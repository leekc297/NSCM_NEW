/* 90 VERIFY — V1~V5 조회 전용 · V6 은 없는 버전으로 GET 1회 호출(GTT 만 사용, 커밋 없음) — 오류 없이 끝나야 한다 */
SELECT 'V1 VALID' AS chk, status AS val FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = 'PKG_DMF0068' AND object_type = 'PACKAGE BODY'
UNION ALL SELECT 'V2 마커 3', TO_CHAR(COUNT(*)) FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PKG_DMF0068' AND type = 'PACKAGE BODY' AND text LIKE '%E20261009-VERNODATA%'
UNION ALL SELECT 'V3 NO_DATA_FOUND 가드 1', TO_CHAR(COUNT(*)) FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PKG_DMF0068' AND type = 'PACKAGE BODY' AND text LIKE '%WHEN NO_DATA_FOUND THEN V_ORI_VERSION_NO := NULL%'
UNION ALL SELECT 'V4 줄 수 1483', TO_CHAR(MAX(line)) FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PKG_DMF0068' AND type = 'PACKAGE BODY'
UNION ALL SELECT 'V5 의존 INVALID 0', TO_CHAR(COUNT(*)) FROM all_objects o WHERE o.owner = 'SCM_MGR' AND o.status = 'INVALID'
                 AND o.object_name IN (SELECT name FROM all_dependencies WHERE referenced_owner = 'SCM_MGR' AND referenced_name = 'PKG_DMF0068');
/* V6 — 클라우드 오류 파라미터 그대로 호출 (없는 버전). 적용 전이면 ORA-20001/ORA-01403, 적용 후면 정상 종료 */
DECLARE
  rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rr SYS_REFCURSOR; v_code VARCHAR2(10); v_msg VARCHAR2(4000); v_evt VARCHAR2(100);
BEGIN
  SCM_MGR.PKG_DMF0068.P_DMF0068_GET_ORDERLIST('40', 'R_S_20260902_V005', '202501', '202712', 'minyonglee1', 'DMF0068', rc1, rc2, rr);
  FETCH rr INTO v_code, v_msg, v_evt;
  CLOSE rc1; CLOSE rc2; CLOSE rr;
  DBMS_OUTPUT.PUT_LINE('V6 없는 버전 호출 OK — RESULT CODE=' || v_code || ' MSG=' || v_msg);
  ROLLBACK;
END;
/
