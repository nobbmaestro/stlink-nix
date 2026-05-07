# stlink-nix (v1.7.0)

Nix flake packaging of the open-source `stlink` STM32 programming tools.

This flake provides `stlink` v1.7.0, which is currently the latest supported version for macOS.

The package includes:

- `st-util` - GDB server for STM32 devices
- `st-flash` - Firmware flashing tool
- `st-info` - Device inspection tool
- `st-trace` - Trace debugging utility

## Usage

### Run without installing

Default app (st-info --help equivalent):

```sh
nix run github:nobbmaestro/stlink-nix
```

Run a specific tool:

```nix
nix run github:nobbmaestro/stlink-nix#st-info
nix run github:nobbmaestro/stlink-nix#st-flash
nix run github:nobbmaestro/stlink-nix#st-util
nix run github:nobbmaestro/stlink-nix#st-trace
```

### Flake usage

#### Add input

```nix
inputs.stlink.url = "github:nobbmaestro/stlink-nix";
```

#### Package usage

```nix
environment.systemPackages = [
  stlink.packages.aarch64-darwin.default
];
```

or dev shell:

```nix
devShells.default = pkgs.mkShell {
  packages = [
    stlink.packages.aarch64-darwin.default
  ];
};
```

### Overlay usage

The flake provides an overlay so `stlink` can be used like a normal package from `nixpkgs`:

```nix
{
  inputs.stlink.url = "github:nobbmaestro/stlink-nix";
  outputs = inputs@{ nixpkgs, stlink, ... }:
  let
    system = "aarch64-darwin";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ stlink.overlays.default ];
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = [ pkgs.stlink ];
    };
  };
}
```

After applying the overlay, `pkgs.stlink` is available like a normal package.

## Upstream

[https://github.com/stlink-org/stlink](https://github.com/stlink-org/stlink)
