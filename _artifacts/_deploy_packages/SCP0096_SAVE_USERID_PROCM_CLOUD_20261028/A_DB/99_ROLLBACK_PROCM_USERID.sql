/* SCP0096 저장 ORA-01407 보완 — 원복. 10_APPLY 가 만든 백업(SCM_ADM_PROC_M_BAK20261028_S096)의 SORT_ORD=8 COL_NM 으로 되돌린다.
 *  백업이 없거나 백업값이 이미 'userId' 면 아무것도 하지 않음(이 패치가 바꾸지 않은 환경). 멱등 · 전체 F5 기준 오류 0. */
SET SERVEROUTPUT ON;

DECLARE
    V_BAK_COL  VARCHAR2(1200 CHAR);
    V_CNT      PLS_INTEGER := 0;
BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'SELECT COL_NM FROM SCM_ADM_PROC_M_BAK20261028_S096 '
                       || 'WHERE PROC_NM = ''PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP'' AND SORT_ORD = 8 AND COL_TP_CD = ''IN'''
          INTO V_BAK_COL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_BAK_COL := NULL;
        WHEN OTHERS THEN
            IF SQLCODE = -942 THEN V_BAK_COL := NULL; ELSE RAISE; END IF;
    END;

    IF V_BAK_COL IS NOT NULL AND V_BAK_COL <> 'userId' THEN
        UPDATE SCM_ADM_PROC_M
           SET COL_NM           = V_BAK_COL
             , LAST_UPDATED_BY  = 'admin'
             , LAST_UPDATE_DATE = SYSDATE
         WHERE PROC_NM   = 'PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP'
           AND SORT_ORD  = 8
           AND COL_TP_CD = 'IN'
           AND COL_NM    = 'userId';
        V_CNT := SQL%ROWCOUNT;
        COMMIT;
    END IF;
    DBMS_OUTPUT.PUT_LINE('[ROLLBACK] 백업값=' || NVL(V_BAK_COL, '(백업 없음)') || ' · 되돌린 행 ' || V_CNT || '건');
END;
/
