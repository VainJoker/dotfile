local telescope = require("telescope")
telescope.setup({
	defaults = {
		prompt_prefix = " ",
		selection_caret = " ",
		mappings = {
			i = {
				["<c-t>"] = function(...)
					return require("trouble.providers.telescope").open_with_trouble(...)
				end,
				["<a-t>"] = function(...)
					return require("trouble.providers.telescope").open_selected_with_trouble(...)
				end,
				["<a-i>"] = function()
					local action_state = require("telescope.actions.state")
					local line = action_state.get_current_line()
					Util.telescope("find_files", { no_ignore = true, default_text = line })()
				end,
				["<a-h>"] = function()
					local action_state = require("telescope.actions.state")
					local line = action_state.get_current_line()
					Util.telescope("find_files", { hidden = true, default_text = line })()
				end,
				["<C-Down>"] = function(...)
					return require("telescope.actions").cycle_history_next(...)
				end,
				["<C-Up>"] = function(...)
					return require("telescope.actions").cycle_history_prev(...)
				end,
				["<C-f>"] = function(...)
					return require("telescope.actions").preview_scrolling_down(...)
				end,
				["<C-b>"] = function(...)
					return require("telescope.actions").preview_scrolling_up(...)
				end,
			},
			n = {
				["q"] = function(...)
					return require("telescope.actions").close(...)
				end,
			},
		},
	},
})
