/*
 * Program ID   : [PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH]  
 * Description  : 출하확정변경시 SCS 전송 데이터 테이블 저장 
 * OutTable     :
 * Execute      : EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS @p_change_type @p_change_req_no
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.03.03   KIMYONGHO      SCS I/F 추가
 * 2023.04.11   jilee          프로젝트 Name명 추가 전송
 * 2024.10.01   KHJ            NERP_SSP
 */
CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS]
( 
      @p_change_type           NVARCHAR(1),  -- B: 변경확정,C: 변경요청, D: 변경 Reject 
      @p_change_req_no         NVARCHAR(30) 

    ---- , @p_debug       INT OUTPUT
) 
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    SET     @v_batch_user = 'ssp_batch' ; -- @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SHIP_CONFIRM INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';

    DECLARE @v_plan_start_yyyymmdd    NVARCHAR(8) = '';
	DECLARE @v_seq    INTEGER = 0;
	DECLARE @v_infseqno	nvarchar(14);	
	DECLARE @v_last_confirm_date nvarchar(8);	


	DECLARE @IF_GROUP_NO            NVARCHAR(50)   = FORMAT(CURRENT_TIMESTAMP, 'yyyyMMddHHmmss');

	DECLARE @mDQry  NVARCHAR(MAX)='';

    BEGIN TRY
      BEGIN
        BEGIN TRAN TX_SH

        -- B: 변경확정 C: 변경요청
		IF @p_change_type IN ('B')
	
			BEGIN

				--------------------------------------------------------SCS I/F 추가--------------------------------------------------------------------------

				INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN
				 ( IF_SEQ           
				 , IF_TYPE          
				 , IF_ID            
				 , IF_INS_DATE      
				 , IF_FLAG          
				 , PACKER_CODE      
				 , DIVISION_ID      
				 , PLAN_VERSION   
				 , PACK_MODEL_CODE  
				 , NICK_NAME 
				 , TARGET_ORDER
				 , SSP_CNFM
				 , SALES_SITE
				 , SHIP_TO
				 , SHIP_TO_NAME
				 , TRANSPORT_MODE
				 , INCOTERMS
				 , SHIP_PLAN_DATE 
				 , SHIP_PLAN_QTY 
				 , COMMENT
				 , ATTR_01           
				 , ATTR_02           
				 , ATTR_03           
				 , ATTR_04           
				 , ATTR_05           
				 , ATTR_06           
				 , ATTR_07           
				 , ATTR_08           
				 , ATTR_09           
				 , ATTR_10           
				 )
			SELECT   'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
					 , 'I'								AS IF_TYPE
					 , 'OSCM_OSCS_SCS_PACK_SHIP_PLAN'	AS IF_ID
					 , GETDATE()						AS IF_INS_DATE
					 , 'N'								AS IF_FLAG 
					 , ISNULL(X1.NEW_VALUE1, A.PACKER_CODE)		AS PACKER_CODE 
					 , A.DIVISION_ID					AS DIVISION_ID     -- DIVISION 
					 , CONVERT(VARCHAR(8), CONVERT(DATETIME, getdate()), 112)    AS PLAN_VERSION
					 , A.PACK_MODEL_CODE						AS PACK_MODEL_CODE -- PACK ID 
					 , A.NICK_NAME
					 , 'O'
					 , A.SSP_CNFM
					 , A.SALES_SITE
					 , A.SHIP_TO_CODE                                             
					 , A.SHIP_TO_NAME
					 , A.TRANSPORT_MODE  -- 운송수단
					 , A.INCOTERMS       -- 거래조건
					 , A.SHIP_PLAN_DATE  -- 출하계획일 
					 , A.SHIP_PLAN_QTY   -- 출하계획수량
					 , NULL								AS COMMENT
					 , A.ATTR_01      
					 , A.ATTR02           
					 , NULL								AS ATTR03           
					 , NULL								AS ATTR04           
					 , A.ATTR05           
					 , NULL								AS ATTR06           
					 , NULL								AS ATTR07           
					 , NULL								AS ATTR08           
					 , NULL								AS ATTR09           
					 , NULL								AS ATTR10  
			FROM (
				SELECT 
					   P.FROM_SITE						AS PACKER_CODE
					 , P.DIVISION_ID					AS DIVISION_ID     -- DIVISION 
					 , P.ITEM_ID						AS PACK_MODEL_CODE -- PACK ID 
					 , [dbo].[FN_GET_ITEM_NICKNAME]( P.DIVISION_ID, P.ITEM_ID)  AS NICK_NAME
					 , P.CONFIRM_ID						AS SSP_CNFM
					 , P.TO_SITE						AS SALES_SITE
					 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](P.DIVISION_ID,P.TO_SITE,'SHIPTO_CODE')			AS SHIP_TO_CODE                                             
					 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](P.DIVISION_ID,P.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
					 , P.NEW_TRANSPORT_MODE					AS TRANSPORT_MODE  -- 운송수단
					 , P.NEW_INCOTERMS						AS INCOTERMS       -- 거래조건
					 , P.NEW_YYYYMMDD						AS SHIP_PLAN_DATE  -- 출하계획일 
					 , P.NEW_QTY							AS SHIP_PLAN_QTY   -- 출하계획수량
					 , P.DIVISION_ID + '_' + C.PLAN_START_YYYYMMDD + '_' + @IF_GROUP_NO	AS ATTR_01      
					 , P.PROJECT_CODE					AS ATTR02           
					 -- 230411 jilee 프로젝트 Name명 추가
					 , ISNULL((SELECT TOP 1 M.PROJECT_NAME FROM SCM_MST_PROJECT M with(nolock) 
							   WHERE M.DIVISION_ID = P.DIVISION_ID AND M.PROJECT_CODE = P.PROJECT_CODE),NULL) 
														AS ATTR05           
  				  FROM dbo.SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE P (NOLOCK)
					   JOIN   SSP_ANL_SHIP_CONFIRM C (NOLOCK)
						ON  P.DIVISION_ID					= C.DIVISION_ID
						AND P.FROM_SITE						= C.FROM_SITE
						AND P.CONFIRM_ID					= C.CONFIRM_ID
					   JOIN   SCM_MST_SITE              TAB (NOLOCK)
						ON TAB.DIVISION_ID					= P.DIVISION_ID
					   AND TAB.SCM_SITE_ID					= P.FROM_SITE
					   AND TAB.SITE_TYPE = 'PLANT'
					   AND TAB.VALID_YN = 'Y'
					   AND TAB.OSP_YN   = 'Y'
					   AND TAB.OPERATION_GROUP = 'P'
				  
				 WHERE 1=1 
				   --ESS 고정
				   AND P.DIVISION_ID = '82'
				   AND P.CHANGE_REQ_NO					= @p_change_req_no
			) A
			LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.PACKER_CODE = X1.OLD_VALUE1
			   ;

		   END 
		 

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT TRAN TX_SH;
          END;       


        -- TXN LOG
        SET @v_log_type = N'TXN';    -- ▶ 로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date =  SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;      

    END
    END TRY

    BEGIN CATCH
      IF @@TRANCOUNT > 0
        BEGIN
          ROLLBACK TRAN TX_SH
        END;
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;
--      PRINT @@ERROR
      return -1
    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['++'][' + @v_exec_time + ']';  
    SET @d_event_date = SYSDATETIME()  ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
   
    return 1  

  END; 
