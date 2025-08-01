local dap = require('dap')
local dapui = require('dapui')

dap.defaults.fallback.external_terminal = {
	command = '/usr/bin/kitty',
	args = { '-e' },
}


dap.defaults.fallback.force_external_terminal = true

dap.adapters.dart = {
	type = 'executable',
	command = vim.fn.stdpath('data') .. '/mason/bin/dart-debug-adapter',
	-- command = 'flutter',
	args = { 'flutter' },
	-- args = { "debug_adapter" },
	options = {
		detached = true,
	},
}

dap.adapters.codelldb = {
	type = 'server',
	port = "${port}",
	executable = {
		-- CHANGE THIS to your path!
		-- command = '/absolute/path/to/codelldb/extension/adapter/codelldb',
		command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
		args = { "--port", "${port}" },

		-- On windows you may have to uncomment this:
		-- detached = false,
	}
}

dap.adapters["local-lua"] = {
	type = "executable",
	command = "node",
	args = {
		"~/debuggers/local-lua-debugger-vscode/extension/debugAdapter.js"
	},
	enrich_config = function(config, on_config)
		if not config["extensionPath"] then
			local c = vim.deepcopy(config)
			---@diagnostic disable-next-line: inject-field
			c.extensionPath = "~/debuggers/local-lua-debugger-vscode/extension/debugAdapter.js"
			on_config(c)
		else
			on_config(config)
		end
	end
}

dap.adapters.nlua = function(callback, config)
	callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end

dap.configurations.dart = {
	{
		type = "dart",
		request = "launch",
		name = "Launch flutter",
		dartSdkPath = "/home/nihal/flutter/bin/cache/dart-sdk/",
		flutterSdkPath = "/home/nihal/flutter/",
		program = "${workspaceFolder}/lib/main.dart",
		cwd = "${workspaceFolder}",
		console = 'terminal',
	}
}

dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			-- Run make in the current working directory
			local cwd = vim.fn.getcwd()
			---@diagnostic disable-next-line: undefined-field
			local makefileExists = vim.loop.fs_stat(cwd .. '/Makefile')
			if not makefileExists then
				return vim.fn.input('Path to executable (after make): ', cwd .. '/', 'file')
			end

			-- Run make
			vim.fn.jobwait({ vim.fn.jobstart('make', { cwd = cwd }) })

			-- Parse make file and extract executable name
			local file = io.open(cwd .. '/Makefile', "r")
			if not file then
				return vim.fn.input('Path to executable (after make): ', cwd .. '/', 'file')
			end
			local content = file:read("*a")
			local binaryName = content:match("%.%/(%w+)")
			file:close()

			return binaryName
		end,
		cwd = '${workspaceFolder}',
		stopOnEntry = false
	},
}

dap.configurations.c = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		cwd = '${workspaceFolder}',
		stopOnEntry = false,
	},
}

dap.configurations.lua = {
	{
		type = "nlua",
		request = "attach",
		name = "Attach to running Neovim instance",
	}
}

local dap_breakpoint = {
	error = {
		text = "🔴",
		texthl = "LspDiagnosticsSignError",
		linehl = "",
		numhl = "",
	},
	rejected = {
		text = "🔘",
		texthl = "LspDiagnosticsSignHint",
		linehl = "",
		numhl = "",
	},
	stopped = {
		text = "🟢",
		texthl = "LspDiagnosticsSignInformation",
		linehl = "DiagnosticUnderlineInfo",
		numhl = "LspDiagnosticsSignInformation",
	},
}

vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

dapui.setup()

require("telescope").load_extension("dap")
