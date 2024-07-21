local lualine = require('lualine')

lualine.setup {
	options = {
		icons_enabled = true,
		theme = 'base16',
		globalstatus = true,
		component_separators = '|',
		section_separators = '',
	},
	sections = {
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = {
			{
				'filename',
				file_status = true,
				path = 1
			},
		},
		lualine_x = {
			{
				'lsp_progress',
				display_components = { { 'title', 'message' } },
			},
		},
		lualine_y = { 'encoding', 'fileformat', 'filetype', 'progress' },
		-- lualine_z = { "os.date('%d %b')", "os.date('%H:%M')" }
		lualine_z = { 'location' }
	},
}
