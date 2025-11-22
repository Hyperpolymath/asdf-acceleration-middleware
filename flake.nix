{
  description = "asdf-acceleration-middleware - High-performance middleware for asdf operations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        };

        nativeBuildInputs = with pkgs; [
          rustToolchain
          pkg-config
          just
          cargo-audit
          cargo-watch
          cargo-tarpaulin
          cargo-geiger
          cargo-license
          cargo-outdated
          cargo-edit
        ];

        buildInputs = with pkgs; [
          openssl
          dbus
          # Add other runtime dependencies here
        ] ++ lib.optionals stdenv.isDarwin [
          darwin.apple_sdk.frameworks.Security
          darwin.apple_sdk.frameworks.CoreFoundation
          darwin.apple_sdk.frameworks.CoreServices
        ];

      in
      {
        # Development shell
        devShells.default = pkgs.mkShell {
          inherit buildInputs nativeBuildInputs;

          shellHook = ''
            echo "🚀 asdf-acceleration-middleware development environment"
            echo ""
            echo "Available commands:"
            echo "  just          - Show available build commands"
            echo "  just build    - Build all crates"
            echo "  just test     - Run tests"
            echo "  just validate - Run all validation checks"
            echo ""
            echo "Rust version: $(rustc --version)"
            echo "Cargo version: $(cargo --version)"
            echo ""
          '';

          RUST_BACKTRACE = "1";
          RUST_LOG = "debug";
        };

        # Package outputs
        packages = {
          default = self.packages.${system}.asdf-accelerate;

          asdf-accelerate = pkgs.rustPlatform.buildRustPackage {
            pname = "asdf-accelerate";
            version = "0.1.0";

            src = ./.;
            cargoLock.lockFile = ./Cargo.lock;

            inherit nativeBuildInputs buildInputs;

            meta = with pkgs.lib; {
              description = "High-performance CLI for accelerating asdf operations";
              homepage = "https://github.com/Hyperpolymath/asdf-acceleration-middleware";
              license = with licenses; [ mit ];
              maintainers = [ ];
            };
          };

          asdf-bench = pkgs.rustPlatform.buildRustPackage {
            pname = "asdf-bench";
            version = "0.1.0";

            src = ./.;
            cargoLock.lockFile = ./Cargo.lock;

            buildAndTestSubdir = "crates/asdf-bench";

            inherit nativeBuildInputs buildInputs;

            meta = with pkgs.lib; {
              description = "Benchmarking tool for asdf operations";
              homepage = "https://github.com/Hyperpolymath/asdf-acceleration-middleware";
              license = with licenses; [ mit ];
            };
          };

          asdf-discover = pkgs.rustPlatform.buildRustPackage {
            pname = "asdf-discover";
            version = "0.1.0";

            src = ./.;
            cargoLock.lockFile = ./Cargo.lock;

            buildAndTestSubdir = "crates/asdf-discover";

            inherit nativeBuildInputs buildInputs;

            meta = with pkgs.lib; {
              description = "Auto-discovery tool for asdf runtimes";
              homepage = "https://github.com/Hyperpolymath/asdf-acceleration-middleware";
              license = with licenses; [ mit ];
            };
          };

          asdf-monitor = pkgs.rustPlatform.buildRustPackage {
            pname = "asdf-monitor";
            version = "0.1.0";

            src = ./.;
            cargoLock.lockFile = ./Cargo.lock;

            buildAndTestSubdir = "crates/asdf-monitor";

            inherit nativeBuildInputs buildInputs;

            meta = with pkgs.lib; {
              description = "Monitoring dashboard for asdf operations";
              homepage = "https://github.com/Hyperpolymath/asdf-acceleration-middleware";
              license = with licenses; [ mit ];
            };
          };
        };

        # Apps that can be run with `nix run`
        apps = {
          default = self.apps.${system}.asdf-accelerate;

          asdf-accelerate = {
            type = "app";
            program = "${self.packages.${system}.asdf-accelerate}/bin/asdf-accelerate";
          };

          asdf-bench = {
            type = "app";
            program = "${self.packages.${system}.asdf-bench}/bin/asdf-bench";
          };

          asdf-discover = {
            type = "app";
            program = "${self.packages.${system}.asdf-discover}/bin/asdf-discover";
          };

          asdf-monitor = {
            type = "app";
            program = "${self.packages.${system}.asdf-monitor}/bin/asdf-monitor";
          };
        };

        # Checks (tests, lints, etc.)
        checks = {
          build = self.packages.${system}.default;

          test = pkgs.runCommand "test" {
            inherit buildInputs nativeBuildInputs;
          } ''
            cd ${./.}
            cargo test --all
            touch $out
          '';

          fmt = pkgs.runCommand "fmt-check" {
            nativeBuildInputs = [ rustToolchain ];
          } ''
            cd ${./.}
            cargo fmt --all -- --check
            touch $out
          '';

          clippy = pkgs.runCommand "clippy" {
            inherit buildInputs nativeBuildInputs;
          } ''
            cd ${./.}
            cargo clippy --all -- -D warnings
            touch $out
          '';
        };
      }
    );
}
