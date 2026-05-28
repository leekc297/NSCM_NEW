/*=============================================================================================
 * File         : 03_View_SCM_MST_FINAL_ITEM_V.sql
 * Description  : View — SCM_MST_FINAL_ITEM_V
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

-- SCM_MGR.SCM_MST_FINAL_ITEM_V source

CREATE OR REPLACE FORCE EDITIONABLE VIEW "SCM_MGR"."SCM_MST_FINAL_ITEM_V" ("DIVISION_ID", "ITEM_ID", "OPERATION_GROUP_ID", "NICK_NAME", "ITEM_CLASS", "ITEM_CLASS_NAME", "ELECTRODE_TYPE", "TCO_CELL_YN", "RACK_YN", "DC_YN", "IS_YN", "CELL_TYPE") AS 
  SELECT DISTINCT
       I.DIVISION_ID,
       I.ITEM_ID,
       /* E:ELECTRODE, A:CELL, P:PACK */
       I.OPERATION_GROUP_ID,
       I.NICK_NAME,
       I.ITEM_CLASS,
       I.ITEM_CLASS_NAME,
       I.ELECTRODE_TYPE,
       I.TCO_CELL_YN,
       I.RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       I.DC_YN,
       I.IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
       I.CELL_TYPE
  FROM SCM_MST_FINAL_ITEM_ORIGIN_DIV_V I
 WHERE 1=1

UNION

/*********************************************
-- 2.  CELL,PACK이 다른 사업부에 FINAL ITEM으로 생산될 수 : JV 등 별도 처리 필요 없음
*********************************************/
SELECT DISTINCT
      '40' AS DIVISION_ID,
       I.ITEM_ID,
       /* E:ELECTRODE, A:CELL, P:PACK */
       I.OPERATION_GROUP_ID,
       I.NICK_NAME,
       I.ITEM_CLASS,
       I.ITEM_CLASS_NAME,
       I.ELECTRODE_TYPE,
       I.TCO_CELL_YN,
       I.RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       I.DC_YN,
       I.IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
       I.CELL_TYPE
  FROM SCM_MST_FINAL_ITEM_ORIGIN_DIV_V I
 WHERE 1=1
   AND I.DIVISION_ID IN ('81', '82')
   AND I.OPERATION_GROUP_ID IN ('A', 'P', '')

UNION

SELECT DISTINCT
      '81' AS DIVISION_ID,
       I.ITEM_ID,
       /* E:ELECTRODE, A:CELL, P:PACK */
       I.OPERATION_GROUP_ID,
       I.NICK_NAME,
       I.ITEM_CLASS,
       I.ITEM_CLASS_NAME,
       I.ELECTRODE_TYPE,
       I.TCO_CELL_YN,
       I.RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       I.DC_YN,
       I.IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
       I.CELL_TYPE
  FROM SCM_MST_FINAL_ITEM_ORIGIN_DIV_V I
 WHERE 1=1
   AND I.DIVISION_ID IN ('40', '82')
   AND I.OPERATION_GROUP_ID IN ('A', 'P', '')

UNION

SELECT DISTINCT
      '82' AS DIVISION_ID,
       I.ITEM_ID,
       /* E:ELECTRODE, A:CELL, P:PACK */
       I.OPERATION_GROUP_ID,
       I.NICK_NAME,
       I.ITEM_CLASS,
       I.ITEM_CLASS_NAME,
       I.ELECTRODE_TYPE,
       I.TCO_CELL_YN,
       I.RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       I.DC_YN,
       I.IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
       I.CELL_TYPE
  FROM SCM_MST_FINAL_ITEM_ORIGIN_DIV_V I
 WHERE 1=1
   AND I.DIVISION_ID IN ('40', '81')
   AND I.OPERATION_GROUP_ID IN ('A', 'P', '')
;

GRANT SELECT ON "SCM_MGR"."SCM_MST_FINAL_ITEM_V" TO "SCMD_APP";


-- SCM_MGR.SCM_MST_LINE_V source
