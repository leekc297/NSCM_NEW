# SCP0129 DemandException — AS-IS ↔ TO-BE 매핑 매트릭스

> AS-IS 정본(design/00_checklist.md §0): `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0129_DemandException/
> {SCP0129_DemandException.cs,.Designer.cs}` — 이 저장소 체크아웃에 파일 자체가 없음(`GSCM/06.UIL/
> GSCM.SCP.Forms.UIL/Master/` 는 `SCP0126_CAPA`까지만 존재, `SCP0127`/`SCP0128`/`SCP0129` 폴더 없음).
> AS-IS MSSQL(`asis.py`)도 이번 세션(convert-plan/design 단계 전부) `08001 Login timeout expired` —
> 접속 불가. 이 매핑은 Roslyn 정적 백본(`screen-analysis.json`)과 DB 실측(`ora.py`)만을 근거로
> 작성했다. 원본 소스 확보 전까지 다수 항목이 "확인 필요"로 남는다 — SCP0128 SafetyStock 이 iter-2
> 에서 원본 확보 후 다수 확인필요를 해소한 선례가 있으므로, 이 화면도 원본 확보 시 동일 절차 필요.
> 설계 근거: `.atlas/gscm-design/SCP0129/design/00_checklist.md` ~ `03_grid-columns.md`,
> `convert-flow/goal.md`, `convert-flow/plan.md`
> 상태 표기: 구현 / 해당없음 / 확인 필요(사유 명시).

## 0. 원본 소스 부재 — 전면 영향 고지

이번 회차(iter-1)는 SCP0128 SafetyStock 과 달리 AS-IS 원본 `.cs`/`.Designer.cs` 를 이 세션에서
확보하지 못했다. 아래 매핑 다수는 design 문서(00~03)가 이미 "확인 필요"로 표기한 항목을
그대로 승계한 것이며, 이 activity(convert-react)에서 새로 해소한 것이 아니다. 원본 확보 후
재실행(iter-2 이상) 시 SCP0128 선례(§0 iter-2 갱신)처럼 다수 항목이 확정될 가능성이 높다.

## 1. 진입점 (entryPoints 5 toolbarOverride + 5 event, `00_checklist.md §4`)

