
/*
 * Program ID   : [DMF0020_EXCEL_UPLOAD]
 * Description  : PR_DETAIL_AUTO 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.05.27		KJJ			최초 작성
 * 2024.12.31		KJJ			[PJ2024-50611] item별로 1개의 currency만 등록되게 기존 데이터 체크하여 튕겨냄 - 작업중
 */

 --EXEC DMF0020_EXCEL_UPLOAD '1', 'kjj0070'  

 CREATE PROCEDURE [dbo].[DMF0020_EXCEL_UPLOAD]
	@p_mode		   INT,
	@p_created_by  NVARCHAR(150)		

AS

BEGIN

/*


1.81 사업부만 대상임


2. LOC 값이 없을 경우 0으로 간주하여 처리(skip 이 아님)
=>기존 저장 SP(DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL) 는 무조건 삭제 후 0 값이 아닌 것들(구분자 D 가 아닌것들)만 insert 하는 것으로 되어 있으나
본 SP는 Merge into 구문으로 구현하여 0으로 처리


=>2024.06.12 로직 변경
0 으로 넣은 경우: Validation 에서 Invalid 처리
빈값으로 넣은 경우: SKIP, 기존 Sales Price 데이터를 유지



3.입력된 엑셀 row 중복체크
=>1)동일모델 입력 방지 위해 Div / Team /	End Customer /	Project Code /	Model 로 중복체크
=>2)위 체크조건 통과했을 경우 여러개 Currency 입력방지 위해 중복체크



4.ItemID가 입력되지 않은 것들과  ItemID가 입력된 건들을 나누어서 추출 후 병합(row순서는 고려하지 않음)
=>
81	자동차.마케팅.OTS.OTS2팀	Corvus Norway	A22CR1001	USD	 AMVAGBEVM-A4-D13  300	300	300	300	300
81	자동차.마케팅.OTS.OTS2팀	Corvus Norway	A22CR1001	USD					   100	100	100	100	100


81	자동차.마케팅.아시아.현대기아차팀	KIA	A22MZ1002	USD	ACHP2005I-A1T007	500	500	500	500


순서로 입력되어 있어도 ItemID가 입력되지 않은 것 먼저 처리함(2024.05.29 박필수 책임 확인사항)

=>이를 위해 ItemID 없는 건들 먼저 추출(전체 데이터셋)
=>ItemID 있는 건들 추출(ItemID 데이터셋)
=>merge into 처리


5.SCM_MST_FUTURE_PRICE , SCM_MST_FUTURE_PRICE_H 저장시 화면에서 수동으로 등록한 것과 구분하기 위해 ATTRIBUTE8 컬럼에 EXCEL UPLOAD 표시

*/
    SET NOCOUNT ON;

    DECLARE @v_program_id     AS NVARCHAR(40) = 'DMF0020';
    DECLARE @v_sheet_name     AS NVARCHAR(40) = 'Sales Price';	
	DECLARE @v_sql_text       AS NVARCHAR(MAX);
	DECLARE @v_creation_date  AS NVARCHAR(40);
	DECLARE @v_count          AS INT;
	DECLARE @v_start_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_end_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_division		AS NVARCHAR(10); 

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0020_EXCEL_UPLOAD';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	

	SELECT @v_creation_date = CONVERT(NVARCHAR(40), MAX(T.CREATION_DATE), 121)
	FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T
	WHERE  T.PROGRAM_ID = @v_program_id
	AND    T.SHEET_NAME = @v_sheet_name
	AND    T.CREATED_BY = @p_created_by;
	--  AND UPPER(METADATA1_VALUE) != 'BASIS YYYYMM';
		 
	IF @v_creation_date IS NULL BEGIN
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'Data Not Found [' + CONVERT(CHAR(19), @v_creation_date, 121) +']';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END;

		BEGIN
			SELECT TOP 1  @v_division = ATTRIBUTE1 FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			WHERE  PROGRAM_ID    = @v_program_id
			AND    SHEET_NAME    = @v_sheet_name
			AND    CREATED_BY    = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'SUCCESS';
		END

	-- @p_mode = 0 이면 Validation
	IF ISNULL(@p_mode, 0) = 0 
	BEGIN
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'UPLOAD'
             , MESSAGE_TEXT       = NULL             
        FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T
		WHERE  T.PROGRAM_ID    = @v_program_id
        AND    T.SHEET_NAME    = @v_sheet_name
        AND    T.CREATED_BY    = @p_created_by
        AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
        AND    ISNULL(T.UPLOAD_STATUS_CODE,'X') != 'UPLOAD';
    	END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
	    SET @v_log_type = '1';
	    SET @v_log_message = '########## RESET Status = UPLOAD ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		BEGIN
	    UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'SKIP'
        WHERE  PROGRAM_ID    = @v_program_id
        AND    SHEET_NAME    = @v_sheet_name
        AND    CREATED_BY    = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    (   ATTRIBUTE1  IS NULL 
	            OR UPPER(ATTRIBUTE1) = 'TOTAL') ;
		END;

	    BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('SKIP EMPTY LINE      ', SQL%ROWCOUNT, 2, TRUE);
		SET @v_log_type = '2';
		SET @v_log_message = '########## SKIP EMPTY LINE ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = '@TITLE'
        WHERE  PROGRAM_ID    = @v_program_id
        AND    SHEET_NAME    = @v_sheet_name
        AND    CREATED_BY    = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPPER(ATTRIBUTE1) = 'DIV';               
        END;

		BEGIN
		------------------------------------------------------------------------
        --scm2_mgr.xLOG('@TITLE Header Line   ', SQL%ROWCOUNT, 3, TRUE);
		SET @v_log_type = '3';
		SET @v_log_message = '########## TITLE Header Line ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;



		--본격적 VALIDATION 시작

		/* #################################################### */
		/* 필수 값 NULL 값 체크									*/
		/* ATTRIBUTE1  : Div									*/
		/* ATTRIBUTE2  : Team									*/
		/* ATTRIBUTE3  : End Customer							*/
		/* ATTRIBUTE4 : Project Code							*/
		/* ATTRIBUTE5 : Currency								*/
		/* #################################################### */
		--Div	Team	End Customer	Project Code	Currency
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET UPLOAD_STATUS_CODE	= 'ERROR'
				 , MESSAGE_TEXT			= CASE WHEN ISNULL(ATTRIBUTE1,'')=''  THEN 'NULL DIVISION.' 
				 							   WHEN ISNULL(ATTRIBUTE2,'')=''  THEN 'NULL TEAM.' 
				 							   WHEN ISNULL(ATTRIBUTE3,'')=''  THEN 'NULL END CUSTOMER.' 
				 							   WHEN ISNULL(ATTRIBUTE4,'')=''  THEN 'NULL PROJECT CODE.' 	
				 							   WHEN ISNULL(ATTRIBUTE5,'')=''  THEN 'NULL CURRENCY.' 
										   END
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND (   
					ISNULL(ATTRIBUTE1,'')='' OR ISNULL(ATTRIBUTE2, '')='' OR ISNULL(ATTRIBUTE3, '')='' OR ISNULL(ATTRIBUTE4,'')='' OR ISNULL(ATTRIBUTE5,'')='' 
					
					) ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## ERROR NULL Column Data ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();
				
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* 동일아이템 중복 체크									*/
		/* ATTRIBUTE1  : Div									*/
		/* ATTRIBUTE2  : Team									*/
		/* ATTRIBUTE3  : End Customer							*/
		/* ATTRIBUTE4 : Project Code							*/
		/* ATTRIBUTE5 : Currency								*/
		/* ATTRIBUTE6 : Model									*/
		/* #################################################### */
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Duplication Model.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND EXISTS (SELECT 1
		            FROM  (SELECT X.ATTRIBUTE1 AS COL1/* ATTRIBUTE1  : Div		*/
                                , X.ATTRIBUTE2 AS COL2/* ATTRIBUTE2  : Team		*/
                                , X.ATTRIBUTE3 AS COL3/* ATTRIBUTE3  : End Customer	*/
                                , X.ATTRIBUTE4 AS COL4/* ATTRIBUTE4 : Project Code	*/
								, X.ATTRIBUTE6 AS COL6/*ATTRIBUTE6  : Model			*/
                           FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] X  WITH(NOLOCK)
                           WHERE  X.PROGRAM_ID    = @v_program_id
                           AND    X.SHEET_NAME    = @v_sheet_name
                           AND    X.CREATED_BY    = @p_created_by
                           AND    CONVERT(NVARCHAR(40), X.CREATION_DATE, 121) = @v_creation_date
                           AND    X.UPLOAD_STATUS_CODE = 'UPLOAD'
                           GROUP BY X.ATTRIBUTE1
                                  , X.ATTRIBUTE2
                                  , X.ATTRIBUTE3
                                  , X.ATTRIBUTE4
								  , X.ATTRIBUTE6
                           HAVING COUNT(*) > 1 ) T
					WHERE 1 = 1										 
	 			    AND T.COL1 = ATTRIBUTE1
                    AND T.COL2 = ATTRIBUTE2
                    AND T.COL3 = ATTRIBUTE3
                    AND T.COL4 = ATTRIBUTE4
					AND T.COL6 = ATTRIBUTE6
				   );
		END

		BEGIN
		------------------------------------------------------------------------
        --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
		SET @v_log_type = '4';
		SET @v_log_message = '########## ERROR Model Duplication ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		/* #################################################### */
		/* 위 체크 통과했을 경우 Currency 체크					*/
		/*두 개 이상의 Currency가 중복으로 입력되면 안됨		*/
		/* ATTRIBUTE1  : Div									*/
		/* ATTRIBUTE2  : Team									*/
		/* ATTRIBUTE3  : End Customer							*/
		/* ATTRIBUTE4 : Project Code							*/
		/* ATTRIBUTE5 : Currency								*/
		/* ATTRIBUTE6 : Model									*/
		/* #################################################### */
		IF NOT EXISTS (SELECT 1
                           FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] X  WITH(NOLOCK)
                           WHERE  X.PROGRAM_ID    = @v_program_id
                           AND    X.SHEET_NAME    = @v_sheet_name
                           AND    X.CREATED_BY    = @p_created_by
                           AND    CONVERT(NVARCHAR(40), X.CREATION_DATE, 121) = @v_creation_date
                           AND    X.UPLOAD_STATUS_CODE = 'UPLOAD'
                           GROUP BY X.ATTRIBUTE1
                                  , X.ATTRIBUTE2
                                  , X.ATTRIBUTE3
                                  , X.ATTRIBUTE4
								  , X.ATTRIBUTE6
                           HAVING COUNT(*) > 1 )
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Multiple Currency.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND EXISTS (SELECT 1
		            FROM  
					(
							SELECT 
							COL1,COL2,COL3,COL4 
							FROM
							(
								SELECT X.ATTRIBUTE1 AS COL1
											, X.ATTRIBUTE2 AS COL2
											, X.ATTRIBUTE3 AS COL3
											, X.ATTRIBUTE4 AS COL4
											, X.ATTRIBUTE5 AS COL5 
										FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] X  WITH(NOLOCK)
										WHERE  X.PROGRAM_ID    = @v_program_id
										AND    X.SHEET_NAME    = @v_sheet_name
										AND    X.CREATED_BY    = @p_created_by
										AND    CONVERT(NVARCHAR(40), X.CREATION_DATE, 121) = @v_creation_date
										AND    X.UPLOAD_STATUS_CODE = 'UPLOAD'
										GROUP BY X.ATTRIBUTE1
												, X.ATTRIBUTE2
												, X.ATTRIBUTE3
												, X.ATTRIBUTE4
												, X.ATTRIBUTE5
							) A
							GROUP BY COL1,COL2,COL3,COL4 
							HAVING COUNT(*) > 1

						  ) T
					WHERE 1 = 1										 
	 			    AND T.COL1 = ATTRIBUTE1
                    AND T.COL2 = ATTRIBUTE2
                    AND T.COL3 = ATTRIBUTE3
                    AND T.COL4 = ATTRIBUTE4
				   );
		END

		BEGIN
		------------------------------------------------------------------------
        --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
		SET @v_log_type = '4';
		SET @v_log_message = '########## ERROR Multiple Currency ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;


		/* #################################################### */
		/* DIVISION  체크											*/
		/* #################################################### */
		--81 사업부만 처리
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Division.'
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND		ATTRIBUTE1 NOT LIKE '81%'
			END;

			BEGIN
			------------------------------------------------------------------------
			--scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
			SET @v_log_type = '5';
			SET @v_log_message = '########## Invalid Division ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
		END;


		/* #################################################### */
		/* TEAM 체크											*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid TEAM.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_MST_SSO_DEPT_INFO DI WITH(NOLOCK)
								   WHERE 1 = 1
									 AND DEPT_NAME_KO = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
									 AND DI.VALID_YN = 'Y'
									)	 ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid TEAM. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* END CUSTOMER 체크									*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid END CUSTOMER.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_MST_SITE MS WITH(NOLOCK)
								   WHERE 1 = 1
									 AND MS.DIVISION_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
									 AND MS.END_CUSTOMER = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
									 AND MS.VALID_YN = 'Y'
									)	 ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid END CUSTOMER. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* PROJECT CODE 체크									*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid PROJECT CODE.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_MST_PROJECT MP WITH(NOLOCK)
								   WHERE 1 = 1
									 AND MP.DIVISION_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
									 AND MP.PROJECT_CODE = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
									)	 ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid PROJECT CODE. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* CURRENCY 체크										*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid CURRENCY.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS  (  SELECT 1
									FROM DM_MST_EXCHANGE_RATE ER WITH(NOLOCK)
								   WHERE 1 = 1
									 AND ER.DIVISION_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
									 AND ER.UNIT_CURRENCY = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5
									)	 ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid CURRENCY. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* MODEL 체크										*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid MODEL.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ISNULL(ATTRIBUTE6, '') <> ''
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_MST_SITE MS WITH(NOLOCK)
									INNER JOIN SCM_MST_SSO_DEPT_INFO DI WITH(NOLOCK)
											ON MS.DEPT_ID = DI.DEPT_ID
											AND DEPT_NAME_KO = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
											AND DI.VALID_YN = 'Y'
									INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
										ON ITM.DIVISION_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
										AND ITM.PROJECT_CODE = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
										AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
										AND ITM.ITEM_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
										AND ITM.VALID_YN = 'Y'
								   WHERE 1 = 1
									 AND MS.DIVISION_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
									 AND MS.END_CUSTOMER = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
									 AND MS.VALID_YN = 'Y'
									)	 ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid MODEL. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* 숫자여부 체크										*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid NUMERIC.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND 
			   (
					(ISNULL(ATTRIBUTE7, '') <> '' AND ISNUMERIC(ATTRIBUTE7) = 0) OR--M0
					(ISNULL(ATTRIBUTE8, '') <> '' AND ISNUMERIC(ATTRIBUTE8) = 0) OR--M1
					(ISNULL(ATTRIBUTE9, '') <> '' AND ISNUMERIC(ATTRIBUTE9) = 0) OR--M2
					(ISNULL(ATTRIBUTE10, '') <> '' AND ISNUMERIC(ATTRIBUTE10) = 0) OR--M3
					(ISNULL(ATTRIBUTE11, '') <> '' AND ISNUMERIC(ATTRIBUTE11) = 0) OR--M4
					(ISNULL(ATTRIBUTE12, '') <> '' AND ISNUMERIC(ATTRIBUTE12) = 0) OR--M5
					(ISNULL(ATTRIBUTE13, '') <> '' AND ISNUMERIC(ATTRIBUTE13) = 0) OR--M6
					(ISNULL(ATTRIBUTE14, '') <> '' AND ISNUMERIC(ATTRIBUTE14) = 0) OR--M7
					(ISNULL(ATTRIBUTE15, '') <> '' AND ISNUMERIC(ATTRIBUTE15) = 0) OR--M8
					(ISNULL(ATTRIBUTE16, '') <> '' AND ISNUMERIC(ATTRIBUTE16) = 0) OR--M9
					(ISNULL(ATTRIBUTE17, '') <> '' AND ISNUMERIC(ATTRIBUTE17) = 0) OR--M10
					(ISNULL(ATTRIBUTE18, '') <> '' AND ISNUMERIC(ATTRIBUTE18) = 0) OR--M11
					(ISNULL(ATTRIBUTE19, '') <> '' AND ISNUMERIC(ATTRIBUTE19) = 0) --M12
			   )

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid NUMERIC. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;


		/* #################################################### */
		/* 마이너스 여부 체크										*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Negative Number.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND 
			   (
					(ISNULL(ATTRIBUTE7, '') <> '' AND ISNUMERIC(ATTRIBUTE7) = 1 AND CONVERT(FLOAT, ATTRIBUTE7) < 0) OR--M0
					(ISNULL(ATTRIBUTE8, '') <> '' AND ISNUMERIC(ATTRIBUTE8) = 1 AND CONVERT(FLOAT, ATTRIBUTE8) < 0) OR--M1
					(ISNULL(ATTRIBUTE9, '') <> '' AND ISNUMERIC(ATTRIBUTE9) = 1 AND CONVERT(FLOAT, ATTRIBUTE9) < 0) OR--M2
					(ISNULL(ATTRIBUTE10, '') <> '' AND ISNUMERIC(ATTRIBUTE10) = 1 AND CONVERT(FLOAT, ATTRIBUTE10) < 0) OR--M3
					(ISNULL(ATTRIBUTE11, '') <> '' AND ISNUMERIC(ATTRIBUTE11) = 1 AND CONVERT(FLOAT, ATTRIBUTE11) < 0) OR--M4
					(ISNULL(ATTRIBUTE12, '') <> '' AND ISNUMERIC(ATTRIBUTE12) = 1 AND CONVERT(FLOAT, ATTRIBUTE12) < 0) OR--M5
					(ISNULL(ATTRIBUTE13, '') <> '' AND ISNUMERIC(ATTRIBUTE13) = 1 AND CONVERT(FLOAT, ATTRIBUTE13) < 0) OR--M6
					(ISNULL(ATTRIBUTE14, '') <> '' AND ISNUMERIC(ATTRIBUTE14) = 1 AND CONVERT(FLOAT, ATTRIBUTE14) < 0) OR--M7
					(ISNULL(ATTRIBUTE15, '') <> '' AND ISNUMERIC(ATTRIBUTE15) = 1 AND CONVERT(FLOAT, ATTRIBUTE15) < 0) OR--M8
					(ISNULL(ATTRIBUTE16, '') <> '' AND ISNUMERIC(ATTRIBUTE16) = 1 AND CONVERT(FLOAT, ATTRIBUTE16) < 0) OR--M9
					(ISNULL(ATTRIBUTE17, '') <> '' AND ISNUMERIC(ATTRIBUTE17) = 1 AND CONVERT(FLOAT, ATTRIBUTE17) < 0) OR--M10
					(ISNULL(ATTRIBUTE18, '') <> '' AND ISNUMERIC(ATTRIBUTE18) = 1 AND CONVERT(FLOAT, ATTRIBUTE18) < 0) OR--M11
					(ISNULL(ATTRIBUTE19, '') <> '' AND ISNUMERIC(ATTRIBUTE19) = 1 AND CONVERT(FLOAT, ATTRIBUTE19) < 0) --M12
			   )

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Negative Number. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;


		/* #################################################### */
		/* 0 여부 체크										*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Zero Number.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND 
			   (
					(ISNULL(ATTRIBUTE7, '') <> '' AND ISNUMERIC(ATTRIBUTE7) = 1 AND CONVERT(FLOAT, ATTRIBUTE7) = 0) OR--M0
					(ISNULL(ATTRIBUTE8, '') <> '' AND ISNUMERIC(ATTRIBUTE8) = 1 AND CONVERT(FLOAT, ATTRIBUTE8) = 0) OR--M1
					(ISNULL(ATTRIBUTE9, '') <> '' AND ISNUMERIC(ATTRIBUTE9) = 1 AND CONVERT(FLOAT, ATTRIBUTE9) = 0) OR--M2
					(ISNULL(ATTRIBUTE10, '') <> '' AND ISNUMERIC(ATTRIBUTE10) = 1 AND CONVERT(FLOAT, ATTRIBUTE10) = 0) OR--M3
					(ISNULL(ATTRIBUTE11, '') <> '' AND ISNUMERIC(ATTRIBUTE11) = 1 AND CONVERT(FLOAT, ATTRIBUTE11) = 0) OR--M4
					(ISNULL(ATTRIBUTE12, '') <> '' AND ISNUMERIC(ATTRIBUTE12) = 1 AND CONVERT(FLOAT, ATTRIBUTE12) = 0) OR--M5
					(ISNULL(ATTRIBUTE13, '') <> '' AND ISNUMERIC(ATTRIBUTE13) = 1 AND CONVERT(FLOAT, ATTRIBUTE13) = 0) OR--M6
					(ISNULL(ATTRIBUTE14, '') <> '' AND ISNUMERIC(ATTRIBUTE14) = 1 AND CONVERT(FLOAT, ATTRIBUTE14) = 0) OR--M7
					(ISNULL(ATTRIBUTE15, '') <> '' AND ISNUMERIC(ATTRIBUTE15) = 1 AND CONVERT(FLOAT, ATTRIBUTE15) = 0) OR--M8
					(ISNULL(ATTRIBUTE16, '') <> '' AND ISNUMERIC(ATTRIBUTE16) = 1 AND CONVERT(FLOAT, ATTRIBUTE16) = 0) OR--M9
					(ISNULL(ATTRIBUTE17, '') <> '' AND ISNUMERIC(ATTRIBUTE17) = 1 AND CONVERT(FLOAT, ATTRIBUTE17) = 0) OR--M10
					(ISNULL(ATTRIBUTE18, '') <> '' AND ISNUMERIC(ATTRIBUTE18) = 1 AND CONVERT(FLOAT, ATTRIBUTE18) = 0) OR--M11
					(ISNULL(ATTRIBUTE19, '') <> '' AND ISNUMERIC(ATTRIBUTE19) = 1 AND CONVERT(FLOAT, ATTRIBUTE19) = 0) --M12
			   )

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Zero Number. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/*  item별로 1개의 currency만 등록되게 기존 데이터 체크하여 튕겨냄					*/
		/* ATTRIBUTE1  : Div									*/
		/* ATTRIBUTE2  : Team									*/
		/* ATTRIBUTE3  : End Customer							*/
		/* ATTRIBUTE4 : Project Code							*/
		/* ATTRIBUTE5 : Currency								*/
		/* ATTRIBUTE6 : Model									*/
		/* #################################################### */
		BEGIN
			--ITEM 입력 안된 경우는 프로젝트 하위의 전체 ITEM을 체크
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = N'동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND EXISTS  (  SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), GETDATE(), 112) --M0
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7 <> '' --M0 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH,1 , GETDATE()), 112) --M1
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE8 <> '' --M1 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 2, GETDATE()), 112) --M2
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE9 <> '' --M2 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 3, GETDATE()), 112) --M3
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10 <> '' --M3 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 4, GETDATE()), 112) --M4
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE11 <> '' --M4 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 5, GETDATE()), 112) --M5
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12 <> '' --M5 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 6, GETDATE()), 112) --M6
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13 <> '' --M6 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 7, GETDATE()), 112) --M7
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE14 <> '' --M7 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 8, GETDATE()), 112) --M8
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE15 <> '' --M8 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 9, GETDATE()), 112) --M9
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE16 <> '' --M9 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 10, GETDATE()), 112) --M10
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE17 <> '' --M10 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 11, GETDATE()), 112) --M11
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE18 <> '' --M11 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 12, GETDATE()), 112) --M12
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE19 <> '' --M12 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
						)	 
				AND ISNULL(ATTRIBUTE6, '') = '' --item_id 입력 안된건
				;

			--ITEM 입력된 경우
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = N'동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND EXISTS  (  SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), GETDATE(), 112) --M0
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
									AND FP.ITEM_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7 <> '' --M0 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 1, GETDATE()), 112) --M1
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
									AND FP.ITEM_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE8 <> '' --M1 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 2, GETDATE()), 112) --M2
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
									AND FP.ITEM_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE9 <> '' --M2 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 3, GETDATE()), 112) --M3
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
									AND FP.ITEM_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10 <> '' --M3 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 4, GETDATE()), 112) --M4
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
									AND FP.ITEM_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE11 <> '' --M4 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 5, GETDATE()), 112) --M5
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
									AND FP.ITEM_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12 <> '' --M5 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 6, GETDATE()), 112) --M6
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
									AND FP.ITEM_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13 <> '' --M6 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 7, GETDATE()), 112) --M7
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
									AND FP.ITEM_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE14 <> '' --M7 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 8, GETDATE()), 112) --M8
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
									AND FP.ITEM_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE15 <> '' --M8 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 9, GETDATE()), 112) --M9
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
									AND FP.ITEM_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE16 <> '' --M9 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 10, GETDATE()), 112) --M10
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
									AND FP.ITEM_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE17 <> '' --M10 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 11, GETDATE()), 112) --M11
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
									AND FP.ITEM_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE18 <> '' --M11 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
								UNION ALL
								SELECT 1
								FROM SCM_MST_SITE MS WITH(NOLOCK)
								INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
									ON ITM.DIVISION_ID = MS.DIVISION_ID
									AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
									AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
									AND ITM.VALID_YN = 'Y'
								INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
									ON  FP.DIVISION_ID = ITM.DIVISION_ID
									AND FP.PROJECT_CODE = ITM.PROJECT_CODE
									AND FP.SCM_SITE_ID = ITM.SCM_SITE_ID
									AND SUBSTRING(FP.YYYYMMDD, 1, 6) = CONVERT(VARCHAR(6), DATEADD(MONTH, 12, GETDATE()), 112) --M12
									AND FP.MEASURE = 'LOC'
									AND FP.ITEM_ID = ITM.ITEM_ID
									AND FP.ITEM_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
								WHERE MS.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
								AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
								AND MS.VALID_YN = 'Y'
								AND SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE19 <> '' --M12 에 값이 있는것
								AND FP.CURRENCY <> SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5 --CURRENCY가 다를 경우만 체크
						)	 
				AND ISNULL(ATTRIBUTE6, '') <> '' --item_id 입력 된건
				;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## ERROR Multiple Currency ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
		
		-- 정상(SUCCESS) 처리
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'SUCCESS'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121)  = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD';
		END;

		BEGIN
        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	    SET @v_log_type = '16';
	    SET @v_log_message = '########## SUCCESS ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------------------------
		END;

	END

