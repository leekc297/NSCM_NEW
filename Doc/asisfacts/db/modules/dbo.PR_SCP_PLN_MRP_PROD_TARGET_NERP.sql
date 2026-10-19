
/*
 * Program ID   : PR_SCP_PLN_MRP_PROD_TARGET_NERP
 * Description  : MRP 생산TARGET 전송 : SAP PI에서 호출하여 Data 송신 처리함 : DB에서 별도로 호출하면 Flag 처리 이슈가 생기니 따로 호출하면 안 됨
 * OutTable     :
 * Execute      : EXEC PR_SCP_PLN_MRP_PROD_TARGET_NERP
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024.04.22   vadabi5       Initial Release  NERP) 데이터 송신 위한 작업
 * 2024.04.25   vadabi5       NERP) ATTR2, ATTR3, ATTR4 ERP 매핑 필요
 * 2024.04.25   vadabi5       NERP) ERP_OPER_CD 매핑 안되는 경우 = OSP Plant 송신 불필요
                              -> 송신하는 것으로 변경, ERP_OPER_CD = NULL, OPER_GRP_CD = X 로 전송 -> OSP_YN으로 구분
							  -> ATTR_05 = Vendor/Customer
 * 2024.05.20   vadabi5       NERP) 핵심테스트 준비 위한 버전 적용
 * 2024.07.08   vadabi5       NERP) 전송 후 FLAG 처리 개선
								 -- 핵심테스트 중에만 적용되는 필터링 ('HQ07','HQ08','WA00') 
								 -- 통합테스트 중에만 적용되는 필터링 ('HQ06','HQ07','HQ08','HQ10','WA00') 
								 -- 향후에도 ROLL IN 대상 만 데이터 송신
								 -- Lookup) SCP_IF_NPP0220
 * 2024.12.31   vadabi5       NERP) 구코드 -> 신코드 변환 후 전송
 * 2025.10.13	YMH			  E20251010-000329 FP와 SCP 간 계획 매칭을 위한 NPP0220 I/F 시 Operation ID 추가 전송 요청
--------------------------------------------------------------------------------------------------------------
exec PR_SCP_PLN_MRP_PROD_TARGET_NERP  @p_division_id	= '40'
								    , @p_start_yyyymmdd = '20240701'
								    , @p_plan_type      = 'FN'
								    , @p_seq            = 1
								    , @p_user_id        = 'SP_RUN_SCP'
--------------------------------------------------------------------------------------------------------------
exec PR_SCP_PLN_MRP_PROD_TARGET_NERP  @p_division_id	= '82'
								    , @p_start_yyyymmdd = '20240318'
								    , @p_plan_type      = 'FN'
								    , @p_seq            = 1
								    , @p_user_id        = 'SP_RUN_SCP'
--------------------------------------------------------------------------------------------------------------
exec PR_SCP_PLN_MRP_PROD_TARGET       @p_division_id	= '82'
								    , @p_start_yyyymmdd = '20240318'
								    , @p_plan_type      = 'FN'
								    , @p_seq            = 1
								    , @p_user_id        = 'SP_RUN_SCP'


exec PR_SCP_PLN_MRP_PROD_TARGET_NERP  @p_division_id	= '81'
								    , @p_start_yyyymmdd = '20240701'
								    , @p_plan_type      = 'FN'
								    , @p_seq            = 1
								    , @p_user_id        = 'SP_RUN_SCP'
--------------------------------------------------------------------------------------------------------------
			select ta.*
			  FROM dbo.SCP_PLN_PROD_PLAN_TARGET_V ta WITH(NOLOCK)
   LEFT OUTER JOIN SCP_MST_FINAL_ITEM fi WITH(NOLOCK)
			    ON  ta.ORIGIN_DIVISION_ID = fi.DIVISION_ID
			   AND ta.ITEM_ID            = fi.ITEM_ID
             WHERE 1=1
               AND ta.DIVISION_ID              = '81'
               AND ta.PLAN_START_YYYYMMDD      = '20240701'
               AND ta.PLAN_TYPE                = 'FN'
               AND ta.SEQ                      = 1
--------------------------------------------------------------------------------------------------------------		
select * from XIF_SCP_PROD_TARGET_MRP_S_SN where if_id = 'NPP0220'
select * from SCP_PLN_INTERFACE_SEND_NPP_H where if_id = 'NPP0220'
--------------------------------------------------------------------------------------------------------------		
select * from SCM_SYS_LOG_BATCH 
where program_name = 'NPP0220' 
and event_date > getdate()-1 
order by event_date
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_PLN_MRP_PROD_TARGET_NERP]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정 
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_MRP_PROD_TARGET_NERP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'NERP_BATCH'; 
    DECLARE @d_event_date   DATETIME;
    DECLARE @d_start_date   DATETIME = SYSDATETIME();
    DECLARE @d_end_date   DATETIME; 



  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = '' ;
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;

   BEGIN TRANSACTION; 
   BEGIN TRY  
   
   BEGIN
        ----------------------------------------------------------- 
        -- 1. interface data creation
        -----------------------------------------------------------        

            DECLARE @X_START_YYYYMMDD       NVARCHAR(8);
            DECLARE @X_CNT                  INT           = 0;
            DECLARE @X_SEND_SEQ             INT           = 1;
            
            DECLARE @X_IF_SEQ               VARCHAR(50);  -- MQ SEQ
            DECLARE @X_IF_TYPE              NVARCHAR(1)   = 'I';
            DECLARE @X_IF_ID                NVARCHAR(50)  = 'NPP0220';
            DECLARE @X_IF_INS_DATE          DATETIME      = GETDATE();
            DECLARE @X_IF_FLAG              NVARCHAR(100)  = 'N';
            DECLARE @X_IF_SND_DATE          DATETIME  = GETDATE();
            
            DECLARE @X_ST_PLAN_TYP          NVARCHAR(40)    ;
            DECLARE @X_PLAN_VERSION         NVARCHAR(12);
      
            BEGIN

						--#################################################
						-- Batch Start
						--#################################################					
						UPDATE XIF_SCP_PROD_TARGET_NPP_S_SN   
						SET    IF_FLAG = 'P'  
						WHERE  ISNULL(IF_FLAG , 'N') = 'N';
			
						--#################################################
						-- 데이터 전송 List
						--#################################################
						SELECT    PLAN_VRSN_ID   AS PLAN_VERSION
								, PLAN_TYP		 AS ST_PLAN_TYP
								, DIV_CD		 AS ST_DIV_CD
								--, SCP_SITE_CD	 AS ST_SCP_SITE_CD
								--, PLANT_CD	 AS ST_PLANT_CD
								, ISNULL(P.NEW_VALUE1, SCP_SITE_CD) AS ST_SCP_SITE_CD
								, ISNULL(S.NEW_VALUE1, PLANT_CD) AS ST_PLANT_CD
								, OPER_CD		 AS ST_OPER_CD
								, LINE_CD		 AS ST_LINE_CD
								, PROD_TYP		 AS ST_PROD_TYP
								, ITEM_CD		 AS ST_ITEM_CD
								, PJCT_NICK_NM	 AS ST_NICK_NM

								, PLAN_DT		 AS ST_PLAN_DT
				
								, PLAN_QTY		 AS ST_PLAN_QTY
								, PLAN_IN_QTY	 AS ST_PLAN_IN_QTY
								, PROD_WEEK		 AS ST_PROD_WEEK
								, MKT_FLAG		 AS ST_MKT_FLAG
							
								, OPER_GRP_CD	 AS ST_OPER_GRP_CD
								, REG_USER_ID	 AS CREATE_USER_ID
								, REG_DTTM		 AS CREATE_DATE
								, CHNG_USER_ID	 AS MODIFY_USER_ID
								, CHNG_DTTM		 AS MODIFY_DATE
								
								, ATTR_01	-- ORIGIN_DIVISION_ID
								, ATTR_02   --,'MASS'
								, ATTR_03   --,'E6D01ACT'	
								, ATTR_04   --,'001'
								, ATTR_05   -- OSP PLANT
								, ATTR_06	-- OPERATION ID -- [E20251010-000329] FP와 SCP 간 계획 매칭을 위한 NPP0220 I/F 시 Operation ID 추가 전송 요청
								--, ATTR_07
								--, ATTR_08
								--, ATTR_09
								--, ATTR_10
 
						FROM XIF_SCP_PROD_TARGET_NPP_S_SN A
						LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = 'PLANT_ID' ) P ON A.PLANT_CD = P.OLD_VALUE1 
						LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = 'SCP_SITE_ID' ) S ON A.SCP_SITE_CD = S.OLD_VALUE1 
						WHERE IF_ID = @X_IF_ID
						AND IF_FLAG = 'P'
					  --and PLANT_CD in ('HQ07','HQ08','WA00')					-- 핵심테스트 중에만 적용되는 필터링
					  --and PLANT_CD in ('HQ06','HQ07','HQ08','HQ10','WA00')	-- 통합테스트 중에만 적용되는 필터링
						AND PLANT_CD IN (SELECT  SEGMENT1 
						                   FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) 
										  WHERE LOOKUP_TYPE ='NERP_ROLLIN_PLANT')	-- 20240708 ROLL IN 대상만 송신 대상
						ORDER BY IF_SEQ

                        SET @n_log_count = @@ROWCOUNT;


						EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
							,@p_log_type      ='INSERT'
							,@p_log_count     =@n_log_count 
							,@p_log_message   ='SAP PI Transfer' 
							,@p_description   = @X_IF_ID
							,@p_event_date    =@d_event_date 
							

					    --#################################################
						-- FINISH : Flag 처리
						--#################################################					
						UPDATE XIF_SCP_PROD_TARGET_NPP_S_SN   
						SET    IF_FLAG = 'Y' 
						,      IF_SND_DATE = GETDATE()
						WHERE IF_ID = @X_IF_ID
						AND IF_FLAG = 'P'
						AND PLANT_CD IN (SELECT  SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)WHERE LOOKUP_TYPE ='NERP_ROLLIN_PLANT')

						UPDATE XIF_SCP_PROD_TARGET_NPP_S_SN   
						SET    IF_FLAG = 'S'  
						,      IF_SND_DATE = GETDATE()
						WHERE IF_ID = @X_IF_ID
						AND IF_FLAG = 'P'

            END    

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'END';   
        SET @v_log_message = N'BATCH TIME';
		SET @d_event_date = SYSDATETIME();
        --SET @v_description = @v_description;
        declare  @BATCH_TIME int;
		SELECT @BATCH_TIME = DATEDIFF(second, @d_start_date, @d_event_date)

        EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                                  ,@p_log_type      ='END'
                                  ,@p_log_count     =@BATCH_TIME
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ;

      END;

   COMMIT TRAN;
   END TRY
   BEGIN CATCH

		  IF (XACT_STATE() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
		  BEGIN
			INSERT INTO SCM_SYS_LOG_BATCH
			(
				  PROGRAM_NAME
				, LOG_TYPE
				, LOG_COUNT
				, LOG_MESSAGE
				, DESCRIPTION
				, EVENT_DATE
				, CREATION_DATE
				, CREATED_BY
				, LAST_UPDATE_DATE
				, LAST_UPDATED_BY
			)
			VALUES
			(
				  ISNULL(ERROR_PROCEDURE(), 'PR_SCP_PLN_MRP_PROD_TARGET_NERP')
	 			, 'ERROR'
	 			, NULL
	 			, ERROR_MESSAGE()
	 			, NULL
	 			, SYSDATETIME()
	 			, SYSDATETIME()
	 			, ERROR_PROCEDURE()
	 			, SYSDATETIME()
				, ERROR_PROCEDURE()
			)
		  END;
		  PRINT ERROR_MESSAGE();
	END CATCH;


  END;
