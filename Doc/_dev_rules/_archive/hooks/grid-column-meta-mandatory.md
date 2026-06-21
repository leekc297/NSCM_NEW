# Hook — Grid Column 메타 표준 의무 (Coloring + Popup + Control Type)

> ⭐ **신규 화면 생성 시 grid 의 column meta 를 `_ctrlType` (14 control type) + `_inputEditType` (5 edit type) + `_modalKey` (popup modal 식별) 로 표준화 의무. FlexGrid 직접 사용 금지 — `DataGrid` 래퍼 사용 의무.**
>
> 위반 시: (1) 편집 가능 cell coloring 누락 (사용자 시각 혼선) (2) Popup cell OpenInNew 아이콘 + 키보드 편집 차단 + dblClick modal 미동작 (3) As-Is 의 cellTypeImage / SetCellTypeCombo 매핑 누락 → As-Is 동작 손실.

작성: 2026-06-02 (DMF0072 NN Master Mapping 작업 + 사용자 명시 요구 반영)
관련 룰: `12_GRID_COMMON.md` §11.7, `25_NEW_SCREEN_MANDATORY_CHECKLIST.md` §1.5.2, `23_FE_IMPORT_INVENTORY.md` §12.A
관련 메모리: `feedback_grid_editable_coloring_mandatory.md`, `feedback_grid_popup_cell_mandatory.md`

---

## §0. 배경 (사용자 명시 요구 — 2026-06-02)

> "DMF0004 화면을 보면 GRID의 편집가능 항목은 COLORING 되어 있는 부분이 확인됩니다.
> 신규화면 4개에 대해서도 이 RULE 적용해주세요. 
> DMF0004 화면의 하단GRID 에서 SOLD_TO 같은 경우에는 신규 입력 시 POPUP 으로 선택하는 기능 이 있습니다. 이 기능도 신규화면 4개에 대해서 적용해주세요. 
> 위의 2개의 RULE 은 신규화면 생성 시 적용되도록 MD, HOOK 에 보완 요청 합니다.
> GRID 의 COLUMN 에 대해서는 COLUMN 이름을 기준으로 POPUP, DROPDOWN, DATE PICKER, CHECKBOX 등등 을 관리해서 사용하도록 RULE을 지정하면 될 것 같아요."

