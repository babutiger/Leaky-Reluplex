# License Map

This repository is a mixed-license repository. It is not correct to treat the entire repository as MIT-licensed.

## MIT-licensed files added in this fork

The following repository-management and documentation files are available under the MIT license in [LICENSE-MIT](LICENSE-MIT):

- `.gitignore`
- `README.md`
- `CITATION.cff`
- `LICENSE-MIT`
- `LICENSES.md`

## Reluplex-derived code and materials

The following files and directories preserve upstream Reluplex licensing and are not relicensed to MIT here:

- `AUTHORS`
- `COPYING`
- `LICENSE`
- `common/`
- `reluplex/`
- `check_properties/`
- `scripts/`
- `glpk-patch/`
- `logs/.gitignore`

These materials carry the modified BSD-style terms reproduced in `COPYING` and `LICENSE`, along with any upstream notices present in file headers.

## Other third-party content

- `glpk-4.60/` is distributed under the GNU General Public License. See `glpk-4.60/README` and `glpk-4.60/COPYING`.
- `nnet/` benchmark files are distributed under CC BY 4.0 as described in `COPYING`.

## Practical consequence

If you want a truly MIT-only release, you would need to publish only the MIT-scoped files above, or create a new repository that excludes the upstream Reluplex code, GLPK, and bundled benchmark data.
