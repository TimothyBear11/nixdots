return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#0f1415',
				base01 = '#0f1415',
				base02 = '#666b6c',
				base03 = '#666b6c',
				base04 = '#202323',
				base05 = '#b7bebf',
				base06 = '#b7bebf',
				base07 = '#b7bebf',
				base08 = '#c63c56',
				base09 = '#c63c56',
				base0A = '#0b7b8b',
				base0B = '#008c0d',
				base0C = '#4c9099',
				base0D = '#0b7b8b',
				base0E = '#8ec8d0',
				base0F = '#8ec8d0',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#666b6c',
				fg = '#b7bebf',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#0b7b8b',
				fg = '#0f1415',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#666b6c' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#4c9099', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#8ec8d0',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#0b7b8b',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#0b7b8b',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#4c9099',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#008c0d',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#202323' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#202323' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#666b6c',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
