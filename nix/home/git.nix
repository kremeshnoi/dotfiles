{
  programs.git = {
    enable = true;
    settings.user = {
      name = "kremeshnoi";
      email = "alexander.kremeshnoi@gmail.com";
    };
    includes = [ { path = "${../../shared/git/config}"; } ];
  };
}
