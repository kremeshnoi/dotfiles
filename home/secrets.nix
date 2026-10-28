{ config, ... }:

{
  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ../secrets/secrets.yaml;
    secrets.wakatime.path = "${config.home.homeDirectory}/.wakatime.cfg";
    secrets.ngrok.path = "${config.xdg.configHome}/ngrok/ngrok.yml";
  };
}
