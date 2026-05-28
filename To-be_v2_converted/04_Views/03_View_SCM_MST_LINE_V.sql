/*=============================================================================================
 * File         : 03_View_SCM_MST_LINE_V.sql
 * Description  : View — SCM_MST_LINE_V
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : ANSI OUTER JOIN → (+) 변환은 자동변환 위험으로 수동 검토 필요.
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 04_Views 단계 (Tables 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN ... ON → WHERE A.x = B.x(+) 변환 (사내 표준 §7.1.6)
 *===========================================================================================*/

-- SCM_MGR.SCM_MST_LINE_V source

CREATE OR REPLACE FORCE EDITIONABLE VIEW "SCM_MGR"."SCM_MST_LINE_V" ("COMPANY_ID", "DIVISION_ID", "SITE_ID", "PLANT_ID", "FACTORY_ID", "OPERATION_ID", "LINE_ID", "ELECTRODE_TYPE", "LINE_NAME", "VALID_YN") AS 
  SELECT COMPANY_ID
          ,DIVISION_ID
          ,SITE_ID
          ,PLANT_ID
          ,FACTORY_ID
          ,OPERATION_ID
          ,LINE_ID
          ,ELECTRODE_TYPE
          ,LINE_NAME
          ,'Y'            AS VALID_YN
    --      ,''            AS OSP_YN
    FROM SCM_MST_LINE_SN
    UNION ALL
    SELECT NULL           AS COMPANY_ID
          ,DIVISION_ID
          ,SCM_SITE_ID SITE_ID
          ,OPERATION_ID PLANT_ID
          ,NULL FACTORY_ID
          ,OPERATION_ID
          ,LINE_ID
          ,NULL ELECTRODE_TYPE
          ,LINE_NAME
          ,VALID_YN
    --      ,'Y'            AS OSP_YN
    FROM SCM_MST_LINE_OSP;

GRANT SELECT ON "SCM_MGR"."SCM_MST_LINE_V" TO "RL_SCM_DML";
  GRANT SELECT ON "SCM_MGR"."SCM_MST_LINE_V" TO "RL_SCM_SEL";
  GRANT SELECT ON "SCM_MGR"."SCM_MST_LINE_V" TO "SCMD_APP";


-- SCM_MGR.SCM_MST_MODEL_FINAL_ITEM_BOM_V source
