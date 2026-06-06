-- ============================================================================
-- 80_screen_4axis_audit_DBeaver.sql
-- DBeaver 용 — 각 SELECT 를 한 번씩 실행하여 결과 확인
-- 본체: 80_screen_4axis_audit.sql
-- ============================================================================

-- ─────────────────────────────────────────────────────────────────────────────
-- AXIS 1: SHEET_COLUMNS 중복 (PASS = 0 row)
-- ─────────────────────────────────────────────────────────────────────────────
SELECT PROGRAM_ID, SHEET_NAME,
       COUNT(*) AS TOT,
       COUNT(DISTINCT COLUMN_NAME) AS DISTINCT_CNT,
       COUNT(*) - COUNT(DISTINCT COLUMN_NAME) AS DUP_CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID LIKE '%'    -- ⚙ 특정 MENU_ID 만: 'SYS0014' 등으로 변경
 GROUP BY PROGRAM_ID, SHEET_NAME
HAVING COUNT(*) > COUNT(DISTINCT COLUMN_NAME)
 ORDER BY PROGRAM_ID, SHEET_NAME;


-- ─────────────────────────────────────────────────────────────────────────────
-- AXIS 2-A: MNU_BTN_CD 일관성 — MNU_BTN_MPG_M 에 등록된 button 이
--           USER_GR_MNU_BTN_MPG_M 권한에 없음 (PASS = 0 row)
-- ─────────────────────────────────────────────────────────────────────────────
SELECT M.MNU_ID, M.SHT_NM, M.MNU_BTN_CD AS MAPPED_BTN, M.API_ID
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M M
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M U
    WHERE U.MNU_ID = M.MNU_ID AND U.SHT_NM = M.SHT_NM AND U.MNU_BTN_CD = M.MNU_BTN_CD
 )
   AND M.MNU_ID LIKE '%'      -- ⚙ 특정 MENU_ID 만
   AND M.USE_YN = 'Y'
 ORDER BY M.MNU_ID, M.SHT_NM, M.MNU_BTN_CD;


-- ─────────────────────────────────────────────────────────────────────────────
-- AXIS 2-B: RETRIEVE 잔재 — FE useTabProcQuery default = 'SEARCH'
--           RETRIEVE 사용 시 "권한 없음" 오류 (PASS = 0 row)
-- ─────────────────────────────────────────────────────────────────────────────
SELECT MNU_ID, SHT_NM, MNU_BTN_CD, USER_GR_ID
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_BTN_CD = 'RETRIEVE'
   AND MNU_ID LIKE '%'        -- ⚙ 특정 MENU_ID 만
 ORDER BY MNU_ID, SHT_NM, USER_GR_ID;


-- ─────────────────────────────────────────────────────────────────────────────
-- AXIS 3-A: PROC_M signature mismatch — PROC_M 행 수 vs SP ALL_ARGUMENTS 인자 수
--           불일치 시 callProc 호출 PLS-00306 (PASS = 0 row)
--   PKG-aware: 'PKG_X.P_Y' 형식 + standalone 'P_Z' 양쪽 처리
--   추가 컬럼 SP_STATUS: SP 자체 존재 여부 (MISSING = dead PROC_M)
-- ─────────────────────────────────────────────────────────────────────────────
SELECT P.PROC_NM,
       COUNT(*) AS PROC_M_ROWS,
       NVL((SELECT COUNT(*) FROM ALL_ARGUMENTS A
              WHERE A.OWNER='SCM_MGR'
                AND ( (INSTR(P.PROC_NM,'.')>0
                       AND A.PACKAGE_NAME = SUBSTR(P.PROC_NM, 1, INSTR(P.PROC_NM,'.')-1)
                       AND A.OBJECT_NAME  = SUBSTR(P.PROC_NM, INSTR(P.PROC_NM,'.')+1))
                   OR (INSTR(P.PROC_NM,'.')=0 AND A.PACKAGE_NAME IS NULL AND A.OBJECT_NAME=P.PROC_NM)
                    )), 0) AS SP_ARGS,
       CASE WHEN NOT EXISTS (
         SELECT 1 FROM ALL_OBJECTS O
          WHERE O.OWNER='SCM_MGR'
            AND ( (INSTR(P.PROC_NM,'.')>0 AND O.OBJECT_NAME = SUBSTR(P.PROC_NM, 1, INSTR(P.PROC_NM,'.')-1) AND O.OBJECT_TYPE='PACKAGE')
               OR (INSTR(P.PROC_NM,'.')=0 AND O.OBJECT_NAME = P.PROC_NM AND O.OBJECT_TYPE='PROCEDURE')
                )
       ) THEN 'SP MISSING' ELSE 'EXISTS' END AS SP_STATUS
  FROM SCM_MGR.SCM_ADM_PROC_M P
 WHERE P.PROC_NM LIKE '%'     -- ⚙ 특정 SP prefix: 'P_SYS0014%' 등
 GROUP BY P.PROC_NM
HAVING COUNT(*) <> NVL((SELECT COUNT(*) FROM ALL_ARGUMENTS A
                          WHERE A.OWNER='SCM_MGR'
                            AND ( (INSTR(P.PROC_NM,'.')>0
                                   AND A.PACKAGE_NAME = SUBSTR(P.PROC_NM, 1, INSTR(P.PROC_NM,'.')-1)
                                   AND A.OBJECT_NAME  = SUBSTR(P.PROC_NM, INSTR(P.PROC_NM,'.')+1))
                               OR (INSTR(P.PROC_NM,'.')=0 AND A.PACKAGE_NAME IS NULL AND A.OBJECT_NAME=P.PROC_NM)
                                )), 0)
 ORDER BY P.PROC_NM;


