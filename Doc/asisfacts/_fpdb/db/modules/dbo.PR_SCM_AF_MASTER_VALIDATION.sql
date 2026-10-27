CREATE PROCEDURE [dbo].[PR_SCM_AF_MASTER_VALIDATION]
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_AF_MASTER_VALIDATION                                               **/
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
/** 2016.10.19   LJH         최초 작성                                                         **/
/** 2026/06/08   kimcd      [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응.            **/
/**                         LINK Instance 유형 Pack 기준으로 조건 추가                          **/
/***********************************************************************************************/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id        nvarchar(30)
  DECLARE @v_plan_id          nvarchar(30)
  DECLARE @plan_date          nvarchar(10) = CONVERT(nvarchar(10),GETDATE(),23)
  
  DECLARE @v_start_month      nvarchar(10)
  DECLARE @v_start_week       nvarchar(10)
  DECLARE @v_end_week         nvarchar(10)

  DECLARE @v_end_week_shop_a  nvarchar(10)    -- 조립 check week
  DECLARE @v_end_week_shop_p  nvarchar(10)    -- pack check week
  DECLARE @v_end_week_shop_e  nvarchar(10)    -- 전극 check week
  DECLARE @v_end_week_shop_f  nvarchar(10)    -- 특성 check week

  DECLARE @validation_seq     Integer = 0

  -- LOG 용 변수 설정
  DECLARE @v_proc_name        nvarchar(100) = 'PR_SCM_AF_MASTER_VALIDATION'
  DECLARE @v_table_name       nvarchar(100)
  DECLARE @v_message          nvarchar(250)
  DECLARE @v_descr            nvarchar(250)
  DECLARE @n_row_count        Integer  = 0
  DECLARE @n_log_count        Integer  = 0
  DECLARE @v_log_code         nvarchar(10)
  
  DECLARE @sysdate            DATETIME2 = GETDATE()

  DECLARE @v_temp1            nvarchar(1000)
  DECLARE @v_temp2            nvarchar(1000)

  SET @v_master_id  = 'MASTER'
  SET @v_plan_id    = 'VALIDATION_' + CONVERT(nvarchar, GETDATE(), 112)
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', @n_log_count, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    BEGIN

      -- VALIDATION 주차 설정 : 10주
      BEGIN
      
        SELECT  @v_start_month = CONVERT(NVARCHAR,YEAR) + CONVERT(NVARCHAR,MONTH) 
        FROM SCM_SYS_CALENDAR_M
        WHERE DATE_ID = CONVERT(nvarchar(10),GETDATE(),23)
      
        SET @v_table_name = 'SCM_SYS_CALENDAR_M'

        SELECT @v_start_week = MIN(WEEK),
               @v_end_week   = MAX(WEEK)
        FROM   (
                SELECT A.*,
                       DENSE_RANK() OVER (ORDER BY WEEK) AS SEQ
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  DATE_ID >= CONVERT(DATE, GETDATE())
               ) A
        WHERE  SEQ <= 10       
      
        --LOG 생성
        SET @v_message = '@v_start_week : ' + @v_start_week
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

        SET @v_message = '@v_end_week : ' + @v_end_week
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

        -- 조립   
        SELECT  @v_end_week_shop_a = MAX(WEEK)
        FROM   (
                SELECT A.*,
                       DENSE_RANK() OVER (ORDER BY WEEK) AS SEQ
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  DATE_ID >= CONVERT(DATE, GETDATE())
               ) A , 
               (
                SELECT   MAX(ATTRIBUTE13) AS SEQ
                FROM SCM_SYS_LOOKUP_VALUE
                WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID'
                AND		  ATTRIBUTE9 = 'A'
                GROUP BY   ATTRIBUTE9
               )B
        WHERE  A.SEQ <= B.SEQ
                             
      
        --LOG 생성
        SET @v_message = '@v_end_week_shop_a : ' + @v_end_week_shop_a
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

        -- pack
        SELECT  @v_end_week_shop_p = MAX(WEEK)
        FROM   (
                SELECT A.*,
                       DENSE_RANK() OVER (ORDER BY WEEK) AS SEQ
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  DATE_ID >= CONVERT(DATE, GETDATE())
               ) A , 
               (
                SELECT   MAX(ATTRIBUTE13) AS SEQ
                FROM SCM_SYS_LOOKUP_VALUE
                WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID'
                AND		  ATTRIBUTE9 = 'P'
                GROUP BY   ATTRIBUTE9
               )B
        WHERE  A.SEQ <= B.SEQ
      
        --LOG 생성
        SET @v_message = '@v_end_week_shop_p : ' + @v_end_week_shop_p
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

        -- 전극
        SELECT @v_end_week_shop_e = MAX(WEEK)
        FROM   (
                SELECT A.*,
                       DENSE_RANK() OVER (ORDER BY WEEK) AS SEQ
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  DATE_ID >= CONVERT(DATE, GETDATE())
               ) A , 
               (
                SELECT   MAX(ATTRIBUTE13) AS SEQ
                FROM SCM_SYS_LOOKUP_VALUE
                WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID'
                AND		  ATTRIBUTE9 = 'E1'
                GROUP BY   ATTRIBUTE9
               )B
        WHERE  A.SEQ <= B.SEQ
      
        --LOG 생성
        SET @v_message = '@v_end_week_shop_e : ' + @v_end_week_shop_e
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
        
        
        SELECT @v_end_week_shop_f = MAX(WEEK)
        FROM   (
                SELECT A.*,
                       DENSE_RANK() OVER (ORDER BY WEEK) AS SEQ
                FROM   SCM_SYS_CALENDAR_M A
      WHERE  DATE_ID >= CONVERT(DATE, GETDATE())
               ) A , 
               (
                SELECT   MAX(ATTRIBUTE13) AS SEQ
                FROM SCM_SYS_LOOKUP_VALUE
                WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID'
                AND		  ATTRIBUTE9 = 'F'
                GROUP BY   ATTRIBUTE9
               )B
        WHERE  A.SEQ <= B.SEQ
      
        --LOG 생성
        SET @v_message = '@v_end_week_shop_f : ' + @v_end_week_shop_f
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

        --LOG 생성
        SET @v_message = '@plan_date : ' + @plan_date
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      END

      -- BOM 추출
      BEGIN
      
        DELETE TH_BUF_MASTER_VALIDATION_RESULT
      
        SET @v_table_name = 'TH_BUF_SCM_VALIDATION_BOM'   -- SCM_BOM_M 에 대한 정보 추출

        DELETE FROM TH_BUF_SCM_VALIDATION_BOM
        
        INSERT INTO TH_BUF_SCM_VALIDATION_BOM
              (
               COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID,
               PARENT_ITEM_ID, CHILD_ITEM_ID, ALT_ID, ALT_PRIORITY, KEY_DATE,
               ITEM_CLASS, ITEM_ACTIVE_FLAG, CLASS_ID, USE_FLAG
              )
        SELECT DISTINCT
               A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,
               A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.ALT_ID, A.ALT_PRIORITY, A.KEY_DATE,
               A.ITEM_CLASS, A.ACTIVE_FLAG,
               C.CLASS_ID, C.USE_FLAG
        FROM   (
                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,
                       A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.ALT_ID, A.ALT_PRIORITY, A.KEY_DATE,
                       B.ITEM_CLASS, B.ACTIVE_FLAG
                FROM   (
                        SELECT AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID,
                               AA.PARENT_ITEM_ID, AA.CHILD_ITEM_ID, AA.ALT_ID, AA.ALT_PRIORITY, AA.KEY_DATE
                        FROM   SCM_BOM_M AA,
                               (
                                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID,
                                       MAX(KEY_DATE) AS KEY_DATE
                                FROM   SCM_BOM_M A,
                                       SCM_ITEM_M B,
                                       SCM_ITEM_CLASS_M C  
                                WHERE  1=1
                                AND    A.ACTIVE_FLAG    = 'Y'
                                AND    A.COMPANY_ID     = B.COMPANY_ID
                                AND    A.DIVISION_ID    = B.DIVISION_ID
                                AND    A.SITE_ID        = B.SITE_ID
                                AND    A.CHILD_ITEM_ID  = B.ITEM_ID  
                                AND    B.ACTIVE_FLAG    = 'Y'
                                AND    B.ITEM_CLASS     = C.CLASS_ID  
                                AND    C.USE_FLAG       = 'Y'                                
                                AND    A.EFF_END_DATE  >= CONVERT(DATE, GETDATE())
                                GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                               ) BB
                        WHERE  AA.COMPANY_ID      = BB.COMPANY_ID
                        AND    AA.DIVISION_ID     = BB.DIVISION_ID
                        AND    AA.SITE_ID         = BB.SITE_ID
                        AND    AA.PLANT_ID        = BB.PLANT_ID
                        AND    AA.PARENT_ITEM_ID  = BB.PARENT_ITEM_ID
                        AND    AA.CHILD_ITEM_ID   = BB.CHILD_ITEM_ID
                        AND    AA.KEY_DATE        = BB.KEY_DATE
                        AND    AA.ACTIVE_FLAG     = 'Y'
                        AND    AA.BOM_VERSION_ID  = '1'
                        AND    AA.EFF_END_DATE   >= CONVERT(DATE, GETDATE())
                       ) A
                       LEFT OUTER JOIN SCM_ITEM_M B
                            ON    A.COMPANY_ID = B.COMPANY_ID
                            AND   A.DIVISION_ID = B.DIVISION_ID
                            AND   A.SITE_ID = B.SITE_ID
                            AND   A.CHILD_ITEM_ID = B.ITEM_ID
               ) A
               LEFT OUTER JOIN SCM_ITEM_CLASS_M C
                    ON    A.ITEM_CLASS = C.CLASS_ID
        WHERE  A.ACTIVE_FLAG IS NOT NULL
        AND    A.ACTIVE_FLAG = 'Y'
        AND    C.USE_FLAG IS NOT NULL
        AND    C.USE_FLAG = 'Y'   


        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_message = 'TARGET BOM  : ' + CONVERT(nvarchar, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      -- Target 추출
      BEGIN
      
        SET @v_table_name = 'TH_BUF_MASTER_VALIDATION_TARGET'
        SET @n_row_count = 0

        DELETE FROM TH_BUF_MASTER_VALIDATION_TARGET
        
        INSERT INTO TH_BUF_MASTER_VALIDATION_TARGET
             (
               COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , SHOP_GROUP_ID
             , INSTANCE_ID
             , ITEM_ID
             , MFG_MONTH
             , MFG_WEEK
             , LINE_ID
             , OPERATION_ID
             )
        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
             , A.SHOP_GROUP_ID, F.INSTANCE_ID, A.ITEM_ID
             , G.MFG_MONTH, A.MFG_WEEK
             , A.LINE_ID, A.OPERATION_ID
        FROM   (
                SELECT DISTINCT 
                       A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
                     , A.SHOP_GROUP_ID, A.ITEM_ID, A.MFG_WEEK
                     , A.LINE_ID, A.OPERATION_ID
                FROM   (
						-- 1 FP_WEEKLY_DEMAND_PRODUCT_H
                        SELECT DISTINCT
		                               A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 
		                               --CASE WHEN A.SHOP_GROUP_ID = 'E' THEN 'E1'
		                               --     ELSE A.SHOP_GROUP_ID
		                               --END  
									   C.INSTANCE_TYPE  -- 2026/06/08   kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응.Instance Type으로 변경
									   AS SHOP_GROUP_ID, A.ITEM_ID, A.MFG_WEEK
		                             , A.LINE_ID, A.OPERATION_ID
                        FROM   FP_WEEKLY_DEMAND_PRODUCT_H A
                             , (
                                SELECT DIVISION_ID, SHOP_GROUP_ID, MAX(SCP_PLAN_ID) SCP_PLAN_ID
                                FROM   FP_WEEKLY_DEMAND_PRODUCT_H
                                GROUP  BY DIVISION_ID, SHOP_GROUP_ID
                               ) B
                             , (
                             	SELECT	  B.COMPANY_ID
										, B.DIVISION_ID
										, B.SITE_ID
										, B.PLANT_ID
										, CASE WHEN A.INSTANCE_ID = 'CN_FORM_T' THEN 'F' ELSE A.INSTANCE_TYPE END AS INSTANCE_TYPE
										, A.INSTANCE_ID  
										, MAX(D.WEEK) AS END_WEEK
								FROM	FP_INSTANCE_FACTORY_M A,
								   		SCM_FACTORY_M B  ,
										(SELECT SEGMENT1 , ATTRIBUTE13
										FROM [DBO].[SCM_SYS_LOOKUP_VALUE]
										WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID') C ,
										(SELECT A.*,
										DENSE_RANK() OVER (ORDER BY WEEK) AS SEQ
										FROM   SCM_SYS_CALENDAR_M A
										WHERE  DATE_ID >= CONVERT(DATE, GETDATE())
										)D
								WHERE  	A.FACTORY_ID = B.FACTORY_ID
								AND    		B.ACTIVE_FLAG = 'Y'
								AND	   		A.INSTANCE_ID = C.SEGMENT1 
								AND	   		C.ATTRIBUTE13 >= D.SEQ
								GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, A.INSTANCE_TYPE , A.INSTANCE_ID
                             	) C
                        WHERE  	A.DIVISION_ID    = B.DIVISION_ID
                        AND 	A.SHOP_GROUP_ID  = B.SHOP_GROUP_ID
                        AND    	A.SCP_PLAN_ID    = B.SCP_PLAN_ID
                        AND		A.COMPANY_ID = C.COMPANY_ID
                        AND		A.DIVISION_ID = C.DIVISION_ID
                        AND		A.SITE_ID =  C.SITE_ID
                        AND		A.PLANT_ID = C.PLANT_ID 
                        AND		CASE WHEN A.SHOP_GROUP_ID = 'E' THEN 'E1' ELSE A.SHOP_GROUP_ID END =  CASE WHEN C.INSTANCE_TYPE = 'L' THEN 'P' ELSE C.INSTANCE_TYPE END -- 2026/06/08   kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. Link 유형 Instance의 공정군은 P로 decode
                        AND    	A.MFG_WEEK  >= @v_start_week
						AND		A.MFG_WEEK	<= C.END_WEEK
						-- 2 FP_WEEKLY_DEMAND_PRODUCT_TEST_H
                        UNION  ALL
                        SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
								, CASE WHEN B.SHOP_GROUP_ID = 'E' THEN 'E1' ELSE B.SHOP_GROUP_ID END AS SHOP_GROUP_ID 
								, A.ITEM_ID, A.MFG_WEEK , A.LINE_ID, A.OPERATION_ID
						FROM   FP_WEEKLY_DEMAND_PRODUCT_TEST_H A,
							   (
								SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, CASE WHEN A.INSTANCE_ID = 'CN_FORM_T' THEN 'F' ELSE A.INSTANCE_TYPE END AS SHOP_GROUP_ID  -- 2026/06/08   kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응.Instance Type으로 변경
								FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK),   -- INSTANCE 별 FACTORY ID
									   SCM_FACTORY_M         B WITH(NOLOCK)    -- FACTORY 별 SITE ID
								WHERE  A.FACTORY_ID = B.FACTORY_ID
							   ) B ,
								(
								SELECT	  B.COMPANY_ID
										, B.DIVISION_ID
										, B.SITE_ID
										, B.PLANT_ID
										, CASE WHEN A.INSTANCE_ID = 'CN_FORM_T' THEN 'F' ELSE A.INSTANCE_TYPE END AS INSTANCE_TYPE
										, A.INSTANCE_ID  
										, MAX(D.WEEK) AS END_WEEK
								FROM   FP_INSTANCE_FACTORY_M A,
		   									SCM_FACTORY_M B  ,
											(SELECT SEGMENT1 , ATTRIBUTE13
											FROM [DBO].[SCM_SYS_LOOKUP_VALUE]
											WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID') C ,
											(SELECT A.*,
											DENSE_RANK() OVER (ORDER BY WEEK) AS SEQ
											FROM   SCM_SYS_CALENDAR_M A
											WHERE  DATE_ID >= CONVERT(DATE, GETDATE())
											)D
								WHERE  	A.FACTORY_ID = B.FACTORY_ID
								AND    		B.ACTIVE_FLAG = 'Y'
								AND	   		A.INSTANCE_ID = C.SEGMENT1 
								AND	   		C.ATTRIBUTE13 >= D.SEQ
								GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, A.INSTANCE_TYPE , A.INSTANCE_ID
								) C 
						WHERE  1=1
						AND    A.MFG_QTY > 0
						AND    A.COMPANY_ID     = B.COMPANY_ID
						AND    A.DIVISION_ID    = B.DIVISION_ID
						AND    A.SITE_ID        = B.SITE_ID
						AND    A.PLANT_ID       = B.PLANT_ID
						AND    A.MFG_WEEK      >= @v_start_week
						AND	   A.COMPANY_ID = C.COMPANY_ID
						AND	   A.DIVISION_ID  = C.DIVISION_ID
						AND	   A.SITE_ID = C.SITE_ID
						AND	   A.PLANT_ID = C.PLANT_ID
						AND		CASE WHEN B.SHOP_GROUP_ID = 'E' THEN 'E1' ELSE B.SHOP_GROUP_ID END =  C.INSTANCE_TYPE
						AND	   A.MFG_WEEK		<= C.END_WEEK
						-- 3 FP_WEEKLY_DEMAND_SHIPMENT_H
                        UNION  ALL
                        /*  CSR ID:3722380 
                            특성 출하타겟 validation 점검 data
                            SHIPMENT TARGET 현시점  특성만 사용하는것으로 보여 SHOP GROUP ID F로 지정
                        */
                        SELECT DISTINCT 
                               A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
                             , 'F' AS SHOP_GROUP_ID , A.ITEM_ID, A.SHIP_WEEK
                             , NULL LINE_ID, NULL OPERATION_ID
						FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A
							 , (
								SELECT DIVISION_ID, MAX(SCP_PLAN_ID) SCP_PLAN_ID
								FROM   FP_WEEKLY_DEMAND_SHIPMENT_H
								GROUP  BY DIVISION_ID
							   ) B 
							   ,(
 								SELECT  DISTINCT B.SITE_ID , B.DIVISION_ID , B.PLANT_ID
								FROM 	FP_INSTANCE_CONFIG_M A ,
        								(
										SELECT INSTANCE_ID , SITE_ID , DIVISION_ID , PLANT_ID  
										FROM FP_INSTANCE_LINE_V
										GROUP BY INSTANCE_ID , SITE_ID , DIVISION_ID , PLANT_ID  
        								) B
								 WHERE A.CATEGORY_ID = 'DEMAND_TARGET'    
								 AND   A.KEY_VALUE = 'SHIPMENT'
								 AND   A.USE_YN = 'Y'
      							 AND		A.INSTANCE_ID =  B.INSTANCE_ID 
     							 AND		A.KEY_ID = B.DIVISION_ID 
							   )C
							   ,(
								SELECT	  B.COMPANY_ID
										, B.DIVISION_ID
										, B.SITE_ID
										, B.PLANT_ID
										, CASE WHEN A.INSTANCE_ID = 'CN_FORM_T' THEN 'F' ELSE A.INSTANCE_TYPE END AS INSTANCE_TYPE
										, A.INSTANCE_ID  
										, MAX(D.WEEK) AS END_WEEK
								FROM   FP_INSTANCE_FACTORY_M A,
			   							SCM_FACTORY_M B  ,
										(SELECT SEGMENT1 , ATTRIBUTE13
										FROM [DBO].[SCM_SYS_LOOKUP_VALUE]
										WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID') C ,
										(SELECT A.*,
										DENSE_RANK() OVER (ORDER BY WEEK) AS SEQ
										FROM   SCM_SYS_CALENDAR_M A
										WHERE  DATE_ID >= CONVERT(DATE, GETDATE())
										)D
								WHERE  	A.FACTORY_ID = B.FACTORY_ID
								AND    	B.ACTIVE_FLAG = 'Y'
								AND	   	A.INSTANCE_ID = C.SEGMENT1 
								AND	   	C.ATTRIBUTE13 >= D.SEQ
								GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, A.INSTANCE_TYPE , A.INSTANCE_ID
							   )D
						WHERE  A.DIVISION_ID = B.DIVISION_ID
						AND    	A.SCP_PLAN_ID = B.SCP_PLAN_ID
						AND    	A.SHOP_GROUP_ID = 'A' 
						AND	   	A.SITE_ID = C.SITE_ID
						AND 	 	A.DIVISION_ID = C.DIVISION_ID
						AND 	 	A.PLANT_ID = C.PLANT_ID                
						AND		A.SHIP_WEEK >=  @v_start_week
						AND		A.COMPANY_ID = D.COMPANY_ID
						AND		A.DIVISION_ID = D.DIVISION_ID
						AND		A.SITE_ID = D.SITE_ID
						AND		A.PLANT_ID = D.PLANT_ID
						AND		A.SHIP_WEEK <=  D.END_WEEK
						AND		D.INSTANCE_TYPE = 'F'
						UNION ALL
                        -- 출하요청 
						 SELECT DISTINCT 
                               A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
                             , 'F' AS SHOP_GROUP_ID , A.ITEM_ID, A.SHIP_WEEK
                             , NULL LINE_ID, NULL OPERATION_ID
						FROM   SCM_SCP_SHIPMENT_REQ_V A
							   ,(
 								SELECT  DISTINCT B.SITE_ID , B.DIVISION_ID , B.PLANT_ID
								FROM 	FP_INSTANCE_CONFIG_M A ,
        								(
										SELECT INSTANCE_ID , SITE_ID , DIVISION_ID , PLANT_ID  
										FROM FP_INSTANCE_LINE_V
										GROUP BY INSTANCE_ID , SITE_ID , DIVISION_ID , PLANT_ID  
        								) B
								 WHERE A.CATEGORY_ID = 'DEMAND_TARGET'    
								 AND   A.KEY_VALUE = 'SHIPMENT_REQUEST'
								 AND   A.USE_YN = 'Y'
      							 AND		A.INSTANCE_ID =  B.INSTANCE_ID 
     							 AND		A.KEY_ID = B.DIVISION_ID 
							   )C
							   ,(
								SELECT	  B.COMPANY_ID
										, B.DIVISION_ID
										, B.SITE_ID
										, B.PLANT_ID
										, CASE WHEN A.INSTANCE_ID = 'CN_FORM_T' THEN 'F' ELSE A.INSTANCE_TYPE END AS INSTANCE_TYPE
										, A.INSTANCE_ID  
										, MAX(D.WEEK) AS END_WEEK
								FROM   FP_INSTANCE_FACTORY_M A,
			   								SCM_FACTORY_M B  ,
											(SELECT SEGMENT1 , ATTRIBUTE13
											FROM [DBO].[SCM_SYS_LOOKUP_VALUE]
											WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID') C ,
											(SELECT A.*,
					       									DENSE_RANK() OVER (ORDER BY WEEK) AS SEQ
												FROM   SCM_SYS_CALENDAR_M A
												WHERE  DATE_ID >= CONVERT(DATE, GETDATE())
											)D
								WHERE  	A.FACTORY_ID = B.FACTORY_ID
								AND    		B.ACTIVE_FLAG = 'Y'
								AND	   		A.INSTANCE_ID = C.SEGMENT1 
								AND	   		C.ATTRIBUTE13 >= D.SEQ
								GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, A.INSTANCE_TYPE , A.INSTANCE_ID
							   )D
						WHERE	A.SHOP_GROUP_ID = 'A' 
						AND	   	A.SITE_ID = C.SITE_ID
						AND 	A.DIVISION_ID = C.DIVISION_ID
						AND 	A.PLANT_ID = C.PLANT_ID                
						AND		A.SHIP_WEEK >=  @v_start_week
						AND		A.COMPANY_ID = D.COMPANY_ID
						AND		A.DIVISION_ID = D.DIVISION_ID
						AND		A.SITE_ID = D.SITE_ID
						AND		A.PLANT_ID = D.PLANT_ID
						AND		A.SHIP_WEEK <=  D.END_WEEK
						AND		D.INSTANCE_TYPE = 'F'
						UNION  ALL
						SELECT DISTINCT
								A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
								, 'F' AS  SHOP_GROUP_ID , A.CELL_ITEM_ID AS ITEM_ID, F.WEEK
								, NULL LINE_ID, NULL OPERATION_ID
						FROM   FP_DEMAND_PACK_REQUIRE_FIX A,
							   (
								SELECT  COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , MAX(PLAN_ID) AS PLAN_ID  
								FROM FP_DEMAND_PACK_REQUIRE_FIX
								GROUP BY COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID
								) B  ,
							   (
								SELECT  DISTINCT B.SITE_ID , B.DIVISION_ID , B.PLANT_ID
								FROM	FP_INSTANCE_CONFIG_M A ,
										(
										SELECT INSTANCE_ID , SITE_ID , DIVISION_ID , PLANT_ID  
										FROM FP_INSTANCE_LINE_V
										GROUP BY INSTANCE_ID , SITE_ID , DIVISION_ID , PLANT_ID  
										) B
								WHERE	A.CATEGORY_ID = 'DEMAND_TARGET'    
								AND		A.KEY_VALUE = 'PACK_REQUIRE'
								AND		A.USE_YN = 'Y'
								AND		A.INSTANCE_ID =  B.INSTANCE_ID 
								AND		A.KEY_ID = B.DIVISION_ID 
								)E
							  , SCM_SYS_CALENDAR_M F
							  , (
								SELECT	  B.COMPANY_ID
										, B.DIVISION_ID
										, B.SITE_ID
										, B.PLANT_ID
										, CASE WHEN A.INSTANCE_ID = 'CN_FORM_T' THEN 'F' ELSE A.INSTANCE_TYPE END AS INSTANCE_TYPE
										, A.INSTANCE_ID  
										, MAX(D.WEEK) AS END_WEEK
								FROM   FP_INSTANCE_FACTORY_M A,
		   									SCM_FACTORY_M B  ,
											(SELECT SEGMENT1 , ATTRIBUTE13
											FROM [DBO].[SCM_SYS_LOOKUP_VALUE]
											WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID') C ,
											(SELECT A.*,
				       										DENSE_RANK() OVER (ORDER BY WEEK) AS SEQ
											 FROM   SCM_SYS_CALENDAR_M A
											 WHERE  DATE_ID >= CONVERT(DATE, GETDATE())
											)D
								WHERE  	A.FACTORY_ID = B.FACTORY_ID
								AND    		B.ACTIVE_FLAG = 'Y'
								AND	   		A.INSTANCE_ID = C.SEGMENT1 
								AND	   		C.ATTRIBUTE13 >= D.SEQ
								GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, A.INSTANCE_TYPE , A.INSTANCE_ID
								)G
						WHERE  1=1
						AND    A.COMPANY_ID   = B.COMPANY_ID
						AND    A.DIVISION_ID  = B.DIVISION_ID
						AND    A.SITE_ID      = B.SITE_ID
						AND 	   A.PLANT_ID = B.PLANT_ID
						AND    A.PLAN_ID = B.PLAN_ID
						AND	   A.SITE_ID = E.SITE_ID
						AND	   A.DIVISION_ID = E.DIVISION_ID
						AND    A.PLANT_ID = E.PLANT_ID
						AND    A.REQUIRE_DATE = F.DATE_ID
						AND    F.WEEK >= @v_start_week 
						AND	   A.COMPANY_ID = G.COMPANY_ID
						AND	   A.DIVISION_ID = G.DIVISION_ID
						AND	   A.SITE_ID = G.SITE_ID
						AND	   A.PLANT_ID = G.PLANT_ID
						AND	   G.INSTANCE_TYPE = 'F'
						AND	   F.WEEK <= G.END_WEEK
                       ) A
               ) A
               INNER JOIN (
                            SELECT DISTINCT
                                   B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, 
                                   CASE WHEN A.INSTANCE_ID = 'CN_FORM_T' THEN 'F' ELSE A.INSTANCE_TYPE END AS INSTANCE_TYPE, A.INSTANCE_ID 
                            FROM   FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
                                   SCM_FACTORY_M B            -- FACTORY 별 SITE ID
                            WHERE  A.FACTORY_ID = B.FACTORY_ID
                            AND    B.ACTIVE_FLAG = 'Y'
                           ) F
                     ON    A.COMPANY_ID = F.COMPANY_ID
                     AND   A.DIVISION_ID = F.DIVISION_ID
                     AND   A.SITE_ID = F.SITE_ID
                     AND   A.PLANT_ID = F.PLANT_ID
                     AND   A.SHOP_GROUP_ID =  F.INSTANCE_TYPE
               INNER JOIN (
                            SELECT WEEK, YEAR + MONTH AS MFG_MONTH
                            FROM   SCM_SYS_CALENDAR_M
                            GROUP  BY WEEK, YEAR + MONTH
                     ) G
                     ON    A.MFG_WEEK = G.WEEK
        WHERE  1=1
        ORDER  BY 
               A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
             , A.SHOP_GROUP_ID, F.INSTANCE_ID

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_message = 'TARGET ITEM (WEEKLY) : ' + CONVERT(nvarchar, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        -- DAILY_PLAN Target ( 선분산 )
        INSERT INTO TH_BUF_MASTER_VALIDATION_TARGET
             (
               COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , SHOP_GROUP_ID
             , INSTANCE_ID
             , ITEM_ID
             , MFG_MONTH
             , MFG_WEEK
             )
        SELECT COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , SHOP_GROUP_ID
             , INSTANCE_ID
             , ITEM_ID
             , MFG_MONTH
             , MFG_WEEK
        FROM   (
                SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 
						CASE WHEN CHARINDEX('PACK',   A.INSTANCE_ID) > 0 THEN 'P'
						    WHEN CHARINDEX('LINK',   A.INSTANCE_ID) > 0 THEN 'L'  -- 2026/06/08 kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. LINK Instance 유형 추가
							WHEN CHARINDEX('CELL',   A.INSTANCE_ID) > 0 THEN 'A'
							WHEN CHARINDEX('FORM',   A.INSTANCE_ID) > 0 THEN 'F'
							WHEN CHARINDEX('E_PRE',  A.INSTANCE_ID) > 0 THEN 'E1'
							WHEN CHARINDEX('E_POST', A.INSTANCE_ID) > 0 THEN 'E2'
							WHEN CHARINDEX('E_PMIX', A.INSTANCE_ID) > 0 THEN 'E3'
																		ELSE 'E1'
						END  AS SHOP_GROUP_ID, A.INSTANCE_ID, A.ITEM_ID
						, E.YEAR + E.MONTH  AS MFG_MONTH
						, E.WEEK            AS MFG_WEEK
                FROM   FP_DAILY_INSTANCE_DEMAND_H A
                     , FP_INSTANCE_CONFIG_M       C
                     , SCM_ITEM_M                 D
                     , SCM_SYS_CALENDAR_M         E
                     ,  (
						SELECT	  B.COMPANY_ID
								, B.DIVISION_ID
								, B.SITE_ID
								, B.PLANT_ID
								, CASE WHEN A.INSTANCE_ID = 'CN_FORM_T' THEN 'F' ELSE A.INSTANCE_TYPE END AS INSTANCE_TYPE
								, A.INSTANCE_ID  
								, MAX(D.WEEK) AS END_WEEK
						FROM   FP_INSTANCE_FACTORY_M A,
						   			SCM_FACTORY_M B  ,
									(SELECT SEGMENT1 , ATTRIBUTE13
									FROM [DBO].[SCM_SYS_LOOKUP_VALUE]
									WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID') C ,
								    (SELECT A.*,
								       				DENSE_RANK() OVER (ORDER BY WEEK) AS SEQ
									 FROM   SCM_SYS_CALENDAR_M A
									 WHERE  DATE_ID >= CONVERT(DATE, GETDATE())
								    )D
						WHERE  	A.FACTORY_ID = B.FACTORY_ID
						AND    		B.ACTIVE_FLAG = 'Y'
						AND	   		A.INSTANCE_ID = C.SEGMENT1 
						AND	   		C.ATTRIBUTE13 >= D.SEQ
						GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, A.INSTANCE_TYPE , A.INSTANCE_ID
					   )F
                WHERE  1=1
                AND    C.CATEGORY_ID  = 'DEMAND_TARGET'    
                AND    C.KEY_VALUE    = 'DAILY_PLAN'
                AND    C.KEY_ID       = A.DIVISION_ID
                AND    A.COMPANY_ID   = D.COMPANY_ID
                AND    A.DIVISION_ID  = D.DIVISION_ID
                AND    A.SITE_ID      = D.SITE_ID
                AND    A.ITEM_ID      = D.ITEM_ID
                AND    CONVERT(DATE, A.DUE_DATE)  = E.DATE_ID
                AND    CONVERT(DATE, A.DUE_DATE) >= CONVERT(DATE, GETDATE())
                AND	   A.COMPANY_ID =  F.COMPANY_ID
                AND    A.DIVISION_ID = F.DIVISION_ID
                AND	   A.SITE_ID = F.SITE_ID 
                AND    A.PLANT_ID = F.PLANT_ID
                AND    CASE WHEN CHARINDEX('PACK',   A.INSTANCE_ID) > 0 THEN 'P'
				            WHEN CHARINDEX('LINK',   A.INSTANCE_ID) > 0 THEN 'L'  -- 2026/06/08 kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. LINK Instance 유형 추가
			                WHEN CHARINDEX('CELL',   A.INSTANCE_ID) > 0 THEN 'A'
			                WHEN CHARINDEX('FORM',   A.INSTANCE_ID) > 0 THEN 'F'
			             WHEN CHARINDEX('E_PRE',  A.INSTANCE_ID) > 0 THEN 'E1'
			                WHEN CHARINDEX('E_POST', A.INSTANCE_ID) > 0 THEN 'E2'
			                WHEN CHARINDEX('E_PMIX', A.INSTANCE_ID) > 0 THEN 'E3'
			                                                            ELSE 'E1'
						END 	=  F.INSTANCE_TYPE
                AND	   E.WEEK  <= F.END_WEEK	     	  
                -- RELEASE 된 버전을 가지고 올때,,, INSTANCE 분리 후
                AND    EXISTS (
                                SELECT 1
                                FROM   (
                                        SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.DIVISION_ID, A.FACTORY_ID
                                             , MAX(AMEND_PLAN_ID) AS AMEND_PLAN_ID
                                        FROM   FP_RELEASE_PLAN_INFO_H A,
                                               (
                                                SELECT A.INSTANCE_ID
                                                     , A.DIVISION_ID
                                                     , A.FACTORY_ID
                                                     , MAX(A.INSTANCE_DATE) AS INSTANCE_DATE
                                                FROM   FP_RELEASE_PLAN_INFO_H  A
                                                     , SCM_FACTORY_M           B
                                                WHERE  A.INSTANCE_DATE <= GETDATE()      -- 당일 이전 RELEASE 꺼,, 먼저 한 동은 그걸 끌고 오기 때문
                                                AND    A.FACTORY_ID   = B.FACTORY_ID
                                                AND    B.ACTIVE_FLAG  = 'Y'
                                                GROUP  BY A.INSTANCE_ID, A.DIVISION_ID, A.FACTORY_ID
                                               ) B
                                        WHERE  A.INSTANCE_ID    = B.INSTANCE_ID
                                        AND    A.INSTANCE_DATE  = B.INSTANCE_DATE
                                        AND    A.DIVISION_ID    = B.DIVISION_ID
                                        AND    A.FACTORY_ID     = B.FACTORY_ID
                                        GROUP  BY A.INSTANCE_ID, A.INSTANCE_DATE, A.DIVISION_ID, A.FACTORY_ID
                                       ) X
                                WHERE  A.SCP_PLAN_ID  = X.AMEND_PLAN_ID
                                AND    A.CUSTOMER_ID  = X.FACTORY_ID        -- INSTANCE DEMAND
                              )
                GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.INSTANCE_ID, A.ITEM_ID
                        , E.YEAR + E.MONTH, E.WEEK
               ) A
        WHERE  1=1
        AND    NOT EXISTS (
                            SELECT 1
                            FROM   TH_BUF_MASTER_VALIDATION_TARGET X
                            WHERE  X.COMPANY_ID     = A.COMPANY_ID
                            AND    X.DIVISION_ID    = A.DIVISION_ID
                            AND    X.SITE_ID        = A.SITE_ID
                            AND    X.PLANT_ID       = A.PLANT_ID
                            AND    X.SHOP_GROUP_ID  = A.SHOP_GROUP_ID
                            AND    X.INSTANCE_ID    = A.INSTANCE_ID
                            AND    X.ITEM_ID        = A.ITEM_ID
                            AND    X.MFG_MONTH      = A.MFG_MONTH
                            AND    X.MFG_WEEK       = A.MFG_WEEK
                          )

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_message = 'TARGET ITEM (DAILY_PLAN) : ' + CONVERT(nvarchar, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


        UPDATE A
        SET    A.FACTORY_ID     = ISNULL(B.FACTORY_ID, C.FACTORY_ID)
             , A.PLAN_GROUP_ID  = ISNULL(B.MODEL_TYPE, C.MODEL_TYPE)
        FROM   TH_BUF_MASTER_VALIDATION_TARGET A
               LEFT OUTER JOIN SCM_LINE_M B
                    ON    A.COMPANY_ID    = B.COMPANY_ID
                    AND   A.DIVISION_ID   = B.DIVISION_ID
                    AND   A.SITE_ID       = B.SITE_ID
          AND   A.PLANT_ID      = B.PLANT_ID
                    AND   A.LINE_ID       = B.SCP_LINE_ID
               LEFT OUTER JOIN SCM_LINE_M C
                    ON    A.COMPANY_ID    = C.COMPANY_ID
                    AND   A.DIVISION_ID   = C.DIVISION_ID
                    AND   A.SITE_ID       = C.SITE_ID
                    AND   A.PLANT_ID      = C.PLANT_ID
                    AND   A.LINE_ID       = C.LINE_ID
                    AND   A.OPERATION_ID  = C.OPERATION_ID

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_message = 'FACTORY_ID : ' + CONVERT(nvarchar, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        UPDATE A
        SET    A.RELEASE_WEEK_FLAG = CASE WHEN A.MFG_WEEK <= B.WEEK THEN 'Y' ELSE 'N' END
        FROM   (
                SELECT A.*
                     , DATEADD(DAY, CONVERT(INTEGER, ISNULL(B.SEGMENT3, ISNULL(C.SEGMENT3, ISNULL(D.SEGMENT3, 7)))) + 1
                                  , CONVERT(DATE, GETDATE())) AS RELEASE_DATE
                FROM   TH_BUF_MASTER_VALIDATION_TARGET A
                       LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE B                               -- PLAN_GROUP_ID
                            ON    B.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
                            AND   B.SEGMENT1          = A.INSTANCE_ID
                            AND   B.SEGMENT2          = A.PLAN_GROUP_ID
                       LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C
                            ON    C.LOOKUP_TYPE_CODE  = 'INSTANCE_FACTORY_RELEASE_TERM'     -- FACTORY_ID
                            AND   C.SEGMENT1          = A.INSTANCE_ID
                            AND   C.SEGMENT2          = A.FACTORY_ID
                       LEFT OUTER JOIN (                                                    -- INSTANCE_ID
                                        SELECT SEGMENT1, MAX(SEGMENT3) AS SEGMENT3
                                        FROM   SCM_SYS_LOOKUP_VALUE 
                                        WHERE  LOOKUP_TYPE_CODE  = 'INSTANCE_FACTORY_RELEASE_TERM'
                                        GROUP  BY SEGMENT1
                                       ) D 
                            ON    D.SEGMENT1          = A.INSTANCE_ID
               ) A
             , SCM_SYS_CALENDAR_M B
        WHERE  A.RELEASE_DATE = B.DATE_ID
        
        --LOG 생성
        SET @v_message = 'RELEASE_WEEK_FLAG : ' + CONVERT(nvarchar, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END

      BEGIN

        BEGIN
        
          SET @v_table_name = 'TH_BUF_MASTER_VALIDATION_RESULT'

          DELETE TH_BUF_MASTER_VALIDATION_RESULT
          /*
           1.ITEM
           1-1 ITEM - TARGET
           1-2 ITEM - BOM - 전개
          */
          
          INSERT INTO TH_BUF_MASTER_VALIDATION_RESULT
              (
                COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , PLAN_DATE
              , VALIDATION_SEQ
              , INSTANCE_ID
              , TOP_ITEM_ID
              , CHECK_SEQ
              , CHECK_CATEGORY
              , CHECK_TABLE
              , PROBLEM_TYPE
              , CHECK_DATA
              , PROBLEM_SEQ
              , PROBLEM_DATA
              , PROBLEM_LIST
              , REFERENCE_TABLE
              , CHECK_UI
           , PROBLEM_DESCRIPTION
              , INSERT_ID
              , INSERT_TIME
              )                                
          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PLAN_DATE,
                 @validation_seq + ROW_NUMBER() OVER (ORDER BY SEQ) AS VALIDATION_SEQ,
                 A.INSTANCE_ID,
                 A.TOP_ITEM_ID, A.CHECK_SEQ, A.CHECK_CATEGORY, A.CHECK_TABLE, A.PROBLEM_TYPE,
                 A.CHECK_DATA, A.PROBLEM_SEQ, A.PROBLEM_DATA, A.PROBLEM_LIST, 
                 A.REFERENCE_TABLE, A.CHECK_UI, A.PROBLEM_DESCRIPTION
               , @v_proc_name AS INSERT_ID
               , @sysdate AS INSERT_TIME
          FROM   (
                  SELECT DISTINCT
                         A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,
                         @plan_date AS PLAN_DATE,
                         A.INSTANCE_ID,
                         A.ITEM_ID AS TOP_ITEM_ID,
                         2 AS CHECK_SEQ,
                         A.CHECK_CATEGORY, A.CHECK_TABLE, A.PROBLEM_TYPE,
                         'ITEM' AS CHECK_DATA,
                         1 AS PROBLEM_SEQ,
                         A.ITEM_ID AS PROBLEM_DATA,
                         A.PROBLEM_LIST,
                         CASE WHEN REASON_DATA IS NOT NULL THEN 'SCM_ITEM_M'
                              ELSE 'SCM_ITEM_CLASS_M'
                         END  REFERENCE_TABLE,
                         CASE WHEN REASON_DATA IS NOT NULL THEN 'ITEM'
                         END  CHECK_UI,
                         CASE WHEN REASON_DATA IS NOT NULL THEN REASON_DATA
                         END  PROBLEM_DESCRIPTION,
                         0 AS SEQ
                  FROM   (
                          SELECT DISTINCT A.*, B.ITEM_CLASS,
                                 CASE WHEN B.ITEM_ID  IS NULL    THEN 'Please check expand the Item.' --N'Item : ' + A.ITEM_ID+N'- Please check expand the Item'
                                 			WHEN C.CLASS_ID IS NULL    THEN 'Please check expand the Item.' --N'Item : ' + A.ITEM_ID+N'- Please check expand the Item'
                                 			WHEN B.FLOW_ID    IS NULL  THEN 'Please check MMD Route ID.'  --N'Item : ' + A.ITEM_ID+N'- Please check MMD Route ID.'
                                      WHEN B.FLOW_ID    = ''     THEN 'Please check MMD Route ID.'  --N'Item : ' + A.ITEM_ID+N'- Please check MMD Route ID.'
                                      WHEN (B.ITEM_TYPE IS NULL OR B.ITEM_TYPE = '' OR B.ITEM_TYPE ='Q' ) THEN 'Please check Item Type.'
                                 END  REASON_DATA
                          FROM   (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID
                                       , INSTANCE_ID, ITEM_ID, CHECK_CATEGORY, CHECK_TABLE, PROBLEM_TYPE
                                       , MIN(PROBLEM_LIST) AS PROBLEM_LIST
                                  FROM   TH_BUF_SCM_VALIDATION_TARGET
                                  GROUP  BY 
                                         COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID
                                       , INSTANCE_ID, ITEM_ID, CHECK_CATEGORY, CHECK_TABLE, PROBLEM_TYPE
                                 ) A
                                 LEFT OUTER JOIN SCM_ITEM_M B
                                      ON   A.ITEM_ID = B.ITEM_ID
                                      AND  A.COMPANY_ID = B.COMPANY_ID
                                      AND  A.DIVISION_ID = B.DIVISION_ID
                                      AND  A.SITE_ID = B.SITE_ID
                                 LEFT OUTER JOIN SCM_ITEM_CLASS_M C
                         				ON   B.ITEM_CLASS = C.CLASS_ID      
                          WHERE  NOT EXISTS (
                                             SELECT 1
                                             FROM   TH_BUF_MASTER_VALIDATION_RESULT X
                   WHERE  PLAN_DATE = @plan_date
                                             AND    X.COMPANY_ID    = A.COMPANY_ID
                                             AND    X.DIVISION_ID   = A.DIVISION_ID
                                             AND    X.SITE_ID       = A.SITE_ID
                                             AND    X.PLANT_ID      = A.PLANT_ID
                                             AND    X.PROBLEM_DATA  = A.ITEM_ID
                                             AND    X.CHECK_TABLE   = A.CHECK_TABLE
                                            )                     
                         ) A  
                 ) A    
          WHERE  PROBLEM_DESCRIPTION IS NOT NULL
          
          SET @n_row_count = @@ROWCOUNT
        
          SET @validation_seq += @n_row_count
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
          /*
            BOM
          */       
          
          INSERT INTO TH_BUF_MASTER_VALIDATION_RESULT
              (
                COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , PLAN_DATE
              , VALIDATION_SEQ
              , INSTANCE_ID
              , TOP_ITEM_ID
              , CHECK_SEQ
              , CHECK_CATEGORY
              , CHECK_TABLE
              , PROBLEM_TYPE
              , CHECK_DATA
              , PROBLEM_SEQ
              , PROBLEM_DATA
              , PROBLEM_LIST
              , REFERENCE_TABLE
              , CHECK_UI
              , PROBLEM_DESCRIPTION
              , INSERT_ID
              , INSERT_TIME
              )
          SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PLAN_DATE,
                @validation_seq + ROW_NUMBER() OVER (ORDER BY SEQ) AS VALIDATION_SEQ,
                A.INSTANCE_ID,
                A.TOP_ITEM_ID, A.CHECK_SEQ, A.CHECK_CATEGORY, A.CHECK_TABLE, A.PROBLEM_TYPE,
                A.CHECK_DATA, A.PROBLEM_SEQ, A.PROBLEM_DATA, A.PROBLEM_LIST, 
                A.REFERENCE_TABLE, A.CHECK_UI, A.PROBLEM_DESCRIPTION
              , @v_proc_name AS INSERT_ID
              , @sysdate AS INSERT_TIME
          FROM   (
                  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,
                         @plan_date AS PLAN_DATE,
                         A.INSTANCE_ID,
                         A.ITEM_ID AS TOP_ITEM_ID,
                         3 AS CHECK_SEQ,
                         A.CHECK_CATEGORY, A.CHECK_TABLE, A.PROBLEM_TYPE,
                         'BOM' AS CHECK_DATA,
                         1 AS PROBLEM_SEQ,
                         A.ITEM_ID AS PROBLEM_DATA,
                         A.PROBLEM_LIST,
                         CASE WHEN REASON_DATA IS NOT NULL THEN 'SCM_BOM_M'
                              ELSE NULL
                         END  REFERENCE_TABLE,
                         CASE WHEN REASON_DATA IS NOT NULL THEN 'BOM'
                              ELSE NULL
                         END  CHECK_UI,
                         CASE WHEN REASON_DATA IS NOT NULL THEN REASON_DATA
                              ELSE NULL
                         END  PROBLEM_DESCRIPTION,
                         0 AS SEQ
                  FROM   (
                          SELECT DISTINCT A.*, 
                                 CASE WHEN B.PARENT_ITEM_ID IS NULL THEN 'Please check expand the Item.' -- A.ITEM_ID+N'Please check expand the Item.'
                                      WHEN C.PARENT_ITEM_ID IS NULL THEN 'Please check effective date the BOM.' --A.ITEM_ID+N'Please check effective date the BOM' 
                                 END  REASON_DATA , 
     CASE WHEN B.PARENT_ITEM_ID IS NULL THEN 'Expand' -- A.ITEM_ID+N'Please check expand the Item.'
                                      WHEN C.PARENT_ITEM_ID IS NULL THEN 'Valid Date' --A.ITEM_ID+N'Please check effective date the BOM' 
                                 END  PROBLEM_TYPE
                          FROM   (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID
                                       , INSTANCE_ID, ITEM_ID, CHECK_CATEGORY, CHECK_TABLE, PROBLEM_TYPE AS PROBLEM_TYPE_A
                                       , MIN(PROBLEM_LIST) AS PROBLEM_LIST
                                  FROM   TH_BUF_SCM_VALIDATION_TARGET
                                  GROUP  BY 
                                         COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID
                                       , INSTANCE_ID, ITEM_ID, CHECK_CATEGORY, CHECK_TABLE , PROBLEM_TYPE
                                 ) A
                                 LEFT OUTER JOIN SCM_BOM_M B
                                      ON    A.COMPANY_ID = B.COMPANY_ID
                                      AND   A.DIVISION_ID = B.DIVISION_ID
                                      AND   A.SITE_ID = B.SITE_ID
                                      AND   A.PLANT_ID = B.PLANT_ID
                                      AND   A.ITEM_ID = B.PARENT_ITEM_ID
                                 LEFT OUTER JOIN (
                                                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID,
                                                         MAX(KEY_DATE) AS KEY_DATE
                                                  FROM   SCM_BOM_M A,
                                                         SCM_ITEM_M B,
                                                         SCM_ITEM_CLASS_M C  
                                                  WHERE  1=1
                                                  AND    A.ACTIVE_FLAG    = 'Y'
                                                  AND    A.COMPANY_ID     = B.COMPANY_ID
                                                  AND    A.DIVISION_ID    = B.DIVISION_ID
                                                  AND    A.SITE_ID        = B.SITE_ID
                                                  AND    A.CHILD_ITEM_ID  = B.ITEM_ID  
                                                  AND    B.ACTIVE_FLAG    = 'Y'
                                                  AND    B.ITEM_CLASS     = C.CLASS_ID  
                                                  AND    C.USE_FLAG       = 'Y'                                
                                                  AND    A.EFF_END_DATE  >= CONVERT(DATE, GETDATE())
                                                  GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                                                 ) C
                                      ON    A.COMPANY_ID = C.COMPANY_ID
                                      AND   A.DIVISION_ID = C.DIVISION_ID
                                      AND   A.SITE_ID = C.SITE_ID
                                      AND   A.PLANT_ID = C.PLANT_ID
                                      AND   A.ITEM_ID = C.PARENT_ITEM_ID
                          WHERE  NOT EXISTS (
                                             SELECT 1
                                             FROM   TH_BUF_MASTER_VALIDATION_RESULT X
                                             WHERE  PLAN_DATE       = @plan_date
                                             AND    X.COMPANY_ID    = A.COMPANY_ID
                                             AND    X.DIVISION_ID   = A.DIVISION_ID
                                             AND    X.SITE_ID       = A.SITE_ID
                                             AND    X.PLANT_ID      = A.PLANT_ID
      AND    X.PROBLEM_DATA  = A.ITEM_ID
                                             AND    X.CHECK_TABLE  = A.CHECK_TABLE
                                            )
                         ) A
                    ) A
          WHERE  PROBLEM_DESCRIPTION IS NOT NULL 
          
          SET @n_row_count = @@ROWCOUNT
        
          SET @validation_seq += @n_row_count
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
          BEGIN
          
            SET @v_table_name = 'TH_BUF_SCM_VALIDATION_CHECK_LIST'
        
            DELETE FROM TH_BUF_SCM_VALIDATION_CHECK_LIST
            
            INSERT INTO TH_BUF_SCM_VALIDATION_CHECK_LIST
                  (
                   COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, INSTANCE_ID, ITEM_ID, BOM_LEVEL, 
                   PARENT_ITEM_ID, PARENT_ITEM_TYPE, PARENT_FLOW_ID,
                   CHILD_ITEM_ID,  CHILD_ITEM_TYPE,  CHILD_FLOW_ID,
                   ALT_ID, ALT_PRIORITY, KEY_DATE,
                   ITEM_CLASS, ITEM_ACTIVE_FLAG, CLASS_ID, USE_FLAG
                  )
            SELECT DISTINCT
                   A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.ITEM_ID, 
                   A.BOM_LEVEL, 
                   A.PARENT_ITEM_ID, B.ITEM_TYPE AS PARENT_ITEM_TYPE, 
                   CASE WHEN  CHARINDEX('FORM',A.INSTANCE_ID) > 0 THEN B.FORMATION_FLOW_ID  ELSE B.FLOW_ID    END AS PARENT_FLOW_ID, 
                   A.CHILD_ITEM_ID,
                   CASE WHEN  CHARINDEX('FORM',A.INSTANCE_ID) > 0 THEN 'R'                  ELSE C.ITEM_TYPE  END AS CHILD_ITEM_TYPE,
                   CASE WHEN  CHARINDEX('FORM',A.INSTANCE_ID) > 0 THEN  NULL                ELSE C.FLOW_ID    END AS CHILD_FLOW_ID,
                   A.ALT_ID, A.ALT_PRIORITY, A.KEY_DATE,
                   A.ITEM_CLASS, A.ITEM_ACTIVE_FLAG, A.CLASS_ID, A.USE_FLAG
            FROM   (
                    SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID,
                           A.ITEM_ID,
                           1 AS BOM_LEVEL , B.PARENT_ITEM_ID, B.CHILD_ITEM_ID, B.ALT_ID, B.ALT_PRIORITY, B.KEY_DATE,
                           B.ITEM_CLASS, B.ITEM_ACTIVE_FLAG, B.CLASS_ID, B.USE_FLAG
                    FROM   (
                            SELECT DISTINCT
                                   A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID,
                                   A.ITEM_ID
                            FROM   TH_BUF_MASTER_VALIDATION_TARGET A             
                            WHERE  NOT EXISTS (
                                               SELECT 1
                                               FROM   TH_BUF_MASTER_VALIDATION_RESULT X
                                               WHERE  X.COMPANY_ID    = A.COMPANY_ID
                                               AND    X.DIVISION_ID   = A.DIVISION_ID
                                               AND    X.SITE_ID       = A.SITE_ID
                                               AND    X.PLANT_ID      = A.PLANT_ID
                                               AND    X.PROBLEM_DATA  = A.ITEM_ID
                                              )
                           ) A
                           LEFT OUTER JOIN TH_BUF_SCM_VALIDATION_BOM B
                                ON     A.COMPANY_ID = B.COMPANY_ID
                                AND    A.DIVISION_ID = B.DIVISION_ID
                                AND    A.SITE_ID = B.SITE_ID
                                AND    A.PLANT_ID = B.PLANT_ID
                                AND    A.ITEM_ID = B.PARENT_ITEM_ID
           ) A
                   LEFT OUTER JOIN SCM_ITEM_M B
                        ON    A.COMPANY_ID = B.COMPANY_ID
                        AND   A.DIVISION_ID = B.DIVISION_ID
                        AND   A.SITE_ID = B.SITE_ID
                        AND   A.PARENT_ITEM_ID = B.ITEM_ID
                        AND   B.ACTIVE_FLAG = 'Y'
                   LEFT OUTER JOIN SCM_ITEM_M C
                        ON    A.COMPANY_ID = C.COMPANY_ID
                        AND   A.DIVISION_ID = C.DIVISION_ID
                        AND   A.SITE_ID = C.SITE_ID
                        AND   A.CHILD_ITEM_ID = C.ITEM_ID
                        AND   C.ACTIVE_FLAG = 'Y'  
                   INNER JOIN FP_INSTANCE_OPERATION_V D
                        ON    A.INSTANCE_ID = D.INSTANCE_ID
                        AND   CASE WHEN  CHARINDEX('FORM',A.INSTANCE_ID) > 0 THEN B.FORMATION_FLOW_ID  ELSE B.FLOW_ID END LIKE '%'+D.OPERATION_ID +'%'
                  --WHERE CONVERT(nvarchar,A.KEY_DATE,112) >= CONVERT(nvarchar, GETDATE(), 112)      

            SET @n_row_count = @@ROWCOUNT
                  
            --LOG 생성
            SET @v_message = 'TARGET DEMAND ( 0 ) : ' + CONVERT(nvarchar, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
            
            -----------------------------------------------------------------------------------------------------------------------------------
            -- BOM 하위 전개
            -----------------------------------------------------------------------------------------------------------------------------------
          
            DECLARE @n_loop int = 0

            SET @v_table_name = 'TH_BUF_SCM_VALIDATION_CHECK_LIST'
            SET @n_row_count = 0

            WHILE 1 = 1
            BEGIN
              SET @n_loop += 1
              
              INSERT INTO TH_BUF_SCM_VALIDATION_CHECK_LIST
                    (
                     COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, INSTANCE_ID, ITEM_ID, TARGET_TYPE, BOM_LEVEL, 
                     PARENT_ITEM_ID, PARENT_ITEM_TYPE, PARENT_FLOW_ID,
                     CHILD_ITEM_ID,  CHILD_ITEM_TYPE,  CHILD_FLOW_ID,
                     ALT_ID, ALT_PRIORITY, KEY_DATE,
                     ITEM_CLASS, ITEM_ACTIVE_FLAG, CLASS_ID, USE_FLAG
                    )
              SELECT DISTINCT
                     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.ITEM_ID, A.TARGET_TYPE, A.BOM_LEVEL, 
                     A.PARENT_ITEM_ID, B.ITEM_TYPE AS PARENT_ITEM_TYPE, B.FLOW_ID AS PARENT_FLOW_ID, 
                     A.CHILD_ITEM_ID,  C.ITEM_TYPE AS CHILD_ITEM_TYPE,  C.FLOW_ID AS CHILD_FLOW_ID, 
                     A.ALT_ID, A.ALT_PRIORITY, A.KEY_DATE,
                     A.ITEM_CLASS, A.ITEM_ACTIVE_FLAG, A.CLASS_ID, A.USE_FLAG
              FROM   (
                      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID,
                             A.ITEM_ID, A.TARGET_TYPE, @n_loop + 1 AS BOM_LEVEL , 
                             A.CHILD_ITEM_ID AS PARENT_ITEM_ID, B.CHILD_ITEM_ID, 
                             B.ALT_ID, B.ALT_PRIORITY, B.KEY_DATE,
                             B.ITEM_CLASS, B.ITEM_ACTIVE_FLAG, B.CLASS_ID, B.USE_FLAG
                      FROM   (
                              SELECT DISTINCT
                                     COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, INSTANCE_ID, ITEM_ID, TARGET_TYPE, CHILD_ITEM_ID 
                              FROM   TH_BUF_SCM_VALIDATION_CHECK_LIST
                              WHERE  1=1
                              AND    BOM_LEVEL = @n_loop
                              AND    CHILD_ITEM_ID IS NOT NULL
                        AND    CHILD_ITEM_TYPE <> 'R'
                             ) A
                             LEFT OUTER JOIN TH_BUF_SCM_VALIDATION_BOM B
                                  ON     A.COMPANY_ID = B.COMPANY_ID
                                  AND    A.DIVISION_ID = B.DIVISION_ID
                                  AND    A.SITE_ID = B.SITE_ID
                                  AND    A.PLANT_ID = B.PLANT_ID
                                  AND    A.CHILD_ITEM_ID = B.PARENT_ITEM_ID
                     ) A
                     LEFT OUTER JOIN SCM_ITEM_M B
                          ON    A.COMPANY_ID = B.COMPANY_ID
                          AND   A.DIVISION_ID = B.DIVISION_ID
                          AND   A.SITE_ID = B.SITE_ID
                          AND   A.PARENT_ITEM_ID = B.ITEM_ID
                          AND   B.ACTIVE_FLAG = 'Y'
                     LEFT OUTER JOIN SCM_ITEM_M C
                          ON    A.COMPANY_ID = C.COMPANY_ID
                          AND   A.DIVISION_ID = C.DIVISION_ID
                          AND   A.SITE_ID = C.SITE_ID
                          AND   A.CHILD_ITEM_ID = C.ITEM_ID
                          AND   C.ACTIVE_FLAG = 'Y'
                     INNER JOIN FP_INSTANCE_OPERATION_V D
                      ON    A.INSTANCE_ID = D.INSTANCE_ID
                      AND   B.FLOW_ID LIKE '%'+D.OPERATION_ID +'%'     
                          
              SET @n_row_count = @@ROWCOUNT
              
              --LOG 생성
              SET @v_message = 'TARGET DEMAND ( '+ CONVERT(nvarchar, @n_loop) +' ) : ' + CONVERT(nvarchar, @n_row_count)
              SET @n_log_count = @n_log_count + 1
              SET @sysdate = GETDATE()
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

              IF @n_loop > 100 OR @n_row_count = 0
                BREAK

              UPDATE A
              SET    A.CHILD_ITEM_TYPE 
                        = CASE WHEN A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID THEN A.CHILD_ITEM_TYPE
                               ELSE 'R'
                          END
                    ,A.PLANT_CHANGE 
                        = CASE WHEN A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID THEN A.CHILD_ITEM_TYPE
                               ELSE ( CASE WHEN A.SHOP_GROUP_ID = 'A' THEN 'Y' ELSE NULL END )
                          END
                    ,A.DESCR
                       += CASE WHEN A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID THEN ''
                               ELSE '- 1. UPDATE CHILD_ITEM_TYPE = "R"'
                          END
              FROM   TH_BUF_SCM_VALIDATION_CHECK_LIST A,
                     TH_BUF_SCM_VALIDATION_BOM B
              WHERE  A.BOM_LEVEL = @n_loop + 1
              AND    A.COMPANY_ID = B.COMPANY_ID
              AND    A.DIVISION_ID = B.DIVISION_ID
              AND    A.SITE_ID = B.SITE_ID
              AND    A.CHILD_ITEM_ID = B.PARENT_ITEM_ID

              SET @n_row_count = @@ROWCOUNT
              
              --LOG 생성
              SET @v_message = 'TARGET DEMAND - CHECKING CHILD ITEM : ' + CONVERT(nvarchar, @n_row_count)
              SET @n_log_count = @n_log_count + 1
              SET @sysdate = GETDATE()
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

            END


            -- INSTANCE 와 관계없는 BOM 제거
            DELETE FROM A
            FROM   TH_BUF_SCM_VALIDATION_CHECK_LIST A
            WHERE  1=1
            AND    NOT EXISTS (
                                SELECT 1
                                FROM   (
                                        SELECT A.INSTANCE_ID, A.INSTANCE_TYPE,
                                               B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, A.FACTORY_ID, 
                                               C.FLOW_ID, C.OPERATION_ID
       FROM   FP_INSTANCE_FACTORY_M A,
                                               SCM_FACTORY_M         B,
                                               (SELECT  A.*
                                                    FROM  SCM_OPERATION_FLOW_M A,
                                                        SCM_OPERATION_M B
                                                    WHERE  1=1
                                                    AND    A.COMPANY_ID = B.COMPANY_ID
                                                    AND    A.DIVISION_ID = B.DIVISION_ID
                                                    AND    A.SITE_ID = B.SITE_ID
                                                    AND    A.OPERATION_ID = B.OPERATION_ID
                                                    AND    B.ACTIVE_FLAG = 'Y')  C,
                                               SCM_OPERATION_M       D
                                        WHERE  A.FACTORY_ID = B.FACTORY_ID
                                        AND    B.ACTIVE_FLAG = 'Y'
                                        AND    B.COMPANY_ID = C.COMPANY_ID
                                        AND    B.DIVISION_ID = C.DIVISION_ID
                                        AND    B.SITE_ID = C.SITE_ID
                                        AND    C.COMPANY_ID = D.COMPANY_ID
                                        AND    C.DIVISION_ID = D.DIVISION_ID
                                        AND    C.SITE_ID = D.SITE_ID
                                        AND    C.OPERATION_ID = D.OPERATION_ID
                                        AND    A.INSTANCE_TYPE = D.INSTANCE_TYPE
                                       ) B
                                WHERE  A.COMPANY_ID = B.COMPANY_ID
                                AND    A.DIVISION_ID = B.DIVISION_ID
                                AND    A.SITE_ID = B.SITE_ID
                                AND    A.PLANT_ID = B.PLANT_ID
                                AND    A.INSTANCE_ID = B.INSTANCE_ID
                                AND    A.PARENT_FLOW_ID = B.FLOW_ID
                               )      
          
            SET @n_row_count = @@ROWCOUNT
            
            --LOG 생성
            SET @v_message = 'PARENT_ITEM_ID deleteed not matching INSTANCE_ID : ' + CONVERT(nvarchar, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

            UPDATE A
            SET    A.CHILD_ITEM_TYPE = 'R'
            FROM   TH_BUF_SCM_VALIDATION_CHECK_LIST A
            WHERE  1=1 --item_id = 'APRSAL38L-A1'
            AND    CHILD_ITEM_TYPE <> 'R'
            AND    CHILD_FLOW_ID IS NOT NULL
            AND    NOT EXISTS (
                                SELECT 1
                                FROM   (
                                        SELECT A.INSTANCE_ID, A.INSTANCE_TYPE,
                                               B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, A.FACTORY_ID, 
                                               C.FLOW_ID, C.OPERATION_ID
                                        FROM   FP_INSTANCE_FACTORY_M A,
                                               SCM_FACTORY_M         B,
                                               (SELECT  A.*
                                                    FROM  SCM_OPERATION_FLOW_M A,
                                                        SCM_OPERATION_M B
                                                    WHERE  1=1
                                                    AND    A.COMPANY_ID = B.COMPANY_ID
                                                    AND    A.DIVISION_ID = B.DIVISION_ID
                  AND    A.SITE_ID = B.SITE_ID
                                                    AND    A.OPERATION_ID = B.OPERATION_ID
                                   AND    B.ACTIVE_FLAG = 'Y')  C,
                                               SCM_OPERATION_M       D
                                        WHERE  A.FACTORY_ID = B.FACTORY_ID
                                        AND    B.ACTIVE_FLAG = 'Y'
                                        AND    B.COMPANY_ID = C.COMPANY_ID
                                        AND    B.DIVISION_ID = C.DIVISION_ID
                                        AND    B.SITE_ID = C.SITE_ID
                                        AND    C.COMPANY_ID = D.COMPANY_ID
                                        AND    C.DIVISION_ID = D.DIVISION_ID
                                        AND    C.SITE_ID = D.SITE_ID
                                        AND    C.OPERATION_ID = D.OPERATION_ID
                                        AND    A.INSTANCE_TYPE = D.INSTANCE_TYPE
                                       ) B
                                WHERE  A.COMPANY_ID = B.COMPANY_ID
                                AND    A.DIVISION_ID = B.DIVISION_ID
                                AND    A.SITE_ID = B.SITE_ID
                                AND    A.PLANT_ID = B.PLANT_ID
                                AND    A.INSTANCE_ID = B.INSTANCE_ID
                                AND    A.CHILD_FLOW_ID = B.FLOW_ID
                               )

            SET @n_row_count = @@ROWCOUNT

            --LOG 생성
            SET @v_message = 'CHILD_ITEM_ID updated not matching INSTANCE_ID : ' + CONVERT(nvarchar, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
            
            UPDATE TH_BUF_SCM_VALIDATION_CHECK
            SET    TH_BUF_SCM_VALIDATION_CHECK.CHILD_ITEM_TYPE = 'R'
            FROM   TH_BUF_SCM_VALIDATION_CHECK A
            WHERE  A.SHOP_GROUP_ID = 'A'
            AND    A.CHILD_ITEM_TYPE IN ('H','P')
            AND    A.CHILD_ITEM_ID IN (
                                       SELECT  ITEM_ID 
                                       FROM    SCM_ITEM_M       A
                                             , SCM_ITEM_CLASS_M B
                                       WHERE   A.ITEM_CLASS   = B.CLASS_ID
                                       AND     A.ACTIVE_FLAG  = 'Y'
                                       AND     B.USE_FLAG     = 'Y'
                                       AND     B.LEVEL_2_CODE = 'APC'
                                      )
            
            --LOG 생성
            SET @v_message = 'ITEM TYPE UPDATE : ' + CONVERT(nvarchar, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null                          


            SET @v_table_name = 'TH_BUF_SCM_VALIDATION_CHECK'

            DELETE FROM TH_BUF_SCM_VALIDATION_CHECK

            INSERT INTO TH_BUF_SCM_VALIDATION_CHECK
                 (
                   COMPANY_ID
                 , DIVISION_ID
                 , SITE_ID
                 , PLANT_ID
                 , SHOP_GROUP_ID
                 , INSTANCE_ID
                 , ITEM_ID
                 , CHECK_MONTH
                 , TARGET_TYPE
                 , BOM_LEVEL
                 , PARENT_ITEM_ID
                 , PARENT_ITEM_TYPE
                 , PARENT_FLOW_ID
                 , CHILD_ITEM_ID
                 , CHILD_ITEM_TYPE
                 , CHILD_FLOW_ID
                 , ALT_ID
                 , ALT_PRIORITY
                 , KEY_DATE
                 , BOM_CHECK
             , PLANT_CHANGE
                 , ITEM_CLASS
                 , ITEM_ACTIVE_FLAG
                 , CLASS_ID
                 , USE_FLAG
           , DESCR
                 )
            SELECT 
                   A.COMPANY_ID
                 , A.DIVISION_ID
                 , A.SITE_ID
                 , A.PLANT_ID
                 , A.SHOP_GROUP_ID
                 , A.INSTANCE_ID
                 , A.ITEM_ID
                 , B.CHECK_MONTH
                 , A.TARGET_TYPE
                 , A.BOM_LEVEL
                 , A.PARENT_ITEM_ID
                 , A.PARENT_ITEM_TYPE
                 , A.PARENT_FLOW_ID
                 , A.CHILD_ITEM_ID
                 , A.CHILD_ITEM_TYPE
                 , A.CHILD_FLOW_ID
                 , A.ALT_ID
                 , A.ALT_PRIORITY
                 , A.KEY_DATE
                 , A.BOM_CHECK
                 , A.PLANT_CHANGE
                 , A.ITEM_CLASS
                 , A.ITEM_ACTIVE_FLAG
                 , A.CLASS_ID
                 , A.USE_FLAG
                 , A.DESCR
            FROM   TH_BUF_SCM_VALIDATION_CHECK_LIST A
                 , (
                    SELECT DISTINCT
                           A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID,
                           A.ITEM_ID, A.MFG_MONTH AS CHECK_MONTH
                    FROM   TH_BUF_MASTER_VALIDATION_TARGET A
                   ) B
            WHERE  A.COMPANY_ID     = B.COMPANY_ID
            AND    A.DIVISION_ID    = B.DIVISION_ID
            AND    A.SITE_ID        = B.SITE_ID
            AND    A.PLANT_ID       = B.PLANT_ID
            AND    A.SHOP_GROUP_ID  = B.SHOP_GROUP_ID
            AND    A.INSTANCE_ID    = B.INSTANCE_ID
            AND    A.ITEM_ID        = B.ITEM_ID

            --LOG 생성
            SET @v_message = '' + CONVERT(nvarchar, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
            
            UPDATE TH_BUF_SCM_VALIDATION_CHECK
            SET CHILD_ITEM_TYPE = 'R'
            WHERE CHILD_FLOW_ID IS NULL
            
            SET @v_table_name = 'TH_BUF_SCM_VALIDATION_LINE_ASSIGN'
            
            DELETE FROM TH_BUF_SCM_VALIDATION_LINE_ASSIGN
            
            INSERT INTO TH_BUF_SCM_VALIDATION_LINE_ASSIGN
                 (
                   COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
                 , ITEM_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, MONTH, LANE_QTY, PRIORITY, ACTIVE_FLAG
                 , CAPA_TYPE, PROD_VERSION_TYPE, PLAN_GROUP_ID
                 )
            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
                 , A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.MONTH, A.LANE_QTY, A.PRIORITY, A.ACTIVE_FLAG
                 , B.CAPA_TYPE, C.PROD_VERSION_TYPE, C.MODEL_TYPE AS PLAN_GROUP_ID
            FROM   SCM_ITEM_LINE_ASSIGN_M       A
                   INNER JOIN SCM_OPERATION_M   B
                         ON   A.COMPANY_ID      = B.COMPANY_ID
                         AND  A.DIVISION_ID     = B.DIVISION_ID
                         AND  A.SITE_ID         = B.SITE_ID
                         AND  A.OPERATION_ID    = B.OPERATION_ID
                         AND  B.ACTIVE_FLAG     = 'Y'
                   LEFT  OUTER JOIN SCM_LINE_M  C
                         ON   A.COMPANY_ID      = C.COMPANY_ID
                         AND  A.DIVISION_ID     = C.DIVISION_ID
                         AND  A.SITE_ID         = C.SITE_ID
                         AND  A.PLANT_ID        = C.PLANT_ID
                         AND  A.FACTORY_ID      = C.FACTORY_ID 
                         AND  A.OPERATION_ID    = C.OPERATION_ID
                         AND  A.LINE_ID    = C.LINE_ID 
                         AND  A.ELECTRODE_TYPE  = C.ELECTRODE_TYPE 
                         --AND  C.ACTIVE_FLAG = 'Y'  
            WHERE  1=1
           AND    EXISTS (
                            SELECT *
                            FROM   TH_BUF_SCM_VALIDATION_CHECK X
                            WHERE  X.COMPANY_ID     = A.COMPANY_ID
                         AND    X.DIVISION_ID    = A.DIVISION_ID
                            AND    X.SITE_ID        = A.SITE_ID
                            AND    X.PLANT_ID       = A.PLANT_ID
                            AND    X.PARENT_ITEM_ID = A.ITEM_ID
                            AND    X.CHECK_MONTH    = A.MONTH
                          )
                      
                  
            SET @n_row_count = @@ROWCOUNT

            --LOG 생성
            SET @v_message = '' + CONVERT(nvarchar, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
            
            DELETE A
            FROM TH_BUF_SCM_VALIDATION_LINE_ASSIGN A , SCM_LINE_M B
            WHERE A.COMPANY_ID     = B.COMPANY_ID
            AND  A.DIVISION_ID     = B.DIVISION_ID
            AND  A.SITE_ID         = B.SITE_ID
            AND  A.PLANT_ID        = B.PLANT_ID
            AND  A.FACTORY_ID      = B.FACTORY_ID 
            AND  A.OPERATION_ID    = B.OPERATION_ID
            AND  A.LINE_ID         = B.LINE_ID 
            AND	 A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
            AND  B.ACTIVE_FLAG = 'N'  
          
          END
          
          /*
            1.ITEM - BOM 전
          */
          
          SET @v_table_name = 'TH_BUF_MASTER_VALIDATION_RESULT'

          INSERT INTO TH_BUF_MASTER_VALIDATION_RESULT
              (
                COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , PLAN_DATE
              , VALIDATION_SEQ
              , INSTANCE_ID
              , TOP_ITEM_ID
              , CHECK_SEQ
              , CHECK_CATEGORY
              , CHECK_TABLE
              , PROBLEM_TYPE
              , CHECK_DATA
              , PROBLEM_SEQ
              , PROBLEM_DATA
              , PROBLEM_LIST
              , REFERENCE_TABLE
              , CHECK_UI
              , PROBLEM_DESCRIPTION
              , INSERT_ID
              , INSERT_TIME
              )    
        SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PLAN_DATE,
                @validation_seq + ROW_NUMBER() OVER (ORDER BY SEQ) AS VALIDATION_SEQ,
                A.INSTANCE_ID,
                A.TOP_ITEM_ID, A.CHECK_SEQ, A.CHECK_CATEGORY, A.CHECK_TABLE, A.PROBLEM_TYPE,
                A.CHECK_DATA, A.PROBLEM_SEQ, A.PROBLEM_DATA, A.PROBLEM_LIST, 
                A.REFERENCE_TABLE, A.CHECK_UI, A.PROBLEM_DESCRIPTION
              , @v_proc_name AS INSERT_ID
              , @sysdate AS INSERT_TIME
          FROM   (
                  SELECT DISTINCT
                         A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,
                         @plan_date AS PLAN_DATE,
                         A.INSTANCE_ID,
                         A.TOP_ITEM_ID AS TOP_ITEM_ID,
                         2 AS CHECK_SEQ,
                         A.CHECK_CATEGORY, A.CHECK_TABLE, A.PROBLEM_TYPE,
                         'ITEM' AS CHECK_DATA,
                         1 AS PROBLEM_SEQ,
                         A.ITEM_ID AS PROBLEM_DATA,
                         'ITEM_ID = '+ A.ITEM_ID AS PROBLEM_LIST,
                         CASE WHEN REASON_DATA IS NOT NULL THEN 'SCM_ITEM_M'
                              ELSE 'SCM_ITEM_CLASS_M'
                         END  REFERENCE_TABLE,
                         CASE WHEN REASON_DATA IS NOT NULL THEN 'ITEM'
                         END  CHECK_UI,
                   CASE WHEN REASON_DATA IS NOT NULL THEN REASON_DATA
                         END  PROBLEM_DESCRIPTION,
                         0 AS SEQ
    FROM   (
                          SELECT DISTINCT A.*, 
						                                CASE  WHEN B.ITEM_ID  IS NULL   THEN 'Please check expand the Item.' -- N'Item : ' + A.ITEM_ID+N'- Please check expand the Item'
						                                 			WHEN C.CLASS_ID IS NULL   THEN 'Please check expand the Item.' --N'Item : ' + A.ITEM_ID+N'- Please check expand the Item'
						                                 			WHEN B.FLOW_ID  IS NULL   THEN 'Please check MMD Route ID.' --N'Item : ' + A.ITEM_ID+N'- Please check MMD Route ID.'
				                                      		WHEN B.FLOW_ID  = ''      THEN 'Please check MMD Route ID.' -- N'Item : ' + A.ITEM_ID+N'- Please check MMD Route ID.'
                                                  WHEN (B.ITEM_TYPE IS NULL OR B.ITEM_TYPE = '' OR B.ITEM_TYPE ='Q' ) THEN 'Please check Item Type.'
						                                END  REASON_DATA , 
						                                CASE  WHEN B.ITEM_ID  IS NULL     THEN  'SCM_ITEM_M'
						                                		  WHEN C.CLASS_ID IS NULL     THEN  'SCM_ITEM_CLASS_M'
						                                		  WHEN B.FLOW_ID   IS NULL    THEN	'SCM_ITEM_M'
                                                  WHEN (B.ITEM_TYPE IS NULL OR B.ITEM_TYPE = '' OR B.ITEM_TYPE ='Q' )  THEN 'SCM_ITEM_M'
						                                END  	  CHECK_TABLE	  ,
						                                'ITEM' AS CHECK_CATEGORY , 
                                            CASE  WHEN B.ITEM_ID  IS NULL     THEN  'Expand'
                                                  WHEN C.CLASS_ID IS NULL     THEN  'Expand'
                                                  WHEN B.FLOW_ID  IS NULL     THEN  'Route ID'
                                                  WHEN (B.ITEM_TYPE IS NULL OR B.ITEM_TYPE = '' OR B.ITEM_TYPE ='Q' )  THEN 'Expand'
                                            END    AS  PROBLEM_TYPE    
						                              --'MISSING' AS PROBLEM_TYPE           
                          FROM   (
                                  /*SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID , INSTANCE_ID, ITEM_ID AS TOP_ITEM_ID , PARENT_ITEM_ID   AS ITEM_ID
                                  FROM   TH_BUF_SCM_VALIDATION_CHECK
                                  WHERE BOM_LEVEL = 1 
                                  GROUP  BY 
                                         COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID
                                       , INSTANCE_ID, ITEM_ID , PARENT_ITEM_ID
                                  UNION ALL    */
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, INSTANCE_ID, ITEM_ID AS TOP_ITEM_ID , CHILD_ITEM_ID  AS ITEM_ID 
                                  FROM   TH_BUF_SCM_VALIDATION_CHECK
                                  WHERE BOM_LEVEL > 1 
                                  AND CHILD_ITEM_TYPE <> 'R'
                                  GROUP  BY 
                                         COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID
                                       , INSTANCE_ID, ITEM_ID , CHILD_ITEM_ID
                                 ) A
                                 LEFT OUTER JOIN SCM_ITEM_M B
                                      ON   A.ITEM_ID = B.ITEM_ID
                                      AND  A.COMPANY_ID = B.COMPANY_ID
                                      AND  A.DIVISION_ID = B.DIVISION_ID
                                      AND  A.SITE_ID = B.SITE_ID
                                 LEFT OUTER JOIN SCM_ITEM_CLASS_M C
                         				ON   B.ITEM_CLASS = C.CLASS_ID      		
                         ) A    
                 ) A    
          WHERE  PROBLEM_DESCRIPTION IS NOT NULL
          AND  NOT EXISTS (
                           SELECT 1
                           FROM   TH_BUF_MASTER_VALIDATION_RESULT X
                 WHERE  PLAN_DATE       = @plan_date
                           AND    X.COMPANY_ID    = A.COMPANY_ID
                           AND    X.DIVISION_ID   = A.DIVISION_ID
                           AND    X.SITE_ID       = A.SITE_ID
                           AND    X.PLANT_ID      = A.PLANT_ID
                           AND    X.PROBLEM_DATA  = A.PROBLEM_DATA
                           AND    X.CHECK_TABLE   = A.CHECK_TABLE
                          )    
                          
          SET @n_row_count = @@ROWCOUNT
        
          SET @validation_seq += @n_row_count
  
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null                

          INSERT INTO TH_BUF_MASTER_VALIDATION_RESULT
                (
                  COMPANY_ID
                , DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , PLAN_DATE
                , VALIDATION_SEQ
                , INSTANCE_ID
                , TOP_ITEM_ID
                , CHECK_SEQ
                , CHECK_CATEGORY
                , CHECK_TABLE
                , PROBLEM_TYPE
                , CHECK_DATA
                , PROBLEM_SEQ
                , PROBLEM_DATA
                , PROBLEM_LIST
                , REFERENCE_TABLE
                , CHECK_UI
                , PROBLEM_DESCRIPTION
                , INSERT_ID
                , INSERT_TIME
                )        
                 SELECT
                  COMPANY_ID
                , DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , PLAN_DATE
                , @validation_seq + ROW_NUMBER() OVER (ORDER BY SEQ) AS VALIDATION_SEQ
                , INSTANCE_ID
                , TOP_ITEM_ID
                , CHECK_SEQ
                , CHECK_CATEGORY
                , CHECK_TABLE
                , PROBLEM_TYPE
                , CHECK_DATA
                , PROBLEM_SEQ
                , PROBLEM_DATA
                , PROBLEM_LIST
                , REFERENCE_TABLE
                , CHECK_UI
                , PROBLEM_DESCRIPTION
                --, SQL_QUERY
                , INSERT_ID
                , INSERT_TIME
          FROM   (
                  SELECT  DISTINCT
                          COMPANY_ID
                        , DIVISION_ID
                        , SITE_ID
                        , PLANT_ID
                        , @plan_date AS PLAN_DATE
                        , INSTANCE_ID
                        , A.ITEM_ID AS TOP_ITEM_ID
                        , 5 AS CHECK_SEQ
                        , 'BOM' CHECK_CATEGORY
                        , 'SCM_BOM_M' CHECK_TABLE
                        , 'Expand' PROBLEM_TYPE
                        , 'BOM' CHECK_DATA
                        , ROW_NUMBER() OVER ( PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TARGET_TYPE
                                              ORDER     BY MIN(BOM_LEVEL), PARENT_ITEM_ID ) AS PROBLEM_SEQ
                        , PARENT_ITEM_ID AS PROBLEM_DATA
                        , 'PARENT_ITEM_ID = ''' + PARENT_ITEM_ID + '''' PROBLEM_LIST
                        , 'SCM_BOM_M' AS REFERENCE_TABLE
                        , 'BOM' CHECK_UI
                        ,	'Please check expand the Item.' AS PROBLEM_DESCRIPTION
                       -- , 'N' Item : ' +  MIN(ITEM_ID) + N' Parent Item : ' + PARENT_ITEM_ID + N'- Please check BOM(Semi Product)' PROBLEM_DESCRIPTION
                        --, SQL_QUERY
                        , @v_proc_name AS INSERT_ID
                 , @sysdate AS INSERT_TIME
                        , 0 AS SEQ
                  FROM    TH_BUF_SCM_VALIDATION_CHECK A
                  WHERE   PARENT_ITEM_ID IS NOT NULL
                  AND     CHILD_ITEM_ID IS NULL
                  AND     NOT EXISTS (
                                      SELECT 1
                                      FROM  TH_BUF_SCM_VALIDATION_CHECK B
                                      WHERE 1=1
                                      AND   A.COMPANY_ID = B.COMPANY_ID
                                      AND   B.DIVISION_ID = '82'
                                      AND   B.PARENT_ITEM_ID IN ( 
                                                                  SELECT A.ITEM_ID FROM SCM_ITEM_M A, SCM_ITEM_CLASS_M B 
                                                                   WHERE  1=1
                                                                   AND    A.ITEM_CLASS = B.CLASS_ID
                                                                   AND    B.USE_FLAG = 'Y'
                                                                   AND    B.LEVEL_2_CODE IN ('ASL','ARL'))
                                                                 )        
                  GROUP  BY COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,INSTANCE_ID,ITEM_ID,PARENT_ITEM_ID,TARGET_TYPE
                 ) A
               
          SET @n_row_count = @@ROWCOUNT
        
          SET @validation_seq += @n_row_count
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null   
               
          INSERT INTO TH_BUF_MASTER_VALIDATION_RESULT
                (
                  COMPANY_ID
                , DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , PLAN_DATE
                , VALIDATION_SEQ
                , INSTANCE_ID
                , TOP_ITEM_ID
                , CHECK_SEQ
                , CHECK_CATEGORY
                , CHECK_TABLE
                , PROBLEM_TYPE
                , CHECK_DATA
                , PROBLEM_SEQ
                , PROBLEM_DATA
                , PROBLEM_LIST
                , REFERENCE_TABLE
                , CHECK_UI
                , PROBLEM_DESCRIPTION
                , INSERT_ID
                , INSERT_TIME
                )         
          SELECT
                  COMPANY_ID
                , DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , PLAN_DATE
                , @validation_seq + ROW_NUMBER() OVER (ORDER BY SEQ) AS VALIDATION_SEQ
                , INSTANCE_ID
                , TOP_ITEM_ID
                , CHECK_SEQ
                , CHECK_CATEGORY
                , CHECK_TABLE
                , PROBLEM_TYPE
                , CHECK_DATA
                , PROBLEM_SEQ
                , PROBLEM_DATA
                , PROBLEM_LIST
                , REFERENCE_TABLE
                , CHECK_UI
                , PROBLEM_DESCRIPTION
                --, SQL_QUERY
                , INSERT_ID
                , INSERT_TIME
          FROM   (
                  SELECT  DISTINCT
                          COMPANY_ID
                        , DIVISION_ID
                        , SITE_ID
                        , PLANT_ID
                        , @plan_date AS PLAN_DATE
                        , INSTANCE_ID
                        , ITEM_ID AS TOP_ITEM_ID
                        , 4 AS CHECK_SEQ
                        , 'BOM' CHECK_CATEGORY
                        , 'SCM_BOM_M' CHECK_TABLE
                        , 'Expand' PROBLEM_TYPE
                        , 'BOM' CHECK_DATA
                        , 1 AS PROBLEM_SEQ
                        , ITEM_ID AS PROBLEM_DATA
                    , 'ITEM_ID = ' + ITEM_ID PROBLEM_LIST
                        , 'SCM_BOM_M' AS REFERENCE_TABLE
                        , 'BOM' CHECK_UI
, 'Please check expand the Item' AS  PROBLEM_DESCRIPTION
                       -- , ITEM_ID + N'- Please check BOM' PROBLEM_DESCRIPTION
                        --, SQL_QUERY
                        , @v_proc_name AS INSERT_ID
                        , @sysdate AS INSERT_TIME
                        , 0 AS SEQ
                  FROM    TH_BUF_SCM_VALIDATION_CHECK
                  WHERE   PARENT_ITEM_ID IS NULL
                 ) A
               
          SET @n_row_count = @@ROWCOUNT
        
          SET @validation_seq += @n_row_count
          
          --LOG 생성
     SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null     
               
          /*
            LINE
          */     
               
          INSERT INTO TH_BUF_MASTER_VALIDATION_RESULT
              (
                COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , PLAN_DATE
              , VALIDATION_SEQ
              , INSTANCE_ID
              , TOP_ITEM_ID
              , CHECK_SEQ
              , CHECK_CATEGORY
              , CHECK_TABLE
              , PROBLEM_TYPE
              , CHECK_DATA
              , PROBLEM_SEQ
              , PROBLEM_DATA
              , PROBLEM_LIST
              , REFERENCE_TABLE
              , CHECK_UI
              , PROBLEM_DESCRIPTION
              , INSERT_ID
              , INSERT_TIME
              )       
    	    SELECT  DISTINCT
                  COMPANY_ID
                , DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , @plan_date PLAN_DATE
                , @validation_seq + ROW_NUMBER() OVER (ORDER BY SEQ) AS VALIDATION_SEQ
                , INSTANCE_ID
                , ITEM_ID AS TOP_ITEM_ID
                , 7 AS CHECK_SEQ
                , 'Line' AS CHECK_CATEGORY
                , 'SCM_ITEM_LINE_ASSIGN_M' AS CHECK_TABLE
                , 'Line Assign' PROBLEM_TYPE
                , 'ITEM' CHECK_DATA
                , ROW_NUMBER() OVER  (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID
                                      ORDER     BY OPERATION_ID DESC, PARENT_ITEM_ID ) AS PROBLEM_SEQ
                , PARENT_ITEM_ID AS PROBLEM_DATA
                , 'ITEM_ID = '''+PARENT_ITEM_ID+''', OPERATION_ID = '''+OPERATION_ID+'''' PROBLEM_LIST
                , 'SCM_ITEM_LINE_ASSIGN_M' AS REFERENCE_TABLE
                , 'LINE ASSIGN' CHECK_UI
                , PROBLEM_REASON AS PROBLEM_DESCRIPTION
                --, '' SQL_QUERY
                , @v_proc_name AS INSERT_ID
                , @sysdate AS INSERT_TIME
          FROM   (
                  SELECT DISTINCT
                         A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID
                       , A.INSTANCE_ID, A.OPERATION_ID, A.PARENT_ITEM_ID, A.CHECK_MONTH
                       , CASE WHEN A.ACTIVE_FLAG IS NULL THEN  'Please check Line Assign.' + ' - ' +A.OPERATION_ID + ' - ' + A.CHECK_MONTH  -- N' Item : ' + A.PARENT_ITEM_ID + A.ALT_DESC + N' Month : ' + A.CHECK_MONTH + N' Operation : ' + A.OPERATION_ID + N' - Please check Item Line Assign.' 
                              WHEN A.PRIORITY = '9'      THEN  'Please check Line Assign.' + ' - ' +A.OPERATION_ID + ' - ' + A.CHECK_MONTH -- N' Item : ' + A.PARENT_ITEM_ID + A.ALT_DESC + N' Month : ' + A.CHECK_MONTH + N' Operation : ' + A.OPERATION_ID + N' - Please check Item Line Assign(Priority).' 
                         END  PROBLEM_REASON
                       , 0 AS SEQ
                  FROM   (
          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.INSTANCE_ID,
                                 A.TARGET_TYPE, A.ITEM_ID, A.CHECK_MONTH, A.PARENT_ITEM_ID, A.OPERATION_ID,
                            G.ACTIVE_FLAG,
                                 H.PRIORITY,
                                 CASE WHEN MIN(ISNULL(B.ALT_PRIORITY, 1)) > 1 THEN '(Replacement)'
                                      ELSE ''
                                 END  AS ALT_DESC
                          FROM   (
                                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.INSTANCE_ID,
                                         A.TARGET_TYPE, A.ITEM_ID, A.CHECK_MONTH, A.PARENT_ITEM_ID, C.OPERATION_ID
                                  FROM   (
                                          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.TARGET_TYPE, 
                                                 A.ITEM_ID, A.CHECK_MONTH, A.PARENT_ITEM_ID
                                          FROM   TH_BUF_SCM_VALIDATION_CHECK A
                                          WHERE  A.CHILD_ITEM_ID IS NOT NULL
                                          GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.TARGET_TYPE, 
                                                    A.ITEM_ID, A.CHECK_MONTH, A.PARENT_ITEM_ID
                                         ) A
                                         INNER JOIN SCM_ITEM_M B
                                               ON   A.COMPANY_ID = B.COMPANY_ID
                                               AND  A.DIVISION_ID = B.DIVISION_ID
                                               AND  A.SITE_ID = B.SITE_ID
                                               AND  A.PARENT_ITEM_ID = B.ITEM_ID
                                               AND  B.ACTIVE_FLAG = 'Y'
                                         INNER JOIN (
                                                      SELECT  A.*
                                                      FROM  SCM_OPERATION_FLOW_M A,
                                                            SCM_OPERATION_M B
                                                      WHERE  1=1
                                                      AND    A.COMPANY_ID = B.COMPANY_ID
                                                      AND    A.DIVISION_ID = B.DIVISION_ID
                                                      AND    A.SITE_ID = B.SITE_ID
                                                      AND    A.OPERATION_ID = B.OPERATION_ID
                                                      AND    B.ACTIVE_FLAG = 'Y'
                                                    ) C
                                              ON  A.COMPANY_ID = C.COMPANY_ID
                                              AND A.DIVISION_ID = C.DIVISION_ID
                                              AND A.SITE_ID = C.SITE_ID
                                             -- AND B.FLOW_ID = C.FLOW_ID    
                                              AND CASE WHEN  CHARINDEX('FORM',A.INSTANCE_ID) > 0 THEN B.FORMATION_FLOW_ID ELSE   B.FLOW_ID END = C.FLOW_ID
                                         INNER JOIN SCM_OPERATION_M D    -- 2016.11.25 INSTANCE 별 OPERATION 추출
                                               ON   A.COMPANY_ID = D.COMPANY_ID
                                               AND  A.DIVISION_ID = D.DIVISION_ID
                                               AND  A.SITE_ID = D.SITE_ID
                                               AND  C.OPERATION_ID = D.OPERATION_ID
                                               AND  A.SHOP_GROUP_ID = D.INSTANCE_TYPE
                                 ) A
                                 LEFT OUTER JOIN TH_BUF_SCM_VALIDATION_CHECK B
                                      ON    A.COMPANY_ID      = B.COMPANY_ID
                        AND   A.DIVISION_ID     = B.DIVISION_ID
                                      AND   A.SITE_ID         = B.SITE_ID
                                      AND   A.PLANT_ID        = B.PLANT_ID
                                      AND   A.INSTANCE_ID     = B.INSTANCE_ID
                                      AND   A.TARGET_TYPE     = B.TARGET_TYPE
                                      AND   A.ITEM_ID         = B.ITEM_ID 
                                      AND   A.PARENT_ITEM_ID  = B.CHILD_ITEM_ID
                                      AND   A.CHECK_MONTH     = B.CHECK_MONTH
                                 LEFT OUTER JOIN (
                                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, MONTH, MAX(ACTIVE_FLAG) AS ACTIVE_FLAG
                                                  FROM   TH_BUF_SCM_VALIDATION_LINE_ASSIGN
                                                  WHERE  ACTIVE_FLAG = 'Y'
                                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, MONTH
                                                 ) G
                                      ON  A.PARENT_ITEM_ID = G.ITEM_ID
                                      AND A.COMPANY_ID = G.COMPANY_ID
                                      AND A.DIVISION_ID = G.DIVISION_ID
                                      AND A.SITE_ID = G.SITE_ID
                                      --AND A.PLANT_ID = G.PLANT_ID
                                      AND A.OPERATION_ID = G.OPERATION_ID
                                      AND A.CHECK_MONTH  = G.MONTH
                                 LEFT OUTER JOIN (
                                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, MONTH
                                                       , MAX(PRIORITY)      AS PRIORITY
                                                  FROM   TH_BUF_SCM_VALIDATION_LINE_ASSIGN
                                                  WHERE  1=1
                                                  AND    ACTIVE_FLAG = 'Y'
                                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, MONTH
                                                  HAVING MIN(PRIORITY) = MAX(PRIORITY)
                                                  AND    MAX(PRIORITY) = '9'
                                                 ) H
                                      ON  A.PARENT_ITEM_ID = H.ITEM_ID
                                      AND A.COMPANY_ID = H.COMPANY_ID
                                      AND A.DIVISION_ID = H.DIVISION_ID
                                      AND A.SITE_ID = H.SITE_ID
                                      --AND A.PLANT_ID = G.PLANT_ID
                                      AND A.OPERATION_ID = H.OPERATION_ID
                                      AND A.CHECK_MONTH  = H.MONTH
                          GROUP  BY
                                 A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.INSTANCE_ID,
                                 A.TARGET_TYPE, A.ITEM_ID, A.CHECK_MONTH, A.PARENT_ITEM_ID, A.OPERATION_ID,
                                 G.ACTIVE_FLAG,
                                 H.PRIORITY
                         ) A
                    WHERE A.CHECK_MONTH >= @v_start_month     
                ) A
          WHERE  PROBLEM_REASON IS NOT NULL   
          
          SET @n_row_count = @@ROWCOUNT
        
          SET @validation_seq += @n_row_count
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
          DELETE TH_BUF_MASTER_VALIDATION_RESULT
         FROM (
          			SELECT A.* , B.PROBLEM_TYPE
          			FROM (
          							SELECT DISTINCT A.* , B.PARENT_ITEM_ID   , C.CHILD_ITEM_ID   , C.COMPANY_ID AS C_COMPANY_ID , C.DIVISION_ID AS C_DIVISION_ID  , C.SITE_ID AS C_SITE_ID , C.PLANT_ID AS C_PLANT_ID
          							FROM (
          										SELECT A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.VALIDATION_SEQ , A.INSTANCE_ID , A.TOP_ITEM_ID , A.CHECK_TABLE , A.PROBLEM_DATA
          										FROM  TH_BUF_MASTER_VALIDATION_RESULT A , SCM_ITEM_M B , SCM_ITEM_CLASS_M C
          										WHERE A.INSTANCE_ID = 'KR_CELL'
          										AND A.CHECK_TABLE = 'SCM_ITEM_LINE_ASSIGN_M'
          										AND A.COMPANY_ID = B.COMPANY_ID
          										AND A.DIVISION_ID = B.DIVISION_ID
          										AND A.SITE_ID = B.SITE_ID
          										AND A.TOP_ITEM_ID = B.ITEM_ID 
          										AND B.ITEM_CLASS = C.CLASS_ID
          										AND C.LEVEL_2_NAME = 'ESS'
          										)A , TH_BUF_SCM_VALIDATION_CHECK B ,  TH_BUF_SCM_VALIDATION_CHECK C
          							WHERE A.COMPANY_ID = B.COMPANY_ID 
          							AND A.DIVISION_ID = B.DIVISION_ID
          							AND A.SITE_ID = B.SITE_ID
          							AND A.PLANT_ID = B.PLANT_ID 
          							AND A.PROBLEM_DATA = B.CHILD_ITEM_ID  
          							AND B.COMPANY_ID = C.COMPANY_ID 
          							AND B.DIVISION_ID = C.DIVISION_ID
          							AND B.SITE_ID = C.SITE_ID
          							AND B.PLANT_ID = C.PLANT_ID 
          							AND B.PARENT_ITEM_ID = C.PARENT_ITEM_ID  
          							AND C.CHILD_ITEM_TYPE <> 'R'
          							AND A.PROBLEM_DATA <> C.CHILD_ITEM_ID 
          						)A LEFT OUTER JOIN TH_BUF_MASTER_VALIDATION_RESULT B
          									ON A.INSTANCE_ID = B.INSTANCE_ID
          									AND A.C_COMPANY_ID = B.COMPANY_ID
          									AND A.C_DIVISION_ID = B.DIVISION_ID
          									AND A.C_PLANT_ID = B.PLANT_ID
          									AND A.CHILD_ITEM_ID = B.PROBLEM_DATA 
          									AND B.CHECK_TABLE = 'SCM_ITEM_LINE_ASSIGN_M'
          			WHERE B.PROBLEM_TYPE IS NULL 
          )A
          WHERE TH_BUF_MASTER_VALIDATION_RESULT.COMPANY_ID = A.COMPANY_ID
          AND TH_BUF_MASTER_VALIDATION_RESULT.DIVISION_ID = A.DIVISION_ID
          AND TH_BUF_MASTER_VALIDATION_RESULT.SITE_ID = A.SITE_ID
          AND TH_BUF_MASTER_VALIDATION_RESULT.PLANT_ID = A.PLANT_ID
          AND TH_BUF_MASTER_VALIDATION_RESULT.VALIDATION_SEQ = A.VALIDATION_SEQ
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        
          INSERT INTO TH_BUF_MASTER_VALIDATION_RESULT
                (
                  COMPANY_ID
                , DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , PLAN_DATE
                , VALIDATION_SEQ
                , INSTANCE_ID
                , TOP_ITEM_ID
                , CHECK_SEQ
                , CHECK_CATEGORY
                , CHECK_TABLE
                , PROBLEM_TYPE
                , CHECK_DATA
                , PROBLEM_SEQ
                , PROBLEM_DATA
                , PROBLEM_LIST
                , REFERENCE_TABLE
                , CHECK_UI
                , PROBLEM_DESCRIPTION
                , INSERT_ID
                , INSERT_TIME
                )
          SELECT  DISTINCT
                  COMPANY_ID
                , DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , @plan_date PLAN_DATE
                , @validation_seq + ROW_NUMBER() OVER (ORDER BY SEQ) AS VALIDATION_SEQ
                , INSTANCE_ID
                , ITEM_ID AS TOP_ITEM_ID
                , 9 CHECK_SEQ
                , 'Line' AS CHECK_CATEGORY
              , 'SCM_EQUIPMENT_M' AS CHECK_TABLE
                , 'Equipment' PROBLEM_TYPE
                , 'EQUIPMENT' CHECK_DATA
                , ROW_NUMBER() OVER  (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TARGET_TYPE
                                      ORDER     BY OPERATION_ID DESC, PARENT_ITEM_ID, LINE_ID, ELECTRODE_TYPE ) AS PROBLEM_SEQ
                , PARENT_ITEM_ID AS PROBLEM_DATA
                , 'ITEM_ID = '''+PARENT_ITEM_ID+''', LINE_ID = '''+LINE_ID+''', OPERATION_ID = '''+OPERATION_ID+''', ELECTRODE_TYPE = '''+ELECTRODE_TYPE+'''' PROBLEM_LIST
                , 'SCM_EQUIPMENT_M' AS REFERENCE_TABLE
                , 'EQUIPMENT' CHECK_UI
                , PROBLEM_REASON AS  PROBLEM_DESCRIPTION
                --, '' SQL_QUERY
                , @v_proc_name AS INSERT_ID
                , @sysdate AS INSERT_TIME
               -- , A.ACTIVE_FLAG
          FROM   (
                  SELECT distinct A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.ITEM_ID, A.TARGET_TYPE, A.BOM_LEVEL, A.PARENT_ITEM_ID
                       , A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE
                       , 130 AS RESAON_TYPE_SEQ
                       , CASE WHEN SCM_EQUIPMENT_M#COMPANY_ID IS NULL AND B.ACTIVE_FLAG = 'Y'     THEN 'Please check Equipment for Line.'+' - ' + A.LINE_ID  --N'Item : '+ PARENT_ITEM_ID+N' Operation : '+A.OPERATION_ID+N' Line : '+A.LINE_ID+N'- Please check Equipment for Line.' 
                              WHEN SCM_EQUIPMENT_M#ACTIVE_FLAG = 'N'     AND B.ACTIVE_FLAG = 'Y' THEN 'Please check Equipment for Line.'+' - ' + A.LINE_ID --N'Item : '+ PARENT_ITEM_ID+N' Operation : '+A.OPERATION_ID+N' Line : '+A.LINE_ID+N'- Please check Equipment for Line.' 
                         END  PROBLEM_REASON
                       , 0 AS SEQ
                       --, B.ACTIVE_FLAG 
                  FROM   (                              
                          SELECT A.*
                          /*
                               , B.COMPANY_ID       AS SCM_EQUIPMENT_M#COMPANY_ID
                               , C.DIVISION_ID      AS SCM_EQUIPMENT_M#DIVISION_ID
                               , D.SITE_ID          AS SCM_EQUIPMENT_M#SITE_ID
                               , E.PLANT_ID         AS SCM_EQUIPMENT_M#PLANT_ID
                               , F.FACTORY_ID       AS SCM_EQUIPMENT_M#FACTORY_ID
                               , G.OPERATION_ID     AS SCM_EQUIPMENT_M#OPERATION_ID
                               , H.LINE_ID          AS SCM_EQUIPMENT_M#LINE_ID
                               */
                               , J.COMPANY_ID       AS SCM_EQUIPMENT_M#COMPANY_ID
                               , J.DIVISION_ID      AS SCM_EQUIPMENT_M#DIVISION_ID
                               , J.SITE_ID          AS SCM_EQUIPMENT_M#SITE_ID
                               , J.PLANT_ID         AS SCM_EQUIPMENT_M#PLANT_ID
                               , J.FACTORY_ID       AS SCM_EQUIPMENT_M#FACTORY_ID
                               , J.OPERATION_ID     AS SCM_EQUIPMENT_M#OPERATION_ID
                               , J.LINE_ID          AS SCM_EQUIPMENT_M#LINE_ID
                               , J.ELECTRODE_TYPE   AS SCM_EQUIPMENT_M#ELECTRODE_TYPE
                               , J.ACTIVE_FLAG      AS SCM_EQUIPMENT_M#ACTIVE_FLAG
                          FROM   (
                                  SELECT DISTINCT
                                         A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.ITEM_ID, 
                                         A.TARGET_TYPE, A.BOM_LEVEL, A.PARENT_ITEM_ID,
                                         B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE, B.ACTIVE_FLAG
                                  FROM   (
                                          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID,
                                                 A.TARGET_TYPE, A.ITEM_ID, A.CHECK_MONTH, A.BOM_LEVEL, A.PARENT_ITEM_ID, 
                                                 B.FLOW_ID, C.OPERATION_ID, C.ACTIVE_FLAG
                                          FROM   (
                                                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.TARGET_TYPE, 
                                                         A.ITEM_ID, A.CHECK_MONTH, A.BOM_LEVEL, A.PARENT_ITEM_ID
                                                  FROM   TH_BUF_SCM_VALIDATION_CHECK A
                                                  WHERE  A.CHILD_ITEM_ID IS NOT NULL
                                                  GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.TARGET_TYPE, 
                                                            A.ITEM_ID, A.CHECK_MONTH, A.BOM_LEVEL, A.PARENT_ITEM_ID
                                                 ) A
                                                 INNER JOIN SCM_ITEM_M B
                                                       ON   A.COMPANY_ID = B.COMPANY_ID
                                                       AND  A.DIVISION_ID = B.DIVISION_ID
                                                       AND  A.SITE_ID = B.SITE_ID
                                                       AND  A.PARENT_ITEM_ID = B.ITEM_ID
                                                       AND  B.ACTIVE_FLAG = 'Y'
                                                 INNER JOIN (
                                                              SELECT  A.*
                                                              FROM  SCM_OPERATION_FLOW_M A,
                                                                    SCM_OPERATION_M B
                                                              WHERE  1=1
                                                              AND    A.COMPANY_ID = B.COMPANY_ID
                                                              AND    A.DIVISION_ID = B.DIVISION_ID
                                                              AND    A.SITE_ID = B.SITE_ID
                                                              AND    A.OPERATION_ID = B.OPERATION_ID
                                                              AND    B.ACTIVE_FLAG = 'Y'
                                                             ) C
                                                       ON   A.COMPANY_ID = C.COMPANY_ID
                                                       AND  A.DIVISION_ID = C.DIVISION_ID
                                                       AND  A.SITE_ID = C.SITE_ID
                                                       AND  B.FLOW_ID = C.FLOW_ID    
                                                 INNER JOIN SCM_OPERATION_M D    -- 2016.11.25 INSTANCE 별 OPERATION 추출
                                                       ON   A.COMPANY_ID = D.COMPANY_ID
                                                       AND  A.DIVISION_ID = D.DIVISION_ID
                                                       AND  A.SITE_ID = D.SITE_ID
                                                       AND  C.OPERATION_ID = D.OPERATION_ID
                                                       AND  A.SHOP_GROUP_ID = D.INSTANCE_TYPE
                                         ) A 
                                         INNER HASH JOIN (
                                                      SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, MONTH, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, MAX(ACTIVE_FLAG) AS ACTIVE_FLAG
                                                      FROM   TH_BUF_SCM_VALIDATION_LINE_ASSIGN
                                                      WHERE  ACTIVE_FLAG = 'Y'
                                                      AND    PRIORITY <> 9 --SONG       
                                                      GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, MONTH, LINE_ID, OPERATION_ID, ELECTRODE_TYPE
            ) B
                                                ON   A.COMPANY_ID = B.COMPANY_ID
                                                AND  A.DIVISION_ID = B.DIVISION_ID
                                                AND  A.SITE_ID = B.SITE_ID
                                                AND  A.PLANT_ID = B.PLANT_ID
                                                AND  A.PARENT_ITEM_ID = B.ITEM_ID
                                                AND  A.OPERATION_ID = B.OPERATION_ID
                                                AND  A.CHECK_MONTH  = B.MONTH
                                 ) A
                                 LEFT OUTER JOIN (
                                                    SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, MAX(ACTIVE_FLAG) AS ACTIVE_FLAG
                                                    FROM   SCM_EQUIPMENT_M
                                                    GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE
                                                 ) J
                                      ON  A.COMPANY_ID  = J.COMPANY_ID
                                      AND A.DIVISION_ID  = J.DIVISION_ID
                                      AND A.SITE_ID  = J.SITE_ID
                                      AND A.PLANT_ID  = J.PLANT_ID
                                      AND A.FACTORY_ID  = J.FACTORY_ID
                                      AND A.LINE_ID = J.LINE_ID
                                      AND A.OPERATION_ID  = J.OPERATION_ID
                                      AND A.ELECTRODE_TYPE  = J.ELECTRODE_TYPE
                         ) A ,SCM_LINE_M B
                         WHERE A.COMPANY_ID = B.COMPANY_ID
                         AND      A.DIVISION_ID = B.DIVISION_ID
                         AND      A.SITE_ID = B.SITE_ID
                         AND      A.PLANT_ID = B.PLANT_ID
                         AND      A.FACTORY_ID= B.FACTORY_ID 
                         AND      A.LINE_ID = B.LINE_ID
                 ) A
          WHERE  PROBLEM_REASON IS NOT NULL
          
          SET @n_row_count = @@ROWCOUNT
        
          SET @validation_seq += @n_row_count
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null 
          
          DELETE TH_BUF_MASTER_VALIDATION_RESULT
          FROM (
          			SELECT A.* , B.PROBLEM_TYPE
          			FROM (
          							SELECT DISTINCT A.* , B.PARENT_ITEM_ID   , C.CHILD_ITEM_ID   , C.COMPANY_ID AS C_COMPANY_ID , C.DIVISION_ID AS C_DIVISION_ID  , C.SITE_ID AS C_SITE_ID , C.PLANT_ID AS C_PLANT_ID
          							FROM (
          										SELECT A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.VALIDATION_SEQ , A.INSTANCE_ID , A.TOP_ITEM_ID , A.CHECK_TABLE , A.PROBLEM_DATA
          										FROM  TH_BUF_MASTER_VALIDATION_RESULT A , SCM_ITEM_M B , SCM_ITEM_CLASS_M C
          										WHERE A.INSTANCE_ID = 'KR_CELL'
          										AND A.CHECK_TABLE = 'SCM_EQUIPMENT_M'
          										AND A.COMPANY_ID = B.COMPANY_ID
          										AND A.DIVISION_ID = B.DIVISION_ID
          										AND A.SITE_ID = B.SITE_ID
          										AND A.TOP_ITEM_ID = B.ITEM_ID 
          										AND B.ITEM_CLASS = C.CLASS_ID
          										AND C.LEVEL_2_NAME = 'ESS'
          										)A , TH_BUF_SCM_VALIDATION_CHECK B ,  TH_BUF_SCM_VALIDATION_CHECK C
          							WHERE A.COMPANY_ID = B.COMPANY_ID 
          							AND A.DIVISION_ID = B.DIVISION_ID
          							AND A.SITE_ID = B.SITE_ID
          							AND A.PLANT_ID = B.PLANT_ID 
          							AND A.PROBLEM_DATA = B.CHILD_ITEM_ID  
 							AND B.COMPANY_ID = C.COMPANY_ID 
          							AND B.DIVISION_ID = C.DIVISION_ID
          							AND B.SITE_ID = C.SITE_ID
          							AND B.PLANT_ID = C.PLANT_ID 
          							AND B.PARENT_ITEM_ID = C.PARENT_ITEM_ID  
          							AND C.CHILD_ITEM_TYPE <> 'R'
          							AND A.PROBLEM_DATA <> C.CHILD_ITEM_ID 
          						)A LEFT OUTER JOIN TH_BUF_MASTER_VALIDATION_RESULT B
          									ON A.INSTANCE_ID = B.INSTANCE_ID
          									AND A.C_COMPANY_ID = B.COMPANY_ID
          									AND A.C_DIVISION_ID = B.DIVISION_ID
          									AND A.C_PLANT_ID = B.PLANT_ID
          									AND A.CHILD_ITEM_ID = B.PROBLEM_DATA 
          									AND B.CHECK_TABLE = 'SCM_EQUIPMENT_M'
          			WHERE B.PROBLEM_TYPE IS NULL 	
          )A
          WHERE TH_BUF_MASTER_VALIDATION_RESULT.COMPANY_ID = A.COMPANY_ID
          AND TH_BUF_MASTER_VALIDATION_RESULT.DIVISION_ID = A.DIVISION_ID
          AND TH_BUF_MASTER_VALIDATION_RESULT.SITE_ID = A.SITE_ID
          AND TH_BUF_MASTER_VALIDATION_RESULT.PLANT_ID = A.PLANT_ID
          AND TH_BUF_MASTER_VALIDATION_RESULT.VALIDATION_SEQ = A.VALIDATION_SEQ
        
          INSERT INTO TH_BUF_MASTER_VALIDATION_RESULT
              (
                COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , PLAN_DATE
              , VALIDATION_SEQ
              , INSTANCE_ID
              , TOP_ITEM_ID
              , CHECK_SEQ
              , CHECK_CATEGORY
              , CHECK_TABLE
              , PROBLEM_TYPE
              , CHECK_DATA
              , PROBLEM_SEQ
              , PROBLEM_DATA
              , PROBLEM_LIST
              , REFERENCE_TABLE
              , CHECK_UI
              , PROBLEM_DESCRIPTION
              , INSERT_ID
              , INSERT_TIME
              )
          SELECT  DISTINCT
                  COMPANY_ID
                , DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , @plan_date PLAN_DATE
                , @validation_seq + ROW_NUMBER() OVER (ORDER BY SEQ) AS VALIDATION_SEQ
                , INSTANCE_ID
                , ITEM_ID AS TOP_ITEM_ID
                , 10 AS CHECK_SEQ
                , 'Capacity' AS CHECK_CATEGORY
                , 'SCM_TACT_TIME_M' AS CHECK_TABLE
                , 'Capacity' PROBLEM_TYPE
                , A.CAPA_TYPE AS CHECK_DATE -- 'TACT-TIME' CHECK_DATA
                , ROW_NUMBER() OVER  (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TARGET_TYPE
                                      ORDER     BY OPERATION_ID DESC, PARENT_ITEM_ID, LINE_ID, ELECTRODE_TYPE ) AS PROBLEM_SEQ
                , PARENT_ITEM_ID AS PROBLEM_DATA
                , 'ITEM_ID = '''+PARENT_ITEM_ID+''', LINE_ID = '''+LINE_ID+''', OPERATION_ID = '''+OPERATION_ID+''', ELECTRODE_TYPE = '''+ELECTRODE_TYPE+'''' PROBLEM_LIST
                , 'SCM_TACT_TIME_M' AS REFERENCE_TABLE
                , 'Tact Time' CHECK_UI
                , PROBLEM_REASON AS  PROBLEM_DESCRIPTION
                --, '' SQL_QUERY
                , @v_proc_name AS INSERT_ID
                , @sysdate AS INSERT_TIME
          FROM   (
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.ITEM_ID, A.TARGET_TYPE, A.BOM_LEVEL, A.PARENT_ITEM_ID
                       , A.OPERATION_ID, A.FACTORY_ID, A.LINE_ID, A.ELECTRODE_TYPE
                       , 150 AS RESAON_TYPE_SEQ
                       , 'SCM_TACT_TIME_M' AS TABLE_NAME
                       , A.CAPA_TYPE
                       , CASE WHEN SCM_TACT_TIME_M#LINE_ID IS NULL     THEN 'Please check Capacity for Line.' + '-' + A.LINE_ID  +' MONTH - ' +A.CHECK_MONTH
                       			 WHEN SCM_TACT_TIME_M#TACT_TIME     = 0     AND A.CAPA_TYPE = 'TACT_TIME'        THEN 'Please check Capacity for Line.' + '-' + A.LINE_ID  +' MONTH - ' +A.CHECK_MONTH
            			 WHEN SCM_TACT_TIME_M#DAILY_CAPA     = 0    AND A.CAPA_TYPE = 'DAILY_CAPA'		THEN 'Please check Capacity for Line.' + '-' + A.LINE_ID  +' MONTH - ' +A.CHECK_MONTH
                       	END	 AS PROBLEM_REASON	 
                     /*  , N'Item : '+PARENT_ITEM_ID+N' Month : '+A.CHECK_MONTH++N' Operation : '+A.OPERATION_ID+N' Line : '+LINE_ID+ ' - Please check ' +
                         CASE WHEN SCM_TACT_TIME_M#COMPANY_ID IS NULL     THEN  CASE WHEN  A.CAPA_TYPE = 'DAILY_CAPA' THEN N'Daily Capacity'  ELSE N'Tact_Time' END + '(Company_ID).'
                              WHEN SCM_TACT_TIME_M#DIVISION_ID IS NULL    THEN  CASE WHEN  A.CAPA_TYPE = 'DAILY_CAPA' THEN N'Daily Capacity'  ELSE N'Tact_Time' END + '(Division_ID).'
                              WHEN SCM_TACT_TIME_M#SITE_ID IS NULL        THEN  CASE WHEN  A.CAPA_TYPE = 'DAILY_CAPA' THEN N'Daily Capacity'  ELSE N'Tact_Time' END + '(Site_ID).'
                              WHEN SCM_TACT_TIME_M#PLANT_ID IS NULL       THEN  CASE WHEN  A.CAPA_TYPE = 'DAILY_CAPA' THEN N'Daily Capacity'  ELSE N'Tact_Time' END + '(Plant_ID).'
                              WHEN SCM_TACT_TIME_M#FACTORY_ID IS NULL     THEN  CASE WHEN  A.CAPA_TYPE = 'DAILY_CAPA' THEN N'Daily Capacity'  ELSE N'Tact_Time' END + '(Factory_ID).'
                              WHEN SCM_TACT_TIME_M#OPERATION_ID IS NULL   THEN  CASE WHEN  A.CAPA_TYPE = 'DAILY_CAPA' THEN N'Daily Capacity'  ELSE N'Tact_Time' END + '(Operation_ID).' 
                              WHEN SCM_TACT_TIME_M#LINE_ID IS NULL        THEN  CASE WHEN  A.CAPA_TYPE = 'DAILY_CAPA' THEN N'Daily Capacity'  ELSE N'Tact_Time' END + '(Line_ID).'
                              WHEN SCM_TACT_TIME_M#ELECTRODE_TYPE IS NULL THEN  CASE WHEN  A.CAPA_TYPE = 'DAILY_CAPA' THEN N'Daily Capacity'  ELSE N'Tact_Time' END + '(Electrod type).'
                              WHEN SCM_TACT_TIME_M#DAILY_CAPA     = 0     
                                AND A.CAPA_TYPE = 'DAILY_CAPA'            THEN                                             N'Daily Capacity'                        + '(DAILY_CAPA = 0).' 
                              WHEN SCM_TACT_TIME_M#TACT_TIME     = 0     
                                AND A.CAPA_TYPE = 'TACT_TIME'             THEN                                                                     N'Tact_Time'     + '(TACT_TIME = 0).'
                         END  PROBLEM_REASON*/
                       , 0 AS SEQ
                  FROM   (                              
                          SELECT A.*
                               , J.COMPANY_ID             AS SCM_TACT_TIME_M#COMPANY_ID
                               , J.DIVISION_ID            AS SCM_TACT_TIME_M#DIVISION_ID
                               , J.SITE_ID                AS SCM_TACT_TIME_M#SITE_ID
                               , J.PLANT_ID               AS SCM_TACT_TIME_M#PLANT_ID
                               , J.FACTORY_ID             AS SCM_TACT_TIME_M#FACTORY_ID
                               , J.OPERATION_ID           AS SCM_TACT_TIME_M#OPERATION_ID
                               , J.LINE_ID                AS SCM_TACT_TIME_M#LINE_ID
                               , J.ELECTRODE_TYPE         AS SCM_TACT_TIME_M#ELECTRODE_TYPE
                               , ISNULL(J.DAILY_CAPA, 0)  AS SCM_TACT_TIME_M#DAILY_CAPA
                               , ISNULL(J.TACT_TIME, 0)   AS SCM_TACT_TIME_M#TACT_TIME
                          FROM   (
                                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.ITEM_ID, 
                                         A.TARGET_TYPE, A.CHECK_MONTH, A.BOM_LEVEL, A.PARENT_ITEM_ID,
                                         B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE, B.ACTIVE_FLAG , A.CAPA_TYPE
                                  FROM   (
                                          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID,
                                                 A.TARGET_TYPE, A.ITEM_ID, A.CHECK_MONTH, A.BOM_LEVEL, A.PARENT_ITEM_ID, 
                                                 B.FLOW_ID, C.OPERATION_ID, C.ACTIVE_FLAG , E.KEY_VALUE AS CAPA_TYPE
                                          FROM   (
                                                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.TARGET_TYPE, 
                                                         A.ITEM_ID, A.CHECK_MONTH, A.BOM_LEVEL, A.PARENT_ITEM_ID
                                                  FROM   TH_BUF_SCM_VALIDATION_CHECK A
                                                  WHERE  A.CHILD_ITEM_ID IS NOT NULL
                                                  GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.TARGET_TYPE, 
                                                            A.ITEM_ID, A.CHECK_MONTH, A.BOM_LEVEL, A.PARENT_ITEM_ID
                                                 ) A
                                                 INNER JOIN SCM_ITEM_M B
                                                       ON   A.COMPANY_ID = B.COMPANY_ID
                                                       AND  A.DIVISION_ID = B.DIVISION_ID
                                                       AND  A.SITE_ID = B.SITE_ID
                                                       AND  A.PARENT_ITEM_ID = B.ITEM_ID
                                                       AND  B.ACTIVE_FLAG = 'Y'
                                                 INNER JOIN (
                                                              SELECT  A.*
                                                              FROM  SCM_OPERATION_FLOW_M A,
                                                                    SCM_OPERATION_M B
                                                              WHERE  1=1
                                                              AND    A.COMPANY_ID = B.COMPANY_ID
                                                              AND    A.DIVISION_ID = B.DIVISION_ID
                                                              AND    A.SITE_ID = B.SITE_ID
                                                              AND    A.OPERATION_ID = B.OPERATION_ID
                                                              AND    B.ACTIVE_FLAG = 'Y'
                                                            ) C
                                                       ON   A.COMPANY_ID = C.COMPANY_ID
                                                       AND  A.DIVISION_ID = C.DIVISION_ID
                                                       AND  A.SITE_ID = C.SITE_ID
                                                       AND  B.FLOW_ID = C.FLOW_ID    
                                                 INNER JOIN SCM_OPERATION_M D    -- 2016.11.25 INSTANCE 별 OPERATION 추출
                                                       ON   A.COMPANY_ID = D.COMPANY_ID
                                                       AND  A.DIVISION_ID = D.DIVISION_ID
                                                       AND  A.SITE_ID = D.SITE_ID
                                                       AND  C.OPERATION_ID = D.OPERATION_ID
                                                       AND  A.SHOP_GROUP_ID = D.INSTANCE_TYPE
                                                 INNER JOIN FP_INSTANCE_CONFIG_M E
                  							                       ON   A.INSTANCE_ID = E.INSTANCE_ID
                  							                       AND  E.KEY_ID = 'FINAL_OP_CAPA'          
                                         ) A 
                                 INNER JOIN (
                                                      SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, MONTH, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, MAX(ACTIVE_FLAG) AS ACTIVE_FLAG
                                                      FROM   TH_BUF_SCM_VALIDATION_LINE_ASSIGN
                                                      WHERE  ACTIVE_FLAG = 'Y'
                                                      AND    CAPA_TYPE = 'TACT'
                                                      AND    PRIORITY <> 9 
                                                      GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, MONTH, LINE_ID, OPERATION_ID, ELECTRODE_TYPE
                                      ) B
                                                ON   A.COMPANY_ID = B.COMPANY_ID
                                                AND  A.DIVISION_ID = B.DIVISION_ID
                                                AND  A.SITE_ID = B.SITE_ID
                                                AND  A.PLANT_ID = B.PLANT_ID
                                                AND  A.PARENT_ITEM_ID = B.ITEM_ID      
                                                AND  A.OPERATION_ID = B.OPERATION_ID
                                                AND  A.CHECK_MONTH = B.MONTH
                                 ) A
                                 LEFT OUTER JOIN SCM_TACT_TIME_M J
                                      ON  A.PARENT_ITEM_ID = J.ITEM_ID
                                      AND A.COMPANY_ID  = J.COMPANY_ID
                                      AND A.DIVISION_ID  = J.DIVISION_ID
                                      AND A.SITE_ID  = J.SITE_ID
                                      AND A.PLANT_ID  = J.PLANT_ID
                                      AND A.FACTORY_ID  = J.FACTORY_ID
                                      AND A.OPERATION_ID  = J.OPERATION_ID
                                      AND A.LINE_ID  = J.LINE_ID
                                      AND A.ELECTRODE_TYPE  = J.ELECTRODE_TYPE
                                      AND A.CHECK_MONTH = J.MONTH
                         ) A
                    WHERE A.CHECK_MONTH >= @v_start_month     
                 ) A
          WHERE  PROBLEM_REASON IS NOT NULL
          
          SET @n_row_count = @@ROWCOUNT
        
          SET @validation_seq += @n_row_count
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null 
        
          INSERT INTO TH_BUF_MASTER_VALIDATION_RESULT
              (
                COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , PLAN_DATE
              , VALIDATION_SEQ
              , INSTANCE_ID
              , TOP_ITEM_ID
              , CHECK_SEQ
              , CHECK_CATEGORY
              , CHECK_TABLE
              , PROBLEM_TYPE
              , CHECK_DATA
              , PROBLEM_SEQ
              , PROBLEM_DATA
              , PROBLEM_LIST
              , REFERENCE_TABLE
              , CHECK_UI
              , PROBLEM_DESCRIPTION
              , INSERT_ID
              , INSERT_TIME
              )
          SELECT  DISTINCT
                  COMPANY_ID
                , DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , @plan_date PLAN_DATE
                , @validation_seq + ROW_NUMBER() OVER (ORDER BY SEQ) AS VALIDATION_SEQ
                , INSTANCE_ID
                , ITEM_ID AS TOP_ITEM_ID
                , 10 AS CHECK_SEQ
                , 'YIELD' AS CHECK_CATEGORY
                , 'SCM_YIELD_M' AS CHECK_TABLE
                , 'Yield' PROBLEM_TYPE
       , 'YIELD' AS CHECK_DATE -- 'TACT-TIME' CHECK_DATA
                , ROW_NUMBER() OVER  (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TARGET_TYPE
                                      ORDER     BY OPERATION_ID DESC, PARENT_ITEM_ID, LINE_ID, ELECTRODE_TYPE ) AS PROBLEM_SEQ
                , PARENT_ITEM_ID AS PROBLEM_DATA
                , 'ITEM_ID = '''+PARENT_ITEM_ID+''', LINE_ID = '''+LINE_ID+''', OPERATION_ID = '''+OPERATION_ID+''', ELECTRODE_TYPE = '''+ELECTRODE_TYPE+'''' PROBLEM_LIST
                , 'SCM_YIELD_M' AS REFERENCE_TABLE
                , 'YIELD' CHECK_UI
                , PROBLEM_REASON AS  PROBLEM_DESCRIPTION
                --, '' SQL_QUERY
                , @v_proc_name AS INSERT_ID
                , @sysdate AS INSERT_TIME
          FROM   (
                  SELECT DISTINCT 
                         A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.ITEM_ID, A.TARGET_TYPE, A.BOM_LEVEL, A.PARENT_ITEM_ID
                       , A.OPERATION_ID, A.FACTORY_ID, A.LINE_ID, A.ELECTRODE_TYPE
                       , 150 AS RESAON_TYPE_SEQ
                       , 'SCM_YIELD_M' AS TABLE_NAME
                       , A.CAPA_TYPE
                       , CASE WHEN SCM_YIELD_M#YIELD = 0  THEN 'Please check Yield for Line.' + '-' + A.LINE_ID   +'-' + A.CHECK_MONTH
                       	END	 AS PROBLEM_REASON	 
                       , 0 AS SEQ
                  FROM   (          
                          SELECT A.*
                               , ISNULL(J.YIELD, 0)  AS SCM_YIELD_M#YIELD
                          FROM   (
                                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.ITEM_ID, 
                                         A.TARGET_TYPE, A.CHECK_MONTH, A.BOM_LEVEL, A.PARENT_ITEM_ID,
                                         B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE, B.ACTIVE_FLAG , A.CAPA_TYPE
                                  FROM   (
                                          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID,
                                                 A.TARGET_TYPE, A.ITEM_ID, A.CHECK_MONTH, A.BOM_LEVEL, A.PARENT_ITEM_ID, 
                                                 B.FLOW_ID, C.OPERATION_ID, C.ACTIVE_FLAG , E.KEY_VALUE AS CAPA_TYPE
                                          FROM   (
                                                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.TARGET_TYPE, 
                                                         A.ITEM_ID, A.CHECK_MONTH, A.BOM_LEVEL, A.PARENT_ITEM_ID
                                                  FROM   TH_BUF_SCM_VALIDATION_CHECK A
                                                  WHERE  A.CHILD_ITEM_ID IS NOT NULL
                                                  GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.TARGET_TYPE, 
                                                            A.ITEM_ID, A.CHECK_MONTH, A.BOM_LEVEL, A.PARENT_ITEM_ID
                                                 ) A
                                                 INNER JOIN SCM_ITEM_M B
                                                       ON   A.COMPANY_ID = B.COMPANY_ID
                                                       AND  A.DIVISION_ID = B.DIVISION_ID
                                                       AND  A.SITE_ID = B.SITE_ID
                                                       AND  A.PARENT_ITEM_ID = B.ITEM_ID
                                                       AND  B.ACTIVE_FLAG = 'Y'
                                                 INNER JOIN (
                                                              SELECT  A.*
                                                              FROM  SCM_OPERATION_FLOW_M A,
                                                                    SCM_OPERATION_M B
                                                              WHERE  1=1
                                                              AND    A.COMPANY_ID = B.COMPANY_ID
                                                              AND    A.DIVISION_ID = B.DIVISION_ID
                                                              AND    A.SITE_ID = B.SITE_ID
                                                              AND    A.OPERATION_ID = B.OPERATION_ID
                                                              AND    B.ACTIVE_FLAG = 'Y'
                                                            ) C
                                                       ON   A.COMPANY_ID = C.COMPANY_ID
                                                       AND  A.DIVISION_ID = C.DIVISION_ID
                                                       AND  A.SITE_ID = C.SITE_ID
                                                       AND  B.FLOW_ID = C.FLOW_ID    
                                                 INNER JOIN SCM_OPERATION_M D    -- 2016.11.25 INSTANCE 별 OPERATION 추출
                                                       ON   A.COMPANY_ID = D.COMPANY_ID
                                                       AND  A.DIVISION_ID = D.DIVISION_ID
                                                       AND  A.SITE_ID = D.SITE_ID
                                                       AND  C.OPERATION_ID = D.OPERATION_ID
                                                       AND  A.SHOP_GROUP_ID = D.INSTANCE_TYPE
                                                 INNER JOIN FP_INSTANCE_CONFIG_M E
                  							                       ON   A.INSTANCE_ID = E.INSTANCE_ID
                  							                       AND  E.KEY_ID = 'FINAL_OP_CAPA'          
                                         ) A 
                                         INNER JOIN (
                                                      SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, MONTH, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, MAX(ACTIVE_FLAG) AS ACTIVE_FLAG
                                                      FROM   TH_BUF_SCM_VALIDATION_LINE_ASSIGN
                                                      WHERE  ACTIVE_FLAG = 'Y'
                                                      AND    CAPA_TYPE = 'TACT'
                                                      AND    PRIORITY <> 9 --SONG  
                                                      GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, MONTH, LINE_ID, OPERATION_ID, ELECTRODE_TYPE
                                                    ) B
                                                ON   A.COMPANY_ID = B.COMPANY_ID
                                                AND  A.DIVISION_ID = B.DIVISION_ID
                                                AND  A.SITE_ID = B.SITE_ID
                                                AND  A.PLANT_ID = B.PLANT_ID
                                                AND  A.PARENT_ITEM_ID = B.ITEM_ID      
                                                AND  A.OPERATION_ID = B.OPERATION_ID
                                                AND  A.CHECK_MONTH = B.MONTH
                                 ) A
                                 LEFT OUTER JOIN SCM_YIELD_M J
                                      ON  A.PARENT_ITEM_ID = J.ITEM_ID
                                      AND A.COMPANY_ID  = J.COMPANY_ID
                                      AND A.DIVISION_ID  = J.DIVISION_ID
                                      AND A.SITE_ID  = J.SITE_ID
                                      AND A.PLANT_ID  = J.PLANT_ID
                                      AND A.FACTORY_ID  = J.FACTORY_ID
                                      AND A.OPERATION_ID  = J.OPERATION_ID
                                      AND A.LINE_ID  = J.LINE_ID
                                      AND A.CHECK_MONTH = J.MONTH
                         ) A
                      WHERE A.CHECK_MONTH >= @v_start_month   
                     ) A
          WHERE  PROBLEM_REASON IS NOT NULL
          
          SET @n_row_count = @@ROWCOUNT
        
          SET @validation_seq += @n_row_count
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
          INSERT INTO TH_BUF_MASTER_VALIDATION_RESULT
              (
                  COMPANY_ID
                , DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , PLAN_DATE
                , VALIDATION_SEQ
                , INSTANCE_ID
                , TOP_ITEM_ID
                , CHECK_SEQ
                , CHECK_CATEGORY
                , CHECK_TABLE
                , PROBLEM_TYPE
                , CHECK_DATA
                , PROBLEM_SEQ
                , PROBLEM_DATA
                , PROBLEM_LIST
                , REFERENCE_TABLE
                , CHECK_UI
                , PROBLEM_DESCRIPTION
                , INSERT_ID
                , INSERT_TIME
              )                
           SELECT  DISTINCT
                    COMPANY_ID
                  , DIVISION_ID
                  , SITE_ID
                  , PLANT_ID
                  , @plan_date PLAN_DATE
                  , @validation_seq + ROW_NUMBER() OVER (ORDER BY SEQ) AS VALIDATION_SEQ
                  , INSTANCE_ID
                  , ITEM_ID AS TOP_ITEM_ID
                  , 22 AS CHECK_SEQ
                  , 'Measure Conversion' AS CHECK_CATEGORY
                  , 'SCM_ITEM_CONV_CALC_M' AS CHECK_TABLE
                  , 'Measure Conversion' PROBLEM_TYPE
                  , 'Measure Conversion' CHECK_DATA
                  , DENSE_RANK() OVER  (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID--, TARGET_TYPE
                                        ORDER     BY FACTORY_ID ) AS PROBLEM_SEQ
                  , PARENT_ITEM_ID AS PROBLEM_DATA
                  , 'ITEM_ID = '''+PARENT_ITEM_ID+''', FACTORY_ID = '''+FACTORY_ID+'''' AS PROBLEM_LIST
                  , 'SCM_ITEM_EQUIP_RATE_BATCH_M' AS REFERENCE_TABLE
                  , 'Measure Conversion' CHECK_UI
                  , PROBLEM_REASON AS  PROBLEM_DESCRIPTION
                  --, '' SQL_QUERY
                  , @v_proc_name AS INSERT_ID
                  , @sysdate AS INSERT_TIME
            FROM   (
                    SELECT DISTINCT
                           A.*--, B.FACTORY_ID
                         , --'Item : ' + A.PARENT_ITEM_ID+' Factory : '+B.FACTORY_ID+' Prod_version_type : '+B.PROD_VERSION_TYPE + '  - ' +
                           --CASE WHEN ISNULL(C.CNT, 0) < 4 THEN N'Please check Model Measure Conversion.'
                           CASE WHEN C.MODEL_ID IS NULL THEN N'Please check Model Measure Conversion.' + ' - ' +  A.PARENT_ITEM_ID
                           END  AS PROBLEM_REASON
                         , 0 AS SEQ
                    FROM   (
                            /*SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, INSTANCE_ID, ITEM_ID, PARENT_ITEM_ID, PARENT_FLOW_ID
                            FROM   TH_BUF_SCM_VALIDATION_CHECK
                            WHERE  SHOP_GROUP_ID = 'E1'
                            GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, INSTANCE_ID, ITEM_ID, PARENT_ITEM_ID, PARENT_FLOW_ID*/
                            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.ITEM_ID, A.PARENT_ITEM_ID, A.PARENT_FLOW_ID, C.FACTORY_ID, C.PROD_VERSION_TYPE
                            FROM   TH_BUF_SCM_VALIDATION_CHECK A,
                               SCM_ITEM_LINE_ASSIGN_M B,
                               SCM_LINE_M C
                            WHERE  A.SHOP_GROUP_ID = 'E1'
                            AND    A.DIVISION_ID = B.DIVISION_ID
                            AND    A.SITE_ID = B.SITE_ID
                            AND    A.PLANT_ID = B.PLANT_ID
                            AND    A.ITEM_ID = B.ITEM_ID
                            AND    A.PARENT_ITEM_ID = B.ITEM_ID
                            AND    B.LINE_ID = C.LINE_ID
                            AND    B.ELECTRODE_TYPE = C.ELECTRODE_TYPE        
                            AND    B.OPERATION_ID = 'E2000'
                            AND    B.OPERATION_ID = C.OPERATION_ID
                            GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.ITEM_ID, A.PARENT_ITEM_ID, A.PARENT_FLOW_ID, C.FACTORY_ID, C.PROD_VERSION_TYPE
                           ) A
                           INNER JOIN (
                                        SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, PROD_VERSION_TYPE
                                        FROM   SCM_LINE_M A
                                        WHERE  ACTIVE_FLAG = 'Y'
                                        AND    OPERATION_ID = 'E2000'
                                        GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, PROD_VERSION_TYPE
                                      ) B
                                ON    B.COMPANY_ID        = A.COMPANY_ID
                                AND   B.DIVISION_ID       = A.DIVISION_ID
                                AND   B.SITE_ID           = A.SITE_ID
                                AND   B.PLANT_ID          = A.PLANT_ID
                                AND   B.FACTORY_ID        = A.FACTORY_ID
                                AND   CHARINDEX(B.OPERATION_ID, A.PARENT_FLOW_ID) > 0
                                AND   B.PROD_VERSION_TYPE = A.PROD_VERSION_TYPE
                           LEFT OUTER HASH JOIN (
                                          SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, VERSION_TYPE
                                                 , MIN(MODEL_ID) AS MODEL_ID
                                            FROM   (
                                                    SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, VERSION_TYPE
                                                         , COUNT(1) AS CNT
                                                    FROM   SCM_ITEM_CONV_CALC_M A
                                                    WHERE  A.MAX_VER_FLAG = 'Y'
                                                    AND    A.VALUE        > 0
                                                    AND    EXISTS (
                                                                    SELECT 1
                                                                    FROM   FP_INSTANCE_CONFIG_M X
                                                                    WHERE  X.INSTANCE_ID  = 'COMMON'
                                                                    AND    X.CATEGORY_ID  = 'ITEM_CONV_CALC'
                                                                    AND    X.KEY_ID       = 'CATEGORY'
                                                                    AND    X.PART_ID      = A.OPERATION
                                                                    AND    X.KEY_VALUE    = A.CATEGORY
                                                                  )
                                                    GROUP  BY
                                                           COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE , VERSION_TYPE
                                                ) A
                                                 , (
                                                    SELECT PART_ID AS OPERATION_ID
    , COUNT(1) AS CNT
                                                    FROM   FP_INSTANCE_CONFIG_M A
                                                    WHERE  A.INSTANCE_ID  = 'COMMON'
                                                    AND    A.CATEGORY_ID  = 'ITEM_CONV_CALC'
                                                    AND    A.KEY_ID       = 'CATEGORY'
                                                    GROUP  BY PART_ID
                                                   ) B
                                            WHERE  A.CNT = B.CNT
                                            GROUP  BY
                                                   COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, VERSION_TYPE
                                            /*
                                            SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE
                                                 , COUNT(1) AS CNT
                                            FROM   SCM_ITEM_CONV_CALC_M A
                                            WHERE  A.MAX_VER_FLAG       = 'Y'
                                            AND    OPERATION = 'E2000'
                                            AND    ISNULL(VALUE, 0) > 0
                                            AND    CATEGORY IN ( 
                                                                 'Jumbo Roll (cell/m)'
                                                               , 'Lane Number'
                                                               , 'cell/batch'
                                                               , 'Jumbo Roll (m/batch)'
                                                               )
                                            GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE
                                            */
                                           ) C
                                ON    C.COMPANY_ID        = B.COMPANY_ID
                                AND   C.DIVISION_ID       = B.DIVISION_ID
                                AND   C.SITE_ID           = B.SITE_ID
                                AND   C.PLANT_ID          = B.PLANT_ID
                                AND   C.FACTORY_ID        = B.FACTORY_ID
                                AND   C.OPERATION         = B.OPERATION_ID
                                AND   C.PROD_VERSION_TYPE = B.PROD_VERSION_TYPE
                                AND   C.ITEM_ID           = A.PARENT_ITEM_ID
                    --WHERE  ISNULL(C.CNT, 0) < 4
                    WHERE  C.MODEL_ID IS NULL
                   ) A
                   
          SET @n_row_count = @@ROWCOUNT
        
          SET @validation_seq += @n_row_count
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, nulll   
        
        END
        
        BEGIN
        
          SET @v_table_name = 'TH_BUF_MASTER_VALIDATION_RESULT'

          -----------------------------------------------------------------
          -- 남경 소형 원/각 ITEM인 경우 CN_CELL_M2 / CN_CELL_M3에서 삭제 
          DELETE  TH_BUF_MASTER_VALIDATION_RESULT
          FROM  TH_BUF_MASTER_VALIDATION_RESULT A,
                SCM_ITEM_M B
          WHERE  1=1
          AND    A.PLAN_DATE = @plan_date
          AND    A.INSTANCE_ID LIKE 'CN_CELL%'
          AND    B.DIVISION_ID = '40'
      AND    B.SITE_ID = 'A002'
          AND    A.TOP_ITEM_ID = B.ITEM_ID
          AND    B.FLOW_ID = 'A3000'
          AND    A.INSTANCE_ID != 'CN_CELL_M'
          
          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null


          -----------------------------------------------------------------
          -- 남경 소형 원/각 ITEM이 아닌 경우 삭제
          DELETE  TH_BUF_MASTER_VALIDATION_RESULT
          FROM  TH_BUF_MASTER_VALIDATION_RESULT A,
                SCM_ITEM_M B
          WHERE  1=1
          AND    A.PLAN_DATE = @plan_date
          AND    A.INSTANCE_ID LIKE 'CN_CELL%'
          AND    B.DIVISION_ID = '40'
          AND    B.SITE_ID = 'A002'
          AND    A.TOP_ITEM_ID = B.ITEM_ID
          AND    B.FLOW_ID = 'A9000'
          AND    A.INSTANCE_ID = 'CN_CELL_M'
          
          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null


          -----------------------------------------------------------------
          -- POUCH와 SF 를 구분하여 비해당 정보 삭제
          DELETE  TH_BUF_MASTER_VALIDATION_RESULT
          FROM  TH_BUF_MASTER_VALIDATION_RESULT A,
                (    
                SELECT  *
                FROM  TH_BUF_MASTER_VALIDATION_RESULT
                WHERE  1=1
                AND    PLAN_DATE = @plan_date
                AND    INSTANCE_ID LIKE 'CN_CELL%'
                --AND    TOP_ITEM_ID = 'MCF466272A10'
                EXCEPT
                SELECT  DISTINCT A.*--B.INSTANCE_ID, A.*, B.INSTANCE_ID
                FROM  TH_BUF_MASTER_VALIDATION_RESULT A
                    LEFT OUTER JOIN FP_INSTANCE_ITEM_V B
                    ON   A.COMPANY_ID = B.COMPANY_ID
                    AND  A.DIVISION_ID = B.DIVISION_ID
                    AND A.SITE_ID = B.SITE_ID
                    AND  A.TOP_ITEM_ID = B.TOP_ITEM_ID
                WHERE  1=1
                AND    A.PLAN_DATE = @plan_date
                AND    A.INSTANCE_ID LIKE 'CN_CELL%'
                AND    (A.INSTANCE_ID = B.INSTANCE_ID OR B.INSTANCE_ID IS NULL) 
                --AND    A.TOP_ITEM_ID = 'MCF466272A10'
                ) B
            WHERE  1=1
            AND    A.VALIDATION_SEQ = B.VALIDATION_SEQ
          
          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
          
          -------------
          /*
            FORMATION_PACK_EXCEPT_ITEM 에 정의된 ITEM은 Validation 대상아님.
          */
          
          DELETE  TH_BUF_MASTER_VALIDATION_RESULT
          FROM  TH_BUF_MASTER_VALIDATION_RESULT A,
                SCM_SYS_LOOKUP_VALUE B
          WHERE  1=1
          AND	  charindex('FORM' , @v_master_id  ) > 0  
          AND    A.PLAN_DATE = @plan_date
          AND    B.LOOKUP_TYPE_CODE ='FORMATION_PACK_EXCEPT_ITEM'
          AND    A.SITE_ID = B.SEGMENT1
          AND    A.DIVISION_ID = B.SEGMENT2
          AND    A.PROBLEM_DATA = B.SEGMENT3
          
          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null                


          -- 동일 사유이나 TOP_ITEM_ID 가 다른 경우 여러개 나와서 1개만 남기고 삭제 처리한다.
          DELETE FROM A
          FROM   TH_BUF_MASTER_VALIDATION_RESULT A
               , (
                  SELECT A.*
                       , DENSE_RANK() OVER (PARTITION BY A.PLAN_DATE
                                                       , A.INSTANCE_ID
  , A.CHECK_SEQ
                                                       , A.PROBLEM_DATA
                                                       , A.PROBLEM_DESCRIPTION
                                            ORDER     BY ISNULL(B.FLOW_ID, '00000') DESC
                                                       , A.TOP_ITEM_ID
                                                       , A.VALIDATION_SEQ) SEQ
                  FROM   TH_BUF_MASTER_VALIDATION_RESULT A
                         LEFT OUTER JOIN SCM_ITEM_M B
                              ON    A.COMPANY_ID  = B.COMPANY_ID
                              AND   A.DIVISION_ID = B.DIVISION_ID
                              AND   A.SITE_ID     = B.SITE_ID
                              AND   A.TOP_ITEM_ID = B.ITEM_ID
                  WHERE  A.PLAN_DATE = @plan_date
                 ) B
          WHERE  B.SEQ            > 1
          AND    A.COMPANY_ID     = B.COMPANY_ID
          AND    A.DIVISION_ID    = B.DIVISION_ID
          AND    A.SITE_ID        = B.SITE_ID
          AND    A.PLANT_ID       = B.PLANT_ID
          AND    A.PLAN_DATE      = B.PLAN_DATE
          AND    A.VALIDATION_SEQ = B.VALIDATION_SEQ

          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null  
          
          DELETE TH_BUF_MASTER_VALIDATION_RESULT
          WHERE 1=1
          AND PLAN_DATE = @plan_date
          AND INSTANCE_ID LIKE '%CELL'
          AND PROBLEM_DATA LIKE 'APC%'

          SET @n_row_count = @@ROWCOUNT
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null     

        END
        
		-- UI : FN_GET_REQ_QTY_MODEL  대체 / 프로시져는 자체 생성 에 따른 데이터 생성 제외 20190904 by cys
/**
        BEGIN
        
          SET @v_table_name = 'FP_ITEM_CELL_EXCHANGE_M'

          DELETE FROM FP_ITEM_CELL_EXCHANGE_M
          
          INSERT INTO FP_ITEM_CELL_EXCHANGE_M
               (
                 COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , MODEL_ID
               , ITEM_ID
               , APPLIED_MODEL
               , ACCUMULATED_CHILD_QTY
               , INSERT_ID
               , INSERT_TIME
               )
          SELECT DISTINCT
                 COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , MODEL_ID
               , ITEM_ID
               , NULL                       AS APPLIED_MODEL
               , MAX(ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
               , @v_proc_name               AS INSERT_ID
               , GETDATE()                  AS INSERT_TIME
          FROM   (
							  SELECT MCT.COMPANY_ID, MCT.DIVISION_ID, MCT.SITE_ID, MCT.PLANT_ID, MCT.MODEL_ID
								   , MCT.CHILD_ITEM_ID                    AS ITEM_ID
								   , MCT.CHILD_COMPANY_ID, MCT.CHILD_DIVISION_ID, MCT.CHILD_SITE_ID
								   , MAX(SIM.APPLIED_MODEL)               AS APPLIED_MODEL
								   , SUM(MCT.ACCUMULATED_CHILD_QTY)       AS ACCUMULATED_CHILD_QTY  -- 누적 소요량
								   , MAX(ICM.CLASS_ID)                    AS CLASS_ID
								   , MAX(ICM.CLASS_NAME)                  AS CLASS_NAME
							  FROM   SCM_ITEM_M              MIM
								   , SCM_ITEM_CLASS_M       ICM
								   , SCM_ITEM_CLASS_LEVEL_M ILCM
								   , SCM_ITEM_M             SIM
								   , SCM_MODEL_COMP_TEMP    MCT
							  WHERE  MCT.MODEL_ID          = MIM.ITEM_ID
							  AND    MCT.COMPANY_ID        = MIM.COMPANY_ID
							  AND    MCT.DIVISION_ID       = MIM.DIVISION_ID
							  AND    MCT.SITE_ID           = MIM.SITE_ID
							  AND    MCT.CHILD_ITEM_ID     = SIM.ITEM_ID
							  AND    MCT.CHILD_COMPANY_ID  = SIM.COMPANY_ID
							  AND    MCT.CHILD_DIVISION_ID = SIM.DIVISION_ID
							  AND    MCT.CHILD_SITE_ID     = SIM.SITE_ID
							  AND    MIM.ITEM_CLASS        = ICM.CLASS_ID
							  AND    ICM.LEVEL_3_ID        = ILCM.LEVEL_ID
							  AND    ISNULL(ILCM.OPERATION_GROUP_ID, '') != ''
							  AND    (SIM.FLOW_ID != 'A2000' OR SIM.FLOW_ID IS NULL)  -- BOM ECO 적용일 이전 FP 계획 수립 대응(A2000 – A3000)   ADD 2019.06.17
			--                  AND    MCT.ALT_PRIORITY = 'Y'
							  AND    MCT.PLANT_ID = (SELECT MAX(MCTI.PLANT_ID)
													 FROM   SCM_MODEL_COMP_TEMP MCTI
													 WHERE  MCTI.DIVISION_ID = MCT.DIVISION_ID
													 AND    MCTI.SITE_ID     = MCT.SITE_ID
													 AND    MCTI.COMPANY_ID  = MCT.COMPANY_ID) -- 3050, A011 중복 조회 방지
							  GROUP  BY MCT.COMPANY_ID, MCT.DIVISION_ID, MCT.SITE_ID, MCT.PLANT_ID, MCT.MODEL_ID,
										MCT.CHILD_ITEM_ID, MCT.CHILD_COMPANY_ID, MCT.CHILD_DIVISION_ID, MCT.CHILD_SITE_ID
							UNION ALL -- BOM ECO 적용일 이전 FP 계획 수립 대응(A2000 – A3000)   ADD 2019.06.17
								SELECT	MCT.COMPANY_ID, MCT.DIVISION_ID, MCT.SITE_ID, MCT.PLANT_ID, MCT.MODEL_ID
										   , MCT.CHILD_ITEM_ID                    AS ITEM_ID
										   , MCT.CHILD_COMPANY_ID, MCT.CHILD_DIVISION_ID, MCT.CHILD_SITE_ID
										   , MAX(SIM.APPLIED_MODEL)               AS APPLIED_MODEL
										   , SUM(MCT.ACCUMULATED_CHILD_QTY)       AS ACCUMULATED_CHILD_QTY  -- 누적 소요량
										   , MAX(ICM.CLASS_ID)                    AS CLASS_ID
										   , MAX(ICM.CLASS_NAME)                  AS CLASS_NAME
								  FROM   SCM_ITEM_M              MIM
										   , SCM_ITEM_CLASS_M       ICM
										   , SCM_ITEM_CLASS_LEVEL_M ILCM
										   , SCM_ITEM_M             SIM
										   , SCM_MODEL_COMP_EFFECTIVE_DATE    MCT
								  WHERE  MCT.MODEL_ID          = MIM.ITEM_ID
								  AND    MCT.COMPANY_ID        = MIM.COMPANY_ID
								  AND    MCT.DIVISION_ID       = MIM.DIVISION_ID
								  AND    MCT.SITE_ID           = MIM.SITE_ID
								  AND    MCT.CHILD_ITEM_ID     = SIM.ITEM_ID
								  AND    MCT.CHILD_COMPANY_ID  = SIM.COMPANY_ID
								  AND    MCT.CHILD_DIVISION_ID = SIM.DIVISION_ID
								  AND    MCT.CHILD_SITE_ID     = SIM.SITE_ID
								  AND    MIM.ITEM_CLASS        = ICM.CLASS_ID
								  AND    ICM.LEVEL_3_ID        = ILCM.LEVEL_ID
								  AND    ISNULL(ILCM.OPERATION_GROUP_ID, '') != ''
								  AND    (MIM.FLOW_ID = 'A3000' AND  SIM.FLOW_ID = 'A2000')
								  AND    MCT.EFF_END_DATE >= GETDATE()
								  AND    MCT.PLANT_ID = (SELECT MAX(MCTI.PLANT_ID)
																 FROM   SCM_MODEL_COMP_EFFECTIVE_DATE MCTI
																 WHERE  MCTI.DIVISION_ID = MCT.DIVISION_ID
																 AND    MCTI.SITE_ID     = MCT.SITE_ID
																 AND    MCTI.COMPANY_ID  = MCT.COMPANY_ID) -- 3050, A011 중복 조회 방지
								  GROUP  BY MCT.COMPANY_ID, MCT.DIVISION_ID, MCT.SITE_ID, MCT.PLANT_ID, MCT.MODEL_ID,
											MCT.CHILD_ITEM_ID, MCT.CHILD_COMPANY_ID, MCT.CHILD_DIVISION_ID, MCT.CHILD_SITE_ID
                 ) A
          GROUP  BY
                 COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, ITEM_ID
          /*
          SELECT DISTINCT
                 COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , MODEL_ID
               , ITEM_ID
               , APPLIED_MODEL
               , ACCUMULATED_CHILD_QTY
               , @v_proc_name             AS INSERT_ID
               , GETDATE()                AS INSERT_TIME
          FROM   (
                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, ITEM_ID, APPLIED_MODEL, ACCUMULATED_CHILD_QTY,
                         -- 20171121
                         --RANK() OVER (PARTITION BY DIVISION_ID, ITEM_ID ORDER BY ACCUMULATED_CHILD_QTY, MODEL_ID, SITE_ID, PLANT_ID) AS RNK
                         RANK() OVER (PARTITION BY SITE_ID, DIVISION_ID, ITEM_ID ORDER BY ACCUMULATED_CHILD_QTY, MODEL_ID, SITE_ID, PLANT_ID) AS RNK
                  FROM (SELECT MCT.COMPANY_ID, MCT.DIVISION_ID, MCT.SITE_ID, MCT.PLANT_ID, MCT.MODEL_ID,
                               MCT.CHILD_ITEM_ID AS ITEM_ID, MCT.CHILD_COMPANY_ID, MCT.CHILD_DIVISION_ID, MCT.CHILD_SITE_ID, MAX(SIM.APPLIED_MODEL) AS APPLIED_MODEL,
                               SUM( MCT.ACCUMULATED_CHILD_QTY)     AS ACCUMULATED_CHILD_QTY, -- 누적 소요량
                               MAX(ICM.CLASS_ID) AS CLASS_ID,
                               MAX(ICM.CLASS_NAME) AS CLASS_NAME
                        FROM   SCM_ITEM_M             MIM
                               ,SCM_ITEM_CLASS_M       ICM
                               ,SCM_ITEM_CLASS_LEVEL_M ILCM
                               ,SCM_ITEM_M             SIM
                               ,SCM_MODEL_COMP_TEMP    MCT
                        WHERE  MCT.MODEL_ID          = MIM.ITEM_ID
                        AND    MCT.COMPANY_ID        = MIM.COMPANY_ID
                        AND    MCT.DIVISION_ID       = MIM.DIVISION_ID
                        AND    MCT.SITE_ID           = MIM.SITE_ID
                        AND    MCT.CHILD_ITEM_ID     = SIM.ITEM_ID
                        AND    MCT.CHILD_COMPANY_ID  = SIM.COMPANY_ID
                        AND    MCT.CHILD_DIVISION_ID = SIM.DIVISION_ID
                        AND    MCT.CHILD_SITE_ID     = SIM.SITE_ID
                        AND    MIM.ITEM_CLASS        = ICM.CLASS_ID
                        AND    ICM.LEVEL_3_ID        = ILCM.LEVEL_ID
                        AND    ISNULL(ILCM.OPERATION_GROUP_ID, '') != ''
                        AND    MCT.ALT_PRIORITY = 'Y'
                        AND    MCT.PLANT_ID = (SELECT MAX(MCTI.PLANT_ID)
                                               FROM   SCM_MODEL_COMP_TEMP MCTI
                                               WHERE  MCTI.DIVISION_ID = MCT.DIVISION_ID
                                               AND    MCTI.SITE_ID     = MCT.SITE_ID
                                               AND    MCTI.COMPANY_ID  = MCT.COMPANY_ID) -- 3050, A011 중복 조회 방지
                    GROUP  BY MCT.COMPANY_ID, MCT.DIVISION_ID, MCT.SITE_ID, MCT.PLANT_ID, MCT.MODEL_ID,
                              MCT.CHILD_ITEM_ID, MCT.CHILD_COMPANY_ID, MCT.CHILD_DIVISION_ID, MCT.CHILD_SITE_ID) A
                 ) A
          WHERE RNK = 1
          */

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END
   */

        BEGIN
          
          SET @v_table_name = 'FP_MASTER_VALIDATION_H'

          DELETE FROM FP_MASTER_VALIDATION_H
          WHERE PLAN_DATE = @plan_date

          INSERT INTO FP_MASTER_VALIDATION_H
                (
                  COMPANY_ID
                , DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , PLAN_DATE
                , VALIDATION_SEQ
                , INSTANCE_ID
                , TOP_ITEM_ID
                , CHECK_SEQ
                , CHECK_CATEGORY
                , CHECK_TABLE
                , PROBLEM_TYPE
                , CHECK_DATA
                , PROBLEM_SEQ
                , PROBLEM_DATA
                , PROBLEM_LIST
                , REFERENCE_TABLE
                , CHECK_UI
                , PROBLEM_DESCRIPTION
                --, SQL_QUERY
                , INSERT_ID
                , INSERT_TIME
                )
      SELECT  COMPANY_ID
                , DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , PLAN_DATE
, VALIDATION_SEQ
                , MAX(INSTANCE_ID)          AS INSTANCE_ID
                , MAX(TOP_ITEM_ID)          AS TOP_ITEM_ID
                , MAX(CHECK_SEQ)            AS CHECK_SEQ
                , MAX(CHECK_CATEGORY)       AS CHECK_CATEGORY
                , MAX(CHECK_TABLE)          AS CHECK_TABLE
                , MAX(PROBLEM_TYPE)         AS PROBLEM_TYPE
                , MAX(CHECK_DATA)           AS CHECK_DATA
                , MAX(PROBLEM_SEQ)          AS PROBLEM_SEQ
                , MAX(PROBLEM_DATA)         AS PROBLEM_DATA
                , MAX(PROBLEM_LIST)         AS PROBLEM_LIST
                , MAX(REFERENCE_TABLE)      AS REFERENCE_TABLE
                , MAX(CHECK_UI)             AS CHECK_UI
                , MAX(PROBLEM_DESCRIPTION)  AS PROBLEM_DESCRIPTION
                --, SQL_QUERY
                ,@v_proc_name AS  INSERT_ID
                ,GETDATE()  AS INSERT_TIME
          FROM   TH_BUF_MASTER_VALIDATION_RESULT
          GROUP  BY
                 COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , PLAN_DATE
               , VALIDATION_SEQ
               
          SET @n_row_count = @@ROWCOUNT     
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, nulll
        
        END

      END
      
      IF @@TRANCOUNT > 0
        COMMIT WORK 
    END
    
  END TRY

  BEGIN CATCH
    --ROLLBACK

    -- 에러나도 로그는 인서트
    SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
    SET @v_descr = ERROR_MESSAGE()
    EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   999999, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END