


/*
 * Program ID   : PR_SCP_PLN_MRP_PROD_TARGET_NERP_CREATE
 * Description  : MRP 생산TARGET 전송용 정보 생성 : 전송은 SAP PI에서 별도로 PR_SCP_PLN_MRP_PROD_TARGET_NERP 호출하여 처리
 * OutTable     :
 * Execute      : EXEC PR_SCP_PLN_MRP_PROD_TARGET_NERP_CREATE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024.04.22   vadabi5       Initial Release  NERP) 데이터 송신 위한 작업
 * 2024.04.25   vadabi5       NERP) ATTR2, ATTR3, ATTR4 ERP 매핑 필요
 * 2024.04.25   vadabi5       NERP) ERP_OPER_CD 매핑 안되는 경우 = OSP Plant 송신 불필요
                              -> 송신하는 것으로 변경, ERP_OPER_CD = NULL, OPER_GRP_CD = X 로 전송 -> OSP_YN으로 구분
							  -> ATTR_05 = Vendor/Customer

 * 2024.07.15   vadabi5       NERP) Workcenter 정책 결정까지 값 Null 셋팅
 * 2024.08.28   vadabi5       NERP) 변수 사용 개선
 * 2024.09.04   vadabi5       NERP) NERP 협의 사항 확인
                                    사용안함) ATTR02, ATTR03, ATTR04 
								    사용) ATTR01, ATTR05
 * 2024.12.04   vadabi5       NERP) 변경전 - 1차 롤인 대상 외에도 데이터는 생성 - I/F 데이터 전송 시 1차 롤인 대상 Plant 만 Lookup에 등록 및 필터링해서 전송
									변경후 - 1차 롤인 대상만 데이터 생성 (nerp에는 신코드만 전송 해야 함)								
 * 2025.01.12   kimcd         NERP) SCM_MST_OPERATION_SN JOIN 컬럼을 ST_DIV_CD에서 ORIGIN_DIVISION_ID로 변경
 * 2025.03.13   kimcd         VN00162200  오류 보완
 * 2025.05.28   kimcd         PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 *                            E20250417-001427 SCP→NERP I/F시 Cell수량 data 요청의 건
 * 2025.10.17	YMH			  E20251010-000329 FP와 SCP 간 계획 매칭을 위한 NPP0220 I/F 시 Operation ID 추가 전송 요청 									
 * 2025.10.31	YMH			  E20251020-000203 Plant/Plant Type 별로 데이터를 송신할 수 있도록 기능 변경
 * 2025.12.18   hrkim         [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선
 *                            JV ESS 생산에 따른 가상 Plant 계획 정보를 JV에 생산 Target으로 생성
 *                            가상 라인 계획은 FP로 전송하는 대상에서 제외
 * 2026.07.21	ymh			  E20260716-001301 Virtual Plant 생산계획 MRP 전송 로직 수정 요청
--------------------------------------------------------------------------------------------------------------
exec PR_SCP_PLN_MRP_PROD_TARGET_NERP_CREATE  @p_division_id	= '82'
								    , @p_start_yyyymmdd = '20240318'
								    , @p_plan_type      = 'FN'
								    , @p_seq            = 1
								    , @p_user_id        = 'SP_RUN_SCP'
--------------------------------------------------------------------------------------------------------------
exec PR_SCP_PLN_MRP_PROD_TARGET_NERP_CREATE       @p_division_id	= '82'
								    , @p_start_yyyymmdd = '20240318'
								    , @p_plan_type      = 'FN'
								    , @p_seq            = 1
								    , @p_user_id        = 'SP_RUN_SCP'
--------------------------------------------------------------------------------------------------------------
			select top 100 ta.*
			  FROM dbo.SCP_PLN_PROD_PLAN_TARGET_V ta WITH(NOLOCK)
   LEFT OUTER JOIN SCP_MST_FINAL_ITEM fi WITH(NOLOCK)
			    ON  ta.ORIGIN_DIVISION_ID = fi.DIVISION_ID
			   AND ta.ITEM_ID            = fi.ITEM_ID
             WHERE 1=1
               AND ta.DIVISION_ID              = '82'
            -- AND ta.PLAN_START_YYYYMMDD      = '20240318'
               AND ta.PLAN_TYPE                = 'FN'
               AND ta.SEQ                      = 1
--------------------------------------------------------------------------------------------------------------		
select * from XIF_SCP_PROD_TARGET_MRP_S_SN where if_id = 'NPP0220'
select * from SCP_PLN_INTERFACE_SEND_NPP_H where if_id = 'NPP0220'
--------------------------------------------------------------------------------------------------------------		
select * from SCM_SYS_LOG_BATCH 
where program_name = 'PR_SCP_PLN_MRP_PROD_TARGET_NERP' 
and event_date > getdate()-1 
order by event_date
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_PLN_MRP_PROD_TARGET_NERP_CREATE]
    ( 
      @p_division_id          NVARCHAR(10)
    , @p_start_yyyymmdd       NVARCHAR(8)
    , @p_plan_type            NVARCHAR(40)
    , @p_seq                  INT
    , @p_user_id              NVARCHAR(100)
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정 
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_MRP_PROD_TARGET_NERP_CREATE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'NERP_BATCH'; 
    DECLARE @d_event_date   DATETIME;
    DECLARE @d_start_date   DATETIME = SYSDATETIME();
    DECLARE @d_end_date   DATETIME; 

	---### Start [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 -- 
	DECLARE @v_from_division_id		NVARCHAR(30); -- [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선

	IF OBJECT_ID('tempdb..#Tbl_PROD_PLAN') IS NOT NULL	 DROP TABLE #Tbl_PROD_PLAN
	CREATE TABLE #Tbl_PROD_PLAN (
		 DIVISION_ID		NVARCHAR(50)
		,SITE_ID			NVARCHAR(50) 
		,PLANT_ID			NVARCHAR(50)
		,OPERATION_ID		NVARCHAR(50)
		,PRODUCTION_LINE	NVARCHAR(50)
		,FCST_TYPE			NVARCHAR(50)
		,ITEM_ID			NVARCHAR(50)
		,NICK_NAME			NVARCHAR(50)
		,PROD_PARTIAL_WEEK	NVARCHAR(50) 
		,PROD_QTY_MRP		NUMERIC(20, 10) 
		,PROD_IN_QTY		NUMERIC(20, 10) 
		,DOM_EXP			NVARCHAR(50) 
		,OPERATION_GROUP	NVARCHAR(50) 
		,CREATE_USER_ID		NVARCHAR(50) 
		,CREATE_DATE		NVARCHAR(50) 
		,MODIFY_USER_ID		NVARCHAR(50) 
		,MODIFY_DATE		NVARCHAR(50) 
		,ORIGIN_DIVISION_ID NVARCHAR(50) 
		);
	---### End [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 -- 


  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = CONCAT( @p_division_id, ',' + @p_start_yyyymmdd, ',' + @p_plan_type, ',' + CONVERT(NVARCHAR(10), @p_seq), ',' + @p_user_id) ;
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;



							  
        ----------------------------------------------------------- 
        -- 0. validation
        -- PLAN_TYPE='MA','FN', CONFIRM된 경우에 처리함.
        -----------------------------------------------------------
		-- E20251020-000203 Plant/Plant Type 별로 데이터를 송신할 수 있도록 기능 변경
        IF @p_plan_type NOT IN ( 'MA','SE','FN' )
           BEGIN
				EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
										  ,@p_log_type      ='END'
										  ,@p_log_count     =@n_log_count 
										  ,@p_log_message   =N'PLAN_TYPE=MA,FN, CONFIRM된 경우에 처리함.' 
										  ,@p_description   =@v_description 
										  ,@p_event_date    =@d_event_date 
				RETURN;
           END
 
        ----------------------------------------------------------
        -- 해당주차 SCP자동으로 수행하여 인터페이스 안내리도록
        -- SCP_PLN_INTERFACE_YN에 N으로 셋팅시 수행안함.
        ----------------------------------------------------------


        DECLARE @X_FP_TARGET_YN			NVARCHAR(1) = 'Y';
        DECLARE @X_MRP_TARGET_YN		NVARCHAR(1) = 'Y';
		DECLARE @X_START_YYYYMMDD       NVARCHAR(8);
		

		-- 20250701 프로시저 파라미터세팅하여 수행되게 수정.
        IF LEN(ISNULL(@P_START_YYYYMMDD,'')) = 8 
            BEGIN            
                SET @X_START_YYYYMMDD = @P_START_YYYYMMDD;  
            END     
        ELSE
            BEGIN
                SET @X_START_YYYYMMDD = DBO.FN_GET_BUCKET_YYYYMMDD(0);
            END


        SELECT @X_FP_TARGET_YN =  ISNULL(FP_TARGET_YN,'Y'),
               @X_MRP_TARGET_YN =  ISNULL(MRP_TARGET_YN,'Y')
          FROM SCP_PLN_INTERFACE_YN WITH(NOLOCK)
         WHERE DIVISION_ID         = @p_division_id 
           AND PLAN_START_YYYYMMDD = @X_START_YYYYMMDD   

        IF @X_MRP_TARGET_YN = 'N'
           BEGIN
				EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
										  ,@p_log_type      ='END'
										  ,@p_log_count     =@n_log_count 
										  ,@p_log_message   =N'SCP_PLN_INTERFACE_YN에 N으로 셋팅시 수행안함' 
										  ,@p_description   =@v_description 
										  ,@p_event_date    =@d_event_date 
              RETURN;
           END



   --BEGIN TRANSACTION; 
              
    BEGIN 
      BEGIN
           
        IF @p_user_id IS NULL 
           BEGIN
              SET @p_user_id = 'SP_SCP';
           END                


        IF (@p_division_id      IS NULL OR @p_division_id    = '')
		OR (@p_start_yyyymmdd   IS NULL OR @p_start_yyyymmdd = '')
		OR (@p_plan_type        IS NULL OR @p_plan_type      = '')
		OR (@p_seq              IS NULL OR @p_seq            = '')
           BEGIN
				EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
										  ,@p_log_type      ='PARAM'
										  ,@p_log_count     =@n_log_count 
										  ,@p_log_message   ='PARAM ERROR' 
										  ,@p_description   =@v_description 
										  ,@p_event_date    =@d_event_date 
										  ;
				RETURN;
           END         


        ----------------------------------------------------------- 
        -- 1. interface data creation
        -----------------------------------------------------------        

            
            DECLARE @X_CNT                  INT           = 0;
            DECLARE @X_SEND_SEQ             INT           = 1;
            
            DECLARE @X_IF_SEQ               VARCHAR(50);  -- MQ SEQ
            DECLARE @X_IF_TYPE              NVARCHAR(1)   = 'I';
            DECLARE @X_IF_ID                NVARCHAR(50)  = 'NPP0220';
            DECLARE @X_IF_INS_DATE          DATETIME      = GETDATE();
            DECLARE @X_IF_FLAG              NVARCHAR(100)  = 'N';
            DECLARE @X_IF_SND_DATE          DATETIME  = GETDATE();
            
            DECLARE @X_ST_PLAN_TYP          NVARCHAR(40)    = @p_plan_type;
            DECLARE @X_PLAN_VERSION         NVARCHAR(12);

            
            SELECT @X_CNT = COUNT(1)
              FROM DBO.SCP_PLN_INTERFACE_SEND_NPP_H WITH(NOLOCK)
             WHERE PLAN_START_YYYYMMDD = @X_START_YYYYMMDD
               AND DIVISION_ID         = @P_DIVISION_ID
               AND PLAN_TYPE           = @P_PLAN_TYPE
               AND IF_ID               = @X_IF_ID;   
      

            IF (@X_CNT > 0)
               BEGIN
                    SELECT @X_CNT = MAX(IFSEQNO)
                      FROM DBO.SCP_PLN_INTERFACE_SEND_NPP_H WITH(NOLOCK)
                     WHERE PLAN_START_YYYYMMDD = @X_START_YYYYMMDD
                       AND DIVISION_ID         = @P_DIVISION_ID
                       AND PLAN_TYPE           = @P_PLAN_TYPE
                       AND IF_ID               = @X_IF_ID;  

                    SET @X_SEND_SEQ = @X_CNT + 1;    
               END
      
			-----------------------------------------------------------------------------------------------------
			---- Start  [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 ---- 
			-----------------------------------------------------------------------------------------------------
			SELECT TOP 1 @v_from_division_id = VS.DIVISION_ID
			 FROM SCM_MST_SITE VS WITH(NOLOCK)	-- Virtual Plant Site 
				  INNER JOIN SCM_MST_SITE RS WITH(NOLOCK) -- JV Real Plant SITE
						  ON RS.DIVISION_ID = @p_division_id -- JV Real Plant Division
						 AND RS.SCM_SITE_ID = VS.ATTRIBUTE9 
						 AND RS.VALID_YN	= 'Y'
			WHERE 1=1
			  AND VS.SITE_TYPE				= 'PLANT'
			  AND VS.VALID_YN				= 'Y'
			  AND ISNULL(VS.ATTRIBUTE9, '') != ''
			
			IF @v_from_division_id > ''
			   BEGIN
				SET @v_log_type = N'LOG';
				SET @v_log_message = N'########## make temp plan ##########';
				SET @v_description = @v_program_name + ':'  + N' make temp plan ';
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
										  ,@p_log_type      =@v_log_type
										  ,@p_log_count     =@n_log_count 
										  ,@p_log_message   =@v_log_message 
										  ,@p_description   =@v_description 
										  ,@p_event_date    =@d_event_date 
										  ;
				------------------------------------------------------------------------------------------------------------  
				print  convert(varchar(30), getdate(), 121) + N' 가상 사이트 포함 division 생산계획' 
				------------------------------------------------------------------------------------------------------------  

				;	WITH PLAN_SEQ AS (  SELECT PLAN_NAME, PLAN_SEQ, PLAN_TYPE,DIVISION_ID
										FROM  (SELECT PM.PLAN_NAME
													, PD.PLAN_SEQ
													, PD.PLAN_TYPE
													 ,PM.DIVISION_ID
													 ,ROW_NUMBER() OVER (PARTITION BY PM.DIVISION_ID
																		 ORDER BY  CASE PD.PLAN_TYPE WHEN 'FN' THEN 1
																									 WHEN 'SE' THEN 2 
																									 WHEN 'MA' THEN 3
																									 WHEN 'PR' THEN 4 
																									 ELSE 5 
																					END
																				  , CASE WHEN PD.CONFIRM_FLAG = 'Y' 
																						 THEN 1 
																						 ELSE 2
																					END
																				  ,PD.PLAN_SEQ DESC) AS NUM
												FROM   SCM_MST_PLAN        PM WITH(NOLOCK)
													   INNER JOIN SCM_MST_PLAN_DETAIL PD WITH(NOLOCK)
		   													   ON PM.PLAN_ID     = PD.PLAN_ID
															  AND PM.DIVISION_ID = PD.DIVISION_ID
												WHERE  PM.DIVISION_ID        IN (	SELECT  MS2.DIVISION_ID
																					FROM    SCM_MST_SITE MS WITH(NOLOCK)
																							INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
																									ON MS.SCM_SITE_ID = MS2.ATTRIBUTE9  -- 실제 생산 Site가 Attribute9에 관리됨
																					WHERE   MS.DIVISION_ID = @p_division_id
																					AND     MS.SITE_TYPE   = 'PLANT'
																					AND     MS.VALID_YN    = 'Y')
												AND    PM.PLAN_NAME          = @p_start_yyyymmdd
												AND    PM.PLAN_CYCLE         = 'WEEKLY'
												AND    PD.PLAN_STATUS        = '1'
												AND    PD.DISPLAY_YN         = 'Y'
												AND    PD.UI_DISPLAY_YN      = 'Y'
												AND    PD.NORMAL_COMPLETE_YN = 'Y'
												AND    PD.ACTIVE_FLAG        = 'Y' ) TP
										WHERE	NUM = 1 
										-- E20260716-001301 생산계획 수립하는 DIV의 PLAN_TYPE 이 FN 일때만 혼용생산 데이터 전송.
										AND		PLAN_TYPE = 'FN' 
					)
					INSERT INTO #Tbl_PROD_PLAN
						(	 DIVISION_ID		
							,SITE_ID			
							,PLANT_ID			
							,OPERATION_ID		
							,PRODUCTION_LINE	
							,FCST_TYPE			
							,ITEM_ID			
							,NICK_NAME			
							,PROD_PARTIAL_WEEK	
							,PROD_QTY_MRP		
							,PROD_IN_QTY		
							,DOM_EXP			
							,OPERATION_GROUP	
							,CREATE_USER_ID		
							,CREATE_DATE		
							,MODIFY_USER_ID		
							,MODIFY_DATE		
							,ORIGIN_DIVISION_ID 
							)
					  SELECT  MS2.DIVISION_ID	AS DIVISION_ID
							 ,MS2.SCM_SITE_ID	AS SITE_ID			
							 ,MS2.PLANT_ID	
							 ,SUB.OPERATION_ID		
							 ,MS2.LINE_ID		AS PRODUCTION_LINE	
							 ,SUB.FCST_TYPE			
							 ,SUB.ITEM_ID			
							 ,SUB.NICK_NAME			
							 ,SUB.PROD_PARTIAL_WEEK	
							 ,SUB.PROD_QTY_MRP		
							 ,SUB.PROD_IN_QTY		
							 ,SUB.DOM_EXP			
							 ,SUB.OPERATION_GROUP	
							 ,SUB.CREATE_USER_ID		
							 ,SUB.CREATE_DATE		
							 ,SUB.MODIFY_USER_ID		
							 ,SUB.MODIFY_DATE		
							 ,MS2.DIVISION_ID	AS ORIGIN_DIVISION_ID 
					  FROM (  SELECT  ITEM_ID 
								    , NICK_NAME
									, OPERATION_GROUP   
									, OPERATION_ID      
									, SITE_ID
									, PLANT_ID
									, PROD_WEEK
									, PROD_PARTIAL_WEEK
									, YYYYMMDD
									, PROD_QTY_MRP
									, PROD_IN_QTY
									, FCST_TYPE
									, PRODUCTION_LINE
									, X.DIVISION_ID
									, DOM_EXP
									, CREATE_USER_ID
									, CREATE_DATE
									, MODIFY_USER_ID
									, MODIFY_DATE
									, ORIGIN_DIVISION_ID
								 FROM dbo.SCP_PLN_PROD_PLAN_TARGET_V X WITH(NOLOCK)
									  INNER JOIN PLAN_SEQ  PS
										   ON     X.division_id         = PS.DIVISION_ID
										   AND    X.plan_start_yyyymmdd = @p_start_yyyymmdd
										   AND    X.plan_type           = PS.PLAN_TYPE
										   AND    X.seq                 = PS.PLAN_SEQ
							) AS SUB
				  INNER JOIN ( SELECT LM.OPERATION_ID
									, LM.ELECTRODE_TYPE
									, MS.DIVISION_ID
									, MS.SCM_SITE_ID
									, LM.LINE_ID
									, LM.PLANT_ID
									, MS2.DIVISION_ID AS LINK_DIVISION_ID
									, MS2.SCM_SITE_ID AS LINK_SCM_SITE_ID
									, LM.LINK_LINE_ID
								 FROM   SCM_MST_SITE MS WITH(NOLOCK)
										INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
												ON MS.SCM_SITE_ID = MS2.ATTRIBUTE9  -- 실제 생산 Site가 Attribute9에 관리됨
										INNER JOIN SCM_MST_LINE_SN LM WITH(NOLOCK)
												ON LM.PLANT_ID = MS.PLANT_ID
											   AND LM.LINK_LINE_ID > ''
								WHERE   MS.DIVISION_ID = @p_division_id
								  AND   MS.SITE_TYPE   = 'PLANT'
								  AND   MS.VALID_YN    = 'Y'
								) MS2
							ON  SUB.DIVISION_ID     = MS2.LINK_DIVISION_ID
							AND SUB.SITE_ID         = MS2.LINK_SCM_SITE_ID
							AND SUB.OPERATION_ID    = MS2.OPERATION_ID
							AND SUB.PRODUCTION_LINE = MS2.LINK_LINE_ID
							;

						SET	@n_log_count = @@ROWCOUNT;
						SET @v_log_type = N'LOG';
						SET @v_log_message = N'########## END make temp plan ##########';
						SET @v_description = @v_program_name + ':'  + N' END make temp plan ';
						SET @d_event_date = SYSDATETIME();
						EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
												  ,@p_log_type      =@v_log_type
												  ,@p_log_count     =@n_log_count 
												  ,@p_log_message   =@v_log_message 
												  ,@p_description   =@v_description 
												  ,@p_event_date    =@d_event_date 
												  ;
						SET @n_log_count = 0;
			  END;	---// IF @v_from_division_id > ''
			---------------------------------------------------------------------------------------------------
			---- End  [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 ----
			---------------------------------------------------------------------------------------------------


            -- 전송주차 = 해당주차의 월요일 일자 YYYYMMDD + '001' 일련번호
            SET @X_PLAN_VERSION = @X_START_YYYYMMDD + '_' + DBO.FN_ZERO_LPAD( @X_SEND_SEQ,3 );
      
            BEGIN

			IF OBJECT_ID('tempdb..#TMP_NPP0220_SEND_DATE') IS NOT NULL            
                DROP TABLE #TMP_NPP0220_SEND_DATE            


       
				;WITH W_OPER AS
				(
						SELECT DISTINCT DIVISION_ID			
							  ,OPERATION_ID		
							  ,ERP_OPERATION_ID	
						FROM SCM_MST_OPERATION_SN WITH (nolock)	
						WHERE active_flag = 'Y'
				)
			   , W_PLANT AS
				(
						SELECT OLD_VALUE1 AS CODE_ASIS
						     , NEW_VALUE1 AS CODE_TOBE
						FROM NERP_CONV_MASTER WITH (nolock)	-- 개발DB NERP_CONV_MASTERS, QA DB = NERP_CONV_MASTER
						WHERE codetype = 'PLANT_ID'
				)
			   , W_PLANT_OSP AS
				(
						SELECT SCM_SITE_ID
								, PLANT_ID
								, VALID_YN 
						  FROM SCM_MST_SITE 
						 WHERE OSP_YN = 'Y'
				)
			   , W_SITE AS
				(
						SELECT CODETYPE
							 , OLD_VALUE1 AS CD_ASIS
							 , NEW_VALUE1 AS CD_TOBE
						  FROM NERP_CONV_MASTER WITH (nolock)	-- 개발DB NERP_CONV_MASTERS, QA DB = NERP_CONV_MASTER
						 WHERE CODETYPE = 'PLANT_ID'

						  UNION ALL

						SELECT CODETYPE
							 , OLD_VALUE1 AS CD_ASIS
							 , NEW_VALUE1 AS CD_TOBE
						  FROM NERP_CONV_MASTER WITH (nolock)	-- 개발DB NERP_CONV_MASTERS, QA DB = NERP_CONV_MASTER
						 WHERE CODETYPE = 'VENDOR_ID'
		
						 UNION ALL
						SELECT CODETYPE
							 , OLD_VALUE1 AS CD_ASIS
							 , NEW_VALUE1 AS CD_TOBE
						  FROM NERP_CONV_MASTER WITH (nolock)	-- 개발DB NERP_CONV_MASTERS, QA DB = NERP_CONV_MASTER
						 WHERE CODETYPE = 'END_CUSTOMER_ID'
				)

				SELECT 	PLAN_VERSION
					  , ST_PLAN_TYP			, ST_DIV_CD		
					  , CASE WHEN WS.CD_ASIS IS NOT NULL 
					         THEN CONCAT(WS.CD_TOBE,ST_SCP_SITE_CD_TAIL)
					         ELSE ST_SCP_SITE_CD
							 END AS ST_SCP_SITE_CD	
				    --, ST_SCP_SITE_CD
				    --, ST_SCP_SITE_CD_BODY
				    --, ST_SCP_SITE_CD_TAIL
					--, ST_PLANT_CD							AS ST_PLANT_CD_ASIS					 
					  , ISNULL(CODE_TOBE,ST_PLANT_CD) 	    AS ST_PLANT_CD
					  , OPER_CD_ORG	 -- 2025.05.28 kimcd NERP 라인 찾기용 공정 추가
				      , ISNULL(ERP_OPERATION_ID,'')			    AS ST_OPER_CD
					  , ST_LINE_CD			, ST_PROD_TYP		, ST_ITEM_CD			, ST_NICK_NM		, ST_PLAN_DT		
					  , ST_PLAN_QTY		    , ST_PLAN_IN_QTY	, ST_PROD_WEEK			, ST_MKT_FLAG		
					  , CASE WHEN wpo.SCM_SITE_ID IS NOT NULL 
					         THEN 'X'
					         ELSE ST_OPER_GRP_CD
							 END ST_OPER_GRP_CD
					  , CREATE_USER_ID		, CREATE_DATE		, MODIFY_USER_ID		, MODIFY_DATE		
					--, CELL_ITEM_ID		
					  , CONVERT_QTY_CELL	 -- 2025.05.28 kimcd NERP에 Cell 환산 수량 추가



			 		  , ORIGIN_DIVISION_ID					AS ATTR_01
			 		  , NULL								AS ATTR_02 ------- E20251020-000203 PLAN_VALID 로 사용.
			 		  , NULL								AS ATTR_03
					  , NULL								AS ATTR_04
			 		--,'MASS'								AS ATTR_02
			 		--,'E6D01ACT'							AS ATTR_03
					--,'001'								AS ATTR_04
					/*
					-- 20240715 정책결정시까지 값 Null
					  ,CASE WHEN ST_PROD_TYP = 'MPS' THEN 'MASS'
					        WHEN ST_PROD_TYP = 'TST' THEN 'SAMPLE'
							ELSE 'MASS'
					        END AS ATTR_02
					  ,CONCAT(ST_LINE_CD,'N',ERP_OPERATION_ID) AS ATTR_03
					  ,CASE WHEN ST_PROD_TYP = 'MPS' THEN '001'
					        WHEN ST_PROD_TYP = 'TST' THEN '010'
							ELSE '001'
					        END AS ATTR_04
						*/
					  , CASE WHEN wpo.SCM_SITE_ID IS NOT NULL 
					         THEN wpo.PLANT_ID
					         ELSE NULL
							 END ATTR_05
					
				INTO #TMP_NPP0220_SEND_DATE
				FROM
				(
				SELECT  LIST.*
					  , WP.CODE_TOBE
					  , WO.ERP_OPERATION_ID
					  , CASE 
					    WHEN CHARINDEX('-', ST_SCP_SITE_CD) > 0 AND CHARINDEX('_', ST_SCP_SITE_CD) > 0 THEN dbo.FN_SCM_SPLIT(ST_SCP_SITE_CD, 0, '_')
						WHEN CHARINDEX('-', ST_SCP_SITE_CD) > 0 THEN dbo.FN_SCM_SPLIT(ST_SCP_SITE_CD, 0, '-')
						ELSE NULL
						END AS ST_SCP_SITE_CD_BODY

					  , CASE 
					    WHEN CHARINDEX('-', ST_SCP_SITE_CD) > 0 AND CHARINDEX('_', ST_SCP_SITE_CD) > 0 
						THEN REPLACE(ST_SCP_SITE_CD, dbo.FN_SCM_SPLIT(ST_SCP_SITE_CD, 0, '_') , '')
						WHEN CHARINDEX('-', ST_SCP_SITE_CD) > 0 
						THEN REPLACE(ST_SCP_SITE_CD, dbo.FN_SCM_SPLIT(ST_SCP_SITE_CD, 0, '-') , '')
						ELSE ''
						END AS ST_SCP_SITE_CD_TAIL
			
				FROM 
				(
                 SELECT  
                          @X_PLAN_VERSION               AS PLAN_VERSION
                        , @P_PLAN_TYPE                  AS ST_PLAN_TYP 
                        , ta.DIVISION_ID                AS ST_DIV_CD
                        , ta.SITE_ID                    AS ST_SCP_SITE_CD
                        , ta.PLANT_ID                   AS ST_PLANT_CD
                        , ta.OPERATION_ID               AS OPER_CD_ORG
                        , ta.PRODUCTION_LINE            AS ST_LINE_CD
                        , ta.FCST_TYPE                  AS ST_PROD_TYP
                        , ta.ITEM_ID                    AS ST_ITEM_CD
						, MAX(ta.NICK_NAME)             AS ST_NICK_NM
                        -- 20190903 [CSR ID 4074962]  PROD_WEEK 대신 Partial 기준 PROD_PARTIAL_WEEK 정보 사용
                        , ta.PROD_PARTIAL_WEEK          AS ST_PLAN_DT    
                      --, ta.PROD_WEEK                  AS PLAN_DT  
                        , SUM(ta.PROD_QTY_MRP)          AS ST_PLAN_QTY
                        , SUM(ta.PROD_IN_QTY)           AS ST_PLAN_IN_QTY
                        -- 20190903 [CSR ID 4074962]  PROD_WEEK 대신 Partial 기준 PROD_PARTIAL_WEEK 정보 사용
                        , ta.PROD_PARTIAL_WEEK          AS ST_PROD_WEEK  
						, ta.DOM_EXP                    AS ST_MKT_FLAG
                        , MAX(ta.OPERATION_GROUP)       AS ST_OPER_GRP_CD

                        , MAX(ta.CREATE_USER_ID)        AS CREATE_USER_ID
						, MAX(ta.CREATE_DATE)           AS CREATE_DATE
						, MAX(ta.MODIFY_USER_ID)        AS MODIFY_USER_ID
                        , MAX(ta.MODIFY_DATE)           AS MODIFY_DATE
                        , ta.ORIGIN_DIVISION_ID         AS ORIGIN_DIVISION_ID
                        , MAX(fi.CELL_ITEM_ID)          AS CELL_ITEM_ID			-- 20190930 전극 Cell 환산자 처리
                        , MAX(fi.CONVERT_QTY_CELL)      AS CONVERT_QTY_CELL		-- 20190930 전극 Cell 환산자 처리

                        --, ta.PROD_WEEK                  AS PROD_WEEK
                     FROM dbo.SCP_PLN_PROD_PLAN_TARGET_V ta WITH(NOLOCK)

					      -- 20190930 전극 Cell 환산자 처리 : 전극 Item 만 정보 추가
		  LEFT OUTER JOIN SCP_MST_FINAL_ITEM fi WITH(NOLOCK) ON  ta.ORIGIN_DIVISION_ID = fi.DIVISION_ID
						                                    AND ta.ITEM_ID             = fi.ITEM_ID
                    WHERE 1=1
                      AND ta.DIVISION_ID              = @p_division_id    --'81'
                      AND ta.PLAN_START_YYYYMMDD      = @p_start_yyyymmdd --'20180319'
                      AND ta.PLAN_TYPE                = @p_plan_type      --'MA'
                      AND ta.SEQ                      = @p_seq            --11
 					------------------------------------------------------------------------------------------------------------------------------
					---- Start  [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 : 가상 라인 계획은 FP로 전송하는 대상에서 제외
					------------------------------------------------------------------------------------------------------------------------------
					  AND NOT EXISTS (SELECT TOP 1 1
									  FROM   SCM_MST_LINE_SN ML WITH(NOLOCK)
									  WHERE  ML.DIVISION_ID		= TA.DIVISION_ID
									  AND    ML.OPERATION_ID	= TA.OPERATION_ID
									  AND    ML.PLANT_ID		= TA.PLANT_ID
									  AND    ML.LINE_ID			= TA.PRODUCTION_LINE
									  AND    ML.ACTIVE_FLAG		= 'Y'
									  AND    ML.VIRTUAL_LINE_YN = 'Y'
									  AND    ML.LINK_LINE_ID	> '' )
					------------------------------------------------------------------------------------------------------------------------------
					---- End  [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 : 가상 라인 계획은 FP로 전송하는 대상에서 제외
					------------------------------------------------------------------------------------------------------------------------------
					-- E20260716-001301 2차 수정안 시작
					AND NOT EXISTS (SELECT TOP 1 1
									FROM [dbo].[FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP]() AS LINE_MAP
									WHERE	LINE_MAP.RL_DIVISION_ID		= TA.DIVISION_ID
									AND		LINE_MAP.RL_PLANT_ID		= TA.PLANT_ID
									AND		LINE_MAP.RL_LINE_ID			= TA.PRODUCTION_LINE )
					-- E20260716-001301 2차 수정안 끝
                   GROUP BY
                          ta.DIVISION_ID   
                        , ta.SITE_ID
                        , ta.PLANT_ID
                        , ta.OPERATION_ID
                        , ta.PRODUCTION_LINE
                        , ta.FCST_TYPE
                        , ta.ITEM_ID
                        -- 20190903 [CSR ID 4074962]  PROD_WEEK 대신 Partial 기준 PROD_PARTIAL_WEEK 정보 사용
                        , ta.PROD_PARTIAL_WEEK
                        , ta.DOM_EXP
                        , ta.ORIGIN_DIVISION_ID   
				------------------------------------------------------------------------------------------------------------------------------
				---- Start  [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 : JV ESS 생산에 따른 가상 Plant 계획 정보를 JV에 생산 Target으로 생성
				------------------------------------------------------------------------------------------------------------------------------
				UNION ALL		
				SELECT
					  @X_PLAN_VERSION               AS PLAN_VERSION
                    , @P_PLAN_TYPE                  AS ST_PLAN_TYP 
                    , TA.DIVISION_ID				AS ST_DIV_CD
					, TA.SITE_ID					AS ST_SCP_SITE_CD		-- JV Real Plant Site 
					, TA.PLANT_ID					AS ST_PLANT_CD
					, TA.OPERATION_ID               AS OPER_CD_ORG
					, TA.PRODUCTION_LINE			AS ST_LINE_CD
					, TA.FCST_TYPE                  AS ST_PROD_TYP
					, TA.ITEM_ID                    AS ST_ITEM_CD
					, MAX(ta.NICK_NAME)             AS ST_NICK_NM
					, TA.PROD_PARTIAL_WEEK          AS ST_PLAN_DT    
					, SUM(TA.PROD_QTY_MRP)          AS ST_PLAN_QTY
					, SUM(TA.PROD_IN_QTY)           AS ST_PLAN_IN_QTY
					, TA.PROD_PARTIAL_WEEK          AS ST_PROD_WEEK  
					, TA.DOM_EXP                    AS ST_MKT_FLAG
					, MAX(TA.OPERATION_GROUP)       AS ST_OPER_GRP_CD
					, MAX(TA.CREATE_USER_ID)        AS CREATE_USER_ID
					, MAX(TA.CREATE_DATE)           AS CREATE_DATE
					, MAX(TA.MODIFY_USER_ID)        AS MODIFY_USER_ID
					, MAX(TA.MODIFY_DATE)           AS MODIFY_DATE
					, TA.DIVISION_ID				AS ORIGIN_DIVISION_ID
					, MAX(FI.CELL_ITEM_ID)          AS CELL_ITEM_ID			-- 20190930 전극 Cell 환산자 처리
					, MAX(FI.CONVERT_QTY_CELL)      AS CONVERT_QTY_CELL		-- 20190930 전극 Cell 환산자 처리
				 FROM #Tbl_PROD_PLAN TA WITH(NOLOCK)
					  LEFT  JOIN SCP_MST_FINAL_ITEM  FI  WITH(NOLOCK) 
							  ON FI.DIVISION_ID			= TA.ORIGIN_DIVISION_ID 
							 AND FI.ITEM_ID				= TA.ITEM_ID
				WHERE 1=1
				GROUP BY
					  TA.DIVISION_ID	
					, TA.SITE_ID			-- JV Real Plant Site 	
					, TA.PLANT_ID    
					, TA.OPERATION_ID
					, TA.PRODUCTION_LINE
					, TA.FCST_TYPE
					, TA.ITEM_ID
					, TA.PROD_PARTIAL_WEEK
					, TA.DOM_EXP
				------------------------------------------------------------------------------------------------------------------------------
				---- End  [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 : JV ESS 생산에 따른 가상 Plant 계획 정보를 JV에 생산 Target으로 생성
				------------------------------------------------------------------------------------------------------------------------------
			) LIST
			LEFT OUTER JOIN             W_OPER wo ON LIST.ORIGIN_DIVISION_ID = wo.DIVISION_ID   -- * 2025.01.12   kimcd         NERP) SCM_MST_OPERATION_SN JOIN 컬럼을 ST_DIV_CD에서 ORIGIN_DIVISION_ID로 변경
		                                         AND LIST.OPER_CD_ORG	     = wo.OPERATION_ID
  			LEFT OUTER JOIN             W_PLANT wp ON LIST.ST_PLANT_CD   = wp.CODE_ASIS
			) DATALIST
  			LEFT OUTER JOIN             W_SITE ws ON DATALIST.ST_SCP_SITE_CD_BODY   = ws.CD_ASIS
			LEFT OUTER JOIN             W_PLANT_OSP wpo ON DATALIST.OPER_CD_ORG   = wpo.PLANT_ID   -- 2025-03-13 kimcd VN00162200  오류 보완
			--WHERE DATALIST.ERP_OPERATION_ID IS NOT NULL
		                             
												 
						--#################################################
						-- RESULT
						--#################################################
												

				
						--#################################################
						-- XIF_SCP_PROD_TARGET_MRP_S_SN
						-- SELECT max(if_seq) from XIF_SCP_PROD_TARGET_MRP_S_SN
						-- SELECT * from XIF_SCP_PROD_TARGET_MRP_S_SN where if_seq like 'OSCP20240513%'
						--#################################################

						INSERT INTO XIF_SCP_PROD_TARGET_NPP_S_SN
						(
						 IF_SEQ			
						,IF_TYPE
						,IF_ID
						,IF_INS_DATE
						,IF_FLAG
						,IF_SND_DATE
						,PLAN_VRSN_ID       										  
						,PLAN_TYP           										  
						,DIV_CD             										  
						,SCP_SITE_CD        										  
						,PLANT_CD           										  
						,OPER_CD            										  
						,LINE_CD            										  
						,PROD_TYP           										  
						,ITEM_CD  													  
						,PLAN_DT            										  
						,MKT_FLAG           										  
						,PLAN_QTY           										  
						,PLAN_IN_QTY        										  
						,PROD_WEEK          										  
						,PJCT_NICK_NM       										  
						,OPER_GRP_CD        										  
						,REG_DTTM           										  
						,REG_USER_ID        										  
						,CHNG_DTTM          										  
						,CHNG_USER_ID       										  
						,ATTR_01            -- ORIGIN DIVISION ID					  
						,ATTR_02            -- E20251020-000203 PLAN_VALID 로 사용.
                        ,ATTR_03            -- 2025.05.28 kimcd 전극 Cell 환산자 처리 : PLAN_QTY * 환산자
                        ,ATTR_04            -- 2025.05.28 kimcd 전극 Cell 환산자 처리 : PLAN_IN_QTY * 환산자
						,ATTR_05            -- 20240513 OSP 일 경우 ORG_PLANT_ID	
						,ATTR_06			-- 2025.10.13 YMH [E20251010-000329] FP와 SCP 간 계획 매칭을 위한 NPP0220 I/F 시 Operation ID 추가 전송 요청

						)
						   SELECT 
						   		 'NPP0220_'+CONVERT(VARCHAR,GETDATE(),112)+ DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCP_PROD_TARGET_NPP_S),10) AS IF_SEQ
								, @X_IF_TYPE                    AS IF_TYPE
								, @X_IF_ID                      AS IF_ID
								, @X_IF_INS_DATE                AS IF_INS_DATE
								, @X_IF_FLAG                    AS IF_FLAG
								, @X_IF_SND_DATE                AS IF_SND_DATE
								, PLAN_VERSION
								, ST_PLAN_TYP 
								, ST_DIV_CD
								, ST_SCP_SITE_CD
								, ST_PLANT_CD
								, ISNULL(ST_OPER_CD,'')
								, ISNULL( ( SELECT TOP 1 ML.MES_LINE_ID
								            FROM   SCM_MST_LINE_SN  ML WITH(NOLOCK)
								            WHERE  ML.PLANT_ID      = T.ST_PLANT_CD
								            AND    ML.OPERATION_ID  = T.OPER_CD_ORG
								            AND    ML.LINE_ID       = T.ST_LINE_CD
								            AND    ML.ACTIVE_FLAG   = 'Y'
								            AND    ML.MES_LINE_ID  != '' ) , ST_LINE_CD)     AS ST_LINE_CD -- 2025.05.28 kimcd MES LINE ID 전환
								, ST_PROD_TYP
								, ST_ITEM_CD
								, ST_PLAN_DT 
								, ST_MKT_FLAG
								, ST_PLAN_QTY
								, ST_PLAN_IN_QTY
								, ST_PROD_WEEK  
								, ST_NICK_NM
								, ST_OPER_GRP_CD
								, CREATE_DATE
								, CREATE_USER_ID
								, MODIFY_DATE
								, MODIFY_USER_ID
								, ATTR_01		-- ORG DIVISION_ID
								-- , ATTR_02		-- E20251020-000203 PLAN_VALID 로 사용
								-- LOOKUP에 설정되어 있으면 설정된 PLANTYPE에만 VALID Y 
								-- LOOKUP에 설정되어 있지 않으면 FN PLANTYPE에만 VALID Y
								, CASE WHEN EXISTS( -- 1.존재여부 체크
										SELECT * 
										FROM	SCM_ADM_LOOKUP_MASTER_DETAIL AS LMD WITH(NOLOCK)
										WHERE	LOOKUP_TYPE		= 'NPP0220_PLANT_PLANTYPE'
										AND		ST_DIV_CD		= LMD.SEGMENT1
										AND		ST_PLANT_CD		= LMD.SEGMENT2	
										AND		LMD.VALID_YN	= 'Y'
									)
									THEN -- 1-1 존재하면 존재하는 타입만 Y 존재하지 않으면 N
										CASE WHEN EXISTS(
											SELECT *
											FROM	SCM_ADM_LOOKUP_MASTER_DETAIL AS LMD WITH(NOLOCK)
											WHERE	LOOKUP_TYPE		= 'NPP0220_PLANT_PLANTYPE'
											AND		ST_DIV_CD		=	LMD.SEGMENT1
											AND		ST_PLANT_CD		=	LMD.SEGMENT2
											AND		ST_PLAN_TYP		=	LMD.SEGMENT3
											AND		LMD.VALID_YN	= 'Y'
										) THEN 'Y' ELSE 'N' END
									-- 2. 존재하지 않으면 FN 만 Y
									ELSE IIF(ST_PLAN_TYP = 'FN','Y','N') 
								END AS ATTR_02 -- PLAN_VALID
                                , ST_PLAN_QTY * CONVERT_QTY_CELL    -- ATTR_03,  2025.05.28 kimcd 전극 Cell 환산자 처리 : PLAN_QTY * 환산자
                                , ST_PLAN_IN_QTY * CONVERT_QTY_CELL -- ATTR_04,  2025.05.28 kimcd 전극 Cell 환산자 처리 : PLAN_IN_QTY * 환산자
								, ATTR_05		-- OSP 일 경우 ORG_PLANT_ID	
								-- 2025.10.13 YMH [E20251010-000329] FP와 SCP 간 계획 매칭을 위한 NPP0220 I/F 시 Operation ID 추가 전송 요청 ATTR_06 반영 -- 벤더코드인경우는 공백처리.
								, IIF(
									(SELECT TOP 1 OSP_YN FROM SCM_MST_SITE WITH(NOLOCK) WHERE OSP_YN = 'Y' AND T.ST_SCP_SITE_CD = SCM_SITE_ID) = 'Y'
									AND
									NOT EXISTS(
										SELECT * FROM 
										(
											SELECT OPERATION_ID FROM SCM_OPERATION_M_SN WITH(NOLOCK) 
											GROUP BY OPERATION_ID
										) AS OPERATION_ID_LIST
										WHERE OPER_CD_ORG = OPERATION_ID
									) ,'',OPER_CD_ORG)   AS ATTR_06
						   FROM #TMP_NPP0220_SEND_DATE T
						  --20241204 추가 : 1차 Roll IN 대상만 데이터 생성
						  WHERE ST_PLANT_CD IN (SELECT  SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)WHERE LOOKUP_TYPE ='NERP_ROLLIN_PLANT')
 

						    SELECT @n_log_count = count(*) from #TMP_NPP0220_SEND_DATE
							EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
								,@p_log_type      ='INSERT'
								,@p_log_count     =@n_log_count 
								,@p_log_message   ='XIF_SCP_PROD_TARGET_NPP_S_SN' 
								,@p_description   = @X_IF_ID
								,@p_event_date    =@d_event_date 

							----#################################################
							---- SCP_PLN_INTERFACE_SEND_NPP_H
							---- SELECT * from SCP_PLN_INTERFACE_SEND_H
							----#################################################
						   INSERT INTO DBO.SCP_PLN_INTERFACE_SEND_NPP_H
                           ( 
						     PLAN_START_YYYYMMDD
                           , DIVISION_ID
                           , PLAN_TYPE
                           , IF_ID
                           , IFSEQNO
                           , CREATED_BY
                           , CREATION_DATE 
						   )
                           VALUES
                           (  
                             @X_START_YYYYMMDD
                           , @P_DIVISION_ID
                           , @P_PLAN_TYPE
                           , @X_IF_ID
                           , @X_SEND_SEQ
                           , @P_USER_ID
                           , GETDATE()    
                           );

						    SET @v_description  = CONCAT(@X_IF_ID,',',@P_USER_ID)
							EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
								,@p_log_type      ='INSERT'
								,@p_log_count     = @@ROWCOUNT 
								,@p_log_message   ='SCP_PLN_INTERFACE_SEND_NPP_H' 
								,@p_description   = @v_description
								,@p_event_date    = @d_event_date 


							--#################################################
							-- 저장 된 데이터 전송
							--#################################################
						   SELECT *  FROM #TMP_NPP0220_SEND_DATE	


            END    

 		IF OBJECT_ID('tempdb..#Tbl_PROD_PLAN') IS NOT NULL	 DROP TABLE #Tbl_PROD_PLAN	-- [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 : 임시테이블 정리

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
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@BATCH_TIME
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ;

      END;
    END 

  END;
