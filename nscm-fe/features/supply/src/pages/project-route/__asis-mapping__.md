# SCP0006 Project Route — AS-IS ↔ TO-BE 매핑 매트릭스

AS-IS 정본: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0006_ProjectRoute/SCP0006_ProjectRoute.cs`(2142) + `.Designer.cs`(885).
설계 근거: `.atlas/gscm-design/SCP0006/design/00_checklist.md` · `01_layout.md` · `02_search-combo.md` · `03_grid-columns.md`.

## 레이아웃(design/01)

| AS-IS | AS-IS 라인 | TO-BE |
|---|---|---|
| usrConditionPanel1(HidePanel) | Designer L124-132 | `MainTitle` openSearchArea + `ProjectRouteForm`(SearchArea) |
| splitContainer1(Horizontal) + splitContainer2 | Designer L711/784 | `PanelGroup` vertical(Main 상) → horizontal(BOM 좌·Plant 우), `ProjectRoute.tsx` |
| R1 Division 권한 0건 → SetDivisionAuthCheck | cs L245-246 | `Division_SCP` 콤보(EE 제외 후) 0건 판정 → `ProjectRouteForm.tsx` `noDivisionAuth`(MSG00097 alert + Division/Project/Model/Status/Search 비활성) — **구현됨**(design/03 gap 재확인 결과 정정, 2026-09-21). PeriodField 는 공용 컴포넌트가 disabled prop 미제공이라 값 입력만 남는 부분비활성 잔여(04_react-gap 기재) |
| R2 Division 82/40 → Project clear·disable, SalesSite ALL | cs L1087-1094 | `isProjectHiddenDivision` → Form projectDisabled + store projectCode='' |
| R3 그 외 division → Project enable | cs L1096-1100 | Form projectDisabled=false |
| R4 clbSalesSite 항상 ALL·비활성(선택값), 후보목록은 division별 실조회 | cs L1089-1098 | Form Sales Site disabled + value='ALL' 고정, store scmSiteId='ALL' 고정 SP 전달. 옵션 목록은 `SaleSiteByDivision1_SCP_ALL` 콤보 실조회(2026-09-22 정정 — 아래 §정정 참고) |
| R5 btnAllFind Input All | cs L534-552 | `handleInputAll` → `ProjectRouteListSaveModal`(구현·admin 등록 완료, 2026-09-22 실 HTTP 왕복 검증 — 아래 미완 목록 §3 정정 참고) |

## 조회조건(design/02)

| AS-IS 컨트롤 | handler/라인 | TO-BE |
|---|---|---|
| cboDivision (`BLUtils.GetDivisionWithoutEE`) | InitControls L254 / E1 L1142 | `useTabComboQueries(['Division_SCP'])` + `EXCLUDE_EE_DIVISION` 클라 필터(2026-09-22 정정, 아래 §정정) + setSearchParams(division reset) |
| clbSalesSite (死필터) | L1080-1098 | 선택값 disabled ALL, SP scmSiteId='ALL' 고정. 옵션은 `useTabComboQueries([{comboId:'SaleSiteByDivision1_SCP_ALL', divisionId}])` 실조회(2026-09-22 정정) |
| txtItemId + btnItemId (Model) | L1292 | InputField + `ItemByDivisionModal` |
| txtProject + btnProject (Project) | L1271 | InputField + `ProjectByDivisionPopup`(base/프1, 2026-09-22 정정 — 아래 §정정 참고)(82/40 disable) |
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
| R-OSCLR 외주 PACKER 클리어(MSG00226) | L1321-1356 | 미구현 — **AS-IS 자체가 dead code라 정합**(design/03 §3 R-OS-DEAD 확정, 2026-09-21 정정. `ChkPlantOs` 호출부 0건 + `checkValidN0` 호출도 주석-out. 이전 서술 "ChkPlantOs 셀이벤트로 살아있다"는 부정확했음) |
| Delete 'I'행만 | L467-491 | `handleDelete` CRUD_TYPE==='I' |
| Save SAVE_PLANT ^-delim | L823-839 | `handleSave` apiClient.post `/SCP0006/plant/SAVE/call-proc` |

## Validation(design/00 §5.1 · design/03 §3.4)

| MSG | 검증 | TO-BE |
|---|---|---|
| MSG00109 | Main/BOM 편집차단 | Plant readOnly + 읽기전용 그리드 |
| MSG00133 | 수정 내용 없음 | handleSave changed.length===0 |
| MSG00116 | Insert 전 BOM 선행 | handleInsert 가드 |
| MSG00101~110·48 (N1~N9) | Plant 저장검증 | `useProjectRouteValidation.validatePlantSave` |
| MSG00226 (N0) | 외주 PACKER | 미구현 — AS-IS 자체가 dead code라 정합(§R-OS-DEAD 참고) |
| MSG00097 | 권한 division 없음 | 구현됨(`ProjectRouteForm.tsx` noDivisionAuth, 2026-09-21 정정) |

## 미완/확인필요 (정직 보고 — convert-core §4.3)

1. **BE 미배포**: SCP0006 6 SP census(2026-07-28) INVALID + admin 컬럼 메타/PLANT_SITE_ID lookup 미등재 → 브라우저 end-to-end 미검증(design/02·03 §확인필요).
2. **SP 반환/파라미터/82분기 계약 추정**: procedures.d.ts SCP0006 컬럼·SAVE payload 키(createdByList 등)는 소스 재구성 계약. SP 본문 확인 후 정합 필요.
3. **N0(외주 PACKER)/CAPA(SCP0049)**: 별도 화면·lookup 의존 → 미구현, 트리거만 고지. ~~Input All(SCM0002)~~ — **정정(2026-09-22)**: admin 등록(`SCM_ADM_MNU_M`/`MNU_BTN_MPG_M`/`USER_GR_MNU_BTN_MPG_M`/`API_M`/`PROC_M`)이 실제로는 2026-09-17에 이미 완료돼 있었음을 DB 재실측으로 확인 — "미구현" 판정은 stale 코드 주석에 근거한 오판이었다. 로컬 BE 실 HTTP 왕복(`minyonglee1`, division=40)으로 `o_rc1` 4행 정상 수신까지 확인했다(`.atlas/gscm-design/SCP0006/design/05_register_inputall_popup.sql` 참고 — 이미 적용돼 있어 재실행해도 무해).
4. **N1~N9 group-by 키**: ITEM_ID+SCM_SITE_ID+PROJECT_CODE 가정 — AS-IS checkValidN* 정확 scope SP 확인 필요.
5. **PERIOD_DEFAULT 계산식**: DB 실측 차단(`PERIOD_DEFAULT` CommonData SQL 미확인) → 근사(현재월+11M)로 대체 중, SP 확인 후 정합 조정 필요. R1 권한판정(MSG00097) 자체는 구현됨(위 표 정정).

## 정정(2026-09-22) — Division/Sales Site 콤보 ID

사용자 지적으로 재확인한 결과 두 콤보 ID가 이 화면의 실제 AS-IS 호출 체인과 무관한 값이었다 — 결과가 우연히 같아 여러 차례의 감사(v4~v7)에서도 걸러지지 않았다.

- **Division**: `MyDivision` → `Division_SCP` + 클라 EE 제외(`EXCLUDE_EE_DIVISION`). AS-IS `BLUtils.GetDivisionWithoutEE(false,"")`는 `GetDivision()`(=`Data_SCP.Common(Type.Division,...)`→`_SCP`, BLUtils.cs L58-71)로 권한 스코프 목록을 얻은 뒤 `DBUtils.Filter("ATTRIBUTE3<>'EE'")`(BLUtils.cs L107-117)로 **클라이언트에서** EE를 제외하는 2단계 구조다. `Division_SCP`(ora.py 실측: 권한 서브쿼리 동일, EE 필터 없음)가 정확히 1단계이고, `MyDivision`은 이 화면과 무관한 별개 콤보가 우연히 서버 SQL에 EE 필터까지 이미 박아둔 것이었다(실측: division=40 세션 기준 두 경로 모두 최종 8행 81/40/82/81_UC/81_HM/81_ST/81_HD/81_HG로 동일 — 결과가 같아서 3차례 감사를 통과했다).
- **Sales Site**: 선택값·SP 파라미터는 그대로(`ALL` 고정, 변경 없음). 이전엔 옵션 목록 자체를 하드코딩(`{ALL}` 단일 항목)해 콤보를 전혀 호출하지 않았다 — AS-IS `dtSalesSiteAll = Data_SCP.CommonAll(Type.SaleSiteByDivision1, false, "")`(cs L51)는 `_SCP_ALL`(권한 무시 전체) 콤보를 실제로 호출해 목록을 채운 뒤 비활성화하므로, TO-BE도 `SaleSiteByDivision1_SCP_ALL`(ora.py 실측 확인)을 호출해 화면 표시까지 맞춘다.
- 근거: 로컬 BE 실 HTTP 왕복(`minyonglee1`) — `Division_SCP` 14행(EE 4행 포함) 중 EE 제외 후 8행이 `MyDivision`의 기존 8행과 일치 확인. `SaleSiteByDivision1_SCP_ALL`(division=40) 1295행 정상 수신 확인.

## 사용자 지시 변경(2026-09-23) — 조회조건 라벨/Sales Site 노출/팝업 재배선

아래 4건은 AS-IS 원본 매핑이 아니라 **사용자 업무 요구사항 변경**으로 적용했다(스펙과 AS-IS가
어긋나면 먼저 보고하고 결정을 받는 CLAUDE.local.md §7 원칙에 따라 사용자에게 직접 확인 후 진행,
확인 근거는 아래 각 항목 참고).

1. **조회조건 라벨**: Project → `LBL00012`("PJT"), Model → `LBL00618`("Model/Nickname")로 교체.
   두 키 모두 KO/EN 로케일에 기존 등록돼 있어 신규 등록 불필요(`public/locales/KO.json`,`EN.json` 확인).
2. **Sales Site 조건 숨김**: 선택값·검색 파라미터는 기존과 동일하게 항상 `'ALL'` 고정 전송하되
   (`useProjectRouteStore.setSearchParams`가 이미 강제), 화면에는 노출하지 않도록 `FormItem`/콤보
   fetch(`salesSiteRows`)를 제거했다. 死필터라는 사실 자체는 바뀌지 않음(§2 확인 필요 항목 2 참고).
3. **PJT 팝업 프1→프2**: 바로 위 §정정(2026-09-22)이 DB 실측 기반으로 "프1(SCM0002 base,
   ProjectByDivisionPopup)이 정확하다"고 확정했음에도, **사용자가 업무 요구사항 변경으로 프2(COM0005,
   DMF000_ProjectbyDivisionPopupEx 공용, `ProjectByDivisionModal`)로 명시 지시**(2026-09-23,
   AskUserQuestion 확인) — AS-IS 정본과 다른 팝업이 의도적으로 연결된 상태다. 향후 재감사 시
   "다시 프1로 되돌리는 회귀"로 오판하지 말 것.
4. **Model 팝업 모1→메1**: 마찬가지로 모1(SCM0002 base, `ModelByDivisionPopup`)에서 메1(COM0013,
   SCM0002_MaterialByDivisionPopup 공용, `MaterialByDivisionModal`)로 사용자 지시 변경(2026-09-23).
   "Model" 필드인데 Material 팝업이 연결된 것은 오배선이 아니라 사용자가 확인 후 선택한 결과다
   (AskUserQuestion에서 §1 라벨 변경("Model/Nickname")과 더 잘 맞는 모3(ItemByDivisionModal)도
   대안으로 제시했으나 메1을 선택함).

## 정정(2026-09-22) — Project 팝업(base/프1) 컴포넌트

`ProjectRouteForm.tsx`의 Project 필드(`txtProject`+`btnProject`)가 지금까지 `ProjectByDivisionModal`(COM0005 Ex 계열, AS-IS `DMF000_ProjectbyDivisionPopupEx`, "프2")로 연결돼 있었으나, design/02_search-combo.md §4.6·§7-8(DB 실측 기반)이 확정한 AS-IS 클래스는 `SCM0002_ProjectbyDivisionPopup`(base, "프1")이다 — 두 팝업은 이름은 비슷하지만 서로 다른 AS-IS 클래스다(combo-semantic-parity 원칙과 동일하게 팝업도 이름 유사 재사용 금지 대상). `ProjectByDivisionPopup`(`features/master/src/components/projectByDivisionPopup`)이 정확히 이 base 팝업의 TO-BE 컴포넌트다(SCP0009 에서 이미 프1로 사용 중). Model 필드의 모1 교정(위 §정정과 별개, 2026-09-22 동일 세션)과 같은 유형의 오배선이라 같은 방식으로 교체했다.

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0, 2026-09-21 gap-resolve iter-1 신설)

> `asis_mapping_gate.py --init` 추출: CRUD 0건(이 화면 00_checklist.md §4는 `toolbarOverride` 컬럼이 없는 구조라 CRUD 자동분류 대상 없음 — §4d 버튼가드/§4e validations는 위 "그리드(design/03)"·"Validation" 표에 이미 서술) + MODAL 2건.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:ProjectRouteListSaveModal | FE 실존 모달 (components/modals/ProjectRouteListSaveModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | `components/modals/ProjectRouteListSaveModal.tsx`(전체), 트리거는 `ProjectRoute.tsx:287` `handleInputAll` |  | 구현 |
| MODAL:ShowDialog | AS-IS 팝업(분석 md, §4f 4건의 트리거 컬럼이 전부 `ShowDialog(modal)`이라 도구가 이 4건을 단일 ID로 묶어 추출함) — TO-BE 모달 구현 위치 기입 의무 | §4f #1 `SCM0002_ProjectRouteListSavePopup`→`ProjectRouteListSaveModal.tsx`(구현), #2 `SCM0002_ProjectbyDivisionPopup`→`ProjectByDivisionPopup`(base/프1, `ProjectRouteForm.tsx`, 2026-09-22 정정 — 아래 §정정 참고, 구현), #3 `SCM0002_ItembyDivisionPopup`→`ItemByDivisionModal`(`ProjectRouteForm.tsx:232`, 구현) | §4f #4 `SCP0049_CAPANewModelPopup`(Plant 더블클릭 CAPA 신규모델 팝업)만 **미전환** — 별도 화면(SCP0049, 미착수)에 속해 이 화면 gap-resolve 범위 밖(기존 프로즈 표 "미완/확인필요" 항목3·design/03 A5에 이미 명시된 동일 사실, 신규 발견 아님) | 제외 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목, 2026-09-21 gap-resolve iter-1 신설)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행 + 2026-08-14 공통 수정사항 2건.
> 화면 분석 md 에 없는 전 UI 공통 요구 — `asis_mapping_gate.py --check` 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지) | `packages/foundation/src/utils/gridAction.ts`(`addRowSet` L830 `keepRowVisibleUnderFilter(grid, row)` 직접 호출) — `ProjectRoute.tsx:198` `handleInsert`가 `GridAction.addRow`(=`addRowSet` 1행형) 경유 | 공통 유틸 본문을 직접 열람해 신규행마다 `keepRowVisibleUnderFilter`가 무조건 호출됨을 확인(추정 아님) — 이 화면의 `handleInsert`가 그 경로를 그대로 사용 | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '작업중인 데이터가 있습니다. 조회 하시겠습니까?' confirm (MSG00704) | `packages/shared/src/components/organisms/search-area/SearchArea.tsx:115`(`confirmIfDirtyKey(dirtyKey,'search')`) — `ProjectRouteForm.tsx:98` `onSearch={noDivisionAuth ? undefined : onSearch}`가 이 공용 `SearchArea`로 배선 | `SearchArea`가 조회 실행 전 dirty 레지스트리(`useDirtyRegistry.ts`)를 확인해 confirm을 여는 공통 구조를 직접 확인 — Plant 그리드(`DataGrid` 래퍼, `EditTracker`)는 dirty 판정을 자동 등록하므로 화면 코드에 별도 배선 불필요 | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2) | `packages/shared/src/components/organisms/data-grid/DataGrid.tsx:679-709`(`handleColumnSettingsSave`) | 컬럼 설정(TitleSet) 저장 시 레이아웃(`fetchGridLayout`)은 재조회되나, 코드를 직접 확인한 결과 **조회된 그리드 데이터(rows) 자체를 Reset하거나 재조회를 유도하는 로직은 없다**(toast만 표시) — 이 화면(`project-route`)이 개별 구현한 동작이 아니라 전 화면이 공유하는 `packages/shared/.../DataGrid.tsx`의 공통 동작이므로, 있다면 전 화면 공통 갭이다. Hard Boundary(convert-core §2.2)상 `packages/shared` 수정은 이 화면 gap-resolve 범위 밖 — 공통 컴포넌트 이슈로 별도 보고 대상 | 제외 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준) | `ProjectRoute.tsx:246`(`setToast({type:'success', message: t(MSG.SAVE_RESULT, ...)})`, Plant 저장 성공 시) | 저장 성공은 Toast(구현). "수정 내용 없음"(`handleSave` L266)과 저장 검증 실패(N1~N9)는 CRUD 완료가 아니라 사전 차단이라 Alert 사용이 맞다(AS-IS도 동일 의미 — MSG00133/N1~N9는 원래 MessageBox) | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계) | `packages/foundation/src/utils/gridAction.ts:1083-1123`(`excelDownload`, "[통합테스트 1st No.60-①]" 주석 — 라이브 컬럼 dataMap을 binding별로 채집 후 export 컬럼 재구성 시 주입) | `SubTitle`(`ProjectRoute.tsx:307` `excelFileName='ProjectRoute'`)이 이 공용 `GridAction.excelDownload`를 그대로 사용 — PLANT_SITE_ID/VALID_YN 콤보 컬럼(admin `CELL_COMBO_DATA_TYPE` 배선)의 dataMap이 export 시 승계됨을 공통 유틸 코드로 확인 | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 | `PKG_SCP0006` body(`P_SPLIT_LIST`, `ora.py` 실측) — Project/Model(ItemId) 두 Key-in 필드가 대상 | DB 실측: SITE GET SP(`P_SCP0006_GET_PROJECT_ROUTE_SITE`)가 `P_PROJECT_CODE`/`P_ITEM_ID`를 `P_SPLIT_LIST`(`STRING_SPLIT(P_STR, ',')`, 공백이면 `O_ALL='Y'`로 전건)로 분리해 `IN (SELECT COLUMN_VALUE FROM TABLE(...))`로 필터한다 — FE(`ProjectRouteForm.tsx`)는 원문 그대로 전달하고 SP가 콤마 분리·전건 처리를 전담하는 구조. 화면 코드 수정 불필요 | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns) | `packages/shared/src/components/organisms/data-grid/DataGrid.tsx:1107-1157`(`itemsSourceChanged` 핸들러 — "재조회로 데이터가 다시 실려도 사용자가 건 컬럼 필터를 유지한다") | 공용 `DataGrid`가 `itemsSource` 참조 변경(재조회) 시에도 `filterDefinition`을 보존·재적용하는 로직을 코드로 직접 확인 — Main/BOM/Plant 3개 그리드 전부 이 공용 컴포넌트 경유(`ProjectRouteMainGrid`/`BomGrid`/`PlantGrid`) | 구현 |
