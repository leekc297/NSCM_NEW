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

## ⭐ §0.5 As-Is DB Baseline 자동 점검 (2026-06-01 Plan Stage 5)

**원칙**: 신규/수정 화면 진입 시 코드 작성 전 As-Is MSSQL DB cross-check 4단계 의무.

**도구**: `_artifacts/_diagnostics/`
**Hook**: [`screen-entry-asis-baseline.md`](hooks/screen-entry-asis-baseline.md)
**상세**: hook §1 4단계 + §2 결과 보고서 양식

**4 단계**:
1. `_mapping_asis_tobe.csv` 에 화면 SP/테이블 매핑 1줄 추가
2. `row_count_diff.sh <TABLE>` — Row count cross-check (|Diff| > 1% 시 사용자 확인)
3. `column_inventory.sh <TABLE>` — Column 인벤토리 cross-check (불일치 시 즉시 보고)
4. PIVOT / 동적 컬럼 / bulk save SP 의 경우 `sp_body_diff.sh <ASIS_SP> <TOBE_PKG>` (선택)

**위반 시**: DMF0043 사고 4축 (Row 누락 1.5M / DTL 96 누락 / SP `[col]` 잔존 / Cursor mismatch) 재발 위험.

---

## ⭐ §1.0 화면 Layout/Table Layout 자료 우선순위 (2026-06-01 신규)

**원칙**: 신규/수정 화면 작업 시 layout/table layout 자료를 다음 **우선순위 순서로 fallback** 하여 확인. 상위 자료가 있으면 하위는 보완용.

```
[Priority 1] Figma 디자인본          → Doc/_figma/screens/{SCREEN_ID}.md + _images/{SCREEN_ID}.svg
                                       ↓ (없으면)
[Priority 2] AS-IS 화면 캡처 PNG     → C:\Projects_Document\NSCM\AsIs_UI_Sample\{SCREEN_ID}.png
                                     또는 _analysis/_screens/{도메인}_Screens/{prefix}{SCREEN_ID}.xlsx 의 `2_Layout` 시트 임베드 PNG
                                       ↓ (없으면)
[Priority 3] Excel 화면분석서 12시트  → _analysis/_screens/{도메인}_Screens/{prefix}{SCREEN_ID}.xlsx
                                       (3_FieldList / 5_Layout 등)
                                       ↓ (병행)
[Priority 4] 화면분석 MD              → Doc/_analysis/domain_{X}/screens/{SCREEN_ID}/{analysis.md / tobe_design.md 등 8 MD}
```

#### 적용 절차

| 단계 | 작업 |
|---:|---|
| 1 | Figma `Doc/_figma/screens/{SCREEN_ID}.md` 존재 확인 → 있으면 Layout 우선 채택 |
| 2 | 없으면 `C:\Projects_Document\NSCM\AsIs_UI_Sample\` 또는 xlsx `2_Layout` 시트 PNG 확인 |
| 3 | 없으면 Excel xlsx (`3_FieldList` / `5_Layout` 시트) 확인 |
| 4 | 병행: MD 8종 (analysis/validation/expressions/tobe_design 등) 정밀 cross-check |
| 5 | 자료 간 불일치 발견 시 — Figma 가 최우선 ground truth. AS-IS 캡처는 동작 검증. Excel/MD 는 보완. |

상세: 룰 19 §1 (Mockup SVG) / 룰 20 §1 (화면 분석서 파이프라인) / 룰 31 (Figma 디자인 연동)

---

## §1. 6종 사전 입력 자료 의무 확인 (Pre-Read MUST)

> 2026-05-30: Figma 디자인 통합 (룰 31) — 기존 5종 + Figma = **6종** 으로 확장.

다음 6종 자료를 **모두** Read tool 로 직접 확인한 뒤가 아니면 코드 작성 금지. 한 건이라도 확인 안 했다면 anti-simplification 룰 위반.

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
Doc/_dev_rules/hooks/new-screen-pre-build.md       ⭐ 본 체크리스트의 실행 hook
Doc/_dev_rules/hooks/pre-write.md                  ⭐ 파일 작성 직전
Doc/_dev_rules/hooks/fe-import-check.md            ⭐ FE 작업 시
Doc/_dev_rules/hooks/asis-coverage-check.md        ⭐ As-Is 4축 매핑 검증
Doc/_dev_rules/hooks/runtime-error-prevention.md   ⭐ NEW (2026-05-28) — 신규 화면 기본 오류 방지 (Box / isEss 사고 사례)
Doc/_dev_rules/hooks/menu-not-displayed-debug.md   ⭐ NEW (2026-05-29) — 메뉴 미표시 5단계 디버깅 (MNU_URL ↔ FE slug 1차, 권한 3차). 신규 화면 메타 SQL BLOCK 2 작성 시 FE route-paths.ts cross-check 의무
Doc/_dev_rules/hooks/asis-button-mapping.md        ⭐ NEW (2026-06-02) — As-Is `.cs §4 Button` 5+1대 분석 후 To-Be hotkeyConfig 매핑 의무 (function/false). DMF0072 사용자 지적 후 신설
```

