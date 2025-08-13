# Agent-to-Agent Protocol (A2A)

## Introduction

The Agent-to-Agent (A2A) protocol, announced by Google on April 9, 2025, represents a paradigm shift in how AI agents communicate and collaborate. Unlike MCP which focuses on connecting models to tools, A2A enables direct agent-to-agent communication.

## The Vision

A2A envisions a future where AI agents can:
- Discover each other's capabilities
- Negotiate interaction terms
- Collaborate on complex tasks
- Maintain security and privacy

```{epigraph}
"A2A is to agent communication what HTTP is to web communication - a foundational protocol for the agent era."

-- Google A2A Team
```

## Core Concepts

### 1. Agent Identity

Every A2A agent has a unique identity expressed through an **Agent Card**:

```json
{
  "name": "DataAnalysisAgent",
  "version": "1.0.0",
  "description": "Specialized in data analysis and visualization",
  "capabilities": [
    "data_cleaning",
    "statistical_analysis",
    "visualization"
  ],
  "endpoints": {
    "sync": "https://api.example.com/a2a/sync",
    "async": "https://api.example.com/a2a/async",
    "stream": "https://api.example.com/a2a/stream"
  },
  "authentication": {
    "type": "oauth2",
    "scopes": ["read", "analyze"]
  }
}
```

### 2. Communication Patterns

A2A supports three primary communication patterns:

#### Synchronous Communication
```python
# Request-Response pattern
response = await agent.call(
    target="DataAnalysisAgent",
    method="analyze",
    params={"data": dataset}
)
```

#### Streaming (SSE)
```python
# Real-time updates
async for event in agent.stream(
    target="DataAnalysisAgent",
    method="monitor",
    params={"metrics": ["cpu", "memory"]}
):
    process_event(event)
```

#### Asynchronous Push
```python
# Long-running tasks with callbacks
task_id = await agent.submit(
    target="DataAnalysisAgent",
    method="deep_analysis",
    params={"data": large_dataset},
    callback_url="https://my-service.com/callback"
)
```

### 3. Task Lifecycle

A2A defines a clear task lifecycle:

```{mermaid}
stateDiagram-v2
    [*] --> Submitted
    Submitted --> Working
    Working --> Completed
    Working --> Failed
    Completed --> [*]
    Failed --> [*]
```

## Protocol Architecture

### Technology Stack
- **Transport**: HTTP/HTTPS
- **Messaging**: JSON-RPC 2.0
- **Streaming**: Server-Sent Events (SSE)
- **Authentication**: OAuth 2.0, API Keys, mTLS

### Message Format

```json
{
  "jsonrpc": "2.0",
  "method": "task.submit",
  "params": {
    "agent": "DataAnalysisAgent",
    "action": "analyze",
    "input": {
      "data_source": "s3://bucket/data.csv",
      "analysis_type": "regression"
    }
  },
  "id": "task-123"
}
```

## Implementation Example

Here's a simple A2A agent in Python:

```python
from a2a import Agent, Task, AgentCard

class DataAnalysisAgent(Agent):
    def __init__(self):
        super().__init__(
            card=AgentCard(
                name="DataAnalysisAgent",
                capabilities=["analyze", "visualize"]
            )
        )
    
    async def handle_analyze(self, task: Task):
        # Process the analysis request
        data = task.input["data"]
        result = perform_analysis(data)
        
        # Update task status
        await task.update_status("working", progress=0.5)
        
        # Complete task
        await task.complete(result)
    
    async def handle_visualize(self, task: Task):
        # Create visualization
        pass
```

## A2A Ecosystem

### Official Support

The protocol is backed by 150+ organizations including:

**Technology Partners**: 
- Atlassian, Box, Cohere, Intuit
- MongoDB, PayPal, Salesforce, SAP
- ServiceNow, Workday

**Service Providers**:
- Accenture, BCG, Capgemini
- Deloitte, HCLTech, Infosys
- KPMG, McKinsey, PwC, TCS

### Linux Foundation

In June 2025, Google donated A2A to the Linux Foundation, ensuring:
- Open governance
- Community-driven development
- Long-term sustainability

## Use Cases

### 1. Multi-Stage Data Pipeline
```python
# Agents collaborate on data processing
collector = Agent("DataCollector")
cleaner = Agent("DataCleaner")
analyzer = Agent("DataAnalyzer")
reporter = Agent("ReportGenerator")

# Chain agents together
pipeline = collector >> cleaner >> analyzer >> reporter
result = await pipeline.run(source="api.example.com")
```

### 2. Distributed Research
Multiple specialized agents working together:
- Literature review agent
- Data collection agent
- Analysis agent
- Writing agent

### 3. Enterprise Automation
- Customer service agents
- Order processing agents
- Inventory management agents
- Reporting agents

## A2A vs MCP: When to Use Which?

```{list-table} Protocol Comparison
:header-rows: 1
:widths: 20 40 40

* - Aspect
  - Use MCP When
  - Use A2A When
* - Scope
  - Single agent needs tools/data
  - Multiple agents need to collaborate
* - Complexity
  - Simple tool integration
  - Complex multi-agent orchestration
* - State
  - Stateless operations
  - Stateful, long-running tasks
* - Examples
  - File access, API calls
  - Workflow automation, distributed processing
```

## Security Considerations

A2A implements multiple security layers:

1. **Authentication**: OAuth 2.0, mTLS
2. **Authorization**: Capability-based access control
3. **Encryption**: TLS 1.3 for all communications
4. **Audit**: Comprehensive logging of agent interactions

## Getting Started

### Quick Start
```bash
# Install A2A SDK
pip install a2a-sdk

# Create agent
a2a create my-agent

# Run agent
a2a run my-agent
```

### Next Steps
- Explore {doc}`05a_a2a_implementations`
- Compare with {doc}`05b_a2a_vs_mcp`
- Build your first A2A agent

## Future Directions

A2A is evolving to support:
- **Semantic understanding** between agents
- **Federated learning** across agent networks
- **Cross-protocol bridges** (A2A ↔ MCP)
- **Decentralized agent registries**

## References

- [A2A Protocol Specification](https://github.com/a2aproject/A2A)
- [A2A Python SDK](https://github.com/a2aproject/a2a-python)
- [Linux Foundation AI & Data](https://lfaidata.foundation/projects/a2a)