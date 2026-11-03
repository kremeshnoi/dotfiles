{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "kremeshnoi";
        email = "alexander.kremeshnoi@gmail.com";
      };
      color.ui = true;
      core = {
        autocrlf = "input";
        editor = "nvim";
        eol = "lf";
      };
      pull.rebase = false;
      fetch.prune = true;
      push.autoSetupRemote = true;
      diff = {
        algorithm = "histogram";
        colorMoved = "default";
      };
      rerere.enabled = true;
      branch.sort = "-committerdate";
      column.ui = "auto";
      init.defaultBranch = "main";
    };
  };
}
