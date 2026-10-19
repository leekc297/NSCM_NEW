

/*
 * Program ID   : SCP0100_GET_GLOBAL_PSI_REPORT_WW
 * Description  : GLOBAL PSI 조회
 * Program History
 *===================================================================================================
 *   Date		In Charge	Description
 *===================================================================================================
 * 2023/10/12	hwyoon		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP)  최초생성
 * 2023/11/20	vadabi3		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP)  DIO 관련 정책 적용
 * 2023/11/23	vadabi3		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP)  A/S 정책
 * 2023/12/01	vadabi3		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP)  Product Level) 참조 개선 / rep_cell_item_id
 * 2023/12/18	vadabi3		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP)  Operation Group Sort
 * 2023/12/19	vadabi3		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP)  Operation 이슈 적용
 * 2023/12/19	vadabi3		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP)  DIO) Pack/Cell 이슈
 * 2025/08/01   hrkim		PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : 공정 하드코딩 변경
 ----------------------------------------------------------------------------------------------------
 EXEC SCP0100_GET_GLOBAL_PSI_REPORT_WW
                              @p_from_yyyymmdd='20230101'
							 ,@p_to_yyyymmdd='20231231'
							 ,@p_division_id='81'
							 ,@p_item_id=''
							 ,@p_nick_name=''
							 ,@p_from_site=''
							 ,@p_to_site=''
							 ,@p_plan_start_yyyymmdd='20231127'
							 ,@p_plan_type='FN'
							 ,@p_seq='1'
							 ,@p_user_id='vadabi3'
							 ,@p_bucket='WEEKLY'
							 ,@p_chk_all=''
							 ,@p_cell_group		='A7'
							 ,@p_project		=''	
							 ,@p_search_level	='PRODUCT_LEVEL1'
							 ,@p_chk_cell_qty	=''
							 ,@p_chk_as =''
							 ,@debug_mode='T'
 */



 CREATE PROCEDURE [dbo].[SCP0100_GET_GLOBAL_PSI_REPORT_WW_NEW_20260819]
	 @p_from_yyyymmdd			NVARCHAR(8),
	 @p_to_yyyymmdd				NVARCHAR(8),
     @p_division_id             NVARCHAR(30),
	 @p_item_id					NVARCHAR(MAX)='',
	 @p_nick_name				NVARCHAR(MAX)='',
	 @p_from_site				NVARCHAR(MAX)='',
	 @p_to_site					NVARCHAR(MAX)='',
	 @p_plan_start_yyyymmdd		NVARCHAR(8),
	 @p_plan_type				NVARCHAR(50),
	 @p_seq						NVARCHAR(50),
	 @p_user_id					NVARCHAR(MAX)='',
	 @p_bucket				    NVARCHAR(10),       
     @p_chk_all				    NVARCHAR(1),   
     @p_cell_group			    NVARCHAR(MAX)='',
	 @p_project			        NVARCHAR(MAX)='',
     @p_search_level			NVARCHAR(MAX)='',	 
     @p_chk_cell_qty			NVARCHAR(1), 	    
     @p_chk_as			        NVARCHAR(1), 	 
	 @debug_mode				NVARCHAR(1)='F'
 AS
 BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	
	DECLARE @p_program_id				NVARCHAR(MAX)='SCP0100'
	DECLARE @p_sheet_name				NVARCHAR(MAX)='Global PSI NEW'
	
	DECLARE @arr_item_id varchar(max) , @arr_from_site varchar(max) , @arr_to_site varchar(max);
	SELECT @arr_item_id		= ISNULL(@arr_item_id	+ ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_item_id,',')
	SELECT @arr_from_site   = ISNULL(@arr_from_site + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_from_site,',')
	SELECT @arr_to_site     = ISNULL(@arr_to_site	+ ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_to_site,',')

	DECLARE @v_cnt_usr_measure	nvarchar =0;
	SET @v_cnt_usr_measure = convert(nvarchar(50), ISNULL((
								SELECT COUNT(*)
								FROM scm_mst_titleset_user WITH (NOLOCK)
								WHERE 1=1
								 AND program_id  =  @p_program_id
								 AND sheet_name  =  @p_sheet_name
								 AND user_id     =  @p_user_id
							  ),0))
							  

	DECLARE @v_from_yyyymmdd     AS NVARCHAR(8)='';
	DECLARE @v_to_yyyymmdd       AS NVARCHAR(8)='';
	DECLARE @v_from_result       AS NVARCHAR(8)='';
	DECLARE @v_to_result         AS NVARCHAR(8)='';
	DECLARE @v_from_yyyymm     AS NVARCHAR(8)='';
	DECLARE @v_to_yyyymm       AS NVARCHAR(8)='';

	DECLARE @mQry_field					NVARCHAR(MAX) = '';
	DECLARE @mQry_field_qty				NVARCHAR(MAX) = '';
	DECLARE @MEXEC		NVARCHAR(MAX);


	SELECT @v_from_yyyymmdd = C.BASIS_START_DATE
	FROM   [dbo].[SCM_SYS_CALENDAR_M]      C WITH (NOLOCK)
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = @p_plan_start_yyyymmdd

	SELECT @v_from_result = C.BASIS_START_DATE
	FROM   [dbo].[SCM_SYS_CALENDAR_M]      C WITH (NOLOCK)
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = @p_from_yyyymmdd;

	SELECT @v_to_result = C.BASIS_START_DATE
	FROM   [dbo].[SCM_SYS_CALENDAR_M]      C WITH (NOLOCK)
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = @p_to_yyyymmdd;

	IF @v_from_yyyymmdd > @v_from_result
		BEGIN -- 실적 보여줌
		SET @v_to_yyyymmdd   = @p_to_yyyymmdd;
		SET @v_to_result     = @v_from_yyyymmdd;
		END;
	ELSE IF @v_from_yyyymmdd <= @v_from_result
		BEGIN -- 실적 없음
		SET @v_to_yyyymmdd   = @p_to_yyyymmdd;
		SET @v_from_result = CONVERT(CHAR(8), DATEADD(MM, 6, convert(datetime,@p_plan_start_yyyymmdd)), 112);
		SET @v_to_result = CONVERT(CHAR(8), DATEADD(MM, -6, convert(datetime,@p_plan_start_yyyymmdd)), 112)

		END;
	ELSE IF @v_from_yyyymmdd > @v_to_result
		BEGIN
		SET @v_from_yyyymmdd = CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@p_plan_start_yyyymmdd)), 112);
		SET @v_to_yyyymmdd = CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@p_plan_start_yyyymmdd)), 112);
		SET @v_from_result = @p_from_yyyymmdd;
		SET @v_to_result = @p_to_yyyymmdd;
		END;
	ELSE IF @v_from_yyyymmdd = @v_to_result
		BEGIN
		SET @v_to_yyyymmdd = @v_from_yyyymmdd
		SET @v_from_result = @p_from_yyyymmdd;
		SET @v_to_result = @p_to_yyyymmdd;
		END;

	select @v_from_yyyymm = SUBSTRING(@p_from_yyyymmdd,1,6);
	select @v_to_yyyymm = SUBSTRING(@p_to_yyyymmdd,1,6);

	DECLARE @v_from_ww     AS NVARCHAR(8)='';
	DECLARE @v_to_ww       AS NVARCHAR(8)='';

	SELECT @v_from_ww = MIN(YYYYPW)
	     , @v_to_ww = MAX(YYYYPW)
	FROM
	(
			SELECT concat(SUBSTRING(ISO_YYYYWW,1,4) ,SUBSTRING(PARTIAL_WEEK_NAME,2,3))  AS YYYYPW   
			FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
			WHERE  A.BASIS_YYYYMMDD >= @p_from_yyyymmdd 
			AND    A.BASIS_YYYYMMDD <= @p_to_yyyymmdd 
			GROUP BY concat(SUBSTRING(ISO_YYYYWW,1,4) ,SUBSTRING(PARTIAL_WEEK_NAME,2,3))

	) DATA





	IF @debug_mode ='T'
	BEGIN
		PRINT '----------------------------------';
		PRINT 'v_from_yyyymmdd =' +@v_from_yyyymmdd;
		PRINT 'v_to_yyyymmdd =' +@v_to_yyyymmdd;
		PRINT 'v_from_result =' +@v_from_result;
		PRINT 'v_to_result =' +@v_to_result	;
		PRINT 'v_from_yyyymm =' +@v_from_yyyymm;
		PRINT 'v_to_yyyymm =' +@v_to_yyyymm	;
		PRINT '----------------------------------';
	END;



	 --********************************************************************************
	 --#TMP_LIST
	 --********************************************************************************
		IF OBJECT_ID('tempdb..#TMP_MEASURE') IS NOT NULL
		DROP TABLE #TMP_MEASURE;
		IF OBJECT_ID('tempdb..#TMP_LEVEL') IS NOT NULL
		DROP TABLE #TMP_LEVEL;
		IF OBJECT_ID('tempdb..#TMP_LIST_FULL') IS NOT NULL
		DROP TABLE #TMP_LIST_FULL;
		
		IF OBJECT_ID('tempdb..#TMP_LIST') IS NOT NULL
		DROP TABLE #TMP_LIST;
		IF OBJECT_ID('tempdb..#TMP_LIST_QTY') IS NOT NULL
		DROP TABLE #TMP_LIST_QTY;
		IF OBJECT_ID('tempdb..#TMP_FIELD') IS NOT NULL
		DROP TABLE #TMP_FIELD;
		IF OBJECT_ID('tempdb..#TMP_LIST_FIND') IS NOT NULL
		DROP TABLE #TMP_LIST_FIND;

		IF OBJECT_ID('tempdb..#TMP_LIST1') IS NOT NULL
		DROP TABLE #TMP_LIST1;
		IF OBJECT_ID('tempdb..#TMP_LIST_QTY1') IS NOT NULL
		DROP TABLE #TMP_LIST_QTY1;
		IF OBJECT_ID('tempdb..#TMP_FIELD1') IS NOT NULL
		DROP TABLE #TMP_FIELD1;
		IF OBJECT_ID('tempdb..#TMP_LIST_FIND1') IS NOT NULL
		DROP TABLE #TMP_LIST_FIND1;
		
		IF OBJECT_ID('tempdb..#TMP_LIST2') IS NOT NULL
		DROP TABLE #TMP_LIST2;
		IF OBJECT_ID('tempdb..#TMP_LIST_QTY2') IS NOT NULL
		DROP TABLE #TMP_LIST_QTY2;
		IF OBJECT_ID('tempdb..#TMP_FIELD2') IS NOT NULL
		DROP TABLE #TMP_FIELD2;
		IF OBJECT_ID('tempdb..#TMP_LIST_FIND2') IS NOT NULL
		DROP TABLE #TMP_LIST_FIND2;
		IF OBJECT_ID('tempdb..#TMP_TRANSPORT') IS NOT NULL
		DROP TABLE #TMP_TRANSPORT;
		IF OBJECT_ID('tempdb..#TMP_MEASURE_PART1') IS NOT NULL
		DROP TABLE #TMP_MEASURE_PART1;		
		IF OBJECT_ID('tempdb..#TMP_MEASURE_PART2') IS NOT NULL
		DROP TABLE #TMP_MEASURE_PART2;	
		IF OBJECT_ID('tempdb..#TMP_MEASURE_PART3') IS NOT NULL
		DROP TABLE #TMP_MEASURE_PART3;	
		IF OBJECT_ID('tempdb..#TMP_TRANS') IS NOT NULL
		DROP TABLE #TMP_TRANS;			
		IF OBJECT_ID('tempdb..#TMP_LINE') IS NOT NULL
		DROP TABLE #TMP_LINE;
		IF OBJECT_ID('tempdb..#TMP_LIST_QTY4') IS NOT NULL
		DROP TABLE #TMP_LIST_QTY4;				
		IF OBJECT_ID('tempdb..#TMP_LIST_QTY5') IS NOT NULL
		DROP TABLE #TMP_LIST_QTY5;	

		IF OBJECT_ID('tempdb..#W_LIST') IS NOT NULL
		DROP TABLE #W_LIST;

		IF OBJECT_ID('tempdb..#TMP_LIST_LAST') IS NOT NULL
		DROP TABLE #TMP_LIST_LAST;

		IF OBJECT_ID('tempdb..#TMP_OPERATION') IS NOT NULL
		DROP TABLE #TMP_OPERATION;

	--################################################################################################################	
	-- #TMP_MEASURE
	--################################################################################################################	
	;WITH USER_MEASURES AS (
			--- user별 설정한 조회 대상 measure 
			SELECT UM.COLUMN_NAME			AS MEASURE_UI 
				  ,M.COLUMN_LABEL_NAME		AS MEASURE_NAME 
				  ,M.SMALL_CLASS_LABEL_NAME	AS MEASURE_GROUP
				  ,UM.SORT_ORDER_NO
			 FROM SCM_MST_TITLESET_USER UM WITH(NOLOCK) 
				  INNER JOIN SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
						  ON M.PROGRAM_ID = @p_program_id
						 AND M.SHEET_NAME =@p_sheet_name
						 AND M.VALID_YN = 'Y'
						 AND M.COLUMN_NAME = UM.COLUMN_NAME 
			WHERE 1=1
			  AND UM.USER_ID = @P_USER_ID
			  AND UM.PROGRAM_ID = @p_program_id
			  AND UM.SHEET_NAME = @p_sheet_name
	)
	,TARGET_MEASURES AS (
			--- user별 설정한 조회 대상 measure 
			SELECT UM.MEASURE_UI
				  ,UM.MEASURE_NAME 
				  ,UM.MEASURE_GROUP
				  ,UM.SORT_ORDER_NO
			  FROM USER_MEASURES UM WITH (NOLOCK)
			UNION ALL
			--- user별 설정한 measure정보가 없을 경우 default measure를 보여준다. 
			SELECT M.COLUMN_NAME		AS MEASURE_UI
				  ,M.COLUMN_LABEL_NAME	AS MEASURE_NAME 
				  ,M.SMALL_CLASS_LABEL_NAME	AS MEASURE_GROUP
				  ,M.SORT_ORDER_NO
			 FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
			WHERE 1=1
			  AND M.PROGRAM_ID = @p_program_id
			  AND M.SHEET_NAME = @p_sheet_name
			  AND M.VALID_YN   = 'Y'
			  AND M.DEFAULT_FLAG = 'Y'
			  AND NOT EXISTS (SELECT 1
							   FROM USER_MEASURES 
							  WHERE 1=1
							  )
	)
	SELECT *
	INTO #TMP_MEASURE
	FROM TARGET_MEASURES

	IF @p_chk_as = 'N'
	begin
	DELETE FROM #TMP_MEASURE WHERE MEASURE_GROUP = 'AS Sales PSI'
	end

	SELECT * 
	INTO #TMP_MEASURE_PART1
	FROM #TMP_MEASURE
	where MEASURE_UI NOT in ('SHIP_PLAN', 'SEMI_SHIP_PLAN','PACK_PROD','CELL_PROD')

	SELECT * 
	INTO #TMP_MEASURE_PART2
	FROM #TMP_MEASURE
	where MEASURE_UI in ('SHIP_PLAN', 'SEMI_SHIP_PLAN')

	SELECT * 
	INTO #TMP_MEASURE_PART3
	FROM #TMP_MEASURE
	where MEASURE_UI in ('PACK_PROD', 'CELL_PROD')


	--################################################################################################################	
	-- #TMP_LEVEL
	--################################################################################################################	

		SELECT    DIVISION_ID
			    , ITEM_ID
			    , FLOW_ID
				/* [PJ20257329] 2025.08.01  변경전 
			    , CASE
                    WHEN FLOW_ID = 'A9000'    THEN 'CELL'
                    WHEN FLOW_ID = 'P5500'    THEN 'MODULE'
					WHEN FLOW_ID = 'P5000'    THEN 'MODULE'
					WHEN FLOW_ID = 'P5200'    THEN 'MODULE'
                    WHEN FLOW_ID = 'P9500'    THEN 'PACK'
                    ELSE ''--P5000
                    END AS BIZ_TYPE
				*/
				-- [PJ20257329] 2025.08.01  공정 하드 코딩 변경 - Start 
				,CASE WHEN A.OPERATION_GROUP = 'A'	THEN 'CELL'
					  WHEN A.OPERATION_GROUP = 'P'	THEN IIF(A.FLOW_ID='P9500', 'PACK', 'MODULE') 
					  ELSE ''
				 END  AS BIZ_TYPE 
				-- [PJ20257329] 2025.08.01  공정 하드 코딩 변경 - END 
				,GROUP_CODE6
				,GROUP_CODE7
				,GROUP_CODE5
			    ,FINISHED_PRODUCT        AS BASIC_FINISHED_PRODUCT
		INTO #TMP_LEVEL
		FROM SCP_MST_FINAL_ITEM A WITH (NOLOCK)
		WHERE DIVISION_ID			=  @P_DIVISION_ID

	--################################################################################################################	
	-- #TMP_OPERATION
	--################################################################################################################	

		SELECT    DIVISION_ID
			    , ITEM_ID
			    , MAX(FLOW_ID) AS FLOW_ID
				/* [PJ20257329] 2025.08.01  변경전 
			    , CASE
                    WHEN MAX(FLOW_ID) = 'A9000'    THEN 'CELL'
                    WHEN MAX(FLOW_ID) = 'P5500'    THEN 'MODULE'
					WHEN MAX(FLOW_ID) = 'P5000'    THEN 'MODULE'
					WHEN MAX(FLOW_ID) = 'P5200'    THEN 'MODULE'
                    WHEN MAX(FLOW_ID) = 'P9500'    THEN 'PACK'
                    ELSE ''--P5000
                    END AS OPERATION
				*/
				-- [PJ20257329] 2025.08.01  공정 하드 코딩 변경 - Start 
				,CASE WHEN MAX(SCP_OPERATION_GROUP) = 'A'	THEN 'CELL'
					  WHEN MAX(SCP_OPERATION_GROUP) = 'P'	THEN IIF(MAX(SCP_OPERATION_GROUP)='P9500', 'PACK', 'MODULE') 
					  ELSE ''
				 END  AS OPERATION 
				-- [PJ20257329] 2025.08.01  공정 하드 코딩 변경 - End 
	    INTO #TMP_OPERATION
		FROM SCM_MST_ITEM_SN A WITH (NOLOCK)
		WHERE DIVISION_ID			=  @P_DIVISION_ID
		and ACTIVE_FLAG = 'Y'
		and scp_operation_group != 'E'
		group by  DIVISION_ID,item_id



	--################################################################################################################	
	--#TMP_LIST_FULL
	--################################################################################################################	
	         	SELECT   MM.PLAN_START_YYYYMMDD
						,MM.DIVISION_ID
						,MM.YYYYPW
						,MM.ITEM_ID
						,CASE WHEN MM.MEASURE = 'DIO' THEN 'P'
						      ELSE MM.OPERATION_GROUP
							  END AS OPERATION_GROUP
						,MM.MEASURE
						,MM.FROM_SITE
						,MM.TO_SITE
						,MM.INCOTERMS
						,MM.VARIOUS_KEY
						,MM.REP_CELL_ITEM_ID
						,MM.CELL_GROUP
						,MM.QTY
						,MM.FROM_BOH_QTY
						,MM.TO_BOH_QTY
						,MM.CELL_CF
						,MM.ATTRIBUTE3
				      ,CASE 
					   WHEN LV.GROUP_CODE6 = '' THEN '-'
					   ELSE ISNULL(LV.GROUP_CODE6,'-') 
						END AS PRODUCT_LEVEL1
				      ,CASE 
					   WHEN LV.GROUP_CODE7 = '' THEN '-'
					   ELSE ISNULL(LV.GROUP_CODE7,'-') 
						END AS PRODUCT_LEVEL2
				      ,CASE 
					   WHEN LV.GROUP_CODE5 = '' THEN '-'
					   ELSE ISNULL(LV.GROUP_CODE5,'-') 
						END AS PRODUCT_LEVEL3
					  --,ISNULL(LV.FLOW_ID,'-') AS FLOW_ID
					  --,ISNULL(LV.FLOW_ID,'-') AS OPERATION_ID
					  ,ISNULL(OP.FLOW_ID,'-') AS FLOW_ID
					  ,ISNULL(OP.FLOW_ID,'-') AS OPERATION_ID
					  ,ISNULL(OP.OPERATION,'-') AS OPERATION_NAME
					  ,CASE WHEN @p_chk_cell_qty = 'Y' AND QTY IS NOT NULL AND CELL_CF IS NOT NULL
					        THEN ISNULL(QTY,0) * ISNULL(CELL_CF,0) 
							ELSE QTY
							END AS CELL_QTY
                  INTO #TMP_LIST_FULL
				  FROM SCP_RPT_GLOBAL_PSI_MD_WW MM WITH (NOLOCK)
			  LEFT JOIN #TMP_LEVEL LV        ON MM.DIVISION_ID = LV.DIVISION_ID 
										    AND MM.attribute3  = LV.ITEM_ID
										 -- AND MM.rep_cell_item_id  	= LV.ITEM_ID

			  LEFT JOIN #TMP_OPERATION OP    ON MM.DIVISION_ID = OP.DIVISION_ID 
										    AND MM.item_id  = OP.ITEM_ID
				 WHERE MM.PLAN_START_YYYYMMDD	 = @p_plan_start_yyyymmdd
				   AND MM.DIVISION_ID			=  @p_division_id
				   AND MM.YYYYPW BETWEEN	     @v_from_ww AND @v_to_ww 
				-- AND (( @p_operation_id	IS NULL OR @p_operation_id	='') OR A.FLOW_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_operation_id	, ',')))
			    -- AND (( @p_nickname		IS NULL OR @p_nickname		='') OR A.NICK_NAME				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_nickname		, ',')))
				   AND (( @p_item_id		IS NULL OR @p_item_id		='') OR MM.ITEM_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id		, ',')))
				   AND (( @p_from_site		IS NULL OR @p_from_site		='') OR MM.FROM_SITE			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_from_site		, ',')))
				   AND (( @p_to_site		IS NULL OR @p_to_site		='') OR MM.TO_SITE				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_to_site	, ',')))
				   AND (ISNULL(@p_project   ,	'') = ''     OR MM.VARIOUS_KEY			LIKE '%' + @p_project		+ '%' )
				   AND (ISNULL(@p_cell_group   ,	'') = '' OR MM.CELL_GROUP			LIKE '%' + @p_cell_group		+ '%' )



	--################################################################################################################	
	--#TMP_FIELD
	--################################################################################################################	
		/*
	 	SELECT DATA.*
		INTO #TMP_FIELD
		FROM
		(
			  SELECT 'W_' + (A.CALENDAR_YYYY+REPLACE(A.PARTIAL_WEEK_NAME,'W',''))   AS YYYYPW_NAME
					, (A.CALENDAR_YYYY+ REPLACE(A.PARTIAL_WEEK_NAME,'W',''))        AS YYYYPW   
					, MAX( (A.CALENDAR_YYYY+A.PARTIAL_WEEK_NAME) )					AS SORT_ORDER_NO
				FROM  [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
               WHERE  A.BASIS_YYYYMMDD >= @p_from_yyyymmdd
				 AND  A.BASIS_YYYYMMDD <= @p_to_yyyymmdd
		    GROUP BY (A.CALENDAR_YYYY+REPLACE(A.PARTIAL_WEEK_NAME,'W','')) 
		) AS DATA
		*/
		;WITH W_WEEK AS
		(
	     
			SELECT   SUBSTRING(A.ISO_YYYYWW,1,4)  AS YEAR
			       , REPLACE(A.PARTIAL_WEEK_NAME,'W','') AS WEEK
				FROM  [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
               WHERE  A.BASIS_YYYYMMDD >= @p_from_yyyymmdd
				 AND  A.BASIS_YYYYMMDD <= @p_to_yyyymmdd
		)
		SELECT CONCAT('W_', YEAR, WEEK) AS YYYYPW_NAME
		      , SUBSTRING(CONCAT('W_', YEAR, WEEK),3,7) AS YYYYPW
			  , CONCAT('W_', YEAR, WEEK) AS SORT_ORDER_NO
		INTO #TMP_FIELD
		FROM W_WEEK
		GROUP BY CONCAT('W_', YEAR, WEEK)

		SELECT  @mQry_field    = @mQry_field + ',' + YYYYPW_NAME + CHAR(10)
		FROM    #TMP_FIELD AS A
		ORDER BY sort_order_no;


	--################################################################################################################	
	--#TMP_TRANSPORT
	--################################################################################################################
	select SEGMENT1 AS CODE
	      ,SEGMENT2 AS  NAME
		  ,DISPLAY_SEQ
	INTO #TMP_TRANSPORT
	from SCM_ADM_LOOKUP_MASTER_DETAIL  WITH (NOLOCK)
	where lookup_type = 'TRANSPORT_TYPE'
	and VALID_YN = 'Y'
	order by DISPLAY_SEQ


	--####################################################
	-- #TMP_TRANS
	--####################################################
		select SEGMENT1 AS CODE
			  ,SEGMENT2 AS  NAME
			  ,DISPLAY_SEQ
		INTO #TMP_TRANS
		from SCM_ADM_LOOKUP_MASTER_DETAIL  WITH (NOLOCK)
		where lookup_type = 'TRANSPORT_TYPE'
		and VALID_YN = 'Y'

	--####################################################
	-- #TMP_LINE
	--####################################################
	     SELECT YYYYPW
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,OPERATION_ID
			   ,PRODUCT_LEVEL1
			   ,PRODUCT_LEVEL2
			   ,PRODUCT_LEVEL3
			   ,ITEM_ID
			   ,TO_SITE
			   ,FROM_SITE
			   ,INCOTERMS
			   ,MEASURE
			   ,VARIOUS_KEY
		   INTO #TMP_LINE
	       FROM #TMP_LIST_FULL
	      WHERE 1 = 1 
	        AND MEASURE in ('PACK_PROD', 'CELL_PROD')
			AND VARIOUS_KEY IS NOT NULL
			AND VARIOUS_KEY != ''
	   GROUP BY YYYYPW
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,OPERATION_ID
			   ,PRODUCT_LEVEL1
			   ,PRODUCT_LEVEL2
			   ,PRODUCT_LEVEL3
			   ,ITEM_ID
			   ,TO_SITE
			   ,FROM_SITE
			   ,INCOTERMS
			   ,MEASURE
			   ,VARIOUS_KEY


--################################################################################################################	
-- 1, AUTO
--################################################################################################################	
IF @P_SEARCH_LEVEL = 'AUTO'
BEGIN
			declare @p_sheet_name2 nvarchar(max) = 'REPORT'
			declare @col_list nvarchar(max) = ''
			declare @col_list2 nvarchar(max) = ''
			declare @col_list_auto nvarchar(max) = ''
			declare @col_where nvarchar(max) = ''
			declare @col_where_count nvarchar(max) = ''
			declare @mEXEC_AUTO nvarchar(max) = ''



			IF OBJECT_ID('tempdb..#TMP_COL_LIST') IS NOT NULL
			DROP TABLE #TMP_COL_LIST;	

			IF OBJECT_ID('tempdb..#TMP_LIST_QTY_AUTO') IS NOT NULL
			DROP TABLE #TMP_LIST_QTY_AUTO;	



			------------------------------
			-- #TMP_COL_LIST
			------------------------------
			SELECT CASE WHEN b.column_name = 'MEASURE_NAME' THEN 'MEASURE'
			            ELSE b.column_name
						END AS column_name
				 , b.column_label_name
				 , U.SORT_ORDER_NO
			 INTO #TMP_COL_LIST
			 FROM scm_mst_sheet_columns b  WITH(NOLOCK)
	   INNER JOIN scm_mst_titleset_user u  WITH(NOLOCK) ON u.program_id = b.program_id 
														AND u.sheet_name = b.sheet_name 
														AND u.column_name = b.column_name 
														AND u.user_id = @p_user_id
		    WHERE   b.program_id             = @p_program_id
			  AND   b.sheet_name             = @p_sheet_name2		  
			  AND   b.valid_yn				 = 'Y'
			  AND   b.visible_flag           = 'Y'
			  AND	ISNULL(b.ATTRIBUTE6,'Y') <>'N'
			  AND   b.column_name NOT IN ('MEASURE_GROUP', 'MEASURE', 'MEASURE_NAME', 'VARIOUS_KEY', 'CELL_CF')
			ORDER BY U.SORT_ORDER_NO;

			declare @cntVarious int = 0
			SELECT @cntVarious = count(*) from #TMP_COL_LIST where column_name = 'VARIOUS_KEY'
			IF @cntVarious = 0
			BEGIN
				DELETE FROM #TMP_TRANS
			END


			------------------------------
			-- #TMP_COL_LIST 검증
			------------------------------
			SELECT @col_list = STUFF((SELECT ', ' + column_name FROM #TMP_COL_LIST ORDER BY SORT_ORDER_NO FOR XML PATH('')  ),1,1,'')
			SELECT @col_list2 = STUFF((SELECT ', ' + concat('L.',column_name) FROM #TMP_COL_LIST ORDER BY SORT_ORDER_NO FOR XML PATH('')  ),1,1,'')
			SELECT @col_list_auto = STUFF((SELECT ', ' + column_name FROM #TMP_COL_LIST WHERE column_name != 'OPERATION_GROUP' ORDER BY SORT_ORDER_NO FOR XML PATH('')  ),1,1,'')
			SELECT @col_where = STUFF((SELECT '  AND ' + concat('L.',column_name , ' = T.', column_name) FROM #TMP_COL_LIST ORDER BY SORT_ORDER_NO FOR XML PATH('')  ),1,1,'')
			SELECT @col_where_count = STUFF((SELECT '  AND ' + concat('DATA.',column_name , ' = ', column_name) FROM #TMP_COL_LIST ORDER BY SORT_ORDER_NO FOR XML PATH('')  ),1,1,'')
				


	DROP TABLE #TMP_COL_LIST
	 --********************************************************************************
	 --#@mQry_field_qty
	 --********************************************************************************
	SELECT  @mQry_field_qty    = @mQry_field_qty + ',  (SELECT TOP 1 QTY 
															FROM #TMP_LIST_QTY_AUTO 
														WHERE 1 = 1
															' + @col_where_count + '  
															AND DATA.MEASURE_UI   = MEASURE_UI
															AND YYYYPW = '''+YYYYPW+''')  as ' + YYYYPW_NAME + CHAR(10)
		FROM    #TMP_FIELD AS A
		ORDER BY sort_order_no;

		SET @mQry_field = RIGHT(@mQry_field, LEN(@mQry_field)-1);
		SET @mQry_field_qty = RIGHT(@mQry_field_qty, LEN(@mQry_field_qty)-1);

		DROP TABLE #TMP_FIELD

		 --********************************************************************************
		 --#TMP_LIST_QTY_AUTO / RESULT
		 --********************************************************************************
			SET @mEXEC = '';
			SET @mEXEC = N'
		 SELECT ' + @col_list + ' 
			   ,MAX(CELL_CF) AS CELL_CF
		   INTO #W_LIST
		   FROM #TMP_LIST_FULL L
	   GROUP BY ' + @col_list + ' 



			 SELECT YYYYPW
				   ,' + @col_list + '  
				   ,MEASURE           AS MEASURE_UI
				   ,SUM(CELL_QTY)     AS QTY
				   ,SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
				   ,SUM(TO_BOH_QTY)   AS TO_BOH_QTY
			   INTO #TMP_LIST_QTY_AUTO
			   FROM #TMP_LIST_FULL
		   GROUP BY YYYYPW
				   ,' + @col_list + '  
				   ,MEASURE


	-----------------------------------------------
   ;DROP TABLE #TMP_LIST_FULL
   ;CREATE INDEX IDX_TMP_LIST_QTY_AUTO ON #TMP_LIST_QTY_AUTO ( 
                                                    YYYYPW
												   ,' + @col_list + ' 
												   ,MEASURE_UI
												   )





		-----------------------------------------------
	   ;SELECT   DBO.FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', OPERATION_GROUP) AS OPERATION_GROUP
		        ,' + @col_list_auto + ' 
				,CASE WHEN OPERATION_GROUP = ''A'' AND MEASURE_GROUP = ''Sales PSI'' THEN ''Cell Sales PSI''
				      ELSE MEASURE_GROUP 
					  END AS MEASURE_GROUP
				,DATA.MEASURE_UI
				,DATA.MEASURE_NAME
				,CASE WHEN OPERATION_GROUP = ''A'' AND MEASURE_GROUP = ''Sales PSI'' THEN SORT_ORDER_NO + 20
				      ELSE SORT_ORDER_NO 
					  END AS SORT_ORDER_NO 
				,CODE
				,VARIOUS_KEY
				,DISPLAY_SEQ
				,CELL_CF
			 ,' + @mQry_field_qty + ' 
		INTO #TMP_LIST_LAST
		FROM
		(
				-----------------------------------------------
	 			 SELECT ' + @col_list + ' 
					   ,MG.MEASURE_GROUP AS MEASURE_GROUP 
					   ,MG.MEASURE_UI    AS MEASURE_UI
					   ,MG.MEASURE_NAME  AS MEASURE_NAME
					   ,MG.SORT_ORDER_NO AS SORT_ORDER_NO 
					   ,NULL AS CODE
					   ,''-'' AS VARIOUS_KEY
					   ,1 AS DISPLAY_SEQ
					   ,CELL_CF
				   FROM #W_LIST L
			 CROSS JOIN #TMP_MEASURE_PART1 MG

			 -----------------------------------------------
			 UNION
	 			 SELECT ' + @col_list + ' 
					   ,MG.MEASURE_GROUP AS MEASURE_GROUP 
					   ,MG.MEASURE_UI    AS MEASURE_UI
					   ,MG.MEASURE_NAME  AS MEASURE_NAME
					   ,MG.SORT_ORDER_NO AS SORT_ORDER_NO 
					   ,T.CODE
					   ,T.NAME AS VARIOUS_KEY
					   ,T.DISPLAY_SEQ 
					   ,CELL_CF
				   FROM #W_LIST L
			 CROSS JOIN #TMP_MEASURE_PART2 MG
			 CROSS JOIN #TMP_TRANS T

			 -----------------------------------------------
			 UNION
	 			 SELECT ' + @col_list2 + ' 
					   ,MG.MEASURE_GROUP AS MEASURE_GROUP 
					   ,MG.MEASURE_UI    AS MEASURE_UI
					   ,MG.MEASURE_NAME  AS MEASURE_NAME
					   ,MG.SORT_ORDER_NO AS SORT_ORDER_NO 
					   ,T.VARIOUS_KEY AS CODE
					   ,T.VARIOUS_KEY AS VARIOUS_KEY
					   ,1 AS DISPLAY_SEQ
					   ,CELL_CF
				   FROM #W_LIST L
			 CROSS JOIN #TMP_MEASURE_PART3 MG
			  LEFT JOIN #TMP_LINE T ON 1 = 1
							       ' + @col_where + ' 
								   AND MG.MEASURE_UI		= T.MEASURE


		) DATA
	  WHERE MEASURE_UI NOT IN (''DIO'')


    ;CREATE INDEX IDX_TMP_LIST_LAST ON #TMP_LIST_LAST ( 
                                                   ' + @col_list + ' 
												   ,SORT_ORDER_NO
												   ,DISPLAY_SEQ
												   ,VARIOUS_KEY
												   )


       ; SELECT * 
	       FROM #TMP_LIST_LAST
	   ORDER BY ' + @col_list + ' 
	          ,SORT_ORDER_NO
			  ,DISPLAY_SEQ


		;DROP TABLE #TMP_LIST_QTY_AUTO
		;DROP TABLE #TMP_MEASURE_PART3
		;DROP TABLE #TMP_MEASURE_PART2
		;DROP TABLE #TMP_MEASURE_PART1
	    ;DROP TABLE #TMP_LINE

			';

END


--################################################################################################################	
-- 1, DETAIL
--################################################################################################################	
ELSE IF @P_SEARCH_LEVEL = 'DETAIL'
BEGIN

     --********************************************************************************
	 --#W_LIST
	 --********************************************************************************
		 SELECT DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,OPERATION_ID
			   ,ITEM_ID
			   ,TO_SITE	
			   ,FROM_SITE
			   ,INCOTERMS
			   ,PRODUCT_LEVEL1
			   ,PRODUCT_LEVEL2
			   ,PRODUCT_LEVEL3
			   ,MAX(CELL_CF) AS CELL_CF
		   INTO #W_LIST
		   FROM #TMP_LIST_FULL L
	   GROUP BY DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,OPERATION_ID
			   ,ITEM_ID
			   ,TO_SITE	
			   ,FROM_SITE
			   ,INCOTERMS
			   ,PRODUCT_LEVEL1
			   ,PRODUCT_LEVEL2
			   ,PRODUCT_LEVEL3


     --********************************************************************************
	 --#TMP_LIST_QTY
	 --********************************************************************************
		 SELECT YYYYPW
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,OPERATION_ID
			   ,PRODUCT_LEVEL1
			   ,PRODUCT_LEVEL2
			   ,PRODUCT_LEVEL3
			   ,ITEM_ID
			   ,TO_SITE
			   ,FROM_SITE
			   ,VARIOUS_KEY
			   ,INCOTERMS
			   ,MEASURE AS MEASURE_UI
			   ,SUM(CELL_QTY)     AS QTY
			   ,SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
			   ,SUM(TO_BOH_QTY)   AS TO_BOH_QTY
			   ,MAX(CELL_CF)      AS CELL_CF 
		   INTO #TMP_LIST_QTY5
		   FROM #TMP_LIST_FULL
	   GROUP BY YYYYPW
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,OPERATION_ID
			   ,PRODUCT_LEVEL1
			   ,PRODUCT_LEVEL2
			   ,PRODUCT_LEVEL3
			   ,ITEM_ID
			   ,TO_SITE
			   ,FROM_SITE
			   ,VARIOUS_KEY
			   ,INCOTERMS
			   ,MEASURE


   CREATE INDEX IDX_TMP_LIST_QTY5 ON #TMP_LIST_QTY5 ( 
                                                    YYYYPW
												   ,DIVISION_ID
												   ,CELL_GROUP
												   ,OPERATION_GROUP
												   ,OPERATION_ID
												   ,PRODUCT_LEVEL1
												   ,PRODUCT_LEVEL2
												   ,PRODUCT_LEVEL3
												   ,ITEM_ID
												   ,TO_SITE
												   ,FROM_SITE
												   ,VARIOUS_KEY
												   ,INCOTERMS
												   ,MEASURE_UI
												   )


	 --********************************************************************************
	 --@mQry_field_qty
	 --********************************************************************************
		SELECT  @mQry_field_qty    = @mQry_field_qty + ',  (SELECT top 1 QTY 
		                                                    FROM #TMP_LIST_QTY5
															WHERE 
															    DIVISION_ID		= DATA.DIVISION_ID 
															AND CELL_GROUP		= DATA.CELL_GROUP 
															AND OPERATION_GROUP	= DATA.OPERATION_GROUP
															AND OPERATION_ID	= DATA.OPERATION_ID
															AND PRODUCT_LEVEL1	= DATA.PRODUCT_LEVEL1
															AND PRODUCT_LEVEL2	= DATA.PRODUCT_LEVEL2
															AND PRODUCT_LEVEL3	= DATA.PRODUCT_LEVEL3
															AND ITEM_ID			= DATA.ITEM_ID
															AND TO_SITE			= DATA.TO_SITE
															AND FROM_SITE		= DATA.FROM_SITE
															AND VARIOUS_KEY		= DATA.VARIOUS_KEY
															AND INCOTERMS		= DATA.INCOTERMS
															AND MEASURE_UI		= DATA.MEASURE_UI 
															AND YYYYPW = '''+YYYYPW+''')  as ' + YYYYPW_NAME + CHAR(10)
		FROM    #TMP_FIELD AS A
		ORDER BY sort_order_no;


		SET @mQry_field = RIGHT(@mQry_field, LEN(@mQry_field)-1);
		SET @mQry_field_qty = RIGHT(@mQry_field_qty, LEN(@mQry_field_qty)-1);

		
	 --********************************************************************************
	 --RESULT
	 --********************************************************************************
		SET @mEXEC       = '';
		SET @mEXEC = N'

		SELECT   DATA.DIVISION_ID
				,DATA.CELL_GROUP
				,DATA.OPERATION_GROUP
				,DATA.OPERATION_ID
				,DATA.ITEM_ID
				,DATA.TO_SITE	
				,DATA.FROM_SITE
				,DATA.INCOTERMS
				,DATA.PRODUCT_LEVEL1
				,DATA.PRODUCT_LEVEL2
				,DATA.PRODUCT_LEVEL3
				,DATA.CELL_CF
				,CASE WHEN OPERATION_GROUP = ''A'' AND MEASURE_GROUP = ''Sales PSI'' THEN ''Cell Sales PSI''
				      ELSE DATA.MEASURE_GROUP 
					  END AS MEASURE_GROUP
				,DATA.MEASURE_UI
				,DATA.MEASURE_NAME
				,CASE WHEN OPERATION_GROUP = ''A'' AND MEASURE_GROUP = ''Sales PSI'' THEN DATA.SORT_ORDER_NO + 20
				      ELSE DATA.SORT_ORDER_NO 
					  END AS SORT_ORDER_NO 
				,DATA.CODE
				,DATA.VARIOUS_KEY
				,DATA.DISPLAY_SEQ
			 ,' + @mQry_field_qty + ' 
		INTO #TMP_LIST_LAST
		FROM
		(


				-----------------------------------------------
	 			 SELECT L.DIVISION_ID
					   ,L.CELL_GROUP
					   ,L.OPERATION_GROUP
					   ,L.OPERATION_ID
					   ,L.ITEM_ID
					   ,L.TO_SITE	
					   ,L.FROM_SITE
					   ,L.INCOTERMS
					   ,L.PRODUCT_LEVEL1
					   ,L.PRODUCT_LEVEL2
					   ,L.PRODUCT_LEVEL3
					   ,L.CELL_CF
					   ,MG.MEASURE_GROUP AS MEASURE_GROUP 
					   ,MG.MEASURE_UI    AS MEASURE_UI
					   ,MG.MEASURE_NAME  AS MEASURE_NAME
					   ,MG.SORT_ORDER_NO AS SORT_ORDER_NO 
					   ,NULL AS CODE
					   ,''-'' AS VARIOUS_KEY
					   ,1 AS DISPLAY_SEQ

				   FROM #W_LIST L
			 CROSS JOIN #TMP_MEASURE_PART1 MG

			 -----------------------------------------------
			 UNION
	 			 SELECT L.DIVISION_ID
					   ,L.CELL_GROUP
					   ,L.OPERATION_GROUP
					   ,L.OPERATION_ID
					   ,L.ITEM_ID
					   ,L.TO_SITE	
					   ,L.FROM_SITE
					   ,L.INCOTERMS
					   ,L.PRODUCT_LEVEL1
					   ,L.PRODUCT_LEVEL2
					   ,L.PRODUCT_LEVEL3
					   ,L.CELL_CF
					   ,MG.MEASURE_GROUP AS MEASURE_GROUP 
					   ,MG.MEASURE_UI    AS MEASURE_UI
					   ,MG.MEASURE_NAME  AS MEASURE_NAME
					   ,MG.SORT_ORDER_NO AS SORT_ORDER_NO 
					   ,T.CODE
					   ,T.NAME AS VARIOUS_KEY
					   ,T.DISPLAY_SEQ 
				   FROM #W_LIST L
			 CROSS JOIN #TMP_MEASURE_PART2 MG
			 CROSS JOIN #TMP_TRANS T

			 -----------------------------------------------
			 UNION
	 			 SELECT L.DIVISION_ID
					   ,L.CELL_GROUP
					   ,L.OPERATION_GROUP
					   ,L.OPERATION_ID
					   ,L.ITEM_ID
					   ,L.TO_SITE	
					   ,L.FROM_SITE
					   ,L.INCOTERMS
					   ,L.PRODUCT_LEVEL1
					   ,L.PRODUCT_LEVEL2
					   ,L.PRODUCT_LEVEL3
					   ,L.CELL_CF
					   ,MG.MEASURE_GROUP AS MEASURE_GROUP 
					   ,MG.MEASURE_UI    AS MEASURE_UI
					   ,MG.MEASURE_NAME  AS MEASURE_NAME
					   ,MG.SORT_ORDER_NO AS SORT_ORDER_NO 
					   ,T.VARIOUS_KEY AS CODE
					   ,T.VARIOUS_KEY AS VARIOUS_KEY
					   ,1 AS DISPLAY_SEQ
				   FROM #W_LIST L
			 CROSS JOIN #TMP_MEASURE_PART3 MG
			  LEFT JOIN #TMP_LINE T ON L.DIVISION_ID		= T.DIVISION_ID
							       AND L.CELL_GROUP			= T.CELL_GROUP
							       AND L.OPERATION_GROUP	= T.OPERATION_GROUP
							       AND L.OPERATION_ID		= T.OPERATION_ID
							       AND L.PRODUCT_LEVEL1		= T.PRODUCT_LEVEL1
							       AND L.PRODUCT_LEVEL2		= T.PRODUCT_LEVEL2
							       AND L.PRODUCT_LEVEL3		= T.PRODUCT_LEVEL3
							       AND L.ITEM_ID			= T.ITEM_ID
							       AND L.TO_SITE			= T.TO_SITE
							       AND L.FROM_SITE			= T.FROM_SITE
							       AND L.INCOTERMS			= T.INCOTERMS
								   AND MG.MEASURE_UI		= T.MEASURE
				

		) DATA
	  WHERE MEASURE_UI NOT IN (''DIO'')

    ;CREATE INDEX IDX_TMP_LIST_LAST ON #TMP_LIST_LAST ( 
                                                     DIVISION_ID
												   ,CELL_GROUP
												   ,OPERATION_GROUP
												   ,OPERATION_ID
												   ,ITEM_ID
												   ,TO_SITE	
												   ,FROM_SITE
												   ,INCOTERMS
												   ,PRODUCT_LEVEL1
												   ,PRODUCT_LEVEL2
												   ,PRODUCT_LEVEL3
												   ,SORT_ORDER_NO
												   ,DISPLAY_SEQ
												   ,VARIOUS_KEY
												   )


       ; SELECT * 
	       FROM #TMP_LIST_LAST
	   ORDER BY DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP DESC
			   ,OPERATION_ID
			   ,ITEM_ID
			   ,TO_SITE	
			   ,FROM_SITE
			   ,INCOTERMS
			   ,PRODUCT_LEVEL1
			   ,PRODUCT_LEVEL2
			   ,PRODUCT_LEVEL3
			   ,SORT_ORDER_NO
			   ,DISPLAY_SEQ
			   ,VARIOUS_KEY


		;DROP INDEX IDX_TMP_LIST_QTY5 ON #TMP_LIST_QTY5
		;DROP TABLE #TMP_LIST_QTY5
		;DROP TABLE #TMP_MEASURE_PART3
		;DROP TABLE #TMP_MEASURE_PART2
		;DROP TABLE #TMP_MEASURE_PART1
	    ;DROP TABLE #TMP_LINE
		;DROP TABLE #TMP_LIST_FULL
		';

		-- ;select * from #TMP_LINE
END


--################################################################################################################	
-- 1, CELL_GROUP
--################################################################################################################	
ELSE IF @P_SEARCH_LEVEL = 'CELL_GROUP'
BEGIN


	 --********************************************************************************
	 --#TMP_LIST_QTY
	 --********************************************************************************
		 SELECT YYYYPW
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,MEASURE AS MEASURE_UI
			   ,SUM(CELL_QTY)          AS QTY
			   ,SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
			   ,SUM(TO_BOH_QTY)   AS TO_BOH_QTY
			   ,MAX(CELL_CF )     AS CELL_CF 
		   INTO #TMP_LIST_QTY1
		   FROM #TMP_LIST_FULL
	   GROUP BY YYYYPW
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,MEASURE


   CREATE INDEX IDX_TMP_LIST_QTY1 ON #TMP_LIST_QTY1 ( 
                                                    YYYYPW
												   ,DIVISION_ID
												   ,CELL_GROUP
												   ,MEASURE_UI
												   )


	 --********************************************************************************
	 --#@mQry_field_qty
	 --********************************************************************************
		SELECT  @mQry_field_qty    = @mQry_field_qty + ',  (SELECT QTY 
		                                                    FROM #TMP_LIST_QTY1 
															WHERE L.DIVISION_ID = DIVISION_ID 
															AND L.CELL_GROUP = CELL_GROUP 
															AND MG.MEASURE_UI = MEASURE_UI 
															AND YYYYPW = '''+YYYYPW+''')  as ' + YYYYPW_NAME + CHAR(10)
		FROM    #TMP_FIELD AS A
		ORDER BY sort_order_no;


		SET @mQry_field = RIGHT(@mQry_field, LEN(@mQry_field)-1);
		SET @mQry_field_qty = RIGHT(@mQry_field_qty, LEN(@mQry_field_qty)-1);
		
	 --********************************************************************************
	 --RESULT
	 --********************************************************************************
		SET @mEXEC       = '';
		SET @mEXEC = N'

		;WITH W_LIST AS 
		(
		 SELECT DIVISION_ID
			   ,CELL_GROUP
		FROM #TMP_LIST_FULL L
		GROUP BY DIVISION_ID
			    ,CELL_GROUP
		)

	 	 SELECT DIVISION_ID
			   ,CELL_GROUP
			   ,MG.MEASURE_GROUP AS MEASURE_GROUP 
			   ,MG.MEASURE_UI    AS MEASURE_UI
			   ,MG.MEASURE_NAME  AS MEASURE_NAME
			   ,MG.SORT_ORDER_NO AS SORT_ORDER_NO 
			   ,''-'' AS OPERATION_GROUP
			   ,''-'' AS OPERATION_ID
			   ,''-'' AS ITEM_ID
			   ,''-'' AS TO_SITE	
			   ,''-'' AS FROM_SITE
			   ,''-'' AS INCOTERMS
			   ,''-'' AS VARIOUS_KEY
			   ,''-'' AS PRODUCT_LEVEL1
			   ,''-'' AS PRODUCT_LEVEL2
			   ,''-'' AS PRODUCT_LEVEL3
			   ,1 AS CELL_CF
			   ,' + @mQry_field_qty + '  
		   FROM W_LIST L
	 CROSS JOIN #TMP_MEASURE MG
	   ORDER BY L.DIVISION_ID
			   ,L.CELL_GROUP
			   ,MG.SORT_ORDER_NO
		';

END

--################################################################################################################	
-- 2, PRODUCT_LEVEL1
--################################################################################################################	
ELSE IF @P_SEARCH_LEVEL = 'PRODUCT_LEVEL1'
BEGIN

	 --********************************************************************************
	 --#TMP_LIST_QTY
	 --********************************************************************************
		 SELECT YYYYPW
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL1
			   ,MEASURE AS MEASURE_UI
			   ,SUM(CELL_QTY)          AS QTY
			   ,SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
			   ,SUM(TO_BOH_QTY)   AS TO_BOH_QTY
			   ,MAX(CELL_CF )     AS CELL_CF 
		   INTO #TMP_LIST_QTY2
		   FROM #TMP_LIST_FULL
	   GROUP BY YYYYPW
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL1
			   ,MEASURE


   CREATE INDEX IDX_TMP_LIST_QTY2 ON #TMP_LIST_QTY2 ( 
                                                    YYYYPW
												   ,DIVISION_ID
												   ,CELL_GROUP
												   ,OPERATION_GROUP
			                                       ,PRODUCT_LEVEL1
												   ,MEASURE_UI
												   )

	 --********************************************************************************
	 --#TMP_FIELD
	 --********************************************************************************
		SELECT  @mQry_field_qty    = @mQry_field_qty + ',  (SELECT QTY 
		                                                    FROM #TMP_LIST_QTY2
															WHERE L.DIVISION_ID		= DIVISION_ID 
															AND L.CELL_GROUP		= CELL_GROUP 
															AND L.OPERATION_GROUP	= OPERATION_GROUP 
															AND L.PRODUCT_LEVEL1	= PRODUCT_LEVEL1 
															AND MG.MEASURE_UI		= MEASURE_UI 
															AND YYYYPW = '''+YYYYPW+''')  as ' + YYYYPW_NAME + CHAR(10)
		FROM    #TMP_FIELD AS A
		ORDER BY sort_order_no;


		SET @mQry_field = RIGHT(@mQry_field, LEN(@mQry_field)-1);
		SET @mQry_field_qty = RIGHT(@mQry_field_qty, LEN(@mQry_field_qty)-1);
		
	 --********************************************************************************
	 --RESULT
	 --********************************************************************************
		SET @mEXEC       = '';
		SET @mEXEC = N'

		;WITH W_LIST AS 
		(
		 SELECT DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL1
		FROM #TMP_LIST_FULL L
		GROUP BY DIVISION_ID
			    ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL1
		)

	 	 SELECT L.DIVISION_ID
			   ,L.CELL_GROUP
			    ,CASE WHEN MEASURE_UI = ''DIO'' 
				      THEN DBO.FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'',''C'') 
				      ELSE DBO.FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'',L.OPERATION_GROUP)
					  END AS OPERATION_GROUP
			   ,L.PRODUCT_LEVEL1
			   ,MG.MEASURE_GROUP AS MEASURE_GROUP 
			   ,MG.MEASURE_UI    AS MEASURE_UI
			   ,MG.MEASURE_NAME  AS MEASURE_NAME
			   ,MG.SORT_ORDER_NO AS SORT_ORDER_NO 
			   ,''-'' AS OPERATION_ID
			   ,''-'' AS ITEM_ID
			   ,''-'' AS TO_SITE	
			   ,''-'' AS FROM_SITE
			   ,''-'' AS INCOTERMS
			   ,''-'' AS VARIOUS_KEY
			   ,''-'' AS PRODUCT_LEVEL2
			   ,''-'' AS PRODUCT_LEVEL3
			   ,1 AS CELL_CF
			   ,' + @mQry_field_qty + '  
		   FROM W_LIST L
	 CROSS JOIN #TMP_MEASURE MG
	  WHERE MEASURE_UI NOT IN (''DIO'')
	   ORDER BY L.DIVISION_ID
			   ,L.CELL_GROUP
			   ,OPERATION_GROUP DESC
			   ,L.PRODUCT_LEVEL1
			   ,MG.SORT_ORDER_NO
		';

