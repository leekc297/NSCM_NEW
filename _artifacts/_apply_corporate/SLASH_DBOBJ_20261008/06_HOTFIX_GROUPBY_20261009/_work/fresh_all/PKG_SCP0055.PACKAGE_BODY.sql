PACKAGE BODY PKG_SCP0055
IS
    /*
     * Program ID   : PKG_SCP0055
     * Description  : SCP0055 Shipment(Allo) Report 화면 — 팀별 출하 계획 · 실적 조회, 메모 조회 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.26   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     * 2026.10.07   ZIONEX       화면 실측 검증 — 메모 저장 여러 줄(^ 이음) 처리
     */

/****************************************************************************************************/
/* Program ID  : P_SCP0055_GET_SHIPMENT_ALLO_PLAN                                                   */
/* Description : 팀별 출하 계획 · 실적 조회                                                         */
/****************************************************************************************************/
PROCEDURE P_SCP0055_GET_SHIPMENT_ALLO_PLAN
(
    P_FROM_YYYYMMDD         IN  CLOB
  , P_TO_YYYYMMDD           IN  CLOB
  , P_DIVISION_ID           IN  CLOB
  , P_BIZ_TYPE              IN  CLOB
  , P_ITEM_ID               IN  CLOB
  , P_CELL_TYPE_GR          IN  CLOB
  , P_PLAN_START_YYYYMMDD   IN  CLOB
  , P_FROMSITE              IN  CLOB
  , P_TEAM_ID               IN  CLOB
  , P_NICKNAME              IN  CLOB
  , P_PROGRAM_ID            IN  CLOB      /* 원문도 받기만 하고 쓰지 않는다 */
  , P_SHEET_NAME            IN  CLOB      /* 원문도 받기만 하고 쓰지 않는다 */
  , P_USER_ID               IN  CLOB      /* 원문도 받기만 하고 쓰지 않는다 */
  , P_FCST_YN               IN  CLOB
  , O_RC1                   OUT SYS_REFCURSOR
  , O_RC2                   OUT SYS_REFCURSOR
  , O_RC3                   OUT SYS_REFCURSOR
  , O_RC4                   OUT SYS_REFCURSOR
  , O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
IS
    /* 원문이 조회조건을 NVARCHAR(8)·NVARCHAR(30)·NVARCHAR(3)·NVARCHAR(2) 로 받아 그 길이에서 자른다 */
    V_FROM_YYYYMMDD_IN      VARCHAR2(8 CHAR)    := TO_CHAR(SUBSTR(P_FROM_YYYYMMDD,       1, 8));
    V_TO_YYYYMMDD_IN        VARCHAR2(8 CHAR)    := TO_CHAR(SUBSTR(P_TO_YYYYMMDD,         1, 8));
    V_DIVISION_ID           VARCHAR2(30 CHAR)   := TO_CHAR(SUBSTR(P_DIVISION_ID,         1, 30));
    V_BIZ_TYPE              VARCHAR2(30 CHAR)   := TO_CHAR(SUBSTR(P_BIZ_TYPE,            1, 30));
    V_ITEM_ID               VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID,             1, 4000));
    V_CELL_TYPE_GR          VARCHAR2(3 CHAR)    := TO_CHAR(SUBSTR(P_CELL_TYPE_GR,        1, 3));
    V_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR)    := TO_CHAR(SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8));
    V_FROMSITE              VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_FROMSITE,            1, 4000));
    V_TEAM_ID               VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_TEAM_ID,             1, 4000));
    V_NICKNAME              VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_NICKNAME,            1, 4000));
    V_FCST_YN               VARCHAR2(2 CHAR)    := TO_CHAR(SUBSTR(P_FCST_YN,             1, 2));

    /* 계획 · 실적 기간 */
    V_FROM_YYYYMMDD         VARCHAR2(8 CHAR)    := '';
    V_TO_YYYYMMDD           VARCHAR2(8 CHAR)    := '';
    V_FROM_RESULT           VARCHAR2(8 CHAR)    := '';
    V_TO_RESULT             VARCHAR2(8 CHAR)    := '';

    V_PLAN_TYPE             VARCHAR2(8 CHAR);
    V_SEQ                   VARCHAR2(8 CHAR);