### ⭐ 1.5.1 As-Is 공통 버튼 분석 의무 (2026-06-02 신설 — 사용자 명시 요구)

신규 화면 작성 시 **`hotkeyConfig` 의 각 버튼 활성화 여부 결정 전**, As-Is `.cs §4 Button` 영역의 `protected override` 메서드를 grep:

```bash
grep -n "protected override void \(Find\|Insert\|Delete\|Edit\|Save\|Excel\)Button" \
     Doc/_legacy_source/06_UIL/domain_*/**/{SCREEN_ID}*/{SCREEN_ID}*.cs
```

| As-Is 메서드 | To-Be hotkeyConfig | 결정 룰 |
|---|---|---|
| `FindButton()` 본문 있음 | `search: handleSearch` | function 필수 |
| `InsertButton() → InsertRow()` | `insert: handleInsert` | function (TODO placeholder 허용) |
| `DeleteButton() → siMain.Delete()` | `delete: handleDelete` | function (TODO placeholder 허용) |
| `SaveButton() → SaveData()` | `save: handleSave` | function (TODO placeholder 허용) |
| `EditButton()` | (별도 IsReadOnly toggle) | hotkeyConfig 미지원 |
| `ExcelButton()` 본문 있음 | SubTitle 기본 Excel | 활성 |
| As-Is 정의 없음 | `manual: false` / `upload: false` | **`false` 명시 의무** (silent omit 금지) |

**Placeholder 패턴** (As-Is 에 있지만 To-Be 미구현):
```ts
const handleInsert = () => {
  // TODO As-Is 1:1 구현 — {SCREEN_ID}.cs L{LINE} InsertRow() 참조
  void setAlert({ type: 'alert', content: '미구현 — As-Is 참조' });
};
```

**`__asis-mapping__.md` 의무 기록**: `## Button 매핑` 섹션에 6대 모두 결과 표로 기록. 누락 1건 → PR 머지 차단.

상세: [`hooks/asis-button-mapping.md`](hooks/asis-button-mapping.md), 메모리 `feedback_asis_button_mapping_mandatory.md`

### ⭐ 1.5.2 As-Is Grid Column 분석 → To-Be Column 메타 매핑 의무 (2026-06-02 신설 — 사용자 명시 요구)

신규 화면 작성 시 **Grid column 메타** 결정 전, As-Is `.cs` 의 grid 처리 패턴을 grep:

```bash
# As-Is grid cell 처리 패턴 (Lock + CellType 5종)
grep -nE "siMain\.(LockColumn|LockRange)|siMain\.SetCellTypeCombo|siMain\.SetCellTypeCheckBox|siMain\.SetCellTypeDateTimeFormat|cellTypeImage" \
     Doc/_legacy_source/06_UIL/domain_*/**/{SCREEN_ID}*/{SCREEN_ID}*.cs
```

