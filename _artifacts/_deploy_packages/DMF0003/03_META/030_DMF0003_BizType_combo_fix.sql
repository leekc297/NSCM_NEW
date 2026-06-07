/*=============================================================================================
 * File         : 030_DMF0003_BizType_combo_fix.sql
 * Description  : BizType combo SQL fix — @divisionId BE 자동 채움 안 되어 0 row
 *              : 자매 TeambyDivision 패턴 적용 — DIVISION_ID 컬럼 결과 포함 + 전 div distinct
 *              : FE 측 toOptions(bizTypes, division) 가 division filter
 * 사용자 보고  : 2026-06-07 "조회조건 biz_type 에 dropdown 값 없습니다"
 * AS-IS 매핑   : DMF0003_1_MktFcst.cs L378 Data.Common(Data.Type.DM_BIZ_TYPE) — 전 div lookup
 *                                  L392 GetBizTypebyDivision(sDivision)        — div 별 filter
 *===========================================================================================*/

-- BizType SQL UPDATE — DIVISION_ID 결과 포함 + WHERE @divisionId 제거 (BE 자동 채움 X)
UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M
   SET SQL_DTL_CTN = 'SELECT DISTINCT DIVISION_ID, BIZ_TYPE_NAME AS CODE, BIZ_TYPE_NAME AS NAME FROM SCM_MST_PROJECT WHERE BIZ_TYPE_NAME IS NOT NULL ORDER BY DIVISION_ID, BIZ_TYPE_NAME',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE SQL_ID = 'BizType';

COMMIT;

-- Verify
PROMPT --- BizType SQL_DTL_CTN 확인 ---
SET PAGESIZE 10 LINESIZE 300 LONG 4000
COL SQL_DTL_CTN FORMAT A270
SELECT SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='BizType';

PROMPT --- BizType row count by Division ---
COL DIVISION_ID FORMAT A12
SELECT DIVISION_ID, COUNT(DISTINCT BIZ_TYPE_NAME) AS BIZ_TYPE_CNT
  FROM SCM_MGR.SCM_MST_PROJECT
 WHERE BIZ_TYPE_NAME IS NOT NULL
 GROUP BY DIVISION_ID
 ORDER BY DIVISION_ID;
