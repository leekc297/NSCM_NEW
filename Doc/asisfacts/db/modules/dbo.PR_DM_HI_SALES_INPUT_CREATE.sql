/*
 * Program ID   : PR_DM_HI_SALES_INPUT_CREATE
 * Description  :
 * Program History
 *===================================================================================================
 *   Date          In Charge          Description
 *===================================================================================================
 * 2019. 04. 17    JSYOUN             Initial Release [CSR ID:4000521] GSCM Portal H/I 지표 운영 이관 요청 - Cust. FCST 입력률 생성
 * 2019. 08. 21    JSYOUN             [CSR ID:4067728] H/I 지표 산출 Raw Data 추가
 * 2019. 12. 10    HWI1993            공식 일부 수정. 1.모수를 SalesPostingDate로 변경, 2. 토.일요일이 PostingDate 일 경우 월요일 Input 까지 인정
 * 2021. 12. 27	   rosia27			  [C20211206-000339]HI - 적시 매출 처이율 산식 변경
   2022.04.06   hwi1993     GM JV 작업
 */


CREATE PROCEDURE [dbo].[PR_DM_HI_SALES_INPUT_CREATE]
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

    DECLARE @v_program_name     NVARCHAR(150) = 'PR_DM_HI_SALES_INPUT_CREATE';
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
	DECLARE @d_from_date		NCHAR(8);	-- from Date ( 월요일 )
	DECLARE @d_to_date			NCHAR(8);	-- to Date ( 다음주 월요일)
	DECLARE @d_origin_to_date	NCHAR(8);	-- to Date ( 다음주 일요일)

    SET @v_created_by        = 'HI_BATCH';
    SET @v_version_yyyymmdd  = CONVERT(VARCHAR, GETDATE(), 112);
    SET @v_time              = SUBSTRING(CONVERT(VARCHAR,GETDATE(),114),1,2);
	
	SELECT @d_from_date = CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 7, GETDATE()) / 7 , -0),112)
		, @d_origin_to_date = CONVERT(VARCHAR,DATEADD(DD,6,DATEADD(WK, DATEDIFF(D, 7, GETDATE()) / 7 , 0)),112)

	SET @d_to_date = CONVERT(NVARCHAR(8), DATEADD(DAY, 1, @d_origin_to_date), 112)
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
          FROM DM_HI_SALES_INPUT
         WHERE VERSION_YYYYMMDD BETWEEN CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 1),112)
	                                AND CONVERT(VARCHAR,DATEADD(D, 6, DATEADD(WK, DATEDIFF(D, 0, GETDATE()) / 7 , 1)),112)
            -- OR VERSION_YYYYMMDD < CONVERT(VARCHAR,DATEADD(MM, -6, GETDATE()),112)  -- 과거데이터 삭제 (6개월이전)
        ;

        INSERT INTO DM_HI_SALES_INPUT (
             [VERSION_YYYYMMDD]
            ,[DIVISION_ID]
            ,[END_CUSTOMER]
            ,[SCM_SITE_ID]
            ,[PROJECT_CODE] -- [CSR ID:4067728] PROJECT_CODE 추가
            ,[DEPT_ID]
            ,[DEPT_NAME_KO]
            ,[ITEM_ID]
            ,[INPUT_QTY]
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
			 , ISNULL(B.END_CUSTOMER,'')
			 , ISNULL(B.SCM_SITE_ID,'')
             , ISNULL(E.PROJECT_CODE,'') -- [CSR ID:4067728] PROJECT_CODE 추가
			 , ISNULL(B.DEPT_ID,'')
			 , ISNULL(C.DEPT_NAME_KO,'')
			 , A.ITEM_ID
			 , SUM(CASE WHEN (DBO.FN_GET_DIF_DAY(SALES_POSTING_DATE, SYSTEM_INPUT_DATE)) = 'TRUE' THEN 1 			
						ELSE 0 END) AS INPUT_QTY
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
		  FROM (SELECT DISTINCT DIVISION_ID, ITEM_ID,  SYSTEM_INPUT_DATE, SALES_POSTING_DATE
					 , PROJECT_CODE, SALES_SITE_ID, FCST_TYPE
				  FROM DM_DNM_SALES_RESULT_IF WITH (NOLOCK)
				 WHERE DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '81', '82' ) )
                   AND SALES_GROUP NOT IN ('X41','X81','X82','W41','W81','W82')  -- 사업부간, 사업본부간 거래는 제외
				   AND SALES_POSTING_DATE BETWEEN @d_from_date AND @d_origin_to_date	-- 2019.12.10
				   --AND SYSTEM_INPUT_DATE BETWEEN CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 7, GETDATE()) / 7 , -0),112)               
							--				 AND CONVERT(VARCHAR,DATEADD(DD,6,DATEADD(WK, DATEDIFF(D, 7, GETDATE()) / 7 , 0)),112)  
			   ) A
               INNER JOIN SCM_MST_SITE_ITEM E WITH (NOLOCK)
				  ON A.DIVISION_ID = E.DIVISION_ID
				 AND A.PROJECT_CODE = E.PROJECT_CODE
				 AND A.SALES_SITE_ID = E.SCM_SITE_ID
				 AND A.ITEM_ID = E.ITEM_ID
			   INNER JOIN SCM_MST_SITE B WITH (NOLOCK)
				  ON A.DIVISION_ID = B.DIVISION_ID
				 AND A.SALES_SITE_ID = B.SCM_SITE_ID
				 AND B.SITE_TYPE = 'SALES'
				 AND B.VALID_YN = 'Y'
			   INNER JOIN SCM_MST_SSO_DEPT_INFO C WITH (NOLOCK)
				  ON B.DEPT_ID = C.DEPT_ID
			   INNER JOIN DM_MST_ITEM_SINGLE_V D WITH (NOLOCK)
				  ON D.DIVISION_ID = A.DIVISION_ID
				 AND D.ITEM_ID = A.ITEM_ID
		 WHERE 1 = 1
		   AND A.FCST_TYPE = 'MPS'
		   AND D.ITEM_TYPE = 'P'
		 GROUP BY A.DIVISION_ID
			 , ISNULL(B.END_CUSTOMER,'')
			 , ISNULL(B.SCM_SITE_ID,'')
             , ISNULL(E.PROJECT_CODE,'') -- [CSR ID:4067728] PROJECT_CODE 추가
			 , ISNULL(B.DEPT_ID,'')
			 , ISNULL(C.DEPT_NAME_KO,'')
			 , A.ITEM_ID

        UNION ALL

		SELECT @v_version_yyyymmdd
             , A.DIVISION_ID
			 , ISNULL(A.PROJECT_CODE,'')
			 , ISNULL(B.SCM_SITE_ID,'')
             , ''
			 , ISNULL(C.DEPT_ID,'')
			 , ISNULL(C.DEPT_NAME_KO,'')
			 , A.ITEM_ID
			 , SUM(CASE WHEN (DBO.FN_GET_DIF_DAY(SALES_POSTING_DATE, SYSTEM_INPUT_DATE)) = 'TRUE' THEN 1 			
						ELSE 0 END) AS INPUT_QTY
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
		  FROM (SELECT DISTINCT DIVISION_ID, ITEM_ID,  SYSTEM_INPUT_DATE, SALES_POSTING_DATE
					 , PROJECT_CODE, SALES_SITE_ID, FCST_TYPE
				  FROM DM_DNM_SALES_RESULT_IF WITH (NOLOCK)
				 WHERE DIVISION_ID IN ('40')
                   AND SALES_GROUP NOT IN ('X41','X81','X82','W41','W81','W82')  -- 사업부간, 사업본부간 거래는 제외
				   AND SALES_POSTING_DATE BETWEEN @d_from_date AND @d_origin_to_date
				   --AND SYSTEM_INPUT_DATE BETWEEN CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(D, 7, GETDATE()) / 7 , -0),112)              
							--				 AND CONVERT(VARCHAR,DATEADD(DD,6,DATEADD(WK, DATEDIFF(D, 7, GETDATE()) / 7 , 0)),112) 
			   ) A
			   INNER JOIN SCM_MST_SITE_ITEM E WITH (NOLOCK)
				  ON A.DIVISION_ID = E.DIVISION_ID
				 AND A.PROJECT_CODE = E.PROJECT_CODE
				 AND A.SALES_SITE_ID = E.SCM_SITE_ID
				 AND A.ITEM_ID = E.ITEM_ID
			   INNER JOIN SCM_MST_SITE B WITH (NOLOCK)
				  ON A.DIVISION_ID = B.DIVISION_ID
				 AND A.SALES_SITE_ID = B.SCM_SITE_ID
				 AND B.SITE_TYPE = 'SALES'
				 AND B.VALID_YN = 'Y'
			   INNER JOIN DM_MST_ITEM_SINGLE_V D WITH (NOLOCK)
				  ON D.DIVISION_ID = A.DIVISION_ID
				 AND D.ITEM_ID = A.ITEM_ID
			   INNER JOIN (SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO , C.UPPER_DEPT_ID , B.JOB_NAME
					 		 FROM [SCM_MST_SSO_USER_INFO] AS B WITH (NOLOCK)
					 			  INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH (NOLOCK)
									 ON B.DEPT_ID = C.DEPT_ID
						  ) C
					ON C.USER_ID = CASE WHEN PATINDEX('%,%', E.OWNER) > 0 THEN LEFT(E.OWNER, PATINDEX('%,%', E.OWNER)-1)
										ELSE E.OWNER
										END
				  --ON C.USER_ID IN (SELECT TOP 1 TOKEN FROM [DBO].[STRING_SPLIT](E.OWNER, ','))
		 WHERE 1 = 1
		   AND A.FCST_TYPE = 'MPS'
		   AND D.ITEM_TYPE = 'P'  
		 GROUP BY A.DIVISION_ID
			 , ISNULL(A.PROJECT_CODE,'')
			 , ISNULL(B.SCM_SITE_ID,'')
			 , ISNULL(C.DEPT_ID,'')
			 , ISNULL(C.DEPT_NAME_KO,'')
			 , A.ITEM_ID
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


