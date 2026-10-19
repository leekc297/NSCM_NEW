---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





/*
 * Program ID   : DMF0044_BP_REPORT_EXCHANGE_RATE_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE - 사업계획통화환율
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191101 KYH    환율 AVG 계산이 틀려서 null 로 변경함
 * 20191106 KYH		월별환율에 NULL 처리 추가
 * 20191118 hwi1993 파라미터 추가, Cancel 기능 추가, 데이터타입 변경
 */

 CREATE PROCEDURE [dbo].[DMF0044_BP_REPORT_EXCHANGE_RATE_CREATE]
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
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0044_BP_REPORT_EXCHANGE_RATE_CREATE';
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
		IF EXISTS ( SELECT 1 FROM DM_MOBILE_REPORT_EXCHANGE_RATE WITH (NOLOCK) WHERE 1=1
									AND DIVISION_ID = @p_division_id
									AND VERSION_NO  = @p_version_no ) 
			BEGIN 
				DELETE FROM DM_MOBILE_REPORT_EXCHANGE_RATE WHERE 1=1 
					AND DIVISION_ID = @p_division_id
					AND VERSION_NO  = @p_version_no
			END

		----------------------------------------------------------------------------------------------------- 
		--                                                        중복 VERSION이 있는경우 삭제후 COPY (END)
		-----------------------------------------------------------------------------------------------------

		----------------------------------------------------------------------------------------------------- 
		--                                                                         요청VERSION COPY (BEGIN)
		-----------------------------------------------------------------------------------------------------
		IF @p_action_type = 'T' -- 2019.11.19 HWI1993 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리
		BEGIN
			--------------------------------------------------------- TEMP TABLE 확인후 초기화
			IF OBJECT_ID (N'tempdb..#TEMP_EXCHANGE_C', N'U') IS NOT NULL 
				DROP TABLE #TEMP_EXCHANGE_C

            SELECT *
              INTO #TEMP_EXCHANGE_C
              FROM DM_BP_EXCHANGE_RATE_C WITH (NOLOCK)
             WHERE DIVISION_ID = @p_division_id
               AND VERSION_NO  = SUBSTRING(@p_version_no,8,18)
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
                INSERT INTO DM_MOBILE_REPORT_EXCHANGE_RATE
                     ( DIVISION_ID
                     , VERSION_NO
                     , YYYY
                     , SP_BP_TYPE
                     , CURRENCY
                     , UNIT_CURRENCY
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
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE )
                SELECT DIVISION_ID
                     , @p_version_no
                     , @yyyy         AS YYYY
                     , 'BP'          AS SP_BP_TYPE
                     , CURRENCY
                     , UNIT_CURRENCY
                     , ISNULL(AVG(CASE WHEN SUBSTRING(YYYYMMDD,1,6) = @yyyy+'01' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM01
                     , ISNULL(AVG(CASE WHEN SUBSTRING(YYYYMMDD,1,6) = @yyyy+'02' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM02
                     , ISNULL(AVG(CASE WHEN SUBSTRING(YYYYMMDD,1,6) = @yyyy+'03' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM03
                     , ISNULL(AVG(CASE WHEN SUBSTRING(YYYYMMDD,1,6) = @yyyy+'04' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM04
                     , ISNULL(AVG(CASE WHEN SUBSTRING(YYYYMMDD,1,6) = @yyyy+'05' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM05
                     , ISNULL(AVG(CASE WHEN SUBSTRING(YYYYMMDD,1,6) = @yyyy+'06' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM06
                     , ISNULL(AVG(CASE WHEN SUBSTRING(YYYYMMDD,1,6) = @yyyy+'07' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM07
                     , ISNULL(AVG(CASE WHEN SUBSTRING(YYYYMMDD,1,6) = @yyyy+'08' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM08
                     , ISNULL(AVG(CASE WHEN SUBSTRING(YYYYMMDD,1,6) = @yyyy+'09' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM09
                     , ISNULL(AVG(CASE WHEN SUBSTRING(YYYYMMDD,1,6) = @yyyy+'10' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM10
                     , ISNULL(AVG(CASE WHEN SUBSTRING(YYYYMMDD,1,6) = @yyyy+'11' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM11
                     , ISNULL(AVG(CASE WHEN SUBSTRING(YYYYMMDD,1,6) = @yyyy+'12' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM12
                     , SUBSTRING(@p_version_no,8,18) AS ORI_VERSION_NO
                     , @user_id  AS CREATED_BY
                     , GETDATE()  AS CREATION_DATE
                     , @user_id   AS LAST_UPDATED_BY
                     , GETDATE()  AS LAST_UPDATE_DATE
                  FROM #TEMP_EXCHANGE_C  WITH (NOLOCK)
                 WHERE 1 = 1
                   --AND DIVISION_ID = @p_division_id
                   --AND VERSION_NO  = @p_version_no
                   AND YYYYMMDD LIKE @yyyy+'%'
        GROUP BY DIVISION_ID
                     , VERSION_NO
                     , CURRENCY
                     , UNIT_CURRENCY
                ;

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


