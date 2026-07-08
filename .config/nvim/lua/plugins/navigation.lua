return {
	{
		"folke/snacks.nvim",
		desc = "File explorer and picker interface",
		priority = 1000,
		lazy = false,
		opts = {
		picker = {
			sources = {
				explorer = { hidden = false, ignored = true, follow = true, },
			},
		},
		explorer = {
			replace_netrw = true,
		},
		bigfile = {},
	},
		keys = {
			{ "<leader>e", function() require("snacks").explorer() end, desc = "File Explorer" },
		},
	},
	{
		"ThePrimeagen/harpoon",
		desc = "Quick file navigation and marking",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		opts = {},
	},
	{
		"mbbill/undotree",
		desc = "Visual undo history tree",
		keys = {
			{ "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" },
		},
		config = function()
			-- Focus the undotree window when toggled
			vim.g.undotree_SetFocusWhenToggle = 1
			-- Use shorter timestamps
			vim.g.undotree_ShortIndicators = 1
			-- Window layout (style 2 = tree on left, diff on bottom)
			vim.g.undotree_WindowLayout = 2
		end,
	},
}