BEGIN

    /* 시작 시 임시 자료를 비운다 (TRUNCATE 는 암묵 커밋이라 쓰지 않는다) */
    DELETE FROM GT_SCP0055_PLAN;
    DELETE FROM GT_SCP0055_PLAN_TOTAL;
    DELETE FROM GT_SCP0055_RESULT;
    DELETE FROM GT_SCP0055_RESULT_TOTAL;

    /* 계획 시작일 · 조회 기간의 주 시작일 */
    BEGIN
        SELECT BASIS_START_DATE
          INTO V_FROM_YYYYMMDD
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD = V_PLAN_START_YYYYMMDD;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_FROM_YYYYMMDD := '';
    END;

    BEGIN
        SELECT BASIS_START_DATE
          INTO V_FROM_RESULT
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD = V_FROM_YYYYMMDD_IN;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_FROM_RESULT := '';
    END;

    BEGIN
        SELECT BASIS_START_DATE
          INTO V_TO_RESULT
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD = V_TO_YYYYMMDD_IN;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_TO_RESULT := '';
    END;

    /* ★원문이 네 갈래로 적었으나 둘째 갈래가 첫째의 반대라 셋째 · 넷째에는 닿지 않는다.
          원문 그대로 옮긴다 */
    IF V_FROM_YYYYMMDD > V_FROM_RESULT
    THEN
        /* 실적 보여줌 */
        V_TO_YYYYMMDD := V_TO_YYYYMMDD_IN;
        V_TO_RESULT   := V_FROM_YYYYMMDD;
    ELSIF V_FROM_YYYYMMDD <= V_FROM_RESULT
    THEN
        /* 실적 없음 */
        V_TO_YYYYMMDD := V_TO_YYYYMMDD_IN;
        V_FROM_RESULT := TO_CHAR(ADD_MONTHS(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD'),  6), 'YYYYMMDD');
        V_TO_RESULT   := TO_CHAR(ADD_MONTHS(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');
    ELSIF V_FROM_YYYYMMDD > V_TO_RESULT
    THEN
        V_FROM_YYYYMMDD := TO_CHAR(ADD_MONTHS(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');
        V_TO_YYYYMMDD   := TO_CHAR(ADD_MONTHS(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');
        V_FROM_RESULT   := V_FROM_YYYYMMDD_IN;
        V_TO_RESULT     := V_TO_YYYYMMDD_IN;
    ELSIF V_FROM_YYYYMMDD = V_TO_RESULT
    THEN
        V_TO_YYYYMMDD := V_FROM_YYYYMMDD;
        V_FROM_RESULT := V_FROM_YYYYMMDD_IN;
        V_TO_RESULT   := V_TO_YYYYMMDD_IN;
    END IF;

    /* ★원문이 품목 · 출발사이트를 따옴표로 이은 문자로 만들어 두고 쓰지 않는다. 옮기지 않았다
          (@ARR_ITEM_ID · @ARR_FROMSITE) */

    /* 최신 PLAN TYPE, SEQ 조회
       ##################################################################################
       -- 20220413 요청사항
       PR까지만 진행된 경우엔 PR의 amend
       MA까지 진행된경우엔 MA의 amend값
       FN이 진행되어도 MA의 amend값 */
    BEGIN
        SELECT IA.CODE
             , IA.PLAN_SEQ
          INTO V_PLAN_TYPE
             , V_SEQ
          FROM (SELECT PLAN_TYPE                    AS CODE
                     , MAX(PLAN_SEQ)                AS PLAN_SEQ
                     , MAX(PLAN_TYPE_ORDER)         AS PLAN_TYPE_ORDER
                  FROM SCP_PLAN_VERSION_V
                 WHERE DIVISION_ID         = V_DIVISION_ID
                   AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                   AND PLAN_TYPE IN ('PR', 'MA')
                 GROUP BY PLAN_TYPE) IA
         WHERE IA.PLAN_TYPE_ORDER = (SELECT MAX(XA.PLAN_TYPE_ORDER)
                                       FROM (SELECT MAX(PLAN_TYPE_ORDER) AS PLAN_TYPE_ORDER
                                               FROM SCP_PLAN_VERSION_V
                                              WHERE DIVISION_ID         = V_DIVISION_ID
                                                AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                AND PLAN_TYPE IN ('PR', 'MA')
                                              GROUP BY PLAN_TYPE) XA);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;   /* 원문도 값을 못 찾으면 그대로 둔다 */
    END;

    /* ##################################################################################
       -- 20220425 요청사항
       P_FCST_YN = Y => FN
       P_FCST_YN = N => PR, MA */
    IF V_FCST_YN = 'Y'
    THEN
        BEGIN
            SELECT IA.CODE
                 , IA.PLAN_SEQ
              INTO V_PLAN_TYPE
                 , V_SEQ
              FROM (SELECT PLAN_TYPE                AS CODE
                         , MAX(PLAN_SEQ)            AS PLAN_SEQ
                         , MAX(PLAN_TYPE_ORDER)     AS PLAN_TYPE_ORDER
                      FROM SCP_PLAN_VERSION_V
                     WHERE DIVISION_ID         = V_DIVISION_ID
                       AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                       AND PLAN_TYPE IN ('PR', 'MA', 'FN')
                     GROUP BY PLAN_TYPE) IA
             WHERE IA.PLAN_TYPE_ORDER = (SELECT MAX(XA.PLAN_TYPE_ORDER)
                                           FROM (SELECT MAX(PLAN_TYPE_ORDER) AS PLAN_TYPE_ORDER
                                                   FROM SCP_PLAN_VERSION_V
                                                  WHERE DIVISION_ID         = V_DIVISION_ID
                                                    AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                    AND PLAN_TYPE IN ('PR', 'MA', 'FN')
                                                  GROUP BY PLAN_TYPE) XA);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;
    END IF;

    /* 계획 (Shipment Plan FG) */
    INSERT INTO GT_SCP0055_PLAN
                ( DIVISION_ID, SITE_ID, SITE_NAME, EXTRA_SPEC, NICK_NAME
                , DEPT_ID, DEPT_NAME, YYYYMMDD, QTY, PLAN_FROM )
    SELECT IA.DIVISION_ID
         , IA.SITE_ID
         , IA.SITE_NAME
         , IA.EXTRA_SPEC
         , IA.NICK_NAME
         , IA.DEPT_ID
         , IA.DEPT_NAME
         , IA.YYYYMMDD
         , SUM(IA.QTY)                                              AS QTY
         , 'FG'                                                     AS PLAN_FROM
      FROM (SELECT A.DIVISION_ID
                 , A.FROM_SITE                                      AS SITE_ID
                 , NVL((SELECT XA.SITE_DESCRIPTION
                          FROM SCM_MST_SITE XA
                         WHERE XA.SCM_SITE_ID = A.FROM_SITE
                           AND ROWNUM         = 1), '/')             AS SITE_NAME
                 , (SELECT NVL(XB.SCP_EXTRA_SPEC, '-')
                      FROM SCM_MST_ITEM_SN XB
                     WHERE XB.DIVISION_ID = A.DIVISION_ID
                       AND XB.ITEM_ID     = A.ITEM_ID
                       AND ROWNUM         = 1)                       AS EXTRA_SPEC
                 , (SELECT NVL(XC.NICK_NAME, '-')
                      FROM SCM_MST_ITEM_SN XC
                     WHERE XC.ITEM_ID = A.ITEM_ID
                       AND ROWNUM     = 1)                           AS NICK_NAME
                 , D.DEPT_ID
                 , E.DEPT_NAME_KO                                    AS DEPT_NAME
                 , A.YYYYMMDD
                 , A.QTY
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_TYPE
                 , A.SEQ
                 , A.BIZ_TYPE
                 , A.ITEM_ID
              FROM SCP_ANL_SHIPMENT_PLAN_FG A
                 , SCP_MST_FINAL_ITEM       B
                 , SCM_MST_SITE_ITEM        C
                 , SCM_MST_SSO_USER_INFO    D
                 , SCM_MST_SSO_DEPT_INFO    E
             WHERE B.DIVISION_ID          = A.DIVISION_ID
               AND B.OPERATION_GROUP_ID   = A.BIZ_TYPE
               AND B.ITEM_ID              = A.ITEM_ID
               AND C.DIVISION_ID          = A.DIVISION_ID
               AND C.SCM_SITE_ID          = A.TO_SITE
               AND C.PROJECT_CODE         = A.PROJECT_CODE
               AND C.ITEM_ID              = A.ITEM_ID
               AND C.VALID_YN             = 'Y'
               /* ★원문은 소유자 목록의 첫 사람을 잘라 쓴다. MSSQL SUBSTRING 시작이 0 이라
                     쉼표 앞까지만 잘리므로 Oracle 은 시작 1 · 길이를 하나 줄여 맞춘다 */
               /* ★원문은 소유자 목록의 첫 사람을 잘라 쓴다. MSSQL SUBSTRING 시작이 0 이라
                     쉼표 앞까지만 잘리므로 Oracle 은 시작 1 · 길이를 하나 줄여 맞춘다.
                     AS-IS 는 대소문자를 가리지 않는다. 소유자와 사용자 번호가 대소문자만 다른 행이
                     4,256건 있어 양쪽을 대문자로 맞춘다 */
               AND UPPER(D.USER_ID(+))    = UPPER(SUBSTR(C.OWNER, 1, CASE WHEN INSTR(C.OWNER, ',') = 0
                                                                          THEN LENGTH(C.OWNER)
                                                                          ELSE INSTR(C.OWNER, ',') - 1
                                                                     END))
               AND E.DEPT_ID(+)           = D.DEPT_ID
               AND A.YYYYMMDD            >= V_FROM_YYYYMMDD
               AND A.YYYYMMDD            <= V_TO_YYYYMMDD
               AND A.DIVISION_ID          = V_DIVISION_ID
               AND A.BIZ_TYPE             = V_BIZ_TYPE
               AND (TRIM(V_FROMSITE) IS NULL
                OR  UPPER(V_FROMSITE) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                OR  A.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE)
                                      FROM TABLE(STRING_SPLIT(V_FROMSITE, ','))))
               AND (TRIM(V_TEAM_ID) IS NULL
                OR  UPPER(V_TEAM_ID) = 'ALL'                         /* 조회조건 ALL 은 조건 없음 */
                OR  D.DEPT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                    FROM TABLE(STRING_SPLIT(V_TEAM_ID, ','))))
               AND (TRIM(V_ITEM_ID) IS NULL
                OR  UPPER(V_ITEM_ID) = 'ALL'                         /* 조회조건 ALL 은 조건 없음 */
                OR  A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
                                    FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
               AND (TRIM(V_CELL_TYPE_GR) IS NULL
                OR  UPPER(V_CELL_TYPE_GR) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
                OR  B.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                                 FROM TABLE(STRING_SPLIT(V_CELL_TYPE_GR, ','))))
               AND A.MEASURE              = 'SHIP_PLAN_AMEND'
               AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
               /* 파티션 키(가상 컬럼)로 훑는 범위를 줄인다. 값은 계획 시작일과 같다 */
               AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD')
               AND A.PLAN_TYPE            = V_PLAN_TYPE
               AND A.SEQ                  = TO_NUMBER(V_SEQ)
               AND A.QTY                  > 0) IA
     GROUP BY IA.DIVISION_ID
            , IA.PLAN_START_YYYYMMDD
            , IA.PLAN_TYPE
            , IA.SEQ
            , IA.BIZ_TYPE
            , IA.SITE_ID
            , IA.ITEM_ID
            , IA.DEPT_ID
            , IA.DEPT_NAME
            , IA.YYYYMMDD
            , IA.SITE_NAME
            , IA.EXTRA_SPEC
            , IA.NICK_NAME;

    /* 계획 (Shipment Plan Semi) */
    INSERT INTO GT_SCP0055_PLAN
                ( DIVISION_ID, SITE_ID, SITE_NAME, EXTRA_SPEC, NICK_NAME
                , DEPT_ID, DEPT_NAME, YYYYMMDD, QTY, PLAN_FROM )
    SELECT IA.DIVISION_ID
         , IA.SITE_ID
         , IA.SITE_NAME
         , IA.EXTRA_SPEC
         , IA.NICK_NAME
         , IA.DEPT_ID
         , IA.DEPT_NAME
         , IA.YYYYMMDD
         , SUM(IA.QTY)                                              AS QTY
         , 'SEMI'                                                   AS PLAN_FROM
      FROM (SELECT A.DIVISION_ID
                 , A.FROM_SITE                                      AS SITE_ID
                 , NVL((SELECT XA.SITE_DESCRIPTION
                          FROM SCM_MST_SITE XA
                         WHERE XA.SCM_SITE_ID = A.FROM_SITE
                           AND ROWNUM         = 1), '/')             AS SITE_NAME
                 , (SELECT NVL(XB.SCP_EXTRA_SPEC, '-')
                      FROM SCM_MST_ITEM_SN XB
                     WHERE XB.DIVISION_ID = A.DIVISION_ID
                       AND XB.ITEM_ID     = A.ITEM_ID
                       AND ROWNUM         = 1)                       AS EXTRA_SPEC
                 , (SELECT NVL(XC.NICK_NAME, '-')
                      FROM SCM_MST_ITEM_SN XC
                     WHERE XC.ITEM_ID = A.ITEM_ID
                       AND ROWNUM     = 1)                           AS NICK_NAME
                 , C.ATTRIBUTE1                                      AS DEPT_ID
                 , C.ATTRIBUTE2                                      AS DEPT_NAME
                 , A.YYYYMMDD
                 , A.QTY
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_TYPE
                 , A.SEQ
                 , A.OPERATION_GROUP
                 , A.ITEM_ID
              FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                 , SCP_MST_FINAL_ITEM         B
                 , SCM_ADM_LOOKUP_MASTER_DETAIL C
             WHERE B.DIVISION_ID          = A.DIVISION_ID
               AND B.OPERATION_GROUP_ID   = A.OPERATION_GROUP
               AND B.ITEM_ID              = A.ITEM_ID
               AND C.SEGMENT1(+)          = A.FROM_SITE
               AND C.SEGMENT2(+)          = A.TO_SITE
               AND C.SEGMENT3(+)          = A.ITEM_ID
               AND C.LOOKUP_TYPE(+)       = 'SHIPMENT_REPORT_LOOKUP'
               AND A.YYYYMMDD            >= V_FROM_YYYYMMDD
               AND A.YYYYMMDD            <= V_TO_YYYYMMDD
               AND A.DIVISION_ID          = V_DIVISION_ID
               AND A.OPERATION_GROUP      = V_BIZ_TYPE
               AND (TRIM(V_FROMSITE) IS NULL
                OR  UPPER(V_FROMSITE) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                OR  A.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE)
                                      FROM TABLE(STRING_SPLIT(V_FROMSITE, ','))))
               AND (TRIM(V_TEAM_ID) IS NULL
                OR  UPPER(V_TEAM_ID) = 'ALL'                         /* 조회조건 ALL 은 조건 없음 */
                OR  C.ATTRIBUTE1 IN (SELECT UPPER(COLUMN_VALUE)
                                       FROM TABLE(STRING_SPLIT(V_TEAM_ID, ','))))
               AND (TRIM(V_ITEM_ID) IS NULL
                OR  UPPER(V_ITEM_ID) = 'ALL'                         /* 조회조건 ALL 은 조건 없음 */
                OR  A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
                                    FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
               AND (TRIM(V_CELL_TYPE_GR) IS NULL
                OR  UPPER(V_CELL_TYPE_GR) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
                OR  B.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                                 FROM TABLE(STRING_SPLIT(V_CELL_TYPE_GR, ','))))
               AND A.MEASURE              = 'SHIP_PLAN_AMEND'
               AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
               /* 파티션 키(가상 컬럼)로 훑는 범위를 줄인다 */
               AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD')
               AND A.PLAN_TYPE            = V_PLAN_TYPE
               AND A.SEQ                  = TO_NUMBER(V_SEQ)
               AND A.QTY                  > 0) IA
     GROUP BY IA.DIVISION_ID
            , IA.PLAN_START_YYYYMMDD
            , IA.PLAN_TYPE
            , IA.SEQ
            , IA.OPERATION_GROUP
            , IA.SITE_ID
            , IA.ITEM_ID
            , IA.DEPT_ID
            , IA.DEPT_NAME
            , IA.YYYYMMDD
            , IA.SITE_NAME
            , IA.EXTRA_SPEC
            , IA.NICK_NAME;

    /* 계획 합계 */
    INSERT INTO GT_SCP0055_PLAN_TOTAL
                ( DIVISION_ID, SITE_ID, SITE_NAME, EXTRA_SPEC, NICK_NAME
                , DEPT_ID, DEPT_NAME, YYYYMMDD, QTY, PLAN_FROM )
    SELECT A.DIVISION_ID
         , A.SITE_ID
         , A.SITE_NAME
         , A.EXTRA_SPEC
         , A.NICK_NAME
         , A.DEPT_ID
         , A.DEPT_NAME
         , A.YYYYMMDD
         , SUM(A.QTY)                                               AS QTY
         , 'PLAN_TOTAL'                                             AS PLAN_FROM
      FROM GT_SCP0055_PLAN A
     WHERE (TRIM(V_NICKNAME) IS NULL
        OR  UPPER(V_NICKNAME) = 'ALL'                               /* 조회조건 ALL 은 조건 없음 */
        OR  A.NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                              FROM TABLE(STRING_SPLIT(V_NICKNAME, ','))))
     GROUP BY A.DIVISION_ID
            , A.NICK_NAME
            , A.SITE_ID
            , A.SITE_NAME
            , A.EXTRA_SPEC
            , A.DEPT_ID
            , A.DEPT_NAME
            , A.YYYYMMDD;

    /* 팀별 출하 실적 (ERP) — 확정번호가 있는 것
       ★원문은 소유자 찾는 스칼라 조회를 조인 조건에 두었다. Oracle 은 외부 조인 조건에
         조회문을 쓸 수 없어(ORA-01799) 담당 · 팀 이름을 스칼라 조회로 바꿔 인라인 조회에 두었다.
         담당 원장은 사용자 번호가, 팀 원장은 팀 번호가 하나뿐임을 실측해 값이 갈리지 않는다 */
    INSERT INTO GT_SCP0055_RESULT
                ( DIVISION_ID, SITE_ID, SITE_NAME, EXTRA_SPEC, NICK_NAME
                , DEPT_ID, DEPT_NAME, YYYYMMDD, QTY, PLAN_FROM, CONFIRM_ID )
    SELECT IA.DIVISION_ID
         , IA.SITE_ID
         , IA.SITE_NAME
         , IA.EXTRA_SPEC
         , IA.NICK_NAME
         , NVL(IA.SUI_DEPT_ID, IA.LMD_ATTRIBUTE1)                   AS DEPT_ID
         , NVL(NVL(IA.SDI_DEPT_NAME_KO, IA.LMD_ATTRIBUTE2), IA.SMS_SITE_DESCRIPTION) AS DEPT_NAME
         , IA.YYYYMMDD
         , SUM(IA.QTY)                                              AS QTY
         , 'RESULT_CE'                                              AS PLAN_FROM
         , IA.CONFIRM_ID
      FROM (SELECT A.DIVISION_ID
                 , B.FROM_SITE                                      AS SITE_ID
                 , NVL((SELECT XA.SITE_DESCRIPTION
                          FROM SCM_MST_SITE XA
                         WHERE XA.SCM_SITE_ID = B.FROM_SITE
                           AND ROWNUM         = 1), '/')             AS SITE_NAME
                 , (SELECT NVL(XB.SCP_EXTRA_SPEC, '-')
                      FROM SCM_MST_ITEM_SN XB
                     WHERE XB.DIVISION_ID = A.DIVISION_ID
                       AND XB.ITEM_ID     = A.ITEM_ID
                       AND ROWNUM         = 1)                       AS EXTRA_SPEC
                 , (SELECT NVL(XC.NICK_NAME, '-')
                      FROM SCM_MST_ITEM_SN XC
                     WHERE XC.ITEM_ID = A.ITEM_ID
                       AND ROWNUM     = 1)                           AS NICK_NAME
                 /* 담당 팀 — 도착 사이트의 품목 소유자로 찾는다 */
                 , (SELECT XD.DEPT_ID
                      FROM SCM_MST_SSO_USER_INFO XD
                     WHERE UPPER(XD.USER_ID) = (SELECT UPPER(XE.OWNER)
                                           FROM (SELECT XF.OWNER
                                                   FROM SCM_MST_SITE_ITEM XF
                                                  WHERE XF.DIVISION_ID = A.DIVISION_ID
                                                    AND XF.SCM_SITE_ID = NVL(C3.SEGMENT4, B.TO_SITE)
                                                    AND XF.ITEM_ID     = A.ITEM_ID
                                                    AND XF.VALID_YN    = 'Y'
                                                  /* ★원문은 소유자를 한 행만 고르고 차례를 정하지 않았다.
                                                        차례를 정하면 값 없는 소유자가 뒤로 밀려 원문과 갈리므로
                                                        원문처럼 정하지 않고 둔다 (재현 대상 아님) */
                                                  ) XE
                                          WHERE ROWNUM = 1)) AS SUI_DEPT_ID
                 , (SELECT XG.DEPT_NAME_KO
                      FROM SCM_MST_SSO_DEPT_INFO XG
                     WHERE XG.DEPT_ID  = (SELECT XH.DEPT_ID
                                            FROM SCM_MST_SSO_USER_INFO XH
                                           WHERE UPPER(XH.USER_ID) = (SELECT UPPER(XI.OWNER)
                                                                 FROM (SELECT XJ.OWNER
                                                                         FROM SCM_MST_SITE_ITEM XJ
                                                                        WHERE XJ.DIVISION_ID = A.DIVISION_ID
                                                                          AND XJ.SCM_SITE_ID = NVL(C3.SEGMENT4, B.TO_SITE)
                                                                          AND XJ.ITEM_ID     = A.ITEM_ID
                                                                          AND XJ.VALID_YN    = 'Y'
                                                                        ) XI
                                                                WHERE ROWNUM = 1))
                       AND XG.VALID_YN = 'Y') AS SDI_DEPT_NAME_KO
                 , C4.ATTRIBUTE1                                     AS LMD_ATTRIBUTE1
                 , C4.ATTRIBUTE2                                     AS LMD_ATTRIBUTE2
                 , D.SITE_DESCRIPTION                                AS SMS_SITE_DESCRIPTION
                 , A.EXFACTORY_DATE                                  AS YYYYMMDD
                 , A.EXFACTORY_QTY                                   AS QTY
                 , A.CONFIRM_ID
                 , A.ITEM_ID
              FROM SCM_DNM_EXFACTORY_RESULT      A
                 , SSP_ANL_SHIP_CONFIRM          B
                 , SCP_MST_FINAL_ITEM            C
                 , SCM_ADM_LOOKUP_MASTER_DETAIL  C2
                 , SCM_ADM_LOOKUP_MASTER_DETAIL  C3
                 , SCM_ADM_LOOKUP_MASTER_DETAIL  C4
                 , SCM_MST_SITE                  D
             WHERE B.DIVISION_ID       = A.DIVISION_ID
               AND B.CONFIRM_ID        = A.CONFIRM_ID
               AND C.ITEM_ID           = A.ITEM_ID
               AND C.DIVISION_ID       = A.DIVISION_ID
               /* 룩업에 등록된 공정만 */
               AND C2.LOOKUP_TYPE      = 'ERP_SSP_TYPE'
               AND C2.VALID_YN         = 'Y'
               AND C2.SEGMENT1         = A.SSP_TYPE
               /* SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE */
               AND C3.LOOKUP_TYPE(+)   = 'SHIP_RESULT_TO_SITE_MAPPING'
               AND C3.SEGMENT1(+)      = A.DIVISION_ID
               AND C3.SEGMENT2(+)      = A.SOLDTO_CODE
               AND C3.SEGMENT3(+)      = A.SHIPTO_CODE
               AND C4.SEGMENT1(+)      = A.FROM_SCM_SITE_ID
               AND C4.SEGMENT2(+)      = NVL(C3.SEGMENT4, B.TO_SITE)
               AND C4.SEGMENT3(+)      = A.ITEM_ID
               AND C4.LOOKUP_TYPE(+)   = 'SHIPMENT_REPORT_LOOKUP'
               AND D.DIVISION_ID(+)    = A.DIVISION_ID
               AND D.SCM_SITE_ID(+)    = B.TO_SITE
               AND D.OSP_YN(+)         = 'Y'
               AND D.VALID_YN(+)       = 'Y'
               /* D90: DO삭제 , D10:DO생성 */
               AND NVL(A.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')
               AND A.CONFIRM_ID LIKE 'C%'
               AND A.DIVISION_ID       = V_DIVISION_ID
               AND C.OPERATION_GROUP   = V_BIZ_TYPE
               AND (TRIM(V_FROMSITE) IS NULL
                OR  UPPER(V_FROMSITE) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                OR  B.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE)
                                      FROM TABLE(STRING_SPLIT(V_FROMSITE, ','))))
               AND (TRIM(V_CELL_TYPE_GR) IS NULL
                OR  UPPER(V_CELL_TYPE_GR) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
                OR  C.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                                 FROM TABLE(STRING_SPLIT(V_CELL_TYPE_GR, ','))))
               AND (TRIM(V_ITEM_ID) IS NULL
                OR  UPPER(V_ITEM_ID) = 'ALL'                         /* 조회조건 ALL 은 조건 없음 */
                OR  A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
                                    FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
               AND A.EXFACTORY_DATE   >= V_FROM_RESULT
               AND A.EXFACTORY_DATE    < V_TO_RESULT) IA
     /* 팀 조건은 담당 · 룩업 둘 중 하나만 맞아도 통과한다(원문과 같다) */
     WHERE (TRIM(V_TEAM_ID) IS NULL
        OR  UPPER(V_TEAM_ID) = 'ALL'                                 /* 조회조건 ALL 은 조건 없음 */
        OR  IA.SUI_DEPT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                 FROM TABLE(STRING_SPLIT(V_TEAM_ID, ',')))
        OR  IA.LMD_ATTRIBUTE1 IN (SELECT UPPER(COLUMN_VALUE)
                                    FROM TABLE(STRING_SPLIT(V_TEAM_ID, ','))))
     GROUP BY IA.DIVISION_ID
            , IA.SITE_ID
            , IA.ITEM_ID
            , NVL(IA.SUI_DEPT_ID, IA.LMD_ATTRIBUTE1)
            , IA.SDI_DEPT_NAME_KO
            , IA.LMD_ATTRIBUTE2
            , IA.SMS_SITE_DESCRIPTION
            , IA.YYYYMMDD
            , IA.CONFIRM_ID
            , IA.SITE_NAME
            , IA.EXTRA_SPEC
            , IA.NICK_NAME;

    /* 팀별 출하 실적 (ERP) — 확정번호가 없는 것 */
    INSERT INTO GT_SCP0055_RESULT
                ( DIVISION_ID, SITE_ID, SITE_NAME, EXTRA_SPEC, NICK_NAME
                , DEPT_ID, DEPT_NAME, YYYYMMDD, QTY, PLAN_FROM, CONFIRM_ID )
    SELECT IA.DIVISION_ID
         , IA.SITE_ID
         , IA.SITE_NAME
         , IA.EXTRA_SPEC
         , IA.NICK_NAME
         , NVL(IA.SUI_DEPT_ID, IA.LMD_ATTRIBUTE1)                   AS DEPT_ID
         , NVL(NVL(IA.SDI_DEPT_NAME_KO, IA.LMD_ATTRIBUTE2), IA.SMS_SITE_DESCRIPTION) AS DEPT_NAME
         , IA.YYYYMMDD
         , SUM(IA.QTY)                                              AS QTY
         , 'RESULT_CN'                                              AS PLAN_FROM
         , NULL                                                     AS CONFIRM_ID
      FROM (SELECT A.DIVISION_ID
                 , A.FROM_SCM_SITE_ID                               AS SITE_ID
                 , NVL((SELECT XA.SITE_DESCRIPTION
                          FROM SCM_MST_SITE XA
                         WHERE XA.SCM_SITE_ID = A.FROM_SCM_SITE_ID
                           AND ROWNUM         = 1), '/')             AS SITE_NAME
                 , (SELECT NVL(XB.SCP_EXTRA_SPEC, '-')
                      FROM SCM_MST_ITEM_SN XB
                     WHERE XB.DIVISION_ID = A.DIVISION_ID
                       AND XB.ITEM_ID     = A.ITEM_ID
                       AND ROWNUM         = 1)                       AS EXTRA_SPEC
                 , (SELECT NVL(XC.NICK_NAME, '-')
                      FROM SCM_MST_ITEM_SN XC
                     WHERE XC.ITEM_ID = A.ITEM_ID
                       AND ROWNUM     = 1)                           AS NICK_NAME
                 , (SELECT XD.DEPT_ID
                      FROM SCM_MST_SSO_USER_INFO XD
                     WHERE UPPER(XD.USER_ID) = (SELECT UPPER(XE.OWNER)
                                           FROM (SELECT XF.OWNER
                                                   FROM SCM_MST_SITE_ITEM XF
                                                  WHERE XF.DIVISION_ID = A.DIVISION_ID
                                                    AND XF.SCM_SITE_ID = NVL(C3.SEGMENT4, A.TO_SCM_SITE_ID)
                                                    AND XF.ITEM_ID     = A.ITEM_ID
                                                    AND XF.VALID_YN    = 'Y'
                                                  ) XE
                                          WHERE ROWNUM = 1)) AS SUI_DEPT_ID
                 , (SELECT XG.DEPT_NAME_KO
                      FROM SCM_MST_SSO_DEPT_INFO XG
                     WHERE XG.DEPT_ID  = (SELECT XH.DEPT_ID
                                            FROM SCM_MST_SSO_USER_INFO XH
                                           WHERE UPPER(XH.USER_ID) = (SELECT UPPER(XI.OWNER)
                                                                 FROM (SELECT XJ.OWNER
                                                                         FROM SCM_MST_SITE_ITEM XJ
                                                                        WHERE XJ.DIVISION_ID = A.DIVISION_ID
                                                                          AND XJ.SCM_SITE_ID = NVL(C3.SEGMENT4, A.TO_SCM_SITE_ID)
                                                                          AND XJ.ITEM_ID     = A.ITEM_ID
                                                                          AND XJ.VALID_YN    = 'Y'
                                                                        ) XI
                                                                WHERE ROWNUM = 1))
                       AND XG.VALID_YN = 'Y') AS SDI_DEPT_NAME_KO
                 , C4.ATTRIBUTE1                                     AS LMD_ATTRIBUTE1
                 , C4.ATTRIBUTE2                                     AS LMD_ATTRIBUTE2
                 , D.SITE_DESCRIPTION                                AS SMS_SITE_DESCRIPTION
                 , A.EXFACTORY_DATE                                  AS YYYYMMDD
                 , A.EXFACTORY_QTY                                   AS QTY
                 , A.ITEM_ID
              FROM SCM_DNM_EXFACTORY_RESULT      A
                 , SCP_MST_FINAL_ITEM            C
                 , SCM_MST_SITE                  C1
                 , SCM_ADM_LOOKUP_MASTER_DETAIL  C3
                 , SCM_ADM_LOOKUP_MASTER_DETAIL  C4
                 , SCM_MST_SITE                  D
             /* SCP 대상 ITEM만 */
             WHERE C.ITEM_ID           = A.ITEM_ID
               AND C.DIVISION_ID       = A.DIVISION_ID
               AND C1.SCM_SITE_ID      = A.FROM_SCM_SITE_ID
               AND C1.DIVISION_ID      = A.DIVISION_ID
               /* SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE */
               AND C3.LOOKUP_TYPE(+)   = 'SHIP_RESULT_TO_SITE_MAPPING'
               AND C3.SEGMENT1(+)      = A.DIVISION_ID
               AND C3.SEGMENT2(+)      = A.SOLDTO_CODE
               AND C3.SEGMENT3(+)      = A.SHIPTO_CODE
               AND C4.SEGMENT1(+)      = A.FROM_SCM_SITE_ID
               AND C4.SEGMENT2(+)      = NVL(C3.SEGMENT4, A.TO_SCM_SITE_ID)
               AND C4.SEGMENT3(+)      = A.ITEM_ID
               AND C4.LOOKUP_TYPE(+)   = 'SHIPMENT_REPORT_LOOKUP'
               AND D.DIVISION_ID(+)    = A.DIVISION_ID
               AND D.SCM_SITE_ID(+)    = A.FROM_SCM_SITE_ID
               AND D.OSP_YN(+)         = 'Y'
               AND D.VALID_YN(+)       = 'Y'
               /* D90: DO삭제 , D10:DO생성 */
               AND NVL(A.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')
               AND NVL(A.CONFIRM_ID, '@') NOT LIKE 'C%'
               /* 상품창고제외 */
               AND A.STORAGE_ID NOT IN ('6000', '799A')
               /* 사외 창고 제외 LOOKUP 관리 */
               AND A.STORAGE_ID NOT IN (SELECT SEGMENT1
                                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                         WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
                                           AND VALID_YN    = 'Y')
               /* ERP오더타입 제외 LOOKUP 관리 */
               AND A.ORDER_TYPE_CODE NOT IN (SELECT SEGMENT1
                                               FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                              WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_ERP_ORDER_TYPE'
                                                AND VALID_YN    = 'Y')
               AND A.DIVISION_ID       = V_DIVISION_ID
               AND C.OPERATION_GROUP   = V_BIZ_TYPE
               AND (TRIM(V_FROMSITE) IS NULL
                OR  UPPER(V_FROMSITE) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                OR  A.FROM_SCM_SITE_ID IN (SELECT UPPER(COLUMN_VALUE)
                                             FROM TABLE(STRING_SPLIT(V_FROMSITE, ','))))
               AND (TRIM(V_CELL_TYPE_GR) IS NULL
                OR  UPPER(V_CELL_TYPE_GR) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
                OR  C.CELL_TYPE_GROUP_CODE IN (SELECT UPPER(COLUMN_VALUE)
                                                 FROM TABLE(STRING_SPLIT(V_CELL_TYPE_GR, ','))))
               AND (TRIM(V_ITEM_ID) IS NULL
                OR  UPPER(V_ITEM_ID) = 'ALL'                         /* 조회조건 ALL 은 조건 없음 */
                OR  A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
                                    FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
               AND A.EXFACTORY_DATE   >= V_FROM_RESULT
               AND A.EXFACTORY_DATE    < V_TO_RESULT) IA
     WHERE (TRIM(V_TEAM_ID) IS NULL
        OR  UPPER(V_TEAM_ID) = 'ALL'                                 /* 조회조건 ALL 은 조건 없음 */
        OR  IA.SUI_DEPT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                 FROM TABLE(STRING_SPLIT(V_TEAM_ID, ',')))
        OR  IA.LMD_ATTRIBUTE1 IN (SELECT UPPER(COLUMN_VALUE)
                                    FROM TABLE(STRING_SPLIT(V_TEAM_ID, ','))))
     GROUP BY IA.DIVISION_ID
            , IA.SITE_ID
            , IA.ITEM_ID
            , NVL(IA.SUI_DEPT_ID, IA.LMD_ATTRIBUTE1)
            , IA.SDI_DEPT_NAME_KO
            , IA.LMD_ATTRIBUTE2
            , IA.SMS_SITE_DESCRIPTION
            , IA.YYYYMMDD
            , IA.SITE_NAME
            , IA.EXTRA_SPEC
            , IA.NICK_NAME;

    /* 실적 합계 */
    INSERT INTO GT_SCP0055_RESULT_TOTAL
                ( DIVISION_ID, SITE_ID, SITE_NAME, EXTRA_SPEC, NICK_NAME
                , DEPT_ID, DEPT_NAME, YYYYMMDD, QTY, PLAN_FROM )
    SELECT A.DIVISION_ID
         , A.SITE_ID
         , A.SITE_NAME
         , A.EXTRA_SPEC
         , A.NICK_NAME
         , A.DEPT_ID
         , A.DEPT_NAME
         , A.YYYYMMDD
         , SUM(A.QTY)                                               AS QTY
         , 'RESULT_TOTAL'                                           AS PLAN_FROM
      FROM GT_SCP0055_RESULT A
     WHERE (TRIM(V_NICKNAME) IS NULL
        OR  UPPER(V_NICKNAME) = 'ALL'                               /* 조회조건 ALL 은 조건 없음 */
        OR  A.NICK_NAME IN (SELECT UPPER(COLUMN_VALUE)
                              FROM TABLE(STRING_SPLIT(V_NICKNAME, ','))))
     GROUP BY A.DIVISION_ID
            , A.NICK_NAME
            , A.SITE_ID
            , A.SITE_NAME
            , A.EXTRA_SPEC
            , A.DEPT_ID
            , A.DEPT_NAME
            , A.YYYYMMDD;

    /* 출력 결과 1 : 계획 데이터 */
    OPEN O_RC1 FOR
        SELECT DIVISION_ID
             , SITE_ID
             , SITE_NAME
             , EXTRA_SPEC
             , NICK_NAME
             , DEPT_ID
             , DEPT_NAME
             , YYYYMMDD
             , QTY
             , PLAN_FROM
          FROM GT_SCP0055_PLAN_TOTAL
         /* 원문에 정렬이 없어 화면 순서가 흔들린다 — 묶은 열쇠 순서와 같게 고정 */
         ORDER BY FN_ASIS_SORT_KEY(DIVISION_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(NICK_NAME)   NULLS FIRST
                , FN_ASIS_SORT_KEY(SITE_ID)     NULLS FIRST
                , FN_ASIS_SORT_KEY(SITE_NAME)   NULLS FIRST
                , FN_ASIS_SORT_KEY(EXTRA_SPEC)  NULLS FIRST
                , FN_ASIS_SORT_KEY(DEPT_ID)     NULLS FIRST
                , FN_ASIS_SORT_KEY(DEPT_NAME)   NULLS FIRST
                , FN_ASIS_SORT_KEY(YYYYMMDD)    NULLS FIRST;

    /* 출력 결과 2 : 그리드 생성용 데이터 */
    OPEN O_RC2 FOR
        SELECT IA.DIVISION_ID
             , IA.SITE_ID
             , IA.SITE_NAME
             , IA.EXTRA_SPEC
             , IA.NICK_NAME
             , IA.DEPT_ID
             , IA.DEPT_NAME
          FROM (SELECT DISTINCT DIVISION_ID
                     , SITE_ID
                     , SITE_NAME
                     , EXTRA_SPEC
                     , NICK_NAME
                     , DEPT_ID
                     , DEPT_NAME
                  FROM GT_SCP0055_PLAN_TOTAL
                UNION ALL
                SELECT DISTINCT DIVISION_ID
                     , SITE_ID
                     , SITE_NAME
                     , EXTRA_SPEC
                     , NICK_NAME
                     , DEPT_ID
                     , DEPT_NAME
                  FROM GT_SCP0055_RESULT_TOTAL) IA
         /* 원문은 두 벌을 이어 붙인 뒤 DISTINCT 한다. 순서가 정해져 있지 않아 열쇠 순서로 고정 */
         GROUP BY IA.DIVISION_ID
                , IA.SITE_ID
                , IA.SITE_NAME
                , IA.EXTRA_SPEC
                , IA.NICK_NAME
                , IA.DEPT_ID
                , IA.DEPT_NAME
         ORDER BY FN_ASIS_SORT_KEY(IA.DIVISION_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(IA.SITE_ID)     NULLS FIRST
                , FN_ASIS_SORT_KEY(IA.EXTRA_SPEC)  NULLS FIRST
                , FN_ASIS_SORT_KEY(IA.NICK_NAME)   NULLS FIRST
                , FN_ASIS_SORT_KEY(IA.DEPT_ID)     NULLS FIRST;

    /* 출력 결과 3 : 실적 데이터 */
    OPEN O_RC3 FOR
        SELECT DIVISION_ID
             , SITE_ID
             , SITE_NAME
             , EXTRA_SPEC
             , NICK_NAME
             , DEPT_ID
             , DEPT_NAME
             , YYYYMMDD
             , QTY
             , PLAN_FROM
          FROM GT_SCP0055_RESULT_TOTAL
         /* 원문에 정렬이 없어 화면 순서가 흔들린다 — 묶은 열쇠 순서와 같게 고정 */
         ORDER BY FN_ASIS_SORT_KEY(DIVISION_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(NICK_NAME)   NULLS FIRST
                , FN_ASIS_SORT_KEY(SITE_ID)     NULLS FIRST
                , FN_ASIS_SORT_KEY(SITE_NAME)   NULLS FIRST
                , FN_ASIS_SORT_KEY(EXTRA_SPEC)  NULLS FIRST
                , FN_ASIS_SORT_KEY(DEPT_ID)     NULLS FIRST
                , FN_ASIS_SORT_KEY(DEPT_NAME)   NULLS FIRST
                , FN_ASIS_SORT_KEY(YYYYMMDD)    NULLS FIRST;

    /* 출력 결과 4 : 검색 Plan Type, Seq */
    OPEN O_RC4 FOR
        SELECT V_PLAN_TYPE  AS V_PLAN_TYPE
             , V_SEQ        AS V_SEQ
          FROM DUAL;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0055_GET_SHIPMENT_ALLO_PLAN;

/****************************************************************************************************/
/* Program ID  : P_SCP0055_GET_SHIPMENT_ALLO_NOTE                                                   */
/* Description : 메모 조회                                                                          */
/****************************************************************************************************/
PROCEDURE P_SCP0055_GET_SHIPMENT_ALLO_NOTE
(
    P_SITE_ID               IN  CLOB
  , P_DEPT_ID               IN  CLOB
  , P_NICK_NAME             IN  CLOB
  , P_PLAN_DATE             IN  CLOB
  , P_GAP_DATE              IN  CLOB      /* 원문도 받기만 하고 쓰지 않는다 (조건은 늘 'ALL') */
  , P_USER_ID               IN  CLOB      /* 원문도 받기만 하고 쓰지 않는다 */
  , O_RC1                   OUT SYS_REFCURSOR
  , O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
IS
    V_SITE_ID               VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_SITE_ID,   1, 4000));
    V_DEPT_ID               VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_DEPT_ID,   1, 4000));
    V_NICK_NAME             VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_NICK_NAME, 1, 4000));
    /* 원문이 계획일자를 NVARCHAR(8) 로 받아 8자에서 자른다 */
    V_PLAN_DATE             VARCHAR2(8 CHAR)    := TO_CHAR(SUBSTR(P_PLAN_DATE, 1, 8));
