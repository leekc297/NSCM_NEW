


/*
 * Program ID   : SCP0093_GET_DIO_TREND_REPORT_CHART_MODEL
 * Description  : SCP0093 DIO TREND Report 화면의 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/09/26   hyerakim	    Query
 * 2022/09/26   vadabi3			최초생성
 * 2022/10/04   vadabi3			조회조건 추가 및 수정
 * 2022/10/14   vadabi3			Model / Cell Group 선택 시 차트 표시
 ----------------------------------------------------------------------------------------------------
 EXEC SCP0093_GET_DIO_TREND_REPORT_CHART_MODEL 
 @p_division_id='81'
 , @p_plan_start_yyyymmdd='20221107'
 , @p_item_id='AMAAGPL65-A1'
 , @p_from_yyyymm='202201'
 , @p_to_yyyymm='202306'
 , @P_AGGR_DV='MD'
 , @P_CATEGORY_DV='P'
 , @P_UNIT_QTY='1'
 , @P_UNIT_AMOUNT='1'
 , @p_cell_group='A5-C'
 , @p_graph_type='COUNT'
 , @p_bucket_type='MONTHLY'
 , @debug_mode='F'


  EXEC SCP0093_GET_DIO_TREND_REPORT_CHART_MODEL 
 @p_division_id='81'
 , @p_plan_start_yyyymmdd='20221107'
 , @p_item_id='합계'
 , @p_from_yyyymm='202201'
 , @p_to_yyyymm='202306'
 , @P_AGGR_DV='TT'
 , @P_CATEGORY_DV='P'
 , @P_UNIT_QTY='1'
 , @P_UNIT_AMOUNT='1'
 , @p_cell_group='A5-C'
 , @p_graph_type='합계'
 , @p_bucket_type='MONTHLY'
 , @debug_mode='F'

EXEC SCP0093_GET_DIO_TREND_REPORT_CHART_MODEL
   @p_division_id='81'
   , @p_plan_start_yyyymmdd='20221107'
   , @p_item_id='합계'
   , @p_from_yyyymm='202201'
   , @p_to_yyyymm='202306'
   , @P_AGGR_DV='TT' -- 'CG'  --> 'TT'
   , @p_category_dv='P'
   , @P_UNIT_QTY='1'
   , @P_UNIT_AMOUNT='1'
   , @p_cell_group='합계'
   , @p_graph_type='COUNT'
   , @p_bucket_type='MONTHLY'
   , @debug_mode='F'



 */
CREATE PROCEDURE [dbo].[SCP0093_GET_DIO_TREND_REPORT_CHART_MODEL]
  @p_division_id            NVARCHAR(30)	-- division
, @p_plan_start_yyyymmdd	NVARCHAR(8)		-- Plan Date
, @p_item_id				NVARCHAR(150)	-- 모델  
, @p_from_yyyymm			NVARCHAR(6)		-- Monthly bucket 조회 기간
, @p_to_yyyymm		        NVARCHAR(6)		-- Monthly bucket 조회 기간
, @P_AGGR_DV				NVARCHAR(10)	-- 집계구분 [MD : 모델(Item), CG: 셀그룹(Level4)]
, @p_category_dv			NVARCHAR(50)    -- Category 구분  = [P:Pack, A:Cell, C:Cell Convert]
, @P_UNIT_QTY				NUMERIC(20,10) = 1  -- 금액 단위 (default 1 ) / 엑셀 원본은 10만단위... (ui에서 조회시 선택....)  
, @P_UNIT_AMOUNT			NUMERIC(20,10) = 1  -- 금액 단위 (default 1 ) / 엑셀 원본은 10만단위... (ui에서 조회시 선택....)  
                                            -- p_graph_type = 수량이면 수량의 단위
											-- p_graph_type = 금액이면 금액의 단위
, @p_cell_group				NVARCHAR(30)    -- 셀그룹(닉네임.Level4) 
, @p_graph_type				NVARCHAR(30)    -- 수량 /금액 선택
, @p_bucket_type		    NVARCHAR(30)    -- MONTHLY< WEEKLY, DAILY 중 선택
, @debug_mode				NVARCHAR(1) = 'T'
AS
BEGIN
    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

/*
-----------------------------------------------------------------------------------------------------------
-- 재고 Trend Measure 정의 
-- db measure에 '_' 포함되지 않도록 한다.
-- ui measure는 = db measure + '_' + 컬럼구분값 (QTY : QUANTITY, AMT : AMOUNT, DIO : DIO) 
-----------------------------------------------------------------------------------------------------------
*/
IF ISNULL(@P_UNIT_QTY, 0) = 0 
   SET @P_UNIT_QTY = 1;

IF ISNULL(@P_UNIT_AMOUNT, 0) = 0 
   SET @P_UNIT_AMOUNT = 1;


