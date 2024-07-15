local map = vim.keymap.set
local tb = require("telescope.builtin")
local cursor = require("telescope.themes").get_cursor({})

require("telescope").setup({
	defaults = {
		-- sorting_strategy = "ascending",
		mappings = {
			i = {
				["<esc>"] = require("telescope.actions").close,
			},
		},
		layout_config = {
			horizontal = {
				-- prompt_position = "top",
				width = 0.99,
				height = 0.99,
				preview_width = 0.6,
				preview_cutoff = 0,
			},
		},
	},
	pickers = {
		find_files = {
			find_command = {
				"rg",
				"--files",
			}
		},
	},
	extensions = {
		["ui-select"] = {
			cursor
		}
	}
})

-- File pickers
map("n", "<leader>f", tb.find_files, { desc = "List [f]iles", noremap = true })
map("n", "<leader>g", tb.git_files, { desc = "List [g]it files", noremap = true })
map("n", "<leader>b", tb.buffers, { desc = "List open [b]uffers" })

-- Search
map("n", "<leader>/", tb.live_grep, { desc = "[<leader>/] Fuzzily search in current workspace" })

-- LSP
map("n", "<leader>s", tb.lsp_document_symbols, { desc = "List document [s]ymbols" })
map("n", "<leader>S", tb.lsp_dynamic_workspace_symbols, { desc = "List workspace [S]ymbols" })

-- Helix-like Goto Mode
map({ "n", "v" }, "gy", tb.lsp_type_definitions, { desc = "[g]oto type definition [y]" })
map({ "n", "v" }, "gr", tb.lsp_references, { desc = "[g]oto [r]eferences" })
map({ "n", "v" }, "gi", tb.lsp_implementations, { desc = "[g]oto [i]mplementation" })
map({ "n", "v" }, "gd", tb.lsp_definitions, { desc = "[g]oto [d]eclaration" })

-- Diagnostic
map("n", "<leader>d", function()
	tb.diagnostics({ bufnr = 0 })
end, { desc = "List current buffer [d]iagnostics" })
map("n", "<leader>D", tb.diagnostics, { desc = "List workspace [d]iagnostics" })


pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
