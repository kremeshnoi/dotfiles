{ config, lib, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dev/dotfiles";
  link = config.lib.file.mkOutOfStoreSymlink;
  skills = builtins.attrNames (builtins.readDir ../shared/claude/skills);
in
{
  home.file = lib.listToAttrs (map (skill: lib.nameValuePair ".claude/skills/${skill}" {
    source = link "${dotfiles}/shared/claude/skills/${skill}";
  }) skills);
}
