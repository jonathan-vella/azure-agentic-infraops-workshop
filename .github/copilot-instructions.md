# Agentic InfraOps - Copilot Instructions

> **Agentic InfraOps** — Azure infrastructure engineered by agents. Verified. Well-Architected. Deployable.

## Core Mission

Transform Azure infrastructure requirements into deploy-ready Bicep code using coordinated AI agents, aligned with
Azure Well-Architected Framework (WAF) and Azure Verified Modules (AVM).

## VS Code 1.109+ Agent Orchestration

This project implements the **Conductor pattern** from VS Code 1.109's agent orchestration features.
The `InfraOps Conductor` agent coordinates the 7-step workflow with mandatory human approval gates.

> **⚠️ REQUIRED SETTING**: Enable custom agents as subagents in your **User Settings**:
>
> ```json
> {
>   "github.copilot.chat": {
>     "customAgentInSubagent": {
>       "enabled": true
>     }
>   }
> }
> ```
>
> Without this, the Conductor cannot delegate to specialized agents.

### Quick Start with Conductor

1. Open VS Code Chat (`Ctrl+Shift+I`)
2. Select **InfraOps Conductor** from agent dropdown
3. Describe your Azure infrastructure project
4. The Conductor guides you through all 7 steps with approval gates

### Agent Invocation Methods

| Method               | Description                           |
| -------------------- | ------------------------------------- |
| `Ctrl+Shift+A`       | Agent picker (all agents)             |
| `InfraOps Conductor` | Master orchestrator (recommended)     |
| Individual agents    | Direct invocation for specific phases |

## Agent Workflow (7 Steps)

Agents coordinate through artifact handoffs via `.github/agents/*.agent.md`:

1. **Requirements** (`requirements` agent) → `01-requirements.md`
2. **Architecture** (`architect` agent) → `02-architecture-assessment.md` + cost estimates via Azure Pricing MCP
3. **Design Artifacts** (`design` agent) → `03-des-*.{py,png,md}` (optional, uses azure-diagrams/azure-adr skills)
4. **Planning** (`bicep-plan` agent) → `04-implementation-plan.md` + governance constraints
5. **Implementation** (`bicep-code` agent) → Bicep templates in `infra/bicep/{project}/`
6. **Deploy** (`deploy` agent) → `06-deployment-summary.md` + resource validation
7. **As-Built** (`azure-diagrams`, `azure-adr`, `azure-workload-docs` skills) → `07-*.md` documentation suite

**Key Rule**: Each agent saves outputs to `agent-output/{project}/` and passes context via handoff prompts.

### Conductor Approval Gates

The InfraOps Conductor enforces mandatory pause points:

| Gate | After Step   | User Action                         |
| ---- | ------------ | ----------------------------------- |
| 1    | Requirements | Confirm requirements complete       |
| 2    | Architecture | Approve WAF assessment              |
| 3    | Planning     | Approve implementation plan         |
| 4    | Pre-Deploy   | Approve lint/what-if/review results |
| 5    | Post-Deploy  | Verify deployment                   |

### Optional Validation Cycle (Power Users)

**OPTIONAL**: Step 5 can run an early validation cycle for complex deployments.

Most users skip this - Deploy agent (Step 6) runs what-if automatically as preflight.

```
@bicep-lint-subagent    → Syntax validation (bicep lint, bicep build)
@bicep-whatif-subagent  → Deployment preview (az deployment what-if)
@bicep-review-subagent  → Code review (AVM standards, security, naming)
```

**When to use**: Complex deployments, learning scenarios, power users wanting early feedback  
**When to skip**: Simple deployments (default), faster workflow

## Critical Defaults

Source of truth: [`.github/agents/_shared/defaults.md`](agents/_shared/defaults.md)

| Setting             | Value                                          | Notes                                              |
| ------------------- | ---------------------------------------------- | -------------------------------------------------- |
| **Default Region**  | `swedencentral`                                | EU GDPR-compliant; alt: `germanywestcentral`       |
| **Required Tags**   | `Environment`, `ManagedBy`, `Project`, `Owner` | All resources must include these tags              |
| **Unique Suffix**   | `uniqueString(resourceGroup().id)` in bicep    | Generate once in `main.bicep`, pass to all modules |
| **Key Vault Name**  | `kv-{short}-{env}-{suffix}` (≤24 chars)        | Always include suffix to guarantee uniqueness      |
| **Storage Account** | `st{short}{env}{suffix}` (≤24 chars, no `-`)   | Lowercase+numbers only; no hyphens                 |
| **SQL Server Auth** | Azure AD-only (`azureADOnlyAuthentication`)    | No SQL auth usernames/passwords                    |
| **Zone Redundancy** | App Service Plans: P1v4+ only                  | Not S1/P1v2; required for HA                       |

