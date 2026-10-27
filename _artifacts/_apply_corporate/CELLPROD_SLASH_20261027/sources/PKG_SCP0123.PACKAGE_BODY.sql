PACKAGE BODY PKG_SCP0123
IS

    /* ------------------------------------------------------------
       오류 로그 (조회 프로시저 공통)
       ------------------------------------------------------------ */
    PROCEDURE P_LOG_ERROR
    (
        P_PROGRAM_NAME  IN  VARCHAR2,
        P_IN_PARA_DATA  IN  VARCHAR2,
        P_SQLCODE       IN  NUMBER,
        P_SQLERRM       IN  VARCHAR2,
        P_BACKTRACE     IN  VARCHAR2
    )
    IS
    BEGIN
        PR_SCM_SYS_LOG_BATCH(P_PROGRAM_NAME
                           , 'ERROR'
                           , NULL
                           , SUBSTR(P_SQLERRM, 1, 1000)
                           , NULL
                           , SYSDATE
                           , SUBSTR(P_IN_PARA_DATA, 1, 2000)
                           , TO_CHAR(P_SQLCODE)
                           , SUBSTR(P_SQLERRM, 1, 2000)
                           , SUBSTR(P_BACKTRACE, 1, 4000));
    END P_LOG_ERROR;


    /* ------------------------------------------------------------
       연계 프로시저 미이관 오류
       AS-IS 에서 호출하는 엔진 연계 프로시저가 Oracle 에 없어 호출문을 주석으로 두고 오류를 낸다.
       (AS-IS 도 없는 프로시저를 부르면 CATCH 로 가서 'F' 를 돌려준다)
       연계 프로시저 이관 후 각 자리의 호출문 주석을 풀고 이 호출을 지운다.
       ------------------------------------------------------------ */
    PROCEDURE P_RAISE_NOT_MIGRATED
    (
        P_PROC_NAME     IN  VARCHAR2
    )
    IS
    BEGIN
        RAISE_APPLICATION_ERROR(-20001, 'Not migrated procedure : ' || P_PROC_NAME);
    END P_RAISE_NOT_MIGRATED;


    /*
     * Program ID   : SCP0123_GET_PLAN_CONTROL
     * Description  : Plan Control 정보 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2025/05/07   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
     * 2025/06/09   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Target 대상 추가
     * 2025/08/20   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Plan ID 표시할 때 ATTRIBUTE1 = 'A' 인 정보 제외
     * 2026/09/17   AJS             MSSQL -> Oracle 전환
     * 2026/09/17   AJS             최종 Plan ID 대소문자 무시 비교
     *
     */
    PROCEDURE P_SCP0123_GET_PLAN_CONTROL
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_GROUP_ID         IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_ACTV_CD               IN  VARCHAR2 DEFAULT NULL,
        P_PLAN_ID               IN  VARCHAR2 DEFAULT NULL,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
    BEGIN

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

        /* AS-IS ISNULL(@p_plan_id, '') = '' : 공백만 있는 값도 빈 값 */
        IF RTRIM(P_PLAN_ID) IS NULL THEN

            -- Plan Controls 메인정보 : Table[0]
            /* AS-IS #temp_plan_control 적재 후 조회 - 한 문장으로 조회 (미사용 CTE opmz_activity_type 제외) */
            OPEN O_RC1 FOR
            SELECT A.PLAN_START_YYYYMMDD
                 , A.OPMZ_PRS_CD
                 --,op.OPMZ_PRS_NAME
                 , B.DIVISION_ID
                 , A.OPMZ_PLAN_GR_ID
                 , B.OPMZ_PLAN_GR_NAME
                 , B.OPMZ_TGT_DIVS_CD
                 , A.OPMZ_ACTV_CD
                 , IB.OPMZ_ACTV_NAME
                 , IB.OPMZ_PLAN_ID_INDP_YN   -- plan id에 독립적으로 수행 여부
                 , IB.CONFIRM_YN
                 , IB.OPTION_YN
                 , IB.LINK_NAME              AS LINK   -- Link 표시명
                 , IB.LINK_ADDRESS           -- Link 화면 Program ID
                 , IB.ACTION_NAME            -- Action button명
                 , A.OPMZ_ACTV_SEQ
                 , C.OPMZ_PLAN_ID
                 , C.OPMZ_ACTV_RUN_STAT_CD   --- activity 운행  상태
                 , IC.OPMZ_ACTV_RUN_STAT_NAME   --- activity 운행  상태
                 , C.LAST_UPDATE_DATE
                 , C.LAST_UPDATED_BY
              FROM SCP_OPMZ_PLAN_CTRL_ACTV_M A
                 , SCP_OPMZ_PLAN_GR_M B
                 , SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M C
                 , (SELECT SEGMENT1               AS OPMZ_PRS_CD
                         , ATTRIBUTE1             AS OPMZ_PRS_NAME
                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                     WHERE LOOKUP_TYPE            = 'OPMZ_PRS_CD'
                       AND VALID_YN               = 'Y') IA
                 , (SELECT SEGMENT1               AS OPMZ_ACTV_CD
                         , ATTRIBUTE1             AS OPMZ_ACTV_NAME
                         , ATTRIBUTE3             AS OPMZ_PLAN_ID_INDP_YN   -- plan id 독립적 수행 activity 여부
                         , ATTRIBUTE6             AS CONFIRM_YN             -- CONFIRM_YN
                         , ATTRIBUTE8             AS OPTION_YN              -- OPTION_YN
                         , ATTRIBUTE9             AS LINK_NAME              -- Link 표시명
                         , ATTRIBUTE10            AS LINK_ADDRESS           -- Link 화면 Program ID
                         , ATTRIBUTE11            AS ACTION_NAME            -- Action button명
                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                     WHERE LOOKUP_TYPE            = 'OPMZ_ACTV_CD'
                       AND VALID_YN               = 'Y') IB
                 , (SELECT SEGMENT1               AS OPMZ_ACTV_RUN_STAT_CD
                         , ATTRIBUTE1             AS OPMZ_ACTV_RUN_STAT_NAME
                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                     WHERE LOOKUP_TYPE            = 'OPMZ_ACTV_RUN_STAT_CD'
                       AND VALID_YN               = 'Y') IC
             WHERE B.OPMZ_PLAN_GR_ID              = A.OPMZ_PLAN_GR_ID
               AND IA.OPMZ_PRS_CD                 = A.OPMZ_PRS_CD
               AND IB.OPMZ_ACTV_CD                = A.OPMZ_ACTV_CD
               AND C.PLAN_START_YYYYMMDD(+)       = A.PLAN_START_YYYYMMDD
               AND C.OPMZ_PRS_CD(+)               = A.OPMZ_PRS_CD
               AND C.OPMZ_PLAN_GR_ID(+)           = A.OPMZ_PLAN_GR_ID
               AND C.OPMZ_ACTV_CD(+)              = A.OPMZ_ACTV_CD
               -- 2026.09.17 AJS 최종 Plan ID 대소문자 무시 비교 (START)
