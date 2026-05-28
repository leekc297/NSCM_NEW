# 25. 신규 화면 생성 강제 체크리스트 (Mandatory Pre-Build Checklist)

> ⭐ **사용자가 "화면 생성/추가/신규" 를 언급하면 무조건 본 체크리스트를 실행한다.**
> 본 체크리스트를 통과하지 못한 상태로 To-Be 코드 작성 착수 = **즉시 중단**.
>
> 작성: 2026-05-22 (사용자 요구: "화면 신규 생성 시 화면분석서 Excel + 화면별 상세분석 RULE MD + HOOK + AS-IS SOURCE 확인 + 연결 POPUP 자동 생성 을 반드시 적용")
> 관련: 17_NEW_SCREEN_QUICKSTART.md / 20_SCREEN_ANALYSIS_PIPELINE.md / 24_ASIS_CROSSCHECK.md / hooks/new-screen-pre-build.md

---

## §0. 본 룰이 적용되는 트리거 키워드

사용자 메시지에 아래 표현이 **하나라도** 포함되면 본 룰 자동 적용:

- 한국어: "화면 생성", "화면 추가", "신규 화면", "화면 만들어", "화면 개발", "화면 작성", "to-be 화면"
- 영어: "create screen", "new screen", "add screen", "build page", "new page"
- 화면 ID 단독 언급 + 동사 (예: "DMF0099 만들어줘", "DMF0099 추가해줘")

해당 키워드 감지 시 첫 응답에서 본 룰을 인용하며 5종 사전 확인 결과를 먼저 보고해야 함.

---

## §1. 5종 사전 입력 자료 의무 확인 (Pre-Read MUST)

다음 5종 자료를 **모두** Read tool 로 직접 확인한 뒤가 아니면 코드 작성 금지. 한 건이라도 확인 안 했다면 anti-simplification 룰 위반.

### 1.1 AS-IS C# Source (.cs + .Designer.cs)

```
Doc/_legacy_source/06_UIL/domain_{DM|Common|SCM|SCP|SSP|FP}/{ProjectName}/{SCREEN_ID}*.cs
Doc/_legacy_source/06_UIL/domain_{DM|...}/{ProjectName}/{SCREEN_ID}*.Designer.cs
```

검색 명령:
```powershell
Get-ChildItem -Path 'C:\Projects\NSCM\Doc\_legacy_source' -Filter '{SCREEN_ID}*.cs' -Recurse -ErrorAction SilentlyContinue
```

⚠ **여러 변종 존재 시** (예: DMF0020 → Master.UIL / Plan.UIL / Shipment.UIL / Forms.UIL/Master/...) **모두 카운트** 후 `__asis-mapping__.md` 또는 `__asis-mapping__.md` 의 "As-Is 소스" 라인에 기재된 경로를 1차 신뢰. 그 외 변종은 후순위 참조.

**필수 추출 대상**:
- `Designer.cs`: 모든 컨트롤의 Location / Size / ControlLocation / ControlSize (정적 좌표/사이즈)
- `.cs`: `.Visible = ...` / `.Enabled = ...` / `.Location = ...` / `.Size = ...` (런타임 동적 배치)
- `.cs`: 모든 `MessageHelper.GMessageBox` (Validation 추출 — 룰 09)
- `.cs`: 모든 `LockColumn / LockRange` (Expression 추출 — 룰 09)
- `.cs`: 모든 `new {Xxx}Popup()` (호출 POPUP 식별 — §3 트리거)

### 1.2 화면별 분석서 Excel (12~13 시트)

```
_analysis/_screens/{27_DM|28_Common|29_SCM|30_SCP|31_SSP|32_FP}_Screens/{NN}_{DOMAIN}_{SCREEN_ID}*.xlsx
```

⚠ 룰 09 §1 원칙 4: 27_DM_Screens 14개 파일에서 1~10 시트가 오염된 사고 있음. `00_정정안내_READ_ME` 시트 있거나 `1_화면개요` 의 SCREEN_ID 가 파일명과 다르면 **MD 폴더를 1차 신뢰**.

**필수 시트 확인**:
- `11_Validation` — MessageBox 매핑 카운트
- `12_Expression` — 동적 동작 매핑 카운트
- `00_정정안내_READ_ME` — 정정 여부

### 1.3 화면별 상세분석 8 MD (특히 validation + expressions)

