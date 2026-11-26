SELECT a.segment1 as CODE, a.segment1 as NAME
                ,a.segment1,a.segment2,a.segment3,a.segment4,a.segment5
                ,a.sort_order                                
                FROM   scm_sys_lookup_value a WITH(NOLOCK)        
                WHERE  a.lookup_type_code = 'SETUP_CATEGORY' 
                AND    a.active_flag='Y'                   
                ORDER BY a.sort_order