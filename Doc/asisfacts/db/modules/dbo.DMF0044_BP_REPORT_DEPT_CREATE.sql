
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




/*
 * Program ID   : DMF0044_BP_REPORT_DEPT_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191022    KYH			[CSR ID:4103445] 컬럼통합. attribute1, 2 --> attribute1
 * 20191023 kyh    Department_Name 가져오는 로직을 Sales Report 와 동일하게 Lookup 을 보도록 수정
 * 20191118 hwi1993 파라미터, 데이터타입 변경 및 Cancel 기능 추가
 *
 */

CREATE PROCEDURE [dbo].[DMF0044_BP_REPORT_DEPT_CREATE]
	@p_division_id            NVARCHAR(30),
	@p_version_no             NVARCHAR(50),
	@p_action_type            NVARCHAR(1),		-- T:Transfer, C:Cancel
	@p_yyyy                   NVARCHAR(4)

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[DMF0044_BP_REPORT_DEPT_CREATE]';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_delete_count    INTEGER = 0;
    DECLARE @n_merge_count     INTEGER = 0;

    -- local 변수선언
    DECLARE @yyyy           NVARCHAR(4);
    DECLARE @user_id        NVARCHAR(10) = 'mdf_batch';
    DECLARE @getdate        NVARCHAR(50) = GETDATE();
    

	
	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	---------------------------------------------------------------------------------------------------------------------------	
	BEGIN TRY
	---------------------------------------------------------------------------------------------------------------------------	

		----------------------------------------------------------------------------------------------------- 
		--                                                        중복 VERSION이 있는경우 삭제후 COPY (BEGIN)
		-----------------------------------------------------------------------------------------------------
		IF EXISTS ( SELECT 1 FROM DM_MOBILE_REPORT_DEPT WITH (NOLOCK) WHERE 1=1
									AND DIVISION_ID = @p_division_id
									AND VERSION_NO  = @p_version_no ) 
			BEGIN 
				DELETE FROM DM_MOBILE_REPORT_DEPT WHERE 1=1 
					AND DIVISION_ID = @p_division_id
					AND VERSION_NO  = @p_version_no
			END
		----------------------------------------------------------------------------------------------------- 
		--                                                        중복 VERSION이 있는경우 삭제후 COPY (END)
		-----------------------------------------------------------------------------------------------------

		----------------------------------------------------------------------------------------------------- 
		--                                                                           요청VERSION COPY (BEGIN)
		-----------------------------------------------------------------------------------------------------
		IF @p_action_type = 'T' -- 2019.11.19 HWI1993 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리
		BEGIN
			--------------------------------------------------------- TEMP TABLE 확인후 초기화
			IF OBJECT_ID (N'tempdb..#TEMP_REPORT_C', N'U') IS NOT NULL 
				DROP TABLE #TEMP_REPORT_C

            SELECT *
              INTO #TEMP_REPORT_C
              FROM DM_PLN_BP_FCST_REPORT_C WITH (NOLOCK)
             WHERE DIVISION_ID = @p_division_id
               AND VERSION_NO  = @p_version_no
            ;
			--------------------------------------------------------- TEMP TABLE 확인후 초기화
			    -- 연도 커서 선언
			DECLARE yyyyList CURSOR FOR
			SELECT A.YYYY
			  FROM (SELECT CONVERT(NVARCHAR,CONVERT(INT, @p_yyyy) - 1) AS YYYY
					UNION ALL
					SELECT @p_yyyy
					UNION ALL
					SELECT CONVERT(NVARCHAR,CONVERT(INT, @p_yyyy) + 1) AS YYYY
				   ) A

            OPEN yyyyList
            FETCH NEXT FROM yyyyList
            INTO @yyyy

            WHILE @@FETCH_STATUS = 0
            BEGIN
                INSERT INTO DM_MOBILE_REPORT_DEPT
                     ( DIVISION_ID
                     , VERSION_NO
                     , YYYY
                     , SP_BP_TYPE
                     , UPPER_DEPT_NAME
                     , DEPT_NAME
                     , CUST_INFO
                     , PRODUCT_NAME
                     , PRODUCT_DETAIL
                     , MEASURE
                     , MM01
                     , MM02
                     , MM03
                     , MM04
                     , MM05
                     , MM06
                     , MM07
                     , MM08
                     , MM09
                     , MM10
                     , MM11
                     , MM12
                     , ORI_VERSION_NO
                     , SORT_NO
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE )
                SELECT A.DIVISION_ID
                     , A.VERSION_NO
                     , A.YYYY
                     , A.SP_BP_TYPE
                     , A.DEPARTMENT_NAME
                     , A.DEPT_NAME
                     , A.CUST_REPORT     AS CUST_INFO
                     --, CASE WHEN A.DATA_TYPE = '1' THEN A.CUST_REPORT ELSE A.END_CUST_REPORT END AS CUST_INFO
                     , A.PRODUCT_NAME
                     , A.PRODUCT_DETAIL
                     , A.MEASURE
                     , SUM(CASE WHEN A.YYYYMM = @yyyy+'01' THEN QTY ELSE 0 END) AS MM01
                     , SUM(CASE WHEN A.YYYYMM = @yyyy+'02' THEN QTY ELSE 0 END) AS MM02
                     , SUM(CASE WHEN A.YYYYMM = @yyyy+'03' THEN QTY ELSE 0 END) AS MM03
                     , SUM(CASE WHEN A.YYYYMM = @yyyy+'04' THEN QTY ELSE 0 END) AS MM04
                     , SUM(CASE WHEN A.YYYYMM = @yyyy+'05' THEN QTY ELSE 0 END) AS MM05
                     , SUM(CASE WHEN A.YYYYMM = @yyyy+'06' THEN QTY ELSE 0 END) AS MM06
                     , SUM(CASE WHEN A.YYYYMM = @yyyy+'07' THEN QTY ELSE 0 END) AS MM07
                     , SUM(CASE WHEN A.YYYYMM = @yyyy+'08' THEN QTY ELSE 0 END) AS MM08
                     , SUM(CASE WHEN A.YYYYMM = @yyyy+'09' THEN QTY ELSE 0 END) AS MM09
                     , SUM(CASE WHEN A.YYYYMM = @yyyy+'10' THEN QTY ELSE 0 END) AS MM10
                     , SUM(CASE WHEN A.YYYYMM = @yyyy+'11' THEN QTY ELSE 0 END) AS MM11
                     , SUM(CASE WHEN A.YYYYMM = @yyyy+'12' THEN QTY ELSE 0 END) AS MM12
                     , @p_version_no AS ORI_VERSION_NO
                     , ROW_NUMBER() OVER(ORDER BY CASE WHEN A.DEPARTMENT_NAME = '' OR A.DEPARTMENT_NAME = N'기타' THEN N'힣' ELSE A.DEPARTMENT_NAME END
                                                 , CASE WHEN A.DEPT_NAME = 'MDF' THEN N'힣' ELSE A.DEPT_NAME END  
                                                 , A.DEPT_NAME
                                                 , B.DISPLAY_SEQ
     , A.MEASURE) AS SORT_NO
   , @user_id   AS CREATED_BY
                     , GETDATE()  AS CREATION_DATE
                     , @user_id   AS LAST_UPDATED_BY
                     , GETDATE()  AS LAST_UPDATE_DATE
                  FROM (SELECT C.DATA_TYPE
                             , C.DIVISION_ID
                             , C.VERSION_NO
                             , @yyyy         AS YYYY
                             , 'BP'          AS SP_BP_TYPE
							-- 20191023 kyh
							, ISNULL((SELECT SEGMENT2
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
									WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
									AND C.DEPARTMENT_ID = SEGMENT1),'')
								AS DEPARTMENT_NAME
							,  ISNULL((SELECT SEGMENT2
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
								WHERE LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'
								AND C.DEPT_ID = SEGMENT1), '')
								AS DEPT_NAME
                             , C.CUST_REPORT
                             , C.END_CUST_REPORT
                             , C.PRODUCT_GROUP AS PRODUCT_NAME
                             , ISNULL(C.ATTRIBUTE1,'') AS PRODUCT_DETAIL
                             , CASE WHEN C.MEASURE = 'Business_Plan' THEN 'RTF' ELSE C.MEASURE END MEASURE
                             , C.YYYYMM
                             , C.QTY
                          FROM #TEMP_REPORT_C C WITH (NOLOCK)
                         WHERE 1 = 1
                           AND C.DIVISION_ID = @p_division_id
                           AND C.VERSION_NO  = @p_version_no
                           AND C.MEASURE IN ('Business_Plan','SalesAmt_KRW')
                           AND C.YYYYMM LIKE @yyyy+'%'
                        ) A
                        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH (NOLOCK)
                          ON A.CUST_REPORT = B.SEGMENT1
                         AND B.LOOKUP_TYPE = 'REPORT_GROUP2'
                 GROUP BY A.DATA_TYPE
                     , A.DIVISION_ID
                     , A.VERSION_NO
                     , A.YYYY
                     , A.SP_BP_TYPE
                     , A.DEPARTMENT_NAME
                     , A.DEPT_NAME
                     , A.CUST_REPORT
                     --, CASE WHEN A.DATA_TYPE = '1' THEN A.CUST_REPORT ELSE A.END_CUST_REPORT END
                     , A.PRODUCT_NAME
                     , A.PRODUCT_DETAIL
                     , B.DISPLAY_SEQ
                     , A.MEASURE   
                ;

                FETCH NEXT FROM yyyyList
                INTO @yyyy

            END 

            CLOSE yyyyList
            DEALLOCATE yyyyList


		END

		----------------------------------------------------------------------------------------------------- 
		--     요청VERSION COPY (END)
		-----------------------------------------------------------------------------------------------------

 	---------------------------------------------------------------------------------------------------------------------------	
	END TRY
	---------------------------------------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
	BEGIN CATCH
	--------------------------------------------------------------	
		-- ROLLBACK
		-- ERROR LOG VALUE SAVE
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

	--------------------------------------------------------------	
	END CATCH;
	--------------------------------------------------------------	

	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
	SET @d_event_date = SYSDATETIME();

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END;
