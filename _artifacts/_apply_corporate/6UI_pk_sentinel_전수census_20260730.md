# 6화면 PK 센티널 `'-'` 확대 적용 — **전수 census 결과 + 쟁점 보고** (적용 전)

> 대상 화면: **DMF0020 / DMF0003 / DMF0021 / DMF0042 / DMF0044 / DMF0049**
> 방식: DMF0082 확립 규약 = PK × VARCHAR2 × NOT NULL / 스테이징 GTT 1지점 정규화 / 검증 뒤 배치
> 근거 룰: hook #119 · 선례 `_artifacts/_apply_corporate/DMF0082_pk_sentinel_적용결과_20260730.md`
> **상태: 미적용 — 아래 §4 쟁점 확정 후 객체별 순차 적용**

---

## §1. 배선 인벤토리 (누락 0 — `SCM_ADM_MNU_BTN_MPG_M`×`API_M` 실측)

6화면이 호출하는 **API 배선 81행 → 고유 오브젝트 15개**. 그중 **영속 테이블 DML 보유 = 10개**.

| # | 오브젝트 | 타입 | 행수 | 영속DML 테이블 | GTT | PK-VC 합집합 | 작업 |
|---:|---|---|---:|---:|---:|---:|:--:|
| 1 | `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL` | PROCEDURE | 1,131 | 2 | 2 | 11 | ✅ |
| 2 | `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP` | PROCEDURE | 795 | 2 | 3 | 11 | ✅ |
| 3 | `PKG_DMF0020` | PACKAGE BODY | 4,609 | 6 | 3 | 14 | ✅ |
| 4 | `PKG_DMF0003` | PACKAGE BODY | 14,926 | 10 | 57 | 23 | ✅ |
| 5 | `PKG_DMF0021` | PACKAGE BODY | 3,534 | 9 | 19 | 21 | ✅ |
| 6 | `PKG_DMF0042` | PACKAGE BODY | 6,561 | 5 | 16 | 20 | ✅ |
| 7 | `PKG_DMF0044` | PACKAGE BODY | 9,744 | 10 | 17 | 36 | ✅ |
| 8 | `PKG_DMF0049` | PACKAGE BODY | 1,198 | 3 | 6 | 9 | ✅ |
| 9 | `PKG_DMF0000` | PACKAGE BODY | 1,146 | 2 | 1 | 4 | ⚠️ 공용 |
| 10 | `SCM0002_SET_TITLESET_POPUP` | PROCEDURE | 540 | 1 | 0 | 5 | ⚠️ 공용·쟁점 |

**영속 DML 없음 = 작업 대상 아님 (5개, 조회 전용)**
`DMF0002_GET_TITLESET_POPUP`(70) · `DMF0020_GET_SCM_MST_FUTURE_PRICE`(1,194) · `DMF0020_GET_SPREAD_TITLE_DATE`(80) · `DMF0073_GET_VERSION_SALESPRICE`(119) · `PR_GET_DAY_RANGE`(61)
→ 리터럴 NULL→PK 출력도 **0건** 확인 (조회 NVL 불요)

> 총 검사 라인 = **39,764행** (전 라인, 표본 아님). 컬럼↔값 개수 불일치 = **전 객체 0건**.

---

## §2. 객체별 DML 타깃 테이블 × PK(VARCHAR2·NOT NULL) 전량

### 1) `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL`
| 타깃 | DML | PK-VC | 컬럼 |
|---|---|---:|---|
| `SCM_MST_FUTURE_PRICE` | INSERT L840 | 11 | DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS |
| `SCM_MST_FUTURE_PRICE_H` | INSERT L902 | 0 | (PK=`HISTORY_SEQ` NUMBER) |

**공급 구조**: `'^' split → INSERT GT_FCSV_RESULTS_MST(L120, 컬럼명 `V_*` 접두)` → L840 `SELECT V_… FROM GT_FCSV_RESULTS_MST`
**정규화 지점(제안)**: `GT_FCSV_RESULTS_MST` — 검증(L710~ E20241125 중복검증 등) **이후**, L840 INSERT 앞

