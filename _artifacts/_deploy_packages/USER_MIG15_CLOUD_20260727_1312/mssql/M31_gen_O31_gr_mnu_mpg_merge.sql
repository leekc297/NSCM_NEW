-- ============================================================================
-- M31 — 운영 MSSQL(LGCE_SCMPROD)에서 실행.
--       결과(SQL_TEXT 전체)를 oracle/O31_gr_mnu_mpg_merge.sql 로 저장 후 Oracle에서 실행.
-- 생성물: 5그룹 메뉴권한 부족분 보충 INSERT (운영 TB_FX_GroupMenuAuth 근거 ×
--         실행 시점 Oracle SCM_ADM_MNU_M 등재 메뉴 교집합 + 조상 메뉴 — TO-BE 미생성 UI 자동 제외)
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
           '-- O31. USER_GR_MNU_MPG_M 메뉴권한 부족분 보충 — 운영 LGCE_SCMPROD 권한 근거 '
           + CONVERT(varchar(16), GETDATE(), 120) + CHAR(10)
         + 'INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN,' + CHAR(10)
         + '        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)' + CHAR(10)
         + 'WITH ASIS_GRANT (GR, MNU, C, U, D) AS (' AS SQL_TEXT
    UNION ALL
    SELECT 1, rn,
           CASE WHEN rn = 1 THEN '  SELECT ' ELSE '  UNION ALL SELECT ' END
         + '''' + REPLACE(gr,'''','''''') + ''',''' + REPLACE(mnu,'''','''''') + ''','''
         + c + ''',''' + u + ''',''' + d + ''' FROM DUAL'
      FROM R
    UNION ALL
    SELECT 2, 0,
           '),' + CHAR(10)
         + 'ANCESTORS AS (' + CHAR(10)
         + '  SELECT CONNECT_BY_ROOT MNU_ID AS MNU_ID, MNU_ID AS ANC_MNU_ID' + CHAR(10)
         + '    FROM SCM_MGR.SCM_ADM_MNU_M' + CHAR(10)
         + ' CONNECT BY NOCYCLE PRIOR UPPR_MNU_ID = MNU_ID' + CHAR(10)
         + '),' + CHAR(10)
         + 'GRANT_MNUS AS (' + CHAR(10)
         + '  SELECT DISTINCT A.GR, AN.ANC_MNU_ID AS MNU_ID' + CHAR(10)
         + '    FROM ASIS_GRANT A' + CHAR(10)
         + '    JOIN ANCESTORS AN ON AN.MNU_ID = A.MNU' + CHAR(10)
         + ')' + CHAR(10)
         + 'SELECT G.GR, G.MNU_ID, ''Y'', ''admin'', SYSDATE, ''admin'', SYSDATE' + CHAR(10)
         + '  FROM GRANT_MNUS G' + CHAR(10)
         + ' WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M P' + CHAR(10)
         + '                    WHERE P.USER_GR_ID = G.GR AND P.MNU_ID = G.MNU_ID);' + CHAR(10) + CHAR(10)
         + 'COMMIT;'
  ) X
 ORDER BY ord, rn;
