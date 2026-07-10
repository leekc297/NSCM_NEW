-- ============================================================================
-- DMF0014 SAVE — PROC_M SORT 17 키명 정렬 (createdBy → createdByList)
--   ⚠️ FE 와 반드시 동시 배포. FE payload 키 'createdByList' 와 이 메타가 일치해야 함.
--      (불일치 시 CREATED_BY NULL → ORA-01400 저장 실패)
-- ============================================================================
UPDATE SCM_MGR.SCM_ADM_PROC_M
   SET COL_NM = 'createdByList',
       LAST_UPDATED_BY = 'minyonglee1',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROC_NM = 'PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA'
   AND SORT_ORD = 17
   AND COL_NM = 'createdBy';
COMMIT;

-- 검증 (기대: 16=qty / 17=createdByList / 18=o_result_cursor)
SELECT SORT_ORD, COL_NM FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM = 'PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA'
   AND SORT_ORD IN (16,17,18) ORDER BY SORT_ORD;
