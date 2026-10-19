# DMF0082 조회 속도개선 (클라우드 이관 · 누적본)

> 마커 `[E20260930-DMF0082QRYPERF]` — `P_DMF0082_GET_MAIN_DATA` (화면 [Search] · `FcstNPrice/SEARCH/call-proc`)

| 항목 | 값 |
|---|---|
| 패키지 | `DMF0082_QRYPERF_CLOUD_20260930` |
| 범위 | **DB 전용** — `PKG_DMF0082` SPEC · BODY + `SCM_ADM_PROC_M` 18행. FE / BE / API_M / BTN / MSG·LBL·MNU **없음** |
| ⚠ 누적본 | BODY 전체본이라 **09-29 저장 회차(SAVETXN·SAVEPERF)를 포함**한다. [`DMF0082_SAVE_TXN_CLOUD_20260929`](../DMF0082_SAVE_TXN_CLOUD_20260929/00_README.md) / [`DMF0082_SAVE_PERF_CLOUD_20260930`](../DMF0082_SAVE_PERF_CLOUD_20260930/00_README.md) 는 **적용하지 말고 이 패키지만** 적용 (이미 적용했다면 이 패키지의 10·20 은 SKIP 판정) |
| 사내 적용 | **완료 · VALID · 오류 0** (ZIOUI1 / SCM_MGR, 2026-09-30 08:04:37) · 사내 PRECHECK·VERIFY 읽기전용 실행 V1~V7 PASS |
| 클라우드 | **미적용** · ⚠ QA·DEV 2곳 모두 |
| 원문 | 사내 USER_SOURCE 재추출 2026-09-30 08:12 (`SOURCE-FRESH` · 24h 초과 시 `python _build.py` 재빌드 — FRESH-GATE 내장) |
| BE 재기동 | **불요** (PKG_DMF0082 무상태) |

## 1. 무엇이 바뀌나 (조회 — GET_MAIN_DATA 만)

| # | 병목 (사내 10046 트레이스 실측) | 조치 |
|---|---|---|
| 1 | div82: `SCM_MST_FUTURE_PRICE`(1.4GB) **풀스캔 2회** — 옵티마이저가 기존 인덱스를 두고 풀스캔 선택. 1회 73~83초 | 두 문장에 `INDEX(A IDX02_SCM_MST_FUTURE_PRICE)` — 동일 조건 12초 → 0.2초 |
| 2 | SP 안 GTT 통계수집 `DBMS_STATS.GATHER_TABLE_STATS` **13건** — 수집 2~3초 + 커서 무효화로 매 호출 하드파싱 약 300건 | 13건 제거(NULL). 추정은 SP 첫머리의 `optimizer_dynamic_sampling=2`(기존) 가 담당 |
| 3 | div82 후행 UPDATE 2건 (VMI_STD_DIO 상관 스칼라 서브쿼리 / EDIT_FLAG 전행) | MF_SP INSERT 시점에 흡수 (선집계 LEFT JOIN · CASE) — 등가 |
| 4 | 중복제거 안전망 DELETE — 11만 행 60컬럼 윈도정렬 후 0행 삭제 | 중복 존재 시에만 원 DELETE 실행 |

**결과 동등성** (사내, 원본 vs 개선 — 6개 커서 전 행 정렬 SHA-256 · 행 순서까지)
- Current 전체 조회 40/81/82 PASS
- 시나리오 매트릭스 34건 FAIL 0 — Cutoff MF_W/SP_W/SF_W · Current+MF_W 복수 · Sales Site 단일 · Item 단일 · qtyYn=Y · 기간 8월 시작
- ⚠ 원본도 0행이라 실증 안 된 축: qtyYn=Y 전 조합, 81/82 `MF_W_20260825` (둘 다 개선 전후 동일 — 기존 동작)

**속도 (사내, 화면과 같은 HTTP 경로, userGroup=ADMIN, 기간 당월~+6개월)**

| Division | 적용 전 | 적용 후 |
|---|---:|---:|
| 40 | 8.6~10.4s | 4.6~5.1s |
| 81 | 8.8~9.5s | 5.5~5.7s |
| 82 | 237~246s | 5.8~7.2s |

## 2. 작업 ↔ 파일 대조표 (적용 순서 · SCM_MGR 접속)

