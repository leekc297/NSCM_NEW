PROCEDURE PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL
(
    P_PLAN_ID              IN VARCHAR2
   ,P_PLAN_START_YYYYMMDD  IN VARCHAR2
)
IS
/******************************************************************************
 * Program ID   : PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL
 * Description  : 엔진 결과(생산·SEMI 출하·FG 출하·CHAR) → SCP_ANL_* · SCP_XLS_PSI_GLOBAL_SMALL · SCP_XLS_PSI_GLOBAL_SMALL_PACK 반영(소형)
 * Program History
 *   --2025.02.07 Taehyun Initial Release
 * 2026.10.06   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 ******************************************************************************/
	------------------------------------------------------------------------
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	/* SET XACT_ABORT ON · SET NOCOUNT ON · SET TRANSACTION ISOLATION LEVEL READ COMMITTED 삭제(Oracle 해당 없음) */
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- Set Param for Log
	------------------------------------------------------------------------
    V_PROGRAM_NAME              VARCHAR2(150 CHAR) := 'PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL';
    V_PLAN_ID                   VARCHAR2(50 CHAR)  := SUBSTR(P_PLAN_ID, 1, 50);
    V_MESSAGE_TEXT              VARCHAR2(1000 CHAR);
    ------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    --DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_LGTM_INV_ALLOCATION';
    V_LOG_TYPE                  VARCHAR2(30 CHAR); -- START/END/ERROR/...
    V_LOG_COUNT                 NUMBER := 0;
    V_LOG_MESSAGE               VARCHAR2(1000 CHAR);
    V_DESCRIPTION               VARCHAR2(500 CHAR);
    V_EVENT_DATE                DATE;
    ---------------------   ---------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    V_SCP_PLAN_DATE             VARCHAR2(8 CHAR);
    V_SCP_PLAN_TYPE             VARCHAR2(8 CHAR);
    V_SCP_PLAN_SEQ              VARCHAR2(8 CHAR);
    V_DIVISION_ID               VARCHAR2(10 CHAR);
    V_PLAN_START_YYYYMMDD       VARCHAR2(8 CHAR);
    V_PLAN_END_YYYYMMDD         VARCHAR2(8 CHAR);
    V_2ND_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR);
    V_NOW_DATE                  DATE;
    V_MIN_WEEK                  NUMBER;
    V_2ND_MIN_WEEK              NUMBER;
    -- 2026.07.22 Minyong Lee : [E20260713-000080] [ODS] 업로드 수량 이상건 수정
    V_WEEKS_IN_YEAR             NUMBER;
    V_2ND_WEEKS_IN_YEAR         NUMBER;
    V_UPDATE_NAME               VARCHAR2(100 CHAR);
    V_OP_COUNT                  NUMBER;
    V_CHK_INTEGRAL              VARCHAR2(100 CHAR);
    --속도이슈
    /* 테이블 변수 @MS_TEMP · @CFY_TEMP · @OP_RESULT · @OS_RESULT · @OS_RESULT_FG · @OS_RESULT_FG_SMMR · @XLS_PV_READY · @XLS_PV_TABLE
       → GTT GT_TASM_MS_TEMP · GT_TASM_CFY_TEMP · GT_TASM_OP_RESULT · GT_TASM_OS_RESULT · GT_TASM_OS_RESULT_FG · GT_TASM_OS_RESULT_FG_SMMR · GT_TASM_XLS_PV_READY · GT_TASM_XLS_PV_TABLE
       (DDL 은 (DDL) 00_GTT_TASM_SCP0123.sql) */
