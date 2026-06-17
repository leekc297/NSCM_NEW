-- Issue 1: SCM_ADM_CMBO_SQL_M 에 SQL_ID='BizType' 신규 INSERT (DmBizType 와 동일 source: SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE='DM_BIZ_TYPE')
--   FE SearchFields BizTypeField 가 useTabComboQueries({ filters: ['BizType'] }) 호출 — 사내에 'BizType' 등록 필수.

INSERT INTO SCM_ADM_CMBO_SQL_M
  (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'BizType', 'CM', 'Biz Type (BIZ_TYPE_NAME for combo)',
       'SELECT ''ALL'' AS CODE, ''ALL'' AS NAME FROM DUAL UNION ALL SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = ''DM_BIZ_TYPE''',
       'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'BizType');


-- Issue 2: SCM_ADM_PROC_M 에 P_COM0005_GET_PROJECT_BY_DIVISION_POPUP signature 등록 (6 IN + 2 OUT)
--   BE 가 callProc 시 이 메타 기준 FE filter 매핑 — 누락 시 etc 가 SP 에 전달 안 되어 ELSE 분기 (0 row).

INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                             CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'P_COM0005_GET_PROJECT_BY_DIVISION_POPUP', NEW.COL_NM, NEW.COL_TP_CD, NEW.DATA_TP_CD, NEW.SORT_ORD,
       'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'divisionId'     COL_NM, 'IN'  COL_TP_CD, 'VARCHAR'     DATA_TP_CD, 1 SORT_ORD FROM DUAL UNION ALL
    SELECT 'deptId',                'IN',             'VARCHAR',                2          FROM DUAL UNION ALL
    SELECT 'endCustomer',           'IN',             'VARCHAR',                3          FROM DUAL UNION ALL
    SELECT 'scmSiteId',             'IN',             'VARCHAR',                4          FROM DUAL UNION ALL
    SELECT 'projectCode',           'IN',             'VARCHAR',                5          FROM DUAL UNION ALL
    SELECT 'etc',                   'IN',             'VARCHAR',                6          FROM DUAL UNION ALL
    SELECT 'o_rc1',                 'OUT',            'CURSOR',                 7          FROM DUAL UNION ALL
    SELECT 'o_result_cursor',       'OUT',            'PROC_RESULT',            8          FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_ADM_PROC_M E
    WHERE E.PROC_NM = 'P_COM0005_GET_PROJECT_BY_DIVISION_POPUP'
      AND E.COL_NM  = NEW.COL_NM
      AND E.COL_TP_CD = NEW.COL_TP_CD
 );

COMMIT;
