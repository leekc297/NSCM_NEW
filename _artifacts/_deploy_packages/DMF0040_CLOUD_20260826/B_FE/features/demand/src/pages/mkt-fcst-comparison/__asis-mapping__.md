# __asis-mapping__.md — EID 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `DMF0040_MktFcstComparison_주요이벤트_상세분석.md`, `DMF0040_MktFcstComparison_제약매트릭스_상세.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (EID 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| E01 | DMF0040 (MKT FCST Comparison) — 주요이벤트 상세분석 (E01~E22 전수) | MktFcstComparison.tsx:60~66 (mount fetch)·components/MktFcstComparisonForm.tsx:57~69 (콤보 적재)·useMktFcstComparisonStore.ts:33~57 (기본값 — Bucket MONTHLY·기간 당월~+6개월) |  | 구현 |
| E02 | cboDivision_SelectedIndexChanged (L943~1042) | components/MktFcstComparisonForm.tsx:118~137 (DivisionField cascade 클리어)·MktFcstComparison.tsx:60~66 (staticColumns/Measures 재fetch)·useMktFcstComparisonStore.ts:setFilters (spreadTitle division) |  | 구현 |
| E02-1 | `FP_Log2("SpeedUp","DMF0040","division_id_changed", start/end)` 속도 로그 (TO-BE 해당없음 — BE Qu… |  | 해당없음 — AS-IS 프레임워크 속도 로그(FP_Log2). TO-BE 는 BE QueryLogInterceptor 가 대체 | 해당없음 |
| E02-2 | `miFormLoad==1` 이면 `InitSpread()` (동적 헤더 재구성 — division 이 SPREAD_TITLE 파라미터) | useMktFcstComparisonStore.ts:107~113 (spreadTitle filters — division 파라미터)·components/MktFcstComparisonGrid.tsx:dynColMetas (조회 시 재구성) |  | 구현 |
| E02-3 | cascade 재적재: Team → (division=="40" 분기: `lblProject.Enabled=false`·`lblPlantSite.Enabled=… | components/MktFcstComparisonForm.tsx:118~137 (cascade)·components/MktFcstComparisonForm.tsx:isDivision40 → ProjectField/PlantSiteField disabled (D-04) |  | 구현 |
| E02-4 | 텍스트 4종 클리어: txtProject/txtItemId/txtVersion/txtOwner (L1032~1035) | components/MktFcstComparisonForm.tsx:126~134 (projectCodes/itemIds/owners/version 클리어) |  | 구현 |
| E02-5 | `SetClbVersion()` (E08 — 실질 no-op) + `GetDefaultVersion()` (E22-b: SCM0002_GET_VERSIONBYW… | components/MktFcstComparisonForm.tsx:72~103 (defaultVersionQuery — MF_W 'Current' 제외 상위 2 자동 세팅. E08 사문 부분은 제외) |  | 구현 |
| E03 | clbTeam_SelectedIndexChanged (L1044~1082) | components/MktFcstComparisonForm.tsx:139~144 (TeamField onChange — endCustomers/salesSiteIds 클리어, 파라미터 분기는 master 공용 필드) |  | 구현 |
| E04 | clbCustomer_SelectedIndexChanged (L1084~1110) | components/MktFcstComparisonForm.tsx:146~151 (EndCustomerField onChange — salesSiteIds 클리어) |  | 구현 |
| E05 | ClbSalesSite_SelectedIndexChanged (L1112) / E06. ClbPlantSite_SelectedIndexChanged (L1117… |  | 제외 — E05~E08 은 SetClbVersion 사문(no-op) 호출뿐 (주요이벤트 md §G) | 제외 |
| E08 | SetClbVersion (L1132~1139) |  | 제외 — 사문 메서드 (로컬 변수만 읽고 종료, 구 로직 제거 잔재) | 제외 |
| E09 | cboBucketType_SelectedIndexChanged (L1141~1160) | components/MktFcstComparisonGrid.tsx:bucketPrefix/applyDynVisibility (D_/W_/M_ 가시성)·components/MktFcstComparisonForm.tsx:106~110 (ONLY_WEEKLY Sum 해제). EditButton 2회 분기는 사문 제외 |  | 구현 |
| E10 | spdMain_ComboSelChange (L1163~1172) |  | 제외 — Insert 행 전제 사문 (읽기 전용 화면 — 편집 진입 불가) | 제외 |
| E11 | spdMain_CellDoubleClick (L1175~1250) | components/MktFcstComparisonGrid.tsx:onDblClick (M_→W_ 토글·D_ 접기 / W_→D_ 토글). 셀 더블클릭 분기(Insert 전제)는 사문 제외 |  | 구현 |
| E12 | spdMain_TopChange (L1252~1256) | components/MktFcstComparisonGrid.tsx:ComparisonHeaderMergeManager + allowMerging=All (wijmo 가 스크롤 시 병합 유지 — SmartColMerge 대응) |  | 구현 |
| E13 | spdMain_KeyUp (L1258~1276) | 공용 DataGrid — wijmo 기본 클립보드 복사 (읽기 전용이라 붙여넣기 무효 = AS-IS 전열 잠금 파리티) |  | 구현 |
| E14 | btnProject_Click (L1280~1302) | components/MktFcstComparisonForm.tsx:ProjectField (master 공용 검색 모달 — AS-IS DMF000_ProjectbyDivisionPopupEx 대응) |  | 구현 |
| E15 | btnItemId_Click (L1305~1335) | components/MktFcstComparisonForm.tsx:ItemField (master 공용 — AS-IS DM0002_ItembyDivisionPopupEx 대응) |  | 구현 |
| E16 | btnColumn_Click (L1338~1348) | MktFcstComparison.tsx:customButtons Column Setting + ColumnLayoutModal (PROGRAM_ID=DMF0040·titleSet 'C'·저장 시 clearData=UC-03) |  | 구현 |
| E17 | btnMeasure_Click (L1350~1360) | MktFcstComparison.tsx:customButtons Measure + MeasureSelectModal (master 정본 — TO-BE 는 PROGRAM_ID=DMF0040 독립 축, SHEET_MEASURE 49행 시딩 seed_meta.py) |  | 구현 |
| E18 | chkSum_CheckedChanged (L1362~1368) | components/MktFcstComparisonGrid.tsx:summaryBindings × searchParams.isSumChecked (applyDynVisibility) |  | 구현 |
| E19 | btnVersion_Click (L1642~1668) | components/MktFcstComparisonForm.tsx:Version InputField(클릭/키=모달) + components/ComparisonVersionModal.tsx (최대 2·기간 반영 onApply) |  | 구현 |
| E20 | txtVersion_KeyDown (L1670~1673) | components/MktFcstComparisonForm.tsx:onKeyDown={() => setOpenVersionModal(true)} (AS-IS 키 입력=팝업 1:1) |  | 구현 |
| E21 | btnOwner_Click (L1720~1747) | components/MktFcstComparisonForm.tsx:OwnerField (master 공용 — AS-IS DM0020_OwnerbyDivisionPopup 대응) |  | 구현 |
| E22 | DMF0040 (MKT FCST Comparison) — 주요이벤트 상세분석 (E01~E22 전수) | components/MktFcstComparisonGrid.tsx:gridRows (QTY divisor ÷1/1e3/1e6/1e8 표시 사본 — Round 2·0 skip·원본 보존) + E22-b 는 components/MktFcstComparisonForm.tsx:defaultVersionQuery |  | 구현 |
| A-01 | 671~677 / `checkRequiredOfSearch`(Required 3종: Division*/Period*/Version*) 통과 후 `sDivisio… | MktFcstComparison.tsx:handleSubmit (MSG00097 — division 빈값 차단) |  | 구현 |
| A-02 | 680~685 / `int(sPeriod[0]) > int(sPeriod[1])` 기간 역전 | MktFcstComparison.tsx:handleSubmit (MSG00108 — from>to 차단) |  | 구현 |
| A-03 | 687~695 / `drpPeriod.Value1.AddYears(2) < Value2` (2년 초과) | MktFcstComparison.tsx:handleSubmit (MSG00164 + 종료일=시작일+2년 자동 보정 — 보정까지 파리티. 문구 3년 vs 로직 2년은 제약매트릭스 A-03 비고) |  | 구현 |
| D-01 | 293 / InitControls | components/MktFcstComparisonForm.tsx: master 필드가 division 빈값 시 빈 목록 (공용 필드 내장 가드) |  | 구현 |
| D-02 | 295 / InitControls | components/MktFcstComparisonForm.tsx:EndCustomerField division/deptId 파라미터 (81계열·82/40 분기 = 공용 CMBO 서버측) |  | 구현 |
| D-03 | 671 / FindData | MktFcstComparison.tsx:handleSubmit V1 (A-01 동일 지점) |  | 구현 |
| D-04 | 968 / cboDivision change | components/MktFcstComparisonForm.tsx:isDivision40 → ProjectField/PlantSiteField disabled |  | 구현 |
| D-05 | 1051 / clbTeam change | components/MktFcstComparisonForm.tsx: master 필드 division 가드 (D-01 동일) |  | 구현 |
| D-06 | 1053 / clbTeam change | components/MktFcstComparisonForm.tsx:TeamField→Customer/SalesSite 재적재 (deptId/endCustomer 파라미터 — 공용 필드) |  | 구현 |
| D-07 | 1090 / clbCustomer change | components/MktFcstComparisonForm.tsx: master 필드 division 가드 |  | 구현 |
| D-08 | 1092 / clbCustomer change | components/MktFcstComparisonForm.tsx:SalesSiteField comboId='UserSiteByEndCustomer' + endCustomer/deptId 파라미터 |  | 구현 |
| D-09 | 1164 / spdMain_ComboSelChange |  | 제외 — Insert 행 전제 사문 (읽기 전용) | 제외 |
| D-10 | 1439 / fnValidation |  | 제외 — Insert 행 전제 사문 (fnValidation 9키 중복 검사 — 저장 경로 없음) | 제외 |
| G-01 | 1657 (validation.md #14 txtVersion_KeyDown) / txtVersion KeyDown | components/MktFcstComparisonForm.tsx:Version InputField readOnly + onClick/onKeyDown=모달 (직접 타이핑 차단 1:1) |  | 구현 |
| G-02 | 1671 / GetThisWeekMonday | components/MktFcstComparisonGrid.tsx:thisWeekMondayYmd (Current 실적 경계 월요일 역산) |  | 구현 |
| G-03 | 1694 / GetLastWeekSunDayByDate | components/MktFcstComparisonGrid.tsx:lastWeekSundayYmd (Cutoff 버전 전주 일요일 역산) |  | 구현 |
| G-04 | 1748 / SetAmountCalculating | components/MktFcstComparisonGrid.tsx:gridRows divisor===1 이면 원본 반환 (QTY index 0 가드 1:1) |  | 구현 |
| P-01 | 588~595 / EditButton (F2) |  | 해당없음 — 편집 진입점 자체 미노출 (hotkeyConfig insert/delete/save=false — MSG00109 표시 상황 부재) | 해당없음 |
| P-02 | 1652~1660 / btnVersion_Click 반환 검사 | components/ComparisonVersionModal.tsx:handleApply (VERSION_MAX_SELECT=2 초과 시 MSG00255 — AS-IS 반환부 검사를 모달 내부로 통합) |  | 구현 |
| P-03 | 팝업 SetItem (팝업 .cs L318~324) / OK 시 선택 행 수 `iCnt > 2` | components/ComparisonVersionModal.tsx:handleApply (동일 지점 — AS-IS 팝업 SetItem 차단 1:1) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:ComparisonVersionModal | FE 실존 모달 (components/ComparisonVersionModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | components/ComparisonVersionModal.tsx — AS-IS DMF0000_VersionByWaterfallPopup 1:1 (주요이벤트 md §E 4영역: 조회조건 4축·SP SCM0002 6p·그리드 표시 5컬럼·최대 2 선택 MSG00255·기간 반영. CRUD=R 만 — 조회 전용 팝업, C/U/D 해당없음) |  | 구현 |
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) |  | 해당없음 — Insert 기능 없음 (읽기 전용 화면, AS-IS InsertButton 빈 구현) | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) |  | 해당없음 — 편집 기능 없음 (수정 중 상태가 존재하지 않음) | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | MktFcstComparison.tsx:ColumnLayoutModal onSave·MeasureSelectModal onApply → clearData() (filters 리셋 = 그리드 비움, hook #132 §2-2) |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) |  | 해당없음 — CRUD 저장 없음 (titleSet 개인화 저장은 공용 모달 경로) | 해당없음 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | 공용 SubTitle Excel Download (gridAction dataMap 승계 — 본 화면 정적 컬럼은 콤보 셀 없음·코드 그대로가 원장 값) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | components/MktFcstComparisonForm.tsx:ProjectField/ItemField/OwnerField — master 공용 필드의 콤마 다중 입력 지원 (join(',') 전달 useMktFcstComparisonStore.ts:setFilters) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | components/MktFcstComparisonGrid.tsx (공용 DataGrid 소비 — rebindFilterColumns 는 packages/shared 공용 DataGrid 내장 L850~852, 화면 배선 불요) |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) |  | 해당없음 — Insert 기능 없음 (읽기 전용 화면, AS-IS InsertButton 빈 구현) | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) |  | 해당없음 — 편집 기능 없음 (수정 중 상태가 존재하지 않음) | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | MktFcstComparison.tsx:ColumnLayoutModal onSave·MeasureSelectModal onApply → clearData() (filters 리셋 = 그리드 비움, hook #132 §2-2) |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) |  | 해당없음 — CRUD 저장 없음 (titleSet 개인화 저장은 공용 모달 경로) | 해당없음 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | 공용 SubTitle Excel Download (gridAction dataMap 승계 — 본 화면 정적 컬럼은 콤보 셀 없음·코드 그대로가 원장 값) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | components/MktFcstComparisonForm.tsx:ProjectField/ItemField/OwnerField — master 공용 필드의 콤마 다중 입력 지원 (join(',') 전달 useMktFcstComparisonStore.ts:setFilters) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | components/MktFcstComparisonGrid.tsx (공용 DataGrid 소비 — rebindFilterColumns 는 packages/shared 공용 DataGrid 내장 L850~852, 화면 배선 불요) |  | 구현 |

## 보완요청(REQ) 축 (2026-08-20 — 사용자 지정 보완요청 · 대상: DMF0040)

> 원장: `Doc/단위테스트_보완대상/보완요청_원장.md` · 대상 UI=DMF0040 행 0건.
> ⭐ 미적용 전제 — 원장 PENDING 행은 본 표 상태와 무관하게 --check FAIL. 전이는 실측 근거 기입 시에만 (사전 판단 SKIP 금지).

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|

## AS-IS 이벤트 핸들러 인벤토리 (2026-08-08 축 — 분석서가 놓친 핸들러 차단)

> 원천: `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0040_MktFcst_Comparison\DMF0040_MktFcst_Comparison.cs` — `.cs` 에서 **기계 추출**한 UI 이벤트 핸들러 29개.
> 대사표의 E번호는 **분석 md** 기준이라 분석서가 누락한 핸들러를 못 잡는다. 이 축이 그 구멍을 막는다.
> 사문(빈 몸통) 핸들러는 **미이관이 파리티** — 상태 '제외' + 사유 기재로 통과시킨다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| HANDLER:ClbPlantSite_SelectedIndexChanged | AS-IS `DMF0040_MktFcst_Comparison.cs:1117` (라이브 3행) · **사문(빈 몸통)** |  | 제외 — 사문 (SetClbVersion no-op 호출뿐, E05 판정) | 제외 |
| HANDLER:ClbSalesSite_SelectedIndexChanged | AS-IS `DMF0040_MktFcst_Comparison.cs:1112` (라이브 3행) · **사문(빈 몸통)** |  | 제외 — 사문 (동일) | 제외 |
| HANDLER:DeleteButton | AS-IS `DMF0040_MktFcst_Comparison.cs:584` (라이브 2행) · **사문(빈 몸통)** |  | 제외 — 빈 몸통 (읽기 전용) — hotkeyConfig delete:false 로 미노출이 파리티 | 제외 |
| HANDLER:EditButton | AS-IS `DMF0040_MktFcst_Comparison.cs:589` (라이브 7행) |  | 해당없음 — 읽기전용 통보(MSG00109)뿐. TO-BE 는 편집 진입점 미노출 (P-01) | 해당없음 |
| HANDLER:ExcelButton | AS-IS `DMF0040_MktFcst_Comparison.cs:604` (라이브 25행) | 공용 SubTitle Excel Download (excelFileName='MktFcstComparison' — HideZero·수치 포맷은 공용 옵션) |  | 구현 |
| HANDLER:FindButton | AS-IS `DMF0040_MktFcst_Comparison.cs:574` (라이브 3행) · **사문(빈 몸통)** | MktFcstComparison.tsx:hotkeyConfig.search=handleSubmit |  | 구현 |
| HANDLER:FindData | AS-IS `DMF0040_MktFcst_Comparison.cs:655` (라이브 156행) | MktFcstComparison.tsx:handleSubmit + useMktFcstComparisonStore.ts:setFilters + components/MktFcstComparisonGrid.tsx (회색/파랑/footer) |  | 구현 |
| HANDLER:FindData:NegativeRed | AS-IS 프레임워크 `01_Framework/GSCM.Windows.Forms/Class/SpreadInfo.cs:4143` 등 `NumberCellType.NegativeRed=true` (전 수치 셀 음수 = Red) + `.cs:913~915` Difference 행 Blue | components/MktFcstComparisonGrid.tsx:formatHandler — 음수 Red(#c62828) 우선, Difference 0·양수 Blue(#1565c0) | 2026-08-27 사용자 지적 후 보완 — 화면 .cs 만 대조하고 프레임워크 셀타입 기본 서식(NegativeRed)을 누락 | 구현 |
| HANDLER:Form_Load | AS-IS `DMF0040_MktFcst_Comparison.cs:188` (라이브 11행) | MktFcstComparison.tsx:60~66 + components/MktFcstComparisonForm.tsx:57~69 + useMktFcstComparisonStore.ts: 기본값 (E01) |  | 구현 |
| HANDLER:InsertButton | AS-IS `DMF0040_MktFcst_Comparison.cs:579` (라이브 2행) · **사문(빈 몸통)** |  | 제외 — 빈 몸통. insert:false 미노출 | 제외 |
| HANDLER:SaveButton | AS-IS `DMF0040_MktFcst_Comparison.cs:598` (라이브 2행) · **사문(빈 몸통)** |  | 제외 — 빈 몸통. save:false 미노출 | 제외 |
| HANDLER:TxtItemId_Enter | AS-IS `DMF0040_MktFcst_Comparison.cs:1127` (라이브 3행) · **사문(빈 몸통)** |  | 제외 — 사문 (SetClbVersion no-op) | 제외 |
| HANDLER:TxtProject_Changed | AS-IS `DMF0040_MktFcst_Comparison.cs:1122` (라이브 3행) · **사문(빈 몸통)** |  | 제외 — 사문 (동일) | 제외 |
| HANDLER:btnColumn_Click | AS-IS `DMF0040_MktFcst_Comparison.cs:1333` (라이브 9행) | MktFcstComparison.tsx:ColumnLayoutModal (E16) |  | 구현 |
| HANDLER:btnItemId_Click | AS-IS `DMF0040_MktFcst_Comparison.cs:1307` (라이브 17행) | components/MktFcstComparisonForm.tsx:ItemField (E15) |  | 구현 |
| HANDLER:btnMeasure_Click | AS-IS `DMF0040_MktFcst_Comparison.cs:1345` (라이브 9행) | MktFcstComparison.tsx:MeasureSelectModal (E17) |  | 구현 |
| HANDLER:btnOwner_Click | AS-IS `DMF0040_MktFcst_Comparison.cs:1706` (라이브 14행) | components/MktFcstComparisonForm.tsx:OwnerField (E21) |  | 구현 |
| HANDLER:btnProject_Click | AS-IS `DMF0040_MktFcst_Comparison.cs:1284` (라이브 17행) | components/MktFcstComparisonForm.tsx:ProjectField (E14) |  | 구현 |
| HANDLER:btnVersion_Click | AS-IS `DMF0040_MktFcst_Comparison.cs:1629` (라이브 23행) | components/MktFcstComparisonForm.tsx:Version 버튼 + components/ComparisonVersionModal.tsx (E19) |  | 구현 |
| HANDLER:cboBucketType_SelectedIndexChanged | AS-IS `DMF0040_MktFcst_Comparison.cs:1141` (라이브 15행) | components/MktFcstComparisonGrid.tsx:applyDynVisibility + components/MktFcstComparisonForm.tsx:ONLY_WEEKLY Sum 해제 (E09) |  | 구현 |
| HANDLER:cboDivision_SelectedIndexChanged | AS-IS `DMF0040_MktFcst_Comparison.cs:946` (라이브 50행) | components/MktFcstComparisonForm.tsx:DivisionField onChange (E02) |  | 구현 |
| HANDLER:cboQTY_SelectedIndexChanged | AS-IS `DMF0040_MktFcst_Comparison.cs:1727` (라이브 5행) | components/MktFcstComparisonGrid.tsx:gridRows divisor (E22) |  | 구현 |
| HANDLER:chkSum_CheckedChanged | AS-IS `DMF0040_MktFcst_Comparison.cs:1358` (라이브 6행) | components/MktFcstComparisonGrid.tsx:summaryBindings 가시성 (E18) |  | 구현 |
| HANDLER:clbCustomer_SelectedIndexChanged | AS-IS `DMF0040_MktFcst_Comparison.cs:1085` (라이브 17행) | components/MktFcstComparisonForm.tsx:EndCustomerField (E04) |  | 구현 |
| HANDLER:clbTeam_SelectedIndexChanged | AS-IS `DMF0040_MktFcst_Comparison.cs:1046` (라이브 21행) | components/MktFcstComparisonForm.tsx:TeamField (E03) |  | 구현 |
| HANDLER:spdMain_CellDoubleClick | AS-IS `DMF0040_MktFcst_Comparison.cs:1174` (라이브 71행) | components/MktFcstComparisonGrid.tsx:onDblClick 헤더 드릴다운 (E11 — 셀 분기는 사문) |  | 구현 |
| HANDLER:spdMain_ComboSelChange | AS-IS `DMF0040_MktFcst_Comparison.cs:1162` (라이브 9행) |  | 제외 — Insert 전제 사문 (E10) | 제외 |
| HANDLER:spdMain_KeyUp | AS-IS `DMF0040_MktFcst_Comparison.cs:1265` (라이브 12행) | 공용 DataGrid — wijmo 기본 클립보드 (E13) |  | 구현 |
| HANDLER:spdMain_TopChange | AS-IS `DMF0040_MktFcst_Comparison.cs:1258` (라이브 5행) | components/MktFcstComparisonGrid.tsx:MergeManager (E12 — wijmo 자동 유지) |  | 구현 |
| HANDLER:txtVersion_KeyDown | AS-IS `DMF0040_MktFcst_Comparison.cs:1657` (라이브 3행) · **사문(빈 몸통)** | components/MktFcstComparisonForm.tsx:Version onKeyDown=모달 (E20 — AS-IS 는 btnVersion_Click 위임) |  | 구현 |

## 콤보 토큰 대사표 (hook #117 §5.6 — 조회조건 콤보 9종)

> DMF0040 은 그리드 셀 콤보 0종(조회 전용) — 아래는 조회조건 콤보. 토큰 전달 주체는 **master 공용 검색필드**
> (`features/master/src/components` — DivisionField 등)이며, 페이지 폴더에는 comboParams 리터럴이 없어
> 게이트 섹션 7 이 "미전달" WARN 을 낸다 (도구 스캔 범위 = 페이지 폴더 한계 — 실전달은 아래 실측 인용).

| SQL_ID | 필요 토큰 | 전달 주체 (실측) | 판정 |
|---|---|---|---|
| Division | @divisionId | 공용 SQL 관대형 — Division 목록 자체 조회라 무토큰 호출이 AS-IS 파리티 (DMF0035/0082 동일) | 정합 |
| BizTypeByDivision | @divisionId | `BizTypeField division={searchParams.divisionId}` (MktFcstComparisonForm.tsx L160~164) | 정합 |
| SiteByEndCustomer | @divisionId·@endCustomer | `SalesSiteField division=... endCustomer={searchParams.endCustomers.join(',')}` (L150~156) | 정합 |
| PlantSitebyEndCustomer | @divisionId·@endCustomer | `PlantSiteField division=... endCustomer=...` (동일 패턴 — 40 은 disabled) | 정합 |
| DmBizType / FcstType / ItemType / TeamByDivision / EndCustomerByDivision | (무토큰 또는 division) | 공용 필드 내부 전달 (`TeamField`/`EndCustomerField` division prop) | 정합 |

## 단위테스트 축 사유 (asis-coverage-check §0.4 — 게이트 섹션 9 WARN)

- 값 검증 대상인 **배분/판정 순수 함수 부재**: DMF0040 은 조회 전용 비교 리포트 — 수치 계산(버전 차이 Difference 산출·합계)은 전량 `PKG_DMF0040` SP 가 수행하고 FE 는 표시(QTY divisor 표시사본·색상·드릴다운 토글)만 담당. AS-IS 산식 1:1 값 검증은 SP 축 = R 스모크(40=854/81=462/82=585행·CODE=0) + HTTP E2E rows 대조로 수행.
- 화면 단위 케이스는 `Doc/단위테스트/DMF0040_MktFcstComparison_TestCases.xlsx` (40/81/82 시트 각 28행 + DATA) — 브라우저 실조작 축은 사용자 확인 인계.
