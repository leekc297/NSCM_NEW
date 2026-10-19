# DMF0082 CURRENCY 결손 + 행분리 보완 — 클라우드 이관 패키지

> ✅ **클라우드 적용·확인 완료 (2026-09-18)** — CURRENCY 채움 정상, 행분리 1줄로 해소

> 생성 2026-09-18 · 대상 `PKG_DMF0082` **BODY 단독** (SPEC 변경 없음)
> 사내 ZIOUI1 적용 완료 — **보완 5건** (`LAST_DDL 2026-09-18 14:03:34`, `STATUS=VALID`, 컴파일 오류 0건)
> ⭐ **클라우드 실증으로 진짜 원인 확정 — `MERGE ON` 의 NULL 거동** (§2-0)
> **FE 변경 없음** — DB 단독 패키지

## 1. 증상

DMF0082 조회 시 CURRENCY 는 Unit Price 행에만 원천 값이 있고, 나머지 measure 는
`P_DMF0082_GET_MAIN_DATA` 안의 채움 로직이 Unit Price 의 통화를 복사해 넣는다.
그런데 **Unit Price 에는 통화가 보이는데 RTF / MKT FCST / SCM FCST 행만 CURRENCY 가 비는** 케이스가 있다.

## 2. 원인

### ⭐ 2-0. 근본 원인 — `MERGE ON` 은 NULL 이면 매칭되지 않는다 (클라우드 실증)

클라우드 진단(`91_DIAG_CLOUD.sql`, 40 / `MCSS22561-C1` / Current) 결과 —
`RTF_SYS_RP` 45행 중 **44행 CURRENCY 없음**, 다른 measure 는 0.

| 구분 | MEASURE | PROJECT | SCM_SITE | **PLANT_SITE_ID** | ITEM | INCO | DOM | FCST | CELL_PROD | 행수 | 통화 |
|---|---|---|---|---|---|---|---|---|---|---:|---|
| 결손 | `RTF_SYS_RP` | NT | BYD Electronics_CN_SZX | **(빈값=NULL)** | MCSS22561-C1 | DAP | E | MPS | NJ01-A | 44 | — |
| 단가 | `LOC` | NT | BYD Electronics_CN_SZX | **`-`** | MCSS22561-C1 | DAP | E | MPS | NJ01-A | 80 | USD |

9키 중 **`PLANT_SITE_ID` 만** 다르다. 수요/실적 행은 `NULL`, 단가 행은 `'-'`.

그런데 Oracle 의 `MERGE ... ON A.col = B.col` 은 한쪽이 NULL 이면 UNKNOWN 이라
**NULL 인 행은 어떤 값과도 매칭되지 않는다. 양쪽이 모두 NULL 이어도 마찬가지다.**

실증 (`_raw/nullproof.py`):

| 조인 방식 | `NULL` vs `'-'` | `NULL` vs `NULL` |
|---|---:|---:|
| `A.col = B.col` (원문) | **0행** | **0행** |
| `NVL(A.col,'-') = NVL(B.col,'-')` | 1행 | 1행 |

즉 조인키 중 **하나라도 NULL 이면 CURRENCY 채움이 통째로 무력화**된다.

**사내에서 재현되지 않은 이유** — ZIOUI1 은 DIV 40 의 `PLANT_SITE_ID` 가 전 행 `'-'` 이고 NULL 이 0건이다.

| 원장 | DIV 40 행수 | `PLANT_SITE_ID` NULL | `'-'` |
|---|---:|---:|---:|
| `DM_PLN_CFM_MKT_DEMAND_PLAN` | 244,124 | **0** | 244,124 |
| `DM_PLN_SALES_PLAN_RESULT` | 38,008 | **0** | 38,008 |
| `DM_PLN_CFM_SELLING_PRICE` | 567,972 | **0** | 567,972 |

클라우드는 수요/실적 쪽이 NULL 이라 드러난다.
`RTF[R+P]`·`BALANCE` 만 비어 보이는 것도 이 때문이다 — 한 키의 일부 기간만 통화가 채워지면
최종 그리드가 `CURRENCY` 를 표시 컬럼으로 GROUP BY 하므로 **행이 둘로 갈린다**
(진단 §2-3 실측: 같은 키 통화목록 = `(없음) / USD`).

### 2-1. 함께 발견한 키 규약 불일치

"CURRENCY 업데이트 (계획구간 통화코드 보완)" MERGE 의 조인키에 `CELL_PROD_SITE_ID` 가 들어 있는데,
GTT(`GT_DMF0082_TEMP_FCST_N_PRICE`)로 적재되는 arm 마다 이 컬럼의 채움 규약이 다르다.

