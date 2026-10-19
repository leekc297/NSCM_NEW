---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*  
 * Program ID   : PR_SCM_MST_EXCHANGE_RATE  
 * Description  : Chempion 환율 I/F Procedure
 * PARAMETER    : N/A
 * DESCRIPTION  : Chempion 환율 I/F
 * I/F Table    : [dbo].[XIF_GSC_MOVE_EXCHANGE_RATE_SN]
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================
 * 2021.05.13	P.C.I		   [PJ20209642R] Chempion 환율 I/F
 * 2022.03.25   sclee          PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2022.05.11	HWI1993			GM JV 수정
 * 2022.11.17	kdw2819			[C20221116-000471]환율정보 수신 배치 오류
 * 2022.11.28	chano0612		[C20221124-000290]환율 IF관련 수정 요청 건
 * 2025.06.24	kjiyoon			[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 사용자 환율팝업 적용 - 화면 호출용 프로시저 수행 성공/실패 output 추가
 * 2025.07.03	kjiyoon			[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : @P_BATCH_YN 파라미터 추가
																			   Y -> 40번 사업부만 제외, TRANSF_FLAG 가 N 인 기준으로 환율 반영 (배치호출)
																			   N -> 40번 사업부만 대상, TRANSF_DATE 가 MAX인 대상 기준으로 환율 반영 (환율팝업호출)
 */  
 
CREATE PROCEDURE [dbo].[PR_SCM_MST_EXCHANGE_RATE]
	@P_BATCH_YN NVARCHAR(1) = 'Y' --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : @P_BATCH_YN 파라미터 추가하여 배치수행/화면수행 구분
AS
--------------------------------------------------------------------------------
BEGIN
	   SET NOCOUNT ON;
	   SET ANSI_WARNINGS OFF;
	   ----------------------------------------------------------------------------
	   
    DECLARE @C_DIVISION_ID			VARCHAR(30);
    DECLARE @C_SCENARIO_TYPE_CD		VARCHAR(06);
    DECLARE @C_PLN_PERIOD_YYYYMM	VARCHAR(06);
    DECLARE @C_CURRENCY_CD			VARCHAR(15);
    DECLARE @C_IF_SEQ				NUMERIC(16,0);
	DECLARE @RECEIVE_CNT			NUMERIC(16,0); --수신적재처리건수
	   ----------------------------------------------------------------------------
	   
    -- LOG 용 변수 설정
    DECLARE @v_batch_user		NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name		NVARCHAR(150) = 'PR_SCM_MST_EXCHANGE_RATE';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description		NVARCHAR(500);
    DECLARE @d_event_date		DATETIME;
	DECLARE @n_history_seq		BIGINT;
	DECLARE @v_ifseqno			NVARCHAR(30); -- 누락된 전체 데이터 insert

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = CONCAT('@P_BATCH_YN = ',ISNULL(@P_BATCH_YN,'X'));
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	IF OBJECT_ID (N'tempdb..#i_division', N'U') IS NOT NULL 
		DROP TABLE #i_division

	CREATE TABLE  #i_division (division_id	NVARCHAR(30)) 

	-- 자동차, ESS, 소형 작업
	--[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : @P_BATCH_YN 파라미터 추가 START 

	--기존로직 주석처리
	--INSERT INTO #i_division (division_id) 
	--SELECT DIVISION_ID 
	--FROM SCM_MST_DIVISION
	--WHERE ATTRIBUTE3 IN ('40','81', '82' )

	IF @P_BATCH_YN = 'Y'
	BEGIN
		--대상 사업부
		INSERT INTO #i_division (division_id) 
		SELECT DIVISION_ID 
		FROM SCM_MST_DIVISION
		WHERE ATTRIBUTE3 IN ('81', '82' )

		--대상 IF 환율
		DECLARE CUR_E CURSOR LOCAL FOR
			select SCENARIO_TYPE_CD, PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ
			from ( select E.SCENARIO_TYPE_CD
						, E.PLN_PERIOD_YYYYMM
						, E.CURRENCY_CD
						, E.IF_SEQ
					from  [dbo].[XIF_GSC_MOVE_EXCHANGE_RATE_SN] AS E with(nolock)
					where  ISNULL(E.TRANSF_FLAG,'N') = 'N'
					AND SCENARIO_TYPE_CD IN ('ML', 'RF') --[C20221124-000290] SCENARIO_TYPE_CD를 ML, RF만 등록한다..
					group by E.SCENARIO_TYPE_CD
						, E.PLN_PERIOD_YYYYMM
						, E.CURRENCY_CD
						, E.IF_SEQ
						) x
			ORDER BY PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ, SCENARIO_TYPE_CD
	END
	ELSE
	BEGIN
		--대상 사업부
		INSERT INTO #i_division (division_id) 
		SELECT DIVISION_ID 
		FROM SCM_MST_DIVISION
		WHERE ATTRIBUTE3 IN ( '40')

		--대상 IF 환율
		DECLARE CUR_E CURSOR LOCAL FOR
			select SCENARIO_TYPE_CD, PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ
			from ( select E.SCENARIO_TYPE_CD
						, E.PLN_PERIOD_YYYYMM
						, E.CURRENCY_CD
						, E.IF_SEQ
					from  [dbo].[XIF_GSC_MOVE_EXCHANGE_RATE_SN] AS E with(nolock)
					where E.TRANSF_DATE = (SELECT MAX(A.TRANSF_DATE)
											 FROM [XIF_GSC_MOVE_EXCHANGE_RATE_SN] A
											WHERE 1=1
											  AND A.SCENARIO_TYPE_CD IN ('ML', 'RF'))
					  AND SCENARIO_TYPE_CD IN ('ML', 'RF') --[C20221124-000290] SCENARIO_TYPE_CD를 ML, RF만 등록한다..
					group by E.SCENARIO_TYPE_CD
						, E.PLN_PERIOD_YYYYMM
						, E.CURRENCY_CD
						, E.IF_SEQ
						) x
			ORDER BY PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ, SCENARIO_TYPE_CD
	END

	--[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : @P_BATCH_YN 파라미터 추가 END

	--DELETE FROM DM_MST_EXCHANGE_RATE WHERE YYYYMMDD BETWEEN CONVERT(CHAR(6), DATEADD(MM, 0, GETDATE()), 112) + '01' AND CONVERT(CHAR(6), DATEADD(MM, 12, GETDATE()), 112) + '01'
	--[C20221124-000290] DM_MST_EXCHANGE_RATE 에 존재하는 기존 데이터를 삭제한다.
	
	--위로 로직 이동해서 아래 CURSOR 주석처리 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : @P_BATCH_YN 파라미터 추가
	--CURSOR 환율 정보 수신 (KEY : SCENARIO_TYPE_CD, PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ)
 --   DECLARE CUR_E CURSOR LOCAL FOR
	--select SCENARIO_TYPE_CD, PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ
	--from ( select E.SCENARIO_TYPE_CD
	--			, E.PLN_PERIOD_YYYYMM
	--			, E.CURRENCY_CD
	--			, E.IF_SEQ
	--		from  [dbo].[XIF_GSC_MOVE_EXCHANGE_RATE_SN] AS E with(nolock)
	--		where  ISNULL(E.TRANSF_FLAG,'N') = 'N'
	--		AND SCENARIO_TYPE_CD IN ('ML', 'RF') --[C20221124-000290] SCENARIO_TYPE_CD를 ML, RF만 등록한다..
	--		group by E.SCENARIO_TYPE_CD
	--			, E.PLN_PERIOD_YYYYMM
	--			, E.CURRENCY_CD
	--			, E.IF_SEQ
	--			) x
	--ORDER BY PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ, SCENARIO_TYPE_CD
	
	
	--CURSOR 환율 정보 수신 (KEY : SCENARIO_TYPE_CD, PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ)
    DECLARE CUR_D CURSOR FOR
	select division_id
	from ( select division_id
			from  #i_division with(nolock)) x


	----------------------------------------------------------------------------
	BEGIN TRY
	BEGIN TRANSACTION;
	------------------------------------------------------------------------
	
		--------------------------------------------------------------------
		--Start 환율 Cursor
		--------------------------------------------------------------------

		SET @RECEIVE_CNT = 0;

		OPEN CUR_E;
        FETCH NEXT FROM CUR_E
		           INTO @C_SCENARIO_TYPE_CD
					  , @C_PLN_PERIOD_YYYYMM
					  , @C_CURRENCY_CD
					  , @C_IF_SEQ ;
        WHILE (@@FETCH_STATUS = 0)
        BEGIN
		    --------------------------------------------------------------------
		    MERGE INTO DM_MST_EXCHANGE_RATE DME
            USING ( SELECT B.DIVISION_ID, A.YYYYMMDD, A.CURRENCY, REPLACE(A.UNIT_CURRENCY, 'CNY', 'RMB') AS UNIT_CURRENCY, A.EXCHANGE_PRICE
					FROM   (SELECT PLN_YYYYMM+'01'	AS YYYYMMDD
								 , 'KRW'			AS CURRENCY
								 , CURRENCY_CD		AS UNIT_CURRENCY
								 , KRW_CNVT_RATE	AS EXCHANGE_PRICE
							FROM   [XIF_GSC_MOVE_EXCHANGE_RATE_SN] with(nolock)
							WHERE SCENARIO_TYPE_CD	= @C_SCENARIO_TYPE_CD
							AND   PLN_PERIOD_YYYYMM	= @C_PLN_PERIOD_YYYYMM
							AND   CURRENCY_CD		= @C_CURRENCY_CD
							AND   IF_SEQ			= @C_IF_SEQ
							UNION ALL
							SELECT PLN_YYYYMM+'01'	AS YYYYMMDD
								 , 'USD'			AS CURRENCY
								 , CURRENCY_CD		AS UNIT_CURRENCY
								 , USD_CNVT_RATE	AS EXCHANGE_PRICE
							FROM   [XIF_GSC_MOVE_EXCHANGE_RATE_SN] with(nolock)
							WHERE SCENARIO_TYPE_CD	= @C_SCENARIO_TYPE_CD
							AND   PLN_PERIOD_YYYYMM	= @C_PLN_PERIOD_YYYYMM
							AND   CURRENCY_CD		= @C_CURRENCY_CD
							AND   IF_SEQ			= @C_IF_SEQ
							UNION ALL
							SELECT PLN_YYYYMM+'01'	AS YYYYMMDD
								 , 'EUR'			AS CURRENCY
								 , CURRENCY_CD		AS UNIT_CURRENCY
								 , EUR_CNVT_RATE	AS EXCHANGE_PRICE
							FROM   [XIF_GSC_MOVE_EXCHANGE_RATE_SN] with(nolock)
							WHERE SCENARIO_TYPE_CD	= @C_SCENARIO_TYPE_CD
							AND   PLN_PERIOD_YYYYMM	= @C_PLN_PERIOD_YYYYMM
							AND   CURRENCY_CD		= @C_CURRENCY_CD
							AND   IF_SEQ			= @C_IF_SEQ
							) AS A
					, #i_division AS B 
                  ) XXX
            ON (     DME.DIVISION_ID	= XXX.DIVISION_ID
				 AND DME.YYYYMMDD		= XXX.YYYYMMDD
				 AND DME.CURRENCY		= XXX.CURRENCY
				 AND DME.UNIT_CURRENCY	= XXX.UNIT_CURRENCY
               )
            WHEN MATCHED THEN
                UPDATE SET DME.EXCHANGE_PRICE   = XXX.EXCHANGE_PRICE
                         , DME.LAST_UPDATED_BY  = 'SYSTEM'
                         , DME.LAST_UPDATE_DATE = GETDATE()
            WHEN NOT MATCHED THEN
                INSERT ( DIVISION_ID
					   , YYYYMMDD
					   , CURRENCY
					   , UNIT_CURRENCY
                       , EXCHANGE_PRICE
					   , CREATED_BY
                       , CREATION_DATE
					   , LAST_UPDATED_BY
                       , LAST_UPDATE_DATE
                       )
                VALUES ( XXX.DIVISION_ID
					   , XXX.YYYYMMDD
					   , XXX.CURRENCY
					   , XXX.UNIT_CURRENCY
					   , XXX.EXCHANGE_PRICE
					   , 'SYSTEM'
                       , GETDATE()
					   , 'SYSTEM'
                       , GETDATE()
                       );
            --------------------------------------------------------------------

			--배치일때만 업데이트하도록 조건추가 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : @P_BATCH_YN 파라미터 추가
			IF @P_BATCH_YN = 'Y' 
			BEGIN
				--I/F Table TRANSF_FLAG 변경
				UPDATE [dbo].[XIF_GSC_MOVE_EXCHANGE_RATE_SN]
				SET    TRANSF_FLAG      = 'Y'
				WHERE SCENARIO_TYPE_CD	= @C_SCENARIO_TYPE_CD
				AND   PLN_PERIOD_YYYYMM	= @C_PLN_PERIOD_YYYYMM
				AND   CURRENCY_CD		= @C_CURRENCY_CD
				AND   IF_SEQ			= @C_IF_SEQ
			END
						
			SET @RECEIVE_CNT        = @RECEIVE_CNT + 1;
			--------------------------------------------------------------------

            FETCH NEXT FROM CUR_E
					   INTO @C_SCENARIO_TYPE_CD
						  , @C_PLN_PERIOD_YYYYMM
						  , @C_CURRENCY_CD
						  , @C_IF_SEQ ;
        END;
        CLOSE CUR_E;
        DEALLOCATE CUR_E;

		--------------------------------------------------------------------
		--End  환율 Cursor
		--------------------------------------------------------------------
		
		--------------------------------------------------------------------
		--Start  Sales Price, Sales Plan Cursor
		--------------------------------------------------------------------
		
		select '@RECEIVE_CNT', @RECEIVE_CNT
		
		IF (@RECEIVE_CNT > 0) 
		BEGIN
		
			OPEN CUR_D;
			FETCH NEXT FROM CUR_D
					   INTO @C_DIVISION_ID ;
			WHILE (@@FETCH_STATUS = 0)
			BEGIN

				select '@C_DIVISION_ID', @C_DIVISION_ID

				-- Sales Price Update
				EXEC [DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION] @C_DIVISION_ID

				-- Sales Plan Update
				EXEC [PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW]   @C_DIVISION_ID, 'EXCHANGE_RATE'
				
				FETCH NEXT FROM CUR_D
						   INTO @C_DIVISION_ID ;
			END;
			CLOSE CUR_D;
			DEALLOCATE CUR_D;

		END
		--------------------------------------------------------------------
		--End  Sales Price, Sales Plan Cursor
		--------------------------------------------------------------------

		------------------------------------------------------------------------
		-- 트랜잭션 종료
		COMMIT;

		-- 종료 LOG
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
	    SELECT 'success' --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 사용자 환율팝업 적용 

	   END TRY
	   ----------------------------------------------------------------------------
	   BEGIN CATCH
		      ROLLBACK;
		      
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	  SELECT @v_log_message --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 사용자 환율팝업 적용 

	   END CATCH
	   ----------------------------------------------------------------------------
END

