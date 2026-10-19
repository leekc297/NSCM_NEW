
/*
 * Program ID   : PR_DM_HI_MKT_FCST_CHANGE_CREATE
 * Description  :
 * Program History
 *===================================================================================================
 *   Date          In Charge          Description
 *===================================================================================================
 * 2019. 04. 17    JSYOUN             Initial Release [CSR ID:4000521] GSCM Portal H/I 지표 운영 이관 요청 - MKT FCST 변동률 생성
 * 2019. 08. 21    JSYOUN             [CSR ID:4067728] H/I 지표 산출 Raw Data 추가
   2022.04.05   hwi1993     GM JV 작업
 */


CREATE PROCEDURE [dbo].[PR_DM_HI_MKT_FCST_CHANGE_CREATE]
AS

BEGIN

    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

    /*
        -----------------------------------------------------------------------------------------
        000
            : VARIABLE DECLARATION
        -----------------------------------------------------------------------------------------
    */

    DECLARE @v_program_name     NVARCHAR(150) = 'PR_DM_HI_MKT_FCST_CHANGE_CREATE';
    DECLARE @v_log_type         NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count        INTEGER = 0;
    DECLARE @v_log_message      NVARCHAR(1000);
    DECLARE @v_description      NVARCHAR(500);
    DECLARE @d_event_date       DATETIME;
    DECLARE @v_created_by       NVARCHAR(MAX);
    DECLARE @v_version_yyyymmdd NVARCHAR(MAX);
    DECLARE @v_attribute1       NVARCHAR(150);
    DECLARE @v_attribute2       NVARCHAR(150);
    DECLARE @v_attribute3       NVARCHAR(150);
    DECLARE @v_time             NVARCHAR(150);

    SET @v_created_by        = 'HI_BATCH';
    SET @v_version_yyyymmdd  = CONVERT(VARCHAR, GETDATE(), 112);
    SET @v_time              = SUBSTRING(CONVERT(VARCHAR,GETDATE(),114),1,2);


    /*
        -----------------------------------------------------------------------------------------
            : START LOG
        -----------------------------------------------------------------------------------------
    */
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

    BEGIN TRAN

    BEGIN TRY
        SELECT @v_attribute1 = ISO_YYYYWW + 'W'
             , @v_attribute2 = WEEK_NAME 
             , @v_attribute3 = ISO_YYYYWW + 'W'
          FROM SCM_SYS_CALENDAR_M WITH (NOLOCK)
         WHERE BASIS_YYYYMMDD = @v_version_yyyymmdd
        ;

        DELETE
          FROM DM_HI_MKT_FCST_CHANGE
         WHERE VERSION_YYYYMMDD BETWEEN CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 1),112)
	                                AND CONVERT(VARCHAR,DATEADD(D, 6, DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 1)),112)
            -- OR VERSION_YYYYMMDD < CONVERT(VARCHAR,DATEADD(MM, -6, GETDATE()),112)  -- 과거데이터 삭제 (6개월이전)
        ;

        WITH FCST_LIST AS
          (SELECT A.DIVISION_ID, ISNULL(C.END_CUSTOMER,'') AS END_CUSTOMER, ISNULL(A.SCM_SITE_ID,'') AS SCM_SITE_ID
                , ISNULL(C.DEPT_ID,'') AS DEPT_ID, ISNULL(D.DEPT_NAME_KO,'') AS DEPT_NAME_KO, A.ITEM_ID
                , ISNULL(A.PROJECT_CODE,'') AS PROJECT_CODE  -- [CSR ID:4067728] PROJECT_CODE 추가
                --, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.MEASURE
                , 'W'+CONVERT(VARCHAR,DATEPART(ISO_WEEK, A.YYYYMMDD)) AS WEEK_NAME
                , CASE WHEN B.YYYYMMDD = CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 1),112) THEN 'CURRENT'
                       ELSE 'BEFORE'
                  END AS WEEK_TYPE
                , SUM(A.QTY) AS QTY
             FROM DM_PLN_MKT_FCST_C A WITH (NOLOCK)
                  INNER JOIN (SELECT DIVISION_ID, YYYYMMDD, MAX(VERSION_NO) AS VERSION_NO
                                FROM DM_MST_VERSION WITH (NOLOCK)
                               WHERE VERSION_TYPE = 'MF_W'
                                 AND (YYYYMMDD = CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 1),112)
                                      OR
                                      YYYYMMDD = CONVERT(VARCHAR,DATEADD(D, -7, DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 1)),112)
                                     )
                               GROUP BY DIVISION_ID, YYYYMMDD
                              ) B
                     ON A.DIVISION_ID = B.DIVISION_ID
                    AND A.VERSION_NO = B.VERSION_NO
                  INNER JOIN DM_MST_ITEM_SINGLE_V I WITH (NOLOCK)
                     ON I.DIVISION_ID = A.DIVISION_ID
                    AND I.ITEM_ID = A.ITEM_ID
			      INNER JOIN SCM_MST_SITE_ITEM S WITH (NOLOCK)
				    ON A.DIVISION_ID = S.DIVISION_ID
				   AND A.PROJECT_CODE = S.PROJECT_CODE
				   AND A.SCM_SITE_ID = S.SCM_SITE_ID
				   AND A.ITEM_ID = S.ITEM_ID
                  INNER JOIN SCM_MST_SITE C WITH (NOLOCK)
                    ON A.DIVISION_ID = C.DIVISION_ID
                   AND A.SCM_SITE_ID = C.SCM_SITE_ID
                   AND C.SITE_TYPE = 'SALES'
                   AND C.VALID_YN = 'Y'
                  LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D WITH (NOLOCK)
                    ON C.DEPT_ID = D.DEPT_ID
            WHERE A.MEASURE = 'MKT_FCST'
              AND A.DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '81', '82' ) )
              AND A.FCST_TYPE = 'MPS'
              AND I.ITEM_TYPE = 'P'
              AND A.YYYYMMDD BETWEEN CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 0),112)
                                 AND CONVERT(VARCHAR,DATEADD(DD,7*12-1,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 0)),112)
            GROUP BY A.DIVISION_ID, ISNULL(C.END_CUSTOMER,''), ISNULL(A.SCM_SITE_ID,'')
                , ISNULL(C.DEPT_ID,''), ISNULL(D.DEPT_NAME_KO,''), A.ITEM_ID
                , ISNULL(A.PROJECT_CODE,'')  -- [CSR ID:4067728] PROJECT_CODE 추가
                , 'W'+CONVERT(VARCHAR,DATEPART(ISO_WEEK, A.YYYYMMDD))
                , CASE WHEN B.YYYYMMDD = CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 1),112) THEN 'CURRENT'
                       ELSE 'BEFORE'
                  END
          )
        , WEEK_INFO AS
          (SELECT DISTINCT ISO_YYYYWW, WEEK_NAME
             FROM SCM_SYS_CALENDAR_M WITH (NOLOCK)
            WHERE BASIS_YYYYMMDD BETWEEN CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 0),112)
                                     AND CONVERT(VARCHAR,DATEADD(DD,7*12-1,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 0)),112)
          )
        , ITEM_INFO AS
          (SELECT DISTINCT A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID
                , A.PROJECT_CODE  -- [CSR ID:4067728] PROJECT_CODE 추가
                , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
                --, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                , B.WEEK_NAME, B.ISO_YYYYWW
             FROM FCST_LIST A
                  INNER JOIN WEEK_INFO B
                     ON 1 = 1
          )
        , LIST_CUR AS
          (SELECT A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID
                , A.PROJECT_CODE  -- [CSR ID:4067728] PROJECT_CODE 추가
                , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
                --, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                , CASE WHEN B.DIVISION_ID IS NULL THEN 0 ELSE B.QTY END AS QTY
                , ROW_NUMBER() OVER( ORDER BY A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, A.ISO_YYYYWW)%12 AS RN
             FROM ITEM_INFO A
                  LEFT OUTER JOIN FCST_LIST B
                    ON A.DIVISION_ID = B.DIVISION_ID
                   AND A.SCM_SITE_ID = B.SCM_SITE_ID
                   AND A.PROJECT_CODE = B.PROJECT_CODE  -- [CSR ID:4067728] PROJECT_CODE 추가
                   AND A.ITEM_ID = B.ITEM_ID
                   AND A.WEEK_NAME = B.WEEK_NAME
                   AND B.WEEK_TYPE = 'CURRENT'
            GROUP BY A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID
                   , A.PROJECT_CODE  -- [CSR ID:4067728] PROJECT_CODE 추가
                   , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
                   , CASE WHEN B.DIVISION_ID IS NULL THEN 0 ELSE B.QTY END
                   , A.ISO_YYYYWW
          )
        , LIST_LAST AS
          (SELECT A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID
                , A.PROJECT_CODE  -- [CSR ID:4067728] PROJECT_CODE 추가
                , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
                --, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                , CASE WHEN B.DIVISION_ID IS NULL THEN 0 ELSE B.QTY END AS QTY
                , ROW_NUMBER() OVER( ORDER BY A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, A.ISO_YYYYWW)%12 AS RN
             FROM ITEM_INFO A
                  LEFT OUTER JOIN FCST_LIST B
                    ON A.DIVISION_ID = B.DIVISION_ID
                   AND A.SCM_SITE_ID = B.SCM_SITE_ID
                   AND A.ITEM_ID = B.ITEM_ID
                   AND A.WEEK_NAME = B.WEEK_NAME
                   AND B.WEEK_TYPE = 'BEFORE'
            GROUP BY A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID
                   , A.PROJECT_CODE  -- [CSR ID:4067728] PROJECT_CODE 추가
                   , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
                   , CASE WHEN B.DIVISION_ID IS NULL THEN 0 ELSE B.QTY END
                   , A.ISO_YYYYWW
          )

        INSERT INTO DM_HI_MKT_FCST_CHANGE (
             [VERSION_YYYYMMDD]
            ,[DIVISION_ID]
            ,[END_CUSTOMER]
            ,[SCM_SITE_ID]
            ,[PROJECT_CODE] -- [CSR ID:4067728] PROJECT_CODE 추가
            ,[DEPT_ID]
            ,[DEPT_NAME_KO]
            ,[ITEM_ID]
            ,[WEEK_TYPE]
            ,[W1]
            ,[W2]
            ,[W3]
            ,[W4]
            ,[W5]
            ,[W6]
            ,[W7]
            ,[W8]
            ,[W9]
            ,[W10]
            ,[W11]
            ,[W12]
            ,[CREATED_BY]
            ,[CREATION_DATE]
            ,[LAST_UPDATED_BY]
            ,[LAST_UPDATE_DATE]
            ,[ATTRIBUTE1]
            ,[ATTRIBUTE2]
            ,[ATTRIBUTE3]
            ,[ATTRIBUTE4]
            ,[ATTRIBUTE5] )
        SELECT @v_version_yyyymmdd
             , A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID
             , A.PROJECT_CODE  -- [CSR ID:4067728] PROJECT_CODE 추가
             , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
             , 'CURRENT' AS WEEK_TYPE
             , SUM(CASE WHEN A.RN = 1 THEN A.QTY ELSE 0 END) AS W1
             , SUM(CASE WHEN A.RN = 2 THEN A.QTY ELSE 0 END) AS W2
             , SUM(CASE WHEN A.RN = 3 THEN A.QTY ELSE 0 END) AS W3
             , SUM(CASE WHEN A.RN = 4 THEN A.QTY ELSE 0 END) AS W4
             , SUM(CASE WHEN A.RN = 5 THEN A.QTY ELSE 0 END) AS W5
             , SUM(CASE WHEN A.RN = 6 THEN A.QTY ELSE 0 END) AS W6
             , SUM(CASE WHEN A.RN = 7 THEN A.QTY ELSE 0 END) AS W7
             , SUM(CASE WHEN A.RN = 8 THEN A.QTY ELSE 0 END) AS W8
             , SUM(CASE WHEN A.RN = 9 THEN A.QTY ELSE 0 END) AS W9
             , SUM(CASE WHEN A.RN = 10 THEN A.QTY ELSE 0 END) AS W10
             , SUM(CASE WHEN A.RN = 11 THEN A.QTY ELSE 0 END) AS W11
             , SUM(CASE WHEN A.RN = 0 THEN A.QTY ELSE 0 END) AS W12
             , @v_created_by
             , GETDATE()
             , @v_created_by
             , GETDATE()
             , @v_attribute1
             , @v_attribute2
             , @v_attribute3
             , NULL
             , NULL
          FROM LIST_CUR A
         GROUP BY A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID
             , A.PROJECT_CODE  -- [CSR ID:4067728] PROJECT_CODE 추가
             , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
        UNION ALL
        SELECT @v_version_yyyymmdd
             , A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID
             , A.PROJECT_CODE  -- [CSR ID:4067728] PROJECT_CODE 추가
             , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
             , 'BEFORE' AS WEEK_TYPE
             , SUM(CASE WHEN A.RN = 1 THEN A.QTY ELSE 0 END) AS W1
             , SUM(CASE WHEN A.RN = 2 THEN A.QTY ELSE 0 END) AS W2
             , SUM(CASE WHEN A.RN = 3 THEN A.QTY ELSE 0 END) AS W3
             , SUM(CASE WHEN A.RN = 4 THEN A.QTY ELSE 0 END) AS W4
             , SUM(CASE WHEN A.RN = 5 THEN A.QTY ELSE 0 END) AS W5
             , SUM(CASE WHEN A.RN = 6 THEN A.QTY ELSE 0 END) AS W6
             , SUM(CASE WHEN A.RN = 7 THEN A.QTY ELSE 0 END) AS W7
             , SUM(CASE WHEN A.RN = 8 THEN A.QTY ELSE 0 END) AS W8
             , SUM(CASE WHEN A.RN = 9 THEN A.QTY ELSE 0 END) AS W9
             , SUM(CASE WHEN A.RN = 10 THEN A.QTY ELSE 0 END) AS W10
             , SUM(CASE WHEN A.RN = 11 THEN A.QTY ELSE 0 END) AS W11
             , SUM(CASE WHEN A.RN = 0 THEN A.QTY ELSE 0 END) AS W12
             , @v_created_by
             , GETDATE()
             , @v_created_by
             , GETDATE()
             , @v_attribute1
             , @v_attribute2
             , @v_attribute3
             , NULL
             , NULL
          FROM LIST_LAST A
         GROUP BY A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID
             , A.PROJECT_CODE  -- [CSR ID:4067728] PROJECT_CODE 추가
             , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
        ;

        WITH FCST_LIST AS
          (SELECT A.DIVISION_ID, ISNULL(A.PROJECT_CODE,'') AS PROJECT_CODE, ISNULL(A.SCM_SITE_ID,'') AS SCM_SITE_ID
                , ISNULL(D.DEPT_ID,'') AS DEPT_ID, ISNULL(D.DEPT_NAME_KO,'') AS DEPT_NAME_KO, A.ITEM_ID
                --, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.MEASURE
                , 'W'+CONVERT(VARCHAR,DATEPART(ISO_WEEK, A.YYYYMMDD)) AS WEEK_NAME
                , CASE WHEN B.YYYYMMDD = CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 1),112) THEN 'CURRENT'
                       ELSE 'BEFORE'
                  END AS WEEK_TYPE
                , SUM(A.QTY) AS QTY
             FROM DM_PLN_MKT_FCST_C A WITH (NOLOCK)
                  INNER JOIN (SELECT DIVISION_ID, YYYYMMDD, MAX(VERSION_NO) AS VERSION_NO
                                FROM DM_MST_VERSION WITH (NOLOCK)
                               WHERE VERSION_TYPE = 'MF_W'
                                 AND (YYYYMMDD = CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 1),112)
                                      OR
                                      YYYYMMDD = CONVERT(VARCHAR,DATEADD(D, -7, DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 1)),112)
                                      )
                                GROUP BY DIVISION_ID, YYYYMMDD
                              ) B
                     ON A.DIVISION_ID = B.DIVISION_ID
                    AND A.VERSION_NO = B.VERSION_NO
                  INNER JOIN DM_MST_ITEM_SINGLE_V I WITH (NOLOCK)
                     ON I.DIVISION_ID = A.DIVISION_ID
                    AND I.ITEM_ID = A.ITEM_ID
			      INNER JOIN SCM_MST_SITE_ITEM S WITH (NOLOCK)
				    ON A.DIVISION_ID = S.DIVISION_ID
				   AND A.PROJECT_CODE = S.PROJECT_CODE
				   AND A.SCM_SITE_ID = S.SCM_SITE_ID
				   AND A.ITEM_ID = S.ITEM_ID
                  INNER JOIN SCM_MST_SITE C WITH (NOLOCK)
                    ON A.DIVISION_ID = C.DIVISION_ID
                   AND A.SCM_SITE_ID = C.SCM_SITE_ID
                   AND C.SITE_TYPE = 'SALES'
                   AND C.VALID_YN = 'Y'
			      LEFT JOIN (SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
					           FROM [SCM_MST_SSO_USER_INFO] AS B WITH (NOLOCK)
								    INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH (NOLOCK)
									   ON B.DEPT_ID = C.DEPT_ID
						    ) AS D
				 ON D.USER_ID   IN (SELECT TOP 1 TOKEN FROM [DBO].[STRING_SPLIT](S.OWNER, ','))
            WHERE A.MEASURE = 'MKT_FCST'
              AND A.DIVISION_ID IN ('40')
              AND A.FCST_TYPE = 'MPS'
              AND I.ITEM_TYPE = 'P'
              AND A.YYYYMMDD BETWEEN CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 0),112)
                                 AND CONVERT(VARCHAR,DATEADD(DD,7*12-1,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 0)),112)
            GROUP BY A.DIVISION_ID, ISNULL(A.PROJECT_CODE,''), ISNULL(A.SCM_SITE_ID,'')
                , ISNULL(D.DEPT_ID,''), ISNULL(D.DEPT_NAME_KO,''), A.ITEM_ID
                , 'W'+CONVERT(VARCHAR,DATEPART(ISO_WEEK, A.YYYYMMDD))
                , CASE WHEN B.YYYYMMDD = CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 1),112) THEN 'CURRENT'
                       ELSE 'BEFORE'
                  END
          )
        , WEEK_INFO AS
          (SELECT DISTINCT ISO_YYYYWW, WEEK_NAME
             FROM SCM_SYS_CALENDAR_M WITH (NOLOCK)
            WHERE BASIS_YYYYMMDD BETWEEN CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 0),112)
                                     AND CONVERT(VARCHAR,DATEADD(DD,7*12-1,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 0)),112)
          )
        , ITEM_INFO AS
          (SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
                --, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                , B.WEEK_NAME, B.ISO_YYYYWW
             FROM FCST_LIST A
                  INNER JOIN WEEK_INFO B
                     ON 1 = 1
          )
        , LIST_CUR AS
          (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
                --, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                , CASE WHEN B.DIVISION_ID IS NULL THEN 0 ELSE B.QTY END AS QTY
                , ROW_NUMBER() OVER( ORDER BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.ISO_YYYYWW)%12 AS RN
             FROM ITEM_INFO A
                  LEFT OUTER JOIN FCST_LIST B
                    ON A.DIVISION_ID = B.DIVISION_ID
                   AND A.SCM_SITE_ID = B.SCM_SITE_ID
                   AND A.ITEM_ID = B.ITEM_ID
                   AND A.WEEK_NAME = B.WEEK_NAME
                   AND B.WEEK_TYPE = 'CURRENT'
            GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
                   , CASE WHEN B.DIVISION_ID IS NULL THEN 0 ELSE B.QTY END
                   , A.ISO_YYYYWW
          )
        , LIST_LAST AS
          (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
                --, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                , CASE WHEN B.DIVISION_ID IS NULL THEN 0 ELSE B.QTY END AS QTY
                , ROW_NUMBER() OVER( ORDER BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.ISO_YYYYWW)%12 AS RN
             FROM ITEM_INFO A
                  LEFT OUTER JOIN FCST_LIST B
                    ON A.DIVISION_ID = B.DIVISION_ID
                   AND A.SCM_SITE_ID = B.SCM_SITE_ID
                   AND A.ITEM_ID = B.ITEM_ID
                   AND A.WEEK_NAME = B.WEEK_NAME
                   AND B.WEEK_TYPE = 'BEFORE'
            GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
                   , CASE WHEN B.DIVISION_ID IS NULL THEN 0 ELSE B.QTY END
                   , A.ISO_YYYYWW
          )

        INSERT INTO DM_HI_MKT_FCST_CHANGE (
             [VERSION_YYYYMMDD]
            ,[DIVISION_ID]
            ,[END_CUSTOMER]
            ,[SCM_SITE_ID]
            ,[PROJECT_CODE] -- [CSR ID:4067728] PROJECT_CODE 추가
            ,[DEPT_ID]
            ,[DEPT_NAME_KO]
            ,[ITEM_ID]
            ,[WEEK_TYPE]
            ,[W1]
            ,[W2]
            ,[W3]
            ,[W4]
            ,[W5]
            ,[W6]
            ,[W7]
            ,[W8]
            ,[W9]
            ,[W10]
            ,[W11]
            ,[W12]
            ,[CREATED_BY]
            ,[CREATION_DATE]
            ,[LAST_UPDATED_BY]
            ,[LAST_UPDATE_DATE]
            ,[ATTRIBUTE1]
            ,[ATTRIBUTE2]
            ,[ATTRIBUTE3]
            ,[ATTRIBUTE4]
            ,[ATTRIBUTE5] )
        SELECT @v_version_yyyymmdd
             , A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
             , ''  -- [CSR ID:4067728] PROJECT_CODE 추가
             , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
             , 'CURRENT' AS WEEK_TYPE
             , SUM(CASE WHEN A.RN = 1 THEN A.QTY ELSE 0 END) AS W1
             , SUM(CASE WHEN A.RN = 2 THEN A.QTY ELSE 0 END) AS W2
             , SUM(CASE WHEN A.RN = 3 THEN A.QTY ELSE 0 END) AS W3
             , SUM(CASE WHEN A.RN = 4 THEN A.QTY ELSE 0 END) AS W4
             , SUM(CASE WHEN A.RN = 5 THEN A.QTY ELSE 0 END) AS W5
             , SUM(CASE WHEN A.RN = 6 THEN A.QTY ELSE 0 END) AS W6
             , SUM(CASE WHEN A.RN = 7 THEN A.QTY ELSE 0 END) AS W7
             , SUM(CASE WHEN A.RN = 8 THEN A.QTY ELSE 0 END) AS W8
             , SUM(CASE WHEN A.RN = 9 THEN A.QTY ELSE 0 END) AS W9
             , SUM(CASE WHEN A.RN = 10 THEN A.QTY ELSE 0 END) AS W10
             , SUM(CASE WHEN A.RN = 11 THEN A.QTY ELSE 0 END) AS W11
             , SUM(CASE WHEN A.RN = 0 THEN A.QTY ELSE 0 END) AS W12
             , @v_created_by
             , GETDATE()
             , @v_created_by
             , GETDATE()
             , @v_attribute1
             , @v_attribute2
             , @v_attribute3
             , NULL
             , NULL
          FROM LIST_CUR A
         GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
             , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
        UNION ALL
        SELECT @v_version_yyyymmdd
             , A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
             , ''  -- [CSR ID:4067728] PROJECT_CODE 추가
             , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
             , 'BEFORE' AS WEEK_TYPE
             , SUM(CASE WHEN A.RN = 1 THEN A.QTY ELSE 0 END) AS W1
             , SUM(CASE WHEN A.RN = 2 THEN A.QTY ELSE 0 END) AS W2
             , SUM(CASE WHEN A.RN = 3 THEN A.QTY ELSE 0 END) AS W3
             , SUM(CASE WHEN A.RN = 4 THEN A.QTY ELSE 0 END) AS W4
             , SUM(CASE WHEN A.RN = 5 THEN A.QTY ELSE 0 END) AS W5
             , SUM(CASE WHEN A.RN = 6 THEN A.QTY ELSE 0 END) AS W6
             , SUM(CASE WHEN A.RN = 7 THEN A.QTY ELSE 0 END) AS W7
             , SUM(CASE WHEN A.RN = 8 THEN A.QTY ELSE 0 END) AS W8
             , SUM(CASE WHEN A.RN = 9 THEN A.QTY ELSE 0 END) AS W9
             , SUM(CASE WHEN A.RN = 10 THEN A.QTY ELSE 0 END) AS W10
             , SUM(CASE WHEN A.RN = 11 THEN A.QTY ELSE 0 END) AS W11
             , SUM(CASE WHEN A.RN = 0 THEN A.QTY ELSE 0 END) AS W12
             , @v_created_by
             , GETDATE()
             , @v_created_by
             , GETDATE()
             , @v_attribute1
             , @v_attribute2
             , @v_attribute3
             , NULL
             , NULL
          FROM LIST_LAST A
         GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
             , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_ID
        ;

        COMMIT TRAN ;

    END TRY

    /*
        -----------------------------------------------------------------------------------------
        300
            : ERROR TRAP
        -----------------------------------------------------------------------------------------
    */
    BEGIN CATCH
        ROLLBACK TRAN ;

        SET @v_log_type = 'ERROR';
        SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
        SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
        SET @d_event_date = SYSDATETIME();

        SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    SET NOCOUNT OFF;

    /*
        -----------------------------------------------------------------------------------------
            : END LOG
        -----------------------------------------------------------------------------------------
    */

    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
