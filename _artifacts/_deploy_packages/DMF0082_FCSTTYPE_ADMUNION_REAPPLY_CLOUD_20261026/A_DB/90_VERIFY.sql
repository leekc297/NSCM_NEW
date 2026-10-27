-- 90 VERIFY — [E20261012-FCSTTYPEADM] 콤보 2종을 케이스별 사용자·division 으로 실제 실행해 후보 수 확인 (조회만 · 전체 F5 · 값 입력 없음)
-- * 기대: 관리자+W/S · 81 = 14종(일반 12 + WS 2, 중복 0) / W/S+DM Planner · 81 = 14종 / W/S 단독 · 81 = 6종 / 비 W/S · 81 = 12종 / 40 은 전부 12종
-- * 케이스 사용자는 이 DB 의 그룹 보유 현황에서 고른다 (없으면 그 줄은 '대상 사용자 없음')
-- * 10 실행 전에 돌리면 관리자+W/S · 81 이 6종 — 그 자체가 적용 전 증거
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    TYPE t_s IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;
    v_case t_s; v_user t_s; v_exp81 t_s;
    v_sql  VARCHAR2(32767);
    v_txt  VARCHAR2(4000);
    n PLS_INTEGER; nd PLS_INTEGER;
    c_ws  CONSTANT VARCHAR2(200) := 'MAX(CASE WHEN G.USER_GR_ID = ''DM Planner (W/S)'' THEN 1 ELSE 0 END)';
    c_adm CONSTANT VARCHAR2(200) := 'MAX(CASE WHEN G.USER_GR_ID IN (''ADMIN'',''DM ADMIN'',''SCM PI Admin'') THEN 1 ELSE 0 END)';
    c_dmp CONSTANT VARCHAR2(200) := 'MAX(CASE WHEN G.USER_GR_ID = ''DM Planner'' THEN 1 ELSE 0 END)';
    FUNCTION pick(p_having VARCHAR2) RETURN VARCHAR2 IS
        v VARCHAR2(200);
    BEGIN
        EXECUTE IMMEDIATE 'SELECT MIN(USER_ID) KEEP (DENSE_RANK FIRST ORDER BY CASE USER_ID WHEN ''minyonglee1'' THEN 0 ELSE 1 END, USER_ID) FROM ('
            || 'SELECT G.USER_ID FROM SCM_ADM_USER_GR_MPG_M G WHERE TO_CHAR(G.USE_YN) = ''Y'' GROUP BY G.USER_ID HAVING ' || p_having || ')' INTO v;
        RETURN v;
    END;
BEGIN
    v_case(1) := '관리자+W/S';     v_user(1) := pick(c_ws || '=1 AND ' || c_adm || '=1');                         v_exp81(1) := '14';
    v_case(2) := 'W/S 단독';       v_user(2) := pick(c_ws || '=1 AND ' || c_adm || '=0 AND ' || c_dmp || '=0');   v_exp81(2) := '6';
    v_case(3) := 'W/S+DM Planner'; v_user(3) := pick(c_ws || '=1 AND ' || c_adm || '=0 AND ' || c_dmp || '=1');   v_exp81(3) := '14';
    v_case(4) := '비 W/S';         v_user(4) := pick(c_ws || '=0 AND ' || c_adm || '=0 AND ' || c_dmp || '=1');   v_exp81(4) := '12';
    FOR m IN (SELECT SQL_ID, SQL_DTL_CTN, CASE WHEN INSTR(SQL_DTL_CTN, 'E20261012-FCSTTYPEADM') > 0 THEN 'Y' ELSE 'N' END APPLIED
                FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN ('FcstTypeEditDMF0082','FcstTypeByUserGroupDMF0082') ORDER BY SQL_ID) LOOP
        DBMS_OUTPUT.PUT_LINE('== ' || m.SQL_ID || ' (마커 ' || m.APPLIED || ')');
        FOR i IN 1 .. 4 LOOP
            IF v_user(i) IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('   ' || RPAD(v_case(i), 16) || ' 대상 사용자 없음');
            ELSE
                FOR d IN (SELECT '81' dv FROM DUAL UNION ALL SELECT '40' FROM DUAL) LOOP
                    v_txt := REPLACE(REPLACE(m.SQL_DTL_CTN, '@divisionId', '''' || d.dv || ''''), '@sesUserId', '''' || v_user(i) || '''');
                    v_sql := 'SELECT COUNT(*), COUNT(DISTINCT CODE) FROM (' || v_txt || ')';
                    BEGIN
                        EXECUTE IMMEDIATE v_sql INTO n, nd;
                        DBMS_OUTPUT.PUT_LINE('   ' || RPAD(v_case(i), 16) || RPAD(v_user(i), 14) || ' div ' || d.dv || ' : ' || n || '종 · 중복 ' || (n - nd)
                            || CASE WHEN n <> nd THEN '  FAIL(중복)'
                                    WHEN d.dv = '81' AND TO_CHAR(n) = v_exp81(i) THEN '  PASS'
                                    WHEN d.dv = '81' AND i IN (1, 3) AND n = 6 THEN '  (적용 전 상태)'
                                    WHEN d.dv = '40' AND n = 12 THEN '  PASS'
                                    ELSE '  CHECK — 기대 ' || CASE WHEN d.dv = '81' THEN v_exp81(i) ELSE '12' END || '종 (룩업 건수가 사내와 다르면 달라질 수 있음)' END);
                    EXCEPTION WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('   ' || RPAD(v_case(i), 16) || RPAD(v_user(i), 14) || ' div ' || d.dv || ' : FAIL — ' || SUBSTR(SQLERRM, 1, 150));
                    END;
                END LOOP;
            END IF;
        END LOOP;
    END LOOP;
END;
/
