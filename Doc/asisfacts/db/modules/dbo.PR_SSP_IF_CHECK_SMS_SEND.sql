

/*
 * Program ID   : PR_SSP_IF_CHECK_SMS_SEND
 * Description  : I/F DATA Check
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2020.03.11   KIMYONGHO		Initial Release [] 전지GSCM(SSP) SM 운영
 * 2024.10.01   KHJ             NERP_SSP
 */
 
CREATE PROCEDURE [dbo].[PR_SSP_IF_CHECK_SMS_SEND]
 AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SSP_IF_CHECK_SMS_SEND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_text		   NVARCHAR(200);
    DECLARE @v_code		   NVARCHAR(10);

	-- NERP 매핑코드
    DECLARE @v_C100 NVARCHAR(10);
	DECLARE @v_G180 NVARCHAR(10);
    DECLARE @v_G380 NVARCHAR(10);
	DECLARE @v_G450 NVARCHAR(10);
    DECLARE @v_G480 NVARCHAR(10);
	DECLARE @v_G630 NVARCHAR(10);

	SET @v_C100 = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_IF_CHECK_SMS_SEND'  ,'ESOC' );	--C100
	SET @v_G180 = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_IF_CHECK_SMS_SEND'  ,'ESNJ' );	--G180
	SET @v_G380 = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_IF_CHECK_SMS_SEND'  ,'ESMI' );	--G380
	SET @v_G450 = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_IF_CHECK_SMS_SEND'  ,'ESNA' );	--G450
	SET @v_G480 = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_IF_CHECK_SMS_SEND'  ,'ESWA' );	--G480
	SET @v_G630 = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_IF_CHECK_SMS_SEND'  ,'ESNB' );	--G630


	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
   
    
	BEGIN TRY
		BEGIN
    
			declare @rs nvarchar(10);
			declare @message nvarchar(100);

			set @rs = '';
			set @message = '';


			/* XIF_MES_FORMATION_LOT_QMS_INSP_RESULT_R_SN
			 A010 : 06, 14
			 G182 : 09
			*/

			IF OBJECT_ID (N'tempdb..#TEMP_XIF_MES_FORMATION_LOT_QMS_INSP_RESULT_R_SN', N'U') IS NOT NULL 
				DROP TABLE #TEMP_XIF_MES_FORMATION_LOT_QMS_INSP_RESULT_R_SN

			CREATE TABLE #TEMP_XIF_MES_FORMATION_LOT_QMS_INSP_RESULT_R_SN ( 
				IF_SEQ               nvarchar(50)    NOT NULL,                    
				IF_ID                nvarchar(50)    NOT NULL,                    
				IF_RCV_DATE          datetime,    
				PLANT_ID             nvarchar(30)    NULL
				
			);
			/* XIF_MES_ISS_WAIT_PALLET_R_SN
			 A040 : 06
			 A050 : 06
			 G382 : 20, 21
			 G451 : 09
			 G481 : 15
			 G631 : 09
			 G634 : 09
			*/

			IF OBJECT_ID (N'tempdb..#TEMP_XIF_MES_ISS_WAIT_PALLET_R_SN', N'U') IS NOT NULL 
				DROP TABLE #TEMP_XIF_MES_ISS_WAIT_PALLET_R_SN

			CREATE TABLE #TEMP_XIF_MES_ISS_WAIT_PALLET_R_SN ( 
				IF_SEQ               nvarchar(50)    NOT NULL,                    
				IF_ID                nvarchar(50)    NOT NULL,                    
				IF_RCV_DATE          datetime,    
				PLANT_ID             nvarchar(30)    NULL
				
			);

			/* XIF_OWMS_SHIP_RESULT_R_SN
			   XIF_OWMS_SHIP_RETURN_R_SN

			 A002 : 06
			 A010 : 06
			 A040 : 06
			 A050 : 06
			 G182 : 09
			 G184 : 09
			 G382 : 21
			 G451 : 09
			 G481 : 15
			*/

			IF OBJECT_ID (N'tempdb..#TEMP_XIF_OWMS_SHIP_RESULT_R_SN', N'U') IS NOT NULL 
				DROP TABLE #TEMP_XIF_OWMS_SHIP_RESULT_R_SN

			CREATE TABLE #TEMP_XIF_OWMS_SHIP_RESULT_R_SN ( 
				IF_SEQ               nvarchar(50)    NOT NULL,                    
				IF_ID                nvarchar(50)    NOT NULL,                    
				IF_RCV_DATE          datetime,    
				PLANT_ID             nvarchar(30)    NULL
				
			);
			IF OBJECT_ID (N'tempdb..#TEMP_XIF_OWMS_SHIP_RETURN_R_SN', N'U') IS NOT NULL 
				DROP TABLE #TEMP_XIF_OWMS_SHIP_RETURN_R_SN

			CREATE TABLE #TEMP_XIF_OWMS_SHIP_RETURN_R_SN ( 
				IF_SEQ               nvarchar(50)    NOT NULL,                    
				IF_ID                nvarchar(50)    NOT NULL,                    
				IF_RCV_DATE          datetime,    
				PLANT_ID             nvarchar(30)    NULL
				
			);

			/* XIF_OWMS_STOCK_R_SN
			A002
			A010
			A040
			A050
			G182
			G184
			G382
			G451
			G481
			G631
			G634  	

			*/

			IF OBJECT_ID (N'tempdb..#TEMP_XIF_OWMS_STOCK_R_SN', N'U') IS NOT NULL 
				DROP TABLE #TEMP_XIF_OWMS_STOCK_R_SN

			CREATE TABLE #TEMP_XIF_OWMS_STOCK_R_SN ( 
				IF_SEQ               nvarchar(50)    NOT NULL,                    
				IF_ID                nvarchar(50)    NOT NULL,                    
				IF_RCV_DATE          datetime,    
				PLANT_ID             nvarchar(30)    NULL
				
			);

