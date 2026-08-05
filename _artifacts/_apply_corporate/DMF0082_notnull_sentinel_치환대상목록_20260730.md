# DMF0082 — PK 컬럼 센티널 `'-'` 치환 대상 목록 (**적용 보류 / 검토용**)

> **대상 확정 이력**: NOT NULL 24 → VARCHAR2 18 → **PK 16 → DMF0082 실작업 13** (사용자 3단 축소 지시 반영)

> **요청**: "81 DIVISION 일 때 초기값 `'-'` 넣어주도록. TABLE에는 필수 항목이지만 해당 DIVISION에서
> 사용하지 않는 경우에는 `NVL(x,'-')` 처리. 조회 시에도 SELECT 절에서 필요 시 `NVL(x,'-') AS x`"
> → PLANT_SITE_ID 만이 아니라 **해당 컬럼 전체** 추출 (사용자 정정 2026-07-30)
> **근거 룰**: hook #119 `oracle-null-sentinel-and-notnull-default` (센티널 `'-'` 통일 / 문자 `NVL(x,'-')` · 숫자 `NVL(x,0)` · DATE `SYSDATE`)
> **상태**: **미적용** — 케이스 확정 후 적용 예정

---

## §0. 구조 요약 — NULL 은 어디서 들어오는가

```
FE '^' payload ──split──> v_* 지역변수 ──> [A] INSERT INTO GT_PRDM1_T_MAIN   (28컬럼 전부 NULLABLE)
                                              │
                          [B] 81/82 정규화 UPDATE (현재 END_CUSTOMER / CELL_PROD_SITE_ID 만)
                                              │
                                              ├──> 8개 영속 테이블 DML (NOT NULL 다수) ← ORA-01400 위험
                                              └──> 하류 SELECT 71곳 / JOIN·ON 41곳 (NULL 이면 키 불일치)
```
**핵심**: 영속 테이블은 NOT NULL 인데 **스테이징 GTT `GT_PRDM1_T_MAIN` 은 28컬럼 전부 NULLABLE**.
빈 문자열은 Oracle 에서 NULL 이므로, FE 가 해당 division 미사용 컬럼을 공란으로 보내면 그대로 NULL 이 된다.

---

## §1. 대상 테이블 NOT NULL 컬럼 인벤토리 (ALL_TAB_COLUMNS 실측)

| 테이블 | 전체 | NOT NULL |
|---|---:|---:|
| `DM_PLN_MKT_FCST` (81계 수요) | 25 | 13 |
| `DM_PLN_MKT_FCST_H` (이력) | 52 | 14 |
| `DM_PLN_MKT_FCST_C` (컷오프) | 29 | 17 |
| `SCM_MST_FUTURE_PRICE` (81계 판가) | 26 | 16 |
| `SCM_MST_FUTURE_PRICE_H` | 28 | 15 |
| `SCM_MST_FUTURE_PRICE_C` | 30 | 20 |
| `DM_PLN_CFM_MKT_DEMAND_PLAN` (40계 수요) | 27 | 15 |
| `DM_PLN_CFM_SELLING_PRICE` (40계 판가) | 28 | 18 |
| **`GT_PRDM1_T_MAIN` (스테이징 GTT)** | 28 | **0 ← 전부 NULLABLE** |

### 대상 축소 3단계 (사용자 확정 2026-07-30)

| 단계 | 기준 | 결과 |
|---|---|---:|
| ① | NOT NULL 컬럼 합집합 | 24 |
| ② | **+ `DATA_TYPE='VARCHAR2'`** (NUMBER/DATE 제외) | 18 |
| ③ | **+ PK 구성 컬럼만** (사용자 최종 확정) | **16** |
| ④ | + DMF0082 가 실제 DML 하는 테이블만 (`_C` 컷오프 3컬럼 제외) | **13 ← 최종 작업 대상** |

