PROCEDURE PR_SCP_MST_MODEL_BOM_EFF_ADD_ASSY
/*
 * Program ID  : [PR_SCP_MST_MODEL_BOM_EFF_ADD_ASSY]
 * Description : Cell Product Model 기준으로 Cell Assy Model정보를 생성한다.

	* source table : SCM_MST_MODEL_BOM_EFFECTIVE, SCP_MST_CELL_PROD_ASSY_MAP
	* target table : SCM_MST_MODEL_BOM_EFFECTIVE
 *
 * Program History
 *============================================================================================================================
 *   Date		In Charge	Description
 *============================================================================================================================
 * 2023/06/22	hrkim		Initial Release  [PJ20230691] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 * 2023/07/17	hrkim		PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응 (8월 해외 오픈 대응)
 * 2023/07/26	hrkim		PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : SCP_MST_CELL_PROD_ASSY_MAP 참조시 Valid_yn = 'Y' 조건 추가
 * 2025.09.08   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  :
 *                          제품 기준 NLevel 선정 로직 현실화
 *
 * 2026.07.06	ZIONEX		[PJ202650304] NextSCM Migration
 */
AS
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'PR_SCP_MST_MODEL_BOM_EFF_ADD_ASSY';
    V_LOG_TYPE      VARCHAR2(30 CHAR);
    N_LOG_COUNT     INTEGER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    D_EVENT_DATE    DATE;
    V_BATCH_USER    VARCHAR2(150 CHAR) := 'scm_batch';
    V_START_TIME    DATE := SYSDATE;
    V_EXEC_TIME     VARCHAR2(10 CHAR);
    V_SEC           NUMBER;