-- ─────────────────────────────────────────────────────────────────────────────
-- AXIS 3-B: GET SP dual cursor 누락 — data cursor + O_RESULT_CURSOR 2 OUT 의무
--           DATA_TP_CD 기준 검출 (COL_NM custom 이름 fcstNPrice/column/measure 허용)
--           O_RESULT_CURSOR 대소문자 무관 (UPPER 비교) (PASS = 0 row)
-- ─────────────────────────────────────────────────────────────────────────────
SELECT PROC_NM,
       SUM(CASE WHEN COL_TP_CD='OUT' AND DATA_TP_CD='CURSOR' THEN 1 ELSE 0 END) AS HAS_DATA_CURSOR,
       SUM(CASE WHEN COL_TP_CD='OUT' AND DATA_TP_CD='PROC_RESULT' AND UPPER(COL_NM)='O_RESULT_CURSOR' THEN 1 ELSE 0 END) AS HAS_RESULT_CURSOR
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE (PROC_NM LIKE 'P_%_GET_%' OR PROC_NM LIKE 'PKG_%_GET_%')
   AND PROC_NM LIKE '%'       -- ⚙ 특정 SP prefix
 GROUP BY PROC_NM
HAVING SUM(CASE WHEN COL_TP_CD='OUT' AND DATA_TP_CD='CURSOR' THEN 1 ELSE 0 END) = 0
    OR SUM(CASE WHEN COL_TP_CD='OUT' AND DATA_TP_CD='PROC_RESULT' AND UPPER(COL_NM)='O_RESULT_CURSOR' THEN 1 ELSE 0 END) = 0
 ORDER BY PROC_NM;


-- ─────────────────────────────────────────────────────────────────────────────
-- AXIS 4: MNU_DESC NULL — USE_YN='Y' 인데 MNU_DESC NULL
--         FE sidebar 메뉴명 렌더 불가로 skip → 화면 미표시 (PASS = 0 row)
-- ─────────────────────────────────────────────────────────────────────────────
SELECT MNU_ID, MNU_URL, UPPR_MNU_ID, MNU_LV_NO
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_DESC IS NULL
   AND USE_YN = 'Y'
   AND MNU_ID LIKE '%'        -- ⚙ 특정 MENU_ID 만
 ORDER BY MNU_ID;


-- ─────────────────────────────────────────────────────────────────────────────
-- SUMMARY: 각 axis 위반 카운트 (PASS = 모두 0)
-- ─────────────────────────────────────────────────────────────────────────────
SELECT 'AXIS 1: SHEET_COLUMNS 중복' AS AXIS,
       (SELECT COUNT(*) FROM (
          SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
           GROUP BY PROGRAM_ID, SHEET_NAME
          HAVING COUNT(*) > COUNT(DISTINCT COLUMN_NAME))) AS VIOLATIONS FROM DUAL
UNION ALL
SELECT 'AXIS 2-A: MNU_BTN_MPG 권한 누락',
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M M
         WHERE M.USE_YN='Y' AND NOT EXISTS (
           SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M U
            WHERE U.MNU_ID=M.MNU_ID AND U.SHT_NM=M.SHT_NM AND U.MNU_BTN_CD=M.MNU_BTN_CD)) FROM DUAL
UNION ALL
SELECT 'AXIS 2-B: RETRIEVE 잔재',
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_BTN_CD='RETRIEVE') FROM DUAL
UNION ALL
SELECT 'AXIS 3-A: PROC_M signature mismatch (PKG-aware)',
       (SELECT COUNT(*) FROM (
          SELECT P.PROC_NM FROM SCM_MGR.SCM_ADM_PROC_M P
           GROUP BY P.PROC_NM
          HAVING COUNT(*) <> NVL((SELECT COUNT(*) FROM ALL_ARGUMENTS A
                                    WHERE A.OWNER='SCM_MGR'
                                      AND ( (INSTR(P.PROC_NM,'.')>0
                                             AND A.PACKAGE_NAME = SUBSTR(P.PROC_NM, 1, INSTR(P.PROC_NM,'.')-1)
                                             AND A.OBJECT_NAME  = SUBSTR(P.PROC_NM, INSTR(P.PROC_NM,'.')+1))
                                         OR (INSTR(P.PROC_NM,'.')=0 AND A.PACKAGE_NAME IS NULL AND A.OBJECT_NAME=P.PROC_NM)
                                          )), 0))) FROM DUAL
UNION ALL
SELECT 'AXIS 3-B: GET SP dual cursor 누락 (DATA_TP_CD 기준)',
       (SELECT COUNT(*) FROM (
          SELECT PROC_NM FROM SCM_MGR.SCM_ADM_PROC_M
           WHERE PROC_NM LIKE 'P_%_GET_%' OR PROC_NM LIKE 'PKG_%_GET_%'
           GROUP BY PROC_NM
          HAVING SUM(CASE WHEN COL_TP_CD='OUT' AND DATA_TP_CD='CURSOR' THEN 1 ELSE 0 END) = 0
              OR SUM(CASE WHEN COL_TP_CD='OUT' AND DATA_TP_CD='PROC_RESULT' AND UPPER(COL_NM)='O_RESULT_CURSOR' THEN 1 ELSE 0 END) = 0)) FROM DUAL
UNION ALL
SELECT 'AXIS 4: MNU_DESC NULL',
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_DESC IS NULL AND USE_YN='Y') FROM DUAL;
