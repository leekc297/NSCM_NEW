# __asis-mapping__.md — EID 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `DMF0042_BizPlan_주요이벤트_상세분석.md`, `DMF0042_BizPlan_제약매트릭스_상세.md`, `DMF0042_BizPlan_Cascade_Filter_전수.md`(CF- 축) · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (EID 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| E01 | §1 spdMain_Changed — 셀 값 변경 (핸들러 `spdMain_Changed`, L1863~L2786) | utils/business-plan.spread.ts `applyCellChange` + components/BusinessPlanGrid.tsx cellEditEnded |  | 구현 |
| E01-1 | §1.1 진입 가드 (L1865~L1874) | utils/business-plan.spread.ts `applyCellChange` 진입 가드 (editable 판정 = utils/business-plan.editLock.ts `evalBizPlanDynCell`) |  | 구현 |
| E01-2 | §1.2 로컬 변수 준비 (L1879~L1903) | utils/business-plan.spread.ts `applyCellChange` 지역 변수 준비 |  | 구현 |
| E01-3 | §1.3 Red(dirty) 색 가드 + 소수점 처리 MSG00289 (L1906~L1918) | components/BusinessPlanGrid.tsx 소수점 차단 MSG00289 → `MSG.BP_INTEGER_ONLY`(business-plan.constants.ts:109) |  | 구현 |
| E01-4 | §1.4 Business_Plan 벌 (Int64 정수 연산, L1920~L2351) | utils/business-plan.spread.ts `applyCellChange` Business_Plan 정수 분기 |  | 구현 |
| E01-5 | §1.5 비-Business_Plan 벌 (LOC 등, double 연산, L2352~L2783) | utils/business-plan.spread.ts 비 Business_Plan(LOC) double 분기 |  | 구현 |
| E01-6 | §1.6 Red(dirty) 마킹 정리 | components/BusinessPlanGrid.tsx EditTracker `storeChange` 로 변경 이력 관리 | AS-IS 는 셀 ForeColor Red 로 dirty 표시 — TO-BE 는 EditTracker 가 등가 역할(플랫폼 차이) | 구현 |
| E01-7 | §1.7 관련 보조 이벤트 | components/BusinessPlanGrid.tsx cellEditEnded / pastedCell 공유 경로 |  | 구현 |
| E02 | §2 EditButton — F2 편집 잠금 재계산 (핸들러 `EditButton` override, L563~L697) | utils/business-plan.editLock.ts `evalBizPlanDynCell` (R1~R4' 종합) + components/BusinessPlanGrid.tsx formatItem/beginningEdit |  | 구현 |
| E03 | §3 SaveData — F7 저장 payload 조립 (핸들러 `SaveData`, L862~L1209; 진입 `SaveButton` L699~L702) | utils/business-plan.save.ts `buildUnfoldRows`/`buildSavePayload` + utils/business-plan.api.ts 저장 호출 |  | 구현 |
| E03-1 | §3.1 진입 가드 (L864~L873) | utils/business-plan.validate.ts `useBusinessPlanValidation` 진입 가드(MSG00113 필수 컬럼) |  | 구현 |
| E03-2 | §3.2 payload 변수 (L875~L905) | utils/business-plan.save.ts `SaveUnfoldRow`/`SaveBuildResult` payload 변수 |  | 구현 |
| E03-3 | §3.3 행 그룹 루프 (L907~L1144) | utils/business-plan.save.ts `buildUnfoldRows` 행 그룹 루프 |  | 구현 |
| E03-4 | §3.4 변경(Red) 셀 수집 — 컬럼 루프 (L933~L1142) | utils/business-plan.save.ts `buildUnfoldRows` 변경 셀 수집 (EditTracker 변경분) |  | 구현 |
| E03-5 | §3.5 사후 검증 (L1146~L1156) | utils/business-plan.validate.ts 사후 검증 (중복키 MSG00043 / 대상 0건 MSG00676) |  | 구현 |
| E03-6 | §3.6 SP 호출 — '^' 21 param 조립 순서 (L1158~L1195) | utils/business-plan.save.ts `buildSavePayload` — '^' 21 param 조립 |  | 구현 |
| E03-7 | §3.7 결과 처리 (L1194~L1207) | utils/business-plan.api.ts `callProc` 결과 판정 + 토스트 |  | 구현 |
| E04 | §4 FindData — F5 조회 (핸들러 `FindData`, L745~L860; 진입 `FindButton` L539~L542) | useBusinessPlanStore.ts `setFilter`/`fetchStaticColumns` + BusinessPlan.tsx 조회 트리거 |  | 구현 |
| E05 | §5 InsertRow — F8 행 삽입 (핸들러 `InsertRow`, L1211~L1480; 진입 `InsertButton` L544~L547) | components/BusinessPlanGrid.tsx Insert 행 생성 + utils/business-plan.gridCombos.ts 콤보 바인딩 |  | 구현 |
| E06 | §6 spdMain_ComboSelChange — div40 2단 cascade (핸들러 L1628~L1659) | business-plan.constants.ts `GRID_CASCADE_FILTERS`(:131) + utils/business-plan.gridCombos.ts `filterComboRowsByRow` |  | 구현 |
| E07 | §7 커스텀 액션 버튼 4종 | BusinessPlan.tsx hotkeyConfig 커스텀 액션 4종 |  | 구현 |
| E07-1 | §7.1 btnSetPrice_Click — Set Price 환산 (L3178~L3199) | BusinessPlan.tsx Set Price → `MSG.SET_PRICE_CONFIRM`(business-plan.constants.ts:111) |  | 구현 |
| E07-2 | §7.2 btnExchangeRate_Click — 환율 팝업 (L3048~L3068, [PJ20200138] Division 추가) | components/modals/ExchangeRateModal.tsx |  | 구현 |
| E07-3 | §7.3 btnCutOff_Click — Version Cut-Off (L2903~L2929) | components/modals/VersionCutoffModal.tsx |  | 구현 |
| E07-4 | §7.4 btnReplace_Click — Current 버전 특정 컷오프로 덮어쓰기 (L3470~L3562, [C20221025-000029]) | components/modals/ReplaceByCutoffModal.tsx |  | 구현 |
| CA-01 | §1 `InitControls` / `sDivision=="40"` / `Substring(0,2)=="81"` / else | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-02 | §1 `InitSpread` / (파라미터 전달) | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-03 | §1 `InitSpread` / `clbDivision.ControlValues.Equals("40") && CELL_PROD_SITE 컬럼 존재` | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-04 | §1 `EditButton` (Monthly) / `sDivision=="40" && valid_YN=="Y"` | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-05 | §1 `EditButton` (Quarterly) / `sDivision=="40" && valid_YN=="Y" && start/end_YYYYQQ!=""` | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-06 | §1 `EditButton` (Yearly) / `sDivision=="40" && valid_YN=="Y" && start/end_YYYY!=""` | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-07 | §1 `SaveData` (Business_Plan 행 파라미터) / 셀 `DIVISION_ID=="40"` / `.Substring(0,2)=="81"` / … | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-08 | §1 `SaveData` (LOC 행 파라미터) / 동일 3분기(재실행) | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-09 | §1 `InsertRow` (Customer 소스) / `sDivision=="40"` / else | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-10 | §1 `InsertRow` (SalesSite 소스) / 3항 연산 `(sDivision=="40") ?` | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-11 | §1 `InsertRow` (Dept 콤보 배선) / `sDivision=="40"` / `!="40"` | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-12 | §1 `InsertRow` (CELL_PROD_SITE 콤보) / `sDivision=="40" && CELL_PROD_SITE 존재` | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-13 | §1 `InsertRow` (PROJECT_CODE 잠금) / `sDivision=="40" && PROJECT_CODE 존재` | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-14 | §1 `InsertRow` (PLANT_SITE_ID 잠금) / `sDivision.Substring(0,2)!="81"` | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-15 | §1 `InsertRow` (버킷 편집창) / #4~#6 과 동일 3벌 | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-16 | §1 `cboDivision_SelectedIndexChanged` / #1과 동일 3분기 | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-17 | §1 `clbTeam_SelectedIndexChanged` / `(Substring(0,2)=="81") \ | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-18 | §1 `clbCustomer_SelectedIndexChanged` / `(Substring(0,2)=="81") \ | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-19 | §1 `spdMain_ComboSelChange` / `sDivision=="40"` 한정 | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-20 | §1 `fnValidation` (키 수집) / `Substring(0,2)=="81"` / `=="40"` | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-21 | §1 `fnValidation` (내부 루프) / `Substring(0,2)=="81"` / `=="82"` / else | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CA-22 | §1 `MinColumnChk` / `Substring(0,2)=="81"` / `=="82"` / else | utils/business-plan.division.ts `divisionKindOf`／`isDiv40`·`isDiv81`·`isDiv82` + read*Slot 슬롯 분기 |  | 구현 |
| CB-01 | §2.1 메인 / `btnCutOff` (Version. Cut-Off 버튼) | utils/business-plan.editLock.ts 권한 게이트(EDIT_FLAG) + BusinessPlan.tsx `useTabBtnPermissions`/`hasButton` + 콤보 권한 파라미터 |  | 구현 |
| CB-02 | §2.1 메인 / `btnReplace_Click` (Replace by Cut-Off) | utils/business-plan.editLock.ts 권한 게이트(EDIT_FLAG) + BusinessPlan.tsx `useTabBtnPermissions`/`hasButton` + 콤보 권한 파라미터 |  | 구현 |
| CB-03 | §2.1 팝업 / `DefineProperty` 버튼 리스트 | utils/business-plan.editLock.ts 권한 게이트(EDIT_FLAG) + BusinessPlan.tsx `useTabBtnPermissions`/`hasButton` + 콤보 권한 파라미터 |  | 구현 |
| CB-04 | §2.1 팝업 / `EditButton` | utils/business-plan.editLock.ts 권한 게이트(EDIT_FLAG) + BusinessPlan.tsx `useTabBtnPermissions`/`hasButton` + 콤보 권한 파라미터 |  | 구현 |
| CB-05 | §2.1 팝업 / `SaveButton` | utils/business-plan.editLock.ts 권한 게이트(EDIT_FLAG) + BusinessPlan.tsx `useTabBtnPermissions`/`hasButton` + 콤보 권한 파라미터 |  | 구현 |
| CB-101 | §2.2 [원문 무번호] 메인 / Division 콤보 | utils/business-plan.editLock.ts 권한 게이트(EDIT_FLAG) + BusinessPlan.tsx `useTabBtnPermissions`/`hasButton` + 콤보 권한 파라미터 |  | 구현 |
| CB-102 | §2.2 [원문 무번호] 메인 / Team 콤보 | utils/business-plan.editLock.ts 권한 게이트(EDIT_FLAG) + BusinessPlan.tsx `useTabBtnPermissions`/`hasButton` + 콤보 권한 파라미터 |  | 구현 |
| CB-103 | §2.2 [원문 무번호] 메인 / End Customer 콤보 | utils/business-plan.editLock.ts 권한 게이트(EDIT_FLAG) + BusinessPlan.tsx `useTabBtnPermissions`/`hasButton` + 콤보 권한 파라미터 |  | 구현 |
| CB-104 | §2.2 [원문 무번호] 메인 / Sales Site 콤보 | utils/business-plan.editLock.ts 권한 게이트(EDIT_FLAG) + BusinessPlan.tsx `useTabBtnPermissions`/`hasButton` + 콤보 권한 파라미터 |  | 구현 |
| CB-105 | §2.2 [원문 무번호] 메인 / Plant Site 콤보 | utils/business-plan.editLock.ts 권한 게이트(EDIT_FLAG) + BusinessPlan.tsx `useTabBtnPermissions`/`hasButton` + 콤보 권한 파라미터 |  | 구현 |
| CB-106 | §2.2 [원문 무번호] 메인 / Currency 콤보 | utils/business-plan.editLock.ts 권한 게이트(EDIT_FLAG) + BusinessPlan.tsx `useTabBtnPermissions`/`hasButton` + 콤보 권한 파라미터 |  | 구현 |
| CB-107 | §2.2 [원문 무번호] 메인 / 신규행 Customer/Site/Team(Auth 계열) | utils/business-plan.editLock.ts 권한 게이트(EDIT_FLAG) + BusinessPlan.tsx `useTabBtnPermissions`/`hasButton` + 콤보 권한 파라미터 |  | 구현 |
| CB-108 | §2.2 [원문 무번호] 메인 / 조회 SP 권한 파라미터 | utils/business-plan.editLock.ts 권한 게이트(EDIT_FLAG) + BusinessPlan.tsx `useTabBtnPermissions`/`hasButton` + 콤보 권한 파라미터 |  | 구현 |
| CB-109 | §2.2 [원문 무번호] 팝업 / Division(My) 콤보 | utils/business-plan.editLock.ts 권한 게이트(EDIT_FLAG) + BusinessPlan.tsx `useTabBtnPermissions`/`hasButton` + 콤보 권한 파라미터 |  | 구현 |
| CB-110 | §2.2 [원문 무번호] 팝업 / Currency 콤보 | utils/business-plan.editLock.ts 권한 게이트(EDIT_FLAG) + BusinessPlan.tsx `useTabBtnPermissions`/`hasButton` + 콤보 권한 파라미터 |  | 구현 |
| CC-01 | §3 `Business_Plan`, `LOC` / `EditButton` | utils/business-plan.editLock.ts `EDIT_MEASURE` 비교(R1 행 게이트) + utils/business-plan.spread.ts measure별 연산 분기 |  | 구현 |
| CC-02 | §3 `LOC` / `SaveData` 행 블록 선두 | utils/business-plan.editLock.ts `EDIT_MEASURE` 비교(R1 행 게이트) + utils/business-plan.spread.ts measure별 연산 분기 |  | 구현 |
| CC-03 | §3 `Business_Plan`, `LOC`, `MKT_FCST` / `SaveData` 필터 | utils/business-plan.editLock.ts `EDIT_MEASURE` 비교(R1 행 게이트) + utils/business-plan.spread.ts measure별 연산 분기 |  | 구현 |
| CC-04 | §3 `KRW`, `USD`, `SalesAmt_KRW`, `SalesAmt_USD`, `SalesAmt_LOC`, `CAR_QTY` / `InsertRow` | utils/business-plan.editLock.ts `EDIT_MEASURE` 비교(R1 행 게이트) + utils/business-plan.spread.ts measure별 연산 분기 |  | 구현 |
| CC-05 | §3 (그 외 measure — Business_Plan/LOC/MKT_FCST) / `InsertRow` else | utils/business-plan.editLock.ts `EDIT_MEASURE` 비교(R1 행 게이트) + utils/business-plan.spread.ts measure별 연산 분기 |  | 구현 |
| CC-06 | §3 `Business_Plan` / `spdMain_Changed` 소수점 검사 | utils/business-plan.editLock.ts `EDIT_MEASURE` 비교(R1 행 게이트) + utils/business-plan.spread.ts measure별 연산 분기 |  | 구현 |
| CC-07 | §3 `Business_Plan` vs 그 외 / `spdMain_Changed` 합산/분배 대분기 | utils/business-plan.editLock.ts `EDIT_MEASURE` 비교(R1 행 게이트) + utils/business-plan.spread.ts measure별 연산 분기 |  | 구현 |
| CC-08 | §3 MEASURE 셀 자체 / `InsertRow` | utils/business-plan.editLock.ts `EDIT_MEASURE` 비교(R1 행 게이트) + utils/business-plan.spread.ts measure별 연산 분기 |  | 구현 |
| CC-09 | §3 (수집) / `fnValidation` | utils/business-plan.editLock.ts `EDIT_MEASURE` 비교(R1 행 게이트) + utils/business-plan.spread.ts measure별 연산 분기 |  | 구현 |
| CC-10 | §3 `MKT_FCST` 취급 / — | utils/business-plan.editLock.ts `EDIT_MEASURE` 비교(R1 행 게이트) + utils/business-plan.spread.ts measure별 연산 분기 |  | 구현 |
| CD-01 | §4 조회기간 역전 차단 / `from > to` | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-02 | §4 조회기간 6년 제한 / `Value1+6년 < Value2` | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-03 | §4 기준일(p_now) = 이번주 월요일 / 조회 시작일이 이번주 월요일 이후면 from 일, 종료일이 월요일 이전이면 to+1일, 그 외 이번주 월요일 | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-04 | §4 Edit: 버킷 외 컬럼 잠금 / Monthly→M_ 아닌 컬럼 / Quarterly→Q_ 아닌 컬럼 / Yearly→Y_ 아닌 컬럼 | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-05 | §4 Edit: 40 cutoff 편집창 / div=40 & VALID_YN=Y (Q/Y 는 start/end 존재 추가) | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-06 | §4 Edit: Q_/Y_ 직접입력 차단(비40) / 40+VALID_YN 조건 미충족 시 else | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-07 | §4 Edit: 과거 연도 행 잠금 / `올해 > int(tag.Substring(2,4))` (편집 개방 행 한정) | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-08 | §4 Edit 해제 시 키영역 재잠금 / `!IsEditMode` | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-09 | §4 InsertRow: 버킷·cutoff·과거연도 동일 3벌 / #4~#7 과 동일 로직 + 마지막에 과거 연도 무조건 잠금 | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-10 | §4 버킷별 컬럼 표시 / BucketType 콤보 | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-101 | §4 [원문 무번호] VALID_YN / `valid_YN` | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-102 | §4 [원문 무번호] START_YYYYMM / END_YYYYMM / `start_YYYYMM`/`end_YYYYMM` | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-103 | §4 [원문 무번호] START_YYYYQQ / END_YYYYQQ / `start_YYYYQQ`/`end_YYYYQQ` | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-104 | §4 [원문 무번호] START_YYYY / END_YYYY / `start_YYYY`/`end_YYYY` | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-11 | §4 헤더 더블클릭 드릴 / Y_ 헤더: 하위 Q_ 토글(+열린 M_ 접기); Q_ 헤더: 하위 M_ 토글 | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-12 | §4 저장은 M_ 만 / tag 에 `Q_`/`Y_` 포함 시 skip | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-13 | §4 분배 시 이번주 월요일 이전 보호 / 버킷 전체(M_ 없음) 분배 fallback 경로에서 `sResultDate(이번주 월요일) > 컬럼일자` → skip | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-14 | §4 버킷 변경 게이트 / 신규행(FlagI) 존재 시 | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-15 | §4 버킷 변경 시 Edit 유지 / Edit 모드에서 버킷 변경 | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CD-16 | §4 Business_Plan 합산/분배 자동식 / Monthly 입력→Q/Y SUM 재계산; Quarterly 입력→하위 M_ 균등분배(나머지 마지막 달)+Y… | utils/business-plan.editLock.ts `buildCutoff`/`buildValidWindow` + `evalBizPlanDynCell` R2/R3/R4' |  | 구현 |
| CE-01 | §5 컬럼 정의 / `DefColumns.FCST_TYPE` 정의. `FCST_TYPE40` 도 선언돼 있으나 **본문 사용처 0건**(선언만) | utils/business-plan.save.ts FCST_TYPE 필수값·직렬화 + utils/business-plan.editLock.ts 키영역 잠금 |  | 구현 |
| CE-02 | §5 콤보 / **FCST_TYPE 셀 콤보 없음** — `SetCellTypeCombo` 대상 아님. 직접 텍스트 입력 | utils/business-plan.save.ts FCST_TYPE 필수값·직렬화 + utils/business-plan.editLock.ts 키영역 잠금 |  | 구현 |
| CE-03 | §5 값 도메인 검증 / **검증 없음** — lookup 대조·형식 체크 부재. 빈 값 필수 체크만 존재(아래) | utils/business-plan.save.ts FCST_TYPE 필수값·직렬화 + utils/business-plan.editLock.ts 키영역 잠금 |  | 구현 |
| CE-04 | §5 필수값 검사 / 저장 시 40 필수(L967), 81 필수(L997). **82는 필수 아님**(검사 목록에 없음) | utils/business-plan.save.ts FCST_TYPE 필수값·직렬화 + utils/business-plan.editLock.ts 키영역 잠금 |  | 구현 |
| CE-05 | §5 컬럼 존재 필수 / `MinColumnChk`: 81(L3401)·40(L3437) 에서 FCST_TYPE 컬럼 미표시면 저장 진입 차단(MSG00113)… | utils/business-plan.save.ts FCST_TYPE 필수값·직렬화 + utils/business-plan.editLock.ts 키영역 잠금 |  | 구현 |
| CE-06 | §5 저장 직렬화 특례 / `ParameterString`: INCOTERMS/FCST_TYPE 는 빈 값을 `" "`(공백 1자)로 치환 후 '^' 결합 | utils/business-plan.save.ts FCST_TYPE 필수값·직렬화 + utils/business-plan.editLock.ts 키영역 잠금 |  | 구현 |
| CE-07 | §5 수집(무효) / `fnValidation` 에서 sFcstType 수집하나 실제 비교식은 주석(§8) | utils/business-plan.save.ts FCST_TYPE 필수값·직렬화 + utils/business-plan.editLock.ts 키영역 잠금 |  | 구현 |
| CE-08 | §5 개방/잠금 / Edit 시 FCST_TYPE 열어주는 로직은 **전부 주석**(§8 — Business_Plan 행 INCOTERMS/FCST_TYPE 개… | utils/business-plan.save.ts FCST_TYPE 필수값·직렬화 + utils/business-plan.editLock.ts 키영역 잠금 |  | 구현 |
| CF-01 | §6.1 FindData / `LockColumn(0, max, true)` | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-02 | §6.1 EditButton / `SwitchLock()` | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-03 | §6.1 EditButton / `LockColumn(iCol,iCol,true)` | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-04 | §6.1 EditButton / `LockColumn` | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-05 | §6.1 EditButton / `LockColumn` | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-06 | §6.1 EditButton / `LockColumn` | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-07 | §6.1 EditButton / `LockColumn` | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-08 | §6.1 EditButton / `LockColumn` | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-09 | §6.1 EditButton / `LockColumn` | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-10 | §6.1 EditButton / `LockColumn` | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-11 | §6.1 EditButton / `LockRange(iRow,0..MEASURE,true)` | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-12 | §6.1 EditButton / `LockRange` | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-13 | §6.1 EditButton / `LockRange(MEASURE+1..max)` | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-14 | §6.1 EditButton / `LockRange(0..MEASURE)` | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-15 | §6.1 DIVISION_ID (SetText 후) / 항상 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-16 | §6.1 PROJECT_CODE / div=40 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-17 | §6.1 CUST_GROUP / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-18 | §6.1 CUST_GROUP_DTL / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-19 | §6.1 OWNER / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-20 | §6.1 APPLICATION / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-21 | §6.1 ROUTE / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-22 | §6.1 BIZ_TYPE_NAME82 / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-23 | §6.1 BIZ_TYPE_NAME40 / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-24 | §6.1 ITEM_CLASS_NAME / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-25 | §6.1 ITEM_NAME / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-26 | §6.1 ITEM_TYPE / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-27 | §6.1 NICK_NAME / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-28 | §6.1 PLANT_SITE_ID / div 비81계열 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-29 | §6.1 VERSION_NO / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-30 | §6.1 FORECAST_INFO_PRODUCT_GROUP / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-31 | §6.1 FORECAST_INFO_CELL_PACK_COUNT / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-32 | §6.1 PRODUCT_GROUP_NAME / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-33 | §6.1 SHIPTO_DESCRIPTION / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-34 | §6.1 CELL_TYPE / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-35 | §6.1 INTERNAL_YN / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-36 | §6.1 COUNTRY_NAME / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-37 | §6.1 CITY_NAME / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-38 | §6.1 FORECAST_INFO_CELL_MODEL / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-39 | §6.1 FORECAST_INFO_SPEC / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-40 | §6.1 MDM_PROJECT_NAME / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-41 | §6.1 MIN_CAPACITY / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-42 | §6.1 VMI_YN / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-43 | §6.1 PRIORITY / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-44 | §6.1 DMS_SALES / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-45 | §6.1 DMS_CUSTOMER / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-46 | §6.1 REPORT_GROUP1 / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-47 | §6.1 REPORT_GROUP2 / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-48 | §6.1 REPORT_GROUP3 / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-49 | §6.1 REPORT_GROUP4 / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-50 | §6.1 REPORT_GROUP5 / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-51 | §6.1 REPORT_GROUP6 / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-52 | §6.1 REPORT_GROUP7 / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-53 | §6.1 REPORT_GROUP8 / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-54 | §6.1 EDIT_FLAG / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-55 | §6.1 CELL_PER_CAR / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-56 | §6.1 MODULE_PER_CAR / 존재 시 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-57 | §6.1 MEASURE (measure 명 SetText 후) / 항상 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-58 | §6.1 데이터 전체(MEASURE+1~max) / measure ∈ {KRW, USD, SalesAmt_KRW, SalesAmt_USD, SalesAmt_LO… | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-59 | §6.1 Monthly: 비 M_ 컬럼 / 그 외 measure | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-60 | §6.1 Monthly: 40 cutoff 창 밖 / 40 & VALID_YN=Y | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-61 | §6.1 Quarterly: 비 Q_ 컬럼 / — | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-62 | §6.1 Quarterly: 40 cutoff 창 밖 / 40 & 창 존재 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-63 | §6.1 Quarterly: Q_ 전체 / 40 조건 미충족 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-64 | §6.1 Yearly: 비 Y_ 컬럼 / — | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-65 | §6.1 Yearly: 40 cutoff 창 밖 / 40 & 창 존재 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-66 | §6.1 Yearly: Y_ 전체 / 40 조건 미충족 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CF-67 | §6.1 과거 연도 셀(데이터 컬럼) / 올해 > 태그 연도 | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx formatItem(배경색)/beginningEdit(cancel) |  | 구현 |
| CG-01 | §7.1 Edit/Insert/Save 버튼 / 비 ADMIN/DM ADMIN | components/modals/ExchangeRateModal.tsx |  | 구현 |
| CG-02 | §7.1 EditButton / 비 ADMIN/DM ADMIN | components/modals/ExchangeRateModal.tsx |  | 구현 |
| CG-03 | §7.1 SaveButton / 비 ADMIN/DM ADMIN | components/modals/ExchangeRateModal.tsx |  | 구현 |
| CG-04 | §7.3 EditButton / 키 컬럼 `LockColumn(DIVISION_ID~CURRENCY_UNITCURRENCY)` | components/modals/ExchangeRateModal.tsx |  | 구현 |
| CG-05 | §7.3 EditButton / **과거 연도 컬럼 잠금**: 컬럼 6부터 태그(`D`+yyyyMMdd)의 연도(`Substring(1,4)`)가 올해 이상인 … | components/modals/ExchangeRateModal.tsx |  | 구현 |
| CG-06 | §7.3 EditButton / 전월까지 잠금: 태그 YYYYMM ≥ 현재월인 첫 컬럼 직전까지 잠금 | components/modals/ExchangeRateModal.tsx |  | 구현 |
| CG-07 | §7.3 InsertRow / 신규행 CURRENCY 셀 잠금(기본값 "KRW" 세팅 후) | components/modals/ExchangeRateModal.tsx |  | 구현 |
| CG-08 | §7.3 InsertRow / 신규행 전월까지 `LockRange(CURRENCY_UNITCURRENCY .. i-1)` (컬럼 5부터 스캔) | components/modals/ExchangeRateModal.tsx |  | 구현 |
| CG-09 | §7.3 DeleteButton / Action 빈 행 삭제 차단(`GetText(row,0)==""` → return) | components/modals/ExchangeRateModal.tsx |  | 구현 |
| CH-01 | §8 메인 / EditButton 진입 |  | AS-IS §8 **비활성 인벤토리**(주석·미사용 코드) — 사문은 미이관이 파리티(hook: sp-body-no-rewrite 동일 원칙) | 제외 |
| CH-02 | §8 메인 / EditButton 행 루프 |  | AS-IS §8 **비활성 인벤토리**(주석·미사용 코드) — 사문은 미이관이 파리티(hook: sp-body-no-rewrite 동일 원칙) | 제외 |
| CH-03 | §8 메인 / EditButton |  | AS-IS §8 **비활성 인벤토리**(주석·미사용 코드) — 사문은 미이관이 파리티(hook: sp-body-no-rewrite 동일 원칙) | 제외 |
| CH-04 | §8 메인 / InsertRow |  | AS-IS §8 **비활성 인벤토리**(주석·미사용 코드) — 사문은 미이관이 파리티(hook: sp-body-no-rewrite 동일 원칙) | 제외 |
| CH-05 | §8 메인 / InsertRow |  | AS-IS §8 **비활성 인벤토리**(주석·미사용 코드) — 사문은 미이관이 파리티(hook: sp-body-no-rewrite 동일 원칙) | 제외 |
| CH-06 | §8 메인 / SaveData |  | AS-IS §8 **비활성 인벤토리**(주석·미사용 코드) — 사문은 미이관이 파리티(hook: sp-body-no-rewrite 동일 원칙) | 제외 |
| CH-07 | §8 메인 / fnValidation |  | AS-IS §8 **비활성 인벤토리**(주석·미사용 코드) — 사문은 미이관이 파리티(hook: sp-body-no-rewrite 동일 원칙) | 제외 |
| CH-08 | §8 메인 / MinColumnChk |  | AS-IS §8 **비활성 인벤토리**(주석·미사용 코드) — 사문은 미이관이 파리티(hook: sp-body-no-rewrite 동일 원칙) | 제외 |
| CH-09 | §8 메인 / spdMain_KeyUp |  | AS-IS §8 **비활성 인벤토리**(주석·미사용 코드) — 사문은 미이관이 파리티(hook: sp-body-no-rewrite 동일 원칙) | 제외 |
| CH-10 | §8 메인 / btnIncotermsChg_Click |  | AS-IS §8 **비활성 인벤토리**(주석·미사용 코드) — 사문은 미이관이 파리티(hook: sp-body-no-rewrite 동일 원칙) | 제외 |
| CH-11 | §8 메인 / DefColumns |  | AS-IS §8 **비활성 인벤토리**(주석·미사용 코드) — 사문은 미이관이 파리티(hook: sp-body-no-rewrite 동일 원칙) | 제외 |
| CH-12 | §8 메인 / spdMain_CellDoubleClick |  | AS-IS §8 **비활성 인벤토리**(주석·미사용 코드) — 사문은 미이관이 파리티(hook: sp-body-no-rewrite 동일 원칙) | 제외 |
| CH-13 | §8 팝업 / `InitSpread_X` |  | AS-IS §8 **비활성 인벤토리**(주석·미사용 코드) — 사문은 미이관이 파리티(hook: sp-body-no-rewrite 동일 원칙) | 제외 |
| CH-14 | §8 팝업 / LoadData |  | AS-IS §8 **비활성 인벤토리**(주석·미사용 코드) — 사문은 미이관이 파리티(hook: sp-body-no-rewrite 동일 원칙) | 제외 |
| CH-15 | §8 팝업 / SaveData |  | AS-IS §8 **비활성 인벤토리**(주석·미사용 코드) — 사문은 미이관이 파리티(hook: sp-body-no-rewrite 동일 원칙) | 제외 |
| CI-101 | §9 [원문 무번호] MSG00097 / FindData | business-plan.constants.ts `MSG` 상수 맵(:83~118) + utils/business-plan.validate.ts/components/BusinessPlanGrid.tsx 발화 지점 — hook #114 재채번 대조 완료 |  | 구현 |
| CI-102 | §9 [원문 무번호] MSG00108 / FindData | business-plan.constants.ts `MSG` 상수 맵(:83~118) + utils/business-plan.validate.ts/components/BusinessPlanGrid.tsx 발화 지점 — hook #114 재채번 대조 완료 |  | 구현 |
| CI-103 | §9 [원문 무번호] MSG00276 / FindData | business-plan.constants.ts `MSG` 상수 맵(:83~118) + utils/business-plan.validate.ts/components/BusinessPlanGrid.tsx 발화 지점 — hook #114 재채번 대조 완료 |  | 구현 |
| CI-104 | §9 [원문 무번호] MSG00113 / SaveData | business-plan.constants.ts `MSG` 상수 맵(:83~118) + utils/business-plan.validate.ts/components/BusinessPlanGrid.tsx 발화 지점 — hook #114 재채번 대조 완료 |  | 구현 |
| CI-105 | §9 [원문 무번호] MSG00310 / SaveData | business-plan.constants.ts `MSG` 상수 맵(:83~118) + utils/business-plan.validate.ts/components/BusinessPlanGrid.tsx 발화 지점 — hook #114 재채번 대조 완료 |  | 구현 |
| CI-106 | §9 [원문 무번호] MSG00275 / SaveData | business-plan.constants.ts `MSG` 상수 맵(:83~118) + utils/business-plan.validate.ts/components/BusinessPlanGrid.tsx 발화 지점 — hook #114 재채번 대조 완료 |  | 구현 |
| CI-107 | §9 [원문 무번호] MSG00043 / SaveData | business-plan.constants.ts `MSG` 상수 맵(:83~118) + utils/business-plan.validate.ts/components/BusinessPlanGrid.tsx 발화 지점 — hook #114 재채번 대조 완료 |  | 구현 |
| CI-108 | §9 [원문 무번호] MSG00004 / SaveData / 팝업 SaveData | business-plan.constants.ts `MSG` 상수 맵(:83~118) + utils/business-plan.validate.ts/components/BusinessPlanGrid.tsx 발화 지점 — hook #114 재채번 대조 완료 |  | 구현 |
| CI-109 | §9 [원문 무번호] MSG00289 / spdMain_Changed | business-plan.constants.ts `MSG` 상수 맵(:83~118) + utils/business-plan.validate.ts/components/BusinessPlanGrid.tsx 발화 지점 — hook #114 재채번 대조 완료 |  | 구현 |
| CI-110 | §9 [원문 무번호] MSG00002 / ValidationCheck(메인) / 팝업 SaveData | business-plan.constants.ts `MSG` 상수 맵(:83~118) + utils/business-plan.validate.ts/components/BusinessPlanGrid.tsx 발화 지점 — hook #114 재채번 대조 완료 |  | 구현 |
| CI-111 | §9 [원문 무번호] MSG00227 / cboBucketType_Click | business-plan.constants.ts `MSG` 상수 맵(:83~118) + utils/business-plan.validate.ts/components/BusinessPlanGrid.tsx 발화 지점 — hook #114 재채번 대조 완료 |  | 구현 |
| CI-112 | §9 [원문 무번호] MSG00142 / btnExchangeRate_Click | business-plan.constants.ts `MSG` 상수 맵(:83~118) + utils/business-plan.validate.ts/components/BusinessPlanGrid.tsx 발화 지점 — hook #114 재채번 대조 완료 |  | 구현 |
| CI-113 | §9 [원문 무번호] MSG00282 / btnSetPrice_Click | business-plan.constants.ts `MSG` 상수 맵(:83~118) + utils/business-plan.validate.ts/components/BusinessPlanGrid.tsx 발화 지점 — hook #114 재채번 대조 완료 |  | 구현 |
| CI-114 | §9 [원문 무번호] MSG00096 / 팝업 SaveButton | business-plan.constants.ts `MSG` 상수 맵(:83~118) + utils/business-plan.validate.ts/components/BusinessPlanGrid.tsx 발화 지점 — hook #114 재채번 대조 완료 |  | 구현 |
| CI-115 | §9 [원문 무번호] (직접 MessageBox) / 팝업 EditButton "You don't have the permissions" / 팝업 SaveDat… | business-plan.constants.ts `MSG` 상수 맵(:83~118) + utils/business-plan.validate.ts/components/BusinessPlanGrid.tsx 발화 지점 — hook #114 재채번 대조 완료 |  | 구현 |
| CJ-101 | §10 [원문 무번호] 1. Division 분기 / **22곳** |  | AS-IS §10 **카운트 요약표**(축별 추출 건수) — 제약이 아니라 집계 메타. 구현 대상 아님 | 해당없음 |
| CJ-102 | §10 [원문 무번호] 2. 권한 — NowGroupID 스위치(실행·표시 차단) / **5곳** |  | AS-IS §10 **카운트 요약표**(축별 추출 건수) — 제약이 아니라 집계 메타. 구현 대상 아님 | 해당없음 |
| CJ-103 | §10 [원문 무번호] 2. 권한 — NowGroupID 데이터 필터 파라미터 / **31개 호출**(메인 29 + 팝업 2) |  | AS-IS §10 **카운트 요약표**(축별 추출 건수) — 제약이 아니라 집계 메타. 구현 대상 아님 | 해당없음 |
| CJ-104 | §10 [원문 무번호] 2. 권한 — EDIT_FLAG 소비 / **3곳**(활성) |  | AS-IS §10 **카운트 요약표**(축별 추출 건수) — 제약이 아니라 집계 메타. 구현 대상 아님 | 해당없음 |
| CJ-105 | §10 [원문 무번호] 3. Measure 비교·제약 / **10항목** |  | AS-IS §10 **카운트 요약표**(축별 추출 건수) — 제약이 아니라 집계 메타. 구현 대상 아님 | 해당없음 |
| CJ-106 | §10 [원문 무번호] 4. 기간·버킷 규칙 / **16항목** |  | AS-IS §10 **카운트 요약표**(축별 추출 건수) — 제약이 아니라 집계 메타. 구현 대상 아님 | 해당없음 |
| CJ-107 | §10 [원문 무번호] 5. FCST_TYPE / **8항목** |  | AS-IS §10 **카운트 요약표**(축별 추출 건수) — 제약이 아니라 집계 메타. 구현 대상 아님 | 해당없음 |
| CJ-108 | §10 [원문 무번호] 6. 잠금 활성 호출 / **73건** |  | AS-IS §10 **카운트 요약표**(축별 추출 건수) — 제약이 아니라 집계 메타. 구현 대상 아님 | 해당없음 |
| CJ-109 | §10 [원문 무번호] 6. 잠금 비활성(주석) 호출 / **11건** |  | AS-IS §10 **카운트 요약표**(축별 추출 건수) — 제약이 아니라 집계 메타. 구현 대상 아님 | 해당없음 |
| CJ-110 | §10 [원문 무번호] 7. 팝업 제약 / 권한 3 + 필수값 2 + 잠금·기간 9 + '^' 파라미터 8종 |  | AS-IS §10 **카운트 요약표**(축별 추출 건수) — 제약이 아니라 집계 메타. 구현 대상 아님 | 해당없음 |
| CJ-111 | §10 [원문 무번호] 8. 비활성 인벤토리 / **15항목** |  | AS-IS §10 **카운트 요약표**(축별 추출 건수) — 제약이 아니라 집계 메타. 구현 대상 아님 | 해당없음 |
| CJ-112 | §10 [원문 무번호] 9. 메시지 / MSG 14종 + 하드코딩 MessageBox 5류 |  | AS-IS §10 **카운트 요약표**(축별 추출 건수) — 제약이 아니라 집계 메타. 구현 대상 아님 | 해당없음 |
| E01-4A | §1.4-A Monthly 버킷 + `M_` 컬럼 입력 (L1925~L1981) — 상위 Q_/Y_ 합계 갱신 | utils/business-plan.spread.ts Monthly M_ 입력 → 상위 Q_/Y_ 합계 갱신 |  | 구현 |
| E01-4B | §1.4-B Quarterly 버킷 + `Q_` 컬럼 입력 (L1982~L2145) — 하위 월 균등분할 + Y_ 재합계 | utils/business-plan.spread.ts Quarterly Q_ 입력 → 하위 월 균등분할 + Y_ 재합계 |  | 구현 |
| E01-4C | §1.4-C Yearly 버킷 + `Y_` 컬럼 입력 (L2146~L2350) — 월 분할 + Q_ 재합계 | utils/business-plan.spread.ts Yearly Y_ 입력 → 월 분할 + Q_ 재합계 |  | 구현 |
| E01-5A | §1.5-A Monthly + `M_` (L2357~L2413) | utils/business-plan.spread.ts LOC Monthly M_ |  | 구현 |
| E01-5B | §1.5-B Quarterly + `Q_` (L2414~L2577) | utils/business-plan.spread.ts LOC Quarterly Q_ |  | 구현 |
| E01-5C | §1.5-C Yearly + `Y_` (L2578~L2782) | utils/business-plan.spread.ts LOC Yearly Y_ |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:E03:SAVE | [SAVE] §3 SaveData — F7 저장 payload 조립 (핸들러 `SaveData`, L862~L1209; 진입 `SaveButton` L699~L702) | utils/business-plan.save.ts + utils/business-plan.api.ts — CRUD 왕복 검증 리포트 첨부 |  | 구현 |
| CRUD:E04:SEARCH | [SEARCH] §4 FindData — F5 조회 (핸들러 `FindData`, L745~L860; 진입 `FindButton` L539~L542) | useBusinessPlanStore.ts `setFilter` + BusinessPlan.tsx |  | 구현 |
| CRUD:E05:INSERT | [INSERT] §5 InsertRow — F8 행 삽입 (핸들러 `InsertRow`, L1211~L1480; 진입 `InsertButton` L544~L547) | components/BusinessPlanGrid.tsx Insert 행 + utils/business-plan.gridCombos.ts |  | 구현 |
| MODAL:BusinessPlanModals | FE 실존 모달 (components/BusinessPlanModals.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | components/BusinessPlanModals.tsx — 위 4모달의 컨테이너(자체 UI 없음) |  | 구현 |
| MODAL:ExchangeRateModal | FE 실존 모달 (components/modals/ExchangeRateModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | components/modals/ExchangeRateModal.tsx (AS-IS DMF0042_ExchangeRatePopup) |  | 구현 |
| MODAL:MeasureSelectModal | 공용 Measure 선택 모달 (hook #132 §2-1 — 2026-08-12 로컬 사본을 공용 승격·전환) | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx (소비 = components/BusinessPlanModals.tsx) |  | 구현 |
| MODAL:ReplaceByCutOffPopUp | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | components/modals/ReplaceByCutoffModal.tsx |  | 구현 |
| MODAL:ReplaceByCutoffModal | FE 실존 모달 (components/modals/ReplaceByCutoffModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | components/modals/ReplaceByCutoffModal.tsx (AS-IS ReplaceByCutOffPopUp) |  | 구현 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 |  | AS-IS `.ShowDialog()` 호출 관용구 — 개별 팝업이 아님(위 3모달의 호출 방식). 모달 실체 없음 | 해당없음 |
| MODAL:VersionCutOffPopUp | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | components/modals/VersionCutoffModal.tsx |  | 구현 |
| MODAL:VersionCutoffModal | FE 실존 모달 (components/modals/VersionCutoffModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | components/modals/VersionCutoffModal.tsx (AS-IS VersionCutOffPopUp) |  | 구현 |

## 0-B. 2026-07-21 최신분석(신정본) 재대조 — 갭 5건 교정 이력

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| G1 | **비40/무효창 Q_/Y_ 직접입력 잠금** — R4' 버킷축별 분기 (근거: 신정본 EditButton L604~615／L624~635 else LockColumn, M_ 은 else 없음=개방) | utils/business-plan.editLock.ts `evalBizPlanDynCell` R4' 분기(:160~174) |  | 구현 |
| G2 | **구 R6 제거** — 기존행 INCO/FCST 조건 개방 블록이 신정본 L651~667 전체 주석(비활성), 기존행 정적 전량 잠금(L649) | utils/business-plan.editLock.ts 키영역 잠금 + components/BusinessPlanGrid.tsx beginningEdit(:478) |  | 구현 |
| G4 | Monthly LOC 편집 시 **Q_ 롤업 = 편집셀값 Int copy**(합산·0 아님. Y_=0 은 파리티) — 신정본 L2371~2376／L2399~2404 | utils/business-plan.spread.ts `applyCellChange` LOC Monthly 분기 |  | 구현 |
| G8 | 필수값 — **81 에 FCST_TYPE／INCOTERMS 추가**, **82 의 PROJECT_CODE82 필수 제거** (신정본 SaveData L997~998／L1024~1026) | utils/business-plan.division.ts 슬롯 분기 + utils/business-plan.validate.ts 필수값 |  | 구현 |
| G9 | **CELL_PROD_SITE 콤보(40)** — 표시 ALL(메타 FPComboBox)+편집 유효건 Y 이원화 (InitSpread L392~397／InsertRow L1274~1278) | business-plan.constants.ts `GRID_EDIT_COMBO.CELL_PROD_SITE`='DMF0042CellProdSiteValid' + 메타 P7 SQL |  | 구현 |
| G5 | [개선] Set Price pending 차단(MSG00680) — AS-IS 가드 전무(btnSetPrice L3178~3199), 버튼 4종 통일 | BusinessPlan.tsx `handleSetPrice` + business-plan.constants.ts `MSG.PENDING_BLOCK`(:116) | AS-IS 대비 **의도적 개선**(사용자 승인 2026-07-21) — 파리티 초과분 | 구현 |
| — | 파리티 확인(무변경): 분모0 가드 기구현 / Cutoff 재조회 없음=파리티·Replace 재조회=기적용 / 6년 자동보정 기구현 / sRet passthrough 동등 | G3/G6/G7/G10 | — |
> 사내 실측 계약(2026-07-15): PROC_M 116(12본) / API_M 23 / BTN_MPG 23 / USER_GR 60, MNU_URL=business-plan(P1),
> 시트 키 'Biz Plan'/spreadTitle/dayRange/titleSet/exchangeRate/futurePrice(Data)/cutoffVersion/mdfVersion,
> MAIN 16키+커서 2(data/calendar[40 유효구간]), SAVE = PKG 판 19키 '^' bulk (F-2 ①).
>
> **커버리지 합계: 이벤트 28/28 · expressions 66/66 · validation 99/99 (누락 0)**

## 1. 조회조건 (AS-IS 컨트롤 15 → 카탈로그 + 인라인)

| # | AS-IS | TO-BE | 상태 |
|---|---|---|---|
| 1 | clbDivision (단일 콤보) | DivisionField (카탈로그 MyDivision) — 변경 = 전면 reset + Grid 초기화 | ✅ |
| 2 | clbTeam | TeamField (TeambyDivision) — 변경 시 EC/Site clear | ✅ |
| 3 | clbCustomer | 인라인 CustomDropdown — 40='EndCustomerByDivision40' / 비40='EndCustomer' 원천 스왑 (InitControls L252~262) | ✅ |
| 4 | clbBizType | 인라인 — 40='DmBizType'(DM_BIZ_TYPE) / 비40='BizTypeByDivision'(GetBizTypebyDivision) 스왑 | ✅ |
| 5 | clbSalesSite | SalesSiteField | ✅ |
| 6 | clbPlantSite | 인라인 — 'PlantSitebyEndCustomer'(quoting). 40 만 비활성 (L259~261) | ✅ |
| 7 | clbItemType | 인라인 — 'ItemType' | ✅ |
| 8 | cboBucketType (M/Q/Y — 기본 Monthly) | 인라인 — 'BucketType2'(P5 신설, BUCKET2_TYPE_CODE) + 정적 fallback. 변경 가드 MSG00227 | ✅ |
| 9 | drpPeriod (PR_GET_DAY_RANGE p_month=7) | PeriodField + dayRange 시트(o_rc2 당월1일~+7개월 말일) 1회 적용 | ✅ |
| 10 | txtProject + btnProject | ProjectField + ProjectByDivisionModal (40 disabled — btnProject 81/82 전용 L2762) | ✅ |
| 11 | txtItemId + btnItemId | ItemField + ItemByDivisionModal | ✅ |
| 12 | txtOwner + btnOwner | OwnerField + OwnerByDivisionModal (DM0020 모달 — CMBO 불필요 판정) | ✅ |
| 13 | chkSum | Sum 체크박스 — sumYn 즉시 토글 (SetSpreadColumn 재실행 대응, SP 미호출 L2832) | ✅ |
| 14 | cboQty (Qty≥0 — Visible=false dead) | 비노출 + qtyYn='N' 고정 배선 (파리티 — 체크포인트 확정) | ✅ |
| 15 | cboClosed (Enabled=false dead) | 제외 (조회조건저장 예외 잔재 — 무배선) | ✅ |

## 2. 버튼 (AS-IS 15 — §2 버튼 인벤토리 1:1)

| AS-IS | TO-BE | 상태 |
|---|---|---|
| Find (F5) | hotkeyConfig.search → handleSearch (V-S1~S3 + setFilter — refetch 직접 호출 금지) | ✅ |
| Insert (F8) | hotkeyConfig.insert → handleInsert (Measure 블록 삽입 — CMBO 'DMF0042_BP_Measure' division 필터, 0건=MSG00113) | ✅ |
| Delete (F9) | hotkeyConfig.delete → handleDelete (I행 블록 전체 삭제 — DB행 silent L527) | ✅ |
| Edit (F2) | 등록 제외 — 상시편집 + editLock R1~R7 대체 (DMF0021 선례) | ✅ |
| Save (F7) | hotkeyConfig.save → handleSave (PKG 판 19키 '^' bulk — F-2 ①. 확인창 없음, 결과 passthrough L1138) | ✅ |
| Excel (F12) | SubTitle EXCEL 공통 (DefaultButtonActions 자동) | ✅ |
| btnColumn 'Column Show' | 커스텀 버튼(icon) → 공용 ColumnLayoutModal + saveTitleSet('C') | ✅ |
| btnMeasure 'Measure' | 커스텀 버튼(icon) → 공용 MeasureSelectModal + saveTitleSet('M') + 그리드 비움(hook #132 §2-2 — Search 재조회 유도) | ✅ |
| btnProject/btnItemId/btnOwner | 카탈로그 필드 팝업 (§1) | ✅ |
| btnSetPrice (가격환산) | 커스텀 버튼 'Set Price' → MSG00678 confirm → SET_PRICE(PRICE_CONV 4p) → 결과 passthrough + 재조회 (L3115~3136) | ✅ |
| btnExchangeRate | 커스텀 버튼(LBL00661) → pending 차단(MSG00680 — AS-IS MSG00142 L2989 용법) → ExchangeRateModal → 닫으면 재조회 | ✅ |
| btnCutOff (ADMIN/DM ADMIN) | 커스텀 버튼 'Ver. Cutoff' — hasButton('CUTOFF') 게이트(P4 ADMIN 만) + pending 차단 → VersionCutoffModal("BP_M") | ✅ |
| btnReplace (ADMIN/DM ADMIN) | 커스텀 버튼 'Replace' — hasButton('REPLACE') 게이트 + pending 차단 + 조회 0행 차단(L3408 인라인) + 선택 M_ 범위 from/to(L3422~3450) → ReplaceByCutoffModal | ✅ |
| btnIncotermsChg (MasterChg) | 미이관 — AS-IS 전량 주석(비활성 L2927~2940). 메모리 project_dmf0003_master_change_removed 계보 | ✅ (제외 확정) |
| Filter/Sort/Condition/Reset | SubTitle 자동 활성 (hook #64) | ✅ |

## 3. 이벤트 핸들러 28 전수 (상세동작_개발용.md §1 1:1)

| # | AS-IS 핸들러 | AS-IS 동작 요약 | TO-BE 구현 | 상태 |
|---:|---|---|---|---|
| 1 | Form_Load (L209~217) | InitControls(3분기 콤보) + CreateSpread + DefineProperty(CutOff 권한) + InitSaveDataTable | BusinessPlan.tsx mount(useEffect) + store initSearch(Monthly) + dayRange 적용 + useTabComboQueries. CutOff 권한 = P4 hasButton | ✅ |
| 2 | OnShown (L219~226) | 사실상 no-op (sDivision 읽기만) | 미적용 (AS-IS no-op) | ✅ |
| 3 | cboDivision_SelectedIndexChanged (L1422~1507) | 3분기 재초기화 — InitSpread + 저장버퍼 리셋 + 콤보 전량 재바인딩 + 텍스트 3종 클리어 | DivisionField onChange (종속 전면 reset) + handleDivisionChange(Grid 초기화·CRUD reset·메타 재fetch) | ✅ |
| 4 | clbTeam_SelectedIndexChanged (L1509~1533) | Customer/SalesSite 재조회 (81·82=div키 / 40=team키) | TeamField onChange — endCustomers/scmSiteIds clear (경로 분기 = 콤보 원천 스왑 흡수) | ✅ |
| 5 | clbCustomer_SelectedIndexChanged (L1535~1547) | SalesSite 재조회 | EC 인라인 onChange — scmSiteIds clear | ✅ |
| 6 | cboBucketType_SelectedIndexChanged (L1549~1563) | SetSpreadColumn(버킷별 Visible) + EditButton×2(잠금 재적용) | store bucketType → applyDynVisibility + editLock 재평가 (bucketType dep) | ✅ |
| 7 | cboBucketType_Click (L2963~2973) | 삽입 행(I) 존재 시 MSG00227 차단 | Bucket onChange 가드 — validateBucketChange(변경분 존재) | ✅ |
| 8 | chkSum_CheckedChanged (L2832~2838) | SetSpreadColumn 재호출 — Y_/Q_ SUM 표시 토글 | sumYn → summaryBindings visible 토글 (SP 미호출 동일) | ✅ |
| 9 | btnProject_Click (L2762~2782) | Project 팝업(81/82) → txtProject | ProjectField + 모달 (disabled=40) | ✅ |
| 10 | btnItemId_Click (L2784~2805) | Item 팝업 → txtItemId | ItemField + 모달 | ✅ |
| 11 | btnOwner_Click (L2942~2961) | Owner 팝업 → txtOwner | OwnerField + 모달 | ✅ |
| 12 | btnColumn_Click (L2807~2817) | TitleSet 팝업(true=Column) → OK 시 InitSpread | 공용 ColumnLayoutModal + saveTitleSet('C') + fetchStaticColumns | ✅ |
| 13 | btnMeasure_Click (L2819~2830) | TitleSet 팝업(false=Measure) → OK 시 InitSpread | 공용 MeasureSelectModal + saveTitleSet('M') + 그리드 비움(#132 §2-2 — AS-IS InitSpread 재조회 대신 명시 Search 유도, Δ 확정) | ✅ |
| 14 | spdMain_Changed (L1800~2723) ⭐ | 수량 배분·롤업 — Business_Plan 정수(M롤업/Q균등분할+나머지끝/Y균등분할+실적스킵) / LOC copy / 소수 절삭 MSG00289 | cellEditEnded → utils/business-plan.spread.ts applyCellChange (순수함수 1:1) + EditTracker patch 전량 추적 + MSG00679 | ✅ |
| 15 | spdMain_CellDoubleClick (L1598~1798) | 헤더: Y_→Q_ 토글+열린 M_ 접기 / Q_→M_ 토글 · 셀: I행 ITEM_ID(40)/ITEM_ID/PROJECT_CODE(81)/PROJECT_CODE82(82) 팝업 | Grid dblclick — 헤더 드릴(drillVisRef flip 1:1) + 셀 분기 → Project/Item 모달 (I행 한정 L1643) | ✅ |
| 16 | spdMain_ComboSelChange (L1565~1596) | 40 전용 — END_CUSTOMER40→SCM_SITE_ID40 재조회 / DEPT_ID40→EC+Site 재설정 | beginningEdit cascade dataMap 스왑(hook #59 §5-G — SCM_SITE_ID40←END_CUSTOMER40 행값 필터) + cellEditEnded 원복 | ✅ |
| 17 | spdMain_EditChange (L2975~2982) | bPasteContinue 플래그 (재검증 게이트) | Wijmo 편집 파이프라인(beginningEdit/cellEditEnded) 대체 — 별도 구현 불요 | ✅ |
| 18 | spdMain_TopChange (L2736~2741) | SmartColMerge 재적용 (스크롤 병합 유지) | scrollPositionChanged → invalidate (HierarchicalMergeManager viewport sticky) | ✅ |
| 19 | spdMain_KeyUp (L2743~2760) | 본문 전량 주석 (no-op) | 미적용 (AS-IS no-op — FlexGrid 내장 클립보드 + pastingCell 게이트) | ✅ |
| 20 | FindButton → FindData (L684~799) | 검증(MSG00097/00108/00276) + 금주월요일 + 16파라미터 조회 + Tables[1] 유효구간 캐시 | handleSearch — validateFind + setFilter(nowYyyymmdd=금주 월요일) + 커서2 cutoffWindow 보관 | ✅ |
| 21 | InsertButton → InsertRow (L1150~1417) | Measure 블록 삽입 + 콤보/팝업 셀타입 + 메타 전량 잠금 + 버킷별 편집구간 unlock | handleInsert — measureBlockOf 블록 생성 + R5 insertStaticEditable + editLock R2~R4 | ✅ |
| 22 | DeleteButton (L525~537) | I행 Measure 블록 역순 삭제 (DB행 불가) | handleDelete — INSERT_GROUP_ID 블록 삭제 | ✅ |
| 23 | EditButton (L539~673) ⭐ | SwitchLock + 버킷별 잠금 + EDIT_FLAG 행제어 + 40 유효구간 + Incoterms/FcstType 조건 개방 | 상시편집 — editLock R1(EDIT_FLAG×measure)/R2(버킷)/R3(금년)/R4(40 유효구간) + R6 existingRowStaticEditable | ✅ |
| 24 | SaveButton → SaveData (L801~1148) | MinColumnChk + Measure 블록 스캔(M_ 만) + 3분기 필수검증(MSG00310) + fnValidation(중복 MSG00043) + 27p '^' 저장 + 재조회 | handleSave — validateSaveRows(MSG00429) + buildUnfoldRows(M_ 수집·'0'→'D'·중복검증) + PKG 19키 저장 + 재조회(스크롤 복원) | ✅ |
| 25 | btnSetPrice_Click (L3115~3136) | MSG00282 confirm → PRICE_CONV(s_flag=''/division) → 반환 메시지 + FindData | handleSetPrice — MSG00678 confirm → callSetPrice → passthrough + refetch | ✅ |
| 26 | btnExchangeRate_Click (L2985~3005) | 편집모드 차단(MSG00142) → ExchangeRatePopup("BP") → blnOK 시 재조회 | handleExchangeRate — pending 차단(MSG00680) → ExchangeRateModal(cate='BP') → saved 시 refetch | ✅ |
| 27 | btnCutOff_Click (L2840~2866) | 편집모드 차단(인라인) → VersionCutOffPopUp("BP_M") — 팝업 자체 저장 | handleCutoff — pending 차단 → VersionCutoffModal(BP_M — 목록조회+설명입력+실행+MSG00675) | ✅ |
| 28 | btnReplace_Click (L3382~3474) | 편집모드/권한/0행 차단 → 선택 M_ 범위 → ReplaceByCutOffPopUp("BP_M", from, to) | handleReplace — pending·0행 차단 + selection M_ 범위 → ReplaceByCutoffModal(버전선택+실행) | ✅ |

## 4. Expressions 66 전수 (expressions.md 1:1 — 조건부잠금 61 + SUM헤더 5)

| 그룹 | AS-IS (# 범위) | TO-BE 구현 | 상태 |
|---|---|---|---|
| SUM 헤더 5 (#1~5) | SetSpreadHeaderSpan — Y_ 연 SUM(2단 세로 span) + Q_ 분기 SUM | mainDynamicColumns 3단 nested(연→분기/SUM→leaf) + HierarchicalMergeManager (Y_ r1..last 세로 머지 / 1·2단 수평 머지) | ✅ |
| EditButton 잠금 8 (#6~13) | 좌측 키 잠금 / Incoterms·FcstType 조건 개방/잠금 / 금년 이전 잠금 / 비대상 measure 수량영역 잠금 / Edit 해제 재잠금 | editLock R1~R4 + R6 existingRowStaticEditable (beginningEdit cancel + formatItem 3색) — 상시편집이라 SwitchLock 자체는 제거 | ✅ |
| InsertRow 메타 잠금 42 (#14~55) | DIVISION_ID~REPORT_GROUP8 + EDIT_FLAG + CELL_PER_CAR/MODULE_PER_CAR 참조컬럼 전량 잠금 | R5 insertStaticEditable — 개방 화이트리스트 외 default false (붕괴 규칙 1:1, 컬럼 열거 불요) | ✅ |
| InsertRow Measure/수량 잠금 11 (#56~66) | MEASURE 잠금 + 파생 measure 수량영역 잠금 + 버킷별(M_/Q_/Y_) 편집구간·40 유효구간·금년 이전 잠금 | MEASURE = 블록 삽입 고정(잠금) + evalBizPlanDynCell R1(measure 게이트)/R2(버킷)/R3(금년)/R4(40 유효구간) | ✅ |

## 5. Validation 99 전수 (validation.md 1:1)

| 그룹 | AS-IS (# 범위) | TO-BE 구현 | 상태 |
|---|---|---|---|
| Division 분기 33 (사업부분기 전수) | InitControls(3)/EditButton(4)/FindData(1)/InsertRow(10)/cboDivision(3)/clbTeam(2)/clbCustomer(1)/ComboSelChange(2)/fnValidation(5)/MinColumnChk(2) | divisionKindOf(startsWith '81') 단일 진실원 + division 슬롯 read* 함수 + R5/콤보 원천 스왑 — 분기 전수 흡수 | ✅ |
| 조회 검증 4 (#9~12) | MSG00097(Division)/MSG00108(역전)/MSG00276(6년 초과+보정) | validateFind — MSG00097/MSG00108/MSG00677(신설)+adjustedEnd 보정 | ✅ |
| 저장 검증 8 (#13~20) | MSG00113(MinColumnChk)/MSG00310×3(필수값)/MSG00275(0건)/MSG00043(중복)/sRet passthrough/MSG00004(N건 저장) | MSG00113 / validateSaveRows(MSG00429 division 분기) / MSG00676(신설) / buildUnfoldRows 중복검증(MSG00043) / callProc passthrough / MSG00002(저장성공 재매핑) | ✅ |
| 필수 컬럼 존재 44 (fnValidation 22 + MinColumnChk 22) | Grid 내 필수 컬럼 인덱스 존재 여부 (division별 컬럼셋) | TO-BE = admin SHEET_COLUMNS 메타 주도(hook #113 — 컬럼 존재가 메타로 보장) + requiredFieldsFor 값 검증으로 대체. 실측 63컬럼 division 토큰 정합 확인 | ✅ (구조 대체) |
| Grid 입력 4 (#39~40/41/44) | Red 셀 가드/MSG00289(소수)/MSG00002(paste 재검증)/EditChange 플래그 | spread 엔진(truncated→MSG00679) + EditTracker + pastingCell 게이트 | ✅ |
| 버튼 가드 6 (#42/43/45/97~99) | CutOff·Replace 인라인 "Edit Mode is not allowed."×3 / MSG00227 / MSG00142 / "데이터 조회 후..." | validateNoPending(MSG00680 신설 — 상시편집 문구) / validateBucketChange / 0행 차단 인라인 1:1 | ✅ |

## 6. 의도적 편차 (전부 근거 보유)

| # | 편차 | 근거 |
|---|---|---|
| 1 | Edit(F2) 토글 제거 — 상시편집 + editLock | DMF0021/DMF0003 TO-BE 표준 (2026-07-14 확정 승계) |
| 2 | SAVE = PKG 판 21 IN (AS-IS standalone 27p 중 TO-BE 미승계 6p 제외) | 사용자 확정 F-2 ① (2026-07-15). standalone 은 P0b alias 패치 후 보존만 |
| 3 | Bucket 표시 규칙 — Monthly 시 Q_ 도 sumYn 토글 (AS-IS 는 Q_ 상시 표시) | 플랜 §E 승인 규칙 (활성=표시/상위 SUM=sumYn/하위=드릴) — DYN_RANK 일관 엔진 |
| 4 | MSG 재매핑 — 00310→00429 / 00275→00676 / 00276→00677 / 00282→00678 / 00289→00679 / 00142·인라인→00680 / 00004(N건)→00002 | 사내 MSG_M 실문구 대사 (00676/677/678/679/680 = P1 신설 675~680, MAX=674 실측) |
| 5 | cboQty 비노출 + 'N' 고정 | AS-IS Visible=false dead (체크포인트 확정 — 파리티) |
| 6 | Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (AS-IS 677줄 WinForms 팝업 1:1 아님) | 조회(futurePriceData cate='BP')+편집(EDIT_YN)+저장('^' bulk)+재조회 데이터 계약은 1:1. 레이아웃 = DMF0020 정본 표준 |
| 7 | Ver.Cutoff/Replace 모달 = 목록조회+실행 표준 재구성 | SP 계약(BP_M/from-to/versionNo) 1:1 — WinForms 레이아웃 비승계 |
| 8 | MEASURE 컬럼 VISIBLE_FLAG='N' (사내 실측) — FE 메타 그대로 반영 | hook #113 메타 100% 주도 (하드코딩 강제표시 금지). admin 에서 'Y' 전환 시 즉시 노출 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — asis_mapping_gate --check 가 부재 행을 FAIL 처리한다.

| ID | 요지(원천 1줄) | 구현 위치(파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 추가 행이 보이도록 (그리드 필터 clear — 1st 행3) | BusinessPlan.tsx handleInsert `gridFilterRef.current?.clear()` (2026-08-12 보완 — DMF0021 C1 선례 1:1) |  | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = MSG00703 confirm (1st 행4) | BusinessPlan.tsx handleSearch `hasPendingChanges()` → setAlert confirm MSG00703 (2026-08-12 보완 — DMF0021 C2 선례 1:1) |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | components/BusinessPlanModals.tsx onSettingsApplied → BusinessPlan.tsx 그리드 비움(insertedRows/editTracker/hasSearched/clearFilters) — 자동 재조회 금지 |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG·hook #132 §3 — 1st 행6) | BusinessPlan.tsx handleSave 성공 `setToast type:'success'` (MSG.SAVED) |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (1st 행7) | 공용 `packages/foundation/src/utils/gridAction.ts` excelDownload dataMap 승계(2026-08-12 공용 보완 — 전 화면 발효) + SubTitle excelFileName 경로 소비 |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | Project/Model/Owner keyin → PKG_DMF0042 SP 내 FN_STRING_SPLIT(DB 함수) 다중 매칭(P0c — 빈값 NULL 가드 포함, 2026-07-15 사내 검증) |  | 구현 |

## 7. 검증 이력

- tsc(features/demand + foundation + apps/web) 0 / eslint --quiet 0 (2026-07-15)
- ~~vitest 환경 이슈로 실행 불가~~ → **환경 복구 후 정상 실행 중** (2026-08-11 jsdom 환경 복구 — 게이트 §9 에서 7 passed 실측, 2026-08-12 정정)
- DB 적용: P0a/P0b + P1~P6 사내 반영 완료(2026-07-15) — 구 "승인 대기" 기록 정정
- **2026-08-12 재점검**: hook #132 소급 4건(V1 페이지 래퍼 div / V2 DataGrid 래퍼 div / V3 MeasureSelectModal 공용 승격 / V4 설정 저장=그리드 비움·자동 재조회 제거) + 게이트 §3 NLS 해소(PROC_M `PR_GET_DAY_RANGE.month` VARCHAR→NUMBER — BE jdbcType=NUMERIC 바인딩, HTTP 실검증 200/code 0) + 단위테스트 xlsx 대조 결과 DMF0042 행 0건(해당 없음 확정)

## AS-IS 이벤트 핸들러 인벤토리 (2026-08-08 축 — 분석서가 놓친 핸들러 차단)

> 원천: `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0042_BizPlan\DMF0042_BizPlan.cs` — `.cs` 에서 **기계 추출**한 UI 이벤트 핸들러 32개.
> 대사표의 E번호는 **분석 md** 기준이라 분석서가 누락한 핸들러를 못 잡는다. 이 축이 그 구멍을 막는다.
> 사문(빈 몸통) 핸들러는 **미이관이 파리티** — 상태 '제외' + 사유 기재로 통과시킨다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| HANDLER:DeleteButton | AS-IS `DMF0042_BizPlan.cs:549` (라이브 10행) | BusinessPlan.tsx:382 `hotkeyConfig.delete` = hasButton('DELETE') ? handleDelete |  | 구현 |
| HANDLER:EditButton | AS-IS `DMF0042_BizPlan.cs:563` (라이브 89행) | utils/business-plan.editLock.ts `evalBizPlanDynCell` + components/BusinessPlanGrid.tsx:431 formatItem / :478 beginningEdit |  | 구현 |
| HANDLER:ExcelButton | AS-IS `DMF0042_BizPlan.cs:705` (라이브 25행) | BusinessPlan.tsx 공통 Excel 버튼(SubTitle 공통 기능) |  | 구현 |
| HANDLER:FindButton | AS-IS `DMF0042_BizPlan.cs:539` (라이브 3행) · **사문(빈 몸통)** |  | AS-IS 라이브 3행 = `FindData()` 위임 래퍼(사문). TO-BE 는 hotkeyConfig.search 가 직접 조회 — 래퍼 불요 | 제외 |
| HANDLER:FindData | AS-IS `DMF0042_BizPlan.cs:745` (라이브 87행) | useBusinessPlanStore.ts `setFilter`/`fetchStaticColumns` + BusinessPlan.tsx:380 hotkeyConfig.search |  | 구현 |
| HANDLER:Form_Load | AS-IS `DMF0042_BizPlan.cs:223` (라이브 8행) | BusinessPlan.tsx mount useEffect (initSearch + dayRange + useTabComboQueries) |  | 구현 |
| HANDLER:InsertButton | AS-IS `DMF0042_BizPlan.cs:544` (라이브 3행) · **사문(빈 몸통)** |  | AS-IS 라이브 3행 = `InsertRow()` 위임 래퍼(사문). TO-BE 는 hotkeyConfig.insert 가 직접 처리 | 제외 |
| HANDLER:InsertRow | AS-IS `DMF0042_BizPlan.cs:1211` (라이브 226행) | components/BusinessPlanGrid.tsx Insert 행 생성 + utils/business-plan.gridCombos.ts 콤보 바인딩 + BusinessPlan.tsx:381 hotkeyConfig.insert |  | 구현 |
| HANDLER:OnShown | AS-IS `DMF0042_BizPlan.cs:233` (라이브 4행) |  | AS-IS 라이브 4행 = sDivision 읽기만(실동작 없음) — 미이관이 파리티 | 제외 |
| HANDLER:SaveButton | AS-IS `DMF0042_BizPlan.cs:699` (라이브 3행) · **사문(빈 몸통)** |  | AS-IS 라이브 3행 = `SaveData()` 위임 래퍼(사문). TO-BE 는 hotkeyConfig.save 가 직접 처리 | 제외 |
| HANDLER:SaveData | AS-IS `DMF0042_BizPlan.cs:862` (라이브 257행) | utils/business-plan.save.ts `buildUnfoldRows`/`buildSavePayload` + BusinessPlan.tsx:383 hotkeyConfig.save |  | 구현 |
| HANDLER:btnColumn_Click | AS-IS `DMF0042_BizPlan.cs:2870` (라이브 9행) | BusinessPlan.tsx:435-440 COLUMN_SETUP → `setOpenColumnSetting(true)` |  | 구현 |
| HANDLER:btnCutOff_Click | AS-IS `DMF0042_BizPlan.cs:2903` (라이브 17행) | BusinessPlan.tsx:404 CUTOFF → components/modals/VersionCutoffModal.tsx |  | 구현 |
| HANDLER:btnExchangeRate_Click | AS-IS `DMF0042_BizPlan.cs:3048` (라이브 16행) | BusinessPlan.tsx:424 EXCHANGE_RATE → components/modals/ExchangeRateModal.tsx |  | 구현 |
| HANDLER:btnItemId_Click | AS-IS `DMF0042_BizPlan.cs:2847` (라이브 17행) | BusinessPlan.tsx ItemField + ItemByDivisionModal(@master 공용) |  | 구현 |
| HANDLER:btnMeasure_Click | AS-IS `DMF0042_BizPlan.cs:2882` (라이브 9행) | BusinessPlan.tsx:446-451 MEASURE_SELECT → `setOpenMeasureSelect(true)` |  | 구현 |
| HANDLER:btnOwner_Click | AS-IS `DMF0042_BizPlan.cs:3005` (라이브 14행) | BusinessPlan.tsx OwnerField + OwnerByDivisionModal(@master 공용) |  | 구현 |
| HANDLER:btnProject_Click | AS-IS `DMF0042_BizPlan.cs:2825` (라이브 17행) | BusinessPlan.tsx ProjectField + ProjectByDivisionModal (40 disabled) |  | 구현 |
| HANDLER:btnReplace_Click | AS-IS `DMF0042_BizPlan.cs:3470` (라이브 68행) | BusinessPlan.tsx:414 REPLACE → components/modals/ReplaceByCutoffModal.tsx |  | 구현 |
| HANDLER:btnSetPrice_Click | AS-IS `DMF0042_BizPlan.cs:3178` (라이브 15행) | BusinessPlan.tsx:394-399 SET_PRICE → `handleSetPrice` (business-plan.constants.ts `MSG.SET_PRICE_CONFIRM`) |  | 구현 |
| HANDLER:cboBucketType_Click | AS-IS `DMF0042_BizPlan.cs:3026` (라이브 10행) | useBusinessPlanStore.ts bucket 변경 가드 (business-plan.constants.ts `MSG.BUCKET_CHANGE_BLOCK` MSG00227) |  | 구현 |
| HANDLER:cboBucketType_SelectedIndexChanged | AS-IS `DMF0042_BizPlan.cs:1612` (라이브 11행) | useBusinessPlanStore.ts bucketType → 동적 컬럼 visible + utils/business-plan.editLock.ts R2 버킷 게이트 재평가 |  | 구현 |
| HANDLER:cboDivision_SelectedIndexChanged | AS-IS `DMF0042_BizPlan.cs:1485` (라이브 62행) | useBusinessPlanStore.ts `handleDivisionChange` — Grid 초기화 + CRUD reset + 메타 재fetch |  | 구현 |
| HANDLER:chkSum_CheckedChanged | AS-IS `DMF0042_BizPlan.cs:2895` (라이브 6행) | useBusinessPlanStore.ts sumYn → summary 컬럼 visible 토글 (SP 미호출 = AS-IS 동일) |  | 구현 |
| HANDLER:clbCustomer_SelectedIndexChanged | AS-IS `DMF0042_BizPlan.cs:1598` (라이브 11행) | BusinessPlan.tsx EndCustomer 인라인 onChange — scmSiteIds clear |  | 구현 |
| HANDLER:clbTeam_SelectedIndexChanged | AS-IS `DMF0042_BizPlan.cs:1572` (라이브 21행) | BusinessPlan.tsx TeamField onChange — endCustomers/scmSiteIds clear |  | 구현 |
| HANDLER:spdMain_CellDoubleClick | AS-IS `DMF0042_BizPlan.cs:1661` (라이브 167행) | components/BusinessPlanGrid.tsx:567-618 dblclick — 헤더 드릴다운(Y_/Q_/M_ 토글) + 셀 모달(PROJECT/ITEM) |  | 구현 |
| HANDLER:spdMain_Changed | AS-IS `DMF0042_BizPlan.cs:1863` (라이브 770행) | components/BusinessPlanGrid.tsx:556 cellEditEnded → utils/business-plan.spread.ts `applyCellChange` |  | 구현 |
| HANDLER:spdMain_ComboSelChange | AS-IS `DMF0042_BizPlan.cs:1628` (라이브 28행) | business-plan.constants.ts:131 `GRID_CASCADE_FILTERS` + utils/business-plan.gridCombos.ts `filterComboRowsByRow` |  | 구현 |
| HANDLER:spdMain_EditChange | AS-IS `DMF0042_BizPlan.cs:3038` (라이브 4행) | components/BusinessPlanGrid.tsx:478 beginningEdit — 편집 진입 판정 |  | 구현 |
| HANDLER:spdMain_KeyUp | AS-IS `DMF0042_BizPlan.cs:2806` (라이브 2행) · **사문(빈 몸통)** |  | AS-IS 라이브 2행 = 사문(빈 몸통). 미이관이 파리티 | 제외 |
| HANDLER:spdMain_TopChange | AS-IS `DMF0042_BizPlan.cs:2799` (라이브 5행) |  | AS-IS 라이브 5행 = FarPoint 스크롤 동기 배관. Wijmo 는 가상 스크롤 네이티브 처리 — 플랫폼 차이 | 해당없음 |

## 토큰 대사표 (hook #117 §5.6 — 2026-08-09 실측)

> AS-IS `UP_FX_GetCommonDataList(_DM)` 의 `@CODE + PARAM1~5` 에 대응하는 TO-BE 축.
> **AS-IS 공급 계약 (정본 실측)**: `SpreadInfo.cs:1975~1981` 이 메타 셀 콤보에 커서 `ATTRIBUTE1~5` 를
> `sParam1~5` 로 넘기고, 그 커서(`DMF0042_GET_SPREAD_TITLE`)는
> `ATTRIBUTE1 = @p_division_id` ("COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다" 주석) /
> `ATTRIBUTE2 = CASE WHEN CELL_COMBO_DATA_TYPE='DM_LOOKUP_DIV' THEN C.ATTRIBUTE1 ELSE '' END` 로 채운다.
> ⇒ **모든 메타 셀 콤보에 division**, `DM_LOOKUP_DIV` 에만 추가로 컬럼 `ATTRIBUTE1`(LOOKUP_TYPE).
> BE `BaseService.makeComboQuery` 는 `@토큰` 을 **raw 문자열 치환**하고, 미전달 토큰은 `''` 로 채운다.
> 서버 자동 주입 = `@sesUserId`/`@sesLangCd` 뿐(`/admin/combo` 단건 경로).
> 비관대형(`COL = @t`) + 미전달 = **0행(조용한 빈 콤보)**.
> FE 전달 지점 = `components/BusinessPlanGrid.tsx` `useTabComboQueries` (메타 셀 콤보 전량 1구독).

| SQL_ID | 필요 토큰 | 서버 자동 | FE 전달 | 미전달 | 판정 | 미전달 사유 |
|---|---|---|---|---|---|---|
| DMF0042CellProdSite | - | - | - | - | ✅ |  |
| DMF0042CellProdSiteValid | - | - | - | - | ✅ | 편집판(GRID_EDIT_COMBO) — 무파라미터 |
| DMF0042_BP_Measure | divisionId | - | 동적: divisionId | - | ✅ (동적 전달) |  |
| DM_LOOKUP_DIV | param1, param2 | - | param1=division, param2=컬럼 ATTRIBUTE1 | - | ✅ | **2026-08-09 정정** — 미전달 시 `B.SEGMENT1=@param1 AND A.LOOKUP_TYPE=@param2` 가 비관대형이라 FCST_TYPE 콤보가 항상 0행이었다 |
| CurrencyList | - | - | - | - | ✅ | 편집판(GRID_EDIT_COMBO) — 무파라미터 |
| DeptId | - | - | - | - | ✅ |  |
| EndCustomerByDivision40 | - | - | - | - | ✅ |  |
| EndCustomerByDivisionDept | deptId, divisionId | sesUserId | 동적: divisionId | deptId | ⚠ 관대형 | **행 스코프 토큰** — AS-IS 는 `SetCellTypeCombo` 로 행마다 재바인딩(L1233). TO-BE 는 `GRID_CASCADE_FILTERS.END_CUSTOMER`(DIVISION_ID+DEPT_ID) 로 `beginningEdit` 시 dataMap 스왑 = 행 컨텍스트 필터. 서버 전역 필터로 넘기면 표시용 CODE→NAME 이 깨진다(hook #117 §5.10) |
| FromSiteByDivision | divisionId | - | 동적: divisionId | - | ✅ (동적 전달) |  |
| Incoterms | - | - | - | - | ✅ | INCOTERMS82 표시판 |
| IncotermsEdit | - | - | - | - | ✅ |  |
| SiteByEndCustomer | divisionId, endCustomer | sesUserId | 동적: divisionId | endCustomer | ⚠ 관대형 | **행 스코프 토큰** — AS-IS 는 InsertRow/ComboSelChange 에서 행 EC 로 재바인딩(L1263·L1637·L1656). TO-BE 는 `GRID_CASCADE_FILTERS.SCM_SITE_ID40`(DIVISION_ID+END_CUSTOMER40) 스왑으로 동등 이상(신규행 포함) |

> ⚠ 한계 — 위 2건의 행 스코프 토큰은 **서버 미전달이 의도된 설계**다. 서버에서 좁히면 원장에 남은
> 값의 CODE→NAME 변환이 깨져 raw 코드로 표시된다([[feedback_edit_display_combo_dualization]]).
