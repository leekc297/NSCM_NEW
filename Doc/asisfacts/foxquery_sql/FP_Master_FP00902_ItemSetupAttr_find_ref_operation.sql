SELECT a.company_id, a.division_id, a.site_id, a.operation_id ,a.operation_name  
                       ,a.operation_group_id, a.operation_group_name  
                       ,a.operation_id as CODE, '(' + a.operation_id + ')' + a.operation_name as NAME  
                 FROM   scm_operation_m a(NOLOCK), (  
                           SELECT b.company_id,b.division_id,b.site_id  
                           FROM th_uis_user_factory_relate a(NOLOCK), th_uis_role_factory_relate b(NOLOCK)  
                           WHERE A.USER_ID = @USER_ID  
                           AND   A.ROLE_ID = B.ROLE_ID  
                           AND   A.USE_AT_FLAG = 'Y'  
                           AND   B.USE_AT_FLAG = 'Y'  
                           GROUP BY b.company_id,b.division_id,b.site_id  
                        ) aa  
                 WHERE a.company_id = aa.company_id  
                 AND   a.division_id = aa.division_id  
                 AND   a.site_id = aa.site_id  
                 AND   a.active_flag = 'Y'  
                 ORDER BY a.operation_group_id, a.operation_id desc