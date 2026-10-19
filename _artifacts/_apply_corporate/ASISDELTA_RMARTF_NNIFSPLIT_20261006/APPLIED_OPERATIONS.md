# AS-IS 운영 변경분 반영 2건 `[E20261006-ASISDELTA]` — 사내 ZIOUI1 실행 작업 대조표

대상: `asis_delta_20261002` 1단계 SR 우선순위 25(RMA RTF 예외항목 비교 조건) · 29~30(NN Mapping I/F 호출 분리)

| 시각 (2026-10-06) | 계정 | 작업 | 대상 | SQL / 스크립트 |
|---|---|---|---|---|
| 15:30 | SCM_MGR | 적용 전 원문 조회·백업 (조회 전용) | `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` (LAST_DDL 2026-10-01 18:44:18 · VALID) | [00_BACKUP_PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE.sql](00_BACKUP_PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE.sql) |
| 15:30 | SCM_MGR | 적용 전 원문 조회·백업 (조회 전용) | `PR_DM_XIF_ERP_NSD0010_R` (LAST_DDL 2026-09-21 17:32:28 · INVALID) | [00_BACKUP_PR_DM_XIF_ERP_NSD0010_R.sql](00_BACKUP_PR_DM_XIF_ERP_NSD0010_R.sql) |
| 15:35 | SCM_MGR | 적용 전 테스트 ① (원장 DML 전부 ROLLBACK) | `DM_PLN_MKT_FCST` 40 RMA | `python t01_test.py rma` → `_test_rma_before.json` |
| 15:37:26 | SCM_MGR | **프로시저 적용** (FRESH-GATE 통과 · VALID · 오류 0 · 적용본 == DB 원문) | `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` | [01_PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE.sql](01_PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE.sql) (`python build_apply.py apply`) |
| 15:37:35 | SCM_MGR | **프로시저 적용** (FRESH-GATE 통과 · VALID · 오류 0 · 적용본 == DB 원문) | `PR_DM_XIF_ERP_NSD0010_R` | [01_PR_DM_XIF_ERP_NSD0010_R.sql](01_PR_DM_XIF_ERP_NSD0010_R.sql) (〃) |
| 15:38:38 | SCM_MGR | 재컴파일 3건 (`ALTER PROCEDURE … COMPILE` · 원문 무변경 · INVALID → VALID · 오류 0) | `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_BATCH` · `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING` · `PR_DM_CUST_MODEL_MAPPING_IF` | [02_recompile_dependents.py](02_recompile_dependents.py) → `_recompile_result.json` |
| 15:39~15:42 | SCM_MGR | 적용 후 테스트 ①② (원장 DML 전부 ROLLBACK) | 위 2 프로시저 | `python t01_test.py rma` / `nsd` → `_test_rma_after.json` · `_test_nsd_after.json` |
| 15:58 | SCM_MGR | 2차 착수 원문 조회·백업 (조회 전용) | `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` (LAST_DDL 2026-10-06 15:37:26 · VALID) | [03_BACKUP_PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE.sql](03_BACKUP_PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE.sql) |
| 15:59 | SCM_MGR | 2차 적용 전 테스트 (원장 DML 전부 ROLLBACK) | `DM_PLN_MKT_FCST` · `DM_PLN_CFM_MKT_DEMAND_PLAN` 40 RMA | `python t02_test.py` → `_test2_before.json` |
| 16:03:12 | SCM_MGR | **프로시저 적용 2차** — #005~#007 3줄 삽입 (FRESH-GATE 통과 · VALID · 오류 0 · 적용본 == DB 원문 · 의존 4개 VALID) | `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` | [04_PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE.sql](04_PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE.sql) (`python build_apply2.py apply`) |
| 16:04~16:06 | SCM_MGR | 2차 적용 후 테스트 + 1차 테스트 재실행 (원장 DML 전부 ROLLBACK) | 〃 | `python t02_test.py` → `_test2_after.json` · `python t01_test.py rma` |

SPEC · PROC_M · GRANT · 시노님 · 메타 · 테이블 변경 없음. 권한(RL_SCM_DML · RL_SCM_SEL · SCMP_APP EXECUTE)은 적용 후에도 그대로 조회됨.