1. [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) — READ-ONLY 선판정 (아래 판정표)
2. [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) — 클라우드 현 원문 → `BAK_SRC_DMF0082_QRYPERF`, PROC_M → `BAK_PROCM_DMF0082_QRYPERF` (비파괴 CTAS · 멱등)
3. [A_DB/10_PKG_DMF0082_SPEC.sql](A_DB/10_PKG_DMF0082_SPEC.sql) — SPEC 전체 (SAVE IN CLOB). **[H1] AFTER 면 SKIP**
4. [A_DB/11_PKG_DMF0082_BODY.sql](A_DB/11_PKG_DMF0082_BODY.sql) — BODY 전체 (905,951B · 첫 줄 `CREATE OR REPLACE PACKAGE BODY SCM_MGR."PKG_DMF0082"` ~ 끝 `/` + `SHOW ERRORS`). **3 과 함께** (클라우드 SPEC 이 VARCHAR2 면 BODY 단독 컴파일 불가)
5. [A_DB/20_SCM_ADM_PROC_M.sql](A_DB/20_SCM_ADM_PROC_M.sql) — PROC_M 18행 MERGE (SAVE IN 17 CLOB) · 멱등. **3·4 이후**
6. [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) — V1 VALID·ERR 0 / V2 지문 / V3·V4 CLOB 17 / V5 저장 원자성 / **V7 QRYPERF 마커 + GET_MAIN_DATA 활성 GATHER 0** / V6 GRANT → 전부 PASS
7. (선택) [A_DB/91_SMOKE_BIG_PAYLOAD.sql](A_DB/91_SMOKE_BIG_PAYLOAD.sql) — 저장 32K 초과 수용 스모크 (데이터 무변경)

롤백 (평소 실행 안 함)
- [A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql) — 2번 백업으로 **클라우드 고유 상태**(PROC_M → SPEC → BODY) 복원 (권장)
- [A_DB/99_ROLLBACK_PKG_DMF0082_BODY.sql](A_DB/99_ROLLBACK_PKG_DMF0082_BODY.sql) — 조회 속도개선만 되돌림(= 사내 09-29 SAVETXN+SAVEPERF 상태 BODY · CLOB SPEC 전제)

### PRECHECK 판정표

| 구획 | 기대 | 다르면 |
|---|---|---|
| `[A]` 의존 객체 136종 부재 | 0행 | **중단** — 부재 객체 선이관 |
| `[L]` GTT 68본 통계 잠금 | 0행 | **중단** — 제시된 `UNLOCK_TABLE_STATS` 후 진행 |
| `[H1]` SPEC 지문 | `BEFORE` → 3 적용 / `AFTER` → SKIP | `⚠ UNKNOWN` → **중단**, 클라우드 SPEC diff |
| `[H2]` BODY 지문 | `AFTER` 외 라벨 → 4 적용 / `AFTER` → SKIP | `⚠ UNKNOWN` → **중단**, 클라우드 고유 변경 가능 |
| `[H3]` 마커 | QRYPERF 0 (적용 후 BODY 22) | — |
| `[I]` `IDX02_SCM_MST_FUTURE_PRICE` | 1행 PASS | 0행/⚠ → 적용은 가능(힌트는 무시될 뿐 오류 없음) 그러나 **82 조회 풀스캔 잔존** — 인덱스 이관 별도 결정 |
| `[H4]`·`[M]` | 적용 전 VARCHAR2/VARCHAR 17 (SAVETXN 미적용 클라우드) | 이미 CLOB 17 이면 SAVETXN 선적용 상태 — 10·20 은 SKIP/멱등 |

## 3. 클라우드 유의

- **통계수집 제거는 동적 샘플링에 의존**한다. 클라우드 시스템값 `optimizer_dynamic_sampling=0`(07-31 실측) 이지만 GET_MAIN_DATA 첫머리 `ALTER SESSION ... = 2`(기존 코드)가 세션에서 보정한다 — 이 줄이 BODY 에 있는지 V7 과 별도로 확인할 필요는 없음(동일 BODY).
- 클라우드는 데이터가 사내보다 크다(FUTURE_PRICE_C 22배 등, 07-31 실측) — 적용 후 화면 Search 로 40/81/82 체감 확인 후 결과 공유 요망.
- 이번 회차에서 만든 인덱스·파라미터 **없음** (IDX02 는 기존 인덱스).
