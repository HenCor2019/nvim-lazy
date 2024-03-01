return {
	"olexsmir/gopher.nvim",
	ft = "go",
	config = function(_, opts)
		require("gopher").setup({
			commands = {
				go = "go",
				gomodifytags = "gomodifytags",
				gotests = "~/go/bin/gotests", -- also you can set custom command path
				impl = "impl",
				iferr = "iferr",
			},
		})
	end,
	build = function()
		vim.cmd([[silent! GoInstallDeps]])
	end,
}
