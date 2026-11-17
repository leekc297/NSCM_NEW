# SCP0111 [E20261112-YIELDP] 저장 PROC 수율 임시표 적재 — 저장 품목으로 한정

대상 DB: 사내 ZIOUI1 (SCM_MGR) · 작업일 2026-11-12 · 사용자 지시 "SCP0111 의 _H TABLE 전체를 TEMP TABLE 에 넣는 프로세스는 잘못된 프로세스로 보이며 보완대상 · 보완 후 테스트"

## 1. 증상 (실측)
| 시각 | 사실 | 출처 |
|---|---|---|
| 11-12 03:31~03:38 | SCP0111 CheckList 저장 시험 5건이 `PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_PSI` 안에서 끝나지 않음 | v$session(sid 746·860·858·483·299) 09:28·09:36 조회 |
| 09:28 | 2개 세션 = `INSERT INTO GT_SCP0111_YIELD_P … FROM SCM_MST_YIELD_VER_H_V`(sql_id 10u1hwwg9dkfu) 가 `FP_MGR.SCM_YIELD_VER_H` Table Scan 진행 85만/553만 블록 · 3개 세션 = sid 860 의 `SCP_ANL_PSI_INTEGRATION` 행 잠금 대기 | v$session_longops · v$locked_object |
| 09:48 | 그 INSERT: 실행 2회 누적 43,410초 · 처리 0행 · 계획 `TABLE ACCESS FULL FP_MGR.SCM_YIELD_VER_H`(통계 324,178,091행) | v$sql · v$sql_plan |
| 09:37 | 세션 5개 종료(ALTER SYSTEM KILL SESSION) → 잠금 0 · 대기 0 | scratchpad ora_kill.py·ora_kill2.py 출력 |
| 09:48 | `SCP_ANL_PSI_INTEGRATION` 11-12 03:00 이후 수정 행 0 (열린 트랜잭션 롤백 확인) | 조회 |

## 2. 원인
- 저장 PROC 의 'pack, cell 수율 가져오기' 구간(원문 1724~1743줄)이 수율 뷰를 **Division 조건만으로** 임시표에 적재한다.
- AS-IS `SCP0111_SAVE_INTEGRATION_PSI`(MSSQL DEV · modify 2026-09-02 18:22:37) 1263~1275줄도 같은 형태(`where a.division_id = @v_division_id`) — 변환 누락이 아니라 원래 형태다.
- Oracle 에서 이 INSERT 문의 계획은 `SCM_YIELD_VER_H` 전체 읽기(EXPLAIN PLAN 09:53 재현). 같은 SELECT 를 단독으로 돌리면 3.1초(20,979행)지만 INSERT 문 형태에서는 전체 읽기 계획이 잡힌다.
- 이 임시표를 읽는 3곳(ID·IH·ID)은 모두 `ITEM_ID(+) = UPPER(V_ITEM_ID)` 로만 읽는다 → Division 전체 적재는 필요 없다.

## 3. 보완 (1줄 추가)
```sql
 WHERE IA.OPERATION_ID = A.OPERATION_ID
   AND A.DIVISION_ID   = UPPER(V_DIVISION_ID)
   AND A.ITEM_ID       = UPPER(V_ITEM_ID);  -- [E20261112-YIELDP]
```
- 적용 전 실측(09:52 · Division 81 · 품목 6개 + 없는 품목 1개 × 2회): '=' 형태 0.1~0.2초 · 소비 조건 적용 후 행 집합이 `UPPER(A.ITEM_ID) = UPPER(:i)` 형태와 전부 동일.
- EXPLAIN PLAN(INSERT 형태 · 09:53): 현재 = `TABLE ACCESS FULL SCM_YIELD_VER_H` → 보완 = `INDEX UNIQUE SCAN PK_SCM_YIELD_VER_H`. (`UPPER(A.ITEM_ID)` 형태는 `INDEX SKIP SCAN` 322,483행이라 쓰지 않음)

## 4. 적용
| 시각 | 작업 | 결과 |
|---|---|---|
| 09:55:06 | 기준본 재조회(BODY LAST_DDL 2026-11-04 14:00:06 · VALID) → `PKG_SCP0111_BODY.ASIS.sql` 백업 · FRESH-GATE 통과 | 일치 |
| 09:55:07 | `CREATE OR REPLACE PACKAGE BODY PKG_SCP0111`(1줄 추가) | STATUS VALID · 오류 0 · 적용본 == DB 원문 · SCP0111 INVALID 객체 0 |

