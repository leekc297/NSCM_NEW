# DMF0082_GAP452_20261015 — 사내 ZIOUI1 적용 기록

- 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY — `P_DMF0082_SAVE_MAIN_DATA` 1줄 + `P_PR_DM_PLN_CFM_TO_MKT_FCST` (마커 `[GAP452 2026-10-15]` 15곳)
- 범위: 사용자 결정 2026-10-15 "패키지 안만" (공용 배치 PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 통계 수집 25곳은 범위 밖 — 한계)
- 참고: 요청 문구는 "GAP 425" 였으나 첨부 이미지 번호는 452 — 이미지 내용 기준으로 진행

## 확인 (착수 원문 LAST_DDL 2026-10-15 15:53:50)
- 원장 첫 변경 = SAVE L14479 (RMA → RTF_SYS_RP 재생성 DELETE)
- GAP 기재 "원장 변경 뒤 통계 수집" 3곳은 이미 `[E20260929-DMF0082SAVETXN]` 로 `NULL;` 처리돼 있었음 (L15105/15151/15317)
- 남은 확정 지점(40): SAVE L16006 `COMMIT`(전파 직전) · 전파 PR `TRUNCATE` 9 · `DBMS_STATS` 4 · `COMMIT` 1 · 공용 배치 BALANCE_CREATE(통계 25) · SALES_PLAN(예외 ROLLBACK)
- 전파 PR 예외부 = ROLLBACK + RAISE_APPLICATION_ERROR → 저장 SP WHEN OTHERS 가 실패 반환 (성공 오안내 없음)
- `PR_DM_SYS_LOG_BATCH` = PRAGMA AUTONOMOUS_TRANSACTION (영향 없음)
- 패키지 밖 `P_PR_DM_PLN_CFM_TO_MKT_FCST` 호출처 0 · BE 참조 0 (배치 JOB 은 독립 `PR_DM_PLN_CFM_TO_MKT_FCST`)

## 적용
| 시각 | 작업 | 결과 |
|---|---|---|
| 16:2x | S1·P1·P2·P3 적용(한글 주석판) | VALID · 오류 0 |
| 16:2x | 정상 저장 실측 (40 EATON_01 2027-12-27): I 100 SUCCESS 7.4s · M 0 SUCCESS 1.6s · 원장/전파 반영 확인 · 테스트 행 정리(CFM 1·MKT_FCST 1) | 정상 |
| 16:27:27 | 패키지 원복 안정성을 위해 표지 주석을 ASCII 로 바꿔 재적용 (주석 제외 코드 동일 확인) | VALID |
| **16:30:17** | ⚠ **사고**: 이관 패키지 리허설 중 99_ROLLBACK 의 TRUNCATE 복원 문자열 인용부호 결함(`''TRUNCATE …''`)으로 컴파일 오류 BODY 생성 → 자동 복원 코드가 ORA-24344 예외로 미실행 → **BODY INVALID** | |
| **16:31:27** | 적용본(ASCII)으로 즉시 재생성 → VALID · 오류 0 · 의존 INVALID 0 · 원문 == 적용본 | **INVALID 약 70초** (그 사이 DMF0082 사용 시 오류 가능) |
| 16:3x | 원인 정정: ① 인용부호 ② `CREATE OR REPLACE` 를 BEGIN…EXCEPTION 으로 감싸 상태 판정·복원이 반드시 실행되게 (사내 시험 프로시저 TMP_GAP452_GUARD_TEST 로 복원 동작 실증 후 삭제) — 오늘 패키지 9개 전부 반영 · 18개 블록 문법 검증(원문 무변경) | |
| 16:35 | GAP452 패키지 재생성 · 리허설 전 단계 기대대로 · 99 원복 == 수정 전 · 10 재적용 == 적용본 | VALID |
