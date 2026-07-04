{ config, pkgs, inputs, ... }:

{
  home.username = "alex";
  home.homeDirectory = "/home/alex";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.caelestia = {
    enable = true;
    systemd.enable = false;
    cli.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",3840x2160@144,auto,1.5";

      "$mod" = "SUPER";
      "$terminal" = "foot";

      exec-once = [
        "caelestia shell -d"
      ];

      input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_shift_toggle";
        follow_mouse = 1;
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
      };

      decoration = {
        rounding = 12;
        active_opacity = 1.0;
        inactive_opacity = 0.95;

        shadow = {
          enabled = true;
          range = 30;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "smooth, 0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          "windows, 1, 4, smooth"
          "windowsOut, 1, 4, smooth, popin 80%"
          "border, 1, 8, default"
          "fade, 1, 6, default"
          "workspaces, 1, 5, smooth"
        ];
      };

      bind = [
        "ALT, space, exec, caelestia shell drawers toggle launcher"
        "ALT, w, exec, $terminal"
        "ALT, q, killactive"
        "ALT, Tab, exec, caelestia shell drawers toggle overview"

        "$mod, M, exit"
        "$mod, B, exec, google-chrome-stable"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"

        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  home.packages = with pkgs; [
    foot
    eza
    bat
    fd
    ripgrep
    fzf
    zoxide
    zsh-autosuggestions
    zsh-syntax-highlighting

    grim
    slurp
    swappy
    wl-clipboard
    cliphist
    pavucontrol
    libnotify

    nautilus
    firefox
    google-chrome
    claude-code
    neovim
    vscode
    git
    lazygit
    gh

    _1password-gui
    _1password-cli

    spotify

    nodejs_22
    pnpm
    bun
    typescript

    rustup

    luajit
    luarocks
    stylua
    lua-language-server

    go
    ruby
    julia
    python3
    jdk17
    php
    phpPackages.composer

    obsidian
    discord
    telegram-desktop

    (pkgs.writeShellScriptBin "rmnvim" ''
      set -eu
      echo "Removing Neovim data directories..."
      rm -rf "$HOME/.local/share/nvim"
      rm -rf "$HOME/.local/state/nvim"
      rm -rf "$HOME/.cache/nvim"

      echo "Removing current Neovim config..."
      rm -rf "$HOME/.config/nvim"

      echo "Creating new config directory..."
      mkdir -p "$HOME/.config/nvim"

      echo "Copying config from backup..."
      cp -r "$HOME/dev/nvim-config/." "$HOME/.config/nvim/"

      echo "Neovim configuration reset complete!"
    '')
  ];

  programs.git = {
    enable = true;
    userName = "kremeshnoi";
    userEmail = "alexander.kremeshnoi@gmail.com";
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/dev/nixos-config#alex-nixos";
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrains Mono:size=11";
        pad = "8x8";
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };

  home.file.".claude/CLAUDE.md".text = ''
    # System
    NixOS managed declaratively. Config at ~/dev/nixos-config/ as a flake.
    Apply changes: `rebuild` (alias for `sudo nixos-rebuild switch --flake ~/dev/nixos-config#alex-nixos`)
    Add user packages: home.nix → home.packages
    Add system packages/services: configuration.nix
    Search packages: https://search.nixos.org
    Do NOT install via npm/pip/cargo globally — use Nix.

    # Hardware
    CPU: i9-13900k, GPU: RTX 4090 (NVIDIA stable, open module), 4× 970 EVO Plus

    # Stack
    Shell: fish, Editor: nvim/vscode, Browser: google-chrome
    WM: Hyprland + Caelestia (Quickshell-based)
    User: alex
  '';
}
