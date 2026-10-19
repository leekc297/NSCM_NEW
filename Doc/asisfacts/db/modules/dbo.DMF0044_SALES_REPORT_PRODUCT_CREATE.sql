
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





/*
 * Program ID   : DMF0044_SALES_REPORT_PRODUCT_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191113 KYH 팩일 경우 QTY 조정
 * 20191118 hwi1993 파라미터 추가 및 데이터타입 변경, Cancel 기능 추가
 * 20200512 hwi1993 ETC 매출 테이블 추가
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE   PROCEDURE [dbo].[DMF0044_SALES_REPORT_PRODUCT_CREATE]
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
    DECLARE @v_program_name NVARCHAR(150) = '[DMF0044_SALES_REPORT_PRODUCT_CREATE]';
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
    DECLARE @ori_version_no NVARCHAR(50);
    

	
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
		IF EXISTS ( SELECT 1 FROM DM_MOBILE_REPORT_PRODUCT WITH (NOLOCK) WHERE 1=1
									AND DIVISION_ID = @p_division_id
									AND VERSION_NO  = @p_version_no ) 
			BEGIN 
				DELETE FROM DM_MOBILE_REPORT_PRODUCT WHERE 1=1 
					AND DIVISION_ID = @p_division_id
					AND VERSION_NO  = @p_version_no
			END

		----------------------------------------------------------------------------------------------------- 
		--                                                     중복 VERSION이 있는경우 삭제후 COPY (END)
		-----------------------------------------------------------------------------------------------------

		----------------------------------------------------------------------------------------------------- 
		--                                       요청VERSION COPY (BEGIN)
		-----------------------------------------------------------------------------------------------------
		IF @p_action_type = 'T' -- 2019.11.19 HWI1993 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리
		BEGIN
PRINT 'A--' + CONVERT(VARCHAR(30), GETDATE(), 121)			
			--------------------------------------------------------- TEMP TABLE 확인후 초기화
            SET @ori_version_no = (SELECT ORI_VERSION_NO FROM DM_MDF_VERSION WITH (NOLOCK) WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @p_version_no)
			IF OBJECT_ID (N'tempdb..#TEMP_REPORT_C', N'U') IS NOT NULL 
				DROP TABLE #TEMP_REPORT_C

            SELECT A.DIVISION_ID, A.PRODUCT_GROUP, CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF' ELSE A.MEASURE END AS MEASURE, A.YYYYMMDD, A.ATTRIBUTE1, A.ATTRIBUTE2
				, CASE WHEN A.MEASURE = 'RTF' AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0 THEN A.QTY * ISNULL(B.FORECAST_INFO_CELL_PACK_COUNT, 1)
					ELSE A.QTY 
					END AS QTY
			INTO #TEMP_REPORT_C
              FROM DM_PLN_SALES_PLAN_REPORT_C A WITH (NOLOCK)
				  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B WITH ( NOLOCK )
				    ON A.DIVISION_ID = B.DIVISION_ID 
						AND A.ITEM_ID = B.ITEM_ID
             WHERE A.DIVISION_ID = @p_division_id
               AND A.VERSION_NO  = @p_version_no
			   AND A.MEASURE IN ('RTF','Business_Plan','SalesAmt_KRW')
			UNION ALL
            SELECT A.DIVISION_ID, A.PRODUCT_GROUP, CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF' ELSE A.MEASURE END AS MEASURE, A.YYYYMMDD, A.ATTRIBUTE1, A.ATTRIBUTE2
				, CASE WHEN A.MEASURE = 'RTF' AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0 THEN A.QTY * ISNULL(B.FORECAST_INFO_CELL_PACK_COUNT, 1)
					ELSE A.QTY 
					END AS QTY
              FROM DM_PLN_SALES_ETC_REPORT_C A WITH (NOLOCK)
				  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B WITH ( NOLOCK )
				    ON A.DIVISION_ID = B.DIVISION_ID 
						AND A.ITEM_ID = B.ITEM_ID
             WHERE A.DIVISION_ID = @p_division_id
               AND A.VERSION_NO  = @p_version_no
			   AND A.MEASURE IN ('RTF','Business_Plan','SalesAmt_KRW')
            ;
			

PRINT 'B--' + CONVERT(VARCHAR(30), GETDATE(), 121)		
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
                INSERT INTO DM_MOBILE_REPORT_PRODUCT
                     ( DIVISION_ID
                     , VERSION_NO
                     , YYYY
                     , SP_BP_TYPE
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
                     , @p_version_no AS VERSION_NO
                     , @yyyy         AS YYYY
                     , 'SP'          AS SP_BP_TYPE
                     , A.PRODUCT_GROUP AS PRODUCT_NAME
                     , CASE WHEN A.PRODUCT_GROUP = N'파우치형' THEN ISNULL(A.ATTRIBUTE1,'#')
                            WHEN A.PRODUCT_GROUP = N'원통형' THEN ISNULL(A.ATTRIBUTE2,'#')
                            ELSE '#'
                       END           AS PRODUCT_DETAIL
                     , A.MEASURE
                     , SUM(CASE WHEN SUBSTRING(A.YYYYMMDD,1,6) = @yyyy+'01' THEN A.QTY ELSE 0 END) AS MM01
                     , SUM(CASE WHEN SUBSTRING(A.YYYYMMDD,1,6) = @yyyy+'02' THEN A.QTY ELSE 0 END) AS MM02
                     , SUM(CASE WHEN SUBSTRING(A.YYYYMMDD,1,6) = @yyyy+'03' THEN A.QTY ELSE 0 END) AS MM03
                     , SUM(CASE WHEN SUBSTRING(A.YYYYMMDD,1,6) = @yyyy+'04' THEN A.QTY ELSE 0 END) AS MM04
                     , SUM(CASE WHEN SUBSTRING(A.YYYYMMDD,1,6) = @yyyy+'05' THEN A.QTY ELSE 0 END) AS MM05
                     , SUM(CASE WHEN SUBSTRING(A.YYYYMMDD,1,6) = @yyyy+'06' THEN A.QTY ELSE 0 END) AS MM06
                     , SUM(CASE WHEN SUBSTRING(A.YYYYMMDD,1,6) = @yyyy+'07' THEN A.QTY ELSE 0 END) AS MM07
                     , SUM(CASE WHEN SUBSTRING(A.YYYYMMDD,1,6) = @yyyy+'08' THEN A.QTY ELSE 0 END) AS MM08
                     , SUM(CASE WHEN SUBSTRING(A.YYYYMMDD,1,6) = @yyyy+'09' THEN A.QTY ELSE 0 END) AS MM09
                     , SUM(CASE WHEN SUBSTRING(A.YYYYMMDD,1,6) = @yyyy+'10' THEN A.QTY ELSE 0 END) AS MM10
                     , SUM(CASE WHEN SUBSTRING(A.YYYYMMDD,1,6) = @yyyy+'11' THEN A.QTY ELSE 0 END) AS MM11
                     , SUM(CASE WHEN SUBSTRING(A.YYYYMMDD,1,6) = @yyyy+'12' THEN A.QTY ELSE 0 END) AS MM12
                     , @ori_version_no AS ORI_VERSION_NO
					 , B.DISPLAY_SEQ
                     , @user_id   AS CREATED_BY
                     , GETDATE()  AS CREATION_DATE
                     , @user_id   AS LAST_UPDATED_BY
                     , GETDATE()  AS LAST_UPDATE_DATE
                  FROM #TEMP_REPORT_C A WITH (NOLOCK)
				  LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH (NOLOCK)
					ON A.PRODUCT_GROUP = B.SEGMENT1
                         AND B.LOOKUP_TYPE = 'REPORT_GROUP2'
                 WHERE 1 = 1
                   AND A.YYYYMMDD LIKE @yyyy+'%'
                 GROUP BY A.DIVISION_ID
                     , A.PRODUCT_GROUP
                     , CASE WHEN A.PRODUCT_GROUP = N'파우치형' THEN ISNULL(A.ATTRIBUTE1,'')
                            WHEN A.PRODUCT_GROUP = N'원통형' THEN ISNULL(A.ATTRIBUTE2,'')
                            ELSE ''
                       END 
                     , A.MEASURE
					 , B.DISPLAY_SEQ
                ;
				
PRINT 'C--' + CONVERT(VARCHAR(30), GETDATE(), 121)		

              FETCH NEXT FROM yyyyList
                INTO @yyyy

            END 

            CLOSE yyyyList
            DEALLOCATE yyyyList


		END

		----------------------------------------------------------------------------------------------------- 
		--                                                                           요청VERSION COPY (END)
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
		
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
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

