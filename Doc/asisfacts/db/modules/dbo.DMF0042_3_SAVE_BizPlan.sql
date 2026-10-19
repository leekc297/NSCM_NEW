
/*
 * Program ID   : DMF0042_3_SAVE_BizPlan
 * Description  : DMF0042_3_BizPlan(사업계획 화면)의 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/08/26	ilovu1			Initial Release 사업계획 프로젝트
 */
CREATE procedure [dbo].[DMF0042_3_SAVE_BizPlan]
	  @p_SAVE_FLAG						nvarchar(max) --저장구분(I:Insert, M: Modify)
    , @p_DIVISION_ID                    nvarchar(max) --사업부ID                                                                                   
    , @p_DEPT_ID                        nvarchar(max) --팀ID                                                                                  
    , @p_PROJECT_CODE                   nvarchar(max) --Project Code                                                                              
    , @p_SCM_SITE_ID                    nvarchar(max) --SCM사이트ID                                                                                
    , @p_ITEM_ID                        nvarchar(max) --Model Code                                                                           
    , @p_END_CUSTOMER                   nvarchar(max) --End User Code                                                                             
    , @p_BIZ_TYPE                       nvarchar(max) --모델구분(셀/팩/모듈)                                                                        
    , @p_PLANT_SITE_ID                  nvarchar(max) --Plant Site                                                                                 
    , @p_FCST_TYPE                      nvarchar(max) --FCST_TYPE                                                                              
    , @p_DOM_EXP                        nvarchar(max) --내수/수출                                                                               
    , @p_INCOTERMS                      nvarchar(max) --출하조건                                                                                  
    , @p_ITEM_USE                       nvarchar(max) --ITEM_USE                                                                              
    , @p_UNIT_ENERGY                    nvarchar(max) --UNIT_ENERGY                                                                              
    , @p_CURRENCY                       nvarchar(max) --CURRENCY                                                                              
    , @p_MEASURE                        nvarchar(max) --Measure                                                                              
    , @p_YYYYMM                         nvarchar(max) --사업계획수립연월                                                                          
    , @p_QTY                            nvarchar(max) --수량                                                                               
    , @p_PROJECT_NAME                   nvarchar(max) --Project Name                                                                              
    , @p_CELL_PROD_SITE                 nvarchar(max) --CELL_PROD_SITE                                                                              
    , @p_EE_CORP_ID                     nvarchar(max) --전극 생산 법인                                                                               
    , @p_CELL_CORP_ID                   nvarchar(max) --Cell 생산 법인                                                                               
    , @p_PACK_CORP_ID                   nvarchar(max) --Pack 생산 법인                                                                               
    , @p_EXT_INT                        nvarchar(max) --외주여부(External/Internal)                                                             
    , @p_PRODUCT_GROUP                  nvarchar(max) --제품군                                                                                       
    , @p_ALT_SIM_YN                     nvarchar(max) --대체/유사모델 여부                                                                            
    , @p_CELL_CODE                      nvarchar(max) --Cell Code                                                                              
    , @p_CELL_PER_MODULE                nvarchar(max) --Cell/Module 환산자                                                                             
    , @p_MODULE_PER_PACK                nvarchar(max) --Module/Pack 환산자                                                                             
    , @p_CELL_PER_PACK                  nvarchar(max) --Cell/Pack 환산자                                                                             
    , @p_PERIOD_YYMM                    nvarchar(6)	  --계획기준년월                                                                                  
    --, @p_SCENARIO_TYPE                  nvarchar(4)	  --시나리오 유형 "BP" 사업계획 고정                                                                     
    --, @p_BASE_PRICE                     nvarchar(max) --기준판가                                                                                   
    --, @p_METAL_LINK_PRICE               nvarchar(max) --메탈연동판가                                                                                       
    --, @p_METAL_LINK_YN                  nvarchar(max) --메틸판가연동 여부                                                                                
    --, @p_WORK_YYYYMMDD                  nvarchar(max) --작업년월일(CUTOFF_YYYYMMDD 동일)                                                                 
    , @p_OSP_YN                         nvarchar(max) --OSP Flag 

	, @p_START_STND_YM                  nvarchar(max) --시작 기준연월
	, @p_END_STND_YM                    nvarchar(max) --종료 기준연월
	, @p_CREATED_BY						nvarchar(max) --생성자
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;	

	---------------------------------------------------------------------------------------------------------
	-- LOG 용 변수 설정
	---------------------------------------------------------------------------------------------------------
    declare @v_program_name		nvarchar(150) = 'DMF0042_3_SAVE_BizPlan';
    declare @v_log_type			nvarchar(30); -- START/END/ERROR/...
    declare @n_log_count		integer = 0;
    declare @v_log_message		nvarchar(1000);
    declare @v_description		nvarchar(500);
    declare @v_event_date		datetime;
	---------------------------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------------------------
	-- 시작 LOG
	---------------------------------------------------------------------------------------------------------
	set @v_log_type		= 'START';
	set @n_log_count	= 0;
	set @v_log_message	= '########## Start of procedure ##########';
	set @v_description	= '';
	set @v_event_date	= sysdatetime();
	exec PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @v_event_date;
	---------------------------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------------------------
	-- 파라미터 값을 파싱하여 임시테이블에 저장
	---------------------------------------------------------------------------------------------------------
	declare @v_delimiter nvarchar(1) = '^';		--파람미터 값 구분자
	select nr as SEQ, token into #SAVE_FLAG	       from dbo.String_Split(@p_SAVE_FLAG		 , @v_delimiter);--저장구분(I:Insert, M: Modify, D: Delete)
	select nr as SEQ, token into #DIVISION_ID      from dbo.String_Split(@p_DIVISION_ID      , @v_delimiter);--사업부ID                        
	select nr as SEQ, token into #DEPT_ID          from dbo.String_Split(@p_DEPT_ID          , @v_delimiter);--팀ID                            
	select nr as SEQ, token into #PROJECT_CODE     from dbo.String_Split(@p_PROJECT_CODE     , @v_delimiter);--Project Code                    
	select nr as SEQ, token into #SCM_SITE_ID      from dbo.String_Split(@p_SCM_SITE_ID      , @v_delimiter);--SCM사이트ID                     
	select nr as SEQ, token into #ITEM_ID          from dbo.String_Split(@p_ITEM_ID          , @v_delimiter);--Model Code                      
	select nr as SEQ, token into #END_CUSTOMER     from dbo.String_Split(@p_END_CUSTOMER     , @v_delimiter);--End User Code                   
	select nr as SEQ, token into #BIZ_TYPE         from dbo.String_Split(@p_BIZ_TYPE         , @v_delimiter);--모델구분(셀/팩/모듈)            
	select nr as SEQ, token into #PLANT_SITE_ID    from dbo.String_Split(@p_PLANT_SITE_ID    , @v_delimiter);--Plant Site                      
	select nr as SEQ, token into #FCST_TYPE        from dbo.String_Split(@p_FCST_TYPE        , @v_delimiter);--FCST_TYPE                       
	select nr as SEQ, token into #DOM_EXP          from dbo.String_Split(@p_DOM_EXP          , @v_delimiter);--내수/수출                       
	select nr as SEQ, token into #INCOTERMS        from dbo.String_Split(@p_INCOTERMS        , @v_delimiter);--출하조건                        
	select nr as SEQ, token into #ITEM_USE         from dbo.String_Split(@p_ITEM_USE         , @v_delimiter);--ITEM_USE                        
	select nr as SEQ, token into #UNIT_ENERGY      from dbo.String_Split(@p_UNIT_ENERGY      , @v_delimiter);--UNIT_ENERGY                     
	select nr as SEQ, token into #CURRENCY         from dbo.String_Split(@p_CURRENCY         , @v_delimiter);--CURRENCY                        
	select nr as SEQ, token into #MEASURE          from dbo.String_Split(@p_MEASURE          , @v_delimiter);--Measure                         
	select nr as SEQ, token into #YYYYMM           from dbo.String_Split(@p_YYYYMM           , @v_delimiter);--사업계획수립연월                
	select nr as SEQ, token into #QTY              from dbo.String_Split(@p_QTY              , @v_delimiter);--수량                            
	select nr as SEQ, token into #PROJECT_NAME     from dbo.String_Split(@p_PROJECT_NAME     , @v_delimiter);--Project Name                    
	select nr as SEQ, token into #CELL_PROD_SITE   from dbo.String_Split(@p_CELL_PROD_SITE   , @v_delimiter);--CELL_PROD_SITE                  
	select nr as SEQ, token into #EE_CORP_ID       from dbo.String_Split(@p_EE_CORP_ID       , @v_delimiter);--전극 생산 법인                  
	select nr as SEQ, token into #CELL_CORP_ID     from dbo.String_Split(@p_CELL_CORP_ID     , @v_delimiter);--Cell 생산 법인                  
	select nr as SEQ, token into #PACK_CORP_ID     from dbo.String_Split(@p_PACK_CORP_ID     , @v_delimiter);--Pack 생산 법인                  
	select nr as SEQ, token into #EXT_INT          from dbo.String_Split(@p_EXT_INT          , @v_delimiter);--외주여부(External/Internal)     
	select nr as SEQ, token into #PRODUCT_GROUP    from dbo.String_Split(@p_PRODUCT_GROUP    , @v_delimiter);--제품군                          
	select nr as SEQ, token into #ALT_SIM_YN       from dbo.String_Split(@p_ALT_SIM_YN       , @v_delimiter);--대체/유사모델 여부              
	select nr as SEQ, token into #CELL_CODE        from dbo.String_Split(@p_CELL_CODE        , @v_delimiter);--Cell Code                       
	select nr as SEQ, token into #CELL_PER_MODULE  from dbo.String_Split(@p_CELL_PER_MODULE  , @v_delimiter);--Cell/Module 환산자              
	select nr as SEQ, token into #MODULE_PER_PACK  from dbo.String_Split(@p_MODULE_PER_PACK  , @v_delimiter);--Module/Pack 환산자              
	select nr as SEQ, token into #CELL_PER_PACK    from dbo.String_Split(@p_CELL_PER_PACK    , @v_delimiter);--Cell/Pack 환산자                
	select nr as SEQ, token into #PERIOD_YYMM      from dbo.String_Split(@p_PERIOD_YYMM      , @v_delimiter);--계획기준년월                    
	--select nr as SEQ, token into #SCENARIO_TYPE    from dbo.String_Split(@p_SCENARIO_TYPE    , @v_delimiter);--시나리오 유형 "BP" 사업계획 고정
	--select nr as SEQ, token into #BASE_PRICE       from dbo.String_Split(@p_BASE_PRICE       , @v_delimiter);--기준판가                        
	--select nr as SEQ, token into #METAL_LINK_PRICE from dbo.String_Split(@p_METAL_LINK_PRICE , @v_delimiter);--메탈연동판가                    
	--select nr as SEQ, token into #METAL_LINK_YN    from dbo.String_Split(@p_METAL_LINK_YN    , @v_delimiter);--메틸판가연동 여부               
	--select nr as SEQ, token into #WORK_YYYYMMDD    from dbo.String_Split(@p_WORK_YYYYMMDD    , @v_delimiter);--작업년월일(CUTOFF_YYYYMMDD 동일)
	select nr as SEQ, token into #OSP_YN           from dbo.String_Split(@p_OSP_YN           , @v_delimiter);--OSP Flag 
	---------------------------------------------------------------------------------------------------------

	begin try
        select SAVE_FLAG.SEQ                            						 --순번
             , case when SAVE_FLAG.token        <> '' then SAVE_FLAG.token                    else null end as SAVE_FLAG              --저장구분(I:Insert, M: Modify)                     
             , case when DIVISION_ID.token      <> '' then  DIVISION_ID.token                 else null end as DIVISION_ID            --사업부ID                                                                                                                   
             , case when DEPT_ID.token          <> '' then  DEPT_ID.token                     else null end as DEPT_ID                --팀ID                                                                                                                       
             , case when PROJECT_CODE.token     <> '' then  PROJECT_CODE.token                else null end as PROJECT_CODE           --Project Code                                                                                                               
             , case when SCM_SITE_ID.token      <> '' then  SCM_SITE_ID.token                 else null end as SCM_SITE_ID            --SCM사이트ID                                                                                                                
             , case when ITEM_ID.token          <> '' then  ITEM_ID.token                     else null end as ITEM_ID                --Model Code                                                                                                                 
             , case when END_CUSTOMER.token     <> '' then  END_CUSTOMER.token                else null end as END_CUSTOMER           --End User Code                                                                                                              
             , case when BIZ_TYPE.token         <> '' then  BIZ_TYPE.token                    else null end as BIZ_TYPE               --모델구분(셀/팩/모듈)                                                                                                       
             , case when PLANT_SITE_ID.token    <> '' then  PLANT_SITE_ID.token               else null end as PLANT_SITE_ID          --Plant Site                                                                                                                 
             , case when FCST_TYPE.token        <> '' then  FCST_TYPE.token                   else null end as FCST_TYPE              --FCST_TYPE                                                                                                                  
             , case when DOM_EXP.token          <> '' then  DOM_EXP.token                     else null end as DOM_EXP                --내수/수출                                                                                                                  
             , case when INCOTERMS.token        <> '' then  INCOTERMS.token                   else null end as INCOTERMS              --출하조건                                                                                                                   
             , case when ITEM_USE.token         <> '' then  ITEM_USE.token                    else null end as ITEM_USE               --ITEM_USE                                                                                                                   
             , case when UNIT_ENERGY.token      <> '' then  UNIT_ENERGY.token                 else null end as UNIT_ENERGY            --UNIT_ENERGY                                                                                                                
             , case when CURRENCY.token         <> '' then  CURRENCY.token                    else null end as CURRENCY               --CURRENCY                                                                                                                   
             , case when MEASURE.token          <> '' then  MEASURE.token                     else null end as MEASURE                --Measure                                                                                                                    
             , case when YYYYMM.token           <> '' then  YYYYMM.token                      else null end as YYYYMM                 --사업계획수립연월                                                                                                           
             , case when QTY.token              <> '' then  QTY.token                         else null end as QTY                    --수량                                                                                                                       
             , case when PROJECT_NAME.token     <> '' then  PROJECT_NAME.token                else null end as PROJECT_NAME           --Project Name                                                                                                               
             , case when CELL_PROD_SITE.token   <> '' then  CELL_PROD_SITE.token              else null end as CELL_PROD_SITE         --CELL_PROD_SITE                                                                                                             
             , case when EE_CORP_ID.token       <> '' then  EE_CORP_ID.token                  else null end as EE_CORP_ID             --전극 생산 법인                                                                                                             
             , case when CELL_CORP_ID.token     <> '' then  CELL_CORP_ID.token                else null end as CELL_CORP_ID           --Cell 생산 법인                                                                                                             
             , case when PACK_CORP_ID.token     <> '' then  PACK_CORP_ID.token                else null end as PACK_CORP_ID           --Pack 생산 법인                                                                                                             
             , case when EXT_INT.token          <> '' then  EXT_INT.token                     else null end as EXT_INT                --외주여부(External/Internal)                                                                                                
             , case when PRODUCT_GROUP.token    <> '' then  PRODUCT_GROUP.token               else null end as PRODUCT_GROUP          --제품군                                                                                                                     
             , case when ALT_SIM_YN.token       <> '' then  ALT_SIM_YN.token                  else null end as ALT_SIM_YN             --대체/유사모델 여부                                                                                                         
             , case when CELL_CODE.token        <> '' then  CELL_CODE.token                   else null end as CELL_CODE              --Cell Code                                                                                                                  
             , case when CELL_PER_MODULE.token  <> '' then  CELL_PER_MODULE.token             else null end as CELL_PER_MODULE        --Cell/Module 환산자                                                                                                         
             , case when MODULE_PER_PACK.token  <> '' then  MODULE_PER_PACK.token             else null end as MODULE_PER_PACK        --Module/Pack 환산자                                                                                                         
             , case when CELL_PER_PACK.token    <> '' then  CELL_PER_PACK.token               else null end as CELL_PER_PACK          --Cell/Pack 환산자                                                                                                           
             , case when PERIOD_YYMM.token      <> '' then  PERIOD_YYMM.token                 else null end as PERIOD_YYMM            --계획기준년월                                                                                                               
             --, case when SCENARIO_TYPE.token    <> '' then  SCENARIO_TYPE.token               else null end as SCENARIO_TYPE          --시나리오 유형 "BP" 사업계획 고정                                                                                           
             --, case when BASE_PRICE.token       <> '' then  BASE_PRICE.token                  else null end as BASE_PRICE             --기준판가                                                                                                                   
             --, case when METAL_LINK_PRICE.token <> '' then  METAL_LINK_PRICE.token            else null end as METAL_LINK_PRICE       --메탈연동판가                                                                                                               
             --, case when METAL_LINK_YN.token    <> '' then  METAL_LINK_YN.token               else null end as METAL_LINK_YN          --메틸판가연동 여부                                                                                                          
             --, case when WORK_YYYYMMDD.token    <> '' then  WORK_YYYYMMDD.token               else null end as WORK_YYYYMMDD          --작업년월일(CUTOFF_YYYYMMDD 동일)                                                                                           
             , case when OSP_YN.token           <> '' then  OSP_YN.token                      else null end as OSP_YN                 --OSP Flag              
          into #SOURCE
          from             #SAVE_FLAG                       SAVE_FLAG                                                                 --저장구분(I:Insert, M: Modify)
               inner join  #DIVISION_ID                     DIVISION_ID                       on SAVE_FLAG.SEQ = DIVISION_ID.SEQ      --사업부ID                        
               inner join  #DEPT_ID                         DEPT_ID                           on SAVE_FLAG.SEQ = DEPT_ID.SEQ          --팀ID                            
               inner join  #PROJECT_CODE                    PROJECT_CODE                      on SAVE_FLAG.SEQ = PROJECT_CODE.SEQ     --Project Code                    
               inner join  #SCM_SITE_ID                     SCM_SITE_ID                       on SAVE_FLAG.SEQ = SCM_SITE_ID.SEQ      --SCM사이트ID                     
               inner join  #ITEM_ID                         ITEM_ID                           on SAVE_FLAG.SEQ = ITEM_ID.SEQ          --Model Code                      
               inner join  #END_CUSTOMER                    END_CUSTOMER                      on SAVE_FLAG.SEQ = END_CUSTOMER.SEQ     --End User Code                   
               inner join  #BIZ_TYPE                        BIZ_TYPE                          on SAVE_FLAG.SEQ = BIZ_TYPE.SEQ         --모델구분(셀/팩/모듈)            
               inner join  #PLANT_SITE_ID                   PLANT_SITE_ID                     on SAVE_FLAG.SEQ = PLANT_SITE_ID.SEQ    --Plant Site                      
               inner join  #FCST_TYPE                       FCST_TYPE                         on SAVE_FLAG.SEQ = FCST_TYPE.SEQ        --FCST_TYPE                       
               inner join  #DOM_EXP                         DOM_EXP                           on SAVE_FLAG.SEQ = DOM_EXP.SEQ          --내수/수출                       
               inner join  #INCOTERMS                       INCOTERMS                         on SAVE_FLAG.SEQ = INCOTERMS.SEQ        --출하조건                        
               inner join  #ITEM_USE                        ITEM_USE                          on SAVE_FLAG.SEQ = ITEM_USE.SEQ         --ITEM_USE                        
               inner join  #UNIT_ENERGY                     UNIT_ENERGY                       on SAVE_FLAG.SEQ = UNIT_ENERGY.SEQ      --UNIT_ENERGY                     
               inner join  #CURRENCY                        CURRENCY                          on SAVE_FLAG.SEQ = CURRENCY.SEQ         --CURRENCY                        
               inner join  #MEASURE                         MEASURE                           on SAVE_FLAG.SEQ = MEASURE.SEQ          --Measure                         
               inner join  #YYYYMM                          YYYYMM                            on SAVE_FLAG.SEQ = YYYYMM.SEQ           --사업계획수립연월                
               inner join  #QTY                             QTY                               on SAVE_FLAG.SEQ = QTY.SEQ              --수량                            
               inner join  #PROJECT_NAME                    PROJECT_NAME                      on SAVE_FLAG.SEQ = PROJECT_NAME.SEQ     --Project Name                    
               inner join  #CELL_PROD_SITE                  CELL_PROD_SITE                    on SAVE_FLAG.SEQ = CELL_PROD_SITE.SEQ   --CELL_PROD_SITE                  
               inner join  #EE_CORP_ID                      EE_CORP_ID                        on SAVE_FLAG.SEQ = EE_CORP_ID.SEQ       --전극 생산 법인                  
               inner join  #CELL_CORP_ID                    CELL_CORP_ID                      on SAVE_FLAG.SEQ = CELL_CORP_ID.SEQ     --Cell 생산 법인                  
               inner join  #PACK_CORP_ID                    PACK_CORP_ID                      on SAVE_FLAG.SEQ = PACK_CORP_ID.SEQ     --Pack 생산 법인                  
               inner join  #EXT_INT                         EXT_INT                           on SAVE_FLAG.SEQ = EXT_INT.SEQ          --외주여부(External/Internal)     
               inner join  #PRODUCT_GROUP                   PRODUCT_GROUP                     on SAVE_FLAG.SEQ = PRODUCT_GROUP.SEQ    --제품군                          
               inner join  #ALT_SIM_YN                      ALT_SIM_YN                        on SAVE_FLAG.SEQ = ALT_SIM_YN.SEQ       --대체/유사모델 여부              
               inner join  #CELL_CODE                       CELL_CODE                         on SAVE_FLAG.SEQ = CELL_CODE.SEQ        --Cell Code                       
               inner join  #CELL_PER_MODULE                 CELL_PER_MODULE                   on SAVE_FLAG.SEQ = CELL_PER_MODULE.SEQ  --Cell/Module 환산자              
               inner join  #MODULE_PER_PACK                 MODULE_PER_PACK                   on SAVE_FLAG.SEQ = MODULE_PER_PACK.SEQ  --Module/Pack 환산자              
               inner join  #CELL_PER_PACK                   CELL_PER_PACK                     on SAVE_FLAG.SEQ = CELL_PER_PACK.SEQ    --Cell/Pack 환산자                
               inner join  #PERIOD_YYMM                     PERIOD_YYMM                       on SAVE_FLAG.SEQ = PERIOD_YYMM.SEQ      --계획기준년월                    
               --inner join  #SCENARIO_TYPE                   SCENARIO_TYPE                     on SAVE_FLAG.SEQ = SCENARIO_TYPE.SEQ    --시나리오 유형 "BP" 사업계획 고정
               --inner join  #BASE_PRICE                      BASE_PRICE                        on SAVE_FLAG.SEQ = BASE_PRICE.SEQ       --기준판가                        
               --inner join  #METAL_LINK_PRICE                METAL_LINK_PRICE                  on SAVE_FLAG.SEQ = METAL_LINK_PRICE.SEQ --메탈연동판가                    
               --inner join  #METAL_LINK_YN                   METAL_LINK_YN                     on SAVE_FLAG.SEQ = METAL_LINK_YN.SEQ    --메틸판가연동 여부               
               --inner join  #WORK_YYYYMMDD                   WORK_YYYYMMDD                     on SAVE_FLAG.SEQ = WORK_YYYYMMDD.SEQ    --작업년월일(CUTOFF_YYYYMMDD 동일)
               inner join  #OSP_YN                          OSP_YN                            on SAVE_FLAG.SEQ = OSP_YN.SEQ			  --OSP Flag   
			   ;

		---------------------------------------------------------------------------------------------------------
		-- 데이터 유효성 체크
		---------------------------------------------------------------------------------------------------------
		--구분자에 의해 파싱한 파라미터 값의 개수 일치 여부 확인
		if exists (select 1 from #SAVE_FLAG a left join #SOURCE b on a.SEQ = b.SEQ where b.SEQ is null)
		begin 
			set @v_log_type = 'INVALID';
			select N'UI 프로그램 오류입니다. 파라미터의 값의 수가 일치하지 않습니다.';
			set @v_description = N'UI 화면 개발자에게 문의하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(DIVISION_ID)
		if exists (select 1 from #DIVISION_ID where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M', 'D')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Div 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Div)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(DEPT_ID)
		if exists (select 1 from #DEPT_ID where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M', 'D')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Team 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Team)을 확인하세요.';
			goto err_rtn;
		end
			
		--not null 제약 확인(PROJECT_CODE)
		if exists (select 1 from #PROJECT_CODE where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M', 'D')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Project Code 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Project Code)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(SCM_SITE_ID)
		if exists (select 1 from #SCM_SITE_ID where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M', 'D')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Sales Site 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Sales Site)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(ITEM_ID)
		if exists (select 1 from #ITEM_ID where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M', 'D')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Model 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Model)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(END_CUSTOMER)
		if exists (select 1 from #END_CUSTOMER where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'End Customer 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(End Customer)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(BIZ_TYPE)
		if exists (select 1 from #BIZ_TYPE where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Biz.Type 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Biz.Type)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(PLANT_SITE_ID)
		if exists (select 1 from #PLANT_SITE_ID where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Plant Site 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Plant Site)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(FCST_TYPE)
		if exists (select 1 from #FCST_TYPE where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'FCST Type 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(FCST Type)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(DOM_EXP)
		if exists (select 1 from #DOM_EXP where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Customs Handbook 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Customs Handbook)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(INCOTERMS)
		if exists (select 1 from #INCOTERMS where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Rep. Incoterms 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Rep. Incoterms)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(ITEM_USE)
		if exists (select 1 from #ITEM_USE where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'용도 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(용도)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(UNIT_ENERGY)
		if exists (select 1 from #UNIT_ENERGY where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Energy 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Energy)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(CURRENCY)
		if exists (select 1 from #CURRENCY where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Currency 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Currency)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(MEASURE)
		if exists (select 1 from #MEASURE where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Measure 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Measure)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(YYYYMM)
		if exists (select 1 from #YYYYMM where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'연월 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(연월)을 확인하세요.';
			goto err_rtn;
		end
		---------------------------------------------------------------------------------------------------------
		create table #DATA
		(
			  DIVISION_ID        nvarchar(30)        NOT NULL  --사업부ID
			, DEPT_ID            nvarchar(20)        NOT NULL  --팀ID
			, PROJECT_CODE       nvarchar(50)        NOT NULL  --Project Code
			, SCM_SITE_ID        nvarchar(30)        NOT NULL  --SCM사이트ID
			, ITEM_ID            nvarchar(50)        NOT NULL  --Model Code
			, END_CUSTOMER       nvarchar(50)        NOT NULL  --End User Code
			, BIZ_TYPE           nvarchar(30)        NOT NULL  --모델구분(셀/팩/모듈)
			, PLANT_SITE_ID      nvarchar(50)        NOT NULL  --Plant Site
			, FCST_TYPE          nvarchar(20)        NOT NULL  --FCST_TYPE
			, DOM_EXP            nvarchar(2)         NOT NULL  --내수/수출
			, INCOTERMS          nvarchar(4)         NOT NULL  --출하조건
			, ITEM_USE           nvarchar(10)        NOT NULL  --ITEM_USE
			, UNIT_ENERGY        numeric(30, 10)     NOT NULL  --UNIT_ENERGY
			, CURRENCY           nvarchar(10)        NOT NULL  --CURRENCY
			, MEASURE            nvarchar(50)        NOT NULL  --Measure
			, YYYYMM             nvarchar(6)         NOT NULL  --사업계획수립연월
			, QTY                numeric(30, 10)     NULL      --수량
			, PROJECT_NAME       nvarchar(50)        NULL      --Project Name
			, CELL_PROD_SITE     nvarchar(30)        NULL      --CELL_PROD_SITE
			, EE_CORP_ID         nvarchar(30)        NULL      --전극 생산 법인
			, CELL_CORP_ID       nvarchar(30)        NULL      --Cell 생산 법인
			, PACK_CORP_ID       nvarchar(30)        NULL      --Pack 생산 법인
			, EXT_INT            nvarchar(6)         NULL      --외주여부(External/Internal)
			, PRODUCT_GROUP      nvarchar(30)        NULL      --제품군
			, ALT_SIM_YN         nvarchar(1)         NULL      --대체/유사모델 여부
			, CELL_CODE          nvarchar(50)        NULL      --Cell Code
			, CELL_PER_MODULE    numeric(20, 10)     NULL      --Cell/Module 환산자
			, MODULE_PER_PACK    numeric(30, 10)     NULL      --Module/Pack 환산자
			, CELL_PER_PACK      numeric(30, 10)     NULL      --Cell/Pack 환산자
			, PERIOD_YYMM        nvarchar(6)         NULL      --계획기준년월
			, SCENARIO_TYPE      nvarchar(4)         NULL      --시나리오 유형 "BP" 사업계획 고정
			, BASE_PRICE         numeric(20, 10)     NULL      --기준판가
			, METAL_LINK_PRICE   numeric(20, 10)     NULL      --메탈연동판가
			, METAL_LINK_YN      nvarchar(1)         NULL      --메틸판가연동 여부
			, WORK_YYYYMMDD      nvarchar(8)         NULL      --작업년월일(CUTOFF_YYYYMMDD 동일)
			, OSP_YN             nvarchar(1)         NULL      --OSP Flag
		);

		--Business_Plan
		insert 
		  into #DATA
		     (
			  DIVISION_ID        --사업부ID
			, DEPT_ID            --팀ID
			, PROJECT_CODE       --Project Code
			, SCM_SITE_ID        --SCM사이트ID
			, ITEM_ID            --Model Code
			, END_CUSTOMER       --End User Code
			, BIZ_TYPE           --모델구분(셀/팩/모듈)
			, PLANT_SITE_ID      --Plant Site
			, FCST_TYPE          --FCST_TYPE
			, DOM_EXP            --내수/수출
			, INCOTERMS          --출하조건
			, ITEM_USE           --ITEM_USE
			, UNIT_ENERGY        --UNIT_ENERGY
			, CURRENCY           --CURRENCY
			, MEASURE            --Measure
			, YYYYMM             --사업계획수립연월
			, QTY                --수량
			, PROJECT_NAME       --Project Name
			, CELL_PROD_SITE     --CELL_PROD_SITE
			, EE_CORP_ID         --전극 생산 법인
			, CELL_CORP_ID       --Cell 생산 법인
			, PACK_CORP_ID       --Pack 생산 법인
			, EXT_INT            --외주여부(External/Internal)
			, PRODUCT_GROUP      --제품군
			, ALT_SIM_YN         --대체/유사모델 여부
			, CELL_CODE          --Cell Code
			, CELL_PER_MODULE    --Cell/Module 환산자
			, MODULE_PER_PACK    --Module/Pack 환산자
			, CELL_PER_PACK      --Cell/Pack 환산자
			, PERIOD_YYMM        --계획기준년월
			, SCENARIO_TYPE      --시나리오 유형 "BP" 사업계획 고정
			, BASE_PRICE         --기준판가
			, METAL_LINK_PRICE   --메탈연동판가
			, METAL_LINK_YN      --메틸판가연동 여부
			, WORK_YYYYMMDD      --작업년월일(CUTOFF_YYYYMMDD 동일)
			, OSP_YN             --OSP Flag
			 )
		select
			  s.DIVISION_ID        --사업부ID
			, s.DEPT_ID            --팀ID
			, s.PROJECT_CODE       --Project Code
			, s.SCM_SITE_ID        --SCM사이트ID
			, s.ITEM_ID            --Model Code
			, s.END_CUSTOMER       --End User Code
			, s.BIZ_TYPE           --모델구분(셀/팩/모듈)
			, s.PLANT_SITE_ID      --Plant Site
			, s.FCST_TYPE          --FCST_TYPE
			, s.DOM_EXP            --내수/수출
			, s.INCOTERMS          --출하조건
			, s.ITEM_USE           --ITEM_USE
			, s.UNIT_ENERGY        --UNIT_ENERGY
			, s.CURRENCY           --CURRENCY
			, s.MEASURE            --Measure
			, s.YYYYMM             --사업계획수립연월
			, s.QTY                --수량
			, s.PROJECT_NAME       --Project Name
			, s.CELL_PROD_SITE     --CELL_PROD_SITE
			, null EE_CORP_ID      --전극 생산 법인
			, null CELL_CORP_ID    --Cell 생산 법인
			, null PACK_CORP_ID    --Pack 생산 법인
			, s.EXT_INT            --외주여부(External/Internal)
			, s.PRODUCT_GROUP      --제품군
			, s.ALT_SIM_YN         --대체/유사모델 여부
			, s.CELL_CODE          --Cell Code
			, s.CELL_PER_MODULE    --Cell/Module 환산자
			, s.MODULE_PER_PACK    --Module/Pack 환산자
			, s.CELL_PER_PACK      --Cell/Pack 환산자
			, s.PERIOD_YYMM        --계획기준년월
			, 'BP'				 SCENARIO_TYPE		--시나리오 유형 "BP" 사업계획 고정
			, q.BASE_PRICE       BASE_PRICE			--기준판가
			, q.METAL_LINK_PRICE METAL_LINK_PRICE   --메탈연동판가
			, p.METAL_LINK_YN 	   --메틸판가연동 여부
			, null WORK_YYYYMMDD --작업년월일(CUTOFF_YYYYMMDD 동일)
			, s.OSP_YN             --OSP Flag
		  from #SOURCE s
			   outer apply (select r1.METAL_LINK_YN
			                  from dbo.DM_MST_METAL_PRICE_RULE r1
							 where (s.DIVISION_ID like '81%' or s.DIVISION_ID = '40')
							   and r1.DIVISION_ID	= s.DIVISION_ID
							   and r1.PROJECT_CODE	= s.PROJECT_CODE
							   and r1.SCM_SITE_ID	= s.SCM_SITE_ID
							   and r1.ITEM_ID		= s.ITEM_ID
							 union all
							select r2.METAL_LINK_YN
			                  from dbo.DM_MST_METAL_PRICE_RULE r2
							 where (s.DIVISION_ID = '82')
							   and r2.DIVISION_ID	= s.DIVISION_ID
							   and r2.PROJECT_CODE	= s.PROJECT_CODE
							   and r2.SCM_SITE_ID	= s.SCM_SITE_ID
							   and r2.ITEM_ID		= s.ITEM_ID
						   ) p
			   outer apply (select sum(case when m.MEASURE = 'BasePriceCur'  then m.PRICE end) BASE_PRICE
			                     , sum(case when m.MEASURE = 'TotalPriceCur' then m.PRICE end) METAL_LINK_PRICE
			                  from dbo.DM_MST_METAL_PRICE m
							 where m.DIVISION_ID	= s.DIVISION_ID							   
							   and m.PROJECT_CODE	= s.PROJECT_CODE
							   and m.SCM_SITE_ID	= s.SCM_SITE_ID
							   and m.ITEM_ID		= s.ITEM_ID
							   and m.MEASURE        in ('BasePriceCur', 'TotalPriceCur')--BasePriceCur: Base Price(Cur), TotalPriceCur: Total Price(Cur)
							   and m.STND_YM        = s.YYYYMM
						   ) q
         where s.MEASURE		= 'Business_Plan'
		   and s.SAVE_FLAG	in ('I', 'M');

		declare @t table(num int);
		insert into @t values(1);
		insert into @t values(2);
		insert into @t values(3);
		insert into @t values(4);

		insert 
		  into #DATA
		     (
			  DIVISION_ID        --사업부ID
			, DEPT_ID            --팀ID
			, PROJECT_CODE       --Project Code
			, SCM_SITE_ID        --SCM사이트ID
			, ITEM_ID            --Model Code
			, END_CUSTOMER       --End User Code
			, BIZ_TYPE           --모델구분(셀/팩/모듈)
			, PLANT_SITE_ID      --Plant Site
			, FCST_TYPE          --FCST_TYPE
			, DOM_EXP            --내수/수출
			, INCOTERMS          --출하조건
			, ITEM_USE           --ITEM_USE
			, UNIT_ENERGY        --UNIT_ENERGY
			, CURRENCY           --CURRENCY
			, MEASURE            --Measure
			, YYYYMM             --사업계획수립연월
			, QTY                --수량
			, PROJECT_NAME       --Project Name
			, CELL_PROD_SITE     --CELL_PROD_SITE
			, EE_CORP_ID         --전극 생산 법인
			, CELL_CORP_ID       --Cell 생산 법인
			, PACK_CORP_ID       --Pack 생산 법인
			, EXT_INT            --외주여부(External/Internal)
			, PRODUCT_GROUP      --제품군
			, ALT_SIM_YN         --대체/유사모델 여부
			, CELL_CODE          --Cell Code
			, CELL_PER_MODULE    --Cell/Module 환산자
			, MODULE_PER_PACK    --Module/Pack 환산자
			, CELL_PER_PACK      --Cell/Pack 환산자
			, PERIOD_YYMM        --계획기준년월
			, SCENARIO_TYPE      --시나리오 유형 "BP" 사업계획 고정
			, BASE_PRICE         --기준판가
			, METAL_LINK_PRICE   --메탈연동판가
			, METAL_LINK_YN      --메틸판가연동 여부
			, WORK_YYYYMMDD      --작업년월일(CUTOFF_YYYYMMDD 동일)
			, OSP_YN             --OSP Flag
			 )
		select
			  d.DIVISION_ID        --사업부ID
			, d.DEPT_ID            --팀ID
			, d.PROJECT_CODE       --Project Code
			, d.SCM_SITE_ID        --SCM사이트ID
			, d.ITEM_ID            --Model Code
			, d.END_CUSTOMER       --End User Code
			, d.BIZ_TYPE           --모델구분(셀/팩/모듈)
			, d.PLANT_SITE_ID      --Plant Site
			, d.FCST_TYPE          --FCST_TYPE
			, d.DOM_EXP            --내수/수출
			, d.INCOTERMS          --출하조건
			, d.ITEM_USE           --ITEM_USE
			, d.UNIT_ENERGY        --UNIT_ENERGY
			, d.CURRENCY           --CURRENCY
			, case n.num            
					when 1 then 'BizPlanPrice_Cur'	--Biz Plan Price(Cur.)
					when 2 then 'SalesAmt_CUR'		--Sales Amount(Cur.)
					when 3 then 'SalesAmt_KRW'		--Sales Amt.(KRW)
					when 4 then 'SalesAmt_USD'		--Sales Amount(USD)
              end MEASURE		 --Measure
			, d.YYYYMM             --사업계획수립연월
			, case n.num            
					when 1 then d.METAL_LINK_PRICE				--Biz Plan Price(Cur.)
					when 2 then d.METAL_LINK_PRICE * d.QTY		--Sales Amount(Cur.)
					when 3 then 								--Sales Amt.(KRW)
						case d.CURRENCY
							when 'KRW' then d.METAL_LINK_PRICE * d.QTY
							else
								(select d.METAL_LINK_PRICE * d.QTY * c.STND_PRICE									
								   from dbo.DM_MST_METAL_CURRENCY_PRICE c
                                  where c.DIVISION_ID = d.DIVISION_ID
								    and c.METAL_CURRENCY_GBN = '1'		--메탈통화구분(1 통화, 2 메탈)
									and c.STND_YM            = d.YYYYMM
									and c.METAL_CURRENCY     = d. CURRENCY
									and c.STND_MARKET        = 'Business Plan'
								)
						end
					when 4 then									--Sales Amount(USD)
						case d.CURRENCY
							when 'USD' then d.METAL_LINK_PRICE * d.QTY
							when 'KRW' then 
								(select d.METAL_LINK_PRICE * d.QTY / c.STND_PRICE									
								   from dbo.DM_MST_METAL_CURRENCY_PRICE c
                                  where c.DIVISION_ID = d.DIVISION_ID
								    and c.METAL_CURRENCY_GBN = '1'		--메탈통화구분(1 통화, 2 메탈)
									and c.STND_YM            = d.YYYYMM
									and c.METAL_CURRENCY     = d. CURRENCY
									and c.STND_MARKET        = 'Business Plan'
								)
							else d.METAL_LINK_PRICE * d.QTY *
								(select c.STND_PRICE									
								   from dbo.DM_MST_METAL_CURRENCY_PRICE c
                                  where c.DIVISION_ID = d.DIVISION_ID
								    and c.METAL_CURRENCY_GBN = '1'		--메탈통화구분(1 통화, 2 메탈)
									and c.STND_YM            = d.YYYYMM
									and c.METAL_CURRENCY     = d. CURRENCY
									and c.STND_MARKET        = 'Business Plan'
								) /
								(select c.STND_PRICE									
								   from dbo.DM_MST_METAL_CURRENCY_PRICE c
                                  where c.DIVISION_ID = d.DIVISION_ID
								    and c.METAL_CURRENCY_GBN = '1'		--메탈통화구분(1 통화, 2 메탈)
									and c.STND_YM            = d.YYYYMM
									and c.METAL_CURRENCY     = 'USD'
									and c.STND_MARKET        = 'Business Plan'
								)
						end	
              end QTY                --수량
			, d.PROJECT_NAME       --Project Name
			, d.CELL_PROD_SITE     --CELL_PROD_SITE
			, d.EE_CORP_ID         --전극 생산 법인
			, d.CELL_CORP_ID       --Cell 생산 법인
			, d.PACK_CORP_ID       --Pack 생산 법인
			, d.EXT_INT            --외주여부(External/Internal)
			, d.PRODUCT_GROUP      --제품군
			, d.ALT_SIM_YN         --대체/유사모델 여부
			, d.CELL_CODE          --Cell Code
			, d.CELL_PER_MODULE    --Cell/Module 환산자
			, d.MODULE_PER_PACK    --Module/Pack 환산자
			, d.CELL_PER_PACK      --Cell/Pack 환산자
			, d.PERIOD_YYMM        --계획기준년월
			, d.SCENARIO_TYPE      --시나리오 유형 "BP" 사업계획 고정
			, d.BASE_PRICE         --기준판가
			, d.METAL_LINK_PRICE   --메탈연동판가
			, d.METAL_LINK_YN      --메틸판가연동 여부
			, d.WORK_YYYYMMDD      --작업년월일(CUTOFF_YYYYMMDD 동일)
			, d.OSP_YN             --OSP Flag
		  from #DATA d cross join @t n;

		select
               PERIOD_YYMM    --계획기준년월
             , DIVISION_ID    --사업부ID
             , PROJECT_CODE   --Project Code
             , SCM_SITE_ID    --SCM사이트ID
             , ITEM_ID        --Model Code
             , END_CUSTOMER   --End User Code
             , BIZ_TYPE       --모델구분(셀/팩/모듈)
             , PLANT_SITE_ID  --Plant Site
             , FCST_TYPE      --FCST_TYPE
             , DOM_EXP        --내수/수출
             , INCOTERMS      --출하조건
             , CURRENCY       --CURRENCY
          into #PKLIST
		  from #SOURCE
		 group by
               PERIOD_YYMM    --계획기준년월
             , DIVISION_ID    --사업부ID
             , PROJECT_CODE   --Project Code
             , SCM_SITE_ID    --SCM사이트ID
             , ITEM_ID        --Model Code
             , END_CUSTOMER   --End User Code
             , BIZ_TYPE       --모델구분(셀/팩/모듈)
             , PLANT_SITE_ID  --Plant Site
             , FCST_TYPE      --FCST_TYPE
             , DOM_EXP        --내수/수출
             , INCOTERMS      --출하조건
             , CURRENCY       --CURRENCY
			   ;

		begin tran;
		delete t
		  from dbo.DM_PLN_BIZPLAN t
		       inner join (select a.*, b.YM YYYYMM 
			                 from #PKLIST a 
							      cross join dbo.DMF0009_GET_YM_IN_BETWEEN_TWO_YM(@p_START_STND_YM, @p_END_STND_YM) b
                          ) s
                       on s.PERIOD_YYMM		= t.PERIOD_YYMM   --계획기준년월 
                      and s.DIVISION_ID     = t.DIVISION_ID    --사업부ID
                      and s.PROJECT_CODE    = t.PROJECT_CODE   --Project Code
                      and s.SCM_SITE_ID     = t.SCM_SITE_ID    --SCM사이트ID
                      and s.ITEM_ID         = t.ITEM_ID        --Model Code
                      and s.END_CUSTOMER    = t.END_CUSTOMER   --End User Code
                      and s.BIZ_TYPE        = t.BIZ_TYPE       --모델구분(셀/팩/모듈)
                      and s.PLANT_SITE_ID   = t.PLANT_SITE_ID  --Plant Site
                      and s.FCST_TYPE       = t.FCST_TYPE      --FCST_TYPE
                      and s.DOM_EXP         = t.DOM_EXP        --내수/수출
                      and s.INCOTERMS       = t.INCOTERMS      --출하조건
                      and s.CURRENCY        = t.CURRENCY       --CURRENCY
					  ;

		insert 
		  into dbo.DM_PLN_BIZPLAN
		     (
			  DIVISION_ID        --사업부ID
			, DEPT_ID            --팀ID
			, PROJECT_CODE       --Project Code
			, SCM_SITE_ID        --SCM사이트ID
			, ITEM_ID            --Model Code
			, END_CUSTOMER       --End User Code
			, BIZ_TYPE           --모델구분(셀/팩/모듈)
			, PLANT_SITE_ID      --Plant Site
			, FCST_TYPE          --FCST_TYPE
			, DOM_EXP            --내수/수출
			, INCOTERMS          --출하조건
			, ITEM_USE           --ITEM_USE
			, UNIT_ENERGY        --UNIT_ENERGY
			, CURRENCY           --CURRENCY
			, MEASURE            --Measure
			, YYYYMM             --사업계획수립연월
			, QTY                --수량
			, PROJECT_NAME       --Project Name
			, CELL_PROD_SITE     --CELL_PROD_SITE
			, EE_CORP_ID         --전극 생산 법인
			, CELL_CORP_ID       --Cell 생산 법인
			, PACK_CORP_ID       --Pack 생산 법인
			, EXT_INT            --외주여부(External/Internal)
			, PRODUCT_GROUP      --제품군
			, ALT_SIM_YN         --대체/유사모델 여부
			, CELL_CODE          --Cell Code
			, CELL_PER_MODULE    --Cell/Module 환산자
			, MODULE_PER_PACK    --Module/Pack 환산자
			, CELL_PER_PACK      --Cell/Pack 환산자
			, PERIOD_YYMM        --계획기준년월
			, SCENARIO_TYPE      --시나리오 유형 "BP" 사업계획 고정
			, BASE_PRICE         --기준판가
			, METAL_LINK_PRICE   --메탈연동판가
			, METAL_LINK_YN      --메틸판가연동 여부
			, WORK_YYYYMMDD      --작업년월일(CUTOFF_YYYYMMDD 동일)
			, OSP_YN             --OSP Flag

			, CREATED_BY         --생성자
            , CREATION_DATE      --생성일자
            , LAST_UPDATED_BY    --최종수정자
            , LAST_UPDATE_DATE   --최종수정일자
			 )
		select
			  DIVISION_ID        --사업부ID
			, DEPT_ID            --팀ID
			, PROJECT_CODE       --Project Code
			, SCM_SITE_ID        --SCM사이트ID
			, ITEM_ID            --Model Code
			, END_CUSTOMER       --End User Code
			, BIZ_TYPE           --모델구분(셀/팩/모듈)
			, PLANT_SITE_ID      --Plant Site
			, FCST_TYPE          --FCST_TYPE
			, DOM_EXP            --내수/수출
			, INCOTERMS          --출하조건
			, ITEM_USE           --ITEM_USE
			, UNIT_ENERGY        --UNIT_ENERGY
			, CURRENCY           --CURRENCY
			, MEASURE            --Measure
			, YYYYMM             --사업계획수립연월
			, QTY                --수량
			, PROJECT_NAME       --Project Name
			, CELL_PROD_SITE     --CELL_PROD_SITE
			, EE_CORP_ID         --전극 생산 법인
			, CELL_CORP_ID       --Cell 생산 법인
			, PACK_CORP_ID       --Pack 생산 법인
			, EXT_INT            --외주여부(External/Internal)
			, PRODUCT_GROUP      --제품군
			, ALT_SIM_YN         --대체/유사모델 여부
			, CELL_CODE          --Cell Code
			, CELL_PER_MODULE    --Cell/Module 환산자
			, MODULE_PER_PACK    --Module/Pack 환산자
			, CELL_PER_PACK      --Cell/Pack 환산자
			, PERIOD_YYMM        --계획기준년월
			, SCENARIO_TYPE      --시나리오 유형 "BP" 사업계획 고정
			, BASE_PRICE         --기준판가
			, METAL_LINK_PRICE   --메탈연동판가
			, METAL_LINK_YN      --메틸판가연동 여부
			, WORK_YYYYMMDD      --작업년월일(CUTOFF_YYYYMMDD 동일)
			, OSP_YN             --OSP 	Flag
			
			, @p_CREATED_BY     --생성자
            , getdate()			--생성일자
            , @p_CREATED_BY		--최종수정자
            , getdate()			--최종수정일자
		  from #DATA;
		commit tran;
	end try

	begin catch
		if @@trancount > 0
			rollback tran;

		---------------------------------------------------------------------------------------------------------
		-- ERROR LOG
		---------------------------------------------------------------------------------------------------------
		set @v_log_type		= 'ERROR';
		set @n_log_count	= @n_log_count + 1;
		set @v_log_message	= cast(error_message() AS nvarchar(1000));
		set @v_description	= 'ERROR_LINE : ' + str(error_line());
		set @v_event_date	= sysdatetime();
		exec PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @v_event_date;

		select '[' + convert(nvarchar(10), error_number()) + ']' + error_message();
	end catch

	---------------------------------------------------------------------------------------------------------
	-- 종료 LOG
	---------------------------------------------------------------------------------------------------------
	set @v_log_type		= 'END';
	set @n_log_count	= @n_log_count + 1;
	set @v_log_message	= '########## END of procedure ##########';;
	set @v_description	= '';
	set @v_event_date	= sysdatetime();
	exec PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @v_event_date;
end;

err_rtn:
	if @v_log_type = 'INVALID'
		begin		
			if @@trancount > 0
				rollback tran;

			set @n_log_count	= @n_log_count + 1;
			set @v_log_message	= '########## END of procedure ##########';
			set @v_event_date	= sysdatetime();
			exec PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @v_event_date;

			select @v_description;
		end	
