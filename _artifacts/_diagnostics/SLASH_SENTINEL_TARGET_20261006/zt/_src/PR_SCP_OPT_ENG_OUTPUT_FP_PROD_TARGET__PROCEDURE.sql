PROCEDURE PR_SCP_OPT_ENG_OUTPUT_FP_PROD_TARGET
(
    P_PLAN_ID               IN  VARCHAR2 -- 250401_81_H5.5A_NH030
  , P_PLAN_START_YYYYMMDD   IN  VARCHAR2 -- 20250331
)
IS
/*==============================================================================================================================
 * STORED PROCEDURE NAME    :   PR_SCP_OPT_ENG_OUTPUT_FP_PROD_TARGET
 * DESCRIPTION              :   최적화 엔진 결과 생산계획을 FP 생산 목표 연계 테이블(XIF_SCP_PROD_TARGET_R)로 전송
 * PROGRAM HISTORY
 *==============================================================================================================================
 *  2025.02.07  Taehyun     Initial Release
 * 2026.10.06   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
==============================================================================================================================*/
    --2025.02.07 Taehyun Initial Release
	------------------------------------------------------------------------
	-- Set Param for Log
	------------------------------------------------------------------------
    V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PR_SCP_OPT_ENG_OUTPUT_FP_PROD_TARGET';
    V_PLAN_ID               VARCHAR2(50 CHAR)  := SUBSTR(P_PLAN_ID, 1, 50);
    V_MESSAGE_TEXT          VARCHAR2(1000 CHAR);
    ------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    --DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_LGTM_INV_ALLOCATION';
    V_LOG_TYPE              VARCHAR2(30 CHAR); -- START/END/ERROR/...
    N_LOG_COUNT             NUMBER := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);
    D_EVENT_DATE            DATE;
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    X_START_YYYYMMDD        VARCHAR2(8 CHAR)   := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8);
    V_DIVISION_ID           VARCHAR2(20 CHAR);
    X_CNT                   NUMBER             := 0;
    X_SEND_SEQ              NUMBER             := 1;
    X_IF_ID                 VARCHAR2(50 CHAR)  := 'OSCP_OFP0_FP_PROD_TARGET';
    X_PLAN_WEEK             VARCHAR2(12 CHAR);
    V_NOW_DATE              DATE               := SYSDATE;
    V_ORDER_TYPE            VARCHAR2(20 CHAR);
    V_MIN_DAY               VARCHAR2(8 CHAR);
    V_MAX_DAY               VARCHAR2(8 CHAR);
    V_MAX_ANL_SEQ           NUMBER;
    V_PT_PLAN_TYPE          VARCHAR2(20 CHAR);
    V_PT_PLAN_WEEK          VARCHAR2(20 CHAR);

    -- 최적화 엔진 및 ANL의 버전 정보를 가져오기 위해
    V_SCP_PLAN_DATE         VARCHAR2(50 CHAR);
    V_SCP_PLAN_TYPE         VARCHAR2(50 CHAR);
    V_SCP_PLAN_SEQ          VARCHAR2(50 CHAR);

    /* AS-IS 테이블 변수 @TYPE_TMP(DIVISION 별 TYPE) 는 한 문장 안에서만 쓰여 인라인 뷰로 옮김 */

