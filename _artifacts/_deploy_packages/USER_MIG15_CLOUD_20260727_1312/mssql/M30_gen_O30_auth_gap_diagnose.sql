-- ============================================================================
-- M30 — 운영 MSSQL(LGCE_SCMPROD)에서 실행.
--       결과(SQL_TEXT 전체)를 oracle/O30_auth_gap_diagnose.sql 로 저장 후 Oracle에서 실행.
-- 생성물: 권한 gap 진단 3종 (읽기 전용 — 데이터 변경 없음)
--   [진단1] 메뉴권한 gap  [진단2] 버튼권한 gap 건수  [진단3] TO-BE 미생성 UI 제외 목록
--   O31/O32 적용 전후로 실행 — 적용 후 진단1·2 = 0 rows 여야 함
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
R AS (SELECT gr, mnu, c, u, d, ROW_NUMBER() OVER (ORDER BY gr, mnu) AS rn FROM G),
DATAROW AS (
  SELECT rn,
         CASE WHEN rn = 1 THEN '  SELECT ' ELSE '  UNION ALL SELECT ' END
       + '''' + REPLACE(gr,'''','''''') + ''',''' + REPLACE(mnu,'''','''''') + ''','''
       + c + ''',''' + u + ''',''' + d + ''' FROM DUAL' AS line
    FROM R
)
SELECT SQL_TEXT
  FROM (
    SELECT 0 AS ord, 0 AS rn,
           '-- O30. 권한 gap 진단 3종 (읽기 전용) — 운영 LGCE_SCMPROD 권한 근거 '
           + CONVERT(varchar(16), GETDATE(), 120) + CHAR(10)
         + '-- [진단 1] 메뉴권한 gap: AS-IS 부여(조상 포함)인데 USER_GR_MNU_MPG_M 부재' + CHAR(10)
         + 'WITH ASIS_GRANT (GR, MNU, C, U, D) AS (' AS SQL_TEXT
    UNION ALL SELECT 10, rn, line FROM DATAROW
    UNION ALL
    SELECT 19, 0,
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
         + 'SELECT G.GR AS USER_GR_ID, G.MNU_ID' + CHAR(10)
         + '  FROM GRANT_MNUS G' + CHAR(10)
         + ' WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M P' + CHAR(10)
         + '                    WHERE P.USER_GR_ID = G.GR AND P.MNU_ID = G.MNU_ID)' + CHAR(10)
         + ' ORDER BY 1, 2;' + CHAR(10) + CHAR(10)
         + '-- [진단 2] 버튼권한 gap 건수 (그룹×메뉴별)' + CHAR(10)
         + 'WITH ASIS_GRANT (GR, MNU, C, U, D) AS ('
    UNION ALL SELECT 20, rn, line FROM DATAROW
    UNION ALL
    SELECT 29, 0,
           ')' + CHAR(10)
         + 'SELECT A.GR AS USER_GR_ID, B.MNU_ID, COUNT(*) AS GAP_BTN_CNT' + CHAR(10)
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
         + '                      AND P.SHT_NM = B.SHT_NM AND P.MNU_BTN_CD = B.MNU_BTN_CD)' + CHAR(10)
         + ' GROUP BY A.GR, B.MNU_ID ORDER BY 1, 2;' + CHAR(10) + CHAR(10)
         + '-- [진단 3] AS-IS 부여인데 TO-BE 미등재 (미생성 UI — 제외 목록, 참고)' + CHAR(10)
         + 'WITH ASIS_GRANT (GR, MNU, C, U, D) AS ('
    UNION ALL SELECT 30, rn, line FROM DATAROW
    UNION ALL
    SELECT 39, 0,
           ')' + CHAR(10)
         + 'SELECT A.GR AS USER_GR_ID, A.MNU AS ASIS_PROGRAM_ID' + CHAR(10)
         + '  FROM ASIS_GRANT A' + CHAR(10)
         + ' WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_M M WHERE M.MNU_ID = A.MNU)' + CHAR(10)
         + ' ORDER BY 1, 2;'
  ) X
 ORDER BY ord, rn;