| As-Is 패턴 (.cs) | To-Be Column Meta (`columns/{screen}-columns.ts`) |
|---|---|
| `siMain.LockColumn(col, true)` 만 | `_inputEditType: 'S'` (read-only) |
| `siMain.LockColumn(col, false)` 또는 미명시 | `_inputEditType: 'M'` 또는 `'O'` (As-Is Validation 의 필수 여부로 결정) |
| `InsertRow` 안 `cellTypeImage` (popup 셀) + `LockColumn` 으로 수정 시 잠금 | `_ctrlType: 'FPModal'` + `_inputEditType: 'IM'` (또는 `IO`) + `_modalKey` (호출 modal) |
| `siMain.SetCellTypeCombo(col, dt)` | `_ctrlType: 'FPComboBox'` + `_inputEditType: 'M'` 또는 `'O'` |
| `siMain.SetCellTypeCheckBox(col)` 또는 컬럼명 `*_YN` | `_ctrlType: 'FPCheckBox'` |
| `siMain.SetCellTypeDateTimeFormat(...)` 또는 컬럼명 `*_DATE` | `_ctrlType: 'FPDate'` (또는 `FPDateTime` / `FPDateMonth`) |
| `siMain.SetCellTypeText(col)` 또는 미설정 | `_ctrlType: 'FPText'` (default) |
| 숫자 입력 `siMain.SetCellTypeNumber...` 또는 `*_QTY`/`*_CNT`/`*_AMOUNT` | `_ctrlType: 'FPNumberText'` |

**Column 이름 패턴 → Control Type 기본 매핑** (As-Is 미명시 시): 룰 12 §11.7.3 참조.

**산출물 의무**: `__asis-mapping__.md` 의 `## Grid Column 매핑` 섹션 — column 별 (As-Is Lock + CellType) × To-Be (`_ctrlType` + `_inputEditType` + `_modalKey`) 매트릭스:

```markdown
## Grid Column 매핑 ({SCREEN_ID})

| Column | As-Is Lock | As-Is CellType | To-Be _inputEditType | To-Be _ctrlType | To-Be _modalKey |
|---|---|---|---|---|---|
| DATA_TYPE_CODE | LockColumn (InsertRow) | SetText 'SCM' default | IM | FPComboBox | — |
| SOLDTO_CODE | LockColumn (M=true) | cellTypeImage (popup) | IM | FPModal | customerByDivisionModal |
| ACTIVE_YN | (없음) | SetText 'Y' default | M | FPCheckBox | — |
| VALID_START_DATE | (없음) | (text 8자) | M | FPDate | — |
| LAST_UPDATED_BY | LockColumn (true) 항상 | (없음) | S | FPText | — |
```

**PR 머지 게이트** (cross-check 카운트 일치 의무):

| As-Is `.cs` grep 카운트 | == To-Be column meta grep 카운트 |
|---|---|
| `siMain.LockColumn` 횟수 | `_inputEditType: 'S'` 또는 `IM`/`IO` 컬럼 수 |
| `cellTypeImage` 또는 `SetCellTypeImage` 횟수 | `_ctrlType: 'FPModal'` (또는 `CELL_CONTROL_TYPE.MODAL`) 컬럼 수 |
| `SetCellTypeCombo` 횟수 | `_ctrlType: 'FPComboBox'` 컬럼 수 |
| `SetCellTypeCheckBox` 횟수 | `_ctrlType: 'FPCheckBox'` 컬럼 수 |
| `SetCellTypeDateTimeFormat` 횟수 | `_ctrlType: 'FPDate'` (또는 DATE_*) 컬럼 수 |

**1건이라도 불일치 → PR Reject** (As-Is 동작 1:1 보존 의무, 룰 24 §3 As-Is Event 축 + 메모리 `feedback_asis_to_tobe_sp_no_omission` 위반).

상세: [`hooks/grid-column-meta-mandatory.md`](hooks/grid-column-meta-mandatory.md), 룰 12 §11.7, 메모리 `feedback_grid_editable_coloring_mandatory.md` + `feedback_grid_popup_cell_mandatory.md`

