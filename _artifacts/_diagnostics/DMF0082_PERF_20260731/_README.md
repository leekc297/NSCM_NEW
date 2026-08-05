# DMF0082 조회 성능 — 사내 10초 vs 클라우드 100초 진단 (2026-07-31)

> 조회 경로: `SCM_ADM_MNU_BTN_MPG_M[DMF0082/FcstNPrice/SEARCH]` → **`PKG_DMF0082.P_DMF0082_GET_MAIN_DATA`**
> 사내(10초) 실측은 제가 직접 떴고, 클라우드(100초)는 접속 경로가 없어 **동일 항목 진단 스크립트**로 대조합니다.

---

## 1. 먼저 배제된 것 (측정으로 확인)

| 후보 | 판정 | 근거 |
|---|---|---|
| **DB 버전 차이** | ⛔ 배제 | 양쪽 모두 **Oracle 26ai (23.26.1.0.0)** — 사용자 확인 |
| **파티셔닝 차이** | ⛔ 배제 | 사내 대상 테이블 **전부 비파티션**. `_PART` 는 인덱스 이름일 뿐 |
| **SQL Profile / Plan Baseline** | ⛔ 배제 | 사내 **0건** — 사내 성능이 플랜 고정 덕이 아님 |
| **이번 DB 작업(82편입·센티널·TRUNCATE→DELETE)** | ⛔ 무관 | 클라우드 **미적용** 상태에서 이미 100초 |

---

## 2. ⭐ 가장 유력한 원인 — `SCM_MST_SITE_ITEM` 튜닝 인덱스가 클라우드에 없음

사내에서 **2026-07-01 ~ 07-12 튜닝 캠페인**의 흔적이 확인됩니다.

| 증거 | 내용 |
|---|---|
| 인덱스 생성일 | `SCM_MST_SITE_ITEM` 의 인덱스 **8본이 전부 2026-07-01 생성** (PK 포함 = 테이블 재구축 정황) |
| 그중 함수기반 | **`FBI_SCM_MST_SITE_ITEM_OWNER_TOKEN1`** = `REGEXP_SUBSTR("OWNER",'[^,]+',1,1)` |
| SP 쪽 짝 | `PKG_DMF0082` **L726** `REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL)` + 주석 **`[PERF 2026-07-12] IN->JOIN`** |
| 다른 화면도 동일 패턴 | `REGEXP_SUBSTR(...OWNER...)` 사용: DMF0003 8줄 / DMF0020 6 / DMF0021 4 / DMF0035 3 / **DMF0082 2** / DMF0040 1 / DMF0053 1 |

**즉 SP 재작성과 인덱스가 세트로 만들어졌는데, 이관 패키지는 PKG/SP 만 옮깁니다.** 인덱스는 어떤 이관 패키지에도 들어간 적이 없으므로 클라우드엔 없을 가능성이 큽니다.

인덱스 없이 `REGEXP_SUBSTR(OWNER, ...)` 조인을 돌리면 114,235행에 대해 **행별 정규식 + Full Scan** 이 되고, 이게 상위 조인 루프 안에 있으면 10배는 쉽게 납니다. 선례가 있습니다 — **DMF0005 300초 → 3.6초**(행별 스칼라 함수 제거 + `UPPER()` FBI, 메모리 `feedback_dmf0005_perf_scalar_fn_fbi_and_view_dedup`).

### 사내 인덱스 기준 (대조표)

| 테이블 | 인덱스 수 | UNUSABLE |
|---|---:|---:|
| **SCM_MST_SITE_ITEM** | **8** | 0 |
| DM_PLN_MKT_FCST_C | 6 | 5 |
| DM_PLN_MKT_FCST_RESULT_C | 5 | 0 |
| DM_PLN_MKT_FCST | 4 | 0 |
| DM_PLN_SALES_PLAN_RESULT_C | 3 | 0 |
| SCM_MST_FUTURE_PRICE_C | 3 | 2 |
| DM_PLN_SALES_PLAN_RESULT / SCM_MST_FUTURE_PRICE | 2 | 0 |
| DM_PLN_CFM_* 4종 | 각 1 | 0 |

> 사내에도 UNUSABLE 7본이 있으나 **사내가 10초**이므로 주 원인은 아닙니다(개선 여지로는 남습니다).

---

## 3. 2순위 — 통계 / 히스토그램

사내는 통계가 최신이고 히스토그램까지 갖춰져 있습니다.

