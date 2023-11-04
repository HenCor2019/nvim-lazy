local ok, null_ls = pcall(require, "null-ls")

if not ok then
	return
end

local config_cspell = {
  -- The CSpell configuration file can take a few different names this option
  -- lets you specify which name you would like to use when creating a new
  -- config file from within the `Add word to cspell json file` action.
  --
  -- See the currently supported files in https://github.com/davidmh/cspell.nvim/blob/main/lua/cspell/helpers.lua
  config_file_preferred_name = ' ~/.config/cspell.json',

  --- A way to define your own logic to find the CSpell configuration file.
  ---@params cwd The same current working directory defined in the source,
  --             defaulting to vim.loop.cwd()
  ---@return string|nil The path of the json file
  find_json = function(cwd)
  end,

  ---@param cspell string The contents of the CSpell config file
  ---@return table
  encode_json = function(cspell_str)
  end,

  ---@param cspell table A lua table with the CSpell config values
  ---@return string
  encode_json = function(cspell_tbl)
  end,


  --- Callback after a successful execution of a code action.
  ---@param cspell_config_file_path string|nil
  ---@param params GeneratorParams
  ---@action_name 'use_suggestion'|'add_to_json'|'add_to_dictionary'
  on_success = function(cspell_config_file_path, params, action_name)
      -- For example, you can format the cspell config file after you add a word
      if action_name == 'add_to_json' then
          os.execute(
              string.format(
                  "cat %s | jq -S '.words |= sort' | tee %s > /dev/null",
                  cspell_config_file_path,
                  cspell_config_file_path
              )
          )
      end

      -- Note: The cspell_config_file_path param could be nil for the
      -- 'use_suggestion' action
  end
}

local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics

local sources = {
 formatting.prettierd,
 formatting.gofmt,
 diagnostics.cspell.with({ config = config_cspell}),
 diagnostics.golangci_lint,
 diagnostics.cpplint,
 formatting.clang_format,
 code_actions.cspell.with({ config = config_cspell}),
}

local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  })
end

null_ls.setup({
	sources = sources,
    on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                -- vim.lsp.buf.formatting_sync()
                lsp_formatting(bufnr)
            end,
        })
    end
  end,
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	update_in_insert = false,
	virtual_text = { spacing = 2, prefix = "●" },
	severity_sort = true,
})

vim.keymap.set({ "n", "v" }, "<leader>vca", vim.lsp.buf.code_action, {desc = "LSP (null ls) Code actions"})
vim.keymap.set("n", "<leader>vf", function()
  return vim.lsp.buf.format { async = true }
end, {desc = "LSP (null ls) Format file"})

-- function to toogle and possible restart it
vim.api.nvim_create_user_command("NullLsToggle", function()
  local sources = vim.tbl_map(function(el)
    return el.name
  end, null_ls.get_sources())
  vim.ui.select(sources, {}, function(selected)
    if not selected then
      return
    end
    null_ls.toggle(selected)
  end)
end, {})

vim.api.nvim_create_user_command(
  'DisableLspFormatting',
  function()
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = 0 })
  end,
  { nargs = 0 }
)
