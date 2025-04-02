# Ultimate VS Code Remote Development Environment

This repository provides a complete remote development environment for VS Code where your local machine acts purely as a thin client. All development resources, data processing, and computation happen on the remote server, keeping your local machine free from heavy resource usage.

## Features

- Complete development environment with multiple programming languages and tools
- Configured for data science, web development, and general software engineering
- Pre-installed extensions for working with CSV, SQLite, Parquet, PostgreSQL, Mermaid diagrams, and more
- Docker-in-Docker support for container-based development
- Multiple connection options (SSH or web browser)
- All data and processing stay on the remote server

## Connection Options

### Option 1: Remote-SSH Extension (Recommended)

1. Install the "Remote - SSH" extension in VS Code on your local machine
2. Configure your SSH connection in VS Code:
   ```
   Host vscode-remote
       HostName your-server-ip
       User developer
       Port 2222
       Password vscode
   ```
3. Connect via "Remote-SSH: Connect to Host..." command
4. When prompted, enter the password: `vscode`

### Option 2: Web Browser Interface

1. Navigate to `http://your-server-ip:8080` in any web browser
2. When prompted, enter the password: `vscode`

## Deployment Instructions

### Using Docker Compose (Recommended)

1. Install Docker and Docker Compose on your server
2. Clone this repository to your server
3. Run:
   ```bash
   docker-compose up -d
   ```
4. Connect using one of the connection options above

### Using Docker Directly

1. Install Docker on your server
2. Clone this repository to your server
3. Build the Docker image:
   ```bash
   docker build -t ultimate-vscode .
   ```
4. Run the container:
   ```bash
   docker run -d \
     --name vscode-remote-dev \
     -p 8080:8080 \
     -p 2222:22 \
     -v vscode-workspace:/home/developer/workspace \
     -v /var/run/docker.sock:/var/run/docker.sock \
     --restart unless-stopped \
     ultimate-vscode
   ```
5. Connect using one of the connection options above

## Installed Tools and Languages

- **Languages**: Python, Node.js, Go, Rust, Java, .NET
- **Data Tools**: PostgreSQL, SQLite, Pandas, NumPy, DuckDB, PyArrow
- **DevOps**: Docker, Git
- **Shells**: Bash, Zsh (with Oh My Zsh)
- **Editors**: Nano, Vim, VS Code Server
- **Utilities**: tmux, htop, ripgrep, fzf

## Recommended VS Code Extensions to Install

Once connected to your remote environment, install these extensions:

- **Roo Code** (RooVeterinaryInc.roo-cline)
- **Rainbow CSV** (mechatroner.rainbow-csv)
- **Data Preview** (RandomFractalsInc.vscode-data-preview)
- **Parquet Visualizer** (lucien-martijn.parquet-visualizer)
- **SQLite Viewer** (qwtel.sqlite-viewer)
- **PostgreSQL** (ms-ossdata.vscode-postgresql)
- **Markdown Preview Mermaid Support** (bierner.markdown-mermaid)
- **PDF Viewer** (tomoki1207.pdf)

## Security Notes

- Default credentials are included for convenience but should be changed for production use
- Consider setting up SSH key authentication instead of password-based authentication
- Restrict access to the container's ports using a firewall
- For enhanced security, configure TLS for the web interface

## Resource Allocation

By default, the container is configured with:
- 8GB RAM limit (4GB guaranteed)
- 4 CPU cores limit (2 cores guaranteed)

Adjust these limits in the docker-compose.yml file based on your server's capabilities.