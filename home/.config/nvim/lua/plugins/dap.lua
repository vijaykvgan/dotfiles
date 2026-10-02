return {
	{
		"mfussenegger/nvim-dap",
		desc = "Debug adapter protocol for debugging",
		event = "VeryLazy",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()
			require("nvim-dap-virtual-text").setup()

			dap.set_log_level("WARN")

			-- Default is 30 seconds, increase to 2 minutes for apps with large classpaths
			dap.defaults.fallback.timeout = 120000

			-- Rust / C / C++ debugger (codelldb via Mason)
			local mason_path = vim.fn.stdpath("data") .. "/mason"
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = mason_path .. "/bin/codelldb",
					args = { "--port", "${port}" },
				},
			}

			dap.configurations.rust = {
				{
					name = "Launch (cargo build target)",
					type = "codelldb",
					request = "launch",
					program = function()
						-- Try to auto-detect the debug binary, fall back to prompt
						local cwd = vim.fn.getcwd()
						local default = cwd .. "/target/debug/"
						return vim.fn.input("Path to executable: ", default, "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
			}

			dap.configurations.c = {
				{
					name = "Launch executable",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
			}
			dap.configurations.cpp = dap.configurations.c

			-- Empty configs for UI buffers to prevent errors
			dap.configurations.snacks_picker_list = {}
			dap.configurations.snacks_explorer = {}

			-- Auto open/close UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		desc = "Python debugging support for DAP",
		ft = "python",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dap-python").setup("python")
		end,
	},
	{
		"mxsdev/nvim-dap-vscode-js",
		desc = "JavaScript and TypeScript debugging support",
		dependencies = { "mfussenegger/nvim-dap" },
		lazy = false,
		config = function()
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
			require("dap-vscode-js").setup({
				node_path = "node",
				debugger_path = mason_path .. "/js-debug-adapter",
				adapters = { "pwa-node" },
			})

			local dap = require("dap")
			for _, adapter in pairs({ "pwa-node", "pwa-chrome" }) do
				dap.adapters[adapter] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "js-debug-adapter",
						args = { "${port}" },
					},
				}
			end

			-- Simple configs for Node.js (including React files)
			for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
				dap.configurations[lang] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Debug Current File",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "npm run start:dev",
						runtimeExecutable = "npm",
						runtimeArgs = { "run", "start:dev" },
						cwd = "${workspaceFolder}",
					},
				}
			end
		end,
	}
}