### 2) `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP`
| 타깃 | DML | PK-VC |
|---|---|---:|
| `SCM_MST_FUTURE_PRICE` | INSERT L629 | 11 (위와 동일 컬럼) |
| `SCM_MST_FUTURE_PRICE_H` | INSERT L666 | 0 |

**공급**: `GT_DMF0020_RESULTS_MST`(L247/307/356/393/433 5회 INSERT) + `GT_DMF0020_EXCH`(L347)
**정규화 지점(제안)**: `GT_DMF0020_RESULTS_MST` — 마지막 적재(L433) 이후 · L629 앞

### 3) `PKG_DMF0020` — 영속 6테이블 / PK-VC 14
`DM_MST_EXCHANGE_RATE`(4: DIVISION_ID,YYYYMMDD,CURRENCY,UNIT_CURRENCY) · `SCM_MST_FUTURE_PRICE`(11) ×2경로 · `DM_PLN_CFM_MKT_DEMAND_PLAN`(12) 등. 공급 alias `B.*`

### 4) `PKG_DMF0003` — 영속 10테이블 / PK-VC 23
| 타깃 | PK-VC | 컬럼 |
|---|---:|---|
| `DM_PLN_MKT_FCST` | 10 | DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD |
| `DM_PLN_SALES_PLAN` | 9 | + (MEASURE 제외) |
| `DM_PLN_PR_DETAIL` | 10 | … **`REQUEST_NO`** 포함 |
| `DM_ANL_MKT_PSI` | 5 | DIVISION_ID, PROJECT_CODE, END_CUSTOMER, MEASURE, YYYYMM |
| `DM_ANL_MKT_PSI_DETAIL` | 8 | + **`QTYCD1/2/3`** |
| `SCM_MST_TITLESET_USER` | 4 | ⚠️ §4-B |
**조회 리터럴 NULL**: L2643 `SELECT NULL AS REQUEST_NO` (1건)

### 5) `PKG_DMF0021` — 영속 9테이블 / PK-VC 21
`DM_PLN_SALES_PLAN`(11) · `DM_PLN_SALES_ETC_PLAN`(11, **`REMARK_TEXT`** 포함) · `DM_PLN_MKT_FCST`(10) · `DM_PLN_MKT_FCST_C`(12) · `DM_PLN_CFM_MKT_DEMAND_PLAN`(12) · `DM_PLN_CFM_MKT_DEMAND_PLAN_C`(14) · `SCM_MST_TITLESET_USER`(4)
**조회 리터럴 NULL**: L479 / L516 / L536 `NULL AS CUTOFF_YYYYMMDD` (3건)

### 6) `PKG_DMF0042` — 영속 5테이블 / PK-VC 20
`DM_PLN_BP_FCST`(**15**: BIZ_TYPE, CELL_PROD_SITE, CURRENCY, DEPT_ID, DIVISION_ID, END_CUSTOMER, FCST_TYPE, INCOTERMS, ITEM_ID, **ITEM_USE**, MEASURE, PLANT_SITE_ID, PROJECT_CODE, SCM_SITE_ID, YYYYMM) · `DM_BP_EXCHANGE_RATE`(4) · `DM_BP_EXCHANGE_RATE_C`(4) · `DM_PLN_BP_FCST_C`(1: VERSION_NO)
**조회 리터럴 NULL**: 0건

