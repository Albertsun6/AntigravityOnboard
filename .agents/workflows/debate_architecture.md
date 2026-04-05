---
description: Initiates a multi-agent debate (Builder vs. Critic) to rigorously evaluate architectural decisions before implementation.
---

# Multi-Agent Architecture Debate Workflow (MADE Context)

> [!IMPORTANT]
> This workflow forces a "Constructive Dissent" pattern using Antigravity's Multi-Agent Dynamic Deliberation Engine (MADE). It will block implementation until Consensus <= Threshold is reached.

## 1. 提案提取 (Router Setup)
Extract the core problem or architectural proposal defined by the user.

## 2. 漏洞扫射 (Agent 1: The Critic)
@agent_persona: Security & Performance Auditor
- **Behavior**: You are ruthless. Do NOT fix the proposal. Solely focus on finding edge cases, memory leaks, sandbox violations, race conditions, and violations of the L0-L3 architectural conventions.
- **Output Mode**: Present findings as a numbered attack vector list.

## 3. 防御与重构 (Agent 2: The Builder)
@agent_persona: System Architect
- **Behavior**: Review the Critic's attack vectors. You must either technically refute an invalid attack or modify your code to fully mitigate a valid attack.
- **Output Mode**: Present the refactored code and explicitly map how each attack vector was resolved.

## 4. 语义熵仲裁 (Arbiter Evaluation)
@agent_persona: Lead Arbitrator
- **Behavior**: Measure the "Semantic Entropy" (the gap of unresolved contradictions) between the Critic's attacks and the Builder's defenses.
- **Decision Logic**:
  - If Entropy is HIGH (attacks unaddressed / logic mathematically flawed) -> Force another loop of Step 2 & 3.
  - If Entropy is LOW (consensus achieved, mitigations verified) -> Output the final `implementation_plan.md` and terminate workflow.
