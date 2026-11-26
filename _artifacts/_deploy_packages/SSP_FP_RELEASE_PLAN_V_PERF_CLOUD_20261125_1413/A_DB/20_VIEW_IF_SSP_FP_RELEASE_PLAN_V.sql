-- SOURCE-FRESH: FP_MGR.IF_SSP_FP_RELEASE_PLAN_V VIEW LAST_DDL=2026-11-17 17:17:28 FETCHED=2026-11-25 13:57 DB=ZIOUI1
/* 20_VIEW FP_MGR.IF_SSP_FP_RELEASE_PLAN_V — 활성화 공정 변환 갈래(UNION ALL 3번째, 4번째)의 SCM_ITEM_M 조인 변경 (E20261125-FPRELV-ITEMJOIN)
 * 원인 : 3번째 갈래(FP_DAILY_PRODUCTIOIN_PLAN_H)에서 옵티마이저가 조회 기준값을 1행으로 추정하고
 *        SCM_ITEM_M 40 사업부 245K행과 카테시안 조인 → 품목 행마다 IX01_FP_DAILY_PRODUCTIOIN_PLAN_H 범위 검색 반복
 * 변경 : SCM_ITEM_M 을 FROM 에서 빼고
 *        - 조인 조건 → EXISTS(PK_SCM_ITEM_M 4컬럼 일치)
 *        - OPERATION_ID → SCM_ITEM_M PK 단건 조회
 *        SCM_ITEM_M PK = ITEM_ID, COMPANY_ID, DIVISION_ID, SITE_ID 이고 조인 컬럼과 같아 결과 행이 바뀌지 않음
 * 치환 3종(각 2곳) 원문 일치 확인 후 치환 · 하나라도 2곳이 아니면 -20011 로 중단(원문 무변경) · 표식이 있으면 SKIP
 * FORCE 없이 CREATE OR REPLACE · 컴파일 오류면 문장이 실패하고 원래 뷰가 그대로 남음 · 권한(GRANT) 유지
 * 실행 계정 FP_MGR 또는 DBA · 전체 F5 · 반복 실행 안전
 */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    c_mark   CONSTANT VARCHAR2(40) := 'E20261125-FPRELV-ITEMJOIN';
    v_src    VARCHAR2(32767);
    v_new    VARCHAR2(32767);
    v_cols   VARCHAR2(4000);
    v_status VARCHAR2(30);

    FUNCTION cnt(p_txt VARCHAR2, p_pat VARCHAR2) RETURN PLS_INTEGER IS
        n   PLS_INTEGER := 0;
        pos PLS_INTEGER := 1;
    BEGIN
        LOOP
            pos := INSTR(p_txt, p_pat, pos);
            EXIT WHEN pos = 0;
            n := n + 1;
            pos := pos + LENGTH(p_pat);
        END LOOP;
        RETURN n;
    END;

    PROCEDURE rep(p_old VARCHAR2, p_new VARCHAR2, p_expect PLS_INTEGER, p_name VARCHAR2) IS
        n PLS_INTEGER := cnt(v_new, p_old);
    BEGIN
        IF n <> p_expect THEN
            RAISE_APPLICATION_ERROR(-20011, '치환 대상 ' || p_name || ' 일치 ' || n || '곳(기대 ' || p_expect || '곳). 원문 무변경. 클라우드 뷰 원문 전달 필요');
        END IF;
        v_new := REPLACE(v_new, p_old, p_new);
        DBMS_OUTPUT.PUT_LINE('> 치환 ' || p_name || ' ' || n || '곳');
    END;
BEGIN
    SELECT TEXT INTO v_src FROM ALL_VIEWS WHERE OWNER = 'FP_MGR' AND VIEW_NAME = 'IF_SSP_FP_RELEASE_PLAN_V';
    IF INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP   이미 반영됨(' || c_mark || ') · 원문 무변경');
        RETURN;
    END IF;

    v_new := v_src;
    /* (1) SELECT 목록 OPERATION_ID : SCM_ITEM_M 컬럼 → PK 단건 조회 */
    rep(q'[SUBSTR(SI.FORMATION_FLOW_ID, GREATEST(LENGTH(SI.FORMATION_FLOW_ID) - 4, 1)) AS OPERATION_ID]'
      , q'[(SELECT /* E20261125-FPRELV-ITEMJOIN */ SUBSTR(SI.FORMATION_FLOW_ID, GREATEST(LENGTH(SI.FORMATION_FLOW_ID) - 4, 1)) FROM SCM_ITEM_M SI WHERE SI.ITEM_ID = DPP.ITEM_ID AND SI.COMPANY_ID = DPP.COMPANY_ID AND SI.DIVISION_ID = DPP.DIVISION_ID AND SI.SITE_ID = DPP.SITE_ID) AS OPERATION_ID]'
      , 2, 'OPERATION_ID');
    /* (2) FROM 목록 : SCM_ITEM_M SI 제거 */
    rep(q'[, SCM_ITEM_M SI]', NULL, 2, 'FROM SCM_ITEM_M');
    /* (3) WHERE 조인 조건 → EXISTS */
    rep(q'[WHERE DPP.SITE_ID = SI.SITE_ID AND DPP.COMPANY_ID = SI.COMPANY_ID AND DPP.DIVISION_ID = SI.DIVISION_ID AND DPP.ITEM_ID = SI.ITEM_ID]'
      , q'[WHERE EXISTS (SELECT 1 FROM SCM_ITEM_M SI WHERE SI.ITEM_ID = DPP.ITEM_ID AND SI.COMPANY_ID = DPP.COMPANY_ID AND SI.DIVISION_ID = DPP.DIVISION_ID AND SI.SITE_ID = DPP.SITE_ID)]'
      , 2, 'WHERE SCM_ITEM_M');

    IF cnt(v_new, 'FROM SCM_ITEM_M SI WHERE') <> 4 THEN
        RAISE_APPLICATION_ERROR(-20012, '치환 뒤 SCM_ITEM_M 조회 ' || cnt(v_new, 'FROM SCM_ITEM_M SI WHERE') || '곳(기대 4곳). 원문 무변경');
    END IF;

    SELECT LISTAGG('"' || COLUMN_NAME || '"', ', ') WITHIN GROUP (ORDER BY COLUMN_ID)
      INTO v_cols
      FROM ALL_TAB_COLUMNS
     WHERE OWNER = 'FP_MGR' AND TABLE_NAME = 'IF_SSP_FP_RELEASE_PLAN_V';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE EDITIONABLE VIEW "FP_MGR"."IF_SSP_FP_RELEASE_PLAN_V" (' || v_cols || ') AS ' || v_new;

    SELECT STATUS INTO v_status FROM ALL_OBJECTS WHERE OWNER = 'FP_MGR' AND OBJECT_NAME = 'IF_SSP_FP_RELEASE_PLAN_V' AND OBJECT_TYPE = 'VIEW';
    DBMS_OUTPUT.PUT_LINE('> APPLY  FP_MGR.IF_SSP_FP_RELEASE_PLAN_V ' || v_status || ' · 원문 ' || LENGTH(v_src) || '자 → ' || LENGTH(v_new) || '자');
END;
/
SELECT OWNER, OBJECT_NAME, OBJECT_TYPE, STATUS, LAST_DDL_TIME
  FROM ALL_OBJECTS
 WHERE (OWNER = 'FP_MGR' AND OBJECT_NAME = 'IF_SSP_FP_RELEASE_PLAN_V')
    OR (OWNER = 'SCM_MGR' AND OBJECT_NAME IN ('SSP_DNM_FP_RELEASE_PLAN_V_SN', 'SSP_DNM_PLAN_FROZEN_V', 'PR_SSP_ANL_SHIP_PLAN_40'))
 ORDER BY OWNER, OBJECT_NAME;
