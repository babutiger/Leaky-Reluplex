# Leaky-Reluplex

Leaky-Reluplex is a research codebase that extends Reluplex to verify deep neural networks with Leaky ReLU activation functions.

This repository contains the code accompanying the paper `Reluplex made more practical: Leaky ReLU`.

This repository contains:

- the modified Reluplex solver core,
- bundled GLPK sources used by the project,
- ACAS Xu `.nnet` benchmark files,
- property-specific verification binaries and runner scripts.

The original Reluplex paper is available at https://arxiv.org/abs/1702.01135 and the upstream Reluplex implementation is available at https://github.com/guykatzz/ReluplexCav2017.

## Repository Layout

- `reluplex/`: core Leaky-Reluplex solver
- `check_properties/`: property-specific verification programs
- `scripts/`: batch runners for ACAS Xu properties and adversarial checks
- `nnet/`: ACAS Xu neural-network benchmark files
- `glpk-4.60/`: vendored GLPK source tree used for builds
- `glpk-patch/`: patch file documenting GLPK changes used by Reluplex
- `common/`: shared utility headers
- `logs/`: output directory for experiment summaries and run logs

## Requirements

The original code was tested on Ubuntu 16.04. The documented build flow in this repository uses GNU Make on Linux.

You will typically need:

- `bash`
- `make`
- `gcc` and `g++`
- `timeout` from GNU coreutils

## Build

GLPK is configured to install into the local repository at `glpk-4.60/installed`, not into a system directory.

1. Build GLPK:

```bash
cd glpk-4.60
./configure_glpk.sh
make
make install
```

2. Build the solver core:

```bash
cd ../reluplex
make
```

3. Build the property checkers:

```bash
cd ../check_properties
make
```

## Quick Test

From `reluplex/`:

```bash
./test.sh
```

The script runs `reluplex.elf` and writes output to `reluplex/test.txt`.

## Running Property Experiments

After building `check_properties/`, return to the repository root and run the helper scripts in `scripts/`.

Examples:

```bash
./scripts/run_property1.sh
./scripts/run_property6.sh
./scripts/run_adversarial.sh
```

Logs and summaries are written under `logs/`.

## Notes

- The primary documented build path is the original Makefile-based workflow.
- The bundled GLPK tree already contains the changes needed by this project; `glpk-patch/glpk.patch` is kept as a reference to those modifications.
- The included benchmark setup follows the original Reluplex property suite, with the Leaky ReLU slope `k = 0.2` in the Leaky-Reluplex test case.

## License

Source code in this repository is distributed under the modified BSD license inherited from Reluplex. See [LICENSE](LICENSE) and [COPYING](COPYING).

Additional licensing notes:

- neural-network files in `nnet/` are distributed under CC BY 4.0,
- the project links against GLPK, which is GPL-licensed, so resulting usage and redistribution may be restricted in non-GPL-compatible settings.

## Citation and Acknowledgements

If you use this repository, please cite the original Reluplex work and acknowledge the upstream implementation by the Reluplex authors and contributors listed in `AUTHORS`.