## 변경 내용

### ① `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` — [E20260812-001054] (2줄)

| 줄 (적용 후) | 내용 |
|---|---|
| L103 | 머리말 이력 1줄 추가 |
| L2200 | `DM_PLN_MKT_FCST` RMA 생성문의 RTF_SYS_RP 쪽 `NOT EXISTS` — `A.MEASURE = B.MEASURE` → `'RTF_SYS_RP' = B.MEASURE` |

- AS-IS 운영 원문 L1745-1746 과 같다 (옛 조건 주석 처리 + 리터럴 비교).
- 같은 SR 의 나머지 3곳(시트 #005~#007)은 **2차(16:03)로 반영했다** — 운영 원문 그대로 옛 조건은 두고 리터럴 비교 1줄씩 추가 (사용자 지시 2026-10-06 "RTF_PR 3곳은 작업 대상"). 운영 원문과 같이 실행 결과는 추가 전과 같다.

| 줄 (2차 적용 후) | 블록 | 추가한 줄 | AS-IS 운영 |
|---|---|---|---|
| L2219 | #005 `DM_PLN_MKT_FCST` RTF_PR 쪽 | `AND 'RTF_PR' = B.MEASURE` | L1783-1784 |
| L2280 | #006 `DM_PLN_CFM_MKT_DEMAND_PLAN` RTF_SYS_RP 쪽 | `AND 'RTF_SYS_RP' = B.MEASURE` | L1874-1875 |
| L2299 | #007 `DM_PLN_CFM_MKT_DEMAND_PLAN` RTF_PR 쪽 | `AND 'RTF_PR' = B.MEASURE` | L1912-1913 |

(1차의 L2200 은 그대로 L2200.)

### ② `PR_DM_XIF_ERP_NSD0010_R` — [E20260701-001086] (머리말 1줄 + 주석 처리 22줄 + 표시 3줄)

- `PR_DM_CUST_MODEL_MAPPING_IF 호출 START` 로그 · `PR_DM_CUST_MODEL_MAPPING_IF('ERP')` 호출 · `호출 END` 로그를 줄 주석(`-- `)으로 막았다. AS-IS 운영 원문 L123-153 의 블록 주석과 같은 범위다 (Oracle 은 블록 주석 중첩이 안 되어 줄 주석 사용).
- 매핑 반영은 `JOB_PR_DM_CUST_MODEL_MAPPING_IF` (매일 11:10 · `PR_DM_CUST_MODEL_MAPPING_IF('ERP')`)가 맡는다 — 사내 DB 에 등록돼 있고 상태는 DISABLED (사내 SCM_MGR JOB 126개 전부 DISABLED).

## 테스트 결과

### ① RMA RTF — 실제 SP 문장을 DB 원문에서 뽑아 실행 (기준일 바인드 2025-08-11 · 40 사업부 · 기준수요 `SCM_FCST` 8행 / 3키)

| # | 상황 | 수정 전 | 수정 후 |
|---|---|---|---|
| A1 | 예외항목 0건 (평상 주) | 생성 대상 8행 | 8행 (같음) |
| A2 | SP 의 예외항목 수집 문장 그대로 실행 (RMA 예외 0건) | 8행 | 8행 (같음) |
| A3 | 한 키에 RTF_SYS_RP 예외 | 8행 (예외 무시) | 4행 (그 키 4행만 제외) |
| A3 | 같은 상황의 RTF_PR 쪽 | 8행 | 8행 (같음 — 무변경) |
| A4 | 예외가 RTF_PR / RTF / RTF_SCP 뿐 | — | 8행 (제외 안 함) |
| A5-a | 원장에 삭제→생성 실행, 예외 0건 | 삭제 16 · 생성 16 | 삭제 16 · 생성 16 · 결과 원장 같음 |
| A5-b | 원장에 삭제→생성 실행, 한 키에 RTF_SYS_RP 예외 | **ORA-00001** (보존된 행을 다시 INSERT) | 오류 없음 · 수정된 4행 감사 컬럼까지 그대로 · 나머지 원장은 A5-a 와 같음 |
| A5-c | 한 키에 RTF_SYS_RP + RTF_PR 예외 | ORA-00001 | **ORA-00001** (RTF_PR 쪽 — 아래 주의) |
| Z | 시험 후 원장 (40 RMA 123행 · 전 컬럼) | 시험 전과 같음 | 시험 전과 같음 |

### ① 2차(#005~#007) — 3줄 추가 전·후 결과 동일성 (적용 전 · 적용 후 각 1회)

- 상황 14가지(예외 없음 / 3개 키 × RTF_SYS_RP · RTF_PR · 둘 다 · RTF+RTF_SCP / 전 키) × 2 테이블 = 28건.
- 28건 모두 **생성 대상 행 집합 동일**, 원장에 삭제→생성 실행한 **결과(오류 여부 · 결과 원장) 동일**.
- 예외 없음 · RTF/RTF_SCP 예외: 두 테이블 모두 오류 없이 삭제 16 · 생성 16.
- 시험 후 원장: `DM_PLN_MKT_FCST` 123행 · `DM_PLN_CFM_MKT_DEMAND_PLAN` 48행 모두 시험 전과 같음.

### ② NN Mapping I/F — 적용 후 실제 호출 (ROLLBACK)

| # | 확인 | 결과 |
|---|---|---|
| N0 | VALID · 오류 0 · 인자 무변경 · 의존 객체에서 `PR_DM_CUST_MODEL_MAPPING_IF` 빠짐 | 통과 |
| N1 | 수신 0건 호출 | `S / SUCCESS` · 로그 5건 (호출 START/END · ERROR 없음) |
| N2 | 수신 1건 호출 (시험 전용 IF_SEQ) | `S / SUCCESS` · I/F 테이블 1행 `TRANSFER_FLAG='N'` · 매핑 마스터 무변경 · ROLLBACK 후 0행 |
| Z | 매핑 마스터 817행 · I/F 테이블 X 19,498 / Y 59,687 · Call Off 품목 3,465,797 | 시험 전과 같음 |

## 미실시·주의

- **`PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` 전체 실행은 하지 않았다.** 본문에 `DBMS_STATS`(암시 COMMIT)가 있어 실행하면 40 사업부 RTF 원장을 통째로 다시 만든다. 바뀐 문장과 짝이 되는 삭제문만 원장에 실행하고 ROLLBACK 했다.
- 사내 원장에는 이번 주(2026-10-05) 이후 40 사업부 RMA 행이 없다. 그래서 ①은 기준일을 과거 주로 준 결과다.
- **A5-c**: 예외항목에 같은 키의 RTF_PR 이 함께 있고 원장에 그 키의 RTF_PR 행이 있으면 RTF_PR 쪽 생성에서 ORA-00001 이 난다. 수정 전에도 나던 오류이고(그때는 RTF_SYS_RP 쪽에서 먼저 발생), AS-IS 운영 원문도 같은 조건이다. `DM_PLN_CFM_MKT_DEMAND_PLAN` 쪽 RMA 생성 2곳도 같다 (2차 테스트에서 실행으로 확인 — 그 키에 RTF_SYS_RP 또는 RTF_PR 예외가 있으면 ORA-00001, 3줄 추가 전·후 동일).
- ② 수정 전 원문은 실행하지 않았다 (실행하면 매핑 반영 프로시저가 실제로 돈다). 수정 전 동작은 원문과 의존 관계로만 확인했다.
- ② 테스트로 로그 테이블 `SCM_SYS_LOG_BATCH` 에 `PR_DM_XIF_ERP_NSD0010_R` 로그 30행이 남았다 (로그 프로시저가 자율 트랜잭션).
- `PR_DM_DNM_EDI_CALLOFF` 는 INVALID 그대로다 (`PR_DM_DNM_EDI_CALLOFF_MKT_FCST` INVALID 에 걸려 있음 — 이번 범위 밖).
- 클라우드 미적용 (이관 패키지 미작성).
- 원복: `python 99_ROLLBACK_apply.py` (현재 DB 원문에서 1차·2차 변경분만 제거 · 원복 결과 == 최초 착수 백업본 확인함).
- `02_변경분_반영현황.xlsx` 시트는 갱신하지 않았다.