BEGIN
    BEGIN

        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '##### Start of procedure #####';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 1. #tgt 대상 추출 (Cell Product MODEL -> Cell Assy MODEL, 유효일자) */
        INSERT
          INTO GT_ADDAE_TGT
             ( BOM_PRIORITY
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , MODEL_ID
             , PARENT_ITEM_ID
             , CHILD_ITEM_ID
             , CHILD_QTY
             , CHILD_UOM
             , ACCUMULATED_CHILD_QTY
             , CONCATENATE_ITEM
             , SORT_ORDER
             , LEAF_LEVEL
             , NLEVEL
             , CHILD_COMPANY_ID
             , CHILD_DIVISION_ID
             , CHILD_SITE_ID
             , CHILD_PLANT_ID
             , ALT_ID
             , ALT_PRIORITY
             , ALT_RATE
             , EFF_START_DATE
             , EFF_END_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             , ATTRIBUTE11
             , ATTRIBUTE12
             , ATTRIBUTE13
             , ATTRIBUTE14
             , CONCAT_ALT_PRIORITY
             , COPY_ALT_PRIORITY
             , SCP_PLAN_YN
             , ENG_ALT_ID
             , ENG_ALT_PRIORITY
             , ORG_ALT_ID
             , ORG_ALT_PRIORITY
             , CHILD_SEQ )
        SELECT ROW_NUMBER() OVER (PARTITION BY B.COMPANY_ID
                                             , B.DIVISION_ID
                                             , B.SITE_ID
                                             , B.PLANT_ID
                                             , M.ITEM_ID_ASSY
                                             , SUBSTR(B.CONCATENATE_ITEM, INSTR(B.CONCATENATE_ITEM, M.ITEM_ID_ASSY), LENGTH(B.CONCATENATE_ITEM))
                                             , B.EFF_START_DATE
                                  ORDER BY F.TCO_CELL_YN, M.ITEM_ID_PROD) AS BOM_PRIORITY
             , B.COMPANY_ID
             , B.DIVISION_ID
             , B.SITE_ID
             , B.PLANT_ID
             , M.ITEM_ID_ASSY AS MODEL_ID
             , CASE WHEN M.ITEM_ID_ASSY = B.CHILD_ITEM_ID THEN '*' ELSE B.PARENT_ITEM_ID END AS PARENT_ITEM_ID
             , B.CHILD_ITEM_ID
             , B.CHILD_QTY
             , B.CHILD_UOM
             , B.ACCUMULATED_CHILD_QTY
             , SUBSTR(B.CONCATENATE_ITEM, INSTR(B.CONCATENATE_ITEM, M.ITEM_ID_ASSY), LENGTH(B.CONCATENATE_ITEM)) AS CONCATENATE_ITEM
             , B.SORT_ORDER
             , B.LEAF_LEVEL
             , CASE WHEN INSTR(B.CONCATENATE_ITEM, M.ITEM_ID_ASSY) > 1
                    THEN B.NLEVEL - LENGTH(SUBSTR(B.CONCATENATE_ITEM, 1, INSTR(B.CONCATENATE_ITEM, M.ITEM_ID_ASSY)))
                              + LENGTH(REPLACE(SUBSTR(B.CONCATENATE_ITEM, 1, INSTR(B.CONCATENATE_ITEM, M.ITEM_ID_ASSY)), '^', ''))
                    ELSE B.NLEVEL
               END AS NLEVEL
             , B.CHILD_COMPANY_ID
             , B.CHILD_DIVISION_ID
             , B.CHILD_SITE_ID
             , B.CHILD_PLANT_ID
             , B.ALT_ID
             , B.ALT_PRIORITY
             , B.ALT_RATE
             , B.EFF_START_DATE
             , B.EFF_END_DATE
             , B.ATTRIBUTE1
             , B.ATTRIBUTE2
             , B.ATTRIBUTE3
             , B.ATTRIBUTE4
             , B.ATTRIBUTE5
             , B.ATTRIBUTE6
             , B.ATTRIBUTE7
             , B.ATTRIBUTE8
             , B.ATTRIBUTE9
             , B.ATTRIBUTE10
             , B.ATTRIBUTE11
             , B.ATTRIBUTE12
             , B.ATTRIBUTE13
             , B.ATTRIBUTE14
             , B.CONCAT_ALT_PRIORITY
             , B.COPY_ALT_PRIORITY
             , B.SCP_PLAN_YN
             , B.ENG_ALT_ID
             , B.ENG_ALT_PRIORITY
             , B.ORG_ALT_ID
             , B.ORG_ALT_PRIORITY
             , B.CHILD_SEQ
          FROM SCM_MST_MODEL_BOM_EFFECTIVE  B
             , SCP_MST_CELL_PROD_ASSY_MAP   M
             , SCP_MST_FINAL_ITEM           F
         WHERE M.DIVISION_ID    = B.DIVISION_ID
           AND M.PLANT_ID       = B.PLANT_ID
           AND M.ITEM_ID_PROD   = B.MODEL_ID
           AND M.VALID_YN       = 'Y'
           AND F.DIVISION_ID(+) = M.DIVISION_ID
           AND F.ITEM_ID(+)     = M.ITEM_ID_PROD
           AND 1 = 1
           AND B.CONCATENATE_ITEM LIKE '%' || M.ITEM_ID_ASSY || '%';

        /* 2.2 DELETE : 기 생성된 Assy Model 삭제 */
        DELETE FROM SCM_MST_MODEL_BOM_EFFECTIVE B
         WHERE 1 = 1
           AND EXISTS ( SELECT 1
                          FROM SCP_MST_CELL_PROD_ASSY_MAP M
                         WHERE M.DIVISION_ID  = B.DIVISION_ID
                           AND M.PLANT_ID     = B.PLANT_ID
                           AND M.ITEM_ID_ASSY = B.MODEL_ID );

        /* 2.2 INSERT : Assy Model 정보 등록 (BOM_PRIORITY=1, ATTRIBUTE15='CELL_ASSY') */
        INSERT
          INTO SCM_MST_MODEL_BOM_EFFECTIVE
             ( COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , MODEL_ID
             , PARENT_ITEM_ID
             , CHILD_ITEM_ID
             , CHILD_QTY
             , CHILD_UOM
             , ACCUMULATED_CHILD_QTY
             , CONCATENATE_ITEM
             , SORT_ORDER
             , LEAF_LEVEL
             , NLEVEL
             , CHILD_COMPANY_ID
             , CHILD_DIVISION_ID
             , CHILD_SITE_ID
             , CHILD_PLANT_ID
             , ALT_ID
             , ALT_PRIORITY
             , ALT_RATE
             , EFF_START_DATE
             , EFF_END_DATE
             , INSERT_ID
             , INSERT_TIME
             , UPDATE_ID
             , UPDATE_TIME
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             , ATTRIBUTE11
             , ATTRIBUTE12
             , ATTRIBUTE13
             , ATTRIBUTE14
             , ATTRIBUTE15
             , CONCAT_ALT_PRIORITY
             , COPY_ALT_PRIORITY
             , SCP_PLAN_YN
             , ENG_ALT_ID
             , ENG_ALT_PRIORITY
             , ORG_ALT_ID
             , ORG_ALT_PRIORITY
             , CHILD_SEQ )
        SELECT B.COMPANY_ID
             , B.DIVISION_ID
             , B.SITE_ID
             , B.PLANT_ID
             , B.MODEL_ID
             , B.PARENT_ITEM_ID
             , B.CHILD_ITEM_ID
             , B.CHILD_QTY
             , B.CHILD_UOM
             , B.ACCUMULATED_CHILD_QTY
             , B.CONCATENATE_ITEM
             , B.SORT_ORDER
             , B.LEAF_LEVEL
             , B.NLEVEL
             , B.CHILD_COMPANY_ID
             , B.CHILD_DIVISION_ID
             , B.CHILD_SITE_ID
             , B.CHILD_PLANT_ID
             , B.ALT_ID
             , B.ALT_PRIORITY
             , B.ALT_RATE
             , B.EFF_START_DATE
             , B.EFF_END_DATE
             , V_PROGRAM_NAME
             , SYSDATE
             , V_PROGRAM_NAME
             , SYSDATE
             , B.ATTRIBUTE1
             , B.ATTRIBUTE2
             , B.ATTRIBUTE3
             , B.ATTRIBUTE4
             , B.ATTRIBUTE5
             , B.ATTRIBUTE6
             , B.ATTRIBUTE7
             , B.ATTRIBUTE8
             , B.ATTRIBUTE9
             , B.ATTRIBUTE10
             , B.ATTRIBUTE11
             , B.ATTRIBUTE12
             , B.ATTRIBUTE13
             , B.ATTRIBUTE14
             , 'CELL_ASSY'
             , B.CONCAT_ALT_PRIORITY
             , B.COPY_ALT_PRIORITY
             , B.SCP_PLAN_YN
             , B.ENG_ALT_ID
             , B.ENG_ALT_PRIORITY
             , B.ORG_ALT_ID
             , B.ORG_ALT_PRIORITY
             , B.CHILD_SEQ
          FROM GT_ADDAE_TGT B
         WHERE 1 = 1
           AND B.BOM_PRIORITY = 1;
        N_LOG_COUNT := SQL%ROWCOUNT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := 'ERROR_LINE : ' || SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 480);
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);
            RAISE;
    END;

    V_SEC := ROUND((SYSDATE - V_START_TIME) * 86400);
    V_EXEC_TIME := LPAD(TO_CHAR(FLOOR(V_SEC / 60)), 2, '0') || ':' || LPAD(TO_CHAR(MOD(V_SEC, 60)), 2, '0');
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '##### END of procedure #####';
    V_DESCRIPTION := '[' || V_EXEC_TIME || ']';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);
END;