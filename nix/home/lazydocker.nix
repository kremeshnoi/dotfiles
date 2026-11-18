{ lib, pkgs, ... }:

let
  config = ../../shared/lazydocker/config.yml;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  home.file."Library/Application Support/lazydocker/config.yml" = lib.mkIf isDarwin { source = config; };
  xdg.configFile."lazydocker/config.yml" = lib.mkIf (!isDarwin) { source = config; };
}
