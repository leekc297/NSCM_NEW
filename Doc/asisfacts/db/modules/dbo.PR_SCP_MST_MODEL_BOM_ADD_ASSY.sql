

/*      
 * Program ID  : [PR_SCP_MST_MODEL_BOM_ADD_ASSY]      
 * Description : Cell Product Model 기준으로 Cell Assy Model정보를 생성한다.

	* source table : SCM_MST_MODEL_BOM, SCP_MST_CELL_PROD_ASSY_MAP
	* target table : SCM_MST_MODEL_BOM
 *
 * Program History      
 *============================================================================================================================      
 *   Date		In Charge	Description      
 *============================================================================================================================      
 * 2023/06/22	hrkim		Initial Release  [PJ20230691] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 * 2023/07/17	hrkim		PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응 (8월 해외 오픈 대응) 
 * 2023/07/26	hrkim		PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : SCP_MST_CELL_PROD_ASSY_MAP 참조시 Valid_yn = 'Y' 조건 추가
 * 2025.09.08   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *                          제품 기준 NLevel 선정 로직 현실화
 * 
 */

CREATE PROCEDURE [dbo].[PR_SCP_MST_MODEL_BOM_ADD_ASSY]
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_MODEL_BOM_ADD_ASSY'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch'; 

	-- 임시 실행시간 확인용              
    DECLARE @v_start_time   DATETIME   = SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';    

	BEGIN TRY
		BEGIN

			-- 시작 LOG  (START)
			SET @v_log_type = 'START';
			SET @v_log_message = '##### Start of procedure #####';  
			SET @v_description = CONVERT(NVARCHAR(8),'',112) ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- < - 변수 재사용을 위하여 초기화해야함 --*/
			-- 시작 LOG  (END)

			---------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 1 #tgt_SCM_MST_MODEL_BOM 대상 추출'
			---------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#tgt_SCM_MST_MODEL_BOM') IS NOT NULL
				DROP TABLE #tgt_SCM_MST_MODEL_BOM;

			SELECT 
					 ROW_NUMBER() OVER (PARTITION BY B.COMPANY_ID
													,B.DIVISION_ID
													,B.SITE_ID
													,B.PLANT_ID
													,M.ITEM_ID_ASSY
													,SUBSTRING(B.CONCATENATE_ITEM
																, CHARINDEX(M.ITEM_ID_ASSY, B.CONCATENATE_ITEM)
																, LEN(B.CONCATENATE_ITEM) )
											ORDER BY F.TCO_CELL_YN
													,M.ITEM_ID_PROD ) AS BOM_PRIORITY
					,F.TCO_CELL_YN			AS CELL_PROD_TCO_CELL_YN
					,B.COMPANY_ID
					,B.DIVISION_ID
					,B.SITE_ID
					,B.PLANT_ID
					,B.MODEL_ID				AS MODEL_ID_OLD
					,B.PARENT_ITEM_ID		AS PARENT_ITEM_ID_OLD 
					,M.ITEM_ID_ASSY			AS MODEL_ID
					,CASE WHEN M.ITEM_ID_ASSY = B.CHILD_ITEM_ID
						  THEN '*'
						  ELSE B.PARENT_ITEM_ID
					 END					AS PARENT_ITEM_ID
					,B.CHILD_ITEM_ID
					,B.CHILD_QTY
					,B.CHILD_UOM
					,B.ACCUMULATED_CHILD_QTY
					,SUBSTRING(B.CONCATENATE_ITEM
								, CHARINDEX(M.ITEM_ID_ASSY, B.CONCATENATE_ITEM)
								, LEN(B.CONCATENATE_ITEM)
							  )				AS CONCATENATE_ITEM 
					,B.CONCATENATE_ITEM		AS CONCATENATE_ITEM_OLD 
					,B.SORT_ORDER
					,B.LEAF_LEVEL
					,B.NLEVEL				AS NLEVEL_OLD
					,CASE WHEN CHARINDEX(M.ITEM_ID_ASSY, B.CONCATENATE_ITEM) > 1 
						  -- THEN B.NLEVEL - 1
						  -- 2025.09.08   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
                          --                          제품 기준 NLevel 선정 로직 현실화
						  THEN B.NLEVEL - LEN(SUBSTRING(B.CONCATENATE_ITEM,1, CHARINDEX(M.ITEM_ID_ASSY, B.CONCATENATE_ITEM))) + LEN(REPLACE(SUBSTRING(B.CONCATENATE_ITEM,1, CHARINDEX(M.ITEM_ID_ASSY, B.CONCATENATE_ITEM)),'^','')) 
						  ELSE B.NLEVEL
					 END					AS NLEVEL
					,B.CHILD_COMPANY_ID
					,B.CHILD_DIVISION_ID
					,B.CHILD_SITE_ID
					,B.CHILD_PLANT_ID
					,B.ALT_ID
					,B.ALT_PRIORITY
					,B.ALT_RATE
					,B.INSERT_ID
					,B.INSERT_TIME
					,B.UPDATE_ID
					,B.UPDATE_TIME
					,B.ATTRIBUTE1
					,B.ATTRIBUTE2
					,B.ATTRIBUTE3
					,B.ATTRIBUTE4
					,B.ATTRIBUTE5
					,B.ATTRIBUTE6
					,B.ATTRIBUTE7
					,B.ATTRIBUTE8
					,B.ATTRIBUTE9
					,B.ATTRIBUTE10
					,B.ATTRIBUTE11
					,B.ATTRIBUTE12
					,B.ATTRIBUTE13
					,B.ATTRIBUTE14
					,B.ATTRIBUTE15
					,B.CONCAT_ALT_PRIORITY
					,B.COPY_ALT_PRIORITY
					,B.SCP_PLAN_YN
					,B.ENG_ALT_ID
					,B.ENG_ALT_PRIORITY
					,B.ORG_ALT_ID
					,B.ORG_ALT_PRIORITY
					,B.CHILD_SEQ
			 INTO #tgt_SCM_MST_MODEL_BOM
			 FROM SCM_MST_MODEL_BOM B WITH(NOLOCK)
				  INNER JOIN SCP_MST_CELL_PROD_ASSY_MAP M WITH(NOLOCK)
						  ON M.DIVISION_ID	= B.DIVISION_ID
						 AND M.PLANT_ID		= B.PLANT_ID
						 AND M.ITEM_ID_PROD	= B.MODEL_ID
						 AND M.VALID_YN		= 'Y'
				  LEFT JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)
						  ON F.DIVISION_ID  = M.DIVISION_ID
						 AND F.ITEM_ID		= M.ITEM_ID_PROD
			WHERE 1=1
			  AND B.CONCATENATE_ITEM LIKE '%'+M.ITEM_ID_ASSY+'%'  -- 8/1 

		--------------------------------------------------------------- 최종 테이블에 반영 --------------------------------------------------------------

		BEGIN TRAN

			---------------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 2.2 Delete : 기 생성된 Assy Model 삭제 '
			---------------------------------------------------------------------------------------------------------------------------------------------
			DELETE B 
			FROM SCM_MST_MODEL_BOM B WITH(NOLOCK)
			WHERE 1=1
			  AND EXISTS (SELECT TOP 1 1
						   FROM SCP_MST_CELL_PROD_ASSY_MAP M WITH(NOLOCK)
						  WHERE M.DIVISION_ID	= B.DIVISION_ID
							AND M.PLANT_ID		= B.PLANT_ID
							AND M.ITEM_ID_ASSY	= B.MODEL_ID)

			-----------------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 2.2  Insert : Assy Model 정보 등록 '
			-----------------------------------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCM_MST_MODEL_BOM (
					 COMPANY_ID
					,DIVISION_ID
					,SITE_ID
					,PLANT_ID
					,MODEL_ID
					,PARENT_ITEM_ID
					,CHILD_ITEM_ID
					,CHILD_QTY
					,CHILD_UOM
					,ACCUMULATED_CHILD_QTY
					,CONCATENATE_ITEM
					,SORT_ORDER
					,LEAF_LEVEL
					,NLEVEL
					,CHILD_COMPANY_ID
					,CHILD_DIVISION_ID
					,CHILD_SITE_ID
					,CHILD_PLANT_ID
					,ALT_ID
					,ALT_PRIORITY
					,ALT_RATE
					,INSERT_ID
					,INSERT_TIME
					,UPDATE_ID
					,UPDATE_TIME
					,ATTRIBUTE1
					,ATTRIBUTE2
					,ATTRIBUTE3
					,ATTRIBUTE4
					,ATTRIBUTE5
					,ATTRIBUTE6
					,ATTRIBUTE7
					,ATTRIBUTE8
					,ATTRIBUTE9
					,ATTRIBUTE10
					,ATTRIBUTE11
					,ATTRIBUTE12
					,ATTRIBUTE13
					,ATTRIBUTE14
					,ATTRIBUTE15
					,CONCAT_ALT_PRIORITY
					,COPY_ALT_PRIORITY
					,SCP_PLAN_YN
					,ENG_ALT_ID
					,ENG_ALT_PRIORITY
					,ORG_ALT_ID
					,ORG_ALT_PRIORITY
					,CHILD_SEQ
					)
			SELECT   B.COMPANY_ID
					,B.DIVISION_ID
					,B.SITE_ID
					,B.PLANT_ID
					,B.MODEL_ID
					,B.PARENT_ITEM_ID
					,B.CHILD_ITEM_ID
					,B.CHILD_QTY
					,B.CHILD_UOM
					,B.ACCUMULATED_CHILD_QTY
					,B.CONCATENATE_ITEM
					,B.SORT_ORDER
					,B.LEAF_LEVEL
					,B.NLEVEL
					,B.CHILD_COMPANY_ID
					,B.CHILD_DIVISION_ID
					,B.CHILD_SITE_ID
					,B.CHILD_PLANT_ID
					,B.ALT_ID
					,B.ALT_PRIORITY
					,B.ALT_RATE
					,@v_program_name	AS INSERT_ID
					,GETDATE()			AS INSERT_TIME
					,@v_program_name	AS UPDATE_ID
					,GETDATE()			AS UPDATE_TIME
					,B.ATTRIBUTE1
					,B.ATTRIBUTE2
					,B.ATTRIBUTE3
					,B.ATTRIBUTE4
					,B.ATTRIBUTE5
					,B.ATTRIBUTE6
					,B.ATTRIBUTE7
					,B.ATTRIBUTE8
					,B.ATTRIBUTE9
					,B.ATTRIBUTE10
					,B.ATTRIBUTE11
					,B.ATTRIBUTE12
					,B.ATTRIBUTE13
					,B.ATTRIBUTE14
					,'CELL_ASSY'		AS ATTRIBUTE15
					,B.CONCAT_ALT_PRIORITY
					,B.COPY_ALT_PRIORITY
					,B.SCP_PLAN_YN
					,B.ENG_ALT_ID
					,B.ENG_ALT_PRIORITY
					,B.ORG_ALT_ID
					,B.ORG_ALT_PRIORITY
					,B.CHILD_SEQ
			 FROM #tgt_SCM_MST_MODEL_BOM B 
			WHERE 1=1
			  AND BOM_PRIORITY = 1
			  ;

			COMMIT TRAN
				  
		END			    
    END TRY

    BEGIN CATCH                  

		if (xact_state() <> 0) ROLLBACK TRAN; 

		-- ERROR LOG                  
		SET @v_log_type = N'ERROR';                  
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                  
		SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());                  
		SET @d_event_date = SYSDATETIME();                  
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name                  
		                          ,@p_log_type      = @v_log_type                  
		                          ,@p_log_count     = @n_log_count                   
		                          ,@p_log_message   = @v_log_message                   
		                          ,@p_description   = @v_description                   
		                          ,@p_event_date    = @d_event_date                   
		                          ,@p_user_id       = @v_batch_user                  
		                          ;                  
		PRINT @v_log_message      + ' : ' + @v_description ;          
		RETURN -1;                
    END CATCH;   

    SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                         REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 
    -- 종료 LOG                  
    SET @v_log_type = N'END';                  
    SET @v_log_message = N'##### END of procedure #####';                  
    SET @v_description = N'['  + @v_exec_time + ']';             
    SET @d_event_date = SYSDATETIME()  ;                 
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                              ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
                              ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
    RETURN 1;                
                  
END

