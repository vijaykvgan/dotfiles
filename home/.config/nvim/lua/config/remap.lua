vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Go to nvmrc / dir view" })
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
vim.keymap.set({"n", "v"}, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })
vim.keymap.set({"n", "v"}, "<leader>P", [["+P]], { desc = "Paste before from system clipboard" })
vim.keymap.set({"n", "v"}, "<leader>d", [["+d]], { desc = "Cut to system clipboard" })
vim.keymap.set({"n", "v"}, "<leader>D", [["+D]], { desc = "Cut to EOL to clipboard" })

vim.keymap.set("n", "<leader>tr", "<cmd>set rnu!<cr>", { desc = "Toggle Relative Number" })
vim.keymap.set("n", "<leader>tw", "<cmd>set wrap!<cr>", { desc = "Toggle Wrap" })
vim.keymap.set("n", "<leader>th", "<cmd>set hlsearch!<cr>", { desc = "Toggle search highlights" })

-- Undotree (configured in navigation.lua plugin setup)
-- <leader>u - Toggle Undotree

-- Interactive search and replace
local function search_and_replace(use_selection)
	local pattern
	if use_selection then
		-- Get visually selected text
		vim.cmd('noau normal! "vy')
		pattern = vim.fn.getreg("v")
	else local ok, input = pcall(vim.fn.input, "Search: ") if not ok or input == "" then return end pattern = input end
	if pattern == "" then
		return
	end
	local ok, replacement = pcall(vim.fn.input, "Replace '" .. pattern .. "' with: ")
	if not ok then
		return
	end
	local success = pcall(vim.cmd, "%s/" .. vim.fn.escape(pattern, "/") .. "/" .. vim.fn.escape(replacement, "/") .. "/gc")
	if not success then
		vim.notify("No matches found", vim.log.levels.WARN)
	end
end

vim.keymap.set("n", "<leader>sr", function()
	search_and_replace(false)
end, { desc = "Search and replace (interactive)" })

vim.keymap.set("v", "<leader>sr", function()
	search_and_replace(true)
end, { desc = "Search and replace selection" })

vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnostics list" })

-- Alternative resize keybindings (more reliable on macOS)
vim.keymap.set("n", "<leader>w<Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
vim.keymap.set("n", "<leader>w<Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })
vim.keymap.set("n", "<leader>w<Up>", "<cmd>resize +2<cr>", { desc = "Increase height" })
vim.keymap.set("n", "<leader>w<Down>", "<cmd>resize -2<cr>", { desc = "Decrease height" })

-- Window resizing (Ctrl+Shift)
vim.keymap.set("n", "<C-S-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
vim.keymap.set("n", "<C-S-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })
vim.keymap.set("n", "<C-S-j>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
vim.keymap.set("n", "<C-S-k>", "<cmd>resize +2<cr>", { desc = "Increase height" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Snacks Picker    
vim.keymap.set("n", "<leader>ff", function() require("snacks").picker.files() end, { desc = "Find Files" })
vim.keymap.set({"n", "v"}, "<leader>fg", function() require("snacks").picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>fb", function() require("snacks").picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fr", function() require("snacks").picker.recent() end, { desc = "Recent Files" })
vim.keymap.set("n", "<leader>fw", function() require("snacks").picker.grep_word() end, { desc = "Grep Word" })

-- Harpoon
local harpoon = require("harpoon")

-- Helper function to setup delete keybinding in harpoon menu
local function setup_harpoon_delete()
	vim.defer_fn(function()
		local bufnr = vim.api.nvim_get_current_buf()
		vim.keymap.set("n", "d", function()
			local list = harpoon:list()
			local idx = vim.fn.line(".") - 1  -- 0-indexed
			if idx >= 0 and idx < list:length() then
				-- Remove the item
				list:remove_at(idx + 1)  -- 1-indexed
				-- Close and reopen menu to refresh
				vim.cmd("close")
				vim.defer_fn(function()
					harpoon.ui:toggle_quick_menu(list)
					setup_harpoon_delete()  -- Re-setup delete keybinding
				end, 10)
			end
		end, { buffer = bufnr, desc = "Delete from harpoon" })
	end, 50)
end

vim.keymap.set("n", "<leader>ah", function() harpoon:list():add() end, { desc = "Harpoon add file" })
vim.keymap.set("n", "<leader>ar", function() harpoon:list():remove() end, { desc = "Harpoon remove file" })
vim.keymap.set("n", "<C-e>", function()
	local list = harpoon:list()
	harpoon.ui:toggle_quick_menu(list)
	setup_harpoon_delete()
end, { desc = "Harpoon menu" })
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })

-- Gitsigns
local gs = require("gitsigns")
vim.keymap.set("n", "]c", gs.next_hunk, { desc = "Next git change" })
vim.keymap.set("n", "[c", gs.prev_hunk, { desc = "Prev git change" })
vim.keymap.set("n", "<leader>ph", gs.preview_hunk, { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>pr", gs.reset_hunk, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>pb", gs.blame_line, { desc = "Blame line" })

-- DAP (Debugger) - Simple workflow:
-- 1. Set breakpoint (<leader>b)
-- 2. Start debugging (F5)
-- 3. Step through code (F7=over/F8=into)
-- 4. Stop debugging (F6)
local dap = require("dap")
local dapui = require("dapui")

-- Essential keymaps only
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue" })
vim.keymap.set("n", "<F6>", dap.terminate, { desc = "Stop" })
vim.keymap.set("n", "<F7>", dap.step_over, { desc = "Step Over" })
vim.keymap.set("n", "<F8>", dap.step_into, { desc = "Step Into" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle UI" })
vim.keymap.set("n", "<leader>dc", function()
	dap.goto_()
	vim.cmd("normal! zz")  -- Center screen on cursor
end, { desc = "Go to current debug line" })
vim.keymap.set("n", "<leader>ds", function()
	-- Open telescope picker for stack frames if available, otherwise use builtin
	local ok, telescope = pcall(require, "telescope")
	if ok then
		require('telescope').extensions.dap.frames()
	else
		dapui.float_element('stacks', { enter = true })
	end
end, { desc = "Show call stack" })
vim.keymap.set("n", "<leader>db", function()
	dap.list_breakpoints()
	vim.cmd("copen")
end, { desc = "List all breakpoints" })
vim.keymap.set("n", "<leader>dl", "<cmd>DapShowLog<cr>", { desc = "Show debug log" })
vim.keymap.set("n", "<leader>dL", function()
	require('dapui').float_element('console', { width = 200, height = 50, enter = true })
end, { desc = "DAP Logs (fullscreen)" })

-- Git
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
-- Fugitive: <leader>gs - Git status (configured in git.lua)

-- Sidekick AI (Cursor is the default CLI)
local sidekick = setmetatable({}, {
	__index = function(_, method)
		return function(opts)
			local cli = require("sidekick.cli")
			if type(opts) == "string" then
				return cli[method]({ name = "cursor", msg = opts })
			end
			opts = vim.tbl_extend("force", { name = "cursor" }, opts or {})
			return cli[method](opts)
		end
	end,
})

vim.keymap.set("n", "<C-n>", function()
	if not require("sidekick").nes_jump_or_apply() then
		return "<C-n>"
	end
end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })
vim.keymap.set({ "n", "t", "i", "x" }, "<c-.>", function()
	sidekick.focus()
end, { desc = "Sidekick Focus" })
vim.keymap.set("n", "<leader>aa", function()
	sidekick.toggle({ focus = true })
end, { desc = "Sidekick Toggle Cursor" })
vim.keymap.set("n", "<leader>as", function()
	require("sidekick.cli").select()
end, { desc = "Select CLI" })
vim.keymap.set("n", "<leader>ad", function()
	sidekick.close()
end, { desc = "Detach CLI Session" })
vim.keymap.set({ "x", "n" }, "<leader>at", function()
	sidekick.send({ msg = "{this}" })
end, { desc = "Send This" })
vim.keymap.set("n", "<leader>af", function()
	sidekick.send({ msg = "{file}" })
end, { desc = "Send File" })
vim.keymap.set("x", "<leader>av", function()
	sidekick.send({ msg = "{selection}" })
end, { desc = "Send Visual Selection" })
vim.keymap.set({ "n", "x" }, "<leader>ap", function()
	sidekick.prompt()
end, { desc = "Sidekick Select Prompt" })

-- LSP keymaps
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })

-- Java keymaps (configured in plugins/java.lua, buffer-local for .java files)
-- <leader>jt - Test current method
-- <leader>jT - Test current class
-- <leader>jdt - Debug test method
-- <leader>jdT - Debug test class
-- <leader>jr - Run main
-- <leader>jR - Run registered app profile
-- <leader>jD - Debug registered app profile
-- <leader>js - Stop main
-- <leader>jl - Toggle logs
-- <leader>jc - Refresh DAP config

-- Maven keymaps (configured in plugins/java.lua via lazy `keys` spec)
-- <leader>Mm - Maven projects
-- <leader>Mf - Maven favorites

-- Rust keymaps (configured in plugins/rust.lua, buffer-local for .rs files)
-- <leader>rr - Runnables (cargo targets)
-- <leader>rd - Debuggables (via codelldb)
-- <leader>re - Expand macro under cursor
-- <leader>rc - Open Cargo.toml
-- <leader>rp - Jump to parent module
-- K         - Rust hover actions (overrides global K hover for .rs buffers)

-- Formatting (configured in plugins/text-manipulation.lua via lazy `keys` spec)
-- <leader>bf - Format buffer (normal) / Format selection via LSP (visual)

-- Text manipulation (configured in plugins/text-manipulation.lua)
-- J     - Treesj toggle (split/join code blocks)
-- <C-a> - dial.nvim increment
-- <C-x> - dial.nvim decrement