BEGIN
    /* GTT 초기화 (TRUNCATE 금지 : 암묵적 커밋) */
    DELETE FROM GT_TASM_MS_TEMP;
    DELETE FROM GT_TASM_CFY_TEMP;
    DELETE FROM GT_TASM_OP_RESULT;
    DELETE FROM GT_TASM_OS_RESULT;
    DELETE FROM GT_TASM_OS_RESULT_FG;
    DELETE FROM GT_TASM_OS_RESULT_FG_SMMR;
    DELETE FROM GT_TASM_XLS_PV_READY;
    DELETE FROM GT_TASM_XLS_PV_TABLE;

	------------------------------------------------------------------------
	-- LOG 시작
	------------------------------------------------------------------------
	V_LOG_TYPE      := 'START';
	V_LOG_MESSAGE   := '########## Start of procedure ##########';
	V_DESCRIPTION   := 'START_' || V_PROGRAM_NAME || '@' || P_PLAN_START_YYYYMMDD || '@' || V_PLAN_ID;
	V_EVENT_DATE    := SYSDATE;
	PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);
	------------------------------------------------------------------------

    /* 스칼라 서브쿼리 대입 : 0 행이면 NULL */
    BEGIN
        SELECT TO_NUMBER(ISO_WEEK) - 1
          INTO V_MIN_WEEK
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD = P_PLAN_START_YYYYMMDD;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_MIN_WEEK := NULL;
    END;
    V_UPDATE_NAME := CASE WHEN V_PLAN_ID IS NULL THEN NULL ELSE 'OPT_ENG_' || V_PLAN_ID END;   /* AS-IS 문자 + 는 NULL 이 섞이면 NULL */
    --52주 이후 구간의 데이터를 GLOBAL 테이블에 넣기 위한 변수 설정
    V_2ND_PLAN_START_YYYYMMDD := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 364, 'YYYYMMDD');
    BEGIN
        SELECT TO_NUMBER(ISO_WEEK) - 1
          INTO V_2ND_MIN_WEEK
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD = V_2ND_PLAN_START_YYYYMMDD;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_2ND_MIN_WEEK := NULL;
    END;

    -- 2026.07.22 Minyong Lee : [E20260713-000080] [ODS] 업로드 수량 이상건 수정
    -- 섹션1 시작연도의 실제 주차 수 (52 or 53)
    SELECT MAX(TO_NUMBER(ISO_WEEK))
      INTO V_WEEKS_IN_YEAR
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMMDD LIKE SUBSTR(P_PLAN_START_YYYYMMDD, 1, 4) || '%';   /* AS-IS LEFT(BASIS_YYYYMMDD,4) = LEFT(@PLAN_START_YYYYMMDD,4) */
    -- 섹션2(52주 이후 구간) 시작연도의 실제 주차 수 (52 or 53)
    SELECT MAX(TO_NUMBER(ISO_WEEK))
      INTO V_2ND_WEEKS_IN_YEAR
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMMDD LIKE SUBSTR(V_2ND_PLAN_START_YYYYMMDD, 1, 4) || '%';   /* AS-IS LEFT(BASIS_YYYYMMDD,4) = LEFT(@2ND_PLAN_START_YYYYMMDD,4) */

    V_NOW_DATE := SYSDATE;
    --SELECT  @V_DIVISION_ID = DIVISION_ID
    --       ,@V_PLAN_START_YYYYMMDD = PLAN_START_YYYYMMDD
    --       ,@V_PLAN_END_YYYYMMDD   = PLAN_END_YYYYMMDD
    --FROM    SCP_OPT_ENG_SCP_PLAN_ID_M_SN WITH(NOLOCK)
    --WHERE   1=1
    --AND     PLAN_ID = @V_PLAN_ID

    --SELECT   @V_DIVISION_ID         = PM.DIVISION_ID
    --        ,@V_PLAN_START_YYYYMMDD = PM.PLAN_START_YYYYMMDD
    --        ,@V_PLAN_END_YYYYMMDD   = PM.PLAN_END_YYYYMMDD
    --FROM    SCP_OPMZ_PLAN_M PM WITH(NOLOCK)
    --WHERE   PM.OPMZ_PLAN_ID = @V_PLAN_ID

    /* SELECT @변수 = ... : 0 행이면 변수 유지(NULL). 두 원천 값이 달라 2 행이면 AS-IS 는 UNION 정렬 결과의 마지막 행 → DESC NULLS LAST 첫 행으로 고정 */
    BEGIN
        SELECT SUBSTR(IA.DIVISION_ID, 1, 10)
              ,SUBSTR(IA.PLAN_START_YYYYMMDD, 1, 8)
              ,SUBSTR(IA.PLAN_END_YYYYMMDD, 1, 8)
          INTO V_DIVISION_ID
              ,V_PLAN_START_YYYYMMDD
              ,V_PLAN_END_YYYYMMDD
          FROM (SELECT XA.DIVISION_ID
                      ,XA.PLAN_START_YYYYMMDD
                      ,XA.PLAN_END_YYYYMMDD
                  FROM (SELECT DIVISION_ID
                              ,PLAN_START_YYYYMMDD
                              ,PLAN_END_YYYYMMDD
                          FROM SCP_OPMZ_PLAN_M
                         WHERE OPMZ_PLAN_ID = V_PLAN_ID
                        UNION
                        SELECT DIVISION_ID
                              ,PLAN_START_YYYYMMDD
                              ,PLAN_END_YYYYMMDD
                          FROM SCP_OPT_ENG_SCP_PLAN_ID_M_SN
                         WHERE PLAN_ID = V_PLAN_ID
                       ) XA
                 ORDER BY XA.DIVISION_ID DESC NULLS LAST
                         ,XA.PLAN_START_YYYYMMDD DESC NULLS LAST
                         ,XA.PLAN_END_YYYYMMDD DESC NULLS LAST
               ) IA
         WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    BEGIN
        SELECT SUBSTR(IA.PLAN_START_YYYYMMDD, 1, 8)
              ,SUBSTR(IA.PLAN_TYPE, 1, 8)
              ,SUBSTR(TO_CHAR(IA.PLAN_SEQ), 1, 8)
          INTO V_SCP_PLAN_DATE
              ,V_SCP_PLAN_TYPE
              ,V_SCP_PLAN_SEQ
          FROM (SELECT DIVISION_ID
                      ,PLAN_START_YYYYMMDD
                      ,PLAN_TYPE
                      ,PLAN_SEQ
                      ,PLAN_TYPE_ORDER
                      ,CONFIRM_FLAG
                  FROM SCP_PLAN_VERSION_V
                 WHERE DIVISION_ID         = V_DIVISION_ID
                   AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                 -- 2026.03.17 Minyong Lee : FN 이후 TE Plan Type 추가 건 대응
                 --ORDER BY PLAN_TYPE_ORDER DESC, CONFIRM_FLAG DESC, PLAN_SEQ DESC
                 ORDER BY CASE WHEN PLAN_TYPE = 'TE' THEN 0 ELSE 1 END ASC
                         ,PLAN_TYPE_ORDER DESC NULLS LAST
                         ,CONFIRM_FLAG DESC NULLS LAST
                         ,PLAN_SEQ DESC
               ) IA
         WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    /* 여러 행이어도 값은 모두 V_PLAN_ID 와 같은 PLAN_ID → MAX 로 1 행(0 행이면 NULL = AS-IS 초기값 유지와 같음) */
    SELECT MAX(PLAN_ID)
      INTO V_CHK_INTEGRAL
      FROM SCP_OPT_ENG_PHASES_SN
     WHERE UPPER(PRINT_RESULT) LIKE '%INTEGRAL%'   /* AS-IS 대소문자 무시 비교 */
       AND PLAN_ID = V_PLAN_ID;

    IF (V_SCP_PLAN_TYPE = 'FN') THEN
            ------------------------------------------------------------------------
            -- 종료 LOG
	        ------------------------------------------------------------------------
            V_LOG_TYPE      := 'END';
            V_LOG_MESSAGE   := '########## END of procedure ##########';
            V_DESCRIPTION   := 'SCP_PLAN_TYPE IS FN' || '@' || P_PLAN_START_YYYYMMDD || '@' || V_PLAN_ID;
            V_EVENT_DATE    := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

            /* SET XACT_ABORT OFF 삭제. AS-IS 는 호출자 TRY 안이라 여기서 중단 → 즉시 종료 */
            RAISE_APPLICATION_ERROR(-20001, ' I/F not executed because PLAN_TYPE is FN.');
    END IF;
    ------------------------------------------------------------------------
	-- Transaction (START)
	------------------------------------------------------------------------
	BEGIN
        /* BEGIN TRAN 삭제(Oracle 은 첫 DML 에서 트랜잭션 시작) */

        ------------------------------------------------------------------------
        -- 엔진 결과에서 문자열 'E'를 붙여서 나오는 데이터 치환
        ------------------------------------------------------------------------
        /* STR(x,50) = 소수 0자리 반올림 정수 문자열. LIKE 는 AS-IS 대소문자 무시와 같게 UPPER */
        UPDATE SCP_OPT_ENG_OUT_ORDER_PRODUCTION_SN
           SET ATTRIBUTE1 = OUT_QTY
              ,OUT_QTY    = TO_CHAR(ROUND(CASE WHEN UPPER(OUT_QTY) LIKE '%E-%' THEN 0 ELSE TO_NUMBER(OUT_QTY) END))
         WHERE UPPER(OUT_QTY) LIKE '%E%'
           AND PLAN_ID = V_PLAN_ID;
        UPDATE SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT_SN
           SET ATTRIBUTE1  = OUT_QTY_INT
              ,OUT_QTY_INT = TO_CHAR(ROUND(CASE WHEN UPPER(OUT_QTY_INT) LIKE '%E-%' THEN 0 ELSE TO_NUMBER(OUT_QTY_INT) END))
         WHERE UPPER(OUT_QTY_INT) LIKE '%E%'
           AND PLAN_ID = V_PLAN_ID;
        UPDATE SCP_OPT_ENG_OUT_ORDER_DEMAND_DELIVERY_SN
           SET ATTRIBUTE1   = DELIVERY_QTY
              ,DELIVERY_QTY = TO_CHAR(ROUND(CASE WHEN UPPER(DELIVERY_QTY) LIKE '%E-%' THEN 0 ELSE TO_NUMBER(DELIVERY_QTY) END))
         WHERE UPPER(DELIVERY_QTY) LIKE '%E%'
           AND PLAN_ID = V_PLAN_ID;
        UPDATE SCP_OPT_ENG_OUT_ORDER_DEMAND_DELIVERY_INT_SN
           SET ATTRIBUTE1       = DELIVERY_QTY_INT
              ,DELIVERY_QTY_INT = TO_CHAR(ROUND(CASE WHEN UPPER(DELIVERY_QTY_INT) LIKE '%E-%' THEN 0 ELSE TO_NUMBER(DELIVERY_QTY_INT) END))
         WHERE UPPER(DELIVERY_QTY_INT) LIKE '%E%'
           AND PLAN_ID = V_PLAN_ID;
        UPDATE SCP_OPT_ENG_OUT_ORDER_SHIPPING_INT_SN
           SET ATTRIBUTE1 = QTY_INT
              ,QTY_INT    = TO_CHAR(ROUND(CASE WHEN UPPER(QTY_INT) LIKE '%E-%' THEN 0 ELSE TO_NUMBER(QTY_INT) END))
         WHERE UPPER(QTY_INT) LIKE '%E%'
           AND PLAN_ID = V_PLAN_ID;
        UPDATE SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN
           SET ATTRIBUTE1 = QTY
              ,QTY        = TO_CHAR(ROUND(CASE WHEN UPPER(QTY) LIKE '%E-%' THEN 0 ELSE TO_NUMBER(QTY) END))
         WHERE UPPER(QTY) LIKE '%E%'
           AND PLAN_ID = V_PLAN_ID;
    ------------------------------------------------------------------------
    -- ORDER_PRODUCTION DATA START
    ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        -- Get Order Production Int data
        ------------------------------------------------------------------------
        IF V_CHK_INTEGRAL IS NULL THEN
            INSERT INTO GT_TASM_OP_RESULT
                  (SITE_ID
                  ,ITEM_ID
                  ,GRADE
                  ,START_DATE
                  ,OUT_QTY_INT
                  ,LINE_ID
                  ,OPERATION_GROUP
                  ,OPERATION_ID
                  ,ELECTRODE_TYPE
                  )
            SELECT A.SITE_ID
                  ,A.ITEM_ID
                  ,A.GRADE
                  ,D.BASIS_YYYYMMDD                                                                                      AS START_DATE
                  ,ROUND(SUM(CASE WHEN D.BASIS_YYYYMMDD = A.START_DATE THEN CAST(A.OUT_QTY AS NUMBER(30,10)) ELSE 0 END), 8) AS OUT_QTY -- 상현 책임님 요청으로 소수점 9자리에서 반올림/20250912/THKIM
                  ,B.RESOURCE_NAME                                                                                       AS LINE_ID
                  ,C.OPERATION_GROUP
                  ,C.FLOW_ID                                                                                             AS OPERATION_ID
                  ,NULL                                                                                                  AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
              FROM SCP_OPT_ENG_OUT_ORDER_PRODUCTION_SN A
                  ,(SELECT PRODUCTION_ORDER_ID
                          ,PRODUCTION_LINE_ID
                          ,PLAN_ID
                      FROM SCP_OPT_ENG_OUT_DEMAND_ASSIGN_PEGGING_SN
                     WHERE PLAN_ID = V_PLAN_ID
                     GROUP BY PRODUCTION_ORDER_ID
                             ,PRODUCTION_LINE_ID
                             ,PLAN_ID
                   ) IA
                  ,SCP_OPT_ENG_RESOURCE_SN B
                  ,SCP_MST_FINAL_ITEM C
                  ,SCM_SYS_CALENDAR_M D
             WHERE A.PLAN_ID             = IA.PLAN_ID(+)
               AND A.PRODUCTION_ORDER_ID = IA.PRODUCTION_ORDER_ID(+)
               AND A.PLAN_ID             = B.PLAN_ID
               AND IA.PRODUCTION_LINE_ID = B.RESOURCE_ID
               AND C.ITEM_ID             = A.ITEM_ID
               AND A.GRADE IN ('ASSY', 'PACK', 'MDLE')
               AND IA.PLAN_ID IS NOT NULL
               AND C.OPERATION_GROUP     = 'A'
               AND C.DIVISION_ID         = V_DIVISION_ID
               AND A.PLAN_ID             = V_PLAN_ID
               AND D.BASIS_YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD  -- Plan From - To 구간 전체.
             GROUP BY A.SITE_ID
                     ,A.ITEM_ID
                     ,A.GRADE
                     ,D.BASIS_YYYYMMDD
                     ,B.RESOURCE_NAME
                     ,C.OPERATION_GROUP
                     ,C.FLOW_ID;
        ELSIF V_CHK_INTEGRAL IS NOT NULL THEN
            INSERT INTO GT_TASM_OP_RESULT
                  (SITE_ID
                  ,ITEM_ID
                  ,GRADE
                  ,START_DATE
                  ,OUT_QTY_INT
                  ,LINE_ID
                  ,OPERATION_GROUP
                  ,OPERATION_ID
                  ,ELECTRODE_TYPE
                  )
            SELECT A.SITE_ID
                  ,A.ITEM_ID
                  ,A.GRADE
                  ,D.BASIS_YYYYMMDD                                                                                          AS START_DATE
                  ,ROUND(SUM(CASE WHEN D.BASIS_YYYYMMDD = A.START_DATE THEN CAST(A.OUT_QTY_INT AS NUMBER(30,10)) ELSE 0 END), 8) AS OUT_QTY_INT
                  ,B.RESOURCE_NAME                                                                                           AS LINE_ID
                  ,C.OPERATION_GROUP
                  ,C.FLOW_ID                                                                                                 AS OPERATION_ID
                  ,NULL                                                                                                      AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
              FROM SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT_SN A
                  ,(SELECT PRODUCTION_ORDER_ID
                          ,PRODUCTION_LINE_ID
                          ,PLAN_ID
                      FROM SCP_OPT_ENG_OUT_DEMAND_ASSIGN_PEGGING_INT_SN
                     WHERE PLAN_ID = V_PLAN_ID
                     GROUP BY PRODUCTION_ORDER_ID
                             ,PRODUCTION_LINE_ID
                             ,PLAN_ID
                   ) IA
                  ,SCP_OPT_ENG_RESOURCE_SN B
                  ,SCP_MST_FINAL_ITEM C
                  ,SCM_SYS_CALENDAR_M D
             WHERE A.PLAN_ID             = IA.PLAN_ID(+)
               AND A.PRODUCTION_ORDER_ID = IA.PRODUCTION_ORDER_ID(+)
               AND A.PLAN_ID             = B.PLAN_ID
               AND IA.PRODUCTION_LINE_ID = B.RESOURCE_ID
               AND C.ITEM_ID             = A.ITEM_ID
               AND A.GRADE IN ('ASSY', 'PACK', 'MDLE')
               AND IA.PLAN_ID IS NOT NULL
               AND C.OPERATION_GROUP     = 'A'
               AND C.DIVISION_ID         = V_DIVISION_ID
               AND A.PLAN_ID             = V_PLAN_ID
               AND D.BASIS_YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD  -- Plan From - To 구간 전체.
             GROUP BY A.SITE_ID
                     ,A.ITEM_ID
                     ,A.GRADE
                     ,D.BASIS_YYYYMMDD
                     ,B.RESOURCE_NAME
                     ,C.OPERATION_GROUP
                     ,C.FLOW_ID;
        END IF;
        ------------------------------------------------------------------------
        -- 생산 결과가 없으면 Error 생성
        ------------------------------------------------------------------------
        SELECT COUNT(*)
          INTO V_OP_COUNT
          FROM GT_TASM_OP_RESULT;

        IF V_OP_COUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Order Production count is zero');
        END IF;
        ------------------------------------------------------------------------
        -- Initialization Qty
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_PRODUCTION_PLAN A
           SET A.QTY              = 0
              ,A.LAST_UPDATED_BY  = V_UPDATE_NAME
              ,A.LAST_UPDATE_DATE = V_NOW_DATE
          --, ATTRIBUTE9        = 'U'
          --, ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/INIT'
         WHERE EXISTS (SELECT 1
                         FROM SCP_OPT_ENG_MODEL_LIST_N_SN B
                        WHERE B.SCM_SITE_ID = A.SCM_SITE_ID
                          AND B.ITEM_ID     = A.ITEM_ID
                          AND B.PLAN_ID     = V_PLAN_ID
                      )
           AND A.MEASURE IN ('PROD_PLAN_AMEND')
           AND A.QTY != 0
           AND A.OPERATION_GROUP     = 'A'
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND A.PLAN_TYPE           = V_SCP_PLAN_TYPE
           AND A.SEQ                 = V_SCP_PLAN_SEQ
           AND A.YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD;
        ------------------------------------------------------------------------
        -- MERGE INTO OPT ENG Data
        ------------------------------------------------------------------------
        /* MERGE → UPDATE(WHEN MATCHED) + INSERT ... NOT EXISTS(WHEN NOT MATCHED) */
        UPDATE SCP_ANL_PRODUCTION_PLAN A
           SET (A.QTY
               ,A.LAST_UPDATE_DATE
               ,A.LAST_UPDATED_BY
                      --,ANL.ATTRIBUTE9        = 'U'
                      --,ANL.ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
               ) = (SELECT B.OUT_QTY_INT
                          ,V_NOW_DATE
                          ,V_UPDATE_NAME
                      FROM GT_TASM_OP_RESULT B
                     WHERE A.OPERATION_GROUP = B.OPERATION_GROUP
                       AND A.SCM_SITE_ID     = B.SITE_ID
                       AND A.ITEM_ID         = B.ITEM_ID
                       AND A.LINE_ID         = B.LINE_ID
                       AND A.OPERATION_ID    = B.OPERATION_ID
                       AND A.YYYYMMDD        = B.START_DATE
                       AND ROWNUM = 1
                   )
         WHERE EXISTS (SELECT 1
                         FROM GT_TASM_OP_RESULT C
                        WHERE A.OPERATION_GROUP = C.OPERATION_GROUP
                          AND A.SCM_SITE_ID     = C.SITE_ID
                          AND A.ITEM_ID         = C.ITEM_ID
                          AND A.LINE_ID         = C.LINE_ID
                          AND A.OPERATION_ID    = C.OPERATION_ID
                          AND A.YYYYMMDD        = C.START_DATE
                      )
           AND A.MEASURE IN ('PROD_PLAN_AMEND')
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND A.PLAN_TYPE           = V_SCP_PLAN_TYPE
           AND A.SEQ                 = V_SCP_PLAN_SEQ;

        INSERT INTO SCP_ANL_PRODUCTION_PLAN
              (DIVISION_ID
               ,PLAN_START_YYYYMMDD
               ,PLAN_TYPE
               ,SEQ
               ,OPERATION_GROUP
               ,SCM_SITE_ID
               ,ITEM_ID
               ,LINE_ID
               ,OPERATION_ID
               ,MEASURE
               ,YYYYMMDD
               ,QTY
               ,ORIGIN_DIVISION_ID
               ,ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
               ,CREATED_BY
               ,CREATION_DATE
               ,LAST_UPDATED_BY
               ,LAST_UPDATE_DATE
               --,ATTRIBUTE9
               --,ATTRIBUTE10
               )
        SELECT V_DIVISION_ID
              ,P_PLAN_START_YYYYMMDD
              ,V_SCP_PLAN_TYPE
              ,V_SCP_PLAN_SEQ
              ,A.OPERATION_GROUP
              ,A.SITE_ID
              ,A.ITEM_ID
              ,A.LINE_ID
              ,A.OPERATION_ID
              ,'PROD_PLAN_AMEND'
              ,A.START_DATE
              ,A.OUT_QTY_INT
              ,V_DIVISION_ID
              ,A.ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
              ,V_UPDATE_NAME
              ,V_NOW_DATE
              ,V_UPDATE_NAME
              ,V_NOW_DATE
              --,'I'
              --,CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
          FROM GT_TASM_OP_RESULT A
         WHERE NOT EXISTS (SELECT 1
                             FROM SCP_ANL_PRODUCTION_PLAN B
                            WHERE B.OPERATION_GROUP     = A.OPERATION_GROUP
                              AND B.SCM_SITE_ID         = A.SITE_ID
                              AND B.ITEM_ID             = A.ITEM_ID
                              AND B.LINE_ID             = A.LINE_ID
                              AND B.OPERATION_ID        = A.OPERATION_ID
                              AND B.YYYYMMDD            = A.START_DATE
                              AND B.MEASURE IN ('PROD_PLAN_AMEND')
                              AND B.DIVISION_ID         = V_DIVISION_ID
                              AND B.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                              AND B.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
                              AND B.PLAN_TYPE           = V_SCP_PLAN_TYPE
                              AND B.SEQ                 = V_SCP_PLAN_SEQ
                          );
        ------------------------------------------------------------------------
        -- INSERT HISTORY
        ------------------------------------------------------------------------
        INSERT INTO SCP_ANL_PRODUCTION_PLAN_H
              (HISTORY_SEQ
              ,DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,LINE_ID
              ,OPERATION_ID
              ,MEASURE
              ,YYYYMMDD
              ,QTY
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE7
              ,ATTRIBUTE8
              ,ATTRIBUTE9
              ,ATTRIBUTE10
              ,HISTORY_CREATION_DATE
              )
        SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_H.NEXTVAL
              ,DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,LINE_ID
              ,OPERATION_ID
              ,MEASURE
              ,YYYYMMDD
              ,QTY
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE7
              ,ATTRIBUTE8
              ,ATTRIBUTE9
              ,ATTRIBUTE10
              ,V_NOW_DATE
          FROM SCP_ANL_PRODUCTION_PLAN
         WHERE MEASURE IN ('PROD_PLAN_AMEND')
           AND DIVISION_ID         = V_DIVISION_ID
           AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND PLAN_TYPE           = V_SCP_PLAN_TYPE
           AND SEQ                 = V_SCP_PLAN_SEQ
           AND YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD
           AND LAST_UPDATED_BY     = V_UPDATE_NAME
           AND LAST_UPDATE_DATE    = V_NOW_DATE;

        ------------------------------------------------------------------------
        -- Initialization SCP_ANL_PRODUCTION_PLAN_FIX QTY
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_PRODUCTION_PLAN_FIX A
           SET A.QTY              = 0
              ,A.LAST_UPDATED_BY  = V_UPDATE_NAME
              ,A.LAST_UPDATE_DATE = V_NOW_DATE
          --, ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/INIT'
         WHERE EXISTS (SELECT 1
                         FROM SCP_OPT_ENG_MODEL_LIST_N_SN B
                        WHERE B.SCM_SITE_ID = A.SCM_SITE_ID
                          AND B.ITEM_ID     = A.ITEM_ID
                          AND B.PLAN_ID     = V_PLAN_ID
                      )
           AND A.QTY != 0
           AND A.OPERATION_GROUP = 'A'
           AND A.YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD
           AND A.DIVISION_ID     = V_DIVISION_ID;
        ------------------------------------------------------------------------
        -- UPDATE SCP_ANL_PRODUCTION_PLAN_FIX QTY
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_PRODUCTION_PLAN_FIX A
           SET (A.QTY
               ,A.LAST_UPDATED_BY
               ,A.LAST_UPDATE_DATE
          --, SCP_ANL_PRODUCTION_PLAN_FIX.ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/UPDATE'
               ) = (SELECT B.OUT_QTY_INT
                          ,V_UPDATE_NAME
                          ,V_NOW_DATE
                      FROM GT_TASM_OP_RESULT B
                     WHERE A.OPERATION_GROUP = B.OPERATION_GROUP
                       AND A.SCM_SITE_ID     = B.SITE_ID
                       AND A.ITEM_ID         = B.ITEM_ID
                       AND A.LINE_ID         = B.LINE_ID
                       AND A.OPERATION_ID    = B.OPERATION_ID
                       AND A.YYYYMMDD        = B.START_DATE
                       AND ROWNUM = 1
                   )
         WHERE EXISTS (SELECT 1
                         FROM GT_TASM_OP_RESULT C
                        WHERE A.OPERATION_GROUP = C.OPERATION_GROUP
                          AND A.SCM_SITE_ID     = C.SITE_ID
                          AND A.ITEM_ID         = C.ITEM_ID
                          AND A.LINE_ID         = C.LINE_ID
                          AND A.OPERATION_ID    = C.OPERATION_ID
                          AND A.YYYYMMDD        = C.START_DATE
                      )
           AND A.DIVISION_ID = V_DIVISION_ID;
        ------------------------------------------------------------------------
        -- INSERT FIX HISTORY
        ------------------------------------------------------------------------
        INSERT INTO SCP_ANL_PRODUCTION_PLAN_FIX_H
              (HISTORY_SEQ
              ,FIX_ID
              ,DIVISION_ID
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,LINE_ID
              ,OPERATION_ID
              ,YYYYMMDD
              ,QTY
              ,FIX_REASON
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE7
              ,ATTRIBUTE8
              ,ATTRIBUTE9
              ,ATTRIBUTE10
              ,HISTORY_CREATION_DATE
              )
        SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
              ,FIX_ID
              ,DIVISION_ID
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,LINE_ID
              ,OPERATION_ID
              ,YYYYMMDD
              ,QTY
              ,FIX_REASON
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE7
              ,ATTRIBUTE8
              ,ATTRIBUTE9
              ,ATTRIBUTE10
              ,V_NOW_DATE
          FROM SCP_ANL_PRODUCTION_PLAN_FIX
         WHERE DIVISION_ID      = V_DIVISION_ID
           AND YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD
           AND LAST_UPDATED_BY  = V_UPDATE_NAME
           AND LAST_UPDATE_DATE = V_NOW_DATE;
    ------------------------------------------------------------------------
    -- ORDER_SHIPPING SEMI DATA START
    ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        -- Get Order Shipping Int data
        ------------------------------------------------------------------------
        IF V_CHK_INTEGRAL IS NULL THEN
            INSERT INTO GT_TASM_OS_RESULT
                  (OPERATION_GROUP
                  ,ITEM_ID
                  ,FROM_SITE
                  ,BOD_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,TO_SITE
                  ,QTY
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,BOD_TYPE
                  )
            SELECT IA.OPERATION_GROUP
                  ,IA.ITEM_ID
                  ,IA.FROM_SITE
                  ,IA.BOD_ID
                  ,IA.MEASURE
                  ,A.BASIS_YYYYMMDD
                  ,IA.TO_SITE
                  ,ROUND(SUM(CASE WHEN A.BASIS_YYYYMMDD = IA.DELIVERY_DATE THEN CAST(IA.DELIVERY_QTY AS NUMBER(30,10)) ELSE 0 END), 8) AS OUT_QTY
                  ,IA.ORIGIN_FROM_DIVISION_ID
                  ,IA.ORIGIN_TO_DIVISION_ID
                  ,IA.ELECTRODE_TYPE
                  ,IA.BOD_TYPE
              FROM (SELECT E.OPERATION_GROUP                AS OPERATION_GROUP
                          ,C.ATTRIBUTE2                     AS ITEM_ID
                          ,C.ATTRIBUTE1                     AS FROM_SITE
                          ,D.BOD_ID                         AS BOD_ID
                          ,'SHIP_PLAN_AMEND'                AS MEASURE
                          ,B.DELIVERY_DATE                  AS DELIVERY_DATE
                          ,C.ATTRIBUTE6                     AS TO_SITE
                          ,SUM(TO_NUMBER(B.DELIVERY_QTY))   AS DELIVERY_QTY
                          ,V_DIVISION_ID                    AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                          ,V_DIVISION_ID                    AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                          ,NULL                             AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                          ,D.BOD_TYPE                       AS BOD_TYPE
                      FROM SCP_OPT_ENG_OUT_ORDER_DEMAND_DELIVERY_SN B
                          ,SCP_OPT_ENG_DEMAND_SN C
                          ,SCP_MST_BOD_N_V D
                          ,SCP_MST_FINAL_ITEM E
                     WHERE B.PLAN_ID      = C.PLAN_ID
                       AND B.DEMAND_ID    = C.DEMAND_ID
                       AND C.ATTRIBUTE1   = D.FROM_SITE
                       AND C.ATTRIBUTE6   = D.TO_SITE
                       AND C.ATTRIBUTE4   = D.INCOTERMS
                       AND C.ATTRIBUTE7   = D.TRANSPORT_MODE
                       AND B.DELIVERY_DATE BETWEEN D.FROM_YYYYMMDD AND D.TO_YYYYMMDD
                       AND E.ITEM_ID      = C.ATTRIBUTE2
                       AND D.BOD_VALID_YN = 'Y'
                       AND B.GRADE        = 'CHAR'
                       AND D.DIVISION_ID  = V_DIVISION_ID
                       AND E.DIVISION_ID  = V_DIVISION_ID
                       AND B.PLAN_ID      = V_PLAN_ID
                     GROUP BY E.OPERATION_GROUP
                             ,C.ATTRIBUTE2
                             ,C.ATTRIBUTE1
                             ,D.BOD_ID
                             ,B.DELIVERY_DATE
                             ,C.ATTRIBUTE6
                             ,D.BOD_TYPE
                    UNION ALL
                    SELECT G.OPERATION_GROUP
                          ,F.ATTRIBUTE2      AS ITEM_ID
                          ,F.ATTRIBUTE1      AS FROM_SITE
                          ,F.ATTRIBUTE7      AS BOD_ID
                          ,'SHIP_PLAN_AMEND' AS MEASURE
                          ,F.DEPARTURE_DATE  AS YYYYMMDD
                          ,F.ATTRIBUTE4      AS TO_SITE
                          ,F.QUANTITY        AS QTY
                          ,V_DIVISION_ID     AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                          ,V_DIVISION_ID     AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                          ,NULL              AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                          ,F.ATTRIBUTE8      AS BOD_TYPE
                      FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN F
                          ,SCP_MST_FINAL_ITEM G
                     WHERE G.ITEM_ID         = F.ATTRIBUTE2
                       AND F.ATTRIBUTE6      = 'IN'
                       AND F.ATTRIBUTE8      = 'PLANT'
                       AND G.OPERATION_GROUP = 'A'
                       AND G.DIVISION_ID     = V_DIVISION_ID
                       AND F.PLAN_ID         = V_PLAN_ID
                   ) IA
                  ,SCM_SYS_CALENDAR_M A
             WHERE A.BASIS_YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD  -- Plan From - To 구간 전체.
             GROUP BY IA.OPERATION_GROUP
                     ,IA.ITEM_ID
                     ,IA.FROM_SITE
                     ,IA.BOD_ID
                     ,IA.MEASURE
                     ,IA.TO_SITE
                     ,IA.ORIGIN_FROM_DIVISION_ID
                     ,IA.ORIGIN_TO_DIVISION_ID
                     ,IA.ELECTRODE_TYPE
                     ,IA.BOD_TYPE
                     ,A.BASIS_YYYYMMDD;
        ELSIF V_CHK_INTEGRAL IS NOT NULL THEN
            INSERT INTO GT_TASM_OS_RESULT
                  (OPERATION_GROUP
                  ,ITEM_ID
                  ,FROM_SITE
                  ,BOD_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,TO_SITE
                  ,QTY
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,BOD_TYPE
                  )
            SELECT IA.OPERATION_GROUP
                  ,IA.ITEM_ID
                  ,IA.FROM_SITE
                  ,IA.BOD_ID
                  ,IA.MEASURE
                  ,A.BASIS_YYYYMMDD
                  ,IA.TO_SITE
                  ,ROUND(SUM(CASE WHEN A.BASIS_YYYYMMDD = IA.DELIVERY_DATE THEN CAST(IA.DELIVERY_QTY AS NUMBER(30,10)) ELSE 0 END), 8) AS OUT_QTY_INT
                  ,IA.ORIGIN_FROM_DIVISION_ID
                  ,IA.ORIGIN_TO_DIVISION_ID
                  ,IA.ELECTRODE_TYPE
                  ,IA.BOD_TYPE
              FROM (SELECT E.OPERATION_GROUP                  AS OPERATION_GROUP
                          ,C.ATTRIBUTE2                       AS ITEM_ID
                          ,C.ATTRIBUTE1                       AS FROM_SITE
                          ,D.BOD_ID                           AS BOD_ID
                          ,'SHIP_PLAN_AMEND'                  AS MEASURE
                          ,B.DELIVERY_DATE                    AS DELIVERY_DATE
                          ,C.ATTRIBUTE6                       AS TO_SITE
                          ,SUM(TO_NUMBER(B.DELIVERY_QTY_INT)) AS DELIVERY_QTY
                       --,ODD.DELIVERY_QTY_INT AS DELIVERY_QTY
                          ,V_DIVISION_ID                      AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                          ,V_DIVISION_ID                      AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                          ,NULL                               AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                          ,D.BOD_TYPE                         AS BOD_TYPE
                       --,DM.ATTRIBUTE4        AS INCOTERMS
                       --,DM.ATTRIBUTE7        AS TRANSPORT_MODE
                       --,ODD.DUE_DATE         AS ODD_DUE_DATE
                       --,DM.DUE_DATE          AS DM_DUE_DATE
                       --,DM.QUANTITY          AS DM_QTY
                      FROM SCP_OPT_ENG_OUT_ORDER_DEMAND_DELIVERY_INT_SN B
                          ,SCP_OPT_ENG_DEMAND_SN C
                          ,SCP_MST_BOD_N_V D
                          ,SCP_MST_FINAL_ITEM E
                     WHERE B.PLAN_ID      = C.PLAN_ID
                       AND B.DEMAND_ID    = C.DEMAND_ID
                       AND C.ATTRIBUTE1   = D.FROM_SITE
                       AND C.ATTRIBUTE6   = D.TO_SITE
                       AND C.ATTRIBUTE4   = D.INCOTERMS
                       AND C.ATTRIBUTE7   = D.TRANSPORT_MODE
                       AND B.DELIVERY_DATE BETWEEN D.FROM_YYYYMMDD AND D.TO_YYYYMMDD
                       AND E.ITEM_ID      = C.ATTRIBUTE2
                       AND D.BOD_VALID_YN = 'Y'
                       AND B.GRADE        = 'CHAR'
                       AND D.DIVISION_ID  = V_DIVISION_ID
                       AND E.DIVISION_ID  = V_DIVISION_ID
                       AND B.PLAN_ID      = V_PLAN_ID
                     GROUP BY E.OPERATION_GROUP
                             ,C.ATTRIBUTE2
                             ,C.ATTRIBUTE1
                             ,D.BOD_ID
                             ,B.DELIVERY_DATE
                             ,C.ATTRIBUTE6
                             ,D.BOD_TYPE

                --SELECT FI.OPERATION_GROUP
                --      ,OS.ITEM_ID        AS ITEM_ID
                --      ,OS.FROM_SITE_ID   AS FROM_SITE
                --      ,BOD.ATTRIBUTE7    AS BOD_ID
                --      ,'SHIP_PLAN_AMEND' AS MEASURE
                --      ,OS.DEPARTURE_DATE AS YYYYMMDD
                --      ,OS.TO_SITE_ID     AS TO_SITE
                --      ,OS.QTY_INT        AS QTY
                --      ,@V_DIVISION_ID    AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                --      ,@V_DIVISION_ID    AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                --      ,NULL              AS ELECTRODE_TYPE
                --      ,BOD.ATTRIBUTE8    AS BOD_TYPE
                --FROM SCP_OPT_ENG_OUT_ORDER_SHIPPING_INT_SN  OS WITH(NOLOCK)
                --    INNER JOIN SCP_OPT_ENG_BOD_SN BOD WITH(NOLOCK)
                --        ON  BOD.PLAN_ID = @V_PLAN_ID
                --        AND OS.BOD_ID   = BOD.BOD_ID
                --    INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
                --        ON  FI.DIVISION_ID = @V_DIVISION_ID
                --        AND FI.ITEM_ID     = OS.ITEM_ID
                --WHERE 1=1
                --AND BOD.ATTRIBUTE8 = 'PLANT'  --SALES는 FG에 넣고 PLANT만 SEMI에 넣으면 됨.
                --AND OS.PLAN_ID = @V_PLAN_ID
                --AND FI.OPERATION_GROUP = 'A'

                    UNION ALL
                    SELECT G.OPERATION_GROUP
                          ,F.ATTRIBUTE2      AS ITEM_ID
                          ,F.ATTRIBUTE1      AS FROM_SITE
                          ,F.ATTRIBUTE7      AS BOD_ID
                          ,'SHIP_PLAN_AMEND' AS MEASURE
                          ,F.DEPARTURE_DATE  AS YYYYMMDD
                          ,F.ATTRIBUTE4      AS TO_SITE
                          ,F.QUANTITY        AS QTY
                          ,V_DIVISION_ID     AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                          ,V_DIVISION_ID     AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                          ,NULL              AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                          ,F.ATTRIBUTE8      AS BOD_TYPE
                      FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN F
                          ,SCP_MST_FINAL_ITEM G
                     WHERE G.ITEM_ID         = F.ATTRIBUTE2
                       AND F.ATTRIBUTE6      = 'IN'
                       AND F.ATTRIBUTE8      = 'PLANT'
                       AND G.OPERATION_GROUP = 'A'
                       AND G.DIVISION_ID     = V_DIVISION_ID
                       AND F.PLAN_ID         = V_PLAN_ID
                   ) IA
                  ,SCM_SYS_CALENDAR_M A
             WHERE A.BASIS_YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD  -- Plan From - To 구간 전체.
             GROUP BY IA.OPERATION_GROUP
                     ,IA.ITEM_ID
                     ,IA.FROM_SITE
                     ,IA.BOD_ID
                     ,IA.MEASURE
                     ,IA.TO_SITE
                     ,IA.ORIGIN_FROM_DIVISION_ID
                     ,IA.ORIGIN_TO_DIVISION_ID
                     ,IA.ELECTRODE_TYPE
                     ,IA.BOD_TYPE
                     ,A.BASIS_YYYYMMDD;
        END IF;
        ------------------------------------------------------------------------
        -- Initialization Qty
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_SHIPMENT_PLAN_SEMI A
           SET A.QTY              = 0
              ,A.LAST_UPDATED_BY  = V_UPDATE_NAME
              ,A.LAST_UPDATE_DATE = V_NOW_DATE
          --, ATTRIBUTE9        = 'U'
          --, ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/INIT'
         WHERE EXISTS (SELECT 1
                         FROM SCP_OPT_ENG_MODEL_LIST_N_SN B
                        WHERE B.SCM_SITE_ID = A.FROM_SITE
                          AND B.ITEM_ID     = A.ITEM_ID
                          AND B.PLAN_ID     = V_PLAN_ID
                      )
           AND A.MEASURE IN ('SHIP_PLAN_AMEND')
           AND A.QTY != 0
           AND A.OPERATION_GROUP     = 'A'
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND A.PLAN_TYPE           = V_SCP_PLAN_TYPE
           AND A.SEQ                 = V_SCP_PLAN_SEQ
           AND A.YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD;
        ------------------------------------------------------------------------
        -- MERGE INTO OPT ENG Data
        ------------------------------------------------------------------------
        /* MERGE → UPDATE(WHEN MATCHED) + INSERT ... NOT EXISTS(WHEN NOT MATCHED) */
        UPDATE SCP_ANL_SHIPMENT_PLAN_SEMI A
           SET (A.QTY
               ,A.LAST_UPDATE_DATE
               ,A.LAST_UPDATED_BY
                      --,ANL.ATTRIBUTE9       = 'U'
                      --,ANL.ATTRIBUTE10      = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
               ) = (SELECT B.QTY
                          ,V_NOW_DATE
                          ,V_UPDATE_NAME
                      FROM GT_TASM_OS_RESULT B
                     WHERE A.OPERATION_GROUP = B.OPERATION_GROUP
                       AND A.ITEM_ID         = B.ITEM_ID
                       AND A.FROM_SITE       = B.FROM_SITE
                       AND A.BOD_ID          = B.BOD_ID
                       AND A.MEASURE         = B.MEASURE
                       AND A.YYYYMMDD        = B.YYYYMMDD
                       AND ROWNUM = 1
                   )
         WHERE EXISTS (SELECT 1
                         FROM GT_TASM_OS_RESULT C
                        WHERE A.OPERATION_GROUP = C.OPERATION_GROUP
                          AND A.ITEM_ID         = C.ITEM_ID
                          AND A.FROM_SITE       = C.FROM_SITE
                          AND A.BOD_ID          = C.BOD_ID
                          AND A.MEASURE         = C.MEASURE
                          AND A.YYYYMMDD        = C.YYYYMMDD
                      )
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND A.PLAN_TYPE           = V_SCP_PLAN_TYPE
           AND A.SEQ                 = V_SCP_PLAN_SEQ;

        INSERT INTO SCP_ANL_SHIPMENT_PLAN_SEMI
              (DIVISION_ID
               ,PLAN_START_YYYYMMDD
               ,PLAN_TYPE
               ,SEQ
               ,OPERATION_GROUP
               ,ITEM_ID
               ,FROM_SITE
               ,BOD_ID
               ,MEASURE
               ,YYYYMMDD
               ,TO_SITE
               ,QTY
               ,ORIGIN_FROM_DIVISION_ID
               ,ORIGIN_TO_DIVISION_ID
               ,ELECTRODE_TYPE
               ,CREATED_BY
               ,CREATION_DATE
               ,LAST_UPDATED_BY
               ,LAST_UPDATE_DATE
               --,ATTRIBUTE9
               --,ATTRIBUTE10
               )
        SELECT V_DIVISION_ID
              ,P_PLAN_START_YYYYMMDD
              ,V_SCP_PLAN_TYPE
              ,V_SCP_PLAN_SEQ
              ,A.OPERATION_GROUP
              ,A.ITEM_ID
              ,A.FROM_SITE
              ,A.BOD_ID
              ,A.MEASURE
              ,A.YYYYMMDD
              ,A.TO_SITE
              ,A.QTY
              ,A.ORIGIN_TO_DIVISION_ID      /* AS-IS 그대로 : ORIGIN_FROM_DIVISION_ID 자리에 ORIGIN_TO 값 */
              ,A.ORIGIN_FROM_DIVISION_ID    /* AS-IS 그대로 : ORIGIN_TO_DIVISION_ID 자리에 ORIGIN_FROM 값 */
              ,A.ELECTRODE_TYPE
              ,V_UPDATE_NAME
              ,V_NOW_DATE
              ,V_UPDATE_NAME
              ,V_NOW_DATE
              --,'I'
              --,CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
          FROM GT_TASM_OS_RESULT A
         WHERE NOT EXISTS (SELECT 1
                             FROM SCP_ANL_SHIPMENT_PLAN_SEMI B
                            WHERE B.OPERATION_GROUP     = A.OPERATION_GROUP
                              AND B.ITEM_ID             = A.ITEM_ID
                              AND B.FROM_SITE           = A.FROM_SITE
                              AND B.BOD_ID              = A.BOD_ID
                              AND B.MEASURE             = A.MEASURE
                              AND B.YYYYMMDD            = A.YYYYMMDD
                              AND B.DIVISION_ID         = V_DIVISION_ID
                              AND B.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                              AND B.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
                              AND B.PLAN_TYPE           = V_SCP_PLAN_TYPE
                              AND B.SEQ                 = V_SCP_PLAN_SEQ
                          );
        ------------------------------------------------------------------------
        -- INSERT HISTORY
        ------------------------------------------------------------------------
        INSERT INTO SCP_ANL_SHIPMENT_PLAN_SEMI_H
              (HISTORY_SEQ
              ,DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,OPERATION_GROUP
              ,ITEM_ID
              ,FROM_SITE
              ,TO_SITE
              ,BOD_ID
              ,MEASURE
              ,YYYYMMDD
              ,QTY
              ,UPDATE_REASON_BOD
              ,ORIGIN_FROM_DIVISION_ID
              ,ORIGIN_TO_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE7
              ,ATTRIBUTE8
              ,ATTRIBUTE9
              ,ATTRIBUTE10
              ,HISTORY_CREATION_DATE
              )
        SELECT SEQ1_SCP_ANL_SHIPMENT_PLAN_SEMI_H.NEXTVAL AS HISTORY_SEQ
              ,DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,OPERATION_GROUP
              ,ITEM_ID
              ,FROM_SITE
              ,TO_SITE
              ,BOD_ID
              ,MEASURE
              ,YYYYMMDD
              ,QTY
              ,NULL       AS UPDATE_REASON_BOD
              ,ORIGIN_FROM_DIVISION_ID
              ,ORIGIN_TO_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE7
              ,ATTRIBUTE8
              ,ATTRIBUTE9
              ,ATTRIBUTE10
              ,V_NOW_DATE AS HISTORY_CREATION_DATE
          FROM SCP_ANL_SHIPMENT_PLAN_SEMI
         WHERE MEASURE IN ('SHIP_PLAN_AMEND')
           AND DIVISION_ID         = V_DIVISION_ID
           AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND PLAN_TYPE           = V_SCP_PLAN_TYPE
           AND SEQ                 = V_SCP_PLAN_SEQ
           AND YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD
           AND LAST_UPDATED_BY     = V_UPDATE_NAME
           AND LAST_UPDATE_DATE    = V_NOW_DATE;


        ------------------------------------------------------------------------
        -- Initialization SCP_ANL_SHIPMENT_PLAN_FIX QTY
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_SHIPMENT_PLAN_FIX A
           SET A.QTY              = 0
              ,A.LAST_UPDATED_BY  = V_UPDATE_NAME
              ,A.LAST_UPDATE_DATE = V_NOW_DATE
          --, ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/INIT'
         WHERE EXISTS (SELECT 1
                         FROM SCP_OPT_ENG_MODEL_LIST_N_SN B
                        WHERE B.SCM_SITE_ID = A.FROM_SITE
                          AND B.ITEM_ID     = A.ITEM_ID
                          AND B.PLAN_ID     = V_PLAN_ID
                      )
           AND A.QTY != 0
           AND A.BIZ_TYPE    = 'A'
           AND A.YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD
           AND A.DIVISION_ID = V_DIVISION_ID;

        ------------------------------------------------------------------------
        -- Update SCP_ANL_SHIPMENT_PLAN_FIX QTY
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_SHIPMENT_PLAN_FIX A
           SET (A.QTY
               ,A.LAST_UPDATED_BY
               ,A.LAST_UPDATE_DATE
          --, SCP_ANL_SHIPMENT_PLAN_FIX.ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/UPDATE'
               ) = (SELECT B.QTY
                          ,V_UPDATE_NAME
                          ,V_NOW_DATE
                      FROM GT_TASM_OS_RESULT B
                     WHERE A.BIZ_TYPE  = B.OPERATION_GROUP
                       AND A.ITEM_ID   = B.ITEM_ID
                       AND A.TO_SITE   = B.TO_SITE
                       AND A.FROM_SITE = B.FROM_SITE
                       AND A.BOD_ID    = B.BOD_ID
                       AND A.YYYYMMDD  = B.YYYYMMDD
                       AND ROWNUM = 1
                   )
         WHERE EXISTS (SELECT 1
                         FROM GT_TASM_OS_RESULT C
                        WHERE A.BIZ_TYPE  = C.OPERATION_GROUP
                          AND A.ITEM_ID   = C.ITEM_ID
                          AND A.TO_SITE   = C.TO_SITE
                          AND A.FROM_SITE = C.FROM_SITE
                          AND A.BOD_ID    = C.BOD_ID
                          AND A.YYYYMMDD  = C.YYYYMMDD
                      )
           AND A.DIVISION_ID = V_DIVISION_ID;
    ------------------------------------------------------------------------
    -- ORDER_SHIPPING FG DATA START
    ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        -- Get Order Shipping Int data
        ------------------------------------------------------------------------
        IF V_CHK_INTEGRAL IS NULL THEN
            INSERT INTO GT_TASM_OS_RESULT_FG
                  (OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,FROM_SITE
                  ,BOD_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,TO_SITE
                  ,QTY
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,BOD_TYPE
                  ,INCOTERMS
                  )
            SELECT IA.BIZ_TYPE
                  ,IA.PROJECT_CODE
                  ,IA.ITEM_ID
                  ,IA.FROM_SITE
                  ,IA.BOD_ID
                  ,IA.MEASURE
                  --,YYYYMMDD
                  ,A.BASIS_YYYYMMDD
                  ,IA.TO_SITE
                  ,ROUND(SUM(CASE WHEN A.BASIS_YYYYMMDD = IA.YYYYMMDD THEN CAST(IA.QTY AS NUMBER(30,10)) ELSE 0 END), 8) AS OUT_QTY
                  --,QTY
                  ,IA.ORIGIN_FROM_DIVISION_ID
                  ,IA.ORIGIN_TO_DIVISION_ID
                  ,IA.ELECTRODE_TYPE
                  ,IA.BOD_TYPE
                  ,IA.INCOTERMS
              FROM (SELECT D.OPERATION_GROUP AS BIZ_TYPE
                          ,C.ATTRIBUTE9      AS PROJECT_CODE
                          ,B.ITEM_ID
                          ,B.FROM_SITE_ID    AS FROM_SITE
                          ,C.ATTRIBUTE7      AS BOD_ID
                          ,'SHIP_PLAN_AMEND' AS MEASURE
                          ,B.DEPARTURE_DATE  AS YYYYMMDD
                          ,B.TO_SITE_ID      AS TO_SITE
                          ,TO_NUMBER(B.QTY)  AS QTY -- 2026.04.16 Minyong Lee : UNION ALL로 인한 의도치 않은 타입캐스팅 및 소수 데이터 유실 에러 수정
                          ,V_DIVISION_ID     AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                          ,V_DIVISION_ID     AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                          ,NULL              AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                          ,C.ATTRIBUTE8      AS BOD_TYPE
                          ,C.ATTRIBUTE6      AS INCOTERMS
                      FROM SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN B
                          ,SCP_OPT_ENG_BOD_SN C
                          ,SCP_MST_FINAL_ITEM D
                     WHERE B.BOD_ID          = C.BOD_ID
                       AND D.ITEM_ID         = B.ITEM_ID
                       AND C.ATTRIBUTE8      = 'SALES'  --SALES는 FG에 넣고 PLANT만 SEMI에 넣으면 됨.
                       AND D.OPERATION_GROUP = 'A'
                       AND C.PLAN_ID         = V_PLAN_ID
                       AND D.DIVISION_ID     = V_DIVISION_ID
                       AND B.PLAN_ID         = V_PLAN_ID
                ------------------------------------------------------------------------
                -- Get Scheduled Move data
                -- INT 테이블 결과에 Scheduled Move 데이터는 나오지 않음
                ------------------------------------------------------------------------
                    UNION ALL
                    SELECT F.OPERATION_GROUP
                          ,E.ATTRIBUTE10     AS PROJECT_CODE
                          ,E.ATTRIBUTE2      AS ITEM_ID
                          ,E.ATTRIBUTE1      AS FROM_SITE
                          ,E.ATTRIBUTE7      AS BOD_ID
                          ,'SHIP_PLAN_AMEND' AS MEASURE
                          ,E.DEPARTURE_DATE  AS YYYYMMDD
                          ,E.ATTRIBUTE4      AS TO_SITE
                          ,SUM(E.QUANTITY)   AS QTY
                          ,V_DIVISION_ID     AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                          ,V_DIVISION_ID     AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                          ,NULL              AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                          ,E.ATTRIBUTE8      AS BOD_TYPE
                          ,E.ATTRIBUTE9      AS INCOTERMS
                      FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN E
                          ,SCP_MST_FINAL_ITEM F
                     WHERE F.ITEM_ID         = E.ATTRIBUTE2
                       AND E.ATTRIBUTE6      = 'IN'
                       AND E.ATTRIBUTE8      = 'SALES'
                       AND F.OPERATION_GROUP = 'A'
                       AND F.DIVISION_ID     = V_DIVISION_ID
                       AND E.PLAN_ID         = V_PLAN_ID
                     GROUP BY F.OPERATION_GROUP
                             ,E.ATTRIBUTE10
                             ,E.ATTRIBUTE2
                             ,E.ATTRIBUTE1
                             ,E.ATTRIBUTE7
                             ,E.DEPARTURE_DATE
                             ,E.ATTRIBUTE4
                             ,E.ATTRIBUTE8
                             ,E.ATTRIBUTE9 -- SCHEDULED MOVE 테이블을 만들 때 PROJECT CODE가 없으면 찾아주는데, 원본에 있는거 하나, 없는거 하나 생길 수 있음
                   ) IA
                  ,SCM_SYS_CALENDAR_M A
             WHERE A.BASIS_YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD  -- Plan From - To 구간 전체.
             GROUP BY IA.BIZ_TYPE
                     ,IA.PROJECT_CODE
                     ,IA.ITEM_ID
                     ,IA.FROM_SITE
                     ,IA.BOD_ID
                     ,IA.MEASURE
                     ,IA.TO_SITE
                     ,IA.ORIGIN_FROM_DIVISION_ID
                     ,IA.ORIGIN_TO_DIVISION_ID
                     ,IA.ELECTRODE_TYPE
                     ,IA.BOD_TYPE
                     ,IA.INCOTERMS
                     ,A.BASIS_YYYYMMDD;
        ELSIF V_CHK_INTEGRAL IS NOT NULL THEN
            INSERT INTO GT_TASM_OS_RESULT_FG
                  (OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,FROM_SITE
                  ,BOD_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,TO_SITE
                  ,QTY
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,BOD_TYPE
                  ,INCOTERMS
                  )
            SELECT IA.BIZ_TYPE
                  ,IA.PROJECT_CODE
                  ,IA.ITEM_ID
                  ,IA.FROM_SITE
                  ,IA.BOD_ID
                  ,IA.MEASURE
                  --,YYYYMMDD
                  ,A.BASIS_YYYYMMDD
                  ,IA.TO_SITE
                  ,ROUND(SUM(CASE WHEN A.BASIS_YYYYMMDD = IA.YYYYMMDD THEN CAST(IA.QTY AS NUMBER(30,10)) ELSE 0 END), 8) AS OUT_QTY_INT
                  --,QTY
                  ,IA.ORIGIN_FROM_DIVISION_ID
                  ,IA.ORIGIN_TO_DIVISION_ID
                  ,IA.ELECTRODE_TYPE
                  ,IA.BOD_TYPE
                  ,IA.INCOTERMS
              FROM (SELECT D.OPERATION_GROUP     AS BIZ_TYPE
                          ,C.ATTRIBUTE9          AS PROJECT_CODE
                          ,B.ITEM_ID
                          ,B.FROM_SITE_ID        AS FROM_SITE
                          ,C.ATTRIBUTE7          AS BOD_ID
                          ,'SHIP_PLAN_AMEND'     AS MEASURE
                          ,B.DEPARTURE_DATE      AS YYYYMMDD
                          ,B.TO_SITE_ID          AS TO_SITE
                          ,TO_NUMBER(B.QTY_INT)  AS QTY -- 2026.04.16 Minyong Lee : UNION ALL로 인한 의도치 않은 타입캐스팅 및 소수 데이터 유실 에러 수정
                          ,V_DIVISION_ID         AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                          ,V_DIVISION_ID         AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                          ,NULL                  AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                          ,C.ATTRIBUTE8          AS BOD_TYPE
                          ,C.ATTRIBUTE6          AS INCOTERMS
                      FROM SCP_OPT_ENG_OUT_ORDER_SHIPPING_INT_SN B
                          ,SCP_OPT_ENG_BOD_SN C
                          ,SCP_MST_FINAL_ITEM D
                     WHERE B.BOD_ID          = C.BOD_ID
                       AND D.ITEM_ID         = B.ITEM_ID
                       AND C.ATTRIBUTE8      = 'SALES'  --SALES는 FG에 넣고 PLANT만 SEMI에 넣으면 됨.
                       AND D.OPERATION_GROUP = 'A'
                       AND C.PLAN_ID         = V_PLAN_ID
                       AND D.DIVISION_ID     = V_DIVISION_ID
                       AND B.PLAN_ID         = V_PLAN_ID
                ------------------------------------------------------------------------
                -- Get Scheduled Move data
                -- INT 테이블 결과에 Scheduled Move 데이터는 나오지 않음
                ------------------------------------------------------------------------
                    UNION ALL
                    SELECT F.OPERATION_GROUP
                          ,E.ATTRIBUTE10     AS PROJECT_CODE
                          ,E.ATTRIBUTE2      AS ITEM_ID
                          ,E.ATTRIBUTE1      AS FROM_SITE
                          ,E.ATTRIBUTE7      AS BOD_ID
                          ,'SHIP_PLAN_AMEND' AS MEASURE
                          ,E.DEPARTURE_DATE  AS YYYYMMDD
                          ,E.ATTRIBUTE4      AS TO_SITE
                          ,SUM(E.QUANTITY)   AS QTY
                          ,V_DIVISION_ID     AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                          ,V_DIVISION_ID     AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                          ,NULL              AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                          ,E.ATTRIBUTE8      AS BOD_TYPE
                          ,E.ATTRIBUTE9      AS INCOTERMS
                      FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN E
                          ,SCP_MST_FINAL_ITEM F
                     WHERE F.ITEM_ID         = E.ATTRIBUTE2
                       AND E.ATTRIBUTE6      = 'IN'
                       AND E.ATTRIBUTE8      = 'SALES'
                       AND F.OPERATION_GROUP = 'A'
                       AND F.DIVISION_ID     = V_DIVISION_ID
                       AND E.PLAN_ID         = V_PLAN_ID
                     GROUP BY F.OPERATION_GROUP
                             ,E.ATTRIBUTE10
                             ,E.ATTRIBUTE2
                             ,E.ATTRIBUTE1
                             ,E.ATTRIBUTE7
                             ,E.DEPARTURE_DATE
                             ,E.ATTRIBUTE4
                             ,E.ATTRIBUTE8
                             ,E.ATTRIBUTE9 -- SCHEDULED MOVE 테이블을 만들 때 PROJECT CODE가 없으면 찾아주는데, 원본에 있는거 하나, 없는거 하나 생길 수 있음
                   ) IA
                  ,SCM_SYS_CALENDAR_M A
             WHERE A.BASIS_YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD  -- Plan From - To 구간 전체.
             GROUP BY IA.BIZ_TYPE
                     ,IA.PROJECT_CODE
                     ,IA.ITEM_ID
                     ,IA.FROM_SITE
                     ,IA.BOD_ID
                     ,IA.MEASURE
                     ,IA.TO_SITE
                     ,IA.ORIGIN_FROM_DIVISION_ID
                     ,IA.ORIGIN_TO_DIVISION_ID
                     ,IA.ELECTRODE_TYPE
                     ,IA.BOD_TYPE
                     ,IA.INCOTERMS
                     ,A.BASIS_YYYYMMDD;
        END IF;
       ------------------------------------------------------------------------
        -- 1. Initialization Qty
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_SHIPMENT_PLAN_FG A
           SET A.QTY              = 0
              ,A.LAST_UPDATED_BY  = V_UPDATE_NAME
              ,A.LAST_UPDATE_DATE = V_NOW_DATE
          --, ATTRIBUTE9       = 'U'
          --, ATTRIBUTE10      = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/INIT'
         WHERE EXISTS (SELECT 1
                         FROM SCP_OPT_ENG_MODEL_LIST_N_SN B
                        WHERE B.SCM_SITE_ID = A.FROM_SITE
                          AND B.ITEM_ID     = A.ITEM_ID
                          AND B.PLAN_ID     = V_PLAN_ID
                      )
           AND A.MEASURE IN ('SHIP_PLAN_AMEND')
           AND A.QTY != 0
           AND A.BIZ_TYPE            = 'A'
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND A.PLAN_TYPE           = V_SCP_PLAN_TYPE
           AND A.SEQ                 = V_SCP_PLAN_SEQ
           AND A.YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD;
        ------------------------------------------------------------------------
        -- 2. Get SCP_ANL_SHIPMENT_PLAN_FG DATA
        -- 프로젝트 코드가 1개인 대상만 추출 -> 속도 개선을 위한 TEMP 테이블 사용
        -- '-'는 제외하고 COUNTING
        ------------------------------------------------------------------------
        INSERT INTO GT_TASM_OS_RESULT_FG_SMMR
              (ITEM_ID
              ,BOD_ID
              ,PROJECT_CODE
              )
        SELECT IA.ITEM_ID
              ,IA.BOD_ID
              ,A.PROJECT_CODE
          FROM (SELECT XA.DIVISION_ID
                      ,XA.PLAN_START_YYYYMMDD
                      ,XA.PLAN_TYPE
                      ,XA.SEQ
                      ,XA.BIZ_TYPE
                      ,XA.ITEM_ID
                      ,XA.MEASURE
                      ,XA.BOD_ID
                  FROM (SELECT B.DIVISION_ID
                              ,B.PLAN_START_YYYYMMDD
                              ,B.PLAN_TYPE
                              ,B.SEQ
                              ,B.BIZ_TYPE
                              ,B.PROJECT_CODE
                              ,B.ITEM_ID
                              ,B.MEASURE
                              ,B.BOD_ID
                          FROM SCP_ANL_SHIPMENT_PLAN_FG B
                              ,(SELECT SCM_SITE_ID
                                      ,ITEM_ID
                                  FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                 WHERE PLAN_ID = V_PLAN_ID
                                 GROUP BY SCM_SITE_ID
                                         ,ITEM_ID
                               ) SA
                         WHERE B.FROM_SITE           = SA.SCM_SITE_ID
                           AND B.ITEM_ID             = SA.ITEM_ID
                           AND B.MEASURE IN ('SHIP_PLAN_AMEND')
                           AND B.PROJECT_CODE       != '-'
                           AND B.BIZ_TYPE            = 'A'
                           AND B.DIVISION_ID         = V_DIVISION_ID
                           AND B.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                           AND B.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
                           AND B.PLAN_TYPE           = V_SCP_PLAN_TYPE
                           AND B.SEQ                 = V_SCP_PLAN_SEQ
                           AND B.YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD
                         GROUP BY B.DIVISION_ID
                                 ,B.PLAN_START_YYYYMMDD
                                 ,B.PLAN_TYPE
                                 ,B.SEQ
                                 ,B.BIZ_TYPE
                                 ,B.PROJECT_CODE
                                 ,B.ITEM_ID
                                 ,B.MEASURE
                                 ,B.BOD_ID
                       ) XA
                 GROUP BY XA.DIVISION_ID
                         ,XA.PLAN_START_YYYYMMDD
                         ,XA.PLAN_TYPE
                         ,XA.SEQ
                         ,XA.BIZ_TYPE
                         ,XA.ITEM_ID
                         ,XA.MEASURE
                         ,XA.BOD_ID
                HAVING COUNT(XA.DIVISION_ID) = 1
               ) IA
              ,SCP_ANL_SHIPMENT_PLAN_FG A
         WHERE IA.ITEM_ID             = A.ITEM_ID
           AND IA.BOD_ID              = A.BOD_ID
           AND A.DIVISION_ID          = IA.DIVISION_ID
           AND A.MEASURE              = IA.MEASURE
           AND A.PLAN_START_YYYYMMDD  = IA.PLAN_START_YYYYMMDD
           AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 (안쪽 집합이 같은 계획 시작일) */
           AND A.PLAN_TYPE            = IA.PLAN_TYPE
           AND A.SEQ                  = IA.SEQ
           AND A.PROJECT_CODE        != '-'
           AND A.BIZ_TYPE             = 'A'
           AND A.YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD
         GROUP BY IA.ITEM_ID
                 ,IA.BOD_ID
                 ,A.PROJECT_CODE;


        ------------------------------------------------------------------------
        -- 2-1. 엔진 결과에 프로젝트 코드가 있으면 바로 넣고, 없는 애들만 2-2에서 프로젝트 코드를 찾아서 넣음
        ------------------------------------------------------------------------
        /* MERGE → UPDATE(WHEN MATCHED) + INSERT ... NOT EXISTS(WHEN NOT MATCHED). USING 서브쿼리는 두 문장에 그대로 */
        UPDATE SCP_ANL_SHIPMENT_PLAN_FG A
           SET (A.QTY
               ,A.LAST_UPDATE_DATE
               ,A.LAST_UPDATED_BY
                      --,ANL.ATTRIBUTE9       = 'U'
                      --,ANL.ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
               ) = (SELECT IA.QTY
                          ,V_NOW_DATE
                          ,V_UPDATE_NAME
                      FROM (SELECT B.OPERATION_GROUP
                                  ,B.PROJECT_CODE
                                  ,B.ITEM_ID
                                  ,B.TO_SITE
                                  ,B.INCOTERMS
                                  ,B.FROM_SITE
                                  ,B.BOD_ID
                                  ,B.MEASURE
                                  ,B.YYYYMMDD
                                  ,B.QTY
                                  ,B.ORIGIN_FROM_DIVISION_ID
                                  ,B.ORIGIN_TO_DIVISION_ID
                                  ,B.ELECTRODE_TYPE
                              FROM GT_TASM_OS_RESULT_FG B
                             WHERE B.PROJECT_CODE != '/' --프로젝트 코드를 가지고있는 애들은 바로 MERGE INTO
                           ) IA
                     WHERE A.BIZ_TYPE     = IA.OPERATION_GROUP
                       AND A.PROJECT_CODE = IA.PROJECT_CODE
                       AND A.ITEM_ID      = IA.ITEM_ID
                       AND A.TO_SITE      = IA.TO_SITE
                       AND A.INCOTERMS    = IA.INCOTERMS
                       AND A.FROM_SITE    = IA.FROM_SITE
                       AND A.BOD_ID       = IA.BOD_ID
                       AND A.MEASURE      = IA.MEASURE
                       AND A.YYYYMMDD     = IA.YYYYMMDD
                       AND ROWNUM = 1
                   )
         WHERE EXISTS (SELECT 1
                         FROM (SELECT C.OPERATION_GROUP
                                     ,C.PROJECT_CODE
                                     ,C.ITEM_ID
                                     ,C.TO_SITE
                                     ,C.INCOTERMS
                                     ,C.FROM_SITE
                                     ,C.BOD_ID
                                     ,C.MEASURE
                                     ,C.YYYYMMDD
                                     ,C.QTY
                                     ,C.ORIGIN_FROM_DIVISION_ID
                                     ,C.ORIGIN_TO_DIVISION_ID
                                     ,C.ELECTRODE_TYPE
                                 FROM GT_TASM_OS_RESULT_FG C
                                WHERE C.PROJECT_CODE != '/'
                              ) XA
                        WHERE A.BIZ_TYPE     = XA.OPERATION_GROUP
                          AND A.PROJECT_CODE = XA.PROJECT_CODE
                          AND A.ITEM_ID      = XA.ITEM_ID
                          AND A.TO_SITE      = XA.TO_SITE
                          AND A.INCOTERMS    = XA.INCOTERMS
                          AND A.FROM_SITE    = XA.FROM_SITE
                          AND A.BOD_ID       = XA.BOD_ID
                          AND A.MEASURE      = XA.MEASURE
                          AND A.YYYYMMDD     = XA.YYYYMMDD
                      )
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND A.PLAN_TYPE           = V_SCP_PLAN_TYPE
           AND A.SEQ                 = V_SCP_PLAN_SEQ;

        INSERT INTO SCP_ANL_SHIPMENT_PLAN_FG
              (DIVISION_ID
               ,PLAN_START_YYYYMMDD
               ,PLAN_TYPE
               ,SEQ
               ,BIZ_TYPE
               ,PROJECT_CODE
               ,ITEM_ID
               ,TO_SITE
               ,INCOTERMS
               ,FROM_SITE
               ,BOD_ID
               ,MEASURE
               ,YYYYMMDD
               ,QTY
               ,ORIGIN_FROM_DIVISION_ID
               ,ORIGIN_TO_DIVISION_ID
               ,ELECTRODE_TYPE
               ,CREATED_BY
               ,CREATION_DATE
               ,LAST_UPDATED_BY
               ,LAST_UPDATE_DATE
               --,ATTRIBUTE9
               --,ATTRIBUTE10
               )
        SELECT V_DIVISION_ID
              ,P_PLAN_START_YYYYMMDD
              ,V_SCP_PLAN_TYPE
              ,V_SCP_PLAN_SEQ
              ,IA.OPERATION_GROUP
              ,IA.PROJECT_CODE
              ,IA.ITEM_ID
              ,IA.TO_SITE
              ,IA.INCOTERMS
              ,IA.FROM_SITE
              ,IA.BOD_ID
              ,IA.MEASURE
              ,IA.YYYYMMDD
              ,IA.QTY
              ,IA.ORIGIN_FROM_DIVISION_ID
              ,IA.ORIGIN_TO_DIVISION_ID
              ,IA.ELECTRODE_TYPE
              ,V_UPDATE_NAME
              ,V_NOW_DATE
              ,V_UPDATE_NAME
              ,V_NOW_DATE
              --,'I'
              --,CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
          FROM (SELECT A.OPERATION_GROUP
                      ,A.PROJECT_CODE
                      ,A.ITEM_ID
                      ,A.TO_SITE
                      ,A.INCOTERMS
                      ,A.FROM_SITE
                      ,A.BOD_ID
                      ,A.MEASURE
                      ,A.YYYYMMDD
                      ,A.QTY
                      ,A.ORIGIN_FROM_DIVISION_ID
                      ,A.ORIGIN_TO_DIVISION_ID
                      ,A.ELECTRODE_TYPE
                  FROM GT_TASM_OS_RESULT_FG A
                 WHERE A.PROJECT_CODE != '/'
               ) IA
         WHERE NOT EXISTS (SELECT 1
                             FROM SCP_ANL_SHIPMENT_PLAN_FG B
                            WHERE B.BIZ_TYPE            = IA.OPERATION_GROUP
                              AND B.PROJECT_CODE        = IA.PROJECT_CODE
                              AND B.ITEM_ID             = IA.ITEM_ID
                              AND B.TO_SITE             = IA.TO_SITE
                              AND B.INCOTERMS           = IA.INCOTERMS
                              AND B.FROM_SITE           = IA.FROM_SITE
                              AND B.BOD_ID              = IA.BOD_ID
                              AND B.MEASURE             = IA.MEASURE
                              AND B.YYYYMMDD            = IA.YYYYMMDD
                              AND B.DIVISION_ID         = V_DIVISION_ID
                              AND B.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                              AND B.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
                              AND B.PLAN_TYPE           = V_SCP_PLAN_TYPE
                              AND B.SEQ                 = V_SCP_PLAN_SEQ
                          );
        ------------------------------------------------------------------------
        -- 2-2. 엔진 결과에서 프로젝트 코드가 없는('-') 대상은 찾아서 넣어야 함
        -- FG에  PROJECT가 한개인 것 MERGE INTO
        -- 프로젝트가 한 개 라면, 그 프로젝트를 찾아서 INSERT 하기위해
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_SHIPMENT_PLAN_FG A
           SET (A.QTY
               ,A.LAST_UPDATE_DATE
               ,A.LAST_UPDATED_BY
                      --,ANL.ATTRIBUTE9       = 'U'
                      --,ANL.ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
               ) = (SELECT IA.QTY
                          ,V_NOW_DATE
                          ,V_UPDATE_NAME
                      FROM (SELECT B.OPERATION_GROUP
                                  ,C.PROJECT_CODE
                                  ,B.ITEM_ID
                                  ,B.TO_SITE
                                  ,B.INCOTERMS
                                  ,B.FROM_SITE
                                  ,B.BOD_ID
                                  ,B.MEASURE
                                  ,B.YYYYMMDD
                                  ,B.QTY
                                  ,B.ORIGIN_FROM_DIVISION_ID
                                  ,B.ORIGIN_TO_DIVISION_ID
                                  ,B.ELECTRODE_TYPE
                              FROM GT_TASM_OS_RESULT_FG B
                                  ,GT_TASM_OS_RESULT_FG_SMMR C
                             WHERE B.ITEM_ID      = C.ITEM_ID
                               AND B.BOD_ID       = C.BOD_ID
                               AND B.PROJECT_CODE = '/'
                           ) IA
                     WHERE A.BIZ_TYPE     = IA.OPERATION_GROUP
                       AND A.PROJECT_CODE = IA.PROJECT_CODE
                       AND A.ITEM_ID      = IA.ITEM_ID
                       AND A.TO_SITE      = IA.TO_SITE
                       AND A.INCOTERMS    = IA.INCOTERMS
                       AND A.FROM_SITE    = IA.FROM_SITE
                       AND A.BOD_ID       = IA.BOD_ID
                       AND A.MEASURE      = IA.MEASURE
                       AND A.YYYYMMDD     = IA.YYYYMMDD
                       AND ROWNUM = 1
                   )
         WHERE EXISTS (SELECT 1
                         FROM (SELECT D.OPERATION_GROUP
                                     ,E.PROJECT_CODE
                                     ,D.ITEM_ID
                                     ,D.TO_SITE
                                     ,D.INCOTERMS
                                     ,D.FROM_SITE
                                     ,D.BOD_ID
                                     ,D.MEASURE
                                     ,D.YYYYMMDD
                                     ,D.QTY
                                     ,D.ORIGIN_FROM_DIVISION_ID
                                     ,D.ORIGIN_TO_DIVISION_ID
                                     ,D.ELECTRODE_TYPE
                                 FROM GT_TASM_OS_RESULT_FG D
                                     ,GT_TASM_OS_RESULT_FG_SMMR E
                                WHERE D.ITEM_ID      = E.ITEM_ID
                                  AND D.BOD_ID       = E.BOD_ID
                                  AND D.PROJECT_CODE = '/'
                              ) XA
                        WHERE A.BIZ_TYPE     = XA.OPERATION_GROUP
                          AND A.PROJECT_CODE = XA.PROJECT_CODE
                          AND A.ITEM_ID      = XA.ITEM_ID
                          AND A.TO_SITE      = XA.TO_SITE
                          AND A.INCOTERMS    = XA.INCOTERMS
                          AND A.FROM_SITE    = XA.FROM_SITE
                          AND A.BOD_ID       = XA.BOD_ID
                          AND A.MEASURE      = XA.MEASURE
                          AND A.YYYYMMDD     = XA.YYYYMMDD
                      )
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND A.PLAN_TYPE           = V_SCP_PLAN_TYPE
           AND A.SEQ                 = V_SCP_PLAN_SEQ;

        INSERT INTO SCP_ANL_SHIPMENT_PLAN_FG
              (DIVISION_ID
               ,PLAN_START_YYYYMMDD
               ,PLAN_TYPE
               ,SEQ
               ,BIZ_TYPE
               ,PROJECT_CODE
               ,ITEM_ID
               ,TO_SITE
               ,INCOTERMS
               ,FROM_SITE
               ,BOD_ID
               ,MEASURE
               ,YYYYMMDD
               ,QTY
               ,ORIGIN_FROM_DIVISION_ID
               ,ORIGIN_TO_DIVISION_ID
               ,ELECTRODE_TYPE
               ,CREATED_BY
               ,CREATION_DATE
               ,LAST_UPDATED_BY
               ,LAST_UPDATE_DATE
               --,ATTRIBUTE9
               --,ATTRIBUTE10
               )
        SELECT V_DIVISION_ID
              ,P_PLAN_START_YYYYMMDD
              ,V_SCP_PLAN_TYPE
              ,V_SCP_PLAN_SEQ
              ,IA.OPERATION_GROUP
              ,IA.PROJECT_CODE    --OSF를 만들 때 하나인 프로젝트 코드를 찾았음
              ,IA.ITEM_ID
              ,IA.TO_SITE
              ,IA.INCOTERMS
              ,IA.FROM_SITE
              ,IA.BOD_ID
              ,IA.MEASURE
              ,IA.YYYYMMDD
              ,IA.QTY
              ,IA.ORIGIN_FROM_DIVISION_ID
              ,IA.ORIGIN_TO_DIVISION_ID
              ,IA.ELECTRODE_TYPE
              ,V_UPDATE_NAME
              ,V_NOW_DATE
              ,V_UPDATE_NAME
              ,V_NOW_DATE
              --,'I'
              --,CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
          FROM (SELECT A.OPERATION_GROUP
                      ,B.PROJECT_CODE
                      ,A.ITEM_ID
                      ,A.TO_SITE
                      ,A.INCOTERMS
                      ,A.FROM_SITE
                      ,A.BOD_ID
                      ,A.MEASURE
                      ,A.YYYYMMDD
                      ,A.QTY
                      ,A.ORIGIN_FROM_DIVISION_ID
                      ,A.ORIGIN_TO_DIVISION_ID
                      ,A.ELECTRODE_TYPE
                  FROM GT_TASM_OS_RESULT_FG A
                      ,GT_TASM_OS_RESULT_FG_SMMR B
                 WHERE A.ITEM_ID      = B.ITEM_ID
                   AND A.BOD_ID       = B.BOD_ID
                   AND A.PROJECT_CODE = '/'
               ) IA
         WHERE NOT EXISTS (SELECT 1
                             FROM SCP_ANL_SHIPMENT_PLAN_FG C
                            WHERE C.BIZ_TYPE            = IA.OPERATION_GROUP
                              AND C.PROJECT_CODE        = IA.PROJECT_CODE
                              AND C.ITEM_ID             = IA.ITEM_ID
                              AND C.TO_SITE             = IA.TO_SITE
                              AND C.INCOTERMS           = IA.INCOTERMS
                              AND C.FROM_SITE           = IA.FROM_SITE
                              AND C.BOD_ID              = IA.BOD_ID
                              AND C.MEASURE             = IA.MEASURE
                              AND C.YYYYMMDD            = IA.YYYYMMDD
                              AND C.DIVISION_ID         = V_DIVISION_ID
                              AND C.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                              AND C.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
                              AND C.PLAN_TYPE           = V_SCP_PLAN_TYPE
                              AND C.SEQ                 = V_SCP_PLAN_SEQ
                          );

        ------------------------------------------------------------------------
        -- 2-3. FG에 프로젝트가 여러개인 애들 MERGE INTO
        -- Project Code가 -로 등록되어있으면 update, 아니면 Project Code를 -로 insert
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_SHIPMENT_PLAN_FG A
           SET (A.QTY
               ,A.LAST_UPDATE_DATE
               ,A.LAST_UPDATED_BY
                      --,ANL.ATTRIBUTE9       = 'U'
                      --,ANL.ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
               ) = (SELECT IA.QTY
                          ,V_NOW_DATE
                          ,V_UPDATE_NAME
                      FROM (SELECT B.OPERATION_GROUP
                                  ,B.PROJECT_CODE
                                  ,B.ITEM_ID
                                  ,B.TO_SITE
                                  ,B.INCOTERMS
                                  ,B.FROM_SITE
                                  ,B.BOD_ID
                                  ,B.MEASURE
                                  ,B.YYYYMMDD
                                  ,B.QTY
                                  ,B.ORIGIN_FROM_DIVISION_ID
                                  ,B.ORIGIN_TO_DIVISION_ID
                                  ,B.ELECTRODE_TYPE
                              FROM GT_TASM_OS_RESULT_FG B
                                  ,GT_TASM_OS_RESULT_FG_SMMR C
                             WHERE B.ITEM_ID      = C.ITEM_ID(+)
                               AND B.BOD_ID       = C.BOD_ID(+)
                               AND C.ITEM_ID IS NULL
                               AND B.PROJECT_CODE = '/'
                           ) IA
                     WHERE A.BIZ_TYPE     = IA.OPERATION_GROUP
                       AND A.PROJECT_CODE = IA.PROJECT_CODE
                       AND A.ITEM_ID      = IA.ITEM_ID
                       AND A.TO_SITE      = IA.TO_SITE
                       AND A.INCOTERMS    = IA.INCOTERMS
                       AND A.FROM_SITE    = IA.FROM_SITE
                       AND A.BOD_ID       = IA.BOD_ID
                       AND A.MEASURE      = IA.MEASURE
                       AND A.YYYYMMDD     = IA.YYYYMMDD
                       AND ROWNUM = 1
                   )
         WHERE EXISTS (SELECT 1
                         FROM (SELECT D.OPERATION_GROUP
                                     ,D.PROJECT_CODE
                                     ,D.ITEM_ID
                                     ,D.TO_SITE
                                     ,D.INCOTERMS
                                     ,D.FROM_SITE
                                     ,D.BOD_ID
                                     ,D.MEASURE
                                     ,D.YYYYMMDD
                                     ,D.QTY
                                     ,D.ORIGIN_FROM_DIVISION_ID
                                     ,D.ORIGIN_TO_DIVISION_ID
                                     ,D.ELECTRODE_TYPE
                                 FROM GT_TASM_OS_RESULT_FG D
                                     ,GT_TASM_OS_RESULT_FG_SMMR E
                                WHERE D.ITEM_ID      = E.ITEM_ID(+)
                                  AND D.BOD_ID       = E.BOD_ID(+)
                                  AND E.ITEM_ID IS NULL
                                  AND D.PROJECT_CODE = '/'
                              ) XA
                        WHERE A.BIZ_TYPE     = XA.OPERATION_GROUP
                          AND A.PROJECT_CODE = XA.PROJECT_CODE
                          AND A.ITEM_ID      = XA.ITEM_ID
                          AND A.TO_SITE      = XA.TO_SITE
                          AND A.INCOTERMS    = XA.INCOTERMS
                          AND A.FROM_SITE    = XA.FROM_SITE
                          AND A.BOD_ID       = XA.BOD_ID
                          AND A.MEASURE      = XA.MEASURE
                          AND A.YYYYMMDD     = XA.YYYYMMDD
                      )
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND A.PLAN_TYPE           = V_SCP_PLAN_TYPE
           AND A.SEQ                 = V_SCP_PLAN_SEQ;

        INSERT INTO SCP_ANL_SHIPMENT_PLAN_FG
              (DIVISION_ID
               ,PLAN_START_YYYYMMDD
               ,PLAN_TYPE
               ,SEQ
               ,BIZ_TYPE
               ,PROJECT_CODE
               ,ITEM_ID
               ,TO_SITE
               ,INCOTERMS
               ,FROM_SITE
               ,BOD_ID
               ,MEASURE
               ,YYYYMMDD
               ,QTY
               ,ORIGIN_FROM_DIVISION_ID
               ,ORIGIN_TO_DIVISION_ID
               ,ELECTRODE_TYPE
               ,CREATED_BY
               ,CREATION_DATE
               ,LAST_UPDATED_BY
               ,LAST_UPDATE_DATE
               --,ATTRIBUTE9
               --,ATTRIBUTE10
               )
        SELECT V_DIVISION_ID
              ,P_PLAN_START_YYYYMMDD
              ,V_SCP_PLAN_TYPE
              ,V_SCP_PLAN_SEQ
              ,IA.OPERATION_GROUP
              ,IA.PROJECT_CODE    --OSF를 만들 때 '-'로 넣었음
              ,IA.ITEM_ID
              ,IA.TO_SITE
              ,IA.INCOTERMS
              ,IA.FROM_SITE
              ,IA.BOD_ID
              ,IA.MEASURE
              ,IA.YYYYMMDD
              ,IA.QTY
              ,IA.ORIGIN_FROM_DIVISION_ID
              ,IA.ORIGIN_TO_DIVISION_ID
              ,IA.ELECTRODE_TYPE
              ,V_UPDATE_NAME
              ,V_NOW_DATE
              ,V_UPDATE_NAME
              ,V_NOW_DATE
              --,'I'
              --,CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
          FROM (SELECT A.OPERATION_GROUP
                      ,A.PROJECT_CODE
                      ,A.ITEM_ID
                      ,A.TO_SITE
                      ,A.INCOTERMS
                      ,A.FROM_SITE
                      ,A.BOD_ID
                      ,A.MEASURE
                      ,A.YYYYMMDD
                      ,A.QTY
                      ,A.ORIGIN_FROM_DIVISION_ID
                      ,A.ORIGIN_TO_DIVISION_ID
                      ,A.ELECTRODE_TYPE
                  FROM GT_TASM_OS_RESULT_FG A
                      ,GT_TASM_OS_RESULT_FG_SMMR B
                 WHERE A.ITEM_ID      = B.ITEM_ID(+)
                   AND A.BOD_ID       = B.BOD_ID(+)
                   AND B.ITEM_ID IS NULL
                   AND A.PROJECT_CODE = '/'
               ) IA
         WHERE NOT EXISTS (SELECT 1
                             FROM SCP_ANL_SHIPMENT_PLAN_FG C
                            WHERE C.BIZ_TYPE            = IA.OPERATION_GROUP
                              AND C.PROJECT_CODE        = IA.PROJECT_CODE
                              AND C.ITEM_ID             = IA.ITEM_ID
                              AND C.TO_SITE             = IA.TO_SITE
                              AND C.INCOTERMS           = IA.INCOTERMS
                              AND C.FROM_SITE           = IA.FROM_SITE
                              AND C.BOD_ID              = IA.BOD_ID
                              AND C.MEASURE             = IA.MEASURE
                              AND C.YYYYMMDD            = IA.YYYYMMDD
                              AND C.DIVISION_ID         = V_DIVISION_ID
                              AND C.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                              AND C.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
                              AND C.PLAN_TYPE           = V_SCP_PLAN_TYPE
                              AND C.SEQ                 = V_SCP_PLAN_SEQ
                          );

        ------------------------------------------------------------------------
        -- INSERT HISTORY
        ------------------------------------------------------------------------
        INSERT INTO SCP_ANL_SHIPMENT_PLAN_FG_H
              (HISTORY_SEQ
              ,DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,BIZ_TYPE
              ,PROJECT_CODE
              ,ITEM_ID
              ,TO_SITE
              ,INCOTERMS
              ,FROM_SITE
              ,BOD_ID
              ,MEASURE
              ,YYYYMMDD
              ,QTY
              ,ORIGIN_TO_DIVISION_ID
              ,ORIGIN_FROM_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE7
              ,ATTRIBUTE8
              ,ATTRIBUTE9
              ,ATTRIBUTE10
              ,HISTORY_CREATION_DATE
              )
        SELECT SEQ1_SCP_ANL_SHIPMENT_PLAN_FG_H.NEXTVAL AS HISTORY_SEQ
              ,DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,BIZ_TYPE
              ,PROJECT_CODE
              ,ITEM_ID
              ,TO_SITE
              ,INCOTERMS
              ,FROM_SITE
              ,BOD_ID
              ,MEASURE
              ,YYYYMMDD
              ,QTY
              ,ORIGIN_FROM_DIVISION_ID   /* AS-IS 그대로 : ORIGIN_TO_DIVISION_ID 자리에 ORIGIN_FROM 값 */
              ,ORIGIN_TO_DIVISION_ID     /* AS-IS 그대로 : ORIGIN_FROM_DIVISION_ID 자리에 ORIGIN_TO 값 */
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE7
              ,ATTRIBUTE8
              ,ATTRIBUTE9
              ,ATTRIBUTE10
              ,V_NOW_DATE AS HISTORY_CREATION_DATE
          FROM SCP_ANL_SHIPMENT_PLAN_FG
         WHERE MEASURE IN ('SHIP_PLAN_AMEND')
           AND DIVISION_ID         = V_DIVISION_ID
           AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND PLAN_TYPE           = V_SCP_PLAN_TYPE
           AND SEQ                 = V_SCP_PLAN_SEQ
           AND YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD
           AND LAST_UPDATED_BY     = V_UPDATE_NAME
           AND LAST_UPDATE_DATE    = V_NOW_DATE;
        ------------------------------------------------------------------------
        -- Update SCP_ANL_SHIPMENT_PLAN_FIX QTY
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_SHIPMENT_PLAN_FIX A
           SET (A.QTY
               ,A.LAST_UPDATED_BY
               ,A.LAST_UPDATE_DATE
          --, SCP_ANL_SHIPMENT_PLAN_FIX.ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/UPDATE'
               ) = (SELECT B.QTY
                          ,V_UPDATE_NAME
                          ,V_NOW_DATE
                      FROM GT_TASM_OS_RESULT_FG B
                     WHERE A.BIZ_TYPE     = B.OPERATION_GROUP
                       AND A.ITEM_ID      = B.ITEM_ID
                       AND A.TO_SITE      = B.TO_SITE
                       AND A.FROM_SITE    = B.FROM_SITE
                       AND A.BOD_ID       = B.BOD_ID
                       AND A.YYYYMMDD     = B.YYYYMMDD
                       AND A.PROJECT_CODE = B.PROJECT_CODE
                       AND ROWNUM = 1
                   )
         WHERE EXISTS (SELECT 1
                         FROM GT_TASM_OS_RESULT_FG C
                        WHERE A.BIZ_TYPE     = C.OPERATION_GROUP
                          AND A.ITEM_ID      = C.ITEM_ID
                          AND A.TO_SITE      = C.TO_SITE
                          AND A.FROM_SITE    = C.FROM_SITE
                          AND A.BOD_ID       = C.BOD_ID
                          AND A.YYYYMMDD     = C.YYYYMMDD
                          AND A.PROJECT_CODE = C.PROJECT_CODE
                      )
           AND A.DIVISION_ID = V_DIVISION_ID;
        ------------------------------------------------------------------------
        -- INSERT FIX HISTORY
        ------------------------------------------------------------------------
        INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX_H
              (HISTORY_SEQ
              ,FIX_ID
              ,DIVISION_ID
              ,BIZ_TYPE
              ,ITEM_ID
              ,TO_SITE
              ,FROM_SITE
              ,BOD_ID
              ,YYYYMMDD
              ,PROJECT_CODE
              ,INCOTERMS
              ,QTY
              ,FIX_REASON
              ,ORIGIN_FROM_DIVISION_ID
              ,ORIGIN_TO_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE7
              ,ATTRIBUTE8
              ,ATTRIBUTE9
              ,ATTRIBUTE10
              ,HISTORY_CREATION_DATE
              )
        SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL -- 원본에서 SCP_ANL_SHIPMENT_PLAN_FIX_H의 SEQ를 SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H로 생성 중.
              ,FIX_ID
              ,DIVISION_ID
              ,BIZ_TYPE
              ,ITEM_ID
              ,TO_SITE
              ,FROM_SITE
              ,BOD_ID
              ,YYYYMMDD
              ,PROJECT_CODE
              ,INCOTERMS
              ,QTY
              ,FIX_REASON
              ,ORIGIN_FROM_DIVISION_ID
              ,ORIGIN_TO_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE7
              ,ATTRIBUTE8
              ,ATTRIBUTE9
              ,ATTRIBUTE10
              ,V_NOW_DATE
          FROM SCP_ANL_SHIPMENT_PLAN_FIX
         WHERE DIVISION_ID      = V_DIVISION_ID
           AND YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD
           AND LAST_UPDATED_BY  = V_UPDATE_NAME
           AND LAST_UPDATE_DATE = V_NOW_DATE;

    ------------------------------------------------------------------------
    -- UPDATE SCP_XLS_PSI_GLOBAL
    ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        -- 52주 구간 : 52주 구간과 52주 이후 구간을 나눠서 넣어야 함
        -- Get Daily SCP_ANL_PRODUCTION_PLAN data
        ------------------------------------------------------------------------
        INSERT INTO GT_TASM_XLS_PV_READY
              (TRG_DATE
              ,DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,OPERATION_GROUP
              ,FROM_SITE
              ,ITEM_ID
              ,LINE_ID
              ,BOD_ID
              ,PROJECT_CODE
              ,MEASURE
              ,QTY_SUM
              ,CREATE_FROM_YYYYMMDD
              )
        SELECT XA.TRG_DATE
              ,A.DIVISION_ID
              ,A.PLAN_START_YYYYMMDD
              ,A.PLAN_TYPE
              ,A.SEQ
              ,A.OPERATION_GROUP
              ,A.SCM_SITE_ID
              ,A.ITEM_ID
              ,A.LINE_ID
              ,'-' AS BOD_ID
              ,'/' AS PROJECT_CODE
              ,CASE WHEN A.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
                    WHEN A.OPERATION_GROUP = 'P' THEN 'PACK_PROD'
                    ELSE NULL
               END AS MEASURE
              ,SUM(NVL(A.QTY, 0)) AS QTY_SUM
              ,P_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_WEEKS_IN_YEAR - V_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)), 3, '0') AS TRG_DATE
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN P_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XA
              ,SCP_ANL_PRODUCTION_PLAN A
         WHERE XA.BASIS_YYYYMMDD = A.YYYYMMDD(+)
           AND A.MEASURE             = 'PROD_PLAN_AMEND'
           AND A.QTY                != 0
           AND A.OPERATION_GROUP     = 'A'
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND A.LAST_UPDATED_BY     = V_UPDATE_NAME
           --AND     AP.ATTRIBUTE9          = 'U'
         GROUP BY XA.TRG_DATE
                 ,A.DIVISION_ID
                 ,A.PLAN_START_YYYYMMDD
                 ,A.PLAN_TYPE
                 ,A.SEQ
                 ,A.OPERATION_GROUP
                 ,A.SCM_SITE_ID
                 ,A.ITEM_ID
                 ,A.LINE_ID
        ------------------------------------------------------------------------
        -- Get Weekly SCP_ANL_PRODUCTION_PLAN data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XB.WEEK_NUM AS TRG_DATE
              ,B.DIVISION_ID
              ,B.PLAN_START_YYYYMMDD
              ,B.PLAN_TYPE
              ,B.SEQ
              ,B.OPERATION_GROUP
              ,B.SCM_SITE_ID
              ,B.ITEM_ID
              ,B.LINE_ID
              ,'-' AS BOD_ID
              ,'/' AS PROJECT_CODE
              ,CASE WHEN B.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
                    WHEN B.OPERATION_GROUP = 'P' THEN 'PACK_PROD'
                    ELSE NULL
               END AS MEASURE
              ,SUM(B.QTY) AS QTY_SUM
              ,P_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_WEEKS_IN_YEAR - V_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN P_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XB
              ,SCP_ANL_PRODUCTION_PLAN B
         WHERE XB.BASIS_YYYYMMDD = B.YYYYMMDD(+)
           AND B.MEASURE             = 'PROD_PLAN_AMEND'
           AND B.QTY                != 0
           AND B.OPERATION_GROUP     = 'A'
           AND B.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND B.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND B.LAST_UPDATED_BY     = V_UPDATE_NAME
           --AND     AP.ATTRIBUTE9          = 'U'
         GROUP BY XB.WEEK_NUM
                 ,B.DIVISION_ID
                 ,B.PLAN_START_YYYYMMDD
                 ,B.PLAN_TYPE
                 ,B.SEQ
                 ,B.OPERATION_GROUP
                 ,B.SCM_SITE_ID
                 ,B.ITEM_ID
                 ,B.LINE_ID

        ------------------------------------------------------------------------
        -- Get Daily SCP_ANL_SHIPMENT_PLAN_SEMI data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XC.TRG_DATE
              ,C.DIVISION_ID
              ,C.PLAN_START_YYYYMMDD
              ,C.PLAN_TYPE
              ,C.SEQ
              ,C.OPERATION_GROUP
              ,C.FROM_SITE
              ,C.ITEM_ID
              ,'-' AS LINE_ID
              ,C.BOD_ID
              ,'/' AS PROJECT_CODE
              ,'SEMI_SHIP_PLAN' AS MEASURE
              ,SUM(NVL(C.QTY, 0)) AS QTY_SUM
              ,P_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_WEEKS_IN_YEAR - V_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)), 3, '0') AS TRG_DATE
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN P_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XC
              ,SCP_ANL_SHIPMENT_PLAN_SEMI C
         WHERE XC.BASIS_YYYYMMDD = C.YYYYMMDD(+)
           AND C.MEASURE             = 'SHIP_PLAN_AMEND'
           AND C.QTY                != 0
           AND C.OPERATION_GROUP     = 'A'
           AND C.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND C.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND C.LAST_UPDATED_BY     = V_UPDATE_NAME
           --AND     ASS.ATTRIBUTE9      = 'U'
         GROUP BY XC.TRG_DATE
                 ,C.DIVISION_ID
                 ,C.PLAN_START_YYYYMMDD
                 ,C.PLAN_TYPE
                 ,C.SEQ
                 ,C.OPERATION_GROUP
                 ,C.FROM_SITE
                 ,C.ITEM_ID
                 ,C.BOD_ID
        ------------------------------------------------------------------------
        -- Get Weekly SCP_ANL_SHIPMENT_PLAN_SEMI data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XD.WEEK_NUM AS TRG_DATE
              ,D.DIVISION_ID
              ,D.PLAN_START_YYYYMMDD
              ,D.PLAN_TYPE
              ,D.SEQ
              ,D.OPERATION_GROUP
              ,D.FROM_SITE
              ,D.ITEM_ID
              ,'-' AS LINE_ID
              ,D.BOD_ID
              ,'/' AS PROJECT_CODE
              ,'SEMI_SHIP_PLAN' AS MEASURE
              ,SUM(D.QTY) AS QTY_SUM
              ,P_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_WEEKS_IN_YEAR - V_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN P_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XD
              ,SCP_ANL_SHIPMENT_PLAN_SEMI D
         WHERE XD.BASIS_YYYYMMDD = D.YYYYMMDD(+)
           AND D.MEASURE             = 'SHIP_PLAN_AMEND'
           AND D.QTY                != 0
           AND D.OPERATION_GROUP     = 'A'
           AND D.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND D.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND D.LAST_UPDATED_BY     = V_UPDATE_NAME
           --AND     ASS.ATTRIBUTE9 ='U'
         GROUP BY XD.WEEK_NUM
                 ,D.DIVISION_ID
                 ,D.PLAN_START_YYYYMMDD
                 ,D.PLAN_TYPE
                 ,D.SEQ
                 ,D.OPERATION_GROUP
                 ,D.FROM_SITE
                 ,D.ITEM_ID
                 ,D.BOD_ID
        ------------------------------------------------------------------------
        -- Get Daily SCP_ANL_SHIPMENT_PLAN_FG data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XE.TRG_DATE
              ,E.DIVISION_ID
              ,E.PLAN_START_YYYYMMDD
              ,E.PLAN_TYPE
              ,E.SEQ
              ,E.BIZ_TYPE AS OPERATION_GROUP
              ,E.FROM_SITE
              ,E.ITEM_ID
              ,'-' AS LINE_ID
              ,E.BOD_ID
              ,E.PROJECT_CODE
              ,'SHIP_PLAN' AS MEASURE
              ,SUM(NVL(E.QTY, 0)) AS QTY_SUM
              ,P_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_WEEKS_IN_YEAR - V_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)), 3, '0') AS TRG_DATE
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN P_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XE
              ,SCP_ANL_SHIPMENT_PLAN_FG E
         WHERE XE.BASIS_YYYYMMDD = E.YYYYMMDD(+)
           AND E.MEASURE             = 'SHIP_PLAN_AMEND'
           AND E.QTY                != 0
           AND E.BIZ_TYPE            = 'A'
           AND E.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND E.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND E.LAST_UPDATED_BY     = V_UPDATE_NAME
           --AND     ASF.ATTRIBUTE9 ='U'
         GROUP BY XE.TRG_DATE
                 ,E.DIVISION_ID
                 ,E.PLAN_START_YYYYMMDD
                 ,E.PLAN_TYPE
                 ,E.SEQ
                 ,E.BIZ_TYPE
                 ,E.FROM_SITE
                 ,E.ITEM_ID
                 ,E.BOD_ID
                 ,E.PROJECT_CODE
        ------------------------------------------------------------------------
        -- Get Weekly SCP_ANL_PRODUCTION_PLAN_FG data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XF.WEEK_NUM AS TRG_DATE
              ,F.DIVISION_ID
              ,F.PLAN_START_YYYYMMDD
              ,F.PLAN_TYPE
              ,F.SEQ
              ,F.BIZ_TYPE AS OPERATION_GROUP
              ,F.FROM_SITE
              ,F.ITEM_ID
              ,'-' AS LINE_ID
              ,F.BOD_ID
              ,F.PROJECT_CODE
              ,'SHIP_PLAN' AS MEASURE
              ,SUM(F.QTY) AS QTY_SUM
              ,P_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_WEEKS_IN_YEAR - V_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN P_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XF
              ,SCP_ANL_SHIPMENT_PLAN_FG F
         WHERE XF.BASIS_YYYYMMDD = F.YYYYMMDD(+)
           AND F.MEASURE             = 'SHIP_PLAN_AMEND'
           AND F.QTY                != 0
           AND F.BIZ_TYPE            = 'A'
           AND F.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND F.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND F.LAST_UPDATED_BY     = V_UPDATE_NAME
           --AND     ASF.ATTRIBUTE9 ='U'
         GROUP BY XF.WEEK_NUM
                 ,F.DIVISION_ID
                 ,F.PLAN_START_YYYYMMDD
                 ,F.PLAN_TYPE
                 ,F.SEQ
                 ,F.BIZ_TYPE
                 ,F.FROM_SITE
                 ,F.ITEM_ID
                 ,F.BOD_ID
                 ,F.PROJECT_CODE
        ------------------------------------------------------------------------
        -- Get Daily CHAR data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XG.TRG_DATE
              ,SA.DIVISION_ID
              ,SA.PLAN_START_YYYYMMDD
              ,SA.PLAN_TYPE
              ,SA.SEQ
              ,SA.OPERATION_GROUP
              ,SA.FROM_SITE
              ,SC.ITEM_ID_ASSY AS ITEM_ID
              ,'-' AS LINE_ID
              ,'-' AS BOD_ID
              ,'/' AS PROJECT_CODE
              ,'CELL_CHAR_PLAN' AS MEASURE
              ,SUM(CAST(SA.QTY AS NUMBER(20,10))) AS QTY_SUM
              ,P_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_WEEKS_IN_YEAR - V_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)), 3, '0') AS TRG_DATE
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN P_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XG
              ,(SELECT V_DIVISION_ID         AS DIVISION_ID
                      ,P_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                      ,V_SCP_PLAN_TYPE       AS PLAN_TYPE
                      ,TO_NUMBER(V_SCP_PLAN_SEQ) AS SEQ /* UNION 다른 가지가 숫자라 AS-IS 도 숫자로 변환 */
                      ,L.OPERATION_GROUP
                      ,K.SITE_ID            AS FROM_SITE
                      ,K.ITEM_ID
                      ,K.GRADE
                      ,K.START_DATE         AS YYYYMMDD
                      ,K.OUT_QTY_INT        AS QTY
                  FROM SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT_SN K
                      ,SCP_MST_FINAL_ITEM L
                 WHERE L.ITEM_ID         = K.ITEM_ID
                   AND K.GRADE IN ('CHAR')
                   AND L.OPERATION_GROUP = 'A'
                   AND L.DIVISION_ID     = V_DIVISION_ID
                   AND K.PLAN_ID         = V_PLAN_ID
               ) SA
              ,(SELECT DISTINCT ITEM_ID_PROD
                      ,ITEM_ID_ASSY
                  FROM SCP_MST_CELL_PROD_ASSY_MAP
                 WHERE CELL_TYPE   = 'CA1'
                   AND DIVISION_ID = V_DIVISION_ID
               ) SC
         WHERE XG.BASIS_YYYYMMDD = SA.YYYYMMDD(+)
           AND SA.ITEM_ID        = SC.ITEM_ID_PROD
           AND CAST(SA.QTY AS NUMBER(20,10)) != 0
         GROUP BY XG.TRG_DATE
                 ,SA.DIVISION_ID
                 ,SA.PLAN_START_YYYYMMDD
                 ,SA.PLAN_TYPE
                 ,SA.SEQ
                 ,SA.OPERATION_GROUP
                 ,SA.FROM_SITE
                 ,SC.ITEM_ID_ASSY
        ------------------------------------------------------------------------
        -- Get Weekly CHAR data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XH.WEEK_NUM AS TRG_DATE
              ,SB.DIVISION_ID
              ,SB.PLAN_START_YYYYMMDD
              ,SB.PLAN_TYPE
              ,SB.SEQ
              ,SB.OPERATION_GROUP
              ,SB.FROM_SITE
              ,SD.ITEM_ID_ASSY AS ITEM_ID
              ,'-' AS LINE_ID
              ,'-' AS BOD_ID
              ,'/' AS PROJECT_CODE
              ,'CELL_CHAR_PLAN' AS MEASURE
              ,SUM(CAST(SB.QTY AS NUMBER(20,10))) AS QTY_SUM
              ,P_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_WEEKS_IN_YEAR - V_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN P_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XH
              ,(SELECT V_DIVISION_ID         AS DIVISION_ID
                      ,P_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                      ,V_SCP_PLAN_TYPE       AS PLAN_TYPE
                      ,TO_NUMBER(V_SCP_PLAN_SEQ) AS SEQ /* UNION 다른 가지가 숫자라 AS-IS 도 숫자로 변환 */
                      ,N.OPERATION_GROUP
                      ,M.SITE_ID            AS FROM_SITE
                      ,M.ITEM_ID
                      ,M.GRADE
                      ,M.START_DATE         AS YYYYMMDD
                      ,M.OUT_QTY_INT        AS QTY
                  FROM SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT_SN M
                      ,SCP_MST_FINAL_ITEM N
                 WHERE N.ITEM_ID         = M.ITEM_ID
                   AND M.GRADE IN ('CHAR')
                   AND N.OPERATION_GROUP = 'A'
                   AND N.DIVISION_ID     = V_DIVISION_ID
                   AND M.PLAN_ID         = V_PLAN_ID
               ) SB
              ,(SELECT DISTINCT ITEM_ID_PROD
                      ,ITEM_ID_ASSY
                  FROM SCP_MST_CELL_PROD_ASSY_MAP
                 WHERE CELL_TYPE   = 'CA1'
                   AND DIVISION_ID = V_DIVISION_ID
               ) SD
         WHERE XH.BASIS_YYYYMMDD = SB.YYYYMMDD(+)
           AND SB.ITEM_ID        = SD.ITEM_ID_PROD
           AND CAST(SB.QTY AS NUMBER(20,10)) != 0
         GROUP BY XH.WEEK_NUM
                 ,SB.DIVISION_ID
                 ,SB.PLAN_START_YYYYMMDD
                 ,SB.PLAN_TYPE
                 ,SB.SEQ
                 ,SB.OPERATION_GROUP
                 ,SB.FROM_SITE
                 ,SD.ITEM_ID_ASSY
        ------------------------------------------------------------------------
        -- Get Daily SCP_ANL_SHIPMENT_PLAN_SEMI data
        -- SCP_XLS_PSI_GLOBAL_SMALL_PACK 테이블의 CELL_SHIP_PLAN MEASURE 추가
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XI.TRG_DATE
              ,I.DIVISION_ID
              ,I.PLAN_START_YYYYMMDD
              ,I.PLAN_TYPE
              ,I.SEQ
              ,I.OPERATION_GROUP
              ,I.FROM_SITE
              ,I.ITEM_ID
              ,'-' AS LINE_ID
              ,I.BOD_ID
              ,'/' AS PROJECT_CODE
              ,'CELL_SHIP_PLAN' AS MEASURE
              ,SUM(NVL(I.QTY, 0)) AS QTY_SUM
              ,P_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_WEEKS_IN_YEAR - V_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)), 3, '0') AS TRG_DATE
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN P_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XI
              ,SCP_ANL_SHIPMENT_PLAN_SEMI I
         WHERE XI.BASIS_YYYYMMDD = I.YYYYMMDD(+)
           AND I.MEASURE             = 'SHIP_PLAN_AMEND'
           AND I.QTY                != 0
           AND I.OPERATION_GROUP     = 'A'
           AND I.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND I.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND I.LAST_UPDATED_BY     = V_UPDATE_NAME
           --AND     ASS.ATTRIBUTE9      = 'U'
         GROUP BY XI.TRG_DATE
                 ,I.DIVISION_ID
                 ,I.PLAN_START_YYYYMMDD
                 ,I.PLAN_TYPE
                 ,I.SEQ
                 ,I.OPERATION_GROUP
                 ,I.FROM_SITE
                 ,I.ITEM_ID
                 ,I.BOD_ID
        ------------------------------------------------------------------------
        -- Get Weekly SCP_ANL_SHIPMENT_PLAN_SEMI data
        -- SCP_XLS_PSI_GLOBAL_SMALL_PACK 테이블의 CELL_SHIP_PLAN MEASURE 추가
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XJ.WEEK_NUM AS TRG_DATE
              ,J.DIVISION_ID
              ,J.PLAN_START_YYYYMMDD
              ,J.PLAN_TYPE
              ,J.SEQ
              ,J.OPERATION_GROUP
              ,J.FROM_SITE
              ,J.ITEM_ID
              ,'-' AS LINE_ID
              ,J.BOD_ID
              ,'/' AS PROJECT_CODE
              ,'CELL_SHIP_PLAN' AS MEASURE
              ,SUM(J.QTY) AS QTY_SUM
              ,P_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_WEEKS_IN_YEAR - V_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN P_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XJ
              ,SCP_ANL_SHIPMENT_PLAN_SEMI J
         WHERE XJ.BASIS_YYYYMMDD = J.YYYYMMDD(+)
           AND J.MEASURE             = 'SHIP_PLAN_AMEND'
           AND J.QTY                != 0
           AND J.OPERATION_GROUP     = 'A'
           AND J.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND J.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND J.LAST_UPDATED_BY     = V_UPDATE_NAME
           --AND     ASS.ATTRIBUTE9 ='U'
         GROUP BY XJ.WEEK_NUM
                 ,J.DIVISION_ID
                 ,J.PLAN_START_YYYYMMDD
                 ,J.PLAN_TYPE
                 ,J.SEQ
                 ,J.OPERATION_GROUP
                 ,J.FROM_SITE
                 ,J.ITEM_ID
                 ,J.BOD_ID;
        ------------------------------------------------------------------------
        -- 52주 이후 구간 : 52주 구간과 52주 이후 구간을 나눠서 넣어야 함
        -- Get Daily SCP_ANL_PRODUCTION_PLAN data
        ------------------------------------------------------------------------
        INSERT INTO GT_TASM_XLS_PV_READY
              (TRG_DATE
              ,DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,OPERATION_GROUP
              ,FROM_SITE
              ,ITEM_ID
              ,LINE_ID
              ,BOD_ID
              ,PROJECT_CODE
              ,MEASURE
              ,QTY_SUM
              ,CREATE_FROM_YYYYMMDD
              )
        SELECT XA.TRG_DATE
              ,A.DIVISION_ID
              ,A.PLAN_START_YYYYMMDD
              ,A.PLAN_TYPE
              ,A.SEQ
              ,A.OPERATION_GROUP
              ,A.SCM_SITE_ID
              ,A.ITEM_ID
              ,A.LINE_ID
              ,'-' AS BOD_ID
              ,'/' AS PROJECT_CODE
              ,CASE WHEN A.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
                    WHEN A.OPERATION_GROUP = 'P' THEN 'PACK_PROD'
                    ELSE NULL
               END AS MEASURE
              ,SUM(NVL(A.QTY, 0)) AS QTY_SUM
              ,V_2ND_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_2ND_WEEKS_IN_YEAR - V_2ND_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)), 3, '0') AS TRG_DATE
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN V_2ND_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(V_2ND_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XA
              ,SCP_ANL_PRODUCTION_PLAN A
         WHERE XA.BASIS_YYYYMMDD = A.YYYYMMDD(+)
           AND A.MEASURE             = 'PROD_PLAN_AMEND'
           AND A.QTY                != 0
           AND A.OPERATION_GROUP     = 'A'
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND A.LAST_UPDATED_BY     = V_UPDATE_NAME
           --AND     AP.ATTRIBUTE9          = 'U'
         GROUP BY XA.TRG_DATE
                 ,A.DIVISION_ID
                 ,A.PLAN_START_YYYYMMDD
                 ,A.PLAN_TYPE
                 ,A.SEQ
                 ,A.OPERATION_GROUP
                 ,A.SCM_SITE_ID
                 ,A.ITEM_ID
                 ,A.LINE_ID
        ------------------------------------------------------------------------
        -- Get Weekly SCP_ANL_PRODUCTION_PLAN data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XB.WEEK_NUM AS TRG_DATE
              ,B.DIVISION_ID
              ,B.PLAN_START_YYYYMMDD
              ,B.PLAN_TYPE
              ,B.SEQ
              ,B.OPERATION_GROUP
              ,B.SCM_SITE_ID
              ,B.ITEM_ID
              ,B.LINE_ID
              ,'-' AS BOD_ID
              ,'/' AS PROJECT_CODE
              ,CASE WHEN B.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
                    WHEN B.OPERATION_GROUP = 'P' THEN 'PACK_PROD'
                    ELSE NULL
               END AS MEASURE
              ,SUM(B.QTY) AS QTY_SUM
              ,V_2ND_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_2ND_WEEKS_IN_YEAR - V_2ND_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN V_2ND_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(V_2ND_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XB
              ,SCP_ANL_PRODUCTION_PLAN B
         WHERE XB.BASIS_YYYYMMDD = B.YYYYMMDD(+)
           AND B.MEASURE             = 'PROD_PLAN_AMEND'
           AND B.QTY                != 0
           AND B.OPERATION_GROUP     = 'A'
           AND B.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND B.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND B.LAST_UPDATED_BY     = V_UPDATE_NAME
           --AND     AP.ATTRIBUTE9          = 'U'
         GROUP BY XB.WEEK_NUM
                 ,B.DIVISION_ID
                 ,B.PLAN_START_YYYYMMDD
                 ,B.PLAN_TYPE
                 ,B.SEQ
                 ,B.OPERATION_GROUP
                 ,B.SCM_SITE_ID
                 ,B.ITEM_ID
                 ,B.LINE_ID

        ------------------------------------------------------------------------
        -- Get Daily SCP_ANL_SHIPMENT_PLAN_SEMI data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XC.TRG_DATE
              ,C.DIVISION_ID
              ,C.PLAN_START_YYYYMMDD
              ,C.PLAN_TYPE
              ,C.SEQ
              ,C.OPERATION_GROUP
              ,C.FROM_SITE
              ,C.ITEM_ID
              ,'-' AS LINE_ID
              ,C.BOD_ID
              ,'/' AS PROJECT_CODE
              ,'SEMI_SHIP_PLAN' AS MEASURE
              ,SUM(NVL(C.QTY, 0)) AS QTY_SUM
              ,V_2ND_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_2ND_WEEKS_IN_YEAR - V_2ND_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)), 3, '0') AS TRG_DATE
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN V_2ND_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(V_2ND_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XC
              ,SCP_ANL_SHIPMENT_PLAN_SEMI C
         WHERE XC.BASIS_YYYYMMDD = C.YYYYMMDD(+)
           AND C.MEASURE             = 'SHIP_PLAN_AMEND'
           AND C.QTY                != 0
           AND C.OPERATION_GROUP     = 'A'
           AND C.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND C.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND C.LAST_UPDATED_BY     = V_UPDATE_NAME
           --AND     ASS.ATTRIBUTE9      = 'U'
         GROUP BY XC.TRG_DATE
                 ,C.DIVISION_ID
                 ,C.PLAN_START_YYYYMMDD
                 ,C.PLAN_TYPE
                 ,C.SEQ
                 ,C.OPERATION_GROUP
                 ,C.FROM_SITE
                 ,C.ITEM_ID
                 ,C.BOD_ID
        ------------------------------------------------------------------------
        -- Get Weekly SCP_ANL_SHIPMENT_PLAN_SEMI data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XD.WEEK_NUM AS TRG_DATE
              ,D.DIVISION_ID
              ,D.PLAN_START_YYYYMMDD
              ,D.PLAN_TYPE
              ,D.SEQ
              ,D.OPERATION_GROUP
              ,D.FROM_SITE
              ,D.ITEM_ID
              ,'-' AS LINE_ID
              ,D.BOD_ID
              ,'/' AS PROJECT_CODE
              ,'SEMI_SHIP_PLAN' AS MEASURE
              ,SUM(D.QTY) AS QTY_SUM
              ,V_2ND_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_2ND_WEEKS_IN_YEAR - V_2ND_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN V_2ND_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(V_2ND_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XD
              ,SCP_ANL_SHIPMENT_PLAN_SEMI D
         WHERE XD.BASIS_YYYYMMDD = D.YYYYMMDD(+)
           AND D.MEASURE             = 'SHIP_PLAN_AMEND'
           AND D.QTY                != 0
           AND D.OPERATION_GROUP     = 'A'
           AND D.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND D.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND D.LAST_UPDATED_BY     = V_UPDATE_NAME
           --AND     ASS.ATTRIBUTE9 ='U'
         GROUP BY XD.WEEK_NUM
                 ,D.DIVISION_ID
                 ,D.PLAN_START_YYYYMMDD
                 ,D.PLAN_TYPE
                 ,D.SEQ
                 ,D.OPERATION_GROUP
                 ,D.FROM_SITE
                 ,D.ITEM_ID
                 ,D.BOD_ID
        ------------------------------------------------------------------------
        -- Get Daily SCP_ANL_SHIPMENT_PLAN_FG data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XE.TRG_DATE
              ,E.DIVISION_ID
              ,E.PLAN_START_YYYYMMDD
              ,E.PLAN_TYPE
              ,E.SEQ
              ,E.BIZ_TYPE AS OPERATION_GROUP
              ,E.FROM_SITE
              ,E.ITEM_ID
              ,'-' AS LINE_ID
              ,E.BOD_ID
              ,E.PROJECT_CODE
              ,'SHIP_PLAN' AS MEASURE
              ,SUM(NVL(E.QTY, 0)) AS QTY_SUM
              ,V_2ND_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_2ND_WEEKS_IN_YEAR - V_2ND_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)), 3, '0') AS TRG_DATE
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN V_2ND_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(V_2ND_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XE
              ,SCP_ANL_SHIPMENT_PLAN_FG E
         WHERE XE.BASIS_YYYYMMDD = E.YYYYMMDD(+)
           AND E.MEASURE             = 'SHIP_PLAN_AMEND'
           AND E.QTY                != 0
           AND E.BIZ_TYPE            = 'A'
           AND E.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND E.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND E.LAST_UPDATED_BY     = V_UPDATE_NAME
           --AND     ASF.ATTRIBUTE9 ='U'
         GROUP BY XE.TRG_DATE
                 ,E.DIVISION_ID
                 ,E.PLAN_START_YYYYMMDD
                 ,E.PLAN_TYPE
                 ,E.SEQ
                 ,E.BIZ_TYPE
                 ,E.FROM_SITE
                 ,E.ITEM_ID
                 ,E.BOD_ID
                 ,E.PROJECT_CODE
        ------------------------------------------------------------------------
        -- Get Weekly SCP_ANL_SHIPMENT_PLAN_FG data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XF.WEEK_NUM AS TRG_DATE
              ,F.DIVISION_ID
              ,F.PLAN_START_YYYYMMDD
              ,F.PLAN_TYPE
              ,F.SEQ
              ,F.BIZ_TYPE AS OPERATION_GROUP
              ,F.FROM_SITE
              ,F.ITEM_ID
              ,'-' AS LINE_ID
              ,F.BOD_ID
              ,F.PROJECT_CODE
              ,'SHIP_PLAN' AS MEASURE
              ,SUM(F.QTY) AS QTY_SUM
              ,V_2ND_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_2ND_WEEKS_IN_YEAR - V_2ND_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN V_2ND_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(V_2ND_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XF
              ,SCP_ANL_SHIPMENT_PLAN_FG F
         WHERE XF.BASIS_YYYYMMDD = F.YYYYMMDD(+)
           AND F.MEASURE             = 'SHIP_PLAN_AMEND'
           AND F.QTY                != 0
           AND F.BIZ_TYPE            = 'A'
           AND F.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND F.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND F.LAST_UPDATED_BY     = V_UPDATE_NAME
           --AND     ASF.ATTRIBUTE9 ='U'
         GROUP BY XF.WEEK_NUM
                 ,F.DIVISION_ID
                 ,F.PLAN_START_YYYYMMDD
                 ,F.PLAN_TYPE
                 ,F.SEQ
                 ,F.BIZ_TYPE
                 ,F.FROM_SITE
                 ,F.ITEM_ID
                 ,F.BOD_ID
                 ,F.PROJECT_CODE
        ------------------------------------------------------------------------
        -- Get Daily CHAR data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XG.TRG_DATE
              ,SA.DIVISION_ID
              ,SA.PLAN_START_YYYYMMDD
              ,SA.PLAN_TYPE
              ,SA.SEQ
              ,SA.OPERATION_GROUP
              ,SA.FROM_SITE
              ,SC.ITEM_ID_ASSY AS ITEM_ID
              ,'-' AS LINE_ID
              ,'-' AS BOD_ID
              ,'/' AS PROJECT_CODE
              ,'CELL_CHAR_PLAN' AS MEASURE
              ,SUM(CAST(SA.QTY AS NUMBER(20,10))) AS QTY_SUM
              ,V_2ND_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_2ND_WEEKS_IN_YEAR - V_2ND_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)), 3, '0') AS TRG_DATE
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN V_2ND_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(V_2ND_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XG
              ,(SELECT V_DIVISION_ID         AS DIVISION_ID
                      ,P_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                      ,V_SCP_PLAN_TYPE       AS PLAN_TYPE
                      ,TO_NUMBER(V_SCP_PLAN_SEQ) AS SEQ /* UNION 다른 가지가 숫자라 AS-IS 도 숫자로 변환 */
                      ,L.OPERATION_GROUP
                      ,K.SITE_ID            AS FROM_SITE
                      ,K.ITEM_ID
                      ,K.GRADE
                      ,K.START_DATE         AS YYYYMMDD
                      ,K.OUT_QTY_INT        AS QTY
                  FROM SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT_SN K
                      ,SCP_MST_FINAL_ITEM L
                 WHERE L.ITEM_ID         = K.ITEM_ID
                   AND K.GRADE IN ('CHAR')
                   AND L.OPERATION_GROUP = 'A'
                   AND L.DIVISION_ID     = V_DIVISION_ID
                   AND K.PLAN_ID         = V_PLAN_ID
               ) SA
              ,(SELECT DISTINCT ITEM_ID_PROD
                      ,ITEM_ID_ASSY
                  FROM SCP_MST_CELL_PROD_ASSY_MAP
                 WHERE CELL_TYPE   = 'CA1'
                   AND DIVISION_ID = V_DIVISION_ID
               ) SC
         WHERE XG.BASIS_YYYYMMDD = SA.YYYYMMDD(+)
           AND SA.ITEM_ID        = SC.ITEM_ID_PROD
           AND CAST(SA.QTY AS NUMBER(20,10)) != 0
         GROUP BY XG.TRG_DATE
                 ,SA.DIVISION_ID
                 ,SA.PLAN_START_YYYYMMDD
                 ,SA.PLAN_TYPE
                 ,SA.SEQ
                 ,SA.OPERATION_GROUP
                 ,SA.FROM_SITE
                 ,SC.ITEM_ID_ASSY
        ------------------------------------------------------------------------
        -- Get Weekly CHAR data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XH.WEEK_NUM AS TRG_DATE
              ,SB.DIVISION_ID
              ,SB.PLAN_START_YYYYMMDD
              ,SB.PLAN_TYPE
              ,SB.SEQ
              ,SB.OPERATION_GROUP
              ,SB.FROM_SITE
              ,SD.ITEM_ID_ASSY AS ITEM_ID
              ,'-' AS LINE_ID
              ,'-' AS BOD_ID
              ,'/' AS PROJECT_CODE
              ,'CELL_CHAR_PLAN' AS MEASURE
              ,SUM(CAST(SB.QTY AS NUMBER(20,10))) AS QTY_SUM
              ,V_2ND_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_2ND_WEEKS_IN_YEAR - V_2ND_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN V_2ND_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(V_2ND_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XH
              ,(SELECT V_DIVISION_ID         AS DIVISION_ID
                      ,P_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                      ,V_SCP_PLAN_TYPE       AS PLAN_TYPE
                      ,TO_NUMBER(V_SCP_PLAN_SEQ) AS SEQ /* UNION 다른 가지가 숫자라 AS-IS 도 숫자로 변환 */
                      ,N.OPERATION_GROUP
                      ,M.SITE_ID            AS FROM_SITE
                      ,M.ITEM_ID
                      ,M.GRADE
                      ,M.START_DATE         AS YYYYMMDD
                      ,M.OUT_QTY_INT        AS QTY
                  FROM SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT_SN M
                      ,SCP_MST_FINAL_ITEM N
                 WHERE N.ITEM_ID         = M.ITEM_ID
                   AND M.GRADE IN ('CHAR')
                   AND N.OPERATION_GROUP = 'A'
                   AND N.DIVISION_ID     = V_DIVISION_ID
                   AND M.PLAN_ID         = V_PLAN_ID
               ) SB
              ,(SELECT DISTINCT ITEM_ID_PROD
                      ,ITEM_ID_ASSY
                  FROM SCP_MST_CELL_PROD_ASSY_MAP
                 WHERE CELL_TYPE   = 'CA1'
                   AND DIVISION_ID = V_DIVISION_ID
               ) SD
         WHERE XH.BASIS_YYYYMMDD = SB.YYYYMMDD(+)
           AND SB.ITEM_ID        = SD.ITEM_ID_PROD
           AND CAST(SB.QTY AS NUMBER(20,10)) != 0
         GROUP BY XH.WEEK_NUM
                 ,SB.DIVISION_ID
                 ,SB.PLAN_START_YYYYMMDD
                 ,SB.PLAN_TYPE
                 ,SB.SEQ
                 ,SB.OPERATION_GROUP
                 ,SB.FROM_SITE
                 ,SD.ITEM_ID_ASSY
        ------------------------------------------------------------------------
        -- Get Daily SCP_ANL_SHIPMENT_PLAN_SEMI data
        -- SCP_XLS_PSI_GLOBAL_SMALL_PACK 테이블의 CELL_SHIP_PLAN MEASURE 추가
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XI.TRG_DATE
              ,I.DIVISION_ID
              ,I.PLAN_START_YYYYMMDD
              ,I.PLAN_TYPE
              ,I.SEQ
              ,I.OPERATION_GROUP
              ,I.FROM_SITE
              ,I.ITEM_ID
              ,'-' AS LINE_ID
              ,I.BOD_ID
              ,'/' AS PROJECT_CODE
              ,'CELL_SHIP_PLAN' AS MEASURE
              ,SUM(NVL(I.QTY, 0)) AS QTY_SUM
              ,V_2ND_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_2ND_WEEKS_IN_YEAR - V_2ND_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)), 3, '0') AS TRG_DATE
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN V_2ND_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(V_2ND_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XI
              ,SCP_ANL_SHIPMENT_PLAN_SEMI I
         WHERE XI.BASIS_YYYYMMDD = I.YYYYMMDD(+)
           AND I.MEASURE             = 'SHIP_PLAN_AMEND'
           AND I.QTY                != 0
           AND I.OPERATION_GROUP     = 'A'
           AND I.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND I.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND I.LAST_UPDATED_BY     = V_UPDATE_NAME
           --AND     ASS.ATTRIBUTE9      = 'U'
         GROUP BY XI.TRG_DATE
                 ,I.DIVISION_ID
                 ,I.PLAN_START_YYYYMMDD
                 ,I.PLAN_TYPE
                 ,I.SEQ
                 ,I.OPERATION_GROUP
                 ,I.FROM_SITE
                 ,I.ITEM_ID
                 ,I.BOD_ID
        ------------------------------------------------------------------------
        -- Get Weekly SCP_ANL_SHIPMENT_PLAN_SEMI data
        -- SCP_XLS_PSI_GLOBAL_SMALL_PACK 테이블의 CELL_SHIP_PLAN MEASURE 추가
        ------------------------------------------------------------------------
        UNION ALL
        SELECT XJ.WEEK_NUM AS TRG_DATE
              ,J.DIVISION_ID
              ,J.PLAN_START_YYYYMMDD
              ,J.PLAN_TYPE
              ,J.SEQ
              ,J.OPERATION_GROUP
              ,J.FROM_SITE
              ,J.ITEM_ID
              ,'-' AS LINE_ID
              ,J.BOD_ID
              ,'/' AS PROJECT_CODE
              ,'CELL_SHIP_PLAN' AS MEASURE
              ,SUM(J.QTY) AS QTY_SUM
              ,V_2ND_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
          FROM (SELECT NULLIF('WQTY' || LPAD(TO_CHAR(CASE WHEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK > 0 THEN TO_NUMBER(ISO_WEEK) - V_2ND_MIN_WEEK ELSE TO_NUMBER(ISO_WEEK) + V_2ND_WEEKS_IN_YEAR - V_2ND_MIN_WEEK END), 2, '0'), 'WQTY') AS WEEK_NUM
                      ,BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD BETWEEN V_2ND_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(V_2ND_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               ) XJ
              ,SCP_ANL_SHIPMENT_PLAN_SEMI J
         WHERE XJ.BASIS_YYYYMMDD = J.YYYYMMDD(+)
           AND J.MEASURE             = 'SHIP_PLAN_AMEND'
           AND J.QTY                != 0
           AND J.OPERATION_GROUP     = 'A'
           AND J.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND J.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 키 */
           AND J.LAST_UPDATED_BY     = V_UPDATE_NAME
           --AND     ASS.ATTRIBUTE9 ='U'
         GROUP BY XJ.WEEK_NUM
                 ,J.DIVISION_ID
                 ,J.PLAN_START_YYYYMMDD
                 ,J.PLAN_TYPE
                 ,J.SEQ
                 ,J.OPERATION_GROUP
                 ,J.FROM_SITE
                 ,J.ITEM_ID
                 ,J.BOD_ID;

        -- 속도 이슈
        INSERT INTO GT_TASM_MS_TEMP
              (MEASURE
              )
        SELECT DISTINCT MEASURE
          FROM GT_TASM_XLS_PV_READY;
        INSERT INTO GT_TASM_CFY_TEMP
              (CREATE_FROM_YYYMMDD   /* AS-IS 테이블 변수 칸 이름 오타(YYY) 그대로 */
              )
        SELECT DISTINCT CREATE_FROM_YYYYMMDD
          FROM GT_TASM_XLS_PV_READY;

        ------------------------------------------------------------------------
        -- INSERT PIVOT TABLE
        ------------------------------------------------------------------------
        INSERT INTO GT_TASM_XLS_PV_TABLE
              (DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,OPERATION_GROUP
              ,FROM_SITE
              ,ITEM_ID
              ,LINE_ID
              ,BOD_ID
              ,PROJECT_CODE
              ,MEASURE
              ,CREATE_FROM_YYYYMMDD
              ,QTY001
              ,QTY002
              ,QTY003
              ,QTY004
              ,QTY005
              ,QTY006
              ,QTY007
              ,QTY008
              ,QTY009
              ,QTY010
              ,QTY011
              ,QTY012
              ,QTY013
              ,QTY014
              ,QTY015
              ,QTY016
              ,QTY017
              ,QTY018
              ,QTY019
              ,QTY020
              ,QTY021
              ,QTY022
              ,QTY023
              ,QTY024
              ,QTY025
              ,QTY026
              ,QTY027
              ,QTY028
              ,QTY029
              ,QTY030
              ,QTY031
              ,QTY032
              ,QTY033
              ,QTY034
              ,QTY035
              ,QTY036
              ,QTY037
              ,QTY038
              ,QTY039
              ,QTY040
              ,QTY041
              ,QTY042
              ,QTY043
              ,QTY044
              ,QTY045
              ,QTY046
              ,QTY047
              ,QTY048
              ,QTY049
              ,QTY050
              ,QTY051
              ,QTY052
              ,QTY053
              ,QTY054
              ,QTY055
              ,QTY056
              ,QTY057
              ,QTY058
              ,QTY059
              ,QTY060
              ,QTY061
              ,QTY062
              ,QTY063
              ,QTY064
              ,QTY065
              ,QTY066
              ,QTY067
              ,QTY068
              ,QTY069
              ,QTY070
              ,QTY071
              ,QTY072
              ,QTY073
              ,QTY074
              ,QTY075
              ,QTY076
              ,QTY077
              ,QTY078
              ,QTY079
              ,QTY080
              ,QTY081
              ,QTY082
              ,QTY083
              ,QTY084
              ,QTY085
              ,QTY086
              ,QTY087
              ,QTY088
              ,QTY089
              ,QTY090
              ,QTY091
              ,QTY092
              ,QTY093
              ,QTY094
              ,QTY095
              ,QTY096
              ,QTY097
              ,QTY098
              ,QTY099
              ,QTY100
              ,QTY101
              ,QTY102
              ,QTY103
              ,QTY104
              ,QTY105
              ,QTY106
              ,QTY107
              ,QTY108
              ,QTY109
              ,QTY110
              ,QTY111
              ,QTY112
              ,QTY113
              ,QTY114
              ,QTY115
              ,QTY116
              ,QTY117
              ,QTY118
              ,QTY119
              ,QTY120
              ,QTY121
              ,QTY122
              ,QTY123
              ,QTY124
              ,QTY125
              ,QTY126
              ,QTY127
              ,QTY128
              ,QTY129
              ,QTY130
              ,QTY131
              ,QTY132
              ,QTY133
              ,QTY134
              ,QTY135
              ,QTY136
              ,QTY137
              ,QTY138
              ,QTY139
              ,QTY140
              ,QTY141
              ,QTY142
              ,QTY143
              ,QTY144
              ,QTY145
              ,QTY146
              ,QTY147
              ,QTY148
              ,QTY149
              ,QTY150
              ,QTY151
              ,QTY152
              ,QTY153
              ,QTY154
              ,QTY155
              ,QTY156
              ,QTY157
              ,QTY158
              ,QTY159
              ,QTY160
              ,QTY161
              ,QTY162
              ,QTY163
              ,QTY164
              ,QTY165
              ,QTY166
              ,QTY167
              ,QTY168
              ,QTY169
              ,QTY170
              ,QTY171
              ,QTY172
              ,QTY173
              ,QTY174
              ,QTY175
              ,QTY176
              ,QTY177
              ,QTY178
              ,QTY179
              ,QTY180
              ,QTY181
              ,QTY182
              ,QTY183
              ,QTY184
              ,QTY185
              ,QTY186
              ,QTY187
              ,QTY188
              ,QTY189
              ,QTY190
              ,QTY191
              ,QTY192
              ,QTY193
              ,QTY194
              ,QTY195
              ,QTY196
              ,QTY197
              ,QTY198
              ,QTY199
              ,QTY200
              ,QTY201
              ,QTY202
              ,QTY203
              ,QTY204
              ,QTY205
              ,QTY206
              ,QTY207
              ,QTY208
              ,QTY209
              ,QTY210
              ,QTY211
              ,QTY212
              ,QTY213
              ,QTY214
              ,QTY215
              ,QTY216
              ,QTY217
              ,QTY218
              ,QTY219
              ,QTY220
              ,QTY221
              ,QTY222
              ,QTY223
              ,QTY224
              ,QTY225
              ,QTY226
              ,QTY227
              ,QTY228
              ,QTY229
              ,QTY230
              ,QTY231
              ,QTY232
              ,QTY233
              ,QTY234
              ,QTY235
              ,QTY236
              ,QTY237
              ,QTY238
              ,QTY239
              ,QTY240
              ,QTY241
              ,QTY242
              ,QTY243
              ,QTY244
              ,QTY245
              ,QTY246
              ,QTY247
              ,QTY248
              ,QTY249
              ,QTY250
              ,QTY251
              ,QTY252
              ,QTY253
              ,QTY254
              ,QTY255
              ,QTY256
              ,QTY257
              ,QTY258
              ,QTY259
              ,QTY260
              ,QTY261
              ,QTY262
              ,QTY263
              ,QTY264
              ,QTY265
              ,QTY266
              ,QTY267
              ,QTY268
              ,QTY269
              ,QTY270
              ,QTY271
              ,QTY272
              ,QTY273
              ,QTY274
              ,QTY275
              ,QTY276
              ,QTY277
              ,QTY278
              ,QTY279
              ,QTY280
              ,QTY281
              ,QTY282
              ,QTY283
              ,QTY284
              ,QTY285
              ,QTY286
              ,QTY287
              ,QTY288
              ,QTY289
              ,QTY290
              ,QTY291
              ,QTY292
              ,QTY293
              ,QTY294
              ,QTY295
              ,QTY296
              ,QTY297
              ,QTY298
              ,QTY299
              ,QTY300
              ,QTY301
              ,QTY302
              ,QTY303
              ,QTY304
              ,QTY305
              ,QTY306
              ,QTY307
              ,QTY308
              ,QTY309
              ,QTY310
              ,QTY311
              ,QTY312
              ,QTY313
              ,QTY314
              ,QTY315
              ,QTY316
              ,QTY317
              ,QTY318
              ,QTY319
              ,QTY320
              ,QTY321
              ,QTY322
              ,QTY323
              ,QTY324
              ,QTY325
              ,QTY326
              ,QTY327
              ,QTY328
              ,QTY329
              ,QTY330
              ,QTY331
              ,QTY332
              ,QTY333
              ,QTY334
              ,QTY335
              ,QTY336
              ,QTY337
              ,QTY338
              ,QTY339
              ,QTY340
              ,QTY341
              ,QTY342
              ,QTY343
              ,QTY344
              ,QTY345
              ,QTY346
              ,QTY347
              ,QTY348
              ,QTY349
              ,QTY350
              ,QTY351
              ,QTY352
              ,QTY353
              ,QTY354
              ,QTY355
              ,QTY356
              ,QTY357
              ,QTY358
              ,QTY359
              ,QTY360
              ,QTY361
              ,QTY362
              ,QTY363
              ,QTY364
              ,WQTY01
              ,WQTY02
              ,WQTY03
              ,WQTY04
              ,WQTY05
              ,WQTY06
              ,WQTY07
              ,WQTY08
              ,WQTY09
              ,WQTY10
              ,WQTY11
              ,WQTY12
              ,WQTY13
              ,WQTY14
              ,WQTY15
              ,WQTY16
              ,WQTY17
              ,WQTY18
              ,WQTY19
              ,WQTY20
              ,WQTY21
              ,WQTY22
              ,WQTY23
              ,WQTY24
              ,WQTY25
              ,WQTY26
              ,WQTY27
              ,WQTY28
              ,WQTY29
              ,WQTY30
              ,WQTY31
              ,WQTY32
              ,WQTY33
              ,WQTY34
              ,WQTY35
              ,WQTY36
              ,WQTY37
              ,WQTY38
              ,WQTY39
              ,WQTY40
              ,WQTY41
              ,WQTY42
              ,WQTY43
              ,WQTY44
              ,WQTY45
              ,WQTY46
              ,WQTY47
              ,WQTY48
              ,WQTY49
              ,WQTY50
              ,WQTY51
              ,WQTY52
              )
        SELECT DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,OPERATION_GROUP
              ,FROM_SITE
              ,ITEM_ID
              ,LINE_ID
              ,BOD_ID
              ,PROJECT_CODE
              ,MEASURE
              ,CREATE_FROM_YYYYMMDD
              ,NVL(QTY001, 0) AS QTY001
              ,NVL(QTY002, 0) AS QTY002
              ,NVL(QTY003, 0) AS QTY003
              ,NVL(QTY004, 0) AS QTY004
              ,NVL(QTY005, 0) AS QTY005
              ,NVL(QTY006, 0) AS QTY006
              ,NVL(QTY007, 0) AS QTY007
              ,NVL(QTY008, 0) AS QTY008
              ,NVL(QTY009, 0) AS QTY009
              ,NVL(QTY010, 0) AS QTY010
              ,NVL(QTY011, 0) AS QTY011
              ,NVL(QTY012, 0) AS QTY012
              ,NVL(QTY013, 0) AS QTY013
              ,NVL(QTY014, 0) AS QTY014
              ,NVL(QTY015, 0) AS QTY015
              ,NVL(QTY016, 0) AS QTY016
              ,NVL(QTY017, 0) AS QTY017
              ,NVL(QTY018, 0) AS QTY018
              ,NVL(QTY019, 0) AS QTY019
              ,NVL(QTY020, 0) AS QTY020
              ,NVL(QTY021, 0) AS QTY021
              ,NVL(QTY022, 0) AS QTY022
              ,NVL(QTY023, 0) AS QTY023
              ,NVL(QTY024, 0) AS QTY024
              ,NVL(QTY025, 0) AS QTY025
              ,NVL(QTY026, 0) AS QTY026
              ,NVL(QTY027, 0) AS QTY027
              ,NVL(QTY028, 0) AS QTY028
              ,NVL(QTY029, 0) AS QTY029
              ,NVL(QTY030, 0) AS QTY030
              ,NVL(QTY031, 0) AS QTY031
              ,NVL(QTY032, 0) AS QTY032
              ,NVL(QTY033, 0) AS QTY033
              ,NVL(QTY034, 0) AS QTY034
              ,NVL(QTY035, 0) AS QTY035
              ,NVL(QTY036, 0) AS QTY036
              ,NVL(QTY037, 0) AS QTY037
              ,NVL(QTY038, 0) AS QTY038
              ,NVL(QTY039, 0) AS QTY039
              ,NVL(QTY040, 0) AS QTY040
              ,NVL(QTY041, 0) AS QTY041
              ,NVL(QTY042, 0) AS QTY042
              ,NVL(QTY043, 0) AS QTY043
              ,NVL(QTY044, 0) AS QTY044
              ,NVL(QTY045, 0) AS QTY045
              ,NVL(QTY046, 0) AS QTY046
              ,NVL(QTY047, 0) AS QTY047
              ,NVL(QTY048, 0) AS QTY048
              ,NVL(QTY049, 0) AS QTY049
              ,NVL(QTY050, 0) AS QTY050
              ,NVL(QTY051, 0) AS QTY051
              ,NVL(QTY052, 0) AS QTY052
              ,NVL(QTY053, 0) AS QTY053
              ,NVL(QTY054, 0) AS QTY054
              ,NVL(QTY055, 0) AS QTY055
              ,NVL(QTY056, 0) AS QTY056
              ,NVL(QTY057, 0) AS QTY057
              ,NVL(QTY058, 0) AS QTY058
              ,NVL(QTY059, 0) AS QTY059
              ,NVL(QTY060, 0) AS QTY060
              ,NVL(QTY061, 0) AS QTY061
              ,NVL(QTY062, 0) AS QTY062
              ,NVL(QTY063, 0) AS QTY063
              ,NVL(QTY064, 0) AS QTY064
              ,NVL(QTY065, 0) AS QTY065
              ,NVL(QTY066, 0) AS QTY066
              ,NVL(QTY067, 0) AS QTY067
              ,NVL(QTY068, 0) AS QTY068
              ,NVL(QTY069, 0) AS QTY069
              ,NVL(QTY070, 0) AS QTY070
              ,NVL(QTY071, 0) AS QTY071
              ,NVL(QTY072, 0) AS QTY072
              ,NVL(QTY073, 0) AS QTY073
              ,NVL(QTY074, 0) AS QTY074
              ,NVL(QTY075, 0) AS QTY075
              ,NVL(QTY076, 0) AS QTY076
              ,NVL(QTY077, 0) AS QTY077
              ,NVL(QTY078, 0) AS QTY078
              ,NVL(QTY079, 0) AS QTY079
              ,NVL(QTY080, 0) AS QTY080
              ,NVL(QTY081, 0) AS QTY081
              ,NVL(QTY082, 0) AS QTY082
              ,NVL(QTY083, 0) AS QTY083
              ,NVL(QTY084, 0) AS QTY084
              ,NVL(QTY085, 0) AS QTY085
              ,NVL(QTY086, 0) AS QTY086
              ,NVL(QTY087, 0) AS QTY087
              ,NVL(QTY088, 0) AS QTY088
              ,NVL(QTY089, 0) AS QTY089
              ,NVL(QTY090, 0) AS QTY090
              ,NVL(QTY091, 0) AS QTY091
              ,NVL(QTY092, 0) AS QTY092
              ,NVL(QTY093, 0) AS QTY093
              ,NVL(QTY094, 0) AS QTY094
              ,NVL(QTY095, 0) AS QTY095
              ,NVL(QTY096, 0) AS QTY096
              ,NVL(QTY097, 0) AS QTY097
              ,NVL(QTY098, 0) AS QTY098
              ,NVL(QTY099, 0) AS QTY099
              ,NVL(QTY100, 0) AS QTY100
              ,NVL(QTY101, 0) AS QTY101
              ,NVL(QTY102, 0) AS QTY102
              ,NVL(QTY103, 0) AS QTY103
              ,NVL(QTY104, 0) AS QTY104
              ,NVL(QTY105, 0) AS QTY105
              ,NVL(QTY106, 0) AS QTY106
              ,NVL(QTY107, 0) AS QTY107
              ,NVL(QTY108, 0) AS QTY108
              ,NVL(QTY109, 0) AS QTY109
              ,NVL(QTY110, 0) AS QTY110
              ,NVL(QTY111, 0) AS QTY111
              ,NVL(QTY112, 0) AS QTY112
              ,NVL(QTY113, 0) AS QTY113
              ,NVL(QTY114, 0) AS QTY114
              ,NVL(QTY115, 0) AS QTY115
              ,NVL(QTY116, 0) AS QTY116
              ,NVL(QTY117, 0) AS QTY117
              ,NVL(QTY118, 0) AS QTY118
              ,NVL(QTY119, 0) AS QTY119
              ,NVL(QTY120, 0) AS QTY120
              ,NVL(QTY121, 0) AS QTY121
              ,NVL(QTY122, 0) AS QTY122
              ,NVL(QTY123, 0) AS QTY123
              ,NVL(QTY124, 0) AS QTY124
              ,NVL(QTY125, 0) AS QTY125
              ,NVL(QTY126, 0) AS QTY126
              ,NVL(QTY127, 0) AS QTY127
              ,NVL(QTY128, 0) AS QTY128
              ,NVL(QTY129, 0) AS QTY129
              ,NVL(QTY130, 0) AS QTY130
              ,NVL(QTY131, 0) AS QTY131
              ,NVL(QTY132, 0) AS QTY132
              ,NVL(QTY133, 0) AS QTY133
              ,NVL(QTY134, 0) AS QTY134
              ,NVL(QTY135, 0) AS QTY135
              ,NVL(QTY136, 0) AS QTY136
              ,NVL(QTY137, 0) AS QTY137
              ,NVL(QTY138, 0) AS QTY138
              ,NVL(QTY139, 0) AS QTY139
              ,NVL(QTY140, 0) AS QTY140
              ,NVL(QTY141, 0) AS QTY141
              ,NVL(QTY142, 0) AS QTY142
              ,NVL(QTY143, 0) AS QTY143
              ,NVL(QTY144, 0) AS QTY144
              ,NVL(QTY145, 0) AS QTY145
              ,NVL(QTY146, 0) AS QTY146
              ,NVL(QTY147, 0) AS QTY147
              ,NVL(QTY148, 0) AS QTY148
              ,NVL(QTY149, 0) AS QTY149
              ,NVL(QTY150, 0) AS QTY150
              ,NVL(QTY151, 0) AS QTY151
              ,NVL(QTY152, 0) AS QTY152
              ,NVL(QTY153, 0) AS QTY153
              ,NVL(QTY154, 0) AS QTY154
              ,NVL(QTY155, 0) AS QTY155
              ,NVL(QTY156, 0) AS QTY156
              ,NVL(QTY157, 0) AS QTY157
              ,NVL(QTY158, 0) AS QTY158
              ,NVL(QTY159, 0) AS QTY159
              ,NVL(QTY160, 0) AS QTY160
              ,NVL(QTY161, 0) AS QTY161
              ,NVL(QTY162, 0) AS QTY162
              ,NVL(QTY163, 0) AS QTY163
              ,NVL(QTY164, 0) AS QTY164
              ,NVL(QTY165, 0) AS QTY165
              ,NVL(QTY166, 0) AS QTY166
              ,NVL(QTY167, 0) AS QTY167
              ,NVL(QTY168, 0) AS QTY168
              ,NVL(QTY169, 0) AS QTY169
              ,NVL(QTY170, 0) AS QTY170
              ,NVL(QTY171, 0) AS QTY171
              ,NVL(QTY172, 0) AS QTY172
              ,NVL(QTY173, 0) AS QTY173
              ,NVL(QTY174, 0) AS QTY174
              ,NVL(QTY175, 0) AS QTY175
              ,NVL(QTY176, 0) AS QTY176
              ,NVL(QTY177, 0) AS QTY177
              ,NVL(QTY178, 0) AS QTY178
              ,NVL(QTY179, 0) AS QTY179
              ,NVL(QTY180, 0) AS QTY180
              ,NVL(QTY181, 0) AS QTY181
              ,NVL(QTY182, 0) AS QTY182
              ,NVL(QTY183, 0) AS QTY183
              ,NVL(QTY184, 0) AS QTY184
              ,NVL(QTY185, 0) AS QTY185
              ,NVL(QTY186, 0) AS QTY186
              ,NVL(QTY187, 0) AS QTY187
              ,NVL(QTY188, 0) AS QTY188
              ,NVL(QTY189, 0) AS QTY189
              ,NVL(QTY190, 0) AS QTY190
              ,NVL(QTY191, 0) AS QTY191
              ,NVL(QTY192, 0) AS QTY192
              ,NVL(QTY193, 0) AS QTY193
              ,NVL(QTY194, 0) AS QTY194
              ,NVL(QTY195, 0) AS QTY195
              ,NVL(QTY196, 0) AS QTY196
              ,NVL(QTY197, 0) AS QTY197
              ,NVL(QTY198, 0) AS QTY198
              ,NVL(QTY199, 0) AS QTY199
              ,NVL(QTY200, 0) AS QTY200
              ,NVL(QTY201, 0) AS QTY201
              ,NVL(QTY202, 0) AS QTY202
              ,NVL(QTY203, 0) AS QTY203
              ,NVL(QTY204, 0) AS QTY204
              ,NVL(QTY205, 0) AS QTY205
              ,NVL(QTY206, 0) AS QTY206
              ,NVL(QTY207, 0) AS QTY207
              ,NVL(QTY208, 0) AS QTY208
              ,NVL(QTY209, 0) AS QTY209
              ,NVL(QTY210, 0) AS QTY210
              ,NVL(QTY211, 0) AS QTY211
              ,NVL(QTY212, 0) AS QTY212
              ,NVL(QTY213, 0) AS QTY213
              ,NVL(QTY214, 0) AS QTY214
              ,NVL(QTY215, 0) AS QTY215
              ,NVL(QTY216, 0) AS QTY216
              ,NVL(QTY217, 0) AS QTY217
              ,NVL(QTY218, 0) AS QTY218
              ,NVL(QTY219, 0) AS QTY219
              ,NVL(QTY220, 0) AS QTY220
              ,NVL(QTY221, 0) AS QTY221
              ,NVL(QTY222, 0) AS QTY222
              ,NVL(QTY223, 0) AS QTY223
              ,NVL(QTY224, 0) AS QTY224
              ,NVL(QTY225, 0) AS QTY225
              ,NVL(QTY226, 0) AS QTY226
              ,NVL(QTY227, 0) AS QTY227
              ,NVL(QTY228, 0) AS QTY228
              ,NVL(QTY229, 0) AS QTY229
              ,NVL(QTY230, 0) AS QTY230
              ,NVL(QTY231, 0) AS QTY231
              ,NVL(QTY232, 0) AS QTY232
              ,NVL(QTY233, 0) AS QTY233
              ,NVL(QTY234, 0) AS QTY234
              ,NVL(QTY235, 0) AS QTY235
              ,NVL(QTY236, 0) AS QTY236
              ,NVL(QTY237, 0) AS QTY237
              ,NVL(QTY238, 0) AS QTY238
              ,NVL(QTY239, 0) AS QTY239
              ,NVL(QTY240, 0) AS QTY240
              ,NVL(QTY241, 0) AS QTY241
              ,NVL(QTY242, 0) AS QTY242
              ,NVL(QTY243, 0) AS QTY243
              ,NVL(QTY244, 0) AS QTY244
              ,NVL(QTY245, 0) AS QTY245
              ,NVL(QTY246, 0) AS QTY246
              ,NVL(QTY247, 0) AS QTY247
              ,NVL(QTY248, 0) AS QTY248
              ,NVL(QTY249, 0) AS QTY249
              ,NVL(QTY250, 0) AS QTY250
              ,NVL(QTY251, 0) AS QTY251
              ,NVL(QTY252, 0) AS QTY252
              ,NVL(QTY253, 0) AS QTY253
              ,NVL(QTY254, 0) AS QTY254
              ,NVL(QTY255, 0) AS QTY255
              ,NVL(QTY256, 0) AS QTY256
              ,NVL(QTY257, 0) AS QTY257
              ,NVL(QTY258, 0) AS QTY258
              ,NVL(QTY259, 0) AS QTY259
              ,NVL(QTY260, 0) AS QTY260
              ,NVL(QTY261, 0) AS QTY261
              ,NVL(QTY262, 0) AS QTY262
              ,NVL(QTY263, 0) AS QTY263
              ,NVL(QTY264, 0) AS QTY264
              ,NVL(QTY265, 0) AS QTY265
              ,NVL(QTY266, 0) AS QTY266
              ,NVL(QTY267, 0) AS QTY267
              ,NVL(QTY268, 0) AS QTY268
              ,NVL(QTY269, 0) AS QTY269
              ,NVL(QTY270, 0) AS QTY270
              ,NVL(QTY271, 0) AS QTY271
              ,NVL(QTY272, 0) AS QTY272
              ,NVL(QTY273, 0) AS QTY273
              ,NVL(QTY274, 0) AS QTY274
              ,NVL(QTY275, 0) AS QTY275
              ,NVL(QTY276, 0) AS QTY276
              ,NVL(QTY277, 0) AS QTY277
              ,NVL(QTY278, 0) AS QTY278
              ,NVL(QTY279, 0) AS QTY279
              ,NVL(QTY280, 0) AS QTY280
              ,NVL(QTY281, 0) AS QTY281
              ,NVL(QTY282, 0) AS QTY282
              ,NVL(QTY283, 0) AS QTY283
              ,NVL(QTY284, 0) AS QTY284
              ,NVL(QTY285, 0) AS QTY285
              ,NVL(QTY286, 0) AS QTY286
              ,NVL(QTY287, 0) AS QTY287
              ,NVL(QTY288, 0) AS QTY288
              ,NVL(QTY289, 0) AS QTY289
              ,NVL(QTY290, 0) AS QTY290
              ,NVL(QTY291, 0) AS QTY291
              ,NVL(QTY292, 0) AS QTY292
              ,NVL(QTY293, 0) AS QTY293
              ,NVL(QTY294, 0) AS QTY294
              ,NVL(QTY295, 0) AS QTY295
              ,NVL(QTY296, 0) AS QTY296
              ,NVL(QTY297, 0) AS QTY297
              ,NVL(QTY298, 0) AS QTY298
              ,NVL(QTY299, 0) AS QTY299
              ,NVL(QTY300, 0) AS QTY300
              ,NVL(QTY301, 0) AS QTY301
              ,NVL(QTY302, 0) AS QTY302
              ,NVL(QTY303, 0) AS QTY303
              ,NVL(QTY304, 0) AS QTY304
              ,NVL(QTY305, 0) AS QTY305
              ,NVL(QTY306, 0) AS QTY306
              ,NVL(QTY307, 0) AS QTY307
              ,NVL(QTY308, 0) AS QTY308
              ,NVL(QTY309, 0) AS QTY309
              ,NVL(QTY310, 0) AS QTY310
              ,NVL(QTY311, 0) AS QTY311
              ,NVL(QTY312, 0) AS QTY312
              ,NVL(QTY313, 0) AS QTY313
              ,NVL(QTY314, 0) AS QTY314
              ,NVL(QTY315, 0) AS QTY315
              ,NVL(QTY316, 0) AS QTY316
              ,NVL(QTY317, 0) AS QTY317
              ,NVL(QTY318, 0) AS QTY318
              ,NVL(QTY319, 0) AS QTY319
              ,NVL(QTY320, 0) AS QTY320
              ,NVL(QTY321, 0) AS QTY321
              ,NVL(QTY322, 0) AS QTY322
              ,NVL(QTY323, 0) AS QTY323
              ,NVL(QTY324, 0) AS QTY324
              ,NVL(QTY325, 0) AS QTY325
              ,NVL(QTY326, 0) AS QTY326
              ,NVL(QTY327, 0) AS QTY327
              ,NVL(QTY328, 0) AS QTY328
              ,NVL(QTY329, 0) AS QTY329
              ,NVL(QTY330, 0) AS QTY330
              ,NVL(QTY331, 0) AS QTY331
              ,NVL(QTY332, 0) AS QTY332
              ,NVL(QTY333, 0) AS QTY333
              ,NVL(QTY334, 0) AS QTY334
              ,NVL(QTY335, 0) AS QTY335
              ,NVL(QTY336, 0) AS QTY336
              ,NVL(QTY337, 0) AS QTY337
              ,NVL(QTY338, 0) AS QTY338
              ,NVL(QTY339, 0) AS QTY339
              ,NVL(QTY340, 0) AS QTY340
              ,NVL(QTY341, 0) AS QTY341
              ,NVL(QTY342, 0) AS QTY342
              ,NVL(QTY343, 0) AS QTY343
              ,NVL(QTY344, 0) AS QTY344
              ,NVL(QTY345, 0) AS QTY345
              ,NVL(QTY346, 0) AS QTY346
              ,NVL(QTY347, 0) AS QTY347
              ,NVL(QTY348, 0) AS QTY348
              ,NVL(QTY349, 0) AS QTY349
              ,NVL(QTY350, 0) AS QTY350
              ,NVL(QTY351, 0) AS QTY351
              ,NVL(QTY352, 0) AS QTY352
              ,NVL(QTY353, 0) AS QTY353
              ,NVL(QTY354, 0) AS QTY354
              ,NVL(QTY355, 0) AS QTY355
              ,NVL(QTY356, 0) AS QTY356
              ,NVL(QTY357, 0) AS QTY357
              ,NVL(QTY358, 0) AS QTY358
              ,NVL(QTY359, 0) AS QTY359
              ,NVL(QTY360, 0) AS QTY360
              ,NVL(QTY361, 0) AS QTY361
              ,NVL(QTY362, 0) AS QTY362
              ,NVL(QTY363, 0) AS QTY363
              ,NVL(QTY364, 0) AS QTY364
              ,NVL(WQTY01, 0) AS WQTY01
              ,NVL(WQTY02, 0) AS WQTY02
              ,NVL(WQTY03, 0) AS WQTY03
              ,NVL(WQTY04, 0) AS WQTY04
              ,NVL(WQTY05, 0) AS WQTY05
              ,NVL(WQTY06, 0) AS WQTY06
              ,NVL(WQTY07, 0) AS WQTY07
              ,NVL(WQTY08, 0) AS WQTY08
              ,NVL(WQTY09, 0) AS WQTY09
              ,NVL(WQTY10, 0) AS WQTY10
              ,NVL(WQTY11, 0) AS WQTY11
              ,NVL(WQTY12, 0) AS WQTY12
              ,NVL(WQTY13, 0) AS WQTY13
              ,NVL(WQTY14, 0) AS WQTY14
              ,NVL(WQTY15, 0) AS WQTY15
              ,NVL(WQTY16, 0) AS WQTY16
              ,NVL(WQTY17, 0) AS WQTY17
              ,NVL(WQTY18, 0) AS WQTY18
              ,NVL(WQTY19, 0) AS WQTY19
              ,NVL(WQTY20, 0) AS WQTY20
              ,NVL(WQTY21, 0) AS WQTY21
              ,NVL(WQTY22, 0) AS WQTY22
              ,NVL(WQTY23, 0) AS WQTY23
              ,NVL(WQTY24, 0) AS WQTY24
              ,NVL(WQTY25, 0) AS WQTY25
              ,NVL(WQTY26, 0) AS WQTY26
              ,NVL(WQTY27, 0) AS WQTY27
              ,NVL(WQTY28, 0) AS WQTY28
              ,NVL(WQTY29, 0) AS WQTY29
              ,NVL(WQTY30, 0) AS WQTY30
              ,NVL(WQTY31, 0) AS WQTY31
              ,NVL(WQTY32, 0) AS WQTY32
              ,NVL(WQTY33, 0) AS WQTY33
              ,NVL(WQTY34, 0) AS WQTY34
              ,NVL(WQTY35, 0) AS WQTY35
              ,NVL(WQTY36, 0) AS WQTY36
              ,NVL(WQTY37, 0) AS WQTY37
              ,NVL(WQTY38, 0) AS WQTY38
              ,NVL(WQTY39, 0) AS WQTY39
              ,NVL(WQTY40, 0) AS WQTY40
              ,NVL(WQTY41, 0) AS WQTY41
              ,NVL(WQTY42, 0) AS WQTY42
              ,NVL(WQTY43, 0) AS WQTY43
              ,NVL(WQTY44, 0) AS WQTY44
              ,NVL(WQTY45, 0) AS WQTY45
              ,NVL(WQTY46, 0) AS WQTY46
              ,NVL(WQTY47, 0) AS WQTY47
              ,NVL(WQTY48, 0) AS WQTY48
              ,NVL(WQTY49, 0) AS WQTY49
              ,NVL(WQTY50, 0) AS WQTY50
              ,NVL(WQTY51, 0) AS WQTY51
              ,NVL(WQTY52, 0) AS WQTY52
          FROM GT_TASM_XLS_PV_READY
         PIVOT (SUM(QTY_SUM)
                FOR TRG_DATE IN ('QTY001' AS QTY001
                                ,'QTY002' AS QTY002
                                ,'QTY003' AS QTY003
                                ,'QTY004' AS QTY004
                                ,'QTY005' AS QTY005
                                ,'QTY006' AS QTY006
                                ,'QTY007' AS QTY007
                                ,'QTY008' AS QTY008
                                ,'QTY009' AS QTY009
                                ,'QTY010' AS QTY010
                                ,'QTY011' AS QTY011
                                ,'QTY012' AS QTY012
                                ,'QTY013' AS QTY013
                                ,'QTY014' AS QTY014
                                ,'QTY015' AS QTY015
                                ,'QTY016' AS QTY016
                                ,'QTY017' AS QTY017
                                ,'QTY018' AS QTY018
                                ,'QTY019' AS QTY019
                                ,'QTY020' AS QTY020
                                ,'QTY021' AS QTY021
                                ,'QTY022' AS QTY022
                                ,'QTY023' AS QTY023
                                ,'QTY024' AS QTY024
                                ,'QTY025' AS QTY025
                                ,'QTY026' AS QTY026
                                ,'QTY027' AS QTY027
                                ,'QTY028' AS QTY028
                                ,'QTY029' AS QTY029
                                ,'QTY030' AS QTY030
                                ,'QTY031' AS QTY031
                                ,'QTY032' AS QTY032
                                ,'QTY033' AS QTY033
                                ,'QTY034' AS QTY034
                                ,'QTY035' AS QTY035
                                ,'QTY036' AS QTY036
                                ,'QTY037' AS QTY037
                                ,'QTY038' AS QTY038
                                ,'QTY039' AS QTY039
                                ,'QTY040' AS QTY040
                                ,'QTY041' AS QTY041
                                ,'QTY042' AS QTY042
                                ,'QTY043' AS QTY043
                                ,'QTY044' AS QTY044
                                ,'QTY045' AS QTY045
                                ,'QTY046' AS QTY046
                                ,'QTY047' AS QTY047
                                ,'QTY048' AS QTY048
                                ,'QTY049' AS QTY049
                                ,'QTY050' AS QTY050
                                ,'QTY051' AS QTY051
                                ,'QTY052' AS QTY052
                                ,'QTY053' AS QTY053
                                ,'QTY054' AS QTY054
                                ,'QTY055' AS QTY055
                                ,'QTY056' AS QTY056
                                ,'QTY057' AS QTY057
                                ,'QTY058' AS QTY058
                                ,'QTY059' AS QTY059
                                ,'QTY060' AS QTY060
                                ,'QTY061' AS QTY061
                                ,'QTY062' AS QTY062
                                ,'QTY063' AS QTY063
                                ,'QTY064' AS QTY064
                                ,'QTY065' AS QTY065
                                ,'QTY066' AS QTY066
                                ,'QTY067' AS QTY067
                                ,'QTY068' AS QTY068
                                ,'QTY069' AS QTY069
                                ,'QTY070' AS QTY070
                                ,'QTY071' AS QTY071
                                ,'QTY072' AS QTY072
                                ,'QTY073' AS QTY073
                                ,'QTY074' AS QTY074
                                ,'QTY075' AS QTY075
                                ,'QTY076' AS QTY076
                                ,'QTY077' AS QTY077
                                ,'QTY078' AS QTY078
                                ,'QTY079' AS QTY079
                                ,'QTY080' AS QTY080
                                ,'QTY081' AS QTY081
                                ,'QTY082' AS QTY082
                                ,'QTY083' AS QTY083
                                ,'QTY084' AS QTY084
                                ,'QTY085' AS QTY085
                                ,'QTY086' AS QTY086
                                ,'QTY087' AS QTY087
                                ,'QTY088' AS QTY088
                                ,'QTY089' AS QTY089
                                ,'QTY090' AS QTY090
                                ,'QTY091' AS QTY091
                                ,'QTY092' AS QTY092
                                ,'QTY093' AS QTY093
                                ,'QTY094' AS QTY094
                                ,'QTY095' AS QTY095
                                ,'QTY096' AS QTY096
                                ,'QTY097' AS QTY097
                                ,'QTY098' AS QTY098
                                ,'QTY099' AS QTY099
                                ,'QTY100' AS QTY100
                                ,'QTY101' AS QTY101
                                ,'QTY102' AS QTY102
                                ,'QTY103' AS QTY103
                                ,'QTY104' AS QTY104
                                ,'QTY105' AS QTY105
                                ,'QTY106' AS QTY106
                                ,'QTY107' AS QTY107
                                ,'QTY108' AS QTY108
                                ,'QTY109' AS QTY109
                                ,'QTY110' AS QTY110
                                ,'QTY111' AS QTY111
                                ,'QTY112' AS QTY112
                                ,'QTY113' AS QTY113
                                ,'QTY114' AS QTY114
                                ,'QTY115' AS QTY115
                                ,'QTY116' AS QTY116
                                ,'QTY117' AS QTY117
                                ,'QTY118' AS QTY118
                                ,'QTY119' AS QTY119
                                ,'QTY120' AS QTY120
                                ,'QTY121' AS QTY121
                                ,'QTY122' AS QTY122
                                ,'QTY123' AS QTY123
                                ,'QTY124' AS QTY124
                                ,'QTY125' AS QTY125
                                ,'QTY126' AS QTY126
                                ,'QTY127' AS QTY127
                                ,'QTY128' AS QTY128
                                ,'QTY129' AS QTY129
                                ,'QTY130' AS QTY130
                                ,'QTY131' AS QTY131
                                ,'QTY132' AS QTY132
                                ,'QTY133' AS QTY133
                                ,'QTY134' AS QTY134
                                ,'QTY135' AS QTY135
                                ,'QTY136' AS QTY136
                                ,'QTY137' AS QTY137
                                ,'QTY138' AS QTY138
                                ,'QTY139' AS QTY139
                                ,'QTY140' AS QTY140
                                ,'QTY141' AS QTY141
                                ,'QTY142' AS QTY142
                                ,'QTY143' AS QTY143
                                ,'QTY144' AS QTY144
                                ,'QTY145' AS QTY145
                                ,'QTY146' AS QTY146
                                ,'QTY147' AS QTY147
                                ,'QTY148' AS QTY148
                                ,'QTY149' AS QTY149
                                ,'QTY150' AS QTY150
                                ,'QTY151' AS QTY151
                                ,'QTY152' AS QTY152
                                ,'QTY153' AS QTY153
                                ,'QTY154' AS QTY154
                                ,'QTY155' AS QTY155
                                ,'QTY156' AS QTY156
                                ,'QTY157' AS QTY157
                                ,'QTY158' AS QTY158
                                ,'QTY159' AS QTY159
                                ,'QTY160' AS QTY160
                                ,'QTY161' AS QTY161
                                ,'QTY162' AS QTY162
                                ,'QTY163' AS QTY163
                                ,'QTY164' AS QTY164
                                ,'QTY165' AS QTY165
                                ,'QTY166' AS QTY166
                                ,'QTY167' AS QTY167
                                ,'QTY168' AS QTY168
                                ,'QTY169' AS QTY169
                                ,'QTY170' AS QTY170
                                ,'QTY171' AS QTY171
                                ,'QTY172' AS QTY172
                                ,'QTY173' AS QTY173
                                ,'QTY174' AS QTY174
                                ,'QTY175' AS QTY175
                                ,'QTY176' AS QTY176
                                ,'QTY177' AS QTY177
                                ,'QTY178' AS QTY178
                                ,'QTY179' AS QTY179
                                ,'QTY180' AS QTY180
                                ,'QTY181' AS QTY181
                                ,'QTY182' AS QTY182
                                ,'QTY183' AS QTY183
                                ,'QTY184' AS QTY184
                                ,'QTY185' AS QTY185
                                ,'QTY186' AS QTY186
                                ,'QTY187' AS QTY187
                                ,'QTY188' AS QTY188
                                ,'QTY189' AS QTY189
                                ,'QTY190' AS QTY190
                                ,'QTY191' AS QTY191
                                ,'QTY192' AS QTY192
                                ,'QTY193' AS QTY193
                                ,'QTY194' AS QTY194
                                ,'QTY195' AS QTY195
                                ,'QTY196' AS QTY196
                                ,'QTY197' AS QTY197
                                ,'QTY198' AS QTY198
                                ,'QTY199' AS QTY199
                                ,'QTY200' AS QTY200
                                ,'QTY201' AS QTY201
                                ,'QTY202' AS QTY202
                                ,'QTY203' AS QTY203
                                ,'QTY204' AS QTY204
                                ,'QTY205' AS QTY205
                                ,'QTY206' AS QTY206
                                ,'QTY207' AS QTY207
                                ,'QTY208' AS QTY208
                                ,'QTY209' AS QTY209
                                ,'QTY210' AS QTY210
                                ,'QTY211' AS QTY211
                                ,'QTY212' AS QTY212
                                ,'QTY213' AS QTY213
                                ,'QTY214' AS QTY214
                                ,'QTY215' AS QTY215
                                ,'QTY216' AS QTY216
                                ,'QTY217' AS QTY217
                                ,'QTY218' AS QTY218
                                ,'QTY219' AS QTY219
                                ,'QTY220' AS QTY220
                                ,'QTY221' AS QTY221
                                ,'QTY222' AS QTY222
                                ,'QTY223' AS QTY223
                                ,'QTY224' AS QTY224
                                ,'QTY225' AS QTY225
                                ,'QTY226' AS QTY226
                                ,'QTY227' AS QTY227
                                ,'QTY228' AS QTY228
                                ,'QTY229' AS QTY229
                                ,'QTY230' AS QTY230
                                ,'QTY231' AS QTY231
                                ,'QTY232' AS QTY232
                                ,'QTY233' AS QTY233
                                ,'QTY234' AS QTY234
                                ,'QTY235' AS QTY235
                                ,'QTY236' AS QTY236
                                ,'QTY237' AS QTY237
                                ,'QTY238' AS QTY238
                                ,'QTY239' AS QTY239
                                ,'QTY240' AS QTY240
                                ,'QTY241' AS QTY241
                                ,'QTY242' AS QTY242
                                ,'QTY243' AS QTY243
                                ,'QTY244' AS QTY244
                                ,'QTY245' AS QTY245
                                ,'QTY246' AS QTY246
                                ,'QTY247' AS QTY247
                                ,'QTY248' AS QTY248
                                ,'QTY249' AS QTY249
                                ,'QTY250' AS QTY250
                                ,'QTY251' AS QTY251
                                ,'QTY252' AS QTY252
                                ,'QTY253' AS QTY253
                                ,'QTY254' AS QTY254
                                ,'QTY255' AS QTY255
                                ,'QTY256' AS QTY256
                                ,'QTY257' AS QTY257
                                ,'QTY258' AS QTY258
                                ,'QTY259' AS QTY259
                                ,'QTY260' AS QTY260
                                ,'QTY261' AS QTY261
                                ,'QTY262' AS QTY262
                                ,'QTY263' AS QTY263
                                ,'QTY264' AS QTY264
                                ,'QTY265' AS QTY265
                                ,'QTY266' AS QTY266
                                ,'QTY267' AS QTY267
                                ,'QTY268' AS QTY268
                                ,'QTY269' AS QTY269
                                ,'QTY270' AS QTY270
                                ,'QTY271' AS QTY271
                                ,'QTY272' AS QTY272
                                ,'QTY273' AS QTY273
                                ,'QTY274' AS QTY274
                                ,'QTY275' AS QTY275
                                ,'QTY276' AS QTY276
                                ,'QTY277' AS QTY277
                                ,'QTY278' AS QTY278
                                ,'QTY279' AS QTY279
                                ,'QTY280' AS QTY280
                                ,'QTY281' AS QTY281
                                ,'QTY282' AS QTY282
                                ,'QTY283' AS QTY283
                                ,'QTY284' AS QTY284
                                ,'QTY285' AS QTY285
                                ,'QTY286' AS QTY286
                                ,'QTY287' AS QTY287
                                ,'QTY288' AS QTY288
                                ,'QTY289' AS QTY289
                                ,'QTY290' AS QTY290
                                ,'QTY291' AS QTY291
                                ,'QTY292' AS QTY292
                                ,'QTY293' AS QTY293
                                ,'QTY294' AS QTY294
                                ,'QTY295' AS QTY295
                                ,'QTY296' AS QTY296
                                ,'QTY297' AS QTY297
                                ,'QTY298' AS QTY298
                                ,'QTY299' AS QTY299
                                ,'QTY300' AS QTY300
                                ,'QTY301' AS QTY301
                                ,'QTY302' AS QTY302
                                ,'QTY303' AS QTY303
                                ,'QTY304' AS QTY304
                                ,'QTY305' AS QTY305
                                ,'QTY306' AS QTY306
                                ,'QTY307' AS QTY307
                                ,'QTY308' AS QTY308
                                ,'QTY309' AS QTY309
                                ,'QTY310' AS QTY310
                                ,'QTY311' AS QTY311
                                ,'QTY312' AS QTY312
                                ,'QTY313' AS QTY313
                                ,'QTY314' AS QTY314
                                ,'QTY315' AS QTY315
                                ,'QTY316' AS QTY316
                                ,'QTY317' AS QTY317
                                ,'QTY318' AS QTY318
                                ,'QTY319' AS QTY319
                                ,'QTY320' AS QTY320
                                ,'QTY321' AS QTY321
                                ,'QTY322' AS QTY322
                                ,'QTY323' AS QTY323
                                ,'QTY324' AS QTY324
                                ,'QTY325' AS QTY325
                                ,'QTY326' AS QTY326
                                ,'QTY327' AS QTY327
                                ,'QTY328' AS QTY328
                                ,'QTY329' AS QTY329
                                ,'QTY330' AS QTY330
                                ,'QTY331' AS QTY331
                                ,'QTY332' AS QTY332
                                ,'QTY333' AS QTY333
                                ,'QTY334' AS QTY334
                                ,'QTY335' AS QTY335
                                ,'QTY336' AS QTY336
                                ,'QTY337' AS QTY337
                                ,'QTY338' AS QTY338
                                ,'QTY339' AS QTY339
                                ,'QTY340' AS QTY340
                                ,'QTY341' AS QTY341
                                ,'QTY342' AS QTY342
                                ,'QTY343' AS QTY343
                                ,'QTY344' AS QTY344
                                ,'QTY345' AS QTY345
                                ,'QTY346' AS QTY346
                                ,'QTY347' AS QTY347
                                ,'QTY348' AS QTY348
                                ,'QTY349' AS QTY349
                                ,'QTY350' AS QTY350
                                ,'QTY351' AS QTY351
                                ,'QTY352' AS QTY352
                                ,'QTY353' AS QTY353
                                ,'QTY354' AS QTY354
                                ,'QTY355' AS QTY355
                                ,'QTY356' AS QTY356
                                ,'QTY357' AS QTY357
                                ,'QTY358' AS QTY358
                                ,'QTY359' AS QTY359
                                ,'QTY360' AS QTY360
                                ,'QTY361' AS QTY361
                                ,'QTY362' AS QTY362
                                ,'QTY363' AS QTY363
                                ,'QTY364' AS QTY364
                                ,'WQTY01' AS WQTY01
                                ,'WQTY02' AS WQTY02
                                ,'WQTY03' AS WQTY03
                                ,'WQTY04' AS WQTY04
                                ,'WQTY05' AS WQTY05
                                ,'WQTY06' AS WQTY06
                                ,'WQTY07' AS WQTY07
                                ,'WQTY08' AS WQTY08
                                ,'WQTY09' AS WQTY09
                                ,'WQTY10' AS WQTY10
                                ,'WQTY11' AS WQTY11
                                ,'WQTY12' AS WQTY12
                                ,'WQTY13' AS WQTY13
                                ,'WQTY14' AS WQTY14
                                ,'WQTY15' AS WQTY15
                                ,'WQTY16' AS WQTY16
                                ,'WQTY17' AS WQTY17
                                ,'WQTY18' AS WQTY18
                                ,'WQTY19' AS WQTY19
                                ,'WQTY20' AS WQTY20
                                ,'WQTY21' AS WQTY21
                                ,'WQTY22' AS WQTY22
                                ,'WQTY23' AS WQTY23
                                ,'WQTY24' AS WQTY24
                                ,'WQTY25' AS WQTY25
                                ,'WQTY26' AS WQTY26
                                ,'WQTY27' AS WQTY27
                                ,'WQTY28' AS WQTY28
                                ,'WQTY29' AS WQTY29
                                ,'WQTY30' AS WQTY30
                                ,'WQTY31' AS WQTY31
                                ,'WQTY32' AS WQTY32
                                ,'WQTY33' AS WQTY33
                                ,'WQTY34' AS WQTY34
                                ,'WQTY35' AS WQTY35
                                ,'WQTY36' AS WQTY36
                                ,'WQTY37' AS WQTY37
                                ,'WQTY38' AS WQTY38
                                ,'WQTY39' AS WQTY39
                                ,'WQTY40' AS WQTY40
                                ,'WQTY41' AS WQTY41
                                ,'WQTY42' AS WQTY42
                                ,'WQTY43' AS WQTY43
                                ,'WQTY44' AS WQTY44
                                ,'WQTY45' AS WQTY45
                                ,'WQTY46' AS WQTY46
                                ,'WQTY47' AS WQTY47
                                ,'WQTY48' AS WQTY48
                                ,'WQTY49' AS WQTY49
                                ,'WQTY50' AS WQTY50
                                ,'WQTY51' AS WQTY51
                                ,'WQTY52' AS WQTY52
                                )
               );

        ------------------------------------------------------------------------
        -- Initialization Qty
        ------------------------------------------------------------------------
        -- 소형은 SMALL, SMALL_PACK 테이블에 UPDATE -> SMALL 먼저
        ------------------------------------------------------------------------
        UPDATE SCP_XLS_PSI_GLOBAL_SMALL A
           SET A.QTY001 = 0
              ,A.QTY002 = 0
              ,A.QTY003 = 0
              ,A.QTY004 = 0
              ,A.QTY005 = 0
              ,A.QTY006 = 0
              ,A.QTY007 = 0
              ,A.QTY008 = 0
              ,A.QTY009 = 0
              ,A.QTY010 = 0
              ,A.QTY011 = 0
              ,A.QTY012 = 0
              ,A.QTY013 = 0
              ,A.QTY014 = 0
              ,A.QTY015 = 0
              ,A.QTY016 = 0
              ,A.QTY017 = 0
              ,A.QTY018 = 0
              ,A.QTY019 = 0
              ,A.QTY020 = 0
              ,A.QTY021 = 0
              ,A.QTY022 = 0
              ,A.QTY023 = 0
              ,A.QTY024 = 0
              ,A.QTY025 = 0
              ,A.QTY026 = 0
              ,A.QTY027 = 0
              ,A.QTY028 = 0
              ,A.QTY029 = 0
              ,A.QTY030 = 0
              ,A.QTY031 = 0
              ,A.QTY032 = 0
              ,A.QTY033 = 0
              ,A.QTY034 = 0
              ,A.QTY035 = 0
              ,A.QTY036 = 0
              ,A.QTY037 = 0
              ,A.QTY038 = 0
              ,A.QTY039 = 0
              ,A.QTY040 = 0
              ,A.QTY041 = 0
              ,A.QTY042 = 0
              ,A.QTY043 = 0
              ,A.QTY044 = 0
              ,A.QTY045 = 0
              ,A.QTY046 = 0
              ,A.QTY047 = 0
              ,A.QTY048 = 0
              ,A.QTY049 = 0
              ,A.QTY050 = 0
              ,A.QTY051 = 0
              ,A.QTY052 = 0
              ,A.QTY053 = 0
              ,A.QTY054 = 0
              ,A.QTY055 = 0
              ,A.QTY056 = 0
              ,A.QTY057 = 0
              ,A.QTY058 = 0
              ,A.QTY059 = 0
              ,A.QTY060 = 0
              ,A.QTY061 = 0
              ,A.QTY062 = 0
              ,A.QTY063 = 0
              ,A.QTY064 = 0
              ,A.QTY065 = 0
              ,A.QTY066 = 0
              ,A.QTY067 = 0
              ,A.QTY068 = 0
              ,A.QTY069 = 0
              ,A.QTY070 = 0
              ,A.QTY071 = 0
              ,A.QTY072 = 0
              ,A.QTY073 = 0
              ,A.QTY074 = 0
              ,A.QTY075 = 0
              ,A.QTY076 = 0
              ,A.QTY077 = 0
              ,A.QTY078 = 0
              ,A.QTY079 = 0
              ,A.QTY080 = 0
              ,A.QTY081 = 0
              ,A.QTY082 = 0
              ,A.QTY083 = 0
              ,A.QTY084 = 0
              ,A.QTY085 = 0
              ,A.QTY086 = 0
              ,A.QTY087 = 0
              ,A.QTY088 = 0
              ,A.QTY089 = 0
              ,A.QTY090 = 0
              ,A.QTY091 = 0
              ,A.QTY092 = 0
              ,A.QTY093 = 0
              ,A.QTY094 = 0
              ,A.QTY095 = 0
              ,A.QTY096 = 0
              ,A.QTY097 = 0
              ,A.QTY098 = 0
              ,A.QTY099 = 0
              ,A.QTY100 = 0
              ,A.QTY101 = 0
              ,A.QTY102 = 0
              ,A.QTY103 = 0
              ,A.QTY104 = 0
              ,A.QTY105 = 0
              ,A.QTY106 = 0
              ,A.QTY107 = 0
              ,A.QTY108 = 0
              ,A.QTY109 = 0
              ,A.QTY110 = 0
              ,A.QTY111 = 0
              ,A.QTY112 = 0
              ,A.QTY113 = 0
              ,A.QTY114 = 0
              ,A.QTY115 = 0
              ,A.QTY116 = 0
              ,A.QTY117 = 0
              ,A.QTY118 = 0
              ,A.QTY119 = 0
              ,A.QTY120 = 0
              ,A.QTY121 = 0
              ,A.QTY122 = 0
              ,A.QTY123 = 0
              ,A.QTY124 = 0
              ,A.QTY125 = 0
              ,A.QTY126 = 0
              ,A.QTY127 = 0
              ,A.QTY128 = 0
              ,A.QTY129 = 0
              ,A.QTY130 = 0
              ,A.QTY131 = 0
              ,A.QTY132 = 0
              ,A.QTY133 = 0
              ,A.QTY134 = 0
              ,A.QTY135 = 0
              ,A.QTY136 = 0
              ,A.QTY137 = 0
              ,A.QTY138 = 0
              ,A.QTY139 = 0
              ,A.QTY140 = 0
              ,A.QTY141 = 0
              ,A.QTY142 = 0
              ,A.QTY143 = 0
              ,A.QTY144 = 0
              ,A.QTY145 = 0
              ,A.QTY146 = 0
              ,A.QTY147 = 0
              ,A.QTY148 = 0
              ,A.QTY149 = 0
              ,A.QTY150 = 0
              ,A.QTY151 = 0
              ,A.QTY152 = 0
              ,A.QTY153 = 0
              ,A.QTY154 = 0
              ,A.QTY155 = 0
              ,A.QTY156 = 0
              ,A.QTY157 = 0
              ,A.QTY158 = 0
              ,A.QTY159 = 0
              ,A.QTY160 = 0
              ,A.QTY161 = 0
              ,A.QTY162 = 0
              ,A.QTY163 = 0
              ,A.QTY164 = 0
              ,A.QTY165 = 0
              ,A.QTY166 = 0
              ,A.QTY167 = 0
              ,A.QTY168 = 0
              ,A.QTY169 = 0
              ,A.QTY170 = 0
              ,A.QTY171 = 0
              ,A.QTY172 = 0
              ,A.QTY173 = 0
              ,A.QTY174 = 0
              ,A.QTY175 = 0
              ,A.QTY176 = 0
              ,A.QTY177 = 0
              ,A.QTY178 = 0
              ,A.QTY179 = 0
              ,A.QTY180 = 0
              ,A.QTY181 = 0
              ,A.QTY182 = 0
              ,A.QTY183 = 0
              ,A.QTY184 = 0
              ,A.QTY185 = 0
              ,A.QTY186 = 0
              ,A.QTY187 = 0
              ,A.QTY188 = 0
              ,A.QTY189 = 0
              ,A.QTY190 = 0
              ,A.QTY191 = 0
              ,A.QTY192 = 0
              ,A.QTY193 = 0
              ,A.QTY194 = 0
              ,A.QTY195 = 0
              ,A.QTY196 = 0
              ,A.QTY197 = 0
              ,A.QTY198 = 0
              ,A.QTY199 = 0
              ,A.QTY200 = 0
              ,A.QTY201 = 0
              ,A.QTY202 = 0
              ,A.QTY203 = 0
              ,A.QTY204 = 0
              ,A.QTY205 = 0
              ,A.QTY206 = 0
              ,A.QTY207 = 0
              ,A.QTY208 = 0
              ,A.QTY209 = 0
              ,A.QTY210 = 0
              ,A.QTY211 = 0
              ,A.QTY212 = 0
              ,A.QTY213 = 0
              ,A.QTY214 = 0
              ,A.QTY215 = 0
              ,A.QTY216 = 0
              ,A.QTY217 = 0
              ,A.QTY218 = 0
              ,A.QTY219 = 0
              ,A.QTY220 = 0
              ,A.QTY221 = 0
              ,A.QTY222 = 0
              ,A.QTY223 = 0
              ,A.QTY224 = 0
              ,A.QTY225 = 0
              ,A.QTY226 = 0
              ,A.QTY227 = 0
              ,A.QTY228 = 0
              ,A.QTY229 = 0
              ,A.QTY230 = 0
              ,A.QTY231 = 0
              ,A.QTY232 = 0
              ,A.QTY233 = 0
              ,A.QTY234 = 0
              ,A.QTY235 = 0
              ,A.QTY236 = 0
              ,A.QTY237 = 0
              ,A.QTY238 = 0
              ,A.QTY239 = 0
              ,A.QTY240 = 0
              ,A.QTY241 = 0
              ,A.QTY242 = 0
              ,A.QTY243 = 0
              ,A.QTY244 = 0
              ,A.QTY245 = 0
              ,A.QTY246 = 0
              ,A.QTY247 = 0
              ,A.QTY248 = 0
              ,A.QTY249 = 0
              ,A.QTY250 = 0
              ,A.QTY251 = 0
              ,A.QTY252 = 0
              ,A.QTY253 = 0
              ,A.QTY254 = 0
              ,A.QTY255 = 0
              ,A.QTY256 = 0
              ,A.QTY257 = 0
              ,A.QTY258 = 0
              ,A.QTY259 = 0
              ,A.QTY260 = 0
              ,A.QTY261 = 0
              ,A.QTY262 = 0
              ,A.QTY263 = 0
              ,A.QTY264 = 0
              ,A.QTY265 = 0
              ,A.QTY266 = 0
              ,A.QTY267 = 0
              ,A.QTY268 = 0
              ,A.QTY269 = 0
              ,A.QTY270 = 0
              ,A.QTY271 = 0
              ,A.QTY272 = 0
              ,A.QTY273 = 0
              ,A.QTY274 = 0
              ,A.QTY275 = 0
              ,A.QTY276 = 0
              ,A.QTY277 = 0
              ,A.QTY278 = 0
              ,A.QTY279 = 0
              ,A.QTY280 = 0
              ,A.QTY281 = 0
              ,A.QTY282 = 0
              ,A.QTY283 = 0
              ,A.QTY284 = 0
              ,A.QTY285 = 0
              ,A.QTY286 = 0
              ,A.QTY287 = 0
              ,A.QTY288 = 0
              ,A.QTY289 = 0
              ,A.QTY290 = 0
              ,A.QTY291 = 0
              ,A.QTY292 = 0
              ,A.QTY293 = 0
              ,A.QTY294 = 0
              ,A.QTY295 = 0
              ,A.QTY296 = 0
              ,A.QTY297 = 0
              ,A.QTY298 = 0
              ,A.QTY299 = 0
              ,A.QTY300 = 0
              ,A.QTY301 = 0
              ,A.QTY302 = 0
              ,A.QTY303 = 0
              ,A.QTY304 = 0
              ,A.QTY305 = 0
              ,A.QTY306 = 0
              ,A.QTY307 = 0
              ,A.QTY308 = 0
              ,A.QTY309 = 0
              ,A.QTY310 = 0
              ,A.QTY311 = 0
              ,A.QTY312 = 0
              ,A.QTY313 = 0
              ,A.QTY314 = 0
              ,A.QTY315 = 0
              ,A.QTY316 = 0
              ,A.QTY317 = 0
              ,A.QTY318 = 0
              ,A.QTY319 = 0
              ,A.QTY320 = 0
              ,A.QTY321 = 0
              ,A.QTY322 = 0
              ,A.QTY323 = 0
              ,A.QTY324 = 0
              ,A.QTY325 = 0
              ,A.QTY326 = 0
              ,A.QTY327 = 0
              ,A.QTY328 = 0
              ,A.QTY329 = 0
              ,A.QTY330 = 0
              ,A.QTY331 = 0
              ,A.QTY332 = 0
              ,A.QTY333 = 0
              ,A.QTY334 = 0
              ,A.QTY335 = 0
              ,A.QTY336 = 0
              ,A.QTY337 = 0
              ,A.QTY338 = 0
              ,A.QTY339 = 0
              ,A.QTY340 = 0
              ,A.QTY341 = 0
              ,A.QTY342 = 0
              ,A.QTY343 = 0
              ,A.QTY344 = 0
              ,A.QTY345 = 0
              ,A.QTY346 = 0
              ,A.QTY347 = 0
              ,A.QTY348 = 0
              ,A.QTY349 = 0
              ,A.QTY350 = 0
              ,A.QTY351 = 0
              ,A.QTY352 = 0
              ,A.QTY353 = 0
              ,A.QTY354 = 0
              ,A.QTY355 = 0
              ,A.QTY356 = 0
              ,A.QTY357 = 0
              ,A.QTY358 = 0
              ,A.QTY359 = 0
              ,A.QTY360 = 0
              ,A.QTY361 = 0
              ,A.QTY362 = 0
              ,A.QTY363 = 0
              ,A.QTY364 = 0
              ,A.WQTY01 = 0
              ,A.WQTY02 = 0
              ,A.WQTY03 = 0
              ,A.WQTY04 = 0
              ,A.WQTY05 = 0
              ,A.WQTY06 = 0
              ,A.WQTY07 = 0
              ,A.WQTY08 = 0
              ,A.WQTY09 = 0
              ,A.WQTY10 = 0
              ,A.WQTY11 = 0
              ,A.WQTY12 = 0
              ,A.WQTY13 = 0
              ,A.WQTY14 = 0
              ,A.WQTY15 = 0
              ,A.WQTY16 = 0
              ,A.WQTY17 = 0
              ,A.WQTY18 = 0
              ,A.WQTY19 = 0
              ,A.WQTY20 = 0
              ,A.WQTY21 = 0
              ,A.WQTY22 = 0
              ,A.WQTY23 = 0
              ,A.WQTY24 = 0
              ,A.WQTY25 = 0
              ,A.WQTY26 = 0
              ,A.WQTY27 = 0
              ,A.WQTY28 = 0
              ,A.WQTY29 = 0
              ,A.WQTY30 = 0
              ,A.WQTY31 = 0
              ,A.WQTY32 = 0
              ,A.WQTY33 = 0
              ,A.WQTY34 = 0
              ,A.WQTY35 = 0
              ,A.WQTY36 = 0
              ,A.WQTY37 = 0
              ,A.WQTY38 = 0
              ,A.WQTY39 = 0
              ,A.WQTY40 = 0
              ,A.WQTY41 = 0
              ,A.WQTY42 = 0
              ,A.WQTY43 = 0
              ,A.WQTY44 = 0
              ,A.WQTY45 = 0
              ,A.WQTY46 = 0
              ,A.WQTY47 = 0
              ,A.WQTY48 = 0
              ,A.WQTY49 = 0
              ,A.WQTY50 = 0
              ,A.WQTY51 = 0
              ,A.WQTY52 = 0
              ,A.LAST_UPDATED_BY  = V_UPDATE_NAME
              ,A.LAST_UPDATE_DATE = V_NOW_DATE
         WHERE EXISTS (SELECT 1
                         FROM SCP_OPT_ENG_MODEL_LIST_N_SN B
                        WHERE B.SCM_SITE_ID = A.FROM_SITE
                          AND B.ITEM_ID     = A.ITEM_ID
                          AND B.PLAN_ID     = V_PLAN_ID
                      )
           AND A.CREATE_FROM_YYYYMMDD IN (SELECT A.CREATE_FROM_YYYYMMDD
                                            FROM GT_TASM_CFY_TEMP
                                         )   /* AS-IS 그대로 : @CFY_TEMP 에 CREATE_FROM_YYYYMMDD 칸이 없어 바깥 테이블 칸으로 해석됨 */
           AND A.MEASURE IN (SELECT MEASURE
                               FROM GT_TASM_MS_TEMP
                            )
           AND A.OPERATION_GROUP     = 'A'
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_TYPE           = V_SCP_PLAN_TYPE
           AND A.SEQ                 = V_SCP_PLAN_SEQ
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD;
        ------------------------------------------------------------------------
        -- UPDATE SCP_XLS_PSI_GLOBAL_SMALL
        ------------------------------------------------------------------------
        UPDATE SCP_XLS_PSI_GLOBAL_SMALL A
           SET (A.LAST_UPDATED_BY
               ,A.LAST_UPDATE_DATE
               ,A.QTY001
               ,A.QTY002
               ,A.QTY003
               ,A.QTY004
               ,A.QTY005
               ,A.QTY006
               ,A.QTY007
               ,A.QTY008
               ,A.QTY009
               ,A.QTY010
               ,A.QTY011
               ,A.QTY012
               ,A.QTY013
               ,A.QTY014
               ,A.QTY015
               ,A.QTY016
               ,A.QTY017
               ,A.QTY018
               ,A.QTY019
               ,A.QTY020
               ,A.QTY021
               ,A.QTY022
               ,A.QTY023
               ,A.QTY024
               ,A.QTY025
               ,A.QTY026
               ,A.QTY027
               ,A.QTY028
               ,A.QTY029
               ,A.QTY030
               ,A.QTY031
               ,A.QTY032
               ,A.QTY033
               ,A.QTY034
               ,A.QTY035
               ,A.QTY036
               ,A.QTY037
               ,A.QTY038
               ,A.QTY039
               ,A.QTY040
               ,A.QTY041
               ,A.QTY042
               ,A.QTY043
               ,A.QTY044
               ,A.QTY045
               ,A.QTY046
               ,A.QTY047
               ,A.QTY048
               ,A.QTY049
               ,A.QTY050
               ,A.QTY051
               ,A.QTY052
               ,A.QTY053
               ,A.QTY054
               ,A.QTY055
               ,A.QTY056
               ,A.QTY057
               ,A.QTY058
               ,A.QTY059
               ,A.QTY060
               ,A.QTY061
               ,A.QTY062
               ,A.QTY063
               ,A.QTY064
               ,A.QTY065
               ,A.QTY066
               ,A.QTY067
               ,A.QTY068
               ,A.QTY069
               ,A.QTY070
               ,A.QTY071
               ,A.QTY072
               ,A.QTY073
               ,A.QTY074
               ,A.QTY075
               ,A.QTY076
               ,A.QTY077
               ,A.QTY078
               ,A.QTY079
               ,A.QTY080
               ,A.QTY081
               ,A.QTY082
               ,A.QTY083
               ,A.QTY084
               ,A.QTY085
               ,A.QTY086
               ,A.QTY087
               ,A.QTY088
               ,A.QTY089
               ,A.QTY090
               ,A.QTY091
               ,A.QTY092
               ,A.QTY093
               ,A.QTY094
               ,A.QTY095
               ,A.QTY096
               ,A.QTY097
               ,A.QTY098
               ,A.QTY099
               ,A.QTY100
               ,A.QTY101
               ,A.QTY102
               ,A.QTY103
               ,A.QTY104
               ,A.QTY105
               ,A.QTY106
               ,A.QTY107
               ,A.QTY108
               ,A.QTY109
               ,A.QTY110
               ,A.QTY111
               ,A.QTY112
               ,A.QTY113
               ,A.QTY114
               ,A.QTY115
               ,A.QTY116
               ,A.QTY117
               ,A.QTY118
               ,A.QTY119
               ,A.QTY120
               ,A.QTY121
               ,A.QTY122
               ,A.QTY123
               ,A.QTY124
               ,A.QTY125
               ,A.QTY126
               ,A.QTY127
               ,A.QTY128
               ,A.QTY129
               ,A.QTY130
               ,A.QTY131
               ,A.QTY132
               ,A.QTY133
               ,A.QTY134
               ,A.QTY135
               ,A.QTY136
               ,A.QTY137
               ,A.QTY138
               ,A.QTY139
               ,A.QTY140
               ,A.QTY141
               ,A.QTY142
               ,A.QTY143
               ,A.QTY144
               ,A.QTY145
               ,A.QTY146
               ,A.QTY147
               ,A.QTY148
               ,A.QTY149
               ,A.QTY150
               ,A.QTY151
               ,A.QTY152
               ,A.QTY153
               ,A.QTY154
               ,A.QTY155
               ,A.QTY156
               ,A.QTY157
               ,A.QTY158
               ,A.QTY159
               ,A.QTY160
               ,A.QTY161
               ,A.QTY162
               ,A.QTY163
               ,A.QTY164
               ,A.QTY165
               ,A.QTY166
               ,A.QTY167
               ,A.QTY168
               ,A.QTY169
               ,A.QTY170
               ,A.QTY171
               ,A.QTY172
               ,A.QTY173
               ,A.QTY174
               ,A.QTY175
               ,A.QTY176
               ,A.QTY177
               ,A.QTY178
               ,A.QTY179
               ,A.QTY180
               ,A.QTY181
               ,A.QTY182
               ,A.QTY183
               ,A.QTY184
               ,A.QTY185
               ,A.QTY186
               ,A.QTY187
               ,A.QTY188
               ,A.QTY189
               ,A.QTY190
               ,A.QTY191
               ,A.QTY192
               ,A.QTY193
               ,A.QTY194
               ,A.QTY195
               ,A.QTY196
               ,A.QTY197
               ,A.QTY198
               ,A.QTY199
               ,A.QTY200
               ,A.QTY201
               ,A.QTY202
               ,A.QTY203
               ,A.QTY204
               ,A.QTY205
               ,A.QTY206
               ,A.QTY207
               ,A.QTY208
               ,A.QTY209
               ,A.QTY210
               ,A.QTY211
               ,A.QTY212
               ,A.QTY213
               ,A.QTY214
               ,A.QTY215
               ,A.QTY216
               ,A.QTY217
               ,A.QTY218
               ,A.QTY219
               ,A.QTY220
               ,A.QTY221
               ,A.QTY222
               ,A.QTY223
               ,A.QTY224
               ,A.QTY225
               ,A.QTY226
               ,A.QTY227
               ,A.QTY228
               ,A.QTY229
               ,A.QTY230
               ,A.QTY231
               ,A.QTY232
               ,A.QTY233
               ,A.QTY234
               ,A.QTY235
               ,A.QTY236
               ,A.QTY237
               ,A.QTY238
               ,A.QTY239
               ,A.QTY240
               ,A.QTY241
               ,A.QTY242
               ,A.QTY243
               ,A.QTY244
               ,A.QTY245
               ,A.QTY246
               ,A.QTY247
               ,A.QTY248
               ,A.QTY249
               ,A.QTY250
               ,A.QTY251
               ,A.QTY252
               ,A.QTY253
               ,A.QTY254
               ,A.QTY255
               ,A.QTY256
               ,A.QTY257
               ,A.QTY258
               ,A.QTY259
               ,A.QTY260
               ,A.QTY261
               ,A.QTY262
               ,A.QTY263
               ,A.QTY264
               ,A.QTY265
               ,A.QTY266
               ,A.QTY267
               ,A.QTY268
               ,A.QTY269
               ,A.QTY270
               ,A.QTY271
               ,A.QTY272
               ,A.QTY273
               ,A.QTY274
               ,A.QTY275
               ,A.QTY276
               ,A.QTY277
               ,A.QTY278
               ,A.QTY279
               ,A.QTY280
               ,A.QTY281
               ,A.QTY282
               ,A.QTY283
               ,A.QTY284
               ,A.QTY285
               ,A.QTY286
               ,A.QTY287
               ,A.QTY288
               ,A.QTY289
               ,A.QTY290
               ,A.QTY291
               ,A.QTY292
               ,A.QTY293
               ,A.QTY294
               ,A.QTY295
               ,A.QTY296
               ,A.QTY297
               ,A.QTY298
               ,A.QTY299
               ,A.QTY300
               ,A.QTY301
               ,A.QTY302
               ,A.QTY303
               ,A.QTY304
               ,A.QTY305
               ,A.QTY306
               ,A.QTY307
               ,A.QTY308
               ,A.QTY309
               ,A.QTY310
               ,A.QTY311
               ,A.QTY312
               ,A.QTY313
               ,A.QTY314
               ,A.QTY315
               ,A.QTY316
               ,A.QTY317
               ,A.QTY318
               ,A.QTY319
               ,A.QTY320
               ,A.QTY321
               ,A.QTY322
               ,A.QTY323
               ,A.QTY324
               ,A.QTY325
               ,A.QTY326
               ,A.QTY327
               ,A.QTY328
               ,A.QTY329
               ,A.QTY330
               ,A.QTY331
               ,A.QTY332
               ,A.QTY333
               ,A.QTY334
               ,A.QTY335
               ,A.QTY336
               ,A.QTY337
               ,A.QTY338
               ,A.QTY339
               ,A.QTY340
               ,A.QTY341
               ,A.QTY342
               ,A.QTY343
               ,A.QTY344
               ,A.QTY345
               ,A.QTY346
               ,A.QTY347
               ,A.QTY348
               ,A.QTY349
               ,A.QTY350
               ,A.QTY351
               ,A.QTY352
               ,A.QTY353
               ,A.QTY354
               ,A.QTY355
               ,A.QTY356
               ,A.QTY357
               ,A.QTY358
               ,A.QTY359
               ,A.QTY360
               ,A.QTY361
               ,A.QTY362
               ,A.QTY363
               ,A.QTY364
               ,A.WQTY01
               ,A.WQTY02
               ,A.WQTY03
               ,A.WQTY04
               ,A.WQTY05
               ,A.WQTY06
               ,A.WQTY07
               ,A.WQTY08
               ,A.WQTY09
               ,A.WQTY10
               ,A.WQTY11
               ,A.WQTY12
               ,A.WQTY13
               ,A.WQTY14
               ,A.WQTY15
               ,A.WQTY16
               ,A.WQTY17
               ,A.WQTY18
               ,A.WQTY19
               ,A.WQTY20
               ,A.WQTY21
               ,A.WQTY22
               ,A.WQTY23
               ,A.WQTY24
               ,A.WQTY25
               ,A.WQTY26
               ,A.WQTY27
               ,A.WQTY28
               ,A.WQTY29
               ,A.WQTY30
               ,A.WQTY31
               ,A.WQTY32
               ,A.WQTY33
               ,A.WQTY34
               ,A.WQTY35
               ,A.WQTY36
               ,A.WQTY37
               ,A.WQTY38
               ,A.WQTY39
               ,A.WQTY40
               ,A.WQTY41
               ,A.WQTY42
               ,A.WQTY43
               ,A.WQTY44
               ,A.WQTY45
               ,A.WQTY46
               ,A.WQTY47
               ,A.WQTY48
               ,A.WQTY49
               ,A.WQTY50
               ,A.WQTY51
               ,A.WQTY52
               ) = (SELECT V_UPDATE_NAME
                          ,V_NOW_DATE
                          ,B.QTY001
                          ,B.QTY002
                          ,B.QTY003
                          ,B.QTY004
                          ,B.QTY005
                          ,B.QTY006
                          ,B.QTY007
                          ,B.QTY008
                          ,B.QTY009
                          ,B.QTY010
                          ,B.QTY011
                          ,B.QTY012
                          ,B.QTY013
                          ,B.QTY014
                          ,B.QTY015
                          ,B.QTY016
                          ,B.QTY017
                          ,B.QTY018
                          ,B.QTY019
                          ,B.QTY020
                          ,B.QTY021
                          ,B.QTY022
                          ,B.QTY023
                          ,B.QTY024
                          ,B.QTY025
                          ,B.QTY026
                          ,B.QTY027
                          ,B.QTY028
                          ,B.QTY029
                          ,B.QTY030
                          ,B.QTY031
                          ,B.QTY032
                          ,B.QTY033
                          ,B.QTY034
                          ,B.QTY035
                          ,B.QTY036
                          ,B.QTY037
                          ,B.QTY038
                          ,B.QTY039
                          ,B.QTY040
                          ,B.QTY041
                          ,B.QTY042
                          ,B.QTY043
                          ,B.QTY044
                          ,B.QTY045
                          ,B.QTY046
                          ,B.QTY047
                          ,B.QTY048
                          ,B.QTY049
                          ,B.QTY050
                          ,B.QTY051
                          ,B.QTY052
                          ,B.QTY053
                          ,B.QTY054
                          ,B.QTY055
                          ,B.QTY056
                          ,B.QTY057
                          ,B.QTY058
                          ,B.QTY059
                          ,B.QTY060
                          ,B.QTY061
                          ,B.QTY062
                          ,B.QTY063
                          ,B.QTY064
                          ,B.QTY065
                          ,B.QTY066
                          ,B.QTY067
                          ,B.QTY068
                          ,B.QTY069
                          ,B.QTY070
                          ,B.QTY071
                          ,B.QTY072
                          ,B.QTY073
                          ,B.QTY074
                          ,B.QTY075
                          ,B.QTY076
                          ,B.QTY077
                          ,B.QTY078
                          ,B.QTY079
                          ,B.QTY080
                          ,B.QTY081
                          ,B.QTY082
                          ,B.QTY083
                          ,B.QTY084
                          ,B.QTY085
                          ,B.QTY086
                          ,B.QTY087
                          ,B.QTY088
                          ,B.QTY089
                          ,B.QTY090
                          ,B.QTY091
                          ,B.QTY092
                          ,B.QTY093
                          ,B.QTY094
                          ,B.QTY095
                          ,B.QTY096
                          ,B.QTY097
                          ,B.QTY098
                          ,B.QTY099
                          ,B.QTY100
                          ,B.QTY101
                          ,B.QTY102
                          ,B.QTY103
                          ,B.QTY104
                          ,B.QTY105
                          ,B.QTY106
                          ,B.QTY107
                          ,B.QTY108
                          ,B.QTY109
                          ,B.QTY110
                          ,B.QTY111
                          ,B.QTY112
                          ,B.QTY113
                          ,B.QTY114
                          ,B.QTY115
                          ,B.QTY116
                          ,B.QTY117
                          ,B.QTY118
                          ,B.QTY119
                          ,B.QTY120
                          ,B.QTY121
                          ,B.QTY122
                          ,B.QTY123
                          ,B.QTY124
                          ,B.QTY125
                          ,B.QTY126
                          ,B.QTY127
                          ,B.QTY128
                          ,B.QTY129
                          ,B.QTY130
                          ,B.QTY131
                          ,B.QTY132
                          ,B.QTY133
                          ,B.QTY134
                          ,B.QTY135
                          ,B.QTY136
                          ,B.QTY137
                          ,B.QTY138
                          ,B.QTY139
                          ,B.QTY140
                          ,B.QTY141
                          ,B.QTY142
                          ,B.QTY143
                          ,B.QTY144
                          ,B.QTY145
                          ,B.QTY146
                          ,B.QTY147
                          ,B.QTY148
                          ,B.QTY149
                          ,B.QTY150
                          ,B.QTY151
                          ,B.QTY152
                          ,B.QTY153
                          ,B.QTY154
                          ,B.QTY155
                          ,B.QTY156
                          ,B.QTY157
                          ,B.QTY158
                          ,B.QTY159
                          ,B.QTY160
                          ,B.QTY161
                          ,B.QTY162
                          ,B.QTY163
                          ,B.QTY164
                          ,B.QTY165
                          ,B.QTY166
                          ,B.QTY167
                          ,B.QTY168
                          ,B.QTY169
                          ,B.QTY170
                          ,B.QTY171
                          ,B.QTY172
                          ,B.QTY173
                          ,B.QTY174
                          ,B.QTY175
                          ,B.QTY176
                          ,B.QTY177
                          ,B.QTY178
                          ,B.QTY179
                          ,B.QTY180
                          ,B.QTY181
                          ,B.QTY182
                          ,B.QTY183
                          ,B.QTY184
                          ,B.QTY185
                          ,B.QTY186
                          ,B.QTY187
                          ,B.QTY188
                          ,B.QTY189
                          ,B.QTY190
                          ,B.QTY191
                          ,B.QTY192
                          ,B.QTY193
                          ,B.QTY194
                          ,B.QTY195
                          ,B.QTY196
                          ,B.QTY197
                          ,B.QTY198
                          ,B.QTY199
                          ,B.QTY200
                          ,B.QTY201
                          ,B.QTY202
                          ,B.QTY203
                          ,B.QTY204
                          ,B.QTY205
                          ,B.QTY206
                          ,B.QTY207
                          ,B.QTY208
                          ,B.QTY209
                          ,B.QTY210
                          ,B.QTY211
                          ,B.QTY212
                          ,B.QTY213
                          ,B.QTY214
                          ,B.QTY215
                          ,B.QTY216
                          ,B.QTY217
                          ,B.QTY218
                          ,B.QTY219
                          ,B.QTY220
                          ,B.QTY221
                          ,B.QTY222
                          ,B.QTY223
                          ,B.QTY224
                          ,B.QTY225
                          ,B.QTY226
                          ,B.QTY227
                          ,B.QTY228
                          ,B.QTY229
                          ,B.QTY230
                          ,B.QTY231
                          ,B.QTY232
                          ,B.QTY233
                          ,B.QTY234
                          ,B.QTY235
                          ,B.QTY236
                          ,B.QTY237
                          ,B.QTY238
                          ,B.QTY239
                          ,B.QTY240
                          ,B.QTY241
                          ,B.QTY242
                          ,B.QTY243
                          ,B.QTY244
                          ,B.QTY245
                          ,B.QTY246
                          ,B.QTY247
                          ,B.QTY248
                          ,B.QTY249
                          ,B.QTY250
                          ,B.QTY251
                          ,B.QTY252
                          ,B.QTY253
                          ,B.QTY254
                          ,B.QTY255
                          ,B.QTY256
                          ,B.QTY257
                          ,B.QTY258
                          ,B.QTY259
                          ,B.QTY260
                          ,B.QTY261
                          ,B.QTY262
                          ,B.QTY263
                          ,B.QTY264
                          ,B.QTY265
                          ,B.QTY266
                          ,B.QTY267
                          ,B.QTY268
                          ,B.QTY269
                          ,B.QTY270
                          ,B.QTY271
                          ,B.QTY272
                          ,B.QTY273
                          ,B.QTY274
                          ,B.QTY275
                          ,B.QTY276
                          ,B.QTY277
                          ,B.QTY278
                          ,B.QTY279
                          ,B.QTY280
                          ,B.QTY281
                          ,B.QTY282
                          ,B.QTY283
                          ,B.QTY284
                          ,B.QTY285
                          ,B.QTY286
                          ,B.QTY287
                          ,B.QTY288
                          ,B.QTY289
                          ,B.QTY290
                          ,B.QTY291
                          ,B.QTY292
                          ,B.QTY293
                          ,B.QTY294
                          ,B.QTY295
                          ,B.QTY296
                          ,B.QTY297
                          ,B.QTY298
                          ,B.QTY299
                          ,B.QTY300
                          ,B.QTY301
                          ,B.QTY302
                          ,B.QTY303
                          ,B.QTY304
                          ,B.QTY305
                          ,B.QTY306
                          ,B.QTY307
                          ,B.QTY308
                          ,B.QTY309
                          ,B.QTY310
                          ,B.QTY311
                          ,B.QTY312
                          ,B.QTY313
                          ,B.QTY314
                          ,B.QTY315
                          ,B.QTY316
                          ,B.QTY317
                          ,B.QTY318
                          ,B.QTY319
                          ,B.QTY320
                          ,B.QTY321
                          ,B.QTY322
                          ,B.QTY323
                          ,B.QTY324
                          ,B.QTY325
                          ,B.QTY326
                          ,B.QTY327
                          ,B.QTY328
                          ,B.QTY329
                          ,B.QTY330
                          ,B.QTY331
                          ,B.QTY332
                          ,B.QTY333
                          ,B.QTY334
                          ,B.QTY335
                          ,B.QTY336
                          ,B.QTY337
                          ,B.QTY338
                          ,B.QTY339
                          ,B.QTY340
                          ,B.QTY341
                          ,B.QTY342
                          ,B.QTY343
                          ,B.QTY344
                          ,B.QTY345
                          ,B.QTY346
                          ,B.QTY347
                          ,B.QTY348
                          ,B.QTY349
                          ,B.QTY350
                          ,B.QTY351
                          ,B.QTY352
                          ,B.QTY353
                          ,B.QTY354
                          ,B.QTY355
                          ,B.QTY356
                          ,B.QTY357
                          ,B.QTY358
                          ,B.QTY359
                          ,B.QTY360
                          ,B.QTY361
                          ,B.QTY362
                          ,B.QTY363
                          ,B.QTY364
                          ,B.WQTY01
                          ,B.WQTY02
                          ,B.WQTY03
                          ,B.WQTY04
                          ,B.WQTY05
                          ,B.WQTY06
                          ,B.WQTY07
                          ,B.WQTY08
                          ,B.WQTY09
                          ,B.WQTY10
                          ,B.WQTY11
                          ,B.WQTY12
                          ,B.WQTY13
                          ,B.WQTY14
                          ,B.WQTY15
                          ,B.WQTY16
                          ,B.WQTY17
                          ,B.WQTY18
                          ,B.WQTY19
                          ,B.WQTY20
                          ,B.WQTY21
                          ,B.WQTY22
                          ,B.WQTY23
                          ,B.WQTY24
                          ,B.WQTY25
                          ,B.WQTY26
                          ,B.WQTY27
                          ,B.WQTY28
                          ,B.WQTY29
                          ,B.WQTY30
                          ,B.WQTY31
                          ,B.WQTY32
                          ,B.WQTY33
                          ,B.WQTY34
                          ,B.WQTY35
                          ,B.WQTY36
                          ,B.WQTY37
                          ,B.WQTY38
                          ,B.WQTY39
                          ,B.WQTY40
                          ,B.WQTY41
                          ,B.WQTY42
                          ,B.WQTY43
                          ,B.WQTY44
                          ,B.WQTY45
                          ,B.WQTY46
                          ,B.WQTY47
                          ,B.WQTY48
                          ,B.WQTY49
                          ,B.WQTY50
                          ,B.WQTY51
                          ,B.WQTY52
                      FROM GT_TASM_XLS_PV_TABLE B
                     WHERE A.DIVISION_ID          = B.DIVISION_ID
                       AND A.PLAN_START_YYYYMMDD  = B.PLAN_START_YYYYMMDD
                       AND A.PLAN_TYPE            = B.PLAN_TYPE
                       AND A.SEQ                  = B.SEQ
                       AND A.OPERATION_GROUP      = B.OPERATION_GROUP
                       AND A.FROM_SITE            = B.FROM_SITE
                       AND A.ITEM_ID              = B.ITEM_ID
                       AND A.PROD_LINE            = B.LINE_ID
                       AND A.BOD_ID               = B.BOD_ID
                       AND A.MEASURE              = B.MEASURE
                       AND A.PROJECT_CODE         = B.PROJECT_CODE
                       AND A.CREATE_FROM_YYYYMMDD = B.CREATE_FROM_YYYYMMDD
                       AND ROWNUM = 1
                   )
         WHERE EXISTS (SELECT 1
                         FROM GT_TASM_XLS_PV_TABLE C
                        WHERE A.DIVISION_ID          = C.DIVISION_ID
                          AND A.PLAN_START_YYYYMMDD  = C.PLAN_START_YYYYMMDD
                          AND A.PLAN_TYPE            = C.PLAN_TYPE
                          AND A.SEQ                  = C.SEQ
                          AND A.OPERATION_GROUP      = C.OPERATION_GROUP
                          AND A.FROM_SITE            = C.FROM_SITE
                          AND A.ITEM_ID              = C.ITEM_ID
                          AND A.PROD_LINE            = C.LINE_ID
                          AND A.BOD_ID               = C.BOD_ID
                          AND A.MEASURE              = C.MEASURE
                          AND A.PROJECT_CODE         = C.PROJECT_CODE
                          AND A.CREATE_FROM_YYYYMMDD = C.CREATE_FROM_YYYYMMDD
                      )
           AND A.OPERATION_GROUP = 'A';


        ------------------------------------------------------------------------
        -- Initialization Qty
        ------------------------------------------------------------------------
        -- 소형 SMALL_PACK 테이블 Init
        ------------------------------------------------------------------------
        UPDATE SCP_XLS_PSI_GLOBAL_SMALL_PACK A
           SET A.QTY001 = 0
              ,A.QTY002 = 0
              ,A.QTY003 = 0
              ,A.QTY004 = 0
              ,A.QTY005 = 0
              ,A.QTY006 = 0
              ,A.QTY007 = 0
              ,A.QTY008 = 0
              ,A.QTY009 = 0
              ,A.QTY010 = 0
              ,A.QTY011 = 0
              ,A.QTY012 = 0
              ,A.QTY013 = 0
              ,A.QTY014 = 0
              ,A.QTY015 = 0
              ,A.QTY016 = 0
              ,A.QTY017 = 0
              ,A.QTY018 = 0
              ,A.QTY019 = 0
              ,A.QTY020 = 0
              ,A.QTY021 = 0
              ,A.QTY022 = 0
              ,A.QTY023 = 0
              ,A.QTY024 = 0
              ,A.QTY025 = 0
              ,A.QTY026 = 0
              ,A.QTY027 = 0
              ,A.QTY028 = 0
              ,A.QTY029 = 0
              ,A.QTY030 = 0
              ,A.QTY031 = 0
              ,A.QTY032 = 0
              ,A.QTY033 = 0
              ,A.QTY034 = 0
              ,A.QTY035 = 0
              ,A.QTY036 = 0
              ,A.QTY037 = 0
              ,A.QTY038 = 0
              ,A.QTY039 = 0
              ,A.QTY040 = 0
              ,A.QTY041 = 0
              ,A.QTY042 = 0
              ,A.QTY043 = 0
              ,A.QTY044 = 0
              ,A.QTY045 = 0
              ,A.QTY046 = 0
              ,A.QTY047 = 0
              ,A.QTY048 = 0
              ,A.QTY049 = 0
              ,A.QTY050 = 0
              ,A.QTY051 = 0
              ,A.QTY052 = 0
              ,A.QTY053 = 0
              ,A.QTY054 = 0
              ,A.QTY055 = 0
              ,A.QTY056 = 0
              ,A.QTY057 = 0
              ,A.QTY058 = 0
              ,A.QTY059 = 0
              ,A.QTY060 = 0
              ,A.QTY061 = 0
              ,A.QTY062 = 0
              ,A.QTY063 = 0
              ,A.QTY064 = 0
              ,A.QTY065 = 0
              ,A.QTY066 = 0
              ,A.QTY067 = 0
              ,A.QTY068 = 0
              ,A.QTY069 = 0
              ,A.QTY070 = 0
              ,A.QTY071 = 0
              ,A.QTY072 = 0
              ,A.QTY073 = 0
              ,A.QTY074 = 0
              ,A.QTY075 = 0
              ,A.QTY076 = 0
              ,A.QTY077 = 0
              ,A.QTY078 = 0
              ,A.QTY079 = 0
              ,A.QTY080 = 0
              ,A.QTY081 = 0
              ,A.QTY082 = 0
              ,A.QTY083 = 0
              ,A.QTY084 = 0
              ,A.QTY085 = 0
              ,A.QTY086 = 0
              ,A.QTY087 = 0
              ,A.QTY088 = 0
              ,A.QTY089 = 0
              ,A.QTY090 = 0
              ,A.QTY091 = 0
              ,A.QTY092 = 0
              ,A.QTY093 = 0
              ,A.QTY094 = 0
              ,A.QTY095 = 0
              ,A.QTY096 = 0
              ,A.QTY097 = 0
              ,A.QTY098 = 0
              ,A.QTY099 = 0
              ,A.QTY100 = 0
              ,A.QTY101 = 0
              ,A.QTY102 = 0
              ,A.QTY103 = 0
              ,A.QTY104 = 0
              ,A.QTY105 = 0
              ,A.QTY106 = 0
              ,A.QTY107 = 0
              ,A.QTY108 = 0
              ,A.QTY109 = 0
              ,A.QTY110 = 0
              ,A.QTY111 = 0
              ,A.QTY112 = 0
              ,A.QTY113 = 0
              ,A.QTY114 = 0
              ,A.QTY115 = 0
              ,A.QTY116 = 0
              ,A.QTY117 = 0
              ,A.QTY118 = 0
              ,A.QTY119 = 0
              ,A.QTY120 = 0
              ,A.QTY121 = 0
              ,A.QTY122 = 0
              ,A.QTY123 = 0
              ,A.QTY124 = 0
              ,A.QTY125 = 0
              ,A.QTY126 = 0
              ,A.QTY127 = 0
              ,A.QTY128 = 0
              ,A.QTY129 = 0
              ,A.QTY130 = 0
              ,A.QTY131 = 0
              ,A.QTY132 = 0
              ,A.QTY133 = 0
              ,A.QTY134 = 0
              ,A.QTY135 = 0
              ,A.QTY136 = 0
              ,A.QTY137 = 0
              ,A.QTY138 = 0
              ,A.QTY139 = 0
              ,A.QTY140 = 0
              ,A.QTY141 = 0
              ,A.QTY142 = 0
              ,A.QTY143 = 0
              ,A.QTY144 = 0
              ,A.QTY145 = 0
              ,A.QTY146 = 0
              ,A.QTY147 = 0
              ,A.QTY148 = 0
              ,A.QTY149 = 0
              ,A.QTY150 = 0
              ,A.QTY151 = 0
              ,A.QTY152 = 0
              ,A.QTY153 = 0
              ,A.QTY154 = 0
              ,A.QTY155 = 0
              ,A.QTY156 = 0
              ,A.QTY157 = 0
              ,A.QTY158 = 0
              ,A.QTY159 = 0
              ,A.QTY160 = 0
              ,A.QTY161 = 0
              ,A.QTY162 = 0
              ,A.QTY163 = 0
              ,A.QTY164 = 0
              ,A.QTY165 = 0
              ,A.QTY166 = 0
              ,A.QTY167 = 0
              ,A.QTY168 = 0
              ,A.QTY169 = 0
              ,A.QTY170 = 0
              ,A.QTY171 = 0
              ,A.QTY172 = 0
              ,A.QTY173 = 0
              ,A.QTY174 = 0
              ,A.QTY175 = 0
              ,A.QTY176 = 0
              ,A.QTY177 = 0
              ,A.QTY178 = 0
              ,A.QTY179 = 0
              ,A.QTY180 = 0
              ,A.QTY181 = 0
              ,A.QTY182 = 0
              ,A.QTY183 = 0
              ,A.QTY184 = 0
              ,A.QTY185 = 0
              ,A.QTY186 = 0
              ,A.QTY187 = 0
              ,A.QTY188 = 0
              ,A.QTY189 = 0
              ,A.QTY190 = 0
              ,A.QTY191 = 0
              ,A.QTY192 = 0
              ,A.QTY193 = 0
              ,A.QTY194 = 0
              ,A.QTY195 = 0
              ,A.QTY196 = 0
              ,A.QTY197 = 0
              ,A.QTY198 = 0
              ,A.QTY199 = 0
              ,A.QTY200 = 0
              ,A.QTY201 = 0
              ,A.QTY202 = 0
              ,A.QTY203 = 0
              ,A.QTY204 = 0
              ,A.QTY205 = 0
              ,A.QTY206 = 0
              ,A.QTY207 = 0
              ,A.QTY208 = 0
              ,A.QTY209 = 0
              ,A.QTY210 = 0
              ,A.QTY211 = 0
              ,A.QTY212 = 0
              ,A.QTY213 = 0
              ,A.QTY214 = 0
              ,A.QTY215 = 0
              ,A.QTY216 = 0
              ,A.QTY217 = 0
              ,A.QTY218 = 0
              ,A.QTY219 = 0
              ,A.QTY220 = 0
              ,A.QTY221 = 0
              ,A.QTY222 = 0
              ,A.QTY223 = 0
              ,A.QTY224 = 0
              ,A.QTY225 = 0
              ,A.QTY226 = 0
              ,A.QTY227 = 0
              ,A.QTY228 = 0
              ,A.QTY229 = 0
              ,A.QTY230 = 0
              ,A.QTY231 = 0
              ,A.QTY232 = 0
              ,A.QTY233 = 0
              ,A.QTY234 = 0
              ,A.QTY235 = 0
              ,A.QTY236 = 0
              ,A.QTY237 = 0
              ,A.QTY238 = 0
              ,A.QTY239 = 0
              ,A.QTY240 = 0
              ,A.QTY241 = 0
              ,A.QTY242 = 0
              ,A.QTY243 = 0
              ,A.QTY244 = 0
              ,A.QTY245 = 0
              ,A.QTY246 = 0
              ,A.QTY247 = 0
              ,A.QTY248 = 0
              ,A.QTY249 = 0
              ,A.QTY250 = 0
              ,A.QTY251 = 0
              ,A.QTY252 = 0
              ,A.QTY253 = 0
              ,A.QTY254 = 0
              ,A.QTY255 = 0
              ,A.QTY256 = 0
              ,A.QTY257 = 0
              ,A.QTY258 = 0
              ,A.QTY259 = 0
              ,A.QTY260 = 0
              ,A.QTY261 = 0
              ,A.QTY262 = 0
              ,A.QTY263 = 0
              ,A.QTY264 = 0
              ,A.QTY265 = 0
              ,A.QTY266 = 0
              ,A.QTY267 = 0
              ,A.QTY268 = 0
              ,A.QTY269 = 0
              ,A.QTY270 = 0
              ,A.QTY271 = 0
              ,A.QTY272 = 0
              ,A.QTY273 = 0
              ,A.QTY274 = 0
              ,A.QTY275 = 0
              ,A.QTY276 = 0
              ,A.QTY277 = 0
              ,A.QTY278 = 0
              ,A.QTY279 = 0
              ,A.QTY280 = 0
              ,A.QTY281 = 0
              ,A.QTY282 = 0
              ,A.QTY283 = 0
              ,A.QTY284 = 0
              ,A.QTY285 = 0
              ,A.QTY286 = 0
              ,A.QTY287 = 0
              ,A.QTY288 = 0
              ,A.QTY289 = 0
              ,A.QTY290 = 0
              ,A.QTY291 = 0
              ,A.QTY292 = 0
              ,A.QTY293 = 0
              ,A.QTY294 = 0
              ,A.QTY295 = 0
              ,A.QTY296 = 0
              ,A.QTY297 = 0
              ,A.QTY298 = 0
              ,A.QTY299 = 0
              ,A.QTY300 = 0
              ,A.QTY301 = 0
              ,A.QTY302 = 0
              ,A.QTY303 = 0
              ,A.QTY304 = 0
              ,A.QTY305 = 0
              ,A.QTY306 = 0
              ,A.QTY307 = 0
              ,A.QTY308 = 0
              ,A.QTY309 = 0
              ,A.QTY310 = 0
              ,A.QTY311 = 0
              ,A.QTY312 = 0
              ,A.QTY313 = 0
              ,A.QTY314 = 0
              ,A.QTY315 = 0
              ,A.QTY316 = 0
              ,A.QTY317 = 0
              ,A.QTY318 = 0
              ,A.QTY319 = 0
              ,A.QTY320 = 0
              ,A.QTY321 = 0
              ,A.QTY322 = 0
              ,A.QTY323 = 0
              ,A.QTY324 = 0
              ,A.QTY325 = 0
              ,A.QTY326 = 0
              ,A.QTY327 = 0
              ,A.QTY328 = 0
              ,A.QTY329 = 0
              ,A.QTY330 = 0
              ,A.QTY331 = 0
              ,A.QTY332 = 0
              ,A.QTY333 = 0
              ,A.QTY334 = 0
              ,A.QTY335 = 0
              ,A.QTY336 = 0
              ,A.QTY337 = 0
              ,A.QTY338 = 0
              ,A.QTY339 = 0
              ,A.QTY340 = 0
              ,A.QTY341 = 0
              ,A.QTY342 = 0
              ,A.QTY343 = 0
              ,A.QTY344 = 0
              ,A.QTY345 = 0
              ,A.QTY346 = 0
              ,A.QTY347 = 0
              ,A.QTY348 = 0
              ,A.QTY349 = 0
              ,A.QTY350 = 0
              ,A.QTY351 = 0
              ,A.QTY352 = 0
              ,A.QTY353 = 0
              ,A.QTY354 = 0
              ,A.QTY355 = 0
              ,A.QTY356 = 0
              ,A.QTY357 = 0
              ,A.QTY358 = 0
              ,A.QTY359 = 0
              ,A.QTY360 = 0
              ,A.QTY361 = 0
              ,A.QTY362 = 0
              ,A.QTY363 = 0
              ,A.QTY364 = 0
              ,A.WQTY01 = 0
              ,A.WQTY02 = 0
              ,A.WQTY03 = 0
              ,A.WQTY04 = 0
              ,A.WQTY05 = 0
              ,A.WQTY06 = 0
              ,A.WQTY07 = 0
              ,A.WQTY08 = 0
              ,A.WQTY09 = 0
              ,A.WQTY10 = 0
              ,A.WQTY11 = 0
              ,A.WQTY12 = 0
              ,A.WQTY13 = 0
              ,A.WQTY14 = 0
              ,A.WQTY15 = 0
              ,A.WQTY16 = 0
              ,A.WQTY17 = 0
              ,A.WQTY18 = 0
              ,A.WQTY19 = 0
              ,A.WQTY20 = 0
              ,A.WQTY21 = 0
              ,A.WQTY22 = 0
              ,A.WQTY23 = 0
              ,A.WQTY24 = 0
              ,A.WQTY25 = 0
              ,A.WQTY26 = 0
              ,A.WQTY27 = 0
              ,A.WQTY28 = 0
              ,A.WQTY29 = 0
              ,A.WQTY30 = 0
              ,A.WQTY31 = 0
              ,A.WQTY32 = 0
              ,A.WQTY33 = 0
              ,A.WQTY34 = 0
              ,A.WQTY35 = 0
              ,A.WQTY36 = 0
              ,A.WQTY37 = 0
              ,A.WQTY38 = 0
              ,A.WQTY39 = 0
              ,A.WQTY40 = 0
              ,A.WQTY41 = 0
              ,A.WQTY42 = 0
              ,A.WQTY43 = 0
              ,A.WQTY44 = 0
              ,A.WQTY45 = 0
              ,A.WQTY46 = 0
              ,A.WQTY47 = 0
              ,A.WQTY48 = 0
              ,A.WQTY49 = 0
              ,A.WQTY50 = 0
              ,A.WQTY51 = 0
              ,A.WQTY52 = 0
              ,A.LAST_UPDATED_BY  = V_UPDATE_NAME
              ,A.LAST_UPDATE_DATE = V_NOW_DATE
         WHERE EXISTS (SELECT 1
                         FROM SCP_OPT_ENG_MODEL_LIST_N_SN B
                        WHERE B.SCM_SITE_ID = A.FROM_SITE
                          AND B.ITEM_ID     = A.ITEM_ID
                          AND B.PLAN_ID     = V_PLAN_ID
                      )
           AND A.CREATE_FROM_YYYYMMDD IN (SELECT A.CREATE_FROM_YYYYMMDD
                                            FROM GT_TASM_CFY_TEMP
                                         )   /* AS-IS 그대로 : @CFY_TEMP 에 CREATE_FROM_YYYYMMDD 칸이 없어 바깥 테이블 칸으로 해석됨 */
           AND A.MEASURE IN (SELECT MEASURE
                               FROM GT_TASM_MS_TEMP
                            )
           AND A.OPERATION_GROUP     = 'A'
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_TYPE           = V_SCP_PLAN_TYPE
           AND A.SEQ                 = V_SCP_PLAN_SEQ
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD;
        ------------------------------------------------------------------------
        -- UPDATE SCP_XLS_PSI_GLOBAL_SMALL_PACK
        ------------------------------------------------------------------------
        UPDATE SCP_XLS_PSI_GLOBAL_SMALL_PACK A
           SET (A.LAST_UPDATED_BY
               ,A.LAST_UPDATE_DATE
               ,A.QTY001
               ,A.QTY002
               ,A.QTY003
               ,A.QTY004
               ,A.QTY005
               ,A.QTY006
               ,A.QTY007
               ,A.QTY008
               ,A.QTY009
               ,A.QTY010
               ,A.QTY011
               ,A.QTY012
               ,A.QTY013
               ,A.QTY014
               ,A.QTY015
               ,A.QTY016
               ,A.QTY017
               ,A.QTY018
               ,A.QTY019
               ,A.QTY020
               ,A.QTY021
               ,A.QTY022
               ,A.QTY023
               ,A.QTY024
               ,A.QTY025
               ,A.QTY026
               ,A.QTY027
               ,A.QTY028
               ,A.QTY029
               ,A.QTY030
               ,A.QTY031
               ,A.QTY032
               ,A.QTY033
               ,A.QTY034
               ,A.QTY035
               ,A.QTY036
               ,A.QTY037
               ,A.QTY038
               ,A.QTY039
               ,A.QTY040
               ,A.QTY041
               ,A.QTY042
               ,A.QTY043
               ,A.QTY044
               ,A.QTY045
               ,A.QTY046
               ,A.QTY047
               ,A.QTY048
               ,A.QTY049
               ,A.QTY050
               ,A.QTY051
               ,A.QTY052
               ,A.QTY053
               ,A.QTY054
               ,A.QTY055
               ,A.QTY056
               ,A.QTY057
               ,A.QTY058
               ,A.QTY059
               ,A.QTY060
               ,A.QTY061
               ,A.QTY062
               ,A.QTY063
               ,A.QTY064
               ,A.QTY065
               ,A.QTY066
               ,A.QTY067
               ,A.QTY068
               ,A.QTY069
               ,A.QTY070
               ,A.QTY071
               ,A.QTY072
               ,A.QTY073
               ,A.QTY074
               ,A.QTY075
               ,A.QTY076
               ,A.QTY077
               ,A.QTY078
               ,A.QTY079
               ,A.QTY080
               ,A.QTY081
               ,A.QTY082
               ,A.QTY083
               ,A.QTY084
               ,A.QTY085
               ,A.QTY086
               ,A.QTY087
               ,A.QTY088
               ,A.QTY089
               ,A.QTY090
               ,A.QTY091
               ,A.QTY092
               ,A.QTY093
               ,A.QTY094
               ,A.QTY095
               ,A.QTY096
               ,A.QTY097
               ,A.QTY098
               ,A.QTY099
               ,A.QTY100
               ,A.QTY101
               ,A.QTY102
               ,A.QTY103
               ,A.QTY104
               ,A.QTY105
               ,A.QTY106
               ,A.QTY107
               ,A.QTY108
               ,A.QTY109
               ,A.QTY110
               ,A.QTY111
               ,A.QTY112
               ,A.QTY113
               ,A.QTY114
               ,A.QTY115
               ,A.QTY116
               ,A.QTY117
               ,A.QTY118
               ,A.QTY119
               ,A.QTY120
               ,A.QTY121
               ,A.QTY122
               ,A.QTY123
               ,A.QTY124
               ,A.QTY125
               ,A.QTY126
               ,A.QTY127
               ,A.QTY128
               ,A.QTY129
               ,A.QTY130
               ,A.QTY131
               ,A.QTY132
               ,A.QTY133
               ,A.QTY134
               ,A.QTY135
               ,A.QTY136
               ,A.QTY137
               ,A.QTY138
               ,A.QTY139
               ,A.QTY140
               ,A.QTY141
               ,A.QTY142
               ,A.QTY143
               ,A.QTY144
               ,A.QTY145
               ,A.QTY146
               ,A.QTY147
               ,A.QTY148
               ,A.QTY149
               ,A.QTY150
               ,A.QTY151
               ,A.QTY152
               ,A.QTY153
               ,A.QTY154
               ,A.QTY155
               ,A.QTY156
               ,A.QTY157
               ,A.QTY158
               ,A.QTY159
               ,A.QTY160
               ,A.QTY161
               ,A.QTY162
               ,A.QTY163
               ,A.QTY164
               ,A.QTY165
               ,A.QTY166
               ,A.QTY167
               ,A.QTY168
               ,A.QTY169
               ,A.QTY170
               ,A.QTY171
               ,A.QTY172
               ,A.QTY173
               ,A.QTY174
               ,A.QTY175
               ,A.QTY176
               ,A.QTY177
               ,A.QTY178
               ,A.QTY179
               ,A.QTY180
               ,A.QTY181
               ,A.QTY182
               ,A.QTY183
               ,A.QTY184
               ,A.QTY185
               ,A.QTY186
               ,A.QTY187
               ,A.QTY188
               ,A.QTY189
               ,A.QTY190
               ,A.QTY191
               ,A.QTY192
               ,A.QTY193
               ,A.QTY194
               ,A.QTY195
               ,A.QTY196
               ,A.QTY197
               ,A.QTY198
               ,A.QTY199
               ,A.QTY200
               ,A.QTY201
               ,A.QTY202
               ,A.QTY203
               ,A.QTY204
               ,A.QTY205
               ,A.QTY206
               ,A.QTY207
               ,A.QTY208
               ,A.QTY209
               ,A.QTY210
               ,A.QTY211
               ,A.QTY212
               ,A.QTY213
               ,A.QTY214
               ,A.QTY215
               ,A.QTY216
               ,A.QTY217
               ,A.QTY218
               ,A.QTY219
               ,A.QTY220
               ,A.QTY221
               ,A.QTY222
               ,A.QTY223
               ,A.QTY224
               ,A.QTY225
               ,A.QTY226
               ,A.QTY227
               ,A.QTY228
               ,A.QTY229
               ,A.QTY230
               ,A.QTY231
               ,A.QTY232
               ,A.QTY233
               ,A.QTY234
               ,A.QTY235
               ,A.QTY236
               ,A.QTY237
               ,A.QTY238
               ,A.QTY239
               ,A.QTY240
               ,A.QTY241
               ,A.QTY242
               ,A.QTY243
               ,A.QTY244
               ,A.QTY245
               ,A.QTY246
               ,A.QTY247
               ,A.QTY248
               ,A.QTY249
               ,A.QTY250
               ,A.QTY251
               ,A.QTY252
               ,A.QTY253
               ,A.QTY254
               ,A.QTY255
               ,A.QTY256
               ,A.QTY257
               ,A.QTY258
               ,A.QTY259
               ,A.QTY260
               ,A.QTY261
               ,A.QTY262
               ,A.QTY263
               ,A.QTY264
               ,A.QTY265
               ,A.QTY266
               ,A.QTY267
               ,A.QTY268
               ,A.QTY269
               ,A.QTY270
               ,A.QTY271
               ,A.QTY272
               ,A.QTY273
               ,A.QTY274
               ,A.QTY275
               ,A.QTY276
               ,A.QTY277
               ,A.QTY278
               ,A.QTY279
               ,A.QTY280
               ,A.QTY281
               ,A.QTY282
               ,A.QTY283
               ,A.QTY284
               ,A.QTY285
               ,A.QTY286
               ,A.QTY287
               ,A.QTY288
               ,A.QTY289
               ,A.QTY290
               ,A.QTY291
               ,A.QTY292
               ,A.QTY293
               ,A.QTY294
               ,A.QTY295
               ,A.QTY296
               ,A.QTY297
               ,A.QTY298
               ,A.QTY299
               ,A.QTY300
               ,A.QTY301
               ,A.QTY302
               ,A.QTY303
               ,A.QTY304
               ,A.QTY305
               ,A.QTY306
               ,A.QTY307
               ,A.QTY308
               ,A.QTY309
               ,A.QTY310
               ,A.QTY311
               ,A.QTY312
               ,A.QTY313
               ,A.QTY314
               ,A.QTY315
               ,A.QTY316
               ,A.QTY317
               ,A.QTY318
               ,A.QTY319
               ,A.QTY320
               ,A.QTY321
               ,A.QTY322
               ,A.QTY323
               ,A.QTY324
               ,A.QTY325
               ,A.QTY326
               ,A.QTY327
               ,A.QTY328
               ,A.QTY329
               ,A.QTY330
               ,A.QTY331
               ,A.QTY332
               ,A.QTY333
               ,A.QTY334
               ,A.QTY335
               ,A.QTY336
               ,A.QTY337
               ,A.QTY338
               ,A.QTY339
               ,A.QTY340
               ,A.QTY341
               ,A.QTY342
               ,A.QTY343
               ,A.QTY344
               ,A.QTY345
               ,A.QTY346
               ,A.QTY347
               ,A.QTY348
               ,A.QTY349
               ,A.QTY350
               ,A.QTY351
               ,A.QTY352
               ,A.QTY353
               ,A.QTY354
               ,A.QTY355
               ,A.QTY356
               ,A.QTY357
               ,A.QTY358
               ,A.QTY359
               ,A.QTY360
               ,A.QTY361
               ,A.QTY362
               ,A.QTY363
               ,A.QTY364
               ,A.WQTY01
               ,A.WQTY02
               ,A.WQTY03
               ,A.WQTY04
               ,A.WQTY05
               ,A.WQTY06
               ,A.WQTY07
               ,A.WQTY08
               ,A.WQTY09
               ,A.WQTY10
               ,A.WQTY11
               ,A.WQTY12
               ,A.WQTY13
               ,A.WQTY14
               ,A.WQTY15
               ,A.WQTY16
               ,A.WQTY17
               ,A.WQTY18
               ,A.WQTY19
               ,A.WQTY20
               ,A.WQTY21
               ,A.WQTY22
               ,A.WQTY23
               ,A.WQTY24
               ,A.WQTY25
               ,A.WQTY26
               ,A.WQTY27
               ,A.WQTY28
               ,A.WQTY29
               ,A.WQTY30
               ,A.WQTY31
               ,A.WQTY32
               ,A.WQTY33
               ,A.WQTY34
               ,A.WQTY35
               ,A.WQTY36
               ,A.WQTY37
               ,A.WQTY38
               ,A.WQTY39
               ,A.WQTY40
               ,A.WQTY41
               ,A.WQTY42
               ,A.WQTY43
               ,A.WQTY44
               ,A.WQTY45
               ,A.WQTY46
               ,A.WQTY47
               ,A.WQTY48
               ,A.WQTY49
               ,A.WQTY50
               ,A.WQTY51
               ,A.WQTY52
               ) = (SELECT V_UPDATE_NAME
                          ,V_NOW_DATE
                          ,B.QTY001
                          ,B.QTY002
                          ,B.QTY003
                          ,B.QTY004
                          ,B.QTY005
                          ,B.QTY006
                          ,B.QTY007
                          ,B.QTY008
                          ,B.QTY009
                          ,B.QTY010
                          ,B.QTY011
                          ,B.QTY012
                          ,B.QTY013
                          ,B.QTY014
                          ,B.QTY015
                          ,B.QTY016
                          ,B.QTY017
                          ,B.QTY018
                          ,B.QTY019
                          ,B.QTY020
                          ,B.QTY021
                          ,B.QTY022
                          ,B.QTY023
                          ,B.QTY024
                          ,B.QTY025
                          ,B.QTY026
                          ,B.QTY027
                          ,B.QTY028
                          ,B.QTY029
                          ,B.QTY030
                          ,B.QTY031
                          ,B.QTY032
                          ,B.QTY033
                          ,B.QTY034
                          ,B.QTY035
                          ,B.QTY036
                          ,B.QTY037
                          ,B.QTY038
                          ,B.QTY039
                          ,B.QTY040
                          ,B.QTY041
                          ,B.QTY042
                          ,B.QTY043
                          ,B.QTY044
                          ,B.QTY045
                          ,B.QTY046
                          ,B.QTY047
                          ,B.QTY048
                          ,B.QTY049
                          ,B.QTY050
                          ,B.QTY051
                          ,B.QTY052
                          ,B.QTY053
                          ,B.QTY054
                          ,B.QTY055
                          ,B.QTY056
                          ,B.QTY057
                          ,B.QTY058
                          ,B.QTY059
                          ,B.QTY060
                          ,B.QTY061
                          ,B.QTY062
                          ,B.QTY063
                          ,B.QTY064
                          ,B.QTY065
                          ,B.QTY066
                          ,B.QTY067
                          ,B.QTY068
                          ,B.QTY069
                          ,B.QTY070
                          ,B.QTY071
                          ,B.QTY072
                          ,B.QTY073
                          ,B.QTY074
                          ,B.QTY075
                          ,B.QTY076
                          ,B.QTY077
                          ,B.QTY078
                          ,B.QTY079
                          ,B.QTY080
                          ,B.QTY081
                          ,B.QTY082
                          ,B.QTY083
                          ,B.QTY084
                          ,B.QTY085
                          ,B.QTY086
                          ,B.QTY087
                          ,B.QTY088
                          ,B.QTY089
                          ,B.QTY090
                          ,B.QTY091
                          ,B.QTY092
                          ,B.QTY093
                          ,B.QTY094
                          ,B.QTY095
                          ,B.QTY096
                          ,B.QTY097
                          ,B.QTY098
                          ,B.QTY099
                          ,B.QTY100
                          ,B.QTY101
                          ,B.QTY102
                          ,B.QTY103
                          ,B.QTY104
                          ,B.QTY105
                          ,B.QTY106
                          ,B.QTY107
                          ,B.QTY108
                          ,B.QTY109
                          ,B.QTY110
                          ,B.QTY111
                          ,B.QTY112
                          ,B.QTY113
                          ,B.QTY114
                          ,B.QTY115
                          ,B.QTY116
                          ,B.QTY117
                          ,B.QTY118
                          ,B.QTY119
                          ,B.QTY120
                          ,B.QTY121
                          ,B.QTY122
                          ,B.QTY123
                          ,B.QTY124
                          ,B.QTY125
                          ,B.QTY126
                          ,B.QTY127
                          ,B.QTY128
                          ,B.QTY129
                          ,B.QTY130
                          ,B.QTY131
                          ,B.QTY132
                          ,B.QTY133
                          ,B.QTY134
                          ,B.QTY135
                          ,B.QTY136
                          ,B.QTY137
                          ,B.QTY138
                          ,B.QTY139
                          ,B.QTY140
                          ,B.QTY141
                          ,B.QTY142
                          ,B.QTY143
                          ,B.QTY144
                          ,B.QTY145
                          ,B.QTY146
                          ,B.QTY147
                          ,B.QTY148
                          ,B.QTY149
                          ,B.QTY150
                          ,B.QTY151
                          ,B.QTY152
                          ,B.QTY153
                          ,B.QTY154
                          ,B.QTY155
                          ,B.QTY156
                          ,B.QTY157
                          ,B.QTY158
                          ,B.QTY159
                          ,B.QTY160
                          ,B.QTY161
                          ,B.QTY162
                          ,B.QTY163
                          ,B.QTY164
                          ,B.QTY165
                          ,B.QTY166
                          ,B.QTY167
                          ,B.QTY168
                          ,B.QTY169
                          ,B.QTY170
                          ,B.QTY171
                          ,B.QTY172
                          ,B.QTY173
                          ,B.QTY174
                          ,B.QTY175
                          ,B.QTY176
                          ,B.QTY177
                          ,B.QTY178
                          ,B.QTY179
                          ,B.QTY180
                          ,B.QTY181
                          ,B.QTY182
                          ,B.QTY183
                          ,B.QTY184
                          ,B.QTY185
                          ,B.QTY186
                          ,B.QTY187
                          ,B.QTY188
                          ,B.QTY189
                          ,B.QTY190
                          ,B.QTY191
                          ,B.QTY192
                          ,B.QTY193
                          ,B.QTY194
                          ,B.QTY195
                          ,B.QTY196
                          ,B.QTY197
                          ,B.QTY198
                          ,B.QTY199
                          ,B.QTY200
                          ,B.QTY201
                          ,B.QTY202
                          ,B.QTY203
                          ,B.QTY204
                          ,B.QTY205
                          ,B.QTY206
                          ,B.QTY207
                          ,B.QTY208
                          ,B.QTY209
                          ,B.QTY210
                          ,B.QTY211
                          ,B.QTY212
                          ,B.QTY213
                          ,B.QTY214
                          ,B.QTY215
                          ,B.QTY216
                          ,B.QTY217
                          ,B.QTY218
                          ,B.QTY219
                          ,B.QTY220
                          ,B.QTY221
                          ,B.QTY222
                          ,B.QTY223
                          ,B.QTY224
                          ,B.QTY225
                          ,B.QTY226
                          ,B.QTY227
                          ,B.QTY228
                          ,B.QTY229
                          ,B.QTY230
                          ,B.QTY231
                          ,B.QTY232
                          ,B.QTY233
                          ,B.QTY234
                          ,B.QTY235
                          ,B.QTY236
                          ,B.QTY237
                          ,B.QTY238
                          ,B.QTY239
                          ,B.QTY240
                          ,B.QTY241
                          ,B.QTY242
                          ,B.QTY243
                          ,B.QTY244
                          ,B.QTY245
                          ,B.QTY246
                          ,B.QTY247
                          ,B.QTY248
                          ,B.QTY249
                          ,B.QTY250
                          ,B.QTY251
                          ,B.QTY252
                          ,B.QTY253
                          ,B.QTY254
                          ,B.QTY255
                          ,B.QTY256
                          ,B.QTY257
                          ,B.QTY258
                          ,B.QTY259
                          ,B.QTY260
                          ,B.QTY261
                          ,B.QTY262
                          ,B.QTY263
                          ,B.QTY264
                          ,B.QTY265
                          ,B.QTY266
                          ,B.QTY267
                          ,B.QTY268
                          ,B.QTY269
                          ,B.QTY270
                          ,B.QTY271
                          ,B.QTY272
                          ,B.QTY273
                          ,B.QTY274
                          ,B.QTY275
                          ,B.QTY276
                          ,B.QTY277
                          ,B.QTY278
                          ,B.QTY279
                          ,B.QTY280
                          ,B.QTY281
                          ,B.QTY282
                          ,B.QTY283
                          ,B.QTY284
                          ,B.QTY285
                          ,B.QTY286
                          ,B.QTY287
                          ,B.QTY288
                          ,B.QTY289
                          ,B.QTY290
                          ,B.QTY291
                          ,B.QTY292
                          ,B.QTY293
                          ,B.QTY294
                          ,B.QTY295
                          ,B.QTY296
                          ,B.QTY297
                          ,B.QTY298
                          ,B.QTY299
                          ,B.QTY300
                          ,B.QTY301
                          ,B.QTY302
                          ,B.QTY303
                          ,B.QTY304
                          ,B.QTY305
                          ,B.QTY306
                          ,B.QTY307
                          ,B.QTY308
                          ,B.QTY309
                          ,B.QTY310
                          ,B.QTY311
                          ,B.QTY312
                          ,B.QTY313
                          ,B.QTY314
                          ,B.QTY315
                          ,B.QTY316
                          ,B.QTY317
                          ,B.QTY318
                          ,B.QTY319
                          ,B.QTY320
                          ,B.QTY321
                          ,B.QTY322
                          ,B.QTY323
                          ,B.QTY324
                          ,B.QTY325
                          ,B.QTY326
                          ,B.QTY327
                          ,B.QTY328
                          ,B.QTY329
                          ,B.QTY330
                          ,B.QTY331
                          ,B.QTY332
                          ,B.QTY333
                          ,B.QTY334
                          ,B.QTY335
                          ,B.QTY336
                          ,B.QTY337
                          ,B.QTY338
                          ,B.QTY339
                          ,B.QTY340
                          ,B.QTY341
                          ,B.QTY342
                          ,B.QTY343
                          ,B.QTY344
                          ,B.QTY345
                          ,B.QTY346
                          ,B.QTY347
                          ,B.QTY348
                          ,B.QTY349
                          ,B.QTY350
                          ,B.QTY351
                          ,B.QTY352
                          ,B.QTY353
                          ,B.QTY354
                          ,B.QTY355
                          ,B.QTY356
                          ,B.QTY357
                          ,B.QTY358
                          ,B.QTY359
                          ,B.QTY360
                          ,B.QTY361
                          ,B.QTY362
                          ,B.QTY363
                          ,B.QTY364
                          ,B.WQTY01
                          ,B.WQTY02
                          ,B.WQTY03
                          ,B.WQTY04
                          ,B.WQTY05
                          ,B.WQTY06
                          ,B.WQTY07
                          ,B.WQTY08
                          ,B.WQTY09
                          ,B.WQTY10
                          ,B.WQTY11
                          ,B.WQTY12
                          ,B.WQTY13
                          ,B.WQTY14
                          ,B.WQTY15
                          ,B.WQTY16
                          ,B.WQTY17
                          ,B.WQTY18
                          ,B.WQTY19
                          ,B.WQTY20
                          ,B.WQTY21
                          ,B.WQTY22
                          ,B.WQTY23
                          ,B.WQTY24
                          ,B.WQTY25
                          ,B.WQTY26
                          ,B.WQTY27
                          ,B.WQTY28
                          ,B.WQTY29
                          ,B.WQTY30
                          ,B.WQTY31
                          ,B.WQTY32
                          ,B.WQTY33
                          ,B.WQTY34
                          ,B.WQTY35
                          ,B.WQTY36
                          ,B.WQTY37
                          ,B.WQTY38
                          ,B.WQTY39
                          ,B.WQTY40
                          ,B.WQTY41
                          ,B.WQTY42
                          ,B.WQTY43
                          ,B.WQTY44
                          ,B.WQTY45
                          ,B.WQTY46
                          ,B.WQTY47
                          ,B.WQTY48
                          ,B.WQTY49
                          ,B.WQTY50
                          ,B.WQTY51
                          ,B.WQTY52
                      FROM GT_TASM_XLS_PV_TABLE B
                     WHERE A.DIVISION_ID          = B.DIVISION_ID
                       AND A.PLAN_START_YYYYMMDD  = B.PLAN_START_YYYYMMDD
                       AND A.PLAN_TYPE            = B.PLAN_TYPE
                       AND A.SEQ                  = B.SEQ
                       AND A.OPERATION_GROUP      = B.OPERATION_GROUP
                       AND A.FROM_SITE            = B.FROM_SITE
                       AND A.ITEM_ID              = B.ITEM_ID
                       AND A.PROD_LINE            = B.LINE_ID
                       AND A.BOD_ID               = B.BOD_ID
                       AND A.MEASURE              = B.MEASURE
                       AND A.CREATE_FROM_YYYYMMDD = B.CREATE_FROM_YYYYMMDD
                        --AND XLS.PROJECT_CODE        = PV.PROJECT_CODE --PACKER 향은 PROJECT CODE가 없는게 맞지만 SCP_XLS_PSI_GLOBAL_SMALL_PACK 테이블에 PROJECT CODE가 들어가있어서 조건에서 제외 -> 신재욱 책임님 확인/김태현선임/20250425
                       AND ROWNUM = 1
                   )
         WHERE EXISTS (SELECT 1
                         FROM GT_TASM_XLS_PV_TABLE C
                        WHERE A.DIVISION_ID          = C.DIVISION_ID
                          AND A.PLAN_START_YYYYMMDD  = C.PLAN_START_YYYYMMDD
                          AND A.PLAN_TYPE            = C.PLAN_TYPE
                          AND A.SEQ                  = C.SEQ
                          AND A.OPERATION_GROUP      = C.OPERATION_GROUP
                          AND A.FROM_SITE            = C.FROM_SITE
                          AND A.ITEM_ID              = C.ITEM_ID
                          AND A.PROD_LINE            = C.LINE_ID
                          AND A.BOD_ID               = C.BOD_ID
                          AND A.MEASURE              = C.MEASURE
                          AND A.CREATE_FROM_YYYYMMDD = C.CREATE_FROM_YYYYMMDD
                          --AND XLS.PROJECT_CODE        = PV.PROJECT_CODE --PACKER 향은 PROJECT CODE가 없는게 맞지만 SCP_XLS_PSI_GLOBAL_SMALL_PACK 테이블에 PROJECT CODE가 들어가있어서 조건에서 제외 -> 신재욱 책임님 확인/김태현선임/20250425
                      )
           AND A.OPERATION_GROUP = 'A'
        ;


    -- 2026.06.15 Minyong Lee : I/F 수행된 버전 PLAN_MASTER ATTRIBUTE13에 마킹
        /* AS-IS 문자 + 연결은 하나라도 NULL 이면 NULL → 같게 CASE */
        UPDATE SCP_OPT_ENG_PLAN_MASTER_SN
           SET ATTRIBUTE13 = CASE WHEN V_SCP_PLAN_DATE IS NULL OR V_SCP_PLAN_TYPE IS NULL OR V_SCP_PLAN_SEQ IS NULL THEN NULL
                                  ELSE V_SCP_PLAN_DATE || ',' || V_SCP_PLAN_TYPE || ',' || V_SCP_PLAN_SEQ
                             END
         WHERE PLAN_ID = V_PLAN_ID;

    ------------------------------------------------------------------------
    -- 종료 LOG
	------------------------------------------------------------------------
        V_LOG_TYPE      := 'END';
        V_LOG_MESSAGE   := '########## END of procedure ##########';
        V_DESCRIPTION   := P_PLAN_START_YYYYMMDD || '@' || V_PLAN_ID;
        V_EVENT_DATE    := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);
    ------------------------------------------------------------------------
    -- Data Insert End
    ------------------------------------------------------------------------
        COMMIT;
	------------------------------------------------------------------------
    EXCEPTION
        WHEN OTHERS THEN
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC;
	------------------------------------------------------------------------
            ROLLBACK;
	    ------------------------------------------------------------------------
          -- ERROR LOG
	    ------------------------------------------------------------------------
            V_LOG_TYPE      := 'ERROR';
            V_LOG_MESSAGE   := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION   := SUBSTR('ERROR_LINE : ' || SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 200) || '@' || P_PLAN_START_YYYYMMDD || '@' || V_PLAN_ID, 1, 500);
            V_EVENT_DATE    := SYSDATE;
	    --SELECT '' + Convert(NVARCHAR(10), ERROR_NUMBER()) + '' + ERROR_MESSAGE();
	    ------------------------------------------------------------------------
            INSERT INTO SCM_SYS_LOG_BATCH
                  (PROGRAM_NAME
                  ,LOG_TYPE
                  ,LOG_COUNT
                  ,LOG_MESSAGE
                  ,DESCRIPTION
                  ,EVENT_DATE
                  ,CREATION_DATE
                  ,CREATED_BY
                  ,LAST_UPDATE_DATE
                  ,LAST_UPDATED_BY
                  )
            VALUES
                  ('PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL'
                  ,V_LOG_TYPE
                  ,NULL
                  ,V_LOG_MESSAGE
                  ,V_DESCRIPTION
                  ,SYSDATE
                  ,SYSDATE
                  ,'PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL'
                  ,SYSDATE
                  ,'PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL'
                  );
	    --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	    ------------------------------------------------------------------------
            COMMIT;
            V_MESSAGE_TEXT := SUBSTR(SQLERRM, 1, 1000);
            DBMS_OUTPUT.PUT_LINE(V_MESSAGE_TEXT);
            RAISE;
    END;
	------------------------------------------------------------------------

    ------------------------------------------------------------------------
END PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL;