# DMF0049 ETC Sales Reports — 제약매트릭스 상세

## 0. 원천 (전수 Read 실측)

| 구분 | 파일 | 행수 | Read 범위 |
|---|---|---:|---|
| 정본 화면 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0049_Sales_ETC_Reports\DMF0049_Sales_ETC_Reports.cs` | 1,727 | 전체 (1~1727) |
| 호출 팝업 1 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_United_VersionPopup.cs` | 727 | 전체 |
| 호출 팝업 2 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0002_TitleSetForm_Popup.cs` | 665 | 전체 |
| 호출 팝업 3 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.SCM.Popup.UIL\SCM0002_ProjectbyDivisionPopupEx.cs` | 602 | 전체 |

- 아래 라인번호는 각 파일 실측 라인. 별도 표기 없으면 정본 화면(DMF0049) 라인.
- 화면 구조: 단일 시트 `MDF Reports` (L72). 조회조건 = Division(clbDivision) / Type(clbType, MDF_TYPE lookup) / Year(usrYear) / SP·BP Version(txtSPVersion+btnSPVer) / Plan·Result(clbPlanResult).
- 상태 변수: `gsDivision_id`(L63, 조회 시점 Division 스냅샷 L600), `gsResultMonth`(L64), `gsVersion_no`(L65), `sCUTOFF_YYYYMMDD`(L62, 현재 활성 경로에서는 설정 코드가 주석 처리되어 사용 잔존물).

---

## 1. Division 축 — 분기 전수 (활성 21건)

Division 값 체계: `40`(소형), `81` 계열(`Substring(0,2)=="81"`, 자동차), `82`(ESS).

| # | 라인 | 위치(메서드) | 비교식 | 효과 |
|---:|---|---|---|---|
| 1 | L209 | InitControls | `gsDivision_id != "40"` | 40 이 아닐 때만 `EndCustomerByDivision` 콤보 데이터 fetch (L214) |
| 2 | L295 | DeleteButton | `gsDivision_id == "40"` | Measure 수를 `GetMeasureCntBy40(ActiveRow)` 로 동적 산출 |
| 3 | L298 | DeleteButton | `gsDivision_id == "40"` | 40: span 첫 행 기준으로 2~3행 세트 삭제 (L300~322) |
| 4 | L324 | DeleteButton | (else = 40 아님) | 일반 `GetCellNumbersByRow` 기반 2행 세트 삭제 |
| 5 | L341~342 | EditButton | `NowGroupID=="DM Planner" && gsDivision_id != "82"` | 82 가 아니면 DM Planner 편집 진입 차단 → MSG00096 (권한 축과 결합 게이트) |
| 6 | L399 | EditButton 행 루프 | `gsDivision_id == "40"` | 40 전용 잠금 세트(L401~405) vs 일반 잠금 세트(L409~411) 분기 |
| 7 | L427 | EditButton Plan 분기 | `gsDivision_id != "40"` | 40 외: 미래구간에서 허용 Measure(sEditMeasure) 외 잠금 (L433~436) |
| 8 | L448 | EditButton Result 분기 | `gsDivision_id != "40"` | 40 외: 실적구간에서 허용 Measure 외 잠금 (L454~457) |
| 9 | L689 | SaveData | `gsDivision_id != "40"` | 40 외 Measure Cnt = 1 (기본값도 1이라 실질 no-op, [C20210406-000259] 이력 잔존) |
| 10 | L694 | SaveData 행 루프 | `gsDivision_id == "40"` | 40: 행별 `GetMeasureCntBy40(i)` 재산출 |
| 11 | L742 | SaveData 수집 조건 | `gsDivision_id == "40" && action=="M" && iMeasureCnt>=2` | 40 은 셀 색상(Red) 변경 없어도 M 행 전체 수집 |
| 12 | L743 | SaveData 수집 조건 | `gsDivision_id == "82" && action=="M"` | 82 는 M 행이면 무조건 수집 |
| 13 | L936 | InsertRow | `gsDivision_id.Substring(0,2) == "81"` | 81 계열: 신규 행 Measure Cnt = 2 (기본 3) |
| 14 | L938 | InsertRow | `gsDivision_id == "82"` | 82: Measure Cnt = 1 |
| 15 | L983 | InsertRow 잠금 | `gsDivision_id.Substring(0,2) == "81"` | 81 계열 전용 잠금/해제 세트 + End Customer 권한 콤보 (L985~1002) |
| 16 | L1004 | InsertRow 잠금 | `gsDivision_id == "82"` | 82 전용 잠금/해제 세트 (L1006~1018) |
| 17 | L1076 | InsertRow 재잠금 Plan | `gsDivision_id != "40"` | 40 외 미래구간 허용 Measure 외 잠금 (L1082~1085) |
| 18 | L1097 | InsertRow 재잠금 Result | `gsDivision_id != "40"` | 40 외 실적구간 허용 Measure 외 잠금 (L1103~1106) |
| 19 | L1264 | spdMain_Changed (DEPARTMENT_ID 변경) | `gsDivision_id == "40"` | 40 전용 Department→Team cascade + "기타" 명칭 분기 (L1266/L1291) |
| 20 | L1583 | spdMain_CellClick | `gsDivision_id == "40"` | 40 전용 DEPARTMENT_ID/DEPT_ID/CUST_REPORT Row Span 재구성 |
| 21 | L1616 | GetCellIndexBySpanRowCells40 | `gsDivision_id == "40"` | 40 전용 Measure 순서(SalesAmt_LOC→SalesAmt_KRW→RTF_SYS_RP) 기반 첫 행 산출 |
| +| L1681 | GetMeasureCntBy40 | `gsDivision_id == "40"` (else-if) | DATA_SEQ 없을 때(신규 행) 40 은 Measure 명으로 Cnt 추정 |

