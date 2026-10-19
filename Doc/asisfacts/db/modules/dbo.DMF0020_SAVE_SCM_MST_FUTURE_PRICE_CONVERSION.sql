
/*
 * Program ID   : DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION
 * Description  : SCM_MST_FUTURE_PRICE Data Conversion 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 02. 22    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180720 KHSONG 주석처리 전체를 다시 계산함
 * 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2021.05.13	P.C.I		[PJ20209642R] Chempion 환율 적용
 * 2022.10.24	ROSIA27		[C20221024-000510]DM UI 소스 정리 요청
 * 2025.03.25	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_SELLING_PRICE 재생성
 */
-- Weekly Cutoff 시에 이 로직이 수행되어야 함.  

CREATE PROCEDURE [dbo].[DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION]

	-- Add the parameters for the stored procedure here
	 @p_division_id            NVARCHAR(30)

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- cursor 별 로딩할 변수설정
    DECLARE @v_DIVISION_ID           nvarchar(MAX)    ;
    DECLARE @v_PROJECT_CODE          nvarchar(MAX)    ;
    DECLARE @v_SCM_SITE_ID           nvarchar(MAX)    ;
    DECLARE @v_PLANT_SITE_ID         nvarchar(MAX)    ;
    DECLARE @v_ITEM_ID               nvarchar(MAX)    ;
    DECLARE @v_YYYYMMDD              nvarchar(MAX)    ;
    DECLARE @v_CURRENCY              nvarchar(MAX)    ;
    DECLARE @v_MEASURE               nvarchar(MAX)    ;
    DECLARE @v_DOM_EXP               nvarchar(MAX)    ;
    DECLARE @v_FCST_TYPE             nvarchar(MAX)    ;
    DECLARE @v_INCOTERMS             nvarchar(MAX)    ;
    DECLARE @v_PRICE                 numeric(20,10)   ;
    DECLARE @v_CREATED_BY            nvarchar(MAX)    ;
    DECLARE @v_CREATION_DATE         DATETIME         ;
    DECLARE @v_LAST_UPDATED_BY       nvarchar(MAX)    ;
    DECLARE @v_LAST_UPDATE_DATE      DATETIME         ;
    DECLARE @v_ROW_COUNT             nvarchar(MAX)    ;

    DECLARE @n1_MEASURE              nvarchar(MAX)    ;
    DECLARE @n2_MEASURE              nvarchar(MAX)    ;
    DECLARE @n1_PRICE                numeric(20,10)   ;
    DECLARE @n2_PRICE                numeric(20,10)   ;
	


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = 'DIVISION_ID : ' + @p_division_id;
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION SCM_MST_FUTURE_PRICE_CONVERSION;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
		

		BEGIN	
		   
			IF OBJECT_ID('tempdb..#FUTURE_PRICE_TEMP1') IS NOT NULL
			BEGIN 
				DROP TABLE  #FUTURE_PRICE_TEMP1;
			END 

			IF OBJECT_ID('tempdb..#FUTURE_PRICE_TEMP2') IS NOT NULL
			BEGIN 
				DROP TABLE  #FUTURE_PRICE_TEMP2;
			END 
 -- PRINT N'CONVERSION2 START =>' + CONVERT(VARCHAR(8), GETDATE(), 108)	
PRINT @v_program_name +' : A001--' + CONVERT(VARCHAR(30), GETDATE(), 121);

			SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMMDD,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS,PRICE,CREATED_BY 
			INTO #FUTURE_PRICE_TEMP1
			FROM dbo.SCM_MST_FUTURE_PRICE WITH(NOLOCK) 
			WHERE DIVISION_ID = @p_division_id
				AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일이후 데이터만 대상으로함
				AND MEASURE = 'LOC';
			-- GROUP BY DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMMDD,CURRENCY,DOM_EXP,FCST_TYPE,INCOTERMS;
			
