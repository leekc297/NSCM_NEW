# 31. Figma 디자인 → React 신규 화면 연동

> ⭐ **Figma 가 디자인 SSoT (Single Source of Truth)**.
> 신규 화면 작업 시 Figma URL → REST API fetch → JSON 정리 → React 코드 작성에 직접 반영.
> 작성: 2026-05-30
> 관련 룰: [20](20_SCREEN_ANALYSIS_PIPELINE.md) / [23](23_FE_IMPORT_INVENTORY.md) / [25](25_NEW_SCREEN_MANDATORY_CHECKLIST.md)
> 관련 hook: [anti-simplification](hooks/anti-simplification.md) (적용)

---

## §1. 배경 / 출처

NSCM 신규 화면은 지금까지 다음 5종 자료로 작성됨 (룰 25):
1. AS-IS C# `.cs` + `.Designer.cs`
2. 화면 분석서 xlsx (13시트)
3. 8 MD (events / api / validation / expressions / fields / ...)
4. 룰셋
5. Hook

하지만 **layout 의 정확한 출처가 없었음** (mockup PNG 는 caricature 수준). 사용자가 **Figma** 로 화면 layout 을 정밀 설계함 → Figma 가 새 SSoT. 본 룰은 Figma 정보를 신규 화면 개발에 직접 반영하는 절차를 명문화.

---

## §2. 인증 / 환경

