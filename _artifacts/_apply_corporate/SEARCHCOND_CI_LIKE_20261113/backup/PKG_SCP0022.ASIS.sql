CREATE OR REPLACE PACKAGE BODY         PKG_SCP0022 IS
/* ==================================================================================================
   Program ID   : PKG_SCP0022
   Description  : SCP0022 Formation (Supply Master)
                  AS-IS SCP0022_GET_FORMATION · SCP0022_GET_FORMATION_EXCEPT · SCP0022_GET_FORMATION_EXCEPT_LT
                        SCP0022_SAVE_FORMATION · SCP0022_SAVE_FORMATION_EXCEPT · SCP0022_SAVE_FORMATION_EXCEPT_LT
                        PR_SCP_MST_FORMATION_HIST · PR_SCP_MST_FORMATION_EXCEPT_HIST · PR_SCP_MST_FORMATION_EXCEPT_LT_HIST
   화면 전송값
     - 조회 : divisionId · plantSiteId('ALL' / 쉼표 구분, SCM_SITE_ID 또는 PLANT_ID) · itemId(쉼표 구분)
     - 저장 : data = 행 배열 JSON(키 = 조회 결과 칸 이름, CRUD_TYPE = I/M/D) · sesUserId
   결과     : O_RESULT_CURSOR (CODE '0' 성공 / '-1' 실패, MSG, EVENT = 처리 행 수)
   ================================================================================================== */

    C_DUP_ERR_NO        CONSTANT PLS_INTEGER := -20010;                                              /* AS-IS 99010 */
    C_DUP_ERR_MSG       CONSTANT VARCHAR2(200 CHAR) := ' 입력 데이터 중 날짜가 중복되는 데이터가 있습니다.';
    C_INT_ERR_NO        CONSTANT PLS_INTEGER := -20245;                                              /* AS-IS 245 */

    /* ------------------------------------------------------------------------------------------------
       조회조건 목록 정규화 (AS-IS dbo.String_Split : 쉼표 분리 + 토큰 앞뒤 공백 제거, IN 비교는 대소문자 무시)
       ------------------------------------------------------------------------------------------------ */
    FUNCTION F_LIST_PARAM
    (
        P_VAL               IN  VARCHAR2
    )
    RETURN VARCHAR2
    IS
    BEGIN
        RETURN ',' || UPPER(REGEXP_REPLACE(TRIM(P_VAL), ' *, *', ',')) || ',';
    END F_LIST_PARAM;

    /* ------------------------------------------------------------------------------------------------
       AS-IS 정수 칸 암묵 변환 (NVARCHAR -> INT)
       빈 값 0 · 앞뒤 공백 허용 · 소수점/문자는 오류 245 · INT 범위 초과 오류
       ------------------------------------------------------------------------------------------------ */
    FUNCTION F_TO_INT
    (
        P_VAL               IN  VARCHAR2
    )
    RETURN NUMBER
    IS
        V_VAL               VARCHAR2(4000 CHAR) := TRIM(P_VAL);
    BEGIN
        IF V_VAL IS NULL THEN
            RETURN 0;
        END IF;

        IF NOT REGEXP_LIKE(V_VAL, '^[+-]?[0-9]+$') THEN
            RAISE_APPLICATION_ERROR(C_INT_ERR_NO, 'Conversion failed when converting the nvarchar value ''' || P_VAL || ''' to data type int.');
        END IF;

        IF TO_NUMBER(V_VAL) NOT BETWEEN -2147483648 AND 2147483647 THEN
            RAISE_APPLICATION_ERROR(C_INT_ERR_NO, 'The conversion of the nvarchar value ''' || P_VAL || ''' overflowed an int column.');
        END IF;

        RETURN TO_NUMBER(V_VAL);
    END F_TO_INT;

    /* ------------------------------------------------------------------------------------------------
       AS-IS convert(numeric(20,4), convert(float, x) / 100) 재현 (부동소수 값 기준 소수 4자리 반올림)
       빈 값 NULL (AS-IS CASE WHEN ISNULL(x,'')='' THEN null)
       ------------------------------------------------------------------------------------------------ */
    FUNCTION F_YIELD4
    (
        P_VAL               IN  VARCHAR2
    )
    RETURN NUMBER
    IS
        V_DBL               BINARY_DOUBLE;
    BEGIN
        IF TRIM(P_VAL) IS NULL THEN
            RETURN NULL;
        END IF;

        V_DBL := TO_BINARY_DOUBLE(TRIM(P_VAL)) / 100;

        RETURN SIGN(V_DBL) * TO_NUMBER(FLOOR(ABS(V_DBL) * 1E4D + 0.5D)) / 1E4;
    END F_YIELD4;

    /* ------------------------------------------------------------------------------------------------
       AS-IS convert(float, x) / 100 -> numeric(20,10) 칸 저장 (칸 자릿수에서 반올림)
       빈 값 NULL
       ------------------------------------------------------------------------------------------------ */
    FUNCTION F_YIELD10
    (
        P_VAL               IN  VARCHAR2
    )
    RETURN NUMBER
    IS
    BEGIN
        IF TRIM(P_VAL) IS NULL THEN
            RETURN NULL;
        END IF;

        RETURN TO_NUMBER(TRIM(P_VAL)) / 100;
    END F_YIELD10;

    /* ------------------------------------------------------------------------------------------------
       AS-IS 화면 ReturnStringDate (날짜 -> yyyyMMdd, 빈 값 '')
       화면 전송값 'YYYY-MM-DD' · 'YYYYMMDD' 모두 허용, 날짜가 아니면 오류
       ------------------------------------------------------------------------------------------------ */
    FUNCTION F_TO_YMD
    (
        P_VAL               IN  VARCHAR2
    )
    RETURN VARCHAR2
    IS
    BEGIN
        IF TRIM(P_VAL) IS NULL THEN
            RETURN NULL;
        END IF;

        RETURN TO_CHAR(TO_DATE(SUBSTR(REGEXP_REPLACE(P_VAL, '[^0-9]', ''), 1, 8), 'FXYYYYMMDD'), 'YYYYMMDD');
    END F_TO_YMD;

    /* ------------------------------------------------------------------------------------------------
       JV real plant site -> ESS virtual plant site 단방향 저장 (virtual plant 이면 skip) 판정
       ------------------------------------------------------------------------------------------------ */
    FUNCTION F_IS_VIRTUAL_SITE
    (
        P_DIVISION_ID       IN  VARCHAR2
      , P_PLANT_SITE_ID     IN  VARCHAR2
    )
    RETURN PLS_INTEGER
    IS
        V_CNT               PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(*)
          INTO V_CNT
          FROM SCM_MST_SITE A
             , SCM_MST_PLANT_SN B                                                                     /* COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID */
         WHERE A.COMPANY_ID = B.COMPANY_ID
           AND A.DIVISION_ID = B.DIVISION_ID
           AND A.SITE_ID = B.SITE_ID
           AND A.PLANT_ID = B.PLANT_ID
           AND B.PLANT_TYPE = 'VIRTUAL'
           AND A.DIVISION_ID = UPPER(RTRIM(P_DIVISION_ID))
           AND UPPER(A.SCM_SITE_ID) = UPPER(RTRIM(P_PLANT_SITE_ID))
           AND ROWNUM = 1;

        RETURN V_CNT;
    END F_IS_VIRTUAL_SITE;

    /* ------------------------------------------------------------------------------------------------
       오류 로그 (AS-IS CATCH : ROLLBACK 뒤 scm_sys_log_batch ERROR 행 기록 - 자율 트랜잭션)
       ------------------------------------------------------------------------------------------------ */
    PROCEDURE P_LOG_ERROR
    (
        P_PROGRAM_NAME      IN  VARCHAR2
      , P_IN_PARA_DATA      IN  VARCHAR2
      , P_SQLCODE           IN  VARCHAR2
      , P_SQLERRM           IN  VARCHAR2
      , P_BACKTRACE         IN  VARCHAR2
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
                           , P_SQLCODE
                           , SUBSTR(P_SQLERRM, 1, 2000)
                           , SUBSTR(P_BACKTRACE, 1, 4000));
    END P_LOG_ERROR;

    /* ------------------------------------------------------------------------------------------------
       오류 문구 (사용자 정의 오류는 ORA 번호 머리말 제거)
       ------------------------------------------------------------------------------------------------ */
    FUNCTION F_ERR_MSG
    (
        P_SQLCODE           IN  NUMBER
      , P_SQLERRM           IN  VARCHAR2
    )
    RETURN VARCHAR2
    IS
    BEGIN
        IF P_SQLCODE BETWEEN -20999 AND -20000 THEN
            RETURN SUBSTR(P_SQLERRM, 12, 4000);
        END IF;

        RETURN SUBSTR(P_SQLERRM, 1, 4000);
    END F_ERR_MSG;

/*
 * Program ID   : PR_SCP_MST_FORMATION_HIST
 * Description  : Formation Master History
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018.03		KYH				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2109.04.08	hwyoon			[CSR:]GSCM 고도화 - Formation 수율 필드 추가, 기능개선
 * 2019/04/11	AYJ				SSP_MODIFY_YIELD 컬럼 추가
 *
 */
    PROCEDURE P_SCP_MST_FORMATION_HIST
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_PLANT_SITE_ID         IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_LF_FORMATION          IN  NUMBER
      , P_ADD_LT_FORMATION      IN  VARCHAR2
      , P_FORMATION_YIELD       IN  NUMBER
      , P_CHAR_YIELD            IN  NUMBER
      , P_FORMATION_TOTAL_YIELD IN  NUMBER
      , P_CREATED_BY            IN  VARCHAR2
      , P_LAST_UPDATED_BY       IN  VARCHAR2
      , P_CREATION_DATE         IN  DATE
      , P_USER_MODIFY_YIELD     IN  NUMBER
    )
    IS
    BEGIN
        INSERT INTO SCP_MST_FORMATION_H
             ( HISTORY_SEQ
             , DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , LT_FORMATION
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             , ATTRIBUTE1
             , SSP_MODIFY_YIELD
             )
        VALUES
             ( SEQ1_SCP_MST_FORMATION_H.NEXTVAL
             , P_DIVISION_ID
             , P_PLANT_SITE_ID
             , P_ITEM_ID
             , P_LF_FORMATION
             , P_FORMATION_YIELD
             , P_CHAR_YIELD
             , P_FORMATION_TOTAL_YIELD
             , P_CREATED_BY
             , P_CREATION_DATE
             , P_LAST_UPDATED_BY
             , SYSDATE
             , SYSDATE
             , P_ADD_LT_FORMATION
             , P_USER_MODIFY_YIELD
             );
    END P_SCP_MST_FORMATION_HIST;

/*
 * Program ID   : PR_SCP_MST_FORMATION_EXCEPT_HIST
 * Description  : FORMATION EXCEPT History
 * Program History
 *===================================================================================================
 *   Date       In Charge			Description
 *===================================================================================================
 * 2018.05.09   byunghunjung		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.04.08	hwyoon				[CSR:]GSCM 고도화 - Formation 수율 필드 추가, 기능개선
 *
 */
    PROCEDURE P_SCP_MST_FORMATION_EXCEPT_HIST
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_PLANT_SITE_ID         IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FORMATION_START_DATE  IN  VARCHAR2
      , P_FORMATION_END_DATE    IN  VARCHAR2
      , P_FORMATION_YIELD       IN  NUMBER
      , P_CHAR_YIELD            IN  NUMBER
      , P_FORMATION_TOTAL_YIELD IN  NUMBER
      , P_EXCEPT_COMMENT        IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , P_LAST_UPDATED_BY       IN  VARCHAR2
      , P_CREATION_DATE         IN  DATE
    )
    IS
    BEGIN
        INSERT INTO SCP_MST_FORMATION_EXCEPT_H
             ( HISTORY_SEQ
             , DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , FORMATION_START_DATE
             , FORMATION_END_DATE
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , EXCEPT_COMMENT
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             )
        VALUES
             ( SEQ1_SCP_MST_FORMATION_EXCEPT_H.NEXTVAL
             , P_DIVISION_ID
             , P_PLANT_SITE_ID
             , P_ITEM_ID
             , P_FORMATION_START_DATE
             , P_FORMATION_END_DATE
             , P_FORMATION_YIELD
             , P_CHAR_YIELD
             , P_FORMATION_TOTAL_YIELD
             , P_EXCEPT_COMMENT
             , P_CREATED_BY
             , P_CREATION_DATE
             , P_LAST_UPDATED_BY
             , SYSDATE
             , SYSDATE
             );
    END P_SCP_MST_FORMATION_EXCEPT_HIST;

/*
 * Program ID   : PR_SCP_MST_FORMATION_EXCEPT_LT_HIST
 * Description  : FORMATION EXCEPT LT History
 * Program History
 *===================================================================================================
 *   Date       In Charge			Description
 *===================================================================================================
 * 2025/09/22   KH 	            Initial Release  PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
 *
 */
    PROCEDURE P_SCP_MST_FORMATION_EXCEPT_LT_HIST
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_PLANT_SITE_ID         IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FORMATION_START_DATE  IN  VARCHAR2
      , P_FORMATION_END_DATE    IN  VARCHAR2
      , P_LT_FORMATION          IN  NUMBER
      , P_ADD_LT_FORMATION      IN  NUMBER
      , P_EXCEPT_COMMENT        IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , P_LAST_UPDATED_BY       IN  VARCHAR2
      , P_CREATION_DATE         IN  DATE
    )
    IS
    BEGIN
        /* AS-IS @p_attribute1 ~ @p_attribute10 은 호출 측이 항상 빈 토큰(NULL)을 넘긴다 */
        INSERT INTO SCP_OPMZ_MST_FORMATION_EXCEPT_LT_H
             ( HISTORY_SEQ
             , DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , FORMATION_START_DATE
             , FORMATION_END_DATE
             , LT_FORMATION
             , ADD_LT_FORMATION
             , EXCEPT_COMMENT
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
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             )
        VALUES
             ( SEQ1_SCP_MST_FORMATION_EXCEPT_H.NEXTVAL
             , P_DIVISION_ID
             , P_PLANT_SITE_ID
             , P_ITEM_ID
             , P_FORMATION_START_DATE
             , P_FORMATION_END_DATE
             , P_LT_FORMATION
             , P_ADD_LT_FORMATION
             , P_EXCEPT_COMMENT
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , P_CREATED_BY
             , P_CREATION_DATE
             , P_LAST_UPDATED_BY
             , SYSDATE
             , SYSDATE
             );
    END P_SCP_MST_FORMATION_EXCEPT_LT_HIST;

    /* ------------------------------------------------------------------------------------------------
       [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
       SCP0022_SAVE_FORMATION #.1 ~ #.4
       ------------------------------------------------------------------------------------------------ */
    PROCEDURE P_SYNC_FORMATION_VIRTUAL_SITE
    (
        P_DIVISION_ID       IN  VARCHAR2
      , P_PLANT_SITE_ID     IN  VARCHAR2
      , P_ITEM_ID           IN  VARCHAR2
      , P_USER_ID           IN  VARCHAR2
    )
    IS
    BEGIN
        /* #.1 가상 Plant 사이트 대상 데이터 추출 */
        DELETE FROM GT_0022_FORMATION_VIRTUAL_SITE;

        INSERT INTO GT_0022_FORMATION_VIRTUAL_SITE
             ( VS_DIVISION_ID
             , VS_PLANT_SITE_ID
             , VS_PLANT_ID
             , RS_DIVISION_ID
             , RS_PLANT_SITE_ID
             , RS_PLANT_ID
             , ITEM_ID
             , LT_FORMATION
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , SSP_MODIFY_YIELD
             , ATTRIBUTE1
             , RN
             )
        SELECT B.DIVISION_ID AS VS_DIVISION_ID
             , B.SCM_SITE_ID AS VS_PLANT_SITE_ID
             , B.PLANT_ID AS VS_PLANT_ID
             , C.DIVISION_ID AS RS_DIVISION_ID
             , C.SCM_SITE_ID AS RS_PLANT_SITE_ID
             , C.PLANT_ID AS RS_PLANT_ID
             , D.ITEM_ID
             , D.LT_FORMATION
             , D.FORMATION_YIELD
             , D.CHAR_YIELD
             , D.FORMATION_TOTAL_YIELD
             , D.SSP_MODIFY_YIELD
             , D.ATTRIBUTE1
             , ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
                                             , UPPER(B.SCM_SITE_ID)
                                             , D.ITEM_ID
                                      ORDER BY D.LAST_UPDATE_DATE DESC) AS RN
          FROM SCM_MST_PLANT_SN A
             , SCM_MST_SITE B
             , SCM_MST_SITE C
             , SCP_MST_FORMATION D                                                                    /* DIVISION_ID, PLANT_SITE_ID, ITEM_ID */
         WHERE B.COMPANY_ID = A.COMPANY_ID
           AND B.DIVISION_ID = A.DIVISION_ID
           AND B.PLANT_ID = A.PLANT_ID
           AND B.SITE_ID = A.SITE_ID
           AND UPPER(C.SCM_SITE_ID) = UPPER(B.ATTRIBUTE9)
           AND C.PLANT_ID = A.LINK_PLANT_ID
           AND D.DIVISION_ID = C.DIVISION_ID
           AND D.PLANT_SITE_ID = UPPER(C.SCM_SITE_ID)
           AND B.SITE_TYPE = 'PLANT'
           AND B.VALID_YN = 'Y'
           AND C.SITE_TYPE = 'PLANT'
           AND C.VALID_YN = 'Y'
           AND A.PLANT_TYPE = 'VIRTUAL'
           AND C.DIVISION_ID = UPPER(RTRIM(P_DIVISION_ID))                                            /* Real plant 기준 */
           AND UPPER(C.SCM_SITE_ID) = UPPER(RTRIM(P_PLANT_SITE_ID))
           AND D.ITEM_ID = UPPER(RTRIM(P_ITEM_ID));

        /* #.2 가상 Plant 사이트 대상 이력 생성 */
        INSERT INTO SCP_MST_FORMATION_H
             ( HISTORY_SEQ
             , DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , LT_FORMATION
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , SSP_MODIFY_YIELD
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , HISTORY_CREATION_DATE
             )
        SELECT SEQ1_SCP_MST_FORMATION_H.NEXTVAL AS HISTORY_SEQ
             , A.DIVISION_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.LT_FORMATION
             , A.FORMATION_YIELD
             , A.CHAR_YIELD
             , A.FORMATION_TOTAL_YIELD
             , A.SSP_MODIFY_YIELD
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , A.ATTRIBUTE1
             , SYSDATE AS HISTORY_CREATION_DATE
          FROM SCP_MST_FORMATION A
             , GT_0022_FORMATION_VIRTUAL_SITE B
         WHERE B.VS_DIVISION_ID = A.DIVISION_ID
           AND UPPER(B.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
           AND B.ITEM_ID = A.ITEM_ID
           AND B.RN = 1
           AND (   NVL(B.LT_FORMATION, 0) <> NVL(A.LT_FORMATION, 0)
                OR NVL(B.FORMATION_YIELD, 0) <> NVL(A.FORMATION_YIELD, 0)
                OR NVL(B.CHAR_YIELD, 0) <> NVL(A.CHAR_YIELD, 0)
                OR NVL(B.FORMATION_TOTAL_YIELD, 0) <> NVL(A.FORMATION_TOTAL_YIELD, 0)
                OR NVL(B.SSP_MODIFY_YIELD, 0) <> NVL(A.SSP_MODIFY_YIELD, 0)
                OR DECODE(UPPER(RTRIM(B.ATTRIBUTE1)), UPPER(RTRIM(A.ATTRIBUTE1)), 0, 1) = 1
               );

        /* #.3 가상 Plant 사이트 대상 데이터 Update */
        UPDATE SCP_MST_FORMATION A
           SET ( A.LT_FORMATION
               , A.FORMATION_YIELD
               , A.CHAR_YIELD
               , A.FORMATION_TOTAL_YIELD
               , A.SSP_MODIFY_YIELD
               , A.ATTRIBUTE1
               )
             = (SELECT SA.LT_FORMATION
                     , SA.FORMATION_YIELD
                     , SA.CHAR_YIELD
                     , SA.FORMATION_TOTAL_YIELD
                     , SA.SSP_MODIFY_YIELD
                     , SA.ATTRIBUTE1
                  FROM GT_0022_FORMATION_VIRTUAL_SITE SA
                 WHERE SA.VS_DIVISION_ID = A.DIVISION_ID
                   AND UPPER(SA.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
                   AND SA.ITEM_ID = A.ITEM_ID
                   AND SA.RN = 1)
             , A.LAST_UPDATE_DATE = SYSDATE
             , A.LAST_UPDATED_BY = P_USER_ID
         WHERE EXISTS (SELECT 1
                         FROM GT_0022_FORMATION_VIRTUAL_SITE XA
                        WHERE XA.VS_DIVISION_ID = A.DIVISION_ID
                          AND UPPER(XA.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
                          AND XA.ITEM_ID = A.ITEM_ID
                          AND XA.RN = 1
                          AND (   NVL(XA.LT_FORMATION, 0) <> NVL(A.LT_FORMATION, 0)
                               OR NVL(XA.FORMATION_YIELD, 0) <> NVL(A.FORMATION_YIELD, 0)
                               OR NVL(XA.CHAR_YIELD, 0) <> NVL(A.CHAR_YIELD, 0)
                               OR NVL(XA.FORMATION_TOTAL_YIELD, 0) <> NVL(A.FORMATION_TOTAL_YIELD, 0)
                               OR NVL(XA.SSP_MODIFY_YIELD, 0) <> NVL(A.SSP_MODIFY_YIELD, 0)
                               OR DECODE(UPPER(RTRIM(XA.ATTRIBUTE1)), UPPER(RTRIM(A.ATTRIBUTE1)), 0, 1) = 1
                              ));

        /* #.4 가상 Plant 사이트 대상 데이터 insert */
        INSERT INTO SCP_MST_FORMATION
             ( DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , LT_FORMATION
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , SSP_MODIFY_YIELD
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             )
        SELECT A.VS_DIVISION_ID
             , A.VS_PLANT_SITE_ID
             , A.ITEM_ID
             , A.LT_FORMATION
             , A.FORMATION_YIELD
             , A.CHAR_YIELD
             , A.FORMATION_TOTAL_YIELD
             , A.SSP_MODIFY_YIELD
             , P_USER_ID AS CREATED_BY
             , SYSDATE AS CREATION_DATE
             , P_USER_ID AS LAST_UPDATED_BY
             , SYSDATE AS LAST_UPDATE_DATE
             , A.ATTRIBUTE1
          FROM GT_0022_FORMATION_VIRTUAL_SITE A
         WHERE NOT EXISTS (SELECT 1
                             FROM SCP_MST_FORMATION SA
                            WHERE SA.DIVISION_ID = A.VS_DIVISION_ID
                              AND SA.PLANT_SITE_ID = UPPER(A.VS_PLANT_SITE_ID)
                              AND SA.ITEM_ID = A.ITEM_ID)
           AND A.RN = 1;
    END P_SYNC_FORMATION_VIRTUAL_SITE;

    /* ------------------------------------------------------------------------------------------------
       [PJ2025F254] SCP0022_SAVE_FORMATION_EXCEPT 등록·수정 #.1 ~ #.4
       ------------------------------------------------------------------------------------------------ */
    PROCEDURE P_SYNC_EXCEPT_VIRTUAL_SITE
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_PLANT_SITE_ID         IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FORMATION_START_DATE  IN  VARCHAR2
      , P_FORMATION_END_DATE    IN  VARCHAR2
      , P_ORG_START_DATE        IN  VARCHAR2
      , P_ORG_END_DATE          IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
    )
    IS
    BEGIN
        /* #.1 가상 Plant 사이트 대상 데이터 추출 */
        DELETE FROM GT_0022_FORMATION_EXECPT_VIRTUAL_SITE;

        INSERT INTO GT_0022_FORMATION_EXECPT_VIRTUAL_SITE
             ( VS_DIVISION_ID
             , VS_PLANT_SITE_ID
             , VS_PLANT_ID
             , RS_DIVISION_ID
             , RS_PLANT_SITE_ID
             , RS_PLANT_ID
             , ITEM_ID
             , FORMATION_START_DATE
             , FORMATION_END_DATE
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , SSP_MODIFY_YIELD
             , EXCEPT_COMMENT
             , RN
             )
        SELECT B.DIVISION_ID AS VS_DIVISION_ID
             , B.SCM_SITE_ID AS VS_PLANT_SITE_ID
             , B.PLANT_ID AS VS_PLANT_ID
             , C.DIVISION_ID AS RS_DIVISION_ID
             , C.SCM_SITE_ID AS RS_PLANT_SITE_ID
             , C.PLANT_ID AS RS_PLANT_ID
             , D.ITEM_ID
             , D.FORMATION_START_DATE
             , D.FORMATION_END_DATE
             , D.FORMATION_YIELD
             , D.CHAR_YIELD
             , D.FORMATION_TOTAL_YIELD
             , D.SSP_MODIFY_YIELD
             , D.EXCEPT_COMMENT
             , ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
                                             , UPPER(B.SCM_SITE_ID)
                                             , D.ITEM_ID
                                             , D.FORMATION_START_DATE
                                             , D.FORMATION_END_DATE
                                      ORDER BY D.LAST_UPDATE_DATE DESC) AS RN
          FROM SCM_MST_PLANT_SN A
             , SCM_MST_SITE B
             , SCM_MST_SITE C
             , SCP_MST_FORMATION_EXCEPT D                                                             /* DIVISION_ID, PLANT_SITE_ID, ITEM_ID, FORMATION_START_DATE, FORMATION_END_DATE */
         WHERE B.COMPANY_ID = A.COMPANY_ID
           AND B.DIVISION_ID = A.DIVISION_ID
           AND B.PLANT_ID = A.PLANT_ID
           AND B.SITE_ID = A.SITE_ID
           AND UPPER(C.SCM_SITE_ID) = UPPER(B.ATTRIBUTE9)
           AND C.PLANT_ID = A.LINK_PLANT_ID
           AND D.DIVISION_ID = C.DIVISION_ID
           AND D.PLANT_SITE_ID = UPPER(C.SCM_SITE_ID)
           AND B.SITE_TYPE = 'PLANT'
           AND B.VALID_YN = 'Y'
           AND C.SITE_TYPE = 'PLANT'
           AND C.VALID_YN = 'Y'
           AND A.PLANT_TYPE = 'VIRTUAL'
           AND C.DIVISION_ID = UPPER(RTRIM(P_DIVISION_ID))                                            /* Real plant 기준 */
           AND UPPER(C.SCM_SITE_ID) = UPPER(RTRIM(P_PLANT_SITE_ID))
           AND D.ITEM_ID = UPPER(RTRIM(P_ITEM_ID))
           AND D.FORMATION_START_DATE = P_FORMATION_START_DATE
           AND D.FORMATION_END_DATE = P_FORMATION_END_DATE;

        /* #.2.1 가상 Plant 사이트 대상 이력 생성 */
        INSERT INTO SCP_MST_FORMATION_EXCEPT_H
             ( HISTORY_SEQ
             , DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , FORMATION_START_DATE
             , FORMATION_END_DATE
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , SSP_MODIFY_YIELD
             , EXCEPT_COMMENT
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             )
        SELECT SEQ1_SCP_MST_FORMATION_EXCEPT_H.NEXTVAL AS HISTORY_SEQ
             , A.DIVISION_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.FORMATION_START_DATE
             , A.FORMATION_END_DATE
             , A.FORMATION_YIELD
             , A.CHAR_YIELD
             , A.FORMATION_TOTAL_YIELD
             , A.SSP_MODIFY_YIELD
             , A.EXCEPT_COMMENT
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , SYSDATE AS HISTORY_CREATION_DATE
          FROM SCP_MST_FORMATION_EXCEPT A
             , GT_0022_FORMATION_EXECPT_VIRTUAL_SITE B
         WHERE B.VS_DIVISION_ID = A.DIVISION_ID
           AND UPPER(B.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
           AND B.ITEM_ID = A.ITEM_ID
           AND B.FORMATION_START_DATE = A.FORMATION_START_DATE
           AND B.FORMATION_END_DATE = A.FORMATION_END_DATE
           AND B.RN = 1
           AND (   NVL(B.FORMATION_YIELD, 0) <> NVL(A.FORMATION_YIELD, 0)
                OR NVL(B.CHAR_YIELD, 0) <> NVL(A.CHAR_YIELD, 0)
                OR NVL(B.FORMATION_TOTAL_YIELD, 0) <> NVL(A.FORMATION_TOTAL_YIELD, 0)
                OR NVL(B.SSP_MODIFY_YIELD, 0) <> NVL(A.SSP_MODIFY_YIELD, 0)
                OR DECODE(UPPER(RTRIM(B.EXCEPT_COMMENT)), UPPER(RTRIM(A.EXCEPT_COMMENT)), 0, 1) = 1
               );

        /* #.2.2 가상 Plant 사이트 이력 생성(날짜key컬럼 변경) */
        INSERT INTO SCP_MST_FORMATION_EXCEPT_H
             ( HISTORY_SEQ
             , DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , FORMATION_START_DATE
             , FORMATION_END_DATE
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , SSP_MODIFY_YIELD
             , EXCEPT_COMMENT
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             )
        SELECT SEQ1_SCP_MST_FORMATION_EXCEPT_H.NEXTVAL AS HISTORY_SEQ
             , A.DIVISION_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.FORMATION_START_DATE
             , A.FORMATION_END_DATE
             , A.FORMATION_YIELD
             , A.CHAR_YIELD
             , A.FORMATION_TOTAL_YIELD
             , A.SSP_MODIFY_YIELD
             , A.EXCEPT_COMMENT
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , SYSDATE AS HISTORY_CREATION_DATE
          FROM SCP_MST_FORMATION_EXCEPT A
             , GT_0022_FORMATION_EXECPT_VIRTUAL_SITE B
         WHERE B.VS_DIVISION_ID = A.DIVISION_ID
           AND UPPER(B.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
           AND B.ITEM_ID = A.ITEM_ID
           AND A.FORMATION_START_DATE = P_ORG_START_DATE
           AND A.FORMATION_END_DATE = P_ORG_END_DATE
           AND TRIM(P_ORG_START_DATE) IS NOT NULL
           AND (   P_ORG_START_DATE <> NVL(P_FORMATION_START_DATE, ' ')
                OR NVL(P_ORG_END_DATE, ' ') <> NVL(P_FORMATION_END_DATE, ' ')
               );

        /* #.2.3 가상 Plant 사이트 변경전 날짜 데이터 삭제 */
        /* key컬럼 변경하지 않고 delete/insert */
        DELETE
          FROM SCP_MST_FORMATION_EXCEPT A
         WHERE EXISTS (SELECT 1
                         FROM GT_0022_FORMATION_EXECPT_VIRTUAL_SITE SA
                        WHERE SA.VS_DIVISION_ID = A.DIVISION_ID
                          AND UPPER(SA.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
                          AND SA.ITEM_ID = A.ITEM_ID)
           AND A.FORMATION_START_DATE = P_ORG_START_DATE
           AND A.FORMATION_END_DATE = P_ORG_END_DATE
           AND TRIM(P_ORG_START_DATE) IS NOT NULL
           AND (   P_ORG_START_DATE <> NVL(P_FORMATION_START_DATE, ' ')
                OR NVL(P_ORG_END_DATE, ' ') <> NVL(P_FORMATION_END_DATE, ' ')
               );

        /* #.3 가상 Plant 사이트 대상 데이터 Update */
        UPDATE SCP_MST_FORMATION_EXCEPT A
           SET ( A.FORMATION_YIELD
               , A.CHAR_YIELD
               , A.FORMATION_TOTAL_YIELD
               , A.SSP_MODIFY_YIELD
               , A.EXCEPT_COMMENT
               )
             = (SELECT SA.FORMATION_YIELD
                     , SA.CHAR_YIELD
                     , SA.FORMATION_TOTAL_YIELD
                     , SA.SSP_MODIFY_YIELD
                     , SA.EXCEPT_COMMENT
                  FROM GT_0022_FORMATION_EXECPT_VIRTUAL_SITE SA
                 WHERE SA.VS_DIVISION_ID = A.DIVISION_ID
                   AND UPPER(SA.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
                   AND SA.ITEM_ID = A.ITEM_ID
                   AND SA.FORMATION_START_DATE = A.FORMATION_START_DATE
                   AND SA.FORMATION_END_DATE = A.FORMATION_END_DATE
                   AND SA.RN = 1)
             , A.LAST_UPDATE_DATE = SYSDATE
             , A.LAST_UPDATED_BY = P_USER_ID
         WHERE EXISTS (SELECT 1
                         FROM GT_0022_FORMATION_EXECPT_VIRTUAL_SITE XA
                        WHERE XA.VS_DIVISION_ID = A.DIVISION_ID
                          AND UPPER(XA.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
                          AND XA.ITEM_ID = A.ITEM_ID
                          AND XA.FORMATION_START_DATE = A.FORMATION_START_DATE
                          AND XA.FORMATION_END_DATE = A.FORMATION_END_DATE
                          AND XA.RN = 1
                          AND (   NVL(XA.FORMATION_YIELD, 0) <> NVL(A.FORMATION_YIELD, 0)
                               OR NVL(XA.CHAR_YIELD, 0) <> NVL(A.CHAR_YIELD, 0)
                               OR NVL(XA.FORMATION_TOTAL_YIELD, 0) <> NVL(A.FORMATION_TOTAL_YIELD, 0)
                               OR NVL(XA.SSP_MODIFY_YIELD, 0) <> NVL(A.SSP_MODIFY_YIELD, 0)
                               OR DECODE(UPPER(RTRIM(XA.EXCEPT_COMMENT)), UPPER(RTRIM(A.EXCEPT_COMMENT)), 0, 1) = 1
                              ));

        /* #.4 가상 Plant 사이트 대상 데이터 insert */
        INSERT INTO SCP_MST_FORMATION_EXCEPT
             ( DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , FORMATION_START_DATE
             , FORMATION_END_DATE
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , SSP_MODIFY_YIELD
             , EXCEPT_COMMENT
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             )
        SELECT A.VS_DIVISION_ID
             , A.VS_PLANT_SITE_ID
             , A.ITEM_ID
             , A.FORMATION_START_DATE
             , A.FORMATION_END_DATE
             , A.FORMATION_YIELD
             , A.CHAR_YIELD
             , A.FORMATION_TOTAL_YIELD
             , A.SSP_MODIFY_YIELD
             , A.EXCEPT_COMMENT
             , P_USER_ID AS CREATED_BY
             , SYSDATE AS CREATION_DATE
             , P_USER_ID AS LAST_UPDATED_BY
             , SYSDATE AS LAST_UPDATE_DATE
          FROM GT_0022_FORMATION_EXECPT_VIRTUAL_SITE A
         WHERE NOT EXISTS (SELECT 1
                             FROM SCP_MST_FORMATION_EXCEPT SA
                            WHERE SA.DIVISION_ID = A.VS_DIVISION_ID
                              AND SA.PLANT_SITE_ID = UPPER(A.VS_PLANT_SITE_ID)
                              AND SA.ITEM_ID = A.ITEM_ID
                              AND SA.FORMATION_START_DATE = A.FORMATION_START_DATE
                              AND SA.FORMATION_END_DATE = A.FORMATION_END_DATE)
           AND A.RN = 1;
    END P_SYNC_EXCEPT_VIRTUAL_SITE;

    /* ------------------------------------------------------------------------------------------------
       [PJ2025F254] SCP0022_SAVE_FORMATION_EXCEPT 삭제 #.1 ~ #.3
       ------------------------------------------------------------------------------------------------ */
    PROCEDURE P_DEL_EXCEPT_VIRTUAL_SITE
    (
        P_ORG_DIVISION_ID       IN  VARCHAR2
      , P_ORG_PLANT_SITE_ID     IN  VARCHAR2
      , P_ORG_ITEM_ID           IN  VARCHAR2
      , P_ORG_START_DATE        IN  VARCHAR2
      , P_ORG_END_DATE          IN  VARCHAR2
    )
    IS
    BEGIN
        /* #.1 가상 Plant 사이트 대상 데이터 추출 */
        DELETE FROM GT_0022_FORMATION_EXECPT_VIRTUAL_SITE_TO_DELETE;

        INSERT INTO GT_0022_FORMATION_EXECPT_VIRTUAL_SITE_TO_DELETE
             ( VS_DIVISION_ID
             , VS_PLANT_SITE_ID
             , ITEM_ID
             , FORMATION_START_DATE
             , FORMATION_END_DATE
             )
        SELECT B.DIVISION_ID AS VS_DIVISION_ID
             , B.SCM_SITE_ID AS VS_PLANT_SITE_ID
             , D.ITEM_ID
             , D.FORMATION_START_DATE
             , D.FORMATION_END_DATE
          FROM SCM_MST_PLANT_SN A
             , SCM_MST_SITE B
             , SCM_MST_SITE C
             , SCP_MST_FORMATION_EXCEPT D                                                             /* DIVISION_ID, PLANT_SITE_ID, ITEM_ID, FORMATION_START_DATE, FORMATION_END_DATE */
         WHERE B.COMPANY_ID = A.COMPANY_ID
           AND B.DIVISION_ID = A.DIVISION_ID
           AND B.PLANT_ID = A.PLANT_ID
           AND B.SITE_ID = A.SITE_ID
           AND UPPER(C.SCM_SITE_ID) = UPPER(B.ATTRIBUTE9)
           AND C.PLANT_ID = A.LINK_PLANT_ID
           AND D.DIVISION_ID = C.DIVISION_ID
           AND D.PLANT_SITE_ID = UPPER(C.SCM_SITE_ID)
           AND B.SITE_TYPE = 'PLANT'
           AND B.VALID_YN = 'Y'
           AND C.SITE_TYPE = 'PLANT'
           AND C.VALID_YN = 'Y'
           AND A.PLANT_TYPE = 'VIRTUAL'
           AND C.DIVISION_ID = UPPER(RTRIM(P_ORG_DIVISION_ID))                                        /* Real plant 기준 */
           AND UPPER(C.SCM_SITE_ID) = UPPER(RTRIM(P_ORG_PLANT_SITE_ID))
           AND D.ITEM_ID = UPPER(RTRIM(P_ORG_ITEM_ID))
           AND D.FORMATION_START_DATE = P_ORG_START_DATE
           AND D.FORMATION_END_DATE = P_ORG_END_DATE;

        /* #.2 가상 Plant 사이트 대상 이력 생성 (삭제전) */
        INSERT INTO SCP_MST_FORMATION_EXCEPT_H
             ( HISTORY_SEQ
             , DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , FORMATION_START_DATE
             , FORMATION_END_DATE
             , FORMATION_YIELD
             , CHAR_YIELD
             , FORMATION_TOTAL_YIELD
             , SSP_MODIFY_YIELD
             , EXCEPT_COMMENT
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             )
        SELECT SEQ1_SCP_MST_FORMATION_EXCEPT_H.NEXTVAL AS HISTORY_SEQ
             , A.DIVISION_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.FORMATION_START_DATE
             , A.FORMATION_END_DATE
             , A.FORMATION_YIELD
             , A.CHAR_YIELD
             , A.FORMATION_TOTAL_YIELD
             , A.SSP_MODIFY_YIELD
             , A.EXCEPT_COMMENT
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , SYSDATE AS HISTORY_CREATION_DATE
          FROM SCP_MST_FORMATION_EXCEPT A
             , GT_0022_FORMATION_EXECPT_VIRTUAL_SITE_TO_DELETE B
         WHERE B.VS_DIVISION_ID = A.DIVISION_ID
           AND UPPER(B.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
           AND B.ITEM_ID = A.ITEM_ID
           AND B.FORMATION_START_DATE = A.FORMATION_START_DATE
           AND B.FORMATION_END_DATE = A.FORMATION_END_DATE;

        /* #.3 가상 Plant 사이트 대상 데이터 삭제 */
        DELETE
          FROM SCP_MST_FORMATION_EXCEPT A
         WHERE EXISTS (SELECT 1
                         FROM GT_0022_FORMATION_EXECPT_VIRTUAL_SITE_TO_DELETE SA
                        WHERE SA.VS_DIVISION_ID = A.DIVISION_ID
                          AND UPPER(SA.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
                          AND SA.ITEM_ID = A.ITEM_ID
                          AND SA.FORMATION_START_DATE = A.FORMATION_START_DATE
                          AND SA.FORMATION_END_DATE = A.FORMATION_END_DATE);
    END P_DEL_EXCEPT_VIRTUAL_SITE;

    /* ------------------------------------------------------------------------------------------------
       [PJ2025F254] SCP0022_SAVE_FORMATION_EXCEPT_LT 등록·수정 #.1 ~ #.4
       ------------------------------------------------------------------------------------------------ */
    PROCEDURE P_SYNC_EXCEPT_LT_VIRTUAL_SITE
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_PLANT_SITE_ID         IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FORMATION_START_DATE  IN  VARCHAR2
      , P_FORMATION_END_DATE    IN  VARCHAR2
      , P_ORG_START_DATE        IN  VARCHAR2
      , P_ORG_END_DATE          IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
    )
    IS
    BEGIN
        /* #.1 가상 Plant 사이트 대상 데이터 추출 */
        DELETE FROM GT_0022_FORMATION_EXECPT_LT_VIRTUAL;

        INSERT INTO GT_0022_FORMATION_EXECPT_LT_VIRTUAL
             ( VS_DIVISION_ID
             , VS_PLANT_SITE_ID
             , VS_PLANT_ID
             , RS_DIVISION_ID
             , RS_PLANT_SITE_ID
             , RS_PLANT_ID
             , ITEM_ID
             , FORMATION_START_DATE
             , FORMATION_END_DATE
             , LT_FORMATION
             , ADD_LT_FORMATION
             , EXCEPT_COMMENT
             , RN
             )
        SELECT B.DIVISION_ID AS VS_DIVISION_ID
             , B.SCM_SITE_ID AS VS_PLANT_SITE_ID
             , B.PLANT_ID AS VS_PLANT_ID
             , C.DIVISION_ID AS RS_DIVISION_ID
             , C.SCM_SITE_ID AS RS_PLANT_SITE_ID
             , C.PLANT_ID AS RS_PLANT_ID
             , D.ITEM_ID
             , D.FORMATION_START_DATE
             , D.FORMATION_END_DATE
             , D.LT_FORMATION
             , D.ADD_LT_FORMATION
             , D.EXCEPT_COMMENT
             , ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
                                             , UPPER(B.SCM_SITE_ID)
                                             , D.ITEM_ID
                                             , D.FORMATION_START_DATE
                                             , D.FORMATION_END_DATE
                                      ORDER BY D.LAST_UPDATE_DATE DESC) AS RN
          FROM SCM_MST_PLANT_SN A
             , SCM_MST_SITE B
             , SCM_MST_SITE C
             , SCP_OPMZ_MST_FORMATION_EXCEPT_LT D                                                     /* DIVISION_ID, PLANT_SITE_ID, ITEM_ID, FORMATION_START_DATE, FORMATION_END_DATE */
         WHERE B.COMPANY_ID = A.COMPANY_ID
           AND B.DIVISION_ID = A.DIVISION_ID
           AND B.PLANT_ID = A.PLANT_ID
           AND B.SITE_ID = A.SITE_ID
           AND UPPER(C.SCM_SITE_ID) = UPPER(B.ATTRIBUTE9)
           AND C.PLANT_ID = A.LINK_PLANT_ID
           AND D.DIVISION_ID = C.DIVISION_ID
           AND D.PLANT_SITE_ID = UPPER(C.SCM_SITE_ID)
           AND B.SITE_TYPE = 'PLANT'
           AND B.VALID_YN = 'Y'
           AND C.SITE_TYPE = 'PLANT'
           AND C.VALID_YN = 'Y'
           AND A.PLANT_TYPE = 'VIRTUAL'
           AND C.DIVISION_ID = UPPER(RTRIM(P_DIVISION_ID))                                            /* Real plant 기준 */
           AND UPPER(C.SCM_SITE_ID) = UPPER(RTRIM(P_PLANT_SITE_ID))
           AND D.ITEM_ID = UPPER(RTRIM(P_ITEM_ID))
           AND D.FORMATION_START_DATE = P_FORMATION_START_DATE
           AND D.FORMATION_END_DATE = P_FORMATION_END_DATE;

        /* #.2.1 가상 Plant 사이트 대상 이력 생성 */
        INSERT INTO SCP_OPMZ_MST_FORMATION_EXCEPT_LT_H
             ( HISTORY_SEQ
             , DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , FORMATION_START_DATE
             , FORMATION_END_DATE
             , LT_FORMATION
             , ADD_LT_FORMATION
             , EXCEPT_COMMENT
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             )
        SELECT SEQ1_SCP_MST_FORMATION_EXCEPT_H.NEXTVAL AS HISTORY_SEQ
             , A.DIVISION_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.FORMATION_START_DATE
             , A.FORMATION_END_DATE
             , A.LT_FORMATION
             , A.ADD_LT_FORMATION
             , A.EXCEPT_COMMENT
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , SYSDATE AS HISTORY_CREATION_DATE
          FROM SCP_OPMZ_MST_FORMATION_EXCEPT_LT A
             , GT_0022_FORMATION_EXECPT_LT_VIRTUAL B
         WHERE B.VS_DIVISION_ID = A.DIVISION_ID
           AND UPPER(B.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
           AND B.ITEM_ID = A.ITEM_ID
           AND B.FORMATION_START_DATE = A.FORMATION_START_DATE
           AND B.FORMATION_END_DATE = A.FORMATION_END_DATE
           AND B.RN = 1
           AND (   NVL(B.LT_FORMATION, 0) <> NVL(A.LT_FORMATION, 0)
                OR NVL(B.ADD_LT_FORMATION, 0) <> NVL(A.ADD_LT_FORMATION, 0)
                OR DECODE(UPPER(RTRIM(B.EXCEPT_COMMENT)), UPPER(RTRIM(A.EXCEPT_COMMENT)), 0, 1) = 1
               );

        /* #.2.2 가상 Plant 사이트 이력 생성(날짜key컬럼 변경) */
        INSERT INTO SCP_OPMZ_MST_FORMATION_EXCEPT_LT_H
             ( HISTORY_SEQ
             , DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , FORMATION_START_DATE
             , FORMATION_END_DATE
             , LT_FORMATION
             , ADD_LT_FORMATION
             , EXCEPT_COMMENT
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             )
        SELECT SEQ1_SCP_MST_FORMATION_EXCEPT_H.NEXTVAL AS HISTORY_SEQ
             , A.DIVISION_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.FORMATION_START_DATE
             , A.FORMATION_END_DATE
             , A.LT_FORMATION
             , A.ADD_LT_FORMATION
             , A.EXCEPT_COMMENT
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , SYSDATE AS HISTORY_CREATION_DATE
          FROM SCP_OPMZ_MST_FORMATION_EXCEPT_LT A
             , GT_0022_FORMATION_EXECPT_LT_VIRTUAL B
         WHERE B.VS_DIVISION_ID = A.DIVISION_ID
           AND UPPER(B.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
           AND B.ITEM_ID = A.ITEM_ID
           AND A.FORMATION_START_DATE = P_ORG_START_DATE
           AND A.FORMATION_END_DATE = P_ORG_END_DATE
           AND TRIM(P_ORG_START_DATE) IS NOT NULL
           AND (   P_ORG_START_DATE <> NVL(P_FORMATION_START_DATE, ' ')
                OR NVL(P_ORG_END_DATE, ' ') <> NVL(P_FORMATION_END_DATE, ' ')
               );

        /* #.2.3 가상 Plant 사이트 변경전 날짜 데이터 삭제 */
        /* key컬럼 변경하지 않고 delete/insert */
        DELETE
          FROM SCP_OPMZ_MST_FORMATION_EXCEPT_LT A
         WHERE EXISTS (SELECT 1
                         FROM GT_0022_FORMATION_EXECPT_LT_VIRTUAL SA
                        WHERE SA.VS_DIVISION_ID = A.DIVISION_ID
                          AND UPPER(SA.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
                          AND SA.ITEM_ID = A.ITEM_ID)
           AND A.FORMATION_START_DATE = P_ORG_START_DATE
           AND A.FORMATION_END_DATE = P_ORG_END_DATE
           AND TRIM(P_ORG_START_DATE) IS NOT NULL
           AND (   P_ORG_START_DATE <> NVL(P_FORMATION_START_DATE, ' ')
                OR NVL(P_ORG_END_DATE, ' ') <> NVL(P_FORMATION_END_DATE, ' ')
               );

        /* #.3 가상 Plant 사이트 대상 데이터 Update */
        UPDATE SCP_OPMZ_MST_FORMATION_EXCEPT_LT A
           SET ( A.LT_FORMATION
               , A.ADD_LT_FORMATION
               , A.EXCEPT_COMMENT
               )
             = (SELECT SA.LT_FORMATION
                     , SA.ADD_LT_FORMATION
                     , SA.EXCEPT_COMMENT
                  FROM GT_0022_FORMATION_EXECPT_LT_VIRTUAL SA
                 WHERE SA.VS_DIVISION_ID = A.DIVISION_ID
                   AND UPPER(SA.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
                   AND SA.ITEM_ID = A.ITEM_ID
                   AND SA.FORMATION_START_DATE = A.FORMATION_START_DATE
                   AND SA.FORMATION_END_DATE = A.FORMATION_END_DATE
                   AND SA.RN = 1)
             , A.LAST_UPDATE_DATE = SYSDATE
             , A.LAST_UPDATED_BY = P_USER_ID
         WHERE EXISTS (SELECT 1
                         FROM GT_0022_FORMATION_EXECPT_LT_VIRTUAL XA
                        WHERE XA.VS_DIVISION_ID = A.DIVISION_ID
                          AND UPPER(XA.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
                          AND XA.ITEM_ID = A.ITEM_ID
                          AND XA.FORMATION_START_DATE = A.FORMATION_START_DATE
                          AND XA.FORMATION_END_DATE = A.FORMATION_END_DATE
                          AND XA.RN = 1
                          AND (   NVL(XA.LT_FORMATION, 0) <> NVL(A.LT_FORMATION, 0)
                               OR NVL(XA.ADD_LT_FORMATION, 0) <> NVL(A.ADD_LT_FORMATION, 0)
                               OR DECODE(UPPER(RTRIM(XA.EXCEPT_COMMENT)), UPPER(RTRIM(A.EXCEPT_COMMENT)), 0, 1) = 1
                              ));

        /* #.4 가상 Plant 사이트 대상 데이터 insert */
        INSERT INTO SCP_OPMZ_MST_FORMATION_EXCEPT_LT
             ( DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , FORMATION_START_DATE
             , FORMATION_END_DATE
             , LT_FORMATION
             , ADD_LT_FORMATION
             , EXCEPT_COMMENT
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             )
        SELECT A.VS_DIVISION_ID
             , A.VS_PLANT_SITE_ID
             , A.ITEM_ID
             , A.FORMATION_START_DATE
             , A.FORMATION_END_DATE
             , A.LT_FORMATION
             , A.ADD_LT_FORMATION
             , A.EXCEPT_COMMENT
             , P_USER_ID AS CREATED_BY
             , SYSDATE AS CREATION_DATE
             , P_USER_ID AS LAST_UPDATED_BY
             , SYSDATE AS LAST_UPDATE_DATE
          FROM GT_0022_FORMATION_EXECPT_LT_VIRTUAL A
         WHERE NOT EXISTS (SELECT 1
                             FROM SCP_OPMZ_MST_FORMATION_EXCEPT_LT SA
                            WHERE SA.DIVISION_ID = A.VS_DIVISION_ID
                              AND SA.PLANT_SITE_ID = UPPER(A.VS_PLANT_SITE_ID)
                              AND SA.ITEM_ID = A.ITEM_ID
                              AND SA.FORMATION_START_DATE = A.FORMATION_START_DATE
                              AND SA.FORMATION_END_DATE = A.FORMATION_END_DATE)
           AND A.RN = 1;
    END P_SYNC_EXCEPT_LT_VIRTUAL_SITE;

    /* ------------------------------------------------------------------------------------------------
       [PJ2025F254] SCP0022_SAVE_FORMATION_EXCEPT_LT 삭제 #.1 ~ #.3
       ------------------------------------------------------------------------------------------------ */
    PROCEDURE P_DEL_EXCEPT_LT_VIRTUAL_SITE
    (
        P_ORG_DIVISION_ID       IN  VARCHAR2
      , P_ORG_PLANT_SITE_ID     IN  VARCHAR2
      , P_ORG_ITEM_ID           IN  VARCHAR2
      , P_ORG_START_DATE        IN  VARCHAR2
      , P_ORG_END_DATE          IN  VARCHAR2
    )
    IS
    BEGIN
        /* #.1 가상 Plant 사이트 삭제 대상 데이터 추출 */
        DELETE FROM GT_0022_FORMATION_EXECPT_LT_VIRTUAL_TO_DEL;

        INSERT INTO GT_0022_FORMATION_EXECPT_LT_VIRTUAL_TO_DEL
             ( VS_DIVISION_ID
             , VS_PLANT_SITE_ID
             , ITEM_ID
             , FORMATION_START_DATE
             , FORMATION_END_DATE
             )
        SELECT B.DIVISION_ID AS VS_DIVISION_ID
             , B.SCM_SITE_ID AS VS_PLANT_SITE_ID
             , D.ITEM_ID
             , D.FORMATION_START_DATE
             , D.FORMATION_END_DATE
          FROM SCM_MST_PLANT_SN A
             , SCM_MST_SITE B
             , SCM_MST_SITE C
             , SCP_OPMZ_MST_FORMATION_EXCEPT_LT D                                                     /* DIVISION_ID, PLANT_SITE_ID, ITEM_ID, FORMATION_START_DATE, FORMATION_END_DATE */
         WHERE B.COMPANY_ID = A.COMPANY_ID
           AND B.DIVISION_ID = A.DIVISION_ID
           AND B.PLANT_ID = A.PLANT_ID
           AND B.SITE_ID = A.SITE_ID
           AND UPPER(C.SCM_SITE_ID) = UPPER(B.ATTRIBUTE9)
           AND C.PLANT_ID = A.LINK_PLANT_ID
           AND D.DIVISION_ID = C.DIVISION_ID
           AND D.PLANT_SITE_ID = UPPER(C.SCM_SITE_ID)
           AND B.SITE_TYPE = 'PLANT'
           AND B.VALID_YN = 'Y'
           AND C.SITE_TYPE = 'PLANT'
           AND C.VALID_YN = 'Y'
           AND A.PLANT_TYPE = 'VIRTUAL'
           AND C.DIVISION_ID = UPPER(RTRIM(P_ORG_DIVISION_ID))                                        /* Real plant 기준 */
           AND UPPER(C.SCM_SITE_ID) = UPPER(RTRIM(P_ORG_PLANT_SITE_ID))
           AND D.ITEM_ID = UPPER(RTRIM(P_ORG_ITEM_ID))
           AND D.FORMATION_START_DATE = P_ORG_START_DATE
           AND D.FORMATION_END_DATE = P_ORG_END_DATE;

        /* #.2 가상 Plant 사이트 데이터 삭제전 이력 생성 */
        INSERT INTO SCP_OPMZ_MST_FORMATION_EXCEPT_LT_H
             ( HISTORY_SEQ
             , DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , FORMATION_START_DATE
             , FORMATION_END_DATE
             , LT_FORMATION
             , ADD_LT_FORMATION
             , EXCEPT_COMMENT
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             )
        SELECT SEQ1_SCP_MST_FORMATION_EXCEPT_H.NEXTVAL AS HISTORY_SEQ
             , A.DIVISION_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.FORMATION_START_DATE
             , A.FORMATION_END_DATE
             , A.LT_FORMATION
             , A.ADD_LT_FORMATION
             , A.EXCEPT_COMMENT
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , SYSDATE AS HISTORY_CREATION_DATE
          FROM SCP_OPMZ_MST_FORMATION_EXCEPT_LT A
             , GT_0022_FORMATION_EXECPT_LT_VIRTUAL_TO_DEL B
         WHERE B.VS_DIVISION_ID = A.DIVISION_ID
           AND UPPER(B.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
           AND B.ITEM_ID = A.ITEM_ID
           AND B.FORMATION_START_DATE = A.FORMATION_START_DATE
           AND B.FORMATION_END_DATE = A.FORMATION_END_DATE;

        /* #.3 가상 Plant 사이트 데이터 삭제 */
        DELETE
          FROM SCP_OPMZ_MST_FORMATION_EXCEPT_LT A
         WHERE EXISTS (SELECT 1
                         FROM GT_0022_FORMATION_EXECPT_LT_VIRTUAL_TO_DEL SA
                        WHERE SA.VS_DIVISION_ID = A.DIVISION_ID
                          AND UPPER(SA.VS_PLANT_SITE_ID) = A.PLANT_SITE_ID
                          AND SA.ITEM_ID = A.ITEM_ID
                          AND SA.FORMATION_START_DATE = A.FORMATION_START_DATE
                          AND SA.FORMATION_END_DATE = A.FORMATION_END_DATE);
    END P_DEL_EXCEPT_LT_VIRTUAL_SITE;

/*
 * Program ID   : SCP0022_GET_Formation
 * Description  : Formation
 * Program History
 *===================================================================================================
 *   Date       In Charge		                    Description
 *===================================================================================================
 * 2018/03/26   kyh				                    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/17   byunghunjung	                    전극 제외
 * 2018/06/18	KYH				                    신규 컬럼 추가. Formation Add LT (Days)
 * 2018/08/08   byunghunjung	                    item_id 2번째 자리가 C인 모델만 검색
 * 2019/04/08	hwyoon			                    [CSR:]GSCM 고도화 - Formation 수율 필드 추가, 기능개선
 * 2019/04/11	AYJ				                    SSP_MODIFY_YIELD 컬럼 추가
 * 2019/05/10	hwyoon			                    [CSR ID:3991073] [긴급] Formation Active 모델 모두 표시 및 SSP Model PIC 정보 컬럼 추가
 * 2019/10/30	hwyoon			                    Project Route 등록여부와 관계없이 기존 입력된 수율 전체 조회
 * 2020/04/03	hwyoon			                    [C20200403-000212] Item 다중입력 조회 오류 개선 nvarchar(50) 제거
 * 2020/04/07	hwyoon			                    [C20200407-000179] CNB H5.5A 특성 실적 시스템 미반영 관련 문의의 건 - Plant 매개변수 nvarchar(30) 제거
 * 2023/09/05   chaan		            V1.1.3      PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2             -  CA1 모델만 조회되게 수정
*/
    PROCEDURE P_SCP0022_GET_FORMATION
    (
        P_DIVISION_ID       IN  VARCHAR2
      , P_PLANT_SITE_ID     IN  VARCHAR2
      , P_ITEM_ID           IN  VARCHAR2
      , P_USER_ID           IN  VARCHAR2
      , P_MENU_ID           IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        C_PROGRAM_NAME      CONSTANT VARCHAR2(150 CHAR) := 'PKG_SCP0022.P_SCP0022_GET_FORMATION';
        V_DIV_ALL           VARCHAR2(1 CHAR);
        V_DIV_LIST          VARCHAR2(32767 CHAR);
        V_PLANT_ALL         VARCHAR2(1 CHAR);
        V_PLANT_LIST        VARCHAR2(32767 CHAR);
        V_ITEM_ALL          VARCHAR2(1 CHAR);
        V_ITEM_LIST         VARCHAR2(32767 CHAR);
    BEGIN
        /* AS-IS 화면 GetCheckedListValue : 'ALL' 은 빈 값으로 넘긴다 */
        V_DIV_ALL    := CASE WHEN TRIM(P_DIVISION_ID) IS NULL OR UPPER(TRIM(P_DIVISION_ID)) = 'ALL' THEN 'Y' ELSE 'N' END;
        V_DIV_LIST   := F_LIST_PARAM(P_DIVISION_ID);
        V_PLANT_ALL  := CASE WHEN TRIM(P_PLANT_SITE_ID) IS NULL OR UPPER(TRIM(P_PLANT_SITE_ID)) = 'ALL' THEN 'Y' ELSE 'N' END;
        V_PLANT_LIST := F_LIST_PARAM(P_PLANT_SITE_ID);
        V_ITEM_ALL   := CASE WHEN TRIM(P_ITEM_ID) IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' THEN 'Y' ELSE 'N' END;   /* 조회조건 ALL 은 조건 없음 */
        V_ITEM_LIST  := F_LIST_PARAM(P_ITEM_ID);

        OPEN O_RC1 FOR
        SELECT XA.DIVISION_ID
             , XA.PLANT_SITE_ID
             , XA.PLANT_SITE_NAME
             , XA.ITEM_ID
             , XA.NICK_NAME
             , XA.LT_FORMATION
             , XA.ADD_LT_FORMATION
             , XA.FORMATION_YIELD
             , XA.CHAR_YIELD
             , XA.FORMATION_TOTAL_YIELD
             , XA.SSP_MODIFY_YIELD
             , XA.CREATED_BY
             , XA.CREATION_DATE
             , XA.LAST_UPDATED_BY
             , XA.LAST_UPDATE_DATE
             , XA.FORMATION_ORDER
             , XA.SHIPMENT_PIC_USER
          FROM (
                /* 입력대상 (Project Route입력 아이템) */
                SELECT DISTINCT
                       IA.DIVISION_ID
                     , IA.PLANT_SITE_ID
                     , FN_GET_SCM_SITE_DESCRIPTION(IA.DIVISION_ID, IA.PLANT_SITE_ID) AS PLANT_SITE_NAME
                     , IA.ITEM_ID
                     , IA.NICK_NAME
                     , A.LT_FORMATION
                     , NVL(TO_NUMBER(TRIM(A.ATTRIBUTE1)), 0) AS ADD_LT_FORMATION
                     , ROUND(A.FORMATION_YIELD * 100, 2) AS FORMATION_YIELD
                     , ROUND(A.CHAR_YIELD * 100, 2) AS CHAR_YIELD
                     , ROUND(A.FORMATION_TOTAL_YIELD * 100, 2) AS FORMATION_TOTAL_YIELD
                     , ROUND(A.SSP_MODIFY_YIELD * 100, 2) AS SSP_MODIFY_YIELD
                     , A.CREATED_BY
                     , TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS') AS CREATION_DATE
                     , A.LAST_UPDATED_BY
                     , TO_CHAR(A.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS LAST_UPDATE_DATE
                     , '1' AS FORMATION_ORDER
                     , CASE WHEN C.USER_NAME IS NULL THEN NULL ELSE C.USER_NAME || '(' || B.USER_ID || ')' END AS SHIPMENT_PIC_USER
                  FROM (
                        SELECT D.DIVISION_ID
                             , G.PLANT_SITE_ID
                             , D.ITEM_ID
                             , FN_GET_ITEM_NICKNAME(D.DIVISION_ID, D.ITEM_ID) AS NICK_NAME
                          FROM SCM_MST_ITEM_SN D
                             , SCP_MST_FINAL_ITEM E
                             , SCM_MST_SITE_ITEM F
                             , SCM_MST_SITE_ITEM_PRIORITY G
                             , SCM_MST_FINAL_ITEM_V H
                         WHERE E.DIVISION_ID = D.DIVISION_ID
                           AND E.ITEM_ID = D.ITEM_ID
                           AND F.DIVISION_ID = D.DIVISION_ID
                           AND UPPER(F.ITEM_ID) = D.ITEM_ID
                           AND G.DIVISION_ID = D.DIVISION_ID
                           AND G.ITEM_ID = D.ITEM_ID
                           AND G.PLANT_SITE_ID = UPPER(F.SCM_SITE_ID)
                           AND UPPER(G.PROJECT_CODE) = UPPER(F.PROJECT_CODE)
                           AND H.DIVISION_ID = D.DIVISION_ID
                           AND H.ITEM_ID = UPPER(F.ITEM_ID)
                           AND (   V_PLANT_ALL = 'Y'
                                OR INSTR(V_PLANT_LIST, ',' || G.PLANT_SITE_ID || ',') > 0
                                OR EXISTS (SELECT 1
                                             FROM SCM_MST_SITE SA
                                            WHERE UPPER(SA.SCM_SITE_ID) = G.PLANT_SITE_ID
                                              AND INSTR(V_PLANT_LIST, ',' || SA.PLANT_ID || ',') > 0)
                               )
                           AND E.ATTRIBUTE8 = 'CA1'
                           AND H.OPERATION_GROUP_ID = 'A'
                           AND G.VALID_YN = 'Y'
                           AND H.OPERATION_GROUP_ID <> 'E'                                            /* 전극 제외 */
                           AND (V_DIV_ALL = 'Y' OR INSTR(V_DIV_LIST, ',' || D.DIVISION_ID || ',') > 0)
                           AND (V_ITEM_ALL = 'Y' 
                           		OR (INSTR(V_ITEM_LIST, ',' || D.ITEM_ID || ',') > 0
                           		OR INSTR(V_ITEM_LIST, ',' || D.ITEM_NAME || ',') > 0
                           		OR INSTR(V_ITEM_LIST, ',' || D.NICK_NAME || ',') > 0)
                           	)
                       ) IA
                     , SCP_MST_FORMATION A
                     , SSP_MST_MODEL_USER B
                     , SCM_MST_SSO_USER_INFO C
                 WHERE A.DIVISION_ID(+) = IA.DIVISION_ID
                   AND A.PLANT_SITE_ID(+) = IA.PLANT_SITE_ID
                   AND A.ITEM_ID(+) = IA.ITEM_ID
                   AND B.DIVISION_ID(+) = IA.DIVISION_ID
                   AND B.FROM_SITE(+) = IA.PLANT_SITE_ID
                   AND B.ITEM_ID(+) = IA.ITEM_ID
                   AND C.USER_ID(+) = B.USER_ID
                   AND B.VALID_YN(+) = 'Y'
                   AND A.LT_FORMATION IS NULL
                 UNION
                /* 입력대상 (Project Route입력 아이템) */
                SELECT DISTINCT
                       I.DIVISION_ID
                     , I.PLANT_SITE_ID
                     , FN_GET_SCM_SITE_DESCRIPTION(I.DIVISION_ID, I.PLANT_SITE_ID) AS PLANT_SITE_NAME
                     , I.ITEM_ID
                     , FN_GET_ITEM_NICKNAME(I.DIVISION_ID, I.ITEM_ID) AS NICK_NAME
                     , I.LT_FORMATION
                     , NVL(TO_NUMBER(TRIM(I.ATTRIBUTE1)), 0) AS ADD_LT_FORMATION
                     , ROUND(I.FORMATION_YIELD * 100, 2) AS FORMATION_YIELD
                     , ROUND(I.CHAR_YIELD * 100, 2) AS CHAR_YIELD
                     , ROUND(I.FORMATION_TOTAL_YIELD * 100, 2) AS FORMATION_TOTAL_YIELD
                     , ROUND(I.SSP_MODIFY_YIELD * 100, 2) AS SSP_MODIFY_YIELD
                     , I.CREATED_BY
                     , TO_CHAR(I.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS') AS CREATION_DATE
                     , I.LAST_UPDATED_BY
                     , TO_CHAR(I.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS LAST_UPDATE_DATE
                     , '2' AS FORMATION_ORDER
                     , CASE WHEN L.USER_NAME IS NULL THEN NULL ELSE L.USER_NAME || '(' || K.USER_ID || ')' END AS SHIPMENT_PIC_USER
                  FROM SCP_MST_FORMATION I                                                            /* ON M.DIVISION_ID   = N.DIVISION_ID */
                                                                                                      /* AND M.PLANT_SITE_ID = N.PLANT_SITE_ID */
                                                                                                      /* AND M.ITEM_ID       = N.ITEM_ID */
                     , SCP_MST_FINAL_ITEM J
                     , SSP_MST_MODEL_USER K
                     , SCM_MST_SSO_USER_INFO L
                 WHERE J.DIVISION_ID = I.DIVISION_ID
                   AND J.ITEM_ID = I.ITEM_ID
                   AND K.DIVISION_ID(+) = I.DIVISION_ID
                   AND K.FROM_SITE(+) = I.PLANT_SITE_ID
                   AND K.ITEM_ID(+) = I.ITEM_ID
                   AND L.USER_ID(+) = K.USER_ID
                   AND (   V_PLANT_ALL = 'Y'
                        OR INSTR(V_PLANT_LIST, ',' || I.PLANT_SITE_ID || ',') > 0
                        OR EXISTS (SELECT 1
                                     FROM SCM_MST_SITE SB
                                    WHERE UPPER(SB.SCM_SITE_ID) = I.PLANT_SITE_ID
                                      AND INSTR(V_PLANT_LIST, ',' || SB.PLANT_ID || ',') > 0)
                       )
                   AND J.ATTRIBUTE8 = 'CA1'
                   AND K.VALID_YN(+) = 'Y'
                   AND (V_DIV_ALL = 'Y' OR INSTR(V_DIV_LIST, ',' || I.DIVISION_ID || ',') > 0)
                   AND (V_ITEM_ALL = 'Y' 
	                   OR INSTR(V_ITEM_LIST, ',' || I.ITEM_ID || ',') > 0
                   )
               ) XA
         ORDER BY XA.FORMATION_ORDER
                , UPPER(TRANSLATE(XA.DIVISION_ID, '_-', '/'))
                , XA.DIVISION_ID
                , UPPER(TRANSLATE(XA.PLANT_SITE_ID, '_-', '/'))
                , XA.PLANT_SITE_ID
                , UPPER(TRANSLATE(XA.ITEM_ID, '_-', '/'))
                , XA.ITEM_ID;

        OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE
             , 'SUCCESS' AS MSG
             , '0' AS EVENT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            P_LOG_ERROR(C_PROGRAM_NAME
                      , 'P_DIVISION_ID=' || P_DIVISION_ID || ', P_PLANT_SITE_ID=' || P_PLANT_SITE_ID || ', P_ITEM_ID=' || SUBSTR(P_ITEM_ID, 1, 1000)
                      , TO_CHAR(SQLCODE)
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE;
    END P_SCP0022_GET_FORMATION;

/*
 * Program ID   : SCP0022_GET_FORMATION_EXCEPT
 * Description  : Formation Except
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/05/09   byunghunjung	Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/08/08   byunghunjung	item_id 2번째 자리가 C인 모델만 검색
 * 2018/04/08	hwyoon			[CSR:]GSCM 고도화 - Formation 수율 필드 추가, 기능개선
 * 2025/09/22   KH 	            PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 조회조건변경
 */
    PROCEDURE P_SCP0022_GET_FORMATION_EXCEPT
    (
        P_DIVISION_ID       IN  VARCHAR2
      , P_PLANT_SITE_ID     IN  VARCHAR2                                                              /* PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 (자리수 변경) */
      , P_ITEM_ID           IN  VARCHAR2                                                              /* PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 (자리수 변경) */
      , P_USER_ID           IN  VARCHAR2
      , P_MENU_ID           IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        C_PROGRAM_NAME      CONSTANT VARCHAR2(150 CHAR) := 'PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCEPT';
        V_DIV_ALL           VARCHAR2(1 CHAR);
        V_DIV_LIST          VARCHAR2(32767 CHAR);
        V_PLANT_ALL         VARCHAR2(1 CHAR);
        V_PLANT_LIST        VARCHAR2(32767 CHAR);
        V_ITEM_ALL          VARCHAR2(1 CHAR);
        V_ITEM_LIST         VARCHAR2(32767 CHAR);
    BEGIN
        V_DIV_ALL    := CASE WHEN TRIM(P_DIVISION_ID) IS NULL OR UPPER(TRIM(P_DIVISION_ID)) = 'ALL' THEN 'Y' ELSE 'N' END;
        V_DIV_LIST   := F_LIST_PARAM(P_DIVISION_ID);
        V_PLANT_ALL  := CASE WHEN TRIM(P_PLANT_SITE_ID) IS NULL OR UPPER(TRIM(P_PLANT_SITE_ID)) = 'ALL' THEN 'Y' ELSE 'N' END;
        V_PLANT_LIST := F_LIST_PARAM(P_PLANT_SITE_ID);
        V_ITEM_ALL   := CASE WHEN TRIM(P_ITEM_ID) IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' THEN 'Y' ELSE 'N' END;   /* 조회조건 ALL 은 조건 없음 */
        V_ITEM_LIST  := F_LIST_PARAM(P_ITEM_ID);

        OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.PLANT_SITE_ID
             , FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.PLANT_SITE_ID) AS PLANT_SITE_NAME
             , A.ITEM_ID
             , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
             , TO_CHAR(TO_DATE(B.FORMATION_START_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS FORMATION_START_DATE
             , TO_CHAR(TO_DATE(B.FORMATION_END_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS FORMATION_END_DATE
             /* ,ROUND(b.formation_yield*100,2)  as formation_yield */
             /* ,b.formation_yield */
             , ROUND(B.FORMATION_YIELD * 100, 2) AS FORMATION_YIELD
             , ROUND(B.CHAR_YIELD * 100, 2) AS CHAR_YIELD
             , ROUND(B.FORMATION_TOTAL_YIELD * 100, 2) AS FORMATION_TOTAL_YIELD
             , B.EXCEPT_COMMENT
             , B.CREATED_BY
             , TO_CHAR(B.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS') AS CREATION_DATE
             , B.LAST_UPDATED_BY
             , TO_CHAR(B.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS LAST_UPDATE_DATE
             /* 수정시 필요한 pk원본 값 2018-04-09 추가 pjs */
             , A.DIVISION_ID AS ORG_DIVISION_ID
             , A.PLANT_SITE_ID AS ORG_PLANT_SITE_ID
             , A.ITEM_ID AS ORG_ITEM_ID
             , TO_CHAR(TO_DATE(B.FORMATION_START_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ORG_FORMATION_START_DATE
             , TO_CHAR(TO_DATE(B.FORMATION_END_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ORG_FORMATION_END_DATE
          FROM SCP_MST_FORMATION A
             , SCP_MST_FORMATION_EXCEPT B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.PLANT_SITE_ID = A.PLANT_SITE_ID
           AND B.ITEM_ID = A.ITEM_ID
           /* 2025.09.23 수정  -- PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 (자리수 변경) Start */
           /* AND a.division_id   = @p_division_id */
           /* AND a.plant_site_id = @p_plant_site_id */
           /* AND a.item_id       = @p_item_id */
           AND (   V_PLANT_ALL = 'Y'
                OR INSTR(V_PLANT_LIST, ',' || A.PLANT_SITE_ID || ',') > 0
                OR EXISTS (SELECT 1
                             FROM SCM_MST_SITE SA
                            WHERE UPPER(SA.SCM_SITE_ID) = A.PLANT_SITE_ID
                              AND INSTR(V_PLANT_LIST, ',' || SA.PLANT_ID || ',') > 0)
               )
           AND (V_DIV_ALL = 'Y' OR INSTR(V_DIV_LIST, ',' || A.DIVISION_ID || ',') > 0)
           AND (V_ITEM_ALL = 'Y' OR INSTR(V_ITEM_LIST, ',' || A.ITEM_ID || ',') > 0)
           /* 2025.09.23 수정  -- PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 (자리수 변경) End */
           /* AND substring(a.item_id,2,1) = 'C' */
         ORDER BY UPPER(TRANSLATE(A.DIVISION_ID, '_-', '/'))
                , A.DIVISION_ID
                , UPPER(TRANSLATE(A.PLANT_SITE_ID, '_-', '/'))
                , A.PLANT_SITE_ID
                , UPPER(TRANSLATE(A.ITEM_ID, '_-', '/'))
                , A.ITEM_ID
                , B.FORMATION_START_DATE                                                              /* AS-IS 클러스터드 PK 순서 */
                , B.FORMATION_END_DATE;

        OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE
             , 'SUCCESS' AS MSG
             , '0' AS EVENT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            P_LOG_ERROR(C_PROGRAM_NAME
                      , 'P_DIVISION_ID=' || P_DIVISION_ID || ', P_PLANT_SITE_ID=' || P_PLANT_SITE_ID || ', P_ITEM_ID=' || SUBSTR(P_ITEM_ID, 1, 1000)
                      , TO_CHAR(SQLCODE)
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE;
    END P_SCP0022_GET_FORMATION_EXCEPT;

/*
 * Program ID   : SCP0022_GET_FORMATION_EXCEPT_LT
 * Description  : Formation Except LT
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/09/22   KH 	            Initial Release  PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산

 */
    PROCEDURE P_SCP0022_GET_FORMATION_EXCEPT_LT
    (
        P_DIVISION_ID       IN  VARCHAR2
      , P_PLANT_SITE_ID     IN  VARCHAR2
      , P_ITEM_ID           IN  VARCHAR2
      , P_USER_ID           IN  VARCHAR2
      , P_MENU_ID           IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        C_PROGRAM_NAME      CONSTANT VARCHAR2(150 CHAR) := 'PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCEPT_LT';
        V_DIV_ALL           VARCHAR2(1 CHAR);
        V_DIV_LIST          VARCHAR2(32767 CHAR);
        V_PLANT_ALL         VARCHAR2(1 CHAR);
        V_PLANT_LIST        VARCHAR2(32767 CHAR);
        V_ITEM_ALL          VARCHAR2(1 CHAR);
        V_ITEM_LIST         VARCHAR2(32767 CHAR);
    BEGIN
        V_DIV_ALL    := CASE WHEN TRIM(P_DIVISION_ID) IS NULL OR UPPER(TRIM(P_DIVISION_ID)) = 'ALL' THEN 'Y' ELSE 'N' END;
        V_DIV_LIST   := F_LIST_PARAM(P_DIVISION_ID);
        V_PLANT_ALL  := CASE WHEN TRIM(P_PLANT_SITE_ID) IS NULL OR UPPER(TRIM(P_PLANT_SITE_ID)) = 'ALL' THEN 'Y' ELSE 'N' END;
        V_PLANT_LIST := F_LIST_PARAM(P_PLANT_SITE_ID);
        V_ITEM_ALL   := CASE WHEN TRIM(P_ITEM_ID) IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' THEN 'Y' ELSE 'N' END;   /* 조회조건 ALL 은 조건 없음 */
        V_ITEM_LIST  := F_LIST_PARAM(P_ITEM_ID);

        OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.PLANT_SITE_ID
             , FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.PLANT_SITE_ID) AS PLANT_SITE_NAME
             , A.ITEM_ID
             , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
             , TO_CHAR(TO_DATE(B.FORMATION_START_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS FORMATION_START_DATE
             , TO_CHAR(TO_DATE(B.FORMATION_END_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS FORMATION_END_DATE
             , B.LT_FORMATION
             , B.ADD_LT_FORMATION
             , B.EXCEPT_COMMENT
             , B.CREATED_BY
             , TO_CHAR(B.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS') AS CREATION_DATE
             , B.LAST_UPDATED_BY
             , TO_CHAR(B.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS LAST_UPDATE_DATE
             /* 수정시 필요한 pk원본 값 2018-04-09 추가 pjs */
             , A.DIVISION_ID AS ORG_DIVISION_ID
             , A.PLANT_SITE_ID AS ORG_PLANT_SITE_ID
             , A.ITEM_ID AS ORG_ITEM_ID
             , TO_CHAR(TO_DATE(B.FORMATION_START_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ORG_FORMATION_START_DATE
             , TO_CHAR(TO_DATE(B.FORMATION_END_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ORG_FORMATION_END_DATE
          FROM SCP_MST_FORMATION A
             , SCP_OPMZ_MST_FORMATION_EXCEPT_LT B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.PLANT_SITE_ID = A.PLANT_SITE_ID
           AND B.ITEM_ID = A.ITEM_ID
           /* 205.09.23 수정 */
           /* AND a.division_id   = @p_division_id */
           /* AND a.plant_site_id = @p_plant_site_id */
           /* AND a.item_id       = @p_item_id */
           AND (   V_PLANT_ALL = 'Y'
                OR INSTR(V_PLANT_LIST, ',' || A.PLANT_SITE_ID || ',') > 0
                OR EXISTS (SELECT 1
                             FROM SCM_MST_SITE SA
                            WHERE UPPER(SA.SCM_SITE_ID) = A.PLANT_SITE_ID
                              AND INSTR(V_PLANT_LIST, ',' || SA.PLANT_ID || ',') > 0)
               )
           AND (V_DIV_ALL = 'Y' OR INSTR(V_DIV_LIST, ',' || A.DIVISION_ID || ',') > 0)
           AND (V_ITEM_ALL = 'Y' OR INSTR(V_ITEM_LIST, ',' || A.ITEM_ID || ',') > 0)
         ORDER BY UPPER(TRANSLATE(A.DIVISION_ID, '_-', '/'))
                , A.DIVISION_ID
                , UPPER(TRANSLATE(A.PLANT_SITE_ID, '_-', '/'))
                , A.PLANT_SITE_ID
                , UPPER(TRANSLATE(A.ITEM_ID, '_-', '/'))
                , A.ITEM_ID
                , B.FORMATION_START_DATE                                                              /* AS-IS 클러스터드 PK 순서 */
                , B.FORMATION_END_DATE;

        OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE
             , 'SUCCESS' AS MSG
             , '0' AS EVENT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            P_LOG_ERROR(C_PROGRAM_NAME
                      , 'P_DIVISION_ID=' || P_DIVISION_ID || ', P_PLANT_SITE_ID=' || P_PLANT_SITE_ID || ', P_ITEM_ID=' || SUBSTR(P_ITEM_ID, 1, 1000)
                      , TO_CHAR(SQLCODE)
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE;
    END P_SCP0022_GET_FORMATION_EXCEPT_LT;

/*
 * Program ID   : SCP0022_SAVE_FORMATION
 * Description  : Formation 등록, 수정, 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/14   kyh				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/06/18	kyh				신규 컬럼 추가. @p_Add_LT_Formation
 * 2109/04/08	yhw				[CSR:]GSCM 고도화 - Formation 수율 필드 추가, 기능개선
 * 2019/04/11	AYJ				SSP_MODIFY_YIELD 컬럼 추가
 * 2025/10/29   hrkim		    [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
 */
    PROCEDURE P_SCP0022_SAVE_FORMATION
    (
        P_DATA              IN  CLOB
      , P_USER_ID           IN  VARCHAR2
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        C_PROGRAM_NAME          CONSTANT VARCHAR2(150 CHAR) := 'PKG_SCP0022.P_SCP0022_SAVE_FORMATION';
        V_MST_LOOP_CNT          PLS_INTEGER := 0;
        V_LT_FORMATION          NUMBER;
        V_FORMATION_YIELD       NUMBER;
        V_CHAR_YIELD            NUMBER;
        V_FORMATION_TOTAL_YIELD NUMBER;
        V_USER_MODIFY_YIELD     NUMBER;
        V_CREATION_DATE         DATE;
        V_ERR_CODE              VARCHAR2(100 CHAR);
        V_ERR_MSG               VARCHAR2(4000 CHAR);
    BEGIN
        /* 트렌젝션 시작 */
        SAVEPOINT SP_SCP0022_SAVE;

        /* 시작 LOG */
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(C_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', NULL, SYSDATE);

        FOR R IN (SELECT A.CRUD_TYPE
                       , A.DIVISION_ID
                       , A.PLANT_SITE_ID
                       , A.ITEM_ID
                       , A.LT_FORMATION
                       , A.ADD_LT_FORMATION
                       , A.FORMATION_YIELD
                       , A.CHAR_YIELD
                       , A.FORMATION_TOTAL_YIELD
                       , A.SSP_MODIFY_YIELD
                    FROM JSON_TABLE(P_DATA, '$[*]'
                             COLUMNS ( RN                    FOR ORDINALITY
                                     , CRUD_TYPE             VARCHAR2(10 CHAR)   PATH '$.CRUD_TYPE'             NULL ON EMPTY
                                     , DIVISION_ID           VARCHAR2(4000 CHAR) PATH '$.DIVISION_ID'           ERROR ON ERROR NULL ON EMPTY
                                     , PLANT_SITE_ID         VARCHAR2(4000 CHAR) PATH '$.PLANT_SITE_ID'         ERROR ON ERROR NULL ON EMPTY
                                     , ITEM_ID               VARCHAR2(4000 CHAR) PATH '$.ITEM_ID'               ERROR ON ERROR NULL ON EMPTY
                                     , LT_FORMATION          VARCHAR2(4000 CHAR) PATH '$.LT_FORMATION'          ERROR ON ERROR NULL ON EMPTY
                                     , ADD_LT_FORMATION      VARCHAR2(4000 CHAR) PATH '$.ADD_LT_FORMATION'      ERROR ON ERROR NULL ON EMPTY
                                     , FORMATION_YIELD       VARCHAR2(4000 CHAR) PATH '$.FORMATION_YIELD'       ERROR ON ERROR NULL ON EMPTY
                                     , CHAR_YIELD            VARCHAR2(4000 CHAR) PATH '$.CHAR_YIELD'            ERROR ON ERROR NULL ON EMPTY
                                     , FORMATION_TOTAL_YIELD VARCHAR2(4000 CHAR) PATH '$.FORMATION_TOTAL_YIELD' ERROR ON ERROR NULL ON EMPTY
                                     , SSP_MODIFY_YIELD      VARCHAR2(4000 CHAR) PATH '$.SSP_MODIFY_YIELD'      ERROR ON ERROR NULL ON EMPTY
                                     )) A
                   WHERE A.CRUD_TYPE IN ('I', 'M', 'D')                                               /* AS-IS 화면 : 플래그 I/M/D 행만 전송 */
                   ORDER BY A.RN)
        LOOP
            /* @mst_loop_cnt 1증가 */
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* JV real plant site -> ESS virtaul plant site 단방향 저장 (virtual plant이면 skip) */
            IF F_IS_VIRTUAL_SITE(R.DIVISION_ID, R.PLANT_SITE_ID) = 0 THEN

                /* AS-IS 칸 형식 변환 : lt_formation INT(빈 값 0) · yield float/100 */
                V_LT_FORMATION          := F_TO_INT(R.LT_FORMATION);
                V_FORMATION_YIELD       := F_YIELD10(R.FORMATION_YIELD);
                V_CHAR_YIELD            := F_YIELD10(R.CHAR_YIELD);
                V_FORMATION_TOTAL_YIELD := F_YIELD10(R.FORMATION_TOTAL_YIELD);
                V_USER_MODIFY_YIELD     := F_YIELD10(R.SSP_MODIFY_YIELD);
                V_CREATION_DATE         := SYSDATE;

                /* 이력저장 */
                P_SCP_MST_FORMATION_HIST(R.DIVISION_ID
                                       , R.PLANT_SITE_ID
                                       , R.ITEM_ID
                                       , V_LT_FORMATION
                                       , R.ADD_LT_FORMATION
                                       , V_FORMATION_YIELD
                                       , V_CHAR_YIELD
                                       , V_FORMATION_TOTAL_YIELD
                                       , P_USER_ID
                                       , P_USER_ID
                                       , V_CREATION_DATE
                                       , V_USER_MODIFY_YIELD);

                /* 데이터 저장 */
                UPDATE SCP_MST_FORMATION
                   SET LT_FORMATION = V_LT_FORMATION
                     , ATTRIBUTE1 = R.ADD_LT_FORMATION
                     , FORMATION_YIELD = V_FORMATION_YIELD
                     , CHAR_YIELD = V_CHAR_YIELD
                     , FORMATION_TOTAL_YIELD = V_FORMATION_TOTAL_YIELD
                     , LAST_UPDATED_BY = P_USER_ID
                     , LAST_UPDATE_DATE = SYSDATE
                     , SSP_MODIFY_YIELD = V_USER_MODIFY_YIELD
                 WHERE DIVISION_ID = UPPER(RTRIM(R.DIVISION_ID))
                   AND PLANT_SITE_ID = UPPER(RTRIM(R.PLANT_SITE_ID))
                   AND ITEM_ID = UPPER(RTRIM(R.ITEM_ID));

                IF SQL%ROWCOUNT = 0 THEN
                    INSERT INTO SCP_MST_FORMATION
                         ( DIVISION_ID
                         , PLANT_SITE_ID
                         , ITEM_ID
                         , LT_FORMATION
                         , FORMATION_YIELD
                         , CHAR_YIELD
                         , FORMATION_TOTAL_YIELD
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
                         , ATTRIBUTE1
                         , SSP_MODIFY_YIELD
                         )
                    VALUES
                         ( R.DIVISION_ID
                         , R.PLANT_SITE_ID
                         , R.ITEM_ID
                         , V_LT_FORMATION
                         , V_FORMATION_YIELD
                         , V_CHAR_YIELD
                         , V_FORMATION_TOTAL_YIELD
                         , P_USER_ID
                         , SYSDATE
                         , P_USER_ID
                         , SYSDATE
                         , R.ADD_LT_FORMATION
                         , V_USER_MODIFY_YIELD
                         );
                END IF;

                /* [PJ2025F254] 가상 Plant 사이트 데이터 동기화 */
                P_SYNC_FORMATION_VIRTUAL_SITE(R.DIVISION_ID, R.PLANT_SITE_ID, R.ITEM_ID, P_USER_ID);

            END IF;
        END LOOP;   /* END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt */

        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(C_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', NULL, SYSDATE);

        COMMIT;

        OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE
             , 'SUCCESS' AS MSG
             , TO_CHAR(V_MST_LOOP_CNT) AS EVENT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE := TO_CHAR(SQLCODE);
            V_ERR_MSG  := F_ERR_MSG(SQLCODE, SQLERRM);

            ROLLBACK TO SAVEPOINT SP_SCP0022_SAVE;                                                    /* 입력 데이타 롤백 처리 */

            P_LOG_ERROR(C_PROGRAM_NAME, 'P_USER_ID=' || P_USER_ID || ', ROW=' || V_MST_LOOP_CNT, V_ERR_CODE, V_ERR_MSG, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE
                 , V_ERR_MSG AS MSG
                 , '0' AS EVENT
              FROM DUAL;
    END P_SCP0022_SAVE_FORMATION;

/*
 * Program ID   : [SCP0019_SAVE_WORKING_TIME]
 * Description  : Working Time 등록, 수정, 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/03/14   pjs				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/28	hwyoon			except 시트 삭제로직 추가
 * 2019/04/08	hwyoon			[CSR:]GSCM 고도화 - Formation 수율 필드 추가, 기능개선
 * 2025/09/22   KH 	            PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 날짜중복체크 추가
 * 2025/10/29   hrkim		    [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
 *
 */
    PROCEDURE P_SCP0022_SAVE_FORMATION_EXCEPT
    (
        P_DATA              IN  CLOB
      , P_USER_ID           IN  VARCHAR2
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        C_PROGRAM_NAME          CONSTANT VARCHAR2(150 CHAR) := 'PKG_SCP0022.P_SCP0022_SAVE_FORMATION_EXCEPT';
        V_MST_LOOP_CNT          PLS_INTEGER := 0;
        V_CNT                   PLS_INTEGER := 0;
        V_FORMATION_START_DATE  VARCHAR2(8 CHAR);
        V_FORMATION_END_DATE    VARCHAR2(8 CHAR);
        V_ORG_START_DATE        VARCHAR2(8 CHAR);
        V_ORG_END_DATE          VARCHAR2(8 CHAR);
        V_FORMATION_YIELD       NUMBER;
        V_CHAR_YIELD            NUMBER;
        V_FORMATION_TOTAL_YIELD NUMBER;
        V_DT_CURRENT            DATE;
        V_ERR_CODE              VARCHAR2(100 CHAR);
        V_ERR_MSG               VARCHAR2(4000 CHAR);
    BEGIN
        /* 트렌젝션 시작 */
        SAVEPOINT SP_SCP0022_SAVE;

        /* 시작 LOG */
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(C_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', NULL, SYSDATE);

        FOR R IN (SELECT A.CRUD_TYPE
                       , A.DIVISION_ID
                       , A.PLANT_SITE_ID
                       , A.ITEM_ID
                       , A.FORMATION_START_DATE
                       , A.FORMATION_END_DATE
                       , A.FORMATION_YIELD
                       , A.CHAR_YIELD
                       , A.FORMATION_TOTAL_YIELD
                       , A.EXCEPT_COMMENT
                       , A.ORG_DIVISION_ID
                       , A.ORG_PLANT_SITE_ID
                       , A.ORG_ITEM_ID
                       , A.ORG_FORMATION_START_DATE
                       , A.ORG_FORMATION_END_DATE
                    FROM JSON_TABLE(P_DATA, '$[*]'
                             COLUMNS ( RN                       FOR ORDINALITY
                                     , CRUD_TYPE                VARCHAR2(10 CHAR)   PATH '$.CRUD_TYPE'                NULL ON EMPTY
                                     , DIVISION_ID              VARCHAR2(4000 CHAR) PATH '$.DIVISION_ID'              ERROR ON ERROR NULL ON EMPTY
                                     , PLANT_SITE_ID            VARCHAR2(4000 CHAR) PATH '$.PLANT_SITE_ID'            ERROR ON ERROR NULL ON EMPTY
                                     , ITEM_ID                  VARCHAR2(4000 CHAR) PATH '$.ITEM_ID'                  ERROR ON ERROR NULL ON EMPTY
                                     , FORMATION_START_DATE     VARCHAR2(4000 CHAR) PATH '$.FORMATION_START_DATE'     ERROR ON ERROR NULL ON EMPTY
                                     , FORMATION_END_DATE       VARCHAR2(4000 CHAR) PATH '$.FORMATION_END_DATE'       ERROR ON ERROR NULL ON EMPTY
                                     , FORMATION_YIELD          VARCHAR2(4000 CHAR) PATH '$.FORMATION_YIELD'          ERROR ON ERROR NULL ON EMPTY
                                     , CHAR_YIELD               VARCHAR2(4000 CHAR) PATH '$.CHAR_YIELD'               ERROR ON ERROR NULL ON EMPTY
                                     , FORMATION_TOTAL_YIELD    VARCHAR2(4000 CHAR) PATH '$.FORMATION_TOTAL_YIELD'    ERROR ON ERROR NULL ON EMPTY
                                     , EXCEPT_COMMENT           VARCHAR2(4000 CHAR) PATH '$.EXCEPT_COMMENT'           ERROR ON ERROR NULL ON EMPTY
                                     , ORG_DIVISION_ID          VARCHAR2(4000 CHAR) PATH '$.ORG_DIVISION_ID'          ERROR ON ERROR NULL ON EMPTY
                                     , ORG_PLANT_SITE_ID        VARCHAR2(4000 CHAR) PATH '$.ORG_PLANT_SITE_ID'        ERROR ON ERROR NULL ON EMPTY
                                     , ORG_ITEM_ID              VARCHAR2(4000 CHAR) PATH '$.ORG_ITEM_ID'              ERROR ON ERROR NULL ON EMPTY
                                     , ORG_FORMATION_START_DATE VARCHAR2(4000 CHAR) PATH '$.ORG_FORMATION_START_DATE' ERROR ON ERROR NULL ON EMPTY
                                     , ORG_FORMATION_END_DATE   VARCHAR2(4000 CHAR) PATH '$.ORG_FORMATION_END_DATE'   ERROR ON ERROR NULL ON EMPTY
                                     )) A
                   WHERE A.CRUD_TYPE IN ('I', 'M', 'D')                                               /* AS-IS 화면 : 플래그 I/M/D 행만 전송 */
                   ORDER BY A.RN)
        LOOP
            /* @mst_loop_cnt 1증가 */
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 수정시 필요한 pk원본 값 2018-04-09 추가 pjs */
            V_FORMATION_START_DATE := F_TO_YMD(R.FORMATION_START_DATE);
            V_FORMATION_END_DATE   := F_TO_YMD(R.FORMATION_END_DATE);
            V_ORG_START_DATE       := F_TO_YMD(R.ORG_FORMATION_START_DATE);
            V_ORG_END_DATE         := F_TO_YMD(R.ORG_FORMATION_END_DATE);

            /* JV real plant site -> ESS virtaul plant site 단방향 저장 (virtual plant이면 skip) */
            IF F_IS_VIRTUAL_SITE(R.DIVISION_ID, R.PLANT_SITE_ID) = 0 THEN

                /* 데이터 저장 */
                IF R.CRUD_TYPE <> 'D' THEN

                    /* [PJ20257329] 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - START */
                    /**** 날짜 중복 체크 ****/
                    SELECT COUNT(1)
                      INTO V_CNT
                      FROM SCP_MST_FORMATION_EXCEPT
                     WHERE DIVISION_ID = UPPER(RTRIM(R.DIVISION_ID))
                       AND PLANT_SITE_ID = UPPER(RTRIM(R.PLANT_SITE_ID))
                       AND ITEM_ID = UPPER(RTRIM(R.ITEM_ID))
                       AND NOT (   NVL(V_FORMATION_END_DATE, ' ') < FORMATION_START_DATE
                                OR NVL(V_FORMATION_START_DATE, ' ') > FORMATION_END_DATE)
                       AND NOT (    FORMATION_START_DATE = NVL(V_ORG_START_DATE, ' ')
                                AND FORMATION_END_DATE = NVL(V_ORG_END_DATE, ' '));               /* 기존 값 */

                    IF V_CNT > 0 THEN
                        RAISE_APPLICATION_ERROR(C_DUP_ERR_NO, C_DUP_ERR_MSG);                             /* 예외발생 */
                    END IF;
                    /**** 날짜 중복 체크 END ***/
                    /* [PJ20257329] 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - END */

                    V_FORMATION_YIELD       := F_YIELD4(R.FORMATION_YIELD);
                    V_CHAR_YIELD            := F_YIELD4(R.CHAR_YIELD);
                    V_FORMATION_TOTAL_YIELD := F_YIELD4(R.FORMATION_TOTAL_YIELD);
                    V_DT_CURRENT            := SYSDATE;

                    UPDATE SCP_MST_FORMATION_EXCEPT
                       SET FORMATION_START_DATE = V_FORMATION_START_DATE
                         , FORMATION_END_DATE = V_FORMATION_END_DATE
                         , FORMATION_YIELD = V_FORMATION_YIELD
                         , CHAR_YIELD = V_CHAR_YIELD
                         , FORMATION_TOTAL_YIELD = V_FORMATION_TOTAL_YIELD
                         , EXCEPT_COMMENT = R.EXCEPT_COMMENT
                         , LAST_UPDATED_BY = P_USER_ID
                         , LAST_UPDATE_DATE = V_DT_CURRENT
                     WHERE DIVISION_ID = UPPER(RTRIM(R.ORG_DIVISION_ID))
                       AND PLANT_SITE_ID = UPPER(RTRIM(R.ORG_PLANT_SITE_ID))
                       AND ITEM_ID = UPPER(RTRIM(R.ORG_ITEM_ID))
                       AND FORMATION_START_DATE = V_ORG_START_DATE
                       AND FORMATION_END_DATE = V_ORG_END_DATE;

                    IF SQL%ROWCOUNT = 0 THEN
                        INSERT INTO SCP_MST_FORMATION_EXCEPT
                             ( DIVISION_ID
                             , PLANT_SITE_ID
                             , ITEM_ID
                             , FORMATION_START_DATE
                             , FORMATION_END_DATE
                             , FORMATION_YIELD
                             , CHAR_YIELD
                             , FORMATION_TOTAL_YIELD
                             , EXCEPT_COMMENT
                             , CREATED_BY
                             , CREATION_DATE
                             , LAST_UPDATED_BY
                             , LAST_UPDATE_DATE
                             )
                        VALUES
                             ( R.DIVISION_ID
                             , R.PLANT_SITE_ID
                             , R.ITEM_ID
                             , V_FORMATION_START_DATE
                             , V_FORMATION_END_DATE
                             , V_FORMATION_YIELD
                             , V_CHAR_YIELD
                             , V_FORMATION_TOTAL_YIELD
                             , R.EXCEPT_COMMENT
                             , P_USER_ID
                             , V_DT_CURRENT
                             , P_USER_ID
                             , V_DT_CURRENT
                             );
                    END IF;

                    P_SCP_MST_FORMATION_EXCEPT_HIST(R.DIVISION_ID
                                                  , R.PLANT_SITE_ID
                                                  , R.ITEM_ID
                                                  , V_FORMATION_START_DATE
                                                  , V_FORMATION_END_DATE
                                                  , V_FORMATION_YIELD
                                                  , V_CHAR_YIELD
                                                  , V_FORMATION_TOTAL_YIELD
                                                  , R.EXCEPT_COMMENT
                                                  , P_USER_ID
                                                  , P_USER_ID
                                                  , V_DT_CURRENT);

                    /* [PJ2025F254] 가상 Plant 사이트 데이터 동기화 */
                    P_SYNC_EXCEPT_VIRTUAL_SITE(R.DIVISION_ID
                                             , R.PLANT_SITE_ID
                                             , R.ITEM_ID
                                             , V_FORMATION_START_DATE
                                             , V_FORMATION_END_DATE
                                             , V_ORG_START_DATE
                                             , V_ORG_END_DATE
                                             , P_USER_ID);

                ELSIF R.CRUD_TYPE = 'D' THEN

                    /* [PJ2025F254] 가상 Plant 사이트 데이터 삭제 */
                    P_DEL_EXCEPT_VIRTUAL_SITE(R.ORG_DIVISION_ID
                                            , R.ORG_PLANT_SITE_ID
                                            , R.ORG_ITEM_ID
                                            , V_ORG_START_DATE
                                            , V_ORG_END_DATE);

                    DELETE
                      FROM SCP_MST_FORMATION_EXCEPT
                     WHERE DIVISION_ID = UPPER(RTRIM(R.ORG_DIVISION_ID))
                       AND PLANT_SITE_ID = UPPER(RTRIM(R.ORG_PLANT_SITE_ID))
                       AND ITEM_ID = UPPER(RTRIM(R.ORG_ITEM_ID))
                       AND FORMATION_START_DATE = V_ORG_START_DATE
                       AND FORMATION_END_DATE = V_ORG_END_DATE;

                END IF;
            END IF;
        END LOOP;   /* END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt */

        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(C_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', NULL, SYSDATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE
             , 'SUCCESS' AS MSG
             , TO_CHAR(V_MST_LOOP_CNT) AS EVENT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE := CASE WHEN SQLCODE = C_DUP_ERR_NO THEN '99010' ELSE TO_CHAR(SQLCODE) END;
            V_ERR_MSG  := F_ERR_MSG(SQLCODE, SQLERRM);

            ROLLBACK TO SAVEPOINT SP_SCP0022_SAVE;                                                    /* 입력 데이타 롤백 처리 */

            P_LOG_ERROR(C_PROGRAM_NAME
                      , 'P_USER_ID=' || P_USER_ID || ', ROW=' || V_MST_LOOP_CNT || ', FORMATION_START_DATE=' || V_FORMATION_START_DATE || ', FORMATION_END_DATE=' || V_FORMATION_END_DATE
                      , V_ERR_CODE
                      , V_ERR_MSG
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            /* 에러 메시지, 에러 데이터  반환   */
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE
                 , V_ERR_MSG AS MSG
                 , '0' AS EVENT
              FROM DUAL;
    END P_SCP0022_SAVE_FORMATION_EXCEPT;

/*
 * Program ID   : [[SCP0022_SAVE_FORMATION_EXCEPT_LT]]
 * Description  : 활성화 LT 구간별 등록, 수정, 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/09/22   KH 	            Initial Release  PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
 * 2025/10/29   hrkim		    [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
 *
 */
    PROCEDURE P_SCP0022_SAVE_FORMATION_EXCEPT_LT
    (
        P_DATA              IN  CLOB
      , P_USER_ID           IN  VARCHAR2
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        C_PROGRAM_NAME          CONSTANT VARCHAR2(150 CHAR) := 'PKG_SCP0022.P_SCP0022_SAVE_FORMATION_EXCEPT_LT';
        V_MST_LOOP_CNT          PLS_INTEGER := 0;
        V_CNT                   PLS_INTEGER := 0;
        V_FORMATION_START_DATE  VARCHAR2(8 CHAR);
        V_FORMATION_END_DATE    VARCHAR2(8 CHAR);
        V_ORG_START_DATE        VARCHAR2(8 CHAR);
        V_ORG_END_DATE          VARCHAR2(8 CHAR);
        V_LT_FORMATION          NUMBER;
        V_ADD_LT_FORMATION      NUMBER;
        V_H_LT_FORMATION        NUMBER;
        V_H_ADD_LT_FORMATION    NUMBER;
        V_DT_CURRENT            DATE;
        V_ERR_CODE              VARCHAR2(100 CHAR);
        V_ERR_MSG               VARCHAR2(4000 CHAR);
    BEGIN
        /* 트렌젝션 시작 */
        SAVEPOINT SP_SCP0022_SAVE;

        /* 시작 LOG */
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(C_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', NULL, SYSDATE);

        FOR R IN (SELECT A.CRUD_TYPE
                       , A.DIVISION_ID
                       , A.PLANT_SITE_ID
                       , A.ITEM_ID
                       , A.FORMATION_START_DATE
                       , A.FORMATION_END_DATE
                       , A.LT_FORMATION
                       , A.ADD_LT_FORMATION
                       , A.EXCEPT_COMMENT
                       , A.ORG_DIVISION_ID
                       , A.ORG_PLANT_SITE_ID
                       , A.ORG_ITEM_ID
                       , A.ORG_FORMATION_START_DATE
                       , A.ORG_FORMATION_END_DATE
                    FROM JSON_TABLE(P_DATA, '$[*]'
                             COLUMNS ( RN                       FOR ORDINALITY
                                     , CRUD_TYPE                VARCHAR2(10 CHAR)   PATH '$.CRUD_TYPE'                NULL ON EMPTY
                                     , DIVISION_ID              VARCHAR2(4000 CHAR) PATH '$.DIVISION_ID'              ERROR ON ERROR NULL ON EMPTY
                                     , PLANT_SITE_ID            VARCHAR2(4000 CHAR) PATH '$.PLANT_SITE_ID'            ERROR ON ERROR NULL ON EMPTY
                                     , ITEM_ID                  VARCHAR2(4000 CHAR) PATH '$.ITEM_ID'                  ERROR ON ERROR NULL ON EMPTY
                                     , FORMATION_START_DATE     VARCHAR2(4000 CHAR) PATH '$.FORMATION_START_DATE'     ERROR ON ERROR NULL ON EMPTY
                                     , FORMATION_END_DATE       VARCHAR2(4000 CHAR) PATH '$.FORMATION_END_DATE'       ERROR ON ERROR NULL ON EMPTY
                                     , LT_FORMATION             VARCHAR2(4000 CHAR) PATH '$.LT_FORMATION'             ERROR ON ERROR NULL ON EMPTY
                                     , ADD_LT_FORMATION         VARCHAR2(4000 CHAR) PATH '$.ADD_LT_FORMATION'         ERROR ON ERROR NULL ON EMPTY
                                     , EXCEPT_COMMENT           VARCHAR2(4000 CHAR) PATH '$.EXCEPT_COMMENT'           ERROR ON ERROR NULL ON EMPTY
                                     , ORG_DIVISION_ID          VARCHAR2(4000 CHAR) PATH '$.ORG_DIVISION_ID'          ERROR ON ERROR NULL ON EMPTY
                                     , ORG_PLANT_SITE_ID        VARCHAR2(4000 CHAR) PATH '$.ORG_PLANT_SITE_ID'        ERROR ON ERROR NULL ON EMPTY
                                     , ORG_ITEM_ID              VARCHAR2(4000 CHAR) PATH '$.ORG_ITEM_ID'              ERROR ON ERROR NULL ON EMPTY
                                     , ORG_FORMATION_START_DATE VARCHAR2(4000 CHAR) PATH '$.ORG_FORMATION_START_DATE' ERROR ON ERROR NULL ON EMPTY
                                     , ORG_FORMATION_END_DATE   VARCHAR2(4000 CHAR) PATH '$.ORG_FORMATION_END_DATE'   ERROR ON ERROR NULL ON EMPTY
                                     )) A
                   WHERE A.CRUD_TYPE IN ('I', 'M', 'D')                                               /* AS-IS 화면 : 플래그 I/M/D 행만 전송 */
                   ORDER BY A.RN)
        LOOP
            /* @mst_loop_cnt 1증가 */
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 수정시 필요한 pk원본 값 2018-04-09 추가 pjs */
            V_FORMATION_START_DATE := F_TO_YMD(R.FORMATION_START_DATE);
            V_FORMATION_END_DATE   := F_TO_YMD(R.FORMATION_END_DATE);
            V_ORG_START_DATE       := F_TO_YMD(R.ORG_FORMATION_START_DATE);
            V_ORG_END_DATE         := F_TO_YMD(R.ORG_FORMATION_END_DATE);

            /* JV real plant site -> ESS virtaul plant site 단방향 저장 (virtual plant이면 skip) */
            IF F_IS_VIRTUAL_SITE(R.DIVISION_ID, R.PLANT_SITE_ID) = 0 THEN

                /* 데이터 저장 */
                IF R.CRUD_TYPE <> 'D' THEN

                    /* declare @dLT numeric(20,10) = convert(int , @v_lt_formation); */
                    /* declare @dAddLT numeric(20,10) = convert(int , @v_add_lt_formation); */
                    V_H_LT_FORMATION     := F_TO_INT(R.LT_FORMATION);
                    V_H_ADD_LT_FORMATION := F_TO_INT(R.ADD_LT_FORMATION);
                    V_LT_FORMATION       := CASE WHEN TRIM(R.LT_FORMATION) IS NULL THEN 0 ELSE V_H_LT_FORMATION END;
                    V_ADD_LT_FORMATION   := CASE WHEN TRIM(R.ADD_LT_FORMATION) IS NULL THEN NULL ELSE V_H_ADD_LT_FORMATION END;
                    V_DT_CURRENT         := SYSDATE;

                    /**** 날짜 중복 체크 ****/
                    SELECT COUNT(1)
                      INTO V_CNT
                      FROM SCP_OPMZ_MST_FORMATION_EXCEPT_LT
                     WHERE DIVISION_ID = UPPER(RTRIM(R.DIVISION_ID))
                       AND PLANT_SITE_ID = UPPER(RTRIM(R.PLANT_SITE_ID))
                       AND ITEM_ID = UPPER(RTRIM(R.ITEM_ID))
                       AND NOT (   NVL(V_FORMATION_END_DATE, ' ') < FORMATION_START_DATE
                                OR NVL(V_FORMATION_START_DATE, ' ') > FORMATION_END_DATE)
                       AND NOT (    FORMATION_START_DATE = NVL(V_ORG_START_DATE, ' ')
                                AND FORMATION_END_DATE = NVL(V_ORG_END_DATE, ' '));               /* 기존 값 */

                    IF V_CNT > 0 THEN
                        RAISE_APPLICATION_ERROR(C_DUP_ERR_NO, C_DUP_ERR_MSG);                             /* 예외발생 */
                    END IF;
                    /**** 날ㅉ 중복 체크 END ***/

                    UPDATE SCP_OPMZ_MST_FORMATION_EXCEPT_LT
                       SET FORMATION_START_DATE = V_FORMATION_START_DATE
                         , FORMATION_END_DATE = V_FORMATION_END_DATE
                         , LT_FORMATION = V_LT_FORMATION
                         , ADD_LT_FORMATION = V_ADD_LT_FORMATION
                         , EXCEPT_COMMENT = R.EXCEPT_COMMENT
                         , LAST_UPDATED_BY = P_USER_ID
                         , LAST_UPDATE_DATE = V_DT_CURRENT
                     WHERE DIVISION_ID = UPPER(RTRIM(R.ORG_DIVISION_ID))
                       AND PLANT_SITE_ID = UPPER(RTRIM(R.ORG_PLANT_SITE_ID))
                       AND ITEM_ID = UPPER(RTRIM(R.ORG_ITEM_ID))
                       AND FORMATION_START_DATE = V_ORG_START_DATE
                       AND FORMATION_END_DATE = V_ORG_END_DATE;

                    IF SQL%ROWCOUNT = 0 THEN
                        INSERT INTO SCP_OPMZ_MST_FORMATION_EXCEPT_LT
                             ( DIVISION_ID
                             , PLANT_SITE_ID
                             , ITEM_ID
                             , FORMATION_START_DATE
                             , FORMATION_END_DATE
                             , LT_FORMATION
                             , ADD_LT_FORMATION
                             , EXCEPT_COMMENT
                             , CREATED_BY
                             , CREATION_DATE
                             , LAST_UPDATED_BY
                             , LAST_UPDATE_DATE
                             )
                        VALUES
                             ( R.DIVISION_ID
                             , R.PLANT_SITE_ID
                             , R.ITEM_ID
                             , V_FORMATION_START_DATE
                             , V_FORMATION_END_DATE
                             , V_LT_FORMATION
                             , V_ADD_LT_FORMATION
                             , R.EXCEPT_COMMENT
                             , P_USER_ID
                             , V_DT_CURRENT
                             , P_USER_ID
                             , V_DT_CURRENT
                             );
                    END IF;

                    /* AS-IS 이력 프로시저는 입력 문자를 그대로 INT 칸에 넣는다 (빈 값 0) */
                    P_SCP_MST_FORMATION_EXCEPT_LT_HIST(R.DIVISION_ID
                                                     , R.PLANT_SITE_ID
                                                     , R.ITEM_ID
                                                     , V_FORMATION_START_DATE
                                                     , V_FORMATION_END_DATE
                                                     , V_H_LT_FORMATION
                                                     , V_H_ADD_LT_FORMATION
                                                     , R.EXCEPT_COMMENT
                                                     , P_USER_ID
                                                     , P_USER_ID
                                                     , V_DT_CURRENT);

                    /* [PJ2025F254] 가상 Plant 사이트 데이터 동기화 */
                    P_SYNC_EXCEPT_LT_VIRTUAL_SITE(R.DIVISION_ID
                                                , R.PLANT_SITE_ID
                                                , R.ITEM_ID
                                                , V_FORMATION_START_DATE
                                                , V_FORMATION_END_DATE
                                                , V_ORG_START_DATE
                                                , V_ORG_END_DATE
                                                , P_USER_ID);

                ELSIF R.CRUD_TYPE = 'D' THEN

                    /* [PJ2025F254] 가상 Plant 사이트 데이터 삭제 */
                    P_DEL_EXCEPT_LT_VIRTUAL_SITE(R.ORG_DIVISION_ID
                                               , R.ORG_PLANT_SITE_ID
                                               , R.ORG_ITEM_ID
                                               , V_ORG_START_DATE
                                               , V_ORG_END_DATE);

                    DELETE
                      FROM SCP_OPMZ_MST_FORMATION_EXCEPT_LT
                     WHERE DIVISION_ID = UPPER(RTRIM(R.ORG_DIVISION_ID))
                       AND PLANT_SITE_ID = UPPER(RTRIM(R.ORG_PLANT_SITE_ID))
                       AND ITEM_ID = UPPER(RTRIM(R.ORG_ITEM_ID))
                       AND FORMATION_START_DATE = V_ORG_START_DATE
                       AND FORMATION_END_DATE = V_ORG_END_DATE;

                END IF;
            END IF;
        END LOOP;   /* END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt */

        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(C_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', NULL, SYSDATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE
             , 'SUCCESS' AS MSG
             , TO_CHAR(V_MST_LOOP_CNT) AS EVENT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE := CASE WHEN SQLCODE = C_DUP_ERR_NO THEN '99010' ELSE TO_CHAR(SQLCODE) END;
            V_ERR_MSG  := F_ERR_MSG(SQLCODE, SQLERRM);

            ROLLBACK TO SAVEPOINT SP_SCP0022_SAVE;                                                    /* 입력 데이타 롤백 처리 */

            P_LOG_ERROR(C_PROGRAM_NAME
                      , 'P_USER_ID=' || P_USER_ID || ', ROW=' || V_MST_LOOP_CNT || ', FORMATION_START_DATE=' || V_FORMATION_START_DATE || ', FORMATION_END_DATE=' || V_FORMATION_END_DATE
                      , V_ERR_CODE
                      , V_ERR_MSG
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            /* 에러 메시지, 에러 데이터  반환   */
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE
                 , V_ERR_MSG AS MSG
                 , '0' AS EVENT
              FROM DUAL;
    END P_SCP0022_SAVE_FORMATION_EXCEPT_LT;

END PKG_SCP0022;