--             AND C.OPMZ_PLAN_ID(+)              = CASE WHEN IB.OPMZ_PLAN_ID_INDP_YN = 'Y' THEN '-'
--                                                       ELSE A.LTST_RUN_OPMZ_PLAN_ID  -- 최종 수행
--                                                  END
               AND UPPER(C.OPMZ_PLAN_ID(+))       = UPPER(CASE WHEN IB.OPMZ_PLAN_ID_INDP_YN = 'Y' THEN '-'
                                                               ELSE A.LTST_RUN_OPMZ_PLAN_ID  -- 최종 수행
                                                          END)
               -- 2026.09.17 AJS 최종 Plan ID 대소문자 무시 비교 (END)
               AND IC.OPMZ_ACTV_RUN_STAT_CD(+)    = C.OPMZ_ACTV_RUN_STAT_CD
               AND NVL(C.ATTRIBUTE1(+), ' ')      <> 'M'   --수동으로 엔진 돌릴경우는 화면표시 대상제외
               AND NVL(C.ATTRIBUTE1(+), ' ')      <> 'A'   --[PJ20257329] Plan ID 표시할 때 ATTRIBUTE1 = 'A' 인 정보 제외(2025-08-20)
               AND B.DIVISION_ID                  = UPPER(P_DIVISION_ID)
               AND A.OPMZ_PLAN_GR_ID              = UPPER(P_PLAN_GROUP_ID)
               AND A.PLAN_START_YYYYMMDD          = P_PLAN_START_YYYYMMDD
             ORDER BY A.OPMZ_ACTV_SEQ
                    , A.OPMZ_ACTV_CD;

            --A004항목 Activity 분리 실행으로 UPDATE 할 필요없음 (2025-06-11 요청)

        ELSE

            OPEN O_RC1 FOR
            SELECT C.OPMZ_ACTV_RUN_STAT_CD      --- activity 운행  상태
                 , IA.OPMZ_ACTV_RUN_STAT_NAME   --- activity 운행  상태
                 , C.LAST_UPDATE_DATE
                 , C.LAST_UPDATED_BY
              FROM SCP_OPMZ_PLAN_CTRL_ACTV_M A
                 , SCP_OPMZ_PLAN_GR_M B
                 , SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M C
                 , (SELECT SEGMENT1               AS OPMZ_ACTV_RUN_STAT_CD
                         , ATTRIBUTE1             AS OPMZ_ACTV_RUN_STAT_NAME
                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                     WHERE LOOKUP_TYPE            = 'OPMZ_ACTV_RUN_STAT_CD'
                       AND VALID_YN               = 'Y') IA
             WHERE B.OPMZ_PLAN_GR_ID              = A.OPMZ_PLAN_GR_ID
               AND C.PLAN_START_YYYYMMDD(+)       = A.PLAN_START_YYYYMMDD
               AND C.OPMZ_PRS_CD(+)               = A.OPMZ_PRS_CD
               AND C.OPMZ_PLAN_GR_ID(+)           = A.OPMZ_PLAN_GR_ID
               AND C.OPMZ_ACTV_CD(+)              = A.OPMZ_ACTV_CD
               AND IA.OPMZ_ACTV_RUN_STAT_CD(+)    = C.OPMZ_ACTV_RUN_STAT_CD
               AND B.DIVISION_ID                  = UPPER(P_DIVISION_ID)
               AND A.OPMZ_PLAN_GR_ID              = UPPER(P_PLAN_GROUP_ID)
               AND A.PLAN_START_YYYYMMDD          = P_PLAN_START_YYYYMMDD
               /* AS-IS ( ( @p_Actv_cd IS NULL OR  @p_Actv_cd='' ) OR rm.opmz_actv_cd = @p_Actv_cd ) */
               AND A.OPMZ_ACTV_CD                 = NVL(UPPER(RTRIM(P_ACTV_CD)), A.OPMZ_ACTV_CD)
               /* Plan ID 는 대소문자 혼재 - AS-IS 대소문자 무시 비교 */
               AND UPPER(C.OPMZ_PLAN_ID(+))       = UPPER(P_PLAN_ID);

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('PKG_SCP0123.P_SCP0123_GET_PLAN_CONTROL'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID
                     || ', P_PLAN_GROUP_ID=' || P_PLAN_GROUP_ID
                     || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                     || ', P_ACTV_CD=' || P_ACTV_CD
                     || ', P_PLAN_ID=' || P_PLAN_ID
                      , SQLCODE
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            IF NOT O_RC1%ISOPEN THEN
                OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
            END IF;

    END P_SCP0123_GET_PLAN_CONTROL;


    /*
     * Program ID   : SCP0123_GET_PLAN_ENGINE_RUN
     * Description  : Engine Run Status 정보 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2025/05/14   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
     * 2025/06/11   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Engine Run Waiting Count 수정
     * 2026/09/17   AJS             MSSQL -> Oracle 전환
     *
     */
    PROCEDURE P_SCP0123_GET_PLAN_ENGINE_RUN
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_GROUP_ID         IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_ACTV_CD               IN  VARCHAR2,
        P_PLAN_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        V_LAST_UPDATE_DATE      DATE;
        V_WAITING_CNT           PLS_INTEGER := 0;
        V_WAITINT_DESC          VARCHAR2(200 CHAR);
    BEGIN

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

        /* AS-IS select distinct @v_last_update_date = ... : 대상 행이 없으면 값 없음 */
        SELECT MAX(A.LAST_UPDATE_DATE)
          INTO V_LAST_UPDATE_DATE
          FROM SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M A
             , SCP_OPMZ_PLAN_GR_M B
         WHERE B.OPMZ_PLAN_GR_ID          = A.OPMZ_PLAN_GR_ID
           AND A.OPMZ_ACTV_RUN_STAT_CD    = 'W'   --Wait인 것만 카운트 하도록
           AND B.DIVISION_ID              = UPPER(P_DIVISION_ID)
           AND A.PLAN_START_YYYYMMDD      = P_PLAN_START_YYYYMMDD
           AND A.OPMZ_PLAN_GR_ID          = UPPER(P_PLAN_GROUP_ID)
           AND A.OPMZ_ACTV_CD             = UPPER(P_ACTV_CD)
           AND UPPER(A.OPMZ_PLAN_ID)      = UPPER(P_PLAN_ID);

        IF V_LAST_UPDATE_DATE IS NOT NULL THEN

            SELECT COUNT(*)
              INTO V_WAITING_CNT
              FROM SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M A
                 , SCP_OPMZ_PLAN_GR_M B
             WHERE B.OPMZ_PLAN_GR_ID      = A.OPMZ_PLAN_GR_ID
               AND A.OPMZ_ACTV_RUN_STAT_CD = 'W'   --Wait인 것만 카운트 하도록
               AND B.DIVISION_ID          = UPPER(P_DIVISION_ID)
               AND A.PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
               --AND rm.OPMZ_PLAN_GR_ID			= @p_plan_group_id		--사업부 내에서 카운트 하도록 수정 plan_group_id 제외
               AND A.OPMZ_ACTV_CD         = UPPER(P_ACTV_CD)
               AND A.LAST_UPDATE_DATE     <= V_LAST_UPDATE_DATE;

            V_WAITINT_DESC := ' Wating for engine. Your position is ' || TO_CHAR(V_WAITING_CNT);

        ELSE
            V_WAITINT_DESC := NULL;
        END IF;

        /* AS-IS 정렬 없음 - 룩업 테이블 기본키(LOOKUP_TYPE, SEGMENT1, SEGMENT2) 순서로 나온다 */
        OPEN O_RC1 FOR
        SELECT NVL(B.PLAN_ID, P_PLAN_ID)  AS PLAN_ID
             , A.SEGMENT2                 AS PROGRESS_CODE
             , A.ATTRIBUTE1               AS PROGRESS_TEXT
             , B.STATUS_CODE              AS STATUS
             , TO_CHAR(B.START_DATE, 'YYYY-MM-DD HH24:MI:SS".000"') AS START_DATE
             , TO_CHAR(B.END_DATE, 'YYYY-MM-DD HH24:MI:SS".000"')   AS END_DATE
             , CASE WHEN A.SEGMENT2 = 'STEP01' THEN B.MESSAGE_TEXT || V_WAITINT_DESC
                    ELSE B.MESSAGE_TEXT
               END                        AS DETAILS
          FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL A
             , SCP_OPT_ENG_ENGINE_RUN_STATUS_DETAIL_SN B
         WHERE B.PROGRESS_CODE(+)         = A.SEGMENT2
           AND A.LOOKUP_TYPE              = 'SCP_OPT_ENG_RUN_STATUS'
           AND A.VALID_YN                 = 'Y'
           AND UPPER(B.PLAN_ID(+))        = UPPER(P_PLAN_ID)
         ORDER BY A.SEGMENT1
                , A.SEGMENT2;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('PKG_SCP0123.P_SCP0123_GET_PLAN_ENGINE_RUN'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID
                     || ', P_PLAN_GROUP_ID=' || P_PLAN_GROUP_ID
                     || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                     || ', P_ACTV_CD=' || P_ACTV_CD
                     || ', P_PLAN_ID=' || P_PLAN_ID
                      , SQLCODE
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            IF NOT O_RC1%ISOPEN THEN
                OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
            END IF;

    END P_SCP0123_GET_PLAN_ENGINE_RUN;


    /*
     * Program ID   : SCP0123_GET_PLAN_ID_CREATE_INFO
     * Description  : Plan Control 정보 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2025/05/09   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
     * 2025/06/09   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Target 대상 추가
     * 2025/06/19   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - SCP Code값 변경
     * 2025/07/02   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - SCP PLAN ID 정렬순서 수정, EE(전극)의 Frozen을 가져오기 위해 division 조건 제외
     * 2025/07/08   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - No Frozen 체크 추가
     * 2025/08/26   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 특정 사업부의 Plan Horizon-End Date 변경가능하도록 룩업연동
     * 2025/09/01   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 일단위 Plan date 운영(81_UC, EE_UC)
     * 2025/09/30   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 전극사업부 선택시 FP Cutoff일자 표시하도록 수정
     * 2025/10/13   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Horizon End 일자 변경 가능하도록 수정
     * 2026/09/17   AJS             MSSQL -> Oracle 전환 (이름 SCP0123_GET_PLAN_ID_CREATE_INFO -> P_SCP0123_GET_PLAN_ID_INFO)
     * 2026/09/17   AJS             계획일 8자 기준 · 형식 확인 · 공정군 ORDER BY
     *
     */
    PROCEDURE P_SCP0123_GET_PLAN_ID_INFO
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_GROUP_ID         IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR,
        O_RC3                   OUT SYS_REFCURSOR,
        O_RC4                   OUT SYS_REFCURSOR,
        O_RC5                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        V_HORIZON_END_DATE      VARCHAR2(10 CHAR);
        V_VERSION_NO            VARCHAR2(200 CHAR);
        V_PLAN_START_DATE       DATE;
        V_WEEKDAY               PLS_INTEGER;
        V_MONDAY_DATE           VARCHAR2(8 CHAR);
        V_SUNDAY_DATE           VARCHAR2(8 CHAR);
        V_PLAN_DAYS             VARCHAR2(400 CHAR);
        V_DATE_1                VARCHAR2(8 CHAR);
        V_DATE_2                VARCHAR2(8 CHAR);
        V_PLAN_START_YMD        VARCHAR2(8 CHAR) := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8);   -- 2026.09.17 AJS AS-IS NVARCHAR(8) 잘림
    BEGIN

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

        -- 2026.09.17 AJS 계획일 형식 확인 (FX) (START)
--      V_PLAN_START_DATE := TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD');
        V_PLAN_START_DATE := TO_DATE(V_PLAN_START_YMD, 'FXYYYYMMDD');
        -- 2026.09.17 AJS 계획일 형식 확인 (FX) (END)

        --[PJ20257329]일단위 Plan date 운영(81_UC, EE_UC)(2025-09-01) START
        -- 주의 시작 요일이 월요일로 설정
        /* AS-IS SET DATEFIRST 1 + DATEPART(weekday) : 월=1 … 일=7 (1900-01-01 이 월요일) */
        V_WEEKDAY     := MOD(V_PLAN_START_DATE - DATE '1900-01-01', 7) + 1;
        V_MONDAY_DATE := TO_CHAR(V_PLAN_START_DATE + (1 - V_WEEKDAY), 'YYYYMMDD');
        V_SUNDAY_DATE := TO_CHAR(V_PLAN_START_DATE + (7 - V_WEEKDAY), 'YYYYMMDD');
        --[PJ20257329]일단위 Plan date 운영(81_UC, EE_UC)(2025-09-01) END

        --[PJ20257329]특정 사업부의 Plan Horizon-End Date 변경가능하도록 룩업연동(2025-08-26) START
        BEGIN
            SELECT SEGMENT2
              INTO V_PLAN_DAYS
              FROM SCM_ADM_LOOKUP_MASTER_DETAIL
             WHERE LOOKUP_TYPE    = 'OPMZ_PLAN_END_DATE'
               AND VALID_YN       = 'Y'
               AND SEGMENT1       = UPPER(P_DIVISION_ID)
               AND ROWNUM         = 1;

            V_HORIZON_END_DATE := TO_CHAR(V_PLAN_START_DATE + TO_NUMBER(V_PLAN_DAYS), 'YYYY-MM-DD');

        EXCEPTION
            WHEN NO_DATA_FOUND THEN

                /* 주 단위 계획은 한 주에 한 건 - 없으면 값 없음 (AS-IS '') */
                SELECT MAX(TO_CHAR(TO_DATE(HORIZON_END_DATE, 'YYYYMMDD'), 'YYYY-MM-DD'))
                  INTO V_HORIZON_END_DATE
                  FROM SCM_MST_PLAN
                 WHERE PLAN_CYCLE     = 'WEEKLY'
                   AND DIVISION_ID    = UPPER(P_DIVISION_ID)
                   --and plan_name = @p_plan_start_yyyymmdd
                   AND PLAN_NAME BETWEEN V_MONDAY_DATE AND V_SUNDAY_DATE;   --[PJ20257329]일단위 Plan date 운영(81_UC, EE_UC)(2025-09-01)
        END;
        --[PJ20257329]특정 사업부의 Plan Horizon-End Date 변경가능하도록 룩업연동(2025-08-26) END

        --select distinct @version_no = version_no
        SELECT MAX(VERSION_NO)
          INTO V_VERSION_NO
          FROM DM_PLN_NET_DEMAND
         WHERE DIVISION_ID    = UPPER(P_DIVISION_ID)
           --and cutoff_yyyymmdd = (select max(cutoff_yyyymmdd) from DM_PLN_NET_DEMAND with(nolock) )
           --and cutoff_yyyymmdd = @p_plan_start_yyyymmdd
           AND CUTOFF_YYYYMMDD BETWEEN V_MONDAY_DATE AND V_SUNDAY_DATE;   --[PJ20257329]일단위 Plan date 운영(81_UC, EE_UC)(2025-09-01)

        -- Table[0]
        /* AS-IS 컬럼명 없음 - 컬럼명 부여 */
        OPEN O_RC1 FOR
        SELECT V_HORIZON_END_DATE AS HORIZON_END_DATE
             , V_VERSION_NO       AS VERSION_NO
          FROM DUAL;

        -- Table[1]
        OPEN O_RC2 FOR
        SELECT A.OPERATION_GROUP
             , TO_CHAR(V_PLAN_START_DATE + (MAX(A.PROD_FROZEN) - 1), 'YYYY-MM-DD') AS PROD_FROZEN
             , TO_CHAR(V_PLAN_START_DATE + (MAX(A.SHIP_FROZEN) - 1), 'YYYY-MM-DD') AS SHIP_FROZEN
          FROM SCM_MST_SITE A
         WHERE A.PLANT_ID IN (SELECT SA.PLANT_ID
                                FROM SCP_OPMZ_PLAN_GR_LINE_M SA
                               WHERE SA.VALID_YN          = 'Y'
                                 AND SA.OPMZ_PLAN_GR_ID   = UPPER(P_PLAN_GROUP_ID))
           AND A.SITE_TYPE        = 'PLANT'
           --and division_id = @p_division_id	EE(전극)의 Frozen을 가져오기 위해 division 조건 제외 (2025-07-02)
           AND A.OPERATION_GROUP IN ('A', 'E', 'P')
         -- 2026.09.17 AJS 공정군 ORDER BY (START)
--       GROUP BY A.OPERATION_GROUP;
         GROUP BY A.OPERATION_GROUP
         ORDER BY A.OPERATION_GROUP;
         -- 2026.09.17 AJS 공정군 ORDER BY (END)

        --[PJ20257329] 전극사업부 선택시 FP Cutoff일자 표시하도록 수정 (2025-09-30) START
        /* AS-IS #division_info 는 인라인 뷰 XA 로 옮김
           AS-IS 조인 조건 CASE 식 : 전극(EE)은 공정 E2000 만, 그 외는 E2000 제외
           (division_dv 는 조인 조건상 NULL 이 올 수 없다) */
        -- Table[2]
        OPEN O_RC3 FOR
        SELECT IB.CODE
             , IB.NAME
             , IB.PLAN_TYPE
          FROM (SELECT IA.CODE
                     , IA.NAME
                     , IA.PLAN_TYPE
                     , 1                          AS SORT_NO
                  FROM (SELECT A.YYYYMMDD                 AS CODE
                             , A.YYYYMMDD || ' Cut off'   AS NAME
                             , 'FP'                       AS PLAN_TYPE
                          FROM SCM_DNM_FP_RELEASE_PROD_PLAN_C A
                             , (SELECT B.DIVISION_ID
                                     , C.DIVISION_ID      AS ORG_DIVISION_ID
                                     , B.ATTRIBUTE3       AS DIVISION_DV
                                  FROM SCM_MST_DIVISION B
                                     , SCM_MST_DIVISION C
                                 WHERE C.ATTRIBUTE4       = B.ATTRIBUTE4
                                   AND ((B.ATTRIBUTE3 <> 'EE' AND C.DIVISION_ID = B.DIVISION_ID)
                                        OR
                                        (B.ATTRIBUTE3 = 'EE'  AND C.ATTRIBUTE3 <> 'EE'))
                                   AND B.VALID_YN         = 'Y'
                                   AND C.VALID_YN         = 'Y') XA
                         WHERE XA.ORG_DIVISION_ID = A.DIVISION_ID
                           AND ((XA.DIVISION_DV = 'EE'  AND A.OPERATION_ID = 'E2000')
                                OR
                                (XA.DIVISION_DV <> 'EE' AND A.OPERATION_ID <> 'E2000'))
                           AND XA.DIVISION_ID     = UPPER(P_DIVISION_ID)
                           -- 2026.09.17 AJS 계획일 8자 기준 (START)
--                         AND A.YYYYMMDD         <= P_PLAN_START_YYYYMMDD
                           AND A.YYYYMMDD         <= V_PLAN_START_YMD
                           -- 2026.09.17 AJS 계획일 8자 기준 (END)
                         GROUP BY A.DIVISION_ID
                                , A.YYYYMMDD
                         ORDER BY A.YYYYMMDD DESC
                         FETCH FIRST 1 ROWS ONLY) IA
                --[PJ20257329] 전극사업부 선택시 FP Cutoff일자 표시하도록 수정 (2025-09-30) END
                 UNION ALL
                SELECT 'Latest FP Plan'           AS CODE
                     , 'Latest FP Plan'           AS NAME
                     , 'FP'                       AS PLAN_TYPE
                     , 2                          AS SORT_NO
                  FROM DUAL
                 UNION ALL
                SELECT 'Current'                  AS CODE
                     , 'Current'                  AS NAME
                     , 'SSP'                      AS PLAN_TYPE
                     , 3                          AS SORT_NO
                  FROM DUAL) IB
         ORDER BY IB.SORT_NO;

        -- SCP 당주 포함 W-2 구간의 SCP 계획(PR, MA, FN 전부 표시)
        /* AS-IS @date_1 NVARCHAR(8) : 8자 초과분은 잘린다 */
        SELECT SUBSTR(MAX(PLAN_START_YYYYMMDD), 1, 8)
          INTO V_DATE_1
          FROM SCP_PLAN_VERSION_V
         -- 2026.09.17 AJS 계획일 8자 기준 (START)
--       WHERE PLAN_START_YYYYMMDD <= P_PLAN_START_YYYYMMDD;
         WHERE PLAN_START_YYYYMMDD <= V_PLAN_START_YMD;
         -- 2026.09.17 AJS 계획일 8자 기준 (END)

        V_DATE_2 := TO_CHAR(TO_DATE(V_DATE_1, 'YYYYMMDD') - 7, 'YYYYMMDD');

        -- Table[3]
        --SELECT plan_start_yyyymmdd + '_' + division_id + '_' + plan_type + '_' +  CONVERT(NVARCHAR, MAX(PLAN_SEQ)) as CODE
        --SCP PLAN ID 정렬순서 수정(2025-07-04)
        OPEN O_RC4 FOR
        SELECT MAX(PLAN_VERSION_ID)       AS CODE   -- SCP Code값 변경(2025-06-19)
             , PLAN_START_YYYYMMDD || '_' || DIVISION_ID || '_' || PLAN_TYPE || '_' || TO_CHAR(MAX(PLAN_SEQ)) AS NAME
             , 'SCP'                      AS PLAN_TYPE
             , PLAN_TYPE_ORDER
          FROM SCP_PLAN_VERSION_V
         WHERE DIVISION_ID        = UPPER(P_DIVISION_ID)
           AND PLAN_START_YYYYMMDD IN (V_DATE_1, V_DATE_2)
         GROUP BY PLAN_START_YYYYMMDD
                , DIVISION_ID
                , PLAN_TYPE
                , PLAN_TYPE_ORDER
         ORDER BY PLAN_START_YYYYMMDD DESC   -- 내림차순으로 정렬(2025-07-08)
                , PLAN_TYPE_ORDER DESC
                , DIVISION_ID;

        -- Table[4]
        OPEN O_RC5 FOR
        SELECT OPMZ_PLAN_ID
             , OPMZ_PRAM_TP_CD
             , OPMZ_PLAN_DESC
             , PROD_REF_SYS_DIVS_CD
             , PROD_REF_SYS_PLAN_ID
             , PLAN_END_YYYYMMDD      --[PJ20257329] Horizon End 일자 변경 가능하도록 수정 (2025-10-13)
             , PMDU_PROD_FRZ_START_YYYYMMDD
             , PMDU_PROD_FRZ_END_YYYYMMDD
             , CELL_PROD_FRZ_START_YYYYMMDD
             , CELL_PROD_FRZ_END_YYYYMMDD
             , SHIP_REF_SYS_DIVS_CD
             , SHIP_REF_SYS_PLAN_ID
             , SHIP_FRZ_START_YYYYMMDD
             , SHIP_FRZ_END_YYYYMMDD
             , ATTRIBUTE1             AS PROD_NO_FROZEN_YN
             , ATTRIBUTE2             AS CELL_NO_FROZEN_YN
             , ATTRIBUTE3             AS SHIP_NO_FROZEN_YN
          FROM SCP_OPMZ_PLAN_M
         WHERE UPPER(OPMZ_PLAN_ID) = UPPER(P_PLAN_ID);

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('PKG_SCP0123.P_SCP0123_GET_PLAN_ID_INFO'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID
                     || ', P_PLAN_GROUP_ID=' || P_PLAN_GROUP_ID
                     || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                     || ', P_PLAN_ID=' || P_PLAN_ID
                      , SQLCODE
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            IF NOT O_RC1%ISOPEN THEN
                OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
            END IF;
            IF NOT O_RC2%ISOPEN THEN
                OPEN O_RC2 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
            END IF;
            IF NOT O_RC3%ISOPEN THEN
                OPEN O_RC3 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
            END IF;
            IF NOT O_RC4%ISOPEN THEN
                OPEN O_RC4 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
            END IF;
            IF NOT O_RC5%ISOPEN THEN
                OPEN O_RC5 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
            END IF;

    END P_SCP0123_GET_PLAN_ID_INFO;


    /*
     * Program ID   : SCP0123_SAVE_PLAN_CTRL_ACTV_RUN
     * Description  : Activity 실행 등록
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2025/05/12   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
     * 2025/06/11   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Plan Out Review and Amend 분리 실행 추가
     * 2025/06/25   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - A009  Ship Plan Semi Cut-Off (To Packer) 여러번 Cut-off 가능하도록 변경
     * 2025/08/18   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Plan Out Review and Amend 분리 실행 (EE) 추가
     * 2025/09/01   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 일단위 Plan date 운영(81_UC, EE_UC), A009-Ship Plan Semi Cut-Off (To Packer) 호출 시 Plan Group 넘기도록
     * 2025/09/19   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - A004, A005 여러번 I/F 가능하도록 변경
     * 2026/09/17   AJS             MSSQL -> Oracle 전환 (이름 SCP0123_SAVE_PLAN_CTRL_ACTV_RUN -> P_SCP0123_SAVE_PLAN_ACTV_RUN)
     *                              엔진 연계 프로시저 미이관 - 호출 자리에서 오류 반환
     * 2026/09/17   AJS             코드 컬럼 대문자 등록 · 대소문자만 다른 같은 키는 기본키 위반 처리
     * 2026/10/20   AJS             엔진 연계 프로시저 이관 반영 - 호출 자리 오류 반환 해제(A004 81·40·EE·82 · A005 · A009, GM_A·GM_EE 는 AS-IS 운영에도 없어 유지)
     *
     */
    PROCEDURE P_SCP0123_SAVE_PLAN_ACTV_RUN
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PRS_CD                IN  VARCHAR2,
        P_PLAN_GR_ID            IN  VARCHAR2,
        P_ACTV_CD               IN  VARCHAR2,
        P_PLAN_ID               IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_CNT            OUT NUMBER,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        -- LOG 용 변수 설정
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PKG_SCP0123.P_SCP0123_SAVE_PLAN_ACTV_RUN';

        V_STAT_CD               VARCHAR2(50 CHAR);
        V_EXISTS                PLS_INTEGER := 0;

        /* AS-IS 대소문자 무시 비교 */
        -- 2026.09.17 AJS 선언부 길이 초과 방지 (START)
--      V_DIVISION_ID_U         VARCHAR2(50 CHAR)  := UPPER(P_DIVISION_ID);
--      V_ACTV_CD_U             VARCHAR2(30 CHAR)  := UPPER(P_ACTV_CD);
        V_DIVISION_ID_U         VARCHAR2(4000 CHAR) := UPPER(P_DIVISION_ID);
        V_ACTV_CD_U             VARCHAR2(4000 CHAR) := UPPER(P_ACTV_CD);
        -- 2026.09.17 AJS 선언부 길이 초과 방지 (END)

        -- 예외처리 변수 설정
        V_ERR_CODE              VARCHAR2(100 CHAR);
        V_ERR_MSG               VARCHAR2(4000 CHAR);
        V_BACKTRACE             VARCHAR2(4000 CHAR);
    BEGIN

        -- 시작 LOG
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', NULL, SYSDATE);

        --Plan Out Review and Amend 실행시
        IF V_ACTV_CD_U = 'A004' THEN

            IF INSTR(V_DIVISION_ID_U, '81') > 0 THEN   --자동차

                DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || 'Plan Out Review and Amend 실행 - PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL  ' || P_PLAN_ID || ', ' || P_PLAN_START_YYYYMMDD);
                /* PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL(P_PLAN_ID, P_PLAN_START_YYYYMMDD); */
--              P_RAISE_NOT_MIGRATED('PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL');    --  2026.10.20 AJS
                PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL(P_PLAN_ID, P_PLAN_START_YYYYMMDD);    --  2026.10.20 AJS

            ELSIF V_DIVISION_ID_U = '40' THEN   -- 소형

                DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || 'Plan Out Review and Amend 실행 - PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL  ' || P_PLAN_ID || ', ' || P_PLAN_START_YYYYMMDD);
                /* PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL(P_PLAN_ID, P_PLAN_START_YYYYMMDD); */
