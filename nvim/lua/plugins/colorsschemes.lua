return {
  {
    "vague2k/vague.nvim",
    config = function()
      require("vague").setup({
        -- optional configuration here
      })
    end,
  },
  {
    "EdenEast/nightfox.nvim",
  },
  {
    "doums/darcula",
  },
  {
    "aliqyan-21/darkvoid.nvim",
  },
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nordic").load()
    end,
  },
}
