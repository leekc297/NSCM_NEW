PACKAGE BODY PKG_SCP0080
IS

    /* 구분자 분리 결과를 담는 컬렉션 (AS-IS UF_FX_String_Split 대응) */
    TYPE T_TOKEN_TAB IS TABLE OF VARCHAR2(4000 CHAR) INDEX BY PLS_INTEGER;


    /* ------------------------------------------------------------
       구분자 분리 (AS-IS dbo.UF_FX_String_Split 와 같은 규칙)
       - 토큰 앞뒤 공백을 떼고 순번은 1 부터
       - 입력이 비어 있어도 빈 토큰 1건을 돌려준다(MSSQL 동작)
       ------------------------------------------------------------ */
    PROCEDURE P_SPLIT_TOKEN
    (
        P_STR       IN  CLOB,
        P_DELIM     IN  VARCHAR2,
        P_TAB       OUT T_TOKEN_TAB
    )
    IS
        V_POS       PLS_INTEGER;
        V_FROM      PLS_INTEGER := 1;
        V_NR        PLS_INTEGER := 0;
        V_LEN       PLS_INTEGER := NVL(DBMS_LOB.GETLENGTH(P_STR), 0);
    BEGIN

        IF V_LEN = 0 THEN
            P_TAB(1) := NULL;
            RETURN;
        END IF;

        LOOP
            V_POS := DBMS_LOB.INSTR(P_STR, P_DELIM, V_FROM, 1);

            EXIT WHEN V_POS = 0 OR V_POS IS NULL;

            V_NR := V_NR + 1;
            P_TAB(V_NR) := TRIM(DBMS_LOB.SUBSTR(P_STR, V_POS - V_FROM, V_FROM));
            V_FROM := V_POS + 1;
        END LOOP;

        V_NR := V_NR + 1;

        IF V_FROM > V_LEN THEN
            P_TAB(V_NR) := NULL;
        ELSE
            P_TAB(V_NR) := TRIM(DBMS_LOB.SUBSTR(P_STR, V_LEN - V_FROM + 1, V_FROM));
        END IF;

    END P_SPLIT_TOKEN;


    /* ------------------------------------------------------------
       AS-IS FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE 본문
       - 단계별로 GTT 에 적재하고 마지막에 GT_0080_GROUP_CODE 를 채운다
       - Program History
         * 2026.10.06   AJS          조회 속도 개선(BOM 체크 조건이 Y 일 때만 GT_0080_BOM_PACK · GT_0080_BOM_CELL 적재)
         * 2026.10.07   AJS          공정 조건 ALL 을 조건 없음으로 처리(AS-IS 빈 값과 같은 의미)
         * 2026.10.07   AJS          [속도2차] 품목 원장 적재(GT_0080_ITEM_ALL)를 조회 사업부 최종품목으로 한정 · 플랜트 · 에너지 적재를 조회 사업부로 한정(연결 재사용 시 임시 테이블 삭제량 축소)
         * 2026.10.07   AJS          [속도2차] BOM 체크 Y : GT_0080_BOM_PACK · GT_0080_BOM_CELL 을 SCM_MST_MODEL_FINAL_ITEM_BOM_V 한 번 읽기로 함께 적재(INSERT ALL)
     * 2026.10.08   AJS          조회조건 Model/Nickname : 입력값(쉼표 여러 개)이 코드 또는 닉네임에 부분일치 · 대소문자 무시 · ALL 은 조건 없음
       ------------------------------------------------------------ */
    PROCEDURE P_LOAD_GROUP_CODE
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_ID          IN  VARCHAR2,
        P_MODEL_ID              IN  VARCHAR2,
        P_NICKNAME              IN  VARCHAR2,
        P_CHECK_FCST            IN  VARCHAR2,
        P_CHECK_PRODUCTION      IN  VARCHAR2,
        P_CHECK_ACTIVE          IN  VARCHAR2,
        P_CHECK_BOM             IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2
    )
    IS
        /* NERP 매핑코드 [HQ00] = C100 */
        V_ESOC                  VARCHAR2(8 CHAR);
        V_BASIS_START_DATE      VARCHAR2(16 CHAR);
    BEGIN

        /* GTT 초기화 - TRUNCATE 는 암묵적 커밋이라 쓰지 않는다 */
        DELETE  GT_0080_ITEM_ALL;
        DELETE  GT_0080_ITEM_ACTIVE;
        DELETE  GT_0080_PLANT;
        DELETE  GT_0080_ENERGE;
        DELETE  GT_0080_CELL_CF_KD;
        DELETE  GT_0080_BOM_PACK;
        DELETE  GT_0080_BOM_CELL;
        DELETE  GT_0080_TEMP;
        DELETE  GT_0080_PRE;
        DELETE  GT_0080_ALL;
        DELETE  GT_0080_GROUP_CODE;

        V_ESOC := FN_GET_LOOKUP_VALUE('FN_SCP0080_GET_GROUP_CODE_MANAGEMENT', 'ESOC');

        /* AS-IS @TblGroupCode_SP0080_MASS (과거 3개월 판매이력) 는 채우기만 하고            */
        /* 최종 조인이 주석 처리돼 결과에 쓰이지 않으므로 옮기지 않는다.                      */

        /* @TblGroupCode_SP0080_ITEM_ALL */
        INSERT INTO GT_0080_ITEM_ALL
                  (
                    DIVISION_ID
                  , ITEM_ID
                  , STATUS_NEW
                  , ACTIVE_FLAG
                  , INSERT_TIME
                  , SCP_EXTRA_SPEC
                  )
        SELECT DISTINCT
                  DIVISION_ID
                , ITEM_ID
                , 'Y'                       AS STATUS_NEW
                , ACTIVE_FLAG
                , INSERT_TIME
                , SCP_EXTRA_SPEC            /* 40 : Product level2 */
--        FROM    SCM_MST_ITEM_SN
        FROM    SCM_MST_ITEM_SN A /* AJS 20261007 속도 */
        WHERE   1=1
            AND EXISTS (SELECT /*+ HASH_SJ */ 1 /* AJS 20261007 속도 */
                        FROM    SCP_MST_FINAL_ITEM XA /* AJS 20261007 속도 */
                        WHERE   XA.DIVISION_ID = A.DIVISION_ID /* AJS 20261007 속도 */
                            AND XA.ITEM_ID     = A.ITEM_ID) /* AJS 20261007 속도 */
