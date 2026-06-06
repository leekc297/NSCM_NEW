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

## Validation 매핑 (Phase 7 보완 C1 — 2026-06-04)

> AS-IS `MessageHelper.GMessageBox` 호출 인벤토리 (active 16건 / comment 14건 — comment 무시).
> TO-BE 의 useMessageStore.setAlert / setToast 매핑 + 미구현 격차 표시.

| # | MSG ID | 의미 | AS-IS 위치 (라인) | trigger | TO-BE 매핑 |
|---:|---|---|---:|---|---|
| 1 | MSG00096 | 권한 없음 | 542, 1405 (2건) | Insert/Save 시 권한 fail | (BE 401 → useApiError) — silently fail |
| 2 | MSG00130 | sheet 변경 안내 | 548 | Tab 전환 시 dirty data 안내 | ❌ 미구현 — TO-BE 는 tab 전환 시 dirty 무시 |
| 3 | MSG00108 | 기간 시작 > 종료 검증 | 734, 806 (2건) | Period column 검증 | ❌ 미구현 (TO-BE Period column 제거됨) |
| 4 | MSG00164 | 기간 3년 초과 | 740, 812 (2건) | Period 검증 | ❌ 미구현 (동일) |
| 5 | MSG00002 | 필수 입력 (5 column) | 1076, 1087, 1098, 1109, 1120 (5건) | SaveSalesSite — SCM_SITE_ID / REP_SOLDTO / REP_SHIPTO / SITE_VALID_YN / CUSTOMER_VALID_YN | ❌ 미구현 (handleSave placeholder) |
| 6 | MSG00004 | Save 결과 (N rows saved) | 1184 | SaveSalesSite 완료 | TO-BE 는 setToast (`G4 useBatchMutation onSuccess`) 동등 — 향후 구현 |
| 7 | MSG00005 | Save 결과 (변경 없음) | 1235 | SaveSSPM 완료 | 동일 |
| 8 | MSG00128 | sheet 별 Insert/Delete 안내 | 1505, 1726, 1861, 2637 (4건) | Repair/SalesSite/SSPM Insert/Delete | ❌ 미구현 (handleInsert placeholder) |
| 9 | MSG00129 | sheet 별 안내 | 2041 | Edit toggle 시 | ❌ 미구현 (Edit toggle 미지원) |
| 10 | MSG00060 | 중복 SCM_SITE_ID | 2135 | cascade Branch (b) | ❌ 미구현 (cascade 미구현 — `cascade-mapping.md` §3.1) |

**총 16 active MSG → TO-BE 0 매핑** (handleSave/handleInsert placeholder + cascade 미구현). 향후 편집 가능 전환 시 본 표 가이드 사용.

### Validation 카운트 (PR 머지 게이트 cross-check)

```bash
rg -nE "MessageHelper\.GMessageBox" {asis-cs} | grep -v "//" | wc -l   # 16
rg -nE "useMessageStore.*setAlert|useMessageStore.*setToast" {tobe-tsx} | wc -l   # 현재 1 (placeholder 안내만)
```

→ 격차 15 건 (의도된 placeholder 상태).

---

## Expression 매핑 (Phase 7 보완 C2 — 2026-06-04)

> AS-IS `LockRange` / `LockColumn` / `SetCellTypeCombo` / `SetValue` Auto-Sync 호출 인벤토리 (60+ 위치).
> TO-BE 의 column meta `_inputEditType` (S/O/M/IO/IM) + cellEditEnded cascade 매핑.

### Lock 패턴 (편집 가능 vs 잠금) — 2 sheet × 분기

| Sheet | Insert 시 lock 범위 | Modify 시 lock 범위 | ADMIN 추가 unlock |
|---|---|---|---|
| SalesSite (siSub) | Division ~ SCM_SITE_ID block + LAST_UPDATE_DATE + LAST_UPDATED_BY (L569+579~584) | Division/SCM_SITE_ID/REP_SOLDTO_CODE/REP_SHIPTO_CODE/LAST_UPDATE_DATE/LAST_UPDATED_BY 6 column (L579~584) | (없음) |
| SSPM (siSub) | Division ~ pSCM_SITE_ID block (L601) + 30+ 개별 column (L608~) | (Modify 시 동일 + 일부 추가 column lock) | DEPT_ID2 / CUST_GROUP / END_CUSTOMER40 / SCM_SITE_ID40 / CELL_TYPE / PRODUCTION_PROCESS / CUST_GROUP_DTL / ROUTE / EDIT_FLAG2 / EDIT_FLAG3 등 12 column (L624~641) — ADMIN/DM ADMIN/SCM PI ADMIN 만 unlock |