PRINT @v_program_name +' : A002--' + CONVERT(VARCHAR(30), GETDATE(), 121);		

			SELECT 
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
				,ROUND(PRICE, 3) AS PRICE
				,CREATED_BY
			INTO #FUTURE_PRICE_TEMP2
			FROM (
				SELECT A.DIVISION_ID
				,PROJECT_CODE
				,SCM_SITE_ID
				,PLANT_SITE_ID
				,ITEM_ID
				,A.YYYYMMDD
				,A.CURRENCY
				,CASE	WHEN A.CURRENCY = 'KRW' THEN 'KRW'  
						WHEN A.CURRENCY = 'USD' THEN 'USD'  
						ELSE 'KRW' END MEASURE
				,DOM_EXP
				,FCST_TYPE
				,INCOTERMS
				,CASE	WHEN A.CURRENCY = 'KRW' THEN PRICE 
						WHEN A.CURRENCY = 'USD' THEN PRICE
						ELSE PRICE * ISNULL(B.EXCHANGE_PRICE,1)  END PRICE
				,A.CREATED_BY
			FROM #FUTURE_PRICE_TEMP1 AS A
			LEFT OUTER JOIN DM_MST_EXCHANGE_RATE AS B WITH(NOLOCK) 
								ON A.DIVISION_ID = B.DIVISION_ID
								AND SUBSTRING(A.YYYYMMDD, 1, 6) + '01' = B.YYYYMMDD
								AND B.CURRENCY = 'KRW'
								AND A.CURRENCY = B.UNIT_CURRENCY
								
			UNION ALL
			SELECT A.DIVISION_ID
				,PROJECT_CODE
				,SCM_SITE_ID
				,PLANT_SITE_ID
				,ITEM_ID
				,A.YYYYMMDD
				,A.CURRENCY
				,CASE	WHEN A.CURRENCY = 'KRW' THEN 'USD'  
						WHEN A.CURRENCY = 'USD' THEN 'KRW'  
						ELSE 'USD' END MEASURE
				,DOM_EXP
				,FCST_TYPE
				,INCOTERMS
				,CASE	WHEN A.CURRENCY = 'KRW' THEN ISNULL(PRICE / ISNULL(B.EXCHANGE_PRICE,1),0)  
						WHEN A.CURRENCY = 'USD' THEN ISNULL(PRICE * ISNULL(B.EXCHANGE_PRICE,1),0) 
						ELSE ISNULL((A.PRICE * ISNULL((SELECT DMER.EXCHANGE_PRICE FROM dbo.DM_MST_EXCHANGE_RATE AS DMER WITH(NOLOCK) where DMER.DIVISION_ID = A.DIVISION_ID  
                                AND DMER.YYYYMMDD = SUBSTRING(A.YYYYMMDD, 1, 6) + '01' AND DMER.UNIT_CURRENCY = A.CURRENCY AND DMER.CURRENCY = 'KRW'),1)) 
							/ ISNULL(B.EXCHANGE_PRICE,1),0) END PRICE
				,A.CREATED_BY
			FROM #FUTURE_PRICE_TEMP1 AS  A
			LEFT OUTER JOIN DM_MST_EXCHANGE_RATE AS B WITH(NOLOCK) 
							ON A.DIVISION_ID = B.DIVISION_ID
							AND SUBSTRING(A.YYYYMMDD, 1, 6) + '01' = B.YYYYMMDD
							AND B.CURRENCY = 'KRW'
							AND B.UNIT_CURRENCY  =  'USD' 	
			) AS C
			WHERE PRICE > 0;
PRINT @v_program_name +' : A003--' + CONVERT(VARCHAR(30), GETDATE(), 121);

			--확인 SELECT 'DATA'
			--확인 SELECT * FROM #FUTURE_PRICE_TEMP3
			BEGIN

				MERGE INTO SCM_MST_FUTURE_PRICE AS A
				USING  #FUTURE_PRICE_TEMP2   AS B
				ON (		A.DIVISION_ID     =  B.DIVISION_ID
					   and  A.PROJECT_CODE    =  B.PROJECT_CODE                         
					   and  A.SCM_SITE_ID     =  B.SCM_SITE_ID                         
					   and  A.PLANT_SITE_ID   =  B.PLANT_SITE_ID                         
					   and  A.ITEM_ID         =  B.ITEM_ID   
					   and  A.YYYYMMDD        =  B.YYYYMMDD 
					   and  A.CURRENCY        =  B.CURRENCY                         
					   and  A.MEASURE         =  B.MEASURE                         
					   and  A.DOM_EXP         =  B.DOM_EXP                         
					   and  A.FCST_TYPE       =  B.FCST_TYPE                         
					   and  A.INCOTERMS       =  B.INCOTERMS )
				WHEN MATCHED THEN
					UPDATE SET	A.PRICE				= B.PRICE
								,A.CREATION_DATE	= SYSDATETIME()
								,A.LAST_UPDATED_BY	= 'SYSTEM'
								,A.LAST_UPDATE_DATE	= SYSDATETIME()
				WHEN NOT MATCHED THEN
					INSERT ( DIVISION_ID
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
					) VALUES(
							B.DIVISION_ID
							,B.PROJECT_CODE
							,B.SCM_SITE_ID
							,B.PLANT_SITE_ID
							,B.ITEM_ID
							,B.YYYYMMDD
							,B.CURRENCY
							,B.MEASURE
							,B.DOM_EXP
							,B.FCST_TYPE
							,B.INCOTERMS
							,B.PRICE
							,B.CREATED_BY
							,SYSDATETIME() 
							,'SYSTEM'
							,SYSDATETIME()
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
					);
			END
			
