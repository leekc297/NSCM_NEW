PROCEDURE PR_SCP_MST_FINAL_ITEM_COPY_FROM_FP
/*
 * Program ID   : PR_SCP_MST_FINAL_ITEM_COPY_FROM_FP
 * Description  : CREATE SCP FINAL ITEM FROM FP ITEM MASTER
 * OutTable     :
 * Execute      :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.06.15   YYDOK          Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.07.03   Kim Jihye      Packer Plan Item ID (소형 Packer 대표 ID) 추가
 * 2018.08.15   YYDOK          TCO_CELL_YN ADD
 * 2018.09.03   YYDOK          SCM_MST_FINAL_ITEM_V -> SCM_MST_FINAL_ITEM_ORIGIN_DIV_V 변경
 * 2018.09.18   YYDOK          소형 셀,팩 ITEM에 대하여 원/각/파우치구분칼럼추가(CELL_TYPE_GROUP_CODE)
 * 2018.10.05   KTH            칼럼추가(CELL_ITEM_ID,CONVERT_QTY_CELL) 후 UPDATE문 반영
 * 2018.10.31   YYDOK          DM FCST에 존재하는 모델하위 FINAL ITEM에 수요존재여부,최소납기일자 칼럼 업데이트
 * 2018.11.02   YYDOK          TCO셀 구분에 공정코드 추가반영( 초소형셀 MCSS20253-A4 F6200공정은 TCO CELL ITEM)
 * 2018.11.27   YYDOK          PACK,TCO셀,셀(자신)에 대하여 들어가는 CELL LIST를 콤마로 구분하여 ATTRIBUTE1에 셋팅
 *                             GLOBAL PSI화면에서 조회조건에 사용하기위해 로직적용.
 * 2019.02.22   YYDOK          CONVERT_QTY_CELL 추출시 SCM_MST_MODEL_FINAL_ITEM_BOM_V -> SCM_MST_MODEL_FINAL_ITEM_BOM_V1 변경
 * 2019.07.09   KTH            CELL_TYPE_GROUP_CODE에 WHEN 'E' THEN 'P' 조건 추가
 * 2019.09.30   KSG            [CSR ID 4083826] 전극 대표 Cell 처리 수정 : FP Item Master의 APPLIED_MODEL 컬럼
 *                             전극의 Cell 환산자 처리 수정 : FN_GET_REQ_QTY_MODEL_FOR_SCP_SN 사용(FP의 FN_GET_REQ_QTY_MODEL)
 * 2020.02.18   KSG            [C20200207-000240] MRP - Requirement list cell수량 확인요청
 * 2020.10.14   KSG            PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK
 * 2021.05.28   KSG            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 대응
 * 2021.10.06   sclee.lee      PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : RTF개선
 * 2021.11.05   sclee.lee      PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 : MEB
 * 2022.01.10   KSG            PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : DC Item 구분 : attribute4
 * 2022-06-02   KSG            PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : ISUZU Item 구분 : attribute5
 * 2022-09-20   KSG            PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 : 소형 P5000 Cell Type Group 처리 추가
 * 2022.11.15   KSG            PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MKT FCST 조건 변경
 * 2023.02.23   jahn1501       PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - SCP_MST_FINAL_ITEM 테이블에 셀환산자(CELL_CF)컬럼 업데이트
 * 2023.04.13   HRK            PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2023.06.02   KSG            PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화 대응 Cell Prod/Assy 구분자 추가 - ATTRIBUTE8 에 설정
 * 2023.07.26   KSG            PJ20230692 LGES SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : SCP_MST_CELL_PROD_ASSY_MAP 사용 시 Valid_yn = 'Y' 조건 추가
 * 2023.11.02   KSG            E20231026-001169 4680/4695 제품에 대한 [Cell Type Gr] 지정 요청의 건 : CELL_TYPE_GROUP_CODE -‘M’인 경우 Cell은‘C, pack은‘P’처리
 * 2023.11.23   KSG            E20231120-000042 [SCM/물류 PI팀]Model code master 시스템의 셀환산 누락방지를 위한 신규 기능 추가의 건 : 평가감 모델의 CELL_CF Update
 * 2023.12.11   KSG            E20231204-000282 CELL_CF  CONVERT_QTY_CELL 설정 logic 수정 요청 :
 * 2024.06.15   KSG            PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : FCST 처리 시 동일 GROUP Item 추가
 * 2024.11.01   KSG            E20240923-000249 Model Code Master 내 Cell NickName 변경 요청 드립니다. : 신규 item Code 등록 시 Basic Model Cell의 NickName 값으로 넣어줌
 * 2026.04.15   YMH            E20260313-002032 SCP 전극 Cell환산기준 변경요청
 * 2026.07.30   ZIONEX         [PJ202650304]  NextSCM Migration
 */
/* ============================================================================================
 *        (a) MERGE 2 USING - Cell 생산계획 SUB : LEFT JOIN M 1 + INNER JOIN(SCP_MST_FINAL_ITEM F) 1 + INNER JOIN(BOM_V1 A) 1
 *      - Cell Prod/Assy MAP 인라인뷰 : 실데이터 5,188행, 양방향 0
 *      - Cell 생산계획 SUB : 구동 테이블 SCP_PLN_ELEC_DEMAND_CELL_PLAN 이 26ai 실데이터 0행이라
 * ============================================================================================ */
AS
    /* LOG 용 변수 설정 */
    V_BATCH_USER    VARCHAR2(150 CHAR) := '';
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'PR_SCP_MST_FINAL_ITEM_COPY_FROM_FP';
    V_LOG_TYPE      VARCHAR2(30 CHAR);          /* START/END/ERROR/... */
    N_LOG_COUNT     INTEGER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    V_TABLE_ID      VARCHAR2(150 CHAR) := 'SCP_MST_FINAL_ITEM';
    D_EVENT_DATE    DATE;
    D_PLAN_DATE     DATE;
    N_PERIOD        INTEGER := 450;             /* FCST 확인 구간 */
    V_PLAN_DATE     VARCHAR2(8 CHAR);           /* FCST 확인 구간 */
    V_PLAN_END_DATE VARCHAR2(8 CHAR);           /* FCST 확인 구간 */

    X_DEFAULT_DEMAND_GROUPING_DAYS INTEGER := 1;