### TO-BE column meta 매핑 (룰 08 + 룰 25 §1.5.2)

| AS-IS lock 패턴 | TO-BE column meta |
|---|---|
| 항상 lock (LAST_UPDATE_DATE / LAST_UPDATED_BY 등) | `_inputEditType: 'O'` (read-only) |
| Insert 시 lock + Modify 시 unlock | `_inputEditType: 'IM'` (Insert 시 만 입력) |
| Insert 시 unlock + Modify 시 lock | `_inputEditType: 'IO'` (Modify 시 read-only) |
| 항상 unlock (편집 가능) | `_inputEditType: 'S'` (standard input) |
| Modal cell (combo cell) | `_inputEditType: 'M'` (modal) |
| ADMIN 권한 분기 unlock | TO-BE 는 useUserStore.permission 분기 + columnMeta 동적 변경 (룰 08 §4 동적 column meta) |

### TO-BE 현재 적용 (DMF0008 — read-only)

- 모든 4 grid: `g.isReadOnly = true` (룰 12 §11.7 readOnly coloring 적용)
- 결과: AS-IS 의 모든 LockRange 호출이 무의미 — 전체 grid read-only
- 향후 편집 가능 전환 시: 각 column 별 `_inputEditType` 분류 의무 + ADMIN 권한 분기 (useUserStore 의 permission)

### SetCellTypeCombo (combo cascade) — cascade-mapping.md §5 동일

→ SSPM 의 SalesPlant ↔ SalesCompany combo cascade (룰 07 §2.10.5).

### Expression 카운트 (PR 머지 게이트 cross-check)

```bash
rg -nE "LockRange|LockColumn|LockCell" {asis-cs} | grep -v "//" | wc -l   # 60+
rg -nE "_inputEditType.*'[OIMS]'" {tobe-tsx} | wc -l   # 현재 0 (전체 read-only)
```

→ 격차 60+ 건 (의도된 read-only 상태). 향후 편집 가능 전환 시 `_inputEditType` 메타 60+ column 모두 적용 의무.

---

## Cascade DataModel.Changed 매핑 (Phase 7 보완 8 — 2026-06-04)

> 상세: `Doc/_rules_v2/_asis/02_screens/DMF0008/cascade-mapping.md`

| sheet | sheetName | AS-IS handler | AS-IS 위치 (라인) | TO-BE 현재 (read-only) | 향후 편집 가능 전환 시 |
|---|---|---|---|---|---|
| Summary | main | `shtSummaryDataModel_Changed` (NoOp — body 주석) | L2391 | `g.isReadOnly=true` ✅ 동등 | (불필요) |
| Repair | repair | (handler 부재) | — | `g.isReadOnly=true` ✅ 동등 | (불필요) |
| SalesSite | salesSite | `shtSALES_SITEDataModel_Changed` (5 column trigger / 4 branch) | L2080 | `g.isReadOnly=true` ⚠️ 의도적 차이 | Wijmo `cellEditEnded` + `s.deferUpdate` + 중복 check MSG00060 + Country/City cascade clear |
| SSPM | sspm | `shtSSPMDataModel_Changed` (모든 cell → dtSubBucket sync) | L2279 | `g.isReadOnly=true` ⚠️ | `EditTracker` (dtSubBucket 동등) + Save 시 G4 `useBatchMutation` |
| SalesSite+SSPM 통합 | salesSite/sspm | `spdSub_Changed` (SSPM 만 활성 — PROJECT_CODE/TEAM_ID 변경 시 SalesPlant↔SalesCompany combo cascade) | L2786 | `g.isReadOnly=true` ⚠️ | `useTabComboQueries` filters + cellEditEnded 에서 store action |

**결론**: TO-BE 현재 4 grid 모두 `g.isReadOnly=true` → AS-IS 의 5 cascade 모두 미구현 (의도적). 본 화면이 향후 편집 가능 으로 전환되면 `cascade-mapping.md` 의 §3~§7 을 가이드 사용.

---

## 변경 이력

- 2026-06-02: 신규 작성 (공통 버튼 10대 룰 정비 — DMF0008 UsrConditionPanel 0건 → condition/resetCondition false 명시 의무 충족)
- 2026-06-04: cascade DataModel.Changed 4 sheet × 5 handler 매핑 부록 추가 (Phase 7 보완 8) — `Doc/_rules_v2/_asis/02_screens/DMF0008/cascade-mapping.md` 신규 작성
