# DMF0008 (ERP EDI Master) — As-Is ↔ To-Be 4축 매핑

화면 ID: **DMF0008**
As-Is 소스: `Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Master/DMF0008_ErpEdiMaster/`
To-Be 위치: `nscm-fe/features/master/src/pages/erp-edi-master/`
작성: 2026-06-02 (룰 25 §1.5.1 / §1.5.3 / 룰 12 §11.8 적용)

---

## Button 매핑 (CRUD 6대 — 룰 25 §1.5.1)

| Button | As-Is 메서드 (라인) | As-Is 본문 요약 | To-Be hotkeyConfig | To-Be 결정 | 비고 |
|---|---|---|---|---|---|
| Search | `FindButton` L522 | `FindData_Main / FindData_Sub` (spdSummary/spdSub 분기) | `search` | `handleSearch` (function) | 활성 |
| Insert | `InsertButton` L541 | `InsertRow()` (Repair/SalesSite/SSPM sub grid) | `insert` | `handleInsert` (TODO placeholder) | As-Is 본문 있음 — placeholder 안내 (silent fail 방지) |
| Delete | `DeleteButton` L546 | 빈 본문 `{ }` | `delete` | `false` | 명시 숨김 |
| Edit | `EditButton` L551 | `SwitchLock` + 권한 분기 ("SCP Planner") | (별도 IsReadOnly toggle) | hotkeyConfig 미지원 | |
| Save | `SaveButton` L808 | `SaveSalesSite() / SaveSSPM()` (spdSub 만, spdMain 빈) | `save` | `handleSave` (TODO placeholder) | As-Is 본문 있음 — placeholder 안내 |
| Excel | `ExcelButton` L832 | `SimpleExcelService.ExportFpSpread` | `_Excel` (생략) | SubTitle 기본 Excel | 자동 활성 |
| Manual | (없음) | — | `manual` | `false` | 명시 숨김 |
| Upload | (없음) | — | `upload` | `false` | 명시 숨김 |

특화 버튼:
- `Status Update` → `customButtons` (As-Is `btnStatusUpdate_Click` .cs L2565~2620 — `PR_DM_DNM_EDI_CALLOFF_STATUS` 호출 후 Summary + Repair + UpdateHistory 자동 재조회)

## Search Aux 매핑 (4대 — 룰 25 §1.5.3 / 룰 12 §11.8)

| Hotkey | As-Is 위치 (BaseForm default) | 화면 override | UsrConditionPanel | DataGrid 활성 요건 | To-Be 결정 |
|---|---|---|---|---|---|
| F3 sort | `BaseForm.cs:5268 OnClickSortButton` | 없음 | — | FlexGrid default allowSorting=true (4 grids 모두) | (생략 = 자동 활성) |
| F4 filter | `BaseForm.cs:5054 OnClickFilterButton` | 없음 | — | `useRef<FlexGridFilter>` (L47) + `<SubTitle gridFilter>` (L251) | (생략 = 자동 활성) |
| F6 condition | `BaseForm.cs:5237 OnClickConditionButton` | 없음 | ❌ **0건 (grep 결과 없음)** | — | **`condition: false`** (명시 숨김 — 룰 25 §1.5.3 의무) |
| F10 resetCondition | `BaseForm.cs:5245 OnClickResetConditionButton` | 없음 | ❌ 0건 | — | **`resetCondition: false`** (명시 숨김) |

UsrConditionPanel grep 결과:
```
grep -nE "UsrConditionPanel|usrCondition" Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Master/DMF0008_ErpEdiMaster/*.cs
→ 0 건
```

---

## API 매핑 (룰 10 / 룰 22 §9)

| sheetName | BE API_ID | BE SP | 메타 |
|---|---|---|---|
| main | P_DMF0008_SUMMARY_GET | DMF0008_GET_EDI_MST_SUMMARY | 49_DMF0008_meta.sql |
| main | P_DMF0008_STATUS_UPDATE | DMF0008_STATUS_UPDATE_WRAPPER → PR_DM_DNM_EDI_CALLOFF_STATUS | 51_DMF0008_status_update_meta.sql |
| repair | P_DMF0008_REPAIR_GET / SAVE | DMF0008_GET / SAVE_SALES_SITE_EDI_REPAIR | 50_DMF0008_phase2_meta.sql |
| salesSite | P_DMF0008_SALES_SITE_GET | DMF0008_GET_SALES_SITE | 50 |
| sspm | P_DMF0008_SSPM_GET | DMF0008_GET_SALES_SITE_PROJECT_MODEL | 50 |
| project | P_DMF0008_PROJECT_GET / SAVE | DMF0008_GET_SALES_SITE_PROJECT_MODEL / SAVE_*_EDI_REPAIR | 50 |
| division | P_DMF0008_DIVISION_GET | DMF0008_GET_MY_DIVISION_LIST | 49 |
| updateHistory | P_DMF0008_UPDATE_HISTORY_GET | DMF0008_GET_UPDATE_HISTORY (wrapper → DMF0000_GET_UPDATE_HISTORY) | 52_DMF0008_updateHistory_meta_boost.sql |

---

## POPUP / Modal 매핑

| Modal 컴포넌트 | 호출 시점 | 비고 |
|---|---|---|
| (Repair) CustomerModal / ProjectByDivisionModal / ItemByDivisionModal | sub grid dblClick | 공용 |

---

## 변경 이력

- 2026-06-02: 신규 작성 (공통 버튼 10대 룰 정비 — DMF0008 UsrConditionPanel 0건 → condition/resetCondition false 명시 의무 충족)