/* INF-R 적용 이전
			INSERT INTO #TEMP_XIF_MES_FORMATION_LOT_QMS_INSP_RESULT_R_SN 
			SELECT IF_SEQ, IF_ID, IF_RCV_DATE, PLANT_ID
			FROM XIF_MES_FORMATION_LOT_QMS_INSP_RESULT_R_SN WITH(NOLOCK)
			WHERE CONVERT(CHAR(10), IF_RCV_DATE, 23) = CONVERT(CHAR(10), GETDATE(), 23)

			INSERT INTO #TEMP_XIF_MES_ISS_WAIT_PALLET_R_SN 
			SELECT IF_SEQ, IF_ID, IF_RCV_DATE, PLANT_ID
			FROM XIF_MES_ISS_WAIT_PALLET_R_SN WITH(NOLOCK)
			WHERE CONVERT(CHAR(10), IF_RCV_DATE, 23) = CONVERT(CHAR(10), GETDATE(), 23)
			
			INSERT INTO #TEMP_XIF_OWMS_SHIP_RESULT_R_SN 
			SELECT IF_SEQ, IF_ID, IF_RCV_DATE, PLANT_ID
			FROM XIF_OWMS_SHIP_RESULT_R_SN WITH(NOLOCK)
			WHERE CONVERT(CHAR(10), IF_RCV_DATE, 23) = CONVERT(CHAR(10), GETDATE(), 23)

			INSERT INTO #TEMP_XIF_OWMS_SHIP_RETURN_R_SN 
			SELECT IF_SEQ, IF_ID, IF_RCV_DATE, PLANT_ID
			FROM XIF_OWMS_SHIP_RETURN_R_SN WITH(NOLOCK)
			WHERE CONVERT(CHAR(10), IF_RCV_DATE, 23) = CONVERT(CHAR(10), GETDATE(), 23)
			
			INSERT INTO #TEMP_XIF_OWMS_STOCK_R_SN 
			SELECT IF_SEQ, IF_ID, IF_RCV_DATE, PLANT_ID
			FROM XIF_OWMS_STOCK_R_SN WITH(NOLOCK)
			WHERE CONVERT(CHAR(10), IF_RCV_DATE, 23) = CONVERT(CHAR(10), GETDATE(), 23)	
*/
/* INF-R 적용 후 */

			INSERT INTO #TEMP_XIF_MES_FORMATION_LOT_QMS_INSP_RESULT_R_SN 
			SELECT IF_SEQ, IF_ID, IF_RCV_DATE, ISNULL(X1.NEW_VALUE1, A.PLANT_ID) AS PLANT_ID
			FROM XIF_MES_FORMATION_LOT_QMS_INSP_RESULT_R_SN A WITH(NOLOCK)
			LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
			ON  X1.CODETYPE = 'PLANT_ID'
			AND A.PLANT_ID = X1.OLD_VALUE1 
			AND X1.ATTRIBUTE5 in ('1ST','2ND')
			WHERE CONVERT(CHAR(10), IF_RCV_DATE, 23) = CONVERT(CHAR(10), GETDATE(), 23)

			INSERT INTO #TEMP_XIF_MES_ISS_WAIT_PALLET_R_SN 
			SELECT IF_SEQ, IF_ID, IF_RCV_DATE, ISNULL(X1.NEW_VALUE1, A.PLANT_ID) AS PLANT_ID
			FROM XIF_MES_ISS_WAIT_PALLET_R_SN A WITH(NOLOCK)
			LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
			ON  X1.CODETYPE = 'PLANT_ID'
			AND A.PLANT_ID = X1.OLD_VALUE1 
			AND X1.ATTRIBUTE5 in ('1ST','2ND')
			WHERE CONVERT(CHAR(10), IF_RCV_DATE, 23) = CONVERT(CHAR(10), GETDATE(), 23)
			
			INSERT INTO #TEMP_XIF_OWMS_SHIP_RESULT_R_SN 
			SELECT IF_SEQ, IF_ID, IF_RCV_DATE, ISNULL(X1.NEW_VALUE1, A.PLANT_ID) AS PLANT_ID
			FROM XIF_OWMS_SHIP_RESULT_R_SN A WITH(NOLOCK)
			LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
			ON  X1.CODETYPE = 'PLANT_ID'
			AND A.PLANT_ID = X1.OLD_VALUE1 
			AND X1.ATTRIBUTE5 in ('1ST','2ND')
			WHERE CONVERT(CHAR(10), IF_RCV_DATE, 23) = CONVERT(CHAR(10), GETDATE(), 23)

			INSERT INTO #TEMP_XIF_OWMS_SHIP_RETURN_R_SN 
			SELECT IF_SEQ, IF_ID, IF_RCV_DATE, ISNULL(X1.NEW_VALUE1, A.PLANT_ID) AS PLANT_ID
			FROM XIF_OWMS_SHIP_RETURN_R_SN A WITH(NOLOCK)
			LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
			ON  X1.CODETYPE = 'PLANT_ID'
			AND A.PLANT_ID = X1.OLD_VALUE1 
			AND X1.ATTRIBUTE5 in ('1ST','2ND')
			WHERE CONVERT(CHAR(10), IF_RCV_DATE, 23) = CONVERT(CHAR(10), GETDATE(), 23)
			
			INSERT INTO #TEMP_XIF_OWMS_STOCK_R_SN 
			SELECT IF_SEQ, IF_ID, IF_RCV_DATE, ISNULL(X1.NEW_VALUE1, A.PLANT_ID) AS PLANT_ID
			FROM XIF_OWMS_STOCK_R_SN A WITH(NOLOCK)
			LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
			ON  X1.CODETYPE = 'PLANT_ID'
			AND A.PLANT_ID = X1.OLD_VALUE1 
			AND X1.ATTRIBUTE5 in ('1ST','2ND')
			WHERE CONVERT(CHAR(10), IF_RCV_DATE, 23) = CONVERT(CHAR(10), GETDATE(), 23)	


			IF (CONVERT(CHAR(2),GETDATE(),108) = '09')  --하루 1회 09시에만 수행함.
			BEGIN
				------------------------------------------------------------------------------------------------------------------
				IF (
					SELECT COUNT(*)
					FROM #TEMP_XIF_MES_FORMATION_LOT_QMS_INSP_RESULT_R_SN
					--WHERE PLANT_ID IN ('A010','G182') 
					WHERE SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  BETWEEN '06:00' AND '10:00'	

					) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
							SET @v_text = N'[' + 'XIF_MES_FORMATION_LOT_QMS_INSP_RESULT_R_SN' + N']'
							SET @v_code = '67'

							--PRINT '===============================================';			
							EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

						END
				------------------------------------------------------------------------------------------------------------------	

				IF (
					SELECT COUNT(*)
					FROM #TEMP_XIF_MES_ISS_WAIT_PALLET_R_SN
					--WHERE PLANT_ID IN ('A040', 'A050', 'G451', 'G631', 'G634') 
					WHERE SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  BETWEEN '06:00' AND '10:00'
					) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
							SET @v_text = N'[' + 'XIF_MES_ISS_WAIT_PALLET_R_SN' + N']'
							SET @v_code = '67'

							--EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

						END
				------------------------------------------------------------------------------------------------------------------	
				IF (
					SELECT COUNT(*)
					FROM #TEMP_XIF_OWMS_SHIP_RESULT_R_SN
					--WHERE PLANT_ID IN ('A002', 'A010', 'A040', 'A050', 'G182', 'G182','G184','G451')
					WHERE SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  BETWEEN '06:00' AND '10:00'
					) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
							SET @v_text = N'[' + 'XIF_OWMS_SHIP_RESULT_R_SN' + N']'
							SET @v_code = '67'

							EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

						END
				------------------------------------------------------------------------------------------------------------------	
				IF (
					SELECT COUNT(*)
					FROM #TEMP_XIF_OWMS_SHIP_RETURN_R_SN
					--WHERE PLANT_ID IN ('A002', 'A010', 'A040', 'A050', 'G182', 'G182','G184','G451')
					  --AND SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  LIKE '06:%'
					WHERE SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  BETWEEN '06:00' AND '10:00'
					) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
							SET @v_text = N'[' + 'XIF_OWMS_SHIP_RETURN_R_SN' + N']'
							SET @v_code = '67'

							EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

						END
				------------------------------------------------------------------------------------------------------------------	
				--IF (
				--	SELECT COUNT(*)
				--	FROM #TEMP_XIF_OWMS_STOCK_R_SN
				--	 --WHERE PLANT_ID IN ('A002', 'A010', 'A040', 'A050', 'G182', 'G182','G184','G451')
				--	WHERE SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  BETWEEN '06:00' AND '10:00'
				--	) < 1  -- 데이터가 존재하지 않는경우
				--		BEGIN
				--			SET @v_text = ''
				--			SET @v_code = ''
				--			SET @v_text = N'[' + 'XIF_OWMS_STOCK_R_SN' + N']'
				--			SET @v_code = '67'

				--			EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

				--		END

				IF (
					SELECT COUNT(*)
					FROM  SCM_ADM_LOOKUP_MASTER_DETAIL
					 WHERE 1 = 1
					   AND LOOKUP_TYPE	= 'IF_STOCK_CHECK'
					   AND SEGMENT2     = 'OWMS'
					   AND SEGMENT4	    = @v_C100		--'C100'
					   AND SEGMENT5		= CONVERT(CHAR(8), GETDATE(), 112)
					   AND DESCRIPTION = 'OWMS STOCK'
					) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
