FUNCTION FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE
(
      P_DIVISION_ID         VARCHAR2
    , P_OPERATION_ID        VARCHAR2
    , P_MODEL_ID            VARCHAR2
    , P_NICKNAME            VARCHAR2
    , P_CHECK_FCST          VARCHAR2
    , P_CHECK_PRODUCTION    VARCHAR2
    , P_CHECK_ACTIVE        VARCHAR2
    , P_CHECK_BOM           VARCHAR2
    , P_USER_ID             VARCHAR2
    , P_DEBUG_MODE          VARCHAR2 DEFAULT 'F'
)
RETURN T_SCP0080_GRP_TAB PIPELINED
/* ============================================================================================================
 * Program ID   : FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE
 * Description  : Model Code Management 조회용 테이블 리턴
 * Program History
 *============================================================================================================
 *   Date       In Charge      Description
 *============================================================================================================
 * 2023/07/03   chaan          V1.1.1    Initilaize
 *                                       전체 컬럼 조회 부분을 공통 함수로 추출->동일한 로직을 Mailing 에서 사용함
 *                                       PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 자동차 - 'Replacement Y/N' 컬럼추가
 *                                       PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - CELL_CF 정수형으로 변경
 * 2023/08/01   chaan          V1.1.2    PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2          - 조회속도 개선
 * 2023/09/12   chaan          V1.1.3    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - JV Division에 대해서 81과 동일 컬럼/로직으로 수정(81_UC, 81_HM, 81_ST 에 대해서 81과 동일 기준)
 * 2023/10/11   chaan          V1.1.4    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Total Capacity 소수점 4자리까지로 수정
 * 2023/11/20   chaan          V1.1.5    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 평가감(-K, -D) 모델 CELL_CF 로직 수정
 * 2024/04/01   chaan          V1.1.6    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선 - 조회 로직 중 데이터 양이 많은 임시 테이블 (20만건)인덱스 생성 부분을 CLUSTER Index 로 변경
 * 2024/06/09   vadabi3        V1.1.5    NERP - 특정 Company 별도 처리 -> 개선
 * 2024/11/19   jahn1502                 40 cell 총용량 추가
 * 2025.08.01   hrkim                    PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성/계획 공정 하드 코딩 변경
 * 2026.07.06   ZIONEX         [PJ202650304]  NextSCM Migration
 *------------------------------------------------------------------------------------------------------------
 * 사용예 : SELECT * FROM TABLE(FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE('82','P5000','EM015135PXB1','','N','N','N','N','vadabi3','F'));
 * ============================================================================================================ */
AS
    V_ESOC                VARCHAR2(8 CHAR);  /* NERP 매핑코드 [HQ00] = C100 */
    V_BASIS_START_DATE    VARCHAR2(16 CHAR) := NULL;
BEGIN

