


/*
 * Program ID   : SCP0083_GET_DIO_OPERATION_LT
 * Description  : SCP_ANL_DIO_CYCLE_INVENTORY 조회 , 81 주기 재고
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/12/28   khj79			Initial Release - [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3)
 * 2021/02/09   khj79			BOD_ID, ROUTE_ID 추가 : 정욱기 책임
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 2022/05/30   vadabi3			항목추가(장병일) / 계산식 개선(김혜라)
 * 2022/06/10   vadabi3			VERSION 추가
 */

CREATE PROCEDURE [dbo].[SCP0083_GET_DIO_OPERATION_LT]
--chaan  @p_division_id            NVARCHAR(5),
    @p_division_id          NVARCHAR(30),--chaan
	@p_plan_start_yyyymmdd	NVARCHAR(8),
	@p_plan_type			NVARCHAR(5),
	@p_seq					NVARCHAR(2),
	@p_nick_name			NVARCHAR(50),
	@p_plant_id				NVARCHAR(30),
	@p_operation_group		NVARCHAR(10),
	@p_from_site			NVARCHAR(max),
	@p_to_site				NVARCHAR(max),
 	@p_ver					INT,
	@debug_mode				NVARCHAR(1) = 'T'

AS
BEGIN
    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	SET ANSI_WARNINGS OFF
	SET ARITHIGNORE ON
	SET ARITHABORT OFF

	IF OBJECT_ID('tempdb..#tmp_SCP0083_REPORT_DETAIL') IS NOT NULL
		DROP TABLE #tmp_SCP0083_REPORT_DETAIL;

	CREATE TABLE #tmp_SCP0083_REPORT_DETAIL(
		   DIVISION_ID						NVARCHAR(060)
		 , PLAN_START_YYYYMMDD				NVARCHAR(008)
		 , SEQ								NVARCHAR(010)
		 , NICK_NAME						NVARCHAR(060)
		 , FROM_SITE						NVARCHAR(060)
		 , TO_SITE							NVARCHAR(060)
		 , TRANSPORT_MODE_LINE				NVARCHAR(100)
		 , BOD_ID							NVARCHAR(150)
		 , INCOTERMS						NVARCHAR(100)
		 , FROM_CITY						NVARCHAR(060)
		 , TO_CITY							NVARCHAR(060)
		 , M1								NUMERIC(20,0)
		 , M2								NUMERIC(20,0)
		 , M3								NUMERIC(20,0)
		 , M4								NUMERIC(20,0)
		 , M5								NUMERIC(20,0)
		 , M6								NUMERIC(20,0)
		 , M7								NUMERIC(20,0)
		 , M8								NUMERIC(20,0)
		 , M9								NUMERIC(20,0)
		 , M10								NUMERIC(20,0)
		 , M11								NUMERIC(20,0)
		 , M12								NUMERIC(20,0)
		 , MODEL_SUM						NUMERIC(20,0)
		 , DNI_DEPART_DAYS					NUMERIC(20,1)
		 , DNI_DEPARTURE_INLAND				NUMERIC(20,1)
		 , DNI_WAITING_FOR_SHIPPING			NUMERIC(20,1)
		 , DNI_VOYAGE						NUMERIC(20,1)
		 , DNI_LAY_OFF_CUSTOMS_CLEARANCE	NUMERIC(20,1)
		 , DNI_ARRIVAL_INLAND				NUMERIC(20,1)
		 , DNI_SUM							NUMERIC(20,1)
		 , CONVERT_CELL_QTY					NUMERIC(20,3)
		 , LT_CONDITION						NVARCHAR(150)
		 , LT_INCOTERMS_CONST				INT
		 , DNI_SUM_INCOTERMS				NUMERIC(20,1)
		 , SITE_TYPE						NVARCHAR(150)
		 , PLANT_ID						    NVARCHAR(30)
	)


	INSERT INTO #tmp_SCP0083_REPORT_DETAIL	

	SELECT RD.DIVISION_ID					
		 , RD.PLAN_START_YYYYMMDD			
		 , RD.SEQ							
		 , RD.NICK_NAME	
		 , RD.FROM_SITE						
		 , RD.TO_SITE						
		 , RD.TRANSPORT_MODE_LINE			
		 , RD.BOD_ID						
		 , RD.INCOTERMS						
		 , RD.FROM_CITY						
		 , RD.TO_CITY						
		 , M1	 , M2	 , M3	 , M4	 , M5	 , M6		
		 , M7	 , M8	 , M9	 , M10	 , M11	 , M12		
		 , (	M1 + M2 + M3 + M4  + M5  + M6							
			  + M7 + M8 + M9 + M10 + M11 + M12) AS MODEL_SUM			
		 , DNI_DEPART_DAYS												
		 , DNI_DEPARTURE_INLAND											
		 , DNI_WAITING_FOR_SHIPPING										
		 , DNI_VOYAGE													
		 , DNI_LAY_OFF_CUSTOMS_CLEARANCE								
		 , DNI_ARRIVAL_INLAND											
		 , (	  DNI_DEPART_DAYS				 						
				+ DNI_DEPARTURE_INLAND		 							
				+ DNI_WAITING_FOR_SHIPPING		 						
				+ DNI_VOYAGE		 									
				+ DNI_LAY_OFF_CUSTOMS_CLEARANCE		  					
				+ DNI_ARRIVAL_INLAND									
	       ) AS DNI_SUM													
	     , CONVERT(NUMERIC(20,3), RD.ATTRIBUTE1) as CONVERT_CELL_QTY	
		 , LD.SEGMENT3 AS LT_CONDITION									
		 , (	  1										
		        + CASE WHEN  TS.SITE_TYPE <> 'SALES' OR ISNULL(LD.SEGMENT3, 'F') != 'A'								THEN  1	else 0 end 	
		        + CASE WHEN  TS.SITE_TYPE <> 'SALES' OR ISNULL(LD.SEGMENT3, 'F') NOT IN ('A', 'B')					THEN  1	else 0 end 	
		        + CASE WHEN  TS.SITE_TYPE <> 'SALES' OR ISNULL(LD.SEGMENT3, 'F') NOT IN ('A', 'B', 'C')				THEN  1	else 0 end 	
		        + CASE WHEN  TS.SITE_TYPE <> 'SALES' OR ISNULL(LD.SEGMENT3, 'F') NOT IN ('A', 'B', 'C', 'D')		THEN  1 else 0 end 	
		        + CASE WHEN  TS.SITE_TYPE <> 'SALES' OR ISNULL(LD.SEGMENT3, 'F') NOT IN ('A', 'B', 'C', 'D', 'E')	THEN  1	else 0 end 	
		   ) AS LT_INCOTERMS_CONST	-- 2022.06.03 추가										
		 , (	  DNI_DEPART_DAYS										
		        + CASE WHEN  TS.SITE_TYPE <> 'SALES' OR ISNULL(LD.SEGMENT3, 'F') != 'A'								THEN  DNI_DEPARTURE_INLAND			else 0 end 	
		        + CASE WHEN  TS.SITE_TYPE <> 'SALES' OR ISNULL(LD.SEGMENT3, 'F') NOT IN ('A', 'B')					THEN  DNI_WAITING_FOR_SHIPPING		else 0 end 	
		        + CASE WHEN  TS.SITE_TYPE <> 'SALES' OR ISNULL(LD.SEGMENT3, 'F') NOT IN ('A', 'B', 'C')				THEN  DNI_VOYAGE					else 0 end 	
		        + CASE WHEN  TS.SITE_TYPE <> 'SALES' OR ISNULL(LD.SEGMENT3, 'F') NOT IN ('A', 'B', 'C', 'D')		THEN  DNI_LAY_OFF_CUSTOMS_CLEARANCE else 0 end 	
		        + CASE WHEN  TS.SITE_TYPE <> 'SALES' OR ISNULL(LD.SEGMENT3, 'F') NOT IN ('A', 'B', 'C', 'D', 'E')	THEN  DNI_ARRIVAL_INLAND			else 0 end 	
		   ) AS DNI_SUM_INCOTERMS											
	     , TS.SITE_TYPE
		 , CASE WHEN TS.SITE_TYPE = 'SALES'
				THEN FS.PLANT_ID  -- FG : From plant
				ELSE TS.PLANT_ID  -- SEMI : To plant
		   END  AS PLANT_ID
	FROM SCP_ANL_DIO_REPORT_DETAIL RD WITH(NOLOCK)						
		 INNER JOIN SCM_MST_SITE TS WITH(NOLOCK)									
			     ON TS.DIVISION_ID	= RD.DIVISION_ID							
			    AND TS.SCM_SITE_ID	= RD.TO_SITE						
			    AND TS.SITE_TYPE = CASE WHEN @p_operation_group = 'A'  THEN 'PLANT' -- SEMI
										WHEN @p_operation_group = 'P'  THEN 'SALES' -- FG
										ELSE TS.SITE_TYPE							-- ALL 			     
								   END     
		 LEFT  JOIN SCM_MST_SITE FS WITH(NOLOCK)									
			     ON FS.DIVISION_ID	= RD.DIVISION_ID							
			    AND FS.SCM_SITE_ID	= RD.FROM_SITE						
								
		 LEFT  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LD  WITH(NOLOCK)				
			     ON LD.LOOKUP_TYPE = 'INCOTERMS'							
			    AND LD.VALID_YN = 'Y'										
			    AND LD.SEGMENT1 = CASE WHEN TS.SITE_TYPE = 'SALES' 
									   THEN RD.INCOTERMS 
									   ELSE 'DAP' -- PLANT site INCOTERMS
								   END	
	 WHERE RD.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd 	
	   AND RD.DIVISION_ID			= @p_division_id		
	   AND RD.PLAN_TYPE			    = @p_plan_type				
	   AND RD.SEQ					= @p_seq	
	   AND RD.VER					= @p_ver
	   AND RD.NICK_NAME			    = @p_nick_name	
	   /* 20220530 주석처리 
	   AND (TS.PLANT_ID = @p_plant_id 
	        OR 
			FS.PLANT_ID = @p_plant_id)  
	   AND  @p_plant_id  = CASE WHEN @p_operation_group = 'A'  THEN TS.PLANT_ID	 -- SEMI는 To site Plant
	                            WHEN @p_operation_group = 'P'  THEN FS.PLANT_ID	 -- FG는   From Stie Plant
								ELSE @p_plant_id
						   END 
						   */

	SELECT DIVISION_ID
		 , PLAN_START_YYYYMMDD
		 , SEQ
		 , NICK_NAME
		 , FROM_SITE
		 , (SELECT X1.SITE_DESCRIPTION
			  FROM SCM_MST_SITE X1 WITH(NOLOCK)
			 WHERE B.DIVISION_ID	= X1.DIVISION_ID
			   AND B.FROM_SITE		= X1.SCM_SITE_ID
		   )						AS FROM_SITE_DESCRIPTION
		 , TO_SITE
		 , (SELECT X2.SITE_DESCRIPTION
			  FROM SCM_MST_SITE X2 WITH(NOLOCK)
			 WHERE B.DIVISION_ID	= X2.DIVISION_ID
			   AND B.TO_SITE		= X2.SCM_SITE_ID
		   )						AS TO_SITE_DESCRIPTION
		 , TRANSPORT_MODE_LINE
		 , BOD_ID					-- 2022.02.09 : 추가 , 정욱기 책임
		 , (SELECT ROUTE_ID
			  FROM SCP_MST_BOD_V X3
			 WHERE B.BOD_ID	= X3.BOD_ID
			)						AS ROUTE_ID
		 , INCOTERMS
		 , LT_CONDITION
		 , LT_INCOTERMS_CONST		-- 2022.06.03 추가
		 , FROM_CITY
		 , TO_CITY
		 , M1		 , M2		 , M3		 , M4		 , M5		 , M6
		 , M7		 , M8		 , M9		 , M10		 , M11		 , M12
		 , MODEL_SUM
         , MODEL_SUM_CELL_CONV
		 , DNI_SUM										AS TOTAL_LT
		 , DNI_SUM_INCOTERMS							AS LT_INCOTERMS
		 , ISNULL(SUM(MODEL_SUM)			OVER(PARTITION BY NICK_NAME, SITE_TYPE),0)	AS NICK_SUM
		 , ISNULL(SUM(MODEL_SUM_CELL_CONV)  OVER(PARTITION BY NICK_NAME, SITE_TYPE),0)	AS NICK_SUM_CONV
		 , ISNULL(MODEL_SUM_CELL_CONV / SUM(MODEL_SUM_CELL_CONV) OVER(PARTITION BY NICK_NAME, SITE_TYPE),0) AS LINE_RATIO
		 --, ISNULL(ROUND(DNI_SUM * ( MODEL_SUM / SUM(MODEL_SUM) OVER(PARTITION BY NICK_NAME)),2),0) AS	LINE_RATIO_LT
		 , ISNULL(ROUND(DNI_SUM_INCOTERMS * ( MODEL_SUM_cell_conv / SUM(MODEL_SUM_cell_conv) OVER(PARTITION BY NICK_NAME, SITE_TYPE)),2),0) AS	LINE_RATIO_LT
		, DNI_DEPART_DAYS
		, DNI_DEPARTURE_INLAND
		, DNI_WAITING_FOR_SHIPPING
		, DNI_VOYAGE
		, DNI_LAY_OFF_CUSTOMS_CLEARANCE
		, DNI_ARRIVAL_INLAND
	  FROM (
			SELECT DIVISION_ID
				 , PLAN_START_YYYYMMDD
				 , SEQ
				 , NICK_NAME
				 , FROM_SITE
				 , TO_SITE
				 , TRANSPORT_MODE_LINE
				 , BOD_ID				-- 2022.02.09 : 추가 , 정욱기 책임
				 , INCOTERMS
				 , LT_CONDITION
				 , LT_INCOTERMS_CONST	-- 2022.06.03 추가
				 , SITE_TYPE
				 , PLANT_ID
				 , FROM_CITY
				 , TO_CITY
				 , SUM(M1)	AS M1
				 , SUM(M2)	AS M2
				 , SUM(M3)	AS M3
				 , SUM(M4)	AS M4
				 , SUM(M5)	AS M5
				 , SUM(M6)	AS M6
				 , SUM(M7)	AS M7
				 , SUM(M8)	AS M8
				 , SUM(M9)	AS M9
				 , SUM(M10)	AS M10
				 , SUM(M11)	AS M11
				 , SUM(M12)	AS M12
				 , SUM(MODEL_SUM) AS MODEL_SUM
				 , SUM(MODEL_SUM * ISNULL(CONVERT_CELL_QTY,1)) AS MODEL_SUM_CELL_CONV
				 -- 2022.03.11 : NICK_NAME 이 같고 ITEM_ID 가 다른 데이터 존재 하여 수정
				 , ISNULL(MAX(DNI_SUM),0)	AS DNI_SUM
				 , ISNULL(MAX(DNI_SUM_INCOTERMS),0)	AS DNI_SUM_INCOTERMS

				 , ISNULL(MAX(DNI_DEPART_DAYS),0)				AS DNI_DEPART_DAYS
				 , ISNULL(MAX(DNI_DEPARTURE_INLAND),0)			AS DNI_DEPARTURE_INLAND
				 , ISNULL(MAX(DNI_WAITING_FOR_SHIPPING),0)		AS DNI_WAITING_FOR_SHIPPING
				 , ISNULL(MAX(DNI_VOYAGE),0)					AS DNI_VOYAGE
				 , ISNULL(MAX(DNI_LAY_OFF_CUSTOMS_CLEARANCE),0)	AS DNI_LAY_OFF_CUSTOMS_CLEARANCE
				 , ISNULL(MAX(DNI_ARRIVAL_INLAND),0)			AS DNI_ARRIVAL_INLAND
			FROM #tmp_SCP0083_REPORT_DETAIL A
			GROUP BY DIVISION_ID
				, PLAN_START_YYYYMMDD
				, SEQ
				, NICK_NAME
				, FROM_SITE
				, TO_SITE
				, TRANSPORT_MODE_LINE
				, BOD_ID
				, INCOTERMS
				, LT_CONDITION
				, LT_INCOTERMS_CONST
				 , SITE_TYPE 
				, PLANT_ID
				, FROM_CITY
				, TO_CITY
		) B
	ORDER BY NICK_NAME
		 , FROM_SITE
		 , TO_SITE


	SELECT TOP 1
		   CONVERT(CHAR(7), DATEADD(MONTH,  1, @p_plan_start_yyyymmdd ), 23)	AS M1
		 , CONVERT(CHAR(7), DATEADD(MONTH,  2, @p_plan_start_yyyymmdd ), 23)	AS M2
		 , CONVERT(CHAR(7), DATEADD(MONTH,  3, @p_plan_start_yyyymmdd ), 23)	AS M3
		 , CONVERT(CHAR(7), DATEADD(MONTH,  4, @p_plan_start_yyyymmdd ), 23)	AS M4
		 , CONVERT(CHAR(7), DATEADD(MONTH,  5, @p_plan_start_yyyymmdd ), 23)	AS M5
		 , CONVERT(CHAR(7), DATEADD(MONTH,  6, @p_plan_start_yyyymmdd ), 23)	AS M6
		 , CONVERT(CHAR(7), DATEADD(MONTH,  7, @p_plan_start_yyyymmdd ), 23)	AS M7
		 , CONVERT(CHAR(7), DATEADD(MONTH,  8, @p_plan_start_yyyymmdd ), 23)	AS M8
		 , CONVERT(CHAR(7), DATEADD(MONTH,  9, @p_plan_start_yyyymmdd ), 23)	AS M9
		 , CONVERT(CHAR(7), DATEADD(MONTH, 10, @p_plan_start_yyyymmdd ), 23)	AS M10
		 , CONVERT(CHAR(7), DATEADD(MONTH, 11, @p_plan_start_yyyymmdd ), 23)	AS M11
		 , CONVERT(CHAR(7), DATEADD(MONTH, 12, @p_plan_start_yyyymmdd ), 23)	AS M12
		 , DATA_RANGE															AS DATA_RANGE
	  FROM SCP_ANL_DIO_REPORT_DETAIL WITH(NOLOCK)
	 WHERE PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
	   AND DIVISION_ID			= @p_division_id
	   AND PLAN_TYPE			= @p_plan_type
	   AND SEQ					= @p_seq 
	   AND VER					= @p_ver
	   AND NICK_NAME			= @p_nick_name

END