| 축 | 원천 | `CELL_PROD_SITE_ID` |
|---|---|---|
| 계획 수요 (40) | `DM_PLN_CFM_MKT_DEMAND_PLAN(_C)` | `A.CELL_PROD_SITE_ID` (실제값) |
| 실적 | `DM_PLN_SALES_PLAN_RESULT(_C)` | `A.CELL_PROD_SITE_ID` (실제값) |
| 계획 수요 (81/82) | `DM_PLN_MKT_FCST` | `'-'` 고정삽입 |
| 단가 (81/82) | `SCM_MST_FUTURE_PRICE(_C)` | **원장에 컬럼 자체가 없어 `'-'` 고정삽입** |
| 단가 (40) | `DM_PLN_CFM_SELLING_PRICE(_C)` | `A.CELL_PROD_SITE_ID` — `'-'` 와 실제값 혼재 |

사내 실측(2026-09-18):

| 원장 | DIV 40 `'-'` | DIV 40 실제값 |
|---|---:|---:|
| `DM_PLN_CFM_MKT_DEMAND_PLAN` | 64,039 | **219,987** |
| `DM_PLN_CFM_SELLING_PRICE` | **950,621** | 600,783 |

같은 사업 키인데 이 한 컬럼만 엇갈리면 MERGE 가 매칭되지 않는다. 단가 행은 원천에서 통화를
직접 들고 오므로 **단가만 통화가 보이고 나머지는 비는** 증상이 된다.

AS-IS(`_asis_DMF0082_GET_MAIN_DATA.live.sql` L4571~4610) 도 조인키가 동일 —
**AS-IS 승계 결함**이지 Oracle 변환 오류가 아니다.

### 실증 (ZIOUI1, DIV 40 Current)

8키 일치 + `CELL_PROD_SITE_ID` 만 불일치 = **3키**

| ITEM | SCM_SITE | PROJECT | 수요 | 단가 |
|---|---|---|---|---|
| `MIF489266C11` | `NT_CN_SZX` | NT | `NJ01-A` | `'-'` |
| `MCCM131012A1` | `Varta RO_RO_OTP` | Varta | `NJ01-A` | `'-'` |
| `MCCH350040A1T001` | `Greenway_CN_DGG` | Greenway | `NJ01-A` | `HQ06-A` |

적용 전 `MIF489266C11 / NT_CN_SZX` : MKT_FCST 4행 / RTF_SYS_RP 2행 / SCM_FCST 4행 **전부 CURRENCY NULL**
(같은 ITEM 의 Unit Price 는 정상 표시).

## 3. 보완 내용

`P_DMF0082_GET_MAIN_DATA` 의 CURRENCY 채움을 **3단계 폴백**으로 만든다.
기존 1차(9키) MERGE 는 **원문 그대로 유지**하고 뒤에 2·3차를 덧붙인다 (+74 lines).

| 단계 | 조인 축 | 마커 |
|---|---|---|
| 1차 | 9키 (AS-IS 원문 — `PROJECT_CODE`·`PLANT_SITE_ID`·`INCOTERMS`·`CELL_PROD_SITE_ID` 포함) | (기존, 무수정) |
| 2차 | 8키 = 1차 − `CELL_PROD_SITE_ID`, **조인키 `NVL(...,'-')` 정규화** | `[E20260918-CURRCELLPROD]` + `[E20260918-CURRNULLKEY]` |
| 3차 | `DIVISION_ID`+`SCM_SITE_ID`+`ITEM_ID`+`DOM_EXP`+`FCST_TYPE`, **동일 정규화** | `[E20260918-CURRSITEITEM]` + `[E20260918-CURRNULLKEY]` |

공통 안전장치 (2·3차 모두)

- **앞 단계 후에도 `CURRENCY IS NULL` 인 행만** 대상 → 비파괴, 기존 값 덮어쓰기 없음
- `HAVING COUNT(DISTINCT CURRENCY) = 1` — 그 축 안에서 통화가 갈리는 키는 **건드리지 않는다**
- 기간(`p_from_yyyymmdd ~ V_TO_YYYYMMDD`) · `MEASURE NOT LIKE 'VMI%'` 게이트는 1차와 동일
- NULL 정규화는 **`USING` 의 SELECT/GROUP BY 와 `ON` 절을 동시에** 적용한다.
  `ON` 만 정규화하면 B 쪽에 NULL 그룹과 `'-'` 그룹이 따로 생겨 한 A 행에 두 B 행이 붙어
  `ORA-30926 unable to get a stable set of rows` 가 날 수 있다.

