local dap, dapui, hydra = require "dap", require "dapui", require "hydra"

-- Setup Virtual Text
require("nvim-dap-virtual-text").setup {}

for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/hencor/dap/configs/*.lua", true)) do
    loadfile(ft_path)()
end

-- Signs
vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "🚫", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "❓", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "💬", texthl = "", linehl = "", numhl = "" })

-- UI structure
dapui.setup {
    icons = { expanded = "▾", collapsed = "▸" },
    layouts = {
        {
            elements = {
                "scopes",
                "breakpoints",
                "stacks",
                "watches",
            },
            size = 80,
            position = "right",
        },
        {
            elements = {
                "repl",
                "console",
            },
            size = 10,
            position = "bottom",
        },
    },
}

-- Events Listeners
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open {}
end

local hint = [[
 Nvim DAP
 _d_: Start/Continue  _j_: StepOver _k_: StepOut _l_: StepInto ^
 _bp_: Toogle Breakpoint  _bc_: Conditional Breakpoint ^
 _?_: log point ^
 _c_: Run To Cursor ^
 _h_: Show information of the variable under the cursor ^
 _x_: Stop Debbuging ^
 ^^                                                      _<Esc>_
]]

hydra {
    name = "dap",
    hint = hint,
    mode = "n",
    config = {
        color = "blue",
        invoke_on_body = true,
        hint = {
            border = "rounded",
            position = "bottom",
        },
    },
    body = "<leader>d",
    heads = {
        { "d",  dap.continue },
        { "bp", dap.toggle_breakpoint },
        { "l",  dap.step_into },
        { "j",  dap.step_over },
        { "k",  dap.step_out },
        { "h",  dapui.eval },
        { "c",  dap.run_to_cursor },
        {
            "bc",
            function()
                vim.ui.input({ prompt = "Condition: " }, function(condition)
                    dap.set_breakpoint(condition)
                end)
            end,
        },
        {
            "?",
            function()
                vim.ui.input({ prompt = "Log: " }, function(log)
                    dap.set_breakpoint(nil, nil, log)
                end)
            end,
        },
        {
            "x",
            function()
                dap.terminate()
                dapui.close {}
                dap.clear_breakpoints()
            end,
        },

        { "<Esc>", nil, { exit = true } },
    },
}
--debugging
-- --
--
-- local ok, dap = pcall(require, "dap")
-- local okdapui, dapui = pcall(require, "dapui")
-- local okdapgo, dap_go = pcall(require, "dap-go")
--
-- if not ok then return end
-- if not okdapui then return end
-- if not okdapgo then return end
--
-- vim.keymap.set("n", "<leader>ds", ":lua require'dap'.continue()<CR>")
-- vim.keymap.set("n", "<F3>", ":lua require'dap'.step_over()<CR>")
-- vim.keymap.set("n", "<F2>", ":lua require'dap'.step_into()<CR>")
-- vim.keymap.set("n", "<F12>", ":lua require'dap'.step_out()<CR>")
-- vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
-- vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
-- vim.keymap.set("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
-- vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
-- vim.keymap.set("n", "<leader>dt", ":lua require'dap-go'.debug_test()<CR>")
-- require("nvim-dap-virtual-text").setup({})
-- -- dap.set_log_level('TRACE')
--
-- dapui.setup({
-- 	icons = { expanded = "▾", collapsed = "▸" },
-- 	layouts = {
-- 		{
-- 			elements = {
-- 				"scopes",
-- 				"breakpoints",
-- 				"stacks",
-- 				"watches",
-- 			},
-- 			size = 80,
-- 			position = "left",
-- 		},
-- 		{
-- 			elements = {
-- 				"repl",
-- 				"console",
-- 			},
-- 			size = 10,
-- 			position = "bottom",
-- 		},
-- 	},
-- })
--
-- dap_go.setup()
--
-- vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
-- vim.fn.sign_define("DapStopped", { text = "➡️", texthl = "", linehl = "", numhl = "" })
-- vim.fn.sign_define("DapBreakpointRejected", { text = "🚫", texthl = "", linehl = "", numhl = "" })
-- vim.fn.sign_define("DapBreakpointCondition", { text = "❓", texthl = "", linehl = "", numhl = "" })
-- vim.fn.sign_define("DapLogPoint", { text = "💬", texthl = "", linehl = "", numhl = "" })
--
-- require("nvim-dap-virtual-text").setup()
--
-- dap.listeners.after.event_initialized["dapui_config"] = function()
--   dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--   dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--   dapui.close()
-- end
--
-- dap.adapters.delve = {
--   type = 'server',
--   port = '${port}',
--   executable = {
--     command = 'dlv',
--     args = {'dap', '-l', '127.0.0.1:${port}'},
--   }
-- }
--
-- -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
-- dap.configurations.go = {
--   {
--     type = "delve",
--     name = "Debug",
--     request = "launch",
--     program = "${file}"
--   },
--   {
--     type = "delve",
--     name = "Debug test", -- configuration for debugging test files
--     request = "launch",
--     mode = "test",
--     program = "${file}"
--   },
--   -- works with go.mod packages and sub packages
--   {
--     type = "delve",
--     name = "Debug test (go.mod)",
--     request = "launch",
--     mode = "test",
--     program = "./${relativeFileDirname}"
--   }
-- }
--
-- dap.adapters.node2 = {
--     type = 'executable',
--     command = 'node',
--     args = { '/home/henryc/.local/share/nvim/mason/packages/js-debug-adapter/js-debug-adapter' },
-- }
--
-- dap.configurations.javascript = {
--     {
--         name = 'Launch',
--         type = 'node2',
--         request = 'launch',
--         program = '${file}',
--         cwd = vim.fn.getcwd(),
--         sourceMaps = true,
--         protocol = 'inspector',
--         console = 'integratedTerminal',
--     },
--     {
--         -- For this to work you need to make sure the node process is started with the `--inspect` flag.
--         name = 'Attach to process',
--         type = 'node2',
--         request = 'attach',
--         processId = require 'dap.utils'.pick_process,
--     },
-- }
--
-- dap.configurations.typescript = {
--     {
--         name = "ts-node (Node2 with ts-node)",
--         type = "node2",
--         request = "attach",
--         cwd = vim.loop.cwd(),
--         args = { "${workspaceFolder}/src/main.ts" },
--         runtimeArgs = { "--nolazy", "-r", "ts-node/register" },
--         runtimeExecutable = "node",
--         sourceMaps = true,
--         port = 9229,
--         protocol = "inspector",
--         skipFiles = { "<node_internals>/**", "node_modules/**" },
--     },
--     {
--         name = "Jest (Node2 with ts-node)",
--         type = "node2",
--         request = "launch",
--         cwd = vim.loop.cwd(),
--         runtimeArgs = { "--inspect-brk", "${workspaceFolder}/node_modules/.bin/jest" },
--         runtimeExecutable = "node",
--         args = { "${file}", "--runInBand", "--coverage", "false" },
--         sourceMaps = true,
--         port = 9229,
--         skipFiles = { "<node_internals>/**", "node_modules/**" },
--     },
-- }
