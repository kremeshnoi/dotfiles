{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings.user = {
      name = "kremeshnoi";
      email = "alexander.kremeshnoi@gmail.com";
    };
    includes = [ { path = "${../../shared/git/config}"; } ];
  };
}
