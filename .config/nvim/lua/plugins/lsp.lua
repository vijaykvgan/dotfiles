return {
	"neovim/nvim-lspconfig",
	desc = "Language server protocol configuration",
	config = function()
		-- Lua
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})

		-- Python (types / intellisense)
		vim.lsp.config("pyright", {
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "basic",
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
					},
				},
			},
		})

		-- Python (linting + fast organize-imports / fixes)
		vim.lsp.config("ruff", {
			-- Let pyright own hover; ruff focuses on lint diagnostics & code actions
			on_attach = function(client, _)
				client.server_capabilities.hoverProvider = false
			end,
		})

		-- JS / TS
		vim.lsp.config("typescript-language-server", {
			cmd = {
				"typescript-language-server",
				"--stdio",
			},
			env = {
				PATH = vim.fn.expand("~/.local/bin") .. ":" .. (vim.env.PATH or ""),
			},
		})

		-- ESLint
		vim.lsp.config("eslint", {
			env = {
				PATH = vim.fn.expand("~/.local/bin") .. ":" .. (vim.env.PATH or ""),
			},
			settings = {
				eslint = {
					workingDirectories = { mode = "auto" },
				},
			},
		})

		-- JSON
		vim.lsp.config("jsonls", {})

		-- HTML
		vim.lsp.config("html", {
			filetypes = { "html", "templ" },
			init_options = {
				configurationSection = { "html", "css", "javascript" },
				embeddedLanguages = { css = true, javascript = true },
				provideFormatter = false, -- prettier handles formatting
			},
		})

		-- CSS
		vim.lsp.config("cssls", {
			settings = {
				css = { validate = true },
				scss = { validate = true },
				less = { validate = true },
			},
		})

		-- C / C++
		vim.lsp.config("clangd", {
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--completion-style=detailed",
				"--header-insertion=iwyu",
			},
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
		})

		-- Emmet (HTML / CSS / JSX / TSX expansions: e.g. `div.foo>ul>li*3`)
		vim.lsp.config("emmet_language_server", {
			filetypes = {
				"html",
				"css",
				"scss",
				"less",
				"sass",
				"javascriptreact",
				"typescriptreact",
				"vue",
				"svelte",
			},
		})

		-- Rust is managed by rustaceanvim (see plugins/rust.lua)
		-- Java is managed by nvim-java (see plugins/java.lua)
	end,
}