> #21 아래 L1681 까지 포함 시 **활성 22건**. 40 = 세트행(2~3 Measure) 특수 UI, 81 계열 = Project/FCST 열 중심, 82 = 단일 Measure + 완화 게이트가 전체 구도.

### 1.1 Division 비활성(주석) 인벤토리 (2건)

| 라인 | 주석 내용 |
|---|---|
| L293~294 | `/*if (gsDivision_id != "40") iMeasureCnt = 3;*/` — 구 Delete 3행 세트 로직 |
| L734 | `if (iMeasureCnt == 3 /*gsDivision_id != "40"*/)` — 조건 치환 이력 |

---

## 2. 권한 축 — NowGroupID / EDIT_FLAG 소비 전수

### 2.1 정본 화면 (8건)

| # | 라인 | 소비 지점 | 내용 |
|---:|---|---|---|
| 1 | L167~168 | SetChangeControl | `Filter["GROUP_ID"]=NowGroupID`, `Filter["USER_ID"]=UserId` → MyDivision / EndCustomerByDivision 데이터 권한 필터 |
| 2 | L341 | EditButton | **그룹 게이트**: `NowGroupID=="DM Planner"` 이고 Division≠82 → MSG00096 후 return (82 는 Planner 편집 허용, [C20210406-000259]) |
| 3 | L555 | FindData | 조회 SP 에 `p_user_group = NowGroupID` 전달 → 서버측에서 행별 EDIT_FLAG 산출 |
| 4 | L989 | InsertRow (81 계열) | `Data.UserEndCustomerByDivisionDeptAuth(NowGroupID, UserId, div, "")` — 권한 있는 End Customer 만 콤보 |
| 5 | L1410 | spdMain_Changed (END_CUSTOMER 변경) | `Data.UserSiteByEndCustomer(NowGroupID, UserId, div, endCust)` — 권한 Site 콤보 |
| 6 | L1056 | InsertRow 재잠금 루프 | **EDIT_FLAG 값 비교**: `EDIT_FLAG == "Y"` 행은 키영역(0~MEASURE) 잠금 |
| 7 | L401 | EditButton (40) | EDIT_FLAG **컬럼 위치**를 잠금 경계로 사용 (0~EDIT_FLAG 열 잠금) — 값 비교 아님 |
| 8 | L766~773 | SaveData | DEPARTMENT_ID 셀 ForeColor==Red → `p_department_edit_flag = "true"` 로 저장 전달 |

### 2.2 팝업측 (5건)

| 라인(파일) | 내용 |
|---|---|
| DMF0044_United L117 | `Data.Common(MyDivision, NowGroupID, UserId)` — Division 콤보 권한 필터 (이후 L120 `Enabled=false` 고정) |
| SCM0002 L219 | 동일 MyDivision 권한 필터 |
| SCM0002 L225 | `Data.UserTeamByDivision(NowGroupID, UserId, div)` |
| SCM0002 L231 | `Data.UserEndCustomerByDivisionDept(NowGroupID, UserId, div, team)` |
| SCM0002 L238 | `Data.UserSiteByEndCustomer(NowGroupID, UserId, div, endCust)` |

### 2.3 DMF0044 형 "이중 게이트" 실측 판정

**이중 게이트 맞음 — 단, 구성이 비대칭.**
1. **클라이언트 그룹 게이트**: EditButton 진입 시 `NowGroupID=="DM Planner" && Division≠82` 차단 (L341~345, MSG00096). 화이트리스트 방식이 아니라 특정 그룹 1개만 블랙리스트하는 형태.
2. **서버 EDIT_FLAG 게이트**: 조회 SP 가 `p_user_group` 을 받아 행별 EDIT_FLAG 를 내려주고(L555), `EDIT_FLAG=='Y'` 행은 키영역이 잠긴다(L1056). 단 이 값 비교 잠금은 **InsertRow 의 재잠금 루프에만 존재**하고 EditButton 루프(L396~461)에는 EDIT_FLAG 값 비교가 없다(EditButton 40 분기는 EDIT_FLAG 를 열 경계로만 사용, L401). 즉 Edit 직후 상태에서는 그룹 게이트+기간/Measure 잠금만 적용되고, EDIT_FLAG 행 잠금은 Insert 를 거칠 때 재적용되는 구조.

---

