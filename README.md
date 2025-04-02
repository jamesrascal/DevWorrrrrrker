# Development Container with Roo Code and Data Tools

This repository contains a development container configuration for VS Code that includes:

- [Roo Code](https://github.com/RooVetGit/Roo-Code) - AI-powered autonomous coding agent
- Tools for working with CSV, Parquet, SQLite, and PostgreSQL data
- Mermaid diagram support
- PDF viewer

## Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop) installed on your machine
- [Visual Studio Code](https://code.visualstudio.com/)
- [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension for VS Code

## Getting Started

1. Open this project in VS Code
2. When prompted, click "Reopen in Container"
   - Alternatively, press F1 and select "Remote-Containers: Reopen in Container"
3. Wait for the container to build (this may take several minutes the first time)

## Included Extensions

### AI Coding Assistant
- Roo Code (prev. Roo Cline) - A whole dev team of AI agents in your editor

### Data Tools
- Rainbow CSV - Colorizes CSV files for better readability
- Data Preview - For viewing large data files
- Parquet Visualizer - Inspect and query parquet files
- Parquet Viewer - Views Apache Parquet files as JSON
- SQLite Viewer - Explore and query SQLite databases
- VSCode SQLite - SQLite database management
- PostgreSQL - Integration with PostgreSQL databases

### Visualization
- Markdown Preview Mermaid Support - Preview Mermaid diagrams in markdown
- VSCode Mermaid Editor - Live editor for Mermaid diagrams
- PDF Viewer - View PDF files directly in VS Code

### Development Tools
- Python - Python language support
- Pylance - Python language server
- Jupyter - Jupyter notebook support

## Using the Container

All extensions run on the remote container, reducing resource usage on your local machine. The container includes:

- Python 3.10 with data science packages (pandas, numpy, matplotlib, etc.)
- Node.js and npm with SQL formatter
- PostgreSQL database
- Docker-in-Docker support

## Project Structure

```
project-root/
├── .devcontainer/     # Container configuration
│   ├── devcontainer.json
│   └── Dockerfile
├── .vscode/           # VS Code settings
│   └── settings.json
├── data/              # Data storage
│   ├── csv/           # CSV files
│   ├── parquet/       # Parquet files
│   └── sqlite/        # SQLite databases
├── notebooks/         # Jupyter notebooks
├── scripts/           # Python scripts
└── README.md          # This file
```