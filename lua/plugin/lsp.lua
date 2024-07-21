require("neodev").setup()

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-on-attach", { clear = true }),
	callback = function(args)
		local client_id = args.data.client_id
		local client = vim.lsp.get_client_by_id(client_id)
		local bufnr = args.buf

		if not client then
			return
		end

		if client.server_capabilities.documentFormattingProvider and client.name ~= "tsserver" then
			local format = function()
				vim.lsp.buf.format({
					async = false,
					filter = function(c)
						return c.id == client.id
					end,
				})
			end

			vim.api.nvim_create_user_command("Format", format, {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = format
			})
		end

		if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
			vim.lsp.inlay_hint.enable(true)
		end

		if client.server_capabilities.documentHighlightProvider then
			vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
				buffer = bufnr,
				callback = vim.lsp.buf.clear_references
			})
		end
	end,
})

local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local completion = null_ls.builtins.completion

local spell = completion.spell
spell.filetypes = { "text" }
null_ls.setup({
	sources = {
		spell,
		formatting.beautysh,
		formatting.prettier,
	},
})

local servers = {
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
	rust_analyzer = {
		["rust-analyzer"] = {
			check = { command = "clippy" },
		},
	},
	texlab = {
		build = {
			executable = "tectonic",
			args = {
				"-X",
				"compile",
				"%f",
				"--synctex",
				"--keep-logs",
				"--keep-intermediates"
			},
			onSave = true,
		}
	}
}


require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			settings = servers[server_name],
		})
	end,
})
