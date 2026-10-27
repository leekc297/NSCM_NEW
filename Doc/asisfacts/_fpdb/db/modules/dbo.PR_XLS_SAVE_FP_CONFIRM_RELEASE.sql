
/*
 * Program ID   : PR_XLS_SAVE_FP_CONFIRM_RELEASE
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.09.23   FP Pjt.         Create.
 * 
 * 
 ex) 
  exec PR_XLS_SAVE_FP_CONFIRM_RELEASE 'crjung', 'UC_E_PRE_A', 'UC_E_PRE_A-20240904-08', 'UC1'
 */

CREATE PROCEDURE [dbo].[PR_XLS_SAVE_FP_CONFIRM_RELEASE]
	@p_user_id					NVARCHAR(MAX)    
, 	@p_instance_id				NVARCHAR(MAX) 
,   @p_fp_plan_id               nvarchar(max)
,   @p_apl_code					nvarchar(max)
,   @p_return					NVARCHAR(max) = NULL OUTPUT

AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_user_id			nvarchar(max)
	DECLARE @v_instance_id		nvarchar(max)
	DECLARE @v_fp_plan_id		nvarchar(max)
	DECLARE @v_apl_code		    nvarchar(50)

	DECLARE @INX				INT				= 0;
    DECLARE @MAX_NUM			INT				= 0;

	set @v_user_id				= @p_user_id
	set @v_instance_id          = @p_instance_id
	set @v_fp_plan_id			= @p_fp_plan_id
	set @v_apl_code				= @p_apl_code

	declare @INVALID_COUNT      int
	declare @INVALID_MSG        nvarchar(max)
	declare @v_start_date		nvarchar(10) 
	declare @v_end_date			nvarchar(10)

	declare	@v_company_id		nvarchar(50)
	declare	@v_division_id		NVARCHAR(50) 
	declare	@v_site_id			nvarchar(50)
	declare	@v_plant_id			nvarchar(50)
	declare @v_elec_plant_id	nvarchar(50)

	declare @v_factory_id       nvarchar(50)
	declare @v_release_plan_id  nvarchar(50)

	if object_id('tempdb..#FACTORY_ID') is not null
		drop table #FACTORY_ID

	CREATE TABLE #FACTORY_ID (
	       TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
		 , FACTORY_ID               nvarchar(50)
 		 )


	BEGIN TRY		

		select @v_company_id		= attribute1
			 , @v_division_id		= attribute2
			 , @v_site_id			= attribute3
			 , @v_plant_id			= attribute4
			 , @v_elec_plant_id		= attribute5
		  from dbo.SCM_SYS_LOOKUP_VALUE with(nolock)
		where lookup_type_code = 'XLS_PLAN_APL_PLANT'
		  and segment1 = @v_apl_code
		  and active_flag = 'Y'

		--기준일 설정
		SET @v_start_date = Format(dbo.FN_SITE_TIME(@v_site_id), 'yyyyMMdd')

		SELECT @v_start_date = CASE WHEN FORMAT(dbo.FN_SITE_TIME(@v_site_id) ,'yyyyMMddHHmmss') < (@v_start_date + A.BASIS_START_TIME ) THEN CONVERT(VARCHAR,DATEADD(DD,-1, @v_start_date ), 112)
			                        ELSE @v_start_date
					            END
	     FROM FP_INSTANCE_START_TIME_V A  
        WHERE A.INSTANCE_ID = 'UC_E_PRE_A'


		-- 인스턴스에 해당하는 동 정보 조회 : 배포할 목록 리스트
		insert into #FACTORY_ID (factory_id)
		select FACTORY_ID
		  from (
		        SELECT '' As CHK
				     , AA.INSTANCE_ID
					 , @v_start_date AS PLAN_DATE
					 , AA.DIVISION_ID 
		             , AA.DIVISION_NAME
					 , AA.SITE_ID
					 , AA.FACTORY_ID
					 , AA.FACTORY_NAME  
		             , AA.FLAG
					 , AA.INSERT_TIME
					 , AA.RELEASE_TIME
					 , AA.IS_ENABLE_REL 
		             , BB.PLAN_ID
					 , BB.CONFIRM_ID
					 , BB.CONFIRM_TIME
					 , BB.CONFIRM_FLAG  
		             , BB.DESCRIPTION                                   
		             , CASE WHEN R.INSTANCE_ID IS NULL  THEN 'N'      
		                    WHEN AA.IS_ENABLE_REL = 'N' THEN 'N'    
		                    ELSE (CASE WHEN (                           
		                                     SELECT DISTINCT 1 AS _VAL  
		                                       FROM HIS_FP_PLAN_DETAIL_H HHH           
		                                      WHERE AA.INSTANCE_ID   = HHH.INSTANCE_ID 
		                                      AND   AA.DIVISION_ID   = HHH.DIVISION_ID 
		                                      AND   AA.FACTORY_ID    = HHH.FACTORY_ID  
		                                      AND   HHH.PLAN_DATE    = @v_start_date   
		                                      AND   HHH.INSTANCE_ID  = @v_instance_id 
		                                      AND   HHH.PLAN_ID      = @v_fp_plan_id     
		                                    ) IS NULL THEN 'Y' 
									  ELSE 'N' END) 
							END AS ISENABLE  
		             , CASE WHEN BB.PLAN_ID IS NOT NULL AND BB.CONFIRM_FLAG='Y' THEN '0' ELSE '0' END ISCHK 
		          FROM (                                              
		    	        SELECT DISTINCT A.INSTANCE_ID, B.DIVISION_ID 
		  	                 , '('+B.DIVISION_ID+')'+DBO.FN_GETNAME_DIVISION(B.COMPANY_ID,B.DIVISION_ID) AS DIVISION_NAME 
		    	             	,B.FACTORY_ID, '('+B.FACTORY_ID+')'+B.FACTORY_NAME AS FACTORY_NAME 
		  		             , 'BUILDING' AS FLAG, C.INSERT_TIME, D.RELEASE_TIME    
		                     , (CASE WHEN D.RELEASE_TIME IS NULL THEN 'Y'          
		                              WHEN C.INSERT_TIME < D.RELEASE_TIME THEN 'N' 
		                              ELSE 'Y' END) AS IS_ENABLE_REL    
		                     , B.SITE_ID                                 
		    	          FROM FP_INSTANCE_FACTORY_M A(NOLOCK)        
		    	               INNER JOIN SCM_FACTORY_M B(NOLOCK)          
		    	            ON A.FACTORY_ID=B.FACTORY_ID        
		                       LEFT OUTER JOIN (	                                        
		                             SELECT MAX(INSERT_TIME) AS INSERT_TIME 
		                             FROM   SCM_FP_PLAN_H A	                
		                             WHERE  A.INSTANCE_ID = @v_instance_id 
		                             AND    A.PLAN_ID     = @v_fp_plan_id     
		  					   ) C   
		                    ON 1 = 1       
		                       LEFT OUTER JOIN (    
		                             SELECT B.FACTORY_ID, MAX(B.RELEASE_TIME) AS RELEASE_TIME 
		                             FROM   HIS_FP_PLAN_DETAIL_H B                     
		                             WHERE  B.PLAN_DATE    = @v_start_date    
		                             AND    B.INSTANCE_ID  = @v_instance_id  
		                             AND    B.RELEASE_FLAG = 'Y'                     
		                             GROUP BY B.FACTORY_ID        
		  						) D                               
		                    ON A.FACTORY_ID    = D.FACTORY_ID        
		    	 WHERE A.INSTANCE_ID   = @v_instance_id 
		          AND   A.ACTIVE_FLAG  = 'Y'                    
		          AND   B.ACTIVE_FLAG  = 'Y'                    
		          AND   B.FACTORY_ID NOT IN (                     
		                                       SELECT SEGMENT1 AS FACTORY_ID                    
		                                       FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)       
		                                       WHERE  A.LOOKUP_TYPE_CODE = 'ABNORMAL_FACTORY' 
		                                       AND    A.ATTRIBUTE1 = 'Y'                      
		                                     ) 
		  ) AA                                 
		  LEFT OUTER JOIN SCM_FP_PLAN_DETAIL_H  BB(NOLOCK) 
		     ON  AA.DIVISION_ID = BB.DIVISION_ID           
		     AND AA.FACTORY_ID  = BB.FACTORY_ID            
		     AND BB.PLAN_DATE   = @v_start_date   
		     AND BB.INSTANCE_ID = @v_instance_id 
		  LEFT OUTER JOIN (                                
		                     SELECT DISTINCT R.INSTANCE_ID, R.FACTORY_ID      
		                     FROM   FP_USER_ROLE_INFO_V  R WITH(NOLOCK)       
		                     WHERE  R.USER_ID     = @v_user_id      
		                     AND    R.INSTANCE_ID = @v_instance_id  
		                     AND    R.SAVE_FLAG   = 'Y'                     
		) R                                  
		ON  AA.INSTANCE_ID = R.INSTANCE_ID 
		AND AA.FACTORY_ID  = R.FACTORY_ID  
		WHERE EXISTS (                        
		                  SELECT CC.ATTRIBUTE1  
		                  FROM   SCM_SYS_LOOKUP_VALUE  CC(NOLOCK)           
		                  WHERE  AA.INSTANCE_ID  = CC.SEGMENT1              
		                  AND    AA.FLAG         = CC.ATTRIBUTE1            
		                  AND    CC.LOOKUP_TYPE_CODE = 'INSTANCE_ID'      
		                  AND    CC.SEGMENT1     = @v_instance_id 
		               ) 
		) as x
		where x.ISENABLE = 'Y'


		SELECT @INX			= 1
			 , @MAX_NUM		= COUNT(*)
		  FROM #FACTORY_ID

		IF @MAX_NUM = 0
		BEGIN
		    SET @INVALID_MSG = N'ERR00 : No factory to release or check your authority.'
			RAISERROR  ( @INVALID_MSG, 16, 1 ); 
		END

		WHILE @INX <= @MAX_NUM
		BEGIN

			SET @v_factory_id			= null
			SET @v_release_plan_id		= null

			SELECT  @v_factory_id		= [FACTORY_ID]		
			   FROM #FACTORY_ID 
			  WHERE TID					= @INX

