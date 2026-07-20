# DMF0042 Business Plan — 제약매트릭스 상세 (AS-IS 소스 전수 실측)

**분석일**: 2026-07-20
**원천 소스 (전체 Read, 전수 스캔)**:

| 파일 | 경로 | 행수 |
|---|---|---:|
| 메인 화면 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0042_BizPlan\DMF0042_BizPlan.cs` | 3,564 |
| 환율 팝업 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0042_ExchangeRatePopup.cs` | 677 |

**표기 원칙**: 라인번호는 위 원천 파일 기준. 활성 코드만 각 축 표에 수록하고, 주석(비활성) 코드는 §8 "비활성 인벤토리"에 분리. 소스에 없는 것은 "없음"으로 정직 표기.

**전제 지식**:
- Division 3계열: `40`(소형), `81*`(자동차 — `Substring(0,2)=="81"` 프리픽스 비교이므로 811/812 등 81계열 전체), `82`(ESS — else 분기이므로 40/81* 이외 전부가 82 취급).
- 그리드 데이터 컬럼 태그: `M_yyyyMMdd`(월), `Q_yyyy_q`(분기 SUM), `Y_yyyy`(연 SUM).
- Measure 행 세트: `DMF0042_BP_Measure` 콤보 결과(dtMeasure) 행수 단위로 1 키조합 = N행(행 블록).
- 셀 ForeColor `Red` = "수정됨" 마커(SetCellColor, L3353~3360). 저장 시 Red 셀만 수집.

---

## 1. Division 축 (40 / 81계열 / 82) — 분기 전수 22곳

메인 소스에서 division 값을 비교·분기하는 모든 위치. (콤보 데이터 소스, 컨트롤 활성/비활성, 필수값 세트, 편집 개방, 파생 브랜치)

