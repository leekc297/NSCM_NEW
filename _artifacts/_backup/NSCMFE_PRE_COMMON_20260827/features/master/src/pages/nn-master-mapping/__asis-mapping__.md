# DMF0072 (NN Master Mapping) — As-Is ↔ To-Be 4축 매핑

화면 ID: **DMF0072**
As-Is 소스: `Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Master/DMF0072_NNMasterMapping/`
To-Be 위치: `nscm-fe/features/master/src/pages/nn-master-mapping/`
작성: 2026-06-02 (룰 25 §1.5.1 / §1.5.3 / 룰 12 §11.8 적용 — 공통 버튼 10대)

---

## Button 매핑 (CRUD 6대 — 룰 25 §1.5.1 / hook asis-button-mapping §1~4)

| Button | As-Is 메서드 (라인) | As-Is 본문 요약 | To-Be hotkeyConfig | To-Be 결정 | 비고 |
|---|---|---|---|---|---|
| Search | `FindButton` L266 | `FindData(true)` (조회) | `search` | `handleSearch` (function) | 활성 |
| Insert | `InsertButton` L271 | `InsertRow()` — DATA_TYPE='SCM' 기본 + cellType 설정 | `insert` | `handleInsert` (function) | 활성 — 신규 행 추가 |
| Delete | `DeleteButton` L277 | `siMain.Delete()` — 'I' 행만 삭제 | `delete` | `handleDelete` (function) | 활성 — CRUD_TYPE='I' 가드 |
| Edit | `EditButton` L281~310 | `SwitchLock + LockRange` (수정 모드 토글) | (별도 IsReadOnly toggle) | hotkeyConfig 미지원 | 화면 자체 read-only 토글 |
| Save | `SaveButton` L389 | `SaveData()` — Validation + SAVE SP 호출 (^ join) | `save` | `handleSave` (function) | 활성 |
| Excel | `ExcelButton` L398 | `SimpleExcelService.ExportFpSpread` | `_Excel` (생략) | SubTitle 기본 Excel | 자동 활성 |
| Manual | (없음) | — | `manual` | `false` | 명시 숨김 |
| Upload | (없음) | — | `upload` | `false` | 명시 숨김 |

## Search Aux 매핑 (4대 — 룰 25 §1.5.3 / 룰 12 §11.8 / hook asis-button-mapping §3.5)

| Hotkey | As-Is 위치 (BaseForm default) | 화면 override | UsrConditionPanel | DataGrid 활성 요건 | To-Be 결정 |
|---|---|---|---|---|---|
| F3 sort | `BaseForm.cs:5268 OnClickSortButton` | 없음 | — | FlexGrid default allowSorting=true | (생략 = 자동 활성) |
| F4 filter | `BaseForm.cs:5054 OnClickFilterButton` | 없음 | — | `useRef<FlexGridFilter>` + `<SubTitle gridFilter={ref}>` (L73, L347) | (생략 = 자동 활성) |
| F6 condition | `BaseForm.cs:5237 OnClickConditionButton` | 없음 | ✅ 존재 (Designer L37 + `.cs` L210 `usrConditionPanel1.Height=70`) | — | (생략 = 자동 활성) |
| F10 resetCondition | `BaseForm.cs:5245 OnClickResetConditionButton` | 없음 | ✅ | — | (생략 = 자동 활성) |

UsrConditionPanel 존재 확인 grep:
```
Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Master/DMF0072_NNMasterMapping/DMF0072_NNMasterMapping.Designer.cs:37
  this.usrConditionPanel1 = new GSCM.Windows.Forms.Controls.UsrConditionPanel(this.components);
```

---

## Grid Column 매핑 (룰 25 §1.5.2 / 룰 12 §11.7)

상세는 사내 DB `SCM_MST_SHEET_COLUMNS` (PROGRAM_ID='DMF0072', SHEET_NAME='main', 23 row) 참조 — 2026-06-20 BE 메타 등록 후 FE `MAIN_COLUMNS` 하드코딩 제거 (룰 #65 ui-category-setup-column-meta). 등록 source: `_artifacts/_deploy_packages/DMF0072/03_META/080_DMF0072_dynamic_property_management.sql` BLOCK 3.

---

## API 매핑 (룰 10 / 룰 22 §9)

| sheetName | BE API_ID | BE SP | 메타 |
|---|---|---|---|
| main | P_DMF0072_GET | DMF0072_GET_NNMASTER_MAPPING_WRAPPER → DMF0072_GET_NNMASTER_MAPPING | 44_DMF0072_meta.sql |
| main | P_DMF0072_SAVE | DMF0072_SAVE_NNMASTER_MAPPING | 44_DMF0072_meta.sql |
| dataType | P_DMF0072_DATATYPE_GET | DMF0072_GET_DATA_TYPE_LIST | 60_DMF0072_lookup_meta_boost.sql |
| division | P_DMF0072_DIVISION_GET | DMF0008_GET_MY_DIVISION_LIST (공용) | 60_*_boost.sql |
| team | P_DMF0072_TEAM_GET | DMF0072_GET_TEAM_LIST | 60_*_boost.sql |
| endCustomer | P_DMF0072_ENDCUST_GET | DMF0072_GET_END_CUSTOMER_LIST | 60_*_boost.sql |
| salesSite | P_DMF0072_SALESSITE_GET | DMF0072_GET_SALES_SITE_LIST | 60_*_boost.sql |
| projectPopup | P_DMF0072_PROJECT_POPUP_GET | DMF0072_GET_PROJECT_POPUP_LIST | 55_DMF0072_popup_meta.sql |
| itemPopup | P_DMF0072_ITEM_POPUP_GET | DMF0072_GET_ITEM_POPUP_LIST | 55_DMF0072_popup_meta.sql |

---

## POPUP / Modal 매핑 (룰 25 §3.3.1)

| Modal 컴포넌트 | 호출 시점 | 공용 / 화면 전용 |
|---|---|---|
| CustomerModal | grid SOLDTO/SHIPTO dblClick | 공용 (master/src/components/) |
| ProjectByDivisionModal | grid PROJECT dblClick | 공용 |
| ItemByDivisionModal | grid ITEM/MAPPING_ITEM dblClick | 공용 |

---

## 변경 이력

- 2026-06-02: 신규 작성 (공통 버튼 10대 룰 정비 — 룰 25 §1.5.1/§1.5.3 + 룰 12 §11.8 적용)
