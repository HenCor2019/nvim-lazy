return {
  mason = {
    enable = true,
    auto_install = false,
  },
  servers = {
    gopls = { enable = true },
    jsonls = { enable = true },
    lua_ls = { enable = true, neodev = true },
    nil_ls = { enable = true },
    tsserver = { enable = true },
  },
  default_options = function (options)
    return vim.tbl_deep_extend("force", {
      on_attach = require"hencor.lsp.attach",
      flags = require "hencor.lsp.flags",
    }, options)
  end,
}
