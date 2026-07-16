# DMF0082 FcstPrice MGMT — 81 사업부 기준수요 기능 적용 수정대상·테스트케이스 개발참조

> **원천 파일**: `Doc/참고자료/(E20260706-000169)_FCSTPRICE MGMT 기준수요 기능 적용을 위한 수정 대상 식별 및 테스트케이스.xlsx` (1시트 `Sheet1`, 스크린샷 이미지 20)
> **CSR**: E20260706-000169 — FcstPrice MGMT 기준수요 기능 적용
> **화면**: DMF0082 / AS-IS `DMF0082_FcstNPrice_Mgmt` (`GSCM.DM.Forms.UIL\Plan`) / TO-BE slug `forecast-price` (구현·보완 진행)
> **연계 회의록**: [`ui_analysis_meet/DMF0082_FcstNPrice_회의참고_20260709.md`](../ui_analysis_meet/DMF0082_FcstNPrice_회의참고_20260709.md) (40→40·81·81_JV 확장, 하드코딩 금지·LOOKUP 관리)
> **추출 원칙**: 원문 셀 그대로 보존. 화면 스크린샷(빨간 네모 표기 등)은 원천 xlsx 참조.

---

## 0. 전제 (원천 상단 ※ 3항 — 필독)

1. **81 사업부는 81, 81_JV 들을 모두 포함**하여 개발 필요.
2. **40 vs 81 은 기본 사용 컬럼 정보가 다름** → 셋팅 컬럼부터 다르므로 **현행 프로그램 소스 분석이 명확히 선행되어야 함**.
3. 본 문서는 **누락 확인용** — SI 는 소스 분석 완료 후 놓친 건/누락 건 점검 용도로만 사용.

> 핵심 컨셉: **FcstPrice MGMT(DMF0082, 40 전용)** 화면에 **81 사업부의 MKT FCST(DMF0003)·Sales Price(DMF0020) 기능을 이관/통합**하고, **AS(A/S) 로직 + Sales Price + Excel Upload + 배치**까지 81 대응으로 확장한다. Div 선택으로 40/81 분기.

---

## A. AS 관련 로직 추가 (9건) — 권한·콤보·컬럼 활성 제어

> 수정대상: `DMF0082_FcstNPrice_Mgmt.cs` / 참조: `DMF0003_MktFcst`(MKT FCST), `System > UI Category Setup`
> **AS 로직은 40 사업부엔 없음** — 현재 화면에 전무하므로 81 대응으로 신규 추가.

| # | 참조 SP / 룩업 | 수정 내용 |
|---|---|---|
| 1 | — | **AS FROM SITE 컬럼 추가** (권한과 별개, 81 공통 추가) |
| 2 | `UP_FX_GETCOMMONDATALIST_DM` / 룩업 `SALES_TYPE_CODE2`, `SALES_TYPE_CODE2_ADD` | 81 DM Planner(W/S) 권한 Fcst Type 콤보 셋팅: **A/S(Chargeable), A/S(Free), WS(Chargeable), WS(Free), Recall, RMA** |
| 3 | `UP_FX_GetCommonDataList`(AS_FROM_SITE) + `UP_FX_GETCOMMONDATALIST_DM`(FCST_TYPE, DM Planner(W/S)) | DM Planner(W/S) 만 **비축용 Sales Site 선택 시 Measure 를 As In Req 로 선택**하도록 수정 |
| 4 | 위 + `System > UI Category Setup` | DM Planner(W/S) 가 **Sales Site 를 고객향 선택 + Fcst Type = A/S·WS 계열** 선택 시 → **AS FROM SITE 컬럼 활성 + 콤보 리스트업 + MKT FCST[R+P] 메져 선택 가능** |
| 5 | `UP_FX_GetCommonDataList`(SiteByEndCustomerAuth, AS_FROM_SITE) + `UP_FX_GETCOMMONDATALIST_DM`(FCST_TYPE, DM Planner(W/S)) | DM Planner(W/S) 만 **조회조건 Sales Site 에 비축향 사이트 포함 조회 / EDIT>INSERT 시 Sales Site 콤보에 비축향 포함** |
| 6 | 수정대상 SP `DMF0082_GET_SPREAD_TITLE` / 참조 `DMF0003_GET_SPREAD_TITLE` | DM Planner(W/S) 인 경우 **"AS FROM SITE" 컬럼 미존재 시 자동 셋팅** |
| 7 | `UP_FX_GETCOMMONDATALIST_DM`(FCST_TYPE, DM Planner) | DM Planner(비 W/S) 는 **Fcst Type WS(Chargeable/Free) 등록 불가** |
| 8 | `UP_FX_GetCommonDataList`(SiteByEndCustomerAuth) | DM Planner 는 **조회조건·INSERT 콤보에 비축향 Sales Site 미조회/미리스트업** |
| 9 | 참조 `DMF0003_MktFcst` | DM Planner 는 **MKT FCST[R+P] 메져만 사용 가능** |

