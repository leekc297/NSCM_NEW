
/*
 * Program ID   : SCP0130_SVAE_VIRTUAL_BOM
 * Description  : VIRTUAL_BOM 등록,수정 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/24   kh   			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/11/24   mrchois    		PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - ITEM 유효성 체크 마스터 테이블 변경, SCP_MST_FINAL_ITEM -> SCM_MST_ITEM_SN
 *
 */
CREATE PROCEDURE [dbo].[SCP0130_SVAE_VIRTUAL_BOM]

	-- Add the parameters for the stored procedure here
  @p_active_flag         NVARCHAR(MAX),
  @p_division_id         NVARCHAR(MAX),
  @p_opmz_plan_gr_id     NVARCHAR(MAX),
  @p_plant_site_id        NVARCHAR(MAX),
  @p_item_id             NVARCHAR(MAX),
  @p_item_id_child       NVARCHAR(MAX),
  @p_to_yyyymmdd         NVARCHAR(MAX),
  @p_to_expc_qty         NVARCHAR(MAX),
  @p_value_description   NVARCHAR(MAX),
  @p_valid_yn            NVARCHAR(MAX),
  @p_user_id			 NVARCHAR(MAX),

  @p_pre_division_id	   NVARCHAR(MAX),
  @p_pre_opmz_plan_gr_id   NVARCHAR(MAX),
  @p_pre_plant_site_id	   NVARCHAR(MAX),
  @p_pre_item_id	       NVARCHAR(MAX),
  @p_pre_item_id_child     NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @v_working_time			DATETIME =sysdatetime();
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag		  NVARCHAR(MAX);
    DECLARE @v_division_id        NVARCHAR(MAX);
    DECLARE @v_opmz_plan_gr_id    NVARCHAR(MAX);
    DECLARE @v_plant_site_id       NVARCHAR(MAX);
    DECLARE @v_item_id            NVARCHAR(MAX);
	DECLARE @v_item_id_child      NVARCHAR(MAX);
    DECLARE @v_to_yyyymmdd        NVARCHAR(MAX);
	DECLARE @v_to_expc_qty        NVARCHAR(MAX);
    DECLARE @v_value_description  NVARCHAR(MAX);
    DECLARE @v_valid_yn           NVARCHAR(MAX);
	DECLARE @v_user_id		      NVARCHAR(MAX);
	DECLARE @v_last_updated_by	  NVARCHAR(MAX);
	
	DECLARE @v_pre_division_id	   NVARCHAR(MAX);
    DECLARE @V_pre_opmz_plan_gr_id NVARCHAR(MAX);
    DECLARE @v_pre_plant_site_id	   NVARCHAR(MAX);
    DECLARE @v_pre_item_id	       NVARCHAR(MAX);
    DECLARE @v_pre_item_id_child   NVARCHAR(MAX);





	SET @v_active_flag       = NULL;	
	SET @v_division_id       = NULL;	
	SET @v_opmz_plan_gr_id   = NULL;
	SET @v_plant_site_id      = NULL;
	SET @v_item_id           = NULL;
    SET @v_item_id_child     = NULL;
	SET @v_to_yyyymmdd       = NULL;
	SET @v_to_expc_qty       = NULL;
	SET @v_value_description = NULL;
	SET @v_valid_yn          = NULL;
	SET @v_user_id	         = NULL;
	SET @v_last_updated_by	 = NULL;

	SET @v_pre_division_id	   = NULL;
	SET @V_pre_opmz_plan_gr_id = NULL;
	SET @v_pre_plant_site_id	   = NULL;
	SET @v_pre_item_id	       = NULL;
	SET @v_pre_item_id_child   = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0130_SVAE_VIRTUAL_BOM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;


	-- 예외처리 변수 설정
	DECLARE @v_err_code     INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	SET @v_last_updated_by  = @p_user_id

	BEGIN TRY

		-- 트렌젝션 시작
		BEGIN TRAN;

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);   

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN

			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag		 = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag,       @v_delimiter , @mst_loop_cnt) ; 
				SET @v_division_id       = [dbo].[SCM_ARR_SPL_VAL](@p_division_id,       @v_delimiter , @mst_loop_cnt) ;	
				SET @v_opmz_plan_gr_id   = [dbo].[SCM_ARR_SPL_VAL](@p_opmz_plan_gr_id,   @v_delimiter , @mst_loop_cnt) ;
				SET @v_plant_site_id      = [dbo].[SCM_ARR_SPL_VAL](@p_plant_site_id,       @v_delimiter , @mst_loop_cnt) ; 
				SET @v_item_id           = [dbo].[SCM_ARR_SPL_VAL](@p_item_id,           @v_delimiter , @mst_loop_cnt) ;   
				SET @v_item_id_child     = [dbo].[SCM_ARR_SPL_VAL](@p_item_id_child,     @v_delimiter , @mst_loop_cnt) ; 
				SET @v_to_yyyymmdd       = [dbo].[SCM_ARR_SPL_VAL](@p_to_yyyymmdd	,    @v_delimiter , @mst_loop_cnt) ; 
			    SET @v_to_expc_qty       = [dbo].[SCM_ARR_SPL_VAL](@p_to_expc_qty	,    @v_delimiter , @mst_loop_cnt) ; 
				SET @v_value_description = [dbo].[SCM_ARR_SPL_VAL](@p_value_description, @v_delimiter , @mst_loop_cnt) ;	
				SET @v_valid_yn          = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn,          @v_delimiter , @mst_loop_cnt) ;

				SET @v_pre_division_id	   = [dbo].[SCM_ARR_SPL_VAL](@p_pre_division_id,     @v_delimiter , @mst_loop_cnt) ;
				SET @V_pre_opmz_plan_gr_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_opmz_plan_gr_id, @v_delimiter , @mst_loop_cnt) ;
				SET @v_pre_plant_site_id	   = [dbo].[SCM_ARR_SPL_VAL](@p_pre_plant_site_id,     @v_delimiter , @mst_loop_cnt) ;
				SET @v_pre_item_id	       = [dbo].[SCM_ARR_SPL_VAL](@p_pre_item_id,         @v_delimiter , @mst_loop_cnt) ;
				SET @v_pre_item_id_child   = [dbo].[SCM_ARR_SPL_VAL](@p_pre_item_id_child,   @v_delimiter , @mst_loop_cnt) ;

			END

			--삭제가 아닌 경우, 중복체크
			IF (@v_active_flag <> 'D')
			BEGIN 
				/***** 중복체크 *****/
				DECLARE @cnt INTEGER;
				/*** Material 유효한 확인  START*****/
				SET @cnt = 0;

				;WITH C1 AS (
					SELECT 1  AS ORD, '81'    AS ORG_DIVISION,  '81' AS DIVISION_ID UNION ALL
					SELECT 2  AS ORD, '40'    AS ORG_DIVISION,  '40' AS DIVISION_ID UNION ALL
					SELECT 3  AS ORD, '82'    AS ORG_DIVISION,  '82' AS DIVISION_ID UNION ALL
					SELECT 4  AS ORD, 'EE'    AS ORG_DIVISION,  '81' AS DIVISION_ID UNION ALL
					SELECT 4  AS ORD, 'EE'    AS ORG_DIVISION,  '40' AS DIVISION_ID UNION ALL
					SELECT 4  AS ORD, 'EE'    AS ORG_DIVISION,  '82' AS DIVISION_ID UNION ALL
					SELECT 5  AS ORD, '81_UC' AS ORG_DIVISION,  '81_UC' AS DIVISION_ID UNION ALL
					SELECT 6  AS ORD, 'EE_UC' AS ORG_DIVISION,  '81_UC' AS DIVISION_ID UNION ALL
					SELECT 7  AS ORD, '81_HM' AS ORG_DIVISION,  '81_HM' AS DIVISION_ID UNION ALL
					SELECT 8  AS ORD, 'EE_HM' AS ORG_DIVISION,  '81_HM' AS DIVISION_ID UNION ALL
					SELECT 9  AS ORD, '81_ST' AS ORG_DIVISION,  '81_ST' AS DIVISION_ID UNION ALL
					SELECT 10 AS ORD, 'EE_ST' AS ORG_DIVISION,  '81_ST' AS DIVISION_ID UNION ALL
					SELECT 11 AS ORD, '81_HD' AS ORG_DIVISION,  '81_HD' AS DIVISION_ID UNION ALL
					SELECT 12 AS ORD, 'EE_HD' AS ORG_DIVISION,  '81_HD' AS DIVISION_ID UNION ALL
					SELECT 13 AS ORD, '81_HG' AS ORG_DIVISION,  '81_HG' AS DIVISION_ID UNION ALL
					SELECT 14 AS ORD, 'EE_HG' AS ORG_DIVISION,  '81_HG'  
				)
				SELECT @cnt = COUNT(*)
				  FROM	[dbo].[SCM_MST_ITEM_SN] I WITH(NOLOCK)		--[PJ20257329]ITEM 유효성 체크 마스터 테이블 변경, SCP_MST_FINAL_ITEM -> SCM_MST_ITEM_SN (2025-11-24)
	 			 WHERE I.DIVISION_ID IN (SELECT C1.DIVISION_ID FROM C1 C1 WHERE C1.ORG_DIVISION = @v_division_id)
				   AND ITEM_ID = @v_item_id

				IF(@cnt = 0)
				BEGIN
					SET @v_err_code    = 99020 ; 
					SET @v_err_message = N' Material 를 확인할 수 없습니다. ('+ @v_item_id+')';
					THROW  @v_err_code, @v_err_message , 1; --예외발생
				END
				/*** Material 유효한 확인  END *****/

			END

			IF(@v_active_flag = 'I')
			BEGIN

				MERGE INTO dbo.SCP_OPMZ_VIRTUAL_BOM AS a
				USING (SELECT @v_division_id     AS DIVISION_ID
                             ,@v_opmz_plan_gr_id AS  OPMZ_PLAN_GR_ID
                             ,@v_plant_site_id    AS  PLANT_SITE_ID
                             ,@v_item_id         AS  ITEM_ID
                             ,@v_item_id_child   AS  ITEM_ID_CHILD) AS b
				   ON (  a.DIVISION_ID     = B.DIVISION_ID
				     AND A.OPMZ_PLAN_GR_ID = B.OPMZ_PLAN_GR_ID
					 AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
					 AND A.ITEM_ID         = B.ITEM_ID
					 AND A.ITEM_ID_CHILD   = B.ITEM_ID_CHILD )
				 WHEN MATCHED THEN
				   UPDATE SET A.TO_YYYYMMDD       = @v_to_yyyymmdd
					         ,A.TO_EXPC_QTY       =@v_to_expc_qty
					         ,A.VALUE_DESCRIPTION =@v_value_description
					         ,A.VALID_YN          =@v_valid_yn
					         ,A.LAST_UPDATED_BY   =@v_last_updated_by
					         ,A.LAST_UPDATE_DATE  = GETDATE()
				 WHEN NOT MATCHED THEN
				   INSERT(DIVISION_ID
                         ,OPMZ_PLAN_GR_ID
                         ,PLANT_SITE_ID
                         ,ITEM_ID
                         ,ITEM_ID_CHILD
                         ,TO_YYYYMMDD
                         ,TO_EXPC_QTY
                         ,VALUE_DESCRIPTION
                         ,VALID_YN
                         ,CREATED_BY
                         ,CREATION_DATE
                         ,LAST_UPDATED_BY
                         ,LAST_UPDATE_DATE
                       ) 
					VALUES
					(
                       @v_division_id
                      ,@v_opmz_plan_gr_id
                      ,@v_plant_site_id
                      ,@v_item_id
                      ,@v_item_id_child
                      ,@v_to_yyyymmdd
					  ,@v_to_expc_qty
                      ,@v_value_description
                      ,@v_valid_yn
                      ,@v_last_updated_by
                      ,GETDATE()
                      ,@v_last_updated_by
                      ,GETDATE()
                   );
			END
			ELSE IF( @v_active_flag ='M' )
			BEGIN
			    -- 변경하려는 데이타가 key 중복일 경우 체크
				SET @cnt = 0;

				SELECT @cnt = COUNT(*)
				FROM SCP_OPMZ_VIRTUAL_BOM  WITH(NOLOCK)
				WHERE DIVISION_ID	= @v_division_id
				AND OPMZ_PLAN_GR_ID = @v_opmz_plan_gr_id
				AND PLANT_SITE_ID	    = @v_plant_site_id
				AND ITEM_ID         = @v_item_id
				AND ITEM_ID_CHILD   = @v_item_id_child
				AND NOT (
						    DIVISION_ID     = @v_pre_division_id
						AND OPMZ_PLAN_GR_ID = @v_pre_opmz_plan_gr_id
						AND PLANT_SITE_ID	    = @v_pre_plant_site_id
						AND ITEM_ID         = @v_pre_item_id
						AND ITEM_ID_CHILD   = @v_pre_item_id_child
						)

				IF(@cnt > 0)
				BEGIN
					SET @v_err_code    = 99010 ; 
					SET @v_err_message = N' 입력 데이터 중 중복된 데이터가 있습니다.';
					THROW  @v_err_code, @v_err_message , 1; --예외발생
				END


                UPDATE SCP_OPMZ_VIRTUAL_BOM
                SET DIVISION_ID           = @v_division_id
                   ,OPMZ_PLAN_GR_ID       = @v_opmz_plan_gr_id
                   ,PLANT_SITE_ID           = @v_plant_site_id
                   ,ITEM_ID               = @v_item_id
                   ,ITEM_ID_CHILD         = @v_item_id_child
                   ,TO_YYYYMMDD           = @v_to_yyyymmdd
				   ,TO_EXPC_QTY           = @v_to_expc_qty
                   ,VALUE_DESCRIPTION     = @v_value_description
                   ,VALID_YN              = @v_valid_yn
                   ,LAST_UPDATED_BY	      = @v_last_updated_by
                   ,LAST_UPDATE_DATE      = SYSDATETIME()
                WHERE DIVISION_ID           = @v_pre_division_id
                AND   OPMZ_PLAN_GR_ID       = @v_pre_opmz_plan_gr_id
                AND   PLANT_SITE_ID           = @v_pre_plant_site_id
                AND   ITEM_ID               = @v_pre_item_id
		        AND   ITEM_ID_CHILD         = @v_pre_item_id_child
				;
 			END
			--삭제기능 추가 (2025-07-16)
			ELSE IF(@v_active_flag ='D')
			BEGIN
				
				DELETE SCP_OPMZ_VIRTUAL_BOM
                WHERE DIVISION_ID           = @v_pre_division_id
                AND   OPMZ_PLAN_GR_ID       = @v_pre_opmz_plan_gr_id
                AND   PLANT_SITE_ID           = @v_pre_plant_site_id
                AND   ITEM_ID               = @v_pre_item_id
                AND   ITEM_ID_CHILD         = @v_pre_item_id_child
 
			END

		END

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		COMMIT TRAN;
			
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;

	END TRY
	BEGIN CATCH
		IF (XACT_STATE() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
		BEGIN
			INSERT INTO scm_sys_log_batch (program_name
											,log_type
											,log_count
											,log_message
											,description
											,event_date
											,creation_date
											,created_by
											,last_update_date
											,last_updated_by)
			VALUES (ERROR_PROCEDURE()
					,'ERROR'
					,NULL
					,ERROR_MESSAGE()
					,NULL
					,SYSDATETIME()
					,SYSDATETIME()
					,ERROR_PROCEDURE()
					,SYSDATETIME()
					,ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--	COMMIT WORK;

		END;

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
END