--							SET @v_text = N'[' + 'XIF_OWMS_STOCK_R_SN - C100' + N']'
							SET @v_text = N'[' + 'XIF_OWMS_STOCK_R_SN - ' + @v_C100 + N']'
							SET @v_code = '67'

							EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

						END


				
			END

			IF (CONVERT(CHAR(2),GETDATE(),108) = '11')  --하루 1회 11시에만 수행함.
			BEGIN
				IF (
					SELECT COUNT(*)
					FROM  SCM_ADM_LOOKUP_MASTER_DETAIL
					 WHERE 1 = 1
					   AND LOOKUP_TYPE	= 'IF_STOCK_CHECK'
					   AND SEGMENT2     = 'OWMS'
					   AND SEGMENT4	    = @v_G180			--'G180'
					   AND SEGMENT5		= CONVERT(CHAR(8), GETDATE(), 112)
					   AND DESCRIPTION = 'OWMS STOCK'
					) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
--							SET @v_text = N'[' + 'XIF_OWMS_STOCK_R_SN - G180' + N']'
							SET @v_text = N'[' + 'XIF_OWMS_STOCK_R_SN - ' + @v_G180 + N']'
							SET @v_code = '67'

							EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

						END


				IF (
					SELECT COUNT(*)
					FROM  SCM_ADM_LOOKUP_MASTER_DETAIL
					 WHERE 1 = 1
					   AND LOOKUP_TYPE	= 'IF_STOCK_CHECK'
					   AND SEGMENT2     = 'OWMS'
					   AND SEGMENT4	    = @v_G450			--'G450'
					   AND SEGMENT5		= CONVERT(CHAR(8), GETDATE(), 112)
					   AND DESCRIPTION = 'OWMS STOCK'
					) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