/* NERP 매핑코드 조회 : MSSQL SELECT @v_ESOC = dbo.FN_GET_LOOKUP_VALUE(...) (무 FROM 대입) */
    V_ESOC := FN_GET_LOOKUP_VALUE('FN_SCP0080_GET_GROUP_CODE_MANAGEMENT', 'ESOC');


    BEGIN
        SELECT BASIS_START_DATE
          INTO V_BASIS_START_DATE
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_BASIS_START_DATE := NULL;
        WHEN TOO_MANY_ROWS THEN V_BASIS_START_DATE := NULL;
    END;

    FOR R IN
    (
        WITH
/* SCP Cell Final 공정 (Cell Packaging/Assembly) [PJ20257329] 2025.08.01 */
        SCP_CELL_FINAL_OPERATION AS
        (
            SELECT DISTINCT LK.SEGMENT1 AS OPERATION_ID
              FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK
             WHERE 1 = 1
               AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
               AND LK.SEGMENT3    = 'A'  /* 공정그룹 (Cell) */
               AND LK.ATTRIBUTE1  = 'Y'  /* Final Operation */
        ),
/* SCP Cell 생산계획 공정 전체 [PJ20257329] 2025.08.01 */
        SCP_CELL_PROD_PLAN_OPERATION_ALL AS
        (
            SELECT DISTINCT LK.SEGMENT1 AS OPERATION_ID
              FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK
             WHERE 1 = 1
               AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
               AND LK.SEGMENT3    = 'A'  /* 공정그룹 (Cell) */
               AND LK.VALID_YN    = 'Y'  /* SCP 계획 공정 */
        ),

        ITEM_ALL AS
        (
            SELECT DISTINCT
                   DIVISION_ID
                 , ITEM_ID
                 , 'Y' AS STATUS_NEW
                 , ACTIVE_FLAG
                 , INSERT_TIME
                 , SCP_EXTRA_SPEC  /* 40 : Product level2 */
              FROM SCM_MST_ITEM_SN
             WHERE 1 = 1
               AND DIVISION_ID = P_DIVISION_ID
        ),
/* 신규 Item ID 발번되어 I/F된지 3주 이내 아이템 */
        ITEM_NEW AS
        (
            SELECT DISTINCT DIVISION_ID, ITEM_ID, STATUS_NEW
              FROM ITEM_ALL
             WHERE 1 = 1
               AND INSERT_TIME > SYSDATE - 21
        ),
/* ITEM 별 ACTIVE_FLAG (Y 우선) 대표 1건 */
        ITEM_ACTIVE AS
        (
            SELECT A.DIVISION_ID
                 , A.ITEM_ID
                 , A.ACTIVE_FLAG
              FROM (
                        SELECT A.DIVISION_ID
                             , A.ITEM_ID
                             , A.ACTIVE_FLAG
                          FROM (
                                    SELECT DIVISION_ID
                                         , ITEM_ID
                                         , ACTIVE_FLAG
                                         , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, ITEM_ID
                                                              ORDER BY CASE WHEN ACTIVE_FLAG = 'Y' THEN 1 ELSE 2 END ASC) AS RN
                                      FROM ITEM_ALL
                               ) A
                         WHERE 1 = 1
                           AND A.RN = 1
                   ) A
             GROUP BY A.DIVISION_ID
                    , A.ITEM_ID
                    , A.ACTIVE_FLAG
        )
      , ITEM_EXTRA_SPEC AS
        (
            SELECT DISTINCT
                   DIVISION_ID
                 , ITEM_ID
                 , SCP_EXTRA_SPEC  /* 40 : Product level2 */
              FROM ITEM_ALL
             WHERE 1 = 1
               AND SCP_EXTRA_SPEC IS NOT NULL
        ),

        PLANT AS
        (
            SELECT DIVISION_ID
                 , ITEM_ID
                 , OPERATION_GROUP
                 , PLANT_ID
                 , PLANT_NAME
                 , RN
              FROM (
                        SELECT P.DIVISION_ID
                             , P.ITEM_ID
                             , S.OPERATION_GROUP
                             , S.PLANT_ID
                             , CASE
                                   WHEN S.OPERATION_GROUP = 'W' THEN S.PLANT_ID
                                   WHEN N.PLANT_NAME IS NULL     THEN V.VENDOR_NAME
                                   ELSE N.PLANT_NAME
                               END AS PLANT_NAME
                             , ROW_NUMBER() OVER (PARTITION BY P.DIVISION_ID, P.ITEM_ID, S.OPERATION_GROUP
                                                  ORDER BY S.PLANT_ID) AS RN
                          FROM SCM_MST_SITE_ITEM_PRIORITY P
                               JOIN SCM_MST_SITE S ON
                                       P.DIVISION_ID   = S.DIVISION_ID
                                   AND P.PLANT_SITE_ID = S.SCM_SITE_ID
                               LEFT OUTER JOIN SCM_MST_PLANT_SN N ON
                                       S.COMPANY_ID    = N.COMPANY_ID
                                   AND S.DIVISION_ID   = P.DIVISION_ID
                                   AND S.PLANT_ID      = N.PLANT_ID
                               LEFT OUTER JOIN SCM_MST_VENDOR V ON
                                       V.VENDOR_CODE   = S.PLANT_ID
                                   AND S.COMPANY_ID    = V.COMPANY_ID
                               LEFT OUTER JOIN SCM_PLANT_M_SN SN ON
                                       S.DIVISION_ID   = SN.DIVISION_ID
                                   AND S.PLANT_ID      = SN.PLANT_ID
                         WHERE 1 = 1
                           AND P.PRIORITY  = '1'
                           AND P.VALID_YN  = 'Y'
                           AND S.SITE_TYPE = 'PLANT'
                           AND S.VALID_YN  = 'Y'
                           AND TO_CHAR(SYSDATE, 'YYYYMMDD') BETWEEN P.FROM_YYYYMMDD AND P.TO_YYYYMMDD
                   ) A
             WHERE 1 = 1
               AND A.RN = 1
        ),

        ESS_MODEL_TYPE AS
        (
            SELECT B.SEGMENT1 AS CODE
                 , B.SEGMENT2 AS NAME
              FROM SCM_ADM_LOOKUP_MASTER A
                   INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON
                           A.LOOKUP_TYPE = B.LOOKUP_TYPE
             WHERE A.LOOKUP_TYPE = 'ITEM_MODEL_TYPE'
               AND A.VALID_YN = 'Y'
               AND B.VALID_YN = 'Y'
               AND B.SEGMENT3 = '82'
        ),

        SMALL_MODEL_TYPE AS
        (
            SELECT B.SEGMENT1 AS CODE
                 , B.SEGMENT2 AS NAME
              FROM SCM_ADM_LOOKUP_MASTER A
                   INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON
                           A.LOOKUP_TYPE = B.LOOKUP_TYPE
             WHERE A.LOOKUP_TYPE = 'ITEM_MODEL_TYPE'
               AND A.VALID_YN = 'Y'
               AND B.VALID_YN = 'Y'
               AND B.SEGMENT3 = '40'
        ),

        CATHODE AS
        (
            SELECT B.SEGMENT1 AS CODE
                 , B.SEGMENT2 AS NAME
              FROM SCM_ADM_LOOKUP_MASTER A
                   INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON
                           A.LOOKUP_TYPE = B.LOOKUP_TYPE
             WHERE A.LOOKUP_TYPE = 'CATHODE'
               AND A.VALID_YN = 'Y'
               AND B.VALID_YN = 'Y'
        ),
