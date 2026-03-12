return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#091518',
				base01 = '#091518',
				base02 = '#838d88',
				base03 = '#838d88',
				base04 = '#d7e4dd',
				base05 = '#f8fffb',
				base06 = '#f8fffb',
				base07 = '#f8fffb',
				base08 = '#ffbb9f',
				base09 = '#ffbb9f',
				base0A = '#8fefbd',
				base0B = '#a5ffa8',
				base0C = '#c8ffe2',
				base0D = '#8fefbd',
				base0E = '#aaffd2',
				base0F = '#aaffd2',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#838d88',
				fg = '#f8fffb',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#8fefbd',
				fg = '#091518',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#838d88' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#c8ffe2', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#aaffd2',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#8fefbd',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#8fefbd',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#c8ffe2',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a5ffa8',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#d7e4dd' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#d7e4dd' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#838d88',
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
