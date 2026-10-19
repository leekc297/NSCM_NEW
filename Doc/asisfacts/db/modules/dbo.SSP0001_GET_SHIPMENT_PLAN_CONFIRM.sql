/*
 * Program ID   : SSP0001_GET_SHIPMENT_PLAN_CONFIRM
 * Description  : Shipment Plan Confrim
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/10   byunghunjung   IInitial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/06/01   ygkim		   ship_frozen 컬럼 추가
 * 2018/06/04   ygkim		   seq 컬럼 추가
 * 2018/08/30   ygkim		   Division 'EE' 추가에 따른 쿼리 수정
 ex)
EXEC SSP0001_GET_SHIPMENT_PLAN_CONFIRM @p_division_id='40,81,82', @p_from_site='', @p_item_id='', @p_plan_start_yyyymmdd='20180515', @p_plan_type='', @p_from_yyyymmdd='20180515', @p_to_yyyymmdd='20180617', @p_user_id='addio777', @p_program_id='SSP0001', @p_sheet_name='Shipment Plan Confirm', @debug_mode='T'
 */
CREATE PROCEDURE [dbo].[SSP0001_GET_SHIPMENT_PLAN_CONFIRM]
	 @p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd  NVARCHAR(8)
	,@p_plan_type			NVARCHAR(50)
	,@p_from_yyyymmdd		NVARCHAR(MAX)
	,@p_to_yyyymmdd			NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_program_id			NVARCHAR(MAX) = 'SSP0001' 
	,@p_sheet_name			NVARCHAR(MAX) = 'Shipment Plan Confirm'
	,@debug_mode			NVARCHAR(1)='F'

AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_data_cnt NVARCHAR(8);
	SET @v_data_cnt =0;
	
	DECLARE @v_cnt_usr_measure	INT =0;

	SET @v_cnt_usr_measure = (
								SELECT COUNT(*) 
								FROM scm_mst_titleset_user   with(nolock)
								WHERE 1=1
								 AND program_id  =  @p_program_id
								 AND sheet_name  =  @p_sheet_name 
								 AND user_id     =  @p_user_id
							  )



   /********************************************************************************
	* 임시테이블만들기
	********************************************************************************/	
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0001_1') IS NOT NULL
		   DROP TABLE #TblDynamicPivot_SSP0001_1 

    create table #TblDynamicPivot_SSP0001_1(
		 division_id NVARCHAR(60)
		,plan_start_yyyymmdd NVARCHAR(8)
		,plan_type NVARCHAR(50)
		,from_site NVARCHAR(30)
		,item_id NVARCHAR(50)
		,ship_frozen int
		,seq int
		,nick_name NVARCHAR(100)
		,measure NVARCHAR(100)
		,measure_name NVARCHAR(2000)
		,user_sort_order_no NUMERIC
		,from_yyyymmdd NVARCHAR(8)
		,to_yyyymmdd NVARCHAR(8)
		,yyyymmdd NVARCHAR(10)		
		,qty NUMERIC

	);

   /********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/
	DECLARE @mDQry NVARCHAR(MAX)='';
	
	DECLARE  @v_division_id NVARCHAR(MAX)='';
	DECLARE  @v_from_site NVARCHAR(MAX)='';
	DECLARE  @v_item_id NVARCHAR(MAX)='';
	
	--IN 조건으로 데이터를 가져옴
	SET @v_division_id = [dbo].FN_GET_IN_STR(@p_division_id);
	SET @v_from_site = [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);

	SET @mDQry = @mDQry + ' INSERT INTO #TblDynamicPivot_SSP0001_1	                          ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' SELECT m.division_id	                          ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 		  ,m.plan_start_yyyymmdd                  ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 		  ,m.plan_type                            ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 		  ,m.from_site                            ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 		  ,m.item_id                              ' + char(10) ;  
	SET @mDQry = @mDQry + ' 		  ,m.ship_frozen                          ' + char(10) ;  
	SET @mDQry = @mDQry + ' 		  ,m.seq		                          ' + char(10) ; 
	SET @mDQry = @mDQry + ' 		  ,m.nick_name                            ' + char(10) ;                                                                                                                                               
	SET @mDQry = @mDQry + ' 		  ,m.measure                              ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 		  ,m.measure_name                         ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 		  ,m.user_sort_order_no                   ' + char(10) ;  	                                                                                                                                                                                                                                                                                           
	SET @mDQry = @mDQry + ' 		  ,'''+@p_from_yyyymmdd +''' as from_yyyymmdd      ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 		  ,'''+@p_to_yyyymmdd   +'''  as to_yyyymmdd          ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 		  ,''D_'' + m.yyyymmdd as yyyymmdd        ' + char(10) ;                                                                                                                                                    
	SET @mDQry = @mDQry + ' 		  ,n.qty                                  ' + char(10) ;
	--SET @mDQry = @mDQry + '     INTO  #TblDynamicPivot_SSP0001_1                ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 	FROM (                                        ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 		SELECT                                    ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 			  c.division_id			              ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 			 ,c.plan_start_yyyymmdd               ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 			 ,c.plan_type                         ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 			 ,c.from_site			              ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 			 ,c.item_id			                  ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 			 ,a.column_name	AS measure	          ' + char(10) ;                                                                                                                                                  
	SET @mDQry = @mDQry + ' 			 ,a.COLUMN_LABEL_NAME AS measure_name ' + char(10) ;                                                                                                                                               
	SET @mDQry = @mDQry + ' 			 ,c.yyyymmdd                          ' + char(10) ; 
	SET @mDQry = @mDQry + ' 			 ,c.ship_frozen                       ' + char(10) ;    
	SET @mDQry = @mDQry + ' 			 ,c.seq			                      ' + char(10) ;      
	SET @mDQry = @mDQry + ' 			 ,c.nick_name	                      ' + char(10) ;                                                                                                                                              
	SET @mDQry = @mDQry + ' 			 ,isnull(b.sort_order_no,a.sort_order_no ) AS user_sort_order_no	    ' + char(10);                                                                                                             
	SET @mDQry = @mDQry + ' 		FROM scm_mst_sheet_measure a with(nolock) LEFT OUTER JOIN                   ' + char(10);                                                                                                             
	SET @mDQry = @mDQry + ' 			 scm_mst_titleset_user b with(nolock) ON b.program_id  = a.program_id   ' + char(10);                                                                                                             
	SET @mDQry = @mDQry + ' 					                AND b.sheet_name  = a.sheet_name                ' + char(10);                                                                                                             
	SET @mDQry = @mDQry + ' 									AND b.column_name = a.column_name               ' + char(10);                                                                                                             
	SET @mDQry = @mDQry + ' 									AND b.user_id     = '''+@p_user_id+'''  ' + char(10);                                                                                                             
	SET @mDQry = @mDQry + ' 			, ( SELECT                                                              ' + char(10);                                                                                                             
	SET @mDQry = @mDQry + ' 					   p.DIVISION_ID 			                                    ' + char(10);                                                                                                             
	SET @mDQry = @mDQry + ' 					  ,p.PLAN_START_YYYYMMDD		                                ' + char(10);                                                                                                             
	SET @mDQry = @mDQry + ' 					  ,p.PLAN_TYPE                                                  ' + char(10);                                                                                                             
	SET @mDQry = @mDQry + ' 					  ,p.FROM_SITE				                                    ' + char(10);                                                                                                             
	SET @mDQry = @mDQry + ' 					  ,p.ITEM_ID				                                    ' + char(10);                                                                                                             
	SET @mDQry = @mDQry + ' 					  ,p.YYYYMMDD                                                   ' + char(10);    
	SET @mDQry = @mDQry + ' 					  ,s.SHIP_FROZEN                                                ' + char(10); 
	SET @mDQry = @mDQry + ' 					  ,p.SEQ		                                                ' + char(10); 
	--SET @mDQry = @mDQry + ' 					  ,dbo.fn_get_item_nickname( p.division_id, p.item_id ) AS nick_name      ' + char(10);                                                                                                            
	SET @mDQry = @mDQry + ' 					  ,dbo.fn_get_item_nickname( (case when p.division_id = ''EE'' then p.origin_from_division_id else p.division_id end) , p.item_id ) AS nick_name      ' + char(10);                                                                                                            
	SET @mDQry = @mDQry + ' 				FROM SSP_ANL_SHIP_PLAN P with(nolock)                               ' + char(10);  
	SET @mDQry = @mDQry + ' 				LEFT OUTER JOIN SCM_MST_SITE S WITH(NOLOCK) ON (CASE WHEN P.DIVISION_ID = ''EE'' THEN P.ORIGIN_FROM_DIVISION_ID ELSE P.DIVISION_ID END) = S.DIVISION_ID AND P.FROM_SITE = S.SCM_SITE_ID AND S.VALID_YN = ''Y''    ' + char(10);    
	--SET @mDQry = @mDQry + ' 				LEFT OUTER JOIN SCM_MST_SITE S WITH(NOLOCK) ON (CASE WHEN P.DIVISION_ID = ''EE'' THEN ELSE P.DIVISION_ID END) = S.DIVISION_ID AND P.FROM_SITE = S.SCM_SITE_ID AND S.VALID_YN = ''Y''    ' + char(10);    
	SET @mDQry = @mDQry + ' 				WHERE 1=1                                                           ' + char(10);                                                                                                             
	SET @mDQry = @mDQry + ' 					AND yyyymmdd    >= '''+@p_from_yyyymmdd +'''                            ' + char(10);                                                                                                             
	SET @mDQry = @mDQry + ' 					AND yyyymmdd    <= '''+@p_to_yyyymmdd + '''                              ' + char(10);                                                                                                             
	SET @mDQry = @mDQry + ' 					--AND division_id  = @p_division_id                             ' + char(10);                                                                                                             
	IF ( @v_division_id IS NOT NULL AND @v_division_id    != '') SET @mDQry = @mDQry + ' 					AND  p.division_id   IN ('+ @v_division_id +')'+char(10);                     
	IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mDQry = @mDQry + ' 					AND  p.from_site     IN ('+ @v_from_site   +')'+char(10);                     
	IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mDQry = @mDQry + ' 					AND  p.item_id       IN ('+ @v_item_id     +')'+char(10);                     
	IF ( @p_plan_start_yyyymmdd   IS NOT NULL AND @p_plan_start_yyyymmdd    != '') SET @mDQry = @mDQry + ' 					AND  PLAN_START_YYYYMMDD = '''+@p_plan_start_yyyymmdd +''''+char(10);                   
	IF ( @p_plan_type   IS NOT NULL AND @p_plan_type    != '') SET @mDQry = @mDQry + ' 				    AND  p.PLAN_TYPE           = '''+@p_plan_type   +''''+char(10);                   
	SET @mDQry = @mDQry + ' 					AND EXISTS (SELECT 1                                                                                                                                        '+char(10);                 
	SET @mDQry = @mDQry + ' 								FROM(                                                                                                                                           '+char(10);                 
	SET @mDQry = @mDQry + ' 									SELECT division_id,MAX(PLAN_SEQ) PLAN_SEQ                                                      '+char(10);                 
	SET @mDQry = @mDQry + ' 									FROM   SSP_PLAN_VERSION_V with(nolock)                                                                                                      '+char(10);                 
	SET @mDQry = @mDQry + ' 									WHERE  PLAN_TYPE    = ''SP''                                                                                                                '+char(10);                   
	--SET @mDQry = @mDQry + ' 									AND    ( ( @p_division_id IS NULL OR @p_division_id ='''')  OR division_id   IN (SELECT token FROM dbo.String_Split(@p_division_id,'','')) )'+char(10); 
   IF ( @v_division_id IS NOT NULL AND @v_division_id !='') SET @mDQry = @mDQry + ' 									AND  division_id   IN ('+ @v_division_id +')'+char(10);                     	                    
	SET @mDQry = @mDQry + ' 									AND    CONFIRM_FLAG = ''Y''                                       '+char(10); 
	SET @mDQry = @mDQry + ' 									AND    PLAN_START_YYYYMMDD = '''+@p_plan_start_yyyymmdd +'''      '+char(10); 							                                                                                            
	--SET @mDQry = @mDQry + ' 									AND    PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD)     '+char(10);                                                                                           
	--SET @mDQry = @mDQry + ' 														FROM SSP_PLAN_VERSION_V T with(nolock)        '+char(10);                                                                                           
	--SET @mDQry = @mDQry + ' 														WHERE 1=1'+char(10);
	----SET @mDQry = @mDQry + ' 														WHERE ( ( @p_division_id IS NULL OR @p_division_id ='''')  OR t.division_id   IN (SELECT token FROM dbo.String_Split(@p_division_id,'','')) )'+char(10);
	--IF ( @v_division_id IS NOT NULL AND @v_division_id !='' ) SET @mDQry = @mDQry + ' 														AND  t.division_id   IN ('+ @v_division_id +')'+char(10);                     	                    
	--SET @mDQry = @mDQry + ' 														AND   T.plan_type  = ''SP''        '+char(10);                                                                                                        
	--SET @mDQry = @mDQry + ' 														AND   T.CONFIRM_FLAG = ''Y'')      '+char(10);                                                                                                        
	SET @mDQry = @mDQry + ' 									group by division_id                                   '+char(10);                                                                                                      
	SET @mDQry = @mDQry + ' 								) E WHERE E.DIVISION_ID = P.DIVISION_ID AND E.PLAN_SEQ = P.SEQ )  '+char(10);                                             
	SET @mDQry = @mDQry + ' 				GROUP BY   p.DIVISION_ID ,p.origin_from_division_id, p.PLAN_START_YYYYMMDD, p.PLAN_TYPE, p.FROM_SITE, p.ITEM_ID, p.YYYYMMDD, s.SHIP_FROZEN, p.SEQ           '+char(10);                                             
	SET @mDQry = @mDQry + ' 			  ) c                                                              ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + '                                                                                ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 			WHERE 1=1                                                          ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 			  AND a.program_id       =  '''+@p_program_id  +'''                        ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 			  AND a.sheet_name       =  '''+@p_sheet_name  +'''                        ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 			  AND a.valid_yn		 =	''Y''                                  ' + char(10) ;                                                                                                                   
	SET @mDQry = @mDQry + ' 			  AND ('+convert(varchar,@v_cnt_usr_measure)+' = 0                                      ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 						OR EXISTS (SELECT 1                                    ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 									 FROM scm_mst_titleset_user with(nolock)   ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 									WHERE program_id  = '''+@p_program_id+'''          ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 									  AND sheet_name  = '''+@p_sheet_name+'''          ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 									  AND user_id     = '''+@p_user_id   +'''          ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 									  AND column_name = a.column_name)         ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 				                  )                                            ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 		) m LEFT HASH JOIN                                                    ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 		 (SELECT p.DIVISION_ID                                                 ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 				,p.PLAN_START_YYYYMMDD                                         ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 				,p.PLAN_TYPE                                                   ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 				,p.FROM_SITE	                                               ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 				,p.ITEM_ID                                                     ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 				,p.YYYYMMDD                                                    ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 				,p.measure		                                               ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 				,sum(p.qty) as qty                                             ' + char(10) ;                                                                                                                 
    SET @mDQry = @mDQry + ' 				,max(p.seq) as seq                                             ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 			FROM SSP_ANL_SHIP_PLAN P with(nolock)                              ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 			WHERE 1=1                                                          ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 			AND yyyymmdd    >= '''+@p_from_yyyymmdd +'''                               ' + char(10) ;                                                                                                                 
	SET @mDQry = @mDQry + ' 			AND yyyymmdd    <= '''+@p_to_yyyymmdd   +'''                               ' + char(10) ;                                                                                                                 
	IF ( @v_division_id IS NOT NULL AND @v_division_id !='') SET @mDQry = @mDQry + ' 					AND  division_id   IN ('+ @v_division_id +')'+char(10);                     
	IF ( @v_from_site   IS NOT NULL AND @v_from_site !='') SET @mDQry = @mDQry + ' 					AND  from_site     IN ('+ @v_from_site   +')'+char(10);                     
	IF ( @v_item_id     IS NOT NULL AND @v_item_id !='') SET @mDQry = @mDQry + ' 					AND  item_id       IN ('+ @v_item_id     +')'+char(10);                     
	IF ( @p_plan_start_yyyymmdd   IS NOT NULL AND @p_plan_start_yyyymmdd !='') SET @mDQry = @mDQry + ' 					AND  PLAN_START_YYYYMMDD = '''+@p_plan_start_yyyymmdd +''''+char(10);                   
	IF ( @p_plan_type   IS NOT NULL AND @p_plan_type !='') SET @mDQry = @mDQry + ' 				    AND  PLAN_TYPE           = '''+@p_plan_type   +''''+char(10);                   

	SET @mDQry = @mDQry + ' 			AND EXISTS (SELECT 1                                                                                                                                    '+ char(10);                             
	SET @mDQry = @mDQry + ' 								FROM(                                                                                                                               '+ char(10);                             
	SET @mDQry = @mDQry + ' 									SELECT division_id,MAX(PLAN_SEQ) PLAN_SEQ                                          '+ char(10);                             
	SET @mDQry = @mDQry + ' 									FROM   SSP_PLAN_VERSION_V with(nolock)                                                                                          '+ char(10);                             
	SET @mDQry = @mDQry + ' 									WHERE  PLAN_TYPE    = ''SP''                                                                                                    '+ char(10);                               
	--SET @mDQry = @mDQry + ' 									AND    ( ( @p_division_id IS NULL OR @p_division_id ='''')  OR division_id   IN (SELECT token FROM dbo.String_Split(@p_division_id,'','')) ) '+ char(10);                                                   
	IF ( @v_division_id IS NOT NULL AND @v_division_id !='') SET @mDQry = @mDQry + ' 									AND  division_id   IN ('+ @v_division_id +')'+char(10);                     	                    
	SET @mDQry = @mDQry + ' 									AND    CONFIRM_FLAG = ''Y''   '+ char(10);                           
	SET @mDQry = @mDQry + ' 									AND    PLAN_START_YYYYMMDD = '''+@p_plan_start_yyyymmdd +'''      '+char(10);                                                                                                                                     
	--SET @mDQry = @mDQry + ' 									AND    PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD)    '+ char(10);                                                                                                                           
	--SET @mDQry = @mDQry + ' 														FROM SSP_PLAN_VERSION_V T with(nolock)       '+ char(10);                                                                                                                           
	--SET @mDQry = @mDQry + ' 														WHERE 1=1 '+ char(10);                               
	----SET @mDQry = @mDQry + ' 														WHERE ( ( @p_division_id IS NULL OR @p_division_id ='''')  OR t.division_id   IN (SELECT token FROM dbo.String_Split(@p_division_id,'','')) ) '+ char(10);                               
	--IF ( @v_division_id IS NOT NULL AND @v_division_id !='') SET @mDQry = @mDQry + ' 									AND  t.division_id   IN ('+ @v_division_id +')'+char(10);                     	                    
	--SET @mDQry = @mDQry + ' 														AND   T.plan_type  = ''SP''      '+ char(10);                                                                                                                                         
	--SET @mDQry = @mDQry + ' 														AND   T.CONFIRM_FLAG = ''Y'')    '+ char(10);                                                                                                                                         
	SET @mDQry = @mDQry + ' 									group by division_id                                 '+ char(10);                                                                                                                                       
	SET @mDQry = @mDQry + ' 								) E WHERE E.DIVISION_ID = P.DIVISION_ID AND E.PLAN_SEQ = P.SEQ ) '+ char(10);                                                                             
	SET @mDQry = @mDQry + ' 			GROUP BY  p.division_id , p.plan_start_yyyymmdd, p.plan_type, p.from_site, p.item_id, p.yyyymmdd, p.measure                            '+ char(10);                                                                             
	SET @mDQry = @mDQry + ' 		) n ON  m.division_id         = n.division_id          ' +char(10);                                                                                                                                  
	SET @mDQry = @mDQry + ' 			AND m.plan_start_yyyymmdd = n.plan_start_yyyymmdd  ' +char(10);                                                                                                                                  
	SET @mDQry = @mDQry + ' 			AND m.plan_type           = n.plan_type            ' +char(10);                                                                                                                                  
	SET @mDQry = @mDQry + ' 			AND m.from_site           = n.from_site            ' +char(10);                                                                                                                                  
	SET @mDQry = @mDQry + ' 			AND m.item_id             = n.item_id              ' +char(10);                                                                                                                                  
	SET @mDQry = @mDQry + ' 			AND m.yyyymmdd            = n.yyyymmdd             ' +char(10);                                                                                                                                  
	SET @mDQry = @mDQry + ' 			AND m.measure             = n.measure              ' +char(10);                                                                                                                                  
    SET @mDQry = @mDQry + ' 			AND m.seq                 = n.seq                  ' +char(10);                                                                                                                                  	
	SET @mDQry = @mDQry + ' 		WHERE 1=1                                              ' +char(10);                                                                                                                                  

	
	EXEC (@mDQry);
	--select @mDQry;
	IF( @debug_mode ='T')
	BEGIN				
		DECLARE @POS INT =1;
		DECLARE @LEN INT =LEN(@mDQry);
		WHILE @POS <= @LEN
			BEGIN
				PRINT SUBSTRING(@mDQry,@POS,4000);
				SET @POS = @POS+4000;
			END;
	END;

	
	--return;
	
	-----------------------------------------------------------
	/********************************************************************************
	* PIVOIT처리
	********************************************************************************/		
	BEGIN
		DECLARE @mQuery NVARCHAR(MAX);
		DECLARE @mEXEC NVARCHAR(MAX);

			-- PIVOIT 대상 날짜문자열 생성
		SET @mQuery = '';
		SELECT @mQuery = @mQuery + '[' + yyyymmdd + '], '
		FROM ( 
			SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd        
				, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a with(nolock)
			WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date

			UNION ALL

			SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
					,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a with(nolock)
				WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.month_name		

			UNION ALL

			SELECT 'D_'+a.basis_yyyymmdd   AS yyyymmdd      
					, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a with(nolock)
				WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymmdd		
				  	
		) AS A
		ORDER BY sort_order_no  ;

		IF( LEN(@mQuery)>0)
			SET @mQuery = LEFT(@mQuery, LEN(@mQuery) - 1);

			SET @mEXEC = '';
			SET @mEXEC = @mEXEC+'      SELECT  ' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			 division_id ' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,from_site		' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,plan_start_yyyymmdd		' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,plan_type		' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,isnull(dbo.fn_get_scm_site_description(division_id, from_site ),''-'') AS from_site_description		' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,item_id	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,ISNULL(ship_frozen,0)	ship_frozen' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,seq	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,case when nick_name is null or nick_name = '''' then ''-'' else nick_name end nick_name	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,measure	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,measure_name	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,user_sort_order_no	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,from_yyyymmdd	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,to_yyyymmdd	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,'+@mQuery	 +CHAR(10);
			SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SSP0001_1 ' +CHAR(10);
			SET @mEXEC = @mEXEC+'       PIVOT ( ' +CHAR(10);
			SET @mEXEC = @mEXEC+'               SUM(qty) FOR  yyyymmdd IN ('+ @mQuery +') ' +CHAR(10);
			SET @mEXEC = @mEXEC+'             ) AS A'   +CHAR(10);
			SET @mEXEC = @mEXEC+'	   ORDER BY division_id, from_site,item_id, user_sort_order_no' +CHAR(10);
			
			EXEC (@mEXEC);

			--임시테이블 삭제
			IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0001_1') IS NOT NULL
		   DROP TABLE #TblDynamicPivot_SSP0001_1 

	end



END
