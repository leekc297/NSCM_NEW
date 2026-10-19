





CREATE  VIEW [dbo].[SCP_PLAN_PARAMETER_V]  AS        
/**        
  * PROJECT       : LG CHEM SCP PRJ.        
  * VIEW NAME     : SCP_PLAN_PARAMETER_V      
  * DESCRIPTION   : 개발 편의성을 위한 엔진수행 버전조회용 뷰 최근 100건         
  *               : 도구>>옵션>>쿼리 결과>SQL Server>표 형태로 결과 표시 에서 
  *                 복사 또는 저장 시 CR/LF 보존 체크할 것.
  * PROGRAM HISTORY        
  *--------------------------------------------------------------        
  *  DATE      IN CHARGE           DESCRIPTION        
  *--------------------------------------------------------------        
  * 2018-06-01       신규생성      
  * 2018-08-29        [FOR_PROCEDURE], [FOR_QUERY] 추가 
  * 2018-09-19        [FOR_WHERE_CLAUSE] 추가
  * 2018-12-05        [FOR_UI_PROCEDURE] 추가
  */        

--  select * from SCM_SYS_LOG_BATCH  WITH (NOLOCK) WHERE LOG_TYPE ='ERROR' order by creation_date desc


with sub as        
(        
select d.DIVISION_ID,        
       p.plan_name+'-'+d.plan_type+'-'+ dbo.fn_zero_lpad(convert(nvarchar,d.plan_seq),2)  as plan_version_id,        
       p.plan_name,        
       d.plan_seq,        
       d.plan_type,        
       d.CONFIRM_FLAG,        
       D.CONFIRM_USER,         
       D.CONFIRM_DATE,        
       P.PLAN_ID,        
       M.MODELING_ID,        
       M.PLAN_CYCLE,        
       P.PLAN_ID+'::'+d.plan_TYPE+'::'+CONVERT(VARCHAR,d.plan_seq) AS ENG_PLAN_ID,        
       d.DIVISION_ID+'::'+M.PLAN_CYCLE AS master_id,      
       D.UI_DISPLAY_YN,        
       D.ACTIVE_FLAG,        
       D.PLAN_STATUS,
       D.CREATION_DATE    
            
      
  from scm_mst_plan_detail d with(nolock),        
       scm_mst_plan        p with(nolock),        
      scm_mst_modeling    m with(nolock)        
 where 1=1        
   and m.MODELING_ID   = d.MODELING_ID        
--   and m.PLAN_CYCLE    = 'WEEKLY'        
   and m.DIVISION_ID   = d.DIVISION_ID        
   and m.MODELING_ID   = d.MODELING_ID        
   and p.DIVISION_ID   = d.DIVISION_ID        
   and p.PLAN_CYCLE    = m.PLAN_CYCLE        
   and p.PLAN_ID       = d.PLAN_ID        
--   and d.PLAN_STATUS   = '1'        
--   and d.UI_DISPLAY_YN = 'Y'        
--order by D.CONFIRM_DATE desc      
 )        
   select TOP 200 
          master_id,  
          ENG_PLAN_ID, 
          plan_name        as plan_start_yyyymmdd, 
         + CHAR(13) +N'-- DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY = ''<@p_user_id,NVARCHAR(100),>'' '
         + CHAR(13) +N'--EXEC <sp,명,PR_SCP_> --'
         + ''
         + '''' + CHAR(13) +'   @p_plan_cycle          = '''+ PLAN_CYCLE+''       
         + '''' + CHAR(13) +' , @p_plan_start_yyyymmdd = '''+ plan_name+ ''       
         + '''' + CHAR(13) +' , @p_plan_id             = '''+ PLAN_ID+ ''      
         + '''' + CHAR(13) +' , @p_modeling_id         = '''+ MODELING_ID + ''      
         + '''' + CHAR(13) +' , @p_seq                 = '''+ CONVERT(NVARCHAR, plan_seq)      + ''      
         + '''' + CHAR(13) +' , @p_plan_type           = '''+ plan_type+ ''      
         + '''' + CHAR(13) +' , @p_master_id           = '''+ master_id+ ''      
         + '''' + CHAR(13) +' , @p_division_id         = '''+ DIVISION_ID+ ''      
         + '''' + CHAR(13) +' , @p_engine_plan_id      = '''+ ENG_PLAN_ID+ ''   
         + '''' + CHAR(13) +' , @p_user_id             = ''<@p_user_id,NVARCHAR(100),>' 
         + '''' + CHAR(13) +' ' 
         + '' + CHAR(13) +' SELECT * FROM SCM_SYS_LOG_BATCH    WITH (NOLOCK)  WHERE CREATED_BY =''<@p_user_id,NVARCHAR(100),>'' order by CREATION_DATE desc '
       AS [FOR_PROCEDURE] ,             
                          N' -- Ctrl+Shift+M 으로 @p_user_id명 입력하세요 '
                + ''
         + '''' + CHAR(13) +' DECLARE   @p_plan_cycle          NVARCHAR(100) = '''+ PLAN_CYCLE+''     
         + '''' + CHAR(13) +'         , @p_plan_start_yyyymmdd NVARCHAR(100) = '''+ plan_name+ ''     
         + '''' + CHAR(13) +'         , @p_plan_id             NVARCHAR(100) = '''+ PLAN_ID+ ''  
         + '''' + CHAR(13) +'         , @p_modeling_id         NVARCHAR(100) = '''+ MODELING_ID + ''    
         + '''' + CHAR(13) +'         , @p_seq                 NVARCHAR(100) = '''+ CONVERT(NVARCHAR, plan_seq)      + ''    
         + '''' + CHAR(13) +'         , @p_plan_type           NVARCHAR(100) = '''+ plan_type+ ''    
         + '''' + CHAR(13) +'         , @p_master_id           NVARCHAR(100) = '''+ master_id+ ''    
         + '''' + CHAR(13) +'         , @p_division_id         NVARCHAR(100) = '''+ DIVISION_ID+ ''    
         + '''' + CHAR(13) +'         , @p_engine_plan_id      NVARCHAR(100) = '''+ ENG_PLAN_ID+ ''
         + '''' + CHAR(13) +'         , @p_item_id             NVARCHAR(100) = '''
         + '''' + CHAR(13) +'         , @p_user_id             NVARCHAR(100) = ''<@p_user_id,NVARCHAR(100),>'      
         + '''' + CHAR(13) +'         , @p_program_id          NVARCHAR(030) = ''XLSPSI03'     
         + '''' + CHAR(13) +'         , @p_to_yyyymmdd         NVARCHAR(008) =  CONVERT(VARCHAR(8), DATEADD(day, 364, '''+plan_name+'''), 112)'          
       AS [FOR_QUERY], 
                          N'      WHERE 0 = 0
       ' +  +'AND division_id         = '''+ DIVISION_ID+ ''    
         + '''' + CHAR(13) +'       AND plan_start_yyyymmdd = '''+ plan_name+ ''     
         + '''' + CHAR(13) +'       AND plan_type           = '''+ plan_type+ ''    
         + '''' + CHAR(13) +'       AND seq                 = '''+ CONVERT(NVARCHAR, plan_seq)      + ''    
         + '''' + CHAR(13) +'    -- AND item_id             = '''             
         + '''' + CHAR(13) +'    -- AND plan_cycle          = '''+ PLAN_CYCLE+ ''             
         + '''' + CHAR(13) +'    -- AND plan_id             = '''+ PLAN_ID+ ''  
         + '''' + CHAR(13) +'    -- AND modeling_id         = '''+ MODELING_ID + ''    
         + '''' + CHAR(13) +'    -- AND master_id           = '''+ master_id+ ''    
         + '''' + CHAR(13) +'    -- AND engine_plan_id      = '''+ ENG_PLAN_ID+ ''
       AS [FOR_WHERE_CLAUSE], 
         N' /* Ctrl+Shift+M 으로 프로시저명, @p_user_id명 입력하세요 '
         + '*/'
         + CHAR(13) +N'EXEC <sp,명,SCP00> --'
         + ''
         + '''' + CHAR(13) +'   @p_from_yyyymmdd       = '''+ plan_name+''       
         + '''' + CHAR(13) +' , @p_to_yyyymmdd         = '''+ CONVERT(VARCHAR(8),  DATEADD(DAY, 30, CONVERT(DATETIME, plan_name,112)), 112)+''       
         + '''' + CHAR(13) +' , @p_division_id         = '''+ DIVISION_ID+ ''      
         + '''' + CHAR(13) +' , @p_item_id             = '''+ +''      
         + '''' + CHAR(13) +' , @p_nick_name           = '''+ +''      
         + '''' + CHAR(13) +' , @p_from_site           = '''+ +''      
         + '''' + CHAR(13) +' , @p_to_site             = '''+ +''      
         + '''' + CHAR(13) +' , @p_plan_start_yyyymmdd = '''+ plan_name+ ''       
         + '''' + CHAR(13) +' , @p_plan_type           = '''+ plan_type+ ''      
         + '''' + CHAR(13) +' , @p_seq                 = '''+ CONVERT(NVARCHAR, plan_seq)      + ''      
         + '''' + CHAR(13) +' , @p_program_id          = '''+ +''      
         + '''' + CHAR(13) +' , @p_sheet_name          = '''+ +''      
         + '''' + CHAR(13) +' , @p_user_id             = ''<@p_user_id,NVARCHAR(100),>' 
         + '''' + CHAR(13) +' , @debug_mode             = ''T' 
         + '''' + CHAR(13) +' ' 
       AS [FOR_UI_PROCEDURE] ,             
       /*
          (
           SELECT count(*)  
             FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN X WITH (NOLOCK)  
            WHERE X.PLAN_ID       = sub.PLAN_ID 
              AND X.MODELING_ID   = sub.MODELING_ID 
              AND X.SEQ           = sub.plan_seq 
              AND X.PLAN_NAME     = sub.PLAN_NAME 
            AND X.MASTER_ID     = sub.MASTER_ID 
              AND X.OUT_VERSION_ID= sub.ENG_PLAN_ID 
   AND X.DIVISION_ID   = sub.DIVISION_ID 
              AND X.PLAN_TYPE     = sub.PLAN_TYPE
              UNION 
          SELECT count(*)  
             FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN X WITH (NOLOCK)  
            WHERE X.PLAN_ID       = sub.PLAN_ID 
              AND X.MODELING_ID   = sub.MODELING_ID 
              AND X.SEQ           = sub.plan_seq 
              AND X.PLAN_NAME     = sub.PLAN_NAME 
              AND X.MASTER_ID     = sub.MASTER_ID 
              AND X.OUT_VERSION_ID= sub.ENG_PLAN_ID 
              AND X.DIVISION_ID   = sub.DIVISION_ID 
              AND X.PLAN_TYPE     = sub.PLAN_TYPE
              ) AS CNT,
         */
          PLAN_CYCLE,       
                
          PLAN_ID,      
          MODELING_ID,       
          plan_seq,      
          plan_type,      
   
          DIVISION_ID,        
                
          plan_version_id  as plan_version_id,        
          CONFIRM_FLAG,        
          CONFIRM_USER,        
          CONFIRM_DATE,       
          UI_DISPLAY_YN,        
          ACTIVE_FLAG,        
          PLAN_STATUS, 
          CREATION_DATE,       
       case(plan_type) when 'PR' then 0 when 'MA' then 1 when 'SE' then 3 when 'FN' then 4 else 9 end as plan_type_order    
     from sub        
    where 1=1        
     and plan_name >= [dbo].[FN_GET_BUCKET_YYYYMMDD](-3) --2주전        
  order by plan_name desc, PLAN_CYCLE desc, ENG_PLAN_ID Desc    
; 





