# DMF0043_01 (Contribute View) — As-Is ↔ To-Be 4축 매핑

화면 ID: **DMF0043_01**
As-Is 소스: `Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Master/DMF0043_Contribute_View/`
To-Be 위치: `nscm-fe/features/master/src/pages/contribute-view/`
작성: 2026-06-02 (룰 25 §1.5.1 / §1.5.3 / 룰 12 §11.8 적용)

---

## Button 매핑 (CRUD 6대 — 룰 25 §1.5.1)

| Button | As-Is 메서드 (라인) | As-Is 본문 요약 | To-Be hotkeyConfig | To-Be 결정 | 비고 |
|---|---|---|---|---|---|
| Search | `FindButton` L244 | `FindData()` | `search` | `handleSearch` (function) | 활성 |
| Insert | `InsertButton` L249 | `InsertRow()` | `insert` | `handleInsert` (TODO placeholder) | As-Is 본문 있음 — Figma "조회 전용" 의도와 충돌. placeholder 안내 (silent fail 방지) |
| Delete | `DeleteButton` L254 | 주석 처리됨 (전체 주석) | `delete` | `false` | 명시 숨김 |
| Edit | `EditButton` L268 | 빈 본문 `{ }` | (별도 IsReadOnly toggle) | hotkeyConfig 미지원 | |
| Save | `SaveButton` L276 | `SaveData()` | `save` | `handleSave` (TODO placeholder) | As-Is 본문 있음 — placeholder 안내 |
| Excel | `ExcelButton` L282 | `SimpleExcelService.ExportFpSpread` | `_Excel` (생략) | SubTitle 기본 Excel | 자동 활성 |
| Manual | (없음) | — | `manual` | `false` | 명시 숨김 |
| Upload | (없음) | — | `upload` | `false` | 명시 숨김 |

특화 버튼 (customButtons):
- `⊞ 컬럼 표시 설정` → ColumnTitleSetModal (As-Is `btnColumn_Click` L473)
- `기여율 버전관리` → ContributeVersionModal (As-Is `btnCutOff_Click` L444 / Form 의 icon button 으로 이동, 2026-06-01 사용자 요구)

## Search Aux 매핑 (4대 — 룰 25 §1.5.3 / 룰 12 §11.8)

| Hotkey | As-Is 위치 (BaseForm default) | 화면 override | UsrConditionPanel | DataGrid 활성 요건 | To-Be 결정 |
|---|---|---|---|---|---|
| F3 sort | `BaseForm.cs:5268 OnClickSortButton` | 없음 | — | FlexGrid default allowSorting=true | (생략 = 자동 활성) |
| F4 filter | `BaseForm.cs:5054 OnClickFilterButton` | 없음 | — | `useRef<FlexGridFilter>` (L29) + `<SubTitle gridFilter>` (L160) | (생략 = 자동 활성) |
| F6 condition | `BaseForm.cs:5237 OnClickConditionButton` | 없음 | ✅ 존재 (Designer L35) | — | (생략 = 자동 활성) |
| F10 resetCondition | `BaseForm.cs:5245 OnClickResetConditionButton` | 없음 | ✅ | — | (생략 = 자동 활성) |

UsrConditionPanel 확인 grep:
```
Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Master/DMF0043_Contribute_View/DMF0043_Contribute_View.Designer.cs:35
  this.usrConditionPanel1 = new GSCM.Windows.Forms.Controls.UsrConditionPanel(this.components);
```

---

## API 매핑

| sheetName | BE API_ID | BE SP | 메타 |
|---|---|---|---|
| main | (parent DMF0043 메타 fallback) | DMF0043_GET_CONTRIBUTION_SALES_LIST | 42_DMF0043_01_meta.sql + 41_DMF0043_meta.sql |
| mainTitle | parent fallback | DMF0043_GET_SALES_LIST_SPREAD_TITLE | 41 |
| version | parent fallback | DMF0043_GET_MAIN_VARSION_DATA | 41 |
| ratePopup | parent fallback | DMF0043_GET_CONTRIBUTE_RATE_POPUP | 41 |
| versionPopup | parent fallback | DMF0043_GET_CONT_VIEW_VERSIONPOPUP | 41 |
| titleSet | P_DMF0043_01_TITLESET_GET | DMF0002_GET_TITLESET_POPUP (공용) | 48_DMF0043_01_TitleSet_Meta.sql |

SP body 동봉: `_artifacts/_deploy_packages/DMF0043_01/03_SP_PKG/50_DMF0002_titleset_SP_body.sql` (공용 — 환경 사전 존재 확인 의무).

---

## POPUP / Modal 매핑

| Modal 컴포넌트 | 호출 시점 | 비고 |
|---|---|---|
| ContributeVersionModal | 기여율 버전관리 customButton | 화면 전용 (DMF0043 와 다름) |
| ColumnTitleSetModal | ⊞ 컬럼 표시 설정 customButton | 화면 전용 |
| ContributeRatePopup | (DMF0043 재사용) | 공용 |

---

## 변경 이력

- 2026-06-02: 신규 작성 (공통 버튼 10대 룰 정비 — 화면 의도 "조회 전용" vs As-Is .cs 본문 존재 충돌 → As-Is 1:1 정합 우선 정책으로 Insert/Save = placeholder)
