local mason_lspconfig = require("mason-lspconfig")
local servers = require("hencor.lsp.servers")
local lspconfig = require("lspconfig")

local mason_servers = {
	"clangd",
	"rust_analyzer",
	"pyright",
	"tsserver",
	"gopls",
	"eslint_d",
	"lua_ls",
	"prettierd",
	"node",
	"node-debug2-adapter",
	"golangci-lint",
	"gofumpt",
	"goimports",
	"golines",
	"delve",
}

for server, _ in pairs(servers) do
	local cmd = lspconfig[server].cmd[1]
	if vim.fn.executable(cmd) == 0 then
		table.insert(mason_servers, server)
	end
end

mason_lspconfig.setup({
	ensure_installed = mason_servers,
})

-- filter the list for the ones not globally installed
-- require("mason-tool-installer").setup {
--   ensure_installed = vim.tbl_filter(function (tool)
--     return vim.fn.executable(tool) == 0
--   end, require "alpha.lsp.tools"),
-- }
