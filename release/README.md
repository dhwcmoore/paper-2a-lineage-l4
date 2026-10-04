# Reviewer release

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

The verified component assembly is pinned at
`a44557a06d1043d7a8d908fc7b32d891cbddc848`. It includes the decision core at
`945c68e08f2d267d9a8a06ec77784a3ecc47afd9` and upstream additions at
`1e9de34b63281d019502f746f57ede348b62ca5e`. The bundle contains the walkthrough,
benchmark and manuscript/source package; the current manifest binds
these files and the component evidence.

The paper, supplement and supporting artefact are deposited on
[Zenodo (DOI: 10.5281/zenodo.23143172)](https://doi.org/10.5281/zenodo.23143172). The record identifies
commit `0619413077a4cb85fcc67819ec776ce414085d29` and supplies
`paper2a-v20-zenodo.zip` (4,757,791 bytes; deposited MD5 checksum
`88215daabe1e6b73479ebf455033d5c6`). The public record metadata was checked;
the deposited ZIP has not been independently byte-verified. Repository edits
after the pinned commit are not part of that deposit.

The supporting source snapshot is also permanently archived at:

- Revision: `swh:1:rev:bea91080c022e4891731aa7a7bf60369269b25c7`.
- [Persistent archive resolver](https://archive.softwareheritage.org/swh:1:rev:bea91080c022e4891731aa7a7bf60369269b25c7/).
- Snapshot: `swh:1:snp:2bd5c3f083ff44f44938215726df410027da0349`.
- [Completed archival request](https://archive.softwareheritage.org/api/1/origin/save/2534032/).

The request succeeded with a full visit. The archived revision matches the
published Git commit `bea91080c022e4891731aa7a7bf60369269b25c7`. Public retrieval
of the generated decision core, raw scaling data, main PDF and supplement
source was checked byte for byte against that revision. The API response,
revision metadata and retrieval checks are retained under
`paper2a-extension/verification-v20/archive/`.

The archived revision contains the experimental and implementation
material, plus the manuscript before its archive-citation update. The final
paper cites that supporting artefact; the later provenance paragraph, final PDF
and current source/reviewer packages have their own current manifest and package
hashes. The Software Heritage identifier identifies a source revision; the Zenodo DOI
identifies the deposited paper and artefact. Neither establishes journal acceptance.
The component relationship is:

`945c68e` decision core → `1e9de34` proof/runtime additions → `a44557a`
verified component assembly → `bea9108` archived supporting artefact → final
manuscript/archive-citation update.
