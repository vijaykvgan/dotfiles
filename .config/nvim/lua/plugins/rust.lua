return {
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		desc = "Modern Rust IDE layer (LSP, DAP, runnables, expand macros)",
		lazy = false, -- plugin already lazy-loads via ft
		ft = { "rust" },
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			-- Wire codelldb (installed by Mason) into rustaceanvim so
			-- :RustLsp debuggables uses it automatically.
			local mason_path = vim.fn.stdpath("data") .. "/mason"
			local codelldb_path = mason_path .. "/bin/codelldb"
			local extension_path = mason_path .. "/packages/codelldb/extension/"
			local liblldb_ext = vim.uv.os_uname().sysname == "Darwin" and "liblldb.dylib" or "liblldb.so"
			local liblldb_path = extension_path .. "lldb/lib/" .. liblldb_ext

			vim.g.rustaceanvim = {
				server = {
					default_settings = {
						["rust-analyzer"] = {
							cargo = { allFeatures = true },
							checkOnSave = { command = "clippy" },
							procMacro = { enable = true },
							inlayHints = {
								bindingModeHints = { enable = false },
								chainingHints = { enable = true },
								closingBraceHints = { enable = true, minLines = 25 },
								closureReturnTypeHints = { enable = "never" },
								lifetimeElisionHints = { enable = "never", useParameterNames = false },
								maxLength = 25,
								parameterHints = { enable = true },
								reborrowHints = { enable = "never" },
								renderColons = true,
								typeHints = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
							},
						},
					},
				},
				dap = {
					adapter = {
						type = "server",
						port = "${port}",
						host = "127.0.0.1",
						executable = {
							command = codelldb_path,
							args = { "--liblldb", liblldb_path, "--port", "${port}" },
						},
					},
				},
			}

			-- Rust-specific keybindings
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "rust",
				callback = function(args)
					local opts = { buffer = args.buf, silent = true }
					vim.keymap.set("n", "<leader>rr", "<cmd>RustLsp runnables<cr>",
						vim.tbl_extend("force", opts, { desc = "Rust: Runnables" }))
					vim.keymap.set("n", "<leader>rd", "<cmd>RustLsp debuggables<cr>",
						vim.tbl_extend("force", opts, { desc = "Rust: Debuggables" }))
					vim.keymap.set("n", "<leader>re", "<cmd>RustLsp expandMacro<cr>",
						vim.tbl_extend("force", opts, { desc = "Rust: Expand macro" }))
					vim.keymap.set("n", "<leader>rc", "<cmd>RustLsp openCargo<cr>",
						vim.tbl_extend("force", opts, { desc = "Rust: Open Cargo.toml" }))
					vim.keymap.set("n", "<leader>rp", "<cmd>RustLsp parentModule<cr>",
						vim.tbl_extend("force", opts, { desc = "Rust: Parent module" }))
					vim.keymap.set("n", "K", "<cmd>RustLsp hover actions<cr>",
						vim.tbl_extend("force", opts, { desc = "Rust: Hover actions" }))
				end,
			})
		end,
	},
}
