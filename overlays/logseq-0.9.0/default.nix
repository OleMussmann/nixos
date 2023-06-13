final: prev:
{
  logseq-0_9_0 = prev.logseq.overrideAttrs (old: rec {
    pname = "logseq";
    version = "0.9.0";

    src = prev.fetchurl {
      url = "https://github.com/logseq/logseq/releases/download/${version}/logseq-linux-x64-${version}.AppImage";
      hash = "sha256-5oX1LhqWvNiMF9ZI7BvpHe4bhB3vQp6dsjLYMQ9Jy+o=";
      name = "${pname}-${version}.AppImage";
    };

    appimageContents = prev.appimageTools.extract {
      inherit pname src version;
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/${pname} $out/share/applications
      cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
      cp -a ${appimageContents}/Logseq.desktop $out/share/applications/${pname}.desktop

      # remove the `git` in `dugite` because we want the `git` in `nixpkgs`
      chmod +w -R $out/share/${pname}/resources/app/node_modules/dugite/git
      chmod +w $out/share/${pname}/resources/app/node_modules/dugite
      rm -rf $out/share/${pname}/resources/app/node_modules/dugite/git
      chmod -w $out/share/${pname}/resources/app/node_modules/dugite

      substituteInPlace $out/share/applications/${pname}.desktop \
      --replace Exec=Logseq Exec=${pname} \
      --replace Icon=Logseq Icon=$out/share/${pname}/resources/app/icons/logseq.png

      runHook postInstall
    '';

    postFixup = ''
      # set the env "LOCAL_GIT_DIRECTORY" for dugite so that we can use the git in nixpkgs
      makeWrapper ${prev.electron}/bin/electron $out/bin/${pname} \
      --set "LOCAL_GIT_DIRECTORY" ${prev.git} \
      --add-flags $out/share/${pname}/resources/app
    '';
  });
}
