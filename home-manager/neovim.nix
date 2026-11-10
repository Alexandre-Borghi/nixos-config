{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    nixpkgs.source = inputs.nixpkgs;
    defaultEditor = true;
    globals = {
      mapleader = " ";
    };
    opts = {
      colorcolumn = "80"; # Highlight column 80
      termguicolors = true; # Enable true colors
      ignorecase = true; # Ignore case in search
      swapfile = false; # Disable swap files
      autoindent = true; # Enable auto indentation
      expandtab = true; # Use spaces instead of tabs
      tabstop = 4; # Number of spaces for a tab
      softtabstop = 4; # Number of spaces for a tab when editing
      shiftwidth = 4; # Number of spaces for autoindent
      shiftround = true; # Round indent to multiple of shiftwidth
      signcolumn = "yes:1"; # Always show sign column
      number = true; # Show line numbers
      relativenumber = true; # Show relative line numbers
      numberwidth = 2; # Width of the line number column
      wrap = false; # Disable line wrapping
      cursorline = true; # Highlight the current line
      scrolloff = 8; # Keep 8 lines above and below the cursor
      undofile = true; # Enable persistent undo
      completeopt = [
        "menuone"
        "popup"
        "noinsert"
      ]; # Options for completion menu
      winborder = "rounded"; # Use rounded borders for windows
    };
    clipboard.register = "unnamedplus";
    keymaps = [
      {
        mode = "n";
        key = "<space>";
        action = "<Nop>";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>FzfLua files<CR>";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>FzfLua live_grep<CR>";
      }
    ];
    plugins = {
      fzf-lua.enable = true;
      lspconfig.enable = true;
      lsp-format = {
        enable = true;
        settings = {
          # let Prettier handle formatting
          typescript.exclude = [ "vtsls" ];
          typescriptreact.exclude = [ "vtsls" ];
          javascript.exclude = [ "vtsls" ];
          javascriptreact.exclude = [ "vtsls" ];
          vue.exclude = [ "vue_ls" ];
        };
      };

      none-ls = {
        enable = true;
        sources = {
          formatting.prettier.enable = true;
        };
      };

      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          vue
          typescript
          tsx
          javascript
          css
          scss
          html
          json
          yaml
          markdown
          markdown-inline
        ];
      };

      # Auto-close/rename HTML + Vue template tags
      ts-autotag.enable = true;

      blink-cmp = {
        enable = true;
        settings = {
          sources = {
            default = [
              "lsp"
              "path"
              "snippets"
              "buffer"
            ];
          };
          keymap = {
            preset = "default";
          };
        };
      };

      web-devicons.enable = true;
      nvim-autopairs.enable = true;
      which-key.enable = true;
    };
    lsp = {
      codelens.enable = true;
      completion = {
        enable = true;
        settings = {
          autotrigger = true;
        };
      };
      documentColor.enable = true;
      inlayHints.enable = true;
      inlineCompletion.enable = true;
      linkedEditingRange.enable = true;
      onTypeFormatting.enable = true;
      semanticTokens.enable = true;
      servers = {
        nixd.enable = true;
        rust_analyzer = {
          enable = true;
          config.settings."rust-analyzer".check.command = "clippy";
        };
        vtsls = {
          config = {
            filetypes = [
              "javascript"
              "javascriptreact"
              "typescript"
              "typescriptreact"
              "vue"
            ];
          };
        };
        vue_ls.enable = true;
        tinymist = {
          enable = true;
          config = {
            exportTarget = "html";
            typstExtraArgs = [
              "--features=bundle,html"
            ];
          };
        };
      };
      keymaps = [
        {
          key = "gd";
          lspBufAction = "definition";
        }
        {
          key = "gr";
          lspBufAction = "references";
        }
        {
          key = "gt";
          lspBufAction = "type_definition";
        }
        {
          key = "gi";
          lspBufAction = "implementation";
        }
        {
          key = "K";
          lspBufAction = "hover";
        }
        {
          key = "<leader>rn";
          lspBufAction = "rename";
        }
        {
          key = "<leader>ca";
          lspBufAction = "code_action";
        }
        {
          key = "[d";
          action = inputs.nixvim.lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count = -1, float = true }) end";
        }
        {
          key = "]d";
          action = inputs.nixvim.lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count = 1, float = true }) end";
        }
        {
          key = "<leader>e";
          action = inputs.nixvim.lib.nixvim.mkRaw "function() vim.diagnostic.open_float() end";
        }
      ];
    };
    diagnostic.settings = {
      virtual_text.virt_text_pos = "eol";
    };
    extraPackages = with pkgs; [
      fd
      nixfmt
      nixfmt-tree
      prettier
      ripgrep
    ];
  };
}
