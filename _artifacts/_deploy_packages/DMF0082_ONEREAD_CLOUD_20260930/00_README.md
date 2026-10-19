# DMF0082 81/82 조회 타임아웃 해소 — 판가 원장 1회 읽기 + IDX02 힌트 철회 (클라우드 이관)

> 마커 `[E20260930-DMF0082ONEREAD]` — `P_DMF0082_GET_MAIN_DATA` (화면 [Search] · Division 81/82 · Current)

| 항목 | 값 |
|---|---|
| 범위 | **DB 전용** — `PKG_DMF0082` BODY 1본. SPEC·PROC_M·FE·BE·메타 변경 없음 · **힌트 추가 0** |
| 전제 | 클라우드 BODY = [`DMF0082_81SALESPLAN_CLOUD_20260930`](../DMF0082_81SALESPLAN_CLOUD_20260930/00_README.md) 적용본 (`16276/836956`) 또는 그 위에 타 작업자(AJS) 09-30 수정이 반영된 상태 (`16293/837608`) · 공용 SP 81SP 적용본 (`886/59771`) |
| 사내 적용 | **완료 · VALID · 오류 0** (ZIOUI1, 2026-09-30 15:48:07) — [`_apply_corporate/DMF0082_ONEREAD_20260930`](../../_apply_corporate/DMF0082_ONEREAD_20260930/apply_oneread.py) |
| 클라우드 | **미적용** · ⚠ **QA · DEV 2곳 모두** |
| BE 재기동 | 불요 |

## 1. 원인 (클라우드 C07 실측 2026-09-30 15:15)

- 81/82 조회 타임아웃 2건: SP 1,009초 / 863초 중 `3d2xnx839ksnt`(81/82 최신 판가 키 적재) 1,000초 / 852초 — **99%**. CPU 990초 · 잠금·I/O 대기 0 · 1회 버퍼읽기 4,100만.
- 계획: GTT `TEMP_SITE_ITEM` 1행 추정 → NESTED LOOPS → 행마다 `IDX02_SCM_MST_FUTURE_PRICE`(`DIVISION_ID, YYYYMMDD 범위, …`) 날짜범위 전체 재스캔.
- 이 인덱스를 강제한 힌트 `INDEX(A IDX02_SCM_MST_FUTURE_PRICE)` 는 09-30 QRYPERF 에서 1~4순위 검토 없이 넣은 것이었다(사내 82 풀스캔 회피 목적). 사내에서도 캐시 상태에 따라 한 번에 수백 초 랜덤읽기로 무너졌다.
- 구조: 81/82 는 판가 원장 `SCM_MST_FUTURE_PRICE`(1.4GB)를 **두 번** 읽었다 — ① 키별 최신 수정일자·수정자를 GTT 로 적재 ② 판가 행을 읽으며 ①을 다시 조인. ①의 소비처는 ② 한 곳뿐.

## 2. 무엇이 바뀌나 (#129 순서 — 1-b 소비집합/중복읽기 제거)

| # | 변경 | 등가 근거 |
|---|---|---|
| ① | 81/82 `T_LAST_DATA_SETUP_PRICE` 적재 문장 비활성(줄 단위 `--`, `NULL;`) — **타임아웃 문장 제거** | 소비처가 ② 한 곳뿐 (40 분기·Cutoff `_C` 분기 무변경) |
| ② | 판가 INSERT 안에서 최신 수정일자·수정자를 `MAX(CASE WHEN 날짜 BETWEEN 조회From AND 조회To …) OVER (PARTITION BY 키 8개)` 로 계산, 출력 날짜범위는 바깥 WHERE(구 조건 그대로) | 조인조건(메저·FCST_TYPE·품목4키)이 모두 파티션 키의 함수 → 한 키의 행은 모두 남거나 모두 빠짐 · 키 8개는 원장 PK 컬럼(NOT NULL) |
| ③ | IDX02 힌트 2곳 철회 (①과 함께 제거 + ② 에서 제거) — **사용자 지시** | 힌트는 결과에 영향 없음 |

판가 원장 읽기 2회 → 1회. 기존 문장은 삭제하지 않고 주석으로 보존.

⚠ **검증 범위 (정직 기재):** 적용 전 기준선 채취가 구 문장(IDX02 경로) 자체에 막혀 1,000초를 넘겨, 사용자 결정으로 **기준선 없이 선적용**했다. 결과 동등성(전 행 SHA) 비교는 **미실시** — 등가는 위 논리 근거 + 사내 적용 후 스모크(아래)로만 확인됨. 필요 시 추가 검증 예정.

## 3. 작업 ↔ 파일 대조표 (SCM_MGR · QA → DEV 각각)

1. [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) — READ-ONLY. `[H]` 2행: BODY **`적용`**(또는 SKIP) · 공용 SP **`PASS`** / `[U]` 3행 PASS. `⚠ 중단` 이면 결과 회신
2. [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) — 현 BODY → `BAK_SRC_DMF0082_ONEREAD` (비파괴 · 멱등)
3. [A_DB/11_PKG_DMF0082_BODY.sql](A_DB/11_PKG_DMF0082_BODY.sql) — BODY 전체본 (`SHOW ERRORS` 0)
4. [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) — V1 VALID·오류 0 / V2 지문 `16375/842152`·마커 3·활성 IDX02 0 / V3 GRANT / V4 `3d2xnx839ksnt` 실행 수 (적용 후 조회해도 늘지 않으면 정상)
5. 화면: 81 · 82 Search → 타임아웃 없이 조회되는지 확인. 필요 시 [C07_TIMEOUT_DIAG.sql](../../_diagnostics/DMF0082_CLOUD_PERFCHK_20260930/C07_TIMEOUT_DIAG.sql) 재실행

롤백 (평소 실행 안 함): [A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql)

## 4. 유의

- **타 작업자 수정 동봉:** 사내 기준본에 AJS 09-30 15:46 수정(사용자 테이블 `TB_FX_USER` → `SCM_ADM_USER_M`, L7824 타임존 조회 · L9325 부서 조회 — 이번 조회 수정과 다른 프로시저)이 들어 있어 BODY 전체본에 함께 실린다. `[U]` 는 그 참조 컬럼 존재 확인.
- **남은 힌트 (사용자 결정 대기):** 09-30 CLOUDPERF 에서 넣은 힌트 2곳(`2nysu9tbng9v4` L1943 · `7mrzdbpupw3b9` L1229)은 이번 범위 밖 — 근본원인 재검토 후 철회 여부 결정 예정.
- 82 판가 원장 접근은 이제 옵티마이저 판단(풀스캔 가능). 클라우드(Exadata STORAGE FULL)에서의 소요는 적용 후 실측 필요.
