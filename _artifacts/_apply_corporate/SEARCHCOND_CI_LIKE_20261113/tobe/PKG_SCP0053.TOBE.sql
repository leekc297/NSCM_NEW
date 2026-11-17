-- SOURCE-FRESH: SCM_MGR.PKG_SCP0053 PACKAGE BODY LAST_DDL=2026-10-14 17:19:36 FETCHED=2026-11-13 10:54:25 DB=ZIOUI1
CREATE OR REPLACE PACKAGE BODY PKG_SCP0053 IS


/****************************************************************************************************

 * Program ID   : PR_SCM_MST_ALTER_BOM_H

 * Description  : Tac TIme Master History

 * Program History

 *===================================================================================================

 *   Date       In Charge			Description

 *===================================================================================================

 * 2021.03.19   PJG                 Initial Release  (PJ20209642 Digital SCM Level.3 달성을 위한 개선)

 * 2022-07-25   jahn1501            PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 변경된 SCPYN 다건 조회 / Plant Id 조건 제외.

 * 2022-10-25   jahn1501   		PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - p_si_alt_priority, p_si_scp_yn, ATTRIBUTE11 ~ 20 추가

 * 2026.09.22   ZIONEX          [PJ202650304] MSSQL -> Oracle 전환

 ****************************************************************************************************/

    PROCEDURE P_SCM_MST_ALTER_BOM_H (

        P_DIVISION_ID       IN VARCHAR2

      , P_PLANT_CD          IN VARCHAR2

      , P_MODEL_ID          IN VARCHAR2

      , P_PARENT_ITEM_ID    IN VARCHAR2

      , P_CHILD_ITEM_ID     IN VARCHAR2

      , P_ALT_ID            IN VARCHAR2

      , P_EFF_START_DATE    IN VARCHAR2

      , P_EFF_END_DATE      IN VARCHAR2

      , P_ECO_CODE          IN VARCHAR2

      , P_SCP_YN            IN VARCHAR2

      , P_SI_ALT_PRIORITY   IN VARCHAR2

      , P_SI_SCP_YN         IN VARCHAR2

      , P_CREATION_DATE     IN DATE

      , P_LAST_UPDATED_BY   IN VARCHAR2

    )

    IS

        V_HISTORY_SEQ NUMBER;

    BEGIN



        SELECT SEQ1_SCP_MST_ALTER_BOM_H.NEXTVAL

          INTO V_HISTORY_SEQ

          FROM DUAL;



        INSERT INTO SCM_MST_ALTER_BOM_H

             ( HISTORY_SEQ

             , DIVISION_ID

             , PLANT_ID

             , PARENT_ITEM_ID

             , CHILD_ITEM_ID

             , ALT_ID

             , EFF_START_DATE

             , EFF_END_DATE

             , ECO_CODE

             , SCP_PLAN_YN

             , CREATION_DATE

             , LAST_UPDATED_BY

             , CREATION_BY

             , SITE_ID

             , BOM_VERSION_ID

             , KEY_DATE

             , PARENT_QTY

             , PARENT_UOM

             , CHILD_QTY

             , CHILD_UOM

             , ALT_PRIORITY

             , ALT_RATE

             , COMMON_CELL_YN

             , CHILD_ITEM_TYPE

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

             , ATTRIBUTE16

             , ATTRIBUTE17

             , ATTRIBUTE18

             , ATTRIBUTE19

             , ATTRIBUTE20

             , OLD_SCP_PLAN_YN )

        SELECT V_HISTORY_SEQ

             , P_DIVISION_ID

             , PLANT_ID

             , P_PARENT_ITEM_ID

             , P_CHILD_ITEM_ID

             , P_ALT_ID

             , CASE WHEN P_EFF_START_DATE IS NULL THEN NULL

                    ELSE TO_DATE(SUBSTR(P_EFF_START_DATE, 1, 8), 'FXYYYYMMDD')

               END

             , CASE WHEN P_EFF_END_DATE IS NULL THEN NULL

                    ELSE TO_DATE(SUBSTR(P_EFF_END_DATE, 1, 8), 'FXYYYYMMDD')

               END

             , P_ECO_CODE

             , P_SCP_YN

             , P_CREATION_DATE

             , P_LAST_UPDATED_BY

             , CREATION_BY

             , SITE_ID

             , BOM_VERSION_ID

             , KEY_DATE

             , PARENT_QTY

             , PARENT_UOM

             , CHILD_QTY

             , CHILD_UOM

             , ALT_PRIORITY

             , ALT_RATE

             , COMMON_CELL_YN

             , CHILD_ITEM_TYPE

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

             , P_SI_ALT_PRIORITY

             , P_SI_SCP_YN

             , ATTRIBUTE13

             , ATTRIBUTE14

             , ATTRIBUTE15

             , ATTRIBUTE16

             , ATTRIBUTE17

             , ATTRIBUTE18

             , ATTRIBUTE19

             , ATTRIBUTE20

             , SCP_PLAN_YN

          FROM SCM_MST_ALTER_BOM

         WHERE DIVISION_ID    = P_DIVISION_ID

				   --AND PLANT_ID         = @p_plant_cd

           AND PARENT_ITEM_ID = P_PARENT_ITEM_ID

           AND CHILD_ITEM_ID  = P_CHILD_ITEM_ID;



    END P_SCM_MST_ALTER_BOM_H;



