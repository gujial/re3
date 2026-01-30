{
  description = "Flake for building multiple re3 branches with branch-specific metadata";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };

      # 构建单个分支的函数：直接返回 derivation，接受描述字符串
      buildRe3 =
        branch: desc:
        pkgs.stdenv.mkDerivation rec {
          pname = "re3-${branch}";
          version = "1.0.0";

          src = self;

          nativeBuildInputs = [
            pkgs.premake5
            pkgs.gcc
            pkgs.gnumake
            pkgs.libx11
            pkgs.libGL
            pkgs.openal
            pkgs.glew
            pkgs.glfw
            pkgs.libsndfile
            pkgs.libmpg123
          ];

          buildPhase = ''
            substituteInPlace printHash.sh --replace-warn '#!/usr/bin/env sh' '#!${pkgs.bash}/bin/bash'

            echo "Running premake5 gmake2..."
            premake5 gmake2 --with-librw

            cd build
            config="release_linux-amd64-librw_gl3_glfw-oal"
            echo "Building $config..."
            make config=$config
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

            # 安装程序
            cp ../bin/linux-amd64-librw_gl3_glfw-oal/Release/${program} $out/bin/${program}

            # 安装图标到标准图标路径
            cp ../res/images/logo.svg $out/share/icons/hicolor/256x256/apps/${program}.svg

            # 安装 desktop 文件
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
                "Re3 branch ${branch} built with Premake, OpenAL, and auto-arch detection."
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
          pkgs.premake5
          pkgs.gcc
          pkgs.gnumake
          pkgs.libx11
          pkgs.libGL
          pkgs.openal
          pkgs.glew
          pkgs.glfw
          pkgs.libsndfile
          pkgs.libmpg123
        ];

        shellHook = ''
          echo "re3 development environment loaded"
          echo "Available build commands:"
          echo "  premake5 gmake2 --with-librw"
          echo "  cd build && make config=release_linux-amd64-librw_gl3_glfw-oal"
        '';
      };
    };
}
