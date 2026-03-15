{
  config,
  pkgs,
  ...
}: {
  vim = {
    options = {
      shada = "'100,<50,s10,h"; # safe default enabling shada with common parameters
      mouse = "a"; # enable mouse support in all modles
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
      formatOnSave = true;
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
