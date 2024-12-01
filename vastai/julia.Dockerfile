FROM --platform=linux/amd64 julia:1.10.6

ARG CUDA_VERSION
ENV CUDA_VERSION=${CUDA_VERSION}

# Julia Related env vars
ENV JULIA_NUM_THREADS="auto"
ENV JULIA_CUDA_SOFT_MEMORY_LIMIT="95%"

# From JuliaGPU/CUDA
# https://github.com/JuliaGPU/CUDA.jl/blob/7ff012f21ecaf9364a348289a136deebe299e8d9/Dockerfile
ENV JULIA_DEPOT_PATH=/usr/local/share/julia

RUN julia -e 'using Pkg; Pkg.add("CUDA")'

# hard-code a CUDA toolkit version
RUN julia -e 'using CUDA; CUDA.set_runtime_version!(parse(VersionNumber, ENV["CUDA_VERSION"]))'
# re-importing CUDA.jl below will trigger a download of the relevant artifacts

# generate the device runtime library for all known and supported devices.
# this is to avoid having to do this over and over at run time.
RUN julia -e 'using CUDA; CUDA.precompile_runtime()'

RUN mkdir -m 0777 /depot
ENV JULIA_DEPOT_PATH=/depot:/usr/local/share/julia

WORKDIR /opt/runner

ADD ./download_gha.sh .
RUN bash ./download_gha.sh
ADD ./register.sh .
ADD ./vastai/entrypoint.sh .

# Environment variables, set at runtime as needed
ENV GITHUB_REPOSITORY=''
ENV RUNNER_TOKEN=''

ENTRYPOINT [ "/bin/bash", "-c", "./entrypoint.sh" ]
