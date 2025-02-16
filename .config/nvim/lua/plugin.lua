---@diagnostic disable: missing-fields, undefined-field
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings,
  -- LSP
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'glepnir/lspsaga.nvim' },            -- lsp ui
      { 'onsails/lspkind-nvim' },            -- vscode like pictograms
      { 'jose-elias-alvarez/null-ls.nvim' }, -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },
      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    }
  },
  -- Theme
  {
    'svrana/neosolarized.nvim',
    dependencies = { 'tjdevries/colorbuddy.nvim' },
    lazy = true
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
  },
  "nvim-treesitter/nvim-treesitter-context",
  -- Nice to haves
  {
    "numToStr/Comment.nvim",
    config = function()
      require('Comment').setup({
        opleader = {
          block = "<S-A-a>"
        }
      })
    end
  },
  {
    'stevearc/dressing.nvim',
  },
  {
    enabled = true,
    "github/copilot.vim",
  },
  "j-hui/fidget.nvim",
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true,      -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = "󰅒 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󱜾 ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      gui_style = {
        fg = "NONE",                     -- The gui style to use for the fg highlight group.
        bg = "BOLD",                     -- The gui style to use for the bg highlight group.
      },
      merge_keywords = true,             -- when true, custom keywords will be merged with the defaults
      highlight = {
        multiline = true,                -- enable multine todo comments
        multiline_pattern = "^.",        -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 10,          -- extra lines that will be re-evaluated when changing a line
        before = "",                     -- "fg" or "bg" or empty
        keyword = "wide",                -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg",                    -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true,            -- uses treesitter to match keywords in comments only
        max_line_len = 400,              -- ignore lines longer than this
        exclude = {},                    -- list of file types to exclude highlighting
      },
      colors = {
        error = { "#DC2626" },
        warning = { "#FBBF24" },
        info = { "#2563EB" },
        hint = { "#10B981" },
        default = { "#7C3AED" },
        test = { "#FF00FF" }
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      },
    }
  },
  -- Git
  {
    "tpope/vim-fugitive",
    lazy = true,
  },
  {
    "lewis6991/gitsigns.nvim",
  },
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
  },
  -- Statusline
  "nvim-lualine/lualine.nvim",
  -- Buffer
  "akinsho/nvim-bufferline.lua",
  -- Toggleterm
  {
    'akinsho/toggleterm.nvim',
    lazy = true,
    version = "*",
    config = function()
      require("toggleterm").setup(
        {
          size = 10,
          open_mapping = [[<C-\>]],
          hide_numbers = true,
          shade_filetypes = {},
          shade_terminals = true,
          shading_factor = 2,
          start_in_insert = true,
          insert_mappings = true,
          persist_size = true,
          close_on_exit = true,
          direction = 'float',
          float_opts = {
            border = "curved",
            winblend = 0,
            highlights = {
              border = "Normal",
              background = "Normal"
            }
          }
        }
      )
    end,
  },
  -- Autopairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
  -- Highligt Color Codes
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  -- Live Server
  {
    lazy = true,
    'barrett-ruth/live-server.nvim',
    config = function()
      require('live-server').setup()
    end,
  },
  -- Debugger
  {
    lazy = true,
    'mfussenegger/nvim-dap',
    dependencies = {
      'nvim-telescope/telescope-dap.nvim',
      'rcarriga/nvim-dap-ui',
      { "mxsdev/nvim-dap-vscode-js", module = { "dap-vscode-js" } },
      {
        "microsoft/vscode-node-debug2",
        opt = true,
        run = "npm install && npm run build"

      },
      {
        'theHamsta/nvim-dap-virtual-text',
        config = function()
          require('nvim-dap-virtual-text').setup({})
        end
      }
    },
  },
  -- Which key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      notify = false
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  -- Dashboard
  {
    'glepnir/dashboard-nvim',
    event = 'VimEnter',
    dependencies = {
      { 'juansalvatore/git-dashboard-nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
      { 'nvim-tree/nvim-web-devicons' },
    }
  },
  -- Flutter
  {
    'akinsho/flutter-tools.nvim',
    commit = "5aa227fa083fd740184b55b5220dfabc24a25cc7",
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
  },
  -- Flutter Snippets
  "RobertBrunhage/flutter-riverpod-snippets",
  "Neevash/awesome-flutter-snippets",
  -- Color highlight in files
  {
    "mrshmllow/document-color.nvim",
    config = function()
      require("document-color").setup {
        mode = "background", -- background | foreground | single
      }
    end
  },
  -- Golang Debugger
  {
    "leoluz/nvim-dap-go",
    config = function()
      require('dap-go').setup({
        dap_configurations = {
          {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
      })
    end
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },
  -- Database Management
  {
    "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
  },
  {
    'navarasu/onedark.nvim'
  },
  -- Lua
  {
    "folke/zen-mode.nvim",
    opts = {
    }
  },
  -- PGSQL
  { 'lifepillar/pgsql.vim' },
  -- Trouble
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  -- Golang extras
  --[[ {
    "olexsmir/gopher.nvim",
    dependencies = { -- dependencies
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    }
  }, ]]
  -- Neotest
  {
    lazy = true,
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      'sidlatau/neotest-dart',
      "nvim-neotest/neotest-go",
    }
  },
  -- DiffView
  {
    lazy = true,
    "sindrets/diffview.nvim",
    event = "BufRead",
  },
  --- Undotree
  {
    "mbbill/undotree",
  },
  -- Rest client
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
    opts = {
      rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }
    }
  },
  {
    "rest-nvim/rest.nvim",
    ft = "http",
  },
  {
    "ziontee113/color-picker.nvim",
  },
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here
    end
  },
  { "nvim-neotest/nvim-nio" },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      -- { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- other stuff
      background_colour = "#333333"
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
  {
    "nvim-neorg/neorg",
  },
  {
    "vhyrro/luarocks.nvim",
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
      rocks = { "magick" },
    },
  },
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      integrations = {
        neorg = {
          enabled = false,
        }
      }
    },
  },
  -- Git integration (fugitive alternative)
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
      -- "ibhagwan/fzf-lua",            -- optional
    },
    config = true
  },
  ---@module "neominimap.config.meta"
  {
    "Isrothy/neominimap.nvim",
    enabled = true,
    lazy = false, -- NOTE: NO NEED to Lazy load
    -- Optional
    keys = {
      { "<leader>nt",  "<cmd>Neominimap toggle<cr>",      desc = "Toggle minimap" },
      { "<leader>no",  "<cmd>Neominimap on<cr>",          desc = "Enable minimap" },
      { "<leader>nc",  "<cmd>Neominimap off<cr>",         desc = "Disable minimap" },
      { "<leader>nf",  "<cmd>Neominimap focus<cr>",       desc = "Focus on minimap" },
      { "<leader>nu",  "<cmd>Neominimap unfocus<cr>",     desc = "Unfocus minimap" },
      { "<leader>ns",  "<cmd>Neominimap toggleFocus<cr>", desc = "Toggle focus on minimap" },
      { "<leader>nwt", "<cmd>Neominimap winToggle<cr>",   desc = "Toggle minimap for current window" },
      { "<leader>nwr", "<cmd>Neominimap winRefresh<cr>",  desc = "Refresh minimap for current window" },
      { "<leader>nwo", "<cmd>Neominimap winOn<cr>",       desc = "Enable minimap for current window" },
      { "<leader>nwc", "<cmd>Neominimap winOff<cr>",      desc = "Disable minimap for current window" },
      { "<leader>nbt", "<cmd>Neominimap bufToggle<cr>",   desc = "Toggle minimap for current buffer" },
      { "<leader>nbr", "<cmd>Neominimap bufRefresh<cr>",  desc = "Refresh minimap for current buffer" },
      { "<leader>nbo", "<cmd>Neominimap bufOn<cr>",       desc = "Enable minimap for current buffer" },
      { "<leader>nbc", "<cmd>Neominimap bufOff<cr>",      desc = "Disable minimap for current buffer" },
    },
    init = function()
      vim.opt.wrap = false       -- Recommended
      vim.opt.sidescrolloff = 36 -- It's recommended to set a large value
      ---@diagnostic disable-next-line: undefined-doc-name
      ---@type Neominimap.UserConfig
      vim.g.neominimap = {
        auto_enable = false,
      }
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      ui = {
        enable = false,
      },
      workspaces = {
        {
          name = "personal",
          path = "/home/n1h41/Documents/obsidian-vault",
        },
      },

      -- see below for full list of options 👇
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  },
  { "nvzone/showkeys",      cmd = "ShowkeysToggle" },
  -- Custom Parameters (with defaults)
  --[[ {
    "David-Kunz/gen.nvim",
    opts = {
      model = "llama3.2",     -- The default model to use.
      quit_map = "q",         -- set keymap to close the response window
      retry_map = "<c-r>",    -- set keymap to re-send the current prompt
      accept_map = "<c-cr>",  -- set keymap to replace the previous selection with the last result
      host = "localhost",     -- The host running the Ollama service.
      port = "11434",         -- The port on which the Ollama service is listening.
      display_mode = "split", -- The display mode. Can be "float" or "split" or "horizontal-split".
      show_prompt = true,     -- Shows the prompt submitted to Ollama.
      show_model = true,      -- Displays which model you are using at the beginning of your chat session.
      no_auto_close = false,  -- Never closes the window automatically.
      file = false,           -- Write the payload to a temporary file to keep the command short.
      hidden = false,         -- Hide the generation window (if true, will implicitly set `prompt.replace = true`), requires Neovim >= 0.10
      init = function(_) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
      -- Function to initialize Ollama
      command = function(options)
        local body = { model = options.model, stream = true }
        return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
      end,
      -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
      -- This can also be a command string.
      -- The executed command must return a JSON object with { response, context }
      -- (context property is optional).
      -- list_models = '<omitted lua function>', -- Retrieves a list of model names
      debug = false -- Prints errors and the command which is run.
    }
  }, ]]
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      -- add any opts here
      -- for example
      -- provider = "openai",
      -- openai = {
      --   endpoint = "https://api.openai.com/v1",
      --   model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
      --   timeout = 30000,  -- timeout in milliseconds
      --   temperature = 0,  -- adjust if needed
      --   max_tokens = 4096,
      -- },
      provider = "ollama",
      vendors = {
        ollama = {
          __inherited_from = "openai",
          api_key_name = "",
          endpoint = "http://127.0.0.1:11434/api",
          model = "qwen2.5-coder:7b",
          parse_curl_args = function(opts, code_opts)
            return {
              url = opts.endpoint .. "/chat",
              headers = {
                ["Accept"] = "application/json",
                ["Content-Type"] = "application/json",
              },
              body = {
                model = opts.model,
                options = {
                  num_ctx = 16384,
                },
                messages = require("avante.providers").copilot.parse_messages(code_opts), -- you can make your own message, but this is very advanced
                stream = true,
              },
            }
          end,
          parse_stream_data = function(data, handler_opts)
            -- Parse the JSON data
            local json_data = vim.fn.json_decode(data)
            -- Check for stream completion marker first
            if json_data and json_data.done then
              handler_opts.on_complete(nil) -- Properly terminate the stream
              return
            end
            -- Process normal message content
            if json_data and json_data.message and json_data.message.content then
              -- Extract the content from the message
              local content = json_data.message.content
              -- Call the handler with the content
              handler_opts.on_chunk(content)
            end
          end,
        }
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick",         -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua",              -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",        -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      -- this is an example, not a default. Please see the readme for more configuration options
      vim.g.molten_output_win_max_height = 12
    end,
  },
  {
    'goerz/jupytext.nvim',
    version = '0.1',
    opts = {}, -- see Options
  },
  {
    'nvim-java/nvim-java',
    config = function()
      require('java').setup()
    end
  },
  {
    "jackplus-xyz/player-one.nvim",
  }
  -- { "folke/neoconf.nvim" },
  -- LOCAL PLUGIN DEVELOPMENT
  --[[ {
    dir = "~/dev/nvim/n1h41-nvim",
    config = function()
      require('n1h41').setup()
    end
  }, ]]
  --[[ {
    dir = "~/dev/nvim/whether",
    config = function()
      -- require('whether').setup()
    end
  }, ]]
}

require('lazy').setup(plugins, {})
