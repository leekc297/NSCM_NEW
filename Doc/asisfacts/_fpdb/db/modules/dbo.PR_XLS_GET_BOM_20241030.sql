
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
   exec [dbo].[PR_XLS_GET_BOM] 'UC2'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_BOM_20241030]
    @p_apl_code                 nvarchar(max)  = 'UC1'

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

	declare @vt_model_flow table (
			TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
		  , MODEL_ID 				nvarchar(150)
		  , OPERATION_ID            nvarchar(50)
		  )
		  ;

	declare @vt_model_change table (
			TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
		  , MODEL_ID 				nvarchar(150)
		  , OPERATION_ID            nvarchar(50)
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

	    insert into @vt_model_change (operation_id, model_id)
		select distinct operation_id, model_id
		  from (
				select distinct 
				       operation_id, model_id
				  from fp_plan_model_change_m with(nolock)
				 where company_id			= @v_company_id
				   and division_id			= @v_division_id
				   and site_id				= @v_site_id
				   and plant_id				IN (@v_plant_id, @v_elec_plant_id)
				 union all
				select distinct
				       operation_id, model_id
				  from fp_plan_model_change_except_m with(nolock)
				 where company_id			= @v_company_id
				   and division_id			= @v_division_id
				   and site_id				= @v_site_id
				   and plant_id				IN (@v_plant_id, @v_elec_plant_id)
		       ) as T

 --select * from @vt_model_change

		insert into @vt_model_flow (model_id, operation_id)
		select distinct 
		       model_id
			 , operation_id
		  from (
		        -- 상위공정 기준
				select distinct
					   x.model_id
					 , ISNULL(case when operation_id = 'A5000' then 'E2000'
								   when operation_id = 'A8000' then 'A5000'
								   when operation_id = 'A9000' then 'A8000'
								   when operation_id = 'F6000' then 'A9000'
								   end, operation_id) as operation_id
				  from @vt_model_change as x
				 union all
				-- 자기공정 기준
				select distinct
					   x.model_id
					 , x.operation_id
				  from @vt_model_change as x
			   ) as T
		  ;

--select * from @vt_model_flow

		select x.company_id, x.division_id, x.site_id, x.plant_id, x.operation_id, x.ELEC, x.nick_name, x.model_id, RIGHT(x.nick_name,3) AS nick_name3, RIGHT(x.model_id,3) AS model_id3
		  into #dp_temp
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
		  		        join @vt_model_flow as mf
		  		     on sim.flow_id = mf.operation_id
		  		    and ct.model_id = mf.model_id
		          where 1 = 1
		            AND CT.company_id			= @v_company_id
		            AND CT.DIVISION_ID			= @v_division_id	
		            AND CT.SITE_ID				= @v_site_id	
		            AND CT.PLANT_ID				IN (@v_plant_id, @v_elec_plant_id) 
		            AND SIM.FLOW_ID				IN ('A5000', 'A8000', 'A9000')
		            AND ISNULL(SIM.ITEM_TYPE, 'H') IN ('P','Q','H')	
		            AND CT.ALT_PRIORITY			= 'Y'	
		            AND CT.MODEL_ID				LIKE 'AC%'
		          group by ct.company_id, ct.division_id, ct.site_id, ct.plant_id, sim.flow_id , sim.nick_name, substring(ct.parent_item_id, 4,2), ct.model_id
		          union all 
		         select ct.company_id, ct.division_id, ct.site_id, ct.plant_id, left(sim.flow_id,5) as operation_id, sim.nick_name
		        	  , case substring(ct.parent_item_id, 4,2) when 'AN' then 'Anode' when 'CA' then 'Cathode' else '-' end ELEC
		        	  , ct.model_id
		           from SCM_MODEL_COMP_TEMP as ct with(nolock)
		        	    join scm_item_m as sim with(nolock)
		             on ct.company_id			= sim.company_id
		            and ct.division_id		= sim.division_id
		            and ct.site_id			= sim.site_id
		            and ct.parent_item_id		= sim.item_id
		  		        join @vt_model_flow as mf
		  		     on left(sim.flow_id,5)	= mf.operation_id
		  		    and ct.model_id			= mf.model_id
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
			   ;

--select * from #dp_temp ;


		with WD_DATA AS (
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
			     + MODEL_ID3 AS KEYS
			     , MODEL_ID3
			  FROM #dp_temp 
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
			     + MODEL_ID3
			     , MODEL_ID3
        )
        SELECT 
			   KEYS 
             , REPLACE( STUFF((SELECT '@' + MODEL_ID3 FROM WD_DATA AS T2 WHERE T2.KEYS = T1.KEYS FOR XML PATH('')), 1, 1, '')
					   ,' ','') AS VAL
          FROM WD_DATA AS T1 
         GROUP BY KEYS 
                
		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()

	END CATCH


END

-- exec [dbo].[PR_XLS_GET_BOM] 'UC1'


