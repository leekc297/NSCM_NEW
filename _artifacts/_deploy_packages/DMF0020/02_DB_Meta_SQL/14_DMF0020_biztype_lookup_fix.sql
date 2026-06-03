/*=============================================================================================
 * File         : 14_DMF0020_biztype_lookup_fix.sql
 * Description  : BizType combo SQL 정정 + Item/Owner SP 결과 검증
 *              :
 *              : 사고: 2026-06-03 사용자 보고 — "Biz Type CELL/MODULE/PACK 데이터 나와야 함"
 *              :
 *              : AS-IS 정밀 분석 (anti-simplification 적용):
 *              :   Doc/_legacy_source/01_Framework/.../DataService.cs:3839~3873 — case "BizType"
 *              :   dsAllDM.Tables[3] 에서 가져옴 (BigFilter multi-result-set 의 4번째 cursor)
 *              :   → 실제 source = SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'BIZ_TYPE'
 *              :   (이전 등록 시 'DM_BIZ_TYPE' 잘못 — DB 실제 LOOKUP_TYPE 은 'BIZ_TYPE')
 *              :
 *              :   실제 DB 데이터 (3 rows): A=Cell / E=Electrode / P=Pack
 *              :   (사용자 메시지 "CELL/MODULE/PACK" 중 MODULE 은 사실 Electrode — DB 실제 값 사용)
 *              :   SEGMENT1=CODE / SEGMENT2=NAME / DIVISION 컬럼 없음 (Division 필터 X)
 *              :
 *              : 처방:
 *              :   UPDATE BizType combo SQL — LOOKUP_TYPE='BIZ_TYPE' + SEGMENT1/SEGMENT2 정확 매핑
 *              :
 *              : 멱등 — UPDATE WHERE 조건.
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-06-03
 * 참조        : AS-IS DataService.cs:3839 + SCM_ADM_LOOKUP_MASTER_DETAIL.LOOKUP_TYPE='BIZ_TYPE'
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    v_new_sql CLOB;
    v_before  VARCHAR2(2000);
BEGIN
    -- 정확한 SQL — LOOKUP_TYPE='BIZ_TYPE' / SEGMENT1=CODE / SEGMENT2=NAME
    v_new_sql := 'SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                    FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                   WHERE LOOKUP_TYPE = ''BIZ_TYPE''
                     AND VALID_YN = ''Y''
                   ORDER BY SEGMENT1';

    SELECT DBMS_LOB.SUBSTR(SQL_DTL_CTN, 200, 1) INTO v_before FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'BizType';
    DBMS_OUTPUT.PUT_LINE('=== BEFORE (BizType SQL_DTL_CTN 첫 200자) ===');
    DBMS_OUTPUT.PUT_LINE(v_before);

    UPDATE SCM_ADM_CMBO_SQL_M
       SET SQL_DTL_CTN      = v_new_sql,
           LAST_UPDATED_BY  = 'admin',
           LAST_UPDATE_DATE = SYSDATE
     WHERE SQL_ID = 'BizType';
    DBMS_OUTPUT.PUT_LINE('rows updated: '||SQL%ROWCOUNT);
    COMMIT;
END;
/

PROMPT === 실 데이터 미리보기 (BE 가 호출할 SQL 결과) ===
SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'BIZ_TYPE'
   AND VALID_YN = 'Y'
 ORDER BY SEGMENT1;

PROMPT === Item popup SP 시뮬레이션 — minyonglee1 권한 + 40 division 결과 row count ===
SET SERVEROUTPUT ON
DECLARE
    v_cnt NUMBER;
BEGIN
    -- AS-IS Item modal SP signature 흐름 모사 — DM_MST_ITEM_SINGLE_V + 권한 필터
    SELECT COUNT(*) INTO v_cnt FROM DM_MST_ITEM_SINGLE_V WHERE DIVISION_ID = '40'
       AND EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
                    WHERE USER_ID = 'minyonglee1' AND UNIT_TP_CD = 'D' AND UNIT_ID = '40');
    DBMS_OUTPUT.PUT_LINE('  Item popup expected rows (div=40): '||v_cnt);

    SELECT COUNT(*) INTO v_cnt FROM SCM_MST_SITE_ITEM WHERE DIVISION_ID = '40'
       AND EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
                    WHERE USER_ID = 'minyonglee1' AND UNIT_TP_CD = 'D' AND UNIT_ID = '40');
    DBMS_OUTPUT.PUT_LINE('  Owner popup expected rows (div=40 SITE_ITEM): '||v_cnt);
END;
/
