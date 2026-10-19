-- [E20261008-SLASHOBJ] PACKAGE BODY PKG_ZTMP_S015K — 사내 현재 원문(적용본, 사내 LAST_DDL 2026-10-08 16:51:10, 2121줄)
CREATE OR REPLACE PACKAGE BODY PKG_ZTMP_S015K
IS
    /* ============================================================
       P_SSP0015_GET_SHIPMENT_RESULT
       AS-IS SSP0015_GET_SHIPMENT_RESULT
       ※ AS-IS WITH 절 5벌은 각각 1회만 참조하므로 인라인 뷰로 펼쳤다(온라인 SQL WITH 금지).
       ※ STUFF(... FOR XML PATH('')) 는 LISTAGG 로 옮겼다. AS-IS 는 정렬이 없으나
          LISTAGG 는 WITHIN GROUP 이 필수라 DEPT_NAME_KO 로 정렬한다.
       ※ AS-IS 의 CASE WHEN DIVISION_ID = '4O' 는 알파벳 O 다(숫자 0 아님).
          결과 동일성을 위해 원형을 그대로 둔다.
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_RESULT
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_TYPE                  IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_COMPANY_ID            IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_REAL_FLAG             IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_RESULT
         * Description  : Shipment Shipment Result
         * Program History
         *===================================================================================================
         *   Date       In Charge		Description
         *===================================================================================================
         * 2019/09/26   AYJ			[CSR ID:4037234] 출하계획 대비 실적 Report 개발
         * 2019/12/04   juhlee      [C20191205-000132]  OWMS 출하실적에 반품 내용 적용
         * 2020/01/21   juhlee      [C20200121-000352]  ESS Packer출하 적용
         * 2020/02/12   KIMYONGHO   [C20200218-000135]  SHIP_TYPE 컬럼추가 및 FROM_STIE, TO_SITE Display 변경
         * 2020.05.06	KIMYONGHO   [C20200403-000062] [GSCM PI] SSP 출하 실적 집계 중 사외 창고 제외 로직 추가 건
         * 2020.09.18	KIMYONGHO   ERP_ORDER_TYPE 주석 처리 Request by 김광희 책임
         * 2021.02.17	KIMYONGHO   실적 조회시 TRNSPORT_MODE, INCOTERMS, ERP_SO_NO, ETA_DATE, ETD_DATE ERP 실적 기준으로 조회
         * 2021.04.05   KIMYONGHO   [C20210330-000402] Shipment Plan화면의 실적 조회시 Sales site Mapping 안되는건 전수 표시
         * 2021.05.03   SSP Pjt.    SSP_SHIP_RESULT_EXCEPT_ERP_ORDER_TYPE LOOKUP적용
         * 2021.11.15   KIMYONGHO   Confirm Data Plan Date 기준 조회 처리
         * 2024.10.18   SSP         소형 Team 컬럼 추가
         * 2024.10.29   KHJ         NERP_SSP
         * 2026.09.16   AJS         MSSQL -> Oracle 전환 (WITH -> 인라인 뷰, XML PATH -> LISTAGG)
         */
    BEGIN

        OPEN O_RC1 FOR
        SELECT X.DIVISION_ID
             , B.COMPANY_ID    AS COMPANY_ID
             , C.SEGMENT2      AS TYPE
             , X.ERP_SO_NO
             , X.CONFIRM_ID
             , X.ITEM_ID
             , FN_GET_ITEM_NICKNAME(X.DIVISION_ID, X.ITEM_ID) AS NICK_NAME
             , NVL(FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID, X.FROM_SITE), X.FROM_SITE) AS FROM_SITE
             --, NVL(FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID, X.TO_SITE), X.TO_SITE)     AS TO_SITE
             , NVL((SELECT MAX(SA.SITE_DESCRIPTION)   /* MSSQL 함수는 사이트 코드 대소문자 무시 */   -- 2026.09.17 AJS
                     FROM SCM_MST_SITE SA   -- 2026.09.17 AJS
                    WHERE UPPER(SA.SCM_SITE_ID) = UPPER(X.TO_SITE)), X.TO_SITE)     AS TO_SITE   -- 2026.09.17 AJS
             , X.TEAM
             , X.END_CUSTOMER
             , X.QTY
             , CASE WHEN REGEXP_LIKE(X.YYYYMMDD, '^[0-9]{8}$')
                    THEN TO_CHAR(TO_DATE(X.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS YYYYMMDD
             , X.TRANSPORT_MODE
             , X.INCOTERMS
             , CASE WHEN REGEXP_LIKE(X.ETD_DATE, '^[0-9]{8}$')
                    THEN TO_CHAR(TO_DATE(X.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETD_DATE
             , CASE WHEN REGEXP_LIKE(X.ETA_DATE, '^[0-9]{8}$')
                    THEN TO_CHAR(TO_DATE(X.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETA_DATE
             , X.SHIP_TYPE
          FROM (
                /* CONFIRM_ID, 날짜동일한 기준으로 계획정보의 FROM, TO SITE기준으로 실적 집계 */
                SELECT IA.DIVISION_ID     AS DIVISION_ID
                     , 'E'                AS TYPE
                     , IA.ERP_SO_NO       AS ERP_SO_NO
                     , IA.CONFIRM_ID      AS CONFIRM_ID
                     , IA.ITEM_ID         AS ITEM_ID
                     , IA.FROM_SITE       AS FROM_SITE
                     , IA.TO_SITE         AS TO_SITE
                     , NULL               AS END_CUSTOMER
                     , IA.TEAM            AS TEAM
                     , SUM(IA.RESULT_QTY) AS QTY
                     , IA.YYYYMMDD        AS YYYYMMDD
                     , IA.TRANSPORT_MODE  AS TRANSPORT_MODE
                     , IA.INCOTERMS       AS INCOTERMS
                     , IA.ETD_DATE        AS ETD_DATE
                     , IA.ETA_DATE        AS ETA_DATE
                     , NULL               AS SHIP_TYPE
                  FROM (
                        /* ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상 */
                        SELECT E.DIVISION_ID          AS DIVISION_ID
                             , E.CONFIRM_ID           AS CONFIRM_ID
                             , E.ORDER_NO             AS ERP_SO_NO
                             , E.EXFACTORY_DATE       AS YYYYMMDD
                             , E.TRANSPORT_MODE       AS TRANSPORT_MODE
                             , E.INCOTERMS            AS INCOTERMS
                             --, E.ETA_DATE             AS ETA_DATE
                             --, E.ETD_DATE             AS ETD_DATE
                             , NVL(E.ETA_DATE, '19000101') AS ETA_DATE   /* AS-IS '' -> 1900-01-01 */   -- 2026.09.17 AJS
                             , NVL(E.ETD_DATE, '19000101') AS ETD_DATE   -- 2026.09.17 AJS
                             , E.FROM_SCM_SITE_ID     AS FROM_SITE
                             , E.TO_SCM_SITE_ID       AS TO_SITE
                             , E.ITEM_ID              AS ITEM_ID
                             , (SELECT LISTAGG(NVL(SA.DEPT_NAME_KO, '-'), ',' ON OVERFLOW TRUNCATE)
                                       WITHIN GROUP (ORDER BY SA.DEPT_NAME_KO)
                                  FROM SCM_MST_SSO_DEPT_INFO SA
                                     /* 2026.09.30 AJS 수정 (START) */
                                   --, TB_FX_USER SB
                                     , SCM_ADM_USER_M SB
                                     /* 2026.09.30 AJS 수정 (END) */
                                 WHERE SA.DEPT_ID = SB.DEPT_ID
                                   --AND SB.USERID IN (SELECT OWNER
                                   /* 2026.09.30 AJS 수정 (START) */
                                 --AND UPPER(SB.USERID) IN (SELECT UPPER(OWNER)   -- 2026.09.17 AJS
                                   AND UPPER(SB.USER_ID) IN (SELECT UPPER(OWNER)   -- 2026.09.17 AJS
                                   /* 2026.09.30 AJS 수정 (END) */
                                                       FROM SCM_MST_SITE_ITEM
                                                      WHERE 1 = 1
                                                        AND DIVISION_ID  = E.DIVISION_ID
                                                        AND SCM_SITE_ID  = E.TO_SCM_SITE_ID
                                                        AND ITEM_ID      = E.ITEM_ID
                                                        AND PROJECT_CODE = (SELECT MIN(SC.PROJECT_CODE)
                                                                              FROM SSP_ANL_SHIP_CONFIRM SC
                                                                             WHERE SC.CONFIRM_ID = E.CONFIRM_ID)
                                                        AND VALID_YN     = 'Y'
                                                        AND OWNER IS NOT NULL)) AS TEAM
                             , SUM(E.EXFACTORY_QTY)   AS RESULT_QTY
                          FROM SCM_DNM_EXFACTORY_RESULT E
                             , SCM_ADM_LOOKUP_MASTER_DETAIL L
                         WHERE L.LOOKUP_TYPE = 'ERP_SSP_TYPE'   /* LOOKUP에 등록된 공정만 */
                           AND L.VALID_YN    = 'Y'
                           AND L.SEGMENT1    = E.SSP_TYPE
                           AND NVL(E.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')   /* D90: DO삭제 , D10:DO생성 */
                           AND E.CONFIRM_ID LIKE 'C%'
                           AND E.EXFACTORY_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                         GROUP BY E.DIVISION_ID
                             , E.CONFIRM_ID
                             , E.ORDER_NO
                             , E.EXFACTORY_DATE
                             , E.TRANSPORT_MODE
                             , E.INCOTERMS
                             , E.ETA_DATE
                             , E.ETD_DATE
                             , E.FROM_SCM_SITE_ID
                             , E.TO_SCM_SITE_ID
                             , E.ITEM_ID
                       ) IA
                 GROUP BY IA.DIVISION_ID
                     , IA.ERP_SO_NO
                     , IA.FROM_SITE
                     , IA.TO_SITE
                     , IA.ITEM_ID
                     , IA.TRANSPORT_MODE
                     , IA.INCOTERMS
                     , IA.ETD_DATE
                     , IA.ETA_DATE
                     , IA.YYYYMMDD
                     , IA.CONFIRM_ID
                     , IA.TEAM
                UNION ALL
                /* CONFIRM_ID 없는 실적 */
                SELECT XB.DIVISION_ID     AS DIVISION_ID
                     , 'E'                AS TYPE
                     , XB.ERP_SO_NO       AS ERP_SO_NO
                     , NULL               AS CONFIRM_ID
                     , XB.ITEM_ID         AS ITEM_ID
                     , XB.FROM_SITE       AS FROM_SITE
                     , XB.TO_SITE         AS TO_SITE
                     , NULL               AS END_CUSTOMER
                     , XB.TEAM            AS TEAM
                     , XB.QTY             AS QTY
                     , XB.YYYYMMDD        AS YYYYMMDD
                     , XB.TRANSPORT_MODE  AS TRANSPORT_MODE
                     , XB.INCOTERMS       AS INCOTERMS
                     , XB.ETD_DATE        AS ETD_DATE
                     , XB.ETA_DATE        AS ETA_DATE
                     , NULL               AS SHIP_TYPE
                  FROM (
                        SELECT E.DIVISION_ID          AS DIVISION_ID
                             , '-'                    AS CONFIRM_ID
                             , E.ORDER_NO             AS ERP_SO_NO
                             , E.FROM_SCM_SITE_ID     AS FROM_SITE
                             , NVL(L3.SEGMENT4, E.TO_SCM_SITE_ID) AS TO_SITE
                             , E.ITEM_ID              AS ITEM_ID
                             , E.EXFACTORY_DATE       AS YYYYMMDD
                             , E.TRANSPORT_MODE       AS TRANSPORT_MODE
                             , E.INCOTERMS            AS INCOTERMS
                             --, E.ETA_DATE             AS ETA_DATE
                             --, E.ETD_DATE             AS ETD_DATE
                             , NVL(E.ETA_DATE, '19000101') AS ETA_DATE   /* AS-IS '' -> 1900-01-01 */   -- 2026.09.17 AJS
                             , NVL(E.ETD_DATE, '19000101') AS ETD_DATE   -- 2026.09.17 AJS
                             , (SELECT LISTAGG(NVL(SA.DEPT_NAME_KO, '-'), ',' ON OVERFLOW TRUNCATE)
                                       WITHIN GROUP (ORDER BY SA.DEPT_NAME_KO)
                                  FROM SCM_MST_SSO_DEPT_INFO SA
                                     /* 2026.09.30 AJS 수정 (START) */
                                   --, TB_FX_USER SB
                                     , SCM_ADM_USER_M SB
                                     /* 2026.09.30 AJS 수정 (END) */
                                 WHERE SA.DEPT_ID = SB.DEPT_ID
                                   --AND SB.USERID IN (SELECT OWNER
                                   /* 2026.09.30 AJS 수정 (START) */
                                 --AND UPPER(SB.USERID) IN (SELECT UPPER(OWNER)   -- 2026.09.17 AJS
                                   AND UPPER(SB.USER_ID) IN (SELECT UPPER(OWNER)   -- 2026.09.17 AJS
                                   /* 2026.09.30 AJS 수정 (END) */
                                                       FROM SCM_MST_SITE_ITEM
                                                      WHERE 1 = 1
                                                        AND DIVISION_ID = E.DIVISION_ID
                                                        AND SCM_SITE_ID = E.TO_SCM_SITE_ID
                                                        AND ITEM_ID     = E.ITEM_ID
                                                        AND VALID_YN    = 'Y'
                                                        AND OWNER IS NOT NULL)) AS TEAM
                             , SUM(E.EXFACTORY_QTY)   AS QTY
                          FROM SCM_DNM_EXFACTORY_RESULT E
                             , SCP_MST_FINAL_ITEM F
                             , SCM_MST_SITE S
                             , SCM_ADM_LOOKUP_MASTER_DETAIL L
                             , SCM_ADM_LOOKUP_MASTER_DETAIL L3
                         WHERE F.ITEM_ID     = E.ITEM_ID       /* SCP 대상 ITEM만 */
                           AND F.DIVISION_ID = E.DIVISION_ID
                           AND S.SCM_SITE_ID = E.FROM_SCM_SITE_ID
                           AND S.DIVISION_ID = E.DIVISION_ID
                           AND L.LOOKUP_TYPE = 'ERP_ORDER_TYPE'   /* LOOKUP에 등록된 ORDER_TYPE만 대상으로 함 */
                           AND L.VALID_YN    = 'Y'
                           AND L.SEGMENT1    = E.ORDER_TYPE_CODE
                           AND L3.LOOKUP_TYPE(+) = 'SHIP_RESULT_TO_SITE_MAPPING'   /* SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE */
                           AND L3.SEGMENT1(+)    = E.DIVISION_ID
                           AND L3.SEGMENT2(+)    = E.SOLDTO_CODE
                           AND L3.SEGMENT3(+)    = E.SHIPTO_CODE
                           AND NVL(E.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')   /* D90: DO삭제 , D10:DO생성 */
                           AND NVL(E.CONFIRM_ID, '-') NOT LIKE 'C%'
                           AND E.EXFACTORY_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           AND E.STORAGE_ID NOT IN (SELECT COLUMN_VALUE
                                                      FROM TABLE(FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_RESULT', 'PRODUCT_STORAGE')))   /* 상품창고제외 */
                           /* [C20200403-000062] 사외 창고 제외 LOOKUP 관리 */
                           AND NOT EXISTS (SELECT 1
                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL SB
                                            WHERE SB.LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
                                              AND SB.VALID_YN    = 'Y'
                                              AND SB.SEGMENT1    = E.STORAGE_ID)
                         GROUP BY E.DIVISION_ID
                             , E.ORDER_NO
                             , E.FROM_SCM_SITE_ID
                             , NVL(L3.SEGMENT4, E.TO_SCM_SITE_ID)
                             , E.ITEM_ID
                             , E.EXFACTORY_DATE
                             , E.TRANSPORT_MODE
                             , E.INCOTERMS
                             , E.ETA_DATE
                             , E.ETD_DATE
                             , E.TO_SCM_SITE_ID
                       ) XB
                UNION ALL
                /* SSP출하계획 ( confirm된 계획) */
                SELECT XC.DIVISION_ID     AS DIVISION_ID
                     , 'P'                AS TYPE
                     , XC.ERP_SO_NO       AS ERP_SO_NO
                     , XC.CONFIRM_ID      AS CONFIRM_ID
                     , XC.ITEM_ID         AS ITEM_ID
                     , XC.FROM_SITE       AS FROM_SITE
                     , XC.TO_SITE         AS TO_SITE
                     , XC.END_CUSTOMER    AS END_CUSTOMER
                     , '-'                AS TEAM
                     , XC.QTY             AS QTY
                     , XC.YYYYMMDD        AS YYYYMMDD
                     , XC.TRANSPORT_MODE  AS TRANSPORT_MODE
                     , XC.INCOTERMS       AS INCOTERMS
                     , XC.ETD_DATE        AS ETD_DATE
                     , XC.ETA_DATE        AS ETA_DATE
                     , NULL               AS SHIP_TYPE
                  FROM (
                        /* Current Version */
                        SELECT C.DIVISION_ID     AS DIVISION_ID
                             , C.ERP_SO_NO       AS ERP_SO_NO
                             , C.CONFIRM_ID      AS CONFIRM_ID
                             , C.ITEM_ID         AS ITEM_ID
                             , C.FROM_SITE       AS FROM_SITE
                             , C.TO_SITE         AS TO_SITE
                               /* AS-IS 원형 유지 : '4O' 는 알파벳 O 다 */
                             , CASE WHEN C.DIVISION_ID = '4O' THEN NVL(SI.PROJECT_CODE, '/')
                                    ELSE NVL(TS.END_CUSTOMER, '-') END AS END_CUSTOMER
                             , C.QTY             AS QTY
                             , C.YYYYMMDD        AS YYYYMMDD
                             , C.TRANSPORT_MODE  AS TRANSPORT_MODE
                             , C.INCOTERMS       AS INCOTERMS
                             , C.ETD_DATE        AS ETD_DATE
                             , C.ETA_DATE        AS ETA_DATE
                          FROM SSP_ANL_SHIP_CONFIRM C
                             , SCM_MST_SITE_ITEM SI
                             , SCM_MST_SITE TS
                         WHERE SI.DIVISION_ID(+)  = C.DIVISION_ID
                           AND SI.ITEM_ID(+)      = C.ITEM_ID
                           AND SI.SCM_SITE_ID(+)  = C.TO_SITE
                           AND SI.PROJECT_CODE(+) = C.PROJECT_CODE
                           AND TS.DIVISION_ID(+)  = C.DIVISION_ID
                           AND TS.SCM_SITE_ID(+)  = C.TO_SITE
                           AND C.CHANGE_TYPE = 'C'
                           AND C.QTY > 0
                           AND C.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           AND C.CONFIRM_ID LIKE 'C%'
                           AND P_REAL_FLAG = 'Y'
                        UNION ALL
                        /* OLD Version */
                        SELECT D.DIVISION_ID     AS DIVISION_ID
                             , D.ERP_SO_NO       AS ERP_SO_NO
                             , D.CONFIRM_ID      AS CONFIRM_ID
                             , D.ITEM_ID         AS ITEM_ID
                             , D.FROM_SITE       AS FROM_SITE
                             , D.TO_SITE         AS TO_SITE
                             , CASE WHEN D.DIVISION_ID = '4O' THEN NVL(SI.PROJECT_CODE, '/')
                                    ELSE NVL(TS.END_CUSTOMER, '-') END AS END_CUSTOMER
                             , D.SHIPMENT_CONFIRM_QTY AS QTY
                             , D.YYYYMMDD        AS YYYYMMDD
                             , D.TRANSPORT_MODE  AS TRANSPORT_MODE
                             , D.INCOTERMS       AS INCOTERMS
                             , D.ETD             AS ETD_DATE
                             , D.ETA             AS ETA_DATE
                          FROM SSP_ANL_SHIP_PLAN_ALL D
                             , SCM_MST_SITE MS
                             , SCM_MST_SITE_ITEM SI
                             , SCM_MST_SITE TS
                         WHERE D.DIVISION_ID = MS.DIVISION_ID
                           AND D.FROM_SITE   = MS.SCM_SITE_ID
                           AND MS.SITE_TYPE  = 'PLANT'
                           AND D.DIVISION_ID = '40'
                           AND MS.OPERATION_GROUP = 'A'
                           AND SI.DIVISION_ID(+)  = D.DIVISION_ID
                           AND SI.ITEM_ID(+)      = D.ITEM_ID
                           AND SI.SCM_SITE_ID(+)  = D.TO_SITE
                           AND SI.PROJECT_CODE(+) = D.PROJECT_CODE
                           AND TS.DIVISION_ID(+)  = D.DIVISION_ID
                           AND TS.SCM_SITE_ID(+)  = D.TO_SITE
                           AND D.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                           AND D.SHIPMENT_STATUS     = 'C'
                           AND D.SHIPMENT_CONFIRM_QTY > 0
                           AND D.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           AND P_REAL_FLAG = 'N'
                       ) XC
                UNION ALL
                /* OWMS 실적 */
                SELECT XD.DIVISION_ID     AS DIVISION_ID
                     , 'O'                AS TYPE
                     , NULL               AS ERP_SO_NO
                     , NULL               AS CONFIRM_ID
                     , XD.ITEM_ID         AS ITEM_ID
                     , XD.FROM_SITE       AS FROM_SITE
                     , XD.TO_SITE         AS TO_SITE
                     , NULL               AS END_CUSTOMER
                     , XD.TEAM            AS TEAM
                     , XD.QTY             AS QTY
                     , XD.YYYYMMDD        AS YYYYMMDD
                     , NULL               AS TRANSPORT_MODE
                     , NULL               AS INCOTERMS
                     , NULL               AS ETD_DATE
                     , NULL               AS ETA_DATE
                     , XD.SHIP_TYPE       AS SHIP_TYPE
                  FROM (
                        SELECT A.DIVISION_ID      AS DIVISION_ID
                             , A.ITEM_ID          AS ITEM_ID
                             , A.FROM_SITE        AS FROM_SITE
                             , CASE WHEN A.TO_SITE = '-' THEN A.CUSTOMER_CODE ELSE A.TO_SITE END AS TO_SITE
                             , SUM(A.LOT_QTY)     AS QTY
                             , A.PLANT_ISSUE_DATE AS YYYYMMDD
                             , A.SHIP_TYPE        AS SHIP_TYPE
                             , (SELECT LISTAGG(NVL(SA.DEPT_NAME_KO, '-'), ',' ON OVERFLOW TRUNCATE)
                                       WITHIN GROUP (ORDER BY SA.DEPT_NAME_KO)
                                  FROM SCM_MST_SSO_DEPT_INFO SA
                                     /* 2026.09.30 AJS 수정 (START) */
                                   --, TB_FX_USER SB
                                     , SCM_ADM_USER_M SB
                                     /* 2026.09.30 AJS 수정 (END) */
                                 WHERE SA.DEPT_ID = SB.DEPT_ID
                                   --AND SB.USERID IN (SELECT OWNER
                                   /* 2026.09.30 AJS 수정 (START) */
                                 --AND UPPER(SB.USERID) IN (SELECT UPPER(OWNER)   -- 2026.09.17 AJS
                                   AND UPPER(SB.USER_ID) IN (SELECT UPPER(OWNER)   -- 2026.09.17 AJS
                                   /* 2026.09.30 AJS 수정 (END) */
                                                       FROM SCM_MST_SITE_ITEM
                                                      WHERE 1 = 1
                                                        AND DIVISION_ID = A.DIVISION_ID
                                                        AND SCM_SITE_ID = A.TO_SITE
                                                        AND ITEM_ID     = A.ITEM_ID
                                                        AND VALID_YN    = 'Y'
                                                        AND OWNER IS NOT NULL)) AS TEAM
                          FROM SSP_DNM_SHIP_RESULT_OWMS A
                         WHERE A.PLANT_ISSUE_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                         GROUP BY A.DIVISION_ID
                             , A.ITEM_ID
                             , A.FROM_SITE
                             , CASE WHEN A.TO_SITE = '-' THEN A.CUSTOMER_CODE ELSE A.TO_SITE END
                             , A.PLANT_ISSUE_DATE
                             , A.SHIP_TYPE
                             , A.TO_SITE
                       ) XD
                UNION ALL
                /* OWMS 반품실적 */
                SELECT XE.DIVISION_ID     AS DIVISION_ID
                     , 'R'                AS TYPE
                     , NULL               AS ERP_SO_NO
                     , NULL               AS CONFIRM_ID
                     , XE.ITEM_ID         AS ITEM_ID
                     , XE.FROM_SITE       AS FROM_SITE
                     , XE.TO_SITE         AS TO_SITE
                     , NULL               AS END_CUSTOMER
                     , '-'                AS TEAM
                     , XE.QTY             AS QTY
                     , XE.YYYYMMDD        AS YYYYMMDD
                     , NULL               AS TRANSPORT_MODE
                     , NULL               AS INCOTERMS
                     , NULL               AS ETD_DATE
                     , NULL               AS ETA_DATE
                     , XE.SHIP_TYPE       AS SHIP_TYPE
                  FROM (
                        SELECT B.DIVISION_ID      AS DIVISION_ID
                             , B.ITEM_ID          AS ITEM_ID
                             , B.FROM_SITE        AS FROM_SITE
                             , '*'                AS TO_SITE
                             , SUM(B.RECIEPT_QTY) AS QTY
                             , B.RECIEPT_DATE     AS YYYYMMDD
                             , NULL               AS SHIP_TYPE
                          FROM SSP_DNM_SHIP_RETURN_OWMS B
                         WHERE B.RECIEPT_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                         GROUP BY B.DIVISION_ID
                             , B.ITEM_ID
                             , B.FROM_SITE
                             , B.RECIEPT_DATE
                       ) XE
               ) X
             , SCM_MST_SITE B
             , SCM_ADM_LOOKUP_MASTER_DETAIL C
             , SSP_MST_MODEL_USER M
         WHERE B.DIVISION_ID = X.DIVISION_ID
           AND B.SCM_SITE_ID = X.FROM_SITE
           AND B.OPERATION_GROUP <> 'E'
           AND C.LOOKUP_TYPE = 'SSP_SHIPMENT_RESULT_TYPE'   /* LOOKUP에 등록된 공정만 */
           AND C.SEGMENT1    = X.TYPE
           AND C.VALID_YN    = 'Y'
           AND M.DIVISION_ID(+) = X.DIVISION_ID
           AND M.FROM_SITE(+)   = X.FROM_SITE
           AND M.ITEM_ID(+)     = X.ITEM_ID
           AND M.VALID_YN(+)    = 'Y'
           AND X.DIVISION_ID = P_DIVISION_ID
           --AND ((P_COMPANY_ID IS NULL OR P_COMPANY_ID = '') OR B.COMPANY_ID = P_COMPANY_ID)
           AND ((TRIM(P_COMPANY_ID) IS NULL) OR B.COMPANY_ID = P_COMPANY_ID)   -- 2026.09.17 AJS
           --AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
           AND ((TRIM(P_FROM_SITE) IS NULL)   -- 2026.09.17 AJS
                 OR X.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
           --AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
           AND ((TRIM(P_ITEM_ID) IS NULL)   -- 2026.09.17 AJS
                 --OR X.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                 OR X.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
           --AND ((P_TYPE IS NULL OR P_TYPE = '')
           AND ((TRIM(P_TYPE) IS NULL)   -- 2026.09.17 AJS
                 OR X.TYPE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_TYPE, ','))))
           /* 체크박스 체크 여부 조회 시작(P_NONCHK = 'Y' : 체크박스 선택 안한 상태) */
           AND ((P_NONCHK = 'Y' AND 1 = 1)
                 OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                   UNION
                                  SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                    FROM SSP_MST_DELEGATE
                                   WHERE VALID_YN = 'Y'
                                     AND DELEGATEE_ID = P_USER_ID
                                   GROUP BY USER_ID)
                 OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                 OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
           /* 체크박스 체크 여부 조회 끝 */
         --ORDER BY X.DIVISION_ID
             --, X.FROM_SITE
             --, X.YYYYMMDD
             --, X.ITEM_ID
             --, X.TO_SITE
             --, C.DISPLAY_SEQ
             --, X.CONFIRM_ID;
         ORDER BY X.DIVISION_ID NULLS FIRST   /* MSSQL 오름차순 NULL 앞 */   -- 2026.09.17 AJS
             , X.FROM_SITE NULLS FIRST   -- 2026.09.17 AJS
             , X.YYYYMMDD NULLS FIRST   -- 2026.09.17 AJS
             , X.ITEM_ID NULLS FIRST   -- 2026.09.17 AJS
             , X.TO_SITE NULLS FIRST   -- 2026.09.17 AJS
             , C.DISPLAY_SEQ NULLS FIRST   -- 2026.09.17 AJS
             , X.CONFIRM_ID NULLS FIRST;   -- 2026.09.17 AJS

    END P_SSP0015_GET_SHIPMENT_RESULT;

    /* ============================================================
       P_SSP0015_GET_SHIPMENT_RESULT_PACKER
       AS-IS SSP0015_GET_SHIPMENT_RESULT_PACKER
       ※ AS-IS WITH 절 3벌은 각각 1회만 참조하므로 인라인 뷰로 펼쳤다.
       ※ AS-IS 의 CASE WHEN DIVISION_ID = '4O' 는 알파벳 O 다. 원형 유지.
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_RESULT_PACKER
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_TYPE                  IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_COMPANY_ID            IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_REAL_FLAG             IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_RESULT_PACKER
         * Description  : Shipment Shipment Result
         * Program History
         *===================================================================================================
         *   Date       In Charge		Description
         *===================================================================================================
         * 2021/10/05   KIMYONGHO		신규추가
         * 2021/11/26   SMS		        Ship to 추가
         * 2026.09.16   AJS             MSSQL -> Oracle 전환 (WITH -> 인라인 뷰)
         */
    BEGIN

        OPEN O_RC1 FOR
        SELECT X.DIVISION_ID
             , B.COMPANY_ID    AS COMPANY_ID
             , C.SEGMENT2      AS TYPE
             , X.ERP_SO_NO
             , X.CONFIRM_ID
             , X.ITEM_ID
             , FN_GET_ITEM_NICKNAME(X.DIVISION_ID, X.ITEM_ID) AS NICK_NAME
             , NVL(FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID, X.FROM_SITE), X.FROM_SITE) AS FROM_SITE
             --, NVL(FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID, X.TO_SITE), X.TO_SITE)     AS TO_SITE
             , NVL((SELECT MAX(SA.SITE_DESCRIPTION)   /* MSSQL 함수는 사이트 코드 대소문자 무시 */   -- 2026.09.17 AJS
                     FROM SCM_MST_SITE SA   -- 2026.09.17 AJS
                    WHERE UPPER(SA.SCM_SITE_ID) = UPPER(X.TO_SITE)), X.TO_SITE)     AS TO_SITE   -- 2026.09.17 AJS
             , X.END_CUSTOMER
             , X.QTY
             , CASE WHEN REGEXP_LIKE(X.YYYYMMDD, '^[0-9]{8}$')
                    THEN TO_CHAR(TO_DATE(X.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS YYYYMMDD
             , X.TRANSPORT_MODE
             , X.INCOTERMS
             , CASE WHEN REGEXP_LIKE(X.ETD_DATE, '^[0-9]{8}$')
                    THEN TO_CHAR(TO_DATE(X.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETD_DATE
             , CASE WHEN REGEXP_LIKE(X.ETA_DATE, '^[0-9]{8}$')
                    THEN TO_CHAR(TO_DATE(X.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETA_DATE
             , X.SHIP_TYPE
               /* 20211126  SMS  추가 Ship to, Shipto description */
             , X.SHIP_TO
             --, D.SHIPTO_DESCRIPTION
             , XF.SHIPTO_DESCRIPTION   -- 2026.09.17 AJS
          FROM (
                /* SCS 출하실적에서 CONFIRM_ID 존재 */
                SELECT IA.DIVISION_ID     AS DIVISION_ID
                     , 'S'                AS TYPE
                     , IA.ERP_SO_NO       AS ERP_SO_NO
                     , IA.CONFIRM_ID      AS CONFIRM_ID
                     , IA.ITEM_ID         AS ITEM_ID
                     , IA.FROM_SITE       AS FROM_SITE
                     , IA.TO_SITE         AS TO_SITE
                     , NULL               AS END_CUSTOMER
                     , SUM(IA.RESULT_QTY) AS QTY
                     , IA.YYYYMMDD        AS YYYYMMDD
                     , IA.TRANSPORT_MODE  AS TRANSPORT_MODE
                     , IA.INCOTERMS       AS INCOTERMS
                     , IA.ETD_DATE        AS ETD_DATE
                     , IA.ETA_DATE        AS ETA_DATE
                     , NULL               AS SHIP_TYPE
                     , IA.SHIP_TO         AS SHIP_TO
                  FROM (
                        SELECT E.DIVISION_ID      AS DIVISION_ID
                             , E.ATTRIBUTE5       AS CONFIRM_ID
                             , C.ERP_SO_NO        AS ERP_SO_NO
                             , E.SHIP_DATE        AS YYYYMMDD
                             , C.TRANSPORT_MODE   AS TRANSPORT_MODE
                             , C.INCOTERMS        AS INCOTERMS
                             , C.ETA_DATE         AS ETA_DATE
                             , C.ETD_DATE         AS ETD_DATE
                             , E.SCM_SITE_ID      AS FROM_SITE
                             , E.TO_SITE          AS TO_SITE
                             , E.ITEM_ID          AS ITEM_ID
                               /* 20211126  SMS  추가  Ship to */
                             , E.ATTRIBUTE4       AS SHIP_TO
                             , SUM(E.SHIP_QTY)    AS RESULT_QTY
                          FROM SCM_DNM_SCS_SHIP_RESULT E
                             , SSP_ANL_SHIP_CONFIRM C
                         WHERE E.DIVISION_ID = C.DIVISION_ID(+)
                           AND E.ATTRIBUTE5  = C.CONFIRM_ID(+)
                           AND E.SHIP_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                         GROUP BY E.DIVISION_ID
                             , E.ATTRIBUTE5
                             , C.ERP_SO_NO
                             , E.SHIP_DATE
                             , C.TRANSPORT_MODE
                             , C.INCOTERMS
                             , C.ETA_DATE
                             , C.ETD_DATE
                             , E.SCM_SITE_ID
                             , E.TO_SITE
                             , E.ITEM_ID
                             , E.ATTRIBUTE4
                       ) IA
                 GROUP BY IA.DIVISION_ID
                     , IA.ERP_SO_NO
                     , IA.FROM_SITE
                     , IA.TO_SITE
                     , IA.ITEM_ID
                     , IA.TRANSPORT_MODE
                     , IA.INCOTERMS
                     , IA.ETD_DATE
                     , IA.ETA_DATE
                     , IA.YYYYMMDD
                     , IA.CONFIRM_ID
                     , IA.SHIP_TO
                UNION ALL
                /* SCS 출하실적에서 CONFIRM_ID 없는 실적 */
                SELECT XB.DIVISION_ID     AS DIVISION_ID
                     , 'S'                AS TYPE
                     , XB.ERP_SO_NO       AS ERP_SO_NO
                     , NULL               AS CONFIRM_ID
                     , XB.ITEM_ID         AS ITEM_ID
                     , XB.FROM_SITE       AS FROM_SITE
                     , XB.TO_SITE         AS TO_SITE
                     , NULL               AS END_CUSTOMER
                     , XB.RESULT_QTY      AS QTY
                     , XB.YYYYMMDD        AS YYYYMMDD
                     , XB.TRANSPORT_MODE  AS TRANSPORT_MODE
                     , XB.INCOTERMS       AS INCOTERMS
                     , NULL               AS ETD_DATE
                     , NULL               AS ETA_DATE
                     , NULL               AS SHIP_TYPE
                     , XB.SHIP_TO         AS SHIP_TO
                  FROM (
                        SELECT E.DIVISION_ID      AS DIVISION_ID
                             , E.ATTRIBUTE5       AS CONFIRM_ID
                             , '-'                AS ERP_SO_NO
                             , E.SHIP_DATE        AS YYYYMMDD
                             , '-'                AS TRANSPORT_MODE
                             , '-'                AS INCOTERMS
                             , '-'                AS ETA_DATE
                             , '-'                AS ETD_DATE
                             , E.SCM_SITE_ID      AS FROM_SITE
                             , E.TO_SITE          AS TO_SITE
                             , E.ITEM_ID          AS ITEM_ID
                             , E.ATTRIBUTE4       AS SHIP_TO
                             , SUM(E.SHIP_QTY)    AS RESULT_QTY
                          FROM SCM_DNM_SCS_SHIP_RESULT E
                         WHERE E.SHIP_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           AND NVL(E.ATTRIBUTE5, '-') = '-'
                         GROUP BY E.DIVISION_ID
                             , E.ATTRIBUTE5
                             , E.SHIP_DATE
                             , E.ITEM_ID
                             , E.SCM_SITE_ID
                             , E.TO_SITE
                             , E.ATTRIBUTE4
                       ) XB
                UNION ALL
                /* SSP출하계획 ( confirm된 계획) */
                SELECT XC.DIVISION_ID     AS DIVISION_ID
                     , 'P'                AS TYPE
                     , XC.ERP_SO_NO       AS ERP_SO_NO
                     , XC.CONFIRM_ID      AS CONFIRM_ID
                     , XC.ITEM_ID         AS ITEM_ID
                     , XC.FROM_SITE       AS FROM_SITE
                     , XC.TO_SITE         AS TO_SITE
                     , XC.END_CUSTOMER    AS END_CUSTOMER
                     , XC.QTY             AS QTY
                     , XC.YYYYMMDD        AS YYYYMMDD
                     , XC.TRANSPORT_MODE  AS TRANSPORT_MODE
                     , XC.INCOTERMS       AS INCOTERMS
                     , XC.ETD_DATE        AS ETD_DATE
                     , XC.ETA_DATE        AS ETA_DATE
                     , NULL               AS SHIP_TYPE
                     , XC.SHIP_TO         AS SHIP_TO
                  FROM (
                        /* Current Version */
                        SELECT C.DIVISION_ID     AS DIVISION_ID
                             , C.ERP_SO_NO       AS ERP_SO_NO
                             , C.CONFIRM_ID      AS CONFIRM_ID
                             , C.ITEM_ID         AS ITEM_ID
                             , C.FROM_SITE       AS FROM_SITE
                             , C.TO_SITE         AS TO_SITE
                             , CASE WHEN C.DIVISION_ID = '4O' THEN NVL(SI.PROJECT_CODE, '/')
                                    ELSE NVL(TS.END_CUSTOMER, '-') END AS END_CUSTOMER
                             , C.QTY             AS QTY
                             , C.YYYYMMDD        AS YYYYMMDD
                             , C.TRANSPORT_MODE  AS TRANSPORT_MODE
                             , C.INCOTERMS       AS INCOTERMS
                             , C.ETD_DATE        AS ETD_DATE
                             , C.ETA_DATE        AS ETA_DATE
                             , C.TO_SITE_SHIPTO_CODE AS SHIP_TO
                          FROM SSP_ANL_SHIP_CONFIRM C
                             , SCM_MST_SITE MS
                             , SCM_MST_SITE_ITEM SI
                             , SCM_MST_SITE TS
                         WHERE C.DIVISION_ID = MS.DIVISION_ID
                           AND C.FROM_SITE   = MS.SCM_SITE_ID
                           AND MS.SITE_TYPE  = 'PLANT'
                           AND C.DIVISION_ID = '40'
                           AND MS.OPERATION_GROUP = 'P'
                           AND SI.DIVISION_ID(+)  = C.DIVISION_ID
                           AND SI.ITEM_ID(+)      = C.ITEM_ID
                           AND SI.SCM_SITE_ID(+)  = C.TO_SITE
                           AND SI.PROJECT_CODE(+) = C.PROJECT_CODE
                           AND TS.DIVISION_ID(+)  = C.DIVISION_ID
                           AND TS.SCM_SITE_ID(+)  = C.TO_SITE
                           AND TS.VALID_YN(+)     = 'Y'   /* NERP 추가 */
                           AND C.CHANGE_TYPE = 'C'
                           AND C.QTY > 0
                           AND C.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           AND P_REAL_FLAG = 'Y'
                        UNION ALL
                        /* OLD Version */
                        SELECT D.DIVISION_ID     AS DIVISION_ID
                             , NULL              AS ERP_SO_NO
                             , D.CONFIRM_ID      AS CONFIRM_ID
                             , D.ITEM_ID         AS ITEM_ID
                             , D.FROM_SITE       AS FROM_SITE
                             , V.TO_SITE         AS TO_SITE
                             , CASE WHEN D.DIVISION_ID = '4O' THEN NVL(SI.PROJECT_CODE, '/')
                                    ELSE NVL(TS.END_CUSTOMER, '-') END AS END_CUSTOMER
                             , D.QTY             AS QTY
                             , D.YYYYMMDD        AS YYYYMMDD
                             , V.TRANSPORT_MODE  AS TRANSPORT_MODE
                             , V.INCOTERMS       AS INCOTERMS
                             , D.ETD_DATE        AS ETD_DATE
                             , D.ETA_DATE        AS ETA_DATE
                             , D.SHIPTO_CODE     AS SHIP_TO
                          FROM SSP_ANL_SHIP_PLAN_P D
                             , SCP_MST_BOD_N_V V
                             , SCM_MST_SITE_ITEM SI
                             , SCM_MST_SITE TS
                         WHERE D.BOD_ID = V.BOD_ID
                           AND SI.DIVISION_ID(+)  = D.DIVISION_ID
                           AND SI.ITEM_ID(+)      = D.ITEM_ID
                           AND SI.SCM_SITE_ID(+)  = V.TO_SITE
                           AND SI.PROJECT_CODE(+) = D.PROJECT_CODE
                           AND TS.DIVISION_ID(+)  = D.DIVISION_ID
                           AND TS.SCM_SITE_ID(+)  = V.TO_SITE
                           AND TS.VALID_YN(+)     = 'Y'   /* NERP 추가 */
                           AND D.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                           AND D.MEASURE      = 'SHIP_CONFIRM'
                           AND D.CONFIRM_FLAG = 'Y'
                           AND D.QTY > 0
                           AND D.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           AND P_REAL_FLAG = 'N'
                       ) XC
               ) X
             , SCM_MST_SITE B
             , SCM_ADM_LOOKUP_MASTER_DETAIL C
             , SSP_MST_MODEL_USER M
               /* 20211126  SMS  추가  Shipto Description */
             --, (SELECT DIVISION_ID, SHIPTO_CODE, MAX(SHIPTO_DESCRIPTION) AS SHIPTO_DESCRIPTION
                  --FROM SCM_MST_CUSTOMER
                 --WHERE DIVISION_ID = '40'
                 --GROUP BY DIVISION_ID, SHIPTO_CODE) D
             , (SELECT DIVISION_ID, UPPER(RTRIM(SHIPTO_CODE)) AS SHIPTO_CODE, MAX(SHIPTO_DESCRIPTION) AS SHIPTO_DESCRIPTION   -- 2026.09.17 AJS
                  FROM SCM_MST_CUSTOMER   -- 2026.09.17 AJS
                 WHERE DIVISION_ID = '40'   -- 2026.09.17 AJS
                 GROUP BY DIVISION_ID, UPPER(RTRIM(SHIPTO_CODE))) XF   -- 2026.09.17 AJS
         WHERE B.DIVISION_ID = X.DIVISION_ID
           AND B.SCM_SITE_ID = X.FROM_SITE
           AND B.OPERATION_GROUP <> 'E'
           AND C.LOOKUP_TYPE = 'SSP_SHIPMENT_RESULT_TYPE_PACKER'   /* LOOKUP에 등록된 공정만 */
           AND C.SEGMENT1    = X.TYPE
           AND C.VALID_YN    = 'Y'
           AND M.DIVISION_ID(+) = X.DIVISION_ID
           AND M.FROM_SITE(+)   = X.FROM_SITE
           AND M.ITEM_ID(+)     = X.ITEM_ID
           AND M.VALID_YN(+)    = 'Y'
           --AND X.DIVISION_ID = D.DIVISION_ID(+)
           --AND X.SHIP_TO     = D.SHIPTO_CODE(+)
           AND X.DIVISION_ID = XF.DIVISION_ID(+)   -- 2026.09.17 AJS
           AND UPPER(RTRIM(X.SHIP_TO)) = XF.SHIPTO_CODE(+)   -- 2026.09.17 AJS
           AND X.DIVISION_ID = P_DIVISION_ID
           --AND ((P_COMPANY_ID IS NULL OR P_COMPANY_ID = '') OR B.COMPANY_ID = P_COMPANY_ID)
           AND ((TRIM(P_COMPANY_ID) IS NULL) OR B.COMPANY_ID = P_COMPANY_ID)   -- 2026.09.17 AJS
           --AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
           AND ((TRIM(P_FROM_SITE) IS NULL)   -- 2026.09.17 AJS
                 OR X.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
           --AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
           AND ((TRIM(P_ITEM_ID) IS NULL)   -- 2026.09.17 AJS
                 --OR X.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                 OR X.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
           --AND ((P_TYPE IS NULL OR P_TYPE = '')
           AND ((TRIM(P_TYPE) IS NULL)   -- 2026.09.17 AJS
                 OR X.TYPE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_TYPE, ','))))
           /* 체크박스 체크 여부 조회 시작(P_NONCHK = 'Y' : 체크박스 선택 안한 상태) */
           AND ((P_NONCHK = 'Y' AND 1 = 1)
                 OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                   UNION
                                  SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                    FROM SSP_MST_DELEGATE
                                   WHERE VALID_YN = 'Y'
                                     AND DELEGATEE_ID = P_USER_ID
                                   GROUP BY USER_ID)
                 OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                 OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
           /* 체크박스 체크 여부 조회 끝 */
         --ORDER BY X.DIVISION_ID
             --, X.FROM_SITE
             --, X.YYYYMMDD
             --, X.ITEM_ID
             --, X.TO_SITE
             --, C.DISPLAY_SEQ
             --, X.CONFIRM_ID;
         ORDER BY X.DIVISION_ID NULLS FIRST   /* MSSQL 오름차순 NULL 앞 */   -- 2026.09.17 AJS
             , X.FROM_SITE NULLS FIRST   -- 2026.09.17 AJS
             , X.YYYYMMDD NULLS FIRST   -- 2026.09.17 AJS
             , X.ITEM_ID NULLS FIRST   -- 2026.09.17 AJS
             , X.TO_SITE NULLS FIRST   -- 2026.09.17 AJS
             , C.DISPLAY_SEQ NULLS FIRST   -- 2026.09.17 AJS
             , X.CONFIRM_ID NULLS FIRST;   -- 2026.09.17 AJS

    END P_SSP0015_GET_SHIPMENT_RESULT_PACKER;

    /* ============================================================
       P_SSP0015_GET_BLOCK_STOCK
       AS-IS SSP0015_GET_BLOCK_STOCK - 결과셋 2벌(본문 · 상세)
       ※ AS-IS 는 두 결과셋의 SELECT 문이 완전히 같다. 조회조건만 P_SEARCH_YN 으로 갈린다.
       ============================================================ */
    PROCEDURE P_SSP0015_GET_BLOCK_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_LANGUAGE              IN  VARCHAR2 DEFAULT 'KO',
        P_SEARCH_YN             IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2 DEFAULT 'N',
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_BLOCK_STOCK
         * Description  : Shipment PSI(Small)
         * Program History
         *===================================================================================================
         *   Date       In Charge		Description
         *===================================================================================================
         * 2019/03/05   AYJ 			Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
         * 2019/06/17	AYJ				조회 조건 추가(p_partLeaderChk, p_teamLeaderChk)
         * 2019/08/28	AYJ			    조회 조건 추가(p_delegateeChk)
         * 2026.09.16   AJS             MSSQL -> Oracle 전환
         */
        V_BASE_YYYYMMDD VARCHAR2(8 CHAR);
    BEGIN

        /* AS-IS : convert(varchar(8), convert(datetime, @p_plan_start_yyyymmdd) +1, 112) */
        V_BASE_YYYYMMDD := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD');

        IF P_SEARCH_YN != 'Y' THEN

            /* 1. 셀 더블클릭 */
            OPEN O_RC1 FOR
            SELECT A.HOLD_ID
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_NM
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                 , TO_CHAR(FN_CHAR_TO_DATE(A.HOLD_YYYYMMDD), 'YYYY-MM-DD')    AS HOLD_YYYYMMDD
                 , TO_CHAR(FN_CHAR_TO_DATE(A.RELEASE_YYYYMMDD), 'YYYY-MM-DD') AS RELEASE_YYYYMMDD
                 , A.HOLD_QTY
                 , A.REMARKS
                   /* MSSQL 은 UserName 이 NULL 이면 결합 결과도 NULL 이다 - 판정을 유지한다 */
                 /* 2026.09.30 AJS 수정 (START) */
               --, CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
                      --ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                 /* 2026.09.30 AJS 수정 (END) */
                   END AS LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE
              FROM SSP_ANL_HOLD_STOCK A
                 /* 2026.09.30 AJS 수정 (START) */
               --, TB_FX_USER U
                 , SCM_ADM_USER_M U
                 /* 2026.09.30 AJS 수정 (END) */
                 , SSP_MST_MODEL_USER M
             /* 2026.09.30 AJS 수정 (START) */
           --WHERE A.LAST_UPDATED_BY = U.USERID(+)
             --AND U.USEYN(+)        = 'Y'
             WHERE A.LAST_UPDATED_BY = U.USER_ID(+)
               AND U.USE_YN(+)        = 'Y'
             /* 2026.09.30 AJS 수정 (END) */
               AND M.DIVISION_ID(+)  = A.DIVISION_ID
               AND M.FROM_SITE(+)    = A.FROM_SITE
               AND M.ITEM_ID(+)      = A.ITEM_ID
               AND M.VALID_YN(+)     = 'Y'
               AND A.DIVISION_ID         = P_DIVISION_ID
               AND A.FROM_SITE           = P_FROM_SITE
               AND A.HOLD_YYYYMMDD      <= V_BASE_YYYYMMDD
               AND A.RELEASE_YYYYMMDD   >= V_BASE_YYYYMMDD
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = P_SEQ
               --AND A.ITEM_ID             = P_ITEM_ID
               AND A.ITEM_ID             = UPPER(P_ITEM_ID)   -- 2026.09.17 AJS
             GROUP BY A.HOLD_ID
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID)
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-')
                 , A.HOLD_YYYYMMDD
                 , A.RELEASE_YYYYMMDD
                 , A.HOLD_QTY
                 , A.REMARKS
                 , A.LAST_UPDATE_DATE
                 /* 2026.09.30 AJS 수정 (START) */
               --, CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
                      --ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                 /* 2026.09.30 AJS 수정 (END) */
                   END
             ORDER BY A.HOLD_ID;

            /* Block Stock Detail - AS-IS 는 위와 같은 문장이다 */
            OPEN O_RC2 FOR
            SELECT A.HOLD_ID
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_NM
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                 , TO_CHAR(FN_CHAR_TO_DATE(A.HOLD_YYYYMMDD), 'YYYY-MM-DD')    AS HOLD_YYYYMMDD
                 , TO_CHAR(FN_CHAR_TO_DATE(A.RELEASE_YYYYMMDD), 'YYYY-MM-DD') AS RELEASE_YYYYMMDD
                 , A.HOLD_QTY
                 , A.REMARKS
                 /* 2026.09.30 AJS 수정 (START) */
               --, CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
                      --ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                 /* 2026.09.30 AJS 수정 (END) */
                   END AS LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE
              FROM SSP_ANL_HOLD_STOCK A
                 /* 2026.09.30 AJS 수정 (START) */
               --, TB_FX_USER U
                 , SCM_ADM_USER_M U
                 /* 2026.09.30 AJS 수정 (END) */
                 , SSP_MST_MODEL_USER M
             /* 2026.09.30 AJS 수정 (START) */
           --WHERE A.LAST_UPDATED_BY = U.USERID(+)
             --AND U.USEYN(+)        = 'Y'
             WHERE A.LAST_UPDATED_BY = U.USER_ID(+)
               AND U.USE_YN(+)        = 'Y'
             /* 2026.09.30 AJS 수정 (END) */
               AND M.DIVISION_ID(+)  = A.DIVISION_ID
               AND M.FROM_SITE(+)    = A.FROM_SITE
               AND M.ITEM_ID(+)      = A.ITEM_ID
               AND M.VALID_YN(+)     = 'Y'
               AND A.DIVISION_ID         = P_DIVISION_ID
               AND A.FROM_SITE           = P_FROM_SITE
               AND A.HOLD_YYYYMMDD      <= V_BASE_YYYYMMDD
               AND A.RELEASE_YYYYMMDD   >= V_BASE_YYYYMMDD
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = P_SEQ
               --AND A.ITEM_ID             = P_ITEM_ID
               AND A.ITEM_ID             = UPPER(P_ITEM_ID)   -- 2026.09.17 AJS
             GROUP BY A.HOLD_ID
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID)
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-')
                 , A.HOLD_YYYYMMDD
                 , A.RELEASE_YYYYMMDD
                 , A.HOLD_QTY
                 , A.REMARKS
                 , A.LAST_UPDATE_DATE
                 /* 2026.09.30 AJS 수정 (START) */
               --, CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
                      --ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                 /* 2026.09.30 AJS 수정 (END) */
                   END
             ORDER BY A.HOLD_ID;

        ELSE

            /* 2. btnSearch */
            OPEN O_RC1 FOR
            SELECT A.HOLD_ID
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_NM
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                 , TO_CHAR(FN_CHAR_TO_DATE(A.HOLD_YYYYMMDD), 'YYYY-MM-DD')    AS HOLD_YYYYMMDD
                 , TO_CHAR(FN_CHAR_TO_DATE(A.RELEASE_YYYYMMDD), 'YYYY-MM-DD') AS RELEASE_YYYYMMDD
                 , A.HOLD_QTY
                 , A.REMARKS
                 /* 2026.09.30 AJS 수정 (START) */
               --, CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
                      --ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                 /* 2026.09.30 AJS 수정 (END) */
                   END AS LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE
              FROM SSP_ANL_HOLD_STOCK A
                 /* 2026.09.30 AJS 수정 (START) */
               --, TB_FX_USER U
                 , SCM_ADM_USER_M U
                 /* 2026.09.30 AJS 수정 (END) */
                 , SSP_MST_MODEL_USER M
             /* 2026.09.30 AJS 수정 (START) */
           --WHERE A.LAST_UPDATED_BY = U.USERID(+)
             --AND U.USEYN(+)        = 'Y'
             WHERE A.LAST_UPDATED_BY = U.USER_ID(+)
               AND U.USE_YN(+)        = 'Y'
             /* 2026.09.30 AJS 수정 (END) */
               AND M.DIVISION_ID(+)  = A.DIVISION_ID
               AND M.FROM_SITE(+)    = A.FROM_SITE
               AND M.ITEM_ID(+)      = A.ITEM_ID
               AND M.VALID_YN(+)     = 'Y'
               AND A.DIVISION_ID         = P_DIVISION_ID
               --AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
               AND ((TRIM(P_FROM_SITE) IS NULL)   -- 2026.09.17 AJS
                     OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
               AND A.HOLD_YYYYMMDD      <= V_BASE_YYYYMMDD
               AND A.RELEASE_YYYYMMDD   >= V_BASE_YYYYMMDD
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = P_SEQ
               --AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
               AND ((TRIM(P_ITEM_ID) IS NULL)   -- 2026.09.17 AJS
                     --OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                     OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
               /* 체크박스 체크 여부 조회 시작(P_NONCHK = 'Y' : 체크박스 선택 안한 상태) */
               AND ((P_NONCHK = 'Y' AND 1 = 1)
                     OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                       UNION
                                      SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                        FROM SSP_MST_DELEGATE
                                       WHERE VALID_YN = 'Y'
                                         AND DELEGATEE_ID = P_USER_ID
                                       GROUP BY USER_ID)
                     OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                     OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
               /* 체크박스 체크 여부 조회 끝 */
             GROUP BY A.HOLD_ID
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID)
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-')
                 , A.HOLD_YYYYMMDD
                 , A.RELEASE_YYYYMMDD
                 , A.HOLD_QTY
                 , A.REMARKS
                 , A.LAST_UPDATE_DATE
                 /* 2026.09.30 AJS 수정 (START) */
               --, CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
                      --ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                 /* 2026.09.30 AJS 수정 (END) */
                   END
             ORDER BY A.HOLD_ID;

            OPEN O_RC2 FOR
            SELECT A.HOLD_ID
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_NM
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                 , TO_CHAR(FN_CHAR_TO_DATE(A.HOLD_YYYYMMDD), 'YYYY-MM-DD')    AS HOLD_YYYYMMDD
                 , TO_CHAR(FN_CHAR_TO_DATE(A.RELEASE_YYYYMMDD), 'YYYY-MM-DD') AS RELEASE_YYYYMMDD
                 , A.HOLD_QTY
                 , A.REMARKS
                 /* 2026.09.30 AJS 수정 (START) */
               --, CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
                      --ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                 /* 2026.09.30 AJS 수정 (END) */
                   END AS LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE
              FROM SSP_ANL_HOLD_STOCK A
                 /* 2026.09.30 AJS 수정 (START) */
               --, TB_FX_USER U
                 , SCM_ADM_USER_M U
                 /* 2026.09.30 AJS 수정 (END) */
                 , SSP_MST_MODEL_USER M
             /* 2026.09.30 AJS 수정 (START) */
           --WHERE A.LAST_UPDATED_BY = U.USERID(+)
             --AND U.USEYN(+)        = 'Y'
             WHERE A.LAST_UPDATED_BY = U.USER_ID(+)
               AND U.USE_YN(+)        = 'Y'
             /* 2026.09.30 AJS 수정 (END) */
               AND M.DIVISION_ID(+)  = A.DIVISION_ID
               AND M.FROM_SITE(+)    = A.FROM_SITE
               AND M.ITEM_ID(+)      = A.ITEM_ID
               AND M.VALID_YN(+)     = 'Y'
               AND A.DIVISION_ID         = P_DIVISION_ID
               --AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
               AND ((TRIM(P_FROM_SITE) IS NULL)   -- 2026.09.17 AJS
                     OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
               AND A.HOLD_YYYYMMDD      <= V_BASE_YYYYMMDD
               AND A.RELEASE_YYYYMMDD   >= V_BASE_YYYYMMDD
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = P_SEQ
               --AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
               AND ((TRIM(P_ITEM_ID) IS NULL)   -- 2026.09.17 AJS
                     --OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                     OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
               AND ((P_NONCHK = 'Y' AND 1 = 1)
                     OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                       UNION
                                      SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                        FROM SSP_MST_DELEGATE
                                       WHERE VALID_YN = 'Y'
                                         AND DELEGATEE_ID = P_USER_ID
                                       GROUP BY USER_ID)
                     OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                     OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
             GROUP BY A.HOLD_ID
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID)
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-')
                 , A.HOLD_YYYYMMDD
                 , A.RELEASE_YYYYMMDD
                 , A.HOLD_QTY
                 , A.REMARKS
                 , A.LAST_UPDATE_DATE
                 /* 2026.09.30 AJS 수정 (START) */
               --, CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
                      --ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                 /* 2026.09.30 AJS 수정 (END) */
                   END
             ORDER BY A.HOLD_ID;

        END IF;

    END P_SSP0015_GET_BLOCK_STOCK;

    /* ============================================================
       P_SSP0015_GET_WH_STOCK
       AS-IS SSP0015_GET_WH_STOCK - 결과셋 2벌(본문 · 상세)
       ============================================================ */
    PROCEDURE P_SSP0015_GET_WH_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_PLAN_SEQ              IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_SEARCH_YN             IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_WH_STOCK
         * Description  : Shipment PSI(Small)
         * Program History
         *===================================================================================================
         *   Date       In Charge		Description
         *===================================================================================================
         * 2019/03/05   AYJ			Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
         * 2019/06/17	AYJ			조회 조건 추가(p_partLeaderChk, p_teamLeaderChk)
         * 2019/08/28	AYJ			조회 조건 추가(p_delegateeChk)
         * 2026.09.16   AJS         MSSQL -> Oracle 전환
         */
    BEGIN

        IF P_SEARCH_YN != 'Y' THEN

            /* 1. 셀 더블클릭 - W/H Stock */
            OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.PLANT_ID
                 , A.STORAGE_ID || ' ' || B.STORAGE_DESCRIPTION AS STORAGE_ID
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                 , A.STOCK_STATUS
                 , A.GRADE
                 , A.CAPACITY_GRADE          AS CAPA_GRADE
                 , A.SOC
                 , SUM(A.STOCK_QTY)          AS STOCK_QTY
                 , SUM(A.AVAILABLE_QTY)      AS AVAILABLE_QTY
                 , SUM(A.NON_QC_QTY)         AS UNDECIDED_QTY
                 , SUM(A.ALLOCATION_QTY)     AS ALLOCATION_QTY
                 , SUM(A.BLOCK_QTY)          AS HOLD_QTY
                 , SUM(A.PACKING_QTY)        AS PACKING_QTY
                 , SUM(A.MOVING_QTY)         AS MOVING_QTY
                 , SUM(A.RCVLOC_QTY)         AS RECEIVING_QTY
                 , SUM(A.EXPIRATION_QTY)     AS EXPIRATION_QTY
                 , SUM(A.LONG_QTY)           AS LONG_TERM_QTY
              FROM SSP_ANL_OWMS_STOCK_C A
                 , SCM_MST_SLOC B
                 , SSP_MST_MODEL_USER M
             WHERE B.DIVISION_ID(+) = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END
               AND B.STORAGE_ID(+)  = A.STORAGE_ID
               AND B.PLANT_ID(+)    = A.PLANT_ID
               AND M.DIVISION_ID(+) = A.DIVISION_ID
               AND M.FROM_SITE(+)   = A.FROM_SITE
               AND M.ITEM_ID(+)     = A.ITEM_ID
               AND M.VALID_YN(+)    = 'Y'
               AND A.DIVISION_ID         = P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = P_PLAN_SEQ
               AND A.FROM_SITE           = P_FROM_SITE
               --AND A.ITEM_ID             = P_ITEM_ID
               AND A.ITEM_ID             = UPPER(P_ITEM_ID)   -- 2026.09.17 AJS
             GROUP BY A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID)
                 , A.STOCK_STATUS
                 , A.GRADE
                 , A.CAPACITY_GRADE
                 , A.SOC
                 , A.PLANT_ID
                 , A.DIVISION_ID
                 , A.STORAGE_ID
                 , B.STORAGE_DESCRIPTION
             ORDER BY A.DIVISION_ID
                 , A.PLANT_ID
                 , A.STORAGE_ID
                 , A.ITEM_ID
                 , A.GRADE
                 , A.CAPACITY_GRADE
                 , A.SOC;

            /* 1. 셀 더블클릭 - W/H Stock Detail */
            OPEN O_RC2 FOR
            SELECT IA.*
              FROM (
                    SELECT A.DIVISION_ID
                         , A.ITEM_ID
                         , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                         , A.GRADE
                         , A.CAPACITY_GRADE     AS CAPA_GRADE
                         , A.SOC
                         , A.LOT_ID
                         , A.PALLET_ID
                         , A.STOCK_QTY
                         , A.AVAILABLE_QTY
                         , A.NON_QC_QTY         AS UNDECIDED_QTY
                         , A.ALLOCATION_QTY
                         --, A.BLOCK_QTY          AS HOLD_QTY
                         , A.BLOCK_QTY          AS "Hold_Qty"   /* AS-IS 칸 이름 Hold_Qty 유지 */   -- 2026.09.17 AJS
                         , A.PACKING_QTY
                         , A.MOVING_QTY
                         , A.RCVLOC_QTY         AS RECEIVING_QTY
                         , A.EXPIRATION_QTY
                         , A.LONG_QTY           AS LONG_TERM_QTY
                         , A.PLANT_ID
                         , A.PACKING_STATUS
                         , A.STOCK_STATUS
                         , A.STORAGE_ID || ' ' || B.STORAGE_DESCRIPTION AS STORAGE_ID
                         , A.CUSTOMER_CODE
                         , A.CUSTOMER_NAME
                         , CASE WHEN REGEXP_LIKE(A.LOT_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.LOT_DATE, 'YYYYMMDD'), 'YYYY-MM-DD')
                           END AS LOT_ISSUE_DATE
                      FROM SSP_ANL_OWMS_STOCK_C A
                         , SCM_MST_SLOC B
                         , SSP_MST_MODEL_USER M
                     WHERE B.DIVISION_ID(+) = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END
                       AND B.STORAGE_ID(+)  = A.STORAGE_ID
                       AND B.PLANT_ID(+)    = A.PLANT_ID
                       AND M.DIVISION_ID(+) = A.DIVISION_ID
                       AND M.FROM_SITE(+)   = A.FROM_SITE
                       AND M.ITEM_ID(+)     = A.ITEM_ID
                       AND M.VALID_YN(+)    = 'Y'
                       AND A.DIVISION_ID         = P_DIVISION_ID
                       AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                       AND A.PLAN_TYPE           = P_PLAN_TYPE
                       AND A.SEQ                 = P_PLAN_SEQ
                       AND A.FROM_SITE           = P_FROM_SITE
                       --AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                       AND ((TRIM(P_ITEM_ID) IS NULL)   -- 2026.09.17 AJS
                             --OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                             OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
                   ) IA
             ORDER BY IA.DIVISION_ID
                 , IA.PLANT_ID
                 , IA.STORAGE_ID
                 , IA.ITEM_ID
                 , IA.GRADE
                 , IA.CAPA_GRADE
                 , IA.SOC
                 , IA.LOT_ID
                 , IA.PALLET_ID;

        ELSE

            /* 2. btnSearch - W/H Stock */
            OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.PLANT_ID
                 , A.STORAGE_ID || ' ' || B.STORAGE_DESCRIPTION AS STORAGE_ID
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                 , A.STOCK_STATUS
                 , A.GRADE
                 , A.CAPACITY_GRADE          AS CAPA_GRADE
                 , A.SOC
                 , SUM(A.STOCK_QTY)          AS STOCK_QTY
                 , SUM(A.AVAILABLE_QTY)      AS AVAILABLE_QTY
                 , SUM(A.NON_QC_QTY)         AS UNDECIDED_QTY
                 , SUM(A.ALLOCATION_QTY)     AS ALLOCATION_QTY
                 , SUM(A.BLOCK_QTY)          AS HOLD_QTY
                 , SUM(A.PACKING_QTY)        AS PACKING_QTY
                 , SUM(A.MOVING_QTY)         AS MOVING_QTY
                 , SUM(A.RCVLOC_QTY)         AS RECEIVING_QTY
                 , SUM(A.EXPIRATION_QTY)     AS EXPIRATION_QTY
                 , SUM(A.LONG_QTY)           AS LONG_TERM_QTY
              FROM SSP_ANL_OWMS_STOCK_C A
                 , SCM_MST_SLOC B
                 , SSP_MST_MODEL_USER M
             WHERE B.DIVISION_ID(+) = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END
               AND B.STORAGE_ID(+)  = A.STORAGE_ID
               AND B.PLANT_ID(+)    = A.PLANT_ID
               AND M.DIVISION_ID(+) = A.DIVISION_ID
               AND M.FROM_SITE(+)   = A.FROM_SITE
               AND M.ITEM_ID(+)     = A.ITEM_ID
               AND M.VALID_YN(+)    = 'Y'
               AND A.DIVISION_ID         = P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = P_PLAN_SEQ
               --AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
               AND ((TRIM(P_FROM_SITE) IS NULL)   -- 2026.09.17 AJS
                     OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
               --AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
               AND ((TRIM(P_ITEM_ID) IS NULL)   -- 2026.09.17 AJS
                     --OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                     OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
               /* 체크박스 체크 여부 조회 시작(P_NONCHK = 'Y' : 체크박스 선택 안한 상태) */
               AND ((P_NONCHK = 'Y' AND 1 = 1)
                     OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                       UNION
                                      SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                        FROM SSP_MST_DELEGATE
                                       WHERE VALID_YN = 'Y'
                                         AND DELEGATEE_ID = P_USER_ID
                                       GROUP BY USER_ID)
                     OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                     OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
               /* 체크박스 체크 여부 조회 끝 */
             GROUP BY A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID)
                 , A.STOCK_STATUS
                 , A.GRADE
                 , A.CAPACITY_GRADE
                 , A.SOC
                 , A.PLANT_ID
                 , A.DIVISION_ID
                 , A.STORAGE_ID
                 , B.STORAGE_DESCRIPTION
             ORDER BY A.DIVISION_ID
                 , A.PLANT_ID
                 , A.STORAGE_ID
                 , A.ITEM_ID
                 , A.GRADE
                 , A.CAPACITY_GRADE
                 , A.SOC;

            /* 2. btnSearch - W/H Stock Detail */
            OPEN O_RC2 FOR
            SELECT IA.*
              FROM (
                    SELECT A.DIVISION_ID
                         , A.ITEM_ID
                         , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                         , A.GRADE
                         , A.CAPACITY_GRADE     AS CAPA_GRADE
                         , A.SOC
                         , A.LOT_ID
                         , A.PALLET_ID
                         , A.STOCK_QTY
                         , A.AVAILABLE_QTY
                         , A.NON_QC_QTY         AS UNDECIDED_QTY
                         , A.ALLOCATION_QTY
                         --, A.BLOCK_QTY          AS HOLD_QTY
                         , A.BLOCK_QTY          AS "Hold_Qty"   /* AS-IS 칸 이름 Hold_Qty 유지 */   -- 2026.09.17 AJS
                         , A.PACKING_QTY
                         , A.MOVING_QTY
                         , A.RCVLOC_QTY         AS RECEIVING_QTY
                         , A.EXPIRATION_QTY
                         , A.LONG_QTY           AS LONG_TERM_QTY
                         , A.PLANT_ID
                         , A.PACKING_STATUS
                         , A.STOCK_STATUS
                         , A.STORAGE_ID || ' ' || B.STORAGE_DESCRIPTION AS STORAGE_ID
                         , A.CUSTOMER_CODE
                         , A.CUSTOMER_NAME
                         , CASE WHEN REGEXP_LIKE(A.LOT_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.LOT_DATE, 'YYYYMMDD'), 'YYYY-MM-DD')
                           END AS LOT_ISSUE_DATE
                      FROM SSP_ANL_OWMS_STOCK_C A
                         , SCM_MST_SLOC B
                         , SSP_MST_MODEL_USER M
                     WHERE B.DIVISION_ID(+) = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END
                       AND B.STORAGE_ID(+)  = A.STORAGE_ID
                       AND B.PLANT_ID(+)    = A.PLANT_ID
                       AND M.DIVISION_ID(+) = A.DIVISION_ID
                       AND M.FROM_SITE(+)   = A.FROM_SITE
                       AND M.ITEM_ID(+)     = A.ITEM_ID
                       AND M.VALID_YN(+)    = 'Y'
                       AND A.DIVISION_ID         = P_DIVISION_ID
                       AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                       AND A.PLAN_TYPE           = P_PLAN_TYPE
                       AND A.SEQ                 = P_PLAN_SEQ
                       --AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                       AND ((TRIM(P_FROM_SITE) IS NULL)   -- 2026.09.17 AJS
                             OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
                       --AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                       AND ((TRIM(P_ITEM_ID) IS NULL)   -- 2026.09.17 AJS
                             --OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                             OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
                       /* 체크박스 체크 여부 조회 시작(P_NONCHK = 'Y' : 체크박스 선택 안한 상태) */
                       AND ((P_NONCHK = 'Y' AND 1 = 1)
                             OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                               UNION
                                              SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                FROM SSP_MST_DELEGATE
                                               WHERE VALID_YN = 'Y'
                                                 AND DELEGATEE_ID = P_USER_ID
                                               GROUP BY USER_ID)
                             OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                             OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
                       /* 체크박스 체크 여부 조회 끝 */
                   ) IA
             ORDER BY IA.DIVISION_ID
                 , IA.PLANT_ID
                 , IA.STORAGE_ID
                 , IA.ITEM_ID
                 , IA.GRADE
                 , IA.CAPA_GRADE
                 , IA.SOC
                 , IA.LOT_ID
                 , IA.PALLET_ID;

        END IF;

    END P_SSP0015_GET_WH_STOCK;

    /* ============================================================
       P_SSP0015_GET_MES_STOCK
       AS-IS SSP0015_GET_MES_STOCK
       ※ AS-IS SUBSTRING(LOT_ID, 0, 9) 는 8자다. Oracle SUBSTR(x,0,9) 는 9자라
          SUBSTR(LOT_ID, 1, 8) 로 옮긴다.
       ============================================================ */
    PROCEDURE P_SSP0015_GET_MES_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_LOT_ID                IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_LANGUAGE              IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   @ PKG_SSP0015.P_SSP0015_GET_MES_STOCK
         * Description  @ MES Stock
         * Program History
         *===================================================================================================
         *   Date       In Charge		Description
         *===================================================================================================
         * 2019/10/24   AYJ				MES Stock 시트 조회
         * 2019/01/06   KIMYHONGHO		[]MES Sotck 시트 운영 신규 적용
         * 2020/01/20   KIMYHONGHO		[C20200115-000414] MES Stock Detail 화면 개선 요청건
         * 2020/03/18   KIMYONGHO		[C20200303-000163] LONGTERM_HOLD_YN 컬럼 추가
         * 2021/07/26	KIMYONGHO       C20210708-000537 : [SCM PI팀] 재고 정합성 관련 GMES 불량 수량 GSCM 전송 요청
         * 2026.09.16   AJS             MSSQL -> Oracle 전환
         */
    BEGIN

        OPEN O_RC1 FOR
        SELECT XA.ROW_NO AS "ROWNUM"   /* AS-IS 칸 이름이 ROWNUM 이라 그대로 내보낸다(Oracle 예약어라 인용부호) */
             , XA.DIVISION_ID
             , XA.FROM_SITE
             , XA.ITEM_ID
             , XA.NICK_NAME
             , XA.LOT_ID
             , XA.YYYYMMDD_LOT_ID_APPLIED_LT
             , XA.MES_CHANGE_STATUS
             , XA.LOT_TYPE
             , XA.LOT_QTY_MES
             , XA.LOT_QTY_MES_NG
             , XA.LOT_QTY_FCS
             , XA.FCS_SPECIAL_QTY
             , XA.OWMS_STOCK_QTY
             , XA.LOT_QTY_TOT
             , XA.AVAILABLE_YN
             , XA.MES_HOLD_YN
             , XA.QMS_HOLD_YN
             , XA.FCS_HOLD_YN
             , XA.LONGTERM_HOLD_YN
             , XA.JUDG_VLD_DATE
             , XA.MES_HOLD_RELEASE
             , XA.QMS_HOLD_RELEASE
             , XA.USER_MOD_RELEASE_DATE
             , XA.REMARKS
             , XA.LAST_UPDATED_BY
             , XA.LAST_UPDATE_DATE
          FROM (
                SELECT ROW_NUMBER() OVER (PARTITION BY IA.DIVISION_ID, IA.FROM_SITE, IA.ITEM_ID, IA.LOT_ID
                                              --ORDER BY IA.LOT_TYPE DESC, IA.MES_CHANGE_STATUS DESC) AS ROW_NO
                                              ORDER BY IA.LOT_TYPE DESC NULLS LAST, IA.MES_CHANGE_STATUS DESC NULLS LAST) AS ROW_NO   /* MSSQL 내림차순 NULL 뒤 */   -- 2026.09.17 AJS
                     , IA.DIVISION_ID
                     , IA.FROM_SITE
                     , IA.ITEM_ID
                     , IA.NICK_NAME
                     , IA.LOT_ID
                     , IA.YYYYMMDD_LOT_ID_APPLIED_LT
                     , IA.MES_CHANGE_STATUS
                     , IA.LOT_TYPE
                     , IA.LOT_QTY_MES
                       /* C20210708-000537 */
                     , IA.LOT_QTY_MES_NG
                     , IA.LOT_QTY_FCS
                     , IA.FCS_SPECIAL_QTY
                     , IA.OWMS_STOCK_QTY
                     , IA.LOT_QTY_TOT
                     , IA.AVAILABLE_YN
                     , IA.MES_HOLD_YN
                     , IA.QMS_HOLD_YN
                     , IA.FCS_HOLD_YN
                     , IA.LONGTERM_HOLD_YN
                     , IA.JUDG_VLD_DATE
                     , IA.MES_HOLD_RELEASE
                     , IA.QMS_HOLD_RELEASE
                     , IA.USER_MOD_RELEASE_DATE
                     , IA.REMARKS
                     , IA.LAST_UPDATED_BY
                     , IA.LAST_UPDATE_DATE
                  FROM (
                        SELECT X.DIVISION_ID
                             , X.FROM_SITE
                             , X.ITEM_ID
                             , FN_GET_ITEM_NICKNAME(X.DIVISION_ID, X.ITEM_ID) AS NICK_NAME
                             , X.LOT_ID                             AS LOT_ID
                             , CASE WHEN REGEXP_LIKE(X.YYYYMMDD_LOT_ID_APPLIED_LT, '^[0-9]{8}$')
                                    THEN TO_CHAR(TO_DATE(X.YYYYMMDD_LOT_ID_APPLIED_LT, 'YYYYMMDD'), 'YYYY-MM-DD')
                               END                                  AS YYYYMMDD_LOT_ID_APPLIED_LT
                             , X.CHANGE_STATUS                      AS MES_CHANGE_STATUS
                             , X.LOT_TYPE
                             , X.LOT_QTY_MES
                               /* C20210708-000537 */
                               /* ATTRIBUTE4 는 VARCHAR2 다. AS-IS 는 UNION 타입 우선순위로 정수가 되므로 숫자로 맞춘다.
                                  원장 칸이라 이관 채움값이 섞여도 조회가 끊기지 않게 방어 변환을 둔다. */
                             , NVL(TO_NUMBER(X.ATTRIBUTE4 DEFAULT NULL ON CONVERSION ERROR), 0) AS LOT_QTY_MES_NG   /* 불량수량 */
                             , X.LOT_QTY_FCS
                             , X.FCS_SPECIAL_QTY
                             , X.OWMS_STOCK_QTY
                             , X.LOT_QTY_TOT                        AS LOT_QTY_TOT
                             , X.AVAILABLE_YN
                             , X.MES_HOLD_YN
                             , X.QMS_HOLD_YN
                             , X.FCS_HOLD_YN
                             , X.LONGTERM_HOLD_YN
                             , CASE WHEN REGEXP_LIKE(X.JUDG_VLD_DATE, '^[0-9]{8}$')
                                    THEN TO_CHAR(TO_DATE(X.JUDG_VLD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD')
                               END                                  AS JUDG_VLD_DATE
                             , CASE WHEN REGEXP_LIKE(X.MES_HOLD_RELEASE, '^[0-9]{8}$')
                                    THEN TO_CHAR(TO_DATE(X.MES_HOLD_RELEASE, 'YYYYMMDD'), 'YYYY-MM-DD')
                               END                                  AS MES_HOLD_RELEASE
                             , CASE WHEN REGEXP_LIKE(X.QMS_HOLD_RELEASE, '^[0-9]{8}$')
                                    THEN TO_CHAR(TO_DATE(X.QMS_HOLD_RELEASE, 'YYYYMMDD'), 'YYYY-MM-DD')
                               END                                  AS QMS_HOLD_RELEASE
                             , CASE WHEN REGEXP_LIKE(X.USER_MOD_RELEASE_DATE, '^[0-9]{8}$')
                                    THEN TO_CHAR(TO_DATE(X.USER_MOD_RELEASE_DATE, 'YYYYMMDD'), 'YYYY-MM-DD')
                               END                                  AS USER_MOD_RELEASE_DATE
                             , X.REMARKS
                             /* 2026.09.30 AJS 수정 (START) */
                           --, CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
                                  --ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || X.LAST_UPDATED_BY || ')'
                             , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                                    ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || X.LAST_UPDATED_BY || ')'
                             /* 2026.09.30 AJS 수정 (END) */
                               END                                  AS LAST_UPDATED_BY
                             , X.LAST_UPDATE_DATE
                          FROM SSP_ANL_MES_FCS_STOCK_40_C X
                             /* 2026.09.30 AJS 수정 (START) */
                           --, TB_FX_USER U
                             , SCM_ADM_USER_M U
                             /* 2026.09.30 AJS 수정 (END) */
                             , SSP_MST_MODEL_USER M
                         /* 2026.09.30 AJS 수정 (START) */
                       --WHERE X.LAST_UPDATED_BY = U.USERID(+)
                         --AND U.USEYN(+)        = 'Y'
                         WHERE X.LAST_UPDATED_BY = U.USER_ID(+)
                           AND U.USE_YN(+)        = 'Y'
                         /* 2026.09.30 AJS 수정 (END) */
                           AND M.DIVISION_ID(+)  = X.DIVISION_ID
                           AND M.FROM_SITE(+)    = X.FROM_SITE
                           AND M.ITEM_ID(+)      = X.ITEM_ID
                           AND M.VALID_YN(+)     = 'Y'
                           AND X.DIVISION_ID         = P_DIVISION_ID
                           AND X.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                           AND X.PLAN_TYPE           = 'SP'
                           AND X.SEQ                 = 1
                           --AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                           AND ((TRIM(P_FROM_SITE) IS NULL)   -- 2026.09.17 AJS
                                 OR X.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
                           --AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                           AND ((TRIM(P_ITEM_ID) IS NULL)   -- 2026.09.17 AJS
                                 --OR X.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                                 OR X.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
                           --AND ((P_LOT_ID IS NULL OR P_LOT_ID = '')
                           AND ((TRIM(P_LOT_ID) IS NULL)   -- 2026.09.17 AJS
                                 --OR X.LOT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_LOT_ID, ','))))
                                 OR X.LOT_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_LOT_ID, ','))))   -- 2026.09.17 AJS
                           /* 체크박스 체크 여부 조회 시작(P_NONCHK = 'Y' @ 체크박스 선택 안한 상태) */
                           AND ((P_NONCHK = 'Y' AND 1 = 1)
                                 OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                                   UNION
                                                  SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                    FROM SSP_MST_DELEGATE
                                                   WHERE VALID_YN = 'Y'
                                                     AND DELEGATEE_ID = P_USER_ID
                                                   GROUP BY USER_ID)
                                 OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                 OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
                        /* [C20200115-000414] OWMS 조회 부분 추가 */
                        UNION ALL
                        SELECT A.DIVISION_ID
                             , A.FROM_SITE
                             , A.ITEM_ID
                             , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                             , SUBSTR(A.LOT_ID, 1, 8)   AS LOT_ID
                             , NULL                     AS YYYYMMDD_LOT_ID_APPLIED_LT
                             , NULL                     AS MES_CHANGE_STATUS
                             , NULL                     AS LOT_TYPE
                             , 0                        AS LOT_QTY_MES
                               /* C20210708-000537 */
                             , 0                        AS LOT_QTY_MES_NG
                             , 0                        AS LOT_QTY_FCS
                             , 0                        AS FCS_SPECIAL_QTY
                             , SUM(A.STOCK_QTY)         AS OWMS_STOCK_QTY
                             , 0                        AS LOT_QTY_TOT
                             , '-'                      AS AVAILABLE_YN
                             , '-'                      AS MES_HOLD_YN
                             , '-'                      AS QMS_HOLD_YN
                             , '-'                      AS FCS_HOLD_YN
                             , '-'                      AS LONGTERM_HOLD_YN
                             , NULL                     AS JUDG_VLD_DATE
                             , NULL                     AS MES_HOLD_RELEASE
                             , NULL                     AS QMS_HOLD_RELEASE
                             , NULL                     AS USER_MOD_RELEASE_DATE
                             , NULL                     AS REMARKS
                             , NULL                     AS LAST_UPDATED_BY
                             , NULL                     AS LAST_UPDATE_DATE
                          FROM SSP_ANL_OWMS_STOCK_C A
                             , SCM_MST_SLOC B
                             , SSP_MST_MODEL_USER M
                         WHERE B.DIVISION_ID(+) = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END
                           AND B.STORAGE_ID(+)  = A.STORAGE_ID
                           AND B.PLANT_ID(+)    = A.PLANT_ID
                           AND M.DIVISION_ID(+) = A.DIVISION_ID
                           AND M.FROM_SITE(+)   = A.FROM_SITE
                           AND M.ITEM_ID(+)     = A.ITEM_ID
                           AND M.VALID_YN(+)    = 'Y'
                           AND A.DIVISION_ID         = P_DIVISION_ID
                           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                           --AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                           AND ((TRIM(P_FROM_SITE) IS NULL)   -- 2026.09.17 AJS
                                 OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
                           --AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                           AND ((TRIM(P_ITEM_ID) IS NULL)   -- 2026.09.17 AJS
                                 --OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                                 OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
                           --AND ((P_LOT_ID IS NULL OR P_LOT_ID = '')
                           AND ((TRIM(P_LOT_ID) IS NULL)   -- 2026.09.17 AJS
                                 --OR A.LOT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_LOT_ID, ','))))
                                 OR A.LOT_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_LOT_ID, ','))))   -- 2026.09.17 AJS
                           AND ((P_NONCHK = 'Y' AND 1 = 1)
                                 OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                                   UNION
                                                  SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                    FROM SSP_MST_DELEGATE
                                                   WHERE VALID_YN = 'Y'
                                                     AND DELEGATEE_ID = P_USER_ID
                                                   GROUP BY USER_ID)
                                 OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                 OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
                         GROUP BY A.DIVISION_ID
                             , A.ORIGIN_FROM_DIVISION_ID
                             , A.FROM_SITE
                             , A.ITEM_ID
                             , SUBSTR(A.LOT_ID, 1, 8)
                       ) IA
               ) XA
         WHERE XA.ROW_NO = 1
         ORDER BY XA.DIVISION_ID
             , XA.ITEM_ID
             , XA.LOT_ID
             --, XA.MES_CHANGE_STATUS DESC;
             , XA.MES_CHANGE_STATUS DESC NULLS LAST;   -- 2026.09.17 AJS

    END P_SSP0015_GET_MES_STOCK;

    /* ============================================================
       P_SSP0015_GET_SCS_STOCK
       AS-IS SSP0015_GET_SCS_STOCK
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SCS_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   @ PKG_SSP0015.P_SSP0015_GET_SCS_STOCK
         * Description  @ MES Stock
         * Program History
         *===================================================================================================
         *   Date       In Charge		Description
         *===================================================================================================
         * 2021-10-20   KIMYONGHO		신규추가
         * 2026.09.16   AJS             MSSQL -> Oracle 전환
         */
        V_CUTOFF_DATE   VARCHAR2(8 CHAR);
    BEGIN

        /* AS-IS : CONVERT(CHAR(8), DATEADD(DD, -2, ...), 112) - 계획기준일 -2일 */
        V_CUTOFF_DATE := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 2, 'YYYYMMDD');

        OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.CUTOFF_DATE
             , A.SCM_SITE_ID                        AS PLANT_ID
             , B.SITE_DESCRIPTION                   AS PLANT_NAME
             , A.ITEM_ID                            AS MODEL_ID
             , TO_CHAR(TO_DATE(A.STOCK_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS PROD_DATE
             , '-'                                  AS HOLD_YN
             , A.STOCK_QTY                          AS QTY
             , A.LAST_UPDATE_DATE
          FROM SCM_DNM_SCS_STOCK A
             , SCM_MST_SITE B
             , SSP_MST_MODEL_USER M
         WHERE A.DIVISION_ID   = B.DIVISION_ID
           AND A.SCM_SITE_ID   = B.SCM_SITE_ID
           AND M.DIVISION_ID(+) = A.DIVISION_ID
           AND M.FROM_SITE(+)   = A.SCM_SITE_ID
           AND M.ITEM_ID(+)     = A.ITEM_ID
           AND M.VALID_YN(+)    = 'Y'
           AND A.DIVISION_ID   = '40'
           AND A.CUTOFF_DATE   = V_CUTOFF_DATE
           AND A.CELL_PACK     = 'P'
           --AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
           AND ((TRIM(P_FROM_SITE) IS NULL)   -- 2026.09.17 AJS
                 OR A.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
           --AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
           AND ((TRIM(P_ITEM_ID) IS NULL)   -- 2026.09.17 AJS
                 --OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                 OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
           /* 체크박스 체크 여부 조회 시작(P_NONCHK = 'Y' : 체크박스 선택 안한 상태) */
           AND ((P_NONCHK = 'Y' AND 1 = 1)
                 OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                   UNION
                                  SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                    FROM SSP_MST_DELEGATE
                                   WHERE VALID_YN = 'Y'
                                     AND DELEGATEE_ID = P_USER_ID
                                   GROUP BY USER_ID)
                 OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                 OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
           /* 체크박스 체크 여부 조회 끝 */
         ORDER BY A.SCM_SITE_ID
             , A.ITEM_ID;

    END P_SSP0015_GET_SCS_STOCK;

    /* ============================================================
       P_SSP0015_GET_STOCK_LOCATION_DETAIL
       AS-IS SSP0015_GET_STOCK_LOCATION_DETAIL
       ※ AS-IS 의 @MST_LOCATION 테이블변수는 채우기만 하고 조인이 전부 주석 처리돼 있어
          결과에 영향을 주지 않는다. 옮기지 않는다.
       ※ SCM_DNM_STOCK_V.CUTOFF_DATE 는 Oracle 에서 DATE 다. 암시적 형변환을 막기 위해
          --비교값을 TO_DATE 로 맞추고, 결과 칸은 AS-IS 표기(YYYYMMDD)로 돌려준다.
          비교값을 TO_DATE 로 맞추고, 결과 칸은 AS-IS 와 같이 날짜형 그대로 돌려준다.   -- 2026.09.17 AJS
       ============================================================ */
    PROCEDURE P_SSP0015_GET_STOCK_LOCATION_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_COMPANY_ID            IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_DBL_FLAG              IN  VARCHAR2,
        P_LANGUAGE              IN  VARCHAR2 DEFAULT 'KO',
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SSP0015',
        P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'Stock Location Detail',
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'T',
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_STOCK_LOCATION_DETAIL
         * Description  : 소형 외주 Packer
         * Program History
         *===================================================================================================
         *   Date       In Charge		Description
         *===================================================================================================
         * 2021-09-28   KIMYONGHO	    최초작성
         * 2024-10-01   KHJ             NERP_SSP
         * 2026.09.16   AJS             MSSQL -> Oracle 전환
         */
        V_A010              VARCHAR2(10 CHAR);   /* NERP 매핑코드 */
        V_BOH_YYYYMMDD      VARCHAR2(8 CHAR);
        V_STOCK_YYYYMMDD    VARCHAR2(8 CHAR);
    BEGIN

        V_A010 := FN_GET_LOOKUP_VALUE('SSP0015_GET_STOCK_LOCATION_DETAIL', 'A010');   /* A010 */

        V_BOH_YYYYMMDD   := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');   /* FROM -1일 */
        V_STOCK_YYYYMMDD := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 3, 'YYYYMMDD');   /* FROM -3일 */

        IF P_DBL_FLAG = 'Y' THEN

            OPEN O_RC1 FOR
            SELECT IA.*
              FROM (
                    SELECT A.DIVISION_ID
                         , A.COMPANY_ID
                         --, TO_CHAR(A.CUTOFF_DATE, 'YYYYMMDD')   AS CUTOFF_DATE
                         , A.CUTOFF_DATE                        AS CUTOFF_DATE   /* AS-IS 는 datetime 그대로 */   -- 2026.09.17 AJS
                         , A.SCM_SITE_ID                        AS FROM_SITE
                         , A.PLANT_ID
                         , A.ITEM_ID
                         , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
                         , A.STOCK_TYPE
                         , A.STORAGE_ID
                         , NVL(B.STORAGE_DESCRIPTION,
                               (SELECT MIN(SA.STORAGE_DESCRIPTION)
                                  FROM SCM_MST_SLOC SA
                                 WHERE SA.PLANT_ID   = A.PLANT_ID
                                   AND SA.STORAGE_ID = A.STORAGE_ID
                                   AND SA.VALID_YN   = 'Y')) AS STORAGE_DESCRIPTION
                         , NVL(A.SCM_QTY, 0)                    AS TOTAL_QTY
                         , NVL(A.SSP_QTY, 0)                    AS AVAILABLE_QTY
                         , A.DEFECT_QTY
                         , A.MOVING_QTY
                         , A.QTY_UOM
                         , NVL(A.WIPHOLD_YN, 'N')               AS WIPHOLD_YN
                         , A.HOLDING_DATE
                         , A.AVAILABLE_DATE
                         , A.OUTSOURCING_FLAG
                         , A.OUTSOURCING_FACTORY
                      FROM SCM_DNM_STOCK_V A
                         , SCM_MST_SLOC B
                         , (SELECT DISTINCT DIVISION_ID, ITEM_ID, NICK_NAME
                              FROM SCM_MST_ITEM_SN
                             WHERE DIVISION_ID = P_DIVISION_ID
                               AND ACTIVE_FLAG = 'Y'
                               AND SCP_OPERATION_GROUP = 'P'   /* CELL/PACK 구분 */
                           ) C
                         , SSP_MST_MODEL_USER M
                     WHERE A.DIVISION_ID   = B.DIVISION_ID(+)
                       AND A.PLANT_ID      = B.PLANT_ID(+)
                       AND A.STORAGE_ID    = B.STORAGE_ID(+)
                       AND A.DIVISION_ID   = C.DIVISION_ID
                       AND A.ITEM_ID       = C.ITEM_ID
                       AND M.DIVISION_ID(+) = A.DIVISION_ID
                       AND M.FROM_SITE(+)   = A.SCM_SITE_ID
                       AND M.ITEM_ID(+)     = A.ITEM_ID
                       AND M.VALID_YN(+)    = 'Y'
                       AND A.DIVISION_ID = P_DIVISION_ID
                       AND A.COMPANY_ID  = P_COMPANY_ID
                       AND A.SCM_SITE_ID = P_FROM_SITE
                       AND A.ITEM_ID     = P_ITEM_ID
                       AND A.CUTOFF_DATE = TO_DATE(V_BOH_YYYYMMDD, 'YYYYMMDD')
                       AND A.CUTOFF_DATE > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')   /* 현재일 - 3 */
                       AND A.STOCK_TYPE  = 'INVENTORY'
                       AND A.PLANT_ID    = V_A010   /* 'A010' */
                       AND ((P_NONCHK = 'Y' AND 1 = 1)
                             OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                               UNION
                                              SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                FROM SSP_MST_DELEGATE
                                               WHERE VALID_YN = 'Y'
                                                 AND DELEGATEE_ID = P_USER_ID
                                               GROUP BY USER_ID)
                             OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                             OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
                   ) IA
             ORDER BY IA.COMPANY_ID
                 , IA.DIVISION_ID
                 , IA.FROM_SITE
                 , IA.PLANT_ID
                 , IA.ITEM_ID
                 , IA.STOCK_TYPE
                 , IA.STORAGE_ID;

        ELSE

            OPEN O_RC1 FOR
            SELECT IA.*
              FROM (
                    SELECT A.DIVISION_ID
                         , A.COMPANY_ID
                         --, TO_CHAR(A.CUTOFF_DATE, 'YYYYMMDD')   AS CUTOFF_DATE
                         , A.CUTOFF_DATE                        AS CUTOFF_DATE   /* AS-IS 는 datetime 그대로 */   -- 2026.09.17 AJS
                         , A.SCM_SITE_ID                        AS FROM_SITE
                         , A.PLANT_ID
                         , A.ITEM_ID
                         , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
                         , A.STOCK_TYPE
                         , A.STORAGE_ID
                         , NVL(B.STORAGE_DESCRIPTION,
                               (SELECT MIN(SA.STORAGE_DESCRIPTION)
                                  FROM SCM_MST_SLOC SA
                                 WHERE SA.PLANT_ID   = A.PLANT_ID
                                   AND SA.STORAGE_ID = A.STORAGE_ID
                                   AND SA.VALID_YN   = 'Y')) AS STORAGE_DESCRIPTION
                         , NVL(A.SCM_QTY, 0)                    AS TOTAL_QTY
                         , NVL(A.SSP_QTY, 0)                    AS AVAILABLE_QTY
                         , A.DEFECT_QTY
                         , A.MOVING_QTY
                         , A.QTY_UOM
                         , NVL(A.WIPHOLD_YN, 'N')               AS WIPHOLD_YN
                         , A.HOLDING_DATE
                         , A.AVAILABLE_DATE
                         , A.OUTSOURCING_FLAG
                         , A.OUTSOURCING_FACTORY
                      FROM SCM_DNM_STOCK_V A
                         , SCM_MST_SLOC B
                         , (SELECT DISTINCT DIVISION_ID, ITEM_ID, NICK_NAME
                              FROM SCM_MST_ITEM_SN
                             WHERE DIVISION_ID = P_DIVISION_ID
                               AND ACTIVE_FLAG = 'Y'
                               AND SCP_OPERATION_GROUP = 'P'   /* CELL/PACK 구분 */
                           ) C
                         , SSP_MST_MODEL_USER M
                     WHERE A.DIVISION_ID   = B.DIVISION_ID(+)
                       AND A.PLANT_ID      = B.PLANT_ID(+)
                       AND A.STORAGE_ID    = B.STORAGE_ID(+)
                       AND A.DIVISION_ID   = C.DIVISION_ID
                       AND A.ITEM_ID       = C.ITEM_ID
                       AND M.DIVISION_ID(+) = A.DIVISION_ID
                       AND M.FROM_SITE(+)   = A.SCM_SITE_ID
                       AND M.ITEM_ID(+)     = A.ITEM_ID
                       AND M.VALID_YN(+)    = 'Y'
                       AND A.DIVISION_ID = P_DIVISION_ID
                       AND A.COMPANY_ID  = P_COMPANY_ID
                       --AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                       AND ((TRIM(P_ITEM_ID) IS NULL)   -- 2026.09.17 AJS
                             --OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                             OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
                       AND A.CUTOFF_DATE = TO_DATE(V_BOH_YYYYMMDD, 'YYYYMMDD')
                       AND A.CUTOFF_DATE > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')   /* 현재일 - 3 */
                       AND A.STOCK_TYPE  = 'INVENTORY'
                       AND A.PLANT_ID    = V_A010   /* 'A010' */
                       AND ((P_NONCHK = 'Y' AND 1 = 1)
                             OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                               UNION
                                              SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                FROM SSP_MST_DELEGATE
                                               WHERE VALID_YN = 'Y'
                                                 AND DELEGATEE_ID = P_USER_ID
                                               GROUP BY USER_ID)
                             OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                             OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
                   ) IA
             ORDER BY IA.COMPANY_ID
                 , IA.DIVISION_ID
                 , IA.FROM_SITE
                 , IA.PLANT_ID
                 , IA.ITEM_ID
                 , IA.STOCK_TYPE
                 , IA.STORAGE_ID;

        END IF;

    END P_SSP0015_GET_STOCK_LOCATION_DETAIL;

    /* ============================================================
       P_SSP0015_GET_ERP_SO_NO_CNT
       AS-IS SSP0015_GET_ERP_SO_NO_CNT
       ============================================================ */
    PROCEDURE P_SSP0015_GET_ERP_SO_NO_CNT
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_ERP_SO_NO             IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_ERP_SO_NO_CNT
         * Description  : Shipment Change Request
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2018/10/12   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
         * 2024/06/04   jilee          UI 수량 표기 안되는 정보에 대한 제외 처리
         * 2026.09.16   AJS            MSSQL -> Oracle 전환
         */
    BEGIN

        OPEN O_RC1 FOR
        SELECT COUNT(*) AS CNT
          FROM SSP_ANL_SHIP_CONFIRM
         WHERE DIVISION_ID = P_DIVISION_ID
           AND ERP_SO_NO   = P_ERP_SO_NO
           AND QTY        <> 0;

    END P_SSP0015_GET_ERP_SO_NO_CNT;

    /* ============================================================
       P_SSP0015_GET_SHIPMENT_STATUS
       AS-IS SSP0015_GET_SHIPMENT_STATUS - 결과셋 3벌
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_STATUS
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_CONFIRM_ID            IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR,
        O_RC3                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_STATUS
         * Description  : Shipment Change Request
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2018/10/12   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
         * 2020/07/15   khj79          ERP_STATUS 가 'C' 인 경우 수정 못하도록 추가
         * 2026.09.16   AJS            MSSQL -> Oracle 전환 (String_Split -> FN_STRING_SPLIT)
         *
         ex) EXEC PKG_SSP0015.P_SSP0015_GET_SHIPMENT_STATUS('40^40', 'C20181001068349^C20181005074232', ...)
         */
    BEGIN

        OPEN O_RC1 FOR
        SELECT CONFIRM_ID
          FROM SSP_ANL_SHIP_CONFIRM
         WHERE 1 = 1
           AND DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, '^')))
           --AND CONFIRM_ID  IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_CONFIRM_ID, '^')))
           AND CONFIRM_ID  IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_CONFIRM_ID, '^')))   -- 2026.09.17 AJS
           AND SHIPMENT_STATUS != 'C';

        OPEN O_RC2 FOR
        SELECT CONFIRM_ID
          FROM SSP_ANL_SHIP_CONFIRM
         WHERE 1 = 1
           AND DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, '^')))
           --AND CONFIRM_ID  IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_CONFIRM_ID, '^')))
           AND CONFIRM_ID  IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_CONFIRM_ID, '^')))   -- 2026.09.17 AJS
           AND QTY = 0;

        OPEN O_RC3 FOR
        SELECT CONFIRM_ID
          FROM SSP_ANL_SHIP_CONFIRM
         WHERE 1 = 1
           AND DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, '^')))
           --AND CONFIRM_ID  IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_CONFIRM_ID, '^')))
           AND CONFIRM_ID  IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_CONFIRM_ID, '^')))   -- 2026.09.17 AJS
           AND ERP_STATUS = 'C';

    END P_SSP0015_GET_SHIPMENT_STATUS;

END PKG_ZTMP_S015K;
/
SHOW ERRORS PACKAGE BODY PKG_ZTMP_S015K
