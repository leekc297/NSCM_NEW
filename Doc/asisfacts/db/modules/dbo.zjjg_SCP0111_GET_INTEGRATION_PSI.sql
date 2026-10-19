
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
 */
 
 -- exec zjjg_SCP0111_GET_INTEGRATION_PSI '81','20240812','','','202408','202501','','',''

 CREATE PROCEDURE [dbo].[zjjg_SCP0111_GET_INTEGRATION_PSI]
   @p_division_id			NVARCHAR(MAX)
  ,@p_plan_start_yyyymmdd	NVARCHAR(8)
  ,@p_plan_type				NVARCHAR(50)=''
  ,@p_seq					NVARCHAR(50)=''
  ,@p_from_yyyymm			NVARCHAR(MAX)
  ,@p_to_yyyymm				NVARCHAR(MAX)
  ,@p_nick_name				NVARCHAR(MAX)=''
  ,@p_cellitem_id			NVARCHAR(MAX)=''
  ,@p_item_id				NVARCHAR(MAX)=''

AS
BEGIN

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--GROUP 조회
	DECLARE @COLUMNS NVARCHAR(MAX)
	DECLARE @SQL     NVARCHAR(MAX)

	SET @COLUMNS = '';
	SET @SQL = '';

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

		SET @SQL = @SQL + 'SELECT * '+CHAR(10);
		SET @SQL = @SQL + '  FROM ( '+CHAR(10);
		SET @SQL = @SQL + '			SELECT a.DIVISION_ID '+CHAR(10);
		SET @SQL = @SQL + '				 , a.COMPANY_ID '+CHAR(10);
		SET @SQL = @SQL + '				 , a.PLANT_ID '+CHAR(10);
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
		SET @SQL = @SQL + '				 , (SELECT  MAX(ITEM_UOM) FROM SCM_MST_ITEM_SN WITH(NOLOCK) WHERE DIVISION_ID = a.DIVISION_ID and ITEM_ID = a.ITEM_ID) AS UOM '+CHAR(10);
		SET @SQL = @SQL + '				 , a.QTY '+CHAR(10);
		SET @SQL = @SQL + '				 , CONVERT(NVARCHAR(8), a.YYYYMM, 112) AS YYYYMM '+CHAR(10);
		--SET @SQL = @SQL + '				 , ''M_'' + a.YYYYMM AS YYYYMM '+CHAR(10);
		SET @SQL = @SQL + '				 , a.SEQ_FLAG '+CHAR(10);
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

		IF (@p_division_id = '82')
		BEGIN
			SET @SQL = @SQL + '	ORDER BY (CASE WHEN OPERATION_GROUP = ''Electrode'' THEN 99 ELSE 1 END),    '+CHAR(10);
			SET @SQL = @SQL + '	(CASE WHEN ISNULL(CELL_ITEM_ID,'''') = '''' THEN 1 ELSE 0 END), CELL_ITEM_ID, (CASE WHEN OPERATION_GROUP = ''Cell'' THEN 99 ELSE 1 END),   '+CHAR(10);
			SET @SQL = @SQL + '	NICK_NAME, SUBSTRING(SEQ_FLAG, 1, 1), ITEM_ID, COMPANY_ID, PLANT_ID,  '+CHAR(10);
			SET @SQL = @SQL + '	(CASE WHEN MEASURE != ''INV'' THEN  SUBSTRING(SEQ_FLAG, 2, 1) ELSE ''6''  END) ,  '+CHAR(10);
			SET @SQL = @SQL + '	TO_PRODUCT, VALUE_TYPE, LINE_ID '+CHAR(10);

		END
		ELSE
		BEGIN
			SET @SQL = @SQL + '	ORDER BY (CASE WHEN OPERATION_GROUP = ''Electrode'' THEN 99 ELSE 1 END),    '+CHAR(10);
			SET @SQL = @SQL + '	(CASE WHEN ISNULL(CELL_ITEM_ID,'''') = '''' THEN 1 ELSE 0 END), CELL_ITEM_ID, (CASE WHEN OPERATION_GROUP = ''Cell'' THEN 99 ELSE 1 END),   '+CHAR(10);
			SET @SQL = @SQL + '	NICK_NAME, COMPANY_ID, PLANT_ID, SUBSTRING(SEQ_FLAG, 1, 1), ITEM_ID, SUBSTRING(SEQ_FLAG, 2, 1),  '+CHAR(10);
			SET @SQL = @SQL + '	TO_PRODUCT, VALUE_TYPE, LINE_ID '+CHAR(10);
		END

PRINT(@SQL);
return
		--EXEC(@SQL);

	END
	ELSE
	BEGIN
return
		-- 조회데이터가 없을 경우
		SELECT *
		  FROM SCP_ANL_PSI_INTEGRATION WITH(NOLOCK)
		 WHERE 1=1
		   AND DIVISION_ID			= @p_division_id
		   AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		   AND YYYYMM BETWEEN @p_from_yyyymm AND @p_to_yyyymm 

	END

END
