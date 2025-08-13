# The AI Agent Ecosystem Book

A comprehensive guide to the AI agent ecosystem, covering MCP, A2A protocols, and the future of multi-agent systems.

## Building the Book

### Prerequisites

```bash
pip install -r requirements.txt
```

### Build HTML Version

```bash
jupyter-book build .
```

The HTML output will be in `_build/html/`.

### Build PDF Version

```bash
jupyter-book build . --builder pdflatex
```

## View Locally

```bash
# After building
open _build/html/index.html

# Or run a local server
python -m http.server -d _build/html 8000
```

## Deploy to GitHub Pages

```bash
# Configure GitHub Pages in repo settings first
ghp-import -n -p -f _build/html
```

## Structure

- `intro.md` - Book introduction and overview
- `chapters/` - Main content chapters
- `appendices/` - Additional resources
- `references/` - Bibliography
- `images/` - Figures and diagrams
- `_config.yml` - Jupyter Book configuration
- `_toc.yml` - Table of contents

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This work is licensed under CC BY-SA 4.0.