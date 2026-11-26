select distinct
   '(' + a.LEVEL_1_CODE + ')' + a.LEVEL_1_NAME as class1code,
   '(' + a.LEVEL_2_CODE + ')' + a.LEVEL_2_NAME as class2code,
        a.LEVEL_1_CODE as LEVEL_1_CODE
              , a.LEVEL_1_NAME as LEVEL_1_NAME,
        a.LEVEL_2_CODE as LEVEL_2_CODE
              , a.LEVEL_2_NAME as LEVEL_2_NAME
       from   scm_item_class_m a(NOLOCK)
       where  a.use_flag='Y'
       order by LEVEL_1_CODE,LEVEL_2_CODE