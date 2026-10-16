# The portable slice of my development environment: git, neovim
# (nixvim), and the shell niceties. Exported as
# homeManagerModules.dev-tools (flake.nix) so headless machines —
# the infra fleet's devbox — consume the exact same editor and git
# configuration as the msi desktop, from one source of truth.
#
# The module requires the `inputs` specialArg (home-manager
# extraSpecialArgs) with at least the nixvim input; importing it
# without one fails loudly at eval.

{
  inputs,
  lib,
  ...
}:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.git = {
    enable = true;
    settings = {
      core.autocrlf = "input";
      user = {
        name = "Alexandre Borghi";
        email = "alexandre@aborghi.fr";
        signingKey = "~/.ssh/id_ed25519.pub";
      };
      init.defaultBranch = "main";
      # Signatures need a private key on the machine; hosts that have
      # none provisioned yet (the infra devbox) override these.
      commit.gpgSign = lib.mkDefault true;
      tag.gpgSign = lib.mkDefault true;
      gpg.format = "ssh";
      pull.rebase = true;
      diff.renames = "copies";
    };
    signing.allowedSigners = ''
      alexandre@aborghi.fr ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAd7EVcjXuUbN0kNHvQV+QWZlzesqOIzlnFIwVSNs4cs alex@nixos-vm
      alexandre@aborghi.fr ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqwpuEIs4Cu54z8NCKqF4KxLdFktyPF+J23QNjxg2vI alex@msi
    '';
  };

  services.ssh-agent.enable = true;

  programs.nixvim = {
    enable = true;
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
      lsp-format.enable = true;
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
      };
    };
    diagnostic.settings = {
      virtual_text.virt_text_pos = "eol";
    };
  };

  programs.bash = {
    enable = true;
    historyControl = [
      "ignoreboth"
      "erasedups"
    ];
    historyFile = "$XDG_STATE_HOME/bash_history";
  };
  home.shellAliases = {
    ll = "ls -lhF";
    la = "ls -lhFa";
    gs = "git status";
    gd = "git diff";
    ga = "git add";
    gc = "git commit";
    gl = "git log --oneline";
  };
}
