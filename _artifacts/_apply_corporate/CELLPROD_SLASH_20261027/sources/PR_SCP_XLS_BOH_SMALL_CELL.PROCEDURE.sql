PROCEDURE PR_SCP_XLS_BOH_SMALL_CELL
( P_PLAN_CYCLE            IN VARCHAR2                       /* NVARCHAR(0150) */
, P_PLAN_START_YYYYMMDD   IN VARCHAR2                       /* NVARCHAR(0008) */
, P_PLAN_ID               IN VARCHAR2                       /* NVARCHAR(4000) */
, P_MODELING_ID           IN VARCHAR2                       /* NVARCHAR(4000) */
, P_SEQ                   IN VARCHAR2                       /* NVARCHAR(4000) */
, P_PLAN_TYPE             IN VARCHAR2                       /* NVARCHAR(4000) */
, P_MASTER_ID             IN VARCHAR2                       /* NVARCHAR(4000) */
, P_DIVISION_ID           IN VARCHAR2                       /* NVARCHAR(0030) */
, P_ENGINE_PLAN_ID        IN VARCHAR2                       /* NVARCHAR(4000) */
, P_USER_ID               IN VARCHAR2 DEFAULT 'SCP_batch'   /* NVARCHAR(0150) = 'SCP_batch' */
  /* ---- , @p_debug       INT OUTPUT */
, O_RETURN                OUT NUMBER                        /* AS-IS RETURN 값 → OUT 인자(CNS 가이드) */
)
/*
 * Program ID   : PR_SCP_XLS_BOH_SMALL_CELL
 * Description  : PR_SCP_PLN_CREATE_DATA 에서 호출함.
 * OutTable     :
 * Execute      :
    -- DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='kth'
    EXEC PR_SCP_XLS_BOH_SMALL_CELL
                                 @p_plan_cycle          = 'WEEKLY'
                               , @p_plan_start_yyyymmdd = '20190107'
                               , @p_plan_id             = '1060'
                               , @p_modeling_id         = '2'
                               , @p_seq                 = '1'
                               , @p_plan_type           = 'PR'
                               , @p_master_id           = '81::WEEKLY'
                               , @p_division_id         = '81'
                               , @p_engine_plan_id      = '1060::PR::1'
                               , @p_user_id             = 'KTH'
    SELECT * FROM SCM_SYS_LOG_BATCH  where CREATED_BY ='kth' order by CREATION_DATE desc

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.03.12   KTH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.10.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
/* --DROP PROC PR_SCP_XLS_BOH_CELL */
AS
    /* AS-IS 인자 선언 길이 재현 : NVARCHAR(0150) · NVARCHAR(0008) · NVARCHAR(0030) */
    V_PLAN_CYCLE              VARCHAR2(150 CHAR) := SUBSTR(P_PLAN_CYCLE, 1, 150);
    V_PLAN_START_YYYYMMDD     VARCHAR2(8 CHAR)   := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8);
    V_DIVISION_ID             VARCHAR2(30 CHAR)  := SUBSTR(P_DIVISION_ID, 1, 30);
    V_USER_ID                 VARCHAR2(150 CHAR) := SUBSTR(P_USER_ID, 1, 150);

    /* SET TRANSACTION ISOLATION LEVEL READ COMMITTED; SET NOCOUNT ON; SET XACT_ABORT ON; SET ANSI_WARNINGS OFF; (Oracle 무대응) */

    /* LOG 용 변수 설정 */
    V_BATCH_USER              VARCHAR2(150 CHAR) := 'SCP_batch';
    V_PROGRAM_NAME            VARCHAR2(150 CHAR) := 'PR_SCP_XLS_BOH_SMALL_CELL';
    V_LOG_TYPE                VARCHAR2(30 CHAR);  /* START/END/ERROR/... */
    N_LOG_COUNT               PLS_INTEGER := 0;
    V_LOG_MESSAGE             VARCHAR2(1000 CHAR);
    V_DESCRIPTION             VARCHAR2(500 CHAR);
    V_TABLE_ID                VARCHAR2(150 CHAR) := 'SCM_SYS_LOG_BATC';
    D_EVENT_DATE              DATE;

    /* 실행시간 확인용 */
    D_START_TIME              DATE;
    V_EXEC_TIME               VARCHAR2(10 CHAR) := '';  /* --'00:00'; */
    N_EXEC_SEC                NUMBER;

    /* --DECLARE @debug_mode            NVARCHAR(30) = 'T' */