select @p_from_yyyymm = substring(@p_from_yyyymm,1,6) 
select @p_to_yyyymm = substring(@p_to_yyyymm,1,6)  	


	--#######################################################################
	-- Chart TMP_MONTH
	--#######################################################################
		IF OBJECT_ID('tempdb..#TMP_MONTH') IS NOT NULL	
		DROP TABLE #TMP_MONTH;

			SELECT DISTINCT B.YYYYMM  
			  INTO #TMP_MONTH 
			  FROM SCM_MST_BUCKET B WITH(NOLOCK) 
			 WHERE B.YYYYMM  BETWEEN @P_FROM_YYYYMM AND  @P_TO_YYYYMM


	--#######################################################################
	-- #TMP_DATA
	--#######################################################################
	IF OBJECT_ID('tempdb..#TMP_DATA') IS NOT NULL	
		DROP TABLE #TMP_DATA;



	--#######################################################################
	-- Chart Data Create
	--#######################################################################
;with selected_measures as (
					select column_name as measure_ui 
						  ,case when  column_name = 'INV_DIO' then 1
								when  column_name = 'STANDARD_DIO' then 2
								when  column_name = 'RTF_QTY' then 3
								when  column_name = 'PROD_QTY' then 4
								when  column_name = 'INV_QTY' then 5
								else 10
						        end as   sort_order_no
						  , ROW_NUMBER() OVER (PARTITION BY column_name ORDER BY sort_order_no DESC) AS RankNo
					from scm_mst_titleset_user with(nolock) 
					where 1=1
					  and program_id = 'SCP0093'
					  and sheet_name = 'MAIN'
					  and column_name in ('INV_QTY','PROD_QTY','RTF_QTY','STANDARD_DIO', 'INV_DIO')
				)
, target_info as ( 
					--- user별 설정한 조회 대상 measure , sample_data와 조인하기 전 1차 가공 
					select sm.measure_ui
						  , substring(sm.measure_ui, 1, charindex('_', sm.measure_ui)-1)  as measure_db 
						  , substring(sm.measure_ui, charindex('_', sm.measure_ui)+1, len(sm.measure_ui) )  as col_div
						  ,sm.sort_order_no
					 from selected_measures sm
					 where RankNo = 1
				)
, measures as (
				-- UI Category Measure 등록시 주의 필요 -  상단 코멘트 참조.
				SELECT M.COLUMN_NAME																	AS MEASURE_UI
					  ,M.COLUMN_LABEL_NAME																AS MEASURE_NAME
					  ,SUBSTRING(M.COLUMN_NAME, 1, CHARINDEX('_', M.COLUMN_NAME)-1)						AS MEASURE_DB
					  ,SUBSTRING(M.COLUMN_NAME, CHARINDEX('_', M.COLUMN_NAME)+1, LEN(M.COLUMN_NAME) )	AS COL_DIV
				 FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
				WHERE 1=1
				  AND M.PROGRAM_ID = 'SCP0093'
				  AND M.SHEET_NAME = 'MAIN'
				  AND M.VALID_YN = 'Y'	 
			)
select  max(measure_ui) as measure_ui
       ,yyyymm
	   /*
		  ,case when max(col_div) = 'QTY' or max(col_div) = 'AMT' 
		        then FORMAT(ROUND(sum(value) / 1, 0), '##0')
				when max(col_div) = 'DIO' 
				then FORMAT(ROUND(sum(dio), 1), '##0.0')
			    else null   -- else case는 있을 수 없음 !!!  (있으면 안됨!!) 
			end as value
		*/
	   , CASE 
		 WHEN MAX(col_div) LIKE '%DIO' THEN  ROUND(ISNULL(MAX(value), 0),1)
		 ELSE ROUND(ISNULL(MAX(value), 0),0)     
		 END  AS value
	   , CASE 
		 WHEN  MAX(col_div) LIKE '%DIO' THEN  FORMAT(ISNULL(MAX(value), 0) , '##0.0')   
		 ELSE  FORMAT( ISNULL(MAX(value), 0) , '##0')        
		 END  AS value_format

	  INTO #TMP_DATA
