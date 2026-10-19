-- SOURCE-FRESH: 사내 ZIOUI1 SCM_MGR.PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE ALL_SOURCE 덤프 2026-10-08 13:58:57 (LAST_DDL 2026-10-01 18:43:58, STATUS VALID, 3092 lines)
-- 목적: 클라우드 PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE 10-02 15:39 판의 GROUP BY 누락(ORA-00979, L763) 해소 — 사내 판으로 동기화
-- 원문 무변경(1바이트도 수정하지 않음). 적용: SCM_MGR 로 접속 후 이 파일 전체 실행 → 02_VERIFY.sql
CREATE OR REPLACE PROCEDURE         "PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE" 
(   P_DIVISION_ID       IN VARCHAR2  /* DIVISION_ID */
  , P_CUT_OFF_VERSION   IN VARCHAR2  /* MKT_FCST_C의 Version */
)
/*=====================================================================================================================================================
 * Program ID   : PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE
 * Description  : MKT FCST CUTOFF 프로시져 화요일 CUTOFF
 * Program History
 *=====================================================================================================================================================
 *    Date      In Charge     Description
 *=====================================================================================================================================================
 * 2018.10.10   KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * -----------------------------------------------------------------------------------------------------------
 * PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 에서 호출되는 Procedure로 Cufoff 테이블 관련처리를 수행함
 * -----------------------------------------------------------------------------------------------------------
 * 2019.06.24   KHSONG      [CSR_ID:4016234]자동차전지 사업부 RTF(Manual 입력) 메져 추가건 적용
 *                          -> @p_division_id 으로 RTF_SCP 수행되므로 특별히 수정할부분은 없음
 * 2019.07.09   KHSONG      [CSR ID:4027463] RTF_System[R+P] Measure 추가 요청의 건
 * 2019.07.09   KHSONG      [CSR ID:4034895] 상품 매출에 대한 마케팅의 RTF[R+P] 수정 권한 요청 및 MKT FCST 기본값 삭제 요청 (자동차사업부)
 * 2019.08.09   KHSONG      [CSR ID:4059971] VMI-In Request 로직 변경
 * 2019.09.03   KHSONG      [CSR ID:4066366] Sales Plan Waterfall 화면 메져값 수정
 * 2019.10.16   KHSONG      'RTF_SCP'Measure로 Sales Amt를 계산하던 오류를 'RTF'Measure로 수정함
 * 2019.10.28   KHSONG      Cutoff Version 'RTF' Measure 삭제 오류로직 수정
 * 2019.11.04   KHSONG      [CSR ID:4107133] VMI대상 RTF_SYS_RP MEASURE 생성로직 추가
 * 2020.02.13   HWI1993     자동차 사업부의 경우 'RTF_SCP'Measure로 Sales Amt를 계산하도록 수정
 * 2020.04.16   KHSONG      C20200413-000593 ESS사업부 RTF Measure 추가 (scp plan 수행시 모든사업부가 이 Procedure 로 호출됨)
 * 2020.05.07   KHSONG      C20200507-000035 (소형사업부 RTF 관련 Measure 숨기기)
 * 2020.06.15   hwi1993     C20200518-000359 GSCM RMA값 표기 로직 수정 요청의 건
 * 2020.07.01   P.C.I       [PJ20200138] Sales Plan Waterfall cut-off 주기 변경 - MKT_FCST_C/SALES_PLAN_C 분리
 *                          PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE_40 -> PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE 명칭 변경
 * 2020.09.09   P.C.I       [C20200909-000203] LOG 표준화 적용
 * 2020.11.13   hwi1993     [C20201103-000114] [SCM PI팀] ESS 사업부 판매 법인 VMI biz의 MKT FCST 입력 시 VMI in req 자동산출 로직 적용의 건
 * 2020.12.08   P.C.I       [C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용
 * 2020.12.23   hwi1993     [C20201222-000376] VMI Inv 메저 수량 표시
 * 2021.03.29   hwi1993     [C20210323-000456] ESS 판매법인 VMI LT 반영
 * 2021.05.11   P.C.I       [C20210511-000221] 자동차 전극 RTF 적용
 * 2021.07.08   SJHAN       [C20210705-000574] Google 반품(RMA) Sales Amount 조회 기능 요청
 * 2021.08.23   hwi1993     [중장기] 52주를 82주로 변경
 * 2021.11.09   HWI1993     [과제]W/S, CUTOFF 버전에 AS RTF 를 업데이트 하도록 프로시저 호출 추가
 * 2022.03.29   kdw2819     [C20220224-000448] ESS 사업부 VMI 기능 자동차사업부 확산 전개 요청 (VMI_IN_PLAN 으로 RTF 생성)
 * 2022.04.05   hwi1993     GM JV 작업
 * 2022.06.17   kdw2819     [C20220615-000414] RESU16H_Prime RTF 에러의 건
 * 2022.06.30   HWI1993     [C20220615-000093] [영업마케팅PI] MKT_FCST Waterfall 內 SaftyStock LevelGap measure 추가 요청 건
 * 2022.07.20   HWI1993     [C20220615-000414] RESU16H_Prime RTF 에러의 건 - RTF 중복오류 수정
 * 2022.10.17   rosia27     [C20221004-000309] ERP 피킹실적 VMI In plan(R+P) 실적 반영 요청 건
 * 2022.12.02   hwi1993     [C20221104-000430] UC법인 MKT FCST화면의 'Balance' Measure 로직 변경 요청의 件
 * 2022.12.06   HWI1993     [C20221207-000259] VMI 재고 계산시 소형사업부만 11자리 LIKE 먹도록 변경
 * 2022.12.07   hwi1993     [C20221207-000280] 원복 [C20221004-000309]
 * 2023.01.17   chano0612   [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건 - 선박BIZ건
 * 2024.05.28   HMIN        [E20240508-000695] Corvus/Siemens사 자동차사업부 RTF 산출 시 동기화 반영 요청
 *                          룩업(DM_NET_DEMAND_EXCEPTION)에 등록된 SITE대상으로 82번 사업부에 RTF정보를 81번 RTF 정보로 반영 처리
 * 2024.06.10   KCW3408     이동계획(SCP_PLN_RTF_ALLOCATION_V 테이블 에서 ITEM_ID를 가져오는 기준 변경,FROM_ITEM_ID가 존재시 먼저가져옴)
 * 2024.11.15   KANG.H.J    [PJ2024-50611] 소형 매출 프로세스 개선
 * 2024.11.29   KANG.H.J    [PJ2024-50611] 전극데이터 생성 시 ORIGIN_DIVISION_ID in ('82','40') 변경, 전 사업부 FROM_SITE_ID 추가
 * 2024.12.11   JSSBAE      [E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청
 * 2025.01.07   JSSBAE      [E20250107-000853]_[공급생산 SCM PI팀] 40번 사업부 전극 MA Plan Sales Plan Cutoff 시 적용요청
 * 2025.02.05   KANG.H.J    [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화
 * 2025.03.05   KANG.H.J    [PJ2025-50017] 소형 매출계획 동기화 개선 - EE_FN 수행시 RTF UPDATE 제외
 * 2025.04.02   KANG.H.J    [E20250402-000992] 81사업부 BPS 전송 매출계획 로직 보완
 * 2025.04.08   KANG.H.J    [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제처리
 * 2025.04.24   KANG.H.J    [PJ2025-50017] 소형 매출계획 동기화 개선 - 40사업부 PACK 제약 제거
 * 2025.04.28   KANG.H.J    [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
 * 2025.05.08   KANG.H.J    [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성) 보완
 * 2025.05.19   KANG.H.J    [PJ2025-50188] 기준수요 - RMA 등등 MKT_FCST 기반으로 RTF 생성하는 로직에서 40사업부는 SCM_FCST / 그외는 MKT_FCST로 정의함.
 * 2025.05.20   KANG.H.J    [PJ2025-50188] BALANCE MEASURE에 CELL_PROD_SITE_ID 고려
 * 2025.05.29   KANG.H.J    [PJ2025-50188] 임시테이블 #T2_MKT_FCST DROP 추가, 임시테이블 #T2_MKT_FCST ==> #T_MF_C_BALANCE_MKT_FCST 변경
 * 2025.05.29   KANG.H.J    [PJ2025-50188] @c_ee_fn_flag 처리 (현재 수행되는 것이 EE_FN 버젼일 경우 ==> 'Y' ==> RTF_SYS_RP / VMI_IN_PLAN / AS_IN_PLAN 업데이트 X)
 * 2025.06.02   KANG.H.J    [PJ2025-50188] EE_FN의 경우 VMI_IN_PLAN도 업데이트 처리
 * 2025.06.10   KANG.H.J    [PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V DROP 추가
 * 2025.06.11   KANG.H.J    [PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_C_RTF_ALLOCATION 이름변경
 * 2025.06.12   KANG.H.J    [PJ2025-50188] 임시테이블 #T_MF_C_EE_FN_MEASURE (EE-FINAL 구분관리용)
 * 2025.06.13   KANG.H.J    [PJ2025-50188] EE_FN 분기 로직 통합처리 (IF 분기문 밖에서 통합 처리)
 * 2025.06.24   KANG.H.J    [PJ2025-50188] ITEM_TYPE IN (Q,R)의 경우 DM_PLN_MKT_FCST_C에서 데이터 수집
 * 2025.11.11   JSSBAE      [E20251111-000455]_40사업부 전극 MA RTF 미반영 요청
 * 2026.01.09   JSSBAE      [E20260107-001287]_Sales Plan Waterfall W80F1 모델 RTF 미산출 건 (버전 SP_W_20260106_V002(W02))
 * 2026.04.09   JSSBAE      [E20260331-000648]_[자동차 SCM] 자동차사업부 '기준수요'기능 중 'RTF수정기능'만 우선 적용 요청 건
 * 2026.05.07   JSSBAE      [E20260507-000749]_자동차 RTF수정 오류 현상
 * 2026.05.13   JSSBAE      [E20260512-000502]_자동차 사업부 Cell Prod Site ID
 * 2026.07.06   ZIONEX        [PJ202650304] NextSCM Migration
 *=====================================================================================================================================================*/
IS
    /* LOG 용 변수 */
    V_PROGRAM_NAME              VARCHAR2(150 CHAR) := 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE';
    V_LOG_TYPE                  VARCHAR2(30 CHAR);
    N_LOG_COUNT                 NUMBER := 0;
    V_LOG_MESSAGE               VARCHAR2(1000 CHAR);
    V_DESCRIPTION               VARCHAR2(500 CHAR);
    D_EVENT_DATE                DATE;
    V_PLAN_START_YYYYMMDD       VARCHAR2(8 CHAR);
    C_PLAN_ID                   VARCHAR2(20 CHAR);
    C_CUTOFF_YYYYMMDD           VARCHAR2(8 CHAR);
    C_CUTOFF_TYPE               VARCHAR2(4 CHAR);
    C_SP_TYPE                   VARCHAR2(4 CHAR);
    C_SP_VERSION                VARCHAR2(18 CHAR);
    C_PLAN_ID_EE                VARCHAR2(20 CHAR);  /* [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용(자동차 전극 : W-1) */
    V_PLAN_WEEK_CNT             NUMBER;  /* 중장기 계획 주차 기간 */
    C_EE_FN_FLAG                VARCHAR2(2 CHAR);  /* [PJ2025-50017] EE(40)의 FN 버전 여부 FLAG */
    V_MEASURE                   VARCHAR2(30 CHAR);  /* [PJ2025-50188] 40사업부는 SCM_FCST / 그외는 MKT_FCST. */
    V_SP_CUTOFF_FLAG            VARCHAR2(2 CHAR);  /* [E20260331-000648]_SALES PLAN CUTOFF 여부를 판단한 후 RTF 데이터 수정여부를 판단하기 위해 FLAG를 추가한다. */
    C_SCP_RTF_FLAG             VARCHAR2(2 CHAR);  /* [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 MKT Fcst에 RTF를 업데이트 하지 않음 */
    V_MAX_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR);  /* [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용 */
    C_SCP_RTF_FLAG_EE          VARCHAR2(2 CHAR);  /* [C20210511-000221] (자동차 전극 : W-1) */
    V_MAX_PLAN_START_YYYYMMDD_EE VARCHAR2(8 CHAR);  /* [C20210511-000221] (자동차 전극 : W-1) */
    V_CUT_OFF_VERSION_81        VARCHAR2(18 CHAR);  /* [E20240508-000695] 82번 사업부 호출시 81번 정보 RTF 갱신위한 작업 */
    V_STOCK_SEQ                 NUMBER;
    V_RTF_SCP_CNT               NUMBER;
    V_RTF_CNT                   NUMBER;
    V_RTF_SYS_RP_CNT            NUMBER;  /* 20240528 */
    V_AFTER_RTF_DATA_CNT        NUMBER;
