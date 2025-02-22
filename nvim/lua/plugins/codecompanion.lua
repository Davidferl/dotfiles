return {
  "olimorris/codecompanion.nvim",
  config = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    display = {
      chat = {
        window = {
          width = 0.25,
        },
        start_in_insert_mode = true,
      },
    },
    strategies = {
      chat = {
        adapter = "copilot",
      },
      inline = {
        keymaps = {
          accept_change = {
            modes = { n = "ga" },
            description = "Accept the suggested change",
          },
          reject_change = {
            modes = { n = "gr" },
            description = "Reject the suggested change",
          },
        },
      },
    },
  },

  keys = {
    { "<C-a>", "<cmd>CodeCompanionActions<cr>" },
    { "<leader>a", "", desc = "+ai" },
    {
      "<leader>at",
      "<cmd>CodeCompanionChat Toggle<cr>",
      mode = "n",
      desc = "Toggle AI Chat",
    },
    {
      "<leader>aa",
      "<cmd>CodeCompanionChat Add<cr>",
      mode = "v",
      desc = "Add Selection to AI Chat",
    },
    { "<leader>A", ":'<,'>CodeCompanion<cr>", mode = "v", desc = "AI Prompt with Selection" },
    { "<leader>A", "<cmd>CodeCompanion<cr>", mode = "n", desc = "AI Prompt" },
  },
}
