{
  config,
  pkgs,
  ...
}: {
  vim = {
    viAlias = false;
    vimAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    options = {
      shada = "'100,<50,s10,h"; # safe default enabling shada with common parameters
      mouse = "a"; # enable mouse support in all modles
      number = true;
      relativenumber = false;
      clipboard = "unnamedplus";
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      splitright = true;
      splitbelow = true;
      list = true;
      listchars = "tab:» ,trail:·,nbsp:␣";
      inccommand = "split";
      cursorline = true;
      scrolloff = 10;
      confirm = true;
    };

    # Basic keymaps similar to kickstart.nvim
    maps = {
      normal = {
        # Clear search highlights on <Esc>
        "<Esc>" = {
          action = "<cmd>nohlsearch<CR>";
          desc = "Clear search highlights";
        };

        # Diagnostic keymaps
        "<leader>q" = {
          action = "vim.diagnostic.setloclist";
          lua = true;
          desc = "Open diagnostic [Q]uickfix list";
        };

        # Window navigation with Ctrl+hjkl
        "<C-h>" = {
          action = "<C-w><C-h>";
          desc = "Move focus to the left window";
        };
        "<C-l>" = {
          action = "<C-w><C-l>";
          desc = "Move focus to the right window";
        };
        "<C-j>" = {
          action = "<C-w><C-j>";
          desc = "Move focus to the lower window";
        };
        "<C-k>" = {
          action = "<C-w><C-k>";
          desc = "Move focus to the upper window";
        };

        # Telescope keymaps
        "<leader>sh" = {
          action = "<cmd>Telescope help_tags<CR>";
          desc = "[S]earch [H]elp";
        };
        "<leader>sk" = {
          action = "<cmd>Telescope keymaps<CR>";
          desc = "[S]earch [K]eymaps";
        };
        "<leader>sf" = {
          action = "<cmd>Telescope find_files<CR>";
          desc = "[S]earch [F]iles";
        };
        "<leader>ss" = {
          action = "<cmd>Telescope builtin<CR>";
          desc = "[S]earch [S]elect Telescope";
        };
        "<leader>sw" = {
          action = "<cmd>Telescope grep_string<CR>";
          desc = "[S]earch current [W]ord";
        };
        "<leader>sg" = {
          action = "<cmd>Telescope live_grep<CR>";
          desc = "[S]earch by [G]rep";
        };
        "<leader>sd" = {
          action = "<cmd>Telescope diagnostics<CR>";
          desc = "[S]earch [D]iagnostics";
        };
        "<leader>sr" = {
          action = "<cmd>Telescope resume<CR>";
          desc = "[S]earch [R]esume";
        };
        "<leader>s." = {
          action = "<cmd>Telescope oldfiles<CR>";
          desc = "[S]earch Recent Files";
        };
        "<leader>sc" = {
          action = "<cmd>Telescope commands<CR>";
          desc = "[S]earch [C]ommands";
        };
        "<leader><leader>" = {
          action = "<cmd>Telescope buffers<CR>";
          desc = "[ ] Find existing buffers";
        };
        "<leader>/" = {
          action = "<cmd>Telescope current_buffer_fuzzy_find<CR>";
          desc = "[/] Fuzzily search in current buffer";
        };
        "<leader>s/" = {
          action = "<cmd>Telescope live_grep grep_open_files=true<CR>";
          desc = "[S]earch [/] in Open Files";
        };
        "<leader>sn" = {
          action = ''<cmd>lua require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })<CR>'';
          desc = "[S]earch [N]eovim files";
        };

        # Format buffer
        "<leader>f" = {
          action = "vim.lsp.buf.format";
          lua = true;
          desc = "[F]ormat buffer";
        };
      };

      terminal = {
        # Exit terminal mode easier
        "<Esc><Esc>" = {
          action = "<C-\\><C-n>";
          desc = "Exit terminal mode";
        };
      };

      visual = {
        # Search current word in visual mode
        "<leader>sw" = {
          action = "<cmd>Telescope grep_string<CR>";
          desc = "[S]earch current [W]ord";
        };
      };
    };

    theme = {
      enable = true;
      name = "onedark";
      style = "dark";
    };

    filetree = {
      neo-tree = {
        enable = true;
      };
    };

    binds = {
      whichKey = {
        enable = true;
        # Register key groups similar to kickstart.nvim
        register = {
          "<leader>s" = "+[S]earch";
          "<leader>t" = "+[T]oggle";
          "<leader>h" = "+Git [H]unk";
          "gr" = "+LSP Actions";
        };
      };
      cheatsheet = {
        enable = true;
      };
      hardtime-nvim = {
        enable = true;
      };
    };

    git = {
      enable = true;
      gitsigns.enable = true;
      gitsigns.codeActions.enable = false;
    };

    minimap = {
      minimap-vim.enable = false;
      codewindow.enable = true;
    };

    dashboard = {
      dashboard-nvim.enable = false;
      alpha.enable = true;
    };

    notify = {
      nvim-notify.enable = true;
    };

    spellcheck = {
      enable = true;
    };

    lsp = {
      enable = true;
      lspkind.enable = true;
      lightbulb.enable = true;
      lspsaga.enable = false;
      trouble.enable = true;
      lspSignature.enable = false; # conflicts with blink
      otter-nvim.enable = true;
      nvim-docs-view.enable = true;
      formatOnSave = false;

      # LSP keybindings similar to kickstart.nvim
      mappings = {
        # Rename symbol
        renameSymbol = "grn";
        # Code action
        codeAction = "gra";
        # Go to declaration
        goToDeclaration = "grD";
        # Go to definition
        goToDefinition = "grd";
        # Find references
        listReferences = "grr";
        # Go to implementation
        listImplementations = "gri";
        # Go to type definition
        goToType = "grt";
        # Document symbols
        listDocumentSymbols = "gO";
        # Workspace symbols
        listWorkspaceSymbols = "gW";
        # Next diagnostic
        nextDiagnostic = "]d";
        # Previous diagnostic
        previousDiagnostic = "[d";
      };
    };

    telescope.enable = true;

    languages = {
      enableFormat = true;
      enableExtraDiagnostics = true;
      enableTreesitter = true;
      nix.enable = true;
      ts.enable = true;
      css.enable = true;
      csharp.enable = true;
    };

    autopairs.nvim-autopairs.enable = true;

    autocomplete = {
      blink-cmp.enable = true;
    };

    debugger = {
      nvim-dap = {
        enable = true;
        ui.enable = true;
        sources.csharp = ''
          local dap = require("dap")

          dap.adapters.coreclr = {
            type = "executable",
            command = "${pkgs.netcoredbg}/bin/netcoredbg",
            args = { "--interpreter=vscode" },
          }

          dap.configurations.cs = {
            {
              type = "coreclr",
              name = "Launch",
              request = "launch",
              program = function()
                local dlls = vim.fn.glob(vim.fn.getcwd() .. "/**/bin/Debug/**/*.dll", false, true)
                dlls = vim.tbl_filter(function(p)
                  return not p:match("%.resources%.dll$") and not p:match("/ref/")
                end, dlls)
                if #dlls == 0 then
                  return vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
                end
                return coroutine.create(function(co)
                  local telescope = require("telescope")
                  local pickers = require("telescope.pickers")
                  local finders = require("telescope.finders")
                  local conf = require("telescope.config").values
                  local actions = require("telescope.actions")
                  local action_state = require("telescope.actions.state")
                  local cwd = vim.fn.getcwd()
                  pickers.new({}, {
                    prompt_title = "Select DLL",
                    finder = finders.new_table({
                      results = dlls,
                      entry_maker = function(entry)
                        return {
                          value = entry,
                          display = entry:gsub(cwd .. "/", ""),
                          ordinal = entry,
                        }
                      end,
                    }),
                    sorter = conf.generic_sorter({}),
                    attach_mappings = function(prompt_bufnr)
                      actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        coroutine.resume(co, selection.value)
                      end)
                      return true
                    end,
                  }):find()
                end)
              end,
              cwd = vim.fn.getcwd,
              stopAtEntry = false,
            },
            {
              type = "coreclr",
              name = "Attach to process",
              request = "attach",
              processId = require("dap.utils").pick_process,
            },
          }
        '';
      };
    };

    visuals = {
      nvim-scrollbar.enable = true;
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;

      highlight-undo.enable = true;
      indent-blankline.enable = true;

      # Fun
      cellular-automaton.enable = false;
    };

    statusline = {
      lualine = {
        enable = true;
        theme = "onedark";
      };
    };

    snippets.luasnip.enable = true;

    tabline = {
      nvimBufferline.enable = true;
    };

    treesitter.context.enable = true;

    # Autocommands similar to kickstart.nvim
    autocmds = [
      {
        # Highlight when yanking (copying) text
        event = ["TextYankPost"];
        pattern = ["*"];
        command = "lua vim.highlight.on_yank()";
        desc = "Highlight when yanking (copying) text";
      }
    ];

    projects = {
      project-nvim.enable = true;
    };

    utility = {
      ccc.enable = false;
      vim-wakatime.enable = false;
      yanky-nvim.enable = true;
      icon-picker.enable = true;
      surround.enable = true;
      leetcode-nvim.enable = true;
      multicursors.enable = true;

      motion = {
        hop.enable = true;
        leap.enable = true;
        precognition.enable = true;
      };
    };

    terminal = {
      toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
    };

    # Enable GitHub Copilot using NVF's assistant.copilot options
    assistant = {
      copilot = {
        enable = true; # turns on Copilot
        cmp.enable = true; # integrate Copilot with nvim-cmp

        # Minimal setup options passed to copilot.lua.setup()
        setupOpts = {
          panel = {
            enabled = true;
            layout = {
              position = "bottom";
              ratio = 0.4;
            };
          };

          suggestion = {
            enabled = true;
            auto_trigger = true;
          };
        };

        # Optional: customize key mappings (defaults shown here; change if desired)
        mappings = {
          panel = {
            accept = "<CR>";
            jumpNext = "]]";
            jumpPrev = "[[";
            open = "<M-CR>";
            refresh = "gr";
          };
          suggestion = {
            accept = "<C-y>";
            acceptLine = null;
            acceptWord = null;
            dismiss = "<C-]>";
            next = "<M-]>";
            prev = "<M-[>";
          };
        };
      };
    };
  };
}