/* Cell Type Group */
        CELL_TYPE_GROUP AS
        (
            SELECT A.CODE                 AS CELL_TYPE_CODE
                 , SUBSTR(A.NAME, 1, 1)   AS FLOW_TYPE
                 , A.GROUP_CODE           AS CELL_TYPE_GROUP_CODE
                 , G.NAME                 AS CELL_TYPE_GROUP_NAME
                 , A.DISPLAY_SEQ
              FROM (
                        SELECT B.SEGMENT1 AS CODE
                             , B.SEGMENT2 AS NAME
                             , B.SEGMENT3 AS GROUP_CODE
                             , B.DISPLAY_SEQ
                          FROM SCM_ADM_LOOKUP_MASTER A
                               JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON
                                       A.LOOKUP_TYPE = B.LOOKUP_TYPE
                                   AND B.VALID_YN = 'Y'
                         WHERE 1 = 1
                           AND A.LOOKUP_TYPE = 'CELL_TYPE_ITEM_CODE'
                           AND A.VALID_YN    = 'Y'
                   ) A
                   JOIN (
                            SELECT B.SEGMENT1 AS CODE
                                 , B.SEGMENT2 AS NAME
                              FROM SCM_ADM_LOOKUP_MASTER A
                                   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON
                                           A.LOOKUP_TYPE = B.LOOKUP_TYPE
                                       AND B.VALID_YN = 'Y'
                             WHERE 1 = 1
                               AND A.LOOKUP_TYPE = 'CELL_TYPE_ITEM_GROUP'
                               AND A.VALID_YN    = 'Y'
                        ) G ON
                           A.GROUP_CODE = G.CODE
        ),
/* ENERGE (82/40, ESOC Company). MSSQL: ENERGE IS NOT NULL AND ENERGE <> '' → Oracle ''=NULL 이므로 IS NOT NULL 로 등가 */
        ENERGE AS
        (
            SELECT DIVISION_ID
                 , SITE_ID
                 , ITEM_ID
                 , ENERGE
              FROM SCM_MST_ITEM_SN
             WHERE 1 = 1
               AND DIVISION_ID IN ('82', '40')
               AND COMPANY_ID = V_ESOC
               AND ENERGE IS NOT NULL
        ),
