{ lib, pkgs, ... }:

lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  home.file.".glzr/glazewm/config.yaml".source = ../../mac/glazewm/config.yaml;
  home.file.".glzr/glazewm/kill-workspace.sh".source = ../../mac/glazewm/kill-workspace.sh;
  xdg.configFile."swiftbar/glazewm.sh".source = ../../mac/swiftbar/glazewm.sh;
  xdg.configFile."ghostty/config".source = ../../mac/ghostty/config;
}
