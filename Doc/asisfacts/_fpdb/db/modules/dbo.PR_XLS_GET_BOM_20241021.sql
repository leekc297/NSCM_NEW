
/*
 * Program ID   : PR_XLS_GET_BOM
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.08.01   FP Pjt.         Create.
 * 2024.10.16   FP Pjt.         피벗처리.
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_BOM] 'UC1'
 */

create PROCEDURE [dbo].[PR_XLS_GET_BOM_20241021]
    @p_apl_code                 nvarchar(max)  = 'UC1'
--,	@p_yyyymm_from			NVARCHAR(MAX)
--,	@p_yyyymm_to			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_apl_code				NVARCHAR(MAX)
	DECLARE @v_yyyymm_from			nvarchar(max)
	DECLARE @v_yyyymm_to			nvarchar(max)

	declare	@v_company_id			nvarchar(50)
	declare	@v_division_id			NVARCHAR(50) 
	declare	@v_site_id				nvarchar(50)
	declare	@v_plant_id				nvarchar(50)
	declare @v_elec_plant_id		nvarchar(50)

	set @v_apl_code			= @p_apl_code
	--set @v_yyyymm_from		= @p_yyyymm_from --format( convert(datetime, @p_yyyymmdd_rom), 'yyyyMMdd')
	--set @v_yyyymm_to		= @p_yyyymm_to --format( convert(datetime, @p_cutoff_date_to), 'yyyyMMdd')

	if object_id('tempdb..#model_flow') is not null
		drop table #model_flow

	create table #model_flow (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
			, OPERATION_ID              nvarchar(50)
			, MODEL_ID 					nvarchar(150)
			, FROM_OPERATION_ID           nvarchar(50)
			)
			;

	BEGIN TRY	
	
		select @v_company_id		= attribute1
			 , @v_division_id		= attribute2
			 , @v_site_id			= attribute3
			 , @v_plant_id			= attribute4
			 , @v_elec_plant_id		= attribute5
		  from dbo.SCM_SYS_LOOKUP_VALUE with(nolock)
		 where lookup_type_code = 'XLS_PLAN_APL_PLANT'
		   and segment1 = @v_apl_code
		   and active_flag = 'Y'

		insert into #model_flow (operation_id, model_id, from_operation_id)
		select operation_id
		     , x.model_id
		     , case when operation_id = 'A5000' then 'E2000'
			        when operation_id = 'A8000' then 'A5000'
					when operation_id = 'A9000' then 'A8000'
					when operation_id = 'F6000' then 'A9000'
					end as from_operation_id
		  from (
			  select distinct operation_id, model_id as model_id
				from fp_plan_model_change_m with(nolock)
			   where company_id			= @v_company_id
				 and division_id		= @v_division_id
				 and site_id			= @v_site_id
				 and plant_id			IN (@v_plant_id, @v_elec_plant_id)
			   union
			  select distinct operation_id, model_id as model_id
				from fp_plan_model_change_except_m with(nolock)
				where company_id		= @v_company_id
				and division_id			= @v_division_id
				and site_id				= @v_site_id
				and plant_id			IN (@v_plant_id, @v_elec_plant_id)
			  ) as x
			  ;