## 3. Measure / 컬럼 축 — 비교 전수 (15건)

허용 편집 Measure(`sEditMeasure`)는 lookup `DM_SR_ETC_CURRENCY` 를 Division 별로 조회해 결정 (L350~355 EditButton, L951~956 InsertRow — `Data.Common(DM_LOOKUP_DIV, gsDivision_id, "DM_SR_ETC_CURRENCY")`).

| # | 라인 | 비교식 | 효과 |
|---:|---|---|---|
| 1 | L433 | `GetValue(MEASURE) != sEditMeasure` | (Edit·Plan·40외) 미래구간 허용 외 Measure 잠금 |
| 2 | L454 | `GetValue(MEASURE) != sEditMeasure` | (Edit·Result·40외) 실적구간 허용 외 Measure 잠금 |
| 3 | L1082 | `GetValue(MEASURE) != sEditMeasure` | (Insert 재잠금·Plan·40외) 동일 |
| 4 | L1103 | `GetValue(MEASURE) != sEditMeasure` | (Insert 재잠금·Result·40외) 동일 |
| 5 | L1618 | `MEASURE == "RTF_SYS_RP"` | 40 세트 첫 행 = 현재행-2 |
| 6 | L1622 | `MEASURE == "SalesAmt_LOC"` (Cnt2) | 40 세트 첫 행 = 현재행 |
| 7 | L1623 | `MEASURE == "SalesAmt_LOC"` (Cnt3) | 동일 |
| 8 | L1627 | `MEASURE == "SalesAmt_KRW"` (Cnt2) | 40 세트 첫 행 = 현재행-1 |
| 9 | L1628 | `MEASURE == "SalesAmt_KRW"` (Cnt3) | 동일 |
| 10 | L1685 | `MEASURE == "SalesAmt_LOC"` | 신규행 Measure Cnt 추정 시작 |
| 11 | L1689 | `MEASURE(+1행) == "SalesAmt_KRW"` | Cnt=2 판정 |
| 12 | L1696 | `MEASURE(+2행) == "RTF_SYS_RP"` | Cnt=3 판정 |
| 13 | L1702 | `MEASURE == "SalesAmt_KRW"` | Cnt=2 기본 판정 |
| 14 | L1707 | `MEASURE(+1행) == "RTF_SYS_RP"` | Cnt=3 판정 |
| 15 | L1713 | `MEASURE == "RTF_SYS_RP"` | Cnt=3 판정 |

- Measure 값 주입: L1030 `SetValue(MEASURE, dtMeasure.Rows[i]["CODE"])` — `DM.DMF0049_GET_MEASURE`(L1145) 결과 순서대로. 40 의 Measure 고정 순서는 SalesAmt_LOC → SalesAmt_KRW → RTF_SYS_RP (L1608, L1684 주석 명문).
- 세트 행 판정 우선순위: DATA_SEQ 가 있으면 사업부 무관 DATA_SEQ 동일 구간으로 Cnt 산출 (L1648~1680, [C20210506-000051]), 없을 때만 Measure 명 추정.
- 저장 시 Measure 축 무결성: 세트 중 1행이라도 Action 존재 시 세트 전체를 저장 대상으로 승격 (L700~716).

---

## 4. 기간·버전 축 — 검증·과거 잠금·구간 분리 전수 (16건)

기준: `nowYYYYMM = 현재일 yyyyMM`, `nowYYYY = 현재년` (L366~367, L1047~1048, L576). Plan/Result 구간 분리 원칙: "이번달부터 계획구간, 전달까지 실적구간" (L373 주석).

| # | 라인 | 검증/분기 | 내용 |
|---:|---|---|---|
| 1 | L526~530 | 조회 전 검증 | `txtSPVersion.Text == ""` → MSG00283, 조회 중단 |
| 2 | L631~635 | 저장 전 검증 | `txtSPVersion.Text == ""` → MSG00281, 저장 중단 |
| 3 | L370~371 | Edit·Type 분기 | `clbType == "REPORT_BP_M"` → 기준월을 `"201801"` 로 대체 (BP 는 전 구간 Plan 취급, 2020-06-09 이력) |
| 4 | L577~578 | Find·Type 분기 | `clbType == "REPORT_BP_M"` → `nowYYYYMM = "20180101"` (**8자리** — L370/L1050 의 6자리와 불일치. `M_20180101` 컬럼은 없으므로 BP 조회 시 회색 처리 미적용으로 귀결) |
| 5 | L1050~1051 | Insert·Type 분기 | `clbType == "REPORT_BP_M"` → `"201801"` |
| 6 | L415 / L440 | Edit·구간 분리 | `clbPlanResult == "Plan"` 이면 과거 잠금, else(Result) 미래 잠금 |
| 7 | L417~420 | Edit·Plan 과거 잠금 | `M_nowYYYYMM` 컬럼 존재하고 MEASURE+1 보다 뒤면 MEASURE+1 ~ 당월-1 잠금 ([C20201223-000448]) |
| 8 | L421~424 | Edit·과거년도 전체 잠금 | `usrYear < nowYYYY` → MEASURE+1 ~ 끝까지 전부 잠금 ([C20201223-000448]) |
| 9 | L442~445 | Edit·Result 미래 잠금 | `M_nowYYYYMM` ~ 마지막 컬럼 잠금 |
| 10 | L580~588 | Find·Plan 회색 | 당월 이전 컬럼(BG Gainsboro) 처리 |
| 11 | L589~596 | Find·Result 회색 | 당월부터 이후 전부 회색 |
| 12 | L602~609 | Find·Result 기준월 | Result 조회 시 `gsResultMonth = 전월(yyyyMM)` 저장 → 저장 파라미터 `p_result_month` (L756) |
| 13 | L1063~1073 | Insert 재잠금·Plan | #7·#8 과 동일 로직 반복 (EDIT_FLAG≠Y 행 한정) |
| 14 | L1089~1094 | Insert 재잠금·Result | #9 와 동일 반복 |
| 15 | L1535~1538 | Type 라벨 분기 | `clbType == "REPORT_SP_W"` → "SP Version", else "BP Version" |
| 16 | L219 / L1152~1175 | 연도 축 원천 | Year 콤보 = `UP_FX_GetCommonDataList_DM(CODE='CALENDAR_YYYY')` 실측 조회 ([E20250121-000490]; 구 −5년~+10년 하드코딩은 주석 L1155~1169) |

