return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", "/home/davidf/.dotfiles/nvim/..markdownlint-cli2.yaml", "--" },
        },
      },
    },
  },
}
