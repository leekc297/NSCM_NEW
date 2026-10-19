# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 lblCombo1 / LayoutControlItem | `GlobalPsiElecForm.tsx` `LABEL.DIVISION` (FormItem label) |  | 구현 |
| D00-1-002 | §1 cboDivision / UsrCombo | `GlobalPsiElecForm.tsx` `divisionOptions` (single CustomDropdown) |  | 구현 |
| D00-1-003 | §1 lblItemId / LayoutControlItem | `GlobalPsiElecForm.tsx` `LABEL.MODEL` (FormItem label) |  | 구현 |
| D00-1-004 | §1 txtItem_Id / UsrMultiLineEditor | `GlobalPsiElecForm.tsx` Model `InputField` (sc.itemId) |  | 구현 |
| D00-1-005 | §1 cboCompany / UsrCheckedList | `GlobalPsiElecForm.tsx` `companyOptions` (multi CustomDropdown) |  | 구현 |
| D00-1-006 | §1 btnItem_Id / UsrButton | `GlobalPsiElecForm.tsx` `onModelSearch` (FunctionSearchIcon) → `GlobalPsiElec.tsx` `ElecMaterialPopup` |  | 구현 |
| D00-1-007 | §1 layoutControlItem7 / LayoutControlItem | `GlobalPsiElecForm.tsx` `LABEL.COMPANY` (FormItem label) |  | 구현 |
| D00-1-008 | §1 layoutControlItem4 / LayoutControlItem | `GlobalPsiElecForm.tsx` `SearchArea` conditions Grid (레이아웃 슬롯) |  | 구현 |
| D00-1-009 | §1 cboPlanDate / UsrCombo | `GlobalPsiElecForm.tsx` `planDateOptions` + `applyPlanDate` |  | 구현 |
| D00-1-010 | §1 PlanDate / LayoutControlItem | `GlobalPsiElecForm.tsx` `LABEL.PLAN_DATE` (FormItem label) |  | 구현 |
| D00-1-011 | §1 dCalendar / UsrDateRangePicker3 | `GlobalPsiElecForm.tsx` `PeriodField` (from~to) |  | 구현 |
| D00-1-012 | §1 layoutControlItem14 / LayoutControlItem | `GlobalPsiElecForm.tsx` `LABEL.PERIOD` (PeriodField label) |  | 구현 |
| D00-1-013 | §1 cboBucketType / UsrCombo | `GlobalPsiElecForm.tsx` `bucketOptions` (single CustomDropdown) |  | 구현 |
| D00-1-014 | §1 lblBucket / LayoutControlItem | `GlobalPsiElecForm.tsx` `LABEL.BUCKET` (FormItem label) |  | 구현 |
| D00-1-015 | §1 chkSum / UsrCheckBox |  | AS-IS Visible=false 미노출(기본 off) — SUM 컬럼 추가표시 없이 활성버킷 접두만(design 03 §2.2). 별도 체크박스 컨트롤 미도입 = AS-IS 패리티 | 해당없음 |
| D00-1-016 | §1 layoutControlItem9 / LayoutControlItem |  | chkSum(#015) 라벨 슬롯 — chkSum 미노출이라 라벨도 없음 | 해당없음 |
| D00-1-017 | §1 layoutControlGroup2 / LayoutControlGroup | `GlobalPsiElecForm.tsx` `SearchArea` (조회영역 컨테이너) |  | 구현 |
| D00-1-018 | §1 usrLayoutControl2 / UsrLayoutControl | `GlobalPsiElecForm.tsx` `SearchArea` (조회영역 레이아웃) |  | 구현 |
| D00-1-019 | §1 usrConditionPanel1 / UsrConditionPanel | `GlobalPsiElecForm.tsx` `SearchArea` conditions |  | 구현 |
| D00-1-020 | §1 spdMain / FpSpread | `GlobalPsiElecGrid.tsx` `DataGrid` (공용 그리드) |  | 구현 |
| D00-1-021 | §1 spdMain_Sheet1 / SheetView | `GlobalPsiElecGrid.tsx` `DataGrid` itemsSource (단일 시트) |  | 구현 |
| D00-1-022 | §1 components / Container |  | WinForms Designer 컨테이너(런타임 컴포넌트 트레이) — React 무대응 | 해당없음 |
| D00-1-023 | §1 imageList1 / ImageList |  | WinForms 이미지 리소스 컨테이너 — React 아이콘(@shared/lges-icons)로 대체, 별도 리스트 불요 | 해당없음 |
| D00-1-024 | §1 emptySpaceItem1 / EmptySpaceItem |  | DevExpress LayoutControl 여백 정렬 요소 — CSS/Grid 레이아웃이 대신 처리 | 해당없음 |
| D00-1-025 | §1 emptySpaceItem2 / EmptySpaceItem |  | LayoutControl 여백 요소 — CSS/Grid 레이아웃 대체 | 해당없음 |
| D00-1-026 | §1 emptySpaceItem3 / EmptySpaceItem |  | LayoutControl 여백 요소 — CSS/Grid 레이아웃 대체 | 해당없음 |
| D00-1-027 | §1 emptySpaceItem6 / EmptySpaceItem |  | LayoutControl 여백 요소 — CSS/Grid 레이아웃 대체 | 해당없음 |
| D00-1-028 | §1 emptySpaceItem18 / EmptySpaceItem |  | LayoutControl 여백 요소 — CSS/Grid 레이아웃 대체 | 해당없음 |
| D00-1-029 | §1 emptySpaceItem19 / EmptySpaceItem |  | LayoutControl 여백 요소 — CSS/Grid 레이아웃 대체 | 해당없음 |
| D00-1-030 | §1 emptySpaceItem20 / EmptySpaceItem |  | LayoutControl 여백 요소 — CSS/Grid 레이아웃 대체 | 해당없음 |
| D00-1-031 | §1 emptySpaceItem21 / EmptySpaceItem |  | LayoutControl 여백 요소 — CSS/Grid 레이아웃 대체 | 해당없음 |
| D00-1-032 | §1 usrButton1 / UsrButton |  | DEAD — 어떤 컨테이너에도 미부모화(Designer), 이벤트 미배선(§3 dead 판정) — 미이관 | 제외 |
| D00-1-033 | §1 usrCheckBox1 / UsrCheckBox |  | DEAD/hidden — Visible=false + 이벤트 미배선(chkSum 중복명, §3 dead 판정) — 미이관 | 제외 |
| D00-2-001 | §2 cboDivision / SelectedIndexChanged | `useGlobalPsiElecStore.ts` `setDivision` (Company/PlanDate/Item 리셋 + Grid clear) |  | 구현 |
| D00-2-002 | §2 cboPlanDate / SelectedIndexChanged | `GlobalPsiElecForm.tsx` `applyPlanDate` (Period W52 재계산) |  | 구현 |
| D00-2-003 | §2 cboBucketType / SelectedIndexChanged | `utils/globalPsiElecColumns.ts` `isColVisibleForBucket` (D_/W_/M_ 토글) |  | 구현 |
| D00-2-004 | §2 chkSum / CheckedChanged |  | AS-IS chkSum Visible=false 미노출(기본 off) — SUM 토글 컨트롤 미도입, 활성버킷 접두만(design 03 §2.2) | 해당없음 |
| D00-2-005 | §2 btnItem_Id / Click | `GlobalPsiElec.tsx` `setOpenModelPopup` → `ElecMaterialPopup` onSelect |  | 구현 |
| D00-2-006 | §2 spdMain / CellDoubleClick | `GlobalPsiElec.tsx` `handleCellDblClick` (3중 가드 + navigate SCP0013) |  | 구현 |
| D00-2-007 | §2 spdMain / TopChange | `GlobalPsiElecGrid.tsx` `DataGrid` allowMerging=All (sticky 재병합 공용 래퍼) |  | 구현 |
| D00-3-001 | §3 SmartColMerge / 컬럼 병합 | `GlobalPsiElecGrid.tsx` allowMerging=`AllowMerging.All` (세로병합) |  | 구현 |
| D00-3-002 | §3 SetReNumerCellType / 숫자 셀타입(음수허용,소수0) | `utils/globalPsiElecColumns.ts` `buildPivotColumns` leaf `format:'n0'` |  | 구현 |
| D00-3-003 | §3 SetReNumerCellType / 숫자 셀타입 | `utils/globalPsiElecColumns.ts` `buildPivotColumns` leaf `format:'n0'` |  | 구현 |
| D00-3-004 | §3 ForeColor= / 헤더 요일색(토=Blue/일=Red) | `GlobalPsiElecGrid.tsx` `weekdayOf` (formatItem ColumnHeader) |  | 구현 |
| D00-3-005 | §3 ColumnHeaderSpan / Large 헤더 span (0단) | `utils/globalPsiElecColumns.ts` `buildPivotColumns` largeGroup(월) |  | 구현 |
| D00-3-006 | §3 ColumnHeaderSpan / SUM span (1단) | `utils/globalPsiElecColumns.ts` `buildPivotColumns` (SUM 소계는 캘린더 SP 라벨) |  | 구현 |
| D00-3-007 | §3 ColumnHeaderSpan / Small 헤더 span (1단) | `utils/globalPsiElecColumns.ts` `buildPivotColumns` smallGroup(주) |  | 구현 |
| D00-3-008 | §3 ColumnHeaderSpan / SUM span (2단) | `utils/globalPsiElecColumns.ts` `buildPivotColumns` (SUM = SP 라벨) |  | 구현 |
| D00-3-009 | §3 ColumnHeaderSpan / Small 헤더 span | `utils/globalPsiElecColumns.ts` `buildPivotColumns` smallGroup |  | 구현 |
| D00-3-010 | §3 ColumnHeaderSpan / SUM span | `utils/globalPsiElecColumns.ts` `buildPivotColumns` (SUM = SP 라벨) |  | 구현 |
| D00-3-011 | §3 ColumnHeaderSpan / Small 헤더 span | `utils/globalPsiElecColumns.ts` `buildPivotColumns` smallGroup |  | 구현 |
| D00-3-012 | §3 ColumnHeaderSpan / SUM span | `utils/globalPsiElecColumns.ts` `buildPivotColumns` (SUM = SP 라벨) |  | 구현 |
| D00-3-013 | §3 ColumnHeaderSpan / Large 헤더 span | `utils/globalPsiElecColumns.ts` `buildPivotColumns` largeGroup |  | 구현 |
| D00-3-014 | §3 ColumnHeaderSpan / SUM span | `utils/globalPsiElecColumns.ts` `buildPivotColumns` (SUM = SP 라벨) |  | 구현 |
| D00-3-015 | §3 SmartColMerge / 컬럼 병합 | `GlobalPsiElecGrid.tsx` allowMerging=`AllowMerging.All` |  | 구현 |
| D00-3-016 | §3 Query / 조회결과 바인딩(ds) | `GlobalPsiElec.tsx` `mainQuery` (useTabProcQuery) → `GlobalPsiElecGrid.tsx` itemsSource |  | 구현 |
| D00-3-017 | §3 LockColumn / 전 컬럼 잠금(0..max, true) — 순수 조회화면 | `GlobalPsiElecGrid.tsx` `isReadOnly` + 메타 INPUT_TP_CD='S' |  | 구현 |
| D00-3-018 | §3 SmartColMerge / 컬럼 병합 | `GlobalPsiElecGrid.tsx` allowMerging=`AllowMerging.All` |  | 구현 |
| D00-3-019 | §3 SetBGColor / Measure 음영 #DAEEF3 | `GlobalPsiElecGrid.tsx` `CONDITIONAL_BG` P_SUM (formatItem) |  | 구현 |
| D00-3-020 | §3 SetBGColor / Measure 음영 #E0F3B0 | `GlobalPsiElecGrid.tsx` `CONDITIONAL_BG` S_SUM (formatItem) |  | 구현 |
| D00-3-021 | §3 SetBGColor / Measure 음영 #FEEBC9 | `GlobalPsiElecGrid.tsx` `CONDITIONAL_BG` I_EOH (formatItem) |  | 구현 |
| D00-3-022 | §3 Visible= / Daily: D_/W_ 표시 | `utils/globalPsiElecColumns.ts` `isColVisibleForBucket` (DAILY→D_) |  | 구현 |
| D00-3-023 | §3 Visible= / Daily: M_/W_ = chkSum | `utils/globalPsiElecColumns.ts` `isColVisibleForBucket` (chkSum off → 활성버킷 접두만) |  | 구현 |
| D00-3-024 | §3 Visible= / Weekly: D_ 숨김 | `utils/globalPsiElecColumns.ts` `isColVisibleForBucket` (WEEKLY→D_ 제외) |  | 구현 |
| D00-3-025 | §3 Visible= / Weekly: W_ 표시 | `utils/globalPsiElecColumns.ts` `isColVisibleForBucket` (WEEKLY→W_) |  | 구현 |
| D00-3-026 | §3 Visible= / Weekly: M_ = chkSum | `utils/globalPsiElecColumns.ts` `isColVisibleForBucket` (chkSum off → M_ 미표시) |  | 구현 |
| D00-3-027 | §3 Visible= / Monthly: D_/W_ 숨김 | `utils/globalPsiElecColumns.ts` `isColVisibleForBucket` (MONTHLY→D_/W_ 제외) |  | 구현 |
| D00-3-028 | §3 Visible= / Monthly: 그 외 표시 | `utils/globalPsiElecColumns.ts` `isColVisibleForBucket` (MONTHLY→M_) |  | 구현 |
| D00-3-029 | §3 GetValue2 / 셀값 read(getCellValue) | `GlobalPsiElec.tsx` `handleCellDblClick` → `GridUtils.getRow` |  | 구현 |
| D00-4b-001 | §4b BLUtils.GetDivisionEE / false / dtDivision | `GlobalPsiElecForm.tsx` `COMBO.DIVISION`(Division_SCP) + `DIVISION_EE_INCLUDE` (ATTRIBUTE3='EE' FE 필터) |  | 구현 |
| D00-4b-002 | §4b Data.Common / COMPANY_EE / dtCompany | `GlobalPsiElecForm.tsx` `COMBO.COMPANY`(COMPANY_EE, 다중) |  | 구현 |
| D00-4b-003 | §4b Data.Common / DATE_WEEKLY / dtPlanDate | `GlobalPsiElecForm.tsx` `COMBO.PLAN_DATE`(DATE_WEEKLY, @divisionId cascade) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) |  | 순수 조회(read-only) 화면 — Insert 없음(전열 INPUT_TP_CD='S', hotkeyConfig.insert=false). 신규행 추가 경로 자체가 없어 해당 축 무 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) |  | 편집모드/수정 상태 자체가 없음(convert-core §2.4, __asis-mapping__ §5) — 조회만 하므로 '수정 중' 상태 미발생 | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) |  | AS-IS SCP0095 는 measure/컬럼 개인화 UI 부재(자매 SCP0100 과 달리 btnMeasure 없음, §3 measure 표시선택 절) — 표시 measure 는 서버측 SCM_MST_SHEET_MEASURE.VALID_YN='Y' 로 확정. 사용자 컬럼/measure 설정 UI 무 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) |  | CRUD(Insert/Save/Delete) 없음(모두 hotkeyConfig false·미노출) — 완료 토스트 발생 경로 무 | 해당없음 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | `GlobalPsiElec.tsx` `SubTitle` excelFileName='GlobalPsiElec' (공용 Excel — DataGrid dataMap Name 승계) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) |  | 조회조건이 콤보 단일/다중선택·Model 팝업·기간 픽커로 구성 — key-in 자유입력 텍스트 조회조건 없음(Model InputField 는 팝업 반환값). 콤마 key-in 그리드필터 축 무 | 해당없음 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | `GlobalPsiElecGrid.tsx` `DataGrid` gridFilterRef (공용 rebindFilterColumns) |  | 구현 |