## Code Style

| Language | Tab Size | Line Length | Key Rules |
| --- | --- | --- | --- |
| **Bicep** | 2 | 120 | AVM-first, `uniqueSuffix` pattern, required tags |
| **Python** | 4 | 120 | Ruff (E, W, F, I, B, C4, UP, SIM), double quotes |
| **PowerShell** | 4 | 120 | Verb-Noun naming, `$ErrorActionPreference = 'Stop'` |
| **Markdown** | 2 | 120 | markdownlint-cli2 (MD013=120), no bare URLs |
| **JavaScript** | 2 | 120 | ESM (`.mjs`), Prettier default formatter |

**Commits**: Conventional Commits enforced via commitlint + lefthook (`feat:`, `fix:`, `docs:`, etc.). Max header 100 chars.

Configs: [commitlint.config.js](../commitlint.config.js),
[.markdownlint-cli2.jsonc](../.markdownlint-cli2.jsonc),
[pyproject.toml](../pyproject.toml), [lefthook.yml](../lefthook.yml)

## Architecture Essentials

### Instruction Files

File-type-specific rules in `.github/instructions/` are applied via `.gitattributes`:

| Instruction File                            | Applies To                   | Key Rules                              |
| ------------------------------------------- | ---------------------------- | -------------------------------------- |
| `bicep-code-best-practices.instructions.md` | `**/*.bicep`                 | AVM-first, uniqueSuffix, required tags |
| `markdown.instructions.md`                  | `**/*.md`                    | Formatting, link style, structure      |
| `agents-definitions.instructions.md`        | `**/*.agent.md`              | Front matter, tools, handoffs          |
| `artifact-generation.instructions.md`       | `**/agent-output/**/*.md`    | Template compliance for artifact output |
| `artifact-h2-reference.instructions.md`     | `**/agent-output/**/*.md`    | Required H2 headings per artifact type |
| `governance-discovery.instructions.md`      | `**/04-governance-*.md`      | ARG query required, discovery source   |
| `cost-estimate.instructions.md`             | `**/cost-estimate.md`        | Cost estimate documentation standards  |
| `workload-documentation.instructions.md`    | `**/agent-output/**/07-*.md` | As-built documentation                 |
| `docs.instructions.md`                      | `docs/**/*.md`               | User-facing documentation standards    |
| `github-actions.instructions.md`            | `.github/workflows/*.yml`    | CI/CD pipeline standards               |

### Template-First Output Generation

Agents MUST follow template structure when generating artifacts:

1. **Read template**: Load `.github/templates/{artifact}.template.md`
2. **Match H2 headings**: Use exact text and order from template
3. **Anchor rule**: Add custom sections only AFTER the last required H2
4. **Attribution**: Include `> Generated by {agent} agent | {YYYY-MM-DD}`

### Artifact Output Structure

All agent outputs go to `agent-output/{project}/` with strict naming and H2 structure:

- **01-requirements.md**: Project Overview, Functional Requirements, NFRs, Compliance, Budget, Operational, Regional
- **02-architecture-assessment.md**: Requirements Validation, Executive Summary, WAF Pillars, SKU Recs, Decisions, Handoff
- **04-implementation-plan.md**: Overview, Resource Inventory, Module Structure, Tasks, Dependencies, Naming, Security
- **04-governance-constraints.md**: Discovery Source, Azure Policy Compliance, Required Tags, Security, Cost, Network Policies

See [validation rules](../scripts/validate-artifact-templates.mjs) for all artifacts.

### Handoff Pattern

Each agent defines `handoffs` in its agent definition linking to the next agent with context:

```yaml
handoffs:
  - label: "Create WAF Assessment"
    agent: architect
    prompt: "Assess the requirements above for WAF alignment..."
    send: true
```

Data flows through artifact files + agent context, not via copy-paste.

## Developer Workflows

### Running Agents

`Ctrl+Shift+A` → Select agent → Type prompt → Approve before execution

### Build & Test