- 버전 선택 자체는 팝업(§7.1) 위임. 화면은 `txtSPVersion` 텍스트만 보관, 조회 시 `p_sp_version_no` 로, 저장 시 조회 시점 스냅샷 `gsVersion_no`(L601) 로 전달.

---

## 5. FCST_TYPE 축 — 비교 전수

**FCST_TYPE 값 비교(등호/부등호) 는 0건 — 없음 (정직 표기).**

FCST_TYPE 이 등장하는 지점 전수:

| 라인 | 성격 |
|---|---|
| L121 | 컬럼 상수 정의 (`DefColumns.FCST_TYPE`) |
| L987~988 | InsertRow 81 계열: FCST_TYPE 컬럼이 존재하면 FCST_TYPE ~ MEASURE 열 잠금 (존재 여부 검사만, 값 비교 아님) |
| L807~808 | 저장 수집: `p_fcst_type += "^" + GetValue(FCST_TYPE)` |
| L874 | 저장 SP 파라미터 `p_fcst_type` 전달 |

---

## 6. 잠금(Lock) 전수 — 활성 41건 (1건 1행)

`true`=잠금, `false`=해제. SwitchLock 포함.

### 6.1 EditButton (14건)

| # | 라인 | 호출 | 범위 | 조건 |
|---:|---|---|---|---|
| 1 | L358 | `SwitchLock()` | 시트 전체 토글 | Edit 진입 |
| 2 | L401 | LockRange true | 0 ~ EDIT_FLAG 열 | 행별 · Div=40 |
| 3 | L402 | LockRange true | T_DEPARTMENT_NAME | Div=40 |
| 4 | L403 | LockRange true | T_DEPT_NAME | Div=40 |
| 5 | L404 | LockRange true | END_CUST_REPORT ~ COUNTRY_CODE | Div=40 |
| 6 | L405 | LockRange true | MEASURE | Div=40 |
| 7 | L409 | LockRange true | 0 ~ MEASURE 열 | Div≠40 |
| 8 | L410 | LockRange true | T_DEPARTMENT_NAME | Div≠40 |
| 9 | L411 | LockRange true | T_DEPT_NAME | Div≠40 |
| 10 | L419 | LockRange true | MEASURE+1 ~ M_당월−1 | Plan, 당월 컬럼 존재 |
| 11 | L423 | LockRange true | MEASURE+1 ~ 끝 | Plan, 조회년<현재년 |
| 12 | L435 | LockRange true | M_당월 ~ 끝 | Plan, Div≠40, Measure≠sEditMeasure |
| 13 | L444 | LockRange true | M_당월 ~ 끝 | Result |
| 14 | L456 | LockRange true | MEASURE+1 ~ M_당월−1 | Result, Div≠40, Measure≠sEditMeasure |

### 6.2 FindData (1건)

| # | 라인 | 호출 | 범위 | 조건 |
|---:|---|---|---|---|
| 15 | L570 | LockColumn true | 0 ~ 전 컬럼 | 조회 직후 전체 잠금 (Edit 전 읽기전용) |

### 6.3 InsertRow (26건)

