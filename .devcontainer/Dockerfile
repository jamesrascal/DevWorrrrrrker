FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    python3-dev \
    python3-pip \
    python3-setuptools \
    sqlite3 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python packages for data analysis
RUN pip3 install --no-cache-dir \
    pandas \
    numpy \
    matplotlib \
    seaborn \
    pyarrow \
    duckdb \
    sqlalchemy \
    psycopg2-binary \
    jupyterlab \
    ipykernel \
    black \
    pylint \
    pytest

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g sql-formatter \
    && npm cache clean --force

# Set up working directory
WORKDIR /workspace

# Set default shell to bash
ENV SHELL /bin/bash