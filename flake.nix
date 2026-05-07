{
  description = "Open source STM32 MCU programming toolset";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" ];
      perSystem =
        { pkgs, ... }:
        let
          stlink = pkgs.callPackage ./package.nix { };

          mkApp = name: description: {
            type = "app";
            program = "${stlink}/bin/${name}";
            meta.description = description;
          };
        in
        {
          packages = {
            stlink = stlink;
            default = stlink;
          };

          apps = rec {
            st-info = mkApp "st-info" "Display STM32 device information";
            st-flash = mkApp "st-flash" "Flash STM32 devices";
            st-util = mkApp "st-util" "STLink GDB server";
            st-trace = mkApp "st-trace" "STM32 trace utility";
            default = st-info;
          };
        };

      flake = {
        overlays.default = final: prev: {
          stlink = final.callPackage ./package.nix { };
        };
      };
    };
}
