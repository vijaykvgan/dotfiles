-- Numbered lines
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indentation (LazyVim default is 2)
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Performance & Responsiveness
vim.opt.updatetime = 50        -- Default is 200ms
vim.opt.timeoutlen = 300       -- Default is 1000ms - reduces lag when pressing leader key

-- UI Customization
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "80"
vim.opt.wrap = false

-- File Handling & History
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Specialized Path Detection
vim.opt.isfname:append("@-@")

-- Search settings
vim.opt.hlsearch = true  -- Disable search highlighting by default
vim.opt.incsearch = true  -- Still show matches as you type
vim.opt.ignorecase = true  -- Case-insensitive search by default
vim.opt.smartcase = true   -- Case-sensitive if search contains uppercase

-- Using '=' to format the buffer
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
