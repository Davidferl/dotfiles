# dotfiles

```
stow --no-folding .
```

## Prerequisites

Most config is managed via [mise](https://mise.jdx.dev) (`mise install`), but a
few things aren't installable that way:

- **Fonts**: install `Monaspace Argon NF` (ghostty) and a Nerd Font for the
  icon glyphs used by eza/starship/lualine.
- **Linux clipboard**: nvim uses `clipboard = unnamedplus`. For system-clipboard
  yank/paste you need a provider - `wl-clipboard` (Wayland) or `xclip`/`xsel`
  (X11). Built in on macOS, so nothing to install there.
