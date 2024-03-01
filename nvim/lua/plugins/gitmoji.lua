return {
	"Dynge/gitmoji.nvim",
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	opts = {},
	ft = "gitcommit",
	config = function()
		require("hencor.gitmoji")
	end,
}
