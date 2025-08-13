# Model Context Protocol (MCP)

## Introduction

The Model Context Protocol (MCP) is an open standard developed by Anthropic for connecting AI assistants to the systems where data lives. It provides a standardized way for AI models to access tools, data sources, and external systems.

## What is MCP?

MCP enables AI assistants like Claude to interact with:
- Content repositories
- Business tools  
- Development environments
- Databases
- APIs

```{figure} ../images/mcp-architecture.png
:name: mcp-arch
:width: 80%

MCP Architecture Overview
```

## Core Concepts

### 1. Servers
MCP servers expose resources and tools that AI models can use:

```python
# Example MCP server structure
class MCPServer:
    def __init__(self):
        self.resources = []
        self.tools = []
        
    def register_tool(self, tool):
        self.tools.append(tool)
        
    def handle_request(self, request):
        # Process incoming requests
        pass
```

### 2. Clients
MCP clients (like Claude Desktop) connect to servers and use their capabilities.

### 3. Tools
Tools are functions that the AI can call:

```json
{
  "name": "read_file",
  "description": "Read contents of a file",
  "parameters": {
    "path": {"type": "string", "description": "File path"}
  }
}
```

### 4. Resources
Resources are data sources the AI can access:

```json
{
  "uri": "file:///path/to/document.md",
  "type": "text/markdown",
  "name": "Project Documentation"
}
```

## Key Features

### Security
- Controlled access to system resources
- Permission-based operations
- Sandboxed execution

### Flexibility
- Support for various transport protocols (stdio, SSE)
- Language-agnostic design
- Extensible architecture

### Standardization
- Consistent interface across different tools
- JSON-RPC based communication
- Well-defined schemas

## MCP vs Traditional APIs

| Feature | MCP | Traditional API |
|---------|-----|----------------|
| **Purpose** | AI-system integration | General data exchange |
| **Design** | Tool/resource focused | Endpoint focused |
| **Discovery** | Built-in capability discovery | Often manual/documented |
| **Context** | Maintains conversation context | Stateless |

## Implementation Example

Here's a simple MCP server in Python:

```python
import asyncio
from mcp import Server, Tool

# Create server
server = Server("my-mcp-server")

# Define a tool
@server.tool()
async def get_weather(location: str) -> str:
    """Get weather for a location"""
    # Implementation here
    return f"Weather in {location}: Sunny, 72°F"

# Run server
if __name__ == "__main__":
    asyncio.run(server.run())
```

## Getting Started

### Installation
```bash
# Python
pip install mcp

# Node.js
npm install @modelcontextprotocol/sdk
```

### Configuration
Add to Claude Desktop config:
```json
{
  "servers": {
    "my-server": {
      "command": "python",
      "args": ["my_server.py"]
    }
  }
}
```

## Popular MCP Servers

Based on our analysis, here are the most popular MCP servers:

1. **Filesystem** - File operations
2. **Git** - Repository management
3. **GitHub** - GitHub integration
4. **PostgreSQL** - Database access
5. **Slack** - Team communication

## Next Steps

In the following sections, we'll explore:
- {doc}`04a_mcp_servers` - Comprehensive list of implementations
- {doc}`04b_mcp_architecture` - Deep technical dive
- Building your own MCP server

## References

- [Official MCP Documentation](https://modelcontextprotocol.io)
- [MCP GitHub Repository](https://github.com/modelcontextprotocol/servers)
- [MCP SDK Documentation](https://modelcontextprotocol.io/docs)