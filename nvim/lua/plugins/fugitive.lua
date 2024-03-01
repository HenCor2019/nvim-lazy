return {
	"tpope/vim-fugitive",
	keys = {
		{ "<leader>ga", ":Git fetch --all -p<cr>", desc = "Git fetch" },
		{ "<leader>gl", ":Git pull<cr>", desc = "Git pull" },
		{ "<leader>gdh", ":diffget //2<cr>", desc = "Git diff grab from left" },
		{ "<leader>gdl", ":diffget //3<cr>", desc = "Git diff grab from right" },
		{ "<leader>gsp", ":Git stash push --include-untracked<cr>", desc = "Git stash push with no tracked files" },
		{ "<leader>gsP", ":Git stash pop<cr>", desc = "Git stash pop with no tracked files" },
	},
	cmd = { "G", "Git" },
}
