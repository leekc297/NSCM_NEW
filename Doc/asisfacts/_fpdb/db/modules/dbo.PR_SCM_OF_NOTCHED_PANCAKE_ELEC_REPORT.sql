CREATE PROCEDURE [dbo].[PR_SCM_OF_NOTCHED_PANCAKE_ELEC_REPORT]
  @p_master_id nvarchar(MAX) = '-'    -- Value : INSTANCE ID 
  
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : [PR_SCM_OF_NOTCHED_PANCAKE_ELEC_REPORT]                                   **/
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
/** 2019.05.27    SHS          최초 작성                                                      **/
/***********************************************************************************************/
/*
  EXEC [[PR_SCM_OF_ASSY_ELEC_REPORT]]
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  DECLARE
    @v_proc_name        nvarchar(150) = 'PR_SCM_OF_NOTCHED_PANCAKE_ELEC_REPORT', 
    @v_table_name       nvarchar(150) = NULL, 
    @v_master_id        nvarchar(150) = @p_master_id 
    
  DECLARE
    @v_plan_id          nvarchar(50)   , 
    @v_create_plan_id   nvarchar(50)   ,
    @v_plan_date        nvarchar(8)    ,
    @v_seq              nvarchar(10)   ,
    @v_plan_group       nvarchar(10)

  DECLARE
    @n_count            Integer  = 0,
    @n_log_count        Integer  = 0,
    @sysdate            DATETIME2 = GETDATE(),
    @v_message          nvarchar(200),
    @v_description      nvarchar(200)
    
  DECLARE @n_row_count        Integer  = 0  

  
  BEGIN TRY

    IF charindex('CELL' , @v_master_id ) > 0 
    BEGIN

    SELECT  @v_plan_group = CASE WHEN ISNULL(MAX(PLAN_GROUP_ID),'-')= '-' THEN '-' ELSE 'PLAN_GROUP' END 
    FROM FP_USER_LINE_GROUP_M
    WHERE INSTANCE_ID = @v_master_id 

    --LOG 생성
    SET @v_message = @v_plan_group
    SET @n_log_count = @n_log_count + 1
    SET @sysdate = GETDATE()
    EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null   
    
    SET @v_table_name = 'TH_BUF_CELL_RELEASE_PLAN'
      
    IF @v_plan_group =  'PLAN_GROUP' 
    BEGIN

      DELETE TH_BUF_CELL_RELEASE_PLAN
      FROM (
    				SELECT  A.INSTANCE_ID , 
                    A.FACTORY_ID ,
                    A.INSTANCE_DATE , 
                    A.RELEASE_DATE , 
                    A.RELEASE_PLAN_ID , 
                    A.AMEND_PLAN_ID
      			FROM (
      		  		  SELECT	INSTANCE_ID , 
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
      							      CONVERT(DATE, A.INSTANCE_DATE) AS RELEASE_DATE ,   -- 2018.03.26 : RELEASE 일자 이후부터 타겟 , 
                          A.PLAN_GROUP_ID, 
                          A.LINE_ID 
      			      FROM (
            						SELECT  A.INSTANCE_ID , 
                                A.INSTANCE_DATE , 
                                A.DIVISION_ID , 
                                MIN(A.RELEASE_PLAN_ID) OVER ( PARTITION BY   A.INSTANCE_ID , A.INSTANCE_DATE , A.DIVISION_ID , B.LINE_ID   ) AS RELEASE_PLAN_ID  , 
                                MAX(A.AMEND_PLAN_ID)   OVER ( PARTITION BY   A.INSTANCE_ID , A.INSTANCE_DATE , A.DIVISION_ID , B.LINE_ID   ) AS  AMEND_PLAN_ID, 
                                CASE WHEN A.FACTORY_ID ='-' THEN B.FACTORY_ID ELSE A.FACTORY_ID END AS FACTORY_ID , 
            							      DENSE_RANK() OVER (PARTITION BY A.PLAN_GROUP_ID
            												                ORDER     BY A.INSTANCE_DATE DESC) AS SEQ , 
                                A.PLAN_GROUP_ID, 
                                B.LINE_ID
            						FROM   FP_RELEASE_PLAN_INFO_H  A 
                                LEFT OUTER JOIN(
                                                SELECT DISTINCT INSTANCE_ID , FACTORY_ID  , LINE_ID  , MODEL_TYPE
                                                FROM FP_INSTANCE_LINE_V
                                                WHERE INSTANCE_ID = @v_master_id
                                                )B
                                      ON A.INSTANCE_ID = B.INSTANCE_ID
                                      AND A.PLAN_GROUP_ID = B.MODEL_TYPE
        							  WHERE  A.INSTANCE_ID = @v_master_id
                        AND	    A.PLAN_GROUP_ID IN ( SELECT PLAN_GROUP_ID FROM FP_USER_LINE_GROUP_M WHERE INSTANCE_ID = @v_master_id )
      						      ) A
      				    WHERE  SEQ = 1   
			            )A
      			)A
      WHERE  TH_BUF_CELL_RELEASE_PLAN.INSTANCE_ID = @v_master_id
      AND		 TH_BUF_CELL_RELEASE_PLAN.INSTANCE_ID = A.INSTANCE_ID
      AND		 TH_BUF_CELL_RELEASE_PLAN.FACTORY_ID  = A.FACTORY_ID
      AND		 TH_BUF_CELL_RELEASE_PLAN.RELEASE_PLAN_ID = A.RELEASE_PLAN_ID
      AND		 TH_BUF_CELL_RELEASE_PLAN.AMEND_PLAN_ID   = A.AMEND_PLAN_ID
      AND		 TH_BUF_CELL_RELEASE_PLAN.INSTANCE_DATE   = A.INSTANCE_DATE
      
      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null  
      

      INSERT INTO TH_BUF_CELL_RELEASE_PLAN
        (
          INSTANCE_ID , 
          FACTORY_ID,
          INSTANCE_DATE , 
          RELEASE_DATE , 
          RELEASE_PLAN_ID , 
          AMEND_PLAN_ID ,
          PLAN_GROUP , 
          LINE_ID ,
          ATTR_1 , 
          ATTR_2
        )
      SELECT  A.INSTANCE_ID , 
              A.FACTORY_ID ,
              A.INSTANCE_DATE , 
              A.RELEASE_DATE , 
              A.RELEASE_PLAN_ID , 
              A.AMEND_PLAN_ID ,
              A.PLAN_GROUP_ID AS PLAN_GROUP, 
              A.LINE_ID  , 
              CASE WHEN A.CHK_ID = A.RELEASE_PLAN_ID THEN 'Y' ELSE '-' END AS ATTR_1 ,
              'Y' AS ATTR_2
			FROM (
		  		  SELECT	INSTANCE_ID , 
      							INSTANCE_DATE , 
      							DIVISION_ID , 
      							FACTORY_ID ,
		  			        MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE , DIVISION_ID  , LINE_ID    ) AS RELEASE_PLAN_ID ,
							      AMEND_PLAN_ID,
		  				      CASE  WHEN RELEASE_PLAN_ID = MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE , DIVISION_ID , LINE_ID   ) 
      		  					    THEN 'Y'
      		  					    ELSE 'N'
    		  			    END AS CK_ID,			  
							      A.SEQ ,
							      CONVERT(DATE, A.INSTANCE_DATE) AS RELEASE_DATE ,   -- 2018.03.26 : RELEASE 일자 이후부터 타겟 , 
                    A.PLAN_GROUP_ID, 
                    A.LINE_ID  , 
                    MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID , INSTANCE_DATE , DIVISION_ID  , LINE_ID    )  AS CHK_ID -- MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID) AS CHK_ID
			      FROM (
      						SELECT  A.INSTANCE_ID , 
                          A.INSTANCE_DATE , 
                          A.DIVISION_ID , 
                          MIN(A.RELEASE_PLAN_ID) OVER ( PARTITION BY   A.INSTANCE_ID , A.INSTANCE_DATE , A.DIVISION_ID , B.LINE_ID   ) AS RELEASE_PLAN_ID  , 
                          MAX(A.AMEND_PLAN_ID)   OVER ( PARTITION BY   A.INSTANCE_ID , A.INSTANCE_DATE , A.DIVISION_ID , B.LINE_ID   ) AS  AMEND_PLAN_ID, 
                          CASE WHEN A.FACTORY_ID ='-' THEN B.FACTORY_ID ELSE A.FACTORY_ID END AS FACTORY_ID , 
      							      DENSE_RANK() OVER (PARTITION BY A.PLAN_GROUP_ID
      												                ORDER     BY A.INSTANCE_DATE DESC) AS SEQ , 
                          A.PLAN_GROUP_ID, 
                          B.LINE_ID
      						FROM   FP_RELEASE_PLAN_INFO_H  A 
                          LEFT OUTER JOIN(
                                          SELECT DISTINCT INSTANCE_ID , FACTORY_ID  , LINE_ID  , MODEL_TYPE
                                          FROM FP_INSTANCE_LINE_V
                                          WHERE INSTANCE_ID = @v_master_id
                                          )B
                                ON A.INSTANCE_ID = B.INSTANCE_ID
                                AND A.PLAN_GROUP_ID = B.MODEL_TYPE
  							  WHERE   A.INSTANCE_ID = @v_master_id
                  AND	    A.PLAN_GROUP_ID IN ( SELECT PLAN_GROUP_ID FROM FP_USER_LINE_GROUP_M WHERE INSTANCE_ID = @v_master_id )
						      ) A
  				  WHERE  SEQ = 1  
			      )A
      
      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null        


    END
    ELSE
    BEGIN    

      DELETE TH_BUF_CELL_RELEASE_PLAN
      FROM (
    				SELECT  A.INSTANCE_ID , 
                    A.FACTORY_ID ,
                    A.INSTANCE_DATE , 
                    A.RELEASE_DATE , 
                    A.RELEASE_PLAN_ID , 
                    A.AMEND_PLAN_ID  
      			FROM (
      		  		  SELECT	INSTANCE_ID , 
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
      							      CONVERT(DATE, A.INSTANCE_DATE) AS RELEASE_DATE ,     -- 2018.03.26 : RELEASE 일자 이후부터 타겟
                          MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID) AS CHK_ID
      			      FROM (
            						SELECT  DISTINCT A.INSTANCE_ID , 
                                A.INSTANCE_DATE , 
                                A.DIVISION_ID , 
                                MIN(A.RELEASE_PLAN_ID) OVER ( PARTITION BY   A.INSTANCE_ID , A.INSTANCE_DATE , A.DIVISION_ID , A.FACTORY_ID   ) AS RELEASE_PLAN_ID  , 
                                MAX(A.AMEND_PLAN_ID)   OVER ( PARTITION BY   A.INSTANCE_ID , A.INSTANCE_DATE , A.DIVISION_ID , A.FACTORY_ID   ) AS  AMEND_PLAN_ID, 
                                CASE WHEN A.FACTORY_ID ='-' THEN B.FACTORY_ID ELSE A.FACTORY_ID END AS FACTORY_ID , 
            							      DENSE_RANK() OVER (PARTITION BY CASE WHEN A.FACTORY_ID ='-' THEN B.FACTORY_ID ELSE A.FACTORY_ID END
            												                ORDER     BY A.INSTANCE_DATE DESC) AS SEQ
            						FROM   FP_RELEASE_PLAN_INFO_H  A 
                                LEFT OUTER JOIN(
                                                SELECT DISTINCT INSTANCE_ID , FACTORY_ID 
                                                FROM FP_INSTANCE_LINE_V
                                                WHERE INSTANCE_ID = @v_master_id
                                                )B
                                      ON A.INSTANCE_ID = B.INSTANCE_ID
        							  WHERE  A.INSTANCE_ID = @v_master_id
      						      ) A
        				  WHERE  SEQ = 1  
      			      )A
      			)A
      WHERE  TH_BUF_CELL_RELEASE_PLAN.INSTANCE_ID  = @v_master_id
      AND		 TH_BUF_CELL_RELEASE_PLAN.INSTANCE_ID  = A.INSTANCE_ID
      AND		 TH_BUF_CELL_RELEASE_PLAN.FACTORY_ID   = A.FACTORY_ID
      AND		 TH_BUF_CELL_RELEASE_PLAN.RELEASE_PLAN_ID = A.RELEASE_PLAN_ID
      AND		 TH_BUF_CELL_RELEASE_PLAN.AMEND_PLAN_ID   = A.AMEND_PLAN_ID
      AND		 TH_BUF_CELL_RELEASE_PLAN.INSTANCE_DATE   = A.INSTANCE_DATE
      
      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null  
      
                
      INSERT INTO TH_BUF_CELL_RELEASE_PLAN
        (
          INSTANCE_ID , 
          FACTORY_ID,
          INSTANCE_DATE , 
          RELEASE_DATE , 
          RELEASE_PLAN_ID , 
          AMEND_PLAN_ID ,
          ATTR_1 , 
          ATTR_2
        )
      SELECT  A.INSTANCE_ID , 
              A.FACTORY_ID ,
              A.INSTANCE_DATE , 
              A.RELEASE_DATE , 
              A.RELEASE_PLAN_ID , 
              A.AMEND_PLAN_ID , 
              CASE WHEN A.CHK_ID = A.RELEASE_PLAN_ID THEN 'Y' ELSE '-' END AS ATTR_1 ,
              'Y' AS ATTR_2
			FROM (
		  		  SELECT	INSTANCE_ID , 
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
							      CONVERT(DATE, A.INSTANCE_DATE) AS RELEASE_DATE ,    -- 2018.03.26 : RELEASE 일자 이후부터 타겟
                    MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID) AS CHK_ID
			      FROM (
      						SELECT  DISTINCT A.INSTANCE_ID , 
                          A.INSTANCE_DATE , 
                          A.DIVISION_ID , 
                          MIN(A.RELEASE_PLAN_ID) OVER ( PARTITION BY   A.INSTANCE_ID , A.INSTANCE_DATE , A.DIVISION_ID , A.FACTORY_ID   ) AS RELEASE_PLAN_ID  , 
                          MAX(A.AMEND_PLAN_ID)   OVER ( PARTITION BY   A.INSTANCE_ID , A.INSTANCE_DATE , A.DIVISION_ID , A.FACTORY_ID   ) AS  AMEND_PLAN_ID, 
                          CASE WHEN A.FACTORY_ID ='-' THEN B.FACTORY_ID ELSE A.FACTORY_ID END AS FACTORY_ID , 
      							      DENSE_RANK() OVER (PARTITION BY CASE WHEN A.FACTORY_ID ='-' THEN B.FACTORY_ID ELSE A.FACTORY_ID END
      												                ORDER     BY A.INSTANCE_DATE DESC) AS SEQ
      						FROM   FP_RELEASE_PLAN_INFO_H  A 
                          LEFT OUTER JOIN(
                                          SELECT DISTINCT INSTANCE_ID , FACTORY_ID 
                                          FROM FP_INSTANCE_LINE_V
                                          WHERE INSTANCE_ID = @v_master_id
                                          )B
                                ON A.INSTANCE_ID = B.INSTANCE_ID
  							  WHERE  A.INSTANCE_ID = @v_master_id
						      ) A
  				  WHERE  SEQ = 1  
			      )A
        
        --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null      

      
      END

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null   

      SELECT @v_plan_id =  max(amend_plan_id) , 
             @v_plan_date = max(INSTANCE_DATE) 
  	  FROM  TH_BUF_CELL_RELEASE_PLAN
  	  WHERE INSTANCE_ID = @v_master_id 

      --LOG 생성
      SET @v_message = 'plan id : ' + convert(nvarchar , @v_plan_id , 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null   
      
  	  
	    SET @v_table_name = 'TH_BUF_NOTCHING_REPORT'
      
      DELETE TH_BUF_NOTCHING_REPORT WHERE INSTANCE_ID = @v_master_id 

	    --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null 
      
      /*
        Noching(Winder) 실적 
      */

      IF @v_plan_group =  'PLAN_GROUP' 
      BEGIN

         INSERT INTO TH_BUF_NOTCHING_REPORT
            		(
            			TYPE ,
            			INSTANCE_ID ,
            			FP_PLAN_ID ,
            			COMPANY_ID ,
            			DIVISION_ID ,
            			SITE_ID ,
            			PLANT_ID ,
            			FACTORY_ID ,
            			LINE_ID ,
            			OPERATION_ID ,
            			ITEM_ID ,
            			SPEC ,
            			PRODUCTION_TYPE ,
            			MARKET ,
            			PLAN_DATE ,
            			PLAN_WEEK ,
            			QTY , 
        					ATTR_1 ,
        					ATTR_2 
            		)                      		
        SELECT	'ASSY_RESULT' AS TYPE ,
        				@v_master_id AS INSTANCE_ID , 
        				@v_plan_id AS FP_PLAN_ID , 
        				A.COMPANY_ID ,
        				A.DIVISION_ID , 
        				A.SITE_ID , 
        				A.PLANT_ID ,
        				A.FACTORY_ID , 
        				A.LINE_ID , 
        				A.OPERATION_ID , 
        				A.ITEM_ID , 
        				NULL AS SPEC , 
        				A.PRODUCTION_TYPE , 
        				A.MARKET ,
        				A.PLAN_DATE AS PLAN_DATE , 
        				D.WEEK	AS PLAN_WEEK ,
        				SUM(A.ACTUAL_QTY) AS QTY ,  -- 투입실적
  					    A.TOP_ITEM_ID AS ATTR_1 , 
  					    A.ITEM_ID AS ATTR_2
        FROM	  SCM_DAILY_PRODUCT_RESULT_H A 
        			  INNER JOIN  (
        			  							SELECT INSTANCE_ID , COMPANY_ID , DIVISION_ID , SITE_ID, OPERATION_ID
        			  							FROM  FP_INSTANCE_OPERATION_V
        			  							GROUP BY INSTANCE_ID , COMPANY_ID , DIVISION_ID , SITE_ID, OPERATION_ID
        			  						)B
            		 		ON A.COMPANY_ID   = B.COMPANY_ID
            		 		AND A.DIVISION_ID = B.DIVISION_ID
            		 		AND A.SITE_ID     = B.SITE_ID
            		 		AND A.OPERATION_ID = B.OPERATION_ID
        		 	  INNER JOIN	( 
                      				SELECT  B.LINE_ID,  B.FACTORY_ID , B.RELEASE_DATE , A.WEEKSTART_DATE 
              								FROM  SCM_SYS_CALENDAR_M A ,
                  									(
                  										SELECT  FACTORY_ID , MIN (RELEASE_DATE) AS RELEASE_DATE , LINE_ID
                  										FROM    TH_BUF_CELL_RELEASE_PLAN
                  										WHERE   INSTANCE_ID = @v_master_id 
                                      AND     ATTR_2 = 'Y'
                  										GROUP BY FACTORY_ID , LINE_ID 
                  									)B
              								WHERE A.DATE_ID = B.RELEASE_DATE  
        		 		 			      )C
          		 		  ON A.FACTORY_ID = C.FACTORY_ID
          		 		  AND A.LINE_ID   = C.LINE_ID
          		 		  AND A.PLAN_DATE >= C.WEEKSTART_DATE  -- 실적을 몇일전까지 보여줘야하는가
          		 		  AND A.PLAN_DATE < C.RELEASE_DATE
          		 		  --AND A.CUTOFF_DATE = C.RELEASE_DATE
      		 		  INNER JOIN SCM_SYS_CALENDAR_M D 
        		 		    ON A.PLAN_DATE = D.DATE_ID
        WHERE B.INSTANCE_ID = @v_master_id 
        AND	  B.OPERATION_ID =  (SELECT  MIN(OPERATION_ID) AS OPERATION_ID FROM FP_INSTANCE_OPERATION_V WHERE INSTANCE_ID = @v_master_id  ) -- 조립 선행공정 ( Winder /Notching)
    		GROUP  BY   A.COMPANY_ID ,
                		A.DIVISION_ID , 
                		A.SITE_ID , 
                		A.PLANT_ID ,
                		A.FACTORY_ID , 
                		A.LINE_ID , 
                		A.OPERATION_ID , 
                		A.ITEM_ID , 
                		A.PRODUCTION_TYPE , 
                		A.MARKET ,
                		A.PLAN_DATE,
                		D.WEEK,
          				  A.TOP_ITEM_ID,
          				  A.ITEM_ID
      
      END
      ELSE
      BEGIN
              
        INSERT INTO TH_BUF_NOTCHING_REPORT
            		(
            			TYPE ,
            			INSTANCE_ID ,
            			FP_PLAN_ID ,
            			COMPANY_ID ,
            			DIVISION_ID ,
            			SITE_ID ,
            			PLANT_ID ,
            			FACTORY_ID ,
            			LINE_ID ,
            			OPERATION_ID ,
            			ITEM_ID ,
            			SPEC ,
            			PRODUCTION_TYPE ,
            			MARKET ,
            			PLAN_DATE ,
            			PLAN_WEEK ,
            			QTY , 
        					ATTR_1 ,
        					ATTR_2 
            		)
        SELECT	'ASSY_RESULT' AS TYPE ,
        				 @v_master_id AS INSTANCE_ID , 
        				 @v_plan_id AS FP_PLAN_ID , 
        				 A.COMPANY_ID ,
        				 A.DIVISION_ID , 
        				 A.SITE_ID , 
        				 A.PLANT_ID ,
        				 A.FACTORY_ID , 
        				 A.LINE_ID , 
        				 A.OPERATION_ID , 
        				 A.ITEM_ID , 
        				 NULL AS SPEC , 
        				 A.PRODUCTION_TYPE , 
        				 A.MARKET ,
        				 A.PLAN_DATE AS PLAN_DATE , 
        				 D.WEEK	AS PLAN_WEEK ,
        				 SUM(A.ACTUAL_QTY) AS QTY ,
  					     A.TOP_ITEM_ID AS ATTR_1 , 
  					     A.ITEM_ID AS ATTR_2
        FROM	  SCM_DAILY_PRODUCT_RESULT_H A 
        			  INNER JOIN  FP_INSTANCE_OPERATION_V B
            		 		ON A.COMPANY_ID = B.COMPANY_ID
            		 		AND A.DIVISION_ID = B.DIVISION_ID
            		 		AND A.SITE_ID = B.SITE_ID
            		 		AND A.OPERATION_ID = B.OPERATION_ID
        		 	  INNER JOIN	( 
                              SELECT   B.FACTORY_ID , B.RELEASE_DATE , A.WEEKSTART_DATE 
              								FROM  SCM_SYS_CALENDAR_M A ,
                  									(
                  										SELECT  FACTORY_ID , MIN (RELEASE_DATE) AS RELEASE_DATE
                  										FROM    TH_BUF_CELL_RELEASE_PLAN
                  										WHERE   INSTANCE_ID = @v_master_id 
                                      AND     ATTR_2 = 'Y'
                  										GROUP BY FACTORY_ID
                  									)B
              								WHERE A.DATE_ID = B.RELEASE_DATE  
        		 		 			      )C
          		 		  ON  A.FACTORY_ID = C.FACTORY_ID
          		 		  AND A.PLAN_DATE >= C.WEEKSTART_DATE -- 실적을 몇일전까지 보여줘야하는가
          		 		  AND A.PLAN_DATE < C.RELEASE_DATE
          		 		  --  AND A.CUTOFF_DATE = C.RELEASE_DATE
        		 		 INNER JOIN SCM_SYS_CALENDAR_M D 
        		 		    ON A.PLAN_DATE = D.DATE_ID
        WHERE B.INSTANCE_ID = @v_master_id 
        AND	  B.OPERATION_ID =  (SELECT  MIN(OPERATION_ID) AS OPERATION_ID FROM FP_INSTANCE_OPERATION_V WHERE INSTANCE_ID = @v_master_id  ) -- 조립 선행공정 ( Winder /Notching)
    		GROUP  BY   A.COMPANY_ID ,
            				A.DIVISION_ID , 
            				A.SITE_ID , 
            				A.PLANT_ID ,
            				A.FACTORY_ID , 
            				A.LINE_ID , 
            				A.OPERATION_ID , 
            				A.ITEM_ID , 
            				A.PRODUCTION_TYPE , 
            				A.MARKET ,
            				A.PLAN_DATE,
            				D.WEEK,
      					    A.TOP_ITEM_ID,
      					    A.ITEM_ID

      END
      
      --LOG 생성
      SET @v_message = 'ASSY_RESULT ' + convert(nvarchar,@@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null  

      /*
        조립 계획 6주구간 
      */
      
      INSERT INTO TH_BUF_NOTCHING_REPORT
          		(
          			TYPE ,
          			INSTANCE_ID ,
          			FP_PLAN_ID ,
          			COMPANY_ID ,
          			DIVISION_ID ,
          			SITE_ID ,
          			PLANT_ID ,
          			FACTORY_ID ,
          			LINE_ID ,
          			OPERATION_ID ,
          			ITEM_ID ,
          			SPEC ,
          			PRODUCTION_TYPE ,
          			MARKET ,
          			PLAN_DATE ,
          			PLAN_WEEK ,
          			QTY , 
      					ATTR_1 , 
      					ATTR_2
          		)      			        		
       SELECT	A.TYPE , 
        			A.INSTANCE_ID , 
        			A.FP_PLAN_ID , 
        			A.COMPANY_ID , 
        			A.DIVISION_ID ,
        			A.SITE_ID , 
        			A.PLANT_ID , 
        			A.FACTORY_ID , 
        			A.LINE_ID , 
        			A.OPERATION_ID , 
        			A.ITEM_ID , 
        			A.SPEC , 
        			A.PRODUCTION_TYPE , 
        			A.MARKET , 
        			A.PLAN_DATE , 
        			A.WEEK AS PLAN_WEEK  , 
        			SUM(PLAN_IN_QTY) AS QTY ,
      				A.TOP_ITEM_ID , 
      				A.ITEM_ID
      FROM (
            SELECT 	DISTINCT 'ASSY_PLAN' AS TYPE ,
                          		@v_master_id AS INSTANCE_ID , 
                          		A.RELEASE_PLAN_ID AS FP_PLAN_ID ,   	
                          		(SELECT DISTINCT COMPANY_ID FROM FP_INSTANCE_OPERATION_V WHERE INSTANCE_ID = @v_master_id )AS COMPANY_ID,
                            	C.DIVISION_ID , 
                          		C.SITE_ID , 
                          		C.PLANT_ID ,
                          		C.FACTORY_ID , 
                          		A.LINE_ID , 
                          		A.OPERATION_ID,
                          		A.ITEM_ID , 
                          		NULL AS SPEC , 
                          		A.PRODUCTION_TYPE , 
                          		A.MARKET ,  
                          		A.PLAN_DATE , 
                          	  --CASE WHEN DATEADD(DAY,SEGMENT2 * -1, A.PLAN_DATE) < B.RELEASE_DATE THEN B.RELEASE_DATE ELSE DATEADD(DAY,SEGMENT2 * -1, A.PLAN_DATE) END AS PLAN_DATE , 
                          		D.WEEK AS WEEK , 
                          		A.PLAN_QTY , 
                          		A.PLAN_IN_QTY , 
                          		A.WORK_ORDER_ID ,  
          					          A.TOP_ITEM_ID
            FROM  FP_RELEASE_FULL_PLAN_H A 
            		    INNER JOIN (
                                SELECT  INSTANCE_ID , FACTORY_ID  , RELEASE_PLAN_ID  , LINE_ID , RELEASE_DATE
                                FROM    TH_BUF_CELL_RELEASE_PLAN
                                WHERE 1=1 
                                AND 		INSTANCE_ID = @v_master_id
                                AND   	ATTR_2 ='Y'
                                --AND		INSTANCE_DATE=  '20190103'
                                GROUP BY INSTANCE_ID , FACTORY_ID  , RELEASE_PLAN_ID , LINE_ID , RELEASE_DATE
                              ) B
              					ON    A.INSTANCE_ID = B.INSTANCE_ID
              					AND   A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID
              					AND   A.FACTORY_ID = B.FACTORY_ID
                        AND   ((@v_plan_group =  'PLAN_GROUP'  AND  A.LINE_ID = B.LINE_ID ) OR ( 1=1) )
            		    INNER JOIN FP_INSTANCE_LINE_V C
                		 		ON    A.DIVISION_ID = C.DIVISION_ID
                		 		AND   A.FACTORY_ID = C.FACTORY_ID
                		 		AND   A.OPERATION_ID = C.OPERATION_ID	
                		 		AND   A.LINE_ID = C.LINE_ID 
            		    INNER JOIN 	SCM_SYS_CALENDAR_M D
            		    		ON    A.PLAN_DATE = D.DATE_ID
            		    INNER JOIN (
                    						SELECT A.FACTORY_ID , B.WEEK AS LAST_WEEK
                    						FROM (
                      								SELECT B.FACTORY_ID , B.WEEK , A.SEQ + 5    AS SEQ-- 6주구간
                      								FROM (
                      											SELECT WEEK , DENSE_RANK() OVER (ORDER BY WEEK) AS  SEQ
                      											FROM SCM_SYS_CALENDAR_M
                      											GROUP BY WEEK
                      									    )A  , 
                      									    (
                          									SELECT   DISTINCT  FACTORY_ID ,  WEEK 
                          									FROM SCM_SYS_CALENDAR_M A ,
                          											(
                          												SELECT  FACTORY_ID , MIN (RELEASE_DATE) AS RELEASE_DATE
                          												FROM TH_BUF_CELL_RELEASE_PLAN
                          												WHERE INSTANCE_ID = @v_master_id 
                                                  AND   	ATTR_2 ='Y'
                                                  						--AND		INSTANCE_DATE=  '20190103'	
                          												GROUP BY FACTORY_ID
                          											)B
                          									WHERE A.DATE_ID = B.RELEASE_DATE  
                      									    )B
                      								WHERE A.WEEK = B.WEEK
                    							    )A INNER JOIN (
                            												SELECT WEEK , SEQ 
                        														FROM (
                          																SELECT WEEK , DENSE_RANK() OVER (ORDER BY WEEK) AS  SEQ
                          																FROM SCM_SYS_CALENDAR_M
                          																GROUP BY WEEK
            																              )A
                    											          )B
                    									    ON A.SEQ = B.SEQ 
            						        )E
                  			ON    A.FACTORY_ID = E.FACTORY_ID 
                  			AND   D.WEEK < = E.LAST_WEEK
                		 /*LEFT OUTER JOIN 	 SCM_SYS_LOOKUP_VALUE F
                  			 ON   F.LOOKUP_TYPE_CODE = 'PANCAKE_REQUIED_LEAD_TIME'
                  			 AND  A.INSTANCE_ID = F.SEGMENT1  */
            WHERE B.INSTANCE_ID = @V_MASTER_ID
            AND   B.INSTANCE_ID = C.INSTANCE_ID
            AND		C.OPERATION_ID = (SELECT  MIN(OPERATION_ID) AS OPERATION_ID FROM FP_INSTANCE_OPERATION_V WHERE INSTANCE_ID = @v_master_id  )
            )A
      GROUP BY  A.TYPE , 
          			A.INSTANCE_ID , 
          			A.FP_PLAN_ID , 
          			A.COMPANY_ID,
          			A.DIVISION_ID ,
          			A.SITE_ID , 
          			A.PLANT_ID , 
          			A.FACTORY_ID , 
          			A.LINE_ID , 
          			A.OPERATION_ID , 
          			A.ITEM_ID , 
          			A.SPEC , 
          			A.PRODUCTION_TYPE , 
          			A.MARKET , 
          			A.PLAN_DATE , 
          			A.WEEK  ,
    				    A.TOP_ITEM_ID
   
      --LOG 생성
      SET @v_message = 'ASSY_PLAN ' + convert(nvarchar,@@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null 
      
      UPDATE TH_BUF_NOTCHING_REPORT
      SET   TH_BUF_NOTCHING_REPORT.PLAN_WEEK = B.WEEK
      FROM  SCM_SYS_CALENDAR_M B
      WHERE TH_BUF_NOTCHING_REPORT.INSTANCE_ID = @v_master_id
      AND   TH_BUF_NOTCHING_REPORT.FP_PLAN_ID = @v_plan_id
      AND   TH_BUF_NOTCHING_REPORT.TYPE = 'ASSY_PLAN' 
      AND   TH_BUF_NOTCHING_REPORT.PLAN_DATE = B.DATE_ID
      
      
      /*
        6주구간 전극 Pancake data 생성
      */
      
      INSERT INTO TH_BUF_NOTCHING_REPORT
          		(
          			TYPE ,
          			INSTANCE_ID ,
          			FP_PLAN_ID ,
          			COMPANY_ID ,
          			DIVISION_ID ,
          			SITE_ID ,
          			PLANT_ID ,
          			FACTORY_ID ,
          			LINE_ID ,
          			OPERATION_ID ,
          			ITEM_ID ,
          			SPEC ,
          			PRODUCTION_TYPE ,
          			MARKET ,
          			PLAN_DATE ,
          			PLAN_WEEK ,
          			QTY ,
      					ATTR_1 ,
      					ATTR_2 , 
      					ATTR_3 ,
                ORG_QTY
          		)    		
      SELECT    A.TYPE ,
                A.INSTANCE_ID , 
      		      A.FP_PLAN_ID ,  
                A.COMPANY_ID , 
          			A.DIVISION_ID ,
          			A.SITE_ID , 
          			A.PLANT_ID , 
          			A.FACTORY_ID , 
          			A.LINE_ID , 
          			A.OPERATION_ID , 
          			A.ITEM_ID , 
          			A.SPEC , 
          			A.PRODUCTION_TYPE  , 
          			A.MARKET , 
          			A.PLAN_DATE , 
          			A.PLAN_WEEK ,
          			SUM(A.QTY) AS QTY ,
        				A.ATTR_1,
        				A.ATTR_2 ,
        				A.ITEM_ID AS ATTR_3 , 
                SUM(A.QTY) AS ORG_QTY
      FROM (
            SELECT 'PANCAKE_PLAN' AS TYPE , 
                		A.INSTANCE_ID , 
                		A.FP_PLAN_ID , 
                		A.COMPANY_ID , 
                		A.DIVISION_ID , 
                		A.SITE_ID , 
                		'-' AS PLANT_ID , 
                		'-' AS FACTORY_ID  ,
                		'-' AS LINE_ID , 
                		'-' AS  OPERATION_ID , 
                		B.CHILD_ITEM_ID AS ITEM_ID , 
                		C.SPEC , 
                		A.PRODUCTION_TYPE , 
                		A.MARKET , 
                		A.PLAN_DATE  , 
                		A.PLAN_WEEK ,
                		--CEILING(A.QTY * ( B.CHILD_QTY / B.PARENT_QTY)  * ( 1 / CASE WHEN ISNULL(D.YIELD , ISNULL(E.YIELD , 1 ) ) = 0 THEN 1 ELSE  ISNULL(D.YIELD , ISNULL(E.YIELD , 1 ) )  END ) ) AS QTY , 
                    (A.QTY * ( B.CHILD_QTY / B.PARENT_QTY)) AS QTY  , 
          					A.ATTR_1,
          					A.ATTR_2
            FROM TH_BUF_NOTCHING_REPORT A 
            				INNER JOIN SCM_BOM_M B
              					ON A.COMPANY_ID = B.COMPANY_ID
              					AND A.DIVISION_ID = B.DIVISION_ID 
              					AND A.SITE_ID = B.SITE_ID 
              					AND A.PLANT_ID = B.PLANT_ID 
              					AND A.ITEM_ID = B.PARENT_ITEM_ID
              					AND A.PLAN_DATE >= B.EFF_START_DATE
              					AND A.PLAN_DATE < B.EFF_END_DATE
                        AND ISNULL(B.ALT_PRIORITY, 1) = 1
            				INNER JOIN SCM_ITEM_M	 C
              					ON   B.COMPANY_ID = C.COMPANY_ID
              					AND	B.DIVISION_ID = C.DIVISION_ID
              					AND	B.SITE_ID = C.SITE_ID
              					AND B.CHILD_ITEM_ID = C.ITEM_ID
              					AND C.ITEM_TYPE  <> 'R'  			
                   /* INNER JOIN SCM_ITEM_CLASS_M D
                        ON 	  C.ITEM_CLASS = D.CLASS_ID			
                        AND 	D.LEVEL_2_NAME = 'Notched Pancake'	*/
            				/*LEFT OUTER  JOIN SCM_YIELD_EXCEPT_M  D
        			 					ON A.COMPANY_ID = D.COMPANY_ID 
        			 					AND A.DIVISION_ID = D.DIVISION_ID 
        			 					AND A.SITE_ID = D.SITE_ID 
        			 					AND A.ITEM_ID = D.ITEM_ID
        			 					AND A.PLAN_DATE >= D.START_TIME
        			 					AND A.PLAN_DATE < D.END_TIME
        			 					AND D.ACTIVE_FLAG = 'Y'
		 					      LEFT OUTER JOIN  (
              		 										SELECT COMPANY_ID , DIVISION_ID , SITE_ID  , ITEM_ID ,MAX(YIELD) AS YIELD , MONTH
              												FROM 	SCM_YIELD_M
              												WHERE OPERATION_ID =  (SELECT  MIN(OPERATION_ID) AS OPERATION_ID FROM FP_INSTANCE_OPERATION_V WHERE INSTANCE_ID = @v_master_id  )
                                                  /*(	SELECT  MAX(OPERATION_ID) AS OPERATION_ID 
              		 																FROM FP_INSTANCE_OPERATION_V
              		 																WHERE INSTANCE_ID like '%E_PRE%' 
              		 																AND AMEND_FLAG = 'Y')*/
              												GROUP BY COMPANY_ID , DIVISION_ID , SITE_ID  , ITEM_ID , MONTH
		 									                ) E
        		 						ON  A.COMPANY_ID = E.COMPANY_ID 
        			 					AND A.DIVISION_ID = E.DIVISION_ID 
        			 					AND A.SITE_ID = E.SITE_ID 
        			 					AND A.ITEM_ID = E.ITEM_ID	
        			 					AND CONVERT(NVARCHAR(6) , A.PLAN_DATE , 112) = E.MONTH */
			      WHERE   A.INSTANCE_ID = @v_master_id 
            AND     A.TYPE IN ('ASSY_PLAN','ASSY_RESULT')		
        	  )A	
		 	GROUP BY 	A.TYPE,
    						A.INSTANCE_ID , 
          			A.FP_PLAN_ID ,  
    						A.COMPANY_ID , 
    		 				A.DIVISION_ID ,
    		 				A.SITE_ID , 
    		 				A.PLANT_ID , 
    		 				A.FACTORY_ID , 
    		 				A.LINE_ID , 
    		 				A.OPERATION_ID , 
    		 				A.ITEM_ID , 
    		 				A.SPEC , 
    		 				A.PRODUCTION_TYPE  , 
    		 				A.MARKET , 
    		 				A.PLAN_DATE , 
    		 				A.PLAN_WEEK ,
    						A.ATTR_1,
    						A.ATTR_2
                  
      --LOG 생성
      SET @v_message = 'PANCAKE ' + convert(nvarchar,@@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null 
      
      /*
        Pancake operatio / plant 지정
      */
      
      UPDATE  TH_BUF_NOTCHING_REPORT
      SET     TH_BUF_NOTCHING_REPORT.PLANT_ID = A.PLANT_ID , 
       		    TH_BUF_NOTCHING_REPORT.FACTORY_ID = A.FACTORY_ID , 
     		      TH_BUF_NOTCHING_REPORT.OPERATION_ID = A.OPERATION_ID 
      FROM (
        		SELECT COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , FACTORY_ID, ITEM_ID , OPERATION_ID , ELECTRODE_TYPE 
        		FROM 	SCM_ITEM_LINE_ASSIGN_M 
        		WHERE OPERATION_ID = (	SELECT  MAX(OPERATION_ID) AS OPERATION_ID 
                  		 							FROM FP_INSTANCE_OPERATION_V
                  		 							WHERE INSTANCE_ID like '%E_PRE%' 
                  		 							AND AMEND_FLAG = 'Y')
        		GROUP BY COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , FACTORY_ID , ITEM_ID , OPERATION_ID , ELECTRODE_TYPE
       		)A
      WHERE		TH_BUF_NOTCHING_REPORT.TYPE = 'PANCAKE_PLAN'
      AND		  TH_BUF_NOTCHING_REPORT.COMPANY_ID = A.COMPANY_ID
      AND		  TH_BUF_NOTCHING_REPORT.DIVISION_ID = A.DIVISION_ID
      AND		  TH_BUF_NOTCHING_REPORT.SITE_ID = A.SITE_ID
       --AND		  TH_BUF_WINDER_ELEC_REPORT.PLANT_ID = A.PLANT_ID
      AND		  TH_BUF_NOTCHING_REPORT.ITEM_ID = A.ITEM_ID 
      
      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null 
	   	 
        /*
          Create SCM_FP_NOTCHED_PANCAKE_REPORT
        */
        BEGIN

          SET @v_table_name = 'SCM_FP_NOTCHED_PANCAKE_REPORT'

          SELECT  @v_seq = ISNULL(MAX(PLAN_SEQ) + 1,1)
          FROM    SCM_FP_NOTCHED_PANCAKE_REPORT
          WHERE   INSTANCE_ID = @V_MASTER_ID 
          AND     INSTANCE_DATE = CONVERT(NVARCHAR,@v_plan_date,112)
          
          --SELECT  @V_CREATE_PLAN_ID = CONVERT(NVARCHAR,@V_PLAN_DATE,112) +'-'  + DBO.FN_LPAD_NVARCHAR( @V_SEQ,2,0)
        
          SELECT  @V_CREATE_PLAN_ID  = MIN(RELEASE_PLAN_ID)
          FROM TH_BUF_RELEASE_PLAN
          WHERE INSTANCE_ID = @V_MASTER_ID
          AND   ATTR_1 = 'Y'

          SELECT  @V_CREATE_PLAN_ID = MIN(A.RELEASE_PLAN_ID) 
    			FROM (
    		  		  SELECT	INSTANCE_ID , 
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
    							      CONVERT(DATE, A.INSTANCE_DATE) AS RELEASE_DATE ,    -- 2018.03.26 : RELEASE 일자 이후부터 타겟
                        MIN(RELEASE_PLAN_ID) OVER ( PARTITION BY   INSTANCE_ID) AS CHK_ID
    			      FROM (
          						SELECT  DISTINCT A.INSTANCE_ID , 
                              A.INSTANCE_DATE , 
                              A.DIVISION_ID , 
                              MIN(A.RELEASE_PLAN_ID) OVER ( PARTITION BY   A.INSTANCE_ID , A.INSTANCE_DATE , A.DIVISION_ID , A.FACTORY_ID   ) AS RELEASE_PLAN_ID  , 
                              MAX(A.AMEND_PLAN_ID)   OVER ( PARTITION BY   A.INSTANCE_ID , A.INSTANCE_DATE , A.DIVISION_ID , A.FACTORY_ID   ) AS  AMEND_PLAN_ID, 
                              CASE WHEN A.FACTORY_ID ='-' THEN B.FACTORY_ID ELSE A.FACTORY_ID END AS FACTORY_ID , 
          							      DENSE_RANK() OVER (PARTITION BY CASE WHEN A.FACTORY_ID ='-' THEN B.FACTORY_ID ELSE A.FACTORY_ID END
          												                ORDER     BY A.INSTANCE_DATE DESC) AS SEQ
          						FROM   FP_RELEASE_PLAN_INFO_H  A 
                              LEFT OUTER JOIN(
                                              SELECT DISTINCT INSTANCE_ID , FACTORY_ID 
                                              FROM FP_INSTANCE_LINE_V
                                              WHERE INSTANCE_ID = @v_master_id
                                              )B
                                    ON A.INSTANCE_ID = B.INSTANCE_ID
      							  WHERE  A.INSTANCE_ID = @v_master_id
    						      ) A
      				  WHERE  SEQ = 1  
    			      )A

          
           --LOG 생성
          SET @v_message = 'CREATE PLAN ID  : ' + @V_CREATE_PLAN_ID 
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null 

          
          DELETE SCM_FP_NOTCHED_PANCAKE_REPORT
          WHERE  INSTANCE_ID = @v_master_id 
          AND    FP_PLAN_ID =  @V_CREATE_PLAN_ID
          
          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_create_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null 
  				  

          INSERT INTO SCM_FP_NOTCHED_PANCAKE_REPORT
                (
                  INSTANCE_ID ,
                  FP_PLAN_ID ,
                  DIVISION_ID ,
                  SITE_ID ,
                  PLANT_ID , 
                  CELL_TYPE ,
                  MODEL_ID ,
                  MODEL_NICK_NAME ,
                  ITEM_ID ,
                  ITEM_NICK_NAME ,
                  ELEC_ITEM_ID ,
                  ELEC_NICK_NAME ,
                  ELECTRODE_TYPE ,
                  UOM ,
                  PLAN_DATE ,
                  PLAN_WEEK ,
                  QTY ,
                  INSERT_ID ,
                  INSERT_TIME ,
                  INSTANCE_DATE , 
                  PLAN_SEQ 
                )
           SELECT   A.INSTANCE_ID , 
                    A.FP_PLAN_ID AS FP_PLAN_ID , 
                    A.DIVISION_ID , 
                    A.SITE_ID , 
                    A.PLANT_ID , 
                    B.CELL_TYPE , 
                    A.ATTR_1 AS MODEL_ID , 
                    C.NICK_NAME , 
           				  A.ATTR_2 AS ITEM_ID , 
                    D.NICK_NAME , 
                    A.ITEM_ID AS ELEC_ITEM_ID , 
                    B.NICK_NAME ,  
                    LEVEL_3_NAME AS ELECTRODE_TYPE , 
                    B.ITEM_UOM   AS UOM , 
                    A.PLAN_DATE ,  
                    A.PLAN_WEEK , 
                    SUM(A.QTY) AS QTY  , 
                    @v_proc_name AS INSERT_ID , 
                    GETDATE() AS INSERT_TIME,
                    @v_plan_date AS INSTANCE_DATE ,
                    @v_seq AS PLAN_SEQ 
           FROM   TH_BUF_NOTCHING_REPORT A 
             				LEFT OUTER  JOIN SCM_ITEM_M B 
               					ON  A.COMPANY_ID = B.COMPANY_ID
               					AND A.DIVISION_ID = B.DIVISION_ID
               					AND A.SITE_ID = B.SITE_ID 
               					AND A.ITEM_ID = B.ITEM_ID 
             				LEFT OUTER JOIN 	SCM_ITEM_M C
               					ON  A.COMPANY_ID = C.COMPANY_ID
               					AND A.DIVISION_ID = C.DIVISION_ID
               					AND A.SITE_ID = C.SITE_ID 
               					AND A.ATTR_1 = C.ITEM_ID
             				LEFT OUTER JOIN SCM_ITEM_M D
               					ON  A.COMPANY_ID = D.COMPANY_ID
               					AND A.DIVISION_ID = D.DIVISION_ID
               					AND A.SITE_ID = D.SITE_ID 
               					AND A.ATTR_2 = D.ITEM_ID
             				LEFT OUTER JOIN SCM_ITEM_CLASS_M E
               					ON  B.ITEM_CLASS = E.CLASS_ID
               					AND B.ITEM_CLASS_NAME = E.CLASS_NAME 
			      WHERE INSTANCE_ID = @v_master_id 
            AND   TYPE = 'PANCAKE_PLAN'  
            GROUP BY  A.INSTANCE_ID , 
                      A.FP_PLAN_ID ,
                      A.DIVISION_ID , 
                      A.SITE_ID , 
                      A.PLANT_ID , 
                      B.CELL_TYPE , 
                      A.ATTR_1 , 
                      C.NICK_NAME , 
             				  A.ATTR_2 , 
                      D.NICK_NAME , 
                      A.ITEM_ID , 
                      B.NICK_NAME ,  
                      LEVEL_3_NAME ,
                      B.ITEM_UOM , 
                      A.PLAN_DATE ,  
                      A.PLAN_WEEK 

            
             --LOG 생성
          SET @v_message = 'PANCAKE_PLAN + ' + CONVERT(NVARCHAR,@@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_create_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
  
          /*
            CELL PER M Calculation  
          */
          
          IF 1=2
          UPDATE SCM_FP_NOTCHED_PANCAKE_REPORT
          SET SCM_FP_NOTCHED_PANCAKE_REPORT.CELL_PER_M_QTY =  SCM_FP_NOTCHED_PANCAKE_REPORT.QTY * A.VALUE
          FROM SCM_ITEM_CONV_CALC_M A 
          WHERE SCM_FP_NOTCHED_PANCAKE_REPORT.INSTANCE_ID = @v_master_id
          AND SCM_FP_NOTCHED_PANCAKE_REPORT.FP_PLAN_ID = @v_create_plan_id
          AND SCM_FP_NOTCHED_PANCAKE_REPORT.UOM = 'M'
          AND SCM_FP_NOTCHED_PANCAKE_REPORT.DIVISION_ID =  A.DIVISION_ID
          AND SCM_FP_NOTCHED_PANCAKE_REPORT.SITE_ID = A.SITE_ID
          AND SCM_FP_NOTCHED_PANCAKE_REPORT.ELEC_ITEM_ID = A.ITEM_ID 
          AND A.CATEGORY = 'Pancake (cell/m)'
          -- OPERATION , FACTORY , PRODUCTION TYPE

          SET @v_message = 'Pancake (cell/m) + ' + CONVERT(NVARCHAR,@@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_create_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          /**/
          UPDATE TH_BUF_CELL_RELEASE_PLAN
          SET  ATTR_2 = NULL  ,
          		ATTR_3 = '-' 
          WHERE INSTANCE_ID = @v_master_id
          AND		ATTR_2 = 'Y'

          SET @v_message = '---------------------------------------'
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_create_plan_id, @v_proc_name, @v_table_name, 'END', @n_log_count, null, @v_message, null
          
        
        END

      END

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


      EXECUTE pr_log_process  null, @v_master_id, '-', @v_error_procedure, null, 'ERROR', null, @v_error_line, null, @v_error_message

      IF @@TRANCOUNT > 0
         COMMIT WORK 
    END
  END CATCH
END
