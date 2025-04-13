if true then
  return {}
end

return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (Root Dir)" },
    { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (Root Dir)" },
  },
}
