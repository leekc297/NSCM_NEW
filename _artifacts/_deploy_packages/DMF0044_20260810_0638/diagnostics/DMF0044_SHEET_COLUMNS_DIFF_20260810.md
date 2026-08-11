# DMF0044 / SHEET_NAME='MDF Reports' — SHEET_COLUMNS AS-IS ↔ TO-BE 전수 대조

AS-IS 46행 / TO-BE 46행

## 1. 컬럼 집합 — 공통 46 / AS-IS 전용 0 / TO-BE 전용 0

→ **집합 완전 일치** ✅

## 2. 공통 컬럼 속성 차이

차이 **3건**

| COLUMN_NAME | 속성 | AS-IS | TO-BE |
|---|---|---|---|
| BIZ_TYPE_NAME40 | CELL_COMBO_DATA_TYPE | `DM_Biz_Type` | `DmBizType` |
| CURRENCY | CELL_COMBO_DATA_TYPE | `CURRENCY_LIST` | `CurrencyList` |
| FCST_TYPE | CELL_COMBO_DATA_TYPE | `FCST_TYPE` | `FcstType` |

## 3. 헤더 단수 판정 (TO-BE 공용 `getColumnDepth` 규약)

> 1단 조건 = 전 행이 `(SCLS·LCLS 둘 다 공백)` **또는** `(colLbl = SCLS = LCLS)`

- **AS-IS** → 2단 이상 (조건 위반 3행: BIZ_TYPE, BIZ_TYPE_NAME40, SOLDTO_CUST_REPORT)

- **TO-BE** → 2단 이상 (조건 위반 3행: BIZ_TYPE, BIZ_TYPE_NAME40, SOLDTO_CUST_REPORT)

> ⚠ AS-IS 화면은 메타와 무관하게 `DMF0044_Sales_Reports.cs:235~236` 이
>   `iColumnHeaderRowCount = 1` 을 넘겨 **1단으로 강제**한다. 즉 AS-IS 에서
>   SMALL/LARGE_CLASS_LABEL_NAME 은 1단 화면에서 **표시에 쓰이지 않는다**.
>   ⇒ 메타를 고치는 게 아니라 **화면이 1단임을 선언**해야 파리티가 맞는다.

---

## 4. 판정 (2026-08-10)

### 4.1 컬럼 집합 — **완전 일치 (46 = 46)** ✅
누락·신설 0. `SHEET_NAME='MDF Reports'` 도 양쪽 동일.

### 4.2 속성 차이 3건 — **모두 콤보 ID 개명 (정상)** ✅

| COLUMN_NAME | AS-IS CMBO | TO-BE CMBO | TO-BE 등록 확인 |
|---|---|---|---|
| BIZ_TYPE_NAME40 | `DM_Biz_Type` | `DmBizType` | ✅ USE_YN='Y' (E2E D2 실측 3행) |
| CURRENCY | `CURRENCY_LIST` | `CurrencyList` | ✅ USE_YN='Y' (10행) |
| FCST_TYPE | `FCST_TYPE` | `FcstType` | ✅ USE_YN='Y' (14행) |

TO-BE 콤보 ID 명명 규약(camelCase) 전환분이며 **AS-IS 명칭은 TO-BE 레지스트리에 존재하지 않는다**
(= 구명칭을 남겨두면 오히려 미등록 빈 콤보가 된다). 콤보 3종 모두 실제 행을 반환함이 E2E D2 로 실증됐다.
⇒ **정정 대상 아님**.

### 4.3 헤더 단수 — 메타 동일, **화면 선언으로 해결** ✅

양쪽 메타 모두 3행(`BIZ_TYPE` / `BIZ_TYPE_NAME40` / `SOLDTO_CUST_REPORT`)이
`SMALL_CLASS_LABEL_NAME = LARGE_CLASS_LABEL_NAME ≠ COLUMN_LABEL_NAME` 이라
TO-BE 공용 `getColumnDepth` 기준으로는 **2단**이 된다.

그러나 **AS-IS 화면은 1단**이다 — `DMF0044_Sales_Reports.cs:235~236` 이
`SetSheetHeaderColumn(siMain, 1)` / `CreateSheetHeaderColumnDtDiv(siMain, **1**, …)` 로
`iColumnHeaderRowCount = 1` 을 넘기고, 이 경우 클래스 라벨은 **표시에 쓰이지 않는다**.
(2단 화면 대조군 `DMF0072` / `DMF0074` 는 `2` 를 넘긴다.)

**채택**: 메타는 **원본 그대로 보존**하고, DMF0044 그리드가 정적 컬럼을 넘길 때
`sClsLblNm=''`/`lClsLblNm=''` 로 **1단을 선언**한다
(`components/SalesReportsGrid.tsx` `mainStaticColumns`).

- ⛔ 메타의 클래스 라벨을 지우는 방식은 **채택하지 않았다** — AS-IS 파리티가 깨지고,
  다른 소비자(UI Category Setup 화면 등)가 보는 원본 라벨까지 사라진다.
- ⛔ 공용 `packages/foundation` 의 `getColumnDepth` 도 **변경하지 않았다**(전역 prop·로직 변경 금지 규약).
- 헤더 높이는 양쪽 규약이 일치한다 — 공용 `HEIGHT_BY_COLUMN_DEPTH.ONE_DEPTH = 48` = hook #93 1단 48px.

---

## 5. ⛔ SHEET_NAME 취급 (사용자 확정 2026-08-10)

- `SHEET_NAME` 은 **절대 변경 불가**. 본 대조는 **읽기 전용**이며 어떤 DML/DDL 도 실행하지 않았다.
- **클라우드 이관 시 `SHEET_NAME` 기준 일괄 DELETE 금지.**
  메타 이관은 **INSERT-only + 행 단위 UPDATE** 만 허용(hook #98 §9 · `feedback_corp_meta_integrity_wiring`).
- 본 화면은 이번 작업에서 **SHEET_COLUMNS 무변경** — 이관 패키지에도 시트 메타 DML 이 없다.
