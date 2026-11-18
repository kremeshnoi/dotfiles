{ lib, pkgs, ... }:

{
  home.activation.batCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.bat}/bin/bat cache --build --source ${../../shared/bat} >/dev/null
  '';
}
