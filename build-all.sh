#!/bin/bash
# Builds both halves at the shared version. They are released as a matched pair because the
# wire protocol between them changes with almost every feature, so building one alone is
# almost never what you want.
set -e
ROOT="$(cd "$(dirname "$0")" && pwd)"
VERSION="$(cat "$ROOT/VERSION" | tr -d '[:space:]')"
OUT="$ROOT/dist"
GRADLE="${GRADLE:-$HOME/.gradle/wrapper/dists/gradle-9.6.1-bin/4ticwg1pgcbps2hj28r8so764/gradle-9.6.1/bin/gradle}"

echo "==> ExMachino $VERSION"
rm -rf "$OUT" && mkdir -p "$OUT"

echo "==> Building streamer (Android)"
( cd "$ROOT/streamer" && "$GRADLE" assembleDebug -q )
cp "$ROOT/streamer/app/build/outputs/apk/debug/epoccam-streamer.apk" \
   "$OUT/exmachino-streamer-v$VERSION.apk"

echo "==> Building viewer (macOS)"
( cd "$ROOT/viewer" && ./build.sh >/dev/null )
( cd "$ROOT/viewer/.build" && zip -qr "$OUT/exmachino-viewer-v$VERSION.zip" EpocCamViewer.app )

echo "==> Artifacts in dist/"
ls -lh "$OUT" | tail -n +2 | awk '{print "    "$9"  "$5}'
