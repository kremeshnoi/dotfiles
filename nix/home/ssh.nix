{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      AddKeysToAgent = "yes";
      IdentityFile = "~/.ssh/id_ed25519";
    };
  };
}