PRINT @v_program_name +' : A004--' + CONVERT(VARCHAR(30), GETDATE(), 121);

			--[PJ2025-50017] 소형 매출계획 동기화 개선 Start - DM_PLN_CFM_MKT_DEMAND_PLAN 의 MKT_AMT 업데이트

 			IF OBJECT_ID('tempdb..#CFM_SELLING_PRICE_TEMP1') IS NOT NULL
			BEGIN 
				DROP TABLE  #CFM_SELLING_PRICE_TEMP1;
			END 

			IF OBJECT_ID('tempdb..#CFM_SELLING_PRICE_TEMP2') IS NOT NULL
			BEGIN 
				DROP TABLE  #CFM_SELLING_PRICE_TEMP2;
			END 


			SELECT DIVISION_ID,PROJECT_CODE,END_CUSTOMER,SCM_SITE_ID,PLANT_SITE_ID,CELL_PROD_SITE_ID,ITEM_ID,YYYYMMDD,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS,PRICE,CREATED_BY,CREATION_DATE
			INTO #CFM_SELLING_PRICE_TEMP1
			FROM dbo.DM_PLN_CFM_SELLING_PRICE WITH(NOLOCK) 
			WHERE DIVISION_ID = @p_division_id
				AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일이후 데이터만 대상으로함
				AND MEASURE = 'LOC';



			SELECT 
				DIVISION_ID
				,PROJECT_CODE
				,END_CUSTOMER
				,SCM_SITE_ID
				,PLANT_SITE_ID
				,CELL_PROD_SITE_ID
				,ITEM_ID
				,YYYYMMDD
				,CURRENCY
				,MEASURE
				,DOM_EXP
				,FCST_TYPE
				,INCOTERMS
				,ROUND(PRICE, 3) AS PRICE
				,CREATED_BY
				,CREATION_DATE
			INTO #CFM_SELLING_PRICE_TEMP2
			FROM (
				SELECT A.DIVISION_ID
				,A.PROJECT_CODE
				,A.END_CUSTOMER
				,A.SCM_SITE_ID
				,A.PLANT_SITE_ID
				,A.CELL_PROD_SITE_ID
				,A.ITEM_ID
				,A.YYYYMMDD
				,A.CURRENCY
				,CASE	WHEN A.CURRENCY = 'KRW' THEN 'KRW'  
						WHEN A.CURRENCY = 'USD' THEN 'USD'  
						ELSE 'KRW' END MEASURE
				,A.DOM_EXP
				,A.FCST_TYPE
				,A.INCOTERMS
				,CASE	WHEN A.CURRENCY = 'KRW' THEN A.PRICE 
						WHEN A.CURRENCY = 'USD' THEN A.PRICE
						ELSE A.PRICE * ISNULL(B.EXCHANGE_PRICE,1)  END PRICE
				,A.CREATED_BY
				,A.CREATION_DATE
			FROM #CFM_SELLING_PRICE_TEMP1 AS A
			LEFT OUTER JOIN DM_MST_EXCHANGE_RATE AS B WITH(NOLOCK) 
								ON A.DIVISION_ID = B.DIVISION_ID
								AND SUBSTRING(A.YYYYMMDD, 1, 6) + '01' = B.YYYYMMDD
								AND B.CURRENCY = 'KRW'
								AND A.CURRENCY = B.UNIT_CURRENCY
								
			UNION ALL
			SELECT A.DIVISION_ID
				,A.PROJECT_CODE
				,A.END_CUSTOMER
				,A.SCM_SITE_ID
				,A.PLANT_SITE_ID
				,A.CELL_PROD_SITE_ID
				,A.ITEM_ID
				,A.YYYYMMDD
				,A.CURRENCY
				,CASE	WHEN A.CURRENCY = 'KRW' THEN 'USD'  
						WHEN A.CURRENCY = 'USD' THEN 'KRW'  
						ELSE 'USD' END MEASURE
				,A.DOM_EXP
				,A.FCST_TYPE
				,A.INCOTERMS
				,CASE	WHEN A.CURRENCY = 'KRW' THEN ISNULL(A.PRICE / ISNULL(B.EXCHANGE_PRICE,1),0)  
						WHEN A.CURRENCY = 'USD' THEN ISNULL(A.PRICE * ISNULL(B.EXCHANGE_PRICE,1),0) 
						ELSE ISNULL((A.PRICE * ISNULL((SELECT DMER.EXCHANGE_PRICE FROM dbo.DM_MST_EXCHANGE_RATE AS DMER WITH(NOLOCK) where DMER.DIVISION_ID = A.DIVISION_ID  
                                AND DMER.YYYYMMDD = SUBSTRING(A.YYYYMMDD, 1, 6) + '01' AND DMER.UNIT_CURRENCY = A.CURRENCY AND DMER.CURRENCY = 'KRW'),1)) 
							/ ISNULL(B.EXCHANGE_PRICE,1),0) END PRICE
				,A.CREATED_BY
				,A.CREATION_DATE
			FROM #CFM_SELLING_PRICE_TEMP1 AS  A
			LEFT OUTER JOIN DM_MST_EXCHANGE_RATE AS B WITH(NOLOCK) 
							ON A.DIVISION_ID = B.DIVISION_ID
							AND SUBSTRING(A.YYYYMMDD, 1, 6) + '01' = B.YYYYMMDD
							AND B.CURRENCY = 'KRW'
							AND B.UNIT_CURRENCY  =  'USD' 	
			) AS C
			WHERE PRICE > 0;
			