NSCM 의 표준 `DataGrid` 래퍼 (`packages/shared/src/components/organisms/data-grid/DataGrid.tsx`) 가 column meta 기반으로 자동 처리:
- **Coloring**: `_inputEditType` (5종) → `wj-cell-editable` (#fff8cd) / `wj-cell-non-editable` (#f1f4f3) 자동 토글
- **Popup cell**: `_ctrlType: 'FPModal'` → 우측 OpenInNew 아이콘 + 키보드 편집 차단 + dblClick 시 modal open

신규 화면이 **FlexGrid 직접 사용** 하면 위 메커니즘 모두 작동 안 함.

---

## §1. `CELL_CONTROL_TYPE` 14종 인벤토리

위치: `packages/foundation/src/constants/column-config.ts:9-25`

| Enum | Value | 의미 | 사용 예 |
|---|---|---|---|
| `MODAL` | `'FPModal'` | Popup cell (dblClick → modal open) | SOLDTO_CODE, SHIPTO_CODE, PROJECT_CODE, ITEM_ID |
| `COMBO` | `'FPComboBox'` | Dropdown (lookup) | DATA_TYPE_CODE, FCST_TYPE, INCOTERMS |
| `BUTTON` | `'FPButton'` | Cell 안 버튼 | (특수 — 인라인 액션) |
| `DATE` | `'FPDate'` | YYYYMMDD picker | VALID_START_DATE |
| `DATE_MONTH` | `'FPDateMonth'` | YYYYMM picker | PLAN_YYYYMM |
| `DATE_TIME` | `'FPDateTime'` | YYYYMMDDHHMMSS | LAST_UPDATE_DATE |
| `DATE_TEXT` | `'FPDateText'` | text 표시 + date editor | 변환 시점 |
| `CHECKBOX` | `'FPCheckBox'` | Y/N boolean | ACTIVE_YN, VALID_YN |
| `NUMBER_TEXT` | `'FPNumberText'` | 천 단위 콤마 | QTY, AMOUNT |
| `TEXT_BOX` | `'FPTextBox'` | textbox | DESCRIPTION |
| `PERCENT` | `'FPPercent'` | 퍼센트 | CONTRIBUTE_RATE |
| `TEXT` | `'FPText'` | 단순 text (default) | LAST_UPDATED_BY |
| `NUMBER` | `'FPNumber'` | 숫자 (right align) | SEQUENCE |
| `MULTILINE_TEXT` | `'FPMultiLineTextBox'` | 멀티라인 | REMARK |

## `CELL_INPUT_EDIT_TYPE` 5종

| Enum | Value | 의미 | 판정 |
|---|---|---|---|
| `SEARCH_ONLY` | `'S'` | read-only | 항상 lock |
| `OPTIONAL` | `'O'` | 신규/수정 선택 입력 | `EDIT_FLAG ≠ 'N'` |
| `MANDATORY` | `'M'` | 신규/수정 필수 입력 | `EDIT_FLAG ≠ 'N'` |
| `OPTIONAL_INSERT_ONLY` | `'IO'` | 신규 행만 선택 입력 | `EDIT_FLAG ≠ 'N'` + `CRUD_TYPE = 'I'` |
| `MANDATORY_INSERT_ONLY` | `'IM'` | 신규 행만 필수 (PK 후보) | `EDIT_FLAG ≠ 'N'` + `CRUD_TYPE = 'I'` |

---

## §2. Column 이름 패턴 → Control Type 표준 매핑

> ⭐ **As-Is `.cs` 가 우선** — 아래 표는 As-Is 미명시 시 default

| 패턴 (Column 이름) | 권장 `_ctrlType` | 비고 |
|---|---|---|
| `*_YN` (ACTIVE_YN / VALID_YN / EDIT_YN ...) | `FPCheckBox` | As-Is 가 text 'Y'/'N' 이면 `FPComboBox` |
| `*_DATE` / `VALID_*_DATE` | `FPDate` | YYYYMMDD |
| `LAST_UPDATE_DATE` / `*_DATETIME` | `FPDateTime` | (보통 read-only) |
| `*_YYYYMM` / `*_MONTH` | `FPDateMonth` | |
| `*_TYPE_CODE` (DATA_TYPE_CODE / FCST_TYPE / INCOTERMS / DOM_EXP ...) | `FPComboBox` | LOOKUP_MASTER_DETAIL |
| `SOLDTO_CODE` / `SHIPTO_CODE` | `FPModal` | `customerByDivisionModal` |
| `PROJECT_CODE` (신규 입력) | `FPModal` | `projectByDivisionModal` (룰 23 §12.A) |
| `ITEM_ID` / `MAPPING_ITEM_ID` (신규 입력) | `FPModal` | `itemByDivisionModal` |
| `END_CUSTOMER` / `SCM_SITE_ID` | `FPModal` 또는 `FPComboBox` | As-Is 의 `cellTypeImage` 여부 |
| `*_QTY` / `*_CNT` / `*_AMOUNT` / `*_AMT` | `FPNumberText` | 천 단위 콤마 + right align |
| `*_RATE` / `*_PERCENT` / `*_PCT` | `FPPercent` | |
| `LAST_UPDATED_BY` / `CREATED_BY` / `OWNER` | `FPText` | read-only |
| `DESCRIPTION` / `NOTE` / `REMARK` | `FPMultiLineTextBox` | 긴 텍스트 |
| 기타 (As-Is 미명시) | `FPText` | default |

---

## §3. 결정 매트릭스 — As-Is `.cs` 패턴 → To-Be Column Meta

| As-Is 패턴 (`.cs`) | To-Be `_inputEditType` | To-Be `_ctrlType` | To-Be `_modalKey` |
|---|---|---|---|
| `LockColumn(col, true)` 만 (항상 lock) | `'S'` | `FPText` (default) | — |
| Lock 미명시 + As-Is Validation 필수 | `'M'` | (이름 패턴) | — |
| Lock 미명시 + As-Is Validation 선택 | `'O'` | (이름 패턴) | — |
| `InsertRow` 안 `cellTypeImage` + 수정 시 lock | `'IM'` | `FPModal` | (호출 modal 명) |
| `SetCellTypeCombo` (전체 row 적용) | `'M'` 또는 `'O'` | `FPComboBox` | — |
| `SetCellTypeCombo` (InsertRow 만) | `'IM'` 또는 `'IO'` | `FPComboBox` | — |
| `SetCellTypeCheckBox` 또는 컬럼명 `*_YN` | `'M'` 또는 `'O'` | `FPCheckBox` | — |
| `SetCellTypeDateTimeFormat` | `'M'` 또는 `'O'` | `FPDate` (또는 DATE_*) | — |

---

## §4. PRE-WRITE 자기 점검

```
☐ As-Is .cs 의 §4 Button + §5 Logic (특히 InsertRow / SetCellType*) 전체 Read?
☐ grep `siMain.(LockColumn|LockRange|SetCellTypeCombo|SetCellTypeCheckBox|SetCellTypeDateTimeFormat)|cellTypeImage` 결과 모두 식별?
☐ 각 column 의 As-Is Validation (mandatory/optional) 매핑됨?
☐ Popup cell 의 호출 modal 인벤토리 확인 (룰 23 §12.A `master/src/components/{xxxByDivisionModal}` 재사용 우선)?
☐ 표준 column 파일 위치 `{screen-slug}/columns/{screen-slug}-columns.ts` 사용?
☐ `_ctrlType` 14종 + `_inputEditType` 5종 import (`@foundation/constants`) 적용?
☐ Popup cell 모두 `_modalKey` 명시?
☐ FlexGrid 직접 사용 0건 (DataGrid 래퍼만)?
☐ `gridRef` + `editTrackerRef` (DataGrid 표준 prop) 사용?
```

**1건이라도 ✗ → 작성 중단, 보완 후 재시작.**

---

## §5. POST-WRITE 자동 검증 grep

```bash
# 1. FlexGrid 직접 사용 0건
grep -rnE "<FlexGrid[ >]" nscm-fe/features/master/src/pages/{screen-slug}/
# 결과 0 → PASS

# 2. column 표준 파일 존재
ls nscm-fe/features/master/src/pages/{screen-slug}/columns/*.ts

# 3. 모든 column 에 _inputEditType 명시
grep -cE "_inputEditType:\s*CELL_INPUT_EDIT_TYPE\.|_inputEditType:\s*'(S|O|M|IO|IM)'" \
     nscm-fe/features/master/src/pages/{screen-slug}/columns/*.ts
# == column 총 개수

# 4. Popup cell _modalKey 명시
POPUP_CNT=$(grep -cE "_ctrlType:.*MODAL|_ctrlType:.*FPModal" nscm-fe/features/master/src/pages/{screen-slug}/columns/*.ts)
MODAL_KEY_CNT=$(grep -cE "_modalKey:" nscm-fe/features/master/src/pages/{screen-slug}/columns/*.ts)
# POPUP_CNT == MODAL_KEY_CNT

# 5. dblClick handler 의 switch case 수 == popup column 수
grep -cE "case '\w+ByDivisionModal'\s*:" nscm-fe/features/master/src/pages/{screen-slug}/**/*.tsx

# 6. As-Is cross-check
grep -cE "siMain\.LockColumn|siMain\.LockRange" Doc/_legacy_source/.../{SCREEN_ID}.cs
# == To-Be column meta 의 _inputEditType: 'S' / 'IM' / 'IO' 카운트

grep -cE "cellTypeImage|SetCellTypeImage" Doc/_legacy_source/.../{SCREEN_ID}.cs
# == To-Be 의 _ctrlType: FPModal 카운트
```

**카운트 1건이라도 불일치 → PR Reject.**

---

## §6. 위반 사례

| 사례 | 위반 패턴 | 결과 |
|---|---|---|
| **DMF0072 신규 작성 (2026-06-02 사용자 지적 전)** | FlexGrid 직접 사용. column meta `_inputEditType` 미명시. SOLDTO/SHIPTO/PROJECT/ITEM 4개 cellTypeImage 가 Modal cell 미구현 | 편집 cell coloring 없음 + popup cell 미동작 (사용자 메뉴 진입 시 신규 입력 불가) |
| **DMF0008 Repair grid (현재)** | FlexGrid 직접 사용 + SOLDTO/SHIPTO/ITEM popup 미구현 | Repair 데이터 row 클릭만 가능, 신규 입력 시 직접 코드 타이핑만 |
| (가상) `*_YN` 컬럼을 `FPText` 로 잘못 매핑 | column 이름 패턴 무시 | 사용자 Y/N 자유 입력 (오타 위험) |
| (가상) `LAST_UPDATED_BY` 를 `_inputEditType: 'M'` | As-Is `LockColumn` 무시 | 사용자가 잘못된 값 입력 → 감사 로그 오염 |

---

## §7. cross-ref + 변경 이력

### cross-ref
- 룰 12 §11.7 Grid Column 메타 표준 (본 hook 의 entry point)
- 룰 25 §1.5.2 As-Is Grid Column 분석 의무
- 룰 23 §12.A 공용 Modal 인벤토리 (`master/src/components/{xxxByDivisionModal}`)
- 룰 24 §3 As-Is Event 축 — `dblClick` / `cellEditEnded` 이벤트 매핑
- 메모리 `feedback_grid_editable_coloring_mandatory.md`
- 메모리 `feedback_grid_popup_cell_mandatory.md`
- 메모리 `feedback_asis_to_tobe_sp_no_omission.md` (As-Is 1:1 보존 의무)

### 변경 이력
- **2026-06-02 작성** (사용자 명시 요구 — DMF0072 NN Master Mapping 작업 + DMF0004 표준 패턴 분석 반영)
