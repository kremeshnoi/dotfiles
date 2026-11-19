{ config, lib, pkgs, ... }:

let
  herdr = "/run/current-system/sw/bin/herdr";

  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  plugins = [
    { id = "kremeshnoi.workspace-tabs"; root = "${../../shared/herdr/workspace-tabs}"; }
    { id = "kremeshnoi.space-colors"; root = "${../../shared/herdr/space-colors}"; }
  ];

  registerPlugin = plugin: ''
    current="$(${pkgs.jq}/bin/jq -r '.[] | select(.plugin_id == "${plugin.id}") | "\(.source.kind) \(.plugin_root)"' "$pluginsJson" 2>/dev/null || true)"
    if [ "$current" != "local ${plugin.root}" ]; then
      if [ "''${current%% *}" = github ]; then
        run ${herdr} plugin uninstall ${plugin.id}
      fi
      run ${herdr} plugin link ${plugin.root}
    fi
  '';
in
{
  xdg.configFile."herdr/config.toml".text = lib.concatMapStringsSep "\n" builtins.readFile [
    (if isDarwin then ../../mac/herdr/config.toml else ../../windows/herdr/config.toml)
    ../../shared/herdr/space-colors/sidebar.toml
  ];
  home.file.".local/bin/herdr-nav" = lib.mkIf (!isDarwin) { source = ../../windows/herdr/herdr-nav; };

  home.activation.herdrPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -x ${herdr} ]; then
      pluginsJson="${config.xdg.configHome}/herdr/plugins.json"
      ${lib.concatMapStrings registerPlugin plugins}
    fi
  '';
}
