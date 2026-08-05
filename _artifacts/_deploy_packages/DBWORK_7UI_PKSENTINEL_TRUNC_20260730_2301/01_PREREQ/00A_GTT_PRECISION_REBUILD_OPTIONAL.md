# ⚠️ 선택 적용 — GTT 수량/금액 컬럼 `NUMBER(20,10)` 정밀도 (본 패키지 **미적용**)

> hook `deploy-package-completeness` §1.1 의 점검 항목("이관 DDL 전체에서 `NUMBER(20,10)` 검출 → 수량/금액/율 계열이면 `(30,10)` 교정 의무")에 **걸린 항목**이라 침묵하지 않고 여기 기록합니다.
> **본 패키지는 이 교정을 적용하지 않았습니다.** 이유와 판단 근거는 아래.

---

## 1. 실측

`01_PREREQ/00_GTT_DDL.sql` (GTT 203본) 스캔 결과:

| 항목 | 값 |
|---|---:|
| `NUMBER(20,10)` 컬럼을 가진 GTT | **39 종** |
| 그중 **수량·금액·율 계열** 컬럼 | **59 개** |

대표 사례:

| GTT | 컬럼 |
|---|---|
| `GTT_MST_FUTURE_PRICE_SAVE_PRICE` · `GTT_OVER_RANGE` · `GTT_TMP_MST_FUTURE_PRICE_SAVE_PRICE` | `PRICE` |
| `GTT_MF_SP` · `GTT_TEMPFCSTNPRICE` · `GTT_TEMPSITEITEM` · `GTT_TEMPSITEITEMALL` | `FORECAST_INFO_CELL_PACK_COUNT` |
| `GT_ANLO_TMP_DM_PLN_MKT_FCST_C` 외 | `QTY` |
| 그 외 | `CELL_QUANTITY` · `EXCHANGE_PRICE` · `CELL_PER_CAR` · `MODULE_PER_CAR` · `MIN_CAPACITY` · `SLURRY_LOSS_RATE` · `UNCOATED_LENGTH` 등 |

**위험**: `(20,10)` 은 정수부 10자리 → **백억(10^10) 이상 금액에서 `ORA-01438`**.
선례 = 2026-07-22 **DMF0082 클라우드 61.8B 사고** (메모리 `feedback_oracle_number_precision_aggregation` — 사용자 확정 표준 = `NUMBER(30,10)`).

---

## 2. 왜 본 패키지에서 적용하지 않았는가

| # | 사유 |
|---:|---|
| 1 | **사내도 동일하게 `(20,10)`** 이다. 즉 이번 DB 작업(division 82 / PK 센티널 / TRUNCATE→DELETE)이 만든 것이 아닌 **기존 상태**이며, 본 패키지의 범위는 "사내 작업본의 클라우드 반영"이다 |
| 2 | 클라우드만 `(30,10)` 으로 바꾸면 **사내↔클라우드 구조가 갈라진다**. 정합을 맞추려면 사내도 함께 바꿔야 하고, 그건 별건 승인 사안이다 |
| 3 | GTT 정밀도 변경은 **구조 변경**이라 `-955 skip` 멱등 DDL 로는 반영되지 않는다 → `DROP` 후 재생성이 필요하고, 이는 7 화면 런타임에 영향을 준다 |
| 4 | 사용자 지시 기조 = **"문제 발생 소지가 보이면 무조건 제외 / 확실한 것만 적용"** |

---

## 3. 적용하려면 (별건 승인 시)

`-955 skip` 은 **이미 존재하는 구판 GTT 를 갱신하지 못한다**. 따라서 순서가 중요합니다.

```sql
-- Step 1. BE 정지 (사용 중이면 ORA-14452)
-- Step 2. 대상 GTT DROP  (미존재 -942 skip / 사용중 -14452 = BE 재기동 안내)
BEGIN
  FOR R IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TEMPORARY='Y'
             AND TABLE_NAME IN ( /* 39종 목록 */ )) LOOP
    BEGIN EXECUTE IMMEDIATE 'DROP TABLE '||R.TABLE_NAME;
    EXCEPTION WHEN OTHERS THEN
      IF SQLCODE NOT IN (-942) THEN DBMS_OUTPUT.PUT_LINE(R.TABLE_NAME||' '||SQLERRM); END IF;
    END;
  END LOOP;
END;
/
-- Step 3. 00_GTT_DDL.sql 의 해당 컬럼을 (30,10) 으로 고친 사본을 실행
-- Step 4. 검증
SELECT TABLE_NAME, COLUMN_NAME, DATA_PRECISION, DATA_SCALE
  FROM USER_TAB_COLUMNS
 WHERE DATA_PRECISION=20 AND DATA_SCALE=10
   AND REGEXP_LIKE(COLUMN_NAME,'QTY|QUANTITY|PRICE|AMT|RATE|RATIO|CAPACITY|COUNT|PER_');
-- 기대: 0행
-- Step 5. 02_DB_SP 전량 재적용(의존 오브젝트 재컴파일) → BE 재기동
```

> ⚠️ **사내에도 동일 교정을 함께 적용**해야 두 환경이 갈라지지 않습니다. 별건으로 판단해 주십시오.

---

## 4. 판단 요청

| 선택 | 결과 |
|---|---|
| **A. 현행 유지 (본 패키지 기본값)** | 사내와 동일 구조 유지. 백억 이상 금액 입력 시 `ORA-01438` 위험 잔존 |
| B. 클라우드만 교정 | 사고 위험 감소하나 **사내↔클라우드 구조 불일치** 발생 |
| C. 사내 + 클라우드 동시 교정 | 표준(`NUMBER(30,10)`) 정합. **별건 작업 + 7 화면 회귀 검증 필요** |