END


--################################################################################################################	
-- 3, PRODUCT_LEVEL2
--################################################################################################################	
ELSE IF @P_SEARCH_LEVEL = 'PRODUCT_LEVEL2'
BEGIN
			
	 --********************************************************************************
	 --#TMP_LIST_QTY
	 --********************************************************************************
		 SELECT YYYYPW
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL2
			   ,MEASURE AS MEASURE_UI
			   ,SUM(CELL_QTY)          AS QTY
			   ,SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
			   ,SUM(TO_BOH_QTY)   AS TO_BOH_QTY
			   ,MAX(CELL_CF )     AS CELL_CF 
		   INTO #TMP_LIST_QTY3
		   FROM #TMP_LIST_FULL
	   GROUP BY YYYYPW
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL2
			   ,MEASURE


   CREATE INDEX IDX_TMP_LIST_QTY3 ON #TMP_LIST_QTY3 ( 
                                                    YYYYPW
												   ,DIVISION_ID
												   ,CELL_GROUP
												   ,OPERATION_GROUP
												   ,PRODUCT_LEVEL2
												   ,MEASURE_UI
												   )

	 --********************************************************************************
	 --#@mQry_field_qty
	 --********************************************************************************
		SELECT  @mQry_field_qty    = @mQry_field_qty + ',  (SELECT QTY 
		                                                    FROM #TMP_LIST_QTY3
															WHERE L.DIVISION_ID		= DIVISION_ID 
															AND L.CELL_GROUP		= CELL_GROUP 
															AND L.OPERATION_GROUP	= OPERATION_GROUP 
															AND L.PRODUCT_LEVEL2	= PRODUCT_LEVEL2 
															AND MG.MEASURE_UI		= MEASURE_UI 
															AND YYYYPW = '''+YYYYPW+''')  as ' + YYYYPW_NAME + CHAR(10)
		FROM    #TMP_FIELD AS A
		ORDER BY sort_order_no;


		SET @mQry_field = RIGHT(@mQry_field, LEN(@mQry_field)-1);
		SET @mQry_field_qty = RIGHT(@mQry_field_qty, LEN(@mQry_field_qty)-1);
		
	 --********************************************************************************
	 --RESULT
	 --********************************************************************************
		SET @mEXEC       = '';
		SET @mEXEC = N'

		;WITH W_LIST AS 
		(
		 SELECT DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL2
		FROM #TMP_LIST_FULL L
		GROUP BY DIVISION_ID
			    ,CELL_GROUP
			    ,OPERATION_GROUP
			    ,PRODUCT_LEVEL2
		)

	 	 SELECT L.DIVISION_ID
			   ,L.CELL_GROUP
			    ,CASE WHEN MEASURE_UI = ''DIO'' 
				      THEN DBO.FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'',''C'') 
				      ELSE DBO.FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'',L.OPERATION_GROUP)
					  END AS OPERATION_GROUP
			   ,L.PRODUCT_LEVEL2
			   ,MG.MEASURE_GROUP AS MEASURE_GROUP 
			   ,MG.MEASURE_UI    AS MEASURE_UI
			   ,MG.MEASURE_NAME  AS MEASURE_NAME
			   ,MG.SORT_ORDER_NO AS SORT_ORDER_NO 
			   ,''-'' AS OPERATION_ID
			   ,''-'' AS ITEM_ID
			   ,''-'' AS TO_SITE	
			   ,''-'' AS FROM_SITE
			   ,''-'' AS INCOTERMS
			   ,''-'' AS VARIOUS_KEY
			   ,''-'' AS PRODUCT_LEVEL1
			   ,''-'' AS PRODUCT_LEVEL3
			   ,1 AS CELL_CF
			   ,' + @mQry_field_qty + '  
		   FROM W_LIST L
	 CROSS JOIN #TMP_MEASURE MG
	  WHERE MEASURE_UI NOT IN (''DIO'')
	   ORDER BY L.DIVISION_ID
			   ,L.CELL_GROUP
			   ,OPERATION_GROUP DESC
			   ,L.PRODUCT_LEVEL2
			   ,MG.SORT_ORDER_NO
		';
