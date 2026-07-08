return {
	{
		"lewis6991/gitsigns.nvim",
		desc = "Git signs in the gutter",
		opts = {
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = false, -- Show blame in status bar only, not at end of line
				delay = 500,
			},
		},
	},
	{
		"tpope/vim-fugitive",
		desc = "Git commands in Neovim",
		keys = {
			{ "<leader>gs", "<cmd>Git<cr>", desc = "Fugitive status" },
		},
	},
	{
		"kdheepak/lazygit.nvim",
		desc = "Git interface in terminal",
		cmd = "LazyGit",
	},
}
