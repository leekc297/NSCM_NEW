# DMF0042 (Business Plan) — AS-IS ↔ TO-BE 매핑 (2026-07-15 신규 생성)

> AS-IS 정본: `GSCM.DM.Forms.UIL\Plan\DMF0042_1_BizPlan\DMF0042_1_BizPlan.cs` 3,477줄 + Designer 1,613줄
> (5벌 병존 중 _1 채택 — CELL_PER_CAR/MODULE_PER_CAR/UNIT_ENERGY 최신 + ExchangeRatePopup 배선).
> 분석 정본: `Doc/_analysis/domain_DM/screens/DMF0042_1_BizPlan/validation.md`(99) + `expressions.md`(66)
> + `Doc/화면설계서/DMF0042_BizPlan_UI분석서_v1.0.xlsx`(11시트) + `DMF0042_BizPlan_상세동작_개발용.md`(이벤트 28 전수).
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
| btnColumn 'Column Show' | 커스텀 버튼(icon) → ColumnSettingModal + saveTitleSet('C') | ✅ |
| btnMeasure 'Measure' | 커스텀 버튼(icon) → MeasureSelectModal + saveTitleSet('M') + invalidate 재조회 | ✅ |
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
| 12 | btnColumn_Click (L2807~2817) | TitleSet 팝업(true=Column) → OK 시 InitSpread | ColumnSettingModal + saveTitleSet('C') + fetchStaticColumns | ✅ |
| 13 | btnMeasure_Click (L2819~2830) | TitleSet 팝업(false=Measure) → OK 시 InitSpread | MeasureSelectModal + saveTitleSet('M') + invalidate 재조회 | ✅ |
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

## 7. 검증 이력

- tsc(features/demand + foundation + apps/web) 0 / eslint --quiet 0 (2026-07-15)
- vitest useBusinessPlanStore.test.tsx — 환경 이슈(Node v24 ↔ jsdom "MIMEType is not a constructor")로 실행 불가.
  기존 sales-plan 테스트도 동일 실패 실측 → 코드 무관 환경 회귀 (별도 인프라 이슈)
- DB 적용: P0a/P0b + P1~P6 스크립트 작성 완료 — 일괄 승인 대기 (미적용)
