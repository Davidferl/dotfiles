-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>o", "o<Esc>", { desc = "Add blank line below" })
vim.keymap.set("n", "<leader>O", "O<Esc>", { desc = "Add blank line above" })

local Snacks = require("snacks")
local copilot_exists = pcall(require, "copilot")

if copilot_exists then
  Snacks.toggle({
    name = "Copilot Completion",
    color = {
      enabled = "green",
      disabled = "orange",
    },
    get = function()
      return not require("copilot.client").is_disabled()
    end,
    set = function(state)
      if state then
        require("copilot.command").enable()
      else
        require("copilot.command").disable()
      end
    end,
  }):map("<leader>ut")
end

vim.keymap.set("n", "<c-/>", function()
  Snacks.terminal(nil, {
    cwd = LazyVim.root(),
    win = {
      position = "bottom",
      height = 0.25,
    },
  })
end, { desc = "Terminal (Root Dir)" })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
