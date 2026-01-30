{
  description = "Flake for building multiple re3 branches with branch-specific metadata";

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
      pkgs = import nixpkgs { system = "x86_64-linux"; };

      # 构建单个分支的函数：直接返回 derivation，接受描述字符串
      buildRe3 =
        branch: desc:
        pkgs.stdenv.mkDerivation rec {
          pname = "re3-${branch}";
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

          program =
            if branch == "master" then
              "re3"
            else if branch == "miami" then
              "reVC"
            else if branch == "lcs" then
              "reLCS"
            else
              throw "Unknown branch: ${branch}";

          name = 
            if branch == "master" then
              "Grand Theft Auto: III (re3)"
            else if branch == "miami" then
              "Grand Theft Auto: Vice City (reVC)"
            else if branch == "lcs" then
              "Grand Theft Auto: Liberty City Stories (reLCS)"
            else
              throw "Unknown branch: ${branch}";

          re3-pwd =
            if branch == "master" then
              "~/.re3"
            else if branch == "miami" then
              "~/.reVC"
            else if branch == "lcs" then
              "~/.reLCS"
            else
              throw "Unknown branch: ${branch}";

          installPhase = ''
            mkdir -p $out/bin $out/share/applications $out/share/icons/hicolor/256x256/apps

            cp "src/${program}" $out/bin/${program}
            chmod +x $out/bin/${program}

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
            description =
              if desc == null then
                "Re3 branch ${branch} built with CMake, OpenAL, and auto-arch detection."
              else
                desc;
            license = licenses.mit;
            maintainers = with maintainers; [ gujial ];
            platforms = platforms.linux;
          };
        };

    in
    {
      packages.x86_64-linux = {
        re3 = buildRe3 "master" "Re3 master branch: the mainline GTA III engine port.";
        re3-vc = buildRe3 "miami" "Re3 Miami (VC) branch: GTA Vice City engine port.";
        re3-lcs = buildRe3 "lcs" "Re3 LCS branch: GTA Liberty City Stories engine port.";
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
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
          echo "re3 development environment loaded"
          echo "Build commands:"
          echo "  cmake -S . -B build -G 'Unix Makefiles' -DCMAKE_BUILD_TYPE=Release -DREVC_VENDORED_LIBRW=ON -DREVC_AUDIO=OAL -DLIBRW_PLATFORM=GL3 -DLIBRW_GL3_GFXLIB=GLFW"
          echo "  cd build && make -j\$(nproc)"
        '';
      };
    };
}
