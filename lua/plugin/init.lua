if vim.g.vscode then
	return
end

local handle = io.popen("uname")
local kernel = handle:read("a")
handle:close()

require('plugin.telescope')
require('plugin.theme')
require('plugin.cmp')
require('plugin.lsp')
require('plugin.treesitter')
require('plugin.harpoon')

if string.find(kernel, "Linux") then
	require('plugin.ollama')
end

local unhide = true
local lualine_sourced = false
vim.o.showmode = true
vim.wo.number = false
vim.o.relativenumber = false
local function toggle_simple_ui()
	if not lualine_sourced then
		require('plugin.lualine')
		lualine_sourced = true
	end
	require('lualine').hide({ unhide = unhide })
	vim.o.showmode = not unhide
	vim.wo.number = unhide
	vim.o.relativenumber = unhide
	-- if not unhide then
	-- 	vim.o.foldcolumn = '9'
	-- 	vim.o.signcolumn = 'yes:9'
	-- else
	-- 	vim.o.foldcolumn = '0'
	-- 	vim.o.signcolumn = 'yes'
	-- end
	unhide = not unhide
end

vim.keymap.set('n', '<leader>l', toggle_simple_ui)

local path = vim.fn.argv(0)
vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("DirFiles", { clear = true }),
	callback = function()
		if string.len(path) == 0 then
			return
		end

		local is_directory = vim.fn.isdirectory(path) == 1

		if not is_directory then
			local full_path = vim.fn.expand("%:p")
			path = full_path:match("(.*" .. '/' .. ")")
		end

		local git_dir = vim.system({ "git", "rev-parse", "--show-toplevel" }, { cwd = path }):wait().stdout
		git_dir = string.gsub(git_dir, '%s+', '')
		local is_in_git_dir = string.len(git_dir) ~= 0

		if is_in_git_dir then
			require('plugin.git')
		end

		local home_dir = os.getenv('HOME')
		if is_in_git_dir and not is_directory and git_dir ~= home_dir then
			path = git_dir
		end

		vim.api.nvim_set_current_dir(path)
		if is_directory then
			require("telescope.builtin").find_files()
		end
	end
})
