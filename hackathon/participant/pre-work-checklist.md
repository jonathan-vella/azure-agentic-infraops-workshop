# Pre-Work Checklist

> **Complete these items BEFORE the hackathon** to ensure a smooth start.
>
> Estimated time: 30-45 minutes

## Required Software

### 1. Docker Desktop

GitHub Copilot custom agents run inside a Dev Container. You need Docker.

**Install:**

- **Windows/Mac**: [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- **Linux**: [Docker Engine](https://docs.docker.com/engine/install/)

**Verify:**

```bash
docker --version
# Expected: Docker version 24.x or newer
```

**Alternatives** (if Docker Desktop licensing is an issue):

- [Rancher Desktop](https://rancherdesktop.io/)
- [Podman Desktop](https://podman-desktop.io/)
- [Colima](https://github.com/abiosoft/colima) (macOS/Linux)

---

### 2. Visual Studio Code

**Install:** [VS Code](https://code.visualstudio.com/)

**Required Extensions:**

| Extension | ID | Purpose |
|-----------|----|---------||
| Dev Containers | `ms-vscode-remote.remote-containers` | Run Dev Container |
| GitHub Copilot | `github.copilot` | AI assistance |
| GitHub Copilot Chat | `github.copilot-chat` | Agent interactions |
| Bicep | `ms-azuretools.vscode-bicep` | Bicep language support |
| Azure Account | `ms-vscode.azure-account` | Azure authentication |

**Install all at once:**

```bash
code --install-extension ms-vscode-remote.remote-containers
code --install-extension github.copilot
code --install-extension github.copilot-chat
code --install-extension ms-azuretools.vscode-bicep
code --install-extension ms-vscode.azure-account
```

---

### 3. Git

**Install:**

- **Windows**: [Git for Windows](https://gitforwindows.org/)
- **Mac**: `brew install git` or Xcode Command Line Tools
- **Linux**: `sudo apt install git` or equivalent

**Verify:**

```bash
git --version
# Expected: git version 2.40 or newer
```

---

## Required Accounts

### 1. GitHub Account with Copilot

You need an active GitHub Copilot subscription (Individual, Business, or Enterprise).

**Verify:**

1. Go to [github.com/settings/copilot](https://github.com/settings/copilot)
2. Confirm your subscription is active
3. Ensure "Copilot Chat in the IDE" is enabled

> ⚠️ **No Copilot subscription?** Contact your facilitator — they may have trial licenses available.

---

### 2. Azure Subscription

You need an Azure subscription with **Contributor** access to create resources.

**Options:**

- Use your organization's Dev/Test subscription
- [Azure Free Account](https://azure.microsoft.com/free/) (includes $200 credit)
- [Visual Studio subscription benefits](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/)

**Verify:**

```bash
az login
az account list --output table
```

You should see at least one subscription where you have Contributor access.

---

## Pre-Clone the Repository

Clone the repository before the event to avoid network congestion:

```bash
# Clone to your preferred location
git clone https://github.com/jonathan-vella/azure-agentic-infraops-workshop.git
cd azure-agentic-infraops-workshop

# Open in VS Code
code .
```

---

## Pre-Build the Dev Container (Recommended)

Building the Dev Container takes 3-5 minutes. Do this ahead of time:

1. Open the cloned repo in VS Code
2. Press `F1` → type "Dev Containers: Reopen in Container"
3. Wait for the container to build (watch the progress in the terminal)
4. Once complete, verify tools are installed:

```bash
# Inside the Dev Container terminal
az version
bicep --version
pwsh --version
```

**Expected output:**

- Azure CLI 2.50+
- Bicep CLI 0.20+
- PowerShell 7+

---

## Pre-Authenticate with Azure

While in the Dev Container, authenticate with Azure:

```bash
# Login to Azure
az login

# Set your preferred subscription
az account set --subscription "<your-subscription-id>"

# Verify
az account show --query "{Name:name, SubscriptionId:id, TenantId:tenantId}" -o table
```

---

## Network Requirements

Ensure your network allows connections to:

| Service | Domains | Ports |
|---------|---------|-------|
| GitHub | `github.com`, `api.github.com` | 443 |
| GitHub Copilot | `copilot.github.com`, `*.githubusercontent.com` | 443 |
| Azure | `*.azure.com`, `*.microsoft.com`, `login.microsoftonline.com` | 443 |
| Docker | `docker.io`, `registry-1.docker.io` | 443 |

---

## Checklist Summary

- [ ] **Docker Desktop** installed and running
- [ ] **VS Code** installed with required extensions
- [ ] **Git** installed
- [ ] **GitHub account** with active Copilot subscription
- [ ] **Azure subscription** with Contributor access
- [ ] **Repository cloned** locally
- [ ] **Dev Container built** (F1 → Reopen in Container)
- [ ] **Azure CLI authenticated** (`az login` successful)
- [ ] **Network access** verified (no proxy issues)

---

## Troubleshooting

### Docker won't start

- **Windows**: Ensure WSL 2 is installed and enabled
- **Mac**: Ensure virtualization is enabled in System Preferences
- **All**: Try restarting Docker Desktop

### Copilot not working

1. Sign out of GitHub in VS Code
2. Sign back in with the account that has Copilot
3. Reload VS Code window (`F1` → "Developer: Reload Window")

### Azure CLI login fails

```bash
# Try device code flow (works behind corporate proxies)
az login --use-device-code
```

### Dev Container build fails

- Ensure Docker is running
- Try: `F1` → "Dev Containers: Rebuild Container Without Cache"
- Check Docker has at least 4GB memory allocated

---

## Questions?

Contact your facilitator if you encounter issues during pre-work setup.
