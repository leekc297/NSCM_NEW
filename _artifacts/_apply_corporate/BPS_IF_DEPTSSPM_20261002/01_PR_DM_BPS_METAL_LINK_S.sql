-- SOURCE-FRESH: SCM_MGR.PR_DM_BPS_METAL_LINK_S PROCEDURE LAST_DDL=2026-10-01 18:17:52 FETCHED=2026-10-02 10:33 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE           "PR_DM_BPS_METAL_LINK_S" 
(
    P_DIVISION_ID     VARCHAR2 /* DIVISION_ID */
   ,P_CUT_OFF_VERSION VARCHAR2 /* Version */
)
/*
    * Program ID  : PR_DM_BPS_METAL_LINK_S
    * Description  :  메탈링크 IF 연동

    * 테이블
      XIF_BPS_METAL_LINK_PRICE_S -->  XIF_BPS_METAL_LINK_PRICE_S_SN
    * Program History
    *===================================================================================================
    *   Date       In Charge      Description
    *===================================================================================================
    2024.07.23     KJJ         [PJ2024-50244]SCM DM 고객수요관리 고도화 및 개선 - 신규생성
    2024.09.12     KJJ         [PJ2024-50461] Team Mapping 로직 변경 - Sales Site Project Model 의 Owner 팀 적용(40번 사업부와 동일. 81, 81_JV, 82 사업부 적용)
    2024.10.24     KJJ         [PJ2024-50611] 소형 이동계획 확산
    2026/03/22     김준규      [PJ20264226] NextSCM Pilot 설계 및 개발

    PR_DM_BPS_METAL_LINK_S('ALL','ALL');
 * 2026.07.06	ZIONEX		[PJ202650304] NextSCM Migration
 * 2026.10.02	ZIONEX		[E20261002-IFDEPTSSPM] 팀(DEPT) = SSPM(SCM_MST_SITE_ITEM.DEPT_ID) — AS-IS Owner 팀 산출 자리, 컷오프(_C) DEPT_ID 미사용
    */
    /* ------------------------------------------------------------------------------------------------------------------------------- */
 AS

    V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE     VARCHAR2(30 CHAR);
    N_LOG_COUNT    INTEGER := 0;
    V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
    V_DESCRIPTION  VARCHAR2(500 CHAR);
    D_EVENT_DATE   DATE;
    N_DELETE_COUNT INTEGER := 0;
    N_INSERT_COUNT INTEGER := 0;
    V_CREATED_BY   VARCHAR2(150 CHAR) := 'SYS_BATCH_DATA';
    V_YYYYMMDD     VARCHAR2(08 CHAR);
    V_IN_PARA_DATA CLOB;
    V_STEP         VARCHAR2(4000 CHAR) := NULL;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID, 'p_cut_off_version' VALUE P_CUT_OFF_VERSION);

    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DBML_SCM_SYS_CALENDAR_M';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DBML_VERSION_NO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DBML_VERSION_SEQ';


    /* LOG 용 변수 설정 */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START OF PROCEDURE ##########';
    V_DESCRIPTION := 'PR_DM_BATCH_IF:';
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    DBMS_OUTPUT.PUT_LINE('A1-- ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    BEGIN
        IF P_DIVISION_ID = 'ALL' OR P_CUT_OFF_VERSION = 'ALL' THEN
            V_YYYYMMDD := TO_CHAR(SYSDATE, 'YYYYMMDD');
        ELSE
            V_YYYYMMDD := SUBSTR(P_CUT_OFF_VERSION, 6, 8);
        END IF;

        INSERT
          INTO GT_DBML_SCM_SYS_CALENDAR_M
        SELECT MIN(B.BASIS_YYYYMMDD) BASIS_YYYYMMDD_WK_FROM
             , MAX(B.BASIS_YYYYMMDD) BASIS_YYYYMMDD_WK_TO
             , MAX(SUBSTR(A.CALENDAR_YYYY, 3, 2) || 'RF_DM_' || A.CALENDAR_YYYY || '_' || A.WEEK_NAME || '_V') VERSION_NO_T
             , MAX(A.ISO_WEEK) ISO_WEEK
          FROM SCM_SYS_CALENDAR_M A
             , SCM_SYS_CALENDAR_M B
         WHERE A.ISO_YYYYWW = B.ISO_YYYYWW
           AND A.BASIS_YYYYMMDD = V_YYYYMMDD;

        /* 이동계획 수립 주차에는 Version Popup에서 이동계획 여부(Y/N)을 Y인 것이 대상 */
        INSERT
          INTO GT_DBML_VERSION_NO
        SELECT A.DIVISION_ID
             , A.VERSION_NO
             , A.MONTHLY_ROLLING_FCST
             , A.VERSION_NO_T
             , A.ISO_WEEK
             , SUBSTR(A.YYYYMMDD, 1, 6) CUTOFF_YYYYMM
             , TO_CHAR(FN_NEXT_DAY(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'MON') + (-7), 'YYYYMMDD') TO_YYYYMMDD_R
          FROM (SELECT ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID, A.VERSION_TYPE ORDER BY A.VERSION_NO DESC) RNK
                     , A.DIVISION_ID
                     , A.VERSION_NO
                     , A.VERSION_TYPE
                     , B.VERSION_NO_T
                     , B.ISO_WEEK
                     , A.YYYYMMDD
                     , NVL(A.ATTRIBUTE7, 'N') MONTHLY_ROLLING_FCST
                  FROM DM_MST_VERSION A
                     , GT_DBML_SCM_SYS_CALENDAR_M B
                 WHERE 1 = 1
                       /* AND A.DIVISION_ID NOT IN ('40') [PJ2024-50611] 소형 사업부도 허용 */
                   AND A.VERSION_TYPE = 'SP_W'
                   AND A.DIVISION_ID = CASE
                                           WHEN P_DIVISION_ID = 'ALL' OR P_CUT_OFF_VERSION = 'ALL' THEN
                                            A.DIVISION_ID
                                           ELSE
                                            P_DIVISION_ID
                                       END
                   AND A.VERSION_NO = CASE
                                          WHEN P_DIVISION_ID = 'ALL' OR P_CUT_OFF_VERSION = 'ALL' THEN
                                           A.VERSION_NO
                                          ELSE
                                           P_CUT_OFF_VERSION
                                      END
                   AND NVL(A.ATTRIBUTE7, 'N') = 'Y'
                   AND A.YYYYMMDD BETWEEN B.BASIS_YYYYMMDD_WK_FROM AND B.BASIS_YYYYMMDD_WK_TO) A
         WHERE A.RNK = 1;

        /* 최종버젼을 가져온다 */
        INSERT
          INTO GT_DBML_VERSION_SEQ
        SELECT A.DIVISION_ID
             , LPAD(CAST(A.VERSION_SEQ AS VARCHAR2(10 CHAR)), 2, '0') VERSION_SEQ
          FROM (SELECT A.DIVISION_ID
                     , TO_NUMBER(SUBSTR(MAX(A.VERSION_NO), 19, 2)) + 1 AS VERSION_SEQ
                  FROM XIF_BPS_METAL_LINK_PRICE_S_SN A
                     , GT_DBML_VERSION_NO Z
                 WHERE 1 = 1
                   AND A.DIVISION_ID = Z.DIVISION_ID
                   AND A.VERSION_NO LIKE VERSION_NO_T || '%'
                 GROUP BY A.DIVISION_ID) A;
    END;

    DBMS_OUTPUT.PUT_LINE('A3-- ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    BEGIN
        INSERT
          INTO XIF_BPS_METAL_LINK_PRICE_S_SN
             ( IFDATE
             , IFTIME
             , IFUSER
             , IFSERVICE
             , CUTOFF_YYYYMM
             , VERSION_NO
             , CUTOFF_ISO_WEEK
             , CUTOFF_YYYYMMDD
             , DIVISION_ID
             , DEPT_ID
             , DEPT_NAME
             , FCST_TYPE
             , FCST_TYPE_NAME
             , SCM_SITE_ID
             , COMPANY_ID
             , END_CUSTOMER
             , PROJECT_CODE
             , PLANT_SITE_ID
             , ITEM_ID
             , METAL_KIND_CODE
             , CURRENCY
             , METAL_EXCEPTION_YN
             , METAL_LINK_YN
             , APPLY_PRICE_TYPE_CODE
             , PLAN_YYYYMM
             , FROM_PERIOD_YYYYMM
             , TO_PERIOD_YYYYMM
             , CONTRACT_UNIT_PRICE
             , METAL_APPLY_UNIT_PRICE
             , METAL_REQR_QTY
             , CREATION_DATE
             , TRANSFER_DATE
             , TRANSFER_FLAG
             , ETL_LOAD_DATE
             , VALUE_TBL_INFO
             , SRC_SYS_CD
             , ENERGE )
        SELECT '' AS IFDATE
             , '' AS IFTIME /* 전송 시간 */
             , '' AS IFUSER /* 전송 유저 */
             , '' AS IFSERVICE /* 서비스 인터페이스명 */
             , T1.CUTOFF_YYYYMM /* 컷오프년월 */
             , T1.VERSION_NO /* 버전번호 */
             , T1.CUTOFF_ISO_WEEK /* 컷오프ISO주차 */
             , T1.CUTOFF_YYYYMMDD /* 컷오프년월일 */
             , T1.DIVISION_ID
             , T1.DEPT_ID /* 부서ID */
               /* [PJ2024-50461] Sales Site Project Model 의 Owner 팀 적용 */
               /* , T2.DEPT_NAME_KO    부서명 */
             , T1.DEPT_NAME_KO /* 부서명 */
               /* [PJ2024-50461] Sales Site Project Model 의 Owner 팀 적용 */
             , T1.FCST_TYPE /* 예측유형 */
             , NVL(T3.SEGMENT2, ' ') FCST_TYPE_NAME /* 예측유형명 */
             , T1.SCM_SITE_ID
             , T1.COMPANY_ID /* 회사ID */
             , T1.END_CUSTOMER /* End Customer */
             , T1.PROJECT_CODE /* 프로젝트코드 */
             , T1.PLANT_SITE_ID /* 플랜트사이트ID */
             , T1.ITEM_ID
             , T1.METAL_KIND_CODE
             , T1.CURRENCY
             , T1.METAL_EXCEPTION_YN
             , T1.METAL_LINK_YN
             , T1.APPLY_PRICE_TYPE_CODE
             , T1.PLAN_YYYYMM
             , T1.FROM_PERIOD_YYYYMM
             , T1.TO_PERIOD_YYYYMM
             , T1.CONTRACT_UNIT_PRICE
             , T1.METAL_APPLY_UNIT_PRICE
             , T1.METAL_REQR_QTY
             , SYSTIMESTAMP CREATION_DATE
             , SYSTIMESTAMP TRANSFER_DATE
             , 'N' AS TRANSFER_FLAG
             , SYSTIMESTAMP ETL_LOAD_DATE /* etl적재일자 */
             , '' AS VALUE_TBL_INFO /* 값테이블정보 */
             , 'SCM' AS SRC_SYS_CD /* 소스시스템코드 */
             , CAST(ROUND(NVL(T1.ENERGY, 0), 5) AS NUMBER(30, 10)) ENERGY /* ENERGY */
          FROM (SELECT SUBSTR(A.CUTOFF_YYYYMMDD, 1, 6) CUTOFF_YYYYMM /* 컷오프년월 */
                     , Z.VERSION_NO_T || NVL(TO_CHAR(Y.VERSION_SEQ, 'FM00'), '01') /*[E20261001-VERSEQ2D] GTT VERSION_SEQ=NUMBER → NVL 결과 NUMBER 로 '_V1' 생성되던 결함. 'FM00' = 공백 없는 2자리*/ VERSION_NO /* 버전번호 */
                     , F.ISO_WEEK CUTOFF_ISO_WEEK /* 컷오프ISO주차 */
                     , A.CUTOFF_YYYYMMDD CUTOFF_YYYYMMDD /* 컷오프년월일 */
                     , A.DIVISION_ID
                       /* [PJ2024-50461] Sales Site Project Model 의 Owner 팀 적용 */
                       /* , A.DEPT_ID    부서ID */


                       /* [PJ2024-50461] Sales Site Project Model 의 Owner 팀 적용 */

                       /* , A.DEPT_ID    부서ID */


                     , D.DEPT_ID /* 부서ID */ /*[E20261002-IFDEPTSSPM] A.DEPT_ID(_C) → SSPM(SCM_MST_SITE_ITEM.DEPT_ID). AS-IS = TEAM.DEPT_ID(Owner 팀) 자리*/
                     , DEPT.DEPT_NAME_KO /* 부서명 */

                     , A.SCM_SITE_ID
                     , A.FCST_TYPE /* 예측유형 */
                     , NVL(D.SALES_COMPANY, ' ') COMPANY_ID
                     , A.END_CUSTOMER
                     , A.PROJECT_CODE /* 프로젝트코드 */
                     , A.PLANT_SITE_ID /* 플랜트사이트ID */
                     , A.ITEM_ID /* 아이템ID */
                     , A.CURRENCY /* 통화코드 */
                     , A.PLAN_YYYYMM /* 계획년월 */
                     , A.METAL_KIND_CODE
                     , A.METAL_EXCEPTION_YN
                     , A.METAL_LINK_YN
                     , LUP.SEGMENT4 APPLY_PRICE_TYPE_CODE /* company_id는 저정하고 있다가 넘기는게 아니라 I/F시에 조회하여 다시 이름으로 넘김 */
                     , A.FROM_PERIOD_YYYYMM
                     , A.TO_PERIOD_YYYYMM
                     , A.CONTRACT_UNIT_PRICE
                     , A.METAL_APPLY_UNIT_PRICE
                     , A.METAL_REQR_QTY /* Item UOM */
                     , A.ENERGY /* ENERGY */
                  FROM DM_BPS_METAL_LINK_PRICE_C A
                     , GT_DBML_VERSION_NO Z
                     , GT_DBML_VERSION_SEQ Y
                     , SCM_SYS_CALENDAR_M F
                     , SCM_ADM_LOOKUP_MASTER_DETAIL LUP
                     , SCM_MST_SITE_ITEM D
                     , (SELECT C.DEPT_ID
                             , MAX(C.DEPT_NAME_KO) DEPT_NAME_KO
                          FROM SCM_MST_SSO_DEPT_INFO C
                         GROUP BY C.DEPT_ID) DEPT
                 WHERE A.DIVISION_ID = Z.DIVISION_ID(+)
                   AND A.DIVISION_ID = Y.DIVISION_ID(+)
                   AND A.CUTOFF_YYYYMMDD = F.BASIS_YYYYMMDD
                   AND A.VERSION_NO = Z.VERSION_NO
                   AND LUP.LOOKUP_TYPE(+) = 'METAL_KEY_VALUE'
                   AND LUP.SEGMENT1(+) = SUBSTR(A.DIVISION_ID, 1, 2)
                   AND LUP.SEGMENT2(+) = A.METAL_KIND_CODE
                   AND LUP.SEGMENT3(+) = A.APPLY_PRICE_TYPE_CODE
                   AND A.DIVISION_ID = D.DIVISION_ID(+)
                       /* [PJ2024-50611]소형일 경우 END_CUSTOMER로 비교. 나머지는 PROJECT_CODE로 비교 */
                       /* AND A.PROJECT_CODE = D.PROJECT_CODE */
                   AND CASE
                          WHEN A.DIVISION_ID = '40' THEN
                           A.END_CUSTOMER
                          ELSE
                           A.PROJECT_CODE
                       END = D.PROJECT_CODE(+)
                   AND A.SCM_SITE_ID = D.SCM_SITE_ID(+)
                   AND A.ITEM_ID = D.ITEM_ID(+)
                   AND D.VALID_YN(+) = 'Y'
                       /* [PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인 start */
                       /*                                       INNER  JOIN SCM_MST_SSO_DEPT_INFO C */
                       /* [PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인 end */

                   AND D.DEPT_ID = DEPT.DEPT_ID(+) /*[E20261002-IFDEPTSSPM] 부서명도 SSPM DEPT_ID 기준*/

                ) T1
             , SCM_ADM_LOOKUP_MASTER_DETAIL T3
               /* [PJ2024-50461] Team Mapping: 40번 사업부 외 적용하던 로직 제거 start */
               /* LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO T2
                  ON T1.DEPT_ID      = T2.DEPT_ID    */
               /* [PJ2024-50461] Team Mapping: 40번 사업부 외 적용하던 로직 제거 end */
         WHERE T1.FCST_TYPE = T3.SEGMENT1(+)
           AND T3.LOOKUP_TYPE(+) = 'SALES_TYPE_CODE'
           AND T3.VALID_YN(+) = 'Y';

        DBMS_OUTPUT.PUT_LINE('A4-- ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    END;
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN

        ROLLBACK;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                            ,'ERROR'
                            ,0
                            ,SQLERRM
                            ,NULL
                            ,SYSDATE
                            ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                            ,P_SQL_ERR_CODE  => SQLCODE
                            ,P_SQL_ERR_MSG   => SQLERRM
                            ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
END;
/