BEGIN
    O_RETURN     := 0;  /* 반환값 초기화 */
    V_BATCH_USER := V_USER_ID;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME || ':' || 'INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );

    /* 실행시간 확인용 */
    D_START_TIME := SYSDATE;

    BEGIN  /* BEGIN TRY */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 1. BOH */
        /* ------------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM SCP_XLS_BOH_SMALL_CELL
         WHERE DIVISION_ID = V_DIVISION_ID;  /* -- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq */

        /* [전환] AS-IS SET ANSI_WARNINGS OFF : 대상 칸보다 긴 문자는 잘라서 적재(LOT_ID 칸 1자 · SITE_ID 칸 30자 등) → SUBSTR 로 재현 */
        INSERT
          INTO SCP_XLS_BOH_SMALL_CELL
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , ITEM_ID
             , SITE_ID
             , SCM_SITE_ID
             , LOC
             , OSP_YN
             , RECEIVING_DTTM
             , QTY
             , LOT_ID
             , DESCR
             , TCO_CELL_YN
             , CELL_ITEM_ID
             , TCO_EXIST_YN
             , CELL_TO_TCO_BOD_LT
             , TCO_TO_CELL_BOD_LT
             , CELL_TO_TCO_TOTAL_BOD_LT
             , FORMATION_TOTAL_YIELD
             , TOTAL_LT_FORMATION
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
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
             )
        SELECT V_DIVISION_ID                       AS DIVISION_ID
             , V_PLAN_START_YYYYMMDD               AS PLAN_START_YYYYMMDD
             , SUBSTR(P_PLAN_TYPE, 1, 50)          AS PLAN_TYPE
             , TO_NUMBER(P_SEQ)                    AS SEQ
             , SUBSTR(IA.ITEM_ID, 1, 50)           AS ITEM_ID
             , SUBSTR(IA.SITE_ID, 1, 30)           AS SITE_ID
             , SUBSTR(IA.SCM_SITE_ID, 1, 30)       AS SCM_SITE_ID
             , SUBSTR(IA.LOC, 1, 10)               AS LOC
             , SUBSTR(IA.OSP_YN, 1, 1)             AS OSP_YN
             , IA.RECEIVING_DTTM
             , IA.QTY
             , SUBSTR(IA.LOT_ID, 1, 1)             AS LOT_ID
             , SUBSTR(IA.DESCR, 1, 2000)           AS DESCR
             , SUBSTR(IA.TCO_CELL_YN, 1, 1)        AS TCO_CELL_YN
             , SUBSTR((CASE WHEN IA.CELL_ITEM_ID = IA.ITEM_ID_ASSY THEN IA.ITEM_ID_PROD ELSE IA.CELL_ITEM_ID END), 1, 150) AS CELL_ITEM_ID  /* --ADD DHJ...07/02/2023 */
             , IA.TCO_EXIST_YN
             , IA.CELL_TO_TCO_BOD_LT
             , IA.TCO_TO_CELL_BOD_LT
             , IA.CELL_TO_TCO_TOTAL_BOD_LT
             , IA.FORMATION_TOTAL_YIELD
             , IA.TOTAL_LT_FORMATION
             , V_BATCH_USER                        AS CREATED_BY
             , SYSDATE                             AS CREATION_DATE
             , V_BATCH_USER                        AS LAST_UPDATED_BY
             , SYSDATE                             AS LAST_UPDATE_DATE
             , NULL                                AS ATTRIBUTE1
             , NULL                                AS ATTRIBUTE2
             , NULL                                AS ATTRIBUTE3
             , NULL                                AS ATTRIBUTE4
             , NULL                                AS ATTRIBUTE5
             , NULL                                AS ATTRIBUTE6
             , NULL                                AS ATTRIBUTE7
             , NULL                                AS ATTRIBUTE8
             , NULL                                AS ATTRIBUTE9
             , NULL                                AS ATTRIBUTE10
          FROM (SELECT A.ITEM_ID
                     , A.SITE_ID
                     , FN_SCM_SPLIT(A.SITE_ID, 1, '~')    AS SCM_SITE_ID
                     , FN_SCM_SPLIT(A.SITE_ID, 2, '~')    AS LOC
                     , (SELECT NVL(SA.OSP_YN, 'N')
                          FROM SCM_MST_SITE SA
                         WHERE SA.DIVISION_ID = V_DIVISION_ID
                           AND SA.SCM_SITE_ID = FN_SCM_SPLIT(A.SITE_ID, 1, '~')
                       )                                  AS OSP_YN
                     , A.RECEIVING_DTTM
                     , A.QTY
                     , A.LOT_ID
                     , A.DESCR
                     , B.TCO_CELL_YN
                     , (CASE WHEN B.TCO_CELL_YN = 'Y' THEN B.ATTRIBUTE1 ELSE A.ITEM_ID END) AS CELL_ITEM_ID
                     , C.ITEM_ID_ASSY
                     , C.ITEM_ID_PROD  /* ---------------ADD DHJ...07/02/2023 */
                     , (SELECT (CASE WHEN MAX(SB.TCO_CELL_ITEM_ID) IS NULL THEN 'N' ELSE 'Y' END)
                          FROM SCP_MST_CELL_TCO_RELATION_V SB
                         WHERE 1 = 1
                           AND SB.CELL_ITEM_ID = (CASE WHEN B.TCO_CELL_YN = 'Y' THEN B.ATTRIBUTE1 ELSE A.ITEM_ID END)
                       )                                  AS TCO_EXIST_YN
                     , (SELECT MAX(SC.CELL_TO_TCO_BOD_LT)
                          FROM SCP_MST_CELL_TCO_RELATION_V SC
                         WHERE 1 = 1
                           AND SC.CELL_ITEM_ID = (CASE WHEN B.TCO_CELL_YN = 'Y' THEN B.ATTRIBUTE1 ELSE A.ITEM_ID END)
                       )                                  AS CELL_TO_TCO_BOD_LT
                     , (SELECT MAX(SD.TCO_TO_CELL_BOD_LT)
                          FROM SCP_MST_CELL_TCO_RELATION_V SD
                         WHERE 1 = 1
                           AND SD.CELL_ITEM_ID = (CASE WHEN B.TCO_CELL_YN = 'Y' THEN B.ATTRIBUTE1 ELSE A.ITEM_ID END)
                       )                                  AS TCO_TO_CELL_BOD_LT
                     , (SELECT MAX(SE.CELL_TO_TCO_TOTAL_BOD_LT)
                          FROM SCP_MST_CELL_TCO_RELATION_V SE
                         WHERE 1 = 1
                           AND SE.CELL_ITEM_ID = (CASE WHEN B.TCO_CELL_YN = 'Y' THEN B.ATTRIBUTE1 ELSE A.ITEM_ID END)
                       )                                  AS CELL_TO_TCO_TOTAL_BOD_LT
                     , (SELECT NVL(MAX(SF.FORMATION_TOTAL_YIELD), 1)
                          FROM SCP_MST_FORMATION_V SF
                         WHERE SF.DIVISION_ID = V_DIVISION_ID
                           AND SF.ITEM_ID     = (CASE WHEN B.TCO_CELL_YN = 'Y' THEN B.ATTRIBUTE1 ELSE A.ITEM_ID END)
                       )                                  AS FORMATION_TOTAL_YIELD
                     , (SELECT NVL(MAX(SG.TOTAL_LT_FORMATION), 0)
                          FROM SCP_MST_FORMATION_V SG
                         WHERE SG.DIVISION_ID = V_DIVISION_ID
                           AND SG.ITEM_ID     = (CASE WHEN B.TCO_CELL_YN = 'Y' THEN B.ATTRIBUTE1 ELSE A.ITEM_ID END)
                       )                                  AS TOTAL_LT_FORMATION
                  FROM SCP_PLN_TH_ENG_STOCK_PLAN  A
                     , SCP_MST_FINAL_ITEM         B
                     , SCP_MST_CELL_PROD_ASSY_MAP C  /* --------ADD DHJ...07/02/2023 */
                 WHERE A.ITEM_ID                   = B.ITEM_ID
                   AND FN_SCM_SPLIT(A.SITE_ID, 1, '~') = C.PLANT_ID(+) || '-A'
                   AND (CASE WHEN B.TCO_CELL_YN = 'Y' THEN B.ATTRIBUTE1 ELSE A.ITEM_ID END) = C.ITEM_ID_ASSY(+)
                   AND 0 = 0
                   AND B.OPERATION_GROUP           = 'A'
                   AND 1 = 1
                   AND B.DIVISION_ID               = V_DIVISION_ID
                   AND A.MASTER_ID                 = P_MASTER_ID
                   /* --AND PLAN_ID    =   '1060' */
                   AND A.PLAN_ID                   = P_ENGINE_PLAN_ID
                   AND A.SITE_ID                LIKE '%-A~%'
               ) IA;

        /* ----------------------------------------------------------- */
        /* 실행 Logic END -- */
        /* ----------------------------------------------------------- */
        /* --IF @@TRANCOUNT > 0 */
        /* --  BEGIN */
        /* --    COMMIT TRAN T1; */
        /* --  END; */

        /* TXN LOG */
        V_LOG_TYPE    := 'TXN';
        N_LOG_COUNT   := 1;  /* AS-IS : 바로 앞 SET 문이 @@ROWCOUNT 를 1 로 바꾼 뒤 읽음 */
        V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

    EXCEPTION  /* BEGIN CATCH */
        WHEN OTHERS THEN
            /* --IF @@TRANCOUNT > 0 */
            /* --  BEGIN */
            /* --    ROLLBACK TRAN T1 */
            /* --  END; */

            /* ERROR LOG */
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR(V_PROGRAM_NAME || 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => V_LOG_TYPE
                                , P_LOG_COUNT    => N_LOG_COUNT
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );
            /* --      PRINT @@ERROR */
            O_RETURN := -1;
            RETURN;  /* return -1 */
    END;  /* END CATCH; */

    /* -- 임시 운영반영시에 주석처리 할것. */
    N_EXEC_SEC  := ROUND((SYSDATE - D_START_TIME) * 86400);
    V_EXEC_TIME := LPAD(TO_CHAR(TRUNC(N_EXEC_SEC / 60)), 2, '0') || ':' || LPAD(TO_CHAR(MOD(N_EXEC_SEC, 60)), 2, '0');

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '[' || P_MASTER_ID || '][' || P_ENGINE_PLAN_ID || '][' || V_EXEC_TIME || ']';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );
    O_RETURN := 1;
    RETURN;  /* return 1 */
END;