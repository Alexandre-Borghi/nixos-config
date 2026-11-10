{
  config,
  pkgs,
  ...
}:
{
  home.username = "alex";
  home.homeDirectory = "/home/alex";

  home.preferXdgDirectories = true;
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      setSessionVariables = true;
      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/dl";
      pictures = "${config.home.homeDirectory}/pics";
      videos = "${config.home.homeDirectory}/vids";
    };
  };

  home.packages = with pkgs; [
    btop
    gcc
    unzip
  ];

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

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
    };
  };
  services.ssh-agent.enable = true;

  programs.git = {
    enable = true;
    settings = {
      core.autocrlf = "input";
      user = {
        name = "Alexandre Borghi";
        email = "alexandre@aborghi.fr";
        signingKey = "~/.ssh/id_ed25519_sk.pub";
      };
      init.defaultBranch = "main";
      commit.gpgSign = true;
      tag.gpgSign = true;
      gpg.format = "ssh";
      pull.rebase = true;
      diff.renames = "copies";
    };
    signing.allowedSigners = ''
      alexandre@aborghi.fr ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAd7EVcjXuUbN0kNHvQV+QWZlzesqOIzlnFIwVSNs4cs alex@nixos-vm
      alexandre@aborghi.fr ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqwpuEIs4Cu54z8NCKqF4KxLdFktyPF+J23QNjxg2vI alex@msi
      alexandre@aborghi.fr ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIODzGxiR7FQPs+VXiPQ56Un4TyMe/JpFWUQEy+4mHaw2 alex@msi sk
    '';
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
    keyMode = "vi";
    focusEvents = true;
    extraConfig = ''
      set -g @continuum-restore 'on'
    '';
    plugins = with pkgs.tmuxPlugins; [
      resurrect
      continuum
    ];
  };

  programs.opencode.enable = true;
}