| # | 위치(메서드) | 조건식(요약) | 40 동작 | 81계열 동작 | 82(else) 동작 | 라인 |
|---:|---|---|---|---|---|---|
| 1 | `InitControls` | `sDivision=="40"` / `Substring(0,2)=="81"` / else | BizType=`DM_BIZ_TYPE`(전체), Customer=`EndCustomerByDivision40`, **lblProject·lblPlantSite·btnProject Enabled=false**, Measure=`DMF0042_BP_Measure("40")` | BizType=`SCM0001_GET_BIZ_TYPE_BY_DIVISION(sDivision)`, Customer=`UserEndCustomerByDivisionDept`, Project·PlantSite·btnProject **Enabled=true**, Measure=`DMF0042_BP_Measure(sDivision)` | 81과 동일 콤보 소스, Enabled=true, Measure=`DMF0042_BP_Measure("82")` | 264~305 |
| 2 | `InitSpread` | (파라미터 전달) | `CreateSheetHeaderColumnDtDiv(..., clbDivision.SelectedValue)` — division 별 타이틀(컬럼 세트) 구성 | 동일(division 값만 다름) | 동일 | 389 |
| 3 | `InitSpread` | `clbDivision.ControlValues.Equals("40") && CELL_PROD_SITE 컬럼 존재` | `GetCellProdSite("DM_CELL_PROD_SITE","ALL")` 로 CELL_PROD_SITE 콤보 재설정(코드→한글 표시, E20240731-000845) | 동작 없음 | 동작 없음 | 392~398 |
| 4 | `EditButton` (Monthly) | `sDivision=="40" && valid_YN=="Y"` | M_ 버킷 중 `start_YYYYMM~end_YYYYMM` 창 밖 컬럼 잠금 | 창 잠금 없음(M_ 전체 개방) | 창 잠금 없음 | 588~595 |
| 5 | `EditButton` (Quarterly) | `sDivision=="40" && valid_YN=="Y" && start/end_YYYYQQ!=""` | Q_ 중 창 밖만 잠금(창 안 직접입력 허용) | **else → Q_ 전체 잠금(직접입력 차단)** | Q_ 전체 잠금 | 604~615 |
| 6 | `EditButton` (Yearly) | `sDivision=="40" && valid_YN=="Y" && start/end_YYYY!=""` | Y_ 중 창 밖만 잠금 | **else → Y_ 전체 잠금(직접입력 차단)** | Y_ 전체 잠금 | 624~635 |
| 7 | `SaveData` (Business_Plan 행 파라미터) | 셀 `DIVISION_ID=="40"` / `.Substring(0,2)=="81"` / else | 필수값: END_CUSTOMER40·SCM_SITE_ID40·ITEM_ID40·CURRENCY·FCST_TYPE·INCOTERMS·CELL_PROD_SITE (누락 시 MSG00310). ProjectCode←END_CUSTOMER40, Site←SCM_SITE_ID40, Item←ITEM_ID40, Dept←DEPT_ID40, BizType←BIZ_TYPE_NAME40 | 필수값: PROJECT_CODE·DEPT_ID·SCM_SITE_ID81·**PLANT_SITE_ID**·ITEM_ID·END_CUSTOMER·FCST_TYPE·INCOTERMS·CURRENCY. ProjectCode←PROJECT_CODE, Site←SCM_SITE_ID81, BizType←BIZ_TYPE_NAME81 | 필수값: DEPT_ID·CURRENCY·**UNIT_ENERGY** 만. ProjectCode←PROJECT_CODE82, Site←SCM_SITE_ID82, BizType←BIZ_TYPE_NAME82 (INCOTERMS82 는 주석=미전송) | 958~1044 |
| 8 | `SaveData` (LOC 행 파라미터) | 동일 3분기(재실행) | ProjectCode←END_CUSTOMER40, Site←SCM_SITE_ID40, Item←ITEM_ID40, Dept←DEPT_ID40, BizType←BIZ_TYPE_NAME40 (필수값 재검증 없음) | ProjectCode←PROJECT_CODE, Site←SCM_SITE_ID81, **PLANT_SITE_ID 전송**, BizType←BIZ_TYPE_NAME81 | ProjectCode←PROJECT_CODE82, Site←SCM_SITE_ID82, BizType←BIZ_TYPE_NAME82 | 1075~1118 |
| 9 | `InsertRow` (Customer 소스) | `sDivision=="40"` / else | 신규행 Customer 소스 재조회 안 함(요구사항 없음 — 40 분기 본문 전체 주석) | `UserEndCustomerByDivisionDeptAuth(...)` 로 dtCustomer 갱신 | 81과 동일 | 1226~1233 |
| 10 | `InsertRow` (SalesSite 소스) | 3항 연산 `(sDivision=="40") ?` | `UserSiteByEndCustomerAuth` | `UserSiteByEndCustomer` | `UserSiteByEndCustomer` | 1248~1249 |
| 11 | `InsertRow` (Dept 콤보 배선) | `sDivision=="40"` / `!="40"` | DEPT_ID40 컬럼에 dtTeamAuth 콤보 | DEPT_ID 컬럼에 dtTeamAuth 콤보 | DEPT_ID 컬럼에 dtTeamAuth 콤보 | 1254~1257 |
| 12 | `InsertRow` (CELL_PROD_SITE 콤보) | `sDivision=="40" && CELL_PROD_SITE 존재` | `GetCellProdSite("DM_CELL_PROD_SITE","Y")` 콤보(유효건만) | 없음 | 없음 | 1274~1278 |
| 13 | `InsertRow` (PROJECT_CODE 잠금) | `sDivision=="40" && PROJECT_CODE 존재` | 신규행 PROJECT_CODE 잠금(40은 프로젝트 미사용) | 개방(팝업 입력) | 개방 | 1292~1293 |
| 14 | `InsertRow` (PLANT_SITE_ID 잠금) | `sDivision.Substring(0,2)!="81"` | 잠금 | **개방(81계열만 Plant Site 입력 가능)** | 잠금 | 1320~1324 |
| 15 | `InsertRow` (버킷 편집창) | #4~#6 과 동일 3벌 | 40+valid_YN=Y: M_/Q_/Y_ 창 밖 잠금 | 비40: Q_/Y_ 전체 잠금, M_ 개방 | 동일 | 1406~1461 |
| 16 | `cboDivision_SelectedIndexChanged` | #1과 동일 3분기 | #1과 동일(BizType·Customer·라벨 Enabled·Measure 재설정) + Team/SalesSite/PlantSite/Bucket/기간/ItemType/Currency 재로딩, txtProject·txtItemId·txtOwner 클리어 | 동일 | 동일 | 1498~1569 |
| 17 | `clbTeam_SelectedIndexChanged` | `(Substring(0,2)=="81") \|\| (=="82")` / else | else 취급: Customer=`EndCustomerByDivision40`, SalesSite=`SiteByEndCustomer40` | Customer=`UserEndCustomerByDivisionDept`, SalesSite=`UserSiteByEndCustomer` | 81과 동일 | 1577~1595 |
| 18 | `clbCustomer_SelectedIndexChanged` | `(Substring(0,2)=="81") \|\| (=="82")` / else | else: SalesSite=`SiteByEndCustomer40` | SalesSite=`UserSiteByEndCustomer` | 81과 동일 | 1601~1609 |
| 19 | `spdMain_ComboSelChange` | `sDivision=="40"` 한정 | END_CUSTOMER40 변경→SCM_SITE_ID40 콤보 cascade; DEPT_ID40 변경→END_CUSTOMER40+SCM_SITE_ID40 콤보 cascade(팀 빈값이면 조회조건 팀 사용) | 셀 cascade 없음 | 셀 cascade 없음 | 1630~1658 |
| 20 | `fnValidation` (키 수집) | `Substring(0,2)=="81"` / `=="40"` | sProjectCode←END_CUSTOMER40 | sProjectCode←PROJECT_CODE | (82 분기 주석 — 수집 없음) | 3218~3230 |
| 21 | `fnValidation` (내부 루프) | `Substring(0,2)=="81"` / `=="82"` / else | 컬럼 존재 체크: DIVISION_ID·END_CUSTOMER40·SCM_SITE_ID40·ITEM_ID40·MEASURE·CURRENCY | DIVISION_ID·PROJECT_CODE·DEPT_ID·END_CUSTOMER·CURRENCY·MEASURE | DIVISION_ID·DEPT_ID·MEASURE·CURRENCY | 3255~3325 |
| 22 | `MinColumnChk` | `Substring(0,2)=="81"` / `=="82"` / else | 필수 컬럼 존재: DIVISION_ID·END_CUSTOMER40·SCM_SITE_ID40·ITEM_ID40·MEASURE·INCOTERMS·FCST_TYPE·CURRENCY·CELL_PROD_SITE | DIVISION_ID·PROJECT_CODE·INCOTERMS·SCM_SITE_ID81·PLANT_SITE_ID·ITEM_ID·DEPT_ID·END_CUSTOMER·FCST_TYPE·CURRENCY·MEASURE | DIVISION_ID·DEPT_ID·**UNIT_ENERGY**·CURRENCY·MEASURE | 3387~3448 |

보조 관찰 (division 값이 파라미터로만 흐르는 위치 — 분기 아님):
- `FindData` L804 `p_division_id`, L817 `p_userinfo=NowGroupID` (SP 내부 분기용 전달).
- `btnCutOff_Click` L2918, `btnReplace_Click` L3551: 선택 division 을 Cut-Off/Replace 팝업으로 전달.
- `btnExchangeRate_Click` L3057: division 을 환율 팝업으로 전달(팝업에서 고정, §7 참조).
- `GetSpdTitle` L2958: division 별 스프레드 타이틀 SP 파라미터.
- `btnColumn_Click`/`btnMeasure_Click` L2872/2884: TitleSet 팝업에 division 전달.
- fnValidation L3214: 셀 DIVISION_ID 읽기(40이면 L3228 에서 `sDivision="40"` 재대입).

---

## 2. 권한 축 — NowGroupID / EDIT_FLAG

### 2.1 NowGroupID 스위치(ADMIN / DM ADMIN) — 실행·표시 차단 5곳

