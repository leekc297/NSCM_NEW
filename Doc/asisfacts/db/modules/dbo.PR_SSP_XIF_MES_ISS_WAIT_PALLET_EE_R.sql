/*
 * Program ID   : PR_SSP_XIF_MES_ISS_WAIT_PALLET_EE_R
 * Description  : 전극 MES  LOT 재고 정보 I/F 수신 반영(Every 10 min)  
 * OutTable     : XIF_MES_ISS_WAIT_PALLET_EE_R_SN --> SSP_DNM_MES_STOCK_EE
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.05.28   LJH         Initial Release [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 
 * 2021.02.16   KBK         MES I/F 재고 체크후 실행하도록 LOGIC 변경
 */

CREATE PROCEDURE [dbo].[PR_SSP_XIF_MES_ISS_WAIT_PALLET_EE_R]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  
--    SET     @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_XIF_MES_ISS_WAIT_PALLET_EE_R';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_DNM_MES_STOCK_EE'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_DNM_MES_STOCK_EE INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';

	-- DECLARE @v_master_if_seq  NVARCHAR(MAX) = '';
	DECLARE @v_count          INT  = 0 ;

    BEGIN TRY
      BEGIN
       BEGIN TRAN TX_SH

		DECLARE @stock_cnt INTEGER, 
			    @company_id VARCHAR(30),  
				@group_seq VARCHAR(30)

		DECLARE @idx INT     SET     @idx = 0  
 

		-- COMPANY 별 I/F 건수와 전송 대상 건수 체크 : 2021.02,04
		DECLARE CUR_MES_STOCK CURSOR FOR  
		SELECT SUM(A.CHECK_CNT) AS STOCK_CNT
				, A.COMPANY_ID
				, A.GROUP_SEQ
		FROM   (
				SELECT CASE WHEN B.IF_CNT = 0 THEN 0
							WHEN B.IF_CNT IS NULL THEN 1
						ELSE 
							CASE WHEN A.IF_CNT <> B.IF_CNT THEN 1
							ELSE 0 END 
						END   AS CHECK_CNT
						, A.COMPANY_ID
						, A.COMPANY_ID + SUBSTRING(A.GROUP_SEQ, 1, 8) AS GROUP_SEQ
				FROM   (
						SELECT A.ATTRIBUTE5  AS COMPANY_ID
								, ISNULL(A.ATTRIBUTE7, CONVERT(CHAR(8), GETDATE(), 112))  AS GROUP_SEQ
								, COUNT(*)  AS IF_CNT
						--FROM   [10.34.220.88,7433].[LGCE_INF].[dbo].[XIF_MES_ISS_WAIT_PALLET_EE_R]  A WITH(NOLOCK)
						FROM   XIF_MES_ISS_WAIT_PALLET_EE_R_SN  A WITH(NOLOCK)
						WHERE  1 = 1
						AND    ISNULL(A.PROC_FLAG,'N') = 'N'
						AND    A.SUM_DATE = CONVERT(CHAR(8), GETDATE(), 112)
						GROUP BY A.ATTRIBUTE5
								, A.ATTRIBUTE7
						) A
						LEFT OUTER JOIN (
						SELECT A.COMPANY_ID, A.GROUP_SEQ, SUM(IF_CNT) AS IF_CNT
						FROM   (
								SELECT A.ATTRIBUTE5  AS COMPANY_ID
										, ISNULL(A.ATTRIBUTE7, CONVERT(CHAR(8), GETDATE(), 112))  AS GROUP_SEQ
										, CONVERT(INT, A.ATTRIBUTE6)  AS IF_CNT
								--FROM   [10.34.220.88,7433].[LGCE_INF].[dbo].[XIF_MES_ISS_WAIT_PALLET_EE_R]  A WITH(NOLOCK)
								FROM   XIF_MES_ISS_WAIT_PALLET_EE_R_SN  A WITH(NOLOCK)
								WHERE  1 = 1
								AND    ISNULL(A.PROC_FLAG,'N') = 'N'
								AND    A.SUM_DATE = CONVERT(CHAR(8), GETDATE(), 112)
								GROUP BY A.ATTRIBUTE5
										, A.ATTRIBUTE6
										, A.ATTRIBUTE7
								) A
						WHERE  1 = 1
						GROUP BY A.COMPANY_ID
								, A.GROUP_SEQ
						) B
						ON   A.COMPANY_ID = B.COMPANY_ID
						AND  A.GROUP_SEQ  = B.GROUP_SEQ
				WHERE  1 = 1
				) A
		WHERE  1 = 1
		GROUP BY A.COMPANY_ID
				, A.GROUP_SEQ
		;

		OPEN CUR_MES_STOCK; 

		FETCH NEXT FROM CUR_MES_STOCK INTO @stock_cnt, 
			                            @company_id,
										@group_seq

		WHILE(@@FETCH_STATUS = 0) 

		BEGIN

			-- COMPANY별 수행여부 체크
			SELECT @v_count = COUNT(*)
			FROM   SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
			WHERE  1 = 1
			AND    A.LOOKUP_TYPE = 'SSP_IF_STOCK_CHECK'
			AND    A.SEGMENT1 = 'PLAN_EE'
			AND    A.SEGMENT2 = 'MES'
			AND    A.SEGMENT3 = 'EE'
			AND    A.SEGMENT4 = @company_id
			AND    A.SEGMENT5 = CONVERT(CHAR(8), GETDATE(), 112)
			AND    A.ATTRIBUTE1 = 'Y'
			;

			IF @stock_cnt = 0 AND @v_count = 0
			BEGIN
				UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
				SET    SEGMENT5 = CONVERT(CHAR(8), GETDATE(), 112)
					 , ATTRIBUTE1 = 'N'
				WHERE  1 = 1
				AND    LOOKUP_TYPE = 'SSP_IF_STOCK_CHECK'
				AND    SEGMENT1 = 'PLAN_EE'
				AND    SEGMENT2 = 'MES'
				AND    SEGMENT3 = 'EE'
				AND    SEGMENT4 = @company_id
				--AND    SEGMENT5 = CONVERT(CHAR(8), GETDATE(), 112)
				--AND    ATTRIBUTE1 = 'N'
				;

				-- 인터페이스 테이블 처리 ROW UPDATE
				UPDATE XIF_MES_ISS_WAIT_PALLET_EE_R_SN 
				SET    PROC_FLAG             = 'P'
				WHERE  ISNULL(PROC_FLAG,'N') = 'N'
				AND    SUM_DATE = CONVERT(CHAR(8), GETDATE(), 112)
				AND    ATTRIBUTE5 = @company_id
				;  
      
				--CURSOR 선언 
				DECLARE @if_seq VARCHAR(MAX)


				DECLARE CUR_MES_R CURSOR FOR  
				SELECT IF_SEQ
				FROM   XIF_MES_ISS_WAIT_PALLET_EE_R_SN WITH(NOLOCK) 
				WHERE  ISNULL(PROC_FLAG,'N') = 'P' 
				AND    ATTRIBUTE5 = @company_id
				AND    ATTRIBUTE6 <> '0'
				AND    SUM_DATE = CONVERT(CHAR(8), GETDATE(), 112)
				ORDER BY IF_SEQ
				;

				OPEN CUR_MES_R; 

				FETCH NEXT FROM CUR_MES_R INTO @if_seq

				WHILE(@@FETCH_STATUS = 0) 

				BEGIN

					PRINT @if_seq ;

					MERGE INTO SSP_DNM_MES_STOCK_EE M
					USING
					(
						SELECT 
							 S.DIVISION_ID              AS DIVISION_ID         
							,S.COMPANY_ID               AS COMPANY_ID          
							,S.SCM_SITE_ID              AS FROM_SITE           
							,X.SUM_DATE                 AS YYYYMMDD            
							,X.INSTANCE_TYPE            AS INSTANCE_TYPE       
							,X.PLANT_ID                 AS PLANT_ID            
							,X.LOTID                    AS LOT_ID              
							,X.PRODID                   AS ITEM_ID             
							,X.MODELID                  AS MODEL_ID            
							,X.PRJT_NAME                AS PRJT_NAME           
							,X.NOW_FACTORY              AS NOW_FACTORY         
							,X.PROD_FACTORY             AS PROD_FACTORY        
							,X.ELECTRODE_VERSION        AS ELECTRODE_VERSION   
							,X.LANE                     AS LANE                
							,X.UOM                      AS UOM                 
							,X.STOCK_QTY                AS STOCK_QTY           
							,X.STOCK_QTY_PC_M           AS STOCK_QTY_PC_M         
							,X.EXPIRATION_DATE          AS EXPIRATION_DATE     
							,X.COATING_PROD_DATE        AS COATING_PROD_DATE   
							,X.OPERATION_ID             AS OPERATION_ID        
							,X.LINE_ID                  AS LINE_ID             
							,X.MES_HOLD                 AS MES_HOLD            
							,X.QMS_HOLD                 AS QMS_HOLD            
							,X.MES_HOLD_DATE            AS MES_HOLD_DATE       
							,X.QMS_HOLD_DATE            AS QMS_HOLD_DATE       
							,X.MES_UNHOLD_SCHD_DATE     AS MES_UNHOLD_SCHD_DATE
							,X.QMS_UNHOLD_SCHD_DATE     AS QMS_UNHOLD_SCHD_DATE
							,X.STORAGE_ID_MES           AS STORAGE_ID_MES      
							,X.STORAGE_ID_ERP           AS STORAGE_ID_ERP      
							,X.STOCK_STATUS             AS STOCK_STATUS        
							,X.STOCK_TYPE               AS STOCK_TYPE          
							,X.PROD_TYPE                AS PROD_TYPE           
							,X.DOMESTIC_TYPE            AS DOMESTIC_TYPE       
							,X.IF_ID                    AS CREATED_BY          
							,IF_RCV_DATE                AS CREATION_DATE       
							,X.IF_ID                    AS LAST_UPDATED_BY     
							,GETDATE()                  AS LAST_UPDATE_DATE  
							,X.IF_SEQ			        AS ATTRIBUTE1	
							,X.ATTRIBUTE2               AS ATTRIBUTE2  
							,X.ATTRIBUTE3               AS ATTRIBUTE3  
							,X.ATTRIBUTE4               AS ATTRIBUTE4  
							,X.ATTRIBUTE5               AS ATTRIBUTE5  
							,X.ATTRIBUTE6               AS ATTRIBUTE6  
							,X.ATTRIBUTE7               AS ATTRIBUTE7  
							,X.ATTRIBUTE8               AS ATTRIBUTE8  
							,X.ATTRIBUTE9               AS ATTRIBUTE9  
							,X.ATTRIBUTE10              AS ATTRIBUTE10   
						FROM XIF_MES_ISS_WAIT_PALLET_EE_R_SN X WITH(NOLOCK) 
						   JOIN SCM_MST_SITE S WITH(NOLOCK) 
							 ON S.PLANT_ID = X.PLANT_ID 
							AND S.SITE_TYPE = 'PLANT'
							AND S.OPERATION_GROUP = X.INSTANCE_TYPE -- A:조립 ,E:전극 
						WHERE ISNULL(X.PROC_FLAG,'N') = 'P' 
						AND   X.SUM_DATE   = CONVERT(CHAR(8), GETDATE(), 112)
						AND   X.ATTRIBUTE5 = @company_id
						AND   X.ATTRIBUTE6 <> '0'
						AND   X.IF_SEQ = @if_seq
					) F

					 ON F.DIVISION_ID   = M.DIVISION_ID       
					AND F.COMPANY_ID    = M.COMPANY_ID       
					AND F.FROM_SITE     = M.FROM_SITE      
					AND F.YYYYMMDD      = M.YYYYMMDD         
					AND F.INSTANCE_TYPE = M.INSTANCE_TYPE    
					AND F.PLANT_ID      = M.PLANT_ID         
					AND F.LOT_ID        = M.LOT_ID            
					AND F.ITEM_ID       = M.ITEM_ID         
					WHEN MATCHED THEN
					UPDATE
					SET 
						  M.MODEL_ID             =  F.MODEL_ID             
						, M.PRJT_NAME            =  F.PRJT_NAME            
						, M.NOW_FACTORY          =  F.NOW_FACTORY          
						, M.PROD_FACTORY         =  F.PROD_FACTORY         
						, M.ELECTRODE_VERSION    =  F.ELECTRODE_VERSION    
						, M.LANE                 =  F.LANE                 
						, M.UOM                  =  F.UOM                  
						, M.STOCK_QTY            =  F.STOCK_QTY            
						, M.STOCK_QTY_PC_M          =  F.STOCK_QTY_PC_M          
						, M.EXPIRATION_DATE      =  F.EXPIRATION_DATE      
						, M.COATING_PROD_DATE    =  F.COATING_PROD_DATE    
						, M.OPERATION_ID         =  F.OPERATION_ID         
						, M.LINE_ID              =  F.LINE_ID              
						, M.MES_HOLD             =  F.MES_HOLD             
						, M.QMS_HOLD             =  F.QMS_HOLD             
						, M.MES_HOLD_DATE        =  F.MES_HOLD_DATE        
						, M.QMS_HOLD_DATE        =  F.QMS_HOLD_DATE        
						, M.MES_UNHOLD_SCHD_DATE =  F.MES_UNHOLD_SCHD_DATE 
						, M.QMS_UNHOLD_SCHD_DATE =  F.QMS_UNHOLD_SCHD_DATE 
						, M.STORAGE_ID_MES       =  F.STORAGE_ID_MES       
						, M.STORAGE_ID_ERP       =  F.STORAGE_ID_ERP       
						, M.STOCK_STATUS         =  F.STOCK_STATUS         
						, M.STOCK_TYPE           =  F.STOCK_TYPE           
						, M.PROD_TYPE            =  F.PROD_TYPE            
						, M.DOMESTIC_TYPE        =  F.DOMESTIC_TYPE        
						, M.CREATED_BY           =  F.CREATED_BY           
						, M.CREATION_DATE        =  F.CREATION_DATE        
						, M.LAST_UPDATED_BY      =  F.LAST_UPDATED_BY      
						, M.LAST_UPDATE_DATE     =  F.LAST_UPDATE_DATE     
						, M.ATTRIBUTE1           =  F.ATTRIBUTE1           
						, M.ATTRIBUTE2           =  F.ATTRIBUTE2           
						, M.ATTRIBUTE3           =  F.ATTRIBUTE3           
						, M.ATTRIBUTE4           =  F.ATTRIBUTE4           
						, M.ATTRIBUTE5           =  F.ATTRIBUTE5           
						, M.ATTRIBUTE6           =  F.ATTRIBUTE6           
						, M.ATTRIBUTE7           =  F.ATTRIBUTE7           
						, M.ATTRIBUTE8           =  F.ATTRIBUTE8           
						, M.ATTRIBUTE9           =  F.ATTRIBUTE9           
						, M.ATTRIBUTE10          =  F.ATTRIBUTE10     
					WHEN NOT MATCHED THEN INSERT (
					 DIVISION_ID
					,COMPANY_ID
					,FROM_SITE
					,YYYYMMDD
					,INSTANCE_TYPE
					,PLANT_ID
					,LOT_ID
					,ITEM_ID
					,MODEL_ID
					,PRJT_NAME
					,NOW_FACTORY
					,PROD_FACTORY
					,ELECTRODE_VERSION
					,LANE
					,UOM
					,STOCK_QTY
					,STOCK_QTY_PC_M
					,EXPIRATION_DATE
					,COATING_PROD_DATE
					,OPERATION_ID
					,LINE_ID
					,MES_HOLD
					,QMS_HOLD
					,MES_HOLD_DATE
					,QMS_HOLD_DATE
					,MES_UNHOLD_SCHD_DATE
					,QMS_UNHOLD_SCHD_DATE
					,STORAGE_ID_MES
					,STORAGE_ID_ERP
					,STOCK_STATUS
					,STOCK_TYPE
					,PROD_TYPE
					,DOMESTIC_TYPE
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
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
					) 
					VALUES (
					 F.DIVISION_ID
					,F.COMPANY_ID
					,F.FROM_SITE
					,F.YYYYMMDD
					,F.INSTANCE_TYPE
					,F.PLANT_ID
					,F.LOT_ID
					,F.ITEM_ID
					,F.MODEL_ID
					,F.PRJT_NAME
					,F.NOW_FACTORY
					,F.PROD_FACTORY
					,F.ELECTRODE_VERSION
					,F.LANE
					,F.UOM
					,F.STOCK_QTY
					,F.STOCK_QTY_PC_M
					,F.EXPIRATION_DATE
					,F.COATING_PROD_DATE
					,F.OPERATION_ID
					,F.LINE_ID
					,F.MES_HOLD
					,F.QMS_HOLD
					,F.MES_HOLD_DATE
					,F.QMS_HOLD_DATE
					,F.MES_UNHOLD_SCHD_DATE
					,F.QMS_UNHOLD_SCHD_DATE
					,F.STORAGE_ID_MES
					,F.STORAGE_ID_ERP
					,F.STOCK_STATUS
					,F.STOCK_TYPE
					,F.PROD_TYPE
					,F.DOMESTIC_TYPE
					,F.CREATED_BY
					,F.CREATION_DATE
					,F.LAST_UPDATED_BY
					,F.LAST_UPDATE_DATE
					,F.ATTRIBUTE1
					,F.ATTRIBUTE2
					,F.ATTRIBUTE3
					,F.ATTRIBUTE4
					,F.ATTRIBUTE5
					,F.ATTRIBUTE6
					,F.ATTRIBUTE7
					,F.ATTRIBUTE8
					,F.ATTRIBUTE9
					,F.ATTRIBUTE10
					)
					;
		
					FETCH NEXT FROM CUR_MES_R INTO @if_seq  ; 

				END ;

				CLOSE CUR_MES_R; 
				DEALLOCATE CUR_MES_R;

				-- 인터페이스 테이블 처리 완료 UPDATE
				UPDATE XIF_MES_ISS_WAIT_PALLET_EE_R_SN 
				SET    PROC_FLAG             = 'Y'
				,      PROC_DATE             = GETDATE()   
				,      PROC_MSG              = 'S'
				WHERE  ISNULL(PROC_FLAG,'N') = 'P'
				AND    ATTRIBUTE5 = @company_id
				AND    SUM_DATE = CONVERT(CHAR(8), GETDATE(), 112)
				;

				UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
				SET    SEGMENT5 = CONVERT(CHAR(8), GETDATE(), 112)
					 , ATTRIBUTE1 = 'Y'
					 , LAST_UPDATED_BY = @v_batch_user
					 , LAST_UPDATE_DATE = GETDATE()
				WHERE  1 = 1
				AND    LOOKUP_TYPE = 'SSP_IF_STOCK_CHECK'
				AND    SEGMENT1 = 'PLAN_EE'
				AND    SEGMENT2 = 'MES'
				AND    SEGMENT3 = 'EE'
				AND    SEGMENT4 = @company_id
				--AND    SEGMENT5 = CONVERT(CHAR(8), GETDATE(), 112)
				AND    ATTRIBUTE1 = 'N'
				;
			END ;

			FETCH NEXT FROM CUR_MES_STOCK INTO @stock_cnt, 
											@company_id,
											@group_seq

		END; 

		CLOSE CUR_MES_STOCK; 
		DEALLOCATE CUR_MES_STOCK;

		-- IF data  삭제 (30일 이전 데이터 삭제) 
		DELETE 
		FROM  XIF_MES_ISS_WAIT_PALLET_EE_R_SN 
		WHERE IF_RCV_DATE < GETDATE() - 30
		;


		-- data  삭제 (3개월  이전 데이터 삭제) 
		DELETE 
		FROM  SSP_DNM_MES_STOCK_EE
		WHERE YYYYMMDD < CONVERT(VARCHAR, DATEADD(M, -3, GETDATE()) ,112)
		;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT TRAN TX_SH;
          END;       


        -- TXN LOG
        SET @v_log_type = N'TXN';    -- ▶ 로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;      

    END
    END TRY

    BEGIN CATCH
      IF @@TRANCOUNT > 0
        BEGIN
          ROLLBACK TRAN TX_SH

			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_MES_STOCK')
				BEGIN
				   CLOSE CUR_MES_STOCK ;
				   DEALLOCATE CUR_MES_STOCK ;
				END

			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_MES_R')
				BEGIN
				   CLOSE CUR_MES_R ;
				   DEALLOCATE CUR_MES_R ;
				END

        END;
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;
--      PRINT @@ERROR
      return -1
    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['+@v_program_name+'][' + @v_exec_time + ']';  
    SET @d_event_date = SYSDATETIME()  ;
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
