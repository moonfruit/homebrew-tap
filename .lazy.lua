local servers = {
  ruby_lsp = {
    capabilities = {
      general = {
        positionEncodings = { "utf-16" },
      },
    },
  },
  rubocop = {
    cmd = { "brew", "rubocop", "--lsp" },
  },
  sorbet = {
    mason = false,
    cmd = { "brew", "typecheck", "--lsp" },
  },
}

local astronvim, _ = pcall(require, "astronvim")

if astronvim then
  ---@type LazySpec
  return {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      servers = {
        "rubocop",
        "sorbet",
      },
      config = servers,
    },
  }
end

---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = servers,
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ruby = {},
      },
    },
  },
}
