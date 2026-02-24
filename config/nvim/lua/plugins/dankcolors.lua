return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#13121c',
				base01 = '#13121c',
				base02 = '#99a1a5',
				base03 = '#99a1a5',
				base04 = '#eff9ff',
				base05 = '#f8fcff',
				base06 = '#f8fcff',
				base07 = '#f8fcff',
				base08 = '#ff9ebc',
				base09 = '#ff9ebc',
				base0A = '#91d7ff',
				base0B = '#a4ffaf',
				base0C = '#c4e9ff',
				base0D = '#91d7ff',
				base0E = '#a4deff',
				base0F = '#a4deff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#99a1a5',
				fg = '#f8fcff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#91d7ff',
				fg = '#13121c',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#99a1a5' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#c4e9ff', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#a4deff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#91d7ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#91d7ff',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#c4e9ff',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a4ffaf',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#eff9ff' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#eff9ff' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#99a1a5',
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
