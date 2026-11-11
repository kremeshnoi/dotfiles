{ config, lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  copies = {
    wakatime = "${config.home.homeDirectory}/.wakatime.cfg";
    ngrok = "${config.xdg.configHome}/ngrok/ngrok.yml";
  };

  copySecrets = pkgs.writeShellScript "copy-sops-secrets" (
    (if isDarwin then ''
      job="gui/$(id -u)/org.nix-community.home.sops-nix"
      for _ in $(${pkgs.coreutils}/bin/seq 1 30); do
        /bin/launchctl print "$job" 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q 'state = running' || break
        ${pkgs.coreutils}/bin/sleep 1
      done
      dir="$(/usr/bin/getconf DARWIN_USER_TEMP_DIR)/secrets"
    '' else ''
      dir="$XDG_RUNTIME_DIR/secrets"
    '')
    + lib.concatStrings (lib.mapAttrsToList (name: target: ''
      ${pkgs.coreutils}/bin/install -D -m 600 "$dir/${name}" ${lib.escapeShellArg target}
    '') copies)
  );
in
{
  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSymlinkPath = "%r/secrets";
    secrets = lib.mapAttrs (_: _: { }) copies;
  };

  systemd.user.services.sops-nix.Service.ExecStartPost = lib.mkIf (!isDarwin) "${copySecrets}";

  home.activation.copySopsSecrets = lib.mkIf isDarwin (
    lib.hm.dag.entryAfter [ "writeBoundary" "sops-nix" ] ''
      run ${copySecrets}
    ''
  );
}
