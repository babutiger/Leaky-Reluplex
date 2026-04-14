FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    build-essential \
    ca-certificates \
    coreutils \
    git \
    lsb-release \
    make \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

COPY . /workspace

RUN chmod +x \
    /workspace/scripts/build_all.sh \
    /workspace/scripts/check_reproduction_outputs.sh \
    /workspace/scripts/record_environment.sh \
    /workspace/scripts/reproduce_paper.sh \
    /workspace/scripts/run_in_docker.sh \
    /workspace/glpk-4.60/configure_glpk.sh \
    /workspace/reluplex/test.sh

CMD ["/bin/bash"]
