
/*
 * Program ID   : SCP0111_GET_INTEGRATION_PSI
 * Description  : Integration PSI 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/05/28   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - Integration PSI 조회
 * 2024/07/03   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - Cell 환산자, Cell Model의 Nick Name, 인코텀즈 컬럼 추가
 * 2024/07/30   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - 전극 cell model nick name 에 - 표기하여 현기준 개별아이템으로  UI 쪼개어지는거 회피하기
 * 2025/01/10   mrchois    PJ20249346 LGES SCP 개선과제 이행 - MKT FCST / Ship Plan(RTF) Measure 별 To site 정렬 기준 개선
 * 2025/02/03   mrchois    PJ20249346 LGES SCP 개선과제 이행 - PLANT_ID/TO_SITE 를 SITE_DESCRIPTION 코드로 표시
 * 2025/03/18   mrchois    PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - 조회조건에 qty<0 에 대해서만 조회 가능하도록 기능 추가
 */

 CREATE PROCEDURE [dbo].[SCP0111_GET_INTEGRATION_PSI]
   @p_division_id			NVARCHAR(MAX)
  ,@p_plan_start_yyyymmdd	NVARCHAR(8)
  ,@p_plan_type				NVARCHAR(50)=''
  ,@p_seq					NVARCHAR(50)=''
  ,@p_from_yyyymm			NVARCHAR(MAX)
  ,@p_to_yyyymm				NVARCHAR(MAX)
  ,@p_nick_name				NVARCHAR(MAX)=''
  ,@p_cellitem_id			NVARCHAR(MAX)=''
  ,@p_item_id				NVARCHAR(MAX)=''
  ,@p_qty_yn				NVARCHAR(1)='N'		--조회조건에 qty<0 에 대해서만 조회 가능하도록 기능 추가 2025-03-18

