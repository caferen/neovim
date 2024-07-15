-- windows-95 without the ugly parts
require('base16-colorscheme').setup(
	{
		base00 = '#000000',
		base01 = '#1c1c1c',
		base02 = '#383838',
		base03 = '#545454',
		base04 = '#7e7e7e',
		base05 = '#a8a8a8',
		base06 = '#d2d2d2',
		base07 = '#fcfcfc',
		-- base08 = '#fc5454',
		-- base08 = '#d94062',
		base08 = '#f92672',
		-- base09 = '#a85400',
		base09 = '#66d9ef',
		base0A = '#fcfc54',
		base0B = '#54fc54',
		base0C = '#54fcfc',
		-- base0D = '#5454fc',
		base0D = '#f92672',
		base0E = '#fc54fc',
		base0F = '#00a800'
	}
)

local variable = require('base16-colorscheme').colors.base0C

vim.api.nvim_set_hl(0, "@variable", { fg = variable })
vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = variable })

vim.api.nvim_set_hl(0, 'Normal', { guibd = nil })
vim.api.nvim_set_hl(0, 'SignColumn', { guibd = nil })
vim.api.nvim_set_hl(0, 'FoldColumn', { guibd = nil })
vim.api.nvim_set_hl(0, 'LineNr', { guibd = nil })