BEGIN

    OPEN O_RC1 FOR
        SELECT NOTE
          FROM SCM_SHIP_ALLO_REPORT
         WHERE SITE_ID   = V_SITE_ID
           AND DEPT_ID   = V_DEPT_ID
           AND NICK_NAME = V_NICK_NAME
           AND PLAN_DATE = V_PLAN_DATE
           AND GAP_DATE  = 'ALL'
           AND VALID     = 'Y';

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0055_GET_SHIPMENT_ALLO_NOTE;

/****************************************************************************************************/
/* Program ID  : P_SCP0055_SAVE_SHIPMENT_ALLO_PLAN                                                  */
/* Description : 메모 저장 — 기존 행을 사용 안 함으로 두고 새 행을 넣는다                          */
/****************************************************************************************************/
PROCEDURE P_SCP0055_SAVE_SHIPMENT_ALLO_PLAN
(
    P_SITE_ID               IN  CLOB
  , P_NICK_NAME             IN  CLOB
  , P_DEPT_ID               IN  CLOB
  , P_PLAN_DATE             IN  CLOB
  , P_GAP_DATE              IN  CLOB      /* 원문도 받기만 하고 쓰지 않는다 (늘 'ALL' 로 넣는다) */
  , P_NOTE                  IN  CLOB
  , P_PROGRAM_ID            IN  CLOB      /* 원문도 받기만 하고 쓰지 않는다 */
  , P_USER_ID               IN  CLOB
  , O_RC1                   OUT SYS_REFCURSOR
  , O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
IS
    /* 화면이 고친 줄 여러 건을 한 번에 보낸다(칸마다 ^ 로 이음) — 옛 화면은 줄마다 한 번씩 불렀다. */ /* AJS 20261007 화면검증 */
    /* 줄마다 나눠 원문과 같은 처리를 되풀이한다. 원래 선언(첫 값 바로 대입)은 아래 주석으로 남긴다 */  /* AJS 20261007 화면검증 */
    /* V_SITE_ID   VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_SITE_ID,   1, 4000)); */
    /* V_NICK_NAME VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_NICK_NAME, 1, 4000)); */
    /* V_DEPT_ID   VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_DEPT_ID,   1, 4000)); */
    /* V_PLAN_DATE VARCHAR2(8 CHAR)    := TO_CHAR(SUBSTR(P_PLAN_DATE, 1, 8));    */
    /* V_NOTE      VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_NOTE,      1, 4000)); */
    /* V_USER_ID   VARCHAR2(30 CHAR)   := TO_CHAR(SUBSTR(P_USER_ID,   1, 30));   */
    C_DELIMITER             CONSTANT VARCHAR2(1 CHAR) := '^';                                        /* AJS 20261007 화면검증 */
    N_MAX_LOOP_CNT          NUMBER(10) := 0;                                                         /* AJS 20261007 화면검증 */
    N_LOOP_CNT              NUMBER(10) := 0;                                                         /* AJS 20261007 화면검증 */
    V_SITE_ID               VARCHAR2(4000 CHAR);                                                     /* AJS 20261007 화면검증 */
    V_NICK_NAME             VARCHAR2(4000 CHAR);                                                     /* AJS 20261007 화면검증 */
    V_DEPT_ID               VARCHAR2(4000 CHAR);                                                     /* AJS 20261007 화면검증 */
    /* 원문이 계획일자를 NVARCHAR(8) 로 받아 8자에서 자른다 */                                                        /* AJS 20261007 화면검증 */
    V_PLAN_DATE             VARCHAR2(8 CHAR);                                                        /* AJS 20261007 화면검증 */
    V_NOTE                  VARCHAR2(4000 CHAR);                                                     /* AJS 20261007 화면검증 */
    /* 원문이 사용자를 NVARCHAR(30) 으로 받아 30자에서 자른다 */                                                      /* AJS 20261007 화면검증 */
    V_USER_ID               VARCHAR2(30 CHAR);                                                       /* AJS 20261007 화면검증 */

    /* ★원장 열쇠에 최초등록일시가 들어 있다. AS-IS 는 1,000분의 1초까지 남아 같은 초에 두 번
          저장해도 열쇠가 갈리지만, 기준 데이터베이스는 초까지만 남아 열쇠가 겹쳐 저장이 막힌다.
          이미 있는 최종 시각보다 한 초 뒤를 확보해 원문과 같이 저장이 되게 한다 */
    V_LAST_INSDTTM          DATE;
    V_INSDTTM               DATE;

    V_SQLERRM               VARCHAR2(4000 CHAR);
BEGIN

    IF P_SITE_ID IS NOT NULL                                                                         /* AJS 20261007 화면검증 */
    THEN                                                                                             /* AJS 20261007 화면검증 */
        N_MAX_LOOP_CNT := TO_NUMBER(SCM_ARR_SPL_CNT(P_SITE_ID, C_DELIMITER));                        /* AJS 20261007 화면검증 */
    END IF;                                                                                          /* AJS 20261007 화면검증 */
                                                                                                     /* AJS 20261007 화면검증 */
    WHILE N_LOOP_CNT < N_MAX_LOOP_CNT                                                                /* AJS 20261007 화면검증 */
    LOOP                                                                                             /* AJS 20261007 화면검증 */
                                                                                                     /* AJS 20261007 화면검증 */
    N_LOOP_CNT  := N_LOOP_CNT + 1;                                                                   /* AJS 20261007 화면검증 */
    V_SITE_ID   := SUBSTR(SCM_ARR_SPL_VAL(P_SITE_ID,   C_DELIMITER, N_LOOP_CNT), 1, 4000);           /* AJS 20261007 화면검증 */
    V_NICK_NAME := SUBSTR(SCM_ARR_SPL_VAL(P_NICK_NAME, C_DELIMITER, N_LOOP_CNT), 1, 4000);           /* AJS 20261007 화면검증 */
    V_DEPT_ID   := SUBSTR(SCM_ARR_SPL_VAL(P_DEPT_ID,   C_DELIMITER, N_LOOP_CNT), 1, 4000);           /* AJS 20261007 화면검증 */
    V_PLAN_DATE := SUBSTR(SCM_ARR_SPL_VAL(P_PLAN_DATE, C_DELIMITER, N_LOOP_CNT), 1, 8);              /* AJS 20261007 화면검증 */
    V_NOTE      := SUBSTR(SCM_ARR_SPL_VAL(P_NOTE,      C_DELIMITER, N_LOOP_CNT), 1, 4000);           /* AJS 20261007 화면검증 */
    V_USER_ID   := SUBSTR(SCM_ARR_SPL_VAL(P_USER_ID,   C_DELIMITER, N_LOOP_CNT), 1, 30);             /* AJS 20261007 화면검증 */

    SELECT NVL(MAX(INSDTTM), SYSDATE - 1)
      INTO V_LAST_INSDTTM
      FROM SCM_SHIP_ALLO_REPORT
     WHERE SITE_ID   = V_SITE_ID
       AND NICK_NAME = V_NICK_NAME
       AND DEPT_ID   = V_DEPT_ID
       AND PLAN_DATE = V_PLAN_DATE
       AND GAP_DATE  = 'ALL';

    V_INSDTTM := GREATEST(SYSDATE, V_LAST_INSDTTM + (1 / 86400));

    /* 기존 정보 백업 */
    UPDATE SCM_SHIP_ALLO_REPORT
       SET VALID     = 'N'
         , UPDDTTM   = SYSDATE
         , UPDUSER   = V_USER_ID
     WHERE SITE_ID   = V_SITE_ID
       AND NICK_NAME = V_NICK_NAME
       AND DEPT_ID   = V_DEPT_ID
       AND PLAN_DATE = V_PLAN_DATE
       AND GAP_DATE  = 'ALL';

    /* 신규 정보 생성 */
    INSERT INTO SCM_SHIP_ALLO_REPORT
                (
                  SITE_ID
                , NICK_NAME
                , DEPT_ID
                , PLAN_DATE
                , GAP_DATE
                , NOTE
                , VALID
                , INSDTTM
                , INSUSER
                )
         VALUES (
                  V_SITE_ID
                , V_NICK_NAME
                , V_DEPT_ID
                , V_PLAN_DATE
                , 'ALL'
                , V_NOTE
                , 'Y'
                , V_INSDTTM
                , V_USER_ID
                );

    END LOOP;                                                                                        /* AJS 20261007 화면검증 */

    COMMIT;

    OPEN O_RC1 FOR
        SELECT 'S'              AS RESULT_CODE
             /* , 1    AS RESULT_CNT */
             , N_MAX_LOOP_CNT   AS RESULT_CNT                                                    /* AJS 20261007 화면검증 */
          FROM DUAL;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_SQLERRM := SQLERRM;

        ROLLBACK;

        OPEN O_RC1 FOR
            SELECT 'F'                          AS RESULT_CODE
                 , SUBSTR(V_SQLERRM, 1, 4000)   AS RESULT_CNT
              FROM DUAL;

        OPEN O_RESULT_CURSOR FOR
            SELECT '1'                          AS RESULT_CODE
                 , SUBSTR(V_SQLERRM, 1, 4000)   AS RESULT_MESSAGE
              FROM DUAL;

END P_SCP0055_SAVE_SHIPMENT_ALLO_PLAN;

END PKG_SCP0055;