### 3차가 필요한 이유

2차 적용 후에도 결손이 남았다. 어긋나는 컬럼이 `CELL_PROD_SITE_ID` 하나가 아니었다.

`40 / Varta RO_RO_OTP / MCCM131012A1` 실측 —

| | PROJECT_CODE | INCOTERMS | CELL_PROD | 통화 |
|---|---|---|---|---|
| 수요 행 | `Varta` | **`CIF`** | `NJ01-A` | (없음) |
| 단가 행 | `Varta` | **`CIP`** | `NJ01-A` | USD |
| 단가 행 | `VARTA(Vacuum)` | `CIF` | `HQ06-A` | USD |
| 단가 행 | `Varta` | `CIF` | `'-'` | USD |

`INCOTERMS`·`PROJECT_CODE`·`PLANT_SITE_ID` 도 수요/단가 원장 간에 갈린다.
그럼에도 **이 ITEM+SITE 의 단가는 전부 같은 통화(USD)** 다.

통화가 유일하게 결정되는 축 실측 (DIV 40 · `DM_PLN_CFM_SELLING_PRICE` · LOC · 2026~)

| 축 | 키 수 | 통화 2종 이상 |
|---|---:|---:|
| 8키 (2차) | 2,638 | 9 (0.3%) |
| **DIV+SITE+ITEM+DOM_EXP+FCST_TYPE (3차)** | **2,313** | **34 (1.5%)** |
| DIV+SITE+ITEM | 2,006 | 40 (2.0%) |
| DIV+SITE | 438 | 44 (10.0%) |

3차 축까지만 완화한다. 갈리는 1.5% 는 채우지 않고 그대로 둔다.

## 4. 파일

| 파일 | 내용 |
|---|---|
| `A_DB/01_PKG_DMF0082_BODY.sql` | 패치 반영 전체 BODY (16,220 lines · `CREATE OR REPLACE` + 종결자 `/` 포함) |
| `A_DB/90_VERIFY.sql` | 적용 검증 3절 (객체 상태·마커 / 대상 키 / 오배정 차단 게이트) |
| `A_DB/91_DIAG_CLOUD.sql` | CURRENCY 결손 진단 — 조회 재현 후 결손 행의 9키를 단가 행과 나란히 비교 |
| `A_DB/92_DIAG_ROWSPLIT.sql` | 행분리 진단 v2 — 컬럼 54개 전수로 갈리는 컬럼 지목 (필터 없음) |

## 5. 적용 순서

```
1) A_DB/01_PKG_DMF0082_BODY.sql   DBeaver 에서 단일본 실행
2) A_DB/90_VERIFY.sql §1          STATUS=VALID · 마커 존재 · ALL_ERRORS 0행
3) A_DB/90_VERIFY.sql §2          클라우드 대상 키 목록 확인 (적용 전 캡처 권장)
4) DMF0082 화면 조회               §2 키에서 RTF/MKT/SCM 의 CURRENCY 표시 확인
```

`PKG_DMF0082` SPEC 은 변경하지 않았으므로 **의존 객체 재컴파일 불필요**.

## 6. 사내 검증 결과 (2026-09-18, 3차 폴백 적용 후)

| 게이트 | 결과 |
|---|---|
| 컴파일 | `STATUS=VALID` · `ALL_ERRORS` 0행 |
| G1 결손 잔존 | **0건** |
| G2/G3 값 정합 (채운 통화 = 같은 축 LOC 통화) | **일치 11,979 / 불일치 0** |

2차만 적용했을 때 남아 있던 `MCCM131012A1 / Varta RO_RO_OTP` 10행이 3차로 해소됐다.

ITEM 10종으로 넓힌 회귀(DIV 40 Current):

| 게이트 | 결과 |
|---|---|
| 값 정합 | **일치 61,949 / 불일치 0** |
| 잔존 결손 60행 분류 | **전부 `단가(LOC) 자체 없음`** (예: `MCCM348014A3 / Celltech_TH_SAU`) — 보완 대상 아님 |
| 통화 2종 이상으로 제외된 키 | 1건 (설계상 제외) |
| **⚠ 미규명** | **0건** |

단가가 등록되지 않은 키는 Unit Price 자체가 화면에 없으므로 통화가 비는 것이 정상이다.

### 클라우드 케이스 해소 근거

클라우드 결손 키(`NT` / `BYD Electronics_CN_SZX` / `MCSS22561-C1` / `DAP` / `E` / `MPS` / `NJ01-A`)는
`PLANT_SITE_ID` 만 `NULL` vs `'-'` 로 갈렸고 단가 통화는 `USD` 단일이다.
NULL 정규화 후 **2차(8키)에서 정확히 매칭**된다 — `PROJECT_CODE`·`INCOTERMS` 변별을 유지하므로
3차까지 내려가지 않는다.

