# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 PlanDate / LayoutControlItem | `GlobalPsiForm.tsx` PLAN_DATE FormItem(extraConditions) |  | 구현 |
| D00-1-002 | §1 PlanType / LayoutControlItem | `GlobalPsiForm.tsx` PLAN_TYPE FormItem(extraConditions) |  | 구현 |
| D00-1-003 | §1 SEQ / LayoutControlItem | `GlobalPsiForm.tsx` SEQ FormItem(extraConditions) |  | 구현 |
| D00-1-004 | §1 btnItem_Id / UsrButton | `GlobalPsiForm.tsx` FunctionSearchIcon onItemSearch(Material 팝업) |  | 구현 |
| D00-1-005 | §1 btnMeasure / UsrButton | `GlobalPsi.tsx` customButtons(MEASURE_SELECT) |  | 구현 |
| D00-1-006 | §1 cboBucketType / UsrCombo | `GlobalPsiForm.tsx` bucketOptions BUCKET FormItem |  | 구현 |
| D00-1-007 | §1 cboDivision / UsrCombo | `GlobalPsiForm.tsx` divisionOptions DIVISION FormItem |  | 구현 |
| D00-1-008 | §1 cboPlanDate / UsrCombo | `GlobalPsiForm.tsx` planDateOptions PLAN_DATE FormItem |  | 구현 |
| D00-1-009 | §1 cboPlanSeq / UsrCombo | `GlobalPsiForm.tsx` planSeqOptions SEQ FormItem |  | 구현 |
| D00-1-010 | §1 cboPlanType / UsrCombo | `GlobalPsiForm.tsx` planTypeOptions PLAN_TYPE FormItem |  | 구현 |
| D00-1-011 | §1 chkAll / UsrCheckBox | `GlobalPsiForm.tsx` ALL checkbox(chkAll) |  | 구현 |
| D00-1-012 | §1 chkSum / UsrCheckBox | `GlobalPsiForm.tsx` SUM checkbox(chkSum) |  | 구현 |
| D00-1-013 | §1 clbFromSite / UsrCheckedList2 | `GlobalPsiForm.tsx` fromSiteOptions FROM_SITE multi |  | 구현 |
| D00-1-014 | §1 clbToSite / UsrCheckedList2 | `GlobalPsiForm.tsx` toSiteOptions TO_SITE multi |  | 구현 |
| D00-1-015 | §1 components / Container |  | 비가시 WinForms IContainer(디자이너 스캐폴딩) — React 무등가, design 00 §1 static | 해당없음 |
| D00-1-016 | §1 dCalendar / UsrDateRangePicker3 | `GlobalPsiForm.tsx` PeriodField(from~to) |  | 구현 |
| D00-1-017 | §1 emptySpaceItem1 / EmptySpaceItem |  | DevExpress 레이아웃 여백 스캐폴딩 — React Grid 무등가, design 00 §1 영역1 | 해당없음 |
| D00-1-018 | §1 emptySpaceItem3 / EmptySpaceItem |  | DevExpress 레이아웃 여백 스캐폴딩 — React Grid 무등가, design 00 §1 영역1 | 해당없음 |
| D00-1-019 | §1 layoutControlGroup2 / LayoutControlGroup |  | DevExpress 레이아웃 그룹 컨테이너 — SearchArea 로 대체, design 00 §1 영역1 | 해당없음 |
| D00-1-020 | §1 layoutControlItem1 / LayoutControlItem |  | 레이아웃 라벨 스캐폴딩(Bucket 라벨) — FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-021 | §1 layoutControlItem13 / LayoutControlItem |  | 레이아웃 라벨 스캐폴딩 — FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-022 | §1 layoutControlItem2 / LayoutControlItem |  | 레이아웃 라벨 스캐폴딩 — FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-023 | §1 layoutControlItem3 / LayoutControlItem |  | 레이아웃 라벨 스캐폴딩 — FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-024 | §1 layoutControlItem4 / LayoutControlItem |  | 레이아웃 라벨 스캐폴딩 — FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-025 | §1 layoutControlItem5 / LayoutControlItem |  | 레이아웃 라벨 스캐폴딩 — FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-026 | §1 layoutControlItem7 / LayoutControlItem |  | 레이아웃 라벨 스캐폴딩 — FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-027 | §1 lblBucket / LayoutControlItem |  | Bucket 라벨 스캐폴딩 — BUCKET FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-028 | §1 lblCombo1 / LayoutControlItem |  | Division 라벨 스캐폴딩 — DIVISION FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-029 | §1 lblItemId / LayoutControlItem |  | Material 라벨 스캐폴딩 — MATERIAL FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-030 | §1 lblToSite / LayoutControlItem |  | To Site 라벨 스캐폴딩 — TO_SITE FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-031 | §1 pnlCondition / UsrConditionPanel | `GlobalPsiForm.tsx` SearchArea(conditions/extraConditions) |  | 구현 |
| D00-1-032 | §1 spdMain / FpSpread | `GlobalPsiGrid.tsx` DataGrid |  | 구현 |
| D00-1-033 | §1 spdMain_Sheet1 / SheetView |  | FpSpread SheetView — 공용 DataGrid 단일 시트로 흡수(GlobalPsiGrid.tsx), design 00 §1 | 해당없음 |
| D00-1-034 | §1 txtItemId / UsrMultiLineEditor | `GlobalPsiForm.tsx` MATERIAL InputField(itemId) |  | 구현 |
| D00-1-035 | §1 txtNickName / TextBox | `GlobalPsiForm.tsx` NICK_NAME InputField(nickName) |  | 구현 |
| D00-1-036 | §1 usrButton1 / UsrButton |  | orphan(x0y0/tabIndex0) 미parent·미참조 헬퍼 버튼 — 이식 제외(design 01 §1.1 #36, __asis-mapping__ §5) | 제외 |
| D00-1-037 | §1 usrLayoutControl2 / UsrLayoutControl |  | DevExpress 레이아웃 컨트롤 루트 — SearchArea 로 대체, design 00 §1 영역1 | 해당없음 |
| D00-2-001 | §2 btnItem_Id / Click | `GlobalPsi.tsx` onItemSearch → ItemByDivisionModal |  | 구현 |
| D00-2-002 | §2 btnMeasure / Click | `GlobalPsi.tsx` setOpenMeasurePopup → `GlobalPsiModals.tsx` |  | 구현 |
| D00-2-003 | §2 cboBucketType / SelectedIndexChanged | `globalPsiColumns.ts` isColVisibleForBucket(bucket 변경 시 pivot 재계산) |  | 구현 |
| D00-2-004 | §2 cboDivision / SelectedIndexChanged | `useGlobalPsiStore.ts` setDivision(하위 cascade 초기화 + filters clear) |  | 구현 |
| D00-2-005 | §2 cboPlanDate / SelectedIndexChanged | `GlobalPsiForm.tsx` selectPlanDate(PlanType 재필터 + Period W52 재계산) |  | 구현 |
| D00-2-006 | §2 cboPlanSeq / SelectedIndexChanged | `GlobalPsiForm.tsx` planSeqOptions useMemo(Seq 선택 상태) |  | 구현 |
| D00-2-007 | §2 cboPlanType / SelectedIndexChanged | `GlobalPsiForm.tsx` planTypeOptions useMemo(Seq 재필터) |  | 구현 |
| D00-2-008 | §2 chkAll / CheckedChanged | `useGlobalPsiStore.ts` setFilter(chkAll → p_chk_all Y/N, 조회 시 헤더 재구성) |  | 구현 |
| D00-2-009 | §2 chkSum / CheckedChanged | `globalPsiColumns.ts` isColVisibleForBucket(SUM 컬럼 visible 토글) |  | 구현 |
| D00-2-010 | §2 spdMain / CellDoubleClick |  | SetDblClickColumnShowHide(pivot 드릴다운) — 공용 DataGrid pivot 컬럼 collapse 미제공(자매 SCP0100 동일)·저위험 잔여, design 04 명시. D00-3-025 와 동일 미이식 결정 | 제외 |
| D00-2-011 | §2 spdMain / TopChange | `GlobalPsiGrid.tsx` DataGrid allowMerging(AllowMerging.All — 스크롤 시 병합 유지, 공용 위임) |  | 구현 |
| D00-3-001 | §3 SmartColMerge / 248 | `GlobalPsiGrid.tsx` DataGrid allowMerging(AllowMerging.All) |  | 구현 |
| D00-3-002 | §3 SetReNumerCellType / 283 | `globalPsiColumns.ts` leafOf(format 'n0' 숫자셀) |  | 구현 |
| D00-3-003 | §3 SetReNumerCellType / 287 | `globalPsiColumns.ts` leafOf(format 'n0' 숫자셀) |  | 구현 |
| D00-3-004 | §3 ForeColor= / 290 | `GlobalPsiGrid.tsx` weekdayOf(토=파랑/일=빨강 헤더색) |  | 구현 |
| D00-3-005 | §3 ColumnHeaderSpan / 296 | `globalPsiColumns.ts` buildPivotColumns(largeGroup 1단 span) |  | 구현 |
| D00-3-006 | §3 ColumnHeaderSpan / 297 | `globalPsiColumns.ts` buildPivotColumns(SUM 소속 group) |  | 구현 |
| D00-3-007 | §3 ColumnHeaderSpan / 302 | `globalPsiColumns.ts` buildPivotColumns(smallGroup 2단 span) |  | 구현 |
| D00-3-008 | §3 ColumnHeaderSpan / 303 | `globalPsiColumns.ts` buildPivotColumns(leaf SUM) |  | 구현 |
| D00-3-009 | §3 ColumnHeaderSpan / 310 | `globalPsiColumns.ts` buildPivotColumns(smallGroup 분기) |  | 구현 |
| D00-3-010 | §3 ColumnHeaderSpan / 311 | `globalPsiColumns.ts` buildPivotColumns(leaf SUM 분기) |  | 구현 |
| D00-3-011 | §3 ColumnHeaderSpan / 321 | `globalPsiColumns.ts` buildPivotColumns(smallGroup 분기) |  | 구현 |
| D00-3-012 | §3 ColumnHeaderSpan / 322 | `globalPsiColumns.ts` buildPivotColumns(leaf SUM 분기) |  | 구현 |
| D00-3-013 | §3 ColumnHeaderSpan / 323 | `globalPsiColumns.ts` buildPivotColumns(largeGroup 분기) |  | 구현 |
| D00-3-014 | §3 ColumnHeaderSpan / 324 | `globalPsiColumns.ts` buildPivotColumns(SUM 분기) |  | 구현 |
| D00-3-015 | §3 Visible= / 357 | `globalPsiColumns.ts` isColVisibleForBucket(D_ 항상 표시) |  | 구현 |
| D00-3-016 | §3 Visible= / 361 | `globalPsiColumns.ts` isColVisibleForBucket(SUM=chkSum) |  | 구현 |
| D00-3-017 | §3 Visible= / 366 | `globalPsiColumns.ts` isColVisibleForBucket(비대상 숨김) |  | 구현 |
| D00-3-018 | §3 Visible= / 369 | `globalPsiColumns.ts` isColVisibleForBucket(W_ 표시) |  | 구현 |
| D00-3-019 | §3 Visible= / 373 | `globalPsiColumns.ts` isColVisibleForBucket(SUM=chkSum) |  | 구현 |
| D00-3-020 | §3 Visible= / 378 | `globalPsiColumns.ts` isColVisibleForBucket(비대상 숨김) |  | 구현 |
| D00-3-021 | §3 Visible= / 382 | `globalPsiColumns.ts` isColVisibleForBucket(M_ 표시) |  | 구현 |
| D00-3-022 | §3 Query / 605 | `GlobalPsi.tsx` mainQuery(useTabProcQuery o_rc1 바인딩) |  | 구현 |
| D00-3-023 | §3 LockColumn / 606 | `GlobalPsiGrid.tsx` DataGrid isReadOnly(전열 잠금) |  | 구현 |
| D00-3-024 | §3 SmartColMerge / 614 | `GlobalPsiGrid.tsx` DataGrid allowMerging(조회 후 병합) |  | 구현 |
| D00-3-025 | §3 SetDblClickColumnShowHide / 817 |  | pivot 드릴다운 컬럼 show/hide — 공용 DataGrid pivot 컬럼 collapse 미제공(자매 SCP0100 동일)·저위험 잔여, design 04 명시 | 제외 |
| D00-3-026 | §3 SmartColMerge / 845 | `GlobalPsiGrid.tsx` DataGrid allowMerging(TopChange 재병합, 공용 위임) |  | 구현 |
| D00-4b-001 | §4b BLUtils.GetDivisionWithoutEE / (false) / dtDivision | `GlobalPsiForm.tsx` divisionOptions(Division_SCP + ATTRIBUTE3!=='EE' && CODE!=='40' FE 필터) |  | 구현 |
| D00-4b-002 | §4b Data_SCP.CommonAll / DATE_WEEKLY1 / dtPlanDateAll | `GlobalPsiForm.tsx` planDatesAll(DATE_WEEKLY1_SCP_ALL) + planDateOptions FE 필터 |  | 구현 |
| D00-4b-003 | §4b Data_SCP.CommonAll / PlanType1 / dtPlanTypeAll | `GlobalPsiForm.tsx` planTypesAll(PlanType1_SCP_ALL) + planTypeOptions FE 필터 |  | 구현 |
| D00-4b-004 | §4b Data_SCP.CommonAll / PlanSeq1 / dtPlanSeqAll | `GlobalPsiForm.tsx` planSeqsAll(PlanSeq1_SCP_ALL) + planSeqOptions FE 필터 |  | 구현 |
| D00-4b-005 | §4b Data.Common / FromSiteByDivision / dtFromSite | `GlobalPsiForm.tsx` fromSites(FromSiteByDivision, divisionId+validYn='Y') |  | 구현 |
| D00-4b-006 | §4b Data.Common / ToSiteByDivision / dtToSite | `GlobalPsiForm.tsx` toSites(ToSiteByDivision, divisionId) |  | 구현 |
| D00-4b-007 | §4b Data_SCP.Common / SCPPlanPeriod / dtPlanPeriodRange | `GlobalPsi.tsx` clampPeriodToHorizon(SCPPlanPeriod_SCP getCombo — 기간범위 검증) |  | 구현 |
| D00-4c-001 | §4c DBUtils.Filter / dtPlanDateAll | `GlobalPsiForm.tsx` planDateOptions(DIVISION_ID FE 필터) |  | 구현 |
| D00-4c-002 | §4c DBUtils.Filter / dtPlanTypeAll | `GlobalPsiForm.tsx` planTypeOptions(DIVISION_ID+PLANDATE FE 필터) |  | 구현 |
| D00-4c-003 | §4c DBUtils.Filter / dtPlanSeqAll | `GlobalPsiForm.tsx` planSeqOptions(DIVISION_ID+PLANDATE+PLANTYPE FE 필터) |  | 구현 |
| D00-4e-001 | §4e — / GMessageBox | `GlobalPsi.tsx` clampPeriodToHorizon(MSG00402 setAlert — 기간 horizon 초과) |  | 구현 |
| D00-4e-002 | §4e — / GMessageBoxForException |  | AS-IS FindData_Main try/catch 예외 알림 — TO-BE 는 useTabProcQuery/apiClient 공용 오류 처리로 흡수(clampPeriodToHorizon catch 무해 진행), design 00 §4e | 해당없음 |
| D00-4e-003 | §4e MSG00049 / GMessageBox | `GlobalPsi.tsx` validateRequired(Period from/to 필수 → MSG00013 setAlert) |  | 구현 |
| D00-4e-004 | §4e MSG00108 / GMessageBox | `GlobalPsiForm.tsx` PeriodField(캘린더 내장 시작>종료 검증) |  | 구현 |
| D00-4e-005 | §4e MSG00049 / GMessageBox | `GlobalPsi.tsx` validateRequired(날짜 필수 → MSG00013 setAlert) |  | 구현 |
| D00-4e-006 | §4e MSG00049 / GMessageBox | `GlobalPsi.tsx` validateRequired(날짜 필수 → MSG00013 setAlert) |  | 구현 |
| D00-4e-007 | §4e MSG00108 / GMessageBox | `GlobalPsiForm.tsx` PeriodField(캘린더 내장 시작>종료 검증) |  | 구현 |
| D00-4e-008 | §4e MSG00049 / GMessageBox | `GlobalPsi.tsx` validateRequired(날짜 필수 → MSG00013 setAlert) |  | 구현 |
| D00-4f-001 | §4f ProgressForm / Show | `GlobalPsi.tsx` mainQuery(useTabProcQuery pending — 공용 로딩) |  | 구현 |
| D00-4f-002 | §4f SCM0002_TitleSetForm_Popup / ShowDialog | `GlobalPsiModals.tsx` MeasureSelectModal + saveTitleSet('M') |  | 구현 |
| D00-4f-003 | §4f SCM0002_MaterialByDivisionPopup / ShowDialog | `GlobalPsi.tsx` ItemByDivisionModal(onItemSearch) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:GlobalPsiModals | FE 실존 모달 (components/GlobalPsiModals.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | `components/GlobalPsiModals.tsx` MeasureSelectModal(saveTitleSet 'M') | AS-IS SCM0002_TitleSetForm_Popup(Measure 설정) 재현 — design 00 §4f | 구현 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | 자재=`GlobalPsi.tsx` onItemSearch→공용 ItemByDivisionModal / Measure=GlobalPsiModals | AS-IS SCM0002_MaterialByDivisionPopup + SCM0002_TitleSetForm_Popup(design 00 §4f) 1:1 | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) |  | 해당없음 — 읽기전용 PIVOT 분석 조회(Insert 경로 부재, Edit/Save/Delete NO-OP·전열 INPUT_TP_CD='S'). design 01 §4d | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) |  | 해당없음 — 편집 경로 부재(전열 잠금, dirty 상태 없음) | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | `GlobalPsiModals.tsx`(MeasureSelectModal) + `useGlobalPsiStore.fetchStaticMeasures` + Search 시 컬럼/measure 재생성 | AS-IS btnMeasure→축 재생성(design 03 C3) | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) |  | 해당없음 — CRUD 부재(읽기전용). 조회 결과만 렌더 | 해당없음 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | SubTitle 공통 ExcelButtonWithoutCopy — 그리드 표시값(Name) 그대로 export. 편집 콤보 컬럼 없음(OPERATION_GROUP hidden) | 공용 Excel export(design 01 V6) | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) |  | 해당없음 — 조회조건 전부 콤보/날짜/팝업 단일값(Material=팝업 반환, NickName=단일 텍스트). AS-IS 도 콤마 다중 미지원. 그리드 key-in 필터 없음(읽기전용) | 해당없음 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | 공용 DataGrid rebindFilterColumns(자매 global-psi-elec 동일) | 공용 컴포넌트 위임 | 구현 |

