
/*
 * Program ID   : SCP0093_GET_DIO_TREND_DATA_REASON
 * Description  : SCP0093 DIO TREND Report 팝업 화면의 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/10/06   vadabi3			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 최초생성
 * 2023/01/10   vadabi3			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 모델 = aggr_dv -> MD 모델별 + category_dv가 A또는 P인 것
 * 2023/01/11   vadabi3			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 모델 대상 @p_plan_start_yyyymmdd 일치로 제한
 * 2023/01/11   vadabi3			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - p_category_dv 추가
 * 2023/01/25   vadabi3			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - Plan Date 관랸 이슈 조치
 * 2023/02/02   vadabi3			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - Cell Convert가 체크되어 있으면 Pack/Cell 둘다 체크된것과 동일
 * 2023/02/02   vadabi3			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - Target Cell 적용
 * 2023/03/20   vadabi3			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제  - [MODEL -> CELL] 기준으로 수정
 ----------------------------------------------------------------------------------------------------
 EXEC SCP0093_GET_DIO_TREND_DATA_REASON 
 @p_plan_start_yyyymmdd = '20230313'
 , @p_yyyymm = '202303'	
 , @p_category_dv = 'C'
 , @p_division_id    = '81' 
 , @p_item_id		 = '' 	
 , @P_AGGR_DV		 = 'CG' 
 , @p_cell_group	 = '' 	
 , @p_dio_reason	 = '' 	
 , @debug_mode		 = '' 

 */
CREATE PROCEDURE [dbo].[SCP0093_GET_DIO_TREND_DATA_REASON]
  @p_plan_start_yyyymmdd    NVARCHAR(8)	
