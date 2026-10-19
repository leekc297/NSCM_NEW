
/*
 * Program ID   : SCP0097_SAVE_SCP_BOM_ELEC
 * Description  : SCP BOM ELEC 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/02/16   jahn1501       PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제  Initial Release
 * 2023/03/06   vadabi3        PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제  [컬럼제거 : PLANT_ID, 컬럼추가 : ELECTRODE_TYPE]
 * 
 */
CREATE PROCEDURE [dbo].[SCP0097_SAVE_SCP_BOM_ELEC]
	 @p_active_flag        NVARCHAR(MAX)
	,@p_division_id        NVARCHAR(MAX)
	,@p_parent_item_id     NVARCHAR(MAX)
	,@p_child_item_id      NVARCHAR(MAX)
	,@p_scp_yn             NVARCHAR(MAX)
	,@p_stock_yn    	   NVARCHAR(MAX)
	,@p_user_id            NVARCHAR(MAX)
	,@debug_mode           NVARCHAR(1) ='F'
AS

BEGIN 

	DECLARE @v_delimiter NVARCHAR(1)

	SET @v_delimiter = '^'

	-- LOG 용 변수 설정
    DECLARE @v_program_name     NVARCHAR(150)   = 'SCP0097_SAVE_SCP_BOM_ELEC'
    DECLARE @v_log_type         NVARCHAR(30)     -- START/END/ERROR/...
    DECLARE @n_log_count        INTEGER         = 0
    DECLARE @v_log_message      NVARCHAR(1000)
    DECLARE @v_description      NVARCHAR(500)
    DECLARE @d_event_date       DATETIME

	-- 결과 반환 변수 설정
	DECLARE @v_mod_cnt		    INTEGER         = 0;
    
	-- 트렌젝션 시작
	BEGIN TRAN

	BEGIN TRY
		-- LOG start
		SET @v_log_type         = 'START'
		SET @v_log_message      = '########## Start of procedure ##########'
		SET @v_description      = ''
		SET @d_event_date       = SYSDATETIME()

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date

		IF OBJECT_ID('TEMPDB..#SCP0097_SAVE_SCP_BOM_ELEC') IS NOT NULL
			DROP TABLE #SCP0097_SAVE_SCP_BOM_ELEC
		IF OBJECT_ID('TEMPDB..#SPLIT_DATA') IS NOT NULL
			DROP TABLE #SPLIT_DATA			

		CREATE TABLE #SCP0097_SAVE_SCP_BOM_ELEC
		(
			DIVISION_ID			NVARCHAR(30)
		  , PARENT_ITEM_ID		NVARCHAR(200)
		  , CHILD_ITEM_ID		NVARCHAR(200)
		  , SCP_YN				NVARCHAR(200)
		  , STOCK_YN			NVARCHAR(200)
		  , USER_ID				NVARCHAR(200) 
		)
		
		SELECT A1.NR 
			 , A1.TOKEN  AS DIVISION_ID
             , A2.TOKEN  AS PARENT_ITEM_ID
             , A3.TOKEN  AS CHILD_ITEM_ID
     		 , A4.TOKEN  AS SCP_YN
             , A5.TOKEN  AS STOCK_YN
          INTO #SPLIT_DATA
		  FROM DBO.UF_FX_String_Split(@p_division_id,         @v_delimiter) A1
		  JOIN DBO.UF_FX_String_Split(@p_parent_item_id,      @v_delimiter) A2  ON A1.NR = A2.NR
		  JOIN DBO.UF_FX_String_Split(@p_child_item_id,       @v_delimiter) A3  ON A1.NR = A3.NR
		  JOIN DBO.UF_FX_String_Split(@p_scp_yn,         	  @v_delimiter) A4  ON A1.NR = A4.NR
		  JOIN DBO.UF_FX_String_Split(@p_stock_yn,         	  @v_delimiter) A5  ON A1.NR = A5.NR  		
	            
		INSERT INTO #SCP0097_SAVE_SCP_BOM_ELEC
		(
			   DIVISION_ID
			 , PARENT_ITEM_ID
			 , CHILD_ITEM_ID
			 , SCP_YN
			 , STOCK_YN
			 , USER_ID
		)		            
		SELECT 
		       DIVISION_ID
			 , PARENT_ITEM_ID
			 , CHILD_ITEM_ID
			 , SCP_YN
			 , STOCK_YN
			 , @p_user_id AS USER_ID
	      FROM #SPLIT_DATA
	     WHERE 1=1  
		            
		MERGE INTO SCP_MST_BOM_ELEC B
		    USING   (
                        SELECT DIVISION_ID
							 , PARENT_ITEM_ID
							 , CHILD_ITEM_ID
							 , SCP_YN
							 , STOCK_YN
							 , USER_ID
                        FROM #SCP0097_SAVE_SCP_BOM_ELEC
                    ) A ON 
                    B.DIVISION_ID    = A.DIVISION_ID
		        AND B.PARENT_ITEM_ID = A.PARENT_ITEM_ID
		        AND B.CHILD_ITEM_ID  = A.CHILD_ITEM_ID

		WHEN MATCHED THEN
			UPDATE 
			   SET SCP_YN		     = A.SCP_YN
				 , STOCK_SUM		     = A.STOCK_YN
				 , ATTRIBUTE5		 = (CASE WHEN B.SCP_YN <> @p_scp_yn THEN 'Y' ELSE '' END)
				 , LAST_UPDATED_BY   = A.USER_ID
				 , LAST_UPDATE_DATE	 = SYSDATETIME();

		SELECT @v_mod_cnt = COUNT(1)
		  FROM #SCP0097_SAVE_SCP_BOM_ELEC

		-- LOG end
		SET @v_log_type     = 'END'
		SET @v_log_message  = '########## END of procedure ##########'
		SET @v_description  = ''
		SET @d_event_date   = SYSDATETIME()

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date

		COMMIT TRAN

		-- 결과코드, 결과 카운트 반환
		SELECT 'S' AS result_code
             , @v_mod_cnt AS result_cnt
	END TRY
	
	BEGIN CATCH
		BEGIN
			IF (XACT_STATE() <> 0) ROLLBACK TRAN;

			INSERT INTO scm_sys_log_batch
            (
                  program_name
                , log_type
                , log_count
                , log_message
                , description
                , event_date
                , creation_date
                , created_by
                , last_update_date
                , last_updated_by
            )
			VALUES 
            (
                  ISNULL(ERROR_PROCEDURE(), @v_program_name)
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

			-- error코드, errror 메시지 반환
			SELECT  'F' AS result_code
			SELECT  '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE()
		END
	END CATCH
END
