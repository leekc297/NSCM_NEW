# PKG_SCP0122 이식 메모

프로시저 3개. 각 프로시저 끝의 /* ASIS … */ 원문을 Oracle 로 옮기고 블록을 지운다. O_RC 수는 As-is 최상위 SELECT 수에서 추정 — FE 플랜(e2e_plan.json procs)과 맞춘다.

- P_SCP0121_GET_SEARCH_INFO: 임시테이블 #division_info, #line_master, #osp_plant_info → GTT(03_GTT) 또는 WITH 절/컬렉션으로
- P_SCP0122_GET_PLAN_ACTIVITY_MGMT: 첫 결과셋 컬럼(As-is 실측 15): DIVISION_ID(nvarchar(30)), OPMZ_PRS_CD(nvarchar(30)), OPMZ_PRS_NAME(nvarchar(100)), OPMZ_PLAN_GR_ID(nvarchar(30)), OPMZ_PLAN_GR_NAME(nvarchar(100)), OPMZ_ACTV_SEQ(tinyint), OPMZ_ACTV_CD(nvarchar(30)), OPMZ_ACTV_NAME(nvarchar(30)), LINK_UI_TYPE(nvarchar(150)), PROGRAM_NAME(nvarchar(150)), CONFIRM_YN(nvarchar(150)), AUTO_YN(nvarchar(150)), OPTION_YN(nvarchar(150)), PRE_OPMZ_ACTV_CD(nvarchar(30)), PRE_OPMZ_ACTV_SEQ(tinyint)
- P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT: TRY/CATCH → EXCEPTION WHEN OTHERS(골격 포함) / 하위 SP 호출 PR_SCM_SYS_LOG_BATCH, SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST → 해당 To-Be PKG.PROC 로 (공통이면 PKG_COM0000/PKG_DM0000)

## 이식 결과 (2026-10-22 · 기준 DB = 사내 ZIOUI1 SCM_MGR 실측)

| 프로시저 | 처리 | 근거·차이 |
|---|---|---|
| P_SCP0121_GET_SEARCH_INFO | #임시테이블 3종 → 기존 GTT `GT_0121_DIVISION_INFO / GT_0121_LINE_MASTER / GT_0121_OSP_PLANT_INFO`(사내 PKG_SCP0121 공용, 신규 DDL 없음) · 시작 시 `DELETE`(#107) | MSSQL `a + ' ' + NULL` = NULL → `CASE … IS NULL THEN NULL` 로 동일화. `osp.*` 는 GTT 보유 컬럼만 적재(결과셋에 쓰이는 컬럼 전부 포함) |
| 〃 | 필수값 검사 제거 | As-is `@p_user_id` 기본값 `''` → 빈값이면 Plan Group 전체. Oracle `''`=NULL 이므로 `P_USER_ID IS NULL OR LIKE` |
| 〃 | O_RC2 `'-'` 행 | As-is 가 `'-'` 를 **실값**(82 사업부 Factory 선택지)으로 반환 — 유지(센티널 아님). O_RC3 OSP 분기 FACTORY_ID `'-'` 동일 |
| P_SCP0122_GET_PLAN_ACTIVITY_MGMT | 15컬럼 As-is 순서·별칭 동일 · 필수값 검사 제거 | As-is 는 NULL 파라미터에 오류 없이 0건 반환 → 동일 동작 |
| 〃 | 키 비교 `= UPPER(RTRIM(P_x))` | As-is MSSQL CI 콜레이션·뒤공백 무시 동등화. 원장 실측 ACTV_M 323행·GR_M 62행 전건 대문자·뒤공백 0 → 인덱스 컬럼 raw 유지 |
| P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT | `'^'` 배열 7개 → `P_DATA` JSON_TABLE(ORDINALITY 순) · 키 `rowStatus, opmzPrsCd, opmzPlanGrId, opmzActvCd, opmzActvSeq, preOpmzActvCd` | As-is 플래그 `'M'` = To-Be `rowStatus 'U'` (둘 다 수용). 그 외 플래그는 As-is 와 같이 이력만 적재 |
| 〃 | 이력 `SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST` → 패키지 내부 전용 `P_SCP_OPMZ_PLAN_GR_ACTV_HIST`(스펙 미노출) | 화면 외 호출처 없음(As-is 원문 `Doc/asisfacts/db/modules/dbo.SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST.sql`). As-is CATCH 는 오류를 삼키나 예외 전파 규약(#137)으로 RAISE |
| 〃 | `PR_SCM_SYS_LOG_BATCH` 그대로 호출 | 사내 standalone(AUTONOMOUS_TRANSACTION) · 인자 10개 중 7~10 기본값 |
| 〃 | 결과 커서 = `CODE/MSG/EVENT` 규약, EVENT = 처리 행수 | As-is `SELECT 'S' result_code, @max_loop_cnt result_cnt` → 규약 우선(port_pkg §하지 말 것). FE 는 CODE='0' 판정 |
| 〃 | 오류 시 ROLLBACK → `SCM_SYS_LOG_BATCH` ERROR 행 적재·COMMIT → RAISE(-20001) | As-is 는 CATCH 에서 `COMMIT WORK` — 오류 이전 행이 부분 커밋될 수 있음. To-Be 는 전건 롤백(원자화) — **의도된 차이** |
| 〃 | 키 컬럼 NVL 미적용 | NOT NULL 키(PRS_CD/PLAN_GR_ID/ACTV_CD/ACTV_SEQ)에 `'/'` 채움은 쓰레기 키 생성 → FE 필수 전달 전제, 누락 시 ORA-01400 으로 실패(롤백) |

## 검증 (사내 ZIOUI1)
- 임시 이름 `PKG_SCP0122_PORTCHK` 로 컴파일 → PACKAGE/BODY VALID · ALL_ERRORS 0 → 비교 후 DROP 완료(잔존 0).
- 결과셋 동등성(이식본 vs 사내 현행 `PKG_SCP0121.P_SCP0121_GET_SEARCH_INFO` / `PKG_SCP0122.P_SCP0122_GET_PLAN_ACTIVITY_MGMT`): SEARCH_INFO RC1~6 행수·컬럼·값 일치(user=minyonglee1 / NULL 두 경우, RC2 는 As-is ORDER BY 없음 → 집합 일치) · PLAN_ACTIVITY 3개 키 × (정상/소문자+뒤공백/NULL) 9건 일치.
- SAVE: `[]` → CODE 0 / EVENT 0, NULL → CODE 1 확인. I/U/D 실행은 사내 원장 보호로 미실행.

## ⚠ 배포 주의
- 사내 ZIOUI1 에 ZIONEX 전환본 `PKG_SCP0122`(2026-10-09, SAVE = `'^'` CLOB 6개 시그니처 · `RESULT_CODE/RESULT_CNT`)가 이미 있다. 본 파일을 `@` 실행하면 **덮어써서 SAVE 시그니처가 바뀐다** — 현 FE/BE 배선 확인 후 결정할 것(미배포).
- `P_SCP0121_GET_SEARCH_INFO` 는 사내 `PKG_SCP0121` 에도 같은 본문이 있다(O_RESULT_CURSOR 없음). 중복 유지 여부 결정 필요.
