
CREATE PROCEDURE [dbo].[jjg_test_fifo]
(                         
      @p_division_id          NVARCHAR(30)            
    , @p_plan_start_yyyymmdd  NVARCHAR(8)     -- plan_name         
)                         
AS                        
  BEGIN 	

    BEGIN TRY                        
    BEGIN  

	-- exec jjg_test_fifo '82', '20240610'

			DECLARE @V_DIVISION_ID		        NVARCHAR(10)	= ISNULL(@P_DIVISION_ID, '82')
			DECLARE @V_PLAN_START_YYYYMMDD		NVARCHAR(8)		= ISNULL(@p_plan_start_yyyymmdd, '20240610')
			DECLARE @V_HORIZON_END_YYYYMMDD		NVARCHAR(8)		= '20250608'
				

			-------------------------------------------------------------------------------------------------------------                         
			-- 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서                        
			-------------------------------------------------------------------------------------------------------------                   
			IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED') IS NOT NULL                        
				DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED   

			IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO') IS NOT NULL                        
				DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO    
			  

			CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED(                        
						DIVISION_ID             NVARCHAR(10)    NULL,
						COMPANY_ID			    NVARCHAR(10)    NULL,
						PLANT_ID			    NVARCHAR(10)	NULL,
						PLAN_START_YYYYMMDD     NVARCHAR(8)     NULL,
						CELL_ITEM_ID            NVARCHAR(40)    NULL,       
						ITEM_ID                 NVARCHAR(40)    NULL,
						MEASURE                 NVARCHAR(40)    NULL,
						VALUE_TYPE				NVARCHAR(10)    NULL,
						TO_PRODUCT				NVARCHAR(100)   NULL,
						SEQ_FLAG				NVARCHAR(5)     NULL,
						YYYYMMDD			    NVARCHAR(8)     NULL,
						QTY			            NUMERIC(20, 10) NULL,   
						PRIORITY				INT				NULL,
						END_FLAG				NVARCHAR(1)     DEFAULT 'N'   -- 'Y'/'N'
			)       


			CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO(                        
						DIVISION_ID             NVARCHAR(10)    NULL,
						COMPANY_ID			    NVARCHAR(10)    NULL,
						PLANT_ID			    NVARCHAR(10)	NULL,
						PLAN_START_YYYYMMDD     NVARCHAR(8)     NULL,
						CELL_ITEM_ID            NVARCHAR(40)    NULL,       
						ITEM_ID                 NVARCHAR(40)    NULL,
						MEASURE                 NVARCHAR(40)    NULL,
						VALUE_TYPE				NVARCHAR(10)    NULL,
						TO_PRODUCT				NVARCHAR(100)   NULL,
						SEQ_FLAG				NVARCHAR(5)     NULL,
						YYYYMMDD			    NVARCHAR(8)     NULL,
						QTY			            NUMERIC(20, 10) NULL,   
						REMAIN_QTY	            NUMERIC(20, 10) NULL,   
						PRIORITY				INT				NULL,
						END_FLAG				NVARCHAR(1)     DEFAULT 'N'   -- 'Y'/'N'
			)       

	------ 기초 데이터 생성 START -------------	
	
						insert into #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED
						select  DIVISION_ID, 
								COMPANY_ID,
								PLANT_ID,
								PLAN_START_YYYYMMDD,
								CELL_ITEM_ID,
								ITEM_ID,
								'SHIP_PLAN' AS MEASURE,
								'PRD' AS VALUE_TYPE,
								TO_PRODUCT,
								'321' AS SEQ_FLAG,
								(CASE WHEN LEFT(@V_PLAN_START_YYYYMMDD,6) = LEFT(YYYYMMDD,6)  THEN @V_PLAN_START_YYYYMMDD 
								      ELSE LEFT(YYYYMMDD,6) + '01'
									  END) AS YYYYMMDD,
								isnull(sum(isnull(QTY,0)),0) AS QTY,
								1,
								'N'
						from SCP_ANL_PSI_INTEGRATION_ESS a with(nolock)
						where DIVISION_ID = @V_DIVISION_ID --'82'
						AND PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD --'20240610'
						and seq_flag in ('310','320')
						and qty <> 0
						group by	DIVISION_ID, 
									COMPANY_ID,
									PLANT_ID,
									PLAN_START_YYYYMMDD,
									CELL_ITEM_ID,
									ITEM_ID,
									VALUE_TYPE,
									TO_PRODUCT,
									--SEQ_FLAG,
									(CASE WHEN LEFT(@V_PLAN_START_YYYYMMDD,6) = LEFT(YYYYMMDD,6)  THEN @V_PLAN_START_YYYYMMDD 
								      ELSE LEFT(YYYYMMDD,6) + '01'
									  END)

	--'IN_HOUSE_MOVING' 생성
						insert into #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED
						select  DIVISION_ID, 
								COMPANY_ID,
								PLANT_ID,
								PLAN_START_YYYYMMDD,
								CELL_ITEM_ID,
								ITEM_ID,
								'IN_HOUSE_MOVING' AS MEASURE,
								VALUE_TYPE,
								TO_PRODUCT,
								'331' AS SEQ_FLAG,
								YYYYMMDD,
								isnull(sum(isnull(QTY,0)),0) AS QTY,
								2,
								'N'
						from SCP_ANL_PSI_INTEGRATION_ESS a with(nolock) 
						where DIVISION_ID = @V_DIVISION_ID 
						AND PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD 
						and seq_flag in ('330')
						and qty <> 0
						group by	DIVISION_ID, 
									COMPANY_ID,
									PLANT_ID,
									PLAN_START_YYYYMMDD,
									CELL_ITEM_ID,
									ITEM_ID,
									VALUE_TYPE,
									TO_PRODUCT,
									YYYYMMDD


