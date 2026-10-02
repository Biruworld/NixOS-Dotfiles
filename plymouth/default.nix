{
  lib,
  stdenvNoCC,
  imagemagick,
  # Output frame size. Match your panel so Plymouth never has to scale at boot.
  width ? 1920,
  height ? 1080,
  # "Point" keeps the pixel-art crisp and the PNGs small (~8 MB total).
  # "Lanczos" is smoother but roughly 3x bigger in the initrd.
  filter ? "Point",
}:

stdenvNoCC.mkDerivation {
  pname = "plymouth-theme-ayaka";
  version = "1.0";

  src = ./ayaka-theme;

  nativeBuildInputs = [ imagemagick ];

  dontConfigure = true;
  dontFixup = true;

  buildPhase = ''
    runHook preBuild

    mkdir frames

    # Per-frame delay of the GIF in centiseconds (60 ms -> 6)
    delay_cs=$(magick identify -format '%T\n' ayaka.gif | head -n1)
    # The Plymouth script plugin refreshes at 50 Hz, i.e. one tick per 20 ms
    ticks=$(( delay_cs * 10 / 20 ))
    [ "$ticks" -ge 1 ] || ticks=1

    # -coalesce rebuilds every frame as a full image (GIFs store deltas),
    # PNG8 keeps the 256-colour palette so the files stay small.
    magick ayaka.gif -coalesce \
      -filter ${filter} -resize "${toString width}x${toString height}!" \
      -define png:compression-level=9 \
      PNG8:frames/frame-%d.png

    count=$(ls frames/*.png | wc -l)
    echo "frames: $count, ticks per frame: $ticks"

    sed -e "s|@FRAME_COUNT@|$count|g" \
        -e "s|@TICKS_PER_FRAME@|$ticks|g" \
        ayaka.script > ayaka.script.out
    sed "s|@out@|$out|g" ayaka.plymouth > ayaka.plymouth.out

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    theme="$out/share/plymouth/themes/ayaka"
    mkdir -p "$theme"
    cp frames/*.png "$theme/"
    cp ayaka.script.out "$theme/ayaka.script"
    cp ayaka.plymouth.out "$theme/ayaka.plymouth"

    runHook postInstall
  '';

  meta = {
    description = "Animated Ayaka Plymouth boot splash built from a GIF";
    platforms = lib.platforms.linux;
  };
}
