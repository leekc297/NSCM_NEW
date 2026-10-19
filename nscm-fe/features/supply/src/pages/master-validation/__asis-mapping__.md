# SCP0039 Master Validation — AS-IS ↔ TO-BE 매핑

> AS-IS: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0039_ValidationMaster/SCP0039_ValidationMaster.cs`(+Designer)
> 설계: `.atlas/gscm-design/SCP0039/design/00_checklist.md ~ 03_grid-columns.md`
> 성격: read-only 검증 대시보드(Insert/Edit/Delete/Save override 본문 공백 = NO-OP).

## 레이아웃 단순화 결정 (design 01 §1.1)

AS-IS Designer 는 우측을 4그리드 세로 스택(spdProjectRouteInfo/spdBOMInfo/spdTactTimeInfo/spdBODInfo)
으로 그리나, 2025-07-15 리팩터(kh)가 detail 다중그리드를 폐기하고 `spdProjectRouteInfo` 단일 그리드에
항목별 시트를 동적 전환하는 구조로 바꿨다. spdBOMInfo/spdTactTimeInfo/spdBODInfo 는 런타임 내내 빈
그리드(AddSheet/Query 전부 주석). **TO-BE 는 런타임 유효한 2-pane(좌 마스터목록 | 우 detail)로 구현하고
splitContainer3/4 + 빈 3그리드는 재현하지 않는다** — 단순화가 아니라 실측 확인된 dead layout 제거.

## 이벤트/컨트롤 매핑

| AS-IS (.cs) | 라인 | TO-BE |
|---|---|---|
| `FindButton()` → `FindDataAll()` | 482 | `hotkeyConfig.search` = `handleSearch`(활성 행 loop SP 호출, COUNT 채움) |
| `InsertButton/EditButton/DeleteButton/SaveButton`(본문 공백) | 487~501 | `hotkeyConfig.insert/save/delete = () => undefined`(명시적 NO-OP, 키 생략·false 금지). F2 Edit 는 Hotkeys 미배선(`_F2_Unused`) |
| `cboDivision` (`BLUtils.GetDivisionWithoutEE`) | 44/198 | `useTabComboQueries(['Division_SCP'])` + `EXCLUDE_EE_DIVISION` 클라 필터(EE 제외 재현). 단일 필수, ALL 없음 |
| `clbPlanGroup` (SCP0121 Tables[3], `DBUtils.Filter`) | 66/453 | `useTabComboQueries(['PlanGroup_SCP_ALL'])` 전량 → 선택 Division `DIVISION_ID` 클라 필터(cascade, 서버 재조회 없음). 다중 ALL sentinel → payload `p_plan_group_id=''` |
| `ClbDivision_SelectedIndexChanged` → `ClearSheet + RefreshPlanGroupByDivision` | 1268 | `setDivision`(PlanGroup=[] 리셋) + Division/PlanGroup 변경 `useEffect` → `clearResults`(detail 행·activeSheet·전 행 COUNT 초기화, cs:1219/1224, GAP-03) |
| `txtItemId + btnItemId` → `DM0002_ItembyDivisionPopupEx` | 1287/1313 | InputField + 공용 `ItemByDivisionModal`(COM0008, features/master/src/components). preSearchParams: divisionId + team/endCustomer/salesSite='ALL', project='' |
| `InsertBaseRow()` (lookup MASTER_VALIDATION seed) | 798~882 | `useTabLookupQueries([{lookupType:'MASTER_VALIDATION'}])`(admin/lookup, GAP-10). PROCEDURE_NAME≠'-' 12행. 마스터 "Validation Info" 컬럼은 `fetchMasterColumns`(SCM_MST_SHEET_COLUMNS admin fetch, 하드코딩 제거 GAP-02) |
| `SpdMain_CellClick` QUERY 컬럼 → `FindData` | 987 | 마스터 QUERY 셀 click → `handleQuery`(행 코드 dispatch → PKG_SCP0039 멤버 SP → COUNT + detail 바인딩) |
| `SpdMain_CellClick` OPEN 컬럼 → `GoPage` | 993/1132 | OPEN 셀 click → `handleOpen`(PROGRAM_ID: http=외부 URL / 그 외=`navigate('/view/<PROGRAM_ID>')`, 권한 메뉴만) |
| `SpdMain_CellClick` 기타 → `ChangeActiveSheet` | 997/1001 | 행 select → `handleRowSelect`(detail sheet 프리뷰 전환 + CONSTRAINTS01 PlanGroup 잠금) |
| `CONSTRAINTS01` `Const:...^PlanGroup` 파싱 | 1016~1040 | `isPlanGroupLocked` → `planGroupLocked` → Form PlanGroup disabled(R18) |
| `FindDataAll` `Div:xx` 행 skip | 544~554 | `isDivisionSkipped`(전체조회 loop 에서 division 불일치 행 COUNT 공란, R22) |
| `LockColumn(0..max)` siMain/siProjectRoute | 862/652 | 마스터/detail 그리드 `isReadOnly`. 마스터는 QUERY/OPEN 셀만 click 동작(R20/R21) |
| `SetCalendar`/`AddNumColumn`(동적 월컬럼) | 1235~1266 | 미구현 — 호출부 전무(dead code, design 02/03 §2) |
| `IsPopup` 임베드 변형(Plan Control 호출) | 141~163 | 미구현 — standalone MDI 우선(확인필요, design 01 §5-L2) |

## 데이터 구동 dispatch (design 03 §4)

마스터 행 원천 lookup(SEGMENT1=코드) → `VALIDATION_MAP[code]` = { FE 시트(SHT_NM) / 등록 SHEET_NAME(컬럼 fetch) / 배포 SP 멤버 }.
- dispatch 키 = SEGMENT1 코드(대소문자·truncation 불변). sheetNm 대소문자 불일치 3건(CAPA:Line Assign 등)·SP명 truncation 3건(PR_ELEC/OS_CAPACITY/INTRANSIT_INV)은 `VALIDATION_MAP` 의 adminSheetName/sp 실측값으로 정규화(design 03 §6-1·§6-2).
- detail 컬럼 = `SCM_MST_SHEET_COLUMNS` sheetNm 별 admin fetch(`fetchDetailColumns`, 하드코딩 금지 — design 03 §5 #03).

## 커버리지 대사

- 이벤트 4/4, comboCalls 3(Division 1 + Calendar dead 2), filterCalls 1(cascade), gridSignals 영역3 13, toolbarOverride 5(B1 실동작 + B2~B5 NO-OP) — 전건 매핑.
- 미이관(dead/후속): Calendar 동적 월컬럼(dead), IsPopup 임베드(확인필요), Item 팝업 데이터 SP(공용 COM0008 사용 — SCP0039 고유 SP 아님), detail SP 런타임 실행(PROC_M = convert-sp 후속, design 05 참조).

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — asis_mapping_gate --check 가 부재 행을 FAIL 처리한다.
> SCP0039 는 read-only 검증 대시보드(Insert/Edit/Delete/Save = NO-OP, 저장 경로 없음) — CRUD·편집·콤보/키인 조회 축은 구조상 해당 없음.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 노출(keepRowVisibleUnderFilter) | - | read-only 뷰어 — Insert = NO-OP(`() => undefined`, 저장 경로 없음, tsx hotkeyConfig.insert). 신규행 추가 자체가 없어 요구 미해당 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시 'MSG00703' confirm | - | 편집 모드 없음(상시 read-only, isReadOnly). 미저장 수정 상태가 존재하지 않아 재조회 confirm 게이트 미해당 | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회 | - | Column/Measure 설정 버튼 없음(design 01 §7 GridColumnSet/Measure hook 미배선, Measure 0건). 사용자 컬럼 편집 UI 부재로 미해당 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = 하단 중앙 Toast 자동 소멸 | - | CRUD 경로 없음(read-only). 저장/삭제/등록 완료 이벤트가 없어 완료 Toast 미해당 | 해당없음 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터 Code 아닌 Name 출력 | - | 마스터/detail 그리드 콤보 컬럼 0(전 컬럼 read-only text, CELL_CONTROL_OBJECT_TYPE_CODE 콤보 미지정, ora.py 실측). Excel export 시 Code↔Name 매핑 대상 컬럼 없음 | 해당없음 |
| COMMON:UC-06 | Key-in 조회조건 콤마 구분 다중 입력 시 전건 조회 | - | 조회조건에 자유 key-in 다중검색 텍스트 필드 없음 — Division/PlanGroup = 콤보(단일/다중 sentinel), Model/Item = ItemByDivisionModal 팝업 단일 선택. 콤마 다중 key-in 대상 필드 부재 | 해당없음 |
| COMMON:UC-07 | 필터 걸린 상태 재조회 시 조회되고 필터도 그대로 적용(rebindFilterColumns) | - | 재조회 = 명시 SEARCH/QUERY 로 데이터 교체(마스터 lookup·detail SP dispatch). 그리드 컬럼 필터 UI 유지는 공용 DataGrid 소관(화면 고유 필터 배선 없음) — 화면 레벨 요구 미해당 | 해당없음 |
