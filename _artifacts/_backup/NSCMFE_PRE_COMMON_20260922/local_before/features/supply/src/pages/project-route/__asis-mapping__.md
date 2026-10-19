# SCP0006 Project Route — AS-IS ↔ TO-BE 매핑 매트릭스

AS-IS 정본: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0006_ProjectRoute/SCP0006_ProjectRoute.cs`(2142) + `.Designer.cs`(885).
설계 근거: `.atlas/gscm-design/SCP0006/design/00_checklist.md` · `01_layout.md` · `02_search-combo.md` · `03_grid-columns.md`.

## 레이아웃(design/01)

| AS-IS | AS-IS 라인 | TO-BE |
|---|---|---|
| usrConditionPanel1(HidePanel) | Designer L124-132 | `MainTitle` openSearchArea + `ProjectRouteForm`(SearchArea) |
| splitContainer1(Horizontal) + splitContainer2 | Designer L711/784 | `PanelGroup` vertical(Main 상) → horizontal(BOM 좌·Plant 우), `ProjectRoute.tsx` |
| R1 Division 권한 0건 → SetDivisionAuthCheck | cs L245-246 | MyDivision 콤보 0건 판정(미구현 — §미완, DB권한 실측 필요) |
| R2 Division 82/40 → Project clear·disable, SalesSite ALL | cs L1087-1094 | `isProjectHiddenDivision` → Form projectDisabled + store projectCode='' |
| R3 그 외 division → Project enable | cs L1096-1100 | Form projectDisabled=false |
| R4 clbSalesSite 항상 ALL·비활성 | cs L1089-1098 | Form Sales Site disabled ALL, store scmSiteId='ALL' 고정 |
| R5 btnAllFind Input All | cs L534-552 | `handleInputAll` customButton(SCM0002 미전환 고지) |

## 조회조건(design/02)

| AS-IS 컨트롤 | handler/라인 | TO-BE |
|---|---|---|
| cboDivision (MyDivision) | InitControls L254 / E1 L1142 | `useTabComboQueries(['MyDivision'])` + setSearchParams(division reset) |
| clbSalesSite (死필터) | L1080-1098 | disabled ALL, SP scmSiteId='ALL' |
| txtItemId + btnItemId (Model) | L1292 | InputField + `ItemByDivisionModal` |
| txtProject + btnProject (Project) | L1271 | InputField + `ProjectByDivisionModal`(82/40 disable) |
| drpPeriod (월범위, PERIOD_DEFAULT+11M) | L257-264 / L1106 | `PeriodField mode='month'`, store defaultPeriod(현재월+11M 근사) |
| cboStatus (YesOrNo) | L266 | `useTabComboQueries(['YesOrNo'])` + ALL sentinel |
| dead: GET_DATE_RANGE_1MONTH | L1128 | 미이관(dead) |

## 그리드(design/03) — gridSignals 18 / 이벤트 4 / validation 14 / 진입점 5

| AS-IS | 라인 | TO-BE |
|---|---|---|
| spdMain(siSite, read-only) | InitSpread L317 | `ProjectRouteMainGrid`(DataGrid, staticColumns) |
| spdBOM(siBOM, read-only) | L362 | `ProjectRouteBomGrid` |
| spdPlant(siPlant, 편집) | L411 | `ProjectRoutePlantGrid`(EditTracker) |
| A2 spdSite_CellDoubleClick → BOM 조회 | L1195 | Main dblClick → `applySiteKey` → BOM 필터 |
| A3 spdBOM_CellDoubleClick → Plant 조회 | L1223 | BOM dblClick → `applyBomKey` → Plant 필터 |
| A5 spdPlant_CellDoubleClick → CAPA(SCP0049) | L1389 | 미전환(별도 화면, §미완) |
| A6 spdPlant_Change FROM/TO → ORG/MERGE | L1314 | Plant cellEditEnded → `deriveOrgDates` |
| R-DYN Div 82/40 컬럼 visible | L319-336 | Main `SITE_HIDE_ON_82_40` 필터 |
| SetCalendar 동적 월 컬럼 | L417-431 | `buildMonthColumns`(Period 파생, M_YYYYMM) |
| R11 PLANT_PER_ITEM=nInput/nTot | L611-619 | BOM reload effect → Main 행 갱신 |
| R-EDIT/R-INS-LOCK 편집 5컬럼만 | L493-524 / L1054-1059 | Plant beginningEdit `PLANT_EDITABLE_COLUMNS` 화이트리스트 |
| R-INS-DEF 신규행 기본값 5종 + MSG00116 | L1042-1051 | `handleInsert`(isBomClicked 가드) |
| R-OSCLR 외주 PACKER 클리어(MSG00226) | L1321-1356 | 미구현(osPackItem lookup·SP 미확인, §미완) |
| Delete 'I'행만 | L467-491 | `handleDelete` CRUD_TYPE==='I' |
| Save SAVE_PLANT ^-delim | L823-839 | `handleSave` apiClient.post `/SCP0006/plant/SAVE/call-proc` |

## Validation(design/00 §5.1 · design/03 §3.4)

| MSG | 검증 | TO-BE |
|---|---|---|
| MSG00109 | Main/BOM 편집차단 | Plant readOnly + 읽기전용 그리드 |
| MSG00133 | 수정 내용 없음 | handleSave changed.length===0 |
| MSG00116 | Insert 전 BOM 선행 | handleInsert 가드 |
| MSG00101~110·48 (N1~N9) | Plant 저장검증 | `useProjectRouteValidation.validatePlantSave` |
| MSG00226 (N0) | 외주 PACKER | 미구현(§미완) |
| MSG00097 | 권한 division 없음 | 미구현(§미완) |

## 미완/확인필요 (정직 보고 — convert-core §4.3)

1. **BE 미배포**: SCP0006 6 SP census(2026-07-28) INVALID + admin 컬럼 메타/PLANT_SITE_ID lookup 미등재 → 브라우저 end-to-end 미검증(design/02·03 §확인필요).
2. **SP 반환/파라미터/82분기 계약 추정**: procedures.d.ts SCP0006 컬럼·SAVE payload 키(createdByList 등)는 소스 재구성 계약. SP 본문 확인 후 정합 필요.
3. **N0(외주 PACKER)/CAPA(SCP0049)/Input All(SCM0002)**: 별도 화면·lookup 의존 → 미구현, 트리거만 고지.
4. **N1~N9 group-by 키**: ITEM_ID+SCM_SITE_ID+PROJECT_CODE 가정 — AS-IS checkValidN* 정확 scope SP 확인 필요.
5. **R1 권한 판정 / PERIOD_DEFAULT 계산식**: DB 실측 차단 → 근사(현재월+11M) + 권한판정 미구현.