| # | 파일 | 객체/기능 | 권한 조건 | 효과 | 라인 |
|---:|---|---|---|---|---|
| 1 | 메인 | `btnCutOff` (Version. Cut-Off 버튼) | `NowGroupID` ∈ {ADMIN, DM ADMIN} | Enabled=true + Visible=true. 그 외 그룹: Enabled=false + Visible=false (버튼 자체 숨김) | 354~367 |
| 2 | 메인 | `btnReplace_Click` (Replace by Cut-Off) | `GroupId != "ADMIN" && != "DM ADMIN"` | `MessageBox "Edit Mode is not allowed."` 후 return — 실행 차단 (버튼은 보이나 기능 차단) | 3478~3484 |
| 3 | 팝업 | `DefineProperty` 버튼 리스트 | 비 ADMIN/DM ADMIN | **Edit / Insert / Save 버튼 Visible=false** (`btnButtonList.Set_ButtonVisibleFalse`) | 127~138 |
| 4 | 팝업 | `EditButton` | 비 ADMIN/DM ADMIN | `MessageBox "You don't have the permissions to access it"` 후 return — Edit 진입 차단 | 305~313 |
| 5 | 팝업 | `SaveButton` | 비 ADMIN/DM ADMIN | `MessageHelper.GMessageBox("MSG00096")` 후 return — 저장 차단 | 361~369 |

부가: 팝업 L122 `this.IsPopup = true` — 팝업은 메뉴 권한 체크를 통과(pass)시키는 플래그(소스 주석 명시).

### 2.2 NowGroupID = 데이터 권한 파라미터 (콤보/조회 소스 필터) — 전수

`UserInfoContext.Current["NowGroupID"]` 를 사용자 권한 필터로 SP 에 전달하는 호출. 효과는 모두 "해당 그룹·사용자에게 허가된 값만 콤보/조회에 노출".

| 파일 | 대상 | 호출 | 라인 |
|---|---|---|---|
| 메인 | Division 콤보 | `Data.Common(MyDivision, ..., NowGroupID, UserId)` | 250 |
| 메인 | Team 콤보 | `Data.UserTeamByDivision(NowGroupID, UserId, div)` | 254, 1493 |
| 메인 | End Customer 콤보 | `EndCustomerByDivision40` / `UserEndCustomerByDivisionDept` | 271, 283, 297, 1505, 1517, 1530, 1581, 1588, 1649 |
| 메인 | Sales Site 콤보 | `UserSiteByEndCustomer` / `SiteByEndCustomer40` | 312, 1545, 1584, 1591, 1603, 1607, 1636, 1655 |
| 메인 | Plant Site 콤보 | `UserPlantSiteByDivision` | 316, 1548 |
| 메인 | Currency 콤보 | `Data.Common(CURRENCY_LIST, ..., NowGroupID, UserId)` | 331, 1563 |
| 메인 | 신규행 Customer/Site/Team(Auth 계열) | `UserEndCustomerByDivisionDeptAuth` / `UserSiteByEndCustomerAuth`·`UserSiteByEndCustomer` / `UserTeamByDivisionAuth` | 1233, 1248~1249, 1252 |
| 메인 | 조회 SP 권한 파라미터 | `p_userinfo = NowGroupID` (DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA) | 817 |
| 팝업 | Division(My) 콤보 | `Data.Common(MyDivision, ..., NowGroupID, UserId)` | 111 |
| 팝업 | Currency 콤보 | `Data.Common(CURRENCY_LIST, ..., NowGroupID, UserId)` | 115 |

### 2.3 EDIT_FLAG 소비 위치 — 활성 2곳(+잠금 1곳)

