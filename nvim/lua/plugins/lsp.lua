return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- "jose-elias-alvarez/null-ls.nvim",
		{
			"williamboman/mason.nvim",
			opts = {
				ui = {
					border = "rounded",
				},
				ensure_installed = {
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
					"goimports-reviser",
					"golines",
					"delve",
				},
			},
		},
		"folke/neodev.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	event = "VeryLazy",
	main = "hencor.lsp",
	opts = {
		mason = {
			enable = true,
			auto_install = false,
		},
		servers = {
			tsserver = { enable = true },
			gopls = { enable = true },
		},
	},
}