--------------------------------------- validation START -----------------------------------------------

			-- 엔진 실행중이면 중단
			SELECT @INVALID_COUNT = COUNT(*)
			  FROM FP_PLAN_STATUS_H A(NOLOCK)           
			 WHERE A.ACTIVE_FLAG = '1'                
			   AND A.INSTANCE_ID = @v_instance_id    
			;

			if @INVALID_COUNT > 0
			BEGIN
				SET @INVALID_MSG = N'Err01 : The engine is already running. - ' + @v_instance_id
				RAISERROR  ( @INVALID_MSG, 16, 1 ); 
			END

			-- 등록된 인스턴스가 RELEASE_LIMIT_YN = 'Y' 이면 중단
			SELECT @INVALID_COUNT = COUNT(*)
			  FROM SCM_SYS_LOOKUP_VALUE AS A WITH(NOLOCK) 
			WHERE A.LOOKUP_TYPE_CODE = N'CONTROL_PLAN_CREATE_RELEASE_BY_INSTANCE' 
			  AND A.ACTIVE_FLAG      = 'Y' 
			  and A.ATTRIBUTE6 = 'Y'  --RELEASE_LIMIT_YN
			  AND A.SEGMENT1 = @v_instance_id 
			;

			if @INVALID_COUNT > 0
			BEGIN
				SET @INVALID_MSG = N'Err02 : The instance is set to release limit - CONTROL_PLAN_CREATE_RELEASE_BY_INSTANCE LOOKUP (RELEASE_LIMIT_YN = Y)'
				RAISERROR  ( @INVALID_MSG, 16, 1 ); 
			END

			-- 동일 인스턴스 상에 배포 중이면 중단
			-- 동일 site 내에 배포 중인 인스턴스가 존재할 경우, 15분이후에는 배포가능하도록 처리
			SELECT @INVALID_COUNT = COUNT(*)
			  FROM (                                                     
				    SELECT A.*                                      
  					     , ( 
						    SELECT MAX(SITE_ID)                                
  						      FROM FP_INSTANCE_INFO_V AA WITH(NOLOCK)           
  						     WHERE A.INSTANCE_ID = AA.INSTANCE_ID ) AS SITE_ID  
				         , B.USER_NAME                                            
				      FROM FP_IS_RUNNING_RELEASE_H A WITH(NOLOCK)            
				           LEFT OUTER JOIN TH_UIS_USER_DETAIL B WITH(NOLOCK)        
				        ON A.INSERT_ID = B.USER_ID                           
				     WHERE A.ACTIVE_FLAG  = 'Y'                            
				       AND A.INSERT_TIME > DATEADD(MI, -15, GETDATE())       
			       ) A                                                        
			 WHERE A.SITE_ID IN (                                       
				                 SELECT MAX(AAA.SITE_ID)                                  
				                   FROM FP_INSTANCE_INFO_V AAA WITH(NOLOCK)               
				                  WHERE AAA.INSTANCE_ID = @v_instance_id              
			       )                                                          
			;

			if @INVALID_COUNT > 0
			BEGIN
				SET @INVALID_MSG = N'Err03 : There are other instances being released in site that belongs to your instance. Available for release after 15 minutes. '
				RAISERROR  ( @INVALID_MSG, 16, 1 ); 
			END

			-- 배포 락 설정 : 이후에 validaton 이 걸리거나 배포완료 시에 이 데이터를 삭제해줘야 락이 해제됨
			INSERT INTO FP_IS_RUNNING_RELEASE_H 
				(           
  				  INSTANCE_ID
				, RELEASE_TYPE
				, FP_PLAN_ID  
				, ACTIVE_FLAG
				, INSERT_ID
				, INSERT_TIME 
				)                                               
			SELECT *                                        
			  FROM (                                          
					SELECT @v_instance_id AS INSTANCE_ID
						 , @v_factory_id AS RELEASE_TYPE  
  						 , @v_fp_plan_id AS FP_PLAN_ID
						 , 'Y' AS ACTIVE_FLAG    
  						 , @v_user_id AS INSERT_ID
						 , GETDATE() AS INSERT_TIME 
				   ) A 
			;


			-- 동일 인스턴스, 동, plan id 로 배포된 내역이 존재하면 중단
			SELECT @INVALID_COUNT = COUNT(*)
			  FROM (             
					SELECT DISTINCT INSTANCE_ID, DIVISION_ID, FACTORY_ID, PLAN_ID 
					  FROM HIS_FP_PLAN_DETAIL_H    
					  where 1 = 1 
					  and INSTANCE_ID  = @v_instance_id
					  and DIVISION_ID  = @v_division_id
					  and FACTORY_ID   = @v_factory_id
					  and PLAN_ID      = @v_fp_plan_id
                   ) As x


			if @INVALID_COUNT > 0
			BEGIN
				SET @INVALID_MSG = N'Err04 : There is a release history based on instance_id, factory_id and plan_id'
				RAISERROR  ( @INVALID_MSG, 16, 1 ); 
			END


			-- 날짜구간 조회 : 뒤에 start, end date 에 들어감
			 SELECT @v_end_date = MAX(YYYYMMDD) --AS END_DATE            
			   FROM TH_UIS_CAL A WITH(NOLOCK)                                             
			  WHERE 1 = 1                                                                   
			    AND ISO_YYYYWW = (                                                           
				                  SELECT ISO_YYYYWW                                                      
				                    FROM TH_UIS_CAL A WITH(NOLOCK)                                       
				                   WHERE YYYYMMDD = CONVERT(VARCHAR, CONVERT( DATETIME, @v_start_date) 
						                                           + ( SELECT (ISNULL(A.ATTRIBUTE15,'10')-1) * 7                   
							                                             FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                    
							                                            WHERE A.LOOKUP_TYPE_CODE = 'INSTANCE_ID'                  
							                                              AND A.SEGMENT1 = @v_instance_id)
																   , 112)                   
				                 )                                                                      
			;


			-- CONFIRM_VALIDATION_1 : 기준정보 없으면 중단
			SELECT @INVALID_COUNT = COUNT(*)
			  FROM (   
				   SELECT DISTINCT 
						  A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID 
						, A.ITEM_ID, A.OPERATION_ID, A.FACTORY_ID, A.LINE_ID, CONVERT(NVARCHAR(6), A.PLAN_DATE, 112) AS MONTH 
						, CASE WHEN C.ACTIVE_FLAG IS NULL THEN N'ITEM_LINE_ASSIGN Noting' 
							   WHEN C.ACTIVE_FLAG = 'N' THEN N'ACTIVE_FLAG = N'         
							   WHEN C.PRIORITY NOT IN ( 1, 2, 3, 4, 5, 6, 7, 8 ) THEN N'PRIORITY CHECK : ' + ISNULL(CONVERT(NVARCHAR, C.PRIORITY), '') 
							   WHEN (A.PLAN_DATE <= A.REL_DATE AND F.EQUIPMENT_ID IS NULL AND A.EQUIP_VALIDATION='Y' AND (A.INSTANCE_ID NOT LIKE '%CELL%' AND A.INSTANCE_ID NOT LIKE '%PACK%') ) THEN N'EQUIPMENT  Nothing' 
						  END  AS ITEM_LINE_ASSIGN_CHECK 
						, CASE WHEN E.KEY_VALUE = 'DAILY_CAPA' THEN (CASE WHEN D.DAILY_CAPA IS NULL THEN N'Daily Capa Nothing' WHEN D.DAILY_CAPA <= 0 THEN N'Daily Capa = 0' END) 
							   WHEN E.KEY_VALUE = 'TACT_TIME' THEN (CASE WHEN D.TACT_TIME IS NULL THEN N'Tact Time Nothing' WHEN D.TACT_TIME <= 0 THEN N'Tact Time = 0' END) 
							   ELSE  '' END AS DAILY_CAPA_CHECK 
						, E.KEY_VALUE 
						, (CASE WHEN A.INSTANCE_ID LIKE '%E_PRE%' THEN (CASE WHEN ISNULL(A.OUT_QTY,0) >= 50 THEN N'Batch 50 over' ELSE NULL END) ELSE NULL END) AS QTY_CHECK 
				     FROM (             
							SELECT A.*, B.REL_DATE, B.EQUIP_VALIDATION 
							  FROM ( 
								     SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID 
								     	  , A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE , A.PLAN_DATE, A.OUT_QTY 
								       FROM FP_AMEND_PLAN_CELL_R A WITH(NOLOCK)      
								      WHERE A.INSTANCE_ID = @v_instance_id 
								        AND A.FP_PLAN_ID  = @v_fp_plan_id     
								        AND A.OUT_QTY > 0 
								      UNION ALL            
								     SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID 
								     	  , A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE, A.OUT_QTY                
								       FROM FP_AMEND_PLAN_PACK_R A WITH(NOLOCK)      
								      WHERE A.INSTANCE_ID = @v_instance_id 
								        AND A.FP_PLAN_ID  = @v_fp_plan_id     
								        AND A.OUT_QTY > 0 
								      UNION ALL 
								     SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID 
								     	  , A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE, A.OUT_QTY 
								       FROM FP_AMEND_PLAN_FORM_R A WITH(NOLOCK) 
								      WHERE A.INSTANCE_ID = @v_instance_id 
								        AND A.FP_PLAN_ID  = @v_fp_plan_id 
								        AND A.OUT_QTY > 0 
								      UNION ALL            
								     SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID          
								     	  , A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE, A.ADJUST_OUT_QTY_BATCH AS OUT_QTY 
								       FROM FP_AMEND_DAILY_PLAN_R A WITH(NOLOCK)     
								      WHERE A.INSTANCE_ID = @v_instance_id 
								        AND A.FP_PLAN_ID  = @v_fp_plan_id     
								        AND A.ADJUST_OUT_QTY_BATCH > 0               
								      UNION ALL            
								     SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID 
								     	  , A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE, SUM(A.JR_OUT_QTY) AS OUT_QTY 
								       FROM FP_PRODUCTION_PLAN_EQUIPMENT_EPOST_R A WITH(NOLOCK) 
								      WHERE 1 = 1 
								        AND A.INSTANCE_ID = @v_instance_id 
								        AND A.FP_PLAN_ID  = @v_fp_plan_id 
								        AND A.SHIFT IN (1,2) 
								        AND A.JR_OUT_QTY > 0 
								      GROUP BY A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID 
								     	  , A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE 
						           ) A,  
						           (     
							         SELECT DISTINCT   C.FACTORY_ID , C.LINE_ID, C.OPERATION_ID , C.ELECTRODE_TYPE   
							         	  , DATEADD(DAY, RELEASR_TERM, CONVERT(DATE, A.PLAN_START_TIME)) AS REL_DATE 
							         	  , B.EQUIP_VALIDATION 
							           FROM SCM_FP_PLAN_H  A   
							              , (                      
							         		 SELECT A.SEGMENT1     AS INSTANCE_ID, A.ATTRIBUTE1   AS PLAN_CATEGORY   
							         		 	  , B.SEGMENT2     AS FACTORY_ID, C.SEGMENT2     AS PLAN_GROUP       
							         		 	  , CONVERT(INT, ISNULL(B.SEGMENT3, C.SEGMENT3))     AS RELEASR_TERM 
							         		 	  , ISNULL(B.SEGMENT5, C.ATTRIBUTE3) AS EQUIP_VALIDATION 
							         		   FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                  
							         		 	    LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)  
							         		     ON B.LOOKUP_TYPE_CODE  = 'INSTANCE_FACTORY_RELEASE_TERM' 
							         		    AND B.SEGMENT1          = A.SEGMENT1   
							         		    AND A.ATTRIBUTE1        = 'BUILDING' 
							         		    AND B.ACTIVE_FLAG       = 'Y'        
							         		 	   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)          
							         		     ON C.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP' 
							         		    AND C.SEGMENT1          = A.SEGMENT1     
							         		    AND A.ATTRIBUTE1        = 'PLAN GROUP' 
							         		    AND C.ACTIVE_FLAG       = 'Y'          
							         		  WHERE A.LOOKUP_TYPE_CODE = 'INSTANCE_ID'           
							         		    AND A.SEGMENT1         = @v_instance_id  
								            ) B            
							              , SCM_LINE_M   C 
							          WHERE A.INSTANCE_ID  = @v_instance_id 
							            AND A.PLAN_ID      = @v_fp_plan_id     
							            AND ( 
							            		   ( B.PLAN_CATEGORY  = 'BUILDING' AND B.FACTORY_ID  = C.FACTORY_ID ) 
							            		OR ( B.PLAN_CATEGORY != 'BUILDING' AND B.PLAN_GROUP  = C.MODEL_TYPE ) 
							            	   ) 
						         ) B        
					         WHERE A.FACTORY_ID     = B.FACTORY_ID     
						       AND A.LINE_ID        = B.LINE_ID        
						       AND A.OPERATION_ID   = B.OPERATION_ID   
						       AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
						       AND A.PLAN_DATE BETWEEN @v_start_date AND @v_end_date 
					      ) A 
					      LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_M C WITH(NOLOCK) 
					   ON C.COMPANY_ID      = A.COMPANY_ID     
					  AND C.DIVISION_ID     = A.DIVISION_ID    
					  AND C.SITE_ID         = A.SITE_ID        
					  AND C.PLANT_ID        = A.PLANT_ID       
					  AND C.ITEM_ID         = A.ITEM_ID        
					  AND C.FACTORY_ID      = A.FACTORY_ID     
					  AND C.LINE_ID         = A.LINE_ID        
					  AND C.OPERATION_ID    = A.OPERATION_ID   
					  AND C.ELECTRODE_TYPE  = A.ELECTRODE_TYPE 
					  AND C.MONTH           = CONVERT(NVARCHAR(6), A.PLAN_DATE, 112) 
					      LEFT OUTER JOIN SCM_TACT_TIME_M D WITH(NOLOCK) 
					   ON D.COMPANY_ID      = A.COMPANY_ID     
					  AND D.DIVISION_ID     = A.DIVISION_ID    
					  AND D.SITE_ID         = A.SITE_ID        
					  AND D.PLANT_ID        = A.PLANT_ID       
					  AND D.ITEM_ID         = A.ITEM_ID        
					  AND D.FACTORY_ID      = A.FACTORY_ID     
					  AND D.LINE_ID         = A.LINE_ID        
					  AND D.OPERATION_ID    = A.OPERATION_ID   
					  AND D.ELECTRODE_TYPE  = A.ELECTRODE_TYPE 
					  AND D.MONTH           = CONVERT(NVARCHAR(6), A.PLAN_DATE, 112) 
					      INNER JOIN SCM_LINE_M B WITH(NOLOCK)       
					   ON A.FACTORY_ID     = B.FACTORY_ID     
					  AND A.LINE_ID        = B.LINE_ID        
					  AND A.OPERATION_ID   = B.OPERATION_ID   
					  AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
					      LEFT OUTER JOIN FP_INSTANCE_CONFIG_M E WITH(NOLOCK) 
					   ON A.INSTANCE_ID    = E.INSTANCE_ID        
					  AND E.KEY_ID         = 'FINAL_OP_CAPA'    
					      LEFT OUTER HASH JOIN SCM_EQUIPMENT_M F WITH(NOLOCK) 
					   ON F.COMPANY_ID      = B.COMPANY_ID     
					  AND F.DIVISION_ID     = B.DIVISION_ID    
					  AND F.SITE_ID         = B.SITE_ID        
					  AND F.PLANT_ID        = B.PLANT_ID       
					  AND F.FACTORY_ID      = B.FACTORY_ID     
					  AND F.LINE_ID         = B.LINE_ID        
					  AND F.OPERATION_ID    = B.OPERATION_ID   
					  AND F.ELECTRODE_TYPE  = B.ELECTRODE_TYPE 
					  AND F.ACTIVE_FLAG     = 'Y' 
					  AND F.EQUIPMENT_TYPE  = 'M' 
					WHERE A.INSTANCE_ID    = @v_instance_id 
					  AND A.FP_PLAN_ID     = @v_fp_plan_id     
					  AND A.FACTORY_ID = @v_factory_id 
					 UNION  ALL 
					SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID 
						 , A.CHILD_ITEM_ID  AS ITEM_ID 
						 , 'A6000' AS OPERATION_ID   
						 , A.FACTORY_ID                
						 , CASE WHEN A.LINE_ID = C.LINE_ID THEN A.LINE_ID 
								ELSE C.LINE_ID         
						   END  AS LINE_ID             
						 , MIN(A.PLAN_MONTH) AS MONTH  
						 , N'ITEM_LINE_ASSIGN Noting' AS ITEM_LINE_ASSIGN_CHECK 
						 , N''     AS DAILY_CAPA_CHECK 
						 , N''     AS KEY_VALUE 
						 , N''     AS QTY_CHECK 
					  FROM (                    
						    SELECT A.*           
							     , B.PRIORITY     
							     -- ???? : line assign ???? -> BOM priority 
							     , DENSE_RANK() OVER (PARTITION BY A.PLAN_DATE, A.ITEM_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.ALT_ID 
									 ORDER BY  (CASE WHEN ISNULL(B.PRIORITY, 99) IN ( 1, 2, 3, 4, 5, 6, 7, 8 ) THEN 1 ELSE 9 END), A.ALT_PRIORITY ) ITEM_SEQ 
						     FROM (                       
								   SELECT DISTINCT       
									      A.*             
									    , C.CHILD_ITEM_ID 
									    , CONVERT(NVARCHAR(6), PLAN_DATE, 112) AS PLAN_MONTH  
									    , C.ALT_ID, ISNULL(C.ALT_PRIORITY,99) AS ALT_PRIORITY 
								     FROM FP_AMEND_PLAN_CELL_R A WITH(NOLOCK) 
								          LEFT OUTER JOIN SCM_BOM_M C WITH(NOLOCK)   
								       ON A.COMPANY_ID    = C.COMPANY_ID       
								      AND A.DIVISION_ID   = C.DIVISION_ID      
								      AND A.SITE_ID       = C.SITE_ID          
								      AND A.PLANT_ID      = C.PLANT_ID         
								      AND A.ITEM_ID       = C.PARENT_ITEM_ID   
								      AND A.PLAN_DATE     >= C.EFF_START_DATE  
								      AND A.PLAN_DATE     <  C.EFF_END_DATE    
								          LEFT OUTER JOIN SCM_ITEM_M D WITH(NOLOCK)  
								       ON C.COMPANY_ID     = D.COMPANY_ID     
								      AND C.DIVISION_ID    = D.DIVISION_ID    
								      AND C.SITE_ID        = D.SITE_ID        
								      AND C.CHILD_ITEM_ID  = D.ITEM_ID        
								      AND D.ACTIVE_FLAG    = 'Y'            
								      AND D.ITEM_TYPE      = 'H'            
								      AND D.FLOW_ID        LIKE '%A6000%'   
								          LEFT OUTER JOIN SCM_ITEM_CLASS_M E WITH(NOLOCK)  
								       ON D.ITEM_CLASS     = E.CLASS_ID             
								      AND E.USE_FLAG       = 'Y'                  
								    WHERE A.INSTANCE_ID  = @v_instance_id 
								      AND A.FP_PLAN_ID   = @v_fp_plan_id     
								      AND A.FACTORY_ID = @v_factory_id 
								      AND A.OPERATION_ID = 'A7000' 
								      AND A.OUT_QTY      > 0         
								      AND E.USE_FLAG     = 'Y'     
								      AND CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN @v_start_date AND @v_end_date -- end date ?? ??... 20210518 
								      AND A.FACTORY_ID NOT IN ('AF','S4') 
								      AND EXISTS (          
											      SELECT 1 
												    FROM ( 
														SELECT B.SEGMENT1, ISNULL(MAX(B.ATTRIBUTE4), 'N') AS ACTIVE_FLAG 
														  FROM SCM_SYS_LOOKUP_TYPE_M A                 
															 , SCM_SYS_LOOKUP_VALUE  B                 
														 WHERE A.LOOKUP_TYPE_CODE = 'INSTANCE_ID'    
														   AND A.ATTRIBUTE4       = 'CREATE_VD_MO'   
														   AND A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE 
														 GROUP BY B.SEGMENT1          
													  ) X                            
												  WHERE X.SEGMENT1     = A.INSTANCE_ID 
												    AND X.ACTIVE_FLAG  = 'Y'         
											     ) 
						          ) A                     
						            LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_M B WITH(NOLOCK) 
						         ON A.COMPANY_ID    = B.COMPANY_ID     
						        AND A.DIVISION_ID   = B.DIVISION_ID    
						        AND A.SITE_ID       = B.SITE_ID        
						        AND A.PLANT_ID      = B.PLANT_ID       
						        AND A.FACTORY_ID    = B.FACTORY_ID     
						        AND A.CHILD_ITEM_ID = B.ITEM_ID        
						        AND A.PLAN_MONTH    = B.MONTH          
						        AND B.OPERATION_ID  = 'A6000'        
					       ) A                                          
					         LEFT OUTER JOIN SCM_LINE_M C WITH(NOLOCK)    
					      ON C.COMPANY_ID    = A.COMPANY_ID         
					     AND C.DIVISION_ID   = A.DIVISION_ID        
					     AND C.SITE_ID       = A.SITE_ID            
					     AND C.PLANT_ID      = A.PLANT_ID           
					     AND C.FACTORY_ID    = A.FACTORY_ID         
					     AND C.OPERATION_ID  = 'A6000'            
					     AND C.ACTIVE_FLAG   = 'Y'                
					   WHERE 1 = 1                                    
					     AND A.ITEM_SEQ = 1                         
					     AND (A.PRIORITY IS NULL OR A.PRIORITY = 9) 
					     AND A.FACTORY_ID <> 'A7' -- ??? A7 VD ????... 20190806                        
					   GROUP BY A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID 
						   , A.CHILD_ITEM_ID, A.FACTORY_ID, CASE WHEN A.LINE_ID = C.LINE_ID THEN A.LINE_ID ELSE C.LINE_ID END 
			       ) A                                       
			 WHERE ITEM_LINE_ASSIGN_CHECK IS NOT NULL 
			    OR DAILY_CAPA_CHECK      IS NOT NULL    
			    OR QTY_CHECK             IS NOT NULL    
	        option (force order) 
			;


			if @INVALID_COUNT > 0
			BEGIN
				SET @INVALID_MSG = N'Err05 : Please check ITEM_LINE_ASSIGN, DAILY_CAPA and etc. or batch qty should be under 50.'
				RAISERROR  ( @INVALID_MSG, 16, 1 ); 
			END
			;



			-- 전극 하위 기준정보 체크 : 대상 존재하면 중단
			WITH PLAN_BOM_ASSIGN AS ( 
  				SELECT A.*             
					 , B.ITEM_CLASS AS CHILD_ITEM_CLASS
					 , B.CHILD_ITEM_ID, B.ITEM_TYPE, B.ALT_ID, B.ALT_PRIORITY 
					 , C.LINE_ID AS S_LINE_ID, C.ELECTRODE_TYPE AS S_ELECTRODE_TYPE, C.PRIORITY AS S_PRIORITY, C.ACTIVE_FLAG AS S_ACTIVE_FLAG, D.EQUIPMENT_ID AS S_EQUIPMENT_ID
					 , F.CHILD_ITEM_ID AS PRE_CHILD_ITEM_ID, F.ITEM_TYPE AS PRE_ITEM_TYPE, F.ALT_ID AS PRE_ALT_ID, F.ALT_PRIORITY AS PRE_ALT_PRIORITY 
					 , G.LINE_ID AS PRE_LINE_ID, G.ELECTRODE_TYPE AS PRE_ELECTRODE_TYPE, G.PRIORITY AS PRE_PRIORITY, G.ACTIVE_FLAG AS PRE_ACTIVE_FLAG, H.EQUIPMENT_ID AS PRE_EQUIPMENT_ID
					 , RANK() OVER (PARTITION BY A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID,  A.LINE_ID, A.P_LINE_ID 
						                       , A.OPERATION_ID, A.ITEM_ID, A.ELECTRODE_TYPE, CONVERT(NVARCHAR(6), A.PLAN_DATE, 112), A.PLAN_DATE, B.ALT_ID 
						                ORDER BY ISNULL(C.LINE_ID, 'ZZZZ'), B.ALT_PRIORITY, D.EQUIPMENT_ID, ISNULL(G.LINE_ID, 'ZZZZ'), F.ALT_PRIORITY, H.EQUIPMENT_ID
								   ) AS RNK 
  				 FROM ( 
						SELECT A.INSTANCE_ID, A.FP_PLAN_ID 
							 , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID,  A.LINE_ID--B.SEGMENT4 AS P_LINE_ID, 
							 , ISNULL(B.SEGMENT4 ,A.LINE_ID)  AS P_LINE_ID          
							 , A.OPERATION_ID, A.ITEM_ID, A.ELECTRODE_TYPE          
							 , CONVERT(NVARCHAR(6), A.PLAN_DATE, 112) AS PLAN_MONTH 
							 , A.PLAN_DATE                                    
						  FROM FP_AMEND_DAILY_PLAN_R  A WITH(NOLOCK)          
						       LEFT OUTER JOIN  SCM_SYS_LOOKUP_VALUE B               
						    ON B.LOOKUP_TYPE_CODE = 'ELECTRODE_VIRTUAL_INLINE' 
						   AND A.FACTORY_ID       = B.ATTRIBUTE3             
						   AND A.LINE_ID          = B.SEGMENT2               
						 WHERE A.INSTANCE_ID   = @v_instance_id 
						   AND A.FP_PLAN_ID    = @v_fp_plan_id     
						   AND A.ADJUST_OUT_QTY_BATCH > 0                 
						   AND A.INSTANCE_ID LIKE '%E_PRE%'             
						   AND A.PLAN_DATE BETWEEN CONVERT(DATETIME,@v_start_date) AND CONVERT(DATETIME,@v_end_date) -- end date ?? ??... 20210518 ?? ??? 
						 GROUP BY A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID , A.LINE_ID 
							 , ISNULL(B.SEGMENT4 ,A.LINE_ID), A.OPERATION_ID, A.ITEM_ID, A.ELECTRODE_TYPE 
							 , CONVERT(NVARCHAR(6), A.PLAN_DATE, 112), A.PLAN_DATE                        
  				      ) A 
  				        LEFT OUTER JOIN ( 
						     SELECT DISTINCT AA.COMPANY_ID,AA.DIVISION_ID,AA.SITE_ID 
							      , AA.PLANT_ID,AA.PARENT_ITEM_ID,AA.CHILD_ITEM_ID     
							      , AA.ALT_PRIORITY,AA.ALT_ID,AA.EFF_START_DATE        
							      , AA.EFF_END_DATE,CC.ITEM_TYPE          
							      , CC.ITEM_CLASS 
						       FROM SCM_BOM_M AA WITH(NOLOCK)         
						          , SCM_ITEM_M        CC WITH(NOLOCK)        
						          , SCM_ITEM_CLASS_M  DD WITH(NOLOCK)          
						      WHERE AA.COMPANY_ID      = CC.COMPANY_ID  
						        AND AA.DIVISION_ID     = CC.DIVISION_ID 
						        AND AA.SITE_ID         = CC.SITE_ID     
						        AND AA.CHILD_ITEM_ID   = CC.ITEM_ID     
						        AND CC.ACTIVE_FLAG     = 'Y'          
						        AND CC.ITEM_CLASS      = DD.CLASS_ID    
						        AND DD.USE_FLAG        = 'Y'          
						        AND AA.ACTIVE_FLAG     = 'Y'          
						        AND AA.BOM_VERSION_ID  = '1'          
						        AND AA.EFF_END_DATE    >  CONVERT(DATE, @v_start_date) 
						        AND DD.LEVEL_2_NAME LIKE 'SLURRY'             
						        AND DD.CLASS_ID NOT IN ( 'ES01', 'ES0101' ) 
  				        ) B 
  				     ON A.COMPANY_ID  = B.COMPANY_ID     
  				    AND A.DIVISION_ID = B.DIVISION_ID    
  				    AND A.SITE_ID     = B.SITE_ID        
  				    AND A.PLANT_ID    = B.PLANT_ID       
  				    AND A.ITEM_ID     = B.PARENT_ITEM_ID 
  				    AND B.EFF_START_DATE < = A.PLAN_DATE 
  				    AND B.EFF_END_DATE   > A.PLAN_DATE   
  				        LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_M C WITH(NOLOCK) 
  				     ON C.COMPANY_ID  = A.COMPANY_ID    
  				    AND C.DIVISION_ID = A.DIVISION_ID   
  				    AND C.SITE_ID     = A.SITE_ID       
  				    AND C.PLANT_ID    = A.PLANT_ID      
  				    AND C.ITEM_ID     = B.CHILD_ITEM_ID 
  				    AND C.FACTORY_ID  = A.FACTORY_ID    
  				    AND C.LINE_ID     = A.LINE_ID       
  				    AND C.ELECTRODE_TYPE = A.ELECTRODE_TYPE 
  				    AND C.MONTH       = A.PLAN_MONTH         
  				    AND C.PRIORITY NOT IN (0,9)              
  				        LEFT OUTER JOIN SCM_EQUIPMENT_M D WITH(NOLOCK) 
  				     ON 1 = 1 
  				    AND D.COMPANY_ID      = C.COMPANY_ID     
  				    AND D.DIVISION_ID     = C.DIVISION_ID    
  				    AND D.SITE_ID         = C.SITE_ID        
  				    AND D.PLANT_ID        = C.PLANT_ID       
  				    AND D.FACTORY_ID      = C.FACTORY_ID     
  				    AND D.LINE_ID         = C.LINE_ID        
  				    AND D.OPERATION_ID    = C.OPERATION_ID   
  				    AND D.ELECTRODE_TYPE  = C.ELECTRODE_TYPE 
  				    AND D.ACTIVE_FLAG     = 'Y'            
  				    AND D.EQUIPMENT_TYPE  = 'M'            
  				        LEFT OUTER JOIN SCM_LINE_M E WITH(NOLOCK)   
  				     ON A.FACTORY_ID      = E.FACTORY_ID     
  				    AND A.LINE_ID         = E.LINE_ID        
  				    AND A.OPERATION_ID    = E.OPERATION_ID   
  				    AND A.ELECTRODE_TYPE  = E.ELECTRODE_TYPE 
  				        LEFT OUTER JOIN ( 
						    SELECT DISTINCT AA.COMPANY_ID,AA.DIVISION_ID,AA.SITE_ID 
							     , AA.PLANT_ID,AA.PARENT_ITEM_ID,AA.CHILD_ITEM_ID      
							     , AA.ALT_PRIORITY,AA.ALT_ID,AA.EFF_START_DATE         
							     , AA.EFF_END_DATE,CC.ITEM_TYPE   
						      FROM SCM_BOM_M AA WITH(NOLOCK)  
						         , SCM_ITEM_M        CC WITH(NOLOCK)
						         , SCM_ITEM_CLASS_M  DD WITH(NOLOCK)  
						     WHERE AA.COMPANY_ID      = CC.COMPANY_ID 
						     AND   AA.DIVISION_ID     = CC.DIVISION_ID 
						     AND   AA.SITE_ID         = CC.SITE_ID     
						     AND   AA.CHILD_ITEM_ID   = CC.ITEM_ID     
						     AND   CC.ACTIVE_FLAG     = 'Y'          
						     AND   CC.ITEM_CLASS      = DD.CLASS_ID    
						     AND   DD.USE_FLAG        = 'Y'          
						     AND   AA.ACTIVE_FLAG     = 'Y'          
						     AND   AA.BOM_VERSION_ID  = '1'          
						     AND   AA.EFF_END_DATE    >  CONVERT(DATE, GETDATE()) 
						     AND   DD.level_3_code    IN ('ASLPD','ASLPW')    
  				        ) F 
  				     ON A.COMPANY_ID  = F.COMPANY_ID  
  				    AND A.DIVISION_ID = F.DIVISION_ID 
  				    AND A.SITE_ID     = F.SITE_ID     
  				    AND A.PLANT_ID    = F.PLANT_ID    
  				    AND B.CHILD_ITEM_ID   = F.PARENT_ITEM_ID 
  				    AND F.EFF_START_DATE < = A.PLAN_DATE     
  				    AND F.EFF_END_DATE   > A.PLAN_DATE       
  				        LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_M G WITH(NOLOCK) 
  				     ON G.COMPANY_ID  = A.COMPANY_ID    
  				    AND G.DIVISION_ID = A.DIVISION_ID   
  				    AND G.SITE_ID     = A.SITE_ID       
  				    AND G.PLANT_ID    = A.PLANT_ID      
  				    AND G.ITEM_ID     = F.CHILD_ITEM_ID 
  				    AND G.FACTORY_ID  = A.FACTORY_ID    
  				    AND G.LINE_ID     = A.P_LINE_ID     
  				    AND G.MONTH       = A.PLAN_MONTH    
  				    AND G.PRIORITY NOT IN (0,9)         
  				        LEFT OUTER JOIN SCM_EQUIPMENT_M H WITH(NOLOCK) 
  				     ON 1 = 1 
  				    AND H.COMPANY_ID      = G.COMPANY_ID     
  				    AND H.DIVISION_ID     = G.DIVISION_ID    
  				    AND H.SITE_ID         = G.SITE_ID        
  				    AND H.PLANT_ID        = G.PLANT_ID       
  				    AND H.FACTORY_ID      = G.FACTORY_ID     
  				    AND H.LINE_ID         = G.LINE_ID        
  				    AND H.OPERATION_ID    = G.OPERATION_ID   
  				    AND H.ELECTRODE_TYPE  = G.ELECTRODE_TYPE 
  				    AND H.ACTIVE_FLAG     = 'Y'            
  				    AND H.EQUIPMENT_TYPE  = 'M'            
  				        LEFT OUTER  JOIN SCM_LINE_M J WITH(NOLOCK) 
  				     ON A.FACTORY_ID      = J.FACTORY_ID     
  				    AND A.LINE_ID         = J.LINE_ID        
  				    AND A.OPERATION_ID    = J.OPERATION_ID   
  				    AND A.ELECTRODE_TYPE  = J.ELECTRODE_TYPE 
			  ) 

			SELECT @INVALID_COUNT = COUNT(*)
			  FROM (                       
					 SELECT DISTINCT A.INSTANCE_ID,  A.FP_PLAN_ID,  A.ITEM_ID 
  						  , A.FACTORY_ID,    A.LINE_ID,     A.OPERATION_ID      
  						  , A.CHILD_ITEM_ID, A.PLAN_MONTH,  'E1000' AS CHILD_OPERATION_ID      
  						  , A.S_ELECTRODE_TYPE AS CHILD_ELECTRODE_TYPE, A.S_PRIORITY, A.S_ACTIVE_FLAG 
  						  , CASE WHEN A.CHILD_ITEM_ID IS NULL  THEN 'SCM_BOM_M'                     
  								 WHEN ( A.ITEM_TYPE IN ('R','') OR A.ITEM_TYPE IS NULL )  THEN 'SCM_ITEM_M' 
  								 WHEN A.S_LINE_ID IS NULL      THEN 'SCM_ITEM_LINE_ASSIGN_M'                    
  								 WHEN ISNULL(A.S_ACTIVE_FLAG, 'N') = 'N' THEN 'SCM_ITEM_LINE_ASSIGN_M'      
  								 WHEN ISNULL(A.S_PRIORITY,  0) NOT IN ( 1, 2, 3, 4, 5, 6, 7, 8 ) 
  													  THEN 'SCM_ITEM_LINE_ASSIGN_M'            
  								 WHEN A.S_EQUIPMENT_ID  IS NULL AND (A.INSTANCE_ID NOT LIKE '%CELL%' AND A.INSTANCE_ID NOT LIKE '%PACK%') THEN 'SCM_EQUIPMENT_M' 
  							END  PROBLEM_TABLE 
  						  , CASE WHEN A.CHILD_ITEM_ID IS NULL    THEN 'No BOM' 
  								 WHEN ( A.ITEM_TYPE IN ('R','') OR A.ITEM_TYPE IS NULL )  THEN 'Slurry Item is not producting material' 
  								 WHEN A.S_LINE_ID IS NULL       THEN 'No Line Assign' 
  								 WHEN ISNULL(A.S_ACTIVE_FLAG, 'N') = 'N' THEN 'Check Line Assign Active Flag : ' + ISNULL(A.S_ACTIVE_FLAG, 'NULL') 
  								 WHEN ISNULL(A.S_PRIORITY,    0) NOT IN ( 1, 2, 3, 4, 5, 6, 7, 8 ) 
  									  THEN 'Check Line Assign Priority : ' + ISNULL(CONVERT(NVARCHAR, A.S_PRIORITY), 'NULL') 
  								 WHEN A.S_EQUIPMENT_ID  IS NULL AND (A.INSTANCE_ID NOT LIKE '%CELL%' AND A.INSTANCE_ID NOT LIKE '%PACK%') THEN 'No Equipment' 
  							END  AS PROBLEM_DESCRIPTION 
  					   FROM PLAN_BOM_ASSIGN A           
  					  WHERE	1 = 1   
  					    AND RNK = 1 
  					  UNION ALL     
				     SELECT DISTINCT A.INSTANCE_ID, A.FP_PLAN_ID, A.ITEM_ID 
  						  , A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID           
  						  , A.PRE_CHILD_ITEM_ID, A.PLAN_MONTH, 'E0500' AS CHILD_OPERATION_ID        
  						  , A.S_ELECTRODE_TYPE AS CHILD_ELECTRODE_TYPE, A.S_PRIORITY, A.S_ACTIVE_FLAG 
  						  , CASE WHEN ( A.PRE_ITEM_TYPE IN ('R','') OR A.PRE_ITEM_TYPE IS NULL )  THEN 'SCM_ITEM_M' 
  							     WHEN A.PRE_CHILD_ITEM_ID IS NULL   THEN 'SCM_BOM_M'              
  							     WHEN A.PRE_LINE_ID IS NULL         THEN 'SCM_ITEM_LINE_ASSIGN_M' 
  							     WHEN ISNULL(A.PRE_ACTIVE_FLAG, 'N') = 'N' THEN 'SCM_ITEM_LINE_ASSIGN_M' 
  							     WHEN ISNULL(A.PRE_PRIORITY, 0) NOT IN ( 1, 2, 3, 4, 5, 6, 7, 8 ) 
  									  THEN 'SCM_ITEM_LINE_ASSIGN_M'                            
  							     WHEN A.PRE_EQUIPMENT_ID  IS NULL AND (A.INSTANCE_ID NOT LIKE '%CELL%' AND A.INSTANCE_ID NOT LIKE '%PACK%') THEN 'SCM_EQUIPMENT_M' 
  						         END  PROBLEM_TABLE 
  						  , CASE WHEN ( A.PRE_ITEM_TYPE IN ('R','') OR A.PRE_ITEM_TYPE IS NULL )  THEN 'Slurry Item is not producting material' 
  							     WHEN A.PRE_CHILD_ITEM_ID IS NULL   THEN 'No BOM'         
  							     WHEN A.PRE_LINE_ID IS NULL         THEN 'No Line Assign' 
  							     WHEN ISNULL(A.PRE_ACTIVE_FLAG, 'N') = 'N' THEN 'Check Line Assign Active Flag : ' + ISNULL(A.PRE_ACTIVE_FLAG, 'NULL') 
  							     WHEN ISNULL(A.PRE_PRIORITY, 0) NOT IN ( 1, 2, 3, 4, 5, 6, 7, 8 ) 
  									  THEN 'Check Line Assign Priority : ' + ISNULL(CONVERT(NVARCHAR, A.PRE_PRIORITY), 'NULL') 
  							     WHEN A.PRE_EQUIPMENT_ID  IS NULL AND (A.INSTANCE_ID NOT LIKE '%CELL%' AND A.INSTANCE_ID NOT LIKE '%PACK%') THEN 'No Equipment' 
  						         END  AS PROBLEM_DESCRIPTION 
  					   FROM PLAN_BOM_ASSIGN A         
  					WHERE 1 = 1     
  					  AND A.RNK = 1 
  					  AND A.PRE_CHILD_ITEM_ID IS NOT NULL      
  					  AND A.CHILD_ITEM_CLASS NOT IN ('ES0109') 
  					  AND A.INSTANCE_ID IN ( SELECT ATTRIBUTE3 
  											   FROM SCM_SYS_LOOKUP_VALUE 
  											  WHERE LOOKUP_TYPE_CODE = 'CREATE_WO_PRE_MIX' 
  											    AND ACTIVE_FLAG ='Y' ) 
			       ) A       
			   WHERE 1 = 1 
			     AND A.FACTORY_ID = @v_factory_id 
			     AND A.PROBLEM_DESCRIPTION  IS NOT NULL                                      
			;

			if @INVALID_COUNT > 0
			BEGIN
				SET @INVALID_MSG = N'Err06 : There is data without electrode sub-process master info.'
				RAISERROR  ( @INVALID_MSG, 16, 1 ); 

			END
			;


			-- 시업시간 포함해서 과거일자일 경우 중단
			SELECT @INVALID_COUNT = COUNT(*)
			  FROM (
			        SELECT @v_start_date AS PLAN_DATE
					     , CONVERT(VARCHAR,dbo.FN_SITE_TIME(@v_site_id),112) AS CURR_DATE
						 , A.BASIS_START_TIME    
				         , CASE WHEN (FORMAT(dbo.FN_SITE_TIME(@v_site_id) ,'yyyyMMddHHmmss') >= (@v_start_date + A.BASIS_START_TIME))   
						             AND  (FORMAT(dbo.FN_SITE_TIME(@v_site_id) ,'yyyyMMddHHmmss') < (CONVERT(VARCHAR,DATEADD(DD,1,@v_start_date),112) + A.BASIS_START_TIME)) THEN 'Y' 
							    ELSE 'N' END AS DATE_VALID  
			          FROM FP_INSTANCE_START_TIME_V A  
			         WHERE A.INSTANCE_ID = @v_instance_id  
			       ) as x
			 WHERE date_valid = 'N'
			;

			if @INVALID_COUNT > 0
			BEGIN
				SET @INVALID_MSG = N'Err07 : The plan start date based on the operning hours is in the past.'
				RAISERROR  ( @INVALID_MSG, 16, 1 ); 

			END
			;


			-- 인스턴스, 동 기준으로 배포 중일 경우 중단
			--SELECT A.INSTANCE_ID, A.RELEASE_TYPE, A.FP_PLAN_ID                     
			--    , A.INSERT_ID, CONVERT(VARCHAR, A.INSERT_TIME, 20) AS INSERT_TIME 
			--SELECT @INVALID_COUNT = COUNT(*)
			--  FROM FP_IS_RUNNING_RELEASE_H A WITH(NOLOCK)                          
			-- WHERE A.INSTANCE_ID  = @v_instance_id                              
			--   AND A.RELEASE_TYPE = @v_factory_id 
			--   AND A.ACTIVE_FLAG  = 'Y'                                          
			--;

			--if @INVALID_COUNT > 0
			--BEGIN
			--	SET @INVALID_MSG = N'Err08 : It is being released based on instance_id and factory_id : ' + @v_instance_id + '/' + @v_factory_id
			--	RAISERROR  ( @INVALID_MSG, 16, 1 ); 
			--END
			--;
