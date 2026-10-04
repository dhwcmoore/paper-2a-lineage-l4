#!/usr/bin/env python3
"""Prepare deterministic editable-source and complete-reviewer packages."""
import gzip
import hashlib
import io
import subprocess
import tarfile
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "release/artifacts"


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    names = subprocess.check_output(["git", "ls-files", "-co", "--exclude-standard"],
                                    cwd=ROOT, text=True).splitlines()
    names = sorted({n for n in names if (ROOT / n).is_file()
                    and not n.startswith("release/artifacts/")})
    package = OUTPUT / "paper2a-v20-reviewer.tar.gz"
    with package.open("wb") as raw:
        with gzip.GzipFile(filename="", fileobj=raw, mode="wb", mtime=0) as compressed:
            with tarfile.open(fileobj=compressed, mode="w") as archive:
                for name in names:
                    data = (ROOT / name).read_bytes()
                    item = tarfile.TarInfo("paper2a-v20/" + name)
                    item.size = len(data)
                    item.mode = (ROOT / name).stat().st_mode & 0o777
                    item.mtime = 0
                    archive.addfile(item, io.BytesIO(data))
    source = OUTPUT / "paper2a-v20-source.zip"
    with zipfile.ZipFile(source, "w", compression=zipfile.ZIP_DEFLATED) as archive:
        for name in names:
            if not name.startswith("document/"):
                continue
            item = zipfile.ZipInfo(Path(name).name, (2026, 10, 4, 0, 0, 0))
            item.compress_type = zipfile.ZIP_DEFLATED
            item.external_attr = 0o644 << 16
            archive.writestr(item, (ROOT / name).read_bytes())
    sums = []
    for path in [source, package]:
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        sums.append(digest + "  " + path.name)
        print(path.relative_to(ROOT), path.stat().st_size, "bytes")
    (OUTPUT / "SHA256SUMS").write_text("\n".join(sums) + "\n")


if __name__ == "__main__":
    main()
