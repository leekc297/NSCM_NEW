
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
 * 2024.11.15   FP Pjt.         실적기준 추가
 *
 ex) 
   exec PR_XLS_GET_BOM_2 'UC1'
 */

create PROCEDURE [dbo].[PR_XLS_GET_BOM_2]
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
		  , COMPANY_ID              nvarchar(30)
		  , DIVISION_ID             nvarchar(30)
		  , SITE_ID                 nvarchar(30)
		  , ITEM_ID                 nvarchar(150)
		  , OPERATION_ID            nvarchar(50)
		  )
		  ;

	declare @vt_model_flow table (
			TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
		  , nick_name 				nvarchar(150)
		  , OPERATION_ID            nvarchar(50)
		  )
		  ;

	declare @vt_model_flow_result table (
			TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
		  , nick_name 				nvarchar(150)
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

	    insert into @vt_model_change (COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, OPERATION_ID)
		select distinct company_id, division_id, site_id, item_id, operation_id
		  from (
				select distinct 
				       company_id, division_id, site_id, item_id, operation_id
				  from fp_plan_model_change_m as x with(nolock)
				 where company_id			= @v_company_id
				   and division_id			= @v_division_id
				   and site_id				= @v_site_id
				   and plant_id				IN (@v_plant_id, @v_elec_plant_id)
				   and active_flag = 'Y'
				   and eff_end_date >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
				 union all
				select distinct 
				       company_id, division_id, site_id, item_id, operation_id
				  from fp_plan_model_change_except_m with(nolock)
				 where company_id			= @v_company_id
				   and division_id			= @v_division_id
				   and site_id				= @v_site_id
				   and plant_id				IN (@v_plant_id, @v_elec_plant_id)
		       ) as T

 --select * from @vt_model_change
 --return

		insert into @vt_model_flow (nick_name, operation_id)
		select distinct 
		       nick_name
			 , operation_id
		  from (
		        -- 상위공정 기준
				select distinct
				       y.nick_name
					 , ISNULL(case when x.operation_id = 'A5000' then 'E2000'
								   when x.operation_id = 'A7000' then 'A5000'
								   when x.operation_id = 'A9000' then 'A8000'
								   when x.operation_id = 'F6000' then 'A9000'
								   end, x.operation_id) as operation_id
				  from @vt_model_change as x
				       join scm_item_m as y with(nolock)
                    on x.company_id = y.company_id
				   and x.division_id = y.division_id
				   and x.site_id = y.site_id
				   and x.item_id = y.item_id
				 union all
				-- 자기공정 기준
				select distinct
					   y.nick_name
					 , x.operation_id
				  from @vt_model_change as x
				       join scm_item_m as y with(nolock)
                    on x.company_id = y.company_id
				   and x.division_id = y.division_id
				   and x.site_id = y.site_id
				   and x.item_id = y.item_id
				) as T
		  ;

		insert into @vt_model_flow_result (nick_name, operation_id)
		select distinct 
		       nick_name
			 , operation_id
		  from (
                -- 실적 기준
				select distinct y.nick_name, x.operation_id
				  FROM [dbo].[SCM_DAILY_PRODUCT_RESULT_H] as x with(nolock)
					   join scm_item_m as y with(nolock)
					on x.company_id = y.company_id
				   and x.division_id = y.division_id
				   and x.site_id = y.site_id
				   and x.item_id = y.item_id
				 where 1 = 1
				   and x.company_id = @v_company_id
				   and x.division_id = @v_division_id
				   and x.site_id = @v_site_id
				   and x.plant_id in (@v_plant_id, @v_elec_plant_id)
				   and x.operation_id in ('E2000', 'A5000',  'A8000', 'A9000', 'F6000')
				   and x.plan_date between format( getdate(), 'yyyy-MM') + '-01' and format( getdate(), 'yyyy-MM-dd') 
				   and x.production_type = 'MASS'
				) as T
		  ;

--select * from @vt_model_flow

-- exec [dbo].[PR_XLS_GET_BOM] 'UC1'

		select distinct 
		       x.company_id, x.division_id, x.site_id, x.plant_id, x.operation_id, x.ELEC, x.child_nick_name, x.model_id, RIGHT(x.child_nick_name,3) + case when x.ALT_PRIORITY is null then '' else '[' + cast(x.ALT_PRIORITY as varchar) + ']' end AS child_nick_name3, RIGHT(x.parent_nick_name,3) AS parent_nick_name3
		  into #dp_temp
		  from (
		         select BOM.company_id, BOM.division_id, BOM.site_id, BOM.plant_id, citem.flow_id as operation_id, citem.nick_name as child_nick_name, pitem.nick_name as parent_nick_name
		        	  , case substring(BOM.child_item_id, 4,2) when 'AN' then 'Anode' when 'CA' then 'Cathode' else '-' end ELEC
		        	  , BOM.model_id, cast(zbom.ALT_PRIORITY as int) as ALT_PRIORITY--, BOM.child_item_id
		           from SCM_MODEL_COMP_TEMP as bom with(nolock)
		        	    join scm_item_m as pitem with(nolock)
		             on BOM.company_id				= pitem.company_id
		            and BOM.division_id				= pitem.division_id
		            and BOM.site_id					= pitem.site_id
		            and BOM.parent_item_id			= pitem.item_id
					    join scm_item_m as citem with(nolock)
		             on BOM.company_id				= citem.company_id
		            and BOM.division_id				= citem.division_id
		            and BOM.site_id					= citem.site_id
		            and BOM.child_item_id			= citem.item_id
					    join scm_item_m as mitem with(nolock)
		             on BOM.company_id				= mitem.company_id
		            and BOM.division_id				= mitem.division_id
		            and BOM.site_id					= mitem.site_id
		            and BOM.model_id				= mitem.item_id
		  		        join @vt_model_flow as mf
		  		     on citem.FLOW_ID				= mf.operation_id
		  		    and citem.nick_name				= mf.nick_name
					    join @vt_model_change as mc
		  		     on citem.FLOW_ID				= mc.operation_id
					and BOM.child_item_id			= mc.item_id
					and BOM.company_id				= mc.company_id
					and BOM.division_id				= mc.division_id
					and BOM.site_id					= mc.site_id
					    join scm_bom_m as zbom with(nolock)
		             on BOM.company_id				= zbom.company_id
		            and BOM.division_id				= zbom.division_id
		            and BOM.site_id					= zbom.site_id
					and BOM.parent_item_id          = zbom.parent_item_id
		            and BOM.child_item_id			= zbom.child_item_id
					and zbom.eff_start_date <= getdate()
					and zbom.eff_end_date > getdate()
					AND zbom.STANDARD_FLAG  = 'Y'                                                                                                  
					AND zbom.ACTIVE_FLAG    = 'Y'  
		          where 1 = 1
		            AND BOM.company_id				= @v_company_id
		            AND BOM.DIVISION_ID				= @v_division_id	
		            AND BOM.SITE_ID					= @v_site_id	
		            AND BOM.PLANT_ID				IN (@v_plant_id, @v_elec_plant_id) 
		            AND citem.FLOW_ID				IN ('A5000', 'A8000', 'A9000')
		            AND ISNULL(citem.ITEM_TYPE, 'H') IN ('P','Q','H')	
		            --AND BOM.ALT_PRIORITY			= 'Y'	
		            AND BOM.MODEL_ID				LIKE 'AC%'
					and citem.nick_name not like '%-T%'
					and pitem.nick_name not like '%-T%'
					and mitem.nick_name not like '%-T%'
		          group by BOM.company_id, BOM.division_id, BOM.site_id, BOM.plant_id, citem.flow_id , citem.nick_name, pitem.nick_name, substring(BOM.child_item_id, 4,2), BOM.model_id, zbom.ALT_PRIORITY--, bom.child_item_id
				  union all
		         select BOM.company_id, BOM.division_id, BOM.site_id, BOM.plant_id, citem.flow_id as operation_id, citem.nick_name as child_nick_name, pitem.nick_name as parent_nick_name
		        	  , case substring(BOM.child_item_id, 4,2) when 'AN' then 'Anode' when 'CA' then 'Cathode' else '-' end ELEC
		        	  , BOM.model_id, cast(zbom.ALT_PRIORITY as int) as ALT_PRIORITY
		           from SCM_MODEL_COMP_TEMP as bom with(nolock)
		        	    join scm_item_m as pitem with(nolock)
		             on BOM.company_id				= pitem.company_id
		            and BOM.division_id				= pitem.division_id
		            and BOM.site_id					= pitem.site_id
		            and BOM.parent_item_id			= pitem.item_id
					    join scm_item_m as citem with(nolock)
		             on BOM.company_id				= citem.company_id
		            and BOM.division_id				= citem.division_id
		            and BOM.site_id					= citem.site_id
		            and BOM.child_item_id			= citem.item_id
					    join scm_item_m as mitem with(nolock)
		             on BOM.company_id				= mitem.company_id
		            and BOM.division_id				= mitem.division_id
		            and BOM.site_id					= mitem.site_id
		            and BOM.model_id				= mitem.item_id
		  		        join @vt_model_flow_result as mf
		  		     on citem.FLOW_ID				= mf.operation_id
		  		    and citem.nick_name				= mf.nick_name
					    join scm_bom_m as zbom with(nolock)
		             on BOM.company_id				= zbom.company_id
		            and BOM.division_id				= zbom.division_id
		            and BOM.site_id					= zbom.site_id
					and BOM.parent_item_id          = zbom.parent_item_id
		            and BOM.child_item_id			= zbom.child_item_id
					and zbom.eff_start_date <= getdate()
					and zbom.eff_end_date > getdate()
					AND zbom.STANDARD_FLAG  = 'Y'                                                                                                  
					AND zbom.ACTIVE_FLAG    = 'Y'  
		          where 1 = 1
		            AND BOM.company_id				= @v_company_id
		            AND BOM.DIVISION_ID				= @v_division_id	
		            AND BOM.SITE_ID					= @v_site_id	
		            AND BOM.PLANT_ID				IN (@v_plant_id, @v_elec_plant_id) 
		            AND citem.FLOW_ID				IN ('A5000', 'A8000', 'A9000')
		            AND ISNULL(citem.ITEM_TYPE, 'H') IN ('P','Q','H')	
		            --AND BOM.ALT_PRIORITY			= 'Y'	
		            AND BOM.MODEL_ID				LIKE 'AC%'
					and citem.nick_name not like '%-T%'
					and pitem.nick_name not like '%-T%'
					and mitem.nick_name not like '%-T%'
		          group by BOM.company_id, BOM.division_id, BOM.site_id, BOM.plant_id, citem.flow_id , citem.nick_name, pitem.nick_name, substring(BOM.child_item_id, 4,2), BOM.model_id, zbom.ALT_PRIORITY
				  union all 
		         select BOM.company_id, BOM.division_id, BOM.site_id, BOM.plant_id, left(citem.flow_id,5) as operation_id, citem.nick_name as child_nick_name, pitem.nick_name as parent_nick_name
		        	  , case substring(BOM.child_item_id, 4,2) when 'AN' then 'Anode' when 'CA' then 'Cathode' else '-' end ELEC
		        	  , BOM.model_id, cast(zbom.ALT_PRIORITY as int) as ALT_PRIORITY
		           from SCM_MODEL_COMP_TEMP as bom with(nolock)
		        	    join scm_item_m as pitem with(nolock)
		             on BOM.company_id				= pitem.company_id
		            and BOM.division_id				= pitem.division_id
		            and BOM.site_id					= pitem.site_id
		            and BOM.parent_item_id			= pitem.item_id
					    join scm_item_m as citem with(nolock)
		             on BOM.company_id				= citem.company_id
		            and BOM.division_id				= citem.division_id
		            and BOM.site_id					= citem.site_id
		            and BOM.child_item_id			= citem.item_id
					    join scm_item_m as mitem with(nolock)
		             on BOM.company_id				= mitem.company_id
		            and BOM.division_id				= mitem.division_id
		            and BOM.site_id					= mitem.site_id
		            and BOM.model_id				= mitem.item_id
		  		        join @vt_model_flow as mf
		  		     on left(citem.flow_id,5)		= mf.operation_id
		  		    and citem.nick_name				= mf.nick_name
					    join scm_bom_m as zbom with(nolock)
		             on BOM.company_id				= zbom.company_id
		            and BOM.division_id				= zbom.division_id
		            and BOM.site_id					= zbom.site_id
					and BOM.parent_item_id          = zbom.parent_item_id
		            and BOM.child_item_id			= zbom.child_item_id
					and zbom.eff_start_date <= getdate()
					and zbom.eff_end_date > getdate()
					AND zbom.STANDARD_FLAG  = 'Y'                                                                                                  
					AND zbom.ACTIVE_FLAG    = 'Y'  
		          where 1 = 1
		            and BOM.company_id				= @v_company_id
		            AND BOM.DIVISION_ID				= @v_division_id	
		            AND BOM.SITE_ID					= @v_site_id	
		            AND BOM.PLANT_ID				IN (@v_plant_id, @v_elec_plant_id) 
		            AND citem.FLOW_ID LIKE 'E2000%'
		            AND ISNULL(citem.ITEM_TYPE, 'H') IN ('P','Q','H')	
		            --AND BOM.ALT_PRIORITY = 'Y'
		            AND BOM.MODEL_ID LIKE 'AC%'
					and citem.nick_name not like '%-T%'
					and pitem.nick_name not like '%-T%'
					and mitem.nick_name not like '%-T%'
		          group by BOM.company_id, BOM.division_id, BOM.site_id, BOM.plant_id, left(citem.flow_id,5) , citem.nick_name, pitem.nick_name, substring(BOM.child_item_id, 4,2), BOM.model_id, zbom.ALT_PRIORITY

		       ) as x
			   ;

--select * from #dp_temp ;
--return;

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

-- exec PR_XLS_GET_BOM 'UC1'


