
-- DROP PROCEDURE [dbo].[PR_SCM_ELECTRODE_POST_PLAN_A]
-- PLAN ID 채번하는 로직 들어가야 함.  PLAN ID 채번 되었다고 가정하고 아래 프로시저 들어 감. 
-- 환산자가 여러개일 경우 선택 로직 들어가야 함
-- Daily Production Plan 테이블 생성 필요함

CREATE PROCEDURE [dbo].[PR_SCM_ELECTRODE_POST_PLAN_A_BACKUP]  
@p_master_id nvarchar(MAX) = '-', 
@p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS

/*************************************************************************************************/
/** 프로그램 ID	: PR_SCM_ELECTRODE_POST_PLAN_A													**/
/** 프로그램 명	:																				**/
/** 설 명		: 전극 후공정 계획 수립															**/
/** Version		: 1.0.0																			**/
/**																								**/
/** Argument																					**/
/**																								**/
/**  [검색 조건]																					**/
/**																								**/
/** [Biz Logic]																					**/
/**																								**/
/**---------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                       **/
/**=============================================================================================**/
/** 2019.08.18    이현수        최초 작성														**/
/** 2019.08.29    이현수        HOLD STOCK 추가													**/
/*************************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
  SET XACT_ABORT ON;


 -- 필수 칼럼

DECLARE   @V_MASTER_ID    nvarchar(30)  
DECLARE   @V_PLAN_ID      nvarchar(30)   
DECLARE   @V_PLAN_TYPE    nvarchar(30)
--DECLARE   @V_KEY_DATE     DATETIME   
--DECLARE   @V_CUTOFF       DATETIME   
DECLARE   @v_operation_01   nvarchar(30)
DECLARE   @KEY_DATE  DATE  
DECLARE   @CUTOFF_DATE  DATE 
	SET   @KEY_DATE     = CONVERT( DATE, GETDATE() ) 
	SET   @CUTOFF_DATE  = CONVERT( DATE, GETDATE() ) 

  -- LOG 용 변수 설정
  DECLARE  @v_proc_name      nvarchar(100) = 'PR_SCM_ELECTRODE_POST_PLAN_A'
  DECLARE  @v_table_name     nvarchar(100)
  DECLARE  @v_message        nvarchar(250)
  DECLARE  @v_descr          nvarchar(250)
  DECLARE  @n_row_count      Integer  = 0
  DECLARE  @n_log_count      Integer  = 0
  DECLARE  @v_log_code       nvarchar(10)
  DECLARE  @sysdate          DATETIME2 = GETDATE()
  --DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)


  SET @V_MASTER_ID    = @p_master_id
  SET @V_PLAN_ID      = @p_plan_id
  SET @V_PLAN_TYPE    = NULL
  
  --SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  

  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', @v_descr
  
  BEGIN

      --LOG 생성
      SET @v_table_name = 'SCM_FP_PLAN_H'
      SELECT  @KEY_DATE = CONVERT(DATE, PLAN_START_TIME)
            , @CUTOFF_DATE  = CONVERT(DATE, PLAN_START_TIME)
      FROM   (
              SELECT PLAN_START_TIME
              FROM   SCM_FP_PLAN_H
              WHERE  INSTANCE_ID = @V_MASTER_ID
              AND    PLAN_ID     = @V_PLAN_ID
             ) A
             
             
      --LOG 생성
      SET @v_message = 'KEY_DATE : ' + CONVERT(nvarchar, @KEY_DATE, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      
  END  

  BEGIN TRY

    -- BUFFER 테이블 삭제
    BEGIN        
	    
      DELETE FROM TH_BUF_EPOST_NOTCHING_PLAN       
      WHERE INSTANCE_ID = @V_MASTER_ID 
      AND FP_PLAN_ID = @V_PLAN_ID
      
      --LOG 생성
      SET @v_table_name = 'TH_BUF_EPOST_NOTCHING_PLAN'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
    
      DELETE FROM TH_BUF_EPOST_NOTCHING_MTR_PLAN   
      WHERE INSTANCE_ID = @V_MASTER_ID 
      AND FP_PLAN_ID = @V_PLAN_ID
      
      --LOG 생성
      SET @v_table_name = 'TH_BUF_EPOST_NOTCHING_MTR_PLAN'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
    
      DELETE FROM TH_BUF_EPOST_FACTORY_MAP         
      WHERE INSTANCE_ID = @V_MASTER_ID 
      AND FP_PLAN_ID = @V_PLAN_ID
      
      --LOG 생성
      SET @v_table_name = 'TH_BUF_EPOST_FACTORY_MAP'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
    
      DELETE FROM TH_BUF_EPOST_STOCK               
      WHERE INSTANCE_ID = @V_MASTER_ID 
      AND FP_PLAN_ID = @V_PLAN_ID
    
      --LOG 생성
      SET @v_table_name = 'TH_BUF_EPOST_STOCK'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
    
	  DELETE FROM TH_BUF_EPOST_STOCK_HOLD
      WHERE INSTANCE_ID = @V_MASTER_ID 
      AND FP_PLAN_ID = @V_PLAN_ID
    
      --LOG 생성
      SET @v_table_name = 'TH_BUF_EPOST_STOCK_HOLD'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr

      DELETE FROM TH_BUF_EPOST_NET_DEMAND          
      WHERE INSTANCE_ID = @V_MASTER_ID 
      AND FP_PLAN_ID = @V_PLAN_ID
    
      --LOG 생성
      SET @v_table_name = 'TH_BUF_EPOST_NET_DEMAND'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
    
      DELETE FROM TH_BUF_EPOST_SLITTING_PLAN       
      WHERE INSTANCE_ID = @V_MASTER_ID 
      AND FP_PLAN_ID = @V_PLAN_ID
    
      --LOG 생성
      SET @v_table_name = 'TH_BUF_EPOST_SLITTING_PLAN'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
    
	  DELETE FROM TH_BUF_EPOST_ROLLPRESS_PLAN      
	  WHERE INSTANCE_ID = @V_MASTER_ID 
	  AND FP_PLAN_ID = @V_PLAN_ID
	
	  --LOG 생성
      SET @v_table_name = 'TH_BUF_EPOST_ROLLPRESS_PLAN'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
    
	  DELETE FROM TH_BUF_EPOST_COATER_PLAN         
	  WHERE INSTANCE_ID = @V_MASTER_ID 
	  AND FP_PLAN_ID = @V_PLAN_ID
	
	  --LOG 생성
      SET @v_table_name = 'TH_BUF_EPOST_COATER_PLAN'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
    
	  DELETE FROM FP_ELECTRODE_POST_PLAN_H         
	  WHERE INSTANCE_ID = @V_MASTER_ID 
	  AND FP_PLAN_ID = @V_PLAN_ID
	
	  --LOG 생성
      SET @v_table_name = 'FP_ELECTRODE_POST_PLAN_H'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
    
      
      DELETE FROM FP_DAILY_PRODUCTION_PLAN_R         
	  WHERE INSTANCE_ID = @V_MASTER_ID 
	  AND FP_PLAN_ID = @V_PLAN_ID
	
	  --LOG 생성
      SET @v_table_name = 'FP_DAILY_PRODUCTION_PLAN_R'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
      
    
    END

	BEGIN  
	--------------------------------------------------
	-- 1-1. 노칭 계획 생성 
	--------------------------------------------------
    SET @v_table_name = 'TH_BUF_EPOST_NOTCHING_PLAN'
	SET @v_operation_01 = 'A5000'


		---- last Notching Releae Plan + GI offset ---- 
		INSERT INTO  TH_BUF_EPOST_NOTCHING_PLAN (
			INSTANCE_ID   ,	
			FP_PLAN_ID ,
			CELL_INSTANCE_ID ,
			CELL_INSTANCE_DATE    ,	
			CELL_RELEASE_PLAN_ID  , 			
			CELL_AMEND_PLAN_ID    ,
			CELL_COMPANY_ID , 
			CELL_DIVISION_ID   ,
			CELL_SITE_ID , 
			CELL_PLANT_ID , 
			CELL_FACTORY_ID    ,
			PLAN_GROUP_ID  ,
			WORK_ORDER_ID , 
			NP_ITEM_ID    ,
			LINE_ID   ,
			OPERATION_ID ,
			ELECTRODE_TYPE,
			PLAN_DATE   ,
			PLAN_QTY    ,
			PLAN_IN_QTY  ,
			PRODUCTION_TYPE ,
			MARKET  ,
			CUM_PLAN_QTY ,
			ACTUAL_GOOD_QTY ,
			GAP    ,
			GI_OFFSET_QTY    ,
			REMIAN_QTY    ,	
			INSERT_ID , 
			INSERT_TIME
		) 
		SELECT  @V_MASTER_ID AS INSTANCE_ID ,  @V_PLAN_ID AS FP_PLAN_ID 
			  , A.INSTANCE_ID AS CELL_INSTANCE_ID , A.INSTANCE_DATE, A.RELEASE_PLAN_ID , A.AMEND_PLAN_ID , A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  , A.FACTORY_ID , A.PLAN_GROUP_ID , A.WORK_ORDER_ID , A.NP_ITEM_ID
			  , A.LINE_ID , A.OPERATION_ID , A.ELECTRODE_TYPE , A.PLAN_DATE , A.PLAN_QTY , A.PLAN_IN_QTY , A.PRODUCTION_TYPE , A.MARKET , A.CUM_PLAN_QTY
			  , B.ACTUAL_GOOD_QTY , A.CUM_PLAN_QTY-B.ACTUAL_GOOD_QTY AS GAP 
			  , CASE WHEN (A.CUM_PLAN_QTY-B.ACTUAL_GOOD_QTY) <= 0         THEN PLAN_QTY 
					 WHEN A.PLAN_QTY > (A.CUM_PLAN_QTY-B.ACTUAL_GOOD_QTY) THEN A.PLAN_QTY - (A.CUM_PLAN_QTY-B.ACTUAL_GOOD_QTY) 
					 ELSE 0  
				END  GI_OFFSET_QTY 
			  , CASE WHEN (A.CUM_PLAN_QTY-B.ACTUAL_GOOD_QTY) <= 0         THEN 0
					 WHEN A.PLAN_QTY > (A.CUM_PLAN_QTY-B.ACTUAL_GOOD_QTY) THEN (A.CUM_PLAN_QTY-B.ACTUAL_GOOD_QTY)
					 ELSE A.PLAN_QTY 
				END  REMAIN_QTY	  
			  , @v_proc_name AS INSERT_ID
			  , GETDATE()    AS INSERT_TIME
		FROM   (--== A 최종 릴리즈 조립계획 ==-- 
				SELECT  B.COMPANY_ID, B.SITE_ID, B.PLANT_ID, A.INSTANCE_ID , A.INSTANCE_DATE, A.RELEASE_PLAN_ID , A.AMEND_PLAN_ID, A.DIVISION_ID, A.FACTORY_ID , A.PLAN_GROUP_ID , A.WORK_ORDER_ID
					  , A.ITEM_ID AS NP_ITEM_ID, A.LINE_ID 
					  , A.OPERATION_ID , A.ELECTRODE_TYPE , A.MARKET , A.PRODUCTION_TYPE
					  , A.PLAN_DATE  
					  , A.PLAN_IN_QTY  , A.PLAN_QTY  		  
					  , SUM(PLAN_QTY) OVER (PARTITION BY A.INSTANCE_ID , A.INSTANCE_DATE, A.RELEASE_PLAN_ID , A.AMEND_PLAN_ID, A.DIVISION_ID, A.FACTORY_ID ,  A.ITEM_ID  ORDER BY A.PLAN_DATE, PLAN_IN_QTY ) AS CUM_PLAN_QTY  --+ PLAN_QTY누적합
				FROM    FP_RELEASE_FULL_PLAN_H A 
					,	( --== 마지막 릴리즈 버전 검색 ==-- 
						SELECT  A.INSTANCE_ID , A.RELEASE_PLAN_ID  , A.AMEND_PLAN_ID  , A.FACTORY_ID  ,A.PLAN_GROUP_ID  ,A.INSTANCE_DATE , B.COMPANY_ID , B.DIVISION_ID , B.SITE_ID , B.PLANT_ID 
						FROM    ( 
								SELECT  A.INSTANCE_ID   , A.RELEASE_PLAN_ID  , A.AMEND_PLAN_ID ,  A.FACTORY_ID  ,A.PLAN_GROUP_ID  ,A.INSTANCE_DATE
									 ,  DENSE_RANK() OVER(PARTITION BY INSTANCE_ID, FACTORY_ID ORDER BY INSTANCE_DATE DESC, RELEASE_PLAN_ID ASC ) AS RNK   
								FROM    FP_RELEASE_PLAN_INFO_H A 
								WHERE  1=1  
								AND  EXISTS ( SELECT 1
												FROM  SCM_SYS_LOOKUP_VALUE  X
												WHERE X.ACTIVE_FLAG = 'Y'   
												AND  X.LOOKUP_TYPE_CODE = 'ELEC_POST_FACTORY_MAP'
												AND  X.SEGMENT1 = @V_MASTER_ID 
												AND  X.SEGMENT3 = A.INSTANCE_ID ) 
								) A
							,   SCM_FACTORY_M B
						WHERE A.RNK = 1
						AND   A.FACTORY_ID    =   B.FACTORY_ID 
						) B
				WHERE 1=1
				AND  A.INSTANCE_ID      = B.INSTANCE_ID
				AND  A.RELEASE_PLAN_ID  = B.RELEASE_PLAN_ID
				AND  A.AMEND_PLAN_ID    = B.AMEND_PLAN_ID
				AND  A.FACTORY_ID       = B.FACTORY_ID 
				AND  A.INSTANCE_DATE    = B.INSTANCE_DATE
				AND  A.OPERATION_ID     = @v_operation_01
				) A
		LEFT OUTER JOIN	( --== B 생산실적: RELEASE DATE이후 동/아이템별 수량합 ==--
				SELECT  B.INSTANCE_ID,  A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID , A.ITEM_ID , A.OPERATION_ID , SUM( A.ACTUAL_GOOD_QTY ) AS  ACTUAL_GOOD_QTY   
				FROM    SCM_DAILY_PRODUCT_RESULT_H A  
					,   ( ---== INSTANCE별 조건 검색 ==--- 
						SELECT  A.INSTANCE_ID, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, P.PLANT_NAME, B.FACTORY_ID, B.FACTORY_NAME, B.SHOP_GROUP_ID, A.INSTANCE_TYPE , C.INSTANCE_DATE 
						FROM	FP_INSTANCE_FACTORY_M A   -- INSTANCE 별 FACTORY ID
							,	SCM_FACTORY_M         B    -- FACTORY 별 SITE ID
							,   SCM_PLANT_M           P
							,   ( ---= 마지막 릴리즈 버전 검색 =---  
								SELECT  A.INSTANCE_ID , A.RELEASE_PLAN_ID  , A.AMEND_PLAN_ID  , A.FACTORY_ID  ,A.PLAN_GROUP_ID  ,A.INSTANCE_DATE
								FROM    ( 
										SELECT  A.INSTANCE_ID   , A.RELEASE_PLAN_ID  , A.AMEND_PLAN_ID  , A.FACTORY_ID  ,A.PLAN_GROUP_ID  ,A.INSTANCE_DATE
											 ,  DENSE_RANK() OVER(PARTITION BY INSTANCE_ID, FACTORY_ID ORDER BY INSTANCE_DATE DESC, RELEASE_PLAN_ID ASC ) AS RNK   
										FROM    FP_RELEASE_PLAN_INFO_H A 
										WHERE  1=1  
										AND  EXISTS ( SELECT 1
														FROM  SCM_SYS_LOOKUP_VALUE  X
														WHERE X.ACTIVE_FLAG = 'Y'   
														AND  X.LOOKUP_TYPE_CODE = 'ELEC_POST_FACTORY_MAP'
														AND  X.SEGMENT1 = @V_MASTER_ID 
														AND  X.SEGMENT3 = A.INSTANCE_ID )
										) A
								WHERE RNK = 1
								) C
						WHERE   1=1
						AND     A.FACTORY_ID = B.FACTORY_ID
						AND     A.ACTIVE_FLAG = 'Y'
						AND     B.ACTIVE_FLAG = 'Y' 
						AND     B.COMPANY_ID = P.COMPANY_ID
						AND     B.DIVISION_ID = P.DIVISION_ID
						AND     B.SITE_ID = P.SITE_ID
						AND     B.PLANT_ID = P.PLANT_ID	
						AND     A.INSTANCE_ID = C.INSTANCE_ID
						AND     B.FACTORY_ID  = C.FACTORY_ID
						AND  EXISTS (	SELECT 1
										FROM  SCM_SYS_LOOKUP_VALUE  X
										WHERE X.ACTIVE_FLAG = 'Y'   
										AND  X.LOOKUP_TYPE_CODE = 'ELEC_POST_FACTORY_MAP'
										AND  X.SEGMENT1 = @V_MASTER_ID 
										AND  X.SEGMENT3 = A.INSTANCE_ID ) 
						) B
				WHERE  1=1
				AND  A.COMPANY_ID   =  B.COMPANY_ID
				AND  A.DIVISION_ID  =  B.DIVISION_ID
				AND  A.SITE_ID      =  B.SITE_ID
				AND  A.FACTORY_ID   =  B.FACTORY_ID
				AND  A.PLAN_DATE    >= B.INSTANCE_DATE
				AND  A.OPERATION_ID =  @v_operation_01
				GROUP BY B.INSTANCE_ID,  A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID , A.ITEM_ID , A.OPERATION_ID 
				) B
				ON  A.INSTANCE_ID  =  B.INSTANCE_ID
				AND  A.DIVISION_ID =  B.DIVISION_ID
				AND  A.FACTORY_ID  =  B.FACTORY_ID 
				AND  A.NP_ITEM_ID     =  B.ITEM_ID
				AND  A.OPERATION_ID = B.OPERATION_ID
		WHERE 1=1
		; 
		
	    --LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	  SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr


		/** UPDAE : YIELD & INPUT QTY **/
		UPDATE  A
		SET     A.YIELD = ISNULL(B.YIELD , C.YIELD ) 
			  , A.NP_IN_QTY =  A.REMIAN_QTY / ISNULL(B.YIELD , C.YIELD )
		FROM    TH_BUF_EPOST_NOTCHING_PLAN  A 
		LEFT OUTER JOIN SCM_YIELD_EXCEPT_M B
				ON	B.ACTIVE_FLAG = 'Y' 
				AND A.CELL_COMPANY_ID  =  B.COMPANY_ID 
				AND A.CELL_DIVISION_ID =  B.DIVISION_ID
				AND A.CELL_SITE_ID     =  B.SITE_ID
				AND A.CELL_PLANT_ID    =  B.PLANT_ID
				AND A.OPERATION_ID = B.OPERATION_ID
				AND A.LINE_ID      = B.LINE_ID
				AND A.NP_ITEM_ID   = B.ITEM_ID
				AND A.PLAN_DATE   >= B.START_TIME
				AND A.PLAN_DATE  <= B.END_TIME 
		LEFT OUTER JOIN SCM_YIELD_M C
				ON	1=1
				AND A.CELL_COMPANY_ID  =  C.COMPANY_ID 
				AND A.CELL_DIVISION_ID =  C.DIVISION_ID
				AND A.CELL_SITE_ID     =  C.SITE_ID
				AND A.CELL_PLANT_ID    =  C.PLANT_ID
				AND A.OPERATION_ID = C.OPERATION_ID
				AND A.LINE_ID      = C.LINE_ID
				AND A.NP_ITEM_ID   = C.ITEM_ID
				AND CONVERT(NVARCHAR , FORMAT( A.PLAN_DATE, 'yyyyMM')) = C.MONTH 
		LEFT OUTER JOIN (
					  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, 
							 A.KEY_DATE , A.EFF_END_DATE
					  FROM   SCM_BOM_M         A,
							 SCM_ITEM_M        B,
							 SCM_ITEM_CLASS_M  C
					  WHERE  1=1
					  AND    A.ACTIVE_FLAG    = 'Y'
					  AND    A.COMPANY_ID     = B.COMPANY_ID
					  AND    A.DIVISION_ID    = B.DIVISION_ID
					  AND    A.SITE_ID        = B.SITE_ID
					  AND    A.CHILD_ITEM_ID  = B.ITEM_ID  
					  AND    B.ACTIVE_FLAG    = 'Y'
					  AND    B.ITEM_CLASS     = C.CLASS_ID  
					  AND    C.USE_FLAG       = 'Y'                             
					  GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.KEY_DATE , A.EFF_END_DATE
				) D
				ON  A.CELL_COMPANY_ID = D.COMPANY_ID
				AND A.CELL_DIVISION_ID = D.DIVISION_ID
				AND A.CELL_SITE_ID     = D.SITE_ID
				AND A.CELL_PLANT_ID    = D.PLANT_ID
				AND A.NP_ITEM_ID  = D.PARENT_ITEM_ID
				AND A.CELL_INSTANCE_DATE < CONVERT(CHAR(8),D.EFF_END_DATE,112) 
		WHERE 	1=1
		AND 	A.INSTANCE_ID = @V_MASTER_ID
		AND 	A.FP_PLAN_ID = @V_PLAN_ID
		; 
	
		    --LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr
		;

		/** UPDATE NP_PLAN_DATE : 실적차감한 과거일자를 오늘로 변경 **/
	
		UPDATE  A 
		SET      A.NP_PLAN_DATE = CASE WHEN  A.PLAN_DATE < @KEY_DATE  THEN @KEY_DATE ELSE A.PLAN_DATE END 
		FROM    TH_BUF_EPOST_NOTCHING_PLAN A
		WHERE 	1=1
		AND 	A.INSTANCE_ID = @V_MASTER_ID
		AND 	A.FP_PLAN_ID = @V_PLAN_ID 
		; 

			    --LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr
	    
	END 

	BEGIN 
	--=========================================================
	-- 1-2. 노칭계획 기반 자재(Pancake) 소요량 산출  
	--=========================================================
	
		SET @v_table_name = 'TH_BUF_EPOST_NOTCHING_MTR_PLAN'


		INSERT INTO TH_BUF_EPOST_NOTCHING_MTR_PLAN  (
			  INSTANCE_ID 
			, FP_PLAN_ID
			, CELL_INSTANCE_ID
			, CELL_INSTANCE_DATE 
			, CELL_RELEASE_PLAN_ID 
			, CELL_AMEND_PLAN_ID 
			, CELL_COMPANY_ID	
			, CELL_DIVISION_ID 
			, CELL_SITE_ID	
			, CELL_PLANT_ID
			, CELL_FACTORY_ID
			, PLAN_GROUP_ID
			, PRODUCTION_TYPE
			, MARKET
			, LINE_ID
			, OPERATION_ID
			, ELECTRODE_TYPE
			, NP_ITEM_ID
			, NP_PLAN_DATE
			, NP_IN_QTY
			, ITEM_ID
			, ITEM_BOM_QTY
			, ITEM_REQ_QTY
			, ITEM_UOM
			, FLOW_ID
			, LAST_FLOW_ID
			, ITEM_PLAN_DATE
			, INSERT_ID
			, INSERT_TIME 
		)
		SELECT  @V_MASTER_ID AS INSTANCE_ID , @V_PLAN_ID AS FP_PLAN_ID
		      , A.CELL_INSTANCE_ID , A.CELL_INSTANCE_DATE , A.CELL_RELEASE_PLAN_ID , A.CELL_AMEND_PLAN_ID 
			  , A.CELL_COMPANY_ID	, A.CELL_DIVISION_ID , A.CELL_SITE_ID	, A.CELL_PLANT_ID, A.CELL_FACTORY_ID, A.PLAN_GROUP_ID
			  , A.PRODUCTION_TYPE, A.MARKET, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, A.NP_ITEM_ID, A.NP_PLAN_DATE, A.NP_IN_QTY
			  , B.CHILD_ITEM_ID AS ITEM_ID
			  , B.ITEM_BOM_QTY
			  , A.NP_IN_QTY * B.ITEM_BOM_QTY AS ITEM_REQ_QTY
			  , B.ITEM_UOM
			  , B.FLOW_ID
			  , B.LAST_FLOW_ID 
			  , CASE WHEN DATEADD (DAY, -1, A.NP_PLAN_DATE) < @KEY_DATE  THEN @KEY_DATE ELSE DATEADD (DAY, -1, A.NP_PLAN_DATE) END  ITEM_PLAN_DATE 
			  , @v_proc_name AS INSERT_ID
			  , GETDATE() AS INSERT_TIME
		FROM    (
				SELECT  A.CELL_INSTANCE_ID , A.CELL_INSTANCE_DATE , A.CELL_RELEASE_PLAN_ID , A.CELL_AMEND_PLAN_ID 
					  , A.CELL_COMPANY_ID	, A.CELL_DIVISION_ID , A.CELL_SITE_ID	, A.CELL_PLANT_ID, A.CELL_FACTORY_ID, A.PLAN_GROUP_ID
					  , A.PRODUCTION_TYPE, A.MARKET, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, A.NP_ITEM_ID, A.NP_PLAN_DATE, SUM(A.NP_IN_QTY) AS NP_IN_QTY 
				FROM    TH_BUF_EPOST_NOTCHING_PLAN A
				WHERE 	1=1
				AND 	A.INSTANCE_ID = @V_MASTER_ID
				AND 	A.FP_PLAN_ID = @V_PLAN_ID
				GROUP BY  A.CELL_INSTANCE_ID , A.CELL_INSTANCE_DATE , A.CELL_RELEASE_PLAN_ID , A.CELL_AMEND_PLAN_ID 
					  , A.CELL_COMPANY_ID	, A.CELL_DIVISION_ID , A.CELL_SITE_ID	, A.CELL_PLANT_ID, A.CELL_FACTORY_ID, A.PLAN_GROUP_ID
					  , A.PRODUCTION_TYPE, A.MARKET, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, A.NP_ITEM_ID, A.NP_PLAN_DATE
			  ) A 
		LEFT OUTER JOIN	(
				SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.PARENT_QTY , A.CHILD_QTY ,  A.CHILD_QTY/A.PARENT_QTY AS ITEM_BOM_QTY
					, A.CHILD_ITEM_ID, B.ITEM_TYPE , B.ITEM_UOM , B.FLOW_ID , A.EFF_START_DATE , A.EFF_END_DATE 
					, RIGHT (B.FLOW_ID, 5) AS LAST_FLOW_ID
				FROM   SCM_BOM_M         A,
						SCM_ITEM_M        B,
						SCM_ITEM_CLASS_M  C
				WHERE  1=1
				AND    A.ACTIVE_FLAG    = 'Y'
				AND    A.COMPANY_ID     = B.COMPANY_ID
				AND    A.DIVISION_ID    = B.DIVISION_ID
				AND    A.SITE_ID        = B.SITE_ID
				AND    A.CHILD_ITEM_ID  = B.ITEM_ID  
				AND    B.ACTIVE_FLAG    = 'Y'
				AND    B.ITEM_CLASS     = C.CLASS_ID  
				AND    C.USE_FLAG       = 'Y'                    
				AND    A.EFF_END_DATE   > @KEY_DATE	
				AND    ISNULL(A.ALT_PRIORITY, 1) = 1 
				) B
				ON  1=1
				AND A.CELL_COMPANY_ID = B.COMPANY_ID 
				AND A.CELL_DIVISION_ID = B.DIVISION_ID
				AND A.CELL_SITE_ID    =  B.SITE_ID
				AND A.CELL_PLANT_ID   =  B.PLANT_ID
				AND A.NP_ITEM_ID = B.PARENT_ITEM_ID
				AND ISNULL(B.CHILD_QTY,0) > 0
				AND CONVERT(CHAR(8) , A.NP_PLAN_DATE, 112) >= CONVERT(CHAR(8), EFF_START_DATE,112)
				AND CONVERT(CHAR(8) , A.NP_PLAN_DATE, 112) < CONVERT(CHAR(8), EFF_END_DATE,112)
				; 
			
		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    
	END   -- 2 END 



	BEGIN  -- 3 
		--=========================================================
		-- 2-1. 전극 소요량 산출 사전작업 
		-- (1) 조립 - 전극 FACTORY MAPPING
		--=========================================================
		
		SET @v_table_name = 'TH_BUF_EPOST_FACTORY_MAP'

		INSERT INTO  TH_BUF_EPOST_FACTORY_MAP (
		    INSTANCE_ID , 
			FP_PLAN_ID , 
			EPOST_INSTANCE_ID ,				
			EPOST_COMPANY_ID  ,
			EPOST_DIVISION_ID ,
			EPOST_SITE_ID     ,
			EPOST_PLANT_ID    ,
			EPOST_FACTORY_ID  ,		
			CELL_INSTANCE_ID  ,				
			CELL_COMPANY_ID   ,	
			CELL_DIVISION_ID  ,		
			CELL_SITE_ID      ,	
			CELL_PLANT_ID     ,
			CELL_FACTORY_ID   ,
			INSERT_ID         ,				
			INSERT_TIME       
		) 
		SELECT  @V_MASTER_ID AS INSTANCE_ID , @V_PLAN_ID AS FP_PLAN_ID
		      , A.EPOST_INSTANCE, B.EPOST_COMPANY , B.EPOST_DIVISION, B.EPOST_SITE, B.EPOST_PLANT, A.EPOST_FACTORY
			  , A.CELL_INSTANCE , B.CELL_COMPANY, B.CELL_DIVISION, B.CELL_SITE, B.CELL_PLANT , A.CELL_FACTORY  
			  , @v_proc_name AS INSERT_ID
			  , GETDATE() AS INSERT_TIME
		FROM   (
				SELECT  V2.SEGMENT1 AS EPOST_INSTANCE , V2.SEGMENT2 AS EPOST_FACTORY , F1.ACTIVE_FLAG , V2.SEGMENT3 AS CELL_INSTANCE , V2.SEGMENT4 AS CELL_FACTORY 
				FROM    SCM_SYS_LOOKUP_VALUE  V2 
					,   FP_INSTANCE_FACTORY_M  F1
					,   FP_INSTANCE_FACTORY_M  F2 
				WHERE V2.LOOKUP_TYPE_CODE = 'ELEC_POST_FACTORY_MAP' 
				AND   V2.ACTIVE_FLAG = 'Y' 
				AND   F1.ACTIVE_FLAG = 'Y' 
				AND   F1.INSTANCE_ID = V2.SEGMENT1
				AND   F1.FACTORY_ID  = V2.SEGMENT2
				AND   F2.ACTIVE_FLAG = 'Y' 
				AND   F2.INSTANCE_ID = V2.SEGMENT3
				AND   F2.FACTORY_ID  = V2.SEGMENT4	
				AND   V2.SEGMENT1    = @V_MASTER_ID			
				) A
			,   (
				SELECT  V1.SEGMENT2 AS CELL_INSTANCE, V1.SEGMENT3 AS EPOST_INSTANCE  
						, V3.SEGMENT2 AS CELL_COMPANY , V3.SEGMENT3 AS CELL_DIVISION , V3.SEGMENT4 AS CELL_SITE , V3.SEGMENT5 AS CELL_PLANT 
						, V4.SEGMENT2 AS EPOST_COMPANY , V4.SEGMENT3 AS EPOST_DIVISION , V4.SEGMENT4 AS EPOST_SITE , V4.SEGMENT5 AS EPOST_PLANT 
				FROM    SCM_SYS_LOOKUP_VALUE  V1 
					,   SCM_SYS_LOOKUP_VALUE  V3 
					,   SCM_SYS_LOOKUP_VALUE  V4
				WHERE  V1.LOOKUP_TYPE_CODE = 'ELEC_ASSY_INSTANCE_MAP' 
				AND  V1.ACTIVE_FLAG = 'Y' 
				AND  V3.ACTIVE_FLAG = 'Y'
				AND  V3.LOOKUP_TYPE_CODE = 'INSTANCE_INFO'
				AND  V3.SEGMENT1    =  V1.SEGMENT2 
				AND  V4.ACTIVE_FLAG = 'Y'
				AND  V4.LOOKUP_TYPE_CODE = 'INSTANCE_INFO'
				AND  V4.SEGMENT1    =  V1.SEGMENT3 		
				) B
		WHERE  A.EPOST_INSTANCE = B.EPOST_INSTANCE 
		AND    A.CELL_INSTANCE  = B.CELL_INSTANCE 
		; 
	
			--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr

	END  -- 3 END 

	BEGIN  --4
		--=========================================================
		-- 2-1. 전극 소요량 산출 사전작업 
		-- (2) 전극 FACTORY별 재고정보 생성.
		--=========================================================

		---- 정상상태 재고정보 ---- 
		SET      @v_table_name = 'TH_BUF_EPOST_STOCK'
		
		INSERT INTO TH_BUF_EPOST_STOCK  (
			INSTANCE_ID , 
			FP_PLAN_ID , 
			CUTOFF_DATE ,
			COMPANY_ID ,
			DIVISION_ID ,
			SITE_ID ,
			PLANT_ID ,
			FACTORY_ID ,		
			FP_APPLY_OPERATION_ID ,
			FP_APPLY_ITEM_ID ,
			FP_APPLY_WIPQTY ,
			STOCK_QTY ,
			INSERT_ID  ,			
			INSERT_TIME    
		) 
		SELECT    @V_MASTER_ID AS INSTANCE_ID 
				, @V_PLAN_ID AS FP_PLAN_ID
				, A.CUTOFF_DATE
				, A.COMPANY_ID 
				, A.DIVISION_ID 
				, A.SITE_ID 
				, A.PLANT_ID
				, A.FACTORY_ID 
				, A.FP_APPLY_OPERATION_ID 
				, A.FP_APPLY_ITEM_ID
				, SUM(A.FP_APPLY_WIPQTY) AS FP_APPLY_WIPQTY
				, SUM(A.FP_APPLY_WIPQTY) AS STOCK_QTY
				, @v_proc_name AS INSERT_ID
				, GETDATE()    AS INSERT_TIME
		FROM    (--== STOCK : 전극 FACTORY, PANCAKE ITEM 집계 ==--- 		
				SELECT  A.CUTOFF_DATE , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID, A.FACTORY_ID , FP_APPLY_OPERATION_ID , FP_APPLY_ITEM_ID
					  , SUM( fp_apply_wipqty ) AS FP_APPLY_WIPQTY 
				FROM   SCM_STOCK_H_V A
					,   (
						SELECT  DISTINCT B.EPOST_COMPANY_ID , B.EPOST_DIVISION_ID, B.EPOST_SITE_ID, B.EPOST_PLANT_ID, B.EPOST_FACTORY_ID
						FROM    (
								SELECT  DISTINCT A.CELL_INSTANCE_ID, A.CELL_COMPANY_ID, A.CELL_DIVISION_ID, A.CELL_SITE_ID, A.CELL_PLANT_ID, A.CELL_FACTORY_ID   
								FROM  	TH_BUF_EPOST_NOTCHING_MTR_PLAN A
								WHERE 	INSTANCE_ID = @V_MASTER_ID
								AND 	FP_PLAN_ID 	= @V_PLAN_ID
								)  A 
							,   TH_BUF_EPOST_FACTORY_MAP B 
						WHERE  B.INSTANCE_ID      =  @V_MASTER_ID
						AND    B.FP_PLAN_ID		  =  @V_PLAN_ID
						AND    A.CELL_INSTANCE_ID =  B.CELL_INSTANCE_ID
						AND    A.CELL_COMPANY_ID  =  B.CELL_COMPANY_ID
						AND    A.CELL_DIVISION_ID =  B.CELL_DIVISION_ID
						AND    A.CELL_SITE_ID     =  B.CELL_SITE_ID
						AND    A.CELL_PLANT_ID    =  B.CELL_PLANT_ID
						AND    A.CELL_FACTORY_ID  =  B.CELL_FACTORY_ID     
						) B 
				WHERE  A.CUTOFF_DATE = @CUTOFF_DATE  
				AND    A.STOCK_TYPE  = 'WIP'
				AND    A.FP_APPLY_WIPQTY > 0
				AND    A.WIPHOLD_YN = 'N' 
				AND    A.COMPANY_ID = B.EPOST_COMPANY_ID
				AND    A.DIVISION_ID =  B.EPOST_DIVISION_ID
				AND    A.SITE_ID     =  B.EPOST_SITE_ID
				AND    A.PLANT_ID    =  B.EPOST_PLANT_ID
				AND    A.FACTORY_ID  =  B.EPOST_FACTORY_ID 
				AND    EXISTS ( SELECT  1
								FROM    SCM_ITEM_M B , SCM_ITEM_CLASS_M  C 
								WHERE  1=1
								AND    B.ACTIVE_FLAG    = 'Y'
								AND    B.ITEM_CLASS     = C.CLASS_ID  
								AND    C.USE_FLAG       = 'Y' 
								AND    C.LEVEL_2_CODE   = 'APC' 
								and    C.LEVEL_3_CODE  <> 'APCSR'
								AND    B.ITEM_ID       = A.FP_APPLY_ITEM_ID
								AND    A.SITE_ID       =  B.SITE_ID  )   --+ 20190826 ADD 
				GROUP BY A.CUTOFF_DATE , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID, A.FACTORY_ID , FP_APPLY_OPERATION_ID , FP_APPLY_ITEM_ID 				
				UNION ALL			
				--== STOCK: A5000번 & 전극 PANCAKE ITEM  ==-- 
				SELECT  A.CUTOFF_DATE, B.COMPANY_ID , B.DIVISION_ID , B.SITE_ID , B.PLANT_ID, B.EPOST_FACTORY  
				      , C.LAST_FLOW_ID AS FP_APPLY_OPERATION_ID 
				      , A.FP_APPLY_ITEM_ID       		       
					  , SUM(FP_APPLY_WIPQTY)   AS FP_APPLY_WIPQTY  
				FROM   SCM_STOCK_H_V A
						LEFT OUTER JOIN (SELECT SEGMENT1 AS EPOST_INSTANCE, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, SEGMENT2 AS EPOST_FACTORY, SEGMENT3 AS ASSY_INSTANCE, SEGMENT4 AS ASSY_FACTORY
										 FROM 	SCM_SYS_LOOKUP_VALUE A,
												SCM_FACTORY_M B
										 WHERE 	1=1
										 AND 	A.LOOKUP_TYPE_CODE = 'ELEC_POST_FACTORY_MAP'
										 AND 	A.ACTIVE_FLAG = 'Y'
										 AND 	A.SEGMENT1 = @V_MASTER_ID
										 AND 	A.SEGMENT2 = B.FACTORY_ID
										 AND 	B.ACTIVE_FLAG = 'Y'
										 ) B
						ON 	1=1
						AND	B.EPOST_INSTANCE = @V_MASTER_ID
						AND A.FACTORY_ID = B.ASSY_FACTORY
						LEFT OUTER JOIN (SELECT INSTANCE_ID AS EPOST_INSTANCE, CELL_INSTANCE_ID AS ASSY_INSTANCE, ITEM_ID, LAST_FLOW_ID
										 FROM 	TH_BUF_EPOST_NOTCHING_MTR_PLAN
										 WHERE 	1=1
										 AND 	INSTANCE_ID = @V_MASTER_ID
										 AND 	FP_PLAN_ID = @V_PLAN_ID
										 GROUP BY INSTANCE_ID, CELL_INSTANCE_ID, ITEM_ID, LAST_FLOW_ID) C
						ON 	1=1
						AND A.FP_APPLY_ITEM_ID = C.ITEM_ID
				WHERE  CUTOFF_DATE = @CUTOFF_DATE   ---@V_CUTOFF_DATE 
				AND    STOCK_TYPE  = 'WIP'
				AND    FP_APPLY_WIPQTY > 0
				AND    WIPHOLD_YN = 'N' 
				AND    EXISTS ( SELECT  1
								FROM    SCM_ITEM_M B , SCM_ITEM_CLASS_M  C 
								WHERE  1=1
								AND    B.ACTIVE_FLAG    = 'Y'
								AND    B.ITEM_CLASS     = C.CLASS_ID  
								AND    C.USE_FLAG       = 'Y' 
								AND    C.LEVEL_2_CODE   = 'APC' 
								and    C.LEVEL_3_CODE  <> 'APCSR'
								AND    B.ITEM_ID       = A.FP_APPLY_ITEM_ID ) 
				AND    EXISTS ( SELECT  1
								FROM    TH_BUF_EPOST_NOTCHING_MTR_PLAN Z 
								WHERE   Z.INSTANCE_ID =  @V_MASTER_ID
								AND     Z.FP_PLAN_ID  =  @V_PLAN_ID
								AND 	A.COMPANY_ID  =  Z.CELL_COMPANY_ID
								AND     A.DIVISION_ID =  Z.CELL_DIVISION_ID
								AND     A.SITE_ID     =  Z.CELL_SITE_ID
								AND     A.PLANT_ID    =  Z.CELL_PLANT_ID
								AND     A.FACTORY_ID  =  Z.CELL_FACTORY_ID 
								AND     A.OPERATION_ID = Z.OPERATION_ID 
								AND     A.ITEM_ID      = Z.ITEM_ID  ) 
				GROUP BY  A.CUTOFF_DATE, B.COMPANY_ID , B.DIVISION_ID , B.SITE_ID , B.PLANT_ID, B.EPOST_FACTORY,  A.FP_APPLY_ITEM_ID , C.LAST_FLOW_ID		
				) A
		WHERE  1=1		
		GROUP BY A.CUTOFF_DATE, A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID, A.FACTORY_ID , A.FP_APPLY_OPERATION_ID , A.FP_APPLY_ITEM_ID
		; 

	    --LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;

		--- ERP 재고수량 가져오기 부분 
		--- 최기주 수석님 추가 해주세요. 
		--- 타 SITE에서 받는 물량은 계획 수립에서 제외

		/*
		--- ERP 재고수량과 합산함. 
		UPDATE  A
		SET    A.STOCK_QTY = ISNULL(A.FP_APPLY_WIPQTY,0) + ISNULL(A.ERP_STOCK_QTY ,0)
		FROM  TH_BUF_EPOST_STOCK  A
		WHERE 	1=1
		AND 	A.INSTANCE_ID = @V_MASTER_ID
		AND 	A.FP_PLAN_ID = @V_PLAN_ID 
		; 
		*/


		----- HOLD 상태 재고정보 (20190829) -------

		SET      @v_table_name = 'TH_BUF_EPOST_STOCK_HOLD'
		
		INSERT INTO TH_BUF_EPOST_STOCK_HOLD  (
			INSTANCE_ID , 
			FP_PLAN_ID , 
			CUTOFF_DATE ,
			COMPANY_ID ,
			DIVISION_ID ,
			SITE_ID ,
			PLANT_ID ,
			FACTORY_ID ,		
			FP_APPLY_OPERATION_ID ,
			FP_APPLY_ITEM_ID ,
			FP_APPLY_WIPQTY ,
			STOCK_QTY ,
			INSERT_ID  ,			
			INSERT_TIME    
		) 
		SELECT    @V_MASTER_ID AS INSTANCE_ID 
				, @V_PLAN_ID AS FP_PLAN_ID
				, A.CUTOFF_DATE
				, A.COMPANY_ID 
				, A.DIVISION_ID 
				, A.SITE_ID 
				, A.PLANT_ID
				, A.FACTORY_ID 
				, A.FP_APPLY_OPERATION_ID 
				, A.FP_APPLY_ITEM_ID
				, SUM(A.FP_APPLY_WIPQTY) AS FP_APPLY_WIPQTY
				, SUM(A.FP_APPLY_WIPQTY) AS STOCK_QTY
				, @v_proc_name AS INSERT_ID
				, GETDATE()    AS INSERT_TIME
		FROM    (--== STOCK : 전극 FACTORY, PANCAKE ITEM 집계 ==--- 		
				SELECT  A.CUTOFF_DATE , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID, A.FACTORY_ID , FP_APPLY_OPERATION_ID , FP_APPLY_ITEM_ID
					  , SUM( fp_apply_wipqty ) AS FP_APPLY_WIPQTY 
				FROM   SCM_STOCK_H_V A
					,   (
						SELECT  DISTINCT B.EPOST_COMPANY_ID , B.EPOST_DIVISION_ID, B.EPOST_SITE_ID, B.EPOST_PLANT_ID, B.EPOST_FACTORY_ID
						FROM    (
								SELECT  DISTINCT A.CELL_INSTANCE_ID, A.CELL_COMPANY_ID, A.CELL_DIVISION_ID, A.CELL_SITE_ID, A.CELL_PLANT_ID, A.CELL_FACTORY_ID   
								FROM  	TH_BUF_EPOST_NOTCHING_MTR_PLAN A
								WHERE 	INSTANCE_ID = @V_MASTER_ID
								AND 	FP_PLAN_ID 	= @V_PLAN_ID
								)  A 
							,   TH_BUF_EPOST_FACTORY_MAP B 
						WHERE  B.INSTANCE_ID      =  @V_MASTER_ID
						AND    B.FP_PLAN_ID		  =  @V_PLAN_ID
						AND    A.CELL_INSTANCE_ID =  B.CELL_INSTANCE_ID
						AND    A.CELL_COMPANY_ID  =  B.CELL_COMPANY_ID
						AND    A.CELL_DIVISION_ID =  B.CELL_DIVISION_ID
						AND    A.CELL_SITE_ID     =  B.CELL_SITE_ID
						AND    A.CELL_PLANT_ID    =  B.CELL_PLANT_ID
						AND    A.CELL_FACTORY_ID  =  B.CELL_FACTORY_ID     
						) B 
				WHERE  A.CUTOFF_DATE = @CUTOFF_DATE  
				AND    A.STOCK_TYPE  = 'WIP'
				AND    A.FP_APPLY_WIPQTY > 0
				AND    A.WIPHOLD_YN = 'Y'    --+ HOLD STOCK 
				AND    A.COMPANY_ID = B.EPOST_COMPANY_ID
				AND    A.DIVISION_ID =  B.EPOST_DIVISION_ID
				AND    A.SITE_ID     =  B.EPOST_SITE_ID
				AND    A.PLANT_ID    =  B.EPOST_PLANT_ID
				AND    A.FACTORY_ID  =  B.EPOST_FACTORY_ID 
				AND    EXISTS ( SELECT  1
								FROM    SCM_ITEM_M B , SCM_ITEM_CLASS_M  C 
								WHERE  1=1
								AND    B.ACTIVE_FLAG    = 'Y'
								AND    B.ITEM_CLASS     = C.CLASS_ID  
								AND    C.USE_FLAG       = 'Y' 
								AND    C.LEVEL_2_CODE   = 'APC' 
								and    C.LEVEL_3_CODE  <> 'APCSR'
								AND    B.ITEM_ID       = A.FP_APPLY_ITEM_ID
								AND    A.SITE_ID       =  B.SITE_ID  )   --+ 20190826 ADD 
				GROUP BY A.CUTOFF_DATE , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID, A.FACTORY_ID , FP_APPLY_OPERATION_ID , FP_APPLY_ITEM_ID 				
				UNION ALL			
				--== STOCK: A5000번 & 전극 PANCAKE ITEM  ==-- 
				SELECT  A.CUTOFF_DATE, B.COMPANY_ID , B.DIVISION_ID , B.SITE_ID , B.PLANT_ID, B.EPOST_FACTORY  
				      , C.LAST_FLOW_ID AS FP_APPLY_OPERATION_ID 
				      , A.FP_APPLY_ITEM_ID       		       
					  , SUM(FP_APPLY_WIPQTY)   AS FP_APPLY_WIPQTY  
				FROM   SCM_STOCK_H_V A
						LEFT OUTER JOIN (SELECT SEGMENT1 AS EPOST_INSTANCE, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, SEGMENT2 AS EPOST_FACTORY, SEGMENT3 AS ASSY_INSTANCE, SEGMENT4 AS ASSY_FACTORY
										 FROM 	SCM_SYS_LOOKUP_VALUE A,
												SCM_FACTORY_M B
										 WHERE 	1=1
										 AND 	A.LOOKUP_TYPE_CODE = 'ELEC_POST_FACTORY_MAP'
										 AND 	A.ACTIVE_FLAG = 'Y'
										 AND 	A.SEGMENT1 = @V_MASTER_ID
										 AND 	A.SEGMENT2 = B.FACTORY_ID
										 AND 	B.ACTIVE_FLAG = 'Y'
										 ) B
						ON 	1=1
						AND	B.EPOST_INSTANCE = @V_MASTER_ID
						AND A.FACTORY_ID = B.ASSY_FACTORY
						LEFT OUTER JOIN (SELECT INSTANCE_ID AS EPOST_INSTANCE, CELL_INSTANCE_ID AS ASSY_INSTANCE, ITEM_ID, LAST_FLOW_ID
										 FROM 	TH_BUF_EPOST_NOTCHING_MTR_PLAN
										 WHERE 	1=1
										 AND 	INSTANCE_ID = @V_MASTER_ID
										 AND 	FP_PLAN_ID = @V_PLAN_ID
										 GROUP BY INSTANCE_ID, CELL_INSTANCE_ID, ITEM_ID, LAST_FLOW_ID) C
						ON 	1=1
						AND A.FP_APPLY_ITEM_ID = C.ITEM_ID
				WHERE  CUTOFF_DATE = @CUTOFF_DATE   
				AND    STOCK_TYPE  = 'WIP'
				AND    FP_APPLY_WIPQTY > 0
				AND    WIPHOLD_YN = 'Y'     --+ HOLD STOCK  
				AND    EXISTS ( SELECT  1
								FROM    SCM_ITEM_M B , SCM_ITEM_CLASS_M  C 
								WHERE  1=1
								AND    B.ACTIVE_FLAG    = 'Y'
								AND    B.ITEM_CLASS     = C.CLASS_ID  
								AND    C.USE_FLAG       = 'Y' 
								AND    C.LEVEL_2_CODE   = 'APC' 
								and    C.LEVEL_3_CODE  <> 'APCSR'
								AND    B.ITEM_ID       = A.FP_APPLY_ITEM_ID ) 
				AND    EXISTS ( SELECT  1
								FROM    TH_BUF_EPOST_NOTCHING_MTR_PLAN Z 
								WHERE   Z.INSTANCE_ID =  @V_MASTER_ID
								AND     Z.FP_PLAN_ID  =  @V_PLAN_ID
								AND 	A.COMPANY_ID  =  Z.CELL_COMPANY_ID
								AND     A.DIVISION_ID =  Z.CELL_DIVISION_ID
								AND     A.SITE_ID     =  Z.CELL_SITE_ID
								AND     A.PLANT_ID    =  Z.CELL_PLANT_ID
								AND     A.FACTORY_ID  =  Z.CELL_FACTORY_ID 
								AND     A.OPERATION_ID = Z.OPERATION_ID 
								AND     A.ITEM_ID      = Z.ITEM_ID  ) 
				GROUP BY  A.CUTOFF_DATE, B.COMPANY_ID , B.DIVISION_ID , B.SITE_ID , B.PLANT_ID, B.EPOST_FACTORY,  A.FP_APPLY_ITEM_ID , C.LAST_FLOW_ID		
				) A
		WHERE  1=1		
		GROUP BY A.CUTOFF_DATE, A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID, A.FACTORY_ID , A.FP_APPLY_OPERATION_ID , A.FP_APPLY_ITEM_ID
		; 

	    --LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;
		
		END    --4 END 


		BEGIN  --5
		--=========================================================
		-- 2-2. 전극 생산 소요량 산출 
		-- 조립 FACTORY의 A5000재고 차감 후 잔량산출 
		--=========================================================
		
		SET      @v_table_name = 'TH_BUF_EPOST_NET_DEMAND'

		INSERT INTO  TH_BUF_EPOST_NET_DEMAND  (
		    INSTANCE_ID , 
		    FP_PLAN_ID , 
			CELL_INSTANCE_ID    ,				
			CELL_INSTANCE_DATE  ,
			CELL_RELEASE_PLAN_ID,
			CELL_AMEND_PLAN_ID  ,
			CELL_COMPANY_ID     ,
			CELL_DIVISION_ID    ,
			CELL_SITE_ID        ,
			CELL_PLANT_ID       ,
			CELL_FACTORY_ID     ,
			OPERATION_ID   ,
			ITEM_ID        ,
			ITEM_UOM       ,
			FLOW_ID        ,
			LAST_FLOW_ID   ,
			ITEM_PLAN_DATE ,
			ITEM_REQ_QTY   ,
			STOCK_QTY      ,
			OFFSET_QTY     ,
			DEMAND_QTY    ,
			EPOST_INSTANCE_ID ,			
			EPOST_COMPANY_ID  ,
			EPOST_DIVISION_ID ,
			EPOST_SITE_ID     ,
			EPOST_PLANT_ID    ,
			EPOST_FACTORY_ID  ,
			INSERT_ID      ,
			INSERT_TIME
		)
		SELECT  @V_MASTER_ID AS INSTANCE_ID ,  @V_PLAN_ID AS FP_PLAN_ID
		      , A.CELL_INSTANCE_ID, A.CELL_INSTANCE_DATE, A.CELL_RELEASE_PLAN_ID , A.CELL_AMEND_PLAN_ID
			  , A.CELL_COMPANY_ID , A.CELL_DIVISION_ID,  A.CELL_SITE_ID, A.CELL_PLANT_ID, A.CELL_FACTORY_ID, A.OPERATION_ID 
			  , A.ITEM_ID , A.ITEM_UOM, A.FLOW_ID, A.LAST_FLOW_ID  , A.ITEM_PLAN_DATE , A.ITEM_REQ_QTY , A.STOCK_QTY , A.OFFSET_QTY , A.DEMAND_QTY
			  , M.EPOST_INSTANCE_ID , M.EPOST_COMPANY_ID , M.EPOST_DIVISION_ID , M.EPOST_SITE_ID , M.EPOST_PLANT_ID, M.EPOST_FACTORY_ID 
			  , @v_proc_name  AS INSERT_ID 
			  , GETDATE()     AS INSERT_TIME 
		FROM    (
				SELECT  A.CELL_INSTANCE_ID, A.CELL_INSTANCE_DATE, A.CELL_RELEASE_PLAN_ID , A.CELL_AMEND_PLAN_ID
					  , A.CELL_COMPANY_ID , A.CELL_DIVISION_ID,  A.CELL_SITE_ID, A.CELL_PLANT_ID, A.CELL_FACTORY_ID, A.OPERATION_ID 
					  , A.ITEM_ID , A.ITEM_UOM, A.FLOW_ID, A.LAST_FLOW_ID  , A.ITEM_PLAN_DATE 
					  , SUM(A.ITEM_REQ_QTY) AS ITEM_REQ_QTY , A.STOCK_QTY
					  , SUM(A.OFFSET_QTY)   AS OFFSET_QTY 
					  , SUM(REMAIN_QTY)     AS DEMAND_QTY  
				FROM   (
						SELECT  A.CELL_INSTANCE_ID, A.CELL_INSTANCE_DATE, A.CELL_RELEASE_PLAN_ID , A.CELL_AMEND_PLAN_ID
							  , A.CELL_COMPANY_ID , A.CELL_DIVISION_ID,  A.CELL_SITE_ID, A.CELL_PLANT_ID, A.CELL_FACTORY_ID, A.OPERATION_ID , A.NP_ITEM_ID
							  , A.ITEM_ID , A.ITEM_UOM, A.FLOW_ID, A.LAST_FLOW_ID 
							  , A.ITEM_PLAN_DATE , A.ITEM_REQ_QTY, A.ITEM_REQ_SUM , S.STOCK_QTY 
							  , A.ITEM_REQ_SUM - S.STOCK_QTY AS GAP 
							  , CASE WHEN  (A.ITEM_REQ_SUM - S.STOCK_QTY) <= 0              THEN  ITEM_REQ_QTY 
									 WHEN  (A.ITEM_REQ_SUM - S.STOCK_QTY) <  ITEM_REQ_QTY   THEN  ITEM_REQ_QTY - (A.ITEM_REQ_SUM - S.STOCK_QTY)
									 ELSE   0   
								END  OFFSET_QTY  
							  , CASE WHEN  (A.ITEM_REQ_SUM - S.STOCK_QTY) <= 0              THEN  0
									 WHEN  (A.ITEM_REQ_SUM - S.STOCK_QTY) < ITEM_REQ_QTY    THEN  (A.ITEM_REQ_SUM - S.STOCK_QTY)
									 ELSE  ITEM_REQ_QTY 
								END  REMAIN_QTY 
						FROM    (
								SELECT  A.CELL_INSTANCE_ID, A.CELL_INSTANCE_DATE, A.CELL_RELEASE_PLAN_ID , A.CELL_AMEND_PLAN_ID , A.NP_ITEM_ID , A.ITEM_ID , A.ITEM_UOM, A.FLOW_ID, A.LAST_FLOW_ID , A.ITEM_PLAN_DATE  
									  , A.CELL_COMPANY_ID , A.CELL_DIVISION_ID,  A.CELL_SITE_ID, A.CELL_PLANT_ID, A.CELL_FACTORY_ID, A.OPERATION_ID , ITEM_REQ_QTY
									  , SUM(A.ITEM_REQ_QTY) OVER(PARTITION BY A.CELL_INSTANCE_ID, A.CELL_INSTANCE_DATE, A.CELL_RELEASE_PLAN_ID , A.CELL_AMEND_PLAN_ID , A.NP_ITEM_ID , A.ITEM_ID , A.ITEM_UOM, A.FLOW_ID, A.LAST_FLOW_ID
									                                        , A.CELL_COMPANY_ID , A.CELL_DIVISION_ID,  A.CELL_SITE_ID, A.CELL_PLANT_ID, A.CELL_FACTORY_ID, A.OPERATION_ID
																 ORDER BY ITEM_PLAN_DATE, NP_ITEM_ID, ITEM_REQ_QTY DESC ) AS ITEM_REQ_SUM
								FROM    TH_BUF_EPOST_NOTCHING_MTR_PLAN A 
								WHERE 	A.INSTANCE_ID = @V_MASTER_ID
								AND 	A.FP_PLAN_ID = @V_PLAN_ID
								) A
						LEFT OUTER JOIN TH_BUF_EPOST_STOCK  S
								ON   1=1
								AND  S.INSTANCE_ID 		= @V_MASTER_ID
								AND  S.FP_PLAN_ID 		= @V_PLAN_ID
								AND  A.CELL_COMPANY_ID  = S.COMPANY_ID
								AND  A.CELL_DIVISION_ID = S.DIVISION_ID
								AND  A.CELL_SITE_ID     = S.SITE_ID
								AND  A.CELL_PLANT_ID    = S.PLANT_ID
								AND  A.CELL_FACTORY_ID  = S.FACTORY_ID
								AND  A.ITEM_ID          = S.FP_APPLY_ITEM_ID 
								AND  A.OPERATION_ID     = S.FP_APPLY_OPERATION_ID
						WHERE   1=1
						) A
				WHERE  1=1 
				GROUP BY  A.CELL_INSTANCE_ID, A.CELL_INSTANCE_DATE, A.CELL_RELEASE_PLAN_ID , A.CELL_AMEND_PLAN_ID
					  , A.CELL_COMPANY_ID , A.CELL_DIVISION_ID,  A.CELL_SITE_ID, A.CELL_PLANT_ID, A.CELL_FACTORY_ID, A.OPERATION_ID 
					  , A.ITEM_ID , A.ITEM_UOM, A.FLOW_ID, A.LAST_FLOW_ID  , A.ITEM_PLAN_DATE , A.STOCK_QTY
				) A
			,   TH_BUF_EPOST_FACTORY_MAP  M
		WHERE  1=1
		AND    M.INSTANCE_ID      =  @V_MASTER_ID
		AND    M.FP_PLAN_ID       =  @V_PLAN_ID
		AND    A.CELL_COMPANY_ID  =  M.CELL_COMPANY_ID
		AND    A.CELL_DIVISION_ID =  M.CELL_DIVISION_ID
		AND    A.CELL_SITE_ID     =  M.CELL_SITE_ID
		AND    A.CELL_PLANT_ID    =  M.CELL_PLANT_ID
		AND    A.CELL_FACTORY_ID  =  M.CELL_FACTORY_ID
		 ; 		
		
		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;

		/** CELL에 매핑된 EPOST FACTORY개수로 분할하여 NET_DEMAND_QTY 생성 
		 ** 조립과 전극 사이트가 1:N으로 매핑될 경우를 대비하여 디폴트로 N분할 함.  안그러면 수요량이 N배가 됨. 
		 ** 후에 룰이 추가되면 여기서 조건처리 해줘야 함.
		 **/		

		UPDATE  A 
		SET     A.NET_DEMAND_QTY = A.DEMAND_QTY / M.CNT  
		FROM    TH_BUF_EPOST_NET_DEMAND  A 
			,   (
				SELECT  M.*
					  , count(m.EPOST_FACTORY_ID) over(partition by M.CELL_INSTANCE_ID , M.CELL_COMPANY_ID, M.CELL_DIVISION_ID , M.CELL_SITE_ID , M.CELL_PLANT_ID , M.CELL_FACTORY_ID ) as CNT 
				FROM    TH_BUF_EPOST_FACTORY_MAP  M 
				WHERE   1=1
				AND     M.INSTANCE_ID      = @V_MASTER_ID
				AND     M.FP_PLAN_ID       = @V_PLAN_ID
				) M 
		WHERE  1=1
		AND    A.INSTANCE_ID      =  @V_MASTER_ID
		AND    A.FP_PLAN_ID       =  @V_PLAN_ID
		AND    A.CELL_COMPANY_ID  =  M.CELL_COMPANY_ID
		AND    A.CELL_DIVISION_ID =  M.CELL_DIVISION_ID
		AND    A.CELL_SITE_ID     =  M.CELL_SITE_ID
		AND    A.CELL_PLANT_ID    =  M.CELL_PLANT_ID
		AND    A.CELL_FACTORY_ID  =  M.CELL_FACTORY_ID
		AND    A.EPOST_COMPANY_ID = M.EPOST_COMPANY_ID 
		AND    A.EPOST_DIVISION_ID = M.EPOST_DIVISION_ID
		AND    A.EPOST_SITE_ID  =  M.EPOST_SITE_ID
		AND    A.EPOST_PLANT_ID =  M.EPOST_PLANT_ID
		AND    A.EPOST_FACTORY_ID =  M.EPOST_FACTORY_ID 
		 ; 

		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr
	    ;
	   
		END    --5 


		BEGIN  --6
		--=========================================================
		-- 3-1. 전극 E4000 (SLITTING)공정 소요량 산출 
		-- 재고차감 , 수율반영 투입량 산출
		--=========================================================
		
		SET      @v_table_name = 'TH_BUF_EPOST_SLITTING_PLAN'

		INSERT INTO TH_BUF_EPOST_SLITTING_PLAN  (
		    INSTANCE_ID , 
			FP_PLAN_ID , 
			CELL_INSTANCE_ID       ,			
			CELL_INSTANCE_DATE     ,
			CELL_RELEASE_PLAN_ID   ,
			CELL_AMEND_PLAN_ID     ,
			EPOST_INSTANCE_ID ,
			EPOST_COMPANY_ID  ,
			EPOST_DIVISION_ID ,
			EPOST_SITE_ID     ,
			EPOST_PLANT_ID    ,
			EPOST_FACTORY_ID  ,
			FLOW_ID           ,
			OPERATION_ID      ,
			ITEM_UOM          ,
			ITEM_ID           ,
			ITEM_PLAN_DATE    ,
			NET_DEMAND_QTY    ,
			NET_DMD_SUM       ,
			STOCK_QTY         ,		
			GAP               ,
			STOCK_OFFSET_QTY  ,
			E4000_OUT_QTY     ,
			YIELD             ,
			E4000_IN_QTY      ,
			INSERT_ID         ,		
			INSERT_TIME    
		) 
		SELECT  @V_MASTER_ID , @V_PLAN_ID , 
      			A.CELL_INSTANCE_ID       ,			
				A.CELL_INSTANCE_DATE     ,
				A.CELL_RELEASE_PLAN_ID   ,
				A.CELL_AMEND_PLAN_ID     ,
				A.EPOST_INSTANCE_ID ,
				A.EPOST_COMPANY_ID  ,
				A.EPOST_DIVISION_ID ,
				A.EPOST_SITE_ID     ,
				A.EPOST_PLANT_ID    ,
				A.EPOST_FACTORY_ID  ,
				A.FLOW_ID           ,
				A.LAST_FLOW_ID  AS OPERATION_ID     ,
				A.ITEM_UOM          ,
				A.ITEM_ID           ,
				A.ITEM_PLAN_DATE    ,
				A.NET_DEMAND_QTY    ,
				A.NET_DMD_SUM       ,
				A.STOCK_QTY         ,
				A.GAP               ,
				A.STOCK_OFFSET_QTY  ,
				A.E4000_OUT_QTY     
			  , ISNULL(B.FACTORY_YIELD_EXCEPT , C.FACTORY_YIELD ) AS YIELD 
			  , CASE WHEN  ISNULL( ISNULL(B.FACTORY_YIELD_EXCEPT , C.FACTORY_YIELD ),0) = 0  THEN  E4000_OUT_QTY 
					 ELSE  E4000_OUT_QTY / (ISNULL( ISNULL(B.FACTORY_YIELD_EXCEPT , C.FACTORY_YIELD ),0))  
				END  E4000_IN_QTY    
			  , @v_proc_name  AS INSERT_ID
			  , GETDATE()     AS INSERT_TIME 
		FROM    ( --== STOCK OFFSET ==-- 
				SELECT  A.*  , S.STOCK_QTY 
					  , ISNULL(A.NET_DMD_SUM,0) - ISNULL(S.STOCK_QTY,0)   AS GAP 
					  , CASE WHEN  (ISNULL(A.NET_DMD_SUM,0) - ISNULL(S.STOCK_QTY,0)) <= 0   THEN   NET_DEMAND_QTY 
							 WHEN  (ISNULL(A.NET_DMD_SUM,0) - ISNULL(S.STOCK_QTY,0)) < NET_DEMAND_QTY  THEN  NET_DEMAND_QTY - (ISNULL(A.NET_DMD_SUM,0) - ISNULL(S.STOCK_QTY,0) )
							 ELSE   0 
						END  STOCK_OFFSET_QTY 
					  , CASE WHEN  (ISNULL(A.NET_DMD_SUM,0) - ISNULL(S.STOCK_QTY,0)) <= 0   THEN   0 
							 WHEN  (ISNULL(A.NET_DMD_SUM,0) - ISNULL(S.STOCK_QTY,0)) < NET_DEMAND_QTY  THEN  (ISNULL(A.NET_DMD_SUM,0) - ISNULL(S.STOCK_QTY,0) )
							 ELSE   NET_DEMAND_QTY 
						END  E4000_OUT_QTY      
				FROM    (
						SELECT  A.CELL_INSTANCE_ID, A.CELL_INSTANCE_DATE, A.CELL_RELEASE_PLAN_ID, A.CELL_AMEND_PLAN_ID , A.EPOST_INSTANCE_ID , A.EPOST_COMPANY_ID , A.EPOST_DIVISION_ID, A.EPOST_SITE_ID , A.EPOST_PLANT_ID , A.EPOST_FACTORY_ID 
							  , A.FLOW_ID , A.LAST_FLOW_ID , A.ITEM_UOM , A.ITEM_ID ,  A.ITEM_PLAN_DATE , A.NET_DEMAND_QTY  
							  , SUM(A.NET_DEMAND_QTY) OVER(PARTITION BY A.EPOST_INSTANCE_ID , A.EPOST_COMPANY_ID , A.EPOST_DIVISION_ID, A.EPOST_SITE_ID , A.EPOST_PLANT_ID , A.EPOST_FACTORY_ID , A.LAST_FLOW_ID , A.ITEM_ID
														   ORDER BY ITEM_PLAN_DATE, NET_DEMAND_QTY DESC ) AS NET_DMD_SUM 
						FROM   TH_BUF_EPOST_NET_DEMAND A 
						WHERE  1=1						
						AND    A.INSTANCE_ID      = @V_MASTER_ID
						AND    A.FP_PLAN_ID       = @V_PLAN_ID
						AND    A.LAST_FLOW_ID     = 'E4000' 
						) A
				LEFT OUTER JOIN TH_BUF_EPOST_STOCK  S
						ON   1=1
						AND  S.INSTANCE_ID       = @V_MASTER_ID
						AND  S.FP_PLAN_ID        = @V_PLAN_ID
						AND  A.EPOST_COMPANY_ID  = S.COMPANY_ID
						AND  A.EPOST_DIVISION_ID = S.DIVISION_ID
						AND  A.EPOST_SITE_ID     = S.SITE_ID
						AND  A.EPOST_PLANT_ID    = S.PLANT_ID
						AND  A.EPOST_FACTORY_ID  = S.FACTORY_ID
						AND  A.ITEM_ID           = S.FP_APPLY_ITEM_ID 
						AND  A.LAST_FLOW_ID      = S.FP_APPLY_OPERATION_ID
				) A
		LEFT OUTER JOIN ( --== 예외 수율 ==-- 
				SELECT  A.* 
					  , CASE WHEN  ISNULL(A.YIELD_SUM ,0) = 0  OR  ISNULL(A.CNT ,0) = 0  THEN 0 
							 ELSE  ISNULL(A.YIELD_SUM ,0) /  ISNULL(A.CNT ,0) 
						END  FACTORY_YIELD_EXCEPT 
				FROM   (		
						SELECT  DISTINCT COMPANY_ID , DIVISION_ID , SITE_ID, PLANT_ID , FACTORY_ID , OPERATION_ID , ITEM_ID , START_TIME , END_TIME , YIELD 
							  , SUM(YIELD) OVER(PARTITION BY COMPANY_ID , DIVISION_ID , SITE_ID, PLANT_ID , FACTORY_ID , OPERATION_ID , ITEM_ID , START_TIME , END_TIME) AS YIELD_SUM
							  , COUNT(LINE_ID) OVER(PARTITION BY COMPANY_ID , DIVISION_ID , SITE_ID, PLANT_ID , FACTORY_ID , OPERATION_ID , ITEM_ID , START_TIME , END_TIME) AS CNT  
						FROM    SCM_YIELD_EXCEPT_M  A 
						WHERE   ACTIVE_FLAG = 'Y' 
						) A
				WHERE  1=1 
				) B 
				ON   1=1
				AND A.EPOST_COMPANY_ID  =  B.COMPANY_ID 
				AND A.EPOST_DIVISION_ID =  B.DIVISION_ID
				AND A.EPOST_SITE_ID     =  B.SITE_ID
				AND A.EPOST_PLANT_ID    =  B.PLANT_ID
				AND A.EPOST_FACTORY_ID  =  B.FACTORY_ID
				AND A.LAST_FLOW_ID      =  B.OPERATION_ID
				AND A.ITEM_ID           =  B.ITEM_ID
				AND A.ITEM_PLAN_DATE   >=  B.START_TIME
				AND A.ITEM_PLAN_DATE   <=  B.END_TIME 		
		LEFT OUTER JOIN  ( --===  동별 수율 평균값 ==---
				SELECT  A.* 
					  , CASE WHEN  ISNULL(A.YIELD_SUM ,0) = 0  OR  ISNULL(A.CNT ,0) = 0  THEN 0 
							 ELSE  ISNULL(A.YIELD_SUM ,0) /  ISNULL(A.CNT ,0) 
						END  FACTORY_YIELD 
				FROM   (
						SELECT  DISTINCT COMPANY_ID , DIVISION_ID , SITE_ID, PLANT_ID , FACTORY_ID , OPERATION_ID , ITEM_ID , MONTH 
							  , SUM(YIELD) OVER(PARTITION BY COMPANY_ID , DIVISION_ID , SITE_ID, PLANT_ID , FACTORY_ID , OPERATION_ID , ITEM_ID , MONTH) AS YIELD_SUM
							  , COUNT(LINE_ID) OVER(PARTITION BY COMPANY_ID , DIVISION_ID , SITE_ID, PLANT_ID , FACTORY_ID , OPERATION_ID , ITEM_ID , MONTH) AS CNT  
						FROM    SCM_YIELD_M  
						WHERE   1=1 
						) A
				WHERE  1=1 
				) C 
				ON   1=1 
				AND A.EPOST_COMPANY_ID  =  C.COMPANY_ID 
				AND A.EPOST_DIVISION_ID =  C.DIVISION_ID
				AND A.EPOST_SITE_ID     =  C.SITE_ID
				AND A.EPOST_PLANT_ID    =  C.PLANT_ID
				AND A.EPOST_FACTORY_ID  =  B.FACTORY_ID
				AND A.LAST_FLOW_ID      =  C.OPERATION_ID
				AND A.ITEM_ID           =  C.ITEM_ID	
				AND CONVERT(NVARCHAR , FORMAT( A.ITEM_PLAN_DATE, 'yyyyMM')) = C.MONTH 
				; 

		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;			
			
		END  --6


		BEGIN --7
		--=========================================================
		-- 4-1. E3000 (Roll Press)공정 계획 생성 
		-- ((슬리팅 소요량 + 노칭 소요량)- 재고차감) / 수율 
		--=========================================================
		
		SET      @v_table_name = 'TH_BUF_EPOST_ROLLPRESS_PLAN'	
			
		INSERT INTO TH_BUF_EPOST_ROLLPRESS_PLAN  (
		    INSTANCE_ID , 
			FP_PLAN_ID  , 
			CELL_INSTANCE_ID       ,			
			CELL_INSTANCE_DATE     ,
			CELL_RELEASE_PLAN_ID   ,
			CELL_AMEND_PLAN_ID     ,
			EPOST_INSTANCE_ID ,
			EPOST_COMPANY_ID  ,
			EPOST_DIVISION_ID ,
			EPOST_SITE_ID     ,
			EPOST_PLANT_ID    ,
			EPOST_FACTORY_ID  ,
			FLOW_ID           ,
			OPERATION_ID      ,
			ITEM_UOM          ,
			ITEM_ID           ,
			ITEM_PLAN_DATE    ,
			NET_DEMAND_QTY    ,
			NET_DMD_SUM       ,
			STOCK_QTY         ,
			GAP               ,
			STOCK_OFFSET_QTY  ,
			E3000_OUT_QTY     ,
			YIELD             ,
			E3000_IN_QTY      ,
			INSERT_ID         ,		
			INSERT_TIME    
		) 		
		SELECT  @V_MASTER_ID , @V_PLAN_ID,  A.* 
			  , ISNULL(B.FACTORY_YIELD_EXCEPT , C.FACTORY_YIELD ) AS  YIELD
			  , CASE WHEN  ISNULL( ISNULL(B.FACTORY_YIELD_EXCEPT , C.FACTORY_YIELD ),0) = 0  THEN  E3000_OUT_QTY    ---+ 수율이 0 으로 들어올 경우 대비 조건처리 함. 
					 ELSE  E3000_OUT_QTY / (ISNULL( ISNULL(B.FACTORY_YIELD_EXCEPT , C.FACTORY_YIELD ),0))  
				END  E3000_IN_QTY 
			  , @v_proc_name AS INSERT_ID
			  , GETDATE()    AS INSERT_TIME 
		FROM    ( --== E3000공정 소요량에서 재고차감 ==--  
				SELECT  A.CELL_INSTANCE_ID, A.CELL_INSTANCE_DATE, A.CELL_RELEASE_PLAN_ID, A.CELL_AMEND_PLAN_ID , A.EPOST_INSTANCE_ID , A.EPOST_COMPANY_ID , A.EPOST_DIVISION_ID, A.EPOST_SITE_ID , A.EPOST_PLANT_ID , A.EPOST_FACTORY_ID 
					  , A.FLOW_ID , A.OPERATION_ID, A.ITEM_UOM , A.ITEM_ID , A.ITEM_PLAN_DATE , A.NET_DEMAND_QTY , A.NET_DMD_SUM , S.STOCK_QTY 
					  , (ISNULL(A.NET_DMD_SUM,0) - ISNULL(S.STOCK_QTY,0))  AS GAP 
					  , CASE WHEN  (ISNULL(A.NET_DMD_SUM,0) - ISNULL(S.STOCK_QTY,0))  <= 0               THEN  A.NET_DEMAND_QTY 
							 WHEN  (ISNULL(A.NET_DMD_SUM,0) - ISNULL(S.STOCK_QTY,0))  < A.NET_DEMAND_QTY THEN  A.NET_DEMAND_QTY - (ISNULL(A.NET_DMD_SUM,0) - ISNULL(S.STOCK_QTY,0)) 
							 ELSE 0
						END  STOCK_OFFSET_QTY 
					  , CASE WHEN  (ISNULL(A.NET_DMD_SUM,0) - ISNULL(S.STOCK_QTY,0))  <= 0           THEN  0
							 WHEN  (ISNULL(A.NET_DMD_SUM,0) - ISNULL(S.STOCK_QTY,0))  < A.NET_DEMAND_QTY THEN  (ISNULL(A.NET_DMD_SUM,0) - ISNULL(S.STOCK_QTY,0)) 
							 ELSE   A.NET_DEMAND_QTY 
						END  E3000_OUT_QTY    --+ 재고 차감 후 REMAINED QTY  
				FROM    (
						SELECT  A.* 	  
							  , SUM(A.NET_DEMAND_QTY) OVER(PARTITION BY  A.CELL_INSTANCE_ID, A.CELL_INSTANCE_DATE, A.CELL_RELEASE_PLAN_ID, A.CELL_AMEND_PLAN_ID , A.EPOST_INSTANCE_ID , A.EPOST_COMPANY_ID , A.EPOST_DIVISION_ID, A.EPOST_SITE_ID 
																  , A.EPOST_PLANT_ID , A.EPOST_FACTORY_ID , A.FLOW_ID , A.OPERATION_ID, A.ITEM_UOM , A.ITEM_ID  
													   ORDER BY  A.ITEM_PLAN_DATE, A.NET_DEMAND_QTY DESC  )  AS NET_DMD_SUM  
						FROM    (---== E3000공정 디맨드 가져오기 ==-- 
								SELECT  A.CELL_INSTANCE_ID, A.CELL_INSTANCE_DATE, A.CELL_RELEASE_PLAN_ID, A.CELL_AMEND_PLAN_ID , A.EPOST_INSTANCE_ID , A.EPOST_COMPANY_ID , A.EPOST_DIVISION_ID, A.EPOST_SITE_ID , A.EPOST_PLANT_ID , A.EPOST_FACTORY_ID 
									  , A.FLOW_ID , A.OPERATION_ID, A.ITEM_UOM , A.ITEM_ID , A.ITEM_PLAN_DATE , SUM(A.DEMAND_QTY ) AS NET_DEMAND_QTY 
								FROM    ( --== 슬리팅공정에서 받은 수량 + 조립에서 받은 수량 ==--
										SELECT  A.CELL_INSTANCE_ID, A.CELL_INSTANCE_DATE, A.CELL_RELEASE_PLAN_ID, A.CELL_AMEND_PLAN_ID , A.EPOST_INSTANCE_ID , A.EPOST_COMPANY_ID , A.EPOST_DIVISION_ID, A.EPOST_SITE_ID , A.EPOST_PLANT_ID , A.EPOST_FACTORY_ID 
											  , A.FLOW_ID , LEFT(RIGHT(A.FLOW_ID,10), 5)  AS OPERATION_ID , A.ITEM_UOM , A.ITEM_ID ,  A.ITEM_PLAN_DATE , A.E4000_IN_QTY AS DEMAND_QTY  
										FROM   TH_BUF_EPOST_SLITTING_PLAN A   
										WHERE  LEFT(RIGHT(A.FLOW_ID,10), 5) =  'E3000'
										AND    A.INSTANCE_ID = @V_MASTER_ID
										AND    A.FP_PLAN_ID  = @V_PLAN_ID  	
										UNION ALL 
										SELECT  A.CELL_INSTANCE_ID, A.CELL_INSTANCE_DATE, A.CELL_RELEASE_PLAN_ID, A.CELL_AMEND_PLAN_ID , A.EPOST_INSTANCE_ID , A.EPOST_COMPANY_ID , A.EPOST_DIVISION_ID, A.EPOST_SITE_ID , A.EPOST_PLANT_ID , A.EPOST_FACTORY_ID 
											  , A.FLOW_ID , A.LAST_FLOW_ID AS OPERATION_ID, A.ITEM_UOM , A.ITEM_ID , A.ITEM_PLAN_DATE , A.NET_DEMAND_QTY AS DEMAND_QTY
										FROM    TH_BUF_EPOST_NET_DEMAND A
										WHERE   A.LAST_FLOW_ID = 'E3000' 
										AND     A.INSTANCE_ID = @V_MASTER_ID
										AND     A.FP_PLAN_ID  = @V_PLAN_ID   
										) A		
								GROUP BY  A.CELL_INSTANCE_ID, A.CELL_INSTANCE_DATE, A.CELL_RELEASE_PLAN_ID, A.CELL_AMEND_PLAN_ID, A.EPOST_INSTANCE_ID , A.EPOST_COMPANY_ID , A.EPOST_DIVISION_ID, A.EPOST_SITE_ID , A.EPOST_PLANT_ID , A.EPOST_FACTORY_ID 
									  , A.FLOW_ID , A.OPERATION_ID, A.ITEM_UOM , A.ITEM_ID , A.ITEM_PLAN_DATE  
								) A 
						) A
				LEFT OUTER JOIN  TH_BUF_EPOST_STOCK  S 		
						ON   1=1
						AND  S.INSTANCE_ID =  @V_MASTER_ID
   				 		AND  S.FP_PLAN_ID  =  @V_PLAN_ID
						AND  A.EPOST_COMPANY_ID  = S.COMPANY_ID
						AND  A.EPOST_DIVISION_ID = S.DIVISION_ID
						AND  A.EPOST_SITE_ID     = S.SITE_ID
						AND  A.EPOST_PLANT_ID    = S.PLANT_ID
						AND  A.EPOST_FACTORY_ID  = S.FACTORY_ID
						AND  A.ITEM_ID           = S.FP_APPLY_ITEM_ID 
						AND  A.OPERATION_ID      = S.FP_APPLY_OPERATION_ID
				) A
		LEFT OUTER JOIN ( --== 동별 예외수율 평균값 ==-- 
				SELECT  A.* 
					  , CASE WHEN  ISNULL(A.YIELD_SUM ,0) = 0  OR  ISNULL(A.CNT ,0) = 0  THEN 0 
							 ELSE  ISNULL(A.YIELD_SUM ,0) /  ISNULL(A.CNT ,0) 
						END  FACTORY_YIELD_EXCEPT 
				FROM   (		
						SELECT  DISTINCT COMPANY_ID , DIVISION_ID , SITE_ID, PLANT_ID , FACTORY_ID , OPERATION_ID , ITEM_ID , START_TIME , END_TIME , YIELD 
							  , SUM(YIELD) OVER(PARTITION BY COMPANY_ID , DIVISION_ID , SITE_ID, PLANT_ID , FACTORY_ID , OPERATION_ID , ITEM_ID , START_TIME , END_TIME) AS YIELD_SUM
							  , COUNT(LINE_ID) OVER(PARTITION BY COMPANY_ID , DIVISION_ID , SITE_ID, PLANT_ID , FACTORY_ID , OPERATION_ID , ITEM_ID , START_TIME , END_TIME) AS CNT  
						FROM    SCM_YIELD_EXCEPT_M  A 
						WHERE   ACTIVE_FLAG = 'Y' 
						) A
				WHERE  1=1 
				) B 
				ON   1=1
				AND A.EPOST_COMPANY_ID  =  B.COMPANY_ID 
				AND A.EPOST_DIVISION_ID =  B.DIVISION_ID
				AND A.EPOST_SITE_ID     =  B.SITE_ID
				AND A.EPOST_PLANT_ID    =  B.PLANT_ID
				AND A.EPOST_FACTORY_ID  =  B.FACTORY_ID
				AND A.OPERATION_ID      =  B.OPERATION_ID
				AND A.ITEM_ID           =  B.ITEM_ID
				AND A.ITEM_PLAN_DATE   >=  B.START_TIME
				AND A.ITEM_PLAN_DATE   <=  B.END_TIME 		
		LEFT OUTER JOIN  ( --===  동별 수율 평균값 ==---
				SELECT  A.* 
					  , CASE WHEN  ISNULL(A.YIELD_SUM ,0) = 0  OR  ISNULL(A.CNT ,0) = 0  THEN 0 
							 ELSE  ISNULL(A.YIELD_SUM ,0) /  ISNULL(A.CNT ,0) 
						END  FACTORY_YIELD 
				FROM   (
						SELECT  DISTINCT COMPANY_ID , DIVISION_ID , SITE_ID, PLANT_ID , FACTORY_ID , OPERATION_ID , ITEM_ID , MONTH 
							  , SUM(YIELD) OVER(PARTITION BY COMPANY_ID , DIVISION_ID , SITE_ID, PLANT_ID , FACTORY_ID , OPERATION_ID , ITEM_ID , MONTH) AS YIELD_SUM
							  , COUNT(LINE_ID) OVER(PARTITION BY COMPANY_ID , DIVISION_ID , SITE_ID, PLANT_ID , FACTORY_ID , OPERATION_ID , ITEM_ID , MONTH) AS CNT  
						FROM    SCM_YIELD_M  
						WHERE   1=1 
						) A
				WHERE  1=1 
				) C 
				ON   1=1 
				AND A.EPOST_COMPANY_ID  =  C.COMPANY_ID 
				AND A.EPOST_DIVISION_ID =  C.DIVISION_ID
				AND A.EPOST_SITE_ID     =  C.SITE_ID
				AND A.EPOST_PLANT_ID    =  C.PLANT_ID
				AND A.EPOST_FACTORY_ID  =  B.FACTORY_ID
				AND A.OPERATION_ID      =  C.OPERATION_ID
				AND A.ITEM_ID           =  C.ITEM_ID	
				AND CONVERT(NVARCHAR , FORMAT( A.ITEM_PLAN_DATE, 'yyyyMM')) = C.MONTH 		
		; 
	
		-- LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;	

		END   --7 



		BEGIN --8
		--=========================================================
		-- 5-1.  Coater Plan 
		-- 전극 INSTACNE의 RELEASED PLAN 조회함.
		--=========================================================

		SET      @v_table_name = 'TH_BUF_EPOST_COATER_PLAN'
			
		INSERT INTO  TH_BUF_EPOST_COATER_PLAN  (
		INSTANCE_ID , 
		FP_PLAN_ID , 
		EPRE_INSTANCE_ID    ,		
		EPRE_INSTANCE_DATE    ,	
		EPRE_RELEASE_PLAN_ID  ,		
		EPRE_AMEND_PLAN_ID   ,
		COMPANY_ID     ,
		DIVISION_ID    ,
		SITE_ID     ,
		PLANT_ID     ,
		FACTORY_ID    , 
		OPERATION_ID   ,	
		ITEM_UOM        ,
		ITEM_ID    ,			
		ITEM_PLAN_DATE   ,    
		STOCK_QTY      ,
		E2000_OUT_QTY    ,
		E2000_IN_QTY   ,
		INSERT_ID      ,			
		INSERT_TIME    
		) 
		SELECT  @V_MASTER_ID AS INSTANCE_ID , @V_PLAN_ID AS FP_PLAN_ID , A.EPRE_INSTANCE_ID
		      , A.INSTANCE_DATE AS EPRE_INSTACNE_DATE , RELEASE_PLAN_ID , A.AMEND_PLAN_ID,  A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID , A.OPERATION_ID , A.ITEM_UOM, A.ITEM_ID , A.PLAN_DATE , S.STOCK_QTY 
			  , SUM(PLAN_QTY)  AS PLAN_OUT_QTY 
			  , SUM(PLAN_IN_QTY) AS PLAN_IN_QTY 
			  , @v_proc_name    AS INSERT_ID
			  , GETDATE()  AS INSERT_TIME 
		FROM    ( --== A 최종 릴리즈 COATER 계획 ==-- 
				SELECT  B.EPOST_INSTACNE_ID,  B.COMPANY_ID, B.SITE_ID, B.PLANT_ID, A.INSTANCE_ID AS EPRE_INSTANCE_ID , A.INSTANCE_DATE, A.RELEASE_PLAN_ID , A.AMEND_PLAN_ID, A.DIVISION_ID, A.FACTORY_ID , A.PLAN_GROUP_ID , A.WORK_ORDER_ID
					  , A.ITEM_ID,  A.LINE_ID 
					  , A.OPERATION_ID , A.ELECTRODE_TYPE , A.MARKET , A.PRODUCTION_TYPE
					  , A.PLAN_DATE  
					  , A.PLAN_QTY  	
					  , A.PLAN_IN_QTY
					  , C.ITEM_UOM 
				FROM    FP_RELEASE_FULL_PLAN_H A 
					,	( --== 마지막 릴리즈 버전 검색 ==-- 
						SELECT  A.E_POST AS EPOST_INSTACNE_ID , A.INSTANCE_ID AS EPRE_INSTANCE_ID, A.RELEASE_PLAN_ID  , A.AMEND_PLAN_ID  , A.FACTORY_ID  ,A.PLAN_GROUP_ID  ,A.INSTANCE_DATE , B.COMPANY_ID , B.DIVISION_ID , B.SITE_ID , B.PLANT_ID 
						FROM    ( 
								SELECT  B.E_POST, A.INSTANCE_ID   , A.RELEASE_PLAN_ID  , A.AMEND_PLAN_ID ,  A.FACTORY_ID  ,A.PLAN_GROUP_ID  ,A.INSTANCE_DATE
									 ,  DENSE_RANK() OVER(PARTITION BY INSTANCE_ID, FACTORY_ID ORDER BY INSTANCE_DATE DESC, RELEASE_PLAN_ID ASC ) AS RNK   
								FROM    FP_RELEASE_PLAN_INFO_H A 
									  , (
										SELECT X.SEGMENT1  AS E_PRE , X.SEGMENT2 AS CELL , X.SEGMENT3 AS E_POST  
										FROM  SCM_SYS_LOOKUP_VALUE  X
											,  (
												SELECT  DISTINCT  X.SEGMENT1 AS EPOST , X.SEGMENT3 AS CELL 
												FROM  SCM_SYS_LOOKUP_VALUE  X
												WHERE X.ACTIVE_FLAG = 'Y'   
												AND   X.LOOKUP_TYPE_CODE = 'ELEC_POST_FACTORY_MAP'
												AND   X.SEGMENT1 = @V_MASTER_ID
												) Y
										WHERE X.ACTIVE_FLAG = 'Y'   
										AND  X.LOOKUP_TYPE_CODE = 'ELEC_ASSY_INSTANCE_MAP'
										AND  X.SEGMENT2 = Y.CELL
										AND  X.SEGMENT3 = Y.EPOST 
										) B 
								WHERE  1=1
								AND   A.INSTANCE_ID  =  B.E_PRE 
								) A
							,   SCM_FACTORY_M B
						WHERE A.RNK = 1
						AND   A.FACTORY_ID   =   B.FACTORY_ID 
						) B
					,   SCM_ITEM_M    C
				WHERE 1=1
				AND  A.INSTANCE_ID      = B.EPRE_INSTANCE_ID
				AND  A.RELEASE_PLAN_ID  = B.RELEASE_PLAN_ID
				AND  A.AMEND_PLAN_ID    = B.AMEND_PLAN_ID
				AND  A.FACTORY_ID       = B.FACTORY_ID 
				AND  A.INSTANCE_DATE    = B.INSTANCE_DATE
				AND  A.OPERATION_ID     = 'E2000'
				AND  B.COMPANY_ID   =  C.COMPANY_ID
				AND  A.DIVISION_ID  =  C.DIVISION_ID
				AND  B.SITE_ID      =  C.SITE_ID
				AND  A.ITEM_ID      =  C.ITEM_ID 		
				) A		
		LEFT OUTER JOIN  TH_BUF_EPOST_STOCK S
				ON   1=1
				AND  S.INSTANCE_ID = @V_MASTER_ID
				AND  S.FP_PLAN_ID =  @V_PLAN_ID
				AND  A.COMPANY_ID  = S.COMPANY_ID
				AND  A.DIVISION_ID = S.DIVISION_ID
				AND  A.SITE_ID     = S.SITE_ID
				AND  A.PLANT_ID    = S.PLANT_ID
				AND  A.FACTORY_ID  = S.FACTORY_ID
				AND  A.ITEM_ID     = S.FP_APPLY_ITEM_ID 
				AND  A.OPERATION_ID = S.FP_APPLY_OPERATION_ID
		GROUP BY A.EPRE_INSTANCE_ID , A.EPOST_INSTACNE_ID , A.INSTANCE_DATE ,RELEASE_PLAN_ID , A.AMEND_PLAN_ID, A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID , A.OPERATION_ID , A.ITEM_ID , A.PLAN_DATE , S.STOCK_QTY , A.ITEM_UOM 		
		; 
	
		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;		

		END   --8 



		BEGIN --9
		--=========================================================
		-- 6-1. UI TABLE에 밀어넣기.
		--=========================================================

		SET      @v_table_name = 'FP_ELECTRODE_POST_PLAN_H'

		---- 11- NOTCHING PLAN ---- 
		INSERT INTO  FP_ELECTRODE_POST_PLAN_H  (
			INSTANCE_ID ,
			FP_PLAN_ID  ,
			COMPANY_ID ,
			DIVISION_ID ,
			SITE_ID ,
			PLANT_ID,
			FACTORY_ID,
			ITEM_ID,
			NP_ITEM_ID,
			CATEGORY,
			PLAN_DATE, 
			BOH ,
			BOH_PC ,
			BOH_JR ,
			BOH_CELL ,
			IN_QTY , 
			OUT_QTY ,
			IN_PC_QTY ,
			OUT_PC_QTY ,
			IN_JR_QTY ,
			OUT_JR_QTY ,
			IN_CELL_QTY ,
			OUT_CELL_QTY ,
			INSERT_ID , 
			INSERT_TIME, 
			UPDATE_ID, 
			UPDATE_TIME
		) 
		SELECT  A.EPOST_INSTANCE_ID  
			  , A.FP_PLAN_ID 
			  , A.EPOST_COMPANY_ID 
			  , A.EPOST_DIVISION_ID 
			  , A.EPOST_SITE_ID 
			  , A.EPOST_PLANT_ID 
			  , A.EPOST_FACTORY_ID 
			  , A.ITEM_ID 
			  , A.NP_ITEM_ID 
			  , '11-Notching Plan'   AS  CATEGORY 
			  , A.NP_PLAN_DATE AS PLAN_DATE 
			  , ISNULL(MAX(A.STOCK_QTY),0)  AS BOH
			  , ISNULL((MAX(A.STOCK_QTY) * A.BOM_RATE),0)  AS BOH_PC
			  , ISNULL((MAX(A.STOCK_QTY) * A.BOM_RATE / A.LANE_VALUE),0)  AS BOH_JR
			  , ISNULL((MAX(A.STOCK_QTY) * A.BOM_RATE / A.LANE_VALUE * A.JR_C_M_VALUE),0)  AS BOH_CELL
			  , SUM(A.PLAN_IN_QTY) AS IN_QTY  
			  , SUM(A.PLAN_QTY) AS OUT_QTY  
			  , SUM(A.PLAN_IN_QTY) * A.BOM_RATE AS IN_PC_QTY
			  , SUM(A.PLAN_QTY) * A.BOM_RATE AS OUT_PC_QTY
			  , SUM(A.PLAN_IN_QTY) * A.BOM_RATE / ISNULL(A.LANE_VALUE, A.LANE_VALUE_TEST)  AS IN_JR_QTY
			  , SUM(A.PLAN_QTY) * A.BOM_RATE / ISNULL(A.LANE_VALUE, A.LANE_VALUE_TEST) AS OUT_JR_QTY
			  , SUM(A.PLAN_IN_QTY) * A.BOM_RATE / ISNULL(A.LANE_VALUE, A.LANE_VALUE_TEST) * ISNULL(A.JR_C_M_VALUE, A.JR_C_M_VALUE_TEST) AS IN_CELL_QTY
			  , SUM(A.PLAN_QTY) * A.BOM_RATE / ISNULL(A.LANE_VALUE, A.LANE_VALUE_TEST) * ISNULL(A.JR_C_M_VALUE, A.JR_C_M_VALUE_TEST) AS OUT_CELL_QTY
			  , @v_proc_name  AS INSERT_ID
			  , GETDATE() AS INSERT_TIME 
			  , @v_proc_name   AS UPDATE_ID
			  , GETDATE() AS UPDATE_TIME 
		FROM    (
				SELECT  DISTINCT A.CELL_INSTANCE_ID , A.FP_PLAN_ID , A.CELL_COMPANY_ID , A.CELL_DIVISION_ID ,  A.CELL_SITE_ID,  A.CELL_PLANT_ID,  A.CELL_FACTORY_ID
					  , A.NP_ITEM_ID , A.PLAN_DATE, A.NP_PLAN_DATE, A.NP_IN_QTY AS PLAN_IN_QTY , A.REMIAN_QTY AS PLAN_QTY
					  , B.EPOST_INSTANCE_ID , B.EPOST_COMPANY_ID , B.EPOST_DIVISION_ID , B.EPOST_SITE_ID , B.EPOST_PLANT_ID , B.EPOST_FACTORY_ID , B.ITEM_ID , B.STOCK_QTY
					  , B.APPLIED_MODEL, B.JR_C_M_VALUE, B.LANE_VALUE, B.BOM_RATE, B.JR_C_M_VALUE_TEST, B.LANE_VALUE_TEST
				FROM    TH_BUF_EPOST_NOTCHING_PLAN   A 
				LEFT OUTER JOIN (
						SELECT  DISTINCT A.INSTANCE_ID , A.FP_PLAN_ID , A.CELL_RELEASE_PLAN_ID 
						      , A.CELL_COMPANY_ID , A.CELL_DIVISION_ID , A.CELL_SITE_ID , A.CELL_PLANT_ID , A.CELL_FACTORY_ID , A.OPERATION_ID , A.NP_ITEM_ID , A.ITEM_ID 
							  , B.EPOST_INSTANCE_ID , B.EPOST_COMPANY_ID , B.EPOST_DIVISION_ID , B.EPOST_SITE_ID , B.EPOST_PLANT_ID , B.EPOST_FACTORY_ID , B.STOCK_QTY 
							  , C.APPLIED_MODEL, D.CATEGORY AS JR_C_M, D.VALUE AS JR_C_M_VALUE, E.CATEGORY AS LANE, E.VALUE AS LANE_VALUE
							  , G.CATEGORY AS JR_C_M_TEST, G.VALUE AS JR_C_M_VALUE_TEST, H.CATEGORY AS LANE_TEST, H.VALUE AS LANE_VALUE_TEST
							  , F.CHILD_QTY / F.PARENT_QTY AS BOM_RATE							  
						FROM   TH_BUF_EPOST_NOTCHING_MTR_PLAN  A 
						LEFT OUTER JOIN   TH_BUF_EPOST_NET_DEMAND B 
								ON   1=1
								AND   A.INSTANCE_ID     	 =  B.INSTANCE_ID 
								AND   A.FP_PLAN_ID      	 =  B.FP_PLAN_ID 
								AND   A.CELL_COMPANY_ID      =  B.CELL_COMPANY_ID
								AND   A.CELL_DIVISION_ID     =  B.CELL_DIVISION_ID
								AND   A.CELL_SITE_ID         =  B.CELL_SITE_ID
								AND   A.CELL_PLANT_ID        =  B.CELL_PLANT_ID
								AND   A.CELL_FACTORY_ID      =  B.CELL_FACTORY_ID
								AND   A.ITEM_ID         =  B.ITEM_ID 
						LEFT OUTER JOIN   SCM_ITEM_M C
								ON 	 1=1
								AND  B.ITEM_ID = C.ITEM_ID
								AND  B.EPOST_COMPANY_ID = C.COMPANY_ID
								AND  B.EPOST_DIVISION_ID = C.DIVISION_ID
								AND  B.EPOST_SITE_ID = C.SITE_ID
								AND  C.ACTIVE_FLAG = 'Y'
						LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M D
							 	ON 	 1=1
								AND  D.MAX_VER_FLAG = 'Y'
								AND  D.VERSION_TYPE = 'MASS'
								AND  C.COMPANY_ID = D.COMPANY_ID
								AND  C.DIVISION_ID = D.DIVISION_ID
								AND  C.SITE_ID = D.SITE_ID
								AND  B.EPOST_FACTORY_ID = D.FACTORY_ID
								AND  C.APPLIED_MODEL = D.MODEL_ID
								AND  C.ITEM_ID = D.ITEM_ID
								AND  D.OPERATION = 'E2000' 
								AND  D.CATEGORY = 'Jumbo Roll (cell/m)'				
						LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M E
							 	ON 	 1=1
								AND  E.MAX_VER_FLAG = 'Y'
								AND  E.VERSION_TYPE = 'MASS'
								AND  C.COMPANY_ID = E.COMPANY_ID
								AND  C.DIVISION_ID = E.DIVISION_ID
								AND  C.SITE_ID = E.SITE_ID
								AND  B.EPOST_FACTORY_ID = E.FACTORY_ID
								AND  C.APPLIED_MODEL = E.MODEL_ID
								AND  C.ITEM_ID = E.ITEM_ID
								AND  E.OPERATION = 'E2000' 
								AND  E.CATEGORY = 'Lane Number'
						LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M G
							 	ON 	 1=1
								AND  G.MAX_VER_FLAG = 'Y'
								AND  G.VERSION_TYPE = 'TEST'
								AND  C.COMPANY_ID = G.COMPANY_ID
								AND  C.DIVISION_ID = G.DIVISION_ID
								AND  C.SITE_ID = G.SITE_ID
								AND  B.EPOST_FACTORY_ID = G.FACTORY_ID
								AND  C.APPLIED_MODEL = G.MODEL_ID
								AND  C.ITEM_ID = G.ITEM_ID
								AND  G.OPERATION = 'E2000' 
								AND  G.CATEGORY = 'Jumbo Roll (cell/m)'				
						LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M H
							 	ON 	 1=1
								AND  H.MAX_VER_FLAG = 'Y'
								AND  H.VERSION_TYPE = 'TEST'
								AND  C.COMPANY_ID = H.COMPANY_ID
								AND  C.DIVISION_ID = H.DIVISION_ID
								AND  C.SITE_ID = H.SITE_ID
								AND  B.EPOST_FACTORY_ID = H.FACTORY_ID
								AND  C.APPLIED_MODEL = H.MODEL_ID
								AND  C.ITEM_ID = H.ITEM_ID
								AND  H.OPERATION = 'E2000' 
								AND  H.CATEGORY = 'Lane Number'
						LEFT OUTER JOIN  SCM_BOM_M F
								ON 	 1=1
								AND  A.CELL_COMPANY_ID  = F.COMPANY_ID
								AND  A.CELL_DIVISION_ID = F.DIVISION_ID
								AND  A.CELL_SITE_ID  = F.SITE_ID
								AND  A.CELL_PLANT_ID = F.PLANT_ID
								AND A.NP_ITEM_ID  = F.PARENT_ITEM_ID 
								AND  A.ITEM_ID  = F.CHILD_ITEM_ID
								AND  F.EFF_END_DATE >= GETDATE()
								AND  F.ACTIVE_FLAG = 'Y'
						WHERE   A.INSTANCE_ID = @V_MASTER_ID
						AND 	A.FP_PLAN_ID  = @V_PLAN_ID
						) B
						ON    1=1
						AND   A.INSTANCE_ID  		 =  B.INSTANCE_ID
						AND   A.FP_PLAN_ID      	 =  B.FP_PLAN_ID 
						AND   A.CELL_COMPANY_ID   	 =  B.CELL_COMPANY_ID
						AND   A.CELL_DIVISION_ID     =  B.CELL_DIVISION_ID
						AND   A.CELL_SITE_ID         =  B.CELL_SITE_ID
						AND   A.CELL_PLANT_ID        =  B.CELL_PLANT_ID
						AND   A.CELL_FACTORY_ID      =  B.CELL_FACTORY_ID
						AND   A.NP_ITEM_ID      =  B.NP_ITEM_ID 		
				WHERE   A.INSTANCE_ID = @V_MASTER_ID
				AND 	A.FP_PLAN_ID  = @V_PLAN_ID
				) A 
				where 	1=1
		GROUP BY A.EPOST_INSTANCE_ID 
			  , A.FP_PLAN_ID
			  , A.EPOST_COMPANY_ID 
			  , A.EPOST_DIVISION_ID 
			  , A.EPOST_SITE_ID 
			  , A.EPOST_PLANT_ID 
			  , A.EPOST_FACTORY_ID 
			  , A.ITEM_ID 
			  , A.NP_ITEM_ID 			  
			  , A.NP_PLAN_DATE
			  , A.BOM_RATE
			  , A.CELL_PLANT_ID
			  , A.APPLIED_MODEL
			  , A.LANE_VALUE
			  , A.JR_C_M_VALUE
			  , A.LANE_VALUE_TEST
			  , A.JR_C_M_VALUE_TEST
		;

		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = '11-NOTCHING PLAN'
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;	

		 ---- 21-Slitting Plan ----

		INSERT INTO  FP_ELECTRODE_POST_PLAN_H  (
			INSTANCE_ID ,
			FP_PLAN_ID  ,
			COMPANY_ID ,
			DIVISION_ID ,
			SITE_ID ,
			PLANT_ID,
			FACTORY_ID,
			ITEM_ID,
			NP_ITEM_ID,
			CATEGORY,
			PLAN_DATE, 
			BOH ,
			BOH_PC ,
			BOH_JR ,
			BOH_CELL ,
			IN_QTY , 
			OUT_QTY ,
			IN_PC_QTY ,
			OUT_PC_QTY ,
			IN_JR_QTY ,
			OUT_JR_QTY ,
			IN_CELL_QTY ,
			OUT_CELL_QTY ,
			INSERT_ID , 
			INSERT_TIME, 
			UPDATE_ID, 
			UPDATE_TIME
		) 
		 SELECT  A.EPOST_INSTANCE_ID 
			   , A.FP_PLAN_ID 
			   , A.EPOST_COMPANY_ID 
			   , A.EPOST_DIVISION_ID 
			   , A.EPOST_SITE_ID 
			   , A.EPOST_PLANT_ID 
			   , A.EPOST_FACTORY_ID 
			   , A.ITEM_ID 
			   , '-' AS NP_ITEM_ID 
			   , '21-Slitting Plan' AS CATEGORY
			   , A.ITEM_PLAN_DATE   AS PLAN_DATE
			   , MAX(A.STOCK_QTY)        AS BOH
			   , MAX(A.STOCK_QTY)        AS BOH_PC
			   , MAX(A.STOCK_QTY) / ISNULL(E.VALUE, G.VALUE)       AS BOH_JR
			   , MAX(A.STOCK_QTY) / ISNULL(E.VALUE, G.VALUE) * ISNULL(D.VALUE, F.VALUE)        AS BOH_CELL
			   , SUM(A.E4000_IN_QTY)     AS IN_QTY 
			   , SUM(A.E4000_OUT_QTY)    AS OUT_QTY
			   , SUM(A.E4000_IN_QTY)     AS IN_PC_QTY
			   , SUM(A.E4000_OUT_QTY)    AS OUT_PC_QTY
			   , SUM(A.E4000_IN_QTY) / ISNULL(E.VALUE, G.VALUE)    AS IN_JR_QTY
			   , SUM(A.E4000_OUT_QTY) / ISNULL(E.VALUE, G.VALUE)    AS OUT_JR_QTY
			   , SUM(A.E4000_IN_QTY) / ISNULL(E.VALUE, G.VALUE) * ISNULL(D.VALUE, F.VALUE)    AS IN_CELL_QTY
			   , SUM(A.E4000_OUT_QTY) / ISNULL(E.VALUE, G.VALUE) * ISNULL(D.VALUE, F.VALUE)    AS OUT_CELL_QTY			    
			  , @v_proc_name  AS INSERT_ID
			  , GETDATE()     AS INSERT_TIME 
			  , @v_proc_name  AS UPDATE_ID
			  , GETDATE()     AS UPDATE_TIME
		FROM    TH_BUF_EPOST_SLITTING_PLAN  A 
				LEFT OUTER JOIN SCM_ITEM_M B
					  	ON 	1=1
					  	AND B.ACTIVE_FLAG = 'Y'
					  	AND A.EPOST_COMPANY_ID = B.COMPANY_ID 
				      	AND A.EPOST_DIVISION_ID = B.DIVISION_ID
				      	AND A.EPOST_SITE_ID = B.SITE_ID
				      	AND A.ITEM_ID = B.ITEM_ID
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M D
					 	ON 	 1=1
						AND  D.MAX_VER_FLAG = 'Y'
						AND  D.VERSION_TYPE = 'MASS'
						AND  A.EPOST_COMPANY_ID = D.COMPANY_ID
						AND  A.EPOST_DIVISION_ID = D.DIVISION_ID
						AND  A.EPOST_SITE_ID = D.SITE_ID
						AND  A.EPOST_FACTORY_ID = D.FACTORY_ID
						AND  B.APPLIED_MODEL = D.MODEL_ID
						AND  B.ITEM_ID = D.ITEM_ID
						AND  D.OPERATION = 'E2000' 
						AND  D.CATEGORY = 'Jumbo Roll (cell/m)'				
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M E
					 	ON 	 1=1
						AND  E.MAX_VER_FLAG = 'Y'
						AND  E.VERSION_TYPE = 'MASS'
						AND  A.EPOST_COMPANY_ID = E.COMPANY_ID
						AND  A.EPOST_DIVISION_ID = E.DIVISION_ID
						AND  A.EPOST_SITE_ID = E.SITE_ID
						AND  A.EPOST_FACTORY_ID = E.FACTORY_ID
						AND  B.APPLIED_MODEL = E.MODEL_ID
						AND  B.ITEM_ID = E.ITEM_ID
						AND  E.OPERATION = 'E2000' 
						AND  E.CATEGORY = 'Lane Number'
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M F
					 	ON 	 1=1
						AND  F.MAX_VER_FLAG = 'Y'
						AND  F.VERSION_TYPE = 'TEST'
						AND  A.EPOST_COMPANY_ID = F.COMPANY_ID
						AND  A.EPOST_DIVISION_ID = F.DIVISION_ID
						AND  A.EPOST_SITE_ID = F.SITE_ID
						AND  A.EPOST_FACTORY_ID = F.FACTORY_ID
						AND  B.APPLIED_MODEL = F.MODEL_ID
						AND  B.ITEM_ID = F.ITEM_ID
						AND  F.OPERATION = 'E2000' 
						AND  F.CATEGORY = 'Jumbo Roll (cell/m)'				
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M G
					 	ON 	 1=1
						AND  G.MAX_VER_FLAG = 'Y'
						AND  G.VERSION_TYPE = 'TEST'
						AND  A.EPOST_COMPANY_ID = G.COMPANY_ID
						AND  A.EPOST_DIVISION_ID = G.DIVISION_ID
						AND  A.EPOST_SITE_ID = G.SITE_ID
						AND  A.EPOST_FACTORY_ID = G.FACTORY_ID
						AND  B.APPLIED_MODEL = G.MODEL_ID
						AND  B.ITEM_ID = G.ITEM_ID
						AND  G.OPERATION = 'E2000' 
						AND  G.CATEGORY = 'Lane Number'	
		WHERE   A.INSTANCE_ID =  @V_MASTER_ID
		AND 	A.FP_PLAN_ID  =  @V_PLAN_ID 
		GROUP BY A.EPOST_INSTANCE_ID 
			   , A.FP_PLAN_ID 
			   , A.EPOST_COMPANY_ID 
			   , A.EPOST_DIVISION_ID 
			   , A.EPOST_SITE_ID 
			   , A.EPOST_PLANT_ID 
			   , A.EPOST_FACTORY_ID 
			   , A.ITEM_ID 
			   , A.ITEM_PLAN_DATE	
			   , E.VALUE 
			   , D.VALUE
			   , F.VALUE
			   , G.VALUE
		;
	
		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = '21-SLITTING PLAN'
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;	

		---- 31-Roll Press Plan ----

		INSERT INTO  FP_ELECTRODE_POST_PLAN_H  (
			INSTANCE_ID ,
			FP_PLAN_ID  ,
			COMPANY_ID ,
			DIVISION_ID ,
			SITE_ID ,
			PLANT_ID,
			FACTORY_ID,
			ITEM_ID,
			NP_ITEM_ID,
			CATEGORY,
			PLAN_DATE, 
			BOH ,
			BOH_PC ,
			BOH_JR ,
			BOH_CELL ,
			IN_QTY , 
			OUT_QTY ,
			IN_PC_QTY ,
			OUT_PC_QTY ,
			IN_JR_QTY ,
			OUT_JR_QTY ,
			IN_CELL_QTY ,
			OUT_CELL_QTY ,
			INSERT_ID , 
			INSERT_TIME, 
			UPDATE_ID, 
			UPDATE_TIME
		) 
		SELECT  A.INSTANCE_ID 
			   , A.FP_PLAN_ID 
			   , A.EPOST_COMPANY_ID 
			   , A.EPOST_DIVISION_ID 
			   , A.EPOST_SITE_ID 
			   , A.EPOST_PLANT_ID 
			   , A.EPOST_FACTORY_ID 
			   , A.ITEM_ID 
			   , '-' AS NP_ITEM_ID 
			   , '31-Roll Press Plan' AS CATEGORY
			   , A.ITEM_PLAN_DATE   AS PLAN_DATE
			   , MAX(A.STOCK_QTY)        													AS BOH
			   , MAX(A.STOCK_QTY)        													AS BOH_PC
			   , MAX(A.STOCK_QTY) / ISNULL(E.VALUE, G.VALUE)       							AS BOH_JR
			   , MAX(A.STOCK_QTY) / ISNULL(E.VALUE, G.VALUE) * ISNULL(D.VALUE, F.VALUE)     AS BOH_CELL
			   , SUM(A.E3000_IN_QTY)     													AS IN_QTY 
			   , SUM(A.E3000_OUT_QTY)    													AS OUT_QTY
			   , SUM(A.E3000_IN_QTY)     													AS IN_PC_QTY
			   , SUM(A.E3000_OUT_QTY)    													AS OUT_PC_QTY
			   , SUM(A.E3000_IN_QTY) / ISNULL(E.VALUE, G.VALUE)    							AS IN_JR_QTY
			   , SUM(A.E3000_OUT_QTY) / ISNULL(E.VALUE, G.VALUE)    						AS OUT_JR_QTY
			   , SUM(A.E3000_IN_QTY) / ISNULL(E.VALUE, G.VALUE) * ISNULL(D.VALUE, F.VALUE)  AS IN_CELL_QTY
			   , SUM(A.E3000_OUT_QTY) / ISNULL(E.VALUE, G.VALUE) * ISNULL(D.VALUE, F.VALUE) AS OUT_CELL_QTY	
			  , @v_proc_name  AS INSERT_ID
			  , GETDATE()     AS INSERT_TIME 
			  , @v_proc_name  AS UPDATE_ID
			  , GETDATE()     AS UPDATE_TIME
		FROM    TH_BUF_EPOST_ROLLPRESS_PLAN A
				LEFT OUTER JOIN SCM_ITEM_M B
					  	ON 	1=1
					  	AND B.ACTIVE_FLAG = 'Y'
					  	AND A.EPOST_COMPANY_ID = B.COMPANY_ID 
				      	AND A.EPOST_DIVISION_ID = B.DIVISION_ID
				      	AND A.EPOST_SITE_ID = B.SITE_ID
				      	AND A.ITEM_ID = B.ITEM_ID		
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M D
					 	ON 	 1=1
						AND  D.MAX_VER_FLAG = 'Y'
						AND  D.VERSION_TYPE = 'MASS'
						AND  A.EPOST_COMPANY_ID = D.COMPANY_ID
						AND  A.EPOST_DIVISION_ID = D.DIVISION_ID
						AND  A.EPOST_SITE_ID = D.SITE_ID
						AND  A.EPOST_FACTORY_ID = D.FACTORY_ID
						AND  B.APPLIED_MODEL = D.MODEL_ID
						AND  B.ITEM_ID = D.ITEM_ID
						AND  D.OPERATION = 'E2000' 
						AND  D.CATEGORY = 'Jumbo Roll (cell/m)'				
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M E
					 	ON 	 1=1
						AND  E.MAX_VER_FLAG = 'Y'
						AND  E.VERSION_TYPE = 'MASS'
						AND  A.EPOST_COMPANY_ID = E.COMPANY_ID
						AND  A.EPOST_DIVISION_ID = E.DIVISION_ID
						AND  A.EPOST_SITE_ID = E.SITE_ID
						AND  A.EPOST_FACTORY_ID = E.FACTORY_ID
						AND  B.APPLIED_MODEL = E.MODEL_ID
						AND  B.ITEM_ID = E.ITEM_ID
						AND  E.OPERATION = 'E2000' 
						AND  E.CATEGORY = 'Lane Number'			
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M F
					 	ON 	 1=1
						AND  F.MAX_VER_FLAG = 'Y'
						AND  F.VERSION_TYPE = 'TEST'
						AND  A.EPOST_COMPANY_ID = F.COMPANY_ID
						AND  A.EPOST_DIVISION_ID = F.DIVISION_ID
						AND  A.EPOST_SITE_ID = F.SITE_ID
						AND  A.EPOST_FACTORY_ID = F.FACTORY_ID
						AND  B.APPLIED_MODEL = F.MODEL_ID
						AND  B.ITEM_ID = F.ITEM_ID
						AND  F.OPERATION = 'E2000' 
						AND  F.CATEGORY = 'Jumbo Roll (cell/m)'				
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M G
					 	ON 	 1=1
						AND  G.MAX_VER_FLAG = 'Y'
						AND  G.VERSION_TYPE = 'TEST'
						AND  A.EPOST_COMPANY_ID = G.COMPANY_ID
						AND  A.EPOST_DIVISION_ID = G.DIVISION_ID
						AND  A.EPOST_SITE_ID = G.SITE_ID
						AND  A.EPOST_FACTORY_ID = G.FACTORY_ID
						AND  B.APPLIED_MODEL = G.MODEL_ID
						AND  B.ITEM_ID = G.ITEM_ID
						AND  G.OPERATION = 'E2000' 
						AND  G.CATEGORY = 'Lane Number'							
		WHERE   A.INSTANCE_ID =   @V_MASTER_ID
		AND 	A.FP_PLAN_ID  =   @V_PLAN_ID 
		GROUP BY A.INSTANCE_ID 
			   , A.FP_PLAN_ID 
			   , A.EPOST_COMPANY_ID 
			   , A.EPOST_DIVISION_ID 
			   , A.EPOST_SITE_ID 
			   , A.EPOST_PLANT_ID 
			   , A.EPOST_FACTORY_ID 
			   , A.ITEM_ID 
			   , A.ITEM_PLAN_DATE
			   , E.VALUE 
			   , D.VALUE
			   , F.VALUE
			   , G.VALUE
		; 

		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = '31-ROLL PRESS PLAN'
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;


		---- 41-Coating Plan ----

		INSERT INTO  FP_ELECTRODE_POST_PLAN_H  (
			INSTANCE_ID ,
			FP_PLAN_ID  ,
			COMPANY_ID ,
			DIVISION_ID ,
			SITE_ID ,
			PLANT_ID,
			FACTORY_ID,
			ITEM_ID,
			NP_ITEM_ID,
			CATEGORY,
			PLAN_DATE, 
			BOH ,
			BOH_PC ,
			BOH_JR ,
			BOH_CELL ,
			IN_QTY , 
			OUT_QTY ,
			IN_PC_QTY ,
			OUT_PC_QTY ,
			IN_JR_QTY ,
			OUT_JR_QTY ,
			IN_CELL_QTY ,
			OUT_CELL_QTY ,
			INSERT_ID , 
			INSERT_TIME, 
			UPDATE_ID, 
			UPDATE_TIME
		) 
		SELECT  A.INSTANCE_ID 
			   , A.FP_PLAN_ID 
			   , A.COMPANY_ID 
			   , A.DIVISION_ID 
			   , A.SITE_ID 
			   , A.PLANT_ID 
			   , A.FACTORY_ID 
			   , A.ITEM_ID 
			   , '-' AS NP_ITEM_ID 
			   , '41-Coating Plan'  AS CATEGORY
			   , A.ITEM_PLAN_DATE   AS PLAN_DATE			   
			   , A.STOCK_QTY        AS BOH
			   , A.STOCK_QTY        AS BOH_PC
			   , A.STOCK_QTY / ISNULL(E.VALUE, G.VALUE)       AS BOH_JR
			   , A.STOCK_QTY / ISNULL(E.VALUE, G.VALUE) * ISNULL(D.VALUE, F.VALUE)        AS BOH_CELL
			   , A.E2000_IN_QTY     AS IN_QTY 
			   , A.E2000_OUT_QTY    AS OUT_QTY
			   , A.E2000_IN_QTY     AS IN_PC_QTY
			   , A.E2000_OUT_QTY    AS OUT_PC_QTY
			   , A.E2000_IN_QTY / ISNULL(E.VALUE, G.VALUE)    AS IN_JR_QTY
			   , A.E2000_OUT_QTY / ISNULL(E.VALUE, G.VALUE)    AS OUT_JR_QTY
			   , A.E2000_IN_QTY / ISNULL(E.VALUE, G.VALUE) * ISNULL(D.VALUE, F.VALUE)    AS IN_CELL_QTY
			   , A.E2000_OUT_QTY / ISNULL(E.VALUE, G.VALUE) * ISNULL(D.VALUE, F.VALUE)    AS OUT_CELL_QTY	
			  , @v_proc_name  AS INSERT_ID
			  , GETDATE()     AS INSERT_TIME 
			  , @v_proc_name  AS UPDATE_ID
			  , GETDATE()     AS UPDATE_TIME
		FROM    TH_BUF_EPOST_COATER_PLAN A 
				LEFT OUTER JOIN SCM_ITEM_M B
					  	ON 	1=1
					  	AND B.ACTIVE_FLAG = 'Y'
					  	AND A.COMPANY_ID = B.COMPANY_ID 
				      	AND A.DIVISION_ID = B.DIVISION_ID
				      	AND A.SITE_ID = B.SITE_ID
				      	AND A.ITEM_ID = B.ITEM_ID		
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M D
					 	ON 	 1=1
						AND  D.MAX_VER_FLAG = 'Y'
						AND  A.COMPANY_ID = D.COMPANY_ID
						AND  A.DIVISION_ID = D.DIVISION_ID
						AND  A.SITE_ID = D.SITE_ID
						AND  A.FACTORY_ID = D.FACTORY_ID
						AND  B.APPLIED_MODEL = D.MODEL_ID
						AND  B.ITEM_ID = D.ITEM_ID
						AND  D.OPERATION = 'E2000' 
						AND  D.CATEGORY = 'Jumbo Roll (cell/m)'		
						AND  D.VERSION_TYPE = 'MASS'
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M E
					 	ON 	 1=1
						AND  E.MAX_VER_FLAG = 'Y'
						AND  A.COMPANY_ID = E.COMPANY_ID
						AND  A.DIVISION_ID = E.DIVISION_ID
						AND  A.SITE_ID = E.SITE_ID
						AND  A.FACTORY_ID = E.FACTORY_ID
						AND  B.APPLIED_MODEL = E.MODEL_ID
						AND  B.ITEM_ID = E.ITEM_ID
						AND  E.OPERATION = 'E2000' 
						AND  E.CATEGORY = 'Lane Number'	
						AND  E.VERSION_TYPE = 'MASS'
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M F
					 	ON 	 1=1
						AND  F.MAX_VER_FLAG = 'Y'
						AND  A.COMPANY_ID = F.COMPANY_ID
						AND  A.DIVISION_ID = F.DIVISION_ID
						AND  A.SITE_ID = F.SITE_ID
						AND  A.FACTORY_ID = F.FACTORY_ID
						AND  B.APPLIED_MODEL = F.MODEL_ID
						AND  B.ITEM_ID = F.ITEM_ID
						AND  F.OPERATION = 'E2000' 
						AND  F.CATEGORY = 'Jumbo Roll (cell/m)'		
						AND  F.VERSION_TYPE = 'TEST'
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M G
					 	ON 	 1=1
						AND  G.MAX_VER_FLAG = 'Y'
						AND  A.COMPANY_ID = G.COMPANY_ID
						AND  A.DIVISION_ID = G.DIVISION_ID
						AND  A.SITE_ID = G.SITE_ID
						AND  A.FACTORY_ID = G.FACTORY_ID
						AND  B.APPLIED_MODEL = G.MODEL_ID
						AND  B.ITEM_ID = G.ITEM_ID
						AND  G.OPERATION = 'E2000' 
						AND  G.CATEGORY = 'Lane Number'		
						AND  G.VERSION_TYPE = 'TEST'
		WHERE   A.INSTANCE_ID =  @V_MASTER_ID
		AND 	A.FP_PLAN_ID  =  @V_PLAN_ID 
		; 
	
			--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = '41-COATING PLAN'
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;
	   

		---- DELETE EXCEPT PANCAKE ----

		DELETE 	A
		FROM 	FP_ELECTRODE_POST_PLAN_H A,
				SCM_SYS_LOOKUP_VALUE B
		WHERE 	1=1
		AND     A.INSTANCE_ID =  @V_MASTER_ID
		AND 	A.FP_PLAN_ID = @V_PLAN_ID
		AND 	B.LOOKUP_TYPE_CODE = 'E_POST_EXCEPT_PANCAKE'
		AND 	A.INSTANCE_ID = B.SEGMENT1
		AND 	A.ITEM_ID = B.SEGMENT2
		AND 	B.ACTIVE_FLAG = 'Y'
		; 
	
			--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = 'DELETE EXCEPT PANCAKE'
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
	    ;
	   

        ------------------------------------------ 
		--  HOLD STOCK UPDATE (20190829)
		------------------------------------------
		
		  ---- 21-Slitting Plan : E4000 ----
		UPDATE  A
		SET	  A.HOLD      = ISNULL(z.HOLD,0)
			, A.HOLD_PC = ISNULL(z.HOLD_PC,0)
			, A.HOLD_JR   = ISNULL(z.HOLD_JR ,0)
			, A.HOLD_CELL = ISNULL(z.HOLD_CELL,0)
		FROM  FP_ELECTRODE_POST_PLAN_H A
			, (	
				SELECT  A.INSTANCE_ID , A.FP_PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID , A.ITEM_ID, B.STOCK_QTY , C.APPLIED_MODEL
							   , MAX(B.STOCK_QTY)        AS HOLD
							   , MAX(B.STOCK_QTY)        AS HOLD_PC
							   , MAX(B.STOCK_QTY) / ISNULL(E.VALUE, G.VALUE)       AS HOLD_JR
							   , MAX(B.STOCK_QTY) / ISNULL(E.VALUE, G.VALUE) * ISNULL(D.VALUE, F.VALUE)        AS HOLD_CELL	 
				FROM    FP_ELECTRODE_POST_PLAN_H  A
				LEFT OUTER JOIN (
						SELECT * FROM TH_BUF_EPOST_STOCK_HOLD 
						WHERE  FP_PLAN_ID    = @V_PLAN_ID
						AND    INSTANCE_ID   = @V_MASTER_ID
						AND   FP_APPLY_OPERATION_ID = 'E4000' 
						) B
						on   A.INSTANCE_ID =  B.INSTANCE_ID
						AND  A.FP_PLAN_ID  =  B.FP_PLAN_ID
						AND  A.ITEM_ID     =  B.FP_APPLY_ITEM_ID
						AND  A.COMPANY_ID  =  B.COMPANY_ID
						AND  A.DIVISION_ID =  B.DIVISION_ID 
						AND  A.SITE_ID     =  B.SITE_ID
						AND  A.PLANT_ID    =  B.PLANT_ID
						AND  A.FACTORY_ID  =  B.FACTORY_ID
				LEFT OUTER JOIN SCM_ITEM_M   C
						ON 	1=1
						AND C.ACTIVE_FLAG = 'Y'
						AND A.COMPANY_ID =  C.COMPANY_ID 
						AND A.DIVISION_ID = C.DIVISION_ID
						AND A.SITE_ID = C.SITE_ID
						AND A.ITEM_ID = C.ITEM_ID
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M D
						ON 	 1=1
						AND  D.MAX_VER_FLAG = 'Y'
						AND  D.VERSION_TYPE = 'MASS'
						AND  A.COMPANY_ID = D.COMPANY_ID
						AND  A.DIVISION_ID = D.DIVISION_ID
						AND  A.SITE_ID = D.SITE_ID
						AND  A.FACTORY_ID = D.FACTORY_ID
						AND  C.APPLIED_MODEL = D.MODEL_ID
						AND  C.ITEM_ID = D.ITEM_ID
						AND  D.OPERATION = 'E2000' 
						AND  D.CATEGORY = 'Jumbo Roll (cell/m)'	
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M E
						ON 	 1=1
						AND  E.MAX_VER_FLAG = 'Y'
						AND  E.VERSION_TYPE = 'MASS'
						AND  A.COMPANY_ID = E.COMPANY_ID
						AND  A.DIVISION_ID = E.DIVISION_ID
						AND  A.SITE_ID = E.SITE_ID
						AND  A.FACTORY_ID = E.FACTORY_ID
						AND  C.APPLIED_MODEL = E.MODEL_ID
						AND  C.ITEM_ID = E.ITEM_ID
						AND  E.OPERATION = 'E2000' 
						AND  E.CATEGORY = 'Lane Number'
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M F
						ON 	 1=1
						AND  F.MAX_VER_FLAG = 'Y'
						AND  F.VERSION_TYPE = 'TEST'
						AND  A.COMPANY_ID = F.COMPANY_ID
						AND  A.DIVISION_ID = F.DIVISION_ID
						AND  A.SITE_ID = F.SITE_ID
						AND  A.FACTORY_ID = F.FACTORY_ID
						AND  C.APPLIED_MODEL = F.MODEL_ID
						AND  C.ITEM_ID = F.ITEM_ID
						AND  F.OPERATION = 'E2000' 
						AND  F.CATEGORY = 'Jumbo Roll (cell/m)'				
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M G
						ON 	 1=1
						AND  G.MAX_VER_FLAG = 'Y'
						AND  G.VERSION_TYPE = 'TEST'
						AND  A.COMPANY_ID = G.COMPANY_ID
						AND  A.DIVISION_ID = G.DIVISION_ID
						AND  A.SITE_ID = G.SITE_ID
						AND  A.FACTORY_ID = G.FACTORY_ID
						AND  C.APPLIED_MODEL = G.MODEL_ID
						AND  C.ITEM_ID = G.ITEM_ID
						AND  G.OPERATION = 'E2000' 
						AND  G.CATEGORY = 'Lane Number'				
				WHERE  A.INSTANCE_ID =  @V_MASTER_ID
				AND    A.FP_PLAN_ID  =  @V_PLAN_ID
				AND    A.CATEGORY    =  '21-Slitting Plan' 
				GROUP BY  A.INSTANCE_ID , A.FP_PLAN_ID , A.COMPANY_ID, a.DIVISION_ID,  A.SITE_ID, A.PLANT_ID, A.FACTORY_ID , A.ITEM_ID, B.STOCK_QTY , C.APPLIED_MODEL
						, E.VALUE , D.VALUE , F.VALUE , G.VALUE
				) Z
		where  1=1
		and  A.INSTANCE_ID =  z.INSTANCE_ID
		AND  A.FP_PLAN_ID  =  z.FP_PLAN_ID
		AND  A.ITEM_ID     =  z.ITEM_ID
		AND  A.COMPANY_ID  =  z.COMPANY_ID
		AND  A.DIVISION_ID =  z.DIVISION_ID 
		AND  A.SITE_ID     =  z.SITE_ID
		AND  A.PLANT_ID    =  z.PLANT_ID
		AND  A.FACTORY_ID  =  z.FACTORY_ID
		and  a.item_id     =  z.item_id
		AND  A.CATEGORY    =  '21-Slitting Plan' 
		; 

	    --LOG 생성
	    SET @v_message = @@ROWCOUNT
		SET @v_descr = 'HOLD STOCK: 21-Slitting Plan(E4000)' 
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr
	    ;


		  ---- 31-Roll Press Plan : E3000 HOLD ----
		UPDATE  A
		SET	  A.HOLD      = ISNULL(z.HOLD,0)
			, A.HOLD_PC   = ISNULL(z.HOLD_PC,0)
			, A.HOLD_JR   = ISNULL(z.HOLD_JR ,0)
			, A.HOLD_CELL = ISNULL(z.HOLD_CELL,0)
		FROM  FP_ELECTRODE_POST_PLAN_H A
			, (	
				SELECT  A.INSTANCE_ID , A.FP_PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID , A.ITEM_ID, B.STOCK_QTY , C.APPLIED_MODEL
							   , MAX(B.STOCK_QTY)        AS HOLD
							   , MAX(B.STOCK_QTY)        AS HOLD_PC
							   , MAX(B.STOCK_QTY) / ISNULL(E.VALUE, G.VALUE)       AS HOLD_JR
							   , MAX(B.STOCK_QTY) / ISNULL(E.VALUE, G.VALUE) * ISNULL(D.VALUE, F.VALUE)        AS HOLD_CELL	 

				FROM    FP_ELECTRODE_POST_PLAN_H  A
				LEFT OUTER JOIN (
						SELECT * FROM TH_BUF_EPOST_STOCK_HOLD 
						WHERE  FP_PLAN_ID    = @V_PLAN_ID
						AND    INSTANCE_ID   = @V_MASTER_ID
						AND   FP_APPLY_OPERATION_ID = 'E3000' 
						) B
						on   A.INSTANCE_ID =  B.INSTANCE_ID
						AND  A.FP_PLAN_ID  =  B.FP_PLAN_ID
						AND  A.ITEM_ID     =  B.FP_APPLY_ITEM_ID
						AND  A.COMPANY_ID  =  B.COMPANY_ID
						AND  A.DIVISION_ID =  B.DIVISION_ID 
						AND  A.SITE_ID     =  B.SITE_ID
						AND  A.PLANT_ID    =  B.PLANT_ID
						AND  A.FACTORY_ID  =  B.FACTORY_ID
				LEFT OUTER JOIN SCM_ITEM_M   C
						ON 	1=1
						AND C.ACTIVE_FLAG = 'Y'
						AND A.COMPANY_ID =  C.COMPANY_ID 
						AND A.DIVISION_ID = C.DIVISION_ID
						AND A.SITE_ID = C.SITE_ID
						AND A.ITEM_ID = C.ITEM_ID
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M D
						ON 	 1=1
						AND  D.MAX_VER_FLAG = 'Y'
						AND  D.VERSION_TYPE = 'MASS'
						AND  A.COMPANY_ID = D.COMPANY_ID
						AND  A.DIVISION_ID = D.DIVISION_ID
						AND  A.SITE_ID = D.SITE_ID
						AND  A.FACTORY_ID = D.FACTORY_ID
						AND  C.APPLIED_MODEL = D.MODEL_ID
						AND  C.ITEM_ID = D.ITEM_ID
						AND  D.OPERATION = 'E2000' 
						AND  D.CATEGORY = 'Jumbo Roll (cell/m)'	
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M E
						ON 	 1=1
						AND  E.MAX_VER_FLAG = 'Y'
						AND  E.VERSION_TYPE = 'MASS'
						AND  A.COMPANY_ID = E.COMPANY_ID
						AND  A.DIVISION_ID = E.DIVISION_ID
						AND  A.SITE_ID = E.SITE_ID
						AND  A.FACTORY_ID = E.FACTORY_ID
						AND  C.APPLIED_MODEL = E.MODEL_ID
						AND  C.ITEM_ID = E.ITEM_ID
						AND  E.OPERATION = 'E2000' 
						AND  E.CATEGORY = 'Lane Number'
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M F
						ON 	 1=1
						AND  F.MAX_VER_FLAG = 'Y'
						AND  F.VERSION_TYPE = 'TEST'
						AND  A.COMPANY_ID = F.COMPANY_ID
						AND  A.DIVISION_ID = F.DIVISION_ID
						AND  A.SITE_ID = F.SITE_ID
						AND  A.FACTORY_ID = F.FACTORY_ID
						AND  C.APPLIED_MODEL = F.MODEL_ID
						AND  C.ITEM_ID = F.ITEM_ID
						AND  F.OPERATION = 'E2000' 
						AND  F.CATEGORY = 'Jumbo Roll (cell/m)'				
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M G
						ON 	 1=1
						AND  G.MAX_VER_FLAG = 'Y'
						AND  G.VERSION_TYPE = 'TEST'
						AND  A.COMPANY_ID = G.COMPANY_ID
						AND  A.DIVISION_ID = G.DIVISION_ID
						AND  A.SITE_ID = G.SITE_ID
						AND  A.FACTORY_ID = G.FACTORY_ID
						AND  C.APPLIED_MODEL = G.MODEL_ID
						AND  C.ITEM_ID = G.ITEM_ID
						AND  G.OPERATION = 'E2000' 
						AND  G.CATEGORY = 'Lane Number'				
				WHERE  A.INSTANCE_ID =  @V_MASTER_ID
				AND    A.FP_PLAN_ID  =  @V_PLAN_ID
				AND    A.CATEGORY    =  '31-Roll Press Plan' 
				GROUP BY  A.INSTANCE_ID , A.FP_PLAN_ID , A.COMPANY_ID, a.DIVISION_ID,  A.SITE_ID, A.PLANT_ID, A.FACTORY_ID , A.ITEM_ID, B.STOCK_QTY , C.APPLIED_MODEL
						, E.VALUE , D.VALUE , F.VALUE , G.VALUE
				) Z
		where  1=1
		and  A.INSTANCE_ID =  z.INSTANCE_ID
		AND  A.FP_PLAN_ID  =  z.FP_PLAN_ID
		AND  A.ITEM_ID     =  z.ITEM_ID
		AND  A.COMPANY_ID  =  z.COMPANY_ID
		AND  A.DIVISION_ID =  z.DIVISION_ID 
		AND  A.SITE_ID     =  z.SITE_ID
		AND  A.PLANT_ID    =  z.PLANT_ID
		AND  A.FACTORY_ID  =  z.FACTORY_ID
		and  a.item_id     =  z.item_id
		AND  A.CATEGORY    =  '31-Roll Press Plan' 
		; 

	    --LOG 생성
	    SET @v_message = @@ROWCOUNT
		SET @v_descr = 'HOLD STOCK: 31-Roll Press Plan (E3000)' 
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr
	    ;


		  ---- 41-Coating Plan: E2000 HOLD ----
		UPDATE  A
		SET	  A.HOLD      = ISNULL(z.HOLD,0)
			, A.HOLD_PC   = ISNULL(z.HOLD_PC,0)
			, A.HOLD_JR   = ISNULL(z.HOLD_JR ,0)
			, A.HOLD_CELL = ISNULL(z.HOLD_CELL,0)
		FROM  FP_ELECTRODE_POST_PLAN_H A
			, (	
				SELECT  A.INSTANCE_ID , A.FP_PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID , A.ITEM_ID, B.STOCK_QTY , C.APPLIED_MODEL
							   , MAX(B.STOCK_QTY)        AS HOLD
							   , MAX(B.STOCK_QTY)        AS HOLD_PC
							   , MAX(B.STOCK_QTY) / ISNULL(E.VALUE, G.VALUE)       AS HOLD_JR
							   , MAX(B.STOCK_QTY) / ISNULL(E.VALUE, G.VALUE) * ISNULL(D.VALUE, F.VALUE)        AS HOLD_CELL	 

				FROM    FP_ELECTRODE_POST_PLAN_H  A
				LEFT OUTER JOIN (
						SELECT * FROM TH_BUF_EPOST_STOCK_HOLD 
						WHERE  FP_PLAN_ID    = @V_PLAN_ID
						AND    INSTANCE_ID   = @V_MASTER_ID
						AND   FP_APPLY_OPERATION_ID = 'E3000' 
						) B
						on   A.INSTANCE_ID =  B.INSTANCE_ID
						AND  A.FP_PLAN_ID  =  B.FP_PLAN_ID
						AND  A.ITEM_ID     =  B.FP_APPLY_ITEM_ID
						AND  A.COMPANY_ID  =  B.COMPANY_ID
						AND  A.DIVISION_ID =  B.DIVISION_ID 
						AND  A.SITE_ID     =  B.SITE_ID
						AND  A.PLANT_ID    =  B.PLANT_ID
						AND  A.FACTORY_ID  =  B.FACTORY_ID
				LEFT OUTER JOIN SCM_ITEM_M   C
						ON 	1=1
						AND C.ACTIVE_FLAG = 'Y'
						AND A.COMPANY_ID =  C.COMPANY_ID 
						AND A.DIVISION_ID = C.DIVISION_ID
						AND A.SITE_ID = C.SITE_ID
						AND A.ITEM_ID = C.ITEM_ID
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M D
						ON 	 1=1
						AND  D.MAX_VER_FLAG = 'Y'
						AND  D.VERSION_TYPE = 'MASS'
						AND  A.COMPANY_ID = D.COMPANY_ID
						AND  A.DIVISION_ID = D.DIVISION_ID
						AND  A.SITE_ID = D.SITE_ID
						AND  A.FACTORY_ID = D.FACTORY_ID
						AND  C.APPLIED_MODEL = D.MODEL_ID
						AND  C.ITEM_ID = D.ITEM_ID
						AND  D.OPERATION = 'E2000' 
						AND  D.CATEGORY = 'Jumbo Roll (cell/m)'	
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M E
						ON 	 1=1
						AND  E.MAX_VER_FLAG = 'Y'
						AND  E.VERSION_TYPE = 'MASS'
						AND  A.COMPANY_ID = E.COMPANY_ID
						AND  A.DIVISION_ID = E.DIVISION_ID
						AND  A.SITE_ID = E.SITE_ID
						AND  A.FACTORY_ID = E.FACTORY_ID
						AND  C.APPLIED_MODEL = E.MODEL_ID
						AND  C.ITEM_ID = E.ITEM_ID
						AND  E.OPERATION = 'E2000' 
						AND  E.CATEGORY = 'Lane Number'
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M F
						ON 	 1=1
						AND  F.MAX_VER_FLAG = 'Y'
						AND  F.VERSION_TYPE = 'TEST'
						AND  A.COMPANY_ID = F.COMPANY_ID
						AND  A.DIVISION_ID = F.DIVISION_ID
						AND  A.SITE_ID = F.SITE_ID
						AND  A.FACTORY_ID = F.FACTORY_ID
						AND  C.APPLIED_MODEL = F.MODEL_ID
						AND  C.ITEM_ID = F.ITEM_ID
						AND  F.OPERATION = 'E2000' 
						AND  F.CATEGORY = 'Jumbo Roll (cell/m)'				
				LEFT OUTER JOIN   SCM_ITEM_CONV_CALC_M G
						ON 	 1=1
						AND  G.MAX_VER_FLAG = 'Y'
						AND  G.VERSION_TYPE = 'TEST'
						AND  A.COMPANY_ID = G.COMPANY_ID
						AND  A.DIVISION_ID = G.DIVISION_ID
						AND  A.SITE_ID = G.SITE_ID
						AND  A.FACTORY_ID = G.FACTORY_ID
						AND  C.APPLIED_MODEL = G.MODEL_ID
						AND  C.ITEM_ID = G.ITEM_ID
						AND  G.OPERATION = 'E2000' 
						AND  G.CATEGORY = 'Lane Number'				
				WHERE  A.INSTANCE_ID =  @V_MASTER_ID
				AND    A.FP_PLAN_ID  =  @V_PLAN_ID
				AND    A.CATEGORY    =  '41-Coating Plan' 
				GROUP BY  A.INSTANCE_ID , A.FP_PLAN_ID , A.COMPANY_ID, a.DIVISION_ID,  A.SITE_ID, A.PLANT_ID, A.FACTORY_ID , A.ITEM_ID, B.STOCK_QTY , C.APPLIED_MODEL
						, E.VALUE , D.VALUE , F.VALUE , G.VALUE
				) Z
		where  1=1
		and  A.INSTANCE_ID =  z.INSTANCE_ID
		AND  A.FP_PLAN_ID  =  z.FP_PLAN_ID
		AND  A.ITEM_ID     =  z.ITEM_ID
		AND  A.COMPANY_ID  =  z.COMPANY_ID
		AND  A.DIVISION_ID =  z.DIVISION_ID 
		AND  A.SITE_ID     =  z.SITE_ID
		AND  A.PLANT_ID    =  z.PLANT_ID
		AND  A.FACTORY_ID  =  z.FACTORY_ID
		and  a.item_id     =  z.item_id
		AND  A.CATEGORY    =  '41-Coating Plan' 
		; 

	    --LOG 생성
	    SET @v_message = @@ROWCOUNT
		SET @v_descr = 'HOLD STOCK: 41-Coating Plan(E2000)' 
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr
	    ;


		END  --9
		

		BEGIN --10
		--=========================================================
		-- 7-1. RELEASE TABLE에 밀어넣기.
		--=========================================================

		SET      @v_table_name = 'FP_DAILY_PRODUCTION_PLAN_R'		
		
		---- E4000 SLITTING Plan ----


		INSERT INTO  FP_DAILY_PRODUCTION_PLAN_R  (
			 		  INSTANCE_ID	
					, FP_PLAN_ID	
					, COMPANY_ID	
					, DIVISION_ID	
					, SITE_ID	
					, PLANT_ID	
					, FACTORY_ID	
					, WORK_ORDER_SPL_ID
					, WORK_ORDER_ID	
					, ORG_DEMAND_ID	
					, DEMAND_ID	
					, ITEM_ID	
					, TOP_ITEM_ID	
					, OPERATION_ID	
					, LINE_ID	
					, ELECTRODE_TYPE	
					, EQUIPMENT_ID	
					, PLAN_DATE	
					, START_TIME	
					, END_TIME	
					, PLAN_QTY	
					, PLAN_IN_QTY	
					, PLAN_LATE_QTY	
					, ITEM_UOM	
					, ROLL_IN_QTY	
					, ROLL_OUT_QTY	
					, ROLL_LATE_QTY	
					, JR_IN_QTY	
					, JR_OUT_QTY	
					, JR_LATE_QTY	
					, CELL_IN_QTY	
					, CELL_OUT_QTY	
					, BATCH_IN_QTY	
					, BATCH_OUT_QTY	
					, BATCH_LATE_QTY	
					, FIX_TYPE	
					, PRODUCTION_TYPE	
					, TOTAL_WORKING_TIME	
					, LINE_ITEM_SEQ	
					, OPERATION_ITEM_SEQ	
					, LANE_QTY	
					, LANE_TACT_QTY	
					, BATCH_ORDER_ID	
					, BIN_ORDER_ID	
					, MFG_WEEK	
					, DEMAND_DIVISION_ID	
					, MARKET	
					, FP_PRODUCTION_TYPE	
					, INSERT_ID	
					, INSERT_DTTM	
					, FULL_CLEANING_FLAG	
					, MODEL_TYPE_CHANGE_FLAG	
					, SEQ	
					, CELL_MATERIAL_ID	
					, CALC_TYPE	
					, CALC_VERSION	
					, TOTAL_BATCH	
					, PIG_CLEANING_FLAG	
					, SETUP_COLOR_CODE
		) 
		SELECT         A.INSTANCE_ID     
		             , A.FP_PLAN_ID      
		             , A.COMPANY_ID      
		             , A.DIVISION_ID     
		             , A.SITE_ID  
		             , A.PLANT_ID 
		             , A.FACTORY_ID      
		             , A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.ITEM_ID + '^' + C.LINE_ID + '^E4000^' + ISNULL(D.PRODUCTION_TYPE, 'MASS') + '^D' AS WORK_ORDER_SPL_ID
		             , A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.ITEM_ID + '^' + C.LINE_ID + '^E4000^' + ISNULL(D.PRODUCTION_TYPE, 'MASS') + '^D' AS WORK_ORDER_ID         
		             , A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.ITEM_ID + '^' + C.LINE_ID + '^E4000^' + ISNULL(D.PRODUCTION_TYPE, 'MASS') + '^D' AS ORG_DEMAND_ID   
		             , A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.ITEM_ID + '^' + C.LINE_ID + '^E4000^' + ISNULL(D.PRODUCTION_TYPE, 'MASS') + '^D' AS DEMAND_ID       
		             , A.ITEM_ID  
		             , A.ITEM_ID AS TOP_ITEM_ID 
		             , 'E4000' AS OPERATION_ID 
		             , C.LINE_ID  
		             , C.ELECTRODE_TYPE
		             , C.EQUIPMENT_ID    
		             , A.PLAN_DATE 
		             , DATEADD(MINUTE, DATEDIFF(MINUTE,CONVERT(DATE,F.PLAN_START_TIME), F.PLAN_START_TIME) , A.PLAN_DATE  ) AS START_TIME
		             , DATEADD(DAY,1,DATEADD(MINUTE, DATEDIFF(MINUTE,CONVERT(DATE,F.PLAN_START_TIME), F.PLAN_START_TIME) , A.PLAN_DATE  )) AS END_TIME
		             , A.OUT_QTY AS PLAN_QTY   
		             , A.IN_QTY AS PLAN_IN_QTY 
		             , 0 AS PLAN_LATE_QTY       
		             , B.ITEM_UOM 
		             , A.IN_PC_QTY AS ROLL_IN_QTY     
		             , A.OUT_PC_QTY AS ROLL_OUT_QTY   
		             , 0 AS ROLL_LATE_QTY       
		             , A.IN_JR_QTY AS JR_IN_QTY 
		             , A.OUT_JR_QTY AS JR_OUT_QTY     
		             , 0 AS JR_LATE_QTY  
		             , A.IN_CELL_QTY AS CELL_IN_QTY   
		             , A.OUT_CELL_QTY AS CELL_OUT_QTY 
		             , NULL AS BATCH_IN_QTY     
		             , NULL AS BATCH_OUT_QTY   
		             , NULL AS BATCH_LATE_QTY  
		             , NULL AS FIX_TYPE  
		             , ISNULL(D.PRODUCTION_TYPE, 'MASS') AS PRODUCTION_TYPE      
		             , '86400' AS TOTAL_WORKING_TIME  
		             , 1 AS LINE_ITEM_SEQ       
		             , 1 AS OPERATION_ITEM_SEQ 
		             , NULL AS LANE_QTY  
		             , NULL AS LANE_TACT_QTY   
		             , NULL AS BATCH_ORDER_ID  
		             , NULL AS BIN_ORDER_ID     
		             , E.WEEK AS MFG_WEEK       
		             , A.DIVISION_ID AS DEMAND_DIVISION_ID   
		             , 'D' AS MARKET     
		             , ISNULL(D.PRODUCTION_TYPE, 'MASS') AS FP_PRODUCTION_TYPE   
		             , @v_proc_name AS INSERT_ID      
		             , GETDATE() AS INSERT_DTTM 
		             , NULL AS FULL_CLEANING_FLAG     
		             , NULL AS MODEL_TYPE_CHANGE_FLAG 
		             , 1 AS SEQ   
		             , NULL AS CELL_MATERIAL_ID 
		             , NULL AS CALC_TYPE 
		             , NULL AS CALC_VERSION     
		             , NULL AS TOTAL_BATCH      
		             , NULL AS PIG_CLEANING_FLAG      
		             , NULL AS SETUP_COLOR_CODE    
		FROM   FP_ELECTRODE_POST_PLAN_H a
		             LEFT OUTER JOIN SCM_ITEM_M B
		                    ON     1=1
		                    AND    A.SITE_ID = B.SITE_ID
		                    AND    A.DIVISION_ID = B.DIVISION_ID
		                    AND    A.COMPANY_ID = B.COMPANY_ID
		                    AND    A.ITEM_ID = B.ITEM_ID
		                    AND    B.ACTIVE_FLAG = 'Y' 
		             LEFT OUTER JOIN (SELECT    B.INSTANCE_ID, A.SITE_ID, A.DIVISION_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, MIN(EQUIPMENT_ID) AS EQUIPMENT_ID
		                                        FROM dbo.SCM_EQUIPMENT_M A,
		                                                     (
		                                                     SELECT       INSTANCE_ID, SITE_ID, DIVISION_ID, FACTORY_ID, OPERATION_ID, ELECTRODE_TYPE, MIN(LINE_ID) AS LINE_ID
		                                                     FROM   dbo.FP_INSTANCE_LINE_V
		                                                     WHERE 1=1
		                                                     AND    INSTANCE_ID = @V_MASTER_ID
		                                                     AND    OPERATION_ID = 'E4000'
		                                                     GROUP BY INSTANCE_ID, SITE_ID, DIVISION_ID, FACTORY_ID, OPERATION_ID, ELECTRODE_TYPE
		                                                     ) B
		                                        WHERE        1=1
		                                        AND   A.SITE_ID = B.SITE_ID
		                                        AND   A.DIVISION_ID = B.DIVISION_ID
		                                        AND   A.FACTORY_ID = B.FACTORY_ID
		                                        AND   A.OPERATION_ID = B.OPERATION_ID
		                                        AND   A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
		                                        AND   A.LINE_ID = B.LINE_ID
		                                        GROUP BY B.INSTANCE_ID, A.SITE_ID, A.DIVISION_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE) C
		                    ON            1=1
		                    AND    A.INSTANCE_ID = C.INSTANCE_ID
		                    AND    A.SITE_ID = C.SITE_ID
		                    AND    A.DIVISION_ID = C.DIVISION_ID
		                    AND    A.FACTORY_ID = C.FACTORY_ID
		                    AND    C.ELECTRODE_TYPE = CASE WHEN B.ITEM_CLASS IN ('ES0301') THEN 'Anode'
		                                                   WHEN B.ITEM_CLASS IN ('ES0302', 'ES0303') THEN 'Cathode' END
		             LEFT OUTER JOIN FP_PLM_PJT_MODEL_MASTER D
		                    ON            1=1
		                    AND    A.DIVISION_ID = D.DIVISION_ID
		                    AND    B.APPLIED_MODEL = D.MODEL_ID
		             LEFT OUTER JOIN SCM_FP_PLAN_H F
		               ON   A.INSTANCE_ID =  F.INSTANCE_ID
		               AND  A.FP_PLAN_ID = F.PLAN_ID ,
		             SCM_SYS_CALENDAR_M E
		WHERE 1=1
		AND    A.INSTANCE_ID = @V_MASTER_ID
		AND    A.FP_PLAN_ID = @V_PLAN_ID
		AND    A.CATEGORY = '21-Slitting Plan'
		AND    A.SITE_ID = B.SITE_ID
		AND    A.DIVISION_ID = B.DIVISION_ID
		AND    A.COMPANY_ID = B.COMPANY_ID
		AND    A.ITEM_ID = B.ITEM_ID
		AND    B.ACTIVE_FLAG = 'Y'
		AND    A.PLAN_DATE = E.DATE_ID
		; 
	
			--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = 'E4000 PLAN INSERT'
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;	   
	   
	   
	   ---- E3000 ROLL PRESS Plan ----
	   
	   INSERT INTO  FP_DAILY_PRODUCTION_PLAN_R  (
			 		  INSTANCE_ID	
					, FP_PLAN_ID	
					, COMPANY_ID	
					, DIVISION_ID	
					, SITE_ID	
					, PLANT_ID	
					, FACTORY_ID	
					, WORK_ORDER_SPL_ID
					, WORK_ORDER_ID	
					, ORG_DEMAND_ID	
					, DEMAND_ID	
					, ITEM_ID	
					, TOP_ITEM_ID	
					, OPERATION_ID	
					, LINE_ID	
					, ELECTRODE_TYPE	
					, EQUIPMENT_ID	
					, PLAN_DATE	
					, START_TIME	
					, END_TIME	
					, PLAN_QTY	
					, PLAN_IN_QTY	
					, PLAN_LATE_QTY	
					, ITEM_UOM	
					, ROLL_IN_QTY	
					, ROLL_OUT_QTY	
					, ROLL_LATE_QTY	
					, JR_IN_QTY	
					, JR_OUT_QTY	
					, JR_LATE_QTY	
					, CELL_IN_QTY	
					, CELL_OUT_QTY	
					, BATCH_IN_QTY	
					, BATCH_OUT_QTY	
					, BATCH_LATE_QTY	
					, FIX_TYPE	
					, PRODUCTION_TYPE	
					, TOTAL_WORKING_TIME	
					, LINE_ITEM_SEQ	
					, OPERATION_ITEM_SEQ	
					, LANE_QTY	
					, LANE_TACT_QTY	
					, BATCH_ORDER_ID	
					, BIN_ORDER_ID	
					, MFG_WEEK	
					, DEMAND_DIVISION_ID	
					, MARKET	
					, FP_PRODUCTION_TYPE	
					, INSERT_ID	
					, INSERT_DTTM	
					, FULL_CLEANING_FLAG	
					, MODEL_TYPE_CHANGE_FLAG	
					, SEQ	
					, CELL_MATERIAL_ID	
					, CALC_TYPE	
					, CALC_VERSION	
					, TOTAL_BATCH	
					, PIG_CLEANING_FLAG	
					, SETUP_COLOR_CODE
		) 
		SELECT         A.INSTANCE_ID     
		             , A.FP_PLAN_ID      
		             , A.COMPANY_ID      
		             , A.DIVISION_ID     
		             , A.SITE_ID  
		             , A.PLANT_ID 
		             , A.FACTORY_ID      
		             , A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.ITEM_ID + '^' + C.LINE_ID + '^E3000^' + ISNULL(D.PRODUCTION_TYPE, 'MASS') + '^D' AS WORK_ORDER_SPL_ID
		             , A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.ITEM_ID + '^' + C.LINE_ID + '^E3000^' + ISNULL(D.PRODUCTION_TYPE, 'MASS') + '^D' AS WORK_ORDER_ID         
		             , A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.ITEM_ID + '^' + C.LINE_ID + '^E3000^' + ISNULL(D.PRODUCTION_TYPE, 'MASS') + '^D' AS ORG_DEMAND_ID   
		             , A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.ITEM_ID + '^' + C.LINE_ID + '^E3000^' + ISNULL(D.PRODUCTION_TYPE, 'MASS') + '^D' AS DEMAND_ID       
		             , A.ITEM_ID  
		             , A.ITEM_ID AS TOP_ITEM_ID 
		             , 'E3000' AS OPERATION_ID 
		             , C.LINE_ID  
		             , C.ELECTRODE_TYPE
		             , C.EQUIPMENT_ID    
		             , A.PLAN_DATE 
		             , DATEADD(MINUTE, DATEDIFF(MINUTE,CONVERT(DATE,F.PLAN_START_TIME), F.PLAN_START_TIME) , A.PLAN_DATE  ) AS START_TIME
		             , DATEADD(DAY,1,DATEADD(MINUTE, DATEDIFF(MINUTE,CONVERT(DATE,F.PLAN_START_TIME), F.PLAN_START_TIME) , A.PLAN_DATE  )) AS END_TIME
		             , A.OUT_QTY AS PLAN_QTY   
		             , A.IN_QTY AS PLAN_IN_QTY 
		             , 0 AS PLAN_LATE_QTY       
		             , B.ITEM_UOM 
		             , A.IN_PC_QTY AS ROLL_IN_QTY     
		             , A.OUT_PC_QTY AS ROLL_OUT_QTY   
		             , 0 AS ROLL_LATE_QTY       
		             , A.IN_JR_QTY AS JR_IN_QTY 
		             , A.OUT_JR_QTY AS JR_OUT_QTY     
		             , 0 AS JR_LATE_QTY  
		             , A.IN_CELL_QTY AS CELL_IN_QTY   
		             , A.OUT_CELL_QTY AS CELL_OUT_QTY 
		             , NULL AS BATCH_IN_QTY     
		             , NULL AS BATCH_OUT_QTY   
		             , NULL AS BATCH_LATE_QTY  
		             , NULL AS FIX_TYPE  
		             , ISNULL(D.PRODUCTION_TYPE, 'MASS') AS PRODUCTION_TYPE      
		             , '86400' AS TOTAL_WORKING_TIME  
		             , 1 AS LINE_ITEM_SEQ       
		             , 1 AS OPERATION_ITEM_SEQ 
		             , NULL AS LANE_QTY  
		             , NULL AS LANE_TACT_QTY   
		             , NULL AS BATCH_ORDER_ID  
		             , NULL AS BIN_ORDER_ID     
		             , E.WEEK AS MFG_WEEK       
		             , A.DIVISION_ID AS DEMAND_DIVISION_ID   
		             , 'D' AS MARKET     
		             , ISNULL(D.PRODUCTION_TYPE, 'MASS') AS FP_PRODUCTION_TYPE   
		             , @v_proc_name AS INSERT_ID      
		             , GETDATE() AS INSERT_DTTM 
		             , NULL AS FULL_CLEANING_FLAG     
		             , NULL AS MODEL_TYPE_CHANGE_FLAG 
		             , 1 AS SEQ   
		             , NULL AS CELL_MATERIAL_ID 
		             , NULL AS CALC_TYPE 
		             , NULL AS CALC_VERSION     
		             , NULL AS TOTAL_BATCH      
		             , NULL AS PIG_CLEANING_FLAG      
		             , NULL AS SETUP_COLOR_CODE    
		FROM   FP_ELECTRODE_POST_PLAN_H a
		             LEFT OUTER JOIN SCM_ITEM_M B
		                    ON     1=1
		                    AND    A.SITE_ID = B.SITE_ID
		                    AND    A.DIVISION_ID = B.DIVISION_ID
		                    AND    A.COMPANY_ID = B.COMPANY_ID
		                    AND    A.ITEM_ID = B.ITEM_ID
		                    AND    B.ACTIVE_FLAG = 'Y' 
		             LEFT OUTER JOIN (SELECT    B.INSTANCE_ID, A.SITE_ID, A.DIVISION_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, MIN(EQUIPMENT_ID) AS EQUIPMENT_ID
		                                        FROM dbo.SCM_EQUIPMENT_M A,
		                                                     (
		                                                     SELECT       INSTANCE_ID, SITE_ID, DIVISION_ID, FACTORY_ID, OPERATION_ID, ELECTRODE_TYPE, MIN(LINE_ID) AS LINE_ID
		                                                     FROM   dbo.FP_INSTANCE_LINE_V
		                                                     WHERE 1=1
		                                                     AND    INSTANCE_ID = @V_MASTER_ID
		                                                     AND    OPERATION_ID = 'E3000'
		                                                     GROUP BY INSTANCE_ID, SITE_ID, DIVISION_ID, FACTORY_ID, OPERATION_ID, ELECTRODE_TYPE
		                                                     ) B
		                                        WHERE        1=1
		                                        AND   A.SITE_ID = B.SITE_ID
		                                        AND   A.DIVISION_ID = B.DIVISION_ID
		                                        AND   A.FACTORY_ID = B.FACTORY_ID
		                                        AND   A.OPERATION_ID = B.OPERATION_ID
		                                        AND   A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
		                                        AND   A.LINE_ID = B.LINE_ID
		                                        GROUP BY B.INSTANCE_ID, A.SITE_ID, A.DIVISION_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE) C
		                    ON            1=1
		                    AND    A.INSTANCE_ID = C.INSTANCE_ID
		                    AND    A.SITE_ID = C.SITE_ID
		                    AND    A.DIVISION_ID = C.DIVISION_ID
		                    AND    A.FACTORY_ID = C.FACTORY_ID
		                    AND    C.ELECTRODE_TYPE = CASE WHEN B.ITEM_CLASS IN ('ES0301') THEN 'Anode'
		                                                                         WHEN B.ITEM_CLASS IN ('ES0302', 'ES0303') THEN 'Cathode' END
		             LEFT OUTER JOIN FP_PLM_PJT_MODEL_MASTER D
		                    ON            1=1
		                    AND    A.DIVISION_ID = D.DIVISION_ID
		                    AND    B.APPLIED_MODEL = D.MODEL_ID
		             LEFT OUTER JOIN SCM_FP_PLAN_H F
		               ON   A.INSTANCE_ID =  F.INSTANCE_ID
		               AND  A.FP_PLAN_ID = F.PLAN_ID ,
		             SCM_SYS_CALENDAR_M E
		WHERE 1=1
		AND    A.INSTANCE_ID = @V_MASTER_ID
		AND    A.FP_PLAN_ID = @V_PLAN_ID
		AND    A.CATEGORY = '31-ROLL PRESS PLAN'
		AND    A.SITE_ID = B.SITE_ID
		AND    A.DIVISION_ID = B.DIVISION_ID
		AND    A.COMPANY_ID = B.COMPANY_ID
		AND    A.ITEM_ID = B.ITEM_ID
		AND    B.ACTIVE_FLAG = 'Y'
		AND    A.PLAN_DATE = E.DATE_ID
		; 
	
			--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = 'E3000 PLAN INSERT'
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;	   
	   
		END  --10
		
  --- 후미 --- 
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    SET @n_log_count = @n_log_count + 1
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', @n_log_count, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
