
/*
 * Program ID   : PR_XLS_GET_BOM
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.08.01   FP Pjt.         Create.
 * 2024.10.16   FP Pjt.         피벗처리.
 * 2024.10.30   FP Pjt.         model_id3 -> parent_nick_name3
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_BOM] 'UC1'
 */

create PROCEDURE [dbo].[PR_XLS_GET_BOM_20241031]
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


	declare @vt_model_change table (
			TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
		  , MODEL_ID 				nvarchar(150)
		  , OPERATION_ID            nvarchar(50)
		  , ITEM_ID                 nvarchar(150)
		  )
		  ;

	declare @vt_model_flow table (
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

	    insert into @vt_model_change (operation_id, model_id, item_id)
		select distinct operation_id, model_id, item_id
		  from (
				select distinct 
				       operation_id, model_id, item_id
				  from fp_plan_model_change_m with(nolock)
				 where company_id			= @v_company_id
				   and division_id			= @v_division_id
				   and site_id				= @v_site_id
				   and plant_id				IN (@v_plant_id, @v_elec_plant_id)
				 union all
				select distinct
				       operation_id, model_id, item_id
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

-- exec [dbo].[PR_XLS_GET_BOM] 'UC1'

		select x.company_id, x.division_id, x.site_id, x.plant_id, x.operation_id, x.ELEC, x.child_nick_name, x.model_id, RIGHT(x.child_nick_name,3) AS child_nick_name3, RIGHT(x.parent_nick_name,3) AS parent_nick_name3
		  into #dp_temp
		  from (
		         select child.company_id, child.division_id, child.site_id, child.plant_id, citem.flow_id as operation_id, citem.nick_name as child_nick_name, pitem.nick_name as parent_nick_name
		        	  , case substring(child.child_item_id, 4,2) when 'AN' then 'Anode' when 'CA' then 'Cathode' else '-' end ELEC
		        	  , child.model_id
		           from SCM_MODEL_COMP_TEMP as child with(nolock)
		        	    join scm_item_m as pitem with(nolock)
		             on child.company_id			= pitem.company_id
		            and child.division_id			= pitem.division_id
		            and child.site_id				= pitem.site_id
		            and child.parent_item_id		= pitem.item_id
					    join scm_item_m as citem with(nolock)
		             on child.company_id			= citem.company_id
		            and child.division_id			= citem.division_id
		            and child.site_id				= citem.site_id
		            and child.child_item_id			= citem.item_id
		  		        join @vt_model_flow as mf
		  		     on citem.FLOW_ID				= mf.operation_id
		  		    and child.model_id				= mf.model_id
					    join @vt_model_change as mc
		  		     on citem.FLOW_ID				= mc.operation_id
		  		    and child.model_id				= mc.model_id
					and child.child_item_id         = mc.item_id
		          where 1 = 1
		            AND child.company_id			= @v_company_id
		            AND child.DIVISION_ID			= @v_division_id	
		            AND child.SITE_ID				= @v_site_id	
		            AND child.PLANT_ID				IN (@v_plant_id, @v_elec_plant_id) 
		            AND citem.FLOW_ID				IN ('A5000', 'A8000', 'A9000')
		            AND ISNULL(citem.ITEM_TYPE, 'H') IN ('P','Q','H')	
		            --AND child.ALT_PRIORITY			= 'Y'	
		            AND child.MODEL_ID				LIKE 'AC%'
		          group by child.company_id, child.division_id, child.site_id, child.plant_id, citem.flow_id , citem.nick_name, pitem.nick_name, substring(child.child_item_id, 4,2), child.model_id
		          union all 
		         select child.company_id, child.division_id, child.site_id, child.plant_id, left(citem.flow_id,5) as operation_id, citem.nick_name as child_nick_name, pitem.nick_name as parent_nick_name
		        	  , case substring(child.child_item_id, 4,2) when 'AN' then 'Anode' when 'CA' then 'Cathode' else '-' end ELEC
		        	  , child.model_id
		           from SCM_MODEL_COMP_TEMP as child with(nolock)
		        	    join scm_item_m as pitem with(nolock)
		             on child.company_id			= pitem.company_id
		            and child.division_id			= pitem.division_id
		            and child.site_id				= pitem.site_id
		            and child.parent_item_id			= pitem.item_id
					    join scm_item_m as citem with(nolock)
		             on child.company_id			= citem.company_id
		            and child.division_id			= citem.division_id
		            and child.site_id				= citem.site_id
		            and child.child_item_id			= citem.item_id
		  		        join @vt_model_flow as mf
		  		     on left(citem.flow_id,5)		= mf.operation_id
		  		    and child.model_id				= mf.model_id
		          where 1 = 1
		            and child.company_id			= @v_company_id
		            AND child.DIVISION_ID			= @v_division_id	
		            AND child.SITE_ID				= @v_site_id	
		            AND child.PLANT_ID				IN (@v_plant_id, @v_elec_plant_id) 
		            AND citem.FLOW_ID LIKE 'E2000%'
		            AND ISNULL(citem.ITEM_TYPE, 'H') IN ('P','Q','H')	
		            --AND child.ALT_PRIORITY = 'Y'
		            AND child.MODEL_ID LIKE 'AC%'
		          group by child.company_id, child.division_id, child.site_id, child.plant_id, left(citem.flow_id,5) , citem.nick_name, pitem.nick_name, substring(child.child_item_id, 4,2), child.model_id
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
			     + child_nick_name3 AS KEYS
			     , parent_nick_name3
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
			     + child_nick_name3
			     , parent_nick_name3
        )
        SELECT 
			   KEYS 
             , REPLACE( STUFF((SELECT '@' + parent_nick_name3 FROM WD_DATA AS T2 WHERE T2.KEYS = T1.KEYS FOR XML PATH('')), 1, 1, '')
					   ,' ','') AS VAL
          FROM WD_DATA AS T1 
         GROUP BY KEYS 

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()

	END CATCH


END

-- exec [dbo].[PR_XLS_GET_BOM] 'UC2'


