
/*
 * Program ID   : PR_SCM_DNM_INTRANSIT_CONSIGN_OFFSET
 * Description  :In Transit 재고 중 RESULT_TYPE = 'I', CUSTOMER_CONSIGN 수량 중 재고 CUTOFF 이후 과거 일자로 출고된 수량을 이동 중 재고에서 제거
 * Program History
 * 
 *===================================================================================================
 *   Date        In Charge     Description
 *===================================================================================================
 * 2025.04.02	 kimcd     	    PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - 이동 중 재고에서 매출 실적 제거
 ----------------------------------------------------------------------------------------------------
 */

CREATE PROCEDURE [dbo].[PR_SCM_DNM_INTRANSIT_CONSIGN_OFFSET]
(
	@P_ISSUE_DATE         NVARCHAR(8)=NULL
)
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = 'PR_SCM_DNM_INTRANSIT_CONSIGN_OFFSET';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_INTRANSIT_CONSIGN_OFFSET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno      NVARCHAR(30); 
	DECLARE @n_history_seq	BIGINT;
	DECLARE @V_ISSUE_DATE   NVARCHAR(8)=NULL; 
	DECLARE @v_check_flag   NVARCHAR(10);
    DECLARE @n_check_time   INTEGER = 0;
	DECLARE @rows           INT;

    -- 년월일 표시형태 변수 설정
    DECLARE @v_date_format  VARCHAR(10) = 'yyyyMMdd';
	DECLARE @PLANT_ID       NVARCHAR(30);
    DECLARE @ITEM_ID        NVARCHAR(50);
	DECLARE @ORIGIN_ITEM_ID NVARCHAR(50);
	DECLARE @SHIPMENT_NO    NVARCHAR(20);
	DECLARE @SALES_QTY      NUMERIC(20,10);
	DECLARE @CUSTOMER_CODE  NVARCHAR(50);
	DECLARE @SHIPTO_CODE    NVARCHAR(50);
	DECLARE @C_COMPANY_ID   NVARCHAR(30);
	DECLARE @C_DIVISION_ID  NVARCHAR(30);
	DECLARE @C_PROJECT_CODE NVARCHAR(50);
	DECLARE @C_PLANT_ISSUE_DATE NVARCHAR(8);
	DECLARE @C_INCOTERMS    NVARCHAR(10);
	DECLARE @C_FCST_TYPE    NVARCHAR(20);
	DECLARE @C_DELIVERY_QTY NUMERIC(20,10);
	DECLARE @C_FINAL_SOLDTO_CODE NVARCHAR(30); 
	DECLARE @C_SALES_ORDER_NO NVARCHAR(30);
	DECLARE @C_SALES_ORDER_SEQ NVARCHAR(30);
	DECLARE @C_QTY          NUMERIC(20,10);

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @d_event_date = SYSDATETIME();

    BEGIN TRY
	IF @P_ISSUE_DATE IS NULL OR ISDATE(@P_ISSUE_DATE) != 1
	    SET @V_ISSUE_DATE = CONVERT(CHAR(8), DATEADD(day,-1,GETDATE()), 112)
	ELSE
	    SET @V_ISSUE_DATE = CONVERT(CHAR(8), DATEADD(day,-1,@P_ISSUE_DATE), 112)
	
    SET @v_description = CONCAT('@P_ISSUE_DATE : ', @P_ISSUE_DATE);
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    -- SCP PR_SCM_DNM_INTRANSIT_CUTOFF 작업 수행 점검
    SET @v_check_flag = 'R';
    SET @n_check_time = 0;
	
    WHILE(@v_check_flag = 'R')
        BEGIN
	      WAITFOR DELAY '0:0:10'; -- 10초 Delay
	  	  
          -- PR_SCM_DNM_INTRANSIT_CUTOFF 종료 확인
          SELECT TOP 1 @v_check_flag = 'C'
	      FROM   SCM_SYS_LOG_BATCH T WITH(NOLOCK)
          WHERE  T.PROGRAM_NAME  = 'PR_SCM_DNM_INTRANSIT_CUTOFF'
	      AND    DATEPART(WEEKDAY, CONVERT(DATE, GETDATE() )) = 2 -- 월요일
	      AND    T.EVENT_DATE   >= CONVERT(DATETIME, CONVERT(NVARCHAR(10),GETDATE(), 120) + ' 23:00:00', 120)
	      AND    T.LOG_TYPE      = 'END'
          ORDER BY T.EVENT_DATE DESC, T.LOG_TYPE;

	      SET @n_check_time = @n_check_time + 10; -- 10초 Delay

	      IF @n_check_time = 1200 -- 20분
	        BREAK;
        END;

	    -- PR_SCM_DNM_INTRANSIT_CUTOFF 미완료
	IF @v_check_flag = 'R'
        BEGIN
          -- ERROR LOG
          SET @v_log_type = 'ERROR';
          SET @v_log_message = N'SCP Check PR_SCM_DNM_INTRANSIT_CUTOFF 수신 작업 미완료... ' + ISNULL(CAST(ERROR_MESSAGE() AS NVARCHAR(1000)), '');
          SET @v_description = N'SCP Check PR_SCM_DNM_INTRANSIT_CUTOFF 수신 작업 미완료... ' ;
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;    

          SET @rows = -1;
          GOTO _RETURN_ERR_CODE

          RETURN -1;
        END;

    SET @v_log_type = 'TXN';
    SET @n_log_count = @@ROWCOUNT;
    SET @v_log_message = 'SCP PR_SCM_DNM_INTRANSIT_CUTOFF Check';
    SET @v_description = 'SCP PR_SCM_DNM_INTRANSIT_CUTOFF Check End' ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    -- DM 수신 작업 수행 점검
    SET @v_check_flag = 'R';
    SET @n_check_time = 0;
	
    WHILE(@v_check_flag = 'R')
        BEGIN
	      WAITFOR DELAY '0:0:10'; -- 10초 Delay
	  	  
          -- PR_DM_DNM_SALES_RESULT_IF 종료 확인
          SELECT TOP 1 @v_check_flag = 'C'
	      FROM   SCM_SYS_LOG_BATCH T WITH(NOLOCK)
          WHERE  T.PROGRAM_NAME  = 'PR_DM_DNM_SALES_RESULT_IF'
	      AND    DATEPART(WEEKDAY, CONVERT(DATE, GETDATE() )) = 2 -- 월요일
	      AND    T.EVENT_DATE   >= CONVERT(DATETIME, CONVERT(NVARCHAR(10),GETDATE(), 120) + ' 23:00:00', 120)
	      AND    T.LOG_TYPE      = 'END'
          ORDER BY T.EVENT_DATE DESC, T.LOG_TYPE;

	      SET @n_check_time = @n_check_time + 10; -- 10초 Delay

	      IF @n_check_time = 1200 -- 20분
	        BREAK;
        END;

	    -- DM 수신 작업 미완료
	IF @v_check_flag = 'R'
        BEGIN
          -- ERROR LOG
          SET @v_log_type = 'ERROR';
          SET @v_log_message = N'DM Check DNM_SALES_RESULT_IF 수신 작업 미완료... ' + ISNULL(CAST(ERROR_MESSAGE() AS NVARCHAR(1000)), '');
          SET @v_description = N'DM Check DNM_SALES_RESULT_IF 수신 작업 미완료... ' ;
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;    

          SET @rows = -1;
          GOTO _RETURN_ERR_CODE

          RETURN -1;
        END;

    SET @v_log_type = 'TXN';
    SET @n_log_count = @@ROWCOUNT;
    SET @v_log_message = 'DM SALES RESULT Check';
    SET @v_description = 'DM SALES RESULT Check End' ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	

	IF OBJECT_ID('dbo.XIF_ERP_SALES_RESULT_R_OFFSET_TEMP$') IS NOT NULL DROP TABLE dbo.XIF_ERP_SALES_RESULT_R_OFFSET_TEMP$;

	WITH P_TIME AS (SELECT P.DIVISION_ID
	                      ,P.PLANT_ID
	                      ,REPLACE(SUBSTRING(CONVERT(NVARCHAR(20)
						                            ,DATEADD( MINUTE
						                                     ,DATEDIFF(minute,[dbo].[FN_SITE_TIME_SN] (P.SITE_ID), GETDATE())
						                                     ,CONVERT(DATETIME, CONVERT(NVARCHAR(10), GETDATE(), 120) + ' ' + STUFF(STUFF(VF.SEGMENT2, 3, 0, ':'), 6,0,':'), 120))
						                            ,120)
										    , 12,8)
								  ,':','')   AS TT
	                FROM   [SCM_ADM_LOOKUP_VALUE_FP_SN]     VF WITH(NOLOCK)
					       INNER JOIN [SCM_MST_PLANT_SN]    P  WITH(NOLOCK)
						   ON  VF.SEGMENT1       = P.PLANT_ID
					WHERE  VF.[LOOKUP_TYPE_CODE] = 'BASIS_START_TIME_PLANT'
					AND    VF.[ACTIVE_FLAG]      = 'Y')
	   , R_TIME AS ( SELECT MD.SEGMENT1 AS DIVISION_ID, MD.ATTRIBUTE1 + '00' AS R_TIME
	                 FROM   SCM_ADM_LOOKUP_MASTER_DETAIL  MD WITH(NOLOCK)
					 WHERE  MD.LOOKUP_TYPE = 'SALES_RESULT_OFFSET_TIME'
					 AND    MD.VALID_YN    = 'Y' )
    SELECT A.PLANT_ID
		  ,A.ITEM_ID AS ORIGIN_ITEM_ID
		  ,dbo.FN_GET_PACKER_PLAN_ITEM_ID(A.DIVISION_ID, A.ITEM_ID) AS ITEM_ID
		  ,CASE WHEN B.AS_ITEM IS NOT NULL AND A.SALES_QTY = 0 AND ISNUMERIC(A.ATTRIBUTE2) > 0 THEN CAST(A.ATTRIBUTE2 AS NUMERIC(20,10))
				ELSE A.SALES_QTY
				END  AS SALES_QTY
		  ,A.CUSTOMER_CODE
	      ,A.SHIPTO_CODE  
		  ,CASE WHEN A.TKNUM IS NOT NULL AND A.TKNUM != '' THEN REPLICATE('0', 10-LEN(RTRIM(A.TKNUM))) + RTRIM(A.TKNUM) END     AS SHIPMENT_NO
		  ,A.INCOTERMS
		  ,A.SALES_TYPE
	      ,SALES_POSTING_DATE, SYSTEM_INPUT_DATE, SYSTEM_INPUT_TIME		
	INTO   dbo.XIF_ERP_SALES_RESULT_R_OFFSET_TEMP$
	FROM   XIF_ERP_SALES_RESULT_R_SN A WITH(NOLOCK)
	       INNER JOIN P_TIME P
		       ON P.PLANT_ID = A.PLANT_ID
	       INNER JOIN R_TIME R
		       ON P.DIVISION_ID = R.DIVISION_ID
	   		LEFT OUTER JOIN (	SELECT DISTINCT SEGMENT2 AS AS_ITEM
							    FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)  
							    WHERE LOOKUP_TYPE	= N'DM_R_ITEM_ID'
								AND VALID_YN		= N'Y'
							    UNION 
							    SELECT DISTINCT SEGMENT3 AS AS_ITEM
							    FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)  
							    WHERE LOOKUP_TYPE	= N'DM_R_ITEM_ID'
								AND VALID_YN		= N'Y'
							    )  B ON A.ITEM_ID = B.AS_ITEM
	WHERE 1=1	
	AND A.SYSTEM_INPUT_DATE >= CONVERT(NVARCHAR(8),GETDATE(), 112)
	AND A.SALES_POSTING_DATE < CONVERT(NVARCHAR(8),GETDATE(), 112)
	AND A.SYSTEM_INPUT_TIME  > P.TT
	AND A.SYSTEM_INPUT_TIME  < R.R_TIME
	AND A.IFSEQNO = (SELECT MAX(IFSEQNO) AS IFSEQNO 
	                 FROM   XIF_ERP_SALES_RESULT_R_SN WITH(NOLOCK)		
                     WHERE  TRANSFER_DATE = CONVERT(NVARCHAR(8),GETDATE(), 112) )
    AND A.TRANSFER_DATE = CONVERT(NVARCHAR(8),GETDATE(), 112)
	AND A.SALES_TYPE IN ( 'ZEX', 'ZKN', 'ZOR' );

	IF OBJECT_ID('dbo.scm_dnm_intransit_c_OFFSET_temp$') IS NOT NULL DROP TABLE scm_dnm_intransit_c_OFFSET_temp$

	SELECT DISTINCT C.[RESULT_DATE],C.[RESULT_TYPE],C.[COMPANY_ID],C.[DIVISION_ID],C.[PLANT_ID],C.[SHIPMENT_NO],C.[PROJECT_CODE]
      ,C.[ITEM_ID],C.[PLANT_ISSUE_DATE],C.[INCOTERMS],C.[FCST_TYPE],C.[DOM_EXP],C.[CUSTOMER_CODE],C.[SHIPTO_CODE],C.[FROM_SCM_SITE_ID]
      ,C.[FROM_SITE_ITEM_MAPPING_YN],C.[TO_SCM_SITE_ID],C.[TO_SITE_ITEM_MAPPING_YN],CONVERT(NUMERIC(20,10),C.[ATTRIBUTE4]) AS [DELIVERY_QTY]
	  ,C.[UOM],C.[TRANSPORT_MODE],C.[SHIPPING_DATE],C.[POL],C.[POL_ATD_DATE],C.[POD],C.[POD_ETA_DATE],C.[POD_ATA_DATE],C.[POD_ETD_DATE],C.[POD_ATD_DATE]
      ,C.[F_DEST_PORT_CODE],C.[F_DEST_ETA_DATE],C.[F_DEST_ATA_DATE],C.[VALID_YN],C.[CREATED_BY],C.[CREATION_DATE],C.[LAST_UPDATED_BY]
      ,C.[LAST_UPDATE_DATE],C.[ATTRIBUTE1],C.[ATTRIBUTE2],C.[ATTRIBUTE3],C.[ATTRIBUTE4],C.[ATTRIBUTE5],C.[ATTRIBUTE6],C.[ATTRIBUTE7]
      ,C.[ATTRIBUTE8],C.[ATTRIBUTE9],C.[ATTRIBUTE10],C.[FINAL_SOLDTO_CODE],C.[FINAL_SOLDTO_NAME],C.[FINAL_INCOTERMS]
	INTO   scm_dnm_intransit_c_OFFSET_temp$
	FROM   dbo.scm_dnm_intransit_c C WITH(NOLOCK)
	       INNER  JOIN ( SELECT T.PLANT_ID
		                       ,T.ITEM_ID
		                       ,T.SHIPMENT_NO
	                     FROM   dbo.XIF_ERP_SALES_RESULT_R_OFFSET_TEMP$  T
	                     WHERE T.SALES_TYPE IN ( 'ZEX', 'ZOR' ) ) T
	           ON  C.[PLANT_ID]    = T.PLANT_ID
		       AND C.[ITEM_ID]     = T.ITEM_ID
		       AND C.[SHIPMENT_NO] = T.SHIPMENT_NO
    WHERE C.RESULT_TYPE = 'I'
	AND   C.RESULT_DATE = @V_ISSUE_DATE;

	IF OBJECT_ID('dbo.scm_dnm_stock_customer_consign_OFFSET_temp$') IS NOT NULL DROP TABLE scm_dnm_stock_customer_consign_OFFSET_temp$

	SELECT DISTINCT C.[COMPANY_ID],C.[DIVISION_ID],C.[SITE_ID],C.[PLANT_ID],C.[ITEM_ID],C.[RESULT_DATE],C.[ITEM_NAME]
          ,C.[CUSTOMER_CODE],C.[CUSTOMER_NAME],CONVERT(NUMERIC(20,10),C.[ATTRIBUTE2]) AS [QTY],C.[UOM],C.[SCM_SITE_ID],C.[VALID_YN],C.[CREATED_BY],C.[CREATION_DATE]
          ,C.[LAST_UPDATED_BY],C.[LAST_UPDATE_DATE],C.[ATTRIBUTE1],C.[ATTRIBUTE2],C.[ATTRIBUTE3],C.[ATTRIBUTE4],C.[ATTRIBUTE5]
          ,C.[ATTRIBUTE6],C.[ATTRIBUTE7],C.[ATTRIBUTE8],C.[ATTRIBUTE9],C.[ATTRIBUTE10],C.[ORIGIN_ITEM_ID],C.[FINAL_SOLDTO_CODE]
          ,C.[FINAL_SHIPTO_CODE],C.[SALES_ORDER_NO],C.[SALES_ORDER_SEQ],C.[FINAL_SOLDTO_NAME],C.[FINAL_SHIPTO_NAME]
	INTO   scm_dnm_stock_customer_consign_OFFSET_temp$
	FROM   [dbo].[SCM_DNM_STOCK_CUSTOMER_CONSIGN] C WITH(NOLOCK)
	       INNER  JOIN ( SELECT T.PLANT_ID
		                       ,T.ITEM_ID
							   ,T.ORIGIN_ITEM_ID
		                       ,T.CUSTOMER_CODE
	                           ,T.SHIPTO_CODE
	                     FROM   dbo.XIF_ERP_SALES_RESULT_R_OFFSET_TEMP$  T
	                     WHERE T.SALES_TYPE = 'ZKN' ) T
	           ON  C.[PLANT_ID]          = T.PLANT_ID
		       AND C.[ITEM_ID]           = T.ITEM_ID
			   AND C.[ORIGIN_ITEM_ID]    = T.ORIGIN_ITEM_ID
		       AND C.[CUSTOMER_CODE]     = T.CUSTOMER_CODE
	           AND C.[FINAL_SHIPTO_CODE] = T.SHIPTO_CODE
    WHERE C.RESULT_DATE = @V_ISSUE_DATE;

	-- RESULT TYPE I 할당 대상 정보 Cursor
	DECLARE CUR_ALLOC CURSOR FOR
	    SELECT PLANT_ID
    		  ,ITEM_ID
		      ,SHIPMENT_NO
		      ,SUM(SALES_QTY) AS SALES_QTY
        FROM  dbo.XIF_ERP_SALES_RESULT_R_OFFSET_TEMP$
        WHERE SALES_TYPE IN ( 'ZEX', 'ZOR' )
		GROUP BY PLANT_ID
		        ,ITEM_ID
		        ,SHIPMENT_NO
		HAVING SUM(SALES_QTY) > 0;

	OPEN CUR_ALLOC;
	FETCH NEXT FROM CUR_ALLOC INTO @PLANT_ID, @ITEM_ID, @SHIPMENT_NO ,@SALES_QTY;
		 
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	      ----------------------------------------
          -- 'ZEX', 'ZOR' 별 할당 처리 : START
	      ----------------------------------------
	      DECLARE CUR_ALLOC_RESULT_I CURSOR FOR
		  	  SELECT C.[COMPANY_ID],C.[DIVISION_ID],C.[PROJECT_CODE]
                    ,C.[PLANT_ISSUE_DATE],C.[INCOTERMS],C.[FCST_TYPE],C.[DELIVERY_QTY]
		      FROM  scm_dnm_intransit_c_OFFSET_temp$ C
              WHERE C.[PLANT_ID]     = @PLANT_ID
			  AND   C.[ITEM_ID]      = @ITEM_ID
			  AND   C.[SHIPMENT_NO]  = @SHIPMENT_NO
			  AND   C.[DELIVERY_QTY] > 0
	          ORDER BY C.[DELIVERY_QTY] DESC;
		  
	      OPEN CUR_ALLOC_RESULT_I;
	      FETCH NEXT FROM CUR_ALLOC_RESULT_I INTO @C_COMPANY_ID, @C_DIVISION_ID, @C_PROJECT_CODE, @C_PLANT_ISSUE_DATE
	                                             ,@C_INCOTERMS,	@C_FCST_TYPE, @C_DELIVERY_QTY;
		 
	      WHILE (@@FETCH_STATUS = 0)
	      BEGIN

		    -------------------------------------------------------------
            --  3-1) @DELIVERY_QTY가 @SALES_QTY 보다 큰 경우 @SALES_QTY 정리하고 종료
		    -------------------------------------------------------------
            IF @SALES_QTY <= @C_DELIVERY_QTY
			  BEGIN

                UPDATE scm_dnm_intransit_c_OFFSET_temp$
                SET    [DELIVERY_QTY] = @C_DELIVERY_QTY - @SALES_QTY
	            WHERE  [RESULT_DATE]  = @V_ISSUE_DATE
	            AND    [RESULT_TYPE]  = 'I'
	            AND    [COMPANY_ID]   = @C_COMPANY_ID
	            AND    [DIVISION_ID]  = @C_DIVISION_ID
	            AND    [PLANT_ID]     = @PLANT_ID
	            AND    [SHIPMENT_NO]  = @SHIPMENT_NO
	            AND    [PROJECT_CODE] = @C_PROJECT_CODE
	            AND    [ITEM_ID]      = @ITEM_ID
	            AND    [PLANT_ISSUE_DATE] = @C_PLANT_ISSUE_DATE
	            AND    [INCOTERMS]    = @C_INCOTERMS
	            AND    [FCST_TYPE]    = @C_FCST_TYPE; 
			    
				BREAK;
              END
		    -------------------------------------------------------------
            --  3-2) @DELIVERY_QTY가 @SALES_QTY 보다 작은 경우 @DELIVERY_QTY는 0으로 갱신. @SALES_QTY 감소
            --       @SALES_QTY 이 소진 될 때까지 처리 후 종료
		    -------------------------------------------------------------
			ELSE
			  BEGIN

                UPDATE scm_dnm_intransit_c_OFFSET_temp$
                SET    [DELIVERY_QTY] = 0
	            WHERE  [RESULT_DATE]  = @V_ISSUE_DATE
	            AND    [RESULT_TYPE]  = 'I'
	            AND    [COMPANY_ID]   = @C_COMPANY_ID
	            AND    [DIVISION_ID]  = @C_DIVISION_ID
	            AND    [PLANT_ID]     = @PLANT_ID
	            AND    [SHIPMENT_NO]  = @SHIPMENT_NO
	            AND    [PROJECT_CODE] = @C_PROJECT_CODE
	            AND    [ITEM_ID]      = @ITEM_ID
	            AND    [PLANT_ISSUE_DATE] = @C_PLANT_ISSUE_DATE
	            AND    [INCOTERMS]    = @C_INCOTERMS
	            AND    [FCST_TYPE]    = @C_FCST_TYPE; 
			    
				SET @SALES_QTY = @SALES_QTY - @C_DELIVERY_QTY;  -- 할당 후 잔여 qty 차감
					 
              END	  

	          FETCH NEXT FROM CUR_ALLOC_RESULT_I INTO @C_COMPANY_ID, @C_DIVISION_ID, @C_PROJECT_CODE, @C_PLANT_ISSUE_DATE
	                                                 ,@C_INCOTERMS,	@C_FCST_TYPE, @C_DELIVERY_QTY;
	      END -- OPEN CUR_ALLOC_RESULT_I;
		
	      CLOSE CUR_ALLOC_RESULT_I;
	      DEALLOCATE CUR_ALLOC_RESULT_I;

	 	 FETCH NEXT FROM CUR_ALLOC INTO @PLANT_ID, @ITEM_ID, @SHIPMENT_NO ,@SALES_QTY;
	  END -- OPEN CUR_ALLOC;
		
	CLOSE CUR_ALLOC;
	DEALLOCATE CUR_ALLOC;
	-------------------------------------------------------------------------
    -- RESULT TYPE I 할당 : END
	-------------------------------------------------------------------------

	-----------------------------------------------------------
    -- Insert LOG
    -----------------------------------------------------------
    SET @n_log_count = @@ROWCOUNT;
    SET @v_log_type = 'APPEND';
    SET @v_log_message = 'UPDATE scm_dnm_intransit_c_OFFSET_temp$ , result_type = I';
    SET @v_description = N'RESULT 유형 I:RESULT TYPE I 할당';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    -----------------------------------------------------------

	-- [scm_dnm_stock_customer_consign] 할당 대상 정보 Cursor
	DECLARE CUR_SC_ALLOC CURSOR FOR
	    SELECT PLANT_ID
		      ,ORIGIN_ITEM_ID
    		  ,ITEM_ID
		      ,CUSTOMER_CODE
	          ,SHIPTO_CODE
		      ,SUM(SALES_QTY) AS SALES_QTY
        FROM  dbo.XIF_ERP_SALES_RESULT_R_OFFSET_TEMP$
        WHERE SALES_TYPE = 'ZKN'
		GROUP BY PLANT_ID
		        ,ORIGIN_ITEM_ID
    		    ,ITEM_ID
		        ,CUSTOMER_CODE
	            ,SHIPTO_CODE
		HAVING SUM(SALES_QTY) > 0;

	OPEN CUR_SC_ALLOC;
	FETCH NEXT FROM CUR_SC_ALLOC INTO @PLANT_ID, @ORIGIN_ITEM_ID, @ITEM_ID, @CUSTOMER_CODE, @SHIPTO_CODE, @SALES_QTY;
		 
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	      ----------------------------------------
          -- 'ZKN' 별 할당 처리 : START
	      ----------------------------------------
	      DECLARE CUR_ALLOC_CONSIGN CURSOR FOR
	          SELECT C.[COMPANY_ID], C.[DIVISION_ID], C.[FINAL_SOLDTO_CODE], C.[SALES_ORDER_NO], C.[SALES_ORDER_SEQ], C.[QTY]
	          FROM   scm_dnm_stock_customer_consign_OFFSET_temp$ C
              WHERE C.[PLANT_ID]          = @PLANT_ID
			  AND   C.[ORIGIN_ITEM_ID]    = @ORIGIN_ITEM_ID
			  AND   C.[ITEM_ID]           = @ITEM_ID
			  AND   C.[CUSTOMER_CODE]     = @CUSTOMER_CODE
			  AND   C.[FINAL_SHIPTO_CODE] = @SHIPTO_CODE
			  AND   C.[VALID_YN]          = 'Y'
			  AND   C.[QTY]               > 0
	          ORDER BY C.[QTY] DESC;
		  
	      OPEN CUR_ALLOC_CONSIGN;
	      FETCH NEXT FROM CUR_ALLOC_CONSIGN INTO @C_COMPANY_ID, @C_DIVISION_ID, @C_FINAL_SOLDTO_CODE, @C_SALES_ORDER_NO, @C_SALES_ORDER_SEQ, @C_QTY;
		 
	      WHILE (@@FETCH_STATUS = 0)
	      BEGIN

		    -------------------------------------------------------------
            --  3-1) @C_QTY가 @SALES_QTY 보다 큰 경우 @SALES_QTY 정리하고 종료
		    -------------------------------------------------------------
            IF @SALES_QTY <= @C_QTY
			  BEGIN

                UPDATE scm_dnm_stock_customer_consign_OFFSET_temp$
                SET    [QTY] = @C_QTY - @SALES_QTY
	            WHERE  [COMPANY_ID]  = @C_COMPANY_ID
                AND    [DIVISION_ID] = @C_DIVISION_ID
                AND    [PLANT_ID]    = @PLANT_ID
                AND    [ITEM_ID]     = @ITEM_ID
                AND    [ORIGIN_ITEM_ID] = @ORIGIN_ITEM_ID
                AND    [RESULT_DATE] = @V_ISSUE_DATE
                AND    [CUSTOMER_CODE]  = @CUSTOMER_CODE
                AND    [FINAL_SOLDTO_CODE] = @C_FINAL_SOLDTO_CODE
                AND    [FINAL_SHIPTO_CODE] = @SHIPTO_CODE
                AND    [SALES_ORDER_NO]    = @C_SALES_ORDER_NO
                AND    [SALES_ORDER_SEQ]   = @C_SALES_ORDER_SEQ;             
			    
				BREAK;
              END
		    -------------------------------------------------------------
            --  3-2) @C_QTY가 @SALES_QTY 보다 작은 경우 @C_QTY는 0으로 갱신. @SALES_QTY 감소
            --       @SALES_QTY 이 소진 될 때까지 처리 후 종료
		    -------------------------------------------------------------
			ELSE
			  BEGIN

                UPDATE scm_dnm_stock_customer_consign_OFFSET_temp$
                SET    [QTY] = 0
	            WHERE  [COMPANY_ID]  = @C_COMPANY_ID
                AND    [DIVISION_ID] = @C_DIVISION_ID
                AND    [PLANT_ID]    = @PLANT_ID
                AND    [ITEM_ID]     = @ITEM_ID
                AND    [ORIGIN_ITEM_ID] = @ORIGIN_ITEM_ID
                AND    [RESULT_DATE] = @V_ISSUE_DATE
                AND    [CUSTOMER_CODE]  = @CUSTOMER_CODE
                AND    [FINAL_SOLDTO_CODE] = @C_FINAL_SOLDTO_CODE
                AND    [FINAL_SHIPTO_CODE] = @SHIPTO_CODE
                AND    [SALES_ORDER_NO]    = @C_SALES_ORDER_NO
                AND    [SALES_ORDER_SEQ]   = @C_SALES_ORDER_SEQ;   
			    
				SET @SALES_QTY = @SALES_QTY - @C_QTY;  -- 할당 후 잔여 qty 차감
					 
              END	  

	          FETCH NEXT FROM CUR_ALLOC_CONSIGN INTO @C_COMPANY_ID, @C_DIVISION_ID, @C_FINAL_SOLDTO_CODE, @C_SALES_ORDER_NO, @C_SALES_ORDER_SEQ, @C_QTY;

	      END -- OPEN CUR_ALLOC_CONSIGN;
		
	      CLOSE CUR_ALLOC_CONSIGN;
	      DEALLOCATE CUR_ALLOC_CONSIGN;

	 	 FETCH NEXT FROM CUR_SC_ALLOC INTO @PLANT_ID, @ORIGIN_ITEM_ID, @ITEM_ID, @CUSTOMER_CODE, @SHIPTO_CODE, @SALES_QTY;
	  END -- OPEN CUR_SC_ALLOC;
		
	CLOSE CUR_SC_ALLOC;
	DEALLOCATE CUR_SC_ALLOC;
	-------------------------------------------------------------------------
    -- customer_consign 할당 : END
	-------------------------------------------------------------------------

	-----------------------------------------------------------
    -- Insert LOG
    -----------------------------------------------------------
    SET @n_log_count = @@ROWCOUNT;
    SET @v_log_type = 'APPEND';
    SET @v_log_message = 'UPDATE scm_dnm_stock_customer_consign_OFFSET_temp$';
    SET @v_description = N' customer consign 할당';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    -----------------------------------------------------------

	-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
    SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_DNM_INTRANSIT_C_H		 
	INSERT INTO [dbo].[scm_dnm_intransit_c_h] with (tablock) (
            history_seq
            , result_date, result_type, company_id, division_id, plant_id, shipment_no, project_code, item_id, plant_issue_date, incoterms, fcst_type, dom_exp
            , customer_code, shipto_code, from_scm_site_id, from_site_item_mapping_yn, to_scm_site_id, to_site_item_mapping_yn
            , delivery_qty, uom, transport_mode
            , shipping_date, pol, pol_atd_date, pod, pod_eta_date, pod_ata_date, pod_etd_date, pod_atd_date
            , f_dest_port_code, f_dest_eta_date, f_dest_ata_date, valid_yn
            , final_soldto_code, final_soldto_name, final_incoterms	  	  
			, attribute4
            , creation_date, last_update_date	
            , created_by, last_updated_by, history_creation_date
            )
    SELECT  @n_history_seq
			, A.result_date, A.result_type, A.company_id, A.division_id, A.plant_id, A.shipment_no, A.project_code, A.item_id, A.plant_issue_date, A.incoterms, A.fcst_type, A.dom_exp
            , A.customer_code, A.shipto_code, A.from_scm_site_id, A.from_site_item_mapping_yn, A.to_scm_site_id, A.to_site_item_mapping_yn
            , A.delivery_qty, A.uom, A.transport_mode
            , A.shipping_date, A.pol, A.pol_atd_date, A.pod, A.pod_eta_date, A.pod_ata_date, A.pod_etd_date, A.pod_atd_date
            , A.f_dest_port_code, A.f_dest_eta_date, A.f_dest_ata_date, A.valid_yn
            , A.final_soldto_code, A.final_soldto_name, A.final_incoterms	  	  
			, A.attribute4
            , A.creation_date, A.last_update_date
			,@v_batch_user
			,@v_batch_user
			,GETDATE()
	FROM    scm_dnm_intransit_c A WITH(NOLOCK)
			INNER JOIN [dbo].[scm_dnm_intransit_c_OFFSET_temp$] B WITH(NOLOCK)
			ON	A.result_date			=  B.result_date
			AND A.result_type			=  B.result_type
			AND A.company_id				=  B.company_id
			AND A.division_id			=  B.division_id	
			AND A.plant_id				=  B.plant_id
			AND A.shipment_no			=  B.shipment_no
			AND A.project_code			=  B.project_code
			AND A.item_id				=  B.item_id
			AND A.plant_issue_date		=  B.plant_issue_date
			AND A.incoterms				=  B.incoterms	
			AND A.fcst_type				=  B.fcst_type
	WHERE  B.DELIVERY_QTY != CONVERT(NUMERIC(20,10),B.[ATTRIBUTE4]);

	-- HISTORY LOG		
    SET @n_log_count = @@ROWCOUNT;
    SET @v_log_type = 'HISTORY';
    SET @v_log_message = 'INSERT INTO scm_dnm_intransit_c_h';
    SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    -- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
	SET @n_history_seq = NEXT VALUE FOR seq1_scm_dnm_stock_customer_consign_h
	INSERT INTO [dbo].[scm_dnm_stock_customer_consign_h] (
			history_seq
			,company_id,division_id,site_id,plant_id,item_id,origin_item_id,result_date,item_name,customer_code,customer_name,qty,uom
            ,scm_site_id,valid_yn,FINAL_SOLDTO_CODE,FINAL_SOLDTO_NAME,FINAL_SHIPTO_CODE,FINAL_SHIPTO_NAME,SALES_ORDER_NO,SALES_ORDER_SEQ
            ,attribute1,attribute2,creation_date,last_update_date,created_by,last_updated_by,history_creation_date)
	SELECT  @n_history_seq
			,A.company_id,A.division_id,A.site_id,A.plant_id,A.item_id,A.origin_item_id,A.result_date,A.item_name,A.customer_code,A.customer_name,A.qty,A.uom
            ,A.scm_site_id,A.valid_yn,A.FINAL_SOLDTO_CODE,A.FINAL_SOLDTO_NAME,A.FINAL_SHIPTO_CODE,A.FINAL_SHIPTO_NAME,A.SALES_ORDER_NO,A.SALES_ORDER_SEQ
            ,A.attribute1,A.attribute2,A.creation_date,A.last_update_date
		    ,@v_batch_user
			,@v_batch_user
			,GETDATE()
	FROM    [dbo].[scm_dnm_stock_customer_consign] A WITH(NOLOCK)
			INNER JOIN [dbo].[scm_dnm_stock_customer_consign_OFFSET_temp$] B WITH(NOLOCK)
			ON  A.company_id     =  B.company_id
			AND A.division_id	=  B.division_id
			AND A.plant_id	    =  B.plant_id
			AND A.item_id		=  B.item_id
			AND A.result_date	=  B.result_date
			AND A.customer_code  =  B.customer_code
			AND A.origin_item_id	 =  B.origin_item_id
			AND A.FINAL_SOLDTO_CODE  =  B.FINAL_SOLDTO_CODE
			AND A.FINAL_SHIPTO_CODE  =  B.FINAL_SHIPTO_CODE
			AND A.SALES_ORDER_NO     =  B.SALES_ORDER_NO
			AND A.SALES_ORDER_SEQ    =  B.SALES_ORDER_SEQ
	WHERE  B.QTY != CONVERT(NUMERIC(20,10),B.[ATTRIBUTE2]);

	-- HISTORY LOG		
    SET @n_log_count = @@ROWCOUNT;
    SET @v_log_type = 'HISTORY';
    SET @v_log_message = 'INSERT INTO scm_dnm_stock_customer_consign_h';
    SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- scm_dnm_intransit_c 저장
	UPDATE  A
    SET     delivery_qty = B.DELIVERY_QTY
	       ,last_update_date = GETDATE()
           ,last_updated_by  = @v_batch_user
    FROM    scm_dnm_intransit_c A WITH(NOLOCK)
			INNER JOIN [dbo].[scm_dnm_intransit_c_OFFSET_temp$] B WITH(NOLOCK)
			ON	A.result_date			=  B.result_date
			AND A.result_type			=  B.result_type
			AND A.company_id			=  B.company_id
			AND A.division_id			=  B.division_id	
			AND A.plant_id				=  B.plant_id
			AND A.shipment_no			=  B.shipment_no
			AND A.project_code			=  B.project_code
			AND A.item_id				=  B.item_id
			AND A.plant_issue_date		=  B.plant_issue_date
			AND A.incoterms				=  B.incoterms	
			AND A.fcst_type				=  B.fcst_type
	WHERE  B.DELIVERY_QTY != CONVERT(NUMERIC(20,10),B.[ATTRIBUTE4]);

	-- HISTORY LOG		
    SET @n_log_count = @@ROWCOUNT;
    SET @v_log_type = 'UPDATE';
    SET @v_log_message = 'UPDATE scm_dnm_intransit_c';
    SET @v_description = 'UPDATE scm_dnm_intransit_c';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    -- scm_dnm_stock_customer_consign 저장
	UPDATE  A
	SET 	qty = B.QTY
	       ,last_update_date = GETDATE()
           ,last_updated_by  = @v_batch_user
	FROM    [dbo].[scm_dnm_stock_customer_consign] A WITH(NOLOCK)
			INNER JOIN [dbo].[scm_dnm_stock_customer_consign_OFFSET_temp$] B WITH(NOLOCK)
			ON  A.company_id    =  B.company_id
			AND A.division_id	=  B.division_id
			AND A.plant_id	    =  B.plant_id
			AND A.item_id		=  B.item_id
			AND A.result_date	=  B.result_date
			AND A.customer_code =  B.customer_code
			AND A.origin_item_id	 =  B.origin_item_id
			AND A.FINAL_SOLDTO_CODE  =  B.FINAL_SOLDTO_CODE
			AND A.FINAL_SHIPTO_CODE  =  B.FINAL_SHIPTO_CODE
			AND A.SALES_ORDER_NO     =  B.SALES_ORDER_NO
			AND A.SALES_ORDER_SEQ    =  B.SALES_ORDER_SEQ
	WHERE  B.QTY != CONVERT(NUMERIC(20,10),B.[ATTRIBUTE2]);

	-- HISTORY LOG		
    SET @n_log_count = @@ROWCOUNT;
    SET @v_log_type = 'UPDATE';
    SET @v_log_message = 'UPDATE scm_dnm_stock_customer_consign';
    SET @v_description = 'UPDATE scm_dnm_stock_customer_consign';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	IF OBJECT_ID('dbo.XIF_ERP_SALES_RESULT_R_OFFSET_TEMP$') IS NOT NULL DROP TABLE dbo.XIF_ERP_SALES_RESULT_R_OFFSET_TEMP$
	IF OBJECT_ID('dbo.scm_dnm_intransit_c_OFFSET_temp$') IS NOT NULL DROP TABLE scm_dnm_intransit_c_OFFSET_temp$
	IF OBJECT_ID('dbo.scm_dnm_stock_customer_consign_OFFSET_temp$') IS NOT NULL DROP TABLE scm_dnm_stock_customer_consign_OFFSET_temp$

    _RETURN_ERR_CODE:
    BEGIN
        IF @rows < 0
        BEGIN
            -- ROLLBACK
            -- ERROR LOG
            SET @v_log_type = 'ERROR';
            SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
            SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

            RETURN -1;
        END; -- IF @rows < 0

    END; -- _RETURN_ERR_CODE:

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
