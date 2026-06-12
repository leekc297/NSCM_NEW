-- Baseline — DMF0043 객체 STATUS + 인벤토리 (사내 Oracle 적용 전)
SELECT object_name, object_type, status
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND (object_name LIKE 'DMF0043%' OR object_name = 'PKG_DMF0043')
 ORDER BY object_type, object_name;
