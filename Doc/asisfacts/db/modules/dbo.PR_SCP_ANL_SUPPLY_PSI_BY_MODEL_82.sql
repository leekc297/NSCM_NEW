      
/*      
 * Program ID : [PR_SCP_ANL_SUPPLY_PSI_BY_MODEL_82]      
 * Description : ESS  모델별 공급 PSI  저장. 대상 테이블 :  SCP_ANL_SUPPLY_PSI_REPORT_ESS
 * Execute      : 
        DECLARE	@return_value int
		EXEC [dbo].[PR_SCP_ANL_SUPPLY_PSI_BY_MODEL_82]
				@p_division_id = N'82',
				@p_plan_start_yyyymmdd = N'20210830',
				@p_plan_type = N'PR',				
				@p_seq = N'1',
				@debug_mode = N'T'

		SELECT	'Return Value' = @return_value

 * Program History      
 *===================================================================================================      
 *   Date		In Charge	Description      
 *===================================================================================================      
 * 2021.08.26	HJ.LEE		Initial Release  [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) 
 * 2022.03.25   sclee       PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가관련 @p_division_id NVARCHAR(2) -> NVARCHAR(10)으로 변경
 
 */      
CREATE PROCEDURE [dbo].[PR_SCP_ANL_SUPPLY_PSI_BY_MODEL_82]    
    @p_division_id				    NVARCHAR(10),
	@p_plan_start_yyyymmdd	NVARCHAR(8),
	@p_plan_type				    NVARCHAR(50),
	@p_seq						        NVARCHAR(50),
	@debug_mode					NVARCHAR(1)='F'