`ORA-30926` 위험은 `USING`/`ON` 동시 정규화 + `HAVING` 유일성 보장으로 차단했고,
사내 10 ITEM 회귀에서 실제로 발생하지 않았다.

**적용 후 클라우드에서 `91_DIAG_CLOUD.sql` 을 다시 돌려 §2-1 의 `통화없음` 이 0 인지 확인**해 주십시오.

## 6-1. 행분리 보완 — `[E20260918-KEYCOLGRAIN]`

### 증상
같은 업무키(같은 Model/Site/Measure)가 그리드에서 **2줄**로 나온다.

### 구조
최종 커서는 PIVOT 이라 `V_COLUMN` 에 남은 **모든 컬럼이 행 그레인**이다.

| 그레인 구성 | AS-IS | TO-BE |
|---|---|---|
| ① C_TITLE — `SCM_MST_TITLESET_USER('C')` 계정별 컬럼 설정 | ✅ | ✅ |
| ② `NOTATION` / ③ `SORT_ORDER_NO` | ✅ | ✅ |
| ④ **저장 키 12컬럼 강제 추가** | **없음** | **`[E20260822-KEYCOL]`** |

AS-IS 는 `@V_COLUMN = C_TITLE + [NOTATION]` 뿐이다(실측 `_asis_..._GET_MAIN_DATA.live.sql` L10963~10993).

### 판정 — 두 경우로 갈린다

**(가) 해당 컬럼을 화면에 표시 중 → AS-IS 도 2줄 → 현행 유지**

클라우드 실측 (40 / `Huapu_CN_CGU` / `MCSS22531-B3` / `NT`, `Cell Prod Site` 표시 계정):

| 줄 | `CELL_PROD_SITE_ID` | 행수 | 기간 | 합계 |
|---|---|---:|---|---:|
| 1 | `NJ01-A` (남경A) | 61 | 20260106~20270201 | 13,253,014 |
| 2 | `HQ06-A` (오창A) | **1** | **20260531 하루** | **-1,350** |

`RTF_SYS_RP`·`MKT_FCST`·`SCM_FCST`·`KRW`·`LOC` 동일 패턴. 그 계정 C_TITLE 에
`CELL_PROD_SITE_ID` 가 있으므로 AS-IS 도 2줄이다. 다른 생산 사이트의 실제 데이터라
합치면 정보가 사라진다 → **보완하지 않는다.**
(`LAST_UPDATED_BY` 도 값이 갈리지만 C_TITLE 에 없어 **그레인이 아니므로 행을 가르지 않는다**.)

**(나) 해당 컬럼을 숨겼는데도 2줄 → TO-BE 전용 회귀 → 보완**

AS-IS 는 숨기면 1줄로 합쳐지는데 TO-BE 는 ④ 때문에 계속 갈린다.
사내 실측(ZIOUI1, `Cell Prod Site` 를 숨긴 계정 / DIV 40):

| MEASURE | 보완 전 분리 업무키 | 보완 후 |
|---|---:|---:|
| KRW / LOC / MKT_FCST / SCM_FCST | 각 12 | **0** |
| RTF_SYS_RP | 11 | **0** |
| USD | 6 | **0** |

### 보완 내용
`MF_SP` 적재 완료 후, **C_TITLE 에 없는 KEYCOL 컬럼에 한해** 업무키 단위 대표값으로 통일한다.

- 대상 판정 = `SCM_MST_TITLESET_USER('C')` 에 그 컬럼이 **없을 때만** → 표시 중인 계정은 손대지 않음(AS-IS 파리티)
- 대표값 = **계획 구간(`BUCKET_KEY >= V_TO_RESULT`) 우선·최신** — 편집·저장 대상이 계획 구간이므로 저장 키로도 이 값이 맞다
- 업무키 = `DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE` (양변 `NVL(...,'~')` 정규화)
- `HAVING COUNT(DISTINCT ...) > 1` — 값이 1종인 업무키는 손대지 않음(멱등)
- `CURRENCY` 는 앞선 보완이 이미 키 단위로 채우므로 제외. `PLANT_SITE_ID`/`END_CUSTOMER` 는 arm 간 불일치 실측 0건이라 제외

## 6-2. 행분리 보완 2차 — `[E20260918-KEYCOLGRAIN2]` (숨긴 `PLANT_SITE_ID`)

