# Design Document

## Overview

本設計描述如何為 Hugo 追星部落格建立第一篇樂團介紹文章。文章為一個靜態 Markdown 檔案，包含 YAML front matter 與結構化正文，遵循 SKILLS.md 定義的風格規範，使用 PaperMod 主題渲染。

## Architecture

### 系統架構

本功能為純靜態內容產出，不涉及動態邏輯或後端服務。架構如下：

```
content/posts/
└── elephant-gym-band-introduction.md   ← 產出的文章檔案
        ├── YAML Front Matter (metadata)
        └── Markdown Body (structured content)
```

Hugo 靜態網站產生器讀取 `content/posts/` 目錄下的 `.md` 檔案，解析 front matter 作為頁面中繼資料，將 Markdown body 渲染為 HTML 頁面。

### 技術選型

- **靜態網站產生器**: Hugo
- **主題**: PaperMod
- **內容格式**: Markdown + YAML front matter
- **語言**: 繁體中文（zh-tw）
- **時區**: +08:00（台灣時間）

## Components and Interfaces

### 1. Post File（文章檔案）

**路徑**: `content/posts/elephant-gym-band-introduction.md`

**命名規則**: 使用英文 kebab-case，反映文章主題（樂團介紹）。

### 2. Front Matter Block（中繼資料區塊）

YAML 格式，以 `---` 分隔符包裹，位於檔案最頂部。

**必要欄位**:

| 欄位 | 型別 | 說明 |
|------|------|------|
| title | string | 繁體中文標題 |
| date | string | ISO 8601 datetime，+08:00 時區 |
| draft | boolean | 設為 `false` |
| slug | string | 英文 kebab-case URL slug |
| tags | list | 標籤列表 |
| categories | list | 分類列表 |
| description | string | 一句話繁體中文摘要 |
| sources | list | 資訊來源（含 name 與 url） |

**Front Matter Interface**:

```yaml
---
title: "繁體中文標題"
date: 2025-01-01T12:00:00+08:00
draft: false
slug: "english-kebab-case-slug"
tags:
  - Elephant Gym
  - 張凱婷
  - 大象體操
  - 追星
  - 樂團介紹
categories:
  - 音樂
  - 追星
description: "一句話繁體中文摘要"
sources:
  - name: "Instagram - 張凱婷 @ktyoyoyo"
    url: "https://www.instagram.com/ktyoyoyo/"
  - name: "Threads - 張凱婷 @ktyoyoyo"
    url: "https://www.threads.com/@ktyoyoyo"
---
```

### 3. Content Body（正文區塊）

使用 `##` 層級標題分隔各段落，結構如下：

1. **開場段落** — 點題，說明為何寫這篇
2. **樂團介紹段落** — 大象體操的背景、風格、定位
3. **人物介紹段落** — 張凱婷的角色、演奏風格、舞台表現
4. **資訊來源段落** — Instagram / Threads 連結
5. **結語段落** — 收尾，保留粉絲感

**Content Body Interface**:

```markdown
## 為什麼寫這篇

[開場段落：1-2 句點題]

## 關於大象體操

[樂團介紹：來自高雄、數學搖滾、三人編制、國際巡演]

## 關於張凱婷

[人物介紹：貝斯手、演奏風格、舞台存在感]

## 資訊來源

- Instagram: [@ktyoyoyo](https://www.instagram.com/ktyoyoyo/)
- Threads: [@ktyoyoyo](https://www.threads.com/@ktyoyoyo)

## 結語

[收尾段落：1-2 句保留粉絲感]
```

## Data Models

### Post Metadata Model

```yaml
title: string          # 繁體中文，描述性標題
date: datetime         # ISO 8601，+08:00 時區
draft: boolean         # false（直接發布）
slug: string           # 英文 kebab-case，用於 URL
tags: list[string]     # 至少包含 "Elephant Gym", "張凱婷", "大象體操"
categories: list[string]  # 至少包含 "音樂"
description: string    # 繁體中文，一句話摘要
sources: list[object]  # 每個 object 含 name (string) 與 url (string)
```

### Content Constraints

| 約束 | 值 |
|------|-----|
| 正文字數（中文字元） | 300–600 |
| 主要語言 | 繁體中文 |
| 允許英文場景 | 團名、曲名、專有名詞 |
| 標題層級 | `##`（level-2） |
| 檔案格式 | `.md` |
| 檔名格式 | kebab-case |

## Error Handling

### 內容驗證規則

| 驗證項目 | 失敗條件 | 處理方式 |
|----------|----------|----------|
| 字數不足 | 中文字元 < 300 | 補充內容至達標 |
| 字數超出 | 中文字元 > 600 | 精簡內容至範圍內 |
| Front matter 格式錯誤 | YAML 解析失敗 | 修正 YAML 語法 |
| 日期格式錯誤 | 非 ISO 8601 或缺少時區 | 修正為正確格式 |
| 缺少必要標籤 | tags 未包含指定值 | 補上缺少的標籤 |
| 檔名格式錯誤 | 非 kebab-case | 修正為 kebab-case |
| 內容含未驗證資訊 | 出現捏造的日期/地點/對話 | 移除未驗證內容 |

## Testing Strategy

本功能為靜態內容產出，測試策略以驗證檔案格式與內容約束為主：

- **Property-based tests**: 驗證 kebab-case 格式、front matter 結構、日期格式、標題層級、語言比例、字數範圍等可量化的通用屬性
- **Example-based tests**: 驗證特定欄位值（draft: false、必要標籤、必要分類、sources 連結）
- **Manual review**: 驗證寫作風格、語氣、內容真實性等主觀品質

由於本功能不涉及程式邏輯（純內容產出），property-based tests 主要用於驗證產出檔案的格式正確性，而非函式行為。測試可透過 shell script 或簡單的驗證腳本執行。

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Kebab-case identifier format

*For any* identifier field used in the post (filename without extension, slug value), the value SHALL consist only of lowercase English letters, digits, and hyphens, with no leading or trailing hyphens and no consecutive hyphens.

**Validates: Requirements 1.2, 2.5**

### Property 2: Front matter delimiter structure

*For any* valid post file content, the file SHALL begin with exactly `---` on the first line and contain a second `---` delimiter line that closes the front matter block before the body content begins.

**Validates: Requirements 2.1**

### Property 3: Date field ISO 8601 compliance

*For any* date value in the front matter, it SHALL match the pattern `YYYY-MM-DDTHH:MM:SS+08:00` where each component is a valid calendar/time value.

**Validates: Requirements 2.3**

### Property 4: Content section heading structure

*For any* section separator in the post body (after front matter), it SHALL be a Markdown level-2 heading (`## `) and the body SHALL contain at least two such headings.

**Validates: Requirements 3.1**

### Property 5: Traditional Chinese as primary language

*For any* paragraph in the article body, the ratio of CJK characters to total non-whitespace characters SHALL exceed 50%, with English characters appearing only adjacent to recognized proper nouns (band names, song titles, platform names).

**Validates: Requirements 4.1**

### Property 6: Word count within bounds

*For any* generated post body content (excluding front matter), the count of Chinese characters (CJK Unified Ideographs range) SHALL be between 300 and 600 inclusive.

**Validates: Requirements 5.1**
