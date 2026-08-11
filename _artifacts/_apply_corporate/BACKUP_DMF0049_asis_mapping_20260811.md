# __asis-mapping__.md — EID 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `DMF0049_EtcSalesReports_주요이벤트_상세분석.md`, `DMF0049_EtcSalesReports_제약매트릭스_상세.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (EID 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| E00 | §0 정본 vs 변형(GSCM.DM.Plan.UIL 평면본) 차이 — git diff --no-index 실측 |  | 정본 선택 근거 — `GSCM.DM.Forms.UIL/Plan/DMF0049_Sales_ETC_Reports/`(1,727행) 폴더단위 유일본. 평면본 `GSCM.DM.Plan.UIL/DMF0049_Sales_ETC_Reports.cs` 는 구본. TO-BE 구현 산출물이 아니라 **분석 메타** 항목 | 제외 |
| E01 | §1 초기화 체인 (Form_Load, L146~154) | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:126~133 (useEffect 초기화 — fetchStaticColumns/fetchStaticMeasures) |  | 구현 |
| E01-1 | §1.1 InitControls (L191~226) — 콤보 로딩 순서·기본값 | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx:37~39 (MDF_TYPE·CALENDAR_YYYY) + features/demand/src/pages/etc-sales-reports/useEtcSalesReportsStore.ts:100~116 (initSearch 기본값) |  | 구현 |
| E01-2 | §1.2 CreateSpread (L240~247) / InitSpread (L249~268) — 시트 구성 | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx:76~120 (정적 컬럼 메타 + 셀 콤보 dataMap) + features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.merge.ts:15 (**1단 헤더** MergeManager — 2026-08-11 전환) |  | 구현 |
| E01-3 | §1.3 DefineProperty (L227~238) |  | AS-IS FarPoint `DefineProperty` = Spread 내부 속성 선언. TO-BE 는 Wijmo + SHEET_COLUMNS 메타가 동일 역할을 하며 대응 코드 단위가 없다(hook #113 메타 주도) | 해당없음 |
| E02 | §2 FindData — 조회 (FindButton L274~277 → FindData L522~627) | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:142~155 (handleSearch) + features/demand/src/pages/etc-sales-reports/useEtcSalesReportsStore.ts:121~165 (setFilter — thisMonth/resultMonth 스냅샷) + features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:83~90 (useTabProcQuery MAIN) |  | 구현 |
| E03 | §3 편집/저장 | features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.editLock.ts:30~71 (evalEtcReportCell) + features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:203~ (handleSave) |  | 구현 |
| E03-1 | §3.1 EditButton (L338~463) — 편집 게이트·잠금 규칙 | features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.editLock.ts:22~23 (G0 그룹 게이트) · :30~71 (동적 셀 매트릭스) · :73~101 (정적 컬럼 = UI Category Setup `INPUT_TP_CD` 단일 원천 `staticEditableByMeta` — 2026-08-11 전환. AS-IS 잠금 파리티는 메타 값 'S' 로 보존) |  | 구현 |
| E03-2 | §3.2 SaveButton (L465~468) → SaveData (L629~923) | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:203~ (handleSave) + features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.save.ts:111~175 (buildEtcReportSaveRows — 세트×채택월×세트내 행) · :176~ (buildBulkPayload '^' bulk) |  | 구현 |
| E03-3 | §3.3 InsertButton (L279~282) → InsertRow (L925~1119) | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:168~189 (handleInsert — GET_MEASURE CODE 순서 강제 세팅) + features/demand/src/pages/etc-sales-reports/etc-sales-reports.constants.ts:92~105 (INSERT_ROW_DEFAULTS) |  | 구현 |
| E03-4 | §3.4 DeleteButton (L284~336) | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:191~201 (handleDelete) |  | 구현 |
| E04 | §4 그리드 이벤트 | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx:259~343 (formatItem / beginningEdit / cellEditEnded / dblclick 핸들러 등록) |  | 구현 |
| E04-1 | §4.1 spdMain_Changed (Data Model Changed, L1252~1426) — `CellsUpdated` 타입만 처리 | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx:302~330 (cellEditEnded — 수치셀 빈값 '0' 강제 + cascade clear) + features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.gridCombos.ts:56~ (resolveDeptIdRows 2분기 · cascadeClearColumns 매트릭스) ⭐ 2026-08-10 이관 — DEPT_ID 부모키 필터가 소실돼 있던 것을 AS-IS L1268/L1294 1:1 복원 |  | 구현 |
| E04-2 | §4.2 spdMain_CellDoubleClick (L1428~1478) | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx:335~343 (dblclick → onProjectCellDblClick) + features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:375 (PROJECT 모달 오픈) |  | 구현 |
| E04-3 | §4.3 spdMain_CellClick (L1578~1605) |  | AS-IS `spdMain_CellClick`(L1578~1605)은 CUST_REPORT 셀 콤보 재바인딩 전용이고, 그 콤보(`DMF0005_REPORT_GROUP2`)는 **무파라미터**라 화면 진입 시 1회 프리페치와 등가다(콤보 호출지점 대사 PASS 사유와 동일). 별도 클릭 핸들러 불요 | 제외 |
| E05 | §5 버튼 전수 | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:289~330 (hotkeyConfig — 공통버튼 10종 배선) |  | 구현 |
| E05-1 | §5.1 BaseForm override (공통 버튼) | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:289~330 (hotkeyConfig) — SEARCH/INSERT/DELETE/SAVE/EXCEL/FILTER/SORT 는 공통버튼 계약으로 처리 (COLUMN_SETUP 은 2026-08-11 **숨김** — 아래 H-3) |  | 구현 |
| E05-2 | §5.2 커스텀 버튼·콤보 이벤트 | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:302~311 (COLUMN_SETUP — **숨김 주석 블록으로 보존**) · :311~322 (MEASURE_SELECT) · :344 (SP_VER → VersionModal) + features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx:114 (btnSPVer '...') |  | 구현 |
| E05-3 | §5.3 화면 내 검증 메시지 전수 (활성 기준) | features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.validate.ts:9~16 (MSG00283 조회 / MSG00688 저장·팝업 / MSG00096 편집권한) + features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.save.ts:126~129 (MSG00429 Department 필수) |  | 구현 |
| E06 | §6 호출 팝업 상세 | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsModals.tsx:30~ (모달 4종 라우팅) |  | 구현 |
| E06-1 | §6.1 DMF0044_United_VersionPopup (버전 선택 — btnSPVer) | features/demand/src/components/versionModal/VersionModal.tsx (공용 — DMF0044 와 1본 공유) ← features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsModals.tsx:171 |  | 구현 |
| E06-2 | §6.2 DM0002_TitleSetForm_Popup (Measure Setting — btnMeasure) | features/demand/src/pages/etc-sales-reports/components/modals/MeasureSelectModal.tsx ← features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsModals.tsx:152 |  | 구현 |
| E06-3 | §6.3 SCM0002_ProjectbyDivisionPopupEx (Project 선택 — 그리드 PROJECT_CODE 더블클릭) | 공용 `ProjectByDivisionModal` ← features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsModals.tsx:83 |  | 구현 |
| L121 | 컬럼 상수 정의 (`DefColumns.FCST_TYPE`) | features/demand/src/pages/etc-sales-reports/etc-sales-reports.types.ts (EtcSalesReportRow) + SHEET_COLUMNS 메타(FCST_TYPE, DIVISION_ID='81*' 한정) |  | 구현 |
| L344 | MSG00096 / Edit, DM Planner & Div≠82 | features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.editLock.ts:22~23 (isEditBlockedGroup) + features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.validate.ts:15~16 (MSG00096) |  | 구현 |
| L362 | `//LockColumn(0, MEASURE, true)` |  | AS-IS 원문에서 **주석 처리된 코드**(`//LockColumn(0, MEASURE, true)`) — 실행되지 않는다. 이식 대상 아님 | 제외 |
| L528 | MSG00283 / Find, 버전 미선택 | features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.validate.ts:9~10 (validateFind → MSG00283) |  | 구현 |
| L633 | MSG00281 / Save, 버전 미선택 | features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.validate.ts:12~13 (validateVersionForAction) — MSG ID 는 AS-IS 00281 → TO-BE **MSG00688** 로 재매핑(hook #114 — 00281 원문 부재로 신설) |  | 구현 |
| L638 | SaveData / `IsLock == false` (Edit 상태) 일 때만 저장 진행 | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:203~ (handleSave 진입 게이트) — TO-BE 는 AS-IS `IsLock` 대신 편집 판정 엔진(evalEtcReportCell)이 셀 단위로 잠그므로 '변경분 0건'이 동일 역할 |  | 구현 |
| L734 | `if (iMeasureCnt == 3 /*gsDivision_id != "40"*/)` — 조건 치환 이력 | features/demand/src/pages/etc-sales-reports/etc-sales-reports.constants.ts (measureCntOf) + features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.save.ts:131 (cnt = measureCntOf(divisionId)) — AS-IS 주석의 조건 치환 이력까지 반영(40=2 / 비40=3) |  | 구현 |
| L748 | MSG00002 {"Department"} / Save, DEPARTMENT_ID 공백 | features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.save.ts:126~129 (Department 공백 → MSG00429) — AS-IS MSG00002 {0} 용법을 TO-BE 필수입력 메시지로 재매핑 |  | 구현 |
| L874 | 저장 SP 파라미터 `p_fcst_type` 전달 | features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.save.ts (EtcReportSaveRow.fcstType) — ⚠ SP 파라미터 순서는 분석서가 아니라 `ALL_ARGUMENTS` POSITION 실측을 따랐다(PROC_M 37행 = 36 IN + result) |  | 구현 |
| L899 | (SP 반환 문자열) / Save 실패 | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:203~ (handleSave — SP 반환 message 를 그대로 alert) |  | 구현 |
| L928 | InsertRow / 동일 게이트 | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:168~172 (handleInsert 진입 게이트 — 편집 게이트 공유) |  | 구현 |
## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:E02:SEARCH | [SEARCH] §2 FindData — 조회 (FindButton L274~277 → FindData L522~627) | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:142~155 · :83~90 (useTabProcQuery MAIN / SHEETS.MAIN SEARCH) |  | 구현 |
| CRUD:E03:SAVE | [SAVE] §3 편집/저장 | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:203~ + features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.api.ts:81 (callSaveEtcReport → SHEETS.MAIN 'SAVE') + save.ts:111~ (36키 '^' bulk) |  | 구현 |
| MODAL:DMF0044_Sales_VersionPopUp | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 |  | AS-IS dead 팝업 — 2026-07-22 사용자 확정으로 이관 제외(활성 경로는 `DMF0044_United_VersionPopup` = 공용 VersionModal, E06-1) | 제외 |
| MODAL:EtcSalesReportsModals | FE 실존 모달 (components/EtcSalesReportsModals.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsModals.tsx (모달 4종 라우팅 — PROJECT/COLUMN/MEASURE/VERSION) |  | 구현 |
| MODAL:MeasureSelectModal | FE 실존 모달 (components/modals/MeasureSelectModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | features/demand/src/pages/etc-sales-reports/components/modals/MeasureSelectModal.tsx ← AS-IS §6.2 DM0002_TitleSetForm_Popup (Measure Setting). CRUD = 표시/선택 전용(저장은 개인화 titleSet 경유) |  | 구현 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 |  | AS-IS `ShowDialog` 는 팝업 호출 **공통 헬퍼**(WinForms API)이지 개별 팝업이 아니다 — TO-BE 대응 단위 없음(각 팝업은 E06-1~3 로 개별 대사) | 해당없음 |
## 0. 원본 결함 교정 이력 (2026-07-22 채택)
| # | 결함 | 처리 |
|---|---|---|
| ① | InsertRow L997 — ETC_DESCR 잠금해제 가드가 CURRENCY 인덱스 검사(오기) | 컬럼 자기판정으로 자연 교정 (메타 42행에 ETC_DESCR 부재 — 실효 0) |
| ② | FindData L577 — REPORT_BP_M 기준월 '20180101' 8자리(잠금축 6자리와 불일치 → BP 회색 미적용) | `BP_BASE_YM='201801'` 단일 상수로 잠금·회색 통일 (BP 조회 시 AS-IS 에 없던 회색 표시 — 시각 차이만) |
| — | GET SP L201/204 `NVL(x,'')<>''` 상시 false(행 저장값 우선 로직 사문화) | 서버측 잠재결함 — BE 무수정, 인지만 |
| — | 분석서 이벤트 L150 SAVE 꼬리 5개 순서 | **오기 확정(기각)** — ALL_ARGUMENTS DB POSITION 이 정본 (…31 CELL_MODEL_INFO/32 CELL_MODEL/33 MEASURE/34 YYYYMMDD/35 QTY/36 CREATED_BY) |

## 1. 조회조건 (주요이벤트 L17 전수)
| AS-IS | TO-BE | 상태 |
|---|---|---|
| clbDivision (MyDivision) | DivisionField — 변경 시 Version 초기화+Grid reset | ✅ |
| clbType (MDF_TYPE) | CustomDropdown 'MDF_TYPE' | ✅ |
| clbPlanResult (정적, 기본 Plan L207) | 정적 콤보 Plan/Result (CMBO 불요) | ✅ |
| usrYear (CALENDAR_YYYY, 기본 올해 — [E20250121] SP화) | CustomDropdown 'CALENDAR_YYYY' | ✅ |
| txtSPVersion + btnSPVer | readonly + '...' → UnitedVersionModal 주입 (조회 MSG00283/저장 MSG00688) | ✅ |
| btnMeasure | TitleSet 'M' 모달 (customButtons) | ✅ |
| Company (캐시만) / clbDivision 이중구독 | 미노출 파리티 / **승계 금지** — 단일 핸들러 | ✅ |

## 2. 그리드 / 편집 매트릭스 (제약매트릭스 §2~§6 전수)
- 정적 42 = admin 'MDF Reports' 메타 100%(hook #113) / 동적 M_yyyymm **1단 평면 헤더**(라벨 `2025-01`, 2026-08-11 전환 — 아래 H-1) ✅
- **세트행**: 40=3(SalesAmt_LOC→KRW→RTF_SYS_RP)/81(startsWith)=2/82=1 — Insert/Delete 블록 단위(INSERT_GROUP_ID), 저장 = 세트×채택월×행 emit ✅
- **G0**: DM Planner && Div≠82 → MSG00096 (Insert/Save 진입 + 셀 전면 잠금 — L341~345) ✅
- **시점축**: baseYm = BP '201801' / SP_W 당월. Plan: 과거년도 전체 잠금[C20201223]·과거 구간 잠금·창 내 = 40 무관 개방·비40 = MEASURE===sEditMeasure(DM_LOOKUP_DIV×DM_SR_ETC_CURRENCY — 82='SalesAmt_KRW'뿐·81 빈값=전잠금). Result: 미래 잠금·과거 = 동일 개방·BP=전체 잠금(보수 확정) ✅
- ⚠ **EDIT_FLAG 동적 셀 미사용** (EditButton 루프 값 비교 없음 — DMF0044와 정반대. §2.3 비대칭 실측) ✅
- 정적 컬럼 편집 = **UI Category Setup `INPUT_TP_CD` 단일 원천**(2026-08-11 전환 — 아래 H-5). AS-IS 신규행 division 분기 잠금(공통 7 + 81: FCST_TYPE·CELL_MODEL_INFO / 82: ITEM_ID·CELL_MODEL_INFO / 40: SCM_SITE_ID)·기존행 전량 잠금은 **메타 값('S')으로 보존**한다 ✅
- cascade 3종: C1 40 DEPARTMENT_ID→DEPT_ID(CMBO DMF0049_DEPARTMENT_TEAM — SEGMENT3 cascade)+하위 clear / C2 DEPT_ID→END_CUST_REPORT·ReportGroup3·DMF0005_REPORT_GROUP2(GRID_EDIT_COMBO) / C3 END_CUSTOMER→SiteByEndCustomer ✅
- 수량 빈값→'0'(L1416~1423) / PROJECT_CODE dblclick→ProjectByDivisionModal(**etc:'Y' — 공용 모달 1줄 확장** [PJ20200138]) / ITEM 팝업 dead(콤보로 변경) 승계 금지 ✅

## 3. 저장 (SaveData L633~915 — 단일 SP 36 IN)
- FE 35키 '^' bulk (sesUserId 36번 BE주입) — **키 바인딩 = PROC_M SORT_ORD = DB POSITION** ✅
- 채택 3분기(L739~744): Red 변경월 / 40+M+cnt≥2=전월 / 82+M=전월. I 세트=값 존재월 ✅
- resultMonth = Result 조회 시 전월 스냅샷(L602~609) / departmentEditFlag = DEPARTMENT_ID Red/신규 입력 시 'true'(L766~773) ✅
- 게이트: Version(MSG00688) → G0(MSG00096) → Department 공백(MSG00429 {0}) → 0건(MSG00676) → passthrough+MSG00002+재조회·스크롤 복원 ✅

## 4. 팝업 (활성 3 / dead 2)
| 팝업 | TO-BE | 상태 |
|---|---|---|
| DMF0044_United_VersionPopup(727 — 공유) | UnitedVersionModal 복제 (SP·PROC 재사용, API_ID 만 DMF0049_) | ✅ |
| SCM0002_ProjectbyDivisionPopupEx (ETC=true) | 공용 ProjectByDivisionModal + etc 파라미터 확장(하위호환 'N') | ✅ |
| DM0002_TitleSetForm_Popup (M 모드) | MeasureSelectModal 복제 (param DMF0049) | ✅ |
| DMF0044_Sales_VersionPopUp / DM0002_Item 팝업 | dead(주석) — **이관 제외**. sCUTOFF_YYYYMMDD 공급 경로 소실 = 항상 '' 파리티 | ✅ |

## 5. MSG 매핑 (hook #114 — 신규 채번 0, 전부 기등록 재사용)
00283(조회 전 버전)/00688(저장 전 — AS-IS 00281)/00096(권한)/00429(Department 필수 — AS-IS 00002 용법)/
00002(저장성공 — AS-IS 00004 용법)/00004(무변경)/00676·00618(0건·실패)/United 00682~687.

## 6. 검증 이력
- 2026-07-22: tsc(demand+web) 0 / eslint 0 errors / 메타 P1·P2 사내 적용·검증(MNU 'etc-sales-reports'·API 19·BTN 19·PROC 60행·권한 19/19/13·CMBO 1) / EDIT_AUTH_V DMF0049 49행 확인(INNER JOIN 0건 리스크 해소).
- 잔여: 브라우저 E2E V1~V5 (플랜 §6).

## ⭐ 2026-08-11 — 헤더 1단 전환 + Column Set 버튼 숨김 + 정적 컬럼 편집 메타 종속 (DMF0044 선례 이식)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| H-1 | 동적 컬럼 헤더 **2단(연 span+월 leaf) → 1단 평면**, 라벨 = `COLUMN_LABEL_NAME`(`2025-01`) — AS-IS `DMF0049_Sales_ETC_Reports.cs:265` 이 `CreateSheetHeaderColumnDtDiv(siMain, **1**, …)` 로 `iColumnHeaderRowCount = 1` 을 넘긴다 | `features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx:162~236 (dynColMetas · mainDynamicColumns)` |  | 구현 |
| H-2 | `EtcSalesReportsMergeManager` **연도 가로 머지 제거** — 상위 헤더 행이 없어 묶을 대상이 없다 | `features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.merge.ts:63~71 (ColumnHeader 분기)` |  | 구현 |
| H-3 | `IcGridColumnSetup`(Grid Column Set) 버튼 **숨김** | `features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:302~311 (customButtons — 주석 블록으로 보존)` | 사용자 지시(2026-08-11, DMF0044 2026-08-10 동일). BTN_MPG 메타·모달(`COLUMN`)·배선은 **무변경** — 되살릴 때 주석 블록 + `IcGridColumnSetup` import 복원 | 구현 |
| H-4 | **정적 영역 헤더도 1단** — 공용 `getColumnDepth` 가 메타 클래스 라벨로 단수를 정하던 것을 화면에서 1단 선언 | `features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx:85~102 (mainStaticColumns — sClsLblNm/lClsLblNm='')` | 메타는 **무변경**. AS-IS 도 메타는 동일하고 `.cs:265` 가 `iColumnHeaderRowCount=1` 로 코드에서 1단을 강제한다 — 그 계약을 그대로 옮긴 것 | 구현 |
| H-5 | 정적 컬럼 편집 판정 = **UI Category Setup `INPUT_TP_CD` 단일 원천**(하드코딩 잠금 목록 폐기). 공용 `GridUtils.isEditableCell` 과 동일 규약(IM/IO=신규행·M/O=전 행·S/미지정=불가) | `features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.editLock.ts:73~101 (staticEditableByMeta)` + `components/EtcSalesReportsGrid.tsx:202~207 (inputTpRef)` · `:285~289 (formatItem 색)` · `:302~305 (beginningEdit 편집)` | 색(formatItem)과 편집(beginningEdit)이 **같은 함수 하나**를 본다 — 갈리면 "노란칸인데 못 고침" 이 생긴다 | 구현 |

> ⚠ **종전 2단 구성은 오구성이었다** — `PKG_DMF0049.P_DMF0049_GET_SPREAD_TITLE`(BODY L229~232)이 동적 컬럼의
> `LARGE_CLASS_LABEL_NAME`·`SMALL_CLASS_LABEL_NAME`·`COLUMN_LABEL_NAME` 을 모두 `SCM_SYS_CALENDAR_M.MONTH_NAME`
> (= `2025-01`) **동일값**으로 준다. 그래서 2단으로 묶으면 상위가 `2025`(연도)가 아니라 `2025-01` 이 되어
> **1:1 그룹이 12개** 생겼다. 1단 평면(`2025-01`, `2025-02` …)이 AS-IS 파리티다.
> 헤더 높이는 hook #93 대로 총 48px — 1단이므로 행 1개가 48을 그대로 갖는다(`48 / headerRows.length`).
>
> ⛔ **본 작업에서 `SCM_MST_SHEET_COLUMNS` DML 0건** (조회만). 2026-08-11 실측:
> `PROGRAM_ID='DMF0049'` 42행의 `INPUT_TP_CD` 는 **전부 'S'(Only Search)** 다
> (대조군 DMF0044 는 'MDF Reports' 46행 = IM 1 / IO 32 / S 13 으로 정합 완료).
> ⇒ 현재 메타로는 H-5 전환 후 정적 컬럼이 **신규행에서도 전량 잠금**이다. AS-IS InsertRow 입력 컬럼을
> 열려면 **메타 정합(IM/IO 등재)이 선행**돼야 하며, 이는 **사용자 승인 사항**으로 제안만 남긴다.

## AS-IS 이벤트 핸들러 인벤토리 (2026-08-08 축 — 분석서가 놓친 핸들러 차단)

> 원천: `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0049_Sales_ETC_Reports\DMF0049_Sales_ETC_Reports.cs` — `.cs` 에서 **기계 추출**한 UI 이벤트 핸들러 18개.
> 대사표의 E번호는 **분석 md** 기준이라 분석서가 누락한 핸들러를 못 잡는다. 이 축이 그 구멍을 막는다.
> 사문(빈 몸통) 핸들러는 **미이관이 파리티** — 상태 '제외' + 사유 기재로 통과시킨다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| HANDLER:DeleteButton | AS-IS `DMF0049_Sales_ETC_Reports.cs:284` (라이브 37행) | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:191~201 (handleDelete) |  | 구현 |
| HANDLER:EditButton | AS-IS `DMF0049_Sales_ETC_Reports.cs:338` (라이브 83행) | features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.editLock.ts:22~104 (G0 게이트 + 동적 셀 매트릭스 + 정적 컬럼 2분기) — TO-BE 는 별도 Edit 버튼 없이 셀 단위 판정 엔진이 항상 적용된다 |  | 구현 |
| HANDLER:ExcelButton | AS-IS `DMF0049_Sales_ETC_Reports.cs:471` (라이브 25행) | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:352 (DataGrid excelFileName) — 공통버튼 EXCEL 계약이 내보내기를 담당 |  | 구현 |
| HANDLER:FindButton | AS-IS `DMF0049_Sales_ETC_Reports.cs:274` (라이브 3행) · **사문(빈 몸통)** |  | AS-IS 몸통이 비어 있는 사문(dead) 핸들러 — 실제 동작은 아래 대응 메서드가 담당한다. 이식 대상 아님 (→ `FindData`) | 제외 |
| HANDLER:FindData | AS-IS `DMF0049_Sales_ETC_Reports.cs:522` (라이브 82행) | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:142~155 (handleSearch) + features/demand/src/pages/etc-sales-reports/useEtcSalesReportsStore.ts:121~165 (setFilter) |  | 구현 |
| HANDLER:Form_Load | AS-IS `DMF0049_Sales_ETC_Reports.cs:146` (라이브 7행) | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:126~133 (초기화 useEffect) |  | 구현 |
| HANDLER:InsertButton | AS-IS `DMF0049_Sales_ETC_Reports.cs:279` (라이브 3행) · **사문(빈 몸통)** |  | AS-IS 몸통이 비어 있는 사문(dead) 핸들러 — 실제 동작은 아래 대응 메서드가 담당한다. 이식 대상 아님 (→ `InsertRow`) | 제외 |
| HANDLER:InsertRow | AS-IS `DMF0049_Sales_ETC_Reports.cs:925` (라이브 139행) | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:168~189 (handleInsert — division 세트 블록 삽입) + features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.editLock.ts:88~101 (신규행 정적 컬럼 잠금) |  | 구현 |
| HANDLER:SaveButton | AS-IS `DMF0049_Sales_ETC_Reports.cs:465` (라이브 3행) · **사문(빈 몸통)** |  | AS-IS 몸통이 비어 있는 사문(dead) 핸들러 — 실제 동작은 아래 대응 메서드가 담당한다. 이식 대상 아님 (→ `SaveData`) | 제외 |
| HANDLER:SaveData | AS-IS `DMF0049_Sales_ETC_Reports.cs:629` (라이브 259행) | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:203~ (handleSave) + features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.save.ts:111~180 |  | 구현 |
| HANDLER:btnMeasure_Click | AS-IS `DMF0049_Sales_ETC_Reports.cs:1543` (라이브 9행) | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:311~316 (MEASURE_SELECT hotkey → MEASURE 모달) + features/demand/src/pages/etc-sales-reports/components/modals/MeasureSelectModal.tsx |  | 구현 |
| HANDLER:btnSPVer_Click | AS-IS `DMF0049_Sales_ETC_Reports.cs:1234` (라이브 6행) | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:343 (onOpenVersionModal → VERSION) + features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx:114 (btnSPVer '...') |  | 구현 |
| HANDLER:clbDivision_SelectedIndexChanged | AS-IS `DMF0049_Sales_ETC_Reports.cs:1556` (라이브 8행) | features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx:157~164 (handleDivisionChange — Grid 초기화 + CRUD reset + 정적컬럼·Measure 재조회) ← features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx:58~61 |  | 구현 |
| HANDLER:clbPlanResult_SelectedIndexChanged | AS-IS `DMF0049_Sales_ETC_Reports.cs:1566` (라이브 7행) | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx:96~101 (planResult set) + features/demand/src/pages/etc-sales-reports/useEtcSalesReportsStore.ts:156~160 (resultMonth 스냅샷은 조회 시점에 확정) |  | 구현 |
| HANDLER:clbType_SelectedIndexChanged | AS-IS `DMF0049_Sales_ETC_Reports.cs:1530` (라이브 8행) | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx:70~72 (mdfType 변경 시 versionNo/versionLabel 초기화 — AS-IS `txtSPVersion.Text = null` 파리티) · :116 (BP/SP 라벨 전환) |  | 구현 |
| HANDLER:spdMain_CellClick | AS-IS `DMF0049_Sales_ETC_Reports.cs:1578` (라이브 24행) |  | AS-IS 는 Measure Cnt 에 따른 **Row Span 재계산**(주석 [C20210125-000207])과 CUST_REPORT 무파라미터 콤보 재바인딩만 한다. TO-BE 는 Row Span 을 `features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.merge.ts` MergeManager 가 선언적으로 처리하고, 콤보는 무파라미터라 진입 시 1회 프리페치와 등가다 — 별도 클릭 핸들러 불요 | 제외 |
| HANDLER:spdMain_CellDoubleClick | AS-IS `DMF0049_Sales_ETC_Reports.cs:1428` (라이브 25행) | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx:335~343 (dblclick → PROJECT 모달) |  | 구현 |
| HANDLER:spdMain_Changed | AS-IS `DMF0049_Sales_ETC_Reports.cs:1252` (라이브 134행) | features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx:302~330 (cellEditEnded — 수치셀 빈값 '0' + cascade clear) + features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.gridCombos.ts (resolveDeptIdRows · cascadeClearColumns) |  | 구현 |
## 토큰 대사표 (hook #117 §5.6 — 2026-08-10 실측)

> AS-IS `UP_FX_GetCommonDataList` 의 `@Code + PARAM1~5` 에 대응하는 TO-BE 축.
> **AS-IS 공급 계약**: `SpreadInfo.cs:1975~1981` 이 메타 셀 콤보에 커서 `ATTRIBUTE1~5` 를 `sParam1~5` 로 넘기고,
> `DMF0049_GET_SPREAD_TITLE` 이 `ATTRIBUTE1 = @p_division_id` /
> `CASE WHEN CELL_COMBO_DATA_TYPE='DM_LOOKUP_DIV' THEN C.ATTRIBUTE1` 로 채운다(DMF0042/0044 와 동일 계약).
> BE `makeComboQuery` 는 `@토큰` **raw 치환** · 미전달은 `''` · 서버 자동 주입은 `@sesUserId`/`@sesLangCd` 뿐.
> FE 전달 지점 = `components/EtcSalesReportsGrid.tsx` `useTabComboQueries`(메타 셀 콤보 18컬럼 1구독) +
> `EtcSalesReports.tsx:66~74`(sEditMeasure 단건).

| SQL_ID | 필요 토큰 | 서버 자동 | FE 전달 | 미전달 | 판정 | 비고 |
|---|---|---|---|---|---|---|
| APPLICATION | - | - | - | - | ✅ |  |
| COUNTRY_MST | - | - | - | - | ✅ |  |
| CurrencyList | - | - | - | - | ✅ |  |
| DMF0005_REPORT_GROUP1 | - | - | - | - | ✅ | APPLICATION_GR |
| DMF0005_REPORT_GROUP4 | - | - | - | - | ✅ | PRODUCT_DETAILS |
| DMF0005_REPORT_GROUP6 | - | - | - | - | ✅ | CELL_MODEL_INFO |
| DMF0044_MDF_MEASURE | - | - | - | - | ✅ |  |
| DM_COMPANY | - | - | - | - | ✅ |  |
| END_CUST_REPORT | - | - | - | - | ✅ |  |
| FcstType | - | - | - | - | ✅ | 81 계열 한정 컬럼 |
| Incoterms | - | - | - | - | ✅ | VISIBLE_FLAG='N'(숨김) |
| SOLD_TO_CUST_REPORT | - | - | - | - | ✅ |  |
| DMF0044_MDF_DEPARTMENT | divisionId | - | divisionId=선택 division | - | ✅ | **2026-08-10 정정** — 종전 무전달 |
| DMF0044_DEPARTMENT_TEAM2 | divisionId | - | divisionId=선택 division | - | ✅ | **2026-08-10 정정** — 종전 무전달. lookup 접미(`_81`/`_82`)가 division 으로 갈린다 |
| DMF0044_DEPARTMENT_TEAM | - | - | - | - | ✅ | 행별 콤보(부모키 `DEPARTMENT_ID` 동반 반환) — `resolveDeptIdRows` 가 행 컨텍스트로 필터 |
| **DM_LOOKUP_DIV** | param1, param2 | - | param1=division, param2=컬럼 ATTRIBUTE1 | - | ✅ | **2026-08-10 정정** — 미전달 시 `B.SEGMENT1=@param1 AND A.LOOKUP_TYPE=@param2` 가 비관대형이라 **항상 0행**이었다. 실측: 무전달 0행 → 전달 시 40 BIZ_TYPE 6 / 40 ITEM_ID 16 / 82 ITEM_USE 7 |
| EndCustomerByDivisionDept | deptId, divisionId | sesUserId | - | deptId, divisionId | ✅ | **적용 대상 없음** — END_CUSTOMER 컬럼이 AS-IS·TO-BE 메타 모두 `VISIBLE_FLAG='N'`(숨김)이라 셀이 렌더되지 않는다 |

### quoting 규약 (hook #117 §5.7)

BE 는 `@토큰` 을 **문자열 치환**하므로 값은 반드시 `'값'` 형태여야 한다.

| 전달 지점 | 종전 | 정정 | 실측 |
|---|---|---|---|
| `EtcSalesReports.tsx` sEditMeasure `param1`/`param2` | 따옴표 없음 | `q()` 적용 | **따옴표 X → HTTP 500 (-9994 Sql Error)** / 따옴표 O → 1행(`SalesAmt_KRW`). 종전 상태에서는 `sEditMeasure` 가 **항상 빈값**이라 82 편집 개방 판정이 무력화돼 있었다 |
| `EtcSalesReportsGrid.tsx` 메타 셀 콤보 | 전달 자체가 없음 | `q(division)` / `q(c.attribute1)` | 위 `DM_LOOKUP_DIV` 행 참조 |
