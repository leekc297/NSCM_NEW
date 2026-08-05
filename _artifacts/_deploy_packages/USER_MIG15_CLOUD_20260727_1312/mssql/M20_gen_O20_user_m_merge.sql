-- ============================================================================
-- M20 — 운영 MSSQL(LGCE_SCMPROD)에서 실행.
--       결과(SQL_TEXT 컬럼 전체)를 oracle/O20_user_m_merge.sql 로 저장 후 Oracle에서 실행.
--       (DBeaver: 결과 그리드 → SQL_TEXT 열 전체 복사 / SSMS: 결과를 텍스트로(Ctrl+T) 실행)
-- 생성물: SCM_ADM_USER_M 14계정 MERGE (기존재 시 프로필 갱신, LOGN_DTM/ACNT_LOK_YN 불변)
-- ============================================================================
SET NOCOUNT ON;

WITH U AS (
  SELECT RTRIM(UserID)                                        AS uid,
         REPLACE(ISNULL(NULLIF(RTRIM(UserName),''), RTRIM(UserID)), '''', '''''') AS nm,
         CASE WHEN NULLIF(RTRIM(UserName_E),'')     IS NULL THEN 'NULL' ELSE '''' + REPLACE(RTRIM(UserName_E),'''','''''') + ''''     END AS eng,
         CASE WHEN NULLIF(RTRIM(Email),'')          IS NULL THEN 'NULL' ELSE '''' + REPLACE(RTRIM(Email),'''','''''') + ''''          END AS eml,
         CASE WHEN NULLIF(RTRIM(Dept_ID),'')        IS NULL THEN 'NULL' ELSE '''' + REPLACE(RTRIM(Dept_ID),'''','''''') + ''''        END AS dept,
         CASE WHEN NULLIF(RTRIM(OfficePhoneNum),'') IS NULL THEN 'NULL' ELSE '''' + REPLACE(RTRIM(OfficePhoneNum),'''','''''') + '''' END AS phn,
         CASE WHEN NULLIF(RTRIM(CellPhoneNum),'')   IS NULL THEN 'NULL' ELSE '''' + REPLACE(RTRIM(CellPhoneNum),'''','''''') + ''''   END AS hphn,
         CASE WHEN RTRIM(Language) IN ('KO','EN','CN') THEN RTRIM(Language) ELSE 'KO' END AS lang,
         ISNULL(NULLIF(RTRIM(TimeZone),''),'AS054')           AS tmz,
         CASE WHEN RTRIM(UseYN) IN ('Y','N') THEN RTRIM(UseYN) ELSE 'Y' END AS useyn,
         CASE WHEN LastLoginDateTime IS NULL THEN 'NULL'
              ELSE 'TO_DATE(''' + CONVERT(varchar(19), LastLoginDateTime, 120) + ''',''YYYY-MM-DD HH24:MI:SS'')' END AS logn,
         CASE WHEN NULLIF(RTRIM(Attribute1),'')  IS NULL THEN 'NULL' ELSE '''' + REPLACE(RTRIM(Attribute1),'''','''''') + ''''  END AS a01,
         CASE WHEN NULLIF(RTRIM(Attribute2),'')  IS NULL THEN 'NULL' ELSE '''' + REPLACE(RTRIM(Attribute2),'''','''''') + ''''  END AS a02,
         CASE WHEN NULLIF(RTRIM(Attribute3),'')  IS NULL THEN 'NULL' ELSE '''' + REPLACE(RTRIM(Attribute3),'''','''''') + ''''  END AS a03,
         CASE WHEN NULLIF(RTRIM(Attribute4),'')  IS NULL THEN 'NULL' ELSE '''' + REPLACE(RTRIM(Attribute4),'''','''''') + ''''  END AS a04,
         CASE WHEN NULLIF(RTRIM(Attribute5),'')  IS NULL THEN 'NULL' ELSE '''' + REPLACE(RTRIM(Attribute5),'''','''''') + ''''  END AS a05,
         CASE WHEN NULLIF(RTRIM(Attribute6),'')  IS NULL THEN 'NULL' ELSE '''' + REPLACE(RTRIM(Attribute6),'''','''''') + ''''  END AS a06,
         CASE WHEN NULLIF(RTRIM(Attribute7),'')  IS NULL THEN 'NULL' ELSE '''' + REPLACE(RTRIM(Attribute7),'''','''''') + ''''  END AS a07,
         CASE WHEN NULLIF(RTRIM(Attribute8),'')  IS NULL THEN 'NULL' ELSE '''' + REPLACE(RTRIM(Attribute8),'''','''''') + ''''  END AS a08,
         CASE WHEN NULLIF(RTRIM(Attribute9),'')  IS NULL THEN 'NULL' ELSE '''' + REPLACE(RTRIM(Attribute9),'''','''''') + ''''  END AS a09,
         CASE WHEN NULLIF(RTRIM(Attribute10),'') IS NULL THEN 'NULL' ELSE '''' + REPLACE(RTRIM(Attribute10),'''','''''') + '''' END AS a10
    FROM dbo.TB_FX_User
   WHERE UserID IN (N'hongjae.kim',N'eunah.koo',N'yooah.chung',N'dodae',
                    N'jiwon.park',N'bpark416',N'jaehyeok',N'park6151',N'bottle',
                    N'wonqthanq',N'ys_cho',N'miyeong.lee',N'yeonjusung',N'coeogus')
)
SELECT SQL_TEXT
  FROM (
    SELECT 0 AS ord, '' AS k,
           '-- O20. SCM_ADM_USER_M 14계정 MERGE — 운영 LGCE_SCMPROD 추출 '
           + CONVERT(varchar(16), GETDATE(), 120)
           + CHAR(10) + '-- 생성기: mssql/M20_gen_O20_user_m_merge.sql (USER_MIG15_CLOUD)' AS SQL_TEXT
    UNION ALL
    SELECT 1, uid,
           'MERGE INTO SCM_MGR.SCM_ADM_USER_M T' + CHAR(10)
         + 'USING (SELECT ''' + REPLACE(uid,'''','''''') + ''' AS USER_ID FROM DUAL) S' + CHAR(10)
         + '   ON (T.USER_ID = S.USER_ID)' + CHAR(10)
         + ' WHEN MATCHED THEN UPDATE SET' + CHAR(10)
         + '      T.USER_NM = ''' + nm + ''', T.USER_ENG_NM = ' + eng + ', T.USER_EML = ' + eml + ',' + CHAR(10)
         + '      T.DEPT_ID = ' + dept + ', T.USER_PHN = ' + phn + ', T.USER_HPHN = ' + hphn + ',' + CHAR(10)
         + '      T.LANG_CD = ''' + lang + ''', T.TMZ_CD = ''' + tmz + ''', T.USE_YN = ''' + useyn + ''',' + CHAR(10)
         + '      T.N01_ATR_CTN = ' + a01 + ', T.N02_ATR_CTN = ' + a02 + ', T.N03_ATR_CTN = ' + a03 + ',' + CHAR(10)
         + '      T.N04_ATR_CTN = ' + a04 + ', T.N05_ATR_CTN = ' + a05 + ', T.N06_ATR_CTN = ' + a06 + ',' + CHAR(10)
         + '      T.N07_ATR_CTN = ' + a07 + ', T.N08_ATR_CTN = ' + a08 + ', T.N09_ATR_CTN = ' + a09 + ', T.N10_ATR_CTN = ' + a10 + ',' + CHAR(10)
         + '      T.LAST_UPDATED_BY = ''admin'', T.LAST_UPDATE_DATE = SYSDATE' + CHAR(10)
         + ' WHEN NOT MATCHED THEN INSERT' + CHAR(10)
         + '      (USER_ID, USER_NM, USER_ENG_NM, USER_EML, DEPT_ID, USER_PHN, USER_HPHN,' + CHAR(10)
         + '       LANG_CD, TMZ_CD, LOGN_DTM, USE_YN, ACNT_LOK_YN, PERM_KEP_CNC_YN,' + CHAR(10)
         + '       N01_ATR_CTN, N02_ATR_CTN, N03_ATR_CTN, N04_ATR_CTN, N05_ATR_CTN,' + CHAR(10)
         + '       N06_ATR_CTN, N07_ATR_CTN, N08_ATR_CTN, N09_ATR_CTN, N10_ATR_CTN,' + CHAR(10)
         + '       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)' + CHAR(10)
         + '      VALUES (''' + REPLACE(uid,'''','''''') + ''', ''' + nm + ''', ' + eng + ', ' + eml + ', ' + dept + ', ' + phn + ', ' + hphn + ',' + CHAR(10)
         + '       ''' + lang + ''', ''' + tmz + ''', ' + logn + ', ''' + useyn + ''', ''Y'', ''N'',' + CHAR(10)
         + '       ' + a01 + ', ' + a02 + ', ' + a03 + ', ' + a04 + ', ' + a05 + ',' + CHAR(10)
         + '       ' + a06 + ', ' + a07 + ', ' + a08 + ', ' + a09 + ', ' + a10 + ',' + CHAR(10)
         + '       ''admin'', SYSDATE, ''admin'', SYSDATE);'
      FROM U
    UNION ALL
    SELECT 9, '', 'COMMIT;'
  ) X
 ORDER BY ord, k;