### 7) `PKG_DMF0044` — 영속 10테이블 / PK-VC 36 ⭐최다
`DM_PLN_SALES_PLAN_REPORT_C`(9) · `DM_PLN_SALES_ETC_REPORT_C`(4) · `DM_PLN_SALES_REPORT_EXCHANGE_C`(7) · `DM_PLN_BP_FCST_REPORT_C`(1) · `DM_MDF_VERSION`(2) · **`DM_MOBILE_REPORT_DEPT`(10: CUST_INFO, DEPT_NAME, PRODUCT_DETAIL, PRODUCT_NAME, SP_BP_TYPE, UPPER_DEPT_NAME …)** · `DM_MOBILE_REPORT_PRODUCT`(6) · `DM_MOBILE_REPORT_EXCHANGE_RATE`(5) · `SCM_MST_TITLESET_USER`(4)
**조회 리터럴 NULL**: L1787 `, NULL AS YYYYMMDD` (1건)

### 8) `PKG_DMF0049` — 영속 3테이블 / PK-VC 9
`DM_PLN_SALES_ETC_REPORT_C`(4: DIVISION_ID, MEASURE, VERSION_NO, YYYYMMDD) · `SCM_MST_TITLESET_USER`(4) · (+1)
**조회 리터럴 NULL**: 0건

### 9) `PKG_DMF0000` ⚠️ **공용 PKG**
`DM_MST_EXCHANGE_RATE`(MERGE L1023, PK-VC 4) · `DM_MST_EXCHANGE_RATE_H`(INSERT L1047, 0)
공급 `GT_D000_RESULTS`(L917/926). → **DMF0044·0049·0082 외 타 화면도 사용** (환율 공용)

### 10) `SCM0002_SET_TITLESET_POPUP` ⚠️ **전 화면 공용 + 쟁점**
`SCM_MST_TITLESET_USER` PK-VC 5 = `USER_ID`, `PROGRAM_ID`, `SHEET_NAME`, `USER_INQUIRY_COLUMN_TYPE_CODE`, `COLUMN_NAME`
공급 = **파라미터 직접**(`P_USER_ID`, `P_PROGRAM_ID`, `P_SHEET_NAME`, `P_COLUMN_TYPE`, `C.COLUMN_NAME`) — 8 DML 문장

---

## §3. 조회(SELECT) 리터럴 NULL → PK 컬럼 : **총 5건**

| 오브젝트 | 위치 | 현재 문구 |
|---|---|---|
| `PKG_DMF0003` | L2643 | `SELECT NULL AS REQUEST_NO` |
| `PKG_DMF0021` | L479 / L516 / L536 | `SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, …` |
| `PKG_DMF0044` | L1787 | `, NULL AS YYYYMMDD` |

> `PKG_DMF0020`·`0042`·`0049`·`0000`·standalone 5종 = **0건**.

---

## §4. ⚠️ 적용 전 확정 필요 쟁점 (blanket 적용하면 안 되는 것)

사용자 규칙은 *"테이블에는 필수인데 **해당 DIVISION 에서 사용하지 않는** 경우"* 입니다.
그런데 PK×VARCHAR2 로 기계적으로 뽑으면 **성격이 다른 컬럼**이 섞입니다.

### A. `_C` 컷오프/버전 축 — `VERSION_NO` / `CUTOFF_TYPE` / `CUTOFF_YYYYMMDD`
`PKG_DMF0021`·`0042`·`0044`·`0049` 의 `_C` 테이블 PK. **버전 식별자**라 `'-'` 로 채우면
서로 다른 버전이 한 키로 뭉개질 수 있음. → **제외 권장**

### B. `SCM_MST_TITLESET_USER` (전 화면 공용) — `USER_ID`/`PROGRAM_ID`/`SHEET_NAME`/`COLUMN_TYPE`/`COLUMN_NAME`
- division 무관·**항상 필수 식별자**. `'-'` 로 채우면 개인화 설정이 유령 행으로 저장됨
- `SCM0002_SET_TITLESET_POPUP` 은 **6화면 외 전 화면이 공용** → 변경 파급 최대
→ **제외 권장** (4 PKG + standalone 1 = 5곳 해당)

