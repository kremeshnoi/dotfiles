{ lib, pkgs, ... }:

lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  home.file.".glzr/glazewm/config.yaml".source = ../darwin/glazewm/config.yaml;
  home.file.".glzr/glazewm/kill-workspace.sh".source = ../darwin/glazewm/kill-workspace.sh;
  xdg.configFile."swiftbar/glazewm.sh".source = ../darwin/swiftbar/glazewm.sh;
  xdg.configFile."ghostty/config".source = ../darwin/ghostty/config;
}
