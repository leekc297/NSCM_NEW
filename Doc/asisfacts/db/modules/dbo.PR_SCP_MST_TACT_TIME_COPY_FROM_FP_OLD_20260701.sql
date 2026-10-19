
/*
 * Program ID   : PR_SCP_MST_TACT_TIME_COPY_FROM_FP
 * Description  : CREATE DEFAULT TACT TIME FROM FP NEXT MONTH DATA
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.04.02   YYDOK         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.21   YYDOK         TACT TIME =0 제외  
 * 2018.05.24   YYDOK         TACT TIME가져오는 우선순위 적용(차차월,차월,전월)
 * 2018.08.17   YYDOK         TACT TIME가져오는 우선순위 적용(차차월,차월,전월) 오류 수정
 * 2018.09.07   YYDOK         SCP TACT TIME 기 존재시 VALID_YN UPDATE대상제외하기위해서 
 *                            DELETE INSERT 로직을 MERGE문장으로 변경함.
 * 2018.09.14   YYDOK         소형 원각형전극(UOM=EA)에 대해서 단위환산수치를 추가반영
 * 2018.09.27   YYDOK         소형 원각형전극(UOM=EA)에 대해서 단위환산수치에 PANCAKE기준으로 반영하기위해 LANE수로 나눔.
 * 2018.09.28   YYDOK         FP 구간의 전극LANE QTY는 복수개의 ITEM LANE중에서 LINE ASSIGN에 지정된 것을 사용해야함.
 * 2018.10.18   YYDOK         fp tact time가져오는 기간을 3개월에서 9개월로 확장적용
 * 2019.02.14   KSG           특성 Capa 처리 프로그램 Call
 * 2019.10.07   KSG           [IT서비스 요청번호:G20191025_000509] [CSR]GSCM 생산라인 우선순위 Logic 적용 요청
                              Priority 설정 변경 : 신규 Insert 시 99 / Update 하지 않음
 * 2019.10.30   KSG           수율 : 차월정보 반영에서 차차월 정보 반영으로 변경
 * 2021.03.12   KSG           PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Tact Time Table 변경
 * 2021.05.28   KSG           PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 대응
 * 2022.06.27   sclee.lee     PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - isuzu관련 조회구문 변경
 * 2023.11.01   KSG           PJ20230692 LGES SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : SCP용 CAPA New Version 생성
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_MST_TACT_TIME_COPY_FROM_FP_OLD_20260701]
    ( @P_DIVISION_ID         NVARCHAR(30)
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = 'SCP'
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_MST_TACT_TIME_COPY_FROM_FP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_MST_TACT_TIME'; 
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_MST_TACT_TIME INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    
    BEGIN TRY
      BEGIN
    
        --BEGIN TRANSACTION; 
		------------------------------------------------
        -- 20231101 PJ20230692 : SCP용 CAPA New Version 생성 Call
		-- SCP 사용 최신 버전 생성 : 월 ~ 목
		-- 오류 발생해도 Plan 작업은 정상 수행되어야 함
		------------------------------------------------
		DECLARE @v_cur_day           NVARCHAR(8) = CONVERT(CHAR(8), GETDATE(), 112); -- 당일 YYYYMMDD
		DECLARE @v_cur_time          NVARCHAR(8) = SUBSTRING(REPLACE(CONVERT(CHAR(8), @d_event_date, 108), ':', ''), 1, 4) -- HHMM
		DECLARE @v_version_name      NVARCHAR(100);
		DECLARE @v_day_of_week       INT;

		SET @v_version_name   = @v_cur_day + '_D_' + @v_cur_time + '_' + @P_DIVISION_ID		
		SELECT @v_day_of_week = DATEPART(DW,GETDATE()) -- 요일 일 ~ 토(1~7)

		IF @v_day_of_week IN (2, 3, 4, 5, 6) -- 월 ~ 금
		BEGIN

			BEGIN TRY
			  BEGIN
				EXEC [dbo].SCP0049_SAVE_NEW_VERSION  @p_today_yyyymmdd   = @v_cur_day
												   , @p_chk_bp           = 'N'
												   , @p_chk_rp           = 'N'
												   , @p_chk_scp          = 'Y'
												   , @p_version_division = @P_DIVISION_ID
												   , @p_version_name     = @v_version_name
												   , @p_update_id        = 'scp_batch' ;
			  END;
			END TRY
			BEGIN CATCH
				-- 오류 발생해도 작업은 정상 수행되어야 함
				SET @v_version_name   = @v_cur_day + '_D_' + @v_cur_time + '_' + @P_DIVISION_ID
			END CATCH;
			
		  -- 82 일때 전극 버전까지 생성 : 전극용이 따로 없어 시간이 덜 걸리는 82 때 같이 수행 처리
		  IF @P_DIVISION_ID = '82'
		  BEGIN

			BEGIN TRY
			  BEGIN
				EXEC [dbo].SCP0049_SAVE_NEW_VERSION  @p_today_yyyymmdd   = @v_cur_day
												   , @p_chk_bp           = 'N'
												   , @p_chk_rp           = 'N'
												   , @p_chk_scp          = 'Y'
												   , @p_version_division = 'EE'
												   , @p_version_name     = @v_version_name
												   , @p_update_id        = 'scp_batch' ;
			  END;
			END TRY
			BEGIN CATCH
				-- 오류 발생해도 작업은 정상 수행되어야 함
				SET @v_version_name   = @v_cur_day + '_D_' + @v_cur_time + '_' + 'EE'
			END CATCH;

		  END; -- IF @P_DIVISION_ID = '82'

		END; -- IF @v_day_of_week IN (1, 2, 3, 4) -- 월 ~ 목

        ---------------------------------------------------------------------------- 
        -- 1. SCP_MST_TACT_TIME 삭제(자동생성 후 수정 없는 경우)
        ---------------------------------------------------------------------------- 
       DELETE FROM SCP_MST_TACT_TIME 
        WHERE 1=1
          AND DIVISION_ID    = @P_DIVISION_ID          
          AND CREATED_BY     = 'COPY'
          AND LAST_UPDATED_BY= 'COPY';                       

        ----------------------------------------------------------- 
        --  2.SCP_MST_TACT_TIME 입력/UPDATE
        -----------------------------------------------------------
        -- 우선순위 테이블 생성 
        IF OBJECT_ID('tempdb..#temp_ord') IS NOT NULL                    
          DROP TABLE #temp_ord            

        -- tact time가져오는 월별 우선순위 지정
        SELECT * 
        INTO #temp_ord
        FROM 
            (
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,2,GETDATE()),112),1,6) AS MONTH ,1  AS NO UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,1,GETDATE()),112),1,6)          ,2        UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,0,GETDATE()),112),1,6)          ,3        UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,3,GETDATE()),112),1,6)          ,4        UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,4,GETDATE()),112),1,6)          ,5        UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,5,GETDATE()),112),1,6)          ,6        UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,6,GETDATE()),112),1,6)          ,7        UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,7,GETDATE()),112),1,6)          ,8        UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,8,GETDATE()),112),1,6)          ,9        UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,9,GETDATE()),112),1,6)          ,10       UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,10,GETDATE()),112),1,6)         ,11       UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,11,GETDATE()),112),1,6)         ,12       UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,12,GETDATE()),112),1,6)         ,13       UNION ALL
			  -- 20210528 PJ20209642 기간 추가
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,13,GETDATE()),112),1,6)         ,14       UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,14,GETDATE()),112),1,6)         ,15       UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,15,GETDATE()),112),1,6)         ,16       UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,16,GETDATE()),112),1,6)         ,17       UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,17,GETDATE()),112),1,6)         ,18       UNION ALL
              SELECT SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,18,GETDATE()),112),1,6)         ,19
            ) X 
        ;
		
		-- 20210312 PJ20209642 : scm_mst_tact_time_ver_h_v 기준으로 처리
         WITH SUB AS
             (           SELECT T.DIVISION_ID
                              , T.PLANT_ID
                              , T.PLANT_SITE_ID
                              , T.ITEM_ID
                              , T.OPERATION_ID
                              , T.LINE_ID
                              , T.MONTH
							 -- 20191007 Priority 설정 변경 : 신규 Insert 시 99 / Update 하지 않음
                              , 99 AS PRIORITY
                              , Y.No AS NO
                              , t.TACT_TIME
                              , t.lane_qty AS lane_qty
                           FROM scm_mst_tact_time_ver_h_v t WITH(NOLOCK)
                               ,#temp_ord  Y  WITH (NOLOCK)
                          WHERE 1=1
                            AND T.DIVISION_ID    = @p_division_id
/* 							
                            AND T.OPERATION_ID   IN ( 
                                                      SELECT DISTINCT b.segment4
                                                        FROM   scm_adm_lookup_master_detail b WITH (NOLOCK)
                                                       WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                                         AND b.valid_yn    = 'Y'
                                                         AND b.segment3    = 'Y' -- Capa 세부 공정 여부
                                                     )
*/
                            -- PJ20216891	
                            -- ISUZU item
                            AND (
                                 t.operation_id IN (
                                                    SELECT DISTINCT b.segment4
                                                    FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
                                                    WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                                    AND    b.valid_yn    = 'Y'
                                                    AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
                                                   )
                                 OR (
                                     t.operation_id = 'P5000'
                                     AND EXISTS (
                                                 SELECT 1
                                                 FROM   dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
                                                 INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
                                                 WHERE  A.ITEM_ID = t.ITEM_ID
                                                 AND    A.IS_YN = 'Y'
                                                )
                                    )
                                )
                            AND T.MONTH > SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,-1,GETDATE()),112),1,6)
                            AND T.MONTH < SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,19,GETDATE()),112),1,6)  -- 20210528 PJ20209642
                            AND T.MONTH          = Y.MONTH
             )                  

             MERGE  SCP_MST_TACT_TIME           
             USING
                    (
                           SELECT  DIVISION_ID
                                 , PLANT_SITE_ID
                                 , ITEM_ID
                                 , OPERATION_ID
                                 , LINE_ID
                                 , ISNULL(PRIORITY, 99) AS PRIORITY -- 20191007 Priority 설정 변경 : 0 => 1
                                 , ISNULL(TACT_TIME,0) AS TACT_TIME
                                 -- 20191030 수율 : 차월정보 반영에서 차차월 정보 반영으로 변경
                                 , ISNULL([dbo].[FN_GET_ITEM_LINE_YIELD](DIVISION_ID, PLANT_ID, ITEM_ID, LINE_ID, OPERATION_ID, SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,2,GETDATE()),112),1,6)+'01')
                                        , 0) AS YIELD
                                 , VALID_YN
                                 , CREATED_BY
                                 , CREATION_DATE
                                 , LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE
                                 , LANE_QTY
                           FROM
                           (          
                                  SELECT *
                                    FROM (
                                          SELECT   SUB.DIVISION_ID
                                                  ,SUB.PLANT_ID
                                                  ,SUB.PLANT_SITE_ID
                                                  ,SUB.ITEM_ID
                                                  ,SUB.OPERATION_ID
                                                  ,SUB.LINE_ID
                                                  ,ROW_NUMBER() OVER (PARTITION BY DIVISION_ID,PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID ORDER BY No asc) AS No 
                                                  ,SUB.PRIORITY
                                                  ,SUB.TACT_TIME
                                                  ,SUB.LANE_QTY      
                                                  , 'Y'       AS VALID_YN
                                                  , 'COPY'    AS CREATED_BY
                                                  , GETDATE() AS CREATION_DATE
                                                  , 'COPY'    AS LAST_UPDATED_BY
                                                  , GETDATE() AS LAST_UPDATE_DATE                                        
                                           FROM SUB
                                          WHERE 1=1
                                        ) Y
                                  WHERE Y.No = 1
                                 
                           ) X
                            
                     ) FP_TT
            ON  SCP_MST_TACT_TIME.DIVISION_ID     = FP_TT.DIVISION_ID
            AND SCP_MST_TACT_TIME.PLANT_SITE_ID   = FP_TT.PLANT_SITE_ID
            AND SCP_MST_TACT_TIME.ITEM_ID         = FP_TT.ITEM_ID            
            AND SCP_MST_TACT_TIME.OPERATION_ID    = FP_TT.OPERATION_ID            
            AND SCP_MST_TACT_TIME.LINE_ID         = FP_TT.LINE_ID            
            
            WHEN MATCHED THEN
            
                 UPDATE  SET --PRIORITY         = FP_TT.PRIORITY, -- 20191007 Priority 설정 변경 : 신규 Insert 시 99 / Update 하지 않음
                             TACT_TIME        = FP_TT.TACT_TIME,  
                             YIELD            = FP_TT.YIELD,
                             LAST_UPDATED_BY  = FP_TT.LAST_UPDATED_BY,
                             LAST_UPDATE_DATE = FP_TT.LAST_UPDATE_DATE,
                             ATTRIBUTE1       = FP_TT.LANE_QTY -- 전극 LANE QTY
            
            WHEN NOT MATCHED THEN         
                     
                 INSERT ( DIVISION_ID
                        , PLANT_SITE_ID
                        , ITEM_ID
                        , OPERATION_ID
                        , LINE_ID
                        , PRIORITY
                        , TACT_TIME
                        , YIELD  
                        , VALID_YN
                        , CREATED_BY
                        , CREATION_DATE
                        , LAST_UPDATED_BY
                        , LAST_UPDATE_DATE
                        , ATTRIBUTE1            -- 전극 LANE QTY
                         ) 
                 VALUES ( FP_TT.DIVISION_ID
                        , FP_TT.PLANT_SITE_ID
                        , FP_TT.ITEM_ID
                        , FP_TT.OPERATION_ID
                        , FP_TT.LINE_ID
                        , FP_TT.PRIORITY
                        , FP_TT.TACT_TIME
                        , FP_TT.YIELD  
                        , FP_TT.VALID_YN
                        , FP_TT.CREATED_BY
                        , FP_TT.CREATION_DATE
                        , FP_TT.LAST_UPDATED_BY
                        , FP_TT.LAST_UPDATE_DATE
                        , FP_TT.LANE_QTY
                         )
            ;     
			
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;    
        SET @v_log_type = N'TXN'; 
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) +  ' ; ' + @p_division_id
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;
        
		-- ITEM_UOM / LANE_QTY(없는 경우 1 처리)
        UPDATE SCP_MST_TACT_TIME
           SET ITEM_UOM = ( SELECT TOP 1 ITEM_UOM
                              FROM SCM_MST_ITEM_SN A WITH(NOLOCK)
                             WHERE A.DIVISION_ID = SCP_MST_TACT_TIME.DIVISION_ID
                               AND A.ITEM_ID     = SCP_MST_TACT_TIME.ITEM_ID ),
			   --LANE QTY
               --ATTRIBUTE1 = ISNULL(ATTRIBUTE1,1) --LANE QTY
			   ATTRIBUTE1 = CASE WHEN ISNULL(ATTRIBUTE1, '') = ''      THEN '1'
                                 WHEN ATTRIBUTE1 = '0.0000000000' THEN '1'
                                 ELSE ATTRIBUTE1
                            END
         WHERE DIVISION_ID =@P_DIVISION_ID;
          -- AND PLANT_SITE_ID LIKE '%-E'

        ------------------------------------------------------------------- 
        --  3.소형전극 ITEM에 대하여 ITEM_UOM.UOM_CONVERT_VALUE UPDATE
        -------------------------------------------------------------------        
        IF @P_DIVISION_ID = '40' 
        BEGIN
              /**************************************************************************************************
               * 소형 전극 원,각형 단위 EA인 경우, EA_M 단위환산자를 PANCAKE기준으로 LANE수를 나누어서 셋팅
			   *    UOM Convert는 FP의 Pancake Master 기준 Lane 수 사용(FP 확인 : Tact Time이 사용하는 Line Assign의 : Lane Qty와는 달라야 함)
               **************************************************************************************************/

               IF OBJECT_ID('tempdb..#UOM_CONVERT_VALUE') IS NOT NULL                    
                  DROP TABLE #UOM_CONVERT_VALUE           

               SELECT 
                        L.DIVISION_ID,
                        A.LINE_ID,
                        A.ITEM_ID,
                        A.OPERATION_ID,
						-- Pancake Master 기준 Lane 수 사용
                        ISNULL(    MAX(ISNULL(CASE WHEN C.CATEGORY = N'Jumbo Roll (cell/m)' THEN C.VALUE END,1))
						         / MAX(ISNULL(CASE WHEN C.CATEGORY = N'Lane Number' AND C.VALUE > 0 THEN C.VALUE END,1))
						      , 1) AS VALUE
                        --ISNULL(MAX(ISNULL(C.VALUE,1)),1) AS VALUE
                INTO #UOM_CONVERT_VALUE
                FROM SCP_MST_TACT_TIME A  WITH(NOLOCK)
                INNER JOIN SCM_MST_LINE_SN L WITH(NOLOCK)
                            ON  A.DIVISION_ID       = L.DIVISION_ID
                            AND A.LINE_ID           = L.LINE_ID
                            AND A.OPERATION_ID      = L.OPERATION_ID 
                INNER JOIN SCM_MST_ITEM_CONV_CALC_SN C WITH(NOLOCK)
                            ON  C.MAX_VER_FLAG      = 'Y'
                            AND C.CATEGORY          IN (N'Jumbo Roll (cell/m)', N'Lane Number')
                            --AND C.CATEGORY          = N'Jumbo Roll (cell/m)'
                            AND C.COMPANY_ID        = L.COMPANY_ID
                            AND C.DIVISION_ID       = L.DIVISION_ID
                            AND C.SITE_ID           = L.SITE_ID
                            AND C.FACTORY_ID        = L.FACTORY_ID
                            AND C.OPERATION         = L.OPERATION_ID
                            AND C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE  --GENERAL/WIDE
                            AND C.ITEM_ID           = A.ITEM_ID
                WHERE 1=1
                 AND A.DIVISION_ID  = '40'
              GROUP BY L.COMPANY_ID,
                    L.DIVISION_ID,
                    L.SITE_ID,
                    L.PLANT_ID,
                    L.FACTORY_ID,
                    A.LINE_ID,
                    A.ITEM_ID,
                    A.OPERATION_ID
                    ;

              UPDATE X
              SET X.UOM_CONVERT_VALUE = ( SELECT TOP 1 ISNULL(VALUE,1)
                                            FROM #UOM_CONVERT_VALUE Y
                                           WHERE 0 = 0
                                                 AND X.DIVISION_ID  = Y.DIVISION_ID
                                                 AND X.ITEM_ID      = Y.ITEM_ID 
                                                 AND X.LINE_ID      = Y.LINE_ID
                                                 AND X.OPERATION_ID = Y.OPERATION_ID
                                         )  
										 -- 전극 LANE QTY 는 위에서 반영
                                         --/ ( CASE WHEN ISNULL(CONVERT(NUMERIC,ATTRIBUTE1),1) = 0 THEN 1
                                         --         ELSE ISNULL(CONVERT(NUMERIC,ATTRIBUTE1),1)
                                         --     END
                                         --   )
                                         --                                             --전극 LANE QTY
              FROM SCP_MST_TACT_TIME X
             
               WHERE X.DIVISION_ID      = '40'
                 AND X.PLANT_SITE_ID LIKE '%-E'
                 AND X.ITEM_UOM         = 'EA'
                 AND X.LINE_ID          IS NOT NULL
                 ;        
             
			  SET @n_log_count = @@ROWCOUNT;     
       
        END;
        PRINT N'*** PROCEDURE END ***'		
		
		-------------------------------------------
		-- 임시 테이블 Drop
		-------------------------------------------
        IF OBJECT_ID('tempdb..#temp_ord') IS NOT NULL
        BEGIN 
            DROP TABLE #temp_ord          
        END 
				 
        IF OBJECT_ID('tempdb..#UOM_CONVERT_VALUE') IS NOT NULL                    
            DROP TABLE #UOM_CONVERT_VALUE   

        ----------------------------------------------------------- 
        -- 9. 종료 처리
        -----------------------------------------------------------

        --IF @@TRANCOUNT > 0 
        --  BEGIN
        --    COMMIT WORK;
        --  END;
        
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        -- TXN LOG
        --SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'Update '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) +  ' ; ' + @p_division_id
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;

        ----------------------------------------------------------- 
        -- 2019.02.14 : 특성 Capa 처리 프로그램 Call
        -----------------------------------------------------------
		EXEC PR_SCP_MST_CHAR_CAPA ;

      END;

    END TRY

    BEGIN CATCH
        
     -- IF @@TRANCOUNT > 0 
     --   BEGIN
     --     ROLLBACK;
     --   END;

      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    return 1 

  END;
