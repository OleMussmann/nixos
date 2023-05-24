# Package Rollbacks

- Create a new folder <packagename>-<version>
- Put the `default.nix` file of that package version from https://github.com/NixOS/nixpkgs in that folder
- Use the package with
  ```
  (callPackage ../../rollbacks/<packagename>-<version> {})
  ```
