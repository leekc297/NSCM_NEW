



/*
 * Program ID   : [PR_SSP_XIF_OWMS_SHIP_RETURN_R]  
 * Description  : OWMS 반품정보 수신 I/F 수신 반영(Every 10 min) 
 * OutTable     : XIF_OWMS_SHIP_RETURN_R_SN --> SSP_DNM_SHIP_RETURN_OWMS 
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.08.21   ayj			   OWMS 반품정보 수신 I/F 수신 반영
 * 2020.06.16   LJH	           [PJ20199555]공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 
                               전극 추가 
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
 * 2024.08.01   SSP Pjt.       RECIEPT_QTY MAX->SUM 변환

*/

CREATE PROCEDURE [dbo].[PR_SSP_XIF_OWMS_SHIP_RETURN_R]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_XIF_OWMS_SHIP_RETURN_R';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_DNM_SHIP_RETURN_OWMS'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_DNM_SHIP_RETURN_OWMS INSERT LOGIC';
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

	DECLARE @v_count          INT  = 0 ;

	IF OBJECT_ID('tempdb..#tmp_XIF_OWMS_SHIP_RETURN_R') IS NOT NULL
		DROP TABLE #tmp_XIF_OWMS_SHIP_RETURN_R

	CREATE TABLE #tmp_XIF_OWMS_SHIP_RETURN_R (
		[IF_SEQ] [nvarchar](50) NOT NULL,
		[IF_TYPE] [nvarchar](1) NOT NULL,
		[IF_ID] [nvarchar](50) NOT NULL,
		[IF_RCV_DATE] [datetime] NOT NULL,
		[PROC_FLAG] [nvarchar](1) NOT NULL,
		[PROC_DATE] [datetime] NULL,
		[PROC_MSG] [nvarchar](1000) NULL,
		[DIVISION_ID] [nvarchar](30) NULL,
		[PLANT_ID] [nvarchar](40) NULL,
		[ITEM_ID] [nvarchar](20) NULL,
		[RECIEPT_DATE] [nvarchar](8) NULL,
		[DELIVERY_NO] [nvarchar](40) NULL,
		[PALLET_ID] [nvarchar](50) NULL,
		[GRADE] [nvarchar](40) NULL,
		[STORAGE_ID] [nvarchar](40) NULL,
		[RECIEPT_QTY] [numeric](20, 3) NULL,
		[CREATION_DATE] [datetime] NULL,
		[CREATED_BY] [nvarchar](150) NULL,
		[LAST_UPDATE_DATE] [datetime] NULL,
		[LAST_UPDATED_BY] [nvarchar](150) NULL,
		[ATTRIBUTE1] [nvarchar](150) NULL,
		[ATTRIBUTE2] [nvarchar](150) NULL,
		[ATTRIBUTE3] [nvarchar](150) NULL,
		[ATTRIBUTE4] [nvarchar](150) NULL,
		[ATTRIBUTE5] [nvarchar](150) NULL,
		[ATTRIBUTE6] [nvarchar](150) NULL,
		[ATTRIBUTE7] [nvarchar](150) NULL,
		[ATTRIBUTE8] [nvarchar](150) NULL,
		[ATTRIBUTE9] [nvarchar](150) NULL,
		[ATTRIBUTE10] [nvarchar](150) NULL
    );

    BEGIN TRY
    BEGIN
		BEGIN TRAN TX_SH

			INSERT INTO #tmp_XIF_OWMS_SHIP_RETURN_R
						([IF_SEQ]
						,[IF_TYPE]
						,[IF_ID]
						,[IF_RCV_DATE]
						,[PROC_FLAG]
						,[PROC_DATE]
						,[PROC_MSG]
						,[DIVISION_ID]
						,[PLANT_ID]
						,[ITEM_ID]
						,[RECIEPT_DATE]
						,[DELIVERY_NO]
						,[PALLET_ID]
						,[GRADE]
						,[STORAGE_ID]
						,[RECIEPT_QTY]
						,[CREATION_DATE]
						,[CREATED_BY]
						,[LAST_UPDATE_DATE]
						,[LAST_UPDATED_BY]
						,[ATTRIBUTE1]
						,[ATTRIBUTE2]
						,[ATTRIBUTE3]
						,[ATTRIBUTE4]
						,[ATTRIBUTE5]
						,[ATTRIBUTE6]
						,[ATTRIBUTE7]
						,[ATTRIBUTE8]
						,[ATTRIBUTE9]
						,[ATTRIBUTE10])
			      SELECT [IF_SEQ]
					    ,[IF_TYPE]
					    ,[IF_ID]
					    ,[IF_RCV_DATE]
					    ,[PROC_FLAG]
					    ,[PROC_DATE]
					    ,[PROC_MSG]
					    ,[dbo].[FN_GET_SSP_JV_DIVISION_ID](DIVISION_ID, PLANT_ID) AS DIVISION_ID
					    ,[PLANT_ID]
					    ,[ITEM_ID]
					    ,[RECIEPT_DATE]
					    ,[DELIVERY_NO]
					    ,[PALLET_ID]
					    ,[GRADE]
					    ,[STORAGE_ID]
					    ,[RECIEPT_QTY]
					    ,[CREATION_DATE]
					    ,[CREATED_BY]
					    ,[LAST_UPDATE_DATE]
					    ,[LAST_UPDATED_BY]
					    ,[ATTRIBUTE1]
					    ,[ATTRIBUTE2]
					    ,[ATTRIBUTE3]
					    ,[ATTRIBUTE4]
					    ,[ATTRIBUTE5]
					    ,[ATTRIBUTE6]
					    ,[ATTRIBUTE7]
					    ,[ATTRIBUTE8]
					    ,[ATTRIBUTE9]
					    ,[ATTRIBUTE10]
				    FROM [dbo].[XIF_OWMS_SHIP_RETURN_R_SN] WITH(NOLOCK)
		           WHERE ISNULL(PROC_FLAG,'N') = 'N'

		MERGE INTO SSP_DNM_SHIP_RETURN_OWMS C
		USING (
		       -- 전극의 경우 조립 PLANT에서 출하실적 발생(남경(CNA) 없는 사업부에서 출하실적발생 EX) 82, G451 
			  SELECT MAX(SN.DIVISION_ID)		AS DIVISION_ID
			        ,MAX(SN.FROM_SITE)			AS FROM_SITE
                    ,MAX(SN.PLANT_ID)			AS PLANT_ID
                    ,MAX(SN.ITEM_ID)			AS ITEM_ID
                    ,MAX(SN.RECIEPT_DATE)		AS RECIEPT_DATE
                    ,MAX(SN.DELIVERY_NO)		AS DELIVERY_NO
                    ,SN.PALLET_ID
                    ,SN.GRADE
                    ,MAX(SN.STORAGE_ID)			AS STORAGE_ID
                    ,SUM(SN.RECIEPT_QTY)		AS RECIEPT_QTY
                    ,MAX(SN.CREATION_DATE)		AS CREATION_DATE
                    ,MAX(SN.CREATED_BY)			AS CREATED_BY
                    ,MAX(SN.LAST_UPDATE_DATE)	AS LAST_UPDATE_DATE
                    ,MAX(SN.LAST_UPDATED_BY)	AS LAST_UPDATED_BY
                    ,MAX(SN.IF_ID)				AS IF_ID
                    ,MAX(SN.IF_SEQ)				AS IF_SEQ
                    ,MAX(SN.IF_RCV_DATE)		AS IF_RCV_DATE
                    ,MAX(SN.ATTRIBUTE1)			AS ATTRIBUTE1
                    ,MAX(SN.ATTRIBUTE2)			AS ATTRIBUTE2
                    ,MAX(SN.ATTRIBUTE3)			AS ATTRIBUTE3
                    ,MAX(SN.ATTRIBUTE4)			AS ATTRIBUTE4
                    ,MAX(SN.ATTRIBUTE5)			AS ATTRIBUTE5
                    ,MAX(SN.ATTRIBUTE6)			AS ATTRIBUTE6
                    ,MAX(SN.ATTRIBUTE7)			AS ATTRIBUTE7
                    ,MAX(SN.ATTRIBUTE8)			AS ATTRIBUTE8
                    ,MAX(SN.ATTRIBUTE9)			AS ATTRIBUTE9
                    ,MAX(SN.ATTRIBUTE10)		AS ATTRIBUTE10
			    FROM (
        		      SELECT 
                             X.DIVISION_ID
        				   , L.SEGMENT3        AS FROM_SITE
        				   , X.PLANT_ID
        				   , X.ITEM_ID
        				   , X.RECIEPT_DATE
        				   , X.DELIVERY_NO
        				   , X.PALLET_ID
        				   , X.GRADE
        				   , X.STORAGE_ID
        				   , X.RECIEPT_QTY
        				   , X.CREATION_DATE
        				   , X.CREATED_BY
        				   , X.LAST_UPDATE_DATE
        				   , X.LAST_UPDATED_BY
        				   , X.IF_ID
        				   , X.IF_SEQ
        				   , X.IF_RCV_DATE
        				   , X.ATTRIBUTE1
        				   , X.ATTRIBUTE2
        				   , X.ATTRIBUTE3
        				   , X.ATTRIBUTE4
        				   , X.ATTRIBUTE5
        				   , X.ATTRIBUTE6
        				   , X.ATTRIBUTE7
        				   , X.ATTRIBUTE8
        				   , X.ATTRIBUTE9
        				   , X.ATTRIBUTE10
        			    FROM #tmp_XIF_OWMS_SHIP_RETURN_R X WITH(NOLOCK) 
        				     JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS L WITH(NOLOCK) -- 해당 LOOKUP에 등록된 경우만 실적 적용 
        			       ON L.LOOKUP_TYPE		= 'ELECTRODE_OWMS_PLANT_MAPPING' 
        				  AND L.SEGMENT1		= X.DIVISION_ID  -- SEGMENT1: OWMS_DIVISION
        				  AND L.SEGMENT2		= X.PLANT_ID     -- SEGMENT2: OWMS_PLANT
        			    WHERE 1 = 1 
        				  AND X.ATTRIBUTE6 <> '0'
        			      AND [dbo].[FN_GET_ITEM_OPERATION_GROUP](X.DIVISION_ID, X.ITEM_ID) = 'E'  -- 전극 
        			  
        			    UNION ALL 
        
        			   SELECT X.DIVISION_ID
        				    , [dbo].[FN_GET_SCM_SITE_ID_PLANT](X.PLANT_ID, [dbo].[FN_GET_ITEM_OPERATION_GROUP](X.DIVISION_ID, X.ITEM_ID)) AS FROM_SITE
        				    , X.PLANT_ID
        				    , X.ITEM_ID
        				    , X.RECIEPT_DATE
        				    , X.DELIVERY_NO
        				    , X.PALLET_ID
        				    , X.GRADE
        				    , X.STORAGE_ID
        				    , X.RECIEPT_QTY
        				    , X.CREATION_DATE
        				    , X.CREATED_BY
        				    , X.LAST_UPDATE_DATE
        				    , X.LAST_UPDATED_BY
        				    , X.IF_ID
        				    , X.IF_SEQ
        				    , X.IF_RCV_DATE
        				    , X.ATTRIBUTE1
        				    , X.ATTRIBUTE2
        				    , X.ATTRIBUTE3
        				    , X.ATTRIBUTE4
        				    , X.ATTRIBUTE5
        				    , X.ATTRIBUTE6
        				    , X.ATTRIBUTE7
        				    , X.ATTRIBUTE8
        				    , X.ATTRIBUTE9
        				    , X.ATTRIBUTE10
        			     FROM #tmp_XIF_OWMS_SHIP_RETURN_R X WITH(NOLOCK) 
        			  		  JOIN SCM_MST_SITE AS B WITH(NOLOCK)
        			  	   ON [dbo].[FN_GET_SCM_SITE_ID_PLANT](X.PLANT_ID, [dbo].[FN_GET_ITEM_OPERATION_GROUP](X.DIVISION_ID, X.ITEM_ID)) = B.SCM_SITE_ID
        			    WHERE 1 = 1 
        				  AND X.ATTRIBUTE6 <> '0'
        			      AND [dbo].[FN_GET_ITEM_OPERATION_GROUP](X.DIVISION_ID, X.ITEM_ID) <> 'E' -- 전극 아닌경우 
        		  	      AND ([dbo].[FN_GET_SCM_SITE_ID_PLANT](X.PLANT_ID, [dbo].[FN_GET_ITEM_OPERATION_GROUP](X.DIVISION_ID, X.ITEM_ID))) IS NOT NULL
			         ) SN 
			   WHERE 1 = 1
			   GROUP BY 
			         SN.PALLET_ID
					,SN.GRADE
		      ) N
		   ON C.PALLET_ID	= N.PALLET_ID
		  AND C.GRADE		= N.GRADE	
		WHEN MATCHED THEN
		UPDATE
		   SET C.DIVISION_ID		= N.DIVISION_ID
		     , C.FROM_SITE			= N.FROM_SITE
		     , C.ITEM_ID			= N.ITEM_ID
		     , C.RECIEPT_DATE		= N.RECIEPT_DATE
		     , C.DELIVERY_NO		= N.DELIVERY_NO
		     , C.STORAGE_ID			= N.STORAGE_ID
		     , C.RECIEPT_QTY		= N.RECIEPT_QTY
		     , C.CREATION_DATE		= N.CREATION_DATE
		     , C.LAST_UPDATE_DATE	= N.IF_RCV_DATE
		     , C.ATTRIBUTE1			= N.IF_SEQ
		WHEN NOT MATCHED THEN
		INSERT ( 
		       DIVISION_ID
			 , FROM_SITE
			 , ITEM_ID
			 , RECIEPT_DATE
			 , DELIVERY_NO
			 , PALLET_ID
			 , GRADE
			 , STORAGE_ID
			 , RECIEPT_QTY
			 , CREATION_DATE
			 , CREATED_BY
			 , LAST_UPDATE_DATE
			 , LAST_UPDATED_BY
			 , ATTRIBUTE1
			 , ATTRIBUTE2
			 , ATTRIBUTE3
			 , ATTRIBUTE4
			 , ATTRIBUTE5
			 , ATTRIBUTE6
			 , ATTRIBUTE7
			 , ATTRIBUTE8
			 , ATTRIBUTE9
			 , ATTRIBUTE10
			   )
		VALUES (
			   N.DIVISION_ID
			 , N.FROM_SITE
			 , N.ITEM_ID
			 , N.RECIEPT_DATE
			 , N.DELIVERY_NO
			 , N.PALLET_ID
			 , N.GRADE
			 , N.STORAGE_ID
			 , N.RECIEPT_QTY
			 , N.CREATION_DATE   -- CREATION_DATE OWMS_CREATE DATE
			 , N.IF_ID    --CREATED_BY
			 , N.IF_RCV_DATE   -- LAST_UPDATE_DATE , 인터페이스 수신 시간  
			 , N.IF_ID     --LAST_UPDATED_BY
			 , N.IF_SEQ -- ATTRIBUTE1
			 , N.ATTRIBUTE2
			 , N.ATTRIBUTE3
			 , N.ATTRIBUTE4
			 , N.ATTRIBUTE5
			 , N.ATTRIBUTE6
			 , N.ATTRIBUTE7
			 , N.ATTRIBUTE8
			 , N.ATTRIBUTE9
			 , N.ATTRIBUTE10
		 );

		UPDATE S 
		   SET S.PROC_FLAG             = 'Y'
		     , S.PROC_DATE             = GETDATE()   
		     , S.PROC_MSG              = 'S'
		FROM XIF_OWMS_SHIP_RETURN_R_SN AS S WITH(NOLOCK)
		     JOIN #tmp_XIF_OWMS_SHIP_RETURN_R AS T
		  ON S.IF_SEQ = T.IF_SEQ

		-- IF data  삭제 (30일 이전 데이터 삭제) 
		DELETE  
		  FROM XIF_OWMS_SHIP_RETURN_R_SN 
		 WHERE IF_RCV_DATE < GETDATE() - 30
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
		IF OBJECT_ID('tempdb..#tmp_XIF_OWMS_SHIP_RETURN_R') IS NOT NULL
			DROP TABLE #tmp_XIF_OWMS_SHIP_RETURN_R

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

	IF OBJECT_ID('tempdb..#tmp_XIF_OWMS_SHIP_RETURN_R') IS NOT NULL
		DROP TABLE #tmp_XIF_OWMS_SHIP_RETURN_R
   
    return 1  

  END; 