PRINT @v_program_name +' : A005--' + CONVERT(VARCHAR(30), GETDATE(), 121);	

			BEGIN
				-- DM_PLN_CFM_SELLING_PRICE 의 USD/KRW 업데이트
				MERGE INTO DM_PLN_CFM_SELLING_PRICE AS A
				USING  #CFM_SELLING_PRICE_TEMP2   AS B
				ON (		A.DIVISION_ID		=  B.DIVISION_ID
					   AND  A.PROJECT_CODE		=  B.PROJECT_CODE                         
					   AND  A.END_CUSTOMER		=  B.END_CUSTOMER                         
					   AND  A.SCM_SITE_ID		=  B.SCM_SITE_ID                         
					   AND  A.PLANT_SITE_ID		=  B.PLANT_SITE_ID                         
					   AND  A.CELL_PROD_SITE_ID	=  B.CELL_PROD_SITE_ID                         
					   AND  A.ITEM_ID			=  B.ITEM_ID   
					   AND  A.YYYYMMDD			=  B.YYYYMMDD 
					   AND  A.CURRENCY			=  B.CURRENCY                         
					   AND  A.MEASURE			=  B.MEASURE                         
					   AND  A.DOM_EXP			=  B.DOM_EXP                         
					   AND  A.FCST_TYPE			=  B.FCST_TYPE                         
					   AND  A.INCOTERMS			=  B.INCOTERMS 
					)
				WHEN MATCHED THEN
					UPDATE SET	A.PRICE				= B.PRICE
								,A.LAST_UPDATED_BY	= 'EXCHANGE_RATE'
								,A.LAST_UPDATE_DATE	= SYSDATETIME()
				WHEN NOT MATCHED THEN
					INSERT ( DIVISION_ID
							,PROJECT_CODE
							,END_CUSTOMER
							,SCM_SITE_ID
							,PLANT_SITE_ID
							,CELL_PROD_SITE_ID
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
					) VALUES(
							B.DIVISION_ID
							,B.PROJECT_CODE
							,B.END_CUSTOMER
							,B.SCM_SITE_ID
							,B.PLANT_SITE_ID
							,B.CELL_PROD_SITE_ID
							,B.ITEM_ID
							,B.YYYYMMDD
							,B.CURRENCY
							,B.MEASURE
							,B.DOM_EXP
							,B.FCST_TYPE
							,B.INCOTERMS
							,B.PRICE
							,B.CREATED_BY
							,B.CREATION_DATE
							,'EXCHANGE_RATE'
							,SYSDATETIME()
					);
			END
			--[PJ2025-50017] 소형 매출계획 동기화 개선 Start - DM_PLN_CFM_MKT_DEMAND_PLAN 의 MKT_AMT 업데이트

			
PRINT @v_program_name +' : A006--' + CONVERT(VARCHAR(30), GETDATE(), 121);

		END	
        /*---------------------------------------------------------------*/

     -- IF @@TRANCOUNT > 0 
  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	  --[C20200909-000203] LOG 표준화 적용
	  ROLLBACK TRANSACTION SCM_MST_FUTURE_PRICE_CONVERSION;
	  SELECT 'ERROR';

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  --[C20200909-000203] LOG 표준화 적용
	  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

	-- 트랜잭션 (END)

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	


	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
	  --SELECT 'success'
	  SELECT N'Sales Price Recalculation is Complete'
	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    --SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
