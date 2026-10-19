/*
 * Program ID  : PR_DM_PLN_CUST_FCST_RECORD
 * Description  : EDI, CUST_FCST 데이터 HISTORY에 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.04.11   chano0612	EDI, CUST_FCST 데이터 HISTORY에 저장
 
EXEC PR_DM_PLN_CUST_FCST_RECORD_TEMP '81', 'EDI', '20230101', '20230131'
EXEC PR_DM_PLN_CUST_FCST_RECORD_TEMP '81_UC', 'EDI', '20230101', '20230808'
EXEC PR_DM_PLN_CUST_FCST_RECORD_TEMP '81', 'RPA', '20230101', '20230808'
EXEC PR_DM_PLN_CUST_FCST_RECORD_TEMP '40', 'RPA', '20230101', '20230808'

 */

CREATE PROCEDURE [dbo].[PR_DM_PLN_CUST_FCST_RECORD_TEMP]
	 @p_division_id			NVARCHAR(8),	-- division_id 전달받음
	 @p_accept_flag			NVARCHAR(10),	-- 업무구분(EDI, RPA)
	 @p_from_yyyymmdd	NVARCHAR(8),	-- FROM_YYYYMMDD
	 @p_to_yyyymmdd		NVARCHAR(8)		-- TO_YYYYMMDD

AS
BEGIN

	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;											
	
	---- LOG 용 변수 설정
    DECLARE @v_program_name			NVARCHAR(150) = 'PR_DM_PLN_CUST_FCST_RECORD';
    DECLARE @v_log_type					NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count				INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);
    DECLARE @d_event_date				DATETIME;

	DECLARE @v_division_id				NVARCHAR(30);
	DECLARE @v_ifseqno_INSERT		NVARCHAR(30);
	DECLARE @v_accept_flag				NVARCHAR(10);
		
	DECLARE @v_0week_monday		NVARCHAR(08);  --W0 월요일	
	DECLARE @v_1week_monday		NVARCHAR(08);  --W1 월요일		

	DECLARE @v_from_date   		      NVARCHAR(8);	
	DECLARE @v_from_date_C		  NVARCHAR(8);
	DECLARE @v_to_date   		      NVARCHAR(8);

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = 'Div: ' + @p_division_id + '_' + @p_accept_flag
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRY

	--SET @v_from_date		= CONVERT(NVARCHAR, DATEADD(DD, -1, CONVERT(CHAR(8), GETDATE(), 112)), 112)
	--SET @v_from_date_C	= CONVERT(NVARCHAR, DATEADD(DD, -30, CONVERT(CHAR(8), GETDATE(), 112)), 112)
	----SET @v_from_date   = '20230508'
	----SET @v_from_date_C = '20230508'

	--SET @v_0week_monday = CONVERT(CHAR(8), DATEADD(DD, -7,				DBO.FN_NEXT_DAY(CONVERT(VARCHAR,GETDATE(),112), 'MON')), 112)  --W0월요일	
	--SET @v_1week_monday = CONVERT(CHAR(8), DATEADD(DD, -7+7,			DBO.FN_NEXT_DAY(CONVERT(VARCHAR,GETDATE(),112), 'MON')), 112)  --W1월요일		

	SET @v_division_id = @p_division_id
	SET @v_accept_flag = @p_accept_flag
	SET @v_from_date = @p_from_yyyymmdd
	SET @v_to_date = @p_to_yyyymmdd

		--******************** EDI DATA 생성 START ********************
		BEGIN

			IF @v_accept_flag = 'EDI'

				--******************** ATTRIBUTE10 <> 'C'인 데이터 처리 ********************
				BEGIN
			
					-- 테이블중복제거
					IF OBJECT_ID (N'tempdb..#TEMP_EDI_ALL', N'U')			IS NOT NULL	DROP TABLE #TEMP_EDI_ALL			

					-- 임시확인용테이블 중복제거
					IF OBJECT_ID (N'dbo.#TEMP_EDI_ALL', N'U')					IS NOT NULL	DROP TABLE #TEMP_EDI_ALL	

					--#TEMP_EDI_NEW_ALL	
					CREATE TABLE #TEMP_EDI_ALL	(
						NUM					INT	NULL,
						IFSEQNO			NVARCHAR(35)	NULL);

					--EDI STATUS_CODE가 SUCCESS인 DATA
					BEGIN			
						INSERT INTO #TEMP_EDI_ALL ( NUM, IFSEQNO )
						SELECT ROW_NUMBER() OVER(ORDER BY A.IFSEQNO) AS NUM
								 , A.IFSEQNO
						FROM  DM_DNM_EDI_CALLOFF_ITEM A WITH(NOLOCK)
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
						ON A.SENDER_CODE = B.SEGMENT2
						AND B.LOOKUP_TYPE = 'EDI_SENDER_CODE'
						WHERE 1=1
						AND A.DIVISION_ID = @v_division_id				
						AND A.CREATE_DATE >= @v_from_date
						AND A.CREATE_DATE <= @v_to_date					
						GROUP BY A.IFSEQNO
						ORDER BY A.IFSEQNO;

					END