| 테이블 | NUM_ROWS | LAST_ANALYZED |
|---|---:|---|
| DM_PLN_MKT_FCST_C | 7,536,901 | 2026-07-20 |
| DM_PLN_SALES_PLAN_RESULT_C | 3,454,721 | 2026-07-20 |
| DM_PLN_CFM_MKT_DEMAND_PLAN_C | 3,274,247 | 2026-07-20 |
| SCM_MST_FUTURE_PRICE_C | 3,086,168 | 2026-07-20 |
| SCM_MST_FUTURE_PRICE | 1,732,210 | 2026-07-27 |
| DM_PLN_CFM_SELLING_PRICE | 1,651,396 | 2026-07-24 |
| DM_PLN_MKT_FCST | 1,193,521 | 2026-07-30 |
| DM_PLN_MKT_FCST_RESULT_C | 788,367 | 2026-07-27 |
| **SCM_MST_SITE_ITEM** | **114,235** | 2026-07-30 |

히스토그램(사내): `DIVISION_ID` = **FREQUENCY / 8 buckets**(8 distinct, 편중) · `ITEM_ID` = HYBRID / 254.
클라우드에 히스토그램이 없으면 `DIVISION_ID` 필터 선택도를 균등분포로 오추정해 조인 방식을 잘못 고릅니다.

---

## 4. 3순위 — 병렬·메모리 자원

`PKG_DMF0082` 는 `INSERT /*+ APPEND PARALLEL(4) */ INTO GT_DMF0082_MF_SP` 를 사용합니다.

사내 값: `cpu_count 8` / `parallel_max_servers 160` / `parallel_servers_target 64` / `parallel_degree_policy MANUAL` / `parallel_force_local FALSE` / `pga_aggregate_target 2GB` / `sga_target 0` / `db_block_size 8192`.

클라우드 CPU가 적거나 PGA가 작으면 이 단계가 직접 느려지고, 해시조인·정렬이 TEMP로 유출됩니다.

---

## 5. 진행 절차

| Step | 파일 | 계정 | 내용 |
|---:|---|---|---|
| 1 | `01_PERF_DIAG.sql` | SCM_MGR | **클라우드에서 실행** (READ-ONLY). 조회를 1회 돌린 **직후** 실행해야 [6] V$SQL이 잡힙니다 |
| 2 | — | — | 결과 `DMF0082_PERF_DIAG_OUTPUT.txt` 회신 |
| 3 | `02_FIX_MISSING_INDEX.sql` | SCM_MGR | [1][2]에서 인덱스 결손 확인 시. 사내 DDL **25본** + UNUSABLE 재생성. 멱등(-955/-1408 skip) |
| 4 | `03_FIX_STATS.sql` | SCM_MGR | [3][4]에서 통계·히스토그램 부재 확인 시 |
| 5 | — | — | 조회 재측정 + [6] `PLAN_HASH_VALUE` 변화 확인 |

⚠ 3·4는 **진단 결과를 보고** 실행하십시오. 대형 테이블 인덱스 생성·통계 수집은 시간과 TEMP를 소모하므로 업무 시간 외를 권장합니다.

---

## 6. 판정 기준

| 진단 결과 | 원인 | 조치 |
|---|---|---|
| `SCM_MST_SITE_ITEM` 인덱스 < 8본 | **인덱스 결손** (1순위) | `02_FIX_MISSING_INDEX.sql` |
| `NUM_ROWS` NULL / `LAST_ANALYZED` 없음 | 통계 미수집 | `03_FIX_STATS.sql` |
| `HISTOGRAM=NONE` | 히스토그램 부재 | `03_FIX_STATS.sql` |
| 실행계획에 `TABLE ACCESS FULL SCM_MST_SITE_ITEM` | 인덱스 결손 **확정** | `02_FIX_MISSING_INDEX.sql` |
| 같은 SQL_ID, **다른** PLAN_HASH_VALUE | 계획 차이 → 통계/파라미터 | 03 → 재측정 |
| 같은 SQL_ID, **같은** PLAN_HASH_VALUE 인데 느림 | 자원(CPU/PGA/IO) 또는 데이터량 | §4 파라미터 대조 |
| `PKG_DMF0082` LAST_DDL 이 2026-07-12 이전 | **BODY 구판** — IN→JOIN 튜닝 누락 | 이관 패키지 `02_DB_SP/14_PKG_DMF0082_BODY.sql` 적용 |

---

## 7. 한계 (명시)

클라우드 DB 접속 경로가 없어 **제가 직접 측정하지 못했습니다.** 위 1순위 가설은 사내 측 정황 증거(인덱스 생성일 + SP 튜닝 주석 + 동일 시기)로 세운 것이며, **확정은 `01_PERF_DIAG.sql` [1] 결과로만** 가능합니다. 결과를 주시면 원인을 확정하고 조치까지 마무리하겠습니다.