/* 평가감 CELL_CF (-A..-K,-R / -GG,-GK 기준모델 매핑) */
        CELL_CF_KD AS
        (
            SELECT A.ITEM_ID
                 , TO_CHAR(TO_NUMBER(NVL(B.CELL_CF, '1.0'))) AS CELL_CF
              FROM (
                        SELECT DIVISION_ID
                             , ITEM_ID
                             , CASE
                                   WHEN SUBSTR(A.ITEM_ID, -2) IN ('-A','-B','-C','-D','-E','-F','-G','-H','-I','-J','-K','-R') THEN SUBSTR(ITEM_ID, 1, LENGTH(ITEM_ID) - 2)
                                   WHEN SUBSTR(A.ITEM_ID, -3) IN ('-GG','-GK')                                                 THEN SUBSTR(ITEM_ID, 1, LENGTH(ITEM_ID) - 3)
                               END AS BASIC_ITEM_ID
                          FROM SCP_MST_FINAL_ITEM A
                         WHERE 1 = 1
                           AND ( SUBSTR(A.ITEM_ID, -2) IN ('-A','-B','-C','-D','-E','-F','-G','-H','-I','-J','-K','-R')
                              OR SUBSTR(A.ITEM_ID, -3) IN ('-GG','-GK') )
                   ) A
                   LEFT JOIN (
                                SELECT *
                                  FROM SCP_MST_ITEM_CELL_CF
                                 WHERE 1 = 1
                             ) B ON
                           A.BASIC_ITEM_ID = B.ITEM_ID
        ),