from
(
	select dt.yyyymm
		  ,dt.item_id
		  ,dt.cell_group
		  ,dt.quantity
		  ,dt.dio
		  ,dt.amount
		  ,ti.measure_ui
		  ,ti.col_div
		  ,ti.sort_order_no
		  ,m.measure_name
		  ,case when ti.col_div = 'QTY' then dt.quantity / @P_UNIT_QTY
				when ti.col_div = 'DIO' then dt.dio
				when ti.col_div = 'AMT' then dt.amount  / @P_UNIT_AMOUNT
			    else null   -- else case는 있을 수 없음 !!!  (있으면 안됨!!) 
			end as value 
	from SCP_RPT_DIO_TREND_MM dt 
		 inner join target_info ti on dt.measure = ti.measure_db 
		 inner join measures m  on m.measure_ui = ti.measure_ui

		 left join scm_mst_sso_dept_info di with(nolock)    
			    on di.dept_id = dt.dept_id
		 left join scm_mst_sso_user_info ui with(nolock) 
			    on ui.user_id = dt.pic_id 
		 left join scm_mst_project pj with(nolock)
				on pj.division_id = dt.division_id
			   and pj.project_code = dt.project_code

	where 1=1
	  and dt.plan_starT_yyyymmdd = @P_PLAN_START_YYYYMMDD
	  and dt.division_id		 = @P_DIVISION_ID
	  and dt.aggr_dv			 = @P_AGGR_DV 
	  and dt.yyyymm		BETWEEN @P_FROM_YYYYMM 
	                        AND @P_TO_YYYYMM
	  and dt.category_dv         = @p_category_dv						
	  and dt.item_id			 = @P_ITEM_ID
) as data
group by yyyymm, measure_ui
order by yyyymm;



	--#######################################################################
	-- 결과 Return 
	--#######################################################################
		SELECT  'INV_DIO' AS DATA_TYPE
		        ,m.yyyymm
		        ,isnull(t.value,0) as value 
		from #TMP_MONTH m
		left outer join (select * from #TMP_DATA where measure_ui = 'INV_DIO') t on m.yyyymm = t.yyyymm
		order by m.yyyymm;

		SELECT  'STANDARD_DIO' AS DATA_TYPE
		        ,m.yyyymm
		        ,isnull(t.value,0) as value 
		from #TMP_MONTH m
		left outer join (select * from #TMP_DATA where measure_ui = 'STANDARD_DIO') t on m.yyyymm = t.yyyymm
		order by m.yyyymm;

		SELECT  'RTF_QTY' AS DATA_TYPE
		        ,m.yyyymm
		        ,isnull(t.value,0) as value 
		from #TMP_MONTH m
		left outer join (select * from #TMP_DATA where measure_ui = 'RTF_QTY') t on m.yyyymm = t.yyyymm
		order by m.yyyymm;
	
		SELECT  'PROD_QTY' AS DATA_TYPE
		        ,m.yyyymm
		        ,isnull(t.value,0) as value 
		from #TMP_MONTH m
		left outer join (select * from #TMP_DATA where measure_ui = 'PROD_QTY') t on m.yyyymm = t.yyyymm
		order by m.yyyymm;

		SELECT  'INV_QTY' AS DATA_TYPE
		        ,m.yyyymm
		        ,isnull(t.value,0) as value 
		from #TMP_MONTH m
		left outer join (select * from #TMP_DATA where measure_ui = 'INV_QTY') t on m.yyyymm = t.yyyymm
		order by m.yyyymm;

	--#######################################################################
	-- Range Return
	--#######################################################################
		SELECT SORT
		      ,GUBUN
			  ,DATA_MIN AS DATA_MIN
		      ,DATA_MAX AS DATA_MAX
			  ,SPACING AS SPACING
			  ,d_min
			  ,d_max
		FROM
		(
		  SELECT  0 AS SORT
		         ,'CHART_BASE' AS GUBUN
				 , min(CONVERT(NUMERIC,value)) AS d_min
				 , max(CONVERT(NUMERIC,value)) AS d_max
				 , abs(min(CONVERT(NUMERIC,value))) * -1 as DATA_MIN
		         , abs(max(CONVERT(NUMERIC,value))) * 2 as DATA_MAX
				 , 600 AS SPACING
			FROM #TMP_DATA 
			WHERE measure_ui IN ( N'RTF_QTY')

		  --------------------------------------------------------------------
		  Union  
		  SELECT  1 AS SORT
		         ,'CHART_DOWN' AS GUBUN
				 , min(CONVERT(NUMERIC,value)) AS d_min
				 , max(CONVERT(NUMERIC,value)) AS d_max
				 , -100 as DATA_MIN
		         , abs(max(CONVERT(NUMERIC,value))) * 2 
				 , 100 AS SPACING
			FROM #TMP_DATA 
		   WHERE measure_ui IN ( N'PROD_QTY', N'INV_QTY')
			--WHERE DATA_TYPE IN ( N'조립')
			--WHERE DATA_TYPE IN ( N'조립', N'재고')
			--WHERE DATA_TYPE IN ( N'재고')
			--------------------------------------------------------------------
			Union
		    SELECT 2 AS SORT
			     , 'CHART_UP' AS GUBUN
				 , min(CONVERT(NUMERIC,value)) AS d_min
				 , max(CONVERT(NUMERIC,value)) AS d_max
				 , max(CONVERT(NUMERIC,value)) * -1 as DATA_MIN
				 , max(CONVERT(NUMERIC,value)) as DATA_MAX
				 --, abs(min(CONVERT(NUMERIC,value))) * -2 as DATA_MIN
		         --, abs(max(CONVERT(NUMERIC,value))) + 5 as DATA_MAX
				 , 2 AS SPACING
			FROM #TMP_DATA 
			WHERE measure_ui IN ( N'INV_DIO', 'STANDARD_DIO')

	    ) AS chart2;






IF OBJECT_ID('tempdb..#TMP_DATA') IS NOT NULL	
	DROP TABLE #TMP_DATA;


END

