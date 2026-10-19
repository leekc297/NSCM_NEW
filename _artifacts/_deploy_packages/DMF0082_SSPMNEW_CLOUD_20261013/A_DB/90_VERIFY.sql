-- 90 VERIFY — [E20261013-DMF0082SSPMNEW] V1~V3 조회 전용 · V4 = 저장 SP 를 '마스터에 없는 Project' 신규 행 1건으로 호출해 차단 확인
-- * 기대: V1 마커 PASS · V2 VALID/오류 0 · V3 5-1 블록 줄 · V4 'PASS — 5-1 검증으로 차단 · 원장 0 → 0'
-- * V4 는 **마커가 있을 때만** 호출한다 (미적용 상태에서 호출하면 시험 행이 저장될 수 있어 건너뛴다).
--   시험 키 = 마스터에 실값 Project 로 유효 등록된 Sales Site-Model 1건 + 존재하지 않는 Project 'ZZ_SSPMNEW_TEST'.
--   호출 전후 원장(수요·판가)에 그 키가 0건인지 확인하고, 막히지 않았으면 FAIL 과 함께 키를 출력한다.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A8
COLUMN TXT FORMAT A150
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) >= 1 THEN 'PASS' ELSE 'FAIL (미적용)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20261013-DMF0082SSPMNEW%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 블록' CHK, S.LINE, SUBSTR(RTRIM(S.TEXT, CHR(10)||CHR(13)),1,150) TXT
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY'
   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20261013-DMF0082SSPMNEW%') + 14
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20261013-DMF0082SSPMNEW%') + 28
 ORDER BY S.LINE;
DECLARE
    n_mark PLS_INTEGER;
    v_div  VARCHAR2(50); v_site VARCHAR2(200); v_item VARCHAR2(200);
    c_prj  CONSTANT VARCHAR2(30) := 'ZZ_SSPMNEW_TEST';
    v_ymd  VARCHAR2(8) := TO_CHAR(TRUNC(SYSDATE,'IW') + 7, 'YYYYMMDD');
    n_b    PLS_INTEGER; n_a PLS_INTEGER;
    rc     SYS_REFCURSOR;
    v_code VARCHAR2(100); v_msg VARCHAR2(4000); v_evt VARCHAR2(400);
    FUNCTION ledger_cnt RETURN PLS_INTEGER IS
        n1 PLS_INTEGER; n2 PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO n1 FROM DM_PLN_CFM_MKT_DEMAND_PLAN WHERE DIVISION_ID = v_div AND PROJECT_CODE = c_prj AND SCM_SITE_ID = v_site AND ITEM_ID = v_item;
        SELECT COUNT(*) INTO n2 FROM DM_PLN_CFM_SELLING_PRICE   WHERE DIVISION_ID = v_div AND PROJECT_CODE = c_prj AND SCM_SITE_ID = v_site AND ITEM_ID = v_item;
        RETURN n1 + n2;
    END;
BEGIN
    SELECT COUNT(*) INTO n_mark FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20261013-DMF0082SSPMNEW%';
    IF n_mark = 0 THEN
        DBMS_OUTPUT.PUT_LINE('V4 SKIP — 미적용 상태 (10 적용 뒤 다시 실행)');
        RETURN;
    END IF;
    BEGIN
        SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID INTO v_div, v_site, v_item
          FROM (SELECT S.DIVISION_ID, S.SCM_SITE_ID, S.ITEM_ID
                  FROM SCM_MST_SITE_ITEM S
                 WHERE S.DIVISION_ID = '40' AND S.VALID_YN = 'Y' AND S.PROJECT_CODE NOT IN ('-','/') AND TRIM(S.PROJECT_CODE) IS NOT NULL
                   AND EXISTS (SELECT 1 FROM SCM_MST_ITEM_SN N WHERE N.DIVISION_ID = S.DIVISION_ID AND N.ITEM_ID = S.ITEM_ID AND N.ACTIVE_FLAG = 'Y')
                 ORDER BY S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID)
         WHERE ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('V4 SKIP — 시험에 쓸 40 유효 Sales Site-Model 이 없음');
        RETURN;
    END;
    n_b := ledger_cnt;
    IF n_b <> 0 THEN
        DBMS_OUTPUT.PUT_LINE('V4 SKIP — 시험 키가 원장에 이미 있음(' || n_b || '건) · 호출하지 않음');
        RETURN;
    END IF;
    SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA('I', v_div, c_prj, c_prj, v_site, v_item, 'E', 'MPS', 'CPT', 'MKT_FCST', '-', '-', v_ymd, '', '1', 'minyonglee1', '', rc);
    FETCH rc INTO v_code, v_msg, v_evt;
    CLOSE rc;
    ROLLBACK;
    n_a := ledger_cnt;
    DBMS_OUTPUT.PUT_LINE('V4 시험 키 = ' || v_div || ' / ' || c_prj || ' / ' || v_site || ' / ' || v_item);
    DBMS_OUTPUT.PUT_LINE('V4 결과 = ' || v_code || ' | ' || REPLACE(SUBSTR(v_msg,1,300), CHR(10), ' / '));
    DBMS_OUTPUT.PUT_LINE('V4 ' || CASE WHEN n_a <> 0 THEN 'FAIL — 막히지 않고 저장됨(' || n_a || '건). 위 시험 키의 행을 정리해야 함'
                                      WHEN v_code = '0' THEN 'FAIL — 성공 응답'
                                      WHEN INSTR(v_msg, 'Sales Site Project Model 에 등록되지 않은 조합입니다.') > 0 THEN 'PASS — 5-1 검증으로 차단 · 원장 0 → 0'
                                      ELSE 'CHECK — 저장은 막혔으나 5-1 보다 앞선 검증 메시지 (위 결과 문구 확인) · 원장 0 → 0' END);
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('V4 FAIL — ' || REPLACE(SUBSTR(SQLERRM,1,300), CHR(10), ' / '));
END;
/
