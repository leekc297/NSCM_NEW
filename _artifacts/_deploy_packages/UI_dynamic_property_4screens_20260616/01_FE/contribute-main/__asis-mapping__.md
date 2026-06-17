# DMF0043 (Contribute Main) — As-Is ↔ To-Be 4축 매핑

화면 ID: **DMF0043**
As-Is 소스: `Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Master/DMF0043_Contribute_Main/`
To-Be 위치: `nscm-fe/features/master/src/pages/contribute-main/`
작성: 2026-06-02 (룰 25 §1.5.1 / §1.5.3 / 룰 12 §11.8 적용)

---

## Button 매핑 (CRUD 6대 — 룰 25 §1.5.1)

| Button | As-Is 메서드 (라인) | As-Is 본문 요약 | To-Be hotkeyConfig | To-Be 결정 | 비고 |
|---|---|---|---|---|---|
| Search | `FindButton` L164 | `CheckForIllegalCrossThreadCalls=false; FindData();` | `search` | `handleSearch` (function) | 활성 |
| Insert | `InsertButton` L170 | 주석 처리됨 (`//InsertRow();`) | `insert` | `false` | 명시 숨김 — As-Is 빈 본문 |
| Delete | `DeleteButton` L175 | 주석 처리됨 (전체 주석) | `delete` | `false` | 명시 숨김 |
| Edit | `EditButton` L189 | `siMain.SwitchLock` + usrHis 조건 분기 | (별도 IsReadOnly toggle) | hotkeyConfig 미지원 | |
| Save | `SaveButton` L211 | `SaveData()` (Validation + ^ join + SAVE SP) | `save` | `handleSave` (function) | 활성 |
| Excel | `ExcelButton` L217 | `SimpleExcelService.ExportFpSpread` | `_Excel` (생략) | SubTitle 기본 Excel | 자동 활성 |
| Manual | (없음) | — | `manual` | `false` | 명시 숨김 |
| Upload | (없음) | — | `upload` | `false` | 명시 숨김 |

특화 버튼:
- `기여율 버전관리` → `customButtons` (As-Is `btnCutOff_Click` — VersionPopup 열기)

## Search Aux 매핑 (4대 — 룰 25 §1.5.3 / 룰 12 §11.8)

| Hotkey | As-Is 위치 (BaseForm default) | 화면 override | UsrConditionPanel | DataGrid 활성 요건 | To-Be 결정 |
|---|---|---|---|---|---|
| F3 sort | `BaseForm.cs:5268 OnClickSortButton` | 없음 | — | FlexGrid default allowSorting=true | (생략 = 자동 활성) |
| F4 filter | `BaseForm.cs:5054 OnClickFilterButton` | 없음 | — | `useRef<FlexGridFilter>` (L23) + `<SubTitle gridFilter>` (L241) | (생략 = 자동 활성) |
| F6 condition | `BaseForm.cs:5237 OnClickConditionButton` | 없음 | ✅ 존재 (Designer L35) | — | (생략 = 자동 활성) |
| F10 resetCondition | `BaseForm.cs:5245 OnClickResetConditionButton` | 없음 | ✅ | — | (생략 = 자동 활성) |

UsrConditionPanel 확인 grep:
```
Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Master/DMF0043_Contribute_Main/DMF0043_Contribute_Main.Designer.cs:35
  this.usrConditionPanel1 = new GSCM.Windows.Forms.Controls.UsrConditionPanel(this.components);
```

---

## API 매핑

| sheetName | BE API_ID | BE SP | 메타 |
|---|---|---|---|
| main | P_DMF0043_GET / SAVE | DMF0043_GET_CONTRIBUTE_MAIN_DATA / SAVE_DM_MST_CONTRIBUTE_RATIO | 41_DMF0043_meta.sql |
| version | P_DMF0043_VERSION_GET / SAVE | DMF0043_GET_MAIN_VARSION_DATA / SAVE_DM_MST_CONTRIBUTE_VER | 41 |
| yearPopup | P_DMF0043_YEAR_POPUP_GET | DMF0043_GET_CONTRIBUTE_YEAR_POPUP | 41 |
| ratePopup | P_DMF0043_RATE_POPUP_GET | DMF0043_GET_CONTRIBUTE_RATE_POPUP | 41 |
| versionPopup | P_DMF0043_VERSIONPOPUP_GET | DMF0043_GET_CONT_VIEW_VERSIONPOPUP | 41 |
| mainTitle | P_DMF0043_MAIN_TITLE_GET | DMF0043_GET_MAIN_SPREAD_TITLE | 41 |

SP body: `_artifacts/_deploy_packages/DMF0043/03_SP_PKG/65_DMF0043_main_SP_bodies.sql` (9 SP)

---

## POPUP / Modal 매핑

| Modal 컴포넌트 | 호출 시점 | 비고 |
|---|---|---|
| ContributeRatePopup | customButton 또는 grid dblClick | 화면 전용 |
| VersionPopup | 기여율 버전관리 customButton | 화면 전용 |

---

## 변경 이력

- 2026-06-02: 신규 작성 (공통 버튼 10대 룰 정비)