실행: `python apply_yieldp.py --apply` · 원복: `PKG_SCP0111_BODY.ASIS.sql` 전체 실행.

## 5. 미변경·남은 것
- 같은 PROC 의 1번 구간('3. 수율 (팩)' 원문 1386~1415줄)은 이미 품목 조건(`UPPER(A.ITEM_ID) = UPPER(V_MULTI_TO_PRODUCT)`)이 있다. INSERT 형태 계획은 `INDEX SKIP SCAN`(322,483행 추정) — 끝나지 않는다는 실측은 없음 · 미변경.
- 같은 뷰를 Division 조건만 건 인라인 뷰 4곳(원문 955·1035·2057·2414줄)과 직접 조인 1곳(2836줄)은 실행 시간 미측정 · 미변경.
- 보완 후 저장 시험: SCP0111 CheckList 재실행(09:55 시작) 결과를 아래에 추가한다.
- 클라우드 이관 패키지: 저장 시험 통과 후 생성.

## 6. 보완 후 시험 (SCP0111 CheckList 재실행 2026-11-12 09:55:17 ~ 11:14:02 · 로그 scratchpad/rerun/b04_SCP0111.log)
| 항목 | 결과 | 출처 |
|---|---|---|
| CRUD — 필수 공란 실제 저장 시도 → 필수 채워 실제 저장·재조회·값 보존·정리 | 통과(테스트 22) | 로그 269행 |
| 저장 세부(F1·F6) — 컬럼별 왕복·0 값 저장 | 통과 3.9분(테스트 23) · 저장 1건 10:08:46 → 10:09:19(33초) | 로그 271~273행 |
| 저장 경로(F1 실패·H10 취소·H11 로딩·F2 붙여넣기) | 통과 4.3분(테스트 24) | 로그 275행 |
| 문서 시나리오(실저장 시나리오 포함) | 끝까지 실행(보완 전 = 20.1분 시간 초과) | 로그 326~342행 |
| 시험 뒤 DB 세션 잔여 | 0개(11:12:52 체인 사후 단계 · 11:14:02 재확인) | db_orphan_sessions.py 출력 |
| 감시 기록의 5분 경고·30분 종료 | 0건(10:19 감시 시작 이후) | Doc/verify/_db_watch.log |
| 원장 저장 규칙 | F1 PASS 9 · 미검증 1 / F2 PASS 1 · 미검증 1 / F6 PASS 4 · 미검증 1 | Doc/verify/SCP0111/verify_ledger.csv |

- 미측정: 테스트 25~32(신규행 검증 E3·E4 · 입력 검증 E1·E2·E5 · A8 · A1 · A3 · A5 · H4 · M1) 8개가 `net::ERR_CONNECTION_REFUSED http://localhost:8080` 로 실패 — 그 시각(10:15 전후) 로컬 BE 가 내려가 있었다(BE java 프로세스 생성 10:31:31 · 부모 `gradlew.bat bootRun --offline` 10:31:20 — 내가 띄운 것 아님). 저장 PROC 보완과 무관 · 해당 규칙만 재측정 필요.
- 미측정: 테스트 37 '병합 셀 입력·Delete·원값 복원(H3·F5·D1·F3)' 7.0분 시간 초과(원인 미확인).

## 7. 클라우드 이관 패키지
- `_artifacts/_deploy_packages/SCP0111_CLOUD_DB_MOD_20261112_1115/` (11:15 생성 · cloud_pkg 1.4.1 · 범위 db 수정본 · PACKAGE BODY = 1개 구간 패치 · 사내 리허설 OK · 경고 0)

## 8. 미측정 규칙 재측정 (11:16:03 ~ 11:38:10 `--only` · 11:42 `--skip-e2e` 재판정)
- 재측정 테스트 39개 전부 통과(실패 0 · 접속 거부 0) — '병합 셀 입력·Delete·원값 복원' 20.7초 통과(11:14 실행은 7.0분 초과).
- 원장(11:42): PASS 654 · FAIL 41 · 판정필요 16 · 미검증 232 · 해당없음 859. (09:55 전체 실행 직후 = PASS 611 · FAIL 70 · 미검증 246)
- 대조표 인스턴스 기준 증명됨 47/269 · 조치 필요 11.