--  == 이하 재고 생성 START
	--'SEMI_WH_IN' 생성

						insert into #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO
						select  h.DIVISION_ID, 
										h.COMPANY_ID,
										h.PLANT_ID,
										h.PLAN_START_YYYYMMDD,
										h.CELL_ITEM_ID,
										h.ITEM_ID,
										h.MEASURE,
										h.VALUE_TYPE,
										h.TO_PRODUCT,
										h.SEQ_FLAG,
										h.YYYYMMDD,
										sum(QTY) AS QTY,
										sum(QTY) AS REMAIN_QTY,
										h.PRIORITY,
										h.END_FLAG

						from 
								(select  DIVISION_ID, 
										COMPANY_ID,
										PLANT_ID,
										PLAN_START_YYYYMMDD,
										CELL_ITEM_ID,
										ITEM_ID,
										'SEMI_WH_IN' AS MEASURE,
										'PUR' AS VALUE_TYPE,
										'-' as TO_PRODUCT,
										'341' AS SEQ_FLAG,
										YYYYMMDD,
										isnull(QTY,0) AS QTY,
										isnull(QTY,0) AS REMAIN_QTY,
										2 as PRIORITY,
										'N' as END_FLAG
								from SCP_ANL_PSI_INTEGRATION_ESS a with(nolock)
								where DIVISION_ID = @V_DIVISION_ID --'82'
								AND PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD --'20240610'
								and seq_flag in ('340')
								and qty <> 0
								union all
								select  DIVISION_ID, 
										COMPANY_ID,
										PLANT_ID,
										PLAN_START_YYYYMMDD,
										CELL_ITEM_ID,
										ITEM_ID,
										'SEMI_WH_IN' AS MEASURE,
										'PUR' AS VALUE_TYPE,
										'-' as TO_PRODUCT,
										'341' AS SEQ_FLAG,
										YYYYMMDD,
										isnull(BOH_QTY,0) AS QTY,
										isnull(BOH_QTY,0) AS REMAIN_QTY,
										2  as PRIORITY,
										'N' as END_FLAG
								-- select * 
								from SCP_ANL_PSI_INTEGRATION_ESS a with(nolock)
								where DIVISION_ID = @V_DIVISION_ID --'82'
								AND PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD --'20240610'
								and seq_flag in ('370')
								AND a.YYYYMMDD = @V_PLAN_START_YYYYMMDD
								and qty <> 0
								) h
						group by	h.DIVISION_ID, 
										h.COMPANY_ID,
										h.PLANT_ID,
										h.PLAN_START_YYYYMMDD,
										h.CELL_ITEM_ID,
										h.ITEM_ID,
										h.MEASURE,
										h.VALUE_TYPE,
										h.TO_PRODUCT,
										h.SEQ_FLAG,
										h.YYYYMMDD,
										h.PRIORITY,
										h.END_FLAG


						insert into #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO
						select  h.DIVISION_ID, 
										h.COMPANY_ID,
										h.PLANT_ID,
										h.PLAN_START_YYYYMMDD,
										h.CELL_ITEM_ID,
										h.ITEM_ID,
										h.MEASURE,
										h.VALUE_TYPE,
										h.TO_PRODUCT,
										h.SEQ_FLAG,
										h.YYYYMMDD,
										sum(QTY) AS QTY,
										sum(QTY) AS REMAIN_QTY,
										h.PRIORITY,
										h.END_FLAG

						from 
								(select  DIVISION_ID, 
										COMPANY_ID,
										PLANT_ID,
										PLAN_START_YYYYMMDD,
										CELL_ITEM_ID,
										ITEM_ID,
										'PROD_PLAN' AS MEASURE,
										'PRD' AS VALUE_TYPE,
										'-' as TO_PRODUCT,
										'351' AS SEQ_FLAG,
										YYYYMMDD,
										isnull(QTY,0) AS QTY,
										isnull(QTY,0) AS REMAIN_QTY,
										1 as PRIORITY,
										'N' as END_FLAG
								from SCP_ANL_PSI_INTEGRATION_ESS a with(nolock)
								where DIVISION_ID = @V_DIVISION_ID --'82'
								AND PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD --'20240610'
								and seq_flag in ('350')
								and qty <> 0
								union all
								select  DIVISION_ID, 
										COMPANY_ID,
										PLANT_ID,
										PLAN_START_YYYYMMDD,
										CELL_ITEM_ID,
										ITEM_ID,
										'PROD_PLAN' AS MEASURE,
										'PRD' AS VALUE_TYPE,
										'-' as TO_PRODUCT,
										'351' AS SEQ_FLAG,
										YYYYMMDD,
										isnull(BOH_QTY,0) AS QTY,
										isnull(BOH_QTY,0) AS REMAIN_QTY,
										1  as PRIORITY,
										'N' as END_FLAG
								from SCP_ANL_PSI_INTEGRATION_ESS a with(nolock)
								where DIVISION_ID = @V_DIVISION_ID 
								AND PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD 
								and seq_flag in ('380')
								AND a.YYYYMMDD = @V_PLAN_START_YYYYMMDD
								and qty <> 0
								) h
						group by	h.DIVISION_ID, 
										h.COMPANY_ID,
										h.PLANT_ID,
										h.PLAN_START_YYYYMMDD,
										h.CELL_ITEM_ID,
										h.ITEM_ID,
										h.MEASURE,
										h.VALUE_TYPE,
										h.TO_PRODUCT,
										h.SEQ_FLAG,
										h.YYYYMMDD,
										h.PRIORITY,
										h.END_FLAG

