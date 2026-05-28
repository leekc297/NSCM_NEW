/*=============================================================================================
 * File         : 03_View_SCM_MST_ALTER_BOM_V.sql
 * Description  : View — SCM_MST_ALTER_BOM_V
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

-- SCM_MGR.SCM_MST_ALTER_BOM_V source

CREATE OR REPLACE FORCE EDITIONABLE VIEW "SCM_MGR"."SCM_MST_ALTER_BOM_V" ("DIVISION_ID", "SITE_ID", "PLANT_ID", "PARENT_ITEM_ID", "CHILD_ITEM_ID", "ALT_ID", "ALT_PRIORITY", "BOM_VERSION_ID", "KEY_DATE", "EFF_START_DATE", "EFF_END_DATE", "PARENT_QTY", "PARENT_UOM", "CHILD_QTY", "CHILD_UOM", "SCP_PLAN_YN", "COMMON_CELL_YN", "CHILD_ITEM_TYPE") AS 
  (
/*
 * Program ID   : SCM_MST_ALTER_BOM_V
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2026.03.09   jcnam          [PJ20264226] NextSCM Pilot 설계 및 개발
 */
  SELECT
      B.DIVISION_ID
    , B.SITE_ID
    , B.PLANT_ID
    , B.PARENT_ITEM_ID
    , B.CHILD_ITEM_ID
    , B.ALT_ID
    , B.ALT_PRIORITY
    , B.BOM_VERSION_ID
    , B.KEY_DATE
    , B.EFF_START_DATE
    , B.EFF_END_DATE
    , B.PARENT_QTY
    , B.PARENT_UOM
    , B.CHILD_QTY
    , B.CHILD_UOM
    , B.VIEW_SCP_PLAN_YN AS SCP_PLAN_YN
    , B.COMMON_CELL_YN
    , B.CHILD_ITEM_TYPE
FROM
(
    SELECT
          X.*
        , CASE
            -- 2025.08.31   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
            --                          Item 비활성의 경우 SCP 미반영으로 설정
            --대치 BOM일 경우 반드시 1개는 계획이 수립이 되도록 한다.
            --단일 대치BOM 또는 모두 SCP_PLAN_YN = ''일 경우 등...
            WHEN ATTRIBUTE13 = '' THEN ''
            WHEN ROW_NUMBER() OVER
                 (
                     PARTITION BY DIVISION_ID, SITE_ID, PLANT_ID, PARENT_ITEM_ID, ALT_ID
                     ORDER BY SCP_PLAN_YN DESC, ALT_PRIORITY, EFF_START_DATE, EFF_END_DATE
                 ) = 1 THEN 'Y'
            ELSE ''
          END AS VIEW_SCP_PLAN_YN
    FROM SCM_MST_ALTER_BOM X
    WHERE 1 = 1
    --AND   CHILD_ITEM_TYPE <> 'R'	--원자재 제외
) B
WHERE 1 = 1);

GRANT SELECT ON "SCM_MGR"."SCM_MST_ALTER_BOM_V" TO "RL_SCM_DML";
  GRANT SELECT ON "SCM_MGR"."SCM_MST_ALTER_BOM_V" TO "SCMD_APP";


-- SCM_MGR.SCM_MST_BOM_SN_V source
