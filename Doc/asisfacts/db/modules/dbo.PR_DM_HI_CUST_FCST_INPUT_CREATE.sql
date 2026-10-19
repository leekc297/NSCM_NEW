
/*
 * Program ID   : PR_DM_HI_CUST_FCST_INPUT_CREATE
 * Description  :
 * Program History
 *===================================================================================================
 *   Date          In Charge          Description
 *===================================================================================================
 * 2019. 04. 17    JSYOUN             Initial Release [CSR ID:4000521] GSCM Portal H/I 지표 운영 이관 요청 - Cust. FCST 입력률 생성
 * 2019. 08. 21    JSYOUN             [CSR ID:4067728] H/I 지표 산출 Raw Data 추가
   2022.04.05   HWI1993 GM JV 작업
 */

CREATE PROCEDURE [dbo].[PR_DM_HI_CUST_FCST_INPUT_CREATE]
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

    DECLARE @v_program_name     NVARCHAR(150) = 'PR_DM_HI_CUST_FCST_INPUT_CREATE';
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
          FROM DM_HI_CUST_FCST_INPUT
         WHERE VERSION_YYYYMMDD BETWEEN CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 1),112)
	                                AND CONVERT(VARCHAR,DATEADD(D, 6, DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 1)),112)
            -- OR VERSION_YYYYMMDD < CONVERT(VARCHAR,DATEADD(MM, -6, GETDATE()),112)  -- 과거데이터 삭제 (6개월이전)
        ;

        INSERT INTO DM_HI_CUST_FCST_INPUT (
             [VERSION_YYYYMMDD]
            ,[DIVISION_ID]
            ,[END_CUSTOMER]
            ,[SCM_SITE_ID]
            ,[PROJECT_CODE] -- [CSR ID:4067728] PROJECT_CODE 추가
            ,[DEPT_ID]
            ,[DEPT_NAME_KO]
            ,[ITEM_ID]
            ,[CUST_QTY]
            ,[QTY]
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
             , FCST.DIVISION_ID
			 , ISNULL(SITE.END_CUSTOMER,'')
			 , ISNULL(SITE.SCM_SITE_ID,'')
             , ISNULL(FCST.PROJECT_CODE,'') -- [CSR ID:4067728] PROJECT_CODE 추가
			 , ISNULL(SITE.DEPT_ID,'')
			 , ISNULL(DEPT.DEPT_NAME_KO,'')
			 , FCST.ITEM_ID
			 , SUM(CASE WHEN CUST.ITEM_ID IS NULL THEN 0 ELSE 1 END) AS CUST_QTY
			 , COUNT(1) AS QTY
             , @v_created_by
             , GETDATE()
             , @v_created_by
             , GETDATE()
             , @v_attribute1
             , @v_attribute2
             , @v_attribute3
             , NULL
             , NULL
		  FROM (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
					 , A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
				  FROM [DBO].[DM_PLN_MKT_FCST] A WITH (NOLOCK)
				 WHERE A.MEASURE = 'MKT_FCST'
				   AND A.YYYYMMDD BETWEEN CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 0),112)                     -- 당주 월요일
									  AND CONVERT(VARCHAR,DATEADD(DD,7*12-1,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 0)),112)  -- 당주월요일에서 12주
				 GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
					 , A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
			   ) FCST
			   LEFT OUTER JOIN (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
									 , A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
								  FROM [DBO].[DM_PLN_MKT_FCST] A WITH (NOLOCK)
								 WHERE (A.MEASURE = 'CUST_FCST' OR A.MEASURE IN (SELECT DISTINCT MEASURE
																				   FROM DM_MST_CUSTOMER_FCST WITH (NOLOCK)
																				  WHERE MEASURE_GROUP = 'CUST_FCST'
																				)
									   )
								   AND A.YYYYMMDD BETWEEN CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 0),112)                     -- 당주 월요일
													  AND CONVERT(VARCHAR,DATEADD(DD,7*12-1,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 0)),112)  -- 당주월요일에서 12주
								 GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
									 , A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
							   ) CUST
				 ON FCST.DIVISION_ID = CUST.DIVISION_ID
				AND FCST.[PROJECT_CODE] = CUST.[PROJECT_CODE]
				AND FCST.SCM_SITE_ID = CUST.SCM_SITE_ID
				AND FCST.ITEM_ID = CUST.ITEM_ID
				AND FCST.DOM_EXP = CUST.DOM_EXP
				AND FCST.FCST_TYPE = CUST.FCST_TYPE
				AND FCST.[INCOTERMS] = CUST.[INCOTERMS]
				AND FCST.PLANT_SITE_ID = CUST.PLANT_SITE_ID
			  INNER JOIN SCM_MST_SITE_ITEM SITE_ITEM WITH (NOLOCK)
				 ON FCST.DIVISION_ID = SITE_ITEM.DIVISION_ID
				AND FCST.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
				AND FCST.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID
				AND FCST.ITEM_ID = SITE_ITEM.ITEM_ID
               INNER JOIN DM_MST_ITEM_SINGLE_V ITEM WITH (NOLOCK)
                  ON ITEM.DIVISION_ID = FCST.DIVISION_ID
                 AND ITEM.ITEM_ID = FCST.ITEM_ID
			   INNER JOIN SCM_MST_SITE SITE WITH (NOLOCK)
				  ON FCST.DIVISION_ID = SITE.DIVISION_ID
				 AND FCST.SCM_SITE_ID = SITE.SCM_SITE_ID
				 AND SITE.SITE_TYPE = 'SALES'
				 AND SITE.VALID_YN = 'Y'
			   LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO DEPT WITH (NOLOCK)
				 ON DEPT.DEPT_ID = SITE.DEPT_ID
		 WHERE FCST.DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '81', '82' ) )
		   AND FCST.FCST_TYPE = 'MPS'
		   AND ITEM.ITEM_TYPE = 'P'
		 GROUP BY FCST.DIVISION_ID
			 , ISNULL(SITE.END_CUSTOMER,'')
			 , ISNULL(SITE.SCM_SITE_ID,'')
             , ISNULL(FCST.PROJECT_CODE,'') -- [CSR ID:4067728] PROJECT_CODE 추가
			 , ISNULL(SITE.DEPT_ID,'')
			 , ISNULL(DEPT.DEPT_NAME_KO,'')
			 , FCST.ITEM_ID

        UNION ALL

		SELECT @v_version_yyyymmdd
             , FCST.DIVISION_ID
			 , ISNULL(FCST.PROJECT_CODE,'')
			 , ISNULL(SITE.SCM_SITE_ID,'')
             , ''                            -- [CSR ID:4067728] PROJECT_CODE 추가
			 , ISNULL(DEPT.DEPT_ID,'')
			 , ISNULL(DEPT.DEPT_NAME_KO,'')
			 , FCST.ITEM_ID
			 , SUM(CASE WHEN CUST.ITEM_ID IS NULL THEN 0 ELSE 1 END) AS CUST_QTY
			 , COUNT(1) AS QTY
             , @v_created_by
             , GETDATE()
             , @v_created_by
             , GETDATE()
             , @v_attribute1
             , @v_attribute2
             , @v_attribute3
             , NULL
             , NULL
		  FROM (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
					 , A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
				  FROM [DBO].[DM_PLN_MKT_FCST] A WITH (NOLOCK)
				 WHERE A.MEASURE = 'MKT_FCST'
				   AND A.YYYYMMDD BETWEEN CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 0),112)                     -- 당주 월요일
									  AND CONVERT(VARCHAR,DATEADD(DD,7*12-1,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 0)),112)  -- 당주월요일에서 12주
				 GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
					 , A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
			   ) FCST
			   LEFT OUTER JOIN (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
									 , A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
								  FROM [DBO].[DM_PLN_MKT_FCST] A WITH (NOLOCK)
								 WHERE (A.MEASURE = 'CUST_FCST' OR A.MEASURE IN (SELECT DISTINCT MEASURE
																				   FROM DM_MST_CUSTOMER_FCST WITH (NOLOCK)
																				  WHERE MEASURE_GROUP = 'CUST_FCST'
																				)
									   )
								   AND A.YYYYMMDD BETWEEN CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 0),112)                     -- 당주 월요일
													  AND CONVERT(VARCHAR,DATEADD(DD,7*12-1,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 0)),112)  -- 당주월요일에서 12주
								 GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
									 , A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
							   ) CUST
				 ON FCST.DIVISION_ID = CUST.DIVISION_ID
				AND FCST.[PROJECT_CODE] = CUST.[PROJECT_CODE]
				AND FCST.SCM_SITE_ID = CUST.SCM_SITE_ID
				AND FCST.ITEM_ID = CUST.ITEM_ID
				AND FCST.DOM_EXP = CUST.DOM_EXP
				AND FCST.FCST_TYPE = CUST.FCST_TYPE
				AND FCST.[INCOTERMS] = CUST.[INCOTERMS]
				AND FCST.PLANT_SITE_ID = CUST.PLANT_SITE_ID
			   INNER JOIN SCM_MST_SITE_ITEM SITE_ITEM WITH (NOLOCK)
				 ON FCST.DIVISION_ID = SITE_ITEM.DIVISION_ID
				AND FCST.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
				AND FCST.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID
				AND FCST.ITEM_ID = SITE_ITEM.ITEM_ID
               INNER JOIN DM_MST_ITEM_SINGLE_V ITEM WITH (NOLOCK)
                  ON ITEM.DIVISION_ID = FCST.DIVISION_ID
                 AND ITEM.ITEM_ID = FCST.ITEM_ID
			   INNER JOIN SCM_MST_SITE SITE WITH (NOLOCK)
				  ON FCST.DIVISION_ID = SITE.DIVISION_ID
				 AND FCST.SCM_SITE_ID = SITE.SCM_SITE_ID
				 AND SITE.SITE_TYPE = 'SALES'
				 AND SITE.VALID_YN = 'Y'
			   LEFT JOIN (SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
							FROM [SCM_MST_SSO_USER_INFO] AS B
								 INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH (NOLOCK)
									ON B.DEPT_ID = C.DEPT_ID
						 ) AS DEPT
				 ON DEPT.USER_ID   IN (SELECT TOP 1 TOKEN FROM [DBO].[STRING_SPLIT](SITE_ITEM.OWNER, ','))
		 WHERE FCST.DIVISION_ID IN ('40')
		   AND FCST.FCST_TYPE = 'MPS'
		   AND ITEM.ITEM_TYPE = 'P'
		 GROUP BY FCST.DIVISION_ID
			 , ISNULL(FCST.PROJECT_CODE,'')
			 , ISNULL(SITE.SCM_SITE_ID,'')
			 , ISNULL(DEPT.DEPT_ID,'')
			 , ISNULL(DEPT.DEPT_NAME_KO,'')
			 , FCST.ITEM_ID
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