### ⭐ 1.5.3 As-Is Search Aux 4대 (Sort/Filter/Condition/ResetCondition) 매핑 의무 (2026-06-02 신설 — 사용자 명시 요구)

신규 화면 작성 시 **`hotkeyConfig` 의 조회 보조 4 키 (sort/filter/condition/resetCondition)** 결정 전, As-Is 4 화면 공통 default (BaseForm.cs) + 화면 고유 UsrConditionPanel 유무 확인 의무.

#### 1.5.3.1 As-Is 인벤토리 (BaseForm.cs default)

| Hotkey | To-Be enum | As-Is 위치 | As-Is 동작 |
|---|---|---|---|
| F3 sort | `Hotkeys.F3 = 'sort'` | `BaseForm.cs:5268 OnClickSortButton()` | FarPoint Spread native (`AllowAutoSort` 토글 + `SortIndicator`) |
| F4 filter | `Hotkeys.F4 = 'filter'` | `BaseForm.cs:5054 OnClickFilterButton()` | FarPoint Spread native (`AutoFilterMode = EnhancedContextMenu` + `IsFilter` 플래그) |
| F6 condition | `Hotkeys.F6 = 'condition'` | `BaseForm.cs:5237 OnClickConditionButton()` | `SavePanelCondition()` — UsrConditionPanel 컨트롤값 수집 (서버 저장) |
| F10 resetCondition | `Hotkeys.F10 = 'resetCondition'` | `BaseForm.cs:5245 OnClickResetConditionButton()` | `ResetPanelCondition()` — Authentication API `Authentication/ResetSearchCondition` 호출 |

**4 화면 (DMF0072/0008/0043/0043_01) 모두 `protected override` 없음** → BaseForm default 채택.

#### 1.5.3.2 To-Be 매핑 정책 (기본 활성 + 예외 false)

```
SubTitle DefaultButtonActions (L62~112) 가 F3/F4/F6/F10 default 자동 제공
  → hotkeyConfig 에서 4 키 명시 생략 = 자동 활성 (As-Is BaseForm default 동등)
```

| 키 | 정책 | 예외 (false 의무) |
|---|---|---|
| `sort` (F3) | (생략) = 자동 활성 | DataGrid 없는 화면만 false |
| `filter` (F4) | (생략) = 자동 활성 | DataGrid 없는 화면만 false |
| `condition` (F6) | (생략) = 자동 활성 | **As-Is `.cs`/`.Designer.cs` 에 `UsrConditionPanel` grep 0건 → false 의무** |
| `resetCondition` (F10) | (생략) = 자동 활성 | **As-Is `.cs`/`.Designer.cs` 에 `UsrConditionPanel` grep 0건 → false 의무** |

#### 1.5.3.3 검증 grep

```bash
# 1. As-Is UsrConditionPanel 존재 여부
grep -nE "UsrConditionPanel|usrCondition" \
     Doc/_legacy_source/06_UIL/domain_*/**/{SCREEN_ID}*.cs \
     Doc/_legacy_source/06_UIL/domain_*/**/{SCREEN_ID}*.Designer.cs
# → 0건이면 To-Be 에서 condition/resetCondition: false 명시 의무

# 2. To-Be 명시 false 매핑 확인 (Panel 없는 화면만)
grep -nE "condition:\s*false|resetCondition:\s*false" \
     nscm-fe/features/.../{화면-slug}/*.tsx
```

#### 1.5.3.4 anti-simplification — 4 키 한 묶음 일반화 금지

- ❌ "어차피 다 BaseForm default 니까 4 키 모두 (생략)" — UsrConditionPanel 부재 화면에서 condition/resetCondition 활성된 빈 panel 저장 시도 → silent fail (사용자 혼선)
- ❌ "조회 전용 화면이니까 4 키 모두 false" — Sort/Filter 는 read-only grid 라도 default 활성 (사용자 편의)
- ✅ 키별 의미 (Wijmo native sort/filter vs server-side Authentication API condition/reset) 구분 + As-Is 자료 별 판정

#### 1.5.3.5 산출물 의무

`__asis-mapping__.md` 의 `## Search Aux 매핑 (4대)` 섹션:

```markdown
## Search Aux 매핑 (4대 — 룰 25 §1.5.3 / 룰 12 §11.8 / hook asis-button-mapping §3.5)

| Hotkey | As-Is 위치 (BaseForm default) | 화면 override | UsrConditionPanel | DataGrid 활성 요건 | To-Be 결정 |
|---|---|---|---|---|---|
| F3 sort | BaseForm.cs:5268 OnClickSortButton | 없음 | — | allowSorting={true} | (생략 = 자동 활성) |
| F4 filter | BaseForm.cs:5054 OnClickFilterButton | 없음 | — | FlexGridFilter ref + gridFilter prop | (생략 = 자동 활성) |
| F6 condition | BaseForm.cs:5237 OnClickConditionButton | 없음 | ✅/❌ | — | (생략) / false (Panel 없음) |
| F10 resetCondition | BaseForm.cs:5245 OnClickResetConditionButton | 없음 | ✅/❌ | — | (생략) / false (Panel 없음) |
```

상세: [`hooks/asis-button-mapping.md`](hooks/asis-button-mapping.md) §3.5, 룰 12 §11.8, 메모리 `feedback_search_aux_default_activation.md`

### 1.6 Figma 디자인 자료 ⭐ NEW (2026-05-30 — 룰 31)

```
Doc/_figma/screens/{SCREEN_ID}.md                  ⭐ Figma 디자인 진실 source (Layout + Frame + Image SVG 경로)
Doc/_figma/_images/{SCREEN_ID}.svg                 ⭐ Figma image export (95 화면 분 완료, 로컬 gitignore)
Doc/_figma/_api_cache/{file_key}/node_*.json       ⭐ Figma API fetch 결과 캐시
```

**확인 절차**:
1. `Doc/_figma/screens/{SCREEN_ID}.md` 존재 확인 — 있으면 Read
2. MD 의 **URL / Node ID / Frame size / Cache 위치** 추출
3. **이미지** `Doc/_figma/_images/{SCREEN_ID}.svg` 존재 시 Read (이미지 인식 가능)
4. Figma URL 새로 받으면 → `fetch-figma.ps1 -Url <URL>` 호출하여 갱신

**Figma 자료의 역할**:
- Layout 정확도 ↑ — As-Is .Designer.cs 의 정적 좌표보다 To-Be 가 Figma 우선
- 컴포넌트 매핑 — Figma 컴포넌트 명 → `@shared/components` (룰 23 cross-check)
- 색상/spacing — Figma fills → `@lges/design-system` 토큰 매핑 (룰 31 §5)
- **⭐ Button 명세 매핑 의무 (2026-06-01)** — Figma SVG/MD 의 button 라벨 ⊕ AS-IS `.cs` 의 click 핸들러 합집합을
  `hotkeyConfig` (룰 12 §5 표준) + `customButtons` (화면 특화) 로 100% 매핑. 상세: **룰 31 §5.0**.
  누락 1건 → `__asis-mapping__.md` 의 `## Button 매핑` 섹션에 ❌ + 사유 기재. PR 머지 게이트.

**Figma 자료 없는 화면**:
- `Doc/_figma/screens/{SCREEN_ID}.md` 가 TBD 인 경우 — 사용자에게 Figma URL 요청 또는 As-Is 자료만으로 진행 (사용자 결정)
- 신규 화면 (사용자가 Figma URL 동반 메시지) — Claude 가 자동 fetch + 6번째 자료 채움

상세: [`Doc/_dev_rules/31_FIGMA_DESIGN_INTEGRATION.md`](31_FIGMA_DESIGN_INTEGRATION.md)

---

### §1.5.4 조회조건 Form 표준 패턴 의무 (2026-06-03 신규)

신규 화면 Form 작성 시 **자매 화면 (DMF0007 customer-forecast-master 등) 의 표준 5종 import 그대로 사용 의무**.

**표준 import (변경 금지)**:
```tsx
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { DatePickerCalendar, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useSessionStore } from '@shared/stores';
```