```bash
# Install dependencies and git hooks
npm install            # Node deps + lefthook install
pip install -r requirements.txt  # Python deps (diagrams, checkov)

# Lint markdown
npm run lint:md
npm run lint:md:fix     # Auto-fix

# Validate artifact H2 structure
npm run lint:artifact-templates
npm run lint:cost-estimate-templates

# Lint Bicep templates
bicep lint infra/bicep/{project}/main.bicep
bicep build infra/bicep/{project}/main.bicep

# Preview Azure deployment
az account set --subscription "<sub-id>"
az deployment group what-if --resource-group <rg> --template-file main.json

# Validation scripts (run individually)
node scripts/validate-agent-frontmatter.mjs
node scripts/validate-skills-format.mjs
node scripts/validate-vscode-config.mjs
node scripts/validate-no-deprecated-refs.mjs
```

### MCP Integration

The Azure Pricing MCP server (`mcp/azure-pricing-mcp/`) integrates with agents to fetch real-time SKU pricing:

- Used by `architect` agent for cost estimations in WAF assessments
- Used by `bicep-plan` agent for SKU recommendations
- Pre-configured in `.vscode/mcp.json`; runs via `mcp/azure-pricing-mcp/.venv/bin/python`

## Key Files & Directories

| File/Dir                                  | Purpose                                                     |
| ----------------------------------------- | ----------------------------------------------------------- |
| `.github/agents/*.agent.md`               | Agent definitions with front matter (name, tools, handoffs) |
| `.github/agents/_shared/defaults.md`      | Shared config: regions, tags, naming conventions, security  |
| `.github/instructions/`                   | File-type rules (Bicep, Markdown, PowerShell, agents, etc.) |
| `.github/templates/`                      | H2 skeleton files for artifact generation                   |
| `agent-output/{project}/`                 | Project-scoped artifacts (01-07 sequentially)               |
| `infra/bicep/{project}/`                  | Bicep module library (main.bicep + modules/)                |
| `mcp/azure-pricing-mcp/`                  | Azure Pricing MCP server for cost estimation                |
| `.vscode/mcp.json`                        | MCP server configuration (pre-configured)                   |
| `scripts/validate-*.mjs`                  | CI validation scripts (artifacts, frontmatter, skills, etc.)|
| `hackathon/`                              | Hackathon challenges, facilitator/participant materials      |

## Project Structure

```
azure-agentic-infraops-workshop/
├── .github/
│   ├── agents/                    # Agents for core workflow steps
│   │   ├── _shared/defaults.md    # Regions, tags, CAF naming, AVM standards
│   │   ├── _subagents/            # Validation subagents (lint, what-if, review)
│   │   ├── infraops-conductor.agent.md  # Master orchestrator
│   │   ├── requirements.agent.md  # Step 1: Gather infrastructure needs
│   │   ├── architect.agent.md     # Step 2: WAF assessment + cost estimates
│   │   ├── design.agent.md        # Step 3: Architecture diagrams + ADRs
│   │   ├── bicep-plan.agent.md    # Step 4: Implementation planning
│   │   ├── bicep-code.agent.md    # Step 5: Bicep code generation
│   │   ├── deploy.agent.md        # Step 6: Azure deployment
│   │   └── diagnose.agent.md      # Troubleshooting helper
│   ├── skills/                    # 10 reusable skills (azure-diagrams, azure-adr,
│   │                              # azure-workload-docs, orchestration-helper, etc.)
│   ├── instructions/              # 16 file-type rules (applied via .gitattributes)
│   ├── prompts/                   # Reusable prompt files for common workflows
│   ├── templates/                 # H2 skeleton files for artifact generation
│   └── copilot-instructions.md    # THIS FILE
├── agent-output/{project}/        # All agent-generated artifacts (01-07)
├── infra/bicep/                   # Bicep module library
│   └── {project}/                 # Project-specific templates
│       ├── main.bicep             # Entry point (generates uniqueSuffix, orchestrates modules)
│       └── modules/               # Feature modules (networking, compute, data, etc.)
├── mcp/azure-pricing-mcp/         # Azure Pricing MCP server (Python, v3.1.0)
├── hackathon/                     # Hackathon materials (challenges, facilitator, participant)
├── scripts/                       # Validation and workflow automation
│   ├── validate-*.mjs             # CI validators (artifacts, frontmatter, skills, etc.)
│   ├── hackathon/                 # Scoring and governance scripts (PowerShell)
│   └── workflow-generator/        # Mermaid → PNG/GIF animation
└── docs/                          # Repository documentation
```

## Tech Stack

| Category            | Tools                                           |
| ------------------- | ----------------------------------------------- |
| **IaC**             | Bicep (Terraform support planned)               |
| **Automation**      | PowerShell 7+, Azure CLI 2.50+, Bicep CLI 0.20+ |
| **Platform**        | Azure (public cloud)                            |
| **AI**              | GitHub Copilot with custom agents               |
| **Dev Environment** | VS Code Dev Container (Ubuntu 24.04)            |

