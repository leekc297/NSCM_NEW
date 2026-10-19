# To-Be PKG 이식 — Claude Code 작업 지시 (하네스 v1)

대상: `Doc/gen/<ID>/<ID>_PKG.sql` (gen-pkg.js 골격). 각 프로시저 끝의 `/* ===== ASIS … ===== */` 원문(T-SQL)을 Oracle PL/SQL 로 옮기고 그 블록을 지운다. 시그니처(IN/OUT)·헤더·EXCEPTION 골격은 바꾸지 않는다(O_RC 수가 틀리면 수를 맞추되 `e2e_plan.json` procs 와 `__asis-mapping__.md` §4 도 같이 고친다).

## 입력 (전부 Read)
1. `Doc/gen/<ID>/<ID>_PKG_NOTES.md` — 프로시저별 특이사항(임시테이블·동적SQL·하위 SP·결과셋 컬럼)
2. 변환 규칙: `Doc/_dev_rules/` 의 DB 변환 규칙 문서(ISNULL→NVL, GETDATE→SYSDATE, TOP→FETCH FIRST, +→||, CONVERT→TO_CHAR/TO_DATE, #temp→GTT(03_GTT)/WITH, @@ROWCOUNT→SQL%ROWCOUNT, 커서→FOR LOOP, sp_executesql→EXECUTE IMMEDIATE)
3. 선례: `To-be_v2_converted/06_Packages/04_Package_PKG_DMF0004.sql`(GET/SAVE 표준형), `PKG_DMF0003.sql`(다중 O_RC), `03_GTT/`(임시테이블 대체), `05_Functions/`(FN_SPLITSTRING 등 공통 함수)
4. 분할 파라미터(콤마 리스트)는 `TABLE(SCM_MGR.FN_SPLITSTRING(P_X, ','))`, 'ALL' 처리는 `(P_X = 'ALL' OR col IN (…))` 선례대로

## 해야 할 것
1. 결과셋 컬럼명·순서는 As-is 와 **동일**(FE 그리드 바인딩이 컬럼명으로 붙는다). 별칭 대소문자는 대문자.
2. SAVE 류: `P_DATA` JSON 배열을 `JSON_TABLE` 로 전개(컬럼 키는 camelCase — FE sendRows), `rowStatus` I/U/D 분기, `V_ROW_CNT` 누적.
3. 하위 SP 호출은 해당 To-Be PKG.PROC 로. 공통 SP(UP_FX_*, SCM0001_GET_*)는 PKG_COM0000/PKG_DM0000 에서 찾고 없으면 NOTES 에 "공통 PKG 필요" 로 남긴다(임의 구현 금지).
4. 끝나면 `node tools/Harness/check-pkg.js <ID>` 를 실행해 BLOCK 0 을 만든다(T-SQL 잔재·TODO·ASIS 블록 검사).
5. 컴파일은 Oracle 에서: `tools/DbConn` 접속으로 `@<ID>_PKG.sql` 후 `USER_ERRORS` 확인 → 이어서 `<ID>_registration.sql` 재실행(PROC_M 확정).

## 하지 말 것
- As-is 에 없는 로직 추가/"개선" — 차이가 필요하면 NOTES 에 사유. 주석 처리된 As-is 코드 이식 금지.
- 결과셋 컬럼 생략/이름 변경, O_RESULT_CURSOR 규약(CODE/MSG/EVENT) 변경.