/****************************************************************************************************

 * Program ID   : SCP0053_GET_SCP_BOM

 * Description  : SCP BOM 조회

 * Program History

 *===================================================================================================

 *   Date       In Charge		Description

 *===================================================================================================

 * 2021/03/11   PJG                     Initial Release (PJ20209642 Digital SCM Level.3 달성을 위한 개선)

 * 2021/04/30   PJG                     MODEL_NAME, PARENT_ITEM_NAME, CHILD_ITEM_NAME 을 NICK_NAME 으로 변경

 * 2022/10/25   jahn1501   		        PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Simulator Alt Priority, Simulator SCP YN 컬럼 추가

 * 2023/06/15   chaan			V1.1.1  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 활성화 코드 분리

 * 2025.08.01   hrkim					PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경

 * 2026.09.22   ZIONEX          [PJ202650304] MSSQL -> Oracle 전환

 * 2026.10.06   AJS             조회 속도 개선 - Alter BOM 조회 시 모델별 대체 BOM 행 중복 제거 후 BOM 원장을 하위품목·플랜트 인덱스로 읽음(결과 동일)

 * 2026.10.07   AJS             조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시

 * 2026.10.08   AJS             Model/Nickname 후속 : Model 'ALL'·공백은 조건 없음 · 일반(ALL) 조회 모델 지정 시 후보 모델부터 BOM 원장을 읽음(결과 동일)

 * 2026.10.08   AJS             조회 속도 개선 - 일반(ALL) 조회 모델 비움 : 품목명을 사업부 품목 원장 1회 읽기로 · 상위품목 조건을 같은 읽기에서 판정 · BOM 원장 조회 사업부 한정(결과 동일)

 ****************************************************************************************************/

    PROCEDURE P_SCP0053_GET_SCP_BOM (

        P_DIVISION_ID   IN  VARCHAR2

      , P_PLANT_SITE_ID IN  VARCHAR2

      , P_MODEL_ID      IN  VARCHAR2

      , P_PARENT_ID     IN  VARCHAR2

      , P_CHILD_ID      IN  VARCHAR2

      , P_ALTER_BOM     IN  VARCHAR2

      , P_DEBUG_MODE    IN  VARCHAR2 DEFAULT 'F'

      , O_RC            OUT SYS_REFCURSOR

      , O_RESULT_CURSOR OUT SYS_REFCURSOR

    )

    IS

        /* 원본 MSSQL 은 대소문자를 가리지 않고 비교한다. 원장 칸에는 소문자가 없으므로 인자만 대문자로 맞춘다 */

        V_DIVISION_ID   VARCHAR2(4000 CHAR) := UPPER(P_DIVISION_ID);

        V_PLANT_SITE_ID VARCHAR2(4000 CHAR) := UPPER(P_PLANT_SITE_ID);

        V_MODEL_ID      VARCHAR2(4000 CHAR) := UPPER(P_MODEL_ID);

        V_PARENT_ID     VARCHAR2(4000 CHAR) := UPPER(P_PARENT_ID);

        V_CHILD_ID      VARCHAR2(4000 CHAR) := UPPER(P_CHILD_ID);

        V_ALTER_BOM     VARCHAR2(4000 CHAR) := UPPER(P_ALTER_BOM);

        V_MODEL_TAB     T_STR_TAB           := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 모델 */

    BEGIN



        /* 2026.10.08 AJS Model/Nickname : Model 칸 'ALL'(대소문자 무시) 또는 공백은 조건 없음 — 후보 모델을 만들기 전에 판정 */

        IF TRIM(P_MODEL_ID) IS NULL OR UPPER(TRIM(P_MODEL_ID)) = 'ALL' THEN   /* AJS 20261008 Model/Nickname */

            V_MODEL_ID := NULL;   /* AJS 20261008 Model/Nickname */

        END IF;   /* AJS 20261008 Model/Nickname */



        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력 토큰(쉼표 구분)이 코드 또는 닉네임에 부분일치하는 모델을 먼저 고른다

           대상 = 조회 사업부 품목 원장 품목(코드 · 닉네임) + 입력 토큰 그대로(품목 원장에 없는 모델의 정확일치 보존)

           BOM 원장에서 사업부 전체 모델을 모으는 것은 40 · 81 에서 90 초를 넘겨 쓰지 않는다 */

        IF V_MODEL_ID IS NOT NULL THEN

            SELECT XA.ITEM_ID

              BULK COLLECT INTO V_MODEL_TAB

              FROM SCM_MST_ITEM_SN XA

                 , TABLE(STRING_SPLIT(V_MODEL_ID, ',')) SA

             WHERE SA.COLUMN_VALUE IS NOT NULL

               AND XA.DIVISION_ID = V_DIVISION_ID

               AND (   UPPER(XA.ITEM_ID)   LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'

                    OR UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%')

            UNION

            SELECT UPPER(XB.COLUMN_VALUE)

              FROM TABLE(STRING_SPLIT(V_MODEL_ID, ',')) XB

             WHERE XB.COLUMN_VALUE IS NOT NULL;

        END IF;

        /* 2026.10.07 AJS Model/Nickname 검색 (END) */



	-- ALTER BOM 에 해당하는 것만 검색시

        IF (V_ALTER_BOM = 'ALTER') THEN



            OPEN O_RC FOR

            SELECT IA.DIVISION_ID

                 , IA.SITE_ID

                 , IA.PLANT_ID

                 , IA.MODEL_ID

                 , (SELECT XB.NICK_NAME

                      FROM (SELECT NVL(TRIM(NICK_NAME), '-') AS NICK_NAME

                              FROM SCM_MST_ITEM_SN

                             WHERE DIVISION_ID = IA.DIVISION_ID

                               AND ITEM_ID     = IA.MODEL_ID) XB

                     WHERE ROWNUM = 1)                        AS MODEL_NAME

                 , IA.PARENT_ITEM_ID

                 , (SELECT XC.NICK_NAME

                      FROM (SELECT NVL(TRIM(NICK_NAME), '-') AS NICK_NAME

                              FROM SCM_MST_ITEM_SN

                             WHERE DIVISION_ID = IA.DIVISION_ID

                               AND ITEM_ID     = IA.PARENT_ITEM_ID) XC

                     WHERE ROWNUM = 1)                        AS PARENT_ITEM_NAME

                 , IA.CHILD_ITEM_ID

                 , (SELECT XD.NICK_NAME

                      FROM (SELECT NVL(TRIM(NICK_NAME), '-') AS NICK_NAME

                              FROM SCM_MST_ITEM_SN

                             WHERE DIVISION_ID = IA.DIVISION_ID

                               AND ITEM_ID     = IA.CHILD_ITEM_ID) XD

                     WHERE ROWNUM = 1)                        AS CHILD_ITEM_NAME

                 , MIN(IA.SORT_ORDER)                         AS SORT_ORDER

                 , XA.ALT_ID

                 , XA.ALT_PRIORITY

                 , XA.EFF_START_DATE

                 , XA.EFF_END_DATE

                 , SA.SCP_PLAN_YN

                 , SA.COMMON_CELL_YN

                 , XA.ECO_CODE

                 , IA.NLEVEL

                 , FLOOR(TO_NUMBER(SA.ATTRIBUTE11))           AS SI_ALT_PRIORITY

                 , SA.ATTRIBUTE12                             AS SI_SCP_YN

--            FROM (SELECT A.DIVISION_ID  --  2026.10.06 AJS

              FROM (SELECT /*+ LEADING(B) USE_NL(A) INDEX(A IDX1_SCM_MODEL_COMP_TEMP) */ A.DIVISION_ID  --  2026.10.06 AJS

                         , A.SITE_ID

                         , A.PLANT_ID

                         , A.MODEL_ID

                         , A.PARENT_ITEM_ID

                         , A.CHILD_ITEM_ID

                         , MIN(A.CHILD_QTY)             AS CHILD_QTY

                         , MIN(A.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY

                         , MIN(A.SORT_ORDER)            AS SORT_ORDER

                         , TRUNC(MIN(A.NLEVEL))         AS NLEVEL

                      /* 원문의 SCM_MST_ITEM_SN 외부조인(사업부·사이트만으로 연결)은 결과에 쓰이지 않아 제거 */

                      /* , MIN(B.SCP_OPERATION_GROUP) AS SCP_OPERATION_GROUP */

                      /* , MIN(B.SCP_FLOW_ID)         AS SCP_FLOW_ID         */

                      FROM SCM_MST_BOM_SN             A

                         -- 2026.10.06 AJS 대체 BOM 모델 행 중복 제거 (START)

--                       , SCM_MST_ALTER_BOM_MODEL    B

                         /* 대체 BOM 모델 원장은 모델마다 한 행이라 같은 (사업부 · 사이트 · 플랜트 · 상위 · 하위)가 여러 번 나온다(82 : 1,975 행 / 181 쌍).

                            이 조인은 BOM 원장 행을 거르는 데만 쓰고 결과는 MIN 집계 · GROUP BY 이므로 중복을 없애도 결과가 같다.

                            조회 사업부 밖의 행은 아래 XA(조회 사업부 BOM) 조인에서 빠지므로 여기서 미리 사업부로 거른다.

                            BOM 원장은 (하위품목 · 플랜트) 인덱스로 읽는다(원래 (사업부 · 상위품목) 인덱스는 상위품목의 모든 모델 행을 읽었다) */

                         , (SELECT /*+ NO_MERGE */

                                   DISTINCT

                                   XB.DIVISION_ID

                                 , XB.SITE_ID

                                 , XB.PLANT_ID

                                 , XB.PARENT_ITEM_ID

                                 , XB.CHILD_ITEM_ID

                              FROM SCM_MST_ALTER_BOM_MODEL XB

                             WHERE XB.DIVISION_ID = V_DIVISION_ID) B

                         -- 2026.10.06 AJS 대체 BOM 모델 행 중복 제거 (END)

                         , (SELECT DISTINCT ITEM_ID

                              FROM SCM_MST_ITEM_SN

                             WHERE DIVISION_ID          = V_DIVISION_ID

                               AND SCP_OPERATION_GROUP IN ('P', 'A')) IB

                         , (SELECT DISTINCT ITEM_ID

                              FROM SCM_MST_ITEM_SN

                             WHERE DIVISION_ID = V_DIVISION_ID

                               AND (SCP_OPERATION_GROUP = 'P'

                                OR (SCP_OPERATION_GROUP = 'A'

                               AND SCP_FLOW_ID IN (SELECT SEGMENT1

                                                     FROM SCM_ADM_LOOKUP_MASTER_DETAIL

                                                    WHERE LOOKUP_TYPE = 'SCP_PLAN_OPERATION'

                                                      AND SEGMENT3    = 'A'    /* 공정그룹(Cell) */

                                                      AND ATTRIBUTE1  = 'Y'))) /* FInal Operation */

                                                                       ) IC

                     WHERE A.DIVISION_ID    = B.DIVISION_ID

                       AND A.SITE_ID        = B.SITE_ID

                       AND A.PLANT_ID       = B.PLANT_ID

                       AND A.PARENT_ITEM_ID = B.PARENT_ITEM_ID

                       AND A.CHILD_ITEM_ID  = B.CHILD_ITEM_ID

                       AND A.PARENT_ITEM_ID = IB.ITEM_ID

                       AND A.CHILD_ITEM_ID  = IC.ITEM_ID

                       AND (V_PLANT_SITE_ID IS NULL

                        OR  B.PLANT_ID IN (SELECT COLUMN_VALUE

                                             FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))))

                       AND ((V_MODEL_ID IS NULL AND V_PARENT_ID IS NULL AND V_CHILD_ID IS NULL)

                        OR  (UPPER(B.PARENT_ITEM_ID) IN (V_MODEL_ID, V_PARENT_ID, V_CHILD_ID))   /* 2026.11.13 조회조건 대소문자 무시 */

                        OR  (UPPER(B.CHILD_ITEM_ID)  IN (V_MODEL_ID, V_PARENT_ID, V_CHILD_ID)))   /* 2026.11.13 조회조건 대소문자 무시 */

                       AND (V_PLANT_SITE_ID IS NULL

                        OR  A.PLANT_ID IN (SELECT COLUMN_VALUE

                                             FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))))

