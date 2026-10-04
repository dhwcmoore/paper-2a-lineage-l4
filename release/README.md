# Version 20 reviewer release

The editable-source package contains the main article, complete technical
supplement, bibliography, Springer class/option/bibliography style, scaling
figure and generated table/prose inputs, Makefile and both compiled PDFs.
The complete reviewer bundle additionally contains the proof and runtime
sources, expected outputs, walkthrough, raw scaling data and attributed
verification records, with the current repository manifest.

Build the PDFs first with `make -C document`, then run:

```sh
python3 release/build_packages.py
(cd release/artifacts && sha256sum -c SHA256SUMS)
```

Outputs:

- `release/artifacts/paper2a-v20-source.zip`
- `release/artifacts/paper2a-v20-reviewer.tar.gz`
- `release/artifacts/SHA256SUMS`

Generated packages are excluded from the source manifest to avoid circular
hashes and retained separately with their own checksums. Package construction
uses sorted files and fixed archive timestamps for repeatability.

The verified version 19 component assembly is pinned at
`a44557a06d1043d7a8d908fc7b32d891cbddc848`. It includes the decision core at
`945c68e08f2d267d9a8a06ec77784a3ecc47afd9` and upstream additions at
`1e9de34b63281d019502f746f57ede348b62ca5e`. Version 20 adds the walkthrough,
benchmark and manuscript/source-package changes; the current manifest binds
those additions and the retained component evidence.

Archival deposit is not completed merely by creating a local package. A
permanent identifier must be recorded only after successful deposit and public
retrieval of the archived release. The manuscript currently describes the
prepared bundle without claiming a DOI or completed deposit. The final archive
record should state the release revision, package hashes and relationship to
the pinned components above. Deposit service/account details remain outstanding.
