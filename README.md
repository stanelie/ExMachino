# ExMachino

Dual-camera video system for live performance: Android phones stream H.264 over Wi-Fi to a
macOS receiver, which publishes each as a Syphon source (and optionally NDI) for Millumin.

| | |
| --- | --- |
| [`streamer/`](streamer/) | Android app (Kotlin). Captures, encodes, advertises itself over mDNS, serves TCP on 5054. |
| [`viewer/`](viewer/) | macOS app (Swift). Discovers phones, decodes, publishes "EpocCam A" / "EpocCam B". |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | Design notes and the measurements behind them. Read this first. |

## Versioning

**Both apps share one version, in [`VERSION`](VERSION), and are released together** — even when
only one of them changed.

This is deliberate. The two halves talk over a custom wire protocol that changes with almost
every feature, so they are only meaningful as a matched pair: "v3.0.0" names a known-good
combination, where separate version numbers per app did not. `streamer/app/build.gradle` and
`viewer/build.sh` both read that file, so the built artifacts cannot disagree with it.

To cut a release, edit `VERSION`, then:

```sh
./build-all.sh        # artifacts land in dist/
```

## History

This repository merges two that came before it — `EpocCam-streamer` and `EpocCam-receiver` —
with their full history, brought in under `streamer/` and `viewer/` via subtree merges.

`git blame` works normally across the boundary. `git log --follow` does **not** traverse a
subtree merge, so to see a file's history from before the merge, pass both paths, or match on
the basename:

```sh
git log --oneline -- streamer/app/.../StreamingServer.kt app/.../StreamingServer.kt
git log --oneline --all -- '*StreamingServer.kt'
```
