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
      ---@diagnostic disable: missing-fields
      config = {
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
          cmd = { "brew", "typecheck", "--lsp" },
        },
      },
    },
  }
end

---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rubocop = {
          cmd = { "brew", "rubocop", "--lsp" },
        },
        sorbet = {
          mason = false,
          cmd = { "brew", "typecheck", "--lsp" },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        rubocop = {
          command = "brew",
          prepend_args = { "rubocop" },
        },
      },
    },
  },
}
