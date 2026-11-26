select distinct
        a.LEVEL_1_CODE as code
              ,'(' + a.LEVEL_1_CODE + ')' + a.LEVEL_1_NAME as name
       from   scm_item_class_m a(NOLOCK)
       where  a.use_flag='Y'
       order by code