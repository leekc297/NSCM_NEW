-- ============================================================================
-- M32 — 운영 MSSQL(LGCE_SCMPROD)에서 실행.
--       결과(SQL_TEXT 전체)를 oracle/O32_gr_mnu_btn_mpg_merge.sql 로 저장 후 Oracle에서 실행.
-- 생성물: 5그룹 버튼권한 부족분 보충 INSERT
--   규칙(AS-IS ACL 비트): 조회성(SEARCH%/EXCEL/FILTER/SORT/COLUMN_SETUP/MEASURE_SELECT/
--   TITLE/SPREAD_TITLE_DATE/SP_VER/TEXTBOX/LOAD_PERCENT/VERSION_MGMT/VERSION_MGT)=메뉴 부여 시 항상,
--   INSERT·NEW=C비트, DELETE=D비트, 그 외 편집성(SAVE% 등)=U비트
-- ============================================================================
SET NOCOUNT ON;

WITH G AS (
  SELECT RTRIM(A.GroupID) AS gr, RTRIM(M.ProgramID) AS mnu,
         MAX(CASE WHEN A.BasicACLC = 1 THEN 'Y' ELSE 'N' END) AS c,
         MAX(CASE WHEN A.BasicACLU = 1 THEN 'Y' ELSE 'N' END) AS u,
         MAX(CASE WHEN A.BasicACLD = 1 THEN 'Y' ELSE 'N' END) AS d
    FROM dbo.TB_FX_GroupMenuAuth A
    JOIN dbo.TB_FX_MenuItemInfo M ON M.MenuID = A.MenuID
   WHERE RTRIM(A.UseYN) = 'Y'
     AND NULLIF(RTRIM(M.ProgramID),'') IS NOT NULL
     AND A.GroupID IN (N'DM ADMIN',N'DM Planner',N'DM Planner (W/S)',N'DM Viewer',N'SCP Planner')
   GROUP BY RTRIM(A.GroupID), RTRIM(M.ProgramID)
),
R AS (SELECT gr, mnu, c, u, d, ROW_NUMBER() OVER (ORDER BY gr, mnu) AS rn FROM G)
SELECT SQL_TEXT
  FROM (
    SELECT 0 AS ord, 0 AS rn,
           '-- O32. USER_GR_MNU_BTN_MPG_M 버튼권한 부족분 보충 — 운영 LGCE_SCMPROD 권한 근거 '
           + CONVERT(varchar(16), GETDATE(), 120) + CHAR(10)
         + 'INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD,' + CHAR(10)
         + '        USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)' + CHAR(10)
         + 'WITH ASIS_GRANT (GR, MNU, C, U, D) AS (' AS SQL_TEXT
    UNION ALL
    SELECT 1, rn,
           CASE WHEN rn = 1 THEN '  SELECT ' ELSE '  UNION ALL SELECT ' END
         + '''' + REPLACE(gr,'''','''''') + ''',''' + REPLACE(mnu,'''','''''') + ''','''
         + c + ''',''' + u + ''',''' + d + ''' FROM DUAL'
      FROM R
    UNION ALL
    SELECT 2, 0,
           ')' + CHAR(10)
         + 'SELECT A.GR, B.MNU_ID, B.SHT_NM, B.MNU_BTN_CD, ''Y'', ''admin'', SYSDATE, ''admin'', SYSDATE' + CHAR(10)
         + '  FROM ASIS_GRANT A' + CHAR(10)
         + '  JOIN SCM_MGR.SCM_ADM_MNU_BTN_MPG_M B ON B.MNU_ID = A.MNU' + CHAR(10)
         + ' WHERE (   B.MNU_BTN_CD LIKE ''SEARCH%''' + CHAR(10)
         + '        OR B.MNU_BTN_CD IN (''EXCEL'',''FILTER'',''SORT'',''COLUMN_SETUP'',''MEASURE_SELECT'',''TITLE'',' + CHAR(10)
         + '                            ''SPREAD_TITLE_DATE'',''SP_VER'',''TEXTBOX'',''LOAD_PERCENT'',''VERSION_MGMT'',''VERSION_MGT'')' + CHAR(10)
         + '        OR (A.C = ''Y'' AND B.MNU_BTN_CD IN (''INSERT'',''NEW''))' + CHAR(10)
         + '        OR (A.D = ''Y'' AND B.MNU_BTN_CD = ''DELETE'')' + CHAR(10)
         + '        OR (A.U = ''Y'' AND B.MNU_BTN_CD NOT LIKE ''SEARCH%''' + CHAR(10)
         + '            AND B.MNU_BTN_CD NOT IN (''EXCEL'',''FILTER'',''SORT'',''COLUMN_SETUP'',''MEASURE_SELECT'',''TITLE'',' + CHAR(10)
         + '                                     ''SPREAD_TITLE_DATE'',''SP_VER'',''TEXTBOX'',''LOAD_PERCENT'',''VERSION_MGMT'',''VERSION_MGT'',' + CHAR(10)
         + '                                     ''INSERT'',''NEW'',''DELETE'')))' + CHAR(10)
         + '   AND NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M P' + CHAR(10)
         + '                    WHERE P.USER_GR_ID = A.GR AND P.MNU_ID = B.MNU_ID' + CHAR(10)
         + '                      AND P.SHT_NM = B.SHT_NM AND P.MNU_BTN_CD = B.MNU_BTN_CD);' + CHAR(10) + CHAR(10)
         + 'COMMIT;'
  ) X
 ORDER BY ord, rn;
