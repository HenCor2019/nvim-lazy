-- require("dap-vscode-js").setup({
-- 	debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
-- 	debugger_cmd = { "js-debug-adapter" },
-- 	adapters = { "pwa-node", "pwa-chrome", "node-terminal" },
-- })
-- require("dap-vscode-js").setup({
-- 	-- node_path = "node",                                                          -- Path of node executable. Defaults to $NODE_PATH, and then "node"
-- 	debugger_path = os.getenv("HOME") .. "/.local/share/nvim/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
-- 	-- debugger_cmd = { "extension" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
-- 	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
-- 	-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
-- 	-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
-- 	-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
-- })

-- require("dap").adapters["pwa-node"] = {
-- 	type = "server",
-- 	host = "localhost",
-- 	port = "${port}",
-- 	executable = {
-- 		command = "node",
-- 		-- 💀 Make sure to update this path to point to your installation
-- 		args = { "~/js-debug/src/dapDebugServer.js", "${port}" },
-- 	},
-- }

require("dap").adapters.node2 = {
	type = "executable",
	command = "node",
	-- args = { vim.fn.stdpath("data") .. "/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js" },
	args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
	-- 	debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
}

for _, language in ipairs({ "typescript", "javascript" }) do
	require("dap").configurations[language] = {
		{
			name = "Launch",
			type = "node2",
			request = "launch",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			console = "integratedTerminal",
		},
		{
			-- For this to work you need to make sure the node process is started with the `--inspect` flag.
			name = "Attach to process",
			type = "node2",
			request = "attach",
			processId = require("dap.utils").pick_process,
		},
	}
end

-- for _, language in ipairs({ "typescript", "javascript" }) do
-- 	require("dap").configurations[language] = {
-- 		{
-- 			type = "pwa-node",
-- 			request = "launch",
-- 			name = "Launch file",
-- 			program = "${file}",
-- 			cwd = "${workspaceFolder}",
-- 		},
-- 		{
-- 			type = "pwa-node",
-- 			request = "attach",
-- 			name = "Attach",
-- 			-- processId = require("dap.utils").pick_process,
-- 			cwd = vim.fn.getcwd(),
-- 			restart = true,
-- 			protocol = "inspector",
-- 			sourceMaps = true,
-- 			skipFiles = { "<node_internals>/**", "node_modules/**" },
-- 			-- runtimeArgs = { "--nolazy", "-r", "ts-node/register" },
-- 			args = { "${workspaceFolder}/src/main.ts" },
-- 		},
-- 	}
-- end

for _, language in ipairs({ "typescriptreact", "javascriptreact" }) do
	require("dap").configurations[language] = {
		{
			type = "pwa-chrome",
			name = "Attach - Remote Debugging",
			request = "attach",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			port = 9229,
			webRoot = "${workspaceFolder}",
		},
		{
			type = "pwa-chrome",
			name = "Launch Chrome",
			request = "launch",
			url = "http://localhost:5001",
			port = 9229,
		},
	}
end
