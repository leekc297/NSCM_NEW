-- ============================================================================
-- DMF0014 SAVE — PROC_M 키명 정렬 (2026-07-08 사내 반영 완료)
--   원인: FE 'createdBy' 키는 BE(BaseService)가 세션 단일값으로 덮어써 '^'×N 배열이
--         1토큰으로 붕괴 → SP split 2행째부터 CREATED_BY NULL → ORA-01400 (다건 저장 실패).
--   조치: FE payload 키 = 'createdByList'(BE 미가로채) + PROC_M COL_NM 동일 정렬 (동시 배포 필수).
-- ============================================================================
UPDATE SCM_MGR.SCM_ADM_PROC_M
   SET COL_NM = 'createdByList',
       LAST_UPDATED_BY = 'minyonglee1',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROC_NM = 'PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA'
   AND SORT_ORD = 17
   AND COL_NM = 'createdBy';
COMMIT;

-- 검증
SELECT SORT_ORD, COL_NM FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM = 'PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA' AND SORT_ORD IN (16,17,18) ORDER BY SORT_ORD;
-- 기대: 16=qty / 17=createdByList / 18=o_result_cursor
