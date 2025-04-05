return {
  "olimorris/codecompanion.nvim",
  config = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    adapters = {
      anthropic = function()
        return require("codecompanion.adapters").extend("anthropic", {
          schema = {
            model = {
              default = "claude-3-5-sonnet-20241022",
            },
          },
        })
      end,
    },
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
        adapter = "anthropic",
      },
      inline = {
        adapter = "anthropic",
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
    {
      "<leader>a",
      "<cmd>CodeCompanionChat Toggle<cr>",
      mode = "n",
      desc = "Toggle AI Chat",
    },
    {
      "<leader>a",
      "<cmd>CodeCompanionChat Add<cr>",
      mode = "v",
      desc = "Add Selection to AI Chat",
    },
    { "<leader>A", ":'<,'>CodeCompanion<cr>", mode = "v", desc = "AI Prompt with Selection" },
    { "<leader>A", "<cmd>CodeCompanion<cr>", mode = "n", desc = "AI Prompt" },
  },
}