### C. 리포트 차원 텍스트 — `DM_MOBILE_REPORT_DEPT`/`_PRODUCT` 의 `DEPT_NAME`·`PRODUCT_NAME`·`CUST_INFO`·`PRODUCT_DETAIL`·`UPPER_DEPT_NAME`·`SP_BP_TYPE`
GDW 전송용 집계 리포트의 **표시 차원**. `'-'` 채움이 리포트에 그대로 노출됨
→ **사용자 판단 필요**

### D. 코드성 PK — `QTYCD1/2/3`(`DM_ANL_MKT_PSI_DETAIL`) · `REQUEST_NO`(`DM_PLN_PR_DETAIL`) · `REMARK_TEXT`(`DM_PLN_SALES_ETC_PLAN`) · `ITEM_USE`·`BIZ_TYPE`·`DEPT_ID`(`DM_PLN_BP_FCST`)
→ **사용자 판단 필요** (DMF0082 에서는 이런 유형이 없었음)

### E. `PKG_DMF0000` (환율 공용) — 6화면 외 파급
`DM_MST_EXCHANGE_RATE` PK 4컬럼. 환율은 전 도메인 공용 → **별건 승인 권장**

### ✅ 쟁점 없는 "안전 코어" (DMF0082 와 동일 성격 = division/사이트 축)
`DIVISION_ID` `PROJECT_CODE` `SCM_SITE_ID` `PLANT_SITE_ID` `CELL_PROD_SITE_ID` `CELL_PROD_SITE`
`ITEM_ID` `END_CUSTOMER` `DOM_EXP` `FCST_TYPE` `INCOTERMS` `MEASURE` `YYYYMMDD` `YYYYMM` `CURRENCY` `UNIT_CURRENCY`
→ **16컬럼**. 이것만 적용하면 DMF0082 와 정확히 동일 성격이고 부작용 위험이 가장 낮음.

---

## §5. 제안 진행안 (객체별 순차 — 누락 0)

| 단계 | 객체 | 비고 |
|---:|---|---|
| 1 | `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL` | GTT `GT_FCSV_RESULTS_MST`(V_* 접두) |
| 2 | `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP` | GTT `GT_DMF0020_RESULTS_MST` |
| 3 | `PKG_DMF0020` | 6타깃 |
| 4 | `PKG_DMF0003` | 최대 14,926행 · GTT 57 → 정규화 지점 다수 |
| 5 | `PKG_DMF0021` | +조회 3건 |
| 6 | `PKG_DMF0042` | |
| 7 | `PKG_DMF0044` | 최다 36 PK · +조회 1건 |
| 8 | `PKG_DMF0049` | |
| 9 | `PKG_DMF0000` | 공용 — §4-E 승인 시 |
| 10 | `SCM0002_SET_TITLESET_POPUP` | 공용 — §4-B 제외 권장 |

각 단계 공통 절차: ①정규화 지점 확정(검증 순서 실측) ②백업 ③assert+라인수 계산값 대조 ④VALID/USER_ERRORS 0 ⑤조회 회귀 ⑥저장 SP 미실행(hook #104)

---

## §6. 확정 요청

| # | 항목 | 선택 |
|---:|---|---|
| Q1 | 대상 컬럼 범위 | **ⓐ 안전 코어 16컬럼만**(권장) / ⓑ PK×VARCHAR2 전량(§4-A~D 포함) |
| Q2 | `_C` 버전축(`VERSION_NO`/`CUTOFF_*`) | 제외(권장) / 포함 |
| Q3 | `SCM_MST_TITLESET_USER` (전 화면 공용) | 제외(권장) / 포함 |
| Q4 | 리포트 차원 텍스트(§4-C) | 제외 / 포함 |
| Q5 | `PKG_DMF0000` 환율 공용 | 이번 포함 / 별건 |
| Q6 | 조회 5건(§3) | 전부 `'-'` 로 / `CUTOFF_YYYYMMDD`·`VERSION_NO` 축은 NULL 유지 |