--  재고 생성 END

      ----------------------------------------------
	  -- 할당 대상 정보 Cursor
	  ----------------------------------------------

			DECLARE @C_DIVISION_ID          NVARCHAR(10)
			DECLARE @C_COMPANY_ID		    NVARCHAR(10)
			DECLARE @C_PLANT_ID			    NVARCHAR(10)
			DECLARE @C_PLAN_START_YYYYMMDD  NVARCHAR(8)
			DECLARE @C_CELL_ITEM_ID         NVARCHAR(40)
			DECLARE @C_ITEM_ID              NVARCHAR(40)
			DECLARE @C_MEASURE              NVARCHAR(40)
			DECLARE @C_VALUE_TYPE			NVARCHAR(10)
			DECLARE @C_TO_PRODUCT			NVARCHAR(100)
			DECLARE @C_SEQ_FLAG				NVARCHAR(5)
			DECLARE @C_YYYYMMDD			    NVARCHAR(8)
			DECLARE @C_QTY			        NUMERIC(20, 10)
			DECLARE @C_PRIORITY				INT
			DECLARE @C_END_FLAG				NVARCHAR(1)
			DECLARE @C_IN_HOUSE_MOVING_PRD_QTY NUMERIC(20, 10)
			DECLARE @C_IN_HOUSE_MOVING_PUR_QTY NUMERIC(20, 10)


			DECLARE @C2_DIVISION_ID         NVARCHAR(10)
			DECLARE @C2_COMPANY_ID		    NVARCHAR(10)
			DECLARE @C2_PLANT_ID			 NVARCHAR(10)
			DECLARE @C2_PLAN_START_YYYYMMDD  NVARCHAR(8)
			DECLARE @C2_CELL_ITEM_ID         NVARCHAR(40)
			DECLARE @C2_ITEM_ID              NVARCHAR(40)
			DECLARE @C2_MEASURE              NVARCHAR(40)
			DECLARE @C2_VALUE_TYPE			NVARCHAR(10)
			DECLARE @C2_TO_PRODUCT			NVARCHAR(100)
			DECLARE @C2_SEQ_FLAG			NVARCHAR(5)
			DECLARE @C2_YYYYMMDD			NVARCHAR(8)
			DECLARE @C2_QTY			        NUMERIC(20, 10)
			DECLARE @C2_REMAIN_QTY	        NUMERIC(20, 10)
			DECLARE @C2_PRIORITY			INT
			DECLARE @C2_END_FLAG			NVARCHAR(1)

			DECLARE CUR_ALLOC CURSOR FOR

				  SELECT DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, SEQ_FLAG, YYYYMMDD, QTY, PRIORITY, END_FLAG, 0, 0
				  FROM  #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED WITH(NOLOCK)  
				  WHERE END_FLAG = 'N'
				  ORDER BY DIVISION_ID, PLANT_ID, ITEM_ID, YYYYMMDD, PRIORITY, TO_PRODUCT

			OPEN CUR_ALLOC;
			FETCH NEXT FROM CUR_ALLOC INTO @C_DIVISION_ID, @C_COMPANY_ID, @C_PLANT_ID, @C_PLAN_START_YYYYMMDD, @C_CELL_ITEM_ID, @C_ITEM_ID, @C_MEASURE, @C_VALUE_TYPE, @C_TO_PRODUCT, @C_SEQ_FLAG, @C_YYYYMMDD, @C_QTY, @C_PRIORITY, @C_END_FLAG, @C_IN_HOUSE_MOVING_PRD_QTY, @C_IN_HOUSE_MOVING_PUR_QTY;

		 
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
	  
			----------------------------------------
			-- 할당 처리 : START
			----------------------------------------
			DECLARE CUR_ALLOC_ITEM CURSOR FOR

				  SELECT DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, SEQ_FLAG, YYYYMMDD, QTY, REMAIN_QTY, PRIORITY, END_FLAG
				  FROM #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO WITH(NOLOCK)  -- 운영시 원복 할 것. JJG_FIFO_JEGO  WITH(NOLOCK)   -- 
				  WHERE DIVISION_ID = @C_DIVISION_ID
				  and END_FLAG = 'N'
				  AND PLANT_ID = @C_PLANT_ID
				  AND PLAN_START_YYYYMMDD = @C_PLAN_START_YYYYMMDD
				  AND ITEM_ID = @C_ITEM_ID
				  AND REMAIN_QTY > 0
				  ORDER BY DIVISION_ID, PLANT_ID, ITEM_ID, YYYYMMDD, PRIORITY, TO_PRODUCT
		  
			OPEN CUR_ALLOC_ITEM;
			FETCH NEXT FROM CUR_ALLOC_ITEM INTO @C2_DIVISION_ID, @C2_COMPANY_ID, @C2_PLANT_ID, @C2_PLAN_START_YYYYMMDD, @C2_CELL_ITEM_ID, @C2_ITEM_ID, @C2_MEASURE, @C2_VALUE_TYPE, @C2_TO_PRODUCT, @C2_SEQ_FLAG, @C2_YYYYMMDD, @C2_QTY, @C2_REMAIN_QTY, @C2_PRIORITY, @C2_END_FLAG ;
		 
			WHILE (@@FETCH_STATUS = 0)
			BEGIN


				IF @C_MEASURE = 'SHIP_PLAN'
				BEGIN

					IF @C2_VALUE_TYPE = 'PRD'
					BEGIN

						IF @C_QTY > @C2_REMAIN_QTY 
						BEGIN

							  UPDATE A SET REMAIN_QTY = 0, END_FLAG = 'Y'
							  FROM #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO A WITH(NOLOCK)  -- 운영시 원복 할 것. JJG_FIFO_JEGO A --WITH(NOLOCK)   -- 
							  WHERE DIVISION_ID = @C2_DIVISION_ID
							  AND COMPANY_ID = @C2_COMPANY_ID
							  AND PLANT_ID = @C2_PLANT_ID
							  AND PLAN_START_YYYYMMDD = @C2_PLAN_START_YYYYMMDD
							  AND CELL_ITEM_ID = @C2_CELL_ITEM_ID
							  AND ITEM_ID = @C2_ITEM_ID
							  AND MEASURE = @C2_MEASURE
							  AND VALUE_TYPE = @C2_VALUE_TYPE
							  AND TO_PRODUCT = @C2_TO_PRODUCT
							  AND SEQ_FLAG = @C2_SEQ_FLAG
							  AND YYYYMMDD = @C2_YYYYMMDD
							  AND PRIORITY = @C2_PRIORITY

							  set @C_QTY = @C_QTY - @C2_REMAIN_QTY

						END
						else if @C_QTY <= @C2_REMAIN_QTY
						BEGIN

							  set @C2_REMAIN_QTY = @C2_REMAIN_QTY - @C_QTY
							  set @C_QTY = 0

							  UPDATE A SET REMAIN_QTY = @C2_REMAIN_QTY, END_FLAG = (case when @C2_REMAIN_QTY > 0 then 'N' else 'Y' end)
							  FROM #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO A WITH(NOLOCK)  -- 운영시 원복 할 것.  JJG_FIFO_JEGO A --WITH(NOLOCK)   -- 
							  WHERE DIVISION_ID = @C2_DIVISION_ID
							  AND COMPANY_ID = @C2_COMPANY_ID
							  AND PLANT_ID = @C2_PLANT_ID
							  AND PLAN_START_YYYYMMDD = @C2_PLAN_START_YYYYMMDD
							  AND CELL_ITEM_ID = @C2_CELL_ITEM_ID
							  AND ITEM_ID = @C2_ITEM_ID
							  AND MEASURE = @C2_MEASURE
							  AND VALUE_TYPE = @C2_VALUE_TYPE
							  AND TO_PRODUCT = @C2_TO_PRODUCT
							  AND SEQ_FLAG = @C2_SEQ_FLAG
							  AND YYYYMMDD = @C2_YYYYMMDD
							  AND PRIORITY = @C2_PRIORITY

							  UPDATE A SET END_FLAG = 'Y'
							  FROM #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED A WITH(NOLOCK)  -- 운영시 원복 할 것. JJG_FIFO_NEED A --WITH(NOLOCK)   -- 
							  WHERE DIVISION_ID = @C_DIVISION_ID
							  AND COMPANY_ID = @C_COMPANY_ID
							  AND PLANT_ID = @C_PLANT_ID
							  AND PLAN_START_YYYYMMDD = @C_PLAN_START_YYYYMMDD
							  AND CELL_ITEM_ID = @C_CELL_ITEM_ID
							  AND ITEM_ID = @C_ITEM_ID
							  AND MEASURE = @C_MEASURE
							  AND VALUE_TYPE = @C_VALUE_TYPE
							  AND TO_PRODUCT = @C_TO_PRODUCT
							  AND SEQ_FLAG = @C_SEQ_FLAG
							  AND YYYYMMDD = @C_YYYYMMDD
							  AND PRIORITY = @C_PRIORITY
							  
							  break

						END	

					END

				END

