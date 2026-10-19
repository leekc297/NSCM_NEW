
/*
 * Program ID   : PR_DM_HI_SITE_ITEM_MAPPING_CREATE
 * Description  :
 * Program History
 *===================================================================================================
 *   Date          In Charge          Description
 *===================================================================================================
 * 2019. 04. 17    JSYOUN             Initial Release [CSR ID:4000521] GSCM Portal H/I 지표 운영 이관 요청 - Site등록률, Site-모델Mapping률 생성
** 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
2022.04.05   hwi1993     GM JV 작업
 */


CREATE PROCEDURE [dbo].[PR_DM_HI_SITE_ITEM_MAPPING_CREATE]
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

    DECLARE @v_program_name     NVARCHAR(150) = 'PR_DM_HI_SITE_ITEM_MAPPING_CREATE';
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
    SET @v_time              = RIGHT(CONVERT(CHAR(19), GETDATE(), 0),3) + SUBSTRING(CONVERT(VARCHAR,GETDATE(),114),1,2);


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
             , @v_attribute3 = N'Today ' + @v_time + N' (KST)'
          FROM SCM_SYS_CALENDAR_M WITH (NOLOCK)
         WHERE BASIS_YYYYMMDD = @v_version_yyyymmdd
        ;

        DELETE
          FROM DM_HI_SITE_ITEM_MAPPING
         WHERE VERSION_YYYYMMDD = @v_version_yyyymmdd
            -- OR VERSION_YYYYMMDD < CONVERT(VARCHAR,DATEADD(MM, -6, GETDATE()),112)  -- 과거데이터 삭제 (6개월이전)
        ;

        INSERT INTO DM_HI_SITE_ITEM_MAPPING (
             [VERSION_YYYYMMDD]
            ,[DIVISION_ID]
            ,[END_CUSTOMER]
            ,[SCM_SITE_ID]
            ,[DEPT_ID]
            ,[DEPT_NAME_KO]
            ,[ITEM_ID]
            ,[ITEM_QTY]
            ,[SITE_QTY]
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
             , A.DIVISION_ID
			 , ISNULL(C.END_CUSTOMER,'')
			 , ISNULL(C.SCM_SITE_ID,'')
			 , ISNULL(C.DEPT_ID,'')
			 , ISNULL(D.DEPT_NAME_KO,'')
			 , A.ITEM_ID
			 , SUM(CASE WHEN B.DIVISION_ID IS NULL THEN 0 ELSE 1 END) AS ITEM_QTY
			 , SUM(CASE WHEN C.DIVISION_ID IS NULL THEN 0 ELSE 1 END) AS SITE_QTY
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
		  FROM (SELECT DISTINCT DIVISION_ID, ITEM_ID
					 , PROJECT_CODE, SALES_SITE_ID, FCST_TYPE 
                     , CUSTOMER_CODE AS SOLDTO_CODE
                     , SHIPTO_CODE
                  FROM DM_DNM_SALES_RESULT_IF WITH (NOLOCK)
                 WHERE SYSTEM_INPUT_DATE BETWEEN CONVERT(VARCHAR, DATEADD(DD, -30, GETDATE()), 112) AND CONVERT(VARCHAR, GETDATE(), 112)
		           AND DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN (  '81', '82' ) )
		           AND FCST_TYPE = 'MPS' -- 양산
		           AND ITEM_TYPE = N'제품'
                   AND SALES_GROUP NOT IN ('X41','X81','X82','W41','W81','W82')  -- 사업부간, 사업본부간 거래는 제외
                   AND SALES_SITE_ID NOT IN (
											--SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'INTERNAL_TXN'
											SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN WITH(NOLOCK)  -- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
											)
                ) A
			   LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK)
				 ON A.DIVISION_ID = B.DIVISION_ID
				AND A.PROJECT_CODE = B.PROJECT_CODE
				AND A.SALES_SITE_ID = B.SCM_SITE_ID
				AND A.ITEM_ID = B.ITEM_ID
			   LEFT OUTER JOIN SCM_MST_SITE C WITH (NOLOCK)
				 ON A.DIVISION_ID = C.DIVISION_ID
				AND A.SALES_SITE_ID = C.SCM_SITE_ID
			   LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D WITH (NOLOCK)
				 ON C.DEPT_ID = D.DEPT_ID
		 WHERE 1 = 1
		 GROUP BY A.DIVISION_ID
			 , ISNULL(C.END_CUSTOMER,'')
			 , ISNULL(C.SCM_SITE_ID,'')
			 , ISNULL(C.DEPT_ID,'')
			 , ISNULL(D.DEPT_NAME_KO,'')
			 , A.ITEM_ID

        UNION ALL

		SELECT @v_version_yyyymmdd
             , A.DIVISION_ID
			 , A.PROJECT_CODE
			 , ISNULL(C.SCM_SITE_ID,'')
			 , ISNULL(D.DEPT_ID,'')
			 , ISNULL(D.DEPT_NAME_KO,'')
			 , A.ITEM_ID
			 , SUM(CASE WHEN B.DIVISION_ID IS NULL THEN 0 ELSE 1 END) AS ITEM_QTY
			 , SUM(CASE WHEN C.DIVISION_ID IS NULL THEN 0 ELSE 1 END) AS SITE_QTY
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
		  FROM (SELECT DISTINCT DIVISION_ID, ITEM_ID
					 , PROJECT_CODE, SALES_SITE_ID, FCST_TYPE 
                     , CUSTOMER_CODE AS SOLDTO_CODE
                     , SHIPTO_CODE
                  FROM DM_DNM_SALES_RESULT_IF WITH (NOLOCK)
                 WHERE SYSTEM_INPUT_DATE BETWEEN CONVERT(VARCHAR, DATEADD(DD, -30, GETDATE()), 112) AND CONVERT(VARCHAR, GETDATE(), 112)
		           AND DIVISION_ID IN ('40')
		           AND FCST_TYPE = 'MPS' -- 양산
		           AND ITEM_TYPE = N'제품'
                   AND SALES_GROUP NOT IN ('X41','X81','X82','W41','W81','W82')  -- 사업부간, 사업본부간 거래는 제외
                   AND SALES_SITE_ID NOT IN (
											--SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'INTERNAL_TXN'
											SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN WITH(NOLOCK)  -- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
											)
                ) A
			   LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK)
				 ON A.DIVISION_ID = B.DIVISION_ID
				AND A.PROJECT_CODE = B.PROJECT_CODE
				AND A.SALES_SITE_ID = B.SCM_SITE_ID
				AND A.ITEM_ID = B.ITEM_ID
			   LEFT OUTER JOIN SCM_MST_SITE C WITH (NOLOCK)
				 ON A.DIVISION_ID = C.DIVISION_ID
				AND A.SALES_SITE_ID = C.SCM_SITE_ID
				--AND C.SITE_TYPE = 'SALES'
			   LEFT JOIN (SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
							FROM [SCM_MST_SSO_USER_INFO] AS B WITH (NOLOCK)
								 INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH (NOLOCK)
									ON B.DEPT_ID = C.DEPT_ID
						 ) AS D
				 ON D.USER_ID   IN (SELECT TOP 1 TOKEN FROM [DBO].[STRING_SPLIT](B.OWNER, ','))
		 WHERE 1 = 1
		 GROUP BY A.DIVISION_ID
			 , A.PROJECT_CODE
			 , ISNULL(C.SCM_SITE_ID,'')
			 , ISNULL(D.DEPT_ID,'')
			 , ISNULL(D.DEPT_NAME_KO,'')
			 , A.ITEM_ID
        ;

        DELETE
          FROM DM_HI_SITE_ITEM_MAPPING_ROWDATA
         WHERE VERSION_YYYYMMDD = @v_version_yyyymmdd
            -- OR VERSION_YYYYMMDD < CONVERT(VARCHAR,DATEADD(MM, -6, GETDATE()),112)  -- 과거데이터 삭제 (6개월이전)
        ;

        INSERT INTO DM_HI_SITE_ITEM_MAPPING_ROWDATA (
             [VERSION_YYYYMMDD]
            ,[DIVISION_ID]
            ,[SITE_ITEM_TYPE]
            ,[SOLDTO_CODE]
            ,[SHIPTO_CODE]
            ,[PROJECT_CODE]
            ,[ITEM_ID]
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
             , A.DIVISION_ID
             , 'SITE'
             , A.SOLDTO_CODE
             , A.SHIPTO_CODE
             , A.PROJECT_CODE
             , A.ITEM_ID
             , @v_created_by
             , GETDATE()
             , @v_created_by
             , GETDATE()
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM (SELECT DISTINCT DIVISION_ID, ITEM_ID
					 , PROJECT_CODE, SALES_SITE_ID, FCST_TYPE 
                     , CUSTOMER_CODE AS SOLDTO_CODE
                     , SHIPTO_CODE
                  FROM DM_DNM_SALES_RESULT_IF WITH (NOLOCK)
                 WHERE SYSTEM_INPUT_DATE BETWEEN CONVERT(VARCHAR, DATEADD(DD, -30, GETDATE()), 112) AND CONVERT(VARCHAR, GETDATE(), 112)
		           AND DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81', '82' ) )
		           AND FCST_TYPE = 'MPS' -- 양산
		           AND ITEM_TYPE = N'제품'
                   AND SALES_GROUP NOT IN ('X41','X81','X82','W41','W81','W82')  -- 사업부간, 사업본부간 거래는 제외
                   AND SALES_SITE_ID NOT IN (
											--SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'INTERNAL_TXN'
											SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN WITH(NOLOCK)  -- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
											)
                ) A
			   LEFT OUTER JOIN SCM_MST_SITE C WITH (NOLOCK)
				 ON A.DIVISION_ID = C.DIVISION_ID
				AND A.SALES_SITE_ID = C.SCM_SITE_ID
         WHERE C.DIVISION_ID IS NULL
        ;

        INSERT INTO DM_HI_SITE_ITEM_MAPPING_ROWDATA (
             [VERSION_YYYYMMDD]
            ,[DIVISION_ID]
            ,[SITE_ITEM_TYPE]
            ,[SOLDTO_CODE]
            ,[SHIPTO_CODE]
            ,[PROJECT_CODE]
            ,[ITEM_ID]
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
             , A.DIVISION_ID
             , 'ITEM'
             , A.SOLDTO_CODE
             , A.SHIPTO_CODE
             , A.PROJECT_CODE
             , A.ITEM_ID
             , @v_created_by
             , GETDATE()
             , @v_created_by
             , GETDATE()
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM (SELECT DISTINCT DIVISION_ID, ITEM_ID
					 , PROJECT_CODE, SALES_SITE_ID, FCST_TYPE 
                     , CUSTOMER_CODE AS SOLDTO_CODE
                     , SHIPTO_CODE
                  FROM DM_DNM_SALES_RESULT_IF WITH (NOLOCK)
                 WHERE SYSTEM_INPUT_DATE BETWEEN CONVERT(VARCHAR, DATEADD(DD, -30, GETDATE()), 112) AND CONVERT(VARCHAR, GETDATE(), 112)
		           AND DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81', '82' ) )
		           AND FCST_TYPE = 'MPS' -- 양산
		           AND ITEM_TYPE = N'제품'
                   AND SALES_GROUP NOT IN ('X41','X81','X82','W41','W81','W82')  -- 사업부간, 사업본부간 거래는 제외
                   AND SALES_SITE_ID NOT IN (
											--SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'INTERNAL_TXN'
											SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN WITH(NOLOCK)  -- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
											)
                ) A
			   LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK)
				 ON A.DIVISION_ID = B.DIVISION_ID
				AND A.PROJECT_CODE = B.PROJECT_CODE
				AND A.SALES_SITE_ID = B.SCM_SITE_ID
				AND A.ITEM_ID = B.ITEM_ID
         WHERE B.DIVISION_ID IS NULL
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