| # | AS-IS name (line) | kind | TO-BE 구현 | 상태 |
|--:|---|---|---|:--:|
| 1 | `FindButton`(356) → `FindData_Main` | toolbarOverride | `DemandException.tsx onSearch` → `setFilters()` + `fetchStaticColumns()` | 구현 |
| 2 | `SaveButton`(388) → `SaveData` | toolbarOverride | `onSave` — `dirtyRows` 수집 → 안전재고 가드(`findSafetyStockBlockedRows`, 클라 로컬 7컬럼 완전일치 비교) → 행별검증(`validateDemandExceptionRow`) → `saveWithValidation(…, mutate)` | 구현(안전재고 가드는 클라 로컬, 서버 대사 후속) |
| 3 | `DeleteButton`(366) | toolbarOverride | `onDelete` — 선택행 없으면 return, `GridAction.removeRow` | 구현 |
| 4 | `EditButton`(375) → `SwitchLock`(추정) | toolbarOverride | **미이식(제외)** — `asis_to_tobe.md §11` 전 화면 공통 결정, 이 결정은 EditButton override 본문 확인 여부와 무관하게 전 화면 적용. hotkeyConfig 에 edit 키 자체를 두지 않는다 | 구현(표준 제외) |
| 5 | `InsertButton`(361) → `Insert`+기본값+범위잠금 | toolbarOverride | `onInsert` — `GridAction.addRow(grid, demandExceptionInsertDefaults(divisionId))`. **가드 미확인** — design 01 §5-1(ERROR, 원본 소스 부재)로 InsertButton 사전조건 가드 원문을 확인하지 못함. SCP0122/SCP0128 선례를 따라 보수적으로 "상시 허용"으로 구현했으나, SCP0128 은 원본 확보 후(iter-2) 이 판단이 실제로 맞았음을 확인한 반면 SCP0129 는 아직 미검증 | 구현(가드 확인 필요) |
| — | UPLOAD/MANUAL (표준 등록 버튼 7종 중 2종) | toolbarOverride | `hotkeyConfig`에 `manual: false, upload: false` 명시(키 생략이 아니라 명시적 `false`). `SCM_ADM_MNU_BTN_MPG_M`에 이 2종 미등록(2.7 게이트 재확인, `ora.py` 조회 5건 = SEARCH/INSERT/DELETE/SAVE/EXCEL) 상태와 일치시킨 것으로, 화면이 임의로 숨긴 것이 아니라 DB 등록 상태를 그대로 반영한 것이다. 다만 이 화면이 엑셀 업로드·수기입력 기능을 실제로 갖는지는 AS-IS 원본(`.cs`) 미확보로 확정할 수 없다(SCP0128 선례도 동일 패턴, 동일 사유) — 원본 확보 시 재검증 필요 | 확인 필요(등록 상태와 일치하나 기능 존재 여부 미확정) |
| 6 | `ClbDivision_SelectedIndexChanged`(850) | event | `DemandExceptionForm` Division 변경 → `setSearchParams({ divisionId })` → store 가 planGroupId 를 'ALL' 로 초기화 | 구현 |
| 7 | `SpdMain_CellDoubleClick`(931) | event | `DemandExceptionGrid handleDblClick` — ITEM_ID 셀만 반응, 헤더 제외, 신규행만 팝업 오픈 | 구현 |
| 8 | `SpdMain_ClipboardPasted`(1065) | event | **미구현** — gridSignals#15(line1079, `SetValue(iRow, OPMZ_PLAN_GR_ID, codeVal)`) 의 `codeVal` 산출식이 원본 소스 부재로 미상(design 03 §6 확인필요#8). SafetyStock(SCP0128) 은 이 신호를 "NAME 붙여넣기 → CODE 역조회" 로 원본 확인 후 구현했으나, SCP0129 는 산출식이 동일한지 확인하지 못해 임의로 같은 로직을 이식하지 않았다(anti-simplification — 다른 화면 패턴을 근거 없이 복사 금지) | 확인 필요(미구현) |
| 9 | `SpdMain_TopChange`(865) → `SmartColMerge` | event | **미구현** — 병합 대상 컬럼 미상(design 03 §3 규칙#12, §6 확인필요#5) — `guides/grid-behavior-parity.md` 판별 절차상 grep/원문 둘 다 대상 컬럼 리터럴 없음 | 확인 필요 |
| 10 | `btnItemId_Click`(1044) | event | `DemandExceptionForm` — InputField 팝업 버튼 → `MaterialByDivisionModal` open, 결과 `setSearchParams({ itemId })` | 구현 |
| 11 | `spdMain_CellClick`(877) | event | 별도 핸들러 미구현 — 잠금/모드 가드(buttonGuards#2·#3)의 실질은 §11 로 Edit 모드 축이 사라져 `isMainCellEditable`(beginningEdit)로 이미 흡수됨(신규행만 편집 가능, SCP0128 선례와 동일 판단) | 구현(흡수) |

## 2. 버튼 가드 (buttonGuards 5, `00_checklist.md §4d`)

| # | method / condition (line) | TO-BE 구현 | 상태 |
|--:|---|---|:--:|
| 1 | Delete `fps==null`(368) | `onDelete` — `gridRef.current` 없거나 선택행(`selection.row<0`) 없으면 return | 구현 |
| 2 | `spdMain_CellClick` `!IsLock(...)`(881) | Edit 미이식(§11)으로 "잠금 해제 상태" 축 자체가 사라짐 — `isMainCellEditable` 이 신규행 기준으로 대체 판정 | 구현(표준 대체) |
| 3 | `spdMain_CellClick` `action!=FlagI && !_isEditMode`(898) | `_isEditMode` 축 제외(§11) — `action!=FlagI`(신규행 아님) 조건만 실질 반영, `isMainCellEditable` 의 `crudType(row)!=='I'` 분기가 이를 재현 | 구현(부분 대체, §11 반영) |
| 4 | `SpdMain_CellDoubleClick` `!e.ColumnHeader`(933) | `DemandExceptionGrid handleDblClick` — `ht.cellType!==CellType.Cell \|\| ht.col<0` 이면 return | 구현 |
| 5 | `SpdMain_CellDoubleClick` `IsLock(...) \|\| (action!=FlagI)&&!_isEditMode`(936) | §11 로 `_isEditMode` 축 상시 거짓 취급 → 실질 조건 "신규행이 아니면 차단" 으로 단순화, `handleDblClick` 의 `row.CRUD_TYPE!=='I'&&row.CRUD_TYPE!=='C'` 가드가 재현 | 구현(§11 반영 단순화) |

## 3. 검증 (validations 11건, `00_checklist.md §3a`)

| msgId (line) | AS-IS 의미 | TO-BE 구현 | 상태 |
|---|---|---|:--:|
| MSG00001(628, 조회조건) | 8필드(division/plan_group/site/item/stage/from/to/valid) 전건 공백 체크 | **미구현** — 조회조건 필드가 Site/PlanGroup/Stage/ValidYn 4종 미노출(비활성)이므로 이 검증을 조회 버튼에 걸면 상시 실패한다. 데이터소스 확정 후 필드 활성화와 함께 구현 예정 | 확인 필요(SP/comboId 후속) |
| MSG00260(655, SaveData) | `dtPreSafeStock.Rows.Count>0 && action!=Delete` 저장 전 안전재고 존재 가드 | `findSafetyStockBlockedRows` — 검사 컬럼 원식(`filterCalls#5 sb.ToString()`)은 미상이나, 신규행이 기존 조회행과 7컬럼(DIVISION_ID/OPMZ_PLAN_GR_ID/SCM_SITE_ID/ITEM_ID/STAGE/FROM_YYYYMMDD/TO_YYYYMMDD) 완전일치하면 클라 로컬 비교로 차단(SP 배포 후 서버측 재검증 필요) | 구현(클라 로컬, 서버 대사 후속) |
| MSG00046(676) | "No Work Date" | **미구현** — 조건 문자열 Roslyn 미검출, 이 화면 컬럼 사양(design 03 §1)에 "Work Date" 성격 필드 부재 확인 안 됨 | 확인 필요 |
| MSG00219(683, 조회조건) | From > To 날짜 역전 차단 | **미구현**(조회조건 레벨) — Period 필드 자체는 노출되나 조회 시점 역전 검증은 아직 배선하지 않음(그리드 셀 레벨은 아래 구현) | 확인 필요(조회조건 레벨) |
| MSG00458(710, 소속 확인필요) | Item 미존재 | `validateDemandExceptionRow` — 형식(공백) 검사만, 실제 마스터 존재 검증은 SP 응답 필요(PKG_SCP0129 미배포로 서버측 대사 불가) | 구현(부분 — 서버 검증 후속) |
| MSG00004(800)/(809 페어)/(817 GMessageBoxForException) | SaveData 결과 분기(성공/실패/예외) | `useProcMutation` 기본 onSuccess(성공 토스트+invalidate)/에러 처리 — 화면 별도 배선 불필요(표준 경로) | 구현(공용 경로) |
| MSG00049(987)/(1023, 그리드 더블클릭) | `!isValid` — 무엇의 유효성인지 원문 미확보 | **미구현** — 조건 세부 미상 | 확인 필요 |
| MSG00219(998, 그리드 더블클릭) | From > To 역전 | `DemandExceptionGrid cellEditEndedHandler` — FROM_YYYYMMDD 편집 종료 시 역전 검증 + TO_YYYYMMDD 리셋(gridSignals#14 재현) | 구현 |

## 4. 그리드 시그널 (gridSignals 15건, `03_grid-columns.md §3`)

| # | AS-IS (line) | TO-BE 구현 | 상태 |
|--:|---|---|:--:|
| 1 | SetSheetHeaderColumnSCP(321) | `staticColumns` 동적 구성이 대체 | 해당없음(메타 구동으로 대체) |
| 2 | Delete(371) | `onDelete` | 구현 |
| 3 | SwitchLock(380, EditButton 소속 추정) | Edit 미이식(§11) — 해당 없음 | 해당없음(§11) |
| 4 | LockColumn DIVISION_ID(381) | `demandExceptionEditLock.ts LOCKED_ALWAYS` | 구현 |
| 5 | LockColumn CREATED_BY~PRE_KEY_VALUES(383) | `LOCKED_ALWAYS` | 구현 |
| 6 | Query(467) | `useTabProcQuery` → `data.o_rc1` → `rows` | 구현 |
| 7 | LockColumn 전체(468) | 기존행 상시 read-only(`isMainCellEditable` `crudType!=='I'` → false) | 구현(§11 반영) |
| 8 | Insert(513) | `onInsert` → `GridAction.addRow` | 구현 |
| 9 | SetValue defaultData(523) | `demandExceptionInsertDefaults(divisionId)` — 원문 미확인, Division 만 상속·나머지 빈 값(SCP0122/SCP0128 선례) | 구현(확인 필요 — defaultData 원문) |
| 10 | LockRange DIVISION_ID(525) | `LOCKED_ALWAYS`(신규행에도 적용) | 구현 |
| 11 | LockRange CREATED_BY~LAST_UPDATE_DATE(526) | `LOCKED_ALWAYS` | 구현 |
| 12 | SmartColMerge(868, TopChange) | **미구현** — 병합 대상 컬럼 미상 | 확인 필요 |
| 13 | SetText ITEM_ID(962) | `DemandExceptionGrid setSelectedValue` — `editTrackerRef.storeChange` + `row.ITEM_ID = items` | 구현 |
| 14 | SetValue TO_YYYYMMDD=""(999) | `cellEditEndedHandler` — From>To 역전 시 리셋 | 구현 |
| 15 | SetValue OPMZ_PLAN_GR_ID=codeVal(1079, ClipboardPasted) | **미구현** — `codeVal` 산출식 미상(§1 진입점#8 참조) | 확인 필요 |

## 5. 컨트롤/레이아웃 (controls 29건, `00_checklist.md §1`)

| AS-IS 영역 | TO-BE 구현 | 상태 |
|---|---|:--:|
| Layout 1(`usrLayoutControl2`,`layoutControlGroup2`) | `SearchArea`(DemandExceptionForm) + `MainTitle.openSearchArea` 토글 | 구현 |
| 조회조건 8개 논리조건(17 컨트롤+라벨) | Division/Item(+팝업)/Period 3건 데이터 배선 완료, Site/PlanGroup/Stage/ValidYn 4건은 UI 골격만 노출(comboId 확인 필요) | 구현(4건 데이터소스 후속) |
| 그리드 2(`spdMain`,`spdMain_Sheet1`) | 단일 `DataGrid`(DemandExceptionGrid) | 구현 |
| `usrButton1`(x0/y0/tab0) | **렌더 제외** — SCP0122/SCP0128 선례와 동일 패턴(좌표 0,0, 어떤 배열에도 참조 없음)의 dead-control 추정이나, 이 화면은 원본 소스 미확보로 실측 확정이 아니라 추정 유지(design 01 §5-4 확인 필요) | 구현(렌더 제외, 판정은 확인 필요) |
| static 1(`components`) | 비시각 — 매핑 대상 아님 | 해당없음 |

## 6. 콤보 (comboCalls 1 + 확인필요 4, `00_checklist.md §4b`)

| # | AS-IS CODE | 소비 위치 | TO-BE comboId | 상태 |
|--:|---|---|---|:--:|
| 1 | `BLUtils.GetDivision(false,"")`(45) | cboDivision | `COMBO.DIVISION='Division_SCP'`(EE 포함, WithoutEE 아님 — SCP0122 선례 재사용 확정, design 02 §2-1) | 구현 |
| — | `dtScmSiteAll` 최초 공급원 미상 | clbSite | **확인 필요** — comboId 미확정(design 02 §2-2). UI 골격만 노출(비활성) | 확인 필요(SP/원본 후속) |
| — | `dtPlanGroupAll` 최초 공급원 미상 | clbPlanGroup | **확인 필요** — comboId 미확정(design 02 §2-3). `PlanGroup_SCP_ALL`(TO-BE 기존 등록) 재사용 가능성 있으나 다중선택 UI 계약 차이로 단정 금지 | 확인 필요(SP/원본 후속) |
| — | `dtStageAll` 최초 공급원 미상 | cboStage | **확인 필요** — comboId 미확정(design 02 §2-4). TO-BE `SQL_ID LIKE '%STAGE%'` 0건(신규 등록 필요 가능성) | 확인 필요(SP/원본 후속) |
| — | 전혀 미검출 | cboValid(조회조건) | **확인 필요** — comboCalls/filterCalls 어디에도 없음(design 02 §2-5). `YesOrNo`(그리드 셀 STOCK_EXCEPTION 콤보와 동일 SQL_ID)가 조회조건에도 동일 의미인지는 검증 없이 재사용 금지(convert-core §2.6) | 확인 필요(SP/원본 후속) |
| — | 그리드 셀 STOCK_EXCEPTION | 그리드 셀 콤보 | `YesOrNo`(등록됨, design 03 §1 #9 — 유일하게 실제 등록·동작) | 구현 |

## 7. 저장 계약 (spCalls 3건, `00_checklist.md §4`, `03_grid-columns.md §4.3`)

| AS-IS SP (line) | TO-BE |
|---|---|
| `SCP.SCP0128_GET_SEARCH_INFO`(206, GetSearchInfo) | **미배선(SP 후속)** — SaveButton→SaveData→GetSearchInfo 체인에서만 잡힘(entryPoints#2). Form_Load 시점 별도 호출 여부·반환 Tables 구조 미확인(design 02 §2-2/2-3) |
| `SCP.SCP0129_GET_DEMAND_EXCEPTION`(440, FindData_Main) | `useTabProcQuery` — `filters={divisionId,planGroupId,scmSiteId,itemId,stage,validYn,periodFrom,periodTo}`(planGroupId/scmSiteId/stage/validYn 는 UI 골격만 노출 상태라 상시 'ALL'/''/'' 고정, comboId 확정 후 실배선) |
| `SCP.SCP0129_SAVE_DEMAND_EXCEPTION`(759, SaveData, 19파라미터) | `useProcMutation` — `saveWithValidation(dirtyRows, staticColumns, mutate)`. PRE_* 7종(surrogate PK 없는 복합키) 조립은 공용 mutation 계층이 CRUD_TYPE 기반으로 처리(화면 로컬 조립 없음, SCP0002/SCP0127 표준과 동일) |

Delete 는 신규행 로컬 제거뿐(SP 호출 없음, `entryPoints#3 sps:[]`) — 저장(SaveButton)이 트리거되어야 실제 DB 반영(AS-IS 공통 CRUD 패턴 추정).

## 8. 미완 / 후속

| 축 | 상태 | 사유 |
|---|---|---|
| AS-IS 원본 `.cs`/`.Designer.cs` | ERROR(미확보) | 이 저장소에 `SCP0127`/`SCP0128`/`SCP0129` 폴더 자체가 없음 — 전 항목의 근본 원인 |
| AS-IS MSSQL(`asis.py`) 접속 | ERROR | `08001 Login timeout expired`(이 회차에서 재시도하지 않음, design 단계에서 이미 1회 재시도 후 실패 확정) |
| `PKG_SCP0129` GET/SAVE 런타임 | 미완 | 배포 후 `convert-sp` 후속 |
| Site/PlanGroup/Stage/ValidYn 4개 조회조건 — comboId/데이터 배선 | 미완(SP·원본 후속) | 원본 확보 또는 `PKG_SCP0129`/`SCP0128_GET_SEARCH_INFO` 배포 전까지 실데이터 배선 불가 |
| SmartColMerge 병합 대상 컬럼 | 확인 필요(미구현) | 병합 기준 컬럼이 Roslyn 백본·grep 어디에도 없음 |
| ClipboardPasted codeVal 파생(line1079) | 확인 필요(미구현) | 산출식 미상 — SCP0128 선례(NAME→CODE)를 검증 없이 이식하지 않음 |
| InsertButton 사전조건 가드 | 확인 필요 | 원본 미확보로 "상시 허용" 판단이 맞는지 미검증(SCP0128 은 원본 확보로 검증됨) |
| usrButton1 정체 | 확인 필요(렌더 제외 유지) | dead-control 추정이나 실측 확정 아님 |
| 안전재고 저장 가드(MSG00260) 검사 컬럼 | 구현(클라 로컬, 서버 대사 후속) | filterCalls#5 동적 조립식 원문은 미확보이나, 7컬럼(design 03 §1 필수 라벨) 완전일치 비교로 우선 구현. PKG_SCP0129 배포 후 서버측 재검증 필요 |
| 조회조건 레벨 8필드 필수검증(MSG00001)/기간역전(MSG00219) | 확인 필요(미구현) | Site/PlanGroup/Stage/ValidYn 필드 비활성 상태에서 필수검증을 걸면 조회 자체가 상시 실패 — 데이터소스 확정 후 함께 구현 |
| 브라우저 시각·조작감 | 미완(사용자 확인 축) | 정적 검증으로 대체 불가 |

## UI 공통(통합테스트) 체크 축 (전 화면 상시 6+1항목)

| ID | 요지 | 구현 위치 | 상태 |
|---|---|---|:--:|
| COMMON:UC-01 | 필터 상태 Insert 시 필터 유지 | `onInsert` → `GridAction.addRow` | 구현 |
| COMMON:UC-02 | 수정 중 재조회 confirm | 공용 `SearchArea.onSearch`/`SubTitle` 단축키 dirty 시 confirm 경유 | 구현(공용 경로) |
| COMMON:UC-03 | Column 설정 적용 시 Reset 후 재조회 | 해당없음 — Column Settings UI 미사용, Measure 0행(pivot 없음) | 해당없음 |
| COMMON:UC-04 | CRUD 완료 Toast(실패/차단은 Alert) | 저장 완료=공용 mutation 성공 Toast, 검증 실패=`setAlert` | 구현 |
| COMMON:UC-05 | Excel 콤보 Code→Name 출력 | `SubTitle excelFileName='DemandException'` 공용 경로 | 구현 |
| COMMON:UC-06 | Key-in 콤마 다중조회 | 해당없음 — Item ID 는 팝업 단일선택(콤마 다중검색 없음) | 해당없음 |
| COMMON:UC-07 | 필터 상태 재조회 시 필터 유지 | 공용 `DataGrid` rebindFilterColumns 경유 | 구현 |