--							SET @v_text = N'[' + 'XIF_OWMS_STOCK_R_SN - G450' + N']'
							SET @v_text = N'[' + 'XIF_OWMS_STOCK_R_SN - ' + @v_G450 + N']'
							SET @v_code = '67'

							EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

						END


				IF (
					SELECT COUNT(*)
					FROM  SCM_ADM_LOOKUP_MASTER_DETAIL
					 WHERE 1 = 1
					   AND LOOKUP_TYPE	= 'IF_STOCK_CHECK'
					   AND SEGMENT2     = 'OWMS'
					   AND SEGMENT4	    = @v_G630			-- 'G630'
					   AND SEGMENT5		= CONVERT(CHAR(8), GETDATE(), 112)
					   AND DESCRIPTION = 'OWMS STOCK'
					) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
--							SET @v_text = N'[' + 'XIF_OWMS_STOCK_R_SN - G630' + N']'
							SET @v_text = N'[' + 'XIF_OWMS_STOCK_R_SN - ' + @v_G630 + N']'
							SET @v_code = '67'

							EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

						END

			END
			

			IF (CONVERT(CHAR(2),GETDATE(),108) = '16')  --하루 1회 16시에만 수행함.
			BEGIN
				------------------------------------------------------------------------------------------------------------------
				--IF (
				--	SELECT COUNT(*)
				--	FROM #TEMP_XIF_MES_FORMATION_LOT_QMS_INSP_RESULT_R_SN
				--	--WHERE PLANT_ID IN ('A010')
				--	  --AND SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  LIKE '14:%'
				--	WHERE SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  BETWEEN '14:00' AND '16:00'
				--	) < 1  -- 데이터가 존재하지 않는경우
				--		BEGIN
				--			SET @v_text = ''
				--			SET @v_code = ''
				--			SET @v_text = N'[' + 'XIF_MES_FORMATION_LOT_QMS_INSP_RESULT_R_SN' + N']'
				--			SET @v_code = '67'

				--			EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

				--		END
				------------------------------------------------------------------------------------------------------------------	
				IF (
					SELECT COUNT(*)
					FROM #TEMP_XIF_MES_ISS_WAIT_PALLET_R_SN
					--WHERE PLANT_ID IN ('G481')
					--AND SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  LIKE '06:%'
					WHERE SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  BETWEEN '14:00' AND '16:00'
					) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
							SET @v_text = N'[' + 'XIF_MES_ISS_WAIT_PALLET_R_SN' + N']'
							SET @v_code = '67'

							--EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

						END
				------------------------------------------------------------------------------------------------------------------	
				IF (
					SELECT COUNT(*)
					FROM #TEMP_XIF_OWMS_SHIP_RESULT_R_SN
					--WHERE PLANT_ID IN ('G481')
					WHERE SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  BETWEEN '14:00' AND '16:00'
					) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
							SET @v_text = N'[' + 'XIF_OWMS_SHIP_RESULT_R_SN' + N']'
							SET @v_code = '67'

							EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

						END
				------------------------------------------------------------------------------------------------------------------
				IF (
					SELECT COUNT(*)
					FROM #TEMP_XIF_OWMS_SHIP_RETURN_R_SN
					--WHERE PLANT_ID IN ('G481')
					WHERE SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  BETWEEN '14:00' AND '16:00'
					) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
							SET @v_text = N'[' + 'XIF_OWMS_SHIP_RETURN_R_SN' + N']'
							SET @v_code = '67'

							EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

						END
				------------------------------------------------------------------------------------------------------------------	
				--IF (
				--	SELECT COUNT(*)
				--	FROM #TEMP_XIF_OWMS_STOCK_R_SN
				--	--WHERE PLANT_ID IN ('A002', 'A010', 'A040', 'A050', 'G182', 'G182','G184','G451')
				--	WHERE SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  BETWEEN '14:00' AND '16:00'
				--	) < 1  -- 데이터가 존재하지 않는경우
				--		BEGIN
				--			SET @v_text = ''
				--			SET @v_code = ''
				--			SET @v_text = N'[' + 'XIF_OWMS_STOCK_R_SN' + N']'
				--			SET @v_code = '67'

				--			EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

				--		END

				IF (
					SELECT COUNT(*)
					FROM  SCM_ADM_LOOKUP_MASTER_DETAIL
					 WHERE 1 = 1
					   AND LOOKUP_TYPE	= 'IF_STOCK_CHECK'
					   AND SEGMENT2     = 'OWMS'
					   AND SEGMENT4	    = @v_G480		--'G480'
					   AND SEGMENT5		= CONVERT(CHAR(8), GETDATE(), 112)
					   AND DESCRIPTION = 'OWMS STOCK'
					) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
