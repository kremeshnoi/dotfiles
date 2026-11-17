{ lib, pkgs, ... }:

let
  config = ../../shared/lazygit/config.yml;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  home.file."Library/Application Support/lazygit/config.yml" = lib.mkIf isDarwin { source = config; };
  xdg.configFile."lazygit/config.yml" = lib.mkIf (!isDarwin) { source = config; };
}