### 증상
같은 Model/Site/Measure 가 **화면상 구분이 안 되는 2줄**로 나온다.
(`RTF[R+P]`, `BALANCE` 등 — 두 줄이 서로 다른 주차 컬럼에만 값을 갖는다)

### 원인 — 숨겨진 `PLANT_SITE_ID`
클라우드 진단(`92_DIAG_ROWSPLIT.sql` §5, 계정 `minyonglee1`) 실측 —
**보이는 컬럼은 13개**이고 `PLANT_SITE_ID` 가 **없다**.

```
CELL_PROD_SITE_ID, CURRENCY, DIVISION_ID, DOM_EXP, END_CUSTOMER, FCST_TYPE,
INCOTERMS, ITEM_ID, MEASURE, NICK_NAME, SCM_SITE_ID, TEAM_ID, VERSION_NO
```

그런데 `[E20260822-KEYCOL]` 이 `PLANT_SITE_ID` 를 그레인에 강제로 넣는다.
그리고 같은 조회의 실값은 —

| 축 | `PLANT_SITE_ID` |
|---|---|
| 수요·실적 행 | **`NULL`** |
| 단가 행 | **`'-'`** |

값은 갈리는데 화면에 안 보이므로 **똑같아 보이는 2줄**이 된다.

**AS-IS 판정**: AS-IS 의 `@V_COLUMN` 은 C_TITLE + `NOTATION` 뿐이라 숨긴 컬럼은 그레인이
아니다 → **AS-IS 는 1줄**. 따라서 TO-BE 전용 회귀이고 1줄로 합치는 것이 맞다.

**사내에서 재현 불가**: ZIOUI1 은 DIV 40 의 `PLANT_SITE_ID` 가 전 행 `'-'` (NULL 0건)이다
(수요 244,124 / 실적 38,008 / 단가 567,972행). 그래서 사내 회귀 0건은 "기존 동작을 깨지
않았다"는 뜻이지 "증상이 해소됐다"는 뜻이 아니었다 — 해소는 **클라우드 실적용으로 확인**했다.

### 보완 내용
`MF_SP` 적재 후, **`PLANT_SITE_ID` 가 C_TITLE 에 없을 때만** 업무키 단위 대표값으로 통일.

- 표시 중인 계정은 손대지 않는다(AS-IS 파리티)
- 대표값 = **계획 구간(`BUCKET_KEY >= V_TO_RESULT`) 우선·최신** — 편집·저장 대상이 계획 구간
- 업무키에서 `PLANT_SITE_ID` 제외, `CELL_PROD_SITE_ID` 포함(그쪽은 1차가 담당)
- 양변 `NVL(...,'~')` 정규화 — `MERGE ON` 은 NULL 이면 매칭되지 않는다
- 값이 1종인 업무키는 손대지 않음(멱등)

### 검증
| 게이트 | 결과 |
|---|---|
| 사내 회귀 (`minyonglee1`, 메저 14종) | 보이는 컬럼이 같은데 2줄 = **0건** (11 measure 전부) |
| 컴파일 | `STATUS=VALID` · `ALL_ERRORS` 0행 |
| **클라우드 실적용** | ✅ **1줄로 정상 표시 확인 (사용자 확인 2026-09-18)** |

## 7. 범위 밖 (별건)

MF/SF/SP **Cutoff 버전** 조회에서 LOC 단가 행 자체가 0건이 되어 전 measure 의 CURRENCY 가
비는 케이스가 있다(81 `ACEN1063I-D1` / `MF_W_20260825_V001` 실측).
Unit Price 가 표시되지 않으므로 이번 초점(= Unit Price 는 있는데 RTF 만 빈 케이스)과 다르다.
사용자 판단에 따라 이번 범위에서 제외했다.

## 8. 사내 작업본

`_artifacts/_apply_corporate/DMF0082_CURRENCY_20260918/`

| 파일 | 내용 |
|---|---|
| `00_BEFORE_PKG_DMF0082_BODY.sql` | 적용 전 원문 (원복용) |
| `build_and_apply.py` | 2차 폴백(8키) 빌드·적용 |
| `build_and_apply2.py` | 3차 폴백(DIV+SITE+ITEM+DOM_EXP+FCST_TYPE) 빌드·적용 |
| `verify_currency.py` | G1~G4 검증 |
| `_raw/` | 원문 수집·재현·원장 대조 스크립트 |

두 build 스크립트 모두 **적용 직전 `ALL_SOURCE` 재조회(FRESH-GATE)** 후 앵커 유일성을 확인하고,
마커가 이미 있으면 중단한다(중복 적용 방지).