--===================================== IN-HOUSE-MOVING 처리 START ========================================================--

			IF @C_MEASURE =  'IN_HOUSE_MOVING'
				BEGIN
						IF @C_QTY > @C2_REMAIN_QTY   -- 'IN_HOUSE_MOVING'
						BEGIN

							  UPDATE A SET REMAIN_QTY = 0, END_FLAG = 'Y'
							  FROM #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO A WITH(NOLOCK)  -- 운영시 원복 할 것. JJG_FIFO_JEGO A --WITH(NOLOCK)   -- 
							  WHERE DIVISION_ID = @C2_DIVISION_ID
							  AND COMPANY_ID = @C2_COMPANY_ID
							  AND PLANT_ID = @C2_PLANT_ID
							  AND PLAN_START_YYYYMMDD = @C2_PLAN_START_YYYYMMDD
							  AND CELL_ITEM_ID = @C2_CELL_ITEM_ID
							  AND ITEM_ID = @C2_ITEM_ID
							  AND MEASURE = @C2_MEASURE
							  AND VALUE_TYPE = @C2_VALUE_TYPE
							  AND TO_PRODUCT = @C2_TO_PRODUCT
							  AND SEQ_FLAG = @C2_SEQ_FLAG
							  AND YYYYMMDD = @C2_YYYYMMDD
							  AND PRIORITY = @C2_PRIORITY

							  IF @C2_VALUE_TYPE = 'PRD'
							  BEGIN
							     SET @C_IN_HOUSE_MOVING_PRD_QTY = @C_IN_HOUSE_MOVING_PRD_QTY + @C2_REMAIN_QTY
							  END
							  ELSE 
							  BEGIN
 								 SET @C_IN_HOUSE_MOVING_PUR_QTY = @C_IN_HOUSE_MOVING_PUR_QTY + @C2_REMAIN_QTY
							  END
						
							  set @C_QTY = @C_QTY - @C2_REMAIN_QTY

						END
						else if @C_QTY <= @C2_REMAIN_QTY   -- 'IN_HOUSE_MOVING'
						BEGIN
							  IF @C2_VALUE_TYPE = 'PRD'   -- 'IN_HOUSE_MOVING'
							  BEGIN
							     SET @C_IN_HOUSE_MOVING_PRD_QTY = @C_IN_HOUSE_MOVING_PRD_QTY + @C_QTY
 							  END
							  ELSE 
							  BEGIN
 								 SET @C_IN_HOUSE_MOVING_PUR_QTY = @C_IN_HOUSE_MOVING_PUR_QTY + @C_QTY
							  END

							  set @C2_REMAIN_QTY = @C2_REMAIN_QTY - @C_QTY
							  set @C_QTY = 0

							  UPDATE A SET REMAIN_QTY = @C2_REMAIN_QTY , END_FLAG = (case when @C2_REMAIN_QTY > 0 then 'N' else 'Y' end)
							  FROM #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO A WITH(NOLOCK)  
							  WHERE DIVISION_ID = @C2_DIVISION_ID
							  AND COMPANY_ID = @C2_COMPANY_ID
							  AND PLANT_ID = @C2_PLANT_ID
							  AND PLAN_START_YYYYMMDD = @C2_PLAN_START_YYYYMMDD
							  AND CELL_ITEM_ID = @C2_CELL_ITEM_ID
							  AND ITEM_ID = @C2_ITEM_ID
							  AND MEASURE = @C2_MEASURE
							  AND VALUE_TYPE = @C2_VALUE_TYPE
							  AND TO_PRODUCT = @C2_TO_PRODUCT
							  AND SEQ_FLAG = @C2_SEQ_FLAG
							  AND YYYYMMDD = @C2_YYYYMMDD
							  AND PRIORITY = @C2_PRIORITY

							  UPDATE A SET END_FLAG = 'Y'
							  FROM  #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED A WITH(NOLOCK)  
							  WHERE DIVISION_ID = @C_DIVISION_ID
							  AND COMPANY_ID = @C_COMPANY_ID
							  AND PLANT_ID = @C_PLANT_ID
							  AND PLAN_START_YYYYMMDD = @C_PLAN_START_YYYYMMDD
							  AND CELL_ITEM_ID = @C_CELL_ITEM_ID
							  AND ITEM_ID = @C_ITEM_ID
							  AND MEASURE = @C_MEASURE
							  AND VALUE_TYPE = @C_VALUE_TYPE
							  AND TO_PRODUCT = @C_TO_PRODUCT
							  AND SEQ_FLAG = @C_SEQ_FLAG
							  AND YYYYMMDD = @C_YYYYMMDD
							  AND PRIORITY = @C_PRIORITY

							  IF @C_IN_HOUSE_MOVING_PRD_QTY <> 0    -- 'IN_HOUSE_MOVING'
							  BEGIN
									 INSERT INTO SCP_ANL_PSI_INTEGRATION_ESS
										  ( DIVISION_ID,
											COMPANY_ID,
											PLANT_ID, 
											PLAN_START_YYYYMMDD,
											SEQ,
											OPERATION_GROUP, 
											FROM_SITE,
											CELL_ITEM_ID,
											ITEM_ID,
											MEASURE,
											VALUE_TYPE,
											TO_PRODUCT,
											LINE_ID,
											BOH_QTY,
											TO_SITE,
											INCOTERMS,
											SEQ_FLAG,
											YYYYMMDD,
											QTY,
											CREATED_BY,
											CREATION_DATE,
											LAST_UPDATED_BY,
											LAST_UPDATE_DATE
										 )
									 SELECT @C_DIVISION_ID AS DIVISION_ID,
											@C_COMPANY_ID AS COMPANY_ID,
											@C_PLANT_ID AS plant_id,
											@C_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD,
											1 AS SEQ, 
											'A' as operation_group, 
											'-' as FROM_SITE,  
											@C_CELL_ITEM_ID as CELL_ITEM_ID,  
											@C_ITEM_ID AS ITEM_ID,
											@C_MEASURE as MEASURE,
											'PRD' as value_type,
											@C_TO_PRODUCT as TO_PRODUCT,
											''  as LINE_ID,   
											0 as BOH_QTY,
											'-' as TO_SITE,
											'-' as incoterms,
											'332'  as SEQ_FLAG,  
											@C_YYYYMMDD as YYYYMMDD,
											@C_IN_HOUSE_MOVING_PRD_QTY as QTY,
											'SCP (ESS)BATCH' AS CREATED_BY,
											GETDATE() AS CREATION_DATE,
											'SCP (ESS)BATCH' AS LAST_UPDATED_BY,
											GETDATE() AS LAST_UPDATE_DATE
								END

								IF @C_IN_HOUSE_MOVING_PUR_QTY <> 0    
							    BEGIN

									  INSERT INTO SCP_ANL_PSI_INTEGRATION_ESS
										  ( DIVISION_ID,
											COMPANY_ID,
											PLANT_ID, 
											PLAN_START_YYYYMMDD,
											SEQ,
											OPERATION_GROUP, 
											FROM_SITE,
											CELL_ITEM_ID,
											ITEM_ID,
											MEASURE,
											VALUE_TYPE,
											TO_PRODUCT,
											LINE_ID,
											BOH_QTY,
											TO_SITE,
											INCOTERMS,
											SEQ_FLAG,
											YYYYMMDD,
											QTY,
											CREATED_BY,
											CREATION_DATE,
											LAST_UPDATED_BY,
											LAST_UPDATE_DATE
										 )
									 SELECT @C_DIVISION_ID AS DIVISION_ID,
											@C_COMPANY_ID AS COMPANY_ID,
											@C_PLANT_ID AS plant_id,
											@C_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD,
											1 AS SEQ, 
											'A' as operation_group, 
											'-' as FROM_SITE,  
											@C_CELL_ITEM_ID as CELL_ITEM_ID,  
											@C_ITEM_ID AS ITEM_ID,
											@C_MEASURE as MEASURE,
											'PUR' as value_type,
											@C_TO_PRODUCT as TO_PRODUCT,
											''  as LINE_ID,   
											0 as BOH_QTY,
											'-' as TO_SITE,
											'-' as incoterms,
											'331'  as SEQ_FLAG,  
											@C_YYYYMMDD as YYYYMMDD,
											@C_IN_HOUSE_MOVING_PUR_QTY as QTY,
											'SCP (ESS)BATCH' AS CREATED_BY,
											GETDATE() AS CREATION_DATE,
											'SCP (ESS)BATCH' AS LAST_UPDATED_BY,
											GETDATE() AS LAST_UPDATE_DATE
								END
							  break

						END	  -- else if @C_QTY <= @C2_REMAIN_QTY   ('IN_HOUSE_MOVING' 의 END )

				END   -- 'IN_HOUSE_MOVING' END

