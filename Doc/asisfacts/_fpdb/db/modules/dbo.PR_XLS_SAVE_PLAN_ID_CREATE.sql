
/*
 * Program ID   : PR_XLS_SAVE_PLAN_ID_CREATE
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025.03.01   FP Pjt.         Create.
 * 
 * 
 * 
 ex) 
  exec PR_XLS_SAVE_PLAN_ID_CREATE 'UC1'

 */

CREATE PROCEDURE [dbo].[PR_XLS_SAVE_PLAN_ID_CREATE]
    @p_apl_code             nvarchar(max)		= 'UC1'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- LOG 용 변수 설정
	DECLARE @v_proc_name		NVARCHAR(100)	= 'PR_XLS_SAVE_PLAN_ID_CREATE'
	DECLARE @v_descr			NVARCHAR(250)
	DECLARE @v_count			INTEGER			= 0
	DECLARE @sysdate			DATETIME		= GETDATE()

	DECLARE @ROWCOUNT			INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1			NVARCHAR(1000)
	DECLARE @v_temp2			NVARCHAR(1000)
	DECLARE @v_temp3			NVARCHAR(1000)
	DECLARE @v_table			NVARCHAR(1000)
	DECLARE @v_check			INT;
--
	DECLARE @v_apl_code			NVARCHAR(max)
	DECLARE @v_PLAN_DATE        NVARCHAR(100) 
	DECLARE @v_PLAN_SEQ         NVARCHAR(100)
	DECLARE @FIX_TYPE           NVARCHAR(100)	= 'QTY_KEEP'
	DECLARE @DESC_ELEC          NVARCHAR(1000)	= 'PLAN ID CREATE: ELEC';
	DECLARE @DESC_CELL			NVARCHAR(1000)	= 'PLAN ID CREATE: CELL';
	DECLARE @DESC_FORM			NVARCHAR(1000)	= 'PLAN ID CREATE: FORM';
	DECLARE @FIX_DATE           NVARCHAR(10) 
	DECLARE @INSTANCE_ID        NVARCHAR(30)
	DECLARE @PLAN_ID            NVARCHAR(30)
	DECLARE @USER_ID            NVARCHAR(1000)	= @v_proc_name

	DECLARE @INX				INT				= 0;
    DECLARE @MAX_NUM			INT				= 0;

    SET @v_apl_code		= @p_apl_code

	DECLARE @vt_INSTANCE		TABLE (
		INSTANCE_ID				NVARCHAR(30),
		SITE_ID					NVARCHAR(30),
		PLAN_DATE				NVARCHAR(10),
		FIX_DATE				NVARCHAR(10),
		USER_ID					NVARCHAR(150),
		TOTAL_INSTANCE_ID		NVARCHAR(30)
		)  

	DECLARE @vt_PLAN			TABLE (
	    TID						INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		INSTANCE_ID				NVARCHAR(30),
		PLAN_ID					NVARCHAR(30)
		)  


	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY	

		BEGIN TRAN

		INSERT INTO @vt_INSTANCE (INSTANCE_ID, SITE_ID, PLAN_DATE, FIX_DATE, USER_ID, TOTAL_INSTANCE_ID)
		SELECT INSTANCE_ID, SITE_ID, PLAN_DATE
			 , CONVERT(VARCHAR, CONVERT(DATETIME, PLAN_DATE) + CONVERT(NUMERIC,ISNULL(PLAN_WEEK,'8'))* 7, 112) AS FIX_DATE
			 , USER_ID, TOTAL_INSTANCE_ID
		FROM (
          	 SELECT A.SEGMENT2 AS INSTANCE_ID
				  , A.SEGMENT3 AS SITE_ID
				  , (CASE WHEN FORMAT(dbo.FN_SITE_TIME(A.SEGMENT3) ,'yyyyMMddHHmmss') <  (FORMAT(dbo.FN_SITE_TIME(A.SEGMENT3) ,'yyyyMMdd') + B.BASIS_START_TIME)   
 				  		THEN CONVERT(VARCHAR,DATEADD(DD,-1,FORMAT(dbo.FN_SITE_TIME(A.SEGMENT3) ,'yyyyMMdd')),112)                                                
 				  		ELSE FORMAT(dbo.FN_SITE_TIME(A.SEGMENT3) ,'yyyyMMdd') END
				  ) AS  PLAN_DATE
				  , @USER_ID AS USER_ID
				  --, 'crjung' as user_id
				  , A.SEGMENT1 AS TOTAL_INSTANCE_ID
				  , C.attribute15 as plan_week
          	   FROM SCM_SYS_LOOKUP_VALUE AS A WITH(NOLOCK)
					LEFT OUTER JOIN FP_INSTANCE_START_TIME_V AS B
				 ON A.SEGMENT2				= B.instance_id
					LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE AS C WITH(NOLOCK)
				 ON A.SEGMENT2 = C.SEGMENT1
				AND C.LOOKUP_TYPE_CODE		= 'INSTANCE_ID'
				AND C.ACTIVE_FLAG			= 'Y'
          	  WHERE A.LOOKUP_TYPE_CODE		= 'TOTAL_INSTANCE_INFO'
          		AND A.ACTIVE_FLAG			= 'Y'
          		AND A.SEGMENT1				= @v_apl_code
			) AS X
			;

		SELECT @v_PLAN_SEQ = ISNULL(REPLICATE ('0',2-LEN(A.SEQ)) + CAST (A.SEQ AS VARCHAR ), '01') 
		  FROM (
			   SELECT CONVERT(NUMERIC, (CASE WHEN A.SEQ > A.SEQ2 THEN A.SEQ ELSE A.SEQ2 END)) + 1 AS SEQ
			     FROM (
				      SELECT ISNULL(MAX(RIGHT(A.PLAN_ID, 2)), '00') AS SEQ, ISNULL(MAX(RIGHT(A.INTG_PLAN_ID, 2)),'00') AS SEQ2
				        FROM SCM_FP_PLAN_H AS A WITH(NOLOCK), @vt_INSTANCE AS B 
				       WHERE 1 = 1
				         AND A.INSTANCE_ID = B.INSTANCE_ID
				         AND CONVERT(VARCHAR(8), A.PLAN_START_TIME, 112) = B.PLAN_DATE
				         AND A.PLAN_TYPE <> 'RELEASE'
			          ) A
		       ) A


        INSERT INTO SCM_FP_PLAN_H (
               INSTANCE_ID
			 , PLAN_ID
			 , PLAN_TYPE
			 , SITE_ID
             , PLAN_START_TIME
			 , PLAN_HORIZON
			 , PLAN_HORIZON_UOM
			 , DEMAND_HORIZON
             , DEMAND_HORIZON_UOM
			 , CONFIG_SET_ID
			 , BASIS_PLAN_ID
			 , DEMAND_PLAN_ID
             , SCP_PLAN_ID
			 , PLAN_WEEK
			 , CONFIRM_FLAG
			 , PRE_FIX_FLAG
             , PRE_FIX_TARGET_ID
			 , SYNC_OPERATION_ID
			 , DESCRIPTION
			 , INSERT_ID
             , INSERT_TIME
			 , UPDATE_ID
			 , UPDATE_TIME
			 , PRE_FIX_DATE
             , PRE_FIX_TYPE
			 , PRE_FIX_DATE1
			 , PRE_FIX_TYPE1
			 , PRE_FIX_DATE2
             , PRE_FIX_TYPE2
			 , INTG_PLAN_ID
             )
        SELECT A.INSTANCE_ID
		     , A.PLAN_ID
			 , 'PRE' AS PLAN_TYPE
			 , A.SITE_ID
             , dbo.FN_GET_BASISTIME(A.INSTANCE_ID, A.PLAN_ID) AS PLAN_START_TIME
			 , A.FIX_DAY AS PLAN_HORIZON, 'DAY' AS PLAN_HORIZON_UOM
			 , A.FIX_DAY AS DEMAND_HORIZON
             , 'DAY' AS DEMAND_HORIZON_UOM
			 , 'LG_CHEM' AS CONFIG_SET_ID
			 , A.PLAN_ID AS BASIS_PLAN_ID
			 , NULL AS DEMAND_PLAN_ID
             , NULL AS SCP_PLAN_ID
			 , B.ISO_YYYYWW AS PLAN_WEEK
			 , 'N' AS CONFIRM_FLAG
			 , 'N' AS PRE_FIX_FLAG
             , NULL AS PRE_FIX_TARGET_ID,  NULL AS SYNC_OPERATION_ID, A.DESCRIPTION, A.USER_ID AS INSERT_ID
             , dbo.FN_SITE_TIME(A.SITE_ID) AS INSERT_TIME
			 , A.USER_ID AS UPDATE_ID, dbo.FN_SITE_TIME(A.SITE_ID) AS UPDATE_TIME
			 , CONVERT(DATE, FIX_DATE) AS PRE_FIX_DATE
             , @FIX_TYPE AS PRE_FIX_TYPE
			 , CONVERT(DATE, FIX_DATE) AS PRE_FIX_DATE1
			 , @FIX_TYPE AS PRE_FIX_TYPE1
			 , NULL AS PRE_FIX_DATE2
             , NULL AS PRE_FIX_TYPE2
			 , A.INTG_PLAN_ID
          FROM (
          	   SELECT A.INSTANCE_ID
			        , (A.INSTANCE_ID + '-' + A.PLAN_DATE + '-' + @v_PLAN_SEQ) AS PLAN_ID
				    , (A.TOTAL_INSTANCE_ID + '-' + A.PLAN_DATE + '-' + @v_PLAN_SEQ) AS INTG_PLAN_ID
				    , A.SITE_ID
				    , A.PLAN_DATE
				    , A.USER_ID
          	        , DATEDIFF(DAY, CONVERT(DATETIME, PLAN_DATE), CONVERT(DATETIME, FIX_DATE)) AS FIX_DAY
          	        , (CASE WHEN CHARINDEX('CELL',	A.INSTANCE_ID) > 0 THEN @DESC_CELL
		                    WHEN CHARINDEX('FORM',	A.INSTANCE_ID) > 0 THEN @DESC_FORM
				            WHEN CHARINDEX('E_PRE', A.INSTANCE_ID) > 0 THEN @DESC_ELEC
				            ELSE '' END) AS DESCRIPTION
				    , FIX_DATE
          	     FROM @vt_INSTANCE AS A
               ) AS A
			   LEFT OUTER JOIN TH_UIS_CAL AS B with(nolock)
			ON A.PLAN_DATE = B.YYYYMMDD
		;


 		INSERT INTO @vt_PLAN (INSTANCE_ID, PLAN_ID)
		SELECT A.INSTANCE_ID, MAX(A.PLAN_ID) AS PLAN_ID
		  FROM SCM_FP_PLAN_H A WITH(NOLOCK)
			   LEFT JOIN @vt_INSTANCE B 
			ON A.INSTANCE_ID = B.INSTANCE_ID
		 WHERE 1 = 1
		   AND CONVERT(VARCHAR(8), A.PLAN_START_TIME, 112) = B.PLAN_DATE
		   AND A.PLAN_TYPE <> 'RELEASE'
		 GROUP BY 
		       A.INSTANCE_ID
		;


		SELECT @INX			= 1
			 , @MAX_NUM		= COUNT(*)
		  FROM @vt_PLAN

		WHILE @INX <= @MAX_NUM
		BEGIN
			
			SELECT @INSTANCE_ID			= INSTANCE_ID	
				 , @PLAN_ID 			= PLAN_ID 	
			  FROM @vt_PLAN 
			 WHERE TID					= @INX


			DELETE FROM FP_PLAN_STATUS_H
			 WHERE INSTANCE_ID			= @INSTANCE_ID
			   AND PLAN_ID				= @PLAN_ID
				;
          
			INSERT INTO FP_PLAN_STATUS_H (
				   INSTANCE_ID
				 , PLAN_ID
				 , ACTIVE_FLAG
				 , INBOUND_FLAG
				 , INBOUND_START
				 , ENGINE_FLAG
				 , OUTBOUND_FLAG
				 , DB_TRANS_FLAG
				 , INSERT_ID
				 , INSERT_TIME
				 , UPDATE_ID
				 , UPDATE_TIME
			     )
			SELECT @INSTANCE_ID
			     , @PLAN_ID
				 , 1			AS ACTIVE_FLAG
				 , 'P'			AS inbound_flag
				 , GETDATE()	AS inbound_start
				 , 'R'			AS engine_flag
				 , 'R'			AS outbound_flag
				 , 'R'			AS db_trans_flag
				 , @USER_ID		AS insert_id
				 , GETDATE()	AS insert_date
				 , @USER_ID		AS update_id
				 , GETDATE()	AS update_date
			;
        
			INSERT INTO HIS_PLAN_STATUS_H (
			       INSTANCE_ID
				 , PLAN_ID
				 , ACTIVE_FLAG         
			     , INBOUND_FLAG
				 , INBOUND_STEP
				 , INBOUND_START       
			     , INBOUND_END
				 , ENGINE_FLAG
				 , ENGINE_STEP         
			     , ENGINE_START
				 , ENGINE_END
				 , OUTBOUND_FLAG       
			     , OUTBOUND_STEP
				 , OUTBOUND_START
				 , OUTBOUND_END        
			     , DB_TRANS_FLAG
				 , DB_TRANS_STEP
				 , DB_TRANS_START      
			     , DB_TRANS_END
				 , DESCRIPTION
				 , DB_CONNECTION_NAME  
			     , INSERT_ID
				 , INSERT_TIME
				 , UPDATE_ID           
			     , UPDATE_TIME
				 , JOB_USER_ID
				 , JOB_TIME            
			     , JOB_TYPE
			)   
			SELECT INSTANCE_ID
			     , PLAN_ID
				 , ACTIVE_FLAG         
			     , INBOUND_FLAG
				 , INBOUND_STEP
				 , INBOUND_START       
			     , INBOUND_END
				 , ENGINE_FLAG
				 , ENGINE_STEP         
			     , ENGINE_START
				 , ENGINE_END
				 , OUTBOUND_FLAG       
			     , OUTBOUND_STEP
				 , OUTBOUND_START
				 , OUTBOUND_END        
			     , DB_TRANS_FLAG
				 , DB_TRANS_STEP
				 , DB_TRANS_START      
			     , DB_TRANS_END
				 , DESCRIPTION
				 , DB_CONNECTION_NAME  
			     , INSERT_ID
				 , INSERT_TIME
				 , UPDATE_ID           
			     , UPDATE_TIME
				 , @USER_ID 
				 , dbo.SYSDATE1() AS JOB_TIME
			     , 'INSERT' AS JOB_TYPE
			  FROM FP_PLAN_STATUS_H WITH(NOLOCK)
			 WHERE INSTANCE_ID		= @INSTANCE_ID
			   AND PLAN_ID			= @PLAN_ID
			;


			UPDATE SCM_FP_PLAN_H 
			   SET AMEND_FIX_DATE	= NULL                          
			 WHERE INSTANCE_ID		= @INSTANCE_ID
			   AND PLAN_ID			= @PLAN_ID 
  
			-- Net Job Executing
			UPDATE JOB_SCHEDULE_DETAIL 
			   SET PARAMETER1		= @INSTANCE_ID   
				 , PARAMETER2		= @PLAN_ID 
			 WHERE GROUP_ID			= 'ENGINE_RUN_UI-' + @INSTANCE_ID
  
			UPDATE JOB_SCHEDULE_MASTER 
			   SET IMMEDIATE_FLAG	= 'Y'   
			 WHERE GROUP_ID			= 'ENGINE_RUN_UI-' + @INSTANCE_ID


--PRINT '-------------CELL Plan : 000 ' +  CONVERT(CHAR(23), getdate(), 21)


			SET @INX = @INX + 1
		END

		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, @v_table, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

	END TRY

	BEGIN CATCH

		ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate


	END CATCH


END


