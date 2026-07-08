return {
	{
		"saghen/blink.cmp",
		desc = "Text completion engine",
		version = "*",
		opts = {
			keymap = {
				preset = "default",
				["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
				["<C-n>"] = {
					"select_next",
					function()
						return require("sidekick").nes_jump_or_apply()
					end,
					"fallback",
				},
				["<CR>"] = { "accept", "fallback" },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
	},
}
