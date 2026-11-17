CREATE OR REPLACE PACKAGE BODY PKG_SCP0104
IS

/* ── 패키지 내부 전용 ─────────────────────────────────────────────────────── */

/****************************************************************************************************/
/* Program ID  : P_SCP0104_SPLIT_CLOB                                                               */
/* Description : 화면이 보내는 긴 칸 값을 구분자로 풀어 자리 번호와 함께 적재                       */
/*               (원문은 dbo.String_Split 을 쓰나 전달값이 길어 CLOB 로 받으므로 따로 둔다)         */
/****************************************************************************************************/
PROCEDURE P_SCP0104_SPLIT_CLOB
(
    P_SLOT_NO               IN  NUMBER
  , P_CLOB                  IN  CLOB
  , P_DELIM                 IN  VARCHAR2
)
IS
    V_LEN       NUMBER      := NVL(DBMS_LOB.GETLENGTH(P_CLOB), 0);
    V_FROM      NUMBER      := 1;
    V_POS       NUMBER      := 0;
    V_NR        NUMBER      := 0;
    V_TOKEN     VARCHAR2(32767 CHAR);
BEGIN

    IF V_LEN = 0 THEN
        RETURN;
    END IF;

    LOOP

        V_POS := DBMS_LOB.INSTR(P_CLOB, P_DELIM, V_FROM, 1);
        V_NR  := V_NR + 1;

        IF V_POS = 0 THEN

            V_TOKEN := DBMS_LOB.SUBSTR(P_CLOB, V_LEN - V_FROM + 1, V_FROM);

            INSERT INTO GT_SCP0104_ASGN_TOKEN
                        ( SLOT_NO
                        , NR
                        , TOKEN )
                 VALUES ( P_SLOT_NO
                        , V_NR
                        , CASE WHEN V_TOKEN IS NULL THEN NULL ELSE V_TOKEN END );

            EXIT;

        END IF;

        IF V_POS > V_FROM THEN
            V_TOKEN := DBMS_LOB.SUBSTR(P_CLOB, V_POS - V_FROM, V_FROM);
        ELSE
            V_TOKEN := NULL;
        END IF;

        INSERT INTO GT_SCP0104_ASGN_TOKEN
                    ( SLOT_NO
                    , NR
                    , TOKEN )
             VALUES ( P_SLOT_NO
                    , V_NR
                    , V_TOKEN );

        V_FROM := V_POS + LENGTH(P_DELIM);

        IF V_FROM > V_LEN THEN
            EXIT;
        END IF;

    END LOOP;

END P_SCP0104_SPLIT_CLOB;


/* SCP0104 라인 배정 저장만 부르는 검증 갈래 — 화면에서 직접 부르지 않는다 */

/****************************************************************************************************/
/* Program ID  : P_SCP0105_CHK_SPEED_ASGN_ASM                                                  */
/* Description : ASSIGN 테이블 구조의 데이터를 파라미터로 Speed Plan Insert/Update — 조립           */
/*               전달 테이블은 GT_SCP_CAPA_LINE_ASSIGN_KEYS 로 받는다(부르는 쪽이 채운다)           */
/****************************************************************************************************/
PROCEDURE P_SCP0105_CHK_SPEED_ASGN_ASM
(
    P_PROGRAM_ID            IN  VARCHAR2
  , P_SHEET_NAME            IN  VARCHAR2
  , P_USER_ID               IN  VARCHAR2
  , P_DEBUG_MODE            IN  VARCHAR2
)
IS
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ASSEMBLY';
    V_STAMP             VARCHAR2(800 CHAR);
BEGIN

    V_STAMP := V_PROGRAM_NAME || '-' || P_USER_ID;

    DELETE GT_SCP0105_CHK_NOT_VALID;
    DELETE GT_SCP0105_CHK_RAW;

    INSERT INTO GT_SCP0105_CHK_NOT_VALID
                ( DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , NICK_NAME )
         SELECT DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , NICK_NAME
           FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS
          WHERE VALID_YN <> 'Y'
          GROUP BY DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , NICK_NAME;

    INSERT INTO GT_SCP0105_CHK_RAW
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , MSR_TP_CD
                , YYYYMM
                , BASE_QTY
                , PFRSLT_QTY
                , QTY
                , UI_UPD_YN
                , REMARK
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
         SELECT A.VER_ID
              , A.VER_SEQ
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.ITEM_ID
              , A.NICK_NAME
              , A.MSR_TP_CD
              , A.YYYYMM
              , A.BASE_QTY
              , A.PFRSLT_QTY
              , CASE WHEN NVL(B.ASSIGN_PRIORITY, 0) = 0 THEN NULL
                     ELSE A.QTY
                END
              , A.UI_UPD_YN
              , A.REMARK
              , B.CREATED_BY
              , B.CREATION_DATE
              , B.LAST_UPDATED_BY
              , B.LAST_UPDATE_DATE
           FROM SCP_MST_CAPA_SPEED_PLAN_NEW_V A
              , GT_SCP_CAPA_LINE_ASSIGN_KEYS B
          WHERE B.DIVISION_ID   = A.DIVISION_ID
            AND B.COMPANY_ID    = A.COMPANY_ID
            AND B.SITE_ID       = A.SITE_ID
            AND B.PLANT_ID      = A.PLANT_ID
            AND B.FACTORY_ID    = A.FACTORY_ID
            AND B.LINE_ID       = A.LINE_ID
            AND B.OPERATION_ID  = A.OPERATION_ID
            AND B.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
            AND B.NICK_NAME     = A.NICK_NAME
            AND B.YYYYMM        = A.YYYYMM;

    DELETE GT_SCP0105_CHK_RAW A
     WHERE EXISTS (SELECT 1
                     FROM GT_SCP0105_CHK_NOT_VALID XA
                    WHERE XA.DIVISION_ID   = A.DIVISION_ID
                      AND XA.COMPANY_ID    = A.COMPANY_ID
                      AND XA.SITE_ID       = A.SITE_ID
                      AND XA.PLANT_ID      = A.PLANT_ID
                      AND XA.FACTORY_ID    = A.FACTORY_ID
                      AND XA.LINE_ID       = A.LINE_ID
                      AND XA.OPERATION_ID  = A.OPERATION_ID
                      AND XA.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                      AND XA.NICK_NAME     = A.NICK_NAME);

    /* INSERT - SCP_MST_CAPA_SPEED_PLAN - BEGIN
       원문은 MERGE 한 문장이나 온라인 SQL 에서 쓰지 않는 규칙이라 고치는 문장과 넣는 문장으로 나눈다 */
    FOR R IN (SELECT DIVISION_ID
                   , COMPANY_ID
                   , SITE_ID
                   , PLANT_ID
                   , FACTORY_ID
                   , LINE_ID
                   , OPERATION_ID
                   , ELTR_LN_TP_CD
                   , ITEM_ID
                   , NICK_NAME
                   , MSR_TP_CD
                   , YYYYMM
                   , BASE_QTY
                   , QTY
                   , UI_UPD_YN
                   , REMARK
                FROM GT_SCP0105_CHK_RAW
               WHERE DIVISION_ID   IS NOT NULL
                 AND COMPANY_ID    IS NOT NULL
                 AND SITE_ID       IS NOT NULL
                 AND PLANT_ID      IS NOT NULL
                 AND FACTORY_ID    IS NOT NULL
                 AND LINE_ID       IS NOT NULL
                 AND OPERATION_ID  IS NOT NULL
                 AND ELTR_LN_TP_CD IS NOT NULL
                 AND ITEM_ID       IS NOT NULL
                 AND NICK_NAME     IS NOT NULL
                 AND MSR_TP_CD     IS NOT NULL
                 AND YYYYMM        IS NOT NULL)
    LOOP

        UPDATE SCP_MST_CAPA_SPEED_PLAN
           SET UI_UPD_YN        = R.UI_UPD_YN
             , LAST_UPDATED_BY  = V_STAMP
             , LAST_UPDATE_DATE = SYSDATE
         WHERE DIVISION_ID   = R.DIVISION_ID
           AND COMPANY_ID    = R.COMPANY_ID
           AND SITE_ID       = R.SITE_ID
           AND PLANT_ID      = R.PLANT_ID
           AND FACTORY_ID    = R.FACTORY_ID
           AND LINE_ID       = R.LINE_ID
           AND OPERATION_ID  = R.OPERATION_ID
           AND ELTR_LN_TP_CD = R.ELTR_LN_TP_CD
           AND ITEM_ID       = R.ITEM_ID
           AND NICK_NAME     = R.NICK_NAME
           AND MSR_TP_CD     = R.MSR_TP_CD
           AND YYYYMM        = R.YYYYMM;

        IF SQL%ROWCOUNT = 0 THEN

            INSERT INTO SCP_MST_CAPA_SPEED_PLAN
                        ( DIVISION_ID
                        , COMPANY_ID
                        , SITE_ID
                        , PLANT_ID
                        , FACTORY_ID
                        , LINE_ID
                        , OPERATION_ID
                        , ELTR_LN_TP_CD
                        , ITEM_ID
                        , NICK_NAME
                        , MSR_TP_CD
                        , YYYYMM
                        , BASE_QTY
                        , QTY
                        , UI_UPD_YN
                        , REMARK
                        , CREATED_BY
                        , CREATION_DATE
                        , LAST_UPDATED_BY
                        , LAST_UPDATE_DATE )
                 VALUES ( R.DIVISION_ID
                        , R.COMPANY_ID
                        , R.SITE_ID
                        , R.PLANT_ID
                        , R.FACTORY_ID
                        , R.LINE_ID
                        , R.OPERATION_ID
                        , R.ELTR_LN_TP_CD
                        , R.ITEM_ID
                        , R.NICK_NAME
                        , R.MSR_TP_CD
                        , R.YYYYMM
                        , R.BASE_QTY
                        , R.QTY
                        , R.UI_UPD_YN
                        , R.REMARK
                        , V_STAMP
                        , SYSDATE
                        , V_STAMP
                        , SYSDATE );

        END IF;

    END LOOP;

    DELETE SCP_MST_CAPA_SPEED_PLAN A
     WHERE EXISTS (SELECT 1
                     FROM GT_SCP0105_CHK_NOT_VALID XA
                    WHERE XA.DIVISION_ID   = A.DIVISION_ID
                      AND XA.COMPANY_ID    = A.COMPANY_ID
                      AND XA.SITE_ID       = A.SITE_ID
                      AND XA.PLANT_ID      = A.PLANT_ID
                      AND XA.FACTORY_ID    = A.FACTORY_ID
                      AND XA.LINE_ID       = A.LINE_ID
                      AND XA.OPERATION_ID  = A.OPERATION_ID
                      AND XA.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                      AND XA.NICK_NAME     = A.NICK_NAME);

    UPDATE SCP_MST_CAPA_SPEED_PLAN A
       SET A.QTY = NULL
     WHERE EXISTS (SELECT 1
                     FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XA
                    WHERE XA.DIVISION_ID   = A.DIVISION_ID
                      AND XA.COMPANY_ID    = A.COMPANY_ID
                      AND XA.SITE_ID       = A.SITE_ID
                      AND XA.PLANT_ID      = A.PLANT_ID
                      AND XA.FACTORY_ID    = A.FACTORY_ID
                      AND XA.LINE_ID       = A.LINE_ID
                      AND XA.OPERATION_ID  = A.OPERATION_ID
                      AND XA.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                      AND XA.NICK_NAME     = A.NICK_NAME
                      AND XA.YYYYMM        = A.YYYYMM
                      AND NVL(XA.ASSIGN_PRIORITY, 0) = 0);
    /* INSERT - SCP_MST_CAPA_SPEED_PLAN - END */

    /* 아예 삭제함 */
    DELETE SCP_MST_CAPA_SPEED_PLAN A
     WHERE EXISTS (SELECT 1
                     FROM SCP_MST_CAPA_LINE_ASSIGN XA
                    WHERE XA.DIVISION_ID   = A.DIVISION_ID
                      AND XA.COMPANY_ID    = A.COMPANY_ID
                      AND XA.SITE_ID       = A.SITE_ID
                      AND XA.PLANT_ID      = A.PLANT_ID
                      AND XA.FACTORY_ID    = A.FACTORY_ID
                      AND XA.LINE_ID       = A.LINE_ID
                      AND XA.OPERATION_ID  = A.OPERATION_ID
                      AND XA.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                      AND XA.NICK_NAME     = A.NICK_NAME
                      AND XA.YYYYMM        = A.YYYYMM
                      AND (XA.ASSIGN_PRIORITY = 0 OR XA.VALID_YN <> 'Y'));

END P_SCP0105_CHK_SPEED_ASGN_ASM;


/****************************************************************************************************/
/* Program ID  : P_SCP0105_CHK_SPEED_ASGN_ELTR                                                 */
/* Description : ASSIGN 테이블 구조의 데이터를 파라미터로 Speed Plan Insert/Update — 전극           */
/*               전달 테이블은 GT_SCP_CAPA_LINE_ASSIGN_KEYS 로 받는다(부르는 쪽이 채운다)           */
/****************************************************************************************************/
PROCEDURE P_SCP0105_CHK_SPEED_ASGN_ELTR
(
    P_PROGRAM_ID            IN  VARCHAR2
  , P_SHEET_NAME            IN  VARCHAR2
  , P_USER_ID               IN  VARCHAR2
  , P_DEBUG_MODE            IN  VARCHAR2
)
IS
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ELTR';
    V_STAMP             VARCHAR2(800 CHAR);
    V_NOT_VALID_CNT     NUMBER(9)          := 0;
    V_VERSION           VARCHAR2(40 CHAR);
    V_VERSION_SEQ       NUMBER(3);
    V_RESULT_TO_YYYYMM  VARCHAR2(6 CHAR);
BEGIN

    V_STAMP := V_PROGRAM_NAME || '-' || P_USER_ID;

    DELETE GT_SCP0105_CHK_NOT_VALID;
    DELETE GT_SCP0105_CHK_RSLT_QTY;
    DELETE GT_SCP0105_CHK_EQP;
    DELETE GT_SCP0105_CHK_BASE_KEY;
    DELETE GT_SCP0105_CHK_BASE_QTY;
    DELETE GT_SCP0105_CHK_RAW_TEMP;
    DELETE GT_SCP0105_CHK_RAW1;
    DELETE GT_SCP0105_CHK_RAW;

    INSERT INTO GT_SCP0105_CHK_NOT_VALID
                ( DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME )
         SELECT DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , ITEM_ID
              , NICK_NAME
           FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS
          WHERE VALID_YN <> 'Y'
          GROUP BY DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , ITEM_ID
                 , NICK_NAME;

    SELECT COUNT(*)
      INTO V_NOT_VALID_CNT
      FROM GT_SCP0105_CHK_NOT_VALID;

    SELECT MAX(VER_ID)
         , MAX(VER_SEQ)
      INTO V_VERSION
         , V_VERSION_SEQ
      FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS;

    /* 버전의 앞달을 실적 기준월로 쓴다 */
    V_RESULT_TO_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -1), 'YYYYMM');

    /* GET - RESULT - BEGIN */
    INSERT INTO GT_SCP0105_CHK_RSLT_QTY
                ( DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , MSR_TP_CD
                , QTY )
         SELECT DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , MDL_NM
              , '-'
              , 'EQP_SPED'
              , AVG(EQP_SPED)
           FROM SCM_DNM_ELTR_EQP_SPED_MMLY
          WHERE PERD_DIVS_CD = '3'
            AND PFRSLT_YM    = V_RESULT_TO_YYYYMM
          GROUP BY DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , MDL_NM;
    /* GET - RESULT - END */

    /* GET - BASE - BEGIN
       BASE 테이블을 SCP_MST_MDL_EQP_SPED => EQUIPMENT 로 대체 */
    INSERT INTO GT_SCP0105_CHK_EQP
                ( COMPANY_ID
                , DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , EQUIPMENT_ID
                , EQUIPMENT_NAME
                , ELTR_LN_TP_CD
                , ITEM_ID
                , EQP_NBU
                , EQP_SPED )
         SELECT IA.COMPANY_ID
              , IA.DIVISION_ID
              , IA.SITE_ID
              , IA.PLANT_ID
              , IA.FACTORY_ID
              , IA.LINE_ID
              , IA.OPERATION_ID
              , IA.EQUIPMENT_ID
              , IA.EQUIPMENT_NAME
              , IA.ELTR_LN_TP_CD
              , IA.BOM_ITEM_ID
              , NULL
              , AVG(IA.EQP_SPED)
           FROM (SELECT A.COMPANY_ID
                      , A.DIVISION_ID
                      , A.SITE_ID
                      , A.PLANT_ID
                      , A.FACTORY_ID
                      , A.LINE_ID
                      , A.OPERATION_ID
                      , B.BOM_ITEM_ID
                      , A.EQUIPMENT_ID
                      , A.EQUIPMENT_NAME
                      , CASE WHEN A.WIDE_ROLL_ENABLE_FLAG = 'Y' THEN 'W' ELSE 'S' END AS ELTR_LN_TP_CD
                      , B.EQP_SPED
                      , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                                      , A.SITE_ID
                                                      , A.COMPANY_ID
                                                      , A.PLANT_ID
                                                      , A.LINE_ID
                                                      , A.OPERATION_ID
                                                      , B.BOM_ITEM_ID
                                               ORDER BY B.UPDATE_TIME DESC
                                                      , A.UPDATE_TIME DESC) AS RN
                   FROM SCM_MST_EQUIPMENT_SN A
                      , SCM_MMD_EQPT_PRDT_SPEED_SN B
                  WHERE B.EQP_ID          = A.EQUIPMENT_ID
                    AND A.OPERATION_ID LIKE 'E2000%'   /* 전극 Coating 공정 (현재는 E2000 공정 하나만 대상) */
                    AND A.EQUIPMENT_TYPE  = 'M'        /* Main 설비 */
                    AND A.ACTIVE_FLAG     = 'Y') IA
          WHERE IA.RN = 1
          GROUP BY IA.COMPANY_ID
                 , IA.DIVISION_ID
                 , IA.SITE_ID
                 , IA.PLANT_ID
                 , IA.FACTORY_ID
                 , IA.LINE_ID
                 , IA.OPERATION_ID
                 , IA.EQUIPMENT_ID
                 , IA.EQUIPMENT_NAME
                 , IA.ELTR_LN_TP_CD
                 , IA.BOM_ITEM_ID;

    INSERT INTO GT_SCP0105_CHK_BASE_KEY
                ( DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , UI_UPD_YN )
         SELECT DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , ITEM_ID
              , '-'
              , 'N'
           FROM GT_SCP0105_CHK_EQP
          GROUP BY DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , ITEM_ID;

    INSERT INTO GT_SCP0105_CHK_BASE_QTY
                ( DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , MSR_TP_CD
                , QTY )
         SELECT DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , ITEM_ID
              , '-'
              , 'EQP_SPED'
              , AVG(EQP_SPED)
           FROM GT_SCP0105_CHK_EQP
          GROUP BY DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , ITEM_ID;
    /* GET - BASE - END */

    /* 배정 열쇠에 측정항목을 붙인다 — 측정항목은 EQP_SPED 만 */
    INSERT INTO GT_SCP0105_CHK_RAW_TEMP
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , MSR_TP_CD
                , YYYYMM
                , BASE_QTY
                , PFRSLT_QTY
                , QTY
                , UI_UPD_YN
                , REMARK
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
         SELECT V_VERSION
              , V_VERSION_SEQ
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.ITEM_ID
              , A.NICK_NAME
              , M.COLUMN_NAME
              , A.YYYYMM
              , NULL
              , NULL
              , NULL
              , 'N'
              , NULL
              , V_STAMP
              , SYSDATE
              , V_STAMP
              , SYSDATE
           FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS A
              , SCP_MST_CAPA_ELTR_LINE B
              , SCM_MST_SHEET_MEASURE M
          WHERE B.DIVISION_ID(+)   = A.DIVISION_ID
            AND B.COMPANY_ID(+)    = A.COMPANY_ID
            AND B.SITE_ID(+)       = A.SITE_ID
            AND B.PLANT_ID(+)      = A.PLANT_ID
            AND B.FACTORY_ID(+)    = A.FACTORY_ID
            AND B.LINE_ID(+)       = A.LINE_ID
            AND B.OPERATION_ID(+)  = A.OPERATION_ID
            AND B.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
            AND M.PROGRAM_ID       = P_PROGRAM_ID
            AND M.SHEET_NAME       = P_SHEET_NAME
            AND M.VALID_YN         = 'Y'
            AND M.COLUMN_NAME      = 'EQP_SPED';

    /* 기준값·실적값·화면수정여부를 붙인다 */
    INSERT INTO GT_SCP0105_CHK_RAW1
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , MSR_TP_CD
                , YYYYMM
                , BASE_QTY
                , PFRSLT_QTY
                , QTY
                , UI_UPD_YN
                , REMARK
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
         SELECT A.VER_ID
              , A.VER_SEQ
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.ITEM_ID
              , A.NICK_NAME
              , A.MSR_TP_CD
              , A.YYYYMM
              , BQ.QTY
              , RQ.QTY
              /* 기본값을 BASE 기준으로 */
              , BQ.QTY
              , NVL(BK.UI_UPD_YN, 'N')
              , A.REMARK
              , A.CREATED_BY
              , A.CREATION_DATE
              , A.LAST_UPDATED_BY
              , A.LAST_UPDATE_DATE
           FROM GT_SCP0105_CHK_RAW_TEMP A
              , GT_SCP0105_CHK_RSLT_QTY RQ
              , GT_SCP0105_CHK_BASE_KEY BK
              , GT_SCP0105_CHK_BASE_QTY BQ
          WHERE RQ.DIVISION_ID(+)   = A.DIVISION_ID
            AND RQ.COMPANY_ID(+)    = A.COMPANY_ID
            AND RQ.SITE_ID(+)       = A.SITE_ID
            AND RQ.PLANT_ID(+)      = A.PLANT_ID
            AND RQ.FACTORY_ID(+)    = A.FACTORY_ID
            AND RQ.LINE_ID(+)       = A.LINE_ID
            AND RQ.OPERATION_ID(+)  = A.OPERATION_ID
            AND RQ.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
            AND RQ.ITEM_ID(+)       = A.ITEM_ID
            AND BK.DIVISION_ID(+)   = A.DIVISION_ID
            AND BK.COMPANY_ID(+)    = A.COMPANY_ID
            AND BK.SITE_ID(+)       = A.SITE_ID
            AND BK.PLANT_ID(+)      = A.PLANT_ID
            AND BK.FACTORY_ID(+)    = A.FACTORY_ID
            AND BK.LINE_ID(+)       = A.LINE_ID
            AND BK.OPERATION_ID(+)  = A.OPERATION_ID
            AND BK.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
            AND BK.ITEM_ID(+)       = A.ITEM_ID
            AND BQ.DIVISION_ID(+)   = A.DIVISION_ID
            AND BQ.COMPANY_ID(+)    = A.COMPANY_ID
            AND BQ.SITE_ID(+)       = A.SITE_ID
            AND BQ.PLANT_ID(+)      = A.PLANT_ID
            AND BQ.FACTORY_ID(+)    = A.FACTORY_ID
            AND BQ.LINE_ID(+)       = A.LINE_ID
            AND BQ.OPERATION_ID(+)  = A.OPERATION_ID
            AND BQ.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
            AND BQ.ITEM_ID(+)       = A.ITEM_ID;

    /* 우선순위가 없으면 값을 비운다 */
    INSERT INTO GT_SCP0105_CHK_RAW
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , MSR_TP_CD
                , YYYYMM
                , BASE_QTY
                , PFRSLT_QTY
                , QTY
                , UI_UPD_YN
                , REMARK
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
         SELECT A.VER_ID
              , A.VER_SEQ
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.ITEM_ID
              , A.NICK_NAME
              , A.MSR_TP_CD
              , A.YYYYMM
              , A.BASE_QTY
              , A.PFRSLT_QTY
              , CASE WHEN NVL(B.ASSIGN_PRIORITY, 0) = 0 THEN NULL
                     ELSE A.QTY
                END
              , A.UI_UPD_YN
              , A.REMARK
              , A.CREATED_BY
              , A.CREATION_DATE
              , A.LAST_UPDATED_BY
              , A.LAST_UPDATE_DATE
           FROM GT_SCP0105_CHK_RAW1 A
              , GT_SCP_CAPA_LINE_ASSIGN_KEYS B
          WHERE B.DIVISION_ID(+)   = A.DIVISION_ID
            AND B.COMPANY_ID(+)    = A.COMPANY_ID
            AND B.SITE_ID(+)       = A.SITE_ID
            AND B.PLANT_ID(+)      = A.PLANT_ID
            AND B.FACTORY_ID(+)    = A.FACTORY_ID
            AND B.LINE_ID(+)       = A.LINE_ID
            AND B.OPERATION_ID(+)  = A.OPERATION_ID
            AND B.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
            AND B.ITEM_ID(+)       = A.ITEM_ID
            AND B.YYYYMM(+)        = A.YYYYMM;

    IF V_NOT_VALID_CNT > 0 THEN

        DELETE GT_SCP0105_CHK_RAW A
         WHERE EXISTS (SELECT 1
                         FROM GT_SCP0105_CHK_NOT_VALID XA
                        WHERE XA.DIVISION_ID   = A.DIVISION_ID
                          AND XA.COMPANY_ID    = A.COMPANY_ID
                          AND XA.SITE_ID       = A.SITE_ID
                          AND XA.PLANT_ID      = A.PLANT_ID
                          AND XA.FACTORY_ID    = A.FACTORY_ID
                          AND XA.LINE_ID       = A.LINE_ID
                          AND XA.OPERATION_ID  = A.OPERATION_ID
                          AND XA.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                          AND XA.ITEM_ID       = A.ITEM_ID);

    END IF;

    /* INSERT - SCP_MST_CAPA_ELTR_SPEED_PLAN - BEGIN
       원문은 MERGE 한 문장이나 온라인 SQL 에서 쓰지 않는 규칙이라 고치는 문장과 넣는 문장으로 나눈다
       ★열쇠에 전극 구분이 들어가지 않는다(원문 그대로) */
    FOR R IN (SELECT DIVISION_ID
                   , COMPANY_ID
                   , SITE_ID
                   , PLANT_ID
                   , FACTORY_ID
                   , LINE_ID
                   , OPERATION_ID
                   , ELTR_LN_TP_CD
                   , ITEM_ID
                   , NICK_NAME
                   , MSR_TP_CD
                   , YYYYMM
                   , BASE_QTY
                   , QTY
                   , UI_UPD_YN
                   , REMARK
                   , LAST_UPDATED_BY
                   , LAST_UPDATE_DATE
                FROM GT_SCP0105_CHK_RAW
               WHERE DIVISION_ID   IS NOT NULL
                 AND COMPANY_ID    IS NOT NULL
                 AND SITE_ID       IS NOT NULL
                 AND PLANT_ID      IS NOT NULL
                 AND FACTORY_ID    IS NOT NULL
                 AND LINE_ID       IS NOT NULL
                 AND OPERATION_ID  IS NOT NULL
                 AND ITEM_ID       IS NOT NULL
                 AND NICK_NAME     IS NOT NULL
                 AND MSR_TP_CD     IS NOT NULL
                 AND YYYYMM        IS NOT NULL)
    LOOP

        UPDATE SCP_MST_CAPA_ELTR_SPEED_PLAN
           SET UI_UPD_YN        = R.UI_UPD_YN
             , LAST_UPDATED_BY  = R.LAST_UPDATED_BY
             , LAST_UPDATE_DATE = R.LAST_UPDATE_DATE
         WHERE DIVISION_ID   = R.DIVISION_ID
           AND COMPANY_ID    = R.COMPANY_ID
           AND SITE_ID       = R.SITE_ID
           AND PLANT_ID      = R.PLANT_ID
           AND FACTORY_ID    = R.FACTORY_ID
           AND LINE_ID       = R.LINE_ID
           AND OPERATION_ID  = R.OPERATION_ID
           AND ITEM_ID       = R.ITEM_ID
           AND NICK_NAME     = R.NICK_NAME
           AND MSR_TP_CD     = R.MSR_TP_CD
           AND YYYYMM        = R.YYYYMM;

        IF SQL%ROWCOUNT = 0 THEN

            INSERT INTO SCP_MST_CAPA_ELTR_SPEED_PLAN
                        ( DIVISION_ID
                        , COMPANY_ID
                        , SITE_ID
                        , PLANT_ID
                        , FACTORY_ID
                        , LINE_ID
                        , OPERATION_ID
                        , ELTR_LN_TP_CD
                        , ITEM_ID
                        , NICK_NAME
                        , MSR_TP_CD
                        , YYYYMM
                        , BASE_QTY
                        , QTY
                        , UI_UPD_YN
                        , REMARK
                        , CREATED_BY
                        , CREATION_DATE
                        , LAST_UPDATED_BY
                        , LAST_UPDATE_DATE )
                 VALUES ( R.DIVISION_ID
                        , R.COMPANY_ID
                        , R.SITE_ID
                        , R.PLANT_ID
                        , R.FACTORY_ID
                        , R.LINE_ID
                        , R.OPERATION_ID
                        , R.ELTR_LN_TP_CD
                        , R.ITEM_ID
                        , R.NICK_NAME
                        , R.MSR_TP_CD
                        , R.YYYYMM
                        , R.BASE_QTY
                        , R.QTY
                        , R.UI_UPD_YN
                        , R.REMARK
                        , V_STAMP
                        , SYSDATE
                        , R.LAST_UPDATED_BY
                        , R.LAST_UPDATE_DATE );

        END IF;

    END LOOP;

    IF V_NOT_VALID_CNT > 0 THEN

        DELETE SCP_MST_CAPA_ELTR_SPEED_PLAN A
         WHERE EXISTS (SELECT 1
                         FROM GT_SCP0105_CHK_NOT_VALID XA
                        WHERE XA.DIVISION_ID   = A.DIVISION_ID
                          AND XA.COMPANY_ID    = A.COMPANY_ID
                          AND XA.SITE_ID       = A.SITE_ID
                          AND XA.PLANT_ID      = A.PLANT_ID
                          AND XA.FACTORY_ID    = A.FACTORY_ID
                          AND XA.LINE_ID       = A.LINE_ID
                          AND XA.OPERATION_ID  = A.OPERATION_ID
                          AND XA.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                          AND XA.ITEM_ID       = A.ITEM_ID);

    END IF;

    /* UPDATE - SCP_MST_CAPA_ELTR_SPEED_PLAN - BEGIN */
    UPDATE SCP_MST_CAPA_ELTR_SPEED_PLAN A
       SET A.QTY = NULL
     WHERE EXISTS (SELECT 1
                     FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XA
                    WHERE XA.DIVISION_ID   = A.DIVISION_ID
                      AND XA.COMPANY_ID    = A.COMPANY_ID
                      AND XA.SITE_ID       = A.SITE_ID
                      AND XA.PLANT_ID      = A.PLANT_ID
                      AND XA.FACTORY_ID    = A.FACTORY_ID
                      AND XA.LINE_ID       = A.LINE_ID
                      AND XA.OPERATION_ID  = A.OPERATION_ID
                      AND XA.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                      AND XA.ITEM_ID       = A.ITEM_ID
                      AND XA.YYYYMM        = A.YYYYMM
                      AND NVL(XA.ASSIGN_PRIORITY, 0) = 0);
    /* UPDATE - SCP_MST_CAPA_ELTR_SPEED_PLAN - END */
    /* INSERT - SCP_MST_CAPA_ELTR_SPEED_PLAN - END */

    /* 아예 삭제함 */
    DELETE SCP_MST_CAPA_ELTR_SPEED_PLAN A
     WHERE EXISTS (SELECT 1
                     FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN XA
                    WHERE XA.DIVISION_ID  = A.DIVISION_ID
                      AND XA.COMPANY_ID   = A.COMPANY_ID
                      AND XA.SITE_ID      = A.SITE_ID
                      AND XA.PLANT_ID     = A.PLANT_ID
                      AND XA.FACTORY_ID   = A.FACTORY_ID
                      AND XA.LINE_ID      = A.LINE_ID
                      AND XA.OPERATION_ID = A.OPERATION_ID
                      AND XA.ITEM_ID      = A.ITEM_ID
                      AND XA.YYYYMM       = A.YYYYMM
                      AND (XA.ASSIGN_PRIORITY = 0 OR XA.VALID_YN <> 'Y'));

    /* 아예 삭제함 */
    DELETE SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
     WHERE EXISTS (SELECT 1
                     FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN XA
                    WHERE XA.DIVISION_ID  = A.DIVISION_ID
                      AND XA.COMPANY_ID   = A.COMPANY_ID
                      AND XA.SITE_ID      = A.SITE_ID
                      AND XA.PLANT_ID     = A.PLANT_ID
                      AND XA.FACTORY_ID   = A.FACTORY_ID
                      AND XA.LINE_ID      = A.LINE_ID
                      AND XA.OPERATION_ID = A.OPERATION_ID
                      AND XA.ITEM_ID      = A.MDL_NM
                      AND XA.YYYYMM       = A.YYYYMM
                      AND (XA.ASSIGN_PRIORITY = 0 OR XA.VALID_YN <> 'Y'));

END P_SCP0105_CHK_SPEED_ASGN_ELTR;


/****************************************************************************************************/
/* Program ID  : P_SCP0106_CALC_SPEED_PLAN_ASM                                                      */
/* Description : 손실계획 검증에 쓰는 조립 속도계획(PPM) 계산 — AS-IS 는 손실계획 검증 본문 안에    */
/*               속도계획 계산이 함께 들어 있다. 갈래를 나눠 두고 결과만 넘긴다                     */
/*               결과 : GT_SCP0106_CHK_SPEED_PLAN (모델별 기준 PPM · 실적 PPM)                      */
/****************************************************************************************************/
PROCEDURE P_SCP0106_CALC_SPEED_PLAN_ASM
(
    P_VERSION               IN  VARCHAR2
  , P_VERSION_SEQ           IN  NUMBER
  , P_RESULT_TO_YYYYMM      IN  VARCHAR2
)
IS
BEGIN

    DELETE GT_SCP0106_CHK_SPD_UNIT;
    DELETE GT_SCP0106_CHK_SPD_SRC;
    DELETE GT_SCP0106_CHK_SPD_CF;
    DELETE GT_SCP0106_CHK_SPD_RAW;
    DELETE GT_SCP0106_CHK_SPEED_PLAN;

    /* 공정별 속도 단위 */
    INSERT INTO GT_SCP0106_CHK_SPD_UNIT
                ( UNIT_GROUP
                , OPERATION_ID
                , MSR_TP_CD
                , LINE_TYPE
                , UNIT_GROUP_SEQ
                , DISPLAY_SEQ )
         SELECT SEGMENT1
              , SEGMENT2
              , SEGMENT3
              , SEGMENT4
              , SEGMENT5
              , DISPLAY_SEQ
           FROM SCM_ADM_LOOKUP_MASTER_DETAIL
          WHERE LOOKUP_TYPE = 'OPERATION_SPEED_UNIT'
            AND VALID_YN    = 'Y';

    /* 실적 — 설비 속도 월별 */
    INSERT INTO GT_SCP0106_CHK_SPD_SRC
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , NICK_NAME
                , SPEED_UNIT_GROUP
                , MSR_TP_CD
                , EQP_NBU
                , EQP_SPED )
         SELECT 'RST'
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.MDL_NM
              , B.UNIT_GROUP
              , UPPER(A.EQP_SPED_UNIT_CD)
              , AVG(A.EQP_NBU)
              , AVG(A.EQP_SPED)
           FROM SCM_DNM_EQP_SPED_MMLY A
              , (SELECT UNIT_GROUP
                      , MSR_TP_CD
                   FROM GT_SCP0106_CHK_SPD_UNIT
                  GROUP BY UNIT_GROUP
                         , MSR_TP_CD) B
          WHERE B.MSR_TP_CD(+)   = A.EQP_SPED_UNIT_CD
            AND A.PERD_DIVS_CD   = '3'
            AND A.PFRSLT_YM      = P_RESULT_TO_YYYYMM
          GROUP BY A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.SITE_ID
                 , A.PLANT_ID
                 , A.FACTORY_ID
                 , A.LINE_ID
                 , A.OPERATION_ID
                 , A.ELTR_LN_TP_CD
                 , A.MDL_NM
                 , B.UNIT_GROUP
                 , A.EQP_SPED_UNIT_CD;

    /* 기준 — 모델별 설비 속도 */
    INSERT INTO GT_SCP0106_CHK_SPD_SRC
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , NICK_NAME
                , SPEED_UNIT_GROUP
                , MSR_TP_CD
                , EQP_NBU
                , EQP_SPED
                , UI_UPD_YN )
         SELECT 'BSE'
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.MDL_NM
              , B.UNIT_GROUP
              , UPPER(A.EQP_SPED_UNIT_CD)
              , A.EQP_NBU
              , A.EQP_SPED
              , A.UI_UPD_YN
           FROM SCP_MST_MDL_EQP_SPED A
              , (SELECT UNIT_GROUP
                      , MSR_TP_CD
                   FROM GT_SCP0106_CHK_SPD_UNIT
                  GROUP BY UNIT_GROUP
                         , MSR_TP_CD) B
          WHERE B.MSR_TP_CD(+) = A.EQP_SPED_UNIT_CD
            AND A.USE_YN       = 'Y'
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XA
                         WHERE XA.DIVISION_ID = A.DIVISION_ID)
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XB
                         WHERE XB.SITE_ID = A.SITE_ID)
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XC
                         WHERE XC.PLANT_ID = A.PLANT_ID)
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XD
                         WHERE XD.FACTORY_ID = A.FACTORY_ID)
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XE
                         WHERE XE.LINE_ID = A.LINE_ID)
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XF
                         WHERE XF.OPERATION_ID = A.OPERATION_ID)
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XG
                         WHERE XG.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD)
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XH
                         WHERE XH.NICK_NAME = A.MDL_NM);

    /* 실적 PPM 조회 대상 변경 => 기존모델별에서 Line 별로 변경 */
    INSERT INTO GT_SCP0106_CHK_SPD_SRC
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , PPM )
         SELECT 'PPM'
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , TO_NUMBER(ATTRIBUTE1 DEFAULT NULL ON CONVERSION ERROR)
           FROM SCM_DNM_EQP_SPED_MMLY
          WHERE PERD_DIVS_CD = '3'
            AND PFRSLT_YM    = P_RESULT_TO_YYYYMM;

    /* 모델별 전극 수량·피치 */
    INSERT INTO GT_SCP0106_CHK_SPD_CF
                ( NICK_NAME
                , ELTR_LN_TP_CD
                , ELTR_QTY
                , ELTR_PCH_LEN )
         SELECT A.NICK_NM
              , A.ELTR_LN_TP_CD
              , A.ELTR_QTY
              , A.ELTR_PCH_LEN
           FROM SCP_MST_MDL_ELTR_QTY A
          WHERE A.USE_YN = 'Y'
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XA
                         WHERE XA.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD)
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XB
                         WHERE XB.NICK_NAME = A.NICK_NM);

    /* 속도계획 원장에서 배정된 열쇠분만 — 속도 단위 묶음별로 늘린다 */
    INSERT INTO GT_SCP0106_CHK_SPD_RAW
                ( STEP_NO
                , VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , SPEED_UNIT_GROUP
                , MSR_TP_CD
                , YYYYMM
                , BASE_QTY
                , QTY )
         SELECT 1
              , P_VERSION
              , P_VERSION_SEQ
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.ITEM_ID
              , A.NICK_NAME
              , G.UNIT_GROUP
              , CASE WHEN G.UNIT_GROUP = 'EQP_SPED'
                     THEN CASE WHEN A.OPERATION_ID = 'A5000' THEN 'MMS'
                               WHEN A.OPERATION_ID = 'A7000' OR A.OPERATION_ID = 'A7400' THEN 'CPM'
                               WHEN (A.OPERATION_ID = 'A8000' AND A.ELTR_LN_TP_CD = 'Folding')
                                 OR A.OPERATION_ID = 'A8400' THEN 'PPM_AVG'
                               ELSE 'TTT'
                          END
                     WHEN G.UNIT_GROUP = 'PPM' THEN 'PPM'
                     ELSE A.MSR_TP_CD
                END
              , A.YYYYMM
              , A.BASE_QTY
              , A.QTY
           FROM SCP_MST_CAPA_SPEED_PLAN A
              , (SELECT UNIT_GROUP
                   FROM GT_SCP0106_CHK_SPD_UNIT
                  GROUP BY UNIT_GROUP) G
          WHERE EXISTS (SELECT 1
                          FROM SCP_MST_CAPA_LINE_ASSIGN XA
                         WHERE XA.DIVISION_ID   = A.DIVISION_ID
                           AND XA.COMPANY_ID    = A.COMPANY_ID
                           AND XA.SITE_ID       = A.SITE_ID
                           AND XA.PLANT_ID      = A.PLANT_ID
                           AND XA.FACTORY_ID    = A.FACTORY_ID
                           AND XA.LINE_ID       = A.LINE_ID
                           AND XA.OPERATION_ID  = A.OPERATION_ID
                           AND XA.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                           AND XA.NICK_NAME     = A.NICK_NAME
                           AND XA.VALID_YN      = 'Y')
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XB
                         WHERE XB.DIVISION_ID = A.DIVISION_ID)
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XC
                         WHERE XC.SITE_ID = A.SITE_ID)
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XD
                         WHERE XD.PLANT_ID = A.PLANT_ID)
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XE
                         WHERE XE.FACTORY_ID = A.FACTORY_ID)
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XF
                         WHERE XF.LINE_ID = A.LINE_ID)
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XG
                         WHERE XG.OPERATION_ID = A.OPERATION_ID)
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XH
                         WHERE XH.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD)
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XI
                         WHERE XI.NICK_NAME = A.NICK_NAME);

    /* 속도 단위 묶음에 맞는 측정항목만 남긴다 */
    DELETE GT_SCP0106_CHK_SPD_RAW
     WHERE STEP_NO = 1
       AND NOT (SPEED_UNIT_GROUP = 'EQP_NBU'  AND MSR_TP_CD = 'EQP_NBU'
             OR SPEED_UNIT_GROUP = 'PPM'      AND MSR_TP_CD = 'PPM'
             OR SPEED_UNIT_GROUP = 'EQP_SPED' AND MSR_TP_CD IN ('MMS', 'CPM', 'PPM_AVG', 'TTT'));

    /* 실적·기준 값을 붙인다 */
    INSERT INTO GT_SCP0106_CHK_SPD_RAW
                ( STEP_NO
                , VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , SPEED_UNIT_GROUP
                , MSR_TP_CD
                , YYYYMM
                , BASE_QTY
                , QTY
                , R_PFRSLT_QTY
                , B_BASE_QTY
                , R_PFRSLT_SPEED
                , B_BASE_SPEED
                , ELTR_QTY
                , ELTR_PCH_LEN
                , MMS_CF
                , UI_UPD_YN )
         SELECT 2
              , A.VER_ID
              , A.VER_SEQ
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.ITEM_ID
              , A.NICK_NAME
              , A.SPEED_UNIT_GROUP
              , A.MSR_TP_CD
              , A.YYYYMM
              , A.BASE_QTY
              , A.QTY
              , R.EQP_NBU
              , B.EQP_NBU
              , R.EQP_SPED
              , B.EQP_SPED
              , Q.ELTR_QTY
              , Q.ELTR_PCH_LEN
              , Q.ELTR_QTY * Q.ELTR_PCH_LEN
              , NVL(BU.UI_UPD_YN, 'Y')
           FROM GT_SCP0106_CHK_SPD_RAW A
              , GT_SCP0106_CHK_SPD_SRC R
              , GT_SCP0106_CHK_SPD_SRC B
              , GT_SCP0106_CHK_SPD_CF Q
              , (SELECT DIVISION_ID
                      , COMPANY_ID
                      , SITE_ID
                      , PLANT_ID
                      , FACTORY_ID
                      , LINE_ID
                      , OPERATION_ID
                      , ELTR_LN_TP_CD
                      , NICK_NAME
                      , MAX(UI_UPD_YN) AS UI_UPD_YN
                   FROM GT_SCP0106_CHK_SPD_SRC
                  WHERE SRC_TP = 'BSE'
                  GROUP BY DIVISION_ID
                         , COMPANY_ID
                         , SITE_ID
                         , PLANT_ID
                         , FACTORY_ID
                         , LINE_ID
                         , OPERATION_ID
                         , ELTR_LN_TP_CD
                         , NICK_NAME) BU
          WHERE A.STEP_NO = 1
            AND R.SRC_TP(+)         = 'RST'
            AND R.DIVISION_ID(+)    = A.DIVISION_ID
            AND R.COMPANY_ID(+)     = A.COMPANY_ID
            AND R.SITE_ID(+)        = A.SITE_ID
            AND R.PLANT_ID(+)       = A.PLANT_ID
            AND R.FACTORY_ID(+)     = A.FACTORY_ID
            AND R.LINE_ID(+)        = A.LINE_ID
            AND R.OPERATION_ID(+)   = A.OPERATION_ID
            AND R.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND B.SRC_TP(+)         = 'BSE'
            AND B.DIVISION_ID(+)    = A.DIVISION_ID
            AND B.COMPANY_ID(+)     = A.COMPANY_ID
            AND B.SITE_ID(+)        = A.SITE_ID
            AND B.PLANT_ID(+)       = A.PLANT_ID
            AND B.FACTORY_ID(+)     = A.FACTORY_ID
            AND B.LINE_ID(+)        = A.LINE_ID
            AND B.OPERATION_ID(+)   = A.OPERATION_ID
            AND B.NICK_NAME(+)      = A.NICK_NAME
            AND B.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND Q.NICK_NAME(+)      = A.NICK_NAME
            AND Q.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND BU.DIVISION_ID(+)   = A.DIVISION_ID
            AND BU.COMPANY_ID(+)    = A.COMPANY_ID
            AND BU.SITE_ID(+)       = A.SITE_ID
            AND BU.PLANT_ID(+)      = A.PLANT_ID
            AND BU.FACTORY_ID(+)    = A.FACTORY_ID
            AND BU.LINE_ID(+)       = A.LINE_ID
            AND BU.OPERATION_ID(+)  = A.OPERATION_ID
            AND BU.NICK_NAME(+)     = A.NICK_NAME
            AND BU.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD;

    /* 설비 대수·속도 갈래를 따로 떠 둔다 */
    INSERT INTO GT_SCP0106_CHK_SPD_RAW
                ( STEP_NO
                , VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , SPEED_UNIT_GROUP
                , MSR_TP_CD
                , YYYYMM
                , QTY
                , SPEED )
         SELECT 3
              , VER_ID
              , VER_SEQ
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , ITEM_ID
              , NICK_NAME
              , SPEED_UNIT_GROUP
              , MSR_TP_CD
              , YYYYMM
              , QTY
              , NULL
           FROM GT_SCP0106_CHK_SPD_RAW
          WHERE STEP_NO = 2
            AND SPEED_UNIT_GROUP = 'EQP_NBU';

    INSERT INTO GT_SCP0106_CHK_SPD_RAW
                ( STEP_NO
                , VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , SPEED_UNIT_GROUP
                , MSR_TP_CD
                , YYYYMM
                , SPEED )
         SELECT 4
              , VER_ID
              , VER_SEQ
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , ITEM_ID
              , NICK_NAME
              , SPEED_UNIT_GROUP
              , MSR_TP_CD
              , YYYYMM
              , CASE WHEN UI_UPD_YN = 'Y' THEN QTY ELSE B_BASE_SPEED END
           FROM GT_SCP0106_CHK_SPD_RAW
          WHERE STEP_NO = 2
            AND SPEED_UNIT_GROUP = 'EQP_SPED';

    /* 측정항목별로 실적·기준·계획 값을 셈한다 */
    INSERT INTO GT_SCP0106_CHK_SPD_RAW
                ( STEP_NO
                , VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , SPEED_UNIT_GROUP
                , MSR_TP_CD
                , YYYYMM
                , PFRSLT_QTY
                , BASE_QTY
                , QTY
                , ELTR_QTY
                , MMS_CF
                , UI_UPD_YN )
         SELECT 5
              , A.VER_ID
              , A.VER_SEQ
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.ITEM_ID
              , A.NICK_NAME
              , A.SPEED_UNIT_GROUP
              , A.MSR_TP_CD
              , A.YYYYMM
              , CASE WHEN A.SPEED_UNIT_GROUP = 'EQP_SPED' THEN A.R_PFRSLT_SPEED
                     WHEN A.SPEED_UNIT_GROUP = 'EQP_NBU'  THEN A.R_PFRSLT_QTY
                     ELSE P.PPM
                END
              /* UI_UPD_YN = 'Y' 이면 Speed Plan 저장된 값, 아니면 실시간 조회값 */
              , CASE WHEN A.UI_UPD_YN = 'Y' THEN A.BASE_QTY
                     ELSE CASE WHEN A.SPEED_UNIT_GROUP = 'EQP_SPED' THEN A.B_BASE_SPEED
                               WHEN A.SPEED_UNIT_GROUP = 'EQP_NBU'  THEN A.B_BASE_QTY
                               ELSE CASE WHEN A.OPERATION_ID = 'A5000'
                                         THEN CASE WHEN A.MMS_CF * A.B_BASE_QTY = 0 THEN 0
                                                   ELSE A.B_BASE_SPEED * 60.0 / A.MMS_CF * A.B_BASE_QTY
                                              END
                                         WHEN A.OPERATION_ID = 'A7000' OR A.OPERATION_ID = 'A7400'
                                         THEN CASE WHEN A.ELTR_QTY * A.B_BASE_QTY = 0 THEN 0
                                                   ELSE A.B_BASE_SPEED / A.ELTR_QTY * A.B_BASE_QTY
                                              END
                                         WHEN (A.OPERATION_ID = 'A8000' AND A.ELTR_LN_TP_CD = 'Folding')
                                           OR A.OPERATION_ID = 'A8400'
                                         THEN A.B_BASE_SPEED * A.B_BASE_QTY
                                         ELSE CASE WHEN A.B_BASE_SPEED * A.B_BASE_QTY = 0 THEN 0
                                                   ELSE 60.0 / A.B_BASE_SPEED * A.B_BASE_QTY
                                              END
                                    END
                          END
                END
              , CASE WHEN A.UI_UPD_YN = 'Y' THEN A.QTY
                     ELSE CASE WHEN A.SPEED_UNIT_GROUP = 'EQP_SPED' THEN S.SPEED
                               WHEN A.SPEED_UNIT_GROUP = 'EQP_NBU'  THEN Q.QTY
                               ELSE CASE WHEN A.OPERATION_ID = 'A5000'
                                         THEN CASE WHEN A.MMS_CF * Q.QTY = 0 THEN 0
                                                   ELSE S.SPEED * 60.0 / A.MMS_CF * Q.QTY
                                              END
                                         WHEN A.OPERATION_ID = 'A7000' OR A.OPERATION_ID = 'A7400'
                                         THEN CASE WHEN A.ELTR_QTY * Q.QTY = 0 THEN 0
                                                   ELSE S.SPEED / A.ELTR_QTY * Q.QTY
                                              END
                                         WHEN (A.OPERATION_ID = 'A8000' AND A.ELTR_LN_TP_CD = 'Folding')
                                           OR A.OPERATION_ID = 'A8400'
                                         THEN S.SPEED * Q.QTY
                                         ELSE CASE WHEN S.SPEED * Q.QTY = 0 THEN 0
                                                   ELSE 60.0 / S.SPEED * Q.QTY
                                              END
                                    END
                          END
                END
              , A.ELTR_QTY
              , A.MMS_CF
              , A.UI_UPD_YN
           FROM GT_SCP0106_CHK_SPD_RAW A
              , GT_SCP0106_CHK_SPD_RAW Q
              , GT_SCP0106_CHK_SPD_RAW S
              , GT_SCP0106_CHK_SPD_SRC P
          WHERE A.STEP_NO = 2
            AND Q.STEP_NO(+)        = 3
            AND Q.VER_ID(+)         = A.VER_ID
            AND Q.VER_SEQ(+)        = A.VER_SEQ
            AND Q.DIVISION_ID(+)    = A.DIVISION_ID
            AND Q.COMPANY_ID(+)     = A.COMPANY_ID
            AND Q.SITE_ID(+)        = A.SITE_ID
            AND Q.PLANT_ID(+)       = A.PLANT_ID
            AND Q.FACTORY_ID(+)     = A.FACTORY_ID
            AND Q.LINE_ID(+)        = A.LINE_ID
            AND Q.OPERATION_ID(+)   = A.OPERATION_ID
            AND Q.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND Q.NICK_NAME(+)      = A.NICK_NAME
            AND Q.YYYYMM(+)         = A.YYYYMM
            AND S.STEP_NO(+)        = 4
            AND S.VER_ID(+)         = A.VER_ID
            AND S.VER_SEQ(+)        = A.VER_SEQ
            AND S.DIVISION_ID(+)    = A.DIVISION_ID
            AND S.COMPANY_ID(+)     = A.COMPANY_ID
            AND S.SITE_ID(+)        = A.SITE_ID
            AND S.PLANT_ID(+)       = A.PLANT_ID
            AND S.FACTORY_ID(+)     = A.FACTORY_ID
            AND S.LINE_ID(+)        = A.LINE_ID
            AND S.OPERATION_ID(+)   = A.OPERATION_ID
            AND S.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND S.NICK_NAME(+)      = A.NICK_NAME
            AND S.YYYYMM(+)         = A.YYYYMM
            AND P.SRC_TP(+)         = 'PPM'
            AND P.DIVISION_ID(+)    = A.DIVISION_ID
            AND P.COMPANY_ID(+)     = A.COMPANY_ID
            AND P.SITE_ID(+)        = A.SITE_ID
            AND P.PLANT_ID(+)       = A.PLANT_ID
            AND P.FACTORY_ID(+)     = A.FACTORY_ID
            AND P.LINE_ID(+)        = A.LINE_ID
            AND P.OPERATION_ID(+)   = A.OPERATION_ID
            AND P.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD;

    /* PPM 기준·실적을 모델 단위로 셈해 넘긴다 */
    INSERT INTO GT_SCP0106_CHK_SPEED_PLAN
                ( DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , NICK_NAME
                , BASE_PPM
                , PFRSLT_PPM )
         SELECT DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , NICK_NAME
              , AVG(BASE_QTY)
              , AVG(PFRSLT_QTY)
           FROM (SELECT DIVISION_ID
                      , COMPANY_ID
                      , SITE_ID
                      , PLANT_ID
                      , FACTORY_ID
                      , LINE_ID
                      , OPERATION_ID
                      , ELTR_LN_TP_CD
                      , NICK_NAME
                      , MSR_TP_CD
                      , YYYYMM
                      , UI_UPD_YN
                      , AVG(NVL(PFRSLT_QTY, 0.0)) AS PFRSLT_QTY
                      , AVG(NVL(BASE_QTY, 0.0))   AS BASE_QTY
                   FROM GT_SCP0106_CHK_SPD_RAW
                  WHERE STEP_NO = 5
                  GROUP BY DIVISION_ID
                         , COMPANY_ID
                         , SITE_ID
                         , PLANT_ID
                         , FACTORY_ID
                         , LINE_ID
                         , OPERATION_ID
                         , ELTR_LN_TP_CD
                         , ITEM_ID
                         , NICK_NAME
                         , SPEED_UNIT_GROUP
                         , MSR_TP_CD
                         , YYYYMM
                         , UI_UPD_YN) IA
          WHERE IA.MSR_TP_CD = 'PPM'
          GROUP BY DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , NICK_NAME;

END P_SCP0106_CALC_SPEED_PLAN_ASM;


/****************************************************************************************************/
/* Program ID  : P_SCP0106_CHK_LOSS_ASGN_ASM                                                        */
/* Description : ASSIGN 테이블 구조의 데이터를 파라미터로 Loss Plan Insert/Update — 조립            */
/*               전달 테이블은 GT_SCP_CAPA_LINE_ASSIGN_KEYS 로 받는다(부르는 쪽이 채운다)           */
/****************************************************************************************************/
PROCEDURE P_SCP0106_CHK_LOSS_ASGN_ASM
(
    P_PROGRAM_ID            IN  VARCHAR2
  , P_SHEET_NAME            IN  VARCHAR2
  , P_USER_ID               IN  VARCHAR2
  , P_DEBUG_MODE            IN  VARCHAR2
)
IS
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0106_CHECK_CAPA_LOSS_PLAN_BY_ASSIGN_ASSEMBLY';
    V_STAMP             VARCHAR2(800 CHAR);
    V_VERSION           VARCHAR2(40 CHAR);
    V_VERSION_SEQ       NUMBER(3);
    V_RESULT_TO_YYYYMM  VARCHAR2(6 CHAR);
    V_RESULT_FR_YYYYMM  VARCHAR2(6 CHAR);
    V_RESULT_DAY_CNT    NUMBER(20,10)      := 1.0;
BEGIN

    V_STAMP := V_PROGRAM_NAME || '-' || P_USER_ID;

    DELETE GT_SCP0106_CHK_MEASURE;
    DELETE GT_SCP0106_CHK_NOT_VALID;
    DELETE GT_SCP0106_CHK_LOSS_RSLT;
    DELETE GT_SCP0106_CHK_DAY_CNT;
    DELETE GT_SCP0106_CHK_FINAL;
    DELETE GT_SCP0106_CHK_EXISTS_BASE;
    DELETE GT_SCP0106_CHK_RAW;

    /* 사용여부가 Y 가 아닌 열쇠 */
    INSERT INTO GT_SCP0106_CHK_NOT_VALID
                ( VALID_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , NICK_NAME )
         SELECT 'N'
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , NICK_NAME
           FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS
          WHERE VALID_YN <> 'Y'
          GROUP BY DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , NICK_NAME;

    /* 사용여부가 N 이 아닌 열쇠 — 우선순위 합계로 쓰인다 */
    INSERT INTO GT_SCP0106_CHK_NOT_VALID
                ( VALID_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , NICK_NAME
                , ASSIGN_PRIORITY )
         SELECT 'Y'
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , NICK_NAME
              , SUM(ASSIGN_PRIORITY)
           FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS
          WHERE VALID_YN <> 'N'
          GROUP BY DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , NICK_NAME;

    SELECT MAX(VER_ID)
         , MAX(VER_SEQ)
      INTO V_VERSION
         , V_VERSION_SEQ
      FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS;

    V_RESULT_TO_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -1), 'YYYYMM');
    V_RESULT_FR_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -3), 'YYYYMM');

    /* 최근 3개월 평균 일수 */
    SELECT NVL(AVG(DAY_CNT), 1.0)
      INTO V_RESULT_DAY_CNT
      FROM (SELECT BASIS_YYYYMM
                 , COUNT(*) AS DAY_CNT
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD >= V_RESULT_FR_YYYYMM
               AND BASIS_YYYYMMDD <  V_VERSION
             GROUP BY BASIS_YYYYMM) IA;

    /* 손실 측정항목 — 속도·일수 항목은 뺀다 */
    INSERT INTO GT_SCP0106_CHK_MEASURE
                ( MSR_GR_CD
                , MSR_TP_CD
                , DISPLAY_SEQ )
         SELECT ATTRIBUTE3
              , SEGMENT1
              , DISPLAY_SEQ
           FROM SCM_ADM_LOOKUP_MASTER_DETAIL
          WHERE LOOKUP_TYPE = 'SCP_CAPA_LOSS_MEASURE'
            AND VALID_YN    = 'Y'
            AND SEGMENT1 NOT IN ('EQP_NBU', 'TACT_TIME', 'PPM', 'SCP_PROD_PLAN_DDN');

    /* 속도계획(PPM) — 갈래를 나눠 둔 프로시저가 채운다 */
    P_SCP0106_CALC_SPEED_PLAN_ASM(V_VERSION, V_VERSION_SEQ, V_RESULT_TO_YYYYMM);

    /* 양산시점 기준 일수 — 버전월 · 전체 · 연도별 */
    INSERT INTO GT_SCP0106_CHK_DAY_CNT
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , SOP_DT
                , YYYYMM
                , DAY_CNT )
         SELECT 'BSE'
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , SOP_DT
              , SOP_YM
              , SOP_DDN
           FROM SCP_MST_CAPA_LINE_SOP
          WHERE VALID_YN = 'Y'
            AND SOP_YM   = V_VERSION;   /* 버전으로 월 고정 */

    INSERT INTO GT_SCP0106_CHK_DAY_CNT
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , SOP_DT
                , YYYYMM
                , DAY_CNT )
         SELECT 'OPP'
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , SOP_DT
              , SOP_YM
              , SOP_DDN
           FROM SCP_MST_CAPA_LINE_SOP
          WHERE VALID_YN = 'Y';

    INSERT INTO GT_SCP0106_CHK_DAY_CNT
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , SOP_DT
                , YYYYMM
                , DAY_CNT )
         SELECT 'OPY'
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , SOP_DT
              , SUBSTR(YYYYMM, 1, 4)
              /* SOP 적용 일수 — 양산일부터 연말까지
                 ★양산시점 월이 비어 있는 행이 있어 날짜로 바꾸기 전에 걸러낸다 */
              , CASE WHEN TRIM(YYYYMM) IS NULL THEN NULL
                     WHEN TRIM(SOP_DT) IS NOT NULL
                     THEN TO_DATE(SUBSTR(YYYYMM, 1, 4) || '1231', 'YYYYMMDD') - FN_CHAR_TO_DATE(SOP_DT) + 1
                     ELSE TO_DATE(SUBSTR(YYYYMM, 1, 4) || '1231', 'YYYYMMDD')
                          - TO_DATE(SUBSTR(YYYYMM, 1, 4) || '0101', 'YYYYMMDD') + 1
                END
           FROM GT_SCP0106_CHK_DAY_CNT
          WHERE SRC_TP = 'OPP';

    /* 실적 손실율 — 모델별 · 라인별 */
    INSERT INTO GT_SCP0106_CHK_LOSS_RSLT
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , MDL_NM
                , LOSS_CD
                , LOSS_RT )
         SELECT 'MDL'
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , MDL_NM
              , LOSS_CD
              , LOSS_RT
           FROM SCM_DNM_LOSS_MDL_MMLY
          WHERE PERD_DIVS_CD = '3'
            AND LOSS_YM      = V_RESULT_TO_YYYYMM;

    INSERT INTO GT_SCP0106_CHK_LOSS_RSLT
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , MDL_NM
                , LOSS_CD
                , LOSS_RT )
         SELECT 'LN'
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , '-'
              , LOSS_CD
              , LOSS_RT
           FROM SCM_DNM_LOSS_LN_MMLY
          WHERE PERD_DIVS_CD = '3'
            AND LOSS_YM      = V_RESULT_TO_YYYYMM;

    /* 기존 손실계획의 기준값 — 열쇠마다 가장 앞 월의 값 */
    INSERT INTO GT_SCP0106_CHK_EXISTS_BASE
                ( DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , MDL_NM
                , MSR_GR_CD
                , MSR_TP_CD
                , BASE_NVL )
         SELECT DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , MDL_NM
              , MSR_GR_CD
              , MSR_TP_CD
              , BASE_NVL
           FROM (SELECT A.DIVISION_ID
                      , A.COMPANY_ID
                      , A.SITE_ID
                      , A.PLANT_ID
                      , A.FACTORY_ID
                      , A.LINE_ID
                      , A.OPERATION_ID
                      , A.ELTR_LN_TP_CD
                      , A.MDL_NM
                      , A.MSR_GR_CD
                      , A.MSR_TP_CD
                      , A.BASE_NVL
                      , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                                      , A.COMPANY_ID
                                                      , A.SITE_ID
                                                      , A.PLANT_ID
                                                      , A.FACTORY_ID
                                                      , A.LINE_ID
                                                      , A.OPERATION_ID
                                                      , A.ELTR_LN_TP_CD
                                                      , A.MDL_NM
                                                      , A.MSR_GR_CD
                                                      , A.MSR_TP_CD
                                               ORDER BY A.YYYYMM) AS RN
                   FROM SCP_MST_CAPA_LOSS_PLAN_MDL A
                      , (SELECT DIVISION_ID
                              , COMPANY_ID
                              , SITE_ID
                              , PLANT_ID
                              , FACTORY_ID
                              , LINE_ID
                              , OPERATION_ID
                              , ELTR_LN_TP_CD
                           FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS
                          GROUP BY DIVISION_ID
                                 , COMPANY_ID
                                 , SITE_ID
                                 , PLANT_ID
                                 , FACTORY_ID
                                 , LINE_ID
                                 , OPERATION_ID
                                 , ELTR_LN_TP_CD) B
                  WHERE B.DIVISION_ID   = A.DIVISION_ID
                    AND B.COMPANY_ID    = A.COMPANY_ID
                    AND B.SITE_ID       = A.SITE_ID
                    AND B.PLANT_ID      = A.PLANT_ID
                    AND B.FACTORY_ID    = A.FACTORY_ID
                    AND B.LINE_ID       = A.LINE_ID
                    AND B.OPERATION_ID  = A.OPERATION_ID
                    AND B.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD) IA
          WHERE IA.RN = 1;

    /* 열쇠별 손실율 — 라인 실적을 바탕으로, 양품가동률만 모델 실적 */
    INSERT INTO GT_SCP0106_CHK_FINAL
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , MDL_NM
                , BM_RT
                , CM_RT
                , ID_RT
                , MR_RT
                , NM_RT
                , PD_RT
                , PM_RT
                , PP_RT
                , UD_RT
                , QL_RT )
         SELECT 'RT'
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.NICK_NAME
              , CASE WHEN NVL(BM.LOSS_RT, 0) > 1 THEN 1 ELSE NVL(BM.LOSS_RT, 0) END
              , CASE WHEN NVL(CM.LOSS_RT, 0) > 1 THEN 1 ELSE NVL(CM.LOSS_RT, 0) END
              , CASE WHEN NVL(ID.LOSS_RT, 0) > 1 THEN 1 ELSE NVL(ID.LOSS_RT, 0) END
              , CASE WHEN NVL(MR.LOSS_RT, 0) > 1 THEN 1 ELSE NVL(MR.LOSS_RT, 0) END
              , CASE WHEN NVL(NM.LOSS_RT, 0) > 1 THEN 1 ELSE NVL(NM.LOSS_RT, 0) END
              , CASE WHEN NVL(PD.LOSS_RT, 0) > 1 THEN 1 ELSE NVL(PD.LOSS_RT, 0) END
              , CASE WHEN NVL(PM.LOSS_RT, 0) > 1 THEN 1 ELSE NVL(PM.LOSS_RT, 0) END
              , CASE WHEN NVL(PP.LOSS_RT, 0) > 1 THEN 1 ELSE NVL(PP.LOSS_RT, 0) END
              , CASE WHEN NVL(UD.LOSS_RT, 0) > 1 THEN 1 ELSE NVL(UD.LOSS_RT, 0) END
              , CASE WHEN NVL(QL.LOSS_RT, 0) > 1 THEN 1 ELSE NVL(QL.LOSS_RT, 0) END
           FROM (SELECT DIVISION_ID
                      , COMPANY_ID
                      , SITE_ID
                      , PLANT_ID
                      , FACTORY_ID
                      , LINE_ID
                      , OPERATION_ID
                      , ELTR_LN_TP_CD
                      , NICK_NAME
                   FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS
                  GROUP BY DIVISION_ID
                         , COMPANY_ID
                         , SITE_ID
                         , PLANT_ID
                         , FACTORY_ID
                         , LINE_ID
                         , OPERATION_ID
                         , ELTR_LN_TP_CD
                         , NICK_NAME) A
              , GT_SCP0106_CHK_LOSS_RSLT BM
              , GT_SCP0106_CHK_LOSS_RSLT CM
              , GT_SCP0106_CHK_LOSS_RSLT ID
              , GT_SCP0106_CHK_LOSS_RSLT MR
              , GT_SCP0106_CHK_LOSS_RSLT NM
              , GT_SCP0106_CHK_LOSS_RSLT PD
              , GT_SCP0106_CHK_LOSS_RSLT PM
              , GT_SCP0106_CHK_LOSS_RSLT PP
              , GT_SCP0106_CHK_LOSS_RSLT UD
              , GT_SCP0106_CHK_LOSS_RSLT QL
          WHERE BM.SRC_TP(+)         = 'LN'
            AND BM.LOSS_CD(+)        = 'BM_RT'
            AND BM.DIVISION_ID(+)    = A.DIVISION_ID
            AND BM.COMPANY_ID(+)     = A.COMPANY_ID
            AND BM.SITE_ID(+)        = A.SITE_ID
            AND BM.PLANT_ID(+)       = A.PLANT_ID
            AND BM.FACTORY_ID(+)     = A.FACTORY_ID
            AND BM.LINE_ID(+)        = A.LINE_ID
            AND BM.OPERATION_ID(+)   = A.OPERATION_ID
            AND BM.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND CM.SRC_TP(+)         = 'LN'
            AND CM.LOSS_CD(+)        = 'CM_RT'
            AND CM.DIVISION_ID(+)    = A.DIVISION_ID
            AND CM.COMPANY_ID(+)     = A.COMPANY_ID
            AND CM.SITE_ID(+)        = A.SITE_ID
            AND CM.PLANT_ID(+)       = A.PLANT_ID
            AND CM.FACTORY_ID(+)     = A.FACTORY_ID
            AND CM.LINE_ID(+)        = A.LINE_ID
            AND CM.OPERATION_ID(+)   = A.OPERATION_ID
            AND CM.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND ID.SRC_TP(+)         = 'LN'
            AND ID.LOSS_CD(+)        = 'ID_RT'
            AND ID.DIVISION_ID(+)    = A.DIVISION_ID
            AND ID.COMPANY_ID(+)     = A.COMPANY_ID
            AND ID.SITE_ID(+)        = A.SITE_ID
            AND ID.PLANT_ID(+)       = A.PLANT_ID
            AND ID.FACTORY_ID(+)     = A.FACTORY_ID
            AND ID.LINE_ID(+)        = A.LINE_ID
            AND ID.OPERATION_ID(+)   = A.OPERATION_ID
            AND ID.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND MR.SRC_TP(+)         = 'LN'
            AND MR.LOSS_CD(+)        = 'MR_RT'
            AND MR.DIVISION_ID(+)    = A.DIVISION_ID
            AND MR.COMPANY_ID(+)     = A.COMPANY_ID
            AND MR.SITE_ID(+)        = A.SITE_ID
            AND MR.PLANT_ID(+)       = A.PLANT_ID
            AND MR.FACTORY_ID(+)     = A.FACTORY_ID
            AND MR.LINE_ID(+)        = A.LINE_ID
            AND MR.OPERATION_ID(+)   = A.OPERATION_ID
            AND MR.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND NM.SRC_TP(+)         = 'LN'
            AND NM.LOSS_CD(+)        = 'NM_RT'
            AND NM.DIVISION_ID(+)    = A.DIVISION_ID
            AND NM.COMPANY_ID(+)     = A.COMPANY_ID
            AND NM.SITE_ID(+)        = A.SITE_ID
            AND NM.PLANT_ID(+)       = A.PLANT_ID
            AND NM.FACTORY_ID(+)     = A.FACTORY_ID
            AND NM.LINE_ID(+)        = A.LINE_ID
            AND NM.OPERATION_ID(+)   = A.OPERATION_ID
            AND NM.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND PD.SRC_TP(+)         = 'LN'
            AND PD.LOSS_CD(+)        = 'PD_RT'
            AND PD.DIVISION_ID(+)    = A.DIVISION_ID
            AND PD.COMPANY_ID(+)     = A.COMPANY_ID
            AND PD.SITE_ID(+)        = A.SITE_ID
            AND PD.PLANT_ID(+)       = A.PLANT_ID
            AND PD.FACTORY_ID(+)     = A.FACTORY_ID
            AND PD.LINE_ID(+)        = A.LINE_ID
            AND PD.OPERATION_ID(+)   = A.OPERATION_ID
            AND PD.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND PM.SRC_TP(+)         = 'LN'
            AND PM.LOSS_CD(+)        = 'PM_RT'
            AND PM.DIVISION_ID(+)    = A.DIVISION_ID
            AND PM.COMPANY_ID(+)     = A.COMPANY_ID
            AND PM.SITE_ID(+)        = A.SITE_ID
            AND PM.PLANT_ID(+)       = A.PLANT_ID
            AND PM.FACTORY_ID(+)     = A.FACTORY_ID
            AND PM.LINE_ID(+)        = A.LINE_ID
            AND PM.OPERATION_ID(+)   = A.OPERATION_ID
            AND PM.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND PP.SRC_TP(+)         = 'LN'
            AND PP.LOSS_CD(+)        = 'PP_RT'
            AND PP.DIVISION_ID(+)    = A.DIVISION_ID
            AND PP.COMPANY_ID(+)     = A.COMPANY_ID
            AND PP.SITE_ID(+)        = A.SITE_ID
            AND PP.PLANT_ID(+)       = A.PLANT_ID
            AND PP.FACTORY_ID(+)     = A.FACTORY_ID
            AND PP.LINE_ID(+)        = A.LINE_ID
            AND PP.OPERATION_ID(+)   = A.OPERATION_ID
            AND PP.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND UD.SRC_TP(+)         = 'LN'
            AND UD.LOSS_CD(+)        = 'UD_RT'
            AND UD.DIVISION_ID(+)    = A.DIVISION_ID
            AND UD.COMPANY_ID(+)     = A.COMPANY_ID
            AND UD.SITE_ID(+)        = A.SITE_ID
            AND UD.PLANT_ID(+)       = A.PLANT_ID
            AND UD.FACTORY_ID(+)     = A.FACTORY_ID
            AND UD.LINE_ID(+)        = A.LINE_ID
            AND UD.OPERATION_ID(+)   = A.OPERATION_ID
            AND UD.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND QL.SRC_TP(+)         = 'MDL'
            AND QL.LOSS_CD(+)        = 'QL_RT'
            AND QL.DIVISION_ID(+)    = A.DIVISION_ID
            AND QL.COMPANY_ID(+)     = A.COMPANY_ID
            AND QL.SITE_ID(+)        = A.SITE_ID
            AND QL.PLANT_ID(+)       = A.PLANT_ID
            AND QL.FACTORY_ID(+)     = A.FACTORY_ID
            AND QL.LINE_ID(+)        = A.LINE_ID
            AND QL.OPERATION_ID(+)   = A.OPERATION_ID
            AND QL.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND QL.MDL_NM(+)         = A.NICK_NAME;

    /* 묶음 손실율에서 가동률을 셈한다 */
    UPDATE GT_SCP0106_CHK_FINAL
       SET OP_RT = (1.0 - (BM_RT + CM_RT + PD_RT + PM_RT + UD_RT + PP_RT + MR_RT))
         , LD_RT = (1.0 - (ID_RT + NM_RT))
         , AV_RT = 1.0   /* Current 조업율 100 */
         , PF_RT = 1.0
     WHERE SRC_TP = 'RT';

    UPDATE GT_SCP0106_CHK_FINAL
       SET TEEP       = (AV_RT * LD_RT * OP_RT * PF_RT * QL_RT)
         , PROD_OP_RT = (LD_RT * OP_RT * PF_RT * QL_RT)
     WHERE SRC_TP = 'RT';

    /* 실적·기준 생산능력 */
    UPDATE GT_SCP0106_CHK_FINAL A
       SET ( BASE_PPM
           , PFRSLT_PPM
           , DAY_CNT ) = (SELECT S.BASE_PPM
                               , S.PFRSLT_PPM
                               , (SELECT MAX(DC.DAY_CNT)
                                    FROM GT_SCP0106_CHK_DAY_CNT DC
                                   WHERE DC.SRC_TP        = 'BSE'
                                     AND DC.DIVISION_ID   = A.DIVISION_ID
                                     AND DC.COMPANY_ID    = A.COMPANY_ID
                                     AND DC.SITE_ID       = A.SITE_ID
                                     AND DC.PLANT_ID      = A.PLANT_ID
                                     AND DC.FACTORY_ID    = A.FACTORY_ID
                                     AND DC.LINE_ID       = A.LINE_ID
                                     AND DC.OPERATION_ID  = A.OPERATION_ID
                                     AND DC.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD)
                            FROM GT_SCP0106_CHK_SPEED_PLAN S
                           WHERE S.DIVISION_ID   = A.DIVISION_ID
                             AND S.COMPANY_ID    = A.COMPANY_ID
                             AND S.SITE_ID       = A.SITE_ID
                             AND S.PLANT_ID      = A.PLANT_ID
                             AND S.FACTORY_ID    = A.FACTORY_ID
                             AND S.LINE_ID       = A.LINE_ID
                             AND S.OPERATION_ID  = A.OPERATION_ID
                             AND S.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                             AND S.NICK_NAME     = A.MDL_NM)
     WHERE A.SRC_TP = 'RT'
       AND EXISTS (SELECT 1
                     FROM GT_SCP0106_CHK_SPEED_PLAN XS
                    WHERE XS.DIVISION_ID   = A.DIVISION_ID
                      AND XS.COMPANY_ID    = A.COMPANY_ID
                      AND XS.SITE_ID       = A.SITE_ID
                      AND XS.PLANT_ID      = A.PLANT_ID
                      AND XS.FACTORY_ID    = A.FACTORY_ID
                      AND XS.LINE_ID       = A.LINE_ID
                      AND XS.OPERATION_ID  = A.OPERATION_ID
                      AND XS.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                      AND XS.NICK_NAME     = A.MDL_NM);

    UPDATE GT_SCP0106_CHK_FINAL
       SET PFRSLT_THRY_CAPA_D = (PFRSLT_PPM * 1440.0)
         , PFRSLT_PROD_CAPA_D = (PFRSLT_PPM * 1440.0 * (LD_RT * OP_RT * PF_RT * QL_RT))
         , PFRSLT_PROD_CAPA_M = (PFRSLT_PPM * 1440.0 * (LD_RT * OP_RT * PF_RT * QL_RT)) * V_RESULT_DAY_CNT
         , BASE_THRY_CAPA_D   = (BASE_PPM * 1440.0)
         , BASE_PROD_CAPA_D   = (BASE_PPM * 1440.0 * (LD_RT * OP_RT * PF_RT * QL_RT))
         , BASE_PROD_CAPA_M   = (BASE_PPM * 1440.0 * (LD_RT * OP_RT * PF_RT * QL_RT))
                              * NVL(DAY_CNT, TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(V_VERSION || '01', 'YYYYMMDD')), 'DD')))
     WHERE SRC_TP = 'RT';

    /* 운영계획용 — 달마다 일수가 달라 따로 둔다 */
    INSERT INTO GT_SCP0106_CHK_FINAL
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , MDL_NM
                , YYYYMM
                , BM_RT
                , CM_RT
                , ID_RT
                , MR_RT
                , NM_RT
                , PD_RT
                , PM_RT
                , PP_RT
                , UD_RT
                , OP_RT
                , LD_RT
                , AV_RT
                , PF_RT
                , QL_RT
                , TEEP
                , PROD_OP_RT
                , BASE_PPM
                , PFRSLT_PPM
                , DAY_CNT
                , PFRSLT_THRY_CAPA_D
                , PFRSLT_PROD_CAPA_D
                , PFRSLT_PROD_CAPA_M
                , BASE_THRY_CAPA_D
                , BASE_PROD_CAPA_D
                , BASE_PROD_CAPA_M )
         SELECT 'OP'
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.MDL_NM
              , K.YYYYMM
              , A.BM_RT
              , A.CM_RT
              , A.ID_RT
              , A.MR_RT
              , A.NM_RT
              , A.PD_RT
              , A.PM_RT
              , A.PP_RT
              , A.UD_RT
              , A.OP_RT
              , A.LD_RT
              , A.AV_RT
              , A.PF_RT
              , A.QL_RT
              , A.TEEP
              , A.PROD_OP_RT
              , A.BASE_PPM
              , A.PFRSLT_PPM
              , NVL(DC.DAY_CNT, TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(V_VERSION || '01', 'YYYYMMDD')), 'DD')))
              , A.PFRSLT_THRY_CAPA_D
              , A.PFRSLT_PROD_CAPA_D
              , A.PFRSLT_PROD_CAPA_M
              , A.BASE_THRY_CAPA_D
              , A.BASE_PROD_CAPA_D
              /* 연도별이면 연 단위 일수, 월별이면 그 달 일수 */
              , (A.BASE_PPM * 1440.0 * (A.LD_RT * A.OP_RT * A.PF_RT * A.QL_RT))
                * CASE WHEN LENGTH(RTRIM(K.YYYYMM)) = 4
                       THEN CASE WHEN DY.DAY_CNT IS NOT NULL THEN DY.DAY_CNT
                                 ELSE TO_DATE(SUBSTR(K.YYYYMM, 1, 4) || '1231', 'YYYYMMDD')
                                    - TO_DATE(SUBSTR(K.YYYYMM, 1, 4) || '0101', 'YYYYMMDD') + 1
                            END
                       ELSE CASE WHEN DC.DAY_CNT IS NOT NULL THEN DC.DAY_CNT
                                 ELSE TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(K.YYYYMM || '01', 'YYYYMMDD')), 'DD'))
                            END
                  END
           FROM GT_SCP0106_CHK_FINAL A
              , (SELECT DIVISION_ID
                      , COMPANY_ID
                      , SITE_ID
                      , PLANT_ID
                      , FACTORY_ID
                      , LINE_ID
                      , OPERATION_ID
                      , ELTR_LN_TP_CD
                      , NICK_NAME
                      , YYYYMM
                   FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS
                  GROUP BY DIVISION_ID
                         , COMPANY_ID
                         , SITE_ID
                         , PLANT_ID
                         , FACTORY_ID
                         , LINE_ID
                         , OPERATION_ID
                         , ELTR_LN_TP_CD
                         , NICK_NAME
                         , YYYYMM) K
              , GT_SCP0106_CHK_DAY_CNT DC
              , GT_SCP0106_CHK_DAY_CNT DY
          WHERE A.SRC_TP           = 'RT'
            AND K.DIVISION_ID      = A.DIVISION_ID
            AND K.COMPANY_ID       = A.COMPANY_ID
            AND K.SITE_ID          = A.SITE_ID
            AND K.PLANT_ID         = A.PLANT_ID
            AND K.FACTORY_ID       = A.FACTORY_ID
            AND K.LINE_ID          = A.LINE_ID
            AND K.OPERATION_ID     = A.OPERATION_ID
            AND K.ELTR_LN_TP_CD    = A.ELTR_LN_TP_CD
            AND K.NICK_NAME        = A.MDL_NM
            AND DC.SRC_TP(+)         = 'OPP'
            AND DC.DIVISION_ID(+)    = A.DIVISION_ID
            AND DC.COMPANY_ID(+)     = A.COMPANY_ID
            AND DC.SITE_ID(+)        = A.SITE_ID
            AND DC.PLANT_ID(+)       = A.PLANT_ID
            AND DC.FACTORY_ID(+)     = A.FACTORY_ID
            AND DC.LINE_ID(+)        = A.LINE_ID
            AND DC.OPERATION_ID(+)   = A.OPERATION_ID
            AND DC.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND DC.YYYYMM(+)         = K.YYYYMM
            AND DY.SRC_TP(+)         = 'OPY'
            AND DY.DIVISION_ID(+)    = A.DIVISION_ID
            AND DY.COMPANY_ID(+)     = A.COMPANY_ID
            AND DY.SITE_ID(+)        = A.SITE_ID
            AND DY.PLANT_ID(+)       = A.PLANT_ID
            AND DY.FACTORY_ID(+)     = A.FACTORY_ID
            AND DY.LINE_ID(+)        = A.LINE_ID
            AND DY.OPERATION_ID(+)   = A.OPERATION_ID
            AND DY.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND DY.YYYYMM(+)         = SUBSTR(K.YYYYMM, 1, 4);

    /* 반영 대상 — 배정 열쇠 × 측정항목 */
    INSERT INTO GT_SCP0106_CHK_RAW
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , MDL_NM
                , PLANT_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , COMPANY_ID
                , SITE_ID
                , FACTORY_ID
                , MSR_GR_CD
                , MSR_TP_CD
                , YYYYMM
                , PFRSLT_NVL
                , BASE_NVL
                , MSR_NVL
                , MSR_DDN
                , ASSIGN_PRIORITY )
         SELECT V_VERSION
              , V_VERSION_SEQ
              , A.DIVISION_ID
--              , CASE WHEN A.ITEM_ID = '-' THEN A.NICK_NAME ELSE A.ITEM_ID END    --  2026.10.11 AJS
              , CASE WHEN A.ITEM_ID = '/' THEN A.NICK_NAME ELSE A.ITEM_ID END    --  2026.10.11 AJS
              , A.PLANT_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.COMPANY_ID
              , A.SITE_ID
              , A.FACTORY_ID
              , M.MSR_GR_CD
              , M.MSR_TP_CD
              , A.YYYYMM
              /* 실적값 */
              , CASE WHEN M.MSR_TP_CD = 'BM_RT'       THEN R.BM_RT
                     WHEN M.MSR_TP_CD = 'CM_RT'       THEN R.CM_RT
                     WHEN M.MSR_TP_CD = 'ID_RT'       THEN R.ID_RT
                     WHEN M.MSR_TP_CD = 'MR_RT'       THEN R.MR_RT
                     WHEN M.MSR_TP_CD = 'NM_RT'       THEN R.NM_RT
                     WHEN M.MSR_TP_CD = 'PD_RT'       THEN R.PD_RT
                     WHEN M.MSR_TP_CD = 'PM_RT'       THEN R.PM_RT
                     WHEN M.MSR_TP_CD = 'PP_RT'       THEN R.PP_RT
                     WHEN M.MSR_TP_CD = 'UD_RT'       THEN R.UD_RT
                     WHEN M.MSR_TP_CD = 'OP_RT'       THEN R.OP_RT
                     WHEN M.MSR_TP_CD = 'LD_RT'       THEN R.LD_RT
                     WHEN M.MSR_TP_CD = 'AV_RT'       THEN R.AV_RT
                     WHEN M.MSR_TP_CD = 'PF_RT'       THEN R.PF_RT
                     WHEN M.MSR_TP_CD = 'QL_RT'       THEN R.QL_RT
                     WHEN M.MSR_TP_CD = 'TEEP'        THEN R.TEEP
                     WHEN M.MSR_TP_CD = 'PROD_OP_RT'  THEN R.PROD_OP_RT
                     WHEN M.MSR_TP_CD = 'THRY_CAPA_D' THEN R.PFRSLT_THRY_CAPA_D
                     WHEN M.MSR_TP_CD = 'PROD_CAPA_D' THEN R.PFRSLT_PROD_CAPA_D
                     WHEN M.MSR_TP_CD = 'PROD_CAPA_M' THEN R.PFRSLT_PROD_CAPA_M
                END
              /* 기준값 — 기존 손실계획 값이 있으면 그것을 먼저 쓴다 */
              , CASE WHEN E.BASE_NVL IS NOT NULL THEN E.BASE_NVL
                     ELSE CASE WHEN M.MSR_TP_CD = 'BM_RT'       THEN R.BM_RT
                               WHEN M.MSR_TP_CD = 'CM_RT'       THEN R.CM_RT
                               WHEN M.MSR_TP_CD = 'ID_RT'       THEN R.ID_RT
                               WHEN M.MSR_TP_CD = 'MR_RT'       THEN R.MR_RT
                               WHEN M.MSR_TP_CD = 'NM_RT'       THEN R.NM_RT
                               WHEN M.MSR_TP_CD = 'PD_RT'       THEN R.PD_RT
                               WHEN M.MSR_TP_CD = 'PM_RT'       THEN R.PM_RT
                               WHEN M.MSR_TP_CD = 'PP_RT'       THEN R.PP_RT
                               WHEN M.MSR_TP_CD = 'UD_RT'       THEN R.UD_RT
                               WHEN M.MSR_TP_CD = 'OP_RT'       THEN R.OP_RT
                               WHEN M.MSR_TP_CD = 'LD_RT'       THEN R.LD_RT
                               WHEN M.MSR_TP_CD = 'AV_RT'       THEN 1.0   /* 초기데이터 base 조업율은 100% */
                               WHEN M.MSR_TP_CD = 'PF_RT'       THEN 1.0   /* 성능가동율 100% */
                               WHEN M.MSR_TP_CD = 'QL_RT'       THEN R.QL_RT
                               WHEN M.MSR_TP_CD = 'TEEP'        THEN (1.0 * R.LD_RT * R.OP_RT * R.PF_RT * R.QL_RT)
                               WHEN M.MSR_TP_CD = 'PROD_OP_RT'  THEN R.PROD_OP_RT
                               WHEN M.MSR_TP_CD = 'THRY_CAPA_D' THEN R.BASE_THRY_CAPA_D
                               WHEN M.MSR_TP_CD = 'PROD_CAPA_D' THEN R.BASE_PROD_CAPA_D
                               WHEN M.MSR_TP_CD = 'PROD_CAPA_M' THEN R.BASE_PROD_CAPA_M
                          END
                END
              /* 계획값 — Formation 은 손실계획에 저장된 값으로만 */
              , CASE WHEN A.OPERATION_ID = 'AFFFF' THEN L.MSR_NVL
                     ELSE CASE WHEN M.MSR_TP_CD = 'BM_RT'       THEN O.BM_RT
                               WHEN M.MSR_TP_CD = 'CM_RT'       THEN O.CM_RT
                               WHEN M.MSR_TP_CD = 'ID_RT'       THEN O.ID_RT
                               WHEN M.MSR_TP_CD = 'MR_RT'       THEN O.MR_RT
                               WHEN M.MSR_TP_CD = 'NM_RT'       THEN O.NM_RT
                               WHEN M.MSR_TP_CD = 'PD_RT'       THEN O.PD_RT
                               WHEN M.MSR_TP_CD = 'PM_RT'       THEN O.PM_RT
                               WHEN M.MSR_TP_CD = 'PP_RT'       THEN O.PP_RT
                               WHEN M.MSR_TP_CD = 'UD_RT'       THEN O.UD_RT
                               WHEN M.MSR_TP_CD = 'OP_RT'       THEN O.OP_RT
                               WHEN M.MSR_TP_CD = 'LD_RT'       THEN O.LD_RT
                               WHEN M.MSR_TP_CD = 'AV_RT'       THEN O.AV_RT
                               WHEN M.MSR_TP_CD = 'PF_RT'       THEN O.PF_RT
                               WHEN M.MSR_TP_CD = 'QL_RT'       THEN O.QL_RT
                               WHEN M.MSR_TP_CD = 'TEEP'        THEN O.TEEP
                               WHEN M.MSR_TP_CD = 'PROD_OP_RT'  THEN O.PROD_OP_RT
                               /* 운영계획 CAPA 는 BASE */
                               WHEN M.MSR_TP_CD = 'THRY_CAPA_D' THEN O.BASE_THRY_CAPA_D
                               WHEN M.MSR_TP_CD = 'PROD_CAPA_D' THEN O.BASE_PROD_CAPA_D
                               WHEN M.MSR_TP_CD = 'PROD_CAPA_M' THEN O.BASE_PROD_CAPA_M
                          END
                END
              , O.DAY_CNT
              , A.ASSIGN_PRIORITY
           FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS A
              , GT_SCP0106_CHK_MEASURE M
              , GT_SCP0106_CHK_FINAL R
              , GT_SCP0106_CHK_FINAL O
              , SCP_MST_CAPA_LOSS_PLAN_MDL L
              , GT_SCP0106_CHK_EXISTS_BASE E
          WHERE R.SRC_TP(+)         = 'RT'
            AND R.DIVISION_ID(+)    = A.DIVISION_ID
            AND R.COMPANY_ID(+)     = A.COMPANY_ID
            AND R.SITE_ID(+)        = A.SITE_ID
            AND R.PLANT_ID(+)       = A.PLANT_ID
            AND R.FACTORY_ID(+)     = A.FACTORY_ID
            AND R.LINE_ID(+)        = A.LINE_ID
            AND R.OPERATION_ID(+)   = A.OPERATION_ID
            AND R.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND R.MDL_NM(+)         = A.NICK_NAME
            AND O.SRC_TP(+)         = 'OP'
            AND O.DIVISION_ID(+)    = A.DIVISION_ID
            AND O.COMPANY_ID(+)     = A.COMPANY_ID
            AND O.SITE_ID(+)        = A.SITE_ID
            AND O.PLANT_ID(+)       = A.PLANT_ID
            AND O.FACTORY_ID(+)     = A.FACTORY_ID
            AND O.LINE_ID(+)        = A.LINE_ID
            AND O.OPERATION_ID(+)   = A.OPERATION_ID
            AND O.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND O.MDL_NM(+)         = A.NICK_NAME
            AND O.YYYYMM(+)         = A.YYYYMM
            AND L.DIVISION_ID(+)    = A.DIVISION_ID
            AND L.MDL_NM(+)         = A.NICK_NAME
            AND L.PLANT_ID(+)       = A.PLANT_ID
            AND L.LINE_ID(+)        = A.LINE_ID
            AND L.OPERATION_ID(+)   = A.OPERATION_ID
            AND L.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND L.COMPANY_ID(+)     = A.COMPANY_ID
            AND L.SITE_ID(+)        = A.SITE_ID
            AND L.FACTORY_ID(+)     = A.FACTORY_ID
            AND L.MSR_TP_CD(+)      = M.MSR_TP_CD
            AND L.YYYYMM(+)         = A.YYYYMM
            AND L.MSR_GR_CD(+)      = M.MSR_GR_CD
            AND E.DIVISION_ID(+)    = A.DIVISION_ID
            AND E.MDL_NM(+)         = A.NICK_NAME
            AND E.PLANT_ID(+)       = A.PLANT_ID
            AND E.LINE_ID(+)        = A.LINE_ID
            AND E.OPERATION_ID(+)   = A.OPERATION_ID
            AND E.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND E.COMPANY_ID(+)     = A.COMPANY_ID
            AND E.SITE_ID(+)        = A.SITE_ID
            AND E.FACTORY_ID(+)     = A.FACTORY_ID
            AND E.MSR_TP_CD(+)      = M.MSR_TP_CD
            AND E.MSR_GR_CD(+)      = M.MSR_GR_CD;

    /* Assign Priority 값이 없으면 기존 Loss Plan 값 삭제 */
    UPDATE GT_SCP0106_CHK_RAW
       SET MSR_NVL = NULL
     WHERE NVL(ASSIGN_PRIORITY, 0) = 0;

    /* 우선순위 합계가 0 인 열쇠는 반영 대상에서 뺀다 */
    DELETE GT_SCP0106_CHK_RAW A
     WHERE EXISTS (SELECT 1
                     FROM GT_SCP0106_CHK_NOT_VALID XA
                    WHERE XA.VALID_TP        = 'Y'
                      AND XA.ASSIGN_PRIORITY = 0
                      AND XA.DIVISION_ID     = A.DIVISION_ID
                      AND XA.COMPANY_ID      = A.COMPANY_ID
                      AND XA.SITE_ID         = A.SITE_ID
                      AND XA.PLANT_ID        = A.PLANT_ID
                      AND XA.FACTORY_ID      = A.FACTORY_ID
                      AND XA.LINE_ID         = A.LINE_ID
                      AND XA.OPERATION_ID    = A.OPERATION_ID
                      AND XA.ELTR_LN_TP_CD   = A.ELTR_LN_TP_CD
                      AND XA.NICK_NAME       = A.MDL_NM);

    /* INSERT - SCP_MST_CAPA_LOSS_PLAN - BEGIN
       원문은 MERGE 한 문장이나 온라인 SQL 에서 쓰지 않는 규칙이라 고치는 문장과 넣는 문장으로 나눈다 */
    FOR R IN (SELECT DIVISION_ID
                   , MDL_NM
                   , PLANT_ID
                   , LINE_ID
                   , OPERATION_ID
                   , ELTR_LN_TP_CD
                   , COMPANY_ID
                   , SITE_ID
                   , FACTORY_ID
                   , MSR_GR_CD
                   , MSR_TP_CD
                   , YYYYMM
                   , PFRSLT_NVL
                   , BASE_NVL
                   , MSR_NVL
                   , MSR_DDN
                   , ASSIGN_PRIORITY
                FROM GT_SCP0106_CHK_RAW
               WHERE DIVISION_ID   IS NOT NULL
                 AND MDL_NM        IS NOT NULL
                 AND PLANT_ID      IS NOT NULL
                 AND LINE_ID       IS NOT NULL
                 AND OPERATION_ID  IS NOT NULL
                 AND ELTR_LN_TP_CD IS NOT NULL
                 AND COMPANY_ID    IS NOT NULL
                 AND SITE_ID       IS NOT NULL
                 AND FACTORY_ID    IS NOT NULL
                 AND MSR_TP_CD     IS NOT NULL
                 AND YYYYMM        IS NOT NULL
                 AND MSR_GR_CD     IS NOT NULL)
    LOOP

        UPDATE SCP_MST_CAPA_LOSS_PLAN_MDL
           SET MSR_NVL          = CASE WHEN NVL(R.ASSIGN_PRIORITY, 0) = 0
                                        AND R.MSR_TP_CD IN ('THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M')
                                       THEN R.MSR_NVL
                                       ELSE MSR_NVL
                                  END
             , LAST_UPDATED_BY  = V_STAMP
             , LAST_UPDATE_DATE = SYSDATE
         WHERE DIVISION_ID   = R.DIVISION_ID
           AND MDL_NM        = R.MDL_NM
           AND PLANT_ID      = R.PLANT_ID
           AND LINE_ID       = R.LINE_ID
           AND OPERATION_ID  = R.OPERATION_ID
           AND ELTR_LN_TP_CD = R.ELTR_LN_TP_CD
           AND COMPANY_ID    = R.COMPANY_ID
           AND SITE_ID       = R.SITE_ID
           AND FACTORY_ID    = R.FACTORY_ID
           AND MSR_TP_CD     = R.MSR_TP_CD
           AND YYYYMM        = R.YYYYMM
           AND MSR_GR_CD     = R.MSR_GR_CD;

        IF SQL%ROWCOUNT = 0 THEN

            INSERT INTO SCP_MST_CAPA_LOSS_PLAN_MDL
                        ( DIVISION_ID
                        , MDL_NM
                        , PLANT_ID
                        , LINE_ID
                        , OPERATION_ID
                        , ELTR_LN_TP_CD
                        , COMPANY_ID
                        , SITE_ID
                        , FACTORY_ID
                        , MSR_TP_CD
                        , YYYYMM
                        , PFRSLT_NVL
                        , BASE_NVL
                        , MSR_GR_CD
                        , MSR_NVL
                        , CREATED_BY
                        , CREATION_DATE
                        , LAST_UPDATED_BY
                        , LAST_UPDATE_DATE )
                 VALUES ( R.DIVISION_ID
                        , R.MDL_NM
                        , R.PLANT_ID
                        , R.LINE_ID
                        , R.OPERATION_ID
                        , R.ELTR_LN_TP_CD
                        , R.COMPANY_ID
                        , R.SITE_ID
                        , R.FACTORY_ID
                        , R.MSR_TP_CD
                        , R.YYYYMM
                        , R.PFRSLT_NVL
                        , R.BASE_NVL
                        , R.MSR_GR_CD
                        , R.MSR_NVL
                        , V_STAMP
                        , SYSDATE
                        , V_STAMP
                        , SYSDATE );

        END IF;

    END LOOP;

    /* 우선순위가 없으면 사용자가 입력한 월별 데이터도 클리어 */
    UPDATE SCP_MST_CAPA_LOSS_PLAN_MDL A
       SET A.MSR_NVL = NULL
     WHERE EXISTS (SELECT 1
                     FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XA
                    WHERE XA.DIVISION_ID   = A.DIVISION_ID
                      AND XA.COMPANY_ID    = A.COMPANY_ID
                      AND XA.SITE_ID       = A.SITE_ID
                      AND XA.PLANT_ID      = A.PLANT_ID
                      AND XA.FACTORY_ID    = A.FACTORY_ID
                      AND XA.LINE_ID       = A.LINE_ID
                      AND XA.OPERATION_ID  = A.OPERATION_ID
                      AND XA.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                      AND XA.NICK_NAME     = A.MDL_NM
                      AND XA.YYYYMM        = A.YYYYMM
                      AND NVL(XA.ASSIGN_PRIORITY, 0) = 0);

    /* 아예 삭제함 */
    DELETE SCP_MST_CAPA_LOSS_PLAN_MDL A
     WHERE EXISTS (SELECT 1
                     FROM SCP_MST_CAPA_LINE_ASSIGN XA
                    WHERE XA.DIVISION_ID   = A.DIVISION_ID
                      AND XA.COMPANY_ID    = A.COMPANY_ID
                      AND XA.SITE_ID       = A.SITE_ID
                      AND XA.PLANT_ID      = A.PLANT_ID
                      AND XA.FACTORY_ID    = A.FACTORY_ID
                      AND XA.LINE_ID       = A.LINE_ID
                      AND XA.OPERATION_ID  = A.OPERATION_ID
                      AND XA.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                      AND XA.NICK_NAME     = A.MDL_NM
                      AND XA.YYYYMM        = A.YYYYMM
                      AND ((NVL(XA.ASSIGN_PRIORITY, 0) = 0 AND XA.VALID_YN = 'Y' AND XA.OPERATION_ID <> 'AFFFF')
                         OR XA.VALID_YN <> 'Y'));
    /* INSERT - SCP_MST_CAPA_LOSS_PLAN - END */

END P_SCP0106_CHK_LOSS_ASGN_ASM;


/****************************************************************************************************/
/* Program ID  : P_SCP0106_CALC_SPEED_PLAN_ELTR                                                     */
/* Description : 손실계획 검증에 쓰는 전극 속도계획(PPM) 계산                                       */
/*               결과 : GT_SCP0106_CHK_SPEED_PLAN (품목별 기준 PPM · 실적 PPM)                      */
/****************************************************************************************************/
PROCEDURE P_SCP0106_CALC_SPEED_PLAN_ELTR
(
    P_VERSION               IN  VARCHAR2
  , P_VERSION_SEQ           IN  NUMBER
  , P_RESULT_TO_YYYYMM      IN  VARCHAR2
)
IS
BEGIN

    DELETE GT_SCP0106_CHK_SPD_UNIT;
    DELETE GT_SCP0106_CHK_SPD_SRC;
    DELETE GT_SCP0106_CHK_SPD_RAW;
    DELETE GT_SCP0106_CHK_SPEED_PLAN;

    /* 전극 공정별 속도 단위 */
    INSERT INTO GT_SCP0106_CHK_SPD_UNIT
                ( UNIT_GROUP
                , OPERATION_ID
                , MSR_TP_CD
                , LINE_TYPE
                , UNIT_GROUP_SEQ
                , DISPLAY_SEQ )
         SELECT SEGMENT1
              , SEGMENT2
              , SEGMENT3
              , SEGMENT4
              , SEGMENT5
              , DISPLAY_SEQ
           FROM SCM_ADM_LOOKUP_MASTER_DETAIL
          WHERE LOOKUP_TYPE = 'OPERATION_SPEED_ELTR_UNIT'
            AND VALID_YN    = 'Y';

    /* 실적 — 전극 설비 속도 월별 (라인 단위) */
    INSERT INTO GT_SCP0106_CHK_SPD_SRC
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , SPEED_UNIT_GROUP
                , MSR_TP_CD
                , EQP_NBU
                , EQP_SPED )
         SELECT 'RST'
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , B.UNIT_GROUP
              , UPPER(A.EQP_SPED_UNIT_CD)
              , AVG(A.EQP_NBU)
              , AVG(A.EQP_SPED)
           FROM SCM_DNM_ELTR_EQP_SPED_MMLY A
              , (SELECT UNIT_GROUP
                      , MSR_TP_CD
                   FROM GT_SCP0106_CHK_SPD_UNIT
                  GROUP BY UNIT_GROUP
                         , MSR_TP_CD) B
          WHERE B.MSR_TP_CD(+) = A.EQP_SPED_UNIT_CD
            AND A.PERD_DIVS_CD = '3'
            AND A.PFRSLT_YM    = P_RESULT_TO_YYYYMM
          GROUP BY A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.SITE_ID
                 , A.PLANT_ID
                 , A.FACTORY_ID
                 , A.LINE_ID
                 , A.OPERATION_ID
                 , A.ELTR_LN_TP_CD
                 , B.UNIT_GROUP
                 , A.EQP_SPED_UNIT_CD;

    /* 기준 — 설비 원장과 설비 속도로 품목별 기준을 만든다
       ★설비 원장이 아직 옮겨지지 않아 이 갈래는 값이 나오지 않는다(데이터 상태) */
    INSERT INTO GT_SCP0106_CHK_SPD_SRC
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , NICK_NAME
                , SPEED_UNIT_GROUP
                , MSR_TP_CD
                , EQP_SPED
                , UI_UPD_YN )
         SELECT 'BSE'
              , IA.DIVISION_ID
              , IA.COMPANY_ID
              , IA.SITE_ID
              , IA.PLANT_ID
              , IA.FACTORY_ID
              , IA.LINE_ID
              , IA.OPERATION_ID
              , IA.ELTR_LN_TP_CD
              , IA.BOM_ITEM_ID
              , 'EQP_SPED'
              , 'EQP_SPED'
              , AVG(IA.EQP_SPED)
              , 'N'
           FROM (SELECT A.COMPANY_ID
                      , A.DIVISION_ID
                      , A.SITE_ID
                      , A.PLANT_ID
                      , A.FACTORY_ID
                      , A.LINE_ID
                      , A.OPERATION_ID
                      , B.BOM_ITEM_ID
                      , CASE WHEN A.WIDE_ROLL_ENABLE_FLAG = 'Y' THEN 'W' ELSE 'S' END AS ELTR_LN_TP_CD
                      , B.EQP_SPED
                      , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                                      , A.SITE_ID
                                                      , A.COMPANY_ID
                                                      , A.PLANT_ID
                                                      , A.LINE_ID
                                                      , A.OPERATION_ID
                                                      , B.BOM_ITEM_ID
                                               ORDER BY B.UPDATE_TIME DESC
                                                      , A.UPDATE_TIME DESC) AS RN
                   FROM SCM_MST_EQUIPMENT_SN A
                      , SCM_MMD_EQPT_PRDT_SPEED_SN B
                  WHERE B.EQP_ID         = A.EQUIPMENT_ID
                    AND A.OPERATION_ID LIKE 'E2000%'
                    AND A.EQUIPMENT_TYPE = 'M'
                    AND A.ACTIVE_FLAG    = 'Y') IA
          WHERE IA.RN = 1
          GROUP BY IA.COMPANY_ID
                 , IA.DIVISION_ID
                 , IA.SITE_ID
                 , IA.PLANT_ID
                 , IA.FACTORY_ID
                 , IA.LINE_ID
                 , IA.OPERATION_ID
                 , IA.ELTR_LN_TP_CD
                 , IA.BOM_ITEM_ID;

    /* 속도계획 원장에서 배정된 열쇠분 */
    INSERT INTO GT_SCP0106_CHK_SPD_RAW
                ( STEP_NO
                , VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , SPEED_UNIT_GROUP
                , MSR_TP_CD
                , YYYYMM
                , BASE_QTY
                , QTY )
         SELECT 1
              , P_VERSION
              , P_VERSION_SEQ
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.ITEM_ID
              , A.NICK_NAME
              , 'EQP_SPED'
              , A.MSR_TP_CD
              , A.YYYYMM
              , A.BASE_QTY
              , A.QTY
           FROM SCP_MST_CAPA_ELTR_SPEED_PLAN A
          WHERE A.MSR_TP_CD = 'EQP_SPED'
            AND EXISTS (SELECT 1
                          FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XA
                         WHERE XA.DIVISION_ID  = A.DIVISION_ID
                           AND XA.COMPANY_ID   = A.COMPANY_ID
                           AND XA.SITE_ID      = A.SITE_ID
                           AND XA.PLANT_ID     = A.PLANT_ID
                           AND XA.FACTORY_ID   = A.FACTORY_ID
                           AND XA.LINE_ID      = A.LINE_ID
                           AND XA.OPERATION_ID = A.OPERATION_ID
                           AND XA.ITEM_ID      = A.ITEM_ID
                           AND XA.YYYYMM       = A.YYYYMM);

    /* 기준·실적을 붙여 품목별 PPM 을 만든다 */
    INSERT INTO GT_SCP0106_CHK_SPEED_PLAN
                ( DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , NICK_NAME
                , BASE_PPM
                , PFRSLT_PPM )
         SELECT A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.ITEM_ID
              , AVG(B.EQP_SPED)
              , AVG(R.EQP_SPED)
           FROM GT_SCP0106_CHK_SPD_RAW A
              , GT_SCP0106_CHK_SPD_SRC B
              , GT_SCP0106_CHK_SPD_SRC R
          WHERE A.STEP_NO = 1
            AND B.SRC_TP(+)        = 'BSE'
            AND B.DIVISION_ID(+)   = A.DIVISION_ID
            AND B.COMPANY_ID(+)    = A.COMPANY_ID
            AND B.SITE_ID(+)       = A.SITE_ID
            AND B.PLANT_ID(+)      = A.PLANT_ID
            AND B.FACTORY_ID(+)    = A.FACTORY_ID
            AND B.LINE_ID(+)       = A.LINE_ID
            AND B.OPERATION_ID(+)  = A.OPERATION_ID
            AND B.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
            AND B.NICK_NAME(+)     = A.ITEM_ID
            AND R.SRC_TP(+)        = 'RST'
            AND R.DIVISION_ID(+)   = A.DIVISION_ID
            AND R.COMPANY_ID(+)    = A.COMPANY_ID
            AND R.SITE_ID(+)       = A.SITE_ID
            AND R.PLANT_ID(+)      = A.PLANT_ID
            AND R.FACTORY_ID(+)    = A.FACTORY_ID
            AND R.LINE_ID(+)       = A.LINE_ID
            AND R.OPERATION_ID(+)  = A.OPERATION_ID
            AND R.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
          GROUP BY A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.SITE_ID
                 , A.PLANT_ID
                 , A.FACTORY_ID
                 , A.LINE_ID
                 , A.OPERATION_ID
                 , A.ELTR_LN_TP_CD
                 , A.ITEM_ID;

END P_SCP0106_CALC_SPEED_PLAN_ELTR;

/****************************************************************************************************/
/* Program ID  : P_SCP0106_CHK_LOSS_ASGN_ELTR                                                       */
/* Description : ASSIGN 테이블 구조의 데이터를 파라미터로 Loss Plan Insert/Update — 전극            */
/*               전달 테이블은 GT_SCP_CAPA_LINE_ASSIGN_KEYS 로 받는다(부르는 쪽이 채운다)           */
/*               조립과 갈리는 곳 : 손실 실적이 라인별 하나 · 조업율과 성능가동률을 실적에서 가져옴 */
/*                                  광폭이면 생산능력 2배 · 저장 열쇠에 전극구분이 없다             */
/****************************************************************************************************/
PROCEDURE P_SCP0106_CHK_LOSS_ASGN_ELTR
(
    P_PROGRAM_ID            IN  VARCHAR2
  , P_SHEET_NAME            IN  VARCHAR2
  , P_USER_ID               IN  VARCHAR2
  , P_DEBUG_MODE            IN  VARCHAR2
)
IS
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0106_CHECK_CAPA_LOSS_PLAN_BY_ASSIGN_ELTR';
    V_STAMP             VARCHAR2(800 CHAR);
    V_VERSION           VARCHAR2(40 CHAR);
    V_VERSION_SEQ       NUMBER(3);
    V_RESULT_TO_YYYYMM  VARCHAR2(6 CHAR);
    V_RESULT_FR_YYYYMM  VARCHAR2(6 CHAR);
    V_RESULT_DAY_CNT    NUMBER(20,10)      := 1.0;
BEGIN

    V_STAMP := V_PROGRAM_NAME || '-' || P_USER_ID;

    DELETE GT_SCP0106_CHK_MEASURE;
    DELETE GT_SCP0106_CHK_NOT_VALID;
    DELETE GT_SCP0106_CHK_LOSS_RSLT;
    DELETE GT_SCP0106_CHK_DAY_CNT;
    DELETE GT_SCP0106_CHK_FINAL;
    DELETE GT_SCP0106_CHK_EXISTS_BASE;
    DELETE GT_SCP0106_CHK_RAW;

    /* 사용여부가 Y 가 아닌 열쇠 — 전극은 품목이 열쇠다 */
    INSERT INTO GT_SCP0106_CHK_NOT_VALID
                ( VALID_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , NICK_NAME )
         SELECT 'N'
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , ITEM_ID
           FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS
          WHERE VALID_YN <> 'Y'
          GROUP BY DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , ITEM_ID;

    INSERT INTO GT_SCP0106_CHK_NOT_VALID
                ( VALID_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , NICK_NAME
                , ASSIGN_PRIORITY )
         SELECT 'Y'
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , ITEM_ID
              , SUM(ASSIGN_PRIORITY)
           FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS
          WHERE VALID_YN <> 'N'
          GROUP BY DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , ITEM_ID;

    SELECT MAX(VER_ID)
         , MAX(VER_SEQ)
      INTO V_VERSION
         , V_VERSION_SEQ
      FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS;

    V_RESULT_TO_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -1), 'YYYYMM');
    V_RESULT_FR_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -3), 'YYYYMM');

    SELECT NVL(AVG(DAY_CNT), 1.0)
      INTO V_RESULT_DAY_CNT
      FROM (SELECT BASIS_YYYYMM
                 , COUNT(*) AS DAY_CNT
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD >= V_RESULT_FR_YYYYMM
               AND BASIS_YYYYMMDD <  V_VERSION
             GROUP BY BASIS_YYYYMM) IA;

    /* 전극 손실 측정항목 */
    INSERT INTO GT_SCP0106_CHK_MEASURE
                ( MSR_GR_CD
                , MSR_TP_CD
                , DISPLAY_SEQ )
         SELECT ATTRIBUTE3
              , SEGMENT1
              , DISPLAY_SEQ
           FROM SCM_ADM_LOOKUP_MASTER_DETAIL
          WHERE LOOKUP_TYPE = 'SCP_CAPA_ELTR_LOSS_MEASURE'
            AND VALID_YN    = 'Y'
            AND SEGMENT1 NOT IN ('EQP_NBU', 'TACT_TIME', 'PPM', 'SCP_PROD_PLAN_DDN');

    /* 속도계획(PPM) */
    P_SCP0106_CALC_SPEED_PLAN_ELTR(V_VERSION, V_VERSION_SEQ, V_RESULT_TO_YYYYMM);

    /* 양산시점 기준 일수 */
    INSERT INTO GT_SCP0106_CHK_DAY_CNT
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , SOP_DT
                , YYYYMM
                , DAY_CNT )
         SELECT 'BSE'
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , SOP_DT
              , SOP_YM
              , SOP_DDN
           FROM SCP_MST_CAPA_ELTR_LINE_SOP
          WHERE VALID_YN = 'Y'
            AND SOP_YM   = V_VERSION;

    INSERT INTO GT_SCP0106_CHK_DAY_CNT
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , SOP_DT
                , YYYYMM
                , DAY_CNT )
         SELECT 'OPP'
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , SOP_DT
              , SOP_YM
              , SOP_DDN
           FROM SCP_MST_CAPA_ELTR_LINE_SOP
          WHERE VALID_YN = 'Y';

    INSERT INTO GT_SCP0106_CHK_DAY_CNT
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , SOP_DT
                , YYYYMM
                , DAY_CNT )
         SELECT 'OPY'
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , SOP_DT
              , SUBSTR(YYYYMM, 1, 4)
              /* ★양산시점 월이 비어 있는 행이 있어 날짜로 바꾸기 전에 걸러낸다 */
              , CASE WHEN TRIM(YYYYMM) IS NULL THEN NULL
                     WHEN TRIM(SOP_DT) IS NOT NULL
                     THEN TO_DATE(SUBSTR(YYYYMM, 1, 4) || '1231', 'YYYYMMDD') - FN_CHAR_TO_DATE(SOP_DT) + 1
                     ELSE TO_DATE(SUBSTR(YYYYMM, 1, 4) || '1231', 'YYYYMMDD')
                          - TO_DATE(SUBSTR(YYYYMM, 1, 4) || '0101', 'YYYYMMDD') + 1
                END
           FROM GT_SCP0106_CHK_DAY_CNT
          WHERE SRC_TP = 'OPP';

    /* 전극 실적 손실율 — 라인별 하나뿐이다 */
    INSERT INTO GT_SCP0106_CHK_LOSS_RSLT
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , MDL_NM
                , LOSS_CD
                , LOSS_RT )
         SELECT 'LN'
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , '-'
              , LOSS_CD
              , AVG(LOSS_RT)
           FROM SCM_DNM_ELTR_LOSS_LN_MMLY
          WHERE PERD_DIVS_CD = '3'
            AND LOSS_YM      = V_RESULT_TO_YYYYMM
          GROUP BY DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , LOSS_CD;

    /* 기존 손실계획의 기준값 */
    INSERT INTO GT_SCP0106_CHK_EXISTS_BASE
                ( DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , MDL_NM
                , MSR_GR_CD
                , MSR_TP_CD
                , BASE_NVL )
         SELECT DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , MDL_NM
              , MSR_GR_CD
              , MSR_TP_CD
              , BASE_NVL
           FROM (SELECT A.DIVISION_ID
                      , A.COMPANY_ID
                      , A.SITE_ID
                      , A.PLANT_ID
                      , A.FACTORY_ID
                      , A.LINE_ID
                      , A.OPERATION_ID
                      , A.ELTR_LN_TP_CD
                      , A.MDL_NM
                      , A.MSR_GR_CD
                      , A.MSR_TP_CD
                      , A.BASE_NVL
                      , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                                      , A.COMPANY_ID
                                                      , A.SITE_ID
                                                      , A.PLANT_ID
                                                      , A.FACTORY_ID
                                                      , A.LINE_ID
                                                      , A.OPERATION_ID
                                                      , A.ELTR_LN_TP_CD
                                                      , A.MDL_NM
                                                      , A.MSR_GR_CD
                                                      , A.MSR_TP_CD
                                               ORDER BY A.YYYYMM) AS RN
                   FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
                      , (SELECT DIVISION_ID
                              , COMPANY_ID
                              , SITE_ID
                              , PLANT_ID
                              , FACTORY_ID
                              , LINE_ID
                              , OPERATION_ID
                              , ELTR_LN_TP_CD
                           FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS
                          GROUP BY DIVISION_ID
                                 , COMPANY_ID
                                 , SITE_ID
                                 , PLANT_ID
                                 , FACTORY_ID
                                 , LINE_ID
                                 , OPERATION_ID
                                 , ELTR_LN_TP_CD) B
                  WHERE B.DIVISION_ID   = A.DIVISION_ID
                    AND B.COMPANY_ID    = A.COMPANY_ID
                    AND B.SITE_ID       = A.SITE_ID
                    AND B.PLANT_ID      = A.PLANT_ID
                    AND B.FACTORY_ID    = A.FACTORY_ID
                    AND B.LINE_ID       = A.LINE_ID
                    AND B.OPERATION_ID  = A.OPERATION_ID
                    AND B.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD) IA
          WHERE IA.RN = 1;

    /* 라인 단위 손실율 — 전극은 조업율·성능가동률도 실적에서 가져오고 1 로 깎지 않는다 */
    INSERT INTO GT_SCP0106_CHK_FINAL
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , MDL_NM
                , BM_RT
                , CM_RT
                , ID_RT
                , MR_RT
                , NM_RT
                , PD_RT
                , PM_RT
                , PP_RT
                , UD_RT
                , AV_RT
                , PF_RT
                , QL_RT )
         SELECT 'RT'
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , '-'
              , NVL(BM.LOSS_RT, 0)
              , CM.LOSS_RT
              , ID.LOSS_RT
              , MR.LOSS_RT
              , NM.LOSS_RT
              , PD.LOSS_RT
              , PM.LOSS_RT
              , PP.LOSS_RT
              , UD.LOSS_RT
              , AV.LOSS_RT
              , PF.LOSS_RT
              , QL.LOSS_RT
           FROM (SELECT DIVISION_ID
                      , COMPANY_ID
                      , SITE_ID
                      , PLANT_ID
                      , FACTORY_ID
                      , LINE_ID
                      , OPERATION_ID
                      , ELTR_LN_TP_CD
                   FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS
                  GROUP BY DIVISION_ID
                         , COMPANY_ID
                         , SITE_ID
                         , PLANT_ID
                         , FACTORY_ID
                         , LINE_ID
                         , OPERATION_ID
                         , ELTR_LN_TP_CD) A
              , GT_SCP0106_CHK_LOSS_RSLT BM
              , GT_SCP0106_CHK_LOSS_RSLT CM
              , GT_SCP0106_CHK_LOSS_RSLT ID
              , GT_SCP0106_CHK_LOSS_RSLT MR
              , GT_SCP0106_CHK_LOSS_RSLT NM
              , GT_SCP0106_CHK_LOSS_RSLT PD
              , GT_SCP0106_CHK_LOSS_RSLT PM
              , GT_SCP0106_CHK_LOSS_RSLT PP
              , GT_SCP0106_CHK_LOSS_RSLT UD
              , GT_SCP0106_CHK_LOSS_RSLT AV
              , GT_SCP0106_CHK_LOSS_RSLT PF
              , GT_SCP0106_CHK_LOSS_RSLT QL
          WHERE BM.LOSS_CD(+)        = 'BM_RT'
            AND BM.DIVISION_ID(+)    = A.DIVISION_ID
            AND BM.COMPANY_ID(+)     = A.COMPANY_ID
            AND BM.SITE_ID(+)        = A.SITE_ID
            AND BM.PLANT_ID(+)       = A.PLANT_ID
            AND BM.FACTORY_ID(+)     = A.FACTORY_ID
            AND BM.LINE_ID(+)        = A.LINE_ID
            AND BM.OPERATION_ID(+)   = A.OPERATION_ID
            AND BM.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND CM.LOSS_CD(+)        = 'CM_RT'
            AND CM.DIVISION_ID(+)    = A.DIVISION_ID
            AND CM.COMPANY_ID(+)     = A.COMPANY_ID
            AND CM.SITE_ID(+)        = A.SITE_ID
            AND CM.PLANT_ID(+)       = A.PLANT_ID
            AND CM.FACTORY_ID(+)     = A.FACTORY_ID
            AND CM.LINE_ID(+)        = A.LINE_ID
            AND CM.OPERATION_ID(+)   = A.OPERATION_ID
            AND CM.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND ID.LOSS_CD(+)        = 'ID_RT'
            AND ID.DIVISION_ID(+)    = A.DIVISION_ID
            AND ID.COMPANY_ID(+)     = A.COMPANY_ID
            AND ID.SITE_ID(+)        = A.SITE_ID
            AND ID.PLANT_ID(+)       = A.PLANT_ID
            AND ID.FACTORY_ID(+)     = A.FACTORY_ID
            AND ID.LINE_ID(+)        = A.LINE_ID
            AND ID.OPERATION_ID(+)   = A.OPERATION_ID
            AND ID.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND MR.LOSS_CD(+)        = 'MR_RT'
            AND MR.DIVISION_ID(+)    = A.DIVISION_ID
            AND MR.COMPANY_ID(+)     = A.COMPANY_ID
            AND MR.SITE_ID(+)        = A.SITE_ID
            AND MR.PLANT_ID(+)       = A.PLANT_ID
            AND MR.FACTORY_ID(+)     = A.FACTORY_ID
            AND MR.LINE_ID(+)        = A.LINE_ID
            AND MR.OPERATION_ID(+)   = A.OPERATION_ID
            AND MR.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND NM.LOSS_CD(+)        = 'NM_RT'
            AND NM.DIVISION_ID(+)    = A.DIVISION_ID
            AND NM.COMPANY_ID(+)     = A.COMPANY_ID
            AND NM.SITE_ID(+)        = A.SITE_ID
            AND NM.PLANT_ID(+)       = A.PLANT_ID
            AND NM.FACTORY_ID(+)     = A.FACTORY_ID
            AND NM.LINE_ID(+)        = A.LINE_ID
            AND NM.OPERATION_ID(+)   = A.OPERATION_ID
            AND NM.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND PD.LOSS_CD(+)        = 'PD_RT'
            AND PD.DIVISION_ID(+)    = A.DIVISION_ID
            AND PD.COMPANY_ID(+)     = A.COMPANY_ID
            AND PD.SITE_ID(+)        = A.SITE_ID
            AND PD.PLANT_ID(+)       = A.PLANT_ID
            AND PD.FACTORY_ID(+)     = A.FACTORY_ID
            AND PD.LINE_ID(+)        = A.LINE_ID
            AND PD.OPERATION_ID(+)   = A.OPERATION_ID
            AND PD.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND PM.LOSS_CD(+)        = 'PM_RT'
            AND PM.DIVISION_ID(+)    = A.DIVISION_ID
            AND PM.COMPANY_ID(+)     = A.COMPANY_ID
            AND PM.SITE_ID(+)        = A.SITE_ID
            AND PM.PLANT_ID(+)       = A.PLANT_ID
            AND PM.FACTORY_ID(+)     = A.FACTORY_ID
            AND PM.LINE_ID(+)        = A.LINE_ID
            AND PM.OPERATION_ID(+)   = A.OPERATION_ID
            AND PM.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND PP.LOSS_CD(+)        = 'PP_RT'
            AND PP.DIVISION_ID(+)    = A.DIVISION_ID
            AND PP.COMPANY_ID(+)     = A.COMPANY_ID
            AND PP.SITE_ID(+)        = A.SITE_ID
            AND PP.PLANT_ID(+)       = A.PLANT_ID
            AND PP.FACTORY_ID(+)     = A.FACTORY_ID
            AND PP.LINE_ID(+)        = A.LINE_ID
            AND PP.OPERATION_ID(+)   = A.OPERATION_ID
            AND PP.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND UD.LOSS_CD(+)        = 'UD_RT'
            AND UD.DIVISION_ID(+)    = A.DIVISION_ID
            AND UD.COMPANY_ID(+)     = A.COMPANY_ID
            AND UD.SITE_ID(+)        = A.SITE_ID
            AND UD.PLANT_ID(+)       = A.PLANT_ID
            AND UD.FACTORY_ID(+)     = A.FACTORY_ID
            AND UD.LINE_ID(+)        = A.LINE_ID
            AND UD.OPERATION_ID(+)   = A.OPERATION_ID
            AND UD.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND AV.LOSS_CD(+)        = 'AV_RT'
            AND AV.DIVISION_ID(+)    = A.DIVISION_ID
            AND AV.COMPANY_ID(+)     = A.COMPANY_ID
            AND AV.SITE_ID(+)        = A.SITE_ID
            AND AV.PLANT_ID(+)       = A.PLANT_ID
            AND AV.FACTORY_ID(+)     = A.FACTORY_ID
            AND AV.LINE_ID(+)        = A.LINE_ID
            AND AV.OPERATION_ID(+)   = A.OPERATION_ID
            AND AV.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND PF.LOSS_CD(+)        = 'PF_RT'
            AND PF.DIVISION_ID(+)    = A.DIVISION_ID
            AND PF.COMPANY_ID(+)     = A.COMPANY_ID
            AND PF.SITE_ID(+)        = A.SITE_ID
            AND PF.PLANT_ID(+)       = A.PLANT_ID
            AND PF.FACTORY_ID(+)     = A.FACTORY_ID
            AND PF.LINE_ID(+)        = A.LINE_ID
            AND PF.OPERATION_ID(+)   = A.OPERATION_ID
            AND PF.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND QL.LOSS_CD(+)        = 'QL_RT'
            AND QL.DIVISION_ID(+)    = A.DIVISION_ID
            AND QL.COMPANY_ID(+)     = A.COMPANY_ID
            AND QL.SITE_ID(+)        = A.SITE_ID
            AND QL.PLANT_ID(+)       = A.PLANT_ID
            AND QL.FACTORY_ID(+)     = A.FACTORY_ID
            AND QL.LINE_ID(+)        = A.LINE_ID
            AND QL.OPERATION_ID(+)   = A.OPERATION_ID
            AND QL.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD;

    /* 가동률 — 빠진 값은 0 으로 보고 셈한다 */
    UPDATE GT_SCP0106_CHK_FINAL
       SET OP_RT = (1.0 - (NVL(BM_RT, 0.0) + NVL(CM_RT, 0.0) + NVL(PD_RT, 0.0) + NVL(PM_RT, 0.0)
                         + NVL(UD_RT, 0.0) + NVL(PP_RT, 0.0) + NVL(MR_RT, 0.0)))
         , LD_RT = (1.0 - (NVL(ID_RT, 0.0) + NVL(NM_RT, 0.0)))
     WHERE SRC_TP = 'RT';

    UPDATE GT_SCP0106_CHK_FINAL
       SET TEEP              = (AV_RT * LD_RT * OP_RT * PF_RT * QL_RT)
         , PROD_OP_RT        = (LD_RT * OP_RT * PF_RT * QL_RT)
         , BASE_AV_RT        = 1.0
         , BASE_PF_RT        = 1.0
         , BASE_TEEP         = (1.0 * LD_RT * OP_RT * 1.0 * QL_RT)
         , BASE_PROD_OP_RT   = (LD_RT * OP_RT * 1.0 * QL_RT)
     WHERE SRC_TP = 'RT';

    /* 품목별 생산능력 — 광폭이면 두 배 */
    INSERT INTO GT_SCP0106_CHK_FINAL
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , MDL_NM
                , BM_RT
                , CM_RT
                , ID_RT
                , MR_RT
                , NM_RT
                , PD_RT
                , PM_RT
                , PP_RT
                , UD_RT
                , OP_RT
                , LD_RT
                , AV_RT
                , PF_RT
                , QL_RT
                , TEEP
                , PROD_OP_RT
                , BASE_AV_RT
                , BASE_PF_RT
                , BASE_TEEP
                , BASE_PROD_OP_RT
                , BASE_PPM
                , PFRSLT_PPM
                , DAY_CNT
                , PFRSLT_THRY_CAPA_D
                , PFRSLT_PROD_CAPA_D
                , PFRSLT_PROD_CAPA_M
                , BASE_THRY_CAPA_D
                , BASE_PROD_CAPA_D
                , BASE_PROD_CAPA_M )
         SELECT 'MD'
              , B.DIVISION_ID
              , B.COMPANY_ID
              , B.SITE_ID
              , B.PLANT_ID
              , B.FACTORY_ID
              , B.LINE_ID
              , B.OPERATION_ID
              , B.ELTR_LN_TP_CD
              , K.ITEM_ID
              , B.BM_RT
              , B.CM_RT
              , B.ID_RT
              , B.MR_RT
              , B.NM_RT
              , B.PD_RT
              , B.PM_RT
              , B.PP_RT
              , B.UD_RT
              , B.OP_RT
              , B.LD_RT
              , B.AV_RT
              , B.PF_RT
              , B.QL_RT
              , B.TEEP
              , B.PROD_OP_RT
              , B.BASE_AV_RT
              , B.BASE_PF_RT
              , B.BASE_TEEP
              , B.BASE_PROD_OP_RT
              , S.BASE_PPM
              , S.PFRSLT_PPM
              , DC.DAY_CNT
              , CASE WHEN B.ELTR_LN_TP_CD = 'W' THEN 2.0 ELSE 1.0 END * (S.PFRSLT_PPM * 1440.0)
              , CASE WHEN B.ELTR_LN_TP_CD = 'W' THEN 2.0 ELSE 1.0 END * (S.PFRSLT_PPM * 1440.0)
                * (B.LD_RT * B.OP_RT * B.PF_RT * B.QL_RT)
              , CASE WHEN B.ELTR_LN_TP_CD = 'W' THEN 2.0 ELSE 1.0 END * (S.PFRSLT_PPM * 1440.0)
                * (B.LD_RT * B.OP_RT * B.PF_RT * B.QL_RT) * V_RESULT_DAY_CNT
              , CASE WHEN B.ELTR_LN_TP_CD = 'W' THEN 2.0 ELSE 1.0 END * (S.BASE_PPM * 1440.0)
              , CASE WHEN B.ELTR_LN_TP_CD = 'W' THEN 2.0 ELSE 1.0 END * (S.BASE_PPM * 1440.0)
                * (B.LD_RT * B.OP_RT * 1.0 * B.QL_RT)
              , CASE WHEN B.ELTR_LN_TP_CD = 'W' THEN 2.0 ELSE 1.0 END * (S.BASE_PPM * 1440.0)
                * (B.LD_RT * B.OP_RT * 1.0 * B.QL_RT)
                * CASE WHEN DC.DAY_CNT IS NOT NULL THEN DC.DAY_CNT
                       ELSE TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(V_VERSION || '01', 'YYYYMMDD')), 'DD'))
                  END
           FROM (SELECT DIVISION_ID
                      , COMPANY_ID
                      , SITE_ID
                      , PLANT_ID
                      , FACTORY_ID
                      , LINE_ID
                      , OPERATION_ID
                      , ELTR_LN_TP_CD
                      , ITEM_ID
                   FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS
                  GROUP BY DIVISION_ID
                         , COMPANY_ID
                         , SITE_ID
                         , PLANT_ID
                         , FACTORY_ID
                         , LINE_ID
                         , OPERATION_ID
                         , ELTR_LN_TP_CD
                         , ITEM_ID) K
              , GT_SCP0106_CHK_FINAL B
              , GT_SCP0106_CHK_SPEED_PLAN S
              , GT_SCP0106_CHK_DAY_CNT DC
          WHERE B.SRC_TP          = 'RT'
            AND B.DIVISION_ID     = K.DIVISION_ID
            AND B.COMPANY_ID      = K.COMPANY_ID
            AND B.SITE_ID         = K.SITE_ID
            AND B.PLANT_ID        = K.PLANT_ID
            AND B.FACTORY_ID      = K.FACTORY_ID
            AND B.LINE_ID         = K.LINE_ID
            AND B.OPERATION_ID    = K.OPERATION_ID
            AND B.ELTR_LN_TP_CD   = K.ELTR_LN_TP_CD
            AND S.DIVISION_ID(+)   = K.DIVISION_ID
            AND S.COMPANY_ID(+)    = K.COMPANY_ID
            AND S.SITE_ID(+)       = K.SITE_ID
            AND S.PLANT_ID(+)      = K.PLANT_ID
            AND S.FACTORY_ID(+)    = K.FACTORY_ID
            AND S.LINE_ID(+)       = K.LINE_ID
            AND S.OPERATION_ID(+)  = K.OPERATION_ID
            AND S.ELTR_LN_TP_CD(+) = K.ELTR_LN_TP_CD
            AND S.NICK_NAME(+)     = K.ITEM_ID
            AND DC.SRC_TP(+)         = 'BSE'
            AND DC.DIVISION_ID(+)    = K.DIVISION_ID
            AND DC.COMPANY_ID(+)     = K.COMPANY_ID
            AND DC.SITE_ID(+)        = K.SITE_ID
            AND DC.PLANT_ID(+)       = K.PLANT_ID
            AND DC.FACTORY_ID(+)     = K.FACTORY_ID
            AND DC.LINE_ID(+)        = K.LINE_ID
            AND DC.OPERATION_ID(+)   = K.OPERATION_ID
            AND DC.ELTR_LN_TP_CD(+)  = K.ELTR_LN_TP_CD;

    /* 운영계획용 — 달마다 일수가 달라 따로 둔다 */
    INSERT INTO GT_SCP0106_CHK_FINAL
                ( SRC_TP
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , MDL_NM
                , YYYYMM
                , BM_RT
                , CM_RT
                , ID_RT
                , MR_RT
                , NM_RT
                , PD_RT
                , PM_RT
                , PP_RT
                , UD_RT
                , OP_RT
                , LD_RT
                , AV_RT
                , PF_RT
                , QL_RT
                , TEEP
                , PROD_OP_RT
                , BASE_AV_RT
                , BASE_PF_RT
                , BASE_TEEP
                , BASE_PROD_OP_RT
                , BASE_PPM
                , PFRSLT_PPM
                , DAY_CNT
                , PFRSLT_THRY_CAPA_D
                , PFRSLT_PROD_CAPA_D
                , PFRSLT_PROD_CAPA_M
                , BASE_THRY_CAPA_D
                , BASE_PROD_CAPA_D
                , BASE_PROD_CAPA_M )
         SELECT 'OP'
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.MDL_NM
              , K.YYYYMM
              , A.BM_RT
              , A.CM_RT
              , A.ID_RT
              , A.MR_RT
              , A.NM_RT
              , A.PD_RT
              , A.PM_RT
              , A.PP_RT
              , A.UD_RT
              , A.OP_RT
              , A.LD_RT
              , A.AV_RT
              , A.PF_RT
              , A.QL_RT
              , A.TEEP
              , A.PROD_OP_RT
              , A.BASE_AV_RT
              , A.BASE_PF_RT
              , A.BASE_TEEP
              , A.BASE_PROD_OP_RT
              , A.BASE_PPM
              , A.PFRSLT_PPM
              , CASE WHEN DC.DAY_CNT IS NOT NULL THEN DC.DAY_CNT
                     ELSE TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(V_VERSION || '01', 'YYYYMMDD')), 'DD'))
                END
              , A.PFRSLT_THRY_CAPA_D
              , A.PFRSLT_PROD_CAPA_D
              , A.PFRSLT_PROD_CAPA_M
              , A.BASE_THRY_CAPA_D
              , A.BASE_PROD_CAPA_D
              , CASE WHEN A.ELTR_LN_TP_CD = 'W' THEN 2.0 ELSE 1.0 END * (A.BASE_PPM * 1440.0)
                * (A.LD_RT * A.OP_RT * 1.0 * A.QL_RT)
                * CASE WHEN LENGTH(RTRIM(K.YYYYMM)) = 4
                       THEN CASE WHEN DY.DAY_CNT IS NOT NULL THEN DY.DAY_CNT
                                 ELSE TO_DATE(SUBSTR(K.YYYYMM, 1, 4) || '1231', 'YYYYMMDD')
                                    - TO_DATE(SUBSTR(K.YYYYMM, 1, 4) || '0101', 'YYYYMMDD') + 1
                            END
                       ELSE CASE WHEN DC.DAY_CNT IS NOT NULL THEN DC.DAY_CNT
                                 ELSE TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(K.YYYYMM || '01', 'YYYYMMDD')), 'DD'))
                            END
                  END
           FROM GT_SCP0106_CHK_FINAL A
              , (SELECT DIVISION_ID
                      , COMPANY_ID
                      , SITE_ID
                      , PLANT_ID
                      , FACTORY_ID
                      , LINE_ID
                      , OPERATION_ID
                      , ELTR_LN_TP_CD
                      , ITEM_ID
                      , YYYYMM
                   FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS
                  GROUP BY DIVISION_ID
                         , COMPANY_ID
                         , SITE_ID
                         , PLANT_ID
                         , FACTORY_ID
                         , LINE_ID
                         , OPERATION_ID
                         , ELTR_LN_TP_CD
                         , ITEM_ID
                         , YYYYMM) K
              , GT_SCP0106_CHK_DAY_CNT DC
              , GT_SCP0106_CHK_DAY_CNT DY
          WHERE A.SRC_TP        = 'MD'
            AND K.DIVISION_ID   = A.DIVISION_ID
            AND K.COMPANY_ID    = A.COMPANY_ID
            AND K.SITE_ID       = A.SITE_ID
            AND K.PLANT_ID      = A.PLANT_ID
            AND K.FACTORY_ID    = A.FACTORY_ID
            AND K.LINE_ID       = A.LINE_ID
            AND K.OPERATION_ID  = A.OPERATION_ID
            AND K.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
            AND K.ITEM_ID       = A.MDL_NM
            AND DC.SRC_TP(+)         = 'OPP'
            AND DC.DIVISION_ID(+)    = A.DIVISION_ID
            AND DC.COMPANY_ID(+)     = A.COMPANY_ID
            AND DC.SITE_ID(+)        = A.SITE_ID
            AND DC.PLANT_ID(+)       = A.PLANT_ID
            AND DC.FACTORY_ID(+)     = A.FACTORY_ID
            AND DC.LINE_ID(+)        = A.LINE_ID
            AND DC.OPERATION_ID(+)   = A.OPERATION_ID
            AND DC.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND DC.YYYYMM(+)         = K.YYYYMM
            AND DY.SRC_TP(+)         = 'OPY'
            AND DY.DIVISION_ID(+)    = A.DIVISION_ID
            AND DY.COMPANY_ID(+)     = A.COMPANY_ID
            AND DY.SITE_ID(+)        = A.SITE_ID
            AND DY.PLANT_ID(+)       = A.PLANT_ID
            AND DY.FACTORY_ID(+)     = A.FACTORY_ID
            AND DY.LINE_ID(+)        = A.LINE_ID
            AND DY.OPERATION_ID(+)   = A.OPERATION_ID
            AND DY.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND DY.YYYYMM(+)         = SUBSTR(K.YYYYMM, 1, 4);

    /* 반영 대상 — 생산능력 항목만 품목 단위, 그 밖은 라인 단위 */
    INSERT INTO GT_SCP0106_CHK_RAW
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , MDL_NM
                , PLANT_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , COMPANY_ID
                , SITE_ID
                , FACTORY_ID
                , MSR_GR_CD
                , MSR_TP_CD
                , YYYYMM
                , PFRSLT_NVL
                , BASE_NVL
                , MSR_NVL
                , MSR_DDN
                , ASSIGN_PRIORITY )
         SELECT V_VERSION
              , V_VERSION_SEQ
              , A.DIVISION_ID
              , CASE WHEN M.MSR_TP_CD NOT IN ('PROD_CAPA_D', 'PROD_CAPA_M', 'THRY_CAPA_D')
                     THEN '-'
                     ELSE A.ITEM_ID
                END
              , A.PLANT_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.COMPANY_ID
              , A.SITE_ID
              , A.FACTORY_ID
              , M.MSR_GR_CD
              , M.MSR_TP_CD
              , A.YYYYMM
              , MAX(CASE WHEN M.MSR_TP_CD = 'BM_RT'       THEN R.BM_RT
                         WHEN M.MSR_TP_CD = 'CM_RT'       THEN R.CM_RT
                         WHEN M.MSR_TP_CD = 'ID_RT'       THEN R.ID_RT
                         WHEN M.MSR_TP_CD = 'MR_RT'       THEN R.MR_RT
                         WHEN M.MSR_TP_CD = 'NM_RT'       THEN R.NM_RT
                         WHEN M.MSR_TP_CD = 'PD_RT'       THEN R.PD_RT
                         WHEN M.MSR_TP_CD = 'PM_RT'       THEN R.PM_RT
                         WHEN M.MSR_TP_CD = 'PP_RT'       THEN R.PP_RT
                         WHEN M.MSR_TP_CD = 'UD_RT'       THEN R.UD_RT
                         WHEN M.MSR_TP_CD = 'OP_RT'       THEN R.OP_RT
                         WHEN M.MSR_TP_CD = 'LD_RT'       THEN R.LD_RT
                         WHEN M.MSR_TP_CD = 'AV_RT'       THEN R.AV_RT
                         WHEN M.MSR_TP_CD = 'PF_RT'       THEN R.PF_RT
                         WHEN M.MSR_TP_CD = 'QL_RT'       THEN R.QL_RT
                         WHEN M.MSR_TP_CD = 'TEEP'        THEN R.TEEP
                         WHEN M.MSR_TP_CD = 'PROD_OP_RT'  THEN R.PROD_OP_RT
                         WHEN M.MSR_TP_CD = 'THRY_CAPA_D' THEN R.PFRSLT_THRY_CAPA_D
                         WHEN M.MSR_TP_CD = 'PROD_CAPA_D' THEN R.PFRSLT_PROD_CAPA_D
                         WHEN M.MSR_TP_CD = 'PROD_CAPA_M' THEN R.PFRSLT_PROD_CAPA_M
                    END)
              , MAX(CASE WHEN E.BASE_NVL IS NOT NULL THEN E.BASE_NVL
                         WHEN M.MSR_TP_CD = 'BM_RT'       THEN R.BM_RT
                         WHEN M.MSR_TP_CD = 'CM_RT'       THEN R.CM_RT
                         WHEN M.MSR_TP_CD = 'ID_RT'       THEN R.ID_RT
                         WHEN M.MSR_TP_CD = 'MR_RT'       THEN R.MR_RT
                         WHEN M.MSR_TP_CD = 'NM_RT'       THEN R.NM_RT
                         WHEN M.MSR_TP_CD = 'PD_RT'       THEN R.PD_RT
                         WHEN M.MSR_TP_CD = 'PM_RT'       THEN R.PM_RT
                         WHEN M.MSR_TP_CD = 'PP_RT'       THEN R.PP_RT
                         WHEN M.MSR_TP_CD = 'UD_RT'       THEN R.UD_RT
                         WHEN M.MSR_TP_CD = 'OP_RT'       THEN R.OP_RT
                         WHEN M.MSR_TP_CD = 'LD_RT'       THEN R.LD_RT
                         WHEN M.MSR_TP_CD = 'AV_RT'       THEN R.BASE_AV_RT
                         WHEN M.MSR_TP_CD = 'PF_RT'       THEN R.BASE_PF_RT
                         WHEN M.MSR_TP_CD = 'QL_RT'       THEN R.QL_RT
                         WHEN M.MSR_TP_CD = 'TEEP'        THEN R.BASE_TEEP
                         WHEN M.MSR_TP_CD = 'PROD_OP_RT'  THEN R.BASE_PROD_OP_RT
                         WHEN M.MSR_TP_CD = 'THRY_CAPA_D' THEN R.BASE_THRY_CAPA_D
                         WHEN M.MSR_TP_CD = 'PROD_CAPA_D' THEN R.BASE_PROD_CAPA_D
                         WHEN M.MSR_TP_CD = 'PROD_CAPA_M' THEN R.BASE_PROD_CAPA_M
                    END)
              , MAX(CASE WHEN M.MSR_TP_CD = 'BM_RT'       THEN O.BM_RT
                         WHEN M.MSR_TP_CD = 'CM_RT'       THEN O.CM_RT
                         WHEN M.MSR_TP_CD = 'ID_RT'       THEN O.ID_RT
                         WHEN M.MSR_TP_CD = 'MR_RT'       THEN O.MR_RT
                         WHEN M.MSR_TP_CD = 'NM_RT'       THEN O.NM_RT
                         WHEN M.MSR_TP_CD = 'PD_RT'       THEN O.PD_RT
                         WHEN M.MSR_TP_CD = 'PM_RT'       THEN O.PM_RT
                         WHEN M.MSR_TP_CD = 'PP_RT'       THEN O.PP_RT
                         WHEN M.MSR_TP_CD = 'UD_RT'       THEN O.UD_RT
                         WHEN M.MSR_TP_CD = 'OP_RT'       THEN O.OP_RT
                         WHEN M.MSR_TP_CD = 'LD_RT'       THEN O.LD_RT
                         WHEN M.MSR_TP_CD = 'AV_RT'       THEN O.AV_RT
                         WHEN M.MSR_TP_CD = 'PF_RT'       THEN O.PF_RT
                         WHEN M.MSR_TP_CD = 'QL_RT'       THEN O.QL_RT
                         WHEN M.MSR_TP_CD = 'TEEP'        THEN O.TEEP
                         WHEN M.MSR_TP_CD = 'PROD_OP_RT'  THEN O.PROD_OP_RT
                         WHEN M.MSR_TP_CD = 'THRY_CAPA_D' THEN O.BASE_THRY_CAPA_D
                         WHEN M.MSR_TP_CD = 'PROD_CAPA_D' THEN O.BASE_PROD_CAPA_D
                         WHEN M.MSR_TP_CD = 'PROD_CAPA_M' THEN O.BASE_PROD_CAPA_M
                    END)
              , MAX(O.DAY_CNT)
              , MAX(A.ASSIGN_PRIORITY)
           FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS A
              , GT_SCP0106_CHK_MEASURE M
              , GT_SCP0106_CHK_FINAL R
              , GT_SCP0106_CHK_FINAL O
              , GT_SCP0106_CHK_EXISTS_BASE E
          WHERE R.SRC_TP(+)         = 'MD'
            AND R.DIVISION_ID(+)    = A.DIVISION_ID
            AND R.COMPANY_ID(+)     = A.COMPANY_ID
            AND R.SITE_ID(+)        = A.SITE_ID
            AND R.PLANT_ID(+)       = A.PLANT_ID
            AND R.FACTORY_ID(+)     = A.FACTORY_ID
            AND R.LINE_ID(+)        = A.LINE_ID
            AND R.OPERATION_ID(+)   = A.OPERATION_ID
            AND R.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND R.MDL_NM(+)         = A.ITEM_ID
            AND O.SRC_TP(+)         = 'OP'
            AND O.DIVISION_ID(+)    = A.DIVISION_ID
            AND O.COMPANY_ID(+)     = A.COMPANY_ID
            AND O.SITE_ID(+)        = A.SITE_ID
            AND O.PLANT_ID(+)       = A.PLANT_ID
            AND O.FACTORY_ID(+)     = A.FACTORY_ID
            AND O.LINE_ID(+)        = A.LINE_ID
            AND O.OPERATION_ID(+)   = A.OPERATION_ID
            AND O.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND O.MDL_NM(+)         = A.ITEM_ID
            AND O.YYYYMM(+)         = A.YYYYMM
            AND E.DIVISION_ID(+)    = A.DIVISION_ID
            AND E.COMPANY_ID(+)     = A.COMPANY_ID
            AND E.SITE_ID(+)        = A.SITE_ID
            AND E.PLANT_ID(+)       = A.PLANT_ID
            AND E.FACTORY_ID(+)     = A.FACTORY_ID
            AND E.LINE_ID(+)        = A.LINE_ID
            AND E.OPERATION_ID(+)   = A.OPERATION_ID
            AND E.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
            AND E.MDL_NM(+)         = A.ITEM_ID
            AND E.MSR_TP_CD(+)      = M.MSR_TP_CD
            AND E.MSR_GR_CD(+)      = M.MSR_GR_CD
          GROUP BY A.DIVISION_ID
                 , CASE WHEN M.MSR_TP_CD NOT IN ('PROD_CAPA_D', 'PROD_CAPA_M', 'THRY_CAPA_D')
                        THEN '-'
                        ELSE A.ITEM_ID
                   END
                 , A.PLANT_ID
                 , A.LINE_ID
                 , A.OPERATION_ID
                 , A.ELTR_LN_TP_CD
                 , A.COMPANY_ID
                 , A.SITE_ID
                 , A.FACTORY_ID
                 , M.MSR_GR_CD
                 , M.MSR_TP_CD
                 , A.YYYYMM;

    /* 모델별 Assign Priority 값이 없으면 기존 Loss Plan 값 삭제
       Assign Priority 가 Model 별 존재하므로 Line 별(품목 '-')은 기존값을 둔다 */
    UPDATE GT_SCP0106_CHK_RAW
       SET MSR_NVL = NULL
     WHERE MDL_NM <> '-'
       AND NVL(ASSIGN_PRIORITY, 0) = 0;

    /* INSERT - SCP_MST_CAPA_ELTR_LOSS_PLAN - BEGIN
       ★MERGE 열쇠에 전극 구분이 없다(원문 그대로) */
    FOR R IN (SELECT DIVISION_ID
                   , MDL_NM
                   , PLANT_ID
                   , LINE_ID
                   , OPERATION_ID
                   , ELTR_LN_TP_CD
                   , COMPANY_ID
                   , SITE_ID
                   , FACTORY_ID
                   , MSR_GR_CD
                   , MSR_TP_CD
                   , YYYYMM
                   , PFRSLT_NVL
                   , BASE_NVL
                   , MSR_NVL
                   , MSR_DDN
                   , ASSIGN_PRIORITY
                FROM GT_SCP0106_CHK_RAW
               WHERE DIVISION_ID   IS NOT NULL
                 AND MDL_NM        IS NOT NULL
                 AND PLANT_ID      IS NOT NULL
                 AND LINE_ID       IS NOT NULL
                 AND OPERATION_ID  IS NOT NULL
                 AND COMPANY_ID    IS NOT NULL
                 AND SITE_ID       IS NOT NULL
                 AND FACTORY_ID    IS NOT NULL
                 AND MSR_TP_CD     IS NOT NULL
                 AND YYYYMM        IS NOT NULL
                 AND MSR_GR_CD     IS NOT NULL)
    LOOP

        UPDATE SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL
           SET MSR_NVL          = CASE WHEN NVL(R.ASSIGN_PRIORITY, 0) = 0
                                        AND R.MSR_TP_CD IN ('THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M')
                                       THEN R.MSR_NVL
                                       ELSE MSR_NVL
                                  END
             , LAST_UPDATED_BY  = V_STAMP
             , LAST_UPDATE_DATE = SYSDATE
         WHERE DIVISION_ID  = R.DIVISION_ID
           AND MDL_NM       = R.MDL_NM
           AND PLANT_ID     = R.PLANT_ID
           AND LINE_ID      = R.LINE_ID
           AND OPERATION_ID = R.OPERATION_ID
           AND COMPANY_ID   = R.COMPANY_ID
           AND SITE_ID      = R.SITE_ID
           AND FACTORY_ID   = R.FACTORY_ID
           AND MSR_TP_CD    = R.MSR_TP_CD
           AND YYYYMM       = R.YYYYMM
           AND MSR_GR_CD    = R.MSR_GR_CD;

        IF SQL%ROWCOUNT = 0 THEN

            INSERT INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL
                        ( DIVISION_ID
                        , MDL_NM
                        , PLANT_ID
                        , LINE_ID
                        , OPERATION_ID
                        , ELTR_LN_TP_CD
                        , COMPANY_ID
                        , SITE_ID
                        , FACTORY_ID
                        , MSR_TP_CD
                        , YYYYMM
                        , PFRSLT_NVL
                        , BASE_NVL
                        , MSR_GR_CD
                        , MSR_NVL
                        , CREATED_BY
                        , CREATION_DATE
                        , LAST_UPDATED_BY
                        , LAST_UPDATE_DATE )
                 VALUES ( R.DIVISION_ID
                        , R.MDL_NM
                        , R.PLANT_ID
                        , R.LINE_ID
                        , R.OPERATION_ID
                        , R.ELTR_LN_TP_CD
                        , R.COMPANY_ID
                        , R.SITE_ID
                        , R.FACTORY_ID
                        , R.MSR_TP_CD
                        , R.YYYYMM
                        , R.PFRSLT_NVL
                        , R.BASE_NVL
                        , R.MSR_GR_CD
                        , R.MSR_NVL
                        , V_STAMP
                        , SYSDATE
                        , V_STAMP
                        , SYSDATE );

        END IF;

    END LOOP;

    /* 우선순위가 없으면 사용자가 입력한 월별 데이터도 클리어 */
    UPDATE SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
       SET A.MSR_NVL = NULL
     WHERE EXISTS (SELECT 1
                     FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS XA
                    WHERE XA.DIVISION_ID  = A.DIVISION_ID
                      AND XA.COMPANY_ID   = A.COMPANY_ID
                      AND XA.SITE_ID      = A.SITE_ID
                      AND XA.PLANT_ID     = A.PLANT_ID
                      AND XA.FACTORY_ID   = A.FACTORY_ID
                      AND XA.LINE_ID      = A.LINE_ID
                      AND XA.OPERATION_ID = A.OPERATION_ID
                      AND XA.ITEM_ID      = A.MDL_NM
                      AND XA.YYYYMM       = A.YYYYMM
                      AND NVL(XA.ASSIGN_PRIORITY, 0) = 0);

    /* 아예 삭제함 */
    DELETE SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
     WHERE EXISTS (SELECT 1
                     FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN XA
                    WHERE XA.DIVISION_ID  = A.DIVISION_ID
                      AND XA.COMPANY_ID   = A.COMPANY_ID
                      AND XA.SITE_ID      = A.SITE_ID
                      AND XA.PLANT_ID     = A.PLANT_ID
                      AND XA.FACTORY_ID   = A.FACTORY_ID
                      AND XA.LINE_ID      = A.LINE_ID
                      AND XA.OPERATION_ID = A.OPERATION_ID
                      AND XA.ITEM_ID      = A.MDL_NM
                      AND XA.YYYYMM       = A.YYYYMM
                      AND (NVL(XA.ASSIGN_PRIORITY, 0) = 0 OR NVL(XA.VALID_YN, 'N') <> 'Y'));
    /* INSERT - SCP_MST_CAPA_ELTR_LOSS_PLAN - END */

END P_SCP0106_CHK_LOSS_ASGN_ELTR;




    /*
     * Program ID   : PKG_SCP0104
     * Description  : SCP0104 CAPA Line Assign 화면 — 계층 조회 · 배정 · 양산시점 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.27   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     */

/****************************************************************************************************/
/* Program ID  : P_SCP0104_GET_SPREAD_TITLE                                                         */
/* Description : CAPA NEW 날짜 타이틀 리턴 (SCP0104, SCP0105, SCP0106, SCP0107, SCP0108 공통)       */
/****************************************************************************************************/
PROCEDURE P_SCP0104_GET_SPREAD_TITLE
(
    P_FROM_YYYYMM       IN  CLOB
  , P_PROGRAM_ID        IN  CLOB
  , P_SHEET_NAME        IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    V_FROM_YYYYMM       VARCHAR2(6 CHAR)    := TO_CHAR(SUBSTR(P_FROM_YYYYMM, 1, 6));
    V_PROGRAM_ID        VARCHAR2(100 CHAR)  := TO_CHAR(SUBSTR(P_PROGRAM_ID,  1, 100));
    V_SHEET_NAME        VARCHAR2(100 CHAR)  := TO_CHAR(SUBSTR(P_SHEET_NAME,  1, 100));

BEGIN

    OPEN O_RC1 FOR
        SELECT COLUMN_NAME
             , COLUMN_LABEL_NAME
             , SMALL_CLASS_LABEL_NAME
             , LARGE_CLASS_LABEL_NAME
             , DAY_CODE
             , SORT_ORDER_NO
          FROM TABLE(FN_SCP0104_GET_SPREAD_TITLE(V_FROM_YYYYMM, V_PROGRAM_ID, V_SHEET_NAME))
         ORDER BY SORT_ORDER_NO;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0104_GET_SPREAD_TITLE;

/****************************************************************************************************/
/* Program ID  : P_SCP0104_GET_CAPA_LINE_ASSEMBLY                                                   */
/* Description : CAPA LINE ASSING                                                                   */
/****************************************************************************************************/
PROCEDURE P_SCP0104_GET_CAPA_LINE_ASSEMBLY
(
    P_DIVISION_ID       IN  CLOB
  , P_SITE_ID           IN  CLOB
  , P_PLANT_ID          IN  CLOB
  , P_FACTORY_ID        IN  CLOB
  , P_LINE_ID           IN  CLOB
  , P_PROGRAM_ID        IN  CLOB
  , P_SHEET_NAME        IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_DEBUG_MODE        IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    V_DIVISION_ID       VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID, 1, 4000));
    V_SITE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_SITE_ID,     1, 4000));
    V_PLANT_ID          VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_PLANT_ID,    1, 4000));
    V_FACTORY_ID        VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_FACTORY_ID,  1, 4000));
    V_LINE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_LINE_ID,     1, 4000));

BEGIN

    OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , MAX(A.LAST_UPDATED_BY)                   AS LAST_UPDATED_BY
             , MAX(A.LAST_UPDATE_DATE)                  AS LAST_UPDATE_DATE
             , FN_GET_DIVISION_NAME(A.DIVISION_ID)      AS DIVISION_NAME
             , MAX(A.SITE_NAME)                         AS SITE_NAME
             , MAX(A.COMPANY_NAME)                      AS COMPANY_NAME
             , MAX(A.PLANT_NAME)                        AS PLANT_NAME
             , MAX(A.FACTORY_NAME)                      AS FACTORY_NAME
             , MAX(A.LINE_NAME)                         AS LINE_NAME
          FROM SCP_MST_CAPA_LINE A
         WHERE (TRIM(V_DIVISION_ID) IS NULL
            OR  UPPER(V_DIVISION_ID) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
            OR  A.DIVISION_ID IN (SELECT COLUMN_VALUE
                                    FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
           AND (TRIM(V_SITE_ID) IS NULL
            OR  UPPER(V_SITE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
            OR  A.SITE_ID IN (SELECT COLUMN_VALUE
                                FROM TABLE(STRING_SPLIT(V_SITE_ID, ','))))
           AND (TRIM(V_PLANT_ID) IS NULL
            OR  UPPER(V_PLANT_ID) = 'ALL'                       /* 조회조건 ALL 은 조건 없음 */
            OR  A.PLANT_ID IN (SELECT COLUMN_VALUE
                                 FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
           AND (TRIM(V_FACTORY_ID) IS NULL
            OR  UPPER(V_FACTORY_ID) = 'ALL'                     /* 조회조건 ALL 은 조건 없음 */
            OR  A.FACTORY_ID IN (SELECT COLUMN_VALUE
                                   FROM TABLE(STRING_SPLIT(V_FACTORY_ID, ','))))
           AND (TRIM(V_LINE_ID) IS NULL
            OR  UPPER(V_LINE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
            OR  A.LINE_ID IN (SELECT COLUMN_VALUE
                                FROM TABLE(STRING_SPLIT(V_LINE_ID, ','))))
           AND A.VALID_YN    = 'Y'
           AND A.COMPANY_ID <> '-'
           AND A.DIVISION_ID <> '-'
           AND A.SITE_ID    <> '-'
           AND A.PLANT_ID   <> '-'
           AND A.FACTORY_ID <> '-'
           AND A.LINE_ID    <> '-'
         GROUP BY A.DIVISION_ID
                , A.COMPANY_ID
                , A.SITE_ID
                , A.PLANT_ID
                , A.FACTORY_ID
                , A.LINE_ID
         ORDER BY A.DIVISION_ID
                , A.COMPANY_ID
                , A.SITE_ID
                , A.PLANT_ID
                , A.FACTORY_ID
                , A.LINE_ID;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0104_GET_CAPA_LINE_ASSEMBLY;

/****************************************************************************************************/
/* Program ID  : P_SCP0104_GET_CAPA_LINE_ELTR                                                       */
/* Description : CAPA LINE ASSING                                                                   */
/****************************************************************************************************/
PROCEDURE P_SCP0104_GET_CAPA_LINE_ELTR
(
    P_DIVISION_ID       IN  CLOB
  , P_SITE_ID           IN  CLOB
  , P_PLANT_ID          IN  CLOB
  , P_FACTORY_ID        IN  CLOB
  , P_LINE_ID           IN  CLOB
  , P_PROGRAM_ID        IN  CLOB
  , P_SHEET_NAME        IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_DEBUG_MODE        IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    V_DIVISION_ID       VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID, 1, 4000));
    V_SITE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_SITE_ID,     1, 4000));
    V_PLANT_ID          VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_PLANT_ID,    1, 4000));
    V_FACTORY_ID        VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_FACTORY_ID,  1, 4000));
    V_LINE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_LINE_ID,     1, 4000));

BEGIN

    /* 원문은 공정 이름 임시 자료(#tblSCP0104_OPERATION)를 만들지만 아래 조회에서 쓰지 않아 옮기지 않는다 */

    OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , MAX(A.LAST_UPDATED_BY)                   AS LAST_UPDATED_BY
             , MAX(A.LAST_UPDATE_DATE)                  AS LAST_UPDATE_DATE
             , FN_GET_DIVISION_NAME(A.DIVISION_ID)      AS DIVISION_NAME
             , MAX(A.SITE_NAME)                         AS SITE_NAME
             , MAX(A.COMPANY_NAME)                      AS COMPANY_NAME
             , MAX(A.PLANT_NAME)                        AS PLANT_NAME
             , MAX(A.FACTORY_NAME)                      AS FACTORY_NAME
             , MAX(A.LINE_NAME)                         AS LINE_NAME
          FROM SCP_MST_CAPA_ELTR_LINE A
         WHERE (TRIM(V_DIVISION_ID) IS NULL
            OR  UPPER(V_DIVISION_ID) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
            OR  A.DIVISION_ID IN (SELECT COLUMN_VALUE
                                    FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
           AND (TRIM(V_SITE_ID) IS NULL
            OR  UPPER(V_SITE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
            OR  A.SITE_ID IN (SELECT COLUMN_VALUE
                                FROM TABLE(STRING_SPLIT(V_SITE_ID, ','))))
           AND (TRIM(V_PLANT_ID) IS NULL
            OR  UPPER(V_PLANT_ID) = 'ALL'                       /* 조회조건 ALL 은 조건 없음 */
            OR  A.PLANT_ID IN (SELECT COLUMN_VALUE
                                 FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
           AND (TRIM(V_FACTORY_ID) IS NULL
            OR  UPPER(V_FACTORY_ID) = 'ALL'                     /* 조회조건 ALL 은 조건 없음 */
            OR  A.FACTORY_ID IN (SELECT COLUMN_VALUE
                                   FROM TABLE(STRING_SPLIT(V_FACTORY_ID, ','))))
           AND (TRIM(V_LINE_ID) IS NULL
            OR  UPPER(V_LINE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
            OR  A.LINE_ID IN (SELECT COLUMN_VALUE
                                FROM TABLE(STRING_SPLIT(V_LINE_ID, ','))))
           AND A.VALID_YN    = 'Y'
           AND A.DIVISION_ID <> '-'
           AND A.SITE_ID    <> '-'
           AND A.PLANT_ID   <> '-'
           AND A.FACTORY_ID <> '-'
           AND A.LINE_ID    <> '-'
         GROUP BY A.DIVISION_ID
                , A.COMPANY_ID
                , A.SITE_ID
                , A.PLANT_ID
                , A.FACTORY_ID
                , A.LINE_ID
         ORDER BY A.DIVISION_ID
                , A.COMPANY_ID
                , A.SITE_ID
                , A.PLANT_ID
                , A.FACTORY_ID
                , A.LINE_ID;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0104_GET_CAPA_LINE_ELTR;


/****************************************************************************************************/
/* Program ID  : P_SCP0104_GET_CAPA_LINE_SOP_ASSEMBLY                                               */
/* Description : CAPA LINE SOP — 조립                                                               */
/****************************************************************************************************/
PROCEDURE P_SCP0104_GET_CAPA_LINE_SOP_ASSEMBLY
(
    P_VERSION           IN  CLOB
  , P_VERSION_SEQ       IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_SITE_ID           IN  CLOB
  , P_PLANT_ID          IN  CLOB
  , P_FACTORY_ID        IN  CLOB
  , P_LINE_ID           IN  CLOB
  , P_OPERATION_ID      IN  CLOB
  , P_ELECTRODE_TYPE    IN  CLOB
  , P_VALID_FLAG        IN  CLOB
  , P_PROGRAM_ID        IN  CLOB
  , P_SHEET_NAME        IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_DEBUG_MODE        IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    V_DIVISION_ID       VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID,    1, 4000));
    V_SITE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_SITE_ID,        1, 4000));
    V_PLANT_ID          VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_PLANT_ID,       1, 4000));
    V_FACTORY_ID        VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_FACTORY_ID,     1, 4000));
    V_LINE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_LINE_ID,        1, 4000));
    V_OPERATION_ID      VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_OPERATION_ID,   1, 4000));
    V_ELECTRODE_TYPE    VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_ELECTRODE_TYPE, 1, 4000));
    /* AS-IS 사용여부 인자는 한 글자라 'ALL' 이 'A' 로 잘린다 — 값 비교는 한 글자, 조회조건 ALL 판정만 자르지 않은 값으로 */
    V_VALID_FLAG        VARCHAR2(1 CHAR)    := TO_CHAR(SUBSTR(P_VALID_FLAG,     1, 1));
    V_VALID_FLAG_ALL    VARCHAR2(10 CHAR)   := TO_CHAR(SUBSTR(P_VALID_FLAG,     1, 10));

BEGIN

    /* 원문은 WITH 절로 계층 이름을 묶으나 온라인 SQL 에서 쓰지 않는 규칙이라 인라인 뷰로 옮긴다 */
    OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.VALID_YN
             /* 스프레드 셀타입을 DateText 로 설정하므로 변환필요!!!                , A.SOP_DT */
             , TO_CHAR(FN_CHAR_TO_DATE(A.SOP_DT), 'YYYY-MM-DD')     AS SOP_DT   /* 스프레드 셀타입을 DateText 로 설정하므로 변환필요!!! */
             , A.SOP_YM
             , A.SOP_DDN
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , FN_GET_DIVISION_NAME(A.DIVISION_ID)                  AS DIVISION_NAME
             , IA.SITE_NAME                                         AS SITE_NAME
             , IB.COMPANY_NAME                                      AS COMPANY_NAME
             , IC.PLANT_NAME                                        AS PLANT_NAME
             , ID.FACTORY_NAME                                      AS FACTORY_NAME
             , IE.LINE_NAME                                         AS LINE_NAME
             , IG.NAME                                              AS OPERATION_NAME
          FROM SCP_MST_CAPA_LINE_SOP A
             , (SELECT SITE_ID
                     , SITE_NAME
                  FROM SCP_MST_CAPA_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY SITE_ID
                        , SITE_NAME) IA
             , (SELECT COMPANY_ID
                     , COMPANY_NAME
                  FROM SCP_MST_CAPA_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY COMPANY_ID
                        , COMPANY_NAME) IB
             , (SELECT PLANT_ID
                     , PLANT_NAME
                  FROM SCP_MST_CAPA_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY PLANT_ID
                        , PLANT_NAME) IC
             , (SELECT FACTORY_ID
                     , FACTORY_NAME
                  FROM SCP_MST_CAPA_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY FACTORY_ID
                        , FACTORY_NAME) ID
             , (SELECT LINE_ID
                     , LINE_NAME
                  FROM SCP_MST_CAPA_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY LINE_ID
                        , LINE_NAME) IE
             , (SELECT XA.CODE
                     , XA.NAME
                  FROM (SELECT XB.OPERATION_ID          AS CODE
                             , MAX(XB.OPERATION_NAME)   AS NAME
                          FROM SCM_MST_OPERATION_SN XB
                         GROUP BY XB.OPERATION_ID
                        UNION ALL
                        SELECT XD.SEGMENT1              AS CODE
                             , XD.ATTRIBUTE1            AS NAME
                          FROM SCM_ADM_LOOKUP_MASTER XC
                             , SCM_ADM_LOOKUP_MASTER_DETAIL XD
                         WHERE XD.LOOKUP_TYPE  = XC.LOOKUP_TYPE
                           AND XC.LOOKUP_GROUP = 'SCP'
                           AND XC.LOOKUP_TYPE  = 'CPS_FORMATION_OPERATION'
                           AND XD.VALID_YN     = 'Y'
                         GROUP BY XD.SEGMENT1
                                , XD.ATTRIBUTE1) XA) IG
         WHERE IA.SITE_ID(+)      = A.SITE_ID
           AND IB.COMPANY_ID(+)   = A.COMPANY_ID
           AND IC.PLANT_ID(+)     = A.PLANT_ID
           AND ID.FACTORY_ID(+)   = A.FACTORY_ID
           AND IE.LINE_ID(+)      = A.LINE_ID
           AND IG.CODE(+)         = A.OPERATION_ID
           AND (TRIM(V_DIVISION_ID) IS NULL
            OR  UPPER(V_DIVISION_ID) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
            OR  A.DIVISION_ID IN (SELECT COLUMN_VALUE
                                    FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
           AND (TRIM(V_SITE_ID) IS NULL
            OR  UPPER(V_SITE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
            OR  A.SITE_ID IN (SELECT COLUMN_VALUE
                                FROM TABLE(STRING_SPLIT(V_SITE_ID, ','))))
           AND (TRIM(V_PLANT_ID) IS NULL
            OR  UPPER(V_PLANT_ID) = 'ALL'                       /* 조회조건 ALL 은 조건 없음 */
            OR  A.PLANT_ID IN (SELECT COLUMN_VALUE
                                 FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
           AND (TRIM(V_FACTORY_ID) IS NULL
            OR  UPPER(V_FACTORY_ID) = 'ALL'                     /* 조회조건 ALL 은 조건 없음 */
            OR  A.FACTORY_ID IN (SELECT COLUMN_VALUE
                                   FROM TABLE(STRING_SPLIT(V_FACTORY_ID, ','))))
           AND (TRIM(V_LINE_ID) IS NULL
            OR  UPPER(V_LINE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
            OR  A.LINE_ID IN (SELECT COLUMN_VALUE
                                FROM TABLE(STRING_SPLIT(V_LINE_ID, ','))))
           AND (TRIM(V_OPERATION_ID) IS NULL
            OR  UPPER(V_OPERATION_ID) = 'ALL'                   /* 조회조건 ALL 은 조건 없음 */
            OR  A.OPERATION_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_OPERATION_ID, ','))))
           AND (TRIM(V_ELECTRODE_TYPE) IS NULL
            OR  UPPER(V_ELECTRODE_TYPE) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
            OR  A.ELTR_LN_TP_CD IN (SELECT COLUMN_VALUE
                                      FROM TABLE(STRING_SPLIT(V_ELECTRODE_TYPE, ','))))
           AND (TRIM(V_VALID_FLAG) IS NULL
            OR  UPPER(V_VALID_FLAG_ALL) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
            OR  A.VALID_YN = V_VALID_FLAG)
         ORDER BY A.DIVISION_ID
                , IA.SITE_ID
                , IB.COMPANY_ID
                , IC.PLANT_ID
                , ID.FACTORY_ID
                , IE.LINE_ID;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0104_GET_CAPA_LINE_SOP_ASSEMBLY;

/****************************************************************************************************/
/* Program ID  : P_SCP0104_GET_CAPA_LINE_SOP_ELTR                                                   */
/* Description : CAPA LINE SOP — 전극                                                               */
/****************************************************************************************************/
PROCEDURE P_SCP0104_GET_CAPA_LINE_SOP_ELTR
(
    P_VERSION           IN  CLOB
  , P_VERSION_SEQ       IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_SITE_ID           IN  CLOB
  , P_PLANT_ID          IN  CLOB
  , P_FACTORY_ID        IN  CLOB
  , P_LINE_ID           IN  CLOB
  , P_OPERATION_ID      IN  CLOB
  , P_ELECTRODE_TYPE    IN  CLOB
  , P_VALID_FLAG        IN  CLOB
  , P_PROGRAM_ID        IN  CLOB
  , P_SHEET_NAME        IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_DEBUG_MODE        IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    V_DIVISION_ID       VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID,    1, 4000));
    V_SITE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_SITE_ID,        1, 4000));
    V_PLANT_ID          VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_PLANT_ID,       1, 4000));
    V_FACTORY_ID        VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_FACTORY_ID,     1, 4000));
    V_LINE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_LINE_ID,        1, 4000));
    V_OPERATION_ID      VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_OPERATION_ID,   1, 4000));
    V_ELECTRODE_TYPE    VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_ELECTRODE_TYPE, 1, 4000));
    /* AS-IS 사용여부 인자는 한 글자라 'ALL' 이 'A' 로 잘린다 — 값 비교는 한 글자, 조회조건 ALL 판정만 자르지 않은 값으로 */
    V_VALID_FLAG        VARCHAR2(1 CHAR)    := TO_CHAR(SUBSTR(P_VALID_FLAG,     1, 1));
    V_VALID_FLAG_ALL    VARCHAR2(10 CHAR)   := TO_CHAR(SUBSTR(P_VALID_FLAG,     1, 10));

BEGIN

    /* 원문은 WITH 절로 계층 이름을 묶으나 온라인 SQL 에서 쓰지 않는 규칙이라 인라인 뷰로 옮긴다 */
    OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.VALID_YN
             /* 스프레드 셀타입을 DateText 로 설정하므로 변환필요!!!                , A.SOP_DT */
             , TO_CHAR(FN_CHAR_TO_DATE(A.SOP_DT), 'YYYY-MM-DD')     AS SOP_DT   /* 스프레드 셀타입을 DateText 로 설정하므로 변환필요!!! */
             , A.SOP_YM
             , A.SOP_DDN
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , FN_GET_DIVISION_NAME(A.DIVISION_ID)                  AS DIVISION_NAME
             , IA.SITE_NAME                                         AS SITE_NAME
             , IB.COMPANY_NAME                                      AS COMPANY_NAME
             , IC.PLANT_NAME                                        AS PLANT_NAME
             , ID.FACTORY_NAME                                      AS FACTORY_NAME
             , IE.LINE_NAME                                         AS LINE_NAME
             , IG.NAME                                              AS OPERATION_NAME
          FROM SCP_MST_CAPA_ELTR_LINE_SOP A
             , (SELECT SITE_ID
                     , SITE_NAME
                  FROM SCP_MST_CAPA_ELTR_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY SITE_ID
                        , SITE_NAME) IA
             , (SELECT COMPANY_ID
                     , COMPANY_NAME
                  FROM SCP_MST_CAPA_ELTR_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY COMPANY_ID
                        , COMPANY_NAME) IB
             , (SELECT PLANT_ID
                     , PLANT_NAME
                  FROM SCP_MST_CAPA_ELTR_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY PLANT_ID
                        , PLANT_NAME) IC
             , (SELECT FACTORY_ID
                     , FACTORY_NAME
                  FROM SCP_MST_CAPA_ELTR_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY FACTORY_ID
                        , FACTORY_NAME) ID
             , (SELECT LINE_ID
                     , LINE_NAME
                  FROM SCP_MST_CAPA_ELTR_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY LINE_ID
                        , LINE_NAME) IE
             , (SELECT OPERATION_ID       AS CODE
                     , OPERATION_NAME     AS NAME
                  FROM SCM_MST_OPERATION_SN
                 GROUP BY OPERATION_ID
                        , OPERATION_NAME) IG
         WHERE IA.SITE_ID(+)      = A.SITE_ID
           AND IB.COMPANY_ID(+)   = A.COMPANY_ID
           AND IC.PLANT_ID(+)     = A.PLANT_ID
           AND ID.FACTORY_ID(+)   = A.FACTORY_ID
           AND IE.LINE_ID(+)      = A.LINE_ID
           AND IG.CODE(+)         = A.OPERATION_ID
           AND (TRIM(V_DIVISION_ID) IS NULL
            OR  UPPER(V_DIVISION_ID) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
            OR  A.DIVISION_ID IN (SELECT COLUMN_VALUE
                                    FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
           AND (TRIM(V_SITE_ID) IS NULL
            OR  UPPER(V_SITE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
            OR  A.SITE_ID IN (SELECT COLUMN_VALUE
                                FROM TABLE(STRING_SPLIT(V_SITE_ID, ','))))
           AND (TRIM(V_PLANT_ID) IS NULL
            OR  UPPER(V_PLANT_ID) = 'ALL'                       /* 조회조건 ALL 은 조건 없음 */
            OR  A.PLANT_ID IN (SELECT COLUMN_VALUE
                                 FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
           AND (TRIM(V_FACTORY_ID) IS NULL
            OR  UPPER(V_FACTORY_ID) = 'ALL'                     /* 조회조건 ALL 은 조건 없음 */
            OR  A.FACTORY_ID IN (SELECT COLUMN_VALUE
                                   FROM TABLE(STRING_SPLIT(V_FACTORY_ID, ','))))
           AND (TRIM(V_LINE_ID) IS NULL
            OR  UPPER(V_LINE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
            OR  A.LINE_ID IN (SELECT COLUMN_VALUE
                                FROM TABLE(STRING_SPLIT(V_LINE_ID, ','))))
           AND (TRIM(V_OPERATION_ID) IS NULL
            OR  UPPER(V_OPERATION_ID) = 'ALL'                   /* 조회조건 ALL 은 조건 없음 */
            OR  A.OPERATION_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_OPERATION_ID, ','))))
           AND (TRIM(V_ELECTRODE_TYPE) IS NULL
            OR  UPPER(V_ELECTRODE_TYPE) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
            OR  A.ELTR_LN_TP_CD IN (SELECT COLUMN_VALUE
                                      FROM TABLE(STRING_SPLIT(V_ELECTRODE_TYPE, ','))))
           AND (TRIM(V_VALID_FLAG) IS NULL
            OR  UPPER(V_VALID_FLAG_ALL) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
            OR  A.VALID_YN = V_VALID_FLAG)
         ORDER BY A.DIVISION_ID
                , IA.SITE_ID
                , IB.COMPANY_ID
                , IC.PLANT_ID
                , ID.FACTORY_ID
                , IE.LINE_ID;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0104_GET_CAPA_LINE_SOP_ELTR;

/****************************************************************************************************/
/* Program ID  : P_SCP0104_CHECK_NAME_ON_DUMMY_CODE                                                 */
/* Description : Dummy 코드 이름 확인 · 없으면 코드를 새로 만든다                                   */
/****************************************************************************************************/
PROCEDURE P_SCP0104_CHECK_NAME_ON_DUMMY_CODE
(
    P_CODE_TP           IN  CLOB
  , P_NAME              IN  CLOB
  , P_PROGRAM_ID        IN  CLOB
  , P_SHEET_NAME        IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_DEBUG_MODE        IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    V_CODE_TP           VARCHAR2(1 CHAR)    := TO_CHAR(SUBSTR(P_CODE_TP, 1, 1));
    V_NAME              VARCHAR2(100 CHAR)  := TO_CHAR(SUBSTR(P_NAME,    1, 100));
    V_USER_ID           VARCHAR2(30 CHAR)   := TO_CHAR(SUBSTR(P_USER_ID, 1, 30));

    V_TEST_MODE         VARCHAR2(20 CHAR)   := 'F';

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME      VARCHAR2(150 CHAR)  := 'SCP0104_CHECK_NAME_ON_DUMMY_CODE';
    V_LOG_TYPE          VARCHAR2(30 CHAR);      /* START/END/ERROR/... */
    N_LOG_COUNT         NUMBER(10) := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    D_EVENT_DATE        DATE;

    V_NEW_CODE          VARCHAR2(30 CHAR)   := '';
    N_CNT               NUMBER(10) := 0;
    N_SEQ               NUMBER(19);

    V_SQLCODE           NUMBER;
    V_SQLERRM           VARCHAR2(4000 CHAR);

BEGIN

    SAVEPOINT SP_SCP0104_CHECK_NAME;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    IF V_TEST_MODE <> 'T'
    THEN
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END IF;

    SELECT SEQ1_SCP_MST_CAPA_DUMMY_CODE.NEXTVAL
      INTO N_SEQ
      FROM DUAL;

    V_NEW_CODE := 'DMY_' || TO_CHAR(N_SEQ);

    /* 원문은 MERGE 로 없을 때만 넣는다 — 넣기만 하므로 한 문장으로 옮긴다 */
    INSERT INTO SCP_MST_CAPA_DUMMY_CODE
                ( CODE_TP
                , CODE
                , NAME
                , VALID_YN
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
         SELECT V_CODE_TP
              , V_NEW_CODE
              , V_NAME
              , 'Y'
              , V_USER_ID
              , SYSDATE
              , V_USER_ID
              , SYSDATE
           FROM DUAL
          WHERE NOT EXISTS (SELECT 1
                              FROM SCP_MST_CAPA_DUMMY_CODE A
                             WHERE A.CODE_TP = V_CODE_TP
                               AND A.NAME    = V_NAME);

    SELECT COUNT(*)
      INTO N_CNT
      FROM SCP_MST_CAPA_DUMMY_CODE
     WHERE CODE = V_NEW_CODE;

    IF N_CNT = 0    /* 기존에 동일한 명칭이 존재하는 경우 */
    THEN

        OPEN O_RC1 FOR
            SELECT *
              FROM SCP_MST_CAPA_DUMMY_CODE
             WHERE NAME = V_NAME;

    ELSE

        OPEN O_RC1 FOR
            SELECT *
              FROM SCP_MST_CAPA_DUMMY_CODE
             WHERE CODE = V_NEW_CODE;

    END IF;

    /* LOG end */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    IF V_TEST_MODE <> 'T'
    THEN
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END IF;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

EXCEPTION
    WHEN OTHERS
    THEN

        V_SQLCODE := SQLCODE;
        V_SQLERRM := SQLERRM;

        ROLLBACK TO SP_SCP0104_CHECK_NAME;      /* 입력 데이타 롤백 처리 */

        INSERT INTO SCM_SYS_LOG_BATCH
                    ( PROGRAM_NAME
                    , LOG_TYPE
                    , LOG_COUNT
                    , LOG_MESSAGE
                    , DESCRIPTION
                    , EVENT_DATE
                    , CREATION_DATE
                    , CREATED_BY
                    , LAST_UPDATE_DATE
                    , LAST_UPDATED_BY )
             VALUES ( V_PROGRAM_NAME
                    , 'ERROR'
                    , NULL
                    , V_SQLERRM
                    , NULL
                    , SYSDATE
                    , SYSDATE
                    , V_PROGRAM_NAME
                    , SYSDATE
                    , V_PROGRAM_NAME );

        COMMIT;

        OPEN O_RC1 FOR
            SELECT 'F'                                              AS RESULT_CODE
                 , '[' || TO_CHAR(V_SQLCODE) || ']' || V_SQLERRM     AS ERR_MESSAGE
              FROM DUAL;

        OPEN O_RESULT_CURSOR FOR
            SELECT '[' || TO_CHAR(V_SQLCODE) || ']' || V_SQLERRM     AS ERR_MESSAGE
              FROM DUAL;

END P_SCP0104_CHECK_NAME_ON_DUMMY_CODE;

/****************************************************************************************************/
/* Program ID  : P_SCP0104_ADD_CAPA_NEW_VERSION                                                     */
/* Description : CAPA 새 버전 추가                                                                  */
/****************************************************************************************************/
PROCEDURE P_SCP0104_ADD_CAPA_NEW_VERSION
(
    P_DIVISION_ID       IN  CLOB
  , P_PROGRAM_ID        IN  CLOB
  , P_SHEET_NAME        IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_DEBUG_MODE        IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    V_DIVISION_ID       VARCHAR2(30 CHAR)   := TO_CHAR(SUBSTR(P_DIVISION_ID, 1, 30));
    V_USER_ID           VARCHAR2(30 CHAR)   := TO_CHAR(SUBSTR(P_USER_ID,     1, 30));

    V_TEST_MODE         VARCHAR2(20 CHAR)   := 'F';

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME      VARCHAR2(150 CHAR)  := 'SCP0104_ADD_CAPA_NEW_VERSION';
    V_LOG_TYPE          VARCHAR2(30 CHAR);      /* START/END/ERROR/... */
    N_LOG_COUNT         NUMBER(10) := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    D_EVENT_DATE        DATE;

    V_LAST_VERSION      VARCHAR2(6 CHAR)    := '';
    V_NEW_VERSION       VARCHAR2(6 CHAR)    := '';

    V_SQLCODE           NUMBER;
    V_SQLERRM           VARCHAR2(4000 CHAR);

BEGIN

    SAVEPOINT SP_SCP0104_ADD_VERSION;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    IF V_TEST_MODE <> 'T'
    THEN
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END IF;

    SELECT MAX(A.VER_ID)
      INTO V_LAST_VERSION
      FROM SCP_MST_CAPA_VERSION A
         , (SELECT XB.SEGMENT1    AS CODE
                 , XB.SEGMENT2    AS NAME
              FROM SCM_ADM_LOOKUP_MASTER XA
                 , SCM_ADM_LOOKUP_MASTER_DETAIL XB
             WHERE XB.LOOKUP_TYPE  = XA.LOOKUP_TYPE
               AND XA.LOOKUP_GROUP = 'SCP'
               AND XA.LOOKUP_TYPE  = 'CAPA_PROG_STAT'
               AND XB.VALID_YN     = 'Y') IA
     WHERE IA.CODE       = A.PROG_STAT
       AND A.DIVISION_ID = V_DIVISION_ID;

    SELECT MIN(BASIS_YYYYMM)
      INTO V_NEW_VERSION
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMM > V_LAST_VERSION;

    /* SAVE - SCP_MST_CAPA_VERSION - BEGIN */
    /* 원문은 MERGE 한 문장이나 온라인 SQL 에서 쓰지 않는 규칙이라 두 문장으로 나눈다 */
    UPDATE SCP_MST_CAPA_VERSION
       SET PROG_STAT        = '0'
         , LAST_UPDATED_BY  = V_USER_ID
         , LAST_UPDATE_DATE = SYSDATE
     WHERE DIVISION_ID = V_DIVISION_ID
       AND VER_ID      = V_NEW_VERSION
       AND VER_SEQ     = 1;

    IF SQL%ROWCOUNT = 0
    THEN

        INSERT INTO SCP_MST_CAPA_VERSION
                    ( DIVISION_ID
                    , VER_ID
                    , VER_SEQ
                    , PROG_STAT
                    , CREATED_BY
                    , CREATION_DATE
                    , LAST_UPDATED_BY
                    , LAST_UPDATE_DATE )
             VALUES ( V_DIVISION_ID
                    , V_NEW_VERSION
                    , 1
                    , '0'
                    , V_USER_ID
                    , SYSDATE
                    , V_USER_ID
                    , SYSDATE );

    END IF;
    /* SAVE - SCP_MST_CAPA_VERSION - END */

    /* LOG end */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    COMMIT;

    /* 결과코드, 결과 카운트 반환 */
    OPEN O_RC1 FOR
        SELECT 'S'  AS RESULT_CODE
             , 1    AS RESULT_CNT
          FROM DUAL;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

EXCEPTION
    WHEN OTHERS
    THEN

        V_SQLCODE := SQLCODE;
        V_SQLERRM := SQLERRM;

        ROLLBACK TO SP_SCP0104_ADD_VERSION;     /* 입력 데이타 롤백 처리 */

        INSERT INTO SCM_SYS_LOG_BATCH
                    ( PROGRAM_NAME
                    , LOG_TYPE
                    , LOG_COUNT
                    , LOG_MESSAGE
                    , DESCRIPTION
                    , EVENT_DATE
                    , CREATION_DATE
                    , CREATED_BY
                    , LAST_UPDATE_DATE
                    , LAST_UPDATED_BY )
             VALUES ( V_PROGRAM_NAME
                    , 'ERROR'
                    , NULL
                    , V_SQLERRM
                    , NULL
                    , SYSDATE
                    , SYSDATE
                    , V_PROGRAM_NAME
                    , SYSDATE
                    , V_PROGRAM_NAME );

        COMMIT;

        OPEN O_RC1 FOR
            SELECT 'F'                                              AS RESULT_CODE
                 , '[' || TO_CHAR(V_SQLCODE) || ']' || V_SQLERRM     AS ERR_MESSAGE
              FROM DUAL;

        OPEN O_RESULT_CURSOR FOR
            SELECT '[' || TO_CHAR(V_SQLCODE) || ']' || V_SQLERRM     AS ERR_MESSAGE
              FROM DUAL;

END P_SCP0104_ADD_CAPA_NEW_VERSION;


/****************************************************************************************************/
/* Program ID  : P_SCP0104_GET_CAPA_LINE_ASSIGN_MDL_ASSEMBLY                                        */
/* Description : CAPA LINE ASSIGN 모델 — 조립                                                       */
/****************************************************************************************************/
PROCEDURE P_SCP0104_GET_CAPA_LINE_ASSIGN_MDL_ASSEMBLY
(
    P_VERSION           IN  CLOB
  , P_VERSION_SEQ       IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_SITE_ID           IN  CLOB
  , P_PLANT_ID          IN  CLOB
  , P_FACTORY_ID        IN  CLOB
  , P_LINE_ID           IN  CLOB
  , P_OPERATION_ID      IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_ELECTRODE_TYPE    IN  CLOB
  , P_PROGRAM_ID        IN  CLOB
  , P_SHEET_NAME        IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_DEBUG_MODE        IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    V_DIVISION_ID       VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID,    1, 4000));
    V_SITE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_SITE_ID,        1, 4000));
    V_PLANT_ID          VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_PLANT_ID,       1, 4000));
    V_FACTORY_ID        VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_FACTORY_ID,     1, 4000));
    V_LINE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_LINE_ID,        1, 4000));
    V_OPERATION_ID      VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_OPERATION_ID,   1, 4000));
    V_ELECTRODE_TYPE    VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_ELECTRODE_TYPE, 1, 4000));

BEGIN

    /* 원문은 WITH 절로 버전 · 계층 이름 · 공정 이름을 묶으나 온라인 SQL 에서 쓰지 않는 규칙이라 인라인 뷰로 옮긴다.
       속도 단위 묶음(tbl_SPEED_UNIT_*) 과 공정별 전극구분 묶음은 최종 조회에서 쓰지 않아 옮기지 않는다 */
    OPEN O_RC1 FOR
        SELECT SA.VER_ID
             , SA.VER_SEQ
             , SA.DIVISION_ID
             , SA.COMPANY_ID
             , SA.SITE_ID
             , SA.PLANT_ID
             , SA.FACTORY_ID
             , SA.LINE_ID
             , SA.OPERATION_ID
             , SA.ELTR_LN_TP_CD
             , FN_GET_DIVISION_NAME(SA.DIVISION_ID)     AS DIVISION_NAME
             , IA.SITE_NAME                             AS SITE_NAME
             , IB.COMPANY_NAME                          AS COMPANY_NAME
             , IC.PLANT_NAME                            AS PLANT_NAME
             , ID.FACTORY_NAME                          AS FACTORY_NAME
             , IE.LINE_NAME                             AS LINE_NAME
             , IG.NAME                                  AS OPERATION_NAME
          FROM (SELECT XV.VER_ID
                     , XV.VER_SEQ
                     , A.DIVISION_ID
                     , A.COMPANY_ID
                     , A.SITE_ID
                     , A.PLANT_ID
                     , A.FACTORY_ID
                     , A.LINE_ID
                     , A.OPERATION_ID
                     , A.ELTR_LN_TP_CD
                  FROM SCP_MST_CAPA_LINE_ASSIGN A
                     , (SELECT DIVISION_ID
                             , MAX(VER_ID)      AS VER_ID
                             , MAX(VER_SEQ)     AS VER_SEQ
                          FROM SCP_MST_CAPA_VERSION
                         WHERE PROG_STAT = '0'
                         GROUP BY DIVISION_ID) XV
                 WHERE XV.DIVISION_ID(+) = A.DIVISION_ID
                   AND A.VALID_YN      = 'Y'
                   AND A.OPERATION_ID <> 'AFFFF'
                   AND (TRIM(V_DIVISION_ID) IS NULL
                    OR  UPPER(V_DIVISION_ID) = 'ALL'                /* 조회조건 ALL 은 조건 없음 */
                    OR  A.DIVISION_ID IN (SELECT COLUMN_VALUE
                                            FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
                   AND (TRIM(V_SITE_ID) IS NULL
                    OR  UPPER(V_SITE_ID) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
                    OR  A.SITE_ID IN (SELECT COLUMN_VALUE
                                        FROM TABLE(STRING_SPLIT(V_SITE_ID, ','))))
                   AND (TRIM(V_PLANT_ID) IS NULL
                    OR  UPPER(V_PLANT_ID) = 'ALL'                   /* 조회조건 ALL 은 조건 없음 */
                    OR  A.PLANT_ID IN (SELECT COLUMN_VALUE
                                         FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
                   AND (TRIM(V_FACTORY_ID) IS NULL
                    OR  UPPER(V_FACTORY_ID) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                    OR  A.FACTORY_ID IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(V_FACTORY_ID, ','))))
                   AND (TRIM(V_LINE_ID) IS NULL
                    OR  UPPER(V_LINE_ID) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
                    OR  A.LINE_ID IN (SELECT COLUMN_VALUE
                                        FROM TABLE(STRING_SPLIT(V_LINE_ID, ','))))
                   AND (TRIM(V_OPERATION_ID) IS NULL
                    OR  UPPER(V_OPERATION_ID) = 'ALL'               /* 조회조건 ALL 은 조건 없음 */
                    OR  A.OPERATION_ID IN (SELECT COLUMN_VALUE
                                             FROM TABLE(STRING_SPLIT(V_OPERATION_ID, ','))))
                   AND (TRIM(V_ELECTRODE_TYPE) IS NULL
                    OR  UPPER(V_ELECTRODE_TYPE) = 'ALL'             /* 조회조건 ALL 은 조건 없음 */
                    OR  A.ELTR_LN_TP_CD IN (SELECT COLUMN_VALUE
                                              FROM TABLE(STRING_SPLIT(V_ELECTRODE_TYPE, ','))))
                 GROUP BY XV.VER_ID
                        , XV.VER_SEQ
                        , A.DIVISION_ID
                        , A.COMPANY_ID
                        , A.SITE_ID
                        , A.PLANT_ID
                        , A.FACTORY_ID
                        , A.LINE_ID
                        , A.OPERATION_ID
                        , A.ELTR_LN_TP_CD) SA
             , (SELECT SITE_ID
                     , SITE_NAME
                  FROM SCP_MST_CAPA_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY SITE_ID
                        , SITE_NAME) IA
             , (SELECT COMPANY_ID
                     , COMPANY_NAME
                  FROM SCP_MST_CAPA_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY COMPANY_ID
                        , COMPANY_NAME) IB
             , (SELECT PLANT_ID
                     , PLANT_NAME
                  FROM SCP_MST_CAPA_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY PLANT_ID
                        , PLANT_NAME) IC
             , (SELECT FACTORY_ID
                     , FACTORY_NAME
                  FROM SCP_MST_CAPA_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY FACTORY_ID
                        , FACTORY_NAME) ID
             , (SELECT LINE_ID
                     , LINE_NAME
                  FROM SCP_MST_CAPA_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY LINE_ID
                        , LINE_NAME) IE
             , (SELECT XA.CODE
                     , XA.NAME
                  FROM (SELECT XB.OPERATION_ID          AS CODE
                             , MAX(XB.OPERATION_NAME)   AS NAME
                          FROM SCM_MST_OPERATION_SN XB
                         GROUP BY XB.OPERATION_ID
                        UNION ALL
                        SELECT XD.SEGMENT1              AS CODE
                             , XD.ATTRIBUTE1            AS NAME
                          FROM SCM_ADM_LOOKUP_MASTER XC
                             , SCM_ADM_LOOKUP_MASTER_DETAIL XD
                         WHERE XD.LOOKUP_TYPE  = XC.LOOKUP_TYPE
                           AND XC.LOOKUP_GROUP = 'SCP'
                           AND XC.LOOKUP_TYPE  = 'CPS_FORMATION_OPERATION'
                           AND XD.VALID_YN     = 'Y'
                         GROUP BY XD.SEGMENT1
                                , XD.ATTRIBUTE1) XA) IG
         WHERE IA.SITE_ID(+)    = SA.SITE_ID
           AND IB.COMPANY_ID(+) = SA.COMPANY_ID
           AND IC.PLANT_ID(+)   = SA.PLANT_ID
           AND ID.FACTORY_ID(+) = SA.FACTORY_ID
           AND IE.LINE_ID(+)    = SA.LINE_ID
           AND IG.CODE(+)       = SA.OPERATION_ID
         ORDER BY SA.VER_ID
                , SA.VER_SEQ
                , SA.DIVISION_ID
                , SA.SITE_ID
                , SA.COMPANY_ID
                , SA.PLANT_ID
                , SA.FACTORY_ID
                , SA.LINE_ID
                , SA.OPERATION_ID
                , SA.ELTR_LN_TP_CD;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0104_GET_CAPA_LINE_ASSIGN_MDL_ASSEMBLY;

/****************************************************************************************************/
/* Program ID  : P_SCP0104_GET_CAPA_LINE_ASSIGN_MDL_ELTR                                            */
/* Description : CAPA LINE ASSIGN 모델 — 전극                                                       */
/****************************************************************************************************/
PROCEDURE P_SCP0104_GET_CAPA_LINE_ASSIGN_MDL_ELTR
(
    P_VERSION           IN  CLOB
  , P_VERSION_SEQ       IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_SITE_ID           IN  CLOB
  , P_PLANT_ID          IN  CLOB
  , P_FACTORY_ID        IN  CLOB
  , P_LINE_ID           IN  CLOB
  , P_OPERATION_ID      IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_ELECTRODE_TYPE    IN  CLOB
  , P_PROGRAM_ID        IN  CLOB
  , P_SHEET_NAME        IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_DEBUG_MODE        IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    V_DIVISION_ID       VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID,    1, 4000));
    V_SITE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_SITE_ID,        1, 4000));
    V_PLANT_ID          VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_PLANT_ID,       1, 4000));
    V_FACTORY_ID        VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_FACTORY_ID,     1, 4000));
    V_LINE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_LINE_ID,        1, 4000));
    V_OPERATION_ID      VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_OPERATION_ID,   1, 4000));
    V_ELECTRODE_TYPE    VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_ELECTRODE_TYPE, 1, 4000));

BEGIN

    /* 원문은 WITH 절로 버전 · 계층 이름 · 공정 이름을 묶으나 온라인 SQL 에서 쓰지 않는 규칙이라 인라인 뷰로 옮긴다.
       ★전극 갈래에는 원문에 공정 제외 조건(OPERATION_ID <> 'AFFFF')이 없다 — 원문 그대로 둔다 */
    OPEN O_RC1 FOR
        SELECT SA.VER_ID
             , SA.VER_SEQ
             , SA.DIVISION_ID
             , SA.COMPANY_ID
             , SA.SITE_ID
             , SA.PLANT_ID
             , SA.FACTORY_ID
             , SA.LINE_ID
             , SA.OPERATION_ID
             , SA.ELTR_LN_TP_CD
             , FN_GET_DIVISION_NAME(SA.DIVISION_ID)     AS DIVISION_NAME
             , IA.SITE_NAME                             AS SITE_NAME
             , IB.COMPANY_NAME                          AS COMPANY_NAME
             , IC.PLANT_NAME                            AS PLANT_NAME
             , ID.FACTORY_NAME                          AS FACTORY_NAME
             , IE.LINE_NAME                             AS LINE_NAME
             , IG.NAME                                  AS OPERATION_NAME
          FROM (SELECT XV.VER_ID
                     , XV.VER_SEQ
                     , A.DIVISION_ID
                     , A.COMPANY_ID
                     , A.SITE_ID
                     , A.PLANT_ID
                     , A.FACTORY_ID
                     , A.LINE_ID
                     , A.OPERATION_ID
                     , A.ELTR_LN_TP_CD
                  FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN A
                     , (SELECT DIVISION_ID
                             , MAX(VER_ID)      AS VER_ID
                             , MAX(VER_SEQ)     AS VER_SEQ
                          FROM SCP_MST_CAPA_VERSION
                         WHERE PROG_STAT = '0'
                         GROUP BY DIVISION_ID) XV
                 WHERE XV.DIVISION_ID(+) = A.DIVISION_ID
                   AND A.VALID_YN = 'Y'
                   AND (TRIM(V_DIVISION_ID) IS NULL
                    OR  UPPER(V_DIVISION_ID) = 'ALL'                /* 조회조건 ALL 은 조건 없음 */
                    OR  A.DIVISION_ID IN (SELECT COLUMN_VALUE
                                            FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
                   AND (TRIM(V_SITE_ID) IS NULL
                    OR  UPPER(V_SITE_ID) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
                    OR  A.SITE_ID IN (SELECT COLUMN_VALUE
                                        FROM TABLE(STRING_SPLIT(V_SITE_ID, ','))))
                   AND (TRIM(V_PLANT_ID) IS NULL
                    OR  UPPER(V_PLANT_ID) = 'ALL'                   /* 조회조건 ALL 은 조건 없음 */
                    OR  A.PLANT_ID IN (SELECT COLUMN_VALUE
                                         FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
                   AND (TRIM(V_FACTORY_ID) IS NULL
                    OR  UPPER(V_FACTORY_ID) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                    OR  A.FACTORY_ID IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(V_FACTORY_ID, ','))))
                   AND (TRIM(V_LINE_ID) IS NULL
                    OR  UPPER(V_LINE_ID) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
                    OR  A.LINE_ID IN (SELECT COLUMN_VALUE
                                        FROM TABLE(STRING_SPLIT(V_LINE_ID, ','))))
                   AND (TRIM(V_OPERATION_ID) IS NULL
                    OR  UPPER(V_OPERATION_ID) = 'ALL'               /* 조회조건 ALL 은 조건 없음 */
                    OR  A.OPERATION_ID IN (SELECT COLUMN_VALUE
                                             FROM TABLE(STRING_SPLIT(V_OPERATION_ID, ','))))
                   AND (TRIM(V_ELECTRODE_TYPE) IS NULL
                    OR  UPPER(V_ELECTRODE_TYPE) = 'ALL'             /* 조회조건 ALL 은 조건 없음 */
                    OR  A.ELTR_LN_TP_CD IN (SELECT COLUMN_VALUE
                                              FROM TABLE(STRING_SPLIT(V_ELECTRODE_TYPE, ','))))
                 GROUP BY XV.VER_ID
                        , XV.VER_SEQ
                        , A.DIVISION_ID
                        , A.COMPANY_ID
                        , A.SITE_ID
                        , A.PLANT_ID
                        , A.FACTORY_ID
                        , A.LINE_ID
                        , A.OPERATION_ID
                        , A.ELTR_LN_TP_CD) SA
             , (SELECT SITE_ID
                     , SITE_NAME
                  FROM SCP_MST_CAPA_ELTR_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY SITE_ID
                        , SITE_NAME) IA
             , (SELECT COMPANY_ID
                     , COMPANY_NAME
                  FROM SCP_MST_CAPA_ELTR_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY COMPANY_ID
                        , COMPANY_NAME) IB
             , (SELECT PLANT_ID
                     , PLANT_NAME
                  FROM SCP_MST_CAPA_ELTR_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY PLANT_ID
                        , PLANT_NAME) IC
             , (SELECT FACTORY_ID
                     , FACTORY_NAME
                  FROM SCP_MST_CAPA_ELTR_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY FACTORY_ID
                        , FACTORY_NAME) ID
             , (SELECT LINE_ID
                     , LINE_NAME
                  FROM SCP_MST_CAPA_ELTR_LINE
                 WHERE VALID_YN = 'Y'
                 GROUP BY LINE_ID
                        , LINE_NAME) IE
             , (SELECT OPERATION_ID       AS CODE
                     , OPERATION_NAME     AS NAME
                  FROM SCM_MST_OPERATION_SN
                 GROUP BY OPERATION_ID
                        , OPERATION_NAME) IG
         WHERE IA.SITE_ID(+)    = SA.SITE_ID
           AND IB.COMPANY_ID(+) = SA.COMPANY_ID
           AND IC.PLANT_ID(+)   = SA.PLANT_ID
           AND ID.FACTORY_ID(+) = SA.FACTORY_ID
           AND IE.LINE_ID(+)    = SA.LINE_ID
           AND IG.CODE(+)       = SA.OPERATION_ID
         ORDER BY SA.VER_ID
                , SA.VER_SEQ
                , SA.DIVISION_ID
                , SA.SITE_ID
                , SA.COMPANY_ID
                , SA.PLANT_ID
                , SA.FACTORY_ID
                , SA.LINE_ID
                , SA.OPERATION_ID
                , SA.ELTR_LN_TP_CD;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0104_GET_CAPA_LINE_ASSIGN_MDL_ELTR;


/****************************************************************************************************/
/* Program ID  : P_SCP0104_GET_CAPA_LINE_ASSIGN_ASSEMBLY                                            */
/* Description : CAPA LINE ASSIGN — 조립                                                            */
/*               ★날짜 칸 수가 조회 기준 월에 따라 달라지므로(39 또는 78) 최종 조회만 동적으로 만든다 */
/*                 — CNS 규칙의 「피벗처럼 불가피한 동적 컬럼」 예외                                */
/* Program History : 2026.10.06   AJS   조회 속도 개선 : 라인 배정 조회의 사업부 이름 함수 호출 캐시 · 전극 품목 약칭을 배정 원장 품목으로 한정(결과 동일) */
/*                   2026.10.07   AJS   조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시 */
/****************************************************************************************************/
PROCEDURE P_SCP0104_GET_CAPA_LINE_ASSIGN_ASSEMBLY
(
    P_VERSION           IN  CLOB
  , P_VERSION_SEQ       IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_SITE_ID           IN  CLOB
  , P_PLANT_ID          IN  CLOB
  , P_FACTORY_ID        IN  CLOB
  , P_LINE_ID           IN  CLOB
  , P_OPERATION_ID      IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_ELECTRODE_TYPE    IN  CLOB
  , P_VALID_FLAG        IN  CLOB
  , P_PROGRAM_ID        IN  CLOB
  , P_SHEET_NAME        IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_DEBUG_MODE        IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    V_VERSION           VARCHAR2(40 CHAR)   := TO_CHAR(SUBSTR(P_VERSION,        1, 40));
    N_VERSION_SEQ       NUMBER(3)           := TO_NUMBER(TO_CHAR(SUBSTR(P_VERSION_SEQ, 1, 3)));
    V_DIVISION_ID       VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID,    1, 4000));
    V_SITE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_SITE_ID,        1, 4000));
    V_PLANT_ID          VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_PLANT_ID,       1, 4000));
    V_FACTORY_ID        VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_FACTORY_ID,     1, 4000));
    V_LINE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_LINE_ID,        1, 4000));
    V_OPERATION_ID      VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_OPERATION_ID,   1, 4000));
    V_ITEM_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID,        1, 4000));
    V_ELECTRODE_TYPE    VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_ELECTRODE_TYPE, 1, 4000));
    /* AS-IS 사용여부 인자는 한 글자라 'ALL' 이 'A' 로 잘린다 — 값 비교는 한 글자, 조회조건 ALL 판정만 자르지 않은 값으로 */
    V_VALID_FLAG        VARCHAR2(1 CHAR)    := TO_CHAR(SUBSTR(P_VALID_FLAG,     1, 1));
    V_VALID_FLAG_ALL    VARCHAR2(10 CHAR)   := TO_CHAR(SUBSTR(P_VALID_FLAG,     1, 10));
    V_PROGRAM_ID        VARCHAR2(100 CHAR)  := TO_CHAR(SUBSTR(P_PROGRAM_ID,     1, 100));
    V_SHEET_NAME        VARCHAR2(100 CHAR)  := TO_CHAR(SUBSTR(P_SHEET_NAME,     1, 100));

    V_FROM_YYYY         VARCHAR2(4 CHAR)    := SUBSTR(TO_CHAR(SUBSTR(P_VERSION, 1, 40)), 1, 4);
    /* 날짜 칸은 버전의 다음 달부터 만든다 — 원문과 같게 */
    V_FROM_YYYYMM       VARCHAR2(6 CHAR)    := TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(SUBSTR(P_VERSION, 1, 6)) || '01', 'YYYYMMDD'), 1), 'YYYYMM');
    V_TO_YYYY           VARCHAR2(4 CHAR);
    V_PROG_STAT         VARCHAR2(8 CHAR);

    V_DATE_COLS         CLOB := EMPTY_CLOB();
    V_FINAL_COLS        CLOB := EMPTY_CLOB();
    V_SQL               CLOB;

BEGIN

    /* 날짜 칸 목록 · 조회 마지막 연도 */
    SELECT MAX(A.SMALL_CLASS_LABEL_NAME)
      INTO V_TO_YYYY
      FROM TABLE(FN_SCP0104_GET_SPREAD_TITLE(V_FROM_YYYYMM, V_PROGRAM_ID, V_SHEET_NAME)) A;

    FOR R IN (SELECT A.COLUMN_NAME
                FROM TABLE(FN_SCP0104_GET_SPREAD_TITLE(V_FROM_YYYYMM, V_PROGRAM_ID, V_SHEET_NAME)) A
               ORDER BY A.SORT_ORDER_NO)
    LOOP

        IF INSTR(R.COLUMN_NAME, 'M_') = 1
        THEN
            V_DATE_COLS := V_DATE_COLS || '
     , CAST(CASE WHEN YYYYMM = SUBSTR(''' || R.COLUMN_NAME || ''', 5, 6) THEN ASSIGN_PRIORITY END AS NUMBER(4)) AS ' || R.COLUMN_NAME;
        ELSIF INSTR(R.COLUMN_NAME, 'Y_') = 1
        THEN
            V_DATE_COLS := V_DATE_COLS || '
     , CAST(CASE WHEN YYYYMM = SUBSTR(''' || R.COLUMN_NAME || ''', 3, 4) THEN ASSIGN_PRIORITY END AS NUMBER(4)) AS ' || R.COLUMN_NAME;
        END IF;

        V_FINAL_COLS := V_FINAL_COLS || '
     , SUM(' || R.COLUMN_NAME || ') AS ' || R.COLUMN_NAME;

    END LOOP;

    /* 선택된 버전 상태에 따라 현재분과 마감분 중 하나를 읽는다 */
    BEGIN
        SELECT PROG_STAT
          INTO V_PROG_STAT
          FROM SCP_MST_CAPA_VERSION
         WHERE DIVISION_ID = V_DIVISION_ID
           AND VER_ID      = V_VERSION
           AND VER_SEQ     = N_VERSION_SEQ;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            V_PROG_STAT := '';
    END;

    /* 세션 유지 임시 테이블은 시작할 때 비운다 */
    DELETE
      FROM GT_SCP0104_ASSIGN_RAW;

    IF V_PROG_STAT = '0' OR V_PROG_STAT = '-'    /* CURRENT, Pre */
    THEN

        INSERT INTO GT_SCP0104_ASSIGN_RAW
                    ( VER_ID
                    , VER_SEQ
                    , DIVISION_ID
                    , COMPANY_ID
                    , SITE_ID
                    , PLANT_ID
                    , FACTORY_ID
                    , LINE_ID
                    , OPERATION_ID
                    , ELTR_LN_TP_CD
                    , ITEM_ID
                    , NICK_NAME
                    , YYYYMM
                    , ASSIGN_PRIORITY
                    , DIVISION_NAME
                    , SITE_NAME
                    , COMPANY_NAME
                    , PLANT_NAME
                    , FACTORY_NAME
                    , LINE_NAME
                    , DUMMY_YN
                    , VALID_YN
                    , PROG_STAT
                    , OPERATION_NAME )
             SELECT V_VERSION
                  , N_VERSION_SEQ
                  , A.DIVISION_ID
                  , A.COMPANY_ID
                  , A.SITE_ID
                  , A.PLANT_ID
                  , A.FACTORY_ID
                  , A.LINE_ID
                  , A.OPERATION_ID
                  , A.ELTR_LN_TP_CD
                  , A.ITEM_ID
                  , A.NICK_NAME
                  , A.YYYYMM
                  , CASE WHEN A.ASSIGN_PRIORITY = 0 THEN NULL
                         ELSE A.ASSIGN_PRIORITY END               /* 우선순위가 없으면 클리어 */
--                  , FN_GET_DIVISION_NAME(A.DIVISION_ID)   --  2026.10.06 AJS
                  , (SELECT FN_GET_DIVISION_NAME(A.DIVISION_ID) FROM DUAL)   --  2026.10.06 AJS
                  , IA.SITE_NAME
                  , IB.COMPANY_NAME
                  , IC.PLANT_NAME
                  , ID.FACTORY_NAME
                  , IE.LINE_NAME
                  , A.DUMMY_YN
                  , A.VALID_YN
                  , '0'
                  , NVL(IG.NAME, '-')
               FROM SCP_MST_CAPA_LINE_ASSIGN A
                  , SCP_MST_CAPA_LINE B
                  , (SELECT SITE_ID
                          , SITE_NAME
                       FROM SCP_MST_CAPA_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY SITE_ID
                             , SITE_NAME) IA
                  , (SELECT COMPANY_ID
                          , COMPANY_NAME
                       FROM SCP_MST_CAPA_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY COMPANY_ID
                             , COMPANY_NAME) IB
                  , (SELECT PLANT_ID
                          , PLANT_NAME
                       FROM SCP_MST_CAPA_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY PLANT_ID
                             , PLANT_NAME) IC
                  , (SELECT FACTORY_ID
                          , FACTORY_NAME
                       FROM SCP_MST_CAPA_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY FACTORY_ID
                             , FACTORY_NAME) ID
                  , (SELECT LINE_ID
                          , LINE_NAME
                       FROM SCP_MST_CAPA_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY LINE_ID
                             , LINE_NAME) IE
                  , (SELECT XA.CODE
                          , XA.NAME
                       FROM (SELECT XB.OPERATION_ID          AS CODE
                                  , MAX(XB.OPERATION_NAME)   AS NAME
                               FROM SCM_MST_OPERATION_SN XB
                              GROUP BY XB.OPERATION_ID
                             UNION ALL
                             SELECT XD.SEGMENT1              AS CODE
                                  , XD.ATTRIBUTE1            AS NAME
                               FROM SCM_ADM_LOOKUP_MASTER XC
                                  , SCM_ADM_LOOKUP_MASTER_DETAIL XD
                              WHERE XD.LOOKUP_TYPE  = XC.LOOKUP_TYPE
                                AND XC.LOOKUP_GROUP = 'SCP'
                                AND XC.LOOKUP_TYPE  = 'CPS_FORMATION_OPERATION'
                                AND XD.VALID_YN     = 'Y'
                              GROUP BY XD.SEGMENT1
                                     , XD.ATTRIBUTE1) XA) IG
              WHERE B.DIVISION_ID(+)   = A.DIVISION_ID
                AND B.COMPANY_ID(+)    = A.COMPANY_ID
                AND B.SITE_ID(+)       = A.SITE_ID
                AND B.PLANT_ID(+)      = A.PLANT_ID
                AND B.FACTORY_ID(+)    = A.FACTORY_ID
                AND B.LINE_ID(+)       = A.LINE_ID
                AND B.OPERATION_ID(+)  = A.OPERATION_ID
                AND B.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
                AND IA.SITE_ID(+)      = A.SITE_ID
                AND IB.COMPANY_ID(+)   = A.COMPANY_ID
                AND IC.PLANT_ID(+)     = A.PLANT_ID
                AND ID.FACTORY_ID(+)   = A.FACTORY_ID
                AND IE.LINE_ID(+)      = A.LINE_ID
                AND IG.CODE(+)         = A.OPERATION_ID
                AND A.YYYYMM BETWEEN V_FROM_YYYY AND V_TO_YYYY
                AND (TRIM(V_DIVISION_ID) IS NULL
                 OR  UPPER(V_DIVISION_ID) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
                 OR  A.DIVISION_ID IN (SELECT COLUMN_VALUE
                                         FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
                AND (TRIM(V_SITE_ID) IS NULL
                 OR  UPPER(V_SITE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                 OR  A.SITE_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_SITE_ID, ','))))
                AND (TRIM(V_PLANT_ID) IS NULL
                 OR  UPPER(V_PLANT_ID) = 'ALL'                       /* 조회조건 ALL 은 조건 없음 */
                 OR  A.PLANT_ID IN (SELECT COLUMN_VALUE
                                      FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
                AND (TRIM(V_FACTORY_ID) IS NULL
                 OR  UPPER(V_FACTORY_ID) = 'ALL'                     /* 조회조건 ALL 은 조건 없음 */
                 OR  A.FACTORY_ID IN (SELECT COLUMN_VALUE
                                        FROM TABLE(STRING_SPLIT(V_FACTORY_ID, ','))))
                AND (TRIM(V_LINE_ID) IS NULL
                 OR  UPPER(V_LINE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                 OR  A.LINE_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_LINE_ID, ','))))
                AND (TRIM(V_OPERATION_ID) IS NULL
                 OR  UPPER(V_OPERATION_ID) = 'ALL'                   /* 조회조건 ALL 은 조건 없음 */
                 OR  A.OPERATION_ID IN (SELECT COLUMN_VALUE
                                          FROM TABLE(STRING_SPLIT(V_OPERATION_ID, ','))))
                AND (TRIM(V_ELECTRODE_TYPE) IS NULL
                 OR  UPPER(V_ELECTRODE_TYPE) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                 OR  A.ELTR_LN_TP_CD IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(V_ELECTRODE_TYPE, ','))))
                AND (TRIM(V_ITEM_ID) IS NULL
                 OR  UPPER(V_ITEM_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                 /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--               OR  A.NICK_NAME IN (SELECT COLUMN_VALUE
--                                     FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
                 OR  EXISTS (SELECT 1
                               FROM TABLE(STRING_SPLIT(V_ITEM_ID, ',')) SM
                              WHERE TRIM(SM.COLUMN_VALUE) IS NOT NULL
                                AND (   UPPER(A.ITEM_ID)   LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%'
                                     OR UPPER(A.NICK_NAME) LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%')))
                 /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                AND (TRIM(V_VALID_FLAG) IS NULL
                 OR  UPPER(V_VALID_FLAG_ALL) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                 OR  A.VALID_YN = V_VALID_FLAG);

    ELSE

        INSERT INTO GT_SCP0104_ASSIGN_RAW
                    ( VER_ID
                    , VER_SEQ
                    , DIVISION_ID
                    , COMPANY_ID
                    , SITE_ID
                    , PLANT_ID
                    , FACTORY_ID
                    , LINE_ID
                    , OPERATION_ID
                    , ELTR_LN_TP_CD
                    , ITEM_ID
                    , NICK_NAME
                    , YYYYMM
                    , ASSIGN_PRIORITY
                    , DIVISION_NAME
                    , SITE_NAME
                    , COMPANY_NAME
                    , PLANT_NAME
                    , FACTORY_NAME
                    , LINE_NAME
                    , DUMMY_YN
                    , VALID_YN
                    , PROG_STAT
                    , OPERATION_NAME )
             SELECT A.VER_ID
                  , A.VER_SEQ
                  , A.DIVISION_ID
                  , A.COMPANY_ID
                  , A.SITE_ID
                  , A.PLANT_ID
                  , A.FACTORY_ID
                  , A.LINE_ID
                  , A.OPERATION_ID
                  , A.ELTR_LN_TP_CD
                  , A.ITEM_ID
                  , A.NICK_NAME
                  , A.YYYYMM
                  , CASE WHEN A.ASSIGN_PRIORITY = 0 THEN NULL
                         ELSE A.ASSIGN_PRIORITY END               /* 우선순위가 없으면 클리어 */
--                  , FN_GET_DIVISION_NAME(A.DIVISION_ID)   --  2026.10.06 AJS
                  , (SELECT FN_GET_DIVISION_NAME(A.DIVISION_ID) FROM DUAL)   --  2026.10.06 AJS
                  , IA.SITE_NAME
                  , IB.COMPANY_NAME
                  , IC.PLANT_NAME
                  , ID.FACTORY_NAME
                  , IE.LINE_NAME
                  , A.DUMMY_YN
                  , A.VALID_YN
                  , V.PROG_STAT
                  , IG.NAME
               FROM SCP_MST_CAPA_LINE_ASSIGN_CUTF A
                  , SCP_MST_CAPA_VERSION V
                  , SCP_MST_CAPA_LINE B
                  , (SELECT SITE_ID
                          , SITE_NAME
                       FROM SCP_MST_CAPA_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY SITE_ID
                             , SITE_NAME) IA
                  , (SELECT COMPANY_ID
                          , COMPANY_NAME
                       FROM SCP_MST_CAPA_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY COMPANY_ID
                             , COMPANY_NAME) IB
                  , (SELECT PLANT_ID
                          , PLANT_NAME
                       FROM SCP_MST_CAPA_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY PLANT_ID
                             , PLANT_NAME) IC
                  , (SELECT FACTORY_ID
                          , FACTORY_NAME
                       FROM SCP_MST_CAPA_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY FACTORY_ID
                             , FACTORY_NAME) ID
                  , (SELECT LINE_ID
                          , LINE_NAME
                       FROM SCP_MST_CAPA_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY LINE_ID
                             , LINE_NAME) IE
                  , (SELECT XA.CODE
                          , XA.NAME
                       FROM (SELECT XB.OPERATION_ID          AS CODE
                                  , MAX(XB.OPERATION_NAME)   AS NAME
                               FROM SCM_MST_OPERATION_SN XB
                              GROUP BY XB.OPERATION_ID
                             UNION ALL
                             SELECT XD.SEGMENT1              AS CODE
                                  , XD.ATTRIBUTE1            AS NAME
                               FROM SCM_ADM_LOOKUP_MASTER XC
                                  , SCM_ADM_LOOKUP_MASTER_DETAIL XD
                              WHERE XD.LOOKUP_TYPE  = XC.LOOKUP_TYPE
                                AND XC.LOOKUP_GROUP = 'SCP'
                                AND XC.LOOKUP_TYPE  = 'CPS_FORMATION_OPERATION'
                                AND XD.VALID_YN     = 'Y'
                              GROUP BY XD.SEGMENT1
                                     , XD.ATTRIBUTE1) XA) IG
              WHERE V.DIVISION_ID(+)   = A.DIVISION_ID
                AND V.VER_ID(+)        = A.VER_ID
                AND V.VER_SEQ(+)       = A.VER_SEQ
                AND B.DIVISION_ID(+)   = A.DIVISION_ID
                AND B.COMPANY_ID(+)    = A.COMPANY_ID
                AND B.SITE_ID(+)       = A.SITE_ID
                AND B.PLANT_ID(+)      = A.PLANT_ID
                AND B.FACTORY_ID(+)    = A.FACTORY_ID
                AND B.LINE_ID(+)       = A.LINE_ID
                AND B.OPERATION_ID(+)  = A.OPERATION_ID
                AND B.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
                AND IA.SITE_ID(+)      = A.SITE_ID
                AND IB.COMPANY_ID(+)   = A.COMPANY_ID
                AND IC.PLANT_ID(+)     = A.PLANT_ID
                AND ID.FACTORY_ID(+)   = A.FACTORY_ID
                AND IE.LINE_ID(+)      = A.LINE_ID
                AND IG.CODE(+)         = A.OPERATION_ID
                AND A.VER_ID           = V_VERSION
                AND A.VER_SEQ          = N_VERSION_SEQ
                AND A.YYYYMM BETWEEN V_FROM_YYYY AND V_TO_YYYY
                AND (TRIM(V_DIVISION_ID) IS NULL
                 OR  UPPER(V_DIVISION_ID) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
                 OR  A.DIVISION_ID IN (SELECT COLUMN_VALUE
                                         FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
                AND (TRIM(V_SITE_ID) IS NULL
                 OR  UPPER(V_SITE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                 OR  A.SITE_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_SITE_ID, ','))))
                AND (TRIM(V_PLANT_ID) IS NULL
                 OR  UPPER(V_PLANT_ID) = 'ALL'                       /* 조회조건 ALL 은 조건 없음 */
                 OR  A.PLANT_ID IN (SELECT COLUMN_VALUE
                                      FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
                AND (TRIM(V_FACTORY_ID) IS NULL
                 OR  UPPER(V_FACTORY_ID) = 'ALL'                     /* 조회조건 ALL 은 조건 없음 */
                 OR  A.FACTORY_ID IN (SELECT COLUMN_VALUE
                                        FROM TABLE(STRING_SPLIT(V_FACTORY_ID, ','))))
                AND (TRIM(V_LINE_ID) IS NULL
                 OR  UPPER(V_LINE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                 OR  A.LINE_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_LINE_ID, ','))))
                AND (TRIM(V_OPERATION_ID) IS NULL
                 OR  UPPER(V_OPERATION_ID) = 'ALL'                   /* 조회조건 ALL 은 조건 없음 */
                 OR  A.OPERATION_ID IN (SELECT COLUMN_VALUE
                                          FROM TABLE(STRING_SPLIT(V_OPERATION_ID, ','))))
                AND (TRIM(V_ELECTRODE_TYPE) IS NULL
                 OR  UPPER(V_ELECTRODE_TYPE) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                 OR  A.ELTR_LN_TP_CD IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(V_ELECTRODE_TYPE, ','))))
                AND (TRIM(V_ITEM_ID) IS NULL
                 OR  UPPER(V_ITEM_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                 /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--               OR  A.NICK_NAME IN (SELECT COLUMN_VALUE
--                                     FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
                 OR  EXISTS (SELECT 1
                               FROM TABLE(STRING_SPLIT(V_ITEM_ID, ',')) SM
                              WHERE TRIM(SM.COLUMN_VALUE) IS NOT NULL
                                AND (   UPPER(A.ITEM_ID)   LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%'
                                     OR UPPER(A.NICK_NAME) LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%')))
                 /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                AND (TRIM(V_VALID_FLAG) IS NULL
                 OR  UPPER(V_VALID_FLAG_ALL) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                 OR  A.VALID_YN = V_VALID_FLAG);

    END IF;

    /* 최종 조회 — 날짜 칸은 조회 기준 월에 따라 개수가 달라져 문장을 만들어 연다 */
    V_SQL := '
    SELECT VER_ID
         , VER_SEQ
         , DIVISION_ID
         , COMPANY_ID
         , SITE_ID
         , PLANT_ID
         , FACTORY_ID
         , LINE_ID
         , OPERATION_ID
         , ELTR_LN_TP_CD
         , ITEM_ID
         , NICK_NAME
         , MAX(DIVISION_NAME)   AS DIVISION_NAME
         , MAX(SITE_NAME)       AS SITE_NAME
         , MAX(COMPANY_NAME)    AS COMPANY_NAME
         , MAX(PLANT_NAME)      AS PLANT_NAME
         , MAX(FACTORY_NAME)    AS FACTORY_NAME
         , MAX(LINE_NAME)       AS LINE_NAME
         , MAX(OPERATION_NAME)  AS OPERATION_NAME
         , MAX(DUMMY_YN)        AS DUMMY_YN
         , MAX(VALID_YN)        AS VALID_YN' || V_FINAL_COLS || '
      FROM (SELECT VER_ID
                 , VER_SEQ
                 , DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , ITEM_ID
                 , NICK_NAME
                 , DIVISION_NAME
                 , SITE_NAME
                 , COMPANY_NAME
                 , PLANT_NAME
                 , FACTORY_NAME
                 , LINE_NAME
                 , OPERATION_NAME
                 , DUMMY_YN
                 , VALID_YN' || V_DATE_COLS || '
              FROM GT_SCP0104_ASSIGN_RAW)
     GROUP BY VER_ID
            , VER_SEQ
            , DIVISION_ID
            , COMPANY_ID
            , SITE_ID
            , PLANT_ID
            , FACTORY_ID
            , LINE_ID
            , ITEM_ID
            , NICK_NAME
            , OPERATION_ID
            , ELTR_LN_TP_CD
     ORDER BY VER_ID
            , VER_SEQ
            , DIVISION_ID
            , COMPANY_ID
            , SITE_ID
            , SITE_NAME
            , COMPANY_NAME
            , PLANT_ID
            , PLANT_NAME
            , FACTORY_ID
            , FACTORY_NAME
            , LINE_ID
            , LINE_NAME
            , ITEM_ID
            , NICK_NAME
            , OPERATION_ID
            , OPERATION_NAME
            , ELTR_LN_TP_CD
            , DIVISION_NAME';

    OPEN O_RC1 FOR V_SQL;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0104_GET_CAPA_LINE_ASSIGN_ASSEMBLY;


/****************************************************************************************************/
/* Program ID  : P_SCP0104_GET_CAPA_LINE_ASSIGN_ELTR                                                */
/* Description : CAPA LINE ASSIGN — 전극                                                            */
/*               ★날짜 칸 수가 조회 기준 월에 따라 달라지므로 최종 조회만 동적으로 만든다           */
/*                 — CNS 규칙의 「피벗처럼 불가피한 동적 컬럼」 예외                                */
/* Program History : 2026.10.06   AJS   조회 속도 개선 : 라인 배정 조회의 사업부 이름 함수 호출 캐시 · 전극 품목 약칭을 배정 원장 품목으로 한정(결과 동일) */
/****************************************************************************************************/
PROCEDURE P_SCP0104_GET_CAPA_LINE_ASSIGN_ELTR
(
    P_VERSION           IN  CLOB
  , P_VERSION_SEQ       IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_SITE_ID           IN  CLOB
  , P_PLANT_ID          IN  CLOB
  , P_FACTORY_ID        IN  CLOB
  , P_LINE_ID           IN  CLOB
  , P_OPERATION_ID      IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_ELECTRODE_TYPE    IN  CLOB
  , P_VALID_FLAG        IN  CLOB
  , P_PROGRAM_ID        IN  CLOB
  , P_SHEET_NAME        IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_DEBUG_MODE        IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    V_VERSION           VARCHAR2(40 CHAR)   := TO_CHAR(SUBSTR(P_VERSION,        1, 40));
    N_VERSION_SEQ       NUMBER(3)           := TO_NUMBER(TO_CHAR(SUBSTR(P_VERSION_SEQ, 1, 3)));
    V_DIVISION_ID       VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID,    1, 4000));
    V_SITE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_SITE_ID,        1, 4000));
    V_PLANT_ID          VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_PLANT_ID,       1, 4000));
    V_FACTORY_ID        VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_FACTORY_ID,     1, 4000));
    V_LINE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_LINE_ID,        1, 4000));
    V_OPERATION_ID      VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_OPERATION_ID,   1, 4000));
    V_ITEM_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID,        1, 4000));
    V_ELECTRODE_TYPE    VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_ELECTRODE_TYPE, 1, 4000));
    /* AS-IS 사용여부 인자는 한 글자라 'ALL' 이 'A' 로 잘린다 — 값 비교는 한 글자, 조회조건 ALL 판정만 자르지 않은 값으로 */
    V_VALID_FLAG        VARCHAR2(1 CHAR)    := TO_CHAR(SUBSTR(P_VALID_FLAG,     1, 1));
    V_VALID_FLAG_ALL    VARCHAR2(10 CHAR)   := TO_CHAR(SUBSTR(P_VALID_FLAG,     1, 10));
    V_PROGRAM_ID        VARCHAR2(100 CHAR)  := TO_CHAR(SUBSTR(P_PROGRAM_ID,     1, 100));
    V_SHEET_NAME        VARCHAR2(100 CHAR)  := TO_CHAR(SUBSTR(P_SHEET_NAME,     1, 100));

    V_FROM_YYYY         VARCHAR2(4 CHAR)    := SUBSTR(TO_CHAR(SUBSTR(P_VERSION, 1, 40)), 1, 4);
    /* 날짜 칸은 버전의 다음 달부터 만든다 — 원문과 같게 */
    V_FROM_YYYYMM       VARCHAR2(6 CHAR)    := TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(SUBSTR(P_VERSION, 1, 6)) || '01', 'YYYYMMDD'), 1), 'YYYYMM');
    V_TO_YYYY           VARCHAR2(4 CHAR);
    V_PROG_STAT         VARCHAR2(8 CHAR);

    V_DATE_COLS         CLOB := EMPTY_CLOB();
    V_FINAL_COLS        CLOB := EMPTY_CLOB();
    V_SQL               CLOB;

BEGIN

    /* 날짜 칸 목록 · 조회 마지막 연도 */
    SELECT MAX(A.SMALL_CLASS_LABEL_NAME)
      INTO V_TO_YYYY
      FROM TABLE(FN_SCP0104_GET_SPREAD_TITLE(V_FROM_YYYYMM, V_PROGRAM_ID, V_SHEET_NAME)) A;

    FOR R IN (SELECT A.COLUMN_NAME
                FROM TABLE(FN_SCP0104_GET_SPREAD_TITLE(V_FROM_YYYYMM, V_PROGRAM_ID, V_SHEET_NAME)) A
               ORDER BY A.SORT_ORDER_NO)
    LOOP

        IF INSTR(R.COLUMN_NAME, 'M_') = 1
        THEN
            V_DATE_COLS := V_DATE_COLS || '
     , CAST(CASE WHEN YYYYMM = SUBSTR(''' || R.COLUMN_NAME || ''', 5, 6) THEN ASSIGN_PRIORITY END AS NUMBER(4)) AS ' || R.COLUMN_NAME;
        ELSIF INSTR(R.COLUMN_NAME, 'Y_') = 1
        THEN
            V_DATE_COLS := V_DATE_COLS || '
     , CAST(CASE WHEN YYYYMM = SUBSTR(''' || R.COLUMN_NAME || ''', 3, 4) THEN ASSIGN_PRIORITY END AS NUMBER(4)) AS ' || R.COLUMN_NAME;
        END IF;

        V_FINAL_COLS := V_FINAL_COLS || '
     , SUM(' || R.COLUMN_NAME || ') AS ' || R.COLUMN_NAME;

    END LOOP;

    /* 선택된 버전 상태에 따라 현재분과 마감분 중 하나를 읽는다 */
    BEGIN
        SELECT PROG_STAT
          INTO V_PROG_STAT
          FROM SCP_MST_CAPA_VERSION
         WHERE DIVISION_ID = V_DIVISION_ID
           AND VER_ID      = V_VERSION
           AND VER_SEQ     = N_VERSION_SEQ;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            V_PROG_STAT := '';
    END;

    /* 세션 유지 임시 테이블은 시작할 때 비운다 */
    DELETE
      FROM GT_SCP0104_ASSIGN_RAW;

    IF V_PROG_STAT = '0' OR V_PROG_STAT = '-'    /* CURRENT, Pre */
    THEN

        INSERT INTO GT_SCP0104_ASSIGN_RAW
                    ( VER_ID
                    , VER_SEQ
                    , DIVISION_ID
                    , COMPANY_ID
                    , SITE_ID
                    , PLANT_ID
                    , FACTORY_ID
                    , LINE_ID
                    , OPERATION_ID
                    , ELTR_LN_TP_CD
                    , ITEM_ID
                    , NICK_NAME
                    , YYYYMM
                    , LANE_QTY
                    , ASSIGN_PRIORITY
                    , DIVISION_NAME
                    , SITE_NAME
                    , COMPANY_NAME
                    , PLANT_NAME
                    , FACTORY_NAME
                    , LINE_NAME
                    , DUMMY_YN
                    , VALID_YN
                    , PROG_STAT
                    , OPERATION_NAME
                    , EQUIPMENT_ID
                    , EQUIPMENT_NAME )
             SELECT V_VERSION
                  , N_VERSION_SEQ
                  , A.DIVISION_ID
                  , A.COMPANY_ID
                  , A.SITE_ID
                  , A.PLANT_ID
                  , A.FACTORY_ID
                  , A.LINE_ID
                  , A.OPERATION_ID
                  , A.ELTR_LN_TP_CD
                  , A.ITEM_ID
                  , IK.NICK_NAME
                  , A.YYYYMM
                  , CASE WHEN A.LANE_QTY IS NULL THEN IN2.LANE_QTY
                         ELSE A.LANE_QTY END
                  , CASE WHEN A.ASSIGN_PRIORITY = 0 THEN NULL
                         ELSE A.ASSIGN_PRIORITY END               /* 우선순위가 없으면 클리어 */
--                  , FN_GET_DIVISION_NAME(A.DIVISION_ID)   --  2026.10.06 AJS
                  , (SELECT FN_GET_DIVISION_NAME(A.DIVISION_ID) FROM DUAL)   --  2026.10.06 AJS
                  , IA.SITE_NAME
                  , IB.COMPANY_NAME
                  , IC.PLANT_NAME
                  , ID.FACTORY_NAME
                  , IE.LINE_NAME
                  , A.DUMMY_YN
                  , A.VALID_YN
                  , '0'
                  , IG.OPERATION_NAME
                  , IQ.EQUIPMENT_ID
                  , IQ.EQUIPMENT_NAME
               FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN A
                  , (SELECT SITE_ID
                          , SITE_NAME
                       FROM SCP_MST_CAPA_ELTR_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY SITE_ID
                             , SITE_NAME) IA
                  , (SELECT COMPANY_ID
                          , COMPANY_NAME
                       FROM SCP_MST_CAPA_ELTR_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY COMPANY_ID
                             , COMPANY_NAME) IB
                  , (SELECT PLANT_ID
                          , PLANT_NAME
                       FROM SCP_MST_CAPA_ELTR_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY PLANT_ID
                             , PLANT_NAME) IC
                  , (SELECT FACTORY_ID
                          , FACTORY_NAME
                       FROM SCP_MST_CAPA_ELTR_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY FACTORY_ID
                             , FACTORY_NAME) ID
                  , (SELECT LINE_ID
                          , LINE_NAME
                       FROM SCP_MST_CAPA_ELTR_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY LINE_ID
                             , LINE_NAME) IE
                  , (SELECT XA.OPERATION_ID
                          , XA.OPERATION_NAME
                       FROM (SELECT XB.OPERATION_ID
                                  , MAX(XB.OPERATION_NAME)   AS OPERATION_NAME
                               FROM SCM_MST_OPERATION_SN XB
                              GROUP BY XB.OPERATION_ID
                             UNION ALL
                             SELECT XD.SEGMENT1              AS CODE
                                  , XD.ATTRIBUTE1            AS NAME
                               FROM SCM_ADM_LOOKUP_MASTER XC
                                  , SCM_ADM_LOOKUP_MASTER_DETAIL XD
                              WHERE XD.LOOKUP_TYPE  = XC.LOOKUP_TYPE
                                AND XC.LOOKUP_GROUP = 'SCP'
                                AND XC.LOOKUP_TYPE  = 'CPS_FORMATION_OPERATION'
                                AND XD.VALID_YN     = 'Y'
                              GROUP BY XD.SEGMENT1
                                     , XD.ATTRIBUTE1) XA) IG
                  /* 2025.04.08 Coating은 라인:설비=1:1 , 1:N 아닌 경우 대비 group by/max 처리 */
                  , (SELECT XE.COMPANY_ID
                          , XE.DIVISION_ID
                          , XE.SITE_ID
                          , XE.PLANT_ID
                          , XE.FACTORY_ID
                          , XE.LINE_ID
                          , XE.OPERATION_ID
                          , MAX(XE.EQUIPMENT_ID)           AS EQUIPMENT_ID
                          , MAX(XE.EQUIPMENT_NAME)         AS EQUIPMENT_NAME
                       FROM SCM_MST_EQUIPMENT_SN XE
                      WHERE XE.OPERATION_ID LIKE 'E2000%'      /* 전극 Coating 공정 (현재는 E2000 공정 하나만 대상) */
                        AND XE.EQUIPMENT_TYPE = 'M'            /* Main 설비 */
                        AND XE.ACTIVE_FLAG    = 'Y'
                      GROUP BY XE.COMPANY_ID
                             , XE.DIVISION_ID
                             , XE.SITE_ID
                             , XE.PLANT_ID
                             , XE.FACTORY_ID
                             , XE.LINE_ID
                             , XE.OPERATION_ID) IQ
                  /* 레인 수 — 적용일이 가장 늦은 값 하나를 라인별로 모은다 */
                  , (SELECT XL.COMPANY_ID
                          , XL.DIVISION_ID
                          , XL.SITE_ID
                          , XM.PLANT_ID
                          , XL.FACTORY_ID
                          , XM.LINE_ID
                          , XL.OPERATION_ID
                          , XL.ITEM_ID
                          , MAX(XL.VALUE)                  AS LANE_QTY
                       FROM (SELECT XN.COMPANY_ID
                                  , XN.DIVISION_ID
                                  , XN.SITE_ID
                                  , XN.PLANT_ID
                                  , XN.FACTORY_ID
                                  , XN.OPERATION_ID
                                  , XN.ITEM_ID
                                  , XN.VALUE
                               FROM (SELECT XO.COMPANY_ID
                                          , XO.DIVISION_ID
                                          , XO.SITE_ID
                                          , XO.PLANT_ID
                                          , XO.FACTORY_ID
                                          , XO.OPERATION      AS OPERATION_ID
                                          , XO.ITEM_ID
                                          , XO.APPLY_DATE
                                          , XO.VALUE
                                          , DENSE_RANK() OVER (PARTITION BY XO.COMPANY_ID, XO.SITE_ID, XO.PLANT_ID
                                                                          , XO.FACTORY_ID, XO.OPERATION, XO.ITEM_ID
                                                                   ORDER BY XO.APPLY_DATE DESC) AS RN
                                       FROM SCM_MST_ITEM_CONV_CALC_SN XO
                                      WHERE XO.OPERATION = 'E2000'
                                        AND XO.CATEGORY  = 'Lane Number') XN
                              WHERE XN.RN = 1) XL
                          , (SELECT XP.COMPANY_ID
                                  , XP.DIVISION_ID
                                  , XP.SITE_ID
                                  , XP.PLANT_ID
                                  , XP.FACTORY_ID
                                  , XP.LINE_ID
                                  , XP.OPERATION_ID
                                  , XQ.ITEM_ID
                               FROM SCM_LINE_M_SN XP
                                  , SCM_ITEM_LANE_M_SN XQ
                              WHERE XQ.COMPANY_ID(+)  = XP.COMPANY_ID
                                AND XQ.DIVISION_ID(+) = XP.DIVISION_ID
                                AND XQ.SITE_ID(+)     = XP.SITE_ID
                                AND XQ.PLANT_ID(+)    = XP.PLANT_ID
                                AND XQ.FACTORY_ID(+)  = XP.FACTORY_ID
                                AND XP.OPERATION_ID   = 'E2000'
                                AND XP.ACTIVE_FLAG    = 'Y'
                              GROUP BY XP.COMPANY_ID
                                     , XP.DIVISION_ID
                                     , XP.SITE_ID
                                     , XP.PLANT_ID
                                     , XP.FACTORY_ID
                                     , XP.LINE_ID
                                     , XP.OPERATION_ID
                                     , XQ.ITEM_ID) XM
                      WHERE XM.COMPANY_ID   = XL.COMPANY_ID
                        AND XM.DIVISION_ID  = XL.DIVISION_ID
                        AND XM.FACTORY_ID   = XL.FACTORY_ID
                        AND XM.SITE_ID      = XL.SITE_ID
                        AND XM.PLANT_ID     = XL.PLANT_ID
                        AND XM.OPERATION_ID = XL.OPERATION_ID
                        AND XM.ITEM_ID      = XL.ITEM_ID
                      GROUP BY XL.COMPANY_ID
                             , XL.DIVISION_ID
                             , XL.SITE_ID
                             , XM.PLANT_ID
                             , XL.FACTORY_ID
                             , XM.LINE_ID
                             , XL.OPERATION_ID
                             , XL.ITEM_ID) IN2
                  -- 2026.10.06 AJS 품목 약칭 — 공용 함수 전체 결과 대신 같은 조회를 배정 원장 품목으로 한정 (결과 동일) (START)
--                  , (SELECT DIVISION_ID
--                          , ITEM_ID
--                          , NICK_NAME
--                       FROM TABLE(FN_SCM0002_GET_CAPA_ITEM_POPUP('', ''))) IK
                  , (SELECT XR.DIVISION_ID
                          , XR.ITEM_ID
                          , MAX(CASE WHEN XT.NICK_NAME IS NULL THEN XR.NICK_NAME
                                     ELSE XT.NICK_NAME END)            AS NICK_NAME
                       FROM SCP_MST_FINAL_ITEM XR
                          , SCM_MST_ITEM_SN    XT
                      WHERE XT.DIVISION_ID = XR.DIVISION_ID
                        AND XT.ITEM_ID     = XR.ITEM_ID
                        AND EXISTS (SELECT 1
                                      FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN XS
                                     WHERE XS.DIVISION_ID = XR.DIVISION_ID
                                       AND XS.ITEM_ID     = XR.ITEM_ID)
                      GROUP BY XR.DIVISION_ID
                             , XR.OPERATION_GROUP
                             , XR.FLOW_ID
                             , XR.ITEM_ID) IK
                  -- 2026.10.06 AJS 품목 약칭 — 공용 함수 전체 결과 대신 같은 조회를 배정 원장 품목으로 한정 (결과 동일) (END)
              WHERE IA.SITE_ID(+)      = A.SITE_ID
                AND IB.COMPANY_ID(+)   = A.COMPANY_ID
                AND IC.PLANT_ID(+)     = A.PLANT_ID
                AND ID.FACTORY_ID(+)   = A.FACTORY_ID
                AND IE.LINE_ID(+)      = A.LINE_ID
                AND IG.OPERATION_ID(+) = A.OPERATION_ID
                AND IQ.DIVISION_ID(+)  = A.DIVISION_ID
                AND IQ.COMPANY_ID(+)   = A.COMPANY_ID
                AND IQ.SITE_ID(+)      = A.SITE_ID
                AND IQ.PLANT_ID(+)     = A.PLANT_ID
                AND IQ.FACTORY_ID(+)   = A.FACTORY_ID
                AND IQ.LINE_ID(+)      = A.LINE_ID
                AND IQ.OPERATION_ID(+) = A.OPERATION_ID
                AND IN2.DIVISION_ID(+) = A.DIVISION_ID
                AND IN2.COMPANY_ID(+)  = A.COMPANY_ID
                AND IN2.SITE_ID(+)     = A.SITE_ID
                AND IN2.PLANT_ID(+)    = A.PLANT_ID
                AND IN2.FACTORY_ID(+)  = A.FACTORY_ID
                AND IN2.LINE_ID(+)     = A.LINE_ID
                AND IN2.OPERATION_ID(+) = A.OPERATION_ID
                AND IN2.ITEM_ID(+)     = A.ITEM_ID
                AND IK.DIVISION_ID(+)  = A.DIVISION_ID
                AND IK.ITEM_ID(+)      = A.ITEM_ID
                AND A.YYYYMM BETWEEN V_FROM_YYYY AND V_TO_YYYY
                AND (TRIM(V_DIVISION_ID) IS NULL
                 OR  UPPER(V_DIVISION_ID) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
                 OR  A.DIVISION_ID IN (SELECT COLUMN_VALUE
                                         FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
                AND (TRIM(V_SITE_ID) IS NULL
                 OR  UPPER(V_SITE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                 OR  A.SITE_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_SITE_ID, ','))))
                AND (TRIM(V_PLANT_ID) IS NULL
                 OR  UPPER(V_PLANT_ID) = 'ALL'                       /* 조회조건 ALL 은 조건 없음 */
                 OR  A.PLANT_ID IN (SELECT COLUMN_VALUE
                                      FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
                AND (TRIM(V_FACTORY_ID) IS NULL
                 OR  UPPER(V_FACTORY_ID) = 'ALL'                     /* 조회조건 ALL 은 조건 없음 */
                 OR  A.FACTORY_ID IN (SELECT COLUMN_VALUE
                                        FROM TABLE(STRING_SPLIT(V_FACTORY_ID, ','))))
                AND (TRIM(V_LINE_ID) IS NULL
                 OR  UPPER(V_LINE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                 OR  A.LINE_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_LINE_ID, ','))))
                AND (TRIM(V_OPERATION_ID) IS NULL
                 OR  UPPER(V_OPERATION_ID) = 'ALL'                   /* 조회조건 ALL 은 조건 없음 */
                 OR  A.OPERATION_ID IN (SELECT COLUMN_VALUE
                                          FROM TABLE(STRING_SPLIT(V_OPERATION_ID, ','))))
                AND (TRIM(V_ELECTRODE_TYPE) IS NULL
                 OR  UPPER(V_ELECTRODE_TYPE) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                 OR  A.ELTR_LN_TP_CD IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(V_ELECTRODE_TYPE, ','))))
                AND (TRIM(V_ITEM_ID) IS NULL
                 OR  UPPER(V_ITEM_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                 OR  UPPER(A.NICK_NAME) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                       FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
                AND (TRIM(V_VALID_FLAG) IS NULL
                 OR  UPPER(V_VALID_FLAG_ALL) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                 OR  A.VALID_YN = V_VALID_FLAG);

    ELSE

        INSERT INTO GT_SCP0104_ASSIGN_RAW
                    ( VER_ID
                    , VER_SEQ
                    , DIVISION_ID
                    , COMPANY_ID
                    , SITE_ID
                    , PLANT_ID
                    , FACTORY_ID
                    , LINE_ID
                    , OPERATION_ID
                    , ELTR_LN_TP_CD
                    , ITEM_ID
                    , NICK_NAME
                    , YYYYMM
                    , LANE_QTY
                    , ASSIGN_PRIORITY
                    , DIVISION_NAME
                    , SITE_NAME
                    , COMPANY_NAME
                    , PLANT_NAME
                    , FACTORY_NAME
                    , LINE_NAME
                    , DUMMY_YN
                    , VALID_YN
                    , PROG_STAT
                    , OPERATION_NAME
                    , EQUIPMENT_ID
                    , EQUIPMENT_NAME )
             SELECT A.VER_ID
                  , A.VER_SEQ
                  , A.DIVISION_ID
                  , A.COMPANY_ID
                  , A.SITE_ID
                  , A.PLANT_ID
                  , A.FACTORY_ID
                  , A.LINE_ID
                  , A.OPERATION_ID
                  , A.ELTR_LN_TP_CD
                  , A.ITEM_ID
                  , IK.NICK_NAME
                  , A.YYYYMM
                  , A.LANE_QTY
                  , CASE WHEN A.ASSIGN_PRIORITY = 0 THEN NULL
                         ELSE A.ASSIGN_PRIORITY END               /* 우선순위가 없으면 클리어 */
--                  , FN_GET_DIVISION_NAME(A.DIVISION_ID)   --  2026.10.06 AJS
                  , (SELECT FN_GET_DIVISION_NAME(A.DIVISION_ID) FROM DUAL)   --  2026.10.06 AJS
                  , IA.SITE_NAME
                  , IB.COMPANY_NAME
                  , IC.PLANT_NAME
                  , ID.FACTORY_NAME
                  , IE.LINE_NAME
                  , A.DUMMY_YN
                  , A.VALID_YN
                  , V.PROG_STAT
                  , IG.OPERATION_NAME
                  , IQ.EQUIPMENT_ID
                  , IQ.EQUIPMENT_NAME
               FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF A
                  , SCP_MST_CAPA_VERSION V
                  , (SELECT SITE_ID
                          , SITE_NAME
                       FROM SCP_MST_CAPA_ELTR_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY SITE_ID
                             , SITE_NAME) IA
                  , (SELECT COMPANY_ID
                          , COMPANY_NAME
                       FROM SCP_MST_CAPA_ELTR_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY COMPANY_ID
                             , COMPANY_NAME) IB
                  , (SELECT PLANT_ID
                          , PLANT_NAME
                       FROM SCP_MST_CAPA_ELTR_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY PLANT_ID
                             , PLANT_NAME) IC
                  , (SELECT FACTORY_ID
                          , FACTORY_NAME
                       FROM SCP_MST_CAPA_ELTR_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY FACTORY_ID
                             , FACTORY_NAME) ID
                  , (SELECT LINE_ID
                          , LINE_NAME
                       FROM SCP_MST_CAPA_ELTR_LINE
                      WHERE VALID_YN = 'Y'
                      GROUP BY LINE_ID
                             , LINE_NAME) IE
                  , (SELECT XA.OPERATION_ID
                          , XA.OPERATION_NAME
                       FROM (SELECT XB.OPERATION_ID
                                  , MAX(XB.OPERATION_NAME)   AS OPERATION_NAME
                               FROM SCM_MST_OPERATION_SN XB
                              GROUP BY XB.OPERATION_ID
                             UNION ALL
                             SELECT XD.SEGMENT1              AS CODE
                                  , XD.ATTRIBUTE1            AS NAME
                               FROM SCM_ADM_LOOKUP_MASTER XC
                                  , SCM_ADM_LOOKUP_MASTER_DETAIL XD
                              WHERE XD.LOOKUP_TYPE  = XC.LOOKUP_TYPE
                                AND XC.LOOKUP_GROUP = 'SCP'
                                AND XC.LOOKUP_TYPE  = 'CPS_FORMATION_OPERATION'
                                AND XD.VALID_YN     = 'Y'
                              GROUP BY XD.SEGMENT1
                                     , XD.ATTRIBUTE1) XA) IG
                  , (SELECT XE.COMPANY_ID
                          , XE.DIVISION_ID
                          , XE.SITE_ID
                          , XE.PLANT_ID
                          , XE.FACTORY_ID
                          , XE.LINE_ID
                          , XE.OPERATION_ID
                          , MAX(XE.EQUIPMENT_ID)           AS EQUIPMENT_ID
                          , MAX(XE.EQUIPMENT_NAME)         AS EQUIPMENT_NAME
                       FROM SCM_MST_EQUIPMENT_SN XE
                      WHERE XE.OPERATION_ID LIKE 'E2000%'
                        AND XE.EQUIPMENT_TYPE = 'M'
                        AND XE.ACTIVE_FLAG    = 'Y'
                      GROUP BY XE.COMPANY_ID
                             , XE.DIVISION_ID
                             , XE.SITE_ID
                             , XE.PLANT_ID
                             , XE.FACTORY_ID
                             , XE.LINE_ID
                             , XE.OPERATION_ID) IQ
                  -- 2026.10.06 AJS 품목 약칭 — 공용 함수 전체 결과 대신 같은 조회를 배정 원장 품목으로 한정 (결과 동일) (START)
--                  , (SELECT DIVISION_ID
--                          , ITEM_ID
--                          , NICK_NAME
--                       FROM TABLE(FN_SCM0002_GET_CAPA_ITEM_POPUP('', ''))) IK
                  , (SELECT XR.DIVISION_ID
                          , XR.ITEM_ID
                          , MAX(CASE WHEN XT.NICK_NAME IS NULL THEN XR.NICK_NAME
                                     ELSE XT.NICK_NAME END)            AS NICK_NAME
                       FROM SCP_MST_FINAL_ITEM XR
                          , SCM_MST_ITEM_SN    XT
                      WHERE XT.DIVISION_ID = XR.DIVISION_ID
                        AND XT.ITEM_ID     = XR.ITEM_ID
                        AND EXISTS (SELECT 1
                                      FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF XS
                                     WHERE XS.DIVISION_ID = XR.DIVISION_ID
                                       AND XS.ITEM_ID     = XR.ITEM_ID)
                      GROUP BY XR.DIVISION_ID
                             , XR.OPERATION_GROUP
                             , XR.FLOW_ID
                             , XR.ITEM_ID) IK
                  -- 2026.10.06 AJS 품목 약칭 — 공용 함수 전체 결과 대신 같은 조회를 배정 원장 품목으로 한정 (결과 동일) (END)
              WHERE V.DIVISION_ID(+)   = A.DIVISION_ID
                AND V.VER_ID(+)        = A.VER_ID
                AND V.VER_SEQ(+)       = A.VER_SEQ
                AND IA.SITE_ID(+)      = A.SITE_ID
                AND IB.COMPANY_ID(+)   = A.COMPANY_ID
                AND IC.PLANT_ID(+)     = A.PLANT_ID
                AND ID.FACTORY_ID(+)   = A.FACTORY_ID
                AND IE.LINE_ID(+)      = A.LINE_ID
                AND IG.OPERATION_ID(+) = A.OPERATION_ID
                AND IQ.DIVISION_ID(+)  = A.DIVISION_ID
                AND IQ.COMPANY_ID(+)   = A.COMPANY_ID
                AND IQ.SITE_ID(+)      = A.SITE_ID
                AND IQ.PLANT_ID(+)     = A.PLANT_ID
                AND IQ.FACTORY_ID(+)   = A.FACTORY_ID
                AND IQ.LINE_ID(+)      = A.LINE_ID
                AND IQ.OPERATION_ID(+) = A.OPERATION_ID
                AND IK.DIVISION_ID(+)  = A.DIVISION_ID
                AND IK.ITEM_ID(+)      = A.ITEM_ID
                AND A.VER_ID           = V_VERSION
                AND A.VER_SEQ          = N_VERSION_SEQ
                AND A.YYYYMM BETWEEN V_FROM_YYYY AND V_TO_YYYY
                AND (TRIM(V_DIVISION_ID) IS NULL
                 OR  UPPER(V_DIVISION_ID) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
                 OR  A.DIVISION_ID IN (SELECT COLUMN_VALUE
                                         FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
                AND (TRIM(V_SITE_ID) IS NULL
                 OR  UPPER(V_SITE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                 OR  A.SITE_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_SITE_ID, ','))))
                AND (TRIM(V_PLANT_ID) IS NULL
                 OR  UPPER(V_PLANT_ID) = 'ALL'                       /* 조회조건 ALL 은 조건 없음 */
                 OR  A.PLANT_ID IN (SELECT COLUMN_VALUE
                                      FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
                AND (TRIM(V_FACTORY_ID) IS NULL
                 OR  UPPER(V_FACTORY_ID) = 'ALL'                     /* 조회조건 ALL 은 조건 없음 */
                 OR  A.FACTORY_ID IN (SELECT COLUMN_VALUE
                                        FROM TABLE(STRING_SPLIT(V_FACTORY_ID, ','))))
                AND (TRIM(V_LINE_ID) IS NULL
                 OR  UPPER(V_LINE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                 OR  A.LINE_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_LINE_ID, ','))))
                AND (TRIM(V_OPERATION_ID) IS NULL
                 OR  UPPER(V_OPERATION_ID) = 'ALL'                   /* 조회조건 ALL 은 조건 없음 */
                 OR  A.OPERATION_ID IN (SELECT COLUMN_VALUE
                                          FROM TABLE(STRING_SPLIT(V_OPERATION_ID, ','))))
                AND (TRIM(V_ELECTRODE_TYPE) IS NULL
                 OR  UPPER(V_ELECTRODE_TYPE) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                 OR  A.ELTR_LN_TP_CD IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(V_ELECTRODE_TYPE, ','))))
                AND (TRIM(V_ITEM_ID) IS NULL
                 OR  UPPER(V_ITEM_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                 OR  UPPER(A.NICK_NAME) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                       FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
                AND (TRIM(V_VALID_FLAG) IS NULL
                 OR  UPPER(V_VALID_FLAG_ALL) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                 OR  A.VALID_YN = V_VALID_FLAG);

    END IF;

    /* 최종 조회 — 날짜 칸은 조회 기준 월에 따라 개수가 달라져 문장을 만들어 연다 */
    V_SQL := '
    SELECT VER_ID
         , VER_SEQ
         , DIVISION_ID
         , COMPANY_ID
         , SITE_ID
         , PLANT_ID
         , FACTORY_ID
         , LINE_ID
         , OPERATION_ID
         , ELTR_LN_TP_CD
         , ITEM_ID
         , NICK_NAME
         , MAX(DIVISION_NAME)   AS DIVISION_NAME
         , MAX(SITE_NAME)       AS SITE_NAME
         , MAX(COMPANY_NAME)    AS COMPANY_NAME
         , MAX(PLANT_NAME)      AS PLANT_NAME
         , MAX(FACTORY_NAME)    AS FACTORY_NAME
         , MAX(LINE_NAME)       AS LINE_NAME
         , MAX(OPERATION_NAME)  AS OPERATION_NAME
         , EQUIPMENT_ID
         , MAX(EQUIPMENT_NAME)  AS EQUIPMENT_NAME
         , MAX(LANE_QTY)        AS LANE_QTY
         , MAX(DUMMY_YN)        AS DUMMY_YN
         , MAX(VALID_YN)        AS VALID_YN' || V_FINAL_COLS || '
      FROM (SELECT VER_ID
                 , VER_SEQ
                 , DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , ITEM_ID
                 , NICK_NAME
                 , LANE_QTY
                 , DIVISION_NAME
                 , SITE_NAME
                 , COMPANY_NAME
                 , PLANT_NAME
                 , FACTORY_NAME
                 , LINE_NAME
                 , OPERATION_NAME
                 , EQUIPMENT_ID
                 , EQUIPMENT_NAME
                 , DUMMY_YN
                 , VALID_YN' || V_DATE_COLS || '
              FROM GT_SCP0104_ASSIGN_RAW)
     GROUP BY VER_ID
            , VER_SEQ
            , DIVISION_ID
            , COMPANY_ID
            , SITE_ID
            , PLANT_ID
            , FACTORY_ID
            , LINE_ID
            , ITEM_ID
            , NICK_NAME
            , OPERATION_ID
            , ELTR_LN_TP_CD
            , EQUIPMENT_ID
     ORDER BY VER_ID
            , VER_SEQ
            , DIVISION_ID
            , COMPANY_ID
            , SITE_ID
            , SITE_NAME
            , COMPANY_NAME
            , PLANT_ID
            , PLANT_NAME
            , FACTORY_ID
            , FACTORY_NAME
            , LINE_ID
            , LINE_NAME
            , ELTR_LN_TP_CD
            , ITEM_ID
            , NICK_NAME
            , OPERATION_ID
            , OPERATION_NAME
            , DIVISION_NAME
            , EQUIPMENT_ID
            , EQUIPMENT_NAME';

    OPEN O_RC1 FOR V_SQL;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0104_GET_CAPA_LINE_ASSIGN_ELTR;


/****************************************************************************************************/
/* Program ID  : P_SCP0104_SAVE_CAPA_LINE_SOP_ASSEMBLY                                              */
/* Description : CAPA LINE SOP 저장 — 조립                                                          */
/****************************************************************************************************/
PROCEDURE P_SCP0104_SAVE_CAPA_LINE_SOP_ASSEMBLY
(
    P_VERSION           IN  CLOB
  , P_VERSION_SEQ       IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_COMPANY_ID        IN  CLOB
  , P_SITE_ID           IN  CLOB
  , P_PLANT_ID          IN  CLOB
  , P_FACTORY_ID        IN  CLOB
  , P_LINE_ID           IN  CLOB
  , P_OPERATION_ID      IN  CLOB
  , P_ELECTRODE_TYPE    IN  CLOB
  , P_VALID_YN          IN  CLOB
  , P_SOP_DT            IN  CLOB
  , P_PROGRAM_ID        IN  CLOB
  , P_SHEET_NAME        IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_DEBUG_MODE        IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    C_DELIMITER         CONSTANT VARCHAR2(1 CHAR) := '^';

    V_VERSION           VARCHAR2(10 CHAR)   := TO_CHAR(SUBSTR(P_VERSION, 1, 10));
    N_VERSION_SEQ       NUMBER(3)           := TO_NUMBER(TO_CHAR(SUBSTR(P_VERSION_SEQ, 1, 3)));
    V_USER_ID           VARCHAR2(30 CHAR)   := TO_CHAR(SUBSTR(P_USER_ID, 1, 30));

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME      VARCHAR2(150 CHAR)  := 'SCP0104_SAVE_CAPA_LINE_SOP_ASSEMBLY';
    V_LOG_TYPE          VARCHAR2(30 CHAR);
    N_LOG_COUNT         NUMBER(10) := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    D_EVENT_DATE        DATE;

    N_ALL_CNT           NUMBER(10) := 0;
    N_UPDATED_CNT       NUMBER(10) := 0;

    V_SQLCODE           NUMBER;
    V_SQLERRM           VARCHAR2(4000 CHAR);

BEGIN

    SAVEPOINT SP_SCP0104_SAVE_SOP;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    /* 세션 유지 임시 테이블은 시작할 때 비운다 */
    DELETE
      FROM GT_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP;

    DELETE
      FROM GT_SCP0104_SCP_MST_CAPA_LINE_SOP;

    DELETE
      FROM GT_SCP0104_SCP_MST_CAPA_LOSS;

    /* String_Split 함수 속도이슈로 임시 테이블로 저장함
       — 인자를 구분자로 나눠 순번으로 맞춘다 */
    INSERT INTO GT_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , VALID_YN
                , SOP_DT
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
         SELECT V_VERSION
              , N_VERSION_SEQ
              , IA.TOKEN
              , IB.TOKEN
              , IC.TOKEN
              , ID.TOKEN
              , IE.TOKEN
              , IG.TOKEN
              , IH.TOKEN
              , II.TOKEN
              , IJ.TOKEN
              , IK.TOKEN
              , V_USER_ID
              , SYSDATE
              , V_USER_ID
              , SYSDATE
           FROM (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_DIVISION_ID),    C_DELIMITER))) IA
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_COMPANY_ID),     C_DELIMITER))) IB
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_SITE_ID),        C_DELIMITER))) IC
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_PLANT_ID),       C_DELIMITER))) ID
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_FACTORY_ID),     C_DELIMITER))) IE
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_LINE_ID),        C_DELIMITER))) IG
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_OPERATION_ID),   C_DELIMITER))) IH
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_ELECTRODE_TYPE), C_DELIMITER))) II
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_VALID_YN),       C_DELIMITER))) IJ
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_SOP_DT),         C_DELIMITER))) IK
          WHERE IB.NR = IA.NR
            AND IC.NR = IA.NR
            AND ID.NR = IA.NR
            AND IE.NR = IA.NR
            AND IG.NR = IA.NR
            AND IH.NR = IA.NR
            AND II.NR = IA.NR
            AND IJ.NR = IA.NR
            AND IK.NR = IA.NR;

    /* 계산 칸을 더해 옮긴다 */
    INSERT INTO GT_SCP0104_SCP_MST_CAPA_LINE_SOP
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , VALID_YN
                , SOP_DT
                , SOP_YM
                , SOP_YEAR
                , SOP_DDN
                , BASE_DDN
                , SOP_DDN_YEAR
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
         SELECT VER_ID
              , VER_SEQ
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , VALID_YN
              , SOP_DT
              , SUBSTR(SOP_DT, 1, 6)                                            AS SOP_YM
              , SUBSTR(SOP_DT, 1, 4)                                            AS SOP_YEAR
              , CASE WHEN LENGTH(RTRIM(SOP_DT)) = 8
                     THEN TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(SUBSTR(SOP_DT, 1, 6) || '01', 'YYYYMMDD')), 'DD'))
                          - TO_NUMBER(SUBSTR(SOP_DT, 7, 2)) + 1
                     ELSE NULL END                                              AS SOP_DDN
              , TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(V_VERSION || '01', 'YYYYMMDD')), 'DD'))
                    - TO_NUMBER(TO_CHAR(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), 'DD')) + 1   AS BASE_DDN
              /* 2026.10.28 AJS 양산시점 빈 값 ORA-01840 (START) */
              , CASE WHEN LENGTH(RTRIM(SOP_DT)) = 8
                     THEN TO_DATE(SUBSTR(SOP_DT, 1, 4) || '1231', 'YYYYMMDD')
                          - TO_DATE(SOP_DT, 'YYYYMMDD') + 1
                     ELSE NULL END                                              AS SOP_DDN_YEAR
              /* 2026.10.28 AJS 양산시점 빈 값 ORA-01840 (END) */
              , CREATED_BY
              , CREATION_DATE
              , LAST_UPDATED_BY
              , LAST_UPDATE_DATE
           FROM GT_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP
          WHERE TRIM(DIVISION_ID)   IS NOT NULL
            AND TRIM(COMPANY_ID)    IS NOT NULL
            AND TRIM(SITE_ID)       IS NOT NULL
            AND TRIM(PLANT_ID)      IS NOT NULL
            AND TRIM(FACTORY_ID)    IS NOT NULL
            AND TRIM(LINE_ID)       IS NOT NULL
            AND TRIM(OPERATION_ID)  IS NOT NULL
            AND TRIM(ELTR_LN_TP_CD) IS NOT NULL;

    SELECT COUNT(*)
      INTO N_ALL_CNT
      FROM GT_SCP0104_SCP_MST_CAPA_LINE_SOP;

    /* SAVE - SCP_MST_CAPA_LINE_SOP - BEGIN
       원문은 MERGE 한 문장이나 온라인 SQL 에서 쓰지 않는 규칙이라 두 문장으로 나눈다 */
    FOR R IN (SELECT DIVISION_ID
                   , COMPANY_ID
                   , SITE_ID
                   , PLANT_ID
                   , FACTORY_ID
                   , LINE_ID
                   , OPERATION_ID
                   , ELTR_LN_TP_CD
                   , VALID_YN
                   , SOP_DT
                   , SOP_YM
                   , SOP_DDN
                FROM GT_SCP0104_SCP_MST_CAPA_LINE_SOP)
    LOOP

        UPDATE SCP_MST_CAPA_LINE_SOP
           SET VALID_YN         = R.VALID_YN
             , SOP_DT           = R.SOP_DT
             , SOP_YM           = R.SOP_YM
             , SOP_DDN          = R.SOP_DDN
             , LAST_UPDATED_BY  = V_USER_ID
             , LAST_UPDATE_DATE = SYSDATE
         WHERE DIVISION_ID   = R.DIVISION_ID
           AND COMPANY_ID    = R.COMPANY_ID
           AND SITE_ID       = R.SITE_ID
           AND PLANT_ID      = R.PLANT_ID
           AND FACTORY_ID    = R.FACTORY_ID
           AND LINE_ID       = R.LINE_ID
           AND OPERATION_ID  = R.OPERATION_ID
           AND ELTR_LN_TP_CD = R.ELTR_LN_TP_CD;

        IF SQL%ROWCOUNT = 0
        THEN

            INSERT INTO SCP_MST_CAPA_LINE_SOP
                        ( DIVISION_ID
                        , COMPANY_ID
                        , SITE_ID
                        , PLANT_ID
                        , FACTORY_ID
                        , LINE_ID
                        , OPERATION_ID
                        , ELTR_LN_TP_CD
                        , VALID_YN
                        , SOP_DT
                        , SOP_YM
                        , SOP_DDN
                        , CREATED_BY
                        , CREATION_DATE
                        , LAST_UPDATED_BY
                        , LAST_UPDATE_DATE )
                 VALUES ( R.DIVISION_ID
                        , R.COMPANY_ID
                        , R.SITE_ID
                        , R.PLANT_ID
                        , R.FACTORY_ID
                        , R.LINE_ID
                        , R.OPERATION_ID
                        , R.ELTR_LN_TP_CD
                        , R.VALID_YN
                        , R.SOP_DT
                        , R.SOP_YM
                        , R.SOP_DDN
                        , V_USER_ID
                        , SYSDATE
                        , V_USER_ID
                        , SYSDATE );

        END IF;

    END LOOP;
    /* SAVE - SCP_MST_CAPA_LINE_SOP - END */

    SELECT COUNT(*)
      INTO N_UPDATED_CNT
      FROM GT_SCP0104_SCP_MST_CAPA_LINE_SOP;

    IF N_UPDATED_CNT > 0
    THEN

        /* 손실 계획 계산 — 원문 WITH 묶음을 인라인 뷰로 옮긴다 */
        INSERT INTO GT_SCP0104_SCP_MST_CAPA_LOSS
                    ( DIVISION_ID
                    , PLANT_ID
                    , LINE_ID
                    , OPERATION_ID
                    , ELTR_LN_TP_CD
                    , MDL_NM
                    , COMPANY_ID
                    , SITE_ID
                    , FACTORY_ID
                    , MSR_TP_CD
                    , YYYYMM
                    , PFRSLT_NVL
                    , BASE_NVL
                    , MSR_GR_CD
                    , MSR_NVL
                    , CREATED_BY
                    , CREATION_DATE
                    , LAST_UPDATED_BY
                    , LAST_UPDATE_DATE )
             SELECT SA.DIVISION_ID
                  , SA.PLANT_ID
                  , SA.LINE_ID
                  , SA.OPERATION_ID
                  , SA.ELTR_LN_TP_CD
                  , SA.MDL_NM
                  , SA.COMPANY_ID
                  , SA.SITE_ID
                  , SA.FACTORY_ID
                  , SA.MSR_TP_CD
                  , SA.YYYYMM
                  , SA.PFRSLT_NVL
                  , CASE WHEN SA.MSR_TP_CD = 'THRY_CAPA_D' THEN SA.BASE_THRY_CAPA_D
                         WHEN SA.MSR_TP_CD = 'PROD_CAPA_D' THEN ROUND(SA.BASE_THRY_CAPA_D * SA.TEMP_BASE_PROD_CAPA_D, 6)
                         WHEN SA.MSR_TP_CD = 'PROD_CAPA_M' THEN ROUND(SA.BASE_THRY_CAPA_D * SA.TEMP_BASE_PROD_CAPA_D * SA.BASE_DDN, 6)
                    END                                                     AS BASE_NVL
                  , SA.MSR_GR_CD
                  , CASE WHEN SA.MSR_TP_CD = 'THRY_CAPA_D' THEN SA.THRY_CAPA_D
                         WHEN SA.MSR_TP_CD = 'PROD_CAPA_D' THEN ROUND(SA.THRY_CAPA_D * SA.TEMP_PROD_CAPA_D, 6)
                         WHEN SA.MSR_TP_CD = 'PROD_CAPA_M' THEN ROUND(SA.THRY_CAPA_D * SA.TEMP_PROD_CAPA_D * SA.SOP_DDN, 6)
                    END                                                     AS MSR_NVL
                  , SA.CREATED_BY
                  , SA.CREATION_DATE
                  , V_USER_ID
                  , SYSDATE
               FROM (SELECT A.DIVISION_ID
                          , A.PLANT_ID
                          , A.LINE_ID
                          , A.OPERATION_ID
                          , A.ELTR_LN_TP_CD
                          , A.MDL_NM
                          , A.COMPANY_ID
                          , A.SITE_ID
                          , A.FACTORY_ID
                          , A.MSR_TP_CD
                          , A.YYYYMM
                          , A.PFRSLT_NVL
                          , A.MSR_GR_CD
                          , A.CREATED_BY
                          , A.CREATION_DATE
                          /* 연도별이면 연 단위, 월별이면 월 단위로 일수를 고른다 */
                          , CASE WHEN LENGTH(RTRIM(A.YYYYMM)) = 4
                                 THEN CASE WHEN XC.DIVISION_ID IS NOT NULL THEN XC.SOP_DDN_YEAR
                                           ELSE TO_DATE(SUBSTR(A.YYYYMM, 1, 4) || '1231', 'YYYYMMDD')
                                                - TO_DATE(SUBSTR(A.YYYYMM, 1, 4) || '0101', 'YYYYMMDD') + 1
                                      END
                                 ELSE CASE WHEN XB.DIVISION_ID IS NOT NULL THEN XB.SOP_DDN
                                           ELSE TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(A.YYYYMM || '01', 'YYYYMMDD')), 'DD'))
                                      END
                            END                                             AS SOP_DDN
                          , CASE WHEN LENGTH(RTRIM(A.YYYYMM)) = 4
                                 THEN CASE WHEN XC.DIVISION_ID IS NOT NULL THEN XC.BASE_DDN
                                           ELSE TO_DATE(SUBSTR(V_VERSION, 1, 4) || '1231', 'YYYYMMDD')
                                                - TO_DATE(SUBSTR(V_VERSION, 1, 4) || '0101', 'YYYYMMDD') + 1
                                      END
                                 ELSE CASE WHEN XB.DIVISION_ID IS NOT NULL THEN XB.BASE_DDN
                                           ELSE TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(V_VERSION || '01', 'YYYYMMDD')), 'DD'))
                                      END
                            END                                             AS BASE_DDN
                          , (XP.BASE_QTY * 1440.0)                          AS BASE_THRY_CAPA_D
                          , (XP.QTY * 1440.0)                               AS THRY_CAPA_D
                          /* AS-IS 는 십진 곱 결과를 소수 6자리로 반올림한다(NUMERIC 자리 규칙) */
                          , ROUND(XL.BASE_NVL * XO.BASE_NVL * XF.BASE_NVL * XQ.BASE_NVL, 6)  AS TEMP_BASE_PROD_CAPA_D
                          , ROUND(XL.MSR_NVL * XO.MSR_NVL * XF.MSR_NVL * XQ.MSR_NVL, 6)      AS TEMP_PROD_CAPA_D
                       FROM (SELECT XA.*
                               FROM SCP_MST_CAPA_LOSS_PLAN_MDL XA
                                  , (SELECT DIVISION_ID
                                          , COMPANY_ID
                                          , SITE_ID
                                          , PLANT_ID
                                          , FACTORY_ID
                                          , LINE_ID
                                          , OPERATION_ID
                                          , ELTR_LN_TP_CD
                                       FROM GT_SCP0104_SCP_MST_CAPA_LINE_SOP
                                      GROUP BY DIVISION_ID
                                             , COMPANY_ID
                                             , SITE_ID
                                             , PLANT_ID
                                             , FACTORY_ID
                                             , LINE_ID
                                             , OPERATION_ID
                                             , ELTR_LN_TP_CD) XK
                              WHERE XK.DIVISION_ID   = XA.DIVISION_ID
                                AND XK.COMPANY_ID    = XA.COMPANY_ID
                                AND XK.SITE_ID       = XA.SITE_ID
                                AND XK.PLANT_ID      = XA.PLANT_ID
                                AND XK.FACTORY_ID    = XA.FACTORY_ID
                                AND XK.LINE_ID       = XA.LINE_ID
                                AND XK.OPERATION_ID  = XA.OPERATION_ID
                                AND XK.ELTR_LN_TP_CD = XA.ELTR_LN_TP_CD
                                AND XA.MSR_TP_CD IN ('LD_RT', 'OP_RT', 'PF_RT', 'QL_RT'
                                                   , 'THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M')) A
                          , GT_SCP0104_SCP_MST_CAPA_LINE_SOP XB
                          , GT_SCP0104_SCP_MST_CAPA_LINE_SOP XC
                          , (SELECT *
                               FROM SCP_MST_CAPA_SPEED_PLAN
                              WHERE MSR_TP_CD = 'EQP_NBU') XE
                          , (SELECT *
                               FROM SCP_MST_CAPA_SPEED_PLAN
                              WHERE MSR_TP_CD = 'PPM') XP
                          , (SELECT *
                               FROM SCP_MST_CAPA_LOSS_PLAN_MDL
                              WHERE MSR_TP_CD = 'LD_RT') XL
                          , (SELECT *
                               FROM SCP_MST_CAPA_LOSS_PLAN_MDL
                              WHERE MSR_TP_CD = 'OP_RT') XO
                          , (SELECT *
                               FROM SCP_MST_CAPA_LOSS_PLAN_MDL
                              WHERE MSR_TP_CD = 'PF_RT') XF
                          , (SELECT *
                               FROM SCP_MST_CAPA_LOSS_PLAN_MDL
                              WHERE MSR_TP_CD = 'QL_RT') XQ
                      WHERE XB.DIVISION_ID(+)   = A.DIVISION_ID
                        AND XB.COMPANY_ID(+)    = A.COMPANY_ID
                        AND XB.SITE_ID(+)       = A.SITE_ID
                        AND XB.PLANT_ID(+)      = A.PLANT_ID
                        AND XB.FACTORY_ID(+)    = A.FACTORY_ID
                        AND XB.LINE_ID(+)       = A.LINE_ID
                        AND XB.OPERATION_ID(+)  = A.OPERATION_ID
                        AND XB.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
                        AND XB.SOP_YM(+)        = A.YYYYMM
                        AND XC.DIVISION_ID(+)   = A.DIVISION_ID
                        AND XC.COMPANY_ID(+)    = A.COMPANY_ID
                        AND XC.SITE_ID(+)       = A.SITE_ID
                        AND XC.PLANT_ID(+)      = A.PLANT_ID
                        AND XC.FACTORY_ID(+)    = A.FACTORY_ID
                        AND XC.LINE_ID(+)       = A.LINE_ID
                        AND XC.OPERATION_ID(+)  = A.OPERATION_ID
                        AND XC.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
                        AND XC.SOP_YEAR(+)      = A.YYYYMM
                        AND XE.DIVISION_ID(+)   = A.DIVISION_ID
                        AND XE.COMPANY_ID(+)    = A.COMPANY_ID
                        AND XE.SITE_ID(+)       = A.SITE_ID
                        AND XE.PLANT_ID(+)      = A.PLANT_ID
                        AND XE.FACTORY_ID(+)    = A.FACTORY_ID
                        AND XE.LINE_ID(+)       = A.LINE_ID
                        AND XE.OPERATION_ID(+)  = A.OPERATION_ID
                        AND XE.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
                        AND XE.NICK_NAME(+)     = A.MDL_NM
                        AND XE.YYYYMM(+)        = A.YYYYMM
                        AND XP.DIVISION_ID(+)   = A.DIVISION_ID
                        AND XP.COMPANY_ID(+)    = A.COMPANY_ID
                        AND XP.SITE_ID(+)       = A.SITE_ID
                        AND XP.PLANT_ID(+)      = A.PLANT_ID
                        AND XP.FACTORY_ID(+)    = A.FACTORY_ID
                        AND XP.LINE_ID(+)       = A.LINE_ID
                        AND XP.OPERATION_ID(+)  = A.OPERATION_ID
                        AND XP.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
                        AND XP.NICK_NAME(+)     = A.MDL_NM
                        AND XP.YYYYMM(+)        = A.YYYYMM
                        AND XL.DIVISION_ID(+)   = A.DIVISION_ID
                        AND XL.COMPANY_ID(+)    = A.COMPANY_ID
                        AND XL.SITE_ID(+)       = A.SITE_ID
                        AND XL.PLANT_ID(+)      = A.PLANT_ID
                        AND XL.FACTORY_ID(+)    = A.FACTORY_ID
                        AND XL.LINE_ID(+)       = A.LINE_ID
                        AND XL.OPERATION_ID(+)  = A.OPERATION_ID
                        AND XL.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
                        AND XL.MDL_NM(+)        = A.MDL_NM
                        AND XL.YYYYMM(+)        = A.YYYYMM
                        AND XO.DIVISION_ID(+)   = A.DIVISION_ID
                        AND XO.COMPANY_ID(+)    = A.COMPANY_ID
                        AND XO.SITE_ID(+)       = A.SITE_ID
                        AND XO.PLANT_ID(+)      = A.PLANT_ID
                        AND XO.FACTORY_ID(+)    = A.FACTORY_ID
                        AND XO.LINE_ID(+)       = A.LINE_ID
                        AND XO.OPERATION_ID(+)  = A.OPERATION_ID
                        AND XO.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
                        AND XO.MDL_NM(+)        = A.MDL_NM
                        AND XO.YYYYMM(+)        = A.YYYYMM
                        AND XF.DIVISION_ID(+)   = A.DIVISION_ID
                        AND XF.COMPANY_ID(+)    = A.COMPANY_ID
                        AND XF.SITE_ID(+)       = A.SITE_ID
                        AND XF.PLANT_ID(+)      = A.PLANT_ID
                        AND XF.FACTORY_ID(+)    = A.FACTORY_ID
                        AND XF.LINE_ID(+)       = A.LINE_ID
                        AND XF.OPERATION_ID(+)  = A.OPERATION_ID
                        AND XF.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
                        AND XF.MDL_NM(+)        = A.MDL_NM
                        AND XF.YYYYMM(+)        = A.YYYYMM
                        AND XQ.DIVISION_ID(+)   = A.DIVISION_ID
                        AND XQ.COMPANY_ID(+)    = A.COMPANY_ID
                        AND XQ.SITE_ID(+)       = A.SITE_ID
                        AND XQ.PLANT_ID(+)      = A.PLANT_ID
                        AND XQ.FACTORY_ID(+)    = A.FACTORY_ID
                        AND XQ.LINE_ID(+)       = A.LINE_ID
                        AND XQ.OPERATION_ID(+)  = A.OPERATION_ID
                        AND XQ.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
                        AND XQ.MDL_NM(+)        = A.MDL_NM
                        AND XQ.YYYYMM(+)        = A.YYYYMM) SA
              WHERE SA.MSR_TP_CD IN ('THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M');

        /* SAVE - LOSS_PLAN_BY_ASSIGN - BEGIN
           원문은 MERGE 한 문장이나 온라인 SQL 에서 쓰지 않는 규칙이라 고치는 문장만 쓴다
           (원문에 WHEN NOT MATCHED 절이 없어 넣지 않는다) */
        FOR R IN (SELECT DIVISION_ID
                       , COMPANY_ID
                       , SITE_ID
                       , PLANT_ID
                       , FACTORY_ID
                       , LINE_ID
                       , OPERATION_ID
                       , ELTR_LN_TP_CD
                       , MDL_NM
                       , MSR_TP_CD
                       , YYYYMM
                       , MSR_NVL
                    FROM GT_SCP0104_SCP_MST_CAPA_LOSS)
        LOOP

            UPDATE SCP_MST_CAPA_LOSS_PLAN_MDL
               SET MSR_NVL          = R.MSR_NVL
                 , LAST_UPDATED_BY  = V_USER_ID
                 , LAST_UPDATE_DATE = SYSDATE
             WHERE DIVISION_ID   = R.DIVISION_ID
               AND COMPANY_ID    = R.COMPANY_ID
               AND SITE_ID       = R.SITE_ID
               AND PLANT_ID      = R.PLANT_ID
               AND FACTORY_ID    = R.FACTORY_ID
               AND LINE_ID       = R.LINE_ID
               AND OPERATION_ID  = R.OPERATION_ID
               AND ELTR_LN_TP_CD = R.ELTR_LN_TP_CD
               AND MDL_NM        = R.MDL_NM
               AND MSR_TP_CD     = R.MSR_TP_CD
               AND YYYYMM        = R.YYYYMM;

        END LOOP;
        /* SAVE - LOSS_PLAN_BY_ASSIGN - END */

    END IF;

    /* LOG end */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    COMMIT;

    /* 결과코드, 결과 카운트 반환 */
    OPEN O_RC1 FOR
        SELECT 'S'          AS RESULT_CODE
             , N_ALL_CNT    AS RESULT_CNT
          FROM DUAL;

    OPEN O_RESULT_CURSOR FOR
        /* SELECT '0'          AS RESULT_CODE */ /* AJS 20261007 화면검증 */
        SELECT 'S'          AS RESULT_CODE   /* AJS 20261007 화면검증 */
             , 'SUCCESS'    AS RESULT_MESSAGE
             , N_ALL_CNT    AS RESULT_CNT   /* AJS 20261007 화면검증 */
          FROM DUAL;

EXCEPTION
    WHEN OTHERS
    THEN

        V_SQLCODE := SQLCODE;
        V_SQLERRM := SQLERRM;

        ROLLBACK TO SP_SCP0104_SAVE_SOP;    /* 입력 데이타 롤백 처리 */

        INSERT INTO SCM_SYS_LOG_BATCH
                    ( PROGRAM_NAME
                    , LOG_TYPE
                    , LOG_COUNT
                    , LOG_MESSAGE
                    , DESCRIPTION
                    , EVENT_DATE
                    , CREATION_DATE
                    , CREATED_BY
                    , LAST_UPDATE_DATE
                    , LAST_UPDATED_BY )
             VALUES ( V_PROGRAM_NAME
                    , 'ERROR'
                    , NULL
                    , V_SQLERRM
                    , NULL
                    , SYSDATE
                    , SYSDATE
                    , V_PROGRAM_NAME
                    , SYSDATE
                    , V_PROGRAM_NAME );

        COMMIT;

        OPEN O_RC1 FOR
            SELECT 'F'                                              AS RESULT_CODE
                 , '[' || TO_CHAR(V_SQLCODE) || ']' || V_SQLERRM     AS ERR_MESSAGE
              FROM DUAL;

        OPEN O_RESULT_CURSOR FOR
            /* SELECT '[' || TO_CHAR(V_SQLCODE) || ']' || V_SQLERRM     AS ERR_MESSAGE */ /* AJS 20261007 화면검증 */
            SELECT 'F'                                              AS RESULT_CODE   /* AJS 20261007 화면검증 */
                 , '[' || TO_CHAR(V_SQLCODE) || ']' || V_SQLERRM     AS ERR_MESSAGE
              FROM DUAL;

END P_SCP0104_SAVE_CAPA_LINE_SOP_ASSEMBLY;


/****************************************************************************************************/
/* Program ID  : P_SCP0104_SAVE_CAPA_LINE_SOP_ELTR                                              */
/* Description : CAPA LINE SOP 저장 — 전극                                                          */
/****************************************************************************************************/
PROCEDURE P_SCP0104_SAVE_CAPA_LINE_SOP_ELTR
(
    P_VERSION           IN  CLOB
  , P_VERSION_SEQ       IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_COMPANY_ID        IN  CLOB
  , P_SITE_ID           IN  CLOB
  , P_PLANT_ID          IN  CLOB
  , P_FACTORY_ID        IN  CLOB
  , P_LINE_ID           IN  CLOB
  , P_OPERATION_ID      IN  CLOB
  , P_ELECTRODE_TYPE    IN  CLOB
  , P_VALID_YN          IN  CLOB
  , P_SOP_DT            IN  CLOB
  , P_PROGRAM_ID        IN  CLOB
  , P_SHEET_NAME        IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_DEBUG_MODE        IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    C_DELIMITER         CONSTANT VARCHAR2(1 CHAR) := '^';

    V_VERSION           VARCHAR2(10 CHAR)   := TO_CHAR(SUBSTR(P_VERSION, 1, 10));
    N_VERSION_SEQ       NUMBER(3)           := TO_NUMBER(TO_CHAR(SUBSTR(P_VERSION_SEQ, 1, 3)));
    V_USER_ID           VARCHAR2(30 CHAR)   := TO_CHAR(SUBSTR(P_USER_ID, 1, 30));

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME      VARCHAR2(150 CHAR)  := 'SCP0104_SAVE_CAPA_LINE_SOP_ELTR';
    V_LOG_TYPE          VARCHAR2(30 CHAR);
    N_LOG_COUNT         NUMBER(10) := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    D_EVENT_DATE        DATE;

    N_ALL_CNT           NUMBER(10) := 0;
    N_UPDATED_CNT       NUMBER(10) := 0;

    V_SQLCODE           NUMBER;
    V_SQLERRM           VARCHAR2(4000 CHAR);

BEGIN

    SAVEPOINT SP_SCP0104_SAVE_SOP_E;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    /* 세션 유지 임시 테이블은 시작할 때 비운다 */
    DELETE
      FROM GT_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP;

    DELETE
      FROM GT_SCP0104_SCP_MST_CAPA_LINE_SOP;

    DELETE
      FROM GT_SCP0104_SCP_MST_CAPA_LOSS;

    /* String_Split 함수 속도이슈로 임시 테이블로 저장함
       — 인자를 구분자로 나눠 순번으로 맞춘다 */
    INSERT INTO GT_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , VALID_YN
                , SOP_DT
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
         SELECT V_VERSION
              , N_VERSION_SEQ
              , IA.TOKEN
              , IB.TOKEN
              , IC.TOKEN
              , ID.TOKEN
              , IE.TOKEN
              , IG.TOKEN
              , IH.TOKEN
              , II.TOKEN
              , IJ.TOKEN
              , IK.TOKEN
              , V_USER_ID
              , SYSDATE
              , V_USER_ID
              , SYSDATE
           FROM (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_DIVISION_ID),    C_DELIMITER))) IA
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_COMPANY_ID),     C_DELIMITER))) IB
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_SITE_ID),        C_DELIMITER))) IC
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_PLANT_ID),       C_DELIMITER))) ID
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_FACTORY_ID),     C_DELIMITER))) IE
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_LINE_ID),        C_DELIMITER))) IG
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_OPERATION_ID),   C_DELIMITER))) IH
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_ELECTRODE_TYPE), C_DELIMITER))) II
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_VALID_YN),       C_DELIMITER))) IJ
              , (SELECT ROWNUM AS NR, COLUMN_VALUE AS TOKEN
                   FROM TABLE(STRING_SPLIT(TO_CHAR(P_SOP_DT),         C_DELIMITER))) IK
          WHERE IB.NR = IA.NR
            AND IC.NR = IA.NR
            AND ID.NR = IA.NR
            AND IE.NR = IA.NR
            AND IG.NR = IA.NR
            AND IH.NR = IA.NR
            AND II.NR = IA.NR
            AND IJ.NR = IA.NR
            AND IK.NR = IA.NR;

    /* 계산 칸을 더해 옮긴다 */
    INSERT INTO GT_SCP0104_SCP_MST_CAPA_LINE_SOP
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , VALID_YN
                , SOP_DT
                , SOP_YM
                , SOP_YEAR
                , SOP_DDN
                , BASE_DDN
                , SOP_DDN_YEAR
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
         SELECT VER_ID
              , VER_SEQ
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , VALID_YN
              , SOP_DT
              , SUBSTR(SOP_DT, 1, 6)                                            AS SOP_YM
              , SUBSTR(SOP_DT, 1, 4)                                            AS SOP_YEAR
              , CASE WHEN LENGTH(RTRIM(SOP_DT)) = 8
                     THEN TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(SUBSTR(SOP_DT, 1, 6) || '01', 'YYYYMMDD')), 'DD'))
                          - TO_NUMBER(SUBSTR(SOP_DT, 7, 2)) + 1
                     ELSE NULL END                                              AS SOP_DDN
              , TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(V_VERSION || '01', 'YYYYMMDD')), 'DD'))
                    - TO_NUMBER(TO_CHAR(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), 'DD')) + 1   AS BASE_DDN
              /* 2026.10.28 AJS 양산시점 빈 값 ORA-01840 (START) */
              , CASE WHEN LENGTH(RTRIM(SOP_DT)) = 8
                     THEN TO_DATE(SUBSTR(SOP_DT, 1, 4) || '1231', 'YYYYMMDD')
                          - TO_DATE(SOP_DT, 'YYYYMMDD') + 1
                     ELSE NULL END                                              AS SOP_DDN_YEAR
              /* 2026.10.28 AJS 양산시점 빈 값 ORA-01840 (END) */
              , CREATED_BY
              , CREATION_DATE
              , LAST_UPDATED_BY
              , LAST_UPDATE_DATE
           FROM GT_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP
          WHERE TRIM(DIVISION_ID)   IS NOT NULL
            AND TRIM(COMPANY_ID)    IS NOT NULL
            AND TRIM(SITE_ID)       IS NOT NULL
            AND TRIM(PLANT_ID)      IS NOT NULL
            AND TRIM(FACTORY_ID)    IS NOT NULL
            AND TRIM(LINE_ID)       IS NOT NULL
            AND TRIM(OPERATION_ID)  IS NOT NULL
            ;

    SELECT COUNT(*)
      INTO N_ALL_CNT
      FROM GT_SCP0104_SCP_MST_CAPA_LINE_SOP;

    /* SAVE - SCP_MST_CAPA_LINE_SOP - BEGIN
       원문은 MERGE 한 문장이나 온라인 SQL 에서 쓰지 않는 규칙이라 두 문장으로 나눈다 */
    FOR R IN (SELECT DIVISION_ID
                   , COMPANY_ID
                   , SITE_ID
                   , PLANT_ID
                   , FACTORY_ID
                   , LINE_ID
                   , OPERATION_ID
                   , ELTR_LN_TP_CD
                   , VALID_YN
                   , SOP_DT
                   , SOP_YM
                   , SOP_DDN
                FROM GT_SCP0104_SCP_MST_CAPA_LINE_SOP)
    LOOP

        UPDATE SCP_MST_CAPA_ELTR_LINE_SOP
           SET VALID_YN         = R.VALID_YN
             , SOP_DT           = R.SOP_DT
             , SOP_YM           = R.SOP_YM
             , SOP_DDN          = R.SOP_DDN
             , LAST_UPDATED_BY  = V_USER_ID
             , LAST_UPDATE_DATE = SYSDATE
         WHERE DIVISION_ID   = R.DIVISION_ID
           AND COMPANY_ID    = R.COMPANY_ID
           AND SITE_ID       = R.SITE_ID
           AND PLANT_ID      = R.PLANT_ID
           AND FACTORY_ID    = R.FACTORY_ID
           AND LINE_ID       = R.LINE_ID
           AND OPERATION_ID  = R.OPERATION_ID;

        IF SQL%ROWCOUNT = 0
        THEN

            INSERT INTO SCP_MST_CAPA_ELTR_LINE_SOP
                        ( DIVISION_ID
                        , COMPANY_ID
                        , SITE_ID
                        , PLANT_ID
                        , FACTORY_ID
                        , LINE_ID
                        , OPERATION_ID
                        , ELTR_LN_TP_CD
                        , VALID_YN
                        , SOP_DT
                        , SOP_YM
                        , SOP_DDN
                        , CREATED_BY
                        , CREATION_DATE
                        , LAST_UPDATED_BY
                        , LAST_UPDATE_DATE )
                 VALUES ( R.DIVISION_ID
                        , R.COMPANY_ID
                        , R.SITE_ID
                        , R.PLANT_ID
                        , R.FACTORY_ID
                        , R.LINE_ID
                        , R.OPERATION_ID
                        , R.ELTR_LN_TP_CD
                        , R.VALID_YN
                        , R.SOP_DT
                        , R.SOP_YM
                        , R.SOP_DDN
                        , V_USER_ID
                        , SYSDATE
                        , V_USER_ID
                        , SYSDATE );

        END IF;

    END LOOP;
    /* SAVE - SCP_MST_CAPA_LINE_SOP - END */

    SELECT COUNT(*)
      INTO N_UPDATED_CNT
      FROM GT_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP;

    IF N_UPDATED_CNT > 0
    THEN

        /* 손실 계획 계산 — 원문 WITH 묶음을 인라인 뷰로 옮긴다 */
        INSERT INTO GT_SCP0104_SCP_MST_CAPA_LOSS
                    ( DIVISION_ID
                    , PLANT_ID
                    , LINE_ID
                    , OPERATION_ID
                    , ELTR_LN_TP_CD
                    , MDL_NM
                    , COMPANY_ID
                    , SITE_ID
                    , FACTORY_ID
                    , MSR_TP_CD
                    , YYYYMM
                    , PFRSLT_NVL
                    , BASE_NVL
                    , MSR_GR_CD
                    , MSR_NVL
                    , CREATED_BY
                    , CREATION_DATE
                    , LAST_UPDATED_BY
                    , LAST_UPDATE_DATE )
             SELECT SA.DIVISION_ID
                  , SA.PLANT_ID
                  , SA.LINE_ID
                  , SA.OPERATION_ID
                  , SA.ELTR_LN_TP_CD
                  , SA.MDL_NM
                  , SA.COMPANY_ID
                  , SA.SITE_ID
                  , SA.FACTORY_ID
                  , SA.MSR_TP_CD
                  , SA.YYYYMM
                  , SA.PFRSLT_NVL
                  , CASE WHEN SA.MSR_TP_CD = 'THRY_CAPA_D' THEN SA.BASE_THRY_CAPA_D
                         WHEN SA.MSR_TP_CD = 'PROD_CAPA_D' THEN ROUND(SA.BASE_THRY_CAPA_D * SA.TEMP_BASE_PROD_CAPA_D, 6)
                         WHEN SA.MSR_TP_CD = 'PROD_CAPA_M' THEN ROUND(SA.BASE_THRY_CAPA_D * SA.TEMP_BASE_PROD_CAPA_D * SA.BASE_DDN, 6)
                    END                                                     AS BASE_NVL
                  , SA.MSR_GR_CD
                  , CASE WHEN SA.MSR_TP_CD = 'THRY_CAPA_D' THEN SA.THRY_CAPA_D
                         WHEN SA.MSR_TP_CD = 'PROD_CAPA_D' THEN ROUND(SA.THRY_CAPA_D * SA.TEMP_PROD_CAPA_D, 6)
                         WHEN SA.MSR_TP_CD = 'PROD_CAPA_M' THEN ROUND(SA.THRY_CAPA_D * SA.TEMP_PROD_CAPA_D * SA.SOP_DDN, 6)
                    END                                                     AS MSR_NVL
                  , SA.CREATED_BY
                  , SA.CREATION_DATE
                  , V_USER_ID
                  , SYSDATE
               FROM (SELECT A.DIVISION_ID
                          , A.PLANT_ID
                          , A.LINE_ID
                          , A.OPERATION_ID
                          , A.ELTR_LN_TP_CD
                          , A.MDL_NM
                          , A.COMPANY_ID
                          , A.SITE_ID
                          , A.FACTORY_ID
                          , A.MSR_TP_CD
                          , A.YYYYMM
                          , A.PFRSLT_NVL
                          , A.MSR_GR_CD
                          , A.CREATED_BY
                          , A.CREATION_DATE
                          /* 연도별이면 연 단위, 월별이면 월 단위로 일수를 고른다 */
                          /* 전극은 SOP_YM 자리에도 SOP_YEAR 를 쓴다 — 원문 그대로 */
                          , CASE WHEN LENGTH(RTRIM(A.YYYYMM)) = 4
                                 THEN CASE WHEN XC.DIVISION_ID IS NOT NULL THEN XC.SOP_DDN_YEAR
                                           ELSE TO_DATE(SUBSTR(A.YYYYMM, 1, 4) || '1231', 'YYYYMMDD')
                                                - TO_DATE(SUBSTR(A.YYYYMM, 1, 4) || '0101', 'YYYYMMDD') + 1
                                      END
                                 ELSE CASE WHEN XB.DIVISION_ID IS NOT NULL THEN XB.SOP_DDN
                                           ELSE TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(A.YYYYMM || '01', 'YYYYMMDD')), 'DD'))
                                      END
                            END                                             AS SOP_DDN
                          , CASE WHEN LENGTH(RTRIM(A.YYYYMM)) = 4
                                 THEN CASE WHEN XC.DIVISION_ID IS NOT NULL THEN XC.BASE_DDN
                                           ELSE TO_DATE(SUBSTR(V_VERSION, 1, 4) || '1231', 'YYYYMMDD')
                                                - TO_DATE(SUBSTR(V_VERSION, 1, 4) || '0101', 'YYYYMMDD') + 1
                                      END
                                 ELSE CASE WHEN XB.DIVISION_ID IS NOT NULL THEN XB.BASE_DDN
                                           ELSE TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(V_VERSION || '01', 'YYYYMMDD')), 'DD'))
                                      END
                            END                                             AS BASE_DDN
                          , (XP.BASE_QTY * 1440.0 * CASE WHEN A.ELTR_LN_TP_CD = 'W' THEN 2.0 ELSE 1.0 END)   AS BASE_THRY_CAPA_D
                          , (XP.QTY * 1440.0 * CASE WHEN A.ELTR_LN_TP_CD = 'W' THEN 2.0 ELSE 1.0 END)        AS THRY_CAPA_D
                          /* AS-IS 는 십진 곱 결과를 소수 6자리로 반올림한다(NUMERIC 자리 규칙) */
                          , ROUND(XL.BASE_NVL * XO.BASE_NVL * XF.BASE_NVL * XQ.BASE_NVL, 6)  AS TEMP_BASE_PROD_CAPA_D
                          , ROUND(XL.MSR_NVL * XO.MSR_NVL * XF.MSR_NVL * XQ.MSR_NVL, 6)      AS TEMP_PROD_CAPA_D
                       FROM (SELECT XA.*
                               FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL XA
                                  , (SELECT DIVISION_ID
                                          , COMPANY_ID
                                          , SITE_ID
                                          , PLANT_ID
                                          , FACTORY_ID
                                          , LINE_ID
                                          , OPERATION_ID
                                       FROM GT_SCP0104_SCP_MST_CAPA_LINE_SOP
                                      GROUP BY DIVISION_ID
                                             , COMPANY_ID
                                             , SITE_ID
                                             , PLANT_ID
                                             , FACTORY_ID
                                             , LINE_ID
                                             , OPERATION_ID) XK
                              WHERE XK.DIVISION_ID   = XA.DIVISION_ID
                                AND XK.COMPANY_ID    = XA.COMPANY_ID
                                AND XK.SITE_ID       = XA.SITE_ID
                                AND XK.PLANT_ID      = XA.PLANT_ID
                                AND XK.FACTORY_ID    = XA.FACTORY_ID
                                AND XK.LINE_ID       = XA.LINE_ID
                                AND XK.OPERATION_ID  = XA.OPERATION_ID
                                AND XA.MSR_TP_CD IN ('LD_RT', 'OP_RT', 'PF_RT', 'QL_RT'
                                                   , 'THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M')) A
                          , GT_SCP0104_SCP_MST_CAPA_LINE_SOP XB
                          , GT_SCP0104_SCP_MST_CAPA_LINE_SOP XC
                          , (SELECT *
                               FROM SCP_MST_CAPA_ELTR_SPEED_PLAN
                              WHERE MSR_TP_CD = 'EQP_SPED') XP
                          , (SELECT *
                               FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL
                              WHERE MSR_TP_CD = 'LD_RT') XL
                          , (SELECT *
                               FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL
                              WHERE MSR_TP_CD = 'OP_RT') XO
                          , (SELECT *
                               FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL
                              WHERE MSR_TP_CD = 'PF_RT') XF
                          , (SELECT *
                               FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL
                              WHERE MSR_TP_CD = 'QL_RT') XQ
                      WHERE XB.DIVISION_ID(+)   = A.DIVISION_ID
                        AND XB.COMPANY_ID(+)    = A.COMPANY_ID
                        AND XB.SITE_ID(+)       = A.SITE_ID
                        AND XB.PLANT_ID(+)      = A.PLANT_ID
                        AND XB.FACTORY_ID(+)    = A.FACTORY_ID
                        AND XB.LINE_ID(+)       = A.LINE_ID
                        AND XB.OPERATION_ID(+)  = A.OPERATION_ID
                        AND XB.SOP_YM(+)        = A.YYYYMM
                        AND XC.DIVISION_ID(+)   = A.DIVISION_ID
                        AND XC.COMPANY_ID(+)    = A.COMPANY_ID
                        AND XC.SITE_ID(+)       = A.SITE_ID
                        AND XC.PLANT_ID(+)      = A.PLANT_ID
                        AND XC.FACTORY_ID(+)    = A.FACTORY_ID
                        AND XC.LINE_ID(+)       = A.LINE_ID
                        AND XC.OPERATION_ID(+)  = A.OPERATION_ID
                        AND XC.SOP_YEAR(+)      = A.YYYYMM
                        AND XP.DIVISION_ID(+)   = A.DIVISION_ID
                        AND XP.COMPANY_ID(+)    = A.COMPANY_ID
                        AND XP.SITE_ID(+)       = A.SITE_ID
                        AND XP.PLANT_ID(+)      = A.PLANT_ID
                        AND XP.FACTORY_ID(+)    = A.FACTORY_ID
                        AND XP.LINE_ID(+)       = A.LINE_ID
                        AND XP.OPERATION_ID(+)  = A.OPERATION_ID
                        AND XP.ITEM_ID(+)       = A.MDL_NM
                        AND XP.YYYYMM(+)        = A.YYYYMM
                        AND XL.DIVISION_ID(+)   = A.DIVISION_ID
                        AND XL.COMPANY_ID(+)    = A.COMPANY_ID
                        AND XL.SITE_ID(+)       = A.SITE_ID
                        AND XL.PLANT_ID(+)      = A.PLANT_ID
                        AND XL.FACTORY_ID(+)    = A.FACTORY_ID
                        AND XL.LINE_ID(+)       = A.LINE_ID
                        AND XL.OPERATION_ID(+)  = A.OPERATION_ID
                        /* 원문은 전극 갈래에서 모델 조건을 쓰지 않는다 */
                        AND XL.YYYYMM(+)        = A.YYYYMM
                        AND XO.DIVISION_ID(+)   = A.DIVISION_ID
                        AND XO.COMPANY_ID(+)    = A.COMPANY_ID
                        AND XO.SITE_ID(+)       = A.SITE_ID
                        AND XO.PLANT_ID(+)      = A.PLANT_ID
                        AND XO.FACTORY_ID(+)    = A.FACTORY_ID
                        AND XO.LINE_ID(+)       = A.LINE_ID
                        AND XO.OPERATION_ID(+)  = A.OPERATION_ID
                        /* 원문은 전극 갈래에서 모델 조건을 쓰지 않는다 */
                        AND XO.YYYYMM(+)        = A.YYYYMM
                        AND XF.DIVISION_ID(+)   = A.DIVISION_ID
                        AND XF.COMPANY_ID(+)    = A.COMPANY_ID
                        AND XF.SITE_ID(+)       = A.SITE_ID
                        AND XF.PLANT_ID(+)      = A.PLANT_ID
                        AND XF.FACTORY_ID(+)    = A.FACTORY_ID
                        AND XF.LINE_ID(+)       = A.LINE_ID
                        AND XF.OPERATION_ID(+)  = A.OPERATION_ID
                        /* 원문은 전극 갈래에서 모델 조건을 쓰지 않는다 */
                        AND XF.YYYYMM(+)        = A.YYYYMM
                        AND XQ.DIVISION_ID(+)   = A.DIVISION_ID
                        AND XQ.COMPANY_ID(+)    = A.COMPANY_ID
                        AND XQ.SITE_ID(+)       = A.SITE_ID
                        AND XQ.PLANT_ID(+)      = A.PLANT_ID
                        AND XQ.FACTORY_ID(+)    = A.FACTORY_ID
                        AND XQ.LINE_ID(+)       = A.LINE_ID
                        AND XQ.OPERATION_ID(+)  = A.OPERATION_ID
                        /* 원문은 전극 갈래에서 모델 조건을 쓰지 않는다 */
                        AND XQ.YYYYMM(+)        = A.YYYYMM) SA
              WHERE SA.MSR_TP_CD IN ('THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M');

        /* SAVE - LOSS_PLAN_BY_ASSIGN - BEGIN
           원문은 MERGE 한 문장이나 온라인 SQL 에서 쓰지 않는 규칙이라 고치는 문장만 쓴다
           (원문에 WHEN NOT MATCHED 절이 없어 넣지 않는다) */
        FOR R IN (SELECT DIVISION_ID
                       , COMPANY_ID
                       , SITE_ID
                       , PLANT_ID
                       , FACTORY_ID
                       , LINE_ID
                       , OPERATION_ID
                       , ELTR_LN_TP_CD
                       , MDL_NM
                       , MSR_TP_CD
                       , YYYYMM
                       , MSR_NVL
                    FROM GT_SCP0104_SCP_MST_CAPA_LOSS)
        LOOP

            UPDATE SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL
               SET MSR_NVL          = R.MSR_NVL
                 , LAST_UPDATED_BY  = V_USER_ID
                 , LAST_UPDATE_DATE = SYSDATE
             WHERE DIVISION_ID   = R.DIVISION_ID
               AND COMPANY_ID    = R.COMPANY_ID
               AND SITE_ID       = R.SITE_ID
               AND PLANT_ID      = R.PLANT_ID
               AND FACTORY_ID    = R.FACTORY_ID
               AND LINE_ID       = R.LINE_ID
               AND OPERATION_ID  = R.OPERATION_ID
               AND MDL_NM        = R.MDL_NM
               AND MSR_TP_CD     = R.MSR_TP_CD
               AND YYYYMM        = R.YYYYMM;

        END LOOP;
        /* SAVE - LOSS_PLAN_BY_ASSIGN - END */

    END IF;

    /* LOG end */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    COMMIT;

    /* 결과코드, 결과 카운트 반환 */
    OPEN O_RC1 FOR
        SELECT 'S'          AS RESULT_CODE
             , N_ALL_CNT    AS RESULT_CNT
          FROM DUAL;

    OPEN O_RESULT_CURSOR FOR
        /* SELECT '0'          AS RESULT_CODE */ /* AJS 20261007 화면검증 */
        SELECT 'S'          AS RESULT_CODE   /* AJS 20261007 화면검증 */
             , 'SUCCESS'    AS RESULT_MESSAGE
             , N_ALL_CNT    AS RESULT_CNT   /* AJS 20261007 화면검증 */
          FROM DUAL;

EXCEPTION
    WHEN OTHERS
    THEN

        V_SQLCODE := SQLCODE;
        V_SQLERRM := SQLERRM;

        ROLLBACK TO SP_SCP0104_SAVE_SOP_E;    /* 입력 데이타 롤백 처리 */

        INSERT INTO SCM_SYS_LOG_BATCH
                    ( PROGRAM_NAME
                    , LOG_TYPE
                    , LOG_COUNT
                    , LOG_MESSAGE
                    , DESCRIPTION
                    , EVENT_DATE
                    , CREATION_DATE
                    , CREATED_BY
                    , LAST_UPDATE_DATE
                    , LAST_UPDATED_BY )
             VALUES ( V_PROGRAM_NAME
                    , 'ERROR'
                    , NULL
                    , V_SQLERRM
                    , NULL
                    , SYSDATE
                    , SYSDATE
                    , V_PROGRAM_NAME
                    , SYSDATE
                    , V_PROGRAM_NAME );

        COMMIT;

        OPEN O_RC1 FOR
            SELECT 'F'                                              AS RESULT_CODE
                 , '[' || TO_CHAR(V_SQLCODE) || ']' || V_SQLERRM     AS ERR_MESSAGE
              FROM DUAL;

        OPEN O_RESULT_CURSOR FOR
            /* SELECT '[' || TO_CHAR(V_SQLCODE) || ']' || V_SQLERRM     AS ERR_MESSAGE */ /* AJS 20261007 화면검증 */
            SELECT 'F'                                              AS RESULT_CODE   /* AJS 20261007 화면검증 */
                 , '[' || TO_CHAR(V_SQLCODE) || ']' || V_SQLERRM     AS ERR_MESSAGE
              FROM DUAL;

END P_SCP0104_SAVE_CAPA_LINE_SOP_ELTR;


/****************************************************************************************************/
/* Program ID  : P_SCP0104_SAVE_CAPA_LINE_ASSIGN_ASSEMBLY                                           */
/* Description : CAPA LINE ASSIGN 저장 — 조립                                                       */
/****************************************************************************************************/
PROCEDURE P_SCP0104_SAVE_CAPA_LINE_ASSIGN_ASSEMBLY
(
    P_VERSION               IN  CLOB
  , P_VERSION_SEQ           IN  CLOB
  , P_PROG_STAT             IN  CLOB
  , P_DIVISION_ID           IN  CLOB
  , P_COMPANY_ID            IN  CLOB
  , P_SITE_ID               IN  CLOB
  , P_PLANT_ID              IN  CLOB
  , P_FACTORY_ID            IN  CLOB
  , P_LINE_ID               IN  CLOB
  , P_OPERATION_ID          IN  CLOB
  , P_ELECTRODE_TYPE        IN  CLOB
  , P_SITE_NAME             IN  CLOB
  , P_COMPANY_NAME          IN  CLOB
  , P_PLANT_NAME            IN  CLOB
  , P_FACTORY_NAME          IN  CLOB
  , P_LINE_NAME             IN  CLOB
  , P_VALID_YN              IN  CLOB
  , P_ITEM_ID               IN  CLOB
  , P_NICK_NAME             IN  CLOB
  , P_DATE_COLUMN_NAMES     IN  CLOB
  , P_DATE_COLUMN_VALUES    IN  CLOB
  , P_PROGRAM_ID            IN  CLOB
  , P_SHEET_NAME            IN  CLOB
  , P_USER_ID               IN  CLOB
  , P_DEBUG_MODE            IN  CLOB
  , O_RC1                   OUT SYS_REFCURSOR
  , O_RC2                   OUT SYS_REFCURSOR
)
IS
    V_USER_ID           VARCHAR2(800 CHAR) := TO_CHAR(P_USER_ID);
    V_VERSION           VARCHAR2(40 CHAR)  := TO_CHAR(P_VERSION);
    V_VERSION_SEQ       NUMBER(3)          := TO_NUMBER(TO_CHAR(P_VERSION_SEQ));
    V_RESULT_CD         VARCHAR2(4 CHAR)   := 'S';
    V_RESULT_MSG        VARCHAR2(4000 CHAR);
    V_UPDATED_CNT       NUMBER(9)          := 0;
BEGIN

    SAVEPOINT SP_SCP0104_SAVE_ASGN_ASM;

    /* GTT 초기화 — 같은 접속에서 잇달아 부를 때 앞 호출분이 남지 않게 한다 */
    DELETE GT_SCP0104_ASGN_TOKEN;
    DELETE GT_SCP0104_DATE_COLS;
    DELETE GT_SCP0104_DATE_VALS;
    DELETE GT_SCP0104_ASGN_ALL;
    DELETE GT_SCP0104_ASGN_CHG;
    DELETE GT_SCP0104_LINE_MDL;
    DELETE GT_SCP_CAPA_LINE_ASSIGN_KEYS;

    /* 화면이 보내는 칸 값은 길이가 커서 CLOB 로 받는다 — 칸마다 자리 번호를 붙여 한 곳에 푼다 */
    P_SCP0104_SPLIT_CLOB( 1, P_DIVISION_ID,        '^');
    P_SCP0104_SPLIT_CLOB( 2, P_COMPANY_ID,         '^');
    P_SCP0104_SPLIT_CLOB( 3, P_SITE_ID,            '^');
    P_SCP0104_SPLIT_CLOB( 4, P_PLANT_ID,           '^');
    P_SCP0104_SPLIT_CLOB( 5, P_FACTORY_ID,         '^');
    P_SCP0104_SPLIT_CLOB( 6, P_LINE_ID,            '^');
    P_SCP0104_SPLIT_CLOB( 7, P_OPERATION_ID,       '^');
    P_SCP0104_SPLIT_CLOB( 8, P_ELECTRODE_TYPE,     '^');
    P_SCP0104_SPLIT_CLOB( 9, P_SITE_NAME,          '^');
    P_SCP0104_SPLIT_CLOB(10, P_COMPANY_NAME,       '^');
    P_SCP0104_SPLIT_CLOB(11, P_PLANT_NAME,         '^');
    P_SCP0104_SPLIT_CLOB(12, P_FACTORY_NAME,       '^');
    P_SCP0104_SPLIT_CLOB(13, P_LINE_NAME,          '^');
    P_SCP0104_SPLIT_CLOB(14, P_ITEM_ID,            '^');
    P_SCP0104_SPLIT_CLOB(15, P_NICK_NAME,          '^');
    P_SCP0104_SPLIT_CLOB(16, P_VALID_YN,           '^');
    P_SCP0104_SPLIT_CLOB(90, P_DATE_COLUMN_NAMES,  '^');
    P_SCP0104_SPLIT_CLOB(91, P_DATE_COLUMN_VALUES, '^');

    /* 속도 이슈로 Unpivot 을 UI 에서 DB 로 이전 BEGIN */
    INSERT INTO GT_SCP0104_DATE_COLS
                ( NR
                , COLUMN_NAME
                , COLUMN_VALUE )
         SELECT A.NR
              , A.TOKEN
              , B.TOKEN
           FROM GT_SCP0104_ASGN_TOKEN A
              , GT_SCP0104_ASGN_TOKEN B
          WHERE A.SLOT_NO = 90
            AND B.SLOT_NO = 91
            AND B.NR      = A.NR
            AND A.TOKEN IS NOT NULL;

    /* 한 행의 칸 이름·칸 값을 각각 ; 로 풀어 자리 번호로 짝짓는다 */
    FOR R IN (SELECT A.NR
                   , A.COLUMN_NAME
                   , A.COLUMN_VALUE
                FROM GT_SCP0104_DATE_COLS A)
    LOOP

        INSERT INTO GT_SCP0104_DATE_VALS
                    ( ROW_NR
                    , COL_NR
                    , COL_NAME
                    , COL_VALUE
                    , YYYYMM )
             SELECT R.NR
                  , IA.NR
                  , IA.TOKEN
                  , IB.TOKEN
                  , REPLACE(REPLACE(REPLACE(IA.TOKEN, 'M_00', ''), 'M_01', ''), 'Y_', '')
               FROM (SELECT ROWNUM AS NR
                          , COLUMN_VALUE AS TOKEN
                       FROM TABLE(STRING_SPLIT(R.COLUMN_NAME, ';'))) IA
                  , (SELECT ROWNUM AS NR
                          , COLUMN_VALUE AS TOKEN
                       FROM TABLE(STRING_SPLIT(R.COLUMN_VALUE, ';'))) IB
              WHERE IB.NR = IA.NR
                AND IA.TOKEN IS NOT NULL;

    END LOOP;

    /* 월별(M_01…) 과 연도별(Y_…) 칸만 남긴다 */
    DELETE GT_SCP0104_DATE_VALS
     WHERE NOT (SUBSTR(COL_NAME, 3, 2) = '01' OR SUBSTR(COL_NAME, 1, 2) = 'Y_');

    /* 화면 한 행을 칸 수만큼 풀어 배정 대상으로 만든다 */
    INSERT INTO GT_SCP0104_ASGN_ALL
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , SITE_NAME
                , COMPANY_NAME
                , PLANT_NAME
                , FACTORY_NAME
                , LINE_NAME
                , ITEM_ID
                , NICK_NAME
                , YYYYMM
                , ASSIGN_PRIORITY
                , DUMMY_YN
                , VALID_YN
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
         SELECT V_VERSION
              , V_VERSION_SEQ
              , B.TOKEN
              , C.TOKEN
              , D.TOKEN
              , E.TOKEN
              , F.TOKEN
              , G.TOKEN
              , H.TOKEN
              , IG.TOKEN
              /* 명칭에 id 가 포함된 경우 제거 */
              , TRIM(REPLACE(J.TOKEN, D.TOKEN, ''))
              , TRIM(REPLACE(K.TOKEN, C.TOKEN, ''))
              , TRIM(REPLACE(L.TOKEN, E.TOKEN, ''))
              , TRIM(REPLACE(M.TOKEN, F.TOKEN, ''))
              , TRIM(REPLACE(N.TOKEN, G.TOKEN, ''))
              , O.TOKEN
              , P.TOKEN
              , A.YYYYMM
              , TO_NUMBER(NVL(TRIM(A.COL_VALUE), '0'))
              , 'N'
              , Q.TOKEN
              , V_USER_ID
              , SYSDATE
              , V_USER_ID
              , SYSDATE
           FROM GT_SCP0104_DATE_VALS A
              , GT_SCP0104_ASGN_TOKEN B
              , GT_SCP0104_ASGN_TOKEN C
              , GT_SCP0104_ASGN_TOKEN D
              , GT_SCP0104_ASGN_TOKEN E
              , GT_SCP0104_ASGN_TOKEN F
              , GT_SCP0104_ASGN_TOKEN G
              , GT_SCP0104_ASGN_TOKEN H
              , GT_SCP0104_ASGN_TOKEN IG
              , GT_SCP0104_ASGN_TOKEN J
              , GT_SCP0104_ASGN_TOKEN K
              , GT_SCP0104_ASGN_TOKEN L
              , GT_SCP0104_ASGN_TOKEN M
              , GT_SCP0104_ASGN_TOKEN N
              , GT_SCP0104_ASGN_TOKEN O
              , GT_SCP0104_ASGN_TOKEN P
              , GT_SCP0104_ASGN_TOKEN Q
          WHERE B.SLOT_NO   = 1
            AND B.NR        = A.ROW_NR
            AND C.SLOT_NO   = 2
            AND C.NR        = A.ROW_NR
            AND D.SLOT_NO   = 3
            AND D.NR        = A.ROW_NR
            AND E.SLOT_NO   = 4
            AND E.NR        = A.ROW_NR
            AND F.SLOT_NO   = 5
            AND F.NR        = A.ROW_NR
            AND G.SLOT_NO   = 6
            AND G.NR        = A.ROW_NR
            AND H.SLOT_NO   = 7
            AND H.NR        = A.ROW_NR
            AND IG.SLOT_NO  = 8
            AND IG.NR       = A.ROW_NR
            AND J.SLOT_NO   = 9
            AND J.NR        = A.ROW_NR
            AND K.SLOT_NO   = 10
            AND K.NR        = A.ROW_NR
            AND L.SLOT_NO   = 11
            AND L.NR        = A.ROW_NR
            AND M.SLOT_NO   = 12
            AND M.NR        = A.ROW_NR
            AND N.SLOT_NO   = 13
            AND N.NR        = A.ROW_NR
            AND O.SLOT_NO   = 14
            AND O.NR        = A.ROW_NR
            AND P.SLOT_NO   = 15
            AND P.NR        = A.ROW_NR
            AND Q.SLOT_NO   = 16
            AND Q.NR        = A.ROW_NR;
    /* 속도 이슈로 Unpivot 을 UI 에서 DB 로 이전 - END */

    /* 빈라인이 추가되어 삭제 */
    DELETE GT_SCP0104_ASGN_ALL
     WHERE DIVISION_ID   IS NULL
        OR COMPANY_ID    IS NULL
        OR SITE_ID       IS NULL
        OR PLANT_ID      IS NULL
        OR FACTORY_ID    IS NULL
        OR LINE_ID       IS NULL
        OR OPERATION_ID  IS NULL
        OR ELTR_LN_TP_CD IS NULL
        OR (ITEM_ID IS NULL AND NICK_NAME IS NULL)
        OR YYYYMM        IS NULL;

    /* DUMMY_YN 로직 수정 */
    UPDATE GT_SCP0104_ASGN_ALL A
       SET A.DUMMY_YN = 'Y'
     WHERE A.SITE_ID    LIKE 'DMY_%'
        OR A.COMPANY_ID LIKE 'DMY_%'
        OR A.PLANT_ID   LIKE 'DMY_%'
        OR A.FACTORY_ID LIKE 'DMY_%'
        OR A.LINE_ID    LIKE 'DMY_%'
        OR NOT EXISTS (SELECT 1
                         FROM TABLE(FN_SCM0002_GET_CAPA_ITEM_POPUP('', '')) XA
                        WHERE XA.NICK_NAME = A.NICK_NAME
                          AND XA.NICK_NAME IS NOT NULL);

    /* 변경된 데이터만 해당 BEGIN */
    INSERT INTO GT_SCP0104_ASGN_CHG
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , SITE_NAME
                , COMPANY_NAME
                , PLANT_NAME
                , FACTORY_NAME
                , LINE_NAME
                , ITEM_ID
                , NICK_NAME
                , YYYYMM
                , ASSIGN_PRIORITY
                , DUMMY_YN
                , VALID_YN
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
         SELECT A.VER_ID
              , A.VER_SEQ
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.SITE_NAME
              , A.COMPANY_NAME
              , A.PLANT_NAME
              , A.FACTORY_NAME
              , A.LINE_NAME
              , A.ITEM_ID
              , A.NICK_NAME
              , A.YYYYMM
              , A.ASSIGN_PRIORITY
              , A.DUMMY_YN
              , A.VALID_YN
              , A.CREATED_BY
              , A.CREATION_DATE
              , A.LAST_UPDATED_BY
              , A.LAST_UPDATE_DATE
           FROM GT_SCP0104_ASGN_ALL A
              , SCP_MST_CAPA_LINE_ASSIGN B
          WHERE B.DIVISION_ID(+)   = A.DIVISION_ID
            AND B.COMPANY_ID(+)    = A.COMPANY_ID
            AND B.SITE_ID(+)       = A.SITE_ID
            AND B.PLANT_ID(+)      = A.PLANT_ID
            AND B.FACTORY_ID(+)    = A.FACTORY_ID
            AND B.LINE_ID(+)       = A.LINE_ID
            AND B.OPERATION_ID(+)  = A.OPERATION_ID
            AND B.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
            AND B.NICK_NAME(+)     = A.NICK_NAME
            AND B.YYYYMM(+)        = A.YYYYMM
            AND (B.DIVISION_ID IS NULL
              OR A.VALID_YN <> B.VALID_YN
              OR NVL(A.ASSIGN_PRIORITY, 0) <> NVL(B.ASSIGN_PRIORITY, 0)
              OR A.DUMMY_YN <> B.DUMMY_YN);
    /* 변경된 데이터만 해당 END */

    /* 데이터 저장 - 마스터 */
    INSERT INTO GT_SCP0104_LINE_MDL
                ( DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , SITE_NAME
                , COMPANY_NAME
                , PLANT_NAME
                , FACTORY_NAME
                , LINE_NAME
                , DUMMY_YN )
         SELECT DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , ITEM_ID
              , NICK_NAME
              , MAX(SITE_NAME)
              , MAX(COMPANY_NAME)
              , MAX(PLANT_NAME)
              , MAX(FACTORY_NAME)
              , MAX(LINE_NAME)
              , MAX(DUMMY_YN)
           FROM GT_SCP0104_ASGN_CHG
          GROUP BY DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , ITEM_ID
                 , NICK_NAME;

    /* SAVE - SCP_MST_CAPA_LINE_MDL - BEGIN
       원문은 MERGE 한 문장이나 온라인 SQL 에서 쓰지 않는 규칙이라 고치는 문장과 넣는 문장으로 나눈다 */
    FOR R IN (SELECT DIVISION_ID
                   , COMPANY_ID
                   , SITE_ID
                   , PLANT_ID
                   , FACTORY_ID
                   , LINE_ID
                   , OPERATION_ID
                   , ELTR_LN_TP_CD
                   , ITEM_ID
                   , NICK_NAME
                   , DUMMY_YN
                FROM GT_SCP0104_LINE_MDL)
    LOOP

        UPDATE SCP_MST_CAPA_LINE_MDL
           SET DUMMY_YN         = R.DUMMY_YN
             , LAST_UPDATED_BY  = V_USER_ID
             , LAST_UPDATE_DATE = SYSDATE
         WHERE DIVISION_ID   = R.DIVISION_ID
           AND COMPANY_ID    = R.COMPANY_ID
           AND SITE_ID       = R.SITE_ID
           AND PLANT_ID      = R.PLANT_ID
           AND FACTORY_ID    = R.FACTORY_ID
           AND LINE_ID       = R.LINE_ID
           AND OPERATION_ID  = R.OPERATION_ID
           AND ELTR_LN_TP_CD = R.ELTR_LN_TP_CD
           AND ITEM_ID       = R.ITEM_ID
           AND NICK_NAME     = R.NICK_NAME;

        IF SQL%ROWCOUNT = 0 THEN

            INSERT INTO SCP_MST_CAPA_LINE_MDL
                        ( DIVISION_ID
                        , COMPANY_ID
                        , SITE_ID
                        , PLANT_ID
                        , FACTORY_ID
                        , LINE_ID
                        , OPERATION_ID
                        , ELTR_LN_TP_CD
                        , ITEM_ID
                        , NICK_NAME
                        , DUMMY_YN
                        , CREATED_BY
                        , CREATION_DATE
                        , LAST_UPDATED_BY
                        , LAST_UPDATE_DATE )
                 VALUES ( R.DIVISION_ID
                        , R.COMPANY_ID
                        , R.SITE_ID
                        , R.PLANT_ID
                        , R.FACTORY_ID
                        , R.LINE_ID
                        , R.OPERATION_ID
                        , R.ELTR_LN_TP_CD
                        , R.ITEM_ID
                        , R.NICK_NAME
                        , R.DUMMY_YN
                        , V_USER_ID
                        , SYSDATE
                        , V_USER_ID
                        , SYSDATE );

        END IF;

    END LOOP;
    /* SAVE - SCP_MST_CAPA_LINE_MDL - END */

    /* SAVE - SCP_MST_CAPA_LINE_ASSIGN - BEGIN */
    FOR R IN (SELECT DIVISION_ID
                   , COMPANY_ID
                   , SITE_ID
                   , PLANT_ID
                   , FACTORY_ID
                   , LINE_ID
                   , OPERATION_ID
                   , ELTR_LN_TP_CD
                   , ITEM_ID
                   , NICK_NAME
                   , YYYYMM
                   , ASSIGN_PRIORITY
                   , DUMMY_YN
                   , VALID_YN
                FROM GT_SCP0104_ASGN_CHG
               WHERE DIVISION_ID   IS NOT NULL
                 AND COMPANY_ID    IS NOT NULL
                 AND SITE_ID       IS NOT NULL
                 AND PLANT_ID      IS NOT NULL
                 AND FACTORY_ID    IS NOT NULL
                 AND LINE_ID       IS NOT NULL
                 AND OPERATION_ID  IS NOT NULL
                 AND ELTR_LN_TP_CD IS NOT NULL
                 AND (ITEM_ID IS NOT NULL OR NICK_NAME IS NOT NULL)
                 AND YYYYMM        IS NOT NULL)
    LOOP

        UPDATE SCP_MST_CAPA_LINE_ASSIGN
           SET ASSIGN_PRIORITY  = R.ASSIGN_PRIORITY
             , DUMMY_YN         = R.DUMMY_YN
             , VALID_YN         = R.VALID_YN
             , LAST_UPDATED_BY  = V_USER_ID
             , LAST_UPDATE_DATE = SYSDATE
         WHERE DIVISION_ID   = R.DIVISION_ID
           AND COMPANY_ID    = R.COMPANY_ID
           AND SITE_ID       = R.SITE_ID
           AND PLANT_ID      = R.PLANT_ID
           AND FACTORY_ID    = R.FACTORY_ID
           AND LINE_ID       = R.LINE_ID
           AND OPERATION_ID  = R.OPERATION_ID
           AND ELTR_LN_TP_CD = R.ELTR_LN_TP_CD
           AND NICK_NAME     = R.NICK_NAME
           AND YYYYMM        = R.YYYYMM;

        IF SQL%ROWCOUNT = 0 THEN

            INSERT INTO SCP_MST_CAPA_LINE_ASSIGN
                        ( DIVISION_ID
                        , COMPANY_ID
                        , SITE_ID
                        , PLANT_ID
                        , FACTORY_ID
                        , LINE_ID
                        , OPERATION_ID
                        , ELTR_LN_TP_CD
                        , ITEM_ID
                        , NICK_NAME
                        , YYYYMM
                        , ASSIGN_PRIORITY
                        , DUMMY_YN
                        , VALID_YN
                        , CREATED_BY
                        , CREATION_DATE
                        , LAST_UPDATED_BY
                        , LAST_UPDATE_DATE )
                 VALUES ( R.DIVISION_ID
                        , R.COMPANY_ID
                        , R.SITE_ID
                        , R.PLANT_ID
                        , R.FACTORY_ID
                        , R.LINE_ID
                        , R.OPERATION_ID
                        , R.ELTR_LN_TP_CD
                        , R.ITEM_ID
                        , R.NICK_NAME
                        , R.YYYYMM
                        , R.ASSIGN_PRIORITY
                        , R.DUMMY_YN
                        , R.VALID_YN
                        , V_USER_ID
                        , SYSDATE
                        , V_USER_ID
                        , SYSDATE );

        END IF;

    END LOOP;
    /* SAVE - SCP_MST_CAPA_LINE_ASSIGN - END */

    /* 뒤따르는 검증 프로시저에 넘길 열쇠 */
    INSERT INTO GT_SCP_CAPA_LINE_ASSIGN_KEYS
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , YYYYMM
                , ASSIGN_PRIORITY
                , DUMMY_YN
                , VALID_YN
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
         SELECT VER_ID
              , VER_SEQ
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , ITEM_ID
              , NICK_NAME
              , YYYYMM
              , ASSIGN_PRIORITY
              , DUMMY_YN
              , VALID_YN
              , CREATED_BY
              , CREATION_DATE
              , LAST_UPDATED_BY
              , LAST_UPDATE_DATE
           FROM GT_SCP0104_ASGN_CHG;

    SELECT COUNT(*)
      INTO V_UPDATED_CNT
      FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS;

    /* 데이터 저장 - Speed Plan */
    IF V_UPDATED_CNT > 0 THEN

        P_SCP0105_CHK_SPEED_ASGN_ASM('SCP0105', 'ASSEMBLY', V_USER_ID, TO_CHAR(P_DEBUG_MODE));

    END IF;

    /* 데이터 저장 - Loss Plan */
    P_SCP0106_CHK_LOSS_ASGN_ASM('SCP0106', 'CURRENT_ASSEMBLY', V_USER_ID, TO_CHAR(P_DEBUG_MODE));

    OPEN O_RC1 FOR
        SELECT V_RESULT_CD  AS RESULT_CD
             , V_RESULT_CD  AS RESULT_CODE   /* AJS 20261007 화면검증 */
             , V_RESULT_MSG AS RESULT_MSG
          FROM DUAL;

    OPEN O_RC2 FOR
        SELECT V_RESULT_CD  AS RESULT_CD
             , V_RESULT_CD  AS RESULT_CODE   /* AJS 20261007 화면검증 */
             , V_RESULT_MSG AS RESULT_MSG
          FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN

        ROLLBACK TO SP_SCP0104_SAVE_ASGN_ASM;

        V_RESULT_CD  := 'F';
        V_RESULT_MSG := '[' || SQLCODE || ']' || SUBSTR(SQLERRM, 1, 3000);

        OPEN O_RC1 FOR
            SELECT V_RESULT_CD  AS RESULT_CD
                 , V_RESULT_CD  AS RESULT_CODE   /* AJS 20261007 화면검증 */
                 , V_RESULT_MSG AS RESULT_MSG
              FROM DUAL;

        OPEN O_RC2 FOR
            SELECT V_RESULT_CD  AS RESULT_CD
                 , V_RESULT_CD  AS RESULT_CODE   /* AJS 20261007 화면검증 */
                 , V_RESULT_MSG AS RESULT_MSG
              FROM DUAL;

END P_SCP0104_SAVE_CAPA_LINE_ASSIGN_ASSEMBLY;


/****************************************************************************************************/
/* Program ID  : P_SCP0104_SAVE_CAPA_LINE_ASSIGN_ELTR                                               */
/* Description : CAPA LINE ASSIGN 저장 — 전극                                                       */
/****************************************************************************************************/
PROCEDURE P_SCP0104_SAVE_CAPA_LINE_ASSIGN_ELTR
(
    P_VERSION               IN  CLOB
  , P_VERSION_SEQ           IN  CLOB
  , P_PROG_STAT             IN  CLOB
  , P_DIVISION_ID           IN  CLOB
  , P_COMPANY_ID            IN  CLOB
  , P_SITE_ID               IN  CLOB
  , P_PLANT_ID              IN  CLOB
  , P_FACTORY_ID            IN  CLOB
  , P_LINE_ID               IN  CLOB
  , P_OPERATION_ID          IN  CLOB
  , P_ELECTRODE_TYPE        IN  CLOB
  , P_SITE_NAME             IN  CLOB
  , P_COMPANY_NAME          IN  CLOB
  , P_PLANT_NAME            IN  CLOB
  , P_FACTORY_NAME          IN  CLOB
  , P_LINE_NAME             IN  CLOB
  , P_LANE_QTY              IN  CLOB
  , P_VALID_YN              IN  CLOB
  , P_ITEM_ID               IN  CLOB
  , P_NICK_NAME             IN  CLOB
  , P_DATE_COLUMN_NAMES     IN  CLOB
  , P_DATE_COLUMN_VALUES    IN  CLOB
  , P_PROGRAM_ID            IN  CLOB
  , P_SHEET_NAME            IN  CLOB
  , P_USER_ID               IN  CLOB
  , P_DEBUG_MODE            IN  CLOB
  , O_RC1                   OUT SYS_REFCURSOR
  , O_RC2                   OUT SYS_REFCURSOR
)
IS
    V_USER_ID           VARCHAR2(800 CHAR) := TO_CHAR(P_USER_ID);
    V_VERSION           VARCHAR2(40 CHAR)  := TO_CHAR(P_VERSION);
    V_VERSION_SEQ       NUMBER(3)          := TO_NUMBER(TO_CHAR(P_VERSION_SEQ));
    V_RESULT_CD         VARCHAR2(4 CHAR)   := 'S';
    V_RESULT_MSG        VARCHAR2(4000 CHAR);
    V_UPDATED_CNT       NUMBER(9)          := 0;
BEGIN

    SAVEPOINT SP_SCP0104_SAVE_ASGN_ELTR;

    /* GTT 초기화 — 같은 접속에서 잇달아 부를 때 앞 호출분이 남지 않게 한다 */
    DELETE GT_SCP0104_ASGN_TOKEN;
    DELETE GT_SCP0104_DATE_COLS;
    DELETE GT_SCP0104_DATE_VALS;
    DELETE GT_SCP0104_ASGN_ALL;
    DELETE GT_SCP0104_ASGN_CHG;
    DELETE GT_SCP0104_LINE_MDL;
    DELETE GT_SCP0104_EQUIPMENT;
    DELETE GT_SCP0104_EQUIP_TP_ASGN;
    DELETE GT_SCP_CAPA_LINE_ASSIGN_KEYS;
    DELETE GT_SCP0104_DUMMY_LIVE;

    /* 전극 Coating 공정의 주 설비 — 광폭 가능 여부로 라인 유형을 가른다 */
    INSERT INTO GT_SCP0104_EQUIPMENT
                ( COMPANY_ID
                , DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , EQUIPMENT_ID
                , EQUIPMENT_NAME
                , WIDE_ROLL_ENABLE_FLAG
                , ELTR_LN_TP_CD )
         SELECT COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              /* 2025.04.08 Coating은 라인:설비=1:1 , 1:N 아닌 경우 대비 group by/max 처리 */
              , MAX(EQUIPMENT_ID)
              , MAX(EQUIPMENT_NAME)
              , MAX(WIDE_ROLL_ENABLE_FLAG)
              , CASE WHEN MAX(WIDE_ROLL_ENABLE_FLAG) = 'Y' THEN 'W' ELSE 'S' END
           FROM SCM_MST_EQUIPMENT_SN
          WHERE OPERATION_ID LIKE 'E2000%'   /* 전극 Coating 공정 (현재는 E2000 공정 하나만 대상) */
            AND EQUIPMENT_TYPE = 'M'         /* Main 설비 */
            AND ACTIVE_FLAG    = 'Y'
          GROUP BY COMPANY_ID
                 , DIVISION_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID;

    /* 화면이 보내는 칸 값은 길이가 커서 CLOB 로 받는다 — 칸마다 자리 번호를 붙여 한 곳에 푼다 */
    P_SCP0104_SPLIT_CLOB( 1, P_DIVISION_ID,        '^');
    P_SCP0104_SPLIT_CLOB( 2, P_COMPANY_ID,         '^');
    P_SCP0104_SPLIT_CLOB( 3, P_SITE_ID,            '^');
    P_SCP0104_SPLIT_CLOB( 4, P_PLANT_ID,           '^');
    P_SCP0104_SPLIT_CLOB( 5, P_FACTORY_ID,         '^');
    P_SCP0104_SPLIT_CLOB( 6, P_LINE_ID,            '^');
    P_SCP0104_SPLIT_CLOB( 7, P_OPERATION_ID,       '^');
    P_SCP0104_SPLIT_CLOB( 8, P_ELECTRODE_TYPE,     '^');
    P_SCP0104_SPLIT_CLOB( 9, P_SITE_NAME,          '^');
    P_SCP0104_SPLIT_CLOB(10, P_COMPANY_NAME,       '^');
    P_SCP0104_SPLIT_CLOB(11, P_PLANT_NAME,         '^');
    P_SCP0104_SPLIT_CLOB(12, P_FACTORY_NAME,       '^');
    P_SCP0104_SPLIT_CLOB(13, P_LINE_NAME,          '^');
    P_SCP0104_SPLIT_CLOB(14, P_ITEM_ID,            '^');
    P_SCP0104_SPLIT_CLOB(15, P_NICK_NAME,          '^');
    P_SCP0104_SPLIT_CLOB(16, P_LANE_QTY,           '^');
    P_SCP0104_SPLIT_CLOB(17, P_VALID_YN,           '^');
    P_SCP0104_SPLIT_CLOB(90, P_DATE_COLUMN_NAMES,  '^');
    P_SCP0104_SPLIT_CLOB(91, P_DATE_COLUMN_VALUES, '^');

    /* 속도 이슈로 Unpivot 을 UI 에서 DB 로 이전 BEGIN */
    INSERT INTO GT_SCP0104_DATE_COLS
                ( NR
                , COLUMN_NAME
                , COLUMN_VALUE )
         SELECT A.NR
              , A.TOKEN
              , B.TOKEN
           FROM GT_SCP0104_ASGN_TOKEN A
              , GT_SCP0104_ASGN_TOKEN B
          WHERE A.SLOT_NO = 90
            AND B.SLOT_NO = 91
            AND B.NR      = A.NR
            AND A.TOKEN IS NOT NULL;

    FOR R IN (SELECT A.NR
                   , A.COLUMN_NAME
                   , A.COLUMN_VALUE
                FROM GT_SCP0104_DATE_COLS A)
    LOOP

        INSERT INTO GT_SCP0104_DATE_VALS
                    ( ROW_NR
                    , COL_NR
                    , COL_NAME
                    , COL_VALUE
                    , YYYYMM )
             SELECT R.NR
                  , IA.NR
                  , IA.TOKEN
                  , IB.TOKEN
                  , REPLACE(REPLACE(REPLACE(IA.TOKEN, 'M_00', ''), 'M_01', ''), 'Y_', '')
               FROM (SELECT ROWNUM AS NR
                          , COLUMN_VALUE AS TOKEN
                       FROM TABLE(STRING_SPLIT(R.COLUMN_NAME, ';'))) IA
                  , (SELECT ROWNUM AS NR
                          , COLUMN_VALUE AS TOKEN
                       FROM TABLE(STRING_SPLIT(R.COLUMN_VALUE, ';'))) IB
              WHERE IB.NR = IA.NR
                AND IA.TOKEN IS NOT NULL;

    END LOOP;

    DELETE GT_SCP0104_DATE_VALS
     WHERE NOT (SUBSTR(COL_NAME, 3, 2) = '01' OR SUBSTR(COL_NAME, 1, 2) = 'Y_');

    /* 화면 한 행을 칸 수만큼 풀어 배정 대상으로 만든다 — 전극은 품목 이름을 쓰지 않는다 */
    INSERT INTO GT_SCP0104_ASGN_ALL
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , SITE_NAME
                , COMPANY_NAME
                , PLANT_NAME
                , FACTORY_NAME
                , LINE_NAME
                , LANE_QTY
                , ITEM_ID
                , NICK_NAME
                , YYYYMM
                , ASSIGN_PRIORITY
                , DUMMY_YN
                , VALID_YN
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
         SELECT V_VERSION
              , V_VERSION_SEQ
              , B.TOKEN
              , C.TOKEN
              , D.TOKEN
              , E.TOKEN
              , F.TOKEN
              , G.TOKEN
              , H.TOKEN
              , IG.TOKEN
              /* 명칭에 id 가 포함된 경우 제거 */
              , TRIM(REPLACE(J.TOKEN, D.TOKEN, ''))
              , TRIM(REPLACE(K.TOKEN, C.TOKEN, ''))
              , TRIM(REPLACE(L.TOKEN, E.TOKEN, ''))
              , TRIM(REPLACE(M.TOKEN, F.TOKEN, ''))
              , TRIM(REPLACE(N.TOKEN, G.TOKEN, ''))
              , TO_NUMBER(NVL(TRIM(Q.TOKEN), '0'))
              , O.TOKEN
              , '-'
              , A.YYYYMM
              , TO_NUMBER(NVL(TRIM(A.COL_VALUE), '0'))
              , 'N'
              , S.TOKEN
              , V_USER_ID
              , SYSDATE
              , V_USER_ID
              , SYSDATE
           FROM GT_SCP0104_DATE_VALS A
              , GT_SCP0104_ASGN_TOKEN B
              , GT_SCP0104_ASGN_TOKEN C
              , GT_SCP0104_ASGN_TOKEN D
              , GT_SCP0104_ASGN_TOKEN E
              , GT_SCP0104_ASGN_TOKEN F
              , GT_SCP0104_ASGN_TOKEN G
              , GT_SCP0104_ASGN_TOKEN H
              , GT_SCP0104_ASGN_TOKEN IG
              , GT_SCP0104_ASGN_TOKEN J
              , GT_SCP0104_ASGN_TOKEN K
              , GT_SCP0104_ASGN_TOKEN L
              , GT_SCP0104_ASGN_TOKEN M
              , GT_SCP0104_ASGN_TOKEN N
              , GT_SCP0104_ASGN_TOKEN O
              , GT_SCP0104_ASGN_TOKEN P
              , GT_SCP0104_ASGN_TOKEN Q
              , GT_SCP0104_ASGN_TOKEN S
          WHERE B.SLOT_NO   = 1
            AND B.NR        = A.ROW_NR
            AND C.SLOT_NO   = 2
            AND C.NR        = A.ROW_NR
            AND D.SLOT_NO   = 3
            AND D.NR        = A.ROW_NR
            AND E.SLOT_NO   = 4
            AND E.NR        = A.ROW_NR
            AND F.SLOT_NO   = 5
            AND F.NR        = A.ROW_NR
            AND G.SLOT_NO   = 6
            AND G.NR        = A.ROW_NR
            AND H.SLOT_NO   = 7
            AND H.NR        = A.ROW_NR
            AND IG.SLOT_NO  = 8
            AND IG.NR       = A.ROW_NR
            AND J.SLOT_NO   = 9
            AND J.NR        = A.ROW_NR
            AND K.SLOT_NO   = 10
            AND K.NR        = A.ROW_NR
            AND L.SLOT_NO   = 11
            AND L.NR        = A.ROW_NR
            AND M.SLOT_NO   = 12
            AND M.NR        = A.ROW_NR
            AND N.SLOT_NO   = 13
            AND N.NR        = A.ROW_NR
            AND O.SLOT_NO   = 14
            AND O.NR        = A.ROW_NR
            AND P.SLOT_NO   = 15
            AND P.NR        = A.ROW_NR
            AND Q.SLOT_NO   = 16
            AND Q.NR        = A.ROW_NR
            AND S.SLOT_NO   = 17
            AND S.NR        = A.ROW_NR;
    /* 속도 이슈로 Unpivot 을 UI 에서 DB 로 이전 - END */

    /* 빈라인이 추가되어 삭제 — 전극은 품목만 본다 */
    DELETE GT_SCP0104_ASGN_ALL
     WHERE DIVISION_ID   IS NULL
        OR COMPANY_ID    IS NULL
        OR SITE_ID       IS NULL
        OR PLANT_ID      IS NULL
        OR FACTORY_ID    IS NULL
        OR LINE_ID       IS NULL
        OR OPERATION_ID  IS NULL
        OR ITEM_ID       IS NULL
        OR YYYYMM        IS NULL;

    /* DUMMY_YN 로직 수정 */
    UPDATE GT_SCP0104_ASGN_ALL A
       SET A.DUMMY_YN = 'Y'
     WHERE A.SITE_ID    LIKE 'DMY_%'
        OR A.COMPANY_ID LIKE 'DMY_%'
        OR A.PLANT_ID   LIKE 'DMY_%'
        OR A.FACTORY_ID LIKE 'DMY_%'
        OR A.LINE_ID    LIKE 'DMY_%'
        OR NOT EXISTS (SELECT 1
                         FROM TABLE(FN_SCM0002_GET_CAPA_ITEM_POPUP('', '')) XA
                        WHERE XA.ITEM_ID = A.ITEM_ID
                          AND XA.ITEM_ID IS NOT NULL);

    /* 기존 Line Assign 에 존재하는 동일 라인의 설비유형 */
    INSERT INTO GT_SCP0104_EQUIP_TP_ASGN
                ( COMPANY_ID
                , DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD )
         SELECT A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , MAX(A.ELTR_LN_TP_CD)
           FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN A
              , GT_SCP0104_ASGN_ALL B
          WHERE B.COMPANY_ID  = A.COMPANY_ID
            AND B.DIVISION_ID = A.DIVISION_ID
            AND B.SITE_ID     = A.SITE_ID
            AND B.PLANT_ID    = A.PLANT_ID
            AND B.FACTORY_ID  = A.FACTORY_ID
            AND B.LINE_ID     = A.LINE_ID
          GROUP BY A.COMPANY_ID
                 , A.DIVISION_ID
                 , A.SITE_ID
                 , A.PLANT_ID
                 , A.FACTORY_ID
                 , A.LINE_ID
                 , A.OPERATION_ID;

    /* 2025.04.08 case 추가 : W/S 데이터 오류 건 수정 — 설비 기준이 먼저, 그다음 기존 배정, 없으면 S */
    UPDATE GT_SCP0104_ASGN_ALL A
       SET A.ELTR_LN_TP_CD = NVL((SELECT XA.ELTR_LN_TP_CD
                                    FROM GT_SCP0104_EQUIPMENT XA
                                   WHERE XA.COMPANY_ID   = A.COMPANY_ID
                                     AND XA.DIVISION_ID  = A.DIVISION_ID
                                     AND XA.SITE_ID      = A.SITE_ID
                                     AND XA.PLANT_ID     = A.PLANT_ID
                                     AND XA.FACTORY_ID   = A.FACTORY_ID
                                     AND XA.LINE_ID      = A.LINE_ID
                                     AND XA.OPERATION_ID = A.OPERATION_ID)
                                , NVL((SELECT XB.ELTR_LN_TP_CD
                                         FROM GT_SCP0104_EQUIP_TP_ASGN XB
                                        WHERE XB.COMPANY_ID   = A.COMPANY_ID
                                          AND XB.DIVISION_ID  = A.DIVISION_ID
                                          AND XB.SITE_ID      = A.SITE_ID
                                          AND XB.PLANT_ID     = A.PLANT_ID
                                          AND XB.FACTORY_ID   = A.FACTORY_ID
                                          AND XB.LINE_ID      = A.LINE_ID
                                          AND XB.OPERATION_ID = A.OPERATION_ID)
                                    , 'S'));

    /* 변경된 데이터만 해당 BEGIN — 전극 열쇠는 품목이다 */
    INSERT INTO GT_SCP0104_ASGN_CHG
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , SITE_NAME
                , COMPANY_NAME
                , PLANT_NAME
                , FACTORY_NAME
                , LINE_NAME
                , LANE_QTY
                , ITEM_ID
                , NICK_NAME
                , YYYYMM
                , ASSIGN_PRIORITY
                , DUMMY_YN
                , VALID_YN
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
         SELECT A.VER_ID
              , A.VER_SEQ
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.SITE_NAME
              , A.COMPANY_NAME
              , A.PLANT_NAME
              , A.FACTORY_NAME
              , A.LINE_NAME
              , A.LANE_QTY
              , A.ITEM_ID
              , A.NICK_NAME
              , A.YYYYMM
              , A.ASSIGN_PRIORITY
              , A.DUMMY_YN
              , A.VALID_YN
              , A.CREATED_BY
              , A.CREATION_DATE
              , A.LAST_UPDATED_BY
              , A.LAST_UPDATE_DATE
           FROM GT_SCP0104_ASGN_ALL A
              , SCP_MST_CAPA_ELTR_LINE_ASSIGN B
          WHERE B.DIVISION_ID(+)  = A.DIVISION_ID
            AND B.COMPANY_ID(+)   = A.COMPANY_ID
            AND B.SITE_ID(+)      = A.SITE_ID
            AND B.PLANT_ID(+)     = A.PLANT_ID
            AND B.FACTORY_ID(+)   = A.FACTORY_ID
            AND B.LINE_ID(+)      = A.LINE_ID
            AND B.OPERATION_ID(+) = A.OPERATION_ID
            AND B.ITEM_ID(+)      = A.ITEM_ID
            AND B.YYYYMM(+)       = A.YYYYMM
            AND (B.DIVISION_ID IS NULL
              OR A.VALID_YN <> B.VALID_YN
              OR NVL(A.ASSIGN_PRIORITY, 0) <> NVL(B.ASSIGN_PRIORITY, 0)
              OR A.DUMMY_YN <> B.DUMMY_YN
              OR NVL(A.LANE_QTY, 0) <> NVL(B.LANE_QTY, 0));
    /* 변경된 데이터만 해당 END */

    /* 데이터 저장 - 마스터 — 전극은 라인 유형을 묶음에서 빼고 대표값을 고른다 */
    INSERT INTO GT_SCP0104_LINE_MDL
                ( DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , SITE_NAME
                , COMPANY_NAME
                , PLANT_NAME
                , FACTORY_NAME
                , LINE_NAME
                , DUMMY_YN )
         SELECT DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , MAX(ELTR_LN_TP_CD)
              , ITEM_ID
              , NICK_NAME
              , MAX(SITE_NAME)
              , MAX(COMPANY_NAME)
              , MAX(PLANT_NAME)
              , MAX(FACTORY_NAME)
              , MAX(LINE_NAME)
              , MAX(DUMMY_YN)
           FROM GT_SCP0104_ASGN_CHG
          GROUP BY DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ITEM_ID
                 , NICK_NAME;

    /* SAVE - SCP_MST_CAPA_ELTR_LINE_MDL - BEGIN
       원문은 MERGE 한 문장이나 온라인 SQL 에서 쓰지 않는 규칙이라 고치는 문장과 넣는 문장으로 나눈다 */
    FOR R IN (SELECT DIVISION_ID
                   , COMPANY_ID
                   , SITE_ID
                   , PLANT_ID
                   , FACTORY_ID
                   , LINE_ID
                   , OPERATION_ID
                   , ELTR_LN_TP_CD
                   , ITEM_ID
                   , NICK_NAME
                   , DUMMY_YN
                FROM GT_SCP0104_LINE_MDL)
    LOOP

        UPDATE SCP_MST_CAPA_ELTR_LINE_MDL
           SET DUMMY_YN         = R.DUMMY_YN
             , ELTR_LN_TP_CD    = R.ELTR_LN_TP_CD
             , LAST_UPDATED_BY  = V_USER_ID
             , LAST_UPDATE_DATE = SYSDATE
         WHERE DIVISION_ID  = R.DIVISION_ID
           AND COMPANY_ID   = R.COMPANY_ID
           AND SITE_ID      = R.SITE_ID
           AND PLANT_ID     = R.PLANT_ID
           AND FACTORY_ID   = R.FACTORY_ID
           AND LINE_ID      = R.LINE_ID
           AND OPERATION_ID = R.OPERATION_ID
           AND ITEM_ID      = R.ITEM_ID
           AND NICK_NAME    = R.NICK_NAME;

        IF SQL%ROWCOUNT = 0 THEN

            INSERT INTO SCP_MST_CAPA_ELTR_LINE_MDL
                        ( DIVISION_ID
                        , COMPANY_ID
                        , SITE_ID
                        , PLANT_ID
                        , FACTORY_ID
                        , LINE_ID
                        , OPERATION_ID
                        , ELTR_LN_TP_CD
                        , ITEM_ID
                        , NICK_NAME
                        , DUMMY_YN
                        , CREATED_BY
                        , CREATION_DATE
                        , LAST_UPDATED_BY
                        , LAST_UPDATE_DATE )
                 VALUES ( R.DIVISION_ID
                        , R.COMPANY_ID
                        , R.SITE_ID
                        , R.PLANT_ID
                        , R.FACTORY_ID
                        , R.LINE_ID
                        , R.OPERATION_ID
                        , R.ELTR_LN_TP_CD
                        , R.ITEM_ID
                        , R.NICK_NAME
                        , R.DUMMY_YN
                        , V_USER_ID
                        , SYSDATE
                        , V_USER_ID
                        , SYSDATE );

        END IF;

    END LOOP;
    /* SAVE - SCP_MST_CAPA_ELTR_LINE_MDL - END */

    /* SAVE - SCP_MST_CAPA_ELTR_LINE_ASSIGN - BEGIN */
    FOR R IN (SELECT DIVISION_ID
                   , COMPANY_ID
                   , SITE_ID
                   , PLANT_ID
                   , FACTORY_ID
                   , LINE_ID
                   , OPERATION_ID
                   , ELTR_LN_TP_CD
                   , ITEM_ID
                   , NICK_NAME
                   , YYYYMM
                   , LANE_QTY
                   , ASSIGN_PRIORITY
                   , DUMMY_YN
                   , VALID_YN
                FROM GT_SCP0104_ASGN_CHG
               WHERE DIVISION_ID  IS NOT NULL
                 AND COMPANY_ID   IS NOT NULL
                 AND SITE_ID      IS NOT NULL
                 AND PLANT_ID     IS NOT NULL
                 AND FACTORY_ID   IS NOT NULL
                 AND LINE_ID      IS NOT NULL
                 AND OPERATION_ID IS NOT NULL
                 AND ITEM_ID      IS NOT NULL
                 AND YYYYMM       IS NOT NULL)
    LOOP

        UPDATE SCP_MST_CAPA_ELTR_LINE_ASSIGN
           SET LANE_QTY         = R.LANE_QTY
             , ASSIGN_PRIORITY  = R.ASSIGN_PRIORITY
             , DUMMY_YN         = R.DUMMY_YN
             , ELTR_LN_TP_CD    = R.ELTR_LN_TP_CD
             , VALID_YN         = R.VALID_YN
             , LAST_UPDATED_BY  = V_USER_ID
             , LAST_UPDATE_DATE = SYSDATE
         WHERE DIVISION_ID  = R.DIVISION_ID
           AND COMPANY_ID   = R.COMPANY_ID
           AND SITE_ID      = R.SITE_ID
           AND PLANT_ID     = R.PLANT_ID
           AND FACTORY_ID   = R.FACTORY_ID
           AND LINE_ID      = R.LINE_ID
           AND OPERATION_ID = R.OPERATION_ID
           AND ITEM_ID      = R.ITEM_ID
           AND YYYYMM       = R.YYYYMM;

        IF SQL%ROWCOUNT = 0 THEN

            INSERT INTO SCP_MST_CAPA_ELTR_LINE_ASSIGN
                        ( DIVISION_ID
                        , COMPANY_ID
                        , SITE_ID
                        , PLANT_ID
                        , FACTORY_ID
                        , LINE_ID
                        , OPERATION_ID
                        , ELTR_LN_TP_CD
                        , ITEM_ID
                        , NICK_NAME
                        , YYYYMM
                        , LANE_QTY
                        , ASSIGN_PRIORITY
                        , DUMMY_YN
                        , VALID_YN
                        , CREATED_BY
                        , CREATION_DATE
                        , LAST_UPDATED_BY
                        , LAST_UPDATE_DATE )
                 VALUES ( R.DIVISION_ID
                        , R.COMPANY_ID
                        , R.SITE_ID
                        , R.PLANT_ID
                        , R.FACTORY_ID
                        , R.LINE_ID
                        , R.OPERATION_ID
                        , R.ELTR_LN_TP_CD
                        , R.ITEM_ID
                        , R.NICK_NAME
                        , R.YYYYMM
                        , R.LANE_QTY
                        , R.ASSIGN_PRIORITY
                        , R.DUMMY_YN
                        , R.VALID_YN
                        , V_USER_ID
                        , SYSDATE
                        , V_USER_ID
                        , SYSDATE );

        END IF;

    END LOOP;
    /* SAVE - SCP_MST_CAPA_ELTR_LINE_ASSIGN - END */

    /* 더미 데이터 정리 — 배정 어디에도 쓰이지 않는 더미 코드를 없앤다
       원문은 큰 원장을 LEFT JOIN 세 번 하는 한 문장이나, 그대로 옮기면 더미 코드 한 행마다
       원장을 다시 훑어 오래 걸린다. 쓰이는 코드를 먼저 한 번 모아 두고 견준다 */
    DELETE GT_SCP0104_DUMMY_LIVE;

    INSERT INTO GT_SCP0104_DUMMY_LIVE
                ( SRC_TP
                , CODE_TP
                , VAL )
         SELECT 'ASM'
              , CODE_TP
              , CODE
           FROM (SELECT 'S' AS CODE_TP, SITE_ID    AS CODE FROM SCP_MST_CAPA_LINE_ASSIGN
                 UNION ALL
                 SELECT 'S' AS CODE_TP, SITE_ID    AS CODE FROM SCP_MST_CAPA_LINE_ASSIGN_CUTF
                 UNION ALL
                 SELECT 'C' AS CODE_TP, COMPANY_ID AS CODE FROM SCP_MST_CAPA_LINE_ASSIGN
                 UNION ALL
                 SELECT 'P' AS CODE_TP, PLANT_ID   AS CODE FROM SCP_MST_CAPA_LINE_ASSIGN
                 UNION ALL
                 SELECT 'P' AS CODE_TP, PLANT_ID   AS CODE FROM SCP_MST_CAPA_LINE_ASSIGN_CUTF
                 UNION ALL
                 SELECT 'F' AS CODE_TP, FACTORY_ID AS CODE FROM SCP_MST_CAPA_LINE_ASSIGN
                 UNION ALL
                 SELECT 'F' AS CODE_TP, FACTORY_ID AS CODE FROM SCP_MST_CAPA_LINE_ASSIGN_CUTF
                 UNION ALL
                 SELECT 'L' AS CODE_TP, LINE_ID    AS CODE FROM SCP_MST_CAPA_LINE_ASSIGN
                 UNION ALL
                 SELECT 'L' AS CODE_TP, LINE_ID    AS CODE FROM SCP_MST_CAPA_LINE_ASSIGN_CUTF) IA
          GROUP BY CODE_TP
                 , CODE;

    INSERT INTO GT_SCP0104_DUMMY_LIVE
                ( SRC_TP
                , CODE_TP
                , VAL )
         SELECT 'ELT'
              , CODE_TP
              , CODE
           FROM (SELECT 'S' AS CODE_TP, SITE_ID    AS CODE FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN
                 UNION ALL
                 SELECT 'S' AS CODE_TP, SITE_ID    AS CODE FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF
                 UNION ALL
                 SELECT 'C' AS CODE_TP, COMPANY_ID AS CODE FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN
                 UNION ALL
                 SELECT 'P' AS CODE_TP, PLANT_ID   AS CODE FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN
                 UNION ALL
                 SELECT 'P' AS CODE_TP, PLANT_ID   AS CODE FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF
                 UNION ALL
                 SELECT 'F' AS CODE_TP, FACTORY_ID AS CODE FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN
                 UNION ALL
                 SELECT 'F' AS CODE_TP, FACTORY_ID AS CODE FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF
                 UNION ALL
                 SELECT 'L' AS CODE_TP, LINE_ID    AS CODE FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN
                 UNION ALL
                 SELECT 'L' AS CODE_TP, LINE_ID    AS CODE FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF) IB
          GROUP BY CODE_TP
                 , CODE;

    INSERT INTO GT_SCP0104_DUMMY_LIVE
                ( SRC_TP
                , CODE_TP
                , VAL )
         SELECT 'NAM'
              , CODE_TP
              , NAME
           FROM (SELECT 'N' AS CODE_TP, NICK_NAME AS NAME FROM SCP_MST_CAPA_LINE_ASSIGN
                 UNION ALL
                 SELECT 'N' AS CODE_TP, NICK_NAME AS NAME FROM SCP_MST_CAPA_LINE_ASSIGN_CUTF
                 UNION ALL
                 SELECT 'I' AS CODE_TP, ITEM_ID   AS NAME FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN
                 UNION ALL
                 SELECT 'I' AS CODE_TP, ITEM_ID   AS NAME FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF) IC
          GROUP BY CODE_TP
                 , NAME;

    DELETE SCP_MST_CAPA_DUMMY_CODE A
     WHERE NOT EXISTS (SELECT 1
                         FROM GT_SCP0104_DUMMY_LIVE XA
                        WHERE XA.SRC_TP  = 'ASM'
                          AND XA.CODE_TP = A.CODE_TP
                          AND XA.VAL     = A.CODE
                          AND TRIM(XA.VAL) IS NOT NULL)
       AND NOT EXISTS (SELECT 1
                         FROM GT_SCP0104_DUMMY_LIVE XB
                        WHERE XB.SRC_TP  = 'ELT'
                          AND XB.CODE_TP = A.CODE_TP
                          AND XB.VAL     = A.CODE
                          AND TRIM(XB.VAL) IS NOT NULL)
       AND NOT EXISTS (SELECT 1
                         FROM GT_SCP0104_DUMMY_LIVE XC
                        WHERE XC.SRC_TP  = 'NAM'
                          AND XC.CODE_TP = A.CODE_TP
                          AND XC.VAL     = A.NAME
                          AND TRIM(XC.VAL) IS NOT NULL);
    /* 더미 데이터 정리 - END */

    /* 뒤따르는 검증 프로시저에 넘길 열쇠 */
    INSERT INTO GT_SCP_CAPA_LINE_ASSIGN_KEYS
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , YYYYMM
                , ASSIGN_PRIORITY
                , LANE_QTY
                , DUMMY_YN
                , VALID_YN
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
         SELECT VER_ID
              , VER_SEQ
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , ITEM_ID
              , NICK_NAME
              , YYYYMM
              , ASSIGN_PRIORITY
              , LANE_QTY
              , DUMMY_YN
              , VALID_YN
              , CREATED_BY
              , CREATION_DATE
              , LAST_UPDATED_BY
              , LAST_UPDATE_DATE
           FROM GT_SCP0104_ASGN_CHG;

    SELECT COUNT(*)
      INTO V_UPDATED_CNT
      FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS;

    /* 데이터 저장 - Speed Plan */
    IF V_UPDATED_CNT > 0 THEN

        P_SCP0105_CHK_SPEED_ASGN_ELTR('SCP0105', 'ELTR', V_USER_ID, TO_CHAR(P_DEBUG_MODE));

    END IF;

    /* 데이터 저장 - Loss Plan */
    P_SCP0106_CHK_LOSS_ASGN_ELTR('SCP0106', 'CURRENT_ELTR', V_USER_ID, TO_CHAR(P_DEBUG_MODE));

    OPEN O_RC1 FOR
        SELECT V_RESULT_CD  AS RESULT_CD
             , V_RESULT_CD  AS RESULT_CODE   /* AJS 20261007 화면검증 */
             , V_RESULT_MSG AS RESULT_MSG
          FROM DUAL;

    OPEN O_RC2 FOR
        SELECT V_RESULT_CD  AS RESULT_CD
             , V_RESULT_CD  AS RESULT_CODE   /* AJS 20261007 화면검증 */
             , V_RESULT_MSG AS RESULT_MSG
          FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN

        ROLLBACK TO SP_SCP0104_SAVE_ASGN_ELTR;

        V_RESULT_CD  := 'F';
        V_RESULT_MSG := '[' || SQLCODE || ']' || SUBSTR(SQLERRM, 1, 3000);

        OPEN O_RC1 FOR
            SELECT V_RESULT_CD  AS RESULT_CD
                 , V_RESULT_CD  AS RESULT_CODE   /* AJS 20261007 화면검증 */
                 , V_RESULT_MSG AS RESULT_MSG
              FROM DUAL;

        OPEN O_RC2 FOR
            SELECT V_RESULT_CD  AS RESULT_CD
                 , V_RESULT_CD  AS RESULT_CODE   /* AJS 20261007 화면검증 */
                 , V_RESULT_MSG AS RESULT_MSG
              FROM DUAL;

END P_SCP0104_SAVE_CAPA_LINE_ASSIGN_ELTR;

END PKG_SCP0104;