--            AND DIVISION_ID = P_DIVISION_ID;
            AND A.DIVISION_ID = P_DIVISION_ID; /* AJS 20261007 속도 */

        /* 뒤 단계가 되풀이해 읽으므로 통계를 잡아 둔다 (CNS 전환가이드 7항)                          */
        /* ※ 소유자 자리에 USER 를 쓰면 안 된다. USER 는 패키지 소유자가 아니라 부른 계정을 돌려주므로 */
        /*    화면 계정(SCMP_APP)이 부르면 "SCMP_APP"."GT_0080_..." 를 찾다 ORA-20000 으로 끝난다.    */
        /*    $$PLSQL_UNIT_OWNER 는 이 패키지를 소유한 스키마를 준다.                                  */
        DBMS_STATS.GATHER_TABLE_STATS($$PLSQL_UNIT_OWNER, 'GT_0080_ITEM_ALL', NO_INVALIDATE => FALSE);

        /* @TblGroupCode_SP0080_ITEM_ACTIVE                                                   */
        /* ITEM 별 Plant 가 여럿이면 ACTIVE_FLAG 가 Y·N 두 벌이므로 Y 를 먼저 고른다          */
        INSERT INTO GT_0080_ITEM_ACTIVE
                  (
                    DIVISION_ID
                  , ITEM_ID
                  , ACTIVE_FLAG
                  )
        SELECT    A.DIVISION_ID
                , A.ITEM_ID
                , A.ACTIVE_FLAG
        FROM    (
                    SELECT    IA.DIVISION_ID
                            , IA.ITEM_ID
                            , IA.ACTIVE_FLAG
                    FROM    (
                                SELECT    DIVISION_ID
                                        , ITEM_ID
                                        , ACTIVE_FLAG
                                        , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, ITEM_ID ORDER BY CASE WHEN ACTIVE_FLAG = 'Y' THEN 1 ELSE 2 END ASC) AS RN
                                FROM    GT_0080_ITEM_ALL
                            ) IA
                    WHERE   1=1
                        AND IA.RN = 1
                ) A
        GROUP BY  A.DIVISION_ID
                , A.ITEM_ID
                , A.ACTIVE_FLAG;

        /* @TblGroupCode_SP0080_PLANT */
        INSERT INTO GT_0080_PLANT
                  (
                    DIVISION_ID
                  , ITEM_ID
                  , OPERATION_GROUP
                  , PLANT_ID
                  , PLANT_NAME
                  , RN
                  )
        SELECT    A.DIVISION_ID
                , A.ITEM_ID
                , A.OPERATION_GROUP
                , A.PLANT_ID
                , A.PLANT_NAME
                , A.RN
        FROM    (
                    SELECT    P.DIVISION_ID
                            , P.ITEM_ID
                            , S.OPERATION_GROUP
                            , S.PLANT_ID
                            , CASE
                                WHEN S.OPERATION_GROUP = 'W' THEN S.PLANT_ID
                                WHEN N.PLANT_NAME IS NULL    THEN V.VENDOR_NAME
                                ELSE N.PLANT_NAME
                              END AS PLANT_NAME
                            , ROW_NUMBER() OVER (PARTITION BY P.DIVISION_ID, P.ITEM_ID, S.OPERATION_GROUP ORDER BY S.PLANT_ID) AS RN
                    FROM      SCM_MST_SITE_ITEM_PRIORITY P
                            , SCM_MST_SITE S
                            , SCM_MST_PLANT_SN N
                            , SCM_MST_VENDOR V
                    WHERE   P.DIVISION_ID   = S.DIVISION_ID
                        AND P.PLANT_SITE_ID = S.SCM_SITE_ID
                        AND S.COMPANY_ID    = N.COMPANY_ID(+)
                        AND S.PLANT_ID      = N.PLANT_ID(+)
                        AND S.DIVISION_ID   = P.DIVISION_ID
                        AND V.VENDOR_CODE(+)= S.PLANT_ID
                        AND S.COMPANY_ID    = V.COMPANY_ID(+)
                        AND P.PRIORITY      = 1
                        AND P.VALID_YN      = 'Y'
                        AND S.SITE_TYPE     = 'PLANT'
                        AND S.VALID_YN      = 'Y'
                        AND TO_CHAR(SYSDATE, 'YYYYMMDD') BETWEEN P.FROM_YYYYMMDD AND P.TO_YYYYMMDD
                        AND P.DIVISION_ID   = P_DIVISION_ID /* AJS 20261007 속도 */
                ) A
        WHERE   A.RN = 1;

        /* @TblGroupCode_SP0080_ENERGE */
        INSERT INTO GT_0080_ENERGE
                  (
                    DIVISION_ID
                  , SITE_ID
                  , ITEM_ID
                  , ENERGE
                  )
        SELECT    DIVISION_ID
                , SITE_ID
                , ITEM_ID
                , ENERGE
        FROM    SCM_MST_ITEM_SN
        WHERE   1=1
            AND DIVISION_ID IN ('82', '40')
            AND COMPANY_ID = V_ESOC
            AND DIVISION_ID = P_DIVISION_ID /* AJS 20261007 속도 */
            AND RTRIM(ENERGE) IS NOT NULL;  /* AS-IS 의 ENERGE IS NOT NULL AND ENERGE <> '' - Oracle 은 빈 문자가 NULL 이라 공백만인 값까지 RTRIM 으로 거른다 */

        /* @TblDynamicPivot_SCP0080_CELL_CF_KD (평가감 CELL_CF) */
        INSERT INTO GT_0080_CELL_CF_KD
                  (
                    ITEM_ID
                  , CELL_CF
                  )
        SELECT    A.ITEM_ID
                , TO_CHAR(TO_NUMBER(NVL(B.CELL_CF, '1.0') DEFAULT NULL ON CONVERSION ERROR), 'FM9999999999999999990.0000000000') AS CELL_CF
        FROM    (
                    SELECT    DIVISION_ID
                            , ITEM_ID
                            , CASE
                                WHEN SUBSTR(ITEM_ID, -2) IN ('-A', '-B', '-C', '-D', '-E', '-F', '-G', '-H', '-I', '-J', '-K', '-R') THEN SUBSTR(ITEM_ID, 1, LENGTH(RTRIM(ITEM_ID)) - 2)
                                WHEN SUBSTR(ITEM_ID, -3) IN ('-GG', '-GK')                                                          THEN SUBSTR(ITEM_ID, 1, LENGTH(RTRIM(ITEM_ID)) - 3)
                              END AS BASIC_ITEM_ID
                    FROM    SCP_MST_FINAL_ITEM
                    WHERE   1=1
                        AND (SUBSTR(ITEM_ID, -2) IN ('-A', '-B', '-C', '-D', '-E', '-F', '-G', '-H', '-I', '-J', '-K', '-R')
                          OR SUBSTR(ITEM_ID, -3) IN ('-GG', '-GK'))
                ) A
                , SCP_MST_ITEM_CELL_CF B
        WHERE   A.BASIC_ITEM_ID = B.ITEM_ID(+);

        /* @TblGroupCode_SP0080_Temp */
        INSERT INTO GT_0080_TEMP
                  (
                    DIVISION_ID
                  , OPERATION_ID
                  , ITEM_ID
                  , NICK_NAME
                  , BASIC_MODEL_PACK
                  , BASIC_NICKNAME_PACK
                  , CELL_MODEL
                  , CELL_MODEL_NICKNAME
                  , BASIC_MODEL_CELL
                  , BASIC_NICKNAME_CELL
                  , GROUP_CODE1
                  , GROUP_CODE2
                  , GROUP_CODE3
                  , GROUP_CODE4
                  , GROUP_CODE5
                  , GROUP_CODE6
                  , GROUP_CODE7
                  , GROUP_CODE8
                  , GROUP_CODE9
                  , GROUP_CODE10
                  , FCST_YN
                  , PIC_ID
                  , PIC_NAME
                  , ATTRIBUTE7
                  , ATTRIBUTE8
                  , ATTRIBUTE9
                  , ATTRIBUTE10
                  , ATTRIBUTE11
                  , ATTRIBUTE12
                  , ATTRIBUTE13
                  , ATTRIBUTE14
                  , ATTRIBUTE15
                  , SALES_MODEL
                  , SALES_VALID_YN
                  , SALES_PRIORITY
                  , SALES_FROM_YYYYMMDD
                  , SALES_TO_YYYYMMDD
                  , LEVEL1_GROUP
                  , LEVEL2_CODE
                  , STATUS_PROTOTYPE
                  , STATUS_NEW
                  , CELL_CF
                  , BASIC_END_CUSTOMER
                  , BASIC_FINISHED_PRODUCT
                  , OPERATION_GROUP
                  , BIZ_TYPE
                  , MODEL_TYPE_CODE
                  , LEVEL_EXCEPT
                  , MKT_DEPT
                  , REMARK
                  , PLANT_ID
                  , PLANT_NAME
                  , ENERGE
                  , FLOW_TYPE
                  , ITEM_ID_ASSY
                  , REPLACEMENT
                  , CATHODE_CODE
                  )
        SELECT    A.DIVISION_ID
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.NICK_NAME
                , A.BASIC_MODEL_PACK
                , A.BASIC_NICKNAME_PACK
                , A.CELL_MODEL
                , A.CELL_MODEL_NICKNAME
                , A.BASIC_MODEL_CELL
                , A.BASIC_NICKNAME_CELL
                , A.GROUP_CODE1
                , A.GROUP_CODE2
                , A.GROUP_CODE3
                , A.GROUP_CODE4
                , A.GROUP_CODE5
                , A.GROUP_CODE6
                , A.GROUP_CODE7
                , A.GROUP_CODE8
                , A.GROUP_CODE9
                , A.GROUP_CODE10
                , A.FCST_YN
                , A.PIC_ID
                , A.PIC_NAME
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
                , A.ATTRIBUTE11
                , A.ATTRIBUTE12
                , A.ATTRIBUTE13
                , A.ATTRIBUTE14
                , A.ATTRIBUTE15
                , A.SALES_MODEL
                , A.SALES_VALID_YN
                , A.SALES_PRIORITY
                , A.SALES_FROM_YYYYMMDD
                , A.SALES_TO_YYYYMMDD
                , A.LEVEL1_GROUP
                , A.LEVEL2_CODE
                , A.STATUS_PROTOTYPE
                , A.STATUS_NEW
                , A.CELL_CF
                , A.BASIC_END_CUSTOMER
                , A.BASIC_FINISHED_PRODUCT
                , A.OPERATION_GROUP
                , A.BIZ_TYPE
                , A.MODEL_TYPE_CODE
                , A.LEVEL_EXCEPT
                , A.MKT_DEPT
                , A.REMARK
                , A.PLANT_ID
                , A.PLANT_NAME
                , A.ENERGE
                , A.FLOW_TYPE
                , A.ITEM_ID_ASSY
                , A.REPLACEMENT
                , SUBSTR(A.BASIC_MODEL_CELL, 8, 2)  AS CATHODE_CODE
        FROM    (
                    SELECT    A.DIVISION_ID
                            , A.FLOW_ID         AS OPERATION_ID
                            , A.ITEM_ID
                            , A.NICK_NAME
                            , CASE
                                WHEN A.OPERATION_GROUP = 'P' THEN (SELECT SA.DOE FROM SCM_MST_ITEM_SN SA WHERE SA.DIVISION_ID = A.DIVISION_ID AND SA.ITEM_ID = A.ITEM_ID AND SA.DOE IS NOT NULL AND ROWNUM = 1)
                                ELSE ''
                              END                       AS BASIC_MODEL_PACK
                            , CASE
                                WHEN A.OPERATION_GROUP = 'P' THEN (SELECT SB.NICK_NAME FROM SCP_MST_FINAL_ITEM SB WHERE SB.DIVISION_ID = A.DIVISION_ID AND SB.ITEM_ID = (SELECT SC.DOE FROM SCM_MST_ITEM_SN SC WHERE SC.DIVISION_ID = A.DIVISION_ID AND SC.ITEM_ID = A.ITEM_ID AND SC.DOE IS NOT NULL AND ROWNUM = 1))
                                ELSE ''
                              END                       AS BASIC_NICKNAME_PACK
                            , CASE
                                /* [PJ20257329] 2025.08.01  변경전 WHEN A.FLOW_ID IN ('A3000', 'A9000', 'F6200', 'F7000', 'F7100', 'F7200', 'F7300') THEN A.ITEM_ID */
                                WHEN CA.OPERATION_ID IS NOT NULL THEN A.ITEM_ID  /* [PJ20257329] 2025.08.01 Cell 계획 공정 하드코딩 변경 */
                                ELSE
                                  CASE
                                    WHEN A.OPERATION_GROUP = 'P' THEN A.ATTRIBUTE1
                                    ELSE ''
                                  END
                              END AS CELL_MODEL
                            , CASE
                                /* [PJ20257329] 2025.08.01  변경전 WHEN A.FLOW_ID IN ('A3000', 'A9000', 'F6200', 'F7000', 'F7100', 'F7200', 'F7300') THEN A.NICK_NAME */
                                WHEN CA.OPERATION_ID IS NOT NULL THEN A.NICK_NAME  /* [PJ20257329] 2025.08.01 Cell 계획 공정 하드코딩 변경 */
                                ELSE
                                  CASE
                                    WHEN A.OPERATION_GROUP = 'P' THEN (SELECT SD.NICK_NAME FROM SCP_MST_FINAL_ITEM SD WHERE SD.DIVISION_ID = A.DIVISION_ID AND SD.ITEM_ID = A.ATTRIBUTE1)
                                    ELSE ''
                                  END
                              END AS CELL_MODEL_NICKNAME
                            , CASE
                                WHEN A.OPERATION_GROUP = 'P' THEN (SELECT SE.DOE FROM SCM_MST_ITEM_SN SE WHERE SE.DIVISION_ID = A.DIVISION_ID AND SE.ITEM_ID = A.ATTRIBUTE1 AND SE.DOE IS NOT NULL AND ROWNUM = 1)
                                ELSE (SELECT SF.DOE FROM SCM_MST_ITEM_SN SF WHERE SF.DIVISION_ID = A.DIVISION_ID AND SF.ITEM_ID = A.ITEM_ID AND SF.DOE IS NOT NULL AND ROWNUM = 1)
                              END                       AS BASIC_MODEL_CELL
                            , CASE
                                WHEN A.OPERATION_GROUP = 'P' THEN (SELECT SG.NICK_NAME FROM SCP_MST_FINAL_ITEM SG WHERE SG.DIVISION_ID = A.DIVISION_ID AND SG.ITEM_ID = (SELECT SH.DOE FROM SCM_MST_ITEM_SN SH WHERE SH.DIVISION_ID = A.DIVISION_ID AND SH.ITEM_ID = A.ATTRIBUTE1 AND SH.DOE IS NOT NULL AND ROWNUM = 1))
                                ELSE (SELECT SI.NICK_NAME FROM SCP_MST_FINAL_ITEM SI WHERE SI.DIVISION_ID = A.DIVISION_ID AND SI.ITEM_ID = (SELECT SJ.DOE FROM SCM_MST_ITEM_SN SJ WHERE SJ.DIVISION_ID = A.DIVISION_ID AND SJ.ITEM_ID = A.ITEM_ID AND SJ.DOE IS NOT NULL AND ROWNUM = 1))
                              END                       AS BASIC_NICKNAME_CELL
                            , A.GROUP_CODE1
                            , A.GROUP_CODE2
                            , A.GROUP_CODE3
                            , A.GROUP_CODE4
                            , A.GROUP_CODE5
                            , A.GROUP_CODE6
                            , A.GROUP_CODE7
                            , A.GROUP_CODE8
                            , A.GROUP_CODE9
                            , A.GROUP_CODE10
                            , NVL(A.FCST_YN, 'N')       AS FCST_YN
                            , A.ATTRIBUTE6              AS PIC_ID
                            , UI.USER_NAME              AS PIC_NAME
                            , A.ATTRIBUTE7
                            , A.ATTRIBUTE8
                            , A.ATTRIBUTE9
                            , A.ATTRIBUTE10
                            , A.ATTRIBUTE11
                            , A.ATTRIBUTE12
                            , A.ATTRIBUTE13
                            , A.ATTRIBUTE14
                            , A.ATTRIBUTE15
                            , A.SALES_MODEL
                            , A.SALES_VALID_YN
                            , A.SALES_PRIORITY
                            , A.SALES_FROM_YYYYMMDD
                            , A.SALES_TO_YYYYMMDD
                            , CASE
                                /* [PJ20257329] 2025.08.01  변경전 WHEN A.FLOW_ID = 'A9000' THEN A.GROUP_CODE1 */
                                WHEN CO.OPERATION_ID IS NOT NULL                                         THEN A.GROUP_CODE1  /* [PJ20257329] 2025.08.01 Cell 완성 공정 하드 코딩 조건 변경 */
                                WHEN A.FLOW_ID = 'P5000' OR A.FLOW_ID = 'P5500' OR A.FLOW_ID = 'P9500'   THEN A.GROUP_CODE2
                              END                       AS LEVEL1_GROUP
                            , A.LEVEL2_CODE
                            , CASE WHEN C.STATUS_NEW = 'Y' AND RTRIM(A.STATUS_PROTOTYPE) IS NOT NULL THEN 'Y' ELSE A.STATUS_PROTOTYPE END AS STATUS_PROTOTYPE  /* AS-IS 의 ISNULL(STATUS_PROTOTYPE,'') <> '' */
                            , C.STATUS_NEW
                            , TO_CHAR(ROUND(
                                  CASE
                                    WHEN SUBSTR(A.ITEM_ID, -2) IN ('-D', '-K') THEN TO_NUMBER(F.CELL_CF DEFAULT NULL ON CONVERSION ERROR)
                                    ELSE
                                        CASE
                                        /* [PJ20257329] 2025.08.01  변경전 WHEN A.FLOW_ID IN ('A3000', 'A9000') THEN */
                                        WHEN CO.OPERATION_ID IS NOT NULL  THEN   /* [PJ20257329] 2025.08.01 Cell 완성 공정 하드 코딩 조건 변경 */
                                            CASE
                                                WHEN NVL(A.CELL_CF, '0') = '0' THEN 1
                                                ELSE TO_NUMBER(A.CELL_CF DEFAULT NULL ON CONVERSION ERROR)
                                            END
                                        ELSE TO_NUMBER(A.CELL_CF DEFAULT NULL ON CONVERSION ERROR)
                                        END
                                  END
                              , 0))                     AS CELL_CF
                            , A.END_CUSTOMER            AS BASIC_END_CUSTOMER
                            , A.FINISHED_PRODUCT        AS BASIC_FINISHED_PRODUCT
                            , A.OPERATION_GROUP
                            , CASE
                                /* [PJ20257329] 2025.08.01  변경전 WHEN A.FLOW_ID = 'A9000'    THEN 'Cell' */
                                WHEN CO.OPERATION_ID IS NOT NULL    THEN 'Cell'  /* [PJ20257329] 2025.08.01 Cell 완성 공정 하드 코딩 조건 변경 */
                                WHEN A.FLOW_ID = 'P5500'            THEN 'Module'
                                WHEN A.FLOW_ID = 'P9500'            THEN 'Pack'
                                ELSE                             ''  /* P5000 */
                              END AS BIZ_TYPE
                            , SUBSTR(A.ITEM_ID, 2, 1)   AS MODEL_TYPE_CODE
                            , SUBSTR(A.ITEM_ID, 1, 2)   AS LEVEL_EXCEPT  /* 예외적용 */
                            , A.MKT_DEPT
                            , A.REMARK
                            , D.PLANT_ID
                            , D.PLANT_NAME
                            , E.ENERGE
                            , CASE
                                /* [PJ20257329] 2025.08.01  변경전 WHEN A.FLOW_ID IN ('A3000', 'A9000') THEN 'C' */
                                WHEN CO.OPERATION_ID IS NOT NULL THEN 'C'    /* [PJ20257329] 2025.08.01 Cell 완성 공정 하드 코딩 조건 변경 */
                                ELSE 'E'
                              END AS FLOW_TYPE
                            , M.ITEM_ID_ASSY
                            , A.REPLACEMENT
                    FROM      SCP_MST_FINAL_ITEM A
                              /* [PJ20257329] 2025.08.01 Cell 공정 하드 코딩 조건 변경 - Start */
                            , (
                                SELECT DISTINCT SEGMENT1 AS OPERATION_ID
                                FROM    SCM_ADM_LOOKUP_MASTER_DETAIL
                                WHERE   1=1
                                    AND LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                                    AND SEGMENT3    = 'A'   /* 공정그룹 (Cell) */
                                    AND VALID_YN    = 'Y'   /* SCP 계획 공정 */
                              ) CA
                            , (
                                SELECT DISTINCT SEGMENT1 AS OPERATION_ID
                                FROM    SCM_ADM_LOOKUP_MASTER_DETAIL
                                WHERE   1=1
                                    AND LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                                    AND SEGMENT3    = 'A'   /* 공정그룹 (Cell) */
                                    AND ATTRIBUTE1  = 'Y'   /* FInal Operation */
                              ) CO
                              /* [PJ20257329] 2025.08.01 Cell 공정 하드 코딩 조건 변경 - End */
                            , (
                                SELECT DISTINCT
                                          DIVISION_ID
                                        , ITEM_ID
                                        , STATUS_NEW
                                FROM    GT_0080_ITEM_ALL
                                WHERE   1=1
                                    AND INSERT_TIME > SYSDATE - 21  /* 신규 Item ID 발번되어 I/F된지 3주 이내 아이템 */
                              ) C
                            , GT_0080_PLANT D
                            , GT_0080_ENERGE E
                            , GT_0080_CELL_CF_KD F
                            , SCM_MST_SSO_USER_INFO UI
                            , (
                                SELECT    DIVISION_ID
                                        , ITEM_ID_PROD
                                        , MIN(ITEM_ID_ASSY) AS ITEM_ID_ASSY
                                FROM    SCP_MST_CELL_PROD_ASSY_MAP
                                WHERE   1=1
                                    AND VALID_YN = 'Y'
                                    AND CELL_TYPE = 'CA1'
                                GROUP BY  DIVISION_ID
                                        , ITEM_ID_PROD
                              ) M
                    WHERE   CA.OPERATION_ID(+)  = A.FLOW_ID
                        AND CO.OPERATION_ID(+)  = A.FLOW_ID
                        AND A.DIVISION_ID       = C.DIVISION_ID(+)
                        AND A.ITEM_ID           = C.ITEM_ID(+)
                        AND A.DIVISION_ID       = D.DIVISION_ID(+)
                        AND A.ITEM_ID           = D.ITEM_ID(+)
                        AND A.DIVISION_ID       = E.DIVISION_ID(+)
                        AND A.ITEM_ID           = E.ITEM_ID(+)
                        AND A.ITEM_ID           = F.ITEM_ID(+)
                        AND A.ATTRIBUTE6        = UI.USER_ID(+)
                        AND A.DIVISION_ID       = M.DIVISION_ID(+)
                        AND A.ITEM_ID           = M.ITEM_ID_PROD(+)
                        AND (A.ATTRIBUTE8 IS NULL OR SUBSTR(A.ATTRIBUTE8, 1, 2) <> 'CA')   /* 활성화코드 분리 */
                        AND A.OPERATION_GROUP IN ('A', 'P')
                        AND A.DIVISION_ID = P_DIVISION_ID
                        /* AS-IS 는 대소문자를 가리지 않는 정렬규칙(CI)이라 소문자로 넣어도 찾는다.                   */
                        /* 원장 3칸(FLOW_ID · ITEM_ID · NICK_NAME)은 실측상 소문자가 한 건도 없으므로                */
                        /* 넘어온 값만 대문자로 맞춘다. 칸에 함수를 걸지 않아 인덱스도 그대로 쓴다.                    */
--                      AND (P_OPERATION_ID IS NULL OR A.FLOW_ID   IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(UPPER(P_OPERATION_ID), ','))))   --  2026.10.07 AJS
                        AND (P_OPERATION_ID IS NULL OR UPPER(TRIM(P_OPERATION_ID)) = 'ALL' OR A.FLOW_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(UPPER(P_OPERATION_ID), ','))))   --  2026.10.07 AJS
