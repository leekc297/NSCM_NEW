CREATE PROCEDURE [dbo].[PR_SCM_OF_CELL_DELIVERY_PLAN]
  @p_master_id nvarchar(MAX) = '-' ,   -- Value : INSTANCE ID 
  @p_basis_plan_id nvarchar(50) = '-'  ,  --  복사 대상 PLAN_ID  / IS_USE ( Calculation 대상 품목 지정 plan_id ) Value : PlanID
  @p_create_planid nvarchar(10) = 'N'  ,  --  신규 Plan ID  Pack Release 시 해당 flag 로 plan id 생성   Value :  Y/N  
  @p_cal_option  nvarchar(50) = '-' , -- ALL or 특정 품목 선정 옵션 Value : ALL / - 
  @p_fix_date    date = '19000101',  -- fix date 일자 해당일자까지 Confirm 기준 고정 / amend 한 계획 품번은 check 하지 않고 수립해야함. Value : YYYYMMDD
  @p_copy_flag   nvarchar(10) = 'N'  ,  -- 버전업시 해당 flag 'Y'   Value : Y / N
  @p_user_id nvarchar(MAX) = 'PR_SCM_OF_CELL_DELIVERY_PLAN' , --  Value : USER ID 
  @p_target_date  date
  
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_CELL_DELIVERY_PLAN                                              **/
/** 프로그램 명   :                                                                           **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/**  [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2018.07.12    SHS          최초 작성                                                      **/
/** 2020.09.11    CYS          Hazel Park 계획 수립 후 요청계획의 확정계획의 Plant 를 Lookup 에 따라 맞춰준다. (D20200911~R0911.01)          **/
/**           						신규버전 PlanId 채번시 10 이상이면 오류가 나는 현상 수정          **/
/** 2020.09.24    CYS          DW 포장창고 재고를 SSP 로 변경함 (룩업으로 조정가능) (D20200923~R0924.01)          **/
/** 2021.04.27    CYS			활성화 Plan Group 적용 및 통합 인계요청 적용	(D.20210427~R.0427.01)			**/
/** 2023.06.14    LJS          활성화 분리 처리 **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_OF_CELL_DELIVERY_PLAN
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  DECLARE
    @v_proc_name        nvarchar(150) = 'PR_SCM_OF_CELL_DELIVERY_PLAN', 
    @v_table_name       nvarchar(150) = NULL, 
    @v_master_id        nvarchar(150) = @p_master_id ,
    @v_basis_plan_id    nvarchar(50)  = @p_basis_plan_id,
    @v_create_planid    nvarchar(50)  = @p_create_planid,
    @v_cal_option       nvarchar(50)  = @p_cal_option,
    @v_fix_date         nvarchar(150) = isnull(@p_fix_date , '19000101') ,
    @v_plan_id          nvarchar(150) = NULL ,
    @v_copy_flag        nvarchar(10)  = @p_copy_flag ,
    @v_pack_confirm_id  nvarchar(50) ,
    @v_seq              nvarchar(10) ,
    @v_target_date      date = @p_target_date
    
  DECLARE
    @n_count            Integer  = 0,
    @n_log_count        Integer  = 0,
    @sysdate            DATETIME2 = GETDATE(),
    @v_message          nvarchar(200),
    @v_description      nvarchar(200)

  DECLARE 
    @plan_start_time  datetime,
    @plan_end_time    datetime,
    @key_date         nvarchar(8),
    @v_plan_date      nvarchar(8),
    @v_plan_type      nvarchar(8)
    
  DECLARE
    @confirm_area     nvarchar(30) = 'BUILDING' ,
    @n_row_count      Integer  = 0 ,
    @v_cutoff_date    date
  
  DECLARE
 @offset$scp_target_id       nvarchar(150), 
    @offset$qty                 numeric(20,10),
    @offset$minus_qty           numeric(20,10),
    @offset$mfg_qty             numeric(20,10)  
  
  DECLARE
    @v_form_master_id            nvarchar(150),
    @v_form_master_id2           nvarchar(150),
    @v_pack_master_id             nvarchar(150)
    
  DECLARE 
    @v_offset_seq integer  ,
    @v_date       date = convert(date,getdate(),112)
    
  DECLARE 
    @v_confirm_id     nvarchar(20)  
  
  DECLARE @v_inhouse_cell_integ_ui nvarchar(20)	-- Add (D.20210427~R.0427.01)

  DECLARE @IS_CELL_ASSY NVARCHAR(MAX); -- 활성화 분리 적용 여부(Y : 적용, N : 비적용)
  
  BEGIN TRY
    --LOG 생성
    	-- ADD (D.20210427~R.0427.01)
  	-- 통합 인계요청 사용하는 인스턴스 제외 로직  
  	SELECT	@v_inhouse_cell_integ_ui = ISNULL(ACTIVE_FLAG,'N')
	FROM	SCM_SYS_LOOKUP_VALUE
	WHERE	1=1
	AND		LOOKUP_TYPE_CODE	= 'INHOUSE_CELL_INTEG_UI'
	AND		SEGMENT1 			=  @v_master_id
	AND		ACTIVE_FLAG 		= 'Y'
	
	SET @v_message = ' v_inhouse_cell_integ_ui : ' + ISNULL(@v_inhouse_cell_integ_ui,'-pass' )
    EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null 
  
	IF @v_inhouse_cell_integ_ui = 'Y'
	BEGIN 
		RETURN ;
	END
    
    IF @v_create_planid ='Y'  
    BEGIN
      SET @v_cal_option = 'ALL'
    END
      
    SET @n_log_count = @n_log_count + 1
    SET @sysdate = GETDATE()
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, @v_cal_option, 'START', @n_log_count, null, '############### Start of procedure ###############', null
    
    SET @v_message = 'instance_id : '+ @v_master_id  +' v_basis_plan_id : '+ @v_basis_plan_id + ' v_cal_option : ' + @p_cal_option + ' v_p_fix_date :' + CONVERT(nvarchar, isnull(@p_fix_date,'19890518'), 112)  + ' v_copy+flag : ' + @p_copy_flag
    EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null      

	-- 활성화 분리 flag
	SET @n_log_count = @n_log_count + 1
	SET @IS_CELL_ASSY = (
							SELECT (CASE WHEN MAX(B.SEGMENT1) IS NULL THEN 'N' ELSE 'Y' END) AS IS_CELL_ASSY
							FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)
							WHERE  B.ACTIVE_FLAG = 'Y'
							AND    B.LOOKUP_TYPE_CODE = 'CELL_PRODUCT_ASSY'
              --2023-07-25 FROM CELL_PRODUCT_ASSY 
							--AND    B.LOOKUP_TYPE_CODE = 'CELL_PRODUCT_ASSY'
							--AND    B.SEGMENT1 IN (
							--	SELECT MAX(SITE_ID)
							--	FROM   FP_INSTANCE_INFO_V V WITH(NOLOCK)
							--	WHERE  V.INSTANCE_ID = @v_master_id
							--) );
              -- TO CELL_PRODUCT_ASSY_INSTANCE
							AND    B.LOOKUP_TYPE_CODE = 'CELL_PRODUCT_ASSY_INSTANCE'
							AND    B.SEGMENT1 = @v_master_id
							);
	SET @v_message = '@IS_CELL_ASSY :: ' + @IS_CELL_ASSY
	EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null


    IF CHARINDEX('FORM', @v_master_id) > 0 
    BEGIN
    
      SET @v_table_name = 'TH_BUF_RELEASE_PLAN'
      
      DELETE TH_BUF_RELEASE_PLAN  WHERE INSTANCE_ID = @v_master_id
      
      -- Modify (D.20210427~R.0427.01) @@@ plan group type 대응
        /**
      INSERT INTO TH_BUF_RELEASE_PLAN
        (
          INSTANCE_ID , 
          FACTORY_ID,
          INSTANCE_DATE , 
          RELEASE_DATE , 
          RELEASE_PLAN_ID , 
          AMEND_PLAN_ID
        )
      SELECT  A.INSTANCE_ID , 
              A.FACTORY_ID ,
              A.INSTANCE_DATE , 
              A.RELEASE_DATE , 
              A.RELEASE_PLAN_ID , 
              A.AMEND_PLAN_ID
		FROM (
		  		SELECT  INSTANCE_ID , 
						INSTANCE_DATE , 
						DIVISION_ID , 
						FACTORY_ID ,
		  				MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE , DIVISION_ID , FACTORY_ID   ) AS RELEASE_PLAN_ID ,
						AMEND_PLAN_ID,
		  					CASE WHEN RELEASE_PLAN_ID = MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE , DIVISION_ID , FACTORY_ID   ) 
      		  						THEN 'Y'
      		  						ELSE 'N'
      		  			END AS CK_ID,			  
						A.SEQ ,
						CONVERT(DATE, A.INSTANCE_DATE) AS RELEASE_DATE    -- 2018.03.26 : RELEASE 일자 이후부터 타겟
				FROM   (
    					SELECT A.*
    						, DENSE_RANK() OVER (PARTITION BY FACTORY_ID
    											ORDER     BY INSTANCE_DATE DESC) AS SEQ
    					FROM   FP_RELEASE_PLAN_INFO_H  A
						WHERE  INSTANCE_ID = @v_master_id
						) A
  				WHERE  SEQ = 1  
			)A
      **/
      INSERT INTO TH_BUF_RELEASE_PLAN
				        (
				          INSTANCE_ID , 
				          FACTORY_ID,
				          INSTANCE_DATE , 
				          RELEASE_DATE , 
				          RELEASE_PLAN_ID , 
				          AMEND_PLAN_ID,
				          LINE_ID
				        )
      SELECT  DISTINCT  A.INSTANCE_ID , 
						A.FACTORY_ID ,
						A.INSTANCE_DATE , 
						A.RELEASE_DATE , 
						A.RELEASE_PLAN_ID , 
						A.AMEND_PLAN_ID , 
						A.LINE_ID 
		FROM (			
				SELECT  INSTANCE_ID , 
						INSTANCE_DATE , 
						FACTORY_ID ,
						LINE_ID , 
	  					MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE  , FACTORY_ID ,LINE_ID   ) AS RELEASE_PLAN_ID ,
						AMEND_PLAN_ID,
	  					CASE WHEN RELEASE_PLAN_ID = MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE  , FACTORY_ID , LINE_ID   ) 
    		  						THEN 'Y'
    		  						ELSE 'N'
    					END AS CK_ID,			  
						A.SEQ ,
						CONVERT(DATE, A.INSTANCE_DATE) AS RELEASE_DATE    -- 2018.03.26 : RELEASE 일자 이후부터 타겟
				FROM   (
						SELECT A.*
							, DENSE_RANK() OVER (PARTITION BY FACTORY_ID , LINE_ID 
												ORDER     BY INSTANCE_DATE DESC) AS SEQ
						FROM   FP_RELEASE_PLAN_LINE_INFO_H  A
						WHERE  INSTANCE_ID = @v_master_id
						) A
				WHERE  SEQ = 1  
			)A
		WHERE A.CK_ID = 'Y'  
      --LOG 생성
      SET @v_message = '@p_master_id : ' + CONVERT(nvarchar, @v_cutoff_date, 112) 
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null      
    
      --LOG 생성
      
      SET @v_table_name = 'TH_MST_PLAN'
      SELECT  @key_date = INSTANCE_DATE,
              @v_plan_date = INSTANCE_DATE,
              @v_cutoff_date  = RELEASE_DATE 
      FROM   (
              SELECT MAX(INSTANCE_DATE) AS INSTANCE_DATE,
                     MAX(RELEASE_DATE) AS RELEASE_DATE
              FROM   TH_BUF_RELEASE_PLAN 
              WHERE INSTANCE_ID = @v_master_id
              GROUP  BY INSTANCE_ID 
             ) A
             
             
      --LOG 생성
      SET @v_message = 'cutoff_date : ' + CONVERT(nvarchar, @v_cutoff_date, 112) 
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
             
             
      --LOG 생성
      SET @v_message = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
       
      SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'

      SELECT @confirm_area = ISNULL(MAX(B.ATTRIBUTE1), 'BUILDING')
      FROM   SCM_SYS_LOOKUP_TYPE_M A,
             SCM_SYS_LOOKUP_VALUE  B
      WHERE  A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE
      AND    A.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
      AND    B.SEGMENT1         = @v_master_id

      --LOG 생성
      SET @v_message = '@confirm_area : ' + @confirm_area
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      

      SELECT @v_form_master_id = CASE WHEN @v_master_id = 'KR_PACK'   THEN 'KR_FORM_A'
                                      WHEN @v_master_id = 'CN_PACK'   THEN 'CN_FORM_A'
                                      WHEN @v_master_id = 'PL_PACK'   THEN 'PL_FORM_A'
                                      WHEN @v_master_id = 'US_PACK'   THEN 'US_FORM_A'
                                      ELSE 'NA' END    
    
      --LOG 생성
      SET @v_message = '@v_form_master_id : ' + @v_form_master_id
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      SELECT @v_pack_master_id = CASE WHEN @v_master_id = 'KR_FORM_A'   THEN 'KR_PACK'
                                      WHEN @v_master_id = 'CN_FORM_A'   THEN 'CN_PACK'
                                      WHEN @v_master_id = 'PL_FORM_A'   THEN 'PL_PACK'
                                      WHEN @v_master_id = 'US_FORM_A'   THEN 'US_PACK'
                                      ELSE 'NA' END    
    
      --LOG 생성
      SET @v_message = '@v_pack_master_id : ' + @v_pack_master_id
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      SELECT @v_form_master_id2 = CASE WHEN @v_master_id = 'CN_PACK'   THEN 'CN_FORM_E'
                                        ELSE 'NA' END    
    
      --LOG 생성
      SET @v_message = '@v_form_master_id2 : ' + @v_form_master_id2
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      

      SELECT @v_pack_confirm_id = PLAN_ID
      FROM (
  	          SELECT INSTANCE_ID , PLAN_ID , RANK() OVER (ORDER BY UPDATE_TIME DESC) AS SEQ
  	          FROM    SCM_FP_IN_HOUSE_PLAN_H
  	      	  WHERE   INSTANCE_ID = @v_pack_master_id 
              AND     CONFIRM_FLAG = 'Y'
      				)A
      WHERE SEQ = 1	
      
      --LOG 생성
      SET @v_message = '@v_pack_confirm_id : ' + @v_pack_confirm_id
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      IF @v_target_date  IS NULL or @v_target_date ='' or @v_target_date = '19000101'
      BEGIN
      
        SET @v_target_date = @v_cutoff_date
        
        --LOG 생성
        SET @v_message = '@v_target_date : ' + CONVERT(nvarchar, @v_target_date, 112)  
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      END
   
      --LOG 생성
      SET @v_message = '@v_target_date : ' + CONVERT(nvarchar, @v_target_date, 112)  
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

        /*
          - 해당 TABLE은 특성 FP RELEASE 시에만 생성													
        	- 특성 계획(P) 기준으로 R값과 Soft Pegging 하여 DO값 산출													
        	- Pegging 시 ERP Sloc과 SOC 반영하여 산출													
        	- 산출 시 FIFO 적용하며 SOC는 동일 날짜에서 Air 우선 Pegging 후 Common Pegging → LOOKUP에 우선순위 정의													
        	- Market은 일단 예비용으로 Pegging에 반영 X													
        	- 산출 수량은 org_delivery_qty, delivery_qty 모두에 입력													
        														
        	* LINE별 STORAGE는 PACK 라인 기준													
													 
        */
    
      IF  @v_copy_flag = 'N'      
      BEGIN
      
        IF @v_create_planid = 'Y'
        BEGIN
          
          INSERT INTO SCM_FP_IN_HOUSE_PLAN_H
            (
              INSTANCE_ID ,
              PLAN_ID ,
              FIX_DATE ,
              CONFIRM_FLAG ,
             -- DESCRIPTION ,
              PLAN_DATE ,
              SEQ , 
              INSERT_ID , 
              INSERT_TIME ,
              UPDATE_ID ,
              UPDATE_TIME , 
              PACK_CONFIRM_ID
            )
          SELECT  @v_master_id  AS INSTANCE_ID , 
                  CONVERT(NVARCHAR,@v_cutoff_date,112) +'-'  + DBO.FN_LPAD_NVARCHAR( ISNULL(MAX(CONVERT(NUMERIC, SEQ)) + 1,1),2,0) AS PLAN_ID  , 		-- seq 가 숫자로 인식하도록 (D20200911~R0911.01)
                  @v_fix_date AS FIX_DATE , 
                  'N' AS CONFIRM_FLAG , 
        				  --@v_basis_plan_id AS DESCRIPTION , 
                  CONVERT(NVARCHAR,@v_cutoff_date,112) AS PLAN_DATE ,   
                  ISNULL(MAX(CONVERT(NUMERIC, SEQ)) + 1,1)  AS SEQ , 						-- seq 가 숫자로 인식하도록 (D20200911~R0911.01)
                  @p_user_id AS INSERT_ID , 
          				GETDATE() AS INSERT_TIME , 
                  @p_user_id AS UPDATE_ID , 
                  GETDATE() AS UPDATE_TIME , 
                  @v_pack_confirm_id
          FROM  SCM_FP_IN_HOUSE_PLAN_H
          WHERE   INSTANCE_ID = @v_master_id 
          AND     PLAN_DATE = CONVERT(NVARCHAR,@v_cutoff_date,112)  -- pack release 한 일자로 해당 id 생성.
          
          SELECT  @v_plan_id = MAX(PLAN_ID)
          FROM    SCM_FP_IN_HOUSE_PLAN_H
          WHERE   INSTANCE_ID = @v_master_id 
          AND     PLAN_DATE = CONVERT(NVARCHAR,@v_cutoff_date,112) 
        
        END
        ELSE 
        BEGIN

          SET @v_plan_id = @v_basis_plan_id
          
          UPDATE SCM_FP_IN_HOUSE_PLAN_H
          SET FIX_DATE = @v_fix_date , 
              UPDATE_ID = @p_user_id ,
              UPDATE_TIME = GETDATE()
          WHERE   INSTANCE_ID = @v_master_id 
          AND     PLAN_ID = @v_plan_id
          
          
        END
        
        BEGIN
    
          SELECT @v_confirm_id = PLAN_ID  
          FROM (
          			SELECT  INSTANCE_ID , PLAN_ID , rank() over ( partition by instance_id order by update_time  desc) as seq 
          			FROM SCM_FP_IN_HOUSE_PLAN_H
          			WHERE INSTANCE_ID = @v_master_id 
          			AND CONFIRM_FLAG ='Y'
          			)A
          WHERE SEQ = 1 
          
          --LOG 생성
          SET @v_message = '@v_confirm_id : ' + @v_confirm_id
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
          
          SET @v_message = '@v_fix_date : ' + @v_fix_date
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
          
        
        END
        
        IF @p_create_planid = 'N' -- 신규 data 생성 시 confirm 기준 pegging 하지 않음 . fix date 입력후 calculation 시 해당 로직 수행
        BEGIN
        
          SET @v_table_name = 'TH_BUF_FORM_PEGGING_PLAN_FIX'
          
          DELETE  TH_BUF_FORM_PEGGING_PLAN_FIX
           
          INSERT INTO TH_BUF_FORM_PEGGING_PLAN_FIX
            (
          		INSTANCE_ID ,
              COMPANY_ID ,
              DIVISION_ID ,
              SITE_ID ,
              PLANT_ID ,
              ITEM_ID ,
              STORAGE_ID ,
              SOC_ID ,
              MARKET ,
              DELIVERY_DATE ,
              DELIVERY_QTY ,
              PEGGING_QTY,
              REMAIN_QTY,
              MOQ
            )
          SELECT  INSTANCE_ID ,
		              COMPANY_ID ,
		              DIVISION_ID ,
		              SITE_ID ,
		              PLANT_ID ,
		              ITEM_ID ,
		              STORAGE_ID ,
		              SOC_ID ,
		              MARKET ,
		              DELIVERY_DATE ,
		              DELIVERY_QTY ,
		              0 as PEGGING_QTY,
		              0 as REMAIN_QTY,
		              MOQ
          FROM FP_CELL_DELIVERY_PLAN_FIX_H
          WHERE INSTANCE_ID = @v_master_id
    		  AND   PLAN_ID = @v_confirm_id
        	AND   DELIVERY_DATE >= @v_target_date
        	AND   DELIVERY_DATE <= @v_fix_date
          
          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

        END
      
        /*
         1. 특성 BOH Pegging
        */
        
        SET @v_table_name = 'TH_BUF_FORM_PEGGING_PLAN'
        
        DELETE TH_BUF_FORM_PEGGING_PLAN
        
        INSERT INTO TH_BUF_FORM_PEGGING_PLAN
      			(
      				 INSTANCE_ID , 
      				 FP_PLAN_ID , 
      				 SEQ , 
      				 COMPANY_ID ,
      				 DIVISION_ID , 
      				 SITE_ID ,
      				 PLANT_ID  ,
      				 FACTORY_ID ,  
      				 PLAN_DATE ,  
      				 ITEM_ID   , 
      				 QTY , 
      				 PEGGING_QTY  ,
      				 REMAIN_QTY ,
      				 P_TYPE  ,
               FORM_ID
      			)
        SELECT A.INSTANCE_ID , A.FP_PLAN_ID , A.SEQ , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID ,
      		   A.PLAN_DATE ,
			   --ITEM_ID ,
			   ISNULL(B.CELL_PRODUCT_ITEM_ID, A.ITEM_ID) , -- 활성화 분리 처리... 20230614
			   SUM(QTY) AS QTY , SUM(PEGGING_QTY )  AS PEGGING_QTY , SUM(REMAIN_QTY ) AS REMAIN_QTY , P_TYPE, --'-' AS P_TYPE
               --A.ITEM_ID + '##' + P_TYPE + '##' + CONVERT(NVARCHAR,RANK() OVER (PARTITION BY A.INSTANCE_ID , A.FP_PLAN_ID , A.SEQ , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID, A.ITEM_ID ORDER BY A.P_TYPE , A.PLAN_DATE ASC) )
			   ISNULL(B.CELL_PRODUCT_ITEM_ID, A.ITEM_ID) + '##' + P_TYPE + '##' + CONVERT(NVARCHAR,RANK() OVER (PARTITION BY A.INSTANCE_ID , A.FP_PLAN_ID , A.SEQ , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID, ISNULL(B.CELL_PRODUCT_ITEM_ID, A.ITEM_ID) ORDER BY A.P_TYPE , A.PLAN_DATE ASC) ) -- 활성화 분리 처리... 20230614
        FROM (
              SELECT   INSTANCE_ID , 
              				 '-' as fp_plan_id , 
              				 1 AS SEQ , 
              			 	 COMPANY_ID , 
              				 DIVISION_ID , 
                       SITE_ID ,
              				 PLANT_ID , 
              				 '-' AS FACTORY_ID  ,  
              				 PLAN_DATE  , 
              				 ITEM_ID , 
              				 SUM(PLAN_QTY) AS QTY , 
              				 0 AS PEGGING_QTY , 
              				 SUM(PLAN_QTY) AS REMAIN_QTY , 
              				 'PLAN' AS P_TYPE
              FROM FP_DAILY_PRODUCTION_PLAN_R
              WHERE INSTANCE_ID = @v_master_id   
              AND   FP_PLAN_ID IN (SELECT DISTINCT RELEASE_PLAN_ID FROM TH_BUF_RELEASE_PLAN WHERE INSTANCE_ID = @v_master_id )
              AND   PLAN_DATE >= @v_target_date
              AND   convert(nvarchar,PLAN_DATE,112) > @v_fix_date
             -- AND     FP_PLAN_ID = @v_plan_id 
              GROUP BY INSTANCE_ID , FP_PLAN_ID  , COMPANY_ID , DIVISION_ID ,SITE_ID, PLANT_ID   , PLAN_DATE  , ITEM_ID  
              UNION ALL -- FIX
              SELECT 	INSTANCE_ID , 
                      '-' AS FP_PLAN_ID , 
                      1 AS SEQ , 
                      COMPANY_ID , 
                      DIVISION_ID , 
                      SITE_ID , 
                      PLANT_ID , 
                      '-' AS FACTORY_ID ,  
              				DELIVERY_DATE AS PLAN_DATE , 
                      ITEM_ID , 
                      DELIVERY_QTY AS QTY ,  
                      0 AS PEGGING_QTY ,  
                      DELIVERY_QTY AS REMAIN_QTY ,
              				'FIX' AS P_TYPE
              FROM TH_BUF_FORM_PEGGING_PLAN_FIX
              WHERE   DELIVERY_DATE <= @v_fix_date
              AND     DELIVERY_DATE >= @v_target_date
              AND     INSTANCE_ID = @v_master_id
             -- /* boh
              UNION ALL
              SELECT @v_master_id   AS INSTANCE_ID,
              				'-' as fp_plan_id , 
            					1 as SEQ , 
                      A.COMPANY_ID,
                      A.DIVISION_ID,
                      A.SITE_ID,
                      A.PLANT_ID,
                      '-' as FACTORY_ID,
                      @v_target_date as PLAN_DATE , 
                      A.FP_APPLY_ITEM_ID   AS ITEM_ID,
                      FLOOR(ISNULL(ISNULL(A.MODIFY_FP_APPLY_WIPQTY,A.FP_APPLY_WIPQTY), 0))  AS BOH_QTY,
                     0 AS PEGGING_QTY  , 
                      FLOOR(ISNULL(ISNULL(A.MODIFY_FP_APPLY_WIPQTY,A.FP_APPLY_WIPQTY), 0))  AS REMAIN_QTY,
                      'BOH' AS P_TYPE  
              FROM   SCM_STOCK_H_V A ,
                      ( 
                        SELECT DISTINCT  COMPANY_ID , 
                                				 DIVISION_ID , 
                                         SITE_ID ,
                                				 PLANT_ID 
                        FROM FP_DAILY_PRODUCTION_PLAN_R
                        WHERE INSTANCE_ID = @v_master_id   
                        AND   FP_PLAN_ID in (SELECT DISTINCT release_PLAN_ID FROM TH_BUF_RELEASE_PLAN WHERE INSTANCE_ID = @v_master_id )
                      )B
              WHERE 1=1  
              AND    A.CUTOFF_DATE      = @v_target_date
              AND    A.STOCK_TYPE       = 'DW'
              AND    A.COMPANY_ID = B.COMPANY_ID
              AND    A.DIVISION_ID = B.DIVISION_ID
              AND    A.SITE_ID = B.SITE_ID
              AND    FLOOR(ISNULL(ISNULL(A.MODIFY_FP_APPLY_WIPQTY,A.FP_APPLY_WIPQTY), 0))  >= 0 
              AND    ((@v_master_id like 'PL%' AND A.WIPHOLD_YN IN ('N','Y')) or (@v_master_id not like 'PL%'  AND 1=1))
              AND    A.STORAGE_ID = '-'
              AND  NOT EXISTS  (SELECT 1
              					FROM (
              		          		SELECT A.*
              		          		FROM   SCM_STOCK_H_V A 
              						WHERE 1=1  
              						AND    A.CUTOFF_DATE      = @v_target_date
              						--AND    convert(date,A.AVAILABLE_DATE)  <= @v_cutoff_date      -- 당일 포함 이전까지 누적 데이터 ( PLAN_DATE) 
              						AND    A.STOCK_TYPE       = 'DW'
									--AND    A.FP_APPLY_OPERATION_ID = 'P5000' -- 하드코딩 고려
									--AND    A.OPERATION_ID = 'P1000'
									--AND    A.STOCK_STATUS = 'WAIT'
									--AND    A.WIPHOLD_YN = 'N'
									AND    A.MODIFY_FP_APPLY_WIPQTY IS NOT NULL
              						--AND    ISNULL(A.MODIFY_FP_APPLY_WIPQTY,0)  > 0 
    									)X
                				WHERE   A.COMPANY_ID = X.COMPANY_ID
                				AND     A.DIVISION_ID = X.DIVISION_ID
                				AND     A.SITE_ID = X.SITE_ID
                				AND 	A.PLANT_ID = X.PLANT_ID
                				AND  	A.FP_APPLY_ITEM_ID = X.FP_APPLY_ITEM_ID
              				   ) 
			  AND NOT EXISTS (	-- Lookup 으로 사용여부 체크 (D20200923~R0924.01)
					                    SELECT 1
					                    FROM (
					                        	SELECT 'DW' AS STOCK_TYPE, '-' AS STORAGE_ID
					                          		, (
					                            			SELECT ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = 'SSP' THEN 1 ELSE 0 END), 1) AS IS_DW
					                            			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
					                            			WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE_STOCK_SOURCE'
					                            			AND    A.ACTIVE_FLAG = 'Y'
					                            			AND    A.SEGMENT1 = 'KR_FORM_A'
					                          		) AS IS_DW
					                    ) AA
					                    WHERE 1 = AA.IS_DW
										AND	  A.STOCK_TYPE = AA.STOCK_TYPE
					                    AND   A.STORAGE_ID = AA.STORAGE_ID
					               )
              UNION ALL
              SELECT	@v_master_id   AS INSTANCE_ID,
            			'-' as fp_plan_id , 
          				1 as SEQ , 
						A.COMPANY_ID,
						A.DIVISION_ID,
						A.SITE_ID,
						A.PLANT_ID,
						'-' as FACTORY_ID,
						@v_target_date as PLAN_DATE , 
						A.FP_APPLY_ITEM_ID   AS ITEM_ID,
						FLOOR(A.MODIFY_FP_APPLY_WIPQTY)  AS BOH_QTY,
						0 AS PEGGING_QTY  , 
						FLOOR(A.MODIFY_FP_APPLY_WIPQTY)  AS REMAIN_QTY,
						'BOH' AS P_TYPE  
              FROM   SCM_STOCK_H_V A ,
                    ( 
                      SELECT DISTINCT  COMPANY_ID , 
                              				 DIVISION_ID , 
                                       SITE_ID ,
                              				 PLANT_ID 
                      FROM FP_DAILY_PRODUCTION_PLAN_R
                      WHERE INSTANCE_ID = @v_master_id   
                      AND   FP_PLAN_ID in (SELECT DISTINCT release_PLAN_ID FROM TH_BUF_RELEASE_PLAN WHERE INSTANCE_ID = @v_master_id )
                    )B
              WHERE 1=1  
              --AND    A.CUTOFF_DATE      = @v_plan_date
              AND    A.CUTOFF_DATE      = @v_target_date
              AND    A.COMPANY_ID = B.COMPANY_ID
              AND    A.DIVISION_ID = B.DIVISION_ID
              AND    A.SITE_ID = B.SITE_ID
              AND    A.STOCK_TYPE = 'DW'
              AND    A.STORAGE_ID = '-'
              AND    A.MODIFY_FP_APPLY_WIPQTY IS NOT NULL
              AND    ((@v_master_id like 'PL%' AND A.WIPHOLD_YN ='N') or (@v_master_id not like 'PL%'  AND 1=1))
              AND NOT EXISTS (	-- Lookup 으로 사용여부 체크 (D20200923~R0924.01)
					                    SELECT 1
					                    FROM (
					                        	SELECT 'DW' AS STOCK_TYPE, '-' AS STORAGE_ID
					                          		, (
					                            			SELECT ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = 'SSP' THEN 1 ELSE 0 END), 1) AS IS_DW
					                            			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
					                            			WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE_STOCK_SOURCE'
					                            			AND    A.ACTIVE_FLAG = 'Y'
					                            			AND    A.SEGMENT1 = 'KR_FORM_A'
					                          		) AS IS_DW
					                    ) AA
					                    WHERE 1 = AA.IS_DW
										AND	  A.STOCK_TYPE = AA.STOCK_TYPE
					                    AND   A.STORAGE_ID = AA.STORAGE_ID
					               )
              UNION ALL
				-- SSP 포장창고 재고 추가(DW 포장창고 대신)
				SELECT	@v_master_id   AS INSTANCE_ID,
					        '-' AS FP_PLAN_ID , 
					        1 AS SEQ , 
							A.COMPANY_ID,
							A.DIVISION_ID,
							A.SITE_ID,
							A.PLANT_ID,
							'-' AS FACTORY_ID,
							@v_target_date AS PLAN_DATE , 
							A.ITEM_ID,
							FLOOR(A.QTY)  AS BOH_QTY,
							0 AS PEGGING_QTY  , 
							FLOOR(A.QTY)  AS REMAIN_QTY,
							'BOH' AS P_TYPE 
				FROM   FP_SSP_STOCK_BACKUP_H A WITH(NOLOCK)
						  ,( 
					            SELECT	DISTINCT  COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID 
					            FROM	FP_DAILY_PRODUCTION_PLAN_R WITH(NOLOCK)
					            WHERE	INSTANCE_ID = @v_master_id   
					            AND		FP_PLAN_ID IN (SELECT DISTINCT RELEASE_PLAN_ID FROM TH_BUF_RELEASE_PLAN WHERE INSTANCE_ID = @v_master_id)
					        ) B
				WHERE  1 = (	-- Lookup 으로 사용여부 체크 (D20200923~R0924.01)
									SELECT ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = 'SSP' THEN 1 ELSE 0 END), 1) AS IS_DW
									FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
									WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE_STOCK_SOURCE'
									AND    A.ACTIVE_FLAG = 'Y'
									AND    A.SEGMENT1 = @v_master_id 
								)
				AND    A.CUTOFF_DATE = CONVERT(DATETIME, @v_target_date)
				AND    A.COMPANY_ID = B.COMPANY_ID
				AND    A.DIVISION_ID = B.DIVISION_ID
				AND    A.SITE_ID = B.SITE_ID
        )A
		LEFT OUTER JOIN FP_CELL_ASSY_PRODUCT_MAP_V B WITH(NOLOCK)
		ON  1=1
		AND A.COMPANY_ID  = B.COMPANY_ID
		AND A.DIVISION_ID = B.DIVISION_ID
		AND A.SITE_ID     = B.SITE_ID
		AND A.ITEM_ID     = B.CELL_ASSY_ITEM_ID
        GROUP BY A.INSTANCE_ID , A.FP_PLAN_ID , A.SEQ , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID , A.PLAN_DATE
		--, A.ITEM_ID
		, ISNULL(B.CELL_PRODUCT_ITEM_ID, A.ITEM_ID) -- 활성화 분리 처리... 20230614
		, A.P_TYPE
        
        /*
        INSERT INTO TH_BUF_FORM_PEGGING_PLAN
      			(
      				 INSTANCE_ID , 
      				 FP_PLAN_ID , 
      				 SEQ , 
      				 COMPANY_ID ,
      				 DIVISION_ID , 
      				 SITE_ID ,
      				 PLANT_ID  ,
      				 FACTORY_ID ,  
      				 PLAN_DATE ,  
      				 ITEM_ID   , 
      				 QTY , 
      				 PEGGING_QTY  ,
      				 REMAIN_QTY ,
      				 P_TYPE  
      			)
        SELECT  INSTANCE_ID , 
      					FP_PLAN_ID , 
      					1 as SEQ , 
      					COMPANY_ID , 
      					DIVISION_ID , 
      				 	SITE_ID , 
      				 	PLANT_ID  , 
      				 	FACTORY_ID ,  
      				 	@v_cutoff_date AS PLAN_DATE , 
      				 	ITEM_ID   , 
      				 	SUM(BOH_QTY) AS BOH_QTY , 
      				 	0 AS PEGGING_QTY  , 
      				 	SUM(BOH_QTY) AS REMAIN_QTY ,
      				 	'BOH' AS P_TYPE  
        FROM FP_AMEND_PLAN_FORM_R
        WHERE INSTANCE_ID = @v_master_id 
        --AND	  FP_PLAN_ID =  @v_plan_iD
        AND   FP_PLAN_ID IN (SELECT DISTINCT RELEASE_PLAN_ID FROM TH_BUF_RELEASE_PLAN WHERE INSTANCE_ID = @v_master_id )
        AND 	FACTORY_ID = '-'
        AND 	BOH_QTY > 0
        GROUP BY INSTANCE_ID , FP_PLAN_ID , COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , FACTORY_ID , ITEM_ID  , ITEM_ID , MARKET  */ 
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
        
        -- CWA CELL GROUP CODE 기준 PEGGING 
        IF @v_master_id = 'PL_FORM_A'
        BEGIN
        
          UPDATE TH_BUF_FORM_PEGGING_PLAN
          SET TH_BUF_FORM_PEGGING_PLAN.ITEM_ID = A.SEGMENT3
          FROM (
          			SELECT *
          			FROM SCM_SYS_LOOKUP_VALUE 
          			WHERE LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'
          			AND SEGMENT1 = 'A004'
          			)A
          WHERE TH_BUF_FORM_PEGGING_PLAN.INSTANCE_ID =  @v_master_id 
          AND		 TH_BUF_FORM_PEGGING_PLAN.ITEM_ID = SEGMENT4 
          
          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, 'MODULE_CELL_GROUP', null
        
        END
        /*
        INSERT INTO TH_BUF_FORM_PEGGING_PLAN
      			(
      				 INSTANCE_ID , 
      				 FP_PLAN_ID , 
      				 SEQ , 
      				 COMPANY_ID ,
      				 DIVISION_ID , 
      				 SITE_ID ,
      				 PLANT_ID  ,
      				 FACTORY_ID ,  
      				 PLAN_DATE ,  
      				 ITEM_ID   , 
      				 QTY , 
      				 PEGGING_QTY  ,
      				 REMAIN_QTY ,
      				 P_TYPE  
      			)
        SELECT   INSTANCE_ID , 
        				 FP_PLAN_ID , 
        				 1 AS SEQ , 
        			 	 COMPANY_ID , 
        				 DIVISION_ID , 
                 SITE_ID ,
        				 PLANT_ID , 
        				 '-' AS FACTORY_ID  , 
        				 PLAN_DATE  , 
        				 ITEM_ID , 
        				 SUM(PLAN_QTY) AS QTY , 
        				 0 AS PEGGING_QTY , 
        				 SUM(PLAN_QTY) AS REMAIN_QTY , 
        				 'PLAN' AS P_TYPE
        FROM FP_DAILY_PRODUCTION_PLAN_R
        WHERE INSTANCE_ID = @v_master_id   
        AND   FP_PLAN_ID = (SELECT DISTINCT AMEND_PLAN_ID FROM TH_BUF_RELEASE_PLAN WHERE INSTANCE_ID = @v_master_id )
       -- AND     FP_PLAN_ID = @v_plan_id 
        GROUP BY INSTANCE_ID , FP_PLAN_ID  , COMPANY_ID , DIVISION_ID ,SITE_ID, PLANT_ID   , PLAN_DATE  , ITEM_ID  */
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
        
        SET @v_table_name = 'TH_BUF_PACK_REQUIRE_PEGGING_PLAN'

        DELETE TH_BUF_PACK_REQUIRE_PEGGING_PLAN
  
        INSERT INTO TH_BUF_PACK_REQUIRE_PEGGING_PLAN
              (
              	COMPANY_ID ,
              	DIVISION_ID , 
                SITE_ID  ,
              	PLANT_ID , 
                FP_PLAN_ID ,
              	ITEM_ID , 
              	STORAGE_ID , 
              	SOC_ID , 
              	PLAN_DATE , 
              	QTY , 
              	PEGGING_QTY ,
                REMAIN_QTY,
              	SEQ , 
              	DESCR,
                PACK_ID
              )
        SELECT  A.COMPANY_ID , 
        		A.DIVISION_ID , 
        		A.SITE_ID,
                ISNULL(D.PLANT_ID, A.PLANT_ID) AS PLANT_ID , 		-- 요청계획 중 Hazel Park Plant 를 변경해 준다. (D20200911~R0911.01)
        		'-' AS FP_PLAN_ID , 
        		A.CELL_ITEM_ID AS ITEM_ID , 
        		A.STORAGE_ID , 
        		A.SOC_ID , 
        		A.REQUIRE_DATE AS PLAN_DATE , 
        		A.REQUIRE_QTY AS QTY , 
        		0 AS PEGGING_QTY , 
                A.REQUIRE_QTY AS REMAIN_QTY , 
        		ROW_NUMBER() OVER ( PARTITION BY A.COMPANY_ID , A.DIVISION_ID , A.PLANT_ID   
        					                ORDER BY A.CELL_ITEM_ID , A.STORAGE_ID , CASE WHEN A.SOC_ID ='AIR' THEN 1 ELSE 9 END  , A.REQUIRE_DATE , A.REQUIRE_QTY ) AS SEQ , 
        		A.MARKET  AS DESCR		,
                A.CELL_ITEM_ID + '##' + CONVERT(NVARCHAR,A.REQUIRE_DATE , 112) + '##' + CONVERT(NVARCHAR,ROW_NUMBER() OVER ( PARTITION BY A.COMPANY_ID , A.DIVISION_ID , A.PLANT_ID   
        					                                                                                            ORDER BY A.CELL_ITEM_ID , A.STORAGE_ID , CASE WHEN A.SOC_ID ='AIR' THEN 1 ELSE 9 END  , A.REQUIRE_DATE , A.REQUIRE_QTY ))
        FROM FP_DEMAND_PACK_REQUIRE_FIX  A
        			LEFT OUTER JOIN (						-- 요청계획 중 Hazel Park Plant 를 변경해 준다. (D20200911~R0911.01)
												SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID
														, A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID
												FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
												WHERE  A.LOOKUP_TYPE_CODE = 'FORMATION_PACK_INSTANCE_MAP'
												AND    A.ACTIVE_FLAG = 'Y'
												AND	   A.SEGMENT4 = 'DU'
					) D
						ON   A.DIVISION_ID  	= D.REF_DIVISION_ID
						AND A.SITE_ID      	= D.REF_SITE_ID
						AND A.PLANT_ID      	= D.REF_PLANT_ID
        -- FP_DEMAND_PACK_REQUIRE_CELL_H A -- , 
        			/*(
        				SELECT  INSTANCE_ID , 
                        INSTANCE_DATE , 
                        DIVISION_ID , 
                   FACTORY_ID ,
        				        MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE , DIVISION_ID , FACTORY_ID   ) AS RELEASE_PLAN_ID ,
                        AMEND_PLAN_ID,
                				CASE WHEN RELEASE_PLAN_ID = MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE , DIVISION_ID , FACTORY_ID   ) 
                						  THEN 'Y'
                						  ELSE 'N'
              			    END AS CK_ID ,			  
        			          A.KEY_VALUE ,
                        A.SEQ ,
                        CONVERT(DATE, A.INSTANCE_DATE) AS RELEASE_DATE    -- 2018.03.26 : RELEASE 일자 이후부터 타겟
        			  FROM   (
        			          SELECT A.*
        			               , B.KEY_VALUE
        			               , DENSE_RANK() OVER (PARTITION BY FACTORY_ID
        			                                    ORDER     BY INSTANCE_DATE DESC) AS SEQ
        			          FROM   FP_RELEASE_PLAN_INFO_H  A
        			               , (
        			                  SELECT *
        			                  FROM   FP_INSTANCE_CONFIG_M
        			                  WHERE  INSTANCE_ID  = @v_master_id
        			                  AND    CATEGORY_ID  = 'DEMAND_TARGET'
        			                  AND    KEY_VALUE    = 'PACK_RELEASE'
        			                 ) B
        			          WHERE  A.INSTANCE_ID  = B.PART_ID
        			          AND    A.DIVISION_ID  = B.KEY_ID
        			         ) A
        			  WHERE  SEQ = 1  
      			  )B*/
      	WHERE  1=1
        AND   A.INSTANCE_ID = @v_pack_master_id
        AND   A.PLAN_ID = @v_pack_confirm_id

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
        
        /**/
        
        /*PEGGING 정보 생성*/
        
        DELETE TH_BUF_CELL_DELIVERY_PEGGING
        
        SET @v_table_name = 'C_PRODUCT_PEGGING'
        --SET @n_row_count = 0

        DECLARE
          @c_require_pegging$seq                  numeric(20,10),
          @c_require_pegging$company_id           nvarchar(30), 
          @c_require_pegging$division_id          nvarchar(30),
          @c_require_pegging$site_id              nvarchar(30),
          @c_require_pegging$plant_id             nvarchar(30),
          @c_require_pegging$item_id              nvarchar(30),
          @c_require_pegging$storage_id           nvarchar(30),
          @c_require_pegging$soc_id               nvarchar(30),
          @c_require_pegging$plan_date            date,
          @c_require_pegging$qty                  numeric(20,10),
          @c_require_pegging$remain_qty           numeric(20,10),
          @c_require_pegging$market               nvarchar(30) ,
          @c_require_pegging$pack_id              nvarchar(150)

          
        DECLARE
          @product_pegging$item_id              nvarchar(150), 
          @product_pegging$plan_date            date,
          @product_pegging$plan_qty             numeric(20,10),
          @product_pegging$remain_qty           numeric(20,10),
          @product_pegging$form_id              nvarchar(150) ,
          @product_pegging$p_type               nvarchar(30)          -- 2018.11.16 : 동일 일자에 BOH, PLAN 존재, 이중차감됨
        
        DECLARE
          @pegging$pegging_qty                  numeric(20,10),
          @pegging_seq                          integer = 0,
          @check_qty                            integer = 1,
          @check_qty2                           integer = 0 ,
          @chk_remain_qty                       numeric(20,10)
          
        DECLARE
          C_REQUIRE_PEGGING CURSOR LOCAL FOR
          
            SELECT  SEQ , 
                    COMPANY_ID , 
                    DIVISION_ID , 
                    SITE_ID , 
                    PLANT_ID , 
                    ITEM_ID , 
                    STORAGE_ID,
                    SOC_ID,
                    PLAN_DATE , 
                    QTY ,
                    REMAIN_QTY,
                    DESCR,
                    PACK_ID
            FROM  TH_BUF_PACK_REQUIRE_PEGGING_PLAN
            WHERE QTY - PEGGING_QTY > 0
            AND   REMAIN_QTY > 0 
            ORDER BY   ITEM_ID , PLAN_DATE, SEQ

        OPEN C_REQUIRE_PEGGING
        
        WHILE 1=1
        BEGIN
        
          FETCH c_require_pegging
               INTO   @c_require_pegging$seq                  ,
                      @c_require_pegging$company_id           , 
                      @c_require_pegging$division_id          ,
                      @c_require_pegging$site_id              ,
                      @c_require_pegging$plant_id             ,
                      @c_require_pegging$item_id              ,
                      @c_require_pegging$storage_id           ,
                      @c_require_pegging$soc_id               ,
                      @c_require_pegging$plan_date            ,
                      @c_require_pegging$qty                  ,
                      @c_require_pegging$remain_qty           ,
                      @c_require_pegging$market               ,
                      @c_require_pegging$pack_id
                      
          IF @@FETCH_STATUS <> 0
                BREAK
              
          WHILE 1 = 1
           
            BEGIN
              
              IF @@FETCH_STATUS <> 0
                BREAK
              
              IF @c_require_pegging$remain_qty <= 0 
                BREAK
                
                SELECT @check_qty  = SUM(REMAIN_QTY)
                FROM TH_BUF_FORM_PEGGING_PLAN
                WHERE ITEM_ID = @c_require_pegging$item_id
                GROUP BY ITEM_ID
                
                IF @check_qty <= 0  -- 전체 pegging 되면 빠져나감.
                BREAK;
                
                SELECT     @product_pegging$item_id     = ITEM_ID, 
                           @product_pegging$plan_date   = PLAN_DATE,
                           @product_pegging$plan_qty    = QTY,
                           @product_pegging$remain_qty  = REMAIN_QTY,
                           @product_pegging$form_id     = FORM_ID ,
                           @product_pegging$p_type      = P_TYPE      
                FROM (
				                SELECT  	SEQ , ITEM_ID , PLAN_DATE , QTY ,  REMAIN_QTY , 
				                				  DENSE_RANK() OVER (ORDER BY CASE WHEN P_TYPE = 'FIX' THEN 1  WHEN P_TYPE = 'BOH' THEN 2 ELSE 3 END  ASC , PLAN_DATE ) AS SEQ_A , FORM_ID , 
                                  P_TYPE
                        FROM TH_BUF_FORM_PEGGING_PLAN
                        WHERE 1=1
                        AND REMAIN_QTY > 0 
                        AND QTY > 0 
                        AND ITEM_ID = @c_require_pegging$item_id
                        and PLAN_DATE <= @c_require_pegging$plan_date
	                    )A
                WHERE  A.SEQ_A =1    
                
                IF ISNULL(@product_pegging$item_id, 'NULL') = 'NULL'
                BREAK;
                
                IF @product_pegging$remain_qty <= 0 
                BREAK;
                
                IF @product_pegging$plan_qty <= 0 
                BREAK;
                
                IF @c_require_pegging$item_id <> @product_pegging$item_id
                BREAK;
                
                --IF @c_require_pegging$remain_qty > @product_pegging$remain_qty
                --  SET @c_require_pegging$remain_qty = @product_pegging$remain_qty
                
                --IF @product_pegging$item_id = 'ACPN1030U-A1'
                --EXECUTE pr_log_process  null, @v_master_id, 'KKK',@product_pegging$item_id , @product_pegging$plan_date, @c_require_pegging$remain_qty, @product_pegging$remain_qty, @product_pegging$plan_qty, @pegging_seq, @c_require_pegging$qty

                WHILE 1 = 1
                  
                  BEGIN
                  
                    IF @c_require_pegging$remain_qty <= 0 
                    BREAK
                    
                    IF @product_pegging$plan_qty <=0
                    BREAK

                    /*
                    전량 pegging 된 경우
                    */
                    IF  @c_require_pegging$remain_qty  >=   @product_pegging$remain_qty  AND @c_require_pegging$remain_qty >0 AND @product_pegging$remain_qty > 0  -- @product_pegging$plan_qty 
                    BEGIN
                      
                      IF @product_pegging$plan_qty <=0
                      BREAK
                      
                      
                      SET @pegging$pegging_qty = @product_pegging$remain_qty 
                 
                      INSERT INTO TH_BUF_CELL_DELIVERY_PEGGING 
                            (
                              COMPANY_ID,
                              DIVISION_ID,
                              SITE_ID,
                              PLANT_ID,
                              ITEM_ID,
                              STORAGE_ID,
                              SOC_ID,
                              MARKET,
                              DELIVERY_DATE,
                              DELIVERY_QTY,
                              PLAN_QTY,
                              PACK_QTY,
                              SEQ,
                              PACK_DATE,
                              FORM_DATE,
                              PACK_ID,
                              FORM_ID
                            )
                      SELECT  @c_require_pegging$company_id           AS COMPANY_ID, 
                              @c_require_pegging$division_id          AS DIVISION_ID,
                              @c_require_pegging$site_id              AS SITE_ID,
                              @c_require_pegging$plant_id             AS PLANT_ID,
                              @c_require_pegging$item_id              AS ITEM_ID,
                              @c_require_pegging$storage_id           AS STORAGE_ID,
                              @c_require_pegging$soc_id               AS SOC_ID,
                              @c_require_pegging$market               AS MARKET ,
                              @c_require_pegging$plan_date            AS DELIVERY_DATE,
                              @pegging$pegging_qty                    AS DELEIVERY_QTY,
                              @product_pegging$plan_qty               AS PLAN_QTY,
                              @c_require_pegging$remain_qty           AS PACK_QTY,
                              @pegging_seq                            AS SEQ,
                              @c_require_pegging$plan_date            AS PACK_DATE,
                              @product_pegging$plan_date              AS FORM_DATE , 
                              @c_require_pegging$pack_id              AS PACK_ID ,
                              @product_pegging$form_id                AS FORM_ID
                              

                      UPDATE  TH_BUF_FORM_PEGGING_PLAN
                      SET     PEGGING_QTY = PEGGING_QTY + @pegging$pegging_qty , 
                              REMAIN_QTY = REMAIN_QTY - @pegging$pegging_qty
                      WHERE   1=1 
                      AND     ITEM_ID     = @product_pegging$item_id     
                      AND     PLAN_DATE   = @product_pegging$plan_date
                      AND     P_TYPE      = @product_pegging$p_type                 -- 2018.11.16 : 동일 일자에 BOH, PLAN 존재, 이중차감됨
                      AND     FORM_ID     = @product_pegging$form_id
                      
                      UPDATE  TH_BUF_PACK_REQUIRE_PEGGING_PLAN
                      SET     PEGGING_QTY = PEGGING_QTY + @pegging$pegging_qty,
                              REMAIN_QTY = REMAIN_QTY - @pegging$pegging_qty
                      WHERE  1=1
                      AND    ITEM_ID     = @product_pegging$item_id    
                      AND    PLAN_DATE = @c_require_pegging$plan_date
                      AND    PACK_ID = @c_require_pegging$pack_id
                      --AND    SEQ = @c_require_pegging$seq
                      
                      SET @c_require_pegging$remain_qty = @c_require_pegging$remain_qty - @pegging$pegging_qty
                      
                      SET @product_pegging$remain_qty = @product_pegging$remain_qty - @pegging$pegging_qty
                      
                      SET @product_pegging$plan_qty = @product_pegging$plan_qty - @pegging$pegging_qty
                      
                      SET @pegging_seq = @pegging_seq + 1
                      
                      BREAK;
                      
                    END
                    ELSE IF  @c_require_pegging$remain_qty  < @product_pegging$remain_qty AND @c_require_pegging$remain_qty >0 AND @product_pegging$remain_qty > 0  -- @product_pegging$plan_qty
                    BEGIN
                    
                        IF @product_pegging$remain_qty <=0
                        BREAK

                        SET @pegging$pegging_qty = @c_require_pegging$remain_qty

                        INSERT INTO TH_BUF_CELL_DELIVERY_PEGGING 
                              (
                                COMPANY_ID,
                                DIVISION_ID,
                                SITE_ID,
                                PLANT_ID,
                                ITEM_ID,
                                STORAGE_ID,
                                SOC_ID,
                                MARKET,
                                DELIVERY_DATE,
                                DELIVERY_QTY,
                                PLAN_QTY,
                                PACK_QTY,
                                SEQ,
                                PACK_DATE,
                                FORM_DATE,
                                PACK_ID,
                                FORM_ID
                              )
                        SELECT  @c_require_pegging$company_id           AS COMPANY_ID, 
                                @c_require_pegging$division_id          AS DIVISION_ID,
                                @c_require_pegging$site_id              AS SITE_ID,
                                @c_require_pegging$plant_id             AS PLANT_ID,
                                @c_require_pegging$item_id              AS ITEM_ID,
                                @c_require_pegging$storage_id           AS STORAGE_ID,
                                @c_require_pegging$soc_id               AS SOC_ID,
                                @c_require_pegging$market               AS MARKET ,
                                @c_require_pegging$plan_date            AS DELIVERY_DATE,
                                @pegging$pegging_qty                    AS DELEIVERY_QTY,
                                @product_pegging$plan_qty               AS PLAN_QTY,
                                @c_require_pegging$remain_qty           AS PACK_QTY,
                                @pegging_seq                            AS SEQ ,
                                @c_require_pegging$plan_date            AS PACK_DATE,
                                @product_pegging$plan_date              AS FORM_DATE,
                                @c_require_pegging$pack_id              AS PACK_ID,
                                @product_pegging$form_id                AS FORM_ID 
                                

                        UPDATE  TH_BUF_FORM_PEGGING_PLAN
                        SET     PEGGING_QTY = PEGGING_QTY + @pegging$pegging_qty , 
                                REMAIN_QTY = REMAIN_QTY - @pegging$pegging_qty
                        WHERE   1=1 
                        AND     ITEM_ID     = @product_pegging$item_id     
                        AND     PLAN_DATE   = @product_pegging$plan_date
                        AND     P_TYPE      = @product_pegging$p_type                 -- 2018.11.16 : 동일 일자에 BOH, PLAN 존재, 이중차감됨
                        AND     FORM_ID     = @product_pegging$form_id
                        
                        UPDATE  TH_BUF_PACK_REQUIRE_PEGGING_PLAN
                        SET     PEGGING_QTY = PEGGING_QTY + @pegging$pegging_qty,
                                REMAIN_QTY = REMAIN_QTY - @pegging$pegging_qty
                        WHERE  1=1
                        AND    ITEM_ID     = @product_pegging$item_id
                        AND    PLAN_DATE = @c_require_pegging$plan_date  
                        AND    PACK_ID = @c_require_pegging$pack_id
                        --AND    SEQ = @c_require_pegging$seq
                        
                        SET @c_require_pegging$remain_qty = @c_require_pegging$remain_qty - @pegging$pegging_qty
                        
                        SET @product_pegging$remain_qty = @product_pegging$remain_qty - @pegging$pegging_qty
                        
                        SET @product_pegging$plan_qty = @product_pegging$plan_qty - @pegging$pegging_qty
                        
                        SET @pegging_seq = @pegging_seq + 1
                                                
                        BREAK;
                        
                    END    

                  END  
            END
        END

        CLOSE C_REQUIRE_PEGGING

        DEALLOCATE C_REQUIRE_PEGGING

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
        /*
          Carry over 반영
        */
        IF  1=1
        BEGIN
          
          SET @v_table_name = 'TH_BUF_CELL_DELIVERY_CAEEYOVER'
          
          DELETE TH_BUF_CELL_DELIVERY_CAEEYOVER
          
          INSERT INTO TH_BUF_CELL_DELIVERY_CAEEYOVER
            (
              COMPANY_ID , 
              DIVISION_ID ,
              SITE_ID ,
              PLANT_ID , 
              ITEM_ID , 
              CARRY_OVER_QTY ,
              REMAIN_QTY
            )
          SELECT  A.COMPANY_ID , 
        				  A.DIVISION_ID , 
        				  A.SITE_ID , 
        				  A.PLANT_ID ,  
        				  A.ITEM_ID   , 
        				  SUM(REQUEST_QTY) - SUM (SHIPPING_QTY )  AS CARRY_OVER_QTY , 
        				  SUM(REQUEST_QTY) - SUM (SHIPPING_QTY )  AS REMAIN_QTY   				  
          FROM (
          			SELECT A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,  A.ITEM_ID  , SUM(A.QTY) AS REQUEST_QTY , 0 AS SHIPPING_QTY
          			FROM (
          						SELECT A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,  A.ITEM_ID  , SUM(A.QTY) AS QTY  
          						FROM TH_BUF_PACK_REQUIRE_PEGGING_PLAN A 
          						WHERE A.PLAN_DATE < @v_target_date
          						GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,  A.ITEM_ID 
          						UNION ALL
          						SELECT A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,  A.ITEM_ID  , 0 AS QTY
          						FROM TH_BUF_PACK_REQUIRE_PEGGING_PLAN A 
          						GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,  A.ITEM_ID 
          					 )A
          			GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,  A.ITEM_ID 
          			UNION ALL
          			SELECT A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,  A.ITEM_ID  ,  0 AS REQUEST_QTY , SUM(A.SHIPPING_QTY) AS SHIPPING_QTY
          			FROM (
          						SELECT A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.ITEM_ID  , SUM(A.QTY) AS SHIPPING_QTY
          						FROM SCM_FCS_SHIP_V A 
          									INNER JOIN
          								(
          									SELECT COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID ,  ITEM_ID , MIN(PLAN_DATE)  AS MIN_DATE , MAX(PLAN_DATE) AS MAX_DATE 
          									FROM TH_BUF_PACK_REQUIRE_PEGGING_PLAN
          									WHERE PLAN_DATE < @v_target_date
          									GROUP BY COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID ,  ITEM_ID
          								)B 
          								ON A.COMPANY_ID = B.COMPANY_ID
          								AND A.DIVISION_ID = B.DIVISION_ID 
          								AND A.SITE_ID = B.SITE_ID 
          								AND A.PLANT_ID = B.PLANT_ID
          								AND A.SHIP_YYYYMMDD >= B.MIN_DATE
          								AND A.SHIP_YYYYMMDD <= B.MAX_DATE
          								AND A.ITEM_ID = B.ITEM_ID 
          								AND  A.BIZ_TYPE = 'P'
          						GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.ITEM_ID 
          						UNION ALL
          						SELECT A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,  A.ITEM_ID  , 0 AS SHIPPING_QTY
          						FROM TH_BUF_PACK_REQUIRE_PEGGING_PLAN A 
          						GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,  A.ITEM_ID 
          						)A
          			GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,  A.ITEM_ID 
                )A
          GROUP BY  A.COMPANY_ID , 
          				  A.DIVISION_ID , 
          				  A.SITE_ID , 
          				  A.PLANT_ID ,  
          				  A.ITEM_ID  
                    
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null          
        
          DECLARE
            @c_carryover$company_id      nvarchar(50), 
            @c_carryover$division_id     nvarchar(50),
            @c_carryover$site_id         nvarchar(50), 
            @c_carryover$plant_id        nvarchar(50),
            @c_carryover$item_id         nvarchar(50),
            @c_carryover$delivery_qty    numeric(20,10),
            @c_carryover$delivery_date   date , 
            @c_carryover$pack_id         nvarchar(50),
            @c_carryover$form_id         nvarchar(50)
            
          DECLARE
            @carryover$carryover_qty     numeric(20,10) = 0
          
          DECLARE
          
            C_CARRYOVER CURSOR LOCAL FOR
            
              SELECT  A.COMPANY_ID , 
                      A.DIVISION_ID , 
                      A.SITE_ID , 
                      A.PLANT_ID , 
                      A.ITEM_ID , 
                      A.DELIVERY_QTY AS DELIVERY_QTY , 
                      A.DELIVERY_DATE , 
                      A.PACK_ID , 
                      A.FORM_ID
              FROM  TH_BUF_CELL_DELIVERY_PEGGING A , 
               			(
               			 	SELECT COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , ITEM_ID , MAX(DELIVERY_DATE) AS  DELIVERY_DATE 
              				FROM TH_BUF_CELL_DELIVERY_PEGGING
              				WHERE DELIVERY_QTY > 0 
              				GROUP BY COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , ITEM_ID
               			)B
              WHERE   A.COMPANY_ID = B.COMPANY_ID 
              AND     A.DIVISION_ID = B.DIVISION_ID
              AND		  A.SITE_ID = B.SITE_ID
              AND		  A.PLANT_ID = B.PLANT_ID 
              AND     A.ITEM_ID = B.ITEM_ID
              AND		  A.DELIVERY_DATE =  B.DELIVERY_DATE
              AND     A.DELIVERY_QTY > 0 
              --GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.ITEM_ID , A.DELIVERY_DATE
            
          OPEN C_CARRYOVER     
          
            WHILE 1=1
              
              BEGIN
              
                FETCH C_CARRYOVER
                INTO    @c_carryover$company_id  , 
                        @c_carryover$division_id ,
                        @c_carryover$site_id , 
                        @c_carryover$plant_id ,
                        @c_carryover$item_id ,
                        @c_carryover$delivery_qty ,
                        @c_carryover$delivery_date , 
                        @c_carryover$pack_id ,
                        @c_carryover$form_id

                IF @@FETCH_STATUS <> 0
                  BREAK
                  
                WHILE 1=1
                  
                  BEGIN    
                  
                    /*SELECT  @c_carryover$company_id  , 
                            @c_carryover$division_id ,
                            @c_carryover$site_id , 
                            @c_carryover$plant_id ,
                            @c_carryover$item_id ,
                            @c_carryover$delivery_qty ,
                            @c_carryover$delivery_date*/
                            
                    SELECT  @carryover$carryover_qty =  CASE  WHEN  A.REMAIN_QTY   >  @c_carryover$delivery_qty 
                                                              THEN  @c_carryover$delivery_qty 
                                                              ELSE  A.REMAIN_QTY 
                                                        END 
                    FROM    TH_BUF_CELL_DELIVERY_CAEEYOVER A
                    WHERE   A.COMPANY_ID =  @c_carryover$company_id
                    AND     A.DIVISION_ID =  @c_carryover$division_id
                    AND		  A.SITE_ID = @c_carryover$site_id
                    AND		  A.PLANT_ID = @c_carryover$plant_id
                    AND		  A.ITEM_ID = @c_carryover$item_id
                    AND     A.REMAIN_QTY <> 0 
                    
                    IF ISNULL(@carryover$carryover_qty, 19890518 ) = 19890518
                        BREAK;
                    
                    IF  @carryover$carryover_qty < 0
                    BEGIN
                      
                      UPDATE TH_BUF_CELL_DELIVERY_PEGGING
                      SET DELIVERY_QTY =  DELIVERY_QTY - @carryover$carryover_qty
                      WHERE  COMPANY_ID =  @c_carryover$company_id
                      AND    DIVISION_ID =  @c_carryover$division_id
                      AND		 SITE_ID = @c_carryover$site_id
                      AND		 PLANT_ID = @c_carryover$plant_id
                      AND		 ITEM_ID = @c_carryover$item_id
                      AND    DELIVERY_dATE = @c_carryover$delivery_date 
                      AND    PACK_ID = @c_carryover$pack_id
                      AND    FORM_ID = @c_carryover$form_id
                      
                      UPDATE TH_BUF_CELL_DELIVERY_CAEEYOVER
                      SET     REMAIN_QTY = 0
                      WHERE   COMPANY_ID =  @c_carryover$company_id
                      AND     DIVISION_ID =  @c_carryover$division_id
                      AND		  SITE_ID = @c_carryover$site_id
                      AND		  PLANT_ID = @c_carryover$plant_id
                      AND		  ITEM_ID = @c_carryover$item_id
                      
                      SET @carryover$carryover_qty = 0
                      
                      BREAK;
                      
                    END
                    
                    ELSE 
                    BEGIN
                    
                      UPDATE TH_BUF_CELL_DELIVERY_PEGGING
                      SET DELIVERY_QTY =  DELIVERY_QTY - @carryover$carryover_qty
                      WHERE  COMPANY_ID =  @c_carryover$company_id
                      AND    DIVISION_ID =  @c_carryover$division_id
                      AND		 SITE_ID = @c_carryover$site_id
                      AND		 PLANT_ID = @c_carryover$plant_id
                      AND		 ITEM_ID = @c_carryover$item_id
                      AND    DELIVERY_dATE = @c_carryover$delivery_date
                      AND    PACK_ID = @c_carryover$pack_id
                      AND    FORM_ID = @c_carryover$form_id
                      
                      UPDATE TH_BUF_CELL_DELIVERY_CAEEYOVER
                      SET     REMAIN_QTY = REMAIN_QTY - @carryover$carryover_qty
                      WHERE   COMPANY_ID =  @c_carryover$company_id
                      AND     DIVISION_ID =  @c_carryover$division_id
                      AND		  SITE_ID = @c_carryover$site_id
                      AND		  PLANT_ID = @c_carryover$plant_id
                      AND		  ITEM_ID = @c_carryover$item_id
                      
                      SET @carryover$carryover_qty = 0
                      
                      BREAK;
                    
                    END
                    
                  END
                   
              END
          
          CLOSE C_CARRYOVER
          DEALLOCATE C_CARRYOVER        
              
        END
        
        -- 20190625 SHS
        -- MEET QTY / EOH 감안하여 EOH 남을시 MEET QTY 대응위해 날짜조정함
        --
        IF  @V_MASTER_ID = 'PL_FORM_A'  AND 1=2
        BEGIN
          
          DECLARE
            @c_adjust$company_id      nvarchar(50), 
            @c_adjust$division_id     nvarchar(50),
            @c_adjust$site_id         nvarchar(50), 
            @c_adjust$plant_id        nvarchar(50),
            @c_adjust$item_id         nvarchar(50),
            @c_adjust$storage_id      nvarchar(50),
            @c_adjust$soc_id          nvarchar(50),
            @c_adjust$maeket_id       nvarchar(50),
            @c_adjust$seq             integer ,
            @c_adjust$delivery_date   date , 
            @c_adjust$pack_date       date , 
            @c_adjust$form_date       date , 
            @c_adjust$delivery_qty    numeric(20,10),
            @c_adjust$pack_id         nvarchar(50),
            @c_adjust$form_id         nvarchar(50),
            @c_adjust$chk_qty         numeric(20,10) , -- = 0 
            @c_adjust$check_Date      date 
            
          DECLARE
          
            C_ADJUST CURSOR LOCAL FOR  
            
            SELECT 	COMPANY_ID , 
                    DIVISION_ID , 
                    SITE_ID , 
                    PLANT_ID , 
                    ITEM_ID , 
                    STORAGE_ID , 
                    SOC_ID , 
                    MARKET ,
                    MAX_SEQ AS SEQ , 
                    DELIVERY_DATE ,
                    PACK_DATE , 
                    FORM_DATE ,  
                    DELIVERY_QTY , 
                    PACK_ID , 
                    FORM_ID 
      			FROM (
      						SELECT  COMPANY_ID , 
			                    DIVISION_ID , 
			                    SITE_ID , 
			                    PLANT_ID , 
			                    ITEM_ID , 
			                    STORAGE_ID , 
			                    SOC_ID , 
			                    MARKET ,
			                    MAX(SEQ) OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,  SITE_ID , PLANT_ID ,  ITEM_ID , STORAGE_ID , SOC_ID , MARKET , DELIVERY_DATE) AS MAX_SEQ, SEQ , 
                          ROW_NUMBER () OVER (PARTITION BY SEQ ORDER BY DELIVERY_QTY DESC) AS R_SEQ ,
			                    DELIVERY_DATE ,
			                    PACK_DATE , 
			                    FORM_DATE ,  
			                    DELIVERY_QTY , 
			                    PACK_ID , 
			                    FORM_ID 
			            FROM    TH_BUF_CELL_DELIVERY_PEGGING
                  WHERE   ITEM_ID IN (
                                        SELECT ITEM_ID
                                        FROM (
                                              SELECT ITEM_ID , STORAGE_ID,  COUNT(STORAGE_ID) OVER (PARTITION BY ITEM_ID)  AS CNT
                                              FROM TH_BUF_CELL_DELIVERY_PEGGING
                                              GROUP BY ITEM_ID , STORAGE_ID
                                        )A
                                        WHERE A.CNT = 1
                                      )
                  )A
            WHERE MAX_SEQ = SEQ
            AND   R_SEQ = 1
            ORDER BY  COMPANY_ID , 
                      DIVISION_ID , 
                      SITE_ID , 
                      PLANT_ID , 
                      ITEM_ID , 
                      STORAGE_ID , 
                      MAX_SEQ 
            
          OPEN C_ADJUST     
          
            WHILE 1=1
              
              BEGIN
              
                FETCH C_ADJUST
                INTO    @c_adjust$company_id      , 
                        @c_adjust$division_id     ,
                        @c_adjust$site_id         , 
                        @c_adjust$plant_id        ,
                        @c_adjust$item_id         ,
                        @c_adjust$storage_id      ,
                        @c_adjust$soc_id          ,
                        @c_adjust$maeket_id       ,
                        @c_adjust$seq             ,
                        @c_adjust$delivery_date   , 
                        @c_adjust$pack_date       , 
                        @c_adjust$form_date       , 
                        @c_adjust$delivery_qty    ,
                        @c_adjust$pack_id         ,
                        @c_adjust$form_id         

                IF @@FETCH_STATUS <> 0
                  BREAK  
                
                BEGIN
                
                   -- IF @c_adjust$seq = 294
                   -- BREAK;
                    
                    SELECT @c_adjust$chk_qty = ISNULL(CASE WHEN DSUM_DELIVERY_QTY - ORG_PACK_QTY > 0 THEN  DSUM_DELIVERY_QTY - ORG_PACK_QTY
                                                           WHEN CHK_QTY < 0 AND CHK_QTY2 + CHK_QTY > 0 THEN CHK_QTY2 -- CHK_QTY2 + CHK_QTY
                                                           WHEN CHK_QTY < 0 AND CHK_QTY2 > 0 AND CHK_QTY2 + CHK_QTY < 0 THEN CHK_QTY2
                                                           --WHEN CHK_QTY > 0 AND CHK_QTY2 < 0 THEN 
                                                           ELSE 0
                                                      END , 0 )      -- 초과분 반영
                    FROM (
                          SELECT 	  A.COMPANY_ID , 
	                                  A.DIVISION_ID , 
	                                  A.SITE_ID , 
	                                  A.PLANT_ID , 
	                                  A.ITEM_ID , 
	                                  A.STORAGE_ID , 
	                                  A.SEQ , 
	                                  A.DELIVERY_DATE ,
	                                  A.PACK_DATE , 
	                                  A.FORM_DATE ,  
	                                  A.DELIVERY_QTY , PACK_ID , FORM_ID  ,
	              									  A.SUM_DELIVERY_QTY - SUM_PACK_QTY AS CHK_QTY, -- MEET QTY 계산
	              									  A.SUM_FORM_QTY -  A.SUM_DELIVERY_QTY AS CHK_QTY2 ,  -- EOH 계산
	              									  A.SUM_DELIVERY_QTY , 
	              									  a.SUM_PACK_QTY , 
	              									  SUM_FORM_QTY , 
                                    ORG_PACK_QTY , 
                                    DSUM_DELIVERY_QTY
              						FROM (
              										SELECT A.* , SUM(CASE WHEN CHK_SEQ = 1 THEN ORG_PACK_QTY ELSE 0 END ) 
              																				OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET  -- , DELIVERY_DATE
              																							ORDER BY  SEQ ) AS SUM_PACK_QTY
              															, SUM(CASE WHEN CHK_SEQ2 = 1 THEN ORG_FORM_QTY ELSE 0 END ) 
              																				OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET   --, FORM_ID
              																							ORDER BY  SEQ ) AS SUM_FORM_QTY								
              													    , SUM(DELIVERY_QTY) 
              													     						OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET --  , DELIVERY_DATE
              													     									ORDER BY  DELIVERY_DATE) AS SUM_DELIVERY_QTY
	              									          , SUM(DELIVERY_QTY ) OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID    , DELIVERY_DATE) AS DSUM_DELIVERY_QTY     -- DAILY DELIVERY QTY               
              										FROM (
                    										SELECT * ,  MAX(PACK_QTY) OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET , PACK_ID )  AS ORG_PACK_QTY , 
                    															  MAX(PLAN_QTY) OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET , FORM_ID )  AS ORG_FORM_QTY , --
                    													      ROW_NUMBER() OVER ( PARTITION BY   COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET , PACK_ID  ORDER BY SEQ) AS CHK_SEQ,
                    													      ROW_NUMBER() OVER ( PARTITION BY   COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET , FORM_ID  ORDER BY SEQ) AS CHK_SEQ2
                    										FROM TH_BUF_CELL_DELIVERY_PEGGING
                    										WHERE 1=1 
                    									  AND   COMPANY_ID  = @c_adjust$company_id
                                        AND   DIVISION_ID = @c_adjust$division_id       
                                        AND   SITE_ID =     @c_adjust$site_id                    
                                        AND   PLANT_ID =    @c_adjust$plant_id                          
                                        AND   ITEM_ID =     @c_adjust$item_id                   
                                        AND   STORAGE_ID =  @c_adjust$storage_id         
                                        AND   SEQ        <= @c_adjust$seq  
              										      )A	
              									)A	
                          )A 
                    WHERE A.SEQ =    @c_adjust$seq   
                                        
                    IF  @c_adjust$chk_qty > 0 
                    BEGIN
       
                      UPDATE TH_BUF_CELL_DELIVERY_PEGGING
                      SET  TH_BUF_CELL_DELIVERY_PEGGING.DELIVERY_QTY = TH_BUF_CELL_DELIVERY_PEGGING.DELIVERY_QTY - @c_adjust$chk_qty
                      FROM (
                            SELECT A.* 
        										FROM (
              										SELECT * ,  ISNULL(MIN(SEQ) OVER (PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET , ITEM_ID),@c_adjust$seq) AS MIN_SEQ
              										FROM TH_BUF_CELL_DELIVERY_PEGGING
              										WHERE 1=1 
              										AND   COMPANY_ID  = @c_adjust$company_id
                                  AND   DIVISION_ID = @c_adjust$division_id       
                                  AND   SITE_ID     = @c_adjust$site_id                    
                                  AND   PLANT_ID    = @c_adjust$plant_id                          
                                  AND   ITEM_ID     = @c_adjust$item_id                        
                                  AND   STORAGE_ID  = @c_adjust$storage_id                           
                                  AND   SEQ         > @c_adjust$seq
                                  AND   FORM_DATE   = @c_adjust$form_date
        										      )A	 
                            )A
                        WHERE  TH_BUF_CELL_DELIVERY_PEGGING.COMPANY_ID  = @c_adjust$company_id
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.DIVISION_ID = @c_adjust$division_id       
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.SITE_ID  = @c_adjust$site_id                    
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.PLANT_ID    = @c_adjust$plant_id                          
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.ITEM_ID     = @c_adjust$item_id                        
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.STORAGE_ID  = @c_adjust$storage_id  
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.SEQ         = A.MIN_SEQ 
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.COMPANY_ID  = A.COMPANY_ID
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.DIVISION_ID = A.DIVISION_ID       
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.SITE_ID     = A.SITE_ID                    
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.PLANT_ID    = A.PLANT_ID                          
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.ITEM_ID     = A.ITEM_ID                        
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.STORAGE_ID  = A.STORAGE_ID                           
                        
                        /*
                          요청계획이 없는 일자에 do가 할당되게 하진 않는다.
                        */
                        SELECT  @c_adjust$check_Date = ISNULL(MAX(PACK_DATE), '19890518')  
                        FROM  TH_BUF_CELL_DELIVERY_PEGGING
                        WHERE  	1=1
                        AND		COMPANY_ID  = @c_adjust$company_id
                        AND   DIVISION_ID = @c_adjust$division_id       
                        AND   SITE_ID     = @c_adjust$site_id                    
                        AND   PLANT_ID    = @c_adjust$plant_id                          
                        AND   ITEM_ID     = @c_adjust$item_id                        
                        AND   STORAGE_ID  = @c_adjust$storage_id   
                        AND		PACK_DATE   = @c_adjust$form_date
                        
                        IF @c_adjust$check_Date = '19890518'
                        BEGIN
                        
                          SELECT  @c_adjust$form_date = ISNULL(MIN(PACK_DATE), @c_adjust$form_date)  
                          FROM  TH_BUF_CELL_DELIVERY_PEGGING
                          WHERE  	1=1
                          AND		COMPANY_ID  = @c_adjust$company_id
                          AND   DIVISION_ID = @c_adjust$division_id       
                          AND   SITE_ID     = @c_adjust$site_id                    
                          AND   PLANT_ID    = @c_adjust$plant_id                          
                          AND   ITEM_ID     = @c_adjust$item_id                        
                          AND   STORAGE_ID  = @c_adjust$storage_id   
                          AND		PACK_DATE   >= @c_adjust$form_date
                        
                        END
                        
                        
                        INSERT INTO TH_BUF_CELL_DELIVERY_PEGGING 
                                (
                                  COMPANY_ID,
                                  DIVISION_ID,
                                  SITE_ID,
                                  PLANT_ID,
                                  ITEM_ID,
                                  STORAGE_ID,
                                  SOC_ID,
                                  MARKET,
                                  DELIVERY_DATE,
                                  PACK_DATE,
                                  FORM_DATE,
                                  DELIVERY_QTY,
                                  SEQ,
                                  PACK_ID,
                                  FORM_ID
                                )
                        SELECT  @c_adjust$company_id           AS COMPANY_ID, 
                                @c_adjust$division_id          AS DIVISION_ID,
                                @c_adjust$site_id              AS SITE_ID,
                                @c_adjust$plant_id             AS PLANT_ID,
                                @c_adjust$item_id              AS ITEM_ID,
                                @c_adjust$storage_id           AS STORAGE_ID,
                                @c_adjust$soc_id               AS SOC_ID,
                                @c_adjust$maeket_id            AS MARKET ,
                                @c_adjust$form_date            AS DELIVERY_DATE,
                                @c_adjust$form_date            AS PACK_DATE,
                                @c_adjust$form_date            AS FORM_DATE,
                                @c_adjust$chk_qty              AS DELEIVERY_QTY,
                                @c_adjust$seq                  AS SEQ ,
                                @c_adjust$pack_id              AS PACK_ID,
                                @c_adjust$form_id              AS FORM_ID 
                        
                        
                    END      
                
                END
              
              END
              
          CLOSE C_ADJUST
          DEALLOCATE C_ADJUST     
          
          --------
        /*
          SEQ 기준 정렬
        */  
        IF  @V_MASTER_ID = 'PL_FORM_A'  AND 1=2
        BEGIN
          
            DECLARE @loop_cnt INTEGER 
            
            DECLARE
            
              C_ADJUST2 CURSOR LOCAL FOR  
              
              SELECT 	COMPANY_ID , 
                      DIVISION_ID , 
                      SITE_ID , 
                      PLANT_ID , 
                      ITEM_ID , 
                      STORAGE_ID , 
                      SOC_ID , 
                      MARKET ,
                      MAX_SEQ AS SEQ , 
                      DELIVERY_DATE ,
                      PACK_DATE , 
                      FORM_DATE ,  
                      DELIVERY_QTY , 
                      PACK_ID , 
                      FORM_ID 
        			FROM (
        						SELECT  COMPANY_ID , 
  			                    DIVISION_ID , 
  			                    SITE_ID , 
  			                    PLANT_ID , 
  			                    ITEM_ID , 
  			                    STORAGE_ID , 
  			                    SOC_ID , 
  			                    MARKET ,
  			                    MAX(SEQ) OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,  SITE_ID , PLANT_ID ,  ITEM_ID , STORAGE_ID , SOC_ID , MARKET , DELIVERY_DATE) AS MAX_SEQ, SEQ , 
  			                    ROW_NUMBER () OVER (PARTITION BY SEQ ORDER BY DELIVERY_QTY) AS R_SEQ ,
                            DELIVERY_DATE ,
  			                    PACK_DATE , 
  			                    FORM_DATE ,  
  			                    DELIVERY_QTY , 
  			                    PACK_ID , 
  			                    FORM_ID 
  			            FROM    TH_BUF_CELL_DELIVERY_PEGGING
                    )A
              WHERE MAX_SEQ = SEQ
              AND   R_SEQ = 1
              AND   ITEM_ID IN (
                                SELECT ITEM_ID
                                FROM (
                                      SELECT ITEM_ID , STORAGE_ID,  COUNT(STORAGE_ID) OVER (PARTITION BY ITEM_ID)  AS CNT
                                      FROM TH_BUF_CELL_DELIVERY_PEGGING
                                      GROUP BY ITEM_ID , STORAGE_ID
                                      )A
                                WHERE A.CNT = 1
                                )
              ORDER BY  COMPANY_ID , 
                        DIVISION_ID , 
                        SITE_ID , 
                        PLANT_ID , 
                        ITEM_ID , 
                        STORAGE_ID , 
                        MAX_SEQ 
              
            OPEN C_ADJUST2     
            
              WHILE 1=1
                
                BEGIN
                
                  FETCH C_ADJUST2
                  INTO    @c_adjust$company_id      , 
                          @c_adjust$division_id     ,
                          @c_adjust$site_id         , 
                          @c_adjust$plant_id        ,
                          @c_adjust$item_id         ,
                          @c_adjust$storage_id      ,
                          @c_adjust$soc_id          ,
                          @c_adjust$maeket_id       ,
                          @c_adjust$seq             ,
                          @c_adjust$delivery_date   , 
                          @c_adjust$pack_date       , 
                          @c_adjust$form_date       , 
                          @c_adjust$delivery_qty    ,
                          @c_adjust$pack_id         ,
                          @c_adjust$form_id         

                  IF @@FETCH_STATUS <> 0
                    BREAK  
                  
                  SET @loop_cnt = 1
                  
                  --WHILE @loop_cnt <= 2
                  BEGIN
                  
                      --IF @c_adjust$seq  = 19
                      --BREAK;
                      
                      SELECT @c_adjust$chk_qty = ISNULL(CASE WHEN CHK_QTY > 0 THEN CHK_QTY 
                                                             ELSE 0
                                                        END , 0 )      -- 초과분 반영
                      FROM (
                            SELECT 	  A.COMPANY_ID , 
  	                                  A.DIVISION_ID , 
  	                                  A.SITE_ID , 
  	                                  A.PLANT_ID , 
  	                                  A.ITEM_ID , 
  	                                  A.STORAGE_ID , 
  	                                  A.SEQ , 
  	                                  A.DELIVERY_DATE ,
  	                                  A.PACK_DATE , 
  	                                  A.FORM_DATE ,  
  	                                  A.DELIVERY_QTY , PACK_ID , FORM_ID  ,
  	              									  A.SUM_DELIVERY_QTY - SUM_PACK_QTY AS CHK_QTY, -- MEET QTY 계산
  	              									  A.SUM_FORM_QTY -  A.SUM_DELIVERY_QTY AS CHK_QTY2 ,  -- EOH 계산
  	              									  A.SUM_DELIVERY_QTY , 
  	              									  a.SUM_PACK_QTY , 
  	              									  SUM_FORM_QTY , 
                                      ORG_PACK_QTY , 
                                      DSUM_DELIVERY_QTY
                						FROM (
                										SELECT A.* , SUM(CASE WHEN CHK_SEQ = 1 THEN ORG_PACK_QTY ELSE 0 END ) 
                																				OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET  -- , DELIVERY_DATE
                																							ORDER BY  SEQ ) AS SUM_PACK_QTY
                															, SUM(CASE WHEN CHK_SEQ2 = 1 THEN ORG_FORM_QTY ELSE 0 END ) 
                																				OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET   --, FORM_ID
                																							ORDER BY  SEQ ) AS SUM_FORM_QTY								
                													    , SUM(DELIVERY_QTY) 
                													     						OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET --  , DELIVERY_DATE
                													     									ORDER BY  DELIVERY_DATE) AS SUM_DELIVERY_QTY
  	              									          , SUM(DELIVERY_QTY ) OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID    , DELIVERY_DATE) AS DSUM_DELIVERY_QTY     -- DAILY DELIVERY QTY               
                										FROM (
                      										SELECT * ,  MAX(PACK_QTY) OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET , PACK_ID )  AS ORG_PACK_QTY , 
                      															  MAX(PLAN_QTY) OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET , FORM_ID )  AS ORG_FORM_QTY , --
                      													      ROW_NUMBER() OVER ( PARTITION BY   COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET , PACK_ID  ORDER BY SEQ) AS CHK_SEQ,
                      													      ROW_NUMBER() OVER ( PARTITION BY   COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET , FORM_ID  ORDER BY SEQ) AS CHK_SEQ2
                      										FROM TH_BUF_CELL_DELIVERY_PEGGING
                      										WHERE 1=1 
                      									  AND   COMPANY_ID  = @c_adjust$company_id
                                          AND   DIVISION_ID = @c_adjust$division_id       
                                          AND   SITE_ID =     @c_adjust$site_id                    
                                          AND   PLANT_ID =    @c_adjust$plant_id                          
                                          AND   ITEM_ID =     @c_adjust$item_id                   
                                          AND   STORAGE_ID =  @c_adjust$storage_id                           
                                          AND   SEQ        <= @c_adjust$seq  
                                          --AND   DELIVERY_DATE = @c_adjust$delivery_date
                										      )A	
                									)A	
                            )A 
                      WHERE A.SEQ =    @c_adjust$seq   
                      
                                          
                      IF  @c_adjust$chk_qty > 0 
                      BEGIN
                         
                        /*
                          과요청 DO 뺀다 
                        */
                          
                        UPDATE TH_BUF_CELL_DELIVERY_PEGGING
                        SET  TH_BUF_CELL_DELIVERY_PEGGING.DELIVERY_QTY = TH_BUF_CELL_DELIVERY_PEGGING.DELIVERY_QTY - @c_adjust$chk_qty
                        WHERE  TH_BUF_CELL_DELIVERY_PEGGING.COMPANY_ID  = @c_adjust$company_id
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.DIVISION_ID = @c_adjust$division_id       
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.SITE_ID     = @c_adjust$site_id                    
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.PLANT_ID    = @c_adjust$plant_id                          
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.ITEM_ID     = @c_adjust$item_id                        
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.STORAGE_ID  = @c_adjust$storage_id  
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.FORM_DATE   = @c_adjust$delivery_date
                        AND	   TH_BUF_CELL_DELIVERY_PEGGING.DELIVERY_QTY = (SELECT MAX(DELIVERY_QTY) 
                                                                            FROM TH_BUF_CELL_DELIVERY_PEGGING  
                                                                            WHERE ITEM_ID     = @c_adjust$item_id   
                                                                            AND   FORM_DATE   = @c_adjust$delivery_date
                                                                            AND   SEQ         = @c_adjust$seq
                                                                            )
                                                                                                                             
                          
                        SELECT  @c_adjust$form_date = ISNULL(MIN(DELIVERY_DATE), @c_adjust$form_date)  
                        FROM  TH_BUF_CELL_DELIVERY_PEGGING
                        WHERE  	1=1
                        AND		COMPANY_ID  = @c_adjust$company_id
                        AND   DIVISION_ID = @c_adjust$division_id       
                        AND   SITE_ID     = @c_adjust$site_id                    
                        AND   PLANT_ID    = @c_adjust$plant_id                          
                        AND   ITEM_ID     = @c_adjust$item_id                        
                        AND   STORAGE_ID  = @c_adjust$storage_id   
                        AND		DELIVERY_DATE   > @c_adjust$form_date
                        AND   SEQ > @c_adjust$seq
                        
                          
                        INSERT INTO TH_BUF_CELL_DELIVERY_PEGGING 
                                (
                                  COMPANY_ID,
                                  DIVISION_ID,
                                  SITE_ID,
                                  PLANT_ID,
                                  ITEM_ID,
                                  STORAGE_ID,
                                  SOC_ID,
                                  MARKET,
                                  DELIVERY_DATE,
                                  PACK_DATE,
                                  FORM_DATE,
                                  DELIVERY_QTY,
                                  SEQ,
                                  PACK_ID,
                                  FORM_ID
                                )
                        SELECT  @c_adjust$company_id           AS COMPANY_ID, 
                                @c_adjust$division_id          AS DIVISION_ID,
                                @c_adjust$site_id              AS SITE_ID,
                                @c_adjust$plant_id             AS PLANT_ID,
                                @c_adjust$item_id              AS ITEM_ID,
                                @c_adjust$storage_id           AS STORAGE_ID,
                                @c_adjust$soc_id               AS SOC_ID,
                                @c_adjust$maeket_id            AS MARKET ,
                                @c_adjust$form_date            AS DELIVERY_DATE,
                                @c_adjust$form_date            AS PACK_DATE,
                                @c_adjust$form_date            AS FORM_DATE,
                                @c_adjust$chk_qty              AS DELEIVERY_QTY,
                                @c_adjust$seq                  AS SEQ ,
                                @c_adjust$pack_id              AS PACK_ID,
                                @c_adjust$form_id              AS FORM_ID 
                          
                          
                      END      
                  
                  END
                
                END
                
            CLOSE C_ADJUST2
            DEALLOCATE C_ADJUST2  
          END
          
          /*
            일자기준 정렬 
          */
          IF  @V_MASTER_ID = 'PL_FORM_A'  AND 1=2
          BEGIN
          
            DECLARE
            
              C_ADJUST3 CURSOR LOCAL FOR  
              
              SELECT 	COMPANY_ID , 
                      DIVISION_ID , 
                      SITE_ID , 
                      PLANT_ID , 
                      ITEM_ID , 
                      STORAGE_ID , 
                      SOC_ID , 
                      MARKET ,
                      MAX_SEQ AS SEQ , 
                      DELIVERY_DATE ,
                      PACK_ID , 
                      FORM_ID 
        			FROM (
        						SELECT   COMPANY_ID , 
				  			                    DIVISION_ID , 
				  			                    SITE_ID , 
				  			                    PLANT_ID , 
				  			                    ITEM_ID , 
				  			                    STORAGE_ID , 
				  			                    SOC_ID , 
				  			                    MARKET ,
				  			                    MAX(SEQ)AS MAX_SEQ , 
				                            	DELIVERY_DATE ,
				  			                    MAX(PACK_ID) AS PACK_ID , 
				  			                    MAX(FORM_ID) AS FORM_ID
		  			            FROM    TH_BUF_CELL_DELIVERY_PEGGING
		  			            GROUP BY 		COMPANY_ID , 
						  			  DIVISION_ID , 
						  			                    SITE_ID , 
						  			                    PLANT_ID , 
						  			                    ITEM_ID , 
						  			                    STORAGE_ID , 
						  			                    SOC_ID , 
						  			                    MARKET ,
						  			                    DELIVERY_DATE	                    
                    )A
              WHERE 1=1 
              AND   ITEM_ID IN (
                                SELECT ITEM_ID
                                FROM (
                                      SELECT ITEM_ID , STORAGE_ID,  COUNT(STORAGE_ID) OVER (PARTITION BY ITEM_ID)  AS CNT
                                      FROM TH_BUF_CELL_DELIVERY_PEGGING
                                      GROUP BY ITEM_ID , STORAGE_ID
                                      )A
                                WHERE A.CNT = 1
                                )
             -- AND ITEM_ID = 'ACEN1058I-B1-A02'
              ORDER BY  COMPANY_ID , 
                        DIVISION_ID , 
                        SITE_ID , 
                        PLANT_ID , 
                        ITEM_ID , 
                        STORAGE_ID , 
                        MAX_SEQ 
              
            OPEN C_ADJUST3     
            
              WHILE 1=1
                
                BEGIN
                
                  FETCH C_ADJUST3
                  INTO    @c_adjust$company_id      , 
                          @c_adjust$division_id     ,
                          @c_adjust$site_id         , 
                          @c_adjust$plant_id        ,
                          @c_adjust$item_id         ,
                          @c_adjust$storage_id      ,
                          @c_adjust$soc_id          ,
                          @c_adjust$maeket_id       ,
                          @c_adjust$seq             ,
                          @c_adjust$delivery_date   , 
                          @c_adjust$pack_id         ,
                          @c_adjust$form_id         

                  IF @@FETCH_STATUS <> 0
                    BREAK  
                  
                  SET @loop_cnt = 1
                  
                  --WHILE @loop_cnt <= 2
                  BEGIN
                  
                      --IF @c_adjust$seq  = 19
                      --BREAK;
                      
                      SELECT @c_adjust$chk_qty = ISNULL(CASE WHEN MAX(CHK_QTY) > 0 AND MIN(CHK_QTY2) < 0 THEN MAX(CHK_QTY )
                                                             ELSE 0
                                                        END , 0 )      -- 초과분 반영
                      FROM (
                            SELECT 	  A.COMPANY_ID , 
  	                                  A.DIVISION_ID , 
  	                                  A.SITE_ID , 
  	                                  A.PLANT_ID , 
  	                                  A.ITEM_ID , 
  	                                  A.STORAGE_ID , 
  	                                  A.SEQ , 
  	                                  A.DELIVERY_DATE ,
  	                                  A.PACK_DATE , 
  	                                  A.FORM_DATE ,  
  	                                  A.DELIVERY_QTY , PACK_ID , FORM_ID  ,
  	              									  A.SUM_DELIVERY_QTY - SUM_PACK_QTY AS CHK_QTY, -- MEET QTY 계산
  	              									  A.SUM_FORM_QTY -  A.SUM_DELIVERY_QTY AS CHK_QTY2 ,  -- EOH 계산
  	              									  A.SUM_DELIVERY_QTY , 
  	              									  a.SUM_PACK_QTY , 
  	              									  SUM_FORM_QTY , 
                                      ORG_PACK_QTY , 
                                      DSUM_DELIVERY_QTY
                						FROM (
                										SELECT A.* , SUM(CASE WHEN CHK_SEQ = 1 THEN ORG_PACK_QTY ELSE 0 END ) 
                																				OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET  -- , DELIVERY_DATE
                																							ORDER BY  DELIVERY_DATE ) AS SUM_PACK_QTY
                															, SUM(CASE WHEN CHK_SEQ2 = 1 THEN ORG_FORM_QTY ELSE 0 END ) 
                																				OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET   --, FORM_ID
                																							ORDER BY  FORM_DATE ) AS SUM_FORM_QTY								
                													    , SUM(DELIVERY_QTY) 
                													     						OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET --  , DELIVERY_DATE
                													     									ORDER BY  DELIVERY_DATE) AS SUM_DELIVERY_QTY
  	              									          , SUM(DELIVERY_QTY ) OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID    , DELIVERY_DATE) AS DSUM_DELIVERY_QTY     -- DAILY DELIVERY QTY               
                										FROM (
                      										SELECT * ,  MAX(PACK_QTY) OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET , PACK_ID )  AS ORG_PACK_QTY , 
                      															  MAX(PLAN_QTY) OVER ( PARTITION BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET , FORM_ID )  AS ORG_FORM_QTY , --
                      													      ROW_NUMBER() OVER ( PARTITION BY   COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET , PACK_ID  ORDER BY SEQ) AS CHK_SEQ,
                      													      ROW_NUMBER() OVER ( PARTITION BY   COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , ITEM_ID , STORAGE_ID , SOC_ID , MARKET , FORM_ID  ORDER BY SEQ) AS CHK_SEQ2
                      										FROM TH_BUF_CELL_DELIVERY_PEGGING
                      										WHERE 1=1 
                      									  AND   COMPANY_ID  = @c_adjust$company_id
                                          AND   DIVISION_ID = @c_adjust$division_id       
                                          AND   SITE_ID =     @c_adjust$site_id                    
                                          AND   PLANT_ID =    @c_adjust$plant_id                          
                                          AND   ITEM_ID =     @c_adjust$item_id                   
                                          AND   STORAGE_ID =  @c_adjust$storage_id                           
                                          --AND   SEQ        <= @c_adjust$seq  
                                          AND   DELIVERY_DATE = @c_adjust$delivery_date
                										      )A	
                									)A	
                            )A 
                      --WHERE A.SEQ =    @c_adjust$seq   
                      
                                     
                       --LOG 생성
                        SET @v_message ='select' +  convert(nvarchar,@c_adjust$seq) +'-' + @c_adjust$item_id
                        SET @n_log_count = @n_log_count + 1
                        SET @sysdate = GETDATE()
                        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, @v_message, @n_log_count, null, 'ALL', null      
                      
                      --SET @loop_cnt = @loop_cnt + 1
                      
                      --IF @loop_cnt = 2 AND @c_adjust$chk_qty = 0 
                      --BREAK;
                      
                                          
                      IF  @c_adjust$chk_qty > 0 
                      BEGIN
                         
                        /*
                          과요청 DO 뺀다 
                        */
                          
                        UPDATE TH_BUF_CELL_DELIVERY_PEGGING
                        SET  TH_BUF_CELL_DELIVERY_PEGGING.DELIVERY_QTY = TH_BUF_CELL_DELIVERY_PEGGING.DELIVERY_QTY - @c_adjust$chk_qty
                        WHERE  TH_BUF_CELL_DELIVERY_PEGGING.COMPANY_ID  = @c_adjust$company_id
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.DIVISION_ID = @c_adjust$division_id       
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.SITE_ID     = @c_adjust$site_id                    
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.PLANT_ID    = @c_adjust$plant_id                          
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.ITEM_ID     = @c_adjust$item_id                        
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.STORAGE_ID  = @c_adjust$storage_id  
                        AND    TH_BUF_CELL_DELIVERY_PEGGING.FORM_DATE   = @c_adjust$delivery_date
                        AND	   TH_BUF_CELL_DELIVERY_PEGGING.DELIVERY_QTY = (SELECT MAX(DELIVERY_QTY) 
                                                                            FROM TH_BUF_CELL_DELIVERY_PEGGING  
                                                                            WHERE ITEM_ID     = @c_adjust$item_id   
                                                                            AND   FORM_DATE   = @c_adjust$delivery_date
                                                                            --AND   SEQ         = @c_adjust$seq
                                                                            )
                                                                            
                        IF @c_adjust$seq  = 8
                        BEGIN

                        SET @v_message = CONVERT(NVARCHAR,@c_adjust$form_date,112) + '-' +  CONVERT(NVARCHAR,@c_adjust$chk_qty) 
                        SET @n_log_count = @n_log_count + 1
                        SET @sysdate = GETDATE()
                        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
                        
                        END                                                     
                          
                        SELECT  @c_adjust$form_date = ISNULL(MIN(DELIVERY_DATE), @c_adjust$delivery_date)  
                        FROM  TH_BUF_CELL_DELIVERY_PEGGING
                        WHERE  	1=1
                        AND		COMPANY_ID  = @c_adjust$company_id
                        AND   DIVISION_ID = @c_adjust$division_id       
                        AND   SITE_ID     = @c_adjust$site_id                    
                        AND   PLANT_ID    = @c_adjust$plant_id                          
                        AND   ITEM_ID     = @c_adjust$item_id                        
                        AND   STORAGE_ID  = @c_adjust$storage_id   
                        AND		DELIVERY_DATE   > @c_adjust$delivery_date
                        --AND   SEQ > @c_adjust$seq
                        
                        IF @c_adjust$seq  = 8
                        BEGIN

                        SET @v_message = CONVERT(NVARCHAR,@c_adjust$form_date,112) + '-' +  CONVERT(NVARCHAR,@c_adjust$chk_qty) 
                        SET @n_log_count = @n_log_count + 1
                        SET @sysdate = GETDATE()
                        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
                        
                        END  
                          
                        INSERT INTO TH_BUF_CELL_DELIVERY_PEGGING 
                                (
                                  COMPANY_ID,
                                  DIVISION_ID,
                                  SITE_ID,
                                  PLANT_ID,
                                  ITEM_ID,
                                  STORAGE_ID,
                                  SOC_ID,
                                  MARKET,
                                  DELIVERY_DATE,
                                  PACK_DATE,
                                  FORM_DATE,
                                  DELIVERY_QTY,
                                  SEQ,
                                  PACK_ID,
                                  FORM_ID
                                )
                        SELECT  @c_adjust$company_id           AS COMPANY_ID, 
                                @c_adjust$division_id          AS DIVISION_ID,
                                @c_adjust$site_id              AS SITE_ID,
                                @c_adjust$plant_id             AS PLANT_ID,
                                @c_adjust$item_id              AS ITEM_ID,
                                @c_adjust$storage_id           AS STORAGE_ID,
                                @c_adjust$soc_id               AS SOC_ID,
                                @c_adjust$maeket_id            AS MARKET ,
                                @c_adjust$form_date            AS DELIVERY_DATE,
                                @c_adjust$form_date            AS PACK_DATE,
                                @c_adjust$form_date            AS FORM_DATE,
                                @c_adjust$chk_qty              AS DELEIVERY_QTY,
                                @c_adjust$seq                  AS SEQ ,
                                @c_adjust$pack_id              AS PACK_ID,
                                @c_adjust$form_id              AS FORM_ID 
                          
                          
                      END      
                  
                  END
                
                END
                
            CLOSE C_ADJUST3
            DEALLOCATE C_ADJUST3  
          END
          
          ----------
        
        END
        
         /*
        특정 MODEL 만 CALCULATION 저장 
        */
        BEGIN
        
          SET @v_table_name = 'TH_BUF_CELL_DELIVERY_PEGGING'
          SET @n_row_count = 0
          
          IF @v_cal_option = 'ALL'
          BEGIN
          
            UPDATE TH_BUF_CELL_DELIVERY_PEGGING
            SET IS_CAL ='Y'
            --WHERE INSTANCE_ID = @v_master_id
            
             --LOG 생성
            SET @v_message = @n_row_count
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, 'ALL', null
          
          END
          ELSE
          BEGIN
          
            UPDATE TH_BUF_CELL_DELIVERY_PEGGING
            SET   TH_BUF_CELL_DELIVERY_PEGGING.IS_CAL= 'Y'
            FROM (
            				SELECT INSTANCE_ID , COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , ITEM_ID 
      							FROM FP_CELL_DELIVERY_PLAN_H
      							WHERE 1=1 
                    --AND  DELIVERY_DATE >= @v_cutoff_date
                    AND  INSTANCE_ID = @v_master_id
                    AND  PLAN_ID = @v_plan_id
      							AND  IS_CAL = 'Y'
      							GROUP BY  INSTANCE_ID , COMPANY_ID , INSTANCE_ID , DIVISION_ID , SITE_ID , PLANT_ID , ITEM_ID 
            			)A
            WHERE   TH_BUF_CELL_DELIVERY_PEGGING.COMPANY_ID = A.COMPANY_ID
            AND 		TH_BUF_CELL_DELIVERY_PEGGING.DIVISION_ID  = A.DIVISION_ID
            AND 		TH_BUF_CELL_DELIVERY_PEGGING.SITE_ID = A.SITE_ID
            AND		  TH_BUF_CELL_DELIVERY_PEGGING.PLANT_ID = A.PLANT_ID
            AND		  TH_BUF_CELL_DELIVERY_PEGGING.ITEM_ID = A.ITEM_ID
            
            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, 'IS_CAL', null
          
          END
        
        END
        
        IF @v_master_id = 'PL_FORM_A'
        BEGIN
        
            UPDATE  TH_BUF_CELL_DELIVERY_PEGGING
            SET ITEM_ID = SUBSTRING(FORM_ID,1,CHARINDEX('##',FORM_ID) -1)
            
            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, 'FORM_ID', null
            

        END
        
        BEGIN
        
          SET @v_table_name = 'FP_CELL_DELIVERY_PLAN_H'
          SET @n_row_count = 0
          
          DELETE FP_CELL_DELIVERY_PLAN_H
          WHERE INSTANCE_ID = @v_master_id 
          AND   INSERT_TIME < DATEADD(DAY, -14, GETDATE())
        
          DELETE FP_CELL_DELIVERY_PLAN_H 
          WHERE INSTANCE_ID = @v_master_id 
          AND   PLAN_ID = @v_plan_id
         -- AND   DELIVERY_DATE >= @v_date
          AND   ( IS_CAL = 'Y' OR @v_cal_option ='ALL')
          
          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
          
          
          INSERT INTO FP_CELL_DELIVERY_PLAN_H
                  (
                    INSTANCE_ID ,
                    PLAN_ID ,
                    COMPANY_ID ,
                    DIVISION_ID ,
                    SITE_ID ,
                    PLANT_ID ,
                    ITEM_ID ,
                    STORAGE_ID , 
                    SOC_ID ,
                    MARKET ,
                    DELIVERY_DATE ,
                    ORG_DELIVERY_QTY ,
                    DELIVERY_QTY ,
                    INSERT_ID ,
                    INSERT_TIME ,
                    UPDATE_ID ,
                    UPDATE_TIME ,
                    MOQ
                  )
          SELECT  	@v_master_id AS INSTANCE_ID , 
              			@v_plan_id  as PLAN_ID,
              			COMPANY_ID , 
              			DIVISION_ID ,
              			SITE_ID , 
              			PLANT_ID , 
              			ITEM_ID , 
              			STORAGE_ID , 
              			SOC_ID , 
              			MARKET , 
              			DELIVERY_DATE , 
              			DELIVERY_QTY AS ORG_DEIVERY_QTY ,
              			DELIVERY_QTY,
              			@v_proc_name AS INSERT_ID , 
	                	GETDATE() INSERT_TIME,
	                	@v_proc_name AS UPDATE_ID,
	                	GETDATE() UPDATE_TIME,
          					MOQ
          FROM FP_CELL_DELIVERY_PLAN_FIX_H A
          WHERE INSTANCE_ID = @v_master_id 
          AND   PLAN_ID = @v_confirm_id
          AND   DELIVERY_DATE <= @v_fix_date
          AND ( @v_cal_option ='ALL' OR EXISTS (
                                                SELECT 1
                                                FROM TH_BUF_CELL_DELIVERY_PEGGING X
                                                WHERE X.IS_CAL ='Y'
                                                --AND   A.INSTANCE_ID = X.INSTANCE_ID
                                                AND   A.COMPANY_ID = X.COMPANY_ID 
                                                AND   A.DIVISION_ID =X.DIVISION_ID
                                                AND   A.SITE_ID = X.SITE_ID
                                                AND   A.PLANT_ID = X.PLANT_ID
                                                AND   A.ITEM_ID = X.ITEM_ID
                                                ) 
              )
              
          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null    
          
          INSERT INTO FP_CELL_DELIVERY_PLAN_H
                  (
                   INSTANCE_ID ,
                    PLAN_ID ,
                    COMPANY_ID ,
                    DIVISION_ID ,
                    SITE_ID ,
                    PLANT_ID ,
                    ITEM_ID ,
                    STORAGE_ID , 
                    SOC_ID ,
                    MARKET ,
                    DELIVERY_DATE ,
                    ORG_DELIVERY_QTY ,
                    DELIVERY_QTY ,
                    INSERT_ID ,
                    INSERT_TIME ,
                    UPDATE_ID ,
                    UPDATE_TIME ,
                    MOQ
                  )
         /* SELECT  @V_MASTER_ID AS INSTANCE_ID , 
                  @v_plan_id  AS PLAN_ID,
                	COMPANY_ID , 
                	DIVISION_ID, 
                	SITE_ID , 
                	PLANT_ID, 
                	ITEM_ID   , 
                	STORAGE_ID,
                	SOC_ID  , 
                	MARKET, 
                	R_DELIVERY_DATE ,
                	SUM(DELIVERY_QTY) AS   ORG_DELIVERY_QTY,
                	SUM(DELIVERY_QTY) AS DELIVERY_QTY,
                	@v_proc_name AS INSERT_ID , 
                	GETDATE() AS INSERT_TIME,
                	@v_proc_name AS UPDATE_ID,
                	GETDATE() AS UPDATE_TIME,
                  DBO.FN_GET_BOX_TOTL_CELL_QTY(DIVISION_ID,'',ITEM_ID,'')  AS MOQ
          FROM (
        				select a.*  , case when  sum_delivery_Qty - sum_pack_qty  < 0 AND sum_pack_qty - sum_delivery_Qty   < DELIVERY_QTY   then form_date else delivery_date end as r_delivery_date --, delivery_date , sum_delivery_Qty - sum_pack_qty 
                from (
                			select a.* , sum(case when chk_seq = 1 then org_pack_qty else 0 end ) over ( partition by company_id , division_id ,site_id , plant_id , item_id , storage_id , soc_id , market   order by  delivery_date) as sum_pack_qty
                						    , sum(delivery_Qty) over ( partition by company_id , division_id ,site_id , plant_id , item_id , storage_id , soc_id , market   order by  delivery_date) as sum_delivery_Qty
                			from (
                      			select * , --sum(pack_qty) over ( partition by company_id , division_id ,site_id , plant_id , item_id , storage_id , soc_id , market , pack_id   order by delivery_date ) , 
                      						    max(pack_qty) over ( partition by company_id , division_id ,site_id , plant_id , item_id , storage_id , soc_id , market , pack_id )  as org_pack_qty , 
                      						    row_number() over ( partition by   company_id , division_id ,site_id , plant_id , item_id , storage_id , soc_id , market , pack_id  order by pack_qty) as chk_seq
                      						   --sum(delivery_qty) over ( partition by company_id , division_id ,site_id , plant_id , item_id , storage_id , soc_id , market  order by delivery_date )
                      			from TH_BUF_CELL_DELIVERY_PEGGING
                      			--WHERE COMPANY_ID = 'G480'
                      			--and item_id = 'ACEN1058I-B1-A02'
                      			)a
                      )a
          		  )A
          WHERE 1=1
          AND IS_CAL ='Y'
          AND DELIVERY_DATE > @v_fix_date
          GROUP BY  COMPANY_ID ,
                    DIVISION_ID ,
                    SITE_ID ,
                    PLANT_ID ,
                    ITEM_ID ,
                    STORAGE_ID ,
                    SOC_ID ,
                    MARKET ,
                    R_DELIVERY_DATE     */          
        SELECT  @V_MASTER_ID AS INSTANCE_ID , 
                  @v_plan_id  AS PLAN_ID,
                	COMPANY_ID , 
                	DIVISION_ID, 
                	SITE_ID , 
                	PLANT_ID, 
                	ITEM_ID   , 
                	STORAGE_ID,
                	SOC_ID  , 
                	MARKET, 
                	DELIVERY_DATE ,
                	SUM(DELIVERY_QTY) AS   ORG_DELIVERY_QTY,
                	SUM(DELIVERY_QTY) AS DELIVERY_QTY,
                	@v_proc_name AS INSERT_ID , 
                	GETDATE() AS INSERT_TIME,
                	@v_proc_name AS UPDATE_ID,
                	GETDATE() AS UPDATE_TIME,
                  DBO.FN_GET_BOX_TOTL_CELL_QTY(DIVISION_ID,'',ITEM_ID,'')  AS MOQ
          FROM TH_BUF_CELL_DELIVERY_PEGGING
          WHERE 1=1
          AND IS_CAL ='Y'
          AND DELIVERY_DATE > @v_fix_date
          GROUP BY  COMPANY_ID ,
                    DIVISION_ID ,
                    SITE_ID ,
                    PLANT_ID ,
                    ITEM_ID ,
                    STORAGE_ID ,
                    SOC_ID ,
                    MARKET ,
                    DELIVERY_DATE 
                    
                    
                    
           --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null       
          
          BEGIN
          
          UPDATE FP_CELL_DELIVERY_PLAN_H
          SET IS_CAL ='N'
          WHERE INSTANCE_ID = @v_master_id
          AND   PLAN_ID = @v_plan_id 
        
          END
        
        END
      
      
      END
      
      ELSE IF @v_copy_flag = 'Y'
      BEGIN
      
        SELECT @v_basis_plan_id = PLAN_ID
        FROM (
  	          SELECT INSTANCE_ID , PLAN_ID , RANK() OVER (ORDER BY UPDATE_TIME DESC) AS SEQ
  	          FROM    SCM_FP_IN_HOUSE_PLAN_H
  	      	  WHERE   INSTANCE_ID = @V_MASTER_ID 
              AND     CONFIRM_FLAG = 'Y'
    				  )A
    	  WHERE SEQ = 1	
      
        SELECT @v_seq = ISNULL(MAX(CONVERT(NUMERIC, SEQ)) + 1,1)
        FROM  SCM_FP_IN_HOUSE_PLAN_H
        WHERE   INSTANCE_ID = @V_MASTER_ID 
        AND     PLAN_DATE = CONVERT(NVARCHAR,@v_target_date,112)
        
        INSERT INTO SCM_FP_IN_HOUSE_PLAN_H
          (
            INSTANCE_ID ,
            PLAN_ID ,
            FIX_DATE ,
            CONFIRM_FLAG ,
            DESCRIPTION ,
            PLAN_DATE ,
            SEQ , 
            INSERT_ID , 
            INSERT_TIME ,
            UPDATE_ID ,
            UPDATE_TIME , 
            PACK_CONFIRM_ID
          )
        SELECT  @v_master_id  AS INSTANCE_ID , 
                CONVERT(NVARCHAR,@v_target_date,112) +'-'  + DBO.FN_LPAD_NVARCHAR( @v_seq,2,0) AS PLAN_ID  , 
                @v_fix_date AS FIX_DATE , 
                'N' AS CONFIRM_FLAG , 
      				  @v_basis_plan_id AS DESCRIPTION , 
                CONVERT(NVARCHAR,@v_target_date,112) AS PLAN_DATE ,   
                @v_seq AS SEQ,  -- DBO.FN_LPAD_NVARCHAR( @v_seq,2,0)  AS SEQ , 
                @p_user_id AS INSERT_ID , 
        				GETDATE() AS INSERT_TIME , @p_user_id AS UPDATE_ID , GETDATE() AS UPDATE_TIME , @v_pack_confirm_id	
        FROM  SCM_FP_IN_HOUSE_PLAN_H
        WHERE   INSTANCE_ID = @v_master_id 
        AND     PLAN_ID = @v_basis_plan_id
        
        --LOG 생성
        SET @v_message =  'CREATE COPY PLAN INFO : ' + convert(nvarchar,@n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
        SELECT  @v_plan_id = PLAN_ID
        FROM    SCM_FP_IN_HOUSE_PLAN_H
        WHERE   INSTANCE_ID = @v_master_id 
        AND     DESCRIPTION = @v_basis_plan_id
        
        --LOG 생성
        SET @v_message =  'PLAN_ID : ' + @v_plan_id
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
        
        DELETE FP_CELL_DELIVERY_PLAN_H
        WHERE INSTANCE_ID = @v_master_id
        AND   PLAN_ID =  @v_plan_id
 
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
        
        INSERT INTO FP_CELL_DELIVERY_PLAN_H
                  (
                    INSTANCE_ID ,
                    PLAN_ID ,
                    COMPANY_ID ,
                    DIVISION_ID ,
                    SITE_ID ,
                    PLANT_ID ,
                    ITEM_ID ,
                    STORAGE_ID , 
                    SOC_ID ,
                    MARKET ,
                    DELIVERY_DATE ,
                    ORG_DELIVERY_QTY ,
                    DELIVERY_QTY ,
                    INSERT_ID ,
                    INSERT_TIME ,
                    UPDATE_ID ,
                    UPDATE_TIME ,
                    MOQ
                  )
        SELECT  INSTANCE_ID ,
                @v_plan_id AS PLAN_ID ,
                COMPANY_ID ,
                DIVISION_ID ,
                SITE_ID ,
                PLANT_ID ,
                ITEM_ID ,
                STORAGE_ID , 
                SOC_ID ,
                MARKET ,
                DELIVERY_DATE ,
                ORG_DELIVERY_QTY ,
                DELIVERY_QTY ,
                @p_user_id +'_COPY' AS INSERT_ID , 
           			GETDATE() AS INSERT_TIME , 
           			@p_user_id +'_COPY' AS UPDATE_ID , 
           			GETDATE() AS UPDATE_TIME ,
                MOQ
        FROM FP_CELL_DELIVERY_PLAN_H
        WHERE INSTANCE_ID = @v_master_id
        AND   PLAN_ID = @v_basis_plan_id  
		
		--LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null       
        
        BEGIN
          
          UPDATE FP_CELL_DELIVERY_PLAN_H
          SET IS_CAL ='N'
          WHERE INSTANCE_ID = @v_master_id
          AND   PLAN_ID = @v_plan_id   
        
        END
        
      END
      
        
      
    END
    
    -----------------------------------------------------------------------------------------------------------------------------------

    
    --LOG 생성
    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, '===============', 'END', 999999, null, '=============== End of procedure ===============', null

    IF @@TRANCOUNT > 0
       COMMIT WORK 

  END TRY

  BEGIN CATCH
    BEGIN

      DECLARE 
        @v_error_message nvarchar(max),
        @v_error_procedure nvarchar(max),
        @v_error_line nvarchar(max)

      SET @v_error_message = ERROR_MESSAGE()

      SET @v_error_procedure = ERROR_PROCEDURE()

      SET @v_error_line = convert(nvarchar,ERROR_LINE())


      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_error_procedure, null, 'ERROR', null, @v_error_line, null, @v_error_message

      IF @@TRANCOUNT > 0
         COMMIT WORK 
    END
  END CATCH
END
