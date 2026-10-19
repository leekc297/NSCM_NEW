/* =====================================================================================================
 * 04_L384_elapsed_T1-T3.sql — WEEKLY_ROLLING 루트 L384 INSERT(MKT_FCST → MKT_FCST_C) 첫 갈래 SELECT 의 클라우드 실측
 * 결과 = 쿼리 결과 행에 건수 / 합계 / 소요초가 문자열로 찍힘 (도구의 경과 표시 불필요)
 * 조회 전용 (SELECT 만). 클라우드 SCM_MGR 로 실행. 각 문장을 통째로 선택해서 실행 (SQL*Plus 명령·& 치환 없음)
 *
 *   T0  : 한 번에 3개 순서대로 실행 (T1 → T2 → T3) — 결과 1행. 이것만 실행해도 됨
 *   T1  : 현재 SP 형태 = 술어 안 FN_NEXT_DAY(SYSDATE) 함수 날짜
 *   T2  : 리터럴 날짜 '20261005' (이번 주 월요일 = FN_NEXT_DAY(SYSDATE,'MON')-7)
 *   T3  : 바인드 형태 (:B1 사업부) — 40 으로 "먼저" 파싱될 때의 소요 (SP 안 커서가 40 전용 계획을 가질 때의 값)
 *   T9  : WITH FUNCTION 이 도구에서 안 될 때의 대체 — 익명 블록이 결과를 ORA-20000 메시지로 되돌림 (오류창에 결과가 뜸)
 *
 * 기대 cnt = 셋 다 동일 (사내 40 = 191,466 / 클라우드 10-05 기준 ≈ 423,068). 다르면 데이터가 움직인 것이므로 그대로 알려 주세요.
 * ===================================================================================================== */