```
Doc/_analysis/domain_{DM|Common|SCM|SCP|SSP|FP}/screens/{SCREEN_ID}/
├── analysis.md
├── validation.md      ⭐ MUST — 행 수 == To-Be 적용 건수 (1건 누락 시 PR Reject)
├── expressions.md     ⭐ MUST — 동적 동작 매핑 (LockColumn / SetValue Auto-Sync 등)
├── popups.md          ⭐ 호출 POPUP 목록 (있으면 §3 트리거)
├── events.md
├── api.md
├── grid.md
└── search.md
```

미존재 시 즉시 사용자에게 보고. 코드 작성 절대 금지.

### 1.4 룰셋 MD (4종 의무 Read)

```
Doc/_dev_rules/hooks/anti-simplification.md   ⭐ 최우선
Doc/_dev_rules/01_CLAUDE.md                   ⭐ AI 가이드
Doc/_dev_rules/17_NEW_SCREEN_QUICKSTART.md    ⭐ 9-step 진행
Doc/_dev_rules/24_ASIS_CROSSCHECK.md          ⭐ 4축 매핑 검증
```

특화 룰 (해당 시 추가 Read):
- `03_FE_RULES.md` (FE)
- `04_BE_RULES.md` (BE 특수 로직)
- `08_SCREEN_REGISTRATION.md` (7-BLOCK 메타 등록)
- `09_WIJMO_VALIDATION_EXPRESSION.md` (Wijmo 매핑)
- `19_MOCKUP_SVG_RULES.md` (Mockup 작성)

### 1.5 Hook MD (3종 의무 Read)

```
Doc/_dev_rules/hooks/new-screen-pre-build.md    ⭐ 본 체크리스트의 실행 hook
Doc/_dev_rules/hooks/pre-write.md               ⭐ 파일 작성 직전
Doc/_dev_rules/hooks/fe-import-check.md         ⭐ FE 작업 시
Doc/_dev_rules/hooks/asis-coverage-check.md     ⭐ As-Is 4축 매핑 검증
```

---

## §2. 5종 자료 확인 결과 보고 양식 (사용자에게 첫 응답 시)

코드 작성 전 다음 표를 **반드시** 사용자에게 출력:

```markdown
## {SCREEN_ID} 신규 화면 생성 사전 확인 (룰 25)

| # | 자료 | 위치 | 상태 |
|---:|---|---|:---:|
| 1 | AS-IS .cs / .Designer.cs | `Doc/_legacy_source/.../...cs` (X 변종 발견) | ✅ Read 완료 (line count: NNNN / NNNN) |
| 2 | 화면 분석서 xlsx | `_analysis/_screens/.../{NN}_{DOMAIN}_{SCREEN_ID}.xlsx` | ✅ Read 완료 (12 시트 OK / 정정 안내 N) |
| 3 | 화면별 8 MD | `Doc/_analysis/domain_X/screens/{SCREEN_ID}/` | ✅ 8/8 Read 완료 / Validation NN건 / Expression NN건 |
| 4 | 룰셋 MD | anti-simplification + 01 + 17 + 24 | ✅ 모두 Read |
| 5 | Hook MD | new-screen-pre-build + pre-write + fe-import-check + asis-coverage-check | ✅ 모두 Read |

호출 POPUP: NN개
- POPUP1 (기존 화면 OO) — 신규 생성 불필요
- POPUP2 (DMF0099_XxxPopup) — ❌ 미생성 → §3 자동 생성 대상
```

❌ 위 표를 출력하지 않거나 자료 5종 중 1건이라도 Read 안 한 상태에서 코드 작성 시 anti-simplification 위반.

---

## §3. 연결 POPUP 자동 생성 규칙

### 3.1 트리거

AS-IS `.cs` 에 `new XxxPopup()` 패턴 또는 `popups.md` 에 명시된 POPUP 이 **신규 화면 폴더에 미생성** 상태이면 자동 생성 대상.

### 3.2 식별 절차

```powershell
# AS-IS .cs 에서 호출 POPUP 추출
Select-String -Path "{ASIS_CS_PATH}" -Pattern 'new \w+Popup\(' -SimpleMatch:$false |
    ForEach-Object { $_.Line.Trim() }
```

```bash
# popups.md 의 POPUP 목록 확인
Read: Doc/_analysis/domain_{X}/screens/{SCREEN_ID}/popups.md
```