--                      AND (P_MODEL_ID     IS NULL OR A.ITEM_ID   IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(UPPER(P_MODEL_ID), ','))))   --  2026.10.08 AJS
                        /* 2026.10.08 AJS Model/Nickname 검색 (START) : 닉네임 칸이 비면 Model 칸 값을 코드 또는 닉네임으로 부분일치(두 칸 모두 있으면 각각 부분일치) · ALL 은 조건 없음 */
                        AND (   P_MODEL_ID IS NULL
                             OR UPPER(TRIM(P_MODEL_ID)) = 'ALL'
                             OR EXISTS (SELECT 1
                                          FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')) SA
                                         WHERE TRIM(SA.COLUMN_VALUE) IS NOT NULL
                                           AND (   UPPER(A.ITEM_ID) LIKE '%' || UPPER(TRIM(SA.COLUMN_VALUE)) || '%'
                                                OR (    P_NICKNAME IS NULL
                                                    AND UPPER(A.NICK_NAME) LIKE '%' || UPPER(TRIM(SA.COLUMN_VALUE)) || '%'))))
--                      AND (P_NICKNAME     IS NULL OR A.NICK_NAME IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(UPPER(P_NICKNAME), ','))))   --  2026.10.08 AJS
                        AND (   P_NICKNAME IS NULL
                             OR UPPER(TRIM(P_NICKNAME)) = 'ALL'
                             OR EXISTS (SELECT 1
                                          FROM TABLE(STRING_SPLIT(P_NICKNAME, ',')) XA
                                         WHERE TRIM(XA.COLUMN_VALUE) IS NOT NULL
                                           AND UPPER(A.NICK_NAME) LIKE '%' || UPPER(TRIM(XA.COLUMN_VALUE)) || '%'))
                        /* 2026.10.08 AJS Model/Nickname 검색 (END) */
                ) A;

        DBMS_STATS.GATHER_TABLE_STATS($$PLSQL_UNIT_OWNER, 'GT_0080_TEMP', NO_INVALIDATE => FALSE);

        /* @TblGroupCode_SP0080_Pre */
        INSERT INTO GT_0080_PRE
                  (
                    DIVISION_ID
                  , OPERATION_ID
                  , ITEM_ID
                  , NICK_NAME
                  , BASIC_MODEL_PACK
                  , BASIC_NICKNAME_PACK
                  , CELL_MODEL
                  , CELL_MODEL_NICKNAME
                  , BASIC_MODEL_CELL
                  , BASIC_NICKNAME_CELL
                  , GROUP_CODE1
                  , GROUP_CODE2
                  , GROUP_CODE3
                  , GROUP_CODE4
                  , GROUP_CODE5
                  , GROUP_CODE6
                  , GROUP_CODE7
                  , GROUP_CODE8
                  , GROUP_CODE9
                  , GROUP_CODE10
                  , FCST_YN
                  , PIC_ID
                  , PIC_NAME
                  , ATTRIBUTE7
                  , ATTRIBUTE8
                  , ATTRIBUTE9
                  , ATTRIBUTE10
                  , ATTRIBUTE11
                  , ATTRIBUTE12
                  , ATTRIBUTE13
                  , ATTRIBUTE14
                  , ATTRIBUTE15
                  , SALES_MODEL
                  , SALES_VALID_YN
                  , SALES_PRIORITY
                  , SALES_FROM_YYYYMMDD
                  , SALES_TO_YYYYMMDD
                  , LEVEL1_GROUP
                  , LEVEL2_CODE
                  , STATUS_PROTOTYPE
                  , STATUS_NEW
                  , CELL_CF
                  , BASIC_END_CUSTOMER
                  , BASIC_FINISHED_PRODUCT
                  , OPERATION_GROUP
                  , BIZ_TYPE
                  , MODEL_TYPE_CODE
                  , LEVEL_EXCEPT
                  , MKT_DEPT
                  , REMARK
                  , PLANT_ID
                  , PLANT_NAME
                  , ENERGE
                  , FLOW_TYPE
                  , ITEM_ID_ASSY
                  , REPLACEMENT
                  , CATHODE_CODE
                  , BASIC_APPLICATION
                  , BASIC_CELL_TYPE
                  , BASIC_CELL_CAPACITY_CHAR
                  , CATHODE_NAME
                  , CELL_TYPE_CODE
                  , NICKNAME_40
                  , MODEL_TYPE_NAME_82
                  , MODEL_TYPE_NAME_40
                  , SCP_EXTRA_SPEC
                  , BASIC_NICKNAME_CELL40
                  )
        SELECT    T.DIVISION_ID
                , T.OPERATION_ID
                , T.ITEM_ID
                , T.NICK_NAME
                , T.BASIC_MODEL_PACK
                , T.BASIC_NICKNAME_PACK
                , T.CELL_MODEL
                , T.CELL_MODEL_NICKNAME
                , T.BASIC_MODEL_CELL
                , T.BASIC_NICKNAME_CELL
                , T.GROUP_CODE1
                , T.GROUP_CODE2
                , T.GROUP_CODE3
                , T.GROUP_CODE4
                , T.GROUP_CODE5
                , T.GROUP_CODE6
                , T.GROUP_CODE7
                , T.GROUP_CODE8
                , T.GROUP_CODE9
                , T.GROUP_CODE10
                , T.FCST_YN
                , T.PIC_ID
                , T.PIC_NAME
                , T.ATTRIBUTE7
                , T.ATTRIBUTE8
                , T.ATTRIBUTE9
                , T.ATTRIBUTE10
                , T.ATTRIBUTE11
                , T.ATTRIBUTE12
                , T.ATTRIBUTE13
                , T.ATTRIBUTE14
                , T.ATTRIBUTE15
                , T.SALES_MODEL
                , T.SALES_VALID_YN
                , T.SALES_PRIORITY
                , T.SALES_FROM_YYYYMMDD
                , T.SALES_TO_YYYYMMDD
                , T.LEVEL1_GROUP
                , T.LEVEL2_CODE
                , T.STATUS_PROTOTYPE
                , T.STATUS_NEW
                , T.CELL_CF
                , T.BASIC_END_CUSTOMER
                , T.BASIC_FINISHED_PRODUCT
                , T.OPERATION_GROUP
                , T.BIZ_TYPE
                , T.MODEL_TYPE_CODE
                , T.LEVEL_EXCEPT
                , T.MKT_DEPT
                , T.REMARK
                , T.PLANT_ID
                , T.PLANT_NAME
                , T.ENERGE
                , T.FLOW_TYPE
                , T.ITEM_ID_ASSY
                , T.REPLACEMENT
                , T.CATHODE_CODE
                , CASE
                    WHEN RTRIM(T.BASIC_MODEL_CELL) IS NOT NULL THEN SUBSTR(T.BASIC_MODEL_CELL, 3, 1)
                    ELSE T.BASIC_MODEL_CELL
                  END AS BASIC_APPLICATION  /* AS-IS 의 IS NOT NULL AND <> '' */
                , CASE
                    WHEN RTRIM(T.BASIC_MODEL_CELL) IS NOT NULL THEN SUBSTR(T.BASIC_MODEL_CELL, 4, 2)
                    ELSE T.BASIC_MODEL_CELL
                  END AS BASIC_CELL_TYPE
                , CASE
                    WHEN SUBSTR(T.BASIC_MODEL_CELL, 1, 2) = 'EC' THEN SUBSTR(T.BASIC_MODEL_CELL, 4, 4)
                    ELSE                                              SUBSTR(T.BASIC_MODEL_CELL, 6, 3)
                  END AS BASIC_CELL_CAPACITY_CHAR
                , H.NAME AS CATHODE_NAME
                , SUBSTR(T.ITEM_ID, 3, 1) AS CELL_TYPE_CODE
                , T.NICK_NAME AS NICKNAME_40
                , E.NAME AS MODEL_TYPE_NAME_82
                , S.NAME AS MODEL_TYPE_NAME_40
                , CASE
                    WHEN T.LEVEL_EXCEPT = 'EC' THEN 'ESS'
                    WHEN T.LEVEL_EXCEPT = 'AM' THEN '21700'
                    ELSE X.SCP_EXTRA_SPEC
                  END AS SCP_EXTRA_SPEC
                , CASE
                    WHEN T.LEVEL_EXCEPT = 'EC' THEN 'ESS'
                    WHEN T.LEVEL_EXCEPT = 'AM' THEN 'M50L'
                    ELSE T.BASIC_NICKNAME_CELL
                  END AS BASIC_NICKNAME_CELL40
        FROM      GT_0080_TEMP T
                , (
                    SELECT    B.SEGMENT1 AS CODE
                            , B.SEGMENT2 AS NAME
                    FROM      SCM_ADM_LOOKUP_MASTER A
                            , SCM_ADM_LOOKUP_MASTER_DETAIL B
                    WHERE   A.LOOKUP_TYPE = B.LOOKUP_TYPE
                        AND A.LOOKUP_TYPE = 'CATHODE'
                        AND A.VALID_YN = 'Y'
                        AND B.VALID_YN = 'Y'
                  ) H
                , (
                    SELECT    B.SEGMENT1 AS CODE
                            , B.SEGMENT2 AS NAME
                    FROM      SCM_ADM_LOOKUP_MASTER A
                            , SCM_ADM_LOOKUP_MASTER_DETAIL B
                    WHERE   A.LOOKUP_TYPE = B.LOOKUP_TYPE
                        AND A.LOOKUP_TYPE = 'ITEM_MODEL_TYPE'
                        AND A.VALID_YN = 'Y'
                        AND B.VALID_YN = 'Y'
                        AND B.SEGMENT3 = '82'
                  ) E
                , (
                    SELECT    B.SEGMENT1 AS CODE
                            , B.SEGMENT2 AS NAME
                    FROM      SCM_ADM_LOOKUP_MASTER A
                            , SCM_ADM_LOOKUP_MASTER_DETAIL B
                    WHERE   A.LOOKUP_TYPE = B.LOOKUP_TYPE
                        AND A.LOOKUP_TYPE = 'ITEM_MODEL_TYPE'
                        AND A.VALID_YN = 'Y'
                        AND B.VALID_YN = 'Y'
                        AND B.SEGMENT3 = '40'
                  ) S
                , (
                    SELECT DISTINCT
                              DIVISION_ID
                            , ITEM_ID
                            , SCP_EXTRA_SPEC    /* 40 : Product level2 */
                    FROM    GT_0080_ITEM_ALL
                    WHERE   1=1
                        AND SCP_EXTRA_SPEC IS NOT NULL
                  ) X
        WHERE   T.CATHODE_CODE      = H.CODE(+)
            AND T.MODEL_TYPE_CODE   = E.CODE(+)
            AND T.OPERATION_ID      = S.CODE(+)
            AND T.DIVISION_ID       = X.DIVISION_ID(+)
            AND T.ITEM_ID           = X.ITEM_ID(+);

        DBMS_STATS.GATHER_TABLE_STATS($$PLSQL_UNIT_OWNER, 'GT_0080_PRE', NO_INVALIDATE => FALSE);

        /* @TblGroupCode_SP0080_All */
        INSERT INTO GT_0080_ALL
                  (
                    DIVISION_ID
                  , OPERATION_ID
                  , ITEM_ID
                  , NICK_NAME
                  , BASIC_MODEL_PACK
                  , BASIC_NICKNAME_PACK
                  , CELL_MODEL
                  , CELL_MODEL_NICKNAME
                  , BASIC_MODEL_CELL
                  , BASIC_NICKNAME_CELL
                  , GROUP_CODE1
                  , GROUP_CODE2
                  , GROUP_CODE3
                  , GROUP_CODE4
                  , GROUP_CODE5
                  , GROUP_CODE6
                  , GROUP_CODE7
                  , GROUP_CODE8
                  , GROUP_CODE9
                  , GROUP_CODE10
                  , FCST_YN
                  , PIC_ID
                  , PIC_NAME
                  , ATTRIBUTE7
                  , ATTRIBUTE8
                  , ATTRIBUTE9
                  , ATTRIBUTE10
                  , ATTRIBUTE11
                  , ATTRIBUTE12
                  , ATTRIBUTE13
                  , ATTRIBUTE14
                  , ATTRIBUTE15
                  , SALES_MODEL
                  , SALES_VALID_YN
                  , SALES_PRIORITY
                  , SALES_FROM_YYYYMMDD
                  , SALES_TO_YYYYMMDD
                  , LEVEL1_GROUP
                  , LEVEL2_CODE
                  , STATUS_PROTOTYPE
                  , STATUS_NEW
                  , CELL_CF
                  , BASIC_END_CUSTOMER
                  , BASIC_FINISHED_PRODUCT
                  , OPERATION_GROUP
                  , BIZ_TYPE
                  , MODEL_TYPE_CODE
                  , LEVEL_EXCEPT
                  , MKT_DEPT
                  , REMARK
                  , PLANT_ID
                  , PLANT_NAME
                  , ENERGE
                  , FLOW_TYPE
                  , ITEM_ID_ASSY
                  , REPLACEMENT
                  , CATHODE_CODE
                  , BASIC_APPLICATION
                  , BASIC_CELL_TYPE
                  , BASIC_CELL_CAPACITY_CHAR
                  , CATHODE_NAME
                  , CELL_TYPE_CODE
                  , NICKNAME_40
                  , MODEL_TYPE_NAME_82
                  , MODEL_TYPE_NAME_40
                  , SCP_EXTRA_SPEC
                  , BASIC_NICKNAME_CELL40
                  , APPLICATION_NAME
                  , BASIC_CELL_CAPACITY_81
                  , CELL_TYPE_GROUP_NAME
                  )
        SELECT    P.DIVISION_ID
                , P.OPERATION_ID
                , P.ITEM_ID
                , P.NICK_NAME
                , P.BASIC_MODEL_PACK
                , P.BASIC_NICKNAME_PACK
                , P.CELL_MODEL
                , P.CELL_MODEL_NICKNAME
                , P.BASIC_MODEL_CELL
                , P.BASIC_NICKNAME_CELL
                , P.GROUP_CODE1
                , P.GROUP_CODE2
                , P.GROUP_CODE3
                , P.GROUP_CODE4
                , P.GROUP_CODE5
                , P.GROUP_CODE6
                , P.GROUP_CODE7
                , P.GROUP_CODE8
                , P.GROUP_CODE9
                , P.GROUP_CODE10
                , P.FCST_YN
                , P.PIC_ID
                , P.PIC_NAME
                , P.ATTRIBUTE7
                , P.ATTRIBUTE8
                , P.ATTRIBUTE9
                , P.ATTRIBUTE10
                , P.ATTRIBUTE11
                , P.ATTRIBUTE12
                , P.ATTRIBUTE13
                , P.ATTRIBUTE14
                , P.ATTRIBUTE15
                , P.SALES_MODEL
                , P.SALES_VALID_YN
                , P.SALES_PRIORITY
                , P.SALES_FROM_YYYYMMDD
                , P.SALES_TO_YYYYMMDD
                , P.LEVEL1_GROUP
                , P.LEVEL2_CODE
                , P.STATUS_PROTOTYPE
                , P.STATUS_NEW
                , P.CELL_CF
                , P.BASIC_END_CUSTOMER
                , P.BASIC_FINISHED_PRODUCT
                , P.OPERATION_GROUP
                , P.BIZ_TYPE
                , P.MODEL_TYPE_CODE
                , P.LEVEL_EXCEPT
                , P.MKT_DEPT
                , P.REMARK
                , P.PLANT_ID
                , P.PLANT_NAME
                , P.ENERGE
                , P.FLOW_TYPE
                , P.ITEM_ID_ASSY
                , P.REPLACEMENT
                , P.CATHODE_CODE
                , P.BASIC_APPLICATION
                , P.BASIC_CELL_TYPE
                , P.BASIC_CELL_CAPACITY_CHAR
                , P.CATHODE_NAME
                , P.CELL_TYPE_CODE
                , P.NICKNAME_40
                , P.MODEL_TYPE_NAME_82
                , P.MODEL_TYPE_NAME_40
                , P.SCP_EXTRA_SPEC
                , P.BASIC_NICKNAME_CELL40
                , CASE
                    WHEN P.BASIC_APPLICATION = 'E' THEN 'Battery EV(BEV)'
                    WHEN P.BASIC_APPLICATION = 'H' THEN 'Hybrid(HEV)'
                    WHEN P.BASIC_APPLICATION = 'L' THEN 'Low Voltage(LV)'
                    WHEN P.BASIC_APPLICATION = 'P' THEN 'Plug-in HEV(PHEV)'
                    ELSE            ''
                  END AS APPLICATION_NAME
                , CASE WHEN P.BASIC_CELL_CAPACITY_CHAR IS NULL OR REGEXP_LIKE(P.BASIC_CELL_CAPACITY_CHAR, '[^0-9]') THEN NULL ELSE TO_NUMBER(P.BASIC_CELL_CAPACITY_CHAR DEFAULT NULL ON CONVERSION ERROR) END AS BASIC_CELL_CAPACITY_81
                , CASE
                    WHEN P.LEVEL_EXCEPT = 'EC' THEN 'Pouch'
                    WHEN P.LEVEL_EXCEPT = 'AM' THEN 'Cylindrical'
                    WHEN SUBSTR(P.ITEM_ID, 3, 1) = 'M' AND P.OPERATION_ID = 'P9500' THEN 'Pouch'
                    ELSE G.CELL_TYPE_GROUP_NAME
                  END AS CELL_TYPE_GROUP_NAME
        FROM      GT_0080_PRE P
                , (
                    SELECT    A.CODE                    AS CELL_TYPE_CODE
                            , SUBSTR(A.NAME, 1, 1)      AS FLOW_TYPE
                            , A.GROUP_CODE              AS CELL_TYPE_GROUP_CODE
                            , G.NAME                    AS CELL_TYPE_GROUP_NAME
                            , A.DISPLAY_SEQ
                    FROM    (
                                SELECT    B.SEGMENT1 AS CODE
                                        , B.SEGMENT2 AS NAME
                                        , B.SEGMENT3 AS GROUP_CODE
                                        , B.DISPLAY_SEQ
                                FROM      SCM_ADM_LOOKUP_MASTER A
                                        , SCM_ADM_LOOKUP_MASTER_DETAIL B
                                WHERE   A.LOOKUP_TYPE = B.LOOKUP_TYPE
                                    AND B.VALID_YN = 'Y'
                                    AND A.LOOKUP_TYPE   = 'CELL_TYPE_ITEM_CODE'
                                    AND A.VALID_YN      = 'Y'
                            ) A
                            , (
                                SELECT    B.SEGMENT1 AS CODE
                                        , B.SEGMENT2 AS NAME
                                FROM      SCM_ADM_LOOKUP_MASTER A
                                        , SCM_ADM_LOOKUP_MASTER_DETAIL B
                                WHERE   A.LOOKUP_TYPE = B.LOOKUP_TYPE
                                    AND B.VALID_YN = 'Y'
                                    AND A.LOOKUP_TYPE   = 'CELL_TYPE_ITEM_GROUP'
                                    AND A.VALID_YN      = 'Y'
                            ) G
                    WHERE   A.GROUP_CODE = G.CODE
                  ) G
        WHERE   P.FLOW_TYPE         = G.FLOW_TYPE(+)
            AND P.CELL_TYPE_CODE    = G.CELL_TYPE_CODE(+);

        DBMS_STATS.GATHER_TABLE_STATS($$PLSQL_UNIT_OWNER, 'GT_0080_ALL', NO_INVALIDATE => FALSE);

        IF P_CHECK_BOM = 'Y' THEN   --  2026.10.06 AJS BOM 체크 조건(Y)일 때만 BOM 적재(N 이면 결과에 쓰이지 않음)