/* ---------- T0. 한 번에 (T1 → T2 → T3 순) ---------- */
WITH FUNCTION f_run(p_tag VARCHAR2, p_sql VARCHAR2, p_div VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
    t0 TIMESTAMP := SYSTIMESTAMP; v_cnt NUMBER; v_sum NUMBER; v_el NUMBER;
BEGIN
    IF p_div IS NULL THEN EXECUTE IMMEDIATE p_sql INTO v_cnt, v_sum;
    ELSE EXECUTE IMMEDIATE p_sql INTO v_cnt, v_sum USING p_div; END IF;
    v_el := EXTRACT(SECOND FROM (SYSTIMESTAMP - t0)) + EXTRACT(MINUTE FROM (SYSTIMESTAMP - t0)) * 60 + EXTRACT(HOUR FROM (SYSTIMESTAMP - t0)) * 3600;
    RETURN p_tag || ' cnt=' || v_cnt || ' sum=' || v_sum || ' elapsed=' || ROUND(v_el, 2) || 's';
END;
SELECT 'T0 | ' || TO_CHAR(SYSDATE, 'MM-DD HH24:MI:SS') || ' | from=' || TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')
    || ' || ' || f_run('T1함수날짜', q'{
SELECT COUNT(*), SUM(F.QTY)
  FROM SCM_MGR.DM_PLN_MKT_FCST F, SCM_MGR.SCM_MST_SITE_ITEM T2
 WHERE F.DIVISION_ID = T2.DIVISION_ID AND F.PROJECT_CODE = T2.PROJECT_CODE AND F.SCM_SITE_ID = T2.SCM_SITE_ID AND F.ITEM_ID = T2.ITEM_ID
   AND T2.VALID_YN = 'Y' AND F.DIVISION_ID = '40'
   AND F.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')
   AND F.MEASURE NOT IN ('CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]','Commercial_Agreement[Org.]','Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]')}')
    || ' || ' || f_run('T2리터럴', q'{
SELECT COUNT(*), SUM(F.QTY)
  FROM SCM_MGR.DM_PLN_MKT_FCST F, SCM_MGR.SCM_MST_SITE_ITEM T2
 WHERE F.DIVISION_ID = T2.DIVISION_ID AND F.PROJECT_CODE = T2.PROJECT_CODE AND F.SCM_SITE_ID = T2.SCM_SITE_ID AND F.ITEM_ID = T2.ITEM_ID
   AND T2.VALID_YN = 'Y' AND F.DIVISION_ID = '40'
   AND F.YYYYMMDD >= '20261005'
   AND F.MEASURE NOT IN ('CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]','Commercial_Agreement[Org.]','Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]')}')
    || ' || ' || f_run('T3바인드40', q'{
SELECT COUNT(*), SUM(F.QTY)
  FROM SCM_MGR.DM_PLN_MKT_FCST F, SCM_MGR.SCM_MST_SITE_ITEM T2
 WHERE F.DIVISION_ID = T2.DIVISION_ID AND F.PROJECT_CODE = T2.PROJECT_CODE AND F.SCM_SITE_ID = T2.SCM_SITE_ID AND F.ITEM_ID = T2.ITEM_ID
   AND T2.VALID_YN = 'Y' AND F.DIVISION_ID = :B1
   AND F.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')
   AND F.MEASURE NOT IN ('CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]','Commercial_Agreement[Org.]','Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]')}', '40') AS line
  FROM dual;


/* ---------- T1. 현재 형태 (함수 날짜) 단독 ---------- */
WITH FUNCTION f_run(p_sql VARCHAR2) RETURN VARCHAR2 IS
    t0 TIMESTAMP := SYSTIMESTAMP; v_cnt NUMBER; v_sum NUMBER;
BEGIN
    EXECUTE IMMEDIATE p_sql INTO v_cnt, v_sum;
    RETURN 'cnt=' || v_cnt || ' | sum=' || v_sum || ' | elapsed=' || ROUND(EXTRACT(SECOND FROM (SYSTIMESTAMP - t0)) + EXTRACT(MINUTE FROM (SYSTIMESTAMP - t0)) * 60 + EXTRACT(HOUR FROM (SYSTIMESTAMP - t0)) * 3600, 2) || 's';
END;
SELECT 'T1 함수날짜 | ' || f_run(q'{
SELECT COUNT(*), SUM(F.QTY)
  FROM SCM_MGR.DM_PLN_MKT_FCST F, SCM_MGR.SCM_MST_SITE_ITEM T2
 WHERE F.DIVISION_ID = T2.DIVISION_ID AND F.PROJECT_CODE = T2.PROJECT_CODE AND F.SCM_SITE_ID = T2.SCM_SITE_ID AND F.ITEM_ID = T2.ITEM_ID
   AND T2.VALID_YN = 'Y' AND F.DIVISION_ID = '40'
   AND F.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')
   AND F.MEASURE NOT IN ('CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]','Commercial_Agreement[Org.]','Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]')}') AS line
  FROM dual;


/* ---------- T2. 리터럴 날짜 단독 ---------- */
WITH FUNCTION f_run(p_sql VARCHAR2) RETURN VARCHAR2 IS
    t0 TIMESTAMP := SYSTIMESTAMP; v_cnt NUMBER; v_sum NUMBER;
BEGIN
    EXECUTE IMMEDIATE p_sql INTO v_cnt, v_sum;
    RETURN 'cnt=' || v_cnt || ' | sum=' || v_sum || ' | elapsed=' || ROUND(EXTRACT(SECOND FROM (SYSTIMESTAMP - t0)) + EXTRACT(MINUTE FROM (SYSTIMESTAMP - t0)) * 60 + EXTRACT(HOUR FROM (SYSTIMESTAMP - t0)) * 3600, 2) || 's';
END;
SELECT 'T2 리터럴날짜 | ' || f_run(q'{
SELECT COUNT(*), SUM(F.QTY)
  FROM SCM_MGR.DM_PLN_MKT_FCST F, SCM_MGR.SCM_MST_SITE_ITEM T2
 WHERE F.DIVISION_ID = T2.DIVISION_ID AND F.PROJECT_CODE = T2.PROJECT_CODE AND F.SCM_SITE_ID = T2.SCM_SITE_ID AND F.ITEM_ID = T2.ITEM_ID
   AND T2.VALID_YN = 'Y' AND F.DIVISION_ID = '40'
   AND F.YYYYMMDD >= '20261005'
   AND F.MEASURE NOT IN ('CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]','Commercial_Agreement[Org.]','Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]')}') AS line
  FROM dual;


/* ---------- T3. 바인드 형태(40 파싱) 단독 ---------- */
WITH FUNCTION f_run(p_sql VARCHAR2, p_div VARCHAR2) RETURN VARCHAR2 IS
    t0 TIMESTAMP := SYSTIMESTAMP; v_cnt NUMBER; v_sum NUMBER;
BEGIN
    EXECUTE IMMEDIATE p_sql INTO v_cnt, v_sum USING p_div;
    RETURN 'cnt=' || v_cnt || ' | sum=' || v_sum || ' | elapsed=' || ROUND(EXTRACT(SECOND FROM (SYSTIMESTAMP - t0)) + EXTRACT(MINUTE FROM (SYSTIMESTAMP - t0)) * 60 + EXTRACT(HOUR FROM (SYSTIMESTAMP - t0)) * 3600, 2) || 's';
END;
SELECT 'T3 바인드(40 파싱) | ' || f_run(q'{
SELECT COUNT(*), SUM(F.QTY)
  FROM SCM_MGR.DM_PLN_MKT_FCST F, SCM_MGR.SCM_MST_SITE_ITEM T2
 WHERE F.DIVISION_ID = T2.DIVISION_ID AND F.PROJECT_CODE = T2.PROJECT_CODE AND F.SCM_SITE_ID = T2.SCM_SITE_ID AND F.ITEM_ID = T2.ITEM_ID
   AND T2.VALID_YN = 'Y' AND F.DIVISION_ID = :B1
   AND F.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')
   AND F.MEASURE NOT IN ('CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]','Commercial_Agreement[Org.]','Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]')}', '40') AS line
  FROM dual;


/* ---------- T9. 대체판 — WITH FUNCTION 이 도구에서 거부될 때 (ORA-00905/ORA-32034 등) ----------
 * 익명 블록. 3개를 순서대로 돌리고 결과 문자열을 ORA-20000 으로 되돌림 → 도구의 오류 메시지 창에 결과가 보임.
 * 쓰기 없음(SELECT 만). 오류로 끝나지만 실패가 아님.                                                           */
DECLARE
    v_cnt NUMBER; v_sum NUMBER; t0 TIMESTAMP; v_out VARCHAR2(4000);
    PROCEDURE run(p_tag VARCHAR2, p_sql VARCHAR2, p_div VARCHAR2 DEFAULT NULL) IS
        v_el NUMBER;
    BEGIN
        t0 := SYSTIMESTAMP;
        IF p_div IS NULL THEN EXECUTE IMMEDIATE p_sql INTO v_cnt, v_sum;
        ELSE EXECUTE IMMEDIATE p_sql INTO v_cnt, v_sum USING p_div; END IF;
        v_el := EXTRACT(SECOND FROM (SYSTIMESTAMP - t0)) + EXTRACT(MINUTE FROM (SYSTIMESTAMP - t0)) * 60 + EXTRACT(HOUR FROM (SYSTIMESTAMP - t0)) * 3600;
        v_out := v_out || ' || ' || p_tag || ' cnt=' || v_cnt || ' sum=' || v_sum || ' elapsed=' || ROUND(v_el, 2) || 's';
    END;
BEGIN
    v_out := 'T9 | ' || TO_CHAR(SYSDATE, 'MM-DD HH24:MI:SS') || ' | from=' || TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD');
    run('T1함수날짜', q'{SELECT COUNT(*), SUM(F.QTY) FROM SCM_MGR.DM_PLN_MKT_FCST F, SCM_MGR.SCM_MST_SITE_ITEM T2 WHERE F.DIVISION_ID = T2.DIVISION_ID AND F.PROJECT_CODE = T2.PROJECT_CODE AND F.SCM_SITE_ID = T2.SCM_SITE_ID AND F.ITEM_ID = T2.ITEM_ID AND T2.VALID_YN = 'Y' AND F.DIVISION_ID = '40' AND F.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD') AND F.MEASURE NOT IN ('CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]','Commercial_Agreement[Org.]','Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]')}');
    run('T2리터럴',   q'{SELECT COUNT(*), SUM(F.QTY) FROM SCM_MGR.DM_PLN_MKT_FCST F, SCM_MGR.SCM_MST_SITE_ITEM T2 WHERE F.DIVISION_ID = T2.DIVISION_ID AND F.PROJECT_CODE = T2.PROJECT_CODE AND F.SCM_SITE_ID = T2.SCM_SITE_ID AND F.ITEM_ID = T2.ITEM_ID AND T2.VALID_YN = 'Y' AND F.DIVISION_ID = '40' AND F.YYYYMMDD >= '20261005' AND F.MEASURE NOT IN ('CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]','Commercial_Agreement[Org.]','Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]')}');
    run('T3바인드40', q'{SELECT COUNT(*), SUM(F.QTY) FROM SCM_MGR.DM_PLN_MKT_FCST F, SCM_MGR.SCM_MST_SITE_ITEM T2 WHERE F.DIVISION_ID = T2.DIVISION_ID AND F.PROJECT_CODE = T2.PROJECT_CODE AND F.SCM_SITE_ID = T2.SCM_SITE_ID AND F.ITEM_ID = T2.ITEM_ID AND T2.VALID_YN = 'Y' AND F.DIVISION_ID = :B1 AND F.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD') AND F.MEASURE NOT IN ('CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]','Commercial_Agreement[Org.]','Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]')}', '40');
    RAISE_APPLICATION_ERROR(-20000, v_out);
END;