> **권한 요약**: `DM Planner (W/S)` = 비축향/AS 풀기능 · `DM Planner` = 제한(WS 등록불가, 비축향 미노출, R+P 메져만).

---

## B. 81 MKT FCST 기능 → FcstPrice MGMT 이관 (11건)

> 수정대상: `DMF0082_FcstNPrice_Mgmt.cs` + SP(`DMF0082_GET_MAIN_DATA` / `DMF0082_SAVE_MAIN_DATA`) / 참조: `DMF0003_MktFcst`, `DMF0003_SAVE_MKT_FCST`, `DMF0003_GET_MKT_FCST_DATA`, `DMF0020_*`

| # | 수정 내용 |
|---|---|
| 1 | **조회조건(BigFilter) Div 선택 시 화면 구성 변경** — 81/40 컬럼 상이. `04.WSL\FoxQuery\DM\Common\BigFilter.xml` 참조 |
| 2 | **컬럼·메져 81 셋팅** — 기본 셋팅은 `UI Category Setup` 이용 |
| 3 | ⭐ **저장/조회 테이블 40↔81 분기** (SP `DMF0082_SAVE_MAIN_DATA` / `DMF0082_GET_MAIN_DATA`, 참조 `DMF0020_*_FUTURE_PRICE`) — 아래 매핑 |
| 4 | 기본 MASTER(`SCM_ITEM_M`, `SCM_MST_SITE_ITEM`) 조회를 **81 사업부도 가능하도록 분기 후 추가** (현재 40 기준) |
| 5 | **저장 SP Validation 추가 (81)**: ① Plant Site ID 필수 ② Cell/Car 수량 환산 기준정보(SSPM 존재여부) 필수 ③ Cell/Module/Pack 량 환산 기준정보(SSPM 존재여부) 필수 |
| 6 | **저장 소스 Validation 추가 (81)**: ① Plant Site ID 필수 ② **Project Code 필수** (40=End Customer / 81=Project Code) ③ 81=AS 메져 사용·VMI 미사용 / 40=VMI 사용·AS 미사용 → 화면 Validation |
| 7 | `UI Category Setup` — **SCM_FCST 메져 81 사업부 추가** |
| 8 | 룩업 `DEFAULT_BUCKET_DAY` — Bucket Monthly/Weekly 선택 시 Default 일자: Sales Site Bucket 일자 따름, 없으면 **81=금요일 / 40=월요일** (확인 필요) |
| 9 | **Bucket Monthly Edit 영역**: 81=당월부터 수정 / 40=당월+4 이후부터 수정 → 81 은 당월부터 수정 가능하도록 화면 수정 |
| 10 | **Bucket 물량 배분 로직**: 40=요청 월간 물량 배분 로직 / **81=단순 입력값 ÷ 주차수** (예: 월 100·5주차 → 주당 20). 81 은 단순 나누기 |
| 11 | 룩업 `GET_ADMIN_GROUP_MEASURE` — 사용자별 사용 메져 EDIT 영역 제어(권한·DIVISION·메져·시간). 프로그램에 이미 적용됨 → DMF0082 81 부분에 맞춰 추가 |

### ⭐ B-3 저장 테이블 40↔81 분기 매핑 (필수)

| 40 사업부 | → | 81 사업부 |
|---|---|---|
| `DM_PLN_CFM_MKT_DEMAND_PLAN` | → | `DM_PLN_MKT_FCST` |
| `DM_PLN_CFM_MKT_DEMAND_PLAN_H` | → | `DM_PLN_MKT_FCST_H` |
| `DM_PLN_CFM_MKT_DEMAND_PLAN_C` | → | `DM_PLN_MKT_FCST_C` |
| `DM_PLN_CFM_SELLING_PRICE` | → | `SCM_MST_FUTURE_PRICE` |
| `DM_PLN_CFM_SELLING_PRICE_H` | → | `SCM_MST_FUTURE_PRICE_H` |
| `DM_PLN_CFM_SELLING_PRICE_C` | → | `SCM_MST_FUTURE_PRICE_C` |

