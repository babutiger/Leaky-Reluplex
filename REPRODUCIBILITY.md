# Reproducibility Guide

This repository is intended to be usable as a paper artifact for `Reluplex made more practical: Leaky ReLU`.

## Recommended Workflow

Run everything from the repository root.

1. Build all required binaries:

```bash
./scripts/build_all.sh
```

2. Reproduce the full paper experiment suite:

```bash
./scripts/reproduce_paper.sh full
```

This performs:

- environment capture,
- GLPK build,
- Leaky-Reluplex core build,
- property-binary build,
- the reluplex smoke test,
- all property scripts,
- the adversarial script.

## Selective Reproduction

To reproduce only part of the paper:

```bash
./scripts/reproduce_paper.sh property1 property6 adversarial
```

If you have already built the binaries:

```bash
./scripts/reproduce_paper.sh --skip-build property1 property6 adversarial
```

## Output Files

The helper scripts write the following outputs:

- `logs/repro_environment.txt`: machine and toolchain information
- `logs/reproduction_manifest.txt`: targets executed in the current reproduction run
- `reluplex/test.txt`: smoke-test output
- `logs/property*_summary.txt`: summary results for property experiments
- `logs/*stats*.txt`: detailed statistics logs emitted during runs
- `logs/adversarial_summary.txt`: adversarial summary output

## Runtime Notes

- The original implementation was tested on Ubuntu 16.04.
- Most property scripts use a `12h` timeout per query.
- A full run can therefore take a long time.
- The helper scripts assume a Linux environment with `bash`, `make`, `gcc`, `g++`, and `timeout`.
