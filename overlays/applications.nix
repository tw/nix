self: super: {

installApplication = 
  { name, appname ? name, version, src, description, homepage, 
    postInstall ? "", sourceRoot ? ".", ... }:
  with super; stdenv.mkDerivation {
    name = "${name}-${version}";
    version = "${version}";
    src = src;
    buildInputs = [ undmg unzip ];
    sourceRoot = sourceRoot;
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mkdir -p "$out/Applications/${appname}.app"
      cp -pR * "$out/Applications/${appname}.app"
    '' + postInstall;
    meta = with lib; {
      description = description;
      homepage = homepage;
      maintainers = with maintainers; [ tw ];
      platforms = platforms.darwin;
    };
  };

iTerm2 = self.installApplication rec {
  name = "iTerm2";
  appname = "iTerm";
  version = "3.4.8";
  sourceRoot = "iTerm.app";
  src = super.fetchurl {
    url = "https://iterm2.com/downloads/stable/iTerm2-3_4_8.zip";
    sha256 = "0vrppd02x50101npbg6ymb9zx9vlknb83ms27vi67kgkvy0czq99";
  };
  description = "iTerm2 is a replacement for Terminal and the successor to iTerm";
  homepage = https://www.iterm2.com;
};

Keybase = self.installApplication rec {
  name = "Keybase";
  appname = "Keybase";
  version = "5.7.0";
  sourceRoot = "Keybase.app";
  #buildInputs = [ super.unzip ];
  src = super.fetchurl {
    name = "Keybase-${version}.zip";
    url = "https://prerelease.keybase.io/darwin-updates/Keybase-5.7.0-20210622193735%2Be3826b703a.zip";
    sha256 = "19pcr1rp9gx4bg5jng2crxy76sgr25sckri6ckqh8gh25a5s1wy3";
  };
  description = "End-to-end encryption software";
  homepage = https://www.keybase.io;
};

jdk16 = super.jdk16.overrideAttrs(oldAttrs: {
  installPhase = ''
      # hello world

      ls
      rm -rf demo
      rm -rf man
      ls
  '' + oldAttrs.installPhase;
});

IntelliJ = self.installApplication rec {
  name = "IntelliJ-IDEA";
  appname = "IntelliJ IDEA";
  version = "2021.2";
  sourceRoot = "IntelliJ IDEA.app";
  src = super.fetchurl {
    url = "https://download.jetbrains.com/idea/ideaIU-2021.2-aarch64.dmg";
    sha256 = "19r140dimmm46y352qnfs696fsgi78qqnd6ya6gj2kqgclqibj6p";
  };
  description = "iTerm2 is a replacement for Terminal and the successor to iTerm";
  homepage = https://www.iterm2.com;
};

Docker = self.installApplication rec {
  name = "Docker";
  appname = "Docker";
  version = "66501";
  sourceRoot = "Docker.app";
  src = super.fetchurl {
    url = "https://desktop.docker.com/mac/stable/arm64/66501/Docker.dmg";
    sha256 = "0kzilxgdilpcz11rmdvvyl41l295z76771dnvh1zi7p4fdpfic7v";
  };
  description = "iTerm2 is a replacement for Terminal and the successor to iTerm";
  homepage = https://www.iterm2.com;
};
}
