/*=============================================================================================
 * File         : 030_Caller_Test.sql
 * Description  : DMF0003 SP sample EXEC 호출 테스트
 *===========================================================================================*/

SET SERVEROUTPUT ON SIZE UNLIMITED

-- Bucket Type Combo
DECLARE
    o_rc1 SYS_REFCURSOR;
    o_res SYS_REFCURSOR;
    v_cnt PLS_INTEGER := 0;
    v_code VARCHAR2(50); v_name VARCHAR2(200);
BEGIN
    SCM_MGR.PKG_DMF0003.P_DMF0003_GET_BUCKET_TYPE_CODE(O_RC1 => o_rc1, O_RESULT_CURSOR => o_res);
    LOOP
        FETCH o_rc1 INTO v_code, v_name;
        EXIT WHEN o_rc1%NOTFOUND;
        v_cnt := v_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('  ['||v_cnt||'] '||v_code||' / '||v_name);
    END LOOP;
    CLOSE o_rc1;
    DBMS_OUTPUT.PUT_LINE('Bucket Type Combo: '||v_cnt||' rows');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Bucket Combo ERROR: '||SQLERRM);
END;
/

-- 메인 GET SP — Division 40 sample call (22 IN)
DECLARE
    o_rc1 SYS_REFCURSOR;
    o_rc2 SYS_REFCURSOR;
    o_rc3 SYS_REFCURSOR;
    o_res SYS_REFCURSOR;
BEGIN
    SCM_MGR.DMF0003_GET_MKT_FCST_DATA(
        P_DIVISION_ID   => '40',
        P_SCM_SITE_ID   => 'ALL',
        P_PLANT_SITE_ID => 'ALL',
        P_TEAM_ID       => 'ALL',
        P_CUSTOMER      => 'ALL',
        P_BIZ_TYPE      => 'ALL',
        P_PROJECT_CODE  => 'ALL',
        P_ITEM_ID       => 'ALL',
        P_FROM_YYYYMMDD => TO_CHAR(SYSDATE,                'YYYYMMDD'),
        P_TO_YYYYMMDD   => TO_CHAR(SYSDATE + 90,           'YYYYMMDD'),
        P_CREATED_BY    => 'admin',
        P_USER_GROUP    => 'ADMIN',
        P_ITEM_TYPE     => 'ALL',
        P_OWNER         => 'ALL',
        P_QTY_YN        => 'N',
        P_CELL_YN       => 'N',
        P_INVALID_EXEC  => 'N',
        P_AS_YN         => 'N',
        P_USER_DEPT_ID  => 'ALL',
        P_SENDER_CODE   => 'ALL',
        P_USER_ID       => 'admin',
        P_MENU_ID       => 'DMF0003',
        O_RC1           => o_rc1,
        O_RC2           => o_rc2,
        O_RC3           => o_rc3,
        O_RESULT_CURSOR => o_res
    );
    DBMS_OUTPUT.PUT_LINE('메인 GET SP 호출 성공');
    CLOSE o_rc1; CLOSE o_rc2; CLOSE o_rc3;
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('메인 GET SP ERROR: '||SQLCODE||' / '||SQLERRM);
END;
/
