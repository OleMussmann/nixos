final: prev:
# TODO this should not be necessary if our eduroam was using latest openssl.
# Remove this overlay once it's fixed.
let
  ignoringVulns = x: x // { meta = (x.meta // { knownVulnerabilities = []; }); };
  openssl_1_1 = prev.openssl_1_1.overrideAttrs ignoringVulns;
in {
  wpa_supplicant = prev.wpa_supplicant.overrideAttrs ( old: rec {
    buildInputs = prev.lib.lists.remove prev.openssl old.buildInputs ++ [ openssl_1_1 ];
  });
}
