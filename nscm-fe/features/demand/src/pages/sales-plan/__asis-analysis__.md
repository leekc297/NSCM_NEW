# DMF0021 Sales Plan — AS-IS 분석

- 원본: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0021_SalesPlan/DMF0021_SalesPlan.cs` (5,643 lines)
- 클래스: `GSCM.DM.Plan.UIL.DMF0021_SalesPlan : BaseForm`, `sProgram_Id = "DMF0021"`, 시트명 `Sales Plan`
- 바인딩: `sBinding = GSCM.DM.Master.WSL/FoxDataService.svc`, `sScmBinding = GSCM.SCM.Master.WSL/FoxDataService.svc`
- 주의: 같은 파일명의 사본이 3개 더 있으나(`GSCM.DM.Plan.UIL`, `- 복사본`, `GSCM.DM.Shipment.UIL`) 위 경로가 정본입니다. `__asis-mapping__.md` 의 라인 인용(EditButton 687 / SaveData 1940 / InsertRow 2866 / Dsdm_Changed 3958 / spdMain_LeaveCell 4362)이 이 파일과 일치합니다.

## 1. 화면 구성

### 1.1 조회조건 (칸 - 컨트롤 대응)

| 칸 | 컨트롤 | 종류 | 비고 |
| --- | --- | --- | --- |
| Division | `clbDivision` | 체크리스트 | 필수. 미선택 시 MSG00097 |
| Team | `clbTeam` | 체크리스트 | Division 종속 |
| End Customer | `clbCustomer` | 체크리스트 | Division/Team 종속 |
| Biz.Type | `clbBizType` | 체크리스트 | Division 종속 |
| Sales Site | `clbSalesSite` | 체크리스트 | End Customer 종속 |
| Plant Site | `clbPlantSite` | 체크리스트 | Division 종속 |
| Project | `txtProject` + `btnProject` | 텍스트 + 팝업 | `SCM0002_ProjectbyDivisionPopupEx` |
| Model / Nickname | `txtItemId` + `btnItemId` | 텍스트 + 팝업 | `DM0002_ItembyDivisionPopupEx` |
| Item Type | `clbItemType` | 체크리스트 | `SCM0001_GET_LOOKUP_VALUES(ITEM_TYPE_CODE)` |
| Owner | `txtOwner` + `btnOwner` | 텍스트 + 팝업 | `DM0020_OwnerbyDivisionPopup` |
| Bucket | `cboBucketType` | 콤보 | DAILY / WEEKLY / MONTHLY, 기본 MONTHLY |
| Period | `drpPeriod` | 기간 | `Value1:Value2` |
| Color | `chkColor` | 체크박스 | 과거 구간 회색 처리 여부 |
| Sum | `chkSum` | 체크박스 | 상위 버킷 합계 컬럼 노출 |
| Include Internal Txn | `InternalYN` | 체크박스 | 내부거래 포함 |
| Cell Qty | `cboCellQty` | 콤보 | Cell 수량 표기 단위 |
| 통화 | `cboKRW` / `cboUSD` / `cboLOC` | 콤보 | 환산 통화 |
| 컬럼/메저 설정 | `btnColumn` / `btnMeasure` | 버튼 | `DM0002_TitleSetForm_Popup`(DMF1007), OK 시 `InitSpread(true)` |

콤보 소스는 대부분 BigFilter(`GSCM.FP.Common.UIL.FilterDataSet` + `DataService.GetDMInnerTable`) 기반 `SetChangeControl(...)` 로 채웁니다. 사용 키: `MyDivision`, `UserTeamByDivision`, `EndCustomerByDivision`, `BizType`, `UserSiteByEndCustomer`, `UserPlantSiteByEndCustomer`, `UserPlantSiteByDivision`. BigFilter 미적용 경로용으로 `SCM.SCM0001_GET_*` 비동기 조회 메서드가 병존합니다.

### 1.2 그리드

- FarPoint Spread, `SpreadInfo siMain` 래퍼.
- 3단 헤더: `LARGE_CLASS_LABEL_NAME` / `SMALL_CLASS_LABEL_NAME` / `COLUMN_LABEL_NAME` 을 `CreateSheetHeaderColumn(siMain, 3, dtTitle)` 로 구성. 헤더 정의는 `DM.DMF0021_GET_SPREAD_TITLE` 이 반환합니다.
- `Freeze(0, MEASURE + 1)`: MEASURE 까지가 고정 영역, 그 오른쪽이 기간(수치) 영역입니다.
- 컬럼 태그 규칙: `D_yyyyMMdd`(일), `W_yyyyMMww`(주), `M_yyyyMM`(월). `B_` 접두 컬럼은 숨김입니다.
- 요일 색: SAT 파랑 / SUN 빨강. "SUM" 스팬 셀은 별도 처리합니다.
- Footer: MEASURE+1 이후 모든 D_/W_/M_ 컬럼에 `SumIgnoreHidden` 집계, 포맷 `{0:#,##0.###}`, 배경 LightGray.
- `DefColumns` 구조체에 약 90개 컬럼 상수가 정의되어 있습니다(DIVISION_ID, DEPT_ID, END_CUSTOMER, END_CUSTOMER40, PROJECT_CODE, ITEM_ID, TEXT, MEASURE, CELL_PROD_SITE_ID, SCP_USE_YN, FROM_SITE_ID 등).

#### 버킷별 컬럼 가시성 (`SetSpreadColumn`, L3629)

| Bucket | D_ | W_ | M_ |
| --- | --- | --- | --- |
| DAILY | 표시 | 표시 | `chkSum` 시 표시 |
| WEEKLY | 숨김 | 표시 | `chkSum` 시 표시 |
| MONTHLY | 숨김 | 숨김 | 표시 |

`chkColor == false` 인 경우 당월/당주 헤더를 초록 굵은 글씨로 표시합니다.

## 2. 조회 흐름 (`FindData`, L1465–L1660)

### 2.1 사전 검증

| 조건 | 메시지 |
| --- | --- |
| 시작일 > 종료일 | MSG00108 |
| `Value1.AddYears(3) < Value2` | MSG00164 + `Value2 = Value1.AddYears(3)` 강제 보정 |
| Division 미선택 | MSG00097 |

참고: 주석에는 "날짜 기간 2년까지"로 적혀 있으나 실제 코드는 3년입니다.

### 2.2 쿼리

`DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx` (CommandTimeout 30분)

파라미터: `p_division_id, p_dept_id, p_end_customer, p_scm_site_id, p_project_code, p_item_id, p_item_type, p_from_yyyymmdd, p_now_yyyymmdd, p_to_yyyymmdd, p_created_by, p_plant_site_id, p_biztype, p_userinfo(NowGroupID), p_owner, p_internal_yn, p_bucket, p_user_dept_id`

`p_now_yyyymmdd` 는 `GetThisWeekMonday()` 로 이번 주 월요일을 구한 뒤, 조회 시작일이 이번 주 이후이거나 종료일이 현재보다 과거이면 보정합니다.

### 2.3 결과 DataSet

| 테이블 | 내용 |
| --- | --- |
| `Tables[0]` | 그리드 데이터. FE 에서 `Action` 컬럼 추가 |
| `Tables[1]` | THIS_YYYYMM, THIS_YYYYMMWW, PRE_YYYYMM, PRE_YYYYMMWW, BASIS_DATE, BASIS_YYYYMM, ISO_WEEK |
| `Tables[2]` | 수정권한 플래그 `EDIT_AUTH_SalesAmt_LOC`, `EDIT_AUTH_RTF_SYS_RP` (Y/N) |

권한은 `GET_ADMIN_GROUP_MEASURE` 기준입니다. 주석상 그룹별 부여 범위: ADMIN(기타매출, RTF), SCP PI ADMIN(기타매출, RTF), SCP Planner(RTF), DM Planner(기타매출), DM ADMIN(기타매출).

### 2.4 부가 조회

| 용도 | 쿼리 |
| --- | --- |
| 헤더 | `DM.DMF0021_GET_SPREAD_TITLE` (`p_start_yyyymmdd, p_end_yyyymmdd, p_created_by, p_division_id, p_bucket`) |
| 메저 정보 | `DM.DMF0021_GET_SALES_PLAN_MEASUREINFO`, `...MEASUREINFO2` |
| 버킷 코드 | `DM.DMF0003_GET_BUCKET_TYPE_CODE` |
| 일자 범위 | `DM.PR_GET_DAY_RANGE` (`p_month = 6`, 7개월에서 6개월로 축소된 이력) |
| 공통코드 | `DM.UP_FX_GetCommonDataList_DM` — `DM_CUSTOMS_HANDBOOK`, INCOTERMS, FCST_TYPE, CELL_PROD_SITE_ID |

### 2.5 Draw (L1650–L1940)

- 행별 `NOTATION` 값(DEFAULT / INTEGER / POINT / POINT3)에 따라 숫자 포맷을 적용합니다. INTEGER → `###,###,###,##0`, POINT → `0.###`, POINT3 → `###,###,###,###.##0`.
- PROJECT_CODE 셀에 `cellTypeImage`(팝업 아이콘) 부여, CELL_PROD_SITE_ID 는 가운데 정렬.
- `chkColor == true`: 과거 구간(`iResultCol` 까지)을 Gainsboro 로 칠하고 당월만 흰색.
- `chkColor == false`: 당주/당일 컬럼에 초록 `BevelBorder`.

## 3. 편집 권한 매트릭스 (`EditButton`, L687–L1123)

F2(Edit) 진입 시 다음 순서로 판정합니다.

1. 필수 컬럼 존재 확인(Division 조건부). 미충족 시 MSG00113 / MSG00429.
2. Bucket 이 DAILY 면 MSG00361 로 편집 불가.
3. 편집 가능 컬럼 인덱스 목록(`list_EDIT_Month`, `list_EDIT_Week`)을 구성합니다.
   - Division 40: 당월(`<= iCol`)부터 편집 가능.
   - 그 외: 익월(`< iCol`)부터 편집 가능.
4. 행 단위 잠금 해제 조건: `SALES_PLAN_ADJUST_YN == "N_Y"` 이고 메저가 편집 대상일 것.

| 메저 | 추가 조건 |
| --- | --- |
| `SalesAmt_LOC` | `EDIT_AUTH_SalesAmt_LOC = Y` 이고 `FCST_TYPE == "ETC"` |
| `Catch_Up` | Division 40 전용, M+3 이후 구간만 |
| `RTF_SYS_RP` | `EDIT_AUTH_RTF_SYS_RP = Y`, Division 40 / 81 계열, Monthly 에서 당월은 잠김 |

버킷 교차 잠금: Monthly 편집 중에는 모든 `W_` 컬럼, Weekly 편집 중에는 모든 `M_` 컬럼이 잠깁니다. `D_` 컬럼은 항상 잠깁니다.

## 4. 신규행 (`InsertRow`, L2866–L3366)

- `EDIT_AUTH_SalesAmt_LOC` 가 아니면 즉시 반환합니다(신규 등록 불가).
- 기본값: DIVISION_ID 세팅 후 잠금, MEASURE `SalesAmt_LOC`(Division 40 외에는 잠금), FCST_TYPE `ETC` 잠금.
- 셀 콤보 소스:

| 컬럼 | 소스 |
| --- | --- |
| DEPT_ID | `Data.UserTeamByDivisionAuth` (Division 40 전용) |
| END_CUSTOMER | `Data.UserEndCustomerByDivisionDeptAuth` |
| END_CUSTOMER40 | `Data.Common(EndCustomerByDivision40, ...)` |
| SCM_SITE_ID | `Data.UserSiteByEndCustomerAuth` |
| PLANT_SITE_ID | `Data.UserPlantSiteByDivision` |
| CELL_PROD_SITE_ID | `Data.Common(Data.Type.CELL_PROD_SITE_ID, ...)` |
| CURRENCY | `dtCurrencyList` |
| ITEM_ID | `dtITEM_ID` 를 `GUBUN` 40 / 81 / 82 로 필터 |

- 읽기 전용 약 35개 컬럼을 개별 잠금 처리합니다.
- 기간 잠금 규칙은 EditButton 과 동일합니다(40 → 당월부터, 그 외 → M+1 부터). `D_` 전체 잠금, Monthly 는 `W_` 잠금 / Weekly 는 `M_` 잠금.

## 5. 셀 이벤트

이벤트 순서(소스 주석 기준): `EnterCell` → `EditModeStarting` → `EditModeOn` → `EditChange` → `Dsdm_Changed` → `EditModeOff` → `LeaveCell`.

### 5.1 `Dsdm_Changed` (L3958–L4125)

- 시트/셀이 잠겨 있거나 행·열 인덱스가 음수면 반환합니다.
- MEASURE 오른쪽 컬럼에서만 동작하고 `D_` 컬럼은 반환합니다.
- 해당 행 MEASURE 가 비어 있으면 입력값을 지웁니다.
- 변경 셀을 빨간 글씨로 표시하고 주/월 SUM 표시를 재계산합니다.

### 5.2 `spdMain_LeaveCell` (L4362–L4438)

편집 배경색(`ControlColor.UnLockColor`)이고 당월 이후 컬럼일 때만 동작합니다.

- `RTF_SYS_RP` 이고 `FCST_TYPE != "RMA"` 인데 음수를 입력하면 값을 비웁니다. RMA 일 때만 음수 저장을 허용하며, DMF0082 와 동일한 정책입니다.
- 메저별 포맷: `RTF_SYS_RP` → `###,###,###`(정수, 소수점 절사), `SalesAmt_LOC` → `###,###,###,##0.000`.

### 5.3 `spdMain_ComboSelChange` (L4530–L5124)

상위 콤보 변경 시 하위 콤보를 다시 채우고 하위 입력값을 비우는 캐스케이드입니다.

| 변경 컬럼 | 재구성 대상 | 초기화 대상 |
| --- | --- | --- |
| DIVISION_ID | DEPT_ID, END_CUSTOMER(40), SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID | DEPT_ID, END_CUSTOMER, SCM_SITE_ID, PROJECT_CODE, PROJECT_NAME, ITEM_ID, TEXT, ITEM_CLASS_NAME |
| DEPT_ID | END_CUSTOMER(40), SCM_SITE_ID, ITEM_ID | END_CUSTOMER, SCM_SITE_ID, PROJECT_*, ITEM_ID, TEXT, ITEM_CLASS_NAME |
| END_CUSTOMER / END_CUSTOMER40 | SCM_SITE_ID, ITEM_ID | SCM_SITE_ID, PROJECT_*, ITEM_ID, TEXT, ITEM_CLASS_NAME |
| SCM_SITE_ID | ITEM_ID | PROJECT_*, ITEM_ID, TEXT, ITEM_CLASS_NAME |
| ITEM_ID | ITEM_CLASS_NAME 채움, CELL_PROD_SITE_ID 콤보 재구성 | — |
| MEASURE | 편집 가능 구간 재계산 | 아래 참조 |

MEASURE 변경 시:
- `Catch_Up` 선택: ITEM_ID 를 팝업형(`cellTypeImage`)으로 바꾸고 값을 비웁니다. DOM_EXP / PLANT_SITE_ID / INCOTERMS / FCST_TYPE 잠금 해제, DEPT_ID 잠금. 편집 시작 컬럼(M+3)보다 왼쪽은 모두 잠급니다.
- 그 외 메저: FCST_TYPE 을 `ETC` 로 고정·잠금, DOM_EXP / INCOTERMS 비우고 잠금, DEPT_ID 잠금 해제, ITEM_ID 는 `GUBUN` 40 콤보로 복귀, PLANT_SITE_ID 잠금.
- 편집 시작 컬럼 계산: MONTHLY 는 당월(`this_YYYYMM`)이 그리드에 있으면 당월 포함, WEEKLY 는 당주(`this_YYYYMMWW`) 포함. 마지막 컬럼이 당주보다 과거면 편집 불가(`i_EditStartCol = 0`).
- 소스 주석: "25.07.04 시점으로 SALES PLAN 신규 등록 가능 데이터는 FCST_TYPE: ETC, MEASURE: SALESAMT_LOC 만 있음".

### 5.4 `spdMain_CellDoubleClick` (L3789)

- 헤더 더블클릭: W_ / D_ 컬럼 가시성 토글(드릴다운).
- 바디 더블클릭은 `Action == I`(신규행)에서만 동작합니다.
  - PROJECT_CODE → `SCM0002_ProjectbyDivisionPopupEx`. PROJECT_NAME / PROJECT_STATUS / BIZ_TYPE_NAME / OWNER 를 채우고 ITEM_ID / ITEM_CLASS_NAME 을 초기화합니다.
  - ITEM_ID → Division 40 이고 메저가 `Catch_Up` 일 때 `DM0002_ItembyDivisionPopupEx`. ITEM_TYPE / NICK_NAME 을 채웁니다.

### 5.5 클립보드

- `spdMain_KeyUp`: MEASURE 오른쪽에서만 동작. Ctrl+V → `ClipboardPaste(AsStringSkipHidden)`, Ctrl+C → `ClipboardCopy(AsStringSkipHidden)`.
- `spdMain_ClipboardPasted`: 붙여넣기 범위에 ITEM_ID 가 포함되면 해당 행의 CELL_PROD_SITE_ID 콤보를 `Data.Common(CELL_PROD_SITE_ID, division, itemId, ...)` 로 재구성합니다.

## 6. 저장 흐름

### 6.1 중복 검증 (`fnValidation`, L4183–L4317)

`Action == I` 인 행끼리 키 중복을 검사합니다. 동일 키가 2건 이상이면 저장을 막습니다.

| Division | 비교 키 |
| --- | --- |
| 81 계열 | DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE |
| 82 | 81 과 동일 |
| 그 외(40) | PROJECT_CODE 대신 END_CUSTOMER40 사용, 나머지 동일 |

TEXT, CURRENCY, PLANT_SITE_ID 는 키에서 제외되어 있습니다(주석에 제외 사유 명시).

### 6.2 `SaveData` (L1940–L2863)

- 시트가 잠긴 상태면 즉시 반환합니다.
- 행별 필수값 검사 → `MSG00002 {0} 값은 필수 입력입니다`. 토큰 목록: `[Division] [Project Code] [Currency] [Sales_Site] [Model] [Measure] [TEXT] [END_CUSTOMER] [TEAM] [Customer Handbook] [FcstType] [INCOTERMS] [CellProdSiteID]`.
- Division 별 규칙
  - 40: Project 없음(END_CUSTOMER40 을 `p_project_code` 로 전송), END_CUSTOMER 필수, DEPT_ID 필수(`Catch_Up` 제외), CELL_PROD_SITE_ID 필수. `Catch_Up` 은 DOM_EXP + FCST_TYPE + INCOTERMS 필수이고 값이 0 미만이면 MSG00085.
  - 81 계열: TEXT 필수, FROM_SITE_ID 가 있으면 `sCellProdSiteId` 를 덮어씁니다.
- 빈 금액은 `"0"` 으로 전송합니다(`[E20251125-000694]`).
- 현재 버킷과 맞지 않는 컬럼은 전송 대상에서 제외하고, 유효 일자가 하나도 없으면 MSG00146.
- 키 중복 최종 판정은 SP 에 위임합니다.

### 6.3 저장 SP

`DM.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL` (CommandTimeout 10분). 파라미터 18개는 모두 `^` 구분 다건 문자열입니다.

`p_active_flag, p_division_id, p_project_code, p_scm_site_id, p_plant_site_id, p_item_id, p_dom_exp, p_fcst_type, p_incoterms, p_measure, p_yyyymmdd, p_qty, p_currency, p_created_by, p_last_updated_by, p_text, p_dept_id, p_cell_prod_site_id`

결과 판정: `Tables[0].Rows[0][0] == "success"` 이면 MSG00004 와 건수를 표시하고, 그 외에는 오류 분기(MSG00428 등)로 갑니다.

## 7. 기타 동작

- `cboBucketType_SelectedIndexChanged` (L3576): WEEKLY/MONTHLY 에서 DAILY 로 바뀌면 `InitSpread(true)`. 이후 `SetSpreadColumn()` 재실행, `sResult_YYYYMMWW` 재계산, 초록 테두리 재적용, 시트가 잠겨 있지 않으면 `EditButton()` 재호출.
- `chkSum_CheckedChanged`: `SetSpreadColumn()` 재실행.
- `chkColor_CheckedChanged`: 색상 재적용.
- `btnColumn_Click` / `btnMeasure_Click`: `DM0002_TitleSetForm_Popup`(DMF1007) 호출, OK 시 `InitSpread(true)`.
- `ExportExcel` (L1199–L1465): Action 컬럼과 숨김 셀을 제외하고 내보냅니다. Action 컬럼이 있으면 틀고정 컬럼 수를 1 줄여 보정합니다.

## 8. 주요 메시지 코드

| 코드 | 상황 |
| --- | --- |
| MSG00002 | 필수 입력 누락 |
| MSG00004 | 저장 성공(건수) |
| MSG00085 | Catch_Up 음수 입력 |
| MSG00097 | Division 미선택 |
| MSG00108 | 조회 시작일 > 종료일 |
| MSG00113 / MSG00429 | 편집 필수 컬럼 누락 |
| MSG00146 | 저장 대상 일자 없음 |
| MSG00164 | 조회 기간 3년 초과 |
| MSG00361 | DAILY 버킷 편집 불가 |
| MSG00428 | 저장 실패 |

## 9. 변경 이력 요약

2018-01-18 최초 개발 이후 2026-05-12 까지 유지보수되었습니다. 최근 주요 건은 다음과 같습니다.

| 이슈 | 내용 |
| --- | --- |
| PJ2024-50611 | 소형(40) 기타매출 / Catch_Up 입력 기능 |
| PJ2025-50017 | CELL_PROD_SITE_ID 추가, 주요 테이블 변경, 그룹별 수정권한, 메저별 소수점 포맷 |
| PJ2025-50188 | SCM_FCST 메저 추가 |
| E20250423-000842 | SCP Use 칼럼 |
| E20250520-000572 | Validation 로직 변경 |
| E20250520-000605 | ETC Monthly 입력 버킷 수정(편집 시작 컬럼 계산 로직 통일) |
| E20251125-000694 | 저장 로직 개선(빈 금액 0 처리) |
| E20260331-000648 | 자동차(81) RTF 수정 기능 |
| E20260512-000502 | 자동차 Cell Prod Site ID / FROM_SITE_ID |