BEGIN

	------------------------------------------------------------------------
	-- LOG 시작
	------------------------------------------------------------------------
	V_LOG_TYPE      := 'START';
	V_LOG_MESSAGE   := '########## Start of procedure ##########';
	V_DESCRIPTION   := 'START_' || V_PROGRAM_NAME;
	D_EVENT_DATE    := SYSDATE;
	PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
	------------------------------------------------------------------------

    BEGIN
        SELECT SUBSTR(ATTRIBUTE1, 1, 20)
          INTO V_DIVISION_ID
          FROM SCP_OPT_ENG_PLAN_MASTER_SN
         WHERE PLAN_ID = V_PLAN_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    --ANL의 최신 버전 정보를 가져오기 위해
    --순지 책임님 요청으로 최신 플랜 TYPE/SEQ를 가져오기로 함 -> 기존에는 PR의 최신 SEQ를 바라봤었음.-> 조립 및 다른 PLAN_GROUP 적용할 시 정리 필요
    BEGIN
        SELECT SUBSTR(IA.PLAN_START_YYYYMMDD, 1, 50)
             , SUBSTR(IA.PLAN_TYPE, 1, 50)
             , TO_CHAR(IA.PLAN_SEQ)
          INTO V_SCP_PLAN_DATE
             , V_SCP_PLAN_TYPE
             , V_SCP_PLAN_SEQ
          FROM (SELECT DIVISION_ID
                     , PLAN_START_YYYYMMDD
                     , PLAN_TYPE
                     , PLAN_SEQ
                     , PLAN_TYPE_ORDER
                     , CONFIRM_FLAG
                     , PLAN_CYCLE
                     , PLAN_ID
                     , MODELING_ID
                     , ENG_PLAN_ID
                  FROM SCP_PLAN_VERSION_V
                 WHERE DIVISION_ID          = V_DIVISION_ID
                   AND PLAN_START_YYYYMMDD  = X_START_YYYYMMDD
                 ORDER BY PLAN_TYPE_ORDER DESC NULLS LAST
                     , CONFIRM_FLAG DESC NULLS LAST
                     , PLAN_SEQ DESC
               ) IA
         WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    SELECT COUNT(1)
      INTO X_CNT
      FROM SCP_PLN_INTERFACE_SEND_H
     WHERE PLAN_START_YYYYMMDD = X_START_YYYYMMDD
       AND DIVISION_ID         = V_DIVISION_ID
       --AND PLAN_TYPE           = @P_PLAN_TYPE
       AND IF_ID               = X_IF_ID;


    IF (X_CNT > 0) THEN
        SELECT MAX(IFSEQNO)
          INTO X_CNT
          FROM SCP_PLN_INTERFACE_SEND_H
         WHERE PLAN_START_YYYYMMDD = X_START_YYYYMMDD
           AND DIVISION_ID         = V_DIVISION_ID
           AND IF_ID               = X_IF_ID;

        X_SEND_SEQ := X_CNT + 1;
    END IF;

    -- 전송주차 = 해당주차의 월요일 일자 YYYYMMDD + '001' 일련번호
    X_PLAN_WEEK  := X_START_YYYYMMDD || '_' || FN_ZERO_LPAD(TO_CHAR(X_SEND_SEQ), 3);
    V_ORDER_TYPE := 'MPS'; -- 81번의 경우 MPS 임시

    SELECT MIN(YYYYMMDD)
         , MAX(YYYYMMDD)
      INTO V_MIN_DAY
         , V_MAX_DAY
      FROM SCP_ANL_PRODUCTION_PLAN
     WHERE PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
       AND DIVISION_ID         = V_DIVISION_ID
       AND MEASURE             = 'PROD_PLAN_AMEND'
    --AND AP.PLAN_TYPE= 'PR' -- 의사결정 필요
       AND PLAN_TYPE           = V_SCP_PLAN_TYPE
       AND SEQ                 = TO_NUMBER(V_SCP_PLAN_SEQ)
       AND QTY                 > 0;

    -- 순지 책임님 요청으로 최신 플랜 TYPE/SEQ를 가져오기로 함 -> 기존에는 PR의 최신 SEQ를 바라봤었음.-> 조립 및 다른 PLAN_GROUP 적용할 시 정리 필요
    --SELECT @MAX_ANL_SEQ = MAX(PLAN_SEQ)
    --FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
    --WHERE  DIVISION_ID          = @V_DIVISION_ID
    --AND    PLAN_START_YYYYMMDD  = @P_PLAN_START_YYYYMMDD
    --AND    PLAN_TYPE = 'PR'-- 의사결정 필요

    /* AS-IS 는 여러 행이면 마지막 행 값(순서 비결정), 없으면 NULL 그대로 → 첫 행 한 건 */
    BEGIN
        SELECT SUBSTR(IA.PLAN_TYPE, 1, 20)
             , SUBSTR(IA.PLAN_WEEK, 1, 20)
          INTO V_PT_PLAN_TYPE
             , V_PT_PLAN_WEEK
          FROM (SELECT DISTINCT A.PLAN_TYPE
                     , A.PLAN_WEEK
                  FROM XIF_SCP_PROD_TARGET_R_SN A
                     , (SELECT DIVISION_ID
                             , TYPE
                          FROM (SELECT DISTINCT SEGMENT1    AS DIVISION_ID
                                     , ATTRIBUTE8  AS TYPE
                                  FROM SCM_SYS_LOOKUP_VALUE_SN
                                 WHERE LOOKUP_TYPE_CODE = 'SCP_PLANT'
                                   AND ATTRIBUTE2       = 'Y'
                                 UNION ALL
                                SELECT DISTINCT SEGMENT1    AS DIVISION_ID
                                     , ATTRIBUTE9  AS TYPE
                                  FROM SCM_SYS_LOOKUP_VALUE_SN
                                 WHERE LOOKUP_TYPE_CODE = 'SCP_PLANT'
                                   AND ATTRIBUTE2       = 'Y'
                                 UNION ALL
                                SELECT DISTINCT SEGMENT1    AS DIVISION_ID
                                     , ATTRIBUTE10 AS TYPE
                                  FROM SCM_SYS_LOOKUP_VALUE_SN
                                 WHERE LOOKUP_TYPE_CODE = 'SCP_PLANT'
                                   AND ATTRIBUTE2       = 'Y'
                               ) SA
                         WHERE TYPE IS NOT NULL
                         GROUP BY DIVISION_ID
                             , TYPE
                       ) XA
                 WHERE A.DIVISION  = XA.DIVISION_ID
                   AND A.PLAN_TYPE = XA.TYPE
                   AND A.PLAN_WEEK = (SELECT IB.PLAN_WEEK
                                        FROM (SELECT B.PLAN_WEEK
                                                FROM XIF_SCP_PROD_TARGET_R_SN B
                                                   , (SELECT DIVISION_ID
                                                           , TYPE
                                                        FROM (SELECT DISTINCT SEGMENT1    AS DIVISION_ID
                                                                   , ATTRIBUTE8  AS TYPE
                                                                FROM SCM_SYS_LOOKUP_VALUE_SN
                                                               WHERE LOOKUP_TYPE_CODE = 'SCP_PLANT'
                                                                 AND ATTRIBUTE2       = 'Y'
                                                               UNION ALL
                                                              SELECT DISTINCT SEGMENT1    AS DIVISION_ID
                                                                   , ATTRIBUTE9  AS TYPE
                                                                FROM SCM_SYS_LOOKUP_VALUE_SN
                                                               WHERE LOOKUP_TYPE_CODE = 'SCP_PLANT'
                                                                 AND ATTRIBUTE2       = 'Y'
                                                               UNION ALL
                                                              SELECT DISTINCT SEGMENT1    AS DIVISION_ID
                                                                   , ATTRIBUTE10 AS TYPE
                                                                FROM SCM_SYS_LOOKUP_VALUE_SN
                                                               WHERE LOOKUP_TYPE_CODE = 'SCP_PLANT'
                                                                 AND ATTRIBUTE2       = 'Y'
                                                             ) SB
                                                       WHERE TYPE IS NOT NULL
                                                       GROUP BY DIVISION_ID
                                                           , TYPE
                                                     ) XB
                                               WHERE B.DIVISION    = XB.DIVISION_ID
                                                 AND B.PLAN_TYPE   = XB.TYPE
                                                 AND B.DIVISION    = V_DIVISION_ID
                                                 AND B.IF_RCV_DATE >= SYSDATE - 14 -- 속도 개선을 위해
                                               ORDER BY B.PLAN_WEEK DESC
                                             ) IB
                                       WHERE ROWNUM = 1)
                   AND A.DIVISION  = V_DIVISION_ID
               ) IA
         WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;


    ------------------------------------------------------------------------
	-- Transaction (START)
	------------------------------------------------------------------------
    BEGIN
        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------

        INSERT INTO XIF_SCP_PROD_TARGET_R_SN
             ( IF_RCV_DATE
             , PROC_FLAG
             , PROC_DATE
             , PLAN_TYPE
             , PLAN_WEEK
             , TARGET_ID
             , ITEM_ID
             , OPERATION_GROUP
             , OPERATION_ID
             , SITE_CODE
             , PLANT_ID
             , PROD_WEEK
             , YYYYMMDD
             , PROD_QTY
             , ORDER_TYPE
             , PRODUCTION_LINE
             , PRIORITY
             , DIVISION
             , MARKET
             , CREATE_USER_ID
             , CREATE_DATE
             , MODIFY_USER_ID
             , MODIFY_DATE
             , ATTR_01             --ORIGIN_DIVISION_ID
             , ATTR_10             --Divide Original and OPT Engine
             )
        SELECT V_NOW_DATE
             , 'N'
             , NULL
             , V_PT_PLAN_TYPE
             , X_PLAN_WEEK
             , A.TARGET_ID
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.OPERATION_ID
             , A.SITE_CODE
             , A.PLANT_ID
             , A.PROD_WEEK
             , A.YYYYMMDD
             , A.PROD_QTY
             , A.ORDER_TYPE
             , A.PRODUCTION_LINE
             , A.PRIORITY
             , A.DIVISION
             , A.MARKET
             , A.CREATE_USER_ID
             , A.CREATE_DATE
             , A.MODIFY_USER_ID
             , A.MODIFY_DATE
             , A.ATTR_01
             , A.ATTR_10
          FROM XIF_SCP_PROD_TARGET_R_SN A
             , (SELECT SCM_SITE_ID
                     , ITEM_ID
                  FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                 WHERE PLAN_ID = V_PLAN_ID
                 GROUP BY SCM_SITE_ID
                     , ITEM_ID
               ) IA
         WHERE A.SITE_CODE       = IA.SCM_SITE_ID(+)
           AND A.ITEM_ID         = IA.ITEM_ID(+)
           AND IA.SCM_SITE_ID IS NULL
           AND A.PLAN_TYPE       = V_PT_PLAN_TYPE
           AND A.PLAN_WEEK       = V_PT_PLAN_WEEK
           AND A.DIVISION        = V_DIVISION_ID
         UNION ALL
        SELECT V_NOW_DATE                                                        AS IF_RCV_DATE
             , 'N'                                                               AS PROC_FLAG
             , NULL                                                              AS PROC_DATE
             , V_PT_PLAN_TYPE                                                    AS PLAN_TYPE
             , X_PLAN_WEEK                                                       AS PLAN_WEEK
             , TO_CHAR(ROW_NUMBER() OVER(ORDER BY B.ITEM_ID))                    AS TARGET_ID
             , B.ITEM_ID
             , B.OPERATION_GROUP
             , B.OPERATION_ID
             , B.SCM_SITE_ID                                                     AS SITE_ID
             , C.PLANT_ID
             , XB.W_MON                                                          AS PROD_WEEK
             , B.YYYYMMDD
             , B.QTY                                                             AS OUT_QTY_INT
             , V_ORDER_TYPE                                                      AS ORDER_TYPE
             , B.LINE_ID                                                         AS PRODUCTION_LINE
             , '1'                                                               AS PRIORITY
             , V_DIVISION_ID                                                     AS DIVISION_ID
             , 'D'                                                               AS MARKET
             , 'OPT_ENG'                                                         AS CREATE_USER_ID
             , V_NOW_DATE                                                        AS CREATE_DATE
             , 'OPT_ENG'                                                         AS MODIFY_USER_ID
             , V_NOW_DATE                                                        AS MODIFY_DATE
             , V_DIVISION_ID                                                     AS ATTR_01
             , 'OPT_ENG_' || TO_CHAR(V_NOW_DATE, 'YYYY-MM-DD HH24:MI:SS')       AS ATTR_10 -- 여러번에 걸쳐 수행된 SP를 구분하기 위해 시간 추가
          FROM SCP_ANL_PRODUCTION_PLAN B
             , (SELECT SCM_SITE_ID
                     , ITEM_ID
                  FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                 WHERE PLAN_ID = V_PLAN_ID
                 GROUP BY SCM_SITE_ID
                     , ITEM_ID
               ) XA
             , SCM_MST_SITE C
             , (SELECT D.BASIS_YYYYMMDD
                     , SC.W_MON
                  FROM SCM_SYS_CALENDAR_M D
                     , (SELECT ISO_YYYYWW
                             , MIN(BASIS_YYYYMMDD) AS W_MON
                          FROM SCM_SYS_CALENDAR_M
                         WHERE BASIS_YYYYMMDD BETWEEN V_MIN_DAY AND V_MAX_DAY
                         GROUP BY ISO_YYYYWW
                       ) SC
                 WHERE D.ISO_YYYYWW = SC.ISO_YYYYWW
                   AND D.BASIS_YYYYMMDD BETWEEN V_MIN_DAY AND V_MAX_DAY
               ) XB
         WHERE B.SCM_SITE_ID          = XA.SCM_SITE_ID
           AND B.ITEM_ID              = XA.ITEM_ID
           AND B.SCM_SITE_ID          = C.SCM_SITE_ID
           AND B.YYYYMMDD             = XB.BASIS_YYYYMMDD
           AND B.MEASURE              = 'PROD_PLAN_AMEND'
        --AND AP.PLAN_TYPE= 'PR' -- 의사결정 필요
           AND B.QTY                  > 0
           AND C.DIVISION_ID          = V_DIVISION_ID
           AND B.PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
           AND B.DIVISION_ID          = V_DIVISION_ID
           AND B.PLAN_TYPE            = V_SCP_PLAN_TYPE --
        --AND AP.SEQ = @MAX_ANL_SEQ
           AND B.SEQ                  = TO_NUMBER(V_SCP_PLAN_SEQ);

        INSERT INTO SCP_PLN_INTERFACE_SEND_H
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE
             , IF_ID
             , IFSEQNO
             , CREATED_BY
             , CREATION_DATE )
        VALUES
             ( X_START_YYYYMMDD
             , V_DIVISION_ID
             , V_PT_PLAN_TYPE
             , X_IF_ID
             , X_SEND_SEQ
             , 'OPT_ENG'
             , SYSDATE
             );
    ------------------------------------------------------------------------
    -- 종료 LOG
	------------------------------------------------------------------------
        V_LOG_TYPE      := 'END';
        V_LOG_MESSAGE   := '########## END of procedure ##########';
        V_DESCRIPTION   := '';
        D_EVENT_DATE    := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
	------------------------------------------------------------------------
    ------------------------------------------------------------------------
    -- Data Insert End
    ------------------------------------------------------------------------
    EXCEPTION
        WHEN OTHERS THEN
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC;
	    ------------------------------------------------------------------------
          -- ERROR LOG
	    ------------------------------------------------------------------------
            V_LOG_TYPE      := 'ERROR';
            V_LOG_MESSAGE   := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION   := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE    := SYSDATE;
	        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQLCODE) || SQLERRM);
	    ------------------------------------------------------------------------
            /* AS-IS 는 SET XACT_ABORT ON 이라 오류 순간 트랜잭션이 취소 불가 상태가 되고, CATCH 의 로그 기록도 실패해 호출자에게 오류가 넘어간다
               → 처리분을 되돌리고 오류 로그를 남긴 뒤 오류를 올린다 */
            ROLLBACK;
	        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            RAISE_APPLICATION_ERROR(-20001, V_LOG_MESSAGE);
    END;
    ------------------------------------------------------------------------
END PR_SCP_OPT_ENG_OUTPUT_FP_PROD_TARGET;