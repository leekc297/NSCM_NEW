-- 90 VERIFY — [E20261013-DMF0005MCDUP] V1~V3 조회 전용 · V4 = 키가 겹치는 변경쌍 1건으로 저장 SP 호출 → 검증 메시지로 차단되는지 확인
-- * 기대: V1 마커 PASS(4) · V2 VALID/오류 0 · V3 CHECK_DUP 호출 줄 · V4 'PASS — 검증 메시지로 차단'
-- * V4 는 **마커가 있을 때만** 호출한다.
--   시험 변경쌍 = SCM_MST_SITE_ITEM(40)에서 같은 Division·Project·Site 에 앞 11자리가 같은 Model 두 개가 함께 등록된 것.
--   이 쌍은 키가 겹치므로 저장이 성공할 수 없다(검증으로 막히거나, 막히지 않아도 ORA-00001 로 전체 ROLLBACK) → 데이터가 바뀌지 않는다.
--   품목 마스터에 없는 코드면 앞 단계 검증('존재하지 않는 코드')에서 먼저 막히므로 다음 쌍으로 넘어간다 (최대 20 쌍).
--   호출 중에는 앞선 대상 테이블 갱신이 잠깐 수행됐다가 되돌려진다 (사내 4~14초).
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A8
COLUMN TXT FORMAT A150
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 4 THEN 'PASS' WHEN COUNT(*) = 0 THEN 'FAIL (미적용)' ELSE 'FAIL (마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0005' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20261013-DMF0005MCDUP%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0005')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0005' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 줄' CHK, S.LINE, SUBSTR(LTRIM(RTRIM(S.TEXT, CHR(10)||CHR(13))),1,150) TXT
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0005' AND S.TYPE='PACKAGE BODY' AND S.TEXT LIKE '%E20261013-DMF0005MCDUP%'
 ORDER BY S.LINE;
DECLARE
    n_mark PLS_INTEGER;
    n_try  PLS_INTEGER := 0;
    v_done BOOLEAN := FALSE;
    rc     SYS_REFCURSOR;
    v_code VARCHAR2(100); v_msg VARCHAR2(4000); v_evt VARCHAR2(400);
    n_b    PLS_INTEGER; n_a PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO n_mark FROM USER_SOURCE WHERE NAME='PKG_DMF0005' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20261013-DMF0005MCDUP%';
    IF n_mark = 0 THEN
        DBMS_OUTPUT.PUT_LINE('V4 SKIP — 미적용 상태 (10 적용 뒤 다시 실행)');
        RETURN;
    END IF;
    FOR k IN (SELECT B.ITEM_ID AS BEF, A.ITEM_ID AS AFT, COUNT(*) AS KEYS
                FROM SCM_MST_SITE_ITEM B
                JOIN SCM_MST_SITE_ITEM A ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                        AND A.ITEM_ID <> B.ITEM_ID AND SUBSTR(A.ITEM_ID, 1, 11) = SUBSTR(B.ITEM_ID, 1, 11)
               WHERE B.DIVISION_ID = '40' AND B.ITEM_ID LIKE 'MP%' AND LENGTH(B.ITEM_ID) = 12 AND LENGTH(A.ITEM_ID) = 12
                 AND B.ITEM_ID = UPPER(B.ITEM_ID) AND A.ITEM_ID = UPPER(A.ITEM_ID)
               GROUP BY B.ITEM_ID, A.ITEM_ID
               ORDER BY COUNT(*), B.ITEM_ID, A.ITEM_ID FETCH FIRST 20 ROWS ONLY) LOOP
        EXIT WHEN v_done;
        n_try := n_try + 1;
        SELECT COUNT(*) INTO n_b FROM SCM_MST_SITE_ITEM WHERE DIVISION_ID = '40' AND ITEM_ID = k.BEF;
        SCM_MGR.PKG_DMF0005.P_DMF0005_SAVE_MODEL_CHANGE_POPUP(
            '[{"ITEM_ID_BEFORE":"' || k.BEF || '","ITEM_ID_AFTER":"' || k.AFT || '"}]', 'minyonglee1', rc);
        FETCH rc INTO v_code, v_msg, v_evt;
        CLOSE rc;
        ROLLBACK;
        SELECT COUNT(*) INTO n_a FROM SCM_MST_SITE_ITEM WHERE DIVISION_ID = '40' AND ITEM_ID = k.BEF;
        DBMS_OUTPUT.PUT_LINE('V4 시도 ' || n_try || ' = ' || k.BEF || ' -> ' || k.AFT || ' (겹치는 키 ' || k.KEYS || ') → ' || v_code || ' | ' || REPLACE(SUBSTR(v_msg, 1, 200), CHR(10), ' / '));
        IF n_a <> n_b THEN
            DBMS_OUTPUT.PUT_LINE('V4 FAIL — 변경 전 Model 행 수가 달라짐 (' || n_b || ' → ' || n_a || ')');
            v_done := TRUE;
        ELSIF v_code = '-1' AND INSTR(v_msg, '이미 등록되어') > 0 THEN
            DBMS_OUTPUT.PUT_LINE('V4 PASS — 검증 메시지로 차단 · 변경 전 Model 행 수 ' || n_b || ' → ' || n_a);
            v_done := TRUE;
        END IF;
    END LOOP;
    IF NOT v_done THEN
        DBMS_OUTPUT.PUT_LINE('V4 N/A — 키 중복 검증까지 도달한 시험 쌍 없음 (시도 ' || n_try || '건 — 겹치는 쌍이 없거나 모두 앞 단계 검증에서 차단). V1~V3 으로 판정');
    END IF;
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('V4 FAIL — ' || REPLACE(SUBSTR(SQLERRM, 1, 300), CHR(10), ' / '));
END;
/