--                     AND (V_MODEL_ID  IS NULL OR A.MODEL_ID       = V_MODEL_ID)   --  2026.10.07 AJS

                       AND (V_MODEL_ID  IS NULL OR A.MODEL_ID       IN (SELECT XT.COLUMN_VALUE FROM TABLE(V_MODEL_TAB) XT))   --  2026.10.07 AJS

                       AND (V_PARENT_ID IS NULL OR UPPER(A.PARENT_ITEM_ID) = V_PARENT_ID)   /* 2026.11.13 조회조건 대소문자 무시 */

                       AND (V_CHILD_ID  IS NULL OR UPPER(A.CHILD_ITEM_ID)  = V_CHILD_ID)   /* 2026.11.13 조회조건 대소문자 무시 */

                       AND A.PARENT_ITEM_ID <> '*'

                     GROUP BY A.DIVISION_ID

                            , A.SITE_ID

                            , A.PLANT_ID

                            , A.MODEL_ID

                            , A.PARENT_ITEM_ID

                            , A.CHILD_ITEM_ID) IA

                 , (SELECT D.DIVISION_ID

                         , D.SITE_ID

                         , D.PLANT_ID

                         , D.PARENT_ITEM_ID

                         , D.CHILD_ITEM_ID

                         , D.EFF_START_DATE

                         , D.EFF_END_DATE

                         , D.ALT_ID

                         , D.ECO_CODE

                         , TRUNC(D.ALT_PRIORITY) AS ALT_PRIORITY

                         , ROW_NUMBER() OVER (PARTITION BY D.DIVISION_ID

                                                         , D.SITE_ID

                                                         , D.PLANT_ID

                                                         , D.PARENT_ITEM_ID

                                                         , D.CHILD_ITEM_ID

                                                  ORDER BY D.KEY_DATE DESC

                                                         , D.BOM_VERSION_ID) AS SEQ /* 최신 KEY_DATE */

                      FROM SCM_MST_BOM_ENG_SN D

                     WHERE D.DIVISION_ID   = V_DIVISION_ID

                       AND D.EFF_END_DATE  > FN_NEXT_DAY(SYSDATE, 'MON') - 7) XA

                 , (SELECT E.DIVISION_ID

                         , E.PLANT_ID

                         , E.PARENT_ITEM_ID

                         , E.CHILD_ITEM_ID

                         , E.ALT_ID

                         , E.ALT_PRIORITY

                         , E.SCP_PLAN_YN

                         , E.COMMON_CELL_YN

                         , E.ATTRIBUTE11

                         , E.ATTRIBUTE12

                      FROM SCM_MST_ALTER_BOM E

                     WHERE (V_PARENT_ID IS NULL OR UPPER(E.PARENT_ITEM_ID) = V_PARENT_ID)   /* 2026.11.13 조회조건 대소문자 무시 */

                       AND (V_CHILD_ID  IS NULL OR UPPER(E.CHILD_ITEM_ID)  = V_CHILD_ID)) SA   /* 2026.11.13 조회조건 대소문자 무시 */

             WHERE IA.DIVISION_ID    = XA.DIVISION_ID

               AND IA.SITE_ID        = XA.SITE_ID

               AND IA.PARENT_ITEM_ID = XA.PARENT_ITEM_ID

               AND IA.CHILD_ITEM_ID  = XA.CHILD_ITEM_ID

               AND XA.SEQ            = 1

               AND IA.DIVISION_ID    = SA.DIVISION_ID(+)

               AND IA.PLANT_ID       = SA.PLANT_ID(+)

               AND IA.PARENT_ITEM_ID = SA.PARENT_ITEM_ID(+)

               AND IA.CHILD_ITEM_ID  = SA.CHILD_ITEM_ID(+)

               AND XA.ALT_ID         = SA.ALT_ID(+)

               AND XA.ALT_PRIORITY   = SA.ALT_PRIORITY(+)

               AND SA.SCP_PLAN_YN   IS NOT NULL

             GROUP BY IA.DIVISION_ID

                    , IA.SITE_ID

                    , IA.PLANT_ID

                    , IA.MODEL_ID

                    , IA.PARENT_ITEM_ID

                    , IA.CHILD_ITEM_ID

                    , XA.ALT_ID

                    , XA.ALT_PRIORITY

                    , XA.EFF_START_DATE

                    , XA.EFF_END_DATE

                    , SA.SCP_PLAN_YN

                    , SA.COMMON_CELL_YN

                    , XA.ECO_CODE

                    , IA.NLEVEL

                    , SA.ATTRIBUTE11

                    , SA.ATTRIBUTE12

             /* 원본 데이터베이스 정렬은 하이픈을 무시하고 빈 값을 앞에 둔다 */

             ORDER BY IA.SITE_ID

                    , IA.PLANT_ID

                    , REPLACE(IA.MODEL_ID, '-', '')

                    , IA.MODEL_ID

                    , IA.NLEVEL

                    , REPLACE(IA.PARENT_ITEM_ID, '-', '')

                    , IA.PARENT_ITEM_ID

                    , XA.ALT_ID NULLS FIRST

                    , XA.ALT_PRIORITY NULLS FIRST

                    , REPLACE(IA.CHILD_ITEM_ID, '-', '')

                    , IA.CHILD_ITEM_ID;



	-- 모델/PARENT/CHILD 검색시

        ELSIF (V_ALTER_BOM = 'ALL') THEN



            /* 2026.10.08 AJS Model/Nickname : 모델 지정 여부로 문장을 나눔

               모델 비움 = 기존 문장 그대로

               모델 지정 = 후보 모델 목록 → BOM 원장 (모델 · 하위품목) 인덱스로 읽음.

                           기존 문장은 「모델 비움 또는 후보 목록 안」 조건이 하위품목 인덱스로 사업부 BOM 을 다 읽은 뒤에야 걸려

                           81 정확 코드 1건이 수백 초 걸림. 사업부 조건은 아래 XA(조회 사업부 BOM) 조인과 같은 뜻이라 결과 동일 */

            IF V_MODEL_ID IS NULL THEN   /* AJS 20261008 Model/Nickname */



            OPEN O_RC FOR

            /* 2026.10.08 AJS 속도 : 모델 비움 일반 모드 — 품목명 3개를 행마다 품목 원장에서 찾던 것을 사업부 품목 원장 1회 읽기로 바꿈

               · 상위품목 조건(SCP 공정그룹 P · A 품목)은 같은 품목 원장 읽기에서 판정해 묶음 뒤 HAVING 으로 거름(상위품목은 묶음 열쇠라 앞에서 거르는 것과 결과 같음)

               · IA 는 조회 사업부 행만 읽음(바깥 XA 조인이 조회 사업부만 남기는 것과 같은 뜻) · SA 는 해시 조인 */

            SELECT /*+ NO_PUSH_PRED(IT) USE_HASH(IT) */ IR.DIVISION_ID   /* AJS 20261008 속도 */

                 , IR.SITE_ID   /* AJS 20261008 속도 */

                 , IR.PLANT_ID   /* AJS 20261008 속도 */

                 , IR.MODEL_ID   /* AJS 20261008 속도 */

                 , MAX(DECODE(IK.NO, 1, IT.NICK_NAME))         AS MODEL_NAME   /* AJS 20261008 속도 */

                 , IR.PARENT_ITEM_ID   /* AJS 20261008 속도 */

                 , MAX(DECODE(IK.NO, 2, IT.NICK_NAME))         AS PARENT_ITEM_NAME   /* AJS 20261008 속도 */

                 , IR.CHILD_ITEM_ID   /* AJS 20261008 속도 */

                 , MAX(DECODE(IK.NO, 3, IT.NICK_NAME))         AS CHILD_ITEM_NAME   /* AJS 20261008 속도 */

                 , IR.SORT_ORDER   /* AJS 20261008 속도 */

                 , IR.ALT_ID   /* AJS 20261008 속도 */

                 , IR.ALT_PRIORITY   /* AJS 20261008 속도 */

                 , IR.EFF_START_DATE   /* AJS 20261008 속도 */

                 , IR.EFF_END_DATE   /* AJS 20261008 속도 */

                 , IR.SCP_PLAN_YN   /* AJS 20261008 속도 */

                 , IR.COMMON_CELL_YN   /* AJS 20261008 속도 */

                 , IR.ECO_CODE   /* AJS 20261008 속도 */

                 , IR.NLEVEL   /* AJS 20261008 속도 */

                 , IR.SI_ALT_PRIORITY   /* AJS 20261008 속도 */

                 , IR.SI_SCP_YN   /* AJS 20261008 속도 */

              FROM (SELECT /*+ NO_PUSH_PRED(SA) USE_HASH(SA) */ IA.DIVISION_ID   /* AJS 20261008 속도 */

                         , IA.SITE_ID   /* AJS 20261008 속도 */

                         , IA.PLANT_ID   /* AJS 20261008 속도 */

                         , IA.MODEL_ID   /* AJS 20261008 속도 */

                         , IA.PARENT_ITEM_ID   /* AJS 20261008 속도 */

                         , IA.CHILD_ITEM_ID   /* AJS 20261008 속도 */

            /* 원래 선택 목록(품목명 하위 질의 3개) — 바깥 IR · IT 로 대체

            SELECT IA.DIVISION_ID

                 , IA.SITE_ID

                 , IA.PLANT_ID

                 , IA.MODEL_ID

                 , (SELECT XB.NICK_NAME

                      FROM (SELECT NVL(TRIM(NICK_NAME), '-') AS NICK_NAME

                              FROM SCM_MST_ITEM_SN

                             WHERE DIVISION_ID = IA.DIVISION_ID

                               AND ITEM_ID     = IA.MODEL_ID) XB

                     WHERE ROWNUM = 1)                        AS MODEL_NAME

                 , IA.PARENT_ITEM_ID

                 , (SELECT XC.NICK_NAME

                      FROM (SELECT NVL(TRIM(NICK_NAME), '-') AS NICK_NAME

                              FROM SCM_MST_ITEM_SN

                             WHERE DIVISION_ID = IA.DIVISION_ID

                               AND ITEM_ID     = IA.PARENT_ITEM_ID) XC

                     WHERE ROWNUM = 1)                        AS PARENT_ITEM_NAME

                 , IA.CHILD_ITEM_ID

                 , (SELECT XD.NICK_NAME

                      FROM (SELECT NVL(TRIM(NICK_NAME), '-') AS NICK_NAME

                              FROM SCM_MST_ITEM_SN

                             WHERE DIVISION_ID = IA.DIVISION_ID

                               AND ITEM_ID     = IA.CHILD_ITEM_ID) XD

                     WHERE ROWNUM = 1)                        AS CHILD_ITEM_NAME

                 , MIN(IA.SORT_ORDER)                         AS SORT_ORDER

                 , XA.ALT_ID

                 , XA.ALT_PRIORITY

                 , XA.EFF_START_DATE

                 , XA.EFF_END_DATE

                 , SA.SCP_PLAN_YN

                 , SA.COMMON_CELL_YN

                 , XA.ECO_CODE

                 , IA.NLEVEL

                 , SA.ATTRIBUTE11                             AS SI_ALT_PRIORITY

                 , SA.ATTRIBUTE12                             AS SI_SCP_YN

            */

                 , MIN(IA.SORT_ORDER)                         AS SORT_ORDER   /* AJS 20261008 속도 */

                 , XA.ALT_ID   /* AJS 20261008 속도 */

                 , XA.ALT_PRIORITY   /* AJS 20261008 속도 */

                 , XA.EFF_START_DATE   /* AJS 20261008 속도 */

                 , XA.EFF_END_DATE   /* AJS 20261008 속도 */

                 , SA.SCP_PLAN_YN   /* AJS 20261008 속도 */

                 , SA.COMMON_CELL_YN   /* AJS 20261008 속도 */

                 , XA.ECO_CODE   /* AJS 20261008 속도 */

                 , IA.NLEVEL   /* AJS 20261008 속도 */

                 , SA.ATTRIBUTE11                             AS SI_ALT_PRIORITY   /* AJS 20261008 속도 */

                 , SA.ATTRIBUTE12                             AS SI_SCP_YN   /* AJS 20261008 속도 */

           /* 원래 줄 : FROM (SELECT A.DIVISION_ID */

              FROM (SELECT /*+ NO_MERGE(IC) LEADING(IC A) USE_NL(A) INDEX(A IDX4_SCM_MODEL_COMP_TEMP IDX1_SCM_MODEL_COMP_TEMP) */ A.DIVISION_ID   /* AJS 20261008 속도 */

                         , A.SITE_ID

                         , A.PLANT_ID

                         , A.MODEL_ID

                         , A.PARENT_ITEM_ID

                         , A.CHILD_ITEM_ID

                         , MIN(A.CHILD_QTY)             AS CHILD_QTY

                         , MIN(A.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY

                         , MIN(A.SORT_ORDER)            AS SORT_ORDER

                         , TRUNC(MIN(A.NLEVEL))         AS NLEVEL

                         , MIN(B.SCP_OPERATION_GROUP)   AS SCP_OPERATION_GROUP

                         , MIN(B.SCP_FLOW_ID)           AS SCP_FLOW_ID

                      FROM SCM_MST_BOM_SN A

                         , (SELECT DIVISION_ID

                                 , SITE_ID

                                 , SCP_OPERATION_GROUP

                                 , SCP_FLOW_ID

                              FROM SCM_MST_ITEM_SN

                             WHERE UPPER(ITEM_ID)    IN (V_MODEL_ID, V_PARENT_ID, V_CHILD_ID)   /* 2026.11.13 조회조건 대소문자 무시 */

                               AND DIVISION_ID = V_DIVISION_ID) B

                      /* 상위품목 판정은 바깥 IT.IB_YN 으로 옮김

                         , (SELECT DISTINCT ITEM_ID

                              FROM SCM_MST_ITEM_SN

                             WHERE DIVISION_ID          = V_DIVISION_ID

                               AND SCP_OPERATION_GROUP IN ('P', 'A')) IB

                      */   /* AJS 20261008 속도 */

                      /* 원래 줄 : , (SELECT DISTINCT ITEM_ID */

                         , (SELECT /*+ FULL(SCM_MST_ITEM_SN) */ DISTINCT ITEM_ID   /* AJS 20261008 속도 */

                              FROM SCM_MST_ITEM_SN

                             WHERE DIVISION_ID = V_DIVISION_ID

                               AND (SCP_OPERATION_GROUP = 'P'

                                OR (SCP_OPERATION_GROUP = 'A'

                               AND SCP_FLOW_ID IN (SELECT SEGMENT1

                                                     FROM SCM_ADM_LOOKUP_MASTER_DETAIL

                                                    WHERE LOOKUP_TYPE = 'SCP_PLAN_OPERATION'

                                                      AND SEGMENT3    = 'A'    /* 공정그룹(Cell) */

                                                      AND ATTRIBUTE1  = 'Y'))) /* FInal Operation */

                                                                       ) IC

                     WHERE A.DIVISION_ID    = B.DIVISION_ID(+)

                       AND A.SITE_ID        = B.SITE_ID(+)

                    /* AND A.PARENT_ITEM_ID = IB.ITEM_ID */   /* AJS 20261008 속도 */

                       AND A.CHILD_ITEM_ID  = IC.ITEM_ID

                       AND (V_PLANT_SITE_ID IS NULL

                        OR  A.PLANT_ID IN (SELECT COLUMN_VALUE

                                             FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))))

--                     AND (V_MODEL_ID  IS NULL OR A.MODEL_ID       = V_MODEL_ID)   --  2026.10.07 AJS

                       AND (V_MODEL_ID  IS NULL OR A.MODEL_ID       IN (SELECT XT.COLUMN_VALUE FROM TABLE(V_MODEL_TAB) XT))   --  2026.10.07 AJS

                       AND (V_PARENT_ID IS NULL OR UPPER(A.PARENT_ITEM_ID) = V_PARENT_ID)   /* 2026.11.13 조회조건 대소문자 무시 */

                       AND (V_CHILD_ID  IS NULL OR UPPER(A.CHILD_ITEM_ID)  = V_CHILD_ID)   /* 2026.11.13 조회조건 대소문자 무시 */

                       AND A.PARENT_ITEM_ID <> '*'

                       AND A.DIVISION_ID    = V_DIVISION_ID   /* AJS 20261008 속도 */

                     GROUP BY A.DIVISION_ID

                            , A.SITE_ID

                            , A.PLANT_ID

                            , A.MODEL_ID

                            , A.PARENT_ITEM_ID

                            , A.CHILD_ITEM_ID) IA

                 , (SELECT D.DIVISION_ID

                         , D.SITE_ID

                         , D.PLANT_ID

                         , D.PARENT_ITEM_ID

                         , D.CHILD_ITEM_ID

                         , D.EFF_START_DATE

                         , D.EFF_END_DATE

                         , D.ALT_ID

                         , D.ECO_CODE

                         , TRUNC(D.ALT_PRIORITY) AS ALT_PRIORITY

                         , ROW_NUMBER() OVER (PARTITION BY D.DIVISION_ID

                                                         , D.SITE_ID

                                                         , D.PLANT_ID

                                                         , D.PARENT_ITEM_ID

                                                         , D.CHILD_ITEM_ID

                                                  ORDER BY D.KEY_DATE DESC

                                                         , D.BOM_VERSION_ID) AS SEQ /* 최신 KEY_DATE */

                      FROM SCM_MST_BOM_ENG_SN D

                     WHERE D.DIVISION_ID   = V_DIVISION_ID

                       AND (V_PLANT_SITE_ID IS NULL

                        OR  D.PLANT_ID IN (SELECT COLUMN_VALUE

                                             FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))))

                       AND D.EFF_END_DATE  > FN_NEXT_DAY(SYSDATE, 'MON') - 7) XA

                 , (SELECT E.DIVISION_ID

                         , E.PLANT_ID

                         , E.PARENT_ITEM_ID

                         , E.CHILD_ITEM_ID

                         , E.SCP_PLAN_YN

                         , E.COMMON_CELL_YN

                         , E.ATTRIBUTE11

                         , E.ATTRIBUTE12

                      FROM SCM_MST_ALTER_BOM E

                     WHERE (V_PARENT_ID IS NULL OR UPPER(E.PARENT_ITEM_ID) = V_PARENT_ID)   /* 2026.11.13 조회조건 대소문자 무시 */

                       AND (V_CHILD_ID  IS NULL OR UPPER(E.CHILD_ITEM_ID)  = V_CHILD_ID)) SA   /* 2026.11.13 조회조건 대소문자 무시 */

             WHERE IA.DIVISION_ID    = XA.DIVISION_ID

               AND IA.SITE_ID        = XA.SITE_ID

               AND IA.PARENT_ITEM_ID = XA.PARENT_ITEM_ID

               AND IA.CHILD_ITEM_ID  = XA.CHILD_ITEM_ID

               AND XA.SEQ            = 1

               AND IA.DIVISION_ID    = SA.DIVISION_ID(+)

               AND IA.PLANT_ID       = SA.PLANT_ID(+)

               AND IA.PARENT_ITEM_ID = SA.PARENT_ITEM_ID(+)

               AND IA.CHILD_ITEM_ID  = SA.CHILD_ITEM_ID(+)

             GROUP BY IA.DIVISION_ID

                    , IA.SITE_ID

                    , IA.PLANT_ID

                    , IA.MODEL_ID

                    , IA.PARENT_ITEM_ID

                    , IA.CHILD_ITEM_ID

                    , XA.ALT_ID

                    , XA.ALT_PRIORITY

                    , XA.EFF_START_DATE

                    , XA.EFF_END_DATE

                    , SA.SCP_PLAN_YN

                    , SA.COMMON_CELL_YN

                    , XA.ECO_CODE

                    , IA.NLEVEL

                    , SA.ATTRIBUTE11

                    , SA.ATTRIBUTE12

                   ) IR   /* AJS 20261008 속도 */

                 , (SELECT 1 AS NO FROM DUAL   /* AJS 20261008 속도 */

                     UNION ALL   /* AJS 20261008 속도 */

                    SELECT 2 FROM DUAL   /* AJS 20261008 속도 */

                     UNION ALL   /* AJS 20261008 속도 */

                    SELECT 3 FROM DUAL) IK   /* 1 모델 · 2 상위품목 · 3 하위품목 */   /* AJS 20261008 속도 */

                 , (SELECT /*+ FULL(SCM_MST_ITEM_SN) */ ITEM_ID   /* AJS 20261008 속도 */

                         , MIN(NVL(TRIM(NICK_NAME), '-'))                          AS NICK_NAME   /* 품목별 닉네임은 한 값(사업부 · 품목에 서로 다른 값 0 건) */   /* AJS 20261008 속도 */

                         , MAX(CASE WHEN SCP_OPERATION_GROUP IN ('P', 'A') THEN 1 END) AS IB_YN       /* 원래 IB(상위품목 대상) */   /* AJS 20261008 속도 */

                      FROM SCM_MST_ITEM_SN   /* AJS 20261008 속도 */

                     WHERE DIVISION_ID = V_DIVISION_ID   /* AJS 20261008 속도 */

                     GROUP BY ITEM_ID) IT   /* AJS 20261008 속도 */

             WHERE IT.ITEM_ID(+) = DECODE(IK.NO, 1, IR.MODEL_ID, 2, IR.PARENT_ITEM_ID, IR.CHILD_ITEM_ID)   /* AJS 20261008 속도 */

             GROUP BY IR.DIVISION_ID   /* AJS 20261008 속도 */

                    , IR.SITE_ID   /* AJS 20261008 속도 */

                    , IR.PLANT_ID   /* AJS 20261008 속도 */

                    , IR.MODEL_ID   /* AJS 20261008 속도 */

                    , IR.PARENT_ITEM_ID   /* AJS 20261008 속도 */

                    , IR.CHILD_ITEM_ID   /* AJS 20261008 속도 */

                    , IR.SORT_ORDER   /* AJS 20261008 속도 */

                    , IR.ALT_ID   /* AJS 20261008 속도 */

                    , IR.ALT_PRIORITY   /* AJS 20261008 속도 */

                    , IR.EFF_START_DATE   /* AJS 20261008 속도 */

                    , IR.EFF_END_DATE   /* AJS 20261008 속도 */

                    , IR.SCP_PLAN_YN   /* AJS 20261008 속도 */

                    , IR.COMMON_CELL_YN   /* AJS 20261008 속도 */

                    , IR.ECO_CODE   /* AJS 20261008 속도 */

                    , IR.NLEVEL   /* AJS 20261008 속도 */

                    , IR.SI_ALT_PRIORITY   /* AJS 20261008 속도 */

                    , IR.SI_SCP_YN   /* AJS 20261008 속도 */

            HAVING MAX(DECODE(IK.NO, 2, IT.IB_YN)) = 1   /* 원래 A.PARENT_ITEM_ID = IB.ITEM_ID */   /* AJS 20261008 속도 */

             /* 원본 데이터베이스 정렬은 하이픈을 무시하고 빈 값을 앞에 둔다 */

            /* 원래 정렬(IA · XA 별칭)

             ORDER BY IA.SITE_ID

                    , IA.PLANT_ID

                    , REPLACE(IA.MODEL_ID, '-', '')

                    , IA.MODEL_ID

                    , IA.NLEVEL

                    , REPLACE(IA.PARENT_ITEM_ID, '-', '')

                    , IA.PARENT_ITEM_ID

                    , XA.ALT_ID NULLS FIRST

                    , XA.ALT_PRIORITY NULLS FIRST

                    , REPLACE(IA.CHILD_ITEM_ID, '-', '')

                    , IA.CHILD_ITEM_ID

            */

             ORDER BY IR.SITE_ID   /* AJS 20261008 속도 */

                    , IR.PLANT_ID   /* AJS 20261008 속도 */

                    , REPLACE(IR.MODEL_ID, '-', '')   /* AJS 20261008 속도 */

                    , IR.MODEL_ID   /* AJS 20261008 속도 */

                    , IR.NLEVEL   /* AJS 20261008 속도 */

                    , REPLACE(IR.PARENT_ITEM_ID, '-', '')   /* AJS 20261008 속도 */

                    , IR.PARENT_ITEM_ID   /* AJS 20261008 속도 */

                    , IR.ALT_ID NULLS FIRST   /* AJS 20261008 속도 */

                    , IR.ALT_PRIORITY NULLS FIRST   /* AJS 20261008 속도 */

                    , REPLACE(IR.CHILD_ITEM_ID, '-', '')   /* AJS 20261008 속도 */

                    , IR.CHILD_ITEM_ID;   /* AJS 20261008 속도 */



            ELSE   /* AJS 20261008 Model/Nickname */



            /* 2026.10.08 AJS Model/Nickname 모델 지정 (START) */

            OPEN O_RC FOR

            SELECT IA.DIVISION_ID

                 , IA.SITE_ID

                 , IA.PLANT_ID

                 , IA.MODEL_ID

                 , (SELECT XB.NICK_NAME

                      FROM (SELECT NVL(TRIM(NICK_NAME), '-') AS NICK_NAME

                              FROM SCM_MST_ITEM_SN

                             WHERE DIVISION_ID = IA.DIVISION_ID

                               AND ITEM_ID     = IA.MODEL_ID) XB

                     WHERE ROWNUM = 1)                        AS MODEL_NAME

                 , IA.PARENT_ITEM_ID

                 , (SELECT XC.NICK_NAME

                      FROM (SELECT NVL(TRIM(NICK_NAME), '-') AS NICK_NAME

                              FROM SCM_MST_ITEM_SN

                             WHERE DIVISION_ID = IA.DIVISION_ID

                               AND ITEM_ID     = IA.PARENT_ITEM_ID) XC

                     WHERE ROWNUM = 1)                        AS PARENT_ITEM_NAME

                 , IA.CHILD_ITEM_ID

                 , (SELECT XD.NICK_NAME

                      FROM (SELECT NVL(TRIM(NICK_NAME), '-') AS NICK_NAME

                              FROM SCM_MST_ITEM_SN

                             WHERE DIVISION_ID = IA.DIVISION_ID

                               AND ITEM_ID     = IA.CHILD_ITEM_ID) XD

                     WHERE ROWNUM = 1)                        AS CHILD_ITEM_NAME

                 , MIN(IA.SORT_ORDER)                         AS SORT_ORDER

                 , XA.ALT_ID

                 , XA.ALT_PRIORITY

                 , XA.EFF_START_DATE

                 , XA.EFF_END_DATE

                 , SA.SCP_PLAN_YN

                 , SA.COMMON_CELL_YN

                 , XA.ECO_CODE

                 , IA.NLEVEL

                 , SA.ATTRIBUTE11                             AS SI_ALT_PRIORITY

                 , SA.ATTRIBUTE12                             AS SI_SCP_YN

              FROM (SELECT /*+ LEADING(IM A) USE_NL(A) INDEX(A IDX3_SCM_MODEL_COMP_TEMP) */ A.DIVISION_ID   /* AJS 20261008 Model/Nickname */

                         , A.SITE_ID

                         , A.PLANT_ID

                         , A.MODEL_ID

                         , A.PARENT_ITEM_ID

                         , A.CHILD_ITEM_ID

                         , MIN(A.CHILD_QTY)             AS CHILD_QTY

                         , MIN(A.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY

                         , MIN(A.SORT_ORDER)            AS SORT_ORDER

                         , TRUNC(MIN(A.NLEVEL))         AS NLEVEL

                         , MIN(B.SCP_OPERATION_GROUP)   AS SCP_OPERATION_GROUP

                         , MIN(B.SCP_FLOW_ID)           AS SCP_FLOW_ID

                      FROM (SELECT DISTINCT XT.COLUMN_VALUE AS MODEL_ID   /* AJS 20261008 Model/Nickname */

                              FROM TABLE(V_MODEL_TAB) XT) IM   /* AJS 20261008 Model/Nickname */

                         , SCM_MST_BOM_SN A   /* AJS 20261008 Model/Nickname */

                         , (SELECT DIVISION_ID

                                 , SITE_ID

                                 , SCP_OPERATION_GROUP

                                 , SCP_FLOW_ID

                              FROM SCM_MST_ITEM_SN

                             WHERE UPPER(ITEM_ID)    IN (V_MODEL_ID, V_PARENT_ID, V_CHILD_ID)   /* 2026.11.13 조회조건 대소문자 무시 */

                               AND DIVISION_ID = V_DIVISION_ID) B

                         , (SELECT DISTINCT ITEM_ID

                              FROM SCM_MST_ITEM_SN

                             WHERE DIVISION_ID          = V_DIVISION_ID

                               AND SCP_OPERATION_GROUP IN ('P', 'A')) IB

                         , (SELECT DISTINCT ITEM_ID

                              FROM SCM_MST_ITEM_SN

                             WHERE DIVISION_ID = V_DIVISION_ID

                               AND (SCP_OPERATION_GROUP = 'P'

                                OR (SCP_OPERATION_GROUP = 'A'

                               AND SCP_FLOW_ID IN (SELECT SEGMENT1

                                                     FROM SCM_ADM_LOOKUP_MASTER_DETAIL

                                                    WHERE LOOKUP_TYPE = 'SCP_PLAN_OPERATION'

                                                      AND SEGMENT3    = 'A'    /* 공정그룹(Cell) */

                                                      AND ATTRIBUTE1  = 'Y'))) /* FInal Operation */

                                                                       ) IC

                     WHERE A.MODEL_ID       = IM.MODEL_ID   /* AJS 20261008 Model/Nickname */

                       AND A.DIVISION_ID    = B.DIVISION_ID(+)

                       AND A.SITE_ID        = B.SITE_ID(+)

                       AND A.PARENT_ITEM_ID = IB.ITEM_ID

                       AND A.CHILD_ITEM_ID  = IC.ITEM_ID

                       AND (V_PLANT_SITE_ID IS NULL

                        OR  A.PLANT_ID IN (SELECT COLUMN_VALUE

                                             FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))))

                    /* AND (V_MODEL_ID  IS NULL OR A.MODEL_ID       IN (SELECT XT.COLUMN_VALUE FROM TABLE(V_MODEL_TAB) XT)) → 위 IM 조인으로 대체 */   /* AJS 20261008 Model/Nickname */

                       AND A.DIVISION_ID    = V_DIVISION_ID   /* AJS 20261008 Model/Nickname */

                       AND (V_PARENT_ID IS NULL OR UPPER(A.PARENT_ITEM_ID) = V_PARENT_ID)   /* 2026.11.13 조회조건 대소문자 무시 */

                       AND (V_CHILD_ID  IS NULL OR UPPER(A.CHILD_ITEM_ID)  = V_CHILD_ID)   /* 2026.11.13 조회조건 대소문자 무시 */

                       AND A.PARENT_ITEM_ID <> '*'

                     GROUP BY A.DIVISION_ID

                            , A.SITE_ID

                            , A.PLANT_ID

                            , A.MODEL_ID

                            , A.PARENT_ITEM_ID

                            , A.CHILD_ITEM_ID) IA

                 , (SELECT /*+ LEADING(IP D) USE_NL(D) INDEX(D PK_SCM_BOM_M) */ D.DIVISION_ID   /* AJS 20261008 Model/Nickname */

                         , D.SITE_ID

                         , D.PLANT_ID

                         , D.PARENT_ITEM_ID

                         , D.CHILD_ITEM_ID

                         , D.EFF_START_DATE

                         , D.EFF_END_DATE

                         , D.ALT_ID

                         , D.ECO_CODE

                         , TRUNC(D.ALT_PRIORITY) AS ALT_PRIORITY

                         , ROW_NUMBER() OVER (PARTITION BY D.DIVISION_ID

                                                         , D.SITE_ID

                                                         , D.PLANT_ID

                                                         , D.PARENT_ITEM_ID

                                                         , D.CHILD_ITEM_ID

                                                  ORDER BY D.KEY_DATE DESC

                                                         , D.BOM_VERSION_ID) AS SEQ /* 최신 KEY_DATE */

                      FROM (SELECT /*+ NO_MERGE LEADING(XM XN) USE_NL(XN) INDEX(XN IDX3_SCM_MODEL_COMP_TEMP) */   /* AJS 20261008 Model/Nickname */

                                   DISTINCT   /* AJS 20261008 Model/Nickname */

                                   XN.PARENT_ITEM_ID   /* AJS 20261008 Model/Nickname */

                              FROM TABLE(V_MODEL_TAB) XM   /* AJS 20261008 Model/Nickname */

                                 , SCM_MST_BOM_SN     XN   /* AJS 20261008 Model/Nickname */

                             WHERE XN.MODEL_ID = XM.COLUMN_VALUE) IP   /* AJS 20261008 Model/Nickname */

                         , SCM_MST_BOM_ENG_SN D

                     WHERE D.PARENT_ITEM_ID = IP.PARENT_ITEM_ID   /* AJS 20261008 Model/Nickname */

                       AND D.DIVISION_ID    = V_DIVISION_ID

                       AND (V_PLANT_SITE_ID IS NULL

                        OR  D.PLANT_ID IN (SELECT COLUMN_VALUE

                                             FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))))

                       AND D.EFF_END_DATE  > FN_NEXT_DAY(SYSDATE, 'MON') - 7) XA

                 , (SELECT E.DIVISION_ID

                         , E.PLANT_ID

                         , E.PARENT_ITEM_ID

                         , E.CHILD_ITEM_ID

                         , E.SCP_PLAN_YN

                         , E.COMMON_CELL_YN

                         , E.ATTRIBUTE11

                         , E.ATTRIBUTE12

                      FROM SCM_MST_ALTER_BOM E

                     WHERE (V_PARENT_ID IS NULL OR UPPER(E.PARENT_ITEM_ID) = V_PARENT_ID)   /* 2026.11.13 조회조건 대소문자 무시 */

                       AND (V_CHILD_ID  IS NULL OR UPPER(E.CHILD_ITEM_ID)  = V_CHILD_ID)) SA   /* 2026.11.13 조회조건 대소문자 무시 */

             WHERE IA.DIVISION_ID    = XA.DIVISION_ID

               AND IA.SITE_ID        = XA.SITE_ID

               AND IA.PARENT_ITEM_ID = XA.PARENT_ITEM_ID

               AND IA.CHILD_ITEM_ID  = XA.CHILD_ITEM_ID

               AND XA.SEQ            = 1

               AND IA.DIVISION_ID    = SA.DIVISION_ID(+)

               AND IA.PLANT_ID       = SA.PLANT_ID(+)

               AND IA.PARENT_ITEM_ID = SA.PARENT_ITEM_ID(+)

               AND IA.CHILD_ITEM_ID  = SA.CHILD_ITEM_ID(+)

             GROUP BY IA.DIVISION_ID

                    , IA.SITE_ID

                    , IA.PLANT_ID

                    , IA.MODEL_ID

                    , IA.PARENT_ITEM_ID

                    , IA.CHILD_ITEM_ID

                    , XA.ALT_ID

                    , XA.ALT_PRIORITY

                    , XA.EFF_START_DATE

                    , XA.EFF_END_DATE

                    , SA.SCP_PLAN_YN

                    , SA.COMMON_CELL_YN

                    , XA.ECO_CODE

                    , IA.NLEVEL

                    , SA.ATTRIBUTE11

                    , SA.ATTRIBUTE12

             /* 원본 데이터베이스 정렬은 하이픈을 무시하고 빈 값을 앞에 둔다 */

             ORDER BY IA.SITE_ID

                    , IA.PLANT_ID

                    , REPLACE(IA.MODEL_ID, '-', '')

                    , IA.MODEL_ID

                    , IA.NLEVEL

                    , REPLACE(IA.PARENT_ITEM_ID, '-', '')

                    , IA.PARENT_ITEM_ID

                    , XA.ALT_ID NULLS FIRST

                    , XA.ALT_PRIORITY NULLS FIRST

                    , REPLACE(IA.CHILD_ITEM_ID, '-', '')

                    , IA.CHILD_ITEM_ID;

            /* 2026.10.08 AJS Model/Nickname 모델 지정 (END) */

            END IF;   /* AJS 20261008 Model/Nickname */



        ELSE

            /* 원문은 두 갈래 밖에서는 결과 집합을 돌려주지 않는다 */

            OPEN O_RC FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;

        END IF;



        OPEN O_RESULT_CURSOR FOR

        SELECT '0'       AS CODE

             , 'SUCCESS' AS MSG

          FROM DUAL;



    EXCEPTION

        WHEN OTHERS THEN

            DECLARE

                V_ERR VARCHAR2(4000 CHAR) := SUBSTR(SQLERRM, 1, 4000);

            BEGIN

                OPEN O_RC FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;

                OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR AS MSG FROM DUAL;

            END;

    END P_SCP0053_GET_SCP_BOM;