SELECT COUNT(*)  FROM #TEMP_EDI_ALL

					-- 테이블중복제거
					IF OBJECT_ID (N'tempdb..#TEMP_EDI_CUST_FCST', N'U')				IS NOT NULL	DROP TABLE #TEMP_EDI_CUST_FCST
					IF OBJECT_ID (N'dbo.#TEMP_EDI_CUST_FCST', N'U')					IS NOT NULL	DROP TABLE #TEMP_EDI_CUST_FCST

					IF OBJECT_ID (N'tempdb..#TEMP_QTY_SUM', N'U')				IS NOT NULL	DROP TABLE #TEMP_QTY_SUM
					IF OBJECT_ID (N'dbo.#TEMP_QTY_SUM', N'U')					IS NOT NULL	DROP TABLE #TEMP_QTY_SUM
			
					--#TEMP_EDI_CUST_FCST	
					CREATE TABLE #TEMP_EDI_CUST_FCST	(				
								EDI_IF_SEQ						NVARCHAR(35)	NULL
							   ,SUB_NO							SMALLINT			NULL
							   ,YYYYMMDD					NVARCHAR(8)		NULL
							   ,DIVISION_ID					NVARCHAR(30)	NULL
							   ,SCM_SITE_ID					NVARCHAR(50)	NULL
							   ,ITEM_ID							NVARCHAR(50)	NULL
							   ,PROJECT_CODE				NVARCHAR(50)	NULL
							   ,ERP_FCST_TYPE				NVARCHAR(10)	NULL
							   ,BASIS_YYYYMMDD			NVARCHAR(8)		NULL
							   ,QTY								NVARCHAR(35)	NULL
							   ,EDI_INCOTERMS				NVARCHAR(50)	NULL
							   ,SALES_PLANT_SITE_ID		NVARCHAR(50)	NULL
							   ,DOM_EXP						NVARCHAR(10)	NULL
							   ,COMPANY_ID					NVARCHAR(30)	NULL
							   ,SOLDTO_CODE				NVARCHAR(10)	NULL
							   ,SHIPTO_CODE					NVARCHAR(10)	NULL
							   ,DOC_IDENTIFINER			NVARCHAR(35)	NULL
							   ,MESSAGE_TYPE				NVARCHAR(6)		NULL
							   ,RDD_START						NVARCHAR(35)	NULL
							   ,RDD_END						NVARCHAR(35)	NULL
							   ,IFSEQNO						NVARCHAR(35)	NULL
							   ,SCHEDULING_TYPE			NVARCHAR(3)		NULL
							   ,DELFOR_TYPE					NVARCHAR(30)	NULL
							   ,EDI_LT							INT					NULL
							   ,CUST_MATERIAL_CODE		NVARCHAR(35)	NULL
							   ,CREATE_DATE					NVARCHAR(8)		NULL
							   ,SENDER_CODE				NVARCHAR(10)	NULL
							   ,SENDER_NAME				NVARCHAR(100)	NULL
							   ,CUSTOMER_PLANT			NVARCHAR(100)	NULL
							   ,UNLOADING_POINT			NVARCHAR(100)	NULL
							   ,NICK_NAME					NVARCHAR(100)	NULL
							   ,END_CUSTOMER				NVARCHAR(100)	NULL
							   ,DEPT_NAME_KO				NVARCHAR(100)	NULL
							   ,TEAM_NAME_KO				NVARCHAR(100)	NULL
							   ,SOLDTO_CUSTOMER		NVARCHAR(100)	NULL
							   ,COUNTRY						NVARCHAR(100)	NULL
							   ,CITY								NVARCHAR(100)	NULL
							   ,ITEM_NAME					NVARCHAR(100)	NULL
							   ,ITEM_TYPE						NVARCHAR(100)	NULL
							   ,OWNER							NVARCHAR(100)	NULL
							   ,VMI_YN							NVARCHAR(100)	NULL
							   ,BIZ_TYPE							NVARCHAR(100)	NULL
							   ,PROJECT_NAME				NVARCHAR(100)	NULL
							   ,PROJECT_STATUS				NVARCHAR(100)	NULL
							   ,PROJECT_OWNER				NVARCHAR(100)	NULL
							   ,CELL_PER_CAR					NVARCHAR(100)	NULL
							   ,CELL_PER_MODULE			NVARCHAR(100)	NULL
							   ,MODULE_PER_CAR			NVARCHAR(100)	NULL
							   ,KWH_PER_CELL				NVARCHAR(100)	NULL
							   ,KWH_PER_MODULE			NVARCHAR(100)	NULL
							   ,KWH_PER_PACK				NVARCHAR(100)	NULL							   
							   );

					CREATE TABLE #TEMP_QTY_SUM	(				
								IFSEQNO						NVARCHAR(35)	NULL
							   ,EDI_IF_SEQ						NVARCHAR(35)	NULL
							   ,CREATE_DATE					NVARCHAR(8)		NULL
							   ,DIVISION_ID					NVARCHAR(30)	NULL
							   ,PROJECT_CODE				NVARCHAR(50)	NULL
							   ,ERP_FCST_TYPE				NVARCHAR(10)	NULL
							   ,SCM_SITE_ID					NVARCHAR(50)	NULL
							   ,ITEM_ID							NVARCHAR(50)	NULL
							   ,BASIS_YYYYMMDD			NVARCHAR(8)		NULL
							   ,QTY								NVARCHAR(35)	NULL
							   ,EDI_INCOTERMS				NVARCHAR(50)	NULL
							   ,SALES_PLANT_SITE_ID		NVARCHAR(50)	NULL
							   ,DOM_EXP						NVARCHAR(10)	NULL
							   ,UNLOADING_POINT			NVARCHAR(70)	NULL
							   ,CUST_MATERIAL_CODE		NVARCHAR(70)	NULL
							   );
					   
					DECLARE @i INT = 1, @CNT INT = 0;
					------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
					SELECT @CNT = COUNT(*) FROM #TEMP_EDI_ALL		
PRINT('A:'+CONVERT(NVARCHAR, @CNT))

					IF @CNT > 0
					------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
					--                                                        DM_DNM_EDI_CALLOFF_ITEM TABLE의 정보가 존재하는경우 수행 (START)
					------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇		
					WHILE (@i <= @CNT)
					BEGIN
						--신규 IFSEQNO
						SELECT @v_ifseqno_INSERT = IFSEQNO FROM #TEMP_EDI_ALL
						WHERE NUM = @i			

