SELECT a.level_code as CODE, '(' + a.level_code + ')' + a.level_name as NAME  
                ,a.level , a.operation_group_id, a.operation_group_name 
                FROM   scm_item_class_level_m a(NOLOCK) 
                WHERE  a.use_flag = 'Y'
                AND    a.level = '2' 
                ORDER BY CODE