--              P_RAISE_NOT_MIGRATED('PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL');    --  2026.10.20 AJS
                PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL(P_PLAN_ID, P_PLAN_START_YYYYMMDD);    --  2026.10.20 AJS

            --[PJ20257329] Plan Out Review and Amend 분리 실행 (EE) 추가(2025-08-18) START
            ELSIF V_DIVISION_ID_U = 'EE' THEN   -- EE

                DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || 'Plan Out Review and Amend 실행 - PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_EE  ' || P_PLAN_ID || ', ' || P_PLAN_START_YYYYMMDD);
                /* PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_EE(P_PLAN_ID, P_PLAN_START_YYYYMMDD); */
--              P_RAISE_NOT_MIGRATED('PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_EE');    --  2026.10.20 AJS
                PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_EE(P_PLAN_ID, P_PLAN_START_YYYYMMDD);    --  2026.10.20 AJS

            --[PJ20257329] Plan Out Review and Amend 분리 실행 (EE) 추가(2025-08-18) END
            --[PJ20257329] 일단위 Plan date 운영(81_UC, EE_UC)(2025-09-01) START
            ELSIF V_DIVISION_ID_U = '82' THEN   -- ESS

                DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || 'Plan Out Review and Amend 실행 - PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_ESS  ' || P_PLAN_ID || ', ' || P_PLAN_START_YYYYMMDD);
                /* PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_ESS(P_PLAN_ID, P_PLAN_START_YYYYMMDD); */
