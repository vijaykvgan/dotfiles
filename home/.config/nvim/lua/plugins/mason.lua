return {
	{
		"williamboman/mason.nvim",
		desc = "Package manager for LSP servers",
		opts = {
			ensure_installed = {
				-- LSP Servers
				"pyright",
				"ruff",                       -- Python linter (LSP)
				"typescript-language-server",
				"eslint-lsp",
				"rust-analyzer",
				"jdtls",
				"clangd",
				"lua-language-server",
				"json-lsp",
				"html-lsp",                   -- HTML
				"css-lsp",                    -- CSS
				"emmet-language-server",      -- Emmet expansions (HTML/CSS/JSX/TSX)
				-- Debug Adapters
				"java-debug-adapter",
				"js-debug-adapter",
				"codelldb",                   -- Rust / C / C++ debugger
				-- Formatters (required for conform.nvim)
				"prettier",                   -- JSON, JS, TS, YAML, HTML, CSS
				"stylua",                     -- Lua
				"black",                      -- Python
				"rustfmt",                    -- Rust
				"google-java-format",         -- Java
				"clang-format",               -- C / C++
			},
			-- Auto-update installed packages
			auto_update = false,
			-- Auto-install on startup
			automatic_installation = true,
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		desc = "Bridge lsp servers and neovim lsp client",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"pyright",
				"ruff",
				"typescript-language-server",
				"eslint",
				"clangd",
				"lua_ls",
				"jsonls",
				"html",
				"cssls",
				"emmet_language_server",
			},
			-- jdtls is managed by nvim-java; rust_analyzer is managed by rustaceanvim
			automatic_enable = { exclude = { "jdtls", "rust_analyzer" } },
		},
	},
}
