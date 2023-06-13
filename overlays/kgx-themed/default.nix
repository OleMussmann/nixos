final: prev:
{
  kgx-themed = prev.kgx.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      ./atelierlakeside.alpha_0.97.hybrid.alpha_0.97.patch
    ];
  });
}