## Critical Patterns

### Azure Verified Modules (AVM)

**Always prefer AVM modules over raw Bicep resources.**

```bicep
// Use AVM from public registry
module keyVault 'br/public:avm/res/key-vault/vault:0.11.0' = {
  params: { name: kvName, location: location }
}
```

| Resource        | Module Path                                 | Min Version |
| --------------- | ------------------------------------------- | ----------- |
| Key Vault       | `br/public:avm/res/key-vault/vault`         | `0.11.0`    |
| Virtual Network | `br/public:avm/res/network/virtual-network` | `0.5.0`     |
| Storage Account | `br/public:avm/res/storage/storage-account` | `0.14.0`    |
| App Service     | `br/public:avm/res/web/site`                | `0.12.0`    |
| SQL Server      | `br/public:avm/res/sql/server`              | `0.10.0`    |

**Full AVM index**: https://aka.ms/avm/index

### Unique Resource Names

```bicep
// main.bicep - Generate once, pass to ALL modules
var uniqueSuffix = uniqueString(resourceGroup().id)

module keyVault 'modules/key-vault.bicep' = {
  params: { uniqueSuffix: uniqueSuffix }
}

// modules/key-vault.bicep
param uniqueSuffix string
var kvName = 'kv-${take(projectName, 8)}-${environment}-${take(uniqueSuffix, 6)}'
```

### Required Tags on All Resources

```bicep
tags: {
  Environment: 'dev'      // dev, staging, prod
  ManagedBy: 'Bicep'      // or 'Terraform'
  Project: projectName
  Owner: owner
}
```

## Security

| Rule | Enforcement |
| --- | --- |
| HTTPS only, TLS 1.2 minimum | `supportsHttpsTrafficOnly: true`, `minimumTlsVersion: 'TLS1_2'` |
| No public blob access | `allowBlobPublicAccess: false` |
| Managed identities over keys | Prefer `systemAssignedIdentity` / `userAssignedIdentities` |
| Private endpoints for data services | `publicNetworkAccess: 'Disabled'` |
| SQL Azure AD-only auth | `azureADOnlyAuthentication: true` — no SQL passwords |
| AVM mandatory first check | Raw Bicep requires explicit approval + documented justification |
| Secrets never in code | Use Key Vault references; `.gitignore` blocks `*.key`, `*.pem`, `.env` |

## Agent-Specific Guidance

### Requirements Agent

- Captures comprehensive infrastructure needs via `01-requirements.md`
- Hands off to Architect for WAF assessment
- Uses `@plan` context for initial requirements gathering

### Architect Agent

- Creates WAF assessments aligned with Azure Well-Architected Framework
- Integrates Azure Pricing MCP for real-time cost estimates
- Generates `02-architecture-assessment.md` with SKU recommendations
- Hands off to Design agent (optional) or Bicep Plan agent

### Design Agent

- Generates design artifacts for architecture documentation (Step 3)
- Uses `azure-diagrams` skill for Python architecture diagrams
- Uses `azure-adr` skill for Architecture Decision Records
- Creates `03-des-diagram.py`, `03-des-diagram.png`, `03-des-adr-*.md`
- Hands off to Bicep Plan agent for implementation

### Bicep Plan Agent

- Discovers Azure Policy governance constraints (tag requirements, resource types allowed, etc.)
- Creates detailed implementation plans in `04-implementation-plan.md`
- Produces `04-governance-constraints.md` for compliance
- Hands off to Bicep Code agent for implementation

### Bicep Code Agent

- Generates Bicep modules in `infra/bicep/{project}/`
- Follows Azure Verified Modules (AVM) standards
- Ensures unique resource names via suffix pattern
- Produces `05-implementation-reference.md` with validation status
- Hands off to Deploy agent

### Deploy Agent

- Executes `bicep build` and `what-if` analysis before deployment
- Manages Azure authentication and subscription selection
- Generates `06-deployment-summary.md` with deployed resource details
- Validates post-deployment resources

### Diagnose Agent

- Interactive diagnostic agent for Azure resource health assessment
- Guides users through issue identification and remediation planning
- Uses approval-first execution for safety
- Saves diagnostic reports to `agent-output/{project}/`

---

**Mission**: Azure infrastructure engineered by agents—from requirements to deployed templates,
aligned with Well-Architected best practices and Azure Verified Modules.