### 2.1 Personal Access Token
- 발급: [Figma → Settings → Account → Personal access tokens](https://www.figma.com/settings/account) → Generate new token
- 스코프: **`File content: Read`** 만 (최소 권한)
- 토큰 1회만 표시 (분실 시 재발급)

### 2.2 저장
- 위치: **`C:\Projects\NSCM\.figma_token`** (1줄, token 만)
- `.gitignore` 등록 됨: `**/.figma_token`, `.figma_token`
- **메모리에 평문 저장 절대 금지** (위치만 기록)

### 2.3 사내망 점검
```bash
curl -s -o /dev/null -w "%{http_code}\n" --max-time 10 https://api.figma.com/v1/me
# 403 (Invalid token) = 정상 — 토큰 없이 호출. 사내 방화벽 통과 확인.
# 0 / timeout = 사내 차단 — IT 에 api.figma.com 허용 요청
```

---

## §3. 자동 trigger 패턴

### 3.1 사용자 메시지 패턴
다음 두 조건이 동시에 만족되면 Claude 가 **자동 fetch**:
1. 메시지에 `figma.com/design/...` URL 포함
2. + "화면 만들어", "신규", "생성", "DMF{NNNN} 작성" 등 신규 화면 작업 키워드

### 3.2 단독 URL 패턴
URL 만 + 특별한 키워드 없음:
- fetch + 정리만 (코드 작성 X)
- "이 layout 이 어떤 화면인지 확인해줘" 흐름

### 3.3 명시 비활성화
사용자가 "Figma fetch 안 해도 돼" / "수동으로만" 명시 시 자동 fetch 안 함.

---

## §4. fetch 절차 (Claude 가 따를 순서)

```
1) Test-Path C:\Projects\NSCM\.figma_token  → 없으면 발급 안내 후 중단
2) .\fetch-figma.ps1 -Url <URL>
     -OutFile Doc/_figma/_api_cache/<file_key>/<node_id>.json
3) JSON 정리:
   ├─ name + lastModified
   ├─ document.children 또는 nodes[<id>].document
   ├─ frame 별 absoluteBoundingBox (width/height/x/y)
   ├─ text 노드 → label / placeholder
   ├─ component 호출 → 룰 23 (FE Import Inventory) cross-check
   └─ 색상/spacing → @lges/design-system 토큰 매핑
4) 룰 25 (NEW_SCREEN_MANDATORY_CHECKLIST):
   기존 5종 자료 + 6번째 = Figma JSON
5) React 코드 작성 시 §5 매핑 표 따름
6) screens/{화면ID}.md 의 "Last sync" 갱신
```

---

## §5. Figma → React/NSCM 컴포넌트 매핑

| Figma 노드 type / name 패턴 | NSCM React 매핑 | 출처 |
|---|---|---|
| `FRAME` (top-level page) | `<div className="page-container">` | (룰 03) |
| `FRAME` (group / section) | `<Stack direction="row|col">` from `@shared/lges` | 룰 23 §3 |
| `COMPONENT` name=Button | `<Button>` from `@shared/components` | 룰 23 §1 |
| `COMPONENT` name=IconButton | `<IconButton>` from `@shared/lges` (note: `@shared/components` 없음) | 룰 23 §5.1 |
| `COMPONENT` name=Input / TextField | `<CustomInput>` from `@shared/components` | 룰 23 |
| `COMPONENT` name=Dropdown / Select | `<CustomDropdown>` from `@shared/components` | 룰 23 §1 |
| `COMPONENT` name=Modal / Dialog | `<CustomDialog>` from `@shared/components` (⚠ `Dialog` 아님) | 룰 23 §1 |
| `COMPONENT` name=Grid / Table | Wijmo `<FlexGrid>` (룰 12 표준 패턴) | 룰 12 |
| `COMPONENT` name=Tab | `<TabWrapper>` + `<TabItem>` | 룰 23 §1 |
| `TEXT` (header) | `<Typography variant="h3">` | MUI |
| `TEXT` (label) | `<label>` 또는 form label prop | - |
| `RECTANGLE` (background) | SCSS `.module.scss` 의 `background` | - |

### 색상 매핑
- Figma 의 `fills[].color` (RGBA 0~1) → SCSS `_colors-lges.scss` 변수
- 예: `r=0.04, g=0.16, b=0.76` → `var(--color-primary)`
- 정확 매핑 미정의 시: 가까운 token 추정 + 사용자 확인 요청 (절대 임의 hex 하드코딩 X)

### 간격 매핑
- Figma 의 `itemSpacing` / `paddingLeft` 등 → SCSS `_spacing.scss`
- 예: `itemSpacing=8` → `var(--space-sm)`

---

## §6. 절대 금지 (Anti-Simplification 적용)

| # | 금지 | 위반 시 |
|---:|---|---|
| 1 | ❌ Figma JSON 의 일부만 추출 (예: 첫 frame 만) | 룰 25 §1 + anti-simplification 위반 |
| 2 | ❌ Component 변환 누락 (Modal, Tab 등 안 보이는 것 포함) | 화면 동작 불일치 |
| 3 | ❌ 컬러/spacing 추측 하드코딩 | LGES 디자인 시스템 일관성 깨짐 |
| 4 | ❌ Figma fetch 실패 시 우회 (try/catch 묵살) | 사용자에게 명시 보고 의무 |
| 5 | ❌ `.figma_token` 평문을 메모리/log/git 에 노출 | 토큰 폐기 + 재발급 |
| 6 | ❌ Figma URL → React 변환 시 룰 23 (FE Import Inventory) 미참조 | runtime 폭발 (룰 23 사고 패턴) |
| 7 | ❌ 같은 화면 여러 번 fetch (rate limit 위협) | _api_cache/ 활용 |
| 8 | ❌ **frame name → NSCM 화면 ID 매핑 시 DB cross-check 생략** | 2026-05-30 사고 패턴 (아래 §6.1) |
| 9 | ❌ **fuzzy match 결과를 anti-simplification 검증 없이 채택** | false positive 누락 |
| 10 | ❌ **Figma Free plan 의 `/v1/files/{key}?depth=N` endpoint 반복 호출** | Retry-After 4.6일 차단 (2026-05-30 발견) |

### §6.1 Frame name → 화면 ID 매핑 사고 패턴 (2026-05-30)

**증상**:
- Stage 1 fuzzy match 가 단순 token 공유 (예: "Sales") 로 **false positive** 매칭 생성
- 한국어 frame name (예: "해외법인 기여율 등록") 는 NSCM 영문 메뉴와 매칭 불가 → 매핑 0건
- 의심: `프로시저 세팅` → SYS0010 (lookup) 잘못 매칭 / `Batch Log` → SYS0010 잘못 매칭

**원인**:
- Claude 가 frame name 의 일부 단어만 보고 추측 (예: "Lookup" 단어가 "프로시저" 와 무관)
- NSCM DB 의 실제 화면 (SCM_ADM_MNU_M) 의 정확한 매칭 검증 누락

**필수 절차** (사고 방지):
1. fuzzy match 결과를 **항상 NSCM DB cross-check**:
   ```sql
   SELECT MNU_ID, MNU_URL, MNU_MSG_ID
     FROM SCM_MGR.SCM_ADM_MNU_M
    WHERE MNU_TP_CD IN ('SCREEN','POPUP');
   ```
2. matched_screen_id 가 DB 에 **존재**하는지 + **URL/한글명**이 frame name 과 의미적으로 일치하는지 확인
3. **HIGH** (=100, URL 완벽 일치) 만 자동 매핑. **MID/LOW** 는 모두 사용자 검토.
4. Claude 가 수동 매핑 시 `confidence='MANUAL'` 표기 + 사용자에게 검토 요청 명시.
5. 매핑 정정 사고 발생 시 본 §6.1 에 사례 추가.

### §6.2 Figma Free plan rate limit 정책 (2026-05-30 발견)

| endpoint | rate limit pool | 사용 권장 |
|---|---|---|
| `/v1/files/{key}?depth=N` | 매우 엄격 (`Retry-After: 397381` = 4.6일) | ❌ 사용 금지 |
| `/v1/files/{key}/nodes?ids=<page>` | 별도 pool | ✅ 사용 가능 |
| `/v1/images/{key}?ids=<frames>` | 별도 pool | ✅ 사용 가능 (batch 50개씩) |
| `/v1/me` | 거의 무제한 | ✅ 인증 확인용 |

**대응**:
- 큰 파일 전체 fetch 가 필요하면 `node-id` 지정 후 `/nodes` endpoint 사용
- batch 호출 사이 800ms sleep 권장
- 429 발생 시 즉시 재시도 금지 (cooldown 더 길어짐) — 10~30분 대기

---

## §7. 캐싱 정책

- **`_api_cache/<file_key>/<node_id>.json`** = gitignore (회사 자산 + 대용량)
- **`_images/<node_id>.png`** = gitignore
- `screens/<화면ID>.md` 의 "Last sync" 필드로 stale 감지
- **7일 이상 stale** 시 자동 재fetch 권장
- Figma rate limit (무료 plan ~120 req/min) 회피

---

## §8. fetch-figma 도구 사용법

### 기본
```powershell
.\fetch-figma.ps1 -Url "https://www.figma.com/design/c9V.../node-id=5883-145780"
```

### 파일로 저장
```powershell
.\fetch-figma.ps1 -Url <URL> -OutFile temp.json
```

### 이미지 동시 export
```powershell
.\fetch-figma.ps1 -Url <URL> -OutFile temp.json -ImageExport -ImageFormat svg
```

### bash 버전 (Git Bash)
```bash
./fetch-figma.sh "https://www.figma.com/design/..." --out temp.json
```

---

## §9. 화면별 `screens/{화면ID}.md` 자동 갱신

신규 화면 작업 시 fetch 후 다음 섹션을 채움:

```markdown
## Layout 요약 (Claude fetch 결과)
- frame size: 1280 x 800
- 주요 영역:
  - header (96px) : 화면 제목 + 검색 영역
  - search-bar (48px): 부서 / 기간 / 거래처 입력
  - grid (560px) : Wijmo FlexGrid, 8 컬럼
  - footer (48px): 저장 / 취소 버튼
- 컴포넌트 사용 (룰 23 매핑):
  - <CustomDropdown> × 3 (부서 / 기간 / 거래처)
  - <DatePicker> × 1
  - <FlexGrid> × 1 (8 컬럼, 위 8 자료 sheet 참조)
  - <Button> × 2 (저장 / 취소)
- 색상: primary / secondary / divider
- 간격: 16px (--space-md) gap 기본
```

---

## §10. Cross-Reference

| 룰 | 관계 |
|---|---|
| [룰 20](20_SCREEN_ANALYSIS_PIPELINE.md) §3.4 | `figma_link.md` 위치 변경 (Doc/_analysis → Doc/_figma/screens) |
| [룰 25](25_NEW_SCREEN_MANDATORY_CHECKLIST.md) §1 | 사전 자료 5종 → 6종 (Figma 6번째) |
| [룰 23](23_FE_IMPORT_INVENTORY.md) | Figma 컴포넌트 → 실제 export 매핑 의무 |
| [룰 19](19_MOCKUP_SVG_RULES.md) | 기존 mockup PNG/SVG 와 Figma 의 관계 (점진적 대체) |
| 메모리 `feedback_figma_url_detected.md` | URL 감지 + 자동 fetch trigger |
| 메모리 `reference_figma_token_location.md` | `.figma_token` 위치 |
| 메모리 `reference_figma_file_key.md` | 메인 Figma 파일 key |

---

## §11. 변경 이력

- 2026-05-30 신규 (사용자 요구 — Figma URL `c9VYF8oleb9TczKeFWi4ka` 첫 적용)
