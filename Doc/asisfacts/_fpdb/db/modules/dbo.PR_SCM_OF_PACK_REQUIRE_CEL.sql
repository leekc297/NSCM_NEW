CREATE PROCEDURE [dbo].[PR_SCM_OF_PACK_REQUIRE_CEL]
@p_master_id nvarchar(MAX) = '-', @p_basis_plan_id nvarchar(50) = '-', @p_create_planid nvarchar(10) = 'N', @p_cal_option nvarchar(50) = '-', @p_fix_date date = '19000101', @p_copy_flag nvarchar(10) = 'N', @p_user_id nvarchar(MAX) = 'PR_SCM_OF_PACK_REQUIRE_CEL', @p_target_date date
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_PACK_REQUIRE_CEL                                                **/
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
/** 2019.05.02    SHS          CWA 특화로직 적용 및 속도개선 작업                             **/
/** 2020.09.11    CYS          신규버전 PlanId 채번시 10 이상이면 오류가 나는 현상 수정 (D20200911~R0911.01)        **/
/** 2020.09.23    CYS          창고정보 가져올때 P1000 으로 고정시킴        **/
/**           						p1000 으로 라인정보와 매핑시켜줘야함 Hazel Park 는 P1000 라인이 없어 P5000 으로 봄    (D20200923~R0923.01)     **/
/** 2020.10.06    CYS          Line 정보 mapping 에 P5000 물린곳이 있어 P1000 으로 변경함 , Hazel Park 는 P1000 라인이 있어 수정함   (D20201006~R1006.01)     **/
/** 2020.10.22    CYS          Version Up 옵션화 - copy_flag = Y : Request Plan / copy_flag = M : Moving Plan / copy_flag = R : Pack Plan     (D20201020~R1022.01)     **/
/**  						       선행 비율 Lookup 화 - IN_HOUSE_PLAN_PRECEDING_RATIO   (D20201020~R1022.01)     **/
/** 2020.11.10    CYS          라인어사인- BOM 대치 기준으로 푼다      (D20201110~R1110.01)     **/
/** 2021.01.07    CYS			DW Intransit 을 SSP Intransit 으로 변경 	(D.20210107~R.0108.01)			**/
/** 2021.04.27    CYS			활성화 Plan Group 적용 및 통합 인계요청 적용	(D.20210427~R.0427.01)			**/
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
/***********************************************************************************************/
/*
  EXEC PR_SCM_OF_PACK_REQUIRE_CEL
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  DECLARE
    @v_proc_name        nvarchar(150) = 'PR_SCM_OF_PACK_REQUIRE_CEL', 
    @v_table_name       nvarchar(150) = NULL, 
    @v_master_id        nvarchar(150) = @p_master_id ,
    @v_basis_plan_id    nvarchar(50)  = @p_basis_plan_id,
    @v_create_planid    nvarchar(50) = @p_create_planid,
    @v_cal_option       nvarchar(50)  = @p_cal_option,
    @v_fix_date         nvarchar(150) = isnull(@p_fix_date , '19000101') ,
    @v_plan_id          nvarchar(150) = NULL ,
    @v_copy_flag        nvarchar(10)  = @p_copy_flag ,
    @v_seq              nvarchar(10)  ,
    @v_target_date      date          = @p_target_date 
    
    -- Version UP 옵션 변경
    -- @v_copy_flag : N - Create / Y - Request Plan / M - Moving Plan / R - Releasae (create)  
    
    /*@p_master_id nvarchar(MAX) = '-' , 
    @p_basis_plan_id nvarchar(50) = '-'  , 
    @p_create_planid nvarchar(10) = 'N'  , 
    @p_cal_option  nvarchar(50) = '-' ,
    @p_fix_date    date = '19890518',
    @p_user_id nvarchar(MAX) = '-'*/
    
    /*
      fix date 존재  
       > 모델기준  is_cal = N 인경우 Amend 유지 / is_cal Y인경우 confirm 유지
      fix date 미존재
      > 모델기준 cal 기준 유지
      plan id 미존재
      > 전체모델 데이터생성
      
      
         
    */
    
  DECLARE
    @n_count            Integer  = 0,
    @n_log_count        Integer  = 0,
    @sysdate            DATETIME2 = GETDATE(),
    @v_message          nvarchar(200),
    @v_description      nvarchar(200)

  DECLARE 
    @plan_start_time  datetime,
    @plan_end_time    datetime,
    @key_date    
     nvarchar(8),
    @v_plan_date      nvarchar(8),
   -- @v_basis_plan_id  nvarchar(100),
    @v_plan_type      nvarchar(8)
    
  DECLARE
    @confirm_area     nvarchar(30) = 'BUILDING' ,
    @n_row_count      Integer  = 0 ,
    @v_cutoff_date    date , 
    @v_date           date = convert(date,getdate(),112)
  
  DECLARE
    @offset$scp_target_id       nvarchar(150), 
    @offset$qty                 numeric(20,10),
    @offset$minus_qty           numeric(20,10),
    @offset$mfg_qty             numeric(20,10)  
 
  DECLARE
    @v_form_master_id            nvarchar(150),
    @v_form_master_id2           nvarchar(150)
    
  DECLARE 
    @v_offset_seq     integer  ,
    @n_precede        numeric(20,10) = 0.5
  
  DECLARE
    @v_cell_master_id nvarchar(50)
   
  DECLARE 
    @v_confirm_id     nvarchar(20)
   -- @v_fix_date       nvarchar(8)

  DECLARE @v_inhouse_cell_integ_ui nvarchar(20)	-- ADD (D.20210427~R.0427.01)
  

  DECLARE @IS_CELL_ASSY NVARCHAR(MAX); -- 활성화 분리 적용 여부(Y : 적용, N : 비적용)
  SET @IS_CELL_ASSY = (
  						SELECT (CASE WHEN MAX(B.SEGMENT1) IS NULL THEN 'N' ELSE 'Y' END) AS IS_CELL_ASSY
  						FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)
  						WHERE  B.ACTIVE_FLAG = 'Y'
  						AND    B.LOOKUP_TYPE_CODE = 'CELL_PRODUCT_ASSY'
  						AND    B.SEGMENT1 IN (
  							SELECT MAX(SITE_ID)
  							FROM   FP_INSTANCE_INFO_V V WITH(NOLOCK)
  							WHERE  V.INSTANCE_ID = @p_master_id
  						) );
  SET @v_message = '@IS_CELL_ASSY :: ' + @IS_CELL_ASSY
  EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null 


  BEGIN TRY
  	-- ADD (D.20210427~R.0427.01)
	-- 통합 인계요청 사용하는 인스턴스 제외 로직  
  	SELECT	@v_inhouse_cell_integ_ui = ISNULL(ACTIVE_FLAG,'N')
	FROM	SCM_SYS_LOOKUP_VALUE
	WHERE	1=1
	AND		LOOKUP_TYPE_CODE	= 'INHOUSE_CELL_INTEG_UI'
	AND		SEGMENT2 			=  @v_master_id
	AND		ACTIVE_FLAG 		= 'Y'
	
	SET @v_message = ' v_inhouse_cell_integ_ui : ' + ISNULL(@v_inhouse_cell_integ_ui,'-pass' )
    EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null 
  
	IF @v_inhouse_cell_integ_ui = 'Y'
	BEGIN 
		RETURN ;
	END
	
  	
    SET @v_message = ' v_cal_option : ' + ISNULL(@p_cal_option,'-XXX' )
    EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null 
  
    IF @v_create_planid = 'Y'
    BEGIN
          SET @v_cal_option = 'ALL'
    END
    --LOG 생성
    SET @n_log_count = @n_log_count + 1
    SET @sysdate = GETDATE()
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, '-', @v_proc_name, @v_cal_option, 'START', @n_log_count, null, '############### Start of procedure ###############', null

    BEGIN
    
      SELECT @v_cell_master_id = CASE WHEN @v_master_id = 'KR_PACK' then 'KR_CELL'
                                      WHEN @v_master_id = 'CN_PACK' then 'CN_CELL'
                                      WHEN @v_master_id = 'US_PACK' then 'US_CELL'
                                      WHEN @v_master_id = 'PL_PACK' then 'PL_CELL'
                                      ELSE 'NA' END    
    
      --LOG 생성
      SET @v_message = 'v_cell_master_id : ' + @v_cell_master_id
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      -- (D20201020~R1022.01)
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
      
      SELECT @v_form_master_id2 = CASE WHEN @v_master_id = 'CN_PACK'   THEN 'CN_FORM_E'
                                        ELSE 'NA' END    
    
      --LOG 생성
      SET @v_message = '@v_form_master_id2 : ' + @v_form_master_id2
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      -- (D20201020~R1022.01)
    END;
    
    BEGIN
    
      SELECT @v_confirm_id = PLAN_ID  
      FROM (
      			SELECT  INSTANCE_ID , PLAN_ID , rank() over ( partition by instance_id order by confirm_time  desc) as seq 
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
    
      SET @v_table_name = 'TH_BUF_RELEASE_PLAN'
      
      DELETE TH_BUF_RELEASE_PLAN  WHERE INSTANCE_ID = @v_master_id
      
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
      SET @v_message = 'cutoff_date : ' + CONVERT(nvarchar, @v_cutoff_date, 112) 
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
      SET @v_message = 'cutoff_date : ' + CONVERT(nvarchar, @v_cutoff_date, 112)  + '// ' +CONVERT(nvarchar, @v_plan_date, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
    
    SET @v_message = 'instance_id : '+ @v_master_id  +' v_basis_plan_id : '+ @v_basis_plan_id + ' v_cal_option : ' + @p_cal_option + ' v_p_fix_date :' + CONVERT(nvarchar, @p_fix_date, 112)  + ' v_copy+flag : ' + @p_copy_flag
    EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null  
    
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
    
    IF CHARINDEX('PACK', @v_master_id) > 0 and ( @v_copy_flag = 'N'  OR @v_copy_flag = 'R' )	-- (D20201020~R1022.01)
    BEGIN
    

      /*
        SCM_FP_IN_HOUSE_PLAN_H
      */
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
			            UPDATE_TIME
			          )
			        SELECT  @v_master_id  AS INSTANCE_ID , 
			                CONVERT(NVARCHAR,@v_cutoff_date,112) +'-'  + DBO.FN_LPAD_NVARCHAR( ISNULL(MAX(CONVERT(NUMERIC, SEQ)) + 1,1),2,0) AS PLAN_ID  , 	-- seq 가 숫자로 인식하도록 (D20200911~R0911.01)
			                @v_fix_date AS FIX_DATE , 
			                'N' AS CONFIRM_FLAG , 
			      				  --@v_basis_plan_id AS DESCRIPTION , 
			                CONVERT(NVARCHAR,@v_cutoff_date,112) AS PLAN_DATE ,   
			                ISNULL(MAX(CONVERT(NUMERIC, SEQ)) + 1,1)  AS SEQ , 			-- seq 가 숫자로 인식하도록 (D20200911~R0911.01)
			                @p_user_id AS INSERT_ID , 
			        				GETDATE() AS INSERT_TIME , 
			                @p_user_id AS UPDATE_ID , 
			                GETDATE() AS UPDATE_TIME			
			        FROM  SCM_FP_IN_HOUSE_PLAN_H
			        WHERE   INSTANCE_ID = @v_master_id 
			        AND     PLAN_DATE = CONVERT(NVARCHAR,@v_cutoff_date,112)  -- pack release 한 일자로 해당 id 생성.
			        
			        SELECT  @v_plan_id = MAX(PLAN_ID)
			        FROM    SCM_FP_IN_HOUSE_PLAN_H
			        WHERE   INSTANCE_ID = @v_master_id 
			        AND     PLAN_DATE = CONVERT(NVARCHAR,@v_cutoff_date,112) 
		      
		      END
			-- (D20201020~R1022.01)
			ELSE IF @v_copy_flag = 'R'	-- Release Version UP
				BEGIN
						SELECT 	@v_basis_plan_id = PLAN_ID
				        FROM 	(
				  	          			SELECT INSTANCE_ID , PLAN_ID , RANK() OVER (ORDER BY UPDATE_TIME DESC) AS SEQ
				  	          			FROM    SCM_FP_IN_HOUSE_PLAN_H
				  	      	  			WHERE   INSTANCE_ID = @V_MASTER_ID 
				              			AND     CONFIRM_FLAG = 'Y'
				    				 ) A
						WHERE 	SEQ = 1	
				      
				        SELECT 	@v_seq = ISNULL(MAX(CONVERT(NUMERIC, SEQ)) + 1,1)
				        FROM  	SCM_FP_IN_HOUSE_PLAN_H
				        WHERE   INSTANCE_ID = @V_MASTER_ID 
				        AND     	PLAN_DATE = CONVERT(NVARCHAR, @v_target_date,112)
				        
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
							UPDATE_TIME
						)
						SELECT  	@v_master_id  AS INSTANCE_ID , 
					              	CONVERT(NVARCHAR,@v_target_date,112) +'-'  + DBO.FN_LPAD_NVARCHAR( @v_seq,2,0) AS PLAN_ID  , 
					              	@v_fix_date AS FIX_DATE , 
					              	'N' AS CONFIRM_FLAG , 
									'COPY-' + @v_copy_flag AS DESCRIPTION , 
					              	CONVERT(NVARCHAR,@v_target_date,112) AS PLAN_DATE ,   
					              	@v_seq AS SEQ,  -- DBO.FN_LPAD_NVARCHAR( @v_seq,2,0)  AS SEQ , 
					              	@p_user_id AS INSERT_ID , 
									GETDATE() AS INSERT_TIME , @p_user_id AS UPDATE_ID , GETDATE() AS UPDATE_TIM	
						
						SET @v_plan_id = CONVERT(NVARCHAR, @v_target_date, 112) +'-'  + DBO.FN_LPAD_NVARCHAR(@v_seq, 2, 0)
						
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
      
	      --LOG 생성
	      SET @v_message = '@v_plan_id : ' + @v_plan_id
	      SET @n_log_count = @n_log_count + 1
	      SET @sysdate = GETDATE()
	      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
		
	    -- END IF

      
		      IF @v_master_id = 'PL_PACK' -- and 1=2   -- data 재생산 여부 / 복사여부 판단해야함.
		      BEGIN
		        
		        DECLARE @n_bohcnt int
		        
		        SELECT @n_bohcnt = COUNT(*) 
		        FROM FP_INHOUSE_REQUEST_BOH_R
		        WHERE INSTANCE_ID = @v_master_id 
		        AND PLAN_ID = @v_plan_id
		        AND ( INSERT_ID !=  @v_proc_name  OR UPDATE_ID !=  @v_proc_name )  
		        
		        IF @n_bohcnt = 0
		        BEGIN
		        
				          DELETE FP_INHOUSE_REQUEST_BOH_R
				          WHERE INSTANCE_ID = @v_master_id
				          AND   PLAN_ID = @v_plan_id
				          
				          INSERT INTO FP_INHOUSE_REQUEST_BOH_R
				              (
				                  INSTANCE_ID
				                , PLAN_ID
				                , COMPANY_ID
				                , DIVISION_ID
				                , SITE_ID
				                , PLANT_ID
				                , FACTORY_ID 
				                , ITEM_ID
				                , SLOC_ID
				                , QTY
				                , ORG_QTY
				                , INSERT_ID
				                , INSERT_DTTM
				                , UPDATE_ID
				                , UPDATE_DTTM
				                , SEQ
				              )
				          /*
				          SELECT  	  @v_master_id AS INSTANCE_ID 
						                , @v_plan_id AS PLAN_ID 
						                , A.COMPANY_ID
						                , A.DIVISION_ID
						                , A.SITE_ID
						                , A.PLANT_ID
						                , A.FACTORY_ID 
						                , isnull(C.SEGMENT3 , FP_APPLY_ITEM_ID)  AS ITEM_ID
						                , ISNULL(B.EXPORT_SLOC_ID , DOMESTIC_SLOC_ID) AS SLOC_ID
						                , ISNULL(MAX(MODIFY_FP_APPLY_WIPQTY),SUM(A.FP_APPLY_WIPQTY)) AS QTY
						                , ISNULL(MAX(MODIFY_FP_APPLY_WIPQTY),SUM(A.FP_APPLY_WIPQTY)) AS QTY
						                , @v_proc_name AS INSERT_ID
						      , GETDATE() AS INSERT_DTTM
						                , @v_proc_name AS UPDATE_ID 
						                , GETDATE() AS UPDATE_DTTM
						                , 1 AS SEQ
				          FROM   SCM_STOCK_H_V A WITH(NOLOCK)
				 	LEFT OUTER JOIN SCM_LINE_M B WITH(NOLOCK)
				                    		ON  A.COMPANY_ID = B.COMPANY_ID
				                    		AND A.DIVISION_ID = B.DIVISION_ID
				                    		AND A.SITE_ID = B.SITE_ID
				                    		AND A.PLANT_ID = B.PLANT_ID
				                    		AND A.FACTORY_ID = B.FACTORY_ID
				                  	    	AND A.FP_APPLY_OPERATION_ID = B.OPERATION_ID
				                    		AND A.LINE_ID = B.LINE_ID
				                    		AND B.ACTIVE_FLAG = 'Y'
				                    LEFT OUTER JOIN  	SCM_SYS_LOOKUP_VALUE C
				                    		ON	C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'
				                        AND A.SITE_ID = C.SEGMENT1
				                    		AND	A.ITEM_ID = C.SEGMENT4
				          WHERE  A.OPERATION_ID = 'P1000'
				          AND    A.STOCK_STATUS = 'WAIT'
				          AND    A.STORAGE_ID = 'MES'
				          AND    CONVERT(VARCHAR, A.CUTOFF_DATE,112) = @v_target_date
				          AND    ((A.STORAGE_ID  BETWEEN '1000' AND '1999') OR (A.STORAGE_ID >= '5000' AND A.STORAGE_ID < '6000') OR (ISNULL(A.FP_APPLY_WIPQTY, 0) >= 0))
				          AND    A.DIVISION_ID IN ('81')
				          AND    A.PLANT_ID IN ('G481')
				          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.FACTORY_ID ,B.EXPORT_SLOC_ID , B.DOMESTIC_SLOC_ID ,isnull(C.SEGMENT3 , FP_APPLY_ITEM_ID) 
				          */
				          SELECT  @v_master_id AS INSTANCE_ID 
				                , @v_plan_id AS PLAN_ID  
				                , A.COMPANY_ID
				                , A.DIVISION_ID
				                , A.SITE_ID
				                , A.PLANT_ID
				                , A.FACTORY_ID 
				                , A.ITEM_ID 
				                , A.SLOC_ID 
				                , SUM(QTY) AS QTY
				                , SUM(QTY) AS ORG_QTY
				                , @v_proc_name AS INSERT_ID
				                , GETDATE() AS INSERT_DTTM
				                , @v_proc_name AS UPDATE_ID 
				                , GETDATE() AS UPDATE_DTTM
				                , 1 AS SEQ 
				          FROM (
				                SELECT  A.COMPANY_ID
				                      , A.DIVISION_ID
				                      , A.SITE_ID
				                      , A.PLANT_ID
				                      , A.FACTORY_ID 
				                      , isnull(C.SEGMENT3 , FP_APPLY_ITEM_ID)  AS ITEM_ID
				                      , ISNULL(B.EXPORT_SLOC_ID , DOMESTIC_SLOC_ID) AS SLOC_ID
				                      , ISNULL(MAX(MODIFY_FP_APPLY_WIPQTY),SUM(A.FP_APPLY_WIPQTY)) AS QTY
				                FROM   SCM_STOCK_H_V A WITH(NOLOCK)
				                        	LEFT OUTER JOIN SCM_LINE_M B WITH(NOLOCK)
				                          		ON  A.COMPANY_ID = B.COMPANY_ID
				                          		AND A.DIVISION_ID = B.DIVISION_ID
				                          		AND A.SITE_ID = B.SITE_ID
				                          		AND A.PLANT_ID = B.PLANT_ID
				                          		AND A.FACTORY_ID = B.FACTORY_ID
				                      	    	--AND A.FP_APPLY_OPERATION_ID = B.OPERATION_ID
				                      	    	--AND B.OPERATION_ID = (CASE WHEN A.PLANT_ID = 'G388' THEN 'P5000' ELSE 'P1000' END) -- (D20200923~R0923.01)
				                      	    	AND B.OPERATION_ID = 'P1000'	-- (D20201006~R1006.01)
				                          		AND A.LINE_ID = B.LINE_ID
				                          		AND B.ACTIVE_FLAG = 'Y'
				                      	  LEFT OUTER JOIN  	SCM_SYS_LOOKUP_VALUE C
				                      		    ON	C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'
				                              AND A.SITE_ID = C.SEGMENT1
				                          		AND	A.ITEM_ID = C.SEGMENT4
				                WHERE  A.OPERATION_ID = 'P1000'
				           AND    A.STOCK_STATUS = 'WAIT'
				                AND    A.STORAGE_ID = 'MES'
				                AND    CONVERT(VARCHAR, A.CUTOFF_DATE,112) = @v_target_date
				                AND    ((A.STORAGE_ID  BETWEEN '1000' AND '1999') OR (A.STORAGE_ID >= '5000' AND A.STORAGE_ID < '6000') OR (ISNULL(A.FP_APPLY_WIPQTY, 0) >= 0))
								AND    A.DIVISION_ID IN ('81')
								--AND    A.PLANT_ID IN ('G481')
								AND    A.PLANT_ID IN ('WA00')
				                GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.FACTORY_ID ,B.EXPORT_SLOC_ID , B.DOMESTIC_SLOC_ID ,isnull(C.SEGMENT3 , FP_APPLY_ITEM_ID) 
								/*
					                UNION ALL        
					                SELECT  A.COMPANY_ID
					    	                , A.DIVISION_ID
					    	                , A.SITE_ID
					    	                , A.PLANT_ID
					    	                , A.FACTORY_ID 
					    	                , ISNULL(C.SEGMENT3 , FP_APPLY_ITEM_ID)  AS ITEM_ID
					    	                , ISNULL(B.EXPORT_SLOC_ID , DOMESTIC_SLOC_ID) AS SLOC_ID
					    	                , ISNULL(SUM(A.PACK_MOVE_QTY),0) AS QTY
					                FROM SCM_STOCK_H_V A
					                		    LEFT OUTER JOIN SCM_LINE_M B WITH(NOLOCK)
					                        		ON  A.COMPANY_ID = B.COMPANY_ID
					           		AND A.DIVISION_ID = B.DIVISION_ID
					                        		AND A.SITE_ID = B.SITE_ID
					                        		AND A.PLANT_ID = B.PLANT_ID
					                        		AND A.FACTORY_ID = B.FACTORY_ID
					                      			--AND B.OPERATION_ID = 'P5000'
					                      			--AND B.OPERATION_ID = (CASE WHEN A.PLANT_ID = 'G388' THEN 'P5000' ELSE 'P1000' END) -- p1000 으로 라인정보와 매핑시켜줘야함 Hazel Park 는 P1000 라인이 없어 P5000 으로 봄
					                      			AND B.OPERATION_ID = 'P1000' -- (D20201006~R1006.01)
					                        		AND A.LINE_ID = B.LINE_ID
					                        		AND B.ACTIVE_FLAG = 'Y'
					                    		LEFT OUTER JOIN  	SCM_SYS_LOOKUP_VALUE C
					              	        		ON	C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'
					            	            	AND A.SITE_ID = C.SEGMENT1
					              	        		AND	A.ITEM_ID = C.SEGMENT4   		
					                WHERE  A.STOCK_TYPE = 'DW'
					                AND 	 A.PACK_MOVE_QTY IS NOT NULL
					                AND 	 A.PACK_MOVE_QTY >  0
					                AND    CONVERT(NVARCHAR, A.CUTOFF_DATE,112) = @v_target_date
					                AND    A.DIVISION_ID IN ('81')
					                AND    A.PLANT_ID IN ('G481')
					                GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.FACTORY_ID ,B.EXPORT_SLOC_ID , B.DOMESTIC_SLOC_ID ,isnull(C.SEGMENT3 , FP_APPLY_ITEM_ID) 
					                HAVING ISNULL(B.EXPORT_SLOC_ID , DOMESTIC_SLOC_ID) IS NOT NULL
								**/	
									-- (D.20210107~R.0108.01)
					                UNION ALL
									SELECT  A.COMPANY_ID
												, A.DIVISION_ID
												, A.SITE_ID
												, A.PLANT_ID
												, A.FACTORY_ID 
												, ISNULL(C.SEGMENT3 , A.ITEM_ID)  AS ITEM_ID
												, A.TO_SLOC_ID AS SLOC_ID
												, ISNULL(SUM(A.PACK_MOVE_QTY),0) AS QTY
									FROM		FP_SSP_STOCK_BACKUP_H A
												LEFT OUTER JOIN  	SCM_SYS_LOOKUP_VALUE C
													ON	C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'
													AND A.SITE_ID = C.SEGMENT1
													AND	A.ITEM_ID = C.SEGMENT4   		
									WHERE	1=1
									AND 	 	ISNULL(A.PACK_MOVE_QTY,0) >  0
									AND		CONVERT(NVARCHAR, A.CUTOFF_DATE,112) = @v_target_date
									AND    A.DIVISION_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_OF_PACK_REQUIRE_CELL' AND SEGMENT1  = '4' AND ACTIVE_FLAG = 'Y')
									AND    A.PLANT_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_OF_PACK_REQUIRE_CELL' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')
									GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.FACTORY_ID , A.TO_SLOC_ID ,ISNULL(C.SEGMENT3 , A.ITEM_ID) 
				              )A
				          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.FACTORY_ID , A.ITEM_ID , A.SLOC_ID
		
		        
		        END	-- @n_bohcnt = 0
      
      		END		-- PL_PACK


        /*
          1. LOOKUP에 정의되지 않을 경우 SOC는 'Common'로 정의된 경우만 SOC 산출		
          
          SELECT SEGMENT1 AS SITE_ID , SEGMENT2 AS DIVISION_ID , SEGMENT3 AS SOCK_ID 
          FROM SCM_SYS_LOOKUP_VALUE
          WHERE LOOKUP_TYPE_CODE = 'PACK_SOC'
          AND      SEGMENT5 = '1' --  IS_USE
          
          2. LINE별 ERP STORAGE ID 정의
          
          SELECT *--STORAGE_ID  현 컬럼 미정의
          FROM SCM_LINE_M
          
          3.CELL 필요량 산출 시 P1000 대기 재공 차감		
          
          - 1. TH_BUF_DEMAND_PACK_REQUIRE cell 소요량 산출
          
          SELECT *
          FROM FP_DEMAND_PACK_REQUIRE_CELL_H
          WHERE REQUIRE_dATE >= CONVERT(DATE,GETDATE() , 112) 
          AND IS_CAL = 'Y'
          
        */
        
      BEGIN
      
        /*
        1. 특성에서 필요한 기본data 생성 
        */
      
        SET @v_table_name = 'TH_BUF_FORM_INSTANCE_FLOW'
      
        DELETE TH_BUF_FORM_INSTANCE_FLOW
        WHERE MASTER_ID = @v_master_id
      
        INSERT INTO TH_BUF_FORM_INSTANCE_FLOW
          (
           MASTER_ID,
           COMPANY_ID, 
           DIVISION_ID, 
           SITE_ID, 
           PLANT_ID,
           FACTORY_ID,
           ITEM_ID, 
           OPERATION_ID, 
           OPERATION_SEQ,
           ERP_OPERATION_ID,
           ORDER_TYPE,
           BATCH_TYPE,
           CAPA_TYPE,
           HALF_SLIT_FLAG,
           KEY_DATE,
           INSERT_ID,
           INSERT_DTTM,
           UPDATE_ID,
           UPDATE_DTTM
          )
        SELECT DISTINCT 
               @v_master_id AS MASTER_ID,
               A.COMPANY_ID, 
               A.DIVISION_ID, 
               A.SITE_ID, 
               A.PLANT_ID, 
               A.FACTORY_ID,
               A.ITEM_ID, 
               A.OPERATION_ID, 
               A.OPERATION_SEQ,
               ISNULL(B.ERP_OPERATION_ID, 'ZZ') AS ERP_OPERATION_ID,
               CASE WHEN B.WO_FLAG = 'Y' THEN 'W'
              WHEN B.MO_FLAG = 'Y' THEN 'M'
                    ELSE 'W'
               END  ORDER_TYPE,
               CASE WHEN CAPA_TYPE = 'BATCH' THEN 'Y'
      ELSE 'N'
               END  BATCH_TYPE,
               CAPA_TYPE,
               'N'                         AS HALF_SLIT_FLAG,
               @v_plan_date                AS KEY_DATE,
               @v_proc_name as INSERT_ID,
               getdate() as INSERT_DTTM,
               @v_proc_name as UPDATE_ID,
               getdate() as UPDATE_DTTM
        FROM   (
                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, D.PLANT_ID, D.FACTORY_ID, A.ITEM_ID,
                       B.FLOW_ID, B.OPERATION_ID, B.OPERATION_SEQ
                FROM   SCM_ITEM_M A
                        INNER JOIN SCM_OPERATION_FLOW_M B
                              ON     A.COMPANY_ID = B.COMPANY_ID
                              AND    A.DIVISION_ID = B.DIVISION_ID
                              AND    A.SITE_ID = B.SITE_ID
                              AND    A.FLOW_ID = B.FLOW_ID
                              AND    B.ACTIVE_FLAG = 'Y'
                        INNER JOIN SCM_ITEM_CLASS_M C
                              ON     A.ITEM_CLASS = C.CLASS_ID
                              AND    C.USE_FLAG = 'Y'
                     , (
                        SELECT B.*, A.INSTANCE_TYPE 
                        FROM   FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
                               SCM_FACTORY_M         B    -- FACTORY 별 SITE ID
                        WHERE  A.INSTANCE_ID IN (@v_form_master_id, @v_form_master_id2)
                        AND    A.FACTORY_ID = B.FACTORY_ID
                        AND    B.ACTIVE_FLAG = 'Y'
                       ) D
                WHERE  A.ACTIVE_FLAG = 'Y'
                AND    A.COMPANY_ID = D.COMPANY_ID
                AND    A.DIVISION_ID = D.DIVISION_ID
                AND    A.SITE_ID = D.SITE_ID
                -- FORMATION 정보 설정 
                UNION  ALL
                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, D.PLANT_ID, D.FACTORY_ID, A.ITEM_ID,
                       B.FLOW_ID, B.OPERATION_ID, B.OPERATION_SEQ
                FROM   SCM_ITEM_M A
                        INNER JOIN SCM_OPERATION_FLOW_M B
                              ON     A.COMPANY_ID = B.COMPANY_ID
                              AND    A.DIVISION_ID = B.DIVISION_ID
                              AND    A.SITE_ID = B.SITE_ID
                              AND    A.FORMATION_FLOW_ID = B.FLOW_ID
                              --AND   (CASE WHEN A.FORMATION_FLOW_ID IS NULL AND A.FLOW_ID = 'A9000' THEN 'F6000'
                              --            ELSE A.FORMATION_FLOW_ID
                              --       END) = B.FLOW_ID
                              AND    B.ACTIVE_FLAG = 'Y'
                        INNER JOIN SCM_ITEM_CLASS_M C
                              ON     A.ITEM_CLASS = C.CLASS_ID
                              AND    C.USE_FLAG = 'Y'
                     , (
                        SELECT B.*, A.INSTANCE_TYPE 
                        FROM   FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
                               SCM_FACTORY_M         B    -- FACTORY 별 SITE ID
                        WHERE  A.INSTANCE_ID IN (@v_form_master_id, @v_form_master_id2)
                        AND    A.FACTORY_ID = B.FACTORY_ID
                        AND    B.ACTIVE_FLAG = 'Y'
                       ) D
                WHERE  A.ACTIVE_FLAG = 'Y'
                AND    A.COMPANY_ID = D.COMPANY_ID
                AND    A.DIVISION_ID = D.DIVISION_ID
                AND    A.SITE_ID = D.SITE_ID              
               ) A,
               (
                SELECT A.*, B.PLANT_ID, B.FACTORY_ID
                FROM   SCM_OPERATION_M A,
                       (
                        SELECT B.*, A.INSTANCE_TYPE 
                        FROM   FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
                               SCM_FACTORY_M         B    -- FACTORY 별 SITE ID
                        WHERE  A.INSTANCE_ID IN (@v_form_master_id, @v_form_master_id2)
                        AND    A.FACTORY_ID = B.FACTORY_ID
                        AND    B.ACTIVE_FLAG = 'Y'
                       ) B       
                WHERE  A.COMPANY_ID    = B.COMPANY_ID
                AND    A.DIVISION_ID   = B.DIVISION_ID
                AND    A.SITE_ID       = B.SITE_ID
                AND    A.INSTANCE_TYPE = B.INSTANCE_TYPE
               ) B
        WHERE  A.COMPANY_ID = B.COMPANY_ID
        AND    A.DIVISION_ID = B.DIVISION_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.PLANT_ID = B.PLANT_ID
        AND    A.FACTORY_ID = B.FACTORY_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        AND    EXISTS ( -- BOM 단종 제약 설정
                        SELECT 1
                        FROM   (
                                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                                     , MAX(KEY_DATE) AS KEY_DATE
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
                                AND    A.BOM_VERSION_ID = '1'
                                --AND    A.EFF_END_DATE   >  GETDATE()
                                AND    A.EFF_END_DATE   >  CONVERT(DATE, @v_plan_date)
                                GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                               ) X
                        WHERE  A.COMPANY_ID   = X.COMPANY_ID
                        AND    A.DIVISION_ID  = X.DIVISION_ID
                        AND    A.SITE_ID      = X.SITE_ID
                        --AND    A.PLANT_ID     = X.PLANT_ID
                        AND    A.ITEM_ID      = X.PARENT_ITEM_ID
                        )
      
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
        
        SET @v_table_name = 'TH_BUF_PACK_BOM_INFO'
      
        DELETE  TH_BUF_PACK_BOM_INFO WHERE INSTANCE_ID = @v_master_id

        INSERT INTO TH_BUF_PACK_BOM_INFO
        	(
        		INSTANCE_ID , 
        		COMPANY_ID ,
        		DIVISION_ID , 
        		SITE_ID , 
        		PLANT_ID , 
        		ALT_PRIORITY ,
        		PARENT_QTY , 
        		CHILD_QTY , 
        		TOP_ITEM_ID , 
        		ITEM_ID , 
        		CELL_ITEM_ID 
        	)
        SELECT INSTANCE_ID , 
               COMPANY_ID , 
               DIVISION_ID , 
               SITE_ID , 
               PLANT_ID , 
               ALT_PRIORITY , 
               PARENT_QTY , 
               CHILD_QTY , 
               TOP_ITEM_ID , 
               ITEM_ID , 
               CELL_ITEM_ID 
        FROM   (
                SELECT @v_master_id  AS INSTANCE_ID ,
                       B.COMPANY_ID ,
                       B.DIVISION_ID ,
                       B.SITE_ID ,
                       B.PLANT_ID ,
                       B.ALT_PRIORITY ,
                       B.PARENT_QTY ,
                       B.CHILD_QTY ,
                       A.TOP_ITEM_ID AS TOP_ITEM_ID ,
                       A.ITEM_ID AS  ITEM_ID ,
                       B.CHILD_ITEM_ID    AS CELL_ITEM_ID
                FROM  (
                        SELECT A.*
                        --FROM   FP_RELEASE_FIX_PLAN_H  A
                        FROM   FP_RELEASE_FULL_PLAN_H  A
                              , TH_BUF_RELEASE_PLAN B
                        WHERE  A.INSTANCE_ID      = B.INSTANCE_ID
                        AND    A.INSTANCE_DATE    = B.INSTANCE_DATE
                        AND    A.RELEASE_PLAN_ID  = B.RELEASE_PLAN_ID
                        --AND    A.AMEND_PLAN_ID    = B.AMEND_PLAN_ID
                        --AND    A.DIVISION_ID      = B.DIVISION_ID
                        AND    A.FACTORY_ID       = B.FACTORY_ID
                        AND    A.LINE_ID          = B.LINE_ID
                        --AND    A.PLAN_DATE       >= @v_plan_date    -- PLAN 일자 이후
                        AND    A.PLAN_DATE        >= B.RELEASE_DATE      -- RELEASE_DATE 일자 이후
                      ) A        
                    ,(
                      SELECT  *
                      FROM   SCM_BOM_M   A
                      WHERE  ACTIVE_FLAG = 'Y'
                      AND    EXISTS (
                                      SELECT 1
                                      FROM   TH_BUF_FORM_INSTANCE_FLOW B
                                      WHERE  B.MASTER_ID    = @v_master_id
                                      AND    B.COMPANY_ID   = A.COMPANY_ID
                                      AND    B.DIVISION_ID  = A.DIVISION_ID
                                      AND    B.SITE_ID      = A.SITE_ID
                                      AND    B.ITEM_ID      = A.CHILD_ITEM_ID
                                    )
                     -- AND ISNULL(A.ALT_PRIORITY,1) = 1  
                     ) B
                WHERE  A.ITEM_ID      = B.PARENT_ITEM_ID
                AND    A.DIVISION_ID  = B.DIVISION_ID
                AND    A.PLAN_DATE   >= B.EFF_START_DATE
                AND    A.PLAN_DATE    < B.EFF_END_DATE
              ) A
         GROUP BY INSTANCE_ID , COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , ALT_PRIORITY , PARENT_QTY , CHILD_QTY , TOP_ITEM_ID , ITEM_ID , CELL_ITEM_ID 
        
         --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
        
        IF @v_master_id = 'PL_PACK' --AND 1=2
        
          BEGIN
          
            UPDATE TH_BUF_PACK_BOM_INFO
            SET TH_BUF_PACK_BOM_INFO.ALT_PRIORITY = A.PRIORITY
            FROM (
  	              SELECT  A.INSTANCE_ID , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.PARENT_QTY , A.CHILD_QTY , A.TOP_ITEM_ID , A.ITEM_ID , A.CELL_ITEM  , MIN(SEQ) AS PRIORITY	, A.CELL_ITEM_ID	
          			  FROM (
                			  SELECT A.* , DENSE_RANK() OVER (PARTITION BY ITEM_ID  ORDER BY SEQ1 , ALT_PRIORITY )  AS SEQ
                			  FROM (
  									  SELECT  A.*   , ISNULL(SEGMENT3, CELL_ITEM_ID) AS CELL_ITEM , CASE WHEN A.CELL_ITEM_ID = ISNULL(C.SEGMENT3,'XXX') THEN 1 ELSE 9 END  AS SEQ1
  									  FROM TH_BUF_PACK_BOM_INFO A 
  		                      						LEFT OUTER JOIN (
  		                      										SELECT *
          															FROM SCM_SYS_LOOKUP_VALUE
          															WHERE LOOKUP_TYPE_CODE = 'MODULE_TO_CELL_GROUP'
  		                      										)C
  		                      								ON	 A.SITE_ID = 	C.SEGMENT1
  		                      								AND	 A.ITEM_ID = C.SEGMENT2
  									  WHERE A.INSTANCE_ID = @v_master_id
                      			  )A
                  			)A
                  GROUP BY A.INSTANCE_ID , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.PARENT_QTY , A.CHILD_QTY , A.TOP_ITEM_ID , A.ITEM_ID , A.CELL_ITEM  , A.CELL_ITEM_ID
             )A
            WHERE   TH_BUF_PACK_BOM_INFO.COMPANY_ID = A.COMPANY_ID
            AND	    TH_BUF_PACK_BOM_INFO.DIVISION_ID = A.DIVISION_ID
            AND     TH_BUF_PACK_BOM_INFO.SITE_ID = A.SITE_ID
            AND     TH_BUF_PACK_BOM_INFO.PLANT_ID = A.PLANT_ID
            AND     TH_BUF_PACK_BOM_INFO.TOP_ITEM_ID = A.TOP_ITEM_ID
            AND     TH_BUF_PACK_BOM_INFO.ITEM_ID = A.ITEM_ID 
            AND     TH_BUF_PACK_BOM_INFO.CELL_ITEM_ID = A.CELL_ITEM_ID    
            AND     TH_BUF_PACK_BOM_INFO.INSTANCE_ID = @v_master_id 
         
            --- 대치정보를 살리기 위해 삭제하지 않는다. (D20201110~R1110.01)
         --   DELETE  TH_BUF_PACK_BOM_INFO WHERE INSTANCE_ID = @v_master_id AND ISNULL(ALT_PRIORITY , 1 ) <> 1 

          /*
          
          UPDATE TH_BUF_PACK_BOM_INFO
          SET TH_BUF_PACK_BOM_INFO.ALT_PRIORITY = A.PRIORITY
          FROM (
                select a.* , case when a.ck_item is null then 9 else dense_rank() over  (partition by a.instance_id , a.COMPANY_ID, a.division_id , a.site_id , a.plant_id ,a.top_item_id ,a.item_id  order by alt_priority)   end as priority
                from (
                      SELECT distinct a.*  , b.item_id as ck_item
                      FROM TH_BUF_PACK_BOM_INFO A 
                      				LEFT OUTER JOIN (
                      										SELECT COMPANY_ID , DIVISION_ID , SITE_ID ,  PLANT_ID , FACTORY_ID , MONTH , ITEM_ID   
                      										FROM SCM_TACT_TIME_M
                      										WHERE 1=1 
                      										AND DAILY_CAPA > 0 
                      										AND OPERATION_ID = 'F6000'
                      										AND MONTH >= SUBSTRING(CONVERT(NVARCHAR,@v_target_date,112),1,6) 
                      										GROUP BY COMPANY_ID , DIVISION_ID , SITE_ID ,  PLANT_ID , FACTORY_ID , MONTH , ITEM_ID  
                      										)B
                      						ON   A.COMPANY_ID = B.COMPANY_ID
                      						AND A.DIVISION_ID = B.DIVISION_ID
                      						AND A.SITE_ID = B.SITE_ID
                      						AND A.PLANT_ID = B.PLANT_ID
                      						AND A.CELL_ITEM_ID = B.ITEM_ID
                      WHERE A.INSTANCE_ID = @v_master_id
                      )a
                )A
          WHERE   TH_BUF_PACK_BOM_INFO.COMPANY_ID = A.COMPANY_ID
          AND	    TH_BUF_PACK_BOM_INFO.DIVISION_ID = A.DIVISION_ID
          AND     TH_BUF_PACK_BOM_INFO.SITE_ID = A.SITE_ID
          AND     TH_BUF_PACK_BOM_INFO.PLANT_ID = A.PLANT_ID
          AND     TH_BUF_PACK_BOM_INFO.TOP_ITEM_ID = A.TOP_ITEM_ID
          AND     TH_BUF_PACK_BOM_INFO.ITEM_ID = A.ITEM_ID 
          AND     TH_BUF_PACK_BOM_INFO.CELL_ITEM_ID = A.CELL_ITEM_ID    
          AND     TH_BUF_PACK_BOM_INFO.INSTANCE_ID = @v_master_id 
          
          UPDATE TH_BUF_PACK_BOM_INFO
          SET TH_BUF_PACK_BOM_INFO.ALT_PRIORITY = A.PRIORITY
          FROM (
                select a.* , case when a.ck_item is null then 9 else dense_rank() over  (partition by a.instance_id , a.COMPANY_ID, a.division_id , a.site_id , a.plant_id ,a.top_item_id ,a.item_id  order by alt_priority)   end as priority
                from (
                      SELECT distinct a.*  , b.item_id as ck_item
                      FROM TH_BUF_PACK_BOM_INFO A 
                      				LEFT OUTER JOIN (
                      										SELECT COMPANY_ID , DIVISION_ID , SITE_ID ,  PLANT_ID , FACTORY_ID , MONTH , ITEM_ID   
                      										FROM SCM_TACT_TIME_M
                      										WHERE 1=1 
                      										AND DAILY_CAPA > 0 
                      										AND OPERATION_ID = 'F6000'
                      										AND MONTH >= SUBSTRING(CONVERT(NVARCHAR,@v_target_date,112),1,6) 
                      										GROUP BY COMPANY_ID , DIVISION_ID , SITE_ID ,  PLANT_ID , FACTORY_ID , MONTH , ITEM_ID  
                      										)B
                      						ON   A.COMPANY_ID = B.COMPANY_ID
         						AND A.DIVISION_ID = B.DIVISION_ID
                      						AND A.SITE_ID = B.SITE_ID
                      						AND A.PLANT_ID = B.PLANT_ID
                      						AND A.CELL_ITEM_ID = B.ITEM_ID
                      WHERE A.INSTANCE_ID = @v_master_id
                      )a
                )A
          WHERE   TH_BUF_PACK_BOM_INFO.COMPANY_ID = A.COMPANY_ID
          AND	    TH_BUF_PACK_BOM_INFO.DIVISION_ID = A.DIVISION_ID
          AND     TH_BUF_PACK_BOM_INFO.SITE_ID = A.SITE_ID
          AND     TH_BUF_PACK_BOM_INFO.PLANT_ID = A.PLANT_ID
          AND     TH_BUF_PACK_BOM_INFO.TOP_ITEM_ID = A.TOP_ITEM_ID
          AND     TH_BUF_PACK_BOM_INFO.ITEM_ID = A.ITEM_ID 
          AND     TH_BUF_PACK_BOM_INFO.CELL_ITEM_ID = A.CELL_ITEM_ID    
          AND     TH_BUF_PACK_BOM_INFO.INSTANCE_ID = @v_master_id 
          */
        
        END
        
      END
      
      /*
        CELL 소요량 산출
      */

      BEGIN
      
        SET @v_table_name = 'TH_BUF_DEMAND_PACK_REQUIRE'
        
        DELETE TH_BUF_DEMAND_PACK_REQUIRE
        WHERE INSTANCE_ID = @v_master_id
        
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description
        
        IF @v_master_id = 'PL_PACK' --AND 1=2
        BEGIN
          
          INSERT INTO TH_BUF_DEMAND_PACK_REQUIRE    
                (
                COMPANY_ID , 
                DIVISION_ID , 
                SITE_ID , 
                PLANT_ID , 
                INSTANCE_ID ,
                FP_DEMAND_ID , 
                CELL_ITEM_ID ,
                ALT_PRIORITY , 
                L_ALT_PRIORITY ,	--(D20201110~R1110.01)
                SCP_WEEK , 
                MFG_WEEK ,
                MFG_QTY ,
                WORK_ORDER_ID , 
                DUE_DATE , 
                DUE_FENCE_DATE , 
                PRODUCTION_TYPE , 
                LINE_ID , 
                MARKET ,
                PRIORITY , 
                OFFSET_INVENTORY_QTY ,
                OFFSET_GI_QTY ,
                OFFSET_FIX_QTY ,
                DEMAND_TYPE , 
                TARGET_TYPE ,
                STORAGE_ID ,
                OPERATION_ID , 
                SAFETY_CAPA 
                ) 
        SELECT  A.COMPANY_ID , 
                A.DIVISION_ID , 
                A.SITE_ID , 
                A.PLANT_ID , 
                A.INSTANCE_ID , 
                MAX(FP_DEMAND_ID)  AS FP_DEMAND_ID , 
  		  		A.CELL_ITEM_ID , 
                A.ALT_PRIORITY ,
                A.L_ALT_PRIORITY,	--(D20201110~R1110.01)
                A.SCP_WEEK , 
                A.MFG_WEEK,  
                SUM(MFG_QTY) AS MFG_QTY , 
                A.WORK_ORDER_ID , 
                A.DUE_DATE  , 
                A.DUE_FENCE_DATE , 
                'MASS' AS PRODUCTION_TYPE ,  --A.PRODUCTION_TYPE , 
                A.LINE_ID AS LINE_ID , 
                'D' AS MARKET , --A.MARKET , 
                A.PRIORITY , 
  		  				A.OFFSET_INVENTORY_QTY , 
                A.OFFSET_GI_QTY , 
                A.OFFSET_FIX_QTY , 
                A.DEMAND_TYPE , 
                A.TARGET_TYPE , 
                A.STORAGE_ID , 
                A.OPERATION_ID , 
                A.SAFETY_CAPA
          FROM (
               SELECT   A.COMPANY_ID ,
                         A.DIVISION_ID ,
                         A.SITE_ID ,
                         A.PLANT_ID ,
                         @v_master_id   AS INSTANCE_ID ,
                         A.PACK_WORK_ORDER_ID AS FP_DEMAND_ID , -- 대치품때문에 UNIQUE 하지 않다.
                         --A.TOP_ITEM_ID AS TOP_ITEM_ID , 
                         --A.ITEM_ID ,
                         A.CELL_ITEM_ID,
                         A.R_ALT_PRIORITY AS ALT_PRIORITY ,
                         A.L_ALT_PRIORITY as L_ALT_PRIORITY,	--(D20201110~R1110.01)
                         B.WEEK         AS SCP_WEEK ,
                         B.WEEK         AS MFG_WEEK ,
                     A.MFG_QTY ,
                         NULL AS WORK_ORDER_ID , -- 'A'           AS WORK_ORDER_ID ,
                         A.PACK_PLAN_DATE   AS DUE_DATE ,
                         A.PACK_PLAN_DATE   AS DUE_FENCE_DATE ,
                         ISNULL(PACK_PRODUCTION_TYPE, 'MASS')  AS PRODUCTION_TYPE ,
                         A.LINE_ID      AS LINE_ID , 
                         A.MARKET       AS MARKET , 
                         NULL           AS PRIORITY ,
                         0              AS OFFSET_INVENTORY_QTY ,
                         0              AS OFFSET_GI_QTY ,
                         0              AS OFFSET_FIX_QTY ,
                         'NOR'          AS DEMAND_TYPE ,
                         'PACK_RELEASE'    AS TARGET_TYPE ,
                         NULL AS STORAGE_ID,
                         A.OPERATION_ID AS OPERATION_ID , 
                         A.SAFETY_CAPA
                FROM   (
		                          select a.* , dense_rank() over  (partition by a.COMPANY_ID , a.site_id , a.plant_id  ,a.item_id  order by a.ALT_PRIORITY) as  R_ALT_PRIORITY
		                          				, DENSE_RANK() OVER  (	PARTITION BY A.COMPANY_ID , A.SITE_ID , A.PLANT_ID  ,A.ITEM_ID, SUBSTRING(CONVERT(NVARCHAR,A.PACK_PLAN_DATE,112),1,6)  
		                          												ORDER BY A.LINE_PRIORITY , A.ALT_PRIORITY ) AS  L_ALT_PRIORITY	--(D20201110~R1110.01)
		                          from (
				                                SELECT  DISTINCT	A.SCP_PLAN_ID , 
				                      								A.PACK_WORK_ORDER_ID , 
				                      								A.PACK_PLAN_DATE , 
				                      								A.PACK_PLAN_IN_QTY , 
				                      								A.PACK_PRODUCTION_TYPE , 
				                      								A.MARKET , 
				                      								A.TO_FACTORY_ID , 
				                      								A.CELL_ITEM_ID , 
				                      								A.PARENT_QTY , 
				                      								A.CHILD_QTY , 
				                      								A.COMPANY_ID , 
				                      								A.DIVISION_ID , 
				                      								A.SITE_ID , 
				                      								A.PLANT_ID , 
				                      								A.ALT_PRIORITY AS ALT_PRIORITY ,  --  D.ITEM_ID CASE WHEN D.ITEM_ID IS NULL THEN 9 ELSE dense_rank() over  (partition by a.COMPANY_ID , a.site_id , a.plant_id  ,a.item_id  order by A.ALT_PRIORITY)   END AS  ALT_PRIORITY , 
				                      								A.SEQ,
				                      								A.LINE_ID , 
				                      								A.ITEM_ID , 
				                      								A.OPERATION_ID ,
																	CEILING(PACK_PLAN_IN_QTY * ( CHILD_QTY / PARENT_QTY)) AS MFG_QTY,
																	DENSE_RANK() OVER (PARTITION BY PACK_WORK_ORDER_ID
																						ORDER     BY CELL_ITEM_ID) - 1 AS ORDER_SEQ,
																					--  ISNULL(B.DAILY_CAPA  ,C.DAILY_CAPA),
																					--  ( CHILD_QTY / PARENT_QTY) ,
																	((ISNULL(B.DAILY_CAPA  ,C.DAILY_CAPA)  *     ( CHILD_QTY / PARENT_QTY)) * @n_precede) AS SAFETY_CAPA  
																	, ISNULL(X.LINE_PRIORITY,9) AS LINE_PRIORITY
				                                FROM   (
							                                        SELECT  A.RELEASE_PLAN_ID  AS SCP_PLAN_ID,
								                                                A.WORK_ORDER_ID    AS PACK_WORK_ORDER_ID,
								                                                A.PLAN_DATE        AS PACK_PLAN_DATE,
								                    							A.PLAN_IN_QTY      AS PACK_PLAN_IN_QTY,
								                                                A.PRODUCTION_TYPE  AS PACK_PRODUCTION_TYPE,
								                                                A.MARKET           AS MARKET, --A.MARKET           AS PACK_MARKET
								               									A.FACTORY_ID       AS TO_FACTORY_ID ,
								                                                B.CELL_ITEM_ID    AS CELL_ITEM_ID,
								                                                B.PARENT_QTY,
								                                                B.CHILD_QTY,
								                                                B.COMPANY_ID,
								                                                B.DIVISION_ID,
								                                                B.SITE_ID,
								                    							B.PLANT_ID,
								                                                B.ALT_PRIORITY,
								     											DENSE_RANK() OVER (PARTITION BY B.COMPANY_ID,
													                                                                                B.DIVISION_ID,
													                                                                                B.SITE_ID,
													                                                                                B.PLANT_ID,
													                                                                                B.ITEM_ID,
													                                                                                A.WORK_ORDER_ID -- ADD SONG
													                            							ORDER     BY B.KEY_DATE DESC) AS SEQ,
								                                                A.LINE_ID,
								                                               -- A.TOP_ITEM_ID AS TOP_ITEM_ID
								                                                A.ITEM_ID AS  ITEM_ID,
								                                                A.OPERATION_ID
							                                        FROM   (
										                                                SELECT A.*
										                                                --FROM   FP_RELEASE_FIX_PLAN_H  A
										                                                FROM    FP_RELEASE_FULL_PLAN_H  A
										                                                      , TH_BUF_RELEASE_PLAN B
										                                                WHERE  A.INSTANCE_ID      = B.INSTANCE_ID
										                                                AND    A.INSTANCE_DATE    = B.INSTANCE_DATE
										                                                AND    A.RELEASE_PLAN_ID  = B.RELEASE_PLAN_ID
										                                                --AND    A.AMEND_PLAN_ID    = B.AMEND_PLAN_ID
										                                                --AND    A.DIVISION_ID      = B.DIVISION_ID
										                                                AND    A.FACTORY_ID       = B.FACTORY_ID
										                                                AND    A.LINE_ID          = B.LINE_ID
										                                                --AND    A.PLAN_DATE       >= @v_plan_date    -- PLAN 일자 이후
										                                                AND    A.PLAN_DATE       >= B.RELEASE_DATE      -- 2018.03.26 : RELEASE_DATE 일자 이후
										                                                AND    B.INSTANCE_ID = @v_master_id
										                                                AND    A.PLAN_DATE >= CONVERT(NVARCHAR,@v_target_date,112)
								                                               ) A        
								                                              ,(
										                                                SELECT  A.* , B.EFF_START_DATE , B.EFF_END_DATE , B.KEY_DATE
										                        		                    FROM    TH_BUF_PACK_BOM_INFO A 
										                                                      , SCM_BOM_M B
										                        		                    WHERE   A.INSTANCE_ID = @v_master_id 
										                        		                    AND		  A.COMPANY_ID  = B.COMPANY_ID 
										                        		                    AND		  A.DIVISION_ID = B.DIVISION_ID 
										                        		                    AND		  A.SITE_ID     = B.SITE_ID 
										                        		                    AND		  A.PLANT_ID    = B.PLANT_ID 
										                        		                    AND		  A.ITEM_ID     = B.PARENT_ITEM_ID 
										                        		                    AND		  A.CELL_ITEM_ID = B.CHILD_ITEM_ID 
								                                                ) B
								                                        WHERE  A.ITEM_ID      = B.ITEM_ID
								                           				AND    A.DIVISION_ID  = B.DIVISION_ID
								                                        AND    A.PLAN_DATE   >= B.EFF_START_DATE
								                                        AND    A.PLAN_DATE    < B.EFF_END_DATE
						                                       ) A
						                                        LEFT OUTER JOIN (		-- (D20201110~R1110.01)
																							SELECT 	A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID, A.ITEM_ID AS ASSIGN_ITEM_ID, MONTH, MIN(PRIORITY) AS LINE_PRIORITY
																							FROM   	SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)
																							WHERE 	1=1
																							AND 		OPERATION_ID = 'A9000'
																							AND 		PRIORITY NOT IN ('0','9')
																							AND 		MONTH >= SUBSTRING(CONVERT(NVARCHAR,@v_target_date,112),1,6) 
																							GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID, A.ITEM_ID, MONTH
																) X
																	ON A.COMPANY_ID = X.COMPANY_ID
																	AND A.DIVISION_ID = X.DIVISION_ID 
																	AND A.SITE_ID = X.SITE_ID
																	AND A.PLANT_ID = X.PLANT_ID 
																	AND A.CELL_ITEM_ID  = X.ASSIGN_ITEM_ID
																	AND SUBSTRING(CONVERT(NVARCHAR,A.PACK_PLAN_DATE,112),1,6) = X.MONTH
						                                       LEFT OUTER JOIN SCM_TACT_TIME_EXCEPT_M B
						                                            ON A.COMPANY_ID = B.COMPANY_ID
						                      						 AND A.DIVISION_ID = B.DIVISION_ID 
						     										AND A.SITE_ID = B.SITE_ID
						                                            AND A.PLANT_ID = B.PLANT_ID 
						                                            AND A.ITEM_ID  = B.ITEM_ID
						                                            AND A.LINE_ID = B.LINE_ID 
						                                            AND A.PACK_PLAN_DATE > = B.START_TIME
						                                            AND A.PACK_PLAN_DATE <= B.END_TIME
						      									LEFT OUTER JOIN SCM_TACT_TIME_M C
						                                       		  ON A.COMPANY_ID = C.COMPANY_ID
						                                            AND A.DIVISION_ID = C.DIVISION_ID 
						                                       		AND A.SITE_ID = C.SITE_ID
						                                            AND A.PLANT_ID = C.PLANT_ID 
						                                            AND A.ITEM_ID  = C.ITEM_ID
						                                            AND A.LINE_ID = C.LINE_ID 
						                                            AND SUBSTRING(CONVERT(NVARCHAR,A.PACK_PLAN_DATE,112),1,6) = c.month  
                                      /*LEFT OUTER JOIN (
                                      								  SELECT COMPANY_ID , DIVISION_ID , SITE_ID ,  PLANT_ID , FACTORY_ID , MONTH , ITEM_ID   
                                      									FROM SCM_TACT_TIME_M
                                      									WHERE 1=1 
                                      									AND DAILY_CAPA > 0 
                                      									AND OPERATION_ID = 'F6000'
                                      									AND MONTH >= SUBSTRING(CONVERT(NVARCHAR,@v_target_date,112),1,6) 
                                      									GROUP BY COMPANY_ID , DIVISION_ID , SITE_ID ,  PLANT_ID , FACTORY_ID , MONTH , ITEM_ID 
                                      							  )D
                                        	  ON A.COMPANY_ID = D.COMPANY_ID
                                        	  --AND A.DIVISION_ID = B.DIVISION_ID
                                        	  AND A.SITE_ID = D.SITE_ID
                                        	  AND A.PLANT_ID = D.PLANT_ID
                                        	  --AND A.TO_FACTORY_ID = D.FACTORY_ID
                                        	  AND SUBSTRING(CONVERT(NVARCHAR,A.PACK_PLAN_DATE,112),1,6) = D.MONTH
                                        	  AND A.CELL_ITEM_ID = D.ITEM_ID     */
                                       
                           							) A        
                        ) A, SCM_SYS_CALENDAR_M B
                WHERE   A.PACK_PLAN_DATE = B.DATE_ID
                AND     A.PACK_PLAN_DATE >= @v_target_date
                AND     NOT EXISTS  (
        									          	SELECT 1
                  										FROM SCM_SYS_LOOKUP_VALUE X
                  										WHERE X.LOOKUP_TYPE_CODE = 'FORMATION_PACK_EXCEPT_ITEM'
                  										AND  A.SITE_ID = X.SEGMENT3
                  										AND  A.DIVISION_ID = X.SEGMENT2
                  										AND  A.CELL_ITEM_ID = X.SEGMENT5
                									  )
                AND     NOT EXISTS ( /*조립 3개월 실적 PILIOT LINE 제외*/
                    							    SELECT 1
                        							FROM (
          			              							SELECT *
          										              FROM (
          													              SELECT A.* , COUNT(A.LINE_ID) OVER (PARTITION BY A.COMPANY_ID ,A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.ITEM_ID) AS CNT2
          													              FROM (
          										                          SELECT A.COMPANY_ID ,A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.LINE_ID  , A.ITEM_ID  , A.LINE_NAME , A.DESCRIPTION , 
            															              			COUNT(A.LINE_ID) OVER (PARTITION BY A.COMPANY_ID ,A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.ITEM_ID) AS CNT
        										                            FROM ( -- 실적
                  										                SELECT A.COMPANY_ID ,A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.LINE_ID  , A.ITEM_ID  , B.LINE_NAME , B.DESCRIPTION
                          										                FROM  SCM_DAILY_PRODUCT_RESULT_H A,  SCM_LINE_M B 
                  															              WHERE A.PLAN_DATE >= DATEADD(MONTH,-3,@v_plan_date)
                  															              AND A.OPERATION_ID = 'A9000'
                  															              AND A.COMPANY_ID = B.COMPANY_ID
                  															              AND A.DIVISION_ID = B.DIVISION_ID 
                  															              AND A.SITE_ID = B.SITE_ID
                  															              AND A.PLANT_ID = B.PLANT_ID
                  															              AND A.OPERATION_ID = B.OPERATION_ID
                  															              AND A.LINE_ID = B.LINE_ID
                  															              GROUP BY A.COMPANY_ID ,A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.LINE_ID , A.ITEM_ID , B.LINE_NAME , B.DESCRIPTION
                															                UNION ALL  -- 마지막 Release 계획
  											                                      SELECT A.COMPANY_ID ,A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.LINE_ID  , A.ITEM_ID  , C.LINE_NAME , C.DESCRIPTION 
                              									  					  FROM  FP_DAILY_PRODUCTION_PLAN_R A ,
                              									  					  		  (
                              									  					  		  		-- Modify (D.20210427~R.0427.01) plan group type 대응
                              									  					  		  		/**
	                              									  					  				SELECT  INSTANCE_ID , 
	                        																	                    INSTANCE_DATE , 
	                        																	                    DIVISION_ID , 
	                        																	                    FACTORY_ID ,
	                        																  			        	    MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE , DIVISION_ID , FACTORY_ID   ) AS RELEASE_PLAN_ID ,
	                      																	                      AMEND_PLAN_ID,
	                            																  				        CASE  WHEN RELEASE_PLAN_ID = MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE , DIVISION_ID , FACTORY_ID   ) 
	                        														      		  						  	    THEN 'Y'
	                          														      		  						 	    ELSE 'N'
	                  																      		  			    	    END AS CK_ID,			  
	                        																		                  A.SEQ ,
	                              													                      CONVERT(DATE, A.INSTANCE_DATE) AS RELEASE_DATE    
	                              															    	    FROM  (
	                            													    					          	SELECT A.*
	                            													    					               , DENSE_RANK() OVER (PARTITION BY FACTORY_ID
	                            													    					                                    ORDER     BY INSTANCE_DATE DESC) AS SEQ
	                            													    					          	FROM   FP_RELEASE_PLAN_INFO_H  A
	                            													                        			WHERE  INSTANCE_ID = @v_cell_master_id
	                              																         			) A
	                              											  					  	  WHERE  SEQ = 1 
	                              											  					  	  **/
	                              											  					  	  	SELECT  DISTINCT	A.INSTANCE_ID , A.FACTORY_ID , A.INSTANCE_DATE , A.RELEASE_DATE , A.RELEASE_PLAN_ID , 
																															A.AMEND_PLAN_ID , A.LINE_ID
																										FROM 	(			
																													SELECT  INSTANCE_ID , INSTANCE_DATE , FACTORY_ID , LINE_ID , A.SEQ , 
																															MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE  , FACTORY_ID ,LINE_ID   ) AS RELEASE_PLAN_ID ,
																															AMEND_PLAN_ID,
																															CASE WHEN RELEASE_PLAN_ID = MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE  , FACTORY_ID , LINE_ID   ) 
																																	THEN 'Y'
																																	ELSE 'N'
																															END AS CK_ID,			  
																															CONVERT(DATE, A.INSTANCE_DATE) AS RELEASE_DATE   
																													FROM   (
																																SELECT A.*
																																		, DENSE_RANK() OVER (	PARTITION BY FACTORY_ID , LINE_ID 
																																								ORDER     BY INSTANCE_DATE DESC		) AS SEQ
																																FROM  	FP_RELEASE_PLAN_LINE_INFO_H  A
																																WHERE  	A.INSTANCE_ID = @v_cell_master_id
																															) A
																													WHERE  SEQ = 1  
																												) A
																										WHERE 	A.CK_ID = 'Y'
                              									  					  			)B , 
                              									  					  			SCM_LINE_M  C
                              									  					  WHERE A.INSTANCE_ID = B.INSTANCE_ID	
                              									  					  AND A.FP_PLAN_ID = B.RELEASE_PLAN_ID 
                              									  					  --AND A.DIVISION_ID = B.DIVISION_ID	-- Del (D.20210427~R.0427.01)
                              									  					  AND A.FACTORY_ID = B.FACTORY_ID 
                              									  					  AND A.LINE_ID = B.LINE_ID		-- Add (D.20210427~R.0427.01)
                              									  					  AND A.OPERATION_ID = 'A9000'
                              									  					  AND A.COMPANY_ID = C.COMPANY_ID
                          											              AND A.DIVISION_ID = C.DIVISION_ID 
                          											              AND A.SITE_ID = C.SITE_ID
                          											              AND A.PLANT_ID = C.PLANT_ID
                          											              AND A.OPERATION_ID = C.OPERATION_ID
                          											              AND A.LINE_ID = C.LINE_ID
                          											              GROUP BY A.COMPANY_ID ,A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.LINE_ID , A.ITEM_ID , C.LINE_NAME , C.DESCRIPTION
  											                                    )A
              											                    GROUP BY A.COMPANY_ID ,A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.LINE_ID , A.ITEM_ID , A.LINE_NAME , A.DESCRIPTION
                											                  )A
      													                    WHERE EXISTS (
      													                    								SELECT 1
      													                    								FROM  SCM_SYS_LOOKUP_VALUE  X 
      													                    								WHERE X.LOOKUP_TYPE_CODE = 'REQUEST_PLAN_EXCEPT_PILOT_LINE'
      													                    								AND		 A.COMPANY_ID = X.SEGMENT1
      													                    								AND		 A.DIVISION_ID = X.SEGMENT2
      													                    								AND		 A.SITE_ID = X.SEGMENT3
      													                    								AND	     A.PLANT_ID = X.SEGMENT4
      													                    								AND		 A.LINE_ID = X.SEGMENT5
      													                    							) --= 'A2AP3' -- UPPER(A.LINE_NAME) LIKE '%PILOT%'
    										              		          )A
            										              WHERE  A.CNT = A.CNT2  -- PILOT 라인으로만 구성된 경우임.
            										              --AND 	 A.LINE_ID = 'A2AP3' -- PILOT 3호기에서만 (20181030 요청)
      							                          )X
            							              WHERE  A.COMPANY_ID = X.COMPANY_ID
            							              AND    A.DIVISION_ID = X.DIVISION_ID
            							              AND    A.SITE_ID = X.SITE_ID
            							              AND    A.PLANT_ID = X.PLANT_ID
            							              AND    A.CELL_ITEM_ID = X.ITEM_ID
              						            )                    
                )A
                GROUP BY  A.COMPANY_ID , 
      									  A.DIVISION_ID , 
      									  A.SITE_ID , 
      									  A.PLANT_ID , 
      									  A.INSTANCE_ID  , 
  					  				 	  A.CELL_ITEM_ID , 
  					  				 	  A.ALT_PRIORITY ,
  					  				 	  A.L_ALT_PRIORITY,	--(D20201110~R1110.01)
  					  				 	  A.SCP_WEEK , 
  					  				 	  A.MFG_WEEK,    
                          A.WORK_ORDER_ID , 
                          A.DUE_DATE  , 
                          A.DUE_FENCE_DATE , 
                          --A.PRODUCTION_TYPE , 
                          A.LINE_ID , 
                          --A.MARKET , 
                          A.PRIORITY , 
  						  				  A.OFFSET_INVENTORY_QTY , 
                          A.OFFSET_GI_QTY , 
                          A.OFFSET_FIX_QTY , 
                          A.DEMAND_TYPE , 
                          A.TARGET_TYPE , 
                          A.STORAGE_ID , 
                          A.OPERATION_ID , 
                          A.SAFETY_CAPA
          
              -- L_ALT_PRIORITY 기준으로 (D20201110~R1110.01)
	          --DELETE TH_BUF_DEMAND_PACK_REQUIRE WHERE INSTANCE_ID = @v_master_id AND ALT_PRIORITY = 9       AND ALT_PRIORITY IS NOT NULL          
	          DELETE TH_BUF_DEMAND_PACK_REQUIRE 
	          WHERE INSTANCE_ID = @v_master_id 
	          AND ( ALT_PRIORITY = 9 OR  L_ALT_PRIORITY <> 1 )      
	          AND ALT_PRIORITY IS NOT NULL
        
        END
        ELSE
        BEGIN
        
          INSERT INTO TH_BUF_DEMAND_PACK_REQUIRE    
                (
                	COMPANY_ID , 
                	DIVISION_ID , 
                	SITE_ID , 
                	PLANT_ID , 
                	INSTANCE_ID ,
                	FP_DEMAND_ID , 
                 -- TOP_ITEM_ID ,
                 --	ITEM_ID , 
                	CELL_ITEM_ID ,
                	ALT_PRIORITY ,
                	L_ALT_PRIORITY , 
                	SCP_WEEK , 
  					MFG_WEEK ,
                	MFG_QTY ,
					WORK_ORDER_ID , 
                	DUE_DATE , 
                	DUE_FENCE_DATE , 
                	PRODUCTION_TYPE , 
                	LINE_ID , 
                	MARKET ,
                	PRIORITY , 
                	OFFSET_INVENTORY_QTY ,
                	OFFSET_GI_QTY ,
                	OFFSET_FIX_QTY ,
                	DEMAND_TYPE , 
                	TARGET_TYPE ,
                	STORAGE_ID ,
                  OPERATION_ID , 
                  SAFETY_CAPA 
                ) 
          SELECT  A.COMPANY_ID , 
                  A.DIVISION_ID , 
                  A.SITE_ID , 
                  A.PLANT_ID , 
                  A.INSTANCE_ID , 
                  MAX(FP_DEMAND_ID)  AS FP_DEMAND_ID , 
  		  				  A.CELL_ITEM_ID , 
                  A.ALT_PRIORITY , 
                  A.L_ALT_PRIORITY,
                  A.SCP_WEEK , 
                  A.MFG_WEEK,  
                  SUM(MFG_QTY) AS MFG_QTY , 
                  A.WORK_ORDER_ID , 
                  A.DUE_DATE  , 
                  A.DUE_FENCE_DATE , 
                  'MASS' AS PRODUCTION_TYPE ,  --A.PRODUCTION_TYPE , 
                  A.LINE_ID AS LINE_ID , 
                  'D' AS MARKET , --A.MARKET , 
                  A.PRIORITY , 
  		  				  A.OFFSET_INVENTORY_QTY , 
                  A.OFFSET_GI_QTY , 
                  A.OFFSET_FIX_QTY , 
                  A.DEMAND_TYPE , 
                  A.TARGET_TYPE , 
                  A.STORAGE_ID , 
                  A.OPERATION_ID , 
                  A.SAFETY_CAPA
          FROM (
                SELECT   A.COMPANY_ID ,
                         A.DIVISION_ID ,
                         A.SITE_ID ,
                         A.PLANT_ID ,
                         @v_master_id   AS INSTANCE_ID ,
                         A.PACK_WORK_ORDER_ID AS FP_DEMAND_ID , -- 대치품때문에 UNIQUE 하지 않다.
                         --A.TOP_ITEM_ID AS TOP_ITEM_ID , 
                         --A.ITEM_ID ,
                         A.CELL_ITEM_ID,
                         A.ALT_PRIORITY ,
                         A.L_ALT_PRIORITY as L_ALT_PRIORITY,
                         B.WEEK         AS SCP_WEEK ,
                         B.WEEK         AS MFG_WEEK ,
                         A.MFG_QTY ,
                         NULL AS WORK_ORDER_ID , -- 'A'           AS WORK_ORDER_ID ,
                         A.PACK_PLAN_DATE   AS DUE_DATE ,
                         A.PACK_PLAN_DATE   AS DUE_FENCE_DATE ,
                         ISNULL(PACK_PRODUCTION_TYPE, 'MASS')  AS PRODUCTION_TYPE ,
                         A.LINE_ID      AS LINE_ID , 
                         A.MARKET       AS MARKET , 
                         NULL           AS PRIORITY ,
                         0              AS OFFSET_INVENTORY_QTY ,
                         0              AS OFFSET_GI_QTY ,
                         0              AS OFFSET_FIX_QTY ,
                         'NOR'          AS DEMAND_TYPE ,
                         'PACK_RELEASE'    AS TARGET_TYPE ,
                         NULL AS STORAGE_ID,
                         A.OPERATION_ID AS OPERATION_ID , 
                         A.SAFETY_CAPA
                FROM   (
                			 SELECT A.* 
                			 		, DENSE_RANK() OVER  (	PARTITION BY A.COMPANY_ID , A.SITE_ID , A.PLANT_ID  ,A.ITEM_ID, SUBSTRING(CONVERT(NVARCHAR,A.PACK_PLAN_DATE,112),1,6)  
		                          												ORDER BY A.LINE_PRIORITY , A.ALT_PRIORITY ) AS  L_ALT_PRIORITY
		                     FROM	(
				                          SELECT  DISTINCT A.*,
				                                  CEILING(PACK_PLAN_IN_QTY * ( CHILD_QTY / PARENT_QTY)) AS MFG_QTY,
				                                  DENSE_RANK() OVER (PARTITION BY PACK_WORK_ORDER_ID
				                                                      ORDER     BY CELL_ITEM_ID) - 1 AS ORDER_SEQ,
				                                                  --  ISNULL(B.DAILY_CAPA  ,C.DAILY_CAPA),
				                                   --  ( CHILD_QTY / PARENT_QTY) ,
				                                  ((ISNULL(B.DAILY_CAPA  ,C.DAILY_CAPA)  *     ( CHILD_QTY / PARENT_QTY)) * @n_precede) AS SAFETY_CAPA       
												  , ISNULL(X.LINE_PRIORITY,9) AS LINE_PRIORITY
				                          FROM   (
						                                  SELECT  A.RELEASE_PLAN_ID  AS SCP_PLAN_ID,
						                                          A.WORK_ORDER_ID    AS PACK_WORK_ORDER_ID,
						     										A.PLAN_DATE        AS PACK_PLAN_DATE,
						                                          A.PLAN_IN_QTY      AS PACK_PLAN_IN_QTY,
						                                          A.PRODUCTION_TYPE  AS PACK_PRODUCTION_TYPE,
						                                          A.MARKET                AS MARKET, --A.MARKET           AS PACK_MARKET
						                                          A.FACTORY_ID       AS TO_FACTORY_ID ,
						                                          B.CHILD_ITEM_ID    AS CELL_ITEM_ID,
						                                          B.PARENT_QTY,
						                                          B.CHILD_QTY,
						                                          B.COMPANY_ID,
						                                          B.DIVISION_ID,
						                                          B.SITE_ID,
						                                          B.PLANT_ID,
						                                          B.ALT_PRIORITY,
						                                          DENSE_RANK() OVER (PARTITION BY B.COMPANY_ID,
						                                                                          B.DIVISION_ID,
						                                                                          B.SITE_ID,
						                                                                          B.PLANT_ID,
						                                                                          B.PARENT_ITEM_ID,
						                                                                          A.WORK_ORDER_ID -- ADD SONG
						                                                              ORDER     BY B.KEY_DATE DESC) AS SEQ,
						                                          A.LINE_ID,
						                                         -- A.TOP_ITEM_ID AS TOP_ITEM_ID
						                                          A.ITEM_ID AS  ITEM_ID,
						                                          A.OPERATION_ID
						                                  FROM   (
							                                          SELECT A.*
							                                          --FROM   FP_RELEASE_FIX_PLAN_H  A
							                                          FROM   FP_RELEASE_FULL_PLAN_H  A
							                                                , TH_BUF_RELEASE_PLAN B
							                                          WHERE  A.INSTANCE_ID      = B.INSTANCE_ID
							                                          AND    A.INSTANCE_DATE    = B.INSTANCE_DATE
							                                          AND    A.RELEASE_PLAN_ID  = B.RELEASE_PLAN_ID
							                                          --AND    A.AMEND_PLAN_ID    = B.AMEND_PLAN_ID
							                                          --AND    A.DIVISION_ID      = B.DIVISION_ID
							                                          AND    A.FACTORY_ID       = B.FACTORY_ID
							                                          AND    A.LINE_ID          = B.LINE_ID
							                                          --AND    A.PLAN_DATE       >= @v_plan_date    -- PLAN 일자 이후
							                                          AND    A.PLAN_DATE       >= B.RELEASE_DATE      -- 2018.03.26 : RELEASE_DATE 일자 이후
							                                          AND    B.INSTANCE_ID = @v_master_id
						                                         ) A        
						                                        ,(
							                                          SELECT  *
							                                          FROM   SCM_BOM_M   A
							                                          WHERE  ACTIVE_FLAG = 'Y'
							                                          AND    EXISTS (
							                                                          SELECT 1
							                                                          FROM   TH_BUF_FORM_INSTANCE_FLOW B
							                                                          WHERE  B.MASTER_ID    = @v_master_id
							                                                          AND    B.COMPANY_ID   = A.COMPANY_ID
							                                                          AND    B.DIVISION_ID  = A.DIVISION_ID
							                                                          AND    B.SITE_ID      = A.SITE_ID
							                                                          AND    B.ITEM_ID      = A.CHILD_ITEM_ID
							                                                         )
							                                           -- AND ISNULL(A.ALT_PRIORITY,1) = 1  
						                                          ) B
						                                  WHERE  A.ITEM_ID      = B.PARENT_ITEM_ID
						                                  AND    A.DIVISION_ID  = B.DIVISION_ID
						                                  AND    A.PLAN_DATE   >= B.EFF_START_DATE
						                                  AND    A.PLAN_DATE    < B.EFF_END_DATE
				                                 ) A
				                                 LEFT OUTER JOIN (
																	SELECT 	A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID, A.ITEM_ID AS ASSIGN_ITEM_ID, MONTH, MIN(PRIORITY) AS LINE_PRIORITY
																	FROM   	SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)
																	WHERE 	1=1
																	AND 		OPERATION_ID = 'A9000'
																	AND 		PRIORITY NOT IN ('0','9')
																	AND 		MONTH >= SUBSTRING(CONVERT(NVARCHAR,@v_target_date,112),1,6) 
																	GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID, A.ITEM_ID, MONTH
												 ) X
													ON A.COMPANY_ID = X.COMPANY_ID
													AND A.DIVISION_ID = X.DIVISION_ID 
													AND A.SITE_ID = X.SITE_ID
													AND A.PLANT_ID = X.PLANT_ID 
													AND A.CELL_ITEM_ID  = X.ASSIGN_ITEM_ID
													AND SUBSTRING(CONVERT(NVARCHAR,A.PACK_PLAN_DATE,112),1,6) = X.MONTH
				                                 LEFT OUTER JOIN SCM_TACT_TIME_EXCEPT_M B
				        		                         ON A.COMPANY_ID = B.COMPANY_ID
				        		                         AND A.DIVISION_ID = B.DIVISION_ID 
				        		                         AND A.SITE_ID = B.SITE_ID
				        		                         AND A.PLANT_ID = B.PLANT_ID 
				        		                         AND A.ITEM_ID  = B.ITEM_ID
				        		                         AND A.LINE_ID = B.LINE_ID 
				        		                         AND A.PACK_PLAN_DATE > = B.START_TIME
				        		                         AND A.PACK_PLAN_DATE <= B.END_TIME
				                                 LEFT OUTER JOIN SCM_TACT_TIME_M C
				                                 		 ON A.COMPANY_ID = C.COMPANY_ID
				        		                         AND A.DIVISION_ID = C.DIVISION_ID 
				        		                         AND A.SITE_ID = C.SITE_ID
				        		                         AND A.PLANT_ID = C.PLANT_ID 
				        		                         AND A.ITEM_ID  = C.ITEM_ID
				        		                         AND A.LINE_ID = C.LINE_ID 
				        		                         AND SUBSTRING(CONVERT(NVARCHAR,A.PACK_PLAN_DATE,112),1,6) = c.month 
									) A
                        ) A, SCM_SYS_CALENDAR_M B
                WHERE   A.PACK_PLAN_DATE = B.DATE_ID
                AND     A.PACK_PLAN_DATE >= @v_target_date
                AND     NOT EXISTS  (
        									          	SELECT 1
                  										FROM SCM_SYS_LOOKUP_VALUE X
                  										WHERE X.LOOKUP_TYPE_CODE = 'FORMATION_PACK_EXCEPT_ITEM'
                  										AND  A.SITE_ID = X.SEGMENT3
                  										AND  A.DIVISION_ID = X.SEGMENT2
                  										AND  A.CELL_ITEM_ID = X.SEGMENT5
                									  )
                AND     NOT EXISTS ( /*조립 3개월 실적 PILIOT LINE 제외*/
                    							    SELECT 1
                        							FROM (
          			              							SELECT *
          										              FROM (
          													              SELECT A.* , COUNT(A.LINE_ID) OVER (PARTITION BY A.COMPANY_ID ,A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.ITEM_ID) AS CNT2
          													              FROM (
          										                          SELECT A.COMPANY_ID ,A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.LINE_ID  , A.ITEM_ID  , A.LINE_NAME , A.DESCRIPTION , 
            															              			COUNT(A.LINE_ID) OVER (PARTITION BY A.COMPANY_ID ,A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.ITEM_ID) AS CNT
        										                            FROM ( -- 실적
                          										                SELECT A.COMPANY_ID ,A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.LINE_ID  , A.ITEM_ID  , B.LINE_NAME , B.DESCRIPTION
                          										                FROM  SCM_DAILY_PRODUCT_RESULT_H A,  SCM_LINE_M B 
                  															              WHERE A.PLAN_DATE >= DATEADD(MONTH,-3,@v_plan_date)
                  															              AND A.OPERATION_ID = 'A9000'
                  															              AND A.COMPANY_ID = B.COMPANY_ID
                  															              AND A.DIVISION_ID = B.DIVISION_ID 
                  															              AND A.SITE_ID = B.SITE_ID
                  															              AND A.PLANT_ID = B.PLANT_ID
                  															    AND A.OPERATION_ID = B.OPERATION_ID
                  															              AND A.LINE_ID = B.LINE_ID
                  															              GROUP BY A.COMPANY_ID ,A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.LINE_ID , A.ITEM_ID , B.LINE_NAME , B.DESCRIPTION
                															                UNION ALL  -- 마지막 Release 계획
  											                                      SELECT A.COMPANY_ID ,A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.LINE_ID  , A.ITEM_ID  , C.LINE_NAME , C.DESCRIPTION 
                              									  					  FROM  FP_DAILY_PRODUCTION_PLAN_R A ,
                              									  					  		  (
                              									  					  		  		-- Modify (D.20210427~R.0427.01) @@@ plan group type 대응
                              									  					  		  		/**
                              									  					  				SELECT  INSTANCE_ID , 
                        																	                    INSTANCE_DATE , 
                        																	                    DIVISION_ID , 
                        																	                    FACTORY_ID ,
                        																  			        	    MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE , DIVISION_ID , FACTORY_ID   ) AS RELEASE_PLAN_ID ,
                      																	                      AMEND_PLAN_ID,
                            																  				        CASE  WHEN RELEASE_PLAN_ID = MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE , DIVISION_ID , FACTORY_ID   ) 
                        														      		  						  	    THEN 'Y'
                          														      		  						 	    ELSE 'N'
                  																      		  			    	    END AS CK_ID,			  
                        																		                  A.SEQ ,
                              													                      CONVERT(DATE, A.INSTANCE_DATE) AS RELEASE_DATE    
                              															    	    FROM  (
                            													    					          SELECT A.*
                            													    					               , DENSE_RANK() OVER (PARTITION BY FACTORY_ID
                            													    					                                    ORDER     BY INSTANCE_DATE DESC) AS SEQ
                            													    					          FROM   FP_RELEASE_PLAN_INFO_H  A
                            													                        WHERE  INSTANCE_ID = @v_cell_master_id
                              																         			) A
                              											  					  	  	WHERE  SEQ = 1 
                              											  					  	  	**/
                              											  					  	  	SELECT  DISTINCT	A.INSTANCE_ID , A.FACTORY_ID , A.INSTANCE_DATE , A.RELEASE_DATE , A.RELEASE_PLAN_ID , 
																														A.AMEND_PLAN_ID , A.LINE_ID
																									FROM 	(			
																												SELECT  INSTANCE_ID , INSTANCE_DATE , FACTORY_ID , LINE_ID , A.SEQ , 
																														MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE  , FACTORY_ID ,LINE_ID   ) AS RELEASE_PLAN_ID ,
																														AMEND_PLAN_ID,
																														CASE WHEN RELEASE_PLAN_ID = MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE  , FACTORY_ID , LINE_ID   ) 
																																THEN 'Y'
																																ELSE 'N'
																														END AS CK_ID,			  
																														CONVERT(DATE, A.INSTANCE_DATE) AS RELEASE_DATE   
																												FROM   (
																															SELECT A.*
																																	, DENSE_RANK() OVER (	PARTITION BY FACTORY_ID , LINE_ID 
																																							ORDER     BY INSTANCE_DATE DESC		) AS SEQ
																															FROM  	FP_RELEASE_PLAN_LINE_INFO_H  A
																															WHERE  	A.INSTANCE_ID = @v_cell_master_id
																														) A
																												WHERE  SEQ = 1  
																											) A
																									WHERE 	A.CK_ID = 'Y'
                              									  					  			)B , 
                              									  					  			SCM_LINE_M  C
                              									  					  WHERE A.INSTANCE_ID = B.INSTANCE_ID	
                              									  					  AND A.FP_PLAN_ID = B.RELEASE_PLAN_ID 
                              									  					  --AND A.DIVISION_ID = B.DIVISION_ID	-- Del (D.20210427~R.0427.01)
                              									  					  AND A.FACTORY_ID = B.FACTORY_ID 
 									  					  			  AND A.LINE_ID	   = B.LINE_ID		-- Add (D.20210427~R.0427.01)
                              									  					  AND A.OPERATION_ID = 'A9000'
                              									  					  AND A.COMPANY_ID = C.COMPANY_ID
                          											              AND A.DIVISION_ID = C.DIVISION_ID 
                          											              AND A.SITE_ID = C.SITE_ID
                          											              AND A.PLANT_ID = C.PLANT_ID
                          											              AND A.OPERATION_ID = C.OPERATION_ID
                          											              AND A.LINE_ID = C.LINE_ID
                     											              GROUP BY A.COMPANY_ID ,A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.LINE_ID , A.ITEM_ID , C.LINE_NAME , C.DESCRIPTION
  											                                    )A
              											                    GROUP BY A.COMPANY_ID ,A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.LINE_ID , A.ITEM_ID , A.LINE_NAME , A.DESCRIPTION
                											                  )A
      													                    WHERE EXISTS (
      													                    								SELECT 1
      													                    								FROM  SCM_SYS_LOOKUP_VALUE  X 
      													                    								WHERE X.LOOKUP_TYPE_CODE = 'REQUEST_PLAN_EXCEPT_PILOT_LINE'
      													                    								AND		 A.COMPANY_ID = X.SEGMENT1
      													                    								AND		 A.DIVISION_ID = X.SEGMENT2
      													                    								AND		 A.SITE_ID = X.SEGMENT3
      													                    								AND	     A.PLANT_ID = X.SEGMENT4
      													                    								AND		 A.LINE_ID = X.SEGMENT5
      													                    							) --= 'A2AP3' -- UPPER(A.LINE_NAME) LIKE '%PILOT%'
    										              		          )A
            										              WHERE  A.CNT = A.CNT2  -- PILOT 라인으로만 구성된 경우임.
            										              --AND 	 A.LINE_ID = 'A2AP3' -- PILOT 3호기에서만 (20181030 요청)
      							                          )X
            							              WHERE  A.COMPANY_ID = X.COMPANY_ID
            							              AND    A.DIVISION_ID = X.DIVISION_ID
            							              AND    A.SITE_ID = X.SITE_ID
            							              AND    A.PLANT_ID = X.PLANT_ID
            							              AND    A.CELL_ITEM_ID = X.ITEM_ID
              						            )                    
                )A
                GROUP BY	A.COMPANY_ID , 
      						A.DIVISION_ID , 
      						A.SITE_ID , 
      						A.PLANT_ID , 
      						A.INSTANCE_ID  , 
  					  		A.CELL_ITEM_ID , 
  					  		A.ALT_PRIORITY ,
  					  		A.L_ALT_PRIORITY, 
  					  		A.SCP_WEEK , 
  					  		A.MFG_WEEK,    
							A.WORK_ORDER_ID , 
							A.DUE_DATE  , 
							A.DUE_FENCE_DATE , 
							--A.PRODUCTION_TYPE , 
							A.LINE_ID , 
							--A.MARKET , 
							A.PRIORITY , 
  						  	A.OFFSET_INVENTORY_QTY , 
							A.OFFSET_GI_QTY , 
							A.OFFSET_FIX_QTY , 
							A.DEMAND_TYPE , 
							A.TARGET_TYPE , 
							A.STORAGE_ID , 
							A.OPERATION_ID , 
							A.SAFETY_CAPA
          
          END
          
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
        
        INSERT INTO TH_BUF_DEMAND_PACK_REQUIRE
                (
                	COMPANY_ID,
                	DIVISION_ID,
                	SITE_ID,
                	PLANT_ID,
                	INSTANCE_ID,
                	FP_DEMAND_ID,
                	CELL_ITEM_ID,
                	ALT_PRIORITY,
                	SCP_WEEK,
                	MFG_WEEK,
                	MFG_QTY,
                	WORK_ORDER_ID,
                	DUE_DATE,
                	DUE_FENCE_DATE,
                	PRODUCTION_TYPE,
                	LINE_ID,
                	MARKET,
                	PRIORITY,
                	OFFSET_INVENTORY_QTY,
                	OFFSET_GI_QTY,
                	OFFSET_FIX_QTY,
                	DEMAND_TYPE,
                	TARGET_TYPE,
                	STORAGE_ID,
                	OPERATION_ID,
                	SAFETY_CAPA,
                	C_SEQ
                )
        SELECT  A.COMPANY_ID , 
        		A.DIVISION_ID , 
        		A.SITE_ID , 
        		A.PLANT_ID , 
        		A.INSTANCE_ID , 
        		'DUMMY@' +A.CELL_ITEM_ID+'@' + CONVERT(NVARCHAR,RANK() OVER (PARTITION BY A.CELL_ITEM_ID  ORDER BY A.LINE_ID , B.DATE_ID) )AS FP_DEMAND_ID , 
        		A.CELL_ITEM_ID ,  
        		NULL AS ALT_PRIORITY ,
        		B.WEEK AS SCP_WEEK , 
        		B.WEEK AS MFG_WEEK,
        		0 AS MFG_QTY , 
        		NULL AS WORK_ORDER_ID,
        		B.DATE_ID AS DUE_DATE,
        		B.DATE_ID AS DUE_FENCE_DATE,
        		'MASS' AS PRODUCTION_TYPE,
        		A.LINE_ID , 
        		'D' AS MARKET , --A.MARKET , 
        		NULL AS PRIORITY , 
        		0 AS OFFSET_INVENTORY_QTY,
        		0 AS OFFSET_GI_QTY,
        		0 AS OFFSET_FIX_QTY,
        		'DUMMY' AS DEMAND_TYPE , 
        		'PACK_RELEASE' AS TARGET_TYPE,
        		NULL AS STORAGE_ID,
        		'P5000' AS OPERATION_ID,
        		0 AS SAFETY_CAPA , 
        		0 AS C_SEQ
        FROM (
  				SELECT COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , INSTANCE_ID , CELL_ITEM_ID ,LINE_ID , MARKET  ,DUE_DATE
  				FROM TH_BUF_DEMAND_PACK_REQUIRE A
                WHERE INSTANCE_ID = @v_master_id
  				GROUP BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , INSTANCE_ID , CELL_ITEM_ID ,LINE_ID , MARKET  ,DUE_DATE
              )A ,SCM_SYS_CALENDAR_M B
        WHERE B.DATE_ID >=  @v_target_date				
        AND   B.DATE_ID <=  DATEADD(DAY,84,@v_plan_date	)
        AND   NOT EXISTS (
  							SELECT X.*
  							FROM (
	      							SELECT COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , INSTANCE_ID , CELL_ITEM_ID ,LINE_ID , MARKET  ,DUE_DATE
									FROM TH_BUF_DEMAND_PACK_REQUIRE A
									WHERE INSTANCE_ID = @v_master_id
									GROUP BY COMPANY_ID , DIVISION_ID ,SITE_ID , PLANT_ID , INSTANCE_ID , CELL_ITEM_ID ,LINE_ID , MARKET  ,DUE_DATE
  									)X
  							WHERE	CONVERT(NVARCHAR,B.DATE_ID,112)  = CONVERT(NVARCHAR,X.DUE_DATE,112)  
  							AND		A.CELL_ITEM_ID = X.CELL_ITEM_ID
							AND		A.LINE_ID = X.LINE_ID
  						 )
        GROUP BY A.COMPANY_ID , DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.INSTANCE_ID , A.CELL_ITEM_ID , A.LINE_ID , B.DATE_ID , B.WEEK --MARKET
      
      --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
      
      END   
      
      /*
        확정 PEGGING
      */
      
      IF @p_create_planid = 'N' -- 신규 data 생성 시 confirm 기준 pegging 하지 않음 . fix date 입력후 calculation 시 해당 로직 수행
      BEGIN
      
        SET @v_table_name = 'TH_BUF_DEMAND_PACK_REQUIRE_FIX'
        
        DELETE TH_BUF_DEMAND_PACK_REQUIRE_FIX 
        WHERE INSTANCE_ID = @v_master_id
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description
        
        
        INSERT INTO TH_BUF_DEMAND_PACK_REQUIRE_FIX
               (
                INSTANCE_ID ,
                PLAN_ID ,
                COMPANY_ID ,
                DIVISION_ID ,
                SITE_ID ,
                PLANT_ID ,
                CELL_ITEM_ID ,
                STORAGE_ID ,
                SOC_ID ,
                MARKET ,
                PACK_REQUIRE_ID ,
                REQUIRE_DATE ,
                QTY  ,
                ORG_QTY , 
                SEQ
               )
        SELECT	INSTANCE_ID ,
          			PLAN_ID ,
          			COMPANY_ID ,
          			DIVISION_ID ,
          			SITE_ID ,
          			PLANT_ID ,
          			CELL_ITEM_ID ,
          			STORAGE_ID ,
          			SOC_ID ,
          			MARKET ,
          			PACK_REQUIRE_ID ,
          			REQUIRE_DATE ,
          			REQUIRE_QTY  AS QTY ,
                REQUIRE_QTY  AS ORG_QTY ,
                DENSE_RANK() OVER (ORDER BY CELL_ITEM_ID , REQUIRE_DATE , PACK_REQUIRE_ID ASC ) AS SEQ
        FROM  FP_DEMAND_PACK_REQUIRE_FIX
        WHERE INSTANCE_ID = @v_master_id
        AND   PLAN_ID = @v_confirm_id
        AND   REQUIRE_DATE >= @v_target_date
        AND   REQUIRE_DATE <= @v_fix_date
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
        
        SET @v_table_name = 'C_FIX'
        SET @n_row_count = 0

        DECLARE
          @c_fix$instance_id       nvarchar(30), 
          @c_fix$company_id        nvarchar(30), 
          @c_fix$division_id       nvarchar(30), 
          @c_fix$site_id           nvarchar(30), 
          @c_fix$plant_id          nvarchar(30), 
          @c_fix$cell_item_id      nvarchar(150),
          @c_fix$pack_require_id   nvarchar(30), 
          @c_fix$pack_require_date nvarchar(10), 
          @c_fix$qty               numeric(20,10),
          @c_fix$seq               numeric(20,10)
        
        DECLARE
          @pegging$fp_demand_id    nvarchar(150), 
          @pegging$qty             numeric(20,10),
          @pegging$minus_qty       numeric(20,10),
          @pegging$mfg_qty         numeric(20,10)      

        DECLARE
          C_FIX CURSOR LOCAL FOR
            
            SELECT 
                    INSTANCE_ID ,
                    COMPANY_ID ,
                    DIVISION_ID ,
                    SITE_ID ,
                    PLANT_ID ,
                    CELL_ITEM_ID ,
                    PACK_REQUIRE_ID ,
                    REQUIRE_DATE ,
                    QTY ,
                    SEQ
            FROM   TH_BUF_DEMAND_PACK_REQUIRE_FIX A
            WHERE  A.INSTANCE_ID  = @v_master_id
            AND    A.QTY > 0
            ORDER  BY STORAGE_ID, CELL_ITEM_ID, REQUIRE_DATE, SEQ

        OPEN C_FIX

          WHILE 1 = 1
           
            BEGIN

              FETCH C_FIX
               INTO   @c_fix$instance_id       , 
                      @c_fix$company_id        , 
                      @c_fix$division_id       , 
                      @c_fix$site_id           , 
                      @c_fix$plant_id          , 
                      @c_fix$cell_item_id      ,
                      @c_fix$pack_require_id   , 
                      @c_fix$pack_require_date , 
                      @c_fix$qty               ,
                      @c_fix$seq               


                IF @@FETCH_STATUS <> 0
                  BREAK

                SET @pegging$qty = @c_fix$qty

                WHILE 1 = 1
                  
                  BEGIN


                    IF @pegging$qty <= 0.0
                      BREAK

                    SET @pegging$fp_demand_id = NULL
                      
                    SELECT @pegging$fp_demand_id   = FP_DEMAND_ID,
                           @pegging$minus_qty      = MINUS_QTY,
                           @pegging$mfg_qty        = MFG_QTY
                    FROM   (
                            SELECT A.*,
                                   CASE WHEN (MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) > @pegging$qty THEN @pegging$qty
                                        ELSE (MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY ))
                                   END  AS MINUS_QTY,
                                   ROW_NUMBER() OVER (ORDER     BY DUE_DATE ASC , DUE_FENCE_DATE ASC , MFG_WEEK ASC ) SEQ
                            FROM   (
                                    SELECT A.*
                                    FROM   TH_BUF_DEMAND_PACK_REQUIRE A
                                    WHERE  A.INSTANCE_ID = @c_fix$instance_id
                                    AND    A.COMPANY_ID   = @c_fix$company_id
                                    AND    A.DIVISION_ID  LIKE SUBSTRING(@c_fix$division_id, 1, 1) +'%'       --  81, 82 혼용되어서
                                    AND    A.SITE_ID      = @c_fix$site_id
                                    --AND    PLANT_ID   = @c_form_inv$plant_id
                                    AND    A.CELL_ITEM_ID      = @c_fix$cell_item_id
  /*AND    A.PRODUCTION_TYPE  =  ( CASE WHEN @c_form_wip$production_type = 'TEST' 
                                                                      THEN @c_form_wip$production_type 
                                                                      ELSE A.PRODUCTION_TYPE 
                                                                 END )                -- TEST 만 구별한다*/
                                    --AND    A.DEMAND_TYPE <> 'FIX'                       -- 확정 PEGGING 된 애들은 대상에서 제외
                                    AND    A.TARGET_TYPE IN ('PACK_RELEASE')            -- PACK_RELEASE 대상임
                                    --AND    TO_FACTORY_ID  = @c_form_inv$factory_id
                                    AND    A.MFG_QTY > ( A.OFFSET_INVENTORY_QTY + A.OFFSET_GI_QTY + A.OFFSET_FIX_QTY )
                                   -- AND    ISNULL(A.ALT_PRIORITY,1) > 1
                                   ) A
                           ) A
                    WHERE  SEQ = 1

                    IF ISNULL(@pegging$fp_demand_id, '*NULL*') = '*NULL*'
                      BREAK;
                    
                    
                    UPDATE TH_BUF_DEMAND_PACK_REQUIRE_FIX
                    SET    QTY         -= @pegging$minus_qty
                    WHERE  INSTANCE_ID  = @c_fix$instance_id
                    AND    COMPANY_ID   = @c_fix$company_id
                    AND    DIVISION_ID  = @c_fix$division_id
                    AND    SITE_ID      = @c_fix$site_id
                    AND    PLANT_ID     = @c_fix$plant_id
                    AND    CELL_ITEM_ID = @c_fix$cell_item_id
                    AND    PACK_REQUIRE_ID = @c_fix$pack_require_id
                    
                    UPDATE TH_BUF_DEMAND_PACK_REQUIRE
                    SET    OFFSET_FIX_QTY += @pegging$minus_qty
                    WHERE  COMPANY_ID   = @c_fix$company_id
                    AND    DIVISION_ID  LIKE SUBSTRING(@c_fix$division_id, 1, 1) +'%'      
                    AND    SITE_ID      = @c_fix$site_id
                    --AND    PLANT_ID   = @c_form_inv$plant_id
                    --AND    CELL_ITEM_ID      = @c_form_wip$item_id
                    AND    FP_DEMAND_ID = @pegging$fp_demand_id
                    AND    INSTANCE_ID  = @v_master_id

                    SET @n_row_count += @@ROWCOUNT

                    SET @pegging$qty -= @pegging$minus_qty
                    
                    
                  END;

            END

        CLOSE C_FIX

        DEALLOCATE C_FIX

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END 
      
      /*
        대기재공 차감
      */
      
      if @v_master_id ='PL_PACK'  and 1=1
      BEGIN
        
          SET @v_table_name = 'dbo.TH_BUF_PACK_REQUIRE_OFFSET_SLOC'
          SET @n_row_count = 0

          DELETE FROM dbo.TH_BUF_PACK_REQUIRE_OFFSET_SLOC
          WHERE MASTER_ID = @v_master_id
          
          INSERT INTO dbo.TH_BUF_PACK_REQUIRE_OFFSET_SLOC
               (
                 MASTER_ID
               , COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , FACTORY_ID
               , STORAGE_ID
               , SEQ
               , ITEM_ID
               , PRODUCTION_TYPE
               , QTY
               , ORG_QTY
           , SLOC_ID
               )
          SELECT    INSTANCE_ID  
                  , COMPANY_ID
                  , DIVISION_ID 
                  , SITE_ID 
                  , PLANT_ID 
                  , FACTORY_ID 
                  , '-' AS STORAGE_ID
                  , SEQ
                  , ITEM_ID
                  , 'MASS' AS PRODUCTION_TYPE
          , QTY
                  , QTY AS ORG_QTY
                  , SLOC_ID
          FROM    FP_INHOUSE_REQUEST_BOH_R
          WHERE   INSTANCE_ID = @v_master_id 
          AND		  PLAN_ID     = @v_plan_id                   
            
          SET @n_row_count = @@ROWCOUNT
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
          SET @v_table_name = 'C_WIP_SLOC'
          SET @n_row_count = 0

          DECLARE
            @c_wip_sloc$company_id        nvarchar(30), 
            @c_wip_sloc$division_id       nvarchar(30), 
            @c_wip_sloc$site_id           nvarchar(30), 
            @c_wip_sloc$plant_id          nvarchar(30), 
            @c_wip_sloc$factory_id        nvarchar(30), 
            @c_wip_sloc$storage_id        nvarchar(30), 
            @c_wip_sloc$seq               numeric(20,10),
            @c_wip_sloc$item_id           nvarchar(150),
            @c_wip_sloc$production_type   nvarchar(30), 
            @c_wip_sloc$qty               numeric(20,10),
            @c_wip_sloc$sloc_id           nvarchar(40)

          DECLARE
            C_WIP_SLOC CURSOR LOCAL FOR
            
              SELECT 
                       COMPANY_ID
                     , DIVISION_ID
                     , SITE_ID
                     , PLANT_ID
                     , FACTORY_ID
                     , STORAGE_ID
                     , SEQ
                     , ITEM_ID
                     , PRODUCTION_TYPE
                     , QTY
                     , SLOC_ID
              FROM   TH_BUF_PACK_REQUIRE_OFFSET_SLOC A
              WHERE  A.MASTER_ID  = @v_master_id
              AND    A.QTY > 0
              ORDER  BY SLOC_ID, ITEM_ID, SEQ

          OPEN C_WIP_SLOC

            WHILE 1 = 1
             
              BEGIN

                FETCH C_WIP_SLOC
                 INTO @c_wip_sloc$company_id,       @c_wip_sloc$division_id,  @c_wip_sloc$site_id, @c_wip_sloc$plant_id,    
                      @c_wip_sloc$factory_id,       @c_wip_sloc$storage_id,   @c_wip_sloc$seq,     @c_wip_sloc$item_id,
                      @c_wip_sloc$production_type,  @c_wip_sloc$qty , @c_wip_sloc$sloc_id


                  IF @@FETCH_STATUS <> 0
                    BREAK

                  SET @offset$qty = @c_wip_sloc$qty

                  WHILE 1 = 1
                    
                    BEGIN


                      IF @offset$qty <= 0.0
                        BREAK

                      SET @offset$scp_target_id = NULL
                        
                      SELECT @offset$scp_target_id  = FP_DEMAND_ID,
                             @offset$minus_qty      = MINUS_QTY,
                             @offset$mfg_qty        = MFG_QTY
                      FROM   (
                              SELECT A.*,
                                     CASE WHEN (MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) > @offset$qty THEN @offset$qty
                                          ELSE (MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY ))
                                     END  AS MINUS_QTY,
                                     ROW_NUMBER() OVER (ORDER     BY DUE_DATE ASC , DUE_FENCE_DATE ASC , MFG_WEEK ASC , FP_DEMAND_ID ASC ) SEQ
                              FROM   (
                    SELECT A.*
                                      FROM   (
                                              SELECT  A.* , 
                                              				CASE WHEN A.MARKET = 'E' THEN B.EXPORT_SLOC_ID ELSE B.DOMESTIC_SLOC_ID END AS SLOC_ID
                                              FROM TH_BUF_DEMAND_PACK_REQUIRE A 
                                					INNER JOIN SCM_LINE_M B
                                			                          ON A.COMPANY_ID = B.COMPANY_ID 
                                			                          AND A.DIVISION_ID = B.DIVISION_ID
                                			                          AND A.SITE_ID = B.SITE_ID
                                			                          AND A.PLANT_ID = B.PLANT_ID
                                			                          AND A.LINE_ID = B.LINE_ID
                                			                          --AND A.OPERATION_ID = B.OPERATION_ID
                                			                          AND B.OPERATION_ID = 'P1000'	--(D20201006~R1006.01)
                                              WHERE A.INSTANCE_ID =  @v_master_id 
                                              ) A
                                      WHERE  A.INSTANCE_ID = @v_master_id
                                      AND    A.COMPANY_ID   = @c_wip_sloc$company_id
                                      AND    A.DIVISION_ID  LIKE SUBSTRING(@c_wip_sloc$division_id, 1, 1) +'%'       --  81, 82 혼용되어서
                                      AND    A.SITE_ID      = @c_wip_sloc$site_id
                                      --AND    PLANT_ID   = @c_form_inv$plant_id
                                      AND    A.CELL_ITEM_ID      = @c_wip_sloc$item_id
                                      /*AND    A.PRODUCTION_TYPE  =  ( CASE WHEN @c_form_wip$production_type = 'TEST' 
                                                                        THEN @c_form_wip$production_type 
                                                                        ELSE A.PRODUCTION_TYPE 
                                                                   END )                -- TEST 만 구별한다*/
                                      --AND    A.DEMAND_TYPE <> 'FIX'                       -- 확정 PEGGING 된 애들은 대상에서 제외
                                      AND    A.TARGET_TYPE IN ('PACK_RELEASE')            -- PACK_RELEASE 대상임
                                      --AND    TO_FACTORY_ID  = @c_form_inv$factory_id
                                      AND    A.MFG_QTY > ( A.OFFSET_INVENTORY_QTY + A.OFFSET_GI_QTY + A.OFFSET_FIX_QTY )
                                      AND    A.SLOC_ID = @c_wip_sloc$sloc_id
                                      AND    ISNULL(A.ALT_PRIORITY,1) = 1
                                      /*AND    A.CELL_ITEM_ID NOT IN (
                                                                      SELECT A.CELL_ITEM_ID
                                                                      FROM (
                                                                              SELECT CELL_ITEM_ID , ISNULL(ALT_PRIORITY , 1) AS ALT_PRIORITY
                                                                              FROM TH_BUF_DEMAND_PACK_REQUIRE
                                                                              GROUP BY CELL_ITEM_ID , ISNULL(ALT_PRIORITY , 1)
                                                                            )A
                                                                      GROUP BY CELL_ITEM_ID
                                                                      HAVING COUNT(A.CELL_ITEM_ID) > 1
                                                                    ) */
                                     ) A
                             ) A
                      WHERE  SEQ = 1

                      IF ISNULL(@offset$scp_target_id, '*NULL*') = '*NULL*'
                        BREAK;
                      
                      
                      UPDATE TH_BUF_PACK_REQUIRE_OFFSET_SLOC
                  SET    QTY         -= @offset$minus_qty
                      WHERE  MASTER_ID    = @v_master_id
                      AND    COMPANY_ID   = @c_wip_sloc$company_id
                      AND    DIVISION_ID  = @c_wip_sloc$division_id
                      AND    SITE_ID      = @c_wip_sloc$site_id
                      AND  PLANT_ID     = @c_wip_sloc$plant_id
                      AND    ITEM_ID      = @c_wip_sloc$item_id
                      AND    SEQ          = @c_wip_sloc$seq
                      AND    SLOC_ID      = @c_wip_sloc$sloc_id
                      
                      UPDATE TH_BUF_DEMAND_PACK_REQUIRE
                      SET    OFFSET_INVENTORY_QTY += @offset$minus_qty
                      WHERE  COMPANY_ID   = @c_wip_sloc$company_id
                      AND    DIVISION_ID  LIKE SUBSTRING(@c_wip_sloc$division_id, 1, 1) +'%'      
                      AND    SITE_ID      = @c_wip_sloc$site_id
                      --AND    PLANT_ID   = @c_form_inv$plant_id
                      --AND    CELL_ITEM_ID      = @c_form_wip$item_id
                      AND    FP_DEMAND_ID = @offset$scp_target_id
                      AND    INSTANCE_ID =  @v_master_id
                      --AND    LINE_ID      = @c_form_wip$line_id

                      SET @n_row_count += @@ROWCOUNT

                      SET @offset$qty -= @offset$minus_qty
                      
                      
                    END;

              END

          CLOSE C_WIP_SLOC

          DEALLOCATE C_WIP_SLOC

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          /*
          BEGIN -- 대치재고도 사용 / 대치 차감된 재고 원 타겟에 INSERT  
          
              UPDATE TH_BUF_DEMAND_PACK_REQUIRE 
              SET OFFSET_INVENTORY_QTY =  A.OFFSET_INVENTORY_QTY  --, 
                 -- work_order_id =  convert(nvarchar,A.OFFSET_INVENTORY_QTY) +'XX'
              FROM (
              					SELECT COMPANY_ID ,DIVISION_ID , SITE_ID , PLANT_ID , INSTANCE_ID , FP_DEMAND_ID  , SUM(OFFSET_INVENTORY_QTY) AS OFFSET_INVENTORY_QTY
        				      	FROM TH_BUF_DEMAND_PACK_REQUIRE
        				      	WHERE 1=1 
        				      	AND ISNULL(ALT_PRIORITY,1) > 1
                        AND INSTANCE_ID =  @v_master_id
        				      	GROUP BY COMPANY_ID ,DIVISION_ID , SITE_ID , PLANT_ID , INSTANCE_ID , FP_DEMAND_ID 
          				)A
          	  WHERE TH_BUF_DEMAND_PACK_REQUIRE.COMPANY_ID = A.COMPANY_ID
          	  AND	   TH_BUF_DEMAND_PACK_REQUIRE.DIVISION_ID = A.DIVISION_ID
          	  AND	   TH_BUF_DEMAND_PACK_REQUIRE.SITE_ID = A.SITE_ID
          	  AND	   TH_BUF_DEMAND_PACK_REQUIRE.PLANT_ID = A.PLANT_ID
          	  AND	   TH_BUF_DEMAND_PACK_REQUIRE.INSTANCE_ID = A.INSTANCE_ID
          	  AND	   TH_BUF_DEMAND_PACK_REQUIRE.FP_DEMAND_ID = A.FP_DEMAND_ID
              AND    TH_BUF_DEMAND_PACK_REQUIRE.INSTANCE_ID =  @v_master_id
              
              --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null */
              
        
      END  
        --pl pack end
      
      IF @v_master_id != 'PL_PACK' 
      BEGIN
        
          SET @v_table_name = 'TH_BUF_PACK_REQUIRE_OFFSET'
          SET @n_row_count = 0

          DELETE FROM TH_BUF_PACK_REQUIRE_OFFSET
          WHERE MASTER_ID = @v_master_id
          
          INSERT INTO TH_BUF_PACK_REQUIRE_OFFSET
               (
                 MASTER_ID
               , COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
              , FACTORY_ID
               , STORAGE_ID
               , SEQ
               , ITEM_ID
               , PRODUCTION_TYPE
               , QTY
               , ORG_QTY
               , LINE_ID
               )
          SELECT   A.MASTER_ID
                 , A.COMPANY_ID
                 , A.DIVISION_ID
  , A.SITE_ID
 , A.PLANT_ID
                 , A.FACTORY_ID
                 , A.STORAGE_ID
                 , ROW_NUMBER() OVER (ORDER BY A.SEQ  , A.QTY DESC) AS SEQ
                 , A.ITEM_ID
                 , A.PRODUCTION_TYPE
                 , A.QTY
                 , A.ORG_QTY
                 , A.LINE_ID
          FROM (
                SELECT @v_master_id   AS MASTER_ID
                     , A.COMPANY_ID
                     , A.DIVISION_ID
                     , A.SITE_ID
                     , A.PLANT_ID
                     , A.FACTORY_ID
                     , A.STORAGE_ID
                     , DENSE_RANK() OVER (ORDER BY A.SEQ
                                                 , A.STOCK_TYPE
                                                 , A.COMPANY_ID
                                                 , A.DIVISION_ID
                                                 , A.SITE_ID
                                                 , A.PLANT_ID
                                                 , A.FACTORY_ID
                                                 , A.STORAGE_ID
                                                 , A.ITEM_ID
                                                 , A.QTY) AS SEQ
                     , A.FP_APPLY_ITEM_ID   AS ITEM_ID
                     , CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                            WHEN A.PRODUCTION_TYPE  = ''   THEN 'MASS'
                            ELSE A.PRODUCTION_TYPE
                       END  PRODUCTION_TYPE
                     , FLOOR(ISNULL(ISNULL(A.MODIFY_FP_APPLY_WIPQTY,A.FP_APPLY_WIPQTY), 0))  AS QTY
                     , FLOOR(ISNULL(ISNULL(A.MODIFY_FP_APPLY_WIPQTY,A.FP_APPLY_WIPQTY), 0))  AS ORG_QTY
                     , LINE_ID
                FROM   SCM_STOCK_H_V A 
                WHERE 1=1  
                --AND    A.CUTOFF_DATE      = @v_plan_date
                AND    A.CUTOFF_DATE      = @v_target_date
                --AND    convert(date,A.AVAILABLE_DATE)  <= @v_cutoff_date      -- 당일 포함 이전까지 누적 데이터 ( PLAN_DATE) 
                AND    A.STOCK_TYPE       = 'WIP'
                AND    A.FP_APPLY_OPERATION_ID = 'P5000' -- 하드코딩 고려
                AND    A.OPERATION_ID = 'P1000'
                AND    A.STOCK_STATUS = 'WAIT'
                --AND    A.WIPHOLD_YN = 'N'
                AND    FLOOR(ISNULL(ISNULL(A.MODIFY_FP_APPLY_WIPQTY,A.FP_APPLY_WIPQTY), 0))  >= 0 
                AND    EXISTS ( SELECT 1
                                FROM   TH_BUF_FORM_INSTANCE_FLOW X
                                WHERE  X.MASTER_ID    = @v_master_id
                                AND    A.COMPANY_ID   = X.COMPANY_ID
                                --AND    A.DIVISION_ID  = X.DIVISION_ID      
                                AND    A.SITE_ID      = X.SITE_ID
                                --AND    A.PLANT_ID = X.PLANT_ID
                                AND    A.FP_APPLY_ITEM_ID = X.ITEM_ID )
                AND   NOT EXISTS  ( 
                                  SELECT 1
              					          FROM (
              		          						SELECT A.*
              		          						FROM   SCM_STOCK_H_V A 
              							            WHERE 1=1  
              							            AND    A.CUTOFF_DATE      = @v_target_date
              							            --AND    convert(date,A.AVAILABLE_DATE)  <= @v_cutoff_date      -- 당일 포함 이전까지 누적 데이터 ( PLAN_DATE) 
              							            AND    A.STOCK_TYPE       = 'WIP'
                                        AND    A.FP_APPLY_OPERATION_ID = 'P5000' -- 하드코딩 고려
                                        AND    A.OPERATION_ID = 'P1000'
                                        AND    A.STOCK_STATUS = 'WAIT'
                                        --AND    A.WIPHOLD_YN = 'N'
                                        AND    A.MODIFY_FP_APPLY_WIPQTY IS NOT NULL
              							            --AND    ISNULL(A.MODIFY_FP_APPLY_WIPQTY,0)  > 0 
    							            AND    EXISTS ( SELECT 1
                							                          FROM   TH_BUF_FORM_INSTANCE_FLOW X
                							                          WHERE  X.MASTER_ID    = @v_master_id
                							                          AND    A.COMPANY_ID   = X.COMPANY_ID
                							                          --AND    A.DIVISION_ID  = X.DIVISION_ID      
                							                          AND    A.SITE_ID      = X.SITE_ID
                							                          --AND    A.PLANT_ID = X.PLANT_ID
                							                          AND    A.FP_APPLY_ITEM_ID      = X.ITEM_ID )
      				                          )X
                					        WHERE   A.COMPANY_ID = X.COMPANY_ID
                					        AND     A.DIVISION_ID = X.DIVISION_ID
                					        AND     A.SITE_ID = X.SITE_ID
                					        AND 		A.PLANT_ID = X.PLANT_ID
                					        AND  	  A.FP_APPLY_ITEM_ID = X.FP_APPLY_ITEM_ID
                				          ) 
                UNION ALL
                SELECT @v_master_id   AS MASTER_ID
                     , A.COMPANY_ID
                     , A.DIVISION_ID
                     , A.SITE_ID
                     , A.PLANT_ID
                     , A.FACTORY_ID
                     , A.STORAGE_ID
                     , DENSE_RANK() OVER (ORDER BY A.SEQ
                                                 , A.STOCK_TYPE
                                                 , A.COMPANY_ID
                                                 , A.DIVISION_ID
                                                 , A.SITE_ID
                                                 , A.PLANT_ID
                                                 , A.FACTORY_ID
                                                 , A.STORAGE_ID
                                                 , A.ITEM_ID
                                                 , A.QTY) AS SEQ
                     , A.FP_APPLY_ITEM_ID AS ITEM_ID
                     , CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                            WHEN A.PRODUCTION_TYPE  = ''   THEN 'MASS'
                            ELSE A.PRODUCTION_TYPE
                       END  PRODUCTION_TYPE
                     , FLOOR(A.MODIFY_FP_APPLY_WIPQTY)  AS QTY
                     , FLOOR(A.MODIFY_FP_APPLY_WIPQTY)  AS ORG_QTY
                     , LINE_ID
                FROM   SCM_STOCK_H_V A 
                WHERE 1=1  
                --AND    A.CUTOFF_DATE      = @v_plan_date
                AND    A.CUTOFF_DATE      = @v_target_date
                --AND    convert(date,A.AVAILABLE_DATE)  <= @v_cutoff_date      -- 당일 포함 이전까지 누적 데이터 ( PLAN_DATE) 
                AND    A.FP_APPLY_OPERATION_ID = 'P5000'
                AND    A.STOCK_TYPE       = 'WIP'
                AND    A.OPERATION_ID = 'P1000'
                AND    A.STOCK_STATUS = 'WAIT'
                --AND    A.WIPHOLD_YN = 'N'
                AND    A.MODIFY_FP_APPLY_WIPQTY IS NOT NULL
               -- AND    ISNULL(A.MODIFY_FP_APPLY_WIPQTY,-999)  >= 0 
                AND    EXISTS ( 
                              SELECT 1
                              FROM   TH_BUF_FORM_INSTANCE_FLOW X
                              WHERE  X.MASTER_ID    = @v_master_id
                              AND    A.COMPANY_ID   = X.COMPANY_ID
                              --AND    A.DIVISION_ID  = X.DIVISION_ID      
                              AND    A.SITE_ID      = X.SITE_ID
                              --AND    A.PLANT_ID = X.PLANT_ID
                              AND    A.FP_APPLY_ITEM_ID      = X.ITEM_ID 
                              ) 
                /*UNION ALL
                SELECT @v_master_id   AS MASTER_ID
      			               , A.COMPANY_ID
      			               , A.DIVISION_ID
      			               , A.SITE_ID
      			               , A.PLANT_ID
      			     , A.FACTORY_ID
      			               , A.STORAGE_ID
      			               , DENSE_RANK() OVER (ORDER BY A.SEQ
      			                                           , A.STOCK_TYPE
      			                                           , A.COMPANY_ID
      			                                           , A.DIVISION_ID
      			                                           , A.SITE_ID
      			                                           , A.PLANT_ID
      			                                           , A.FACTORY_ID
      			                                           , A.STORAGE_ID
      			                                           , A.ITEM_ID
      			                                           , A.QTY) AS SEQ
      			               , A.FP_APPLY_ITEM_ID   AS ITEM_ID
      			               , CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
      			                      WHEN A.PRODUCTION_TYPE  = ''   THEN 'MASS'
      			                      ELSE A.PRODUCTION_TYPE
      			                 END  PRODUCTION_TYPE
      			               , ISNULL((A.PACK_MOVE_QTY),0) AS QTY 
      			               , ISNULL((A.PACK_MOVE_QTY),0) AS ORG_QTY
      			               , LINE_ID
                FROM   SCM_STOCK_H_V A 
                WHERE 1=1  
                AND    A.CUTOFF_DATE      = @v_target_date
                --AND    convert(date,A.AVAILABLE_DATE)  <= @v_cutoff_date      -- 당일 포함 이전까지 누적 데이터 ( PLAN_DATE) 
                --AND    A.STOCK_TYPE       = 'DW'
                --AND    A.FP_APPLY_OPERATION_ID = 'P5000' -- 하드코딩 고려
                --AND    A.OPERATION_ID = 'P1000'
                --AND    A.STOCK_STATUS = 'WAIT'              
                AND	   ISNULL((A.PACK_MOVE_QTY),0)  > 0 
                AND    EXISTS ( 
                              SELECT 1
                              FROM   TH_BUF_FORM_INSTANCE_FLOW X
                              WHERE  X.MASTER_ID    = @v_master_id
                              AND    A.COMPANY_ID   = X.COMPANY_ID
                              --AND    A.DIVISION_ID  = X.DIVISION_ID      
                              AND    A.SITE_ID      = X.SITE_ID
                              --AND    A.PLANT_ID = X.PLANT_ID
                              AND    A.FP_APPLY_ITEM_ID      = X.ITEM_ID 
                              ) */            
                 )A
          
          SET @n_row_count = @@ROWCOUNT
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
          SET @v_table_name = 'C_FORM_WIP'
          SET @n_row_count = 0

          DECLARE
            @c_form_wip$company_id        nvarchar(30), 
            @c_form_wip$division_id       nvarchar(30), 
            @c_form_wip$site_id           nvarchar(30), 
            @c_form_wip$plant_id          nvarchar(30), 
            @c_form_wip$factory_id        nvarchar(30), 
            @c_form_wip$storage_id        nvarchar(30), 
            @c_form_wip$seq               numeric(20,10),
            @c_form_wip$item_id           nvarchar(150),
            @c_form_wip$production_type   nvarchar(30), 
            @c_form_wip$qty               numeric(20,10),
            @c_form_wip$line_id           nvarchar(40)

          DECLARE
            C_FORM_DW CURSOR LOCAL FOR
              SELECT 
                       COMPANY_ID
                     , DIVISION_ID
                     , SITE_ID
 , PLANT_ID
                     , FACTORY_ID
                     , STORAGE_ID
                     , SEQ
                     , ITEM_ID
                     , PRODUCTION_TYPE
                     , QTY
                     , LINE_ID
              FROM   TH_BUF_PACK_REQUIRE_OFFSET A
              WHERE  A.MASTER_ID  = @v_master_id
              AND    A.QTY > 0
              ORDER  BY STORAGE_ID, ITEM_ID, SEQ

          OPEN C_FORM_DW

            WHILE 1 = 1
             
              BEGIN

                FETCH C_FORM_DW
                 INTO @c_form_wip$company_id,       @c_form_wip$division_id,  @c_form_wip$site_id, @c_form_wip$plant_id,    
                      @c_form_wip$factory_id,       @c_form_wip$storage_id,   @c_form_wip$seq,     @c_form_wip$item_id,
                      @c_form_wip$production_type,  @c_form_wip$qty , @c_form_wip$line_id


                  IF @@FETCH_STATUS <> 0
                    BREAK

                  SET @offset$qty = @c_form_wip$qty

                  WHILE 1 = 1
                    
                    BEGIN


                      IF @offset$qty <= 0.0
                        BREAK

                      SET @offset$scp_target_id = NULL
                        
                      SELECT @offset$scp_target_id  = FP_DEMAND_ID,
                             @offset$minus_qty      = MINUS_QTY,
                             @offset$mfg_qty        = MFG_QTY
                      FROM   (
                              SELECT A.*,
                                     CASE WHEN (MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) > @offset$qty THEN @offset$qty
                                          ELSE (MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY ))
                                     END  AS MINUS_QTY,
                                     ROW_NUMBER() OVER (ORDER     BY DUE_DATE ASC , DUE_FENCE_DATE ASC , MFG_WEEK ASC ) SEQ
                              FROM   (
                                      SELECT A.*
                                      FROM   TH_BUF_DEMAND_PACK_REQUIRE A
                                      WHERE  A.INSTANCE_ID = @v_master_id
                                      AND    A.COMPANY_ID   = @c_form_wip$company_id
                                      AND    A.DIVISION_ID  LIKE SUBSTRING(@c_form_wip$division_id, 1, 1) +'%'       --  81, 82 혼용되어서
                                      AND    A.SITE_ID      = @c_form_wip$site_id
                                      --AND    PLANT_ID   = @c_form_inv$plant_id
                                      AND    A.CELL_ITEM_ID      = @c_form_wip$item_id
                                      /*AND    A.PRODUCTION_TYPE  =  ( CASE WHEN @c_form_wip$production_type = 'TEST' 
                                                                        THEN @c_form_wip$production_type 
                                                                        ELSE A.PRODUCTION_TYPE 
                                                                   END )                -- TEST 만 구별한다*/
                                      --AND    A.DEMAND_TYPE <> 'FIX'                       -- 확정 PEGGING 된 애들은 대상에서 제외
                                      AND    A.TARGET_TYPE IN ('PACK_RELEASE')            -- PACK_RELEASE 대상임
                                      --AND    TO_FACTORY_ID  = @c_form_inv$factory_id
                                      AND    A.MFG_QTY > ( A.OFFSET_INVENTORY_QTY + A.OFFSET_GI_QTY + A.OFFSET_FIX_QTY )
                                      AND    A.LINE_ID = @c_form_wip$line_id
                                      AND    ISNULL(A.ALT_PRIORITY,1) > 1
                                      AND    A.CELL_ITEM_ID NOT IN (
                                                                      SELECT A.CELL_ITEM_ID
                                                                      FROM (
                                            SELECT CELL_ITEM_ID , ALT_PRIORITY
                                                                              FROM TH_BUF_DEMAND_PACK_REQUIRE
                                                                              GROUP BY CELL_ITEM_ID , ALT_PRIORITY
       
                                                                   )A
                                                                      GROUP BY CELL_ITEM_ID
                                                                      HAVING COUNT(A.CELL_ITEM_ID) > 1
                                                                    )
                                     ) A
                             ) A
                      WHERE  SEQ = 1

                      IF ISNULL(@offset$scp_target_id, '*NULL*') = '*NULL*'
                        BREAK;
                      
                      
                      UPDATE TH_BUF_PACK_REQUIRE_OFFSET
                      SET    QTY         -= @offset$minus_qty
                      WHERE  MASTER_ID    = @v_master_id
                      AND    COMPANY_ID   = @c_form_wip$company_id
                      AND    DIVISION_ID  = @c_form_wip$division_id
                      AND    SITE_ID      = @c_form_wip$site_id
                      AND    PLANT_ID     = @c_form_wip$plant_id
                      AND    ITEM_ID      = @c_form_wip$item_id
                      AND    SEQ          = @c_form_wip$seq
                      AND    LINE_ID      = @c_form_wip$line_id
                      
                      UPDATE TH_BUF_DEMAND_PACK_REQUIRE
                      SET    OFFSET_INVENTORY_QTY += @offset$minus_qty
                      WHERE  COMPANY_ID   = @c_form_wip$company_id
                      AND    DIVISION_ID  LIKE SUBSTRING(@c_form_wip$division_id, 1, 1) +'%'      
                      AND    SITE_ID      = @c_form_wip$site_id
                      --AND    PLANT_ID   = @c_form_inv$plant_id
                      --AND    CELL_ITEM_ID      = @c_form_wip$item_id
                      AND    FP_DEMAND_ID = @offset$scp_target_id
                      AND    INSTANCE_ID =  @v_master_id
                      AND    LINE_ID      = @c_form_wip$line_id

                      SET @n_row_count += @@ROWCOUNT

                      SET @offset$qty -= @offset$minus_qty
                      
                      
                    END;

              END

          CLOSE C_FORM_DW

          DEALLOCATE C_FORM_DW

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
          BEGIN -- 대치재고도 사용 / 대치 차감된 재고 원 타겟에 INSERT  
          
              UPDATE TH_BUF_DEMAND_PACK_REQUIRE 
              SET OFFSET_INVENTORY_QTY =  A.OFFSET_INVENTORY_QTY  --, 
                 -- work_order_id =  convert(nvarchar,A.OFFSET_INVENTORY_QTY) +'XX'
              FROM (
              					SELECT COMPANY_ID ,DIVISION_ID , SITE_ID , PLANT_ID , INSTANCE_ID , FP_DEMAND_ID  , SUM(OFFSET_INVENTORY_QTY) AS OFFSET_INVENTORY_QTY
        				      	FROM TH_BUF_DEMAND_PACK_REQUIRE
        				      	WHERE 1=1 
        				      	AND ISNULL(ALT_PRIORITY,1) > 1
                        AND INSTANCE_ID =  @v_master_id
        				      	GROUP BY COMPANY_ID ,DIVISION_ID , SITE_ID , PLANT_ID , INSTANCE_ID , FP_DEMAND_ID 
          				)A
          	  WHERE TH_BUF_DEMAND_PACK_REQUIRE.COMPANY_ID = A.COMPANY_ID
          	  AND	   TH_BUF_DEMAND_PACK_REQUIRE.DIVISION_ID = A.DIVISION_ID
          	  AND	   TH_BUF_DEMAND_PACK_REQUIRE.SITE_ID = A.SITE_ID
          	  AND	   TH_BUF_DEMAND_PACK_REQUIRE.PLANT_ID = A.PLANT_ID
          	  AND	   TH_BUF_DEMAND_PACK_REQUIRE.INSTANCE_ID = A.INSTANCE_ID
          	  AND	   TH_BUF_DEMAND_PACK_REQUIRE.FP_DEMAND_ID = A.FP_DEMAND_ID
              AND    TH_BUF_DEMAND_PACK_REQUIRE.INSTANCE_ID =  @v_master_id
              
              --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
              
              /*
                DELETE
              */
              --DELETE TH_BUF_DEMAND_PACK_REQUIRE
              --WHERE  ISNULL(ALT_PRIORITY,1) > 1
              
              /*
                OFFSET 한번더 대치떄문임
              */
              
              DECLARE
              C_FORM_DW CURSOR LOCAL FOR
                SELECT 
                         COMPANY_ID
                       , DIVISION_ID
                       , SITE_ID
                       , PLANT_ID
                       , FACTORY_ID
                       , STORAGE_ID
                       , SEQ
                       , ITEM_ID
                       , PRODUCTION_TYPE
                       , QTY
                       , LINE_ID
                FROM   TH_BUF_PACK_REQUIRE_OFFSET A
                WHERE  A.MASTER_ID  = @v_master_id
                AND    A.QTY > 0
                ORDER  BY STORAGE_ID, ITEM_ID, SEQ

              OPEN C_FORM_DW

                WHILE 1 = 1
                 
                  BEGIN

                    FETCH C_FORM_DW
                     INTO @c_form_wip$company_id,       @c_form_wip$division_id,  @c_form_wip$site_id, @c_form_wip$plant_id,    
                          @c_form_wip$factory_id,       @c_form_wip$storage_id,   @c_form_wip$seq,     @c_form_wip$item_id,
                          @c_form_wip$production_type,  @c_form_wip$qty , @c_form_wip$line_id


                      IF @@FETCH_STATUS <> 0
                        BREAK

                      SET @offset$qty = @c_form_wip$qty

                      WHILE 1 = 1
                        
                        BEGIN


                          IF @offset$qty <= 0.0
                            BREAK

                          SET @offset$scp_target_id = NULL
                            
                          SELECT @offset$scp_target_id  = FP_DEMAND_ID,
                                 @offset$minus_qty      = MINUS_QTY,
                                 @offset$mfg_qty        = MFG_QTY
                          FROM   (
                                  SELECT A.*,
                                         CASE WHEN (MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) > @offset$qty THEN @offset$qty
                                              ELSE (MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY ))
                                         END  AS MINUS_QTY,
                                         ROW_NUMBER() OVER (ORDER     BY DUE_DATE ASC , DUE_FENCE_DATE ASC , MFG_WEEK ASC ) SEQ
                                  FROM   (
                                          SELECT A.*
                                          FROM   TH_BUF_DEMAND_PACK_REQUIRE A
                                          WHERE  A.INSTANCE_ID = @v_master_id
                                          AND    A.COMPANY_ID   = @c_form_wip$company_id
                                          AND    A.DIVISION_ID  LIKE SUBSTRING(@c_form_wip$division_id, 1, 1) +'%'       --  81, 82 혼용되어서
                                          AND    A.SITE_ID      = @c_form_wip$site_id
                                          --AND    PLANT_ID   = @c_form_inv$plant_id
                                          AND    A.CELL_ITEM_ID      = @c_form_wip$item_id
                                          /*AND    A.PRODUCTION_TYPE  =  ( CASE WHEN @c_form_wip$production_type = 'TEST' 
            THEN @c_form_wip$production_type 
                                                                            ELSE A.PRODUCTION_TYPE 
                                                                       END )                -- TEST 만 구별한다*/
               --AND    A.DEMAND_TYPE <> 'FIX'            -- 확정 PEGGING 된 애들은 대상에서 제외
                                          AND    A.TARGET_TYPE IN ('PACK_RELEASE')            -- PACK_RELEASE 대상임
                                          --AND    TO_FACTORY_ID  = @c_form_inv$factory_id
                                          AND    A.MFG_QTY > ( A.OFFSET_INVENTORY_QTY + A.OFFSET_GI_QTY + A.OFFSET_FIX_QTY )
                                          AND    A.LINE_ID = @c_form_wip$line_id
                                          --AND    ISNULL(A.ALT_PRIORITY,1) > 1
                                         ) A
                                 ) A
                          WHERE  SEQ = 1

                          IF ISNULL(@offset$scp_target_id, '*NULL*') = '*NULL*'
                            BREAK;
                          
                          UPDATE TH_BUF_PACK_REQUIRE_OFFSET
                          SET    QTY         -= @offset$minus_qty
                          WHERE  MASTER_ID    = @v_master_id
                          AND    COMPANY_ID   = @c_form_wip$company_id
                          AND    DIVISION_ID  = @c_form_wip$division_id
                          AND    SITE_ID      = @c_form_wip$site_id
                          AND    PLANT_ID     = @c_form_wip$plant_id
                          AND    ITEM_ID      = @c_form_wip$item_id
                          AND    SEQ          = @c_form_wip$seq
                          AND    LINE_ID      = @c_form_wip$line_id
                          
                          UPDATE TH_BUF_DEMAND_PACK_REQUIRE
                          SET    OFFSET_INVENTORY_QTY += @offset$minus_qty --, 
                                -- WORK_ORDER_ID = ISNULL(WORK_ORDER_ID , 'A') + CONVERT(NVARCHAR,@c_form_wip$seq) + '#' + CONVERT(NVARCHAR,@offset$minus_qty) + '#'
                          WHERE  COMPANY_ID   = @c_form_wip$company_id
                          AND    DIVISION_ID  LIKE SUBSTRING(@c_form_wip$division_id, 1, 1) +'%'      
                          AND    SITE_ID      = @c_form_wip$site_id
                          --AND    PLANT_ID   = @c_form_inv$plant_id
                          AND    CELL_ITEM_ID      = @c_form_wip$item_id
                          AND    FP_DEMAND_ID = @offset$scp_target_id
                          AND    INSTANCE_ID    = @v_master_id
                          AND    LINE_ID      = @c_form_wip$line_id
                      
                      /*
                      if     @c_form_wip$item_id = 'ACEN1060I-A1'
                      begin

                      SELECT  @v_master_id ,  @c_form_wip$item_id ,  @offset$scp_target_id ,  @offset$minus_qty ,  @c_form_wip$seq     

                      end*/
                        

                          SET @n_row_count += @@ROWCOUNT

                          SET @offset$qty -= @offset$minus_qty
                                           
                                              
                        END;

                  END

              CLOSE C_FORM_DW

              DEALLOCATE C_FORM_DW

              SET @sysdate = GETDATE()
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
          END
          
        END  
        
            /*
              선행하여 인계요청 막음  
              --LOG 생성
              SET @v_message = @n_row_count
              SET @n_log_count = @n_log_count + 1
              처음개발 - capa 의 50% 선행
              두번쨰 변경 d+1일의 수량의 절반을 선행
              세번쨰 오창 선행반영 하지않음. - 황현규선임임 선행수량 보정한다고함.
              네번쨰 D+1 일의 50% 선행 후  일요일은 요청계획 제외 일요일수량 -> 토요일반영
            */
        
        BEGIN
        
          SET @v_table_name = 'TH_BUF_DEMAND_PACK_REQUIRE'
          
          UPDATE TH_BUF_DEMAND_PACK_REQUIRE
          SET MFG_QTY = MFG_QTY - OFFSET_INVENTORY_QTY
       WHERE INSTANCE_ID = @v_master_id
          
  --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
          UPDATE TH_BUF_DEMAND_PACK_REQUIRE
          SET TH_BUF_DEMAND_PACK_REQUIRE.C_SEQ = A.SEQ
          FROM (
                SELECT  A.INSTANCE_ID,
                        A.CELL_ITEM_ID , 
                        A.DUE_DATE , 
                        MFG_QTY ,  
                        SAFETY_CAPA ,
                        LINE_ID , 
              				  --LEAD(MFG_QTY) OVER (PARTITION BY A.CELL_ITEM_ID  ORDER BY A.DUE_DATE)  AS LEAD_QTY , 
              				  --LAG(MFG_QTY) OVER (PARTITION BY A.CELL_ITEM_ID  ORDER BY A.DUE_DATE)  AS LAG_QTY ,
              				  ROW_NUMBER()  OVER(PARTITION BY A.CELL_ITEM_ID ORDER BY LINE_ID , DUE_DATE  ) AS SEQ  
            FROM TH_BUF_DEMAND_PACK_REQUIRE A 
                WHERE A.INSTANCE_ID = @v_master_id
                --AND   A.MFG_QTY > 0 
                AND   CHARINDEX(A.FP_DEMAND_ID , 'DUMMY')  = 0
                )A
          WHERE TH_BUF_DEMAND_PACK_REQUIRE.CELL_ITEM_ID = A.CELL_ITEM_ID
          AND   TH_BUF_DEMAND_PACK_REQUIRE.DUE_DATE = A.DUE_DATE
          AND   TH_BUF_DEMAND_PACK_REQUIRE.INSTANCE_ID = @v_master_id
          AND   TH_BUF_DEMAND_PACK_REQUIRE.INSTANCE_ID= A.INSTANCE_ID
          AND  TH_BUF_DEMAND_PACK_REQUIRE.LINE_ID= A.LINE_ID
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
        END
        
         
          

        -- (D20201020~R1022.01)
        --IF CHARINDEX(@v_master_id , 'KR_PACK') > 0 or CHARINDEX(@v_master_id , 'PL_PACK') > 0
		IF 	@v_master_id IN (		SELECT	DISTINCT SEGMENT1 AS INSTANCE_ID
										FROM		SCM_SYS_LOOKUP_VALUE C
										WHERE	1=1
										AND		ACTIVE_FLAG = 'Y'
										AND		LOOKUP_TYPE_CODE = 'IN_HOUSE_PLAN_PRECEDING_RATIO'
									)
        BEGIN
          	
	      DECLARE @n_ratio numeric(5,2)	-- (D20201020~R1022.01)
	      
	     			
			SELECT	@n_ratio = ( CASE WHEN CONVERT(NUMERIC(5,2),SEGMENT5) > 1 THEN 1 ELSE CONVERT(NUMERIC(5,2),SEGMENT5) END )
			FROM		SCM_SYS_LOOKUP_VALUE C
			WHERE	1=1
			AND		ACTIVE_FLAG = 'Y'
			AND		LOOKUP_TYPE_CODE = 'IN_HOUSE_PLAN_PRECEDING_RATIO'
			AND		SEGMENT1 = @v_master_id
			
		 
          /*
          기존 CAPA 의 0.5일 선행에서 변경함.
          */
          UPDATE TH_BUF_DEMAND_PACK_REQUIRE
          SET TH_BUF_DEMAND_PACK_REQUIRE.SAFETY_CAPA = A.MODIFY_QTY
          FROM  (
        					SELECT A.*  , 
        								--CEILING(ISNULL(LEAD(MFG_QTY) OVER (PARTITION BY CELL_ITEM_ID  , LINE_ID ORDER BY DUE_DATE ),0) / 2.0)  AS MODIFY_QTY
        								CEILING(ISNULL(LEAD(MFG_QTY) OVER (PARTITION BY CELL_ITEM_ID  , LINE_ID ORDER BY DUE_DATE ),0) * @n_ratio )  AS MODIFY_QTY	-- (D20201020~R1022.01)
        				  FROM TH_BUF_DEMAND_PACK_REQUIRE a 
                  WHERE INSTANCE_ID = @v_master_id
                  AND(A.ALT_PRIORITY = 1 OR A.ALT_PRIORITY IS NULL )
        				)A
          WHERE 	TH_BUF_DEMAND_PACK_REQUIRE.INSTANCE_ID = @v_master_id
          AND     TH_BUF_DEMAND_PACK_REQUIRE.INSTANCE_ID= A.INSTANCE_ID
          AND     TH_BUF_DEMAND_PACK_REQUIRE.COMPANY_ID = A.COMPANY_ID
          AND 		TH_BUF_DEMAND_PACK_REQUIRE.DIVISION_ID = A.DIVISION_ID
          AND 		TH_BUF_DEMAND_PACK_REQUIRE.SITE_ID = A.SITE_ID
          AND		  TH_BUF_DEMAND_PACK_REQUIRE.PLANT_ID = A.PLANT_ID
          AND		  TH_BUF_DEMAND_PACK_REQUIRE.INSTANCE_ID = A.INSTANCE_ID
          AND		  TH_BUF_DEMAND_PACK_REQUIRE.FP_DEMAND_ID = A.FP_DEMAND_ID
          AND		  TH_BUF_DEMAND_PACK_REQUIRE.CELL_ITEM_ID = A.CELL_ITEM_ID
          AND		  TH_BUF_DEMAND_PACK_REQUIRE.DUE_DATE = A.DUE_DATE
          AND     TH_BUF_DEMAND_PACK_REQUIRE.LINE_ID = A.LINE_ID
          
          --LOG 생성
          SET @v_message = 'SAFETY CAPA UPDATE : '  + convert(nvarchar,@n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
          DECLARE
    @c_pack_precede$cell_item_id      nvarchar(50), 
            @c_pack_precede$due_date          date, 
            @c_pack_precede$mfg_qty           numeric(20,10), 
            @c_pack_precede$safety_capa       numeric(20,10), 
            @c_pack_precede$seq               integer, 
        @c_pack_precede$max_seq           integer
            
  
        DECLARE 
            @c_check                          nvarchar(2)

          DECLARE
          
            C_PACK_RRECEDE CURSOR LOCAL FOR
            
              SELECT  A.CELL_ITEM_ID , 
                      A.DUE_DATE , 
                      MFG_QTY  ,  
                      SAFETY_CAPA ,
                      A.C_SEQ , 
                      MAX(A.C_SEQ) OVER (PARTITION BY A.CELL_ITEM_ID) AS MAX_SEQ
          		FROM (
                    SELECT  A.CELL_ITEM_ID , 
                            A.DUE_DATE , 
                            MFG_QTY ,  
                            SAFETY_CAPA ,
                  				  --LEAD(MFG_QTY) OVER (PARTITION BY A.CELL_ITEM_ID  ORDER BY A.DUE_DATE)  AS LEAD_QTY , 
                  				  --LAG(MFG_QTY) OVER (PARTITION BY A.CELL_ITEM_ID  ORDER BY A.DUE_DATE)  AS LAG_QTY ,
                            A.C_SEQ
                  				  --RANK() OVER(PARTITION BY A.CELL_ITEM_ID ORDER BY DUE_DATE) AS SEQ  
                    FROM TH_BUF_DEMAND_PACK_REQUIRE A 
                    WHERE A.INSTANCE_ID = @v_master_id 
                    AND   (A.ALT_PRIORITY = 1 OR A.ALT_PRIORITY IS NULL )     
                    )A
              ORDER BY A.CELL_ITEM_ID , A.C_SEQ

          OPEN C_PACK_RRECEDE

            WHILE 1 = 1
             
              BEGIN

                FETCH C_PACK_RRECEDE
                 INTO   @c_pack_precede$cell_item_id      , 
                        @c_pack_precede$due_date          , 
                        @c_pack_precede$mfg_qty           , 
                        @c_pack_precede$safety_capa       , 
                        @c_pack_precede$seq               , 
                        @c_pack_precede$max_seq           


                  IF @@FETCH_STATUS <> 0
                    BREAK
                    

                  BEGIN
                    
                    SELECT  @c_check = 'P' , --CASE WHEN A.MFG_QTY >= A.SAFETY_CAPA  THEN 'P' ELSE 'F' END ,
                            @c_pack_precede$safety_capa = case when MFG_QTY < @c_pack_precede$safety_capa THEN MFG_QTY ELSE @c_pack_precede$safety_capa END
                        		FROM (
                                  SELECT  A.CELL_ITEM_ID , 
                                          A.DUE_DATE , 
                                          A.MFG_QTY ,  
                                          A.SAFETY_CAPA ,
                                				  A.C_SEQ
                                  FROM TH_BUF_DEMAND_PACK_REQUIRE A 
                                  WHERE (A.ALT_PRIORITY = 1 OR A.ALT_PRIORITY IS NULL )   
                                  AND   A.INSTANCE_ID = @v_master_id
                                  )A
                    WHERE A.CELL_ITEM_ID =   @c_pack_precede$cell_item_id
                    AND   A.C_SEQ = @c_pack_precede$seq + 1
                    
                    
                    IF @c_check = 'P'
                    BEGIN
                    
                      UPDATE TH_BUF_DEMAND_PACK_REQUIRE
                      SET MFG_QTY = MFG_QTY + @c_pack_precede$safety_capa ,
                          DEMAND_TYPE = DEMAND_TYPE +'#' + '+P'
                      WHERE CELL_ITEM_ID = @c_pack_precede$cell_item_id
                      AND   DUE_DATE = @c_pack_precede$due_date
                      AND   C_SEQ = @c_pack_precede$seq
                      AND   (ALT_PRIORITY = 1 OR ALT_PRIORITY IS NULL )
                      AND   INSTANCE_ID = @v_master_id
                      
                      UPDATE TH_BUF_DEMAND_PACK_REQUIRE
         SET MFG_QTY = MFG_QTY - @c_pack_precede$safety_capa , 
                          DEMAND_TYPE = DEMAND_TYPE +'#' + '-P'
                      WHERE CELL_ITEM_ID = @c_pack_precede$cell_item_id
                      --AND  DUE_DATE = @c_pack_precede$due_date
                      AND   C_SEQ = @c_pack_precede$seq + 1
                      AND  (ALT_PRIORITY = 1 OR ALT_PRIORITY IS NULL )  
                      AND   INSTANCE_ID = @v_master_id
                      
                      SET @c_pack_precede$seq = @c_pack_precede$seq + 1
                      
                      --SELECT @c_pack_precede$cell_item_id ,  @c_pack_precede$due_date  , @c_pack_precede$seq
                      
                      
                    END
                    
                  
                  END
            
              END

          CLOSE C_PACK_RRECEDE
          DEALLOCATE C_PACK_RRECEDE
        
        END
        
        --LOG 생성
        SET @v_message = 'PRECEDE : '  + convert(nvarchar,@n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
        
        UPDATE TH_BUF_DEMAND_PACK_REQUIRE
        SET ORG_MFG_QTY = MFG_QTY 
        WHERE INSTANCE_ID = @v_master_id
        
        /*
          일요일 수량 -> 토요일
        */
        IF  CHARINDEX(@v_master_id , 'KR_PACK') > 0 --AND 1=2  
        BEGIN
        
          SET @v_table_name = 'TH_BUF_DEMAND_PACK_REQUIRE'
          
          UPDATE TH_BUF_DEMAND_PACK_REQUIRE
          SET TH_BUF_DEMAND_PACK_REQUIRE.MFG_QTY = TH_BUF_DEMAND_PACK_REQUIRE.MFG_QTY + A.MFG_QTY
          FROM (
          			SELECT  B.DAY , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.INSTANCE_ID , A.CELL_ITEM_ID , 
          							A.MFG_QTY , A.DUE_DATE  , A.LINE_ID , A.OPERATION_ID  , DATEADD(DAY , -1 , A.DUE_DATE ) AS SAT_DAY
	              FROM  TH_BUF_DEMAND_PACK_REQUIRE A , 
	              			SCM_SYS_CALENDAR_M B
	              WHERE  A.INSTANCE_ID  = @v_master_id
	              AND 	 A.DUE_dATE = B.DATE_ID
	              AND	   A.MFG_QTY > 0 
	              AND	   B.DAY = 'SUN'
                AND    (A.ALT_PRIORITY = 1 OR A.ALT_PRIORITY IS NULL )
          		  )A
          WHERE  	TH_BUF_DEMAND_PACK_REQUIRE.INSTANCE_ID = @v_master_id
          AND		TH_BUF_DEMAND_PACK_REQUIRE.INSTANCE_ID = A.INSTANCE_ID
          AND		TH_BUF_DEMAND_PACK_REQUIRE.COMPANY_ID = A.COMPANY_ID
          AND		TH_BUF_DEMAND_PACK_REQUIRE.DIVISION_ID = A.DIVISION_ID
          AND		TH_BUF_DEMAND_PACK_REQUIRE.SITE_ID = A.SITE_ID
          AND		TH_BUF_DEMAND_PACK_REQUIRE.PLANT_ID = A.PLANT_ID
          AND		TH_BUF_DEMAND_PACK_REQUIRE.LINE_ID = A.LINE_ID
          AND		TH_BUF_DEMAND_PACK_REQUIRE.OPERATION_ID = A.OPERATION_ID
          AND		TH_BUF_DEMAND_PACK_REQUIRE.DUE_DATE = A.SAT_DAY
          AND   TH_BUF_DEMAND_PACK_REQUIRE.CELL_ITEM_ID= A.CELL_ITEM_ID
          
          --LOG 생성
          SET @v_message = 'SUN TO SAT'  + convert(nvarchar,@n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
          UPDATE TH_BUF_DEMAND_PACK_REQUIRE
          SET    TH_BUF_DEMAND_PACK_REQUIRE.MFG_QTY = 0
          FROM   SCM_SYS_CALENDAR_M A
          WHERE  TH_BUF_DEMAND_PACK_REQUIRE.INSTANCE_ID = @v_master_id 
          AND    TH_BUF_DEMAND_PACK_REQUIRE.DUE_DATE = A.DATE_ID
          AND	   A.DAY = 'SUN'
          
          --LOG 생성
          SET @v_message = 'SUN TO SAT'  + convert(nvarchar,@n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
              
              
        
        END
        
        /*
          20181016 MOQ Qty 적용.
        */
        if 1=1
        BEGIN
   
          DECLARE
            @c_pack_moq$cell_item_id      nvarchar(50), 
            @c_pack_moq$line_id           nvarchar(50), 
            @c_pack_moq$moq_size          integer ,
            @c_pack_moq$seq               integer, 
            @c_pack_moq$max_seq           integer 
            
          DECLARE
            @c_pack_moq$diff              integer,
            @c_pack_moq$modify_qty        integer,
            @c_pack_moq$diff_mfg_qty      integer = 0
            
          DECLARE
          
            C_MOQ CURSOR LOCAL FOR
            
              SELECT CELL_ITEM_ID  ,LINE_ID ,  MAX(MOQ) AS MOQ , MIN(C_SEQ) AS MIN_SEQ , MAX(C_SEQ) AS MAX_SEQ
						  FROM (
									  SELECT DBO.FN_GET_BOX_TOTL_CELL_QTY(DIVISION_ID,'',CELL_ITEM_ID,'') AS MOQ  , A.*
									  FROM TH_BUF_DEMAND_PACK_REQUIRE A
									  WHERE INSTANCE_ID = @v_master_id
									  AND   MFG_QTY > 0 
						  )A
						  WHERE A.MOQ IS NOT  NULL
						  GROUP BY CELL_ITEM_ID  , LINE_ID
						  ORDER BY CELL_ITEM_ID  , LINE_ID

          OPEN C_MOQ  

            WHILE 1 = 1
             
              BEGIN

                FETCH C_MOQ
                 INTO   @c_pack_moq$cell_item_id      , 
                        @c_pack_moq$line_id , 
                        @c_pack_moq$moq_size    ,
                        @c_pack_moq$seq         , 
                        @c_pack_moq$max_seq       

                  IF @@FETCH_STATUS <> 0
                    BREAK
                  
                  WHILE 1=1
                    BEGIN  
                    
                      SELECT   @c_pack_moq$modify_qty = CEILING(A.MFG_QTY / A.MOQ) * MOQ  , 
                               @c_pack_moq$diff = (CEILING(A.MFG_QTY / A.MOQ) * MOQ - MFG_QTY  ) + @c_pack_moq$diff_mfg_qty
  									  FROM (
        									  SELECT DBO.FN_GET_BOX_TOTL_CELL_QTY(DIVISION_ID,'',CELL_ITEM_ID,'')  AS MOQ  , A.*
        									  FROM  TH_BUF_DEMAND_PACK_REQUIRE A
        									  WHERE INSTANCE_ID = @v_master_id 
                            AND   CELL_ITEM_ID = @c_pack_moq$cell_item_id
                            AND   LINE_ID = @c_pack_moq$line_id
                            AND   C_SEQ =  @c_pack_moq$seq
  									        )A  
                      
                      UPDATE TH_BUF_DEMAND_PACK_REQUIRE
                      SET   MOQ_REQUIRE_QTY = @c_pack_moq$modify_qty 
                      WHERE INSTANCE_ID = @v_master_id 
                      AND   CELL_ITEM_ID = @c_pack_moq$cell_item_id
                      AND   LINE_ID = @c_pack_moq$line_id
                      AND   C_SEQ =  @c_pack_moq$seq
                      
                      IF @c_pack_moq$seq = @c_pack_moq$max_seq
                      BREAK;
                      
                      --SET @c_pack_moq$seq = @c_pack_moq$seq + 1
                      
                      SELECT @c_pack_moq$seq = MIN(C_SEQ)
                      FROM TH_BUF_DEMAND_PACK_REQUIRE
                      WHERE INSTANCE_ID = @v_master_id 
                      AND   CELL_ITEM_ID = @c_pack_moq$cell_item_id
                      AND   LINE_ID = @c_pack_moq$line_id
                      AND   C_SEQ >  @c_pack_moq$seq
                      AND   MFG_QTY > 0  
                       
                      UPDATE TH_BUF_DEMAND_PACK_REQUIRE
                      SET   MFG_QTY = MFG_QTY - @c_pack_moq$diff -- case when MFG_QTY - @c_pack_moq$diff < 0 then 0 else MFG_QTY - @c_pack_moq$diff end 
                      WHERE INSTANCE_ID = @v_master_id 
                      AND   CELL_ITEM_ID = @c_pack_moq$cell_item_id
                      AND   LINE_ID = @c_pack_moq$line_id
                      AND   C_SEQ =  @c_pack_moq$seq
                      
                      
                      SELECT @c_pack_moq$diff_mfg_qty = ISNULL(MAX(MFG_QTY) , 0) * -1 
                      FROM  TH_BUF_DEMAND_PACK_REQUIRE
                      WHERE INSTANCE_ID = @v_master_id 
                      AND   CELL_ITEM_ID = @c_pack_moq$cell_item_id
                      AND   LINE_ID = @c_pack_moq$line_id
                      AND   C_SEQ =  @c_pack_moq$seq
                      AND   MFG_QTY < 0
                      
                      UPDATE TH_BUF_DEMAND_PACK_REQUIRE
                      SET   MFG_QTY = 0 
                      WHERE INSTANCE_ID = @v_master_id 
                      AND   CELL_ITEM_ID = @c_pack_moq$cell_item_id
                      AND   LINE_ID = @c_pack_moq$line_id
                      AND   C_SEQ =  @c_pack_moq$seq
                      AND   MFG_QTY < 0 
                      
                    END
              
              END

          CLOSE C_MOQ
          DEALLOCATE C_MOQ    
          
          --LOG 생성
          SET @v_message = 'MOQ : '  + convert(nvarchar,@n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
            --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'END', @n_log_count, null, @v_message, null
          
          UPDATE TH_BUF_DEMAND_PACK_REQUIRE
          SET   MOQ_REQUIRE_QTY = MFG_QTY 
          WHERE INSTANCE_ID = @v_master_id
          AND   MOQ_REQUIRE_QTY IS NULL
          
          UPDATE TH_BUF_DEMAND_PACK_REQUIRE
          SET   MOQ_SIZE = DBO.FN_GET_BOX_TOTL_CELL_QTY(DIVISION_ID,'',CELL_ITEM_ID,'')
          WHERE INSTANCE_ID =@v_master_id
        
        END
      
      /*
        특정 MODEL 만 CALCULATION 저장 
      */
      BEGIN
      
        SET @v_table_name = 'FP_DEMAND_PACK_REQUIRE_CELL_H'
        SET @n_row_count = 0
        
        IF @v_cal_option = 'ALL'
        BEGIN
        
          UPDATE TH_BUF_DEMAND_PACK_REQUIRE
          SET IS_CAL ='Y'
          WHERE INSTANCE_ID = @v_master_id
          --AND   PLAN_ID = @v_plan_id
        
        END
        ELSE
        BEGIN
        
          UPDATE TH_BUF_DEMAND_PACK_REQUIRE
          SET TH_BUF_DEMAND_PACK_REQUIRE.IS_CAL= 'Y'
          FROM (
				SELECT INSTANCE_ID , PLAN_ID , DIVISION_ID , SITE_ID , PLANT_ID , ITEM_ID
				FROM TH_BUF_REQUEST_PLAN_CAL_MODEL
				WHERE INSTANCE_ID = @v_master_id
                AND   PLAN_ID = @v_plan_id
				AND   IS_CAL = 'Y'
          		/*SELECT INSTANCE_ID , COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , CELL_ITEM_ID 
        		FROM FP_DEMAND_PACK_REQUIRE_CELL_H
        		WHERE REQUIRE_dATE >=@v_target_date --  CONVERT(DATE,GETDATE() , 112) 
        		AND  IS_CAL = 'Y'
        		AND  INSTANCE_ID = @v_master_id
                AND  PLAN_ID = @v_plan_id
        		GROUP BY  INSTANCE_ID , COMPANY_ID , INSTANCE_ID , DIVISION_ID , SITE_ID , PLANT_ID , CELL_ITEM_ID*/ 
          		)A
          WHERE TH_BUF_DEMAND_PACK_REQUIRE.INSTANCE_ID = @v_master_id
          --AND  TH_BUF_DEMAND_PACK_REQUIRE.PLAN_ID = @v_plan_id
          AND   TH_BUF_DEMAND_PACK_REQUIRE.INSTANCE_ID = A.INSTANCE_ID
          AND 	TH_BUF_DEMAND_PACK_REQUIRE.DIVISION_ID  = A.DIVISION_ID
          AND 	TH_BUF_DEMAND_PACK_REQUIRE.SITE_ID = A.SITE_ID
          AND	TH_BUF_DEMAND_PACK_REQUIRE.PLANT_ID = A.PLANT_ID
          AND	TH_BUF_DEMAND_PACK_REQUIRE.CELL_ITEM_ID = A.ITEM_ID
        
        END
      
      END
      
      /*
        최종 데이터 생성
      */
      BEGIN
      
        SET @v_table_name = 'FP_DEMAND_PACK_REQUIRE_CELL_H'
        SET @n_row_count = 0
        
        /*
          Calculation 대상 품번만 적용
        */
        
        DELETE FP_DEMAND_PACK_REQUIRE_CELL_H  WHERE INSERT_TIME < DATEADD(DAY, -20, GETDATE())
        
        DELETE FP_DEMAND_PACK_REQUIRE_CELL_H 
        WHERE INSTANCE_ID = @v_master_id 
        AND   PLAN_ID = @v_plan_id
       -- AND   ( IS_CAL = 'Y' OR @v_cal_option ='ALL')	-- (D20201020~R1022.01)
		AND	  ( CELL_ITEM_ID IN (
								SELECT ITEM_ID
								FROM TH_BUF_REQUEST_PLAN_CAL_MODEL
								WHERE INSTANCE_ID = @v_master_id
								AND   PLAN_ID = @v_plan_id
								)
				OR @v_cal_option ='ALL'		
				OR @v_copy_flag ='R'	
			   )
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
        
        /*
          확정구간 INSERT
        */
        INSERT INTO FP_DEMAND_PACK_REQUIRE_CELL_H
          (		
			INSTANCE_ID ,
			PLAN_ID,
			COMPANY_ID , 
       		DIVISION_ID , 
       		SITE_ID , 
       		PLANT_ID , 
       		-- TOP_ITEM_ID , 20180719 컬럼삭제요청 
       		-- ITEM_ID ,
       		CELL_ITEM_ID ,
       		STORAGE_ID , 
       		SOC_ID , 
       		MARKET ,
       		REQUIRE_DATE , 
       		ORG_REQUIRE_QTY , 
       		REQUIRE_QTY , 
       		INSERT_ID , 
       		INSERT_TIME , 
       		UPDATE_ID , 
       		UPDATE_TIME ,
            MOQ , 
            IS_CAL
         ) 
        SELECT  INSTANCE_ID ,
                @v_plan_id as PLAN_ID,
                COMPANY_ID , 
           		DIVISION_ID , 
           		SITE_ID , 
           		PLANT_ID , 
           		CELL_ITEM_ID ,
           		STORAGE_ID , 
           		SOC_ID , 
           		MARKET ,
           		REQUIRE_DATE , 
           		REQUIRE_QTY as ORG_REQUIRE_QTY , 
           		REQUIRE_QTY , 
           		'CONFIRM_FIX' AS INSERT_ID , 
           		GETDATE() AS INSERT_TIME , 
           		'CONFIRM_FIX' AS UPDATE_ID , 
           		GETDATE() AS UPDATE_TIME ,
                MOQ ,
                'Y' AS IS_CAL
        FROM FP_DEMAND_PACK_REQUIRE_FIX A
        WHERE INSTANCE_ID = @v_master_id 
        AND PLAN_ID = @v_confirm_id
        AND REQUIRE_DATE <= @v_fix_date
        AND REQUIRE_DATE >= @v_target_date
        AND ( @v_cal_option ='ALL' OR EXISTS (
                                              SELECT 1
                                              FROM TH_BUF_DEMAND_PACK_REQUIRE X
                                              WHERE X.IS_CAL ='Y'
                                              AND   A.INSTANCE_ID = X.INSTANCE_ID
                                              AND   A.COMPANY_ID = X.COMPANY_ID 
                                              AND   A.DIVISION_ID =X.DIVISION_ID
                                              AND   A.SITE_ID = X.SITE_ID
                                              AND   A.PLANT_ID = X.PLANT_ID
                                              AND   A.CELL_ITEM_ID = X.CELL_ITEM_ID
                                            ) 
            )
        
      
        INSERT INTO FP_DEMAND_PACK_REQUIRE_CELL_H
         (  INSTANCE_ID ,
            PLAN_ID,
            COMPANY_ID , 
       		DIVISION_ID , 
       		SITE_ID , 
       		PLANT_ID , 
       		-- TOP_ITEM_ID , 20180719 컬럼삭제요청 
       		-- ITEM_ID ,
       		CELL_ITEM_ID ,
       		STORAGE_ID , 
       		SOC_ID , 
       		MARKET ,
       		REQUIRE_DATE , 
       		ORG_REQUIRE_QTY , 
       		REQUIRE_QTY , 
       		INSERT_ID , 
       		INSERT_TIME , 
       		UPDATE_ID , 
       		UPDATE_TIME ,
            MOQ
         ) 
        SELECT  A.INSTANCE_ID , 
                @v_plan_id AS PLAN_ID,
                A.COMPANY_ID , 
                A.DIVISION_ID , 
                A.SITE_ID , 
        		A.PLANT_ID , 
                A.CELL_ITEM_ID , 
                A.STORAGE_ID , 
                A.SOC_ID , 
    		A.MARKET , 
                A.REQUIRE_DATE,  
                SUM(ORG_REQUIRE_QTY) AS ORG_REQUIRE_QTY , 
                SUM(REQUIRE_QTY)  AS REQUIRE_QTY, 
        		A.INSERT_ID , 
                A.INSERT_TIME, 
               A.UPDATE_ID , 
                A.UPDATE_TIME,
           A.MOQ_SIZE
        FROM (
              SELECT  DISTINCT  A.INSTANCE_ID, 
                      			A.COMPANY_ID , 
                           		A.DIVISION_ID , 
                           		A.SITE_ID , 
                           		A.PLANT_ID , 
                           		-- A.TOP_ITEM_ID , 
                           		-- A.ITEM_ID ,
                                A.UNIQUE_ID , 
                           		A.CELL_ITEM_ID ,
                           		CASE WHEN A.MARKET = 'E' THEN B.EXPORT_SLOC_ID ELSE B.DOMESTIC_SLOC_ID END AS STORAGE_ID, 
                           		ISNULL(C.SOC_ID,'Etc') AS SOC_ID , 
                           		A.MARKET ,
                           		A.REQUIRE_DATE , 
                           		A.REQUIRE_QTY AS ORG_REQUIRE_QTY , 
                           		A.REQUIRE_QTY  AS REQUIRE_QTY, 
                        		'PR_SCM_OF_PACK_REQUIRE_CELL' AS INSERT_ID ,
                        		GETDATE()  AS INSERT_TIME ,
                        		'PR_SCM_OF_PACK_REQUIRE_CELL' AS UPDATE_ID ,
                        		GETDATE() AS UPDATE_TIME,
                                A.MOQ_SIZE
              FROM (
                	SELECT  DISTINCT INSTANCE_ID , 
                					COMPANY_ID , 
                					DIVISION_ID , 
                					SITE_ID , 
                					PLANT_ID  , 
                					-- TOP_ITEM_ID , 
                					-- ITEM_ID , 
									A.INSTANCE_ID +'^' +  A.CELL_ITEM_ID + '^' +  A.LINE_ID + '^'+  CONVERT(NVARCHAR, A.REQUIRE_DATE , 112)  AS UNIQUE_ID ,
                					CELL_ITEM_ID , 
                					'D' AS MARKET , --MARKET ,  
                					REQUIRE_DATE ,  
                					LINE_ID  , 
                					SUM(ISNULL(MOQ_REQUIRE_QTY,REQUIRE_QTY)) AS REQUIRE_QTY , 
                					OPERATION_ID,
									MOQ_SIZE
                	FROM (
                  			SELECT  INSTANCE_ID , 
                  					COMPANY_ID , DIVISION_ID , 
                  					SITE_ID , PLANT_ID  , 
                  					-- TOP_ITEM_ID ,
                  					-- ITEM_ID ,
            								CELL_ITEM_ID  , 
            								MARKET ,
            								DUE_DATE AS REQUIRE_DATE , 
                					MFG_QTY   AS REQUIRE_QTY, 
                					LINE_ID  , 
                					OPERATION_ID,
									MOQ_REQUIRE_QTY,
									MOQ_SIZE
                  			FROM TH_BUF_DEMAND_PACK_REQUIRE
                  			WHERE INSTANCE_ID = @v_master_id
                  			-- AND (ALT_PRIORITY = 1 OR ALT_PRIORITY IS NULL)  -- (D20201110~R1110.01)
                  			AND (L_ALT_PRIORITY = 1 OR L_ALT_PRIORITY IS NULL)
							AND  ( IS_CAL= 'Y' OR @v_copy_flag ='R'	 )
            				)A 
                	GROUP BY	INSTANCE_ID , 
                				COMPANY_ID , 
                				DIVISION_ID , 
                				SITE_ID , 
                				PLANT_ID  , 
                				-- TOP_ITEM_ID , 
                				-- ITEM_ID , 
                				CELL_ITEM_ID , 
                				--MARKET ,  
                				REQUIRE_DATE , 
                				LINE_ID  , 
                				OPERATION_ID,
								MOQ_SIZE
                    )A  
                      INNER JOIN SCM_LINE_M B
                          ON A.COMPANY_ID = B.COMPANY_ID 
                          AND A.DIVISION_ID = B.DIVISION_ID
                          AND A.SITE_ID = B.SITE_ID
                          AND A.PLANT_ID = B.PLANT_ID
                          AND A.LINE_ID = B.LINE_ID
                          --AND A.OPERATION_ID = B.OPERATION_ID
                          AND B.OPERATION_ID = 'P1000' 		--(D20201006~R1006.01)
                      LEFT OUTER JOIN  (
                      					SELECT SEGMENT1 AS SITE_ID , SEGMENT2 AS DIVISION_ID , SEGMENT3 AS SOC_ID 
                    					FROM  SCM_SYS_LOOKUP_VALUE
                    					WHERE LOOKUP_TYPE_CODE = 'PACK_SOC'
                    					AND   ATTRIBUTE1 = 'Y'  --  1순위 SOC 사용 없을시 COMMON
                      					)C
                          ON  A.SITE_ID = 	C.SITE_ID
   				AND A.DIVISION_ID = C.DIVISION_ID
              WHERE CASE WHEN A.MARKET = 'E' THEN B.EXPORT_SLOC_ID ELSE B.DOMESTIC_SLOC_ID END IS NOT NULL 
              AND   A.REQUIRE_QTY > 0
              )A
        WHERE  NOT EXISTS (
        					SELECT  1
				            FROM SCM_SYS_LOOKUP_VALUE X
				            WHERE  X.LOOKUP_TYPE_CODE = 'REQUEST_PLAN_EXCEPT_ITEM'
				            AND		 A.COMPANY_ID = X.SEGMENT1
				            AND 	 A.DIVISION_ID = X.SEGMENT2
				            AND		 A.SITE_ID = X.SEGMENT3
				            AND		 A.PLANT_ID = X.SEGMENT4
				            AND		 A.CELL_ITEM_ID = X.SEGMENT5
        					)
        AND   A.REQUIRE_DATE > @v_fix_date                
        GROUP BY  A.INSTANCE_ID , 
                  A.COMPANY_ID , 
                  A.DIVISION_ID , 
                  A.SITE_ID , 
                  A.PLANT_ID , 
                  A.CELL_ITEM_ID , 
                  A.STORAGE_ID , 
                  A.SOC_ID , 
                  A.MARKET , 
                  A.REQUIRE_DATE, 
                  A.INSERT_ID , 
                  A.INSERT_TIME, 
                  A.UPDATE_ID , 
                  A.UPDATE_TIME ,
                  A.MOQ_SIZE
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
        
      
      END
      
      BEGIN
        
        UPDATE FP_DEMAND_PACK_REQUIRE_CELL_H
        SET IS_CAL ='N'
        WHERE INSTANCE_ID = @v_master_id
        AND   PLAN_ID = @v_plan_id   

		DELETE TH_BUF_REQUEST_PLAN_CAL_MODEL
		WHERE INSTANCE_ID = @v_master_id
        AND   PLAN_ID = @v_plan_id
      
      END
        
      
    END
    
    ELSE IF @v_copy_flag = 'Y' OR @v_copy_flag = 'M'	-- Version UP -- (D20201020~R1022.01)
    BEGIN
    				-- (D20201020~R1022.01)
			      --SET @v_message = 'instance_id : '+ @v_master_id  +' v_basis_plan_id : '+ @v_basis_plan_id + ' v_cal_option : ' + @p_cal_option + ' v_p_fix_date :' + CONVERT(nvarchar, @p_fix_date, 112)  + ' v_copy+flag : ' + @p_copy_flag
			      --EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null  
			IF @v_copy_flag = 'Y'
				BEGIN
						SELECT 	@v_basis_plan_id = PLAN_ID
						FROM 	(
										SELECT INSTANCE_ID , PLAN_ID , RANK() OVER (ORDER BY UPDATE_TIME DESC) AS SEQ
										FROM    SCM_FP_IN_HOUSE_PLAN_H
										WHERE   INSTANCE_ID = @V_MASTER_ID 
										AND     CONFIRM_FLAG = 'Y'
									)	A
						WHERE 	SEQ = 1					      
				END
			ELSE 	-- Moving Plan 
				BEGIN
						SELECT 	@v_basis_plan_id = PLAN_ID
						FROM 	(
										SELECT INSTANCE_ID , PLAN_ID , RANK() OVER (ORDER BY UPDATE_TIME DESC) AS SEQ
										FROM    SCM_FP_IN_HOUSE_PLAN_H
										WHERE   INSTANCE_ID = @v_form_master_id 
										AND     CONFIRM_FLAG = 'Y'
									)	A
						WHERE 	SEQ = 1
				END 
			-- IF END
			
			    
			      SELECT @v_seq = ISNULL(MAX(CONVERT(NUMERIC, SEQ)) + 1,1)
			      FROM  SCM_FP_IN_HOUSE_PLAN_H
			      WHERE   INSTANCE_ID = @V_MASTER_ID 
			      AND     PLAN_DATE = CONVERT(NVARCHAR,@v_target_date,112)
			      
				  SET @v_message = 'instance_id : '+ @v_master_id  + 'v_form_master_id : '+ @v_form_master_id  + ' v_basis_plan_id : '+ @v_basis_plan_id + ' v_cal_option : ' + @p_cal_option + ' v_p_fix_date :' + CONVERT(nvarchar, @p_fix_date, 112)  + ' v_copy+flag : ' + @p_copy_flag
			      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null  
			
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
			            UPDATE_TIME
			          )
				-- 조회하지 않고 넣어줌
				SELECT  	@v_master_id  AS INSTANCE_ID , 
			              	CONVERT(NVARCHAR,@v_target_date,112) +'-'  + DBO.FN_LPAD_NVARCHAR( @v_seq,2,0) AS PLAN_ID  , 
			              	@v_fix_date AS FIX_DATE , 
			              	'N' AS CONFIRM_FLAG , 
							@v_basis_plan_id + '-' + @v_copy_flag AS DESCRIPTION , 
			              	CONVERT(NVARCHAR,@v_target_date,112) AS PLAN_DATE ,   
			              	@v_seq AS SEQ,  -- DBO.FN_LPAD_NVARCHAR( @v_seq,2,0)  AS SEQ , 
			              	@p_user_id AS INSERT_ID , 
							GETDATE() AS INSERT_TIME , @p_user_id AS UPDATE_ID , GETDATE() AS UPDATE_TIM
				/**			       
			     SELECT  @v_master_id  AS INSTANCE_ID , 
			              CONVERT(NVARCHAR,@v_target_date,112) +'-'  + DBO.FN_LPAD_NVARCHAR( @v_seq,2,0) AS PLAN_ID  , 
			              @v_fix_date AS FIX_DATE , 
			              'N' AS CONFIRM_FLAG , 
			    				  @v_basis_plan_id AS DESCRIPTION , 
			              CONVERT(NVARCHAR,@v_target_date,112) AS PLAN_DATE ,   
			              @v_seq AS SEQ,  -- DBO.FN_LPAD_NVARCHAR( @v_seq,2,0)  AS SEQ , 
			              @p_user_id AS INSERT_ID , 
			      				GETDATE() AS INSERT_TIME , @p_user_id AS UPDATE_ID , GETDATE() AS UPDATE_TIME			
			      FROM  SCM_FP_IN_HOUSE_PLAN_H
			      WHERE   INSTANCE_ID = @V_MASTER_ID 
			      AND     PLAN_ID = @v_basis_plan_id
			    **/
					
			          
			      --LOG 생성
			      SET @v_message =  'CREATE COPY PLAN INFO : ' + convert(nvarchar,@n_row_count)
			      SET @n_log_count = @n_log_count + 1
			      SET @sysdate = GETDATE()
			      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
			      
			      
			      -- 조회하지 않고 사용
			      /**
			      SELECT @v_plan_id = PLAN_ID
			      FROM  SCM_FP_IN_HOUSE_PLAN_H
			      WHERE   INSTANCE_ID = @V_MASTER_ID 
			      AND     DESCRIPTION = @v_basis_plan_id
			      **/
			      SET @v_plan_id = CONVERT(NVARCHAR,@v_target_date,112) +'-'  + DBO.FN_LPAD_NVARCHAR( @v_seq,2,0)
			      
			      --LOG 생성
			      SET @v_message =  'PLAN_ID : ' + @v_plan_id
			      SET @n_log_count = @n_log_count + 1
			      SET @sysdate = GETDATE()
			      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
			      
			      IF @v_master_id ='PL_PACK' --AND 1=2
			      BEGIN
			      
					        /*
					        DELETE FP_INHOUSE_REQUEST_BOH_R WHERE INSTANCE_ID = @v_master_id AND PLAN_ID = @v_plan_id
					        
					        INSERT INTO FP_INHOUSE_REQUEST_BOH_R
					             (  INSTANCE_ID
					              , PLAN_ID
					              , COMPANY_ID
					              , DIVISION_ID
					              , SITE_ID
					              , PLANT_ID
					              , ITEM_ID
					              , SLOC_ID
					              , QTY
					              , ORG_QTY
					              , INSERT_ID
					              , INSERT_DTTM
					              , UPDATE_ID
					              , UPDATE_DTTM
					              , SEQ
					             ) 
					        SELECT  INSTANCE_ID
					              , @v_plan_id AS PLAN_ID
					              , COMPANY_ID
					              , DIVISION_ID
					              , SITE_ID
					              , PLANT_ID
					              , ITEM_ID
					              , SLOC_ID
					              , QTY
					              , ORG_QTY
					              , @v_proc_name AS INSERT_ID
					              , GETDATE() AS INSERT_DTTM
					              , @v_proc_name AS UPDATE_ID
					              , GETDATE() AS UPDATE_DTTM
					              , SEQ
					        FROM  FP_INHOUSE_REQUEST_BOH_R
					        WHERE INSTANCE_ID = @v_master_id 
					        AND   PLAN_ID = @v_basis_plan_id 
					        */
					        
					        SET @v_table_name = 'FP_INHOUSE_REQUEST_BOH_R'
					        
					        DELETE FP_INHOUSE_REQUEST_BOH_R
					        WHERE INSTANCE_ID = @v_master_id
					        AND   PLAN_ID = @v_plan_id
					        
					        INSERT INTO FP_INHOUSE_REQUEST_BOH_R
					            (
					                INSTANCE_ID
					              , PLAN_ID
					              , COMPANY_ID
					              , DIVISION_ID
					              , SITE_ID
					              , PLANT_ID
					              , FACTORY_ID 
					              , ITEM_ID
					              , SLOC_ID
					              , QTY
					              , ORG_QTY
					              , INSERT_ID
					              , INSERT_DTTM
					              , UPDATE_ID
					              , UPDATE_DTTM
					              , SEQ
					            )
					        SELECT  @v_master_id AS INSTANCE_ID 
					              , @v_plan_id AS PLAN_ID 
					              , A.COMPANY_ID
					              , A.DIVISION_ID
					              , A.SITE_ID
					              , A.PLANT_ID
					              , A.FACTORY_ID 
					              , A.FP_APPLY_ITEM_ID AS ITEM_ID
					              , ISNULL(B.EXPORT_SLOC_ID , DOMESTIC_SLOC_ID) AS SLOC_ID
					              , ISNULL(MAX(MODIFY_FP_APPLY_WIPQTY),SUM(A.FP_APPLY_WIPQTY)) AS QTY
					              , ISNULL(MAX(MODIFY_FP_APPLY_WIPQTY),SUM(A.FP_APPLY_WIPQTY)) AS QTY
					              , @v_proc_name AS INSERT_ID
					       , GETDATE() AS INSERT_DTTM
					              , @v_proc_name AS UPDATE_ID 
					              , GETDATE() AS UPDATE_DTTM
					              , 1 AS SEQ
					        FROM   SCM_STOCK_H_V A WITH(NOLOCK)
					      	LEFT OUTER JOIN SCM_LINE_M B WITH(NOLOCK)
					        		ON  A.COMPANY_ID = B.COMPANY_ID
					        		AND A.DIVISION_ID = B.DIVISION_ID
					        		AND A.SITE_ID = B.SITE_ID
					        		AND A.PLANT_ID = B.PLANT_ID
					        		AND A.FACTORY_ID = B.FACTORY_ID
					      	    	--AND A.FP_APPLY_OPERATION_ID = B.OPERATION_ID
					      	    	AND B.OPERATION_ID = 'P1000' 	-- (D20201006~R1006.01)
					        		AND A.LINE_ID = B.LINE_ID
					        		AND B.ACTIVE_FLAG = 'Y'
					        WHERE  A.OPERATION_ID = 'P1000'
					        AND    A.STOCK_STATUS = 'WAIT'
					        AND    A.STORAGE_ID = 'MES'
					        AND    CONVERT(VARCHAR, A.CUTOFF_DATE,112) = @v_target_date
					        AND    (
                    (A.STORAGE_ID  >= (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_OF_PACK_REQUIRE_CELL' AND SEGMENT1  = '2' AND ACTIVE_FLAG = 'Y' AND ATTRIBUTE3='MIN')
                    AND A.STORAGE_ID < (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_OF_PACK_REQUIRE_CELL' AND SEGMENT1  = '2' AND ACTIVE_FLAG = 'Y' AND ATTRIBUTE3='MAX')) 
                    OR (A.STORAGE_ID >= (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_OF_PACK_REQUIRE_CELL' AND SEGMENT1  = '3' AND ACTIVE_FLAG = 'Y' AND ATTRIBUTE3='MIN') 
                    AND A.STORAGE_ID < (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_OF_PACK_REQUIRE_CELL' AND SEGMENT1  = '3' AND ACTIVE_FLAG = 'Y' AND ATTRIBUTE3='MAX')
                    ) OR (ISNULL(A.FP_APPLY_WIPQTY, 0) >= 0))
					        AND    A.DIVISION_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_OF_PACK_REQUIRE_CELL' AND SEGMENT1  = '4' AND ACTIVE_FLAG = 'Y')
					        AND    A.PLANT_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_OF_PACK_REQUIRE_CELL' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')
					        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.FACTORY_ID ,A.FP_APPLY_ITEM_ID,B.EXPORT_SLOC_ID , B.DOMESTIC_SLOC_ID
			        
						         --LOG 생성
						      SET @v_message = @n_row_count
						      SET @n_log_count = @n_log_count + 1
						      SET @sysdate = GETDATE()
						      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
			      
			      END		-- END IF PL_PACK
			      
				  SET @v_table_name = 'FP_DEMAND_PACK_REQUIRE_CELL_H'
			      
			      DELETE FP_DEMAND_PACK_REQUIRE_CELL_H
			      WHERE INSTANCE_ID = @v_master_id
			      AND   PLAN_ID =  @v_plan_id
			      
			      SET @n_row_count = @@ROWCOUNT
			      --LOG 생성
			      SET @v_message = @n_row_count
			      SET @n_log_count = @n_log_count + 1
			      SET @sysdate = GETDATE()
			      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
			      
				IF @v_copy_flag = 'Y'
				BEGIN
						INSERT INTO FP_DEMAND_PACK_REQUIRE_CELL_H
				        ( 
				          	INSTANCE_ID ,
				          	PLAN_ID , 
				          	COMPANY_ID , 
			     			DIVISION_ID , 
			     			SITE_ID , 
			     			PLANT_ID , 
			     			CELL_ITEM_ID ,
			     			STORAGE_ID , 
			     			SOC_ID , 
			     			MARKET ,
			     			REQUIRE_DATE , 
			     			ORG_REQUIRE_QTY , 
			     			REQUIRE_QTY , 
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
				         				CELL_ITEM_ID ,
				         				STORAGE_ID , 
				         				SOC_ID , 
				         				MARKET ,
				         				REQUIRE_DATE , 
				         				ORG_REQUIRE_QTY , 
				         				REQUIRE_QTY , 
				         				@p_user_id +'_REQUEST_COPY' AS INSERT_ID , 
				         				GETDATE() AS INSERT_TIME , 
				         				@p_user_id +'_REQUEST_COPY' AS UPDATE_ID , 
				         				GETDATE() AS UPDATE_TIME ,
								  		DBO.FN_GET_BOX_TOTL_CELL_QTY(DIVISION_ID,'',CELL_ITEM_ID,'') AS MOQ
						  FROM FP_DEMAND_PACK_REQUIRE_CELL_H
						  WHERE INSTANCE_ID = @v_master_id
						  AND   PLAN_ID = @v_basis_plan_id
						 /*
						-- FP_DEMAND_PACK_REQUIRE_CELL_H 에서 FIX 테이블로 변경 Confirm 버전과 보관주기의 차에 따른 데이타 생성 누락 때문 - 20200103 by cys
						SELECT  INSTANCE_ID ,
								@v_plan_id AS PLAN_ID ,
								COMPANY_ID , 
								DIVISION_ID , 
								SITE_ID , 
								PLANT_ID , 
								CELL_ITEM_ID ,
								STORAGE_ID , 
								SOC_ID , 
								MARKET ,
								REQUIRE_DATE , 
								REQUIRE_QTY AS ORG_REQUIRE_QTY , 
								REQUIRE_QTY , 
								@p_user_id +'_COPY' AS INSERT_ID , 
								GETDATE() AS INSERT_TIME , 
								@p_user_id +'_COPY' AS UPDATE_ID , 
								GETDATE() AS UPDATE_TIME ,
								DBO.FN_GET_BOX_TOTL_CELL_QTY(DIVISION_ID,'',CELL_ITEM_ID,'') AS MOQ
						FROM	FP_DEMAND_PACK_REQUIRE_FIX
						WHERE	INSTANCE_ID = @v_master_id
						AND		PLAN_ID		= @v_basis_plan_id
						*/
				END
				ELSE 
					BEGIN
							INSERT INTO FP_DEMAND_PACK_REQUIRE_CELL_H
					        ( 
					          	INSTANCE_ID ,
					          	PLAN_ID , 
					          	COMPANY_ID , 
				     			DIVISION_ID , 
				     			SITE_ID , 
				     			PLANT_ID , 
				     			CELL_ITEM_ID ,
				     			STORAGE_ID , 
				     			SOC_ID , 
				     			MARKET ,
				     			REQUIRE_DATE , 
				     			ORG_REQUIRE_QTY , 
				     			REQUIRE_QTY , 
				     			INSERT_ID , 
				     			INSERT_TIME , 
				     			UPDATE_ID , 
				     			UPDATE_TIME ,
					          	MOQ
					         ) 
							SELECT	DISTINCT @v_master_id AS INSTANCE_ID ,
										@v_plan_id AS PLAN_ID ,
										A.COMPANY_ID ,
										A.DIVISION_ID ,
										A.SITE_ID ,
										CASE WHEN A.SITE_ID = 'A003' THEN ISNULL(B.PLANT_ID, A.PLANT_ID) ELSE A.PLANT_ID END	PLANT_ID ,	-- Hazel Park Plant 가 변경되어 들어와서 다시 변경함
										A.ITEM_ID AS CELL_ITEM_ID,
										A.STORAGE_ID , 
										A.SOC_ID ,
										A.MARKET ,
										A.DELIVERY_DATE AS REQUIRE_DATE ,
										A.ORG_DELIVERY_QTY AS ORG_REQUIRE_QTY ,
										A.DELIVERY_QTY AS REQUIRE_QTY ,
										@p_user_id +'_MOVING_COPY' AS INSERT_ID , 
										GETDATE() AS INSERT_TIME , 
										@p_user_id +'_MOVING_COPY' AS UPDATE_ID , 
										GETDATE() AS UPDATE_TIME ,
										DBO.FN_GET_BOX_TOTL_CELL_QTY(A.DIVISION_ID, '', A.ITEM_ID, '') AS MOQ
							FROM 	FP_CELL_DELIVERY_PLAN_H	A	
										LEFT OUTER JOIN (
																	SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, DOMESTIC_SLOC_ID  AS STORAGE_ID
																	FROM SCM_LINE_M
																	WHERE 1=1
																	AND OPERATION_ID = 'P1000'
																	AND ACTIVE_FLAG = 'Y'
										) B
											ON 1=1
											AND A.COMPANY_ID = B.COMPANY_ID
											AND A.DIVISION_ID = B.DIVISION_ID
											AND A.SITE_ID = B.SITE_ID
											AND A.STORAGE_ID = B.STORAGE_ID
							WHERE 	A.INSTANCE_ID = @v_form_master_id
							AND   	A.PLAN_ID = @v_basis_plan_id
					END
				-- IF END
				
			      SET @n_row_count = @@ROWCOUNT
			    
			      --LOG 생성
			      SET @v_message = @n_row_count
			      SET @n_log_count = @n_log_count + 1
			      SET @sysdate = GETDATE()
			      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
			      
			      UPDATE FP_DEMAND_PACK_REQUIRE_CELL_H
			      SET IS_CAL ='N'
			      WHERE INSTANCE_ID = @v_master_id
			      AND   PLAN_ID = @v_plan_id   
      
    
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
