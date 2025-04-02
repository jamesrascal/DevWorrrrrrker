FROM ubuntu:22.04

# Avoid user interaction with tzdata
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install essential system packages
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    dirmngr \
    git \
    gnupg \
    iputils-ping \
    jq \
    libfontconfig1 \
    libgconf-2-4 \
    libgl1-mesa-glx \
    libsecret-1-0 \
    libx11-xcb1 \
    libxcb-dri3-0 \
    libxtst6 \
    locales \
    nano \
    net-tools \
    openssh-server \
    procps \
    rsync \
    sudo \
    tar \
    unzip \
    wget \
    xdg-utils \
    zsh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Install Python and pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    python3-setuptools \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm yarn typescript \
    && npm cache clean --force

# Install Docker in Docker
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PostgreSQL
RUN apt-get update && apt-get install -y \
    postgresql \
    postgresql-contrib \
    libpq-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python data science packages
RUN pip3 install --no-cache-dir \
    black \
    dask \
    duckdb \
    fastapi \
    ipykernel \
    ipywidgets \
    jupyterlab \
    matplotlib \
    nltk \
    numpy \
    pandas \
    plotly \
    psycopg2-binary \
    pyarrow \
    pylint \
    pytest \
    python-dotenv \
    scikit-learn \
    scipy \
    seaborn \
    sqlalchemy \
    statsmodels \
    streamlit \
    xgboost

# Install Go
RUN wget https://go.dev/dl/go1.20.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.20.linux-amd64.tar.gz \
    && rm go1.20.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH=$PATH:/root/.cargo/bin

# Install Java
RUN apt-get update && apt-get install -y openjdk-17-jdk maven gradle \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install .NET SDK
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y dotnet-sdk-7.0 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install useful CLI tools
RUN apt-get update && apt-get install -y \
    fd-find \
    fzf \
    htop \
    ripgrep \
    tmux \
    vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install VS Code Server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Configure SSH
RUN mkdir -p /var/run/sshd
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# Set up a new user
ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME:$USERNAME" | chpasswd \
    && usermod -aG sudo $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Setup user's environment
USER $USERNAME
WORKDIR /home/$USERNAME

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Setup code-server config for the user
RUN mkdir -p /home/$USERNAME/.config/code-server
RUN echo "bind-addr: 0.0.0.0:8069" > /home/$USERNAME/.config/code-server/config.yaml
RUN echo "auth: password" >> /home/$USERNAME/.config/code-server/config.yaml
RUN echo "password: vscode" >> /home/$USERNAME/.config/code-server/config.yaml
RUN echo "cert: false" >> /home/$USERNAME/.config/code-server/config.yaml

# Set up workspace directory
RUN mkdir -p /home/$USERNAME/workspace
WORKDIR /home/$USERNAME/workspace

# Switch back to root for final setup
USER root

# Create and set ownership for VS Code extensions directory
RUN mkdir -p /home/$USERNAME/.local/share/code-server/extensions
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/.local

# Expose SSH port
EXPOSE 22
# Expose code-server port
EXPOSE 8080

# Create startup script
RUN echo '#!/bin/bash\n\
    service ssh start\n\
    service docker start\n\
    service postgresql start\n\
    echo "VS Code Server ready! Connect via SSH or visit http://localhost:8080 for web access"\n\
    sudo -u '$USERNAME' code-server --host 0.0.0.0 --port 8069 /home/'$USERNAME'/workspace\n\
    ' > /start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]