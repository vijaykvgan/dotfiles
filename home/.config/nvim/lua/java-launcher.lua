local M = {}

local settings_path = vim.fn.expand(vim.env.JAVA_LAUNCHER_SETTINGS or "~/.config/java-launcher/settings.lua")
local settings_chunk, settings_error = loadfile(settings_path)
if not settings_chunk then
	error(("Cannot load Java launcher settings %s: %s"):format(settings_path, settings_error))
end

local settings_ok, settings = pcall(settings_chunk)
if not settings_ok then
	error(("Java launcher settings failed: %s"):format(settings))
end
if type(settings) ~= "table" or type(settings.registry_path) ~= "string" then
	error("Java launcher settings must define registry_path")
end

local registry_path = vim.fn.expand(vim.env.JAVA_APP_REGISTRY or settings.registry_path)

local map_fields = {
	env = true,
	environment_properties = true,
	system_properties = true,
}

local function expand_path(path)
	return vim.fs.normalize(vim.fn.expand(path))
end

local function real_path(path)
	return vim.uv.fs_realpath(expand_path(path)) or expand_path(path)
end

local function merge_map(base, overrides)
	local merged = vim.deepcopy(base or {})

	for key, value in pairs(overrides or {}) do
		if value == false then
			merged[key] = nil
		else
			merged[key] = vim.deepcopy(value)
		end
	end

	return merged
end

local function merge_profile(defaults, stage)
	local merged = vim.deepcopy(defaults or {})

	for key, value in pairs(stage or {}) do
		if map_fields[key] then
			merged[key] = merge_map(merged[key], value)
		elseif value == false then
			merged[key] = nil
		else
			merged[key] = vim.deepcopy(value)
		end
	end

	return merged
end

local function load_registry()
	local chunk, load_error = loadfile(registry_path)
	if not chunk then
		error(("Cannot load Java app registry %s: %s"):format(registry_path, load_error))
	end

	local ok, registry = pcall(chunk)
	if not ok then
		error(("Java app registry failed: %s"):format(registry))
	end
	if type(registry) ~= "table" or type(registry.apps) ~= "table" then
		error("Java app registry must return a table containing an 'apps' list")
	end

	return registry
end

local function active_jdtls_root()
	local clients = vim.lsp.get_clients({ bufnr = 0, name = "jdtls" })
	if #clients == 0 then
		error("JDTLS is not attached to the current buffer")
	end

	local root = clients[1].config.root_dir
	if type(root) ~= "string" or root == "" then
		error("The active JDTLS client has no project root")
	end

	return real_path(root)
end

local function matching_profiles(registry, project_root)
	local profiles = {}

	for _, app in ipairs(registry.apps) do
		if type(app.root) ~= "string" then
			error("Every registered Java app must define a root")
		end

		if real_path(app.root) == project_root then
			for stage_name, stage in pairs(app.stages or {}) do
				table.insert(profiles, {
					app = app,
					name = ("%s / %s"):format(app.name or app.project_name or app.main_class, stage_name),
					profile = merge_profile(app.defaults, stage),
					stage = stage_name,
				})
			end
		end
	end

	table.sort(profiles, function(left, right)
		return left.name < right.name
	end)

	return profiles
end

local function java_executable(version)
	if vim.fn.has("macunix") ~= 1 then
		error("java_version resolution is currently supported only on macOS")
	end

	local result = vim.system({ "/usr/libexec/java_home", "-v", tostring(version) }, { text = true }):wait()
	if result.code ~= 0 then
		error(("Java %s is not installed: %s"):format(version, vim.trim(result.stderr or "")))
	end

	return vim.fs.joinpath(vim.trim(result.stdout), "bin", "java")
end

