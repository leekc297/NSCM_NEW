/*=============================================================================================
 * File         : 03_PR_Get_Procedures_Metadata.sql
 * Description  : PR_GET_PROCEDURES_METADATA — 전체 화면(MENU)별 PKG.SP + IN/OUT 컬럼 메타데이터
 *              : FE procedures.d.ts 자동 생성 (`pnpm gen:procedures`)을 위한 BE 메타 API의 DB 단.
 *
 * 호출 흐름   :
 *   FE `pnpm gen:procedures` (gen-procedures.ts)
 *     → BE GET /admin/dev/procedures-metadata
 *     → BE DevToolsServiceImpl
 *     → MyBatis admin.devtools.retrieveProceduresMetadata
 *     → ★ SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROCEDURES_METADATA(O_CURSOR)
 *     ← cursor: (MNU_ID, MNU_DESC, SHT_NM, MNU_BTN_CD, PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD)
 *
 * 참고      : SCM_ADM_MNU_BTN_MPG_M (메뉴×시트×버튼) + SCM_ADM_API_M (API) + SCM_ADM_PROC_M (PKG.SP 컬럼)
 *
 * 실행 순서   : 06_Packages 단계 (PKG_NSCM_UI_COMM 본체에 흡수 — 본 파일은 ALTER PACKAGE로 추가)
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/


-- ====== PACKAGE SPEC — PR_GET_PROCEDURES_METADATA 추가 ======
-- (실제 적용 시 `04_Package_PKG_NSCM_UI_COMM.sql` 의 PACKAGE SPEC 블록에 아래 PROCEDURE 시그니처를 합쳐 재컴파일)

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_NSCM_UI_COMM
AS

    /* (...기존 PROCEDURE 시그니처 유지...) */

    /**
     * 모든 메뉴의 PKG.SP 컬럼 메타데이터 일괄 조회 (FE procedures.d.ts 자동 생성용)
     *
     * @param O_CURSOR  - (MNU_ID, MNU_DESC, SHT_NM, MNU_BTN_CD, API_ID, PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD)
     *                    COL_TP_CD: 'IN' (입력 파라미터) / 'OUT' (출력 컬럼) / 'NORMAL'
     *                    DATA_TP_CD: 'STRING' / 'NUMBER' / 'DATE' / 'CLOB' / 'CURSOR' 등
     */
    PROCEDURE PR_GET_PROCEDURES_METADATA (
        O_CURSOR        OUT     SYS_REFCURSOR
    );

    /* 화면 단위 메타데이터 조회 (특정 MENU_ID 만) */
    PROCEDURE PR_GET_PROCEDURE_METADATA_BY_MENU (
        P_MNU_ID        IN      VARCHAR2,
        O_CURSOR        OUT     SYS_REFCURSOR
    );

END PKG_NSCM_UI_COMM;
/


-- ====== PACKAGE BODY ======
-- (PKG_NSCM_UI_COMM 본체에 흡수)

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_NSCM_UI_COMM
AS

    /* (...기존 PROCEDURE 본문 유지...) */


--==============================================================================================
    PROCEDURE PR_GET_PROCEDURES_METADATA (
        O_CURSOR        OUT     SYS_REFCURSOR
    ) IS
    BEGIN
        /* 화면(MENU) × 시트 × 버튼 별 PKG.SP 와 그 SP의 컬럼 메타를 평탄화하여 반환.
         * FE 스크립트(gen-procedures.ts)가 이를 그룹핑하여 procedures.d.ts 생성.
         */
        OPEN O_CURSOR FOR
        SELECT  M.MNU_ID                                AS MNU_ID,
                NVL(M.MNU_NM, M.MNU_DESC)               AS MNU_DESC,
                NVL(BMP.SHT_NM, '_DEFAULT_')            AS SHT_NM,
                NVL(BMP.MNU_BTN_CD, 'SEARCH')           AS MNU_BTN_CD,
                BMP.API_ID                              AS API_ID,
                API.API_URL                             AS PROC_NM,
                NVL(PROC.COL_NM, '')                    AS COL_NM,
                NVL(PROC.DATA_TP_CD, 'STRING')          AS DATA_TP_CD,
                NVL(PROC.COL_TP_CD, 'NORMAL')           AS COL_TP_CD,
                NVL(PROC.SORT_ORD, 0)                   AS SORT_ORD
          FROM  SCM_MGR.SCM_ADM_MENU_M                  M
          LEFT  OUTER JOIN
                SCM_MGR.SCM_ADM_MNU_BTN_MPG_M           BMP
            ON  BMP.MNU_ID = M.MNU_ID
          LEFT  OUTER JOIN
                SCM_MGR.SCM_ADM_API_M                   API
            ON  API.API_ID = BMP.API_ID
          LEFT  OUTER JOIN
                SCM_MGR.SCM_ADM_PROC_M                  PROC
            ON  PROC.PROC_NM = API.API_URL
         WHERE  M.USE_YN = 'Y'
      ORDER BY  M.MNU_ID, BMP.SHT_NM, BMP.MNU_BTN_CD, PROC.COL_TP_CD, PROC.SORT_ORD;
    END PR_GET_PROCEDURES_METADATA;


