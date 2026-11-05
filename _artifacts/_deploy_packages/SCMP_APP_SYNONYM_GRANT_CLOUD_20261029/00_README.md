# 앱 계정(SCMP_APP) 시노님·권한 보완 — 클라우드 이관 패키지 (2026-10-29)

## 증상 · 원인
- 증상: SCP0020(Tact Time OSP)·SCP0111(Integration PSI) 화면 진입 시 Line 계열 조회조건 콤보가 `ORA-00942: 테이블 또는 뷰가 존재하지 않습니다` 로 실패 → 조회·검증엔진 테스트 중단(SCP0020 17/22 · SCP0111 18/22).
- BE 로그(nscm.log 2026-10-29): `"SCMP_APP"."SCM_MST_LINE_SN"` 36회(00:04:00~00:12:06) · `"SCMP_APP"."SCM_LINE_HIERARCHY_CPS_V_SN"` 55회(00:04:00~01:39:03).
- 원인: 콤보 SQL(SCM_ADM_CMBO_SQL_M `LineByOperation`·`LineByOperationPlantId_SCP_ALL` 등)이 `SCM_MST_LINE_SN`·`SCM_LINE_HIERARCHY_CPS_V_SN` 을 무접두로 참조하는데, 이 시노님이 SCM_MGR 에만 있고 BE 앱 계정 SCMP_APP·PUBLIC 에는 없었다. 또 `FP_MGR.SCM_LINE_HIERARCHY_CPS_V` 의 SELECT 권한이 SCM_MGR 에만 있어 시노님을 만들어도 ORA-00942 가 계속됐다.
- 보완(DB 객체만 · PKG·FE·BE 무변경):
  1. `CREATE OR REPLACE SYNONYM SCMP_APP.SCM_MST_LINE_SN FOR FP_MGR.SCM_LINE_M`
  2. `CREATE OR REPLACE SYNONYM SCMP_APP.SCM_LINE_HIERARCHY_CPS_V_SN FOR FP_MGR.SCM_LINE_HIERARCHY_CPS_V`
  3. `GRANT SELECT ON FP_MGR.SCM_LINE_HIERARCHY_CPS_V TO RL_FP_SEL` (SCMP_APP 가 가진 롤 · `FP_MGR.SCM_LINE_M` 은 RL_FP_SEL 에 SELECT 가 이미 있음)

## 파일 (A_DB, 전체 F5 기준 오류 0 · system(또는 DBA) 계정으로 실행)
| 순서 | 파일 | 성질 |
|---|---|---|
| 1 | `00_PRECHECK_CLOUD.sql` | 읽기 전용 — 대상 객체 존재·현재 시노님·권한·SCMP_APP 롤 확인 |
| 2 | `10_APPLY_SYNONYM_GRANT.sql` | 시노님 2건만(CREATE ANY SYNONYM 계정: SCM_MGR·system). 멱등(이미 있으면 교체) · 비파괴 · 마지막 SELECT 가 권한 상태를 알려 준다 |
| 3 | `20_GRANT_BY_OWNER_OR_DBA.sql` | ★ **FP_MGR(뷰 소유자) 또는 SYSTEM/DBA 로만 실행** — `GRANT SELECT ON FP_MGR.SCM_LINE_HIERARCHY_CPS_V TO RL_FP_SEL`. 2026-10-29 다른 계정으로 돌려 ORA-01031 이 났던 블록을 분리 |
| 4 | `90_VERIFY.sql` | RESULT='PASS' 확인(시노님 2건이 FP_MGR 대상을 가리키고 RL_FP_SEL 에 SELECT 가 있음) |
| 롤백 | `99_ROLLBACK_SYNONYM_GRANT.sql` | 시노님 2건 DROP + REVOKE. 주의: 이 시노님을 다른 화면도 쓰기 시작했다면 롤백 금지 |

## 사내 ZIOUI1 적용 기록 (2026-10-29 · 실행 로그 기준)
- 09:35:03 SCM_MGR 계정: `CREATE OR REPLACE SYNONYM SCMP_APP.SCM_MST_LINE_SN FOR FP_MGR.SCM_LINE_M` · `… SCM_LINE_HIERARCHY_CPS_V_SN FOR FP_MGR.SCM_LINE_HIERARCHY_CPS_V` (syn_fix.py · 이력 `Doc/verify/_synonym_history.csv`)
- 09:42~09:50 `GRANT SELECT ON FP_MGR.SCM_LINE_HIERARCHY_CPS_V TO RL_FP_SEL` 반영 확인(DBA_TAB_PRIVS 실측 — SCM_MGR 에는 GRANT OPTION 이 없어 system 계정 전환 뒤 확인)
- 재검사(syn_check.py): SCP0020 32건 OK · SCP0111 전부 OK → SCP0020 CheckList v4(10:08) 는 E2E 22/22 정상 실행, DB-SYN 행에 '시노님 자동 보완' 이력 표기
- 참고: SCMP_APP 롤 = RL_FP_SEL, RL_INF_SEL, RL_DIC, RL_SES, RL_SYN, RL_SCM_DML

## 클라우드 적용
00 → 10(시노님, SCM_MGR/system) → 20(GRANT, ★FP_MGR 또는 SYSTEM) → 90. 10 의 마지막 SELECT 가 'SELECT 권한 있음' 이면 20 은 생략. 클라우드 FP_MGR 객체 이름이 다르면(예 SCM_LINE_M 이 없음) 00 결과를 보고 10 의 FOR 대상을 맞춘 뒤 실행한다. 클라우드 SCMP_APP 에 RL_FP_SEL 롤이 없으면 10 의 GRANT 대상을 `SCMP_APP` 으로 바꾼다.
