PACKAGE BODY PKG_SCP0031
IS
/*
 * Program ID   : PKG_SCP0031
 * Description  : SCP0031 Global PSI
 * Program History
 *===================================================================================================
 * Date         In Charge		Description
 *===================================================================================================
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.06   AJS          조회 속도 개선 : 품목 뷰(SCM_MST_FINAL_ITEM_V) 외부조인에 조회 사업부 조건 추가 - 전 사업부 뷰 전개(약 26만 블록) 제거
 * 2026.10.20   AJS          Material · Nick Name 대소문자 무시 · Nick Name 쉼표 복수 조회 · 표시 칸 채움값 「/」 → 「-」(AS-IS 원문 값)
 * 2026.10.20   AJS          Cell Type 정렬값 : 품목의 CELL_TYPE 이 비면 400000 (AS-IS 빈 문자 분기 재현)
 * 2026.10.21   AJS          Team 부서 : 행 품목의 부서(사이트·품목 원장) 우선, 없으면 사이트 대표 부서
 */

    /* AS-IS 피벗 집계에서 되풀이되는 MEASURE 목록 */
    C_MEASURE_BAL    CONSTANT VARCHAR2(200) := '''MODEL_INVENTORY'',''WH_IN_BALANCE'',''BALANCE'',''CHAR_AVAILABLE'',''ACTIVATE_PROGRESS'',''SAFETY_STOCK'',''GAP'',''DIO''';
    C_MEASURE_NOTIN  CONSTANT VARCHAR2(240) := '''MODEL_INVENTORY'',''WH_IN_BALANCE'',''BALANCE'',''CHAR_AVAILABLE'',''ACTIVATE_PROGRESS'',''LINE_TOTAL_LOAD_ENGINE'',''SAFETY_STOCK'',''GAP'',''DIO''';

    PROCEDURE P_SCP0031_GET_GLOBAL_PSI
    (
        P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_FROM_SITE             IN  VARCHAR2
      , P_TO_SITE               IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_PLAN_TYPE             IN  VARCHAR2
      , P_SEQ                   IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_BUCKET                IN  VARCHAR2        --2021/12/14  p_chk_all 추가
      , P_CHK_ALL               IN  VARCHAR2        -- 2021/12/14 :  체크 시 bucket='daily' 조회
      , P_DEBUG_MODE            IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
/*
 * Program ID   : SCP0031_GET_GLOBAL_PSI
 * Description  : GLOBAL PSI 조회
 * Program History
 *===================================================================================================
 * Date         In Charge		Description
 *===================================================================================================
 * 2018/09/12	hwyoon		              Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/09/18	hwyoon		              아이템 ID/NICKNAME 조회조건 변경
 * 2018/09/20	hwyoon		              CELL/PACK 세트 조회로직 변경
 * 2018/09/27	hwyoon		              쿼리 성능 개선
 * 2018/11/09	hwyoon		              measure 조회(Invetory) 수정
 * 2018/11/19	hwyoon		              qty numeric(20,10)로 타입 수정
 * 2018/11/21	hwyoon		              LINE_TOTAL_LOAD_ENGINE measure 추가
 * 2018/11/22	hwyoon		              LINE_TOTAL_LOAD_ENGINE 출력오류 수정
 * 2018/11/29	hwyoon		              measure 출력순서조정(PRODJCTION, LINE_TOTAL_LOAD_ENGINE, SHIP_REQ, SHIP_PLAN 강제 셋팅)
 * 2018/12/17	hwyoon		              Measure Inventory 추가 (Pack Biz기준 Cell 재고)
 * 2019/02/28	hwyoon		              [CSR ID:3931058] 화면 Measure 색상 변경 건
 * 2019/04/29	hwyoon		              [CSR ID:3979166] GSCM Global PSI 및 simulator 과거구간 반영요청의 건
 * 2019/06/11	hwyoon		              [CSR ID:4023208] GSCM 시스템 개선 요청 - 라인가동율 산출로직 변경
 * 2019/08/26	hwyoon		              [CSR ID:4077274] 자체개선 - SCP 3개 메뉴 기능보완(Global PSI, Project Route, Master Validation) - From Site, To Site 조회조건 '-' 추가
 * 2019/10/21	hwyoon		              오류수정 - 출하실적 조회 시 "삭제" 수량 제외 r.EXFACTORY_STATUS IN ('D20','D30','D40')
 * 2019/12/12	hwyoon		              UI Category 수정 - Operation Group 코드명 컬럼 추가 (Pack, Cell)
 * 2021/03/23	PJG                       C20210319-000345  Global PSI UI 개선 요청: 국가 or 팀별로 생산량이 보일 수 있게 요청 (TEAM 컬럼 추가)
 * 2021/05/13   khj79                     [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - BOD LT 1단계 개발(LT_DAY 변경을 위한 scp_mst_bod_v 로 변경 )
 * 2021/07/15   khj79		              [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 개발 : scp_mst_bod_v=> scp_mst_bod_n_v
 * 2021/11/19   KDW                       [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - SQL튜닝 반영
 * 2021/12/14   KDW                       [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - p_chk_all 추가 ( 체크 시 bucket='daily' 조회)
 * 2022/01/20   khj79                     PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - BOM Explosion > Sort 우선 순위 적용 > P (DC_LINK) ->  P(NOT DC_LINK) -> A -> E
 * 2022/03/24   chaan           V1.5      VMI 안전재고설정 추가
 * 2022/04/29   chaan		              81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 2022/06/16   jahn1501                  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - BOD L/T History 변경 (SCP_MST_BOD_N_V -> SCP_ANL_BOD_N_V_PLAN_H)
 * 2023/04/10   LWY			              PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 * 2023/06/13   vadabi3		              PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - [활성화] Final Item) Cell Type 기준 Sort 적용
 * 2023/07/11   vadabi3		              PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 특정 Measure) Monthly, Weekly Last Value 적용 개선
 * 2023/10/10   vadabi3		              PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 82주 개선
 * 2024-01-08   chaan           V1.1.12   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선
 * 2024-01-19   chaan           V1.1.13   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선 - 2차 튜닝
 ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  EXEC SCP0031_GET_GLOBAL_PSI @p_from_yyyymmdd='20180910'
							 ,@p_to_yyyymmdd='20190908'
							 ,@p_division_id='81'
							 ,@p_item_id=''
							 ,@p_nick_name=''
							 ,@p_from_site=''
							 ,@p_to_site=''
							 ,@p_plan_start_yyyymmdd='20180910'
							 ,@p_plan_type='PR'
							 ,@p_seq='1'
							 ,@p_program_id='SCP0031'
							 ,@p_sheet_name='Global PSI'
							 ,@p_user_id='hwwoonins'
							 ,@debug_mode='T'

 */
    -- CREATE PROCEDURE [dbo].[SCP0031_GET_GLOBAL_PSI]

        V_CNT_USR_MEASURE    VARCHAR2(1)   := '0';   /* AS-IS 는 NVARCHAR(1) 이라 10 이상이면 앞 한 자리만 남는다 */
        V_FROM_YYYYMMDD      VARCHAR2(32);
        V_TO_YYYYMMDD        VARCHAR2(32);
        V_FROM_RESULT        VARCHAR2(32);
        V_TO_RESULT          VARCHAR2(32);
        V_BUCKET             VARCHAR2(10)  := P_BUCKET;
        V_SEQ                NUMBER        := TO_NUMBER(P_SEQ);
        V_QRY_SUM            CLOB;
        V_QRY_PIVOT          CLOB;    /* PIVOT IN 목록 */    --  2026.10.29 AJS
        V_EXEC               CLOB;
        V_EE_YN              VARCHAR2(1)   := 'N';   /* 조회 사업부가 EE 계열인지 */
        V_ERR_MSG            VARCHAR2(4000);
        V_QRY_PIVOT_CNT      NUMBER        := 0;    /* PIVOT IN 목록 개수 */    --  2026.10.29 AJS

    BEGIN

        --DECLARE @p_from_yyyymmdd			NVARCHAR(8)		= N'20240101';
        --DECLARE @p_to_yyyymmdd				NVARCHAR(8)		= N'20241229';
        --DECLARE @p_division_id              NVARCHAR(30)	= N'81';
        --DECLARE @p_item_id					NVARCHAR(MAX)	= N'';
        --DECLARE @p_nick_name				NVARCHAR(MAX)	= N'';
        --DECLARE @p_from_site				NVARCHAR(MAX)	= N'';
        --DECLARE @p_to_site					NVARCHAR(MAX)	= N'';
        --DECLARE @p_plan_start_yyyymmdd		NVARCHAR(8)		= N'20240101';
        --DECLARE @p_plan_type				NVARCHAR(50)	= N'PR';
        --DECLARE @p_seq						NVARCHAR(50)	= N'1';
        --DECLARE @p_program_id				NVARCHAR(MAX)	= N'SCP0031';
        --DECLARE @p_sheet_name				NVARCHAR(MAX)	= N'Global PSI';
        --DECLARE @p_user_id					NVARCHAR(MAX)	= N'iamarock';
        --DECLARE @p_bucket				    NVARCHAR(10)	= N'DAILY';
        --DECLARE @p_chk_all				    NVARCHAR(1)		= N'N';
        --DECLARE @debug_mode					NVARCHAR(1)		= N'F';

        /********************************************************************************
         * 임시테이블만들기 - 조회조건 테이블
         ********************************************************************************/
        /* 세션에 남은 임시 자료 정리 */
        DELETE GT_SCP0031_NICKITEM;
        DELETE GT_SCP0031_RANK;
        DELETE GT_SCP0031_ITEM;
        DELETE GT_SCP0031_MEASURE;
        /********************************************************************************
         * 임시테이블만들기 - 본 테이블
         ********************************************************************************/
        DELETE GT_SCP0031_MAIN;
        --생산실적, 출하실적 용
        DELETE GT_SCP0031_RESULT;
        DELETE GT_SCP0031_LOADBASE;
        --로드률 용
        DELETE GT_SCP0031_LOAD;
        DELETE GT_SCP0031_FNL;

        SELECT SUBSTR(TO_CHAR(NVL((SELECT COUNT(*)
                                     FROM SCM_MST_TITLESET_USER
                                    WHERE 1          = 1
                                      AND PROGRAM_ID = P_PROGRAM_ID
                                      AND SHEET_NAME = P_SHEET_NAME
                                      AND USER_ID    = P_USER_ID), 0)), 1, 1)
          INTO V_CNT_USR_MEASURE
          FROM DUAL;

        BEGIN
            SELECT C.BASIS_START_DATE
              INTO V_FROM_YYYYMMDD
              FROM SCM_SYS_CALENDAR_M C
             WHERE 1                = 1
               AND C.BASIS_YYYYMMDD = P_PLAN_START_YYYYMMDD;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_FROM_YYYYMMDD := NULL;
        END;

        BEGIN
            SELECT C.BASIS_START_DATE
              INTO V_FROM_RESULT
              FROM SCM_SYS_CALENDAR_M C
             WHERE 1                = 1
               AND C.BASIS_YYYYMMDD = P_FROM_YYYYMMDD;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_FROM_RESULT := NULL;
        END;

        BEGIN
            SELECT C.BASIS_START_DATE
              INTO V_TO_RESULT
              FROM SCM_SYS_CALENDAR_M C
             WHERE 1                = 1
               AND C.BASIS_YYYYMMDD = P_TO_YYYYMMDD;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_TO_RESULT := NULL;
        END;

        /* AS-IS 변수 초기값이 빈 문자라 미조회 시에도 비교가 성립한다. NVL 로 같은 분기를 태운다 */
        IF NVL(V_FROM_YYYYMMDD, ' ') > NVL(V_FROM_RESULT, ' ') THEN
            -- 실적 보여줌
            V_TO_YYYYMMDD := P_TO_YYYYMMDD;
            V_TO_RESULT   := V_FROM_YYYYMMDD;
        ELSIF NVL(V_FROM_YYYYMMDD, ' ') <= NVL(V_FROM_RESULT, ' ') THEN
            -- 실적 없음
            V_TO_YYYYMMDD := P_TO_YYYYMMDD;
            V_FROM_RESULT := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), 6), 'YYYYMMDD');
            V_TO_RESULT   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');
        END IF;
        /* AS-IS 의 나머지 두 분기(> v_to_result · = v_to_result)는 위 두 조건이 전 구간을 덮어 도달하지 않는다. 원문 유지 */

        --2021/12/14 Start
        IF P_CHK_ALL = 'Y' THEN
            V_BUCKET := 'DAILY';   -- 2021/12/14
        END IF;
        --2021/12/14 End

        --IF @p_division_id NOT IN ('EE','EE_UC')
        SELECT CASE WHEN EXISTS (SELECT 1
                                   FROM TABLE(FN_GET_DIVISION_DIV('EE')) --div_commonization
                                  WHERE COLUMN_VALUE = P_DIVISION_ID) THEN 'Y' ELSE 'N' END
          INTO V_EE_YN
          FROM DUAL;

        /* NICK NAME 조회조건으로 ITEM 추출 */
        INSERT
          INTO GT_SCP0031_NICKITEM
             ( ITEM_ID)
        SELECT DISTINCT ITEM_ID
               --	FROM SCM_MST_ITEM_SN
          FROM SCM_MST_ITEM_SN
         WHERE 1 = 1
           AND NICK_NAME IS NOT NULL
           AND TRIM(P_NICK_NAME) IS NOT NULL
               --	AND @p_nick_name != ''
               -- 2026.10.20 AJS 별칭 대소문자 무시 · 쉼표 복수 조회 (START)
               --         AND NICK_NAME LIKE P_NICK_NAME || '%';
           AND EXISTS (SELECT 1
                         FROM TABLE(UF_FX_STRING_SPLIT(P_NICK_NAME, ',')) SA
                        WHERE TRIM(SA.TOKEN) IS NOT NULL
                          AND UPPER(NICK_NAME) LIKE UPPER(TRIM(SA.TOKEN))||'%');
        -- 2026.10.20 AJS 별칭 대소문자 무시 · 쉼표 복수 조회 (END)

        /* PSI CELL/PACK ITEM 세트 */
        INSERT
          INTO GT_SCP0031_RANK
             ( CELL_ITEM_ID
             , ITEM_ID
             , RANK_NO)
        SELECT CELL_ITEM_ID
             , ITEM_ID
             , RANK() OVER (ORDER BY CELL_ITEM_ID ASC) AS RANK_NO
          FROM SCP_ANL_PSI_GLOBAL
         WHERE DIVISION_ID         = P_DIVISION_ID
           AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND PLAN_TYPE           = P_PLAN_TYPE
           AND SEQ                 = V_SEQ
           AND YYYYMMDD            >= P_FROM_YYYYMMDD
           AND YYYYMMDD            <= P_TO_YYYYMMDD
         GROUP BY CELL_ITEM_ID
                , ITEM_ID;

        /* 조회조건에 해당하는 세트 모두 추출 */
        INSERT
          INTO GT_SCP0031_ITEM
             ( CELL_ITEM_ID
             , ITEM_ID)
        SELECT A.CELL_ITEM_ID
             , A.ITEM_ID
          FROM GT_SCP0031_RANK A
         WHERE A.RANK_NO IN (SELECT B.RANK_NO
                               FROM GT_SCP0031_RANK B
                              WHERE 1 = 1
                                AND (
                                     --                        ( B.ITEM_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_ITEM_ID, ','))) )    --  2026.10.20 AJS
                                     (UPPER(B.ITEM_ID) IN (SELECT UPPER(TRIM(TOKEN))
                                                             FROM TABLE(UF_FX_STRING_SPLIT(P_ITEM_ID, ',')))) --  2026.10.20 AJS
                                     OR (B.ITEM_ID IN (SELECT ITEM_ID
                                                         FROM GT_SCP0031_NICKITEM))
                                     --                        ( B.CELL_ITEM_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_ITEM_ID, ','))) )    --  2026.10.20 AJS
                                     OR (UPPER(B.CELL_ITEM_ID) IN (SELECT UPPER(TRIM(TOKEN))
                                                                     FROM TABLE(UF_FX_STRING_SPLIT(P_ITEM_ID, ',')))) --  2026.10.20 AJS
                                     OR (B.CELL_ITEM_ID IN (SELECT ITEM_ID
                                                              FROM GT_SCP0031_NICKITEM))));

        /* 유저 MEASURE 세팅값 추출 */ --로드율은 PRODUCTION과 동일한 SORT 값을 강제 셋팅
        INSERT
          INTO GT_SCP0031_MEASURE
             ( COLUMN_NAME
             , COLUMN_LABEL_NAME
             , SORT_ORDER_NO
             , ATTRIBUTE3)
        SELECT M.COLUMN_NAME
             , M.COLUMN_LABEL_NAME
             , CASE WHEN M.COLUMN_NAME = 'LINE_TOTAL_LOAD_ENGINE' AND TO_NUMBER(V_CNT_USR_MEASURE) > 0 THEN NVL((SELECT T.SORT_ORDER_NO
                                                                                                                   FROM SCM_MST_TITLESET_USER T
                                                                                                                  WHERE T.PROGRAM_ID  = M.PROGRAM_ID
                                                                                                                    AND T.SHEET_NAME  = M.SHEET_NAME
                                                                                                                    AND T.COLUMN_NAME = 'PRODUCTION'
                                                                                                                    AND T.USER_ID     = U.USER_ID), U.SORT_ORDER_NO)
                    WHEN M.COLUMN_NAME = 'LINE_TOTAL_LOAD_ENGINE' AND TO_NUMBER(V_CNT_USR_MEASURE) = 0 THEN P.SORT_ORDER_NO
                    WHEN M.COLUMN_NAME = 'SHIP_PLAN' AND TO_NUMBER(V_CNT_USR_MEASURE) > 0 THEN NVL((SELECT T.SORT_ORDER_NO
                                                                                                      FROM SCM_MST_TITLESET_USER T
                                                                                                     WHERE T.PROGRAM_ID  = M.PROGRAM_ID
                                                                                                       AND T.SHEET_NAME  = M.SHEET_NAME
                                                                                                       AND T.COLUMN_NAME = 'SHIP_REQ'
                                                                                                       AND T.USER_ID     = U.USER_ID), U.SORT_ORDER_NO)
                    WHEN M.COLUMN_NAME = 'SHIP_PLAN' AND TO_NUMBER(V_CNT_USR_MEASURE) = 0 THEN S.SORT_ORDER_NO
                    ELSE NVL(U.SORT_ORDER_NO, M.SORT_ORDER_NO)
                END AS SORT_ORDER_NO
             , M.ATTRIBUTE3 --MEASURE 별 COLOR RGB코드
          FROM SCM_MST_SHEET_MEASURE M
             , SCM_MST_TITLESET_USER U
             , SCM_MST_SHEET_MEASURE P
             , SCM_MST_SHEET_MEASURE S
         WHERE U.PROGRAM_ID(+)  = M.PROGRAM_ID
           AND U.SHEET_NAME(+)  = M.SHEET_NAME
           AND U.COLUMN_NAME(+) = M.COLUMN_NAME
           AND U.USER_ID(+)     = P_USER_ID
           AND P.PROGRAM_ID(+)  = M.PROGRAM_ID
           AND P.SHEET_NAME(+)  = M.SHEET_NAME
           AND P.COLUMN_NAME(+) = 'PRODUCTION'
           AND S.PROGRAM_ID(+)  = M.PROGRAM_ID
           AND S.SHEET_NAME(+)  = M.SHEET_NAME
           AND S.COLUMN_NAME(+) = 'SHIP_REQ'
           AND M.PROGRAM_ID     = 'SCP0031'
           AND M.VALID_YN       = 'Y'
           AND (TO_NUMBER(V_CNT_USR_MEASURE) = 0 OR NVL(U.SORT_ORDER_NO, 0) > 0);

        /********************************************************************************
         * 데이타조회, 임시테이블에 저장
         ********************************************************************************/
        /* AS-IS 는 조회조건 유무에 따라 문장을 조립했다. 조건별 정적 SQL 로 옮긴다 */
        --생산/출하 실적 Temp Table
        IF TRIM(P_ITEM_ID) IS NOT NULL OR TRIM(P_NICK_NAME) IS NOT NULL THEN

            INSERT
              INTO GT_SCP0031_MAIN
                 ( DIVISION_ID
                 , OPERATION_GROUP
                 , CELL_ITEM_ID
                 , ITEM_ID
                 , TO_SITE
                 , TO_SITE2
                 , TO_BOH_QTY
                 , FROM_BOH_QTY
                 , INCOTERMS
                 , FROM_SITE
                 , TRANSPORT_MODE_LINE
                 , MEASURE
                 , B_YYYYMMDD
                 , YYYYMMDD
                 , YYYYMM
                 , QTY
                 , ISO_WEEK
                 , SORT_ORDER_NO
                 , COLUMN_LABEL_NAME
                 , BOD_ID
                 , ATTRIBUTE9
                 , ATTRIBUTE10
                 , ATTRIBUTE3)
            SELECT A.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.CELL_ITEM_ID
                 , A.ITEM_ID
                   --               , NVL(NULLIF(A.TO_SITE, ''), '/') AS TO_SITE    --  2026.10.20 AJS
                 , NVL(NULLIF(A.TO_SITE, ''), '-') AS TO_SITE --  2026.10.20 AJS
                   --               , CASE WHEN SUBSTR(NVL(NULLIF(A.TO_SITE, ''), '/'), -2) = '-S' THEN SUBSTR(NVL(NULLIF(A.TO_SITE, ''), '/'), 1, LENGTH(RTRIM(NVL(NULLIF(A.TO_SITE, ''), '/'))) - 2) ELSE NVL(NULLIF(A.TO_SITE, ''), '/') END AS TO_SITE2    --  2026.10.20 AJS
                 , CASE WHEN SUBSTR(NVL(NULLIF(A.TO_SITE, ''), '-'), -2) = '-S' THEN SUBSTR(NVL(NULLIF(A.TO_SITE, ''), '-'), 1, LENGTH(RTRIM(NVL(NULLIF(A.TO_SITE, ''), '-'))) - 2) ELSE NVL(NULLIF(A.TO_SITE, ''), '-') END AS TO_SITE2 --  2026.10.20 AJS
                 , A.TO_BOH_QTY
                 , A.FROM_BOH_QTY
                 , A.INCOTERMS
                 , A.FROM_SITE
                 , A.TRANSPORT_MODE_LINE
                 , A.MEASURE
                 , A.YYYYMMDD AS B_YYYYMMDD
                 , 'D_'||A.YYYYMMDD AS YYYYMMDD
                 , O.BASIS_YYYYMM AS YYYYMM
                 , NVL(A.QTY, 0) AS QTY
                 , SUBSTR(O.BASIS_YYYYMM, -4)||O.ISO_WEEK AS ISO_WEEK
                   --SET @mEXEC = @mEXEC + '			, ISNULL(U.sort_order_no, M.SORT_ORDER_NO) SORT_ORDER_NO'+CHAR(10);
                 , M.SORT_ORDER_NO
                 , M.COLUMN_LABEL_NAME
                 , A.BOD_ID
                 , A.ATTRIBUTE9 -- OPERATION ID
                 , A.ATTRIBUTE10 -- P:1, A:2
                 , M.ATTRIBUTE3 -- UI용 MEASURE COLOR
              FROM SCP_ANL_PSI_GLOBAL A
                 , SCM_SYS_CALENDAR_M O
                 , GT_SCP0031_MEASURE M
                 , GT_SCP0031_ITEM I
             WHERE A.YYYYMMDD            = O.BASIS_YYYYMMDD
               AND M.COLUMN_NAME         = A.MEASURE
               AND A.CELL_ITEM_ID        = I.CELL_ITEM_ID
               AND A.ITEM_ID             = I.ITEM_ID
               AND A.DIVISION_ID         = P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = V_SEQ
               AND A.YYYYMMDD            >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD            <= P_TO_YYYYMMDD
               AND (TO_NUMBER(V_CNT_USR_MEASURE) = 0 OR NVL(M.SORT_ORDER_NO, 0) > 0)
                   --             AND ( TRIM(P_FROM_SITE) IS NULL OR NVL(NULLIF(A.FROM_SITE, ''), '/') IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_FROM_SITE, ','))) )    --  2026.10.20 AJS
               -- 2026.10.23 AJS From/To Site ALL = 조건 없음 (START)
               --AND (TRIM(P_FROM_SITE) IS NULL OR NVL(NULLIF(A.FROM_SITE, ''), '-') IN (SELECT TOKEN
               --                                                                          FROM TABLE(UF_FX_STRING_SPLIT(P_FROM_SITE, ',')))) --  2026.10.20 AJS
               AND (TRIM(P_FROM_SITE) IS NULL
                    OR UPPER(TRIM(P_FROM_SITE)) = 'ALL'
                    OR NVL(NULLIF(A.FROM_SITE, ''), '-') IN (SELECT TOKEN
                                                               FROM TABLE(UF_FX_STRING_SPLIT(P_FROM_SITE, ','))))
                   --             AND ( TRIM(P_TO_SITE)   IS NULL OR NVL(NULLIF(A.TO_SITE, ''), '/')   IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_TO_SITE, ','))) );    --  2026.10.20 AJS
               --AND (TRIM(P_TO_SITE) IS NULL OR NVL(NULLIF(A.TO_SITE, ''), '-') IN (SELECT TOKEN
               --                                                                      FROM TABLE(UF_FX_STRING_SPLIT(P_TO_SITE, ','))));    --  2026.10.20 AJS
               AND (TRIM(P_TO_SITE) IS NULL
                    OR UPPER(TRIM(P_TO_SITE)) = 'ALL'
                    OR NVL(NULLIF(A.TO_SITE, ''), '-') IN (SELECT TOKEN
                                                             FROM TABLE(UF_FX_STRING_SPLIT(P_TO_SITE, ','))));
               -- 2026.10.23 AJS From/To Site ALL = 조건 없음 (END)

        ELSE

            INSERT
              INTO GT_SCP0031_MAIN
                 ( DIVISION_ID
                 , OPERATION_GROUP
                 , CELL_ITEM_ID
                 , ITEM_ID
                 , TO_SITE
                 , TO_SITE2
                 , TO_BOH_QTY
                 , FROM_BOH_QTY
                 , INCOTERMS
                 , FROM_SITE
                 , TRANSPORT_MODE_LINE
                 , MEASURE
                 , B_YYYYMMDD
                 , YYYYMMDD
                 , YYYYMM
                 , QTY
                 , ISO_WEEK
                 , SORT_ORDER_NO
                 , COLUMN_LABEL_NAME
                 , BOD_ID
                 , ATTRIBUTE9
                 , ATTRIBUTE10
                 , ATTRIBUTE3)
            SELECT A.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.CELL_ITEM_ID
                 , A.ITEM_ID
                   --               , NVL(NULLIF(A.TO_SITE, ''), '/') AS TO_SITE    --  2026.10.20 AJS
                 , NVL(NULLIF(A.TO_SITE, ''), '-') AS TO_SITE --  2026.10.20 AJS
                   --               , CASE WHEN SUBSTR(NVL(NULLIF(A.TO_SITE, ''), '/'), -2) = '-S' THEN SUBSTR(NVL(NULLIF(A.TO_SITE, ''), '/'), 1, LENGTH(RTRIM(NVL(NULLIF(A.TO_SITE, ''), '/'))) - 2) ELSE NVL(NULLIF(A.TO_SITE, ''), '/') END AS TO_SITE2    --  2026.10.20 AJS
                 , CASE WHEN SUBSTR(NVL(NULLIF(A.TO_SITE, ''), '-'), -2) = '-S' THEN SUBSTR(NVL(NULLIF(A.TO_SITE, ''), '-'), 1, LENGTH(RTRIM(NVL(NULLIF(A.TO_SITE, ''), '-'))) - 2) ELSE NVL(NULLIF(A.TO_SITE, ''), '-') END AS TO_SITE2 --  2026.10.20 AJS
                 , A.TO_BOH_QTY
                 , A.FROM_BOH_QTY
                 , A.INCOTERMS
                 , A.FROM_SITE
                 , A.TRANSPORT_MODE_LINE
                 , A.MEASURE
                 , A.YYYYMMDD AS B_YYYYMMDD
                 , 'D_'||A.YYYYMMDD AS YYYYMMDD
                 , O.BASIS_YYYYMM AS YYYYMM
                 , NVL(A.QTY, 0) AS QTY
                 , SUBSTR(O.BASIS_YYYYMM, -4)||O.ISO_WEEK AS ISO_WEEK
                   --SET @mEXEC = @mEXEC + '			, ISNULL(U.sort_order_no, M.SORT_ORDER_NO) SORT_ORDER_NO'+CHAR(10);
                 , M.SORT_ORDER_NO
                 , M.COLUMN_LABEL_NAME
                 , A.BOD_ID
                 , A.ATTRIBUTE9 -- OPERATION ID
                 , A.ATTRIBUTE10 -- P:1, A:2
                 , M.ATTRIBUTE3 -- UI용 MEASURE COLOR
              FROM SCP_ANL_PSI_GLOBAL A
                 , SCM_SYS_CALENDAR_M O
                 , GT_SCP0031_MEASURE M
             WHERE A.YYYYMMDD            = O.BASIS_YYYYMMDD
               AND M.COLUMN_NAME         = A.MEASURE
               AND A.DIVISION_ID         = P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = V_SEQ
               AND A.YYYYMMDD            >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD            <= P_TO_YYYYMMDD
               AND (TO_NUMBER(V_CNT_USR_MEASURE) = 0 OR NVL(M.SORT_ORDER_NO, 0) > 0)
                   --             AND ( TRIM(P_FROM_SITE) IS NULL OR NVL(NULLIF(A.FROM_SITE, ''), '/') IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_FROM_SITE, ','))) )    --  2026.10.20 AJS
               -- 2026.10.23 AJS From/To Site ALL = 조건 없음 (START)
               --AND (TRIM(P_FROM_SITE) IS NULL OR NVL(NULLIF(A.FROM_SITE, ''), '-') IN (SELECT TOKEN
               --                                                                          FROM TABLE(UF_FX_STRING_SPLIT(P_FROM_SITE, ',')))) --  2026.10.20 AJS
               AND (TRIM(P_FROM_SITE) IS NULL
                    OR UPPER(TRIM(P_FROM_SITE)) = 'ALL'
                    OR NVL(NULLIF(A.FROM_SITE, ''), '-') IN (SELECT TOKEN
                                                               FROM TABLE(UF_FX_STRING_SPLIT(P_FROM_SITE, ','))))
                   --             AND ( TRIM(P_TO_SITE)   IS NULL OR NVL(NULLIF(A.TO_SITE, ''), '/')   IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_TO_SITE, ','))) );    --  2026.10.20 AJS
               --AND (TRIM(P_TO_SITE) IS NULL OR NVL(NULLIF(A.TO_SITE, ''), '-') IN (SELECT TOKEN
               --                                                                      FROM TABLE(UF_FX_STRING_SPLIT(P_TO_SITE, ','))));    --  2026.10.20 AJS
               AND (TRIM(P_TO_SITE) IS NULL
                    OR UPPER(TRIM(P_TO_SITE)) = 'ALL'
                    OR NVL(NULLIF(A.TO_SITE, ''), '-') IN (SELECT TOKEN
                                                             FROM TABLE(UF_FX_STRING_SPLIT(P_TO_SITE, ','))));
               -- 2026.10.23 AJS From/To Site ALL = 조건 없음 (END)

        END IF;

        -----------------------------------------------------------
        -- DEBUG QRY 출력
        -----------------------------------------------------------

        /********************************************************************************
         * 1. Line Load(%) Temp
         ********************************************************************************/
        INSERT
          INTO GT_SCP0031_LOADBASE
             ( DIVISION_ID
             , OPERATION_GROUP
             , FROM_SITE
             , ATTRIBUTE9
             , TRANSPORT_MODE_LINE
             , SUM_LOAD_QTY
             , QTY
             , WORKING_TIME
             , B_YYYYMMDD
             , YYYYMM
             , ISO_WEEK
             , WEEK_YYYYMMDD
             , MONTH_YYYYMMDD)
        SELECT A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , A.ATTRIBUTE9
             , A.TRANSPORT_MODE_LINE
             , ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0) AS SUM_LOAD_QTY
             , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0 ELSE NVL(((ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0) / D.WORKING_TIME)), 0) * 100 END AS QTY
             , D.WORKING_TIME
             , A.YYYYMMDD AS B_YYYYMMDD
             , O.BASIS_YYYYMM AS YYYYMM
             , O.ISO_WEEK
             , 'W_'||O.BASIS_YYYYMM||O.ISO_WEEK AS WEEK_YYYYMMDD
             , 'M_'||O.BASIS_YYYYMM AS MONTH_YYYYMMDD
          FROM SCP_ANL_PSI_GLOBAL A
             , SCM_SYS_CALENDAR_M O
             , SCM_MST_SHEET_MEASURE M
             , SCP_ANL_WORKING_TIME D
             , SCP_ANL_TACT_TIME E
         WHERE A.YYYYMMDD            = O.BASIS_YYYYMMDD
           AND M.PROGRAM_ID          = P_PROGRAM_ID
           AND M.COLUMN_NAME         = A.MEASURE
           AND A.DIVISION_ID         = D.DIVISION_ID
           AND A.ATTRIBUTE9          = D.OPERATION_ID
           AND A.FROM_SITE           = D.SCM_SITE_ID
           AND A.TRANSPORT_MODE_LINE = D.LINE_ID
           AND A.YYYYMMDD            = D.YYYYMMDD
           AND A.DIVISION_ID         = E.DIVISION_ID
           AND A.ATTRIBUTE9          = E.OPERATION_ID
           AND A.FROM_SITE           = E.SCM_SITE_ID
           AND A.TRANSPORT_MODE_LINE = E.LINE_ID
           AND (CASE WHEN A.OPERATION_GROUP = 'P' THEN A.ITEM_ID ELSE A.CELL_ITEM_ID END) = E.ITEM_ID
           AND A.YYYYMMDD            = E.YYYYMMDD
           AND A.DIVISION_ID         = P_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = P_PLAN_TYPE
           AND A.SEQ                 = V_SEQ
           AND A.YYYYMMDD            >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD            <= P_TO_YYYYMMDD
               --AND (@v_cnt_usr_measure = 0 OR ISNULL(U.sort_order_no,0)>0)
           AND (TO_NUMBER(V_CNT_USR_MEASURE) = 0 OR NVL(M.SORT_ORDER_NO, 0) > 0)
           AND A.MEASURE = 'PRODUCTION' -- 6초 75712행
         GROUP BY A.DIVISION_ID
                , A.OPERATION_GROUP
                , A.FROM_SITE
                , A.ATTRIBUTE9
                , A.TRANSPORT_MODE_LINE
                , A.YYYYMMDD
                , O.BASIS_YYYYMM
                , O.ISO_WEEK
                , D.WORKING_TIME;

        /********************************************************************************
         * 2. 과거 실적구간 temp
         ********************************************************************************/
        IF V_FROM_RESULT < V_TO_RESULT THEN

            INSERT
              INTO GT_SCP0031_RESULT
                 ( DIVISION_ID
                 , OPERATION_GROUP
                 , CELL_ITEM_ID
                 , ITEM_ID
                 , TO_SITE
                 , TO_SITE2
                 , TO_BOH_QTY
                 , FROM_BOH_QTY
                 , INCOTERMS
                 , FROM_SITE
                 , TRANSPORT_MODE_LINE
                 , MEASURE
                 , SORT_ORDER_NO
                 , COLUMN_LABEL_NAME
                 , BOD_ID
                 , ATTRIBUTE9
                 , ATTRIBUTE10
                 , ATTRIBUTE3)
            SELECT DISTINCT A.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.CELL_ITEM_ID
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.TO_SITE2
                 , A.TO_BOH_QTY
                 , A.FROM_BOH_QTY
                 , A.INCOTERMS
                 , A.FROM_SITE
                 , A.TRANSPORT_MODE_LINE
                 , A.MEASURE
                 , A.SORT_ORDER_NO
                 , A.COLUMN_LABEL_NAME
                 , A.BOD_ID
                 , A.ATTRIBUTE9
                 , A.ATTRIBUTE10
                 , A.ATTRIBUTE3
              FROM GT_SCP0031_MAIN A
             WHERE A.MEASURE IN ('PRODUCTION', 'SHIP_PLAN', 'ALLOCATION');    --2초

        END IF;

        -- Line Load(%) Insert
        INSERT
          INTO GT_SCP0031_LOAD
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , TO_SITE2
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , MEASURE
             , B_YYYYMMDD
             , YYYYMMDD
             , YYYYMM
             , QTY
             , ISO_WEEK
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE9
             , ATTRIBUTE10
             , ATTRIBUTE3
             , SUM_LOAD_QTY
             , WORKING_TIME
             , WEEK_YYYYMMDD
             , MONTH_YYYYMMDD)
        SELECT A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , A.TO_SITE
             , A.TO_SITE2
             , A.TO_BOH_QTY
             , A.FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
             , A.TRANSPORT_MODE_LINE
             , 'LINE_TOTAL_LOAD_ENGINE' AS MEASURE
             , A.B_YYYYMMDD
             , A.YYYYMMDD
             , A.YYYYMM
             , B.QTY
             , A.ISO_WEEK
               --, ISNULL(U.sort_order_no, M.SORT_ORDER_NO) SORT_ORDER_NO -- 수정
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , A.BOD_ID
             , A.ATTRIBUTE9
             , A.ATTRIBUTE10
             , M.ATTRIBUTE3
             , B.SUM_LOAD_QTY
             , B.WORKING_TIME
             , B.WEEK_YYYYMMDD
             , B.MONTH_YYYYMMDD
          FROM GT_SCP0031_MAIN A
             , GT_SCP0031_LOADBASE B
             , GT_SCP0031_MEASURE M
         WHERE A.DIVISION_ID         = B.DIVISION_ID
           AND A.OPERATION_GROUP     = B.OPERATION_GROUP
           AND A.FROM_SITE           = B.FROM_SITE
           AND A.ATTRIBUTE9          = B.ATTRIBUTE9
           AND A.TRANSPORT_MODE_LINE = B.TRANSPORT_MODE_LINE
           AND A.B_YYYYMMDD          = B.B_YYYYMMDD
           AND M.COLUMN_NAME         = 'LINE_TOTAL_LOAD_ENGINE';

	/*
	INSERT INTO #TblDynamicPivot_SCP0031
	SELECT A.DIVISION_ID
		   , A.OPERATION_GROUP
		   , A.CELL_ITEM_ID
		   , A.ITEM_ID
		   , A.TO_SITE
		   , A.TO_BOH_QTY
		   , A.FROM_BOH_QTY
		   , A.INCOTERMS
		   , A.FROM_SITE
		   , A.TRANSPORT_MODE_LINE
		   , 'LINE_TOTAL_LOAD_ENGINE' MEASURE
		   , A.B_yyyymmdd
		   , A.yyyymmdd
		   , A.yyyymm
		   , B.qty
		   , A.iso_week
		   --, ISNULL(U.sort_order_no, M.SORT_ORDER_NO) SORT_ORDER_NO -- 수정
		   , M.sort_order_no
		   , M.COLUMN_LABEL_NAME
		   , A.BOD_ID
		   , A.ATTRIBUTE9
		   , A.ATTRIBUTE10
		   , M.ATTRIBUTE3
	FROM #TblDynamicPivot_SCP0031 A WITH(NOLOCK)
	JOIN #TblDynamicPivot_SCP0031_TEMP B WITH(NOLOCK)
		ON A.DIVISION_ID=B.DIVISION_ID
		AND A.OPERATION_GROUP = B.OPERATION_GROUP
		AND A.FROM_SITE=B.FROM_SITE
		AND A.ATTRIBUTE9 = B.ATTRIBUTE9
		AND A.TRANSPORT_MODE_LINE = B.TRANSPORT_MODE_LINE
		AND A.B_yyyymmdd = B.B_yyyymmdd
	INNER JOIN #TblDynamicPivot_SCP0031_MEASURE M WITH(NOLOCK) ON M.COLUMN_NAME='LINE_TOTAL_LOAD_ENGINE'
	;
	*/

        --Load율 개선(Daily)
        INSERT
          INTO GT_SCP0031_MAIN
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , TO_SITE2
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , MEASURE
             , B_YYYYMMDD
             , YYYYMMDD
             , YYYYMM
             , QTY
             , ISO_WEEK
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE9
             , ATTRIBUTE10
             , ATTRIBUTE3)
        SELECT A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , A.TO_SITE
             , A.TO_SITE2
             , A.TO_BOH_QTY
             , A.FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
             , A.TRANSPORT_MODE_LINE
             , A.MEASURE
             , A.B_YYYYMMDD
             , A.YYYYMMDD
             , A.YYYYMM
             , A.QTY
             , A.ISO_WEEK
             , A.SORT_ORDER_NO
             , A.COLUMN_LABEL_NAME
             , A.BOD_ID
             , A.ATTRIBUTE9
             , A.ATTRIBUTE10
             , A.ATTRIBUTE3
          FROM GT_SCP0031_LOAD A;

        --Load율 개선(Week)
        INSERT
          INTO GT_SCP0031_MAIN
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , TO_SITE2
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , MEASURE
             , B_YYYYMMDD
             , YYYYMMDD
             , YYYYMM
             , QTY
             , ISO_WEEK
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE9
             , ATTRIBUTE10
             , ATTRIBUTE3)
        SELECT DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , TO_SITE2
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , MEASURE
             , '-' AS B_YYYYMMDD
             , WEEK_YYYYMMDD AS YYYYMMDD
             , '/' AS YYYYMM
             , CASE WHEN SUM(WORKING_TIME) <= 0.0 THEN 0 ELSE NVL((SUM(SUM_LOAD_QTY) / SUM(WORKING_TIME)), 0) * 100 END AS QTY
             , '-' AS ISO_WEEK
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE9
             , ATTRIBUTE10
             , ATTRIBUTE3
          FROM GT_SCP0031_LOAD
         GROUP BY DIVISION_ID
                , OPERATION_GROUP
                , CELL_ITEM_ID
                , ITEM_ID
                , TO_SITE
                , TO_SITE2
                , TO_BOH_QTY
                , FROM_BOH_QTY
                , INCOTERMS
                , FROM_SITE
                , TRANSPORT_MODE_LINE
                , MEASURE
                , SORT_ORDER_NO
                , COLUMN_LABEL_NAME
                , BOD_ID
                , ATTRIBUTE9
                , ATTRIBUTE10
                , ATTRIBUTE3
                , WEEK_YYYYMMDD
                , MONTH_YYYYMMDD;

        --Load율 개선(Month)
        INSERT
          INTO GT_SCP0031_MAIN
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , TO_SITE2
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , MEASURE
             , B_YYYYMMDD
             , YYYYMMDD
             , YYYYMM
             , QTY
             , ISO_WEEK
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE9
             , ATTRIBUTE10
             , ATTRIBUTE3)
        SELECT DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , TO_SITE2
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , MEASURE
             , '-' AS B_YYYYMMDD
             , MONTH_YYYYMMDD AS YYYYMMDD
             , '/' AS YYYYMM
             , CASE WHEN SUM(WORKING_TIME) <= 0.0 THEN 0 ELSE NVL((SUM(SUM_LOAD_QTY) / SUM(WORKING_TIME)), 0) * 100 END AS QTY
             , '-' AS ISO_WEEK
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE9
             , ATTRIBUTE10
             , ATTRIBUTE3
          FROM GT_SCP0031_LOAD
         GROUP BY DIVISION_ID
                , OPERATION_GROUP
                , CELL_ITEM_ID
                , ITEM_ID
                , TO_SITE
                , TO_SITE2
                , TO_BOH_QTY
                , FROM_BOH_QTY
                , INCOTERMS
                , FROM_SITE
                , TRANSPORT_MODE_LINE
                , MEASURE
                , SORT_ORDER_NO
                , COLUMN_LABEL_NAME
                , BOD_ID
                , ATTRIBUTE9
                , ATTRIBUTE10
                , ATTRIBUTE3
                , MONTH_YYYYMMDD;

        -- 생산/출하/매출 실적 insert
        IF V_FROM_RESULT < V_TO_RESULT THEN

            -- 1. 생산실적 insert
            INSERT
              INTO GT_SCP0031_MAIN
                 ( DIVISION_ID
                 , OPERATION_GROUP
                 , CELL_ITEM_ID
                 , ITEM_ID
                 , TO_SITE
                 , TO_SITE2
                 , TO_BOH_QTY
                 , FROM_BOH_QTY
                 , INCOTERMS
                 , FROM_SITE
                 , TRANSPORT_MODE_LINE
                 , MEASURE
                 , B_YYYYMMDD
                 , YYYYMMDD
                 , YYYYMM
                 , QTY
                 , ISO_WEEK
                 , SORT_ORDER_NO
                 , COLUMN_LABEL_NAME
                 , BOD_ID
                 , ATTRIBUTE9
                 , ATTRIBUTE10
                 , ATTRIBUTE3)
            SELECT DISTINCT R.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.CELL_ITEM_ID
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.TO_SITE2
                 , A.TO_BOH_QTY
                 , A.FROM_BOH_QTY
                 , A.INCOTERMS
                 , A.FROM_SITE
                 , A.TRANSPORT_MODE_LINE
                 , A.MEASURE
                 , TO_CHAR(R.PLAN_DATE, 'YYYYMMDD') AS B_YYYYMMDD
                 , 'D_'||TO_CHAR(R.PLAN_DATE, 'YYYYMMDD') AS YYYYMMDD
                 , C.BASIS_YYYYMM AS YYYYMM
                 , R.ACTUAL_GOOD_QTY AS QTY
                   --,RIGHT(c.basis_yyyymm,2)+c.iso_week AS iso_week
                 , SUBSTR(C.BASIS_YYYYMM, -4)||C.ISO_WEEK AS ISO_WEEK
                 , A.SORT_ORDER_NO
                 , A.COLUMN_LABEL_NAME
                 , A.BOD_ID
                 , A.ATTRIBUTE9
                 , A.ATTRIBUTE10
                 , A.ATTRIBUTE3
              FROM SCM_DNM_PRODUCT_RESULT_V R
                 , SCM_SYS_CALENDAR_M C
                 , SCP_MST_FINAL_ITEM B
                 , GT_SCP0031_RESULT A
             WHERE TO_CHAR(R.PLAN_DATE, 'YYYYMMDD') = C.BASIS_YYYYMMDD
               AND R.DIVISION_ID         = B.DIVISION_ID(+)
               AND R.ITEM_ID             = B.ITEM_ID(+)
               AND R.SCP_OPERATION_GROUP = B.OPERATION_GROUP(+)
               AND A.MEASURE             = 'PRODUCTION'
               AND A.DIVISION_ID         = R.DIVISION_ID
               AND A.OPERATION_GROUP     = R.SCP_OPERATION_GROUP
               AND A.FROM_SITE           = R.SCM_SITE_ID
               AND A.ITEM_ID             = R.ITEM_ID
               AND A.ATTRIBUTE9          = R.OPERATION_ID
               AND A.TRANSPORT_MODE_LINE = R.LINE_ID
               AND R.PLAN_DATE           >= TO_DATE(V_FROM_RESULT, 'YYYYMMDD')
               AND R.PLAN_DATE           < TO_DATE(V_TO_RESULT, 'YYYYMMDD')
               AND R.DIVISION_ID         = P_DIVISION_ID
               AND R.SCP_OPERATION_GROUP IN ('A', 'P')
               AND (SUBSTR(R.OPERATION_ID, 1, 5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
                                                     SELECT SEGMENT1 AS OPERATION_ID
                                                       FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                      WHERE LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                                                        AND SEGMENT1    <> 'F6000'
                                                        AND VALID_YN    = 'Y')
                    OR R.OPERATION_ID IN (--외주PACKER의 업체코드
                                          SELECT PLANT_ID AS OPERATION_ID
                                            FROM SCM_MST_SITE
                                           WHERE 1           = 1
                                             AND DIVISION_ID = P_DIVISION_ID
                                             AND SITE_TYPE   = 'PLANT'
                                             AND OSP_YN      = 'Y'
                                             AND VALID_YN    = 'Y'));

            -- 2. 출하실적 insert
            INSERT
              INTO GT_SCP0031_MAIN
                 ( DIVISION_ID
                 , OPERATION_GROUP
                 , CELL_ITEM_ID
                 , ITEM_ID
                 , TO_SITE
                 , TO_SITE2
                 , TO_BOH_QTY
                 , FROM_BOH_QTY
                 , INCOTERMS
                 , FROM_SITE
                 , TRANSPORT_MODE_LINE
                 , MEASURE
                 , B_YYYYMMDD
                 , YYYYMMDD
                 , YYYYMM
                 , QTY
                 , ISO_WEEK
                 , SORT_ORDER_NO
                 , COLUMN_LABEL_NAME
                 , BOD_ID
                 , ATTRIBUTE9
                 , ATTRIBUTE10
                 , ATTRIBUTE3)
            SELECT R.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.CELL_ITEM_ID
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.TO_SITE2
                 , A.TO_BOH_QTY
                 , A.FROM_BOH_QTY
                 , A.INCOTERMS
                 , A.FROM_SITE
                 , A.TRANSPORT_MODE_LINE
                 , A.MEASURE
                 , R.EXFACTORY_DATE AS B_YYYYMMDD
                 , 'D_'||R.EXFACTORY_DATE AS YYYYMMDD
                 , C.BASIS_YYYYMM AS YYYYMM
                 , R.EXFACTORY_QTY AS QTY
                 , SUBSTR(C.BASIS_YYYYMM, -4)||C.ISO_WEEK AS ISO_WEEK
                 , A.SORT_ORDER_NO
                 , A.COLUMN_LABEL_NAME
                 , A.BOD_ID
                 , A.ATTRIBUTE9
                 , A.ATTRIBUTE10
                 , A.ATTRIBUTE3
              FROM SCM_DNM_EXFACTORY_RESULT R
                 , SCM_SYS_CALENDAR_M C
                 , SCM_MST_SITE B
                 , GT_SCP0031_RESULT A
             WHERE R.EXFACTORY_DATE      = C.BASIS_YYYYMMDD
               AND B.SCM_SITE_ID(+)      = R.TO_SCM_SITE_ID
               AND B.SITE_TYPE(+)        = 'PLANT'
               AND A.MEASURE             = 'SHIP_PLAN'
               AND A.DIVISION_ID         = R.DIVISION_ID
               AND A.ITEM_ID             = R.ITEM_ID
               AND A.FROM_SITE           = R.FROM_SCM_SITE_ID
               AND A.TO_SITE             = R.TO_SCM_SITE_ID
               AND A.TRANSPORT_MODE_LINE = R.TRANSPORT_MODE
               AND R.EXFACTORY_DATE      >= V_FROM_RESULT
               AND R.EXFACTORY_DATE      < V_TO_RESULT
               AND R.DIVISION_ID         = P_DIVISION_ID
               AND (B.PLANT_ID IS NOT NULL OR (B.PLANT_ID IS NULL AND A.INCOTERMS = R.INCOTERMS)) -- FG의 경우 incoterms 비교
               AND R.EXFACTORY_STATUS IN ('D20', 'D30', 'D40');

            -- 3. 매출실적 insert
            INSERT
              INTO GT_SCP0031_MAIN
                 ( DIVISION_ID
                 , OPERATION_GROUP
                 , CELL_ITEM_ID
                 , ITEM_ID
                 , TO_SITE
                 , TO_SITE2
                 , TO_BOH_QTY
                 , FROM_BOH_QTY
                 , INCOTERMS
                 , FROM_SITE
                 , TRANSPORT_MODE_LINE
                 , MEASURE
                 , B_YYYYMMDD
                 , YYYYMMDD
                 , YYYYMM
                 , QTY
                 , ISO_WEEK
                 , SORT_ORDER_NO
                 , COLUMN_LABEL_NAME
                 , BOD_ID
                 , ATTRIBUTE9
                 , ATTRIBUTE10
                 , ATTRIBUTE3)
            SELECT R.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.CELL_ITEM_ID
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.TO_SITE2
                 , A.TO_BOH_QTY
                 , A.FROM_BOH_QTY
                 , A.INCOTERMS
                 , A.FROM_SITE
                 , A.TRANSPORT_MODE_LINE
                 , A.MEASURE
                 , R.YYYYMMDD AS B_YYYYMMDD
                 , 'D_'||R.YYYYMMDD AS YYYYMMDD
                 , C.BASIS_YYYYMM AS YYYYMM
                 , R.QTY AS QTY
                 , SUBSTR(C.BASIS_YYYYMM, -4)||C.ISO_WEEK AS ISO_WEEK
                 , A.SORT_ORDER_NO
                 , A.COLUMN_LABEL_NAME
                 , A.BOD_ID
                 , A.ATTRIBUTE9
                 , A.ATTRIBUTE10
                 , A.ATTRIBUTE3
              FROM DM_PLN_SALES_PLAN_RESULT R
                 , SCM_SYS_CALENDAR_M C
                   --JOIN SCM_MST_SITE b on b.scm_site_id = r.PLANT_SITE_ID and b.site_type='PLANT'
                 , GT_SCP0031_RESULT A
             WHERE R.YYYYMMDD    = C.BASIS_YYYYMMDD
               AND A.MEASURE     = 'ALLOCATION'
               AND A.DIVISION_ID = R.DIVISION_ID
               AND A.ITEM_ID     = R.ITEM_ID
               AND A.TO_SITE     = R.SCM_SITE_ID
               AND A.INCOTERMS   = R.INCOTERMS
               AND R.YYYYMMDD    >= V_FROM_RESULT
               AND R.YYYYMMDD    < V_TO_RESULT
               AND R.DIVISION_ID = P_DIVISION_ID
               AND R.MEASURE     = 'RTF';

        END IF;

        --2021/11/02 Start UI 속도 개선
        INSERT
          INTO GT_SCP0031_FNL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , TO_SITE2
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , MEASURE
             , B_YYYYMMDD
             , YYYYMMDD
             , YYYYMM
             , QTY
             , ISO_WEEK
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE9
             , ATTRIBUTE10
             , ATTRIBUTE3)
        SELECT DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , TO_SITE2
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , MEASURE
             , B_YYYYMMDD
             , YYYYMMDD
             , YYYYMM
             , QTY
             , ISO_WEEK
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE9
             , ATTRIBUTE10
             , ATTRIBUTE3
          FROM GT_SCP0031_MAIN;

        --MODEL_INVENTORY, WH_IN_BALANCE, BALANCE, CHAR_AVAILABLE, ACTIVATE_PROGRESS

        --chaan begin V1.5 VMI 안전재고설정 추가 - Measure가 없는 Gap용 가상행을 추가함(Safety Stock 행 복사후 Measure, ATTRIBUTE3-라인색상 등만 Gap용으로 변경)
        INSERT
          INTO GT_SCP0031_FNL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , TO_SITE2
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , MEASURE
             , B_YYYYMMDD
             , YYYYMMDD
             , YYYYMM
             , QTY
             , ISO_WEEK
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE9
             , ATTRIBUTE10
             , ATTRIBUTE3
             , WEEK_YN
             , MONTH_YN)
        SELECT F.DIVISION_ID
             , F.OPERATION_GROUP
             , F.CELL_ITEM_ID
             , F.ITEM_ID
             , F.TO_SITE
             , F.TO_SITE2
             , F.TO_BOH_QTY
             , F.FROM_BOH_QTY
             , F.INCOTERMS
             , F.FROM_SITE
             , F.TRANSPORT_MODE_LINE
             , F.MEASURE
             , F.B_YYYYMMDD
             , F.YYYYMMDD
             , F.YYYYMM
             , F.QTY
             , F.ISO_WEEK
             , C.SORT_ORDER_NO
             , C.COLUMN_LABEL_NAME
             , F.BOD_ID
             , F.ATTRIBUTE9
             , F.ATTRIBUTE10
             , C.ATTRIBUTE3
             , F.WEEK_YN
             , F.MONTH_YN
          FROM (SELECT S.DIVISION_ID
                     , S.OPERATION_GROUP
                     , S.CELL_ITEM_ID
                     , S.ITEM_ID
                     , S.TO_SITE
                     , S.TO_SITE2
                     , S.TO_BOH_QTY
                     , S.FROM_BOH_QTY
                     , S.INCOTERMS
                     , S.FROM_SITE
                     , S.TRANSPORT_MODE_LINE
                     , 'GAP' AS MEASURE
                     , S.B_YYYYMMDD
                     , S.YYYYMMDD
                     , S.YYYYMM
                     , (NVL(B.QTY, 0) - NVL(S.QTY, 0)) AS QTY
                     , S.ISO_WEEK
                     , S.SORT_ORDER_NO
                     , S.COLUMN_LABEL_NAME
                     , S.BOD_ID
                     , S.ATTRIBUTE9
                     , S.ATTRIBUTE10
                     , S.ATTRIBUTE3
                     , S.WEEK_YN
                     , S.MONTH_YN
                  FROM (SELECT *
                          FROM GT_SCP0031_FNL
                         WHERE MEASURE = 'SAFETY_STOCK') S
                     , (SELECT *
                          FROM GT_SCP0031_FNL
                         WHERE MEASURE = 'WH_IN_BALANCE') B
                       -- Safet Stocck 을 기준으로 하므로 Safety Stock 행이 없으면 Gap 행도 만들 수 없음
                 WHERE S.DIVISION_ID         = B.DIVISION_ID(+)
                   AND S.OPERATION_GROUP     = B.OPERATION_GROUP(+)
                   AND S.CELL_ITEM_ID        = B.CELL_ITEM_ID(+)
                   AND S.ITEM_ID             = B.ITEM_ID(+)
                   AND S.TO_SITE             = B.TO_SITE(+)
                   AND S.TO_SITE2            = B.TO_SITE2(+)
                       --AND S.TO_BOH_QTY = B.TO_BOH_QTY
                       --AND S.FROM_BOH_QTY = B.FROM_BOH_QTY
                   AND S.INCOTERMS           = B.INCOTERMS(+)
                   AND S.FROM_SITE           = B.FROM_SITE(+)
                   AND S.TRANSPORT_MODE_LINE = B.TRANSPORT_MODE_LINE(+)
                   AND S.B_YYYYMMDD          = B.B_YYYYMMDD(+)
                   AND S.YYYYMMDD            = B.YYYYMMDD(+)
                   AND S.YYYYMM              = B.YYYYMM(+)
                   AND S.ISO_WEEK            = B.ISO_WEEK(+)
                   AND S.BOD_ID              = B.BOD_ID(+)
                       --AND S.ATTRIBUTE9 = B.ATTRIBUTE9
                       --AND S.ATTRIBUTE10 = B.ATTRIBUTE10
                       --AND S.ATTRIBUTE3 = B.ATTRIBUTE3
               ) F
               --                SELECT DISTINCT
               --                          M.PROGRAM_ID
               --                        , M.SHEET_NAME
               --                        , M.COLUMN_NAME
               --                        , M.COLUMN_LABEL_NAME
               --                        , T.SORT_ORDER_NO
               --                        , 'GAP' AS MEASURE
               --, M.ATTRIBUTE9
               --, M.ATTRIBUTE10
               --, M.ATTRIBUTE3
               --                FROM    SCM_MST_SHEET_MEASURE M,
               --                        SCM_MST_TITLESET_USER T
               --                WHERE   1=1
               --                    AND M.PROGRAM_ID  = T.PROGRAM_ID
               --           AND M.SHEET_NAME  = T.SHEET_NAME
               --                    AND M.COLUMN_NAME = 'GAP'
               --                    AND T.PROGRAM_ID  = @p_program_id
               --           AND T.SHEET_NAME  = @p_sheet_name
               --  AND T.USER_ID     = @p_user_id
             , (SELECT M.PROGRAM_ID
                     , M.SHEET_NAME
                     , M.COLUMN_NAME
                     , M.COLUMN_LABEL_NAME
                     , T.SORT_ORDER_NO
                     , 'GAP' AS MEASURE
                     , M.ATTRIBUTE9
                     , M.ATTRIBUTE10
                     , M.ATTRIBUTE3
                  FROM SCM_MST_SHEET_MEASURE M
                     , SCM_MST_TITLESET_USER T
                 WHERE 1             = 1
                   AND M.PROGRAM_ID  = T.PROGRAM_ID
                   AND M.SHEET_NAME  = T.SHEET_NAME
                   AND M.COLUMN_NAME = T.COLUMN_NAME
                   AND M.COLUMN_NAME = 'GAP'
                   AND T.PROGRAM_ID  = P_PROGRAM_ID
                   AND T.SHEET_NAME  = P_SHEET_NAME
                   AND T.USER_ID     = P_USER_ID) C
         WHERE F.MEASURE = C.MEASURE(+);
        --chaan end V1.5 VMI 안전재고설정 추가 - Measure가 없는 Gap용 가상행을 추가함(Safety Stock 행 복사후 Measure, ATTRIBUTE3-라인색상 등만 Gap용으로 변경)

        UPDATE GT_SCP0031_FNL A
           SET A.WEEK_YN = 'Y'
         WHERE A.MEASURE IN ('MODEL_INVENTORY', 'WH_IN_BALANCE', 'BALANCE', 'CHAR_AVAILABLE', 'ACTIVATE_PROGRESS', 'SAFETY_STOCK', 'GAP', 'DIO')
           AND EXISTS (SELECT 1
                         FROM (SELECT ISO_WEEK
                                    , PARTIAL_WEEK_NAME
                                    , CALENDAR_YYYY
                                    , MAX(BASIS_YYYYMMDD) AS YYYYMMDD
                                 FROM SCM_SYS_CALENDAR_M
                                WHERE BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                                  AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD -- 마지막 구간 오류 발생으로 1개월 더함
                                GROUP BY ISO_WEEK
                                       , PARTIAL_WEEK_NAME
                                       , CALENDAR_YYYY) XA
                        WHERE SUBSTR(A.YYYYMMDD, -8) = XA.YYYYMMDD);

        UPDATE GT_SCP0031_FNL A
           SET A.MONTH_YN = 'Y'
         WHERE A.MEASURE IN ('MODEL_INVENTORY', 'WH_IN_BALANCE', 'BALANCE', 'CHAR_AVAILABLE', 'ACTIVATE_PROGRESS', 'SAFETY_STOCK', 'GAP', 'DIO')
           AND EXISTS (SELECT 1
                         FROM (SELECT BASIS_YYYYMM
                                    , MAX(BASIS_YYYYMMDD) AS YYYYMMDD
                                 FROM SCM_SYS_CALENDAR_M
                                WHERE BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                                  AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD -- 마지막 구간 오류 발생으로 1개월 더함
                                GROUP BY BASIS_YYYYMM) XA
                        WHERE SUBSTR(A.YYYYMMDD, -8) = XA.YYYYMMDD);
        --2021/11/02 End UI 속도 개선

        /********************************************************************************
         * PIVOIT처리
         ********************************************************************************/
        /* 집계 대상 날짜가 조회 구간에 따라 달라져 컬럼 자체가 가변이므로 이 구간만 동적 SQL 로 둔다(06 보고서 6항) */
        -- SUM 컬럼 문자열 생성 begin
        -- PIVOIT 대상 날짜문자열 생성
        V_QRY_SUM := EMPTY_CLOB();
        DBMS_LOB.CREATETEMPORARY(V_QRY_SUM, TRUE);
        V_QRY_PIVOT := EMPTY_CLOB();                       --  2026.10.29 AJS
        DBMS_LOB.CREATETEMPORARY(V_QRY_PIVOT, TRUE);       --  2026.10.29 AJS

        FOR R IN ( SELECT YYYYMMDD
                     FROM ( SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS YYYYMMDD
                                 , A.BASIS_START_DATE || '21' AS SORT_ORDER_NO
                              FROM SCM_SYS_CALENDAR_M      A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                               AND ( V_BUCKET = 'DAILY' OR V_BUCKET = 'WEEKLY' )
                             GROUP BY A.BASIS_YYYYMM
                                    , A.ISO_WEEK
                                    , A.BASIS_START_DATE
                            UNION ALL
                            SELECT 'M_' || A.BASIS_YYYYMM AS YYYYMMDD
                                 , MIN(A.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
                              FROM SCM_SYS_CALENDAR_M      A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY A.BASIS_YYYYMM
                                    , A.MONTH_NAME
                            UNION ALL
                            SELECT 'D_' || A.BASIS_YYYYMMDD AS YYYYMMDD
                                 , A.BASIS_YYYYMMDD || '31' AS SORT_ORDER_NO
                              FROM SCM_SYS_CALENDAR_M      A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                               AND V_BUCKET = 'DAILY'
                             GROUP BY A.BASIS_YYYYMMDD
                          )  IA
                    ORDER BY SORT_ORDER_NO
                 )
        LOOP

--            IF INSTR(R.YYYYMMDD, 'M_') = 1 THEN
--                DBMS_LOB.WRITEAPPEND(V_QRY_SUM, LENGTH(','), ',');
--                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(
--                    'SUM( CASE WHEN YYYYMM = SUBSTR(''' || R.YYYYMMDD || ''', -6) AND MEASURE IN     (' || C_MEASURE_BAL || ') AND MONTH_YN = ''Y''       THEN CAST(QTY AS NUMBER(15,2)) '
--                 || 'WHEN YYYYMM = SUBSTR(''' || R.YYYYMMDD || ''', -6) AND MEASURE NOT IN (' || C_MEASURE_NOTIN || ') THEN CAST(QTY AS NUMBER(15,2)) ELSE 0 END   ) AS ' || R.YYYYMMDD || CHR(10)));
--            ELSIF INSTR(R.YYYYMMDD, 'W_') = 1 THEN
--                DBMS_LOB.WRITEAPPEND(V_QRY_SUM, LENGTH(','), ',');
--                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(
--                    'SUM( CASE WHEN ISO_WEEK = SUBSTR(''' || R.YYYYMMDD || ''', -6) AND MEASURE IN     (' || C_MEASURE_BAL || ') AND WEEK_YN = ''Y''        THEN CAST(QTY AS NUMBER(15,2)) '
--                 || 'WHEN ISO_WEEK = SUBSTR(''' || R.YYYYMMDD || ''', -6) AND MEASURE NOT IN (' || C_MEASURE_NOTIN || ') THEN CAST(QTY AS NUMBER(15,2)) ELSE 0 END   ) AS ' || R.YYYYMMDD || CHR(10)));
--            ELSIF INSTR(R.YYYYMMDD, 'D_') = 1 THEN
--                DBMS_LOB.WRITEAPPEND(V_QRY_SUM, LENGTH(','), ',');
--                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(
--                    ' SUM(CASE WHEN YYYYMMDD = ''' || R.YYYYMMDD || ''' THEN QTY END ) AS ' || R.YYYYMMDD || CHR(10)));
--            END IF;
            -- 2026.10.29 AJS 날짜 칸 집계를 PIVOT 으로 변경 — 행마다 날짜 칸 수만큼 CASE 를 평가하던 것을 한 번에 칸으로 나눔(결과 동일) (START)
            /* 월·주 칸은 해당 행이 없으면 AS-IS 처럼 0, 일 칸은 AS-IS 처럼 값 없음 */
            IF INSTR(R.YYYYMMDD, 'M_') = 1 OR INSTR(R.YYYYMMDD, 'W_') = 1 THEN
                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(
                    '              , NVL(A.' || R.YYYYMMDD || ', 0) AS ' || R.YYYYMMDD || CHR(10)));
            ELSIF INSTR(R.YYYYMMDD, 'D_') = 1 THEN
                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(
                    '              , A.' || R.YYYYMMDD || CHR(10)));
            END IF;

            /* PIVOT 값 : 월 = 'M'+YYYYMM, 주 = 'W'+ISO_WEEK(칸 이름 끝 6자리), 일 = 칸 이름 그대로 */
            IF V_QRY_PIVOT_CNT > 0 THEN
                DBMS_LOB.WRITEAPPEND(V_QRY_PIVOT, LENGTH(','), ',');
            END IF;
            V_QRY_PIVOT_CNT := V_QRY_PIVOT_CNT + 1;

            IF INSTR(R.YYYYMMDD, 'M_') = 1 THEN
                DBMS_LOB.APPEND(V_QRY_PIVOT, TO_CLOB(' ''M' || SUBSTR(R.YYYYMMDD, -6) || ''' AS ' || R.YYYYMMDD || CHR(10)));
            ELSIF INSTR(R.YYYYMMDD, 'W_') = 1 THEN
                DBMS_LOB.APPEND(V_QRY_PIVOT, TO_CLOB(' ''W' || SUBSTR(R.YYYYMMDD, -6) || ''' AS ' || R.YYYYMMDD || CHR(10)));
            ELSE
                DBMS_LOB.APPEND(V_QRY_PIVOT, TO_CLOB(' ''' || R.YYYYMMDD || ''' AS ' || R.YYYYMMDD || CHR(10)));
            END IF;
            -- 2026.10.29 AJS 날짜 칸 집계를 PIVOT 으로 변경 (END)

        END LOOP;
        -- SUM 컬럼 문자열 생성 end

        -----------------------------------------------------------
        -- DEBUG QRY 출력
        -----------------------------------------------------------
        --IF( @debug_mode ='T')
        --BEGIN
        --SET @POS =1;
        --SET @LEN =LEN(@mQry_sum);
        --WHILE @POS <= @LEN
        --BEGIN
        --PRINT SUBSTRING(@mQry_sum,@POS,4000);
        --SET @POS = @POS+4000;
        --END;
        --END;

        V_EXEC := EMPTY_CLOB();
        DBMS_LOB.CREATETEMPORARY(V_EXEC, TRUE);

        --2021/11/19 SQL튜닝 반영 DEL
		/*
		-- 주의 : 조회항목 변경 시 M_,W_,D_ 컬럼이 항상 뒤에 나와야함
		--        UI에서 합계계산 시 COLUMN COUNT INDEX 계산
		SET @mEXEC = @mEXEC + 'SELECT CASE WHEN A.BOD_ID=''-'' THEN ''-'' ELSE convert(nvarchar(50), ('+CHAR(10);
		--SET @mEXEC = @mEXEC + '										CASE	WHEN ISNULL(l.segment3, '''') = '''' THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0)  '+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''A''            THEN 0'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''B''            THEN ISNULL(r.lt_departure_inland, 0)'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''C''            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0)'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''D''            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0)'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''E''            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0)'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''F''            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0)'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												ELSE                                     ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0)'+CHAR(10);
		--SET @mEXEC = @mEXEC + '										END ) ) END AS LT_DAY'+CHAR(10);
		SET @mEXEC = @mEXEC + '		     B.lt_total )) END AS LT_DAY'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , isnull(NULLIF( A.CELL_QTY_PACK_T, '''') , ''-'') AS CELL_QTY_PACK'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , isnull(d.segment2,''-'') AS OPERATION_GROUP_NAME'+CHAR(10);
		SET @mEXEC = @mEXEC + '	       , ISNULL(H.DEPT_NAME_KO, ''-'') AS DEPT_NAME	                            '+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.*'+CHAR(10);


		--IF @p_division_id != 'EE'
		--BEGIN
		--    SET @mEXEC = @mEXEC + '        , CASE WHEN A.TO_SITE = ''-'' THEN '''''+CHAR(10);
		--    SET @mEXEC = @mEXEC + '          ELSE (SELECT TOP 1 BB.DEPT_NAME_KO FROM SCM_MST_SSO_USER_INFO AA WITH (NOLOCK) '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '                                           INNER JOIN SCM_MST_SSO_DEPT_INFO BB WITH (NOLOCK) ON AA.DEPT_ID = BB.DEPT_ID  '+CHAR(10);
		--	SET @mEXEC = @mEXEC + '                                           INNER JOIN SCM_MST_SITE_ITEM CC WITH (NOLOCK) ON AA.USER_ID = CC.OWNER        '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '               WHERE CC.ITEM_ID = A.ITEM_ID                                      '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '                 AND CC.DIVISION_ID = A.DIVISION_ID AND CC.SCM_SITE_ID = A.TO_SITE) END AS DEPT_NAME      '+CHAR(10);

		--END
		--ELSE BEGIN
		--    SET @mEXEC = @mEXEC + '        , CASE WHEN A.TO_SITE = ''-'' THEN '''''+CHAR(10);
		--    SET @mEXEC = @mEXEC + '          ELSE (SELECT TOP 1 BB.DEPT_NAME_KO FROM SCM_MST_SSO_USER_INFO AA WITH (NOLOCK) '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '                                     INNER JOIN SCM_MST_SSO_DEPT_INFO BB WITH (NOLOCK) ON AA.DEPT_ID = BB.DEPT_ID  '+CHAR(10);
		--	SET @mEXEC = @mEXEC + '                                     INNER JOIN SCM_MST_SITE_ITEM CC WITH (NOLOCK) ON AA.USER_ID = CC.OWNER        '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '               WHERE CC.ITEM_ID = A.ITEM_ID                  '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '               AND CC.DIVISION_ID = A.DIVISION_ID AND CC.SCM_SITE_ID = A.TO_SITE2) END AS DEPT_NAME      '+CHAR(10);
		--END;

		--SET @mEXEC = @mEXEC + '        , G.DEPT_NAME_KO AS DEPT_NAME'+CHAR(10);

		SET @mEXEC = @mEXEC + ' FROM ('+CHAR(10);
		*/
        --2021/11/19 SQL튜닝 반영 DEL
        --2021/11/19 SQL튜닝 반영 ADD
        --2021/11/19 SQL튜닝 반영 ADD
        --2021/11/19 SQL튜닝 반영 DEL
        --SET @mEXEC = @mEXEC + '      ) A'+CHAR(10);
        --2021/11/19 SQL튜닝 반영 DEL
        --2021/11/19 SQL튜닝 반영 ADD
        /* 주의 : 조회항목 변경 시 M_,W_,D_ 컬럼이 항상 뒤에 나와야함
                  UI에서 합계계산 시 COLUMN COUNT INDEX 계산 */
        -- 주의 : 조회항목 변경 시 M_,W_,D_ 컬럼이 항상 뒤에 나와야함
        DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
            'SELECT CASE WHEN A.BOD_ID = ''-'' THEN ''-'' ELSE TO_CHAR(B.LT_TOTAL) END AS LT_DAY' || CHR(10)
         || '     , NVL(NULLIF(A.CELL_QTY_PACK_T, ''''), ''-'') AS CELL_QTY_PACK' || CHR(10)
--       || '     , NVL(D.SEGMENT2, ''/'') AS OPERATION_GROUP_NAME' || CHR(10)    --  2026.10.20 AJS
         || '     , NVL(D.SEGMENT2, ''-'') AS OPERATION_GROUP_NAME' || CHR(10)    --  2026.10.20 AJS
         || '     , NVL(( SELECT H.DEPT_NAME_KO' || CHR(10)
         || '               FROM SCM_MST_SSO_DEPT_INFO      H' || CHR(10)
         -- 2026.09.30 AJS 부서 열쇠를 사이트 대표 부서 뷰로 변경 (START)
         -- || '              WHERE H.DEPT_ID = CASE WHEN ' || CASE WHEN V_EE_YN = 'Y' THEN 'A.ORIGIN_TO_DIVISION_ID' ELSE 'A.DIVISION_ID' END || ' = ''40'' THEN G.DEPT_ID ELSE E.DEPT_ID END' || CHR(10)
--       || '              WHERE H.DEPT_ID = CASE WHEN ' || CASE WHEN V_EE_YN = 'Y' THEN 'A.ORIGIN_TO_DIVISION_ID' ELSE 'A.DIVISION_ID' END || ' = ''40'' THEN G.DEPT_ID ELSE C.DEPT_ID END' || CHR(10)    --  2026.10.21 AJS
         || '              WHERE H.DEPT_ID = CASE WHEN ' || CASE WHEN V_EE_YN = 'Y' THEN 'A.ORIGIN_TO_DIVISION_ID' ELSE 'A.DIVISION_ID' END || ' = ''40'' THEN G.DEPT_ID ELSE NVL(TRIM(F.DEPT_ID), C.DEPT_ID) END' || CHR(10)    --  2026.10.21 AJS
         -- 2026.09.30 AJS 부서 열쇠를 사이트 대표 부서 뷰로 변경 (END)
         || '                AND ROWNUM = 1 ), ''-'') AS DEPT_NAME' || CHR(10)
         || '     , A.*' || CHR(10)
         -- 20230613 Final Item) Cell Type Sort
--       || '     , FN_GET_SCP_CELL_TYPE_SORT(V.CELL_TYPE) AS CELL_TYPE_SORT' || CHR(10)    --  2026.10.20 AJS
         || '     , CASE WHEN V.ITEM_ID IS NOT NULL AND V.CELL_TYPE IS NULL THEN 400000 ELSE FN_GET_SCP_CELL_TYPE_SORT(V.CELL_TYPE) END AS CELL_TYPE_SORT' || CHR(10)    --  2026.10.20 AJS
         || '  FROM ( SELECT A.DIVISION_ID' || CHR(10)
         --2021/11/19 SQL튜닝 반영 ADD
         || '              , A.OPERATION_GROUP' || CHR(10)
         || '              , A.CELL_ITEM_ID' || CHR(10)
         || '              , A.ITEM_ID' || CHR(10)
         || '              , ( SELECT (CASE WHEN X.NICK_NAME IS NULL THEN ''-''  WHEN X.NICK_NAME = ''''    THEN ''-''  ELSE X.NICK_NAME END) FROM SCM_MST_ITEM_SN X  WHERE  X.ITEM_ID  = A.ITEM_ID AND X.NICK_NAME IS NOT NULL AND ROWNUM = 1 ) AS NICK_NAME' || CHR(10)    -- MS 원본이 '-'    --  2026.10.12 AJS
         || '              , CASE WHEN A.OPERATION_GROUP = ''A'' THEN ''-'' ELSE ( SELECT TO_CHAR(CEIL(V.ACCUMULATED_CHILD_QTY))' || CHR(10)
         || '                                                                       FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V' || CHR(10)
         || '                                                                      WHERE V.DIVISION_ID = A.DIVISION_ID AND V.OPERATION_GROUP_ID = ''A''' || CHR(10)
         || '                                                                        AND V.MODEL_ID = A.ITEM_ID AND V.CHILD_ITEM_ID = A.CELL_ITEM_ID' || CHR(10)
         || '                                                                        AND ROWNUM = 1 ) END AS CELL_QTY_PACK_T' || CHR(10)
         || '              , A.TO_SITE' || CHR(10)
         || '              , A.TO_SITE2' || CHR(10)
--       || '              , NVL(NULLIF(( SELECT M.SITE_DESCRIPTION FROM SCM_MST_SITE M WHERE M.SCM_SITE_ID = A.TO_SITE AND ROWNUM = 1 ), ''''), ''/'') AS TO_SITE_DESCRIPTION' || CHR(10)    --  2026.10.20 AJS
         || '              , NVL(NULLIF(( SELECT M.SITE_DESCRIPTION FROM SCM_MST_SITE M WHERE M.SCM_SITE_ID = A.TO_SITE AND ROWNUM = 1 ), ''''), ''-'') AS TO_SITE_DESCRIPTION' || CHR(10)    --  2026.10.20 AJS
         || '              , A.TO_BOH_QTY' || CHR(10)
         || '              , A.FROM_BOH_QTY' || CHR(10)
--       || '              , NVL(NULLIF(A.INCOTERMS, ''''), ''/'') AS INCOTERMS' || CHR(10)    --  2026.10.20 AJS
         || '              , NVL(NULLIF(A.INCOTERMS, ''''), ''-'') AS INCOTERMS' || CHR(10)    --  2026.10.20 AJS
         || '              , A.FROM_SITE' || CHR(10)
--       || '              , NVL(NULLIF(( SELECT M.SITE_DESCRIPTION FROM SCM_MST_SITE M WHERE M.SCM_SITE_ID = A.FROM_SITE AND ROWNUM = 1 ), ''''), ''/'') AS FROM_SITE_DESCRIPTION' || CHR(10)    --  2026.10.20 AJS
         || '              , NVL(NULLIF(( SELECT M.SITE_DESCRIPTION FROM SCM_MST_SITE M WHERE M.SCM_SITE_ID = A.FROM_SITE AND ROWNUM = 1 ), ''''), ''-'') AS FROM_SITE_DESCRIPTION' || CHR(10)    --  2026.10.20 AJS
--       || '              , NVL(NULLIF(A.TRANSPORT_MODE_LINE, ''''), ''/'') AS TRANSPORT_MODE_LINE' || CHR(10)    --  2026.10.20 AJS
         || '              , NVL(NULLIF(A.TRANSPORT_MODE_LINE, ''''), ''-'') AS TRANSPORT_MODE_LINE' || CHR(10)    --  2026.10.20 AJS
         || '              , A.BOD_ID' || CHR(10)
         || '              , A.ATTRIBUTE10' || CHR(10)
         || '              , A.MEASURE' || CHR(10)
         || '              , A.COLUMN_LABEL_NAME AS MEASURE_LABEL' || CHR(10)
         || '              , A.SORT_ORDER_NO' || CHR(10)
         || '              , A.ATTRIBUTE3 AS MEASURE_COLOR' || CHR(10)));

        DBMS_LOB.APPEND(V_EXEC, V_QRY_SUM);

--        DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
--            '           FROM GT_SCP0031_FNL      A' || CHR(10)
--         || '          GROUP BY A.DIVISION_ID' || CHR(10)
--         || '                 , A.OPERATION_GROUP' || CHR(10)
--         || '                 , A.CELL_ITEM_ID' || CHR(10)
--         || '                 , A.ITEM_ID' || CHR(10)
--         || '                 , A.TO_SITE' || CHR(10)
--         || '                 , A.TO_SITE2' || CHR(10)
--         || '                 , A.TO_BOH_QTY' || CHR(10)
--         || '                 , A.FROM_BOH_QTY' || CHR(10)
--         || '                 , A.INCOTERMS' || CHR(10)
--         || '                 , A.FROM_SITE' || CHR(10)
--         || '                 , A.TRANSPORT_MODE_LINE' || CHR(10)
--         || '                 , A.BOD_ID' || CHR(10)
--         || '                 , A.ATTRIBUTE10' || CHR(10)
--         || '                 , A.MEASURE' || CHR(10)
--         || '                 , A.SORT_ORDER_NO' || CHR(10)
--         || '                 , A.COLUMN_LABEL_NAME' || CHR(10)
--         || '                 , A.ATTRIBUTE3' || CHR(10)
        -- 2026.10.29 AJS 날짜 칸 집계를 PIVOT 으로 변경 — 일 칸은 그대로, 주·월 칸은 조건에 맞는 행만 'W'+ISO_WEEK · 'M'+YYYYMM 값으로 붙임 (START)
        DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
            '           FROM ( SELECT *' || CHR(10)
         || '                    FROM (' || CHR(10)
         || '                   SELECT DIVISION_ID' || CHR(10)
         || '                        , OPERATION_GROUP' || CHR(10)
         || '                        , CELL_ITEM_ID' || CHR(10)
         || '                        , ITEM_ID' || CHR(10)
         || '                        , TO_SITE' || CHR(10)
         || '                        , TO_SITE2' || CHR(10)
         || '                        , TO_BOH_QTY' || CHR(10)
         || '                        , FROM_BOH_QTY' || CHR(10)
         || '                        , INCOTERMS' || CHR(10)
         || '                        , FROM_SITE' || CHR(10)
         || '                        , TRANSPORT_MODE_LINE' || CHR(10)
         || '                        , BOD_ID' || CHR(10)
         || '                        , ATTRIBUTE10' || CHR(10)
         || '                        , MEASURE' || CHR(10)
         || '                        , SORT_ORDER_NO' || CHR(10)
         || '                        , COLUMN_LABEL_NAME' || CHR(10)
         || '                        , ATTRIBUTE3' || CHR(10)
         || '                        , YYYYMMDD                  AS PIVOT_COL' || CHR(10)
         || '                        , QTY                       AS PIVOT_QTY' || CHR(10)
         || '                     FROM GT_SCP0031_FNL' || CHR(10)
         || '                   UNION ALL' || CHR(10)
         || '                   SELECT DIVISION_ID' || CHR(10)
         || '                        , OPERATION_GROUP' || CHR(10)
         || '                        , CELL_ITEM_ID' || CHR(10)
         || '                        , ITEM_ID' || CHR(10)
         || '                        , TO_SITE' || CHR(10)
         || '                        , TO_SITE2' || CHR(10)
         || '                        , TO_BOH_QTY' || CHR(10)
         || '                        , FROM_BOH_QTY' || CHR(10)
         || '                        , INCOTERMS' || CHR(10)
         || '                        , FROM_SITE' || CHR(10)
         || '                        , TRANSPORT_MODE_LINE' || CHR(10)
         || '                        , BOD_ID' || CHR(10)
         || '                        , ATTRIBUTE10' || CHR(10)
         || '                        , MEASURE' || CHR(10)
         || '                        , SORT_ORDER_NO' || CHR(10)
         || '                        , COLUMN_LABEL_NAME' || CHR(10)
         || '                        , ATTRIBUTE3' || CHR(10)
         || '                        , ''W'' || ISO_WEEK           AS PIVOT_COL' || CHR(10)
         || '                        , CAST(QTY AS NUMBER(15,2)) AS PIVOT_QTY' || CHR(10)
         || '                     FROM GT_SCP0031_FNL' || CHR(10)
         || '                    WHERE (MEASURE IN     (' || C_MEASURE_BAL || ') AND WEEK_YN = ''Y'')' || CHR(10)
         || '                       OR  MEASURE NOT IN (' || C_MEASURE_NOTIN || ')' || CHR(10)
         || '                   UNION ALL' || CHR(10)
         || '                   SELECT DIVISION_ID' || CHR(10)
         || '                        , OPERATION_GROUP' || CHR(10)
         || '                        , CELL_ITEM_ID' || CHR(10)
         || '                        , ITEM_ID' || CHR(10)
         || '                        , TO_SITE' || CHR(10)
         || '                        , TO_SITE2' || CHR(10)
         || '                        , TO_BOH_QTY' || CHR(10)
         || '                        , FROM_BOH_QTY' || CHR(10)
         || '                        , INCOTERMS' || CHR(10)
         || '                        , FROM_SITE' || CHR(10)
         || '                        , TRANSPORT_MODE_LINE' || CHR(10)
         || '                        , BOD_ID' || CHR(10)
         || '                        , ATTRIBUTE10' || CHR(10)
         || '                        , MEASURE' || CHR(10)
         || '                        , SORT_ORDER_NO' || CHR(10)
         || '                        , COLUMN_LABEL_NAME' || CHR(10)
         || '                        , ATTRIBUTE3' || CHR(10)
         || '                        , ''M'' || YYYYMM             AS PIVOT_COL' || CHR(10)
         || '                        , CAST(QTY AS NUMBER(15,2)) AS PIVOT_QTY' || CHR(10)
         || '                     FROM GT_SCP0031_FNL' || CHR(10)
         || '                    WHERE (MEASURE IN     (' || C_MEASURE_BAL || ') AND MONTH_YN = ''Y'')' || CHR(10)
         || '                       OR  MEASURE NOT IN (' || C_MEASURE_NOTIN || ')' || CHR(10)
         || '                         )' || CHR(10)
         || '                   PIVOT ( SUM(PIVOT_QTY) FOR PIVOT_COL IN (' || CHR(10)));

        DBMS_LOB.APPEND(V_EXEC, V_QRY_PIVOT);

        DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
            '                         ) )' || CHR(10)
         || '                )  A' || CHR(10)));
        -- 2026.10.29 AJS 날짜 칸 집계를 PIVOT 으로 변경 (END)

        DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
            '' || CHR(10)
         || '       )  A' || CHR(10)
         --PJ20209642 : BOD LT 1단계 개발 ( scp_mst_bod_v.lt_total 로 변경)
         --SET @mEXEC = @mEXEC + '      LEFT JOIN scp_mst_bod b WITH(NOLOCK)'+CHAR(10);
         --SET @mEXEC = @mEXEC + '				ON B.DIVISION_ID=A.DIVISION_ID AND B.BOD_ID=A.BOD_ID AND B.FROM_SITE=A.FROM_SITE '+CHAR(10);
         --SET @mEXEC = @mEXEC + '      LEFT JOIN scp_mst_distribution_route r WITH(NOLOCK)'+CHAR(10);
         --SET @mEXEC = @mEXEC + '				ON R.route_id = B.route_id'+CHAR(10);
         --SET @mEXEC = @mEXEC + '      LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL l WITH(NOLOCK)'+CHAR(10);
         --SET @mEXEC = @mEXEC + '				ON l.lookup_type = ''INCOTERMS'' AND l.valid_yn    = ''Y'' AND b.incoterms = l.segment1'+CHAR(10);
         -- BOD 2단계 : scp_mst_bod_v -> scp_mst_bod_n_v
         --SET @mEXEC = @mEXEC + '      LEFT JOIN scp_mst_bod_v b WITH(NOLOCK)'+CHAR(10);
         --chaan Row size limit 에러 수정		SET @mEXEC = @mEXEC + '      LEFT JOIN scp_mst_bod_n_v b WITH(NOLOCK)'+CHAR(10);
         || '     , SCP_ANL_BOD_N_V_PLAN_H         B' || CHR(10)    --chaan Row size limit 에러 수정
         || '     , SCM_ADM_LOOKUP_MASTER_DETAIL   D' || CHR(10)
         -- 2026.09.30 AJS SCM_MST_SITE.DEPT_ID 삭제에 따라 사이트 대표 부서 뷰를 덧붙임 (START)
         || '     , SCM_MST_SITE                   E' || CHR(10)
         || '     , SCM_MST_SITE_DEPT_REP_V    C' || CHR(10)
         -- 2026.09.30 AJS SCM_MST_SITE.DEPT_ID 삭제에 따라 사이트 대표 부서 뷰를 덧붙임 (END)
         || '     , ( SELECT XA.*' || CHR(10)
         || '              , ROW_NUMBER() OVER (PARTITION BY XA.DIVISION_ID, XA.SCM_SITE_ID, XA.ITEM_ID ORDER BY XA.PROJECT_CODE) AS RANK_NUMBER' || CHR(10)
         || '           FROM SCM_MST_SITE_ITEM      XA' || CHR(10)
         || '          WHERE XA.VALID_YN = ''Y''' || CHR(10)
         || '       )  F' || CHR(10)
         || '     , SCM_MST_SSO_USER_INFO          G' || CHR(10)
         || '     , SCM_MST_FINAL_ITEM_V           V' || CHR(10)
         || ' WHERE B.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)
         || '   AND B.BOD_ID(+)      = A.BOD_ID' || CHR(10)
         || '   AND B.FROM_SITE(+)   = A.FROM_SITE' || CHR(10)
         || '   AND B.PLAN_NAME(+)   = ''' || P_PLAN_START_YYYYMMDD || '''' || CHR(10)
         || '   AND B.PLAN_TYPE(+)   = ''' || P_PLAN_TYPE || '''' || CHR(10)
         /* ★차수가 비면 AS-IS 는 조회문 전체가 값 없음이 되어 결과 0건을 돌려준다.
            Oracle 은 빈 값을 빈 글자로 이어 붙여 끊긴 문장을 만들므로 조건으로 막아 같은 결과가 되게 한다. */
         || CASE WHEN V_SEQ IS NULL
                 THEN '   AND 1 = 0' || CHR(10)
                 ELSE '   AND B.PLAN_SEQ(+)    = ' || TO_CHAR(V_SEQ) || CHR(10)
            END
         || '   AND D.LOOKUP_TYPE(+) = ''OPERATION_GROUP''' || CHR(10)
         || '   AND D.SEGMENT1(+)    = A.OPERATION_GROUP' || CHR(10)));

        /********** DEPT NAME START **********/
        --IF @p_division_id NOT IN ('EE','EE_UC')
        IF V_EE_YN = 'N' THEN    --div_commonization
            DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
                '   AND E.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)
             || '   AND E.SCM_SITE_ID(+) = A.TO_SITE' || CHR(10)));
        ELSE
            DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
                '   AND E.DIVISION_ID(+) = A.ORIGIN_TO_DIVISION_ID' || CHR(10)
             || '   AND E.SCM_SITE_ID(+) = A.TO_SITE2' || CHR(10)));
        END IF;

        DBMS_LOB.APPEND(V_EXEC, TO_CLOB('   AND E.VALID_YN(+)    = ''Y''' || CHR(10)));

        -- 2026.09.30 AJS 사이트 대표 부서 뷰 조인 추가 (START)
        DBMS_LOB.APPEND(V_EXEC, TO_CLOB('   AND C.DIVISION_ID(+) = E.DIVISION_ID' || CHR(10)
                                      || '   AND C.SCM_SITE_ID(+) = E.SCM_SITE_ID' || CHR(10)));
        -- 2026.09.30 AJS 사이트 대표 부서 뷰 조인 추가 (END)

        --IF @p_division_id NOT IN ('EE','EE_UC')
        IF V_EE_YN = 'N' THEN    --div_commonization
            DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
                '   AND F.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)
             || '   AND F.SCM_SITE_ID(+) = A.TO_SITE' || CHR(10)));
        ELSE
            DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
                '   AND F.DIVISION_ID(+) = A.ORIGIN_TO_DIVISION_ID' || CHR(10)
             || '   AND F.SCM_SITE_ID(+) = A.TO_SITE2' || CHR(10)));
        END IF;

        DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
            '   AND F.ITEM_ID(+)     = A.ITEM_ID' || CHR(10)
         || '   AND F.VALID_YN(+)    = ''Y''' || CHR(10)
         || '   AND F.RANK_NUMBER(+) = 1' || CHR(10)   -- PROJECT_CODE 가 없어 1건만 가져오기 위해 처리
         || '   AND SUBSTR(F.OWNER, 1, CASE WHEN INSTR(F.OWNER, '','') = 0 THEN LENGTH(RTRIM(F.OWNER)) ELSE INSTR(F.OWNER, '','') - 1 END) = G.USER_ID(+)' || CHR(10)));
        /********** DEPT NAME END **********/

        --SET @mEXEC = @mEXEC + '      LEFT OUTER JOIN SCM_MST_SITE_ITEM E WITH(NOLOCK)     '+CHAR(10);
        --IF @p_division_id != 'EE'
        --	BEGIN
        --		SET @mEXEC = @mEXEC+'			   ON A.DIVISION_ID	= E.DIVISION_ID                                     '+CHAR(10);
        --		SET @mEXEC = @mEXEC+'			  AND A.TO_SITE = E.SCM_SITE_ID     		                                    '+CHAR(10);
        --		SET @mEXEC = @mEXEC+'			  AND A.ITEM_ID	= E.ITEM_ID 			                                            '+CHAR(10);
        --	END
        --	ELSE
        --	BEGIN
        --		SET @mEXEC = @mEXEC+'			   ON A.DIVISION_ID	= E.DIVISION_ID 	                                    '+CHAR(10);
        --		SET @mEXEC = @mEXEC+'			  AND A.TO_SITE2 = E.SCM_SITE_ID                                        '+CHAR(10);
        --		SET @mEXEC = @mEXEC+'			  AND A.ITEM_ID	= E.ITEM_ID 				                                                '+CHAR(10);
        --	END
        --SET @mEXEC = @mEXEC + '      INNER JOIN SCM_MST_SSO_USER_INFO F WITH(NOLOCK)     '+CHAR(10);
        --SET @mEXEC = @mEXEC + '				ON E.OWNER = F.USER_ID	                                                                     '+CHAR(10);
        --SET @mEXEC = @mEXEC + '      INNER JOIN SCM_MST_SSO_DEPT_INFO G WITH(NOLOCK)     '+CHAR(10);
        --SET @mEXEC = @mEXEC + '				ON F.DEPT_ID = G.DEPT_ID                                                                '+CHAR(10);

        -- 20220125 vadabi3 DC Link Sort 적용 (Rack_YN, DC_YN Sort 적용)
        DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
            '   AND V.DIVISION_ID(+)         = A.DIVISION_ID' || CHR(10)
         || '   AND V.ITEM_ID(+)             = A.ITEM_ID' || CHR(10)
         || '   AND V.OPERATION_GROUP_ID(+)  = A.OPERATION_GROUP' || CHR(10)
         || '   AND V.DIVISION_ID(+)         = :B_DIVISION_ID' || CHR(10)   /* 품목 뷰를 조회 사업부로 한정 (적재 자료는 모두 조회 사업부) */   --  2026.10.06 AJS
         --SET @mEXEC = @mEXEC + ' 	 ORDER BY A.DIVISION_ID, A.CELL_ITEM_ID, A.OPERATION_GROUP DESC, A.ITEM_ID,A.ATTRIBUTE10, A.TO_SITE desc, A.INCOTERMS, A.FROM_SITE, A.SORT_ORDER_NO, A.TRANSPORT_MODE_LINE, A.MEASURE_LABEL DESC'+CHAR(10);
         --SET @mEXEC = @mEXEC + ' 	 ORDER BY A.DIVISION_ID, A.CELL_ITEM_ID, A.OPERATION_GROUP DESC, A.ITEM_ID,A.ATTRIBUTE10, A.TO_SITE desc, A.INCOTERMS, A.FROM_SITE, A.SORT_ORDER_NO, A.TRANSPORT_MODE_LINE, A.BOD_ID , A.MEASURE_LABEL DESC'+CHAR(10); -- BOD 2단계
         -- 20220125 vadabi3 DC Link Sort 적용 (Rack_YN, DC_YN Sort 적용)
         || ' ORDER BY A.DIVISION_ID' || CHR(10)
         || '        , A.CELL_ITEM_ID' || CHR(10)
         || '        , A.OPERATION_GROUP DESC NULLS LAST' || CHR(10)
         || '        , V.RACK_YN DESC NULLS LAST' || CHR(10)
         || '        , V.DC_YN DESC NULLS LAST' || CHR(10)
         || '        , CELL_TYPE_SORT' || CHR(10)
         || '        , A.ITEM_ID' || CHR(10)
         || '        , A.ATTRIBUTE10 NULLS FIRST' || CHR(10)
         || '        , NLSSORT(A.TO_SITE, ''NLS_SORT=BINARY_CI'') DESC NULLS LAST' || CHR(10)
         || '        , A.INCOTERMS' || CHR(10)
         || '        , A.FROM_SITE' || CHR(10)
         || '        , A.SORT_ORDER_NO NULLS FIRST' || CHR(10)
         || '        , A.TRANSPORT_MODE_LINE' || CHR(10)
         || '        , A.BOD_ID' || CHR(10)
         || '        , NLSSORT(A.MEASURE_LABEL, ''NLS_SORT=BINARY_CI'') DESC NULLS LAST' || CHR(10)));

--        OPEN O_RC1 FOR V_EXEC;                                                                   --  2026.10.06 AJS
        OPEN O_RC1 FOR V_EXEC USING P_DIVISION_ID;                                                   --  2026.10.06 AJS

        --임시테이블 삭제
        DBMS_LOB.FREETEMPORARY(V_QRY_SUM);
        DBMS_LOB.FREETEMPORARY(V_QRY_PIVOT);    --  2026.10.29 AJS

        OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE
                                      , 'SUCCESS' AS MSG
                                      , TO_CHAR(0) AS EVENT
                                   FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE
                                          , V_ERR_MSG AS MSG
                                          , TO_CHAR(0) AS EVENT
                                       FROM DUAL;

    END P_SCP0031_GET_GLOBAL_PSI;

END PKG_SCP0031;