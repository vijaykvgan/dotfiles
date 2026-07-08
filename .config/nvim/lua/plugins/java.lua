return {
	{
		'nvim-java/nvim-java',
		dependencies = {
			'mfussenegger/nvim-dap',
		},
		config = function()
			require('java').setup({
				java_debug_adapter = { enable = true },
				java_test = { enable = true },
			})
			vim.lsp.enable('jdtls')
			-- Java-specific keybindings using nvim-java's built-in commands
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function(args)
					local opts = { buffer = args.buf }
					-- Test commands
					vim.keymap.set("n", "<leader>jt", "<cmd>JavaTestRunCurrentMethod<cr>",
					vim.tbl_extend("force", opts, { desc = "Java: Test current method" }))
					vim.keymap.set("n", "<leader>jT", "<cmd>JavaTestRunCurrentClass<cr>",
					vim.tbl_extend("force", opts, { desc = "Java: Test current class" }))
					vim.keymap.set("n", "<leader>jdt", "<cmd>JavaTestDebugCurrentMethod<cr>",
					vim.tbl_extend("force", opts, { desc = "Java: Debug test method" }))
					vim.keymap.set("n", "<leader>jdT", "<cmd>JavaTestDebugCurrentClass<cr>",
					vim.tbl_extend("force", opts, { desc = "Java: Debug test class" }))
					-- Runner commands
					vim.keymap.set("n", "<leader>jr", "<cmd>JavaRunnerRunMain<cr>",
					vim.tbl_extend("force", opts, { desc = "Java: Run main" }))
					vim.keymap.set("n", "<leader>js", "<cmd>JavaRunnerStopMain<cr>",
					vim.tbl_extend("force", opts, { desc = "Java: Stop main" }))
					vim.keymap.set("n", "<leader>jl", "<cmd>JavaRunnerToggleLogs<cr>",
					vim.tbl_extend("force", opts, { desc = "Java: Toggle logs" }))
					-- DAP config refresh
					vim.keymap.set("n", "<leader>jc", "<cmd>JavaDapConfig<cr>",
					vim.tbl_extend("force", opts, { desc = "Java: Refresh DAP config" }))
				end,
			})
		end,
	},
	{
		"oclay1st/maven.nvim",
		desc = "Run Maven commands from Neovim",
		cmd = { "Maven", "MavenInit", "MavenExec", "MavenFavorites" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {},
		keys = {
			{ "<leader>M", desc = "+Maven", mode = { "n", "v" } },
			{ "<leader>Mm", "<cmd>Maven<cr>", desc = "Maven projects" },
			{ "<leader>Mf", "<cmd>MavenFavorites<cr>", desc = "Maven favorites" },
		},
	},
}