BEGIN


    V_BATCH_USER    := 'SCP';
    D_PLAN_DATE     := FN_NEXT_DAY(SYSDATE, 'MON') - 7;
    V_PLAN_DATE     := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');
    V_PLAN_END_DATE := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + N_PERIOD, 'YYYYMMDD');

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' SCP_MST_FINAL_ITEM INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );

    BEGIN

        /* 20210528 PJ20209642 : FCST 확인 구간 */
        /* HM JV 가상 사업부 추가 대응 : 사업부 상관없이 MAX값 */
        SELECT MAX((TO_DATE(P.HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(P.PLAN_NAME, 'YYYYMMDD')) + 1)
          INTO N_PERIOD
          FROM SCM_MST_PLAN P
         WHERE 1 = 1                 /* HM JV 가상 사업부 추가 대응  p.division_id = '81' */
           AND P.PLAN_CYCLE = 'WEEKLY'
           AND P.PLAN_NAME  = TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')  /* 당주 월요일 YYYYMMDD */
             ;

        /* -----------------------------------------------------------
           SCP FINAL ITEM CREATE
           -----------------------------------------------------------
           원본 : WITH XX AS (...) UPDATE SCP_MST_FINAL_ITEM SET ... FROM XX, SCP_MST_FINAL_ITEM AA WHERE 조인
                  Oracle 은 UPDATE ~ FROM ~ JOIN 미지원이라 MERGE 로 변환(조인키 = XX 의 GROUP BY 키라 다중매치 없음). */
        MERGE INTO SCP_MST_FINAL_ITEM AA
        USING ( SELECT A.DIVISION_ID
                     , A.ITEM_ID
                     , MAX(A.NICK_NAME)  AS NICK_NAME
                     , MAX(A.ITEM_CLASS) AS ITEM_CLASS
                       /* 20190930 전극 대표 Cell 처리 수정 : FP Item Master의 APPLIED_MODEL 컬럼  CELL_ITEM_ID */
                     , CASE WHEN MAX(A.SCP_OPERATION_GROUP) = 'E' THEN MAX(A.APPLIED_MODEL)
                            ELSE NULL
                       END AS CELL_ITEM_ID
                     , MAX(CASE WHEN A.FLOW_ID IS NULL THEN A.SCP_FLOW_ID ELSE A.FLOW_ID END) AS FLOW_ID
                     , MAX(A.SCP_OPERATION_GROUP)    AS OPERATION_GROUP
                     , MAX(A.SCP_OPERATION_GROUP_ID) AS OPERATION_GROUP_ID
                     , MAX(B.ELECTRODE_TYPE)         AS ELECTRODE_TYPE
                       /* PJ20202001 Rack Item 추가
                                    CASE WHEN MAX(I.ITEM_CLASS) = 'EM0304' THEN 'Y'
                                         ELSE 'N'
                                    END AS ATTRIBUTE3 */
                     , MAX(NVL(B.RACK_YN, 'N'))      AS ATTRIBUTE3
                     , MAX(NVL(B.DC_YN, 'N'))        AS ATTRIBUTE4  /* 20220110 DC Item 구분 */
                     , MAX(NVL(B.IS_YN, 'N'))        AS ATTRIBUTE5  /* 20220602 PJ20216891 ISUZU Item 구분 */
                     , MAX(B.CELL_TYPE)              AS ATTRIBUTE8  /* 20230602 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가 */
                                                                    /* 원본 MAX(ISNULL(FI.CELL_TYPE, '')) : Oracle 은 '' 가 NULL 이라 NVL(x,'') 이 금지(CV-029)이고 결과도 MAX(CELL_TYPE) 와 동일하다. */
                  FROM SCM_MST_ITEM_SN                  A
                     , SCM_MST_FINAL_ITEM_ORIGIN_DIV_V  B
                 WHERE A.DIVISION_ID = B.DIVISION_ID
                   AND A.ITEM_ID     = B.ITEM_ID
                   AND A.ACTIVE_FLAG = 'Y'
                   AND A.SCP_OPERATION_GROUP IS NOT NULL
                 GROUP BY A.DIVISION_ID
                        , A.ITEM_ID
              ) XX
           ON ( XX.DIVISION_ID = AA.DIVISION_ID
            AND XX.ITEM_ID     = AA.ITEM_ID )
        WHEN MATCHED THEN
        UPDATE SET AA.NICK_NAME          = XX.NICK_NAME
                 , AA.ITEM_CLASS         = XX.ITEM_CLASS
                 , AA.CELL_ITEM_ID       = XX.CELL_ITEM_ID  /* 20190930 전극 대표 Cell 처리 */
                   /* , CONVERT_QTY_CELL   = (1.0 / DBO.FN_GET_REQ_QTY_MODEL_FOR_SCP_SN('', XX.CELL_ITEM_ID, XX.ITEM_ID, @d_plan_date))  20231211 : E20231204-000282 아래에서 별도 처리   20190930 Cell 환산자 처리 */
                 , AA.FLOW_ID            = XX.FLOW_ID
                 , AA.OPERATION_GROUP    = XX.OPERATION_GROUP
                 , AA.OPERATION_GROUP_ID = XX.OPERATION_GROUP_ID
                 , AA.ELECTRODE_TYPE     = XX.ELECTRODE_TYPE
                 , AA.ATTRIBUTE3         = XX.ATTRIBUTE3    /* PJ20202001 Rack Item 추가 */
                 , AA.ATTRIBUTE4         = XX.ATTRIBUTE4    /* 20220110 DC Item 구분 */
                 , AA.ATTRIBUTE5         = XX.ATTRIBUTE5    /* 20220602 PJ20216891 ISUZU Item 구분 */
                 , AA.ATTRIBUTE8         = XX.ATTRIBUTE8    /* 20230602 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가 */
                 , AA.LAST_UPDATED_BY    = 'COPY'
                 , AA.LAST_UPDATE_DATE   = SYSDATE
             ;
        /* SELECT  XX.NICK_NAME
                , XX.ITEM_CLASS
                , XX.FLOW_ID
                , XX.OPERATION_GROUP
                , XX.OPERATION_GROUP_ID
                , XX.ELECTRODE_TYPE
          */

        N_LOG_COUNT := SQL%ROWCOUNT;

        INSERT
          INTO SCP_MST_FINAL_ITEM
             ( DIVISION_ID
             , ITEM_ID
             , NICK_NAME
             , ITEM_CLASS
             , CELL_ITEM_ID          /* 20190930 전극 대표 Cell 처리 */
             , CONVERT_QTY_CELL      /* 20190930 Cell 환산자 처리 */
             , OPERATION_GROUP
             , OPERATION_GROUP_ID
             , ELECTRODE_TYPE
             , FLOW_ID
             , DEMAND_GROUPING_DAYS
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , TCO_CELL_YN
             , ATTRIBUTE3            /* PJ20202001 Rack Item 추가 */
             , ATTRIBUTE4            /* 20220110 DC Item 구분 */
             , ATTRIBUTE5            /* 20220602 PJ20216891 ISUZU Item 구분 */
             , ATTRIBUTE8 )          /* 20230602 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가 */
        SELECT XX.DIVISION_ID
             , XX.ITEM_ID
             , XX.NICK_NAME
             , XX.ITEM_CLASS
             , XX.CELL_ITEM_ID       /* 20190930 전극 대표 Cell 처리 */
             , (1.0 / FN_GET_REQ_QTY_MODEL_FOR_SCP_SN('', XX.CELL_ITEM_ID, XX.ITEM_ID, D_PLAN_DATE))  /* 20231211 : E20231204-000282 아래에서 추가 처리   20190930 Cell 환산자 처리 */
             , XX.OPERATION_GROUP
             , XX.OPERATION_GROUP_ID
             , XX.ELECTRODE_TYPE
             , XX.FLOW_ID
             , ( CASE WHEN XX.OPERATION_GROUP = 'A' THEN 1 ELSE NULL END ) AS DEMAND_GROUPING_DAYS
             , 'COPY'  AS CREATED_BY
             , SYSDATE AS CREATION_DATE
             , 'COPY'  AS LAST_UPDATED_BY
             , SYSDATE AS LAST_UPDATE_DATE
             , XX.TCO_CELL_YN
             , XX.ATTRIBUTE3         /* PJ20202001 Rack Item 추가 */
             , XX.ATTRIBUTE4         /* 20220110 DC Item 구분 */
             , XX.ATTRIBUTE5         /* 20220602 PJ20216891 ISUZU Item 구분 */
             , XX.ATTRIBUTE8         /* 20230602 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가 */
          FROM ( SELECT A.DIVISION_ID
                      , A.ITEM_ID
                      , MAX(A.NICK_NAME)  AS NICK_NAME
                      , MAX(A.ITEM_CLASS) AS ITEM_CLASS
                        /* 20190930 전극 대표 Cell 처리 수정 : FP Item Master의 APPLIED_MODEL 컬럼  CELL_ITEM_ID */
                      , CASE WHEN MAX(A.SCP_OPERATION_GROUP) = 'E' THEN MAX(A.APPLIED_MODEL)
                             ELSE NULL
                        END AS CELL_ITEM_ID
                      , MAX(CASE WHEN A.FLOW_ID IS NULL THEN A.SCP_FLOW_ID ELSE A.FLOW_ID END) AS FLOW_ID
                      , MAX(A.SCP_OPERATION_GROUP)    AS OPERATION_GROUP
                      , MAX(A.SCP_OPERATION_GROUP_ID) AS OPERATION_GROUP_ID
                      , MAX(B.ELECTRODE_TYPE)         AS ELECTRODE_TYPE
                        /* MAX( CASE WHEN (I.SCP_OPERATION_GROUP ='A' AND I.DIVISION_ID ='40' AND SUBSTRING(I.ITEM_ID,1,2) = 'MD' ) THEN 'Y'
                                     WHEN (I.SCP_OPERATION_GROUP ='A' AND I.DIVISION_ID ='40' AND SUBSTRING(I.ITEM_ID,1,2) = 'MI' ) THEN 'Y'
                                     WHEN (I.SCP_OPERATION_GROUP ='A' AND I.DIVISION_ID ='40' AND SUBSTRING(I.ITEM_ID,1,2) = 'MT' ) THEN 'Y'
                                     WHEN (I.SCP_OPERATION_GROUP ='A' AND I.DIVISION_ID ='40' AND SUBSTRING(I.ITEM_ID,1,2) = 'MT' ) THEN 'Y'
                                     WHEN (I.SCP_OPERATION_GROUP ='A' AND I.DIVISION_ID ='40'
                                           AND (CASE WHEN FLOW_ID IS NULL THEN LEFT(SCP_FLOW_ID,5) ELSE LEFT(FLOW_ID,5) END) IN ('F6200','F7000','F7100','F7200','F7300') ) THEN 'Y'
                                ELSE 'N'
                                END ) AS TCO_CELL_YN, */
                      , MAX(NVL(B.TCO_CELL_YN, 'N'))  AS TCO_CELL_YN
                        /* PJ20202001 Rack Item 추가
                                     CASE WHEN MAX(I.ITEM_CLASS) = 'EM0304' THEN 'Y'
                                          ELSE 'N'
                                     END AS ATTRIBUTE3 */
                      , MAX(NVL(B.RACK_YN, 'N'))      AS ATTRIBUTE3
                      , MAX(NVL(B.DC_YN, 'N'))        AS ATTRIBUTE4  /* 20220110 DC Item 구분 */
                      , MAX(NVL(B.IS_YN, 'N'))        AS ATTRIBUTE5  /* 20220602 PJ20216891 ISUZU Item 구분 */
                      , MAX(B.CELL_TYPE)              AS ATTRIBUTE8  /* 20230602 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가 */
                                                                     /* 원본 MAX(ISNULL(FI.CELL_TYPE, '')) : NVL(x,'') 금지(CV-029), 결과 동일. */
                   FROM SCM_MST_ITEM_SN                  A
                      , SCM_MST_FINAL_ITEM_ORIGIN_DIV_V  B
                  WHERE A.DIVISION_ID = B.DIVISION_ID
                    AND A.ITEM_ID     = B.ITEM_ID
                    AND A.ACTIVE_FLAG = 'Y'
                    AND A.SCP_OPERATION_GROUP IS NOT NULL
                  GROUP BY A.DIVISION_ID
                         , A.ITEM_ID
               ) XX
         WHERE 1 = 1
           AND NOT EXISTS ( SELECT 1
                              FROM SCP_MST_FINAL_ITEM C
                             WHERE C.DIVISION_ID = XX.DIVISION_ID
                               AND C.ITEM_ID     = XX.ITEM_ID )
             ;

        N_LOG_COUNT := N_LOG_COUNT + SQL%ROWCOUNT;

        /* -----------------------------------------------------------
           Packer Plan Item ID (소형 Packer 대표 ID) 추가
           -----------------------------------------------------------
           원본 : UPDATE ~ FROM ~ JOIN (DISTINCT 인라인뷰) 다중매치 가능(LEFT 11자리 기준) -> MSSQL 은 임의 1건 채택.
                  Oracle 은 MERGE 시 ORA-30926 이 나므로 상관 UPDATE + ROWNUM=1(임의 1건) + EXISTS(매치행만 갱신)로 변환(CV-024). */
        UPDATE SCP_MST_FINAL_ITEM A
           SET A.PACKER_PLAN_ITEM_ID = ( SELECT B.ITEM_ID
                                           FROM SCM_MST_SITE_ITEM B
                                          WHERE B.DIVISION_ID = A.DIVISION_ID
                                            AND SUBSTR(B.ITEM_ID, 1, 11) = SUBSTR(A.ITEM_ID, 1, 11)
                                            AND B.DIVISION_ID = '40'
                                            AND LENGTH(B.ITEM_ID) > 11
                                            AND FN_GET_ITEM_OPERATION_GROUP(B.DIVISION_ID, B.ITEM_ID) = 'P'
                                            AND ROWNUM = 1 )
             , A.LAST_UPDATE_DATE    = SYSDATE
         WHERE A.DIVISION_ID     = '40'
           AND A.OPERATION_GROUP = 'P'
           /* AND    FI.PACKER_PLAN_ITEM_ID IS NULL */
           AND LENGTH(A.ITEM_ID) > 11
           AND SUBSTR(A.ITEM_ID, 1, 11) IN (SELECT SUBSTR(C.ITEM_ID, 1, 11)
                                              FROM SCP_MST_FINAL_ITEM C
                                             WHERE C.DIVISION_ID     = '40'
                                               AND C.OPERATION_GROUP = 'P'
                                               AND LENGTH(C.ITEM_ID) > 11
                                             GROUP BY SUBSTR(C.ITEM_ID, 1, 11)
                                            HAVING COUNT(*) > 1)
           AND EXISTS ( SELECT 1
                          FROM SCM_MST_SITE_ITEM B
                         WHERE B.DIVISION_ID = A.DIVISION_ID
                           AND SUBSTR(B.ITEM_ID, 1, 11) = SUBSTR(A.ITEM_ID, 1, 11)
                           AND B.DIVISION_ID = '40'
                           AND LENGTH(B.ITEM_ID) > 11
                           AND FN_GET_ITEM_OPERATION_GROUP(B.DIVISION_ID, B.ITEM_ID) = 'P' )
             ;

        /* -----------------------------------------------------------
           칼럼추가(CELL_ITEM_ID,CONVERT_QTY_CELL) 후 UPDATE문 반영
           20190930 전극 대표 Cell 처리 : CELL_ITEM_ID가 NULL 인 경우만 처리
           20230602 PJ20230691 활성화 대응 : 최정 Cell Prod 로 처리
           ----------------------------------------------------------- */
        MERGE INTO SCP_MST_FINAL_ITEM X
              /* Cell 생산 계획이 있는 모델 대상 */
        USING ( SELECT IA.DIVISION_ID
                     , IA.ITEM_ID       AS CELL_ITEM_ID
                     , A.CHILD_ITEM_ID  AS ELEC_ITEM_ID
                     , MIN(A.ACCUMULATED_CHILD_QTY) AS BOM_QTY
                     , 1.0/MIN(A.ACCUMULATED_CHILD_QTY) AS CONVERT_QTY_CELL  /* ACCUMULATED_CHILD_QTY가 0일 경우는 오류처리는 ?  --> 0 ? 1 */
                     , ROW_NUMBER() OVER(PARTITION BY IA.DIVISION_ID, A.CHILD_ITEM_ID ORDER BY IA.DIVISION_ID, A.CHILD_ITEM_ID, MIN(A.ACCUMULATED_CHILD_QTY) ASC) AS NO
                  FROM ( SELECT DISTINCT B.ORIGIN_DIVISION_ID AS DIVISION_ID
                                       , CASE WHEN RTRIM(XA.ITEM_ID_PROD) IS NULL THEN B.ITEM_ID ELSE XA.ITEM_ID_PROD END AS ITEM_ID
                           FROM SCP_PLN_ELEC_DEMAND_CELL_PLAN B
                                /* 20230602 PJ20230691 활성화 대응 */
                              , ( SELECT C.DIVISION_ID
                                       , C.ITEM_ID_ASSY
                                       , MIN(C.ITEM_ID_PROD) AS ITEM_ID_PROD
                                    FROM SCP_MST_CELL_PROD_ASSY_MAP C
                                       , SCP_MST_FINAL_ITEM         D
                                   WHERE C.DIVISION_ID  = D.DIVISION_ID
                                     AND C.ITEM_ID_PROD = D.ITEM_ID
                                     AND D.ATTRIBUTE8   = 'CP'
                                     AND C.CELL_TYPE    = 'CA1'   /* Cell 생산 계획 */
                                     AND C.VALID_YN     = 'Y'     /* 20230726 PJ20230692 : Valid_yn = 'Y' 조건 추가 */
                                   GROUP BY C.DIVISION_ID
                                          , C.ITEM_ID_ASSY
                                ) XA
                          WHERE B.ORIGIN_DIVISION_ID = XA.DIVISION_ID(+)
                            AND B.ITEM_ID            = XA.ITEM_ID_ASSY(+)
                            AND B.PLAN_START_YYYYMMDD >= FN_GET_BUCKET_YYYYMMDD(-1)
                       ) IA
                     , SCM_MST_MODEL_FINAL_ITEM_BOM_V1 A   /* 20250901 운영 속도 이슈로 변경 */

                 WHERE 1 = 1                               /* 20250901 운영 속도 이슈로 변경 */
                   AND A.MODEL_ID    = IA.ITEM_ID          /* 20250901 운영 속도 이슈로 변경 */
                   AND A.DIVISION_ID = IA.DIVISION_ID      /* 20250901 운영 속도 이슈로 변경 */
                   AND A.OPERATION_GROUP_ID = 'E'
                   /* AND A.CHILD_ITEM_ID       = 'APCAN1120A' */
                 GROUP BY IA.DIVISION_ID
                        , IA.ITEM_ID
                        , A.CHILD_ITEM_ID
                HAVING MIN(A.ACCUMULATED_CHILD_QTY) > 0
              ) Y
              /*  -- 전체 Cell 모델 대상 : 가끔 수작업으로 Update 처리할 것
                (
                   SELECT a.DIVISION_ID, A.MODEL_ID AS CELL_ITEM_ID,
                          A.CHILD_ITEM_ID AS ELEC_ITEM_ID,
                          MIN(ACCUMULATED_CHILD_QTY) AS BOM_QTY,
                          1.0/MIN(ACCUMULATED_CHILD_QTY) AS CONVERT_QTY_CELL,   ACCUMULATED_CHILD_QTY가 0일 경우는 오류처리는 ?  --> 0 ? 1
                          ROW_NUMBER() OVER(PARTITION BY  a.DIVISION_ID,A.CHILD_ITEM_ID ORDER BY  a.DIVISION_ID,A.CHILD_ITEM_ID,MIN(ACCUMULATED_CHILD_QTY) asc) AS No
                     FROM dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V1 A
                    WHERE 1=1
                      AND a.OPERATION_GROUP_ID  = 'E'
                  GROUP BY a.DIVISION_ID, A.MODEL_ID, A.CHILD_ITEM_ID
                  HAVING MIN(ACCUMULATED_CHILD_QTY) > 0
                  ) Y
                  */
           ON ( 0 = 0
            AND X.DIVISION_ID = Y.DIVISION_ID
            AND X.ITEM_ID     = Y.ELEC_ITEM_ID
            AND Y.NO          = 1 )
        WHEN MATCHED THEN
        UPDATE SET X.CELL_ITEM_ID = Y.CELL_ITEM_ID
                   /* , X.CONVERT_QTY_CELL   = Y.CONVERT_QTY_CELL  20231211 : E20231204-000282 아래에서 별도 처리 */
                   /* SELECT X.CELL_ITEM_ID, Y.CELL_ITEM_ID,X.CONVERT_QTY_CELL,Y.CONVERT_QTY_CELL,* */
         WHERE X.OPERATION_GROUP_ID = 'E'
           /* 20190930 전극 대표 Cell 처리 : CELL_ITEM_ID가 NULL 인 경우만 처리 */
           AND RTRIM(X.CELL_ITEM_ID) IS NULL   /* 원본 (X.CELL_ITEM_ID IS NULL OR X.CELL_ITEM_ID = '') : Oracle 은 ''=NULL 이라 RTRIM(col) IS NULL 로 흡수(CV-028) */
             ;

        /* -----------------------------------------------------------
           당주이후 미래구간 수요가 존재하는 ITEM에 대하여,
           BOM존재하는 팩,셀,전극 ITEM에 수요존재='Y',최소납기일자 기록.
            : TACT TIME미존재 체크화면이나 메일링시 수요존재하는 경우만 반영
           ----------------------------------------------------------- */
        UPDATE SCP_MST_FINAL_ITEM
           SET FCST_YN      = NULL
             , MIN_DUE_DATE = NULL
         WHERE 1 = 1
             ;

        MERGE INTO SCP_MST_FINAL_ITEM T
        USING ( SELECT B.DIVISION_ID
                     , B.CHILD_ITEM_ID
                     , MIN(IA.MIN_YYYYMMDD) AS MIN_YYYYMMDD
                  FROM ( /* aa.division_id
                                , aa.project_code
                                , aa.scm_site_id
                                , aa.item_id
                                , aa.yyyymmdd
                                , aa.qty
                                , aa.measure
                         */
                         SELECT A.DIVISION_ID
                              , NVL(D.ITEM_ID, A.ITEM_ID) AS ITEM_ID
                              , MIN(A.YYYYMMDD)           AS MIN_YYYYMMDD
                           FROM ( SELECT *
                                    FROM DM_PLN_MKT_FCST XA
                                   WHERE 1 = 1                                        /* aa.division_id     = '40' */
                                     /* 20210528 PJ20209642 : FCST 확인 구간 */
                                     AND XA.YYYYMMDD >= V_PLAN_DATE                   /* CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) */
                                     AND XA.YYYYMMDD <= V_PLAN_END_DATE               /* CONVERT(CHAR(8), DATEADD(DD, @n_period, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) */
                                     AND XA.MEASURE  IN ('AS_In_Req', 'VMI_In_Req', 'MKT_FCST')
                                     AND XA.QTY      >  0
                                ) A
                                /* 20180716 추가 VMI 대상 site 조회 */
                              , ( SELECT E.DIVISION_ID
                                       , E.SCM_SITE_ID
                                       , E.VMI_YN
                                       , E.OPERATION_GROUP
                                    FROM SCM_MST_SITE E
                                   WHERE 1 = 1                                        /* division_id = '40' */
                                     AND E.VALID_YN = 'Y'
                                     /* AND    vmi_yn      = 'Y' */
                                ) B
                                /* 20240615 PJ20244573 동일 GROUP Item 추가 */
                              , ( SELECT F.DIVISION_ID
                                       , F.PROJECT_CODE
                                       , F.ITEM_ID
                                       , F.GROUP_ID
                                    FROM SCP_MST_ITEM_GROUP_DETAIL F
                                   WHERE 1 = 1                                        /* division_id = '40' */
                                     AND F.VALID_YN = 'Y'
                                     AND RTRIM(F.GROUP_ID) IS NOT NULL
                                ) C
                                /* 20240615 PJ20244573 동일 GROUP Item 추가 */
                              , ( SELECT G.DIVISION_ID
                                       , G.PROJECT_CODE
                                       , G.ITEM_ID
                                       , G.GROUP_ID
                                    FROM SCP_MST_ITEM_GROUP_DETAIL G
                                   WHERE 1 = 1                                        /* division_id = '40' */
                                     AND G.VALID_YN = 'Y'
                                     AND RTRIM(G.GROUP_ID) IS NOT NULL
                                ) D
                          WHERE 1 = 1                                         /* aa.division_id     = '40' */
                            AND A.DIVISION_ID  = B.DIVISION_ID
                            AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                            AND A.DIVISION_ID  = C.DIVISION_ID(+)
                            AND A.PROJECT_CODE = C.PROJECT_CODE(+)
                            AND A.ITEM_ID      = C.ITEM_ID(+)
                            AND C.DIVISION_ID  = D.DIVISION_ID(+)
                            AND C.GROUP_ID     = D.GROUP_ID(+)
                            /* PJ20214907 */
                            /* 20221115 PJ20216994  MKT FCST 조건 변경 */
                            /* vmi = 'Y' 이면 'MKT_FCST' 대신 'VMI_In_Req' Measure 사용하도록 처리 */
                            AND A.MEASURE = CASE WHEN B.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                                 WHEN B.VMI_YN = 'Y' THEN 'VMI_In_Req'
                                                 WHEN RTRIM(A.ATTRIBUTE10) IS NULL THEN 'MKT_FCST'
                                            END
                          GROUP BY A.DIVISION_ID
                                 , NVL(D.ITEM_ID, A.ITEM_ID)
                       ) IA
                     , SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                 WHERE IA.DIVISION_ID = B.DIVISION_ID
                   AND IA.ITEM_ID     = B.MODEL_ID
                 GROUP BY B.DIVISION_ID
                        , B.CHILD_ITEM_ID
              ) XX
              /* SELECT XX.* */
           ON ( XX.DIVISION_ID   = T.DIVISION_ID
            AND XX.CHILD_ITEM_ID = T.ITEM_ID )
        WHEN MATCHED THEN
        UPDATE SET T.FCST_YN      = 'Y'
                 , T.MIN_DUE_DATE = TO_DATE(XX.MIN_YYYYMMDD, 'YYYYMMDD')
             ;

        /* -------------------------------------------------------------------
           PACK(MODULE포함) 모델,TCO모델,셀 모델에 대하여, BOM 하위에 존재하는 CELL LIST를 콤마로 구분하여
           ATTRIBUTE1에 셋팅하여 GLOBAL PSI 화면에서 조회조건으로 활용
           20230602 PJ20230691 활성화 대응 : 1. TCO(CP) / CP : 자신으로 처리
                                             2. CP 중 상위 TCO(CP) 가 있는 경우 상위 TCO(CP) 로 처리
                                             3-1. CA1/CA2 : CP 로 처리
                                             3-2. CA1/CA2 : 상위 TCO(CP) 가 있는 경우 상위 TCO(CP) 로 처리
                                             4-1. Pack : CP 로 처리
                                             4-2. Pack : TCO(CP) 가 있는 경우 TCO(CP) 로 처리
           -------------------------------------------------------------------
           1. TCO(CP) / CP : 자신으로 처리 */
        UPDATE SCP_MST_FINAL_ITEM X
           SET X.ATTRIBUTE1 = X.ITEM_ID
               /* SELECT * */
         WHERE 1 = 1
           AND X.OPERATION_GROUP = 'A'
           /* AND X.TCO_CELL_YN     = 'Y' */
           AND X.ATTRIBUTE8 IN ('CP')
             ;

        /* 2. CP 중 상위 TCO(CP) 가 있는 경우 상위 TCO(CP) 로 처리 */
        UPDATE SCP_MST_FINAL_ITEM X
           SET X.ATTRIBUTE1 = NVL( (SELECT A.MODEL_ID
                                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A
                                         , SCM_MST_FINAL_ITEM_V           B
                                     WHERE A.DIVISION_ID        = B.DIVISION_ID
                                       AND A.MODEL_ID           = B.ITEM_ID
                                       AND A.DIVISION_ID        = X.DIVISION_ID
                                       AND A.CHILD_ITEM_ID      = X.ITEM_ID
                                       AND B.OPERATION_GROUP_ID = 'A'
                                       AND B.TCO_CELL_YN        = 'Y'
                                       AND B.CELL_TYPE          = 'CP'
                                       AND ROWNUM               = 1
                                   ), X.ATTRIBUTE1)
               /* SELECT * */
         WHERE 1 = 1
           AND X.OPERATION_GROUP = 'A'
           AND X.TCO_CELL_YN     = 'N'
           AND X.ATTRIBUTE8 IN ('CP')
             ;

        /* 3-1. CA1/CA2 : CP 로 처리 */
        UPDATE SCP_MST_FINAL_ITEM X
           SET X.ATTRIBUTE1 = NVL( (SELECT A.MODEL_ID
                                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A
                                         , SCM_MST_FINAL_ITEM_V           B
                                     WHERE A.DIVISION_ID        = B.DIVISION_ID
                                       AND A.MODEL_ID           = B.ITEM_ID
                                       AND A.DIVISION_ID        = X.DIVISION_ID
                                       AND A.CHILD_ITEM_ID      = X.ITEM_ID
                                       AND B.OPERATION_GROUP_ID = 'A'
                                       AND B.TCO_CELL_YN        = 'N'
                                       AND B.CELL_TYPE          = 'CP'
                                       AND ROWNUM               = 1
                                   ), X.ATTRIBUTE1)
               /* SELECT * */
         WHERE 1 = 1
           AND X.OPERATION_GROUP = 'A'
           /* AND X.TCO_CELL_YN     = 'N' */
           AND X.ATTRIBUTE8 IN ('CA1', 'CA2')
             ;

        /* 3-2. CA1/CA2 : 상위 TCO(CP) 가 있는 경우 상위 TCO(CP) 로 처리 */
        UPDATE SCP_MST_FINAL_ITEM X
           SET X.ATTRIBUTE1 = NVL( (SELECT A.MODEL_ID
                                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A
                                         , SCM_MST_FINAL_ITEM_V           B
                                     WHERE A.DIVISION_ID        = B.DIVISION_ID
                                       AND A.MODEL_ID           = B.ITEM_ID
                                       AND A.DIVISION_ID        = X.DIVISION_ID
                                       AND A.CHILD_ITEM_ID      = X.ITEM_ID
                                       AND B.OPERATION_GROUP_ID = 'A'
                                       AND B.TCO_CELL_YN        = 'Y'
                                       AND B.CELL_TYPE          = 'CP'
                                       AND ROWNUM               = 1
                                   ), X.ATTRIBUTE1)
               /* SELECT * */
         WHERE 1 = 1
           AND X.OPERATION_GROUP = 'A'
           /* AND X.TCO_CELL_YN     = 'N' */
           AND X.ATTRIBUTE8 IN ('CA1', 'CA2')
             ;

        /* 4-1. Pack : CP 로 처리 */
        /*  -- ymh 운영 속도 이슈로 주석처리 20250903
              UPDATE X
                 SET ATTRIBUTE1 = ISNULL(
                                   (
                                    SELECT TOP 1 B.CHILD_ITEM_ID
                                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK)
                                         , scm_mst_final_item_v o WITH(NOLOCK)
                                     WHERE B.DIVISION_ID        = X.DIVISION_ID
                                       AND B.MODEL_ID           = X.ITEM_ID
                                       AND B.DIVISION_ID        = o.DIVISION_ID
                                       AND B.CHILD_ITEM_ID      = o.item_id
                                       AND O.OPERATION_GROUP_ID = 'A'
                                       AND O.TCO_CELL_YN        = 'N'
                                       AND O.CELL_TYPE         IN ('CP')
                                   ), ATTRIBUTE1)
              SELECT *
                FROM SCP_MST_FINAL_ITEM X WITH(NOLOCK)
               WHERE 1=1
                 AND X.OPERATION_GROUP = 'P'
                 ;
        */
        /* 운영 속도이슈로 ymh 로직 변경 시작 */
        /* 원본 : UPDATE X SET ATTRIBUTE1 = ISNULL(B.CHILD_ITEM_ID, ATTRIBUTE1) FROM SCP_MST_FINAL_ITEM X INNER HASH JOIN (...) B ON ...
                  Oracle 은 UPDATE ~ FROM ~ JOIN 미지원 + 다중매치(모델 1건에 CELL 여러 건) 가능 -> 상관 스칼라(ROWNUM=1, 임의 1건)로 변환. */
        UPDATE SCP_MST_FINAL_ITEM X
           SET X.ATTRIBUTE1 = NVL( (SELECT A.CHILD_ITEM_ID
                                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A
                                         , SCM_MST_FINAL_ITEM_V           B
                                     WHERE 1 = 1
                                       AND A.DIVISION_ID        = B.DIVISION_ID
                                       AND A.CHILD_ITEM_ID      = B.ITEM_ID
                                       AND A.DIVISION_ID        = X.DIVISION_ID
                                       AND A.MODEL_ID           = X.ITEM_ID
                                       AND B.OPERATION_GROUP_ID = 'A'
                                       AND B.TCO_CELL_YN        = 'N'
                                       AND B.CELL_TYPE         IN ('CP')
                                       AND ROWNUM               = 1
                                   ), X.ATTRIBUTE1)
         WHERE 1 = 1
           AND X.OPERATION_GROUP = 'P'
             ;
        /* 운영 속도이슈로 ymh 로직 변경 끝 */

        /* 4-2. Pack : TCO(CP) 가 있는 경우 TCO(CP) 로 처리 */
        /*  -- ymh 운영 속도 이슈로 주석처리 20250903
              UPDATE X
                 SET ATTRIBUTE1 =ISNULL(
                                    (
                                    SELECT TOP 1 B.CHILD_ITEM_ID
                                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK)
                                         , scm_mst_final_item_v o WITH(NOLOCK)
                                     WHERE B.DIVISION_ID        = X.DIVISION_ID
                                       AND B.MODEL_ID           = X.ITEM_ID
                                       AND B.DIVISION_ID        = o.DIVISION_ID
                                       AND B.CHILD_ITEM_ID      = o.item_id
                                       AND O.OPERATION_GROUP_ID = 'A'
                                       AND O.TCO_CELL_YN        = 'Y'
                                       AND O.CELL_TYPE         IN ('CP')
                                   ), ATTRIBUTE1)
              SELECT *
                FROM SCP_MST_FINAL_ITEM X WITH(NOLOCK)
               WHERE 1=1
                 AND X.OPERATION_GROUP = 'P'
                 ;
        */
        /* 운영 속도이슈로 ymh 로직 변경 시작 */
        UPDATE SCP_MST_FINAL_ITEM X
           SET X.ATTRIBUTE1 = NVL( (SELECT A.CHILD_ITEM_ID
                                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A
                                         , SCM_MST_FINAL_ITEM_V           B
                                     WHERE 1 = 1
                                       AND A.DIVISION_ID        = B.DIVISION_ID
                                       AND A.CHILD_ITEM_ID      = B.ITEM_ID
                                       AND A.DIVISION_ID        = X.DIVISION_ID
                                       AND A.MODEL_ID           = X.ITEM_ID
                                       AND B.OPERATION_GROUP_ID = 'A'
                                       AND B.TCO_CELL_YN        = 'Y'
                                       AND B.CELL_TYPE         IN ('CP')
                                       AND ROWNUM               = 1
                                   ), X.ATTRIBUTE1)
         WHERE 1 = 1
           AND X.OPERATION_GROUP = 'P'
             ;
        /* 운영 속도이슈로 ymh 로직 변경 끝 */

        /* PJ20214997 */
        /* 2.1) MEB Item은 BOM에서 하위에 나오는 셀을 셋팅
                  UPDATE ~ FROM sub1 A INNER JOIN SCP_MST_FINAL_ITEM X ON A.ITEM_ID = X.ITEM_ID 로 사용.
                  Oracle 은 UPDATE 앞 WITH 절이 불가해 상관 서브쿼리로 평탄화했고, 두 CTE 의 별칭 B 가 서로 다른 */
        UPDATE SCP_MST_FINAL_ITEM X
           SET X.ATTRIBUTE1 = ( SELECT C.ATTRIBUTE1
                                  FROM SCP_MST_FINAL_ITEM             A
                                     , SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                                     , SCP_MST_FINAL_ITEM             C
                                 WHERE A.ITEM_ID  = B.CHILD_ITEM_ID
                                   AND B.MODEL_ID = C.ITEM_ID
                                   AND A.ITEM_ID  = X.ITEM_ID
                                   AND A.FLOW_ID  = 'P5200'
                                   AND B.MODEL_ID IS NOT NULL
                                   AND ROWNUM     = 1 )
         WHERE 1 = 1
           AND EXISTS ( SELECT 1
                          FROM SCP_MST_FINAL_ITEM             A
                             , SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                             , SCP_MST_FINAL_ITEM             C
                         WHERE A.ITEM_ID  = B.CHILD_ITEM_ID
                           AND B.MODEL_ID = C.ITEM_ID
                           AND A.ITEM_ID  = X.ITEM_ID
                           AND A.FLOW_ID  = 'P5200'
                           AND B.MODEL_ID IS NOT NULL )
             ;

        /* -----------------------------------------------------------
           소형 셀,팩 ITEM에 대하여 원/각/파우치구분칼럼반영 (CELL_TYPE_GROUP_CODE)
             20220920 PJ20216994 : 소형 P5000 Cell Type Group 처리 추가
             20231102 E20231026-001169 4680/4695 [Cell Type Gr] 지정 : 'M’인 경우 Cell은‘C, pack은 ‘P’처리
           ----------------------------------------------------------- */
        UPDATE SCP_MST_FINAL_ITEM
           SET CELL_TYPE_GROUP_CODE = ( CASE SUBSTR(FLOW_ID, 1, 5) WHEN 'P5000' THEN
                                                                       ( CASE WHEN SUBSTR(ATTRIBUTE1, 3, 1) = 'R' THEN 'R'
                                                                              WHEN SUBSTR(ATTRIBUTE1, 3, 1) = 'B' THEN 'C'
                                                                              WHEN SUBSTR(ATTRIBUTE1, 3, 1) = 'C' THEN 'C'
                                                                              WHEN SUBSTR(ATTRIBUTE1, 3, 1) = 'S' THEN 'C'
                                                                              WHEN SUBSTR(ATTRIBUTE1, 3, 1) = 'P' THEN 'P'
                                                                              WHEN SUBSTR(ATTRIBUTE1, 3, 1) = 'F' THEN 'P'
                                                                              WHEN SUBSTR(ATTRIBUTE1, 3, 1) = 'N' THEN 'P'
                                                                              WHEN SUBSTR(ATTRIBUTE1, 3, 1) = 'E' THEN 'P'
                                                                              WHEN SUBSTR(ATTRIBUTE1, 3, 1) = 'M' AND OPERATION_GROUP = 'A' THEN 'C'
                                                                              WHEN SUBSTR(ATTRIBUTE1, 3, 1) = 'M' AND OPERATION_GROUP = 'P' THEN 'P'
                                                                              ELSE ''
                                                                         END
                                                                       )
                                                                   ELSE
                                                                       ( CASE WHEN SUBSTR(ITEM_ID, 3, 1) = 'R' THEN 'R'
                                                                              WHEN SUBSTR(ITEM_ID, 3, 1) = 'B' THEN 'C'
                                                                              WHEN SUBSTR(ITEM_ID, 3, 1) = 'C' THEN 'C'
                                                                              WHEN SUBSTR(ITEM_ID, 3, 1) = 'S' THEN 'C'
                                                                              WHEN SUBSTR(ITEM_ID, 3, 1) = 'P' THEN 'P'
                                                                              WHEN SUBSTR(ITEM_ID, 3, 1) = 'F' THEN 'P'
                                                                              WHEN SUBSTR(ITEM_ID, 3, 1) = 'N' THEN 'P'
                                                                              WHEN SUBSTR(ITEM_ID, 3, 1) = 'E' THEN 'P'
                                                                              WHEN SUBSTR(ITEM_ID, 3, 1) = 'M' AND OPERATION_GROUP = 'A' THEN 'C'
                                                                              WHEN SUBSTR(ITEM_ID, 3, 1) = 'M' AND OPERATION_GROUP = 'P' THEN 'P'
                                                                              ELSE ''
                                                                         END
                                                                       )
                                        END )
             , LAST_UPDATE_DATE     = SYSDATE
         WHERE 1 = 1
           AND DIVISION_ID     = '40'         /* 소형 */
           AND OPERATION_GROUP IN ('A', 'P')  /* CELL,PACK */
             ;

        /*-----------------------------------------------------------
        -- 셀환산자 : CELL_CF / CONVERT_QTY_CELL 적용
        -- 20230323 : 자동차만 해당하며 셀환산자 업데이트 => DM에서 CELL_CF 활용
        -- 20231211 : E20231204-000282 우선 순위 역순으로 구현하여 Update 되도록 처리
          - CELL_CF/CONVERT_QTY_CELL
           1) CELL_CF/CONVERT_QTY_CELL : GPLM
           2) CELL_CF/CONVERT_QTY_CELL :  => 5) 에서 처리??
           3) CELL ITEM ID 확인(적용모델찾기) : 위에서 처리된 상태임
           4) CELL_CF/CONVERT_QTY_CELL : FP Conversion 정보 사용 : CELL_ITEM_ID와 ITEM_ID 기준
           5) CELL_CF/CONVERT_QTY_CELL : 전극 모델 대상 BOM 소요량 확인
           6) CONVERT_QTY_CELL : SCP_MST_ITEM_CELL_CF 의 UNIT 이 ‘EA’ 이면 1 설정
           7) CONVERT_QTY_CELL : FP 정보 최종 확인 [SCM_ITEM_CONV_CALC_M]]
        -----------------------------------------------------------*/

        /*
            E20260313-002032 SCP 전극 Cell환산기준 변경 으로 인해 로직 변경. (로직순서)
            1) CONVERT_QTY_CELL : SCP_MST_ITEM_CELL_CF 의 UNIT 이 ‘EA’ 이면 1 설정
            2) CONVERT_QTY_CELL : FP 정보 적용모델기준 반영 [SCM_ITEM_CONV_CALC_M]] * UNIT EA 제외
            3) CELL_CF/CONVERT_QTY_CELL : FP Conversion 정보 사용 : CELL_ITEM_ID와 ITEM_ID 기준 (*전극 환산자값이 없을때추가.)
            4) CELL_CF/CONVERT_QTY_CELL : 전극 모델 대상 BOM 소요량 확인 (*전극 환산자값이 없을때추가.)
            5) CONVERT_QTY_CELL : FP 정보 최종 확인 [SCM_ITEM_CONV_CALC_M]] (*전극 환산자값이 없을때가.)
            6) CELL_CF/CONVERT_QTY_CELL : GPLM 값 있으면 최종 적용

            * 1순위 GPLM 데이터 값이 있으면 해당 값 적용.
            * 2순위 FP 환산자 적용모델 기준 적용.
            * 1,2순위 적용시 세팅된 환산자 값 없을때
            * FP Conversion 정보 -> BOM 기준 MIN -> FP 적용모델 없이 MAX환산자적용


        */

        /* -----------------------------------------------------------
           7) CONVERT_QTY_CELL : FP 정보 최종 확인 [SCM_ITEM_CONV_CALC_M]]
           20200218 [C20200207-000240] 전극 -> Cell 환산자 정보 없는 경우 FP 로직으로 추가
           ----------------------------------------------------------- */
        UPDATE SCP_MST_FINAL_ITEM A
           SET A.CONVERT_QTY_CELL = ( SELECT MAX(B.VALUE)
                                        FROM SCM_MST_ITEM_CONV_CALC_SN B
                                       WHERE B.ITEM_ID      = A.ITEM_ID
                                         /* AND    ic.company_id   = 'G480' */
                                         AND B.MAX_VER_FLAG = 'Y'
                                         AND B.CATEGORY     = 'Pancake (cell/m)'
                                         AND B.OPERATION    = 'E2000'
                                    )
         WHERE 1 = 1
           AND NVL(A.CONVERT_QTY_CELL, -99) = -99
             ;

        /* E20260313-002032 전극 Cell환산기준 변경 으로 인해 로직 변경 - 로직순서 변경. */
        /* -----------------------------------------------------------
           1) CONVERT_QTY_CELL : SCP_MST_ITEM_CELL_CF 의 UNIT 이 ‘EA’ 이면 1 설정
           ----------------------------------------------------------- */
        UPDATE SCP_MST_FINAL_ITEM A
           SET A.CONVERT_QTY_CELL = 1
         WHERE A.ITEM_ID IN (SELECT DISTINCT B.ITEM_ID
                               FROM SCP_MST_ITEM_CELL_CF B
                              WHERE B.UNIT = 'EA')
             ;

        /* -----------------------------------------------------------
           5) CELL_CF/CONVERT_QTY_CELL : 전극 모델 대상 BOM 소요량 확인
           칼럼추가(CELL_ITEM_ID) 후 UPDATE문 반영 PJ20230691 활성화 대응 : 최종 Cell Prod 로 처리
           ----------------------------------------------------------- */
        MERGE INTO SCP_MST_FINAL_ITEM X
              /* 전체 Cell 모델 대상 */
        USING ( SELECT A.DIVISION_ID
                     , A.MODEL_ID      AS CELL_ITEM_ID
                     , A.CHILD_ITEM_ID AS ELEC_ITEM_ID
                     , MIN(A.ACCUMULATED_CHILD_QTY) AS BOM_QTY
                     , 1.0/MIN(A.ACCUMULATED_CHILD_QTY) AS CONVERT_QTY_CELL   /* ACCUMULATED_CHILD_QTY가 0일 경우는 오류처리는 ?  --> 0 ? 1 */
                     , ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID, A.CHILD_ITEM_ID ORDER BY A.DIVISION_ID, A.CHILD_ITEM_ID, MIN(A.ACCUMULATED_CHILD_QTY) ASC) AS NO
                  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V1 A
                 WHERE 1 = 1
                   AND A.OPERATION_GROUP_ID = 'E'
                 GROUP BY A.DIVISION_ID
                        , A.MODEL_ID
                        , A.CHILD_ITEM_ID
                HAVING MIN(A.ACCUMULATED_CHILD_QTY) > 0
              ) Y
           ON ( 0 = 0
            AND X.DIVISION_ID = Y.DIVISION_ID
            AND X.ITEM_ID     = Y.ELEC_ITEM_ID
            AND Y.NO          = 1 )
        WHEN MATCHED THEN
        UPDATE SET X.CELL_CF          = Y.CONVERT_QTY_CELL
                 , X.CONVERT_QTY_CELL = Y.CONVERT_QTY_CELL
         WHERE X.OPERATION_GROUP_ID = 'E'
           AND NVL(Y.CONVERT_QTY_CELL, -99) <> -99
             ;

        /* -----------------------------------------------------------
           4) CELL_CF/CONVERT_QTY_CELL : FP Conversion 정보 사용 : CELL_ITEM_ID와 ITEM_ID 기준
           ----------------------------------------------------------- */
        UPDATE SCP_MST_FINAL_ITEM
           SET CELL_CF          = NVL((1.0 / FN_GET_REQ_QTY_MODEL_FOR_SCP_SN('', CELL_ITEM_ID, ITEM_ID, D_PLAN_DATE)), CELL_CF)  /* 20231211 : E20231204-000282   20190930 Cell 환산자 처리 */
             , CONVERT_QTY_CELL = NVL((1.0 / FN_GET_REQ_QTY_MODEL_FOR_SCP_SN('', CELL_ITEM_ID, ITEM_ID, D_PLAN_DATE)), CONVERT_QTY_CELL)
         WHERE 1 = 1
        /*    WITH XX AS
            (
            SELECT  I.DIVISION_ID,
                    I.ITEM_ID,
                    MAX(I.NICK_NAME)  AS NICK_NAME,
                    MAX(I.ITEM_CLASS) AS ITEM_CLASS,
                     20190930 전극 대표 Cell 처리 수정 : FP Item Master의 APPLIED_MODEL 컬럼  CELL_ITEM_ID
                    CASE WHEN MAX(I.SCP_OPERATION_GROUP) = 'E' THEN MAX(I.APPLIED_MODEL)
                         ELSE NULL
                    END AS CELL_ITEM_ID,
                    MAX(CASE WHEN FLOW_ID IS NULL THEN SCP_FLOW_ID ELSE FLOW_ID END) AS FLOW_ID,
                    MAX(I.SCP_OPERATION_GROUP)    AS OPERATION_GROUP,
                    MAX(I.SCP_OPERATION_GROUP_ID) AS OPERATION_GROUP_ID,
                    MAX(FI.ELECTRODE_TYPE)        AS ELECTRODE_TYPE,
                    MAX(ISNULL(FI.RACK_YN, 'N'))   AS ATTRIBUTE3,
                    MAX(ISNULL(FI.DC_YN, 'N'))     AS ATTRIBUTE4,  20220110 DC Item 구분
                    MAX(ISNULL(FI.IS_YN, 'N'))     AS ATTRIBUTE5,  20220602 PJ20216891 ISUZU Item 구분
                    MAX(ISNULL(FI.CELL_TYPE, ''))  AS ATTRIBUTE8   20230602 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
              FROM  SCM_MST_ITEM_SN       I WITH(NOLOCK)
                   ,SCM_MST_FINAL_ITEM_ORIGIN_DIV_V  FI WITH(NOLOCK)
             WHERE I.DIVISION_ID = FI.DIVISION_ID
               AND I.ITEM_ID     = FI.ITEM_ID
               AND I.ACTIVE_FLAG = 'Y'
               AND I.SCP_OPERATION_GROUP IS NOT NULL
             GROUP BY I.DIVISION_ID,
                      I.ITEM_ID
            )
              UPDATE SCP_MST_FINAL_ITEM
              SET    CELL_CF          = (1.0 / DBO.FN_GET_REQ_QTY_MODEL_FOR_SCP_SN('', XX.CELL_ITEM_ID, XX.ITEM_ID, @d_plan_date))  20231211 : E20231204-000282   20190930 Cell 환산자 처리
                   , CONVERT_QTY_CELL = (1.0 / DBO.FN_GET_REQ_QTY_MODEL_FOR_SCP_SN('', XX.CELL_ITEM_ID, XX.ITEM_ID, @d_plan_date))
                FROM XX,
                     SCP_MST_FINAL_ITEM AA WITH(NOLOCK)
               WHERE 1=1
                 AND XX.DIVISION_ID = AA.DIVISION_ID
                 AND XX.ITEM_ID     = AA.ITEM_ID
        */
             ;

        /* E20260313-002032 SCP 전극 Cell환산기준 변경요청 로직개선으로 해당 로직 추가. */
        /* CONVERT_QTY_CELL : FP 정보 적용모델기준 반영 [SCM_ITEM_CONV_CALC_M]] + UNIT 'EA' 제외. */
        UPDATE SCP_MST_FINAL_ITEM A
           SET A.CONVERT_QTY_CELL = NVL( (SELECT MAX(B.VALUE)
                                            FROM SCM_MST_ITEM_CONV_CALC_SN B
                                           WHERE B.ITEM_ID      = A.ITEM_ID
                                             AND B.MODEL_ID     = A.CELL_ITEM_ID
                                             /* AND    ic.company_id   = 'G480' */
                                             AND B.MAX_VER_FLAG = 'Y'
                                             AND B.CATEGORY     = 'Pancake (cell/m)'
                                             AND B.OPERATION    = 'E2000'
                                             AND B.VALUE        > 0
                                        ), A.CONVERT_QTY_CELL)
         WHERE 1 = 1
           /* 원본 A.ITEM_ID NOT IN (서브쿼리) : NULL 위험 회피 위해 NOT EXISTS 로 변환(CV-031) */
           AND NOT EXISTS ( SELECT 1
                              FROM SCP_MST_ITEM_CELL_CF C
                             WHERE C.ITEM_ID = A.ITEM_ID
                               AND C.UNIT    = 'EA' )
             ;

        /* -----------------------------------------------------------
           5) CELL_CF / CONVERT_QTY_CELL : GPLM
           ----------------------------------------------------------- */
        MERGE INTO SCP_MST_FINAL_ITEM A
        USING ( SELECT IA.ITEM_ID
                     , IA.CELL_CF
                  FROM ( SELECT DISTINCT C.TARGET_CELL
                                       , C.ITEM_ID
                                       , C.CELL_CF
                                       , ROW_NUMBER() OVER (PARTITION BY C.ITEM_ID ORDER BY C.BOM_MODIFY_DATE DESC, C.ATTRIBUTE5 DESC) AS RANKNO
                           FROM SCP_MST_ITEM_CELL_CF C
                          WHERE RTRIM(C.CELL_CF) IS NOT NULL   /* 원본 ISNULL(CELL_CF, '') <> '' (CELL_CF 는 VARCHAR2(30 CHAR), CV-028) */
                       ) IA
                 WHERE IA.RANKNO = 1
              ) B
           ON ( A.ITEM_ID = B.ITEM_ID )
        WHEN MATCHED THEN
        UPDATE SET A.CELL_CF          = B.CELL_CF
                 , A.CONVERT_QTY_CELL = B.CELL_CF
             ;

        /* -----------------------------------------------------------
           20231123 E20231120-000042 : 평가감 모델의 CELL_CF/CONVERT_QTY_CELL Update
           -----------------------------------------------------------
           원본 : UPDATE F ~ INNER JOIN (자기 자신을 접미사 조건으로 필터한 인라인뷰 A, PK 전체 조인) ~ LEFT JOIN (CELL_CF 보유분 B) */
        UPDATE SCP_MST_FINAL_ITEM A
           SET (A.CELL_CF, A.CONVERT_QTY_CELL) = ( SELECT B.CELL_CF, B.CELL_CF
                                                     FROM SCP_MST_ITEM_CELL_CF B
                                                    WHERE B.ITEM_ID = CASE WHEN SUBSTR(A.ITEM_ID, -2) IN ('-A', '-B', '-C', '-D', '-E', '-F', '-G', '-H', '-I', '-J', '-K', '-R') THEN SUBSTR(A.ITEM_ID, 1, LENGTH(A.ITEM_ID) - 2)
                                                                           WHEN SUBSTR(A.ITEM_ID, -3) IN ('-GG', '-GK')                                                          THEN SUBSTR(A.ITEM_ID, 1, LENGTH(A.ITEM_ID) - 3)
                                                                      END
                                                      AND RTRIM(B.CELL_CF) IS NOT NULL
                                                      AND ROWNUM = 1 )
         WHERE 1 = 1
           AND (SUBSTR(A.ITEM_ID, -2) IN ('-A', '-B', '-C', '-D', '-E', '-F', '-G', '-H', '-I', '-J', '-K', '-R') OR
                SUBSTR(A.ITEM_ID, -3) IN ('-GG', '-GK'))
           AND (A.CELL_CF IS NULL OR A.CONVERT_QTY_CELL IS NULL)
             ;

        /* -----------------------------------------------------------
           20241101 E20240923-000249  : 자동차 사업부 신규 item Code 등록 시 Basic Model Cell의 NickName 값으로 넣어줌
           ----------------------------------------------------------- */
        UPDATE SCP_MST_FINAL_ITEM A
           SET A.GROUP_CODE1 = ( CASE WHEN A.OPERATION_GROUP = 'P' THEN (SELECT B.NICK_NAME
                                                                           FROM SCP_MST_FINAL_ITEM B
                                                                          WHERE B.DIVISION_ID = A.DIVISION_ID
                                                                            AND B.ITEM_ID     = (SELECT C.DOE
                                                                                                   FROM SCM_MST_ITEM_SN C
                                                                                                  WHERE C.DIVISION_ID = A.DIVISION_ID
                                                                                                    AND C.ITEM_ID     = A.ATTRIBUTE1
                                                                                                    AND C.DOE IS NOT NULL
                                                                                                    AND ROWNUM = 1)
                                                                        )
                                      ELSE (SELECT B.NICK_NAME
                                              FROM SCP_MST_FINAL_ITEM B
                                             WHERE B.DIVISION_ID = A.DIVISION_ID
                                               AND B.ITEM_ID     = (SELECT C.DOE
                                                                      FROM SCM_MST_ITEM_SN C
                                                                     WHERE C.DIVISION_ID = A.DIVISION_ID
                                                                       AND C.ITEM_ID     = A.ITEM_ID
                                                                       AND C.DOE IS NOT NULL
                                                                       AND ROWNUM = 1)
                                           )
                                 END
                               )
         WHERE 1 = 1
           AND A.DIVISION_ID IN (SELECT D.DIVISION_ID
                                   FROM SCM_MST_DIVISION D
                                  WHERE D.ATTRIBUTE3 = '81')
           AND RTRIM(A.GROUP_CODE1) IS NULL
             ;

        /* -----------------------------------------------------------
           실행 Logic END --
           ----------------------------------------------------------- */

        /* TXN LOG */
        V_LOG_TYPE    := 'TXN';
        /* SET @n_log_count = @@ROWCOUNT; */
        V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
        D_EVENT_DATE  := SYSDATE;

        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

    EXCEPTION
        WHEN OTHERS THEN

            ROLLBACK;

            /* ERROR LOG */
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);

            V_DESCRIPTION := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => V_LOG_TYPE
                                , P_LOG_COUNT    => N_LOG_COUNT
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            RETURN;
    END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );


    COMMIT;
    RETURN;
END;