## 1. events (11) — 100% 매핑

| # | AS-IS 이벤트 | 라인 | TO-BE 재현 | 상태 |
|---:|---|---|---|:---:|
| 1 | btnItem_Id Click | .cs:919 | `GlobalPsi.tsx` onItemSearch → ItemByDivisionModal | O |
| 2 | cboBucketType SIC | .cs:864 | Bucket 변경 → grid `buildPivotColumns(bucket)` visible 재계산(globalPsiColumns) | O |
| 3 | cboDivision SIC | .cs:914 | `useGlobalPsiStore.setDivision` — 하위 cascade 초기화 + 그리드 clear | O |
| 4 | cboPlanDate SIC | .cs:899 | Form `selectPlanDate` — PlanType 재필터 + Period(W52) 재계산 + 그리드 clear | O |
| 5 | cboPlanSeq SIC | .cs:345 | Seq 변경 → 그리드 clear(filters 비움, 하위 없음) | O |
| 6 | cboPlanType SIC | .cs:889 | Form planType 변경 → Seq 재필터(planSeqOptions useMemo) + 그리드 clear | O |
| 7 | chkAll change | .cs:883 | `chkAll` → p_chk_all Y/N(store setFilter) + 조회 시 헤더 재구성(재조회) | O |
| 8 | chkSum change | .cs:878 | `chkSum` → SUM 컬럼 visible 토글(globalPsiColumns isColVisibleForBucket) | O |
| 9 | btnMeasure Click | .cs:817 계열 | `GlobalPsiModals` MeasureSelectModal + saveTitleSet('M') | O |
| 10 | SpdMain CellDoubleClick | .cs:816 | pivot 드릴다운(컬럼 show/hide) — 공용 DataGrid 미제공 → 미구현(저위험 잔여, 04 명시) | 잔여 |
| 11 | FindButton(Search) | .cs:492 | `handleSearch` — checkRequired → setFilter → useTabProcQuery | O |