--------------------------------------- validation END -----------------------------------------------

			-- 재계산 프로 시저 실행
			EXEC PR_SCM_FP_CALCURATION @v_instance_id, @v_fp_plan_id

			-- SCM_FP_PLAN_DETAIL_H 데이터 생성 : 가장 최근 배포 내역 정보 저장, 
			-- 이후 과정에 validation 이 걸리는 상황이 발생하면 데이터를 삭제해줘야한다 : SCM_FP_PLAN_DETAIL_H,  HIS_FP_PLAN_DETAIL_H
			MERGE INTO SCM_FP_PLAN_DETAIL_H AS A 
			USING (   
			        SELECT @v_start_date	AS PLAN_DATE
					     , @v_instance_id	AS INSTANCE_ID 
						 , @v_division_id	AS DIVISION_ID
						 , @v_factory_id	AS FACTORY_ID  
					) AS  B                      
			    ON A.PLAN_DATE   = B.PLAN_DATE   
			   AND A.INSTANCE_ID = B.INSTANCE_ID 
			   AND A.DIVISION_ID = B.DIVISION_ID 
			   AND A.FACTORY_ID  = B.FACTORY_ID
			WHEN MATCHED THEN                   
				UPDATE SET                        
				       PLAN_ID      = @v_fp_plan_id
					 , CONFIRM_ID = @v_user_id 
				     , CONFIRM_TIME = dbo.FN_SITE_TIME(@v_site_id)
					 , CONFIRM_FLAG = 'P'   
				     , RELEASE_TIME = NULL
					 , RELEASE_FLAG = 'N'               
				     , RELEASE_PLAN_ID = NULL
					 , MES_TRANSFER_FLAG = 'N'          
				     , MES_TRANSFER_TIME = NULL
					 , UPDATE_ID = @v_user_id 
				     , UPDATE_TIME = DBO.FN_SITE_TIME(@v_site_id)       
			WHEN NOT MATCHED THEN 
				INSERT (            
				       PLAN_DATE
					 , INSTANCE_ID
					 , DIVISION_ID     
				     , FACTORY_ID
					 , PLAN_ID
					 , CONFIRM_ID       
				     , CONFIRM_TIME
					 , CONFIRM_FLAG
					 , DESCRIPTION 
				     , INSERT_ID
					 , INSERT_TIME
					 , UPDATE_ID
					 , UPDATE_TIME
					 )
			    VALUES ( 
				       @v_start_date
					 , @v_instance_id 
					 , @v_division_id   
				     , @v_factory_id
					 , @v_fp_plan_id
					 , @v_user_id       
				     , dbo.FN_SITE_TIME(@v_site_id)    
					 ,'P'
					 , null 
				     , @v_user_id
					 , dbo.FN_SITE_TIME(@v_site_id)
					 , @v_user_id
					 , dbo.FN_SITE_TIME(@v_site_id) 
			         );   

			MERGE INTO HIS_FP_PLAN_DETAIL_H AS A  
			USING (
			        SELECT @v_start_date AS PLAN_DATE
					     , @v_instance_id AS INSTANCE_ID  
					     , @v_division_id AS DIVISION_ID
						 , @v_factory_id AS FACTORY_ID
						 , @v_fp_plan_id AS PLAN_ID
						 ) AS B  
			    ON A.PLAN_DATE   = B.PLAN_DATE    
			   AND A.INSTANCE_ID = B.INSTANCE_ID  
			   AND A.DIVISION_ID = B.DIVISION_ID  
			   AND A.FACTORY_ID  = B.FACTORY_ID   
			   AND A.PLAN_ID     = B.PLAN_ID  
			WHEN MATCHED THEN  
				UPDATE SET       
				       PLAN_ID  = @v_fp_plan_id
					 , CONFIRM_ID   = @v_user_id
					 , CONFIRM_TIME = dbo.FN_SITE_TIME(@v_site_id) 
				     , CONFIRM_FLAG = 'Y'
					 , RELEASE_TIME = NULL
					 , RELEASE_FLAG = 'N'                        
				     , RELEASE_PLAN_ID = NULL
					 , MES_TRANSFER_FLAG = 'N'
					 , MES_TRANSFER_TIME = NULL            
				     , UPDATE_ID = @v_user_id
					 , UPDATE_TIME = DBO.FN_SITE_TIME(@v_site_id) 
			 WHEN NOT MATCHED THEN 
				INSERT (            
				       PLAN_DATE
					 , INSTANCE_ID 
					 , DIVISION_ID  
				     , FACTORY_ID
					 , PLAN_ID
					 , CONFIRM_ID   
				     , CONFIRM_TIME
					 , CONFIRM_FLAG
					 , RELEASE_TIME 
				     , RELEASE_FLAG
					 , RELEASE_PLAN_ID
					 , DESCRIPTION  
				     , MES_TRANSFER_FLAG
					 , MES_TRANSFER_TIME
					 , INSERT_ID    
				     , INSERT_TIME
					 , UPDATE_ID
					 , UPDATE_TIME  
				     , JOB_USER_ID
					 , JOB_TIME
					 , JOB_TYPE 
					 )
			    VALUES ( 
				       @v_start_date
					 , @v_instance_id
					 , @v_division_id 
				     , @v_factory_id
					 , @v_fp_plan_id
					 , @v_user_id    
				     , dbo.FN_SITE_TIME(@v_site_id)
					 , 'Y'
					 , NULL                  
				     , 'N'
					 , NULL
				     , null
				     , 'N'
					 , NULL
					 , @v_user_id       
				     , dbo.FN_SITE_TIME(@v_site_id)
					 , @v_user_id
					 , dbo.FN_SITE_TIME(@v_site_id) 
				     , @v_user_id
					 , dbo.FN_SITE_TIME(@v_site_id)
					 , 'CONFIRM' 
			   );  

			UPDATE SCM_FP_PLAN_H SET  
				   CONFIRM_FLAG = 'Y' 
				 , CONFIRM_ID   = @v_user_id                  
				 , CONFIRM_TIME = dbo.FN_SITE_TIME(@v_site_id)
			 WHERE INSTANCE_ID  = @v_instance_id   
			   AND PLAN_ID      = @v_fp_plan_id  
  

			-- 혹시 중복으로 배포 단계에 들어간 정보가 존재하면 중단
			SELECT @INVALID_COUNT = count(*)
			  FROM FP_RELEASE_PLAN_STATUS_H A            
			 WHERE INSTANCE_ID = @v_instance_id       
			   AND FACTORY_ID  = @v_factory_id       
			   AND RELEASE_STATUS IN ('RUN','WAIT')  
			;

			if @INVALID_COUNT > 0
			BEGIN
				SET @INVALID_MSG = N'Err09 : There is a process that is being released multiple times.'
				RAISERROR  ( @INVALID_MSG, 16, 1 ); 
			END
			;

			-- 배포 프로시저 실행
			 EXEC PR_SCM_FP_CONFIRM_RELEASE @v_instance_id, @v_fp_plan_id, @v_factory_id, @v_user_id

			-- 배포 데이터 메일링
			 EXEC [dbo].[PR_SCM_PLAN_RESULT_SEND]  @v_instance_id, @v_start_date, @v_factory_id ;


			-- 수량 검증 쿼리 : 데이터 존재할 경우 배포 중단
			WITH TARGET_PLAN AS (                   
				SELECT INSTANCE_ID 
					 , (CASE WHEN SLV2.AMEND_LIMIT_YN = 'Y' THEN SLV2.AMEND_LIMIT_DATE ELSE INSTANCE_DATE END) AS INSTANCE_DATE 
					 , DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID , RELEASE_PLAN_ID PLAN_ID, AMEND_PLAN_ID BASIS_PLAN_ID, SLV.ATTRIBUTE1 AS UI_TYPE 
					 , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID  ORDER BY INSERT_TIME DESC ) NUMS 
					 , SLV2.AMEND_LIMIT_YN, SLV2.AMEND_LIMIT_DATE 
				  FROM FP_RELEASE_PLAN_INFO_H H WITH(NOLOCK)    
				       LEFT OUTER JOIN ( 
							SELECT SLV2.SEGMENT1 AS REL_INST, SLV2.SEGMENT2 AS REL_FACT 
								 , SLV2.ATTRIBUTE7 AS AMEND_LIMIT_YN, SLV2.ATTRIBUTE8 AS AMEND_LIMIT_DATE 
							  FROM SCM_SYS_LOOKUP_VALUE  SLV2 WITH(NOLOCK) 
							 WHERE 1 = 1 
							   AND SLV2.LOOKUP_TYPE_CODE = 'INSTANCE_FACTORY_RELEASE_TERM' 
							   AND SLV2.ACTIVE_FLAG = 'Y' 
							   AND SLV2.SEGMENT1 = @v_instance_id 
							   AND SLV2.SEGMENT2 = @v_factory_id 
				       ) SLV2 
				    ON 1 = 1 
				   AND H.INSTANCE_ID = SLV2.REL_INST 
				   AND H.FACTORY_ID  = SLV2.REL_FACT 
					 , SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)   
				 WHERE INSTANCE_ID   = @v_instance_id 
				   AND INSTANCE_DATE = @v_start_date   
			       AND FACTORY_ID = @v_factory_id 
				   AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE AMEND UI' 
				   AND SLV.SEGMENT1 = H.INSTANCE_ID                 
				) 
			SELECT @INVALID_COUNT = COUNT(*)
			 FROM (
					SELECT PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, MAKE_DATE, PLAN_ID         
				         , SUM(CASE WHEN groups = 'ERP'     THEN make_qty ELSE 0 END) 'ERP'     
				         , SUM(CASE WHEN groups = 'MES'     THEN make_qty ELSE 0 END) 'MES'     
				         , SUM(CASE WHEN groups = 'RELEASE' THEN make_qty ELSE 0 END) 'RELEASE' 
				         , SUM(CASE WHEN groups = 'AMEND'   THEN make_qty ELSE 0 END) 'AMEND'   
				         , SUM(CASE WHEN groups = 'PLAN_EQUIPMENT_R'   THEN make_qty ELSE 0 END) 'PLAN_EQUIPMENT_R'  
				         , CASE WHEN  SUM(CASE WHEN groups = 'AMEND'   THEN make_qty ELSE 0 END) <> SUM(CASE WHEN groups = 'RELEASE' THEN make_qty ELSE 0 END) THEN 'NG_RELEASE' ELSE '' END CHK1_RELEASE  
				         , CASE WHEN  SUM(CASE WHEN groups = 'RELEASE' THEN make_qty ELSE 0 END) <> SUM(CASE WHEN groups = 'MES'     THEN make_qty ELSE 0 END) THEN 'NG_MES'     ELSE '' END CHK2_MES  
				         , CASE WHEN  SUM(CASE WHEN groups = 'MES'     THEN make_qty ELSE 0 END) <> SUM(CASE WHEN groups = 'ERP'     THEN make_qty ELSE 0 END) THEN 'NG_ERP'     ELSE '' END CHK3_ERP  
			          FROM (  
					        SELECT max(groups) as groups, plant_id, factory_id, operation_id, item_id, make_date, sum(make_qty) as make_qty, plan_id  
					          FROM ( 
							         SELECT 'ERP' groups , plant_id, a.factory_id, OPERATION_ID, item_id,SUBSTRING(a.plan_date,1,8) make_date  
										  , FP_PLAN_QTY AS MAKE_QTY  
										  , A.FP_PLAN_ID AS PLAN_ID  
									   FROM SY_XIF_ERP_PRODUCTION_PLAN_S A  WITH(NOLOCK)  
										  , TARGET_PLAN  PLANS  WITH(NOLOCK)  
									  WHERE FP_PLAN_ID = PLANS.PLAN_ID       
										AND PLANS.NUMS = 1                   
       									AND (A.TOP_BACK_IND = 'B' OR A.TOP_BACK_IND IS NULL)  
       									AND A.FIX_TYPE = 'Y'   
									  UNION ALL                      
									 SELECT 'ERP' AS GROUPS, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID  
										  , CONVERT( VARCHAR, A.PLAN_DATE, 112) , A.PLAN_QTY, A.FP_PLAN_ID AS PLAN_ID 
									   FROM [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] A WITH(NOLOCK)  
       									  , TARGET_PLAN  PLANS  WITH(NOLOCK)  
									  WHERE A.FP_PLAN_ID = PLANS.PLAN_ID 
										AND FIX_TYPE   IN ('F','N')   
										AND ORDER_TYPE IN ('W')         
										AND PLANS.NUMS = 1                 
										AND NOT EXISTS ( SELECT 1         
														   FROM [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] XEP WITH(NOLOCK)  
														  WHERE XEP.FP_PLAN_ID = A.FP_PLAN_ID          
															AND XEP.WORK_ORDER_ID = A.WORK_ORDER_ID )  
       				               ) PLANSS  
							 GROUP BY plant_id, factory_id, OPERATION_ID, item_id,make_date, plan_id  
							 UNION ALL    
							SELECT max(groups) as groups, plant_id, factory_id, OPERATION_ID 
							     , item_id, make_date, sum(make_qty) as make_qty, plan_id   
							  FROM ( 
							        SELECT 'MES' as groups, plant_id, builno factory_id, OPERATION_ID, item_id  
										 , replace( SUBSTRING(a.plan_date,1,10) ,'-','') make_date             
										 , CAST(ATTR_08 AS NUMERIC) AS MAKE_QTY, a.PLAN_ID     
									  FROM SY_XIF_MES_WO_S a  with(nolock)         
										 , target_plan  plans  with(nolock)          
									 WHERE a.plan_id  = plans.plan_id               
									   AND plans.nums = 1                            
									   AND (a.attr_05 = 'B' or a.attr_05 is null)  
									   AND a.IS_RELEASE = 'Y'                      
									   AND if_id <> 'OFP0_OPLM_FP_WO'              
									 UNION ALL  
									SELECT 'MES' AS GROUPS, A.PLANT_ID, A.FACTORY_ID                 
										 , A.OPERATION_ID, A.ITEM_ID, CONVERT( VARCHAR, A.PLAN_DATE, 112) 
										 , A.PLAN_QTY, A.FP_PLAN_ID AS PLAN_ID                            
									  FROM [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] A WITH(NOLOCK)       
		          						 , TARGET_PLAN  PLANS  WITH(NOLOCK)  
									 WHERE A.FP_PLAN_ID = PLANS.PLAN_ID      
									   AND FIX_TYPE   IN ('F', 'N')       
									   AND PLANS.NUMS = 1         
									   AND NOT EXISTS ( SELECT 1  
														  FROM [dbo].[SY_XIF_MES_WO_S] XMW WITH(NOLOCK) 
														 WHERE XMW.PLAN_ID   = A.FP_PLAN_ID             
														   AND XMW.WO        = A.WORK_ORDER_ID          
														   AND XMW.WO_DETAIL = A.WORK_ORDER_SPL_ID      
													   )  
		       				       ) planss          
							 GROUP BY plant_id, factory_id, OPERATION_ID, item_id, make_date, plan_id  
						     UNION ALL  
							SELECT 'AMEND' as groups
							     , (select f.plant_id from dbo.scm_factory_m f with(nolock) where f.factory_id = w.after_site_id ) as PLANT_ID  
								 , after_site_id as FACTORY_ID, after_operation_id, ITEM_ID      
								 , after_plan_date make_date , CEILING(sum(after_qty)) make_qty  
								 , plans.plan_id  
							  FROM [dbo].[FP_AMEND_PRODUCTION_PLAN_R] W with(nolock)  
		       					 , target_plan plans                                 
								 , ( SELECT DEMAND_ID, MIN(AFTER_PLAN_DATE) AS PLAN_DATE       
									   FROM [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w with(nolock)  
										  , target_plan plans                  
									  WHERE master_id = plans.instance_id     
									    AND W.plan_id = plans.basis_plan_id    
									    AND W.after_in_qty > 0                 
									    AND plans.nums = 1                     
									    AND PLANS.UI_TYPE = 'AMEND UI'       
									    AND W.AFTER_SITE_ID = plans.factory_id 
									  group by DEMAND_ID                      
								   ) x  
							 WHERE master_id = plans.instance_id      
							   AND W.plan_id = plans.basis_plan_id     
							   AND PLANS.UI_TYPE = 'AMEND UI'        
							   AND W.demand_id = x.demand_id           
							   AND W.AFTER_SITE_ID = plans.factory_id  
							   AND PLAN_DATE <= dateadd(dd,( SELECT (CASE WHEN SLV.ATTRIBUTE7 = 'Y' THEN 0 ELSE CONVERT(NUMERIC(5), SLV.SEGMENT3) END) AS INSTANCE_DATE 
															   FROM DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)  
															  WHERE SLV.LOOKUP_TYPE_CODE = 'INSTANCE_FACTORY_RELEASE_TERM'  
															    AND SLV.ACTIVE_FLAG = 'Y'           
															    AND SLV.SEGMENT1 = plans.INSTANCE_ID  
															    AND SLV.SEGMENT2 = plans.factory_id ) 
		 											      , CONVERT(datetime, plans.instance_date) )         
							   AND plans.nums = 1     
							   AND exists (           
										   SELECT 1  
										     FROM FP_INSTANCE_CONFIG_M k       
										    WHERE k.instance_id = w.master_id  
										      AND k.CATEGORY_ID  = 'PLAN_CATEGORY'      
										      AND k.KEY_ID       = 'CELL_HARD_PEGGING'  
										      AND k.KEY_VALUE    = 'Y'                  
										   )  
							 GROUP BY after_site_id, after_operation_id, ITEM_ID, after_plan_date, plans.plan_id  
						     UNION ALL  
							SELECT 'AMEND' as groups
							     , ( select f.plant_id from dbo.scm_factory_m f WITH(NOLOCK) where f.factory_id = w.after_site_id ) as PLANT_ID      
								 , after_site_id as FACTORY_ID, after_operation_id, ITEM_ID                          
		       				     , after_plan_date make_date, CEILING(sum(after_qty)) make_qty, plans.plan_id        
							  FROM [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w with(nolock)  
		       					 , target_plan  plans  with(nolock)              
							 WHERE master_id = plans.instance_id                      
							   AND w.plan_id = plans.basis_plan_id                    
							   AND plans.ui_type = 'AMEND UI'          
		       				   AND w.after_site_id = plans.factory_id  
							   AND plans.nums = 1      
							   AND w.after_in_qty > 0  
							   AND after_plan_date <= dateadd( dd,( SELECT (CASE WHEN SLV.ATTRIBUTE7 = 'Y' THEN 0 ELSE CONVERT(NUMERIC(5), SLV.SEGMENT3) END) AS INSTANCE_DATE 
																      FROM DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)               
																     WHERE SLV.LOOKUP_TYPE_CODE = 'INSTANCE_FACTORY_RELEASE_TERM' 
																       AND SLV.ACTIVE_FLAG = 'Y'           
																       AND SLV.SEGMENT1 = plans.INSTANCE_ID  
																       AND SLV.SEGMENT2 = plans.factory_id   
																  ), convert(datetime,plans.instance_date) )  
							   AND not exists (         
											   SELECT 1  
											     FROM FP_INSTANCE_CONFIG_M k       
											    WHERE k.instance_id = w.master_id  
											      AND k.CATEGORY_ID  = 'PLAN_CATEGORY'      
											      AND k.KEY_ID       = 'CELL_HARD_PEGGING'  
											      AND k.KEY_VALUE    = 'Y'                  
										       )  
							 GROUP BY after_site_id, after_operation_id, ITEM_ID, after_plan_date, plans.plan_id  
						     UNION ALL  
							SELECT 'AMEND' as groups, MAX(W.PLANT_ID) AS PLANT_ID   
								 , W.FACTORY_ID as FACTORY_ID, W.operation_id, W.ITEM_ID 
		       				     , PLAN_DATE make_date , CEILING(sum(OUT_QTY)) make_qty,plans.plan_id  
							  FROM [dbo].[FP_AMEND_PLAN_R] w with(nolock) 
								 , target_plan  plans  with(nolock)       
							 WHERE w.instance_id = plans.instance_id      
							   AND w.fp_plan_id  = plans.basis_plan_id    
							   AND PLANS.UI_TYPE = 'PSI AMEND UI'       
		       				   AND W.factory_id = plans.factory_id      
							   AND plans.nums = 1  
							   AND in_qty > 0      
							   AND plan_date <= dateadd(dd,(SELECT (CASE WHEN SLV.ATTRIBUTE7 = 'Y' THEN 0 ELSE CONVERT(NUMERIC(5), SLV.SEGMENT3) END) AS INSTANCE_DATE 
		       									              FROM DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)  
		       									             WHERE SLV.LOOKUP_TYPE_CODE = 'INSTANCE_FACTORY_RELEASE_TERM'  
		       									               AND SLV.ACTIVE_FLAG = 'Y'           
		       									               AND SLV.SEGMENT1 = plans.INSTANCE_ID  
		       									               AND SLV.SEGMENT2 = plans.FACTORY_ID ) 
		 									              , convert(datetime,plans.instance_date) )        
							 GROUP BY W.FACTORY_ID, operation_id, ITEM_ID, plan_date, plans.plan_id  
						     UNION ALL  
							SELECT 'RELEASE', ( select f.plant_id from scm_factory_m f  with(nolock) where f.factory_id = w.FACTORY_ID ) as PLANT_ID      
								 , W.FACTORY_ID , W.OPERATION_ID , W.ITEM_ID       
								 , CONVERT(VARCHAR, W.PLAN_DATE,112) AS PLAN_DATE  
								 , CEILING(sum(PLAN_QTY)) make_qty, plans.plan_id  
							  FROM FP_RELEASE_FIX_PLAN_H  W  with(nolock)  
								 , target_plan  plans  with(nolock)          
							 WHERE W.INSTANCE_ID     = plans.instance_id    
							   AND W.AMEND_PLAN_ID   = plans.basis_plan_id  
							   AND W.RELEASE_PLAN_ID = plans.PLAN_ID        
							   AND plans.nums        = 1                    
							 GROUP BY W.FACTORY_ID, W.operation_id, W.ITEM_ID, W.plan_date, plans.plan_id  
						     UNION ALL  
							SELECT 'PLAN_EQUIPMENT_R', a.PLANT_ID, a.FACTORY_ID, a.OPERATION_ID 
							     , a.ITEM_ID, convert( varchar, a.PLAN_DATE, 112), sum( a.plan_qty), plans.plan_id  
							  FROM dbo.FP_PRODUCTION_PLAN_EQUIPMENT_R a  with(nolock)  
								 , target_plan plans with(nolock) 
							 WHERE a.FP_PLAN_ID = plans.plan_id  
							   AND FIX_TYPE   IN ('F','N')     
							   AND ORDER_TYPE IN ('W','M')     
							 GROUP BY a.PLANT_ID, a.FACTORY_ID, a.OPERATION_ID, a.ITEM_ID, convert( varchar, a.PLAN_DATE, 112),plans.plan_id  
						   ) A  
			         GROUP BY PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, MAKE_DATE, PLAN_ID  
			        HAVING (ABS(SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = 'RELEASE' THEN MAKE_QTY ELSE 0 END ))/( CASE WHEN SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) = 0 THEN 1 ELSE SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) END) > 0.0015  
				           OR  ABS(SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = 'MES' THEN MAKE_QTY ELSE 0 END ))/( CASE WHEN SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) = 0 THEN 1 ELSE SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) END) > 0.0015 )  
			           AND (   ABS(SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = 'RELEASE' THEN MAKE_QTY ELSE 0 END )) > 1  
				           OR  ABS(SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = 'MES' THEN MAKE_QTY ELSE 0 END ))> 1 )  

					 UNION  
			        SELECT PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, SUBSTRING(Z.PLAN_DATE,1,8), FP_PLAN_ID 
				         , 0 As 'ERP', 0 As 'MES'    , 0 As 'RELEASE'   , 0 As 'AMEND'                   
				         , count(distinct batch_id) As 'PLAN_EQUIPMENT_R', z.batch_order_id As CHK1_RELEASE    
				         , 'NG_BATCH_ORDER_ID' As CHK2_MES, 'NG_BATCH_ORDER_ID' As CHK3_ERP  
			         FROM (  
					        SELECT ISNULL( ( SELECT B.BATCH_ID     
									           FROM SCM_BATCH_M B  
									          WHERE B.PLANT_ID = A.PLANT_ID  
									            AND B.ITEM_ID = A.ITEM_ID ), ITEM_ID) AS BATCH_ID  
								 , A.*  
							  FROM SY_XIF_ERP_PRODUCTION_PLAN_S A WITH(NOLOCK)  
								 , TARGET_PLAN PLANS WITH(NOLOCK) 
							 WHERE A.FP_PLAN_ID = PLANS.PLAN_ID   
							   AND BATCH_ORDER_ID <> '-'        
						  ) Z  
  		            GROUP BY Z.PLANT_ID, Z.FACTORY_ID, Z.OPERATION_ID, Z.ITEM_ID, SUBSTRING(Z.PLAN_DATE,1,8), FP_PLAN_ID, BATCH_ORDER_ID  
		           HAVING COUNT(DISTINCT z.BATCH_ID) > 1  
			) as x


			if @INVALID_COUNT > 0
			BEGIN
				SET @INVALID_MSG = N'Err10 : Contains data with inadequate quantity.'
				RAISERROR  ( @INVALID_MSG, 16, 1 ); 
			END
			;


			-- 배포검증 쿼리 2 : 데이터 존재할 경우 중단
			SELECT @INVALID_COUNT = COUNT(*)
			 FROM (  
					SELECT A.COMPANY_ID ,A.DIVISION_ID ,A.SITE_ID ,A.PLANT_ID    
					     , A.FACTORY_ID ,A.OPERATION_ID ,A.WORK_ORDER_ID ,PLAN_DATE  
					     , A.FP_PLAN_ID ,A.LINE_ID ,A.PLAN_QTY ,A.PLAN_IN_QTY        
					     , PARENT_ITEM_ID ,CHILD_ITEM_ID ,I.LINE_ID AS CHILD_ASSIGN_LINE_ID  
					     , I.OPERATION_ID  AS CHILD_OPERATION_ID ,I.PRIORITY AS CHILD_ASSIGN_PRIORITY  
					     , CASE WHEN A.ALT_ID IS NULL THEN 1 
					            ELSE ROW_NUMBER() OVER (PARTITION BY A.PARENT_ITEM_ID, A.WORK_ORDER_ID, A.ALT_ID   
 						                                    ORDER BY I.LINE_ID DESC, A.ALT_PRIORITY, A.CHILD_ITEM_ID ) END AS ORD_PRIORITY  
					  FROM (  
						     SELECT * 
						       FROM ( 
							          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID       
 							               , A.FACTORY_ID, A.OPERATION_ID, A.PLAN_DATE, A.FP_PLAN_ID      
 							               , A.WORK_ORDER_ID, A.PLAN_QTY, A.PLAN_IN_QTY, A.LINE_ID        
							               , B.PARENT_ITEM_ID, B.CHILD_ITEM_ID, B.ALT_ID, B.ALT_PRIORITY  
							               , A.VERSION, A.WORK_REQUEST_MODEL_ID 
							            FROM DBO.FP_PRODUCTION_PLAN_EQUIPMENT_R A WITH(NOLOCK)          
							               , DBO.SCM_BOM_M B WITH(NOLOCK)             
							               , DBO.SCM_FP_PLAN_DETAIL_H C WITH(NOLOCK)  
							               , DBO.SCM_ITEM_M D WITH(NOLOCK)            
							           WHERE 1 = 1  
							             AND B.PARENT_ITEM_ID = A.ITEM_ID 
										 AND B.PLANT_ID      = A.PLANT_ID        
							             AND CHILD_ITEM_ID LIKE 'ASL%'  
										 AND EFF_START_DATE  <= A.START_TIME     
							             AND EFF_END_DATE  > A.START_TIME 
										 AND A.FP_PLAN_ID    = C.RELEASE_PLAN_ID 
							             AND B.COMPANY_ID  = D.COMPANY_ID 
										 AND B.DIVISION_ID   = D.DIVISION_ID     
							             AND B.SITE_ID     = D.SITE_ID    
										 AND B.CHILD_ITEM_ID = D.ITEM_ID         
							             AND D.ACTIVE_FLAG = 'Y'        
										 AND C.RELEASE_FLAG  = 'Y'             
							             AND C.PLAN_DATE   = @v_start_date  
										 AND C.INSTANCE_ID  = @v_instance_id 
			                             AND C.PLAN_ID = @v_fp_plan_id 
			                             AND C.FACTORY_ID = @v_factory_id 
							             AND ORDER_TYPE = 'W'         
										 AND PLAN_IN_QTY > 0.0  
							             AND OPERATION_ID IN ( 'E2000', 'S2000')           
						            ) A 
						      WHERE 1 = 1 
						        AND EXISTS ( 
											SELECT 1 
											  FROM ( 
													 SELECT DISTINCT A.SITE_ID, B.FACTORY_ID, B.MODEL_ID 
														  , A.PARENT_ITEM_ID AS PANCAKE_ID 
														  , A.CHILD_ITEM_ID AS SLURRY_ID 
														  , B.PROD_VERSION 
														  , RANK() OVER ( PARTITION BY A.SITE_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, B.MODEL_ID, B.PROD_VERSION_TYPE, B.PROD_VERSION 
														  				  ORDER BY B.APPLY_DATE DESC, B.PROD_VERSION DESC, B.PROD_SEQ DESC ) AS RNK 
													   FROM SCM_BOM_M A
														  , FP_PROD_VERSION_M B
														  , FP_PROD_VERSION_M D 
													  WHERE 1 = 1 
													    AND A.PARENT_ITEM_ID = B.ITEM_ID 
													    AND B.COMPANY_ID = D.COMPANY_ID 
													    AND B.DIVISION_ID = D.DIVISION_ID 
													    AND B.SITE_ID = D.SITE_ID 
													    AND B.PLANT_ID = D.PLANT_ID 
													    AND B.FACTORY_ID = D.FACTORY_ID 
													    AND B.MODEL_ID = D.MODEL_ID 
													    AND B.PROD_VERSION_TYPE = D.PROD_VERSION_TYPE 
													    AND B.PROD_VERSION = D.PROD_VERSION 
													    AND B.PROD_SEQ = D.PROD_SEQ 
													    AND A.CHILD_ITEM_ID = D.ITEM_ID 
													    AND	A.ALT_ID IS NOT NULL 
														AND B.FACTORY_ID = @v_factory_id 
												   ) B 
											 WHERE 1 = 1 
											   AND B.RNK =1 
											   AND A.SITE_ID        = B.SITE_ID 
											   AND A.FACTORY_ID     = B.FACTORY_ID 
											   AND A.WORK_REQUEST_MODEL_ID = B.MODEL_ID 
											   AND A.PARENT_ITEM_ID = B.PANCAKE_ID 
											   AND A.CHILD_ITEM_ID  = B.SLURRY_ID 
											   AND A.VERSION        = B.PROD_VERSION 
						                   ) 

				           ) A 
				           LEFT OUTER JOIN  DBO.SCM_ITEM_LINE_ASSIGN_M I WITH(NOLOCK)          
					    ON A.PLANT_ID =  I.PLANT_ID      
					   AND A.FACTORY_ID  = I.FACTORY_ID 
					   AND A.CHILD_ITEM_ID = I.ITEM_ID  
					   AND A.LINE_ID = I.LINE_ID        
					   AND ACTIVE_FLAG = 'Y'          /*AND I.PRIORITY != '9'*/          
					   AND MONTH = CONVERT(VARCHAR(6),A.PLAN_DATE, 112) 
					   AND NOT EXISTS (           
									    SELECT 1  
									      FROM SCM_ITEM_LINE_ASSIGN_EXCEPT_M KK WITH(NOLOCK)             
									     WHERE PLANT_ID =  A.PLANT_ID   AND FACTORY_ID  = A.FACTORY_ID    
									       AND ITEM_ID = A.CHILD_ITEM_ID  AND OPERATION_ID = I.OPERATION_ID 
									       AND LINE_ID = I.LINE_ID        AND START_TIME <= A.PLAN_DATE     
									       AND END_TIME >= A.PLAN_DATE                                      
									       AND (ACTIVE_FLAG = 'N' OR PRIORITY = 0 OR PRIORITY = 9 )       
								      ) 
			      ) A 
			WHERE ORD_PRIORITY = 1 
			  AND ( NOT EXISTS ( 
					            SELECT 1 
								  FROM DBO.FP_ORDER_PEGGING_R B WITH(NOLOCK) 
					             WHERE B.FP_PLAN_ID       = A.FP_PLAN_ID 
					               AND B.TO_WORK_ORDER_ID = A.WORK_ORDER_ID 
					               AND B.FROM_ITEM_ID     = A.CHILD_ITEM_ID 
				               ) 
			      OR (ISNULL(A.CHILD_ASSIGN_PRIORITY,0) NOT IN (1,2,3,4,5,6,7,8) ) 
			      ) 
			;

			if @INVALID_COUNT > 0
			BEGIN
				SET @INVALID_MSG = N'Err11 : Contains data that is not suitable for release.'
				RAISERROR  ( @INVALID_MSG, 16, 1 ); 
			END
			;


			-- MES 전송 처리
			 UPDATE SY_XIF_ERP_PRODUCTION_PLAN_S                       
			    SET SY_XIF_ERP_PRODUCTION_PLAN_S.TRANSFER_FLAG = 'N' 
			   FROM SY_XIF_ERP_PRODUCTION_PLAN_S A             
			        INNER JOIN SCM_FP_PLAN_DETAIL_H B                 
			     ON A.FP_PLAN_ID    = B.RELEASE_PLAN_ID        
			  WHERE B.PLAN_DATE     = @v_start_date   
			    AND B.INSTANCE_ID   = @v_instance_id 
			    AND B.RELEASE_FLAG  = 'Y'                    
			    AND A.TRANSFER_FLAG = 'X'                    
			    AND (CASE WHEN CHARINDEX('E_POST', @v_instance_id) = 0 THEN 1 ELSE 0 END) = 1 
			    AND B.PLAN_ID = @v_fp_plan_id 
  
			 UPDATE SY_XIF_MES_WO_S                            
			    SET SY_XIF_MES_WO_S.IF_FLAG = 'N'            
			   FROM SY_XIF_MES_WO_S A                          
			        INNER JOIN SCM_FP_PLAN_DETAIL_H B                 
			     ON A.PLAN_ID       = B.RELEASE_PLAN_ID        
			  WHERE B.PLAN_DATE     = @v_start_date   
			    AND B.INSTANCE_ID   = @v_instance_id 
			    AND B.RELEASE_FLAG  = 'Y'                    
			    AND A.IF_FLAG       = 'X'                    
			    AND B.PLAN_ID = @v_fp_plan_id 
  
			 UPDATE SY_XIF_MES_DAILY_PP_S                      
			    SET SY_XIF_MES_DAILY_PP_S.IF_FLAG = 'N'      
			   FROM SY_XIF_MES_DAILY_PP_S A                    
			        INNER JOIN SCM_FP_PLAN_DETAIL_H B                 
			     ON A.PLAN_ID       = B.RELEASE_PLAN_ID        
			  WHERE B.PLAN_DATE     = @v_start_date   
			    AND B.INSTANCE_ID   = @v_instance_id 
			    AND B.RELEASE_FLAG  = 'Y'                    
			    AND A.IF_FLAG       = 'X'                    
			    AND B.PLAN_ID = @v_fp_plan_id 
  
			 UPDATE SY_XIF_PDS_WO_S                            
			    SET SY_XIF_PDS_WO_S.IF_FLAG = 'N'            
			   FROM SY_XIF_PDS_WO_S A                          
			        INNER JOIN SCM_FP_PLAN_DETAIL_H B                 
			     ON A.PLAN_ID       = B.RELEASE_PLAN_ID        
			 WHERE B.PLAN_DATE     = @v_start_date   
			   AND B.INSTANCE_ID   = @v_instance_id 
			   AND B.RELEASE_FLAG  = 'Y'                    
			   AND A.IF_FLAG       = 'X'                    
			   AND B.PLAN_ID = @v_fp_plan_id 
  
			 UPDATE SCM_FP_PLAN_DETAIL_H                     
			    SET MES_TRANSFER_FLAG = 'Y'                
				  , MES_TRANSFER_TIME = GETDATE()            
			 WHERE PLAN_DATE     = @v_start_date   
			   AND INSTANCE_ID   = @v_instance_id 
			   AND RELEASE_FLAG  = 'Y'                    
			   AND PLAN_ID = @v_fp_plan_id 


			 -- 배포된 버전 조회
			--SELECT A.INSTANCE_ID, B.RELEASE_PLAN_ID AS PLAN_ID, A.FACTORY_ID   
			SELECT @v_release_plan_id = B.RELEASE_PLAN_ID
			  FROM HIS_FP_PLAN_DETAIL_H A WITH(NOLOCK)                          
			       INNER JOIN SCM_FP_PLAN_DETAIL_H B WITH(NOLOCK)                      
			    ON A.PLAN_DATE		= B.PLAN_DATE                                 
			   AND A.INSTANCE_ID	= B.INSTANCE_ID                               
			   AND A.FACTORY_ID		= B.FACTORY_ID                                
			 WHERE A.PLAN_DATE		= @v_start_date                           
			   AND A.INSTANCE_ID	= @v_instance_id                           
			   AND A.PLAN_ID		= @v_fp_plan_id                           
			   AND A.FACTORY_ID		= @v_factory_id 
			;

			-- description 추가
			UPDATE SCM_FP_PLAN_H 
			   SET REL_DESC    = NULL    
			 WHERE INSTANCE_ID = @v_instance_id  
			   AND PLAN_ID     = @v_release_plan_id


			-- 화면에서 MRP FLAG 가 체크되있을 경우 업데이트 처리
			UPDATE SCM_FP_PLAN_H 
			   SET MRP_FLAG = 'N'
			 WHERE INSTANCE_ID = @v_instance_id
			   AND PLAN_ID     = @v_release_plan_id
      
			-- 배포 완료 메일링
			 EXEC [dbo].[PR_SCM_RELEASE_PLAN_ATTACH_FILE]  @v_instance_id, @v_start_date, @v_factory_id, 'NULL',  '' 

			-- HIS_FP_PLAN_DETAIL_H 업데이트
			 UPDATE HIS_FP_PLAN_DETAIL_H                                              
			    SET HIS_FP_PLAN_DETAIL_H.RELEASE_TIME    = dbo.FN_SITE_TIME(@v_site_id) 
				  , HIS_FP_PLAN_DETAIL_H.RELEASE_FLAG    = 'Y'                       
				  , HIS_FP_PLAN_DETAIL_H.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID           
				  , MES_TRANSFER_FLAG = 'Y'                                          
				  , MES_TRANSFER_TIME = GETDATE()                                      
			   FROM HIS_FP_PLAN_DETAIL_H A                                             
			        INNER JOIN SCM_FP_PLAN_DETAIL_H B                                         
			     ON A.PLAN_DATE		= B.PLAN_DATE                                       
			    AND A.INSTANCE_ID	= B.INSTANCE_ID                                     
			    AND A.FACTORY_ID	= B.FACTORY_ID                                      
			  WHERE A.PLAN_DATE		= @v_start_date                            
			    AND A.INSTANCE_ID	= @v_instance_id                          
			    AND A.PLAN_ID		= @v_fp_plan_id                              
			    AND A.FACTORY_ID	= @v_factory_id 

			-- SMS 전송
			EXEC [dbo].[PR_SCM_CONFIRM_SMS_SEND]  @v_instance_id, @v_release_plan_id, @v_factory_id 

			-- 프로시저 실행
			EXEC [dbo].[PR_XIF_MES_ERP_WO_MASTER]  @v_release_plan_id

			-- 배포 락 해제
			DELETE 
			  FROM FP_IS_RUNNING_RELEASE_H             
			 WHERE INSTANCE_ID  = @v_instance_id  
			   AND RELEASE_TYPE = @v_factory_id 

			-- 프로시저 실행
			EXEC [dbo].[PR_SCM_OF_ASSY_ELEC_REPORT]  @v_instance_id 


			SET @INX = @INX + 1
		END

		
        --SELECT 'OK' as ret, '' as msg   
		PRINT 'OK'
		SET @p_return = 'OK' 

	END TRY

	BEGIN CATCH

		--IF @@TRANCOUNT > 0
		--	ROLLBACK TRAN

		DELETE 
		  FROM FP_IS_RUNNING_RELEASE_H             
		 WHERE INSTANCE_ID  = @v_instance_id  
		   AND RELEASE_TYPE = @v_factory_id 


		--SELECT 'NG' as ret, ERROR_MESSAGE() as msg
		PRINT 'NG|' + ERROR_MESSAGE()
		SET @p_return = 'NG|' + '[' + @v_instance_id + '] '+ ERROR_MESSAGE()

	END CATCH

	if object_id('tempdb..#FACTORY_ID') is not null
		drop table #FACTORY_ID


END