/* Temp : SCP_MST_FINAL_ITEM 기준 전체 컬럼 가공 */
        GRP_TEMP AS
        (
            SELECT A.*
                 , SUBSTR(A.BASIC_MODEL_CELL, 8, 2) AS CATHODE_CODE
              FROM (
                        SELECT A.DIVISION_ID
                             , A.FLOW_ID AS OPERATION_ID
                             , A.ITEM_ID
                             , A.NICK_NAME
                             , CASE
                                   WHEN A.OPERATION_GROUP = 'P' THEN (SELECT B.DOE FROM SCM_MST_ITEM_SN B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL AND ROWNUM = 1)
                                   ELSE ''
                               END AS BASIC_MODEL_PACK
                             , CASE
                                   WHEN A.OPERATION_GROUP = 'P' THEN (SELECT B.NICK_NAME FROM SCP_MST_FINAL_ITEM B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT B2.DOE FROM SCM_MST_ITEM_SN B2 WHERE B2.DIVISION_ID = A.DIVISION_ID AND B2.ITEM_ID = A.ITEM_ID AND B2.DOE IS NOT NULL AND ROWNUM = 1))
                                   ELSE ''
                               END AS BASIC_NICKNAME_PACK
                             , CASE
                                   WHEN CA.OPERATION_ID IS NOT NULL THEN A.ITEM_ID  /* [PJ20257329] 2025.08.01 Cell 계획 공정 하드코딩 변경 */
                                   ELSE
                                       CASE
                                           WHEN A.OPERATION_GROUP = 'P' THEN A.ATTRIBUTE1
                                           ELSE ''
                                       END
                               END AS CELL_MODEL
                             , CASE
                                   WHEN CA.OPERATION_ID IS NOT NULL THEN A.NICK_NAME  /* [PJ20257329] 2025.08.01 Cell 계획 공정 하드코딩 변경 */
                                   ELSE
                                       CASE
                                           WHEN A.OPERATION_GROUP = 'P' THEN (SELECT B.NICK_NAME FROM SCP_MST_FINAL_ITEM B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1)
                                           ELSE ''
                                       END
                               END AS CELL_MODEL_NICKNAME
                             , CASE
                                   WHEN A.OPERATION_GROUP = 'P' THEN (SELECT B.DOE FROM SCM_MST_ITEM_SN B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1 AND B.DOE IS NOT NULL AND ROWNUM = 1)
                                   ELSE (SELECT B.DOE FROM SCM_MST_ITEM_SN B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL AND ROWNUM = 1)
                               END AS BASIC_MODEL_CELL
                             , CASE
                                   WHEN A.OPERATION_GROUP = 'P' THEN (SELECT B.NICK_NAME FROM SCP_MST_FINAL_ITEM B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT B2.DOE FROM SCM_MST_ITEM_SN B2 WHERE B2.DIVISION_ID = A.DIVISION_ID AND B2.ITEM_ID = A.ATTRIBUTE1 AND B2.DOE IS NOT NULL AND ROWNUM = 1))
                                   ELSE (SELECT B.NICK_NAME FROM SCP_MST_FINAL_ITEM B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT B2.DOE FROM SCM_MST_ITEM_SN B2 WHERE B2.DIVISION_ID = A.DIVISION_ID AND B2.ITEM_ID = A.ITEM_ID AND B2.DOE IS NOT NULL AND ROWNUM = 1))
                               END AS BASIC_NICKNAME_CELL
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
                             , NVL(A.FCST_YN, 'N') AS FCST_YN
                             , A.ATTRIBUTE6        AS PIC_ID
                             , UI.USER_NAME        AS PIC_NAME
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
                                   WHEN CO.OPERATION_ID IS NOT NULL                                       THEN A.GROUP_CODE1  /* [PJ20257329] 2025.08.01 Cell 완성 공정 하드 코딩 조건 변경 */
                                   WHEN A.FLOW_ID = 'P5000' OR A.FLOW_ID = 'P5500' OR A.FLOW_ID = 'P9500' THEN A.GROUP_CODE2
                               END AS LEVEL1_GROUP
                             , A.LEVEL2_CODE
                             , CASE WHEN C.STATUS_NEW = 'Y' AND A.STATUS_PROTOTYPE IS NOT NULL THEN 'Y' ELSE A.STATUS_PROTOTYPE END AS STATUS_PROTOTYPE
                             , C.STATUS_NEW
                             , TO_CHAR(ROUND(TO_NUMBER(
                                   CASE
                                       WHEN SUBSTR(A.ITEM_ID, -2) IN ('-D', '-K') THEN F.CELL_CF
                                       ELSE
                                           CASE
                                               WHEN CO.OPERATION_ID IS NOT NULL THEN  /* [PJ20257329] 2025.08.01 Cell 완성 공정 하드 코딩 조건 변경 */
                                                   CASE WHEN NVL(A.CELL_CF, '0') = '0' THEN '1' ELSE A.CELL_CF END
                                               ELSE A.CELL_CF
                                           END
                                   END
                               ), 0)) AS CELL_CF
                             , A.END_CUSTOMER     AS BASIC_END_CUSTOMER
                             , A.FINISHED_PRODUCT AS BASIC_FINISHED_PRODUCT
                             , A.OPERATION_GROUP
                             , CASE
                                   WHEN CO.OPERATION_ID IS NOT NULL THEN 'Cell'  /* [PJ20257329] 2025.08.01 Cell 완성 공정 하드 코딩 조건 변경 */
                                   WHEN A.FLOW_ID = 'P5500'         THEN 'Module'
                                   WHEN A.FLOW_ID = 'P9500'         THEN 'Pack'
                                   ELSE ''  /* P5000 */
                               END AS BIZ_TYPE
                             , SUBSTR(A.ITEM_ID, 2, 1) AS MODEL_TYPE_CODE
                             , SUBSTR(A.ITEM_ID, 1, 2) AS LEVEL_EXCEPT  /* 예외적용 */
                             , A.MKT_DEPT
                             , A.REMARK
                             , D.PLANT_ID
                             , D.PLANT_NAME
                             , E.ENERGE
                             , CASE
                                   WHEN CO.OPERATION_ID IS NOT NULL THEN 'C'  /* [PJ20257329] 2025.08.01 Cell 완성 공정 하드 코딩 조건 변경 */
                                   ELSE 'E'
                               END AS FLOW_TYPE
                             , M.ITEM_ID_ASSY
                             , A.REPLACEMENT
                          FROM SCP_MST_FINAL_ITEM A
