{ pkgs, ... }:

let
  herdr = pkgs.callPackage ../pkgs/herdr.nix { };
in
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.channel.enable = false;
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };
  nix.optimise.automatic = true;

  system.primaryUser = "kremeshnoi";
  users.users.kremeshnoi = {
    home = "/Users/kremeshnoi";
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };

  programs.nix-index-database.comma.enable = true;

  environment.systemPackages = with pkgs; [
    herdr
    nh
    git
    git-lfs
    gh
    ripgrep
    fd
    tree
    wget
    jq
    htop
    btop
    nvd
    nix-tree
    ngrok
    python3
    uv
    pnpm
    go
    stylua
    dprint
    tree-sitter
    shfmt
    eslint_d
    prettier
    wakatime-cli
  ];

  environment.variables.NH_FLAKE = "/Users/kremeshnoi/dev/dotfiles";

  homebrew = {
    enable = true;
    taps = [ "glzr-io/tap" ];
    casks = [
      "glzr-io/tap/glazewm"
      "swiftbar"
      "ghostty"
    ];
    onActivation.cleanup = "none";
  };

  system.defaults.CustomUserPreferences."com.ameba.SwiftBar".PluginDirectory = "/Users/kremeshnoi/.config/swiftbar";

  system.stateVersion = 6;
}