**판정 SQL (재현 가능)**
```sql
-- ③ PK × VARCHAR2 × NOT NULL 교집합
SELECT cc.COLUMN_NAME, COUNT(DISTINCT c.TABLE_NAME) TBLS
  FROM ALL_CONSTRAINTS c
  JOIN ALL_CONS_COLUMNS cc ON c.OWNER=cc.OWNER AND c.CONSTRAINT_NAME=cc.CONSTRAINT_NAME
  JOIN ALL_TAB_COLUMNS  tc ON tc.OWNER=c.OWNER AND tc.TABLE_NAME=c.TABLE_NAME
                          AND tc.COLUMN_NAME=cc.COLUMN_NAME
 WHERE c.OWNER='SCM_MGR' AND c.CONSTRAINT_TYPE='P' AND tc.DATA_TYPE='VARCHAR2'
   AND c.TABLE_NAME IN (8테이블)
 GROUP BY cc.COLUMN_NAME ORDER BY 2 DESC, 1;     -- 실측: 16 컬럼 (전부 NULLABLE='N')
```
> ✅ PK 기준이 의미상으로도 정확: PK = **MERGE ON / JOIN 키**이며, NULL 이면 매칭 실패 → 항상 INSERT →
> NOT NULL 위반으로 직결된다 (hook #119 "JOIN 키 → 양변 NVL" 과 동일 지점).

### 테이블별 PK 구성 (실측)

| 테이블 | PK 제약 | 컬럼 수 | VARCHAR2 PK |
|---|---|---:|---:|
| `DM_PLN_CFM_MKT_DEMAND_PLAN` | `PK_DM_PLN_CFM_MKT_DEMAND_PLAN` | 12 | 12 |
| `DM_PLN_CFM_SELLING_PRICE` | `PK_DM_PLN_CFM_SELLING_PRICE` | 12 | 12 |
| `DM_PLN_MKT_FCST` | `PK_DM_PLN_MKT_FCST` | 10 | 10 |
| `SCM_MST_FUTURE_PRICE` | `PK_SCM_MST_FUTURE_PRICE` | 11 | 11 |
| `DM_PLN_MKT_FCST_C` | `PK_DM_PLN_MKT_FCST_C_PART` | 14 | 13 (+DATE 1) |
| `SCM_MST_FUTURE_PRICE_C` | `PK_SCM_MST_FUTURE_PRICE_C_PART` | 15 | 14 (+DATE 1) |
| **`DM_PLN_MKT_FCST_H`** | `PK_DM_PLN_MKT_FCST_H` | **1** | **0** (`HISTORY_SEQ` NUMBER) |
| **`SCM_MST_FUTURE_PRICE_H`** | `PK_SCM_MST_FUTURE_PRICE_H` | **1** | **0** (동일) |

> ⭐ **이력(_H) 테이블 2본은 PK 가 `HISTORY_SEQ`(NUMBER) 뿐 → PK 기준에서 대상 0**.
> 즉 §4 의 **B7·B8 (이력 INSERT 2문장) 은 작업 대상에서 빠진다**.

| # | 컬럼 | 타입 | 등장 테이블 | 제안 처리 | GTT 공급원 |
|---:|---|---|---:|---|---|
| 1 | `DIVISION_ID` | VARCHAR2 | 8 | `NVL(x,'-')` | `v_p_division_id_val` |
| 2 | `PROJECT_CODE` | VARCHAR2 | 8 | `NVL(x,'-')` | FE split |
| 3 | `SCM_SITE_ID` | VARCHAR2 | 8 | `NVL(x,'-')` | FE split |
| 4 | `ITEM_ID` | VARCHAR2 | 8 | `NVL(x,'-')` | FE split |
| 5 | `INCOTERMS` | VARCHAR2 | 8 | `NVL(x,'-')` | FE split |
| 6 | `MEASURE` | VARCHAR2 | 8 | `NVL(x,'-')` | FE split |
| 7 | **`PLANT_SITE_ID`** | VARCHAR2 | 8 | `NVL(x,'-')` | FE split |
| 8 | `YYYYMMDD` | VARCHAR2 | 8 | `NVL(x,'-')` | FE split |
| 9 | `DOM_EXP` | VARCHAR2 | 7 | `NVL(x,'-')` | FE split |
| 10 | `FCST_TYPE` | VARCHAR2 | 7 | `NVL(x,'-')` | FE split |
| 11 | `CURRENCY` | VARCHAR2 | 4 (판가) | `NVL(x,'-')` | FE split |
| 12 | `CREATED_BY` | VARCHAR2 | 4 (판가) | `NVL(x,'-')` | `v_p_created_by_val` |
| 13 | `LAST_UPDATED_BY` | VARCHAR2 | 4 (판가) | `NVL(x,'-')` | `v_p_created_by_val` |
| 14 | `END_CUSTOMER` | VARCHAR2 | 2 (40계) | `NVL(x,'-')` | **이미 81/82 정규화됨** |
| 15 | `CELL_PROD_SITE_ID` | VARCHAR2 | 2 (40계) | `NVL(x,'-')` | **이미 81/82 정규화됨** |
| 16 | `VERSION_NO` | VARCHAR2 | 2 (_C) | `NVL(x,'-')` | 컷오프 SP 소관(DMF0082 미DML) |
| 17 | `CUTOFF_TYPE` | VARCHAR2 | 2 (_C) | `NVL(x,'-')` | 동일 |
| 18 | `CUTOFF_YYYYMMDD` | VARCHAR2 | 2 (_C) | `NVL(x,'-')` | 동일 |
| ~~19~~ | ~~`QTY`~~ | NUMBER | 4 | **대상 제외** | (참고: 이미 `NVL(B.QTY_PRICE,0)`) |
| ~~20~~ | ~~`PRICE`~~ | NUMBER | 4 | **대상 제외** | (참고: `CAST(B.QTY_PRICE AS NUMBER)` — NVL 없음) |
| ~~21~~ | ~~`HISTORY_SEQ`~~ | NUMBER | 2 (_H) | **대상 제외** | 시퀀스 `NEXTVAL` |
| ~~22~~ | ~~`CREATION_DATE`~~ | DATE | 8 | **대상 제외** | `SYSDATE` 직접(L11299) 또는 `V_GETDATE` |
| ~~23~~ | ~~`LAST_UPDATE_DATE`~~ | DATE | 8 | **대상 제외** | 동일 |
| ~~24~~ | ~~`CUTOFF_YYYYMMDD_DATE`~~ | DATE | 2 (_C) | **대상 제외** | 컷오프 SP 소관 — DMF0082 미DML |

> ✅ NUMBER/DATE 6종은 **사용자 확정으로 대상 제외**. 참고로 위험도도 낮음 — DATE 는 `V_GETDATE DATE;`(L10063)
> → **`V_GETDATE := SYSDATE;`(L12145)** 이고 첫 사용이 **L12201**(대입 이후)이라 NULL 불가, 그 앞 DML(L11288)은
> `SYSDATE` 리터럴 직접. NUMBER 3종 중 `QTY` 는 이미 NVL, `HISTORY_SEQ` 는 시퀀스.
> (`PRICE` 만 NVL 미적용 상태이나 **본 과제 범위 밖** — 별건으로 판단 필요 시 재보고)

### ✅ 최종 대상 = **PK × VARCHAR2 13개** (DMF0082 실작업)

| # | 컬럼 | PK 등장 테이블 수 |
|---:|---|---:|
| 1 | `DIVISION_ID` | 6 |
| 2 | `PROJECT_CODE` | 6 |
| 3 | `SCM_SITE_ID` | 6 |
| 4 | `ITEM_ID` | 6 |
| 5 | `DOM_EXP` | 6 |
| 6 | `FCST_TYPE` | 6 |
| 7 | `INCOTERMS` | 6 |
| 8 | `MEASURE` | 6 |
| 9 | **`PLANT_SITE_ID`** | 6 |
| 10 | `YYYYMMDD` | 6 |
| 11 | `END_CUSTOMER` | 2 (40계 2본) |
| 12 | `CELL_PROD_SITE_ID` | 2 (40계 2본) |
| 13 | `CURRENCY` | 2 (판가 2본) |

**대상 제외 (PK 아님)** — 이전 단계에서 포함됐던 2개:
`CREATED_BY`, `LAST_UPDATED_BY` → NOT NULL·VARCHAR2 이지만 **PK 구성 아님** → 제외
**대상 제외 (`_C` 컷오프 전용, DMF0082 미DML)**: `VERSION_NO`, `CUTOFF_TYPE`, `CUTOFF_YYYYMMDD`

---

## §2. 판정 기준 = **테이블 DDL 의 NOT NULL 여부** (사용자 확정 2026-07-30)

> **데이터 분포로 "미사용 컬럼"을 추정하지 않는다.** 판정은 오직 `ALL_TAB_COLUMNS.NULLABLE='N'` 로 한다.
> 이유: 현재 데이터에 값이 있는지는 시점·이력에 따라 변하므로 판정 근거가 될 수 없다.
> **규칙**: 대상 = **§1 의 NOT NULL 컬럼 전량** × **공급원이 NULLABLE(스테이징 GTT / 리터럴 아님)** 인 지점.
> 타입별 처리 = 문자 `NVL(x,'-')` · 숫자 `NVL(x,0)` · DATE `SYSDATE` (hook #119).

### 판정 원장 (SQL — 재현 가능)
```sql
-- 영속 테이블 NOT NULL 컬럼 = 치환 대상 모집단
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
  FROM ALL_TAB_COLUMNS
 WHERE OWNER='SCM_MGR' AND NULLABLE='N'
   AND TABLE_NAME IN ('DM_PLN_MKT_FCST','DM_PLN_MKT_FCST_H','DM_PLN_MKT_FCST_C'
                     ,'SCM_MST_FUTURE_PRICE','SCM_MST_FUTURE_PRICE_H','SCM_MST_FUTURE_PRICE_C'
                     ,'DM_PLN_CFM_MKT_DEMAND_PLAN','DM_PLN_CFM_SELLING_PRICE')
 ORDER BY TABLE_NAME, COLUMN_ID;      -- 실측 결과: 합집합 24 컬럼 (§1 표)

-- 공급원(스테이징)은 전 컬럼 NULLABLE → NOT NULL 위반 가능 경로
SELECT COLUMN_NAME, NULLABLE FROM ALL_TAB_COLUMNS
 WHERE OWNER='SCM_MGR' AND TABLE_NAME='GT_PRDM1_T_MAIN';   -- 실측: 28 컬럼 전부 'Y'
```

> 참고(맥락용, 판정 근거 아님): 현재 `SCM_MST_FUTURE_PRICE.PLANT_SITE_ID` 는 82 전건·40 34% 가 이미 `'-'` 로
> 저장돼 있어 센티널 규약이 실제로 통용되고 있음을 보여준다. 그러나 **대상 선정은 위 DDL 기준만 사용**한다.

---

## §3. 【저장】 치환 대상 — 방식 A (권장) : 정규화 1지점

> 스테이징을 정규화하면 하류 **DML 8문장 + SELECT 71곳 + JOIN·ON 41곳 + GROUP BY 30곳이 전부 자동 안전**.
> 개별 DML 마다 NVL 을 흩뿌리는 것보다 diff 가 작고 누락 위험이 없다 (sp-body-minimal-change).

### A-1. 기존 81/82 정규화 블록 확장 — **L10290~10296**

**현재 문구**
```sql
    IF (V_DIVISION_ID LIKE '81%' OR V_DIVISION_ID = '82') THEN
        v_is_81 := 'Y';
        -- 81 테이블에는 END_CUSTOMER / CELL_PROD_SITE_ID 컬럼이 없다 (ALL_TAB_COLUMNS 실측 2026-07-14).
        -- GET 커서의 '-' 리터럴과 동일하게 T_MAIN 도 '-' 로 정규화하여 하류 join 키를 일관시킨다.
        UPDATE SCM_MGR.GT_PRDM1_T_MAIN
        SET END_CUSTOMER = '-', CELL_PROD_SITE_ID = '-';
    END IF;
```

**제안 문구** (81/82 전용 — 40 무영향)
```sql
    IF (V_DIVISION_ID LIKE '81%' OR V_DIVISION_ID = '82') THEN
        v_is_81 := 'Y';
        -- 81 테이블에는 END_CUSTOMER / CELL_PROD_SITE_ID 컬럼이 없다 (ALL_TAB_COLUMNS 실측 2026-07-14).
        -- GET 커서의 '-' 리터럴과 동일하게 T_MAIN 도 '-' 로 정규화하여 하류 join 키를 일관시킨다.
        UPDATE SCM_MGR.GT_PRDM1_T_MAIN
        SET END_CUSTOMER = '-', CELL_PROD_SITE_ID = '-';
    END IF;

    --[NN] PK 센티널 정규화 (hook #119) — 영속 테이블 PK 는 NOT NULL 이나 본 GTT 는 전 컬럼 NULLABLE.
    --     PK 는 MERGE ON/JOIN 키이므로 NULL 이면 매칭 실패 → 항상 INSERT → NOT NULL 위반.
    --     해당 division 이 사용하지 않는 PK 컬럼(공란=Oracle NULL)을 '-' 로 통일한다.
    --     대상 = PK × VARCHAR2 13컬럼 (NUMBER/DATE·비PK 는 사용자 확정으로 제외)
    UPDATE SCM_MGR.GT_PRDM1_T_MAIN
       SET DIVISION_ID       = NVL(DIVISION_ID,       '-')
         , PROJECT_CODE      = NVL(PROJECT_CODE,      '-')
         , END_CUSTOMER      = NVL(END_CUSTOMER,      '-')
         , SCM_SITE_ID       = NVL(SCM_SITE_ID,       '-')
         , ITEM_ID           = NVL(ITEM_ID,           '-')
         , DOM_EXP           = NVL(DOM_EXP,           '-')
         , FCST_TYPE         = NVL(FCST_TYPE,         '-')
         , INCOTERMS         = NVL(INCOTERMS,         '-')
         , MEASURE           = NVL(MEASURE,           '-')
         , PLANT_SITE_ID     = NVL(PLANT_SITE_ID,     '-')
         , CELL_PROD_SITE_ID = NVL(CELL_PROD_SITE_ID, '-')
         , YYYYMMDD          = NVL(YYYYMMDD,          '-')
         , CURRENCY          = NVL(CURRENCY,          '-')
     WHERE DIVISION_ID       IS NULL OR PROJECT_CODE  IS NULL OR END_CUSTOMER      IS NULL
        OR SCM_SITE_ID       IS NULL OR ITEM_ID       IS NULL OR DOM_EXP           IS NULL
        OR FCST_TYPE         IS NULL OR INCOTERMS     IS NULL OR MEASURE           IS NULL
        OR PLANT_SITE_ID     IS NULL OR YYYYMMDD      IS NULL OR CELL_PROD_SITE_ID IS NULL
        OR CURRENCY          IS NULL;
```
> ✅ PK × VARCHAR2 **13컬럼 정확 일치**. 비PK(`CREATED_BY`/`LAST_UPDATED_BY`)·NUMBER(`QTY_PRICE`)·DATE 는
> 사용자 확정으로 **제외**.

> ⚠️ **정규화 위치 = 검증(#1~#19) 시작 전**(L10297 이후 블록보다 앞). 단, **V81-01 필수 검증**은
> `NVL(A.PLANT_SITE_ID,'-') = '-'` 를 오류로 보므로 **정규화를 앞에 두면 V81-01 이 무력화**된다.
> → **결정 필요**: ⓐ 정규화를 V81-01 **뒤**에 두어 검증은 살린다(권장) / ⓑ 앞에 두고 V81-01 에서 PLANT_SITE_ID 제외.
> 관련 문구 = **L11602~11612 V81-01** (아래 §5 참조).

### A-2. 스테이징 진입 시점 처리(대안) — **L10249~10260**
**현재** `, v_plant_site_id, v_cell_prod_site_id, v_yyyymmdd, v_currency` (L10257)
**대안** 각 `v_*` 를 `NVL(v_*, '-')` 로. → A-1 과 중복이므로 **A-1 채택 시 불필요**.

---

## §4. 【저장】 치환 대상 — 방식 B (대안) : DML 8문장 개별 NVL

> A 를 쓰지 않을 경우의 전량 목록. `컬럼 ↔ 값표현식` 위치 1:1 대조 실측(개수 불일치 0건).

> 컬럼 수 = **PK × VARCHAR2 기준** (사용자 최종 확정 반영). 파서 실측 — 컬럼↔값 개수 불일치 0건.

| # | 위치 | 문장 | 대상 테이블 | PK-VARCHAR2 | **NVL 필요** | 제외(리터럴) |
|---:|---|---|---|---:|---:|---|
| B1 | **L11288~11310** | `INSERT` | `DM_PLN_CFM_MKT_DEMAND_PLAN` | 12 | **11** | `MEASURE`=`'RTF_SYS_RP'` |
| B2 | **L12174~12210** | `MERGE` | `DM_PLN_CFM_SELLING_PRICE` | 12 | **12** | — |
| B3 | **L12231~12263** | `MERGE` | `SCM_MST_FUTURE_PRICE` | 11 | **11** | — |
| B4 | **L12369~12405** | `MERGE` | `DM_PLN_CFM_MKT_DEMAND_PLAN` | 12 | **12** | — |
| B5 | **L12407~12442** | `MERGE` | `DM_PLN_MKT_FCST` | 10 | **10** | — |
| B6 | **L12528~12560** | `INSERT` | `DM_PLN_CFM_MKT_DEMAND_PLAN` | 12 | **11** | `MEASURE` 리터럴 |
| ~~B7~~ | ~~L12630~12660~~ | `INSERT ... SELECT` | `SCM_MST_FUTURE_PRICE_H` | **0** | **0** | PK=`HISTORY_SEQ`(NUMBER) |
| ~~B8~~ | ~~L12693~12720~~ | `INSERT ... SELECT` | `DM_PLN_MKT_FCST_H` | **0** | **0** | 동일 |
| | | | **합계** | | **67건** | |

> **B 방식 = 67건 치환 + MERGE ON 4곳(양변)** vs **A 방식 = 1블록(13컬럼)**.
> PK 기준으로 좁혀도 여전히 A 가 유리 (이력 2문장은 자동 제외).

### B-공통 : `MERGE ON` 절도 함께 봐야 함 (NULL 이면 매칭 실패 → 항상 INSERT → NOT NULL 위반)
| 위치 | 현재 문구(발췌) |
|---|---|
| L12188 | `AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID` |
| L12244 | `AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID` |
| L12389 | `AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID` |
| L12425 | `AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID` |
> hook #119 = **양변 NVL 의무**(`NVL(a,'-')=NVL(b,'-')`, 한쪽만 보정 금지). **A 방식 채택 시 불필요**(GTT 가 이미 '-' 확정).

### ~~B-추가 : 숫자 NOT NULL 미보정~~ → **대상 제외** (VARCHAR2 외 제외, 사용자 확정)
참고로만 기록 (본 과제 범위 밖):
| 위치 | 현재 문구 | 상태 |
|---|---|---|
| L12207 근처 (`DM_PLN_CFM_SELLING_PRICE.PRICE`) | `CAST(B.QTY_PRICE AS NUMBER(20,10))` | NVL 미적용 |
| L12262 근처 (`SCM_MST_FUTURE_PRICE.PRICE`) | `CAST(B.QTY_PRICE AS NUMBER(20,10))` | NVL 미적용 |
| L12402 근처 (`DM_PLN_CFM_MKT_DEMAND_PLAN.QTY`) | `B.QTY_PRICE` | NVL 미적용 |

---

## §5. 검증 로직과의 충돌 — **결정 필요 (중요)**

**V81-01 (L11602~11619) 실제 문구 — 전문 실측**
```sql
        SELECT COUNT(*) INTO v_cnt_check
        FROM SCM_MGR.GT_PRDM1_T_MAIN A
        WHERE NVL(A.DIVISION_ID, '-')   = '-'
           OR NVL(A.PROJECT_CODE, '-')  = '-'
           OR NVL(A.SCM_SITE_ID, '-')   = '-'
           OR NVL(A.ITEM_ID, '-')       = '-'
           OR NVL(A.DOM_EXP, '-')       = '-'
           OR NVL(A.FCST_TYPE, '-')     = '-'
           OR NVL(A.INCOTERMS, '-')     = '-'
           OR NVL(A.MEASURE, '-')       = '-'
           OR NVL(A.PLANT_SITE_ID, '-') = '-';      -- ⭐ L11613
        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := ' Check Mandatory Columns ( Fcst type or Incoterms or Customs Handbook or Plant Site ) !';
            RAISE e_validation_error;
        END IF;
```
이 검증은 **`'-'` 를 "미입력 오류"로 판정**하며 **`PLANT_SITE_ID` 를 명시 포함**(L11613)한다.
→ 센티널 정규화와 **정면 충돌 확정**. 정규화를 앞에 두면 이 검증이 전건 통과(무력화)되고,
뒤에 두면 "미사용 컬럼 공란" 건이 여기서 차단된다.

| 선택지 | 내용 | 영향 |
|---|---|---|
| **① 정규화를 V81-01 뒤에 배치** (권장) | 검증은 원본 NULL 로 수행 → 통과한 건만 '-' 정규화 | 검증 의미 보존. "미사용 컬럼"은 여전히 오류로 걸림 |
| ② V81-01 에서 미사용 컬럼 제외 | `PLANT_SITE_ID` 등을 검증 대상에서 빼고 정규화 | 필수 검증 완화 — **사용자 확정 필요** |
| ③ division 별 검증 컬럼 분기 | 81/82 는 PLANT_SITE_ID 검증, 40 은 제외 등 | 가장 정확하나 변경량 큼 |

> ⚠️ 이 결정 없이는 "82 는 `'-'` 로 저장되는데 V81-01 이 `'-'` 를 오류로 막는" 모순이 남습니다.

---

## §6. 【조회】 치환 대상 — SELECT 절 `NVL(x,'-') AS x`

### C-1. 리터럴 NULL 출력 (확정 치환 대상) — **L770**
```sql
         , NULL                                              AS PLANT_SITE_ID        -- 원본 GTT 에 없는 컬럼
```
→ 제안: `, '-'                                               AS PLANT_SITE_ID        -- 원본 GTT 에 없는 컬럼 ('-' 센티널)`
- 흐름: `GT_DMF0082_TEMP_SITE_ITEM_ALL` 적재(L770) → **L914 `MAX(PLANT_SITE_ID) AS PLANT_SITE_ID`** 집계 → 하류 전파. 현재는 계속 NULL.
- 동일 패턴 다른 컬럼: **L767 `NULL AS SORT_ORDER_NO`** / **L773 `NULL AS PROJECT_S_OP_REPORT`** — 둘 다 NOT NULL 대상 아님(치환 불요, 참고).

### C-2. 화면 표시 컬럼 (FE 노출) — 판가 일괄저장 팝업만 해당
`SCM_MST_SHEET_COLUMNS` 실측: DMF0082 에서 `PLANT_SITE_ID` 표시 컬럼은 **`Sales Price Save All` 시트 1행뿐**
(`Plant Site*`, VISIBLE='Y', DIVISION_ID=`81,81_UC,81_HM,81_ST,81_HD,81_HG,82`).
→ 메인 그리드(`FcstNPrice`)에는 표시 컬럼 아님(내부 조인 키로만 사용).

**`P_DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP` 최종 커서(동적 SQL) 출력 지점**

| 분기 | 위치 | 현재 문구 | 제안 |
|---|---|---|---|
| B1(81) | **L8167** | `AA.PLANT_SITE_ID,` | `NVL(AA.PLANT_SITE_ID,'-') AS PLANT_SITE_ID,` |
| B1 내부 | L8182 / L8205 / L8256 | `PLANT_SITE_ID,` (중간 인라인뷰) | 최종 출력만 처리 시 불요 |
| B2(81) | **L8330** | `AA.PLANT_SITE_ID,` | 동일 |
| B3(81) | **L8950** / L9026 | `A.PLANT_SITE_ID,` | 동일 |
| B4(81) | **L9105** / L9168 | `A.PLANT_SITE_ID,` | 동일 |
| 40 분기 | L8239 / L8402 / L8549 / L8621 / L8744 / L9473 | `A.PLANT_SITE_ID,` / `b.PLANT_SITE_ID,` | 40 유지 방침이면 **제외** |
| 최종 조립 | **L9533 / L9550 / L9595** | `PLANT_SITE_ID,` (V_NSQL 최종 SELECT — `OPEN O_CURSOR FOR V_NSQL` L9605) | ⭐ **여기 1곳만 `NVL(PLANT_SITE_ID,'-') AS PLANT_SITE_ID` 로 하면 분기 무관 일괄 해결** |

> **권장**: C-2 는 **L9533/9550/9595 최종 조립 지점**만 처리 (분기별 6~10곳 대신 최소 diff).
> 정확한 대상 라인은 §7 실행 전 `V_NSQL` 조립 구조 확인 1회 더 필요.

### C-3. 메인 조회(`GET_MAIN_DATA` / `_CURRENT`) SELECT 출력
`PLANT_SITE_ID` 는 **FE 표시 컬럼이 아니고** PIVOT 키/조인 키로만 쓰인다.
→ **조회 NVL 은 불요**. 단 §3-A 정규화로 저장 데이터가 항상 `'-'` 이면 조인 키도 자동 일관.
(현재 위험은 오히려 **L770 리터럴 NULL** → C-1 로 해결)

---

## §7. 적용 시 검증 계획 (실행 승인 후)

1. 변경 전 BODY 백업 (`BACKUP_PKG_DMF0082_body_pre_notnull_<stamp>.sql`)
2. 치환 규칙별 **기대건수 assert** + **라인수 불변** + 주석 라인 제외 (hook #119 파서 교훈)
3. BE 정지 → `DDL_LOCK_TIMEOUT` → 배포 → `USER_ERRORS 0` / `VALID` → BE 재기동
4. 사후: `GET_MAIN_DATA` 40/81/82 회귀(행수·SUCCESS 동일) + 판가팝업 82 조회
5. 저장은 **화면 E2E 위임** (hook #104 — SAVE SP 부수효과 보유, 임의 실행 금지)

---

## §8. 확정 필요 항목 (사용자 결정 대기)

| # | 항목 | 선택지 |
|---:|---|---|
| Q1 | 방식 | **A(정규화 1지점, 권장)** / B(DML 8문장 100건+) |
| Q2 | 적용 범위 division | **81계+82 만**(현재 정규화 블록 안 = 40 무영향) / 40 포함 전 division |
| Q3 | **V81-01 필수검증 충돌** (§5) | ①정규화를 검증 뒤로(권장) / ②검증에서 미사용 컬럼 제외 / ③division 별 분기 |
| Q4 | ~~대상 컬럼~~ | **확정됨** — `PK × VARCHAR2 × NOT NULL` → **DMF0082 실작업 13컬럼** (NUMBER/DATE·비PK 제외, 이력 2테이블 대상 0) |
| Q5 | 조회 NVL | C-1(L770) + C-2 최종조립 3곳 / C-2 분기별 전량 / C-1 만 |
| Q6 | ~~DATE 컬럼~~ | **해결됨** — `V_GETDATE := SYSDATE`(L12145) 가 첫 사용(L12201)보다 앞. 치환 불요 |
