# DMF0049 같은 키 중복 저장 차단 + 중복 데이터 정리 — 클라우드 이관 패키지 (2026-10-28)

마커 `[E20261028-DUPROLLBACK]` · 사내 ZIOUI1 적용 완료(2026-10-28 16:25:13) · 클라우드 미적용

## 무엇이 문제였나
- DMF0049(ETC Sales Reports)에서 같은 세트를 두 번 저장하면 두 번째 저장이 막히지 않고 같은 키 행이 2건씩 생겼다.
  - 클라우드 실측: 버전 R_S_20261008_V004_C, DATA_SEQ 379(10-28 14:58:00)·380(15:02:54), 사용자 k0101
- 경로: DMF0049 저장 끝에서 `PKG_DMF0044.P_DMF0044_MOBILE_REPORT_CREATE` 가 원장 전체 중복을 찾아도
  메시지만 돌려주고 끝남(ROLLBACK 없음) → DMF0049 가 이어서 COMMIT → 중복이 그대로 저장됨.
- AS-IS `DMF0044_MOBILE_REPORT_CREATE` 는 같은 분기에서 `ROLLBACK TRANSACTION` → 저장 전체 취소.
- 부수 영향: 중복이 생긴 뒤의 저장은 ETC 원장에만 반영되고 Sales Report(DMF0044)에는 반영되지 않았다.

## 무엇을 바꾸나
| 파일 | 내용 | 실행 |
|---|---|---|
| `A_DB/00_PRECHECK_CLOUD.sql` | 상태·마커·대상 분기 수(6)·정리 대상 중복·백업 테이블 | 조회 전용 |
| `A_DB/10_APPLY_DUPROLLBACK_PATCH.sql` | MOBILE_REPORT_CREATE 검증 실패 분기 6곳 앞에 `ROLLBACK;` 삽입 | PKG BODY 변경 |
| `A_DB/20_DATA_DEDUP.sql` | 같은 키 중복 행 중 나중 DATA_SEQ 삭제(QTY 같은 행만) · 삭제 전 `BAK_DMF0049_DUP_20261028` 백업 | 데이터 변경 · COMMIT |
| `A_DB/25_REGEN_SALES_REPORT.sql` | 정리한 버전 중 전송 상태(SEND_YN='Y') 목록 + Sales Report 재생성 블록(줄 주석) | 전체 F5 = 조회만 |
| `A_DB/90_VERIFY.sql` | VALID·오류 0 · 마커 6줄 위치 · 남은 중복 · 백업 건수 | 조회 전용 |
| `A_DB/99_ROLLBACK_DUPROLLBACK_PATCH.sql` | ROLLBACK 6줄 제거(원복) | PKG BODY 변경 |
| `A_DB/99_ROLLBACK_DATA.sql` | 백업 행을 원장으로 되돌림 | 데이터 변경 · COMMIT |

검증 실패 분기 6곳: DIVISION_INVALID · VERSION_NO_INVALID · ACTION_TYPE_INVALID_C · ACTION_TYPE_INVALID_T · DEPT_NAME INVALID · DUPLICATION VALIDATION.
로그(`PR_DM_SYS_LOG_BATCH`)는 자율 트랜잭션이라 ROLLBACK 후에도 남는다. 화면 메시지는 그대로다.
FE·BE·메타·권한 무변경, BE 재기동 불필요.

## 실행 순서 (클라우드)
1. `00_PRECHECK_CLOUD` — P1 BODY VALID, P2 = 0, **P3 = 6행** 확인. P4 에서 정리 대상과 QTY_DIFF_ROWS 확인.
2. `10_APPLY_DUPROLLBACK_PATCH` — `APPLIED` 출력 확인 (재실행 시 `SKIP`).
3. `20_DATA_DEDUP` — `DEDUP — 백업 N건 · 삭제 N건` (두 수가 같아야 함, 재실행 시 0건).
4. `90_VERIFY` — V1 VALID·오류 0 / V2 6행 모두 IN / V3 DUP_SAME_QTY_LEFT = 0.
5. `25_REGEN_SALES_REPORT` — R1 에서 SEND_YN='Y' 인 버전은 R2 블록으로 Sales Report 재생성(업무 확인 후).
   - 예상: R_S_20261008_V004_C (클라우드 Q8 실측 SEND_YN='Y').
   - 2024~2025 버전(R_B_20240104_V003 등)이 Y 로 나오면 과거 리포트가 다시 만들어지므로 재생성 여부를 먼저 정할 것.
6. V3 DUP_QTY_DIFF_LEFT > 0 이면 자동 삭제하지 않은 행 — 어느 값이 맞는지 업무 판단 후 개별 처리.

원복: `99_ROLLBACK_DUPROLLBACK_PATCH` → `99_ROLLBACK_DATA`.

## 사내 리허설 (2026-10-28, ZIOUI1)
- FRESH-GATE: 착수(16:06:22) 기준본 = 적용 직전 원문 동일(LAST_DDL 2026-10-27 13:14:01)
- 패치: 99(SKIP) → 10(APPLIED) → 10(SKIP) → 원문 diff = 추가 6줄만 → 99(원복) → **원문 = 착수 기준본 동일** → 99(SKIP) → 10(APPLIED) → 90 PASS
- 동작 실측(같은 세션 선행 UPDATE → MOBILE 중복 검증):
  - 수정 전: 선행 변경 살아남음(`DUPRB_TEST`) → 호출자가 COMMIT 하면 저장됨
  - 수정 후: 선행 변경 ROLLBACK 됨(`<NULL>`) · 버전 SEND_YN·시험값 잔존 0
- 데이터: 20(3건) → 20(0건) → 90(남은 중복 0) → 99_DATA(3건 복원) → 99_DATA(0건) → 20(3건) → 90 PASS
- 결과 출력: `_rehearsal_out/`
- 미실행: 화면 경유 저장(E2E) 및 MOBILE 성공 경로 실행(성공 시 SEND_YN·리포트를 바꾸므로 사내 실데이터에서 실행하지 않음 — 성공 경로 코드는 무변경, diff 로 확인)