**데이터 가져오기 표준**: `useTabComboQueries({ filters: ['MyDivision', 'BucketType', ...] })` — 다중 lookup 한 번에. BE 가 미리 등록한 표준 키 사용.

| Filter 키 | 데이터 |
|---|---|
| `MyDivision` | 사용자 권한 기반 Division |
| `BucketType` | Weekly/Monthly |
| `EndCustomer` / `SalesSite` / `Team` / `BizType` | Division 기반 다중 (각각 `DIVISION_ID === sc.divisionId` 필터) |
| `YesOrNo` | Y/N |

**가로 사이즈 표준**: `<Grid size={n}>` (12 column 시스템). 단일 field 2~3, Period 4. 행당 합계 12 (또는 자동 wrap).

**라벨 표준**: `<FormItem label={t('LBL00001', '_Div.')} labelAlign='right' required render={...} />` — i18n LBL 코드 + 라벨 정렬 + 필수 표시.

**다중 선택 표준**: `<CustomDropdown multiple allOption useClearIcon limitTags={1} />` — 4 옵션 모두 표준.

**Period 표준**: `<DatePickerCalendar mode='date-range' value={[start, end]} onChange={...} />`.

**Popup 표준** (`@master/components` 재사용):
- `ProjectByDivisionModal` / `ItemByDivisionModal` / `OwnerByDivisionModal` / `CustomerModal` / `TeamModal`

⛔ **금지**:
- 직접 `<label>` + `<input>` / `<select>` 작성 (라벨 정렬 / 필수 표시 / 일관성 깨짐)
- 임의 `style={{ width: ... }}` / `min-width` 지정
- 직접 `useTabProcQuery` 호출하여 개별 lookup SP 호출 (BE 메타 등록 추가 필요)
- 한국어/영어 라벨 직접 입력 (`'Division'` → i18n `t('LBL00001', '_Div.')` 의무)

**AS-IS 캡쳐 1:1 재현 의무**: `Doc/ui_cap/{MENU_ID}_init.png` 또는 `Doc/_figma/_images/{MENU_ID}.svg` 존재 시 row 순서/필드 그룹 정확 재현.

**자매 화면 참조 의무**: 신규 Form 작성 직전 `Read C:\Projects\NSCM\nscm-fe\features\master\src\pages\customer-forecast-master\componenets\CustomerFcstMasterForm.tsx` (또는 동일 도메인 자매 Form).

상세: 메모리 `feedback_form_search_area_standard.md`.

---

## §2. 6종 자료 확인 결과 보고 양식 (사용자에게 첫 응답 시)

코드 작성 전 다음 표를 **반드시** 사용자에게 출력:

```markdown
## {SCREEN_ID} 신규 화면 생성 사전 확인 (룰 25 — 6종)

| # | 자료 | 위치 | 상태 |
|---:|---|---|:---:|
| 1 | AS-IS .cs / .Designer.cs | `Doc/_legacy_source/.../...cs` (X 변종 발견) | ✅ Read 완료 (line count: NNNN / NNNN) |
| 2 | 화면 분석서 xlsx | `_analysis/_screens/.../{NN}_{DOMAIN}_{SCREEN_ID}.xlsx` | ✅ Read 완료 (12 시트 OK / 정정 안내 N) |
| 3 | 화면별 8 MD | `Doc/_analysis/domain_X/screens/{SCREEN_ID}/` | ✅ 8/8 Read 완료 / Validation NN건 / Expression NN건 |
| 4 | 룰셋 MD | anti-simplification + 01 + 17 + 24 + 31 | ✅ 모두 Read |
| 5 | Hook MD | new-screen-pre-build + pre-write + fe-import-check + asis-coverage-check | ✅ 모두 Read |
| 6 | **Figma 자료** ⭐ NEW | `Doc/_figma/screens/{SCREEN_ID}.md` + `_images/{SCREEN_ID}.svg` | ✅/⚠ TBD / ❌ 미존재 |

호출 POPUP: NN개
- POPUP1 (기존 화면 OO) — 신규 생성 불필요
- POPUP2 (DMF0099_XxxPopup) — ❌ 미생성 → §3 자동 생성 대상
```