AS      
BEGIN      
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	PRINT 'All Start. '+CONVERT(CHAR(23), GETDATE(), 21)

	DECLARE @v_from_yyyymmdd     AS NVARCHAR(8)='';
	DECLARE @v_to_yyyymmdd       AS NVARCHAR(8)='';
	
	SET @v_from_yyyymmdd = @p_plan_start_yyyymmdd
	SET @v_to_yyyymmdd = CONVERT(CHAR(8), DATEADD(WW, 150,  convert(datetime,@p_plan_start_yyyymmdd)), 112); -- YY 3년 필요
    
		-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ANL_SUPPLY_PSI_BY_MODEL_82'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N''; 
	DECLARE @v_division_id	NVARCHAR(10)   = @p_division_id

	-- 임시 실행시간 확인용              
    DECLARE @v_start_time   DATETIME   = SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';    

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '#PR_SCP_ANL_SUPPLY_PSI_BY_MODEL_82#### Start of procedure #';     
    SET @v_description = @v_division_id + ' : ' + @p_plan_start_yyyymmdd + ' : ' + @p_plan_type + ' : ' + @p_seq ;
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- < - 변수 재사용을 위하여 초기화해야함 --*/
		
	-- 시작 LOG  (END)

	IF @debug_mode ='T'
	BEGIN
		PRINT '----------------------------------';
		PRINT 'v_from_yyyymmdd =' +@v_from_yyyymmdd;
		PRINT 'v_to_yyyymmdd =' +@v_to_yyyymmdd;
		
		PRINT '----------------------------------';
	END;

	BEGIN TRY                  
      BEGIN

    /********************************************************************************      
	 * 임시테이블만들기 - 조회조건 테이블      
	 ********************************************************************************/      
	--임시테이블 삭제      
	IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0074_item') is not null       
		DROP TABLE #TblDynamicPivot_SCP0074_item     

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074_TEMP') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0074_TEMP

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074_NICKITEM') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0074_NICKITEM

	IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0074') is not null       
		DROP TABLE #TblDynamicPivot_SCP0074

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074_TEMP1') IS NOT NULL      
	DROP TABLE #TblDynamicPivot_SCP0074_TEMP1;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074_LAST') IS NOT NULL      
	DROP TABLE #TblDynamicPivot_SCP0074_LAST;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074_RANK') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0074_RANK

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074_MEASURE') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0074_MEASURE

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074_MODELNAME') IS NOT NULL      
	DROP TABLE #TblDynamicPivot_SCP0074_MODELNAME;

	IF OBJECT_ID('tempdb..#SCM_MST_SITE') IS NOT NULL      
	DROP TABLE #SCM_MST_SITE;
	
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074_INVENTORY') IS NOT NULL      
	DROP TABLE #TblDynamicPivot_SCP0074_INVENTORY;


	/* NICK NAME 조회조건으로 ITEM 추출 */
	SELECT distinct ITEM_ID 
	INTO #TblDynamicPivot_SCP0074_NICKITEM
	FROM SCM_MST_ITEM_SN WITH(NOLOCK)
	WHERE 1=1
	AND NICK_NAME IS NOT NULL

	/* PSI CELL/PACK ITEM 세트 */
	SELECT CELL_ITEM_ID, ITEM_ID, RANK() OVER(ORDER BY CELL_ITEM_ID ASC) AS 'RANK'
	INTO #TblDynamicPivot_SCP0074_RANK
	FROM SCP_ANL_PSI_GLOBAL WITH(NOLOCK)
	WHERE DIVISION_ID = @p_division_id
	AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
	AND PLAN_TYPE = @p_plan_type
	AND SEQ = @p_seq
	AND YYYYMMDD >= @v_from_yyyymmdd
	AND YYYYMMDD <= @v_to_yyyymmdd
	GROUP BY CELL_ITEM_ID, ITEM_ID
	
	/* 조회조건에 해당하는 세트 모두 추출 */
	SELECT A.CELL_ITEM_ID, A.ITEM_ID
	INTO #TblDynamicPivot_SCP0074_item
	FROM #TblDynamicPivot_SCP0074_RANK A
	WHERE A.RANK IN 
		(
			SELECT B.RANK
			FROM #TblDynamicPivot_SCP0074_RANK B
			WHERE 1=1
			AND ( 
				(B.ITEM_ID IN (SELECT ITEM_ID FROM #TblDynamicPivot_SCP0074_NICKITEM))
				OR 				
				(B.CELL_ITEM_ID IN (SELECT ITEM_ID FROM #TblDynamicPivot_SCP0074_NICKITEM))
				)
		)
	;

	SELECT DIVISION_ID, OPERATION_ID, LINE_ID, LINE_NAME
				INTO #SCM_MST_LINE
			  FROM SCM_MST_LINE_V
			WHERE DIVISION_ID = @p_division_id 
    			--AND ELECTRODE_TYPE = 'E' 'A'
				--AND operation_id in ('A3000', 'A9000') -- Cell 공정           --, 'P5500', 'P9500' -- Pack 공정
				AND VALID_YN = 'Y'
				 --AND LINE_ID = 'A1A02'   -- 2호 

	PRINT 'Search Item set End. '+CONVERT(CHAR(23), GETDATE(), 21)
	
	/* 유저 MEASURE 세팅값 추출 */ --로드율은 PRODUCTION과 동일한 SORT 값을 강제 셋팅
	SELECT M.COLUMN_NAME
		 , M.COLUMN_LABEL_NAME	AS MEASURE_LABEL
		 , M.ATTRIBUTE3			AS MEASURE_COLOR	--MEASURE 별 COLOR RGB코드
		 , M.SORT_ORDER_NO		AS SORT_ORDER_NO	-- KHJ79 : 정열을 위한 값
	INTO #TblDynamicPivot_SCP0074_MEASURE
	FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
	-- khj78 : user 정보 없음 나중에 해달라고 하면 추가
	--LEFT JOIN SCM_MST_TITLESET_USER U ON U.program_id  = M.program_id AND U.sheet_name  = M.sheet_name
	--									AND U.column_name = M.column_name AND U.user_id = @p_user_id
	--LEFT JOIN SCM_MST_SHEET_MEASURE P ON P.program_id  = M.program_id AND P.sheet_name  = M.sheet_name AND P.column_name = 'PRODUCTION'
	--LEFT JOIN SCM_MST_SHEET_MEASURE S ON S.program_id  = M.program_id AND S.sheet_name  = M.sheet_name AND S.column_name = 'SHIP_REQ'
	WHERE M.PROGRAM_ID='SCP0074'
	AND M.VALID_YN='Y'
	AND M.SHEET_NAME = 'SUPPLY_PSI_BY_MODEL'
	ORDER BY SORT_ORDER_NO
	

	/* MODEL명(NICK_NAME) 칼럼 */ 
	SELECT DISTINCT A.ITEM_ID, A.CELL_ITEM_ID, MI.DOE, SMI.NICK_NAME
	   INTO #TblDynamicPivot_SCP0074_MODELNAME
	 FROM SCP_ANL_PSI_GLOBAL A WITH(NOLOCK)
		 LEFT OUTER JOIN (SELECT DIVISION_ID, ITEM_ID, MAX(DOE) AS DOE
						  FROM SCM_MST_ITEM_SN WITH(NOLOCK)
						  WHERE DOE IS NOT NULL
						  GROUP BY DIVISION_ID, ITEM_ID
						 ) MI
		 ON  A.DIVISION_ID  = MI.DIVISION_ID
		 AND A.CELL_ITEM_ID = MI.ITEM_ID	 
		 LEFT OUTER JOIN  SCM_MST_ITEM_SN SMI WITH(NOLOCK)
		 ON  A.DIVISION_ID  = SMI.DIVISION_ID
		 AND ISNULL(MI.DOE, A.CELL_ITEM_ID) = SMI.ITEM_ID
	WHERE A.DIVISION_ID = @p_division_id -- 40 : 소형 / 81 : 자동차 / 82 : ESS
	AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd   
	AND A.PLAN_TYPE =@p_plan_type
	AND A.SEQ = @p_seq
	AND A.QTY > 0

	/*SCM_SITE (FROM SITE)*/
	SELECT DIVISION_ID, SCM_SITE_ID, PLANT_ID, SITE_DESCRIPTION
		INTO #SCM_MST_SITE
	   FROM SCM_MST_SITE S WITH(NOLOCK)
  	 WHERE S.DIVISION_ID = @v_division_id
	  	 AND S.OSP_YN = 'N' 
		 AND  S.OPERATION_GROUP = 'A'	

   /*활성화 수율, 라인이 여러개일 경우 평균값. */
    SELECT PLANT_ID, ITEM_ID, MONTH, AVG(YIELD) AS YIELD
	   INTO #TblDynamicPivot_SCP0074_YIELD
	  FROM SCM_YIELD_VER_H_SN WITH(NOLOCK)
	WHERE  DIVISION_ID = @v_division_id 
	    AND VERSION_ID =
	    							(
									SELECT TOP 1 VERSION_ID 
									  FROM SCP_PLAN_VERSION_V WITH(NOLOCK)
									WHERE DIVISION_ID = @v_division_id
										AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
										AND PLAN_TYPE =@p_plan_type
										AND PLAN_SEQ = @p_seq
									)
     GROUP BY PLANT_ID, ITEM_ID, MONTH


	PRINT 'Search Measure set End. '+CONVERT(CHAR(23), GETDATE(), 21)

	-- LOG                  
	SET @v_log_type = N'TXN';                  
	SET @v_log_message = N'Measure set';                        
	SET @d_event_date = SYSDATETIME()  ;                 
	EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
								,@p_log_type      =@v_log_type                  
								,@p_log_count     =@n_log_count                   
								,@p_log_message   =@v_log_message                   
								,@p_description   =@v_description                   
								,@p_event_date    =@d_event_date                   
								,@p_user_id       =@v_batch_user                  
								;  

	/********************************************************************************      
	 * 임시테이블만들기 - 본 테이블      
	 ********************************************************************************/      
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074') IS NOT NULL      
	DROP TABLE #TblDynamicPivot_SCP0074;      

	/********************************************************************************      
	* 데이타조회, 임시테이블에 저장      
	********************************************************************************/
	
	DECLARE @mEXEC NVARCHAR(MAX);
	DECLARE @POS INT =1;
	DECLARE @LEN INT =LEN(@mEXEC);

	CREATE TABLE #TblDynamicPivot_SCP0074 (
			 DIVISION_ID		      NVARCHAR(60)	
			,PLANT_ID                   NVARCHAR(10)	
			,OPERATION_GROUP    NVARCHAR(8)
			,OPERATION_ID           NVARCHAR(10)
			,NICK_NAME 				  NVARCHAR(60)		-- Cell모델명 JH3, JH4
			,CELL_ITEM_ID		      NVARCHAR(100)	
			,ITEM_ID			          NVARCHAR(100)
			,FROM_SITE			      NVARCHAR(60)
			,FROM_SITE_DESCRIPTION NVARCHAR(100)
			,MEASURE		        	NVARCHAR(100)          
			,MEASURE_LABEL		NVARCHAR(100) 
			,MEASURE_COLOR	    NVARCHAR(30)
			,SORT_ORDER_NO		NVARCHAR(100)    		
			,B_yyyymmdd			NVARCHAR(10)
			,YYYYMMDD			    NVARCHAR(10)
			,YYYYMM				    NVARCHAR(6)
			,YYYYQQ  	                NVARCHAR(6)
			,YYYY                        NVARCHAR(4)
			,QTY				            NUMERIC(20,10)
			,ISO_WEEK			    INT
			,TRANSPORT_MODE_LINE NVARCHAR(60)
	);
	
	--BALANCE
	--CHAR_AVAILABLE
	--INVENTORY
	--MODEL_INVENTORY
	--PRODUCTION
	--SHIP_PLAN
	--SHIP_REQ

	SET @mEXEC = '';
	SET @mEXEC = @mEXEC + ' INSERT #TblDynamicPivot_SCP0074										'+CHAR(10);
	SET @mEXEC = @mEXEC + ' SELECT A.DIVISION_ID														'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, S.PLANT_ID          												    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.OPERATION_GROUP												'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.ATTRIBUTE9 AS OPERATION_ID   							'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, MO.NICK_NAME						      							'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.CELL_ITEM_ID														'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.ITEM_ID																'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.FROM_SITE															'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, S.SITE_DESCRIPTION AS FROM_SITE_DESCRIPTION	'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.MEASURE	   						           							'+CHAR(10);   
	--SET @mEXEC = @mEXEC + '			, M.MEASURE_LABEL	   												'+CHAR(10);   
    SET @MEXEC = @MEXEC + '	        , IIF(A.MEASURE = ''PRODUCTION'', MEASURE_LABEL + ''('' +  S.SITE_DESCRIPTION + '')'',MEASURE_LABEL)  AS MEASURE_LABEL ' + CHAR(10); 
	SET @mEXEC = @mEXEC + '			, M.MEASURE_COLOR	   												'+CHAR(10);   
	SET @mEXEC = @mEXEC + '			, M.SORT_ORDER_NO	   												'+CHAR(10);   
	SET @mEXEC = @mEXEC + '			, A.yyyymmdd AS B_yyyymmdd									'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, ''D_''+ A.yyyymmdd AS yyyymmdd							'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, o.basis_yyyymm AS yyyymm									'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, o.CALENDAR_YYYYQQ AS yyyyqq 								'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, o.CALENDAR_YYYY AS yyyy   									'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, SUM(isnull(qty,0)) AS qty											'+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, RIGHT(o.basis_yyyymm, 4)+o.iso_week AS iso_week			'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, O.ISO_YYYYWW AS ISO_WEEK	                                  		'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.TRANSPORT_MODE_LINE												'+CHAR(10);
	SET @mEXEC = @mEXEC + '	   FROM SCP_ANL_PSI_GLOBAL A WITH(NOLOCK)							'+CHAR(10);
	SET @mEXEC = @mEXEC + '	   INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) o on A.yyyymmdd = o.basis_yyyymmdd						            '+CHAR(10);
	SET @mEXEC = @mEXEC + '	   INNER JOIN #TblDynamicPivot_SCP0074_MEASURE M (NOLOCK) ON M.COLUMN_NAME=A.MEASURE				'+CHAR(10);
	SET @mEXEC = @mEXEC + '	   INNER JOIN #TblDynamicPivot_SCP0074_MODELNAME MO (NOLOCK) ON MO.ITEM_ID= A.ITEM_ID AND MO.CELL_ITEM_ID = A.CELL_ITEM_ID	'+CHAR(10);
	SET @mEXEC = @mEXEC + '     LEFT JOIN #SCM_MST_SITE S (NOLOCK) ON S.DIVISION_ID = A.DIVISION_ID AND S.SCM_SITE_ID = A.FROM_SITE  '+CHAR(10);
	SET @mEXEC = @mEXEC + '	  WHERE A.DIVISION_ID			= '''+@p_division_id+'''			   	             '+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.PLAN_START_YYYYMMDD	= '''+@p_plan_start_yyyymmdd+'''	 '+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.PLAN_TYPE				= '''+@p_plan_type+'''							 '+CHAR(10);	
	SET @mEXEC = @mEXEC + '		AND A.SEQ					    = '''+@p_seq+'''					           			 '+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.YYYYMMDD >= '''+@v_from_yyyymmdd+'''							 '+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.YYYYMMDD <= '''+@v_to_yyyymmdd+'''								 '+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND M.COLUMN_NAME IN (''CHAR_AVAILABLE'',''INVENTORY'',''MODEL_INVENTORY'',''PRODUCTION'',''SHIP_PLAN'',''SHIP_REQ'') '+CHAR(10);
	SET @mEXEC = @mEXEC + '		GROUP BY A.DIVISION_ID, S.PLANT_ID, A.OPERATION_GROUP, A.ATTRIBUTE9, MO.NICK_NAME,A.CELL_ITEM_ID,A.ITEM_ID,	A.FROM_SITE,  S.SITE_DESCRIPTION, A.TRANSPORT_MODE_LINE	, A.MEASURE,M.MEASURE_LABEL,MEASURE_COLOR	,M.SORT_ORDER_NO	,A.yyyymmdd,''D_''+ A.yyyymmdd  ,o.basis_yyyymm,o.CALENDAR_YYYYQQ  ,O.CALENDAR_YYYY ,O.ISO_YYYYWW  '+CHAR(10);
	
	-- LOG                  
	SET @v_log_type = N'TXN';                  
	SET @v_log_message = N'Insert Temp Table';                        
	SET @d_event_date = SYSDATETIME()  ;                 
	EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
								,@p_log_type      =@v_log_type                  
								,@p_log_count     =@n_log_count                   
								,@p_log_message   =@v_log_message                   
								,@p_description   =@v_description                   
								,@p_event_date    =@d_event_date                   
								,@p_user_id       =@v_batch_user                  
								;  

	-----------------------------------------------------------
	-- DEBUG QRY 출력
	-----------------------------------------------------------	
	IF( @debug_mode ='T')
		BEGIN				
			SET @POS  =1;
			SET @LEN =LEN(@mEXEC);
			WHILE @POS <= @LEN
				BEGIN
					PRINT SUBSTRING(@mEXEC,@POS,4000);
					SET @POS = @POS+4000;
				END;
		END;

	EXEC (@mEXEC);

	PRINT 'Temp Data set End. '+CONVERT(CHAR(23), GETDATE(), 21)		
 
	--------------과부족 (Balance) ROW Insert ----------------
	INSERT #TblDynamicPivot_SCP0074
	SELECT   A.DIVISION_ID
	            , A.PLANT_ID
	            , A.OPERATION_GROUP        
				, A.OPERATION_ID 
				, A.NICK_NAME
				, A.CELL_ITEM_ID
				, A.ITEM_ID
				, FROM_SITE
				, FROM_SITE_DESCRIPTION
				, M.COLUMN_NAME AS MEASURE
				, M.MEASURE_LABEL
				, M.MEASURE_COLOR
				, M.SORT_ORDER_NO
				, A.B_YYYYMMDD
				, A.YYYYMMDD
				, A.YYYYMM
				, A.YYYYQQ
				, A.YYYY
				, 0	 AS QTY			-- QTY
				, A.ISO_WEEK
				, TRANSPORT_MODE_LINE
		   FROM #TblDynamicPivot_SCP0074 A
		  CROSS APPLY(SELECT COLUMN_NAME , MEASURE_COLOR , MEASURE_LABEL , SORT_ORDER_NO
							      FROM  #TblDynamicPivot_SCP0074_MEASURE M (NOLOCK) 
							    WHERE COLUMN_NAME = 'BALANCE'
							  ) M
		  WHERE A.MEASURE = 'SHIP_REQ'  --'MKT_FCST'
		 ;
	
	 -- CHAR_AVAILABLE * 활성화 수율을   MEASURE 'CHAR_AVAILABLE_MUL' 로 저장
	INSERT #TblDynamicPivot_SCP0074
	SELECT  A.DIVISION_ID
	            , A.PLANT_ID
	            , A.OPERATION_GROUP        
				, A.OPERATION_ID
				, A.NICK_NAME AS CELL_MODEL_NAME
				, A.CELL_ITEM_ID 
				, A.ITEM_ID
				, FROM_SITE AS SCM_SITE_ID
				, FROM_SITE_DESCRIPTION AS  SCM_SITE_NAME
				, 'CHAR_AVAILABLE_MUL' ASMEASURE
				, 'CHAR_AVAILABLE_MUL' AS MEASURE_LABEL
				, '' AS  MEASURE_COLOR
				, '' AS  SORT_ORDER_NO
				, A.B_yyyymmdd
				, A.yyyymmdd
				, A.yyyymm  AS BASIS_YYYYMM
				, A.yyyyqq  AS BASIS_YYYYQQ 
				, A.yyyy AS BASIS_YYYY
				--, A.QTY AS ORI_QTY
				--, Y.YIELD AS YIELD
				, A.QTY * Y.YIELD AS QTY
				, A.iso_week  AS ISO_YYYYWW
			    , TRANSPORT_MODE_LINE
		   FROM #TblDynamicPivot_SCP0074 A
		            LEFT JOIN #TblDynamicPivot_SCP0074_YIELD Y ON Y.PLANT_ID = A.PLANT_ID AND Y.ITEM_ID = A.ITEM_ID AND Y.MONTH =  A.yyyymm
        WHERE  MEASURE = 'CHAR_AVAILABLE'


	 IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0074_TEMP1') is not null       
	 DROP TABLE #TblDynamicPivot_SCP0074_TEMP1; 

	  SELECT  A.DIVISION_ID
	            , A.PLANT_ID
	            , A.OPERATION_GROUP        
				, A.OPERATION_ID
				, A.NICK_NAME
				, A.CELL_ITEM_ID
				, A.ITEM_ID
				, FROM_SITE
				, FROM_SITE_DESCRIPTION
				, A.MEASURE
				, A.MEASURE_LABEL
				, A.MEASURE_COLOR
				, A.SORT_ORDER_NO
				, A.B_yyyymmdd
				, A.yyyymmdd
				, A.yyyymm
				, A.yyyyqq
				, A.yyyy
				, A.QTY
				, A.iso_week
				, isnull(NULLIF( 
										( 
										CASE WHEN A.OPERATION_GROUP ='A' THEN '1' 
													ELSE (SELECT TOP 1 convert(nvarchar(50), ceiling(V.ACCUMULATED_CHILD_QTY) ) 	
 												        		 FROM DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)					
 															   WHERE V.DIVISION_ID=A.DIVISION_ID
																   AND V.OPERATION_GROUP_ID='A'		
 																   AND V.MODEL_ID  = A.ITEM_ID
																   AND V.CHILD_ITEM_ID = A.CELL_ITEM_ID
 															  ) END
										), '') , '1')  AS CELL_QTY
                  , TRANSPORT_MODE_LINE
			INTO #TblDynamicPivot_SCP0074_TEMP1
		   FROM #TblDynamicPivot_SCP0074 A


	  IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0074_LAST') is not null       
	  DROP TABLE #TblDynamicPivot_SCP0074_LAST; 
     
	 SELECT  A.DIVISION_ID
	            , A.PLANT_ID
	            , A.OPERATION_GROUP 
				, A.OPERATION_ID
				, A.NICK_NAME AS CELL_MODEL_NAME
				, A.CELL_ITEM_ID 
				, A.ITEM_ID
				, FROM_SITE AS SCM_SITE_ID
				, FROM_SITE_DESCRIPTION AS  SCM_SITE_NAME
				, A.MEASURE
				, A.MEASURE_LABEL
				, A.MEASURE_COLOR
				, A.SORT_ORDER_NO
				, A.B_yyyymmdd
				, A.yyyymmdd
				, A.yyyymm  AS BASIS_YYYYMM
				, A.yyyyqq  AS BASIS_YYYYQQ 
				, A.yyyy AS BASIS_YYYY
				, A.QTY
				, A.iso_week  AS ISO_YYYYWW
				, A.QTY * A.CELL_QTY AS RESULT_QTY
			    , TRANSPORT_MODE_LINE
		    INTO #TblDynamicPivot_SCP0074_LAST 
		   FROM #TblDynamicPivot_SCP0074_TEMP1 A
	
	PRINT 'Search Rowdata set End. '+CONVERT(CHAR(23), GETDATE(), 21)

	-- LOG                  
	SET @v_log_type = N'TXN';                  
	SET @v_log_message = N'Rowdata set';                        
	SET @d_event_date = SYSDATETIME()  ;                 
	EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
								,@p_log_type      =@v_log_type                  
								,@p_log_count     =@n_log_count                   
								,@p_log_message   =@v_log_message                   
								,@p_description   =@v_description                   
								,@p_event_date    =@d_event_date                   
								,@p_user_id       =@v_batch_user                  
								;  

   /********************************************************************************      
	* PIVOIT처리      
	********************************************************************************/   
	BEGIN   
				DECLARE @mQRY_sum1 NVARCHAR(MAX);      			

				SET @mQRY_sum1 = '';

				PRINT 'PIVOIT  START '+CONVERT(CHAR(23), GETDATE(), 21)

				DELETE SCP_ANL_SUPPLY_PSI_REPORT_ESS
				 WHERE DIVISION_ID = @p_division_id
					 AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					 AND PLAN_TYPE = @p_plan_type
					 AND SEQ = @p_seq

				SELECT TOP 130 @mQRY_sum1 = @mQRY_sum1+','+ 
					CASE WHEN CHARINDEX('Y_', YYYYMMDD) =1 THEN   '  ISNULL(SUM(CASE WHEN BASIS_YYYY = RIGHT('''+YYYYMMDD+''', 4) THEN QTY END ),0) AS ' + YYYYMMDD    
							 WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN BASIS_YYYYMM = RIGHT('''+YYYYMMDD+''', 6) THEN QTY END ),0) AS ' + YYYYMMDD   
							 WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN BASIS_YYYYQQ = RIGHT('''+YYYYMMDD+''', 6) THEN QTY END ),0) AS ' + YYYYMMDD    
							 WHEN CHARINDEX('W_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN  ISO_YYYYWW = RIGHT('''+YYYYMMDD+''', 6) THEN QTY END ),0) AS ' + YYYYMMDD   
					END +''+CHAR(10) 
				FROM (
					SELECT TOP 100  'W_'+ A.ISO_YYYYWW AS YYYYMMDD  
						, '03'+A.BASIS_START_DATE + CONVERT(CHAR(2), '03') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND CONVERT(CHAR(8), DATEADD(MM, 2,  convert(datetime,@v_to_yyyymmdd)), 112)        
					GROUP BY A.ISO_YYYYWW, A.BASIS_START_DATE      
					UNION       
					SELECT TOP 20 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
					  ,'02'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '02') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND CONVERT(CHAR(8), DATEADD(MM, 2,  convert(datetime,@v_to_yyyymmdd)), 112)        
					GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME        
					UNION 
				  SELECT TOP 7  'Q_'+A.CALENDAR_YYYYQQ  AS YYYYMMDD
					  ,'01'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd      
					GROUP BY A.CALENDAR_YYYYQQ 
					UNION 
				  SELECT TOP 3 'Y_'+A.CALENDAR_YYYY  AS YYYYMMDD
					  ,'00'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '00') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd        
					GROUP BY A.CALENDAR_YYYY   
				)  A      
				ORDER BY SORT_ORDER_NO ;      
				

				SET @mEXEC = '';

				SET @mEXEC = @mEXEC + ' INSERT INTO [dbo].[SCP_ANL_SUPPLY_PSI_REPORT_ESS]																																					'+CHAR(10);
				SET @mEXEC = @mEXEC + '            ([DIVISION_ID], [PLANT_ID], [PLAN_START_YYYYMMDD], [PLAN_TYPE], [SEQ], [CELL_ITEM_ID], [CELL_MODEL_NAME], [SCM_SITE_ID], [SCM_SITE_NAME]			'+CHAR(10); 
				SET @mEXEC = @mEXEC + '            ,[MEASURE], [MEASURE_LABEL] ,[MEASURE_COLOR], [SORT_ORDER_NO], [LINE_ID],[LINE_NAME] ,[Y0],[Y1],[Y2],[Q0],[Q1],[Q2],[Q3],[Q4],[Q5],[Q6],[M0],[M1],[M2]          '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[M3],[M4],[M5],[M6],[M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[W0],[W1]													'+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W2],[W3],[W4],[W5],[W6],[W7],[W8],[W9],[W10],[W11],[W12],[W13],[W14],[W15],[W16],[W17],[W18],[W19]													'+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W20],[W21],[W22],[W23],[W24],[W25],[W26],[W27],[W28],[W29],[W30],[W31],[W32],[W33],[W34],[W35],[W36],[W37],[W38],[W39],[W40]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W41],[W42],[W43],[W44],[W45],[W46],[W47],[W48],[W49],[W50],[W51],[W52],[W53],[W54],[W55],[W56],[W57],[W58],[W59],[W60],[W61]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W62],[W63],[W64],[W65],[W66],[W67],[W68],[W69],[W70],[W71],[W72],[W73],[W74],[W75],[W76],[W77],[W78],[W79],[W80],[W81],[W82]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W83],[W84],[W85],[W86],[W87],[W88],[W89],[W90],[W91],[W92],[W93],[W94],[W95],[W96],[W97],[W98],[W99])                                              '+CHAR(10);  
				SET @mEXEC = @mEXEC + ' (SELECT  ''' + @p_division_id +'''		  					       '+CHAR(10);
				SET @mEXEC = @mEXEC + '              , A.PLANT_ID     										   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_plan_start_yyyymmdd+'''     		   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_plan_type+'''                       		   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_seq+'''                                		       '+CHAR(10);
				SET @mEXEC = @mEXEC + '              , A.CELL_ITEM_ID										   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.CELL_MODEL_NAME								   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              , A.SCM_SITE_ID										   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.SCM_SITE_NAME									   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.MEASURE									    		   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.MEASURE_LABEL							   		   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.MEASURE_COLOR							   		   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.SORT_ORDER_NO    	                     		   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.TRANSPORT_MODE_LINE  AS LINE_ID	   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 			    , L.LINE_NAME                               		       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				' + @mQRY_sum1 +'									   '+CHAR(10);	
				SET @mEXEC = @mEXEC + ' 		FROM #TblDynamicPivot_SCP0074_LAST A WITH(NOLOCK)                         '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 		LEFT JOIN #SCM_MST_LINE L ON L.DIVISION_ID = A.DIVISION_ID            '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 		                                           AND L.LINE_ID = A.TRANSPORT_MODE_LINE  '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 		                                           AND L.OPERATION_ID = A.OPERATION_ID        '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 		GROUP BY A.PLANT_ID    							           '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 		              , A.CELL_ITEM_ID							       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.CELL_MODEL_NAME             			   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.SCM_SITE_ID             				 	   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.SCM_SITE_NAME							       '+CHAR(10);
			    SET @mEXEC = @mEXEC + ' 				      , A.MEASURE                            			   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.MEASURE_LABEL            				 	   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.MEASURE_COLOR           				 	   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.SORT_ORDER_NO						       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.TRANSPORT_MODE_LINE  			       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , L.LINE_NAME                   			           '+CHAR(10);
				
				SET @mEXEC = @mEXEC + ' )                                                     					       '+CHAR(10);

				---PRINT 'INSERT SCP_ANL_SUPPLY_PSI_REPORT_ESS  START 1 '+CONVERT(CHAR(23), GETDATE(), 21)
              

				IF( @debug_mode ='T')
					BEGIN				
						SET @POS =1;
						SET @LEN =LEN(@mEXEC);
						WHILE @POS <= @LEN
							BEGIN
								PRINT SUBSTRING(@mEXEC,@POS,4000);
								SET @POS = @POS+4000;
							END;
					END;
				EXEC (@mEXEC);

				-- LOG                  
				SET @v_log_type = N'TXN';                  
				SET @v_log_message = N'PIVOIT';                        
				SET @d_event_date = SYSDATETIME()  ;                 
				EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
											,@p_log_type      =@v_log_type                  
											,@p_log_count     =@n_log_count                   
											,@p_log_message   =@v_log_message                   
											,@p_description   =@v_description                   
											,@p_event_date    =@d_event_date                   
											,@p_user_id       =@v_batch_user                  
											;  
												
         -- INVENTORY INSERT
		 INSERT INTO [dbo].[SCP_ANL_SUPPLY_PSI_REPORT_ESS]																													
				            ([DIVISION_ID], [PLANT_ID], [PLAN_START_YYYYMMDD], [PLAN_TYPE], [SEQ], [CELL_ITEM_ID], [CELL_MODEL_NAME], SCM_SITE_ID, SCM_SITE_NAME
				            ,[MEASURE], [MEASURE_LABEL] ,[MEASURE_COLOR], [SORT_ORDER_NO]
							,[Y0] ,[Y1] ,[Y2] ,[Q0] ,[Q1] ,[Q2] ,[Q3] ,[Q4] ,[Q5] ,[Q6]
				  			,[M0] ,[M1] ,[M2] ,[M3] ,[M4] ,[M5] ,[M6] ,[M7] ,[M8] ,[M9] ,[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19]
							,[W0] ,[W1] ,[W2] ,[W3] ,[W4] ,[W5] ,[W6] ,[W7] ,[W8] ,[W9] ,[W10],[W11],[W12],[W13],[W14],[W15],[W16],[W17],[W18],[W19]													
							,[W20],[W21],[W22],[W23],[W24],[W25],[W26],[W27],[W28],[W29],[W30],[W31],[W32],[W33],[W34],[W35],[W36],[W37],[W38],[W39],[W40]       
							,[W41],[W42],[W43],[W44],[W45],[W46],[W47],[W48],[W49],[W50],[W51],[W52],[W53],[W54],[W55],[W56],[W57],[W58],[W59],[W60],[W61]       
							,[W62],[W63],[W64],[W65],[W66],[W67],[W68],[W69],[W70],[W71],[W72],[W73],[W74],[W75],[W76],[W77],[W78],[W79],[W80],[W81],[W82]       
							,[W83],[W84],[W85],[W86],[W87],[W88],[W89],[W90],[W91],[W92],[W93],[W94],[W95],[W96],[W97],[W98],[W99])   
				 (
				  SELECT DIVISION_ID, PLANT_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, CELL_ITEM_ID, CELL_MODEL_NAME, SCM_SITE_ID, SCM_SITE_NAME 
  					          ,'INVENTORY' AS MEASURE,   'Inventory'  AS MEASURE_LABEL, '' AS MEASURE_COLOR, 7 AS SORT_ORDER_NO 
			            	                            ,I_Y0   +  M_Y0   AS  Y0 
														,I_Y1   +  M_Y1   AS  Y1 
							                            ,I_Y2   +  M_Y2   AS  Y2 
							                            ,I_Q0   +  M_Q0   AS  Q0 
							                            ,I_Q1   +  M_Q1   AS  Q1 
							                            ,I_Q2   +  M_Q2   AS  Q2 
							                            ,I_Q3   +  M_Q3   AS  Q3 
							                            ,I_Q4   +  M_Q4   AS  Q4 
							                            ,I_Q5   +  M_Q5   AS  Q5 
							                            ,I_Q6   +  M_Q6   AS  Q6 
							                            ,I_M0   +  M_M0   AS  M0 
							                            ,I_M1   +  M_M1   AS  M1 
							                            ,I_M2   +  M_M2   AS  M2 
							                            ,I_M3   +  M_M3   AS  M3 
							                            ,I_M4   +  M_M4   AS  M4 
							                            ,I_M5   +  M_M5   AS  M5 
							                            ,I_M6   +  M_M6   AS  M6 
							                            ,I_M7   +  M_M7   AS  M7 
							                            ,I_M8   +  M_M8   AS  M8 
							                            ,I_M9   +  M_M9   AS  M9 
							                            ,I_M10  +  M_M10  AS  M10
							                            ,I_M11  +  M_M11  AS  M11
							                            ,I_M12  +  M_M12  AS  M12
							                            ,I_M13  +  M_M13  AS  M13
							                            ,I_M14  +  M_M14  AS  M14
							                            ,I_M15  +  M_M15  AS  M15
							                            ,I_M16  +  M_M16  AS  M16
							                            ,I_M17  +  M_M17  AS  M17
							                            ,I_M18  +  M_M18  AS  M18
							                            ,I_M19  +  M_M19  AS  M19
							                            ,I_W0   +  M_W0   AS  W0 
							                            ,I_W1   +  M_W1   AS  W1 
							                            ,I_W2   +  M_W2   AS  W2 
							                            ,I_W3   +  M_W3   AS  W3 
							                            ,I_W4   +  M_W4   AS  W4 
							                            ,I_W5   +  M_W5   AS  W5 
							                            ,I_W6   +  M_W6   AS  W6 
							                            ,I_W7   +  M_W7   AS  W7 
							                            ,I_W8   +  M_W8   AS  W8 
							                            ,I_W9   +  M_W9   AS  W9 
							                            ,I_W10  +  M_W10  AS  W10
							                            ,I_W11  +  M_W11  AS  W11
							                            ,I_W12  +  M_W12  AS  W12
							                            ,I_W13  +  M_W13  AS  W13
							                            ,I_W14  +  M_W14  AS  W14
							                            ,I_W15  +  M_W15  AS  W15
							                            ,I_W16  +  M_W16  AS  W16
							                            ,I_W17  +  M_W17  AS  W17
							                            ,I_W18  +  M_W18  AS  W18
							                            ,I_W19  +  M_W19  AS  W19
							                            ,I_W20  +  M_W20  AS  W20
							                            ,I_W21  +  M_W21  AS  W21
							                            ,I_W22  +  M_W22  AS  W22
							                            ,I_W23  +  M_W23  AS  W23
							                            ,I_W24  +  M_W24  AS  W24
							                            ,I_W25  +  M_W25  AS  W25
							                            ,I_W26  +  M_W26  AS  W26
							                            ,I_W27  +  M_W27  AS  W27
							                            ,I_W28  +  M_W28  AS  W28
							                            ,I_W29  +  M_W29  AS  W29
							                            ,I_W30  +  M_W30  AS  W30
							                            ,I_W31  +  M_W31  AS  W31
							                            ,I_W32  +  M_W32  AS  W32
							                            ,I_W33  +  M_W33  AS  W33
							                            ,I_W34  +  M_W34  AS  W34
							                            ,I_W35  +  M_W35  AS  W35
							                            ,I_W36  +  M_W36  AS  W36
							                            ,I_W37  +  M_W37  AS  W37
							                            ,I_W38  +  M_W38  AS  W38
							                            ,I_W39  +  M_W39  AS  W39
							                            ,I_W40  +  M_W40  AS  W40
							                            ,I_W41  +  M_W41  AS  W41
							                            ,I_W42  +  M_W42  AS  W42
							                            ,I_W43  +  M_W43  AS  W43
							                            ,I_W44  +  M_W44  AS  W44
							                            ,I_W45  +  M_W45  AS  W45
							                            ,I_W46  +  M_W46  AS  W46
							                            ,I_W47  +  M_W47  AS  W47
							                            ,I_W48  +  M_W48  AS  W48
							                            ,I_W49  +  M_W49  AS  W49
							                            ,I_W50  +  M_W50  AS  W50
							                            ,I_W51  +  M_W51  AS  W51
							                            ,I_W52  +  M_W52  AS  W52
							                            ,I_W53  +  M_W53  AS  W53
							                            ,I_W54  +  M_W54  AS  W54
							                            ,I_W55  +  M_W55  AS  W55
							                            ,I_W56  +  M_W56  AS  W56
							                            ,I_W57  +  M_W57  AS  W57
							                            ,I_W58  +  M_W58  AS  W58
							                            ,I_W59  +  M_W59  AS  W59
							                            ,I_W60  +  M_W60  AS  W60
							                            ,I_W61  +  M_W61  AS  W61
							                            ,I_W62  +  M_W62  AS  W62
							                            ,I_W63  +  M_W63  AS  W63
							                            ,I_W64  +  M_W64  AS  W64
							                            ,I_W65  +  M_W65  AS  W65
							                            ,I_W66  +  M_W66  AS  W66
							                            ,I_W67  +  M_W67  AS  W67
							                            ,I_W68  +  M_W68  AS  W68
							                            ,I_W69  +  M_W69  AS  W69
							                            ,I_W70  +  M_W70  AS  W70
							                            ,I_W71  +  M_W71  AS  W71
							                            ,I_W72  +  M_W72  AS  W72
							                            ,I_W73  +  M_W73  AS  W73
							                            ,I_W74  +  M_W74  AS  W74
							                            ,I_W75  +  M_W75  AS  W75
							                            ,I_W76  +  M_W76  AS  W76
							                            ,I_W77  +  M_W77  AS  W77
							                            ,I_W78  +  M_W78  AS  W78
							                            ,I_W79  +  M_W79  AS  W79
							                            ,I_W80  +  M_W80  AS  W80
							                            ,I_W81  +  M_W81  AS  W81
							                            ,I_W82  +  M_W82  AS  W82
							                            ,I_W83  +  M_W83  AS  W83
							                            ,I_W84  +  M_W84  AS  W84
							                            ,I_W85  +  M_W85  AS  W85
							                            ,I_W86  +  M_W86  AS  W86
							                            ,I_W87  +  M_W87  AS  W87
							                            ,I_W88  +  M_W88  AS  W88
							                            ,I_W89  +  M_W89  AS  W89
							                            ,I_W90  +  M_W90  AS  W90
							                            ,I_W91  +  M_W91  AS  W91
							                            ,I_W92  +  M_W92  AS  W92
							                            ,I_W93  +  M_W93  AS  W93
							                            ,I_W94  +  M_W94  AS  W94
							                            ,I_W95  +  M_W95  AS  W95
							                            ,I_W96  +  M_W96  AS  W96
							                            ,I_W97  +  M_W97  AS  W97
							                            ,I_W98  +  M_W98  AS  W98
                                                        ,I_W99  +  M_W99  AS  W99
			        FROM
					           ( 
      				 	         SELECT DIVISION_ID, PLANT_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, CELL_ITEM_ID, CELL_MODEL_NAME, SCM_SITE_ID, SCM_SITE_NAME 
								            ,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(Y0  ,0) END ) AS numeric) AS I_Y0
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(Y1  ,0) END ) AS numeric) AS I_Y1
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(Y2  ,0) END ) AS numeric) AS I_Y2
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(Q0  ,0) END ) AS numeric) AS I_Q0
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(Q1  ,0) END ) AS numeric) AS I_Q1
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(Q2  ,0) END ) AS numeric) AS I_Q2
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(Q3  ,0) END ) AS numeric) AS I_Q3
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(Q4  ,0) END ) AS numeric) AS I_Q4
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(Q5  ,0) END ) AS numeric) AS I_Q5
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(Q6  ,0) END ) AS numeric) AS I_Q6
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M0  ,0) END ) AS numeric) AS I_M0           
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M1  ,0) END ) AS numeric) AS I_M1       
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M2  ,0) END ) AS numeric) AS I_M2       
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M3  ,0) END ) AS numeric) AS I_M3       
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M4  ,0) END ) AS numeric) AS I_M4       
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M5  ,0) END ) AS numeric) AS I_M5       
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M6  ,0) END ) AS numeric) AS I_M6       
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M7  ,0) END ) AS numeric) AS I_M7       
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M8  ,0) END ) AS numeric) AS I_M8       
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M9  ,0) END ) AS numeric) AS I_M9       
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M10 ,0) END ) AS numeric) AS I_M10      
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M11 ,0) END ) AS numeric) AS I_M11      
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M12 ,0) END ) AS numeric) AS I_M12      
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M13 ,0) END ) AS numeric) AS I_M13      
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M14 ,0) END ) AS numeric) AS I_M14      
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M15 ,0) END ) AS numeric) AS I_M15      
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M16 ,0) END ) AS numeric) AS I_M16      
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M17 ,0) END ) AS numeric) AS I_M17      
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M18 ,0) END ) AS numeric) AS I_M18      
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(M19 ,0) END ) AS numeric) AS I_M19								   		
								   			,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W0  ,0) END ) AS numeric) AS I_W0 
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W1  ,0) END ) AS numeric) AS I_W1 
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W2  ,0) END ) AS numeric) AS I_W2 
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W3  ,0) END ) AS numeric) AS I_W3 
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W4  ,0) END ) AS numeric) AS I_W4 
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W5  ,0) END ) AS numeric) AS I_W5 
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W6  ,0) END ) AS numeric) AS I_W6 
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W7  ,0) END ) AS numeric) AS I_W7 
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W8  ,0) END ) AS numeric) AS I_W8 
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W9  ,0) END ) AS numeric) AS I_W9 
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W10 ,0) END ) AS numeric) AS I_W10
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W11 ,0) END ) AS numeric) AS I_W11
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W12 ,0) END ) AS numeric) AS I_W12
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W13 ,0) END ) AS numeric) AS I_W13
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W14 ,0) END ) AS numeric) AS I_W14
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W15 ,0) END ) AS numeric) AS I_W15
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W16 ,0) END ) AS numeric) AS I_W16
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W17 ,0) END ) AS numeric) AS I_W17
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W18 ,0) END ) AS numeric) AS I_W18
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W19 ,0) END ) AS numeric) AS I_W19
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W20 ,0) END ) AS numeric) AS I_W20
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W21 ,0) END ) AS numeric) AS I_W21
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W22 ,0) END ) AS numeric) AS I_W22
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W23 ,0) END ) AS numeric) AS I_W23
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W24 ,0) END ) AS numeric) AS I_W24
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W25 ,0) END ) AS numeric) AS I_W25
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W26 ,0) END ) AS numeric) AS I_W26
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W27 ,0) END ) AS numeric) AS I_W27
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W28 ,0) END ) AS numeric) AS I_W28
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W29 ,0) END ) AS numeric) AS I_W29
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W30 ,0) END ) AS numeric) AS I_W30
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W31 ,0) END ) AS numeric) AS I_W31
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W32 ,0) END ) AS numeric) AS I_W32
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W33 ,0) END ) AS numeric) AS I_W33
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W34 ,0) END ) AS numeric) AS I_W34
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W35 ,0) END ) AS numeric) AS I_W35
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W36 ,0) END ) AS numeric) AS I_W36
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W37 ,0) END ) AS numeric) AS I_W37
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W38 ,0) END ) AS numeric) AS I_W38
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W39 ,0) END ) AS numeric) AS I_W39
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W40 ,0) END ) AS numeric) AS I_W40
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W41 ,0) END ) AS numeric) AS I_W41
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W42 ,0) END ) AS numeric) AS I_W42
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W43 ,0) END ) AS numeric) AS I_W43
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W44 ,0) END ) AS numeric) AS I_W44
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W45 ,0) END ) AS numeric) AS I_W45
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W46 ,0) END ) AS numeric) AS I_W46
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W47 ,0) END ) AS numeric) AS I_W47
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W48 ,0) END ) AS numeric) AS I_W48
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W49 ,0) END ) AS numeric) AS I_W49
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W50 ,0) END ) AS numeric) AS I_W50
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W51 ,0) END ) AS numeric) AS I_W51
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W52 ,0) END ) AS numeric) AS I_W52
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W53 ,0) END ) AS numeric) AS I_W53
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W54 ,0) END ) AS numeric) AS I_W54
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W55 ,0) END ) AS numeric) AS I_W55
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W56 ,0) END ) AS numeric) AS I_W56
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W57 ,0) END ) AS numeric) AS I_W57
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W58 ,0) END ) AS numeric) AS I_W58
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W59 ,0) END ) AS numeric) AS I_W59
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W60 ,0) END ) AS numeric) AS I_W60
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W61 ,0) END ) AS numeric) AS I_W61
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W62 ,0) END ) AS numeric) AS I_W62
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W63 ,0) END ) AS numeric) AS I_W63
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W64 ,0) END ) AS numeric) AS I_W64
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W65 ,0) END ) AS numeric) AS I_W65
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W66 ,0) END ) AS numeric) AS I_W66
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W67 ,0) END ) AS numeric) AS I_W67
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W68 ,0) END ) AS numeric) AS I_W68
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W69 ,0) END ) AS numeric) AS I_W69
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W70, 0) END ) AS numeric) AS I_W70
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W71, 0) END ) AS numeric) AS I_W71
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W72, 0) END ) AS numeric) AS I_W72
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W73, 0) END ) AS numeric) AS I_W73
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W74, 0) END ) AS numeric) AS I_W74
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W75, 0) END ) AS numeric) AS I_W75
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W76, 0) END ) AS numeric) AS I_W76
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W77, 0) END ) AS numeric) AS I_W77
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W78, 0) END ) AS numeric) AS I_W78
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W79, 0) END ) AS numeric) AS I_W79                                                                                                                    
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W80 ,0) END ) AS numeric) AS I_W80
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W81 ,0) END ) AS numeric) AS I_W81
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W82 ,0) END ) AS numeric) AS I_W82
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W83 ,0) END ) AS numeric) AS I_W83
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W84 ,0) END ) AS numeric) AS I_W84
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W85 ,0) END ) AS numeric) AS I_W85
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W86 ,0) END ) AS numeric) AS I_W86
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W87 ,0) END ) AS numeric) AS I_W87
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W88 ,0) END ) AS numeric) AS I_W88
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W89 ,0) END ) AS numeric) AS I_W89
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W90 ,0) END ) AS numeric) AS I_W90
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W91 ,0) END ) AS numeric) AS I_W91
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W92 ,0) END ) AS numeric) AS I_W92
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W93 ,0) END ) AS numeric) AS I_W93
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W94 ,0) END ) AS numeric) AS I_W94
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W95 ,0) END ) AS numeric) AS I_W95
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W96 ,0) END ) AS numeric) AS I_W96
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W97 ,0) END ) AS numeric) AS I_W97
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W98 ,0) END ) AS numeric) AS I_W98
											,CAST(SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN ISNULL(W99 ,0) END ) AS numeric) AS I_W99
                                            ,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(Y0  ,0) END ) AS numeric) AS M_Y0
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(Y1  ,0) END ) AS numeric) AS M_Y1
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(Y2  ,0) END ) AS numeric) AS M_Y2
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(Q0  ,0) END ) AS numeric) AS M_Q0
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(Q1  ,0) END ) AS numeric) AS M_Q1
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(Q2  ,0) END ) AS numeric) AS M_Q2
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(Q3  ,0) END ) AS numeric) AS M_Q3
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(Q4  ,0) END ) AS numeric) AS M_Q4
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(Q5  ,0) END ) AS numeric) AS M_Q5
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(Q6  ,0) END ) AS numeric) AS M_Q6
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M0  ,0) END ) AS numeric) AS M_M0           
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M1  ,0) END ) AS numeric) AS M_M1       
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M2  ,0) END ) AS numeric) AS M_M2       
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M3  ,0) END ) AS numeric) AS M_M3       
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M4  ,0) END ) AS numeric) AS M_M4       
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M5  ,0) END ) AS numeric) AS M_M5       
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M6  ,0) END ) AS numeric) AS M_M6       
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M7  ,0) END ) AS numeric) AS M_M7       
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M8  ,0) END ) AS numeric) AS M_M8       
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M9  ,0) END ) AS numeric) AS M_M9       
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M10 ,0) END ) AS numeric) AS M_M10      
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M11 ,0) END ) AS numeric) AS M_M11      
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M12 ,0) END ) AS numeric) AS M_M12      
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M13 ,0) END ) AS numeric) AS M_M13      
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M14 ,0) END ) AS numeric) AS M_M14      
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M15 ,0) END ) AS numeric) AS M_M15      
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M16 ,0) END ) AS numeric) AS M_M16      
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M17 ,0) END ) AS numeric) AS M_M17      
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M18 ,0) END ) AS numeric) AS M_M18      
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(M19 ,0) END ) AS numeric) AS M_M19								   		
								   			,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W0  ,0) END ) AS numeric) AS M_W0 
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W1  ,0) END ) AS numeric) AS M_W1 
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W2  ,0) END ) AS numeric) AS M_W2 
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W3  ,0) END ) AS numeric) AS M_W3 
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W4  ,0) END ) AS numeric) AS M_W4 
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W5  ,0) END ) AS numeric) AS M_W5 
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W6  ,0) END ) AS numeric) AS M_W6 
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W7  ,0) END ) AS numeric) AS M_W7 
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W8  ,0) END ) AS numeric) AS M_W8 
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W9  ,0) END ) AS numeric) AS M_W9 
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W10 ,0) END ) AS numeric) AS M_W10
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W11 ,0) END ) AS numeric) AS M_W11
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W12 ,0) END ) AS numeric) AS M_W12
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W13 ,0) END ) AS numeric) AS M_W13
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W14 ,0) END ) AS numeric) AS M_W14
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W15 ,0) END ) AS numeric) AS M_W15
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W16 ,0) END ) AS numeric) AS M_W16
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W17 ,0) END ) AS numeric) AS M_W17
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W18 ,0) END ) AS numeric) AS M_W18
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W19 ,0) END ) AS numeric) AS M_W19
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W20 ,0) END ) AS numeric) AS M_W20
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W21 ,0) END ) AS numeric) AS M_W21
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W22 ,0) END ) AS numeric) AS M_W22
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W23 ,0) END ) AS numeric) AS M_W23
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W24 ,0) END ) AS numeric) AS M_W24
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W25 ,0) END ) AS numeric) AS M_W25
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W26 ,0) END ) AS numeric) AS M_W26
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W27 ,0) END ) AS numeric) AS M_W27
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W28 ,0) END ) AS numeric) AS M_W28
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W29 ,0) END ) AS numeric) AS M_W29
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W30 ,0) END ) AS numeric) AS M_W30
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W31 ,0) END ) AS numeric) AS M_W31
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W32 ,0) END ) AS numeric) AS M_W32
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W33 ,0) END ) AS numeric) AS M_W33
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W34 ,0) END ) AS numeric) AS M_W34
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W35 ,0) END ) AS numeric) AS M_W35
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W36 ,0) END ) AS numeric) AS M_W36
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W37 ,0) END ) AS numeric) AS M_W37
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W38 ,0) END ) AS numeric) AS M_W38
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W39 ,0) END ) AS numeric) AS M_W39
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W40 ,0) END ) AS numeric) AS M_W40
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W41 ,0) END ) AS numeric) AS M_W41
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W42 ,0) END ) AS numeric) AS M_W42
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W43 ,0) END ) AS numeric) AS M_W43
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W44 ,0) END ) AS numeric) AS M_W44
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W45 ,0) END ) AS numeric) AS M_W45
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W46 ,0) END ) AS numeric) AS M_W46
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W47 ,0) END ) AS numeric) AS M_W47
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W48 ,0) END ) AS numeric) AS M_W48
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W49 ,0) END ) AS numeric) AS M_W49
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W50 ,0) END ) AS numeric) AS M_W50
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W51 ,0) END ) AS numeric) AS M_W51
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W52 ,0) END ) AS numeric) AS M_W52
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W53 ,0) END ) AS numeric) AS M_W53
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W54 ,0) END ) AS numeric) AS M_W54
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W55 ,0) END ) AS numeric) AS M_W55
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W56 ,0) END ) AS numeric) AS M_W56
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W57 ,0) END ) AS numeric) AS M_W57
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W58 ,0) END ) AS numeric) AS M_W58
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W59 ,0) END ) AS numeric) AS M_W59
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W60 ,0) END ) AS numeric) AS M_W60
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W61 ,0) END ) AS numeric) AS M_W61
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W62 ,0) END ) AS numeric) AS M_W62
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W63 ,0) END ) AS numeric) AS M_W63
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W64 ,0) END ) AS numeric) AS M_W64
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W65 ,0) END ) AS numeric) AS M_W65
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W66 ,0) END ) AS numeric) AS M_W66
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W67 ,0) END ) AS numeric) AS M_W67
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W68 ,0) END ) AS numeric) AS M_W68
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W69 ,0) END ) AS numeric) AS M_W69
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W70, 0) END ) AS numeric) AS M_W70
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W71, 0) END ) AS numeric) AS M_W71
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W72, 0) END ) AS numeric) AS M_W72
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W73, 0) END ) AS numeric) AS M_W73
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W74, 0) END ) AS numeric) AS M_W74
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W75, 0) END ) AS numeric) AS M_W75
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W76, 0) END ) AS numeric) AS M_W76
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W77, 0) END ) AS numeric) AS M_W77
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W78, 0) END ) AS numeric) AS M_W78
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W79, 0) END ) AS numeric) AS M_W79                                                                                                                    
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W80 ,0) END ) AS numeric) AS M_W80
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W81 ,0) END ) AS numeric) AS M_W81
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W82 ,0) END ) AS numeric) AS M_W82
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W83 ,0) END ) AS numeric) AS M_W83
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W84 ,0) END ) AS numeric) AS M_W84
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W85 ,0) END ) AS numeric) AS M_W85
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W86 ,0) END ) AS numeric) AS M_W86
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W87 ,0) END ) AS numeric) AS M_W87
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W88 ,0) END ) AS numeric) AS M_W88
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W89 ,0) END ) AS numeric) AS M_W89
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W90 ,0) END ) AS numeric) AS M_W90
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W91 ,0) END ) AS numeric) AS M_W91
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W92 ,0) END ) AS numeric) AS M_W92
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W93 ,0) END ) AS numeric) AS M_W93
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W94 ,0) END ) AS numeric) AS M_W94
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W95 ,0) END ) AS numeric) AS M_W95
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W96 ,0) END ) AS numeric) AS M_W96
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W97 ,0) END ) AS numeric) AS M_W97
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W98 ,0) END ) AS numeric) AS M_W98
											,CAST(SUM(CASE WHEN MEASURE = 'CHAR_AVAILABLE_MUL' THEN ISNULL(W99 ,0) END ) AS numeric) AS M_W99
								FROM SCP_ANL_SUPPLY_PSI_REPORT_ESS A
							 WHERE A.MEASURE IN ( 'MODEL_INVENTORY', 'CHAR_AVAILABLE_MUL')
			 				     AND A.DIVISION_ID = @p_division_id
								 AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
								 AND A.PLAN_TYPE = @p_plan_type
								 AND A.SEQ = @p_seq
							 GROUP BY DIVISION_ID, PLANT_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ,  
											 CELL_ITEM_ID, CELL_MODEL_NAME, SCM_SITE_ID, SCM_SITE_NAME
					      ) A
				   )

				-- LOG                  
				SET @v_log_type = N'TXN';                  
				SET @v_log_message = N'Insert SCP_ANL_SUPPLY_PSI_REPORT_ESS';                        
				SET @d_event_date = SYSDATETIME()  ;                 
				EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
											,@p_log_type      =@v_log_type                  
											,@p_log_count     =@n_log_count                   
											,@p_log_message   =@v_log_message                   
											,@p_description   =@v_description                   
											,@p_event_date    =@d_event_date                   
											,@p_user_id       =@v_batch_user                  
											;  

    -- SELECT * FROM	[SCP_ANL_SUPPLY_PSI_REPORT_ESS]

 	------------------ TOTAL ROW INSERT --------------
	 INSERT INTO [dbo].[SCP_ANL_SUPPLY_PSI_REPORT_ESS]																																					
				([DIVISION_ID], [PLANT_ID], [PLAN_START_YYYYMMDD], [PLAN_TYPE], [SEQ], [CELL_ITEM_ID], [CELL_MODEL_NAME] , [SCM_SITE_ID], [SCM_SITE_NAME]			
				,[MEASURE], [MEASURE_LABEL] ,[MEASURE_COLOR], [SORT_ORDER_NO],[LINE_ID],[LINE_NAME] ,[Y0],[Y1],[Y2],[Q0],[Q1],[Q2],[Q3],[Q4],[Q5],[Q6],[M0],[M1],[M2]          
				,[M3],[M4],[M5],[M6],[M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[W0],[W1]													
				,[W2],[W3],[W4],[W5],[W6],[W7],[W8],[W9],[W10],[W11],[W12],[W13],[W14],[W15],[W16],[W17],[W18],[W19]													
				,[W20],[W21],[W22],[W23],[W24],[W25],[W26],[W27],[W28],[W29],[W30],[W31],[W32],[W33],[W34],[W35],[W36],[W37],[W38],[W39],[W40]       
				,[W41],[W42],[W43],[W44],[W45],[W46],[W47],[W48],[W49],[W50],[W51],[W52],[W53],[W54],[W55],[W56],[W57],[W58],[W59],[W60],[W61]       
				,[W62],[W63],[W64],[W65],[W66],[W67],[W68],[W69],[W70],[W71],[W72],[W73],[W74],[W75],[W76],[W77],[W78],[W79],[W80],[W81],[W82]       
				,[W83],[W84],[W85],[W86],[W87],[W88],[W89],[W90],[W91],[W92],[W93],[W94],[W95],[W96],[W97],[W98],[W99]) 
			 (
				SELECT DIVISION_ID, PLANT_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ 
			 				, 'Total' AS CELL_ITEM_ID							       
 							, 'Total' AS CELL_MODEL_NAME             			   
 							, 'Total' AS SCM_SITE_ID             				 	   
 							, 'Total' AS SCM_SITE_NAME							       
 							, A.MEASURE                            			   
 							, A.MEASURE_LABEL            				 	   
 							, A.MEASURE_COLOR           				 	   
 							, A.SORT_ORDER_NO
							, A.LINE_ID
							, A.LINE_NAME
							,0,0,0,0,0 ,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0
							,0,0,0,0,0 ,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0
							,0,0,0,0,0 ,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0
							,0,0,0,0,0 ,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0
							,0,0,0,0,0 ,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0
							,0,0,0,0,0
					FROM SCP_ANL_SUPPLY_PSI_REPORT_ESS A
							WHERE A.DIVISION_ID = @p_division_id
								AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
								AND A.PLAN_TYPE = @p_plan_type
								AND A.SEQ = @p_seq
				GROUP BY DIVISION_ID
				              , PLANT_ID
							  , PLAN_START_YYYYMMDD
							  , PLAN_TYPE
							  , SEQ 
	 		 				  , A.CELL_ITEM_ID							       
 							  , A.CELL_MODEL_NAME             			   
 						--	  , A.SCM_SITE_ID             				 	   
 						--	  , A.SCM_SITE_NAME							       
 						      , A.MEASURE                            			   
 						      , A.MEASURE_LABEL            				 	   
 						      , A.MEASURE_COLOR  
							  , A.SORT_ORDER_NO
							  , A.LINE_ID
							  , A.LINE_NAME
			   )
			

			--- Production(Total) Row  Insert
			INSERT INTO [dbo].[SCP_ANL_SUPPLY_PSI_REPORT_ESS]																																					
				([DIVISION_ID], [PLANT_ID], [PLAN_START_YYYYMMDD], [PLAN_TYPE], [SEQ], [CELL_ITEM_ID], [CELL_MODEL_NAME] , [SCM_SITE_ID], [SCM_SITE_NAME]			
				,[MEASURE], [MEASURE_LABEL] ,[MEASURE_COLOR], [SORT_ORDER_NO],[LINE_ID],[LINE_NAME] ,[Y0],[Y1],[Y2],[Q0],[Q1],[Q2],[Q3],[Q4],[Q5],[Q6],[M0],[M1],[M2]          
				,[M3],[M4],[M5],[M6],[M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[W0],[W1]													
				,[W2],[W3],[W4],[W5],[W6],[W7],[W8],[W9],[W10],[W11],[W12],[W13],[W14],[W15],[W16],[W17],[W18],[W19]													
				,[W20],[W21],[W22],[W23],[W24],[W25],[W26],[W27],[W28],[W29],[W30],[W31],[W32],[W33],[W34],[W35],[W36],[W37],[W38],[W39],[W40]       
				,[W41],[W42],[W43],[W44],[W45],[W46],[W47],[W48],[W49],[W50],[W51],[W52],[W53],[W54],[W55],[W56],[W57],[W58],[W59],[W60],[W61]       
				,[W62],[W63],[W64],[W65],[W66],[W67],[W68],[W69],[W70],[W71],[W72],[W73],[W74],[W75],[W76],[W77],[W78],[W79],[W80],[W81],[W82]       
				,[W83],[W84],[W85],[W86],[W87],[W88],[W89],[W90],[W91],[W92],[W93],[W94],[W95],[W96],[W97],[W98],[W99]) 
			 (
				SELECT @p_division_id, 'Total' AS PLANT_ID, @p_plan_start_yyyymmdd, @p_plan_type, @p_seq 
			 				, 'Total' AS CELL_ITEM_ID							       
 							, 'Total' AS CELL_MODEL_NAME             			   
 							, 'Total' AS SCM_SITE_ID             				 	   
 							, 'Total' AS SCM_SITE_NAME							       
 							, 'PRODUCTION' AS MEASURE                            			   
 							, 'PRODUCTION(Total)' AS MEASURE_LABEL            				 	   
 							, '' AS MEASURE_COLOR           				 	   
 							, '5' AS SORT_ORDER_NO
							, '' AS LINE_ID
							, '' AS LINE_NAME
							,0,0,0,0,0 ,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0
							,0,0,0,0,0 ,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0
							,0,0,0,0,0 ,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0
							,0,0,0,0,0 ,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0
							,0,0,0,0,0 ,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0
							,0,0,0,0,0
			   )

				-- LOG                  
				SET @v_log_type = N'TXN';                  
				SET @v_log_message = N'Insert TOTAL ROW';                        
				SET @d_event_date = SYSDATETIME()  ;                 
				EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
											,@p_log_type      =@v_log_type                  
											,@p_log_count     =@n_log_count                   
											,@p_log_message   =@v_log_message                   
											,@p_description   =@v_description                   
											,@p_event_date    =@d_event_date                   
											,@p_user_id       =@v_batch_user                  
											;  


			 PRINT '-------------TOTAL ROW INSERT End'
			 print CONVERT(CHAR(23), getdate(), 21)
		END 

		--임시테이블 삭제      
		IF OBJECT_ID('tempdb..##SCM_MST_LINE') IS NOT NULL      
		DROP TABLE #SCM_MST_LINE;

		IF OBJECT_ID('tempdb..##TblDynamicPivot_SCP0074') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0074;

		IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0074_item') is not null       
			DROP TABLE #TblDynamicPivot_SCP0074_item     

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074_TEMP') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0074_TEMP

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074_NICKITEM') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCP0074_NICKITEM

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074_TEMP1') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0074_TEMP1;

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074_LAST') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0074_LAST;

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074_RANK') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCP0074_RANK

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074_MEASURE') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCP0074_MEASURE

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074_MODELNAME') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0074_MODELNAME;

		IF OBJECT_ID('tempdb..#SCM_MST_SITE') IS NOT NULL      
		DROP TABLE #SCM_MST_SITE;
	
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0074_INVENTORY') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_INVENTORY;

		END
	END TRY


	BEGIN CATCH                  
		--  IF @@TRANCOUNT > 0                  
		--    BEGIN                  
		--      ROLLBACK                   
		--END;                  
                        
		  -- ERROR LOG                  
		  SET @v_log_type = N'ERROR';                  
		  SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                  
		  SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());                  
		  SET @d_event_date = SYSDATETIME();                  
		  EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
									,@p_log_type      =@v_log_type                  
									,@p_log_count     =@n_log_count                   
									,@p_log_message   =@v_log_message                   
									,@p_description   =@v_description                   
									,@p_event_date    =@d_event_date                   
									,@p_user_id       =@v_batch_user                  
									;                  
		   --      PRINT @@ERROR                  
		  return -1                  
	END CATCH;   

		-- 종료 LOG                  
		SET @v_log_type = N'END';                  
		SET @v_log_message = N'PR_SCP_ANL_SUPPLY_PSI_BY_MODEL_82 END of procedure ';                  
		SET @v_description = N'['  + @v_exec_time + ']';             
		SET @d_event_date = SYSDATETIME()  ;                 
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
								  ,@p_log_type      =@v_log_type                  
								  ,@p_log_count     =@n_log_count                   
								  ,@p_log_message   =@v_log_message                   
								  ,@p_description   =@v_description                   
								  ,@p_event_date    =@d_event_date                   
								  ,@p_user_id       =@v_batch_user                  
								  ;                  
		return 1                
                  
		_RETURN_ERR_CODE:                  
			BEGIN                  
				 RETURN -1                  
			END;                  
                  
  END;  
