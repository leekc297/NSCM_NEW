
/*
 * Program ID   : PR_DM_MOBILE_FUTURE_PRICE_MONTH
 * Description  : 'SCM_MST_FUTURE_PRICE' TABLE INSERT/UPDATE/DELETE 소형용임시
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 08. 01    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 */

CREATE PROCEDURE [dbo].[PR_DM_MOBILE_FUTURE_PRICE_MONTH]

	-- Add the parameters for the stored procedure here
	 --@p_division_id            NVARCHAR(MAX)

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

    DECLARE @in_DIVISION_ID      nvarchar(MAX);
	DECLARE @in_created_by       NVARCHAR(MAX);
	DECLARE @in_start_date       NVARCHAR(MAX);

	set @in_DIVISION_ID = '40'
	set @in_created_by = 'mobile_conv'
	set @in_start_date = '20180801'  -- CONVERT(VARCHAR(6), GETDATE(), 112) + '01'  -- 당월1일부터

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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MOBILE_FUTURE_PRICE_MONTH'; --[C20200909-000203] LOG 표준화 적용
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
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

			-- Temp Table0 존재여부 확인하여 삭제
			IF OBJECT_ID('tempdb..#FUTURE_PRICE_TEMP0') IS NOT NULL
				BEGIN 
					DROP TABLE  #FUTURE_PRICE_TEMP0
				END 

			-- Temp Table0 에 작업대상을 저장
			SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMMDD,CURRENCY,DOM_EXP,FCST_TYPE,INCOTERMS,COUNT(*) AS G_COUNT 
				 INTO #FUTURE_PRICE_TEMP0
			 FROM dbo.SCM_MST_FUTURE_PRICE WITH(NOLOCK) WHERE 1=1
				  AND DIVISION_ID = @in_division_id
				  AND YYYYMMDD >= @in_start_date -- '20180701'일부터
   		      GROUP BY DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMMDD,CURRENCY,DOM_EXP,FCST_TYPE,INCOTERMS
			   ORDER BY DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMMDD,CURRENCY,DOM_EXP,FCST_TYPE,INCOTERMS

			-- Temp Table1 존재여부 확인하여 삭제
			IF OBJECT_ID('tempdb..#FUTURE_PRICE_TEMP1') IS NOT NULL
				BEGIN 
					DROP TABLE  #FUTURE_PRICE_TEMP1
				END 

			-- Temp Table1 에 작업대상을 저장
			SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMMDD,CURRENCY,DOM_EXP,FCST_TYPE,INCOTERMS,G_COUNT 
				 INTO #FUTURE_PRICE_TEMP1
			 FROM #FUTURE_PRICE_TEMP0 WITH(NOLOCK) WHERE 1=1
					  --AND G_COUNT < 3     -- 3개 정상 셋트가 아닌경우만 대상으로함 -> 20180720 KHSONG 주석처리 전체를 다시 계산함
   		      GROUP BY DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMMDD,CURRENCY,DOM_EXP,FCST_TYPE,INCOTERMS,G_COUNT
			   ORDER BY DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMMDD,CURRENCY,DOM_EXP,FCST_TYPE,INCOTERMS,G_COUNT

			-- Temp Table2 존재여부 확인하여 삭제
			IF OBJECT_ID('tempdb..#FUTURE_PRICE_TEMP2') IS NOT NULL
				BEGIN 
					DROP TABLE  #FUTURE_PRICE_TEMP2          
				END 

			-- 대상데이터 INSERT
			SELECT B.DIVISION_ID,B.PROJECT_CODE,B.SCM_SITE_ID,B.PLANT_SITE_ID,B.ITEM_ID,B.YYYYMMDD,B.CURRENCY,MEASURE,B.DOM_EXP,B.FCST_TYPE,B.INCOTERMS,B.PRICE
			      ,B.CREATED_BY,B.CREATION_DATE,B.LAST_UPDATED_BY,B.LAST_UPDATE_DATE
			      ,A.G_COUNT,row_number() OVER (ORDER BY B.DIVISION_ID) AS ROW_COUNT
				 INTO #FUTURE_PRICE_TEMP2
			 FROM #FUTURE_PRICE_TEMP1 A WITH(NOLOCK)
			 LEFT JOIN dbo.SCM_MST_FUTURE_PRICE B WITH(NOLOCK)
			  ON (
					A.DIVISION_ID      =    B.DIVISION_ID     
				AND A.PROJECT_CODE     =    B.PROJECT_CODE    
				AND A.SCM_SITE_ID      =    B.SCM_SITE_ID     
				AND A.PLANT_SITE_ID    =    B.PLANT_SITE_ID   
				AND A.ITEM_ID          =    B.ITEM_ID         
				AND A.YYYYMMDD         =    B.YYYYMMDD        
				AND A.CURRENCY         =    B.CURRENCY        
				AND A.DOM_EXP          =    B.DOM_EXP         
				AND A.FCST_TYPE        =    B.FCST_TYPE       
				AND A.INCOTERMS        =    B.INCOTERMS       
			  )
			ORDER BY A.G_COUNT

			-- Temp Table3 존재여부 확인하여 삭제
			IF OBJECT_ID('tempdb..#FUTURE_PRICE_TEMP3') IS NOT NULL
				BEGIN 
					DROP TABLE  #FUTURE_PRICE_TEMP3
				END 

			SELECT TOP 0 * INTO #FUTURE_PRICE_TEMP3
				FROM dbo.SCM_MST_FUTURE_PRICE WITH(NOLOCK) ;  -- TEMP 테이블 컬럼생성

			-- 데이터 확인
			--SELECT * FROM #FUTURE_PRICE_TEMP1
			--SELECT '#FUTURE_PRICE_TEMP2'
			--SELECT COUNT(*) FROM #FUTURE_PRICE_TEMP2

			-- 데이터 확인하여 INSERT

		    -- 커서 확인후 초기화
			IF  EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'future_price_cur') 
			BEGIN
				close future_price_cur
				deallocate future_price_cur
			END;

			declare future_price_cur cursor fast_forward for
			select      DIVISION_ID     
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
					   ,ROW_COUNT
				from #FUTURE_PRICE_TEMP2  WITH(NOLOCK)
				ORDER BY ROW_COUNT

		    -- 커서 오픈
			open future_price_cur;

			--------------------------------------------------------------------------------------------------------
			fetch next from future_price_cur into
                        @v_DIVISION_ID     
					   ,@v_PROJECT_CODE    
					   ,@v_SCM_SITE_ID     
					   ,@v_PLANT_SITE_ID   
					   ,@v_ITEM_ID         
					   ,@v_YYYYMMDD        
					   ,@v_CURRENCY        
					   ,@v_MEASURE         
					   ,@v_DOM_EXP         
					   ,@v_FCST_TYPE       
					   ,@v_INCOTERMS       
					   ,@v_PRICE           
					   ,@v_CREATED_BY      
					   ,@v_CREATION_DATE   
					   ,@v_LAST_UPDATED_BY 
					   ,@v_LAST_UPDATE_DATE
					   ,@v_ROW_COUNT
			--------------------------------------------------------------------------------------------------------
			while @@FETCH_STATUS = 0 
			--------------------------------------------------------------------------------------------------------
			BEGIN
			--------------------------------------------------------------------------------------------------------

			  -- 변수 초기화
			  SET @n1_MEASURE = NULL;
			  SET @n2_MEASURE = NULL;
			  SET @n1_PRICE   = 0;
			  SET @n2_PRICE   = 0;
			--------------------------------------------------------------------------------------------------------
			  IF  @v_MEASURE='LOC' AND @v_CURRENCY = 'KRW'   -- LOCAL CURRENCY 가 KRW 인경우 INPUT PRICE 그대로 사용하면됨
			      BEGIN
				    -- KRW SETTING
				    set @n1_MEASURE = 'KRW'
				    set @n1_PRICE   = @v_PRICE

				    -- USD 산출
				    set @n2_MEASURE = 'USD'
                    SET @n2_PRICE = ISNULL(@v_PRICE / ISNULL((SELECT EXCHANGE_PRICE FROM dbo.DM_MST_EXCHANGE_RATE where DIVISION_ID = @v_DIVISION_ID  
			                                   AND YYYYMMDD = SUBSTRING(@v_YYYYMMDD, 1, 6) + '01' AND UNIT_CURRENCY = 'USD'),1),0)
			      END

			  IF  @v_MEASURE='LOC' AND @v_CURRENCY = 'USD'   -- LOCAL CURRENCY 가 USD 인경우 INPUT PRICE 그대로 사용하면됨
			      BEGIN
				    -- USD SETTING
				    set @n1_MEASURE = 'USD'
				    set @n1_PRICE   = @v_PRICE

				    -- KRW 산출
				    set @n2_MEASURE = 'KRW'
                    SET @n2_PRICE = ISNULL(@v_PRICE * ISNULL((SELECT EXCHANGE_PRICE FROM dbo.DM_MST_EXCHANGE_RATE where DIVISION_ID = @v_DIVISION_ID  
			                                   AND YYYYMMDD = SUBSTRING(@v_YYYYMMDD, 1, 6) + '01' AND UNIT_CURRENCY = 'USD'),1),0)
			      END

			  IF  @v_MEASURE='LOC' AND @v_CURRENCY NOT IN ('KRW','USD')
			      BEGIN
				    set @n1_MEASURE = 'KRW'
				    -- KRW 산출
                    SET @n1_PRICE = @v_PRICE * ISNULL((SELECT EXCHANGE_PRICE FROM dbo.DM_MST_EXCHANGE_RATE where DIVISION_ID = @v_DIVISION_ID  
			                                   AND YYYYMMDD = SUBSTRING(@v_YYYYMMDD, 1, 6) + '01' AND UNIT_CURRENCY = @v_CURRENCY),1)
				    set @n2_MEASURE = 'USD'
                    SET @n2_PRICE = ISNULL(@n1_PRICE / ISNULL((SELECT EXCHANGE_PRICE FROM dbo.DM_MST_EXCHANGE_RATE where DIVISION_ID = @v_DIVISION_ID  
			                                   AND YYYYMMDD = SUBSTRING(@v_YYYYMMDD, 1, 6) + '01' AND UNIT_CURRENCY = 'USD'),1),0)
			      END


			  IF  @n1_MEASURE IS NOT NULL AND @n1_PRICE > 0
			    BEGIN
					-- INSERT #1
					insert into  #FUTURE_PRICE_TEMP3
						(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMMDD,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS,PRICE
						,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
						,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10)
					values
						(@v_DIVISION_ID,@v_PROJECT_CODE,@v_SCM_SITE_ID,@v_PLANT_SITE_ID,@v_ITEM_ID,@v_YYYYMMDD,@v_CURRENCY,@n1_MEASURE
						,@v_DOM_EXP,@v_FCST_TYPE,@v_INCOTERMS,@n1_PRICE,@in_created_by,SYSDATETIME(),@in_created_by,SYSDATETIME()
						,null,null,null,null,null,null,null,null,null,null)
			    END
	
			  IF  @n2_MEASURE IS NOT NULL AND @n2_PRICE > 0
			    BEGIN
					-- INSERT #2
					insert into  #FUTURE_PRICE_TEMP3
						(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMMDD,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS,PRICE
						,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
						,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10)
					values
						(@v_DIVISION_ID,@v_PROJECT_CODE,@v_SCM_SITE_ID,@v_PLANT_SITE_ID,@v_ITEM_ID,@v_YYYYMMDD,@v_CURRENCY,@n2_MEASURE     
						,@v_DOM_EXP,@v_FCST_TYPE,@v_INCOTERMS,@n2_PRICE,@in_created_by,SYSDATETIME(),@in_created_by,SYSDATETIME()
						,null,null,null,null,null,null,null,null,null,null)
			    END

			--------------------------------------------------------------------------------------------------------
			fetch next from future_price_cur into
                        @v_DIVISION_ID     
					   ,@v_PROJECT_CODE    
					   ,@v_SCM_SITE_ID     
					   ,@v_PLANT_SITE_ID   
					   ,@v_ITEM_ID         
					   ,@v_YYYYMMDD        
					   ,@v_CURRENCY        
					   ,@v_MEASURE         
					   ,@v_DOM_EXP         
					   ,@v_FCST_TYPE       
					   ,@v_INCOTERMS       
					   ,@v_PRICE           
					   ,@v_CREATED_BY      
					   ,@v_CREATION_DATE   
					   ,@v_LAST_UPDATED_BY 
					   ,@v_LAST_UPDATE_DATE
					   ,@v_ROW_COUNT
			END
			--------------------------------------------------------------------------------------------------------
			close future_price_cur
			deallocate  future_price_cur

			--확인 SELECT 'DATA'
			--확인 SELECT * FROM #FUTURE_PRICE_TEMP3
			BEGIN
			DELETE
				FROM  dbo.SCM_MST_FUTURE_PRICE 
                  WHERE (
                    SELECT count(1) 
					  FROM #FUTURE_PRICE_TEMP3 B WITH(NOLOCK)
				     where  1=1
					   and  SCM_MST_FUTURE_PRICE.DIVISION_ID     =  B.DIVISION_ID
					   and  SCM_MST_FUTURE_PRICE.PROJECT_CODE    =  B.PROJECT_CODE                         
					   and  SCM_MST_FUTURE_PRICE.SCM_SITE_ID     =  B.SCM_SITE_ID                         
					   and  SCM_MST_FUTURE_PRICE.PLANT_SITE_ID   =  B.PLANT_SITE_ID                         
					   and  SCM_MST_FUTURE_PRICE.ITEM_ID         =  B.ITEM_ID                         
					   and  SCM_MST_FUTURE_PRICE.YYYYMMDD        =  B.YYYYMMDD                         
					   and  SCM_MST_FUTURE_PRICE.CURRENCY        =  B.CURRENCY                         
					   and  SCM_MST_FUTURE_PRICE.MEASURE         =  B.MEASURE                         
					   and  SCM_MST_FUTURE_PRICE.DOM_EXP         =  B.DOM_EXP                         
					   and  SCM_MST_FUTURE_PRICE.FCST_TYPE       =  B.FCST_TYPE                         
					   and  SCM_MST_FUTURE_PRICE.INCOTERMS       =  B.INCOTERMS                         
				  ) > 0
			END


  			BEGIN
			INSERT INTO dbo.SCM_MST_FUTURE_PRICE
			(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMMDD,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS,PRICE
						,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
						,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10)
			  SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMMDD,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS,PRICE
						,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
						,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
						 FROM #FUTURE_PRICE_TEMP3 WITH(NOLOCK)
			END


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
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION SCM_MST_FUTURE_PRICE_CONVERSION;
	  SELECT 'ERROR';

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
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
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
