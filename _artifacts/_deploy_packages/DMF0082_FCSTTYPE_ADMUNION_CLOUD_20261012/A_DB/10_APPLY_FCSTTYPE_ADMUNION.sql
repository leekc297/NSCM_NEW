-- 10_APPLY — [E20261012-FCSTTYPEADM] DMF0082 FCST Type 콤보 2종 패치 (전체 F5, 값 입력 없음, 멱등)
-- 증상: Division 81 에서 관리자 그룹(ADMIN 등)과 'DM Planner (W/S)' 를 함께 가진 사용자의 Insert 행 FCST Type 후보가 W/S 유형 6종뿐
-- 원인: 콤보 SQL 이 81 에서 'DM Planner (W/S)' 보유만 보고 W/S 유형만 준다 (관리자 그룹 보유는 판정에 없음)
-- 조치(사용자 확정 2026-10-12): 일반 그룹(ADMIN · DM ADMIN · DM Planner · SCM PI Admin) 겸직자는 81 에서 일반 유형 + W/S 유형을 모두 받는다 (중복 코드 1회)
--       "W/S + DM Planner 사용자도 DM Planner 가 할 수 있는 모든 것을 할 수 있어야 한다"
--       W/S 만 가진 사용자 · 비 W/S 사용자 · 40 조회는 종전과 동일
-- 방식: 이 DB 의 등록 SQL 원문(SCM_ADM_CMBO_SQL_M.SQL_DTL_CTN)에 정규식 치환 2곳. 사내·클라우드 원문이 달라 전체 교체하지 않는다.
-- 가드: 마커 있으면 무동작 · 앵커가 각 1곳이 아니면 중단(무변경) · 4000바이트 초과 시 중단 · 적용 전 원문을 SCM_ADM_CMBO_SQL_M_BAK20261012_FTADM 에 보관
-- 원복: 99_ROLLBACK_FCSTTYPE_ADMUNION.sql
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    c_mark CONSTANT VARCHAR2(40)   := 'E20261012-FCSTTYPEADM';
    c_p1   CONSTANT VARCHAR2(2000) := '(G\.USER_GR_ID\s*=\s*''DM Planner \(W/S\)''\s+AND\s+(TO_CHAR\(G\.USE_YN\)|G\.USE_YN)\s*=\s*''Y''\s*\))(\s+UNION ALL)';
    c_p2   CONSTANT VARCHAR2(2000) := '(NOT\s*\(\s*NVL\(TRIM\(@divisionId\),\s*''-''\)\s+LIKE\s+''81%''\s+AND\s+EXISTS\s*\(\s*SELECT 1 FROM SCM_MGR\.SCM_ADM_USER_GR_MPG_M G\s+WHERE\s+G\.USER_ID\s*=\s*@sesUserId\s+AND\s+G\.USER_GR_ID\s*=\s*''DM Planner \(W/S\)''\s+AND\s+(TO_CHAR\(G\.USE_YN\)|G\.USE_YN)\s*=\s*''Y''\s*\)\s*\))';
    c_r1   CONSTANT VARCHAR2(4000) := '\1 /* [E20261012-FCSTTYPEADM] 일반 그룹 겸직자는 일반 유형도 함께 받으므로 겹치는 코드는 여기서 제외(중복 방지) */ AND NOT ( SEGMENT1 IN (SELECT S.SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL S WHERE S.LOOKUP_TYPE = ''SALES_TYPE_CODE'' AND S.VALID_YN = ''Y'' AND NVL(S.ATTRIBUTE2, '' '') <> ''Y'') AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M A WHERE A.USER_ID = @sesUserId AND A.USER_GR_ID IN (''ADMIN'', ''DM ADMIN'', ''DM Planner'', ''SCM PI Admin'') AND TO_CHAR(A.USE_YN) = ''Y'') )\3';
    c_r2   CONSTANT VARCHAR2(2000) := '( \1 OR EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M A WHERE A.USER_ID = @sesUserId AND A.USER_GR_ID IN (''ADMIN'', ''DM ADMIN'', ''DM Planner'', ''SCM PI Admin'') AND TO_CHAR(A.USE_YN) = ''Y'') )';
    v_new  VARCHAR2(32767);
    n_bak  PLS_INTEGER;
    n_done PLS_INTEGER := 0;
BEGIN
    SELECT COUNT(*) INTO n_bak FROM USER_TABLES WHERE TABLE_NAME = 'SCM_ADM_CMBO_SQL_M_BAK20261012_FTADM';
    IF n_bak = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SCM_ADM_CMBO_SQL_M_BAK20261012_FTADM AS SELECT * FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN (''FcstTypeEditDMF0082'',''FcstTypeByUserGroupDMF0082'')';
        DBMS_OUTPUT.PUT_LINE('BACKUP — SCM_ADM_CMBO_SQL_M_BAK20261012_FTADM 생성 (적용 전 원문 2행)');
    END IF;
    FOR r IN (SELECT SQL_ID, SQL_DTL_CTN FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN ('FcstTypeEditDMF0082','FcstTypeByUserGroupDMF0082') ORDER BY SQL_ID) LOOP
        IF INSTR(r.SQL_DTL_CTN, c_mark) > 0 THEN
            DBMS_OUTPUT.PUT_LINE('SKIP — ' || r.SQL_ID || ' 이미 적용됨');
        ELSE
            IF REGEXP_COUNT(r.SQL_DTL_CTN, c_p1) <> 1 OR REGEXP_COUNT(r.SQL_DTL_CTN, c_p2) <> 1 THEN
                ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, '중단 — ' || r.SQL_ID || ' 앵커 매칭 ' || REGEXP_COUNT(r.SQL_DTL_CTN, c_p1) || '/' || REGEXP_COUNT(r.SQL_DTL_CTN, c_p2)
                                                || ' (각 1 기대). 등록 SQL 원문이 예상과 다름 → 00_PRECHECK 결과 회신. 변경 취소함');
            END IF;
            v_new := REGEXP_REPLACE(REGEXP_REPLACE(r.SQL_DTL_CTN, c_p2, c_r2), c_p1, c_r1);
            IF LENGTHB(v_new) > 4000 THEN
                ROLLBACK;
                RAISE_APPLICATION_ERROR(-20002, '중단 — ' || r.SQL_ID || ' 치환 결과 ' || LENGTHB(v_new) || '바이트 (4000 초과). 변경 취소함');
            END IF;
            UPDATE SCM_ADM_CMBO_SQL_M SET SQL_DTL_CTN = v_new, LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE WHERE SQL_ID = r.SQL_ID;
            n_done := n_done + 1;
            DBMS_OUTPUT.PUT_LINE('APPLIED — ' || r.SQL_ID || ' ' || LENGTHB(r.SQL_DTL_CTN) || ' → ' || LENGTHB(v_new) || '바이트');
        END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('DONE — ' || n_done || '건 적용 · COMMIT · ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'));
END;
/