--              P_RAISE_NOT_MIGRATED('PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_ESS');    --  2026.10.20 AJS
                PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_ESS(P_PLAN_ID, P_PLAN_START_YYYYMMDD);    --  2026.10.20 AJS

            /* AS-IS 와 같이 '81_UC' 는 위 '81' 포함 조건에 먼저 걸려 이 갈래로 오지 않는다 */
            ELSIF V_DIVISION_ID_U = '81_UC' THEN   -- 81_UC

                DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || 'Plan Out Review and Amend 실행 - PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_GM_A  ' || P_PLAN_ID || ', ' || P_PLAN_START_YYYYMMDD);
                /* PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_GM_A(P_PLAN_ID, P_PLAN_START_YYYYMMDD); */
                P_RAISE_NOT_MIGRATED('PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_GM_A');

            /* PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_GM_EE 는 AS-IS 운영에도 없는 프로시저 */
            ELSIF V_DIVISION_ID_U = 'EE_UC' THEN   -- EE_UC

                DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || 'Plan Out Review and Amend 실행 - PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_GM_EE  ' || P_PLAN_ID || ', ' || P_PLAN_START_YYYYMMDD);
                /* PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_GM_EE(P_PLAN_ID, P_PLAN_START_YYYYMMDD); */
                P_RAISE_NOT_MIGRATED('PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_GM_EE');

            END IF;
            --[PJ20257329] 일단위 Plan date 운영(81_UC, EE_UC)(2025-09-01) END

        END IF;

        --FP Target I/F 실행시
        IF V_ACTV_CD_U = 'A005' THEN

            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || 'FP Target I/F 실행 - PR_SCP_OPT_ENG_OUTPUT_FP_PROD_TARGET ' || P_PLAN_ID || ', ' || P_PLAN_START_YYYYMMDD);
            /* PR_SCP_OPT_ENG_OUTPUT_FP_PROD_TARGET(P_PLAN_ID, P_PLAN_START_YYYYMMDD); */
