{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  zig_0_16,
  pkg-config,
  wayland-scanner,
  wayland,
  wayland-protocols,
  libxkbcommon,
  pixman,
  fcft,
  river,
  versionCheckHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kwm";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "kewuaa";
    repo = "kwm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hX76wTHPTgg5RAHILfd3CjRKPlgAwGSK3lG82IFoUUs=";
  };

  deps = callPackage ./deps.nix {};

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    zig_0_16
  ];

  buildInputs = [
    fcft
    libxkbcommon
    pixman
    wayland
    wayland-protocols
    wayland-scanner
  ];

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
    "-Dconfig=config.def.zon"
    "-Dkwim=false"
  ];

  postPatch = ''
    substituteInPlace contrib/kwm.desktop \
      --replace-fail "Exec=river -c kwm" "Exec=${lib.getExe river} -c $out/bin/kwm"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [versionCheckHook];
  versionCheckProgramArg = "-version";

  passthru = {
    providedSessions = ["kwm"];
    updateScript = nix-update-script {};
  };

  meta = {
    description = "DWM-like dynamic tiling window manager for the river Wayland compositor";
    homepage = "https://github.com/kewuaa/kwm";
    changelog = "https://github.com/kewuaa/kwm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "kwm";
    maintainers = with lib.maintainers; [
      lykos153
    ];
    inherit (zig_0_16.meta) platforms;
  };
})
