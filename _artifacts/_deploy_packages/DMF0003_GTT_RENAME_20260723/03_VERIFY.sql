-- [DMF0003 GTT RENAME 20260723] 배포 후 검증
-- 1) 패키지 VALID
SELECT object_type, status FROM user_objects WHERE object_name='PKG_DMF0003';
-- 2) errors 0
SELECT line, position, text FROM user_errors WHERE name='PKG_DMF0003' ORDER BY sequence;
-- 3) 신명칭 GTT 40종 존재
SELECT COUNT(*) AS gt_dmf0003_cnt FROM user_tables
 WHERE temporary='Y' AND table_name LIKE 'GT_DMF0003_%';
-- 4) body 내 구명 실참조 0 (마커/주석 제외 근사)
SELECT COUNT(*) AS old_ref_cnt FROM user_source
 WHERE name='PKG_DMF0003' AND type='PACKAGE BODY'
   AND (REGEXP_LIKE(text,'GT_GGET_[A-Z]') OR REGEXP_LIKE(text,'GT_MFCP_[A-Z]') OR REGEXP_LIKE(text,'GT_SAVEPK_[A-Z]'));
-- 5) 마커
SELECT COUNT(*) AS marker FROM user_source
 WHERE name='PKG_DMF0003' AND type='PACKAGE BODY' AND text LIKE '%[DMF0003 GTT RENAME 20260723]%';
