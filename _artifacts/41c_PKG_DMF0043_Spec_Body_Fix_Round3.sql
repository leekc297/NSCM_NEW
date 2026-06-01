--==============================================================================
-- 41c_PKG_DMF0043_Spec_Body_Fix_Round3.sql
--
-- 41b 적용 결과:
--   - FN_SCM_STRING_SPLIT 함수 정상 생성 OK
--   - SP #10 재컴파일 시 새 ORA-00947, ORA-00904 잔존
--   - 원인: AS-IS 마이그레이션 시 SCM_MST_SITE_ITEM.REPORT_GROUP2/3 컬럼 삭제
--           → SP body 의 SELECT 에서 CUST_REPORT (REPORT_GROUP2 기반) 와
--             PRODUCT_GROUP (REPORT_GROUP3 기반) 컬럼이 코멘트 처리됨
--           → GT_DMF0043_SALES_LIST_C INSERT 의 13 컬럼 vs SELECT 11 컬럼 불일치
--
-- 본 Round 3 작업:
--   1) SP body 의 3 코멘트 라인 활성화 (빈 값 '' 으로 대체)
--      - INSERT SELECT 의 CUST_REPORT
--      - INSERT SELECT 의 PRODUCT_GROUP
--      - p_cursor_cnt subquery 의 LIST.PRODUCT_GROUP
--   2) PL/SQL anonymous block 으로 USER_SOURCE 의 SP source 추출 + REPLACE + EXECUTE IMMEDIATE
--   3) 재컴파일 + VALID 검증
--
-- 멱등성: REPLACE 가 idempotent (한 번 patch 후 재실행 시 동일 효과)
-- 작성: 2026-05-30
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET LINESIZE 200
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : USER_SOURCE 에서 SP body 추출 + 3 코멘트 라인 patch + 재컴파일 ===

DECLARE
    v_src CLOB := EMPTY_CLOB();
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    -- USER_SOURCE 의 모든 라인 합치기
    FOR rec IN (
        SELECT TEXT
          FROM USER_SOURCE
         WHERE NAME = 'DMF0043_GET_CONTRIBUTION_SALES_LIST'
           AND TYPE = 'PROCEDURE'
         ORDER BY LINE
    ) LOOP
        DBMS_LOB.APPEND(v_src, rec.TEXT);
    END LOOP;

    -- Patch 1: INSERT SELECT 의 REPORT_GROUP2 (CUST_REPORT 매핑)
    v_src := REPLACE(v_src,
        '-- , NVL(I.REPORT_GROUP2,'''') AS CUST_REPORT -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP2 제거 (Oracle 마이그레이션 2026.05.22)',
        ', '''' AS CUST_REPORT --[Round3 patch] REPORT_GROUP2 제거로 빈값');
    -- Patch 2: INSERT SELECT 의 REPORT_GROUP3 (PRODUCT_GROUP 매핑)
    v_src := REPLACE(v_src,
        '-- , NVL(I.REPORT_GROUP3,'''') AS PRODUCT_GROUP -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP3 제거 (Oracle 마이그레이션 2026.05.22)',
        ', '''' AS PRODUCT_GROUP --[Round3 patch] REPORT_GROUP3 제거로 빈값');
    -- Patch 3: p_cursor_cnt 의 LIST subquery 의 REPORT_GROUP3 (PRODUCT_GROUP)
    v_src := REPLACE(v_src,
        '-- , NVL(A.REPORT_GROUP3,'''') AS PRODUCT_GROUP -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP3 제거 (Oracle 마이그레이션 2026.05.22)',
        ', '''' AS PRODUCT_GROUP --[Round3 patch] REPORT_GROUP3 제거로 빈값');

    -- DDL 접두사 추가
    v_src := 'CREATE OR REPLACE ' || v_src;

    -- 재컴파일
    EXECUTE IMMEDIATE v_src;

    DBMS_OUTPUT.PUT_LINE('Patch applied + recompiled. CLOB size: ' || DBMS_LOB.GETLENGTH(v_src));
    DBMS_LOB.FREETEMPORARY(v_src);
END;
/

PROMPT === BLOCK 2 : 최종 상태 ===

SELECT 'standalone SP count (10 expected)' AS K, COUNT(*) AS V
  FROM USER_OBJECTS
 WHERE OBJECT_NAME LIKE 'DMF0043_%'
   AND OBJECT_TYPE = 'PROCEDURE'
UNION ALL
SELECT 'standalone SP INVALID (0 expected)', COUNT(*)
  FROM USER_OBJECTS
 WHERE OBJECT_NAME LIKE 'DMF0043_%'
   AND OBJECT_TYPE = 'PROCEDURE'
   AND STATUS = 'INVALID'
UNION ALL
SELECT 'SP10 errors (0 expected)', COUNT(*)
  FROM USER_ERRORS
 WHERE NAME = 'DMF0043_GET_CONTRIBUTION_SALES_LIST'
   AND TYPE = 'PROCEDURE';

PROMPT === BLOCK 3 : 잔존 오류 (0 expected) ===

SELECT NAME, LINE, POSITION, TEXT
  FROM USER_ERRORS
 WHERE NAME LIKE 'DMF0043_%' AND TYPE = 'PROCEDURE'
 ORDER BY NAME, LINE;

COMMIT;

PROMPT === COMPLETE ===
EXIT;