local function parse_env_file(path)
	if not path then
		return {}
	end

	path = expand_path(path)
	local file, open_error = io.open(path, "r")
	if not file then
		error(("Cannot read envFile %s: %s"):format(path, open_error))
	end

	local values = {}
	for line in file:lines() do
		line = vim.trim(line)
		if line ~= "" and not line:match("^#") then
			line = line:gsub("^export%s+", "")
			local key, value = line:match("^([%a_][%w_]*)=(.*)$")
			if not key then
				file:close()
				error(("Invalid envFile entry in %s: %s"):format(path, line))
			end

			value = vim.trim(value)
			local quote = value:sub(1, 1)
			if (#value >= 2 and quote == '"' and value:sub(-1) == '"')
				or (#value >= 2 and quote == "'" and value:sub(-1) == "'")
			then
				value = value:sub(2, -2)
			end
			values[key] = value
		end
	end
	file:close()

	return values
end

local function command_line_argument(value)
	value = tostring(value)
	if value:find('[%s"]') then
		return '"' .. value:gsub("\\", "\\\\"):gsub('"', '\\"') .. '"'
	end
	return value
end

local function system_property_arguments(properties)
	local keys = vim.tbl_keys(properties or {})
	table.sort(keys)

	local arguments = {}
	for _, key in ipairs(keys) do
		local value = properties[key]
		local argument = value == true and ("-D%s"):format(key) or ("-D%s=%s"):format(key, value)
		table.insert(arguments, command_line_argument(argument))
	end

	return arguments
end

local function resolve_environment_properties(profile, env_file_values)
	local properties = vim.deepcopy(profile.system_properties or {})

	for property, variable in pairs(profile.environment_properties or {}) do
		local value = (profile.env or {})[variable] or env_file_values[variable] or os.getenv(variable)
		if not value or value == "" then
			error(("Missing %s for Java system property %s"):format(variable, property))
		end
		properties[property] = value
	end

	return properties
end

local function build_configuration(selected, no_debug)
	local app = selected.app
	local profile = selected.profile
	local env_file = profile.env_file and expand_path(profile.env_file) or nil
	local env_file_values = parse_env_file(env_file)
	local properties = resolve_environment_properties(profile, env_file_values)
	local vm_arguments = vim.deepcopy(profile.jvm_options or {})
	vim.list_extend(vm_arguments, system_property_arguments(properties))

	local program_arguments = {}
	for _, argument in ipairs(profile.program_args or {}) do
		table.insert(program_arguments, command_line_argument(argument))
	end

	return {
		args = table.concat(program_arguments, " "),
		cwd = expand_path(profile.cwd or app.root),
		env = vim.deepcopy(profile.env or {}),
		envFile = env_file,
		javaExec = java_executable(profile.java_version or app.java_version),
		mainClass = assert(app.main_class, "Registered Java app is missing main_class"),
		name = selected.name,
		noDebug = no_debug,
		projectName = assert(app.project_name, "Registered Java app is missing project_name"),
		request = "launch",
		type = "java",
		vmArgs = table.concat(vm_arguments, " "),
	}
end

local function notify_error(message)
	vim.notify(tostring(message), vim.log.levels.ERROR, { title = "Java launcher" })
end

local function launch(no_debug)
	local ok, profiles = pcall(function()
		return matching_profiles(load_registry(), active_jdtls_root())
	end)
	if not ok then
		notify_error(profiles)
		return
	end
	if #profiles == 0 then
		notify_error("No registered Java app matches the active JDTLS project")
		return
	end

	vim.ui.select(profiles, {
		format_item = function(item)
			return item.name
		end,
		prompt = no_debug and "Run Java profile" or "Debug Java profile",
	}, function(selected)
		if not selected then
			return
		end

		local built, config = pcall(build_configuration, selected, no_debug)
		if not built then
			notify_error(config)
			return
		end

		require("dap").run(config)
	end)
end

function M.run()
	launch(true)
end

function M.debug()
	launch(false)
end

M._test = {
	build_configuration = build_configuration,
	matching_profiles = matching_profiles,
	merge_profile = merge_profile,
}

return M
