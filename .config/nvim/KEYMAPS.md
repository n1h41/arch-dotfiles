# Neovim Custom Keymaps

| Mode | Key(s)         | Action/Command                                 | Description                        |
|------|----------------|------------------------------------------------|------------------------------------|
| n    | x              | "_x                                            | Delete char without yanking        |
| n    | +              | <C-a>                                          | Increment number                   |
| n    | -              | <C-x>                                          | Decrement number                   |
| n    | <C-a>          | gg<S-v>G                                       | Select all                         |
| n    | te             | :tabedit<CR>                                   | New tab                            |
| n    | <Tab>          | gt                                             | Next tab                           |
| n    | <S-Tab>        | gT                                             | Previous tab                       |
| n    | ss             | :split<Return><C-w>w                           | Horizontal split and move          |
| n    | sv             | :vsplit<Return><C-w>w                          | Vertical split and move            |
| n    | <Space><Space> | <C-w>w                                         | Move to next window                |
| n    | sc             | <C-w>c                                         | Close window                       |
| n    | sh/sk/sj/sl    | <C-w>h/<C-w>k/<C-w>j/<C-w>l                    | Move to window (left/up/down/right)|
| n    | sH/sK/sJ/sL    | <C-w>H/<C-w>K/<C-w>J/<C-w>L                    | Move window (left/up/down/right)   |
| n    | s<left>        | <C-w>>                                         | Resize window (increase width)     |
| n    | s<right>       | <C-w><                                         | Resize window (decrease width)     |
| n    | s<up>          | <C-w>+                                         | Resize window (increase height)    |
| n    | s<down>        | <C-w>-                                         | Resize window (decrease height)    |
| n    | <S-A-f>        | <cmd>lua vim.lsp.buf.format()<CR>              | Format buffer (LSP)                |
| n    | <C-i>          | <C-i>                                          | Jump forward in jumplist           |
| n    | <leader>fn     | :let @+=expand("%:t")<CR>                      | Copy current file name to clipboard|
| n    | <leader>fj     | :.!jq<CR>                                      | Format current line as JSON        |

- `vim.g.mapleader = ' '` sets the leader key to space.