/* [PJ20257329] 2025.08.01 Cell 공정 하드 코딩 조건 변경 */
                               LEFT JOIN SCP_CELL_PROD_PLAN_OPERATION_ALL CA ON
                                       CA.OPERATION_ID = A.FLOW_ID
                               LEFT JOIN SCP_CELL_FINAL_OPERATION CO ON
                                       CO.OPERATION_ID = A.FLOW_ID
                               LEFT JOIN ITEM_NEW C ON
                                       A.DIVISION_ID = C.DIVISION_ID
                                   AND A.ITEM_ID     = C.ITEM_ID
                               LEFT JOIN PLANT D ON
                                       A.DIVISION_ID = D.DIVISION_ID
                                   AND A.ITEM_ID     = D.ITEM_ID
                               LEFT JOIN ENERGE E ON
                                       A.DIVISION_ID = E.DIVISION_ID
                                   AND A.ITEM_ID     = E.ITEM_ID
                               LEFT JOIN CELL_CF_KD F ON
                                       A.ITEM_ID     = F.ITEM_ID
                               LEFT JOIN SCM_MST_SSO_USER_INFO UI ON
                                       UPPER(A.ATTRIBUTE6) = UPPER(UI.USER_ID)  /* H-2 Collation : USER_ID 비교 UPPER(양변) */
                               LEFT JOIN (
                                            SELECT DIVISION_ID
                                                 , ITEM_ID_PROD
                                                 , MIN(ITEM_ID_ASSY) AS ITEM_ID_ASSY
                                              FROM SCP_MST_CELL_PROD_ASSY_MAP
                                             WHERE 1 = 1
                                               AND VALID_YN  = 'Y'
                                               AND CELL_TYPE = 'CA1'
                                             GROUP BY DIVISION_ID
                                                    , ITEM_ID_PROD
                                         ) M ON
                                       A.DIVISION_ID = M.DIVISION_ID
                                   AND A.ITEM_ID     = M.ITEM_ID_PROD
                         WHERE 1 = 1
                           AND (SUBSTR(A.ATTRIBUTE8, 1, 2) <> 'CA' OR A.ATTRIBUTE8 IS NULL)  /* 활성화코드 분리 */
                           AND A.OPERATION_GROUP IN ('A', 'P')
                           AND A.DIVISION_ID = P_DIVISION_ID
                           AND ( (P_OPERATION_ID IS NULL OR P_OPERATION_ID = '') OR A.FLOW_ID   IN (SELECT REGEXP_SUBSTR(P_OPERATION_ID, '[^,]+', 1, LEVEL) FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(P_OPERATION_ID, ',') + 1) )
                           AND ( (P_MODEL_ID     IS NULL OR P_MODEL_ID     = '') OR A.ITEM_ID   IN (SELECT REGEXP_SUBSTR(P_MODEL_ID,     '[^,]+', 1, LEVEL) FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(P_MODEL_ID,     ',') + 1) )
                           AND ( (P_NICKNAME     IS NULL OR P_NICKNAME     = '') OR A.NICK_NAME IN (SELECT REGEXP_SUBSTR(P_NICKNAME,     '[^,]+', 1, LEVEL) FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(P_NICKNAME,     ',') + 1) )
                   ) A
        ),

        GRP_PRE AS
        (
            SELECT T.*
                 , CASE WHEN T.BASIC_MODEL_CELL IS NOT NULL THEN SUBSTR(T.BASIC_MODEL_CELL, 3, 1) ELSE T.BASIC_MODEL_CELL END AS BASIC_APPLICATION
                 , CASE WHEN T.BASIC_MODEL_CELL IS NOT NULL THEN SUBSTR(T.BASIC_MODEL_CELL, 4, 2) ELSE T.BASIC_MODEL_CELL END AS BASIC_CELL_TYPE
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
              FROM GRP_TEMP T
                   LEFT JOIN CATHODE H ON
                           T.CATHODE_CODE = H.CODE
                   LEFT JOIN ESS_MODEL_TYPE E ON
                           T.MODEL_TYPE_CODE = E.CODE
                   LEFT JOIN SMALL_MODEL_TYPE S ON
                           T.OPERATION_ID = S.CODE
                   LEFT JOIN ITEM_EXTRA_SPEC X ON
                           T.DIVISION_ID = X.DIVISION_ID
                       AND T.ITEM_ID     = X.ITEM_ID
        ),
