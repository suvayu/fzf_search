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
    defaultPackage.x86_64-linux = 
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
       '';
    };
  };

}