--							SET @v_text = N'[' + 'XIF_OWMS_STOCK_R_SN - G480' + N']'
							SET @v_text = N'[' + 'XIF_OWMS_STOCK_R_SN - '+ @v_G480 + N']'
							SET @v_code = '67'

							EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

						END

			END



			IF (CONVERT(CHAR(2),GETDATE(),108) = '22')  --하루 1회 22시에만 수행함.
			BEGIN
				------------------------------------------------------------------------------------------------------------------
				IF (
					SELECT COUNT(*)
					FROM #TEMP_XIF_MES_ISS_WAIT_PALLET_R_SN
					--WHERE PLANT_ID IN ('G382')
					WHERE SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  BETWEEN '20:00' AND '22:00'
					) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
							SET @v_text = N'[' + 'XIF_MES_ISS_WAIT_PALLET_R_SN' + N']'
							SET @v_code = '67'

							--EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

						END
				------------------------------------------------------------------------------------------------------------------
				IF (
					SELECT COUNT(*)
					FROM #TEMP_XIF_OWMS_SHIP_RESULT_R_SN
					--WHERE PLANT_ID IN ('G382')
					WHERE SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  BETWEEN '20:00' AND '22:00'
					) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
							SET @v_text = N'[' + 'XIF_OWMS_SHIP_RESULT_R_SN' + N']'
							SET @v_code = '67'

							EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

						END
				------------------------------------------------------------------------------------------------------------------	

				IF (
					SELECT COUNT(*)
					FROM #TEMP_XIF_OWMS_SHIP_RETURN_R_SN
					--WHERE PLANT_ID IN ('G481')
					WHERE SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  BETWEEN '20:00' AND '22:00'
					) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
							SET @v_text = N'[' + 'XIF_OWMS_SHIP_RETURN_R_SN' + N']'
							SET @v_code = '67'

							EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

						END
				------------------------------------------------------------------------------------------------------------------	

				--IF (
				--	SELECT COUNT(*)
				--	FROM #TEMP_XIF_OWMS_STOCK_R_SN
				--	 --WHERE PLANT_ID IN ('A002', 'A010', 'A040', 'A050', 'G182', 'G182','G184','G451')
				--	WHERE SUBSTRING(CONVERT(CHAR(23), IF_RCV_DATE, 21),12,5)  BETWEEN '20:00' AND '22:00'
				--	) < 1  -- 데이터가 존재하지 않는경우
				--		BEGIN
				--			SET @v_text = ''
				--			SET @v_code = ''
				--			SET @v_text = N'[' + 'XIF_OWMS_STOCK_R_SN' + N']'
				--			SET @v_code = '67'

				--			EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

				--		END



				IF (
					SELECT COUNT(*)
					FROM  SCM_ADM_LOOKUP_MASTER_DETAIL
					 WHERE 1 = 1
					   AND LOOKUP_TYPE	= 'IF_STOCK_CHECK'
					   AND SEGMENT2     = 'OWMS'
					   AND SEGMENT4	    = @v_G380			--'G380'
					   AND SEGMENT5		= CONVERT(CHAR(8), GETDATE(), 112)
					   AND DESCRIPTION = 'OWMS STOCK'
					) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
--							SET @v_text = N'[' + 'XIF_OWMS_STOCK_R_SN - G380' + N']'
							SET @v_text = N'[' + 'XIF_OWMS_STOCK_R_SN - ' + @v_G380 + N']'
							SET @v_code = '67'

							EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

						END

			END
			


		END

    END TRY

    BEGIN CATCH
        
      
      -- ERROR LOG
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

      return -1 
    END CATCH;

    -- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description  = N'';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    return 1 


  END;



