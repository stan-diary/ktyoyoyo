# 追星日記 | Elephant Gym & 張凱婷

這是一個使用 Hugo 建立的純靜態部落格，專門用來記錄關於台灣數字搖滾樂團「大象體操」(Elephant Gym) 以及貝斯手「張凱婷」(KT Chang) 的點點滴滴。

## 🌐 網站連結

👉 **[https://stan-diary.github.io/ktyoyoyo/](https://stan-diary.github.io/ktyoyoyo/)**

## 🛠 技術棧與架構

- **Framework**: [Hugo](https://gohugo.io/) (Static Site Generator)
- **Theme**: [PaperMod](https://github.com/adityatelange/hugo-PaperMod)
- **Deployment**: GitHub Actions ➡️ GitHub Pages

本專案採用純靜態架構，由 AI Assistant (`stan-diary-ai`) 輔助維護與建置。

## 📝 開發與發布指南

本專案遵循「純淨 Hugo 部落格」原則，所有文章與設定的更動皆透過標準的 Hugo 指令處理，不依賴複雜的外部軟體腳本。

1. **新增文章**：撰寫 Markdown 檔案並放置於 `content/posts/` 目錄中，並確保 YAML Front Matter 格式正確。
2. **本地預覽**：在終端機執行 `hugo server`，即可在 `http://localhost:1313/` 預覽畫面。
3. **發布部署**：完成文章後，將變更 commit 並 push 至 `main` 分支。GitHub Actions 會自動攔截 push 事件，將 Markdown 檔編譯為靜態網頁並發布至 GitHub Pages。
