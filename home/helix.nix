{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dev/dotfiles";
in
{
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      typescript-language-server
      vue-language-server
      vscode-langservers-extracted
      tailwindcss-language-server
      yaml-language-server
    ];
  };

  xdg.configFile."helix".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/shared/helix";
}
