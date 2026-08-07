return {
	{
		"Wansmer/treesj",
		desc = "Split and join code blocks",
		keys = { { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" } },
		opts = { use_default_keymaps = false, max_join_length = 150 },
	},
	{
		"monaqa/dial.nvim",
		desc = "Increment and decrement numbers",
		keys = {
			{ "<C-a>", mode = "n" },
			{ "<C-x>", mode = "n" },
		},
	},
	{
		"echasnovski/mini.nvim",
		version = "*",
		desc = "Adds pairing brackets, quotes etc.",
		config = function()
			require("mini.surround").setup()
			require("mini.ai").setup()
		end
	},
	{ "windwp/nvim-autopairs", desc = "Auto pair brackets and quotes", event = "InsertEnter", opts = {} },
	{ "numToStr/Comment.nvim", desc = "Comment and uncomment code", event = "VeryLazy", opts = {} },
	{
		"stevearc/conform.nvim",
		desc = "Code formatter for multiple languages",
		event = { "BufReadPost" },
		cmd = { "ConformInfo" },
		keys = {
			{ "<leader>bf", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
			{
				"<leader>bf",
				function()
					-- Use LSP formatting for range (works for languages with LSP formatters)
					local start_line = vim.fn.line("'<") - 1  -- 0-indexed
					local end_line = vim.fn.line("'>") - 1
					local start_col = vim.fn.col("'<") - 1
					local end_col = vim.fn.col("'>") - 1
					
					vim.lsp.buf.format({
						range = {
							["start"] = { start_line, start_col },
							["end"] = { end_line, end_col },
						},
					})
				end,
				mode = "v",
				desc = "Format selection (LSP)",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				yaml = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				less = { "prettier" },
				markdown = { "prettier" },
				rust = { "rustfmt" },
				java = { "google-java-format" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				["*"] = { "trim_whitespace" },
			},
			-- Ensure formatters are available
			format_on_save = false,
		},
	},
}
