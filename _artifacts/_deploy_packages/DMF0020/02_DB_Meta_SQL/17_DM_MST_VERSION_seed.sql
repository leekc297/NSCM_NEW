/*=============================================================================================
 * File         : 17_DM_MST_VERSION_seed.sql
 * Description  : DM_MST_VERSION 샘플 데이터 시드
 *              :
 *              : 사용자 요구 (2026-06-03): "dm_mst_version Table 에 데이터 넣어주세요"
 *              :
 *              : 정밀 분석:
 *              :   DDL 의무 컬럼 (NN): DIVISION_ID/VERSION_NO/VERSION_TYPE/YYYYMMDD/VER_CRE_SEQ/
 *              :                       CREATED_BY/CREATION_DATE/LAST_UPDATED_BY/LAST_UPDATE_DATE
 *              :   SP body 의존:
 *              :     - DMF0073_GET_VERSION_SALESPRICE p_version_type DEFAULT 'SP_W' (Sales Plan Week)
 *              :     - YYYYMMDD ↔ SCM_SYS_CALENDAR_M.BASIS_YYYYMMDD INNER JOIN
 *              :     - NVL(ATTRIBUTE1, NULL) <> 'MOVE' 필터
 *              :   AS-IS 패턴: DMF0043 ContributeVersionModal 에서 REPORT_SP_W/REPORT_BP_M/REPORT_MF_D
 *              :   DMF0073 Sales Price 도메인 → SP_W (Sales Plan Week) / SP_M (Monthly) 사용
 *              :
 *              : 시드 디자인:
 *              :   3 Division (40/81/82) × 4 주차 (W22~W25, 2026-06) × VERSION_TYPE='SP_W' = 12 rows
 *              :   + 추가 SP_M (Monthly) Division 40 1 row = 13 rows
 *              :
 *              : 멱등 — NOT EXISTS 패턴.
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-06-03
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

INSERT INTO DM_MST_VERSION (
    DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ,
    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
    ATTRIBUTE1, ATTRIBUTE7
)
SELECT s.DIVISION_ID, s.VERSION_NO, s.VERSION_DESCRIPTION, s.VERSION_TYPE, s.YYYYMMDD, s.VER_CRE_SEQ,
       'admin', SYSDATE, 'admin', SYSDATE,
       NULL, 'N'
  FROM (
    -- ----- Division 40 (Mobility & IT Battery), 4 주차 Sales Plan Week -----
    SELECT '40' AS DIVISION_ID, 'SP_W_40_W22_2026' AS VERSION_NO,
           '2026 W22 Sales Plan Week (Mobility)' AS VERSION_DESCRIPTION,
           'SP_W' AS VERSION_TYPE, '20260525' AS YYYYMMDD, 1 AS VER_CRE_SEQ FROM DUAL UNION ALL
    SELECT '40', 'SP_W_40_W23_2026', '2026 W23 Sales Plan Week (Mobility)', 'SP_W', '20260601', 2 FROM DUAL UNION ALL
    SELECT '40', 'SP_W_40_W24_2026', '2026 W24 Sales Plan Week (Mobility)', 'SP_W', '20260608', 3 FROM DUAL UNION ALL
    SELECT '40', 'SP_W_40_W25_2026', '2026 W25 Sales Plan Week (Mobility)', 'SP_W', '20260615', 4 FROM DUAL UNION ALL
    -- ----- Division 81 (ESS Battery), 4 주차 -----
    SELECT '81', 'SP_W_81_W22_2026', '2026 W22 Sales Plan Week (ESS)', 'SP_W', '20260525', 5 FROM DUAL UNION ALL
    SELECT '81', 'SP_W_81_W23_2026', '2026 W23 Sales Plan Week (ESS)', 'SP_W', '20260601', 6 FROM DUAL UNION ALL
    SELECT '81', 'SP_W_81_W24_2026', '2026 W24 Sales Plan Week (ESS)', 'SP_W', '20260608', 7 FROM DUAL UNION ALL
    SELECT '81', 'SP_W_81_W25_2026', '2026 W25 Sales Plan Week (ESS)', 'SP_W', '20260615', 8 FROM DUAL UNION ALL
    -- ----- Division 82 (Power Tool), 4 주차 -----
    SELECT '82', 'SP_W_82_W22_2026', '2026 W22 Sales Plan Week (Power Tool)', 'SP_W', '20260525', 9 FROM DUAL UNION ALL
    SELECT '82', 'SP_W_82_W23_2026', '2026 W23 Sales Plan Week (Power Tool)', 'SP_W', '20260601', 10 FROM DUAL UNION ALL
    SELECT '82', 'SP_W_82_W24_2026', '2026 W24 Sales Plan Week (Power Tool)', 'SP_W', '20260608', 11 FROM DUAL UNION ALL
    SELECT '82', 'SP_W_82_W25_2026', '2026 W25 Sales Plan Week (Power Tool)', 'SP_W', '20260615', 12 FROM DUAL UNION ALL
    -- ----- Monthly 1 row 추가 (Division 40 6월) -----
    SELECT '40', 'SP_M_40_202606',   '2026-06 Monthly Sales Plan (Mobility)', 'SP_M', '20260601', 13 FROM DUAL
  ) s
 WHERE NOT EXISTS (
   SELECT 1 FROM DM_MST_VERSION x
    WHERE x.DIVISION_ID = s.DIVISION_ID AND x.VERSION_NO = s.VERSION_NO
 );

COMMIT;

SET SERVEROUTPUT ON
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM DM_MST_VERSION;
    DBMS_OUTPUT.PUT_LINE('=== DM_MST_VERSION total rows: '||v_cnt);

    SELECT COUNT(*) INTO v_cnt FROM DM_MST_VERSION
     WHERE DIVISION_ID='40' AND VERSION_TYPE='SP_W'
       AND YYYYMMDD BETWEEN '20260301' AND '20260901';
    DBMS_OUTPUT.PUT_LINE('   Division=40 SP_W in period 2026-03~09: '||v_cnt||' (expect 4)');
END;
/

PROMPT === 시드 결과 ===
SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD, VERSION_DESCRIPTION
  FROM DM_MST_VERSION ORDER BY DIVISION_ID, VER_CRE_SEQ;

PROMPT === SP 호출 시뮬 — Division=40, SP_W, 2026-03~2026-09, EMPTY description ===
DECLARE
    v_cur SYS_REFCURSOR;
    v_code VARCHAR2(100); v_vno VARCHAR2(400); v_vdesc VARCHAR2(4000); v_vt VARCHAR2(100);
    v_edi VARCHAR2(10); v_vseq NUMBER; v_yy VARCHAR2(32); v_cb VARCHAR2(600); v_cd DATE;
    v_mrf VARCHAR2(10); v_ed VARCHAR2(10); v_ey VARCHAR2(10);
    v_n PLS_INTEGER := 0;
BEGIN
    SCM_MGR.DMF0073_GET_VERSION_SALESPRICE(
        '20260301', '20260901', NULL, '40', 'SP_W', NULL, 'minyonglee1', 'DMF0020', v_cur
    );
    LOOP
        FETCH v_cur INTO v_code, v_vno, v_vdesc, v_vt, v_edi, v_vseq, v_yy, v_cb, v_cd, v_mrf, v_ed, v_ey;
        EXIT WHEN v_cur%NOTFOUND;
        v_n := v_n + 1;
        DBMS_OUTPUT.PUT_LINE('  ['||v_n||'] '||v_code||' / '||v_vno||' / '||v_yy);
    END LOOP;
    CLOSE v_cur;
    DBMS_OUTPUT.PUT_LINE('   total rows returned: '||v_n);
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('   ERROR: '||SQLERRM);
END;
/
