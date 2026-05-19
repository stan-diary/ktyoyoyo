# Implementation Plan: First Blog Post — Elephant Gym Band Introduction

## Overview

Create the first blog post for the Hugo stan diary site: a band introduction article about Elephant Gym and bassist KT Chang (張凱婷). The implementation involves creating a single Markdown file with correct YAML front matter and structured Traditional Chinese content, then validating it against the 6 correctness properties defined in the design.

## Tasks

- [x] 1. Create the blog post file with front matter and content
  - [x] 1.1 Create `content/posts/elephant-gym-band-introduction.md` with complete YAML front matter
    - Create the file at `content/posts/elephant-gym-band-introduction.md`
    - Include YAML front matter delimited by `---` with all required fields: title, date (ISO 8601 +08:00), draft: false, slug, tags, categories, description, sources
    - Tags must include "Elephant Gym", "張凱婷", "大象體操"
    - Categories must include "音樂"
    - Sources must list Instagram and Threads profiles for @ktyoyoyo
    - Slug must be English kebab-case
    - _Requirements: 1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9_

  - [x] 1.2 Write the article body with 5 structured sections
    - Write content body using `##` level-2 headings for each section
    - Section 1: 為什麼寫這篇 — opening that introduces the article purpose
    - Section 2: 關於大象體操 — band origin, genre (math rock), style, three-piece formation
    - Section 3: 關於張凱婷 — bassist role, playing style, stage presence
    - Section 4: 資訊來源 — Instagram and Threads links
    - Section 5: 結語 — closing with fan sentiment
    - Write in Traditional Chinese with sincere fan tone per SKILLS.md
    - English only for band names, song titles, proper nouns
    - Only describe publicly known information; no fabricated details
    - Total Chinese character count must be between 300–600
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 4.1, 4.2, 4.3, 4.4, 4.5, 5.1, 5.2_

- [-] 2. Checkpoint - Verify post file structure
  - Ensure the post file exists, Hugo can parse it (valid YAML front matter, valid Markdown), and content reads naturally. Ask the user if questions arise.

- [x] 3. Create validation script for correctness properties
  - [x] 3.1 Write a shell validation script to verify all 6 correctness properties
    - Create `scripts/validate-post.sh` (or similar) that checks:
    - Property 1 (kebab-case): filename and slug contain only lowercase letters, digits, hyphens; no leading/trailing/consecutive hyphens
    - Property 2 (front matter delimiters): file starts with `---` on line 1 and has a closing `---` before body
    - Property 3 (ISO 8601 date): date field matches `YYYY-MM-DDTHH:MM:SS+08:00` pattern with valid values
    - Property 4 (heading structure): body contains only `##` headings and at least 2 of them
    - Property 5 (language ratio): CJK characters exceed 50% of non-whitespace characters in body paragraphs
    - Property 6 (word count): CJK character count in body is between 300 and 600 inclusive
    - Script should output PASS/FAIL for each property with clear messages
    - _Requirements: 1.2, 2.1, 2.3, 2.5, 3.1, 4.1, 5.1_

  - [ ]* 3.2 Write property test for kebab-case identifier format
    - **Property 1: Kebab-case identifier format**
    - **Validates: Requirements 1.2, 2.5**

  - [ ]* 3.3 Write property test for front matter delimiter structure
    - **Property 2: Front matter delimiter structure**
    - **Validates: Requirements 2.1**

  - [ ]* 3.4 Write property test for ISO 8601 date compliance
    - **Property 3: Date field ISO 8601 compliance**
    - **Validates: Requirements 2.3**

  - [ ]* 3.5 Write property test for content heading structure
    - **Property 4: Content section heading structure**
    - **Validates: Requirements 3.1**

  - [ ]* 3.6 Write property test for Traditional Chinese language ratio
    - **Property 5: Traditional Chinese as primary language**
    - **Validates: Requirements 4.1**

  - [ ]* 3.7 Write property test for word count bounds
    - **Property 6: Word count within bounds**
    - **Validates: Requirements 5.1**

- [ ] 4. Run validation and fix any issues
  - [~] 4.1 Execute the validation script against the post file and fix any failures
    - Run the validation script
    - If any property check fails, fix the post content or front matter accordingly
    - Re-run until all 6 properties pass
    - _Requirements: 1.2, 2.1, 2.3, 2.5, 3.1, 4.1, 5.1_

- [~] 5. Final checkpoint - All validations pass
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate universal correctness properties from the design document
- The validation script (task 3.1) covers all 6 properties in a single executable check
- The individual property test tasks (3.2–3.7) provide more granular, isolated testing
- Content must follow SKILLS.md writing guidelines: sincere fan tone, Traditional Chinese, public info only

## Task Dependency Graph

```json
{
  "waves": [
    { "id": 0, "tasks": ["1.1"] },
    { "id": 1, "tasks": ["1.2"] },
    { "id": 2, "tasks": ["3.1"] },
    { "id": 3, "tasks": ["3.2", "3.3", "3.4", "3.5", "3.6", "3.7"] },
    { "id": 4, "tasks": ["4.1"] }
  ]
}
```
