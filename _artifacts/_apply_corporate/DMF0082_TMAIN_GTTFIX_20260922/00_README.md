# DMF0082 TMAINFIX — P_PR_DM_PLN_CFM_TO_MKT_FCST 값 미전달 정정 (2026-09-22, 사내 ZIOUI1 적용 완료)

## 결함
- `P_DMF0082_SAVE_MAIN_DATA` 는 저장 행을 `GT_PRDM1_T_MAIN` 에 적재하나, 호출되는 `P_PR_DM_PLN_CFM_TO_MKT_FCST` 는
  `GT_PRDM_T_MAIN`(무 '1') 을 읽음. DB 전체에서 `GT_PRDM_T_MAIN` 적재 객체 **0건** → 40 사업부 CFM→DM_PLN_MKT_FCST /
  SCM_MST_FUTURE_PRICE 전파가 **항상 no-op** (BALANCE 재생성·SALES_PLAN_AMT 재계산도 미실행).
- 추가 발견: PR 의 VMI 메저 리터럴 `'VMI_IN_REQ'` — SAVE·원장 저장값은 `'VMI_In_Req'` (DM_PLN_MKT_FCST 40 = 18,619건,
  대문자 0건). AS-IS MSSQL 은 대소문자 무시 collation 이라 매칭됐으나 Oracle 은 불일치 → GTT 만 바꾸면 VMI 행은 계속 누락.

## 조치 (마커 `[E20260922-TMAINFIX]`)
| # | 대상 | 변경 | 파일 |
|---|---|---|---|
| 1 | PKG_DMF0082 BODY / P_PR_DM_PLN_CFM_TO_MKT_FCST | `GT_PRDM_T_MAIN`→`GT_PRDM1_T_MAIN` 5곳 (SELECT 4 + TRUNCATE 1) | 01_PKG_DMF0082_BODY.sql |
| 2 | 同 | `'VMI_IN_REQ'`→`'VMI_In_Req'` 4곳 (TEMP 적재 / DM_PLN_MKT_FCST DELETE / SEND_TARGET / RESULTS) | 01_PKG_DMF0082_BODY.sql |
| 3 | 同 / P_DMF0082_SAVE_MAIN_DATA 호출부 주석 | "잠재 이슈 미수정" 주석 → 해소 주석 | 01_PKG_DMF0082_BODY.sql |
| 4 | standalone `SCM_MGR.PR_DM_PLN_CFM_TO_MKT_FCST` + `SCMP_APP` 시노님 | DROP (2026-09-15 UIPKG 로 PKG 취합 완료본) | 02_DROP_STANDALONE_PR.sql |

- `_new_PKG_BODY.sql` / `_new_PR.sql` = 작업본(참고). `_new_PR.sql` 은 DROP 으로 미적용.
- 백업: `00_backup/BACKUP_PKG_DMF0082_BODY_pre_tmainfix_20260922.sql`, `00_backup/BACKUP_PR_DM_PLN_CFM_TO_MKT_FCST_pre_tmainfix_20260922.sql`
  (FRESH-GATE: 적용 직전 DB 원문 = 백업 EQUAL, BODY LAST_DDL 2026-09-21 18:19:20 불변 확인)

## standalone DROP 사전 근거 (실측)
- ALL_DEPENDENCIES 의존자 0 / ALL_SOURCE 참조 = BALANCE_CREATE L299 주석 1건뿐 / SCHEDULER JOB 0
  (JOB 3종은 `PR_DM_PLN_CFM_TO_MKT_FCST_ALL` 호출 — 별개 객체, 유지) / SCM_ADM_PROC_M 0 / nscm-be 소스 0
- 권한(RL_SCM_DML EXECUTE·DEBUG, RL_SCM_SEL EXECUTE, SCMP_APP EXECUTE) = DROP 시 자동 소멸
- AS-IS 교차확인(LGCE_SCMDEV 직접 접속): 실제 EXEC = `DMF0082_SAVE_MAIN_DATA` 1곳뿐. SQL Agent JOB 3종은 `_ALL` 호출,
  C# 소스는 `DMF0082_FcstNPrice_Mgmt.cs:715` 주석 1줄 → 단독 배치 SP 아님 = PKG 합류·standalone 삭제 기준 충족
  (사용자 기준 2026-09-22: 다른 호출처 있으면 유지 / 없으면 삭제·PKG 합류)
- 클라우드 이관 패키지: `_artifacts/_deploy_packages/DMF0082_TMAINFIX_CLOUD_20260922/`

## 적용 결과 (사내 ZIOUI1, SERVER_HOST=ol9-db)
- PKG_DMF0082 BODY: VALID, USER_ERRORS 0 / 잔존 `GT_PRDM_T_MAIN`·`'VMI_IN_REQ'` 0
- standalone PROCEDURE·SYNONYM: 부재 확인 (재DROP 시 ORA-01434)
- 비파괴 dry-run (세션 GTT, ROLLBACK): 40 원장 40행 적재 시 PR 추출 건수 수정전 0 → 수정후 40 (SEND_TARGET 0→20),
  모의 VMI_In_Req 5행: 정정 전 0 → 정정 후 5

## 미검증 / 후속
- 실제 화면 저장(DMF0082 40 사업부) E2E 미실행 — 이제 PR 이 실제로 DM_PLN_MKT_FCST DELETE/INSERT + BALANCE_CREATE(40)
  + PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE 를 수행하므로 저장 소요시간·결과 확인 필요.
- 이슈 후보(미수정): `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` L2079 에도 `'VMI_IN_REQ'`,`'AS_IN_REQ'` 대문자 리터럴 존재.
- 클라우드 이관 패키지 작성 완료 (위 경로) — 클라우드 미적용.
