# __asis-mapping__.md — EID 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `DMF0021_SalesPlan_주요이벤트_상세분석.md`, `DMF0021_SalesPlan_제약매트릭스_상세.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (EID 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| E01 | §1 Dsdm_Changed — 셀 값 변경 (Dsdm_Changed, L3958~L4125) | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:781~818 (cellEditEndedHandler — MEASURE 빈행 롤백/EditTracker Red) |  | 구현 |
| E02 | §2 spdMain_LeaveCell — 셀 이탈 시 포맷/음수 차단 (spdMain_LeaveCell, L4362~L4438) | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:792~806 (RTF 음수 RMA예외·정수절삭 / LOC 소수3) + features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:101~112 (formatByNotation) |  | 구현 |
| E03 | §3 EditButton (F2) — 편집모드 진입 (EditButton override, L687~L1123) | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (evalSalesPlanDynCell — TO-BE 상시편집: F2 진입 없이 셀 단위 동등 판정) |  | 구현 |
| E04 | §4 SaveData (F7) — 저장 (SaveButton L1125~1128 → SaveData, L1940~L2863) | features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:99~213 (buildUnfoldRows/buildSavePayload 18키) + features/demand/src/pages/sales-plan/SalesPlan.tsx (handleSave) |  | 구현 |
| E05 | §5 InsertRow (F8) — 신규 행 (InsertButton L674~677 → InsertRow, L2866~L3366) | features/demand/src/pages/sales-plan/SalesPlan.tsx:224~ (handleInsert) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5) |  | 구현 |
| E06 | §6 spdMain_ComboSelChange — 행 내 콤보 cascade 6키 (spdMain_ComboSelChange, L4530~L5122) | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:719~730 (cascade dataMap 스왑) + features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:842~852 (계단 clear) + features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts:45~71 |  | 구현 |
| E07 | §7 FindData (F5) — 조회 (FindButton L669~672 → FindData L1465~L1650, Draw L1652~L1938) | features/demand/src/pages/sales-plan/useSalesPlanStore.ts:221~ (fetch 17 IN + 커서3) + features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:27~59 (validateFind) |  | 구현 |
| E08 | §8 spdMain_CellDoubleClick / ClipboardPasted (L3789~L3956 / L5616~L5640) | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:856~927 (pastedCellHandler + dblclickHandler 드릴·모달) + features/demand/src/pages/sales-plan/components/SalesPlanModals.tsx |  | 구현 |
| CA-101 | §1.1 [원문 무번호] InitControls / `sDivision == "40"` | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx:286·319~350 (40: PlantSite disabled·Project 비활성) |  | 구현 |
| CA-102 | §1.1 [원문 무번호] clbDivision_SelectedIndexChanged / `sDivision == "40"` | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx:182~195 (Division 변경 — 하위 조건 클리어·재조회) + features/demand/src/pages/sales-plan/useSalesPlanStore.ts (setSearchCondition) |  | 구현 |
| CA-103 | §1.1 [원문 무번호] clbTeam_SelectedIndexChanged / `Substring(0,2)=="81" \ | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx:204~207 (TeamField cascade — endCustomers/scmSiteIds 클리어) |  | 구현 |
| CA-104 | §1.1 [원문 무번호] btnProject_Click / `Substring(0,2)=="81" \ | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx:345~350 (ProjectField — 40 비활성 = 팝업 미호출) |  | 구현 |
| CA-105 | §1.2 [원문 무번호] EditButton / `!= "40" && PROJECT_CODE == -1` |  | TO-BE 상시편집 — F2 편집모드 진입 게이트 부재. 컬럼 존재 = SHEET_COLUMNS division 스코프 메타가 보장(hook #113) | 해당없음 |
| CA-106 | §1.2 [원문 무번호] EditButton / `== "40" && END_CUSTOMER40 == -1` |  | TO-BE 상시편집 — F2 편집모드 진입 게이트 부재. 컬럼 존재 = SHEET_COLUMNS division 스코프 메타가 보장(hook #113) | 해당없음 |
| CA-107 | §1.2 [원문 무번호] EditButton / `!= "40" && END_CUSTOMER == -1` |  | TO-BE 상시편집 — F2 편집모드 진입 게이트 부재. 컬럼 존재 = SHEET_COLUMNS division 스코프 메타가 보장(hook #113) | 해당없음 |
| CA-108 | §1.2 [원문 무번호] EditButton / `Substring(0,2)=="81" && TEXT == -1` |  | TO-BE 상시편집 — F2 편집모드 진입 게이트 부재. 컬럼 존재 = SHEET_COLUMNS division 스코프 메타가 보장(hook #113) | 해당없음 |
| CA-109 | §1.2 [원문 무번호] EditButton / `== "40" && DEPT_ID == -1` |  | TO-BE 상시편집 — F2 편집모드 진입 게이트 부재. 컬럼 존재 = SHEET_COLUMNS division 스코프 메타가 보장(hook #113) | 해당없음 |
| CA-110 | §1.2 [원문 무번호] EditButton / `== "40" && CELL_PROD_SITE_ID == -1` |  | TO-BE 상시편집 — F2 편집모드 진입 게이트 부재. 컬럼 존재 = SHEET_COLUMNS division 스코프 메타가 보장(hook #113) | 해당없음 |
| CA-111 | §1.2 [원문 무번호] EditButton ⭐E20260512 / `Substring(0,2)=="81" && FROM_SITE_ID == -1` | features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:81~93 (81 FROM_SITE_ID/PLANT_SITE_ID 컬럼 존재 체크 — MSG00113) |  | 구현 |
| CA-112 | §1.2 [원문 무번호] EditButton ⭐E20260512 / `Substring(0,2)=="81" && PLANT_SITE_ID == -1` | features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:81~93 (81 FROM_SITE_ID/PLANT_SITE_ID 컬럼 존재 체크 — MSG00113) |  | 구현 |
| CA-113 | §1.2 [원문 무번호] EditButton (실패 메시지) / `== "40" && DEPT_ID == -1` |  | TO-BE 상시편집 — F2 편집모드 진입 게이트 부재. 컬럼 존재 = SHEET_COLUMNS division 스코프 메타가 보장(hook #113) | 해당없음 |
| CA-114 | §1.2 [원문 무번호] EditButton (실패 메시지) / `== "40" && CELL_PROD_SITE_ID == -1` |  | TO-BE 상시편집 — F2 편집모드 진입 게이트 부재. 컬럼 존재 = SHEET_COLUMNS division 스코프 메타가 보장(hook #113) | 해당없음 |
| CA-115 | §1.3 [원문 무번호] EditButton (M_ 편집대상 수집) ⭐E20250520-000605 / `clbDivision.SelectedValue.Subs… | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~148 (R3 — M_ 40=당월포함(≥)/비40=익월(＞)) |  | 구현 |
| CA-116 | §1.3 [원문 무번호] EditButton (W_ 편집대상 수집) / 공통 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:150~157 (W_ 당주부터 ≥) |  | 구현 |
| CA-117 | §1.3 [원문 무번호] EditButton (40 Weekly CLEAR) / `Substring(0,2)=="40" && i_EditStartCol>0 &&… |  | Monthly↔Weekly 상호배제 유지(R2) — 40 Monthly 중 과거 W_ CLEAR 특례는 Weekly 버킷 전환 + 0값 저장('D' 전환)으로 동일 목적 달성(경로 대체) | 제외 |
| CA-118 | §1.3 [원문 무번호] EditButton (행별 편집 허용) / `row DIVISION_ID=="40" && MEASURE=="Catch_Up"` | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:127 (Catch_Up = 40 전용) |  | 구현 |
| CA-119 | §1.3 [원문 무번호] EditButton ⭐E20260331 / `(row DIVISION_ID=="40" \ | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:123~133 (measureGate — E20260331 81 확장 + ETC 한정) |  | 구현 |
| CA-120 | §1.4 [원문 무번호] SaveData 필수컬럼 / `!= "40" && PROJECT_CODE==-1` |  | TO-BE 상시편집 — F2 편집모드 진입 게이트 부재. 컬럼 존재 = SHEET_COLUMNS division 스코프 메타가 보장(hook #113) | 해당없음 |
| CA-121 | §1.4 [원문 무번호] SaveData 필수컬럼 / `== "40" && END_CUSTOMER40==-1` |  | TO-BE 상시편집 — F2 편집모드 진입 게이트 부재. 컬럼 존재 = SHEET_COLUMNS division 스코프 메타가 보장(hook #113) | 해당없음 |
| CA-122 | §1.4 [원문 무번호] SaveData 필수컬럼 / `!= "40" && END_CUSTOMER==-1` |  | TO-BE 상시편집 — F2 편집모드 진입 게이트 부재. 컬럼 존재 = SHEET_COLUMNS division 스코프 메타가 보장(hook #113) | 해당없음 |
| CA-123 | §1.4 [원문 무번호] SaveData 필수컬럼 / `Substring(0,2)=="81" && TEXT==-1` |  | TO-BE 상시편집 — F2 편집모드 진입 게이트 부재. 컬럼 존재 = SHEET_COLUMNS division 스코프 메타가 보장(hook #113) | 해당없음 |
| CA-124 | §1.4 [원문 무번호] SaveData 필수컬럼 / `== "40" && DEPT_ID==-1` |  | TO-BE 상시편집 — F2 편집모드 진입 게이트 부재. 컬럼 존재 = SHEET_COLUMNS division 스코프 메타가 보장(hook #113) | 해당없음 |
| CA-125 | §1.4 [원문 무번호] SaveData 필수컬럼 / `== "40" && CELL_PROD_SITE_ID==-1` |  | TO-BE 상시편집 — F2 편집모드 진입 게이트 부재. 컬럼 존재 = SHEET_COLUMNS division 스코프 메타가 보장(hook #113) | 해당없음 |
| CA-126 | §1.4 [원문 무번호] SaveData 필수컬럼 ⭐E20260512 / `Substring(0,2)=="81" && FROM_SITE_ID==-1` | features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:81~93 (81 FROM/PLANT 컬럼 체크) |  | 구현 |
| CA-127 | §1.4 [원문 무번호] SaveData 필수컬럼 ⭐E20260512 / `Substring(0,2)=="81" && PLANT_SITE_ID==-1` | features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:81~93 (81 FROM/PLANT 컬럼 체크) |  | 구현 |
| CA-128 | §1.4 [원문 무번호] SaveData 미실패 시 MSG00113 / 상기 조합 | features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:86~92 (MSG00113 REQUIRED_COLUMN) |  | 구현 |
| CA-129 | §1.4 [원문 무번호] SaveData 행별 필수값 / `sDivisionId==""` → "[Division]" | features/demand/src/pages/sales-plan/utils/sales-plan.division.ts:55~79 (requiredFieldsFor — division×measure 13종) + features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:100~115 |  | 구현 |
| CA-130 | §1.4 [원문 무번호] SaveData 행별 필수값 / `!="40" && sProjectCode==""` → "[Project Code]" | features/demand/src/pages/sales-plan/utils/sales-plan.division.ts:55~79 (requiredFieldsFor — division×measure 13종) + features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:100~115 |  | 구현 |
| CA-131 | §1.4 [원문 무번호] SaveData 행별 필수값 / `=="40" && sEndCustomer==""` → "[END_CUSTOMER]" | features/demand/src/pages/sales-plan/utils/sales-plan.division.ts:55~79 (requiredFieldsFor — division×measure 13종) + features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:100~115 |  | 구현 |
| CA-132 | §1.4 [원문 무번호] SaveData 행별 필수값 / `=="40" && sDeptId=="" && sMeasure!="Catch_Up"` → "[TEAM]" |  | 통합테스트 1st No.61-④(2026-08-12 사용자 확정) — Team 전 Div 입력 불가 전환으로 필수 해제(입력 불가 컬럼 필수화 = 저장 불능). AS-IS 40 필수는 직접 입력 시절 계약 | 제외 |
| CA-133 | §1.4 [원문 무번호] SaveData 행별 필수값 / `Substring(0,2)=="81" && sText==""` → "[TEXT]" | features/demand/src/pages/sales-plan/utils/sales-plan.division.ts:69~75 (requiredFieldsFor — 81 TEXT = FCST_TYPE='ETC' 행만) | 통합테스트 1st No.59 — RTF 행 오발동 정정(ETC=DM_PLN_SALES_ETC_PLAN 경로 한정) | 구현 |
| CA-134 | §1.4 [원문 무번호] SaveData 행별 필수값 / `=="40" && Catch_Up && sDomExp==""` → "[Customer Handbook… | features/demand/src/pages/sales-plan/utils/sales-plan.division.ts:55~79 (requiredFieldsFor — division×measure 13종) + features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:100~115 |  | 구현 |
| CA-135 | §1.4 [원문 무번호] SaveData 행별 필수값 / `=="40" && Catch_Up && sFcstType==""` → "[FcstType]" | features/demand/src/pages/sales-plan/utils/sales-plan.division.ts:55~79 (requiredFieldsFor — division×measure 13종) + features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:100~115 |  | 구현 |
| CA-136 | §1.4 [원문 무번호] SaveData 행별 필수값 / `=="40" && Catch_Up && sIncoterms==""` → "[INCOTERMS]" | features/demand/src/pages/sales-plan/utils/sales-plan.division.ts:55~79 (requiredFieldsFor — division×measure 13종) + features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:100~115 |  | 구현 |
| CA-137 | §1.4 [원문 무번호] SaveData 행별 필수값 / `=="40" && sCellProdSiteId==""` → "[CellProdSiteID]" | features/demand/src/pages/sales-plan/utils/sales-plan.division.ts:55~79 (requiredFieldsFor — division×measure 13종) + features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:100~115 |  | 구현 |
| CA-138 | §1.4 [원문 무번호] SaveData (공통 무분기) / sScmSiteId/sItemId/sMeasure/sCurrency=="" → 각 라벨 | features/demand/src/pages/sales-plan/utils/sales-plan.division.ts:55~79 (requiredFieldsFor — division×measure 13종) + features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:100~115 |  | 구현 |
| CA-139 | §1.4 [원문 무번호] SaveData 실패 메시지 / MSG00002(sMsg) + 포커스 (i,2) 이동 | features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:107~112 (MSG00429 {0} + 행번호 병기) |  | 구현 |
| CA-140 | §1.4 [원문 무번호] SaveData 키 대체 / `sDivisionId != "40"`: PROJECT_CODE 사용, ""→"N" / else(40): … | features/demand/src/pages/sales-plan/utils/sales-plan.division.ts:32~33 (readProjectSlot — 40=END_CUSTOMER40) |  | 구현 |
| CA-141 | §1.4 [원문 무번호] SaveData TEXT 소스 / `sDivisionId.Substring(0,2)=="81"`: TEXT / else: TEXT4082 | features/demand/src/pages/sales-plan/utils/sales-plan.division.ts:36~37 (readTextSlot — 81=TEXT/그외 TEXT4082) |  | 구현 |
| CA-142 | §1.4 [원문 무번호] SaveData Catch_Up 음수 / `sDivisionId=="40" && sMeasure=="Catch_Up" && sPrice… | features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:121~124 (Catch_Up 음수 MSG00085) |  | 구현 |
| CA-143 | §1.4 [원문 무번호] SaveData FROM_SITE_ID ⭐E20260512 / `FROM_SITE_ID 컬럼 존재 시` sCellProdSiteId ←… | features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:87~90 (cellProdSiteId — 81=FROM_SITE_ID 덮어씀) |  | 구현 |
| CA-144 | §1.5 [원문 무번호] InsertRow / `sDivision=="40" && DEPT_ID 존재` |  | 통합테스트 1st No.61-④ — Team 전 Div 입력 불가(마스터 파생 표시). AS-IS 40 dtTeamAuth 콤보 개방을 뒤집는 사용자 명시 요구 | 제외 |
| CA-145 | §1.5 [원문 무번호] InsertRow / `sDivision != "40"` | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:193~194 (MEASURE = 40 만 개방) |  | 구현 |
| CA-146 | §1.5 [원문 무번호] InsertRow 기간 잠금 (작월 조회) / `Substring(0,2)=="40"` | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~148 (R3 기간 잠금 — Insert 행 동일 엔진) |  | 구현 |
| CA-147 | §1.5 [원문 무번호] InsertRow 기간 잠금 (당월~미래 조회) / `Substring(0,2)=="40"` | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~148 (R3 기간 잠금 — Insert 행 동일 엔진) |  | 구현 |
| CA-148 | §1.5 [원문 무번호] InsertRow ITEM_ID 콤보 / `sDivision=="82"` / `Substring(0,2)=="81"` / `=="40"` | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:153~190 (itemByDivision COM0008 — division 필터 드롭다운) |  | 구현 |
| CA-149 | §1.6 [원문 무번호] DIVISION_ID 변경 → PLANT_SITE_ID / `sDivision.Substring(0,2) != "81"` | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:201~212 (PLANT_SITE_ID = 전 Div 잠금 — 2026-09-01 정정. 이 unlock 은 그리드 Division 셀 변경 전용이라 신규행에서 미도달) |  | 구현 |
| CA-150 | §1.6 [원문 무번호] DIVISION_ID 변경 → ITEM_ID 콤보 / 82 / 81 / 40 | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:153~172 (itemByDivision division 파라미터 재조회) |  | 구현 |
| CA-151 | §1.6 [원문 무번호] DIVISION_ID 변경 → 연쇄 클리어 / 공통 | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:842~852 (GRID_CASCADE_CLEAR — 하위 컬럼 연쇄 클리어) |  | 구현 |
| CA-152 | §1.6 [원문 무번호] END_CUSTOMER 변경 → ITEM_ID / 82 / 81 / 40 | features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts:56~67 (SiteByEndCustomer/EndCustomerByDivisionDept) + features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:719~730 |  | 구현 |
| CA-153 | §1.6 [원문 무번호] END_CUSTOMER40 변경 → ITEM_ID / 82 / 81 / 40(+`MEASURE != "Catch_Up"` 조건) | features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts:56~67 + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:187~188 (40+Catch_Up ITEM_ID 모달 전용 — 콤보 미바인딩) |  | 구현 |
| CA-154 | §1.6 [원문 무번호] SCM_SITE_ID 변경 → ITEM_ID / 82 / 81 / 40(+`MEASURE != "Catch_Up"`) | features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts:56~67 + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:187~188 (40+Catch_Up ITEM_ID 모달 전용 — 콤보 미바인딩) |  | 구현 |
| CA-155 | §1.6 [원문 무번호] MEASURE 변경 → 편집 시작점 / `Substring(0,2)=="40" && MEASURE=="SalesAmt_LOC"` | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (R3 — row.MEASURE 실시간 참조로 전환 반영) |  | 구현 |
| CA-156 | §1.6 [원문 무번호] MEASURE 변경 → 기간 잠금 (작월 조회) / `Substring(0,2)=="40"` | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (R3 — row.MEASURE 실시간 참조로 전환 반영) |  | 구현 |
| CA-157 | §1.6 [원문 무번호] MEASURE 변경 → 기간 잠금 (당월~) / `Substring(0,2)=="40"` | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (R3 — row.MEASURE 실시간 참조로 전환 반영) |  | 구현 |
| CA-158 | §1.7 [원문 무번호] spdMain_CellDoubleClick / `sDivision=="40" && sMeasure=="Catch_Up" && ITEM_… | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:909~927 + features/demand/src/pages/sales-plan/components/SalesPlanModals.tsx (ItemByDivisionModal — 40+Catch_Up) |  | 구현 |
| CA-159 | §1.7 [원문 무번호] spdMain_CellDoubleClick (PROJECT_CODE) / Action=='I' 행 한정 | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:909~927 + features/demand/src/pages/sales-plan/components/SalesPlanModals.tsx (ProjectByDivisionModal — Insert 행 한정) |  | 구현 |
| CB-101 | §2 [원문 무번호] 기능 / 권한 조건 |  | 표 헤더 행(기능/권한 조건 라벨) — 판정 대상 아님 | 해당없음 |
| CB-102 | §2 [원문 무번호] EditButton — Tables[2] 소비 / `dsMain != null && dsMain.Tables.Count >= 3` → `d… | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:69~76 (buildMeasureAuth) + features/demand/src/pages/sales-plan/SalesPlan.tsx:141~151 (커서3 editAuth 보관) |  | 구현 |
| CB-103 | §2 [원문 무번호] EditButton — 편집행 판정 1 / `MEASURE=="SalesAmt_LOC" && bEDIT_AUTH_SalesAmt_LOC &… | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:126 (SalesAmt_LOC × 권한 × FCST_TYPE=ETC) |  | 구현 |
| CB-104 | §2 [원문 무번호] EditButton — 편집행 판정 2 / `MEASURE.ToUpper()=="RTF_SYS_RP" && bEDIT_AUTH_RTF_SY… | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:130~132 (RTF_SYS_RP × 권한) |  | 구현 |
| CB-105 | §2 [원문 무번호] EditButton — division 결합 판정 / `(40 \ | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:123~133 (division 결합 measureGate) |  | 구현 |
| CB-106 | §2 [원문 무번호] **InsertButton 게이트** / `dsMain.Tables[2]` 재조회 → `bEDIT_AUTH_SalesAmt_LOC == f… | features/demand/src/pages/sales-plan/SalesPlan.tsx:224~232 (handleInsert — EDIT_AUTH_SALESAMT_LOC≠Y silent return) |  | 구현 |
| CB-107 | §2 [원문 무번호] 조회 SP 파라미터 (JV Planner) / `p_user_dept_id = UserInfoContext.Current["Dept_ID"… | features/demand/src/pages/sales-plan/useSalesPlanStore.ts:256 (userDeptId → p_user_dept_id — SalesPlanUserDept 콤보 주입) |  | 구현 |
| CB-108 | §2 [원문 무번호] EditButton — 팀 권한 조회 / `Data.UserTeamByDivisionAuth(NowGroupID, UserId, divis… |  | AS-IS 취득만 하고 사용처 없는 잔존 코드(L880) — 이관 대상 아님 | 해당없음 |
| CB-109 | §2 [원문 무번호] InsertRow — 권한 콤보 3종 / `UserTeamByDivisionAuth` / `UserSiteByEndCustomerAuth`… | features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts:56~67 (DeptId/EndCustomerByDivisionDept/SiteByEndCustomer 권한 콤보) |  | 구현 |
| CB-110 | §2 [원문 무번호] ComboSelChange — 권한 콤보 / DIVISION_ID 변경: `UserTeamByDivisionAuth`(4546)·`User… | features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts:45~71 + features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:283~312 (rowCombo 재바인딩) |  | 구현 |
| CC-01 | §3.3 ITEM_ID 값 초기화 / 4909 | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:71 (applyMeasureSwitch — ITEM_ID clear) |  | 구현 |
| CC-02 | §3.3 ITEM_ID 셀타입 = 이미지(팝업 호출형 cellTypeImage) / 4910 | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:633~652 (isModalCell — 팝업 아이콘 셀 전환) |  | 구현 |
| CC-03 | §3.3 DomExp 값 초기화 / 4915 | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:69 (DOM_EXP clear) |  | 구현 |
| CC-04 | §3.3 DomExp 콤보 = dtCustomsHandbook (DM_CUSTOMS_HANDBOOK) / 4916 | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:261~269 (dataMaps — DOM_EXP 콤보 CustomsHandbook 메타 바인딩) |  | 구현 |
| CC-05 | §3.3 DomExp unlock (입력 개방) / 4917 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:201~204 (DOM_EXP — 40+Catch_Up 개방) |  | 구현 |
| CC-06 | §3.3 INCOTERMS 값 초기화 / 4933 | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:70 (INCOTERMS clear) |  | 구현 |
| CC-07 | §3.3 INCOTERMS 콤보 = GetIncotermsType(division, scmSite) (AS_INCOTERMS) / 4934~4935 | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:250~269 (INCOTERMS 편집 콤보 — 게이트 섹션7 콤보 대사 포함) |  | 구현 |
| CC-08 | §3.3 INCOTERMS unlock / 4936 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:201~204 (INCOTERMS 개방) |  | 구현 |
| CC-09 | §3.3 FcstType 값 초기화 / 4941 | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:68 (FCST_TYPE clear) |  | 구현 |
| CC-10 | §3.3 FcstType 콤보 = dtFcstType (**ETC 제외** — GetFcstType `CODE <> 'ETC'` 필터, 5595) / 4942 | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:17~24 (buildCatchUpFcstTypeMap — ETC 제외) |  | 구현 |
| CC-101 | §3.1 [원문 무번호] Measure / 위치 |  | 표 헤더 행 — 판정 대상 아님 | 해당없음 |
| CC-102 | §3.1 [원문 무번호] SalesAmt_LOC / EditButton | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:126 (ETC 한정 편집) |  | 구현 |
| CC-103 | §3.1 [원문 무번호] SalesAmt_LOC / EditButton | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:123~133 (division 결합 branch) |  | 구현 |
| CC-104 | §3.1 [원문 무번호] SalesAmt_LOC / InsertRow | features/demand/src/pages/sales-plan/useSalesPlanStore.ts (Insert 기본 MEASURE=SalesAmt_LOC — INSERT_DEFAULT) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:27~32 (measureInfo 콤보) |  | 구현 |
| CC-105 | §3.1 [원문 무번호] SalesAmt_LOC / spdMain_LeaveCell | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:802~806 (LOC 소수3 반올림) + features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:101~112 (NOTATION 포맷) |  | 구현 |
| CC-106 | §3.1 [원문 무번호] SalesAmt_LOC / ComboSelChange (40) | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:146~148 (40 당월 포함 시작) |  | 구현 |
| CC-107 | §3.1 [원문 무번호] SalesAmt_LOC(전환 복귀) / ComboSelChange | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (applyMeasureSwitch 복귀 cascade) |  | 구현 |
| CC-108 | §3.2 [원문 무번호] Measure / 위치 |  | 표 헤더 행 — 판정 대상 아님 | 해당없음 |
| CC-109 | §3.2 [원문 무번호] Catch_Up / EditButton | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:127 (Catch_Up 권한 무관 — 40 전용) |  | 구현 |
| CC-11 | §3.3 FcstType unlock / 4943 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:201~204 (FCST_TYPE 개방) |  | 구현 |
| CC-110 | §3.2 [원문 무번호] Catch_Up / EditButton | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:138~140 (M+3 게이트) |  | 구현 |
| CC-111 | §3.2 [원문 무번호] Catch_Up / SaveData | features/demand/src/pages/sales-plan/utils/sales-plan.division.ts:63~66 (Team 필수 자체 해제 — No.61-④) |  | 구현 |
| CC-112 | §3.2 [원문 무번호] Catch_Up / SaveData | features/demand/src/pages/sales-plan/utils/sales-plan.division.ts:72~76 (Catch_Up 필수 3종) |  | 구현 |
| CC-113 | §3.2 [원문 무번호] Catch_Up / SaveData | features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:121~124 (음수 차단) |  | 구현 |
| CC-114 | §3.2 [원문 무번호] Catch_Up / CellDoubleClick | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:909~927 + features/demand/src/pages/sales-plan/components/SalesPlanModals.tsx (ItemByDivisionModal) |  | 구현 |
| CC-115 | §3.2 [원문 무번호] Catch_Up / ComboSelChange (END_CUSTOMER40) | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:187~188 (Catch_Up ITEM_ID 모달 전용 — 콤보 미바인딩) |  | 구현 |
| CC-116 | §3.2 [원문 무번호] Catch_Up / ComboSelChange (SCM_SITE_ID) | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:187~188 (Catch_Up ITEM_ID 모달 전용 — 콤보 미바인딩) |  | 구현 |
| CC-117 | §3.2 [원문 무번호] Catch_Up / ComboSelChange (MEASURE) | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 + features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:826~840 (MEASURE 전환 cascade) |  | 구현 |
| CC-118 | §3.4 [원문 무번호] Measure / 위치 |  | 표 헤더 행 — 판정 대상 아님 | 해당없음 |
| CC-119 | §3.4 [원문 무번호] RTF_SYS_RP / EditButton | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:130~132 (RTF 권한 편집 후보) |  | 구현 |
| CC-12 | §3.3 DEPT_ID(Team) 값 초기화 / 4950 | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (applyMeasureSwitch — DEPT_ID clear, 2026-08-12 보완) |  | 구현 |
| CC-120 | §3.4 [원문 무번호] RTF_SYS_RP / EditButton ⭐E20260331 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:128~132 (E20260331 81 확장) |  | 구현 |
| CC-121 | §3.4 [원문 무번호] RTF_SYS_RP / EditButton (Monthly) | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:142~144 (RTF Monthly 당월 잠금 M+1) |  | 구현 |
| CC-122 | §3.4 [원문 무번호] RTF_SYS_RP / spdMain_LeaveCell | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:792~801 (음수 차단 RMA 예외) |  | 구현 |
| CC-123 | §3.4 [원문 무번호] RTF_SYS_RP / spdMain_LeaveCell | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:799~800 (Math.trunc 정수 절삭) |  | 구현 |
| CC-13 | §3.3 DEPT_ID **잠금** (catch-up 입력 시 팀 수정 금지) / 4951 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:179~180 (DEPT_ID — Catch_Up 시 잠금) |  | 구현 |
| CC-14 | §3.3 숫자컬럼: D_ 제외 & `YYYYMM >= 현재+3개월` 컬럼만 unlock / 4959~4967 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:138~140·154~156 (Catch_Up M+3 — catchUpMonth) |  | 구현 |
| CC-15 | §3.3 숫자컬럼: M+3 미만 컬럼 잠금 / 4968~4971 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:138~140·154~156 (Catch_Up M+3 — catchUpMonth) |  | 구현 |
| CC-16 | §3.3 편집 시작 불가(과거 구간)이면 MEASURE+1~끝 전체 잠금 / 4974~4977 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:97·136~157 (과거 구간 전잠금) |  | 구현 |
| CC-17 | §3.3 FcstType = "ETC" 고정 + Text 셀타입 전환 + 잠금 / 4983~4988 | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:75 (FCST_TYPE=ETC 고정) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:203~204 (잠금) |  | 구현 |
| CC-18 | §3.3 DomExp 초기화 + 잠금 / 4990~4994 | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:76 + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:201~204 (DOM_EXP clear+잠금) |  | 구현 |
| CC-19 | §3.3 INCOTERMS 초기화 + 잠금 / 4996~5000 | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:77 + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:201~204 (INCOTERMS clear+잠금) |  | 구현 |
| CC-20 | §3.3 DEPT_ID 초기화 + **unlock** (ETC는 팀 입력 가능) / 5004~5008 | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~88 (DEPT_ID clear) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:179~183 | 값 초기화 구현·개방은 No.61-④ 로 전 Div 잠금 우선(ETC 복귀 개방 폐지) | 구현 |
| CC-21 | §3.3 ITEM_ID 셀타입 해제(null) + 초기화 + GUBUN='40' 콤보 재바인딩 / 5010~5015 | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:71~72 + features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:173~190 (ITEM_ID 콤보 재바인딩) |  | 구현 |
| CC-22 | §3.3 NickName 초기화 / 5017~5020 | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:73 (NICK_NAME clear) |  | 구현 |
| CC-23 | §3.3 숫자컬럼 전체 unlock 후 기간 분기 재잠금 (40 당월/비40 M+1/과거 전체잠금) / 5031~5071 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (R3 재판정 — row.MEASURE 실시간) |  | 구현 |
| CC-24 | §3.3 D_ 잠금 + 버킷 교차 잠금 (Monthly→W_ 잠금 / Weekly→M_ 잠금) / 5074~5099 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:109~113 (R2 — D_ 잠금 + 버킷 교차) |  | 구현 |
| CC-25 | §3.3 메저 전환 시 기존 숫자 입력값 전체 초기화(`SetValue ""`) + D_ 재잠금 / 5106~5116 | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:80~82 (기간 입력 전체 초기화) |  | 구현 |
| CD-101 | §4.1 [원문 무번호] 규칙 / 조건 |  | 표 헤더 행 — 판정 대상 아님 | 해당없음 |
| CD-102 | §4.1 [원문 무번호] M_ 편집 시작 — 40 당월 / `Substring(0,2)=="40"`: `GetColumnIndex(this_YYYYMM) <= … | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:146~147 (40 당월 포함 ≥) |  | 구현 |
| CD-103 | §4.1 [원문 무번호] M_ 편집 시작 — 비40 익월 / else: `GetColumnIndex(this_YYYYMM) < iCol` | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:147 (비40 익월 ＞) |  | 구현 |
| CD-104 | §4.1 [원문 무번호] 조회기간이 당월 이후 / `sPeriod[0] 월 > this_YYYYMM` → 모든 M_ 편집 대상 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (태그-cutoff 비교 — 조회기간 무관 동등 판정) |  | 구현 |
| CD-105 | §4.1 [원문 무번호] W_ 편집 시작 — 당주 / `GetColumnIndex(this_YYYYMMWW) <= iCol` (전 사업부 공통) | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:150~153 (W_ 당주 ≥) |  | 구현 |
| CD-106 | §4.1 [원문 무번호] 조회기간이 당주 이후 / `sPeriod[0] 월 > this_YYYYMMWW 월` → 모든 W_ 편집 대상 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (태그-cutoff 비교 — 조회기간 무관 동등 판정) |  | 구현 |
| CD-107 | §4.1 [원문 무번호] Edit 시작 컬럼 보정 / 첫 컬럼이 M_ 이면 +1 (M_ 뒤 W_ 항상 존재) |  | TO-BE 는 binding 태그 판정 — 컬럼 인덱스 +1 보정 구조 자체가 없음 | 해당없음 |
| CD-108 | §4.1 [원문 무번호] **과거~과거 조회 = 전체 편집 불가** / 마지막 컬럼 W_ < 당주 → `i_EditStartCol = 0` | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:100~107·136~157 (과거 태그 전부 editable=false — 전체 편집 불가와 동등) |  | 구현 |
| CD-109 | §4.1 [원문 무번호] 동일 (Daily 말미) / 마지막 컬럼 D_ < 당주 월요일(sResult_YYYYMMDD) → 0 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:100~107·136~157 (과거 태그 전부 editable=false — 전체 편집 불가와 동등) |  | 구현 |
| CD-110 | §4.1 [원문 무번호] 당주 존재 시 시작 컬럼 = 당주 / `GetColumnIndex(this_YYYYMMWW) >= 0` | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (셀 단위 cutoff — 시작 컬럼 개념 대체) |  | 구현 |
| CD-111 | §4.1 [원문 무번호] 편집 루프 게이트 / `i_EditStartCol > 0` 일 때만 행별 락 해제 수행 ([E20250520-000605] `>= 0`… | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (셀 단위 cutoff — 시작 컬럼 개념 대체) |  | 구현 |
| CD-112 | §4.1 [원문 무번호] 행별 편집 시작 컬럼 / Monthly → `list_EDIT_Month[0]` / Weekly → `list_EDIT_Week[0]` | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (셀 단위 cutoff — 시작 컬럼 개념 대체) |  | 구현 |
| CD-113 | §4.1 [원문 무번호] 버킷-prefix 일치 검증 / `Weekly && W_` 또는 `Monthly && M_` 일 때만 unlock, 불일치 시 잠금 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:109~113 (버킷-prefix 상호배제) |  | 구현 |
| CD-114 | §4.1 [원문 무번호] InsertRow — Monthly 당월 포함 / `Monthly && this_YYYYMM 존재` → 시작 = 당월 컬럼 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (Insert 행 동일 엔진 — R3) |  | 구현 |
| CD-115 | §4.1 [원문 무번호] InsertRow — Weekly 당주 포함 / `Weekly && this_YYYYMMWW 존재` → 시작 = 당주 / 부재 시 +1 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (Insert 행 동일 엔진 — R3) |  | 구현 |
| CD-116 | §4.1 [원문 무번호] InsertRow — 과거 조회 차단 / 마지막 W_ < 당주 → i_EditStartCol=0 → 전 구간 잠금 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (Insert 행 동일 엔진 — R3) |  | 구현 |
| CD-117 | §4.1 [원문 무번호] InsertRow — 비40 M+1 unlock 판정 / 첫 M_ > 당월이면 unlock, 아니면 잠금 (25.07.04 주석: 신규… | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (Insert 행 동일 엔진 — R3) |  | 구현 |
| CD-118 | §4.1 [원문 무번호] ComboSelChange — 시작점 재계산 / 첫 컬럼 M_→당월 포함, W_→당주 포함, 마지막 W_ < 당주 → 0 (2회 검사) | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (row.MEASURE 실시간 재판정 — 재계산 대체) |  | 구현 |
| CD-119 | §4.1 [원문 무번호] FindData — 기간 역전 / `sPeriod[0] > sPeriod[1]` → MSG00108 | features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:38~45 (기간 역전 MSG00108) |  | 구현 |
| CD-120 | §4.1 [원문 무번호] FindData — 기간 상한 / `Value1.AddYears(3) < Value2` → MSG00164 + Value2 보정 (주석… | features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:46~57 (3년 초과 MSG00164 + 종료일 보정) |  | 구현 |
| CD-121 | §4.1 [원문 무번호] 과거-과거 첫달 회색 버그 보정 / `조회시작월 >= this_YYYYMM` → iResultMonth+1 |  | TO-BE isPast = 태그 비교 — AS-IS Draw 인덱스 버그가 구조상 불발생 | 해당없음 |
| CD-122 | §4.2 [원문 무번호] 규칙 / 조건 |  | 표 헤더 행 — 판정 대상 아님 | 해당없음 |
| CD-123 | §4.2 [원문 무번호] **Daily = 편집 자체 불가** / `BucketType.Daily` → MSG00361 후 return | features/demand/src/pages/sales-plan/SalesPlan.tsx:227~232 (Daily 편집 차단 MSG00361 대응) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:110 |  | 구현 |
| CD-124 | §4.2 [원문 무번호] Daily 컬럼 입력 차단 / Dsdm_Changed: `D_` 컬럼이면 return | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:111 (D_ 상시 잠금) |  | 구현 |
| CD-125 | §4.2 [원문 무번호] Daily 저장 스킵 / SaveData: `D_` 컬럼 continue | features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:65~68·154 (activeKind M/W 만 수집 — D_ 제외) |  | 구현 |
| CD-126 | §4.2 [원문 무번호] 버킷 교차 잠금 (편집) / Monthly 편집 시 모든 list_EDIT_Week 잠금 / Weekly 편집 시 모든 list_EDI… | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:112~113 (Monthly↔Weekly 상호배제 — 편집/Insert/전환 공통 엔진) |  | 구현 |
| CD-127 | §4.2 [원문 무번호] 버킷 교차 잠금 (Insert) / Monthly→W_ 잠금 / Weekly→M_ 잠금 + D_ 잠금 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:112~113 (Monthly↔Weekly 상호배제 — 편집/Insert/전환 공통 엔진) |  | 구현 |
| CD-128 | §4.2 [원문 무번호] 버킷 교차 잠금 (Measure 전환) / 동일 세트 2회 (5074~5099, 5108~5116) | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:112~113 (Monthly↔Weekly 상호배제 — 편집/Insert/전환 공통 엔진) |  | 구현 |
| CD-129 | §4.2 [원문 무번호] 버킷 교차 저장 스킵 / Weekly 인데 M_ / Monthly 인데 W_ → continue (동월 이중수정 중복 방지) | features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:154·173 (버킷 불일치 셀 silent skip) |  | 구현 |
| CD-130 | §4.2 [원문 무번호] **편집 중 버킷 변경 금지** / `!siMain.IsLock()` → MSG00227 | features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:63~72 (validateBucketChange — 변경분 존재 시 차단) |  | 구현 |
| CD-131 | §4.2 [원문 무번호] RTF_SYS_RP 당월 잠금 / Monthly && 조회시작월 <= 당월 && `M_ < 현재+1개월` → 잠금 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:142~144 (RTF Monthly 당월 잠금) |  | 구현 |
| CD-132 | §4.2 [원문 무번호] Catch_Up M+3 잠금 / `YYYYMM >= Now+3개월` 만 편집 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:138~140 (Catch_Up M+3) |  | 구현 |
| CD-133 | §4.2 [원문 무번호] 헤더 더블클릭 접기/펼치기 / M_ 헤더: 하위 W_(Daily 시 D_) 토글 / W_ 헤더: 하위 D_ 토글 | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:877~907 (헤더 더블클릭 드릴다운) |  | 구현 |
| CD-134 | §4.2 [원문 무번호] 저장 시 팀 변경 전파 / 40: DEPT_ID 셀이 Red(수정)이면 해당 버킷(W_/M_) 숫자컬럼 전부 Red 처리(수정 간주) |  | TO-BE 기존 행 DEPT_ID 편집 불가(정적 셀 Insert 행 한정) — Insert 행은 전량 저장이라 전파 불필요 | 해당없음 |
| CD-135 | §4.2 [원문 무번호] 저장 대상 판정 / 셀 ForeColor == Red 만 저장 (변경 추적) | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:807~815 (EditTracker storeChange) + features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:167~177 (변경 셀만 수집) |  | 구현 |
| CD-136 | §4.2 [원문 무번호] 빈값 저장 치환 / sPrice=="" → "0" ([E20251125-000694]) / action != "D" && sPrice=… | features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:58~62·137 (빈값→'0' / '0'→'D' 전환) |  | 구현 |
| CD-137 | §4.2 [원문 무번호] 저장 0건 검증 / iDateCount==0 → MSG00146(행번호) | features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:161~164·178~180 (라인 변경 0건 — AS-IS MSG00146 → 사내 MSG00670 재매핑, MSG.LINE_NO_CHANGE) |  | 구현 |
| CD-138 | §4.3 [원문 무번호] 규칙 / 조건 |  | 표 헤더 행 — 판정 대상 아님 | 해당없음 |
| CD-139 | §4.3 [원문 무번호] 색상 모드(chkColor=true) — 과거 회색 / 전주(pre_YYYYMMWW)까지 `Color.Gainsboro` 배경 |  | Color 체크박스 제거(2026-07 사용자 확정) — chkColor=true 모드 미제공 | 제외 |
| CD-140 | §4.3 [원문 무번호] 색상 모드 — 당월 White 복원 / this_YYYYMM 컬럼 White |  | Color 체크박스 제거(2026-07 사용자 확정) — chkColor=true 모드 미제공 | 제외 |
| CD-141 | §4.3 [원문 무번호] 보더 모드(chkColor=false) — 당주 초록 / `BevelBorder(Raised, Green, Green, 3)` 당주 컬… | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:200~213 (당주 세로 레일 — 보더 모드 대응) |  | 구현 |
| CD-142 | §4.3 [원문 무번호] Draw — 과거 구간 회색 / Daily: `D_ < 당주월요일` / Weekly: 전주(pre_YYYYMMWW) 매칭(52주차 특례… | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:100~107 (isPast) + features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:594~605 (Gray 클래스) |  | 구현 |
| CD-143 | §4.3 [원문 무번호] Draw — 보더 모드 / 비Daily: 당주(this_YYYYMMWW) 또는 sResult_YYYYMMWW 초록 보더 / Daily:… | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:200~213·569 (당주/당월 강조) |  | 구현 |
| CD-144 | §4.3 [원문 무번호] 헤더 강조 — 당월/당주 / M_: 당월이면 ForeColor Green + 굴림 9 Bold + 폭 60 / W_: iso_week+… | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:538~554·569 (헤더 Green Bold) |  | 구현 |
| CD-145 | §4.3 [원문 무번호] 색상 모드 시 헤더 리셋 / chkColor=true → ForeColor/Font 리셋 |  | Color 체크박스 제거(2026-07 사용자 확정) — chkColor=true 모드 미제공 | 제외 |
| CD-146 | §4.3 [원문 무번호] 버킷 전환 시 보더 재설정 / Daily: D_ 보더 + 당주 W_ 보더 해제 / 비Daily: 당주 W_ 보더 + D_ 보더 해제 | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx (bucketType deps formatItem 재실행 — 보더 재설정 대체) |  | 구현 |
| CD-147 | §4.3 [원문 무번호] 토·일 헤더 색 / DayCode SAT → Blue / SUN → Red | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:409~432 (weekendCodeByBinding — SAT Blue/SUN Red) |  | 구현 |
| CD-148 | §4.3 [원문 무번호] 주말/합계 푸터 / M_/W_/D_ 컬럼 SumIgnoreHidden + LightGray |  | 2026-08-12 사용자 지시 — Grid Footer Summary 삭제 (aggregate/useAggregationRow 제거) | 제외 |
| CE-101 | §5 [원문 무번호] EditButton ⭐E20260331 / `SalesAmt_LOC 편집은 FcstType=="ETC" 한정` — 수정라인 판정에 ETC … | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:126 (ETC 한정 — E20260331) |  | 구현 |
| CE-102 | §5 [원문 무번호] InsertRow / 신규 행 `FcstType = "ETC"` 고정 세팅 + 잠금 | features/demand/src/pages/sales-plan/useSalesPlanStore.ts (Insert FCST_TYPE=ETC 고정 — INSERT_DEFAULT_FCST_TYPE) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:203~204 |  | 구현 |
| CE-103 | §5 [원문 무번호] spdMain_LeaveCell / `RTF_SYS_RP && FcstType != "RMA" && Val < 0` → 값 삭제. **RM… | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:792~801 (RMA 만 음수 허용) |  | 구현 |
| CE-104 | §5 [원문 무번호] ComboSelChange (Catch_Up 전환) / FcstType 초기화 + dtFcstType 콤보(**ETC 제외**) + unl… | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:17~24·68 (ETC 제외 콤보 + clear) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:201~204 (개방) |  | 구현 |
| CE-105 | §5 [원문 무번호] ComboSelChange (SalesAmt_LOC 복귀) / `FcstType="ETC"` 고정 + Text 셀타입 + 잠금 | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:75 (ETC 고정) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:203~204 (잠금) |  | 구현 |
| CE-106 | §5 [원문 무번호] GetFcstType / `dt.Select(" CODE <> 'ETC' ")` — Catch_Up 용 콤보에서 ETC 제외 (SalesA… | features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:20~22 (CODE≠ETC 필터) |  | 구현 |
| CE-107 | §5 [원문 무번호] SaveData / 40 && Catch_Up && sFcstType=="" → "[FcstType]" 필수 | features/demand/src/pages/sales-plan/utils/sales-plan.division.ts:74 (Catch_Up FcstType 필수) |  | 구현 |
| CE-108 | §5 [원문 무번호] SaveData / pFcstType '^' 연결 파라미터 → `p_fcst_type` 전달 | features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:200~201 (p_fcst_type '^' 전달) |  | 구현 |
| CF-01 | §6.1 EditButton / 컬럼 0~max 전체 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (전체잠금+선별해제 → 셀 단위 동등 판정으로 구조 대체) |  | 구현 |
| CF-02 | §6.1 FindData / 컬럼 0~max 전체 | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (전체잠금+선별해제 → 셀 단위 동등 판정으로 구조 대체) |  | 구현 |
| CF-03 | §6.2 Catch_Up·M+3·IsEditMode: 행 i, j~max 해제 / false | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (evalSalesPlanDynCell R1~R4 — EditButton lock 13건 집약) |  | 구현 |
| CF-04 | §6.2 Catch_Up·Monthly: list_EDIT_Week 각 컬럼 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (evalSalesPlanDynCell R1~R4 — EditButton lock 13건 집약) |  | 구현 |
| CF-05 | §6.2 Catch_Up·Weekly: list_EDIT_Month 각 컬럼 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (evalSalesPlanDynCell R1~R4 — EditButton lock 13건 집약) |  | 구현 |
| CF-06 | §6.2 Catch_Up·비편집모드 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (evalSalesPlanDynCell R1~R4 — EditButton lock 13건 집약) |  | 구현 |
| CF-07 | §6.2 Catch_Up·버킷-prefix 불일치 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (evalSalesPlanDynCell R1~R4 — EditButton lock 13건 집약) |  | 구현 |
| CF-08 | §6.2 Catch_Up·M+3 미만 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (evalSalesPlanDynCell R1~R4 — EditButton lock 13건 집약) |  | 구현 |
| CF-09 | §6.2 SalesAmt_LOC/RTF·IsEditMode: 행 i, j~max 해제 / false | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (evalSalesPlanDynCell R1~R4 — EditButton lock 13건 집약) |  | 구현 |
| CF-10 | §6.2 SalesAmt_LOC/RTF·Monthly: list_EDIT_Week 각 컬럼 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (evalSalesPlanDynCell R1~R4 — EditButton lock 13건 집약) |  | 구현 |
| CF-100 | §6.4 기간 잠금(비40): ~시작(M+1) / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-101 | §6.4 시작 해제(40) / false | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-102 | §6.4 시작 해제(비40, 첫 M_ > 당월) / false | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-103 | §6.4 시작 잠금(비40, else) / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-104 | §6.4 과거 구간 전체 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-105 | §6.4 D_ 컬럼 개별 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-106 | §6.4 Monthly 시 W_ 개별 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-107 | §6.4 Weekly 시 M_ 개별 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-108 | §6.4 공통 후처리 D_ 재잠금 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-11 | §6.2 RTF_SYS_RP·Monthly: 당월(M+1 미만) 컬럼 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (evalSalesPlanDynCell R1~R4 — EditButton lock 13건 집약) |  | 구현 |
| CF-12 | §6.2 SalesAmt_LOC/RTF·Weekly: list_EDIT_Month 각 컬럼 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (evalSalesPlanDynCell R1~R4 — EditButton lock 13건 집약) |  | 구현 |
| CF-13 | §6.2 SalesAmt_LOC/RTF·버킷 판별 else / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (evalSalesPlanDynCell R1~R4 — EditButton lock 13건 집약) |  | 구현 |
| CF-14 | §6.2 SalesAmt_LOC/RTF·비편집모드 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (evalSalesPlanDynCell R1~R4 — EditButton lock 13건 집약) |  | 구현 |
| CF-15 | §6.2 SalesAmt_LOC/RTF·prefix 불일치 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (evalSalesPlanDynCell R1~R4 — EditButton lock 13건 집약) |  | 구현 |
| CF-16 | §6.3 DIVISION_ID / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-17 | §6.3 DEPT_ID (비40) / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:179~183 (DEPT_ID 전 Div false — No.61-④ 상위집합) |  | 구현 |
| CF-18 | §6.3 MEASURE (비40) / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-19 | §6.3 FcstType / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-20 | §6.3 TEAM_INCHARGE / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-21 | §6.3 PROJECT_NAME / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-22 | §6.3 ProjectStatus / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-23 | §6.3 PROJECT_OWNER / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-24 | §6.3 BizTypeName / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-25 | §6.3 ITEM_CLASS_NAME / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-26 | §6.3 ITEM_NAME / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-27 | §6.3 ItemType / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-28 | §6.3 SALES_COMPANY / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-29 | §6.3 SALES_PLANT / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-30 | §6.3 NickName / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-31 | §6.3 KwhCell / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-32 | §6.3 KwhModule / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-33 | §6.3 KwhPack / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-34 | §6.3 PLANT_SITE_ID / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-35 | §6.3 DomExp / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-36 | §6.3 SALES_PLAN_ADJUST_YN / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-37 | §6.3 INCOTERMS / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-38 | §6.3 OWNER / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-39 | §6.3 COUNTRY_NAME / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-40 | §6.3 CITY_NAME / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-41 | §6.3 FORECAST_INFO_PRODUCT_GROUP / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-42 | §6.3 VMI_YN / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-43 | §6.3 ProjectName / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-44 | §6.3 DistributionChannel / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-45 | §6.3 CellName / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable R5 — default false 붕괴 규칙) |  | 구현 |
| CF-75 | §6.3 기간 잠금(40, 작월 조회): MEASURE+1 ~ 시작-1 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (Insert 행 기간·버킷 — R2/R3 동일 엔진) |  | 구현 |
| CF-76 | §6.3 기간 잠금(비40 Monthly): ~시작(당월 포함, M+1) / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (Insert 행 기간·버킷 — R2/R3 동일 엔진) |  | 구현 |
| CF-77 | §6.3 기간 잠금(비40 Weekly, 당주 존재): ~시작-1 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (Insert 행 기간·버킷 — R2/R3 동일 엔진) |  | 구현 |
| CF-78 | §6.3 당월 시작 해제(40): MEASURE+1 ~ 시작 / false | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (Insert 행 기간·버킷 — R2/R3 동일 엔진) |  | 구현 |
| CF-79 | §6.3 시작 해제(비40, 첫 M_ > 당월) / false | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (Insert 행 기간·버킷 — R2/R3 동일 엔진) |  | 구현 |
| CF-80 | §6.3 시작 잠금(비40, 첫 M_ <= 당월) / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (Insert 행 기간·버킷 — R2/R3 동일 엔진) |  | 구현 |
| CF-81 | §6.3 과거 구간: MEASURE+1 ~ max 전체 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (Insert 행 기간·버킷 — R2/R3 동일 엔진) |  | 구현 |
| CF-82 | §6.3 D_ 컬럼 개별 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (Insert 행 기간·버킷 — R2/R3 동일 엔진) |  | 구현 |
| CF-83 | §6.3 Monthly 시 W_ 컬럼 개별 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (Insert 행 기간·버킷 — R2/R3 동일 엔진) |  | 구현 |
| CF-84 | §6.3 Weekly 시 M_ 컬럼 개별 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:136~157 (Insert 행 기간·버킷 — R2/R3 동일 엔진) |  | 구현 |
| CF-85 | §6.4 PLANT_SITE_ID (division 비81) / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:199~200 (PLANT_SITE_ID 비81 잠금) |  | 구현 |
| CF-86 | §6.4 PLANT_SITE_ID (division 81) / false | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:201~212 (PLANT_SITE_ID 81 도 잠금 — AS-IS InsertRow L3023 무조건 lock) |  | 구현 |
| CF-87 | §6.4 DomExp (Catch_Up 전환) / false | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-88 | §6.4 INCOTERMS (Catch_Up 전환) / false | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-89 | §6.4 FcstType (Catch_Up 전환) / false | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-90 | §6.4 DEPT_ID (Catch_Up 전환 — 팀 수정 금지) / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:179~183 (전 Div 잠금 — Catch_Up 포함 상위집합) |  | 구현 |
| CF-91 | §6.4 숫자컬럼 M+3 이후 (Catch_Up) / false | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-92 | §6.4 숫자컬럼 M+3 미만 (Catch_Up) / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-93 | §6.4 과거 구간 전체 (Catch_Up) / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-94 | §6.4 FcstType (SalesAmt_LOC 복귀 — ETC 고정) / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-95 | §6.4 DomExp (SalesAmt_LOC 복귀) / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-96 | §6.4 INCOTERMS (SalesAmt_LOC 복귀) / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-97 | §6.4 DEPT_ID (SalesAmt_LOC 복귀 — 팀 입력 개방) / false |  | 통합테스트 1st No.61-④ — ETC 복귀 시 팀 입력 개방(AS-IS L5007)은 전 Div 잠금 정책으로 폐지 | 제외 |
| CF-98 | §6.4 숫자컬럼 전체 선해제: MEASURE+1 ~ max / false | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CF-99 | §6.4 기간 잠금(40): ~시작-1 / true | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (R5 — row.MEASURE 실시간) + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (R1~R4) + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 (전환 clear) |  | 구현 |
| CG-00 | §7.2 컬럼 정의 / `DefColumns.FromSiteId = "FROM_SITE_ID"` | features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts:65~67 (FROM_SITE_ID 콤보 배선) + SHEET_COLUMNS 81 등록(2026-07-21 사내 적용) |  | 구현 |
| CG-01 | §7.2 EditButton 필수컬럼 / `Substring(0,2)=="81" && GetColumnIndex(FromSiteId)==-1` 및 `Substr… | features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:81~93 (81 FROM/PLANT 컬럼 존재 MSG00113) |  | 구현 |
| CG-02 | §7.2 SaveData 필수컬럼 / 동일 2개 조건식 → MSG00113 후 저장 차단 | features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:81~93 (81 FROM/PLANT 컬럼 존재 MSG00113) |  | 구현 |
| CG-03 | §7.2 SaveData 값 매핑 / `if (GetColumnIndex(FromSiteId) != -1) sCellProdSiteId = GetValue(i,… | features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:87~90 (p_cell_prod_site_id ← FROM_SITE_ID — 81) |  | 구현 |
| CG-04 | §7.2 InsertRow 잠금 / FROM_SITE_ID 컬럼 LockRange true — "정보만 보여주고, 데이터를 선택할 필요없음" (표시 전용) | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 (insertStaticEditable default false — 표시 전용) |  | 구현 |
| CG-101 | §7.1 [원문 무번호] 필드 선언 / `private bool blnWork = false;` 주석 |  | E20260331 이 제거(주석 처리)한 blnWork 세마포어 — AS-IS 비활성 코드, 이관 대상 아님 | 해당없음 |
| CG-102 | §7.1 [원문 무번호] FindData 진입 / MSG00137 가드 + `blnWork=true` 주석 |  | E20260331 이 제거(주석 처리)한 blnWork 세마포어 — AS-IS 비활성 코드, 이관 대상 아님 | 해당없음 |
| CG-103 | §7.1 [원문 무번호] FindData catch/finally / `blnWork=false` 2곳 주석 |  | E20260331 이 제거(주석 처리)한 blnWork 세마포어 — AS-IS 비활성 코드, 이관 대상 아님 | 해당없음 |
| CG-104 | §7.1 [원문 무번호] SaveData 진입 / MSG00137 가드 + `blnWork=true` 주석 |  | E20260331 이 제거(주석 처리)한 blnWork 세마포어 — AS-IS 비활성 코드, 이관 대상 아님 | 해당없음 |
| CG-105 | §7.1 [원문 무번호] SaveData 성공 후 / `blnWork=false` 주석 |  | E20260331 이 제거(주석 처리)한 blnWork 세마포어 — AS-IS 비활성 코드, 이관 대상 아님 | 해당없음 |
| CG-106 | §7.1 [원문 무번호] SaveData catch/finally / `blnWork=false` 2곳 주석 |  | E20260331 이 제거(주석 처리)한 blnWork 세마포어 — AS-IS 비활성 코드, 이관 대상 아님 | 해당없음 |
| CG-107 | §7.1 [원문 무번호] clbDivision_SelectedIndexChanged / 진입 가드 + catch/finally 3곳 주석 |  | E20260331 이 제거(주석 처리)한 blnWork 세마포어 — AS-IS 비활성 코드, 이관 대상 아님 | 해당없음 |
| CG-108 | §7.1 [원문 무번호] (MEASURE=="Catch_Up") | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:123~133 (measureGate 조건식 — §7.1(2)(3) 코드블록 파편 행) |  | 구현 |
| CG-109 | §7.1 [원문 무번호] (MEASURE.ToUpper()=="RTF_SYS_RP" && bEDIT_AUTH_RTF_SYS_RP)) | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:123~133 (measureGate 조건식 — §7.1(2)(3) 코드블록 파편 행) |  | 구현 |
| CG-110 | §7.1 [원문 무번호] (MEASURE.ToUpper()=="RTF_SYS_RP" && bEDIT_AUTH_RTF_SYS_RP))) | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:123~133 (measureGate 조건식 — §7.1(2)(3) 코드블록 파편 행) |  | 구현 |
| CG-111 | §7.1 [원문 무번호] ((row DIVISION_ID != "40" | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:123~133 (measureGate 조건식 — §7.1(2)(3) 코드블록 파편 행) |  | 구현 |
| CH-101 | §8 [원문 무번호] SpdMain_ClipboardPasted (구버전) / END_CUSTOMER40 붙여넣기 시 SalesSite/ITEM_ID(GUBUN… |  | AS-IS 주석 처리 비활성 코드(§8 인벤토리) — 이관 대상 아님 | 해당없음 |
| CH-102 | §8 [원문 무번호] 42/44 division 분기 / `(sDivision=="40") |  | AS-IS 주석 처리 비활성 코드(§8 인벤토리) — 이관 대상 아님 | 해당없음 |
| CH-103 | §8 [원문 무번호] EditButton 40 읽기전용 / 구 로직: 40 → MSG00109(읽기 전용) 리턴, 81/82만 편집 — [PJ2024-50611… |  | AS-IS 주석 처리 비활성 코드(§8 인벤토리) — 이관 대상 아님 | 해당없음 |
| CH-104 | §8 [원문 무번호] blnWork 세마포어 / §7.1 (1) 참조 — E20260331 주석 처리 |  | AS-IS 주석 처리 비활성 코드(§8 인벤토리) — 이관 대상 아님 | 해당없음 |
| CH-105 | §8 [원문 무번호] SaveData 구 필수값 체크 / 원소스 변수(sDIVISION_ID 등) 기반 동일 로직 — 변수 통일 리팩터링으로 주석 ([E2025… |  | AS-IS 주석 처리 비활성 코드(§8 인벤토리) — 이관 대상 아님 | 해당없음 |
| CH-106 | §8 [원문 무번호] fnValidation 호출 / 중복체크 화면 수행 → SP 이관으로 호출부 주석 (`if (!fnValidation())`). 메서드 본… |  | AS-IS 주석 처리 비활성 코드(§8 인벤토리) — 이관 대상 아님 | 해당없음 |
| CH-107 | §8 [원문 무번호] SaveData 구 nvc 파라미터 / `CString.AppendStringEx` 방식 파라미터 조립 — Foxml 방식 전환으로 주석 |  | AS-IS 주석 처리 비활성 코드(§8 인벤토리) — 이관 대상 아님 | 해당없음 |
| CH-108 | §8 [원문 무번호] SaveData 구 오류 메시지 분기 / INVALID2/INVALID4/INVALID_MSG/INVALID5 분기 — [E20250520… |  | AS-IS 주석 처리 비활성 코드(§8 인벤토리) — 이관 대상 아님 | 해당없음 |
| CH-109 | §8 [원문 무번호] InsertRow 구 잠금 / SCM_SITE_ID(3026~3027)·CURRENCY(3034)·END_CUSTOMER 비40(3069~… |  | AS-IS 주석 처리 비활성 코드(§8 인벤토리) — 이관 대상 아님 | 해당없음 |
| CH-110 | §8 [원문 무번호] ComboSelChange DEPT_ID 분기 / 팀 변경 시 EndCustomer/SalesSite/ITEM_ID 연쇄 재바인딩 전체 —… |  | AS-IS 주석 처리 비활성 코드(§8 인벤토리) — 이관 대상 아님 | 해당없음 |
| CH-111 | §8 [원문 무번호] PLANT_SITE_ID Catch_Up 처리 / "40사업부가 없음..혹시 몰라서 주석" 2곳 |  | AS-IS 주석 처리 비활성 코드(§8 인벤토리) — 이관 대상 아님 | 해당없음 |
| CH-112 | §8 [원문 무번호] EditButton 구 색상 원본 / 전주 회색/당월 White 구 코드 |  | AS-IS 주석 처리 비활성 코드(§8 인벤토리) — 이관 대상 아님 | 해당없음 |
| CH-113 | §8 [원문 무번호] ExcelButton 구현 2종 / [PJ20209642R] ExcelButtonWithoutCopy / 원소스 ExportExcel 호출… |  | AS-IS 주석 처리 비활성 코드(§8 인벤토리) — 이관 대상 아님 | 해당없음 |
| CH-114 | §8 [원문 무번호] Dsdm_Changed 구 SUM / "Sum 계산 오류로 주석. 20190306" |  | AS-IS 주석 처리 비활성 코드(§8 인벤토리) — 이관 대상 아님 | 해당없음 |
| CH-115 | §8 [원문 무번호] 저장 sPrice=="" continue / [E20251125-000694] 이전엔 빈값 skip → 현행 "0" 치환 |  | AS-IS 주석 처리 비활성 코드(§8 인벤토리) — 이관 대상 아님 | 해당없음 |
| CH-116 | §8 [원문 무번호] 기타 / dtMearsure2/GetSALESPLAN_MEASUREInfo2 미사용(92, 532, 3517~3527), InitSaveD… |  | AS-IS 주석 처리 비활성 코드(§8 인벤토리) — 이관 대상 아님 | 해당없음 |
| CI-101 | §9 [원문 무번호] 1. Division 비교 분기 / **73곳** |  | 축별 카운트 요약 행 — 각 축 개별 행에서 판정 완료 | 해당없음 |
| CI-102 | §9 [원문 무번호] 2. 권한 / **16곳** |  | 축별 카운트 요약 행 — 각 축 개별 행에서 판정 완료 | 해당없음 |
| CI-103 | §9 [원문 무번호] 3. Measure / **22곳 비교 + 전환 cascade 25규칙** |  | 축별 카운트 요약 행 — 각 축 개별 행에서 판정 완료 | 해당없음 |
| CI-104 | §9 [원문 무번호] 4. 기간·버킷 / **42건** |  | 축별 카운트 요약 행 — 각 축 개별 행에서 판정 완료 | 해당없음 |
| CI-105 | §9 [원문 무번호] 5. FCST_TYPE / **8곳** |  | 축별 카운트 요약 행 — 각 축 개별 행에서 판정 완료 | 해당없음 |
| CI-106 | §9 [원문 무번호] 6. Lock / **108건 + 소비 8곳** |  | 축별 카운트 요약 행 — 각 축 개별 행에서 판정 완료 | 해당없음 |
| CI-107 | §9 [원문 무번호] 7. 결재 반영 / **E20260331: 3항목(주석 12블록 + 조건식 2곳) / E20260512: 4기능 블록(7개 지점)** |  | 축별 카운트 요약 행 — 각 축 개별 행에서 판정 완료 | 해당없음 |
| CI-108 | §9 [원문 무번호] 8. 비활성 인벤토리 / 17그룹 |  | 축별 카운트 요약 행 — 각 축 개별 행에서 판정 완료 | 해당없음 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:E03:EDIT | [EDIT] §3 EditButton (F2) — 편집모드 진입 (EditButton override, L687~L1123) | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (상시편집 — F2 편집모드 대체) + features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:657~747 (beginningEdit) |  | 구현 |
| CRUD:E04:SAVE | [SAVE] §4 SaveData (F7) — 저장 (SaveButton L1125~1128 → SaveData, L1940~L2863) | features/demand/src/pages/sales-plan/SalesPlan.tsx (handleSave) + features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:99~213 (18키 '^' bulk) |  | 구현 |
| CRUD:E05:INSERT | [INSERT] §5 InsertRow (F8) — 신규 행 (InsertButton L674~677 → InsertRow, L2866~L3366) | features/demand/src/pages/sales-plan/SalesPlan.tsx:224~ (handleInsert — EDIT_AUTH 게이트) + features/demand/src/pages/sales-plan/useSalesPlanStore.ts |  | 구현 |
| CRUD:E07:SEARCH | [SEARCH] §7 FindData (F5) — 조회 (FindButton L669~672 → FindData L1465~L1650, Draw L1652~L1938) | features/demand/src/pages/sales-plan/useSalesPlanStore.ts:221~ (17 IN + 커서3 fetch) + features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:27~59 |  | 구현 |
| MODAL:MeasureSelectModal | FE 실존 모달 (components/modals/MeasureSelectModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | features/demand/src/pages/sales-plan/components/modals/MeasureSelectModal.tsx (AS-IS btnMeasure_Click L4480 measure 표시 선택 대응) |  | 구현 |
| MODAL:SalesPlanModals | FE 실존 모달 (components/SalesPlanModals.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | features/demand/src/pages/sales-plan/components/SalesPlanModals.tsx (Project/Item/Owner 팝업 wrapper — AS-IS SCM0002/DM0002 대응) |  | 구현 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | features/demand/src/pages/sales-plan/components/SalesPlanModals.tsx (ProjectByDivisionModal·ItemByDivisionModal — AS-IS SCM0002_ProjectbyDivisionPopupEx/DM0002_ItembyDivisionPopupEx) |  | 구현 |

## 1. 조회조건 (AS-IS 컨트롤 20 → 카탈로그 + 인라인)

| # | AS-IS | TO-BE | 상태 |
|---|---|---|---|
| 1 | clbDivision (단일 콤보) | DivisionField (카탈로그 MyDivision) | ✅ |
| 2 | clbTeam | TeamField (TeambyDivision) | ✅ |
| 3 | clbCustomer | 인라인 CustomDropdown — 40='EndCustomerByDivision40' / 비40='EndCustomer' 원천 스왑 | ✅ |
| 4 | clbBizType | 인라인 — 40='DmBizType' / 비40='BizTypeByDivision' 원천 스왑 | ✅ |
| 5 | clbSalesSite | SalesSiteField (SalesSite) | ✅ |
| 6 | clbPlantSite | 인라인 — 'PlantSitebyEndCustomer'(quoting). 40 만 비활성 (카탈로그 PlantSiteField 는 81 전용이라 AS-IS 82 활성과 상이 → 인라인) | ✅ |
| 7 | clbItemType | 인라인 — 'ItemType' | ✅ |
| 8 | cboBucketType (기본 Monthly) | 인라인 — 'BucketType' + fallback 3종. 변경 가드 MSG00227 | ✅ |
| 9 | drpPeriod (PR_GET_DAY_RANGE) | PeriodField + dayRange 시트(o_rc2 당월1일~+6개월 말일) 1회 적용 | ✅ |
| 10 | txtProject + btnProject | ProjectField + ProjectByDivisionModal (40 disabled, multiCheckbox) | ✅ |
| 11 | txtItemId + btnItemId | ItemField + ItemByDivisionModal (multiCheckbox) | ✅ |
| 12 | txtOwner + btnOwner | OwnerField + OwnerByDivisionModal (multiCheckbox) | ✅ |
| 13 | chkSum | Sum 체크박스 — sumYn 즉시 토글 (SP 미호출) | ✅ |
| 14 | chkColor | 제거 (2026-07-14 사용자 확정) — 당주/당월 헤더 강조 + 과거 Gray 기본 고정 | ✅ |
| 15 | InternalYN (숨김) | 숨김 유지 — internalYn='N' 고정 배선 (AS-IS Visible=false 1:1) | ✅ |
| 16 | cboCellQty (dead) | 제외 (완전 dead — 코드 참조 0건) | ✅ |
| 17 | cboKRW/cboUSD/cboLOC (dead 3) | 제외 (금액환산 폐기 잔재) | ✅ |
| 18 | btnColumn / btnMeasure | 커스텀 버튼 2종 (icon-only) → ColumnSettingModal / MeasureSelectModal + titleSet C/M | ✅ |

## 2. 버튼 (AS-IS 11 — 공통 CRUD 6 + 조회조건 버튼 5)

| AS-IS | TO-BE | 상태 |
|---|---|---|
| Find (F5) | hotkeyConfig.search → handleSearch (V-S1~S3 + setFilter — refetch 직접 호출 금지) | ✅ |
| Insert (F8) | hotkeyConfig.insert → handleInsert (EDIT_AUTH_SALESAMT_LOC silent 게이트 + 기본값) | ✅ |
| Delete (F9) | hotkeyConfig.delete → handleDelete (I행만, DB행 silent) | ✅ |
| Edit (F2) | 등록 제외 — 상시편집 + editLock R1~R6 대체 (DMF0003 선례) | ✅ |
| Save (F7) | hotkeyConfig.save → handleSave (16키 '^' bulk, 확인창 없음 1:1) | ✅ |
| Excel (F12) | SubTitle EXCEL 공통 (DefaultButtonActions 자동) | ✅ |
| btnProject/btnItemId/btnOwner | 카탈로그 필드 팝업 (§1) | ✅ |
| btnColumn/btnMeasure | 커스텀 버튼 → 모달 + titleSet 영구 저장 | ✅ |
| Filter/Sort/Condition/Reset | SubTitle 자동 활성 (hook #64) | ✅ |

## 3. 이벤트 핸들러 38 전수 (Designer 25 + 코드배선 5 + BaseForm override 6 + Designer stub/dead 포함 — 상세동작_개발용.md §1 32그룹 1:1)

| # | AS-IS 핸들러 | AS-IS 동작 요약 | TO-BE 구현 | 상태 |
|---:|---|---|---|---|
| 1 | Form_Load (코드배선 L299) | 초기화 체인 — InitControls 콤보 15단계 + CreateSpread + DefineProperty(기본 Monthly) | SalesPlan.tsx mount(useEffect) + useSalesPlanStore initSearch(Monthly) + dayRange 적용 + useTabComboQueries | ✅ |
| 2 | DMF0021_SalesPlan_Load | Designer stub — 빈 본문 (이중 배선 잔재) | 미적용 (AS-IS 자체 no-op) | ✅ |
| 3 | clbDivision_SelectedIndexChanged (코드배선 L554) | Team/BizType/EC/Site/Plant 연쇄 재조회 + div40 비활성/클리어 + 텍스트 3종 클리어 + InitSpread | SalesPlanForm DivisionField onChange (cascade 전면 clear + 원천 스왑) + handleDivisionChange(Grid 초기화·CRUD reset) | ✅ |
| 4 | clbTeam_SelectedIndexChanged (D.803) | End Customer / Sales Site 재조회 (81·82/40 경로 분기) | TeamField onChange — endCustomers/scmSiteIds clear (경로 분기 = EC 콤보 원천 스왑 흡수) | ✅ |
| 5 | clbCustomer_SelectedIndexChanged (D.763) | Sales Site 재조회 | End Customer 인라인 onChange — scmSiteIds clear | ✅ |
| 6 | cboBucketType_SelectedIndexChanged (D.568) | D/W/M 컬럼 표시 전환 + 당주 보더 재계산 + 편집 잠금 재적용 | store bucketType → applyDynVisibility(표시 규칙) + editLock 재평가 (bucketType dep) | ✅ |
| 7 | cboBucketType_Click (D.569) | 편집 중 Bucket 변경 차단 — MSG00227 | SalesPlanForm Bucket onChange 가드 — validateBucketChange(변경분 존재) | ✅ |
| 8 | chkSum_CheckedChanged (D.389) | 상위 버킷 합계 컬럼(M_/W_) 표시 토글 — FE 전용 | Sum 체크박스 → sumYn → summaryBindings visible 토글 (SP 미호출 동일) | ✅ |
| 9 | chkColor_CheckedChanged (D.281) | 과거 회색/당주 보더 강조 방식 전환 | Color 체크박스 제거 (2026-07-14 사용자 확정) — 기본 강조(당주/당월 헤더 Green + 세로 레일 + 과거 Gray) 고정 | ✅ (제거 확정) |
| 10 | cboKRW_SelectedIndexChanged | no-op (금액환산 폐기 잔재 — 본문 주석) | 미적용 (dead) | ✅ |
| 11 | cboUSD_SelectedIndexChanged | no-op (동일) | 미적용 (dead) | ✅ |
| 12 | cboLOC_SelectedIndexChanged | no-op (동일) | 미적용 (dead) | ✅ |
| 13 | txtProject_KeyDown (코드배선 L552) | Enter → Project 팝업 | ProjectField 팝업 버튼 — ⚠ Enter 키 팝업 미지원 (카탈로그 표준, 편차 §6-1) | ⚠ 편차 |
| 14 | txtItemId_KeyDown (코드배선 L553) | Enter → Item 팝업 | ItemField 팝업 버튼 — 동일 편차 (§6-1) | ⚠ 편차 |
| 15 | btnProject_Click (D.499) | Project 팝업 (81·82 만) → txtProject | ProjectField + ProjectByDivisionModal (disabled=40) | ✅ |
| 16 | btnItemId_Click (D.353) | Model 팝업 → txtItemId | ItemField + ItemByDivisionModal | ✅ |
| 17 | btnOwner_Click (D.985) | Owner 팝업 → txtOwner | OwnerField + OwnerByDivisionModal | ✅ |
| 18 | btnColumn_Click (D.463) | TitleSet 팝업(Column) → OK 시 InitSpread | ColumnSettingModal(공용) + saveTitleSet(C) + fetchStaticColumns 재적용 | ✅ |
| 19 | btnMeasure_Click (D.426) | TitleSet 팝업(Measure) → OK 시 재구성 | MeasureSelectModal + saveTitleSet(M) + invalidateQueries 재조회(SP measure 필터) | ✅ |
| 20 | Dsdm_Changed (코드배선 L583) | 가드(잠금/D_/빈 MEASURE 롤백) + 변경 셀 Red + 인접 SUM 터치 | cellEditEnded — V-C3 롤백 + EditTracker 추적(Red = sp-cell-changed) + footer 자동 집계 | ✅ |
| 21 | spdMain_CellDoubleClick (D.158) | 헤더: M_/W_ 하위 접기/펼치기 · 셀: I행 PROJECT_CODE → Project 팝업 / 40+Catch_Up ITEM_ID → Item 팝업 | Grid dblclick — 헤더 드릴(drillVisRef flip) + 셀 분기 → ProjectByDivisionModal / ItemByDivisionModal (I행 한정) | ✅ |
| 22 | spdMain_ComboSelChange (D.159) | 행 내 cascade 6키 + Measure 전환 대규모 재구성 | beginningEdit dataMap 스왑(hook #59 §5-G) + cellEditEnded 원복·계단 clear + R6 applyMeasureSwitch | ✅ |
| 23 | spdMain_ClipboardPasted (D.155) | ITEM_ID 포함 붙여넣기 시 CELL_PROD 콤보 재바인딩 | pastedCell — ITEM_ID 시 dataMap 재부착 + 동적 셀 V-C 공유 | ✅ |
| 24 | spdMain_LeaveCell (D.156) | RTF_SYS_RP 음수 차단(RMA 제외)+정수 절삭 / SalesAmt_LOC 소수3 | cellEditEnded V-C1/V-C2 | ✅ |
| 25 | spdMain_EnterCell (D.157) | 원본값 백업 (배분 델타 잔재) | Wijmo 내장 편집 상태(e.data) 대체 — 별도 구현 불요 | ✅ |
| 26 | spdMain_KeyUp (D.163) | Ctrl+C/V — 숨김열 제외 복사/붙여넣기 (키영역 가드) | FlexGrid 내장 클립보드 + pastingCell 게이트(편집 가드 공유) | ✅ |
| 27 | spdMain_TopChange (D.161) | 스크롤 시 SmartColMerge 재적용 | scrollPositionChanged → invalidate (HierarchicalMergeManager viewport sticky) | ✅ |
| 28 | spdMain_EditModeStarting (D.152) | no-op (진단 잔재) | 미적용 | ✅ |
| 29 | spdMain_EditModeOn (D.153) | no-op | 미적용 | ✅ |
| 30 | spdMain_EditModeOff (D.154) | no-op | 미적용 | ✅ |
| 31 | spdMain_TextChanged (D.162) | no-op | 미적용 | ✅ |
| 32 | spdMain_EditChange (D.160) | no-op | 미적용 | ✅ |
| 33 | FindButton override (L663) | FindData — 검증 4종 + 18p 조회 + 전체잠금 + Draw + SetSpreadColumn | handleSearch — validateFind(V-S1~S3) + setFilter(17키 — sesUserId BE주입) + useTabProcQuery 3커서 소비 | ✅ |
| 34 | InsertButton override (L668) | InsertRow — SalesAmt_LOC 권한 게이트 + 기본값 + 잠금 68종 | handleInsert — editAuth silent 게이트 + 기본값(SalesAmt_LOC/ETC) + R5 화이트리스트 | ✅ |
| 35 | DeleteButton override (L673) | Action='I' 행만 즉시 삭제 (DB행 무동작) | handleDelete — I행만 제거, 그 외 silent (V-D1) | ✅ |
| 36 | EditButton override (L681) | 편집모드 진입 — 필수컬럼/Daily 차단 + 행·버킷·권한 잠금 재계산 | 상시편집 + editLock R1~R4 (진입 개념 제거 — MSG00361 은 Daily 편집 시도 시) | ✅ |
| 37 | SaveButton override (L1110) | SaveData — 검증 2단 + Red 셀 '^' 16키 bulk + 결과 분해 + 재조회(위치 복원) | handleSave — V-V1 + buildUnfoldRows/buildSavePayload + callSaveSalesPlan + 스크롤 복원 (확인창 없음 1:1) | ✅ |
| 38 | ExcelButton override (L1131) | SimplexelService.ExportFpSpread — 숨김열 제외 | SubTitle EXCEL 공통 버튼 (visible 컬럼 export) | ✅ |

## 4. Expressions 120 전행 체크오프 (조건부잠금 112 → editLock R1~R6 / SUM헤더 5 → 3단 헤더 / 합계 3 → footer)

> ⚠ 2026-07-15 사용자 확정: **Grid Footer Summary Visible=false** — 합계 3건(#90~92)의 footer 는 구현 후 숨김 처리
> (columnFooters rows visible=false, Aggregate 미적용). AS-IS 기능은 있었으나 TO-BE 제외. 재활성 시 SalesPlanGrid.tsx footer 블록 복원.

> R1 행 게이트 / R2 버킷 게이트(Daily 전잠금·M↔W 상호배제·D_ 잠금) / R3 기간 cutoff(40 당월≥·비40 M+1·W 당주·Catch_Up M+3·RTF 당월 잠금) /
> R4 과거 잠금(Gray) / R5 Insert 화이트리스트(개방 소수 외 default read-only 붕괴) / R6 Measure 전환 재계산 — `utils/sales-plan.editLock.ts`.

| # | Handler | Kind | Cell/Column | Line | TO-BE 매핑 |
|---:|---|---|---|---:|---|
| 1 | EditButton | 행잠금 | `i, j, i, siMain.GetMaxColumnIndex(` | 994 | R1 — 대상 행 Unlock (evalSalesPlanDynCell measure×권한 게이트) |
| 2 | EditButton | 행잠금 | `i, list_EDIT_Week[x], i, list_EDIT_Week[x], true` | 1001 | R3 — W_ 당주부터(≥) Weekly cutoff |
| 3 | EditButton | 행잠금 | `i, list_EDIT_Month[x], i, list_EDIT_Month[x], true` | 1009 | R3 — M_ Monthly cutoff |
| 4 | EditButton | 행잠금 | `i, j, i, siMain.GetMaxColumnIndex(` | 1015 | R1/R4 — 비대상 행·과거 구간 행 전체 잠금 |
| 5 | EditButton | 행잠금 | `i, j, i, siMain.GetMaxColumnIndex(` | 1020 | R1/R4 — 비대상 행·과거 구간 행 전체 잠금 |
| 6 | EditButton | 행잠금 | `i, j, i, siMain.GetMaxColumnIndex(` | 1025 | R1/R4 — 비대상 행·과거 구간 행 전체 잠금 |
| 7 | EditButton | 행잠금 | `i, j, i, siMain.GetMaxColumnIndex(` | 1041 | R1 — 대상 행 Unlock |
| 8 | EditButton | 행잠금 | `i, list_EDIT_Week[x], i, list_EDIT_Week[x], true` | 1048 | R3 — W_ 당주 cutoff |
| 9 | EditButton | 행잠금 | `i, list_EDIT_Month[x], i, list_EDIT_Month[x], true` | 1060 | R3 — RTF_SYS_RP + Monthly 당월 잠금 |
| 10 | EditButton | 행잠금 | `i, list_EDIT_Month[x], i, list_EDIT_Month[x], true` | 1072 | R3 — Catch_Up M+3 cutoff |
| 11 | EditButton | 행잠금 | `i, j, i, siMain.GetMaxColumnIndex(` | 1077 | R1/R2 — 행·버킷 게이트 잠금 |
| 12 | EditButton | 행잠금 | `i, j, i, siMain.GetMaxColumnIndex(` | 1081 | R1/R2 — 행·버킷 게이트 잠금 |
| 13 | EditButton | 행잠금 | `i, j, i, siMain.GetMaxColumnIndex(` | 1085 | R1/R2 — 행·버킷 게이트 잠금 |
| 14 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2882 | R5 — DIVISION_ID 잠금 (조회조건 자동 세팅) |
| 15 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2895 | R5 — DEPT_ID (40 & ≠Catch_Up 개방) |
| 16 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2935 | R5 — MEASURE (40 개방 + measureInfo 편집 콤보) |
| 17 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2945 | R5/R6 — FCST_TYPE (ETC 고정 — Catch_Up 시 개방) |
| 18 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2950 | R5 — TEAM_INCHARGE read-only (default 잠금 붕괴 규칙) |
| 19 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2952 | R5 — PROJECT_NAME read-only (default 잠금 붕괴 규칙) |
| 20 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2954 | R5 — ProjectStatus read-only (default 잠금 붕괴 규칙) |
| 21 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2956 | R5 — PROJECT_OWNER read-only (default 잠금 붕괴 규칙) |
| 22 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2959 | R5 — BizTypeName read-only (default 잠금 붕괴 규칙) |
| 23 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2963 | R5 — ITEM_CLASS_NAME read-only (default 잠금 붕괴 규칙) |
| 24 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2965 | R5 — ITEM_NAME read-only (default 잠금 붕괴 규칙) |
| 25 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2968 | R5 — ItemType read-only (default 잠금 붕괴 규칙) |
| 26 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2972 | R5 — SALES_COMPANY read-only (default 잠금 붕괴 규칙) |
| 27 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2974 | R5 — SALES_PLANT read-only (default 잠금 붕괴 규칙) |
| 28 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2977 | R5 — NickName read-only (default 잠금 붕괴 규칙) |
| 29 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2980 | R5 — KwhCell read-only (default 잠금 붕괴 규칙) |
| 30 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2983 | R5 — KwhModule read-only (default 잠금 붕괴 규칙) |
| 31 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2986 | R5 — KwhPack read-only (default 잠금 붕괴 규칙) |
| 32 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2989 | R5 — PLANT_SITE_ID (전 Div 잠금 — InsertRow 무조건 lock) |
| 33 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2995 | R5/R6 — DOM_EXP (Catch_Up 시 개방) |
| 34 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3003 | R5 — SALES_PLAN_ADJUST_YN read-only |
| 35 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3005 | R5/R6 — INCOTERMS (Catch_Up 시 개방) |
| 36 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3010 | R5 — OWNER read-only (default 잠금) |
| 37 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3013 | R5 — COUNTRY_NAME read-only (default 잠금) |
| 38 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3015 | R5 — CITY_NAME read-only (default 잠금) |
| 39 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3017 | R5 — FORECAST_INFO_PRODUCT_GROUP read-only (default 잠금) |
| 40 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3019 | R5 — VMI_YN read-only (default 잠금) |
| 41 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3023 | R5 — ProjectName read-only (default 잠금) |
| 42 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3025 | R5 — DistributionChannel read-only (default 잠금) |
| 43 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3027 | R5 — CellName read-only (default 잠금) |
| 44 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3029 | R5 — ShipmentSite read-only (default 잠금) |
| 45 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3036 | R5 — END_CUSTOMER (비40 개방) |
| 46 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3041 | R5 — COMPANY_ID read-only (default 잠금) |
| 47 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3045 | R5 — CUST_GROUP read-only (default 잠금) |
| 48 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3049 | R5 — CUST_GROUP_DTL read-only (default 잠금) |
| 49 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3053 | R5 — APPLICATION read-only (default 잠금) |
| 50 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3057 | R5 — ROUTE read-only (default 잠금) |
| 51 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3061 | R5 — BIZ_TYPE_NAME40 read-only (default 잠금) |
| 52 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3065 | R5 — GROUP_ID read-only (default 잠금) |
| 53 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3069 | R5 — INTERNAL_YN read-only (default 잠금) |
| 54 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3073 | R5 — CELL_TYPE read-only (default 잠금) |
| 55 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3077 | R5 — FORECAST_INFO_CELL_PACK_COUNT read-only (default 잠금) |
| 56 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3081 | R5 — CELL_MODEL_INFO read-only (default 잠금) |
| 57 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3085 | R5 — CELL_MODEL read-only (default 잠금) |
| 58 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3089 | R5 — FORECAST_INFO_ALL read-only (default 잠금) |
| 59 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3093 | R5 — FORECAST_INFO_SPEC read-only (default 잠금) |
| 60 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3097 | R5 — FORECAST_INFOR_VERSION read-only (default 잠금) |
| 61 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3101 | R5 — CELL_MODEL_NICK_NAME read-only (default 잠금) |
| 62 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3105 | R5 — MDM_PROJECT_NAME read-only (default 잠금) |
| 63 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3109 | R5 — MIN_CAPACITY read-only (default 잠금) |
| 64 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3113 | R5 — CELL_PER_CAR read-only (default 잠금) |
| 65 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3117 | R5 — CELL_PER_MODULE read-only (default 잠금) |
| 66 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3121 | R5 — MODULE_PER_CAR read-only (default 잠금) |
| 67 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3125 | R5 — ENERGE read-only (default 잠금) |
| 68 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3129 | R5 — ENERGE_WH read-only (default 잠금) |
| 69 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3133 | R5 — CELL_QUANTITY read-only (default 잠금) |
| 70 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3137 | R5 — DMS_SALES read-only (default 잠금) |
| 71 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3141 | R5 — DMS_CUSTOMER read-only (default 잠금) |
| 72 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3149 | R5 — SCP_USE_YN read-only (default 잠금) |
| 73 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3225 | R2/R3 — insert 행 기간영역(MEASURE+1~) 잠금 = 동적 셀 bucket×cutoff 판정 |
| 74 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3227 | R2/R3 — insert 행 기간영역(MEASURE+1~) 잠금 = 동적 셀 bucket×cutoff 판정 |
| 75 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3235 | R2/R3 — insert 행 기간영역(MEASURE+1~) 잠금 = 동적 셀 bucket×cutoff 판정 |
| 76 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3240 | R2/R3 — insert 행 기간영역(MEASURE+1~) 잠금 = 동적 셀 bucket×cutoff 판정 |
| 77 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3245 | R2/R3 — insert 행 기간영역(MEASURE+1~) 잠금 = 동적 셀 bucket×cutoff 판정 |
| 78 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3252 | R2/R3 — insert 행 기간영역(MEASURE+1~) 잠금 = 동적 셀 bucket×cutoff 판정 |
| 79 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3258 | R2/R3 — insert 행 기간영역(MEASURE+1~) 잠금 = 동적 셀 bucket×cutoff 판정 |
| 80 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3261 | R2/R3 — insert 행 기간영역(MEASURE+1~) 잠금 = 동적 셀 bucket×cutoff 판정 |
| 81 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 3266 | R2/R3 — insert 행 기간영역(MEASURE+1~) 잠금 = 동적 셀 bucket×cutoff 판정 |
| 82 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, …` | 3275 | R2/R3 — 기간 개별 셀 (값 조건 분기) |
| 83 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, …` | 3284 | R2 — 버킷 불일치 셀 잠금 (Monthly↔W_/Weekly↔M_) |
| 84 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, …` | 3293 | R3 — cutoff 개별 셀 잠금 |
| 85 | SetSpreadHeaderSpan | SUM헤더 | `(header)` | 3715 | 3단 nested SUM 헤더 — mainDynamicColumns (M/W 합계 leaf=SUM + Monthly 2·3단 세로 머지) |
| 86 | SetSpreadHeaderSpan | SUM헤더 | `(header)` | 3721 | 3단 nested SUM 헤더 — mainDynamicColumns (M/W 합계 leaf=SUM + Monthly 2·3단 세로 머지) |
| 87 | SetSpreadHeaderSpan | SUM헤더 | `(header)` | 3729 | 3단 nested SUM 헤더 — mainDynamicColumns (M/W 합계 leaf=SUM + Monthly 2·3단 세로 머지) |
| 88 | SetSpreadHeaderSpan | SUM헤더 | `(header)` | 3741 | 3단 nested SUM 헤더 — mainDynamicColumns (M/W 합계 leaf=SUM + Monthly 2·3단 세로 머지) |
| 89 | SetSpreadHeaderSpan | SUM헤더 | `(header)` | 3743 | 3단 nested SUM 헤더 — mainDynamicColumns (M/W 합계 leaf=SUM + Monthly 2·3단 세로 머지) |
| 90 | Dsdm_Changed | 합계변수 | `iMonthlySum` | 3990 | footer Sum — columnFooters Aggregate.Sum (SUM 셀 터치 재기입 불필요 — Wijmo 자동 집계) |
| 91 | Dsdm_Changed | 합계변수 | `iMonthlySum` | 3995 | footer Sum — columnFooters Aggregate.Sum (SUM 셀 터치 재기입 불필요 — Wijmo 자동 집계) |
| 92 | Dsdm_Changed | 합계변수 | `iMonthlySum` | 4001 | footer Sum 표시 — formatItem ColumnFooter #,##0.### 포맷 |
| 93 | spdMain_ComboSelChange | 행잠금 | `e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID` | 4544 | R5 — PLANT_SITE_ID 81 unlock (Division 셀 변경 전용 경로 — 신규행 미도달, 잠금 유지) |
| 94 | spdMain_ComboSelChange | 행잠금 | `e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID` | 4546 | R5 — PLANT_SITE_ID 비81 lock |
| 95 | spdMain_ComboSelChange | 행잠금 | `e.Row, siMain.GetColumnIndex(DefColumns.DomExp` | 4877 | R6 — DOM_EXP 개방 (Catch_Up 전환) |
| 96 | spdMain_ComboSelChange | 행잠금 | `e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID` | 4887 | R5 — PLANT_SITE_ID 잠금 |
| 97 | spdMain_ComboSelChange | 행잠금 | `e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS` | 4896 | R6 — INCOTERMS 개방 (Catch_Up) |
| 98 | spdMain_ComboSelChange | 행잠금 | `e.Row, siMain.GetColumnIndex(DefColumns.FcstType` | 4903 | R6 — FCST_TYPE 개방 (ETC 제외 편집 콤보 buildCatchUpFcstTypeMap) |
| 99 | spdMain_ComboSelChange | 행잠금 | `e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID` | 4911 | R6 — DEPT_ID 잠금 (Catch_Up 시 insertStaticEditable false) |
| 100 | spdMain_ComboSelChange | 행잠금 | `siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, …` | 4926 | R5 — ITEM_ID 개방 (콤보/텍스트) |
| 101 | spdMain_ComboSelChange | 행잠금 | `siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, …` | 4930 | R5 — ITEM_ID 잠금 (40+Catch_Up 모달 전용) |
| 102 | spdMain_ComboSelChange | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 4936 | R2/R3 — 기간영역 재잠금 (Measure 전환 후 재평가) |
| 103 | spdMain_ComboSelChange | 행잠금 | `e.Row, siMain.GetColumnIndex(DefColumns.FcstType` | 4947 | R6 — FCST_TYPE ETC 고정+잠금 (SalesAmt_LOC 복귀 applyMeasureSwitch) |
| 104 | spdMain_ComboSelChange | 행잠금 | `e.Row, siMain.GetColumnIndex(DefColumns.DomExp` | 4953 | R6 — DOM_EXP 잠금 (SalesAmt_LOC 복귀) |
| 105 | spdMain_ComboSelChange | 행잠금 | `e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS` | 4959 | R6 — INCOTERMS 잠금 (SalesAmt_LOC 복귀) |
| 106 | spdMain_ComboSelChange | 행잠금 | `e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID` | 4967 | R6 — DEPT_ID 개방 (SalesAmt_LOC 복귀) |
| 107 | spdMain_ComboSelChange | 행잠금 | `e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID` | 4987 | R5 — PLANT_SITE_ID 잠금 |
| 108 | spdMain_ComboSelChange | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 4993 | R6 + R2/R3 — Measure 전환 후 기간영역 재평가 (cutoff 스왑 = evalSalesPlanDynCell 이 row.MEASURE 실시간 참조 + 입력 clear) |
| 109 | spdMain_ComboSelChange | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 4998 | R6 + R2/R3 — Measure 전환 후 기간영역 재평가 (cutoff 스왑 = evalSalesPlanDynCell 이 row.MEASURE 실시간 참조 + 입력 clear) |
| 110 | spdMain_ComboSelChange | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 5000 | R6 + R2/R3 — Measure 전환 후 기간영역 재평가 (cutoff 스왑 = evalSalesPlanDynCell 이 row.MEASURE 실시간 참조 + 입력 clear) |
| 111 | spdMain_ComboSelChange | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 5007 | R6 + R2/R3 — Measure 전환 후 기간영역 재평가 (cutoff 스왑 = evalSalesPlanDynCell 이 row.MEASURE 실시간 참조 + 입력 clear) |
| 112 | spdMain_ComboSelChange | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 5010 | R6 + R2/R3 — Measure 전환 후 기간영역 재평가 (cutoff 스왑 = evalSalesPlanDynCell 이 row.MEASURE 실시간 참조 + 입력 clear) |
| 113 | spdMain_ComboSelChange | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 5016 | R6 + R2/R3 — Measure 전환 후 기간영역 재평가 (cutoff 스왑 = evalSalesPlanDynCell 이 row.MEASURE 실시간 참조 + 입력 clear) |
| 114 | spdMain_ComboSelChange | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 5022 | R6 + R2/R3 — Measure 전환 후 기간영역 재평가 (cutoff 스왑 = evalSalesPlanDynCell 이 row.MEASURE 실시간 참조 + 입력 clear) |
| 115 | spdMain_ComboSelChange | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 5025 | R6 + R2/R3 — Measure 전환 후 기간영역 재평가 (cutoff 스왑 = evalSalesPlanDynCell 이 row.MEASURE 실시간 참조 + 입력 clear) |
| 116 | spdMain_ComboSelChange | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 5030 | R6 + R2/R3 — Measure 전환 후 기간영역 재평가 (cutoff 스왑 = evalSalesPlanDynCell 이 row.MEASURE 실시간 참조 + 입력 clear) |
| 117 | spdMain_ComboSelChange | 행잠금 | `siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, …` | 5039 | R2/R3 — 기간 개별 셀 잠금 재평가 (버킷/값 조건 분기) |
| 118 | spdMain_ComboSelChange | 행잠금 | `siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, …` | 5047 | R2/R3 — 기간 개별 셀 잠금 재평가 (버킷/값 조건 분기) |
| 119 | spdMain_ComboSelChange | 행잠금 | `siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, …` | 5056 | R2/R3 — 기간 개별 셀 잠금 재평가 (버킷/값 조건 분기) |
| 120 | spdMain_ComboSelChange | 행잠금 | `siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, …` | 5075 | R2/R3 — 기간 개별 셀 잠금 재평가 (버킷/값 조건 분기) |

## 5. Validation 141 전행 체크오프

> 활성 메시지 20 + silent 38 + 잠금 22(→editLock) + 사업부분기 계수(→division/editLock) + 비활성(주석) — UI분석서 시트 6 재분류와 정합.
> MSG 재매핑(사내 실문구 대사 2026-07-14): AS-IS MSG00002(필수)→MSG00429 / MSG00004({0}건 저장)→MSG00002(성공) / 변경0건→MSG00004.
> MSG 재매핑 추가(2026-09-10 사용자 요구): AS-IS MSG00146(라인 변경 0건)→사내 MSG00670. 단일 원천 = sales-plan.constants.ts MSG.LINE_NO_CHANGE.

| # | Handler | MsgID | Column | Line | TO-BE 매핑 |
|---:|---|---|---|---:|---|
| 1 | SpdMain_ClipboardPasted | - | Division | 335 | SalesPlanGrid pastedCell — ITEM_ID 붙여넣기 시 CELL_PROD 콤보 dataMap 재부착 (division 필터 = 콤보 rows DIVISION_ID) |
| 2 | SpdMain_ClipboardPasted | - | Division | 337 | SalesPlanGrid pastedCell — ITEM_ID 붙여넣기 시 CELL_PROD 콤보 dataMap 재부착 (division 필터 = 콤보 rows DIVISION_ID) |
| 3 | SpdMain_ClipboardPasted | - | Division | 339 | SalesPlanGrid pastedCell — ITEM_ID 붙여넣기 시 CELL_PROD 콤보 dataMap 재부착 (division 필터 = 콤보 rows DIVISION_ID) |
| 4 | SpdMain_ClipboardPasted | - | Division | 342 | SalesPlanGrid pastedCell — ITEM_ID 붙여넣기 시 CELL_PROD 콤보 dataMap 재부착 (division 필터 = 콤보 rows DIVISION_ID) |
| 5 | InitControls | - | Division | 440 | SalesPlanForm — div40 분기 (PlantSite/Project 비활성 + EC40/DmBizType 원천 스왑) |
| 6 | txtProject_KeyDown | - | txtProject | 557 | ProjectField(카탈로그) 팝업 버튼 — ⚠ Enter 키 팝업은 카탈로그 미지원 (편차 §6-1) |
| 7 | txtItemId_KeyDown | - | txtItemId | 565 | ItemField(카탈로그) 팝업 버튼 — ⚠ Enter 키 편차 동일 (§6-1) |
| 8 | EditButton | - | - | 683 | 해당없음 — 상시편집 (fps null 가드 = 프레임워크 대체) |
| 9 | EditButton | - | Division | 690 | 비활성(주석) — 미이관 |
| 10 | EditButton | MSG00109 | - | 693 | 비활성(주석 MSG00109 — [PJ2024-50611] 40 편집차단 제거) — 미이관 |
| 11 | EditButton | - | Division | 697 | editLock/division — divisionKindOf(startsWith 81) 분기 |
| 12 | EditButton | - | DIVISION_ID | 703 | 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |
| 13 | EditButton | - | PROJECT_CODE | 704 | 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |
| 14 | EditButton | - | END_CUSTOMER40 | 705 | 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |
| 15 | EditButton | - | END_CUSTOMER | 706 | 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |
| 16 | EditButton | - | SCM_SITE_ID | 707 | 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |
| 17 | EditButton | - | ITEM_ID | 708 | 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |
| 18 | EditButton | - | TEXT | 709 | 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |
| 19 | EditButton | - | DomExp | 710 | 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |
| 20 | EditButton | - | FcstType | 711 | 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |
| 21 | EditButton | - | INCOTERMS | 712 | 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |
| 22 | EditButton | - | MEASURE | 713 | 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |
| 23 | EditButton | - | CURRENCY | 714 | 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |
| 24 | EditButton | - | DEPT_ID | 715 | 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |
| 25 | EditButton | - | CELL_PROD_SITE_ID | 716 | 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |
| 26 | EditButton | - | DEPT_ID | 720 | 해당없음 — 컬럼 존재 = 메타 보장 (V-V1 대체) |
| 27 | EditButton | - | Division | 720 | requiredFieldsFor — DEPT_ID 40 & ≠Catch_Up 분기 |
| 28 | EditButton | MSG00429 | - | 722 | validateSaveRows MSG00429 {Team} (V-V1) |
| 29 | EditButton | - | CELL_PROD_SITE_ID | 724 | 해당없음 — CELL_PROD_SITE_ID 컬럼 존재 = 메타 보장. 값 검증 = V-V1(40) |
| 30 | EditButton | - | Division | 724 | 해당없음 — CELL_PROD_SITE_ID 컬럼 존재 = 메타 보장. 값 검증 = V-V1(40) |
| 31 | EditButton | MSG00113 | - | 726 | MSG00113 — 컬럼 존재 = 메타 보장 (V-V1 값 검증으로 대체) |
| 32 | EditButton | MSG00113 | - | 730 | MSG00113 — 컬럼 존재 = 메타 보장 (V-V1 값 검증으로 대체) |
| 33 | EditButton | - | Division | 763 | editLock R3 — M_ 40=당월 포함(≥) |
| 34 | EditButton | - | Division | 900 | editLock R3 — i_EditStartCol 40 분기 (evalSalesPlanDynCell) |
| 35 | EditButton | MSG00361 | - | 1103 | MSG00361 — Grid beginningEdit Daily 차단 + handleInsert Daily 가드 |
| 36 | ExportExcel | - | - | 1207 | 해당없음 — 구 ExportExcel 미사용 경로 (SubTitle EXCEL 공통 대체) |
| 37 | ExportExcel | - | - | 1370 | 해당없음 — 구 ExportExcel 미사용 경로 (SubTitle EXCEL 공통 대체) |
| 38 | ExportExcel | MSG00003 | - | 1434 | MSG00003 — 구경로 미사용 (공통 오류 처리 대체) |
| 39 | FindData | MSG00137 | - | 1460 | MSG00137 — react-query queryKey 직렬화 (재진입 중복 fetch 없음) — 프레임워크 대체 |
| 40 | FindData | MSG00108 | - | 1474 | validateFind V-S2 (MSG00108) |
| 41 | FindData | MSG00164 | - | 1481 | validateFind V-S3 (MSG00164 + 종료일 시작일+3년 보정 adjustedEnd) |
| 42 | FindData | MSG00097 | - | 1513 | validateFind V-S1 (MSG00097) |
| 43 | FindData | - | - | 1563 | silent 동일 — 0행 = 빈 그리드 |
| 44 | FindData | - | - | 1656 | 해당없음 — AS-IS Draw 내부 인덱스 가드 (Wijmo 렌더러 대체) |
| 45 | SaveData | MSG00137 | - | 1933 | MSG00137 — handleSave await 단일 실행 (재진입 없음) — 프레임워크 대체 |
| 46 | SaveData | - | DIVISION_ID | 2007 | 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |
| 47 | SaveData | - | PROJECT_CODE | 2008 | 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |
| 48 | SaveData | - | END_CUSTOMER40 | 2009 | 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |
| 49 | SaveData | - | END_CUSTOMER | 2010 | 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |
| 50 | SaveData | - | SCM_SITE_ID | 2011 | 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |
| 51 | SaveData | - | ITEM_ID | 2012 | 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |
| 52 | SaveData | - | TEXT | 2013 | 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |
| 53 | SaveData | - | FcstType | 2015 | 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |
| 54 | SaveData | - | INCOTERMS | 2016 | 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |
| 55 | SaveData | - | MEASURE | 2017 | 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |
| 56 | SaveData | - | CURRENCY | 2018 | 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |
| 57 | SaveData | - | DEPT_ID | 2019 | 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |
| 58 | SaveData | - | CELL_PROD_SITE_ID | 2022 | 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |
| 59 | SaveData | MSG00113 | - | 2024 | MSG00113 — 컬럼 존재 = 메타 보장 (V-V1 대체) |
| 60 | SaveData | - | Division | 2198 | requiredFieldsFor 13종 division×measure 분기 (V-V1) |
| 61 | SaveData | - | Division | 2209 | requiredFieldsFor 13종 division×measure 분기 (V-V1) |
| 62 | SaveData | - | Division | 2211 | requiredFieldsFor 13종 division×measure 분기 (V-V1) |
| 63 | SaveData | - | Division | 2221 | requiredFieldsFor 13종 division×measure 분기 (V-V1) |
| 64 | SaveData | - | Division | 2223 | requiredFieldsFor 13종 division×measure 분기 (V-V1) |
| 65 | SaveData | - | Division | 2226 | requiredFieldsFor 13종 division×measure 분기 (V-V1) |
| 66 | SaveData | - | Division | 2228 | requiredFieldsFor 13종 division×measure 분기 (V-V1) |
| 67 | SaveData | - | Division | 2230 | requiredFieldsFor 13종 division×measure 분기 (V-V1) |
| 68 | SaveData | - | Division | 2232 | requiredFieldsFor 13종 division×measure 분기 (V-V1) |
| 69 | SaveData | - | Division | 2234 | requiredFieldsFor 13종 division×measure 분기 (V-V1) |
| 70 | SaveData | MSG00002 | - | 2239 | validateSaveRows MSG00429 {필드} + 행번호 병기 (V-V1) |
| 71 | SaveData | MSG00043 | - | 2267 | SP 위임 — SAVE 결과 messageCode^addmessage alert (callSaveSalesPlan. 중복검증 SP 내장) |
| 72 | SaveData | - | Division | 2344 | sales-plan.save readProjectSlot — 40=END_CUSTOMER40 슬롯 (p_project_code) |
| 73 | SaveData | - | Division | 2380 | sales-plan.save identityOf — plantSiteId (81 소스 유지) |
| 74 | SaveData | MSG00002 | - | 2453 | V-V1 — Sales Site (MSG00429 {Sales Site}) |
| 75 | SaveData | MSG00002 | - | 2461 | V-V1 — Customs Handbook (Catch_Up 분기) |
| 76 | SaveData | MSG00002 | - | 2472 | V-V1 — Currency |
| 77 | SaveData | - | Division | 2577 | buildUnfoldRows — 40+Catch_Up 분기 |
| 78 | SaveData | MSG00085 | - | 2587 | buildUnfoldRows — MSG00085 {0} (Catch_Up 음수 차단) |
| 79 | SaveData | MSG00146 | - | 2666 | buildUnfoldRows — MSG00670 {line} (라인 변경 0건. 사내 문구 대사 재매핑, AS-IS MSG00146) |
| 80 | SaveData | MSG00428 | - | 2743 | callSaveSalesPlan — SP 반환 messageCode 분해 alert (MSG00428 등 SP 코드) |
| 81 | SaveData | - | - | 2760 | callSaveSalesPlan — SP 원문 addMessage alert (MessageBox.Show 경로 대체) |
| 82 | SaveData | - | - | 2766 | callSaveSalesPlan — SP 원문 addMessage alert (MessageBox.Show 경로 대체) |
| 83 | SaveData | - | - | 2788 | callSaveSalesPlan — SP 원문 addMessage alert (MessageBox.Show 경로 대체) |
| 84 | SaveData | MSG00004 | - | 2794 | handleSave 성공 — MSG00002 toast(사내 문구 대사 재매핑, AS-IS MSG00004 {0}건 용법) + 재조회·스크롤 복원 |
| 85 | InsertRow | - | - | 2854 | handleInsert — EDIT_AUTH_SALESAMT_LOC≠Y silent return (AS-IS 동일 silent) |
| 86 | InsertRow | - | Division | 2888 | editLock R5 — DEPT_ID 40 만 개방 |
| 87 | InsertRow | - | Division | 2933 | editLock R5 — MEASURE 40 만 개방 (비40 잠금) |
| 88 | InsertRow | - | Division | 3034 | 비활성(주석) — 미이관 |
| 89 | InsertRow | - | Division | 3233 | editLock R3 — insert 행 40 분기 |
| 90 | InsertRow | - | Division | 3237 | editLock R2/R3 — Monthly×40 insert 기간 잠금 |
| 91 | InsertRow | - | Division | 3242 | editLock R2/R3 — Weekly×40 insert 기간 잠금 |
| 92 | InsertRow | - | Division | 3251 | editLock R5 — 40 분기 |
| 93 | InsertRow | - | Division | 3303 | ITEM_ID insert 콤보 GUBUN 분기 — ⚠ CMBO(SALES_PLAN_ITEM_ID) 미등록 → 텍스트 입력 폴백 (편차 §6-2) |
| 94 | InsertRow | - | Division | 3305 | ITEM_ID insert 콤보 GUBUN 분기 — ⚠ CMBO(SALES_PLAN_ITEM_ID) 미등록 → 텍스트 입력 폴백 (편차 §6-2) |
| 95 | InsertRow | - | Division | 3307 | ITEM_ID insert 콤보 GUBUN 분기 — ⚠ CMBO(SALES_PLAN_ITEM_ID) 미등록 → 텍스트 입력 폴백 (편차 §6-2) |
| 96 | InsertRow | - | Division | 3310 | ITEM_ID insert 콤보 GUBUN 분기 — ⚠ CMBO(SALES_PLAN_ITEM_ID) 미등록 → 텍스트 입력 폴백 (편차 §6-2) |
| 97 | btnProject_Click | - | Division | 3491 | ProjectField disabled(40) — 81·82 만 팝업 (SalesPlanForm) |
| 98 | spdMain_CellDoubleClick | - | - | 3772 | Grid 헤더 드릴 flip — visible 가드 동일 (hideOnly) |
| 99 | spdMain_CellDoubleClick | - | Division | 3863 | Grid dblclick — 40+Catch_Up ITEM_ID 셀 → ItemByDivisionModal |
| 100 | Dsdm_Changed | - | - | 3926 | 해당없음 — Wijmo 이벤트 인덱스 보장 (프레임워크 대체) |
| 101 | Dsdm_Changed | - | - | 3941 | cellEditEnded V-C3 — MEASURE 빈 행 숫자 입력 롤백 |
| 102 | fnValidation | - | Division | 4163 | dead — fnValidation 중복검증 SP 이관 [PJ2024-50611] (미이관 — SP 결과 alert 대체) |
| 103 | fnValidation | - | Division | 4190 | dead — fnValidation 중복검증 SP 이관 [PJ2024-50611] (미이관 — SP 결과 alert 대체) |
| 104 | fnValidation | - | Division | 4195 | dead — fnValidation 중복검증 SP 이관 [PJ2024-50611] (미이관 — SP 결과 alert 대체) |
| 105 | fnValidation | - | Division | 4197 | dead — fnValidation 중복검증 SP 이관 [PJ2024-50611] (미이관 — SP 결과 alert 대체) |
| 106 | fnValidation | - | Division | 4214 | dead — fnValidation 중복검증 SP 이관 [PJ2024-50611] (미이관 — SP 결과 alert 대체) |
| 107 | fnValidation | - | Division | 4216 | dead — fnValidation 중복검증 SP 이관 [PJ2024-50611] (미이관 — SP 결과 alert 대체) |
| 108 | fnValidation | - | Division | 4247 | dead — fnValidation 중복검증 SP 이관 [PJ2024-50611] (미이관 — SP 결과 alert 대체) |
| 109 | fnValidation | - | - | 4263 | dead — fnValidation 중복검증 SP 이관 [PJ2024-50611] (미이관 — SP 결과 alert 대체) |
| 110 | spdMain_TextChanged | - | spdMain | 4400 | no-op(본문 주석) — 미이관 |
| 111 | spdMain_EditChange | - | spdMain | 4407 | no-op(본문 주석) — 미이관 |
| 112 | GetThisWeekMonday | - | - | 4478 | 해당없음 — cutoff 기준 = MAIN 커서 2(서버 기준일). 클라 월요일 계산 미사용 |
| 113 | spdMain_ComboSelChange | - | Division | 4541 | editLock R5 — PLANT_SITE_ID 잠금 유지(Division 셀 변경 전용 unlock — 신규행 미도달) (DIVISION 셀은 insert 잠금 — 조회조건 고정) |
| 114 | spdMain_ComboSelChange | - | Division | 4543 | editLock R5 — PLANT_SITE_ID 잠금 유지(Division 셀 변경 전용 unlock — 신규행 미도달) (DIVISION 셀은 insert 잠금 — 조회조건 고정) |
| 115 | spdMain_ComboSelChange | - | Division | 4553 | ITEM_ID insert 콤보 GUBUN 분기 — CMBO 미등록 텍스트 폴백 (편차 §6-2) |
| 116 | spdMain_ComboSelChange | - | Division | 4555 | ITEM_ID insert 콤보 GUBUN 분기 — CMBO 미등록 텍스트 폴백 (편차 §6-2) |
| 117 | spdMain_ComboSelChange | - | Division | 4557 | ITEM_ID insert 콤보 GUBUN 분기 — CMBO 미등록 텍스트 폴백 (편차 §6-2) |
| 118 | spdMain_ComboSelChange | - | Division | 4560 | ITEM_ID insert 콤보 GUBUN 분기 — CMBO 미등록 텍스트 폴백 (편차 §6-2) |
| 119 | spdMain_ComboSelChange | - | Division | 4615 | 비활성(주석 — DEPT_ID 셀 분기 전량 주석 no-op [PJ2024-50611]) — 미이관 |
| 120 | spdMain_ComboSelChange | - | Division | 4617 | 비활성(주석 — DEPT_ID 셀 분기 전량 주석 no-op [PJ2024-50611]) — 미이관 |
| 121 | spdMain_ComboSelChange | - | Division | 4619 | 비활성(주석 — DEPT_ID 셀 분기 전량 주석 no-op [PJ2024-50611]) — 미이관 |
| 122 | spdMain_ComboSelChange | - | Division | 4622 | 비활성(주석 — DEPT_ID 셀 분기 전량 주석 no-op [PJ2024-50611]) — 미이관 |
| 123 | spdMain_ComboSelChange | - | Division | 4655 | GRID_CASCADE_CLEAR END_CUSTOMER + ITEM 콤보 dataMap 재부착 |
| 124 | spdMain_ComboSelChange | - | Division | 4657 | GRID_CASCADE_CLEAR END_CUSTOMER + ITEM 콤보 dataMap 재부착 |
| 125 | spdMain_ComboSelChange | - | Division | 4659 | GRID_CASCADE_CLEAR END_CUSTOMER + ITEM 콤보 dataMap 재부착 |
| 126 | spdMain_ComboSelChange | - | Division | 4662 | GRID_CASCADE_CLEAR END_CUSTOMER + ITEM 콤보 dataMap 재부착 |
| 127 | spdMain_ComboSelChange | - | Division | 4692 | GRID_CASCADE_CLEAR END_CUSTOMER40 (40 Catch_Up 제외 — ITEM 모달 전용 R5) |
| 128 | spdMain_ComboSelChange | - | Division | 4694 | GRID_CASCADE_CLEAR END_CUSTOMER40 (40 Catch_Up 제외 — ITEM 모달 전용 R5) |
| 129 | spdMain_ComboSelChange | - | Division | 4696 | GRID_CASCADE_CLEAR END_CUSTOMER40 (40 Catch_Up 제외 — ITEM 모달 전용 R5) |
| 130 | spdMain_ComboSelChange | - | Division | 4699 | GRID_CASCADE_CLEAR END_CUSTOMER40 (40 Catch_Up 제외 — ITEM 모달 전용 R5) |
| 131 | spdMain_ComboSelChange | - | Division | 4714 | GRID_CASCADE_CLEAR SCM_SITE_ID (하위 Project/Item/Text/ItemClass clear) |
| 132 | spdMain_ComboSelChange | - | Division | 4716 | GRID_CASCADE_CLEAR SCM_SITE_ID (하위 Project/Item/Text/ItemClass clear) |
| 133 | spdMain_ComboSelChange | - | Division | 4718 | GRID_CASCADE_CLEAR SCM_SITE_ID (하위 Project/Item/Text/ItemClass clear) |
| 134 | spdMain_ComboSelChange | - | Division | 4721 | GRID_CASCADE_CLEAR SCM_SITE_ID (하위 Project/Item/Text/ItemClass clear) |
| 135 | spdMain_ComboSelChange | - | Division | 4846 | editLock R3 — 40 SalesAmt_LOC 당월 포함(≥) |
| 136 | spdMain_ComboSelChange | - | Division | 5005 | R6 — applyMeasureSwitch 40 분기 (Catch_Up↔SalesAmt_LOC) |
| 137 | spdMain_ComboSelChange | - | Division | 5015 | R6 — applyMeasureSwitch 40 분기 (Catch_Up↔SalesAmt_LOC) |
| 138 | clbDivision_SelectedIndexChanged | - | Division | 5120 | SalesPlanForm — Division onChange 40 분기 (원천 스왑 + 비활성 + cascade clear) |
| 139 | clbTeam_SelectedIndexChanged | - | Division | 5299 | SalesPlanForm — Team cascade (81·82/40 경로 = EC 콤보 원천 스왑으로 흡수) |
| 140 | cboBucketType_Click | MSG00227 | - | 5475 | validateBucketChange — MSG00227 (변경분 존재 시 Bucket 차단) |
| 141 | cboBucketType_Click | MSG00227 | - | 5483 | validateBucketChange — MSG00227 (변경분 존재 시 Bucket 차단) |

## 6. 편차 · 미결 (정직 보고)

1. **Enter 키 팝업 (§6-1)** — AS-IS txtProject/txtItemId KeyDown Enter → 팝업. 카탈로그 PopupSearchInput 은 버튼 클릭만 지원 (shared 컴포넌트 무수정 원칙 — 전 화면 공통 개선 시 일괄).
2. **ITEM_ID insert 콤보 (§6-2)** — 해소(2026-09-02 재적용). AS-IS SALES_PLAN_ITEM_ID(GUBUN 40/81/82 필터) in-memory 콤보를 CMBO 'SalesPlanItemId'(@divisionId) 로 등재하고, SalesPlanGrid `insertOnlyDataMaps` 가 화면에서 직접 붙인다. 컬럼 메타(SHEET_COLUMNS)는 FPText 그대로 둔다 — FPComboBox 로 바꾸면 조회 행까지 콤보가 되어 AS-IS(조회=텍스트)와 어긋난다. 구현은 beginningEdit 스왑이 아니라 컬럼 dataMap 1개 + `getDisplayValues` 가 CRUD_TYPE='I' 행에만 후보를 돌려주는 방식이다(MEASURE/FCST_TYPE 선례). 부착은 updatedLayout — columnGroups 재대입마다 Column 이 재생성돼 dataMap 이 날아가기 때문. 40+Catch_Up 은 종전대로 모달 1:1.
3. **CURRENCY insert 콤보** — 해소(2026-09-02 재적용). AS-IS 는 신규행 셀만 SetCellTypeCombo(dtCurrencyList, .cs L3032~3036, 직전 LockRange 는 주석 처리)로 승격하고 조회 행은 텍스트다. ITEM_ID 와 같은 방식으로 컬럼 메타 등록 없이 SalesPlanGrid `insertOnlyDataMaps` 가 CMBO 'CurrencyList'(바인드 없음) 를 붙인다. AS-IS 원천이 Data.Common(CURRENCY_LIST) 전역 목록(.cs L528)이라 division 분기는 없다.

   AS-IS 신규행 콤보 전수(2026-09-02 재검증, DMF0021_SalesPlan.cs 5,643줄 정본 + 주석 블록 제외): DEPT_ID(L2923, 40 한정 — 통합테스트 1st No.61-④ 로 TO-BE 는 잠금 유지) / CELL_PROD_SITE_ID(L2946) / END_CUSTOMER(L2951) / END_CUSTOMER40(L4547 cascade) / SCM_SITE_ID(L2952) / MEASURE(L2957) / DOM_EXP(L4910) / INCOTERMS(L4930) / FCST_TYPE(L4940) = 9종은 컬럼 메타 콤보로 기충족. 미충족은 ITEM_ID·CURRENCY 2종뿐이었다. PROJECT_CODE(L2974) 와 40+Catch_Up 의 ITEM_ID(L4905) 는 콤보가 아니라 cellTypeImage 모달이라 대상 아님. PLANT_SITE_ID Catch_Up 콤보(L4920~4929, L5022~5029)는 AS-IS 에서 블록 전체가 주석 처리라 이관 대상 아님.
4. **MEASURE 강제 표시** — 사내 SHEET_COLUMNS VISIBLE_FLAG='N' 실측이나 PIVOT 행 식별 키 컬럼 → 강제 표시 (admin 메타 정정 시 제거).
5. **W_ 저장 기준일** — SAVE p_yyyymmdd 를 W_yyyymm+ww → ISO주 월요일(월경계 clamp) 로 산출 (AS-IS B_* 숨김 컬럼 값 미확보 — E2E 저장 왕복 1회 검증 필요).
6. **MSG00085/00146/00361 문구** — 사내 MSG_M [TODO] placeholder. 계약 확정 용법으로 locales 3종 반영 (MSG00361 본문은 잠정 — MSG_M 등록 시 대사). locale JSON 은 gitignore(DB 원천) — 사내 MSG_M 반영 별도.
7. **멀티선택 구분자** — MAIN 조회 콤보 = 콤마 + 'ALL' sentinel (AS-IS CheckedList/DMF0082 계열 준용). SP REGEXP 패턴 실측 대사 1회 권장.
8. **NOTATION 'POINT' 소수 자릿수** — AS-IS 포맷 마스크 미실측 → 최대 1자리 가정 (INTEGER=0/POINT3=3 고정). E2E 82 division 표기 확인.
9. **vitest 환경** — 로컬 node v24 + jsdom 비호환(MIMEType is not a constructor)으로 스토어 테스트 실행 불가 (기존 forecast-price 테스트도 동일 실패 — 사전 존재 환경 이슈).

## 8. 최신분석(2026-07-20) 결재분 반영 (2026-07-21)

FE 는 2026-07-15 UI분석서 v1.0 기준 빌드 → 이후 전수실측(제약매트릭스/주요이벤트) 이 명세한 두 결재분 반영:

| 결재 | 항목 | 반영 | 파일 |
|---|---|---|---|
| **[E20260331-000648]** | SalesAmt_LOC 편집 = FCST_TYPE='ETC' 행만 (AS-IS L968) | ✅ measureGate 조건 추가(기존 비-ETC 행 잠금) | `utils/sales-plan.editLock.ts` |
| **[E20260331-000648]** | RTF_SYS_RP 편집 = div 40 또는 81 만 (40→+81 확장, AS-IS L1041-1045) | ✅ measureGate division 게이트 추가 → **82 잘못열림 차단** | `utils/sales-plan.editLock.ts` |
| **[E20260512-000502]** | 저장 p_cell_prod_site_id ← 81=FROM_SITE_ID (AS-IS L2466-2475 덮어쓰기) | ✅ identityOf 81 분기 (미치환 시 81 저장 손상) | `utils/sales-plan.save.ts` |
| **[E20260512-000502]** | FROM_SITE_ID 컬럼 81 표시(display-only) + 컬럼-존재 체크(MSG00113) | ✅ SHEET_COLUMNS 81 행 등록(사내 적용) — GET SP(L1575-1576)는 기반환·SP 무변경 | `_artifacts/_apply_corporate/DMF0021_fromSiteId_meta_20260721.sql` |

⚠️ **AS-IS 실측 교정**: FROM_SITE_ID / PLANT_SITE_ID 는 **값-필수 아님** — AS-IS 활성 SaveData 루프(L2225+) 는 FROM_SITE_ID 미검사, PLANT_SITE_ID 는 `//p_plant_site_id == ""` 주석. L723/L2043 은 컬럼-존재 체크(MSG00113)로 메타 등록(위 4행)으로 충족. → requiredFieldsFor 값-필수 13종 무변경.

## 7. 게이트 결과 (2026-07-15)

- features/demand tsc --noEmit 0 errors / eslint 0 errors (warnings 5 = mkt-fcst 원본 동일 패턴: scss 상대 상위 import 2 + non-null 3) / 진입 SalesPlan.tsx 399줄(≤400 — SalesPlanModals 분리)
- apps/web tsc 0 errors (route-paths/Router/procedures.d.ts 배선분)
- 배선 4점: route-paths(DMF0021=sales-plan) / Router(DEMAND_PLAN children) / procedures.d.ts(DMF0021 5시트) / locales(MSG00085·00146·00361)
- BE 무수정 / 기존 화면 파일 수정 = 배선 4점만 (mkt-fcst/forecast-price 무수정 — merge 1단계 복제)

## AS-IS 이벤트 핸들러 인벤토리 (2026-08-08 축 — 분석서가 놓친 핸들러 차단)

> 원천: `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0021_SalesPlan\DMF0021_SalesPlan.cs` — `.cs` 에서 **기계 추출**한 UI 이벤트 핸들러 38개.
> 대사표의 E번호는 **분석 md** 기준이라 분석서가 누락한 핸들러를 못 잡는다. 이 축이 그 구멍을 막는다.
> 사문(빈 몸통) 핸들러는 **미이관이 파리티** — 상태 '제외' + 사유 기재로 통과시킨다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| HANDLER:DMF0021_SalesPlan_Load | AS-IS `DMF0021_SalesPlan.cs:5534` (라이브 2행) · **사문(빈 몸통)** |  | AS-IS 사문(빈 몸통) — 이관 대상 아님 | 해당없음 |
| HANDLER:DeleteButton | AS-IS `DMF0021_SalesPlan.cs:679` (라이브 6행) | features/demand/src/pages/sales-plan/SalesPlan.tsx (handleDelete — I 행만 제거) |  | 구현 |
| HANDLER:Dsdm_Changed | AS-IS `DMF0021_SalesPlan.cs:3958` (라이브 90행) | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:781~818 (cellEditEndedHandler) |  | 구현 |
| HANDLER:EditButton | AS-IS `DMF0021_SalesPlan.cs:687` (라이브 300행) | features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:86~158 (상시편집 대체) |  | 구현 |
| HANDLER:ExcelButton | AS-IS `DMF0021_SalesPlan.cs:1146` (라이브 25행) | features/demand/src/pages/sales-plan/SalesPlan.tsx (공용 그리드 Excel export — hasButton EXCEL) |  | 구현 |
| HANDLER:FindButton | AS-IS `DMF0021_SalesPlan.cs:669` (라이브 3행) · **사문(빈 몸통)** |  | AS-IS 사문(빈 몸통) — 이관 대상 아님 | 해당없음 |
| HANDLER:FindData | AS-IS `DMF0021_SalesPlan.cs:1465` (라이브 116행) | features/demand/src/pages/sales-plan/useSalesPlanStore.ts:221~ (fetch) + features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:27~59 |  | 구현 |
| HANDLER:Form_Load | AS-IS `DMF0021_SalesPlan.cs:310` (라이브 7행) | features/demand/src/pages/sales-plan/SalesPlan.tsx (초기화 useEffect — 진입 시 콤보/기본값) |  | 구현 |
| HANDLER:InsertButton | AS-IS `DMF0021_SalesPlan.cs:674` (라이브 3행) · **사문(빈 몸통)** |  | AS-IS 사문(빈 몸통) — 이관 대상 아님 | 해당없음 |
| HANDLER:InsertRow | AS-IS `DMF0021_SalesPlan.cs:2866` (라이브 342행) | features/demand/src/pages/sales-plan/SalesPlan.tsx:224~ + features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts:169~208 |  | 구현 |
| HANDLER:SaveButton | AS-IS `DMF0021_SalesPlan.cs:1125` (라이브 3행) · **사문(빈 몸통)** |  | AS-IS 사문(빈 몸통) — 이관 대상 아님 | 해당없음 |
| HANDLER:SaveData | AS-IS `DMF0021_SalesPlan.cs:1940` (라이브 426행) | features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:99~213 + features/demand/src/pages/sales-plan/SalesPlan.tsx (handleSave) |  | 구현 |
| HANDLER:btnColumn_Click | AS-IS `DMF0021_SalesPlan.cs:4467` (라이브 9행) | features/demand/src/pages/sales-plan/SalesPlan.tsx (customButtons — ColumnLayoutModal) |  | 구현 |
| HANDLER:btnItemId_Click | AS-IS `DMF0021_SalesPlan.cs:3548` (라이브 13행) | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx:147~165 (Model 검색 모달 오픈) |  | 구현 |
| HANDLER:btnMeasure_Click | AS-IS `DMF0021_SalesPlan.cs:4480` (라이브 9행) | features/demand/src/pages/sales-plan/SalesPlan.tsx (customButtons — MeasureSelectModal) |  | 구현 |
| HANDLER:btnOwner_Click | AS-IS `DMF0021_SalesPlan.cs:5491` (라이브 14행) | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx (Owner 검색 — OwnerField 모달) |  | 구현 |
| HANDLER:btnProject_Click | AS-IS `DMF0021_SalesPlan.cs:3529` (라이브 15행) | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx:345~350 (ProjectField — 40 비활성) |  | 구현 |
| HANDLER:cboBucketType_Click | AS-IS `DMF0021_SalesPlan.cs:5512` (라이브 7행) | features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts:63~72 (validateBucketChange) |  | 구현 |
| HANDLER:cboBucketType_SelectedIndexChanged | AS-IS `DMF0021_SalesPlan.cs:3576` (라이브 35행) | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx (Bucket 콤보) + features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx (bucketType deps 재판정) |  | 구현 |
| HANDLER:cboKRW_SelectedIndexChanged | AS-IS `DMF0021_SalesPlan.cs:5443` (라이브 4행) |  | AS-IS 본문 전체 주석(SetAmountCalculating — §8 CH-116) — 라이브 4행은 빈 래퍼 | 해당없음 |
| HANDLER:cboLOC_SelectedIndexChanged | AS-IS `DMF0021_SalesPlan.cs:5463` (라이브 4행) |  | AS-IS 본문 전체 주석(SetAmountCalculating — §8 CH-116) — 라이브 4행은 빈 래퍼 | 해당없음 |
| HANDLER:cboUSD_SelectedIndexChanged | AS-IS `DMF0021_SalesPlan.cs:5453` (라이브 4행) |  | AS-IS 본문 전체 주석(SetAmountCalculating — §8 CH-116) — 라이브 4행은 빈 래퍼 | 해당없음 |
| HANDLER:chkColor_CheckedChanged | AS-IS `DMF0021_SalesPlan.cs:5255` (라이브 6행) |  | Color 체크박스 제거(2026-07 사용자 확정) | 제외 |
| HANDLER:chkSum_CheckedChanged | AS-IS `DMF0021_SalesPlan.cs:4459` (라이브 6행) | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:1033~1069 (Sum 체크 — summaryBindings visible 토글) |  | 구현 |
| HANDLER:clbCustomer_SelectedIndexChanged | AS-IS `DMF0021_SalesPlan.cs:5124` (라이브 4행) | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx (EndCustomer cascade — scmSiteIds 클리어) |  | 구현 |
| HANDLER:clbDivision_SelectedIndexChanged | AS-IS `DMF0021_SalesPlan.cs:5135` (라이브 49행) | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx:182~195 (Division 변경 cascade) |  | 구현 |
| HANDLER:clbTeam_SelectedIndexChanged | AS-IS `DMF0021_SalesPlan.cs:5337` (라이브 20행) | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx:204~207 (Team cascade) |  | 구현 |
| HANDLER:spdMain_CellDoubleClick | AS-IS `DMF0021_SalesPlan.cs:3789` (라이브 132행) | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:877~927 (드릴 + 모달) |  | 구현 |
| HANDLER:spdMain_ClipboardPasted | AS-IS `DMF0021_SalesPlan.cs:5616` (라이브 23행) | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:856~874 (pastedCell — ITEM_ID 종속 재바인딩) |  | 구현 |
| HANDLER:spdMain_ComboSelChange | AS-IS `DMF0021_SalesPlan.cs:4530` (라이브 367행) | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:719~730·842~852 + features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61~83 |  | 구현 |
| HANDLER:spdMain_EditChange | AS-IS `DMF0021_SalesPlan.cs:4447` (라이브 2행) · **사문(빈 몸통)** |  | AS-IS 사문(빈 몸통) — 이관 대상 아님 | 해당없음 |
| HANDLER:spdMain_EnterCell | AS-IS `DMF0021_SalesPlan.cs:4329` (라이브 9행) | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:790 (oldVal 보관 — e.data) |  | 구현 |
| HANDLER:spdMain_KeyUp | AS-IS `DMF0021_SalesPlan.cs:5473` (라이브 12행) | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx (Wijmo 기본 clipboard copy/paste — KeyActionTab 표준) |  | 구현 |
| HANDLER:spdMain_LeaveCell | AS-IS `DMF0021_SalesPlan.cs:4362` (라이브 57행) | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx:792~806 (음수/절삭/포맷 — cellEditEnded 통합) |  | 구현 |
| HANDLER:spdMain_TextChanged | AS-IS `DMF0021_SalesPlan.cs:4440` (라이브 2행) · **사문(빈 몸통)** |  | AS-IS 사문(빈 몸통) — 이관 대상 아님 | 해당없음 |
| HANDLER:spdMain_TopChange | AS-IS `DMF0021_SalesPlan.cs:3569` (라이브 5행) |  | AS-IS 스크롤 시 SmartColMerge 재호출 — TO-BE HierarchicalMergeManager 가 viewport 단위 자동 처리 | 해당없음 |
| HANDLER:txtItemId_KeyDown | AS-IS `DMF0021_SalesPlan.cs:571` (라이브 6행) | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx:147~165 (Enter → 모달 오픈) |  | 구현 |
| HANDLER:txtProject_KeyDown | AS-IS `DMF0021_SalesPlan.cs:563` (라이브 6행) | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx:147~165 (Enter → 모달 오픈) |  | 구현 |

## 셀 콤보 토큰 대사표 (hook #117 §5.6 — 2026-08-12 실측)

> FE 실전달 = `utils/sales-plan.comboContext.ts`(표시/행 컨텍스트) + `sales-plan.constants.ts` GRID_EDIT_COMBO.
> 게이트 섹션7 대상 16종 중 토큰 보유 콤보만 기재. quoting = FE `'값'` 전달 의무 (BE raw 치환).

| CMBO | 필요 토큰 | FE 전달 | 판정/사유 |
|---|---|---|---|
| Measure | @mnuId (비관대형 `= @mnuId`) | mnuId `'DMF0021'` (comboContext default 분기 — 2026-08-12 보완) | ✅ 미전달 시 0행이던 실갭 정정 |
| BizTypeByDivision | @divisionId | divisionId | ✅ |
| Division | @divisionId | divisionId | ✅ |
| SalesPlanItemId | @divisionId | divisionId (Grid itemDropdown — No.61-③) | ✅ |
| CELL_PROD_SITE_ID | @divisionId·@itemId (관대형) | divisionId + itemId(행 컨텍스트 — ITEM 선택 후 재조회) | ✅ 메타 수집 시점 itemId 미전달 = 행 미확정 정상 (AS-IS 도 ITEM 선택 후 재바인딩 L4806) |
| EndCustomerByDivisionDept | @divisionId·@deptId·@sesUserId (관대형) | divisionId + deptId(행 컨텍스트) + sesUserId(BE 주입) | ✅ 표시 시점 deptId 미전달 = division 전체 후보(AS-IS InsertRow 선바인딩과 동일 계약) |
| SiteByEndCustomer | @divisionId·@deptId·@endCustomer·@sesUserId | divisionId + 행 컨텍스트 2종 + sesUserId(BE) | ✅ |
| FromSiteByDivision | @divisionId | divisionId | ✅ |
| AsIncotermsEdit | @divisionId | divisionId (GRID_EDIT_COMBO divisionParam — 2026-08-12 배선) | ✅ |
| CustomsHandbook | (무토큰) | — | ✅ |
| CurrencyList | (무토큰) | — | ✅ |
