<!-- TRELLIS:START -->
# Trellis Instructions

These instructions are for AI assistants working in this project.

This project is managed by Trellis. The working knowledge you need lives under `.trellis/`:

- `.trellis/workflow.md` — development phases, when to create tasks, skill routing
- `.trellis/spec/` — package- and layer-scoped coding guidelines (read before writing code in a given layer)
- `.trellis/workspace/` — per-developer journals and session traces
- `.trellis/tasks/` — active and archived tasks (PRDs, research, jsonl context)

If a Trellis command is available on your platform (e.g. `/trellis:finish-work`, `/trellis:continue`), prefer it over manual steps. Not every platform exposes every command.

If you're using Codex or another agent-capable tool, additional project-scoped helpers may live in:
- `.agents/skills/` — reusable Trellis skills
- `.codex/agents/` — optional custom subagents

<!-- TRELLIS:END -->

# 專案定位與 AI 助理規範 (Project Definition & AI Guidelines)

- **純粹的 Hugo 部落格**：本專案是一個純粹的 Hugo 靜態部落格（主題為大象體操與張凱婷的追星日記），不是複雜的軟體專案。
- **僅使用 Hugo 指令**：禁止在本專案中編寫複雜的程式碼或額外的 Shell 驗證指令碼。所有的建置、測試、發佈工作皆應只使用標準 Hugo 指令（例如 `hugo`、`hugo server` 等）。
- **Trellis 與 Kiro 輔助定位**：`.trellis` 與 `.kiro` 目錄僅用於輔助規劃、撰寫與校對部落格文章，並在文章完成後發佈。請勿引進過度設計的軟體工程架構或複雜驗證腳本。