/****************************************************************************************************

 * Program ID   : SCP0020_SAVE_SCP_BOM

 * Description  : SCP BOM 수정

 * Program History

 *===================================================================================================

 *   Date       In Charge      Description

 *===================================================================================================

 * 2018/03/27   PJG				Initial Release (PJ20209642 Digital SCM Level.3 달성을 위한 개선)

 * 2022-07-25   jahn1501        PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - SCPYN 설정값이 동시 반영되도록 Plant Id 조건 제외.

 * 2022-10-25   jahn1501   		PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - p_si_alt_priority, p_si_scp_yn parameter 추가

 * 2026.09.22   ZIONEX          [PJ202650304] MSSQL -> Oracle 전환

 ****************************************************************************************************/

    PROCEDURE P_SCP0053_SAVE_SCP_BOM (

        P_ACTIVE_FLAG     IN  VARCHAR2

      , P_DIVISION_ID     IN  VARCHAR2

      , P_PLANT_CD        IN  VARCHAR2

      , P_MODEL_ID        IN  VARCHAR2

      , P_PARENT_ITEM_ID  IN  VARCHAR2

      , P_CHILD_ITEM_ID   IN  VARCHAR2

      , P_ALT_ID          IN  VARCHAR2

      , P_EFF_START_DATE  IN  VARCHAR2

      , P_EFF_END_DATE    IN  VARCHAR2

      , P_ECO_CODE        IN  VARCHAR2

      , P_SCP_YN          IN  VARCHAR2

      , P_SI_ALT_PRIORITY IN  VARCHAR2

      , P_SI_SCP_YN       IN  VARCHAR2

      , P_USER_ID         IN  VARCHAR2

      , P_DEBUG_MODE      IN  VARCHAR2 DEFAULT 'F'

      , O_RC              OUT SYS_REFCURSOR

      , O_RESULT_CURSOR   OUT SYS_REFCURSOR

    )

    IS

        V_WORKING_TIME      DATE := SYSDATE;

        V_RECV_ACTIVE_FLAG  VARCHAR2(32767 CHAR) := P_ACTIVE_FLAG;



        V_ACTIVE_FLAG       VARCHAR2(4000 CHAR);

        V_DIVISION_ID       VARCHAR2(4000 CHAR);

        V_PLANT_CD          VARCHAR2(4000 CHAR);

        V_MODEL_ID          VARCHAR2(4000 CHAR);

        V_PARENT_ITEM_ID    VARCHAR2(4000 CHAR);

        V_CHILD_ITEM_ID     VARCHAR2(4000 CHAR);

        V_ALT_ID            VARCHAR2(4000 CHAR);

        V_EFF_START_DATE    VARCHAR2(4000 CHAR);

        V_EFF_END_DATE      VARCHAR2(4000 CHAR);

        V_ECO_CODE          VARCHAR2(4000 CHAR);

        V_SCP_YN            VARCHAR2(4000 CHAR);

        V_SI_ALT_PRIORITY   VARCHAR2(4000 CHAR);

        V_SI_SCP_YN         VARCHAR2(4000 CHAR);



        V_CREATION_DATE     DATE;

        V_LAST_UPDATED_BY   VARCHAR2(4000 CHAR);

        V_LAST_UPDATE_DATE  DATE;



        V_DELIMITER         VARCHAR2(1 CHAR) := '^';

        N_MAX_LOOP_CNT      NUMBER := 0;

        N_MST_LOOP_CNT      NUMBER := 0;



	-- LOG 용 변수 설정

        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := '[SCP0053_SAVE_SCP_BOM]';

        V_LOG_TYPE          VARCHAR2(30 CHAR); -- START/END/ERROR/...

        N_LOG_COUNT         NUMBER := 0;

        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);

        V_DESCRIPTION       VARCHAR2(500 CHAR);

        D_EVENT_DATE        DATE;

    BEGIN



        V_CREATION_DATE    := V_WORKING_TIME;

        V_LAST_UPDATED_BY  := P_USER_ID;

        V_LAST_UPDATE_DATE := V_WORKING_TIME;



	-- 트렌젝션 시작

        SAVEPOINT SP_SCP0053_SAVE;



        V_LOG_TYPE    := 'START';

        V_LOG_MESSAGE := '########## Start of procedure ##########';

        V_DESCRIPTION := '';

        D_EVENT_DATE  := SYSDATE;

        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);



	-- 프로시저 LOOP 길이를 판단

        N_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER);



        WHILE LENGTH(RTRIM(V_RECV_ACTIVE_FLAG)) > 0

          AND N_MST_LOOP_CNT < N_MAX_LOOP_CNT

        LOOP

	    -- @mst_loop_cnt 1증가

            N_MST_LOOP_CNT := N_MST_LOOP_CNT + 1;



	    -- 각 컬럼들에 대한 스플릿처리로직 스타트

            V_ACTIVE_FLAG     := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,     V_DELIMITER, N_MST_LOOP_CNT);

            V_DIVISION_ID     := SCM_ARR_SPL_VAL(P_DIVISION_ID,     V_DELIMITER, N_MST_LOOP_CNT);

            V_PLANT_CD        := SCM_ARR_SPL_VAL(P_PLANT_CD,        V_DELIMITER, N_MST_LOOP_CNT);

            V_MODEL_ID        := SCM_ARR_SPL_VAL(P_MODEL_ID,        V_DELIMITER, N_MST_LOOP_CNT);

            V_PARENT_ITEM_ID  := SCM_ARR_SPL_VAL(P_PARENT_ITEM_ID,  V_DELIMITER, N_MST_LOOP_CNT);

            V_CHILD_ITEM_ID   := SCM_ARR_SPL_VAL(P_CHILD_ITEM_ID,   V_DELIMITER, N_MST_LOOP_CNT);

            V_ALT_ID          := SCM_ARR_SPL_VAL(P_ALT_ID,          V_DELIMITER, N_MST_LOOP_CNT);

            V_EFF_START_DATE  := SCM_ARR_SPL_VAL(P_EFF_START_DATE,  V_DELIMITER, N_MST_LOOP_CNT);

            V_EFF_END_DATE    := SCM_ARR_SPL_VAL(P_EFF_END_DATE,    V_DELIMITER, N_MST_LOOP_CNT);

            V_ECO_CODE        := SCM_ARR_SPL_VAL(P_ECO_CODE,        V_DELIMITER, N_MST_LOOP_CNT);

            V_SCP_YN          := SCM_ARR_SPL_VAL(P_SCP_YN,          V_DELIMITER, N_MST_LOOP_CNT);

            V_SI_ALT_PRIORITY := SCM_ARR_SPL_VAL(P_SI_ALT_PRIORITY, V_DELIMITER, N_MST_LOOP_CNT);

            V_SI_SCP_YN       := SCM_ARR_SPL_VAL(P_SI_SCP_YN,       V_DELIMITER, N_MST_LOOP_CNT);



	    /* 원본 MSSQL 은 대소문자를 가리지 않고 비교한다. 열쇠 칸은 인자만 대문자로 맞춘다 */

            V_DIVISION_ID    := UPPER(V_DIVISION_ID);

            V_PARENT_ITEM_ID := UPPER(V_PARENT_ITEM_ID);

            V_CHILD_ITEM_ID  := UPPER(V_CHILD_ITEM_ID);

            V_ACTIVE_FLAG    := UPPER(V_ACTIVE_FLAG);



	   --이력저장

            P_SCM_MST_ALTER_BOM_H( V_DIVISION_ID

                                 , V_PLANT_CD

                                 , V_MODEL_ID

                                 , V_PARENT_ITEM_ID

                                 , V_CHILD_ITEM_ID

                                 , V_ALT_ID

                                 , V_EFF_START_DATE

                                 , V_EFF_END_DATE

                                 , V_ECO_CODE

                                 , V_SCP_YN

                                 , V_SI_ALT_PRIORITY

                                 , V_SI_SCP_YN

                                 , V_CREATION_DATE

                                 , V_LAST_UPDATED_BY );



	    --데이터 저장

            IF N_MST_LOOP_CNT > 0 THEN

                IF (V_ACTIVE_FLAG = 'M') THEN

                    UPDATE SCM_MST_ALTER_BOM

                       SET SCP_PLAN_YN       = V_SCP_YN

                         , ATTRIBUTE11       = V_SI_ALT_PRIORITY

                         , ATTRIBUTE12       = V_SI_SCP_YN

                     WHERE DIVISION_ID    = V_DIVISION_ID

							   --AND PLANT_ID         = @v_plant_cd

                       AND PARENT_ITEM_ID = V_PARENT_ITEM_ID

                       AND CHILD_ITEM_ID  = V_CHILD_ITEM_ID;

                END IF;

            END IF;  -- END OF STMT. IF( @mst_loop_cnt > 0 )



        END LOOP; -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt



        V_LOG_TYPE    := 'END';

        V_LOG_MESSAGE := '########## END of procedure ##########';

        V_DESCRIPTION := '';

        D_EVENT_DATE  := SYSDATE;

        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);



        COMMIT;



	-- 결과코드, 결과 카운트 반환

        OPEN O_RC FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;



        OPEN O_RESULT_CURSOR FOR

        SELECT 'S'            AS RESULT_CODE

             , N_MST_LOOP_CNT AS RESULT_CNT

          FROM DUAL;



    EXCEPTION

        WHEN OTHERS THEN

            DECLARE

                V_ERR_CODE    NUMBER             := SQLCODE;

                V_ERR_MESSAGE VARCHAR2(4000 CHAR) := SUBSTR(SQLERRM, 1, 4000);

            BEGIN

	    --입력 데이타 롤백 처리

                ROLLBACK TO SP_SCP0053_SAVE;



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

                VALUES

                     ( V_PROGRAM_NAME

                     , 'ERROR'

                     , NULL

                     , V_ERR_MESSAGE

                     , NULL

                     , SYSDATE

                     , SYSDATE

                     , V_PROGRAM_NAME

                     , SYSDATE

                     , V_PROGRAM_NAME );



	    /* 에러 메시지, 에러 데이터  반환   */

                OPEN O_RC FOR

                SELECT V_ERR_CODE        AS ERR_CODE

                     , V_ERR_MESSAGE     AS ERR_MESSAGE

                     , V_DIVISION_ID     AS DIVISION_ID

                     , V_PLANT_CD        AS PLANT_CD

                     , V_PARENT_ITEM_ID  AS PARENT_ITEM_ID

                     , V_CHILD_ITEM_ID   AS CHILD_ITEM_ID

                     , V_SCP_YN          AS SCP_YN

                  FROM DUAL;



	    -- error코드, errror 메시지 반환

                OPEN O_RESULT_CURSOR FOR

                SELECT 'F' AS RESULT_CODE

                  FROM DUAL;

            END;

    END P_SCP0053_SAVE_SCP_BOM;



END PKG_SCP0053;
/