--====================================== IN-HOUSE-MOVING 처리 END  =========================================================

	 			FETCH NEXT FROM CUR_ALLOC_ITEM INTO  @C2_DIVISION_ID, @C2_COMPANY_ID, @C2_PLANT_ID, @C2_PLAN_START_YYYYMMDD, @C2_CELL_ITEM_ID, @C2_ITEM_ID, @C2_MEASURE, @C2_VALUE_TYPE, @C2_TO_PRODUCT, @C2_SEQ_FLAG, @C2_YYYYMMDD, @C2_QTY, @C2_REMAIN_QTY, @C2_PRIORITY, @C2_END_FLAG ;
			END -- OPEN CUR_ALLOC_ITEM;
		
			CLOSE CUR_ALLOC_ITEM;
			DEALLOCATE CUR_ALLOC_ITEM;
			----------------------------------------
			-- 할당 처리 : END
			----------------------------------------

			if ( @C_QTY > 0 )
			begin
				SET @C_IN_HOUSE_MOVING_PRD_QTY = @C_IN_HOUSE_MOVING_PRD_QTY + @C_QTY
			
							  IF @C_IN_HOUSE_MOVING_PRD_QTY <> 0    -- 'IN_HOUSE_MOVING'
							  BEGIN
									 INSERT INTO SCP_ANL_PSI_INTEGRATION_ESS
										  ( DIVISION_ID,
											COMPANY_ID,
											PLANT_ID, 
											PLAN_START_YYYYMMDD,
											SEQ,
											OPERATION_GROUP, 
											FROM_SITE,
											CELL_ITEM_ID,
											ITEM_ID,
											MEASURE,
											VALUE_TYPE,
											TO_PRODUCT,
											LINE_ID,
											BOH_QTY,
											TO_SITE,
											INCOTERMS,
											SEQ_FLAG,
											YYYYMMDD,
											QTY,
											CREATED_BY,
											CREATION_DATE,
											LAST_UPDATED_BY,
											LAST_UPDATE_DATE
										 )
									 SELECT @C_DIVISION_ID AS DIVISION_ID,
											@C_COMPANY_ID AS COMPANY_ID,
											@C_PLANT_ID AS plant_id,
											@C_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD,
											1 AS SEQ, 
											'A' as operation_group, 
											'-' as FROM_SITE,  
											@C_CELL_ITEM_ID as CELL_ITEM_ID,  
											@C_ITEM_ID AS ITEM_ID,
											@C_MEASURE as MEASURE,
											'PRD' as value_type,
											@C_TO_PRODUCT as TO_PRODUCT,
											''  as LINE_ID,   
											0 as BOH_QTY,
											'-' as TO_SITE,
											'-' as incoterms,
											'332'  as SEQ_FLAG,  
											@C_YYYYMMDD as YYYYMMDD,
											@C_IN_HOUSE_MOVING_PRD_QTY as QTY,
											'SCP (ESS)BATCH' AS CREATED_BY,
											GETDATE() AS CREATION_DATE,
											'SCP (ESS)BATCH' AS LAST_UPDATED_BY,
											GETDATE() AS LAST_UPDATE_DATE
								END

								IF @C_IN_HOUSE_MOVING_PUR_QTY <> 0    -- 'IN_HOUSE_MOVING'
							    BEGIN

									  INSERT INTO SCP_ANL_PSI_INTEGRATION_ESS
										  ( DIVISION_ID,
											COMPANY_ID,
											PLANT_ID, 
											PLAN_START_YYYYMMDD,
											SEQ,
											OPERATION_GROUP, 
											FROM_SITE,
											CELL_ITEM_ID,
											ITEM_ID,
											MEASURE,
											VALUE_TYPE,
											TO_PRODUCT,
											LINE_ID,
											BOH_QTY,
											TO_SITE,
											INCOTERMS,
											SEQ_FLAG,
											YYYYMMDD,
											QTY,
											CREATED_BY,
											CREATION_DATE,
											LAST_UPDATED_BY,
											LAST_UPDATE_DATE
										 )
									 SELECT @C_DIVISION_ID AS DIVISION_ID,
											@C_COMPANY_ID AS COMPANY_ID,
											@C_PLANT_ID AS plant_id,
											@C_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD,
											1 AS SEQ, --SEQ,
											'A' as operation_group, --operation_group,
											'-' as FROM_SITE,  
											@C_CELL_ITEM_ID as CELL_ITEM_ID,  
											@C_ITEM_ID AS ITEM_ID,
											@C_MEASURE as MEASURE,
											'PUR' as value_type,
											@C_TO_PRODUCT as TO_PRODUCT,
											''  as LINE_ID,   
											0 as BOH_QTY,
											'-' as TO_SITE,
											'-' as incoterms,
											'331'  as SEQ_FLAG,  
											@C_YYYYMMDD as YYYYMMDD,
											@C_IN_HOUSE_MOVING_PUR_QTY as QTY,
											'SCP (ESS)BATCH' AS CREATED_BY,
											GETDATE() AS CREATION_DATE,
											'SCP (ESS)BATCH' AS LAST_UPDATED_BY,
											GETDATE() AS LAST_UPDATE_DATE
								END

			end

	 		FETCH NEXT FROM CUR_ALLOC INTO  @C_DIVISION_ID, @C_COMPANY_ID, @C_PLANT_ID, @C_PLAN_START_YYYYMMDD, @C_CELL_ITEM_ID, @C_ITEM_ID, @C_MEASURE, @C_VALUE_TYPE, @C_TO_PRODUCT, @C_SEQ_FLAG, @C_YYYYMMDD, @C_QTY, @C_PRIORITY, @C_END_FLAG,@C_IN_HOUSE_MOVING_PRD_QTY, @C_IN_HOUSE_MOVING_PUR_QTY;
		END -- OPEN CUR_ALLOC;
		
		CLOSE CUR_ALLOC;
		DEALLOCATE CUR_ALLOC;

		drop table #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED
		drop table #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO

	END 
	END TRY

	BEGIN CATCH
	
			DECLARE @jjgv_log_message  NVARCHAR(1000);
			SET @jjgv_log_message  = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));  
			select 'ERROR JJG-Catch'
			select @jjgv_log_message
			
			return -1  

	END CATCH                 
                              ;                        
    return 1  
	
end  