/* All : Application 명 / Cell 용량(81) / Cell Type Group 명 결합 */
        GRP_ALL AS
        (
            SELECT P.*
                 , CASE
                       WHEN P.BASIC_APPLICATION = 'E' THEN 'Battery EV(BEV)'
                       WHEN P.BASIC_APPLICATION = 'H' THEN 'Hybrid(HEV)'
                       WHEN P.BASIC_APPLICATION = 'L' THEN 'Low Voltage(LV)'
                       WHEN P.BASIC_APPLICATION = 'P' THEN 'Plug-in HEV(PHEV)'
                       ELSE ''
                   END AS APPLICATION_NAME
                 , CASE
                       WHEN P.BASIC_CELL_CAPACITY_CHAR IS NULL OR REGEXP_LIKE(P.BASIC_CELL_CAPACITY_CHAR, '[^0-9]') THEN NULL
                       ELSE TO_NUMBER(P.BASIC_CELL_CAPACITY_CHAR)
                   END AS BASIC_CELL_CAPACITY_81
                 , CASE
                       WHEN P.LEVEL_EXCEPT = 'EC' THEN 'Pouch'
                       WHEN P.LEVEL_EXCEPT = 'AM' THEN 'Cylindrical'
                       WHEN SUBSTR(P.ITEM_ID, 3, 1) = 'M' AND P.OPERATION_ID = 'P9500' THEN 'Pouch'
                       ELSE G.CELL_TYPE_GROUP_NAME
                   END AS CELL_TYPE_GROUP_NAME
              FROM GRP_PRE P
                   LEFT JOIN CELL_TYPE_GROUP G ON
                           P.FLOW_TYPE      = G.FLOW_TYPE
                       AND P.CELL_TYPE_CODE = G.CELL_TYPE_CODE
        ),

        BOM_PACK AS
        (
            SELECT DISTINCT MODEL_ID AS ITEM_ID, OPERATION_GROUP_ID
              FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V
             WHERE DIVISION_ID = P_DIVISION_ID
               AND OPERATION_GROUP_ID = 'A'
        )
      , BOM_CELL AS
        (
            SELECT DISTINCT MODEL_ID AS ITEM_ID, OPERATION_GROUP_ID
              FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V
             WHERE DIVISION_ID = P_DIVISION_ID
               AND OPERATION_GROUP_ID = 'E'
        )
/* 최종 결과 (BASIC_TOTAL_CAPACITY / BASIC_CELL_CAPACITY / 상태 플래그 결합 + 필터) */
        SELECT A.DIVISION_ID
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
                   WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81' THEN CASE WHEN A.BASIC_CELL_CAPACITY_81 IS NULL OR A.CELL_CF IS NULL THEN NULL ELSE A.BASIC_CELL_CAPACITY_81 * TO_NUMBER(A.CELL_CF) END
                   WHEN A.DIVISION_ID = '82'              THEN CASE WHEN A.CELL_CF IS NULL THEN NULL ELSE TO_NUMBER(A.ENERGE) END
                   WHEN A.DIVISION_ID = '40'              THEN CASE WHEN A.CELL_CF IS NULL THEN NULL ELSE TO_NUMBER(A.ENERGE) END
                   ELSE NULL
               END AS BASIC_TOTAL_CAPACITY
             , CASE
                   WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81' THEN A.BASIC_CELL_CAPACITY_81
                   WHEN A.DIVISION_ID = '82'              THEN TO_NUMBER(A.ENERGE) / TO_NUMBER(A.CELL_CF)
                   ELSE NULL
               END AS BASIC_CELL_CAPACITY
