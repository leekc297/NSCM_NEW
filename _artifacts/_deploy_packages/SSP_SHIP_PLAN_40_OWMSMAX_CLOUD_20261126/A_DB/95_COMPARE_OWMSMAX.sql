/* 효과 확인 (조회만) : 1-1 단계 MAX(CUTOFF_DATE) 를 원문(함수), 변경(스칼라 서브쿼리), JOIN(함수 없이 EXISTS) 3가지로 같은 입력에 실행해 결과, 소요 비교
 * 사내 ZIOUI1 2026-11-26 14:21 (3회 평균) : 함수 2.61초, 스칼라 0.25초, JOIN 0.76초. 결과 9건 같음
 * [DUP] = OWMS(40) 품목 중 SCM_MST_ITEM_SN 같은 키에 SCP_OPERATION_GROUP 이 여러 개인 품목 수. 0 이 아니면 JOIN 결과가 함수와 다를 수 있음
 * 클라우드 11-26 SQL 모니터 : 원문 문장(83wgypmy3wyvu) 회차당 73.3 ~ 75.8초
 * SCM_MGR 접속, 전체 실행(F5). Output 창의 [DUP] 1줄, [CMP] 3줄을 회신 */
SET SERVEROUTPUT ON SIZE UNLIMITED
ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;
DECLARE
    v_old VARCHAR2(8);
    v_new VARCHAR2(8);
    v_jn  VARCHAR2(8);
    t0    TIMESTAMP;
    s_old NUMBER;
    s_new NUMBER;
    s_jn  NUMBER;
    n_dup NUMBER;
    FUNCTION sec(a TIMESTAMP, b TIMESTAMP) RETURN NUMBER IS
    BEGIN
        RETURN ROUND(EXTRACT(MINUTE FROM (b - a)) * 60 + EXTRACT(SECOND FROM (b - a)), 2);
    END;
BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';   /* SP 안 설정과 같게 */
    SELECT COUNT(DISTINCT O.PLANT_ID || '|' || O.ITEM_ID)
      INTO n_dup
      FROM SSP_DNM_OWMS_STOCK O
     WHERE O.PROD_GROUP = '40'
       AND (O.PROD_GROUP, O.ITEM_ID) IN (SELECT DIVISION_ID, ITEM_ID FROM SCM_MST_ITEM_SN
                                          GROUP BY DIVISION_ID, ITEM_ID HAVING COUNT(DISTINCT NVL(SCP_OPERATION_GROUP, '~')) > 1);
    DBMS_OUTPUT.PUT_LINE('[DUP] ' || n_dup);
    FOR r IN (SELECT 'HQ00' AS CO FROM DUAL UNION ALL SELECT 'NJ00' FROM DUAL UNION ALL SELECT 'AZ00' FROM DUAL) LOOP
        t0 := SYSTIMESTAMP;
        SELECT MAX(CUTOFF_DATE)
          INTO v_old
          FROM SSP_DNM_OWMS_STOCK O
               JOIN SCM_MST_SITE B
            ON B.DIVISION_ID = '40'
           AND NVL(B.COMPANY_ID, '-') = NVL(r.CO, '-')
           AND B.DIVISION_ID = O.DIVISION_ID
           AND B.PLANT_ID = O.PLANT_ID
         WHERE 1 = 1
           AND O.PROD_GROUP = '40'
           AND FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) IS NOT NULL;
        s_old := sec(t0, SYSTIMESTAMP);
        t0 := SYSTIMESTAMP;
        SELECT MAX(CUTOFF_DATE)
          INTO v_new
          FROM SSP_DNM_OWMS_STOCK O
               JOIN SCM_MST_SITE B
            ON B.DIVISION_ID = '40'
           AND NVL(B.COMPANY_ID, '-') = NVL(r.CO, '-')
           AND B.DIVISION_ID = O.DIVISION_ID
           AND B.PLANT_ID = O.PLANT_ID
         WHERE 1 = 1
           AND O.PROD_GROUP = '40'
           AND (SELECT FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) FROM DUAL) IS NOT NULL;
        s_new := sec(t0, SYSTIMESTAMP);
        t0 := SYSTIMESTAMP;
        SELECT MAX(CUTOFF_DATE)
          INTO v_jn
          FROM SSP_DNM_OWMS_STOCK O
               JOIN SCM_MST_SITE B
            ON B.DIVISION_ID = '40'
           AND NVL(B.COMPANY_ID, '-') = NVL(r.CO, '-')
           AND B.DIVISION_ID = O.DIVISION_ID
           AND B.PLANT_ID = O.PLANT_ID
         WHERE 1 = 1
           AND O.PROD_GROUP = '40'
           AND EXISTS (SELECT 1
                         FROM SCM_MST_ITEM_SN S
                            , SCM_MST_SITE I
                        WHERE S.DIVISION_ID     = O.PROD_GROUP
                          AND S.ITEM_ID         = O.ITEM_ID
                          AND I.PLANT_ID        = O.PLANT_ID
                          AND I.OPERATION_GROUP = S.SCP_OPERATION_GROUP
                          AND I.SITE_TYPE       = 'PLANT'
                          AND I.VALID_YN        = 'Y');
        s_jn := sec(t0, SYSTIMESTAMP);
        DBMS_OUTPUT.PUT_LINE('[CMP] ' || r.CO || ' 함수 ' || v_old || ' ' || s_old || '초 · 스칼라 ' || v_new || ' ' || s_new || '초 · JOIN ' || v_jn || ' ' || s_jn || '초 · '
                          || CASE WHEN NVL(v_old, '~') = NVL(v_new, '~') AND NVL(v_old, '~') = NVL(v_jn, '~') THEN '결과 같음' ELSE '결과 다름' END);
    END LOOP;
END;
/
