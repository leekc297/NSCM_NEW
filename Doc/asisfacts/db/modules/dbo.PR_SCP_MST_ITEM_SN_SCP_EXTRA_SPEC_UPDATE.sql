
/*
 * Program ID   : PR_SCP_MST_ITEM_SN_SCP_EXTRA_SPEC_UPDATE
 * Description  : SCM_MST_ITEM_SN의 SCP_EXTRA_SPEC update
				: 매일 x시에 동작함.
				: SCP_EXTRA_SPEC이 없으면 Update함
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.07.04   sclee.lee      Initial Release PJ20216891 Digital SCM 3 Level 가속화를 위한 개선
 * 2025.02.27   hrkim		   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선
 *								Cell Assy 모델 extra spec update 대상에 포함
 *								- 하위 반제품 참조에서  Cell Assy 모델은 제외함
 *								 (반제품 참조시 Cell Assy가 포함되어 '일반'이 아닌데 일반으로 update되는 현상)
 *								- with 구문을 temp 테이블 사용으로 변경  
 *
 */

CREATE PROCEDURE [dbo].[PR_SCP_MST_ITEM_SN_SCP_EXTRA_SPEC_UPDATE]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;
    SET ANSI_NULLS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_ITEM_SN_SCP_EXTRA_SPEC_UPDATE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
    -- LOOP 관련 변수 설정
    -- DECLARE @v_total_cnt          INT;
    DECLARE @v_current            INT = 0;
    DECLARE @v_division_id        NVARCHAR(30);
    DECLARE @v_item_id            NVARCHAR(150);
    DECLARE @v_new_scp_extra_spec NVARCHAR(150);
	
    DECLARE @v_tb_target TABLE
    (
     RowIdx                 INT IDENTITY(1,1),
     DIVISION_ID            NVARCHAR(30) NOT NULL,
     ITEM_ID                NVARCHAR(150) NOT NULL,
     SCP_EXTRA_SPEC         NVARCHAR(150) NULL,
     NEW_SCP_EXTRA_SPEC     NVARCHAR(150) NULL,
     ITEM_CLASS             NVARCHAR(50) NOT NULL
    );

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
		
		/* 2025.02.27 변경전 소스 Start 
		-------------------------------------------
        -- SCP_EXTRA_SPEC 업데이트 대상 조회 및 기존 내역 백업
		-------------------------------------------
        ;WITH sub AS
        (
         SELECT CT.COMPANY_ID
               ,CT.DIVISION_ID
               ,CT.SITE_ID 
               ,CT.MODEL_ID
               ,SI.ITEM_CLASS
               ,ROW_NUMBER() OVER (PARTITION BY CT.COMPANY_ID ,CT.SITE_ID ,CT.MODEL_ID ,CT.PLANT_ID ORDER BY CT.NLEVEL ,CT.INSERT_TIME ,CT.CHILD_ITEM_ID) RN
         FROM  dbo.[SCM_MST_ITEM_SN] SI WITH(NOLOCK)
         INNER JOIN dbo.[SCM_MST_BOM_SN] CT WITH(NOLOCK)
         ON  CT.CHILD_ITEM_ID     = SI.ITEM_ID
         AND CT.CHILD_COMPANY_ID  = SI.COMPANY_ID
         AND CT.CHILD_DIVISION_ID = SI.DIVISION_ID
         AND CT.CHILD_SITE_ID     = SI.SITE_ID
         INNER JOIN dbo.[SCP_MST_FINAL_ITEM] C WITH(NOLOCK)
         ON  CT.DIVISION_ID = C.DIVISION_ID
         AND CT.MODEL_ID = C.ITEM_ID
         INNER JOIN dbo.[SCM_MST_ITEM_CLASS_SN] IC WITH(NOLOCK)
         ON  SI.ITEM_CLASS        = IC.CLASS_ID
         WHERE 1 = 1
           AND CT.DIVISION_ID = N'40' 
           AND ISNULL(SI.ITEM_TYPE,'H') IN ('H')
           AND CT.ALT_PRIORITY = 'Y'
           AND C.ITEM_CLASS IN (
                                SELECT b.segment1
                                FROM   scm_adm_lookup_master_detail b WITH (NOLOCK)
                                WHERE  b.lookup_type = 'SCP_EXTRA_SPEC_ITEM_CLASS'
                                AND    b.valid_yn    = 'Y'
                               )
           AND IC.USE_FLAG = 'Y'
        ),
        sub1 AS
        (
         SELECT A.*
		        -- 20230327  내용 조정
               ,NEW_SCP_EXTRA_SPEC = CASE WHEN A.ITEM_CLASS = 'ES0801' THEN 'Stacking'
			                              WHEN A.ITEM_CLASS = 'ES1701' THEN 'ZZS'
										  ELSE N'일반'
			                         END 
               --,NEW_SCP_EXTRA_SPEC = IIF(A.ITEM_CLASS IN ('ES1701', 'ES0801'), 'Stacking', N'일반')
         FROM   sub A
         WHERE  1 = 1
         AND    A.RN = 1  -- ISNULL(SI.ITEM_TYPE,'H') IN ('H')과 CT.ALT_PRIORITY = 'Y'을 만족하는 첫번째 CHILD_ITEM_ID
        )
        INSERT INTO @v_tb_target
        (
         ITEM_ID,
         DIVISION_ID,
         ITEM_CLASS,
         SCP_EXTRA_SPEC,
         NEW_SCP_EXTRA_SPEC
        )
        SELECT DISTINCT A.MODEL_ID
              ,A.DIVISION_ID, A.ITEM_CLASS
              ,X.SCP_EXTRA_SPEC
              ,A.NEW_SCP_EXTRA_SPEC
        FROM   sub1 A
        INNER JOIN dbo.SCM_MST_ITEM_SN X WITH(NOLOCK)
        ON  A.MODEL_ID = X.ITEM_ID
        AND A.DIVISION_ID = X.DIVISION_ID
        WHERE 1 = 1
        AND X.SCP_EXTRA_SPEC IS NULL
        ORDER BY A.ITEM_CLASS DESC;
        
        SET @n_log_count = @@ROWCOUNT;

		-------------------------------------------
        -- SCP_EXTRA_SPEC 업데이트 실행
		-------------------------------------------

        WHILE(@v_current < @n_log_count)
        BEGIN
            SET @v_current += 1;
        
            SELECT @v_item_id = ITEM_ID
                  ,@v_division_id = DIVISION_ID
                  ,@v_new_scp_extra_spec = NEW_SCP_EXTRA_SPEC
            FROM   @v_tb_target
            WHERE  RowIdx = @v_current;
            
            UPDATE dbo.SCM_MST_ITEM_SN
               SET SCP_EXTRA_SPEC = @v_new_scp_extra_spec
             WHERE DIVISION_ID = @v_division_id
               AND ITEM_ID = @v_item_id;
        END

		2025.02.27 변경전 소스 End */
		
		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'대상 cell model  - Cell Product  ' 
		----------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#TGT_CELL_MODEL') is not null drop table #TGT_CELL_MODEL

		;WITH sub AS
        (
         SELECT CT.COMPANY_ID
               ,CT.DIVISION_ID
               ,CT.SITE_ID 
               ,CT.MODEL_ID
               ,SI.ITEM_CLASS	 -- 반제품 item class 
               ,ROW_NUMBER() OVER (PARTITION BY CT.COMPANY_ID 
											   ,CT.SITE_ID 
											   ,CT.MODEL_ID 
											   ,CT.PLANT_ID 
							           ORDER BY CT.NLEVEL 
									   ,CT.INSERT_TIME 
									   ,CT.CHILD_ITEM_ID) RN
         FROM  dbo.[SCM_MST_ITEM_SN] SI WITH(NOLOCK)
				 INNER JOIN dbo.[SCM_MST_BOM_SN] CT WITH(NOLOCK)
						 ON  CT.CHILD_ITEM_ID     = SI.ITEM_ID
						 AND CT.CHILD_COMPANY_ID  = SI.COMPANY_ID
						 AND CT.CHILD_DIVISION_ID = SI.DIVISION_ID
						 AND CT.CHILD_SITE_ID     = SI.SITE_ID
				 INNER JOIN dbo.[SCP_MST_FINAL_ITEM] C WITH(NOLOCK)
						 ON  CT.DIVISION_ID = C.DIVISION_ID
						 AND CT.MODEL_ID = C.ITEM_ID
				 INNER JOIN dbo.[SCM_MST_ITEM_CLASS_SN] IC WITH(NOLOCK)
						 ON  SI.ITEM_CLASS        = IC.CLASS_ID
         WHERE 1 = 1
           AND CT.DIVISION_ID = N'40' 
           AND ISNULL(SI.ITEM_TYPE,'H') IN ('H')
           AND CT.ALT_PRIORITY = 'Y'
           AND C.ITEM_CLASS IN (  -- model item_class 
                                SELECT b.segment1
                                FROM   scm_adm_lookup_master_detail b WITH (NOLOCK)
                                WHERE  b.lookup_type = 'SCP_EXTRA_SPEC_ITEM_CLASS'
                                AND    b.valid_yn    = 'Y'
                               )
           AND IC.USE_FLAG = 'Y'
		   AND NOT EXISTS (SELECT 'X'	-- 2025.02.27 모델 하위 반제품 Cell Assy 제외 
							FROM SCP_MST_CELL_PROD_ASSY_MAP CA with(nolock)
						   WHERE CA.DIVISION_ID = SI.DIVISION_ID
						     AND CA.ITEM_ID_ASSY = SI.ITEM_ID) 
        )
		SELECT DISTINCT 
			  A.DIVISION_ID
			  ,A.MODEL_ID
			  ,A.ITEM_CLASS				-- 반제품 Item class 
			  ,'CP'				AS DV	-- CP(Cell Product)/CA(Cell Assy) 구분 
			  ,A.MODEL_ID		AS CP_ITEM_ID
		 INTO #TGT_CELL_MODEL
		 FROM sub A
		WHERE 1 = 1
		  AND A.RN = 1

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'대상 cell model  - Cell Assy 추가 ' 
		-- 2025.02.25 Cell Assy update 대상에 포함
		----------------------------------------------------------------------------------------------------------
		INSERT INTO #TGT_CELL_MODEL
		SELECT DISTINCT  
			    A.DIVISION_ID
			   ,CA.ITEM_ID_ASSY		AS MODEL_ID
			   ,A.ITEM_CLASS
			  ,'CA'					AS DV	-- CP(Cell Product)/CA(Cell Assy) 구분 
			  , A.MODEL_ID			AS CP_ITEM_ID 
		  FROM  #TGT_CELL_MODEL A
				INNER JOIN SCP_MST_CELL_PROD_ASSY_MAP CA with(nolock)
						ON CA.DIVISION_ID	= A.DIVISION_ID
					   AND CA.ITEM_ID_PROD	= A.MODEL_ID
		 WHERE  1=1

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'기등록 CP모델의 extra spec 정보 ' 
		-- 2025.02.27 extra spec 기등록 된 Cell Product 모델이 있는 경우(UI에서 update?) 
		-- 기 등록된 CP의 extra spec과 같은 값으로 update하기 위해 CP의 extra spec 정보 추출 
		----------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCP_EXTRA_SPEC_CP') is not null drop table #SCP_EXTRA_SPEC_CP
		--- CP 기준 참조 scp_extra_spec  (기등록)     
		 SELECT TG.DIVISION_ID
			   ,TG.MODEL_ID
			   ,TG.DV
			   ,MAX(CP.SCP_EXTRA_SPEC)  AS	SCP_EXTRA_SPEC_CP_ASIS
		  INTO #SCP_EXTRA_SPEC_CP
		  FROM #TGT_CELL_MODEL TG
			   INNER JOIN dbo.[SCM_MST_ITEM_SN] CP WITH(NOLOCK)
					   ON CP.DIVISION_ID = TG.DIVISION_ID
					  AND CP.ITEM_ID	 = TG.CP_ITEM_ID -- Cell Product Model 
		  WHERE 1=1 
		    AND CP.SCP_EXTRA_SPEC  IS NOT NULL
			AND CP.SCP_EXTRA_SPEC != ''
		  GROUP BY TG.DIVISION_ID
				  ,TG.MODEL_ID
				  ,TG.DV

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'소형 대상 모델 with extra spec  ' 
		----------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#TARGET_EXTRA_SPEC') is not null drop table #TARGET_EXTRA_SPEC

		--- CP 기준 참조 scp_extra_spec  (기등록)     
		 SELECT TG.*
			   ,CASE WHEN CP.SCP_EXTRA_SPEC_CP_ASIS IS NOT NULL AND CP.SCP_EXTRA_SPEC_CP_ASIS != N'일반'	THEN CP.SCP_EXTRA_SPEC_CP_ASIS
					 WHEN TG.ITEM_CLASS = 'ES0801'															THEN 'Stacking'   --- 반제품 ITEM class 
			 		 WHEN TG.ITEM_CLASS = 'ES1701'															THEN 'ZZS'
			 		 ELSE N'일반'
			 	 END	AS SCP_EXTRA_SPEC_TOBE 
			   ,CP.SCP_EXTRA_SPEC_CP_ASIS
		  INTO #TARGET_EXTRA_SPEC
		  FROM #TGT_CELL_MODEL TG
			   LEFT JOIN #SCP_EXTRA_SPEC_CP CP 
					  ON CP.DIVISION_ID = TG.DIVISION_ID
					 AND CP.MODEL_ID	= TG.MODEL_ID 
					 AND CP.DV			= TG.DV
		  WHERE 1=1 

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'소형 최종 update 대상' 
		----------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#TARGET_EXTRA_SPEC_FIANL') is not null drop table #TARGET_EXTRA_SPEC_FIANL
        SELECT DISTINCT A.MODEL_ID
					  , A.DIVISION_ID
					  , A.ITEM_CLASS
					  , A.SCP_EXTRA_SPEC_TOBE
					  , A.SCP_EXTRA_SPEC_CP_ASIS
					  , X.SCP_EXTRA_SPEC
					  , ROW_NUMBER() OVER (PARTITION BY A.MODEL_ID
													   ,A.DIVISION_ID
											   ORDER BY A.ITEM_CLASS) AS RN 
		 INTO  #TARGET_EXTRA_SPEC_FIANL
         FROM  #TARGET_EXTRA_SPEC A 
			   INNER JOIN dbo.SCM_MST_ITEM_SN X WITH(NOLOCK)
					   ON A.MODEL_ID	  = X.ITEM_ID
					  AND A.DIVISION_ID	  = X.DIVISION_ID
        WHERE 1 = 1
          AND (X.SCP_EXTRA_SPEC IS NULL 
			  OR 
			   (X.SCP_EXTRA_SPEC = N'일반' AND A.SCP_EXTRA_SPEC_TOBE != N'일반')
			   )

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'SCP_EXTRA_SPEC 업데이트 실행 ' 
		----------------------------------------------------------------------------------------------------------
		UPDATE TG 
		   SET TG.SCP_EXTRA_SPEC = FT.SCP_EXTRA_SPEC_TOBE
		     , UPDATE_TIME		 = GETDATE()
			 , UPDATE_ID		 = @v_program_name 
		  FROM #TARGET_EXTRA_SPEC_FIANL FT
			   INNER JOIN SCM_MST_ITEM_SN TG WITH(NOLOCK)
					   ON TG.DIVISION_ID = FT.DIVISION_ID
					  AND TG.ITEM_ID	 = FT.MODEL_ID 
		 WHERE 1=1
		   AND FT.RN = 1 

        SET @n_log_count = @@ROWCOUNT;

    END TRY

    BEGIN CATCH
	  IF @@TRANCOUNT > 0 
        BEGIN
          ROLLBACK;
        END;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