## 1. 조회조건 (events / comboCalls) — design 02

| AS-IS | line | TO-BE | 비고 |
|---|---|---|---|
| `dtDivision = BLUtils.GetDivisionEE(false)` (Division_SCP + RowFilter ATTRIBUTE3='EE') | cs L43 | `useTabComboQueries([Division_SCP])` + FE `row.ATTRIBUTE3==='EE'` 필터, **단일선택**(iter-3 A2) | Option B(좁히는 주체 FE 하나). Division_SCP 가 ATTRIBUTE3 반환(no-op 아님). Division_SCP_NoEE/MyDivisionInEE_SCP 재사용 금지. **allOption 미추가**(A1) — isAddALL=false |
| `Data.Common(Type.COMPANY_EE,false)` | cs L314 | `useTabComboQueries([COMPANY_EE])` 정적, **다중선택**(콤마조인) | 값=COMPANY_NAME(CODE)/표시=COMPANY_ID(NAME). division cascade 아님(파라미터 0 실측). **allOption 미추가**(A1) — 미선택('')은 SP 가 전체로 우회 |
| `Data.Common(Type.DATE_WEEKLY,false,_division)` | cs L317 | `useTabComboQueries([{comboId:DATE_WEEKLY, divisionId}])` | 토큰 @divisionId 정확히. division 종속 재조회 cascade |
| `GetBucketType()` FoxDataRequest(DM0003) | cs L306/321 | 정적 select(DAILY/WEEKLY/MONTHLY) | 값 고정 3종·조회 파라미터 아님(pivot 토글) → SP 왕복 불요(자매 global-psi-report 동일). 기본 WEEKLY(cs L282) |
| `dCalendar.InitValue=GetDayRange("52")` | cs L309/464 | 공용 `PeriodField`(from~to) + W52 기본(from=planDate, to=planDate+363일) | iter-2: 텍스트 2입력 → 공용 PeriodField 로 교체(캘린더 스냅/경계 검증 내장, gap-audit G5). 기본값은 AS-IS 산식(52*7-1) 재현 유지. SP(P_SCM0001_GET_SCP_DAY_PERIOD) 초기값 대체는 확인필요 A |
| `SetChangedControl()` (Div→Company/PlanDate 재적재) | cs L456~460 | `setDivision` cascade 초기화 + 그리드 clear | Company/PlanDate/Item/Period 리셋 |
| cboPlanDate Changed → 기간 재계산 + 그리드 clear | cs L462~466 | `applyPlanDate` (Period 재계산) + Search 게이트 | division/planDate 변경 = 그리드 clear(hook #5) |
| `checkRequired(usrConditionPanel1)` + `Check_PeriodDate` | cs L504~510 | `validateRequired` (Division*/Plan-date*/Period) | 필수값 미충족 시 조회 차단 |

### Division 단일선택 · Company 다중선택 · allOption 제거 — AS-IS SP 실측 결정 (iter-3 A1/A2)

iter-2 gap-audit A1(SELECT ALL 센티널 빈 결과)·A2(Division 다중 vs 등식 SP)를 AS-IS SP 본문 실측으로 확정 해소했다.
`asis.py proc SCP0095_GET_GLOBAL_PSI_ELEC`(MSSQL, 2026-09-26) 메인 데이터 WHERE(L242~245):

```sql
AND A.DIVISION_ID = @p_division_id                                              -- 단일 등식(STRING_SPLIT 없음)
AND ((@p_item_id IS NULL OR @p_item_id='') OR A.ELEC_MODEL IN (STRING_SPLIT(@p_item_id,',')))  -- 다중
AND ((@p_company IS NULL OR @p_company='') OR A.COMPANY_ID IN (STRING_SPLIT(@p_company,',')))    -- 다중
```
(L215 최신버전 조회도 `AND DIVISION_ID = @p_division_id` 동일 등식.)

- **A2 결정 = Division 단일선택**: AS-IS SP 가 division 을 `= @p_division_id`(단일 등식)으로만 받는다 — STRING_SPLIT 없음.
  AS-IS UsrCombo 는 체크형이나 SP 계약이 등식이라 **다중선택은 AS-IS 에서도 빈 결과**(latent). TO-BE PKG_SCP0095 도
  `DIVISION_ID = UPPER(P_DIVISION_ID)`(등식, ora.py 실측), DATE_WEEKLY cascade 도 `A.division_id = @divisionId`(등식).
  → FE 단일선택이 등식 SP 계약과 정합하며 regression-zero. multi→single 전환은 FE 자기폴더 한정(Hard Boundary 내).
  design 02 의 "다중" 표기는 UI 컨트롤 종류 기준이었고 실제 데이터 계약(SP 등식)과 어긋났다 — SP 실측을 정본으로 채택.
  다중 division 이 업무상 필요하면 SP/CMBO 를 IN-list 로 바꾸는 convert-sp 소관(Hard Boundary 밖) — 사용자 결정 시 재개.
- **Company 다중선택 유지**: AS-IS SP 가 company 를 `IN (STRING_SPLIT(@p_company,','))` 로 받는다 → 콤마조인 다중 정합.
  Model(ELEC_MODEL)도 동일 IN 이나 이 화면은 팝업 단일 반환.
- **A1 = allOption 제거(Division/Company)**: AS-IS `isAddALL=false`. 'ALL' 센티널은 등식(division)·IN(company) 어느 쪽도
  매치 0 → 빈 그리드(memory `scp0020-all-sentinel-vs-null-filter-empty-grid`). Company 미선택('')은 SP `@p_company=''`
  우회로 전체 조회(AS-IS 동일). Division 은 필수(*)라 미선택 시 validateRequired 가 차단.

## 2. 팝업 (popups) — design 02 §4.6

| AS-IS | line | TO-BE | 비고 |
|---|---|---|---|
| `SCM0002_ItembyDivisionPopupEE` (btnItem_Id) | cs L450, L760~776 | `ElecMaterialPopup`(선작성) | 확인필요 #6 확정 — 전극 전용(division 81,82,40 내부 고정)이 AS-IS EE 변형과 1:1. design 권장 ItemByDivisionModal 대신 채택(중복 방지). 반환 ItemID→itemId, 취소 시 기존값 유지 |

## 3. 그리드 (gridSignals 29 + 백본 밖 3) — design 03

| # | AS-IS (line) | 구현 위치 (TO-BE) | 비고 | 상태 |
|---|---|---|---|:--:|
| R1/R18 | SmartColMerge (세로병합) (359/536) | `AllowMerging.All` | 반복 키칼럼 세로병합 | 구현 |
| R3 | 기간칼럼 SetReNumerCellType(정수) (402) | pivot leaf `format:'n0'` | 기본 정수 | 구현 |
| R4 | 3단(일)헤더 요일색 SAT=Blue/SUN=Red (406) | grid formatItem `weekdayOf` | D_YYYYMMDD 로컬 Date 파싱(DAY_CODE 미의존) | 구현 |
| R5~R14 | ColumnHeaderSpan (월/주 + SUM) (413~442) | `buildPivotColumns` 2단 그룹(large/small) | SUM 소계 헤더는 캘린더 SP 라벨로 표현(별도 리터럴 생성 안 함) | 구현 |
| R15 | 스크롤 재병합 (470) | DataGrid wrapper sticky 병합 | hook #69 | 구현 |
| R16 | AfterFindData 바인딩 (523) | React Query rows → DataGrid | mainQuery.o_rc1 → itemsSource | 구현 |
| R17 | LockColumn(0,max,true) 전열잠금 (525) | `isReadOnly` + 메타 INPUT_TP_CD='S' | 순수 조회 | 구현 |
| R19 | PSI='P'&SUM → #DAEEF3 (599) | formatItem `CONDITIONAL_BG` P_SUM (col4~끝) | 조건부 배경 | 구현 |
| R20 | PSI='S'&SUM → #E0F3B0 (612) | formatItem `CONDITIONAL_BG` S_SUM (col4~끝) | 조건부 배경 | 구현 |
| R21 | PSI='I'&EOH → #FEEBC9 (625) | formatItem `CONDITIONAL_BG` I_EOH (col4~끝) | 조건부 배경 | 구현 |
| R22~R28 | Bucket×chkSum Visible 토글 (718~755) | `isColVisibleForBucket` (D_/W_/M_) | chkSum off·미노출 → 활성 버킷 접두만 | 구현 |
| R29 | getCellValue (드릴다운 셀 read) (791) | `GridUtils.getRow` | 드릴다운 행 read | 구현 |
| R30 | Yield_A/Yield_E 소수 2자리 (639~651) | formatItem `DECIMAL2_MEASURES` 셀 | 그 외 정수 | 구현 |
| drilldown | spdMain_CellDoubleClick 3중 가드 → SCP0013 | 825~850 | `handleCellDblClick` 3가드 + navigate('/view/SCP0013') | 5조건 파라미터 포워딩 경로 부재 → 화면만 오픈(확인필요) |

### dead 판정 (조용한 제외 금지 — convert-core §2.1 #11)

| 대상 | 근거 | 판정 |
|---|---|---|
| usrButton1 (#32) | 어떤 컨테이너에도 `.Controls.Add` 안 됨(Designer) | DEAD 미부모화 — 미이관 |
| usrCheckBox1 (#33, chkSum 중복명) | Visible=false + 이벤트 미배선 | DEAD/hidden — 미이관 |
| bChgDiv 플래그 (cs L64/459) | 세팅만·소비처 없음 | DEAD — 미이관 |
| B_ 접두 칼럼 분기 (R2, cs L394~398) | 헤더/메인 SP 가 B_ 미산출 | 사문(dead) — 미처리 |
| Set_MeasureColor (R31, cs L680~683) | 빈 몸체(no-op) | DEAD — 미이관 |
| Set_SumValues (R32, cs L658~678) | 수집만·미사용 | DEAD — 미이관 |

### Org.Div 컬럼(ORG_DIVISION_ID) 공백 — AS-IS 패리티 확정 (iter-2 gap-audit G1)

메타 `SCM_MST_SHEET_COLUMNS` 는 AS-IS·TO-BE 둘 다 COLUMN_NAME=`ORG_DIVISION_ID`(라벨 Org.Div, VISIBLE=Y)로
동일하나, AS-IS SP `SCP0095_GET_GLOBAL_PSI_ELEC` 최종 SELECT(asis.py 실측)는 `DIVISION_ID` 만 반환하고
AS-IS `.cs` 에도 이 컬럼 rebind 가 없다(grep 0) → **AS-IS 에서도 Org.Div 는 공백**(Original Division 기능이 메타·SP 에
반쪽만 반영된 latent 결함). TO-BE 는 메타·SP 를 AS-IS 그대로 미러하므로 동일 상태 = 규격 패리티(regression-zero).
메타를 DIVISION_ID 로 바꾸는 것은 AS-IS 충실 복사에서 이탈하는 추측 매핑이라 금지(convert-core §2.3) — 미변경.
원의도(Original Division 표시) 복구는 SP 가 `DIVISION_ID AS ORG_DIVISION_ID` 별칭 반환하도록 고치는 convert-sp/기획
결정 사항.

### measure 표시선택 — 미배선(AS-IS 무, iter-2 gap-audit G6)

AS-IS SCP0095 는 measure 표시선택 컨트롤(자매 SCP0100 의 btnMeasure/MeasureSelectModal 같은 것)이 없다.
표시 measure 는 메인 SP 가 서버측에서 `SCM_MST_SHEET_MEASURE.VALID_YN='Y'` + 사용자 titleset 으로 확정한다
(AS-IS SP L120~131 실측). 따라서 FE 는 measure 메타를 fetch 하지 않는다 — iter-1 이 넣었던
`fetchStaticMeasures`/`staticMeasures` 는 소비처 0 인 dead wiring 이라 제거(convert-core §4.2). 그리드 컬럼 메타
(`fetchStaticColumns`)만 admin 동적 fetch 로 유지.

## 4. 버튼(toolbarOverride) — design 01 §4d

| AS-IS override | line | 본문 | DB 버튼메타 | TO-BE |
|---|---|---|---|---|
| FindButton | cs L477~480 | 실동작 FindData | SEARCH 등록(Y) | `hotkeyConfig.search=handleSearch` |
| EditButton | cs L482~484 | NO-OP `{ }` | 미등록 | 미노출(hasButton=false) + hotkeyConfig 미배선 |
| SaveButton | cs L486~488 | NO-OP | 미등록 | `hotkeyConfig.save=false` (공용 저장핸들러 부활 차단) |
| InsertButton | cs L490~492 | NO-OP | 미등록 | `hotkeyConfig.insert=false` (공용 addRow 부활 차단) |
| DeleteButton | cs L494~496 | NO-OP | 미등록 | `hotkeyConfig.delete=false` (공용 removeRow 부활 차단) |

### hotkeyConfig false 사용 근거 (skill §3 예외)

skill §3 기본값은 NO-OP 버튼에 `() => undefined` 이나, SCP0095 는 DB 버튼메타(SCM_ADM_MNU_BTN_MPG_M)가
Edit/Save/Insert/Delete 를 **미등록**으로 확정(design 01 §4d ora.py 실측) → hasButton=false 로 렌더 자체가 안 되는
"미노출"이 정본 재현(design 01 §5 #3 화면 결정). 이는 skill §3 의 "화면별 별도로 숨기기로 확정된 경우 예외 false 허용"에
해당한다. false 는 공용 SubTitle 기본 addRow/removeRow 부활도 함께 차단한다.

## 5. editMode 미이식 판정 (convert-core §2.4)

AS-IS 는 조회 후 전열 잠금(read-only) 순수조회 화면이라 편집모드 토글 자체가 없다. TO-BE 도
`editMode`/`setEditMode` state 를 만들지 않는다(self-check grep `editMode|setEditMode` 0 hit). 전열 read-only 는
컬럼 속성(메타 INPUT_TP_CD='S') + DataGrid `isReadOnly` 로만 표현. 권한 게이트는 조회영역 활성 여부(권한 division 0건
방어)로만 둔다.

## 6. 제목 (design 01 §5 #4)

AS-IS `Form.Text="Shipment Request"`(Designer L782)는 복붙 오기 — 재현 금지. TO-BE 는 `title`(메뉴 등록명/i18n
= Global PSI Elec) 그대로 사용(PageProps.title).
