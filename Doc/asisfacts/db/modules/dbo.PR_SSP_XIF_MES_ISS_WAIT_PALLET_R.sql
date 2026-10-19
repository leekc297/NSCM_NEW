/*
 * Program ID   : PR_SSP_XIF_MES_ISS_WAIT_PALLET_R
 * Description  : MES 출하대기 LOT 재고 정보 I/F 수신 반영(Every 10 min) 자동차/ESS대상 
 * OutTable     : XIF_MES_ISS_WAIT_PALLET_R_SN --> SSP_DNM_MES_STOCK_81_82 
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.10.14   LJH         Initial Release [PJ20189106] 전지.GSCM 고도화 이행
 * 2021.02.16   KBK         MES I/F 재고 정보 확인 후 실행하도록 LOGIC 변경
 */

CREATE  PROCEDURE [dbo].[PR_SSP_XIF_MES_ISS_WAIT_PALLET_R]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_NULLS ON;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  
--    SET     @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_XIF_MES_ISS_WAIT_PALLET_R';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_DNM_MES_STOCK_81_82'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_DNM_MES_STOCK_81_82 INSERT LOGIC';
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
	DECLARE @v_cnt            INT  = 0 ;


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
						, A.COMPANY_ID + SUBSTRING(A.GROUP_SEQ, 1, 8)  AS GROUP_SEQ
				FROM   (
						SELECT A.ATTRIBUTE5  AS COMPANY_ID
							 , ISNULL(A.ATTRIBUTE7, CONVERT(CHAR(8), GETDATE(), 112))  AS GROUP_SEQ
							 , COUNT(*)  AS IF_CNT
						--FROM   [10.34.220.88,7433].[LGCE_INF].[dbo].[XIF_MES_ISS_WAIT_PALLET_R]  A WITH(NOLOCK)
						FROM   XIF_MES_ISS_WAIT_PALLET_R_SN  A WITH(NOLOCK)
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
								--FROM   [10.34.220.88,7433].[LGCE_INF].[dbo].[XIF_MES_ISS_WAIT_PALLET_R]  A WITH(NOLOCK)
								FROM   XIF_MES_ISS_WAIT_PALLET_R_SN  A WITH(NOLOCK)
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
		GROUP BY A.COMPANY_ID, A.GROUP_SEQ
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
			AND    A.SEGMENT1 = 'PLAN_AUTO'
			AND    A.SEGMENT2 = 'MES_W'
			AND    A.SEGMENT3 = '81_82'
			AND    A.SEGMENT4 = @company_id
			AND    A.SEGMENT5 = CONVERT(CHAR(8), GETDATE(), 112)
			AND    A.ATTRIBUTE1 = 'Y'
			;

--PRINT(N'1 === ' + @company_id + ' : ' +  CONVERT(NVARCHAR, @stock_cnt) + ' : ' + CONVERT(NVARCHAR, @v_count) )

			IF @stock_cnt = 0 AND @v_count = 0
			BEGIN
				UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
				SET    SEGMENT5 = CONVERT(CHAR(8), GETDATE(), 112)
						, ATTRIBUTE1 = 'N'
				WHERE  1 = 1
				AND    LOOKUP_TYPE = 'SSP_IF_STOCK_CHECK'
				AND    SEGMENT1 = 'PLAN_AUTO'
				AND    SEGMENT2 = 'MES_W'
				AND    SEGMENT3 = '81_82'
				AND    SEGMENT4 = @company_id
				--AND    SEGMENT5 = CONVERT(CHAR(8), GETDATE(), 112)
				--AND    ATTRIBUTE1 = 'N'
				;

				-- 인터페이스 테이블 처리 ROW UPDATE
				-- 2020.08.27  현업 요구사항으로 LOGIC 변경
				UPDATE A 
				SET    A.PROC_FLAG             = 'P'
				FROM   XIF_MES_ISS_WAIT_PALLET_R_SN  A WITH(NOLOCK)
					   LEFT OUTER JOIN SCM_MST_FACTORY_SN  B WITH(NOLOCK)
					   ON   B.PLANT_ID   = A.PLANT_ID
					   AND  B.FACTORY_ID = A.AREAID 
				WHERE  ISNULL(A.PROC_FLAG,'N') = 'N'
				AND    A.SUM_DATE = CONVERT(CHAR(8), GETDATE(), 112)
				AND    A.ATTRIBUTE5 = @company_id
				--AND    A.ATTRIBUTE7 = @group_seq
				AND    B.DIVISION_ID <> '40'
				;  

				--CURSOR 선언 
				DECLARE @if_seq VARCHAR(MAX)
				DECLARE @idx2 INT     SET     @idx2 = 0  
 

				DECLARE CUR_MES_R CURSOR FOR  

				-- 2020.08.27  현업 요구사항으로 LOGIC 변경
				SELECT A.IF_SEQ
				FROM   XIF_MES_ISS_WAIT_PALLET_R_SN  A WITH(NOLOCK) 
					   LEFT OUTER JOIN SCM_MST_FACTORY_SN  B WITH(NOLOCK)
					   ON   B.PLANT_ID   = A.PLANT_ID
					   AND  B.FACTORY_ID = A.AREAID 
				WHERE  ISNULL(A.PROC_FLAG,'N') = 'P'
				AND    A.SUM_DATE = CONVERT(CHAR(8), GETDATE(), 112)
				AND    A.ATTRIBUTE5 = @company_id
				--AND    A.ATTRIBUTE7 = @group_seq
				AND    B.DIVISION_ID <> '40'
				ORDER BY A.IF_SEQ
				;

		
				OPEN CUR_MES_R; 

				FETCH NEXT FROM CUR_MES_R INTO @if_seq

				WHILE(@@FETCH_STATUS = 0) 

				BEGIN
					--Idx2 1씩 증가 
					--SET @idx2 = @idx2 + 1 

					PRINT @if_seq ;

					MERGE INTO SSP_DNM_MES_STOCK_81_82 M
					USING (
						  SELECT 
							 F.DIVISION_ID  AS DIVISION_ID 
							,F.COMPANY_ID   AS COMPANY_ID 
							,[dbo].[FN_GET_SCM_SITE_ID_PLANT](F.PLANT_ID, [dbo].[FN_GET_ITEM_OPERATION_GROUP](F.DIVISION_ID, SN.PRODID)) AS FROM_SITE 
							,CASE WHEN OQC_INSP_RESULT ='Y' AND QMS_HOLD_YN ='N' AND MES_HOLD_YN ='N' THEN 'Y' ELSE 'N' END AS AVAILABLE_YN 
							,SN.SUM_DATE    AS YYYYMMDD
							,SN.PLANT_ID
							,SN.AREAID
							,SN.EQSGID
							,SN.EQSGNAME
							,SN.BOXID
							,SN.MDLLOT_ID
							,SN.PRODID   AS ITEM_ID
							,SN.PRODNAME
							,SN.PRJT_NAME
							,SN.TOTAL_QTY
							,SN.RCV_ISS_STAT_CODE
							,SN.RCV_ISS_STAT_NAME
							,SN.SHIPTO_ID
							,SN.SHIPTO_NAME
							,SN.PACK_NOTE
							,SN.OQC_INSP_RESULT
							,SN.LOTID
							,SN.LOT_QTY
							,SN.PROD_DATE
							,SN.PROD_VALID_DATE
							,SN.EXP_INSP_JUDGE_DATE
							,SN.EXP_INSP_VALID_DATE
							,SN.EXP_INSP_RESULT
							,SN.PROD_INSP_RESULT
							,SN.MEASR_INSP_RESULT
							,SN.LOW_VOLT_INSP_RESULT
							,SN.MES_HOLD_YN
							,SN.QMS_HOLD_YN
							,SN.SUBLOT_HOLD_YN
							,SN.PACK_HOLD_YN
							,SN.RTN_RCV_FLAG
							,SN.RCV_BOXSTAT_NAME
							,SN.MES_HOLD_RELEASE
							,SN.QMS_HOLD_RELEASE
							,GETDATE()     AS CREATION_DATE 
							,'MES I/F'     AS CREATED_BY
							,GETDATE()     AS LAST_UPDATE_DATE  
							,'MES I/F'     AS LAST_UPDATED_BY
							,SN.ATTRIBUTE1 AS ATTRIBUTE1  -- MES공정번호
							,SN.ATTRIBUTE2
							,SN.ATTRIBUTE3
							,SN.ATTRIBUTE4
							,SN.ATTRIBUTE5
							,SN.ATTRIBUTE6
							,SN.ATTRIBUTE7
							,SN.ATTRIBUTE8
							,SN.ATTRIBUTE9
							,SN.IF_SEQ      AS ATTRIBUTE10
						FROM XIF_MES_ISS_WAIT_PALLET_R_SN SN WITH(NOLOCK) 
							 JOIN SCM_MST_FACTORY_SN F WITH(NOLOCK) 
							   ON F.PLANT_ID   = SN.PLANT_ID
							  AND F.FACTORY_ID = SN.AREAID 
							  AND SN.IF_SEQ = @if_seq
						WHERE SN.ATTRIBUTE5 = @company_id
						AND   SN.ATTRIBUTE6 <> '0'
						--AND   SN.ATTRIBUTE7 = @group_seq
						AND   SN.PROC_FLAG   = 'P'
						AND   F.DIVISION_ID <> '40'
						AND   SN.SUM_DATE = CONVERT(CHAR(8), GETDATE(), 112)
					  )  N 
					   ON  M.DIVISION_ID = N.DIVISION_ID
					  AND  M.COMPANY_ID	 = N.COMPANY_ID
					  AND  M.FROM_SITE	 = N.FROM_SITE
					  AND  M.YYYYMMDD	 = N.YYYYMMDD
					  AND  M.BOXID	     = N.BOXID
					  AND  M.ITEM_ID	 = N.ITEM_ID
					  AND  M.LOTID	     = N.LOTID
					WHEN MATCHED THEN
					UPDATE
					SET  M.AVAILABLE_YN         = N.AVAILABLE_YN         
						,M.PLANT_ID             = N.PLANT_ID             
						,M.AREAID               = N.AREAID               
						,M.EQSGID               = N.EQSGID               
						,M.EQSGNAME             = N.EQSGNAME             
						,M.MDLLOT_ID            = N.MDLLOT_ID            
						,M.PRODNAME             = N.PRODNAME             
						,M.PRJT_NAME            = N.PRJT_NAME            
						,M.TOTAL_QTY            = N.TOTAL_QTY            
						,M.RCV_ISS_STAT_CODE    = N.RCV_ISS_STAT_CODE    
						,M.RCV_ISS_STAT_NAME    = N.RCV_ISS_STAT_NAME    
						,M.SHIPTO_ID            = N.SHIPTO_ID            
						,M.SHIPTO_NAME          = N.SHIPTO_NAME          
						,M.PACK_NOTE            = N.PACK_NOTE            
						,M.OQC_INSP_RESULT      = N.OQC_INSP_RESULT      
						,M.LOT_QTY              = N.LOT_QTY              
						,M.PROD_DATE            = N.PROD_DATE            
						,M.PROD_VALID_DATE      = N.PROD_VALID_DATE      
						,M.EXP_INSP_JUDGE_DATE  = N.EXP_INSP_JUDGE_DATE  
						,M.EXP_INSP_VALID_DATE  = N.EXP_INSP_VALID_DATE  
						,M.EXP_INSP_RESULT      = N.EXP_INSP_RESULT      
						,M.PROD_INSP_RESULT     = N.PROD_INSP_RESULT     
						,M.MEASR_INSP_RESULT    = N.MEASR_INSP_RESULT    
						,M.LOW_VOLT_INSP_RESULT = N.LOW_VOLT_INSP_RESULT 
						,M.MES_HOLD_YN          = N.MES_HOLD_YN          
						,M.QMS_HOLD_YN          = N.QMS_HOLD_YN          
						,M.SUBLOT_HOLD_YN       = N.SUBLOT_HOLD_YN       
						,M.PACK_HOLD_YN         = N.PACK_HOLD_YN         
						,M.RTN_RCV_FLAG         = N.RTN_RCV_FLAG         
						,M.RCV_BOXSTAT_NAME     = N.RCV_BOXSTAT_NAME     
						,M.MES_HOLD_RELEASE     = N.MES_HOLD_RELEASE     
						,M.QMS_HOLD_RELEASE     = N.QMS_HOLD_RELEASE   
						,M.CREATION_DATE	    = N.CREATION_DATE 
						,M.CREATED_BY           = N.CREATED_BY
						,M.LAST_UPDATE_DATE     = N.LAST_UPDATE_DATE  
						,M.LAST_UPDATED_BY      = N.LAST_UPDATED_BY
						,M.ATTRIBUTE1			= N.ATTRIBUTE1     -- ATTRIBUTE1
						,M.ATTRIBUTE2           = N.ATTRIBUTE2           
						,M.ATTRIBUTE3           = N.ATTRIBUTE3           
						,M.ATTRIBUTE4           = N.ATTRIBUTE4           
						,M.ATTRIBUTE5           = N.ATTRIBUTE5           
						,M.ATTRIBUTE6           = N.ATTRIBUTE6           
						,M.ATTRIBUTE7           = N.ATTRIBUTE7           
						,M.ATTRIBUTE8           = N.ATTRIBUTE8           
						,M.ATTRIBUTE9           = N.ATTRIBUTE9           
						,M.ATTRIBUTE10          = N.ATTRIBUTE10          
					WHEN NOT MATCHED THEN
					INSERT ( 
							 DIVISION_ID
							,COMPANY_ID
							,FROM_SITE
							,AVAILABLE_YN
							,YYYYMMDD
							,PLANT_ID
							,AREAID
							,EQSGID
							,EQSGNAME
							,BOXID
							,MDLLOT_ID
							,ITEM_ID
							,PRODNAME
							,PRJT_NAME
							,TOTAL_QTY
							,RCV_ISS_STAT_CODE
							,RCV_ISS_STAT_NAME
							,SHIPTO_ID
							,SHIPTO_NAME
							,PACK_NOTE
							,OQC_INSP_RESULT
							,LOTID
							,LOT_QTY
							,PROD_DATE
							,PROD_VALID_DATE
							,EXP_INSP_JUDGE_DATE
							,EXP_INSP_VALID_DATE
							,EXP_INSP_RESULT
							,PROD_INSP_RESULT
							,MEASR_INSP_RESULT
							,LOW_VOLT_INSP_RESULT
							,MES_HOLD_YN
							,QMS_HOLD_YN
							,SUBLOT_HOLD_YN
							,PACK_HOLD_YN
							,RTN_RCV_FLAG
							,RCV_BOXSTAT_NAME
							,MES_HOLD_RELEASE
							,QMS_HOLD_RELEASE
							,CREATION_DATE 
							,CREATED_BY
							,LAST_UPDATE_DATE  
							,LAST_UPDATED_BY
							,ATTRIBUTE1  --MES공정번호
							,ATTRIBUTE2
							,ATTRIBUTE3
							,ATTRIBUTE4
							,ATTRIBUTE5
							,ATTRIBUTE6
							,ATTRIBUTE7
							,ATTRIBUTE8
							,ATTRIBUTE9
							,ATTRIBUTE10 -- IF_SEQ
						   )
					 VALUES (
							 N.DIVISION_ID
							,N.COMPANY_ID
							,N.FROM_SITE
							,N.AVAILABLE_YN
							,N.YYYYMMDD
							,N.PLANT_ID
							,N.AREAID
							,N.EQSGID
							,N.EQSGNAME
							,N.BOXID
							,N.MDLLOT_ID
							,N.ITEM_ID
							,N.PRODNAME
							,N.PRJT_NAME
							,N.TOTAL_QTY
							,N.RCV_ISS_STAT_CODE
							,N.RCV_ISS_STAT_NAME
							,N.SHIPTO_ID
							,N.SHIPTO_NAME
							,N.PACK_NOTE
							,N.OQC_INSP_RESULT
							,N.LOTID
							,N.LOT_QTY
							,N.PROD_DATE
							,N.PROD_VALID_DATE
							,N.EXP_INSP_JUDGE_DATE
							,N.EXP_INSP_VALID_DATE
							,N.EXP_INSP_RESULT
							,N.PROD_INSP_RESULT
							,N.MEASR_INSP_RESULT
							,N.LOW_VOLT_INSP_RESULT
							,N.MES_HOLD_YN
							,N.QMS_HOLD_YN
							,N.SUBLOT_HOLD_YN
							,N.PACK_HOLD_YN
							,N.RTN_RCV_FLAG
							,N.RCV_BOXSTAT_NAME
							,N.MES_HOLD_RELEASE
							,N.QMS_HOLD_RELEASE
							,N.CREATION_DATE 
							,N.CREATED_BY
							,LAST_UPDATE_DATE  
							,LAST_UPDATED_BY
							,N.ATTRIBUTE1   --IF_SEQ
							,N.ATTRIBUTE2
							,N.ATTRIBUTE3
							,N.ATTRIBUTE4
							,N.ATTRIBUTE5
							,N.ATTRIBUTE6
							,N.ATTRIBUTE7
							,N.ATTRIBUTE8
							,N.ATTRIBUTE9
							,N.ATTRIBUTE10
					 );

					FETCH NEXT FROM CUR_MES_R INTO @if_seq  ; 

				END ;

				CLOSE CUR_MES_R; 
				DEALLOCATE CUR_MES_R;

				-- 인터페이스 테이블 처리 완료 UPDATE
				UPDATE A
				SET    A.PROC_FLAG             = 'Y'
				,      A.PROC_DATE             = GETDATE()   
				,      A.PROC_MSG              = 'S'
				FROM   XIF_MES_ISS_WAIT_PALLET_R_SN  A WITH(NOLOCK)
					   LEFT OUTER JOIN SCM_MST_FACTORY_SN  B WITH(NOLOCK)
					   ON   B.PLANT_ID   = A.PLANT_ID
					   AND  B.FACTORY_ID = A.AREAID 
				WHERE  ISNULL(A.PROC_FLAG,'N') = 'P'
				AND    A.ATTRIBUTE5 = @company_id
				--AND    A.ATTRIBUTE7 = @group_seq
				AND    B.DIVISION_ID <> '40'
				AND    A.SUM_DATE = CONVERT(CHAR(8), GETDATE(), 112)
				;  

				IF [dbo].[FN_GET_SSP_IF_STOCK_CHECK_YN](@company_id, CONVERT(CHAR(8), getdate(), 112)) = 'Y'
				BEGIN

					UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
					   SET SEGMENT5 = CONVERT(CHAR(8), GETDATE(), 112)
						 , ATTRIBUTE1 = 'Y'
						 , LAST_UPDATED_BY = @v_batch_user
						 , LAST_UPDATE_DATE = GETDATE()
					 WHERE 1 = 1
					   AND LOOKUP_TYPE = 'SSP_IF_STOCK_CHECK'
					   AND SEGMENT1 = 'PLAN_AUTO'
					   AND SEGMENT2 = 'MES_W'
					   AND SEGMENT3 = '81_82'
					   AND SEGMENT4 = @company_id
					   AND ATTRIBUTE1 = 'N'

				END

			END;

			FETCH NEXT FROM CUR_MES_STOCK INTO @stock_cnt, 
											@company_id,
											@group_seq
	

--PRINT(N'2 === ' + @company_id + ' : ' +  CONVERT(NVARCHAR, @stock_cnt) + ' : ' + CONVERT(NVARCHAR, @v_count) )
		END; 

		CLOSE CUR_MES_STOCK; 
		DEALLOCATE CUR_MES_STOCK;

		-- IF data  삭제 (30일 이전 데이터 삭제) 
		DELETE 
		FROM  XIF_MES_ISS_WAIT_PALLET_R_SN 
		WHERE IF_RCV_DATE < GETDATE() - 30
		;

		-- data  삭제 (3개월  이전 데이터 삭제) 
		DELETE 
		FROM  SSP_DNM_MES_STOCK_81_82 
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
