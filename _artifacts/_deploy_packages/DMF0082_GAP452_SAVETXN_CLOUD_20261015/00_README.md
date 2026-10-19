# DMF0082_GAP452_SAVETXN_CLOUD_20261015 — 저장 도중 확정(반쪽 저장) 축소 (클라우드 패치, DB 만)

- 마커: `[GAP452 2026-10-15]` 15곳 · 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_SAVE_MAIN_DATA` 1줄 + `P_PR_DM_PLN_CFM_TO_MKT_FCST`
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료 · 리허설 재적용(16:35, 사내 적용본과 원문 전체 일치) — `_artifacts/_apply_corporate/DMF0082_GAP452_20261015/APPLIED_OPERATIONS.md`
- **FE 무변경.** 오늘 다른 DMF0082 패키지와 서로 독립.

## 무엇이 바뀌나 (사용자 결정 2026-10-15 "패키지 안만")
DMF0082(40) 저장 도중 오류가 나면 앞부분만 반영된 채 남던 문제를 줄인다. Oracle 에서 `TRUNCATE`(DDL)·`DBMS_STATS`·`COMMIT` 은 그때까지의 변경을 확정한다.
| # | 위치 | 변경 |
|---|---|---|
| S1 | 저장 SP 40 경로, 전파 프로시저 호출 직전 | `COMMIT` 제거 (확정 = 저장 SP 끝 1곳) |
| P1 | 전파 프로시저 GTT 초기화 9개(시작 4 · 끝 5) | `TRUNCATE` → `DELETE` |
| P2 | 전파 프로시저 통계 수집 4개 | 제거 (저장 SP 세션 `optimizer_dynamic_sampling=2` 가 대체) |
| P3 | 전파 프로시저 내부 `COMMIT` | 제거 (예외 시 `ROLLBACK` + 재발생은 유지) |
- 결과: 원장 첫 변경(RMA→RTF_SYS_RP 재생성) 이후 ~ 전파의 `DM_PLN_MKT_FCST`·`SCM_MST_FUTURE_PRICE` 반영까지 오류가 나면 **저장 전체가 되돌려진다**.
- ⚠ **한계(사용자 결정으로 범위 밖)**: 전파 안에서 부르는 공용 배치 `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE`(통계 수집 25곳 — 배치 JOB 2개·객체 4개 공유)는 무변경이다. 그 호출 이후 오류는 종전처럼 앞부분이 확정된다. 81 경로도 무변경.
- 원장 · 조회 · 메타 · FE · 권한 · GTT 정의 무변경. **BE 재기동 불필요.** 패키지 밖에서 전파 프로시저를 부르는 곳 0건(00 L3 확인 — 배치 JOB 은 별도 독립 프로시저 `PR_DM_PLN_CFM_TO_MKT_FCST` 사용).

## 사내 검증
- 원장 첫 변경 이후 BALANCE 호출 전까지 활성 `COMMIT`/`TRUNCATE`/`DBMS_STATS` **0건** (원문 정적 검사) · 로그 프로시저 `PR_DM_SYS_LOG_BATCH` 는 자율 트랜잭션이라 영향 없음.
- 정상 저장 경로 실측(40 EATON_01 2027-12-27, 원장에 없는 키): 100 저장 SUCCESS 7.4초 → 원장·전파(DM_PLN_MKT_FCST) 반영 / 0 저장 SUCCESS 1.6초 → QTY 0 반영 / 테스트 행 정리.
- 전파 단계 오류를 일부러 일으키는 시험은 하지 않았다(운영 원장에 오류 유발 수단이 없음) — 확정 지점 제거는 원문 정적 검사로 확인.
- 리허설: 90 → 99 → 00 → 10 → 10(SKIP) → 90 → 99 → 99(SKIP) → 10 전 단계 기대대로 · **99 원복 == 수정 전 원문 · 10 재적용 == 사내 적용본**.

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 4줄 PASS(1·9·4·1) · L2 마커 0 · L3 외부 호출 0 PASS · L4 0행 | L1·L3 FAIL이면 **10 실행 금지**, 결과 회신 |
| 2 | `A_DB/10_APPLY_GAP452_PATCH.sql` | `APPLIED — PKG_DMF0082 BODY VALID · 마커 15곳` | `중단 — …`이면 원문 무변경. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 15 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 잔존 0 ×3 PASS | 회신 |
| 4 | 화면: 40 정상 저장 | 저장·전파 정상 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP452_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 패치 방식
- 표지는 모두 ASCII 다. 적용은 정확 문자열(S1·P3)과 정규식(P1·P2) 치환, 원복은 그 역치환이다. 각 대상 건수가 기대와 다르면 원문을 바꾸지 않고 중단한다.
- 컴파일 실패 자동 복원: `CREATE OR REPLACE` 를 `BEGIN … EXCEPTION WHEN OTHERS THEN NULL; END;` 로 감싸고 직후 STATUS/USER_ERRORS 로 판정해 원문을 되넣는다
  (2026-10-15 리허설에서 감싸지 않은 형태는 ORA-24344 예외로 복원 코드에 도달하지 못함을 확인 → 정정. 사내 시험 프로시저로 복원 동작 실증).

## 파일
- `build_package.py` — 생성기(FRESH-GATE · 시뮬레이터 포함).
- `run_rehearsal.py` · `_rehearsal_out/` — 사내 리허설 실행기와 결과.
- `_md5_corporate_applied.txt` — 생성 시점 사내 적용본·수정 전 md5.
