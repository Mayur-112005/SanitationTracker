# 🌍 Project 36 — Sanitation Project Tracker

**BE IT 2026 | BL&DLT Mini Project | SDG 6: Clean Water and Sanitation**

> **Student:** Prajapati Mayur Suryanath  
> **Roll No.:** 34 | **Group:** 0  
> **Category:** UN Sustainability Development Goals

---

## 📌 Introduction

This mini project implements a **Decentralized Sanitation Project Tracker** on the Ethereum blockchain. It allows community members and organizations to transparently create, fund, and track sanitation and clean water projects — aligned with **UN SDG Goal 6**.

**Related Projects (Dependencies):**
- This project is thematically related to **Project 35 — Water Credit System** (Roll 33, Patil Krantik). Both projects address SDG 6 (Clean Water & Sanitation). The Sanitation Project Tracker can optionally call into a Water Credit System contract to issue water credits upon project completion, creating an end-to-end SDG 6 ecosystem.

---

## 🛠️ Tech Stack

| Tool        | Purpose                              |
|-------------|--------------------------------------|
| Solidity    | Smart contract language              |
| Remix IDE   | Write, compile, and deploy contract  |
| MetaMask    | Browser wallet for signing txns      |
| Sepolia     | Ethereum testnet for deployment      |
| HTML/CSS/JS | Frontend UI (ethers.js)              |

---

## 📂 Project Structure

```
sanitation_project_tracker/
├── contracts/
│   └── SanitationProjectTracker.sol    ← Smart Contract
├── frontend/
│   └── index.html                      ← Web UI (connect MetaMask)
└── README.md
```

---

## ⚙️ Smart Contract Functions

| Function | Description |
|----------|-------------|
| `createProject(name, location, description, fundingGoal)` | Creates a new sanitation project |
| `fundProject(projectId)` | Payable — funds a project with ETH |
| `updateProgress(projectId, progressPercent, note)` | Updates progress (0–100%) — only creator |
| `getStatus(projectId)` | Returns all details of a project |
| `getAllProjects()` | Returns list of all projects |
| `getProjectFunders(projectId)` | Returns all funders of a project |
| `getMyContribution(projectId)` | Returns caller's contribution to a project |
| `cancelProject(projectId)` | Cancels a proposed project — only creator |

---

## 🚀 Deployment Steps (Remix + MetaMask + Sepolia)

### Step 1 — Setup MetaMask
1. Install [MetaMask](https://metamask.io/) extension
2. Add **Sepolia Testnet** (Settings → Networks → Add Network)
3. Get free test ETH from [Sepolia Faucet](https://sepoliafaucet.com/)

### Step 2 — Deploy in Remix
1. Go to [remix.ethereum.org](https://remix.ethereum.org)
2. Create new file → paste `SanitationProjectTracker.sol`
3. Compile (Solidity 0.8.x)
4. Deploy tab → Environment: **Injected Provider - MetaMask**
5. Select Sepolia in MetaMask → Deploy
6. Copy the deployed **Contract Address**

### Step 3 — Connect Frontend
1. Open `frontend/index.html` in a browser
2. Paste your **Contract Address** into the `CONTRACT_ADDRESS` variable in the `<script>` section
3. Click **Connect MetaMask** → interact with all functions

---

## 🖥️ Frontend Features

- ✅ **Create Project** — name, location, description, funding goal
- ✅ **Fund Project** — send ETH to any project
- ✅ **Update Progress** — slider (0–100%) + progress note (creator only)
- ✅ **Get Status** — view full project details
- ✅ **All Projects Dashboard** — live list with progress bars & badges
- ✅ **My Contribution** — check your own contribution to a project

---

## 📋 College Documentation Format

- **Title:** Sanitation Project Tracker — SDG 6
- **Objective:** Build a decentralized blockchain application to track sanitation infrastructure projects transparently.
- **Introduction:** [See above — mention dependency on Project 35]
- **System Design:** Smart contract → Remix deploy → MetaMask → HTML frontend
- **Testing:** Deployed on Sepolia testnet; tested all 4 core functions
- **Conclusion:** Blockchain ensures immutable, transparent project tracking for SDG 6.

---



---

*Built with ❤️ for SDG 6 — Clean Water and Sanitation*
