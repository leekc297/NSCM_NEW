# Doc/_figma/ — NSCM Figma 디자인 연동

> 사용자가 Figma 로 작성한 NSCM 화면 디자인 파일의 링크/캐시/이미지를 통합 보관.
> 신규 화면 작업 시 본 폴더의 `screens/{화면ID}.md` 를 진실 source 로 사용.
> 룰: [`Doc/_dev_rules/31_FIGMA_DESIGN_INTEGRATION.md`](../_dev_rules/31_FIGMA_DESIGN_INTEGRATION.md) (2026-05-30 신규)

---

## 폴더 구조

```
Doc/_figma/
  ├── README.md                       (이 파일)
  ├── screens/                        ← Git track ✓ (화면별 진실 source)
  │    ├── DMF0007.md                 (URL + Node ID + Layout 요약)
  │    ├── DMF0020.md
  │    └── ... (Doc/_analysis 의 figma_link.md 397 개 이관)
  ├── design_system/                  ← Git track ✓
  │    ├── colors.md                  ← 색상 토큰 (Primary/Secondary/...)
  │    ├── typography.md              ← 폰트·크기·굵기
  │    ├── spacing.md                 ← 간격 토큰
  │    └── components.md              ← Figma 컴포넌트 라이브러리 링크
  ├── _api_cache/                     ← gitignore (회사 자산 + 대용량)
  │    └── {file_key}/{node_id}.json
  └── _images/                        ← gitignore (Figma image export)
       └── {node_id}.png
```

> 이전 (2026-05-19 이전) 의 `domain_DM/`, `domain_SCP/` 폴더 패턴은 **`screens/{화면ID}.md`** 평탄 구조로 통일됨. 도메인 정보는 파일 내부의 frontmatter 로 표기.

---

## 화면별 `screens/{화면ID}.md` 표준 양식

```markdown
# {화면ID} Figma 디자인 정보

## URL
- File: https://www.figma.com/design/{file_key}/{file-name}
- Node: ?node-id={node_id}
- Last sync: TBD (yyyy-mm-dd)

## Layout 요약 (Claude fetch 결과)
- frame size: 1280 x 800
- 주요 영역: header / search-bar / grid / footer
- 컴포넌트 사용: ...

## Cache 위치
- JSON: Doc/_figma/_api_cache/{file_key}/{node_id}.json
- PNG : Doc/_figma/_images/{node_id}.png

## 디자인 결정 사항
- 레이아웃 / 인터랙션 / 반응형

## 변경 이력
- 2026-MM-DD : 초기 작성
```

---

## 사용 워크플로우

### 1. 신규 화면 작업 (사용자 메시지에 URL 포함)
```
"https://www.figma.com/design/c9VYF8oleb9TczKeFWi4ka/...?node-id=5883-145780
 DMF0099 화면 만들어줘"
```
→ Claude 가 URL 자동 감지 → `fetch-figma.ps1` 호출 → `_api_cache/` 에 JSON
→ JSON 정리 → 룰 23 (FE Import Inventory) cross-check → React 코드 작성

### 2. 수동 fetch
```powershell
cd C:\Projects\NSCM\_artifacts\local-docker-oracle
.\fetch-figma.ps1 -Url "https://www.figma.com/design/..." `
  -OutFile "C:\Projects\NSCM\Doc\_figma\_api_cache\<file_key>\<node_id>.json"
```

### 3. `screens/{화면ID}.md` 갱신
fetch 결과를 본 파일의 "Layout 요약" 섹션에 옮겨 적기. "Last sync" 날짜 갱신.

---

## 인증

- Personal Access Token: `C:\Projects\NSCM\.figma_token` (gitignore, 1줄)
- 발급: [https://www.figma.com/settings/account](https://www.figma.com/settings/account) → Personal access tokens → Generate new token
- 스코프: `File content: Read` 만 권장

---

## 룰 cross-reference

| 룰 | 관련 |
|---|---|
| [룰 31](../_dev_rules/31_FIGMA_DESIGN_INTEGRATION.md) | 본 폴더 전체 사용법 + 자동 trigger |
| [룰 20](../_dev_rules/20_SCREEN_ANALYSIS_PIPELINE.md) | 화면 분석서 — `figma_link.md` 위치 변경 (`Doc/_analysis/` → 본 폴더 screens/) |
| [룰 25](../_dev_rules/25_NEW_SCREEN_MANDATORY_CHECKLIST.md) | 신규 화면 사전 자료 5종 → 6종 (Figma 추가) |
| [룰 23](../_dev_rules/23_FE_IMPORT_INVENTORY.md) | Figma 컴포넌트 → `@shared/components` 정확 매핑 |

---

## 도구

| 파일 | 역할 |
|---|---|
| `_artifacts/local-docker-oracle/fetch-figma.ps1` | URL → REST API → JSON 정리 (PowerShell) |
| `_artifacts/local-docker-oracle/fetch-figma.sh` | bash 버전 (Git Bash 호환) |
| `_artifacts/local-docker-oracle/migrate-figma-md.ps1` | 397 figma_link.md → screens/ 이관 (1회용) |

---

## To-Do (장기)

- [ ] LGES 사내 디자인 시스템 — `@lges/design-system` 과 Figma 컴포넌트 매핑 표 작성
- [ ] 화면 와이어프레임 → 고밀도 모킹 → 인터랙션 단계별 캐시
- [ ] Claude 코드용 export 형식 결정 — Figma → 디자인 토큰 자동 추출 (colors.scss, typography.scss 자동 갱신)

---

## 변경 이력

- 2026-05-19 : 폴더 신설 + figma_link.md 397 개 자동 생성 (각 화면 분석 폴더 안)
- 2026-05-30 : 룰 31 신규 + screens/ 평탄 구조 이관 + fetch-figma 도구 + README 보강