PRINT ('A:'+CONVERT(NVARCHAR, @i) + ', IFSEQNO:' + @v_ifseqno_INSERT)

						BEGIN
							INSERT INTO #TEMP_EDI_CUST_FCST ( EDI_IF_SEQ, SUB_NO, YYYYMMDD, DIVISION_ID, SCM_SITE_ID
																			   , ITEM_ID, PROJECT_CODE, ERP_FCST_TYPE
																			   , BASIS_YYYYMMDD, QTY, EDI_INCOTERMS, SALES_PLANT_SITE_ID, DOM_EXP
																			   , COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE, DOC_IDENTIFINER, MESSAGE_TYPE
																			   , RDD_START, RDD_END, IFSEQNO, SCHEDULING_TYPE
																			   , DELFOR_TYPE
																			   , EDI_LT, CUST_MATERIAL_CODE, CREATE_DATE
																			   , SENDER_CODE, SENDER_NAME, CUSTOMER_PLANT, UNLOADING_POINT, END_CUSTOMER, NICK_NAME, DEPT_NAME_KO, TEAM_NAME_KO, SOLDTO_CUSTOMER, COUNTRY
																			   , CITY, ITEM_NAME, ITEM_TYPE, OWNER, VMI_YN, BIZ_TYPE,  PROJECT_NAME, PROJECT_STATUS, PROJECT_OWNER, CELL_PER_CAR, CELL_PER_MODULE
																			   , MODULE_PER_CAR, KWH_PER_CELL, KWH_PER_MODULE, KWH_PER_PACK )
																	SELECT   A.EDI_IF_SEQ, A.SUB_NO, A.YYYYMMDD, A.DIVISION_ID, A.SCM_SITE_ID
																			   , A.ITEM_ID, A.PROJECT_CODE, (CASE A.ERP_FCST_TYPE WHEN 'M' THEN 'MPS' WHEN 'S' THEN 'SMC' ELSE 'MPS' END) AS ERP_FCST_TYPE
																			   , A.BASIS_YYYYMMDD, A.QTY, A.EDI_INCOTERMS, A.SALES_PLANT_SITE_ID, 'E' AS DOM_EXP
																			   , A.COMPANY_ID, A.SOLDTO_CODE, A.SHIPTO_CODE, DOC_IDENTIFINER, MESSAGE_TYPE
																			   , A.RDD_START, RDD_END, IFSEQNO, SCHEDULING_TYPE		
																			   , (CASE WHEN MESSAGE_TYPE = 'DELFOR' AND SOLDTO_CODE = 'FR000064' AND RDD_START <> RDD_END AND RDD_START >= @v_1week_monday THEN 
																									'Periodic DELFOR' 
																						  ELSE '' END) AS DELFOR_TYPE
																			   , A.EDI_LT, A.CUST_MATERIAL_CODE, A.CREATE_DATE
																			   , A.SENDER_CODE, A.SENDER_NAME, A.CUSTOMER_PLANT, A.UNLOADING_POINT
																			   , C.END_CUSTOMER
																			   , [dbo].[FN_GET_ITEM_NICKNAME](A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
																			   , E.DEPT_NAME_KO AS DEPT_NAME_KO
																			   , F.DEPT_NAME_KO AS TEAM_NAME_KO 
																			   , C.SOLDTO_CUSTOMER		
																			   , G.COUNTRY, G.CITY, H.ITEM_NAME, H.ITEM_TYPE, D.OWNER, C.VMI_YN, I.BIZ_TYPE
																			   , I.PROJECT_NAME, I.PROJECT_STATUS, I.PROJECT_OWNER
																			   , D.CELL_PER_CAR, D.CELL_PER_MODULE
																			   , (CASE WHEN D.CELL_PER_MODULE  <> 0 THEN D.CELL_PER_CAR / D.CELL_PER_MODULE ELSE 0 END) AS MODULE_PER_CAR
																			   , D.ATTRIBUTE8 AS KWH_PER_CELL
																			   , (CASE WHEN A.DIVISION_ID LIKE '81%' AND D.CELL_PER_MODULE > 0 AND ISNULL(D.ATTRIBUTE8, '''') <> '''' THEN 
					 											  								CONVERT(FLOAT,(D.CELL_PER_MODULE * D.ATTRIBUTE8))   
					 											  						ELSE NULL END) AS KWH_PER_MODULE
																			   , (CASE WHEN A.DIVISION_ID LIKE '81%' AND D.CELL_PER_CAR > 0 AND ISNULL(D.ATTRIBUTE8, '''') <> '''' THEN 
					 											  								CONVERT(FLOAT,(D.CELL_PER_CAR * D.ATTRIBUTE8))   
					 											  						ELSE NULL END) AS KWH_PER_PACK
																	FROM  DM_DNM_EDI_CALLOFF_ITEM AS A 
																	LEFT OUTER JOIN (SELECT * FROM SCM_MST_SITE WITH(NOLOCK) 
																							  WHERE SITE_TYPE = 'SALES' AND VALID_YN = 'Y' AND DIVISION_ID = @v_division_id) AS C
																	ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID
																	LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PER_CAR, CELL_PER_MODULE, OWNER, ATTRIBUTE8 
																							  FROM SCM_MST_SITE_ITEM WITH(NOLOCK) WHERE VALID_YN = 'Y' AND DIVISION_ID = @v_division_id) D 
																	ON A.DIVISION_ID = D.DIVISION_ID
																		AND A.PROJECT_CODE = D.PROJECT_CODE
																		AND A.SCM_SITE_ID = D.SCM_SITE_ID
																		AND A.ITEM_ID = D.ITEM_ID
																	LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO E WITH(NOLOCK)
																	ON C.DEPT_ID = E.DEPT_ID
																	LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO F WITH(NOLOCK)
																	ON E.UPPER_DEPT_ID = F.DEPT_ID
																	LEFT OUTER JOIN SCM_MST_CITY G 
																	ON C.COUNTRY = G.COUNTRY
																		AND C.CITY = G.CITY  
																	LEFT OUTER JOIN (SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_TYPE FROM DM_MST_ITEM_SINGLE_V WITH(NOLOCK)   
																							  WHERE ACTIVE_FLAG = 'Y' AND DIVISION_ID = @v_division_id) H 
																	ON A.DIVISION_ID = H.DIVISION_ID  
																	AND A.ITEM_ID   = H.ITEM_ID  
																	LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, BIZ_TYPE, PROJECT_NAME, PROJECT_STATUS, PROJECT_OWNER FROM SCM_MST_PROJECT 
																							  WHERE DROP_YN = 'N' AND DIVISION_ID = @v_division_id) I 
																	ON A.DIVISION_ID = I.DIVISION_ID 
																		AND A.PROJECT_CODE = I.PROJECT_CODE			
																	WHERE	IFSEQNO = @v_ifseqno_INSERT														
												
						END

						BEGIN
								INSERT INTO #TEMP_QTY_SUM
											( IFSEQNO				
											,EDI_IF_SEQ			
											,CREATE_DATE			
											,DIVISION_ID			
											,PROJECT_CODE		
											,ERP_FCST_TYPE		
											,BASIS_YYYYMMDD	
											,SCM_SITE_ID
											,ITEM_ID
											,QTY					
											,EDI_INCOTERMS		
											,SALES_PLANT_SITE_ID	
											,DOM_EXP
											,UNLOADING_POINT
											,CUST_MATERIAL_CODE)
								SELECT   IFSEQNO				
											,EDI_IF_SEQ			
											,CREATE_DATE			
											,DIVISION_ID			
											,PROJECT_CODE		
											,ERP_FCST_TYPE		
											,BASIS_YYYYMMDD		
											,SCM_SITE_ID
											,ITEM_ID
											,SUM(CAST(REPLACE(QTY, ',', '') AS NUMERIC))		
											,EDI_INCOTERMS		
											,SALES_PLANT_SITE_ID	
											,DOM_EXP
											,UNLOADING_POINT
											,CUST_MATERIAL_CODE
								FROM  #TEMP_EDI_CUST_FCST WITH(NOLOCK)  
								WHERE 1 = 1
								AND IFSEQNO =  @v_ifseqno_INSERT			-- SEQUENCE 별로 하나씩 작업					
								AND DIVISION_ID = @p_division_id
								AND SCHEDULING_TYPE <> '83'										
								GROUP BY IFSEQNO, EDI_IF_SEQ, CREATE_DATE, DIVISION_ID, PROJECT_CODE
											  , ERP_FCST_TYPE, BASIS_YYYYMMDD, SCM_SITE_ID, ITEM_ID
											  , EDI_INCOTERMS, SALES_PLANT_SITE_ID, DOM_EXP
											  , UNLOADING_POINT, CUST_MATERIAL_CODE
						END

						BEGIN
							DELETE FROM DM_PLN_CUST_FCST_H
							WHERE 1=1				
							AND EDI_IF_SEQ = ( SELECT DISTINCT X.EDI_IF_SEQ FROM #TEMP_EDI_CUST_FCST X WITH(NOLOCK)
														WHERE X.IFSEQNO =  @v_ifseqno_INSERT					-- SEQUENCE 별로 하나씩 작업										
													   );			
						END

						------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
						-- 날짜 중복데이터는 SUM한 값으로 입력
						------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
						BEGIN
							INSERT INTO DM_PLN_CUST_FCST_H
										(HISTORY_SEQ, EDI_IF_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
										, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
										, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
										, CREATE_DATE
										, SENDER_CODE
										, SENDER_NAME
										, END_CUSTOMER
										, CUSTOMER_PLANT
										, UNLOADING_POINT
										, NICK_NAME
										, DEPT_NAME_KO
										, TEAM_NAME_KO 
										, SOLDTO_CUSTOMER
										, COUNTRY		
										, CITY			
										, ITEM_NAME			
										, ITEM_TYPE			
										, OWNER				
										, VMI_YN			
										, BIZ_TYPE		
										, PROJECT_NAME		
										, PROJECT_STATUS	
										, PROJECT_OWNER		
										, CELL_PER_CAR		
										, CELL_PER_MODULE	
										, MODULE_PER_CAR	
										, KWH_PER_CELL		
										, KWH_PER_MODULE	
										, KWH_PER_PACK		
										, SCHEDULING_TYPE
										, CUST_MATERIAL_CODE
										)
								SELECT NEXT VALUE FOR SEQ1_DM_PLN_CUST_FCST_H, A.EDI_IF_SEQ, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.ERP_FCST_TYPE
										, A.EDI_INCOTERMS, 'CUST_FCST_EDI', ISNULL(A.SALES_PLANT_SITE_ID, ''), A.BASIS_YYYYMMDD, B.QTY
										, 'EDI', GETDATE(), 'EDI', GETDATE()
										, A.CREATE_DATE
										, A.SENDER_CODE
										, A.SENDER_NAME
										, A.END_CUSTOMER
										, A.CUSTOMER_PLANT
										, A.UNLOADING_POINT
										, A.NICK_NAME
										, A.DEPT_NAME_KO
										, A.TEAM_NAME_KO 
										, A.SOLDTO_CUSTOMER
										, A.COUNTRY		
										, A.CITY			
										, A.ITEM_NAME			
										, A.ITEM_TYPE			
										, A.OWNER				
										, A.VMI_YN			
										, A.BIZ_TYPE		
										, A.PROJECT_NAME		
										, A.PROJECT_STATUS	
										, A.PROJECT_OWNER		
										, A.CELL_PER_CAR		
										, A.CELL_PER_MODULE	
										, A.MODULE_PER_CAR	
										, A.KWH_PER_CELL		
										, A.KWH_PER_MODULE	
										, A.KWH_PER_PACK		
										, A.SCHEDULING_TYPE
										, A.CUST_MATERIAL_CODE
								FROM  #TEMP_EDI_CUST_FCST A WITH(NOLOCK)  
								INNER JOIN #TEMP_QTY_SUM B 
								ON A.IFSEQNO = B.IFSEQNO 
									AND A.EDI_IF_SEQ = B.EDI_IF_SEQ 
									AND A.CREATE_DATE = B.CREATE_DATE 
									AND A.DIVISION_ID = B.DIVISION_ID 
									AND ISNULL(A.PROJECT_CODE, '') = ISNULL(B.PROJECT_CODE, '')
									AND ISNULL(A.SCM_SITE_ID, '') = ISNULL(B.SCM_SITE_ID, '')
									AND ISNULL(A.ITEM_ID, '') = ISNULL(B.ITEM_ID, '')
									AND A.DOM_EXP = B.DOM_EXP 
									AND A.ERP_FCST_TYPE = B.ERP_FCST_TYPE 
									AND A.EDI_INCOTERMS = B.EDI_INCOTERMS
									AND A.SALES_PLANT_SITE_ID = B.SALES_PLANT_SITE_ID 
									AND A.BASIS_YYYYMMDD = B.BASIS_YYYYMMDD
									AND ISNULL(A.UNLOADING_POINT, '') = ISNULL(B.UNLOADING_POINT, '')
									AND ISNULL(A.CUST_MATERIAL_CODE, '') = ISNULL(B.CUST_MATERIAL_CODE, '')
								WHERE 1 = 1
								AND A.IFSEQNO =  @v_ifseqno_INSERT						-- SEQUENCE 별로 하나씩 작업

						END

						------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
						-- MEASURE별 SUM한 값으로 생성
						------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
						BEGIN
							INSERT INTO DM_PLN_CUST_FCST_H
										(HISTORY_SEQ, EDI_IF_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
										, INCOTERMS
										, MEASURE
										, PLANT_SITE_ID, YYYYMMDD, QTY
										, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
										, CREATE_DATE
										, SENDER_CODE	-- SENDER_CODE 값 저장
										, SENDER_NAME	-- SENDER_NAME 값 저장
										, END_CUSTOMER
										, CUSTOMER_PLANT
										, UNLOADING_POINT
										, NICK_NAME
										, DEPT_NAME_KO
										, TEAM_NAME_KO 
										, SOLDTO_CUSTOMER
										, COUNTRY		
										, CITY			
										, ITEM_NAME			
										, ITEM_TYPE			
										, OWNER				
										, VMI_YN			
										, BIZ_TYPE		
										, PROJECT_NAME		
										, PROJECT_STATUS	
										, PROJECT_OWNER		
										, CELL_PER_CAR		
										, CELL_PER_MODULE	
										, MODULE_PER_CAR	
										, KWH_PER_CELL		
										, KWH_PER_MODULE	
										, KWH_PER_PACK		
										, SCHEDULING_TYPE
										, CUST_MATERIAL_CODE
										)
								SELECT NEXT VALUE FOR SEQ1_DM_PLN_CUST_FCST_H, A.EDI_IF_SEQ , A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.ERP_FCST_TYPE
										, A.EDI_INCOTERMS
										, CASE WHEN A.SCHEDULING_TYPE = '4'  THEN 'Planning_Forecast'
												  WHEN A.SCHEDULING_TYPE = '10' THEN 'Immidiate'
												  WHEN A.SCHEDULING_TYPE = '24' THEN 'Commercial_Agreement'
												  WHEN A.SCHEDULING_TYPE = '1' THEN 'Firm_Temp'
												  WHEN A.SCHEDULING_TYPE = '2' THEN 'Manumacturing_Material_Temp'
												  WHEN A.SCHEDULING_TYPE = '3' THEN 'Material_Temp'
												  WHEN A.SCHEDULING_TYPE = '83' THEN 'Backorder' END
										, ISNULL(A.SALES_PLANT_SITE_ID, ''), A.BASIS_YYYYMMDD
										, SUM(CAST(REPLACE(A.QTY, ',', '') AS NUMERIC)) AS QTY
										, 'EDI', GETDATE(), 'EDI', GETDATE()
										, A.CREATE_DATE
										, A.SENDER_CODE
										, A.SENDER_NAME
										, A.END_CUSTOMER
										, A.CUSTOMER_PLANT
										, A.UNLOADING_POINT
										, A.NICK_NAME
										, A.DEPT_NAME_KO
										, A.TEAM_NAME_KO 
										, A.SOLDTO_CUSTOMER
										, A.COUNTRY		
										, A.CITY			
										, A.ITEM_NAME			
										, A.ITEM_TYPE			
										, A.OWNER				
										, A.VMI_YN			
										, A.BIZ_TYPE		
										, A.PROJECT_NAME		
										, A.PROJECT_STATUS	
										, A.PROJECT_OWNER		
										, A.CELL_PER_CAR		
										, A.CELL_PER_MODULE	
										, A.MODULE_PER_CAR	
										, A.KWH_PER_CELL		
										, A.KWH_PER_MODULE	
										, A.KWH_PER_PACK		
										, A.SCHEDULING_TYPE
										, A.CUST_MATERIAL_CODE
								FROM  #TEMP_EDI_CUST_FCST A WITH(NOLOCK)
								WHERE 1 = 1
								AND A.IFSEQNO =  @v_ifseqno_INSERT						-- SEQUENCE 별로 하나씩 작업
								GROUP BY A.EDI_IF_SEQ , A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.ERP_FCST_TYPE
											  , A.EDI_INCOTERMS, A.SCHEDULING_TYPE, ISNULL(A.SALES_PLANT_SITE_ID, ''), A.BASIS_YYYYMMDD, A.CREATE_DATE
											  , A.SENDER_CODE, A.SENDER_NAME, A.END_CUSTOMER, A.CUSTOMER_PLANT, A.UNLOADING_POINT
											  , A.NICK_NAME, A.DEPT_NAME_KO, A.TEAM_NAME_KO, A.SOLDTO_CUSTOMER, A.COUNTRY, A.CITY			
											  , A.ITEM_NAME, A.ITEM_TYPE, A.OWNER, A.VMI_YN, A.BIZ_TYPE, A.PROJECT_NAME, A.PROJECT_STATUS, A.PROJECT_OWNER		
											  , A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR, A.KWH_PER_CELL, A.KWH_PER_MODULE, A.KWH_PER_PACK		
											  , A.SCHEDULING_TYPE, A.CUST_MATERIAL_CODE
						END

						SET @i = @i + 1			

					END

				END

				--******************** EDI DATA 생성 END ********************	

			IF @v_accept_flag = 'RPA'

				BEGIN

					BEGIN
						DELETE FROM DM_PLN_CUST_FCST_H
						WHERE MEASURE IN ('CUST_FCST', 'Customer FCST')
						AND DIVISION_ID = @v_division_id
						AND CONVERT(NVARCHAR, LAST_UPDATE_DATE, 112) >= @v_from_date
					END
					
					IF (@v_division_id = '40')						

						BEGIN
							INSERT INTO DM_PLN_CUST_FCST_H
										(HISTORY_SEQ
										, EDI_IF_SEQ
										, DIVISION_ID
										, PROJECT_CODE
										, SCM_SITE_ID
										, ITEM_ID
										, DOM_EXP
										, FCST_TYPE
										, INCOTERMS
										, MEASURE
										, PLANT_SITE_ID
										, YYYYMMDD, QTY
										, CREATED_BY
										, CREATION_DATE
										, LAST_UPDATED_BY
										, LAST_UPDATE_DATE
										, CREATE_DATE
										, SENDER_CODE
										, SENDER_NAME
										, END_CUSTOMER
										, CUSTOMER_PLANT
										, UNLOADING_POINT
										, NICK_NAME
										, DEPT_NAME_KO
										, TEAM_NAME_KO 
										, SOLDTO_CUSTOMER
										, COUNTRY		
										, CITY			
										, ITEM_NAME			
										, ITEM_TYPE			
										, OWNER				
										, VMI_YN			
										, BIZ_TYPE		
										, PROJECT_NAME		
										, PROJECT_STATUS	
										, PROJECT_OWNER		
										, CELL_PER_CAR		
										, CELL_PER_MODULE	
										, MODULE_PER_CAR	
										, KWH_PER_CELL		
										, KWH_PER_MODULE	
										, KWH_PER_PACK		
										, SCHEDULING_TYPE
										)
							   SELECT NEXT VALUE FOR SEQ1_DM_PLN_CUST_FCST_H
										, '' AS EDI_IF_SEQ
										, AA.DIVISION_ID
										, '' AS PROJECT_CODE
										, AA.SCM_SITE_ID
										, AA.ITEM_ID
										, AA.DOM_EXP
										, AA.FCST_TYPE
										, AA.INCOTERMS
										, AA.MEASURE
										, AA.PLANT_SITE_ID
										, AA.YYYYMMDD
										, IIF(AA.QTY IS NULL , NULL,  CONVERT(NUMERIC(30, 10), AA.QTY)) AS QTY
										, AA.CREATED_BY
										, CREATION_DATE
										, LAST_UPDATED_BY
										, LAST_UPDATE_DATE
										, AA.CREATE_DATE
										, AA.SENDER_CODE
										, AA.SENDER_NAME
										, AA.END_CUSTOMER
										, AA.CUSTOMER_PLANT
										, AA.UNLOADING_POINT
										, AA.NICK_NAME
										, AA.DEPT_NAME_KO
										, AA.TEAM_NAME_KO 
										, AA.SOLDTO_CUSTOMER
										, AA.COUNTRY_NAME	
										, AA.CITY_NAME	
										, AA.ITEM_NAME			
										, AA.ITEM_TYPE			
										, AA.OWNER				
										, AA.VMI_YN			
										, AA.BIZ_TYPE_NAME		
										, AA.PROJECT_NAME		
										, AA.PROJECT_STATUS	
										, AA.PROJECT_OWNER		
										, ISNULL(AA.CELL_PER_CAR, 0) AS CELL_PER_CAR
										, ISNULL(AA.CELL_PER_MODULE, 0) AS CELL_PER_MODULE
										, ISNULL(AA.MODULE_PER_CAR, 0) AS MODULE_PER_CAR
										, 0 --ISNULL(CONVERT(NUMERIC(30, 10), AA.KWH_PER_CELL)), 0)  KWH_PER_CELL
										, ISNULL(AA.KWH_PER_MODULE, 0) AS KWH_PER_MODULE
										, ISNULL(AA.KWH_PER_PACK, 0) AS KWH_PER_PACK
										, ''
							   FROM (
										  SELECT DISTINCT A.DIVISION_ID
												   , '' AS SENDER_CODE
												   , '' AS SENDER_NAME
												   , A.YYYYMMDD
												   , '' AS CUSTOMER_PLANT
												   , '' AS UNLOADING_POINT
												   , '' AS CUST_MATERIAL_CODE
												   , C.END_CUSTOMER
												   , A.SCM_SITE_ID
												   , A.ITEM_ID
												   , [dbo].[FN_GET_ITEM_NICKNAME](A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
												   , A.INCOTERMS
												   , A.FCST_TYPE
												   , A.DOM_EXP 
												   , E.DEPT_NAME_KO AS DEPT_NAME_KO
												   , F.DEPT_NAME_KO AS TEAM_NAME_KO 
												   , C.SOLDTO_CUSTOMER		
												   , G.COUNTRY_NAME
												   , G.CITY_NAME
												   , H.ITEM_NAME
												   , H.ITEM_TYPE
												   , D.OWNER
												   , C.VMI_YN
												   , I.BIZ_TYPE_NAME
												   , A.PROJECT_CODE
												   , I.PROJECT_NAME
												   , I.PROJECT_STATUS
												   , I.PROJECT_OWNER
												   , A.PLANT_SITE_ID AS PLANT_SITE_ID
												   , D.CELL_PER_CAR
												   , D.CELL_PER_MODULE
												   , (CASE WHEN D.CELL_PER_MODULE <> 0 THEN D.CELL_PER_CAR / D.CELL_PER_MODULE ELSE 0 END) AS MODULE_PER_CAR
												   , '' AS SOLDTO_CODE
												   , '' AS COMPANY_ID
												   , D.ATTRIBUTE8 AS KWH_PER_CELL
												   , (CASE WHEN A.DIVISION_ID = @v_division_id AND D.CELL_PER_MODULE > 0 AND ISNULL(D.ATTRIBUTE8, '''') <> '''' THEN 
																	   CONVERT(FLOAT, (D.CELL_PER_MODULE * D.ATTRIBUTE8))   
															  ELSE NULL END) AS KWH_PER_MODULE
												   , (CASE WHEN A.DIVISION_ID = @v_division_id AND D.CELL_PER_CAR > 0 AND ISNULL(D.ATTRIBUTE8, '''') <> '''' THEN 
																	   CONVERT(FLOAT, (D.CELL_PER_CAR * D.ATTRIBUTE8))   
															  ELSE NULL END) AS KWH_PER_PACK
												   , A.MEASURE
												   , A.QTY
												   , CONVERT(NVARCHAR, A.CREATION_DATE, 112) AS CREATE_DATE
												   , A.CREATED_BY
												   , A.CREATION_DATE
												   , A.LAST_UPDATED_BY
												   , A.LAST_UPDATE_DATE
										  FROM DM_PLN_MKT_FCST A WITH(NOLOCK)
										  LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
										  ON A.DIVISION_ID = C.DIVISION_ID
											AND A.SCM_SITE_ID = C.SCM_SITE_ID
											AND C.SITE_TYPE		= 'SALES'
											AND C.VALID_YN = 'Y'
										  LEFT OUTER JOIN SCM_MST_SITE_ITEM D WITH(NOLOCK)
										  ON A.DIVISION_ID = D.DIVISION_ID						
											AND A.SCM_SITE_ID = D.SCM_SITE_ID
											AND A.ITEM_ID = D.ITEM_ID
										  LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO E WITH(NOLOCK)
										  ON C.DEPT_ID = E.DEPT_ID
										  LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO F WITH(NOLOCK)
										  ON E.UPPER_DEPT_ID = F.DEPT_ID
										  LEFT OUTER JOIN SCM_MST_CITY G 
										  ON C.COUNTRY = G.COUNTRY
											AND C.CITY = G.CITY  
										  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V H WITH(NOLOCK)  
										  ON A.DIVISION_ID = H.DIVISION_ID  
											AND A.ITEM_ID   = H.ITEM_ID  
										  LEFT OUTER JOIN SCM_MST_PROJECT I 
										  ON A.DIVISION_ID = I.DIVISION_ID 						
										  WHERE A.MEASURE IN ('CUST_FCST', 'Customer FCST')
										  AND A.DIVISION_ID = @v_division_id
										  AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) >= @v_from_date										  
										) AA
						END

					ELSE

						BEGIN
							INSERT INTO DM_PLN_CUST_FCST_H
										(HISTORY_SEQ, EDI_IF_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
										, INCOTERMS
										, MEASURE
										, PLANT_SITE_ID, YYYYMMDD, QTY
										, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
										, CREATE_DATE
										, SENDER_CODE	-- SENDER_CODE 값 저장
										, SENDER_NAME	-- SENDER_NAME 값 저장
										, END_CUSTOMER
										, CUSTOMER_PLANT
										, UNLOADING_POINT
										, NICK_NAME
										, DEPT_NAME_KO
										, TEAM_NAME_KO 
										, SOLDTO_CUSTOMER
										, COUNTRY		
										, CITY			
										, ITEM_NAME			
										, ITEM_TYPE			
										, OWNER				
										, VMI_YN			
										, BIZ_TYPE		
										, PROJECT_NAME		
										, PROJECT_STATUS	
										, PROJECT_OWNER		
										, CELL_PER_CAR		
										, CELL_PER_MODULE	
										, MODULE_PER_CAR	
										, KWH_PER_CELL		
										, KWH_PER_MODULE	
										, KWH_PER_PACK		
										)
								SELECT NEXT VALUE FOR SEQ1_DM_PLN_CUST_FCST_H
										, '' EDI_IF_SEQ
										, AA.DIVISION_ID
										, AA.PROJECT_CODE PROJECT_CODE
										, AA.SCM_SITE_ID
										, AA.ITEM_ID
										, AA.DOM_EXP
										, AA.FCST_TYPE
										, AA.INCOTERMS
										, AA.MEASURE
										, AA.PLANT_SITE_ID
										, AA.YYYYMMDD
										, IIF(AA.QTY IS NULL , NULL,  CONVERT(NUMERIC(30, 10), AA.QTY)) AS QTY
										, AA.CREATED_BY
										, CREATION_DATE
										, LAST_UPDATED_BY
										, LAST_UPDATE_DATE
										, AA.CREATE_DATE
										, AA.SENDER_CODE
										, AA.SENDER_NAME
										, AA.END_CUSTOMER
										, AA.CUSTOMER_PLANT
										, AA.UNLOADING_POINT
										, AA.NICK_NAME
										, AA.DEPT_NAME_KO
										, AA.TEAM_NAME_KO 
										, AA.SOLDTO_CUSTOMER
										, AA.COUNTRY_NAME	
										, AA.CITY_NAME	
										, AA.ITEM_NAME			
										, AA.ITEM_TYPE			
										, AA.OWNER				
										, AA.VMI_YN			
										, AA.BIZ_TYPE_NAME		
										, AA.PROJECT_NAME		
										, AA.PROJECT_STATUS	
										, AA.PROJECT_OWNER
										, IIF(AA.CELL_PER_CAR IS NULL, NULL, CONVERT(NUMERIC(30, 10), AA.CELL_PER_CAR)) AS CELL_PER_CAR
										, IIF(AA.CELL_PER_MODULE IS NULL, NULL, CONVERT(NUMERIC(30, 10), AA.CELL_PER_MODULE)) AS CELL_PER_MODULE
										, IIF(AA.MODULE_PER_CAR IS NULL, NULL, CONVERT(NUMERIC(30, 10), AA.MODULE_PER_CAR)) AS MODULE_PER_CAR
										, IIF(AA.KWH_PER_CELL IS NULL, NULL, CONVERT(NUMERIC(30, 10), AA.KWH_PER_CELL)) AS KWH_PER_CELL
										, IIF(AA.KWH_PER_MODULE IS NULL, NULL, CONVERT(NUMERIC(30, 10), AA.KWH_PER_MODULE)) AS KWH_PER_MODULE
										, IIF(AA.KWH_PER_PACK IS NULL, NULL, CONVERT(NUMERIC(30, 10), AA.KWH_PER_PACK)) AS KWH_PER_PACK
							   FROM (
										  SELECT DISTINCT A.DIVISION_ID
												   , '' AS SENDER_CODE
												   , '' AS SENDER_NAME
												   , A.YYYYMMDD
												   , '' AS CUSTOMER_PLANT
												   , '' AS UNLOADING_POINT
												   , '' AS CUST_MATERIAL_CODE
												   , C.END_CUSTOMER
												   , A.SCM_SITE_ID
												   , A.ITEM_ID
												   , [dbo].[FN_GET_ITEM_NICKNAME](A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
												   , A.INCOTERMS
												   , A.FCST_TYPE
												   , A.DOM_EXP 
												   , E.DEPT_NAME_KO AS DEPT_NAME_KO
												   , F.DEPT_NAME_KO AS TEAM_NAME_KO 
												   , C.SOLDTO_CUSTOMER		
												   , G.COUNTRY_NAME
												   , G.CITY_NAME
												   , H.ITEM_NAME
												   , H.ITEM_TYPE
												   , D.OWNER
												   , C.VMI_YN
												   , I.BIZ_TYPE_NAME
												   , A.PROJECT_CODE
												   , I.PROJECT_NAME
												   , I.PROJECT_STATUS
												   , I.PROJECT_OWNER
												   , A.PLANT_SITE_ID AS PLANT_SITE_ID
												   , D.CELL_PER_CAR
												   , D.CELL_PER_MODULE
												   , (CASE WHEN D.CELL_PER_MODULE <> 0 THEN D.CELL_PER_CAR / D.CELL_PER_MODULE ELSE 0 END) AS MODULE_PER_CAR
												   , '' AS SOLDTO_CODE, '' AS COMPANY_ID, D.ATTRIBUTE8 AS KWH_PER_CELL
												   , (CASE WHEN A.DIVISION_ID = @v_division_id AND D.CELL_PER_MODULE > 0 AND ISNULL(D.ATTRIBUTE8, '''') <> '''' THEN 
																		CONVERT(FLOAT, (D.CELL_PER_MODULE * D.ATTRIBUTE8))   
															  ELSE NULL END) AS KWH_PER_MODULE
												   , (CASE WHEN A.DIVISION_ID = @v_division_id AND D.CELL_PER_CAR > 0 AND ISNULL(D.ATTRIBUTE8, '''') <> '''' THEN 
																		CONVERT(FLOAT, (D.CELL_PER_CAR * D.ATTRIBUTE8))   
															  ELSE NULL END) AS KWH_PER_PACK
												   , A.MEASURE
												   , A.QTY
												   , CONVERT(NVARCHAR, A.CREATION_DATE, 112) AS CREATE_DATE
												   , A.CREATED_BY
												   , A.CREATION_DATE
												   , A.LAST_UPDATED_BY
												   , A.LAST_UPDATE_DATE
										  FROM DM_PLN_MKT_FCST A WITH(NOLOCK)
										  LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
										  ON A.DIVISION_ID = C.DIVISION_ID
											AND A.SCM_SITE_ID = C.SCM_SITE_ID
											AND C.SITE_TYPE		= 'SALES'
											AND C.VALID_YN = 'Y'
										  LEFT OUTER JOIN SCM_MST_SITE_ITEM D WITH(NOLOCK)
										  ON A.DIVISION_ID = D.DIVISION_ID
											AND A.PROJECT_CODE = D.PROJECT_CODE
											AND A.SCM_SITE_ID = D.SCM_SITE_ID
											AND A.ITEM_ID = D.ITEM_ID
										  LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO E WITH(NOLOCK)
										  ON C.DEPT_ID = E.DEPT_ID
										  LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO F WITH(NOLOCK)
										  ON E.UPPER_DEPT_ID = F.DEPT_ID
										  LEFT OUTER JOIN SCM_MST_CITY G 
										  ON C.COUNTRY = G.COUNTRY
											AND C.CITY = G.CITY  
										  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V H WITH(NOLOCK)  
										  ON A.DIVISION_ID = H.DIVISION_ID  
											AND A.ITEM_ID   = H.ITEM_ID  
										  LEFT OUTER JOIN SCM_MST_PROJECT I 
										  ON A.DIVISION_ID = I.DIVISION_ID 
											AND A.PROJECT_CODE = I.PROJECT_CODE
										  WHERE A.MEASURE IN ('CUST_FCST', 'Customer FCST')
										  AND A.DIVISION_ID = @v_division_id
										  AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) >= @v_from_date										  
										) AA
						END		

				END

		END

	END TRY
    BEGIN CATCH

			SET @v_log_type = 'ERROR';
			SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
			SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
			SET @d_event_date = SYSDATETIME();
			SELECT 'catch', @v_log_message 

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH

    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @v_from_date + '(' + @p_division_id + '_' + @p_accept_flag + ')';
    SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
  END;