AS
BEGIN

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--GROUP 조회
	DECLARE @COLUMNS NVARCHAR(MAX)
	DECLARE @SQL     NVARCHAR(MAX)
	DECLARE @SQL_ORDERBY     NVARCHAR(MAX)	--조회조건에 qty<0 에 대해서만 조회 가능하도록 기능 추가 2025-03-18

	SET @COLUMNS = '';
	SET @SQL = '';
	SET @SQL_ORDERBY = '';

	SELECT @COLUMNS = @COLUMNS + '[' + YYYYMM + '],'
	  FROM (
			 SELECT DISTINCT
					CONVERT(NVARCHAR(6), a.YYYYMM, 112) AS YYYYMM
			   FROM SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
			   LEFT JOIN SCP_MST_FINAL_ITEM b WITH(NOLOCK) ON b.DIVISION_ID = a.DIVISION_ID AND b.ITEM_ID = a.ITEM_ID 
			  WHERE 1=1
				AND a.DIVISION_ID			= @p_division_id
				AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND a.YYYYMM BETWEEN @p_from_yyyymm AND @p_to_yyyymm 
				--AND ( ( @p_nick_name IS NULL OR  @p_nick_name = '' ) OR b.NICK_NAME IN (SELECT token FROM dbo.String_Split(@p_nick_name  ,',') ) )
				--AND ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR a.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id  ,',') ) )
		   ) AS MONTHS
	 ORDER BY YYYYMM

	IF (LEN(@COLUMNS) > 0)
	BEGIN

		SET @COLUMNS = LEFT(@COLUMNS, LEN(@COLUMNS) - 1)

		--조회조건에 qty<0 에 대해서만 조회 가능하도록 기능 추가 2025-03-18 START
		IF object_id('tempdb..#SCP_ANL_PSI_INTEGRATION_TMP') IS NOT NULL DROP TABLE #SCP_ANL_PSI_INTEGRATION_TMP;

		IF(@p_qty_yn = 'Y')
		BEGIN 
			SET @SQL = @SQL + 'SELECT * '+CHAR(10);
			SET @SQL = @SQL + 'INTO #SCP_ANL_PSI_INTEGRATION_TMP '+CHAR(10);
			SET @SQL = @SQL + 'FROM ( '+CHAR(10);
		END
		--조회조건에 qty<0 에 대해서만 조회 가능하도록 기능 추가 2025-03-18 END

		SET @SQL = @SQL + 'SELECT * '+CHAR(10);
		SET @SQL = @SQL + '  FROM ( '+CHAR(10);
		SET @SQL = @SQL + '			SELECT a.DIVISION_ID '+CHAR(10);
		SET @SQL = @SQL + '				 , a.COMPANY_ID '+CHAR(10);
		SET @SQL = @SQL + '				 , a.PLANT_ID '+CHAR(10);
		SET @SQL = @SQL + '				 , ISNULL(p.SITE_DESCRIPTION, a.PLANT_ID) AS PLANT_ID_DESCRIPTION '+CHAR(10);	--SITE_DESCRIPTION 코드 표시 2025-02-03 mrchois
		SET @SQL = @SQL + '				 , c.SEGMENT2 AS OPERATION_GROUP '+CHAR(10);
		--컬럼추가 20240703 START
		--전극 cell model nick name 에 - 표기하여 현기준 개별아이템으로  UI 쪼개어지는거 회피하기 2024-07-30
		--SET @SQL = @SQL + '				 , ISNULL(cell.NICK_NAME, '''') AS CELL_MODEL_NICK_NAME '+CHAR(10);
		SET @SQL = @SQL + '				 , ISNULL(cell.NICK_NAME, ''-'') AS CELL_MODEL_NICK_NAME '+CHAR(10);
		SET @SQL = @SQL + '				 , cf.CELL_CF '+CHAR(10);
		SET @SQL = @SQL + '				 , a.INCOTERMS '+CHAR(10);
		--컬럼추가 20240703 END
		SET @SQL = @SQL + '				 , ISNULL(b.NICK_NAME, '''') AS NICK_NAME '+CHAR(10);
		SET @SQL = @SQL + '				 , a.CELL_ITEM_ID '+CHAR(10);
		SET @SQL = @SQL + '				 , a.ITEM_ID '+CHAR(10);
		SET @SQL = @SQL + '				 , a.MEASURE '+CHAR(10);
		SET @SQL = @SQL + '				 , d.COLUMN_LABEL_NAME AS MEASURE_LABEL'+CHAR(10);
		SET @SQL = @SQL + '				 , a.VALUE_TYPE '+CHAR(10);
		SET @SQL = @SQL + '				 , a.TO_PRODUCT '+CHAR(10);
		SET @SQL = @SQL + '				 , a.LINE_ID '+CHAR(10);
		SET @SQL = @SQL + '				 , CONVERT (BIGINT, a.BOH_QTY) AS BOH_QTY '+CHAR(10);
		SET @SQL = @SQL + '				 , a.TO_SITE '+CHAR(10);
		SET @SQL = @SQL + '				 , ISNULL(s.SITE_DESCRIPTION, a.TO_SITE) AS TO_SITE_DESCRIPTION '+CHAR(10);	--SITE_DESCRIPTION 코드 표시 2025-02-03 mrchois
		SET @SQL = @SQL + '				 , (SELECT  MAX(ITEM_UOM) FROM SCM_MST_ITEM_SN WITH(NOLOCK) WHERE DIVISION_ID = a.DIVISION_ID and ITEM_ID = a.ITEM_ID) AS UOM '+CHAR(10);
		SET @SQL = @SQL + '				 , a.QTY '+CHAR(10);
		SET @SQL = @SQL + '				 , CONVERT(NVARCHAR(8), a.YYYYMM, 112) AS YYYYMM '+CHAR(10);
		--SET @SQL = @SQL + '				 , ''M_'' + a.YYYYMM AS YYYYMM '+CHAR(10);
		SET @SQL = @SQL + '				 , a.SEQ_FLAG '+CHAR(10);
		SET @SQL = @SQL + '				 , a.ATTRIBUTE2 AS PLAN_TYPE '+CHAR(10);	--Plan type UI 화면에서 정보 표시 2025-03-14 mrchois
		SET @SQL = @SQL + '			  FROM SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK) '+CHAR(10);
		SET @SQL = @SQL + '			  LEFT JOIN ( '+CHAR(10);
		SET @SQL = @SQL + '						SELECT DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME '+CHAR(10);
		SET @SQL = @SQL + '						  FROM SCM_MST_ITEM_SN WITH(NOLOCK) '+CHAR(10);
		SET @SQL = @SQL + '						 GROUP BY  DIVISION_ID, ITEM_ID ) b '+CHAR(10);
		SET @SQL = @SQL + '					ON b.DIVISION_ID = a.DIVISION_ID AND b.ITEM_ID = a.ITEM_ID '+CHAR(10); --닉네임 조인 테이블 변경
		--SET @SQL = @SQL + '			  LEFT JOIN SCP_MST_FINAL_ITEM b WITH(NOLOCK) ON b.DIVISION_ID = a.DIVISION_ID AND b.ITEM_ID = a.ITEM_ID '+CHAR(10);
		SET @SQL = @SQL + '			  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL c WITH(NOLOCK) ON LOOKUP_TYPE = ''OPERATION_GROUP'' AND c.SEGMENT1 = a.OPERATION_GROUP '+CHAR(10);
		SET @SQL = @SQL + '			  LEFT JOIN SCM_MST_SHEET_MEASURE d WITH(NOLOCK) ON d.PROGRAM_ID = ''SCP0111'' AND d.COLUMN_NAME = a.MEASURE '+CHAR(10);
		--컬럼추가 20240703 START
		SET @SQL = @SQL + '			  LEFT JOIN ( '+CHAR(10);
		SET @SQL = @SQL + '						SELECT DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME  '+CHAR(10);
		SET @SQL = @SQL + '						  FROM SCM_MST_ITEM_SN WITH(NOLOCK) '+CHAR(10);
		SET @SQL = @SQL + '						 GROUP BY  DIVISION_ID, ITEM_ID ) cell '+CHAR(10);
		SET @SQL = @SQL + '					ON cell.DIVISION_ID = a.DIVISION_ID AND cell.ITEM_ID = a.CELL_ITEM_ID  '+CHAR(10); 
		SET @SQL = @SQL + '			  LEFT JOIN SCP_MST_ITEM_CELL_CF cf WITH(NOLOCK) ON cf.ITEM_ID = a.ITEM_ID '+CHAR(10);
		--컬럼추가 20240703 END
		--SITE_DESCRIPTION 코드 표시 2025-02-03 mrchois START
		SET @SQL = @SQL + '			  LEFT JOIN SCM_MST_SITE p ON p.DIVISION_ID = a.DIVISION_ID AND p.PLANT_ID = a.PLANT_ID AND p.OSP_YN = ''Y'' AND p.VALID_YN = ''Y''  '+CHAR(10);
		SET @SQL = @SQL + '			  LEFT JOIN SCM_MST_SITE s ON s.DIVISION_ID = a.DIVISION_ID AND s.PLANT_ID = a.TO_SITE AND s.OSP_YN = ''Y'' AND s.VALID_YN = ''Y''	'+CHAR(10);
		--SITE_DESCRIPTION 코드 표시 2025-02-03 mrchois END
		SET @SQL = @SQL + '			  WHERE 1=1 '+CHAR(10);
		SET @SQL = @SQL + '			    AND a.DIVISION_ID = ''' + @p_division_id + ''''+CHAR(10);

		--자동차 사업부(81)에 대해서 MKT FCST Measure는 조회 안되도록
		IF (@p_division_id = '81')
			SET @SQL = @SQL + '			AND a.MEASURE != ''MKT_FCST'''+CHAR(10);

		SET @SQL = @SQL + '			    AND a.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + ''''+CHAR(10);
		SET @SQL = @SQL + '			    AND a.YYYYMM BETWEEN ''' + @p_from_yyyymm  + ''' AND ''' + @p_to_yyyymm + ''''+CHAR(10);
		--SET @SQL = @SQL + '			    AND a.SEQ = ''' + @p_seq + ''''+CHAR(10);
		SET @SQL = @SQL + '			    AND ( ( ''' + @p_nick_name + ''' IS NULL OR  '''+ @p_nick_name + ''' = '''' ) OR b.NICK_NAME IN (SELECT token FROM dbo.String_Split(''' + @p_nick_name + ''' ,'','')) ) '+CHAR(10);
		SET @SQL = @SQL + '			    AND ( ( ''' + @p_cellitem_id + ''' IS NULL OR  '''+ @p_cellitem_id + ''' = '''' ) OR a.CELL_ITEM_ID LIKE ''%' + @p_cellitem_id + '%'' ) '+CHAR(10);
		SET @SQL = @SQL + '			    AND ( ( ''' + @p_item_id + ''' IS NULL OR  '''+ @p_item_id + ''' = '''' ) OR a.ITEM_ID IN (SELECT token FROM dbo.String_Split(''' + @p_item_id + ''' ,'','')) ) '+CHAR(10);
		SET @SQL = @SQL + '		  ) AS result '+CHAR(10);
		SET @SQL = @SQL + '	PIVOT ( '+CHAR(10);
		SET @SQL = @SQL + '		    SUM(QTY) '+CHAR(10);
		SET @SQL = @SQL + '		    FOR YYYYMM IN (' + @COLUMNS + ') '+CHAR(10);
		SET @SQL = @SQL + '		  ) AS PIVOT_RESULT '+CHAR(10);

		--조회조건에 qty<0 에 대해서만 조회 가능하도록 기능 추가 2025-03-18 START
		IF (@p_division_id = '82')
		BEGIN
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	ORDER BY (CASE WHEN OPERATION_GROUP = ''Electrode'' THEN 99 ELSE 1 END),    '+CHAR(10);
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	(CASE WHEN ISNULL(CELL_ITEM_ID,'''') = '''' THEN 1 ELSE 0 END), CELL_ITEM_ID, (CASE WHEN OPERATION_GROUP = ''Cell'' THEN 99 ELSE 1 END),   '+CHAR(10);
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	NICK_NAME, SUBSTRING(SEQ_FLAG, 1, 1), ITEM_ID, COMPANY_ID, PLANT_ID,  '+CHAR(10);
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	(CASE WHEN MEASURE != ''INV'' THEN  SUBSTRING(SEQ_FLAG, 2, 1) ELSE ''6''  END) ,  '+CHAR(10);
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	TO_PRODUCT, VALUE_TYPE, LINE_ID '+CHAR(10);
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	, TO_SITE, INCOTERMS '+CHAR(10);	-- MKT FCST / Ship Plan(RTF) Measure 별 To site, INCOTERMS 정렬 기준 개선(2025-01-10 mrchois)

		END
		--20241004 소형 테스트 START
		ELSE IF (@p_division_id = '40')	-- 소형
		BEGIN

			SET @SQL_ORDERBY = @SQL_ORDERBY + '	ORDER BY (CASE WHEN OPERATION_GROUP = ''Electrode'' THEN 99 ELSE 1 END),    '+CHAR(10);
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	(CASE WHEN ISNULL(CELL_ITEM_ID,'''') = '''' THEN 1 ELSE 0 END), CELL_ITEM_ID, (CASE WHEN OPERATION_GROUP = ''Cell'' THEN 99 ELSE 1 END),   '+CHAR(10);
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	NICK_NAME, COMPANY_ID, PLANT_ID,   '+CHAR(10);
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	(CASE WHEN SUBSTRING(SEQ_FLAG, 1, 1) = ''1'' THEN 1   '+CHAR(10);	--Pack
			SET @SQL_ORDERBY = @SQL_ORDERBY + '		  WHEN SUBSTRING(SEQ_FLAG, 1, 1) = ''2'' THEN 2   '+CHAR(10);	--모듈
			SET @SQL_ORDERBY = @SQL_ORDERBY + '		  WHEN SUBSTRING(SEQ_FLAG, 1, 1) = ''6'' THEN 3   '+CHAR(10);	--셀 후공정 제품
			SET @SQL_ORDERBY = @SQL_ORDERBY + '		  WHEN SUBSTRING(SEQ_FLAG, 1, 1) = ''7'' THEN 4   '+CHAR(10);	--셀 후공정 반제품
			SET @SQL_ORDERBY = @SQL_ORDERBY + '		  WHEN SUBSTRING(SEQ_FLAG, 1, 1) = ''3'' THEN 5   '+CHAR(10);	--셀 제품
			SET @SQL_ORDERBY = @SQL_ORDERBY + '		  WHEN SUBSTRING(SEQ_FLAG, 1, 1) = ''4'' THEN 6   '+CHAR(10);	--셀 반제품
			SET @SQL_ORDERBY = @SQL_ORDERBY + '		  ELSE 7 END), '+CHAR(10);											--전극
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	ITEM_ID, SUBSTRING(SEQ_FLAG, 2, 1),  '+CHAR(10);
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	TO_PRODUCT, VALUE_TYPE, LINE_ID '+CHAR(10);
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	, TO_SITE, INCOTERMS '+CHAR(10);	-- MKT FCST / Ship Plan(RTF) Measure 별 To site, INCOTERMS 정렬 기준 개선(2025-01-10 mrchois)

		END
		--20241004 소형 테스트 END
		ELSE
		BEGIN
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	ORDER BY (CASE WHEN OPERATION_GROUP = ''Electrode'' THEN 99 ELSE 1 END),    '+CHAR(10);
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	(CASE WHEN ISNULL(CELL_ITEM_ID,'''') = '''' THEN 1 ELSE 0 END), CELL_ITEM_ID, (CASE WHEN OPERATION_GROUP = ''Cell'' THEN 99 ELSE 1 END),   '+CHAR(10);
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	NICK_NAME, COMPANY_ID, PLANT_ID, SUBSTRING(SEQ_FLAG, 1, 1), ITEM_ID, SUBSTRING(SEQ_FLAG, 2, 1),  '+CHAR(10);
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	TO_PRODUCT, VALUE_TYPE, LINE_ID '+CHAR(10);
			SET @SQL_ORDERBY = @SQL_ORDERBY + '	, TO_SITE, INCOTERMS '+CHAR(10);	-- MKT FCST / Ship Plan(RTF) Measure 별 To site, INCOTERMS 정렬 기준 개선(2025-01-10 mrchois)
		END

		IF(@p_qty_yn = 'Y')
		BEGIN 
			SET @SQL = @SQL + ' ) X '+CHAR(10);

			IF object_id('tempdb..#SCP_ANL_PSI_INTEGRATION_ITEM') IS NOT NULL DROP TABLE #SCP_ANL_PSI_INTEGRATION_ITEM;

			SELECT DISTINCT a.ITEM_ID, a.qty
			INTO #SCP_ANL_PSI_INTEGRATION_ITEM
			FROM SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK) 
			LEFT JOIN ( 
					SELECT DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME 
						FROM SCM_MST_ITEM_SN WITH(NOLOCK) 
						GROUP BY  DIVISION_ID, ITEM_ID ) b 
				ON b.DIVISION_ID = a.DIVISION_ID AND b.ITEM_ID = a.ITEM_ID 
			WHERE 1=1 
			AND a.DIVISION_ID = @p_division_id
			AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND a.YYYYMM BETWEEN @p_from_yyyymm AND @p_to_yyyymm
			AND ( ( @p_nick_name IS NULL OR  @p_nick_name = '' ) OR b.NICK_NAME IN (SELECT token FROM dbo.String_Split(@p_nick_name ,',')) ) 
			AND ( ( @p_cellitem_id IS NULL OR  @p_cellitem_id = '' ) OR a.CELL_ITEM_ID LIKE '%' + @p_cellitem_id + '%' ) 
			AND ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR a.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id ,',')) ) 
			AND a.QTY < 0

				--SELECT * FROM #SCP_ANL_PSI_INTEGRATION_ITEM

			SET @SQL = @SQL + 'SELECT a.* '+CHAR(10);
			SET @SQL = @SQL + 'FROM #SCP_ANL_PSI_INTEGRATION_TMP a WITH(NOLOCK) '+CHAR(10);
			SET @SQL = @SQL + 'WHERE a.ITEM_ID IN ( SELECT ITEM_ID FROM #SCP_ANL_PSI_INTEGRATION_ITEM )'+CHAR(10);

			SET @SQL = @SQL + @SQL_ORDERBY +CHAR(10);

		END
		ELSE 
		BEGIN

			SET @SQL = @SQL + @SQL_ORDERBY +CHAR(10);

		END
		--조회조건에 qty<0 에 대해서만 조회 가능하도록 기능 추가 2025-03-18 END

		--PRINT(@SQL);
		EXEC(@SQL);

	END
	ELSE
	BEGIN

		-- 조회데이터가 없을 경우
		SELECT *
		  FROM SCP_ANL_PSI_INTEGRATION WITH(NOLOCK)
		 WHERE 1=1
		   AND DIVISION_ID			= @p_division_id
		   AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		   AND YYYYMM BETWEEN @p_from_yyyymm AND @p_to_yyyymm 

	END

END
