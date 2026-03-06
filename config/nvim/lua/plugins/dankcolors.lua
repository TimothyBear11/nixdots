return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#1a1110',
				base01 = '#1a1110',
				base02 = '#9e8d8c',
				base03 = '#9e8d8c',
				base04 = '#ffe8e7',
				base05 = '#fff5f5',
				base06 = '#fff5f5',
				base07 = '#fff5f5',
				base08 = '#ff6b6a',
				base09 = '#ff6b6a',
				base0A = '#ff6156',
				base0B = '#91ff74',
				base0C = '#ffaba5',
				base0D = '#ff6156',
				base0E = '#ff7d74',
				base0F = '#ff7d74',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#9e8d8c',
				fg = '#fff5f5',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#ff6156',
				fg = '#1a1110',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#9e8d8c' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffaba5', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#ff7d74',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#ff6156',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#ff6156',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#ffaba5',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#91ff74',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#ffe8e7' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#ffe8e7' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#9e8d8c',
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
