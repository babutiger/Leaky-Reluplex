# Leaky-Reluplex

Leaky-Reluplex is a research codebase that extends Reluplex to verify deep neural networks with Leaky ReLU activation functions.

This repository contains the code accompanying the paper `Reluplex made more practical: Leaky ReLU`.

## Associated Paper

Jin Xu, Zishan Li, Bowen Du, Miaomiao Zhang, and Jing Liu. `Reluplex made more practical: Leaky ReLU.` 2020 IEEE Symposium on Computers and Communications (ISCC), pp. 1-7, 2020. DOI: https://doi.org/10.1109/ISCC50000.2020.9219587

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

For a one-command build, run:

```bash
./scripts/build_all.sh
```

For a containerized environment, you can also build and run via Docker:

```bash
docker build -t leaky-reluplex .
docker run --rm -it leaky-reluplex
```

The manual steps are:

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

## Reproducing the Paper Experiments

The repository includes helper scripts for the property checks used with the bundled ACAS Xu networks.

For the most direct reproduction path, run:

```bash
./scripts/reproduce_paper.sh full
```

This generates:

- `logs/repro_environment.txt`
- `logs/reproduction_manifest.txt`
- `logs/reproduction_check.txt`

For a shorter selective run, for example:

```bash
./scripts/reproduce_paper.sh property1 property6 adversarial
```

To run the same workflow inside Docker:

```bash
./scripts/run_in_docker.sh full
```

After finishing the build steps above, run experiments from the repository root:

```bash
./scripts/run_property1.sh
./scripts/run_property2.sh
./scripts/run_property3.sh
./scripts/run_property4.sh
./scripts/run_property5.sh
./scripts/run_property6.sh
./scripts/run_property7.sh
./scripts/run_property8.sh
./scripts/run_property9.sh
./scripts/run_property10.sh
./scripts/run_adversarial.sh
```

Each script writes summary and statistics files into `logs/`. Most property scripts use a `12h` timeout per run.

For a step-by-step artifact workflow, see [REPRODUCIBILITY.md](REPRODUCIBILITY.md).

## Notes

- The primary documented build path is the original Makefile-based workflow.
- The bundled GLPK tree already contains the changes needed by this project; `glpk-patch/glpk.patch` is kept as a reference to those modifications.
- The included benchmark setup follows the original Reluplex property suite, with the Leaky ReLU slope `k = 0.2` in the Leaky-Reluplex test case.

## License

This repository keeps the original Reluplex license text in [LICENSE](LICENSE) and [COPYING](COPYING).

Notes:

- files under `nnet/` keep their original CC BY 4.0 license,
- files under `glpk-4.60/` keep their original GPL license.

## Citation

If you use this repository, please cite the accompanying paper:

```bibtex
@inproceedings{xu2020reluplex,
  author    = {Jin Xu and Zishan Li and Bowen Du and Miaomiao Zhang and Jing Liu},
  title     = {Reluplex made more practical: Leaky ReLU},
  booktitle = {2020 IEEE Symposium on Computers and Communications (ISCC)},
  pages     = {1--7},
  year      = {2020},
  doi       = {10.1109/ISCC50000.2020.9219587}
}
```

Please also acknowledge the original Reluplex work and the upstream implementation by the Reluplex authors and contributors listed in `AUTHORS`.
