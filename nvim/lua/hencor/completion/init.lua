local ok, cmp = pcall(require, "cmp")
if not ok then
	return
end

local lspkind = require("lspkind")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

cmp.setup({
	mapping = {
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.close()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-n>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		-- ["<TAB>"] = cmp.mapping.confirm {
		--     behavior = cmp.ConfirmBehavior.Insert,
		--     select = true,
		-- },
		["<TAB>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				return cmp.confirm({
					behavior = cmp.ConfirmBehavior.Insert,
					select = true,
				})
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<c-space>"] = cmp.mapping.complete(),
	},
	sources = {
		{ name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "copilot" },
		{ name = "gitmoji" },
		{
			name = "buffer",
			keyword_length = 4,
			option = {
				get_bufnrs = function()
					local bufs = {}
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local bufnr = vim.api.nvim_win_get_buf(win)
						if vim.api.nvim_buf_get_option(bufnr, "buftype") ~= "terminal" then
							bufs[bufnr] = true
						end
					end
					return vim.tbl_keys(bufs)
				end,
			},
		},
	},

	formatting = {
		format = lspkind.cmp_format({
			with_text = true,
			menu = {
				buffer = "[buf]",
				nvim_lsp = "[ ]",
				nvim_lua = "[api]",
				path = "[path]",
				copilot = "[ﮧ ]",
			},
		}),
	},

	experimental = {
		native_menu = false,

		ghost_text = true,
	},
})
