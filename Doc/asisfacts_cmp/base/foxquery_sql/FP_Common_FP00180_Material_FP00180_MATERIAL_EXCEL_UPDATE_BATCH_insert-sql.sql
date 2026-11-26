begin
        begin tran
          merge into scm_item_m AS A
          using (select RTRIM(LTRIM(@COMPANY_ID)) as company_id, RTRIM(LTRIM(@DIVISION_ID)) as division_id, RTRIM(LTRIM(@SITE_ID)) as site_id
                      , @ITEM_ID as item_id) AS B
            on (a.company_id  = b.company_id
            and a.division_id = b.division_id
            and a.site_id     = b.site_id
            and a.item_id     = b.item_id)
          when matched then
            update set 
               update_id          = @USER_ID
              ,update_time        = dbo.sysdate1()
              ,demand_lot_size    = RTRIM(LTRIM(@DEMAND_LOT_SIZE))
              ,item_attribute     = RTRIM(LTRIM(@ITEM_ATTRIBUTE))
              ,setup_attribute    = RTRIM(LTRIM(@SETUP_ATTRIBUTE))
              ,FORM_ATTRIBUTE     = RTRIM(LTRIM(@FORM_ATTRIBUTE))
          when not matched then
            insert (
               company_id, division_id, site_id
              ,item_id, item_name, nick_name
              ,item_type
              ,item_class, item_class_name
              ,material_class, material_class_name
              ,electrode_type, side_type, item_group_id
              ,setup_group_id_1, setup_group_id_2, setup_group_id_3
              ,flow_id
              ,erp_eol, scp_eol
              ,item_uom, spec, demand_lot_size
              ,item_attribute, setup_attribute
              ,outsourcing_factory
              ,finite_term, finite_term_uom
              ,description, active_flag, MAKE_AND_BUY
              ,insert_id,insert_time,update_id,update_time
              ,FORM_ATTRIBUTE
            ) values (
               RTRIM(LTRIM(@COMPANY_ID)),RTRIM(LTRIM(@DIVISION_ID)),RTRIM(LTRIM(@SITE_ID))
              ,RTRIM(LTRIM(@ITEM_ID)),RTRIM(LTRIM(@ITEM_NAME)),RTRIM(LTRIM(@NICK_NAME))
              ,RTRIM(LTRIM(@ITEM_TYPE))
              ,RTRIM(LTRIM(@ITEM_CLASS)), RTRIM(LTRIM(@ITEM_CLASS_NAME))
              ,RTRIM(LTRIM(@MATERIAL_CLASS)), RTRIM(LTRIM(@MATERIAL_CLASS_NAME))
              ,RTRIM(LTRIM(@ELECTRODE_TYPE)), RTRIM(LTRIM(@SIDE_TYPE)), RTRIM(LTRIM(@ITEM_GROUP_ID))
              ,RTRIM(LTRIM(@SETUP_GROUP_ID_1)), RTRIM(LTRIM(@SETUP_GROUP_ID_2)), RTRIM(LTRIM(@SETUP_GROUP_ID_3))
              ,RTRIM(LTRIM(@FLOW_ID))
              ,RTRIM(LTRIM(@ERP_EOL)), RTRIM(LTRIM(@SCP_EOL))
              ,UPPER(RTRIM(LTRIM(@ITEM_UOM))), RTRIM(LTRIM(@SPEC)), RTRIM(LTRIM(@DEMAND_LOT_SIZE))
              ,RTRIM(LTRIM(@ITEM_ATTRIBUTE)), RTRIM(LTRIM(@SETUP_ATTRIBUTE))
              ,RTRIM(LTRIM(@OUTSOURCING_FACTORY))
              ,RTRIM(LTRIM(@FINITE_TERM)), RTRIM(LTRIM(@FINITE_TERM_UOM))
              ,RTRIM(LTRIM(@DESCRIPTION)), isnull(RTRIM(LTRIM(@ACTIVE_FLAG)), 'Y'), RTRIM(LTRIM(@MAKE_AND_BUY))
              ,@USER_ID,dbo.SYSDATE1(),@USER_ID,dbo.SYSDATE1()
              ,RTRIM(LTRIM(@FORM_ATTRIBUTE))
            )
          ;
          
        commit;
        
 begin tran
          insert into his_item_m (
                 company_id, division_id, site_id
                ,item_id, item_name, nick_name
                ,item_type
                ,item_class, item_class_name
                ,material_class, material_class_name
                ,electrode_type, side_type, item_group_id
                ,setup_group_id_1, setup_group_id_2, setup_group_id_3
                ,flow_id
                ,erp_eol, scp_eol
                ,item_uom, spec, demand_lot_size
                ,item_attribute, setup_attribute
                ,outsourcing_factory
                ,finite_term, finite_term_uom
                ,description, active_flag
                ,insert_id,insert_time,update_id,update_time
                ,JOB_USER_ID,JOB_TIME,JOB_TYPE
				        ,BATCH_RATIO_ID, MAKE_AND_BUY
				        ,FORM_ATTRIBUTE
          )
          select company_id, division_id, site_id
                ,item_id, item_name, nick_name
                ,item_type
                ,item_class, item_class_name
                ,material_class, material_class_name
                ,electrode_type, side_type, item_group_id
                ,setup_group_id_1, setup_group_id_2, setup_group_id_3
                ,flow_id
                ,erp_eol, scp_eol
                ,item_uom, spec, demand_lot_size
                ,item_attribute, setup_attribute
                ,outsourcing_factory
                ,finite_term, finite_term_uom
                ,description, active_flag
                ,insert_id,insert_time,update_id,update_time
                ,@USER_ID as JOB_USER_ID,dbo.sysdate1() as JOB_TIME,'EXCEL' as JOB_TYPE
				        ,BATCH_RATIO_ID, MAKE_AND_BUY
				        ,FORM_ATTRIBUTE
          FROM   SCM_ITEM_M A WITH(NOLOCK)
          WHERE  A.COMPANY_ID   = RTRIM(LTRIM(@COMPANY_ID))
          AND    A.DIVISION_ID  = RTRIM(LTRIM(@DIVISION_ID))
          AND    A.SITE_ID      = RTRIM(LTRIM(@SITE_ID))
          AND    A.ITEM_ID      = RTRIM(LTRIM(@ITEM_ID))
          ;
        
        commit;
      end;