FROM python:3.9.20-slim

# procps is required by Nextflow (CloudOS) for task metrics
RUN apt-get update && apt-get install -y --no-install-recommends procps \
    && rm -rf /var/lib/apt/lists/*

# Same dependency versions as your working installation
RUN pip install --no-cache-dir \
        numpy==2.0.2 \
        pysam==0.22.1 \
        natsort==8.4.0

# Optional extras for vase_reporter / bgzip output. Uncomment if needed:
# RUN pip install --no-cache-dir biopython xlsxwriter requests mygene

# VASE 0.5.1 (tag 0.5.1), pinned to its underlying commit
ARG VASE_REF=f939cb527d72d852cb0919a57332110c15c5fd4a
RUN pip install --no-cache-dir --no-deps \
        https://github.com/david-a-parry/vase/archive/${VASE_REF}.tar.gz

# Build-time sanity check
RUN vase --help > /dev/null \
    && python -c "import vase, pysam, numpy, natsort; print(vase.__file__)"