### 3.3 POPUP 신규 생성 vs 기존 화면 활용 분기

| 케이스 | 처리 |
|---|---|
| POPUP 이 **독립 메뉴 (별도 SCREEN_ID 보유)** 인 경우 | 별도 신규 화면으로 처리 (본 체크리스트 재귀 적용 필요 — 사용자 별도 승인) |
| POPUP 이 **현재 화면 종속** (별도 SCREEN_ID 없음) | `components/modals/{PopupName}Modal.tsx` 로 신규 생성 |
| POPUP 이 **공통 모달 영역** (예: 검색 마스터 lookup) | `@shared/components` 의 기존 컴포넌트 재사용 — 신규 생성 금지 |

### 3.4 종속 POPUP 신규 생성 시 구조

```
features/{domain}/src/pages/{kebab-screen}/components/modals/
├── {Popup1}Modal.tsx
├── {Popup1}Modal.module.scss
├── {Popup2}Modal.tsx
└── {Popup2}Modal.module.scss
```

각 Popup Modal 도 본 룰 25 의 5종 자료 적용 대상 — POPUP 의 AS-IS `.cs` (예: `DMF0020_SalesPriceRangePopUp.cs`) 도 Read 의무.

### 3.5 보고 양식

```markdown
## 연결 POPUP 처리 결과 (룰 25 §3)

| # | POPUP | AS-IS .cs | 처리 방식 | 생성 위치 |
|---:|---|---|---|---|
| 1 | DMF0020_SalesFuturePricePopUp | `domain_DM/.../DMF0020_SalesFuturePricePopUp.cs` (24,882 B) | 종속 모달 신규 | `components/modals/ExchangeRateModal.tsx` |
| 2 | DMF0020_SalesPriceRangePopUp | `domain_DM/.../DMF0020_SalesPriceRangePopUp.cs` (22,945 B) | 종속 모달 신규 | `components/modals/SalesPriceRangeModal.tsx` |
| 3 | (공통 lookup) | (해당 없음) | `@shared/components/ItemLookup` 재사용 | (신규 생성 안 함) |
```

---

## §4. 화면 동적 배치 분석 (반드시 포함)

AS-IS `.cs` 의 다음 패턴을 **모두** 추출하여 To-Be 코드에 매핑:

| AS-IS 패턴 | 의미 | To-Be 매핑 위치 |
|---|---|---|
| `xxx.Visible = (조건)` | 컨트롤 동적 표시/숨김 | JSX `{condition && <Component>}` |
| `xxx.Enabled = (조건)` | 컨트롤 동적 활성/비활성 | `<Component disabled={!condition}>` |
| `xxx.Location = new System.Drawing.Point(...)` | 런타임 위치 변경 | SCSS `transform` 또는 Grid `size` 동적 |
| `xxx.Size = new System.Drawing.Size(...)` | 런타임 크기 변경 | SCSS width / MUI `sx={{ width: ... }}` |
| `panel1.Visible = true/false` | Progress / 영역 토글 | Loading state |
| `siMain.ActiveSheet.Columns[i].Visible = ...` | 그리드 컬럼 동적 표시 | FlexGrid `<Col visible={...} />` |

**누락 0건 의무**: 모든 동적 배치는 `__asis-mapping__.md` 의 Expression 섹션에 추가.

---

## §5. 사용자가 직접 우회 요청 시

사용자가 명시적으로 "이 체크리스트는 건너뛰자" / "AS-IS 안 봐도 돼" 라고 요청하면:

1. 그대로 진행하지 말고, **본 룰 25 의 위반 risk 와 어떤 데이터가 손실되는지 명시적으로 보고**
2. 사용자가 그래도 진행하라고 재차 확인하면 진행 — 단 PR 의 description 에 "룰 25 우회 (사용자 명시 승인)" 명기 의무

---

## §6. 적용 화면 사례

본 룰의 첫 적용 사례 (2026-05-22): **DMF0020 SalesFuturePrice 레이아웃 보완 작업**
- AS-IS `.cs` 3,970줄 + `.Designer.cs` 93,124 B 분석
- 정적 좌표 추출: 22 컨트롤 (Designer.cs L255~1480)
- 동적 배치 추출: `btnTemplate.Visible = (div==81)` (L205, 2581)
- 결과: `__asis-mapping__.md` Expression #74 신규 행 추가 + `{isEss && <Button>}` JSX 조건부 적용
