{
  home.homeDirectory = "/Users/kremeshnoi";

  home.file.".glzr/glazewm/config.yaml".source = ../../../mac/glazewm/config.yaml;
  home.file.".glzr/glazewm/kill-workspace.sh".source = ../../../mac/glazewm/kill-workspace.sh;
  xdg.configFile."swiftbar/glazewm.sh".source = ../../../mac/swiftbar/glazewm.sh;
  xdg.configFile."ghostty/config".source = ../../../mac/ghostty/config;

  xdg.configFile."herdr/config.toml".text = builtins.readFile ../../../mac/herdr/config.toml + "\n" + builtins.readFile ../../../shared/herdr/space-colors/sidebar.toml;

  home.file."Library/Application Support/lazygit/config.yml".source = ../../../shared/lazygit/config.yml;
  home.file."Library/Application Support/lazydocker/config.yml".source = ../../../shared/lazydocker/config.yml;
}