END


--################################################################################################################	
-- 34, PRODUCT_LEVEL3
--################################################################################################################	
ELSE IF @P_SEARCH_LEVEL = 'PRODUCT_LEVEL3'
BEGIN

	 --********************************************************************************
	 --#TMP_LIST_QTY
	 --********************************************************************************
		 SELECT YYYYPW
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL3
			   ,MEASURE AS MEASURE_UI
			   ,SUM(CELL_QTY)          AS QTY
			   ,SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
			   ,SUM(TO_BOH_QTY)   AS TO_BOH_QTY
			   ,MAX(CELL_CF )     AS CELL_CF 
		   INTO #TMP_LIST_QTY4
		   FROM #TMP_LIST_FULL
	   GROUP BY YYYYPW
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL3
			   ,MEASURE


   CREATE INDEX IDX_TMP_LIST_QTY4 ON #TMP_LIST_QTY4 ( 
                                                    YYYYPW
												   ,DIVISION_ID
												   ,CELL_GROUP
												   ,OPERATION_GROUP
												   ,PRODUCT_LEVEL3
												   ,MEASURE_UI
												   )

	 --********************************************************************************
	 --#@mQry_field_qty
	 --********************************************************************************
		SELECT  @mQry_field_qty    = @mQry_field_qty + ',  (SELECT QTY 
		                                                    FROM #TMP_LIST_QTY4
															WHERE L.DIVISION_ID		= DIVISION_ID 
															AND L.CELL_GROUP		= CELL_GROUP 
															AND L.OPERATION_GROUP	= OPERATION_GROUP 
															AND L.PRODUCT_LEVEL3	= PRODUCT_LEVEL3
															AND MG.MEASURE_UI		= MEASURE_UI 
															AND YYYYPW = '''+YYYYPW+''')  as ' + YYYYPW_NAME + CHAR(10)
		FROM    #TMP_FIELD AS A
		ORDER BY sort_order_no;


		SET @mQry_field = RIGHT(@mQry_field, LEN(@mQry_field)-1);
		SET @mQry_field_qty = RIGHT(@mQry_field_qty, LEN(@mQry_field_qty)-1);
		
	 --********************************************************************************
	 --RESULT
	 --********************************************************************************
		SET @mEXEC       = '';
		SET @mEXEC = N'

		;WITH W_LIST AS 
		(
		 SELECT DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL3
		FROM #TMP_LIST_FULL L
		GROUP BY DIVISION_ID
			    ,CELL_GROUP
				,OPERATION_GROUP
			    ,PRODUCT_LEVEL3
		)

	 	 SELECT L.DIVISION_ID
			   ,L.CELL_GROUP
			    ,CASE WHEN MEASURE_UI = ''DIO'' 
				      THEN DBO.FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'',''C'') 
				      ELSE DBO.FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'',L.OPERATION_GROUP)
					  END AS OPERATION_GROUP
			   ,L.PRODUCT_LEVEL3
			   ,MG.MEASURE_GROUP AS MEASURE_GROUP 
			   ,MG.MEASURE_UI    AS MEASURE_UI
			   ,MG.MEASURE_NAME  AS MEASURE_NAME
			   ,MG.SORT_ORDER_NO AS SORT_ORDER_NO 
			   ,''-'' AS OPERATION_ID
			   ,''-'' AS ITEM_ID
			   ,''-'' AS TO_SITE	
			   ,''-'' AS FROM_SITE
			   ,''-'' AS INCOTERMS
			   ,''-'' AS VARIOUS_KEY
			   ,''-'' AS PRODUCT_LEVEL1
			   ,''-'' AS PRODUCT_LEVEL2
			   ,1 AS CELL_CF
			   ,' + @mQry_field_qty + '  
		   FROM W_LIST L
	 CROSS JOIN #TMP_MEASURE MG
	  WHERE MEASURE_UI NOT IN (''DIO'')
	   ORDER BY L.DIVISION_ID
			   ,L.CELL_GROUP
			   ,OPERATION_GROUP DESC
			   ,PRODUCT_LEVEL3
			   ,MG.SORT_ORDER_NO
		';
