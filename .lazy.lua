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