> 분기 처리하여 저장·조회. (40=확정 마케팅 수요 계획 계열 / 81=MKT FCST + Future Price 계열)

---

## C. 81 Sales Price 기능 → FcstPrice MGMT 이관 (2건)

> 참조: `DMF0020_SalesFuturePrice.cs`, `ExcelUploadForm.cs`, `DMF0020_SalesPriceTemplatePopup.cs`

| # | 수정 내용 |
|---|---|
| 1 | **Excel Upload** — 81 만 Upload + Excel Form 다운로드 두 기능 모두 이관 필요 |
| 2 | **Exchange Rate 팝업** — 40=환율 자체 수정 / **81=환율 미수정**. Div=81 선택 시 Exchange Rate 에 81 넘기고 **Edit 불가** 처리 |

> 원천 표기: "81 사업부의 경우 빨간색 네모 모두 수정 필요" (화면 스크린샷 참조).

---

## D. 배치 수정 (2건)

| # | 대상 | 내용 |
|---|---|---|
| 1 | SCM_FCST CUTOFF 배치 [81, 81_UC, 81_HM, 81_ST, 81_HD, 81_HG] | **VERSION_TYPE: SF_W CUTOFF 추가 필요** — SF_W 용 CUTOFF 배치 생성 |
| 2 | `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING` | **MF_W CUTOFF 시 MKT_FCST 값과 동일하게 SCM_FCST 값 생성** — 81·81_JV 가 MF_W CUTOFF 순간 40 과 동일하게 **삭제 후 SCM_FCST 데이터 생성** 로직 추가 |

---

## E. MKT FCST / Sales Price 화면 수정 (1건)

| 대상 | 내용 |
|---|---|
| `DMF0020_SalesFuturePrice.cs` (Sales Price) / `DMF0003_MktFcst_SalesFuturePrice\DMF0020_SalesFuturePrice.cs` (MKT FCST) | **81 사업부인 경우 EDIT 불가** 처리 — Sales Price 화면·MKT FCST 화면 모두 (기능이 FcstPrice MGMT 로 이관되므로 원 화면 편집 차단) |

---

## F. 테스트 필요 (업무 FLOW)

### F-1. 변경 후 정상 여부 확인 필요 SP (직접 개발 X, 업무 플로우상 1회 실행)
```
PR_SCM_MST_FUTURE_PRICE_CUTOFF
PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE
PR_DM_PLN_MKT_FCST_TO_NET_DEMAND
PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE
PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE
PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW
DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx
```

### F-2. TEST 업무 FLOW 순서
1. MKT FCST 입력
2. MKT FCST CUTOFF → `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING`
3. SCP 엔진 수행 (SCP 운영자 요청)
4. SCM FCST CUTOFF → `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING`
5. SCP 엔진 수행 (SCP 운영자 요청)
6. Sales Plan Cutoff → `PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE`
7. Sales Plan RTF 수정 → `DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL`
8. Sales Plan Cutoff → `PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE`
9. BPS Interface → `PR_DM_BPS_SALES_ETC_PLAN_S`, `PR_DM_BPS_SALES_PLAN_S`, `PR_DM_BPS_METAL_LINK_S`

---

## G. TO-BE 개발 시 확정/주의 (개발참조 체크포인트)

1. **모든 로직은 Div(40/81) 분기** — 하드코딩 금지, 제약은 LOOKUP/UI Category Setup 데이터로 관리 (회의 확정, [[feedback_column_division_id_visibility]] hook #113 정합).
2. **81 필수값 = Plant Site ID + Project Code** (40=End Customer). 저장 Validation 화면·SP 양쪽 추가.
3. **메져 대칭**: 81=AS 메져(VMI 미사용) / 40=VMI 메져(AS 미사용). `SCM_FCST` 메져 81 추가는 UI Category Setup.
4. **Bucket 배분**: 81=단순 `입력값 ÷ 주차수` (40 배분 로직과 다름). Monthly Default 일자 81=금요일/40=월요일(확인), Monthly Edit 81=당월부터.
5. **환율**: 81 Exchange Rate 편집 불가(Edit lock) — 40 만 자체 수정.
6. **저장 테이블 6종 40↔81 분기**(B-3 매핑) — 오적재 시 데이터 혼선.
7. **Excel Upload/Template 다운로드**는 81 전용 이관 ([[feedback_excel_upload_2step_pattern]] 2-Step).
8. 관련 배치(SF_W CUTOFF 신규 / WEEKLY_ROLLING SCM_FCST 생성)까지 세트로 반영.
