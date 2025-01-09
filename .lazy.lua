return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rubocop = {
          cmd = { "brew", "rubocop", "--lsp" },
        },
        sorbet = {
          cmd = { "brew", "typecheck", "--lsp" },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
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