--          P_RAISE_NOT_MIGRATED('PR_SCP_OPT_ENG_OUTPUT_FP_PROD_TARGET');    --  2026.10.20 AJS
            PR_SCP_OPT_ENG_OUTPUT_FP_PROD_TARGET(P_PLAN_ID, P_PLAN_START_YYYYMMDD);    --  2026.10.20 AJS

        END IF;

        --소형 Shipment SEMI Snapshot 실행시
        IF V_ACTV_CD_U = 'A009' THEN

            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || '소형 Shipment SEMI Snapshot 실행 - PR_SCP_OPT_ENG_INPUT_SHIPMENT_SNAPSHOT ' || P_PLAN_ID || ', ' || P_DIVISION_ID || ', ' || P_PLAN_START_YYYYMMDD || ', ' || P_PLAN_GR_ID);
            /* PR_SCP_OPT_ENG_INPUT_SHIPMENT_SNAPSHOT(P_PLAN_ID, P_DIVISION_ID, P_PLAN_START_YYYYMMDD, P_PLAN_GR_ID); */   --[PJ20257329] A009-Ship Plan Semi Cut-Off (To Packer) 호출 시 Plan Group 넘기도록(2025-09-03)
--          P_RAISE_NOT_MIGRATED('PR_SCP_OPT_ENG_INPUT_SHIPMENT_SNAPSHOT');    --  2026.10.20 AJS
            PR_SCP_OPT_ENG_INPUT_SHIPMENT_SNAPSHOT(P_PLAN_ID, P_DIVISION_ID, P_PLAN_START_YYYYMMDD, P_PLAN_GR_ID);    --  2026.10.20 AJS

            --소형 Shipment SEMI Snapshot 재실행인 경우, LAST_UPDATE_DATE만 업데이트 START (2025-06-25)
            BEGIN
                SELECT 1
                  INTO V_EXISTS
                  FROM SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M
                 WHERE PLAN_START_YYYYMMDD    = P_PLAN_START_YYYYMMDD
                   AND OPMZ_PRS_CD            = UPPER(P_PRS_CD)
                   AND OPMZ_PLAN_GR_ID        = UPPER(P_PLAN_GR_ID)
                   AND OPMZ_ACTV_CD           = V_ACTV_CD_U
                   AND ROWNUM                 = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_EXISTS := 0;
            END;

            IF V_EXISTS > 0 THEN

                UPDATE SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M
                   SET LAST_UPDATE_DATE       = SYSDATE
                     , LAST_UPDATED_BY        = P_USER_ID
                 WHERE PLAN_START_YYYYMMDD    = P_PLAN_START_YYYYMMDD
                   AND OPMZ_PRS_CD            = UPPER(P_PRS_CD)
                   AND OPMZ_PLAN_GR_ID        = UPPER(P_PLAN_GR_ID)
                   AND OPMZ_ACTV_CD           = V_ACTV_CD_U;

                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', NULL, SYSDATE);

                COMMIT;

                -- 결과코드, 결과 카운트 반환
                O_RESULT_CODE := 'S';
                O_RESULT_CNT  := 1;
                O_RESULT_MSG  := NULL;

                RETURN;

            END IF;
            --소형 Shipment SEMI Snapshot 재실행인 경우, LAST_UPDATE_DATE만 업데이트 END (2025-06-25)

        END IF;

        --[PJ20257329] A004, A005 여러번 I/F 가능하도록 변경 (2025-09-19) START
        IF V_ACTV_CD_U IN ('A004', 'A005') THEN

            V_EXISTS := 0;

            BEGIN
                SELECT 1
                  INTO V_EXISTS
                  FROM SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M
                 WHERE DIVISION_ID            = V_DIVISION_ID_U
                   AND PLAN_START_YYYYMMDD    = P_PLAN_START_YYYYMMDD
                   AND OPMZ_PRS_CD            = UPPER(P_PRS_CD)
                   AND OPMZ_PLAN_GR_ID        = UPPER(P_PLAN_GR_ID)
                   AND OPMZ_ACTV_CD           = V_ACTV_CD_U
                   AND UPPER(OPMZ_PLAN_ID)    = UPPER(P_PLAN_ID)
                   AND ROWNUM                 = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_EXISTS := 0;
            END;

            IF V_EXISTS > 0 THEN

                UPDATE SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M
                   SET LAST_UPDATE_DATE       = SYSDATE
                     , LAST_UPDATED_BY        = P_USER_ID
                 WHERE DIVISION_ID            = V_DIVISION_ID_U
                   AND PLAN_START_YYYYMMDD    = P_PLAN_START_YYYYMMDD
                   AND OPMZ_PRS_CD            = UPPER(P_PRS_CD)
                   AND OPMZ_PLAN_GR_ID        = UPPER(P_PLAN_GR_ID)
                   AND OPMZ_ACTV_CD           = V_ACTV_CD_U
                   AND UPPER(OPMZ_PLAN_ID)    = UPPER(P_PLAN_ID);

                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', NULL, SYSDATE);

                COMMIT;

                -- 결과코드, 결과 카운트 반환
                O_RESULT_CODE := 'S';
                O_RESULT_CNT  := 1;
                O_RESULT_MSG  := NULL;

                RETURN;

            END IF;

        END IF;
        --[PJ20257329] A0005 여러번 I/F 가능하도록 변경 (2025-09-19) END

        -- 2026.09.17 AJS 대소문자만 다른 같은 키는 기본키 위반 처리 (START)
        V_EXISTS := 0;
        BEGIN
            SELECT 1
              INTO V_EXISTS
              FROM SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M
             WHERE PLAN_START_YYYYMMDD    = P_PLAN_START_YYYYMMDD
               AND OPMZ_PRS_CD            = UPPER(P_PRS_CD)
               AND OPMZ_PLAN_GR_ID        = UPPER(P_PLAN_GR_ID)
               AND OPMZ_ACTV_CD           = V_ACTV_CD_U
               AND UPPER(OPMZ_PLAN_ID)    = UPPER(P_PLAN_ID)
               AND ROWNUM                 = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_EXISTS := 0;
        END;
        IF V_EXISTS > 0 THEN
            RAISE DUP_VAL_ON_INDEX;
        END IF;
        -- 2026.09.17 AJS 대소문자만 다른 같은 키는 기본키 위반 처리 (END)

        --Engine Run 인 경우는 'W'를 등록
        IF V_ACTV_CD_U = 'A003' THEN
            V_STAT_CD := 'W';
        ELSE
            V_STAT_CD := 'C';
        END IF;

        INSERT INTO SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M
             ( PLAN_START_YYYYMMDD
             , OPMZ_PRS_CD
             , OPMZ_PLAN_GR_ID
             , OPMZ_ACTV_CD
             , OPMZ_PLAN_ID
             , OPMZ_ACTV_RUN_STAT_CD
             , DIVISION_ID
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             )
        VALUES
             ( P_PLAN_START_YYYYMMDD
             -- 2026.09.17 AJS 코드 컬럼 대문자 등록 (START)
--           , P_PRS_CD
--           , P_PLAN_GR_ID
--           , P_ACTV_CD
--           , P_PLAN_ID
--           , V_STAT_CD
--           , P_DIVISION_ID
             , UPPER(P_PRS_CD)
             , UPPER(P_PLAN_GR_ID)
             , V_ACTV_CD_U
             , P_PLAN_ID
             , V_STAT_CD
             , V_DIVISION_ID_U
             -- 2026.09.17 AJS 코드 컬럼 대문자 등록 (END)
             , P_USER_ID
             , SYSDATE
             , P_USER_ID
             , SYSDATE
             );

        IF P_PLAN_ID <> '-' THEN    -- MS 원본이 '-'    --  2026.10.12 AJS

            --최종실행한 Activity의 Plan id를 변경
            UPDATE SCP_OPMZ_PLAN_CTRL_ACTV_M
               SET LTST_RUN_OPMZ_PLAN_ID      = P_PLAN_ID
                 , LAST_UPDATE_DATE           = SYSDATE
             WHERE PLAN_START_YYYYMMDD        = P_PLAN_START_YYYYMMDD
               AND OPMZ_PRS_CD                = UPPER(P_PRS_CD)
               AND OPMZ_PLAN_GR_ID            = UPPER(P_PLAN_GR_ID)
               AND OPMZ_ACTV_CD               = V_ACTV_CD_U;

        END IF;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', NULL, SYSDATE);

        COMMIT;

        -- 결과코드, 결과 카운트 반환
        O_RESULT_CODE := 'S';
        O_RESULT_CNT  := 1;
        O_RESULT_MSG  := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE  := TO_CHAR(SQLCODE);
            V_ERR_MSG   := SUBSTR(SQLERRM, 1, 4000);
            V_BACKTRACE := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);

            INSERT INTO SCM_SYS_LOG_BATCH
                 ( PROGRAM_NAME
                 , LOG_TYPE
                 , LOG_COUNT
                 , LOG_MESSAGE
                 , DESCRIPTION
                 , IN_PARA_DATA
                 , SQL_ERR_CODE
                 , SQL_ERR_MSG
                 , SQL_BACKTRACE
                 , EVENT_DATE
                 , CREATION_DATE
                 , CREATED_BY
                 , LAST_UPDATE_DATE
                 , LAST_UPDATED_BY
                 )
            VALUES
                 ( V_PROGRAM_NAME
                 , 'ERROR'
                 , NULL
                 , SUBSTR(V_ERR_MSG, 1, 1000)
                 , NULL
                 , SUBSTR('P_DIVISION_ID=' || P_DIVISION_ID
                       || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                       || ', P_PRS_CD=' || P_PRS_CD
                       || ', P_PLAN_GR_ID=' || P_PLAN_GR_ID
                       || ', P_ACTV_CD=' || P_ACTV_CD
                       || ', P_PLAN_ID=' || P_PLAN_ID
                       || ', P_USER_ID=' || P_USER_ID, 1, 2000)
                 , V_ERR_CODE
                 , SUBSTR(V_ERR_MSG, 1, 2000)
                 , V_BACKTRACE
                 , SYSDATE
                 , SYSDATE
                 , V_PROGRAM_NAME
                 , SYSDATE
                 , V_PROGRAM_NAME
                 );

            /* AS-IS CATCH : IF @@TRANCOUNT > 0 COMMIT WORK - 오류 앞까지 처리분도 확정 */
            COMMIT;

            -- error코드, errror 메시지 반환
            O_RESULT_CODE := 'F';
            O_RESULT_CNT  := NULL;
            O_RESULT_MSG  := '[' || V_ERR_CODE || ']' || V_ERR_MSG;

    END P_SCP0123_SAVE_PLAN_ACTV_RUN;


    /*
     * Program ID   : SCP0123_SAVE_PLAN_ID_CREATE
     * Description  : Plan ID 등록
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2025/05/12   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
     * 2025/06/11   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Plan ID 채번시 plan group name 으로 채번
     * 2025/07/08   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - No Frozen 체크 추가
     * 2025/08/20   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Plan ID 채번시 ATTRIBUTE10 = 'AI' 인 정보 제외
     * 2025/09/05   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Plan ID 생성시 '_'가 있는 그룹명의 채번 수정
     * 2026/09/17   AJS             MSSQL -> Oracle 전환
     *                              Demand Version 빈 값은 이관 채움값 '-' 로 등록 (DMD_VER_ID NOT NULL)
     *                              Activity 실행 등록이 실패하면 그 결과를 돌려준다 (AS-IS 화면은 첫 결과셋의 'F' 를 받는다)
     * 2026/09/17   AJS             코드 컬럼(그룹 · 공정 · 사업부) 대문자 등록
     *
     */
    PROCEDURE P_SCP0123_SAVE_PLAN_ID_CREATE
    (
        P_DIVISION_ID                   IN  VARCHAR2,
        P_PLAN_GR_ID                    IN  VARCHAR2,
        P_PLAN_GR_NAME                  IN  VARCHAR2,
        P_PRS_CD                        IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_END_YYYYMMDD             IN  VARCHAR2,
        P_DMD_VER_ID                    IN  VARCHAR2,
        P_PROD_REF_SYS_DIVS_CD          IN  VARCHAR2,
        P_PROD_REF_SYS_PLAN_ID          IN  VARCHAR2,
        P_PROD_FRZ_START_YYYYMMDD       IN  VARCHAR2,
        P_PROD_FRZ_END_YYYYMMDD         IN  VARCHAR2,
        P_CELL_PROD_FRZ_START_YYYYMMDD  IN  VARCHAR2,
        P_CELL_PROD_FRZ_END_YYYYMMDD    IN  VARCHAR2,
        P_SHIP_REF_SYS_DIVS_CD          IN  VARCHAR2,
        P_SHIP_REF_SYS_PLAN_ID          IN  VARCHAR2,
        P_SHIP_FRZ_START_YYYYMMDD       IN  VARCHAR2,
        P_SHIP_FRZ_END_YYYYMMDD         IN  VARCHAR2,
        P_PRAM_TY_CD                    IN  VARCHAR2,
        P_PLAN_DESC                     IN  VARCHAR2,
        P_PROD_NO_FRZ_YN                IN  VARCHAR2,
        P_CELL_NO_FRZ_YN                IN  VARCHAR2,
        P_SHIP_NO_FRZ_YN                IN  VARCHAR2,
        P_USER_ID                       IN  VARCHAR2,
        O_RESULT_CODE                   OUT VARCHAR2,
        O_RESULT_CNT                    OUT NUMBER,
        O_RESULT_MSG                    OUT VARCHAR2
    )
    IS
        -- LOG 용 변수 설정
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PKG_SCP0123.P_SCP0123_SAVE_PLAN_ID_CREATE';

        V_STRKEY                VARCHAR2(50 CHAR);
        V_PLAN_ID               VARCHAR2(4000 CHAR);

        V_SUB_CODE              VARCHAR2(10 CHAR);
        V_SUB_CNT               NUMBER;
        V_SUB_MSG               VARCHAR2(4000 CHAR);

        -- 예외처리 변수 설정
        V_ERR_CODE              VARCHAR2(100 CHAR);
        V_ERR_MSG               VARCHAR2(4000 CHAR);
        V_BACKTRACE             VARCHAR2(4000 CHAR);
    BEGIN

        -- 시작 LOG
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', NULL, SYSDATE);

        /* AS-IS @strKey NVARCHAR(50) : 50자 초과분은 잘린다 */
        V_STRKEY := SUBSTR(P_PLAN_START_YYYYMMDD || '_' || P_DIVISION_ID || '_' || P_PLAN_GR_NAME || '_', 1, 50);   --채번시 plan group name 으로 채번(2025-06-11 요청)
        --Plan Id 채번(계획시작일_Div._Plan Group_Plan Group별 Seq)
        --SELECT @v_plan_id = @strKey + dbo.FN_ZERO_LPAD(CONVERT(NVARCHAR, CAST(ISNULL(MAX(SUBSTRING(OPMZ_PLAN_ID, 20, 3)), '000') AS INT) + 1 ), 3)
        -- Plan Group Name 길이 변동에 따른 에러 발생으로 Plan ID 마지막 3자리 잘라서 채번하도록 수정(2025-06-17)
        /* Plan ID 는 대소문자 혼재 - AS-IS 대소문자 무시 비교 */
        SELECT V_STRKEY || FN_ZERO_LPAD(TO_CHAR(TO_NUMBER(NVL(MAX(SUBSTR(OPMZ_PLAN_ID, -3)), '000')) + 1), 3)
          INTO V_PLAN_ID
          FROM SCP_OPMZ_PLAN_M
         WHERE UPPER(OPMZ_PLAN_ID) LIKE '%' || UPPER(V_STRKEY) || '%'
           AND OPMZ_PLAN_GR_ID    = UPPER(P_PLAN_GR_ID)   --[PJ20257329] Plan ID 생성시 '_'가 있는 그룹명의 채번 수정(2025-09-05)
           AND (ATTRIBUTE10 IS NULL OR UPPER(ATTRIBUTE10) <> 'AI');   --[PJ20257329] Plan ID 채번시 ATTRIBUTE10 = 'AI' 인 정보 제외 (2025-08-20)

        INSERT INTO SCP_OPMZ_PLAN_M
             ( OPMZ_PLAN_ID
             , OPMZ_PLAN_GR_ID
             , OPMZ_PRS_CD
             , DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_END_YYYYMMDD
             , DMD_VER_ID
             , OPMZ_PRAM_TP_CD
             , OPMZ_PLAN_DESC
             , PROD_REF_SYS_DIVS_CD
             , PROD_REF_SYS_PLAN_ID
             , PMDU_PROD_FRZ_START_YYYYMMDD
             , PMDU_PROD_FRZ_END_YYYYMMDD
             , CELL_PROD_FRZ_START_YYYYMMDD
             , CELL_PROD_FRZ_END_YYYYMMDD
             , SHIP_REF_SYS_DIVS_CD
             , SHIP_REF_SYS_PLAN_ID
             , SHIP_FRZ_START_YYYYMMDD
             , SHIP_FRZ_END_YYYYMMDD
             , ATTRIBUTE1   --prod_no_frz_yn    No Frozen 체크 추가(2025-07-08)
             , ATTRIBUTE2   --cell_no_frz_yn
             , ATTRIBUTE3   --ship_no_frz_yn
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             )
        VALUES
             ( V_PLAN_ID
             -- 2026.09.17 AJS 코드 컬럼 대문자 등록 (START)
--           , P_PLAN_GR_ID
--           , P_PRS_CD
--           , P_DIVISION_ID
--           , P_PLAN_START_YYYYMMDD
--           , P_PLAN_END_YYYYMMDD
             , UPPER(P_PLAN_GR_ID)
             , UPPER(P_PRS_CD)
             , UPPER(P_DIVISION_ID)
             , P_PLAN_START_YYYYMMDD
             , P_PLAN_END_YYYYMMDD
             -- 2026.09.17 AJS 코드 컬럼 대문자 등록 (END)
             , NVL(P_DMD_VER_ID, '-')   /* AS-IS 빈 문자 -> 이관 채움값 '-' */
             , P_PRAM_TY_CD
             , P_PLAN_DESC
             , P_PROD_REF_SYS_DIVS_CD
             , P_PROD_REF_SYS_PLAN_ID
             , P_PROD_FRZ_START_YYYYMMDD
             , P_PROD_FRZ_END_YYYYMMDD
             , P_CELL_PROD_FRZ_START_YYYYMMDD
             , P_CELL_PROD_FRZ_END_YYYYMMDD
             , P_SHIP_REF_SYS_DIVS_CD
             , P_SHIP_REF_SYS_PLAN_ID
             , P_SHIP_FRZ_START_YYYYMMDD
             , P_SHIP_FRZ_END_YYYYMMDD
             , P_PROD_NO_FRZ_YN   --No Frozen 체크 추가(2025-07-08)
             , P_CELL_NO_FRZ_YN
             , P_SHIP_NO_FRZ_YN
             , P_USER_ID
             , SYSDATE
             , P_USER_ID
             , SYSDATE
             );

        --SCP최적화계획제어활동, SCP최적화계획제어활동운행 정보 등록
        /* 하위 프로시저가 COMMIT 하므로 위 등록분도 함께 확정된다 (AS-IS 도 최종 COMMIT 으로 함께 확정) */
        P_SCP0123_SAVE_PLAN_ACTV_RUN(P_DIVISION_ID
                                   , P_PLAN_START_YYYYMMDD
                                   , P_PRS_CD
                                   , P_PLAN_GR_ID
                                   , 'A002'
                                   , V_PLAN_ID
                                   , P_USER_ID
                                   , V_SUB_CODE
                                   , V_SUB_CNT
                                   , V_SUB_MSG);

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', NULL, SYSDATE);

        COMMIT;

        -- 결과코드, 결과 카운트 반환
        IF V_SUB_CODE = 'S' THEN
            O_RESULT_CODE := 'S';
            O_RESULT_CNT  := 1;
            O_RESULT_MSG  := NULL;
        ELSE
            O_RESULT_CODE := NVL(V_SUB_CODE, 'F');
            O_RESULT_CNT  := NULL;
            O_RESULT_MSG  := V_SUB_MSG;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE  := TO_CHAR(SQLCODE);
            V_ERR_MSG   := SUBSTR(SQLERRM, 1, 4000);
            V_BACKTRACE := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);

            INSERT INTO SCM_SYS_LOG_BATCH
                 ( PROGRAM_NAME
                 , LOG_TYPE
                 , LOG_COUNT
                 , LOG_MESSAGE
                 , DESCRIPTION
                 , IN_PARA_DATA
                 , SQL_ERR_CODE
                 , SQL_ERR_MSG
                 , SQL_BACKTRACE
                 , EVENT_DATE
                 , CREATION_DATE
                 , CREATED_BY
                 , LAST_UPDATE_DATE
                 , LAST_UPDATED_BY
                 )
            VALUES
                 ( V_PROGRAM_NAME
                 , 'ERROR'
                 , NULL
                 , SUBSTR(V_ERR_MSG, 1, 1000)
                 , NULL
                 , SUBSTR('P_DIVISION_ID=' || P_DIVISION_ID
                       || ', P_PLAN_GR_ID=' || P_PLAN_GR_ID
                       || ', P_PLAN_GR_NAME=' || P_PLAN_GR_NAME
                       || ', P_PRS_CD=' || P_PRS_CD
                       || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                       || ', P_PLAN_END_YYYYMMDD=' || P_PLAN_END_YYYYMMDD
                       || ', P_DMD_VER_ID=' || P_DMD_VER_ID
                       || ', P_PRAM_TY_CD=' || P_PRAM_TY_CD
                       || ', P_USER_ID=' || P_USER_ID, 1, 2000)
                 , V_ERR_CODE
                 , SUBSTR(V_ERR_MSG, 1, 2000)
                 , V_BACKTRACE
                 , SYSDATE
                 , SYSDATE
                 , V_PROGRAM_NAME
                 , SYSDATE
                 , V_PROGRAM_NAME
                 );

            /* AS-IS CATCH : IF @@TRANCOUNT > 0 COMMIT WORK - 오류 앞까지 처리분도 확정 */
            COMMIT;

            -- error코드, errror 메시지 반환
            O_RESULT_CODE := 'F';
            O_RESULT_CNT  := NULL;
            O_RESULT_MSG  := '[' || V_ERR_CODE || ']' || V_ERR_MSG;

    END P_SCP0123_SAVE_PLAN_ID_CREATE;

END PKG_SCP0123;