--        /* @TblGroupCode_SP0080_BOM_PACK */
--        INSERT INTO GT_0080_BOM_PACK
--                  (
--                    ITEM_ID
--                  , OPERATION_GROUP_ID
--                  )
--        SELECT DISTINCT
--                  MODEL_ID AS ITEM_ID
--                , OPERATION_GROUP_ID
--        FROM    SCM_MST_MODEL_FINAL_ITEM_BOM_V
--        WHERE   DIVISION_ID = P_DIVISION_ID
--            AND OPERATION_GROUP_ID = 'A';
--
--        /* @TblGroupCode_SP0080_BOM_CELL */
--        INSERT INTO GT_0080_BOM_CELL
--                  (
--                    ITEM_ID
--                  , OPERATION_GROUP_ID
--                  )
--        SELECT DISTINCT
--                  MODEL_ID AS ITEM_ID
--                , OPERATION_GROUP_ID
--        FROM    SCM_MST_MODEL_FINAL_ITEM_BOM_V
--        WHERE   DIVISION_ID = P_DIVISION_ID
--            AND OPERATION_GROUP_ID = 'E';
        /* @TblGroupCode_SP0080_BOM_PACK(공정그룹 A) · @TblGroupCode_SP0080_BOM_CELL(공정그룹 E) 를 뷰 한 번 읽어 함께 적재 */ /* AJS 20261007 속도 */
        INSERT ALL /* AJS 20261007 속도 */
            WHEN OPERATION_GROUP_ID = 'A' THEN /* AJS 20261007 속도 */
            INTO GT_0080_BOM_PACK /* AJS 20261007 속도 */
                  ( /* AJS 20261007 속도 */
                    ITEM_ID /* AJS 20261007 속도 */
                  , OPERATION_GROUP_ID /* AJS 20261007 속도 */
                  ) /* AJS 20261007 속도 */
            VALUES /* AJS 20261007 속도 */
                  ( /* AJS 20261007 속도 */
                    ITEM_ID /* AJS 20261007 속도 */
                  , OPERATION_GROUP_ID /* AJS 20261007 속도 */
                  ) /* AJS 20261007 속도 */
            WHEN OPERATION_GROUP_ID = 'E' THEN /* AJS 20261007 속도 */
            INTO GT_0080_BOM_CELL /* AJS 20261007 속도 */
                  ( /* AJS 20261007 속도 */
                    ITEM_ID /* AJS 20261007 속도 */
                  , OPERATION_GROUP_ID /* AJS 20261007 속도 */
                  ) /* AJS 20261007 속도 */
            VALUES /* AJS 20261007 속도 */
                  ( /* AJS 20261007 속도 */
                    ITEM_ID /* AJS 20261007 속도 */
                  , OPERATION_GROUP_ID /* AJS 20261007 속도 */
                  ) /* AJS 20261007 속도 */
        SELECT DISTINCT /* AJS 20261007 속도 */
                  MODEL_ID AS ITEM_ID /* AJS 20261007 속도 */
                , OPERATION_GROUP_ID /* AJS 20261007 속도 */
        FROM    SCM_MST_MODEL_FINAL_ITEM_BOM_V /* AJS 20261007 속도 */
        WHERE   OPERATION_GROUP_ID IN ('A', 'E') /* AJS 20261007 속도 */
            AND DIVISION_ID = P_DIVISION_ID; /* AJS 20261007 속도 */
        END IF;   --  2026.10.06 AJS

        BEGIN
            SELECT  BASIS_START_DATE
            INTO    V_BASIS_START_DATE
            FROM    SCM_SYS_CALENDAR_M
            WHERE   BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_BASIS_START_DATE := NULL;
        END;

        /* 최종 결과 (AS-IS @TBL_RES · #TblGroupCode_SP0080) */
        INSERT INTO GT_0080_GROUP_CODE
                  (
                    DIVISION_ID
                  , OPERATION_ID
                  , ITEM_ID
                  , NICK_NAME
                  , BASIC_MODEL_PACK
                  , BASIC_NICKNAME_PACK
                  , CELL_MODEL
                  , CELL_MODEL_NICKNAME
                  , BASIC_MODEL_CELL
                  , BASIC_NICKNAME_CELL
                  , GROUP_CODE1
                  , GROUP_CODE2
                  , GROUP_CODE3
                  , GROUP_CODE4
                  , GROUP_CODE5
                  , GROUP_CODE6
                  , GROUP_CODE7
                  , GROUP_CODE8
                  , GROUP_CODE9
                  , GROUP_CODE10
                  , FCST_YN
                  , PIC_ID
                  , PIC_NAME
                  , ATTRIBUTE7
                  , ATTRIBUTE8
                  , ATTRIBUTE9
                  , ATTRIBUTE10
                  , ATTRIBUTE11
                  , ATTRIBUTE12
                  , ATTRIBUTE13
                  , ATTRIBUTE14
                  , ATTRIBUTE15
                  , SALES_MODEL
                  , SALES_VALID_YN
                  , SALES_PRIORITY
                  , SALES_FROM_YYYYMMDD
                  , SALES_TO_YYYYMMDD
                  , LEVEL1_GROUP
                  , LEVEL2_CODE
                  , STATUS_PROTOTYPE
                  , STATUS_NEW
                  , CELL_CF
                  , BASIC_END_CUSTOMER
                  , BASIC_FINISHED_PRODUCT
                  , OPERATION_GROUP
                  , BIZ_TYPE
                  , MODEL_TYPE_CODE
                  , LEVEL_EXCEPT
                  , MKT_DEPT
                  , REMARK
                  , PLANT_ID
                  , PLANT_NAME
                  , ENERGE
                  , FLOW_TYPE
                  , ITEM_ID_ASSY
                  , REPLACEMENT
                  , CATHODE_CODE
                  , BASIC_APPLICATION
                  , BASIC_CELL_TYPE
                  , BASIC_CELL_CAPACITY_CHAR
                  , CATHODE_NAME
                  , CELL_TYPE_CODE
                  , NICKNAME_40
                  , MODEL_TYPE_NAME_82
                  , MODEL_TYPE_NAME_40
                  , SCP_EXTRA_SPEC
                  , BASIC_NICKNAME_CELL40
                  , APPLICATION_NAME
                  , BASIC_CELL_CAPACITY_81
                  , CELL_TYPE_GROUP_NAME
                  , BASIC_TOTAL_CAPACITY
                  , BASIC_CELL_CAPACITY
                  , PRODUCTION_YN
                  , STATUS_MASS
                  , STATUS_ACTIVE
                  )
        SELECT    A.DIVISION_ID
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.NICK_NAME
                , A.BASIC_MODEL_PACK
                , A.BASIC_NICKNAME_PACK
                , A.CELL_MODEL
                , A.CELL_MODEL_NICKNAME
                , A.BASIC_MODEL_CELL
                , A.BASIC_NICKNAME_CELL
                , A.GROUP_CODE1
                , A.GROUP_CODE2
                , A.GROUP_CODE3
                , A.GROUP_CODE4
                , A.GROUP_CODE5
                , A.GROUP_CODE6
                , A.GROUP_CODE7
                , A.GROUP_CODE8
                , A.GROUP_CODE9
                , A.GROUP_CODE10
                , A.FCST_YN
                , A.PIC_ID
                , A.PIC_NAME
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
                , A.ATTRIBUTE11
                , A.ATTRIBUTE12
                , A.ATTRIBUTE13
                , A.ATTRIBUTE14
                , A.ATTRIBUTE15
                , A.SALES_MODEL
                , A.SALES_VALID_YN
                , A.SALES_PRIORITY
                , A.SALES_FROM_YYYYMMDD
                , A.SALES_TO_YYYYMMDD
                , A.LEVEL1_GROUP
                , A.LEVEL2_CODE
                , A.STATUS_PROTOTYPE
                , A.STATUS_NEW
                , A.CELL_CF
                , A.BASIC_END_CUSTOMER
                , A.BASIC_FINISHED_PRODUCT
                , A.OPERATION_GROUP
                , A.BIZ_TYPE
                , A.MODEL_TYPE_CODE
                , A.LEVEL_EXCEPT
                , A.MKT_DEPT
                , A.REMARK
                , A.PLANT_ID
                , A.PLANT_NAME
                , A.ENERGE
                , A.FLOW_TYPE
                , A.ITEM_ID_ASSY
                , A.REPLACEMENT
                , A.CATHODE_CODE
                , A.BASIC_APPLICATION
                , A.BASIC_CELL_TYPE
                , A.BASIC_CELL_CAPACITY_CHAR
                , A.CATHODE_NAME
                , A.CELL_TYPE_CODE
                , A.NICKNAME_40
                , A.MODEL_TYPE_NAME_82
                , A.MODEL_TYPE_NAME_40
                , A.SCP_EXTRA_SPEC
                , A.BASIC_NICKNAME_CELL40
                , A.APPLICATION_NAME
                , A.BASIC_CELL_CAPACITY_81
                , A.CELL_TYPE_GROUP_NAME
                , CASE
                    WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81'  THEN CASE WHEN A.BASIC_CELL_CAPACITY_81 IS NULL OR A.CELL_CF IS NULL THEN NULL ELSE A.BASIC_CELL_CAPACITY_81 * TO_NUMBER(A.CELL_CF DEFAULT NULL ON CONVERSION ERROR) END
                    WHEN A.DIVISION_ID = '82'                THEN CASE WHEN A.CELL_CF IS NULL THEN NULL ELSE TO_NUMBER(A.ENERGE DEFAULT NULL ON CONVERSION ERROR) END
                    WHEN A.DIVISION_ID = '40'                THEN CASE WHEN A.CELL_CF IS NULL THEN NULL ELSE TO_NUMBER(A.ENERGE DEFAULT NULL ON CONVERSION ERROR) END
                    ELSE NULL
                  END AS BASIC_TOTAL_CAPACITY
                , CASE
                    WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81'  THEN A.BASIC_CELL_CAPACITY_81
                    WHEN A.DIVISION_ID = '82'                THEN TO_NUMBER(A.ENERGE DEFAULT NULL ON CONVERSION ERROR) / TO_NUMBER(A.CELL_CF DEFAULT NULL ON CONVERSION ERROR)
                    ELSE NULL
                  END AS BASIC_CELL_CAPACITY
                  /* ITEM 별 Plant가 n 개이면 Active 가 Plant 별로 Y, N 두개 이상 존재하므로 Y만 필터링(최종 row 가 ITEM 별 1개만 존재하도록) */
                , CASE WHEN P.ITEM_ID IS NOT NULL THEN 'Y' ELSE '' END                              AS PRODUCTION_YN
                , CASE WHEN P.ITEM_ID IS NOT NULL OR A.FCST_YN = 'Y' THEN 'Y' ELSE '' END           AS STATUS_MASS
                , NVL(IA.ACTIVE_FLAG, 'N')                                                          AS STATUS_ACTIVE
        FROM      GT_0080_ALL A
                , (
                    SELECT DISTINCT
                              N.DIVISION_ID
                            , N.ITEM_ID
                    FROM    SCP_ANL_PRODUCTION_PLAN_N N
                    WHERE   1=1
                        AND N.YYYYMMDD >= V_BASIS_START_DATE
                  ) P
                , GT_0080_ITEM_ACTIVE IA
                , GT_0080_BOM_PACK BP
                , GT_0080_BOM_CELL BC
        WHERE   A.DIVISION_ID   = P.DIVISION_ID(+)
            AND A.ITEM_ID       = P.ITEM_ID(+)
            AND A.DIVISION_ID   = IA.DIVISION_ID(+)
            AND A.ITEM_ID       = IA.ITEM_ID(+)
            AND A.ITEM_ID       = BP.ITEM_ID(+)
            AND A.ITEM_ID       = BC.ITEM_ID(+)
            AND ((P_CHECK_FCST = 'N')           OR A.FCST_YN = P_CHECK_FCST)
            AND ((P_CHECK_PRODUCTION = 'N')     OR (P_CHECK_PRODUCTION = 'Y'    AND P.ITEM_ID IS NOT NULL))
            AND ((P_CHECK_BOM = 'N')            OR (P_CHECK_BOM = 'Y'           AND A.OPERATION_GROUP = 'P' AND BP.ITEM_ID IS NOT NULL)
                                                OR (P_CHECK_BOM = 'Y'           AND A.OPERATION_GROUP = 'A' AND BC.ITEM_ID IS NOT NULL))
            AND ((P_CHECK_ACTIVE = 'N')         OR (P_CHECK_ACTIVE = 'Y'        AND NVL(IA.ACTIVE_FLAG, 'N') = 'Y'));

        IF P_DEBUG_MODE = 'T' THEN
            DBMS_OUTPUT.PUT_LINE('GT_0080_GROUP_CODE LOADED : ' || SQL%ROWCOUNT);
        END IF;

    END P_LOAD_GROUP_CODE;


    /* ------------------------------------------------------------
       Group Code Management 조회
       ------------------------------------------------------------ */
    PROCEDURE P_SCP0080_GET_GROUP_CODE_MANAGEMENT
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_ID          IN  VARCHAR2,
        P_MODEL_ID              IN  VARCHAR2,
        P_NICKNAME              IN  VARCHAR2,
        P_CHECK_FCST            IN  VARCHAR2,
        P_CHECK_PRODUCTION      IN  VARCHAR2,
        P_CHECK_ACTIVE          IN  VARCHAR2,
        P_CHECK_BOM             IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        V_PROGRAM_ID            VARCHAR2(30 CHAR)   := 'SCP0080';
        V_SHEET_NAME            VARCHAR2(200 CHAR)  := 'Group Code Management';
        V_COLUMNS               VARCHAR2(32767 CHAR);
        V_ORDERS                VARCHAR2(32767 CHAR);
        V_SQL                   CLOB;
    BEGIN

        O_RESULT_CODE := 'S';

        /* 조회 대상 적재 (AS-IS FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE) */
        P_LOAD_GROUP_CODE
        (
            P_DIVISION_ID       => P_DIVISION_ID,
            P_OPERATION_ID      => P_OPERATION_ID,
            P_MODEL_ID          => P_MODEL_ID,
            P_NICKNAME          => P_NICKNAME,
            P_CHECK_FCST        => P_CHECK_FCST,
            P_CHECK_PRODUCTION  => P_CHECK_PRODUCTION,
            P_CHECK_ACTIVE      => P_CHECK_ACTIVE,
            P_CHECK_BOM         => P_CHECK_BOM,
            P_USER_ID           => P_USER_ID,
            P_DEBUG_MODE        => P_DEBUG_MODE
        );

        V_SHEET_NAME := V_SHEET_NAME || CASE WHEN P_DIVISION_ID IN ('81', '82', '40') OR SUBSTR(P_DIVISION_ID, 1, 2) = '81' THEN ' - ' || P_DIVISION_ID ELSE '' END;

        /* 표시할 칸 목록 */
        SELECT  LISTAGG(A.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY A.SORT_ORDER_NO)
        INTO    V_COLUMNS
        FROM    (
                    SELECT    SORT_ORDER_NO
                            , COLUMN_NAME
                            , DATA_SORT_METHOD_CODE
                    FROM    SCM_MST_SHEET_COLUMNS
                    WHERE   1=1
                        AND PROGRAM_ID      = V_PROGRAM_ID
                        AND SHEET_NAME      = V_SHEET_NAME
                        AND VALID_YN        = 'Y'
                        AND VISIBLE_FLAG    = 'Y'
                ) A;

        /* 최종 데이터 정렬기준 변경(데이터 수정때마다 새로 정렬되어 찾기 어려움)                     */
        /* AS-IS 는 위 목록으로 @V_ORDERS 를 조립한 뒤 아래 고정값으로 덮어쓴다(조립분은 쓰이지 않음) */
        /*                                                                                            */
        /* ※ AS-IS 와 표시 순서를 맞추기 위해 두 가지를 더 준다.                                      */
        /*   1. BIZ_TYPE NULLS FIRST - AS-IS 의 빈 문자는 Oracle 에서 NULL 이 되는데                  */
        /*      MSSQL 은 빈 문자를 맨 앞에 두고 Oracle 은 NULL 을 오름차순 맨 뒤에 둔다.              */
        /*   2. REPLACE(ITEM_ID, '-', '') - MSSQL 기본 정렬은 하이픈을 무시한다.                      */
        /*      실측으로 사업부 40·81·82 의 정렬 그룹 25벌이 모두 이 규칙과 맞았다.                   */
        /*      하이픈을 뗀 값이 같아지는 경우를 위해 ITEM_ID 원문을 2차 키로 둔다.                   */
        V_ORDERS := 'DIVISION_ID ,OPERATION_ID ,BIZ_TYPE NULLS FIRST ,REPLACE(ITEM_ID, ''-'', '''') ,ITEM_ID';

        IF V_COLUMNS IS NULL THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '화면 칸 설정(SCM_MST_SHEET_COLUMNS)에 ' || V_PROGRAM_ID || ' / ' || V_SHEET_NAME || ' 이 없습니다.';
            OPEN O_RC1 FOR SELECT * FROM GT_0080_GROUP_CODE WHERE 1=0;
            RETURN;
        END IF;

        V_SQL := 'SELECT      ' || V_COLUMNS || '
                    FROM        GT_0080_GROUP_CODE
                    ORDER BY    ' || V_ORDERS;

        IF P_DEBUG_MODE = 'T' THEN
            DBMS_OUTPUT.PUT_LINE('V_COLUMNS : ' || V_COLUMNS);
            DBMS_OUTPUT.PUT_LINE('V_ORDERS : ' || V_ORDERS);
            DBMS_OUTPUT.PUT_LINE('V_SQL : ' || DBMS_LOB.SUBSTR(V_SQL, 3000, 1));
        END IF;

        OPEN O_RC1 FOR V_SQL;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || SQLCODE || ']' || SQLERRM;

            PR_SCM_SYS_LOG_BATCH
            (
                'PKG_SCP0080.P_SCP0080_GET_GROUP_CODE_MANAGEMENT'
              , 'ERROR'
              , NULL
              , SUBSTR(SQLERRM, 1, 1000)
              , NULL
              , SYSDATE
              , SUBSTR('DIVISION_ID=' || P_DIVISION_ID || ', OPERATION_ID=' || P_OPERATION_ID || ', MODEL_ID=' || P_MODEL_ID || ', NICKNAME=' || P_NICKNAME || ', USER_ID=' || P_USER_ID, 1, 1000)
              , TO_CHAR(SQLCODE)
              , SUBSTR(SQLERRM, 1, 1000)
              , SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 1000)
            );

            IF O_RC1%ISOPEN THEN
                CLOSE O_RC1;
            END IF;

            OPEN O_RC1 FOR SELECT * FROM GT_0080_GROUP_CODE WHERE 1=0;

    END P_SCP0080_GET_GROUP_CODE_MANAGEMENT;


    /* ------------------------------------------------------------
       Group Code Management 저장
       ------------------------------------------------------------ */
    PROCEDURE P_SCP0080_SAVE_GROUP_CODE_MANAGEMENT
    (
        P_DIVISION_ID           IN  CLOB,
        P_MODEL_ID              IN  CLOB,
        P_PIC_ID                IN  CLOB,
        P_SALES_MODEL           IN  CLOB,
        P_SALES_VALID_YN        IN  CLOB,
        P_SALES_PRIORITY        IN  CLOB,
        P_SALES_FROM_YYYYMMDD   IN  CLOB,
        P_SALES_TO_YYYYMMDD     IN  CLOB,
        P_USER_ID               IN  CLOB,
        P_LEVEL1_GROUP          IN  CLOB,
        P_LEVEL2_CODE           IN  CLOB,
        P_STATUS_PROTOTYPE      IN  CLOB,
        P_STATUS_MASS           IN  CLOB,
        P_STATUS_NEW            IN  CLOB,
        P_REPLACEMENT           IN  CLOB,
        P_BASIC_END_CUSTOMER    IN  CLOB,
        P_BASIC_FINISHED_PRODUCT IN CLOB,
        P_MKT_DEPT              IN  CLOB,
        P_REMARK                IN  CLOB,
        P_GROUP_CODE1           IN  CLOB,
        P_GROUP_CODE2           IN  CLOB,
        P_GROUP_CODE3           IN  CLOB,
        P_GROUP_CODE4           IN  CLOB,
        P_GROUP_CODE5           IN  CLOB,
        P_GROUP_CODE6           IN  CLOB,
        P_GROUP_CODE7           IN  CLOB,
        P_GROUP_CODE8           IN  CLOB,
        P_GROUP_CODE9           IN  CLOB,
        P_GROUP_CODE10          IN  CLOB,
        P_ATTRIBUTE1            IN  CLOB,
        P_ATTRIBUTE2            IN  CLOB,
        P_ATTRIBUTE3            IN  CLOB,
        P_ATTRIBUTE4            IN  CLOB,
        P_ATTRIBUTE5            IN  CLOB,
        P_ATTRIBUTE6            IN  CLOB,
        P_ATTRIBUTE7            IN  CLOB,
        P_ATTRIBUTE8            IN  CLOB,
        P_ATTRIBUTE9            IN  CLOB,
        P_ATTRIBUTE10           IN  CLOB,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_CNT            OUT NUMBER,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        V_DELIMITER             VARCHAR2(1 CHAR)    := '^';

        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME          VARCHAR2(150 CHAR)  := 'SCP0080_SAVE_GROUP_CODE_MANAGEMENT';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        N_LOG_COUNT             NUMBER              := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        D_EVENT_DATE            DATE;

        /* 결과 반환 변수 설정 */
        V_MOD_CNT               NUMBER              := 0;

        T_DIVISION_ID           T_TOKEN_TAB;
        T_MODEL_ID              T_TOKEN_TAB;
        T_PIC_ID                T_TOKEN_TAB;
        T_SALES_MODEL           T_TOKEN_TAB;
        T_SALES_VALID_YN        T_TOKEN_TAB;
        T_SALES_PRIORITY        T_TOKEN_TAB;
        T_SALES_FROM_YYYYMMDD   T_TOKEN_TAB;
        T_SALES_TO_YYYYMMDD     T_TOKEN_TAB;
        T_USER_ID               T_TOKEN_TAB;
        T_LEVEL1_GROUP          T_TOKEN_TAB;
        T_LEVEL2_CODE           T_TOKEN_TAB;
        T_STATUS_PROTOTYPE      T_TOKEN_TAB;
        T_STATUS_MASS           T_TOKEN_TAB;
        T_STATUS_NEW            T_TOKEN_TAB;
        T_REPLACEMENT           T_TOKEN_TAB;
        T_END_CUSTOMER          T_TOKEN_TAB;
        T_FINISHED_PRODUCT      T_TOKEN_TAB;
        T_MKT_DEPT              T_TOKEN_TAB;
        T_REMARK                T_TOKEN_TAB;
        T_GROUP_CODE1           T_TOKEN_TAB;
        T_GROUP_CODE2           T_TOKEN_TAB;
        T_GROUP_CODE3           T_TOKEN_TAB;
        T_GROUP_CODE4           T_TOKEN_TAB;
        T_GROUP_CODE5           T_TOKEN_TAB;
        T_GROUP_CODE6           T_TOKEN_TAB;
        T_GROUP_CODE7           T_TOKEN_TAB;
        T_GROUP_CODE8           T_TOKEN_TAB;
        T_GROUP_CODE9           T_TOKEN_TAB;
        T_GROUP_CODE10          T_TOKEN_TAB;
        T_ATTRIBUTE1            T_TOKEN_TAB;
        T_ATTRIBUTE2            T_TOKEN_TAB;
        T_ATTRIBUTE3            T_TOKEN_TAB;
        T_ATTRIBUTE4            T_TOKEN_TAB;
        T_ATTRIBUTE5            T_TOKEN_TAB;
        T_ATTRIBUTE6            T_TOKEN_TAB;
        T_ATTRIBUTE7            T_TOKEN_TAB;
        T_ATTRIBUTE8            T_TOKEN_TAB;
        T_ATTRIBUTE9            T_TOKEN_TAB;
        T_ATTRIBUTE10           T_TOKEN_TAB;

        V_ROW_CNT               PLS_INTEGER;
        V_ERR_MSG               VARCHAR2(1000 CHAR);

        /* AS-IS 는 파라미터마다 REPLACE(x, 'null', '') 를 먼저 돌린다 */
        FUNCTION F_CLEAN (P_IN IN CLOB) RETURN CLOB
        IS
        BEGIN
            RETURN REPLACE(P_IN, 'null', '');
        END F_CLEAN;

    BEGIN

        O_RESULT_CODE := 'S';

        /* GTT 초기화 */
        DELETE  GT_0080_SAVE_MAIN;
        DELETE  GT_0080_SAVE_MAIN_CA;

        /* LOG start */
        V_LOG_TYPE      := 'START';
        V_LOG_MESSAGE   := '########## Start of procedure ##########';
        V_DESCRIPTION   := '';
        D_EVENT_DATE    := SYSDATE;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, NULL, NULL, NULL, NULL);

        /* 파라미터 분리 */
        P_SPLIT_TOKEN(F_CLEAN(P_DIVISION_ID),           V_DELIMITER, T_DIVISION_ID);
        P_SPLIT_TOKEN(F_CLEAN(P_MODEL_ID),              V_DELIMITER, T_MODEL_ID);
        P_SPLIT_TOKEN(F_CLEAN(P_PIC_ID),                V_DELIMITER, T_PIC_ID);
        P_SPLIT_TOKEN(F_CLEAN(P_SALES_MODEL),           V_DELIMITER, T_SALES_MODEL);
        P_SPLIT_TOKEN(F_CLEAN(P_SALES_VALID_YN),        V_DELIMITER, T_SALES_VALID_YN);
        P_SPLIT_TOKEN(F_CLEAN(P_SALES_PRIORITY),        V_DELIMITER, T_SALES_PRIORITY);
        P_SPLIT_TOKEN(F_CLEAN(P_SALES_FROM_YYYYMMDD),   V_DELIMITER, T_SALES_FROM_YYYYMMDD);
        P_SPLIT_TOKEN(F_CLEAN(P_SALES_TO_YYYYMMDD),     V_DELIMITER, T_SALES_TO_YYYYMMDD);
        P_SPLIT_TOKEN(F_CLEAN(P_USER_ID),               V_DELIMITER, T_USER_ID);
        P_SPLIT_TOKEN(F_CLEAN(P_LEVEL1_GROUP),          V_DELIMITER, T_LEVEL1_GROUP);
        P_SPLIT_TOKEN(F_CLEAN(P_LEVEL2_CODE),           V_DELIMITER, T_LEVEL2_CODE);
        P_SPLIT_TOKEN(F_CLEAN(P_STATUS_PROTOTYPE),      V_DELIMITER, T_STATUS_PROTOTYPE);
        P_SPLIT_TOKEN(F_CLEAN(P_STATUS_MASS),           V_DELIMITER, T_STATUS_MASS);
        P_SPLIT_TOKEN(F_CLEAN(P_STATUS_NEW),            V_DELIMITER, T_STATUS_NEW);
        P_SPLIT_TOKEN(F_CLEAN(P_REPLACEMENT),           V_DELIMITER, T_REPLACEMENT);
        P_SPLIT_TOKEN(F_CLEAN(P_BASIC_END_CUSTOMER),    V_DELIMITER, T_END_CUSTOMER);
        P_SPLIT_TOKEN(F_CLEAN(P_BASIC_FINISHED_PRODUCT),V_DELIMITER, T_FINISHED_PRODUCT);
        P_SPLIT_TOKEN(F_CLEAN(P_MKT_DEPT),              V_DELIMITER, T_MKT_DEPT);
        P_SPLIT_TOKEN(F_CLEAN(P_REMARK),                V_DELIMITER, T_REMARK);
        P_SPLIT_TOKEN(F_CLEAN(P_GROUP_CODE1),           V_DELIMITER, T_GROUP_CODE1);
        P_SPLIT_TOKEN(F_CLEAN(P_GROUP_CODE2),           V_DELIMITER, T_GROUP_CODE2);
        P_SPLIT_TOKEN(F_CLEAN(P_GROUP_CODE3),           V_DELIMITER, T_GROUP_CODE3);
        P_SPLIT_TOKEN(F_CLEAN(P_GROUP_CODE4),           V_DELIMITER, T_GROUP_CODE4);
        P_SPLIT_TOKEN(F_CLEAN(P_GROUP_CODE5),           V_DELIMITER, T_GROUP_CODE5);
        P_SPLIT_TOKEN(F_CLEAN(P_GROUP_CODE6),           V_DELIMITER, T_GROUP_CODE6);
        P_SPLIT_TOKEN(F_CLEAN(P_GROUP_CODE7),           V_DELIMITER, T_GROUP_CODE7);
        P_SPLIT_TOKEN(F_CLEAN(P_GROUP_CODE8),           V_DELIMITER, T_GROUP_CODE8);
        P_SPLIT_TOKEN(F_CLEAN(P_GROUP_CODE9),           V_DELIMITER, T_GROUP_CODE9);
        P_SPLIT_TOKEN(F_CLEAN(P_GROUP_CODE10),          V_DELIMITER, T_GROUP_CODE10);
        P_SPLIT_TOKEN(F_CLEAN(P_ATTRIBUTE1),            V_DELIMITER, T_ATTRIBUTE1);
        P_SPLIT_TOKEN(F_CLEAN(P_ATTRIBUTE2),            V_DELIMITER, T_ATTRIBUTE2);
        P_SPLIT_TOKEN(F_CLEAN(P_ATTRIBUTE3),            V_DELIMITER, T_ATTRIBUTE3);
        P_SPLIT_TOKEN(F_CLEAN(P_ATTRIBUTE4),            V_DELIMITER, T_ATTRIBUTE4);
        P_SPLIT_TOKEN(F_CLEAN(P_ATTRIBUTE5),            V_DELIMITER, T_ATTRIBUTE5);
        P_SPLIT_TOKEN(F_CLEAN(P_ATTRIBUTE6),            V_DELIMITER, T_ATTRIBUTE6);
        P_SPLIT_TOKEN(F_CLEAN(P_ATTRIBUTE7),            V_DELIMITER, T_ATTRIBUTE7);
        P_SPLIT_TOKEN(F_CLEAN(P_ATTRIBUTE8),            V_DELIMITER, T_ATTRIBUTE8);
        P_SPLIT_TOKEN(F_CLEAN(P_ATTRIBUTE9),            V_DELIMITER, T_ATTRIBUTE9);
        P_SPLIT_TOKEN(F_CLEAN(P_ATTRIBUTE10),           V_DELIMITER, T_ATTRIBUTE10);

        /* AS-IS 는 4벌을 NR 로 내부조인하므로 토큰 수가 가장 적은 파라미터까지만 저장된다 */
        V_ROW_CNT := LEAST(T_DIVISION_ID.COUNT, T_MODEL_ID.COUNT, T_PIC_ID.COUNT, T_SALES_MODEL.COUNT
                         , T_SALES_VALID_YN.COUNT, T_SALES_PRIORITY.COUNT, T_SALES_FROM_YYYYMMDD.COUNT
                         , T_SALES_TO_YYYYMMDD.COUNT, T_USER_ID.COUNT
                         , T_LEVEL1_GROUP.COUNT, T_LEVEL2_CODE.COUNT, T_STATUS_PROTOTYPE.COUNT
                         , T_STATUS_MASS.COUNT, T_STATUS_NEW.COUNT, T_REPLACEMENT.COUNT
                         , T_END_CUSTOMER.COUNT, T_FINISHED_PRODUCT.COUNT, T_MKT_DEPT.COUNT, T_REMARK.COUNT
                         , T_GROUP_CODE1.COUNT, T_GROUP_CODE2.COUNT, T_GROUP_CODE3.COUNT, T_GROUP_CODE4.COUNT
                         , T_GROUP_CODE5.COUNT, T_GROUP_CODE6.COUNT, T_GROUP_CODE7.COUNT, T_GROUP_CODE8.COUNT
                         , T_GROUP_CODE9.COUNT, T_GROUP_CODE10.COUNT
                         , T_ATTRIBUTE1.COUNT, T_ATTRIBUTE2.COUNT, T_ATTRIBUTE3.COUNT, T_ATTRIBUTE4.COUNT
                         , T_ATTRIBUTE5.COUNT, T_ATTRIBUTE6.COUNT, T_ATTRIBUTE7.COUNT, T_ATTRIBUTE8.COUNT
                         , T_ATTRIBUTE9.COUNT, T_ATTRIBUTE10.COUNT);

        /* CP 임시테이블에 값 저장 begin----------------------------------------------------------- */
        FOR I IN 1 .. V_ROW_CNT
        LOOP
            INSERT INTO GT_0080_SAVE_MAIN
                      (
                        DIVISION_ID
                      , MODEL_ID
                      , PIC_ID
                      , SALES_MODEL
                      , SALES_VALID_YN
                      , SALES_PRIORITY
                      , SALES_FROM_YYYYMMDD
                      , SALES_TO_YYYYMMDD
                      , USER_ID
                      , LEVEL1_GROUP
                      , LEVEL2_CODE
                      , STATUS_PROTOTYPE
                      , STATUS_MASS
                      , REPLACEMENT
                      , END_CUSTOMER
                      , FINISHED_PRODUCT
                      , MKT_DEPT
                      , REMARK
                      , GROUP_CODE1
                      , GROUP_CODE2
                      , GROUP_CODE3
                      , GROUP_CODE4
                      , GROUP_CODE5
                      , GROUP_CODE6
                      , GROUP_CODE7
                      , GROUP_CODE8
                      , GROUP_CODE9
                      , GROUP_CODE10
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
            VALUES
                      (
                        T_DIVISION_ID(I)
                      , T_MODEL_ID(I)
                      , T_PIC_ID(I)
                      , T_SALES_MODEL(I)
                      , T_SALES_VALID_YN(I)
                        /* AS-IS : IIF(CONVERT(INT, ISNULL(TOKEN, 0)) = 0, NULL, CONVERT(INT, TOKEN))              */
                        /* 숫자로 바꿀 수 없는 값이 오면 AS-IS 는 오류로 끝난다(실측 : 'ABC' 는 결과코드 F).       */
                        /* 변환 실패를 빈값으로 삼키면 사용자는 저장된 줄 알지만 값이 비므로 AS-IS 대로 오류를 낸다. */
                        /* 부호만 있거나 이관 채움값('-' · '+')은 AS-IS 가 0 으로 보므로 빈값으로 옮긴다(실측 : S). */
                      , CASE
                          WHEN RTRIM(T_SALES_PRIORITY(I)) IS NULL     THEN NULL
                          WHEN RTRIM(T_SALES_PRIORITY(I)) IN ('-', '+') THEN NULL
                          WHEN TO_NUMBER(T_SALES_PRIORITY(I)) = 0     THEN NULL
                          ELSE TO_NUMBER(T_SALES_PRIORITY(I))
                        END
                      , T_SALES_FROM_YYYYMMDD(I)
                      , T_SALES_TO_YYYYMMDD(I)
                      , T_USER_ID(I)
                      , T_LEVEL1_GROUP(I)
                      , T_LEVEL2_CODE(I)
                      , T_STATUS_PROTOTYPE(I)
                      , T_STATUS_MASS(I)
                      , T_REPLACEMENT(I)
                      , T_END_CUSTOMER(I)
                      , T_FINISHED_PRODUCT(I)
                      , T_MKT_DEPT(I)
                      , T_REMARK(I)
                      , T_GROUP_CODE1(I)
                      , T_GROUP_CODE2(I)
                      , T_GROUP_CODE3(I)
                      , T_GROUP_CODE4(I)
                      , T_GROUP_CODE5(I)
                      , T_GROUP_CODE6(I)
                      , T_GROUP_CODE7(I)
                      , T_GROUP_CODE8(I)
                      , T_GROUP_CODE9(I)
                      , T_GROUP_CODE10(I)
                      , T_ATTRIBUTE1(I)
                      , T_ATTRIBUTE2(I)
                      , T_ATTRIBUTE3(I)
                      , T_ATTRIBUTE4(I)
                      , T_ATTRIBUTE5(I)
                      , T_ATTRIBUTE6(I)
                      , T_ATTRIBUTE7(I)
                      , T_ATTRIBUTE8(I)
                      , T_ATTRIBUTE9(I)
                      , T_ATTRIBUTE10(I)
                      );
        END LOOP;
        /* CP 임시테이블에 값 저장 end------------------------------------------------------------- */

        /* CA 임시테이블에 값 저장 begin----------------------------------------------------------- */
        INSERT INTO GT_0080_SAVE_MAIN_CA
                  (
                    DIVISION_ID
                  , MODEL_ID
                  , PIC_ID
                  , SALES_MODEL
                  , SALES_VALID_YN
                  , SALES_PRIORITY
                  , SALES_FROM_YYYYMMDD
                  , SALES_TO_YYYYMMDD
                  , USER_ID
                  , LEVEL1_GROUP
                  , LEVEL2_CODE
                  , STATUS_PROTOTYPE
                  , STATUS_MASS
                  , REPLACEMENT
                  , END_CUSTOMER
                  , FINISHED_PRODUCT
                  , MKT_DEPT
                  , REMARK
                  , GROUP_CODE1
                  , GROUP_CODE2
                  , GROUP_CODE3
                  , GROUP_CODE4
                  , GROUP_CODE5
                  , GROUP_CODE6
                  , GROUP_CODE7
                  , GROUP_CODE8
                  , GROUP_CODE9
                  , GROUP_CODE10
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
        SELECT    P.DIVISION_ID
                , A.ITEM_ID_ASSY        AS MODEL_ID     /* CA 원래 컬럼값 유지 */
                , P.PIC_ID
                , P.SALES_MODEL
                , P.SALES_VALID_YN
                , P.SALES_PRIORITY
                , P.SALES_FROM_YYYYMMDD
                , P.SALES_TO_YYYYMMDD
                , P.USER_ID
                , P.LEVEL1_GROUP
                , P.LEVEL2_CODE
                , P.STATUS_PROTOTYPE
                , P.STATUS_MASS
                , P.REPLACEMENT
                , P.END_CUSTOMER
                , P.FINISHED_PRODUCT
                , P.MKT_DEPT
                , P.REMARK
                , P.GROUP_CODE1
                , P.GROUP_CODE2
                , P.GROUP_CODE3
                , P.GROUP_CODE4
                , P.GROUP_CODE5
                , P.GROUP_CODE6
                , P.GROUP_CODE7
                , P.GROUP_CODE8
                , P.GROUP_CODE9
                , P.GROUP_CODE10
                , P.ATTRIBUTE1
                , P.ATTRIBUTE2
                , P.ATTRIBUTE3
                , P.ATTRIBUTE4
                , P.ATTRIBUTE5
                , P.ATTRIBUTE6
                , P.ATTRIBUTE7
                , I.ATTRIBUTE8          /* CA 원래 컬럼값 유지(Cell Type) */
                , P.ATTRIBUTE9
                , P.ATTRIBUTE10
        FROM    (
                    SELECT DISTINCT
                              DIVISION_ID
                            , ITEM_ID_PROD
                            , ITEM_ID_ASSY
                    FROM    SCP_MST_CELL_PROD_ASSY_MAP
                    WHERE   1=1
                        AND VALID_YN      = 'Y'
                ) A
                , GT_0080_SAVE_MAIN P
                , SCP_MST_FINAL_ITEM I
        WHERE   A.DIVISION_ID   = P.DIVISION_ID
            AND A.ITEM_ID_PROD  = P.MODEL_ID
            AND A.DIVISION_ID   = I.DIVISION_ID
            AND A.ITEM_ID_ASSY  = I.ITEM_ID;
        /* CA 임시테이블에 값 저장 end------------------------------------------------------------- */

        /* CP 저장 begin--------------------------------------------------------------------------- */
        MERGE INTO SCP_MST_FINAL_ITEM M
        USING
        (
            SELECT    DIVISION_ID
                    , MODEL_ID
                    , PIC_ID
                    , SALES_MODEL
                    , SALES_VALID_YN
                    , SALES_PRIORITY
                    , SALES_FROM_YYYYMMDD
                    , SALES_TO_YYYYMMDD
                    , USER_ID
                    , LEVEL1_GROUP
                    , LEVEL2_CODE
                    , STATUS_PROTOTYPE
                    , STATUS_MASS
                    , REPLACEMENT
                    , END_CUSTOMER
                    , FINISHED_PRODUCT
                    , MKT_DEPT
                    , REMARK
                    , GROUP_CODE1
                    , GROUP_CODE2
                    , GROUP_CODE3
                    , GROUP_CODE4
                    , GROUP_CODE5
                    , GROUP_CODE6
                    , GROUP_CODE7
                    , GROUP_CODE8
                    , GROUP_CODE9
                    , GROUP_CODE10
                    /* 수정불가 : ATTRIBUTE1 ~ ATTRIBUTE6 */
                    , ATTRIBUTE7
                    /* 수정불가 : ATTRIBUTE8 ~ ATTRIBUTE10 */
            FROM    GT_0080_SAVE_MAIN
        ) A ON
        (
                M.DIVISION_ID = A.DIVISION_ID
            AND M.ITEM_ID     = A.MODEL_ID
        )
        WHEN MATCHED THEN
            UPDATE
            SET
                  M.ATTRIBUTE6              = A.PIC_ID
                , M.SALES_MODEL             = A.SALES_MODEL
                , M.SALES_VALID_YN          = A.SALES_VALID_YN
                , M.SALES_PRIORITY          = A.SALES_PRIORITY
                , M.SALES_FROM_YYYYMMDD     = A.SALES_FROM_YYYYMMDD
                , M.SALES_TO_YYYYMMDD       = A.SALES_TO_YYYYMMDD
                , M.LEVEL1_GROUP            = A.LEVEL1_GROUP
                , M.LEVEL2_CODE             = A.LEVEL2_CODE
                , M.STATUS_PROTOTYPE        = A.STATUS_PROTOTYPE
                , M.STATUS_MASS             = A.STATUS_MASS
                , M.REPLACEMENT             = A.REPLACEMENT
                , M.END_CUSTOMER            = A.END_CUSTOMER
                , M.FINISHED_PRODUCT        = A.FINISHED_PRODUCT
                , M.MKT_DEPT                = A.MKT_DEPT
                , M.REMARK                  = A.REMARK
                , M.GROUP_CODE1             = A.GROUP_CODE1
                , M.GROUP_CODE2             = A.GROUP_CODE2
                , M.GROUP_CODE3             = A.GROUP_CODE3
                , M.GROUP_CODE4             = A.GROUP_CODE4
                , M.GROUP_CODE5             = A.GROUP_CODE5
                , M.GROUP_CODE6             = A.GROUP_CODE6
                , M.GROUP_CODE7             = A.GROUP_CODE7
                , M.GROUP_CODE8             = A.GROUP_CODE8
                , M.GROUP_CODE9             = A.GROUP_CODE9
                , M.GROUP_CODE10            = A.GROUP_CODE10
                , M.ATTRIBUTE7              = A.ATTRIBUTE7
                , M.LAST_UPDATED_BY         = A.USER_ID
                , M.LAST_UPDATE_DATE        = SYSDATE;
        /* CP 저장 end----------------------------------------------------------------------------- */

        /* CA 저장 begin--------------------------------------------------------------------------- */
        MERGE INTO SCP_MST_FINAL_ITEM M
        USING
        (
            SELECT    DIVISION_ID
                    , MODEL_ID
                    , PIC_ID
                    , SALES_MODEL
                    , SALES_VALID_YN
                    , SALES_PRIORITY
                    , SALES_FROM_YYYYMMDD
                    , SALES_TO_YYYYMMDD
                    , USER_ID
                    , LEVEL1_GROUP
                    , LEVEL2_CODE
                    , STATUS_PROTOTYPE
                    , STATUS_MASS
                    , REPLACEMENT
                    , END_CUSTOMER
                    , FINISHED_PRODUCT
                    , MKT_DEPT
                    , REMARK
                    , GROUP_CODE1
                    , GROUP_CODE2
                    , GROUP_CODE3
                    , GROUP_CODE4
                    , GROUP_CODE5
                    , GROUP_CODE6
                    , GROUP_CODE7
                    , GROUP_CODE8
                    , GROUP_CODE9
                    , GROUP_CODE10
                    /* 수정불가 : ATTRIBUTE1 ~ ATTRIBUTE6 */
                    , ATTRIBUTE7
                    /* 수정불가 : ATTRIBUTE8 ~ ATTRIBUTE10 */
            FROM    GT_0080_SAVE_MAIN_CA
        ) A ON
        (
                M.DIVISION_ID = A.DIVISION_ID
            AND M.ITEM_ID     = A.MODEL_ID
        )
        WHEN MATCHED THEN
            UPDATE
            SET
                  M.ATTRIBUTE6              = A.PIC_ID
                , M.SALES_MODEL             = A.SALES_MODEL
                , M.SALES_VALID_YN          = A.SALES_VALID_YN
                , M.SALES_PRIORITY          = A.SALES_PRIORITY
                , M.SALES_FROM_YYYYMMDD     = A.SALES_FROM_YYYYMMDD
                , M.SALES_TO_YYYYMMDD       = A.SALES_TO_YYYYMMDD
                , M.LEVEL1_GROUP            = A.LEVEL1_GROUP
                , M.LEVEL2_CODE             = A.LEVEL2_CODE
                , M.STATUS_PROTOTYPE        = A.STATUS_PROTOTYPE
                , M.STATUS_MASS             = A.STATUS_MASS
                , M.REPLACEMENT             = A.REPLACEMENT
                , M.END_CUSTOMER            = A.END_CUSTOMER
                , M.FINISHED_PRODUCT        = A.FINISHED_PRODUCT
                , M.MKT_DEPT                = A.MKT_DEPT
                , M.REMARK                  = A.REMARK
                , M.GROUP_CODE1             = A.GROUP_CODE1
                , M.GROUP_CODE2             = A.GROUP_CODE2
                , M.GROUP_CODE3             = A.GROUP_CODE3
                , M.GROUP_CODE4             = A.GROUP_CODE4
                , M.GROUP_CODE5             = A.GROUP_CODE5
                , M.GROUP_CODE6             = A.GROUP_CODE6
                , M.GROUP_CODE7             = A.GROUP_CODE7
                , M.GROUP_CODE8             = A.GROUP_CODE8
                , M.GROUP_CODE9             = A.GROUP_CODE9
                , M.GROUP_CODE10            = A.GROUP_CODE10
                , M.ATTRIBUTE7              = A.ATTRIBUTE7
                , M.LAST_UPDATED_BY         = A.USER_ID
                , M.LAST_UPDATE_DATE        = SYSDATE;
        /* CA 저장 end----------------------------------------------------------------------------- */

        /* CP 이력 저장 begin---------------------------------------------------------------------- */
        INSERT INTO SCP_MST_FINAL_ITEM_H
                  (
                    HISTORY_SEQ
                  , DIVISION_ID
                  , ITEM_ID
                  , NICK_NAME
                  , ITEM_CLASS
                  , OPERATION_GROUP
                  , OPERATION_GROUP_ID
                  , ELECTRODE_TYPE
                  , FLOW_ID
                  , DEMAND_GROUPING_DAYS
                  , CREATED_BY
                  , CREATION_DATE
                  , LAST_UPDATED_BY
                  , LAST_UPDATE_DATE
                  , HISTORY_CREATION_DATE
                  , TCO_CELL_YN
                  , SALES_MODEL
                  , SALES_VALID_YN
                  , SALES_PRIORITY
                  , SALES_FROM_YYYYMMDD
                  , SALES_TO_YYYYMMDD
                  , LEVEL1_GROUP
                  , LEVEL2_CODE
                  , STATUS_PROTOTYPE
                  , STATUS_MASS
                  , STATUS_NEW
                  , REPLACEMENT
                  , END_CUSTOMER
                  , FINISHED_PRODUCT
                  , MKT_DEPT
                  , REMARK
                  , GROUP_CODE1
                  , GROUP_CODE2
                  , GROUP_CODE3
                  , GROUP_CODE4
                  , GROUP_CODE5
                  , GROUP_CODE6
                  , GROUP_CODE7
                  , GROUP_CODE8
                  , GROUP_CODE9
                  , GROUP_CODE10
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
        SELECT    SEQ1_SCP_MST_FINAL_ITEM_H.NEXTVAL      AS HISTORY_SEQ
                , M.DIVISION_ID
                , M.ITEM_ID
                , M.NICK_NAME
                , M.ITEM_CLASS
                , M.OPERATION_GROUP
                , M.OPERATION_GROUP_ID
                , M.ELECTRODE_TYPE
                , M.FLOW_ID
                , M.DEMAND_GROUPING_DAYS
                , M.CREATED_BY
                , M.CREATION_DATE
                , M.LAST_UPDATED_BY
                , M.LAST_UPDATE_DATE
                , SYSDATE                               AS HISTORY_CREATION_DATE
                , M.TCO_CELL_YN
                , M.SALES_MODEL
                , M.SALES_VALID_YN
                , M.SALES_PRIORITY
                , M.SALES_FROM_YYYYMMDD
                , M.SALES_TO_YYYYMMDD
                , M.LEVEL1_GROUP
                , M.LEVEL2_CODE
                , M.STATUS_PROTOTYPE
                , M.STATUS_MASS
                , M.STATUS_NEW
                , M.REPLACEMENT
                , M.END_CUSTOMER
                , M.FINISHED_PRODUCT
                , M.MKT_DEPT
                , M.REMARK
                , M.GROUP_CODE1
                , M.GROUP_CODE2
                , M.GROUP_CODE3
                , M.GROUP_CODE4
                , M.GROUP_CODE5
                , M.GROUP_CODE6
                , M.GROUP_CODE7
                , M.GROUP_CODE8
                , M.GROUP_CODE9
                , M.GROUP_CODE10
                , M.ATTRIBUTE1
                , M.ATTRIBUTE2
                , M.ATTRIBUTE3
                , M.ATTRIBUTE4
                , M.ATTRIBUTE5
                , M.ATTRIBUTE6
                , M.ATTRIBUTE7
                , M.ATTRIBUTE8
                , M.ATTRIBUTE9
                , M.ATTRIBUTE10
        FROM      GT_0080_SAVE_MAIN T
                , SCP_MST_FINAL_ITEM M
        WHERE   T.DIVISION_ID   = M.DIVISION_ID
            AND T.MODEL_ID      = M.ITEM_ID;
        /* CP 이력 저장 end------------------------------------------------------------------------ */

        /* CA 이력 저장 begin---------------------------------------------------------------------- */
        INSERT INTO SCP_MST_FINAL_ITEM_H
                  (
                    HISTORY_SEQ
                  , DIVISION_ID
                  , ITEM_ID
                  , NICK_NAME
                  , ITEM_CLASS
                  , OPERATION_GROUP
                  , OPERATION_GROUP_ID
                  , ELECTRODE_TYPE
                  , FLOW_ID
                  , DEMAND_GROUPING_DAYS
                  , CREATED_BY
                  , CREATION_DATE
                  , LAST_UPDATED_BY
                  , LAST_UPDATE_DATE
                  , HISTORY_CREATION_DATE
                  , TCO_CELL_YN
                  , SALES_MODEL
                  , SALES_VALID_YN
                  , SALES_PRIORITY
                  , SALES_FROM_YYYYMMDD
                  , SALES_TO_YYYYMMDD
                  , LEVEL1_GROUP
                  , LEVEL2_CODE
                  , STATUS_PROTOTYPE
                  , STATUS_MASS
                  , STATUS_NEW
                  , REPLACEMENT
                  , END_CUSTOMER
                  , FINISHED_PRODUCT
                  , MKT_DEPT
                  , REMARK
                  , GROUP_CODE1
                  , GROUP_CODE2
                  , GROUP_CODE3
                  , GROUP_CODE4
                  , GROUP_CODE5
                  , GROUP_CODE6
                  , GROUP_CODE7
                  , GROUP_CODE8
                  , GROUP_CODE9
                  , GROUP_CODE10
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
        SELECT    SEQ1_SCP_MST_FINAL_ITEM_H.NEXTVAL      AS HISTORY_SEQ
                , M.DIVISION_ID
                , M.ITEM_ID
                , M.NICK_NAME
                , M.ITEM_CLASS
                , M.OPERATION_GROUP
                , M.OPERATION_GROUP_ID
                , M.ELECTRODE_TYPE
                , M.FLOW_ID
                , M.DEMAND_GROUPING_DAYS
                , M.CREATED_BY
                , M.CREATION_DATE
                , M.LAST_UPDATED_BY
                , M.LAST_UPDATE_DATE
                , SYSDATE                               AS HISTORY_CREATION_DATE
                , M.TCO_CELL_YN
                , M.SALES_MODEL
                , M.SALES_VALID_YN
                , M.SALES_PRIORITY
                , M.SALES_FROM_YYYYMMDD
                , M.SALES_TO_YYYYMMDD
                , M.LEVEL1_GROUP
                , M.LEVEL2_CODE
                , M.STATUS_PROTOTYPE
                , M.STATUS_MASS
                , M.STATUS_NEW
                , M.REPLACEMENT
                , M.END_CUSTOMER
                , M.FINISHED_PRODUCT
                , M.MKT_DEPT
                , M.REMARK
                , M.GROUP_CODE1
                , M.GROUP_CODE2
                , M.GROUP_CODE3
                , M.GROUP_CODE4
                , M.GROUP_CODE5
                , M.GROUP_CODE6
                , M.GROUP_CODE7
                , M.GROUP_CODE8
                , M.GROUP_CODE9
                , M.GROUP_CODE10
                , M.ATTRIBUTE1
                , M.ATTRIBUTE2
                , M.ATTRIBUTE3
                , M.ATTRIBUTE4
                , M.ATTRIBUTE5
                , M.ATTRIBUTE6
                , M.ATTRIBUTE7
                , M.ATTRIBUTE8
                , M.ATTRIBUTE9
                , M.ATTRIBUTE10
        FROM      GT_0080_SAVE_MAIN_CA T
                , SCP_MST_FINAL_ITEM M
        WHERE   T.DIVISION_ID   = M.DIVISION_ID
            AND T.MODEL_ID      = M.ITEM_ID;
        /* CA 이력 저장 end------------------------------------------------------------------------ */

        SELECT  COUNT(1)
        INTO    V_MOD_CNT
        FROM    GT_0080_SAVE_MAIN;

        /* LOG end */
        V_LOG_TYPE      := 'END';
        V_LOG_MESSAGE   := '########## END of procedure ##########';
        V_DESCRIPTION   := '';
        D_EVENT_DATE    := SYSDATE;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, NULL, NULL, NULL, NULL);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        O_RESULT_CODE := 'S';
        O_RESULT_CNT  := V_MOD_CNT;
        O_RESULT_MSG  := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;

            /* SQLERRM 은 SQL 문 안에서 바로 쓸 수 없어 변수로 받는다 */
            V_ERR_MSG := SUBSTR(SQLERRM, 1, 1000);

            INSERT INTO SCM_SYS_LOG_BATCH
                      (
                        PROGRAM_NAME
                      , LOG_TYPE
                      , LOG_COUNT
                      , LOG_MESSAGE
                      , DESCRIPTION
                      , EVENT_DATE
                      , CREATION_DATE
                      , CREATED_BY
                      , LAST_UPDATE_DATE
                      , LAST_UPDATED_BY
                      )
            VALUES
                      (
                        V_PROGRAM_NAME
                      , 'ERROR'
                      , NULL
                      , V_ERR_MSG
                      , NULL
                      , SYSDATE
                      , SYSDATE
                      , V_PROGRAM_NAME
                      , SYSDATE
                      , V_PROGRAM_NAME
                      );

            COMMIT;

            /* error코드, error 메시지 반환 */
            O_RESULT_CODE := 'F';
            O_RESULT_CNT  := 0;
            O_RESULT_MSG  := '[' || SQLCODE || ']' || SQLERRM;

    END P_SCP0080_SAVE_GROUP_CODE_MANAGEMENT;


    /* ------------------------------------------------------------
       담당자 조회 팝업
       ------------------------------------------------------------ */
    PROCEDURE P_SCP0050_GET_CAPA_PIC_USERINFO_POPUP
    (
        P_SEARCH                IN  VARCHAR2,
        P_LANGUAGE              IN  VARCHAR2 DEFAULT 'KO',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
    BEGIN

        O_RESULT_CODE := 'S';

        OPEN O_RC1 FOR
            SELECT    UI.USER_ID
                    , UI.USER_NAME
                    , UI.USER_NAME_EN
                    , UI.DEPT_ID
                    , DI.DEPT_NAME_KO   AS DEPT_NAME
                    , UI.COMPANY_ID
                    , UI.WORKING_CODE
                    , UI.WORKING_NAME
                    , UI.SSO_LOCATE
            FROM      SCM_MST_SSO_USER_INFO UI
                    , SCM_MST_SSO_DEPT_INFO DI
            WHERE   UI.DEPT_ID = DI.DEPT_ID
                AND (   (P_SEARCH IS NULL OR UPPER(UI.USER_ID)      LIKE '%' || UPPER(P_SEARCH) || '%')
                     OR (P_SEARCH IS NULL OR UPPER(UI.USER_NAME)    LIKE '%' || UPPER(P_SEARCH) || '%')
                     OR (P_SEARCH IS NULL OR UPPER(UI.USER_NAME_EN) LIKE '%' || UPPER(P_SEARCH) || '%'));
                /* AS-IS 는 대소문자를 가리지 않는 정렬규칙(CI)이라 'AHN' 으로 'Ahn'·'ahn' 까지 찾는다.  */
                /* Oracle 은 대소문자를 가리므로 양쪽을 대문자로 맞춘다.                                 */
                /* 사용자 영문명에 소문자가 섞인 행이 89,271 건이라 이 처리가 없으면 건수가 갈린다        */
                /* (실측 : 'AHN' 검색 AS-IS 556 건 대 조치 전 208 건).                                  */
                /* 조회조건 칸에 함수를 쓰지 않는다는 성능 규칙보다 결과 동일성을 앞세운 자리다.          */

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || SQLCODE || ']' || SQLERRM;

            IF O_RC1%ISOPEN THEN
                CLOSE O_RC1;
            END IF;

            OPEN O_RC1 FOR
                SELECT    NULL AS USER_ID
                        , NULL AS USER_NAME
                        , NULL AS USER_NAME_EN
                        , NULL AS DEPT_ID
                        , NULL AS DEPT_NAME
                        , NULL AS COMPANY_ID
                        , NULL AS WORKING_CODE
                        , NULL AS WORKING_NAME
                        , NULL AS SSO_LOCATE
                FROM    DUAL
                WHERE   1=0;

    END P_SCP0050_GET_CAPA_PIC_USERINFO_POPUP;

END PKG_SCP0080;