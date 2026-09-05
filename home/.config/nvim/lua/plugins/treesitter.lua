-- Parsers are installed under stdpath("data")/site, not into this repo.
local parsers = {
	"bash",
	"c",
	"cpp",
	"css",
	"html",
	"java",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"rust",
	"tsx",
	"typescript",
	"xml",
	"yaml",
}

-- Filetypes, which do not always match parser names, that get highlighting and
-- indentation turned on. markdown_inline has no filetype; it is injected into markdown.
local filetypes = {
	"bash",
	"c",
	"cpp",
	"css",
	"html",
	"java",
	"javascript",
	"javascriptreact",
	"json",
	"lua",
	"markdown",
	"python",
	"rust",
	"sh",
	"typescript",
	"typescriptreact",
	"xml",
	"yaml",
}

return {
	"nvim-treesitter/nvim-treesitter",
	desc = "Syntax highlighting and parsing",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install(parsers)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = filetypes,
			callback = function()
				-- install() is asynchronous, so a parser added to the list above may
				-- not be on disk the first time its filetype is opened.
				if not pcall(vim.treesitter.start) then
					return
				end
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