| # | 위치 | 소비 방식 | 효과 | 라인 |
|---:|---|---|---|---|
| 1 | `EditButton` 행 루프 | `sEdit = GetValue(iRow, EDIT_FLAG)` | 읽기(아래 #2의 게이트 입력) | 646 |
| 2 | `EditButton` 편집 개방 게이트 | `(sEdit=="Y") && (Measure=="Business_Plan" \|\| "LOC")` | 참: 데이터 컬럼 중 **과거 연도만** 잠금(미래 개방). 거짓: 해당 행 데이터 컬럼(MEASURE+1~끝) **전체 잠금** | 670~689 |
| 3 | `InsertRow` | EDIT_FLAG 컬럼 존재 시 | 신규행 EDIT_FLAG 셀 잠금(사용자 변조 금지) | 1381~1382 |

> EDIT_FLAG 는 조회 SP 결과 컬럼(행 단위 편집 허가 플래그)이며 화면에서 값을 만드는 곳은 없음(소비 전용).

---

## 3. Measure 축 — MEASURE 값 비교 전수

Measure 소스: `Data.Common(Data.Type.DMF0042_BP_Measure, false, {"40"|sDivision|"82"}, ...)` — L276/289/303 (InitControls), L1510/1523/1536 (Division 변경). 행 블록 크기 = `dtMeasure.Rows.Count`.

| # | Measure | 위치 | 제약·동작 | 라인 |
|---:|---|---|---|---|
| 1 | `Business_Plan`, `LOC` | `EditButton` | `EDIT_FLAG=='Y'` 이면서 이 두 measure 인 행만 편집 개방(과거 연도 컬럼 제외). 그 외 measure 행은 데이터 영역 전체 잠금 | 670~689 |
| 2 | `LOC` | `SaveData` 행 블록 선두 | 블록 내에서 MEASURE=="LOC" 인 행 인덱스(iLOCRow) 탐색 — BP 행과 LOC 행을 쌍으로 저장 | 907~917 |
| 3 | `Business_Plan`, `LOC`, `MKT_FCST` | `SaveData` 필터 | 이 3종이 아닌 measure 행은 저장 skip (`continue`) | 927~928 |
| 4 | `KRW`, `USD`, `SalesAmt_KRW`, `SalesAmt_USD`, `SalesAmt_LOC`, `CAR_QTY` | `InsertRow` | 환산(파생) measure 행: 신규행 데이터 컬럼(MEASURE+1~끝) **전체 잠금** — 직접입력 불가(SetPrice/SP 환산 전용) | 1395~1400 |
| 5 | (그 외 measure — Business_Plan/LOC/MKT_FCST) | `InsertRow` else | 버킷 타입·40 cutoff 창·과거연도 규칙에 따라 선별 잠금(§4 #9) | 1401~1472 |
| 6 | `Business_Plan` | `spdMain_Changed` 소수점 검사 | 데이터 셀(또는 UNIT_ENERGY) 입력값에 소수부가 있고 `.000` 이 아니면 정수부+".000" 으로 강제 치환 + MSG00289 | 1913~1917 |
| 7 | `Business_Plan` vs 그 외 | `spdMain_Changed` 합산/분배 대분기 | Business_Plan: long 정수 연산으로 Q/Y SUM 재계산·분배(나머지는 마지막 버킷에 가산). 그 외(LOC 등): double 연산 + 분배는 **split 이 아닌 copy**(동일 값 복사), SUM 은 0 처리 | 1920(분기), 1941/1969(합), 2025~2034, 2131, 2190~2201, 2336, 2373, 2401, 2456~2466, 2563, 2622~2633, 2768 |
| 8 | MEASURE 셀 자체 | `InsertRow` | 신규 블록 각 행에 measure 명 SetText 후 잠금 + Red 마킹 | 1390~1393 |
| 9 | (수집) | `fnValidation` | sMeasure 수집(실 비교는 주석 — §8) | 3250~3251 |
| 10 | `MKT_FCST` 취급 | — | 저장 대상 3종에 포함(#3)될 뿐, **편집 개방 게이트(#1)에는 미포함** → Edit 모드에서 MKT_FCST 행은 항상 잠김. 그 외 MKT_FCST 특수 로직 없음 | 927, 670 |

---

## 4. 기간·버킷 축

Tables[1](40 cutoff 편집창) 소비 매핑: `FindData` 조회 SP 2번째 결과 테이블 → 멤버 변수 7종 (L831~840).

| 컬럼 | 저장 변수 | 소비처(버킷 잠금) |
|---|---|---|
| VALID_YN | `valid_YN` | "Y" 일 때만 40 편집창 잠금 로직 활성(모든 버킷 공통 게이트) — L588, 604, 624, 1412, 1428, 1448 |
| START_YYYYMM / END_YYYYMM | `start_YYYYMM`/`end_YYYYMM` | Monthly M_ 컬럼 잠금창(창 밖 잠금) — L590~591, 1414~1415 |
| START_YYYYQQ / END_YYYYQQ | `start_YYYYQQ`/`end_YYYYQQ` | Quarterly Q_ 컬럼 잠금창 — L606~607, 1430~1431 |
| START_YYYY / END_YYYY | `start_YYYY`/`end_YYYY` | Yearly Y_ 컬럼 잠금창 — L626~627, 1450~1451 |

규칙 전수:

| # | 규칙 | 조건 | 대상 버킷/셀 | 라인 |
|---:|---|---|---|---|
| 1 | 조회기간 역전 차단 | `from > to` | 조회 자체 차단, MSG00108 | 762~768 |
| 2 | 조회기간 6년 제한 | `Value1+6년 < Value2` | MSG00276 + Value2 를 Value1+6년으로 자동 보정 후 return | 770~775 |
| 3 | 기준일(p_now) = 이번주 월요일 | 조회 시작일이 이번주 월요일 이후면 from 일, 종료일이 월요일 이전이면 to+1일, 그 외 이번주 월요일 | SP `p_now_yyyymmdd` (서버측 과거 보호 기준) | 777~782, 3086~3105 |
| 4 | Edit: 버킷 외 컬럼 잠금 | Monthly→M_ 아닌 컬럼 / Quarterly→Q_ 아닌 컬럼 / Yearly→Y_ 아닌 컬럼 | 해당 버킷 태그가 아닌 모든 데이터 컬럼(+MEASURE 컬럼 — 루프가 MEASURE 인덱스부터 시작) | 580~637 |
| 5 | Edit: 40 cutoff 편집창 | div=40 & VALID_YN=Y (Q/Y 는 start/end 존재 추가) | 창(start~end) 밖의 M_/Q_/Y_ 잠금 | 588~595, 604~611, 624~631 |
| 6 | Edit: Q_/Y_ 직접입력 차단(비40) | 40+VALID_YN 조건 미충족 시 else | Quarterly 의 Q_ 전체, Yearly 의 Y_ 전체 잠금 (Monthly 의 M_ 는 비40도 개방) | 613~615, 633~635 |
| 7 | Edit: 과거 연도 행 잠금 | `올해 > int(tag.Substring(2,4))` (편집 개방 행 한정) | Business_Plan/LOC & EDIT_FLAG=Y 행의 과거 연도 데이터 셀 | 672~684 |
| 8 | Edit 해제 시 키영역 재잠금 | `!IsEditMode` | 각 행 0~MEASURE 컬럼 | 693~694 |
| 9 | InsertRow: 버킷·cutoff·과거연도 동일 3벌 | #4~#7 과 동일 로직 + 마지막에 과거 연도 무조건 잠금 | 신규 블록의 각 measure 행 | 1404~1470 |
| 10 | 버킷별 컬럼 표시 | BucketType 콤보 | Monthly: M_ 표시, Q_/Y_ 는 chkSum 체크 시만; Quarterly: M_ 숨김·Q_ 표시·Y_ 는 chkSum; Yearly: M_/Q_ 숨김·Y_ 표시 | 490~522 (호출: 1616, 2899) |
| 11 | 헤더 더블클릭 드릴 | Y_ 헤더: 하위 Q_ 토글(+열린 M_ 접기); Q_ 헤더: 하위 M_ 토글 | 해당 연/분기 블록의 하위 버킷 visible | 1663~1702 |
| 12 | 저장은 M_ 만 | tag 에 `Q_`/`Y_` 포함 시 skip | SUM 컬럼은 전송 제외, `p_YYYYMM = tag.Replace("M_","")` | 935~936, 1063, 1133 |
| 13 | 분배 시 이번주 월요일 이전 보호 | 버킷 전체(M_ 없음) 분배 fallback 경로에서 `sResultDate(이번주 월요일) > 컬럼일자` → skip | Yearly/Quarterly 값 입력 시 하위 M_ 분배·삭제 대상에서 과거 주 제외 | 2267~2272, 2293~2298, 2699~2704, 2725~2730 (기준일 계산 2167~2168, 2599~2600) |
| 14 | 버킷 변경 게이트 | 신규행(FlagI) 존재 시 | BucketType 클릭 시 MSG00227 후 return(변경 차단) | 3026~3036 |
| 15 | 버킷 변경 시 Edit 유지 | Edit 모드에서 버킷 변경 | `EditButton()` 2회 호출(SwitchLock 토글 복원)로 잠금 상태 재계산 | 1612~1626 |
| 16 | Business_Plan 합산/분배 자동식 | Monthly 입력→Q/Y SUM 재계산; Quarterly 입력→하위 M_ 균등분배(나머지 마지막 달)+Y SUM; Yearly 입력→하위 M_ 균등분배+Q SUM | §3 #7 참조 | 1920~2350 (BP), 2352~2783 (기타 measure copy) |

---

## 5. FCST_TYPE 축

| # | 항목 | 내용 | 라인 |
|---:|---|---|---|
| 1 | 컬럼 정의 | `DefColumns.FCST_TYPE` 정의. `FCST_TYPE40` 도 선언돼 있으나 **본문 사용처 0건**(선언만) | 124, 164 |
| 2 | 콤보 | **FCST_TYPE 셀 콤보 없음** — `SetCellTypeCombo` 대상 아님. 직접 텍스트 입력 | (없음 — InsertRow 1236~1278 전수 확인) |
| 3 | 값 도메인 검증 | **검증 없음** — lookup 대조·형식 체크 부재. 빈 값 필수 체크만 존재(아래) | (없음) |
| 4 | 필수값 검사 | 저장 시 40 필수(L967), 81 필수(L997). **82는 필수 아님**(검사 목록에 없음) | 967, 997 |
| 5 | 컬럼 존재 필수 | `MinColumnChk`: 81(L3401)·40(L3437) 에서 FCST_TYPE 컬럼 미표시면 저장 진입 차단(MSG00113). 82는 제외 | 3401, 3437 |
| 6 | 저장 직렬화 특례 | `ParameterString`: INCOTERMS/FCST_TYPE 는 빈 값을 `" "`(공백 1자)로 치환 후 '^' 결합 | 3148~3152 |
| 7 | 수집(무효) | `fnValidation` 에서 sFcstType 수집하나 실제 비교식은 주석(§8) | 3242~3243 |
| 8 | 개방/잠금 | Edit 시 FCST_TYPE 열어주는 로직은 **전부 주석**(§8 — Business_Plan 행 INCOTERMS/FCST_TYPE 개방 블록). 활성 코드상 기존 행의 FCST_TYPE 는 키영역 잠금(L649)에 포함되어 편집 불가, 신규행에서만 입력 가능 | 649 (잠금), 652~667 (주석) |

---

## 6. 잠금(Lock) 전수 — 활성 호출 1건 1행

### 6.1 메인 화면 (66건 + SwitchLock 1건)

**FindData / EditButton (13건 + SwitchLock)**

| # | 위치 | 호출 | 잠금 대상 | 조건 | 라인 |
|---:|---|---|---|---|---|
| 1 | FindData | `LockColumn(0, max, true)` | 전체 시트(조회 직후 전면 잠금) | 항상 | 829 |
| 2 | EditButton | `SwitchLock()` | 시트 잠금 토글(Edit 진입/해제) | 항상 | 577 |
| 3 | EditButton | `LockColumn(iCol,iCol,true)` | Monthly: 비 M_ 컬럼 | tag≠M_ | 585 |
| 4 | EditButton | `LockColumn` | Monthly: 40 cutoff 창 밖 M_ | 40 & VALID_YN=Y | 593 |
| 5 | EditButton | `LockColumn` | Quarterly: 비 Q_ 컬럼 | tag≠Q_ | 601 |
| 6 | EditButton | `LockColumn` | Quarterly: 40 cutoff 창 밖 Q_ | 40 & VALID_YN=Y & 창 존재 | 609 |
| 7 | EditButton | `LockColumn` | Quarterly: Q_ 전체 | 40 조건 미충족(비40 포함) | 614 |
| 8 | EditButton | `LockColumn` | Yearly: 비 Y_ 컬럼 | tag≠Y_ | 621 |
| 9 | EditButton | `LockColumn` | Yearly: 40 cutoff 창 밖 Y_ | 40 & VALID_YN=Y & 창 존재 | 629 |
| 10 | EditButton | `LockColumn` | Yearly: Y_ 전체 | 40 조건 미충족 | 634 |
| 11 | EditButton | `LockRange(iRow,0..MEASURE,true)` | 각 행 키영역(Action~MEASURE) | 모든 행 | 649 |
| 12 | EditButton | `LockRange` | 편집 개방 행의 과거 연도 셀 | EDIT_FLAG=Y & (BP\|LOC) & 올해>태그연도 | 680 |
| 13 | EditButton | `LockRange(MEASURE+1..max)` | 비개방 행 데이터 영역 전체 | EDIT_FLAG≠Y 또는 measure∉{BP,LOC} | 688 |
| 14 | EditButton | `LockRange(0..MEASURE)` | 키영역 재잠금 | `!IsEditMode` | 694 |

**InsertRow (53건)** — 신규 블록의 각 measure 행(iRowNo) 대상. `GetColumnIndex(...) != -1` 존재 가드 하 실행.

| # | 잠금 대상 컬럼 | 조건 | 라인 |
|---:|---|---|---|
| 15 | DIVISION_ID (SetText 후) | 항상 | 1286 |
| 16 | PROJECT_CODE | div=40 | 1293 |
| 17 | CUST_GROUP | 존재 시 | 1297 |
| 18 | CUST_GROUP_DTL | 존재 시 | 1299 |
| 19 | OWNER | 존재 시 | 1301 |
| 20 | APPLICATION | 존재 시 | 1303 |
| 21 | ROUTE | 존재 시 | 1305 |
| 22 | BIZ_TYPE_NAME82 | 존재 시 | 1309 |
| 23 | BIZ_TYPE_NAME40 | 존재 시 | 1311 |
| 24 | ITEM_CLASS_NAME | 존재 시 | 1313 |
| 25 | ITEM_NAME | 존재 시 | 1315 |
| 26 | ITEM_TYPE | 존재 시 | 1317 |
| 27 | NICK_NAME | 존재 시 | 1319 |
| 28 | PLANT_SITE_ID | div 비81계열 | 1323 |
| 29 | VERSION_NO | 존재 시 | 1326 |
| 30 | FORECAST_INFO_PRODUCT_GROUP | 존재 시 | 1328 |
| 31 | FORECAST_INFO_CELL_PACK_COUNT | 존재 시 | 1330 |
| 32 | PRODUCT_GROUP_NAME | 존재 시 | 1332 |
| 33 | SHIPTO_DESCRIPTION | 존재 시 | 1334 |
| 34 | CELL_TYPE | 존재 시 | 1336 |
| 35 | INTERNAL_YN | 존재 시 | 1338 |
| 36 | COUNTRY_NAME | 존재 시 | 1340 |
| 37 | CITY_NAME | 존재 시 | 1342 |
| 38 | FORECAST_INFO_CELL_MODEL | 존재 시 | 1344 |
| 39 | FORECAST_INFO_SPEC | 존재 시 | 1346 |
| 40 | MDM_PROJECT_NAME | 존재 시 | 1348 |
| 41 | MIN_CAPACITY | 존재 시 | 1350 |
| 42 | VMI_YN | 존재 시 | 1352 |
| 43 | PRIORITY | 존재 시 | 1360 |
| 44 | DMS_SALES | 존재 시 | 1362 |
| 45 | DMS_CUSTOMER | 존재 시 | 1364 |
| 46 | REPORT_GROUP1 | 존재 시 | 1366 |
| 47 | REPORT_GROUP2 | 존재 시 | 1368 |
| 48 | REPORT_GROUP3 | 존재 시 | 1370 |
| 49 | REPORT_GROUP4 | 존재 시 | 1372 |
| 50 | REPORT_GROUP5 | 존재 시 | 1374 |
| 51 | REPORT_GROUP6 | 존재 시 | 1376 |
| 52 | REPORT_GROUP7 | 존재 시 | 1378 |
| 53 | REPORT_GROUP8 | 존재 시 | 1380 |
| 54 | EDIT_FLAG | 존재 시 | 1382 |
| 55 | CELL_PER_CAR | 존재 시 | 1386 |
| 56 | MODULE_PER_CAR | 존재 시 | 1388 |
| 57 | MEASURE (measure 명 SetText 후) | 항상 | 1392 |
| 58 | 데이터 전체(MEASURE+1~max) | measure ∈ {KRW, USD, SalesAmt_KRW, SalesAmt_USD, SalesAmt_LOC, CAR_QTY} | 1399 |
| 59 | Monthly: 비 M_ 컬럼 | 그 외 measure | 1409 |
| 60 | Monthly: 40 cutoff 창 밖 | 40 & VALID_YN=Y | 1417 |
| 61 | Quarterly: 비 Q_ 컬럼 | — | 1425 |
| 62 | Quarterly: 40 cutoff 창 밖 | 40 & 창 존재 | 1433 |
| 63 | Quarterly: Q_ 전체 | 40 조건 미충족 | 1438 |
| 64 | Yearly: 비 Y_ 컬럼 | — | 1445 |
| 65 | Yearly: 40 cutoff 창 밖 | 40 & 창 존재 | 1453 |
| 66 | Yearly: Y_ 전체 | 40 조건 미충족 | 1458 |
| 67 | 과거 연도 셀(데이터 컬럼) | 올해 > 태그 연도 | 1469 |

잠금 연관 부가 제약(락 호출은 아니나 편집 차단):
- `DeleteButton`: Action ≠ 'I' 행 삭제 차단(신규행만 삭제, measure 블록 단위 일괄 삭제) — L549~561.
- `spdMain_CellDoubleClick` ITEM 팝업: 시트 잠김(조회모드) 또는 Action≠'I' 행이면 팝업 차단 — L1706~1709. (PROJECT_CODE/PROJECT_CODE82 더블클릭 분기에는 동일 가드 **없음** — L1762, 1817.)
- `btnExchangeRate_Click`: Edit 모드 중이면 MSG00142 후 차단 — L3050~3054.
- `btnCutOff_Click` / `btnReplace_Click`: Edit 모드 중이면 "Edit Mode is not allowed." 차단 — L2905~2909, 3472~3476.
- `IsLock` 가드: SaveData L864, InsertRow L1213 (잠금 상태면 미동작).

### 6.2 환율 팝업 (6건 + SwitchLock 1건) — §7 표 참조

---

## 7. ExchangeRatePopup (DMF0042_ExchangeRatePopup) 제약 전수

호출부(메인): `btnExchangeRate_Click` L3048~3068 — `LoadData(from yyyyMM, to yyyyMM, "BP", division)`. 팝업 OK 시 `DMF0042_GET_EXCHANGE_PRICE` 재조회 + FindData.

### 7.1 권한 (MSG00096 계열)

| # | 객체/기능 | 권한 조건 | 효과 | 라인 |
|---:|---|---|---|---|
| 1 | Edit/Insert/Save 버튼 | 비 ADMIN/DM ADMIN | Visible=false | 127~138 |
| 2 | EditButton | 비 ADMIN/DM ADMIN | "You don't have the permissions to access it" 후 차단 | 305~313 |
| 3 | SaveButton | 비 ADMIN/DM ADMIN | **MSG00096** 후 차단 | 361~369 |

### 7.2 필수값 (MSG00002 계열)

| # | 검사 | 조건 | 효과 | 라인 |
|---:|---|---|---|---|
| 1 | 신규행(Action='I') 키 3종 | DIVISION_ID / CURRENCY / UNIT_CURRENCY 중 빈 값 | MSG00002("[Division],"·"[Currency],"·"[Unit],") + 해당 행 2열로 포커스 이동 후 저장 중단. ※ `else if` 체인이라 복수 누락 시 **첫 항목 1개만** 메시지에 표기됨(실측) | 448~483 |
| 2 | EXCHANGE_PRICE 실입력 | 수집된 p_EXCHANGE_PRICE 에서 '0'과 '^' 제거 후 빈 문자열 | MSG00002("[EXCHANGE_PRICE]") — 전부 0/빈 값이면 저장 거부 | 530~539 |

### 7.3 잠금·기간 보호

| # | 위치 | 잠금 대상 | 조건 | 라인 |
|---:|---|---|---|---|
| 1 | FindData | 전체 시트 `LockColumn(0,max,true)` | 조회 직후 항상 | 400 |
| 2 | FindData | Division 조회조건 고정 | `clbDivision.ControlValues=_division; Enabled=false` (메인 화면 division 승계, 변경 불가) | 385~386 |
| 3 | EditButton | `SwitchLock()` | Edit 토글 | 316 |
| 4 | EditButton | 키 컬럼 `LockColumn(DIVISION_ID~CURRENCY_UNITCURRENCY)` | 항상(기존행 키 수정 금지) | 318~319 |
| 5 | EditButton | **과거 연도 컬럼 잠금**: 컬럼 6부터 태그(`D`+yyyyMMdd)의 연도(`Substring(1,4)`)가 올해 이상인 첫 컬럼 직전까지 `LockColumn(CURRENCY, i-1)` | `_cate=="BP"` (DMF0042 경로는 항상 "BP") | 321~334 |
| 6 | EditButton | 전월까지 잠금: 태그 YYYYMM ≥ 현재월인 첫 컬럼 직전까지 잠금 | else(비BP) & From월 < 현재월 | 336~354 |
| 7 | InsertRow | 신규행 CURRENCY 셀 잠금(기본값 "KRW" 세팅 후) | 항상 | 588~594 |
| 8 | InsertRow | 신규행 전월까지 `LockRange(CURRENCY_UNITCURRENCY .. i-1)` (컬럼 5부터 스캔) | From월 < 현재월 | 596~613 |
| 9 | DeleteButton | Action 빈 행 삭제 차단(`GetText(row,0)==""` → return) | 항상 | 291~298 |

### 7.4 저장 '^' 직렬화 — 8종 전수 (SP: `DM.DMF0042_SAVE_DM_BP_EXCHANGE_RATE`, L547)

수집 규칙: Action ∈ {I,M,D} 행에서, 데이터 컬럼(CURRENCY_UNITCURRENCY+1~max) 중 **ForeColor=Red 셀만** 수집(L498~503). 값 규칙: 빈 값→"0", "0"→action "D"(삭제), 그 외→action ""(L508~513). `CString.AppendStringEx(..., iCUD)` 로 '^' 결합.

| # | 파라미터 | 값 | 라인 |
|---:|---|---|---|
| 1 | `p_active_flag` | 행 action(위 값 규칙으로 재산정) | 515 |
| 2 | `p_division_id` | DIVISION_ID 셀 값 | 516 |
| 3 | `p_YYYYMMDD` | 컬럼 태그 `Replace("D","")` | 517 |
| 4 | `p_CURRENCY` | CURRENCY(Trim+ToUpper) | 518 |
| 5 | `p_UNIT_CURRENCY` | UNIT_CURRENCY(Trim+ToUpper) | 519 |
| 6 | `p_EXCHANGE_PRICE` | 셀 값(빈 값 "0") | 520 |
| 7 | `p_CREATED_BY` | UserId | 521 |
| 8 | `p_LAST_UPDATED_BY` | UserId | 522 |

결과 처리: Tables[0][0][0] ≠ "success" → 전 컬럼 연결 오류문자열 MessageBox(L560~571); 성공 → MSG00004(저장건수 iCUD_R=행 수) + FindData(L575~577).

기타: 조회 SP = `DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP`(골격) + `..._POPUP_DATA`(값 매핑, L397~430) / 헤더 SP = `DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE`(L237 — **DMF0020 SP 공유**). OK 버튼 = `blnOK=true` 후 Close(L652~655, 665~668) — 저장과 별개.

---

## 8. 비활성 인벤토리 (주석·미사용 코드 — 활성 제약 아님)

| # | 파일 | 위치 | 내용(비활성) | 라인 |
|---:|---|---|---|---|
| 1 | 메인 | EditButton 진입 | MinColumnChk 선체크 + MSG00113 (주석 — 현재는 SaveData 에서만 체크) | 569~574 |
| 2 | 메인 | EditButton 행 루프 | sEdit/sMeasure 선행 읽기 + 키영역 LockRange 1건 (중복 잔재) | 642~644 |
| 3 | 메인 | EditButton | **Business_Plan+div40 행 INCOTERMS/FCST_TYPE 개방** 및 else 시 잠금 — LockRange 4건 포함 블록 전체 주석 (활성 코드에는 FCST_TYPE/INCOTERMS 개방 로직 없음) | 651~667 |
| 4 | 메인 | InsertRow | div40 시 DEPT_ID40 기반 Customer 재조회 (주석 — "요구사항에 없음" 명시) | 1228~1230 |
| 5 | 메인 | InsertRow | DEPT_ID 잠금 / PROJECT_NAME 잠금 / BIZ_TYPE_NAME81 잠금 / CELL_PER_PACK·CELL_PER_MODULE·MODULE_PER_PACK 잠금 — LockRange 총 6건 주석 | 1288~1291, 1294~1295, 1306~1307, 1353~1358 |
| 6 | 메인 | SaveData | DOM_EXP 관련 파라미터 전 경로 주석(pDom_Exp, p_DOM_EXP, INCOTERMS82) / CELL_PER_PACK 3종 파라미터 주석 | 881, 970, 978, 999, 1015, 1034, 1036, 1078, 1098, 1106, 1108, 1123~1125, 1170, 1182~1184 |
| 7 | 메인 | fnValidation | **키 중복 실비교식 3벌(81/82/40) 전체 주석** — 현재 활성 코드는 컬럼 존재 체크(`GetColumnIndex==-1`)로 퇴화하여 실질 중복검증이 무력화된 상태(그 케이스는 MinColumnChk 에서 선차단됨). 82 키 수집 분기도 주석 | 3221~3225, 3244~3249, 3257~3267, 3283~3292, 3305~3313 |
| 8 | 메인 | MinColumnChk | 82: PROJECT_CODE82/SCM_SITE_ID82/ITEM_ID/END_CUSTOMER 체크 주석; 40: PROJECT_NAME·DOM_EXP 주석; 81: BIZ_TYPE_NAME81 주석 | 3402, 3414~3416, 3419, 3431, 3438 |
| 9 | 메인 | spdMain_KeyUp | Ctrl+V/Ctrl+C 클립보드 처리 전체 주석(메서드 본문 없음) | 2806~2823 |
| 10 | 메인 | btnIncotermsChg_Click | DM0002_MatsterChgPopup 호출 전체 주석 (C20221024-000510 소스 정리로 삭제) | 2990~3003 |
| 11 | 메인 | DefColumns | 선언만 있고 사용 0건: `FCST_TYPE40`(L164), 주석 선언: SCM_SITE_ID·BIZ_TYPE_NAME·DOM_EXP·DOM_EXP40·CELL_PER_PACK·CELL_PER_MODULE·MODULE_PER_PACK | 108, 116, 125, 165, 174~176 |
| 12 | 메인 | spdMain_CellDoubleClick | Q 헤더 관련 PROJECT_CODE82 병합 조건 주석 / ProjectOwner 세팅 주석 | 1763, 1810~1813 |
| 13 | 팝업 | `InitSpread_X` | 구버전 스프레드 구성 메서드 — **미호출 데드코드**(CreateSpread 는 InitSpread 만 호출). 내부에 인라인 SQL(`SCM_SYS_CALENDAR_M` 직접 SELECT) 잔존 | 152~220 |
| 14 | 팝업 | LoadData | `//FindData();` 주석(조회는 Form_Load 에서 수행) | 100 |
| 15 | 팝업 | SaveData | `//request.CommandTimeout = 90 * 60;` 주석 | 548 |

---

## 9. 메시지 인벤토리 (활성 제약에서 발화되는 MSG 전수)

| MSG ID | 발화 위치 | 의미(문맥) | 라인 |
|---|---|---|---|
| MSG00097 | FindData | Division 미선택 조회 차단 | 756~759 |
| MSG00108 | FindData | 조회기간 역전(from>to) | 764~767 |
| MSG00276 | FindData | 조회기간 6년 초과(자동 보정) | 770~774 |
| MSG00113 | SaveData | 필수 컬럼(표시 컬럼 세트) 미충족 | 869~872 |
| MSG00310 | SaveData | 필수 입력값 누락(40/81/82 각 세트) | 973, 1004, 1028 |
| MSG00275 | SaveData | 저장 대상(변경 건) 0건 | 1146~1149 |
| MSG00043 | SaveData | 저장 중복 오류(fnValidation 실패) | 1152~1155 |
| MSG00004 | SaveData / 팝업 SaveData | 저장 완료({0}건) | 1204, 575(팝업) |
| MSG00289 | spdMain_Changed | Business_Plan 소수점 입력 차단(.000 강제) | 1916 |
| MSG00002 | ValidationCheck(메인) / 팝업 SaveData | 필수값 [컬럼] 입력 요구 | 2791(메인), 476·537(팝업) |
| MSG00227 | cboBucketType_Click | 신규행 존재 시 버킷 변경 차단 | 3032 |
| MSG00142 | btnExchangeRate_Click | Edit 모드 중 환율 팝업 진입 차단 | 3052 |
| MSG00282 | btnSetPrice_Click | 가격 환산(SetPrice) 실행 확인(Yes/No) | 3180 |
| MSG00096 | 팝업 SaveButton | 권한 없음(저장) | 367(팝업) |
| (직접 MessageBox) | 팝업 EditButton "You don't have the permissions" / 팝업 SaveData 오류 / 메인 btnCutOff·btnReplace "Edit Mode is not allowed." / btnReplace "데이터 조회 후 다시 시도" / SaveData sRet 오류 | MSG ID 없이 하드코딩 | 311·569(팝업), 2907, 3474·3482·3496, 1199 |

> 참고: 메인 `ValidationCheck`(L2788~2797, MSG00002) 는 정의만 있고 **본 파일 내 호출부 없음**(paste 검증용 잔재 — bPasteContinue 플래그와 세트).

---

## 10. 카운트 요약 (축별 추출 건수)

| 축 | 건수 | 비고 |
|---|---:|---|
| 1. Division 분기 | **22곳** | + 파라미터 단순 전달 6곳 별도 기재 |
| 2. 권한 — NowGroupID 스위치(실행·표시 차단) | **5곳** | 메인 2 + 팝업 3 |
| 2. 권한 — NowGroupID 데이터 필터 파라미터 | **31개 호출**(메인 29 + 팝업 2) | 콤보/조회 소스 권한 필터 |
| 2. 권한 — EDIT_FLAG 소비 | **3곳**(활성) | 게이트 1 + 읽기 1 + 신규행 잠금 1 |
| 3. Measure 비교·제약 | **10항목** | 편집조(BP/LOC), 저장 3종(BP/LOC/MKT_FCST), 환산 6종 잠금 등 |
| 4. 기간·버킷 규칙 | **16항목** | Tables[1] 7컬럼 소비 매핑 포함 |
| 5. FCST_TYPE | **8항목** | 콤보 없음·도메인 검증 없음(정직 표기), 필수 2분기(40/81)만 |
| 6. 잠금 활성 호출 | **73건** | 메인 LockColumn/LockRange 66 + 팝업 6 + SwitchLock 2(메인1·팝업1) — SwitchLock 포함 시 75 |
| 6. 잠금 비활성(주석) 호출 | **11건** | 메인 L644 + L652~667 내 4 + InsertRow 6 |
| 7. 팝업 제약 | 권한 3 + 필수값 2 + 잠금·기간 9 + '^' 파라미터 8종 | 저장 SP 1본(DMF0042_SAVE_DM_BP_EXCHANGE_RATE) |
| 8. 비활성 인벤토리 | **15항목** | 데드코드 InitSpread_X 포함 |
| 9. 메시지 | MSG 14종 + 하드코딩 MessageBox 5류 | ValidationCheck 는 미호출 잔재 |