## 2. comboCalls (7) + filterCalls (3) — 100% 매핑

| boundControl | AS-IS 호출 | TO-BE SQL_ID | FE 재현 | 상태 |
|---|---|---|---|:---:|
| cboDivision | `BLUtils.GetDivisionWithoutEE`→`Data_SCP.Common(Type.Division)` | `Division_SCP` | FE 필터 `ATTRIBUTE3!=='EE' && CODE!=='40'`(design 02 §2.2 ①②) | O |
| clbFromSite | `Data.Common(Type.FromSiteByDivision)` | `FromSiteByDivision` | divisionId 재조회 + validYn='Y' + '-' 센티넬 | O |
| clbToSite | `Data.Common(Type.ToSiteByDivision)` | `ToSiteByDivision` | divisionId 재조회 + '-' 센티넬. `@__GROUP__` 미주입(N3 확인필요) | O(잔여) |
| cboPlanDate | `Data_SCP.CommonAll(Type.DATE_WEEKLY1)` | `DATE_WEEKLY1_SCP_ALL` | filterCall#1: 전체로드 후 FE 필터 `DIVISION_ID` | O |
| cboPlanType | `Data_SCP.CommonAll(Type.PlanType1)` | `PlanType1_SCP_ALL` | filterCall#2: FE 필터 `DIVISION_ID+PLANDATE`, 기본=마지막 | O |
| cboPlanSeq | `Data_SCP.CommonAll(Type.PlanSeq1)` | `PlanSeq1_SCP_ALL` | filterCall#3: FE 필터 `DIVISION_ID+PLANDATE+PLANTYPE`, 기본=index0 | O |
| cboBucketType | `DM.DM0003_GET_BUCKET_TYPE_CODE` | `BucketType`(lookup) | 정적 select, 기본 DAILY | O |

