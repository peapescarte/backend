{
  description = "Plataforma Digital PEA Pescarte";

  outputs = {nixpkgs, ...}: let
    systems = {
      linux = "x86_64-linux";
      darwin = "aarch64-darwin";
    };

    pkgs = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
  in {
    packages = {
      "${systems.darwin}".default = let
        darwinPkgs = pkgs systems.darwin;
        erl = darwinPkgs.beam.packages.erlang;
        nodeDependencies = (darwinPkgs.callPackage ./apps/plataforma_digital/assets/default.nix {}).shell.nodeDependencies;
      in
        erl.callPackage ./nix/pescarte.nix {
          inherit nodeDependencies;
          inherit (darwinPkgs) nix-gitignore;
        };
    };

    devShells = let
      mkShell = pkgs: let
        inherit (pkgs.beam.packages) erlang_26;
      in
        pkgs.mkShell {
          name = "pescarte";
          packages = with pkgs;
            [
              gnumake
              gcc
              openssl
              zlib
              libxml2
              libiconv
              erlang_26.elixir
              postgresql_15
              nodejs_18
            ]
            ++ lib.optional stdenv.isLinux [
              inotify-tools
              gtk-engine-murrine
            ]
            ++ lib.optional stdenv.isDarwin [
              darwin.apple_sdk.frameworks.CoreServices
              darwin.apple_sdk.frameworks.CoreFoundation
            ];
        };
    in {
      "${systems.linux}".default = mkShell (pkgs systems.linux);
      "${systems.darwin}".default = mkShell (pkgs systems.darwin);
    };
  };
}