/*
		SELECT CT.COMPANY_ID			
		     , MAX(CT.DIVISION_ID) AS DIVISION_ID			
		     , CT.SITE_ID 			
		     , CT.PLANT_ID			
		     , MAX(CT.FLOW_ID)     AS FLOW_ID			
		     , MAX(CT.ELEC) AS ELEC			
		     , MAX(CT.NICK_NAME)   AS NICK_NAME			
		     , CT.MODEL_ID AS FIN_MODEL			
		  FROM (			
		       SELECT CT.COMPANY_ID			
		            , CT.DIVISION_ID			
		            , CT.SITE_ID 			
		            , CT.MODEL_ID			
		            , CT.PLANT_ID			
		            , CT.CHILD_ITEM_ID			
		            , SI.ITEM_NAME			
		            , SI.NICK_NAME			
		            , SI.DESCRIPTION			
		            , SI.ITEM_TYPE			
		            , SI.ITEM_CLASS			
		            , CASE WHEN  SI.ITEM_CLASS_NAME LIKE '%Anode%' THEN 'Anode'			
		                   WHEN SI.ITEM_CLASS_NAME LIKE '%Cathode%' THEN 'Cathode'			
		                   ELSE '-' END AS ELEC			
		            , SUBSTRING(SI.FLOW_ID,1,5) AS FLOW_ID			
		            , SI.ITEM_UOM			
		            , CT.SORT_ORDER			
		            , CT.ACCUMULATED_CHILD_QTY			
		            , CT.CHILD_QTY			
		            , CT.ALT_PRIORITY			
		            , CT.NLEVEL			
		            , CT.INSERT_TIME			
		            , (
					  SELECT TOP 1 'Y'			
		                FROM  SCM_MODEL_COMP_TEMP CK WITH(NOLOCK)			
		               WHERE CK.COMPANY_ID     = CT.COMPANY_ID			
		                 AND CK.DIVISION_ID    = CT.DIVISION_ID			
		                 AND CK.SITE_ID        = CT.SITE_ID			
		                 AND CK.MODEL_ID       = CT.MODEL_ID			
		                 AND CK.PLANT_ID       = CT.PLANT_ID			
		                 AND CK.PARENT_ITEM_ID = CT.PARENT_ITEM_ID			
		                 AND CK.ALT_ID         = CT.ALT_ID			
		                 AND CK.ALT_PRIORITY  IS NULL
					  ) AS CHECK_ALT			
		         FROM SCM_MODEL_COMP_TEMP CT WITH(NOLOCK)			
		            , SCM_ITEM_M  SI WITH(NOLOCK)			
		            , SCM_ITEM_CLASS_M IC WITH(NOLOCK)			
		        WHERE CT.CHILD_COMPANY_ID  = SI.COMPANY_ID			
		          AND CT.CHILD_DIVISION_ID = SI.DIVISION_ID			
		          AND CT.CHILD_SITE_ID     = SI.SITE_ID			
		          AND CT.CHILD_ITEM_ID     = SI.ITEM_ID			
		          AND SI.ITEM_CLASS        = IC.CLASS_ID			
		          AND IC.USE_FLAG          = 'Y'			
		          AND CT.DIVISION_ID = N'81_UC' 			
		          AND CT.SITE_ID = N'A003' 			
		          AND CT.PLANT_ID IN (N'G671',N'G672') 			
		          AND SUBSTRING(SI.FLOW_ID,1,5) in ('E2000','A5000','A8000','A9000')			
		          AND ISNULL(SI.ITEM_TYPE,'H') IN ('P','Q','H')			
		          AND CT.ALT_PRIORITY = 'Y'			
		       )  CT	
			   where (CT.FLOW_ID)  = 'E2000'
			   and ct.nick_name = 'E101A-140'
		 GROUP BY CT.COMPANY_ID ,CT.SITE_ID ,CT.MODEL_ID ,CT.PLANT_ID ,CT.CHILD_ITEM_ID			
		 ORDER BY CT.COMPANY_ID ,CT.SITE_ID ,CT.MODEL_ID ,CT.PLANT_ID ,MIN(CT.NLEVEL) ,MIN(CT.INSERT_TIME) ,CT.CHILD_ITEM_ID			
*/      
        with WD as (
		    select x.company_id, x.division_id, x.site_id, x.plant_id, x.operation_id, x.ELEC, x.nick_name, x.model_id, RIGHT(x.nick_name,3) AS nick_name3, RIGHT(x.model_id,3) AS model_id3
		      from (
		           select ct.company_id, ct.division_id, ct.site_id, ct.plant_id, sim.flow_id as operation_id, sim.nick_name
		       	        , case substring(ct.parent_item_id, 4,2) when 'AN' then 'Anode' when 'CA' then 'Cathode' else '-' end ELEC
		       	        , ct.model_id
		             from SCM_MODEL_COMP_TEMP as ct with(nolock)
		       	          join scm_item_m as sim with(nolock)
		               on ct.company_id = sim.company_id
		              and ct.division_id = sim.division_id
		              and ct.site_id = sim.site_id
		              and ct.parent_item_id = sim.item_id
					      join #model_flow as mf
					   on sim.flow_id = mf.from_operation_id
					  and ct.model_id = mf.model_id
		            where 1 = 1
		              and CT.company_id		= @v_company_id
		              AND CT.DIVISION_ID	= @v_division_id	
		              AND CT.SITE_ID		= @v_site_id	
		              AND CT.PLANT_ID		IN (@v_plant_id, @v_elec_plant_id) 
		              AND SIM.FLOW_ID		IN ('A5000', 'A8000', 'A9000')
		              AND ISNULL(SIM.ITEM_TYPE, 'H') IN ('P','Q','H')	
		              AND CT.ALT_PRIORITY = 'Y'	
		              AND CT.MODEL_ID LIKE 'AC%'
		            group by ct.company_id, ct.division_id, ct.site_id, ct.plant_id, sim.flow_id , sim.nick_name, substring(ct.parent_item_id, 4,2), ct.model_id
		            union all 
		           select ct.company_id, ct.division_id, ct.site_id, ct.plant_id, left(sim.flow_id,5) as operation_id, sim.nick_name
		       	        , case substring(ct.parent_item_id, 4,2) when 'AN' then 'Anode' when 'CA' then 'Cathode' else '-' end ELEC
		       	        , ct.model_id
		             from SCM_MODEL_COMP_TEMP as ct with(nolock)
		       	          join scm_item_m as sim with(nolock)
		               on ct.company_id = sim.company_id
		              and ct.division_id = sim.division_id
		              and ct.site_id = sim.site_id
		              and ct.parent_item_id = sim.item_id
					      join #model_flow as mf
					   on left(sim.flow_id,5) = mf.from_operation_id
					  and ct.model_id = mf.model_id
		            where 1 = 1
		              and CT.company_id		= @v_company_id
		              AND CT.DIVISION_ID	= @v_division_id	
		              AND CT.SITE_ID		= @v_site_id	
		              AND CT.PLANT_ID		IN (@v_plant_id, @v_elec_plant_id) 
		              AND SIM.FLOW_ID LIKE 'E2000%'
		              AND ISNULL(SIM.ITEM_TYPE, 'H') IN ('P','Q','H')	
		              AND CT.ALT_PRIORITY = 'Y'
		              AND CT.MODEL_ID LIKE 'AC%'
		            group by ct.company_id, ct.division_id, ct.site_id, ct.plant_id, left(sim.flow_id,5) , sim.nick_name, substring(ct.parent_item_id, 4,2), ct.model_id

		           ) as x
                   )
           , WD_DATA AS (
                     SELECT 
                        CASE WHEN OPERATION_ID = 'A5000' THEN 'Notching'
                            WHEN OPERATION_ID = 'A8000' THEN 'L&S'
                            WHEN OPERATION_ID = 'A9000' THEN 'PKG'
                            WHEN OPERATION_ID = 'E2000' THEN 'Coating'
                            WHEN OPERATION_ID = 'F6000' THEN 'EOL'
                            ELSE OPERATION_ID
                            END
                        + CASE WHEN ELEC ='-' THEN '' 
                            ELSE ' (' + ELEC + ')'
                          END 
                         + NICK_NAME3 AS KEYS
                         , MODEL_ID3
                    FROM WD 
                        GROUP BY 
                         CASE WHEN OPERATION_ID = 'A5000' THEN 'Notching'
                            WHEN OPERATION_ID = 'A8000' THEN 'L&S'
                            WHEN OPERATION_ID = 'A9000' THEN 'PKG'
                            WHEN OPERATION_ID = 'E2000' THEN 'Coating'
                            WHEN OPERATION_ID = 'F6000' THEN 'EOL'
                            ELSE OPERATION_ID
                            END
                        + CASE WHEN ELEC ='-' THEN '' 
                            ELSE ' (' + ELEC + ')'
                          END 
                         + NICK_NAME3
                         , MODEL_ID3
        )
        SELECT 
            KEYS 
            , REPLACE(STUFF((
                SELECT '@' + MODEL_ID3 FROM WD_DATA AS T2
                WHERE T2.KEYS = T1.KEYS
                FOR XML PATH('')),1,1,''),' ','') AS VAL
                FROM WD_DATA AS T1 
                GROUP BY KEYS 
                
		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()

		--if object_id('tempdb..#yield') is not null
		--	drop table #yield

	END CATCH

	if object_id('tempdb..#model_flow') is not null
	drop table #model_flow

END

-- exec [dbo].[PR_XLS_GET_BOM] 'UC1'