- 좁힘 주체 단일화(CLAUDE.local §5): _ALL 3콤보는 divisionId 미전송(전체 로드) + FE 필터만. Site 는 서버 divisionId 좁힘.
- 콤보 의미 패리티(convert-core §2.6): 8 SQL_ID 전부 `Type.X`→`X_SCP`/`X_SCP_ALL`/base 규약 도출 + DB 실측 확정. `MyDivision` 재사용 금지.

## 3. validations (8) — 100% 매핑

| # | AS-IS 검증 | 라인 | TO-BE 재현 | 상태 |
|---:|---|---|---|:---:|
| 1 | checkRequired(pnlCondition) — 필수 5(Division/PlanDate/PlanType/Seq/Period) | .cs:529 | `GlobalPsi.validateRequired` + FormItem required + MSG00013 | O |
| 2 | Check_PeriodDate(dCalendar) | .cs:530 | PeriodField 캘린더 내장 검증(from/to YYYYMMDD) | O |
| 3 | CheckPlanPeriodRange(SCPPlanPeriod_SCP) HORIZON_END clamp | .cs:537~542 | 기간 범위 clamp — 확인필요(04, runtime-parity: SCPPlanPeriod_SCP 조회 필요) | 잔여 |
| 4~8 | 기간/필수 파생 검증(체크리스트 §4e) | 각 라인 | #1~#3 로 흡수(필수 + 기간 유효성 + 범위). 나머지 파생은 SP 계약 종속 | O(#1~2)/잔여(#3) |

