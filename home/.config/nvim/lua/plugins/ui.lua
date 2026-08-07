return {
	{ "stevearc/dressing.nvim", desc = "Better UI for vim.ui interfaces", event = "VeryLazy" },
	{ "dstein64/vim-startuptime", desc = "Diagnose startup time using :StartupTime", cmd = "StartupTime" },
	{
		"folke/noice.nvim",
		desc = "Floating pop ups and command line",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		desc = "Status line at bottom",
		dependencies = { "nvim-tree/nvim-web-devicons", "lewis6991/gitsigns.nvim" },
		opts = {
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = {
					"location",
					{
						function()
							local blame = vim.b.gitsigns_blame_line or ""
							if #blame > 50 then
								return blame:sub(1, 47) .. "..."
							end
							return blame
						end,
						cond = function()
							return vim.b.gitsigns_blame_line ~= nil and vim.b.gitsigns_blame_line ~= ""
						end,
						color = { fg = "#000000" },
					},
				},
			},
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		desc = "Indentation guides for code",
		main = "ibl",
		opts = {
			exclude = {
				filetypes = {
					"yaml",
				}
			},
		},
	},
}
