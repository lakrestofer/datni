{
  description = "My Awesome Desktop Shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    ags = {
      url = "github:aylur/ags/631f462ba4f98a247ba53836d99266cfd8451b25";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ags,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = {
        default = ags.lib.bundle {
          inherit pkgs;
          src = ./.;
          name = "datni";
          entry = "app.ts";

          # additional libraries and executables to add to gjs' runtime
          extraPackages = [
            ags.packages.${system}.agsFull
          ];
        };
      };

      devShells.${system} = {
        default = pkgs.mkShell {
          buildInputs = [
            # includes all Astal libraries
            ags.packages.${system}.agsFull

            # includes astal3 astal4 astal-io by default
            (ags.packages.${system}.default.override {
              extraPackages = [
                # cherry pick packages
              ];
            })
          ];
        };
      };
    };
}