--==============================================================================================
    PROCEDURE PR_GET_PROCEDURE_METADATA_BY_MENU (
        P_MNU_ID        IN      VARCHAR2,
        O_CURSOR        OUT     SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN O_CURSOR FOR
        SELECT  M.MNU_ID                                AS MNU_ID,
                NVL(M.MNU_NM, M.MNU_DESC)               AS MNU_DESC,
                NVL(BMP.SHT_NM, '_DEFAULT_')            AS SHT_NM,
                NVL(BMP.MNU_BTN_CD, 'SEARCH')           AS MNU_BTN_CD,
                BMP.API_ID                              AS API_ID,
                API.API_URL                             AS PROC_NM,
                NVL(PROC.COL_NM, '')                    AS COL_NM,
                NVL(PROC.DATA_TP_CD, 'STRING')          AS DATA_TP_CD,
                NVL(PROC.COL_TP_CD, 'NORMAL')           AS COL_TP_CD,
                NVL(PROC.SORT_ORD, 0)                   AS SORT_ORD
          FROM  SCM_MGR.SCM_ADM_MENU_M                  M
          LEFT  OUTER JOIN
                SCM_MGR.SCM_ADM_MNU_BTN_MPG_M           BMP
            ON  BMP.MNU_ID = M.MNU_ID
          LEFT  OUTER JOIN
                SCM_MGR.SCM_ADM_API_M                   API
            ON  API.API_ID = BMP.API_ID
          LEFT  OUTER JOIN
                SCM_MGR.SCM_ADM_PROC_M                  PROC
            ON  PROC.PROC_NM = API.API_URL
         WHERE  M.MNU_ID = P_MNU_ID
           AND  M.USE_YN = 'Y'
      ORDER BY  BMP.SHT_NM, BMP.MNU_BTN_CD, PROC.COL_TP_CD, PROC.SORT_ORD;
    END PR_GET_PROCEDURE_METADATA_BY_MENU;

END PKG_NSCM_UI_COMM;
/


-- ====== PUBLIC SYNONYM + GRANT ======
CREATE OR REPLACE PUBLIC SYNONYM PKG_NSCM_UI_COMM FOR SCM_MGR.PKG_NSCM_UI_COMM;

GRANT EXECUTE ON SCM_MGR.PKG_NSCM_UI_COMM TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.PKG_NSCM_UI_COMM TO RL_SCM_SEL;


-- ====== 검증 SQL (수동 실행) ======
/*
DECLARE
    v_cur SYS_REFCURSOR;
    v_mnu_id VARCHAR2(20); v_mnu_desc VARCHAR2(100);
    v_sht VARCHAR2(40); v_btn VARCHAR2(20); v_api VARCHAR2(40);
    v_proc VARCHAR2(100); v_col VARCHAR2(60); v_dtp VARCHAR2(20);
    v_ctp VARCHAR2(20); v_sort NUMBER;
BEGIN
    SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROCEDURES_METADATA(v_cur);
    LOOP
        FETCH v_cur INTO v_mnu_id, v_mnu_desc, v_sht, v_btn, v_api, v_proc, v_col, v_dtp, v_ctp, v_sort;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_mnu_id||'|'||v_sht||'|'||v_btn||'|'||v_proc||'|'||v_col||'|'||v_dtp||'|'||v_ctp);
    END LOOP;
    CLOSE v_cur;
END;
/
*/
