-- Main plugin spec file - loads all individual plugin files
---@param ... table
---@return table
local function flatten_plugins(...)
	local plugins = {}
	for _, plugin_group in ipairs({...}) do
		if type(plugin_group) == "table" then
			-- Check if first element is a string (plugin name) or table (array of plugins)
			if plugin_group[1] and type(plugin_group[1]) == "string" then
				-- Single plugin (first element is the plugin name/path)
				table.insert(plugins, plugin_group)
			elseif plugin_group[1] and type(plugin_group[1]) == "table" then
				-- Array of plugins
				for _, p in ipairs(plugin_group) do
					table.insert(plugins, p)
				end
			else
				-- Single plugin without array structure
				table.insert(plugins, plugin_group)
			end
		end
	end
	return plugins
end

return flatten_plugins(
	require("plugins.colorscheme"),
	require("plugins.git"),
	require("plugins.which-key"),
	require("plugins.treesitter"),
	require("plugins.ui"),
	require("plugins.text-manipulation"),
	require("plugins.navigation"),
	require("plugins.completion"),
	require("plugins.mason"),
	require("plugins.lsp"),
	require("plugins.java"),
	require("plugins.rust"),
	require("plugins.dap"),
	require("plugins.ai-tools")
)