❌ 위 표를 출력하지 않거나 자료 6종 중 1건이라도 Read 안 한 상태에서 코드 작성 시 anti-simplification 위반. (Figma 자료는 TBD 일 수 있으나 그 상태도 "확인 후 TBD" 라고 명시 필수.)

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

### ⭐ 3.3.1 POPUP AS-IS 원본 정밀 분석 의무 (2026-06-01 신규)

> ⭐⭐ **진실 source (POPUP 주제) — 이 주제는 여기만 변경.**
> 룰 24 §3.5 / hook `popup-asis-analysis.md` 는 이 절을 link only 참조.

**원칙**: POPUP 작업 시 AS-IS `.cs` + `.Designer.cs` 원본을 **반드시 전체 Read** 하여 동작 정밀 매핑. 추측/단순화 절대 금지.

#### 의무 절차

| 단계 | 작업 |
|---:|---|
| 1 | `Doc/_legacy_source/.../POPUP/{POPUP_NAME}.cs` 전체 Read (수백~수천 라인 전체) |
| 2 | `Doc/_legacy_source/.../POPUP/{POPUP_NAME}.Designer.cs` 전체 Read — 컨트롤 인벤토리/이벤트 등록 |
| 3 | `protected override` 메서드 모두 확인 (FindButton/EditButton/InsertButton/SaveButton/DeleteButton) — BaseForm 기본 동작 vs 화면 specific override |
| 4 | `FoxDataRequest("..._SP_NAME")` 호출 모두 추출 — LOAD / SAVE / 부가 SP signature |
| 5 | DefColumns struct 컬럼 추출 — binding / header / readOnly / lock 패턴 |
| 6 | 권한 분기 (`UserInfoContext.Current["NowGroupID"]`) 확인 — admin only CRUD vs 모두 |
| 7 | Edit toggle 동작 확인 (`SwitchLock` + `LockColumn`/`LockRange`) — 어느 컬럼이 영구 잠금 vs 편집 가능 |
| 8 | bulk save 패턴 (`^` 구분 string × N) vs row-by-row 패턴 확인 |
| 9 | MSG i18n 코드 모두 추출 (`MessageHelper.GMessageBox("MSGXXXXX")`) |

#### To-Be 작성 의무

- **SCSS Module 강제** (`{Popup}.module.scss`) — inline style 절대 금지 (룰 03 / 룰 24 §3.5)
- `CustomDialog` (`@shared/components` — `Dialog` 아님, 룰 23 §1) 사용
- Wijmo FlexGrid (룰 12 §5 표준 + GridAction)
- `setAlert/confirm` (`@shared/stores` 의 `useMessageStore`) — `window.alert/confirm` 금지 (룰 14)
- AS-IS 의 모든 button click 핸들러 1:1 매핑 (`hotkeyConfig` 표준 또는 `customButtons` — 룰 31 §5.0)
- AS-IS L 라인 번호와 함께 주석 (`// AS-IS {file}:{LNN}`)

#### 누락 검출 의무

- `__asis-mapping__.md` 의 `## POPUP 매핑` 섹션에 각 POPUP 의 button / SP / event / validation 4축 모두 ✅/⏳/❌ 표시
- ❌ 1건 이상 — PR 머지 게이트 차단

#### 사고 사례 (2026-06-01 DMF0043_ContributeRatePopup)

- Agent 가 sheet 매핑을 `VERSION_POPUP` 으로 잘못 선택 → BE 가 `GET_CONT_VIEW_VERSIONPOPUP` (다른 popup SP) 호출 → 화면 데이터 미조회
- SCSS 적용 깨짐 (`headerContainer` global className 사용) → 일부 영역 표시 불량
- `dialogContent height: 100%` → CustomDialog 자체 영역 초과 → actionBar 영역 외 push → CRUD 버튼 미표시
- 위 사고들 모두 §3.3.1 정밀 분석 의무 위반에서 비롯

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