## 4. popups (3) — 100% 매핑

| AS-IS 팝업 | TO-BE | 상태 |
|---|---|:---:|
| SCM0002_MaterialByDivisionPopup(btnItem_Id) | `ItemByDivisionModal`(features/master) — preSearchParams=division, 반환→itemId | O |
| SCM0002_TitleSetForm_Popup(btnMeasure) | `MeasureSelectModal`(features/master) + saveTitleSet('M') | O |
| ProgressForm(공통 로딩) | 공용 로딩(useTabProcQuery pending) — 별도 이식 불요 | O |

## 5. editMode 미이식 결정 (convert-core §2.1(11))

AS-IS `LockColumn(0,max,true)`(.cs:606)로 조회 후 전열 잠금 = 읽기전용 성격. 이 화면은 **편집 자체가 없다**
(Edit/Save/Delete override 전부 빈 몸체 NO-OP, .cs:497~510). 따라서:
- `editMode`/`setEditMode` store 상태 **신설하지 않는다**(self-check grep 0 hit).
- `canEdit` 축도 두지 않는다(편집 경로 0). DataGrid `isReadOnly` + 컬럼 메타 `INPUT_TP_CD='S'`(잠금)로 전열 읽기전용.
- 버튼: SEARCH/EXCEL/MEASURE_SELECT 만 노출. Delete/Edit/Save = DB 미등록(hasButton=false) + hotkeyConfig `false`
  로 공용 SubTitle 기본 addRow/removeRow 부활 차단(design 01 §2 B3~B5).
- usrButton1(orphan, .cs:97~128) = 미parent·미참조 → 이식 제외(design 01 §1.1 #36).