------------------------------------- validation 로직 종료 ----------------------------------------------
------------------------------------- validation 로직 종료 ----------------------------------------------
------------------------------------- validation 로직 종료 ----------------------------------------------

	BEGIN
    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	SET @v_log_type = '17';
	SET @v_log_message = '########## INSERT DATA START ##########';
	SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    ----------------------------------------------------------------------------
	END;

	--// SCM_UI_EXCEL_UPLOAD_T =>  DMR_CAPA_ALLOC_M
    --//======================================================================================
    SELECT @v_count = COUNT(1)
    FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
    WHERE  T.PROGRAM_ID         = @v_program_id
    AND    T.SHEET_NAME         = @v_sheet_name
    AND    T.CREATED_BY         = @p_created_by
    AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
    AND    T.UPLOAD_STATUS_CODE = 'ERROR' ;




	--실제 업무처리
	IF @p_mode > 0 AND @v_count = 0	
	BEGIN

		--------------------------------------------------
		-- 엑셀 업로드용 TMP 테이블 생성 및 데이터 저장
		--------------------------------------------------
		BEGIN TRANSACTION SALES_PRICE;
		BEGIN TRY
			IF OBJECT_ID('TEMPDB..#TMP_EXCEL_UPLOAD') IS NOT NULL
				DROP TABLE #TMP_EXCEL_UPLOAD;
			IF OBJECT_ID('TEMPDB..#TMP_UPLOAD_MASTER_STEP1') IS NOT NULL
				DROP TABLE #TMP_UPLOAD_MASTER_STEP1;
			IF OBJECT_ID('TEMPDB..#TMP_UPLOAD_MASTER_STEP2') IS NOT NULL
				DROP TABLE #TMP_UPLOAD_MASTER_STEP2;
			IF OBJECT_ID('TEMPDB..#TMP_UPLOAD_MASTER_FINAL') IS NOT NULL
				DROP TABLE #TMP_UPLOAD_MASTER_FINAL;
			IF OBJECT_ID('TEMPDB..#TEMP_EXCH') IS NOT NULL
				DROP TABLE #TEMP_EXCH;
			IF OBJECT_ID('TEMPDB..#TMP_UPLOAD_MASTER_WITH_ITEM') IS NOT NULL
				DROP TABLE #TMP_UPLOAD_MASTER_WITH_ITEM;

				-- 환율 테이블
			CREATE TABLE #TEMP_EXCH (
						DIVISION_ID			NVARCHAR(30) NOT NULL
					, YYYYMMDD				NVARCHAR(8)  NOT NULL
					, CURRENCY				NVARCHAR(10) NOT NULL
					, UNIT_CURRENCY			NVARCHAR(10) NOT NULL
					, EXCHANGE_PRICE		NUMERIC(20,10) NOT NULL
					)	


			CREATE TABLE #TMP_EXCEL_UPLOAD(
				DIVISION_ID		NVARCHAR(100),
				TEAM_NAME		NVARCHAR(100),
				END_CUST		NVARCHAR(100),
				PROJECT_CODE	NVARCHAR(100),
				CURRENCY		NVARCHAR(100),	
				MODEL			NVARCHAR(100),	
				M0				NVARCHAR(100),	
				M1				NVARCHAR(100),	
				M2				NVARCHAR(100),	
				M3				NVARCHAR(100),	
				M4				NVARCHAR(100),	
				M5				NVARCHAR(100),	
				M6				NVARCHAR(100),	
				M7				NVARCHAR(100),	
				M8				NVARCHAR(100),	
				M9				NVARCHAR(100),	
				M10				NVARCHAR(100),	
				M11				NVARCHAR(100),	
				M12				NVARCHAR(100)
			)

			--그냥 빈값을 넣어도 되나 추후 UNPIVOT시 제대로 되지 않을까 우려하여 0으로 놓고 나중에 걸러내기로 함
			INSERT INTO #TMP_EXCEL_UPLOAD
			SELECT
			ATTRIBUTE1	--DIVISION_ID
			,ATTRIBUTE2	--TEAM_NAME
			,ATTRIBUTE3	--END_CUST
			,ATTRIBUTE4	--PROJECT_CODE
			,ATTRIBUTE5	--CURRENCY
			,ATTRIBUTE6	--MODEL
			,CASE WHEN ATTRIBUTE7 = '' THEN '0' ELSE ATTRIBUTE7 END		--M0 빈값이면 0 처리
			,CASE WHEN ATTRIBUTE8  = '' THEN '0' ELSE ATTRIBUTE8 END	--M1
			,CASE WHEN ATTRIBUTE9  = '' THEN '0' ELSE ATTRIBUTE9 END	--M2
			,CASE WHEN ATTRIBUTE10 = '' THEN '0' ELSE ATTRIBUTE10 END	--M3
			,CASE WHEN ATTRIBUTE11 = '' THEN '0' ELSE ATTRIBUTE11 END	--M4
			,CASE WHEN ATTRIBUTE12 = '' THEN '0' ELSE ATTRIBUTE12 END	--M5
			,CASE WHEN ATTRIBUTE13 = '' THEN '0' ELSE ATTRIBUTE13 END	--M6
			,CASE WHEN ATTRIBUTE14 = '' THEN '0' ELSE ATTRIBUTE14 END	--M7
			,CASE WHEN ATTRIBUTE15 = '' THEN '0' ELSE ATTRIBUTE15 END	--M8
			,CASE WHEN ATTRIBUTE16 = '' THEN '0' ELSE ATTRIBUTE16 END	--M9
			,CASE WHEN ATTRIBUTE17 = '' THEN '0' ELSE ATTRIBUTE17 END	--M10
			,CASE WHEN ATTRIBUTE18 = '' THEN '0' ELSE ATTRIBUTE18 END	--M11
			,CASE WHEN ATTRIBUTE19 = '' THEN '0' ELSE ATTRIBUTE19 END	--M12
			FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD]  WITH(NOLOCK)
			WHERE  1 = 1
			AND    PROGRAM_ID    = @v_program_id
			AND    SHEET_NAME    = @v_sheet_name
			AND    CREATED_BY    = @p_created_by
			AND    UPLOAD_STATUS_CODE = 'SUCCESS'
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) =  @v_creation_date


				--------------------------------------------------
				-- 이를 기반으로 Upload Master 구성
				/*
			1. Team & End Customer -> 포함되는 Sales Site를 찾아옴
			2. Division, Site, Project 기반으로 SSPM에 Item 목록을 찾아옴
			3. Division, Site, Project, Item, Currency 단위의 Upload Master 구성
			4. SCM_MST_FUTURE_PRICE, DM_PLN_SALES_PLAN 에서 Upload Master에 포함된 PK* 목록을 추출
			*PK: DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, FCST_TYPE, DOM_EXP, CURRENCY, PLANT_SITE
	
				*/
				--------------------------------------------------

			--------------------------------------------------
			--item_id 없는 데이터셋 추출
			--------------------------------------------------
			SELECT *
			INTO #TMP_UPLOAD_MASTER_STEP1
			FROM
			(
				SELECT
				TMP.DIVISION_ID
				,MS.SCM_SITE_ID
				,TMP.PROJECT_CODE
				,ITM.ITEM_ID
				,TMP.CURRENCY
				,FP.INCOTERMS
				,FP.DOM_EXP
				,FP.PLANT_SITE_ID
				,FP.FCST_TYPE
				,TMP.M0
				,TMP.M1		
				,TMP.M2	
				,TMP.M3	
				,TMP.M4	
				,TMP.M5	
				,TMP.M6	
				,TMP.M7	
				,TMP.M8	
				,TMP.M9	
				,TMP.M10	
				,TMP.M11	
				,TMP.M12
				FROM #TMP_EXCEL_UPLOAD TMP
				INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
					ON MS.DIVISION_ID = TMP.DIVISION_ID
					AND MS.END_CUSTOMER = TMP.END_CUST
					AND MS.VALID_YN = 'Y'
				INNER JOIN SCM_MST_SSO_DEPT_INFO DI WITH(NOLOCK)
						ON MS.DEPT_ID = DI.DEPT_ID
						AND DEPT_NAME_KO = TMP.TEAM_NAME
						AND DI.VALID_YN = 'Y'
				INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
					ON ITM.DIVISION_ID = TMP.DIVISION_ID
					AND ITM.PROJECT_CODE = TMP.PROJECT_CODE
					AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
					AND ITM.VALID_YN = 'Y'
				INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
					ON FP.DIVISION_ID = TMP.DIVISION_ID
					AND FP.PROJECT_CODE = TMP.PROJECT_CODE
					AND FP.SCM_SITE_ID = MS.SCM_SITE_ID
					AND FP.ITEM_ID = ITM.ITEM_ID
					AND FP.MEASURE = 'LOC'
				WHERE ISNULL(TMP.MODEL, '') = '' --item_id 입력 안된건(전체데이터셋)
				UNION
				SELECT 
				TMP.DIVISION_ID
				,MS.SCM_SITE_ID
				,TMP.PROJECT_CODE
				,ITM.ITEM_ID
				,TMP.CURRENCY
				,PN.INCOTERMS
				,PN.DOM_EXP
				,PN.PLANT_SITE_ID
				,PN.FCST_TYPE
				,TMP.M0
				,TMP.M1		
				,TMP.M2	
				,TMP.M3	
				,TMP.M4	
				,TMP.M5	
				,TMP.M6	
				,TMP.M7	
				,TMP.M8	
				,TMP.M9	
				,TMP.M10	
				,TMP.M11	
				,TMP.M12
				FROM #TMP_EXCEL_UPLOAD TMP
				INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
					ON MS.DIVISION_ID = TMP.DIVISION_ID
					AND MS.END_CUSTOMER = TMP.END_CUST
					AND MS.VALID_YN = 'Y'
				INNER JOIN SCM_MST_SSO_DEPT_INFO DI WITH(NOLOCK)
						ON MS.DEPT_ID = DI.DEPT_ID
						AND DEPT_NAME_KO = TMP.TEAM_NAME
						AND DI.VALID_YN = 'Y'
				INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
					ON ITM.DIVISION_ID = TMP.DIVISION_ID
					AND ITM.PROJECT_CODE = TMP.PROJECT_CODE
					AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
					AND ITM.VALID_YN = 'Y'
				INNER JOIN DM_PLN_SALES_PLAN PN WITH(NOLOCK)
					ON PN.DIVISION_ID = TMP.DIVISION_ID
					AND PN.PROJECT_CODE = TMP.PROJECT_CODE
					AND PN.SCM_SITE_ID = MS.SCM_SITE_ID
					AND PN.ITEM_ID = ITM.ITEM_ID
					AND PN.MEASURE = 'RTF_SYS_RP'
				WHERE ISNULL(TMP.MODEL, '') = '' --item_id 입력 안된건(전체데이터셋)
				--------------------------------------------------------------------
			) A

			--------------------------------------------------
			--item_id 있는 데이터셋 추출
			--------------------------------------------------

			SELECT *
			INTO #TMP_UPLOAD_MASTER_WITH_ITEM
			FROM
			(
				SELECT
				TMP.DIVISION_ID
				,MS.SCM_SITE_ID
				,TMP.PROJECT_CODE
				,ITM.ITEM_ID
				,TMP.CURRENCY
				,FP.INCOTERMS
				,FP.DOM_EXP
				,FP.PLANT_SITE_ID
				,FP.FCST_TYPE
				,TMP.M0
				,TMP.M1		
				,TMP.M2	
				,TMP.M3	
				,TMP.M4	
				,TMP.M5	
				,TMP.M6	
				,TMP.M7	
				,TMP.M8	
				,TMP.M9	
				,TMP.M10	
				,TMP.M11	
				,TMP.M12
				FROM #TMP_EXCEL_UPLOAD TMP
				INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
					ON MS.DIVISION_ID = TMP.DIVISION_ID
					AND MS.END_CUSTOMER = TMP.END_CUST
					AND MS.VALID_YN = 'Y'
				INNER JOIN SCM_MST_SSO_DEPT_INFO DI WITH(NOLOCK)
						ON MS.DEPT_ID = DI.DEPT_ID
						AND DEPT_NAME_KO = TMP.TEAM_NAME
						AND DI.VALID_YN = 'Y'
				INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
					ON ITM.DIVISION_ID = TMP.DIVISION_ID
					AND ITM.PROJECT_CODE = TMP.PROJECT_CODE
					AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
					AND ITM.ITEM_ID = TMP.MODEL
					AND ITM.VALID_YN = 'Y'
				INNER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
					ON FP.DIVISION_ID = TMP.DIVISION_ID
					AND FP.PROJECT_CODE = TMP.PROJECT_CODE
					AND FP.SCM_SITE_ID = MS.SCM_SITE_ID
					AND FP.ITEM_ID = ITM.ITEM_ID
					AND FP.MEASURE = 'LOC'
				UNION
				SELECT 
				TMP.DIVISION_ID
				,MS.SCM_SITE_ID
				,TMP.PROJECT_CODE
				,ITM.ITEM_ID
				,TMP.CURRENCY
				,PN.INCOTERMS
				,PN.DOM_EXP
				,PN.PLANT_SITE_ID
				,PN.FCST_TYPE
				,TMP.M0
				,TMP.M1		
				,TMP.M2	
				,TMP.M3	
				,TMP.M4	
				,TMP.M5	
				,TMP.M6	
				,TMP.M7	
				,TMP.M8	
				,TMP.M9	
				,TMP.M10	
				,TMP.M11	
				,TMP.M12
				FROM #TMP_EXCEL_UPLOAD TMP
				INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
					ON MS.DIVISION_ID = TMP.DIVISION_ID
					AND MS.END_CUSTOMER = TMP.END_CUST
					AND MS.VALID_YN = 'Y'
				INNER JOIN SCM_MST_SSO_DEPT_INFO DI WITH(NOLOCK)
						ON MS.DEPT_ID = DI.DEPT_ID
						AND DEPT_NAME_KO = TMP.TEAM_NAME
						AND DI.VALID_YN = 'Y'
				INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
					ON ITM.DIVISION_ID = TMP.DIVISION_ID
					AND ITM.PROJECT_CODE = TMP.PROJECT_CODE
					AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
					AND ITM.ITEM_ID = TMP.MODEL
					AND ITM.VALID_YN = 'Y'
				INNER JOIN DM_PLN_SALES_PLAN PN WITH(NOLOCK)
					ON PN.DIVISION_ID = TMP.DIVISION_ID
					AND PN.PROJECT_CODE = TMP.PROJECT_CODE
					AND PN.SCM_SITE_ID = MS.SCM_SITE_ID
					AND PN.ITEM_ID = ITM.ITEM_ID
					AND PN.MEASURE = 'RTF_SYS_RP'
			) A


			----===============================================================================
			--두 데이터셋 합치기

			/* ITEM있는 항목(#TMP_UPLOAD_MASTER_WITH_ITEM)의 값이 '0'이면 원래값 유지*/
			MERGE INTO #TMP_UPLOAD_MASTER_STEP1 AS A
			USING #TMP_UPLOAD_MASTER_WITH_ITEM AS B
			   ON (
					A.DIVISION_ID = B.DIVISION_ID
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.ITEM_ID = B.ITEM_ID
						AND A.CURRENCY = B.CURRENCY
						AND A.INCOTERMS = B.INCOTERMS
						AND A.DOM_EXP = B.DOM_EXP
						AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
						AND A.FCST_TYPE = B.FCST_TYPE				   
				)
			WHEN MATCHED THEN
				UPDATE SET 
					/*A.M0 = B.M0
					,A.M1 = B.M1
					,A.M2 = B.M2
					,A.M3 = B.M3
					,A.M4 = B.M4
					,A.M5 = B.M5
					,A.M6 = B.M6
					,A.M7 = B.M7
					,A.M8 = B.M8
					,A.M9 = B.M9
					,A.M10 = B.M10
					,A.M11 = B.M11
					,A.M12 = B.M12
					*/
					A.M0 = CASE WHEN B.M0 = '0' THEN A.M0 ELSE B.M0 END
					,A.M1 = CASE WHEN B.M1 = '0' THEN A.M1 ELSE B.M1 END
					,A.M2 = CASE WHEN B.M2 = '0' THEN A.M2 ELSE B.M2 END
					,A.M3 = CASE WHEN B.M3 = '0' THEN A.M3 ELSE B.M3 END
					,A.M4 = CASE WHEN B.M4 = '0' THEN A.M4 ELSE B.M4 END
					,A.M5 = CASE WHEN B.M5 = '0' THEN A.M5 ELSE B.M5 END
					,A.M6 = CASE WHEN B.M6 = '0' THEN A.M6 ELSE B.M6 END
					,A.M7 = CASE WHEN B.M7 = '0' THEN A.M7 ELSE B.M7 END
					,A.M8 = CASE WHEN B.M8 = '0' THEN A.M8 ELSE B.M8 END
					,A.M9 = CASE WHEN B.M9 = '0' THEN A.M9 ELSE B.M9 END
					,A.M10 = CASE WHEN B.M10 = '0' THEN A.M10 ELSE B.M10 END
					,A.M11 = CASE WHEN B.M11 = '0' THEN A.M11 ELSE B.M11 END
					,A.M12 = CASE WHEN B.M12 = '0' THEN A.M12 ELSE B.M12 END
			WHEN NOT MATCHED THEN
				INSERT 
				(	
						DIVISION_ID
						,SCM_SITE_ID
						,PROJECT_CODE
						,ITEM_ID
						,CURRENCY
						,INCOTERMS
						,DOM_EXP
						,PLANT_SITE_ID
						,FCST_TYPE
						,M0
						,M1		
						,M2	
						,M3	
						,M4	
						,M5	
						,M6	
						,M7	
						,M8	
						,M9	
						,M10	
						,M11	
						,M12
					)
				VALUES
				(
					B.DIVISION_ID
					,B.SCM_SITE_ID
					,B.PROJECT_CODE
					,B.ITEM_ID
					,B.CURRENCY
					,B.INCOTERMS
					,B.DOM_EXP
					,B.PLANT_SITE_ID
					,B.FCST_TYPE
					,B.M0
					,B.M1		
					,B.M2	
					,B.M3	
					,B.M4	
					,B.M5	
					,B.M6	
					,B.M7	
					,B.M8	
					,B.M9	
					,B.M10	
					,B.M11	
					,B.M12
				);


			--------------------------------------------------
			-- 5. 추출된 PK 기준으로 LOC Measure의 가격을 Upload Master 기준 가격으로 Calendar Join해서 주차별 반영(Insert / Update, 52주 구간)
			--------------------------------------------------
			--월별로 UNPIVOT하여 실제 월 구하기(#TMP_UPLOAD_MASTER_STEP2)
			SELECT *
			,CASE MM WHEN 'M0' THEN CONVERT(VARCHAR(6), GETDATE(), 112)
				WHEN 'M1' THEN CONVERT(VARCHAR(6), DATEADD(MONTH, 1, GETDATE()), 112)
				WHEN 'M2' THEN CONVERT(VARCHAR(6), DATEADD(MONTH, 2, GETDATE()), 112)
				WHEN 'M3' THEN CONVERT(VARCHAR(6), DATEADD(MONTH, 3, GETDATE()), 112)
				WHEN 'M4' THEN CONVERT(VARCHAR(6), DATEADD(MONTH, 4, GETDATE()), 112)
				WHEN 'M5' THEN CONVERT(VARCHAR(6), DATEADD(MONTH, 5, GETDATE()), 112)
				WHEN 'M6' THEN CONVERT(VARCHAR(6), DATEADD(MONTH, 6, GETDATE()), 112)
				WHEN 'M7' THEN CONVERT(VARCHAR(6), DATEADD(MONTH, 7, GETDATE()), 112)
				WHEN 'M8' THEN CONVERT(VARCHAR(6), DATEADD(MONTH, 8, GETDATE()), 112)
				WHEN 'M9' THEN CONVERT(VARCHAR(6), DATEADD(MONTH, 9, GETDATE()), 112)
				WHEN 'M10' THEN CONVERT(VARCHAR(6), DATEADD(MONTH, 10, GETDATE()), 112)
				WHEN 'M11' THEN CONVERT(VARCHAR(6), DATEADD(MONTH, 11, GETDATE()), 112)
				WHEN 'M12' THEN CONVERT(VARCHAR(6), DATEADD(MONTH, 12, GETDATE()), 112)
			END MM2
			INTO #TMP_UPLOAD_MASTER_STEP2
			FROM
			(
				SELECT * FROM #TMP_UPLOAD_MASTER_STEP1
			) RAWDATA
			UNPIVOT
			(
				LOC FOR MM IN (
					M0,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12
				)
			) AS UNPIVOT_DATA

			--SELECT * FROM #TMP_UPLOAD_MASTER_STEP2 ORDER BY MM2
			--------------------------------------------

				--5-1)Upload Master와 CALENDAR 테이블 조인하여 주차별로 ROW 생성
				--52주차

			--------------------------------------------
			SELECT DISTINCT TMP.*
			, CAL.BASIS_START_DATE
			, 'LOC' MEASURE--엑셀 입력값은 LOC 메저로 간주
			INTO #TMP_UPLOAD_MASTER_FINAL
			FROM #TMP_UPLOAD_MASTER_STEP2 TMP
			INNER JOIN 
			(
				SELECT DISTINCT
				SUBSTRING(BASIS_START_DATE, 1, 6) YYYYMM 
				,BASIS_START_DATE
				FROM SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
				WHERE CAL.BASIS_YYYYMMDD >= CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)  
				AND CAL.BASIS_YYYYMMDD < CONVERT(CHAR(8), DATEADD(WW, 52, CURRENT_TIMESTAMP), 112) 
			) CAL
			ON TMP.MM2 = CAL.YYYYMM
			WHERE CONVERT(FLOAT, TMP.LOC) > 0-- 0 이상만 처리 (빈값 제외)

			--WHERE ISNULL(TMP.LOC, '') <> '' -- 빈값 제외
			--AND CONVERT(INT, TMP.LOC) > 0 -- 0 이상

			ORDER BY TMP.MM2, CAL.BASIS_START_DATE

			--SELECT * FROM #TMP_UPLOAD_MASTER_FINAL
			--------------------------------------------

			--5-2)환율데이터 생성
			--DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP 참고(404 라인)
			-- LOC / KRW / USD 3개쌍으로 메저 생성
			--------------------------------------------

			INSERT INTO #TEMP_EXCH (DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE)
			SELECT DISTINCT A.DIVISION_ID, A.YYYYMMDD, A.CURRENCY, A.UNIT_CURRENCY, A.EXCHANGE_PRICE
			FROM DM_MST_EXCHANGE_RATE A
			JOIN #TMP_UPLOAD_MASTER_STEP2 B
				ON A.DIVISION_ID	= B.DIVISION_ID
				AND A.YYYYMMDD		= B.MM2 + '01'
				AND A.CURRENCY		= 'KRW'

			--SELECT * FROM #TEMP_EXCH

			--------------------------------------------
			--5-3) CURRENCY가 'KRW', 'USD'일 경우 해당 CURRENCY로 메저생성
			--환율 계산할 필요 없으므로 LOC값 그대로 저장
			--------------------------------------------
			INSERT INTO #TMP_UPLOAD_MASTER_FINAL ( 
			DIVISION_ID
			,SCM_SITE_ID
			,PROJECT_CODE
			,ITEM_ID
			,CURRENCY
			,INCOTERMS
			,DOM_EXP
			,PLANT_SITE_ID
			,FCST_TYPE
			,LOC
			,MM
			,MM2
			,BASIS_START_DATE
			,MEASURE
			)
			SELECT 		
			A.DIVISION_ID
			,A.SCM_SITE_ID
			,A.PROJECT_CODE
			,A.ITEM_ID
			,A.CURRENCY
			,A.INCOTERMS
			,A.DOM_EXP
			,A.PLANT_SITE_ID
			,A.FCST_TYPE
			,A.LOC
			,A.MM
			,A.MM2
			,A.BASIS_START_DATE
			,A.CURRENCY AS MEASURE
			FROM #TMP_UPLOAD_MASTER_FINAL A
			WHERE A.MEASURE = 'LOC'
			AND A.CURRENCY IN('KRW', 'USD')

			--------------------------------------------
			--5-4) KRW 메저 생성(기준값)  : 환율금액을 곱하여 KRW 생성
			--------------------------------------------
			INSERT INTO #TMP_UPLOAD_MASTER_FINAL ( 
			DIVISION_ID
			,SCM_SITE_ID
			,PROJECT_CODE
			,ITEM_ID
			,CURRENCY
			,INCOTERMS
			,DOM_EXP
			,PLANT_SITE_ID
			,FCST_TYPE
			,LOC
			,MM
			,MM2
			,BASIS_START_DATE
			,MEASURE
			)
			SELECT 		
			A.DIVISION_ID
			,A.SCM_SITE_ID
			,A.PROJECT_CODE
			,A.ITEM_ID
			,A.CURRENCY
			,A.INCOTERMS
			,A.DOM_EXP
			,A.PLANT_SITE_ID
			,A.FCST_TYPE
			--,A.LOC
			,ROUND(A.LOC * B.EXCHANGE_PRICE, 3)
			,A.MM
			,A.MM2
			,A.BASIS_START_DATE
			,'KRW'
			FROM #TMP_UPLOAD_MASTER_FINAL A
			JOIN #TEMP_EXCH B 
			ON B.UNIT_CURRENCY = A.CURRENCY
			AND B.YYYYMMDD = MM2 + '01'
			WHERE A.MEASURE = 'LOC'
			AND A.CURRENCY <> 'KRW'

			--------------------------------------------
			--5-5) USD 메저 생성 : KRW 기준으로 계산
			--------------------------------------------
			INSERT INTO #TMP_UPLOAD_MASTER_FINAL ( 
			DIVISION_ID
			,SCM_SITE_ID
			,PROJECT_CODE
			,ITEM_ID
			,CURRENCY
			,INCOTERMS
			,DOM_EXP
			,PLANT_SITE_ID
			,FCST_TYPE
			,LOC
			,MM
			,MM2
			,BASIS_START_DATE
			,MEASURE
			)
			SELECT  
			A.DIVISION_ID
			,A.SCM_SITE_ID
			,A.PROJECT_CODE
			,A.ITEM_ID
			,A.CURRENCY
			,A.INCOTERMS
			,A.DOM_EXP
			,A.PLANT_SITE_ID
			,A.FCST_TYPE
			--,A.LOC
			,ROUND(A.LOC / B.EXCHANGE_PRICE, 3)       
			,A.MM
			,A.MM2
			,A.BASIS_START_DATE
			,'USD'
			FROM #TMP_UPLOAD_MASTER_FINAL A
			JOIN #TEMP_EXCH B 
			ON B.UNIT_CURRENCY = 'USD'
			AND B.YYYYMMDD = MM2 + '01'
			WHERE A.MEASURE = 'KRW'
			AND A.CURRENCY <> 'USD'


			--SELECT * FROM #TMP_UPLOAD_MASTER_FINAL ORDER BY BASIS_START_DATE
			--------------------------------------------
			--6) SCM_MST_FUTURE_PRICE 저장
			--------------------------------------------
			MERGE INTO SCM_MST_FUTURE_PRICE AS A
			USING #TMP_UPLOAD_MASTER_FINAL AS B
			   ON (
					A.DIVISION_ID = B.DIVISION_ID
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
						AND A.ITEM_ID = B.ITEM_ID
						AND A.YYYYMMDD = B.BASIS_START_DATE
						AND A.CURRENCY = B.CURRENCY
						AND A.MEASURE = B.MEASURE
						AND A.DOM_EXP = B.DOM_EXP
						AND A.FCST_TYPE = B.FCST_TYPE	
						AND A.INCOTERMS = B.INCOTERMS
				)
			WHEN MATCHED THEN
				UPDATE SET 
					A.PRICE = B.LOC
					,A.LAST_UPDATED_BY = @p_created_by
					,A.LAST_UPDATE_DATE = GETDATE()
					,A.ATTRIBUTE8 = 'EXCEL UPLOAD' --엑셀업로드 여부 표시
			WHEN NOT MATCHED THEN
				INSERT 
				(	
					DIVISION_ID     
					,PROJECT_CODE    
					,SCM_SITE_ID    
					,PLANT_SITE_ID 
					,ITEM_ID         
					,YYYYMMDD        
					,CURRENCY        
					,MEASURE        
					,DOM_EXP        
					,FCST_TYPE        
					,INCOTERMS       
					,PRICE           
					,CREATED_BY      
					,CREATION_DATE   
					,LAST_UPDATED_BY 
					,LAST_UPDATE_DATE
					,ATTRIBUTE8
					)
				VALUES
				(
					B.DIVISION_ID     
					,B.PROJECT_CODE    
					,B.SCM_SITE_ID    
					,B.PLANT_SITE_ID 
					,B.ITEM_ID         
					,B.BASIS_START_DATE        
					,B.CURRENCY        
					,B.MEASURE        
					,B.DOM_EXP        
					,B.FCST_TYPE        
					,B.INCOTERMS       
					,CAST(B.LOC as numeric(20,10))
					,@p_created_by      
					,GETDATE()   
					,@p_created_by 
					,GETDATE()
					,'EXCEL UPLOAD' --엑셀업로드 여부 표시
				);

			--------------------------------------------
			--7) SCM_MST_FUTURE_PRICE_H 저장
			--------------------------------------------

			INSERT INTO  SCM_MST_FUTURE_PRICE_H
						( DIVISION_ID 
						,HISTORY_SEQ
						,PROJECT_CODE
						,SCM_SITE_ID
						,PLANT_SITE_ID
						,ITEM_ID
						,YYYYMMDD
						,CURRENCY
						,MEASURE
						,DOM_EXP
						,FCST_TYPE
						,INCOTERMS
						,PRICE
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						,ATTRIBUTE8
						)
				SELECT 
						DIVISION_ID	    
						,NEXT VALUE FOR SEQ1_SCM_MST_FUTURE_PRICE_H
						,PROJECT_CODE    
						,SCM_SITE_ID		
						,PLANT_SITE_ID	
						,ITEM_ID		    
						,BASIS_START_DATE	   	    
						,CURRENCY		    
						,MEASURE		    
						,DOM_EXP		    
						,FCST_TYPE		
						,INCOTERMS		
						,LOC            
						,@p_created_by  
						,GETDATE()  
						,@p_created_by
						,GETDATE()
						,'EXCEL UPLOAD' --엑셀업로드 여부 표시
					FROM  #TMP_UPLOAD_MASTER_FINAL



			----------------------------------------------------------------------------
			--scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
			SET @v_log_type = '21';
			SET @v_log_message = '########## INSERT DMF0020_EXCEL_UPLOAD END ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------------		   

			--COMMIT WORK;
			COMMIT TRANSACTION SALES_PRICE;

			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION SALES_PRICE;


				INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
				VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());
			END CATCH


	END

	BEGIN
    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	SET @v_log_type = 'END';
	SET @v_log_message = '########## INSERT DATA END ##########';
	SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    ----------------------------------------------------------------------------
	END;

END