END



			---------------------------------------------------------
			--DEBUG QRY 출력
			---------------------------------------------------------
			IF( @debug_mode ='T')
			BEGIN
				DECLARE @POS INT =1;
				SET @POS =1;
				DECLARE @LEN INT =LEN(@mEXEC);
				WHILE @POS <= @LEN
				BEGIN
					PRINT SUBSTRING(@mEXEC,@POS,4000);
					SET @POS = @POS+4000;
				END;
			END;

			EXEC (@mEXEC);


		IF OBJECT_ID('tempdb..#TMP_MEASURE') IS NOT NULL
		DROP TABLE #TMP_MEASURE;
		IF OBJECT_ID('tempdb..#TMP_LEVEL') IS NOT NULL
		DROP TABLE #TMP_LEVEL;
		IF OBJECT_ID('tempdb..#TMP_LIST_FULL') IS NOT NULL
		DROP TABLE #TMP_LIST_FULL;
		
		IF OBJECT_ID('tempdb..#TMP_LIST') IS NOT NULL
		DROP TABLE #TMP_LIST;
		IF OBJECT_ID('tempdb..#TMP_LIST_QTY') IS NOT NULL
		DROP TABLE #TMP_LIST_QTY;
		IF OBJECT_ID('tempdb..#TMP_FIELD') IS NOT NULL
		DROP TABLE #TMP_FIELD;
		IF OBJECT_ID('tempdb..#TMP_LIST_FIND') IS NOT NULL
		DROP TABLE #TMP_LIST_FIND;

		IF OBJECT_ID('tempdb..#TMP_LIST1') IS NOT NULL
		DROP TABLE #TMP_LIST1;
		IF OBJECT_ID('tempdb..#TMP_LIST_QTY1') IS NOT NULL
		DROP TABLE #TMP_LIST_QTY1;
		IF OBJECT_ID('tempdb..#TMP_FIELD1') IS NOT NULL
		DROP TABLE #TMP_FIELD1;
		IF OBJECT_ID('tempdb..#TMP_LIST_FIND1') IS NOT NULL
		DROP TABLE #TMP_LIST_FIND1;
		
		IF OBJECT_ID('tempdb..#TMP_LIST2') IS NOT NULL
		DROP TABLE #TMP_LIST2;
		IF OBJECT_ID('tempdb..#TMP_LIST_QTY2') IS NOT NULL
		DROP TABLE #TMP_LIST_QTY2;
		IF OBJECT_ID('tempdb..#TMP_FIELD2') IS NOT NULL
		DROP TABLE #TMP_FIELD2;
		IF OBJECT_ID('tempdb..#TMP_LIST_FIND2') IS NOT NULL
		DROP TABLE #TMP_LIST_FIND2;
		IF OBJECT_ID('tempdb..#TMP_TRANSPORT') IS NOT NULL
		DROP TABLE #TMP_TRANSPORT;
		IF OBJECT_ID('tempdb..#TMP_MEASURE_PART1') IS NOT NULL
		DROP TABLE #TMP_MEASURE_PART1;		
		IF OBJECT_ID('tempdb..#TMP_MEASURE_PART2') IS NOT NULL
		DROP TABLE #TMP_MEASURE_PART2;	
		IF OBJECT_ID('tempdb..#TMP_MEASURE_PART3') IS NOT NULL
		DROP TABLE #TMP_MEASURE_PART3;	
		IF OBJECT_ID('tempdb..#TMP_TRANS') IS NOT NULL
		DROP TABLE #TMP_TRANS;			
		IF OBJECT_ID('tempdb..#TMP_LINE') IS NOT NULL
		DROP TABLE #TMP_LINE;	
		IF OBJECT_ID('tempdb..#TMP_LIST_QTY4') IS NOT NULL
		DROP TABLE #TMP_LIST_QTY4;	
		IF OBJECT_ID('tempdb..#TMP_LIST_QTY5') IS NOT NULL
		DROP TABLE #TMP_LIST_QTY5;	
		
		IF OBJECT_ID('tempdb..#TMP_OPERATION') IS NOT NULL
		DROP TABLE #TMP_OPERATION;
END



  
