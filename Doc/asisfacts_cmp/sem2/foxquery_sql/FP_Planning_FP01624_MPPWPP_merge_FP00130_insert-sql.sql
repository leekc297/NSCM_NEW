begin
        begin tran
          merge into scm_equipment_m AS A
          using (select RTRIM(LTRIM(@COMPANY_ID)) as company_id, RTRIM(LTRIM(@DIVISION_ID)) as division_id, RTRIM(LTRIM(@SITE_ID)) as site_id, RTRIM(LTRIM(@PLANT_ID)) as plant_id, RTRIM(LTRIM(@FACTORY_ID)) as factory_id
                      , RTRIM(LTRIM(@EQUIPMENT_ID)) as equipment_id) AS B
            on (a.company_id    = b.company_id
            and a.division_id   = b.division_id
            and a.site_id       = b.site_id
            and a.plant_id      = b.plant_id
            and a.factory_id    = b.factory_id
            and a.equipment_id  = b.equipment_id)
          when matched then 
            update set 
              update_id      = @USER_ID
             ,update_time    = dbo.SYSDATE1()
 			       ,line_id        = RTRIM(LTRIM(@LINE_ID))
  			     ,electrode_type = RTRIM(LTRIM(@ELECTRODE_TYPE))
  			     ,line_type      = RTRIM(LTRIM(@LINE_TYPE))
  			     ,active_flag    = upper(RTRIM(LTRIM(@ACTIVE_FLAG)))
          when not matched then 
            insert (
               COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID
              ,EQUIPMENT_ID,EQUIPMENT_NAME
              ,OPERATION_ID,LINE_ID
              ,MES_LINE_ID,WORK_CENTER_ID
              ,EQUIPMENT_TYPE,ELECTRODE_TYPE
              ,LINE_TYPE
              ,ACTIVE_FLAG
              ,DESCRIPTION
              ,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
            ) values (
               RTRIM(LTRIM(@COMPANY_ID))     ,RTRIM(LTRIM(@DIVISION_ID))    ,RTRIM(LTRIM(@SITE_ID)),RTRIM(LTRIM(@PLANT_ID)),RTRIM(LTRIM(@FACTORY_ID))
              ,RTRIM(LTRIM(@EQUIPMENT_ID))   ,RTRIM(LTRIM(@EQUIPMENT_NAME))
              ,RTRIM(LTRIM(@OPERATION_ID))   ,RTRIM(LTRIM(@LINE_ID))
              ,RTRIM(LTRIM(@MES_LINE_ID))    ,RTRIM(LTRIM(@WORK_CENTER_ID))
              ,RTRIM(LTRIM(@EQUIPMENT_TYPE)) ,RTRIM(LTRIM(@ELECTRODE_TYPE))
              ,RTRIM(LTRIM(@LINE_TYPE))
              ,upper(RTRIM(LTRIM(@ACTIVE_FLAG)))
              ,RTRIM(LTRIM(@DESCRIPTION))
              ,@USER_ID,dbo.SYSDATE1(),@USER_ID,dbo.SYSDATE1()
            )
          ;
          
        commit;
        
        begin tran
          insert into his_equipment_m (
                 COMPANY_ID
                ,DIVISION_ID
                ,SITE_ID
                ,PLANT_ID
                ,FACTORY_ID
                ,EQUIPMENT_ID
                ,EQUIPMENT_NAME
                ,OPERATION_ID
                ,LINE_ID
                ,MES_LINE_ID
                ,WORK_CENTER_ID
                ,EQUIPMENT_TYPE
                ,ELECTRODE_TYPE
                ,LINE_TYPE
                ,ACTIVE_FLAG
                ,DESCRIPTION
                ,INSERT_ID
                ,INSERT_TIME
                ,UPDATE_ID
                ,UPDATE_TIME
                ,JOB_USER_ID
                ,JOB_TIME
                ,JOB_TYPE
          )
          select COMPANY_ID
                ,DIVISION_ID
                ,SITE_ID
                ,PLANT_ID
                ,FACTORY_ID
                ,EQUIPMENT_ID
                ,EQUIPMENT_NAME
                ,OPERATION_ID
                ,LINE_ID
                ,MES_LINE_ID
                ,WORK_CENTER_ID
                ,EQUIPMENT_TYPE
                ,ELECTRODE_TYPE
                ,LINE_TYPE
                ,ACTIVE_FLAG
                ,DESCRIPTION
                ,INSERT_ID
                ,INSERT_TIME
                ,UPDATE_ID
                ,UPDATE_TIME
                ,@USER_ID as JOB_USER_ID
                ,dbo.sysdate1() as JOB_TIME
                ,'EXCEL' as JOB_TYPE
          from   scm_equipment_m A(NOLOCK)
    			where  company_id   = RTRIM(LTRIM(@COMPANY_ID))
    			and    division_id  = RTRIM(LTRIM(@DIVISION_ID))
    			and    site_id      = RTRIM(LTRIM(@SITE_ID))
    			and    plant_id     = RTRIM(LTRIM(@PLANT_ID))
    			and    factory_id   = RTRIM(LTRIM(@FACTORY_ID))
    			AND    equipment_id = RTRIM(LTRIM(@EQUIPMENT_ID))
          ;
        
        commit;
      end;