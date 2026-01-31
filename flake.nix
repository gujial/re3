{
  description = "Flake for building re3 (GTA Vice City) miami branch";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    librw = {
      url = "github:aap/librw";
      flake = false;
    };
    ogg = {
      url = "github:xiph/ogg";
      flake = false;
    };
    opus = {
      url = "github:xiph/opus";
      flake = false;
    };
    opusfile = {
      url = "github:xiph/opusfile";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, librw, ogg, opus, opusfile }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      
      forAllSystems = f: builtins.listToAttrs (map (system: {
        name = system;
        value = f system;
      }) supportedSystems);

      mkPkgs = system: import nixpkgs { inherit system; };

      # 构建re3（miami分支）的函数
      buildRe3 =
        pkgs:
        pkgs.stdenv.mkDerivation rec {
          pname = "reVC";
          version = "1.0.0";

          # 使用本地源，排除build目录和.git
          src = pkgs.lib.cleanSourceWith {
            filter = name: type:
              let baseName = baseNameOf (toString name);
              in !(
                baseName == "build" ||
                baseName == ".git" ||
                baseName == ".gitignore" ||
                baseName == "result" ||
                baseName == ".vscode" ||
                baseName == ".idea" ||
                baseName == "vendor" # 排除本地vendor目录，我们将从inputs提供
              );
            src = ./.;
          };

          # 从inputs提供submodules
          postUnpack = ''
            mkdir -p $sourceRoot/vendor
            cp -r ${librw} $sourceRoot/vendor/librw
            cp -r ${ogg} $sourceRoot/vendor/ogg
            cp -r ${opus} $sourceRoot/vendor/opus
            cp -r ${opusfile} $sourceRoot/vendor/opusfile
            
            # 由于从flake inputs复制，目录可能是只读的
            chmod -R u+w $sourceRoot/vendor
          '';

          nativeBuildInputs = [
            pkgs.cmake
            pkgs.gcc
            pkgs.gnumake
            pkgs.git
            pkgs.pkg-config
          ];

          buildInputs = [
            pkgs.libx11
            pkgs.libxcb
            pkgs.libxkbcommon
            pkgs.libGL
            pkgs.libGLU
            pkgs.openal
            pkgs.glew
            pkgs.glfw
            pkgs.libsndfile
            pkgs.libmpg123
            pkgs.xorg.libXrandr
            pkgs.xorg.libXinerama
            pkgs.xorg.libXcursor
            pkgs.xorg.libXi
          ];

          buildPhase = ''
            cd ..
            
            export PKG_CONFIG_PATH="${pkgs.glfw}/lib/pkgconfig:${pkgs.openal}/lib/pkgconfig:${pkgs.libmpg123}/lib/pkgconfig:$PKG_CONFIG_PATH"
            
            cmake -S . -B build \
              -G "Unix Makefiles" \
              -DCMAKE_BUILD_TYPE=Release \
              -DREVC_VENDORED_LIBRW=ON \
              -DREVC_AUDIO=OAL \
              -DLIBRW_PLATFORM=GL3 \
              -DLIBRW_GL3_GFXLIB=GLFW \
              -Wno-dev
            
            cd build
            make -j$NIX_BUILD_CORES
          '';

          program = "reVC";
          name = "Grand Theft Auto: Vice City (reVC)";
          re3-pwd = "~/.reVC";

          installPhase = ''
            mkdir -p $out/bin $out/share/applications $out/share/icons/hicolor/256x256/apps $out/share/${program}

            cp "src/${program}" $out/bin/${program}
            chmod +x $out/bin/${program}

            # Copy gamefiles to share directory
            if [ -d "../gamefiles" ]; then
              cp -r ../gamefiles/* $out/share/${program}/
            fi

            if [ -f "../res/images/logo.svg" ]; then
              cp ../res/images/logo.svg $out/share/icons/hicolor/256x256/apps/${program}.svg
            fi

            cat > $out/share/applications/${program}.desktop <<EOF
            [Desktop Entry]
            Name=${name}
            Exec=${program}
            Icon=${program}
            Path=${re3-pwd}
            Type=Application
            Categories=Game;
            Terminal=false
            EOF
          '';

          meta = with pkgs.lib; {
            description = "Re3 miami branch: GTA Vice City engine port built with CMake, OpenAL, and libRW.";
            license = licenses.mit;
            maintainers = with maintainers; [ gujial ];
            platforms = platforms.unix;
          };
        };

      mkPackages = system:
        let pkgs = mkPkgs system;
        in {
          reVC = buildRe3 pkgs;
          default = buildRe3 pkgs;
        };

      mkDevShell = system:
        let pkgs = mkPkgs system;
        in pkgs.mkShell {
          buildInputs = [
            pkgs.cmake
            pkgs.gcc
            pkgs.gnumake
            pkgs.git
            pkgs.pkg-config
            pkgs.libx11
            pkgs.libxcb
            pkgs.libxkbcommon
            pkgs.libGL
            pkgs.libGLU
            pkgs.openal
            pkgs.glew
            pkgs.glfw
            pkgs.libsndfile
            pkgs.libmpg123
            pkgs.xorg.libXrandr
            pkgs.xorg.libXinerama
            pkgs.xorg.libXcursor
            pkgs.xorg.libXi
          ];

          shellHook = ''
            echo "re3 development environment loaded (${system})"
            echo "Build commands:"
            echo "  cmake -S . -B build -G 'Unix Makefiles' -DCMAKE_BUILD_TYPE=Release -DREVC_VENDORED_LIBRW=ON -DREVC_AUDIO=OAL -DLIBRW_PLATFORM=GL3 -DLIBRW_GL3_GFXLIB=GLFW"
            echo "  cd build && make -j\$(nproc)"
          '';
        };
    in
    {
      packages = forAllSystems mkPackages;
      
      devShells = forAllSystems (system: {
        default = mkDevShell system;
      });
    };
}
