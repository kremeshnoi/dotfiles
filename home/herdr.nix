{ config, lib, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dev/dotfiles";
  link = config.lib.file.mkOutOfStoreSymlink;
  herdr = "/run/current-system/sw/bin/herdr";

  reviewr = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "herdr-reviewr";
    version = "0.49.0";
    src = pkgs.fetchurl {
      url = "https://github.com/persiyanov/herdr-reviewr/releases/download/v${version}/herdr-reviewr-x86_64-unknown-linux-musl.tar.gz";
      hash = "sha256-no1hwT/8sY763mmELC3d1+j9Br2Wz8OdtOOFrktTUwY=";
    };
    manifest = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/persiyanov/herdr-reviewr/v${version}/herdr-plugin.toml";
      hash = "sha256-bTc/RcFhkMDO3CtxVLz3WIJAVVLHLnNSAKylhWhN/Mg=";
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      tar -xzf $src -C $out/bin herdr-reviewr
      cp $manifest $out/herdr-plugin.toml
    '';
  };

  plugins = [
    { id = "persiyanov.reviewr"; root = reviewr; }
    { id = "kremeshnoi.workspace-tabs"; root = "${dotfiles}/shared/herdr/workspace-tabs"; }
  ];

  linkPlugin = plugin: ''
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
  xdg.configFile."herdr/config.toml".source = link "${dotfiles}/windows/herdr/config.toml";
  home.file.".local/bin/herdr-nav".source = link "${dotfiles}/windows/herdr/herdr-nav";
  home.file.".local/bin/herdr-git-review".source = link "${dotfiles}/shared/herdr/git-review.sh";
  home.file.".local/bin/herdr-goto".source = link "${dotfiles}/shared/herdr/goto.sh";
  xdg.configFile."herdr/plugins/config/persiyanov.reviewr/config.toml".source = link "${dotfiles}/shared/herdr/reviewr.toml";

  home.activation.herdrPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -x ${herdr} ]; then
      pluginsJson="${config.xdg.configHome}/herdr/plugins.json"
      ${lib.concatMapStrings linkPlugin plugins}
    fi
  '';
}
