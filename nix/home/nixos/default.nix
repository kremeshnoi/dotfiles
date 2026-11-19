{
  home.homeDirectory = "/home/kremeshnoi";

  home.sessionVariables.SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/ssh-agent.socket";

  xdg.configFile."herdr/config.toml".text = builtins.readFile ../../../windows/herdr/config.toml + "\n" + builtins.readFile ../../../shared/herdr/space-colors/sidebar.toml;
  home.file.".local/bin/herdr-nav".source = ../../../windows/herdr/herdr-nav;

  xdg.configFile."lazygit/config.yml".source = ../../../shared/lazygit/config.yml;
  xdg.configFile."lazydocker/config.yml".source = ../../../shared/lazydocker/config.yml;
}
