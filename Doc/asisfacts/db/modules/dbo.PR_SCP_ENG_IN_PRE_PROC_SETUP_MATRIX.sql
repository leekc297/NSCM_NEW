/*
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_SETUP_MATRIX
 * Description  : 엔진 SETUP MATRIX 데이터 생성 (관련 FP 기준정보) 
                            
 * OutTable     :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.03.17   KKC         Initial Release
 */
CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_SETUP_MATRIX]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)   
    
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

     --20180228 프로시저 속도 개선을 위해서 입력변수를 일반변수로 변경함
    DECLARE @p_plan_cycle  NVARCHAR(150)    = @p_plan_cycle1;
    DECLARE @p_plan_name   NVARCHAR(4000)   = @p_plan_name1;
    DECLARE @p_plan_id     NVARCHAR(4000)   = @p_plan_id1;
    DECLARE @p_modeling_id NVARCHAR(4000)   = @p_modeling_id1 ;
    DECLARE @p_seq         NVARCHAR(4000)   = @p_seq1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)   = @p_plan_type1 ;
    DECLARE @p_master_id   NVARCHAR(4000)   = @p_master_id1 ;
    DECLARE @p_division_id NVARCHAR(30)     = @p_division_id1 ; 
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ;
    
    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_SETUP_MATRIX';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = '';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;

    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @v_cur_wednesday     NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'WED')), 112); -- 당주 수요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME = CONVERT(DATETIME,@p_plan_name);
    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date
	DECLARE @v_add_pet_date      NVARCHAR(8) ; -- Add Plan End Date (2022.01.17 추가) 

    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

        ------------------------------------------------------------
        --1. TH_ENG_SETUP_MATRIX_SN 데이터 초기화
		------------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1 START';
        SET @v_description = N'1. TH_ENG_SETUP_MATRIX_SN Delete' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		DELETE RM
		FROM  TH_ENG_SETUP_MATRIX_SN RM 
		WHERE master_id = @p_master_id 
        AND   plan_id   = @p_engine_plan_id 
		;		
				
        /*************************************************************************
        LINE_MASTER의 LINE_SETUP_GROUP 존재하는 기준으로 SETUP MATRIX 설정
		--> LINE SETUP GROUP이 없는 것은 반영하지 않음(정의되고 매핑되는 SETUP만 반영 - FP엔진과 동일)
		**************************************************************************/
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2 START';
        SET @v_description = N'TH_ENG_RESOURCE_SN.LINE_SETUP_GROUP_ID [UPDATE]' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		WITH VW_TARGET_LINE_MASTER AS (
									   SELECT LM.DIVISION_ID
											, LM.SITE_ID
											, LM.PLANT_ID
											, LM.OPERATION_ID
											, LM.LINE_ID
											, LM.LINE_NAME
											, LM.LINE_SETUP_GROUP_ID                                          
											, CASE WHEN LM.OPERATION_ID LIKE 'P%' THEN LM.OPERATION_ID + '::' + LM.PLANT_ID + '-P~***' + '::' + LM.LINE_ID
												   ELSE LM.OPERATION_ID + '::' + LM.PLANT_ID + '-A~***' + '::' + LM.LINE_ID
											   END      AS ENG_RESOURCE_ID								
											, LM.SCP_LINE_ID
											, LM.MODEL_TYPE
											, SM.SETUP_CATEGORY_ID
											, SM.FROM_ITEM_SETUP_GROUP_ID
											, SM.TO_ITEM_SETUP_GROUP_ID
											, SM.SETUP_CONDITION_ID
											, SM.SETUP_TIME
											, SM.SETUP_TIME_UOM
										FROM SCM_LINE_M_SN         LM WITH(NOLOCK) 
										JOIN SCM_MST_SETUP_MATRIX_SN SM WITH(NOLOCK) --시노님명 변경
										ON LM.DIVISION_ID  = SM.DIVISION_ID
										AND LM.PLANT_ID     = SM.PLANT_ID
										AND LM.OPERATION_ID = SM.OPERATION_ID
										AND LM.LINE_SETUP_GROUP_ID = SM.LINE_SETUP_GROUP_ID
									  WHERE LM.DIVISION_ID = @p_division_id
									    AND SM.SETUP_TIME > 0 
									  )
		UPDATE ER
		   SET ER.RESOURCE_SETUP_GROUP_ID = LM.LINE_SETUP_GROUP_ID
		  FROM TH_ENG_RESOURCE_SN ER WITH(NOLOCK)
		  JOIN (			
				SELECT ER.RESOURCE_ID
					 , ER.SITE_ID
					 , ER.ROUTE_ID
					 , ER.RESOURCE_GROUP_ID
					 , ER.RESOURCE_SETUP_GROUP_ID
					 , LM.ENG_RESOURCE_ID
					 , LM.LINE_SETUP_GROUP_ID   --//SETUP GROUP을 PLANT별/OPERATION별/ 구분해야 할지는 나중에 한번 보자
				  FROM TH_ENG_RESOURCE_SN ER WITH(NOLOCK)
				  LEFT OUTER JOIN
					   ( SELECT LM.ENG_RESOURCE_ID
							  , MAX(LM.LINE_SETUP_GROUP_ID)   AS LINE_SETUP_GROUP_ID
							  , COUNT(LM.LINE_SETUP_GROUP_ID) AS LINE_SETUP_GROUP_CNT
						   FROM VW_TARGET_LINE_MASTER LM
						  GROUP 
							 BY LM.ENG_RESOURCE_ID	
					   ) LM
					ON ER.RESOURCE_ID = LM.ENG_RESOURCE_ID 
				 WHERE ER.MASTER_ID = @p_master_id
				   AND ER.PLAN_ID   = @p_engine_plan_id
				   --AND ER.RESOURCE_TYPE = 'CAPA'
				   AND ER.SITE_ID LIKE '%~***' --(CELL/PACK 생산 공정)
				   AND LM.ENG_RESOURCE_ID IS NOT NULL    
			   )  LM
			ON ER.RESOURCE_ID   = LM.RESOURCE_ID
		 WHERE ER.MASTER_ID     = @p_master_id
		   AND ER.PLAN_ID       = @p_engine_plan_id
		   AND ER.SITE_ID LIKE '%~***'
		   --AND ER.RESOURCE_TYPE = 'CAPA'
		;

        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3 START';
        SET @v_description = N'TH_ENG_SETUP_MATRIX_SN [INSERT]' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		WITH VW_LINE_SETUP_MATRIX AS (
									   SELECT LM.DIVISION_ID
											, LM.SITE_ID
											, LM.PLANT_ID
											, LM.OPERATION_ID
											, LM.LINE_ID
											, LM.LINE_NAME
											, LM.LINE_SETUP_GROUP_ID                                          
											, CASE WHEN LM.OPERATION_ID LIKE 'P%' THEN LM.OPERATION_ID + '::' + LM.PLANT_ID + '-P~***' + '::' + LM.LINE_ID
												   ELSE LM.OPERATION_ID + '::' + LM.PLANT_ID + '-A~***' + '::' + LM.LINE_ID
											   END      AS ENG_RESOURCE_ID								
											, LM.SCP_LINE_ID
											, LM.MODEL_TYPE
											, SM.SETUP_CATEGORY_ID
											, SM.FROM_ITEM_SETUP_GROUP_ID
											, SM.TO_ITEM_SETUP_GROUP_ID
											, SM.SETUP_CONDITION_ID
											, SM.SETUP_TIME
											, SM.SETUP_TIME_UOM
										FROM SCM_LINE_M_SN                        LM WITH(NOLOCK) 
										JOIN SCM_MST_SETUP_MATRIX_SN              SM WITH(NOLOCK)  --시노님명 변경
										ON LM.DIVISION_ID  = SM.DIVISION_ID
										AND LM.PLANT_ID     = SM.PLANT_ID
										AND LM.OPERATION_ID = SM.OPERATION_ID
										AND LM.LINE_SETUP_GROUP_ID = SM.LINE_SETUP_GROUP_ID
									  WHERE LM.DIVISION_ID = @p_division_id
									    AND SM.SETUP_TIME > 0 
								)
		INSERT INTO TH_ENG_SETUP_MATRIX_SN
		     (
			   MASTER_ID
			 , PLAN_ID
			 , RESOURCE_SETUP_GROUP_ID
			 , FROM_SETUP_GROUP_ID
			 , TO_SETUP_GROUP_ID
			 , SETUP_TIME
			 , SETUP_TIME_UOM
		     )
		SELECT @p_master_id                AS MASTER_ID
			 , @p_engine_plan_id           AS PLAN_ID
			 , SM.LINE_SETUP_GROUP_ID      AS RESOURCE_SETUP_GROUP_ID
			 --, SM.ENG_RESOURCE_ID
			 , SM.FROM_ITEM_SETUP_GROUP_ID AS FROM_SETUP_GROUP_ID
			 , SM.TO_ITEM_SETUP_GROUP_ID   AS TO_SETUP_GROUP_ID
			 , MAX(SM.SETUP_TIME)          AS SETUP_TIME
			 , MAX(SM.SETUP_TIME_UOM)      AS SETUP_TIME_UOM
		  FROM VW_LINE_SETUP_MATRIX SM 
		 WHERE 1=1 
		   --AND SM.LINE_SETUP_GROUP_ID      = 'Prismatic_678'
		   --AND SM.FROM_ITEM_SETUP_GROUP_ID = 'Wide_666180'
		   AND EXISTS (
						SELECT ER.RESOURCE_ID
							 , ER.SITE_ID
							 , ER.RESOURCE_SETUP_GROUP_ID
						  FROM TH_ENG_RESOURCE_SN ER WITH(NOLOCK)
						 WHERE ER.MASTER_ID = @p_master_id
						   AND ER.PLAN_ID   = @p_engine_plan_id
						   --AND ER.RESOURCE_TYPE = 'CAPA'
						   AND ER.SITE_ID LIKE '%~***'
						   AND ER.RESOURCE_ID   = SM.ENG_RESOURCE_ID                 
					  )
         GROUP 
		    BY SM.LINE_SETUP_GROUP_ID
			 , SM.FROM_ITEM_SETUP_GROUP_ID
			 , SM.TO_ITEM_SETUP_GROUP_ID
		;  

        -----------------------------------------------------------
        -- TXN LOG                
        -------------------------------------------------
		SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        --SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = 'Process Complete...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT WORK;
          END

      END

    END TRY

    BEGIN CATCH
      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
	     SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()) + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      return -1
    END CATCH

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    return 1

  END