/* ITEM 별 Plant가 n 개이면 Active 가 Plant 별로 Y, N 두개 이상 존재하므로 Y만 필터링(최종 row 가 ITEM 별 1개만 존재하도록) */
             , CASE WHEN P.ITEM_ID IS NOT NULL THEN 'Y' ELSE '' END                      AS PRODUCTION_YN
             , CASE WHEN (P.ITEM_ID IS NOT NULL) OR A.FCST_YN = 'Y' THEN 'Y' ELSE '' END AS STATUS_MASS
             , NVL(IA.ACTIVE_FLAG, 'N')                                                  AS STATUS_ACTIVE
          FROM GRP_ALL A
               LEFT JOIN (
                            SELECT DISTINCT
                                   N.DIVISION_ID
                                 , N.ITEM_ID
                              FROM SCP_ANL_PRODUCTION_PLAN_N N
                             WHERE 1 = 1
                               AND N.YYYYMMDD >= V_BASIS_START_DATE
                         ) P ON
                       A.DIVISION_ID = P.DIVISION_ID
                   AND A.ITEM_ID     = P.ITEM_ID
               LEFT JOIN ITEM_ACTIVE IA ON
                       A.DIVISION_ID = IA.DIVISION_ID
                   AND A.ITEM_ID     = IA.ITEM_ID
               LEFT JOIN BOM_PACK BP ON
                       A.ITEM_ID = BP.ITEM_ID
               LEFT JOIN BOM_CELL BC ON
                       A.ITEM_ID = BC.ITEM_ID
         WHERE 1 = 1
           AND ( (P_CHECK_FCST = 'N')        OR A.FCST_YN = P_CHECK_FCST )
           AND ( (P_CHECK_PRODUCTION = 'N')  OR (P_CHECK_PRODUCTION = 'Y' AND P.ITEM_ID IS NOT NULL) )
           AND ( (P_CHECK_BOM = 'N')         OR (P_CHECK_BOM = 'Y' AND A.OPERATION_GROUP = 'P' AND BP.ITEM_ID IS NOT NULL)
                                             OR (P_CHECK_BOM = 'Y' AND A.OPERATION_GROUP = 'A' AND BC.ITEM_ID IS NOT NULL) )
           AND ( (P_CHECK_ACTIVE = 'N')      OR (P_CHECK_ACTIVE = 'Y' AND NVL(IA.ACTIVE_FLAG, 'N') = 'Y') )
         ORDER BY A.DIVISION_ID
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.NICK_NAME
    )
    LOOP
        PIPE ROW ( T_SCP0080_GRP_ROW(
              R.DIVISION_ID
            , R.OPERATION_ID
            , R.ITEM_ID
            , R.NICK_NAME
            , R.BASIC_MODEL_PACK
            , R.BASIC_NICKNAME_PACK
            , R.CELL_MODEL
            , R.CELL_MODEL_NICKNAME
            , R.BASIC_MODEL_CELL
            , R.BASIC_NICKNAME_CELL
            , R.GROUP_CODE1
            , R.GROUP_CODE2
            , R.GROUP_CODE3
            , R.GROUP_CODE4
            , R.GROUP_CODE5
            , R.GROUP_CODE6
            , R.GROUP_CODE7
            , R.GROUP_CODE8
            , R.GROUP_CODE9
            , R.GROUP_CODE10
            , R.FCST_YN
            , R.PIC_ID
            , R.PIC_NAME
            , R.ATTRIBUTE7
            , R.ATTRIBUTE8
            , R.ATTRIBUTE9
            , R.ATTRIBUTE10
            , R.ATTRIBUTE11
            , R.ATTRIBUTE12
            , R.ATTRIBUTE13
            , R.ATTRIBUTE14
            , R.ATTRIBUTE15
            , R.SALES_MODEL
            , R.SALES_VALID_YN
            , R.SALES_PRIORITY
            , R.SALES_FROM_YYYYMMDD
            , R.SALES_TO_YYYYMMDD
            , R.LEVEL1_GROUP
            , R.LEVEL2_CODE
            , R.STATUS_PROTOTYPE
            , R.STATUS_NEW
            , R.CELL_CF
            , R.BASIC_END_CUSTOMER
            , R.BASIC_FINISHED_PRODUCT
            , R.OPERATION_GROUP
            , R.BIZ_TYPE
            , R.MODEL_TYPE_CODE
            , R.LEVEL_EXCEPT
            , R.MKT_DEPT
            , R.REMARK
            , R.PLANT_ID
            , R.PLANT_NAME
            , R.ENERGE
            , R.FLOW_TYPE
            , R.ITEM_ID_ASSY
            , R.REPLACEMENT
            , R.CATHODE_CODE
            , R.BASIC_APPLICATION
            , R.BASIC_CELL_TYPE
            , R.BASIC_CELL_CAPACITY_CHAR
            , R.CATHODE_NAME
            , R.CELL_TYPE_CODE
            , R.NICKNAME_40
            , R.MODEL_TYPE_NAME_82
            , R.MODEL_TYPE_NAME_40
            , R.SCP_EXTRA_SPEC
            , R.BASIC_NICKNAME_CELL40
            , R.APPLICATION_NAME
            , R.BASIC_CELL_CAPACITY_81
            , R.CELL_TYPE_GROUP_NAME
            , R.BASIC_TOTAL_CAPACITY
            , R.BASIC_CELL_CAPACITY
            , R.PRODUCTION_YN
            , R.STATUS_MASS
            , R.STATUS_ACTIVE
        ) );
    END LOOP;

    RETURN;
END FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE;