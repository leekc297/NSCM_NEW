
/*
 * Program ID   : PR_DM_MST_BOD_HIST
 * Description  : SCM MST BOD HISTORYT INSERT
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 11. 29    DWOK/DWPARK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */


CREATE PROCEDURE [dbo].[PR_DM_MST_BOD_HIST]

	@p_division_id			NVARCHAR(MAX),
	@p_bod_id				NVARCHAR(MAX),
	@p_bod_type				NVARCHAR(MAX),
	@p_from_site			NVARCHAR(MAX),
	@p_pol					NVARCHAR(MAX),
	@p_pod					NVARCHAR(MAX),
	@p_hub_sloc				NVARCHAR(MAX),
	@p_to_site				NVARCHAR(MAX),
	@p_incoterms			NVARCHAR(MAX),
	@p_transport_mode		NVARCHAR(MAX),
	@p_priority				NVARCHAR(MAX),
	@p_period_shipsch_mon	NVARCHAR(MAX),
	@p_period_shipsch_tue	NVARCHAR(MAX),
	@p_period_shipsch_wed	NVARCHAR(MAX),
	@p_period_shipsch_thu	NVARCHAR(MAX),
	@p_period_shipsch_fri	NVARCHAR(MAX),
	@p_period_shipsch_sat	NVARCHAR(MAX),
	@p_period_shipsch_sun	NVARCHAR(MAX),
	@p_freight_forwarder	NVARCHAR(MAX),
	@p_safety_stock			NVARCHAR(MAX),
	@p_period1_lt			NVARCHAR(MAX),
	@p_pol_clearance_lt		NVARCHAR(MAX),
	@p_period2_lt			NVARCHAR(MAX),
	@p_pod_clearance_lt		NVARCHAR(MAX),
	@p_period3_lt			NVARCHAR(MAX),
	@p_customer_lt			NVARCHAR(MAX),
	@p_valid_yn				NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX)
	--@p_OK_description		NVARCHAR(1200) OUTPUT		-- 자식 프로시저 성공/에러 셋팅 -> 다중트랜잭션설정했으므로 필요는 없음 20180223 songkeeho 
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_bod_id				NVARCHAR(MAX);
	DECLARE @v_bod_type				NVARCHAR(MAX);
	DECLARE @v_from_site			NVARCHAR(MAX);
	DECLARE @v_pol					NVARCHAR(MAX);
	DECLARE @v_pod					NVARCHAR(MAX);
	DECLARE @v_hub_sloc				NVARCHAR(MAX);
	DECLARE @v_to_site				NVARCHAR(MAX);
	DECLARE @v_incoterms			NVARCHAR(MAX);
	DECLARE @v_transport_mode		NVARCHAR(MAX);
	DECLARE @v_priority				NVARCHAR(MAX);
	DECLARE @v_period_shipsch_mon	NVARCHAR(MAX);
	DECLARE @v_period_shipsch_tue	NVARCHAR(MAX);
	DECLARE @v_period_shipsch_wed	NVARCHAR(MAX);
	DECLARE @v_period_shipsch_thu	NVARCHAR(MAX);
	DECLARE @v_period_shipsch_fri	NVARCHAR(MAX);
	DECLARE @v_period_shipsch_sat	NVARCHAR(MAX);
	DECLARE @v_period_shipsch_sun	NVARCHAR(MAX);
	DECLARE @v_freight_forwarder	NVARCHAR(MAX);
	DECLARE @v_safety_stock			NVARCHAR(MAX);
	DECLARE @v_period1_lt			NVARCHAR(MAX);
	DECLARE @v_pol_clearance_lt		NVARCHAR(MAX);
	DECLARE @v_period2_lt			NVARCHAR(MAX);
	DECLARE @v_pod_clearance_lt		NVARCHAR(MAX);
	DECLARE @v_period3_lt			NVARCHAR(MAX);
	DECLARE @v_customer_lt			NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
	DECLARE @n_history_seq			INTEGER = 0;

	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MST_BOD_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	--[C20200909-000203] LOG 표준화 적용
		-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 트랜잭션 (START)
		BEGIN TRANSACTION PR_DM_MST_BOD_HIST;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

			BEGIN    
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_MST_BOD_H
				   BEGIN
				
						--[2018-03-19][수정]
						--MERGE INTO [dbo].[SCM_MST_BOD_H] A
						--USING (
						--		SELECT
						--			 @p_division_id			AS DIVISION_ID
						--			,@p_bod_id				AS BOD_ID
						--			,@p_bod_type			AS BOD_TYPE
						--			,@p_from_site			AS FROM_SITE
						--			,@p_pol					AS POL
						--			,@p_pod					AS POD
						--			,@p_hub_sloc			AS HUB_SLOC
						--			,@p_to_site				AS TO_SITE
						--			,@p_incoterms			AS INCOTERMS
						--			,@p_transport_mode		AS TRANSPORT_MODE
						--			,@p_priority			AS [PRIORITY]
						--			,@p_period_shipsch_mon	AS PERIOD_SHIPSCH_MON
						--			,@p_period_shipsch_tue	AS PERIOD_SHIPSCH_TUE
						--			,@p_period_shipsch_wed	AS PERIOD_SHIPSCH_WED
						--			,@p_period_shipsch_thu	AS PERIOD_SHIPSCH_THU
						--			,@p_period_shipsch_fri	AS PERIOD_SHIPSCH_FRI
						--			,@p_period_shipsch_sat	AS PERIOD_SHIPSCH_SAT
						--			,@p_period_shipsch_sun	AS PERIOD_SHIPSCH_SUN
						--			,@p_freight_forwarder	AS FREIGHT_FORWARDER
						--			,@p_safety_stock		AS SAFETY_STOCK
						--			,@p_period1_lt			AS PERIOD1_LT
						--			,@p_pol_clearance_lt	AS POL_CLEARANCE_LT
						--			,@p_period2_lt			AS PERIOD2_LT
						--			,@p_pod_clearance_lt	AS POD_CLEARANCE_LT
						--			,@p_period3_lt			AS PERIOD3_LT
						--			,@p_customer_lt			AS CUSTOMER_LT
						--			,@p_valid_yn			AS VALID_YN
						--	  ) B
						--ON (
						--			A.DIVISION_ID			= B.DIVISION_ID
						--		AND A.BOD_ID				= B.BOD_ID
						--		AND A.BOD_TYPE				= B.BOD_TYPE
						--		AND A.FROM_SITE				= B.FROM_SITE
						--		AND A.POL					= B.POL
						--		AND A.POD					= B.POD
						--		AND A.HUB_SLOC				= B.HUB_SLOC
						--		AND A.TO_SITE				= B.TO_SITE
						--		AND A.INCOTERMS				= B.INCOTERMS
						--		AND A.TRANSPORT_MODE		= B.TRANSPORT_MODE
						--		AND A.[PRIORITY]			= B.[PRIORITY]
						--		AND A.PERIOD_SHIPSCH_MON	= B.PERIOD_SHIPSCH_MON
						--		AND A.PERIOD_SHIPSCH_TUE	= B.PERIOD_SHIPSCH_TUE
						--		AND A.PERIOD_SHIPSCH_WED	= B.PERIOD_SHIPSCH_WED
						--		AND A.PERIOD_SHIPSCH_THU	= B.PERIOD_SHIPSCH_THU
						--		AND A.PERIOD_SHIPSCH_FRI	= B.PERIOD_SHIPSCH_FRI
						--		AND A.PERIOD_SHIPSCH_SAT	= B.PERIOD_SHIPSCH_SAT
						--		AND A.PERIOD_SHIPSCH_SUN	= B.PERIOD_SHIPSCH_SUN
						--		AND A.FREIGHT_FORWARDER		= B.FREIGHT_FORWARDER
						--		AND A.SAFETY_STOCK			= B.SAFETY_STOCK
						--		AND A.PERIOD1_LT			= B.PERIOD1_LT
						--		AND A.POL_CLEARANCE_LT		= B.POL_CLEARANCE_LT
						--		AND A.PERIOD2_LT			= B.PERIOD2_LT
						--		AND A.POD_CLEARANCE_LT		= B.POD_CLEARANCE_LT
						--		AND A.PERIOD3_LT			= B.PERIOD3_LT
						--		AND A.CUSTOMER_LT			= B.CUSTOMER_LT
						--		AND A.VALID_YN				= B.VALID_YN
						--   )
						--WHEN NOT MATCHED THEN
						--	INSERT	  (
						--			   DIVISION_ID ,HISTORY_SEQ, BOD_ID ,BOD_TYPE 
						--			  ,FROM_SITE ,POL ,POD ,HUB_SLOC ,TO_SITE
						--			  ,INCOTERMS ,TRANSPORT_MODE 
						--			  ,[PRIORITY]
						--			  ,PERIOD_SHIPSCH_MON ,PERIOD_SHIPSCH_TUE ,PERIOD_SHIPSCH_WED ,PERIOD_SHIPSCH_THU
						--			  ,PERIOD_SHIPSCH_FRI ,PERIOD_SHIPSCH_SAT ,PERIOD_SHIPSCH_SUN
						--			  ,FREIGHT_FORWARDER ,SAFETY_STOCK 
						--			  ,PERIOD1_LT 
						--			  ,POL_CLEARANCE_LT
						--			  ,PERIOD2_LT 
						--			  ,POD_CLEARANCE_LT 
						--			  ,PERIOD3_LT 
						--			  ,CUSTOMER_LT 
						--			  ,VALID_YN
						--			  ,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE)
						--	VALUES  
						--			  (
						--			   @p_division_id , @n_history_seq ,@p_bod_id, @p_bod_type 
						--			  ,@p_from_site ,@p_pol ,@p_pod ,@p_hub_sloc ,@p_to_site
						--			  ,@p_incoterms ,@p_transport_mode 
						--			  , CONVERT(INT, CAST(@p_priority AS NVARCHAR(10)))
						--			  ,@p_period_shipsch_mon ,@p_period_shipsch_tue ,@p_period_shipsch_wed ,@p_period_shipsch_thu
						--			  ,@p_period_shipsch_fri ,@p_period_shipsch_sat ,@p_period_shipsch_sun
						--			  ,@p_freight_forwarder ,@p_safety_stock 
						--			  , CONVERT(INT, CAST(@p_period1_lt AS NVARCHAR(10)))
						--			  , CONVERT(INT, CAST(@p_pol_clearance_lt AS NVARCHAR(10)))
						--			  , CONVERT(INT, CAST(@p_period2_lt AS NVARCHAR(10)))
						--			  , CONVERT(INT, CAST(@p_pod_clearance_lt AS NVARCHAR(10)))
						--			  , CONVERT(INT, CAST(@p_period3_lt AS NVARCHAR(10)))
						--			  , CONVERT(INT, CAST(@p_customer_lt AS NVARCHAR(10)))
						--			  ,@p_valid_yn
						--			  ,@p_created_by ,SYSDATETIME() ,@p_created_by ,SYSDATETIME()
						--			  );

							INSERT	INTO  [dbo].[SCM_MST_BOD_H]
							(									   
									   DIVISION_ID ,HISTORY_SEQ, BOD_ID ,BOD_TYPE 
									  ,FROM_SITE ,POL ,POD ,HUB_SLOC ,TO_SITE
									  ,INCOTERMS ,TRANSPORT_MODE 
									  ,[PRIORITY]
									  ,PERIOD_SHIPSCH_MON ,PERIOD_SHIPSCH_TUE ,PERIOD_SHIPSCH_WED ,PERIOD_SHIPSCH_THU
									  ,PERIOD_SHIPSCH_FRI ,PERIOD_SHIPSCH_SAT ,PERIOD_SHIPSCH_SUN
									  ,FREIGHT_FORWARDER ,SAFETY_STOCK 
									  ,PERIOD1_LT 
									  ,POL_CLEARANCE_LT
									  ,PERIOD2_LT 
									  ,POD_CLEARANCE_LT 
									  ,PERIOD3_LT 
									  ,CUSTOMER_LT 
									  ,VALID_YN
									  ,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE
							)
							VALUES  
							(
									   @p_division_id , @n_history_seq ,@p_bod_id, @p_bod_type 
									  ,@p_from_site ,@p_pol ,@p_pod ,@p_hub_sloc ,@p_to_site
									  ,@p_incoterms ,@p_transport_mode 
									  , CONVERT(INT, CAST(@p_priority AS NVARCHAR(10)))
									  ,@p_period_shipsch_mon ,@p_period_shipsch_tue ,@p_period_shipsch_wed ,@p_period_shipsch_thu
									  ,@p_period_shipsch_fri ,@p_period_shipsch_sat ,@p_period_shipsch_sun
									  ,@p_freight_forwarder ,@p_safety_stock 
									  , CONVERT(INT, CAST(@p_period1_lt AS NVARCHAR(10)))
									  , CONVERT(INT, CAST(@p_pol_clearance_lt AS NVARCHAR(10)))
									  , CONVERT(INT, CAST(@p_period2_lt AS NVARCHAR(10)))
									  , CONVERT(INT, CAST(@p_pod_clearance_lt AS NVARCHAR(10)))
									  , CONVERT(INT, CAST(@p_period3_lt AS NVARCHAR(10)))
									  , CONVERT(INT, CAST(@p_customer_lt AS NVARCHAR(10)))
									  ,@p_valid_yn
									  ,@p_created_by ,SYSDATETIME() ,@p_created_by ,SYSDATETIME()
						   );



				   END

					--SET @p_OK_description = 'OK';
					--RETURN;
				
			END

          COMMIT WORK;

		END TRY

     BEGIN CATCH
	 
	 --[C20200909-000203] LOG 표준화 적용
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION  PR_DM_MST_BOD_HIST;

      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	  

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END; 




