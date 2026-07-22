{
  description = "AtCoder practice in Rust";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default ];
        };

        # AtCoder ジャッジ（2025-10 言語アップデート）は rustc 1.89.0
        rustToolchain = pkgs.rust-bin.stable."1.89.0".default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        };

      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            rustToolchain
            pkgs.just # コマンドランナー（レシピは justfile を参照）
            pkgs.online-judge-tools # サンプルケースの取得・テスト実行 (oj)
          ];
        };
      });
}