, @p_yyyymm			        NVARCHAR(6)		-- Monthly bucket 조회 기간
, @p_category_dv			NVARCHAR(MAX)	-- Category 조건  = [P, A, C]
, @p_division_id            NVARCHAR(30)	-- division
, @p_item_id				NVARCHAR(150)	-- 모델/셀그룹(닉네임.Level4) 조건  -- NULL이면 전체 
, @P_AGGR_DV				NVARCHAR(10)	-- 집계구분 [MD : 모델(Item), CG: 셀그룹(Level4)]
, @p_cell_group				NVARCHAR(30)    -- Cell GRoup 사용자 직접 입력
, @p_dio_reason				NVARCHAR(30)    -- DIO 초과 사유
, @debug_mode				NVARCHAR(1) = 'T'
AS
BEGIN
    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	-- 2023/03/20 CELL 기준으로 적용
	DECLARE @CELL_CNT INT = 0;
	SET @p_category_dv = 'C';
	SET @P_AGGR_DV = 'CG';
	

	----------------------------------------------------------------------------------------------------------
	-- #T_CELL_GROUP_INFO
	----------------------------------------------------------------------------------------------------------
    IF (OBJECT_ID('tempdb..#T_CELL_GROUP_INFO') IS NOT NULL)
    BEGIN    
        DROP TABLE #T_CELL_GROUP_INFO;
    END
    
    CREATE TABLE #T_CELL_GROUP_INFO
	(
    	[DIVISION_ID] [nvarchar](120),
    	[CELL_GROUP] [nvarchar](300),
    	[AGGR_DV] [nvarchar](20),
    	[CATEGORY_DV] CHAR(1)
    );

	SELECT @CELL_CNT = COUNT(*)
	  FROM SCP_RPT_DIO_TREND_MM WITH (NOLOCK)
	 WHERE 1 = 1
	   AND yyyymm  = @p_yyyymm 
	   AND plan_start_yyyymmdd = @p_plan_start_yyyymmdd
	   AND CATEGORY_DV	= 'C'	 
	   AND AGGR_DV		= 'CG'      
  GROUP BY DIVISION_ID
		 , CELL_GROUP
		 , AGGR_DV
		 , CATEGORY_DV


	IF @CELL_CNT > 0 
		BEGIN
			   INSERT INTO #T_CELL_GROUP_INFO
					(
					  DIVISION_ID
					, CELL_GROUP
					, AGGR_DV
					, CATEGORY_DV
					)
			   SELECT DIVISION_ID
					, CELL_GROUP
					, AGGR_DV
					, CATEGORY_DV
				 FROM SCP_RPT_DIO_TREND_MM WITH (NOLOCK)
				WHERE 1 = 1
				  AND yyyymm  = @p_yyyymm
				  AND plan_start_yyyymmdd = @p_plan_start_yyyymmdd
				  AND CATEGORY_DV	= 'C'	 
				  AND AGGR_DV		= 'CG'      
			 GROUP BY DIVISION_ID
					, CELL_GROUP
					, AGGR_DV
					, CATEGORY_DV
		END
	ELSE
		BEGIN
			   INSERT INTO #T_CELL_GROUP_INFO
					(
					  DIVISION_ID
					, CELL_GROUP
					, AGGR_DV
					, CATEGORY_DV
					)
			   SELECT DIVISION_ID
					, CELL_GROUP
					, AGGR_DV
					, CATEGORY_DV
				 FROM SCP_RPT_DIO_TREND_MM WITH (NOLOCK)
				WHERE 1 = 1
				  AND CATEGORY_DV	= 'C'	 
				  AND AGGR_DV		= 'CG'      
			 GROUP BY DIVISION_ID
					, CELL_GROUP
					, AGGR_DV
					, CATEGORY_DV
		END

	----------------------------------------------------------------------------------------------------------
	-- SEARCH
	----------------------------------------------------------------------------------------------------------
    ;WITH W_REASON_LIST AS
	(
			SELECT C.*
				 , REASON_LIST.*
			  FROM #T_CELL_GROUP_INFO C
		CROSS JOIN 
			(
				SELECT COLUMN_NAME		 AS REASON_ID
					 , COLUMN_LABEL_NAME AS REASON
					 , SORT_ORDER_NO     AS REASON_SORT
				  FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)	
				 WHERE PROGRAM_ID = 'SCP0093' 
				   AND SHEET_NAME ='POP_DIO_REASON'
			) REASON_LIST
			INNER JOIN SCM_MST_DIVISION AS D WITH(NOLOCK) ON C.DIVISION_ID = D.DIVISION_ID
	)

	,W_DATA AS
	(
			SELECT yyyymm
			     , DIVISION_ID	
				 , cell_group		
				 , AGGR_DV		
				 , CATEGORY_DV	
				 , DIO_REASON	
			     , QUANTITY
				 , AMOUNT
				 , REMARK
			  FROM SCP_RPT_DIO_TREND_MM_REASON  WITH (NOLOCK)
             WHERE yyyymm = @p_yyyymm
				AND AGGR_DV = 'CG'
				AND CATEGORY_DV = 'C'
	)
	,W_GAP AS
	(
	   select PLAN_START_YYYYMMDD
			, YYYYMM
			, DIVISION_ID
			, cell_group
			, AGGR_DV
			, CATEGORY_DV
			, MEASURE AS REASON
			, 'gap' AS REASON_NAME
			, SUM(QUANTITY) AS QUANTITY
			, SUM(AMOUNT) AS AMOUNT
			, SUM(DIO) AS DIO
			, 120 AS REASON_SORT
		 from SCP_RPT_DIO_TREND_MM  WITH (NOLOCK)
		where plan_start_yyyymmdd  = @p_plan_start_yyyymmdd 
		  and yyyymm = @p_yyyymm
		  and DIVISION_ID = @p_division_id
		  and MEASURE='GAP'
		  AND CATEGORY_DV = 'C'	 
		  AND AGGR_DV = 'CG'     
	 GROUP BY PLAN_START_YYYYMMDD
			, YYYYMM
			, DIVISION_ID
			, cell_group
			, AGGR_DV
		    , CATEGORY_DV
			, MEASURE
	)
	,W_SUM AS
	(
	   select YYYYMM
			, DIVISION_ID
			, cell_group
			, AGGR_DV
		    , CATEGORY_DV
			, SUM(QUANTITY) AS QUANTITY
			, SUM(AMOUNT) AS AMOUNT
		 from SCP_RPT_DIO_TREND_MM_REASON  WITH (NOLOCK)
		where yyyymm = @P_YYYYMM
	      and DIVISION_ID = @p_division_id
		  and DIO_REASON='SUM'
		  AND CATEGORY_DV = 'C'	 
		  AND AGGR_DV = 'CG'  
	 group by YYYYMM
			, DIVISION_ID
			, cell_group
			, AGGR_DV
			, CATEGORY_DV
	)
	 SELECT *
	 FROM
	 (
			--------------------------------------------------------------------------------------------------------------------------------
			-- W_REASON_LIST
			--------------------------------------------------------------------------------------------------------------------------------
			SELECT @P_YYYYMM as YYYYMM
			     , R.DIVISION_ID
				 , R.cell_group
				 , R.AGGR_DV
				 , R.CATEGORY_DV
				 , R.REASON_ID
				 , R.REASON
				 , R.REASON_SORT
			     , DATA.QUANTITY
				 , DATA.AMOUNT
				 , DATA.REMARK
			  FROM W_REASON_LIST R
		 LEFT JOIN W_DATA DATA   ON R.DIVISION_ID	= DATA.DIVISION_ID	
								AND R.cell_group	= DATA.cell_group		
								AND R.AGGR_DV		= DATA.AGGR_DV		
								AND R.CATEGORY_DV	= DATA.CATEGORY_DV	
								AND R.REASON_ID	    = DATA.DIO_REASON	
									         
			  WHERE 1 = 1 
				AND ( ISNULL(@p_division_id, '')		= '' OR R.DIVISION_ID	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
				AND ( ISNULL(@p_dio_reason, '')	        = '' OR R.REASON_ID	    IN (SELECT token FROM dbo.String_Split(@p_dio_reason,',')) )
				AND ( ISNULL(@p_cell_group, '')		    = '' OR R.CELL_GROUP	IN (SELECT token FROM dbo.String_Split(@p_cell_group,',')) )
				AND ( ISNULL(@P_AGGR_DV, '')			= '' OR R.AGGR_DV		IN (SELECT token FROM dbo.String_Split(@P_AGGR_DV,',')) )
				AND ( ISNULL(@p_category_dv, '')		= '' OR R.CATEGORY_DV	IN (SELECT token FROM dbo.String_Split(@p_category_dv,',')) )
				AND R.REASON_ID != 'GAP'

		--------------------------------------------------------------------------------------------------------------------------------
		-- GAP  = GAP - SUM
		--------------------------------------------------------------------------------------------------------------------------------
		UNION ALL
			SELECT     @P_YYYYMM as YYYYMM
					 , R.DIVISION_ID
					 , R.cell_group
					 , R.AGGR_DV
					 , R.CATEGORY_DV
					 , R.REASON_ID
					 , R.REASON
					 , R.REASON_SORT
					 , ISNULL(A.QUANTITY,0) - isnull(B.QUANTITY,0) AS QUANTITY
					 , ISNULL(A.AMOUNT,0) - isnull(B.AMOUNT,0) AS AMOUNT
					 , null AS REMARK
				FROM W_REASON_LIST R
		   LEFT JOIN W_GAP A WITH(NOLOCK) 
				  ON A.DIVISION_ID		= R.DIVISION_ID 
				 AND A.cell_group		= R.cell_group  
				 AND A.AGGR_DV			= R.AGGR_DV   
				 and A.REASON		    = 'GAP' 
		   LEFT JOIN W_SUM B WITH(NOLOCK) 
				  ON B.DIVISION_ID		= R.DIVISION_ID 
				 AND B.cell_group		= R.cell_group  
				 AND B.AGGR_DV			= R.AGGR_DV 
			   WHERE  1 = 1 
			   	 AND ( ISNULL(@p_division_id, '')		= '' OR R.DIVISION_ID	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
			   	 AND ( ISNULL(@p_dio_reason, '')	    = '' OR R.REASON_ID	    IN (SELECT token FROM dbo.String_Split(@p_dio_reason,',')) )
			   	 AND ( ISNULL(@p_cell_group, '')		= '' OR R.CELL_GROUP	IN (SELECT token FROM dbo.String_Split(@p_cell_group,',')) )
			   	 AND ( ISNULL(@P_AGGR_DV, '')			= '' OR R.AGGR_DV		IN (SELECT token FROM dbo.String_Split(@P_AGGR_DV,',')) )
			   	 AND ( ISNULL(@p_category_dv, '')		= '' OR R.CATEGORY_DV	IN (SELECT token FROM dbo.String_Split(@p_category_dv,',')) )
			   	 AND R.REASON_ID = 'GAP'
		) LIST	
	   where 1 = 1
	Order by DIVISION_ID
			,CELL_GROUP
			,AGGR_DV
			,CATEGORY_DV
		    ,REASON_SORT
				
END

