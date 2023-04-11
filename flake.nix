{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;

  in with pkgs;
  let
    dependencies = [ ripgrep fzf bat ];
  in {
    devShell.x86_64-linux = mkShell { 
      buildInputs = dependencies;
    };
    packages.x86_64-linux.fzf-search = 
    stdenv.mkDerivation {
       name = "fzf-search";
       src = self;
       buildInputs = [makeWrapper ];
       installPhase = "
         mkdir -p $out/bin; 
         install -t $out/bin fzf-search;
         install -t $out/bin fzf-file;
         install -t $out/bin help.1"; #TODO it doesn't belong there
       postFixup =
       let
         dependency_path = pkgs.lib.makeBinPath dependencies;
       in
       ''
         wrapProgram "$out/bin/fzf-search" --prefix PATH : "${dependency_path}"
         wrapProgram "$out/bin/fzf-file" --prefix PATH : "${dependency_path}"
       '';
    };

    # nix run <loc>#fzf-search
    apps.x86_64-linux.fzf-search = {
    type = "app";
    program = "${self.packages.x86_64-linux.fzf-search}/bin/fzf-search";
    };

    # nix run <loc>#fzf-file
    apps.x86_64-linux.fzf-file = {
    type = "app";
    program = "${self.packages.x86_64-linux.fzf-search}/bin/fzf-file";
    };

    # Default nix run
    apps.x86_64-linux.default = self.apps.x86_64-linux.fzf-search;
  };

}