BEGIN
    /* ================================================================================================================ */
    /* GTT 초기화 (ON COMMIT PRESERVE ROWS 이므로 세션 잔존 방지. 원본 DROP+CREATE 초기화 등가) */
    /* ================================================================================================================ */
    DELETE FROM GT_DPMFCQB_CUTOFF_MST;
    DELETE FROM GT_DPMFCQB_CUTOFF_MST_ACCUM;
    DELETE FROM GT_DPMFCQB_CUTOFF_TEMPX;
    DELETE FROM GT_DPMFCQB_VMI_MST;
    DELETE FROM GT_DPMFCQB_VMI_MST_MAIN;
    DELETE FROM GT_DPMFCQB_VMI_TEMP1;
    DELETE FROM GT_DPMFCQB_VMI_TEMP2;
    DELETE FROM GT_DPMFCQB_VMI_TEMP_ALL;
    DELETE FROM GT_DPMFCQB_SSLVL;
    DELETE FROM GT_DPMFCQB_MEASURE_MF_ALL;
    DELETE FROM GT_DPMFCQB_MEASURE_VMI_RTF;
    DELETE FROM GT_DPMFCQB_MEASURE_RTF;
    DELETE FROM GT_DPMFCQB_RTF_EXCEPTION_ITEM;
    DELETE FROM GT_DPMFCQB_MF_C_RTF_ALLOCATION;
    DELETE FROM GT_DPMFCQB_MKT_FCST_INSERT;
    DELETE FROM GT_DPMFCQB_CFM_DEMAND_INSERT;
    DELETE FROM GT_DPMFCQB_T9_RTF_AFTER_INS;
    DELETE FROM GT_DPMFCQB_T9_CFM_DMD_AFTER_INS;
    DELETE FROM GT_DPMFCQB_T9_RTF_AFTER_INS2;
    DELETE FROM GT_DPMFCQB_T9_CFM_DMD_AFT_INS2;
    DELETE FROM GT_DPMFCQB_FP_STOCK_QTY;
    DELETE FROM GT_DPMFCQB_MF_C_BALANCE_MKT_FCST;


    /* ================================================================================================================ */
    /* 변수값 셋팅 */
    /* ================================================================================================================ */
    BEGIN
        SELECT YYYYMMDD INTO C_CUTOFF_YYYYMMDD
        FROM   DM_MST_VERSION
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_CUT_OFF_VERSION;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        C_CUTOFF_YYYYMMDD := NULL;
    END;

    V_PLAN_START_YYYYMMDD := TO_CHAR(FN_NEXT_DAY(TO_DATE(C_CUTOFF_YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD');  /* 월요일 */
    C_CUTOFF_TYPE         := SUBSTR(P_CUT_OFF_VERSION, 1, 4);
    C_SP_TYPE             := 'SP' || SUBSTR(C_CUTOFF_TYPE, 3, 2);  /* SALES PLAN 용 */
    C_SP_VERSION          := 'SP' || SUBSTR(P_CUT_OFF_VERSION, 3, 16);  /* SALES PLAN 용 */

    SELECT NVL(MAX(PLAN_ID), ' ') INTO C_PLAN_ID  /* plan_id 추출 */
    FROM   SCP_PLN_RTF_ALLOCATION_V
    WHERE  DIVISION_ID = P_DIVISION_ID
    AND    PLAN_START_YYYYMMDD <= V_PLAN_START_YYYYMMDD;

    /* ---------------------------------------------------------------------------------------------------------------- */
    /* [E20250107-000853]_[공급생산 SCM PI팀] 40번 사업부 전극 MA Plan Sales Plan Cutoff 시 적용요청 (START) */
    /* 40사업부인 경우에만 당주 반영하고, 타사업부는 원 로직과 동일하게 전주 반영 */
    /* ---------------------------------------------------------------------------------------------------------------- */
    IF P_DIVISION_ID = '40' THEN
        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20251111-000455]_40사업부 전극 MA RTF 미반영 요청 (START) */
        /* EE 전극 미반영 요청으로 해당 부분 주석처리 후 PLAN_ID 체크하지 않도록 공백값 으로 설정 */
        /* ---------------------------------------------------------------------------------------------------------------- */
        /*
        SET @c_plan_id_ee            = ISNULL((SELECT MAX(plan_id)
                                               FROM SCP_PLN_RTF_ALLOCATION_V WITH(NOLOCK)
                                               --[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청 START
                                               --WHERE division_id = @p_division_id
                                               WHERE division_id = 'EE'
                                               AND origin_division_id = @p_division_id
                                               --[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청 END
                                               and plan_start_yyyymmdd <= @plan_start_yyyymmdd ),'')  --[C20210511-000221] plan_id_ee 추출
        ;
        */
        C_PLAN_ID_EE := ' ';  /* 원본 SET @c_plan_id_ee = '' (공백) */
        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20251111-000455]_EE 전극 미반영 요청으로 해당 부분 주석처리 후 PLAN_ID 체크하지 않도록 공백값 으로 설정 (END) */
        /* ---------------------------------------------------------------------------------------------------------------- */
        V_MEASURE := 'SCM_FCST';  /* [PJ2025-50188] 40사업부는 SCM_FCST / 그외는 MKT_FCST. */
    ELSE
        /* [변환주의] 원본 MAX(PLAN_ID)-1 : PLAN_ID 컬럼(문자)이나 산술(-1) 사용 -> 숫자로 취급. 렉시컬 MAX 후 숫자 -1. 무데이터시 원본 ISNULL(,'')='0' 이나 다운스트림 등가비교(무매칭) -> 공백 sentinel 사용. */
        SELECT NVL(TO_CHAR(TO_NUMBER(MAX(PLAN_ID)) - 1), ' ') INTO C_PLAN_ID_EE  /* [C20210511-000221] plan_id_ee 추출 */
        FROM   SCP_PLN_RTF_ALLOCATION_V
        WHERE  DIVISION_ID = 'EE'
        AND    ORIGIN_DIVISION_ID = P_DIVISION_ID
        AND    PLAN_START_YYYYMMDD <= V_PLAN_START_YYYYMMDD;
        V_MEASURE := 'MKT_FCST';  /* [PJ2025-50188] 40사업부는 SCM_FCST / 그외는 MKT_FCST. */
    END IF;
    /* ---------------------------------------------------------------------------------------------------------------- */
    /* [E20250107-000853]_[공급생산 SCM PI팀] 40번 사업부 전극 MA Plan Sales Plan Cutoff 시 적용요청 (END) */
    /* ---------------------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(C_PLAN_ID_EE);

    /* ---------------------------------------------------------------------------------------------------------------- */
    /* 중장기 계획 주차 기간 */
    /* ---------------------------------------------------------------------------------------------------------------- */
    BEGIN
        SELECT ATTRIBUTE1 INTO V_PLAN_WEEK_CNT
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'DM_LONG_PLAN_WEEK_CNT'
        AND    VALID_YN = 'Y'
        AND    SEGMENT1 = P_DIVISION_ID;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        V_PLAN_WEEK_CNT := NULL;
    END;


    IF V_PLAN_WEEK_CNT IS NULL THEN
        V_PLAN_WEEK_CNT := 54;
    END IF;

    /* ---------------------------------------------------------------------------------------------------------------- */
    /* [E20260331-000648]_당주 월요일이후, SALES PLAN CUTOFF 데이터가 존재하는 경우에만 수정한 RTF를 적용한다. 그 이전에는 SCP RTF를 적용하기위해 FLAG를 받는다. (START) */
    /* ---------------------------------------------------------------------------------------------------------------- */
    /* 40 사업부와 81사업부에 한하여 해당 부분 요청하였으므로, 40, 81만 쓰도록 한다. */
    IF ( P_DIVISION_ID = '40' OR SUBSTR(P_DIVISION_ID, 1, 2) = '81' ) THEN
        SELECT CASE WHEN A.CNT > 0 THEN 'Y' ELSE 'N' END INTO V_SP_CUTOFF_FLAG
        FROM ( SELECT COUNT(*) AS CNT
               FROM   DM_MST_VERSION
               WHERE  DIVISION_ID = P_DIVISION_ID
               AND    VERSION_TYPE = 'SP_W'
               AND    YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD') ) A;
    ELSE
        V_SP_CUTOFF_FLAG := 'N';
    END IF;
    /* ---------------------------------------------------------------------------------------------------------------- */
    /* [E20260331-000648]_당주 월요일이후, SALES PLAN CUTOFF 데이터가 존재하는 경우에만 수정한 RTF를 적용한다. 그 이전에는 SCP RTF를 적용하기위해 FLAG를 받는다. (END) */
    /* ---------------------------------------------------------------------------------------------------------------- */
    /* ---------------------------------------------------------------------------------------------------------------- */
    /* ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
        [E20240508-000695] 82번 사업부 호출시 81번 정보 RTF 갱신위한 작업
       ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■*/
    SELECT MAX(VERSION_NO) INTO V_CUT_OFF_VERSION_81
    FROM   DM_MST_VERSION
    WHERE  1 = 1
    AND    DIVISION_ID  = '81'
    AND    YYYYMMDD    >= V_PLAN_START_YYYYMMDD  /* 당주월요일부터 */
    AND    VERSION_TYPE = 'MF_W';  /* 81 사업부는 MF_W만 있음 */

    /* SELECT @p_cut_off_version_81 AS '@p_cut_off_version_81' ;RETURN; */
    DBMS_OUTPUT.PUT_LINE(V_CUT_OFF_VERSION_81);

    /* ================================================================================================================ */
    /* 시작 LOG  (START) */
    /* ================================================================================================================ */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########1';
    V_DESCRIPTION := '@p_division_id : ' || RTRIM(LTRIM(P_DIVISION_ID)) || ' / ' || '@p_cut_off_version : ' || RTRIM(LTRIM(P_CUT_OFF_VERSION)) || ' / ' || '@c_plan_id : ' || RTRIM(LTRIM(C_PLAN_ID));
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL;   /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    /* ================================================================================================================ */
    /* 시작 LOG  (END) */
    /* ================================================================================================================ */

    /* 트랜잭션 (START) : 부모 proc이 트랜잭션 소유 -> 본문 COMMIT/ROLLBACK/TRAN 제거 */
    /* BEGIN TRANSACTION MKT_FCST_C_QTY_BALANCE_CREATE; */
    /* ------------------------------------------------------------------------------------------ */
    BEGIN
    /* ------------------------------------------------------------------------------------------ */
        /* ---------------------------------------------------------------------------------------------------------------- */
        /* TEMP TABLE SETTING (원본 #temp DROP/CREATE -> Oracle GTT 사전생성으로 대체, 시작부 DELETE 초기화 완료) */
        /* ---------------------------------------------------------------------------------------------------------------- */
        NULL;  /* (원본 임시테이블 생성 블록 : GTT 로 대체됨) */

        /* ---------------------------------------------------------------------------------------------------------------- */
        /* MKT_FCST, RTF 대상 날짜및 값 추출 (START) */
        /* RTF MEASURE MKT_FCST TABLE INSERT (START) */
        /* ---------------------------------------------------------------------------------------------------------------- */
        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용 (START) */
        /* ---------------------------------------------------------------------------------------------------------------- */
        SELECT NVL(MAX(PLAN_START_YYYYMMDD), ' ') INTO V_MAX_PLAN_START_YYYYMMDD
        FROM   SCP_PLN_RTF_ALLOCATION_V
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    PLAN_ID     = C_PLAN_ID;

        SELECT NVL(MAX(DM_RTF_YN), 'Y') INTO C_SCP_RTF_FLAG
        FROM   SCP_PLN_INTERFACE_YN
        WHERE  DIVISION_ID        = P_DIVISION_ID
        AND    PLAN_START_YYYYMMDD = V_MAX_PLAN_START_YYYYMMDD;

        IF ( C_SCP_RTF_FLAG = 'N' ) THEN
            /* [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용 (START) */
            SELECT MAX(PLAN_ID) INTO C_PLAN_ID
            FROM   SCM_MST_PLAN
            WHERE  DIVISION_ID = P_DIVISION_ID
            AND    PLAN_CYCLE  = 'WEEKLY'
            AND    PLAN_NAME   = ( SELECT MAX(PLAN_START_YYYYMMDD)
                                   FROM   SCP_PLN_INTERFACE_YN
                                   WHERE  DIVISION_ID         = P_DIVISION_ID
                                   AND    PLAN_START_YYYYMMDD < V_MAX_PLAN_START_YYYYMMDD
                                   AND    DM_RTF_YN           = 'Y' );

            /* ---------------------------------------------------------------------------------------------------------------- */
            /* LOG 생성 (START) */
            /* ---------------------------------------------------------------------------------------------------------------- */
            V_LOG_TYPE    := 'ING';
            V_LOG_MESSAGE := 'SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용';
            V_DESCRIPTION := '@p_division_id : ' || NVL(P_DIVISION_ID, 'NULL') || ' / ' || '@c_plan_id : ' || NVL(C_PLAN_ID, 'NULL');
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            /* ---------------------------------------------------------------------------------------------------------------- */
            /* LOG 생성 (END) */
            /* ---------------------------------------------------------------------------------------------------------------- */
        END IF;
        /* [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용 (END) */

        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용(자동차 전극 : W-1) (START) */
        /* ---------------------------------------------------------------------------------------------------------------- */
        SELECT NVL(MAX(PLAN_START_YYYYMMDD), ' ') INTO V_MAX_PLAN_START_YYYYMMDD_EE
        FROM   SCP_PLN_RTF_ALLOCATION_V
        WHERE  DIVISION_ID        = 'EE'
        AND    ORIGIN_DIVISION_ID = P_DIVISION_ID
        AND    PLAN_ID            = C_PLAN_ID_EE;

        SELECT NVL(MAX(DM_RTF_YN), 'Y') INTO C_SCP_RTF_FLAG_EE
        FROM   SCP_PLN_INTERFACE_YN
        WHERE  DIVISION_ID         = 'EE'
        AND    PLAN_START_YYYYMMDD = V_MAX_PLAN_START_YYYYMMDD_EE;

        IF ( C_SCP_RTF_FLAG_EE = 'N' ) THEN
            /* [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용 (START) */
            SELECT MAX(PLAN_ID) INTO C_PLAN_ID_EE
            FROM   SCM_MST_PLAN
            WHERE  DIVISION_ID = 'EE'
            AND    PLAN_CYCLE  = 'WEEKLY'
            AND    PLAN_NAME   = ( SELECT MAX(PLAN_START_YYYYMMDD)
                                   FROM   SCP_PLN_INTERFACE_YN
                                   WHERE  DIVISION_ID         = 'EE'
                                   AND    PLAN_START_YYYYMMDD < V_MAX_PLAN_START_YYYYMMDD_EE
                                   AND    DM_RTF_YN           = 'Y' );

            /* ---------------------------------------------------------------------------------------------------------------- */
            /* LOG 생성 (START) */
            /* ---------------------------------------------------------------------------------------------------------------- */
            V_LOG_TYPE    := 'ING';
            V_LOG_MESSAGE := 'SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용(EE)';
            V_DESCRIPTION := '@p_division_id : ' || NVL(P_DIVISION_ID, 'NULL') || ' / ' || '@c_plan_id_ee : ' || NVL(C_PLAN_ID_EE, 'NULL');
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            /* ---------------------------------------------------------------------------------------------------------------- */
            /* LOG 생성 (END) */
            /* ---------------------------------------------------------------------------------------------------------------- */
        END IF;
        /* [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용(자동차 전극 : W-1) (END) */

        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [PJ2025-50017] 소형 매출계획 동기화 개선 (START) */
        /* ---------------------------------------------------------------------------------------------------------------- */
        IF ( P_DIVISION_ID = '40' ) THEN
            /* [PJ2025-50188] PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE 는 40으로 호출되기 때문에 현재 수행되는 DIVISION이 40인지 EE인지 판별 필요함. */
            /* START ==> SCM_MST_PLAN_DETAIL 의 최근 수행목록을 기반으로 체크함. */
            BEGIN
                SELECT CASE WHEN DIVISION_ID = 'EE' THEN 'Y' ELSE 'N' END INTO C_EE_FN_FLAG
                FROM ( SELECT DIVISION_ID, OUTPUT_END_DATE, RANK() OVER (ORDER BY OUTPUT_END_DATE DESC NULLS LAST, PLAN_SEQ DESC NULLS LAST) AS RN  /* AS-IS MSSQL 은 내림차순에서 값 없음을 뒤에 둔다 — 사업부 분기 판정이 뒤집히지 않게 */
                       FROM   SCM_MST_PLAN_DETAIL
                       WHERE  DIVISION_ID IN ( '40', 'EE' )
                       AND    PLAN_ID   = C_PLAN_ID
                       AND    PLAN_TYPE = 'FN' )
                WHERE RN = 1 AND ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                C_EE_FN_FLAG := NULL;
            END;

            IF C_EE_FN_FLAG IS NULL THEN
                C_EE_FN_FLAG := 'N';
            END IF;
            /* [PJ2025-50188] PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE 는 40으로 호출되기 때문에 현재 수행되는 DIVISION이 40인지 EE인지 판별 필요함. END */
        END IF;
        /* [PJ2025-50017] 소형 매출계획 동기화 개선 (END) */

        /* ---------------------------------------------------------------------------------------------------------------- */
        /* LOG 생성 (START) */
        /* ---------------------------------------------------------------------------------------------------------------- */
        V_LOG_TYPE    := 'ING';
        V_LOG_MESSAGE := 'Plan ID';
        V_DESCRIPTION := '@p_division_id : ' || NVL(P_DIVISION_ID, 'NULL') || ' / ' || ' / @c_plan_id : ' || NVL(C_PLAN_ID, 'NULL') || ' / @c_plan_id_ee : ' || NVL(C_PLAN_ID_EE, 'NULL');
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        /* ---------------------------------------------------------------------------------------------------------------- */
        /* LOG 생성 (END) */
        /* ---------------------------------------------------------------------------------------------------------------- */

        IF ( P_DIVISION_ID = '40' AND C_EE_FN_FLAG = 'Y' ) THEN
            /* [PJ2025-50017] 현재 수행되는 기준이 EE_FN일 경우 RTF_SYS_RP/VMI_IN_PLAN/AS_IN_PLAN는 업데이트 안함. (RTF_PR만 업데이트 처리) ==> [PJ2025-50188] VMI_IN_PLAN/AS_IN_PLAN 업데이트 하는 것으로 변경 */
            /* [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_MF_ALL (EE_FN에서는 VMI_IN_PLAN/AS_INPLAN/RTF_PR만 SCP와 동기화) */
            INSERT INTO GT_DPMFCQB_MEASURE_MF_ALL ( MEASURE )
            SELECT 'VMI_In_Plan' FROM DUAL UNION ALL
            SELECT 'AS_In_Plan'  FROM DUAL UNION ALL
            SELECT 'SS_LVL'      FROM DUAL UNION ALL
            SELECT 'SS_GAP'      FROM DUAL UNION ALL
            SELECT 'RTF_PR'      FROM DUAL;
            /* [PJ2025-50188] 'RTF_SYS_RP', 'RTF_SCP'는 제외함. */
        ELSE
            /* [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_MF_ALL (EE_FN이 아닐 경우는 VMI_IN_PLAN/AS_INPLAN/RTF_PR/RTF_SYS_RP/RTF_SCP 까지 모두 SCP와 동기화) */
            INSERT INTO GT_DPMFCQB_MEASURE_MF_ALL ( MEASURE )
            SELECT 'VMI_In_Plan' FROM DUAL UNION ALL
            SELECT 'AS_In_Plan'  FROM DUAL UNION ALL
            SELECT 'SS_LVL'      FROM DUAL UNION ALL
            SELECT 'SS_GAP'      FROM DUAL UNION ALL
            SELECT 'RTF_PR'      FROM DUAL UNION ALL
            SELECT 'RTF_SYS_RP'  FROM DUAL UNION ALL
            SELECT 'RTF_SCP'     FROM DUAL UNION ALL
            SELECT 'RTF'         FROM DUAL;
            /* [PJ2025-50188] 'RTF_SYS_RP', 'RTF_SCP', 'RTF'는 포함함. */
        END IF;

        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20260331-000648]_당주 월요일이후 데이터 중 당주 월요일 이후 수정한 이력이 있는 데이터를 TEMP에 담는다. (START) */
        /* ---------------------------------------------------------------------------------------------------------------- */
        IF ( V_SP_CUTOFF_FLAG = 'Y' ) THEN  /* 당주 월요일 이후 SALES PLAN을 CUTOFF한 데이터가 존재하는 경우에만 테이블 데이터를 INSERT 한다. */
            IF ( P_DIVISION_ID = '40' OR P_DIVISION_ID LIKE '81%' ) THEN  /* [E20260512-000502]_81도 CELL_PROD_SITE_ID를 받기때문에 해당 부분을 타도록 수정한다. */
                /* 사용자가 변경하는 값은 해당 시점에 데이터가 변경되기때문에 변경때 변경되는 메져 3개는 당주 월요일 이후 수정건에 대한 내역 추출 */
                INSERT INTO GT_DPMFCQB_RTF_EXCEPTION_ITEM
                ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID )
                SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                FROM   DM_PLN_CFM_MKT_DEMAND_PLAN_C
                WHERE  DIVISION_ID = P_DIVISION_ID  /* 81 */
                AND    YYYYMMDD   >= V_PLAN_START_YYYYMMDD  /* 당주월요일 이후 데이터만 '20260406' */
                AND    VERSION_NO  = P_CUT_OFF_VERSION
                AND    TO_CHAR(LAST_UPDATE_DATE, 'YYYYMMDD') >= V_PLAN_START_YYYYMMDD  /* 당주월요일 이후 데이터만 '20260406' */
                AND    MEASURE IN ( 'RTF_SYS_RP', 'RTF', 'RTF_SCP' )
                AND    LAST_UPDATED_BY NOT IN ( 'SYSTEM', 'CUTOFF' )
                GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID;

                /* RTF_PR메져는 SCP의 FINAL값을 반영하는 부분으로, 수정된 대상들을 가지고 조회한다. */
                INSERT INTO GT_DPMFCQB_RTF_EXCEPTION_ITEM
                ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID )
                SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                     , A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID
                FROM   DM_PLN_CFM_MKT_DEMAND_PLAN_C A
                INNER JOIN GT_DPMFCQB_RTF_EXCEPTION_ITEM B
                        ON A.DIVISION_ID       = B.DIVISION_ID
                       AND A.PROJECT_CODE      = B.PROJECT_CODE
                       AND A.END_CUSTOMER      = B.END_CUSTOMER
                       AND A.SCM_SITE_ID       = B.SCM_SITE_ID
                       AND A.ITEM_ID           = B.ITEM_ID
                       AND A.DOM_EXP           = B.DOM_EXP
                       AND A.FCST_TYPE         = B.FCST_TYPE
                       AND A.INCOTERMS         = B.INCOTERMS
                       AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
                       AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                WHERE  A.MEASURE    = 'RTF_PR'
                AND    A.VERSION_NO = P_CUT_OFF_VERSION
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                       , A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID;
            ELSE
                /* 사용자가 변경하는 값은 해당 시점에 데이터가 변경되기때문에 변경때 변경되는 메져 3개는 당주 월요일 이후 수정건에 대한 내역 추출 */
                INSERT INTO GT_DPMFCQB_RTF_EXCEPTION_ITEM
                ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID )
                SELECT DIVISION_ID, PROJECT_CODE, '' AS END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                     , MEASURE, PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID
                FROM   DM_PLN_MKT_FCST_C
                WHERE  DIVISION_ID = P_DIVISION_ID  /* 81 */
                AND    YYYYMMDD   >= V_PLAN_START_YYYYMMDD  /* 당주월요일 이후 데이터만 '20260406' */
                AND    TO_CHAR(LAST_UPDATE_DATE, 'YYYYMMDD') >= V_PLAN_START_YYYYMMDD  /* 당주월요일 이후 데이터만 '20260406' */
                AND    VERSION_NO  = P_CUT_OFF_VERSION
                AND    MEASURE IN ( 'RTF_SYS_RP', 'RTF', 'RTF_SCP' )
                AND    LAST_UPDATED_BY NOT IN ( 'SYSTEM', 'CUTOFF' )
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID;

                /* RTF_PR메져는 SCP의 FINAL값을 반영하는 부분으로, 수정된 대상들을 가지고 조회한다. */
                INSERT INTO GT_DPMFCQB_RTF_EXCEPTION_ITEM
                ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID )
                SELECT A.DIVISION_ID, A.PROJECT_CODE, '' AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                     , A.MEASURE, A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID
                FROM   DM_PLN_MKT_FCST_C A
                INNER JOIN GT_DPMFCQB_RTF_EXCEPTION_ITEM B
                        ON A.DIVISION_ID   = B.DIVISION_ID
                       AND A.PROJECT_CODE  = B.PROJECT_CODE
                       AND A.SCM_SITE_ID   = B.SCM_SITE_ID
                       AND A.ITEM_ID       = B.ITEM_ID
                       AND A.DOM_EXP       = B.DOM_EXP
                       AND A.FCST_TYPE     = B.FCST_TYPE
                       AND A.INCOTERMS     = B.INCOTERMS
                       AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                WHERE  A.MEASURE    = 'RTF_PR'
                AND    A.VERSION_NO = P_CUT_OFF_VERSION
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID;
            END IF;
        END IF;
        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20260331-000648]_당주 월요일이후 데이터 중 당주 월요일 이후 수정한 이력이 있는 데이터를 TEMP에 담는다. (END) */
        /* ---------------------------------------------------------------------------------------------------------------- */

        /*  -- [PJ2025-50188] #T_MEASURE_MF_ALL 참고
             . EE_FN 인 경우   ('VMI_In_Plan', 'AS_In_Plan', 'SS_LVL', 'SS_GAP', 'RTF_PR')
             . EE_FN 아닌 경우 ('VMI_In_Plan', 'AS_In_Plan', 'SS_LVL', 'SS_GAP', 'RTF_PR', 'RTF_SYS_RP','RTF_SCP', 'RTF' ) */
        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20260107-001287]_전극의 경우는 FCSTPRICE MGMT 화면에서 데이터를 저장한 데이터를 반영하기 때문에, 40사업부의 경우는 삭제하지 않도록 수정한다.(START) */
        IF ( P_DIVISION_ID = '40' ) THEN
            /* [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_MF_ALL (임시테이블에 정의된 MEASURE 삭제) */
            /* [E20260107-001287]_40 사업부 데이터를 삭제할때는 전극 데이터가 삭제되지 않도록 NOT IN 처리를 한다. */
            DELETE FROM DM_PLN_MKT_FCST_C A
            WHERE  A.MEASURE IN ( SELECT MEASURE FROM GT_DPMFCQB_MEASURE_MF_ALL )
            AND    A.DIVISION_ID     = P_DIVISION_ID
            AND    A.VERSION_NO      = P_CUT_OFF_VERSION
            AND    A.CUTOFF_TYPE     = C_CUTOFF_TYPE
            AND    A.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
            AND    A.ITEM_ID NOT IN ( SELECT K.ITEM_ID FROM SCM_MST_ITEM_SN K
                                      WHERE K.DIVISION_ID = A.DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y' AND K.DIVISION_ID = '40' )
            /* [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. */
            AND    NOT EXISTS ( SELECT 1
                                FROM   GT_DPMFCQB_RTF_EXCEPTION_ITEM B
                                WHERE  A.DIVISION_ID   = B.DIVISION_ID
                                AND    A.PROJECT_CODE  = B.PROJECT_CODE
                                AND    A.SCM_SITE_ID   = B.SCM_SITE_ID
                                AND    A.ITEM_ID       = B.ITEM_ID
                                AND    A.DOM_EXP       = B.DOM_EXP
                                AND    A.FCST_TYPE     = B.FCST_TYPE
                                AND    A.INCOTERMS     = B.INCOTERMS
                                AND    A.MEASURE       = B.MEASURE
                                AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID
                                AND    A.YYYYMMDD     >= V_PLAN_START_YYYYMMDD   /*-- 당주월요일*/
                                AND    A.VERSION_NO    = P_CUT_OFF_VERSION );
        ELSE
            /* [E20260107-001287]_40 사업부 외의 다른 사업부는 원 로직과 동일하게 둔다. */
            /* [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_MF_ALL (임시테이블에 정의된 MEASURE 삭제) */
            DELETE FROM DM_PLN_MKT_FCST_C A
            WHERE  A.MEASURE IN ( SELECT MEASURE FROM GT_DPMFCQB_MEASURE_MF_ALL )
            AND    A.DIVISION_ID     = P_DIVISION_ID
            AND    A.VERSION_NO      = P_CUT_OFF_VERSION
            AND    A.CUTOFF_TYPE     = C_CUTOFF_TYPE
            AND    A.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
            /* [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. */
            AND    NOT EXISTS ( SELECT 1
                                FROM   GT_DPMFCQB_RTF_EXCEPTION_ITEM B
                                WHERE  A.DIVISION_ID   = B.DIVISION_ID
                                AND    A.PROJECT_CODE  = B.PROJECT_CODE
                                AND    A.SCM_SITE_ID   = B.SCM_SITE_ID
                                AND    A.ITEM_ID       = B.ITEM_ID
                                AND    A.DOM_EXP       = B.DOM_EXP
                                AND    A.FCST_TYPE     = B.FCST_TYPE
                                AND    A.INCOTERMS     = B.INCOTERMS
                                AND    A.MEASURE       = B.MEASURE
                                AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID
                                AND    A.YYYYMMDD     >= V_PLAN_START_YYYYMMDD   /*-- 당주월요일*/
                                AND    A.VERSION_NO    = P_CUT_OFF_VERSION );
        END IF;
        /* [E20260107-001287]_전극의 경우는 FCSTPRICE MGMT 화면에서 데이터를 저장한 데이터를 반영하기 때문에, 40사업부의 경우는 삭제하지 않도록 수정한다.(END) */

        /* [C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용 */
        DELETE FROM DM_PLN_MKT_FCST_C
        WHERE  MEASURE IN ( 'RTF' )
        AND    DIVISION_ID     = P_DIVISION_ID
        AND    VERSION_NO      = P_CUT_OFF_VERSION
        AND    CUTOFF_TYPE     = C_CUTOFF_TYPE
        AND    CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
        AND    DIVISION_ID     = '82';

        /* [E20240508-000695] */
        DELETE FROM DM_PLN_MKT_FCST_C A
        WHERE  A.MEASURE IN ( 'RTF' )
        AND    A.DIVISION_ID     = P_DIVISION_ID
        AND    A.VERSION_NO      = P_CUT_OFF_VERSION
        AND    A.CUTOFF_TYPE     = C_CUTOFF_TYPE
        AND    A.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
        AND    A.DIVISION_ID     = '81'
        AND    A.DIVISION_ID IN ( SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y' )
        AND    A.SCM_SITE_ID IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y' )
        /* [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. */
        AND    NOT EXISTS ( SELECT 1
                            FROM   GT_DPMFCQB_RTF_EXCEPTION_ITEM B
                            WHERE  A.DIVISION_ID   = B.DIVISION_ID
                            AND    A.PROJECT_CODE  = B.PROJECT_CODE
                            AND    A.SCM_SITE_ID   = B.SCM_SITE_ID
                            AND    A.ITEM_ID       = B.ITEM_ID
                            AND    A.DOM_EXP       = B.DOM_EXP
                            AND    A.FCST_TYPE     = B.FCST_TYPE
                            AND    A.INCOTERMS     = B.INCOTERMS
                            AND    A.MEASURE       = B.MEASURE
                            AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID
                            AND    A.YYYYMMDD     >= V_PLAN_START_YYYYMMDD   /*-- 당주월요일*/
                            AND    A.VERSION_NO    = P_CUT_OFF_VERSION );
        /*  -- [PJ2025-50188] #T_MEASURE_MF_ALL 참고
             . EE_FN 인 경우   ('VMI_In_Plan', 'AS_In_Plan', 'SS_LVL', 'SS_GAP', 'RTF_PR')
             . EE_FN 아닌 경우 ('VMI_In_Plan', 'AS_In_Plan', 'SS_LVL', 'SS_GAP', 'RTF_PR', 'RTF_SYS_RP','RTF_SCP' )*/
        /* [E20260107-001287]_전극의 경우는 FCSTPRICE MGMT 화면에서 데이터를 저장한 데이터를 반영하기 때문에, 40사업부의 경우는 삭제하지 않도록 수정한다.(START) */
        IF ( P_DIVISION_ID = '40' ) THEN
            /* [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MF_C_EE_FN_MEASURE (정의된 MEASURE만 업데이트 함.) */
            /* [E20260107-001287]_40 사업부 데이터를 삭제할때는 전극 데이터가 삭제되지 않도록 NOT IN 처리를 한다. (START) */
            DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
            WHERE  A.MEASURE IN ( SELECT MEASURE FROM GT_DPMFCQB_MEASURE_MF_ALL )
            AND    A.DIVISION_ID     = P_DIVISION_ID
            AND    A.VERSION_NO      = P_CUT_OFF_VERSION
            AND    A.CUTOFF_TYPE     = C_CUTOFF_TYPE
            AND    A.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
            AND    A.ITEM_ID NOT IN ( SELECT K.ITEM_ID FROM SCM_MST_ITEM_SN K
                                      WHERE K.DIVISION_ID = A.DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y' AND K.DIVISION_ID = '40' )
            /* [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. */
            AND    NOT EXISTS ( SELECT 1
                                FROM   GT_DPMFCQB_RTF_EXCEPTION_ITEM BB
                                WHERE  A.DIVISION_ID   = BB.DIVISION_ID
                                AND    A.PROJECT_CODE  = BB.PROJECT_CODE
                                AND    A.END_CUSTOMER  = BB.END_CUSTOMER
                                AND    A.SCM_SITE_ID   = BB.SCM_SITE_ID
                                AND    A.ITEM_ID       = BB.ITEM_ID
                                AND    A.DOM_EXP       = BB.DOM_EXP
                                AND    A.FCST_TYPE     = BB.FCST_TYPE
                                AND    A.INCOTERMS     = BB.INCOTERMS
                                AND    A.MEASURE       = BB.MEASURE
                                AND    A.PLANT_SITE_ID = BB.PLANT_SITE_ID
                                AND    NVL(A.CELL_PROD_SITE_ID, '-') = NVL(BB.CELL_PROD_SITE_ID, '-')
                                AND    A.YYYYMMDD     >= V_PLAN_START_YYYYMMDD   /*-- 당주월요일*/
                                AND    A.VERSION_NO    = P_CUT_OFF_VERSION );
        ELSE
            /* [E20260107-001287]_40 사업부 외의 다른 사업부는 원 로직과 동일하게 둔다. (START) */
            /* [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MF_C_EE_FN_MEASURE (정의된 MEASURE만 업데이트 함.) */
            DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
            WHERE  A.MEASURE IN ( SELECT MEASURE FROM GT_DPMFCQB_MEASURE_MF_ALL )
            AND    A.DIVISION_ID     = P_DIVISION_ID
            AND    A.VERSION_NO      = P_CUT_OFF_VERSION
            AND    A.CUTOFF_TYPE     = C_CUTOFF_TYPE
            AND    A.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
            /* [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. */
            AND    NOT EXISTS ( SELECT 1
                                FROM   GT_DPMFCQB_RTF_EXCEPTION_ITEM BB
                                WHERE  A.DIVISION_ID   = BB.DIVISION_ID
                                AND    A.PROJECT_CODE  = BB.PROJECT_CODE
                                AND    A.SCM_SITE_ID   = BB.SCM_SITE_ID
                                AND    A.ITEM_ID       = BB.ITEM_ID
                                AND    A.DOM_EXP       = BB.DOM_EXP
                                AND    A.FCST_TYPE     = BB.FCST_TYPE
                                AND    A.INCOTERMS     = BB.INCOTERMS
                                AND    A.MEASURE       = BB.MEASURE
                                AND    A.PLANT_SITE_ID = BB.PLANT_SITE_ID
                                AND    NVL(A.CELL_PROD_SITE_ID, '-') = NVL(BB.CELL_PROD_SITE_ID, '-')  /* [E20260512-000502] */
                                AND    A.YYYYMMDD     >= V_PLAN_START_YYYYMMDD   /*-- 당주월요일*/
                                AND    A.VERSION_NO    = P_CUT_OFF_VERSION );
        END IF;
        /* [E20260107-001287]_전극의 경우는 FCSTPRICE MGMT 화면에서 데이터를 저장한 데이터를 반영하기 때문에, 40사업부의 경우는 삭제하지 않도록 수정한다.(END) */

        /* [C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용 */
        DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
        WHERE  MEASURE IN ( 'RTF' )
        AND    DIVISION_ID     = P_DIVISION_ID
        AND    VERSION_NO      = P_CUT_OFF_VERSION
        AND    CUTOFF_TYPE     = C_CUTOFF_TYPE
        AND    CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
        AND    DIVISION_ID     = '82';

        /* [E20240508-000695] */
        DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        WHERE  A.MEASURE IN ( 'RTF' )
        AND    A.DIVISION_ID     = P_DIVISION_ID
        AND    A.VERSION_NO      = P_CUT_OFF_VERSION
        AND    A.CUTOFF_TYPE     = C_CUTOFF_TYPE
        AND    A.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
        AND    A.DIVISION_ID     = '81'
        AND    A.DIVISION_ID IN ( SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y' )
        AND    A.SCM_SITE_ID IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y' )
        /* [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. */
        AND    NOT EXISTS ( SELECT 1
                            FROM   GT_DPMFCQB_RTF_EXCEPTION_ITEM B
                            WHERE  A.DIVISION_ID   = B.DIVISION_ID
                            AND    A.PROJECT_CODE  = B.PROJECT_CODE
                            AND    A.END_CUSTOMER  = B.END_CUSTOMER
                            AND    A.SCM_SITE_ID   = B.SCM_SITE_ID
                            AND    A.ITEM_ID       = B.ITEM_ID
                            AND    A.DOM_EXP       = B.DOM_EXP
                            AND    A.FCST_TYPE     = B.FCST_TYPE
                            AND    A.INCOTERMS     = B.INCOTERMS
                            AND    A.MEASURE       = B.MEASURE
                            AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID
                            AND    NVL(A.CELL_PROD_SITE_ID, '-') = NVL(B.CELL_PROD_SITE_ID, '-')  /* [E20260512-000502] */
                            AND    A.YYYYMMDD     >= V_PLAN_START_YYYYMMDD   /*-- 당주월요일*/
                            AND    A.VERSION_NO    = P_CUT_OFF_VERSION );
        /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 (END) */

        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [PJ2025-50017] 속도개선을 이유로 임시테이블에 SCP_PLN_RTF_ALLOCATION_V를 담아서 사용함. */
        /* [PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_C_RTF_ALLOCATION 이름변경 */
        /* ---------------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_DPMFCQB_MF_C_RTF_ALLOCATION
        ( MASTER_ID, PLAN_ID, OUT_VERSION_ID, DIVISION_ID, ORIGIN_DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE
        , SEQ, OPERATION_GROUP, ENG_DEMAND_ID, ITEM_ID, PROJECT_CODE, SALES_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE
        , DEMAND_TYPE, DUE_DATE, PLANT_SITE_ID, YYYYMMDD, ALLOCATION_QTY
        , DELIVERY_ORDER_ID, FROM_SITE, FROM_ITEM_ID, SCP_INCOTERMS, FROM_SITE_ID, CELL_PROD_SITE_ID )  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
        SELECT MASTER_ID, PLAN_ID, OUT_VERSION_ID, DIVISION_ID, ORIGIN_DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE
             , SEQ, OPERATION_GROUP, ENG_DEMAND_ID, ITEM_ID, PROJECT_CODE, SALES_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE
             , DEMAND_TYPE, DUE_DATE, PLANT_SITE_ID, YYYYMMDD, ALLOCATION_QTY
             , DELIVERY_ORDER_ID, FROM_SITE, FROM_ITEM_ID, SCP_INCOTERMS, FROM_SITE_ID, CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
        FROM   SCP_PLN_RTF_ALLOCATION_V
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    PLAN_ID     = C_PLAN_ID
        AND    YYYYMMDD   >= V_PLAN_START_YYYYMMDD
        UNION ALL
        SELECT MASTER_ID, PLAN_ID, OUT_VERSION_ID, DIVISION_ID, ORIGIN_DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE
             , SEQ, OPERATION_GROUP, ENG_DEMAND_ID, ITEM_ID, PROJECT_CODE, SALES_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE
             , DEMAND_TYPE, DUE_DATE, PLANT_SITE_ID, YYYYMMDD, ALLOCATION_QTY
             , DELIVERY_ORDER_ID, FROM_SITE, FROM_ITEM_ID, SCP_INCOTERMS, FROM_SITE_ID, CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
        FROM   SCP_PLN_RTF_ALLOCATION_V
        WHERE  DIVISION_ID        = 'EE'
        AND    ORIGIN_DIVISION_ID = P_DIVISION_ID
        AND    PLAN_ID            = C_PLAN_ID_EE
        AND    YYYYMMDD          >= V_PLAN_START_YYYYMMDD;

        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) */
        /* ---------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_DPMFCQB_MF_C_RTF_ALLOCATION A
        WHERE  EXISTS ( SELECT 1
                        FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
                                    , NVL(CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
                               FROM   GT_DPMFCQB_RTF_EXCEPTION_ITEM
                               GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, NVL(CELL_PROD_SITE_ID, '-') ) B
                        WHERE  A.DIVISION_ID   = B.DIVISION_ID
                        AND    A.PROJECT_CODE  = B.PROJECT_CODE
                        AND    A.SALES_SITE_ID = B.SCM_SITE_ID
--                        AND    A.ITEM_ID       = B.ITEM_ID
                        AND    A.FROM_ITEM_ID  = B.ITEM_ID                  -- 2026.09.11 AJS
                        AND    A.DOM_EXP       = B.DOM_EXP
                        AND    A.FCST_TYPE     = B.FCST_TYPE
                        AND    A.INCOTERMS     = B.INCOTERMS
                        AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID
                        AND    NVL(A.CELL_PROD_SITE_ID, '-') = NVL(B.CELL_PROD_SITE_ID, '-') );  /* [E20260512-000502] 81도 해당 부분을 비교하도록 수정한다. */
        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) */
        /* ---------------------------------------------------------------------------------------------------------------- */

        INSERT INTO GT_DPMFCQB_MKT_FCST_INSERT
        ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        /* 20190709 KHSONG [CSR ID:4027463] 임시테이블에 넣고 MEASURE 추가할 용도임 */
        SELECT DISTINCT A.DIVISION_ID
             , P_CUT_OFF_VERSION   AS VERSION_NO
             , C_CUTOFF_TYPE       AS CUTOFF_TYPE
             , C_CUTOFF_YYYYMMDD   AS CUTOFF_YYYYMMDD
             , A.PROJECT_CODE
             , A.SALES_SITE_ID     AS SCM_SITE_ID
             , CASE WHEN A.FROM_ITEM_ID IS NULL  /*--20240610 KCW3408 */ THEN A.ITEM_ID ELSE A.FROM_ITEM_ID END AS ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ( '82', '40' ) THEN 'VMI_In_Plan'
                    WHEN C.OPERATION_GROUP = 'W'                            THEN 'AS_In_Plan'
                    ELSE 'RTF_SCP'  END AS MEASURE  /* [CSR ID:4059971] 20190809 KHSONG ESS사업부 추가 */
             , CASE WHEN A.DIVISION_ID IN ( '82', '40' ) THEN ' ' ELSE A.PLANT_SITE_ID END AS PLANT_SITE_ID
             , A.YYYYMMDD
             , SUM(A.ALLOCATION_QTY)  AS QTY
             , 'SYSTEM'   AS CREATED_BY
             , SYSDATE    AS CREATION_DATE
             , 'SYSTEM'   AS LAST_UPDATED_BY
             , SYSDATE    AS LAST_UPDATE_DATE
        /* [PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_C_RTF_ALLOCATION 이름변경 */
        FROM   GT_DPMFCQB_MF_C_RTF_ALLOCATION A
        INNER JOIN SCM_MST_SITE C
                ON A.DIVISION_ID   = C.DIVISION_ID
               AND A.SALES_SITE_ID = C.SCM_SITE_ID
        WHERE  A.DIVISION_ID = P_DIVISION_ID
        AND    A.PLAN_ID     = C_PLAN_ID
        AND    A.YYYYMMDD   >= V_PLAN_START_YYYYMMDD
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SALES_SITE_ID, CASE WHEN A.FROM_ITEM_ID IS NULL THEN A.ITEM_ID ELSE A.FROM_ITEM_ID END
               , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, CASE WHEN A.DIVISION_ID IN ('82','40') THEN ' ' ELSE A.PLANT_SITE_ID END, A.YYYYMMDD, C.VMI_YN, C.OPERATION_GROUP
        /* 상품인 건에 대해서는 RTF를 MKT FCST와 동일하게 생성 함. */
        /* [C20210511-000221] 자동자 전극 RTF 적용 (자동차 전극 RTF 적용)(START) */
        UNION ALL
        SELECT DISTINCT A.ORIGIN_DIVISION_ID AS DIVISION_ID
             , P_CUT_OFF_VERSION   AS VERSION_NO
             , C_CUTOFF_TYPE       AS CUTOFF_TYPE
             , C_CUTOFF_YYYYMMDD   AS CUTOFF_YYYYMMDD
             , A.PROJECT_CODE
             , A.SALES_SITE_ID     AS SCM_SITE_ID
             , CASE WHEN A.FROM_ITEM_ID IS NULL /* --20240610 KCW3408*/ THEN A.ITEM_ID ELSE A.FROM_ITEM_ID END AS ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ( '82', '40' ) THEN 'VMI_In_Plan'
                    WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
                    ELSE 'RTF_SCP'  END AS MEASURE  /* [CSR ID:4059971] 20190809 KHSONG ESS사업부 추가 */
             , CASE WHEN A.ORIGIN_DIVISION_ID IN ( '82', '40' ) THEN ' ' ELSE A.PLANT_SITE_ID END AS PLANT_SITE_ID
             , A.YYYYMMDD
             , SUM(A.ALLOCATION_QTY)  AS QTY
             , 'SYSTEM'   AS CREATED_BY
             , SYSDATE    AS CREATION_DATE
             , 'SYSTEM'   AS LAST_UPDATED_BY
             , SYSDATE    AS LAST_UPDATE_DATE
        FROM   GT_DPMFCQB_MF_C_RTF_ALLOCATION A
        INNER JOIN SCM_MST_SITE C
                ON A.ORIGIN_DIVISION_ID = C.DIVISION_ID
               AND A.SALES_SITE_ID      = C.SCM_SITE_ID
        WHERE  A.DIVISION_ID        = 'EE'
        AND    A.ORIGIN_DIVISION_ID = P_DIVISION_ID
        AND    A.PLAN_ID            = C_PLAN_ID_EE
        AND    A.YYYYMMDD          >= V_PLAN_START_YYYYMMDD
        GROUP BY A.ORIGIN_DIVISION_ID, A.PROJECT_CODE, A.SALES_SITE_ID, CASE WHEN A.FROM_ITEM_ID IS NULL THEN A.ITEM_ID ELSE A.FROM_ITEM_ID END
               , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, CASE WHEN A.ORIGIN_DIVISION_ID IN ( '82', '40' ) THEN ' ' ELSE A.PLANT_SITE_ID END  /* [PJ2024-50611] 전극데이터 생성 시 ORIGIN_DIVISION_ID in ('82','40') 변경 */
               , A.YYYYMMDD, C.VMI_YN, C.OPERATION_GROUP, A.DIVISION_ID
        /* [C20210511-000221] 자동자 전극 RTF 적용 (END) */
        UNION ALL
        SELECT A.DIVISION_ID
             , A.VERSION_NO
             , A.CUTOFF_TYPE
             , A.CUTOFF_YYYYMMDD
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ( '82', '40' ) THEN 'VMI_In_Plan'
                    WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
                    ELSE 'RTF_SCP' END  /* [CSR ID:4059971] 20190809 KHSONG ESS사업부 추가 */
             , A.PLANT_SITE_ID
             , A.YYYYMMDD
             , SUM(A.QTY)  AS QTY
             , 'SYSTEM'    AS CREATED_BY
             , SYSDATE     AS CREATION_DATE
             , 'SYSTEM'    AS LAST_UPDATED_BY
             , SYSDATE     AS LAST_UPDATE_DATE
        FROM   DM_PLN_MKT_FCST_C A
        INNER JOIN DM_MST_ITEM_SINGLE_V B
                ON A.DIVISION_ID = B.DIVISION_ID
               AND A.ITEM_ID     = B.ITEM_ID
        INNER JOIN SCM_MST_SITE C
                ON A.DIVISION_ID = C.DIVISION_ID
               AND A.SCM_SITE_ID = C.SCM_SITE_ID
        WHERE  1 = 1
        AND    A.DIVISION_ID     = P_DIVISION_ID
        AND    A.VERSION_NO      = P_CUT_OFF_VERSION
        AND    A.CUTOFF_TYPE     = C_CUTOFF_TYPE
        AND    A.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
        AND    A.MEASURE         = CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ( '82', '40' ) THEN 'VMI_In_Req'
                                        WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                        ELSE V_MEASURE  END  /* [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST) */
        /* 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 */
        AND    ( B.ITEM_TYPE IN ( 'Q' , 'R' ) ) /*OR ( a.item_id in ( select k.item_id from scm_mst_item_sn k where k.division_id = a.division_id and k.SCP_OPERATION_GROUP = 'E'  )  )*/
        GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
               , CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ('82','40') THEN 'VMI_In_Plan'
                      WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
                      ELSE 'RTF_SCP'  END  /* [CSR ID:4059971] 20190809 KHSONG ESS사업부 추가 */
               , A.PLANT_SITE_ID, A.YYYYMMDD
        UNION ALL
        /* RMA 처리 C20200518-000359 (START) */
        SELECT A.DIVISION_ID
             , A.VERSION_NO
             , A.CUTOFF_TYPE
             , A.CUTOFF_YYYYMMDD
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'RTF_SCP'
             , A.PLANT_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , 'SYSTEM'  AS CREATED_BY
             , SYSDATE   AS CREATION_DATE
             , 'SYSTEM'  AS LAST_UPDATED_BY
             , SYSDATE   AS LAST_UPDATE_DATE
        FROM   DM_PLN_MKT_FCST_C A
        WHERE  1 = 1
        AND    A.DIVISION_ID     = P_DIVISION_ID
        AND    A.VERSION_NO      = P_CUT_OFF_VERSION
        AND    A.CUTOFF_TYPE     = C_CUTOFF_TYPE
        AND    A.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
        AND    A.MEASURE         = V_MEASURE  /* [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST) */
        AND    A.FCST_TYPE = 'RMA';
        /* RMA 처리 C20200518-000359 (END) */

        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) */
        /* ---------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_DPMFCQB_MKT_FCST_INSERT A
        WHERE  EXISTS ( SELECT 1
                        FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
                               FROM   GT_DPMFCQB_RTF_EXCEPTION_ITEM
                               GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID ) B
                        WHERE  A.DIVISION_ID   = B.DIVISION_ID
                        AND    A.PROJECT_CODE  = B.PROJECT_CODE
                        AND    A.SCM_SITE_ID   = B.SCM_SITE_ID
                        AND    A.ITEM_ID       = B.ITEM_ID
                        AND    A.DOM_EXP       = B.DOM_EXP
                        AND    A.FCST_TYPE     = B.FCST_TYPE
                        AND    A.INCOTERMS     = B.INCOTERMS
                        AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID );
        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) */
        /* ---------------------------------------------------------------------------------------------------------------- */
        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 (START) */
        /* ---------------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_DPMFCQB_CFM_DEMAND_INSERT
        ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, FROM_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        /* 20190709 KHSONG [CSR ID:4027463] 임시테이블에 넣고 MEASURE 추가할 용도임 */
        SELECT DISTINCT A.DIVISION_ID
             , P_CUT_OFF_VERSION   AS VERSION_NO
             , C_CUTOFF_TYPE       AS CUTOFF_TYPE
             , C_CUTOFF_YYYYMMDD   AS CUTOFF_YYYYMMDD
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
             , MAX(A.FROM_SITE_ID)     AS FROM_SITE_ID  /* [PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성) */
             , A.YYYYMMDD
             , SUM(A.QTY)              AS QTY
             , 'SYSTEM'   AS CREATED_BY
             , SYSDATE    AS CREATION_DATE
             , 'SYSTEM'   AS LAST_UPDATED_BY
             , SYSDATE    AS LAST_UPDATE_DATE
        FROM ( SELECT DISTINCT A.DIVISION_ID
                    , A.PROJECT_CODE
                    , A.SALES_SITE_ID AS SCM_SITE_ID
                    , CASE WHEN A.FROM_ITEM_ID IS NULL /*--20240610 KCW3408 */ THEN A.ITEM_ID ELSE A.FROM_ITEM_ID END AS ITEM_ID
                    , A.DOM_EXP
                    , A.FCST_TYPE
                    , A.INCOTERMS
                    , CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ( '82', '40' ) THEN 'VMI_In_Plan'
                           WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
                           ELSE 'RTF_SCP'  END AS MEASURE  /* [CSR ID:4059971] 20190809 KHSONG ESS사업부 추가 */
                    , CASE WHEN A.DIVISION_ID IN ('82','40') THEN ' ' ELSE A.PLANT_SITE_ID END AS PLANT_SITE_ID
                    , NVL(A.CELL_PROD_SITE_ID, '-')  AS CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                    , CASE WHEN ( A.DIVISION_ID IN ('40') AND NVL(A.CELL_PROD_SITE_ID, '-') = '-' ) THEN A.FROM_SITE_ID ELSE NVL(A.CELL_PROD_SITE_ID, '-') END AS FROM_SITE_ID  /* [PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 */
                    , A.YYYYMMDD
                    , SUM(A.ALLOCATION_QTY) AS QTY
               FROM   GT_DPMFCQB_MF_C_RTF_ALLOCATION A
               INNER JOIN SCM_MST_SITE C
                       ON A.DIVISION_ID   = C.DIVISION_ID
                      AND A.SALES_SITE_ID = C.SCM_SITE_ID
               WHERE  A.DIVISION_ID = P_DIVISION_ID
               AND    A.PLAN_ID     = C_PLAN_ID
               AND    A.YYYYMMDD   >= V_PLAN_START_YYYYMMDD
               GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SALES_SITE_ID, CASE WHEN A.FROM_ITEM_ID IS NULL THEN A.ITEM_ID ELSE A.FROM_ITEM_ID END
                      , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, CASE WHEN A.DIVISION_ID IN ( '82', '40' ) THEN ' ' ELSE A.PLANT_SITE_ID END
                      , NVL(A.FROM_SITE_ID, ' ')  /* [PJ2024-50611] SCP FROM_SITE_ID 추가 */
                      , A.YYYYMMDD, C.VMI_YN, C.OPERATION_GROUP, NVL(A.CELL_PROD_SITE_ID, '-') /*--[PJ2025-50017] CELL_PROD_SITE_ID 추가*/, A.FROM_SITE_ID ) A
        /* 상품인 건에 대해서는 RTF를 MKT FCST와 동일하게 생성 함. */
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
        /* [C20210511-000221] 자동자 전극 RTF 적용 (자동차 전극 RTF 적용) (START) */
        UNION ALL
        SELECT DISTINCT A.ORIGIN_DIVISION_ID  AS DIVISION_ID
             , P_CUT_OFF_VERSION   AS VERSION_NO
             , C_CUTOFF_TYPE       AS CUTOFF_TYPE
             , C_CUTOFF_YYYYMMDD   AS CUTOFF_YYYYMMDD
             , A.PROJECT_CODE
             , A.SALES_SITE_ID AS SCM_SITE_ID
             , CASE WHEN A.FROM_ITEM_ID IS NULL /*--20240610 KCW3408 */ THEN A.ITEM_ID ELSE A.FROM_ITEM_ID END AS ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ( '82', '40' ) THEN 'VMI_In_Plan'
                    WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
                    ELSE 'RTF_SCP'  END AS MEASURE  /* [CSR ID:4059971] 20190809 KHSONG ESS사업부 추가 */
             , CASE WHEN A.ORIGIN_DIVISION_ID IN ( '82', '40' ) THEN ' ' ELSE A.PLANT_SITE_ID END AS PLANT_SITE_ID
             , NVL(A.CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
             , CASE WHEN ( A.ORIGIN_DIVISION_ID IN ('40') AND NVL(A.CELL_PROD_SITE_ID, '-') = '-' ) THEN A.FROM_SITE_ID ELSE NVL(A.CELL_PROD_SITE_ID, '-') END AS FROM_SITE_ID  /* [PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 */
             , A.YYYYMMDD
             , SUM(A.ALLOCATION_QTY)  AS QTY
             , 'SYSTEM'   AS CREATED_BY
             , SYSDATE    AS CREATION_DATE
             , 'SYSTEM'   AS LAST_UPDATED_BY
             , SYSDATE    AS LAST_UPDATE_DATE
        FROM   GT_DPMFCQB_MF_C_RTF_ALLOCATION A
        INNER JOIN SCM_MST_SITE C
                ON A.ORIGIN_DIVISION_ID = C.DIVISION_ID
               AND A.SALES_SITE_ID      = C.SCM_SITE_ID
        WHERE  A.DIVISION_ID = 'EE'
        AND    A.ORIGIN_DIVISION_ID = P_DIVISION_ID
        AND    A.PLAN_ID            = C_PLAN_ID_EE
        AND    A.YYYYMMDD          >= V_PLAN_START_YYYYMMDD
        GROUP BY A.ORIGIN_DIVISION_ID, A.PROJECT_CODE, A.SALES_SITE_ID, CASE WHEN A.FROM_ITEM_ID IS NULL THEN A.ITEM_ID ELSE A.FROM_ITEM_ID END
               , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, CASE WHEN A.ORIGIN_DIVISION_ID IN ('82','40') THEN ' ' ELSE A.PLANT_SITE_ID END  /* [PJ2024-50611] 전극데이터 생성 시 ORIGIN_DIVISION_ID in ('82','40') 변경 */
               , NVL(A.CELL_PROD_SITE_ID, '-') /*--[PJ2025-50017] CELL_PROD_SITE_ID 추가*/, A.FROM_SITE_ID, A.YYYYMMDD, C.VMI_YN, C.OPERATION_GROUP, A.DIVISION_ID
        /* [C20210511-000221] 자동자 전극 RTF 적용 (자동차 전극 RTF 적용) (END) */
        UNION ALL
        SELECT A.DIVISION_ID
             , A.VERSION_NO
             , A.CUTOFF_TYPE
             , A.CUTOFF_YYYYMMDD
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ('82','40') THEN 'VMI_In_Plan'
                    WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
                    ELSE 'RTF_SCP' END  /* [CSR ID:4059971] 20190809 KHSONG ESS사업부 추가 */
             , A.PLANT_SITE_ID
             , '-'                    AS CELL_PROD_SITE_ID  /* [PJ2025-50017] ITEM_TYPE IN (Q,R)의 경우 DM_PLN_MKT_FCST_C에서 데이터 수집 */
             , MAX(A.ATTRIBUTE2)      AS FROM_SITE_ID  /* [PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 */
             , A.YYYYMMDD
             , SUM(A.QTY)             AS QTY
             , 'SYSTEM'   AS CREATED_BY
             , SYSDATE    AS CREATION_DATE
             , 'SYSTEM'   AS LAST_UPDATED_BY
             , SYSDATE    AS LAST_UPDATE_DATE
             /* 2025.06.24 종합적으로 점검결과 CELL_PROD_SITE_ID는 '-'로 통일할 수 있음. ==> DM_PLN_MKT_FCST_C로 사용하기로 결정함. ITEM_TYPE IN (Q,R)의 경우 DM_PLN_MKT_FCST_C에서 데이터 수집*/
        FROM   DM_PLN_MKT_FCST_C A
        INNER JOIN DM_MST_ITEM_SINGLE_V B
                ON A.DIVISION_ID = B.DIVISION_ID
               AND A.ITEM_ID     = B.ITEM_ID
        INNER JOIN SCM_MST_SITE C
                ON A.DIVISION_ID = C.DIVISION_ID
               AND A.SCM_SITE_ID = C.SCM_SITE_ID
        WHERE  1 = 1
        AND    A.DIVISION_ID     = P_DIVISION_ID
        AND    A.VERSION_NO      = P_CUT_OFF_VERSION
        AND    A.CUTOFF_TYPE     = C_CUTOFF_TYPE
        AND    A.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
        AND    A.MEASURE         = CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ( '82', '40' ) THEN 'VMI_In_Req'
                                        WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                        ELSE V_MEASURE END  /* [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST) */
        AND    ( B.ITEM_TYPE IN ( 'Q' , 'R' ) )
        GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
               , CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ('82','40') THEN 'VMI_In_Plan'
                      WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
                      ELSE 'RTF_SCP'  END  /* [CSR ID:4059971] 20190809 KHSONG ESS사업부 추가 */
               , A.PLANT_SITE_ID, A.YYYYMMDD
        UNION ALL
        /* RMA 처리 C20200518-000359 */
        SELECT A.DIVISION_ID
             , A.VERSION_NO
             , A.CUTOFF_TYPE
             , A.CUTOFF_YYYYMMDD
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'RTF_SCP'
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID  /* [PJ2025-50017] SCP CELL_PROD_SITE_ID 추가 */
             , MAX(A.ATTRIBUTE2)      AS FROM_SITE_ID  /* [PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 */
             , A.YYYYMMDD
             , SUM(A.QTY)             AS QTY
             , 'SYSTEM'   AS CREATED_BY
             , SYSDATE    AS CREATION_DATE
             , 'SYSTEM'   AS LAST_UPDATED_BY
             , SYSDATE    AS LAST_UPDATE_DATE
        FROM   DM_PLN_CFM_MKT_DEMAND_PLAN_C A  /* [PJ2025-50017] 40사업부는 DM_PLN_MKT_FCST_C ==> DM_PLN_CFM_MKT_DEMAND_PLAN_C 적용 */
        WHERE  1 = 1
        AND    A.DIVISION_ID     = P_DIVISION_ID
        AND    A.VERSION_NO      = P_CUT_OFF_VERSION
        AND    A.CUTOFF_TYPE     = C_CUTOFF_TYPE
        AND    A.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
        AND    A.MEASURE         = V_MEASURE  /* [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST) */
        AND    A.FCST_TYPE = 'RMA'
        GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
               , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID /*--[PJ2025-50017] SCP CELL_PROD_SITE_ID 추가*/, A.YYYYMMDD;
        /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 (END) */

        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) */
        /* ---------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_DPMFCQB_CFM_DEMAND_INSERT A
        WHERE  EXISTS ( SELECT 1
                        FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
                                    , NVL(CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
                               FROM   GT_DPMFCQB_RTF_EXCEPTION_ITEM
                               GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, NVL(CELL_PROD_SITE_ID, '-') ) B
                        WHERE  A.DIVISION_ID   = B.DIVISION_ID
                        AND    A.PROJECT_CODE  = B.PROJECT_CODE
                        AND    A.SCM_SITE_ID   = B.SCM_SITE_ID
                        AND    A.ITEM_ID       = B.ITEM_ID
                        AND    A.DOM_EXP       = B.DOM_EXP
                        AND    A.FCST_TYPE     = B.FCST_TYPE
                        AND    A.INCOTERMS     = B.INCOTERMS
                        AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID
                        AND    NVL(A.CELL_PROD_SITE_ID, '-') = NVL(B.CELL_PROD_SITE_ID, '-') );  /* [E20260512-000502] 81도 해당 부분을 비교하도록 수정한다. */
        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) */
        /* ---------------------------------------------------------------------------------------------------------------- */

        /* [C20210323-000456] ESS 판매법인의 VMI_IN_PLAN 에 대해서 5영업일 뒤로 미뤄줌 */
        /* [변환주의] 원본 UPDATE ... FROM #T2_MKT_FCST_INSERT A JOIN (lookup) B ON A.SCM_SITE_ID=B.SCM_SITE_ID (lookup 유일성 미보장, 다중매칭시 원본 비결정적) */
        /* -> MERGE + GROUP BY SCM_SITE_ID(MAX(LT_CNT)) 로 결정적 처리. */
        /* TRY_CAST(SEGMENT2 AS INT)>0 -> CAST(SEGMENT2 AS NUMBER DEFAULT NULL ON CONVERSION ERROR)>0. */
        /* FN_GET_BIZ_DAY(P_CUR_DATE CHAR, P_DAY_CNT NUMBER) RETURN VARCHAR2(시그니처 실측) : 원본대로 YYYYMMDD 문자열을 직접 전달/반환(DATE 래핑 불요). */
        MERGE INTO GT_DPMFCQB_MKT_FCST_INSERT A
        USING ( SELECT SEGMENT1 AS SCM_SITE_ID, MAX(SEGMENT2) AS LT_CNT
                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE  LOOKUP_TYPE = 'ESS_SALES_PLANT_LT'
                AND    VALID_YN    = 'Y'
                AND    CAST(SEGMENT2 AS NUMBER DEFAULT NULL ON CONVERSION ERROR) > 0
                GROUP BY SEGMENT1 ) B
        ON    ( A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = '82' AND A.MEASURE = 'VMI_In_Plan' )
        WHEN MATCHED THEN
            UPDATE SET A.YYYYMMDD = FN_GET_BIZ_DAY(A.YYYYMMDD, TO_NUMBER(B.LT_CNT));

        /* ---------------------------------------------------------------------------------------------------------------- */
        /* SAFETY STOCK LEVEL, GAP 메저 처리 */
        /* ---------------------------------------------------------------------------------------------------------------- */
        IF P_DIVISION_ID LIKE '81%' THEN
            /* TO_SITE, ITEM_ID 기준으로 정렬한다. */
            INSERT INTO GT_DPMFCQB_SSLVL ( DIVISION_ID, SCM_SITE_ID, ITEM_ID, PROJECT_CODE, INCOTERMS, PLANT_SITE_ID, DOM_EXP )
            SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.PROJECT_CODE, A.INCOTERMS, A.PLANT_SITE_ID, A.DOM_EXP
            FROM ( SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.PROJECT_CODE, A.INCOTERMS, A.PLANT_SITE_ID, A.DOM_EXP
                        , ROW_NUMBER() OVER ( PARTITION BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID
                                              ORDER BY A.PROJECT_CODE, A.INCOTERMS, A.PLANT_SITE_ID, A.DOM_EXP ) AS ROW_NUM
                   FROM ( SELECT DISTINCT A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.PROJECT_CODE, A.INCOTERMS, A.PLANT_SITE_ID, A.DOM_EXP
                          FROM   DM_PLN_MKT_FCST_C A
                          WHERE  A.YYYYMMDD >= V_PLAN_START_YYYYMMDD
                          AND    A.MEASURE IN ( V_MEASURE, 'RTF_SYS_RP', 'VMI_IN_REQ', 'AS_IN_REQ', 'BNP_IN' )  /* [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST) */
                          AND    A.DIVISION_ID = P_DIVISION_ID
                          AND    A.VERSION_NO  = P_CUT_OFF_VERSION ) A
                 ) A
            WHERE ROW_NUM = 1;

            SELECT MAX(SEQ) INTO V_STOCK_SEQ
            FROM   SCP_ANL_PSI_GLOBAL_V
            WHERE  DIVISION_ID        = P_DIVISION_ID
            AND    PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
            AND    PLAN_TYPE          = 'FN';

            INSERT INTO GT_DPMFCQB_MKT_FCST_INSERT
            ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
            , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
            , QTY
            , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
            SELECT A.DIVISION_ID, P_CUT_OFF_VERSION AS VERSION_NO, C_CUTOFF_TYPE AS CUTOFF_TYPE, C_CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
                 , A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, 'MPS' AS FCST_TYPE, A.INCOTERMS, C.MEASURE, A.PLANT_SITE_ID, B.YYYYMMDD
                 , CASE WHEN C.MEASURE = 'SS_LVL' THEN B.SAFETY_STOCK ELSE B.GAP END AS QTY
                 , 'SYSTEM' AS CREATED_BY, SYSDATE AS CREATION_DATE, 'SYSTEM' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
            FROM   GT_DPMFCQB_SSLVL A
            JOIN   SCP_ANL_PSI_GLOBAL_V B
              ON   A.DIVISION_ID       = B.DIVISION_ID
             AND   A.SCM_SITE_ID       = B.TO_SITE
             AND   A.ITEM_ID           = B.ITEM_ID
             AND   B.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
             AND   B.PLAN_TYPE         = 'FN'
             AND   B.SEQ               = V_STOCK_SEQ
            JOIN ( SELECT 'SS_LVL' AS MEASURE FROM DUAL
                   UNION ALL
                   SELECT 'SS_GAP' AS MEASURE FROM DUAL ) C ON 1 = 1
            WHERE A.DIVISION_ID = P_DIVISION_ID;
        END IF;

        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) */
        /* ---------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_DPMFCQB_MKT_FCST_INSERT A
        WHERE  EXISTS ( SELECT 1
                        FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
                               FROM   GT_DPMFCQB_RTF_EXCEPTION_ITEM
                               GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID ) B
                        WHERE  A.DIVISION_ID   = B.DIVISION_ID
                        AND    A.PROJECT_CODE  = B.PROJECT_CODE
                        AND    A.SCM_SITE_ID   = B.SCM_SITE_ID
                        AND    A.ITEM_ID       = B.ITEM_ID
                        AND    A.DOM_EXP       = B.DOM_EXP
                        AND    A.FCST_TYPE     = B.FCST_TYPE
                        AND    A.INCOTERMS     = B.INCOTERMS
                        AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID );
        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) */
        /* ---------------------------------------------------------------------------------------------------------------- */

        IF ( P_DIVISION_ID = '40' AND C_EE_FN_FLAG = 'Y' ) THEN
            /* [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_VMI_RTF - NOT IN 구문에서 사용 */
            INSERT INTO GT_DPMFCQB_MEASURE_VMI_RTF ( MEASURE )
            SELECT 'VMI_In_Plan' FROM DUAL UNION ALL
            SELECT 'AS_In_Plan'  FROM DUAL UNION ALL
            SELECT 'RTF'         FROM DUAL UNION ALL
            SELECT 'RTF_SCP'     FROM DUAL UNION ALL
            SELECT 'RTF_SYS_RP'  FROM DUAL;
            /* [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_RTF - 생성할 RTF 시리즈 정의 */
            INSERT INTO GT_DPMFCQB_MEASURE_RTF ( MEASURE )
            SELECT 'RTF_PR' FROM DUAL;  /* [PJ2025-50188] 'RTF_PR'만 생성함. */
        ELSE
            /* [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_VMI_RTF - NOT IN 구문에서 사용 */
            INSERT INTO GT_DPMFCQB_MEASURE_VMI_RTF ( MEASURE )
            SELECT 'VMI_In_Plan' FROM DUAL UNION ALL
            SELECT 'AS_In_Plan'  FROM DUAL;
            /* [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_RTF - 생성할 RTF 시리즈 정의 */
            INSERT INTO GT_DPMFCQB_MEASURE_RTF ( MEASURE )
            SELECT 'RTF_PR'     FROM DUAL UNION ALL
            SELECT 'RTF_SYS_RP' FROM DUAL;  /* [PJ2025-50188] 'RTF_SYS_RP'까지 포함. */
        END IF;

        /*  -- [PJ2025-50188] #T_MEASURE_VMI_RTF 참고
             . EE_FN 인 경우   ('VMI_In_Plan', 'AS_In_Plan', 'RTF', 'RTF_SCP', 'RTF_SYS_RP')
             . EE_FN 아닌 경우 ('VMI_In_Plan', 'AS_In_Plan') */
        /*  -- [PJ2025-50188] ##T_MEASURE_RTF 참고
             . EE_FN 인 경우   ('RTF')
             . EE_FN 아닌 경우 ('RTF', 'RTF_SYS_RP') */
        INSERT INTO DM_PLN_MKT_FCST_C
        ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
             , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        FROM   GT_DPMFCQB_MKT_FCST_INSERT
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    MEASURE NOT IN ( SELECT MEASURE FROM GT_DPMFCQB_MEASURE_VMI_RTF )  /* [PJ2025-50188] EE_FN 분기 로직 통합처리 */
        UNION ALL
        SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
             , MEASURE, PLANT_SITE_ID, YYYYMMDD, SUM(QTY) AS QTY, MAX(CREATED_BY) AS CREATED_BY, MAX(CREATION_DATE) AS CREATION_DATE
             , MAX(LAST_UPDATED_BY) AS LAST_UPDATED_BY, MAX(LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
        FROM   GT_DPMFCQB_MKT_FCST_INSERT
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    MEASURE IN ('VMI_In_Plan', 'AS_In_Plan')
        GROUP BY DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
               , MEASURE, PLANT_SITE_ID, YYYYMMDD
        UNION ALL
        SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.MEASURE /*-- [PJ2025-50188] EE_FN 분기 로직 통합처리. #T_MEASURE_RTF 에서 정의된 모든 MEASURE 생성*/
             , A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY, A.CREATED_BY, A.CREATION_DATE
             , A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
        FROM   GT_DPMFCQB_MKT_FCST_INSERT A
        INNER JOIN ( SELECT MEASURE FROM GT_DPMFCQB_MEASURE_RTF ) B
                ON 1 = 1  /* [PJ2025-50188] EE_FN 분기 로직 통합처리. #T_MEASURE_RTF 에서 정의된 MEASURE 전체를 동일하게 생성하기 위함. */
        WHERE  A.MEASURE     = 'RTF_SCP'  /* 20190709 KHSONG [CSR ID:4027463] MEASURE 추가 INSERT */
        AND    A.DIVISION_ID = P_DIVISION_ID
        UNION ALL  /* [C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용 */
        SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
             , 'RTF' AS MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
             , LAST_UPDATED_BY, LAST_UPDATE_DATE
        FROM   GT_DPMFCQB_MKT_FCST_INSERT
        WHERE  MEASURE = 'RTF_SCP'
        AND    DIVISION_ID = P_DIVISION_ID
        AND    DIVISION_ID = '82';

        INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
        ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
        , END_CUSTOMER
        , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE
        , PLANT_SITE_ID, CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
        , ATTRIBUTE2 /*--[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)*/
        , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
             , CASE WHEN DIVISION_ID = '40' THEN PROJECT_CODE ELSE '' END AS END_CUSTOMER
             , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
             , MEASURE
             , PLANT_SITE_ID, CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
             , CASE WHEN DIVISION_ID = '40' THEN FROM_SITE_ID ELSE NULL END AS ATTRIBUTE2  /* [PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 */
             , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        FROM   GT_DPMFCQB_CFM_DEMAND_INSERT
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    MEASURE NOT IN ( SELECT MEASURE FROM GT_DPMFCQB_MEASURE_VMI_RTF )  /* [PJ2025-50188] EE_FN 분기 로직 통합처리 */
        UNION ALL
        SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
             , CASE WHEN DIVISION_ID = '40' THEN PROJECT_CODE ELSE '' END AS END_CUSTOMER
             , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
             , MEASURE
             , PLANT_SITE_ID, CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
             , CASE WHEN DIVISION_ID = '40' THEN MAX(FROM_SITE_ID) ELSE NULL END AS ATTRIBUTE2  /* [PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 */
             , YYYYMMDD, SUM(QTY) AS QTY, MAX(CREATED_BY), MAX(CREATION_DATE), MAX(LAST_UPDATED_BY), MAX(LAST_UPDATE_DATE)
        FROM   GT_DPMFCQB_CFM_DEMAND_INSERT
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    MEASURE IN ('VMI_In_Plan', 'AS_In_Plan')
        GROUP BY DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
               , CELL_PROD_SITE_ID /*--[PJ2025-50017] CELL_PROD_SITE_ID 추가*/, YYYYMMDD
        UNION ALL
        SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE
             , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE '' END AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.MEASURE  /* [PJ2025-50188] EE_FN 분기 로직 통합처리. #T_MEASURE_RTF 에서 정의된 모든 MEASURE 생성 */
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
             , CASE WHEN A.DIVISION_ID = '40' THEN A.FROM_SITE_ID ELSE NULL END AS ATTRIBUTE2  /* [PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 */
             , A.YYYYMMDD, A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
        FROM   GT_DPMFCQB_CFM_DEMAND_INSERT A
        INNER JOIN ( SELECT MEASURE FROM GT_DPMFCQB_MEASURE_RTF ) B
                ON 1 = 1  /* [PJ2025-50188] EE_FN 분기 로직 통합처리. #T_MEASURE_RTF 에서 정의된 MEASURE 전체를 동일하게 생성하기 위함. */
        WHERE  A.MEASURE     = 'RTF_SCP'
        AND    A.DIVISION_ID = P_DIVISION_ID;
        /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 (END) */

        /* ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
        --PRINT N'로직적용-E20240508-000695';
        [E20240508-000695] Corvus/Siemens사 자동차사업부 RTF 산출 시 동기화 반영 요청
        ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ */
        IF ( P_DIVISION_ID = '81' ) THEN  /* 20240530: MKT_FCST.DIVISION_ID = 82번 RTF바라보고 처리 */

            INSERT INTO GT_DPMFCQB_T9_RTF_AFTER_INS
            ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
            , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
            WITH TEMP_MKT_PLANT_ID_81_MAX_DATE AS
            ( /* 81번만 PLAN_SITE_ID 정보를 사용하고있으므로 DP일자 구간의 MAX(PLAN_ID)사용하기위해 처리 */
              SELECT T1.*
              FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
                          , ROW_NUMBER() OVER( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD DESC) AS RN
                     FROM DM_PLN_MKT_FCST
                     WHERE DIVISION_ID = '81'
                       AND MEASURE     = V_MEASURE  /* [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST) */
                       AND SCM_SITE_ID IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                       AND YYYYMMDD   >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')  /*--계획구간에서 정보 추출 */ ) T1
              WHERE 1 = 1
              AND RN = 1 /* 계획구간 MKT FCST DP입력 대상 MAX(PLANT_ID) 추출 */ )
            , TEMP_MKT_PLANT_ID_81 AS
            ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
              FROM DM_PLN_MKT_FCST
              WHERE DIVISION_ID = '81'
                AND MEASURE     = V_MEASURE  /* [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST) */
                AND SCM_SITE_ID IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND YYYYMMDD   >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')  /* 계획구간에서 정보 추출 */
              GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID )
            , TEMP_RTF_DATA_82 AS (
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                     , F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID, F.YYYYMMDD, F.QTY
                FROM   DM_PLN_MKT_FCST F
                INNER JOIN SCM_MST_SITE_ITEM T2  /* 20230410 JHS [E20230403-000148] */
                ON  F.DIVISION_ID  = T2.DIVISION_ID
                AND F.PROJECT_CODE = T2.PROJECT_CODE
                AND F.SCM_SITE_ID  = T2.SCM_SITE_ID
                AND F.ITEM_ID      = T2.ITEM_ID
                WHERE F.DIVISION_ID  = '82'
                AND   F.YYYYMMDD    >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                AND   F.MEASURE      = 'RTF_SYS_RP'
                AND   F.SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
            )
            , FINAL_DATA AS (
                SELECT /* 81번정보사용 */ B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PLANT_SITE_ID
                     , /* 82번정보사용 */ A.MEASURE, A.YYYYMMDD, A.QTY
                     , CASE WHEN A.YYYYMMDD <= SUBSTR(B.MAX_YYYYMMDD,1,6) || '31'  THEN 'Y' ELSE 'N' END AS GUBUN
                FROM TEMP_RTF_DATA_82 A
                LEFT OUTER JOIN (
                                    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
                                        ,  B.YYYYMMDD AS MAX_YYYYMMDD
                                    FROM TEMP_MKT_PLANT_ID_81 A
                                    INNER JOIN TEMP_MKT_PLANT_ID_81_MAX_DATE B
                                    ON  A.DIVISION_ID   = B.DIVISION_ID
                                    AND A.PROJECT_CODE  = B.PROJECT_CODE
                                    AND A.SCM_SITE_ID   = B.SCM_SITE_ID
                                    AND A.ITEM_ID       = B.ITEM_ID
                                    AND A.DOM_EXP       = B.DOM_EXP
                                    AND A.FCST_TYPE     = B.FCST_TYPE
                                    AND A.INCOTERMS     = B.INCOTERMS
                                    AND A.MEASURE       = B.MEASURE
                                    AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                ) B
                ON A.SCM_SITE_ID = B.SCM_SITE_ID  AND A.ITEM_ID = B.ITEM_ID
                WHERE 1 = 1
                AND B.DIVISION_ID IS NOT NULL
            )
            SELECT DIVISION_ID
                 , P_CUT_OFF_VERSION AS VERSION_NO
                 , C_CUTOFF_TYPE     AS CUTOFF_TYPE
                 , C_CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
                 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                 , 'RTF_SCP' AS MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
                 , 'SYSTEM'  AS CREATED_BY
                 , SYSDATE   AS CREATION_DATE
                 , 'SYSTEM'  AS LAST_UPDATED_BY
                 , SYSDATE   AS LAST_UPDATE_DATE
            FROM  FINAL_DATA
            /* ■■■■■■■■■■■■ 20240530 : 월 기준으로 자르면 됩니다 81사업부 DP 가 2025-05-01에 DP가 있다면, 2025-05-31까지 들어온 RTF는 반영 */
            WHERE GUBUN = 'Y';

            /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start */
            INSERT INTO GT_DPMFCQB_T9_CFM_DMD_AFTER_INS
            ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
            , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
            WITH TEMP_MKT_PLANT_ID_81_MAX_DATE AS (
                SELECT T1.*
                FROM (
                    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
                         , ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD DESC) AS RN
                    FROM DM_PLN_MKT_FCST
                    WHERE DIVISION_ID = '81'
                      AND MEASURE     = V_MEASURE  /* [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST) */
                      AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                      AND YYYYMMDD   >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')  /* 계획구간에서 정보 추출 */
                ) T1
                WHERE 1 = 1
                AND RN = 1 /* 계획구간 MKT FCST DP입력 대상 MAX(PLANT_ID) 추출 */
            )
            , TEMP_MKT_PLANT_ID_81 AS (
                    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                    FROM DM_PLN_MKT_FCST
                    WHERE DIVISION_ID = '81'
                      AND MEASURE     = V_MEASURE  /* [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST) */
                      AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                      AND YYYYMMDD   >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')  /* 계획구간에서 정보 추출 */
                      GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
            )
            , TEMP_RTF_DATA_82 AS (
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                     , F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID, F.CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                     , F.YYYYMMDD, F.QTY
                FROM DM_PLN_CFM_MKT_DEMAND_PLAN F
                INNER JOIN SCM_MST_SITE_ITEM T2
                ON  F.DIVISION_ID  = T2.DIVISION_ID
                AND F.PROJECT_CODE = T2.PROJECT_CODE
                AND F.SCM_SITE_ID  = T2.SCM_SITE_ID
                AND F.ITEM_ID      = T2.ITEM_ID
                WHERE F.DIVISION_ID  = '82'
                AND   F.YYYYMMDD    >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                AND   F.MEASURE      = 'RTF_SYS_RP'
                AND   F.SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
            )
            , FINAL_DATA AS (
                SELECT /* 81번정보사용 */ B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PLANT_SITE_ID
                     , /* 82번정보사용 */ A.CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                     , /* 82번정보사용 */ A.MEASURE, A.YYYYMMDD, A.QTY
                     , CASE WHEN A.YYYYMMDD <= SUBSTR(B.MAX_YYYYMMDD,1,6) || '31'  THEN 'Y' ELSE 'N' END AS GUBUN
                FROM TEMP_RTF_DATA_82 A
                LEFT OUTER JOIN (
                                    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
                                        ,  B.YYYYMMDD AS MAX_YYYYMMDD
                                    FROM TEMP_MKT_PLANT_ID_81 A
                                    INNER JOIN TEMP_MKT_PLANT_ID_81_MAX_DATE B
                                    ON  A.DIVISION_ID   = B.DIVISION_ID
                                    AND A.PROJECT_CODE  = B.PROJECT_CODE
                                    AND A.SCM_SITE_ID   = B.SCM_SITE_ID
                                    AND A.ITEM_ID       = B.ITEM_ID
                                    AND A.DOM_EXP       = B.DOM_EXP
                                    AND A.FCST_TYPE     = B.FCST_TYPE
                                    AND A.INCOTERMS     = B.INCOTERMS
                                    AND A.MEASURE       = B.MEASURE
                                    AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                ) B
                ON A.SCM_SITE_ID = B.SCM_SITE_ID  AND A.ITEM_ID = B.ITEM_ID
                WHERE 1 = 1
                AND B.DIVISION_ID IS NOT NULL
            )
            SELECT DIVISION_ID
                 , P_CUT_OFF_VERSION AS VERSION_NO
                 , C_CUTOFF_TYPE     AS CUTOFF_TYPE
                 , C_CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
                 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                 , 'RTF_SCP' AS MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                 , YYYYMMDD, QTY
                 , 'SYSTEM'  AS CREATED_BY
                 , SYSDATE   AS CREATION_DATE
                 , 'SYSTEM'  AS LAST_UPDATED_BY
                 , SYSDATE   AS LAST_UPDATE_DATE
            FROM  FINAL_DATA
            WHERE GUBUN = 'Y';

            /* ---------------------------------------------------------------------------------------------------------------- */
            /* [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. */
            /* ---------------------------------------------------------------------------------------------------------------- */
            DELETE FROM GT_DPMFCQB_T9_RTF_AFTER_INS A
            WHERE  EXISTS ( SELECT 1
                            FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
                                   FROM   GT_DPMFCQB_RTF_EXCEPTION_ITEM
                                   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID ) B
                            WHERE  A.DIVISION_ID   = B.DIVISION_ID
                            AND    A.PROJECT_CODE  = B.PROJECT_CODE
                            AND    A.SCM_SITE_ID   = B.SCM_SITE_ID
                            AND    A.ITEM_ID       = B.ITEM_ID
                            AND    A.DOM_EXP       = B.DOM_EXP
                            AND    A.FCST_TYPE     = B.FCST_TYPE
                            AND    A.INCOTERMS     = B.INCOTERMS
                            AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID
                            AND    A.YYYYMMDD     >= V_PLAN_START_YYYYMMDD /*-- 당주월요일*/
                            AND    A.VERSION_NO    = P_CUT_OFF_VERSION );

            DELETE FROM GT_DPMFCQB_T9_CFM_DMD_AFTER_INS A
            WHERE  EXISTS ( SELECT 1
                            FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
                                   FROM   GT_DPMFCQB_RTF_EXCEPTION_ITEM
                                   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID ) B
                            WHERE  A.DIVISION_ID   = B.DIVISION_ID
                            AND    A.PROJECT_CODE  = B.PROJECT_CODE
                            AND    A.SCM_SITE_ID   = B.SCM_SITE_ID
                            AND    A.ITEM_ID       = B.ITEM_ID
                            AND    A.DOM_EXP       = B.DOM_EXP
                            AND    A.FCST_TYPE     = B.FCST_TYPE
                            AND    A.INCOTERMS     = B.INCOTERMS
                            AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID
                            AND    A.YYYYMMDD     >= V_PLAN_START_YYYYMMDD /*-- 당주월요일*/
                            AND    A.VERSION_NO    = P_CUT_OFF_VERSION );
            /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End */

            /* [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건으로 RTF 추가 - 선박BIZ건 START */
            SELECT COUNT(*) INTO V_RTF_SCP_CNT
            FROM DM_PLN_MKT_FCST_C
            WHERE MEASURE = 'RTF_SCP'
            AND VERSION_NO = P_CUT_OFF_VERSION
            AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
            AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y');

            IF (V_RTF_SCP_CNT = 0) THEN
                INSERT INTO DM_PLN_MKT_FCST_C
                    ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                    , LAST_UPDATED_BY, LAST_UPDATE_DATE )
                SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, 'RTF_SCP' AS MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                    , LAST_UPDATED_BY, LAST_UPDATE_DATE
                FROM GT_DPMFCQB_T9_RTF_AFTER_INS  /* 20240528*/
                WHERE MEASURE = 'RTF_SCP'
                AND VERSION_NO = P_CUT_OFF_VERSION
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y');

                /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start */
                INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
                    ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, CASE WHEN DIVISION_ID='40' THEN PROJECT_CODE ELSE '' END AS END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, 'RTF_SCP' AS MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                FROM GT_DPMFCQB_T9_CFM_DMD_AFTER_INS  /* 20240528*/
                WHERE MEASURE = 'RTF_SCP'
                AND VERSION_NO = P_CUT_OFF_VERSION
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y');
                /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End */
            END IF;

            SELECT COUNT(*) INTO V_RTF_CNT
            FROM DM_PLN_MKT_FCST_C
            WHERE MEASURE = 'RTF'
            AND VERSION_NO = P_CUT_OFF_VERSION
            AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
            AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y');

            IF (V_RTF_CNT = 0) THEN
                INSERT INTO DM_PLN_MKT_FCST_C
                    ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                    , LAST_UPDATED_BY, LAST_UPDATE_DATE )
                SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, 'RTF' AS MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                    , LAST_UPDATED_BY, LAST_UPDATE_DATE
                FROM GT_DPMFCQB_T9_RTF_AFTER_INS  /* 20240528*/
                WHERE MEASURE = 'RTF_SCP' /* 20240528*/
                AND VERSION_NO = P_CUT_OFF_VERSION
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y');

                /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start */
                INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
                    ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, CASE WHEN DIVISION_ID='40' THEN PROJECT_CODE ELSE '' END AS END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, 'RTF' AS MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                FROM GT_DPMFCQB_T9_CFM_DMD_AFTER_INS  /* 20240528*/
                WHERE MEASURE = 'RTF_SCP' /* 20240528*/
                AND VERSION_NO = P_CUT_OFF_VERSION
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y');
                /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End */
            END IF;

            /* 20240528 RTF_SYS_RP 생성 */
            SELECT COUNT(*) INTO V_RTF_SYS_RP_CNT
            FROM DM_PLN_MKT_FCST_C
            WHERE MEASURE = 'RTF_SYS_RP'
            AND VERSION_NO = P_CUT_OFF_VERSION
            AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
            AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y');

            IF (V_RTF_SYS_RP_CNT = 0) THEN
                INSERT INTO DM_PLN_MKT_FCST_C
                    ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                    , LAST_UPDATED_BY, LAST_UPDATE_DATE )
                SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, 'RTF_SYS_RP' AS MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                    , LAST_UPDATED_BY, LAST_UPDATE_DATE
                FROM GT_DPMFCQB_T9_RTF_AFTER_INS
                WHERE MEASURE = 'RTF_SCP'
                AND VERSION_NO = P_CUT_OFF_VERSION
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y');

                /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start */
                INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
                    ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, CASE WHEN DIVISION_ID='40' THEN PROJECT_CODE ELSE '' END AS END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, 'RTF_SYS_RP' AS MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                 --   , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, SYSDATE  -- 
                FROM GT_DPMFCQB_T9_CFM_DMD_AFTER_INS
                WHERE MEASURE = 'RTF_SCP'
                AND VERSION_NO = P_CUT_OFF_VERSION
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y');
                /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End */
            END IF;

            /* ■■■ 기존 부분은 그대로 유지 : 룩업에 생성되어있으나 82번 사업부 RTF정보 미존재건에 대해서는 기존 로직대로 처리 */
            /* [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건으로 RTF 추가 - 선박BIZ건 START */
            SELECT COUNT(*) INTO V_RTF_SCP_CNT
            FROM DM_PLN_MKT_FCST_C
            WHERE MEASURE = 'RTF_SCP'
            AND VERSION_NO = P_CUT_OFF_VERSION
            AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
            AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
            AND SCM_SITE_ID NOT IN (SELECT Z.SCM_SITE_ID FROM GT_DPMFCQB_T9_RTF_AFTER_INS Z GROUP BY Z.SCM_SITE_ID);

            IF (V_RTF_SCP_CNT = 0) THEN
                INSERT INTO DM_PLN_MKT_FCST_C
                    ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                    , LAST_UPDATED_BY, LAST_UPDATE_DATE )
                SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, 'RTF_SCP' AS MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                  --  , LAST_UPDATED_BY, LAST_UPDATE_DATE
                     , LAST_UPDATED_BY, SYSDATE
                FROM DM_PLN_MKT_FCST_C A
                WHERE MEASURE = V_MEASURE  /* [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST) */
                AND VERSION_NO = P_CUT_OFF_VERSION
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID NOT IN (SELECT Z.SCM_SITE_ID FROM GT_DPMFCQB_T9_RTF_AFTER_INS Z GROUP BY Z.SCM_SITE_ID)
                /* [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. */
                AND NOT EXISTS ( SELECT 1
                                 FROM GT_DPMFCQB_RTF_EXCEPTION_ITEM B
                                 WHERE A.DIVISION_ID = B.DIVISION_ID
                                 AND A.PROJECT_CODE = B.PROJECT_CODE
                                 AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                 AND A.ITEM_ID = B.ITEM_ID
                                 AND A.DOM_EXP = B.DOM_EXP
                                 AND A.FCST_TYPE = B.FCST_TYPE
                                 AND A.INCOTERMS = B.INCOTERMS
                                 AND A.MEASURE = B.MEASURE
                                 AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                                 AND A.YYYYMMDD >= V_PLAN_START_YYYYMMDD /*-- 당주월요일*/
                                 AND A.VERSION_NO = P_CUT_OFF_VERSION );

                /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start */
                INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
                    ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, CASE WHEN DIVISION_ID='40' THEN PROJECT_CODE ELSE '' END AS END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, 'RTF_SCP' AS MEASURE, PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID
                    --, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, SYSDATE
                FROM DM_PLN_MKT_FCST_C A
                WHERE MEASURE = V_MEASURE  /* [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST) */
                AND VERSION_NO = P_CUT_OFF_VERSION
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID NOT IN (SELECT Z.SCM_SITE_ID FROM GT_DPMFCQB_T9_RTF_AFTER_INS Z GROUP BY Z.SCM_SITE_ID)
                /* [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. */
                AND NOT EXISTS ( SELECT 1
                                 FROM GT_DPMFCQB_RTF_EXCEPTION_ITEM B
                                 WHERE A.DIVISION_ID = B.DIVISION_ID
                                 AND A.PROJECT_CODE = B.PROJECT_CODE
                                 AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                 AND A.ITEM_ID = B.ITEM_ID
                                 AND A.DOM_EXP = B.DOM_EXP
                                 AND A.FCST_TYPE = B.FCST_TYPE
                                 AND A.INCOTERMS = B.INCOTERMS
                                 AND A.MEASURE = B.MEASURE
                                 AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                                 AND A.YYYYMMDD >= V_PLAN_START_YYYYMMDD /*-- 당주월요일*/
                                 AND A.VERSION_NO = P_CUT_OFF_VERSION );
                /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End */
            END IF;

            SELECT COUNT(*) INTO V_RTF_CNT
            FROM DM_PLN_MKT_FCST_C
            WHERE MEASURE = 'RTF'
            AND VERSION_NO = P_CUT_OFF_VERSION
            AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
            AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
            AND SCM_SITE_ID NOT IN (SELECT Z.SCM_SITE_ID FROM GT_DPMFCQB_T9_RTF_AFTER_INS Z GROUP BY Z.SCM_SITE_ID);

            IF (V_RTF_CNT = 0) THEN
                INSERT INTO DM_PLN_MKT_FCST_C
                    ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                    , LAST_UPDATED_BY, LAST_UPDATE_DATE )
                SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, 'RTF' AS MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                    , LAST_UPDATED_BY, LAST_UPDATE_DATE
                FROM DM_PLN_MKT_FCST_C A
                WHERE MEASURE = V_MEASURE  /* [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST) */
                AND VERSION_NO = P_CUT_OFF_VERSION
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID NOT IN (SELECT Z.SCM_SITE_ID FROM GT_DPMFCQB_T9_RTF_AFTER_INS Z GROUP BY Z.SCM_SITE_ID)
                /* [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. */
                AND NOT EXISTS ( SELECT 1
                                 FROM GT_DPMFCQB_RTF_EXCEPTION_ITEM B
                                 WHERE A.DIVISION_ID = B.DIVISION_ID
                                 AND A.PROJECT_CODE = B.PROJECT_CODE
                                 AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                 AND A.ITEM_ID = B.ITEM_ID
                                 AND A.DOM_EXP = B.DOM_EXP
                                 AND A.FCST_TYPE = B.FCST_TYPE
                                 AND A.INCOTERMS = B.INCOTERMS
                                 AND A.MEASURE = B.MEASURE
                                 AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                                 AND A.YYYYMMDD >= V_PLAN_START_YYYYMMDD /*-- 당주월요일*/
                                 AND A.VERSION_NO = P_CUT_OFF_VERSION );

                /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start */
                INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
                    ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, CASE WHEN DIVISION_ID='40' THEN PROJECT_CODE ELSE '' END AS END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, 'RTF' AS MEASURE, PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID
                  --  , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, SYSDATE
                FROM DM_PLN_MKT_FCST_C A
                WHERE MEASURE = V_MEASURE  /* [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST) */
                AND VERSION_NO = P_CUT_OFF_VERSION
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID NOT IN (SELECT Z.SCM_SITE_ID FROM GT_DPMFCQB_T9_RTF_AFTER_INS Z GROUP BY Z.SCM_SITE_ID)
                /* [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. */
                AND NOT EXISTS ( SELECT 1
                                 FROM GT_DPMFCQB_RTF_EXCEPTION_ITEM B
                                 WHERE A.DIVISION_ID = B.DIVISION_ID
                                 AND A.PROJECT_CODE = B.PROJECT_CODE
                                 AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                 AND A.ITEM_ID = B.ITEM_ID
                                 AND A.DOM_EXP = B.DOM_EXP
                                 AND A.FCST_TYPE = B.FCST_TYPE
                                 AND A.INCOTERMS = B.INCOTERMS
                                 AND A.MEASURE = B.MEASURE
                                 AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                                 AND A.YYYYMMDD >= V_PLAN_START_YYYYMMDD /*-- 당주월요일*/
                                 AND A.VERSION_NO = P_CUT_OFF_VERSION );
                /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End */
            END IF;
            /* [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건으로 RTF 추가 - 선박BIZ건 END */
        ELSIF ( P_DIVISION_ID = '82' ) THEN
            INSERT INTO GT_DPMFCQB_T9_RTF_AFTER_INS2
            ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
            , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
            WITH LOOKUP_SCM_SITE_ID AS (
                SELECT *
                FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE 1 = 1
                AND LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION'
                AND VALID_YN = 'Y'  /* 사용대상 */
            )
            , TEMP_CUTOFF_DATA_82 AS (
                SELECT A.*
                FROM DM_PLN_MKT_FCST_C A
                   , LOOKUP_SCM_SITE_ID B
                WHERE A.DIVISION_ID = P_DIVISION_ID
                AND A.VERSION_NO   = P_CUT_OFF_VERSION
                AND A.CUTOFF_TYPE  = 'MF_W'
                AND A.MEASURE      IN ('RTF_SYS_RP')
                AND A.SCM_SITE_ID  = B.SEGMENT2
            )
            , TEMP_CUTOFF_DATA_81_MAX_DATE AS (
                SELECT T.*
                FROM (
                    SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
                         , A.YYYYMMDD
                         , ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD DESC) AS RN
                    FROM DM_PLN_MKT_FCST_C A
                       , LOOKUP_SCM_SITE_ID B
                    WHERE A.DIVISION_ID = '81'
                    AND A.VERSION_NO    = V_CUT_OFF_VERSION_81
                    AND A.CUTOFF_TYPE   = 'MF_W'
                    AND A.MEASURE IN ('RTF_SYS_RP')
                    AND A.DIVISION_ID = B.SEGMENT1
                    AND A.SCM_SITE_ID = B.SEGMENT2
                ) T
                WHERE T.RN = 1
            )
            , TEMP_CUTOFF_DATA_81 AS (
                    SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
                    FROM DM_PLN_MKT_FCST_C A
                       , LOOKUP_SCM_SITE_ID B
                    WHERE A.DIVISION_ID = '81'
                    AND A.VERSION_NO    = V_CUT_OFF_VERSION_81
                    AND A.CUTOFF_TYPE   = 'MF_W'
                    AND A.MEASURE IN ('RTF_SYS_RP')
                    AND A.DIVISION_ID = B.SEGMENT1
                    AND A.SCM_SITE_ID = B.SEGMENT2
                    GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
            )
            , FINAL_DATA AS (
                SELECT B.DIVISION_ID, B.VERSION_NO, B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID
                     , A.YYYYMMDD, A.QTY
                FROM TEMP_CUTOFF_DATA_82 A
                INNER JOIN (
                                SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
                                    ,  B.YYYYMMDD AS MAX_YYYYMMDD
                                FROM TEMP_CUTOFF_DATA_81 A
                                INNER JOIN TEMP_CUTOFF_DATA_81_MAX_DATE B
                                ON  A.DIVISION_ID     = B.DIVISION_ID
                                AND A.VERSION_NO      = B.VERSION_NO
                                AND A.CUTOFF_TYPE     = B.CUTOFF_TYPE
                                AND A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD
                                AND A.PROJECT_CODE    = B.PROJECT_CODE
                                AND A.SCM_SITE_ID     = B.SCM_SITE_ID
                                AND A.ITEM_ID         = B.ITEM_ID
                                AND A.DOM_EXP         = B.DOM_EXP
                                AND A.FCST_TYPE       = B.FCST_TYPE
                                AND A.INCOTERMS       = B.INCOTERMS
                                AND A.MEASURE         = B.MEASURE
                                AND A.PLANT_SITE_ID   = B.PLANT_SITE_ID
                ) B
                ON  A.SCM_SITE_ID = B.SCM_SITE_ID
                AND A.ITEM_ID = B.ITEM_ID
                AND A.DOM_EXP   = B.DOM_EXP
                AND A.FCST_TYPE = B.FCST_TYPE
                AND A.INCOTERMS = B.INCOTERMS
                AND A.MEASURE   = B.MEASURE
                WHERE 1 = 1
                AND CASE WHEN A.YYYYMMDD <= SUBSTR(B.MAX_YYYYMMDD,1,6) || '31'  THEN 'Y' ELSE 'N' END  = 'Y'
            )
            SELECT DIVISION_ID
                 , VERSION_NO AS VERSION_NO
                 , CUTOFF_TYPE AS CUTOFF_TYPE
                 , CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
                 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                 , 'RTF_SCP' AS MEASURE
                 , PLANT_SITE_ID, YYYYMMDD, QTY
                 , 'SYSTEM'  AS CREATED_BY
                 , SYSDATE   AS CREATION_DATE
                 , 'SYSTEM'  AS LAST_UPDATED_BY
                 , SYSDATE   AS LAST_UPDATE_DATE
            FROM  FINAL_DATA;

            /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start */
            INSERT INTO GT_DPMFCQB_T9_CFM_DMD_AFT_INS2
            ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
            , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
            WITH LOOKUP_SCM_SITE_ID AS (
                SELECT *
                FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE 1 = 1
                AND LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION'
                AND VALID_YN = 'Y'  /* 사용대상 */
            )
            , TEMP_CUTOFF_DATA_82 AS (
                SELECT A.*
                FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
                   , LOOKUP_SCM_SITE_ID B
                WHERE A.DIVISION_ID = P_DIVISION_ID
                AND A.VERSION_NO   = P_CUT_OFF_VERSION
                AND A.CUTOFF_TYPE  = 'MF_W'
                AND A.MEASURE      IN ('RTF_SYS_RP')
                AND A.SCM_SITE_ID  = B.SEGMENT2
            )
            , TEMP_CUTOFF_DATA_81_MAX_DATE AS (
                SELECT T.*
                FROM (
                    SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
                         , A.CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                         , A.YYYYMMDD
                         , ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD DESC) AS RN
                    FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
                       , LOOKUP_SCM_SITE_ID B
                    WHERE A.DIVISION_ID = '81'
                    AND A.VERSION_NO    = V_CUT_OFF_VERSION_81
                    AND A.CUTOFF_TYPE   = 'MF_W'
                    AND A.MEASURE IN ('RTF_SYS_RP')
                    AND A.DIVISION_ID = B.SEGMENT1
                    AND A.SCM_SITE_ID = B.SEGMENT2
                ) T
                WHERE T.RN = 1
            )
            , TEMP_CUTOFF_DATA_81 AS (
                    SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
                         , A.CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                    FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
                       , LOOKUP_SCM_SITE_ID B
                    WHERE A.DIVISION_ID = '81'
                    AND A.VERSION_NO    = V_CUT_OFF_VERSION_81
                    AND A.CUTOFF_TYPE   = 'MF_W'
                    AND A.MEASURE IN ('RTF_SYS_RP')
                    AND A.DIVISION_ID = B.SEGMENT1
                    AND A.SCM_SITE_ID = B.SEGMENT2
                    /* 2025.04.10 Philsu Park: [PJ2024-50611] Group By 미처리로 Data 중복 발생한 케이스 조치. */
                    GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
                         , A.CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
            )
            , FINAL_DATA AS (
                SELECT B.DIVISION_ID, B.VERSION_NO, B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                     , A.YYYYMMDD, A.QTY
                FROM TEMP_CUTOFF_DATA_82 A
                INNER JOIN (
                                SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
                                    ,  B.YYYYMMDD AS MAX_YYYYMMDD
                                FROM TEMP_CUTOFF_DATA_81 A
                                INNER JOIN TEMP_CUTOFF_DATA_81_MAX_DATE B
                                ON  A.DIVISION_ID     = B.DIVISION_ID
                                AND A.VERSION_NO      = B.VERSION_NO
                                AND A.CUTOFF_TYPE     = B.CUTOFF_TYPE
                                AND A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD
                                AND A.PROJECT_CODE    = B.PROJECT_CODE
                                AND A.SCM_SITE_ID     = B.SCM_SITE_ID
                                AND A.ITEM_ID         = B.ITEM_ID
                                AND A.DOM_EXP         = B.DOM_EXP
                                AND A.FCST_TYPE       = B.FCST_TYPE
                                AND A.INCOTERMS       = B.INCOTERMS
                                AND A.MEASURE         = B.MEASURE
                                AND A.PLANT_SITE_ID   = B.PLANT_SITE_ID
                                AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                ) B
                ON  A.SCM_SITE_ID = B.SCM_SITE_ID
                AND A.ITEM_ID = B.ITEM_ID
                AND A.DOM_EXP   = B.DOM_EXP
                AND A.FCST_TYPE = B.FCST_TYPE
                AND A.INCOTERMS = B.INCOTERMS
                AND A.MEASURE   = B.MEASURE
                WHERE 1 = 1
                AND CASE WHEN A.YYYYMMDD <= SUBSTR(B.MAX_YYYYMMDD,1,6) || '31'  THEN 'Y' ELSE 'N' END  = 'Y'
            )
            SELECT DIVISION_ID
                 , VERSION_NO AS VERSION_NO
                 , CUTOFF_TYPE AS CUTOFF_TYPE
                 , CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
                 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                 , 'RTF_SCP' AS MEASURE
                 , PLANT_SITE_ID
                 , CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                 , YYYYMMDD, QTY
                 , 'SYSTEM'  AS CREATED_BY
                 , SYSDATE   AS CREATION_DATE
                 , 'SYSTEM'  AS LAST_UPDATED_BY
                 , SYSDATE   AS LAST_UPDATE_DATE
            FROM  FINAL_DATA;

            /* ---------------------------------------------------------------------------------------------------------------- */
            /* [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. */
            /* ---------------------------------------------------------------------------------------------------------------- */
            DELETE FROM GT_DPMFCQB_T9_RTF_AFTER_INS2 A
            WHERE  EXISTS ( SELECT 1
                            FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
                                   FROM   GT_DPMFCQB_RTF_EXCEPTION_ITEM
                                   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID ) B
                            WHERE  A.DIVISION_ID   = B.DIVISION_ID
                            AND    A.PROJECT_CODE  = B.PROJECT_CODE
                            AND    A.SCM_SITE_ID   = B.SCM_SITE_ID
                            AND    A.ITEM_ID       = B.ITEM_ID
                            AND    A.DOM_EXP       = B.DOM_EXP
                            AND    A.FCST_TYPE     = B.FCST_TYPE
                            AND    A.INCOTERMS     = B.INCOTERMS
                            AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID
                            AND    A.YYYYMMDD     >= V_PLAN_START_YYYYMMDD /*-- 당주월요일*/ );

            DELETE FROM GT_DPMFCQB_T9_CFM_DMD_AFT_INS2 A
            WHERE  EXISTS ( SELECT 1
                            FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
                                   FROM   GT_DPMFCQB_RTF_EXCEPTION_ITEM
                                   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID ) B
                            WHERE  A.DIVISION_ID   = B.DIVISION_ID
                            AND    A.PROJECT_CODE  = B.PROJECT_CODE
                            AND    A.SCM_SITE_ID   = B.SCM_SITE_ID
                            AND    A.ITEM_ID       = B.ITEM_ID
                            AND    A.DOM_EXP       = B.DOM_EXP
                            AND    A.FCST_TYPE     = B.FCST_TYPE
                            AND    A.INCOTERMS     = B.INCOTERMS
                            AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID
                            AND    A.YYYYMMDD     >= V_PLAN_START_YYYYMMDD /*-- 당주월요일*/ );
            /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End */

            /* #T9_RTF_AFTER_INSERT2 : 81번 CUTOFF대상 중 82번 RTF 정보가 있는 정보
               81번 CUTOFF 정보 중 해당 테이블에 정보가 있는 대상이면 삭제 후 #T9_RTF_AFTER_INSERT2정보로 다시 INSERT 한다.
            */
            SELECT COUNT(*) INTO V_AFTER_RTF_DATA_CNT
            FROM DM_PLN_MKT_FCST_C
            WHERE MEASURE IN ('RTF_SCP','RTF','RTF_SYS_RP')
            AND VERSION_NO = V_CUT_OFF_VERSION_81
            AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
            AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
            /* 다시 넣어야할 대상에 존재하는지 확인 */
            AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM GT_DPMFCQB_T9_RTF_AFTER_INS2 Z WHERE DIVISION_ID = '81')
            AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM GT_DPMFCQB_T9_RTF_AFTER_INS2 Z WHERE DIVISION_ID = '81');

            IF (V_AFTER_RTF_DATA_CNT > 0) THEN  /* 삭제 후 다시 넣어준다. */
                DELETE FROM DM_PLN_MKT_FCST_C A
                WHERE MEASURE  IN ('RTF_SCP','RTF_SYS_RP','RTF')
                AND VERSION_NO = V_CUT_OFF_VERSION_81
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                /* 다시 넣어야할 대상에 존재하는지 확인 */
                AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM GT_DPMFCQB_T9_RTF_AFTER_INS2 Z WHERE DIVISION_ID = '81')
                AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM GT_DPMFCQB_T9_RTF_AFTER_INS2 Z WHERE DIVISION_ID = '81')
                /* [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. */
                AND NOT EXISTS ( SELECT 1
                                 FROM GT_DPMFCQB_RTF_EXCEPTION_ITEM B
                                 WHERE A.DIVISION_ID   = B.DIVISION_ID
                                 AND A.PROJECT_CODE    = B.PROJECT_CODE
                                 AND A.SCM_SITE_ID     = B.SCM_SITE_ID
                                 AND A.ITEM_ID         = B.ITEM_ID
                                 AND A.DOM_EXP         = B.DOM_EXP
                                 AND A.FCST_TYPE       = B.FCST_TYPE
                                 AND A.INCOTERMS       = B.INCOTERMS
                                 AND A.MEASURE         = B.MEASURE
                                 AND A.PLANT_SITE_ID   = B.PLANT_SITE_ID
                                 AND A.YYYYMMDD       >= V_PLAN_START_YYYYMMDD /*-- 당주월요일*/
                                 AND A.VERSION_NO      = V_CUT_OFF_VERSION_81 );

                /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start */
                DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
                WHERE MEASURE  IN ('RTF_SCP','RTF_SYS_RP','RTF')
                AND VERSION_NO = V_CUT_OFF_VERSION_81
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                /* 다시 넣어야할 대상에 존재하는지 확인 */
                AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM GT_DPMFCQB_T9_CFM_DMD_AFT_INS2 Z WHERE DIVISION_ID = '81')
                AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM GT_DPMFCQB_T9_CFM_DMD_AFT_INS2 Z WHERE DIVISION_ID = '81')
                /* [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. */
                AND NOT EXISTS ( SELECT 1
                                 FROM GT_DPMFCQB_RTF_EXCEPTION_ITEM B
                                 WHERE A.DIVISION_ID   = B.DIVISION_ID
                                 AND A.PROJECT_CODE    = B.PROJECT_CODE
                                 AND A.END_CUSTOMER    = B.END_CUSTOMER
                                 AND A.SCM_SITE_ID     = B.SCM_SITE_ID
                                 AND A.ITEM_ID         = B.ITEM_ID
                                 AND A.DOM_EXP         = B.DOM_EXP
                                 AND A.FCST_TYPE       = B.FCST_TYPE
                                 AND A.INCOTERMS       = B.INCOTERMS
                                 AND A.MEASURE         = B.MEASURE
                                 AND A.PLANT_SITE_ID   = B.PLANT_SITE_ID
                                 AND NVL(A.CELL_PROD_SITE_ID, '-') = NVL(B.CELL_PROD_SITE_ID, '-')
                                 AND A.YYYYMMDD       >= V_PLAN_START_YYYYMMDD /*-- 당주월요일*/
                                 AND A.VERSION_NO      = V_CUT_OFF_VERSION_81 );

                INSERT INTO DM_PLN_MKT_FCST_C
                    ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                    , LAST_UPDATED_BY, LAST_UPDATE_DATE )
                SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                    , LAST_UPDATED_BY, LAST_UPDATE_DATE
                FROM GT_DPMFCQB_T9_RTF_AFTER_INS2
                WHERE MEASURE = 'RTF_SCP'
                AND VERSION_NO = V_CUT_OFF_VERSION_81
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM GT_DPMFCQB_T9_RTF_AFTER_INS2 Z WHERE DIVISION_ID = '81')
                AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM GT_DPMFCQB_T9_RTF_AFTER_INS2 Z WHERE DIVISION_ID = '81')
                UNION ALL
                SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, 'RTF' AS MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                    , LAST_UPDATED_BY, LAST_UPDATE_DATE
                FROM GT_DPMFCQB_T9_RTF_AFTER_INS2
                WHERE MEASURE = 'RTF_SCP'
                AND VERSION_NO = V_CUT_OFF_VERSION_81
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM GT_DPMFCQB_T9_RTF_AFTER_INS2 Z WHERE DIVISION_ID = '81')
                AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM GT_DPMFCQB_T9_RTF_AFTER_INS2 Z WHERE DIVISION_ID = '81')
                UNION ALL
                SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, 'RTF_SYS_RP' AS MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                    , LAST_UPDATED_BY, LAST_UPDATE_DATE
                FROM GT_DPMFCQB_T9_RTF_AFTER_INS2
                WHERE MEASURE = 'RTF_SCP'
                AND VERSION_NO = V_CUT_OFF_VERSION_81
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM GT_DPMFCQB_T9_RTF_AFTER_INS2 Z WHERE DIVISION_ID = '81')
                AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM GT_DPMFCQB_T9_RTF_AFTER_INS2 Z WHERE DIVISION_ID = '81');

                /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start */
                INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
                    ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, PROJECT_CODE AS END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                FROM GT_DPMFCQB_T9_CFM_DMD_AFT_INS2
                WHERE MEASURE = 'RTF_SCP'
                AND VERSION_NO = V_CUT_OFF_VERSION_81
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM GT_DPMFCQB_T9_CFM_DMD_AFT_INS2 Z WHERE DIVISION_ID = '81')
                AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM GT_DPMFCQB_T9_CFM_DMD_AFT_INS2 Z WHERE DIVISION_ID = '81')
                UNION ALL
                SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, PROJECT_CODE AS END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, 'RTF' AS MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                FROM GT_DPMFCQB_T9_CFM_DMD_AFT_INS2
                WHERE MEASURE = 'RTF_SCP'
                AND VERSION_NO = V_CUT_OFF_VERSION_81
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM GT_DPMFCQB_T9_CFM_DMD_AFT_INS2 Z WHERE DIVISION_ID = '81')
                AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM GT_DPMFCQB_T9_CFM_DMD_AFT_INS2 Z WHERE DIVISION_ID = '81')
                UNION ALL
                SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                    , PROJECT_CODE, PROJECT_CODE AS END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , INCOTERMS, 'RTF_SYS_RP' AS MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                FROM GT_DPMFCQB_T9_CFM_DMD_AFT_INS2
                WHERE MEASURE = 'RTF_SCP'
                AND VERSION_NO = V_CUT_OFF_VERSION_81
                AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
                AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM GT_DPMFCQB_T9_CFM_DMD_AFT_INS2 Z WHERE DIVISION_ID = '81')
                AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM GT_DPMFCQB_T9_CFM_DMD_AFT_INS2 Z WHERE DIVISION_ID = '81');
                /* [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End */
            END IF;
        END IF;
/* ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ */

        /* -------------------------------- RTF MEASURE MKT_FCST TABLE INSERT (END) */
        /* ------------------------------------------------------------------------------------------------------------------- VMI재고 확인후 RTF 생성 로직 (START) */
        /* [C20220224-000448] ESS 사업부 VMI 기능 자동차사업부 확산 전개 요청 (자동차 사업부 VMI_INV 생성하지 않음) */
        IF P_DIVISION_ID NOT LIKE '81%' THEN
            /* 성능이슈로 TEMP테이블로 사용 */
            /* [변환주의] SCM_DNM_STOCK_SN / SCM_MST_LOCATION / SCM_DNM_STOCK_SALES 는 seq10 triage 의존목록에 없음(컴파일시 실재 확인 필요). */
            /* RESULT_DATE 컬럼 타입(DATE vs 문자열) 미확인 -> 원본 충실히 문자열 'YYYYMMDD' 비교 유지(DATE컬럼이면 TO_CHAR 래핑 필요). */
            INSERT INTO GT_DPMFCQB_FP_STOCK_QTY ( DIVISION_ID, SCM_SITE_ID, ITEM_ID, QTY )
            SELECT L.DIVISION_ID, L.SCM_SITE_ID, S.ITEM_ID, S.QTY
            FROM   SCM_DNM_STOCK_SN S
                 , SCM_MST_LOCATION L
            WHERE  L.DIVISION_ID = S.DIVISION_ID
            AND    L.STORAGE_ID = S.STORAGE_ID
            AND    TO_CHAR(S.CUTOFF_DATE, 'YYYYMMDD') = V_PLAN_START_YYYYMMDD
            UNION ALL  /* [C20201103-000114] */
            SELECT L.DIVISION_ID, L.SCM_SITE_ID, S.ITEM_ID, S.QTY
            FROM   SCM_DNM_STOCK_SALES S
                 , SCM_MST_LOCATION L
            WHERE  L.DIVISION_ID = S.DIVISION_ID
            AND    L.STORAGE_ID = S.STORAGE_ID
            /* [C20201222-000376] */
            AND    L.PLANT_ID = S.PLANT_ID  /* 여기는 PLANT까지 걸어야 함. */
            AND    S.DIVISION_ID = '82'
            AND    S.RESULT_DATE = TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');

            IF P_DIVISION_ID = '40' THEN
                INSERT INTO GT_DPMFCQB_VMI_MST_MAIN
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CELL_PROD_SITE_ID, FROM_SITE_ID )  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
                SELECT DISTINCT
                        A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
                      , B.BASIS_YYYYMMDD AS YYYYMMDD
                      /* vmi stock qty 를 초재고로 적용 (S)  -- 20221206 -- 11 자리 LIKE 는 소형사업부에만 적용 */
                      , CASE WHEN A.DIVISION_ID = '40' THEN
                                 CASE WHEN B.BASIS_YYYYMMDD = V_PLAN_START_YYYYMMDD AND A.MEASURE IN ('Vmi_In_Plan')
                                      THEN NVL(C.QTY,0) + NVL(( SELECT SUM(S.QTY)
                                                                FROM GT_DPMFCQB_FP_STOCK_QTY S
                                                                WHERE S.SCM_SITE_ID = A.SCM_SITE_ID
                                                                  AND S.DIVISION_ID = A.DIVISION_ID
                                                                  AND S.ITEM_ID LIKE (CASE WHEN SUBSTR(A.ITEM_ID,1,2) = 'MP' THEN SUBSTR(A.ITEM_ID,1,11) ELSE A.ITEM_ID END) || '%'
                                                              ), 0)
                                      ELSE NVL(C.QTY,0) END
                             ELSE
                                 CASE WHEN B.BASIS_YYYYMMDD = V_PLAN_START_YYYYMMDD AND A.MEASURE IN ('Vmi_In_Plan')
                                      THEN NVL(C.QTY,0) + NVL(( SELECT SUM(S.QTY)
                                                                FROM GT_DPMFCQB_FP_STOCK_QTY S
                                                                WHERE S.SCM_SITE_ID = A.SCM_SITE_ID
                                                                  AND S.DIVISION_ID = A.DIVISION_ID
                                                                  AND S.ITEM_ID = A.ITEM_ID
                                                              ), 0)
                                      ELSE NVL(C.QTY,0) END
                             END AS QTY
                      /* vmi stock qty 를 초재고로 적용 (E) */
                      , A.CELL_PROD_SITE_ID, A.FROM_SITE_ID  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
                FROM ( SELECT DISTINCT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, W.MEASURE, W.PLANT_SITE_ID
                            , W.CELL_PROD_SITE_ID  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
                            , W.ATTRIBUTE2 AS FROM_SITE_ID  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
                            /* (START) 2026.10.01 AJS  END_CUSTOMER 를 조인에 쓰기 위해 추출 항목에 추가.
                                                       조인 조건에 이 칸이 없어 기본키 인덱스가 여섯째 칸에서 끊기고
                                                       나머지 조건이 걸러내기로 넘어가 수행시간이 길어진다 */
                            , W.END_CUSTOMER
                            /* (END) */
                       FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C W
                       INNER JOIN SCM_MST_SITE ST
                          ON W.DIVISION_ID = ST.DIVISION_ID
                         AND W.SCM_SITE_ID = ST.SCM_SITE_ID
                         AND ST.VMI_YN     = 'Y'  /* vmi대상만 입력 */
                        AND W.DIVISION_ID     = P_DIVISION_ID
                        AND W.VERSION_NO      = P_CUT_OFF_VERSION
                        AND W.CUTOFF_TYPE     = C_CUTOFF_TYPE
                        AND W.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
                       WHERE W.YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD
                         AND TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + V_PLAN_WEEK_CNT * 7, 'YYYYMMDD')  /* SCP PLANNING 구간이 52주 */
                     ) A
                INNER JOIN SCM_SYS_CALENDAR_M B
                    ON B.BASIS_YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD
                       AND TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + V_PLAN_WEEK_CNT * 7, 'YYYYMMDD')  /* SCP PLANNING 구간이 52주 */
                LEFT JOIN DM_PLN_CFM_MKT_DEMAND_PLAN_C C
                    ON  A.DIVISION_ID     = C.DIVISION_ID
                    AND A.PROJECT_CODE    = C.PROJECT_CODE
                    AND A.SCM_SITE_ID     = C.SCM_SITE_ID
                    AND A.ITEM_ID         = C.ITEM_ID
                    AND A.DOM_EXP         = C.DOM_EXP
                    AND A.FCST_TYPE       = C.FCST_TYPE
                    AND A.INCOTERMS       = C.INCOTERMS
                    AND A.PLANT_SITE_ID   = C.PLANT_SITE_ID
                    AND A.MEASURE         = C.MEASURE
                    AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
                    /* (START) 2026.10.01 AJS  기본키 인덱스를 끝까지 타도록 조인 조건 추가.
                                               END_CUSTOMER 는 NOT NULL 이고 조인 열쇠당 한 값뿐이라 결과가 바뀌지 않는다
                                               (40·81·82 전건 확인, 행수·수량합 동일) */
                    AND A.END_CUSTOMER    = C.END_CUSTOMER
                    /* (END) */
                    AND B.BASIS_YYYYMMDD  = C.YYYYMMDD
                    AND C.DIVISION_ID     = P_DIVISION_ID
                    AND C.VERSION_NO      = P_CUT_OFF_VERSION
                    AND C.CUTOFF_TYPE     = C_CUTOFF_TYPE
                    AND C.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
                WHERE 1 = 1
                AND A.MEASURE IN (V_MEASURE, 'Vmi_In_Plan');  /* [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST) */
            ELSE
                INSERT INTO GT_DPMFCQB_VMI_MST_MAIN
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CELL_PROD_SITE_ID, FROM_SITE_ID )  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
                SELECT DISTINCT
                        A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
                      , B.BASIS_YYYYMMDD AS YYYYMMDD
                      , CASE WHEN A.DIVISION_ID = '40' THEN
                                 CASE WHEN B.BASIS_YYYYMMDD = V_PLAN_START_YYYYMMDD AND A.MEASURE IN ('Vmi_In_Plan')
                                      THEN NVL(C.QTY,0) + NVL(( SELECT SUM(S.QTY)
                                                                FROM GT_DPMFCQB_FP_STOCK_QTY S
                                                                WHERE S.SCM_SITE_ID = A.SCM_SITE_ID
                                                                  AND S.DIVISION_ID = A.DIVISION_ID
                                                                  AND S.ITEM_ID LIKE (CASE WHEN SUBSTR(A.ITEM_ID,1,2) = 'MP' THEN SUBSTR(A.ITEM_ID,1,11) ELSE A.ITEM_ID END) || '%'
                                                              ), 0)
                                      ELSE NVL(C.QTY,0) END
                             ELSE
                                 CASE WHEN B.BASIS_YYYYMMDD = V_PLAN_START_YYYYMMDD AND A.MEASURE IN ('Vmi_In_Plan')
                                      THEN NVL(C.QTY,0) + NVL(( SELECT SUM(S.QTY)
                                                                FROM GT_DPMFCQB_FP_STOCK_QTY S
                                                                WHERE S.SCM_SITE_ID = A.SCM_SITE_ID
                                                                  AND S.DIVISION_ID = A.DIVISION_ID
                                                                  AND S.ITEM_ID = A.ITEM_ID
                                                              ), 0)
                                      ELSE NVL(C.QTY,0) END
                             END AS QTY
                      , '-' AS CELL_PROD_SITE_ID  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 (단, 40외에는 형식을 맞추기 위해 DEFAULT값 적용) */
                      , '-' AS FROM_SITE_ID  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 (단, 40외에는 형식을 맞추기 위해 DEFAULT값 적용) */
                FROM ( SELECT DISTINCT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, W.MEASURE, W.PLANT_SITE_ID
                       FROM DM_PLN_MKT_FCST_C W
                       INNER JOIN SCM_MST_SITE ST
                          ON W.DIVISION_ID = ST.DIVISION_ID
                         AND W.SCM_SITE_ID = ST.SCM_SITE_ID
                         AND ST.VMI_YN     = 'Y'  /* vmi대상만 입력 */
                        AND W.DIVISION_ID     = P_DIVISION_ID
                        AND W.VERSION_NO      = P_CUT_OFF_VERSION
                        AND W.CUTOFF_TYPE     = C_CUTOFF_TYPE
                        AND W.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
                       WHERE W.YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD
                         AND TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + V_PLAN_WEEK_CNT * 7, 'YYYYMMDD')  /* SCP PLANNING 구간이 52주 */
                     ) A
                INNER JOIN SCM_SYS_CALENDAR_M B
                    ON B.BASIS_YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD
                       AND TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + V_PLAN_WEEK_CNT * 7, 'YYYYMMDD')  /* SCP PLANNING 구간이 52주 */
                LEFT JOIN DM_PLN_MKT_FCST_C C
                    ON  A.DIVISION_ID     = C.DIVISION_ID
                    AND A.PROJECT_CODE    = C.PROJECT_CODE
                    AND A.SCM_SITE_ID     = C.SCM_SITE_ID
                    AND A.ITEM_ID         = C.ITEM_ID
                    AND A.DOM_EXP         = C.DOM_EXP
                    AND A.FCST_TYPE       = C.FCST_TYPE
                    AND A.INCOTERMS       = C.INCOTERMS
                    AND A.PLANT_SITE_ID   = C.PLANT_SITE_ID
                    AND A.MEASURE         = C.MEASURE
                    AND B.BASIS_YYYYMMDD  = C.YYYYMMDD
                    AND C.DIVISION_ID     = P_DIVISION_ID
                    AND C.VERSION_NO      = P_CUT_OFF_VERSION
                    AND C.CUTOFF_TYPE     = C_CUTOFF_TYPE
                    AND C.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
                WHERE 1 = 1
                AND A.MEASURE IN (V_MEASURE, 'Vmi_In_Plan');  /* [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST) */
            END IF;

            /*
            [C20220615-000414] RESU16H_Prime RTF 에러의 건
            MKT_FCST는 존재하나 Vmi_In_Plan이 존재하지 않고 scm_dnm_stock_sn에 기초재고가 존재하는 site의 item들은 Vmi_In_Plan을 생성
            plan 시작일 기준 기초재고 수량 이후 0으로 qty 설정
            */
            INSERT INTO GT_DPMFCQB_VMI_MST_MAIN
            ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE, YYYYMMDD, QTY, CELL_PROD_SITE_ID, FROM_SITE_ID )
            WITH T_CHK_PLAN AS (
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                     , CELL_PROD_SITE_ID, FROM_SITE_ID  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
                FROM  GT_DPMFCQB_VMI_MST_MAIN
                WHERE MEASURE = 'Vmi_In_Plan'
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                       , CELL_PROD_SITE_ID, FROM_SITE_ID  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
            )
            SELECT  AA.DIVISION_ID, AA.PROJECT_CODE, AA.SCM_SITE_ID, AA.ITEM_ID, AA.DOM_EXP, AA.FCST_TYPE, AA.INCOTERMS, AA.PLANT_SITE_ID
                  , 'Vmi_In_Plan' AS MEASURE
                  , AA.YYYYMMDD AS YYYYMMDD
                  , CASE WHEN V_PLAN_START_YYYYMMDD = AA.YYYYMMDD THEN BB.QTY ELSE 0 END AS QTY
                  , AA.CELL_PROD_SITE_ID, AA.FROM_SITE_ID  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
            FROM GT_DPMFCQB_VMI_MST_MAIN AA
            INNER JOIN (
                SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, SUM(A.QTY) AS QTY
                FROM GT_DPMFCQB_FP_STOCK_QTY A
                LEFT OUTER JOIN T_CHK_PLAN B
                ON  A.DIVISION_ID = B.DIVISION_ID
                AND A.SCM_SITE_ID = B.SCM_SITE_ID
                AND A.ITEM_ID     = B.ITEM_ID
                WHERE B.DIVISION_ID IS NULL
                GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID
            ) BB
            ON  AA.DIVISION_ID = BB.DIVISION_ID
            AND AA.SCM_SITE_ID = BB.SCM_SITE_ID
            AND AA.ITEM_ID     = BB.ITEM_ID
            AND BB.QTY > 0;

            INSERT INTO GT_DPMFCQB_VMI_MST
            ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CELL_PROD_SITE_ID, FROM_SITE_ID )  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY, A.CELL_PROD_SITE_ID, A.FROM_SITE_ID
            FROM GT_DPMFCQB_VMI_MST_MAIN A
            WHERE 1 = 1;

            INSERT INTO GT_DPMFCQB_VMI_TEMP1
            ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, ACCUM_SUM, LAST_ACCUM_SUM, CELL_PROD_SITE_ID, FROM_SITE_ID )  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY
                 , SUM(A.QTY) OVER ( PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID ORDER BY YYYYMMDD ) AS ACCUM_SUM
                 , SUM(A.QTY) OVER ( PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID ORDER BY YYYYMMDD ) - A.QTY AS LAST_ACCUM_SUM
                 , A.CELL_PROD_SITE_ID, A.FROM_SITE_ID  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
            FROM GT_DPMFCQB_VMI_MST A
            WHERE A.MEASURE = V_MEASURE  /* [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST) */
            AND A.YYYYMMDD >= V_PLAN_START_YYYYMMDD;

            INSERT INTO GT_DPMFCQB_VMI_TEMP2
            ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, ACCUM_SUM, LAST_ACCUM_SUM, CELL_PROD_SITE_ID, FROM_SITE_ID )  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY
                 , SUM(A.QTY) OVER ( PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID ORDER BY YYYYMMDD ) AS ACCUM_SUM
                 , SUM(A.QTY) OVER ( PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID ORDER BY YYYYMMDD ) - A.QTY AS LAST_ACCUM_SUM
                 , A.CELL_PROD_SITE_ID, A.FROM_SITE_ID  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
            FROM GT_DPMFCQB_VMI_MST A
            WHERE A.MEASURE = 'Vmi_In_Plan'
            AND A.YYYYMMDD >= V_PLAN_START_YYYYMMDD;

            INSERT INTO GT_DPMFCQB_VMI_TEMP_ALL
            ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, YYYYMMDD, RTF_QTY, INV, CELL_PROD_SITE_ID, FROM_SITE_ID )  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.YYYYMMDD
                 , SUM( CASE WHEN NVL(A.ACCUM_SUM,0) > NVL(B.ACCUM_SUM,0) THEN NVL(B.ACCUM_SUM,0) ELSE NVL(A.ACCUM_SUM,0) END ) - SUM( CASE WHEN NVL(A.LAST_ACCUM_SUM,0) > NVL(B.LAST_ACCUM_SUM,0) THEN NVL(B.LAST_ACCUM_SUM,0) ELSE NVL(A.LAST_ACCUM_SUM,0) END ) AS RTF_QTY
                 , SUM(NVL(B.ACCUM_SUM,0) - NVL(A.ACCUM_SUM,0)) AS INV
                 , B.CELL_PROD_SITE_ID, B.FROM_SITE_ID  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
            FROM GT_DPMFCQB_VMI_TEMP1 A  /* 'MKT_FCST' */
               , GT_DPMFCQB_VMI_TEMP2 B  /* 'Vmi_In_Plan' */
            WHERE A.DIVISION_ID = B.DIVISION_ID
            AND A.PROJECT_CODE  = B.PROJECT_CODE
            AND A.SCM_SITE_ID   = B.SCM_SITE_ID
            AND A.ITEM_ID       = B.ITEM_ID
            AND A.FCST_TYPE     = B.FCST_TYPE
            AND A.INCOTERMS     = B.INCOTERMS
            AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
            AND A.DOM_EXP       = B.DOM_EXP
            AND A.YYYYMMDD      = B.YYYYMMDD
            AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
            GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
                   , B.CELL_PROD_SITE_ID, B.FROM_SITE_ID  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
            ORDER BY A.YYYYMMDD;

            /* ---------------------------------------------------------------------------------------------------------------- */
            /* [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. */
            /* ---------------------------------------------------------------------------------------------------------------- */
            DELETE FROM GT_DPMFCQB_VMI_TEMP_ALL A
            WHERE EXISTS ( SELECT 1
                           FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, NVL(CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
                                  FROM GT_DPMFCQB_RTF_EXCEPTION_ITEM
                                  GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, NVL(CELL_PROD_SITE_ID, '-') ) B
                           WHERE A.DIVISION_ID   = B.DIVISION_ID
                           AND   A.PROJECT_CODE  = B.PROJECT_CODE
                           AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
                           AND   A.ITEM_ID       = B.ITEM_ID
                           AND   A.DOM_EXP       = B.DOM_EXP
                           AND   A.FCST_TYPE     = B.FCST_TYPE
                           AND   A.INCOTERMS     = B.INCOTERMS
                           AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
                           AND   NVL(A.CELL_PROD_SITE_ID, '-') = NVL(B.CELL_PROD_SITE_ID, '-')  /* [E20260512-000502] 81도 해당 부분을 비교하도록 수정한다. */
                           AND   A.YYYYMMDD     >= V_PLAN_START_YYYYMMDD /*-- 당주월요일*/ );

            DELETE FROM GT_DPMFCQB_MEASURE_RTF;  /* [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_RTF 초기화 */

            IF (P_DIVISION_ID = '40' AND C_EE_FN_FLAG = 'Y') THEN
                /* [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_RTF */
                INSERT INTO GT_DPMFCQB_MEASURE_RTF ( MEASURE )
                SELECT 'RTF_PR' FROM DUAL;
            ELSE
                /* [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_RTF */
                INSERT INTO GT_DPMFCQB_MEASURE_RTF ( MEASURE )
                SELECT 'RTF_PR'     FROM DUAL UNION ALL
                SELECT 'RTF_SCP'    FROM DUAL UNION ALL
                SELECT 'RTF_SYS_RP' FROM DUAL;
            END IF;

            /* [PJ2025-50188] 'VMI_INV' 삭제 START */
            DELETE FROM DM_PLN_MKT_FCST_C
            WHERE MEASURE IN ( 'VMI_Inv' )
            AND   DIVISION_ID     = P_DIVISION_ID
            AND   VERSION_NO      = P_CUT_OFF_VERSION
            AND   CUTOFF_TYPE     = C_CUTOFF_TYPE
            AND   CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
            AND EXISTS (
                    SELECT VM.DIVISION_ID
                    FROM GT_DPMFCQB_VMI_MST VM
                    WHERE 1 = 1
                    AND DM_PLN_MKT_FCST_C.DIVISION_ID   = VM.DIVISION_ID
                    AND DM_PLN_MKT_FCST_C.PROJECT_CODE  = VM.PROJECT_CODE
                    AND DM_PLN_MKT_FCST_C.SCM_SITE_ID   = VM.SCM_SITE_ID
                    AND DM_PLN_MKT_FCST_C.ITEM_ID       = VM.ITEM_ID
                    AND DM_PLN_MKT_FCST_C.DOM_EXP       = VM.DOM_EXP
                    AND DM_PLN_MKT_FCST_C.FCST_TYPE     = VM.FCST_TYPE
                    AND DM_PLN_MKT_FCST_C.INCOTERMS     = VM.INCOTERMS
                    AND DM_PLN_MKT_FCST_C.PLANT_SITE_ID = VM.PLANT_SITE_ID
                    AND DM_PLN_MKT_FCST_C.YYYYMMDD     >= V_PLAN_START_YYYYMMDD  /* 월요일 */
            );

            DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
            WHERE MEASURE IN ( 'VMI_Inv' )
            AND   DIVISION_ID     = P_DIVISION_ID
            AND   VERSION_NO      = P_CUT_OFF_VERSION
            AND   CUTOFF_TYPE     = C_CUTOFF_TYPE
            AND   CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
            AND EXISTS (
                    SELECT VM.DIVISION_ID
                    FROM GT_DPMFCQB_VMI_MST VM
                    WHERE 1 = 1
                    AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID   = VM.DIVISION_ID
                    AND CASE WHEN VM.DIVISION_ID = '40' THEN DM_PLN_CFM_MKT_DEMAND_PLAN_C.END_CUSTOMER ELSE DM_PLN_CFM_MKT_DEMAND_PLAN_C.PROJECT_CODE END = VM.PROJECT_CODE
                    AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.SCM_SITE_ID   = VM.SCM_SITE_ID
                    AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.ITEM_ID       = VM.ITEM_ID
                    AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.DOM_EXP       = VM.DOM_EXP
                    AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.FCST_TYPE     = VM.FCST_TYPE
                    AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.INCOTERMS     = VM.INCOTERMS
                    AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID = VM.PLANT_SITE_ID
                    AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.YYYYMMDD     >= V_PLAN_START_YYYYMMDD  /* 월요일 */
            );
            /* [PJ2025-50188] 'VMI_INV' 삭제 END */

            /* ---------------------------------------------------------------------------------------------------------------- */
            /* [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. */
            /* ---------------------------------------------------------------------------------------------------------------- */
            DELETE FROM GT_DPMFCQB_VMI_MST A
            WHERE EXISTS ( SELECT 1
                           FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
                                  FROM GT_DPMFCQB_RTF_EXCEPTION_ITEM
                                  GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID ) B
                           WHERE A.DIVISION_ID   = B.DIVISION_ID
                           AND   A.PROJECT_CODE  = B.PROJECT_CODE
                           AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
                           AND   A.ITEM_ID       = B.ITEM_ID
                           AND   A.DOM_EXP       = B.DOM_EXP
                           AND   A.FCST_TYPE     = B.FCST_TYPE
                           AND   A.INCOTERMS     = B.INCOTERMS
                           AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
                           AND   A.YYYYMMDD     >= V_PLAN_START_YYYYMMDD /*-- 당주월요일*/ );

            /* [PJ2025-50188] 임시테이블 #T_MEASURE_RTF MEASURE 삭제 START */
            /*  -- [PJ2025-50188] #T_MEASURE_RTF 참고
                    . EE_FN 인 경우  ( 'RTF_PR' )
                    . EE_FN 아닌 경우( 'RTF_SCP', 'RTF_SYS_RP', 'RTF_PR' )
            */
            DELETE FROM DM_PLN_MKT_FCST_C
            WHERE MEASURE IN ( SELECT MEASURE FROM GT_DPMFCQB_MEASURE_RTF )  /* [PJ2025-50188] EE_FN 분기 로직 통합처리. */
            AND   DIVISION_ID     = P_DIVISION_ID
            AND   VERSION_NO      = P_CUT_OFF_VERSION
            AND   CUTOFF_TYPE     = C_CUTOFF_TYPE
            AND   CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
            AND EXISTS (
                    SELECT VM.DIVISION_ID
                    FROM GT_DPMFCQB_VMI_MST VM
                    WHERE 1 = 1
                    AND DM_PLN_MKT_FCST_C.DIVISION_ID   = VM.DIVISION_ID
                    AND DM_PLN_MKT_FCST_C.PROJECT_CODE  = VM.PROJECT_CODE
                    AND DM_PLN_MKT_FCST_C.SCM_SITE_ID   = VM.SCM_SITE_ID
                    AND DM_PLN_MKT_FCST_C.ITEM_ID       = VM.ITEM_ID
                    AND DM_PLN_MKT_FCST_C.DOM_EXP       = VM.DOM_EXP
                    AND DM_PLN_MKT_FCST_C.FCST_TYPE     = VM.FCST_TYPE
                    AND DM_PLN_MKT_FCST_C.INCOTERMS     = VM.INCOTERMS
                    AND DM_PLN_MKT_FCST_C.PLANT_SITE_ID = VM.PLANT_SITE_ID
                    AND DM_PLN_MKT_FCST_C.YYYYMMDD     >= V_PLAN_START_YYYYMMDD  /* 월요일 */
            );

            DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
            WHERE MEASURE IN ( SELECT MEASURE FROM GT_DPMFCQB_MEASURE_RTF )  /* [PJ2025-50188] EE_FN 분기 로직 통합처리. */
            AND   DIVISION_ID     = P_DIVISION_ID
            AND   VERSION_NO      = P_CUT_OFF_VERSION
            AND   CUTOFF_TYPE     = C_CUTOFF_TYPE
            AND   CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
            AND EXISTS (
                    SELECT VM.DIVISION_ID
                    FROM GT_DPMFCQB_VMI_MST VM
                    WHERE 1 = 1
                    AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID   = VM.DIVISION_ID
                    AND CASE WHEN VM.DIVISION_ID = '40' THEN DM_PLN_CFM_MKT_DEMAND_PLAN_C.END_CUSTOMER ELSE DM_PLN_CFM_MKT_DEMAND_PLAN_C.PROJECT_CODE END = VM.PROJECT_CODE
                    AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.SCM_SITE_ID   = VM.SCM_SITE_ID
                    AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.ITEM_ID       = VM.ITEM_ID
                    AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.DOM_EXP       = VM.DOM_EXP
                    AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.FCST_TYPE     = VM.FCST_TYPE
                    AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.INCOTERMS     = VM.INCOTERMS
                    AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID = VM.PLANT_SITE_ID
                    AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.YYYYMMDD     >= V_PLAN_START_YYYYMMDD  /* 월요일 */
            );
            /* [PJ2025-50188] 임시테이블 #T_MEASURE_RTF MEASURE 삭제 END */

            /*  -- [PJ2025-50188] #T_MEASURE_RTF 참고
                    . EE_FN 인 경우  ( 'RTF_PR' )
                    . EE_FN 아닌 경우( 'RTF_SCP', 'RTF_SYS_RP', 'RTF_PR' )
            */
            INSERT INTO DM_PLN_MKT_FCST_C
                ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
                , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
            SELECT A.DIVISION_ID
                 , P_CUT_OFF_VERSION, C_CUTOFF_TYPE, C_CUTOFF_YYYYMMDD
                 , A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                 , B.MEASURE  /* [PJ2025-50188] #T_MEASURE_RTF 에서 정의된 모든 MEASURE 생성 */
                 , A.PLANT_SITE_ID, A.YYYYMMDD
                 , A.RTF_QTY AS QTY
                 , 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
            FROM  GT_DPMFCQB_VMI_TEMP_ALL A
            INNER JOIN ( SELECT MEASURE FROM GT_DPMFCQB_MEASURE_RTF ) B  /* [PJ2025-50188] EE_FN 분기 로직 통합처리. */
            ON 1 = 1  /* [PJ2025-50188] #T_MEASURE_RTF 에서 정의된 MEASURE 전체를 동일하게 생성하기 위함. */
            WHERE A.YYYYMMDD >= V_PLAN_START_YYYYMMDD
            AND   A.RTF_QTY  > 0
            UNION ALL  /* [C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용 */
            SELECT DIVISION_ID
                 , P_CUT_OFF_VERSION, C_CUTOFF_TYPE, C_CUTOFF_YYYYMMDD
                 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, 'RTF' AS MEASURE, PLANT_SITE_ID, YYYYMMDD
                 , RTF_QTY AS QTY
                 , 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
            FROM  GT_DPMFCQB_VMI_TEMP_ALL
            WHERE YYYYMMDD >= V_PLAN_START_YYYYMMDD
            AND   DIVISION_ID = '82'
            AND RTF_QTY > 0
            UNION ALL
            SELECT DIVISION_ID
                 , P_CUT_OFF_VERSION, C_CUTOFF_TYPE, C_CUTOFF_YYYYMMDD
                 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, 'VMI_Inv' AS MEASURE, PLANT_SITE_ID, YYYYMMDD
                 , INV AS QTY
                 , 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
            FROM  GT_DPMFCQB_VMI_TEMP_ALL
            WHERE YYYYMMDD >= V_PLAN_START_YYYYMMDD
            AND   DIVISION_ID = '82'
            AND INV > 0;

            INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
                ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                , PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                , INCOTERMS, MEASURE, PLANT_SITE_ID
                , CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                , ATTRIBUTE2  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
                , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE3, ATTRIBUTE4
                , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
            SELECT A.DIVISION_ID
                 , P_CUT_OFF_VERSION, C_CUTOFF_TYPE, C_CUTOFF_YYYYMMDD
                 , A.PROJECT_CODE
                 , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE '' END AS END_CUSTOMER
                 , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                 , B.MEASURE  /* [PJ2025-50188] EE_FN 분기 로직 통합처리. #T_MEASURE_RTF에서 정의된 모든 MEASURE 생성 */
                 , A.PLANT_SITE_ID
                 , NVL(A.CELL_PROD_SITE_ID,'-')  AS CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                 , A.FROM_SITE_ID                AS ATTRIBUTE2  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
                 , A.YYYYMMDD
                 , A.RTF_QTY AS QTY
                 , 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
            FROM  GT_DPMFCQB_VMI_TEMP_ALL A
            INNER JOIN ( SELECT MEASURE FROM GT_DPMFCQB_MEASURE_RTF ) B  /* [PJ2025-50188] EE_FN 분기 로직 통합처리. */
            ON 1 = 1  /* [PJ2025-50188] EE_FN 분기 로직 통합처리. #T_MEASURE_RTF 에서 정의된 MEASURE 전체를 동일하게 생성하기 위함. */
            WHERE A.YYYYMMDD >= V_PLAN_START_YYYYMMDD
            AND A.RTF_QTY    > 0
            UNION ALL  /* [C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용 */
            SELECT DIVISION_ID
                 , P_CUT_OFF_VERSION, C_CUTOFF_TYPE, C_CUTOFF_YYYYMMDD
                 , PROJECT_CODE
                 , CASE WHEN DIVISION_ID = '40' THEN PROJECT_CODE ELSE '' END AS END_CUSTOMER
                 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, 'RTF' AS MEASURE, PLANT_SITE_ID
                 , NVL(CELL_PROD_SITE_ID,'-')  AS CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                 , FROM_SITE_ID                AS ATTRIBUTE2  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
                 , YYYYMMDD
                 , RTF_QTY AS QTY
                 , 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
            FROM  GT_DPMFCQB_VMI_TEMP_ALL
            WHERE YYYYMMDD >= V_PLAN_START_YYYYMMDD
            AND   DIVISION_ID = '82'
            AND RTF_QTY > 0
            UNION ALL
            SELECT DIVISION_ID
                 , P_CUT_OFF_VERSION, C_CUTOFF_TYPE, C_CUTOFF_YYYYMMDD
                 , PROJECT_CODE
                 , CASE WHEN DIVISION_ID = '40' THEN PROJECT_CODE ELSE '' END AS END_CUSTOMER
                 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, 'VMI_Inv' AS MEASURE, PLANT_SITE_ID
                 , '-' AS CELL_PROD_SITE_ID  /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                 , '-' AS ATTRIBUTE2  /* [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 */
                 , YYYYMMDD
                 , INV AS QTY
                 , 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
            FROM  GT_DPMFCQB_VMI_TEMP_ALL
            WHERE YYYYMMDD >= V_PLAN_START_YYYYMMDD
            AND   DIVISION_ID = '82'
            AND INV > 0;
        END IF;
        /* ------------------------------------------------------------------------------------------------------------------- VMI재고 확인후 RTF 생성 로직 (END) */

        /* ------------------------------------------------------------------------------------------------------------------- AS RTF 생성 프로시저 호출 */
        PR_DM_DNM_CREATE_C_WS_RTF(P_DIVISION_ID, P_CUT_OFF_VERSION);

        /* ------------------------------------------------------------------------------------------------------------------- MKT_FCST CUTOFF QTY_BALANCE_CREATE (START) */
        /* [PJ2025-50188] 임시테이블 #T2_MKT_FCST ==> #T_MF_C_BALANCE_MKT_FCST 변경 (GTT 사전생성) */
        IF P_DIVISION_ID = '40' THEN
            INSERT INTO GT_DPMFCQB_MF_C_BALANCE_MKT_FCST  /* [PJ2025-50188] 임시테이블 #T2_MKT_FCST ==> #T_MF_C_BALANCE_MKT_FCST 변경 */
            ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
            , CELL_PROD_SITE_ID  /* [PJ2025-50188]추가 */
            , MEASURE, YYYYMMDD, QTY )
            SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
                 , CELL_PROD_SITE_ID  /* [PJ2025-50188]추가 */
                 , MEASURE, YYYYMMDD, QTY
            FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
            WHERE DIVISION_ID     = P_DIVISION_ID
            AND   VERSION_NO      = P_CUT_OFF_VERSION
            AND   CUTOFF_TYPE     = C_CUTOFF_TYPE
            AND   CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
            AND   YYYYMMDD       >= V_PLAN_START_YYYYMMDD
            AND MEASURE IN ('MKT_FCST','RTF_SCP');  /* 해당 MEASURE로 국한하지 않으면, MKT_AMT_KRW로 인해 OVERFLOW 발생 가능함. */
        ELSE
            INSERT INTO GT_DPMFCQB_MF_C_BALANCE_MKT_FCST  /* [PJ2025-50188] 임시테이블 #T2_MKT_FCST ==> #T_MF_C_BALANCE_MKT_FCST 변경 */
            ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
            , CELL_PROD_SITE_ID  /* [PJ2025-50188]추가 */
            , MEASURE, YYYYMMDD, QTY )
            SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
                 , '-'                AS CELL_PROD_SITE_ID  /* [PJ2025-50188]추가 */
                 , MEASURE, YYYYMMDD, QTY
            FROM DM_PLN_MKT_FCST_C
            WHERE DIVISION_ID     = P_DIVISION_ID
            AND   VERSION_NO      = P_CUT_OFF_VERSION
            AND   CUTOFF_TYPE     = C_CUTOFF_TYPE
            AND   CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
            AND   YYYYMMDD       >= V_PLAN_START_YYYYMMDD
            AND MEASURE IN ('MKT_FCST','RTF_SCP');  /* 해당 MEASURE로 국한하지 않으면, MKT_AMT_KRW로 인해 OVERFLOW 발생 가능함. */
        END IF;

        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. */
        /* ---------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_DPMFCQB_MF_C_BALANCE_MKT_FCST A
        WHERE EXISTS ( SELECT 1
                       FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, NVL(CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
                              FROM GT_DPMFCQB_RTF_EXCEPTION_ITEM
                              GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, NVL(CELL_PROD_SITE_ID, '-') ) B
                       WHERE A.DIVISION_ID   = B.DIVISION_ID
                       AND   A.PROJECT_CODE  = B.PROJECT_CODE
                       AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
                       AND   A.ITEM_ID       = B.ITEM_ID
                       AND   A.DOM_EXP       = B.DOM_EXP
                       AND   A.FCST_TYPE     = B.FCST_TYPE
                       AND   A.INCOTERMS     = B.INCOTERMS
                       AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
                       AND   NVL(A.CELL_PROD_SITE_ID, '-') = NVL(B.CELL_PROD_SITE_ID, '-')  /* [E20260512-000502] 81도 해당 부분을 비교하도록 수정한다. */
                       AND   A.YYYYMMDD     >= V_PLAN_START_YYYYMMDD /*-- 당주월요일*/
                       AND   A.VERSION_NO    = P_CUT_OFF_VERSION );

        INSERT INTO GT_DPMFCQB_CUTOFF_MST
            ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE, YYYYMMDD, QTY
            , CELL_PROD_SITE_ID )  /* [PJ2025-50188] 추가 */
        SELECT ZZ.DIVISION_ID, ZZ.PROJECT_CODE, ZZ.SCM_SITE_ID, ZZ.ITEM_ID, ZZ.DOM_EXP, ZZ.FCST_TYPE, ZZ.INCOTERMS, ZZ.PLANT_SITE_ID, ZZ.MEASURE, ZZ.YYYYMMDD, MAX(NVL(C.QTY,0))
             , ZZ.CELL_PROD_SITE_ID  /* [PJ2025-50188] 추가 */
        FROM
         (
          SELECT *
          FROM
          (
            SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                        ,   A.CELL_PROD_SITE_ID  /* [PJ2025-50188] 추가 */
                FROM GT_DPMFCQB_MF_C_BALANCE_MKT_FCST A WHERE 1 = 1  /* [PJ2025-50188] 임시테이블 #T2_MKT_FCST ==> #T_MF_C_BALANCE_MKT_FCST 변경 */
                    AND   A.MEASURE          IN ('MKT_FCST','RTF_SCP')
                    AND   A.QTY               > 0
                    AND   A.DIVISION_ID       = P_DIVISION_ID
                    AND   A.VERSION_NO        = P_CUT_OFF_VERSION
                    AND   A.CUTOFF_TYPE       = C_CUTOFF_TYPE
                    AND   A.CUTOFF_YYYYMMDD   = C_CUTOFF_YYYYMMDD
           ) TARGET_DATA
           ,(
            SELECT 'MKT_FCST' AS MEASURE FROM DUAL
            UNION ALL
            SELECT 'RTF_SCP' AS MEASURE FROM DUAL
           ) MEASURE
            ,       (
                    SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
                        FROM SCM_SYS_CALENDAR_M C
                        WHERE C.BASIS_YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + V_PLAN_WEEK_CNT * 7, 'YYYYMMDD')  /* SCP PLANNING 구간이 52주 */
                    ) DS
            ) ZZ
            LEFT JOIN GT_DPMFCQB_MF_C_BALANCE_MKT_FCST C  /* [PJ2025-50188] 임시테이블 #T2_MKT_FCST ==> #T_MF_C_BALANCE_MKT_FCST 변경 */
                                            ON  ZZ.DIVISION_ID     = C.DIVISION_ID
                                            AND ZZ.PROJECT_CODE    = C.PROJECT_CODE
                                            AND ZZ.SCM_SITE_ID     = C.SCM_SITE_ID
                                            AND ZZ.ITEM_ID         = C.ITEM_ID
                                            AND ZZ.DOM_EXP         = C.DOM_EXP
                                            AND ZZ.FCST_TYPE       = C.FCST_TYPE
                                            AND ZZ.INCOTERMS       = C.INCOTERMS
                                            AND ZZ.PLANT_SITE_ID   = C.PLANT_SITE_ID
                                            AND ZZ.MEASURE         = C.MEASURE
                                            AND ZZ.YYYYMMDD        = C.YYYYMMDD
                                            AND ZZ.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID
                                            AND C.DIVISION_ID      = P_DIVISION_ID
                                            AND C.VERSION_NO       = P_CUT_OFF_VERSION
                                            AND C.CUTOFF_TYPE      = C_CUTOFF_TYPE
                                            AND C.CUTOFF_YYYYMMDD  = C_CUTOFF_YYYYMMDD
        GROUP BY ZZ.DIVISION_ID, ZZ.PROJECT_CODE, ZZ.SCM_SITE_ID, ZZ.ITEM_ID, ZZ.DOM_EXP, ZZ.FCST_TYPE, ZZ.INCOTERMS, ZZ.PLANT_SITE_ID, ZZ.MEASURE, ZZ.YYYYMMDD
               , ZZ.CELL_PROD_SITE_ID;  /* [PJ2025-50188] 추가 */

        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. */
        /* ---------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_DPMFCQB_CUTOFF_MST A
        WHERE EXISTS ( SELECT 1
                       FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, NVL(CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
                              FROM GT_DPMFCQB_RTF_EXCEPTION_ITEM
                              GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, NVL(CELL_PROD_SITE_ID, '-') ) B
                       WHERE A.DIVISION_ID   = B.DIVISION_ID
                       AND   A.PROJECT_CODE  = B.PROJECT_CODE
                       AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
                       AND   A.ITEM_ID       = B.ITEM_ID
                       AND   A.DOM_EXP       = B.DOM_EXP
                       AND   A.FCST_TYPE     = B.FCST_TYPE
                       AND   A.INCOTERMS     = B.INCOTERMS
                       AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
                       AND   NVL(A.CELL_PROD_SITE_ID, '-') = NVL(B.CELL_PROD_SITE_ID, '-')  /* [E20260512-000502] 81도 해당 부분을 비교하도록 수정한다. */
                       AND   A.YYYYMMDD     >= V_PLAN_START_YYYYMMDD /*-- 당주월요일*/ );

        /* [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건 - 선박BIZ건--- START */
        /* BALANCE_MAKE MEASURE 생성 배제 */
        DELETE FROM GT_DPMFCQB_CUTOFF_MST
        WHERE DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
        AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y');
        /* [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건 - 선박BIZ건--- END */

        INSERT INTO GT_DPMFCQB_CUTOFF_MST_ACCUM
        (       DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, YYYYMMDD
              , MEASURE, QTY
              , CELL_PROD_SITE_ID  /* [PJ2025-50188] 추가 */
              , ACCUM_SUM
        )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, YYYYMMDD
              , MEASURE, QTY
              , CELL_PROD_SITE_ID  /* [PJ2025-50188] 추가 */
              , SUM(QTY) OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE, CELL_PROD_SITE_ID ORDER BY YYYYMMDD ) AS ACCUM_SUM  /* [PJ2025-50188] CELL_PROD_SITE_ID 추가 */
        FROM GT_DPMFCQB_CUTOFF_MST;

        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. */
        /* ---------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_DPMFCQB_CUTOFF_MST_ACCUM A
        WHERE EXISTS ( SELECT 1
                       FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, NVL(CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
                              FROM GT_DPMFCQB_RTF_EXCEPTION_ITEM
                              GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, NVL(CELL_PROD_SITE_ID, '-') ) B
                       WHERE A.DIVISION_ID   = B.DIVISION_ID
                       AND   A.PROJECT_CODE  = B.PROJECT_CODE
                       AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
                       AND   A.ITEM_ID       = B.ITEM_ID
                       AND   A.DOM_EXP       = B.DOM_EXP
                       AND   A.FCST_TYPE     = B.FCST_TYPE
                       AND   A.INCOTERMS     = B.INCOTERMS
                       AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
                       AND   NVL(A.CELL_PROD_SITE_ID, '-') = NVL(B.CELL_PROD_SITE_ID, '-')  /* [E20260512-000502] 81도 해당 부분을 비교하도록 수정한다. */
                       AND   A.YYYYMMDD     >= V_PLAN_START_YYYYMMDD /*-- 당주월요일*/ );

        INSERT INTO GT_DPMFCQB_CUTOFF_TEMPX
        (
              DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE, YYYYMMDD
            , CELL_PROD_SITE_ID
            , ACCUM_X
        )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, 'BALANCE' AS MEASURE, YYYYMMDD
              , CELL_PROD_SITE_ID  /* [PJ2025-50188] 추가 */
              , SUM( CASE WHEN MEASURE = 'MKT_FCST' THEN 0 ELSE ACCUM_SUM END ) - SUM( CASE WHEN MEASURE = 'MKT_FCST' THEN ACCUM_SUM ELSE 0 END ) AS ACCUM_X
        FROM GT_DPMFCQB_CUTOFF_MST_ACCUM
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, YYYYMMDD
              , CELL_PROD_SITE_ID;  /* [PJ2025-50188] 추가 */

        /* ---------------------------------------------------------------------------------------------------------------- */
        /* [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. */
        /* ---------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_DPMFCQB_CUTOFF_TEMPX A
        WHERE EXISTS ( SELECT 1
                       FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, NVL(CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
                              FROM GT_DPMFCQB_RTF_EXCEPTION_ITEM
                              GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, NVL(CELL_PROD_SITE_ID, '-') ) B
                       WHERE A.DIVISION_ID   = B.DIVISION_ID
                       AND   A.PROJECT_CODE  = B.PROJECT_CODE
                       AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
                       AND   A.ITEM_ID       = B.ITEM_ID
                       AND   A.DOM_EXP       = B.DOM_EXP
                       AND   A.FCST_TYPE     = B.FCST_TYPE
                       AND   A.INCOTERMS     = B.INCOTERMS
                       AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
                       AND   NVL(A.CELL_PROD_SITE_ID, '-') = NVL(B.CELL_PROD_SITE_ID, '-')  /* [E20260512-000502] 81도 해당 부분을 비교하도록 수정한다. */
                       AND   A.YYYYMMDD     >= V_PLAN_START_YYYYMMDD /*-- 당주월요일*/ );

        /* -------------------------------- 초기화 (START) */
        DELETE FROM DM_PLN_MKT_FCST_C
        WHERE MEASURE       = 'BALANCE'
        AND   DIVISION_ID     = P_DIVISION_ID
        AND   VERSION_NO      = P_CUT_OFF_VERSION
        AND   CUTOFF_TYPE     = C_CUTOFF_TYPE
        AND   CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD;
        /* -------------------------------- 초기화 (END) */

        /* -------------------------------- 계산된 BALANCE값 INSERT (START) */
        INSERT INTO DM_PLN_MKT_FCST_C
            ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
            , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
            , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
            , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
        SELECT DIVISION_ID, P_CUT_OFF_VERSION, C_CUTOFF_TYPE, C_CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, 'BALANCE' AS MEASURE, PLANT_SITE_ID, YYYYMMDD
             , SUM(ACCUM_X) AS ACCUM_X  /* [PJ2025-50188] 40 사업부의 경우 CELL_PROD_SITE_ID 단위로 구분되어 있으므로 SUM으로 처리함. */
             , 'BALANCE_MAKE', SYSDATE, 'BALANCE_MAKE', SYSDATE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        FROM  GT_DPMFCQB_CUTOFF_TEMPX
        WHERE 1 = 1
            AND ACCUM_X BETWEEN -9999999999 AND 9999999999  /* 오버플로우 예방 */
            AND ACCUM_X <> 0  /* ZERO 값은 불필요 */
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, YYYYMMDD;
        /* -------------------------------- 계산된 BALANCE값 INSERT (END) */

        IF P_DIVISION_ID = '40' THEN
            /* -------------------------------- 초기화 (START) */
            DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
            WHERE MEASURE       = 'BALANCE'
            AND   DIVISION_ID     = P_DIVISION_ID
            AND   VERSION_NO      = P_CUT_OFF_VERSION
            AND   CUTOFF_TYPE     = C_CUTOFF_TYPE
            AND   CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD;
            /* -------------------------------- 초기화 (END) */

            /* -------------------------------- 계산된 BALANCE값 INSERT (START) */
            INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
                ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                , PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                , INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
                , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
                , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
            SELECT DIVISION_ID, P_CUT_OFF_VERSION, C_CUTOFF_TYPE, C_CUTOFF_YYYYMMDD
                 , PROJECT_CODE, PROJECT_CODE AS END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, 'BALANCE' AS MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, ACCUM_X
                 , 'BALANCE_MAKE', SYSDATE, 'BALANCE_MAKE', SYSDATE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
            FROM  GT_DPMFCQB_CUTOFF_TEMPX
            WHERE 1 = 1
                AND ACCUM_X BETWEEN -9999999999 AND 9999999999  /* 오버플로우 예방 */
                AND ACCUM_X <> 0;  /* ZERO 값은 불필요 */
            /* -------------------------------- 계산된 BALANCE값 INSERT (END) */
        END IF;
        /* ------------------------------------------------------------------------------------------------------------------- MKT_FCST CUTOFF QTY_BALANCE_CREATE (END) */

        /* ------------------------------------------------------------------------------------------------------------------- VMI DIO 계산로직 (START) */
        /* [변환주의] 원본 VMI_DIO QTY = DATEDIFF(DAY, a.yyyymmdd, (스칼라서브쿼리 MIN(yyyymmdd) WHERE 누적SUM(QTY) OVER(ORDER BY yyyymmdd) >= a.qty)). */
        /* Oracle 은 인라인뷰(zz)의 상관참조(a) 불가 -> 윈도우 누적합을 '상관 경계합'(a.yyyymmdd < c.yyyymmdd <= b.yyyymmdd) 으로 재구성(시맨틱 동일). */
        /* DATEDIFF(DAY) 는 정수 일수차 -> (min_date - a.yyyymmdd). ISNULL(...,999) -> NVL(...,999). */
        IF P_DIVISION_ID = '40' THEN
            /* 수행전 삭제 */
            DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
            WHERE MEASURE = 'VMI_DIO'
            AND   DIVISION_ID     = P_DIVISION_ID
            AND   VERSION_NO      = P_CUT_OFF_VERSION
            AND   CUTOFF_TYPE     = C_CUTOFF_TYPE
            AND   CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD;

            /* VMI_DIO INSERT */
            INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
            (    DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
               , PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
               , INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE  /* [PJ2025-50017] 추가 */
               , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
               , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
            SELECT DISTINCT
                     A.DIVISION_ID
                    ,A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
                    ,A.PROJECT_CODE
                    ,A.END_CUSTOMER
                    ,A.SCM_SITE_ID
                    ,A.ITEM_ID
                    ,A.DOM_EXP
                    ,A.FCST_TYPE
                    ,A.INCOTERMS
                    ,'VMI_DIO' AS MEASURE
                    ,A.PLANT_SITE_ID
                    ,A.CELL_PROD_SITE_ID  /* [PJ2025-50017] 추가 */
                    ,A.YYYYMMDD
                    ,NVL( TO_DATE( ( SELECT MIN(B.YYYYMMDD)
                                     FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C B
                                     WHERE A.DIVISION_ID     = B.DIVISION_ID
                                       AND A.PROJECT_CODE    = B.PROJECT_CODE
                                       AND A.END_CUSTOMER    = B.END_CUSTOMER
                                       AND A.SCM_SITE_ID     = B.SCM_SITE_ID
                                       AND A.ITEM_ID         = B.ITEM_ID
                                       AND A.DOM_EXP         = B.DOM_EXP
                                       AND A.FCST_TYPE       = B.FCST_TYPE
                                       AND A.INCOTERMS       = B.INCOTERMS
                                       AND A.PLANT_SITE_ID   = B.PLANT_SITE_ID
                                       AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID  /* [PJ2025-50017] 추가 */
                                       AND B.MEASURE         = 'RTF_SCP'
                                       AND B.YYYYMMDD        > A.YYYYMMDD
                                       AND B.DIVISION_ID     = P_DIVISION_ID
                                       AND B.VERSION_NO      = P_CUT_OFF_VERSION
                                       AND B.CUTOFF_TYPE     = C_CUTOFF_TYPE
                                       AND B.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
                                       AND ( SELECT SUM(C.QTY)
                                             FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C C
                                             WHERE C.DIVISION_ID     = A.DIVISION_ID
                                               AND C.PROJECT_CODE    = A.PROJECT_CODE
                                               AND C.END_CUSTOMER    = A.END_CUSTOMER
                                               AND C.SCM_SITE_ID     = A.SCM_SITE_ID
                                               AND C.ITEM_ID         = A.ITEM_ID
                                               AND C.DOM_EXP         = A.DOM_EXP
                                               AND C.FCST_TYPE       = A.FCST_TYPE
                                               AND C.INCOTERMS       = A.INCOTERMS
                                               AND C.PLANT_SITE_ID   = A.PLANT_SITE_ID
                                               AND C.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID
                                               AND C.MEASURE         = 'RTF_SCP'
                                               AND C.YYYYMMDD        > A.YYYYMMDD
                                               AND C.YYYYMMDD       <= B.YYYYMMDD
                                               AND C.DIVISION_ID     = P_DIVISION_ID
                                               AND C.VERSION_NO      = P_CUT_OFF_VERSION
                                               AND C.CUTOFF_TYPE     = C_CUTOFF_TYPE
                                               AND C.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD ) >= A.QTY
                                   ), 'YYYYMMDD')
                          - TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 999 ) AS QTY
                    ,A.CREATED_BY
                    ,A.CREATION_DATE
--                    ,A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
                    ,A.LAST_UPDATED_BY, SYSDATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
                    ,A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
            FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
            INNER JOIN GT_DPMFCQB_VMI_MST_MAIN S
                ON (        A.DIVISION_ID     = S.DIVISION_ID
                        AND A.PROJECT_CODE    = S.PROJECT_CODE
                        AND A.SCM_SITE_ID     = S.SCM_SITE_ID
                        AND A.ITEM_ID         = S.ITEM_ID
                        AND A.DOM_EXP         = S.DOM_EXP
                        AND A.FCST_TYPE       = S.FCST_TYPE
                        AND A.INCOTERMS       = S.INCOTERMS
                        AND A.PLANT_SITE_ID   = S.PLANT_SITE_ID
                        AND A.CELL_PROD_SITE_ID = S.CELL_PROD_SITE_ID  /* [PJ2025-50017] 추가 */
                        AND A.YYYYMMDD       >= V_PLAN_START_YYYYMMDD  /* 월요일 */
                        )
            WHERE 1 = 1
            AND A.MEASURE = 'VMI_Inv'
            AND A.QTY > 0
            AND A.DIVISION_ID     = P_DIVISION_ID
            AND A.VERSION_NO      = P_CUT_OFF_VERSION
            AND A.CUTOFF_TYPE     = C_CUTOFF_TYPE
            AND A.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD;
        ELSE
            /* 수행전 삭제 */
            DELETE FROM DM_PLN_MKT_FCST_C
            WHERE MEASURE = 'VMI_DIO'
            AND   DIVISION_ID     = P_DIVISION_ID
            AND   VERSION_NO      = P_CUT_OFF_VERSION
            AND   CUTOFF_TYPE     = C_CUTOFF_TYPE
            AND   CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD;

            /* VMI_DIO INSERT */
            INSERT INTO DM_PLN_MKT_FCST_C
            (    DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
               , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
               , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
               , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
               , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
            SELECT DISTINCT
                     A.DIVISION_ID
                    ,A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
                    ,A.PROJECT_CODE
                    ,A.SCM_SITE_ID
                    ,A.ITEM_ID
                    ,A.DOM_EXP
                    ,A.FCST_TYPE
                    ,A.INCOTERMS
                    ,'VMI_DIO' AS MEASURE
                    ,A.PLANT_SITE_ID
                    ,A.YYYYMMDD
                    ,NVL( TO_DATE( ( SELECT MIN(B.YYYYMMDD)
                                     FROM DM_PLN_MKT_FCST_C B
                                     WHERE A.DIVISION_ID     = B.DIVISION_ID
                                       AND A.PROJECT_CODE    = B.PROJECT_CODE
                                       AND A.SCM_SITE_ID     = B.SCM_SITE_ID
                                       AND A.ITEM_ID         = B.ITEM_ID
                                       AND A.DOM_EXP         = B.DOM_EXP
                                       AND A.FCST_TYPE       = B.FCST_TYPE
                                       AND A.INCOTERMS       = B.INCOTERMS
                                       AND A.PLANT_SITE_ID   = B.PLANT_SITE_ID
                                       AND B.MEASURE         = 'RTF_SCP'
                                       AND B.YYYYMMDD        > A.YYYYMMDD
                                       AND B.DIVISION_ID     = P_DIVISION_ID
                                       AND B.VERSION_NO      = P_CUT_OFF_VERSION
                                       AND B.CUTOFF_TYPE     = C_CUTOFF_TYPE
                                       AND B.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD
                                       AND ( SELECT SUM(C.QTY)
                                             FROM DM_PLN_MKT_FCST_C C
                                             WHERE C.DIVISION_ID     = A.DIVISION_ID
                                               AND C.PROJECT_CODE    = A.PROJECT_CODE
                                               AND C.SCM_SITE_ID     = A.SCM_SITE_ID
                                               AND C.ITEM_ID         = A.ITEM_ID
                                               AND C.DOM_EXP         = A.DOM_EXP
                                               AND C.FCST_TYPE       = A.FCST_TYPE
                                               AND C.INCOTERMS       = A.INCOTERMS
                                               AND C.PLANT_SITE_ID   = A.PLANT_SITE_ID
                                               AND C.MEASURE         = 'RTF_SCP'
                                               AND C.YYYYMMDD        > A.YYYYMMDD
                                               AND C.YYYYMMDD       <= B.YYYYMMDD
                                               AND C.DIVISION_ID     = P_DIVISION_ID
                                               AND C.VERSION_NO      = P_CUT_OFF_VERSION
                                               AND C.CUTOFF_TYPE     = C_CUTOFF_TYPE
                                               AND C.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD ) >= A.QTY
                                   ), 'YYYYMMDD')
                          - TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 999 ) AS QTY
                    ,A.CREATED_BY
                    ,A.CREATION_DATE
--                    ,A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
                    ,A.LAST_UPDATED_BY, SYSDATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
                    ,A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
            FROM DM_PLN_MKT_FCST_C A
            INNER JOIN GT_DPMFCQB_VMI_MST_MAIN S
                ON (        A.DIVISION_ID     = S.DIVISION_ID
                        AND A.PROJECT_CODE    = S.PROJECT_CODE
                        AND A.SCM_SITE_ID     = S.SCM_SITE_ID
                        AND A.ITEM_ID         = S.ITEM_ID
                        AND A.DOM_EXP         = S.DOM_EXP
                        AND A.FCST_TYPE       = S.FCST_TYPE
                        AND A.INCOTERMS       = S.INCOTERMS
                        AND A.PLANT_SITE_ID   = S.PLANT_SITE_ID
                        AND A.YYYYMMDD       >= V_PLAN_START_YYYYMMDD  /* 월요일 */
                        )
            WHERE 1 = 1
            AND A.MEASURE = 'VMI_Inv'
            AND A.QTY > 0
            AND A.DIVISION_ID     = P_DIVISION_ID
            AND A.VERSION_NO      = P_CUT_OFF_VERSION
            AND A.CUTOFF_TYPE     = C_CUTOFF_TYPE
            AND A.CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD;
        END IF;
        /* ------------------------------------------------------------------------------------------------------------------- VMI DIO 계산로직 (END) */
        /* ------------------------------------------------------------------------------------------------------------------- Sales Plan  Cutoff 정보 변경 (END) */
        /* 트랜잭션 (COMMIT) : 부모 proc이 소유 -> 본문 COMMIT 제거 */
        /* COMMIT WORK; */


    /* ------------------------------------------------------------------------------------------ */
    EXCEPTION
    /* ------------------------------------------------------------------------------------------ */
    WHEN OTHERS THEN
        /* 트랜잭션 (END) : 부모 proc이 ROLLBACK 소유 -> 본문 ROLLBACK 제거 */
        /* ROLLBACK TRANSACTION MKT_FCST_C_QTY_BALANCE_CREATE; */
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        D_EVENT_DATE  := SYSDATE;
        DBMS_OUTPUT.PUT_LINE('[' || SQLCODE || ']' || SQLERRM);   /*-- 에러메시지 DISPLAY --*/
        /* [C20200909-000203] LOG 표준화 적용 : 로깅표준 10인자 (6코어 + 진단4 : 입력파라미터 JSON / SQLCODE / SQLERRM / BACKTRACE) */
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE
                           , JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID, 'p_cut_off_version' VALUE P_CUT_OFF_VERSION RETURNING VARCHAR2(4000 CHAR))
                           , SQLCODE, SQLERRM, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        /* 재변환 로깅표준 : 에러 재발생(배치 잡 실패 감지). 에러경로 END LOG 생략(정상경로 END LOG만 실행). */
        RAISE_APPLICATION_ERROR(-20001, '[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '@p_division_id : ' || RTRIM(LTRIM(P_DIVISION_ID)) || ' / ' || '@p_cut_off_version : ' || RTRIM(LTRIM(P_CUT_OFF_VERSION));
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);


    IF V_LOG_TYPE = 'INVALID' THEN
        V_LOG_MESSAGE := '########## END of procedure ##########';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END IF;

END;
/
