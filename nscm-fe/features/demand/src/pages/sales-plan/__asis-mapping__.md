# DMF0021 (Sales Plan) — AS-IS ↔ TO-BE 매핑 (2026-07-15 신규 생성)

> AS-IS 정본: `GSCM.DM.Forms.UIL\Plan\DMF0021_SalesPlan\DMF0021_SalesPlan.cs` 5,599줄 + Designer 1,451줄.
> 분석 정본: `Doc/_analysis/domain_DM/screens/DMF0021_SalesPlan/validation.md`(141) + `expressions.md`(120)
> + `Doc/화면설계서/DMF0021_SalesPlan_UI분석서_v1.0.xlsx`(11시트) + `DMF0021_SalesPlan_상세동작_개발용.md`(38 핸들러).
> 사내 실측 계약(2026-07-14): PROC_M 49 / API_M 14 / BTN_MPG 14 / USER_GR 39, MNU_URL=sales-plan,
> 시트 키 'Sales Plan'/spreadTitle/measureInfo/dayRange/titleSet, MAIN 17키+커서 3(data/calendar/editAuth), SAVE 16키 '^' bulk.
>
> **커버리지 합계: 이벤트 핸들러 38/38 · expressions 120/120 · validation 141/141 (누락 0)**

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
| 32 | InsertRow | 행잠금 | `siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColu…` | 2989 | R5 — PLANT_SITE_ID (81 계열만 개방) |
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
| 93 | spdMain_ComboSelChange | 행잠금 | `e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID` | 4544 | R5 — PLANT_SITE_ID 81 unlock |
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
| 79 | SaveData | MSG00146 | - | 2666 | buildUnfoldRows — MSG00146 {line} (라인 변경 0건) |
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
| 113 | spdMain_ComboSelChange | - | Division | 4541 | editLock R5 — PLANT_SITE_ID 81 계열만 개방 (DIVISION 셀은 insert 잠금 — 조회조건 고정) |
| 114 | spdMain_ComboSelChange | - | Division | 4543 | editLock R5 — PLANT_SITE_ID 81 계열만 개방 (DIVISION 셀은 insert 잠금 — 조회조건 고정) |
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
2. **ITEM_ID insert 콤보 (§6-2)** — AS-IS SALES_PLAN_ITEM_ID(GUBUN 40/81/82 필터) in-memory 콤보. TO-BE CMBO 미등록 → insert 행 텍스트 입력 폴백 (40+Catch_Up 은 모달 1:1). CMBO 등록 시 admin CELL_COMBO_DATA_TYPE 만으로 즉시 콤보화.
3. **CURRENCY insert 콤보** — admin 메타 콤보 미지정('-') → 편집 전용 'CurrencyList'(DMF0020 등록 선례) 스왑 적용. 사내 CMBO 'CurrencyList' 부재 시 텍스트 입력 폴백.
4. **MEASURE 강제 표시** — 사내 SHEET_COLUMNS VISIBLE_FLAG='N' 실측이나 PIVOT 행 식별 키 컬럼 → 강제 표시 (admin 메타 정정 시 제거).
5. **W_ 저장 기준일** — SAVE p_yyyymmdd 를 W_yyyymm+ww → ISO주 월요일(월경계 clamp) 로 산출 (AS-IS B_* 숨김 컬럼 값 미확보 — E2E 저장 왕복 1회 검증 필요).
6. **MSG00085/00146/00361 문구** — 사내 MSG_M [TODO] placeholder. 계약 확정 용법으로 locales 3종 반영 (MSG00361 본문은 잠정 — MSG_M 등록 시 대사). locale JSON 은 gitignore(DB 원천) — 사내 MSG_M 반영 별도.
7. **멀티선택 구분자** — MAIN 조회 콤보 = 콤마 + 'ALL' sentinel (AS-IS CheckedList/DMF0082 계열 준용). SP REGEXP 패턴 실측 대사 1회 권장.
8. **NOTATION 'POINT' 소수 자릿수** — AS-IS 포맷 마스크 미실측 → 최대 1자리 가정 (INTEGER=0/POINT3=3 고정). E2E 82 division 표기 확인.
9. **vitest 환경** — 로컬 node v24 + jsdom 비호환(MIMEType is not a constructor)으로 스토어 테스트 실행 불가 (기존 forecast-price 테스트도 동일 실패 — 사전 존재 환경 이슈).

## 7. 게이트 결과 (2026-07-15)

- features/demand tsc --noEmit 0 errors / eslint 0 errors (warnings 5 = mkt-fcst 원본 동일 패턴: scss 상대 상위 import 2 + non-null 3) / 진입 SalesPlan.tsx 399줄(≤400 — SalesPlanModals 분리)
- apps/web tsc 0 errors (route-paths/Router/procedures.d.ts 배선분)
- 배선 4점: route-paths(DMF0021=sales-plan) / Router(DEMAND_PLAN children) / procedures.d.ts(DMF0021 5시트) / locales(MSG00085·00146·00361)
- BE 무수정 / 기존 화면 파일 수정 = 배선 4점만 (mkt-fcst/forecast-price 무수정 — merge 1단계 복제)