| # | 라인 | 호출 | 범위 | 조건 |
|---:|---|---|---|---|
| 16 | L966 | LockRange true | T_DEPARTMENT_NAME | 신규 세트 행별, 컬럼 존재 시 |
| 17 | L968 | LockRange true | T_DEPT_NAME | 〃 |
| 18 | L970 | LockRange true | CUTOFF_YYYYMMDD | 〃 |
| 19 | L972 | LockRange true | NICK_NAME | 〃 |
| 20 | L974 | LockRange true | SCM_SITE_ID | 〃 |
| 21 | L976 | LockRange true | BIZ_TYPE_NAME | 〃 |
| 22 | L978 | LockRange true | DMS_CUSTOMER | 〃 |
| 23 | L986 | LockRange **false** | PROJECT_CODE | Div=81계열 (편집 개방) |
| 24 | L988 | LockRange true | FCST_TYPE ~ MEASURE | Div=81계열 |
| 25 | L993 | LockRange **false** | SCM_SITE_ID | Div=81계열 (#20 재해제) |
| 26 | L995 | LockRange **false** | CURRENCY | Div=81계열 |
| 27 | L997 | LockRange **false** | ETC_DESCR | Div=81계열 (⚠ 가드가 `GetColumnIndex(CURRENCY) != -1` — ETC_DESCR 아닌 CURRENCY 존재 검사. 원본 결함 실측) |
| 28 | L1000 | LockRange true | CELL_MODEL_INFO | Div=81계열 |
| 29 | L1006 | LockRange **false** | PROJECT_CODE | Div=82 |
| 30 | L1009 | LockRange **false** | END_CUSTOMER | Div=82 |
| 31 | L1011 | LockRange **false** | SCM_SITE_ID | Div=82 |
| 32 | L1013 | LockRange **false** | CURRENCY | Div=82 |
| 33 | L1015 | LockRange true | ITEM_ID | Div=82 |
| 34 | L1018 | LockRange true | CELL_MODEL_INFO | Div=82 |
| 35 | L1029 | LockRange true | MEASURE | 신규 세트 공통 (직후 L1030 Measure 값 주입) |
| 36 | L1058 | LockRange true | 0 ~ MEASURE | 전 행 재루프: EDIT_FLAG=='Y' 행 |
| 37 | L1068 | LockRange true | MEASURE+1 ~ M_당월−1 | EDIT_FLAG≠Y, Plan, 당월 컬럼 존재 |
| 38 | L1072 | LockRange true | MEASURE+1 ~ 끝 | EDIT_FLAG≠Y, Plan, 조회년<현재년 |
| 39 | L1084 | LockRange true | M_당월 ~ 끝 | EDIT_FLAG≠Y, Plan, Div≠40, Measure≠sEditMeasure |
| 40 | L1093 | LockRange true | M_당월 ~ 끝 | EDIT_FLAG≠Y, Result |
| 41 | L1105 | LockRange true | MEASURE+1 ~ M_당월−1 | EDIT_FLAG≠Y, Result, Div≠40, Measure≠sEditMeasure |

### 6.4 잠금 상태 판독 (IsLock, 3건)

| 라인 | 위치 | 내용 |
|---|---|---|
| L638 | SaveData | `IsLock == false` (Edit 상태) 일 때만 저장 진행 |
| L928 | InsertRow | 동일 게이트 |
| L1581 | spdMain_CellClick | 편집 상태에서만 40 Row Span 재구성 |

### 6.5 팝업측 잠금 (4건)

| 파일·라인 | 호출 | 내용 |
|---|---|---|
| DMF0044_United L246 | LockColumn true | DIVISION_ID ~ 끝 (전체 읽기전용) |
| SCM0002 L390 | LockColumn true | 0 ~ 끝 (전체 읽기전용) |
| TitleSet L191 | `Columns[..].Locked = true` | Base 시트 전 컬럼 잠금 |
| TitleSet L209 | `Columns[..].Locked = true` | User 시트 0 ~ COLUMN_LABEL_NAME 잠금 (Sort/SubTotal 만 편집) |

### 6.6 비활성(주석) 잠금 인벤토리 (11건)

| 라인 | 내용 |
|---|---|
| L362 | `//LockColumn(0, MEASURE, true)` |
| L378~381 | 주석 블록: Plan 시 당월부터 해제 `LockColumn(M_당월, 끝, false)` |
| L385~388 | 주석 블록: Result 시 MEASURE+1 ~ 당월−1 해제 |
| L980~981 | `/*CELL_MODEL_INFO 잠금*/` (신규 세트 공통) |
| L1001~1002 | `//Cell_Name 해제` (81계열) |
| L1019~1020 | `//Cell_Name 잠금` (82) |
| L1022~1023 | `//PROJECT_CODE+1 ~ MEASURE 잠금` (82) |
| L1033~1034 | `//BIZ_TYPE_NAME40 잠금` |
| L1035~1036 | `//DMS_SALES 잠금` |
| L1037~1038 | `//COMPANY_ID 잠금` |
| L1039~1040 | `//APPLICATION 잠금` |

---

## 7. 호출 팝업 제약 전수 — 활성 3건 / 비활성 2건

### 7.1 DMF0044_United_VersionPopup (버전 선택) — 호출부 L1234~1240 (btnSPVer_Click)

- 호출 파라미터: `Form_Load(clbDivision.ControlValues, clbType.ControlValues)` → 팝업 `_sDiv`/`_sType`. 반환 = `pop.sVersions` → `txtSPVersion.Text`.
- 조회조건 제약: Division 콤보 = MyDivision 권한 필터 후 `Enabled=false` 고정(팝업 L117~120). 기간 기본 = 전월~+5개월(L122~124). Type 콤보 = `_sType=="REPORT_SP_W"` 이면 `MDF_TYPE_SP_POPUP`, 아니면 `MDF_TYPE_BP_POPUP` lookup (L130~137).
- Type 별 버튼 노출(ControlDisplay L503~579): `SP_W`/`BP_M`/`SP_M` = 버전생성만 노출, 그 외(REPORT_* copy 계열) = Transfer/Cancel/Copy/Delete/OK/실적포함/기준일 노출. MV(월) 입력은 `SP_W`/`SP_M`/`REPORT_SP_W` 만 노출 (L520~529, L557~566).
- 행 선택 제약: 클릭한 1행만 (giRowIndex, SingleCheck L323~347 — 다중선택 검증 MSG00279 는 전량 주석 = 비활성). 더블클릭 확정은 `REPORT_BP_M`/`REPORT_SP_W` 타입일 때만 (L351~356).
- SEND_YN 상태 게이트: Transfer = `SEND_YN=='N'` 만 (L384, 아니면 MSG00318 확인), Cancel = `'Y'` 만 (L404, MSG00195 확인 / 아니면 MSG00319), Delete = `'N' or 'C'` 만 (L428, MSG00016 확인 / 아니면 MSG00320), Copy = 실적 미포함 시 MSG00314 확인 (L458).
- 실적포함 체크 시 기준일 활성+Update 강제 Y (chkResult_CheckedChanged L302~321); MV 체크 시 전월 기본 (chkMV L713~725).
- 호출 SP: 아래 §8.2 표.
- 저장 결과: `"success"` 면 MSG00004 후 재조회, 아니면 반환 문자열을 MSG ID 로 표시 (L608~616, L663~672).

### 7.2 SCM0002_ProjectbyDivisionPopupEx (Project 선택) — 호출부 L1428~1457 (spdMain_CellDoubleClick, PROJECT_CODE 컬럼)

- 호출 파라미터: `Form_Load(false, gsDivision_id, "ALL", "ALL", "ALL", 현재셀 Project, true)` — 단일선택, Team/EndCustomer/Site = "ALL", **ETC=true** ([PJ20200138] ETC 체크박스 노출 + 기본 체크, 팝업 L248~255).
- 조회조건 제약: Division/Team/EndCustomer/Site 콤보 전부 권한 필터(NowGroupID) 후 `Enabled=false` 고정 (팝업 L257~260). Project 텍스트만 입력 가능 (Enter 로 조회 L589~595).
- 그리드: 조회 후 전체 잠금(L390), OK 또는 더블클릭으로 확정 (L433~436, L443~447). 반환 = ProjectCode/ProjectName → 본화면 셀 SetText (L1449~1456, `sProject != ""` 일 때만).
- 검증 MSG: 활성 0건 (다중선택 빈선택 경고 주석 L514). 저장 없음 (SaveData 빈 몸체 L415~417).
- Team 파라미터는 [E20260211-001049] 로 ALL 원문 전달 (팝업 L373~376) — 82 사업부 Project 입력 불가 수정 이력.

### 7.3 DM0002_TitleSetForm_Popup (Measure Setting) — 호출부 L1543~1554 (btnMeasure_Click)

- 호출 파라미터: `new DM0002_TitleSetForm_Popup("DMF0049", siMain.SheetName, false, clbDivision.SelectedValue)` — isColumn=false → **Measure Setting 모드**(`_sTitleSetType="M"`), Division 전달 ([C20210125-000207], 팝업 L75~85).
- 확정 시 `DialogResult.OK` → 본화면 `InitSpread()` 재실행 (L1550~1553) — 헤더 재생성으로 즉시 반영.
- 제약: Base 시트 전 컬럼 잠금(팝업 L191), User 시트 라벨 영역 잠금(L209), 행 Drag 이동은 `USER_SELECTABLE_FLAG=='Y'` 행만 (L628~635), SubTotal 은 단일 행만 체크 유지 (spdUser_ButtonClicked L589~599).
- 검증 MSG: 저장 대상 0건 → MSG00093 `{Column|Measure}` (L542~546), 저장 성공 MSG00020 (L530), 예외 MSG00006 (L565). (MSG00005 는 주석 인벤토리 L539/L556.)
- 저장 파라미터: active_flag 전행 `"I"`, sort_order_no = 순번(또는 BaseSort 시 공백), sub_total_flag Y/N, `^` 구분 문자열 (L447~500).

### 7.4 비활성(주석) 팝업 인벤토리 (2건)

| 라인 | 팝업 | 내용 |
|---|---|---|
| L1242~1249 | `DMF0044_Sales_VersionPopUp` | 구 버전선택. `sCUTOFF_YYYYMMDD` 수신 코드 포함 — 주석화로 현재 sCUTOFF_YYYYMMDD 는 항상 "" |
| L1461~1477 | `DM0002_ItembyDivisionPopupEx` | ITEM_ID 더블클릭 Item 선택("기타매출" 제외) — "콤보로 변경함" 주석과 함께 비활성 |

---

## 8. 호출 SP 전수 (실명 + 파라미터 수)

### 8.1 정본 화면 — FoxDataRequest 직접 호출 6종

| # | SP (FoxDataRequest) | 호출 라인 | 파라미터 수 | 파라미터 실명 | 비고 |
|---:|---|---|---:|---|---|
| 1 | `DM.DMF0049_GET_SPREAD_TITLE` | L254 | 4 | p_division_id, p_created_by, p_start_dt(년+0101), p_end_dt(년+1231) | InitSpread 헤더 |
| 2 | `DM.DMF0049_GET_SALES_ETC_REPORTS_DATA` | L549 | 6 | division_id, p_mdf_type, p_yyyy, p_sp_version_no, p_user_group, p_created_by | Timeout 600s. p_user_group=NowGroupID |
| 3 | `DM.DMF0049_SAVE_SALES_ETC_REPORT_C` | L849 | 36 | p_active_flag, p_result_month, p_division_id, p_version_no, p_data_seq, p_department_id, p_department_edit_flag, p_department_name, p_dept_id, p_cust_report, p_end_cust_report, p_soldto_code, p_soldto_cust_report, p_product_group, p_item_id, p_product_details, p_currency, p_company_id, p_biz_type, p_application_gr, p_application, p_country_code, p_project_code, p_scm_site_id, p_fcst_type, p_item_use, p_soldto_country, p_shipto_country, p_end_customer, p_etc_descr, p_cell_model_info, p_measure, p_yyyymmdd, p_qty, p_created_by, p_cell_model | `^` 구분 병렬 문자열, Timeout 600s. 결과 `"success"` 판정 L892 |
| 4 | `SCM.SCM0001_GET_LOOKUP_VALUES` | L1130 | 1 | p_lookup_type | GetLookupData — MDF_TYPE(L204)/DM_COMPANY(L223)/REPORT_GROUP3(L1338) |
| 5 | `DM.DMF0049_GET_MEASURE` | L1145 | 1 | p_division_id | Measure 목록 |
| 6 | `DM.UP_FX_GetCommonDataList_DM` | L1184 | 6 | CODE(=CALENDAR_YYYY), PARAM1~PARAM5(공백) | 연도 콤보 [E20250121-000490] |

### 8.1b 정본 화면 — 프레임워크 래퍼 경유 데이터 호출 (간접 SP, 9종)

| 래퍼 | 호출 라인 | 인자 |
|---|---|---|
| `DataService.GetDMInnerTable("MyDivision", Filter)` | L174 | GROUP_ID, USER_ID |
| `DataService.GetDMInnerTable("EndCustomerByDivision", Filter)` | L182 | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID |
| `DataService.FP_Log2("SpeedUp","DMF0049",...)` | L194, L217 | 속도개선 로그 [PJ202350699] |
| `Data.Common(Data.Type.DM_LOOKUP_DIV, div, "DM_SR_ETC_CURRENCY")` | L350, L951 | 허용 편집 Measure |
| `Data.Common(Data.Type.DMF0044_DEPARTMENT_TEAM2, div, "", ["","Y"])` | L958, L1294 | Team 콤보 |
| `Data.Common(Data.Type.DMF0044_DEPARTMENT_TEAM, deptId, "")` | L1268 | 40 Department→Team cascade |
| `Data.Common(Data.Type.END_CUST_REPORT, "", "")` | L1337 | End Cust Report 콤보 |
| `Data.Common(Data.Type.DMF0005_REPORT_GROUP2, "", "")` | L1346, L1367, L1597 | Cust Report 콤보 |
| `Data.UserEndCustomerByDivisionDeptAuth` (L989) / `Data.UserSiteByEndCustomer` (L1410) | — | 권한 콤보 (§2.1) |

### 8.2 DMF0044_United_VersionPopup — 5종 (+래퍼 1)

| SP | 라인(팝업) | 파라미터 수 | 파라미터 실명 |
|---|---|---:|---|
| `DM.DMF0044_GET_SALES_VERSION_POPUP` | L233 | 5 | p_division_id, p_sdt, p_edt, p_version_type, p_Description (Timeout 600s) |
| `DM.DMF0000_GET_COMMON_SPREAD_TITLE` | L274 | 6 | p_start_yyyymmdd, p_end_yyyymmdd, p_created_by, p_program_id(=DMF0044), p_sheet_name(=MDFVerpopup), p_division_id |
| `SCM.SCM0001_GET_LOOKUP_VALUES` | L294(GetLookupValues)·L364(GetLookupData) | 1 | p_lookup_type (MDF_TYPE_SP_POPUP / MDF_TYPE_BP_POPUP) |
| `DM.DMF0044_MOBILE_REPORT_CREATE` | L593 | 5 | p_division_id, p_version_no, p_version_type, p_action_type(T/C), p_created_by (Timeout 600s) |
| `DM.DMF0044_SAVE_SALES_PLAN_VERSION_COPY` | L642 | 8 | p_division_id, p_version_no, p_version_description, p_created_by, p_result_date, p_action_type(D/CP/CR), p_mv_plan_yyyymm, p_update_yn (Timeout 600s) |
| (래퍼) `Data.Common(MyDivision)` | L117 | — | NowGroupID, UserId |

### 8.3 SCM0002_ProjectbyDivisionPopupEx — 활성 2종 (+래퍼 4, 비활성 4)

| SP | 라인(팝업) | 파라미터 수 | 파라미터 실명 |
|---|---|---:|---|
| `DM.SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX` | L368 | 6 | p_division_id, p_dept_id, p_end_customer, p_scm_site_id, p_project_code, p_etc |
| `DM.DM0000_GET_COMMON_SPREAD_TITLE` | L455 | 5 | p_start_yyyymmdd, p_end_yyyymmdd, p_created_by, p_program_id(=SCM0002), p_sheet_name(=ProjectPopup) |
| (래퍼 활성) MyDivision(L219) / UserTeamByDivision(L225) / UserEndCustomerByDivisionDept(L231) / UserSiteByEndCustomer(L238) | — | — | 권한 콤보 4종 |
| (비활성 — 메서드 존재하나 호출부 전량 주석) `SCM.SCM0001_GET_DIVISION`(L537, 0개) / `SCM.SCM0001_GET_TEAM_BY_DIVISION`(L550, 1개) / `SCM.SCM0001_GET_CUSTOMER_BY_DIVISION`(L564, 2개) / `SCM.SCM0001_GET_SITE_BY_DIVISION`(L579, 3개) | — | — | dead method |

### 8.4 DM0002_TitleSetForm_Popup — 2종

| SP | 라인(팝업) | 파라미터 수 | 파라미터 실명 |
|---|---|---:|---|
| `DM.DMF0002_GET_TITLESET_POPUP` | L244 | 5 | p_program_id, p_sheet_name, p_column_type(=M), p_user_id, p_division_id |
| `SCM.SCM0002_SET_TITLESET_POPUP` | L430/L510 | 9 | p_program_id, p_sheet_name, p_column_type, p_active_flag, p_column_name, p_sort_order_no, p_sub_total_flag, p_sort_method_code, p_user_id |

---

## 9. 검증(MSG) 전수 — 정본 화면 활성 7지점

| 라인 | MSG ID | 트리거 | 내용 |
|---|---|---|---|
| L344 | MSG00096 | Edit, DM Planner & Div≠82 | 편집권한 차단 |
| L528 | MSG00283 | Find, 버전 미선택 | 조회 중단 |
| L633 | MSG00281 | Save, 버전 미선택 | 저장 중단 |
| L748 | MSG00002 {"Department"} | Save, DEPARTMENT_ID 공백 | 필수값 검증, 저장 중단 |
| L894 / L903 | MSG00004 {iCount} | Save 성공("success") | 성공 건수 표시 후 재조회 |
| L899 | (SP 반환 문자열) | Save 실패 | SP 가 돌려준 값을 MSG ID 로 표시 |
| L619 / L915 | GMessageBoxForException | 조회/저장 예외 | 예외 표준 표시 |

팝업 MSG 는 §7.1(MSG00318/00195/00319/00016/00320/00314/00004 + 주석 MSG00279), §7.3(MSG00020/00093/00006 + 주석 MSG00005) 참조.

---

## 10. 축별 카운트 요약

| 축 | 활성 | 비활성(주석) | 비고 |
|---|---:|---:|---|
| 1. Division 분기 | 22 | 2 | 40 / 81계열(Substring) / 82 삼분 구도 |
| 2. 권한 소비 (NowGroupID·EDIT_FLAG) | 정본 8 + 팝업 5 = 13 | 0 | 이중 게이트 실측 = 예 (그룹 게이트 + 서버 EDIT_FLAG, 단 EDIT_FLAG 행잠금은 InsertRow 루프에만) |
| 3. Measure 비교 | 15 | 0 | sEditMeasure 4 + 리터럴(LOC/KRW/RTF_SYS_RP) 11 |
| 4. 기간·버전 검증/잠금/분리 | 16 | 1 (연도 하드코딩 L1155~1169) | REPORT_BP_M 기준월 "201801" vs FindData "20180101" 8자리 불일치 실측 |
| 5. FCST_TYPE 값 비교 | **0 (없음)** | 0 | 존재검사·잠금·저장전달 4지점만 |
| 6. Lock 호출 (LockRange/LockColumn/SwitchLock) | 정본 41 + 팝업 4 = 45 | 11 | 해제(false) 9건 포함. L997 ETC_DESCR 가드 오기(CURRENCY 검사) 실측 |
| 7. 호출 팝업 | 3 | 2 | United_Version / ProjectbyDivisionEx(ETC=true) / TitleSet(Measure 모드) |
| 8. 호출 SP (FoxDataRequest 직접) | 정본 6 + 팝업 9 = 15 | 4 (SCM0002 dead helper) | SAVE SP 파라미터 36개, 조회·저장 Timeout 600s |
| 9. 검증 MSG (정본) | 7지점 | — | 팝업 포함 시 활성 MSG ID 15종 |
