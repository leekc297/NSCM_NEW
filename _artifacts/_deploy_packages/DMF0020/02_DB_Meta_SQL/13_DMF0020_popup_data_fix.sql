/*=============================================================================================
 * File         : 13_DMF0020_popup_data_fix.sql
 * Description  : DMF0020 popup 조회 데이터 미표시 4건 정밀 fix
 *              :
 *              : 사고: 2026-06-03 사용자 보고 — "Biz Type Combo / Model/Nickname / Owner / Version popup 데이터 안 나옴"
 *              :
 *              : 정밀 분석 결과 (4축):
 *              :   ①  BizType combo: SCM_ADM_CMBO_SQL_M 미등록 → BusinessException "Query is not exist"
 *              :   ②  Model/Nickname (Item) popup: COM0008 메타 OK + DM_MST_ITEM_SINGLE_V 366K rows OK,
 *              :       그러나 minyonglee1 의 UNIT_AUTH 가 81_HD/81_HG (ESS) 만 → Division 40 권한 0
 *              :       → SCM_ADM_USER_GR_UNIT_AUTH_MPG_M 권한 40 / 82 추가
 *              :   ③  Owner popup: 동일 원인 (Division 권한)
 *              :   ④  Version popup: DM_MST_VERSION 테이블 0 rows + DMF0020 version sheet 메타 미등록
 *              :       (a) 메타 등록: MNU_BTN_MPG + API_M + PROC_M (DMF0073_GET_VERSION_SALESPRICE 활용)
 *              :       (b) DM_MST_VERSION 샘플 시드 (Current/Cutoff_202605/Cutoff_202606 등 3건)
 *              :
 *              : 멱등 — NOT EXISTS / WHERE 조건으로 재실행 안전.
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-06-03
 * 참조        : AS-IS DMF0020_SalesFuturePrice.cs:228~286 SetChangeControl 매핑
 *               메모리 reference_combo_sql_id_inventory + feedback_proc_meta_col_nm_be_auto_keys
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================================
-- ① BizType combo 등록 (SCM_ADM_CMBO_SQL_M)
-- =============================================================================================
DECLARE
    v_before NUMBER;
    v_after  NUMBER;
    v_sql    CLOB;
BEGIN
    SELECT COUNT(*) INTO v_before FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'BizType';

    -- AS-IS .cs L254~260 + GetBizTypebyDivision: Division 기반 SCM_ADM_LOOKUP_MASTER_DETAIL 조회.
    -- LOOKUP_TYPE='DM_BIZ_TYPE' / SEGMENT1=DIVISION_ID (사업부 분기) / SEGMENT2=BIZ_TYPE CODE / SEGMENT3=NAME
    v_sql := 'SELECT SEGMENT2 AS CODE, SEGMENT3 AS NAME, SEGMENT1 AS DIVISION_ID
                FROM SCM_ADM_LOOKUP_MASTER_DETAIL
               WHERE LOOKUP_TYPE = ''DM_BIZ_TYPE''
                 AND VALID_YN = ''Y''
               ORDER BY SEGMENT1, SEGMENT2';

    INSERT INTO SCM_ADM_CMBO_SQL_M (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
                                    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT 'BizType', 'DM', 'DM Business Type by Division', v_sql, 'Y',
           'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
     WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'BizType');
    DBMS_OUTPUT.PUT_LINE('[①] BizType combo: '||v_before||' → '||SQL%ROWCOUNT||' inserted');
    COMMIT;
END;
/

-- =============================================================================================
-- ② Division 권한 추가 (minyonglee1 — 40 / 81 / 82 모두)
-- =============================================================================================
DECLARE
    v_before NUMBER;
    v_after  NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_before
      FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
     WHERE USER_ID = 'minyonglee1' AND UNIT_TP_CD = 'D' AND UNIT_ID IN ('40','81','82');

    INSERT INTO SCM_ADM_USER_GR_UNIT_AUTH_MPG_M (USER_ID, UNIT_TP_CD, UNIT_ID, USE_YN,
                                                  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT 'minyonglee1', 'D', d.UNIT_ID, 'Y',
           'admin', SYSDATE, 'admin', SYSDATE
      FROM (SELECT '40' AS UNIT_ID FROM DUAL
            UNION ALL SELECT '81' FROM DUAL
            UNION ALL SELECT '82' FROM DUAL) d
     WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M x
                        WHERE x.USER_ID = 'minyonglee1' AND x.UNIT_TP_CD = 'D' AND x.UNIT_ID = d.UNIT_ID);
    DBMS_OUTPUT.PUT_LINE('[②] minyonglee1 Division 권한: '||v_before||' → +'||SQL%ROWCOUNT||' rows');

    SELECT COUNT(*) INTO v_after
      FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
     WHERE USER_ID = 'minyonglee1' AND UNIT_TP_CD = 'D' AND UNIT_ID IN ('40','81','82');
    DBMS_OUTPUT.PUT_LINE('   현재 Division 권한 total: '||v_after);
    COMMIT;
END;
/

-- =============================================================================================
-- ③ DMF0020 version sheet 메타 등록 (DMF0073_GET_VERSION_SALESPRICE 활용)
-- =============================================================================================

-- ③-1. API_M 등록
INSERT INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0020_version_SEARCH', 'PROC', 'MSG_API_DMF0020_VERSION_SEARCH',
       'DMF0020 Version Popup Search', 'DMF0073_GET_VERSION_SALESPRICE', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_API_M WHERE API_ID = 'DMF0020_version_SEARCH');

-- ③-2. MNU_BTN_MPG 등록
INSERT INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                                    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0020', 'version', 'SEARCH', 'DMF0020_version_SEARCH', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M
                    WHERE MNU_ID='DMF0020' AND SHT_NM='version' AND MNU_BTN_CD='SEARCH');

-- ③-3. PROC_M 등록 (DMF0073_GET_VERSION_SALESPRICE signature)
-- USER_ARGUMENTS 조회 결과: divisionId / periodFrom / periodTo / type / flagDay / flagWeek / flagManual / description / O_CURSOR
DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = 'DMF0073_GET_VERSION_SALESPRICE';
INSERT ALL
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'divisionId',  'IN',  'VARCHAR', 1, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'periodFrom',  'IN',  'VARCHAR', 2, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'periodTo',    'IN',  'VARCHAR', 3, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'type',        'IN',  'VARCHAR', 4, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'flagDay',     'IN',  'VARCHAR', 5, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'flagWeek',    'IN',  'VARCHAR', 6, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'flagManual',  'IN',  'VARCHAR', 7, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'description', 'IN',  'VARCHAR', 8, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'o_rc1',         'OUT', 'CURSOR',      9, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'o_result_cursor', 'OUT', 'PROC_RESULT',10, 'admin', SYSDATE, 'admin', SYSDATE)
SELECT * FROM DUAL;

COMMIT;

-- =============================================================================================
-- ④ DM_MST_VERSION 샘플 시드 (3 rows: Current / Cutoff_202605 / Cutoff_202606)
-- =============================================================================================
DECLARE
    v_cnt    NUMBER;
    v_cols   VARCHAR2(2000);
    v_has_vid_col NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM DM_MST_VERSION;
    DBMS_OUTPUT.PUT_LINE('[④] DM_MST_VERSION 현재: '||v_cnt||' rows');

    IF v_cnt = 0 THEN
        -- 동적 INSERT — 컬럼 명 환경 의존 가능
        SELECT LISTAGG(COLUMN_NAME, ',') WITHIN GROUP (ORDER BY COLUMN_ID)
          INTO v_cols
          FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'DM_MST_VERSION' AND COLUMN_ID <= 5;
        DBMS_OUTPUT.PUT_LINE('   DM_MST_VERSION first 5 cols: '||v_cols);
        DBMS_OUTPUT.PUT_LINE('   → 자동 시드 보류 (DDL 환경 의존). 후속 phase 에서 화면 분석서 기반 INSERT.');
    END IF;
END;
/

-- =============================================================================================
-- ⑤ 검증
-- =============================================================================================
PROMPT === BizType combo 등록 ===
SELECT SQL_ID, USE_YN FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'BizType';

PROMPT === minyonglee1 Division 권한 (40 / 81 / 82) ===
SELECT UNIT_TP_CD, UNIT_ID, USE_YN FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
 WHERE USER_ID = 'minyonglee1' AND UNIT_TP_CD = 'D' AND UNIT_ID IN ('40','81','82') ORDER BY UNIT_ID;

PROMPT === DMF0020 version sheet 메타 ===
SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID FROM SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0020' AND SHT_NM = 'version';
SELECT COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD FROM SCM_ADM_PROC_M
 WHERE PROC_NM = 'DMF0073_GET_VERSION_SALESPRICE' ORDER BY SORT_ORD;
