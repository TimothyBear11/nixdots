return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#22292E',
				base01 = '#22292E',
				base02 = '#99a5a1',
				base03 = '#99a5a1',
				base04 = '#effff9',
				base05 = '#f8fffc',
				base06 = '#f8fffc',
				base07 = '#f8fffc',
				base08 = '#ffbd9f',
				base09 = '#ffbd9f',
				base0A = '#92ffda',
				base0B = '#a5ffa9',
				base0C = '#c5ffeb',
				base0D = '#92ffda',
				base0E = '#a5ffe0',
				base0F = '#a5ffe0',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#99a5a1',
				fg = '#f8fffc',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#92ffda',
				fg = '#22292E',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#99a5a1' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#c5ffeb', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#a5ffe0',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#92ffda',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#92ffda',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#c5ffeb',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a5ffa9',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#effff9' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#effff9' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#99a5a1',
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
