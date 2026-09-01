# __asis-mapping__.md — EID 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `DMF0053_CustFcstWaterfall_주요이벤트_상세분석.md`, `DMF0053_CustFcstWaterfall_제약매트릭스_상세.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (EID 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| E01 | DMF0053 (Customer FCST Waterfall) — 주요 이벤트 상세분석 (E01~E23) | CustFcstWaterfall.tsx:26~78 (store 초기화·division effect L72~77) + useCustFcstWaterfallStore.ts:46~66 (기본값 Bucket=MONTHLY·기간 6/1개월) |  | 구현 |
| E02 | `cboDivision_SelectedIndexChanged` / Division 변경 (L928) | components/CustFcstWaterfallForm.tsx:75~92 (DivisionField onChange — cascade 클리어+텍스트 3칸) + CustFcstWaterfall.tsx:72~77 (#113 재fetch) + cascade-combo-filter §1.4 Grid 초기화=clearData 경로 |  | 구현 |
| E03 | `clbTeam_SelectedIndexChanged` / Team 변경 (L1030) | components/CustFcstWaterfallForm.tsx:93~98 (TeamField — endCustomers·salesSiteIds 클리어) |  | 구현 |
| E04 | `clbCustomer_SelectedIndexChanged` / End Customer 변경 (L1067) | components/CustFcstWaterfallForm.tsx:99~104 (EndCustomerField — salesSiteIds 클리어) |  | 구현 |
| E05 | `ClbSalesSite_SelectedIndexChanged` / — |  | 제외 — AS-IS 미배선 사문 (Designer·InitEvent 에 += 없음 + 본문 SetClbVersion=no-op L1114~1121) | 제외 |
| E06 | `ClbPlantSite_SelectedIndexChanged` / — |  | 제외 — 동일 사문 (E05) | 제외 |
| E07 | `TxtProject_Changed` / — |  | 제외 — 동일 사문 (E05) | 제외 |
| E08 | `TxtItemId_Enter` / — |  | 제외 — 동일 사문 (E05) | 제외 |
| E09 | `cboBucketType_SelectedIndexChanged` / Bucket 변경 (L1123) | components/CustFcstWaterfallForm.tsx:136~149 (Bucket 콤보) + components/CustFcstWaterfallGrid.tsx:139~157 (bucket 가시성 재계산·드릴 리셋) — AS-IS 이중 배선은 1회로 정상화 |  | 구현 |
| E10 | `spdMain_ComboSelChange` / Grid Division 셀 콤보 변경 (L1148) |  | 제외 — dead path (조회 후 전열 잠금 L786·Insert 미노출 — ACTION='I' 행이 존재할 수 없음) | 제외 |
| E11 | `spdMain_CellDoubleClick`(헤더) / M_/W_ 헤더 더블클릭 (L1160~1210) | components/CustFcstWaterfallGrid.tsx:296~330 (onDblClick — M_→W_ 토글·D_ 접기 / W_→D_ 토글) |  | 구현 |
| E12 | `spdMain_CellDoubleClick`(셀) / 데이터 셀 더블클릭 (L1211~1248) |  | 제외 — dead path (IsLock OR ACTION!='I' 이면 즉시 return L1213 — 읽기 전용 화면에서 도달 불가) | 제외 |
| E13 | `spdMain_TopChange` / 스크롤 (L1251) | components/CustFcstWaterfallGrid.tsx:365~372 (DataGrid allowMerging=All — wijmo 기본 머지가 스크롤 재머지 담당) |  | 구현 |
| E14 | `spdMain_KeyUp` / Ctrl+C/V (L1258) | components/CustFcstWaterfallGrid.tsx:365~372 (wijmo 기본 Copy) — Paste 는 제외(읽기 전용·WinForms 플랫폼 차이) |  | 구현 |
| E15 | `btnProject_Click` / PJT 검색 버튼 (L1277) | components/CustFcstWaterfallForm.tsx:155~165 (ProjectField — master 공용 ProjectByDivisionModal·40 비활성) |  | 구현 |
| E16 | `btnItemId_Click` / Model/Nickname 검색 버튼 (L1300) | components/CustFcstWaterfallForm.tsx:166~175 (ItemField — master 공용 ItemByDivisionModal) |  | 구현 |
| E17 | `btnColumn_Click` / Column Setting (L1326) | CustFcstWaterfall.tsx:180~217 (ColumnLayoutModal 'C' + applyColumnLayout + saveTitleSet('C') + clearData UC-03) |  | 구현 |
| E18 | `btnMeasure_Click` / Measure (L1338) | CustFcstWaterfall.tsx:219~233 (MeasureSelectModal + saveTitleSet('M') + clearData) |  | 구현 |
| E19 | `chkSum_CheckedChanged` / Sum 체크 (L1351) | components/CustFcstWaterfallForm.tsx:231~242 (Sum 체크 — ONLY_WEEKLY 비활성) + components/CustFcstWaterfallGrid.tsx:263~276 (요약 컬럼 가시성) |  | 구현 |
| E20 | `chkColor_CheckedChanged` / — |  | 제외 — AS-IS 미배선 사문 + 실적 회색 로직 전부 주석 (L811~903) | 제외 |
| E21 | `btnVersion_Click` / Version 팝업 (L1657) |  | 제외 — Version 조회조건 미구현 (AS-IS btnVersion.Visible=false Designer L348 + #112 카탈로그 17행·Figma 프레임 모두 부재 → versionNo='' 고정 useCustFcstWaterfallStore.ts:118) | 제외 |
| E22 | `txtVersion_KeyDown` / Version 칸 키 입력 (L1676) |  | 제외 — E21 과 동일 사유 (숨겨진 팝업의 유일한 진입로) | 제외 |
| E23 | DMF0053 (Customer FCST Waterfall) — 주요 이벤트 상세분석 (E01~E23) | components/CustFcstWaterfallForm.tsx:204~213 (OwnerField — master 공용 OwnerByDivisionModal) + components/CustFcstWaterfallGrid.tsx:88~103 (cboQTY→QTY 표시 사본 divisor E23+) |  | 구현 |
| A-01 | FindData L677~682 / Division 미선택 | CustFcstWaterfall.tsx:83~87 (MSG00097 차단) |  | 구현 |
| A-02 | FindData L686~690 / Period 시작>종료 | CustFcstWaterfall.tsx:98~102 (MSG00108 차단) |  | 구현 |
| A-03 | FindData L692~699 / **Period 3년 초과** | CustFcstWaterfall.tsx:104~109 (MSG00164 알림 + endYyyymmdd=from+3년 보정 후 중단 — PERIOD_LIMIT_YEARS=3 cust-fcst-waterfall.constants.ts:27) |  | 구현 |
| A-04 | FindData L701~707 / Input Date(CreateDate) 시작>종료 | CustFcstWaterfall.tsx:111~115 (MSG00108 차단) |  | 구현 |
| A-05 | FindData L709~716 / Input Date 3년 초과 | CustFcstWaterfall.tsx:117~122 (MSG00164 + toCreateYyyymmdd 보정) |  | 구현 |
| A-06 | EditButton L587~594 / 편집 시도 (F2) |  | 해당없음 — 편집 진입점 자체 미노출 (hotkeyConfig insert/delete/save=false CustFcstWaterfall.tsx:130~137) — MSG00109 도달 경로 없음 | 해당없음 |
| B-01 | InitControls L286 / `Substring(0,2)=="81"` OR `=="82"` 분기 | components/CustFcstWaterfallForm.tsx:41~42 (isProjectEnabled = startsWith('81') OR ==='82') + master 공용 필드 division cascade |  | 구현 |
| B-02 | FindData L677 / `sDivision==""` | CustFcstWaterfall.tsx:83~87 (A-01 과 동일 지점) |  | 구현 |
| B-09 | spdMain_ComboSelChange L1150 / Division 컬럼 판정 |  | 제외 — dead path (E10 과 동일 — 전열 잠금·편집 셀 없음) | 제외 |
| B-10 | fnValidation L1462 / 신규 행 중복 검사 (9 컬럼 동치) |  | 제외 — dead code (SaveData 주석·저장 경로 없음 — fnValidation 소비처 부재) | 제외 |
| C-01 | GetLastWeekSunDayByDate L1691 / 월요일 도달 시 전일(일요일) 반환 |  | 제외 — 소비처(실적 회색 L811~903)가 전부 주석 = dead code | 제외 |
| C-02 | SetAmountCalculating L1744 / `QTY index==0` 이면 원본 복원 | components/CustFcstWaterfallGrid.tsx:90~103 (divisor===1 이면 원본 반환 — AS-IS SelectedIndex 0 복원 파리티) |  | 구현 |
| D-01 | txtVersion_KeyDown L1676 / 아무 키 → Version 팝업 |  | 제외 — Version 조회조건 미구현 (E21/E22 와 동일 사유) | 제외 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:E15:SEARCH | [SEARCH] `btnProject_Click` / PJT 검색 버튼 (L1277) | components/CustFcstWaterfallForm.tsx:155~165 (ProjectField 열기→선택 반영 — R 전용) |  | 구현 |
| CRUD:E16:SEARCH | [SEARCH] `btnItemId_Click` / Model/Nickname 검색 버튼 (L1300) | components/CustFcstWaterfallForm.tsx:166~175 (ItemField 열기→선택 반영 — R 전용) |  | 구현 |
| MODAL:ColumnLayoutModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | CustFcstWaterfall.tsx:180~217 — 공용 정본 (@shared/components) 사용·columnType='C'·sheetName='CUST Fcst Waterfall'·onSave=titleSet 'C'+UC-03. 4영역=공용 모달 소관(#132 사본 금지) |  | 구현 |
| MODAL:ItemByDivisionModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | components/CustFcstWaterfallForm.tsx:166~175 — master 공용 정본 (AS-IS DM0002_ItembyDivisionPopupEx L1311 대응) |  | 구현 |
| MODAL:MeasureSelectModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | CustFcstWaterfall.tsx:219~233 — master 공용 정본·staticMeasures(SHEET_MEASURE 기시딩 2행)·onApply=titleSet 'M'+UC-03 |  | 구현 |
| MODAL:OwnerByDivisionModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | components/CustFcstWaterfallForm.tsx:204~213 — master 공용 정본 (AS-IS DM0020_OwnerbyDivisionPopup L1713 대응) |  | 구현 |
| MODAL:ProjectByDivisionModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | components/CustFcstWaterfallForm.tsx:155~165 — master 공용 정본 (AS-IS SCM0002_ProjectbyDivisionPopupEx L1286 대응·division/team/endCustomer/scmSite/project 전달) |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) |  | 해당없음 — Insert 기능 없음 (읽기 전용 화면, AS-IS InsertButton 주석 L577~580) | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) |  | 해당없음 — 편집 기능 없음 (수정 중 상태가 존재하지 않음) | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | CustFcstWaterfall.tsx:212~216·231 (ColumnLayoutModal onSave·MeasureSelectModal onApply → clearData() = filters 리셋·그리드 비움, hook #132 §2-2) |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) |  | 해당없음 — CRUD 저장 없음 (titleSet 개인화 저장은 공용 모달 경로) | 해당없음 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | CustFcstWaterfall.tsx:171 (SubTitle excelFileName='CustFcstWaterfall' — gridAction dataMap 승계. 본 화면 정적 컬럼은 콤보 셀 없음·코드 그대로가 원장 값) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | components/CustFcstWaterfallForm.tsx:155~213 (ProjectField/ItemField/OwnerField — master 공용 필드 콤마 다중 입력, join(',') 전달 useCustFcstWaterfallStore.ts:106~115) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | components/CustFcstWaterfallGrid.tsx:365~372 (공용 DataGrid 소비 — rebindFilterColumns 는 packages/shared 공용 DataGrid 내장, 화면 배선 불요) |  | 구현 |

## 보완요청(REQ) 축 (2026-08-20 — 사용자 지정 보완요청 · 대상: DMF0053)

> 원장: `Doc/단위테스트_보완대상/보완요청_원장.md` · 대상 UI=DMF0053 행 12건.
> ⭐ 미적용 전제 — 원장 PENDING 행은 본 표 상태와 무관하게 --check FAIL. 전이는 실측 근거 기입 시에만 (사전 판단 SKIP 금지).

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| REQ:CHAT-20260828-UM01-DMF0053 | Div Default 선택 + 변경 시 초기화 | EV:features/demand/src/pages/cust-fcst-waterfall/CustFcstWaterfall.tsx::UM-01 Division 기본 선택 · FE:handleDivisionChange · FE:clearData |  | 구현 |
| REQ:CHAT-20260828-UM02-DMF0053 | Team 선택 시 End Customer cascade | EV:features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx::cascade=\{\{ DEPT_ID |  | 구현 |
| REQ:CHAT-20260828-UM03-DMF0053 | div 선택 시 Biz.Type / Plant Site cascade | EV:features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx::PlantSiteField · EV:features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx::BizTypeField |  | 구현 |
| REQ:CHAT-20260828-UM04-DMF0053 | 숫자 자릿수 AS-IS 동일 | FE:scaleOf · EV:features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallGrid.tsx::DATA_SCALE_NUMBER |  | 구현 |
| REQ:CHAT-20260828-UM05-DMF0053 | 초기화 일자 AS-IS 동일 | FE:defaultPeriod |  | 구현 |
| REQ:CHAT-20260828-UM06-DMF0053 | header 높이 1단 크기·최대 3줄 | EV:features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallGrid.tsx::tierH |  | 구현 |
| REQ:CHAT-20260828-UM07-DMF0053 | 필터 버튼 동작 | EV:features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallGrid.tsx::gridFilterRef=\{gridFilterRef\} |  | 구현 |
| REQ:CHAT-20260828-UM08-DMF0053 | (BUCKET) 즉각 반응 / ONLY_WEEKLY 전환 시 grid 초기화+헤더 재생성 | FE:isBucketResetBoundary · FE:resetForBucket |  | 구현 |
| REQ:CHAT-20260828-UM09-DMF0053 | (BUCKET) ONLY_WEEKLY 헤더 주차:날짜 1:1 | EV:features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallGrid.tsx::UM-09 |  | 구현 |
| REQ:CHAT-20260828-UM10-DMF0053 | (BUCKET) 월/주차 헤더 더블클릭 접힘·펼침 | EV:features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallGrid.tsx::getMergedRange |  | 구현 |
| REQ:CHAT-20260828-UM11-DMF0053 | (BUCKET) ONLY_WEEKLY 최하단 sum | EV:features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallGrid.tsx::columnFooters |  | 구현 |
| REQ:CHAT-20260828-UM12-DMF0053 | 합계 값 기준 AS-IS 통일 | EV:features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallGrid.tsx::Aggregate.Sum |  | 구현 |

## UI 필수 12행동(UM) 축 (2026-08-28 — hook #149, 착수 화면부터)

> 원천: 사용자 지정 12항목(2026-08-28) — hook #149 `ui-mandatory-12-behaviors`. 12행 전부 판정(구현+위치 / 해당없음+사유). 빈 행 = FAIL.
> 코드 증거(판정신호)는 원장 `REQ:CHAT-20260828-UM{nn}-DMF0053` 행이 담당 — 산문 '정합' 만으로 구현을 쓰지 말 것. 런타임 실측 = `_artifacts/_diagnostics/um12_browser_probe.py DMF0053` (2026-08-28 PASS).

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| UM-01 | Div Default 선택(세션 division 우선·없으면 첫 행) + Division 변경 시 Grid 초기화·CRUD reset (hook #149 / #59 §1.4) | CustFcstWaterfall.tsx (MyDivision effect · handleDivisionChange→clearData) / useCustFcstWaterfallStore.ts clearData | 런타임 probe PASS (um12_browser_probe 2026-08-28) | 구현 |
| UM-02 | Team 선택 시 End Customer cascade (EndCustomerField cascade DEPT_ID strict — AS-IS EndCustomerByDivision(division, team)) | components/CustFcstWaterfallForm.tsx EndCustomerField cascade={{ DEPT_ID: { values, strict: true } }} |  | 구현 |
| UM-03 | Division 선택 시 Biz.Type / Plant Site cascade + 81*/82 활성 분기 (AS-IS cboDivision_SelectedIndexChanged) | components/CustFcstWaterfallForm.tsx BizTypeField division= / PlantSiteField division= endCustomer= disabled 분기 |  | 구현 |
| UM-04 | 숫자 자릿수 = AS-IS (타이틀 SP DATA_SCALE_NUMBER 소비 — SpreadInfo.cs L1433~1440 decimalPlaces) | components/CustFcstWaterfallGrid.tsx DynColMeta scale (scaleOf DATA_SCALE_NUMBER) / cust-fcst-waterfall.constants.ts scaleOf·DEFAULT_DYN_SCALE |  | 구현 |
| UM-05 | 초기 일자 = AS-IS (PR_GET_DAY_RANGE p_month — 당월 1일~+p_month 개월 말일) | useCustFcstWaterfallStore.ts defaultPeriod (PR_GET_DAY_RANGE 등가) |  | 구현 |
| UM-06 | 헤더 높이 = 1단 크기(48px) 안에 최대 3줄 (#93 — DataGrid row 단위 강제) | components/CustFcstWaterfallGrid.tsx headerRowHeight/tierH (+ packages/shared data-grid/DataGrid.tsx updatedLayout row 강제) | probe 총 48px 실측 | 구현 |
| UM-07 | 필터 버튼(F4) 실동작 — gridFilterRef 페이지→Grid→DataGrid 관통 (OLAP = Grid Layout 레일 Filters) | components/CustFcstWaterfallGrid.tsx <DataGrid gridFilterRef={gridFilterRef}> |  | 구현 |
| UM-08 | (BUCKET) 선택 즉시 컬럼 가시성 반응 + ONLY_WEEKLY 경계 전환 시 grid 초기화·헤더 재생성 (AS-IS InitSpread) | cust-fcst-waterfall.constants.ts isBucketResetBoundary / useCustFcstWaterfallStore.ts resetForBucket / CustFcstWaterfall.tsx handleBucketChange |  | 구현 |
| UM-09 | (BUCKET) ONLY_WEEKLY 헤더 = AS-IS 3행(월/주차/SUM) 병합 없음, 주차:날짜 1:1 (사용자 결정 2026-08-28) | components/CustFcstWaterfallGrid.tsx ONLY_WEEKLY 컬럼별 3단 그룹 + MergeManager getOnlyWeekly 무병합 (tierH 16) | probe rows [16,16,16]=48 | 구현 |
| UM-10 | (BUCKET) 월/주차 헤더 더블클릭 접힘·펼침 — 머지 원점(getMergedRange) 복원 (#103) | components/CustFcstWaterfallGrid.tsx handleHeaderDblClick getMergedRange(columnHeaders).leftCol |  | 구현 |
| UM-11 | (BUCKET) ONLY_WEEKLY 에도 최하단 sum (footer 는 bucket 무관 항상 — AS-IS InitSpreadFooterSum) | components/CustFcstWaterfallGrid.tsx columnFooters GroupRow + formatItem ColumnFooter n3·#d3d3d3 |  | 구현 |
| UM-12 | 합계 값 기준 = AS-IS (SumIgnoreHidden = 표시 행·컬럼 클라이언트 합, SP 합계행 없음) | components/CustFcstWaterfallGrid.tsx Aggregate.Sum over 표시 사본 (= SumIgnoreHidden) |  | 구현 |

## AS-IS 이벤트 핸들러 인벤토리 (2026-08-08 축 — 분석서가 놓친 핸들러 차단)

> 원천: `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0053_CustFcstWaterfall\DMF0053_CustFcstWaterfall.cs` — `.cs` 에서 **기계 추출**한 UI 이벤트 핸들러 30개.
> 대사표의 E번호는 **분석 md** 기준이라 분석서가 누락한 핸들러를 못 잡는다. 이 축이 그 구멍을 막는다.
> 사문(빈 몸통) 핸들러는 **미이관이 파리티** — 상태 '제외' + 사유 기재로 통과시킨다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| HANDLER:ClbPlantSite_SelectedIndexChanged | AS-IS `DMF0053_CustFcstWaterfall.cs:1099` (라이브 3행) · **사문(빈 몸통)** |  | 제외 — 사문 — E06 | 제외 |
| HANDLER:ClbSalesSite_SelectedIndexChanged | AS-IS `DMF0053_CustFcstWaterfall.cs:1094` (라이브 3행) · **사문(빈 몸통)** |  | 제외 — 사문(미배선 + SetClbVersion no-op) — E05 | 제외 |
| HANDLER:DeleteButton | AS-IS `DMF0053_CustFcstWaterfall.cs:582` (라이브 2행) · **사문(빈 몸통)** |  | 제외 — 사문(빈 몸통·주석) — delete=false | 제외 |
| HANDLER:EditButton | AS-IS `DMF0053_CustFcstWaterfall.cs:587` (라이브 7행) |  | 해당없음 — 편집 진입점 미노출 (A-06 동일 — MSG00109 도달 경로 없음) | 해당없음 |
| HANDLER:ExcelButton | AS-IS `DMF0053_CustFcstWaterfall.cs:602` (라이브 25행) | CustFcstWaterfall.tsx:164~178 (SubTitle Excel Download — UC-05) |  | 구현 |
| HANDLER:FindButton | AS-IS `DMF0053_CustFcstWaterfall.cs:572` (라이브 3행) · **사문(빈 몸통)** | CustFcstWaterfall.tsx:80·130 (hotkeyConfig.search=handleSubmit — F5) |  | 구현 |
| HANDLER:FindData | AS-IS `DMF0053_CustFcstWaterfall.cs:662` (라이브 115행) | CustFcstWaterfall.tsx:80~127 (handleSubmit — A-01~A-05 + setFilters) |  | 구현 |
| HANDLER:Form_Load | AS-IS `DMF0053_CustFcstWaterfall.cs:181` (라이브 11행) | CustFcstWaterfall.tsx:26~78 (E01) |  | 구현 |
| HANDLER:InsertButton | AS-IS `DMF0053_CustFcstWaterfall.cs:577` (라이브 2행) · **사문(빈 몸통)** |  | 제외 — 사문(빈 몸통·주석) — hotkeyConfig insert=false 로 미노출이 파리티 | 제외 |
| HANDLER:SaveButton | AS-IS `DMF0053_CustFcstWaterfall.cs:596` (라이브 2행) · **사문(빈 몸통)** |  | 제외 — 사문(빈 몸통·주석) — save=false | 제외 |
| HANDLER:TxtItemId_Enter | AS-IS `DMF0053_CustFcstWaterfall.cs:1109` (라이브 3행) · **사문(빈 몸통)** |  | 제외 — 사문 — E08 | 제외 |
| HANDLER:TxtProject_Changed | AS-IS `DMF0053_CustFcstWaterfall.cs:1104` (라이브 3행) · **사문(빈 몸통)** |  | 제외 — 사문 — E07 | 제외 |
| HANDLER:btnColumn_Click | AS-IS `DMF0053_CustFcstWaterfall.cs:1326` (라이브 9행) | CustFcstWaterfall.tsx:180~217 (E17) |  | 구현 |
| HANDLER:btnItemId_Click | AS-IS `DMF0053_CustFcstWaterfall.cs:1300` (라이브 17행) | components/CustFcstWaterfallForm.tsx:166~175 (E16) |  | 구현 |
| HANDLER:btnMeasure_Click | AS-IS `DMF0053_CustFcstWaterfall.cs:1338` (라이브 9행) | CustFcstWaterfall.tsx:219~233 (E18) |  | 구현 |
| HANDLER:btnOwner_Click | AS-IS `DMF0053_CustFcstWaterfall.cs:1702` (라이브 14행) | components/CustFcstWaterfallForm.tsx:204~213 (E23) |  | 구현 |
| HANDLER:btnProject_Click | AS-IS `DMF0053_CustFcstWaterfall.cs:1277` (라이브 17행) | components/CustFcstWaterfallForm.tsx:155~165 (E15) |  | 구현 |
| HANDLER:btnVersion_Click | AS-IS `DMF0053_CustFcstWaterfall.cs:1657` (라이브 14행) |  | 제외 — Version 미구현 (E21) | 제외 |
| HANDLER:cboBucketType_SelectedIndexChanged | AS-IS `DMF0053_CustFcstWaterfall.cs:1123` (라이브 20행) | components/CustFcstWaterfallForm.tsx:136~149 + components/CustFcstWaterfallGrid.tsx:139~157 (E09) |  | 구현 |
| HANDLER:cboDivision_SelectedIndexChanged | AS-IS `DMF0053_CustFcstWaterfall.cs:928` (라이브 50행) | components/CustFcstWaterfallForm.tsx:75~92 (E02) |  | 구현 |
| HANDLER:cboQTY_SelectedIndexChanged | AS-IS `DMF0053_CustFcstWaterfall.cs:1723` (라이브 5행) | components/CustFcstWaterfallGrid.tsx:88~103 (QTY 표시 사본 divisor — E23+·C-02) |  | 구현 |
| HANDLER:chkColor_CheckedChanged | AS-IS `DMF0053_CustFcstWaterfall.cs:1359` (라이브 4행) |  | 제외 — 사문(미배선·회색 로직 주석) — E20 | 제외 |
| HANDLER:chkSum_CheckedChanged | AS-IS `DMF0053_CustFcstWaterfall.cs:1351` (라이브 6행) | components/CustFcstWaterfallForm.tsx:231~242 (E19) |  | 구현 |
| HANDLER:clbCustomer_SelectedIndexChanged | AS-IS `DMF0053_CustFcstWaterfall.cs:1067` (라이브 17행) | components/CustFcstWaterfallForm.tsx:99~104 (E04) |  | 구현 |
| HANDLER:clbTeam_SelectedIndexChanged | AS-IS `DMF0053_CustFcstWaterfall.cs:1030` (라이브 21행) | components/CustFcstWaterfallForm.tsx:93~98 (E03) |  | 구현 |
| HANDLER:spdMain_CellDoubleClick | AS-IS `DMF0053_CustFcstWaterfall.cs:1160` (라이브 76행) | components/CustFcstWaterfallGrid.tsx:296~330 (헤더 드릴다운 E11 — 셀 팝업 축은 dead path E12 제외) |  | 구현 |
| HANDLER:spdMain_ComboSelChange | AS-IS `DMF0053_CustFcstWaterfall.cs:1148` (라이브 9행) |  | 제외 — dead path (E10) | 제외 |
| HANDLER:spdMain_KeyUp | AS-IS `DMF0053_CustFcstWaterfall.cs:1258` (라이브 12행) | components/CustFcstWaterfallGrid.tsx:365~372 (wijmo 기본 Copy — E14·Paste 제외) |  | 구현 |
| HANDLER:spdMain_TopChange | AS-IS `DMF0053_CustFcstWaterfall.cs:1251` (라이브 5행) | components/CustFcstWaterfallGrid.tsx:365~372 (wijmo 기본 머지 — E13) |  | 구현 |
| HANDLER:txtVersion_KeyDown | AS-IS `DMF0053_CustFcstWaterfall.cs:1676` (라이브 3행) · **사문(빈 몸통)** |  | 제외 — Version 미구현 (E22) | 제외 |

## 콤보 토큰 대사표 (hook #117 §5.6 — 조회조건 콤보)

> DMF0053 은 그리드 셀 콤보 0종(읽기 전용 — CELL_COMBO_DATA_TYPE 지정 3건은 사전 D12 'AS-IS 잔재·정정 대상 아님' 판정).
> 토큰 전달 주체는 **master 공용 검색필드** — 페이지 폴더에 comboParams 리터럴이 없어 게이트 섹션 7 이
> "미전달" WARN 을 낼 수 있다 (도구 스캔 범위 = 페이지 폴더 한계 — 실전달은 아래 실측 인용).

| SQL_ID | 필요 토큰 | 전달 주체 (실측) | 판정 |
|---|---|---|---|
| Division | @divisionId | 공용 SQL 관대형 — Division 목록 자체 조회 (DMF0035/0040 동일) | 정합 |
| TeamByDivision 계열 | @divisionId | `TeamField division={searchParams.divisionId}` (components/CustFcstWaterfallForm.tsx:93~98) | 정합 |
| EndCustomerByDivision(Dept) | @divisionId·@deptId | `EndCustomerField division=... cascade={{ DEPT_ID: { values: deptIds, strict: true } }}` (components/CustFcstWaterfallForm.tsx) — ⚠ 2026-08-28 정정: 종전 "공용 필드 내부 전달" 은 허위 기재(cascade 미전달 = Team→End Customer 무반응, UM-02). 코드 증거 없는 산문 '정합' 금지(hook #149 §0-2) | 정합 |
| UserSiteByEndCustomer | @divisionId·@endCustomer·@deptId | `SalesSiteField comboId='UserSiteByEndCustomer' division=... endCustomer=... deptId=...` (L105~113) | 정합 |
| BizTypeByDivision | @divisionId | `BizTypeField division=...` (L115~120) | 정합 |
| PlantSitebyEndCustomer | @divisionId·@endCustomer | `PlantSiteField division=... endCustomer=...` (L176~183) | 정합 |
| ReportBucketType / QtyType / ItemType | (무토큰) | `useTabComboQueries` (L44~46) | 정합 |

## 단위테스트 축 사유 (asis-coverage-check §0.4 — 게이트 섹션 9)

- 값 검증 대상인 **배분/판정 순수 함수 부재**: DMF0053 은 조회 전용 리포트 — 수치 계산(Measure 펼침·합계·정렬)은 전량 `PKG_DMF0053` SP 가 수행하고 FE 는 표시(QTY divisor 표시 사본·드릴다운 토글·SAT/SUN 색)만 담당. AS-IS 산식 1:1 값 검증은 SP 축 = 스모크(GTT 단계별 카운트·MEASURE 목록 실측) + HTTP E2E rows 대조로 수행.
- 화면 단위 케이스는 `Doc/단위테스트/DMF0053_CustFcstWaterfall_TestCases.xlsx` (40/81/82 시트 + DATA) — 브라우저 실조작 축은 사용자 확인 인계.

## 데이터 결함 발견·정정 기록 (E20260827-CFHCD)

- **DM_PLN_CUST_FCST_H.CREATE_DATE 이관 누락**: TO-BE 전량 NULL(2,873,365행) vs AS-IS 전량 채움 실측 → 메인 SP 의 Input Date 필터(BODY L523~524)가 전멸 = 전 사용자 0행. CREATION_DATE 파생 불가(일치율 12% 실측) → AS-IS 실값을 HISTORY_SEQ 키로 채움(2,873,365행 적용·NULL-only 멱등). 클라우드 = `C_DATA/load_create_date_from_csv.py`.
