"""
P_SYS0013_GET_HISTORY 신규 작성 (standalone SP)
- 자매 SYS0013_GET_QUERY_LIST 등의 dual cursor 패턴 따름
- SCM_ADM_DQ_EXECUTE_H 에서 dqId 로 history list 조회
"""
import oracledb

sp_body = """
CREATE OR REPLACE PROCEDURE SCM_MGR.SYS0013_GET_HISTORY
(
    P_DQ_ID            IN  VARCHAR2,
    P_USER_ID          IN  VARCHAR2,
    P_MNU_ID           IN  VARCHAR2,
    O_RC1              OUT SYS_REFCURSOR,
    O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : SYS0013_GET_HISTORY                                                                  */
/* Description : Dynamic Query 실행 이력 조회                                                          */
/* Created     : 2026-06-15 — AS-IS DB 에 history GET SP 미존재, SCM_ADM_DQ_EXECUTE_H SELECT 신규 작성 */
/****************************************************************************************************/
IS
BEGIN
    OPEN O_RC1 FOR
    SELECT HISTORY_SEQ
         , DQ_ID
         , DQ_TEXT
         , CREATED_BY
         , CREATION_DATE
         , LAST_UPDATED_BY
         , LAST_UPDATE_DATE
      FROM SCM_MGR.SCM_ADM_DQ_EXECUTE_H
     WHERE (P_DQ_ID IS NULL OR P_DQ_ID = '' OR DQ_ID = P_DQ_ID)
     ORDER BY HISTORY_SEQ DESC;

    OPEN O_RESULT_CURSOR FOR
    SELECT 0 AS RESULT_CODE
         , 'SUCCESS' AS RESULT_MESSAGE
      FROM DUAL;
END SYS0013_GET_HISTORY;
"""

conn = oracledb.connect(user='SCM_MGR', password='!SCMroqkf2026', dsn='121.162.245.167:2521/ESSCMD')
cur = conn.cursor()
cur.execute(sp_body)
print('✅ SYS0013_GET_HISTORY CREATE OK')

# GRANT + SYNONYM
cur.execute('GRANT EXECUTE ON SYS0013_GET_HISTORY TO SCMD_APP')
print('✅ GRANT TO SCMD_APP')

conn.commit()
conn.close()

# SCMD_APP SYNONYM
conn = oracledb.connect(user='SCMD_APP', password='!SCMroqkf2026', dsn='121.162.245.167:2521/ESSCMD')
cur = conn.cursor()
cur.execute('CREATE OR REPLACE SYNONYM SYS0013_GET_HISTORY FOR SCM_MGR.SYS0013_GET_HISTORY')
print('✅ SYNONYM created')
conn.commit()
conn.close()
