-- 90 VERIFY — [E20261013-DMF0082ADJYNALL] V1~V3 조회 전용 · V4 = 조정 제외(N) 품목의 '판가 없는 주' 신규 수량 1건으로 저장 SP 호출 → 단가 검증 차단 확인
-- * 기대: V1 마커 PASS · V2 VALID/오류 0 · V3 주석 처리된 8줄 · V4 'PASS — 단가 검증으로 차단 · 원장 0 → 0'
-- * V4 는 **마커가 있을 때만** 호출한다 (미적용 상태에서 호출하면 시험 행이 저장된다).
--   시험 키 = 마스터의 조정 제외(N) 유효 품목(40) 중에서 고르고, 일자 = 8주 뒤 월요일. 그 (키, 일자)의 수요와 그 주 판가가 0건일 때만 호출.
--   앞 단계 검증(Biz Type 등)에 먼저 걸리는 품목은 다음 품목으로 넘어간다 (최대 20 품목). 호출마다 ROLLBACK, 호출 뒤 건수 재확인.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A8
COLUMN TXT FORMAT A150
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL (미적용)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20261013-DMF0082ADJYNALL%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 블록' CHK, S.LINE, SUBSTR(RTRIM(S.TEXT, CHR(10)||CHR(13)),1,150) TXT
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY'
   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20261013-DMF0082ADJYNALL%')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20261013-DMF0082ADJYNALL%') + 9
 ORDER BY S.LINE;
DECLARE
    n_mark PLS_INTEGER;
    v_ymd  VARCHAR2(8) := TO_CHAR(TRUNC(SYSDATE,'IW') + 56, 'YYYYMMDD');
    v_wk   VARCHAR2(8);
    n_b    PLS_INTEGER; n_a PLS_INTEGER;
    n_try  PLS_INTEGER := 0;
    v_done BOOLEAN := FALSE;
    rc     SYS_REFCURSOR;
    v_code VARCHAR2(100); v_msg VARCHAR2(4000); v_evt VARCHAR2(400);
    FUNCTION ledger_cnt(p_div VARCHAR2, p_prj VARCHAR2, p_site VARCHAR2, p_item VARCHAR2) RETURN PLS_INTEGER IS
        n1 PLS_INTEGER; n2 PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO n1 FROM DM_PLN_CFM_MKT_DEMAND_PLAN WHERE DIVISION_ID = p_div AND PROJECT_CODE = p_prj AND SCM_SITE_ID = p_site AND ITEM_ID = p_item AND YYYYMMDD = v_ymd;
        SELECT COUNT(*) INTO n2 FROM DM_PLN_CFM_SELLING_PRICE   WHERE DIVISION_ID = p_div AND PROJECT_CODE = p_prj AND SCM_SITE_ID = p_site AND ITEM_ID = p_item AND YYYYMMDD IN (v_ymd, v_wk);
        RETURN n1 + n2;
    END;
BEGIN
    SELECT COUNT(*) INTO n_mark FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20261013-DMF0082ADJYNALL%';
    IF n_mark = 0 THEN
        DBMS_OUTPUT.PUT_LINE('V4 SKIP — 미적용 상태 (10 적용 뒤 다시 실행)');
        RETURN;
    END IF;
    SELECT NVL(MAX(BASIS_START_DATE), v_ymd) INTO v_wk FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = v_ymd;
    FOR k IN (SELECT S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID
                FROM SCM_MST_SITE_ITEM S
               WHERE S.DIVISION_ID = '40' AND S.VALID_YN = 'Y' AND S.SALES_PLAN_ADJUST_YN = 'N'
                 AND EXISTS (SELECT 1 FROM SCM_MST_ITEM_SN N WHERE N.DIVISION_ID = S.DIVISION_ID AND N.ITEM_ID = S.ITEM_ID AND N.ACTIVE_FLAG = 'Y')
               ORDER BY S.LAST_UPDATE_DATE DESC, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID FETCH FIRST 20 ROWS ONLY) LOOP
        EXIT WHEN v_done;
        n_b := ledger_cnt(k.DIVISION_ID, k.PROJECT_CODE, k.SCM_SITE_ID, k.ITEM_ID);
        IF n_b = 0 THEN
            n_try := n_try + 1;
            SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA('I', k.DIVISION_ID, k.PROJECT_CODE, k.PROJECT_CODE, k.SCM_SITE_ID, k.ITEM_ID, 'E', 'MPS', 'CPT', 'MKT_FCST', '-', 'HQ06-A', v_ymd, '', '1', 'minyonglee1', '', rc);
            FETCH rc INTO v_code, v_msg, v_evt;
            CLOSE rc;
            ROLLBACK;
            n_a := ledger_cnt(k.DIVISION_ID, k.PROJECT_CODE, k.SCM_SITE_ID, k.ITEM_ID);
            DBMS_OUTPUT.PUT_LINE('V4 시도 ' || n_try || ' = ' || k.DIVISION_ID || ' / ' || k.PROJECT_CODE || ' / ' || k.SCM_SITE_ID || ' / ' || k.ITEM_ID || ' / ' || v_ymd
                                 || ' → ' || v_code || ' | ' || REPLACE(SUBSTR(v_msg,1,160), CHR(10), ' / '));
            IF n_a <> 0 THEN
                DBMS_OUTPUT.PUT_LINE('V4 FAIL — 막히지 않고 저장됨(' || n_a || '건). 위 시도 키·일자의 행을 정리해야 함');
                v_done := TRUE;
            ELSIF INSTR(v_msg, 'Unit Price Not Found') > 0 THEN
                DBMS_OUTPUT.PUT_LINE('V4 PASS — 단가 검증으로 차단 · 원장 0 → 0');
                v_done := TRUE;
            END IF;
        END IF;
    END LOOP;
    IF NOT v_done THEN
        DBMS_OUTPUT.PUT_LINE('V4 N/A — 단가 검증까지 도달한 시험 품목 없음 (시도 ' || n_try || '건 모두 앞 단계 검증에서 차단 또는 대상 품목 없음). V1~V3 으로 판정');
    END IF;
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('V4 FAIL — ' || REPLACE(SUBSTR(SQLERRM,1,300), CHR(10), ' / '));
END;
/
