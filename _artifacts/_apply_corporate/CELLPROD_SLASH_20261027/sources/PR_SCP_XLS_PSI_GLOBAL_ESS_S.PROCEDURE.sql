PROCEDURE PR_SCP_XLS_PSI_GLOBAL_ESS_S
(
      P_PLAN_CYCLE            VARCHAR2                        /* NVARCHAR(0150) */
    , P_PLAN_START_YYYYMMDD   VARCHAR2                        /* NVARCHAR(0008) */
    , P_PLAN_ID               VARCHAR2                        /* NVARCHAR(4000) */
    , P_MODELING_ID           VARCHAR2                        /* NVARCHAR(4000) */
    , P_SEQ                   VARCHAR2                        /* NVARCHAR(4000) */
    , P_PLAN_TYPE             VARCHAR2                        /* NVARCHAR(4000) */
    , P_MASTER_ID             VARCHAR2                        /* NVARCHAR(4000) */
    , P_DIVISION_ID           VARCHAR2                        /* NVARCHAR(0030) */
    , P_ENGINE_PLAN_ID        VARCHAR2                        /* NVARCHAR(4000) */
    , P_CREATE_FROM_YYYYMMDD  VARCHAR2                        /* NVARCHAR(0008) */
    , P_CREATE_TO_YYYYMMDD    VARCHAR2                        /* NVARCHAR(0008) */
    , P_USER_ID               VARCHAR2 DEFAULT 'SCP_batch'    /* NVARCHAR(0150) = 'SCP_batch' */
    , P_IS_DEBUG              VARCHAR2 DEFAULT '0'            /* bit = 0  : 0=RELEASE, 1=DEBUG */
    , O_RETURN_CODE           OUT NUMBER                      /* ★신설 : MSSQL 의 return 값(계약서 §1) */
)
AS
/*
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_ESS_S
 * Description  : PR_SCP_XLS_CREATE_DATA 에서 호출함.
 * OutTable     :
 * Execute      :
    -- DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='kth'
      EXEC PR_SCP_XLS_PSI_GLOBAL_ESS_S @p_plan_cycle          = 'WEEKLY'
             , @p_plan_start_yyyymmdd = '20190325'
             , @p_plan_id             = '1071'
             , @p_modeling_id         = '2'
             , @p_seq                 = '1'
             , @p_plan_type           = 'PR'
             , @p_master_id           = '81::WEEKLY'
             , @p_division_id         = '81'
             , @p_engine_plan_id      = '1071::PR::1'
             , @p_user_id             = 'KTH'

    SELECT * FROM SCM_SYS_LOG_BATCH  where PROGRAM_NAME ='PR_SCP_XLS_PSI_GLOBAL_ESS_S' order by 1 desc

 * Program History
 *======================================================================================
 *   Date       In Charge      Description
 *======================================================================================
 * 2021.05.25   KSW         NICK_NAME 누락방지
 * 2021.06.02   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전으로 신규생성
                            - 구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (1 YEAR 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결)
 * 2021.08.23   KSW         PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
 * 2021.11.15   KSW         튜닝개선 - 0값 제거 및 쿼리재조정
 * 2021.12.22   KSW			DC.Link 적용 - ATTRIBUTE6 update
 * 2021.04.01   KSW         DC LINK 공용모델 적용
 * 2022.05.12   KSW         복수 BOD 수립관련건 적용
 * 2022.07.01	KSK		    PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화 분리
 * 2025.08.12	KSK         E20250805-000724	ess 사업부 시뮬레이터 특정 모델 저장 안되는 이슈
 * 2025.09.02	kimcd		속도 개선 HASH 추가
 * 2026.06.19   ymh         E20260618-001229 ESS 시뮬레이터 중복 키값 호출 로직 추가 시작 - dc link 코드목록 넣는부분 item_code 순서대로 넣음.
 *--------------------------------------------------------------------------------------
 * 변환(MSSQL->Oracle) : 재변환. MSSQL 운영본(2026-08-12 추출) 단독 근거.
 *   - ★반환값 : MSSQL `EXEC @rows = PR_SCP_XLS_PSI_GLOBAL_ESS_S` 로 호출자
 *     PR_SCP_XLS_PSI_GLOBAL_ESS 가 반환값을 받아 분기한다(운영 L4606·L4647 실측).
 *     Oracle PROCEDURE 는 반환값이 없으므로 XLSPSI 계약서 §1 대로 마지막 파라미터
 *     O_RETURN_CODE OUT NUMBER 로 옮긴다. 진입 직후 1(정상값)로 초기화한다.
 *     원본 return 지점 = L3382 `return -1`(CATCH) / L3403 `return 1`(정상 종료).
 *     ※L1471 `return;` 은 주석 블록(L1466~L1472) 안의 죽은 코드라 대상 아님.
 *   - ★결과셋 : 호출자가 INSERT..EXEC 가 아니라 반환값만 받으므로 결과셋 반환 없음.
 *   - #temp 22종 → GTT 22종. 매핑 근거는 2_db_convert/work/xlspsi_global_ess_gtt_map.csv
 *     (배포본이 주석 안의 #temp 이름까지 GTT 로 치환해 둔 것을 원본 주석과 1:1 대조해 확정).
 *   - SET TRANSACTION ISOLATION LEVEL / NOCOUNT / XACT_ABORT / ANSI_WARNINGS / ANSI_NULLS
 *     → Oracle 무대응(H-13 원본 구문은 주석 보존).
 *   - SYSDATETIME() → SYSDATE. N'...' → '...'.
 * 2026.07.06	ZIONEX		[PJ202650304] NextSCM Migration
 */
    /* 원본 L61~L66 : Oracle 무대응(H-13)
       SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
       SET NOCOUNT ON;
       SET XACT_ABORT ON;
       --SET ANSI_WARNINGS OFF;
       SET ANSI_WARNINGS ON;
       SET ANSI_NULLS ON;                                                     */

    /* LOG 용 변수 설정 */
    V_BATCH_USER     VARCHAR2(150 CHAR)  := 'SCP_batch';
    V_PROGRAM_NAME   VARCHAR2(150 CHAR)  := 'PR_SCP_XLS_PSI_GLOBAL_ESS_S';
    V_LOG_TYPE       VARCHAR2(30 CHAR);                     /* START/END/ERROR/... */
    N_LOG_COUNT      INTEGER             := 0;
    V_LOG_MESSAGE    VARCHAR2(1000 CHAR);
    V_DESCRIPTION    VARCHAR2(500 CHAR);
    V_TABLE_ID       VARCHAR2(150 CHAR)  := 'SCM_SYS_LOG_BATC';
    D_EVENT_DATE     DATE;

    /* 실행시간 확인용 */
    V_START_TIME     DATE                := SYSDATE;
    V_EXEC_TIME      VARCHAR2(10 CHAR)   := '';             /* '00:00' */

    V_PROGRAM_ID     VARCHAR2(30 CHAR)   := 'XLSPSI14';
    /* 원본 주석 보존(H-13)
       --DECLARE @p_to_yyyymmdd  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112)
       --DECLARE @p_cutoff_date  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day,  -1, @p_plan_start_yyyymmdd), 112)
       --DECLARE @debug_mode            NVARCHAR(30) = 'T'                    */

    /*  동적 SQL 조립 버퍼. 원본 @mQry_sum/@mQry_sum2/@mEXEC 는 전부 NVARCHAR(MAX).
        364컬럼 조립 길이가 32,767자를 넘으므로 VARCHAR2 로는 담을 수 없다 -> CLOB (CV-040/CV-046) */
    V_MQRY_SUM       CLOB;
    V_MQRY_SUM2      CLOB;
    V_MEXEC          CLOB;
    V_MQRY_SUMWEEK   CLOB;   /* 원본 @mQry_sumWeek (주간합계 UPDATE 조립) */

    /* 원본 @V_DC_CNT / @V_ADD_CNT (DC Link 모듈 반복 카운터, L3248~L3312) */
    V_DC_CNT         INTEGER             := 0;
    V_ADD_CNT        INTEGER             := 0;

BEGIN
    /* 원본 정상 종료값(L3403 return 1). 경로별로 덮어쓴다(계약서 §1). */
    O_RETURN_CODE := 1;

    V_BATCH_USER := P_USER_ID;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME || ':' || 'INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER );


    /* =====================================================================================
       [구간1] 원본 L106~L483
       Line Load 율 - #LineLoad 를 1 YEAR 단위로 처리하기 위해서 다시 생성함
       ===================================================================================== */
    /* 원본 L111~L112 : IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL DROP TABLE #LineLoad;
       -> GTT 는 사전 배포되어 있으므로 DELETE 로 초기화(재실행 대비) */
    DELETE
      FROM GT_SCXL_LINELOAD;

    INSERT INTO GT_SCXL_LINELOAD
         ( DIVISION_ID, SCM_SITE_ID, OPERATION_GROUP, OPERATION_ID, LINE_ID
         , MEASURE, QTY, CAPA_TACT, WORKING_TIME, YYYYMMDD, ISO_YYYYWW, WEEK_COLUMN )
    SELECT /* DISTINCT */
           A.DIVISION_ID
         , A.SCM_SITE_ID
         , A.OPERATION_GROUP
         , A.OPERATION_ID
         , A.LINE_ID
         , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                 WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD' END ) AS MEASURE
         , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0
                ELSE NVL( ( ( ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0) / D.WORKING_TIME ) ), 0 ) * 100 END AS QTY
         , NVL(ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0), 0) AS CAPA_TACT
         , NVL( D.WORKING_TIME, 0 ) AS WORKING_TIME
         , A.YYYYMMDD AS YYYYMMDD
         , C.ISO_YYYYWW AS ISO_YYYYWW
           /* 원본 'WQTY' + REPLICATE('0', 2 - LEN(DENSE_RANK() ...)) + CONVERT(NVARCHAR, DENSE_RANK() ...)
              -> LPAD 로 등가 변환(형제 PR_SCP_XLS_ADD_XLSPSI01_S L3449 선례 준용) */
         , 'WQTY' || LPAD(TO_CHAR(DENSE_RANK() OVER(PARTITION BY A.LINE_ID ORDER BY C.ISO_YYYYWW)), 2, '0') AS WEEK_COLUMN
      FROM SCP_ANL_PRODUCTION_PLAN A
     INNER JOIN SCM_SYS_CALENDAR_M C
        ON A.YYYYMMDD = C.BASIS_YYYYMMDD
      LEFT OUTER JOIN GT_SCXL_LINE_WORKTIME D
        ON  A.DIVISION_ID  = D.DIVISION_ID
        AND A.OPERATION_ID = D.OPERATION_ID
        AND A.SCM_SITE_ID  = D.SCM_SITE_ID
        AND A.LINE_ID      = D.LINE_ID
        AND A.YYYYMMDD     = D.YYYYMMDD
      LEFT OUTER JOIN SCP_ANL_TACT_TIME E
        ON  A.DIVISION_ID  = E.DIVISION_ID
        AND A.OPERATION_ID = E.OPERATION_ID
        AND A.SCM_SITE_ID  = E.SCM_SITE_ID
        AND A.LINE_ID      = E.LINE_ID
        AND A.ITEM_ID      = E.ITEM_ID
        AND A.YYYYMMDD     = E.YYYYMMDD
     WHERE 1 = 1
       AND A.DIVISION_ID         = P_DIVISION_ID
       AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
       AND A.PLAN_TYPE           = P_PLAN_TYPE
       AND A.SEQ                 = P_SEQ
       AND A.YYYYMMDD           >= P_CREATE_FROM_YYYYMMDD
       AND A.YYYYMMDD           <= P_CREATE_TO_YYYYMMDD
       /* 원본 L151 주석 보존 : AND A.MEASURE IN ('CELL_PROD','PACK_PROD') */
       AND A.MEASURE             IN ('PROD_PLAN_AMEND')
     GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.OPERATION_ID, A.LINE_ID, A.YYYYMMDD, D.WORKING_TIME, C.ISO_YYYYWW, A.OPERATION_GROUP
            , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                    WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD' END );


    /* -------------------------------------------------------------------------------------
       전체 임시 테이블 생성  (#SCP_XLS_PSI_GLOBAL_ESS)   원본 L159~L217
       원본은 CREATE TABLE #SCP_XLS_PSI_GLOBAL_ESS(...409컬럼...) 로 매번 생성한다.
       -> Oracle 은 GTT GT_SCXL_PSI_GLOBAL_ESS(409컬럼) 가 사전 배포되어 있으므로 DELETE 로 초기화.
       ------------------------------------------------------------------------------------- */
    DELETE
      FROM GT_SCXL_PSI_GLOBAL_ESS;

    /* -------------------------------------------------------------------------------------
       원본 L226~L241 : @mQry_sum 조립
         SELECT @mQry_sum = @mQry_sum + ',' + ' SUM(CASE WHEN YYYYMMDD = ''..'' THEN ISNULL(QTY,0)
                ELSE 0 END ) AS QTY001..' + CHAR(10)  FROM (달력 GROUP BY) ORDER BY SORT_ORDER_NO
       -> MSSQL 의 "집계 대입"(SELECT @x = @x + ..) 은 Oracle 에 없으므로 커서 FOR 루프로 옮긴다.
          정렬(ORDER BY SORT_ORDER_NO)이 컬럼 번호를 정하므로 루프 순서를 반드시 보존한다.
       ------------------------------------------------------------------------------------- */
    V_MQRY_SUM := '';
    FOR R IN ( SELECT A.YYYYMMDD
                    , ' SUM(CASE WHEN YYYYMMDD = ''' || A.YYYYMMDD || '''    THEN NVL(QTY, 0) ELSE 0 END ) AS '
                      || 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.YYYYMMDD)), 3, '0') AS COL_EXPR
                 FROM ( SELECT A.BASIS_YYYYMMDD AS YYYYMMDD
                             , A.BASIS_YYYYMMDD || TO_CHAR(31) AS SORT_ORDER_NO
                          FROM SCM_SYS_CALENDAR_M A
                         WHERE A.BASIS_YYYYMMDD >= P_CREATE_FROM_YYYYMMDD
                           AND A.BASIS_YYYYMMDD <= P_CREATE_TO_YYYYMMDD
                         GROUP BY A.BASIS_YYYYMMDD ) A
                ORDER BY A.SORT_ORDER_NO ) LOOP
        V_MQRY_SUM := V_MQRY_SUM || ',' || R.COL_EXPR || '' || CHR(10);
    END LOOP;

    /* -------------------------------------------------------------------------------------
       원본 L247~L262 : @mQry_sum2 조립  ( 'ISNULL(QTY001' .. ',0)' )
       ------------------------------------------------------------------------------------- */
    V_MQRY_SUM2 := '';
    FOR R IN ( SELECT A.YYYYMMDD
                    , 'NVL(QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.YYYYMMDD)), 3, '0') AS COL_EXPR
                 FROM ( SELECT A.BASIS_YYYYMMDD AS YYYYMMDD
                             , A.BASIS_YYYYMMDD || TO_CHAR(31) AS SORT_ORDER_NO
                          FROM SCM_SYS_CALENDAR_M A
                         WHERE A.BASIS_YYYYMMDD >= P_CREATE_FROM_YYYYMMDD
                           AND A.BASIS_YYYYMMDD <= P_CREATE_TO_YYYYMMDD
                         GROUP BY A.BASIS_YYYYMMDD ) A
                ORDER BY A.SORT_ORDER_NO ) LOOP
        V_MQRY_SUM2 := V_MQRY_SUM2 || ',' || R.COL_EXPR || ',0)' || CHR(10);
    END LOOP;

    /* -------------------------------------------------------------------------------------
       원본 L267~L455 : @mEXEC 조립 후 EXEC sp_executesql
         MSSQL `SET @mEXEC = @mEXEC + '..' + CHAR(10)` -> Oracle `V_MEXEC := V_MEXEC || '..' || CHR(10);`
         MSSQL `EXEC sp_executesql @mEXEC`             -> Oracle `EXECUTE IMMEDIATE V_MEXEC;` (CV-040)
       ※원본 L272~L341 은 통째로 주석 처리된 구판 조립문이라 옮기지 않는다(死코드).
       ※원본의 `WITH (TABLOCK)` / `WITH (NOLOCK)` 은 MSSQL 잠금힌트 -> Oracle 무대응(SOP §3.11).
       ------------------------------------------------------------------------------------- */
    V_MEXEC := '';
    V_MEXEC := V_MEXEC || ' INSERT INTO GT_SCXL_PSI_GLOBAL_ESS  ' || CHR(10);
    V_MEXEC := V_MEXEC || 'SELECT  DIVISION_ID          ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,PLAN_START_YYYYMMDD  ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,PLAN_TYPE            ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,SEQ                  ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,OPERATION_GROUP      ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,OPERATION_GROUP_NAME ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,CELL_ITEM_ID         ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,ITEM_ID              ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,NICK_NAME            ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,CELL_QTY_PACK        ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,TO_SITE              ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,TO_SITE_DESCRIPTION  ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,PROJECT_CODE         ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,FROM_BOH_QTY         ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,TO_BOH_QTY           ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,INCOTERMS            ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,FROM_SITE            ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,FROM_SITE_DESCRIPTION' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,TRANSPORT_MODE       ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,PROD_LINE            ' || CHR(10);
    /* 원본 L362~L368 : ISNULL((SELECT TOP 1 ..), 0) -> NVL((SELECT .. AND ROWNUM = 1), 0) */
    V_MEXEC := V_MEXEC || '       ,NVL((SELECT LT_TOTAL_BY_WEEK                        ' || CHR(10);
    V_MEXEC := V_MEXEC || '               FROM GT_SCXL_BOD_V B                         ' || CHR(10);
    V_MEXEC := V_MEXEC || '              WHERE B.DIVISION_ID = XX.DIVISION_ID          ' || CHR(10);
    V_MEXEC := V_MEXEC || '                AND B.BOD_ID      = XX.BOD_ID               ' || CHR(10);
    V_MEXEC := V_MEXEC || '                AND B.FROM_SITE   = XX.FROM_SITE            ' || CHR(10);
    V_MEXEC := V_MEXEC || '                AND B.TO_SITE     = XX.TO_SITE              ' || CHR(10);
    V_MEXEC := V_MEXEC || '                AND B.INCOTERMS   = XX.INCOTERMS            ' || CHR(10);
    V_MEXEC := V_MEXEC || '                AND ROWNUM        = 1), 0) AS LT_DAY        ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,BOD_ID       ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,MEASURE      ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,MEASURE_LABEL' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,XLS_KEY1' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,XLS_KEY2' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,XLS_KEY3' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,XLS_KEY4' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,XLS_KEY5' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,XLS_ATTRIBUTE1' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,XLS_ATTRIBUTE2' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,XLS_ATTRIBUTE3' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,XLS_ATTRIBUTE4' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,XLS_ATTRIBUTE5' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,SORT_ORDER_NO ' || CHR(10);
    V_MEXEC := V_MEXEC || '        ' || V_MQRY_SUM2 || '        ' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,ATTRIBUTE1' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,ATTRIBUTE2' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,ATTRIBUTE3' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,ATTRIBUTE4' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,ATTRIBUTE5' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,ATTRIBUTE6' || CHR(10);
    V_MEXEC := V_MEXEC || '       ,ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10' || CHR(10);
    V_MEXEC := V_MEXEC || '  FROM (  ' || CHR(10);
    V_MEXEC := V_MEXEC || ' SELECT A.DIVISION_ID ' || CHR(10);
    V_MEXEC := V_MEXEC || '      , ''' || P_PLAN_START_YYYYMMDD || ''' AS PLAN_START_YYYYMMDD ' || CHR(10);
    V_MEXEC := V_MEXEC || '      , ''' || P_PLAN_TYPE           || ''' AS PLAN_TYPE ' || CHR(10);
    V_MEXEC := V_MEXEC || '      , ''' || P_SEQ                 || ''' AS SEQ ' || CHR(10);
    V_MEXEC := V_MEXEC || '      , A.OPERATION_GROUP ' || CHR(10);
    V_MEXEC := V_MEXEC || '      , (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL X WHERE X.LOOKUP_TYPE = ''OPERATION_GROUP'' AND X.SEGMENT1 = A.OPERATION_GROUP AND ROWNUM = 1 ) AS OPERATION_GROUP_NAME' || CHR(10);
    V_MEXEC := V_MEXEC || '      , A.CELL_ITEM_ID ' || CHR(10);
    V_MEXEC := V_MEXEC || '      , A.ITEM_ID ' || CHR(10);
    V_MEXEC := V_MEXEC || '      , (SELECT (CASE WHEN X.NICK_NAME IS NULL THEN ''-'' WHEN X.NICK_NAME = '''' THEN ''-'' ELSE X.NICK_NAME END) FROM SCM_MST_ITEM_SN X WHERE X.ITEM_ID = A.ITEM_ID AND X.DIVISION_ID = ''82'' AND ROWNUM = 1) AS NICK_NAME' || CHR(10);
    V_MEXEC := V_MEXEC || '      , 0 AS CELL_QTY_PACK' || CHR(10);
    V_MEXEC := V_MEXEC || '      , A.TO_SITE AS TO_SITE' || CHR(10);
    V_MEXEC := V_MEXEC || '      , NVL(NULLIF( (SELECT M.SITE_DESCRIPTION FROM SCM_MST_SITE M WHERE M.SCM_SITE_ID = A.TO_SITE AND ROWNUM = 1), '''') , ''-'') AS TO_SITE_DESCRIPTION' || CHR(10);
    V_MEXEC := V_MEXEC || '      , A.PROJECT_CODE' || CHR(10);
    V_MEXEC := V_MEXEC || '      , A.FROM_BOH_QTY' || CHR(10);
    V_MEXEC := V_MEXEC || '      , SUM(A.TO_BOH_QTY) AS TO_BOH_QTY' || CHR(10);
    V_MEXEC := V_MEXEC || '      , NVL(A.INCOTERMS,''-'') AS INCOTERMS' || CHR(10);
    V_MEXEC := V_MEXEC || '      , A.FROM_SITE' || CHR(10);
    V_MEXEC := V_MEXEC || '      , NVL(NULLIF( (SELECT M.SITE_DESCRIPTION FROM SCM_MST_SITE M WHERE M.SCM_SITE_ID = A.FROM_SITE AND ROWNUM = 1), '''') , ''-'') AS FROM_SITE_DESCRIPTION' || CHR(10);
    V_MEXEC := V_MEXEC || '      ,NVL(A.TRANSPORT_MODE,''-'') AS TRANSPORT_MODE' || CHR(10);
    V_MEXEC := V_MEXEC || '      ,NVL(A.PROD_LINE,''-'') AS PROD_LINE' || CHR(10);
    V_MEXEC := V_MEXEC || '      ,A.BOD_ID' || CHR(10);
    V_MEXEC := V_MEXEC || '      , A.MEASURE' || CHR(10);
    V_MEXEC := V_MEXEC || '      , A.COLUMN_LABEL_NAME           AS MEASURE_LABEL ' || CHR(10);
    /* 원본 L416~L426 : CONVERT(NVARCHAR(200), NULL) -> CAST(NULL AS VARCHAR2(200)) */
    V_MEXEC := V_MEXEC || '      , CAST(NULL AS VARCHAR2(200))  AS XLS_KEY1' || CHR(10);
    V_MEXEC := V_MEXEC || '      , CAST(NULL AS VARCHAR2(200))  AS XLS_KEY2' || CHR(10);
    V_MEXEC := V_MEXEC || '      , CAST(NULL AS VARCHAR2(200))  AS XLS_KEY3' || CHR(10);
    V_MEXEC := V_MEXEC || '      , CAST(NULL AS VARCHAR2(200))  AS XLS_KEY4' || CHR(10);
    V_MEXEC := V_MEXEC || '      , CAST(NULL AS VARCHAR2(200))  AS XLS_KEY5' || CHR(10);
    V_MEXEC := V_MEXEC || '      , CAST(NULL AS VARCHAR2(200))  AS XLS_ATTRIBUTE1' || CHR(10);
    V_MEXEC := V_MEXEC || '      , CAST(NULL AS VARCHAR2(200))  AS XLS_ATTRIBUTE2' || CHR(10);
    V_MEXEC := V_MEXEC || '      , CAST(NULL AS VARCHAR2(200))  AS XLS_ATTRIBUTE3' || CHR(10);
    V_MEXEC := V_MEXEC || '      , CAST(NULL AS VARCHAR2(200))  AS XLS_ATTRIBUTE4' || CHR(10);
    V_MEXEC := V_MEXEC || '      , CAST(NULL AS VARCHAR2(200))  AS XLS_ATTRIBUTE5' || CHR(10);
    V_MEXEC := V_MEXEC || '      , A.SORT_ORDER_NO ' || CHR(10);
    V_MEXEC := V_MEXEC || '        ' || V_MQRY_SUM || '        ' || CHR(10);
    V_MEXEC := V_MEXEC || '      , MAX(A.ATTRIBUTE1) AS ATTRIBUTE1' || CHR(10);
    V_MEXEC := V_MEXEC || '      , NULL AS ATTRIBUTE2' || CHR(10);
    V_MEXEC := V_MEXEC || '      , NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5, NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8' || CHR(10);
    V_MEXEC := V_MEXEC || '      , A.ATTRIBUTE9, NULL AS ATTRIBUTE10 ' || CHR(10);
    V_MEXEC := V_MEXEC || '   FROM GT_SCXL_PSI_GLOBAL_ESS_SRC A ' || CHR(10);
    V_MEXEC := V_MEXEC || '  WHERE A.YYYYMMDD    >= ''' || P_CREATE_FROM_YYYYMMDD || '''' || CHR(10);
    V_MEXEC := V_MEXEC || '    AND A.YYYYMMDD    <= ''' || P_CREATE_TO_YYYYMMDD   || '''' || CHR(10);
    V_MEXEC := V_MEXEC || '  GROUP BY  A.DIVISION_ID ' || CHR(10);
    V_MEXEC := V_MEXEC || '          , A.OPERATION_GROUP ' || CHR(10);
    V_MEXEC := V_MEXEC || '          , A.CELL_ITEM_ID ' || CHR(10);
    V_MEXEC := V_MEXEC || '          , A.ITEM_ID ' || CHR(10);
    V_MEXEC := V_MEXEC || '          , A.TO_SITE' || CHR(10);
    V_MEXEC := V_MEXEC || '          , A.PROJECT_CODE' || CHR(10);
    V_MEXEC := V_MEXEC || '          , A.FROM_BOH_QTY ' || CHR(10);
    V_MEXEC := V_MEXEC || '          , NVL(A.INCOTERMS,''-'')' || CHR(10);
    V_MEXEC := V_MEXEC || '          , A.FROM_SITE ' || CHR(10);
    V_MEXEC := V_MEXEC || '          , NVL(A.TRANSPORT_MODE ,''-'') ' || CHR(10);
    V_MEXEC := V_MEXEC || '          , NVL(A.PROD_LINE,''-'') ' || CHR(10);
    V_MEXEC := V_MEXEC || '          , A.BOD_ID' || CHR(10);
    V_MEXEC := V_MEXEC || '          , A.MEASURE ' || CHR(10);
    V_MEXEC := V_MEXEC || '          , A.SORT_ORDER_NO ' || CHR(10);
    V_MEXEC := V_MEXEC || '          , A.COLUMN_LABEL_NAME ' || CHR(10);
    V_MEXEC := V_MEXEC || '          , A.ATTRIBUTE9' || CHR(10);
    V_MEXEC := V_MEXEC || '        ' || CHR(10);
    V_MEXEC := V_MEXEC || ') XX ' || CHR(10);

    EXECUTE IMMEDIATE V_MEXEC;

    /* -------------------------------------------------------------------------------------
       [구간2] 원본 L476~L867 : #TRANSPORT_MODE 생성 + SHIP_PLAN 행 보충 INSERT 2건
       ------------------------------------------------------------------------------------- */
    /* 원본 L480~L492 : SELECT DISTINCT .. INTO #TRANSPORT_MODE */
    DELETE
      FROM GT_SCXL_TRANSPORT_MODE;

    INSERT INTO GT_SCXL_TRANSPORT_MODE
         ( DIVISION_ID, FROM_SITE, TO_SITE, INCOTERMS, TRANSPORT_MODE, LT_TOTAL, BOD_ID, PROJECT_CODE, LT_TOTAL_BY_WEEK )
    SELECT DISTINCT X.DIVISION_ID, X.FROM_SITE, X.TO_SITE, X.INCOTERMS, X.TRANSPORT_MODE, X.LT_TOTAL
         , X.BOD_ID, NVL(Y.PROJECT_CODE, '-') AS PROJECT_CODE, X.LT_TOTAL_BY_WEEK
      FROM GT_SCXL_BOD_V X
      LEFT OUTER JOIN GT_SCXL_PSI_GLOBAL_ESS Y
        ON  X.DIVISION_ID   = Y.DIVISION_ID
        AND X.FROM_SITE     = Y.FROM_SITE
        AND X.TO_SITE       = Y.TO_SITE
        AND X.INCOTERMS     = Y.INCOTERMS
        AND Y.PROJECT_CODE <> '-'
        AND X.BOD_ID        = Y.BOD_ID   /* PJ20209643 BOD L/T 2단계 BOD_ID 추가 */
    ;

    /* 원본 L502~L676 : SHIP_PLAN 행 보충(QTY 는 전부 0). NOT EXISTS 로 중복 방지 */
    INSERT INTO GT_SCXL_PSI_GLOBAL_ESS
    SELECT DIVISION_ID
         , PLAN_START_YYYYMMDD
         , PLAN_TYPE
         , SEQ
         , OPERATION_GROUP
         , OPERATION_GROUP_NAME
         , CELL_ITEM_ID
         , ITEM_ID
         , NICK_NAME
         , CELL_QTY_PACK
         , TO_SITE
         , TO_SITE_DESCRIPTION
         , PROJECT_CODE
         , FROM_BOH_QTY
         , TO_BOH_QTY
         , INCOTERMS
         , FROM_SITE
         , FROM_SITE_DESCRIPTION
         , TRANSPORT_MODE
         , PROD_LINE
         , LT_DAY
         , BOD_ID
         , MEASURE
         , MEASURE_LABEL
         , XLS_KEY1
         , XLS_KEY2
         , XLS_KEY3
         , XLS_KEY4
         , XLS_KEY5
         , XLS_ATTRIBUTE1
         , XLS_ATTRIBUTE2
         , XLS_ATTRIBUTE3
         , XLS_ATTRIBUTE4
         , XLS_ATTRIBUTE5
         , SORT_ORDER_NO
        , 0 AS QTY001, 0 AS QTY002, 0 AS QTY003, 0 AS QTY004, 0 AS QTY005, 0 AS QTY006, 0 AS QTY007, 0 AS QTY008, 0 AS QTY009, 0 AS QTY010
        , 0 AS QTY011, 0 AS QTY012, 0 AS QTY013, 0 AS QTY014, 0 AS QTY015, 0 AS QTY016, 0 AS QTY017, 0 AS QTY018, 0 AS QTY019, 0 AS QTY020
        , 0 AS QTY021, 0 AS QTY022, 0 AS QTY023, 0 AS QTY024, 0 AS QTY025, 0 AS QTY026, 0 AS QTY027, 0 AS QTY028, 0 AS QTY029, 0 AS QTY030
        , 0 AS QTY031, 0 AS QTY032, 0 AS QTY033, 0 AS QTY034, 0 AS QTY035, 0 AS QTY036, 0 AS QTY037, 0 AS QTY038, 0 AS QTY039, 0 AS QTY040
        , 0 AS QTY041, 0 AS QTY042, 0 AS QTY043, 0 AS QTY044, 0 AS QTY045, 0 AS QTY046, 0 AS QTY047, 0 AS QTY048, 0 AS QTY049, 0 AS QTY050
        , 0 AS QTY051, 0 AS QTY052, 0 AS QTY053, 0 AS QTY054, 0 AS QTY055, 0 AS QTY056, 0 AS QTY057, 0 AS QTY058, 0 AS QTY059, 0 AS QTY060
        , 0 AS QTY061, 0 AS QTY062, 0 AS QTY063, 0 AS QTY064, 0 AS QTY065, 0 AS QTY066, 0 AS QTY067, 0 AS QTY068, 0 AS QTY069, 0 AS QTY070
        , 0 AS QTY071, 0 AS QTY072, 0 AS QTY073, 0 AS QTY074, 0 AS QTY075, 0 AS QTY076, 0 AS QTY077, 0 AS QTY078, 0 AS QTY079, 0 AS QTY080
        , 0 AS QTY081, 0 AS QTY082, 0 AS QTY083, 0 AS QTY084, 0 AS QTY085, 0 AS QTY086, 0 AS QTY087, 0 AS QTY088, 0 AS QTY089, 0 AS QTY090
        , 0 AS QTY091, 0 AS QTY092, 0 AS QTY093, 0 AS QTY094, 0 AS QTY095, 0 AS QTY096, 0 AS QTY097, 0 AS QTY098, 0 AS QTY099, 0 AS QTY100
        , 0 AS QTY101, 0 AS QTY102, 0 AS QTY103, 0 AS QTY104, 0 AS QTY105, 0 AS QTY106, 0 AS QTY107, 0 AS QTY108, 0 AS QTY109, 0 AS QTY110
        , 0 AS QTY111, 0 AS QTY112, 0 AS QTY113, 0 AS QTY114, 0 AS QTY115, 0 AS QTY116, 0 AS QTY117, 0 AS QTY118, 0 AS QTY119, 0 AS QTY120
        , 0 AS QTY121, 0 AS QTY122, 0 AS QTY123, 0 AS QTY124, 0 AS QTY125, 0 AS QTY126, 0 AS QTY127, 0 AS QTY128, 0 AS QTY129, 0 AS QTY130
        , 0 AS QTY131, 0 AS QTY132, 0 AS QTY133, 0 AS QTY134, 0 AS QTY135, 0 AS QTY136, 0 AS QTY137, 0 AS QTY138, 0 AS QTY139, 0 AS QTY140
        , 0 AS QTY141, 0 AS QTY142, 0 AS QTY143, 0 AS QTY144, 0 AS QTY145, 0 AS QTY146, 0 AS QTY147, 0 AS QTY148, 0 AS QTY149, 0 AS QTY150
        , 0 AS QTY151, 0 AS QTY152, 0 AS QTY153, 0 AS QTY154, 0 AS QTY155, 0 AS QTY156, 0 AS QTY157, 0 AS QTY158, 0 AS QTY159, 0 AS QTY160
        , 0 AS QTY161, 0 AS QTY162, 0 AS QTY163, 0 AS QTY164, 0 AS QTY165, 0 AS QTY166, 0 AS QTY167, 0 AS QTY168, 0 AS QTY169, 0 AS QTY170
        , 0 AS QTY171, 0 AS QTY172, 0 AS QTY173, 0 AS QTY174, 0 AS QTY175, 0 AS QTY176, 0 AS QTY177, 0 AS QTY178, 0 AS QTY179, 0 AS QTY180
        , 0 AS QTY181, 0 AS QTY182, 0 AS QTY183, 0 AS QTY184, 0 AS QTY185, 0 AS QTY186, 0 AS QTY187, 0 AS QTY188, 0 AS QTY189, 0 AS QTY190
        , 0 AS QTY191, 0 AS QTY192, 0 AS QTY193, 0 AS QTY194, 0 AS QTY195, 0 AS QTY196, 0 AS QTY197, 0 AS QTY198, 0 AS QTY199, 0 AS QTY200
        , 0 AS QTY201, 0 AS QTY202, 0 AS QTY203, 0 AS QTY204, 0 AS QTY205, 0 AS QTY206, 0 AS QTY207, 0 AS QTY208, 0 AS QTY209, 0 AS QTY210
        , 0 AS QTY211, 0 AS QTY212, 0 AS QTY213, 0 AS QTY214, 0 AS QTY215, 0 AS QTY216, 0 AS QTY217, 0 AS QTY218, 0 AS QTY219, 0 AS QTY220
        , 0 AS QTY221, 0 AS QTY222, 0 AS QTY223, 0 AS QTY224, 0 AS QTY225, 0 AS QTY226, 0 AS QTY227, 0 AS QTY228, 0 AS QTY229, 0 AS QTY230
        , 0 AS QTY231, 0 AS QTY232, 0 AS QTY233, 0 AS QTY234, 0 AS QTY235, 0 AS QTY236, 0 AS QTY237, 0 AS QTY238, 0 AS QTY239, 0 AS QTY240
        , 0 AS QTY241, 0 AS QTY242, 0 AS QTY243, 0 AS QTY244, 0 AS QTY245, 0 AS QTY246, 0 AS QTY247, 0 AS QTY248, 0 AS QTY249, 0 AS QTY250
        , 0 AS QTY251, 0 AS QTY252, 0 AS QTY253, 0 AS QTY254, 0 AS QTY255, 0 AS QTY256, 0 AS QTY257, 0 AS QTY258, 0 AS QTY259, 0 AS QTY260
        , 0 AS QTY261, 0 AS QTY262, 0 AS QTY263, 0 AS QTY264, 0 AS QTY265, 0 AS QTY266, 0 AS QTY267, 0 AS QTY268, 0 AS QTY269, 0 AS QTY270
        , 0 AS QTY271, 0 AS QTY272, 0 AS QTY273, 0 AS QTY274, 0 AS QTY275, 0 AS QTY276, 0 AS QTY277, 0 AS QTY278, 0 AS QTY279, 0 AS QTY280
        , 0 AS QTY281, 0 AS QTY282, 0 AS QTY283, 0 AS QTY284, 0 AS QTY285, 0 AS QTY286, 0 AS QTY287, 0 AS QTY288, 0 AS QTY289, 0 AS QTY290
        , 0 AS QTY291, 0 AS QTY292, 0 AS QTY293, 0 AS QTY294, 0 AS QTY295, 0 AS QTY296, 0 AS QTY297, 0 AS QTY298, 0 AS QTY299, 0 AS QTY300
        , 0 AS QTY301, 0 AS QTY302, 0 AS QTY303, 0 AS QTY304, 0 AS QTY305, 0 AS QTY306, 0 AS QTY307, 0 AS QTY308, 0 AS QTY309, 0 AS QTY310
        , 0 AS QTY311, 0 AS QTY312, 0 AS QTY313, 0 AS QTY314, 0 AS QTY315, 0 AS QTY316, 0 AS QTY317, 0 AS QTY318, 0 AS QTY319, 0 AS QTY320
        , 0 AS QTY321, 0 AS QTY322, 0 AS QTY323, 0 AS QTY324, 0 AS QTY325, 0 AS QTY326, 0 AS QTY327, 0 AS QTY328, 0 AS QTY329, 0 AS QTY330
        , 0 AS QTY331, 0 AS QTY332, 0 AS QTY333, 0 AS QTY334, 0 AS QTY335, 0 AS QTY336, 0 AS QTY337, 0 AS QTY338, 0 AS QTY339, 0 AS QTY340
        , 0 AS QTY341, 0 AS QTY342, 0 AS QTY343, 0 AS QTY344, 0 AS QTY345, 0 AS QTY346, 0 AS QTY347, 0 AS QTY348, 0 AS QTY349, 0 AS QTY350
        , 0 AS QTY351, 0 AS QTY352, 0 AS QTY353, 0 AS QTY354, 0 AS QTY355, 0 AS QTY356, 0 AS QTY357, 0 AS QTY358, 0 AS QTY359, 0 AS QTY360
        , 0 AS QTY361, 0 AS QTY362, 0 AS QTY363, 0 AS QTY364
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
      FROM (
            SELECT DISTINCT X.DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , OPERATION_GROUP
                 , OPERATION_GROUP_NAME
                 , CELL_ITEM_ID
                 , ITEM_ID
                 , NICK_NAME
                 , CELL_QTY_PACK
                 , X.TO_SITE
                 , TO_SITE_DESCRIPTION
                 , X.PROJECT_CODE
                 , FROM_BOH_QTY
                 , TO_BOH_QTY
                 , X.INCOTERMS
                 , X.FROM_SITE
                 , FROM_SITE_DESCRIPTION
                 , (CASE WHEN OPERATION_GROUP = 'P' THEN '-' ELSE NVL(Y.TRANSPORT_MODE, '-') END)  AS TRANSPORT_MODE
                 , PROD_LINE
                   /* 원본은 THEN '0'(문자) 이지만 대상 컬럼 LT_DAY 가 INT 라 MSSQL 이 숫자로 암묵변환한다.
                      Oracle 은 CASE 분기 타입이 같아야 하므로(ORA-00932) 숫자 0 으로 명시한다. 값은 동일. */
                 , (CASE WHEN OPERATION_GROUP = 'P' THEN 0 ELSE NVL(Y.LT_TOTAL_BY_WEEK, 0) END) AS LT_DAY
                 , (CASE WHEN OPERATION_GROUP = 'P' THEN '-' ELSE NVL(Y.BOD_ID, '-') END)  AS BOD_ID
                 , MEASURE
                 , MEASURE_LABEL
                 , XLS_KEY1
                 , XLS_KEY2
                 , XLS_KEY3
                 , XLS_KEY4
                 , XLS_KEY5
                 , XLS_ATTRIBUTE1
                 , XLS_ATTRIBUTE2
                 , XLS_ATTRIBUTE3
                 , XLS_ATTRIBUTE4
                 , XLS_ATTRIBUTE5
                 , SORT_ORDER_NO
                 , X.ATTRIBUTE1
                 , X.ATTRIBUTE2
                 , X.ATTRIBUTE3
                 , X.ATTRIBUTE4
                 , X.ATTRIBUTE5
                 , X.ATTRIBUTE6
                 , X.ATTRIBUTE7
                 , X.ATTRIBUTE8
                 , X.ATTRIBUTE9
                 , X.ATTRIBUTE10
              FROM GT_SCXL_PSI_GLOBAL_ESS X
              LEFT OUTER JOIN GT_SCXL_TRANSPORT_MODE Y
                ON  0 = 0
                AND X.DIVISION_ID  = Y.DIVISION_ID
                AND X.FROM_SITE    = Y.FROM_SITE
                AND X.TO_SITE      = Y.TO_SITE
                AND X.INCOTERMS    = Y.INCOTERMS
                AND X.PROJECT_CODE = Y.PROJECT_CODE
                AND X.BOD_ID       = Y.BOD_ID   /* PJ20209643 BOD L/T 2단계 BOD_ID 추가 */
                AND X.MEASURE      = 'SHIP_PLAN'
                /* 원본 L654 주석 보존 : AND X.TRANSPORT_MODE <> Y.TRANSPORT_MODE */
           ) SUB
     WHERE 1 = 1
       AND NOT EXISTS (
                        SELECT 1
                          FROM GT_SCXL_PSI_GLOBAL_ESS Z
                         WHERE 1 = 1
                           AND Z.DIVISION_ID     = SUB.DIVISION_ID
                           AND Z.OPERATION_GROUP = SUB.OPERATION_GROUP
                           AND Z.CELL_ITEM_ID    = SUB.CELL_ITEM_ID
                           AND Z.ITEM_ID         = SUB.ITEM_ID
                           AND Z.PROJECT_CODE    = SUB.PROJECT_CODE
                           AND Z.TO_SITE         = SUB.TO_SITE
                           AND Z.INCOTERMS       = SUB.INCOTERMS
                           AND Z.FROM_SITE       = SUB.FROM_SITE
                           AND Z.TRANSPORT_MODE  = SUB.TRANSPORT_MODE
                           AND Z.MEASURE         = SUB.MEASURE
                           AND Z.MEASURE         = 'SHIP_PLAN'
                           AND Z.BOD_ID          = SUB.BOD_ID
                      )
       AND SUB.MEASURE = 'SHIP_PLAN'
    ;

    /* 원본 L681~L855 : SEMI_SHIP_PLAN 행 보충. #1 과 달리 CASE 없이 Y. 값을 그대로 쓰고,
       조인에서 INCOTERMS 는 빠지며(원본 L829 주석) PROJECT_CODE 는 NVL 비교, NOT EXISTS 에 ATTRIBUTE1 이 추가된다. */
    INSERT INTO GT_SCXL_PSI_GLOBAL_ESS
    SELECT DIVISION_ID
         , PLAN_START_YYYYMMDD
         , PLAN_TYPE
         , SEQ
         , OPERATION_GROUP
         , OPERATION_GROUP_NAME
         , CELL_ITEM_ID
         , ITEM_ID
         , NICK_NAME
         , CELL_QTY_PACK
         , TO_SITE
         , TO_SITE_DESCRIPTION
         , PROJECT_CODE
         , FROM_BOH_QTY
         , TO_BOH_QTY
         , INCOTERMS
         , FROM_SITE
         , FROM_SITE_DESCRIPTION
         , TRANSPORT_MODE
         , PROD_LINE
         , LT_DAY
         , BOD_ID
         , MEASURE
         , MEASURE_LABEL
         , XLS_KEY1
         , XLS_KEY2
         , XLS_KEY3
         , XLS_KEY4
         , XLS_KEY5
         , XLS_ATTRIBUTE1
         , XLS_ATTRIBUTE2
         , XLS_ATTRIBUTE3
         , XLS_ATTRIBUTE4
         , XLS_ATTRIBUTE5
         , SORT_ORDER_NO
        , 0 AS QTY001, 0 AS QTY002, 0 AS QTY003, 0 AS QTY004, 0 AS QTY005, 0 AS QTY006, 0 AS QTY007, 0 AS QTY008, 0 AS QTY009, 0 AS QTY010
        , 0 AS QTY011, 0 AS QTY012, 0 AS QTY013, 0 AS QTY014, 0 AS QTY015, 0 AS QTY016, 0 AS QTY017, 0 AS QTY018, 0 AS QTY019, 0 AS QTY020
        , 0 AS QTY021, 0 AS QTY022, 0 AS QTY023, 0 AS QTY024, 0 AS QTY025, 0 AS QTY026, 0 AS QTY027, 0 AS QTY028, 0 AS QTY029, 0 AS QTY030
        , 0 AS QTY031, 0 AS QTY032, 0 AS QTY033, 0 AS QTY034, 0 AS QTY035, 0 AS QTY036, 0 AS QTY037, 0 AS QTY038, 0 AS QTY039, 0 AS QTY040
        , 0 AS QTY041, 0 AS QTY042, 0 AS QTY043, 0 AS QTY044, 0 AS QTY045, 0 AS QTY046, 0 AS QTY047, 0 AS QTY048, 0 AS QTY049, 0 AS QTY050
        , 0 AS QTY051, 0 AS QTY052, 0 AS QTY053, 0 AS QTY054, 0 AS QTY055, 0 AS QTY056, 0 AS QTY057, 0 AS QTY058, 0 AS QTY059, 0 AS QTY060
        , 0 AS QTY061, 0 AS QTY062, 0 AS QTY063, 0 AS QTY064, 0 AS QTY065, 0 AS QTY066, 0 AS QTY067, 0 AS QTY068, 0 AS QTY069, 0 AS QTY070
        , 0 AS QTY071, 0 AS QTY072, 0 AS QTY073, 0 AS QTY074, 0 AS QTY075, 0 AS QTY076, 0 AS QTY077, 0 AS QTY078, 0 AS QTY079, 0 AS QTY080
        , 0 AS QTY081, 0 AS QTY082, 0 AS QTY083, 0 AS QTY084, 0 AS QTY085, 0 AS QTY086, 0 AS QTY087, 0 AS QTY088, 0 AS QTY089, 0 AS QTY090
        , 0 AS QTY091, 0 AS QTY092, 0 AS QTY093, 0 AS QTY094, 0 AS QTY095, 0 AS QTY096, 0 AS QTY097, 0 AS QTY098, 0 AS QTY099, 0 AS QTY100
        , 0 AS QTY101, 0 AS QTY102, 0 AS QTY103, 0 AS QTY104, 0 AS QTY105, 0 AS QTY106, 0 AS QTY107, 0 AS QTY108, 0 AS QTY109, 0 AS QTY110
        , 0 AS QTY111, 0 AS QTY112, 0 AS QTY113, 0 AS QTY114, 0 AS QTY115, 0 AS QTY116, 0 AS QTY117, 0 AS QTY118, 0 AS QTY119, 0 AS QTY120
        , 0 AS QTY121, 0 AS QTY122, 0 AS QTY123, 0 AS QTY124, 0 AS QTY125, 0 AS QTY126, 0 AS QTY127, 0 AS QTY128, 0 AS QTY129, 0 AS QTY130
        , 0 AS QTY131, 0 AS QTY132, 0 AS QTY133, 0 AS QTY134, 0 AS QTY135, 0 AS QTY136, 0 AS QTY137, 0 AS QTY138, 0 AS QTY139, 0 AS QTY140
        , 0 AS QTY141, 0 AS QTY142, 0 AS QTY143, 0 AS QTY144, 0 AS QTY145, 0 AS QTY146, 0 AS QTY147, 0 AS QTY148, 0 AS QTY149, 0 AS QTY150
        , 0 AS QTY151, 0 AS QTY152, 0 AS QTY153, 0 AS QTY154, 0 AS QTY155, 0 AS QTY156, 0 AS QTY157, 0 AS QTY158, 0 AS QTY159, 0 AS QTY160
        , 0 AS QTY161, 0 AS QTY162, 0 AS QTY163, 0 AS QTY164, 0 AS QTY165, 0 AS QTY166, 0 AS QTY167, 0 AS QTY168, 0 AS QTY169, 0 AS QTY170
        , 0 AS QTY171, 0 AS QTY172, 0 AS QTY173, 0 AS QTY174, 0 AS QTY175, 0 AS QTY176, 0 AS QTY177, 0 AS QTY178, 0 AS QTY179, 0 AS QTY180
        , 0 AS QTY181, 0 AS QTY182, 0 AS QTY183, 0 AS QTY184, 0 AS QTY185, 0 AS QTY186, 0 AS QTY187, 0 AS QTY188, 0 AS QTY189, 0 AS QTY190
        , 0 AS QTY191, 0 AS QTY192, 0 AS QTY193, 0 AS QTY194, 0 AS QTY195, 0 AS QTY196, 0 AS QTY197, 0 AS QTY198, 0 AS QTY199, 0 AS QTY200
        , 0 AS QTY201, 0 AS QTY202, 0 AS QTY203, 0 AS QTY204, 0 AS QTY205, 0 AS QTY206, 0 AS QTY207, 0 AS QTY208, 0 AS QTY209, 0 AS QTY210
        , 0 AS QTY211, 0 AS QTY212, 0 AS QTY213, 0 AS QTY214, 0 AS QTY215, 0 AS QTY216, 0 AS QTY217, 0 AS QTY218, 0 AS QTY219, 0 AS QTY220
        , 0 AS QTY221, 0 AS QTY222, 0 AS QTY223, 0 AS QTY224, 0 AS QTY225, 0 AS QTY226, 0 AS QTY227, 0 AS QTY228, 0 AS QTY229, 0 AS QTY230
        , 0 AS QTY231, 0 AS QTY232, 0 AS QTY233, 0 AS QTY234, 0 AS QTY235, 0 AS QTY236, 0 AS QTY237, 0 AS QTY238, 0 AS QTY239, 0 AS QTY240
        , 0 AS QTY241, 0 AS QTY242, 0 AS QTY243, 0 AS QTY244, 0 AS QTY245, 0 AS QTY246, 0 AS QTY247, 0 AS QTY248, 0 AS QTY249, 0 AS QTY250
        , 0 AS QTY251, 0 AS QTY252, 0 AS QTY253, 0 AS QTY254, 0 AS QTY255, 0 AS QTY256, 0 AS QTY257, 0 AS QTY258, 0 AS QTY259, 0 AS QTY260
        , 0 AS QTY261, 0 AS QTY262, 0 AS QTY263, 0 AS QTY264, 0 AS QTY265, 0 AS QTY266, 0 AS QTY267, 0 AS QTY268, 0 AS QTY269, 0 AS QTY270
        , 0 AS QTY271, 0 AS QTY272, 0 AS QTY273, 0 AS QTY274, 0 AS QTY275, 0 AS QTY276, 0 AS QTY277, 0 AS QTY278, 0 AS QTY279, 0 AS QTY280
        , 0 AS QTY281, 0 AS QTY282, 0 AS QTY283, 0 AS QTY284, 0 AS QTY285, 0 AS QTY286, 0 AS QTY287, 0 AS QTY288, 0 AS QTY289, 0 AS QTY290
        , 0 AS QTY291, 0 AS QTY292, 0 AS QTY293, 0 AS QTY294, 0 AS QTY295, 0 AS QTY296, 0 AS QTY297, 0 AS QTY298, 0 AS QTY299, 0 AS QTY300
        , 0 AS QTY301, 0 AS QTY302, 0 AS QTY303, 0 AS QTY304, 0 AS QTY305, 0 AS QTY306, 0 AS QTY307, 0 AS QTY308, 0 AS QTY309, 0 AS QTY310
        , 0 AS QTY311, 0 AS QTY312, 0 AS QTY313, 0 AS QTY314, 0 AS QTY315, 0 AS QTY316, 0 AS QTY317, 0 AS QTY318, 0 AS QTY319, 0 AS QTY320
        , 0 AS QTY321, 0 AS QTY322, 0 AS QTY323, 0 AS QTY324, 0 AS QTY325, 0 AS QTY326, 0 AS QTY327, 0 AS QTY328, 0 AS QTY329, 0 AS QTY330
        , 0 AS QTY331, 0 AS QTY332, 0 AS QTY333, 0 AS QTY334, 0 AS QTY335, 0 AS QTY336, 0 AS QTY337, 0 AS QTY338, 0 AS QTY339, 0 AS QTY340
        , 0 AS QTY341, 0 AS QTY342, 0 AS QTY343, 0 AS QTY344, 0 AS QTY345, 0 AS QTY346, 0 AS QTY347, 0 AS QTY348, 0 AS QTY349, 0 AS QTY350
        , 0 AS QTY351, 0 AS QTY352, 0 AS QTY353, 0 AS QTY354, 0 AS QTY355, 0 AS QTY356, 0 AS QTY357, 0 AS QTY358, 0 AS QTY359, 0 AS QTY360
        , 0 AS QTY361, 0 AS QTY362, 0 AS QTY363, 0 AS QTY364
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
      FROM (
            SELECT DISTINCT X.DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , OPERATION_GROUP
                 , OPERATION_GROUP_NAME
                 , CELL_ITEM_ID
                 , ITEM_ID
                 , NICK_NAME
                 , CELL_QTY_PACK
                 , X.TO_SITE
                 , TO_SITE_DESCRIPTION
                 , X.PROJECT_CODE
                 , FROM_BOH_QTY
                 , TO_BOH_QTY
                 , X.INCOTERMS
                 , X.FROM_SITE
                 , FROM_SITE_DESCRIPTION
                 , Y.TRANSPORT_MODE
                 , PROD_LINE
                 , Y.LT_TOTAL_BY_WEEK AS LT_DAY
                 , Y.BOD_ID
                 , MEASURE
                 , MEASURE_LABEL
                 , XLS_KEY1
                 , XLS_KEY2
                 , XLS_KEY3
                 , XLS_KEY4
                 , XLS_KEY5
                 , XLS_ATTRIBUTE1
                 , XLS_ATTRIBUTE2
                 , XLS_ATTRIBUTE3
                 , XLS_ATTRIBUTE4
                 , XLS_ATTRIBUTE5
                 , SORT_ORDER_NO
                 , X.ATTRIBUTE1
                 , X.ATTRIBUTE2
                 , X.ATTRIBUTE3
                 , X.ATTRIBUTE4
                 , X.ATTRIBUTE5
                 , X.ATTRIBUTE6
                 , X.ATTRIBUTE7
                 , X.ATTRIBUTE8
                 , X.ATTRIBUTE9
                 , X.ATTRIBUTE10
              FROM GT_SCXL_PSI_GLOBAL_ESS X
              LEFT OUTER JOIN GT_SCXL_TRANSPORT_MODE Y
                ON  0 = 0
                AND X.DIVISION_ID  = Y.DIVISION_ID
                AND X.FROM_SITE    = Y.FROM_SITE
                AND X.TO_SITE      = Y.TO_SITE
                /* 원본 L829 주석 보존 : AND X.INCOTERMS = Y.INCOTERMS */
                AND X.PROJECT_CODE = NVL(Y.PROJECT_CODE, '-')
                AND X.BOD_ID       = Y.BOD_ID   /* PJ20209643 BOD L/T 2단계 BOD_ID 추가 */
                AND X.MEASURE      = 'SEMI_SHIP_PLAN'
                /* 원본 L833 주석 보존 : AND X.TRANSPORT_MODE <> Y.TRANSPORT_MODE */
           ) SUB
     WHERE 1 = 1
       AND NOT EXISTS (
                        SELECT 1
                          FROM GT_SCXL_PSI_GLOBAL_ESS Z
                         WHERE 1 = 1
                           AND Z.DIVISION_ID     = SUB.DIVISION_ID
                           AND Z.OPERATION_GROUP = SUB.OPERATION_GROUP
                           AND Z.CELL_ITEM_ID    = SUB.CELL_ITEM_ID
                           AND Z.ITEM_ID         = SUB.ITEM_ID
                           AND Z.PROJECT_CODE    = SUB.PROJECT_CODE
                           AND Z.TO_SITE         = SUB.TO_SITE
                           AND Z.INCOTERMS       = SUB.INCOTERMS
                           AND Z.FROM_SITE       = SUB.FROM_SITE
                           AND Z.TRANSPORT_MODE  = SUB.TRANSPORT_MODE
                           AND Z.MEASURE         = SUB.MEASURE
                           AND Z.MEASURE         = 'SEMI_SHIP_PLAN'
                           AND Z.BOD_ID          = SUB.BOD_ID
                           AND Z.ATTRIBUTE1      = SUB.ATTRIBUTE1
                      )
       AND SUB.MEASURE = 'SEMI_SHIP_PLAN'
    ;

    /* -------------------------------------------------------------------------------------
       [구간3] 원본 L868~L1215 : 라인(PROD_LINE)별 CELL_PROD/PACK_PROD 행 보충
       ★원본 `CROSS APPLY #tmp_SCP_MST_TACT_TIME Y` 는 테이블 대상이라 INNER JOIN 과 동치이고,
         조인 조건이 WHERE 절에 있으므로 콤마 조인(FROM X, Y WHERE ..)으로 옮긴다(결과 동일).
       ------------------------------------------------------------------------------------- */
    INSERT INTO GT_SCXL_PSI_GLOBAL_ESS
    SELECT DISTINCT X.DIVISION_ID
         , X.PLAN_START_YYYYMMDD
         , X.PLAN_TYPE
         , X.SEQ
         , X.OPERATION_GROUP
         , X.OPERATION_GROUP_NAME
         , X.CELL_ITEM_ID
         , X.ITEM_ID
         , X.NICK_NAME
         , X.CELL_QTY_PACK
         , TO_SITE
         , TO_SITE_DESCRIPTION
         , PROJECT_CODE
         , FROM_BOH_QTY
         , TO_BOH_QTY
         , INCOTERMS
         , FROM_SITE
         , FROM_SITE_DESCRIPTION
         , TRANSPORT_MODE
         , Y.LINE_ID AS PROD_LINE
         , LT_DAY
         , BOD_ID
         , X.MEASURE
         , X.MEASURE_LABEL
         , X.XLS_KEY1
         , X.XLS_KEY2
         , X.XLS_KEY3
         , X.XLS_KEY4
         , X.XLS_KEY5
         , X.XLS_ATTRIBUTE1
         , X.XLS_ATTRIBUTE2
         , X.XLS_ATTRIBUTE3
         , X.XLS_ATTRIBUTE4
         , X.XLS_ATTRIBUTE5
         , X.SORT_ORDER_NO
        , 0 AS QTY001, 0 AS QTY002, 0 AS QTY003, 0 AS QTY004, 0 AS QTY005, 0 AS QTY006, 0 AS QTY007, 0 AS QTY008, 0 AS QTY009, 0 AS QTY010
        , 0 AS QTY011, 0 AS QTY012, 0 AS QTY013, 0 AS QTY014, 0 AS QTY015, 0 AS QTY016, 0 AS QTY017, 0 AS QTY018, 0 AS QTY019, 0 AS QTY020
        , 0 AS QTY021, 0 AS QTY022, 0 AS QTY023, 0 AS QTY024, 0 AS QTY025, 0 AS QTY026, 0 AS QTY027, 0 AS QTY028, 0 AS QTY029, 0 AS QTY030
        , 0 AS QTY031, 0 AS QTY032, 0 AS QTY033, 0 AS QTY034, 0 AS QTY035, 0 AS QTY036, 0 AS QTY037, 0 AS QTY038, 0 AS QTY039, 0 AS QTY040
        , 0 AS QTY041, 0 AS QTY042, 0 AS QTY043, 0 AS QTY044, 0 AS QTY045, 0 AS QTY046, 0 AS QTY047, 0 AS QTY048, 0 AS QTY049, 0 AS QTY050
        , 0 AS QTY051, 0 AS QTY052, 0 AS QTY053, 0 AS QTY054, 0 AS QTY055, 0 AS QTY056, 0 AS QTY057, 0 AS QTY058, 0 AS QTY059, 0 AS QTY060
        , 0 AS QTY061, 0 AS QTY062, 0 AS QTY063, 0 AS QTY064, 0 AS QTY065, 0 AS QTY066, 0 AS QTY067, 0 AS QTY068, 0 AS QTY069, 0 AS QTY070
        , 0 AS QTY071, 0 AS QTY072, 0 AS QTY073, 0 AS QTY074, 0 AS QTY075, 0 AS QTY076, 0 AS QTY077, 0 AS QTY078, 0 AS QTY079, 0 AS QTY080
        , 0 AS QTY081, 0 AS QTY082, 0 AS QTY083, 0 AS QTY084, 0 AS QTY085, 0 AS QTY086, 0 AS QTY087, 0 AS QTY088, 0 AS QTY089, 0 AS QTY090
        , 0 AS QTY091, 0 AS QTY092, 0 AS QTY093, 0 AS QTY094, 0 AS QTY095, 0 AS QTY096, 0 AS QTY097, 0 AS QTY098, 0 AS QTY099, 0 AS QTY100
        , 0 AS QTY101, 0 AS QTY102, 0 AS QTY103, 0 AS QTY104, 0 AS QTY105, 0 AS QTY106, 0 AS QTY107, 0 AS QTY108, 0 AS QTY109, 0 AS QTY110
        , 0 AS QTY111, 0 AS QTY112, 0 AS QTY113, 0 AS QTY114, 0 AS QTY115, 0 AS QTY116, 0 AS QTY117, 0 AS QTY118, 0 AS QTY119, 0 AS QTY120
        , 0 AS QTY121, 0 AS QTY122, 0 AS QTY123, 0 AS QTY124, 0 AS QTY125, 0 AS QTY126, 0 AS QTY127, 0 AS QTY128, 0 AS QTY129, 0 AS QTY130
        , 0 AS QTY131, 0 AS QTY132, 0 AS QTY133, 0 AS QTY134, 0 AS QTY135, 0 AS QTY136, 0 AS QTY137, 0 AS QTY138, 0 AS QTY139, 0 AS QTY140
        , 0 AS QTY141, 0 AS QTY142, 0 AS QTY143, 0 AS QTY144, 0 AS QTY145, 0 AS QTY146, 0 AS QTY147, 0 AS QTY148, 0 AS QTY149, 0 AS QTY150
        , 0 AS QTY151, 0 AS QTY152, 0 AS QTY153, 0 AS QTY154, 0 AS QTY155, 0 AS QTY156, 0 AS QTY157, 0 AS QTY158, 0 AS QTY159, 0 AS QTY160
        , 0 AS QTY161, 0 AS QTY162, 0 AS QTY163, 0 AS QTY164, 0 AS QTY165, 0 AS QTY166, 0 AS QTY167, 0 AS QTY168, 0 AS QTY169, 0 AS QTY170
        , 0 AS QTY171, 0 AS QTY172, 0 AS QTY173, 0 AS QTY174, 0 AS QTY175, 0 AS QTY176, 0 AS QTY177, 0 AS QTY178, 0 AS QTY179, 0 AS QTY180
        , 0 AS QTY181, 0 AS QTY182, 0 AS QTY183, 0 AS QTY184, 0 AS QTY185, 0 AS QTY186, 0 AS QTY187, 0 AS QTY188, 0 AS QTY189, 0 AS QTY190
        , 0 AS QTY191, 0 AS QTY192, 0 AS QTY193, 0 AS QTY194, 0 AS QTY195, 0 AS QTY196, 0 AS QTY197, 0 AS QTY198, 0 AS QTY199, 0 AS QTY200
        , 0 AS QTY201, 0 AS QTY202, 0 AS QTY203, 0 AS QTY204, 0 AS QTY205, 0 AS QTY206, 0 AS QTY207, 0 AS QTY208, 0 AS QTY209, 0 AS QTY210
        , 0 AS QTY211, 0 AS QTY212, 0 AS QTY213, 0 AS QTY214, 0 AS QTY215, 0 AS QTY216, 0 AS QTY217, 0 AS QTY218, 0 AS QTY219, 0 AS QTY220
        , 0 AS QTY221, 0 AS QTY222, 0 AS QTY223, 0 AS QTY224, 0 AS QTY225, 0 AS QTY226, 0 AS QTY227, 0 AS QTY228, 0 AS QTY229, 0 AS QTY230
        , 0 AS QTY231, 0 AS QTY232, 0 AS QTY233, 0 AS QTY234, 0 AS QTY235, 0 AS QTY236, 0 AS QTY237, 0 AS QTY238, 0 AS QTY239, 0 AS QTY240
        , 0 AS QTY241, 0 AS QTY242, 0 AS QTY243, 0 AS QTY244, 0 AS QTY245, 0 AS QTY246, 0 AS QTY247, 0 AS QTY248, 0 AS QTY249, 0 AS QTY250
        , 0 AS QTY251, 0 AS QTY252, 0 AS QTY253, 0 AS QTY254, 0 AS QTY255, 0 AS QTY256, 0 AS QTY257, 0 AS QTY258, 0 AS QTY259, 0 AS QTY260
        , 0 AS QTY261, 0 AS QTY262, 0 AS QTY263, 0 AS QTY264, 0 AS QTY265, 0 AS QTY266, 0 AS QTY267, 0 AS QTY268, 0 AS QTY269, 0 AS QTY270
        , 0 AS QTY271, 0 AS QTY272, 0 AS QTY273, 0 AS QTY274, 0 AS QTY275, 0 AS QTY276, 0 AS QTY277, 0 AS QTY278, 0 AS QTY279, 0 AS QTY280
        , 0 AS QTY281, 0 AS QTY282, 0 AS QTY283, 0 AS QTY284, 0 AS QTY285, 0 AS QTY286, 0 AS QTY287, 0 AS QTY288, 0 AS QTY289, 0 AS QTY290
        , 0 AS QTY291, 0 AS QTY292, 0 AS QTY293, 0 AS QTY294, 0 AS QTY295, 0 AS QTY296, 0 AS QTY297, 0 AS QTY298, 0 AS QTY299, 0 AS QTY300
        , 0 AS QTY301, 0 AS QTY302, 0 AS QTY303, 0 AS QTY304, 0 AS QTY305, 0 AS QTY306, 0 AS QTY307, 0 AS QTY308, 0 AS QTY309, 0 AS QTY310
        , 0 AS QTY311, 0 AS QTY312, 0 AS QTY313, 0 AS QTY314, 0 AS QTY315, 0 AS QTY316, 0 AS QTY317, 0 AS QTY318, 0 AS QTY319, 0 AS QTY320
        , 0 AS QTY321, 0 AS QTY322, 0 AS QTY323, 0 AS QTY324, 0 AS QTY325, 0 AS QTY326, 0 AS QTY327, 0 AS QTY328, 0 AS QTY329, 0 AS QTY330
        , 0 AS QTY331, 0 AS QTY332, 0 AS QTY333, 0 AS QTY334, 0 AS QTY335, 0 AS QTY336, 0 AS QTY337, 0 AS QTY338, 0 AS QTY339, 0 AS QTY340
        , 0 AS QTY341, 0 AS QTY342, 0 AS QTY343, 0 AS QTY344, 0 AS QTY345, 0 AS QTY346, 0 AS QTY347, 0 AS QTY348, 0 AS QTY349, 0 AS QTY350
        , 0 AS QTY351, 0 AS QTY352, 0 AS QTY353, 0 AS QTY354, 0 AS QTY355, 0 AS QTY356, 0 AS QTY357, 0 AS QTY358, 0 AS QTY359, 0 AS QTY360
        , 0 AS QTY361, 0 AS QTY362, 0 AS QTY363, 0 AS QTY364
         , X.ATTRIBUTE1
         , X.ATTRIBUTE2
         , X.ATTRIBUTE3
         , X.ATTRIBUTE4
         , X.ATTRIBUTE5
         , X.ATTRIBUTE6
         , X.ATTRIBUTE7
         , X.ATTRIBUTE8
         , X.ATTRIBUTE9
         , X.ATTRIBUTE10
      FROM GT_SCXL_PSI_GLOBAL_ESS X
         , GT_SCXL_TACT_TIME_TMP Y   /* 원본 CROSS APPLY */
     WHERE 0 = 0
       AND X.DIVISION_ID = Y.DIVISION_ID
       AND X.ITEM_ID     = Y.ITEM_ID
       AND X.FROM_SITE   = Y.PLANT_SITE_ID
       AND X.MEASURE     IN ('CELL_PROD','PACK_PROD')
       AND NOT EXISTS (
                        SELECT 1
                          FROM GT_SCXL_PSI_GLOBAL_ESS Z
                         WHERE 1 = 1
                           AND Z.DIVISION_ID  = X.DIVISION_ID
                           AND Z.CELL_ITEM_ID = X.CELL_ITEM_ID
                           AND Z.ITEM_ID      = X.ITEM_ID
                           AND Z.MEASURE      = X.MEASURE
                           AND Z.FROM_SITE    = Y.PLANT_SITE_ID
                           AND Z.PROD_LINE    = Y.LINE_ID
                           AND Z.MEASURE      IN ('CELL_PROD','PACK_PROD')
                      )
    UNION
    /* 원본 L997~L1107 : 같은 원천을 MEASURE 만 *_LOAD 로 바꿔 Load Ratio 행을 함께 만든다. */
    SELECT DISTINCT X.DIVISION_ID
         , X.PLAN_START_YYYYMMDD
         , X.PLAN_TYPE
         , X.SEQ
         , X.OPERATION_GROUP
         , X.OPERATION_GROUP_NAME
         , X.CELL_ITEM_ID
         , X.ITEM_ID
         , X.NICK_NAME
         , X.CELL_QTY_PACK
         , X.TO_SITE
         , X.TO_SITE_DESCRIPTION
         , X.PROJECT_CODE
         , X.FROM_BOH_QTY
         , X.TO_BOH_QTY
         , X.INCOTERMS
         , X.FROM_SITE
         , X.FROM_SITE_DESCRIPTION
         , X.TRANSPORT_MODE
         , Y.LINE_ID AS PROD_LINE
         , X.LT_DAY
         , X.BOD_ID
         , (CASE WHEN X.MEASURE = 'PACK_PROD' THEN 'PACK_PROD_LOAD'
                 WHEN X.MEASURE = 'CELL_PROD' THEN 'CELL_PROD_LOAD' END ) AS MEASURE
         , (CASE WHEN X.MEASURE = 'PACK_PROD' THEN 'Load Ratio(%)'
                 WHEN X.MEASURE = 'CELL_PROD' THEN 'Load Ratio(%)' END ) AS MEASURE_LABEL
         , X.XLS_KEY1
         , X.XLS_KEY2
         , X.XLS_KEY3
         , X.XLS_KEY4
         , X.XLS_KEY5
         , X.XLS_ATTRIBUTE1
         , X.XLS_ATTRIBUTE2
         , X.XLS_ATTRIBUTE3
         , X.XLS_ATTRIBUTE4
         , X.XLS_ATTRIBUTE5
         , X.SORT_ORDER_NO
        , 0 AS QTY001, 0 AS QTY002, 0 AS QTY003, 0 AS QTY004, 0 AS QTY005, 0 AS QTY006, 0 AS QTY007, 0 AS QTY008, 0 AS QTY009, 0 AS QTY010
        , 0 AS QTY011, 0 AS QTY012, 0 AS QTY013, 0 AS QTY014, 0 AS QTY015, 0 AS QTY016, 0 AS QTY017, 0 AS QTY018, 0 AS QTY019, 0 AS QTY020
        , 0 AS QTY021, 0 AS QTY022, 0 AS QTY023, 0 AS QTY024, 0 AS QTY025, 0 AS QTY026, 0 AS QTY027, 0 AS QTY028, 0 AS QTY029, 0 AS QTY030
        , 0 AS QTY031, 0 AS QTY032, 0 AS QTY033, 0 AS QTY034, 0 AS QTY035, 0 AS QTY036, 0 AS QTY037, 0 AS QTY038, 0 AS QTY039, 0 AS QTY040
        , 0 AS QTY041, 0 AS QTY042, 0 AS QTY043, 0 AS QTY044, 0 AS QTY045, 0 AS QTY046, 0 AS QTY047, 0 AS QTY048, 0 AS QTY049, 0 AS QTY050
        , 0 AS QTY051, 0 AS QTY052, 0 AS QTY053, 0 AS QTY054, 0 AS QTY055, 0 AS QTY056, 0 AS QTY057, 0 AS QTY058, 0 AS QTY059, 0 AS QTY060
        , 0 AS QTY061, 0 AS QTY062, 0 AS QTY063, 0 AS QTY064, 0 AS QTY065, 0 AS QTY066, 0 AS QTY067, 0 AS QTY068, 0 AS QTY069, 0 AS QTY070
        , 0 AS QTY071, 0 AS QTY072, 0 AS QTY073, 0 AS QTY074, 0 AS QTY075, 0 AS QTY076, 0 AS QTY077, 0 AS QTY078, 0 AS QTY079, 0 AS QTY080
        , 0 AS QTY081, 0 AS QTY082, 0 AS QTY083, 0 AS QTY084, 0 AS QTY085, 0 AS QTY086, 0 AS QTY087, 0 AS QTY088, 0 AS QTY089, 0 AS QTY090
        , 0 AS QTY091, 0 AS QTY092, 0 AS QTY093, 0 AS QTY094, 0 AS QTY095, 0 AS QTY096, 0 AS QTY097, 0 AS QTY098, 0 AS QTY099, 0 AS QTY100
        , 0 AS QTY101, 0 AS QTY102, 0 AS QTY103, 0 AS QTY104, 0 AS QTY105, 0 AS QTY106, 0 AS QTY107, 0 AS QTY108, 0 AS QTY109, 0 AS QTY110
        , 0 AS QTY111, 0 AS QTY112, 0 AS QTY113, 0 AS QTY114, 0 AS QTY115, 0 AS QTY116, 0 AS QTY117, 0 AS QTY118, 0 AS QTY119, 0 AS QTY120
        , 0 AS QTY121, 0 AS QTY122, 0 AS QTY123, 0 AS QTY124, 0 AS QTY125, 0 AS QTY126, 0 AS QTY127, 0 AS QTY128, 0 AS QTY129, 0 AS QTY130
        , 0 AS QTY131, 0 AS QTY132, 0 AS QTY133, 0 AS QTY134, 0 AS QTY135, 0 AS QTY136, 0 AS QTY137, 0 AS QTY138, 0 AS QTY139, 0 AS QTY140
        , 0 AS QTY141, 0 AS QTY142, 0 AS QTY143, 0 AS QTY144, 0 AS QTY145, 0 AS QTY146, 0 AS QTY147, 0 AS QTY148, 0 AS QTY149, 0 AS QTY150
        , 0 AS QTY151, 0 AS QTY152, 0 AS QTY153, 0 AS QTY154, 0 AS QTY155, 0 AS QTY156, 0 AS QTY157, 0 AS QTY158, 0 AS QTY159, 0 AS QTY160
        , 0 AS QTY161, 0 AS QTY162, 0 AS QTY163, 0 AS QTY164, 0 AS QTY165, 0 AS QTY166, 0 AS QTY167, 0 AS QTY168, 0 AS QTY169, 0 AS QTY170
        , 0 AS QTY171, 0 AS QTY172, 0 AS QTY173, 0 AS QTY174, 0 AS QTY175, 0 AS QTY176, 0 AS QTY177, 0 AS QTY178, 0 AS QTY179, 0 AS QTY180
        , 0 AS QTY181, 0 AS QTY182, 0 AS QTY183, 0 AS QTY184, 0 AS QTY185, 0 AS QTY186, 0 AS QTY187, 0 AS QTY188, 0 AS QTY189, 0 AS QTY190
        , 0 AS QTY191, 0 AS QTY192, 0 AS QTY193, 0 AS QTY194, 0 AS QTY195, 0 AS QTY196, 0 AS QTY197, 0 AS QTY198, 0 AS QTY199, 0 AS QTY200
        , 0 AS QTY201, 0 AS QTY202, 0 AS QTY203, 0 AS QTY204, 0 AS QTY205, 0 AS QTY206, 0 AS QTY207, 0 AS QTY208, 0 AS QTY209, 0 AS QTY210
        , 0 AS QTY211, 0 AS QTY212, 0 AS QTY213, 0 AS QTY214, 0 AS QTY215, 0 AS QTY216, 0 AS QTY217, 0 AS QTY218, 0 AS QTY219, 0 AS QTY220
        , 0 AS QTY221, 0 AS QTY222, 0 AS QTY223, 0 AS QTY224, 0 AS QTY225, 0 AS QTY226, 0 AS QTY227, 0 AS QTY228, 0 AS QTY229, 0 AS QTY230
        , 0 AS QTY231, 0 AS QTY232, 0 AS QTY233, 0 AS QTY234, 0 AS QTY235, 0 AS QTY236, 0 AS QTY237, 0 AS QTY238, 0 AS QTY239, 0 AS QTY240
        , 0 AS QTY241, 0 AS QTY242, 0 AS QTY243, 0 AS QTY244, 0 AS QTY245, 0 AS QTY246, 0 AS QTY247, 0 AS QTY248, 0 AS QTY249, 0 AS QTY250
        , 0 AS QTY251, 0 AS QTY252, 0 AS QTY253, 0 AS QTY254, 0 AS QTY255, 0 AS QTY256, 0 AS QTY257, 0 AS QTY258, 0 AS QTY259, 0 AS QTY260
        , 0 AS QTY261, 0 AS QTY262, 0 AS QTY263, 0 AS QTY264, 0 AS QTY265, 0 AS QTY266, 0 AS QTY267, 0 AS QTY268, 0 AS QTY269, 0 AS QTY270
        , 0 AS QTY271, 0 AS QTY272, 0 AS QTY273, 0 AS QTY274, 0 AS QTY275, 0 AS QTY276, 0 AS QTY277, 0 AS QTY278, 0 AS QTY279, 0 AS QTY280
        , 0 AS QTY281, 0 AS QTY282, 0 AS QTY283, 0 AS QTY284, 0 AS QTY285, 0 AS QTY286, 0 AS QTY287, 0 AS QTY288, 0 AS QTY289, 0 AS QTY290
        , 0 AS QTY291, 0 AS QTY292, 0 AS QTY293, 0 AS QTY294, 0 AS QTY295, 0 AS QTY296, 0 AS QTY297, 0 AS QTY298, 0 AS QTY299, 0 AS QTY300
        , 0 AS QTY301, 0 AS QTY302, 0 AS QTY303, 0 AS QTY304, 0 AS QTY305, 0 AS QTY306, 0 AS QTY307, 0 AS QTY308, 0 AS QTY309, 0 AS QTY310
        , 0 AS QTY311, 0 AS QTY312, 0 AS QTY313, 0 AS QTY314, 0 AS QTY315, 0 AS QTY316, 0 AS QTY317, 0 AS QTY318, 0 AS QTY319, 0 AS QTY320
        , 0 AS QTY321, 0 AS QTY322, 0 AS QTY323, 0 AS QTY324, 0 AS QTY325, 0 AS QTY326, 0 AS QTY327, 0 AS QTY328, 0 AS QTY329, 0 AS QTY330
        , 0 AS QTY331, 0 AS QTY332, 0 AS QTY333, 0 AS QTY334, 0 AS QTY335, 0 AS QTY336, 0 AS QTY337, 0 AS QTY338, 0 AS QTY339, 0 AS QTY340
        , 0 AS QTY341, 0 AS QTY342, 0 AS QTY343, 0 AS QTY344, 0 AS QTY345, 0 AS QTY346, 0 AS QTY347, 0 AS QTY348, 0 AS QTY349, 0 AS QTY350
        , 0 AS QTY351, 0 AS QTY352, 0 AS QTY353, 0 AS QTY354, 0 AS QTY355, 0 AS QTY356, 0 AS QTY357, 0 AS QTY358, 0 AS QTY359, 0 AS QTY360
        , 0 AS QTY361, 0 AS QTY362, 0 AS QTY363, 0 AS QTY364
         , X.ATTRIBUTE1
         , X.ATTRIBUTE2
         , X.ATTRIBUTE3
         , X.ATTRIBUTE4
         , X.ATTRIBUTE5
         , X.ATTRIBUTE6
         , X.ATTRIBUTE7
         , X.ATTRIBUTE8
         , X.ATTRIBUTE9
         , X.ATTRIBUTE10
      FROM GT_SCXL_PSI_GLOBAL_ESS X
         , GT_SCXL_TACT_TIME_TMP Y   /* 원본 CROSS APPLY */
     WHERE 0 = 0
       AND X.DIVISION_ID = Y.DIVISION_ID
       AND X.ITEM_ID     = Y.ITEM_ID
       AND X.FROM_SITE   = Y.PLANT_SITE_ID
       AND X.MEASURE     IN ('CELL_PROD','PACK_PROD')
       AND NOT EXISTS (
                        SELECT 1
                          FROM GT_SCXL_PSI_GLOBAL_ESS Z
                         WHERE 1 = 1
                           AND Z.DIVISION_ID  = X.DIVISION_ID
                           AND Z.CELL_ITEM_ID = X.CELL_ITEM_ID
                           AND Z.ITEM_ID      = X.ITEM_ID
                           AND Z.MEASURE      = X.MEASURE
                           AND Z.FROM_SITE    = Y.PLANT_SITE_ID
                           AND Z.PROD_LINE    = Y.LINE_ID
                           AND Z.MEASURE      IN ('CELL_PROD','PACK_PROD')
                      )
    ;

    /* -------------------------------------------------------------------------------------
       [구간4] 원본 L1108~L1420 : #TACT_TIME_WEEK 생성(UNPIVOT -> PIVOT) 후 PROD_LINE 보정 INSERT
       ★MSSQL UNPIVOT/PIVOT 은 Oracle 도 지원한다. IN 목록의 대괄호 [QTY001] -> QTY001 로 바꾸고,
         Oracle UNPIVOT 의 기본 동작(NULL 제외)이 MSSQL 과 같아 그대로 옮긴다.
       ------------------------------------------------------------------------------------- */
    DELETE
      FROM GT_SCXL_TACT_TIME_WEEK;

    INSERT INTO GT_SCXL_TACT_TIME_WEEK
    SELECT XX.DIVISION_ID, XX.OPERATION_GROUP, XX.SCM_SITE_ID, XX.PROD_LINE, XX.ITEM_ID, XX.OPERATION_ID
         , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
         , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
         , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
         , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
         , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
         , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
         , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
         , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
         , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
         , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
         , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
         , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
         , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
         , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
         , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
         , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
         , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
         , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
         , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
         , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
         , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
         , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
         , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
         , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
         , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
         , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
         , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
         , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
         , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
         , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
         , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
         , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
         , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
         , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
         , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
         , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
         , QTY361, QTY362, QTY363, QTY364
      FROM (
            SELECT X.DIVISION_ID
                 , X.OPERATION_GROUP
                 , Z.SCM_SITE_ID
                 , X.PROD_LINE
                 , X.YYYYMMDD_COLUMN
                 , Z.ITEM_ID
                 , Z.OPERATION_ID
                 , Z.TACT_TIME
              FROM ( SELECT *
                       FROM GT_SCXL_PSI_GLOBAL_ESS
                      WHERE 0 = 0
                        AND MEASURE IN ('PACK_PROD','CELL_PROD')
                   ) SOURCETABLE
             UNPIVOT ( QTY FOR YYYYMMDD_COLUMN IN (
                         QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010,
                         QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020,
                         QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030,
                         QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040,
                         QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050,
                         QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060,
                         QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070,
                         QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080,
                         QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090,
                         QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100,
                         QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110,
                         QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120,
                         QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130,
                         QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140,
                         QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150,
                         QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160,
                         QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170,
                         QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180,
                         QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190,
                         QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200,
                         QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210,
                         QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220,
                         QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230,
                         QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240,
                         QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250,
                         QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260,
                         QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270,
                         QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280,
                         QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290,
                         QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300,
                         QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310,
                         QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320,
                         QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330,
                         QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340,
                         QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350,
                         QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360,
                         QTY361, QTY362, QTY363, QTY364
                     ) ) X
             INNER JOIN ( SELECT A.BASIS_YYYYMMDD AS YYYYMMDD
                               , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS YYYYMMDD_COLUMN
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD >= P_CREATE_FROM_YYYYMMDD
                             AND A.BASIS_YYYYMMDD <= P_CREATE_TO_YYYYMMDD
                        ) Y
                ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
             INNER JOIN SCP_ANL_TACT_TIME Z
                ON  Y.YYYYMMDD    = Z.YYYYMMDD
               AND X.PROD_LINE    = Z.LINE_ID
               AND X.ITEM_ID      = Z.ITEM_ID
               AND Z.DIVISION_ID  = X.DIVISION_ID
               AND Z.YYYYMMDD    >= P_CREATE_FROM_YYYYMMDD
               AND Z.YYYYMMDD    <= P_CREATE_TO_YYYYMMDD
           ) SOURCETABLE
     PIVOT ( SUM(TACT_TIME) FOR YYYYMMDD_COLUMN IN (
                 'QTY001' AS QTY001, 'QTY002' AS QTY002, 'QTY003' AS QTY003, 'QTY004' AS QTY004, 'QTY005' AS QTY005, 'QTY006' AS QTY006, 'QTY007' AS QTY007, 'QTY008' AS QTY008, 'QTY009' AS QTY009, 'QTY010' AS QTY010,
                 'QTY011' AS QTY011, 'QTY012' AS QTY012, 'QTY013' AS QTY013, 'QTY014' AS QTY014, 'QTY015' AS QTY015, 'QTY016' AS QTY016, 'QTY017' AS QTY017, 'QTY018' AS QTY018, 'QTY019' AS QTY019, 'QTY020' AS QTY020,
                 'QTY021' AS QTY021, 'QTY022' AS QTY022, 'QTY023' AS QTY023, 'QTY024' AS QTY024, 'QTY025' AS QTY025, 'QTY026' AS QTY026, 'QTY027' AS QTY027, 'QTY028' AS QTY028, 'QTY029' AS QTY029, 'QTY030' AS QTY030,
                 'QTY031' AS QTY031, 'QTY032' AS QTY032, 'QTY033' AS QTY033, 'QTY034' AS QTY034, 'QTY035' AS QTY035, 'QTY036' AS QTY036, 'QTY037' AS QTY037, 'QTY038' AS QTY038, 'QTY039' AS QTY039, 'QTY040' AS QTY040,
                 'QTY041' AS QTY041, 'QTY042' AS QTY042, 'QTY043' AS QTY043, 'QTY044' AS QTY044, 'QTY045' AS QTY045, 'QTY046' AS QTY046, 'QTY047' AS QTY047, 'QTY048' AS QTY048, 'QTY049' AS QTY049, 'QTY050' AS QTY050,
                 'QTY051' AS QTY051, 'QTY052' AS QTY052, 'QTY053' AS QTY053, 'QTY054' AS QTY054, 'QTY055' AS QTY055, 'QTY056' AS QTY056, 'QTY057' AS QTY057, 'QTY058' AS QTY058, 'QTY059' AS QTY059, 'QTY060' AS QTY060,
                 'QTY061' AS QTY061, 'QTY062' AS QTY062, 'QTY063' AS QTY063, 'QTY064' AS QTY064, 'QTY065' AS QTY065, 'QTY066' AS QTY066, 'QTY067' AS QTY067, 'QTY068' AS QTY068, 'QTY069' AS QTY069, 'QTY070' AS QTY070,
                 'QTY071' AS QTY071, 'QTY072' AS QTY072, 'QTY073' AS QTY073, 'QTY074' AS QTY074, 'QTY075' AS QTY075, 'QTY076' AS QTY076, 'QTY077' AS QTY077, 'QTY078' AS QTY078, 'QTY079' AS QTY079, 'QTY080' AS QTY080,
                 'QTY081' AS QTY081, 'QTY082' AS QTY082, 'QTY083' AS QTY083, 'QTY084' AS QTY084, 'QTY085' AS QTY085, 'QTY086' AS QTY086, 'QTY087' AS QTY087, 'QTY088' AS QTY088, 'QTY089' AS QTY089, 'QTY090' AS QTY090,
                 'QTY091' AS QTY091, 'QTY092' AS QTY092, 'QTY093' AS QTY093, 'QTY094' AS QTY094, 'QTY095' AS QTY095, 'QTY096' AS QTY096, 'QTY097' AS QTY097, 'QTY098' AS QTY098, 'QTY099' AS QTY099, 'QTY100' AS QTY100,
                 'QTY101' AS QTY101, 'QTY102' AS QTY102, 'QTY103' AS QTY103, 'QTY104' AS QTY104, 'QTY105' AS QTY105, 'QTY106' AS QTY106, 'QTY107' AS QTY107, 'QTY108' AS QTY108, 'QTY109' AS QTY109, 'QTY110' AS QTY110,
                 'QTY111' AS QTY111, 'QTY112' AS QTY112, 'QTY113' AS QTY113, 'QTY114' AS QTY114, 'QTY115' AS QTY115, 'QTY116' AS QTY116, 'QTY117' AS QTY117, 'QTY118' AS QTY118, 'QTY119' AS QTY119, 'QTY120' AS QTY120,
                 'QTY121' AS QTY121, 'QTY122' AS QTY122, 'QTY123' AS QTY123, 'QTY124' AS QTY124, 'QTY125' AS QTY125, 'QTY126' AS QTY126, 'QTY127' AS QTY127, 'QTY128' AS QTY128, 'QTY129' AS QTY129, 'QTY130' AS QTY130,
                 'QTY131' AS QTY131, 'QTY132' AS QTY132, 'QTY133' AS QTY133, 'QTY134' AS QTY134, 'QTY135' AS QTY135, 'QTY136' AS QTY136, 'QTY137' AS QTY137, 'QTY138' AS QTY138, 'QTY139' AS QTY139, 'QTY140' AS QTY140,
                 'QTY141' AS QTY141, 'QTY142' AS QTY142, 'QTY143' AS QTY143, 'QTY144' AS QTY144, 'QTY145' AS QTY145, 'QTY146' AS QTY146, 'QTY147' AS QTY147, 'QTY148' AS QTY148, 'QTY149' AS QTY149, 'QTY150' AS QTY150,
                 'QTY151' AS QTY151, 'QTY152' AS QTY152, 'QTY153' AS QTY153, 'QTY154' AS QTY154, 'QTY155' AS QTY155, 'QTY156' AS QTY156, 'QTY157' AS QTY157, 'QTY158' AS QTY158, 'QTY159' AS QTY159, 'QTY160' AS QTY160,
                 'QTY161' AS QTY161, 'QTY162' AS QTY162, 'QTY163' AS QTY163, 'QTY164' AS QTY164, 'QTY165' AS QTY165, 'QTY166' AS QTY166, 'QTY167' AS QTY167, 'QTY168' AS QTY168, 'QTY169' AS QTY169, 'QTY170' AS QTY170,
                 'QTY171' AS QTY171, 'QTY172' AS QTY172, 'QTY173' AS QTY173, 'QTY174' AS QTY174, 'QTY175' AS QTY175, 'QTY176' AS QTY176, 'QTY177' AS QTY177, 'QTY178' AS QTY178, 'QTY179' AS QTY179, 'QTY180' AS QTY180,
                 'QTY181' AS QTY181, 'QTY182' AS QTY182, 'QTY183' AS QTY183, 'QTY184' AS QTY184, 'QTY185' AS QTY185, 'QTY186' AS QTY186, 'QTY187' AS QTY187, 'QTY188' AS QTY188, 'QTY189' AS QTY189, 'QTY190' AS QTY190,
                 'QTY191' AS QTY191, 'QTY192' AS QTY192, 'QTY193' AS QTY193, 'QTY194' AS QTY194, 'QTY195' AS QTY195, 'QTY196' AS QTY196, 'QTY197' AS QTY197, 'QTY198' AS QTY198, 'QTY199' AS QTY199, 'QTY200' AS QTY200,
                 'QTY201' AS QTY201, 'QTY202' AS QTY202, 'QTY203' AS QTY203, 'QTY204' AS QTY204, 'QTY205' AS QTY205, 'QTY206' AS QTY206, 'QTY207' AS QTY207, 'QTY208' AS QTY208, 'QTY209' AS QTY209, 'QTY210' AS QTY210,
                 'QTY211' AS QTY211, 'QTY212' AS QTY212, 'QTY213' AS QTY213, 'QTY214' AS QTY214, 'QTY215' AS QTY215, 'QTY216' AS QTY216, 'QTY217' AS QTY217, 'QTY218' AS QTY218, 'QTY219' AS QTY219, 'QTY220' AS QTY220,
                 'QTY221' AS QTY221, 'QTY222' AS QTY222, 'QTY223' AS QTY223, 'QTY224' AS QTY224, 'QTY225' AS QTY225, 'QTY226' AS QTY226, 'QTY227' AS QTY227, 'QTY228' AS QTY228, 'QTY229' AS QTY229, 'QTY230' AS QTY230,
                 'QTY231' AS QTY231, 'QTY232' AS QTY232, 'QTY233' AS QTY233, 'QTY234' AS QTY234, 'QTY235' AS QTY235, 'QTY236' AS QTY236, 'QTY237' AS QTY237, 'QTY238' AS QTY238, 'QTY239' AS QTY239, 'QTY240' AS QTY240,
                 'QTY241' AS QTY241, 'QTY242' AS QTY242, 'QTY243' AS QTY243, 'QTY244' AS QTY244, 'QTY245' AS QTY245, 'QTY246' AS QTY246, 'QTY247' AS QTY247, 'QTY248' AS QTY248, 'QTY249' AS QTY249, 'QTY250' AS QTY250,
                 'QTY251' AS QTY251, 'QTY252' AS QTY252, 'QTY253' AS QTY253, 'QTY254' AS QTY254, 'QTY255' AS QTY255, 'QTY256' AS QTY256, 'QTY257' AS QTY257, 'QTY258' AS QTY258, 'QTY259' AS QTY259, 'QTY260' AS QTY260,
                 'QTY261' AS QTY261, 'QTY262' AS QTY262, 'QTY263' AS QTY263, 'QTY264' AS QTY264, 'QTY265' AS QTY265, 'QTY266' AS QTY266, 'QTY267' AS QTY267, 'QTY268' AS QTY268, 'QTY269' AS QTY269, 'QTY270' AS QTY270,
                 'QTY271' AS QTY271, 'QTY272' AS QTY272, 'QTY273' AS QTY273, 'QTY274' AS QTY274, 'QTY275' AS QTY275, 'QTY276' AS QTY276, 'QTY277' AS QTY277, 'QTY278' AS QTY278, 'QTY279' AS QTY279, 'QTY280' AS QTY280,
                 'QTY281' AS QTY281, 'QTY282' AS QTY282, 'QTY283' AS QTY283, 'QTY284' AS QTY284, 'QTY285' AS QTY285, 'QTY286' AS QTY286, 'QTY287' AS QTY287, 'QTY288' AS QTY288, 'QTY289' AS QTY289, 'QTY290' AS QTY290,
                 'QTY291' AS QTY291, 'QTY292' AS QTY292, 'QTY293' AS QTY293, 'QTY294' AS QTY294, 'QTY295' AS QTY295, 'QTY296' AS QTY296, 'QTY297' AS QTY297, 'QTY298' AS QTY298, 'QTY299' AS QTY299, 'QTY300' AS QTY300,
                 'QTY301' AS QTY301, 'QTY302' AS QTY302, 'QTY303' AS QTY303, 'QTY304' AS QTY304, 'QTY305' AS QTY305, 'QTY306' AS QTY306, 'QTY307' AS QTY307, 'QTY308' AS QTY308, 'QTY309' AS QTY309, 'QTY310' AS QTY310,
                 'QTY311' AS QTY311, 'QTY312' AS QTY312, 'QTY313' AS QTY313, 'QTY314' AS QTY314, 'QTY315' AS QTY315, 'QTY316' AS QTY316, 'QTY317' AS QTY317, 'QTY318' AS QTY318, 'QTY319' AS QTY319, 'QTY320' AS QTY320,
                 'QTY321' AS QTY321, 'QTY322' AS QTY322, 'QTY323' AS QTY323, 'QTY324' AS QTY324, 'QTY325' AS QTY325, 'QTY326' AS QTY326, 'QTY327' AS QTY327, 'QTY328' AS QTY328, 'QTY329' AS QTY329, 'QTY330' AS QTY330,
                 'QTY331' AS QTY331, 'QTY332' AS QTY332, 'QTY333' AS QTY333, 'QTY334' AS QTY334, 'QTY335' AS QTY335, 'QTY336' AS QTY336, 'QTY337' AS QTY337, 'QTY338' AS QTY338, 'QTY339' AS QTY339, 'QTY340' AS QTY340,
                 'QTY341' AS QTY341, 'QTY342' AS QTY342, 'QTY343' AS QTY343, 'QTY344' AS QTY344, 'QTY345' AS QTY345, 'QTY346' AS QTY346, 'QTY347' AS QTY347, 'QTY348' AS QTY348, 'QTY349' AS QTY349, 'QTY350' AS QTY350,
                 'QTY351' AS QTY351, 'QTY352' AS QTY352, 'QTY353' AS QTY353, 'QTY354' AS QTY354, 'QTY355' AS QTY355, 'QTY356' AS QTY356, 'QTY357' AS QTY357, 'QTY358' AS QTY358, 'QTY359' AS QTY359, 'QTY360' AS QTY360,
                 'QTY361' AS QTY361, 'QTY362' AS QTY362, 'QTY363' AS QTY363, 'QTY364' AS QTY364
           ) ) XX
    ;

    /* 원본 L1349~L1454 : TACT_TIME 행에 라인(PROD_LINE)별 주간 TACT 를 채워 보충 INSERT.
       원본 CROSS APPLY #TACT_TIME_WEEK -> 콤마 조인(조인 조건은 WHERE 절). */
    INSERT INTO GT_SCXL_PSI_GLOBAL_ESS
    SELECT DISTINCT X.DIVISION_ID
         , X.PLAN_START_YYYYMMDD
         , X.PLAN_TYPE
         , X.SEQ
         , X.OPERATION_GROUP
         , X.OPERATION_GROUP_NAME
         , X.CELL_ITEM_ID
         , X.ITEM_ID
         , X.NICK_NAME
         , X.CELL_QTY_PACK
         , X.TO_SITE
         , X.TO_SITE_DESCRIPTION
         , X.PROJECT_CODE
         , X.FROM_BOH_QTY
         , X.TO_BOH_QTY
         , X.INCOTERMS
         , X.FROM_SITE
         , X.FROM_SITE_DESCRIPTION
         , X.TRANSPORT_MODE
         , Y.PROD_LINE AS PROD_LINE
         , X.LT_DAY
         , X.BOD_ID
         , X.MEASURE
         , X.MEASURE_LABEL
         , X.XLS_KEY1
         , X.XLS_KEY2
         , X.XLS_KEY3
         , X.XLS_KEY4
         , X.XLS_KEY5
         , X.XLS_ATTRIBUTE1
         , X.XLS_ATTRIBUTE2
         , X.XLS_ATTRIBUTE3
         , X.XLS_ATTRIBUTE4
         , X.XLS_ATTRIBUTE5
         , X.SORT_ORDER_NO
         , NVL(Y.QTY001, 0), NVL(Y.QTY002, 0), NVL(Y.QTY003, 0), NVL(Y.QTY004, 0), NVL(Y.QTY005, 0), NVL(Y.QTY006, 0), NVL(Y.QTY007, 0), NVL(Y.QTY008, 0), NVL(Y.QTY009, 0), NVL(Y.QTY010, 0)
         , NVL(Y.QTY011, 0), NVL(Y.QTY012, 0), NVL(Y.QTY013, 0), NVL(Y.QTY014, 0), NVL(Y.QTY015, 0), NVL(Y.QTY016, 0), NVL(Y.QTY017, 0), NVL(Y.QTY018, 0), NVL(Y.QTY019, 0), NVL(Y.QTY020, 0)
         , NVL(Y.QTY021, 0), NVL(Y.QTY022, 0), NVL(Y.QTY023, 0), NVL(Y.QTY024, 0), NVL(Y.QTY025, 0), NVL(Y.QTY026, 0), NVL(Y.QTY027, 0), NVL(Y.QTY028, 0), NVL(Y.QTY029, 0), NVL(Y.QTY030, 0)
         , NVL(Y.QTY031, 0), NVL(Y.QTY032, 0), NVL(Y.QTY033, 0), NVL(Y.QTY034, 0), NVL(Y.QTY035, 0), NVL(Y.QTY036, 0), NVL(Y.QTY037, 0), NVL(Y.QTY038, 0), NVL(Y.QTY039, 0), NVL(Y.QTY040, 0)
         , NVL(Y.QTY041, 0), NVL(Y.QTY042, 0), NVL(Y.QTY043, 0), NVL(Y.QTY044, 0), NVL(Y.QTY045, 0), NVL(Y.QTY046, 0), NVL(Y.QTY047, 0), NVL(Y.QTY048, 0), NVL(Y.QTY049, 0), NVL(Y.QTY050, 0)
         , NVL(Y.QTY051, 0), NVL(Y.QTY052, 0), NVL(Y.QTY053, 0), NVL(Y.QTY054, 0), NVL(Y.QTY055, 0), NVL(Y.QTY056, 0), NVL(Y.QTY057, 0), NVL(Y.QTY058, 0), NVL(Y.QTY059, 0), NVL(Y.QTY060, 0)
         , NVL(Y.QTY061, 0), NVL(Y.QTY062, 0), NVL(Y.QTY063, 0), NVL(Y.QTY064, 0), NVL(Y.QTY065, 0), NVL(Y.QTY066, 0), NVL(Y.QTY067, 0), NVL(Y.QTY068, 0), NVL(Y.QTY069, 0), NVL(Y.QTY070, 0)
         , NVL(Y.QTY071, 0), NVL(Y.QTY072, 0), NVL(Y.QTY073, 0), NVL(Y.QTY074, 0), NVL(Y.QTY075, 0), NVL(Y.QTY076, 0), NVL(Y.QTY077, 0), NVL(Y.QTY078, 0), NVL(Y.QTY079, 0), NVL(Y.QTY080, 0)
         , NVL(Y.QTY081, 0), NVL(Y.QTY082, 0), NVL(Y.QTY083, 0), NVL(Y.QTY084, 0), NVL(Y.QTY085, 0), NVL(Y.QTY086, 0), NVL(Y.QTY087, 0), NVL(Y.QTY088, 0), NVL(Y.QTY089, 0), NVL(Y.QTY090, 0)
         , NVL(Y.QTY091, 0), NVL(Y.QTY092, 0), NVL(Y.QTY093, 0), NVL(Y.QTY094, 0), NVL(Y.QTY095, 0), NVL(Y.QTY096, 0), NVL(Y.QTY097, 0), NVL(Y.QTY098, 0), NVL(Y.QTY099, 0), NVL(Y.QTY100, 0)
         , NVL(Y.QTY101, 0), NVL(Y.QTY102, 0), NVL(Y.QTY103, 0), NVL(Y.QTY104, 0), NVL(Y.QTY105, 0), NVL(Y.QTY106, 0), NVL(Y.QTY107, 0), NVL(Y.QTY108, 0), NVL(Y.QTY109, 0), NVL(Y.QTY110, 0)
         , NVL(Y.QTY111, 0), NVL(Y.QTY112, 0), NVL(Y.QTY113, 0), NVL(Y.QTY114, 0), NVL(Y.QTY115, 0), NVL(Y.QTY116, 0), NVL(Y.QTY117, 0), NVL(Y.QTY118, 0), NVL(Y.QTY119, 0), NVL(Y.QTY120, 0)
         , NVL(Y.QTY121, 0), NVL(Y.QTY122, 0), NVL(Y.QTY123, 0), NVL(Y.QTY124, 0), NVL(Y.QTY125, 0), NVL(Y.QTY126, 0), NVL(Y.QTY127, 0), NVL(Y.QTY128, 0), NVL(Y.QTY129, 0), NVL(Y.QTY130, 0)
         , NVL(Y.QTY131, 0), NVL(Y.QTY132, 0), NVL(Y.QTY133, 0), NVL(Y.QTY134, 0), NVL(Y.QTY135, 0), NVL(Y.QTY136, 0), NVL(Y.QTY137, 0), NVL(Y.QTY138, 0), NVL(Y.QTY139, 0), NVL(Y.QTY140, 0)
         , NVL(Y.QTY141, 0), NVL(Y.QTY142, 0), NVL(Y.QTY143, 0), NVL(Y.QTY144, 0), NVL(Y.QTY145, 0), NVL(Y.QTY146, 0), NVL(Y.QTY147, 0), NVL(Y.QTY148, 0), NVL(Y.QTY149, 0), NVL(Y.QTY150, 0)
         , NVL(Y.QTY151, 0), NVL(Y.QTY152, 0), NVL(Y.QTY153, 0), NVL(Y.QTY154, 0), NVL(Y.QTY155, 0), NVL(Y.QTY156, 0), NVL(Y.QTY157, 0), NVL(Y.QTY158, 0), NVL(Y.QTY159, 0), NVL(Y.QTY160, 0)
         , NVL(Y.QTY161, 0), NVL(Y.QTY162, 0), NVL(Y.QTY163, 0), NVL(Y.QTY164, 0), NVL(Y.QTY165, 0), NVL(Y.QTY166, 0), NVL(Y.QTY167, 0), NVL(Y.QTY168, 0), NVL(Y.QTY169, 0), NVL(Y.QTY170, 0)
         , NVL(Y.QTY171, 0), NVL(Y.QTY172, 0), NVL(Y.QTY173, 0), NVL(Y.QTY174, 0), NVL(Y.QTY175, 0), NVL(Y.QTY176, 0), NVL(Y.QTY177, 0), NVL(Y.QTY178, 0), NVL(Y.QTY179, 0), NVL(Y.QTY180, 0)
         , NVL(Y.QTY181, 0), NVL(Y.QTY182, 0), NVL(Y.QTY183, 0), NVL(Y.QTY184, 0), NVL(Y.QTY185, 0), NVL(Y.QTY186, 0), NVL(Y.QTY187, 0), NVL(Y.QTY188, 0), NVL(Y.QTY189, 0), NVL(Y.QTY190, 0)
         , NVL(Y.QTY191, 0), NVL(Y.QTY192, 0), NVL(Y.QTY193, 0), NVL(Y.QTY194, 0), NVL(Y.QTY195, 0), NVL(Y.QTY196, 0), NVL(Y.QTY197, 0), NVL(Y.QTY198, 0), NVL(Y.QTY199, 0), NVL(Y.QTY200, 0)
         , NVL(Y.QTY201, 0), NVL(Y.QTY202, 0), NVL(Y.QTY203, 0), NVL(Y.QTY204, 0), NVL(Y.QTY205, 0), NVL(Y.QTY206, 0), NVL(Y.QTY207, 0), NVL(Y.QTY208, 0), NVL(Y.QTY209, 0), NVL(Y.QTY210, 0)
         , NVL(Y.QTY211, 0), NVL(Y.QTY212, 0), NVL(Y.QTY213, 0), NVL(Y.QTY214, 0), NVL(Y.QTY215, 0), NVL(Y.QTY216, 0), NVL(Y.QTY217, 0), NVL(Y.QTY218, 0), NVL(Y.QTY219, 0), NVL(Y.QTY220, 0)
         , NVL(Y.QTY221, 0), NVL(Y.QTY222, 0), NVL(Y.QTY223, 0), NVL(Y.QTY224, 0), NVL(Y.QTY225, 0), NVL(Y.QTY226, 0), NVL(Y.QTY227, 0), NVL(Y.QTY228, 0), NVL(Y.QTY229, 0), NVL(Y.QTY230, 0)
         , NVL(Y.QTY231, 0), NVL(Y.QTY232, 0), NVL(Y.QTY233, 0), NVL(Y.QTY234, 0), NVL(Y.QTY235, 0), NVL(Y.QTY236, 0), NVL(Y.QTY237, 0), NVL(Y.QTY238, 0), NVL(Y.QTY239, 0), NVL(Y.QTY240, 0)
         , NVL(Y.QTY241, 0), NVL(Y.QTY242, 0), NVL(Y.QTY243, 0), NVL(Y.QTY244, 0), NVL(Y.QTY245, 0), NVL(Y.QTY246, 0), NVL(Y.QTY247, 0), NVL(Y.QTY248, 0), NVL(Y.QTY249, 0), NVL(Y.QTY250, 0)
         , NVL(Y.QTY251, 0), NVL(Y.QTY252, 0), NVL(Y.QTY253, 0), NVL(Y.QTY254, 0), NVL(Y.QTY255, 0), NVL(Y.QTY256, 0), NVL(Y.QTY257, 0), NVL(Y.QTY258, 0), NVL(Y.QTY259, 0), NVL(Y.QTY260, 0)
         , NVL(Y.QTY261, 0), NVL(Y.QTY262, 0), NVL(Y.QTY263, 0), NVL(Y.QTY264, 0), NVL(Y.QTY265, 0), NVL(Y.QTY266, 0), NVL(Y.QTY267, 0), NVL(Y.QTY268, 0), NVL(Y.QTY269, 0), NVL(Y.QTY270, 0)
         , NVL(Y.QTY271, 0), NVL(Y.QTY272, 0), NVL(Y.QTY273, 0), NVL(Y.QTY274, 0), NVL(Y.QTY275, 0), NVL(Y.QTY276, 0), NVL(Y.QTY277, 0), NVL(Y.QTY278, 0), NVL(Y.QTY279, 0), NVL(Y.QTY280, 0)
         , NVL(Y.QTY281, 0), NVL(Y.QTY282, 0), NVL(Y.QTY283, 0), NVL(Y.QTY284, 0), NVL(Y.QTY285, 0), NVL(Y.QTY286, 0), NVL(Y.QTY287, 0), NVL(Y.QTY288, 0), NVL(Y.QTY289, 0), NVL(Y.QTY290, 0)
         , NVL(Y.QTY291, 0), NVL(Y.QTY292, 0), NVL(Y.QTY293, 0), NVL(Y.QTY294, 0), NVL(Y.QTY295, 0), NVL(Y.QTY296, 0), NVL(Y.QTY297, 0), NVL(Y.QTY298, 0), NVL(Y.QTY299, 0), NVL(Y.QTY300, 0)
         , NVL(Y.QTY301, 0), NVL(Y.QTY302, 0), NVL(Y.QTY303, 0), NVL(Y.QTY304, 0), NVL(Y.QTY305, 0), NVL(Y.QTY306, 0), NVL(Y.QTY307, 0), NVL(Y.QTY308, 0), NVL(Y.QTY309, 0), NVL(Y.QTY310, 0)
         , NVL(Y.QTY311, 0), NVL(Y.QTY312, 0), NVL(Y.QTY313, 0), NVL(Y.QTY314, 0), NVL(Y.QTY315, 0), NVL(Y.QTY316, 0), NVL(Y.QTY317, 0), NVL(Y.QTY318, 0), NVL(Y.QTY319, 0), NVL(Y.QTY320, 0)
         , NVL(Y.QTY321, 0), NVL(Y.QTY322, 0), NVL(Y.QTY323, 0), NVL(Y.QTY324, 0), NVL(Y.QTY325, 0), NVL(Y.QTY326, 0), NVL(Y.QTY327, 0), NVL(Y.QTY328, 0), NVL(Y.QTY329, 0), NVL(Y.QTY330, 0)
         , NVL(Y.QTY331, 0), NVL(Y.QTY332, 0), NVL(Y.QTY333, 0), NVL(Y.QTY334, 0), NVL(Y.QTY335, 0), NVL(Y.QTY336, 0), NVL(Y.QTY337, 0), NVL(Y.QTY338, 0), NVL(Y.QTY339, 0), NVL(Y.QTY340, 0)
         , NVL(Y.QTY341, 0), NVL(Y.QTY342, 0), NVL(Y.QTY343, 0), NVL(Y.QTY344, 0), NVL(Y.QTY345, 0), NVL(Y.QTY346, 0), NVL(Y.QTY347, 0), NVL(Y.QTY348, 0), NVL(Y.QTY349, 0), NVL(Y.QTY350, 0)
         , NVL(Y.QTY351, 0), NVL(Y.QTY352, 0), NVL(Y.QTY353, 0), NVL(Y.QTY354, 0), NVL(Y.QTY355, 0), NVL(Y.QTY356, 0), NVL(Y.QTY357, 0), NVL(Y.QTY358, 0), NVL(Y.QTY359, 0), NVL(Y.QTY360, 0)
         , NVL(Y.QTY361, 0), NVL(Y.QTY362, 0), NVL(Y.QTY363, 0), NVL(Y.QTY364, 0)
         , X.ATTRIBUTE1
         , X.ATTRIBUTE2
         , X.ATTRIBUTE3
         , X.ATTRIBUTE4
         , X.ATTRIBUTE5
         , X.ATTRIBUTE6
         , X.ATTRIBUTE7
         , X.ATTRIBUTE8
         , X.ATTRIBUTE9
         , X.ATTRIBUTE10
      FROM GT_SCXL_PSI_GLOBAL_ESS X
         , GT_SCXL_TACT_TIME_WEEK Y   /* 원본 CROSS APPLY */
     WHERE 0 = 0
       AND X.DIVISION_ID = Y.DIVISION_ID
       AND X.ITEM_ID     = Y.ITEM_ID
       AND X.FROM_SITE   = Y.SCM_SITE_ID
       AND X.MEASURE     IN ('PACK_TACT_TIME','CELL_TACT_TIME')
       AND NOT EXISTS (
                        SELECT 1
                          FROM GT_SCXL_PSI_GLOBAL_ESS Z
                         WHERE 1 = 1
                           AND Z.DIVISION_ID  = X.DIVISION_ID
                           AND Z.CELL_ITEM_ID = X.CELL_ITEM_ID
                           AND Z.ITEM_ID      = X.ITEM_ID
                           AND Z.MEASURE      = X.MEASURE
                           AND Z.FROM_SITE    = Y.SCM_SITE_ID
                           AND Z.PROD_LINE    = Y.PROD_LINE
                           AND Z.MEASURE      IN ('PACK_TACT_TIME','CELL_TACT_TIME')
                      )
    ;

    /* -------------------------------------------------------------------------------------
       [구간5] 원본 L1472~L1660 : #PROD_TACT_TIME_PIVOT 생성(PIVOT) 후 TACT_TIME 행 QTY 일괄 갱신
       ★원본 L1599 `UPDATE X SET .. FROM X INNER JOIN Y ON ..` 은 MSSQL 전용 구문이다.
         Oracle 에는 UPDATE..FROM 이 없으므로 MERGE 로 옮긴다(SOP §3.3). 조인키는 ON 절에,
         원본 WHERE 의 대상 행 필터도 ON 절에 넣어 매칭 자체를 제한한다(INNER JOIN + WHERE 와 등가).
       ------------------------------------------------------------------------------------- */
    DELETE
      FROM GT_SCXL_PROD_TACT_PIVOT;

    INSERT INTO GT_SCXL_PROD_TACT_PIVOT
    SELECT DIVISION_ID
         , SCM_SITE_ID
         , OPERATION_ID
         , ITEM_ID
         , LINE_ID
         , MAX(QTY001) AS QTY001, MAX(QTY002) AS QTY002, MAX(QTY003) AS QTY003, MAX(QTY004) AS QTY004, MAX(QTY005) AS QTY005, MAX(QTY006) AS QTY006, MAX(QTY007) AS QTY007, MAX(QTY008) AS QTY008
         , MAX(QTY009) AS QTY009, MAX(QTY010) AS QTY010, MAX(QTY011) AS QTY011, MAX(QTY012) AS QTY012, MAX(QTY013) AS QTY013, MAX(QTY014) AS QTY014, MAX(QTY015) AS QTY015, MAX(QTY016) AS QTY016
         , MAX(QTY017) AS QTY017, MAX(QTY018) AS QTY018, MAX(QTY019) AS QTY019, MAX(QTY020) AS QTY020, MAX(QTY021) AS QTY021, MAX(QTY022) AS QTY022, MAX(QTY023) AS QTY023, MAX(QTY024) AS QTY024
         , MAX(QTY025) AS QTY025, MAX(QTY026) AS QTY026, MAX(QTY027) AS QTY027, MAX(QTY028) AS QTY028, MAX(QTY029) AS QTY029, MAX(QTY030) AS QTY030, MAX(QTY031) AS QTY031, MAX(QTY032) AS QTY032
         , MAX(QTY033) AS QTY033, MAX(QTY034) AS QTY034, MAX(QTY035) AS QTY035, MAX(QTY036) AS QTY036, MAX(QTY037) AS QTY037, MAX(QTY038) AS QTY038, MAX(QTY039) AS QTY039, MAX(QTY040) AS QTY040
         , MAX(QTY041) AS QTY041, MAX(QTY042) AS QTY042, MAX(QTY043) AS QTY043, MAX(QTY044) AS QTY044, MAX(QTY045) AS QTY045, MAX(QTY046) AS QTY046, MAX(QTY047) AS QTY047, MAX(QTY048) AS QTY048
         , MAX(QTY049) AS QTY049, MAX(QTY050) AS QTY050, MAX(QTY051) AS QTY051, MAX(QTY052) AS QTY052, MAX(QTY053) AS QTY053, MAX(QTY054) AS QTY054, MAX(QTY055) AS QTY055, MAX(QTY056) AS QTY056
         , MAX(QTY057) AS QTY057, MAX(QTY058) AS QTY058, MAX(QTY059) AS QTY059, MAX(QTY060) AS QTY060, MAX(QTY061) AS QTY061, MAX(QTY062) AS QTY062, MAX(QTY063) AS QTY063, MAX(QTY064) AS QTY064
         , MAX(QTY065) AS QTY065, MAX(QTY066) AS QTY066, MAX(QTY067) AS QTY067, MAX(QTY068) AS QTY068, MAX(QTY069) AS QTY069, MAX(QTY070) AS QTY070, MAX(QTY071) AS QTY071, MAX(QTY072) AS QTY072
         , MAX(QTY073) AS QTY073, MAX(QTY074) AS QTY074, MAX(QTY075) AS QTY075, MAX(QTY076) AS QTY076, MAX(QTY077) AS QTY077, MAX(QTY078) AS QTY078, MAX(QTY079) AS QTY079, MAX(QTY080) AS QTY080
         , MAX(QTY081) AS QTY081, MAX(QTY082) AS QTY082, MAX(QTY083) AS QTY083, MAX(QTY084) AS QTY084, MAX(QTY085) AS QTY085, MAX(QTY086) AS QTY086, MAX(QTY087) AS QTY087, MAX(QTY088) AS QTY088
         , MAX(QTY089) AS QTY089, MAX(QTY090) AS QTY090, MAX(QTY091) AS QTY091, MAX(QTY092) AS QTY092, MAX(QTY093) AS QTY093, MAX(QTY094) AS QTY094, MAX(QTY095) AS QTY095, MAX(QTY096) AS QTY096
         , MAX(QTY097) AS QTY097, MAX(QTY098) AS QTY098, MAX(QTY099) AS QTY099, MAX(QTY100) AS QTY100, MAX(QTY101) AS QTY101, MAX(QTY102) AS QTY102, MAX(QTY103) AS QTY103, MAX(QTY104) AS QTY104
         , MAX(QTY105) AS QTY105, MAX(QTY106) AS QTY106, MAX(QTY107) AS QTY107, MAX(QTY108) AS QTY108, MAX(QTY109) AS QTY109, MAX(QTY110) AS QTY110, MAX(QTY111) AS QTY111, MAX(QTY112) AS QTY112
         , MAX(QTY113) AS QTY113, MAX(QTY114) AS QTY114, MAX(QTY115) AS QTY115, MAX(QTY116) AS QTY116, MAX(QTY117) AS QTY117, MAX(QTY118) AS QTY118, MAX(QTY119) AS QTY119, MAX(QTY120) AS QTY120
         , MAX(QTY121) AS QTY121, MAX(QTY122) AS QTY122, MAX(QTY123) AS QTY123, MAX(QTY124) AS QTY124, MAX(QTY125) AS QTY125, MAX(QTY126) AS QTY126, MAX(QTY127) AS QTY127, MAX(QTY128) AS QTY128
         , MAX(QTY129) AS QTY129, MAX(QTY130) AS QTY130, MAX(QTY131) AS QTY131, MAX(QTY132) AS QTY132, MAX(QTY133) AS QTY133, MAX(QTY134) AS QTY134, MAX(QTY135) AS QTY135, MAX(QTY136) AS QTY136
         , MAX(QTY137) AS QTY137, MAX(QTY138) AS QTY138, MAX(QTY139) AS QTY139, MAX(QTY140) AS QTY140, MAX(QTY141) AS QTY141, MAX(QTY142) AS QTY142, MAX(QTY143) AS QTY143, MAX(QTY144) AS QTY144
         , MAX(QTY145) AS QTY145, MAX(QTY146) AS QTY146, MAX(QTY147) AS QTY147, MAX(QTY148) AS QTY148, MAX(QTY149) AS QTY149, MAX(QTY150) AS QTY150, MAX(QTY151) AS QTY151, MAX(QTY152) AS QTY152
         , MAX(QTY153) AS QTY153, MAX(QTY154) AS QTY154, MAX(QTY155) AS QTY155, MAX(QTY156) AS QTY156, MAX(QTY157) AS QTY157, MAX(QTY158) AS QTY158, MAX(QTY159) AS QTY159, MAX(QTY160) AS QTY160
         , MAX(QTY161) AS QTY161, MAX(QTY162) AS QTY162, MAX(QTY163) AS QTY163, MAX(QTY164) AS QTY164, MAX(QTY165) AS QTY165, MAX(QTY166) AS QTY166, MAX(QTY167) AS QTY167, MAX(QTY168) AS QTY168
         , MAX(QTY169) AS QTY169, MAX(QTY170) AS QTY170, MAX(QTY171) AS QTY171, MAX(QTY172) AS QTY172, MAX(QTY173) AS QTY173, MAX(QTY174) AS QTY174, MAX(QTY175) AS QTY175, MAX(QTY176) AS QTY176
         , MAX(QTY177) AS QTY177, MAX(QTY178) AS QTY178, MAX(QTY179) AS QTY179, MAX(QTY180) AS QTY180, MAX(QTY181) AS QTY181, MAX(QTY182) AS QTY182, MAX(QTY183) AS QTY183, MAX(QTY184) AS QTY184
         , MAX(QTY185) AS QTY185, MAX(QTY186) AS QTY186, MAX(QTY187) AS QTY187, MAX(QTY188) AS QTY188, MAX(QTY189) AS QTY189, MAX(QTY190) AS QTY190, MAX(QTY191) AS QTY191, MAX(QTY192) AS QTY192
         , MAX(QTY193) AS QTY193, MAX(QTY194) AS QTY194, MAX(QTY195) AS QTY195, MAX(QTY196) AS QTY196, MAX(QTY197) AS QTY197, MAX(QTY198) AS QTY198, MAX(QTY199) AS QTY199, MAX(QTY200) AS QTY200
         , MAX(QTY201) AS QTY201, MAX(QTY202) AS QTY202, MAX(QTY203) AS QTY203, MAX(QTY204) AS QTY204, MAX(QTY205) AS QTY205, MAX(QTY206) AS QTY206, MAX(QTY207) AS QTY207, MAX(QTY208) AS QTY208
         , MAX(QTY209) AS QTY209, MAX(QTY210) AS QTY210, MAX(QTY211) AS QTY211, MAX(QTY212) AS QTY212, MAX(QTY213) AS QTY213, MAX(QTY214) AS QTY214, MAX(QTY215) AS QTY215, MAX(QTY216) AS QTY216
         , MAX(QTY217) AS QTY217, MAX(QTY218) AS QTY218, MAX(QTY219) AS QTY219, MAX(QTY220) AS QTY220, MAX(QTY221) AS QTY221, MAX(QTY222) AS QTY222, MAX(QTY223) AS QTY223, MAX(QTY224) AS QTY224
         , MAX(QTY225) AS QTY225, MAX(QTY226) AS QTY226, MAX(QTY227) AS QTY227, MAX(QTY228) AS QTY228, MAX(QTY229) AS QTY229, MAX(QTY230) AS QTY230, MAX(QTY231) AS QTY231, MAX(QTY232) AS QTY232
         , MAX(QTY233) AS QTY233, MAX(QTY234) AS QTY234, MAX(QTY235) AS QTY235, MAX(QTY236) AS QTY236, MAX(QTY237) AS QTY237, MAX(QTY238) AS QTY238, MAX(QTY239) AS QTY239, MAX(QTY240) AS QTY240
         , MAX(QTY241) AS QTY241, MAX(QTY242) AS QTY242, MAX(QTY243) AS QTY243, MAX(QTY244) AS QTY244, MAX(QTY245) AS QTY245, MAX(QTY246) AS QTY246, MAX(QTY247) AS QTY247, MAX(QTY248) AS QTY248
         , MAX(QTY249) AS QTY249, MAX(QTY250) AS QTY250, MAX(QTY251) AS QTY251, MAX(QTY252) AS QTY252, MAX(QTY253) AS QTY253, MAX(QTY254) AS QTY254, MAX(QTY255) AS QTY255, MAX(QTY256) AS QTY256
         , MAX(QTY257) AS QTY257, MAX(QTY258) AS QTY258, MAX(QTY259) AS QTY259, MAX(QTY260) AS QTY260, MAX(QTY261) AS QTY261, MAX(QTY262) AS QTY262, MAX(QTY263) AS QTY263, MAX(QTY264) AS QTY264
         , MAX(QTY265) AS QTY265, MAX(QTY266) AS QTY266, MAX(QTY267) AS QTY267, MAX(QTY268) AS QTY268, MAX(QTY269) AS QTY269, MAX(QTY270) AS QTY270, MAX(QTY271) AS QTY271, MAX(QTY272) AS QTY272
         , MAX(QTY273) AS QTY273, MAX(QTY274) AS QTY274, MAX(QTY275) AS QTY275, MAX(QTY276) AS QTY276, MAX(QTY277) AS QTY277, MAX(QTY278) AS QTY278, MAX(QTY279) AS QTY279, MAX(QTY280) AS QTY280
         , MAX(QTY281) AS QTY281, MAX(QTY282) AS QTY282, MAX(QTY283) AS QTY283, MAX(QTY284) AS QTY284, MAX(QTY285) AS QTY285, MAX(QTY286) AS QTY286, MAX(QTY287) AS QTY287, MAX(QTY288) AS QTY288
         , MAX(QTY289) AS QTY289, MAX(QTY290) AS QTY290, MAX(QTY291) AS QTY291, MAX(QTY292) AS QTY292, MAX(QTY293) AS QTY293, MAX(QTY294) AS QTY294, MAX(QTY295) AS QTY295, MAX(QTY296) AS QTY296
         , MAX(QTY297) AS QTY297, MAX(QTY298) AS QTY298, MAX(QTY299) AS QTY299, MAX(QTY300) AS QTY300, MAX(QTY301) AS QTY301, MAX(QTY302) AS QTY302, MAX(QTY303) AS QTY303, MAX(QTY304) AS QTY304
         , MAX(QTY305) AS QTY305, MAX(QTY306) AS QTY306, MAX(QTY307) AS QTY307, MAX(QTY308) AS QTY308, MAX(QTY309) AS QTY309, MAX(QTY310) AS QTY310, MAX(QTY311) AS QTY311, MAX(QTY312) AS QTY312
         , MAX(QTY313) AS QTY313, MAX(QTY314) AS QTY314, MAX(QTY315) AS QTY315, MAX(QTY316) AS QTY316, MAX(QTY317) AS QTY317, MAX(QTY318) AS QTY318, MAX(QTY319) AS QTY319, MAX(QTY320) AS QTY320
         , MAX(QTY321) AS QTY321, MAX(QTY322) AS QTY322, MAX(QTY323) AS QTY323, MAX(QTY324) AS QTY324, MAX(QTY325) AS QTY325, MAX(QTY326) AS QTY326, MAX(QTY327) AS QTY327, MAX(QTY328) AS QTY328
         , MAX(QTY329) AS QTY329, MAX(QTY330) AS QTY330, MAX(QTY331) AS QTY331, MAX(QTY332) AS QTY332, MAX(QTY333) AS QTY333, MAX(QTY334) AS QTY334, MAX(QTY335) AS QTY335, MAX(QTY336) AS QTY336
         , MAX(QTY337) AS QTY337, MAX(QTY338) AS QTY338, MAX(QTY339) AS QTY339, MAX(QTY340) AS QTY340, MAX(QTY341) AS QTY341, MAX(QTY342) AS QTY342, MAX(QTY343) AS QTY343, MAX(QTY344) AS QTY344
         , MAX(QTY345) AS QTY345, MAX(QTY346) AS QTY346, MAX(QTY347) AS QTY347, MAX(QTY348) AS QTY348, MAX(QTY349) AS QTY349, MAX(QTY350) AS QTY350, MAX(QTY351) AS QTY351, MAX(QTY352) AS QTY352
         , MAX(QTY353) AS QTY353, MAX(QTY354) AS QTY354, MAX(QTY355) AS QTY355, MAX(QTY356) AS QTY356, MAX(QTY357) AS QTY357, MAX(QTY358) AS QTY358, MAX(QTY359) AS QTY359, MAX(QTY360) AS QTY360
         , MAX(QTY361) AS QTY361, MAX(QTY362) AS QTY362, MAX(QTY363) AS QTY363, MAX(QTY364) AS QTY364
      FROM (
            SELECT D.DIVISION_ID
                 , D.OPERATION_ID
                 , D.SCM_SITE_ID
                 , D.ITEM_ID
                 , D.LINE_ID
                 , D.TACT_TIME AS VAL
                 , D.YYYYMMDD
                 , Y.YYYYMMDD_COLUMN
              FROM SCP_ANL_TACT_TIME D
                 , ( SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
                          , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD)), 3, '0') AS YYYYMMDD_COLUMN
                       FROM SCM_SYS_CALENDAR_M C
                      WHERE 1 = 1
                        AND C.BASIS_YYYYMMDD BETWEEN P_CREATE_FROM_YYYYMMDD AND P_CREATE_TO_YYYYMMDD ) Y
             WHERE 0 = 0
               AND D.DIVISION_ID = P_DIVISION_ID
               AND D.YYYYMMDD BETWEEN P_CREATE_FROM_YYYYMMDD AND P_CREATE_TO_YYYYMMDD
               AND D.YYYYMMDD = Y.YYYYMMDD
           ) SOURCETABLE
     PIVOT ( SUM(VAL) FOR YYYYMMDD_COLUMN IN (
                 'QTY001' AS QTY001, 'QTY002' AS QTY002, 'QTY003' AS QTY003, 'QTY004' AS QTY004, 'QTY005' AS QTY005, 'QTY006' AS QTY006,
                 'QTY007' AS QTY007, 'QTY008' AS QTY008, 'QTY009' AS QTY009, 'QTY010' AS QTY010, 'QTY011' AS QTY011, 'QTY012' AS QTY012,
                 'QTY013' AS QTY013, 'QTY014' AS QTY014, 'QTY015' AS QTY015, 'QTY016' AS QTY016, 'QTY017' AS QTY017, 'QTY018' AS QTY018,
                 'QTY019' AS QTY019, 'QTY020' AS QTY020, 'QTY021' AS QTY021, 'QTY022' AS QTY022, 'QTY023' AS QTY023, 'QTY024' AS QTY024,
                 'QTY025' AS QTY025, 'QTY026' AS QTY026, 'QTY027' AS QTY027, 'QTY028' AS QTY028, 'QTY029' AS QTY029, 'QTY030' AS QTY030,
                 'QTY031' AS QTY031, 'QTY032' AS QTY032, 'QTY033' AS QTY033, 'QTY034' AS QTY034, 'QTY035' AS QTY035, 'QTY036' AS QTY036,
                 'QTY037' AS QTY037, 'QTY038' AS QTY038, 'QTY039' AS QTY039, 'QTY040' AS QTY040, 'QTY041' AS QTY041, 'QTY042' AS QTY042,
                 'QTY043' AS QTY043, 'QTY044' AS QTY044, 'QTY045' AS QTY045, 'QTY046' AS QTY046, 'QTY047' AS QTY047, 'QTY048' AS QTY048,
                 'QTY049' AS QTY049, 'QTY050' AS QTY050, 'QTY051' AS QTY051, 'QTY052' AS QTY052, 'QTY053' AS QTY053, 'QTY054' AS QTY054,
                 'QTY055' AS QTY055, 'QTY056' AS QTY056, 'QTY057' AS QTY057, 'QTY058' AS QTY058, 'QTY059' AS QTY059, 'QTY060' AS QTY060,
                 'QTY061' AS QTY061, 'QTY062' AS QTY062, 'QTY063' AS QTY063, 'QTY064' AS QTY064, 'QTY065' AS QTY065, 'QTY066' AS QTY066,
                 'QTY067' AS QTY067, 'QTY068' AS QTY068, 'QTY069' AS QTY069, 'QTY070' AS QTY070, 'QTY071' AS QTY071, 'QTY072' AS QTY072,
                 'QTY073' AS QTY073, 'QTY074' AS QTY074, 'QTY075' AS QTY075, 'QTY076' AS QTY076, 'QTY077' AS QTY077, 'QTY078' AS QTY078,
                 'QTY079' AS QTY079, 'QTY080' AS QTY080, 'QTY081' AS QTY081, 'QTY082' AS QTY082, 'QTY083' AS QTY083, 'QTY084' AS QTY084,
                 'QTY085' AS QTY085, 'QTY086' AS QTY086, 'QTY087' AS QTY087, 'QTY088' AS QTY088, 'QTY089' AS QTY089, 'QTY090' AS QTY090,
                 'QTY091' AS QTY091, 'QTY092' AS QTY092, 'QTY093' AS QTY093, 'QTY094' AS QTY094, 'QTY095' AS QTY095, 'QTY096' AS QTY096,
                 'QTY097' AS QTY097, 'QTY098' AS QTY098, 'QTY099' AS QTY099, 'QTY100' AS QTY100, 'QTY101' AS QTY101, 'QTY102' AS QTY102,
                 'QTY103' AS QTY103, 'QTY104' AS QTY104, 'QTY105' AS QTY105, 'QTY106' AS QTY106, 'QTY107' AS QTY107, 'QTY108' AS QTY108,
                 'QTY109' AS QTY109, 'QTY110' AS QTY110, 'QTY111' AS QTY111, 'QTY112' AS QTY112, 'QTY113' AS QTY113, 'QTY114' AS QTY114,
                 'QTY115' AS QTY115, 'QTY116' AS QTY116, 'QTY117' AS QTY117, 'QTY118' AS QTY118, 'QTY119' AS QTY119, 'QTY120' AS QTY120,
                 'QTY121' AS QTY121, 'QTY122' AS QTY122, 'QTY123' AS QTY123, 'QTY124' AS QTY124, 'QTY125' AS QTY125, 'QTY126' AS QTY126,
                 'QTY127' AS QTY127, 'QTY128' AS QTY128, 'QTY129' AS QTY129, 'QTY130' AS QTY130, 'QTY131' AS QTY131, 'QTY132' AS QTY132,
                 'QTY133' AS QTY133, 'QTY134' AS QTY134, 'QTY135' AS QTY135, 'QTY136' AS QTY136, 'QTY137' AS QTY137, 'QTY138' AS QTY138,
                 'QTY139' AS QTY139, 'QTY140' AS QTY140, 'QTY141' AS QTY141, 'QTY142' AS QTY142, 'QTY143' AS QTY143, 'QTY144' AS QTY144,
                 'QTY145' AS QTY145, 'QTY146' AS QTY146, 'QTY147' AS QTY147, 'QTY148' AS QTY148, 'QTY149' AS QTY149, 'QTY150' AS QTY150,
                 'QTY151' AS QTY151, 'QTY152' AS QTY152, 'QTY153' AS QTY153, 'QTY154' AS QTY154, 'QTY155' AS QTY155, 'QTY156' AS QTY156,
                 'QTY157' AS QTY157, 'QTY158' AS QTY158, 'QTY159' AS QTY159, 'QTY160' AS QTY160, 'QTY161' AS QTY161, 'QTY162' AS QTY162,
                 'QTY163' AS QTY163, 'QTY164' AS QTY164, 'QTY165' AS QTY165, 'QTY166' AS QTY166, 'QTY167' AS QTY167, 'QTY168' AS QTY168,
                 'QTY169' AS QTY169, 'QTY170' AS QTY170, 'QTY171' AS QTY171, 'QTY172' AS QTY172, 'QTY173' AS QTY173, 'QTY174' AS QTY174,
                 'QTY175' AS QTY175, 'QTY176' AS QTY176, 'QTY177' AS QTY177, 'QTY178' AS QTY178, 'QTY179' AS QTY179, 'QTY180' AS QTY180,
                 'QTY181' AS QTY181, 'QTY182' AS QTY182, 'QTY183' AS QTY183, 'QTY184' AS QTY184, 'QTY185' AS QTY185, 'QTY186' AS QTY186,
                 'QTY187' AS QTY187, 'QTY188' AS QTY188, 'QTY189' AS QTY189, 'QTY190' AS QTY190, 'QTY191' AS QTY191, 'QTY192' AS QTY192,
                 'QTY193' AS QTY193, 'QTY194' AS QTY194, 'QTY195' AS QTY195, 'QTY196' AS QTY196, 'QTY197' AS QTY197, 'QTY198' AS QTY198,
                 'QTY199' AS QTY199, 'QTY200' AS QTY200, 'QTY201' AS QTY201, 'QTY202' AS QTY202, 'QTY203' AS QTY203, 'QTY204' AS QTY204,
                 'QTY205' AS QTY205, 'QTY206' AS QTY206, 'QTY207' AS QTY207, 'QTY208' AS QTY208, 'QTY209' AS QTY209, 'QTY210' AS QTY210,
                 'QTY211' AS QTY211, 'QTY212' AS QTY212, 'QTY213' AS QTY213, 'QTY214' AS QTY214, 'QTY215' AS QTY215, 'QTY216' AS QTY216,
                 'QTY217' AS QTY217, 'QTY218' AS QTY218, 'QTY219' AS QTY219, 'QTY220' AS QTY220, 'QTY221' AS QTY221, 'QTY222' AS QTY222,
                 'QTY223' AS QTY223, 'QTY224' AS QTY224, 'QTY225' AS QTY225, 'QTY226' AS QTY226, 'QTY227' AS QTY227, 'QTY228' AS QTY228,
                 'QTY229' AS QTY229, 'QTY230' AS QTY230, 'QTY231' AS QTY231, 'QTY232' AS QTY232, 'QTY233' AS QTY233, 'QTY234' AS QTY234,
                 'QTY235' AS QTY235, 'QTY236' AS QTY236, 'QTY237' AS QTY237, 'QTY238' AS QTY238, 'QTY239' AS QTY239, 'QTY240' AS QTY240,
                 'QTY241' AS QTY241, 'QTY242' AS QTY242, 'QTY243' AS QTY243, 'QTY244' AS QTY244, 'QTY245' AS QTY245, 'QTY246' AS QTY246,
                 'QTY247' AS QTY247, 'QTY248' AS QTY248, 'QTY249' AS QTY249, 'QTY250' AS QTY250, 'QTY251' AS QTY251, 'QTY252' AS QTY252,
                 'QTY253' AS QTY253, 'QTY254' AS QTY254, 'QTY255' AS QTY255, 'QTY256' AS QTY256, 'QTY257' AS QTY257, 'QTY258' AS QTY258,
                 'QTY259' AS QTY259, 'QTY260' AS QTY260, 'QTY261' AS QTY261, 'QTY262' AS QTY262, 'QTY263' AS QTY263, 'QTY264' AS QTY264,
                 'QTY265' AS QTY265, 'QTY266' AS QTY266, 'QTY267' AS QTY267, 'QTY268' AS QTY268, 'QTY269' AS QTY269, 'QTY270' AS QTY270,
                 'QTY271' AS QTY271, 'QTY272' AS QTY272, 'QTY273' AS QTY273, 'QTY274' AS QTY274, 'QTY275' AS QTY275, 'QTY276' AS QTY276,
                 'QTY277' AS QTY277, 'QTY278' AS QTY278, 'QTY279' AS QTY279, 'QTY280' AS QTY280, 'QTY281' AS QTY281, 'QTY282' AS QTY282,
                 'QTY283' AS QTY283, 'QTY284' AS QTY284, 'QTY285' AS QTY285, 'QTY286' AS QTY286, 'QTY287' AS QTY287, 'QTY288' AS QTY288,
                 'QTY289' AS QTY289, 'QTY290' AS QTY290, 'QTY291' AS QTY291, 'QTY292' AS QTY292, 'QTY293' AS QTY293, 'QTY294' AS QTY294,
                 'QTY295' AS QTY295, 'QTY296' AS QTY296, 'QTY297' AS QTY297, 'QTY298' AS QTY298, 'QTY299' AS QTY299, 'QTY300' AS QTY300,
                 'QTY301' AS QTY301, 'QTY302' AS QTY302, 'QTY303' AS QTY303, 'QTY304' AS QTY304, 'QTY305' AS QTY305, 'QTY306' AS QTY306,
                 'QTY307' AS QTY307, 'QTY308' AS QTY308, 'QTY309' AS QTY309, 'QTY310' AS QTY310, 'QTY311' AS QTY311, 'QTY312' AS QTY312,
                 'QTY313' AS QTY313, 'QTY314' AS QTY314, 'QTY315' AS QTY315, 'QTY316' AS QTY316, 'QTY317' AS QTY317, 'QTY318' AS QTY318,
                 'QTY319' AS QTY319, 'QTY320' AS QTY320, 'QTY321' AS QTY321, 'QTY322' AS QTY322, 'QTY323' AS QTY323, 'QTY324' AS QTY324,
                 'QTY325' AS QTY325, 'QTY326' AS QTY326, 'QTY327' AS QTY327, 'QTY328' AS QTY328, 'QTY329' AS QTY329, 'QTY330' AS QTY330,
                 'QTY331' AS QTY331, 'QTY332' AS QTY332, 'QTY333' AS QTY333, 'QTY334' AS QTY334, 'QTY335' AS QTY335, 'QTY336' AS QTY336,
                 'QTY337' AS QTY337, 'QTY338' AS QTY338, 'QTY339' AS QTY339, 'QTY340' AS QTY340, 'QTY341' AS QTY341, 'QTY342' AS QTY342,
                 'QTY343' AS QTY343, 'QTY344' AS QTY344, 'QTY345' AS QTY345, 'QTY346' AS QTY346, 'QTY347' AS QTY347, 'QTY348' AS QTY348,
                 'QTY349' AS QTY349, 'QTY350' AS QTY350, 'QTY351' AS QTY351, 'QTY352' AS QTY352, 'QTY353' AS QTY353, 'QTY354' AS QTY354,
                 'QTY355' AS QTY355, 'QTY356' AS QTY356, 'QTY357' AS QTY357, 'QTY358' AS QTY358, 'QTY359' AS QTY359, 'QTY360' AS QTY360,
                 'QTY361' AS QTY361, 'QTY362' AS QTY362, 'QTY363' AS QTY363, 'QTY364' AS QTY364
           ) )
     GROUP BY DIVISION_ID
            , SCM_SITE_ID
            , OPERATION_ID
            , LINE_ID
            , ITEM_ID
    ;

    /* 원본 L1599~L1660 : UPDATE .. FROM JOIN -> MERGE (SOP §3.3) */
    MERGE INTO GT_SCXL_PSI_GLOBAL_ESS X
    USING GT_SCXL_PROD_TACT_PIVOT Y
       ON (    0 = 0
           AND X.ATTRIBUTE9 = Y.OPERATION_ID
           AND X.FROM_SITE  = Y.SCM_SITE_ID
           AND X.PROD_LINE  = Y.LINE_ID
           AND X.ITEM_ID    = Y.ITEM_ID
           AND X.MEASURE    IN ('PACK_TACT_TIME', 'CELL_TACT_TIME') )
     WHEN MATCHED THEN UPDATE
        SET X.QTY001 = NVL(Y.QTY001, 0), X.QTY002 = NVL(Y.QTY002, 0), X.QTY003 = NVL(Y.QTY003, 0), X.QTY004 = NVL(Y.QTY004, 0)
          , X.QTY005 = NVL(Y.QTY005, 0), X.QTY006 = NVL(Y.QTY006, 0), X.QTY007 = NVL(Y.QTY007, 0), X.QTY008 = NVL(Y.QTY008, 0)
          , X.QTY009 = NVL(Y.QTY009, 0), X.QTY010 = NVL(Y.QTY010, 0), X.QTY011 = NVL(Y.QTY011, 0), X.QTY012 = NVL(Y.QTY012, 0)
          , X.QTY013 = NVL(Y.QTY013, 0), X.QTY014 = NVL(Y.QTY014, 0), X.QTY015 = NVL(Y.QTY015, 0), X.QTY016 = NVL(Y.QTY016, 0)
          , X.QTY017 = NVL(Y.QTY017, 0), X.QTY018 = NVL(Y.QTY018, 0), X.QTY019 = NVL(Y.QTY019, 0), X.QTY020 = NVL(Y.QTY020, 0)
          , X.QTY021 = NVL(Y.QTY021, 0), X.QTY022 = NVL(Y.QTY022, 0), X.QTY023 = NVL(Y.QTY023, 0), X.QTY024 = NVL(Y.QTY024, 0)
          , X.QTY025 = NVL(Y.QTY025, 0), X.QTY026 = NVL(Y.QTY026, 0), X.QTY027 = NVL(Y.QTY027, 0), X.QTY028 = NVL(Y.QTY028, 0)
          , X.QTY029 = NVL(Y.QTY029, 0), X.QTY030 = NVL(Y.QTY030, 0), X.QTY031 = NVL(Y.QTY031, 0), X.QTY032 = NVL(Y.QTY032, 0)
          , X.QTY033 = NVL(Y.QTY033, 0), X.QTY034 = NVL(Y.QTY034, 0), X.QTY035 = NVL(Y.QTY035, 0), X.QTY036 = NVL(Y.QTY036, 0)
          , X.QTY037 = NVL(Y.QTY037, 0), X.QTY038 = NVL(Y.QTY038, 0), X.QTY039 = NVL(Y.QTY039, 0), X.QTY040 = NVL(Y.QTY040, 0)
          , X.QTY041 = NVL(Y.QTY041, 0), X.QTY042 = NVL(Y.QTY042, 0), X.QTY043 = NVL(Y.QTY043, 0), X.QTY044 = NVL(Y.QTY044, 0)
          , X.QTY045 = NVL(Y.QTY045, 0), X.QTY046 = NVL(Y.QTY046, 0), X.QTY047 = NVL(Y.QTY047, 0), X.QTY048 = NVL(Y.QTY048, 0)
          , X.QTY049 = NVL(Y.QTY049, 0), X.QTY050 = NVL(Y.QTY050, 0), X.QTY051 = NVL(Y.QTY051, 0), X.QTY052 = NVL(Y.QTY052, 0)
          , X.QTY053 = NVL(Y.QTY053, 0), X.QTY054 = NVL(Y.QTY054, 0), X.QTY055 = NVL(Y.QTY055, 0), X.QTY056 = NVL(Y.QTY056, 0)
          , X.QTY057 = NVL(Y.QTY057, 0), X.QTY058 = NVL(Y.QTY058, 0), X.QTY059 = NVL(Y.QTY059, 0), X.QTY060 = NVL(Y.QTY060, 0)
          , X.QTY061 = NVL(Y.QTY061, 0), X.QTY062 = NVL(Y.QTY062, 0), X.QTY063 = NVL(Y.QTY063, 0), X.QTY064 = NVL(Y.QTY064, 0)
          , X.QTY065 = NVL(Y.QTY065, 0), X.QTY066 = NVL(Y.QTY066, 0), X.QTY067 = NVL(Y.QTY067, 0), X.QTY068 = NVL(Y.QTY068, 0)
          , X.QTY069 = NVL(Y.QTY069, 0), X.QTY070 = NVL(Y.QTY070, 0), X.QTY071 = NVL(Y.QTY071, 0), X.QTY072 = NVL(Y.QTY072, 0)
          , X.QTY073 = NVL(Y.QTY073, 0), X.QTY074 = NVL(Y.QTY074, 0), X.QTY075 = NVL(Y.QTY075, 0), X.QTY076 = NVL(Y.QTY076, 0)
          , X.QTY077 = NVL(Y.QTY077, 0), X.QTY078 = NVL(Y.QTY078, 0), X.QTY079 = NVL(Y.QTY079, 0), X.QTY080 = NVL(Y.QTY080, 0)
          , X.QTY081 = NVL(Y.QTY081, 0), X.QTY082 = NVL(Y.QTY082, 0), X.QTY083 = NVL(Y.QTY083, 0), X.QTY084 = NVL(Y.QTY084, 0)
          , X.QTY085 = NVL(Y.QTY085, 0), X.QTY086 = NVL(Y.QTY086, 0), X.QTY087 = NVL(Y.QTY087, 0), X.QTY088 = NVL(Y.QTY088, 0)
          , X.QTY089 = NVL(Y.QTY089, 0), X.QTY090 = NVL(Y.QTY090, 0), X.QTY091 = NVL(Y.QTY091, 0), X.QTY092 = NVL(Y.QTY092, 0)
          , X.QTY093 = NVL(Y.QTY093, 0), X.QTY094 = NVL(Y.QTY094, 0), X.QTY095 = NVL(Y.QTY095, 0), X.QTY096 = NVL(Y.QTY096, 0)
          , X.QTY097 = NVL(Y.QTY097, 0), X.QTY098 = NVL(Y.QTY098, 0), X.QTY099 = NVL(Y.QTY099, 0), X.QTY100 = NVL(Y.QTY100, 0)
          , X.QTY101 = NVL(Y.QTY101, 0), X.QTY102 = NVL(Y.QTY102, 0), X.QTY103 = NVL(Y.QTY103, 0), X.QTY104 = NVL(Y.QTY104, 0)
          , X.QTY105 = NVL(Y.QTY105, 0), X.QTY106 = NVL(Y.QTY106, 0), X.QTY107 = NVL(Y.QTY107, 0), X.QTY108 = NVL(Y.QTY108, 0)
          , X.QTY109 = NVL(Y.QTY109, 0), X.QTY110 = NVL(Y.QTY110, 0), X.QTY111 = NVL(Y.QTY111, 0), X.QTY112 = NVL(Y.QTY112, 0)
          , X.QTY113 = NVL(Y.QTY113, 0), X.QTY114 = NVL(Y.QTY114, 0), X.QTY115 = NVL(Y.QTY115, 0), X.QTY116 = NVL(Y.QTY116, 0)
          , X.QTY117 = NVL(Y.QTY117, 0), X.QTY118 = NVL(Y.QTY118, 0), X.QTY119 = NVL(Y.QTY119, 0), X.QTY120 = NVL(Y.QTY120, 0)
          , X.QTY121 = NVL(Y.QTY121, 0), X.QTY122 = NVL(Y.QTY122, 0), X.QTY123 = NVL(Y.QTY123, 0), X.QTY124 = NVL(Y.QTY124, 0)
          , X.QTY125 = NVL(Y.QTY125, 0), X.QTY126 = NVL(Y.QTY126, 0), X.QTY127 = NVL(Y.QTY127, 0), X.QTY128 = NVL(Y.QTY128, 0)
          , X.QTY129 = NVL(Y.QTY129, 0), X.QTY130 = NVL(Y.QTY130, 0), X.QTY131 = NVL(Y.QTY131, 0), X.QTY132 = NVL(Y.QTY132, 0)
          , X.QTY133 = NVL(Y.QTY133, 0), X.QTY134 = NVL(Y.QTY134, 0), X.QTY135 = NVL(Y.QTY135, 0), X.QTY136 = NVL(Y.QTY136, 0)
          , X.QTY137 = NVL(Y.QTY137, 0), X.QTY138 = NVL(Y.QTY138, 0), X.QTY139 = NVL(Y.QTY139, 0), X.QTY140 = NVL(Y.QTY140, 0)
          , X.QTY141 = NVL(Y.QTY141, 0), X.QTY142 = NVL(Y.QTY142, 0), X.QTY143 = NVL(Y.QTY143, 0), X.QTY144 = NVL(Y.QTY144, 0)
          , X.QTY145 = NVL(Y.QTY145, 0), X.QTY146 = NVL(Y.QTY146, 0), X.QTY147 = NVL(Y.QTY147, 0), X.QTY148 = NVL(Y.QTY148, 0)
          , X.QTY149 = NVL(Y.QTY149, 0), X.QTY150 = NVL(Y.QTY150, 0), X.QTY151 = NVL(Y.QTY151, 0), X.QTY152 = NVL(Y.QTY152, 0)
          , X.QTY153 = NVL(Y.QTY153, 0), X.QTY154 = NVL(Y.QTY154, 0), X.QTY155 = NVL(Y.QTY155, 0), X.QTY156 = NVL(Y.QTY156, 0)
          , X.QTY157 = NVL(Y.QTY157, 0), X.QTY158 = NVL(Y.QTY158, 0), X.QTY159 = NVL(Y.QTY159, 0), X.QTY160 = NVL(Y.QTY160, 0)
          , X.QTY161 = NVL(Y.QTY161, 0), X.QTY162 = NVL(Y.QTY162, 0), X.QTY163 = NVL(Y.QTY163, 0), X.QTY164 = NVL(Y.QTY164, 0)
          , X.QTY165 = NVL(Y.QTY165, 0), X.QTY166 = NVL(Y.QTY166, 0), X.QTY167 = NVL(Y.QTY167, 0), X.QTY168 = NVL(Y.QTY168, 0)
          , X.QTY169 = NVL(Y.QTY169, 0), X.QTY170 = NVL(Y.QTY170, 0), X.QTY171 = NVL(Y.QTY171, 0), X.QTY172 = NVL(Y.QTY172, 0)
          , X.QTY173 = NVL(Y.QTY173, 0), X.QTY174 = NVL(Y.QTY174, 0), X.QTY175 = NVL(Y.QTY175, 0), X.QTY176 = NVL(Y.QTY176, 0)
          , X.QTY177 = NVL(Y.QTY177, 0), X.QTY178 = NVL(Y.QTY178, 0), X.QTY179 = NVL(Y.QTY179, 0), X.QTY180 = NVL(Y.QTY180, 0)
          , X.QTY181 = NVL(Y.QTY181, 0), X.QTY182 = NVL(Y.QTY182, 0), X.QTY183 = NVL(Y.QTY183, 0), X.QTY184 = NVL(Y.QTY184, 0)
          , X.QTY185 = NVL(Y.QTY185, 0), X.QTY186 = NVL(Y.QTY186, 0), X.QTY187 = NVL(Y.QTY187, 0), X.QTY188 = NVL(Y.QTY188, 0)
          , X.QTY189 = NVL(Y.QTY189, 0), X.QTY190 = NVL(Y.QTY190, 0), X.QTY191 = NVL(Y.QTY191, 0), X.QTY192 = NVL(Y.QTY192, 0)
          , X.QTY193 = NVL(Y.QTY193, 0), X.QTY194 = NVL(Y.QTY194, 0), X.QTY195 = NVL(Y.QTY195, 0), X.QTY196 = NVL(Y.QTY196, 0)
          , X.QTY197 = NVL(Y.QTY197, 0), X.QTY198 = NVL(Y.QTY198, 0), X.QTY199 = NVL(Y.QTY199, 0), X.QTY200 = NVL(Y.QTY200, 0)
          , X.QTY201 = NVL(Y.QTY201, 0), X.QTY202 = NVL(Y.QTY202, 0), X.QTY203 = NVL(Y.QTY203, 0), X.QTY204 = NVL(Y.QTY204, 0)
          , X.QTY205 = NVL(Y.QTY205, 0), X.QTY206 = NVL(Y.QTY206, 0), X.QTY207 = NVL(Y.QTY207, 0), X.QTY208 = NVL(Y.QTY208, 0)
          , X.QTY209 = NVL(Y.QTY209, 0), X.QTY210 = NVL(Y.QTY210, 0), X.QTY211 = NVL(Y.QTY211, 0), X.QTY212 = NVL(Y.QTY212, 0)
          , X.QTY213 = NVL(Y.QTY213, 0), X.QTY214 = NVL(Y.QTY214, 0), X.QTY215 = NVL(Y.QTY215, 0), X.QTY216 = NVL(Y.QTY216, 0)
          , X.QTY217 = NVL(Y.QTY217, 0), X.QTY218 = NVL(Y.QTY218, 0), X.QTY219 = NVL(Y.QTY219, 0), X.QTY220 = NVL(Y.QTY220, 0)
          , X.QTY221 = NVL(Y.QTY221, 0), X.QTY222 = NVL(Y.QTY222, 0), X.QTY223 = NVL(Y.QTY223, 0), X.QTY224 = NVL(Y.QTY224, 0)
          , X.QTY225 = NVL(Y.QTY225, 0), X.QTY226 = NVL(Y.QTY226, 0), X.QTY227 = NVL(Y.QTY227, 0), X.QTY228 = NVL(Y.QTY228, 0)
          , X.QTY229 = NVL(Y.QTY229, 0), X.QTY230 = NVL(Y.QTY230, 0), X.QTY231 = NVL(Y.QTY231, 0), X.QTY232 = NVL(Y.QTY232, 0)
          , X.QTY233 = NVL(Y.QTY233, 0), X.QTY234 = NVL(Y.QTY234, 0), X.QTY235 = NVL(Y.QTY235, 0), X.QTY236 = NVL(Y.QTY236, 0)
          , X.QTY237 = NVL(Y.QTY237, 0), X.QTY238 = NVL(Y.QTY238, 0), X.QTY239 = NVL(Y.QTY239, 0), X.QTY240 = NVL(Y.QTY240, 0)
          , X.QTY241 = NVL(Y.QTY241, 0), X.QTY242 = NVL(Y.QTY242, 0), X.QTY243 = NVL(Y.QTY243, 0), X.QTY244 = NVL(Y.QTY244, 0)
          , X.QTY245 = NVL(Y.QTY245, 0), X.QTY246 = NVL(Y.QTY246, 0), X.QTY247 = NVL(Y.QTY247, 0), X.QTY248 = NVL(Y.QTY248, 0)
          , X.QTY249 = NVL(Y.QTY249, 0), X.QTY250 = NVL(Y.QTY250, 0), X.QTY251 = NVL(Y.QTY251, 0), X.QTY252 = NVL(Y.QTY252, 0)
          , X.QTY253 = NVL(Y.QTY253, 0), X.QTY254 = NVL(Y.QTY254, 0), X.QTY255 = NVL(Y.QTY255, 0), X.QTY256 = NVL(Y.QTY256, 0)
          , X.QTY257 = NVL(Y.QTY257, 0), X.QTY258 = NVL(Y.QTY258, 0), X.QTY259 = NVL(Y.QTY259, 0), X.QTY260 = NVL(Y.QTY260, 0)
          , X.QTY261 = NVL(Y.QTY261, 0), X.QTY262 = NVL(Y.QTY262, 0), X.QTY263 = NVL(Y.QTY263, 0), X.QTY264 = NVL(Y.QTY264, 0)
          , X.QTY265 = NVL(Y.QTY265, 0), X.QTY266 = NVL(Y.QTY266, 0), X.QTY267 = NVL(Y.QTY267, 0), X.QTY268 = NVL(Y.QTY268, 0)
          , X.QTY269 = NVL(Y.QTY269, 0), X.QTY270 = NVL(Y.QTY270, 0), X.QTY271 = NVL(Y.QTY271, 0), X.QTY272 = NVL(Y.QTY272, 0)
          , X.QTY273 = NVL(Y.QTY273, 0), X.QTY274 = NVL(Y.QTY274, 0), X.QTY275 = NVL(Y.QTY275, 0), X.QTY276 = NVL(Y.QTY276, 0)
          , X.QTY277 = NVL(Y.QTY277, 0), X.QTY278 = NVL(Y.QTY278, 0), X.QTY279 = NVL(Y.QTY279, 0), X.QTY280 = NVL(Y.QTY280, 0)
          , X.QTY281 = NVL(Y.QTY281, 0), X.QTY282 = NVL(Y.QTY282, 0), X.QTY283 = NVL(Y.QTY283, 0), X.QTY284 = NVL(Y.QTY284, 0)
          , X.QTY285 = NVL(Y.QTY285, 0), X.QTY286 = NVL(Y.QTY286, 0), X.QTY287 = NVL(Y.QTY287, 0), X.QTY288 = NVL(Y.QTY288, 0)
          , X.QTY289 = NVL(Y.QTY289, 0), X.QTY290 = NVL(Y.QTY290, 0), X.QTY291 = NVL(Y.QTY291, 0), X.QTY292 = NVL(Y.QTY292, 0)
          , X.QTY293 = NVL(Y.QTY293, 0), X.QTY294 = NVL(Y.QTY294, 0), X.QTY295 = NVL(Y.QTY295, 0), X.QTY296 = NVL(Y.QTY296, 0)
          , X.QTY297 = NVL(Y.QTY297, 0), X.QTY298 = NVL(Y.QTY298, 0), X.QTY299 = NVL(Y.QTY299, 0), X.QTY300 = NVL(Y.QTY300, 0)
          , X.QTY301 = NVL(Y.QTY301, 0), X.QTY302 = NVL(Y.QTY302, 0), X.QTY303 = NVL(Y.QTY303, 0), X.QTY304 = NVL(Y.QTY304, 0)
          , X.QTY305 = NVL(Y.QTY305, 0), X.QTY306 = NVL(Y.QTY306, 0), X.QTY307 = NVL(Y.QTY307, 0), X.QTY308 = NVL(Y.QTY308, 0)
          , X.QTY309 = NVL(Y.QTY309, 0), X.QTY310 = NVL(Y.QTY310, 0), X.QTY311 = NVL(Y.QTY311, 0), X.QTY312 = NVL(Y.QTY312, 0)
          , X.QTY313 = NVL(Y.QTY313, 0), X.QTY314 = NVL(Y.QTY314, 0), X.QTY315 = NVL(Y.QTY315, 0), X.QTY316 = NVL(Y.QTY316, 0)
          , X.QTY317 = NVL(Y.QTY317, 0), X.QTY318 = NVL(Y.QTY318, 0), X.QTY319 = NVL(Y.QTY319, 0), X.QTY320 = NVL(Y.QTY320, 0)
          , X.QTY321 = NVL(Y.QTY321, 0), X.QTY322 = NVL(Y.QTY322, 0), X.QTY323 = NVL(Y.QTY323, 0), X.QTY324 = NVL(Y.QTY324, 0)
          , X.QTY325 = NVL(Y.QTY325, 0), X.QTY326 = NVL(Y.QTY326, 0), X.QTY327 = NVL(Y.QTY327, 0), X.QTY328 = NVL(Y.QTY328, 0)
          , X.QTY329 = NVL(Y.QTY329, 0), X.QTY330 = NVL(Y.QTY330, 0), X.QTY331 = NVL(Y.QTY331, 0), X.QTY332 = NVL(Y.QTY332, 0)
          , X.QTY333 = NVL(Y.QTY333, 0), X.QTY334 = NVL(Y.QTY334, 0), X.QTY335 = NVL(Y.QTY335, 0), X.QTY336 = NVL(Y.QTY336, 0)
          , X.QTY337 = NVL(Y.QTY337, 0), X.QTY338 = NVL(Y.QTY338, 0), X.QTY339 = NVL(Y.QTY339, 0), X.QTY340 = NVL(Y.QTY340, 0)
          , X.QTY341 = NVL(Y.QTY341, 0), X.QTY342 = NVL(Y.QTY342, 0), X.QTY343 = NVL(Y.QTY343, 0), X.QTY344 = NVL(Y.QTY344, 0)
          , X.QTY345 = NVL(Y.QTY345, 0), X.QTY346 = NVL(Y.QTY346, 0), X.QTY347 = NVL(Y.QTY347, 0), X.QTY348 = NVL(Y.QTY348, 0)
          , X.QTY349 = NVL(Y.QTY349, 0), X.QTY350 = NVL(Y.QTY350, 0), X.QTY351 = NVL(Y.QTY351, 0), X.QTY352 = NVL(Y.QTY352, 0)
          , X.QTY353 = NVL(Y.QTY353, 0), X.QTY354 = NVL(Y.QTY354, 0), X.QTY355 = NVL(Y.QTY355, 0), X.QTY356 = NVL(Y.QTY356, 0)
          , X.QTY357 = NVL(Y.QTY357, 0), X.QTY358 = NVL(Y.QTY358, 0), X.QTY359 = NVL(Y.QTY359, 0), X.QTY360 = NVL(Y.QTY360, 0)
          , X.QTY361 = NVL(Y.QTY361, 0), X.QTY362 = NVL(Y.QTY362, 0), X.QTY363 = NVL(Y.QTY363, 0), X.QTY364 = NVL(Y.QTY364, 0)
    ;

    /* 원본 L1667~L1764 : CELL 합계 MEASURE(MKT_FCST/SHIP_REQ) 행 생성 */
    INSERT INTO GT_SCXL_PSI_GLOBAL_ESS
    SELECT DISTINCT X.DIVISION_ID
         , X.PLAN_START_YYYYMMDD
         , X.PLAN_TYPE
         , X.SEQ
         , X.OPERATION_GROUP
         , 'CELL' AS OPERATION_GROUP_NAME
         , X.CELL_ITEM_ID
         , '-' AS ITEM_ID
         , '-' AS NICK_NAME
         , '0' AS CELL_QTY_PACK
         , '-' AS TO_SITE
         , '-' AS TO_SITE_DESCRIPTION
         , '-' AS PROJECT_CODE
         , '0' AS FROM_BOH_QTY
         , '0' AS TO_BOH_QTY
         , '-' AS INCOTERMS
         , '-' AS FROM_SITE
         , '-' AS FROM_SITE_DESCRIPTION
         , '-' AS TRANSPORT_MODE
         , '-' AS PROD_LINE
         , '-' AS LT_DAY
         , '-' AS BOD_ID
         , M.COLUMN_NAME AS MEASURE
         , M.COLUMN_LABEL_NAME AS MEASURE_LABEL
         , X.XLS_KEY1
         , X.XLS_KEY2
         , X.XLS_KEY3
         , X.XLS_KEY4
         , X.XLS_KEY5
         , X.XLS_ATTRIBUTE1
         , X.XLS_ATTRIBUTE2
         , X.XLS_ATTRIBUTE3
         , X.XLS_ATTRIBUTE4
         , X.XLS_ATTRIBUTE5
         , M.SORT_ORDER_NO
         , 0 AS QTY001, 0 AS QTY002, 0 AS QTY003, 0 AS QTY004, 0 AS QTY005, 0 AS QTY006, 0 AS QTY007, 0 AS QTY008, 0 AS QTY009, 0 AS QTY010
         , 0 AS QTY011, 0 AS QTY012, 0 AS QTY013, 0 AS QTY014, 0 AS QTY015, 0 AS QTY016, 0 AS QTY017, 0 AS QTY018, 0 AS QTY019, 0 AS QTY020
         , 0 AS QTY021, 0 AS QTY022, 0 AS QTY023, 0 AS QTY024, 0 AS QTY025, 0 AS QTY026, 0 AS QTY027, 0 AS QTY028, 0 AS QTY029, 0 AS QTY030
         , 0 AS QTY031, 0 AS QTY032, 0 AS QTY033, 0 AS QTY034, 0 AS QTY035, 0 AS QTY036, 0 AS QTY037, 0 AS QTY038, 0 AS QTY039, 0 AS QTY040
         , 0 AS QTY041, 0 AS QTY042, 0 AS QTY043, 0 AS QTY044, 0 AS QTY045, 0 AS QTY046, 0 AS QTY047, 0 AS QTY048, 0 AS QTY049, 0 AS QTY050
         , 0 AS QTY051, 0 AS QTY052, 0 AS QTY053, 0 AS QTY054, 0 AS QTY055, 0 AS QTY056, 0 AS QTY057, 0 AS QTY058, 0 AS QTY059, 0 AS QTY060
         , 0 AS QTY061, 0 AS QTY062, 0 AS QTY063, 0 AS QTY064, 0 AS QTY065, 0 AS QTY066, 0 AS QTY067, 0 AS QTY068, 0 AS QTY069, 0 AS QTY070
         , 0 AS QTY071, 0 AS QTY072, 0 AS QTY073, 0 AS QTY074, 0 AS QTY075, 0 AS QTY076, 0 AS QTY077, 0 AS QTY078, 0 AS QTY079, 0 AS QTY080
         , 0 AS QTY081, 0 AS QTY082, 0 AS QTY083, 0 AS QTY084, 0 AS QTY085, 0 AS QTY086, 0 AS QTY087, 0 AS QTY088, 0 AS QTY089, 0 AS QTY090
         , 0 AS QTY091, 0 AS QTY092, 0 AS QTY093, 0 AS QTY094, 0 AS QTY095, 0 AS QTY096, 0 AS QTY097, 0 AS QTY098, 0 AS QTY099, 0 AS QTY100
         , 0 AS QTY101, 0 AS QTY102, 0 AS QTY103, 0 AS QTY104, 0 AS QTY105, 0 AS QTY106, 0 AS QTY107, 0 AS QTY108, 0 AS QTY109, 0 AS QTY110
         , 0 AS QTY111, 0 AS QTY112, 0 AS QTY113, 0 AS QTY114, 0 AS QTY115, 0 AS QTY116, 0 AS QTY117, 0 AS QTY118, 0 AS QTY119, 0 AS QTY120
         , 0 AS QTY121, 0 AS QTY122, 0 AS QTY123, 0 AS QTY124, 0 AS QTY125, 0 AS QTY126, 0 AS QTY127, 0 AS QTY128, 0 AS QTY129, 0 AS QTY130
         , 0 AS QTY131, 0 AS QTY132, 0 AS QTY133, 0 AS QTY134, 0 AS QTY135, 0 AS QTY136, 0 AS QTY137, 0 AS QTY138, 0 AS QTY139, 0 AS QTY140
         , 0 AS QTY141, 0 AS QTY142, 0 AS QTY143, 0 AS QTY144, 0 AS QTY145, 0 AS QTY146, 0 AS QTY147, 0 AS QTY148, 0 AS QTY149, 0 AS QTY150
         , 0 AS QTY151, 0 AS QTY152, 0 AS QTY153, 0 AS QTY154, 0 AS QTY155, 0 AS QTY156, 0 AS QTY157, 0 AS QTY158, 0 AS QTY159, 0 AS QTY160
         , 0 AS QTY161, 0 AS QTY162, 0 AS QTY163, 0 AS QTY164, 0 AS QTY165, 0 AS QTY166, 0 AS QTY167, 0 AS QTY168, 0 AS QTY169, 0 AS QTY170
         , 0 AS QTY171, 0 AS QTY172, 0 AS QTY173, 0 AS QTY174, 0 AS QTY175, 0 AS QTY176, 0 AS QTY177, 0 AS QTY178, 0 AS QTY179, 0 AS QTY180
         , 0 AS QTY181, 0 AS QTY182, 0 AS QTY183, 0 AS QTY184, 0 AS QTY185, 0 AS QTY186, 0 AS QTY187, 0 AS QTY188, 0 AS QTY189, 0 AS QTY190
         , 0 AS QTY191, 0 AS QTY192, 0 AS QTY193, 0 AS QTY194, 0 AS QTY195, 0 AS QTY196, 0 AS QTY197, 0 AS QTY198, 0 AS QTY199, 0 AS QTY200
         , 0 AS QTY201, 0 AS QTY202, 0 AS QTY203, 0 AS QTY204, 0 AS QTY205, 0 AS QTY206, 0 AS QTY207, 0 AS QTY208, 0 AS QTY209, 0 AS QTY210
         , 0 AS QTY211, 0 AS QTY212, 0 AS QTY213, 0 AS QTY214, 0 AS QTY215, 0 AS QTY216, 0 AS QTY217, 0 AS QTY218, 0 AS QTY219, 0 AS QTY220
         , 0 AS QTY221, 0 AS QTY222, 0 AS QTY223, 0 AS QTY224, 0 AS QTY225, 0 AS QTY226, 0 AS QTY227, 0 AS QTY228, 0 AS QTY229, 0 AS QTY230
         , 0 AS QTY231, 0 AS QTY232, 0 AS QTY233, 0 AS QTY234, 0 AS QTY235, 0 AS QTY236, 0 AS QTY237, 0 AS QTY238, 0 AS QTY239, 0 AS QTY240
         , 0 AS QTY241, 0 AS QTY242, 0 AS QTY243, 0 AS QTY244, 0 AS QTY245, 0 AS QTY246, 0 AS QTY247, 0 AS QTY248, 0 AS QTY249, 0 AS QTY250
         , 0 AS QTY251, 0 AS QTY252, 0 AS QTY253, 0 AS QTY254, 0 AS QTY255, 0 AS QTY256, 0 AS QTY257, 0 AS QTY258, 0 AS QTY259, 0 AS QTY260
         , 0 AS QTY261, 0 AS QTY262, 0 AS QTY263, 0 AS QTY264, 0 AS QTY265, 0 AS QTY266, 0 AS QTY267, 0 AS QTY268, 0 AS QTY269, 0 AS QTY270
         , 0 AS QTY271, 0 AS QTY272, 0 AS QTY273, 0 AS QTY274, 0 AS QTY275, 0 AS QTY276, 0 AS QTY277, 0 AS QTY278, 0 AS QTY279, 0 AS QTY280
         , 0 AS QTY281, 0 AS QTY282, 0 AS QTY283, 0 AS QTY284, 0 AS QTY285, 0 AS QTY286, 0 AS QTY287, 0 AS QTY288, 0 AS QTY289, 0 AS QTY290
         , 0 AS QTY291, 0 AS QTY292, 0 AS QTY293, 0 AS QTY294, 0 AS QTY295, 0 AS QTY296, 0 AS QTY297, 0 AS QTY298, 0 AS QTY299, 0 AS QTY300
         , 0 AS QTY301, 0 AS QTY302, 0 AS QTY303, 0 AS QTY304, 0 AS QTY305, 0 AS QTY306, 0 AS QTY307, 0 AS QTY308, 0 AS QTY309, 0 AS QTY310
         , 0 AS QTY311, 0 AS QTY312, 0 AS QTY313, 0 AS QTY314, 0 AS QTY315, 0 AS QTY316, 0 AS QTY317, 0 AS QTY318, 0 AS QTY319, 0 AS QTY320
         , 0 AS QTY321, 0 AS QTY322, 0 AS QTY323, 0 AS QTY324, 0 AS QTY325, 0 AS QTY326, 0 AS QTY327, 0 AS QTY328, 0 AS QTY329, 0 AS QTY330
         , 0 AS QTY331, 0 AS QTY332, 0 AS QTY333, 0 AS QTY334, 0 AS QTY335, 0 AS QTY336, 0 AS QTY337, 0 AS QTY338, 0 AS QTY339, 0 AS QTY340
         , 0 AS QTY341, 0 AS QTY342, 0 AS QTY343, 0 AS QTY344, 0 AS QTY345, 0 AS QTY346, 0 AS QTY347, 0 AS QTY348, 0 AS QTY349, 0 AS QTY350
         , 0 AS QTY351, 0 AS QTY352, 0 AS QTY353, 0 AS QTY354, 0 AS QTY355, 0 AS QTY356, 0 AS QTY357, 0 AS QTY358, 0 AS QTY359, 0 AS QTY360
         , 0 AS QTY361, 0 AS QTY362, 0 AS QTY363, 0 AS QTY364
         , (CASE WHEN M.COLUMN_NAME = 'MKT_FCST_CELL_TOTAL' THEN 'MKT_FCST_CELL_TOTAL'
                 WHEN M.COLUMN_NAME = 'SHIP_REQ_CELL_TOTAL' THEN 'SHIP_REQ_CELL_TOTAL'
                 ELSE 'DIO' END) AS ATTRIBUTE1
         , X.ATTRIBUTE2
         , X.ATTRIBUTE3
         , X.ATTRIBUTE4
         , X.ATTRIBUTE5
         , X.ATTRIBUTE6
         , X.ATTRIBUTE7
         , X.ATTRIBUTE8
         , NULL AS ATTRIBUTE9
         , X.ATTRIBUTE10
      FROM GT_SCXL_PSI_GLOBAL_ESS X
         , GT_SCXL_MEASURE M   /* 원본 CROSS APPLY */
     WHERE 1 = 1
       AND M.GUBUN       = 'CELL_ITEM_ID'
       AND M.COLUMN_NAME IN ('MKT_FCST_CELL_TOTAL','SHIP_REQ_CELL_TOTAL')
       AND X.OPERATION_GROUP = 'A'
    ;

    /* 원본 L1771~L1867 : 그 외 CELL_ITEM_ID MEASURE 행 생성(OPERATION_GROUP 을 A 로 고정) */
    INSERT INTO GT_SCXL_PSI_GLOBAL_ESS
    SELECT DISTINCT X.DIVISION_ID
         , X.PLAN_START_YYYYMMDD
         , X.PLAN_TYPE
         , X.SEQ
         , 'A' AS OPERATION_GROUP
         , 'CELL' AS OPERATION_GROUP_NAME
         , X.CELL_ITEM_ID
         , '-' AS ITEM_ID
         , '-' AS NICK_NAME
         , '0' AS CELL_QTY_PACK
         , '-' AS TO_SITE
         , '-' AS TO_SITE_DESCRIPTION
         , '-' AS PROJECT_CODE
         , '0' AS FROM_BOH_QTY
         , '0' AS TO_BOH_QTY
         , '-' AS INCOTERMS
         , '-' AS FROM_SITE
         , '-' AS FROM_SITE_DESCRIPTION
         , '-' AS TRANSPORT_MODE
         , '-' AS PROD_LINE
         , '-' AS LT_DAY
         , '-' AS BOD_ID
         , M.COLUMN_NAME AS MEASURE
         , M.COLUMN_LABEL_NAME AS MEASURE_LABEL
         , X.XLS_KEY1
         , X.XLS_KEY2
         , X.XLS_KEY3
         , X.XLS_KEY4
         , X.XLS_KEY5
         , X.XLS_ATTRIBUTE1
         , X.XLS_ATTRIBUTE2
         , X.XLS_ATTRIBUTE3
         , X.XLS_ATTRIBUTE4
         , X.XLS_ATTRIBUTE5
         , M.SORT_ORDER_NO
         , 0 AS QTY001, 0 AS QTY002, 0 AS QTY003, 0 AS QTY004, 0 AS QTY005, 0 AS QTY006, 0 AS QTY007, 0 AS QTY008, 0 AS QTY009, 0 AS QTY010
         , 0 AS QTY011, 0 AS QTY012, 0 AS QTY013, 0 AS QTY014, 0 AS QTY015, 0 AS QTY016, 0 AS QTY017, 0 AS QTY018, 0 AS QTY019, 0 AS QTY020
         , 0 AS QTY021, 0 AS QTY022, 0 AS QTY023, 0 AS QTY024, 0 AS QTY025, 0 AS QTY026, 0 AS QTY027, 0 AS QTY028, 0 AS QTY029, 0 AS QTY030
         , 0 AS QTY031, 0 AS QTY032, 0 AS QTY033, 0 AS QTY034, 0 AS QTY035, 0 AS QTY036, 0 AS QTY037, 0 AS QTY038, 0 AS QTY039, 0 AS QTY040
         , 0 AS QTY041, 0 AS QTY042, 0 AS QTY043, 0 AS QTY044, 0 AS QTY045, 0 AS QTY046, 0 AS QTY047, 0 AS QTY048, 0 AS QTY049, 0 AS QTY050
         , 0 AS QTY051, 0 AS QTY052, 0 AS QTY053, 0 AS QTY054, 0 AS QTY055, 0 AS QTY056, 0 AS QTY057, 0 AS QTY058, 0 AS QTY059, 0 AS QTY060
         , 0 AS QTY061, 0 AS QTY062, 0 AS QTY063, 0 AS QTY064, 0 AS QTY065, 0 AS QTY066, 0 AS QTY067, 0 AS QTY068, 0 AS QTY069, 0 AS QTY070
         , 0 AS QTY071, 0 AS QTY072, 0 AS QTY073, 0 AS QTY074, 0 AS QTY075, 0 AS QTY076, 0 AS QTY077, 0 AS QTY078, 0 AS QTY079, 0 AS QTY080
         , 0 AS QTY081, 0 AS QTY082, 0 AS QTY083, 0 AS QTY084, 0 AS QTY085, 0 AS QTY086, 0 AS QTY087, 0 AS QTY088, 0 AS QTY089, 0 AS QTY090
         , 0 AS QTY091, 0 AS QTY092, 0 AS QTY093, 0 AS QTY094, 0 AS QTY095, 0 AS QTY096, 0 AS QTY097, 0 AS QTY098, 0 AS QTY099, 0 AS QTY100
         , 0 AS QTY101, 0 AS QTY102, 0 AS QTY103, 0 AS QTY104, 0 AS QTY105, 0 AS QTY106, 0 AS QTY107, 0 AS QTY108, 0 AS QTY109, 0 AS QTY110
         , 0 AS QTY111, 0 AS QTY112, 0 AS QTY113, 0 AS QTY114, 0 AS QTY115, 0 AS QTY116, 0 AS QTY117, 0 AS QTY118, 0 AS QTY119, 0 AS QTY120
         , 0 AS QTY121, 0 AS QTY122, 0 AS QTY123, 0 AS QTY124, 0 AS QTY125, 0 AS QTY126, 0 AS QTY127, 0 AS QTY128, 0 AS QTY129, 0 AS QTY130
         , 0 AS QTY131, 0 AS QTY132, 0 AS QTY133, 0 AS QTY134, 0 AS QTY135, 0 AS QTY136, 0 AS QTY137, 0 AS QTY138, 0 AS QTY139, 0 AS QTY140
         , 0 AS QTY141, 0 AS QTY142, 0 AS QTY143, 0 AS QTY144, 0 AS QTY145, 0 AS QTY146, 0 AS QTY147, 0 AS QTY148, 0 AS QTY149, 0 AS QTY150
         , 0 AS QTY151, 0 AS QTY152, 0 AS QTY153, 0 AS QTY154, 0 AS QTY155, 0 AS QTY156, 0 AS QTY157, 0 AS QTY158, 0 AS QTY159, 0 AS QTY160
         , 0 AS QTY161, 0 AS QTY162, 0 AS QTY163, 0 AS QTY164, 0 AS QTY165, 0 AS QTY166, 0 AS QTY167, 0 AS QTY168, 0 AS QTY169, 0 AS QTY170
         , 0 AS QTY171, 0 AS QTY172, 0 AS QTY173, 0 AS QTY174, 0 AS QTY175, 0 AS QTY176, 0 AS QTY177, 0 AS QTY178, 0 AS QTY179, 0 AS QTY180
         , 0 AS QTY181, 0 AS QTY182, 0 AS QTY183, 0 AS QTY184, 0 AS QTY185, 0 AS QTY186, 0 AS QTY187, 0 AS QTY188, 0 AS QTY189, 0 AS QTY190
         , 0 AS QTY191, 0 AS QTY192, 0 AS QTY193, 0 AS QTY194, 0 AS QTY195, 0 AS QTY196, 0 AS QTY197, 0 AS QTY198, 0 AS QTY199, 0 AS QTY200
         , 0 AS QTY201, 0 AS QTY202, 0 AS QTY203, 0 AS QTY204, 0 AS QTY205, 0 AS QTY206, 0 AS QTY207, 0 AS QTY208, 0 AS QTY209, 0 AS QTY210
         , 0 AS QTY211, 0 AS QTY212, 0 AS QTY213, 0 AS QTY214, 0 AS QTY215, 0 AS QTY216, 0 AS QTY217, 0 AS QTY218, 0 AS QTY219, 0 AS QTY220
         , 0 AS QTY221, 0 AS QTY222, 0 AS QTY223, 0 AS QTY224, 0 AS QTY225, 0 AS QTY226, 0 AS QTY227, 0 AS QTY228, 0 AS QTY229, 0 AS QTY230
         , 0 AS QTY231, 0 AS QTY232, 0 AS QTY233, 0 AS QTY234, 0 AS QTY235, 0 AS QTY236, 0 AS QTY237, 0 AS QTY238, 0 AS QTY239, 0 AS QTY240
         , 0 AS QTY241, 0 AS QTY242, 0 AS QTY243, 0 AS QTY244, 0 AS QTY245, 0 AS QTY246, 0 AS QTY247, 0 AS QTY248, 0 AS QTY249, 0 AS QTY250
         , 0 AS QTY251, 0 AS QTY252, 0 AS QTY253, 0 AS QTY254, 0 AS QTY255, 0 AS QTY256, 0 AS QTY257, 0 AS QTY258, 0 AS QTY259, 0 AS QTY260
         , 0 AS QTY261, 0 AS QTY262, 0 AS QTY263, 0 AS QTY264, 0 AS QTY265, 0 AS QTY266, 0 AS QTY267, 0 AS QTY268, 0 AS QTY269, 0 AS QTY270
         , 0 AS QTY271, 0 AS QTY272, 0 AS QTY273, 0 AS QTY274, 0 AS QTY275, 0 AS QTY276, 0 AS QTY277, 0 AS QTY278, 0 AS QTY279, 0 AS QTY280
         , 0 AS QTY281, 0 AS QTY282, 0 AS QTY283, 0 AS QTY284, 0 AS QTY285, 0 AS QTY286, 0 AS QTY287, 0 AS QTY288, 0 AS QTY289, 0 AS QTY290
         , 0 AS QTY291, 0 AS QTY292, 0 AS QTY293, 0 AS QTY294, 0 AS QTY295, 0 AS QTY296, 0 AS QTY297, 0 AS QTY298, 0 AS QTY299, 0 AS QTY300
         , 0 AS QTY301, 0 AS QTY302, 0 AS QTY303, 0 AS QTY304, 0 AS QTY305, 0 AS QTY306, 0 AS QTY307, 0 AS QTY308, 0 AS QTY309, 0 AS QTY310
         , 0 AS QTY311, 0 AS QTY312, 0 AS QTY313, 0 AS QTY314, 0 AS QTY315, 0 AS QTY316, 0 AS QTY317, 0 AS QTY318, 0 AS QTY319, 0 AS QTY320
         , 0 AS QTY321, 0 AS QTY322, 0 AS QTY323, 0 AS QTY324, 0 AS QTY325, 0 AS QTY326, 0 AS QTY327, 0 AS QTY328, 0 AS QTY329, 0 AS QTY330
         , 0 AS QTY331, 0 AS QTY332, 0 AS QTY333, 0 AS QTY334, 0 AS QTY335, 0 AS QTY336, 0 AS QTY337, 0 AS QTY338, 0 AS QTY339, 0 AS QTY340
         , 0 AS QTY341, 0 AS QTY342, 0 AS QTY343, 0 AS QTY344, 0 AS QTY345, 0 AS QTY346, 0 AS QTY347, 0 AS QTY348, 0 AS QTY349, 0 AS QTY350
         , 0 AS QTY351, 0 AS QTY352, 0 AS QTY353, 0 AS QTY354, 0 AS QTY355, 0 AS QTY356, 0 AS QTY357, 0 AS QTY358, 0 AS QTY359, 0 AS QTY360
         , 0 AS QTY361, 0 AS QTY362, 0 AS QTY363, 0 AS QTY364
         , (CASE WHEN M.COLUMN_NAME = 'MKT_FCST_CELL_TOTAL' THEN 'MKT_FCST_CELL_TOTAL'
                 WHEN M.COLUMN_NAME = 'SHIP_REQ_CELL_TOTAL' THEN 'SHIP_REQ_CELL_TOTAL'
                 ELSE 'DIO' END) AS ATTRIBUTE1
         , X.ATTRIBUTE2
         , X.ATTRIBUTE3
         , X.ATTRIBUTE4
         , X.ATTRIBUTE5
         , X.ATTRIBUTE6
         , X.ATTRIBUTE7
         , X.ATTRIBUTE8
         , NULL AS ATTRIBUTE9
         , X.ATTRIBUTE10
      FROM GT_SCXL_PSI_GLOBAL_ESS X
         , GT_SCXL_MEASURE M   /* 원본 CROSS APPLY */
     WHERE 1 = 1
       AND M.GUBUN       = 'CELL_ITEM_ID'
       AND M.COLUMN_NAME NOT IN ('MKT_FCST_CELL_TOTAL','SHIP_REQ_CELL_TOTAL')
    ;

    /* 원본 L1874~L1969 : CELL_PROD 행을 근거로 CELL_WORKING_TIME MEASURE 행 생성(값은 0). */
    INSERT INTO GT_SCXL_PSI_GLOBAL_ESS
    SELECT DISTINCT X.DIVISION_ID
         , X.PLAN_START_YYYYMMDD
         , X.PLAN_TYPE
         , X.SEQ
         , X.OPERATION_GROUP
         , X.OPERATION_GROUP_NAME
         , X.CELL_ITEM_ID
         , X.ITEM_ID
         , X.NICK_NAME
         , X.CELL_QTY_PACK
         , X.TO_SITE
         , X.TO_SITE_DESCRIPTION
         , X.PROJECT_CODE
         , X.FROM_BOH_QTY
         , X.TO_BOH_QTY
         , X.INCOTERMS
         , X.FROM_SITE
         , X.FROM_SITE_DESCRIPTION
         , X.TRANSPORT_MODE
         , X.PROD_LINE
         , X.LT_DAY
         , X.BOD_ID
         , M.COLUMN_NAME AS MEASURE
         , M.COLUMN_LABEL_NAME AS MEASURE_LABEL
         , X.XLS_KEY1
         , X.XLS_KEY2
         , X.XLS_KEY3
         , X.XLS_KEY4
         , X.XLS_KEY5
         , X.XLS_ATTRIBUTE1
         , X.XLS_ATTRIBUTE2
         , X.XLS_ATTRIBUTE3
         , X.XLS_ATTRIBUTE4
         , X.XLS_ATTRIBUTE5
         , M.SORT_ORDER_NO
         , 0 AS QTY001, 0 AS QTY002, 0 AS QTY003, 0 AS QTY004, 0 AS QTY005, 0 AS QTY006, 0 AS QTY007, 0 AS QTY008, 0 AS QTY009, 0 AS QTY010
         , 0 AS QTY011, 0 AS QTY012, 0 AS QTY013, 0 AS QTY014, 0 AS QTY015, 0 AS QTY016, 0 AS QTY017, 0 AS QTY018, 0 AS QTY019, 0 AS QTY020
         , 0 AS QTY021, 0 AS QTY022, 0 AS QTY023, 0 AS QTY024, 0 AS QTY025, 0 AS QTY026, 0 AS QTY027, 0 AS QTY028, 0 AS QTY029, 0 AS QTY030
         , 0 AS QTY031, 0 AS QTY032, 0 AS QTY033, 0 AS QTY034, 0 AS QTY035, 0 AS QTY036, 0 AS QTY037, 0 AS QTY038, 0 AS QTY039, 0 AS QTY040
         , 0 AS QTY041, 0 AS QTY042, 0 AS QTY043, 0 AS QTY044, 0 AS QTY045, 0 AS QTY046, 0 AS QTY047, 0 AS QTY048, 0 AS QTY049, 0 AS QTY050
         , 0 AS QTY051, 0 AS QTY052, 0 AS QTY053, 0 AS QTY054, 0 AS QTY055, 0 AS QTY056, 0 AS QTY057, 0 AS QTY058, 0 AS QTY059, 0 AS QTY060
         , 0 AS QTY061, 0 AS QTY062, 0 AS QTY063, 0 AS QTY064, 0 AS QTY065, 0 AS QTY066, 0 AS QTY067, 0 AS QTY068, 0 AS QTY069, 0 AS QTY070
         , 0 AS QTY071, 0 AS QTY072, 0 AS QTY073, 0 AS QTY074, 0 AS QTY075, 0 AS QTY076, 0 AS QTY077, 0 AS QTY078, 0 AS QTY079, 0 AS QTY080
         , 0 AS QTY081, 0 AS QTY082, 0 AS QTY083, 0 AS QTY084, 0 AS QTY085, 0 AS QTY086, 0 AS QTY087, 0 AS QTY088, 0 AS QTY089, 0 AS QTY090
         , 0 AS QTY091, 0 AS QTY092, 0 AS QTY093, 0 AS QTY094, 0 AS QTY095, 0 AS QTY096, 0 AS QTY097, 0 AS QTY098, 0 AS QTY099, 0 AS QTY100
         , 0 AS QTY101, 0 AS QTY102, 0 AS QTY103, 0 AS QTY104, 0 AS QTY105, 0 AS QTY106, 0 AS QTY107, 0 AS QTY108, 0 AS QTY109, 0 AS QTY110
         , 0 AS QTY111, 0 AS QTY112, 0 AS QTY113, 0 AS QTY114, 0 AS QTY115, 0 AS QTY116, 0 AS QTY117, 0 AS QTY118, 0 AS QTY119, 0 AS QTY120
         , 0 AS QTY121, 0 AS QTY122, 0 AS QTY123, 0 AS QTY124, 0 AS QTY125, 0 AS QTY126, 0 AS QTY127, 0 AS QTY128, 0 AS QTY129, 0 AS QTY130
         , 0 AS QTY131, 0 AS QTY132, 0 AS QTY133, 0 AS QTY134, 0 AS QTY135, 0 AS QTY136, 0 AS QTY137, 0 AS QTY138, 0 AS QTY139, 0 AS QTY140
         , 0 AS QTY141, 0 AS QTY142, 0 AS QTY143, 0 AS QTY144, 0 AS QTY145, 0 AS QTY146, 0 AS QTY147, 0 AS QTY148, 0 AS QTY149, 0 AS QTY150
         , 0 AS QTY151, 0 AS QTY152, 0 AS QTY153, 0 AS QTY154, 0 AS QTY155, 0 AS QTY156, 0 AS QTY157, 0 AS QTY158, 0 AS QTY159, 0 AS QTY160
         , 0 AS QTY161, 0 AS QTY162, 0 AS QTY163, 0 AS QTY164, 0 AS QTY165, 0 AS QTY166, 0 AS QTY167, 0 AS QTY168, 0 AS QTY169, 0 AS QTY170
         , 0 AS QTY171, 0 AS QTY172, 0 AS QTY173, 0 AS QTY174, 0 AS QTY175, 0 AS QTY176, 0 AS QTY177, 0 AS QTY178, 0 AS QTY179, 0 AS QTY180
         , 0 AS QTY181, 0 AS QTY182, 0 AS QTY183, 0 AS QTY184, 0 AS QTY185, 0 AS QTY186, 0 AS QTY187, 0 AS QTY188, 0 AS QTY189, 0 AS QTY190
         , 0 AS QTY191, 0 AS QTY192, 0 AS QTY193, 0 AS QTY194, 0 AS QTY195, 0 AS QTY196, 0 AS QTY197, 0 AS QTY198, 0 AS QTY199, 0 AS QTY200
         , 0 AS QTY201, 0 AS QTY202, 0 AS QTY203, 0 AS QTY204, 0 AS QTY205, 0 AS QTY206, 0 AS QTY207, 0 AS QTY208, 0 AS QTY209, 0 AS QTY210
         , 0 AS QTY211, 0 AS QTY212, 0 AS QTY213, 0 AS QTY214, 0 AS QTY215, 0 AS QTY216, 0 AS QTY217, 0 AS QTY218, 0 AS QTY219, 0 AS QTY220
         , 0 AS QTY221, 0 AS QTY222, 0 AS QTY223, 0 AS QTY224, 0 AS QTY225, 0 AS QTY226, 0 AS QTY227, 0 AS QTY228, 0 AS QTY229, 0 AS QTY230
         , 0 AS QTY231, 0 AS QTY232, 0 AS QTY233, 0 AS QTY234, 0 AS QTY235, 0 AS QTY236, 0 AS QTY237, 0 AS QTY238, 0 AS QTY239, 0 AS QTY240
         , 0 AS QTY241, 0 AS QTY242, 0 AS QTY243, 0 AS QTY244, 0 AS QTY245, 0 AS QTY246, 0 AS QTY247, 0 AS QTY248, 0 AS QTY249, 0 AS QTY250
         , 0 AS QTY251, 0 AS QTY252, 0 AS QTY253, 0 AS QTY254, 0 AS QTY255, 0 AS QTY256, 0 AS QTY257, 0 AS QTY258, 0 AS QTY259, 0 AS QTY260
         , 0 AS QTY261, 0 AS QTY262, 0 AS QTY263, 0 AS QTY264, 0 AS QTY265, 0 AS QTY266, 0 AS QTY267, 0 AS QTY268, 0 AS QTY269, 0 AS QTY270
         , 0 AS QTY271, 0 AS QTY272, 0 AS QTY273, 0 AS QTY274, 0 AS QTY275, 0 AS QTY276, 0 AS QTY277, 0 AS QTY278, 0 AS QTY279, 0 AS QTY280
         , 0 AS QTY281, 0 AS QTY282, 0 AS QTY283, 0 AS QTY284, 0 AS QTY285, 0 AS QTY286, 0 AS QTY287, 0 AS QTY288, 0 AS QTY289, 0 AS QTY290
         , 0 AS QTY291, 0 AS QTY292, 0 AS QTY293, 0 AS QTY294, 0 AS QTY295, 0 AS QTY296, 0 AS QTY297, 0 AS QTY298, 0 AS QTY299, 0 AS QTY300
         , 0 AS QTY301, 0 AS QTY302, 0 AS QTY303, 0 AS QTY304, 0 AS QTY305, 0 AS QTY306, 0 AS QTY307, 0 AS QTY308, 0 AS QTY309, 0 AS QTY310
         , 0 AS QTY311, 0 AS QTY312, 0 AS QTY313, 0 AS QTY314, 0 AS QTY315, 0 AS QTY316, 0 AS QTY317, 0 AS QTY318, 0 AS QTY319, 0 AS QTY320
         , 0 AS QTY321, 0 AS QTY322, 0 AS QTY323, 0 AS QTY324, 0 AS QTY325, 0 AS QTY326, 0 AS QTY327, 0 AS QTY328, 0 AS QTY329, 0 AS QTY330
         , 0 AS QTY331, 0 AS QTY332, 0 AS QTY333, 0 AS QTY334, 0 AS QTY335, 0 AS QTY336, 0 AS QTY337, 0 AS QTY338, 0 AS QTY339, 0 AS QTY340
         , 0 AS QTY341, 0 AS QTY342, 0 AS QTY343, 0 AS QTY344, 0 AS QTY345, 0 AS QTY346, 0 AS QTY347, 0 AS QTY348, 0 AS QTY349, 0 AS QTY350
         , 0 AS QTY351, 0 AS QTY352, 0 AS QTY353, 0 AS QTY354, 0 AS QTY355, 0 AS QTY356, 0 AS QTY357, 0 AS QTY358, 0 AS QTY359, 0 AS QTY360
         , 0 AS QTY361, 0 AS QTY362, 0 AS QTY363, 0 AS QTY364
         , X.ATTRIBUTE1
         , X.ATTRIBUTE2
         , X.ATTRIBUTE3
         , X.ATTRIBUTE4
         , X.ATTRIBUTE5
         , X.ATTRIBUTE6
         , X.ATTRIBUTE7
         , X.ATTRIBUTE8
         , X.ATTRIBUTE9
         , X.ATTRIBUTE10
      FROM GT_SCXL_PSI_GLOBAL_ESS X
         , GT_SCXL_MEASURE M   /* 원본 CROSS APPLY */
     WHERE 1 = 1
       AND X.MEASURE     IN ('CELL_PROD')
       AND M.COLUMN_NAME IN ('CELL_WORKING_TIME')
       AND X.OPERATION_GROUP = 'A'
    ;

    /* -------------------------------------------------------------------------------------
       [구간6] 원본 L1974~L2456 : #WORKING_TIME 생성(UNPIVOT -> PIVOT). 구간4 와 같은 형태이나
       원천 MEASURE 가 *_WORKING_TIME 이고 값은 #LINE_WORKINGTIME_BY_LOSS 의 WORKING_TIME 이다.
       ------------------------------------------------------------------------------------- */
    DELETE
      FROM GT_SCXL_WORKING_TIME;

    INSERT INTO GT_SCXL_WORKING_TIME
    SELECT XX.DIVISION_ID, XX.OPERATION_GROUP, XX.SCM_SITE_ID, XX.PROD_LINE, XX.OPERATION_ID
         , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
         , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
         , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
         , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
         , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
         , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
         , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
         , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
         , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
         , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
         , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
         , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
         , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
         , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
         , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
         , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
         , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
         , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
         , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
         , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
         , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
         , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
         , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
         , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
         , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
         , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
         , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
         , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
         , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
         , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
         , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
         , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
         , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
         , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
         , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
         , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
         , QTY361, QTY362, QTY363, QTY364
      FROM (
            SELECT X.DIVISION_ID
                 , X.OPERATION_GROUP
                 , Z.SCM_SITE_ID
                 , X.PROD_LINE
                 , X.YYYYMMDD_COLUMN
                 , Z.OPERATION_ID
                 , Z.WORKING_TIME
              FROM ( SELECT *
                       FROM GT_SCXL_PSI_GLOBAL_ESS
                      WHERE 0 = 0
                        AND MEASURE IN ('PACK_WORKING_TIME','CELL_WORKING_TIME')
                   ) SOURCETABLE
             UNPIVOT ( QTY FOR YYYYMMDD_COLUMN IN (
                         QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010,
                         QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020,
                         QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030,
                         QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040,
                         QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050,
                         QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060,
                         QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070,
                         QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080,
                         QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090,
                         QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100,
                         QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110,
                         QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120,
                         QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130,
                         QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140,
                         QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150,
                         QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160,
                         QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170,
                         QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180,
                         QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190,
                         QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200,
                         QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210,
                         QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220,
                         QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230,
                         QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240,
                         QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250,
                         QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260,
                         QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270,
                         QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280,
                         QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290,
                         QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300,
                         QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310,
                         QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320,
                         QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330,
                         QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340,
                         QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350,
                         QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360,
                         QTY361, QTY362, QTY363, QTY364
                     ) ) X
             INNER JOIN ( SELECT A.BASIS_YYYYMMDD AS YYYYMMDD
                               , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS YYYYMMDD_COLUMN
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD >= P_CREATE_FROM_YYYYMMDD
                             AND A.BASIS_YYYYMMDD <= P_CREATE_TO_YYYYMMDD
                        ) Y
                ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
             INNER JOIN GT_SCXL_LINE_WORKTIME Z
                ON  Y.YYYYMMDD    = Z.YYYYMMDD
               AND X.PROD_LINE    = Z.LINE_ID
               AND Z.DIVISION_ID  = X.DIVISION_ID
               AND X.ATTRIBUTE9   = Z.OPERATION_ID
               AND X.FROM_SITE    = Z.SCM_SITE_ID
               AND Z.YYYYMMDD    >= P_CREATE_FROM_YYYYMMDD
               AND Z.YYYYMMDD    <= P_CREATE_TO_YYYYMMDD
           ) SOURCETABLE
     PIVOT ( MIN(WORKING_TIME) FOR YYYYMMDD_COLUMN IN (
                 'QTY001' AS QTY001, 'QTY002' AS QTY002, 'QTY003' AS QTY003, 'QTY004' AS QTY004, 'QTY005' AS QTY005, 'QTY006' AS QTY006,
                 'QTY007' AS QTY007, 'QTY008' AS QTY008, 'QTY009' AS QTY009, 'QTY010' AS QTY010, 'QTY011' AS QTY011, 'QTY012' AS QTY012,
                 'QTY013' AS QTY013, 'QTY014' AS QTY014, 'QTY015' AS QTY015, 'QTY016' AS QTY016, 'QTY017' AS QTY017, 'QTY018' AS QTY018,
                 'QTY019' AS QTY019, 'QTY020' AS QTY020, 'QTY021' AS QTY021, 'QTY022' AS QTY022, 'QTY023' AS QTY023, 'QTY024' AS QTY024,
                 'QTY025' AS QTY025, 'QTY026' AS QTY026, 'QTY027' AS QTY027, 'QTY028' AS QTY028, 'QTY029' AS QTY029, 'QTY030' AS QTY030,
                 'QTY031' AS QTY031, 'QTY032' AS QTY032, 'QTY033' AS QTY033, 'QTY034' AS QTY034, 'QTY035' AS QTY035, 'QTY036' AS QTY036,
                 'QTY037' AS QTY037, 'QTY038' AS QTY038, 'QTY039' AS QTY039, 'QTY040' AS QTY040, 'QTY041' AS QTY041, 'QTY042' AS QTY042,
                 'QTY043' AS QTY043, 'QTY044' AS QTY044, 'QTY045' AS QTY045, 'QTY046' AS QTY046, 'QTY047' AS QTY047, 'QTY048' AS QTY048,
                 'QTY049' AS QTY049, 'QTY050' AS QTY050, 'QTY051' AS QTY051, 'QTY052' AS QTY052, 'QTY053' AS QTY053, 'QTY054' AS QTY054,
                 'QTY055' AS QTY055, 'QTY056' AS QTY056, 'QTY057' AS QTY057, 'QTY058' AS QTY058, 'QTY059' AS QTY059, 'QTY060' AS QTY060,
                 'QTY061' AS QTY061, 'QTY062' AS QTY062, 'QTY063' AS QTY063, 'QTY064' AS QTY064, 'QTY065' AS QTY065, 'QTY066' AS QTY066,
                 'QTY067' AS QTY067, 'QTY068' AS QTY068, 'QTY069' AS QTY069, 'QTY070' AS QTY070, 'QTY071' AS QTY071, 'QTY072' AS QTY072,
                 'QTY073' AS QTY073, 'QTY074' AS QTY074, 'QTY075' AS QTY075, 'QTY076' AS QTY076, 'QTY077' AS QTY077, 'QTY078' AS QTY078,
                 'QTY079' AS QTY079, 'QTY080' AS QTY080, 'QTY081' AS QTY081, 'QTY082' AS QTY082, 'QTY083' AS QTY083, 'QTY084' AS QTY084,
                 'QTY085' AS QTY085, 'QTY086' AS QTY086, 'QTY087' AS QTY087, 'QTY088' AS QTY088, 'QTY089' AS QTY089, 'QTY090' AS QTY090,
                 'QTY091' AS QTY091, 'QTY092' AS QTY092, 'QTY093' AS QTY093, 'QTY094' AS QTY094, 'QTY095' AS QTY095, 'QTY096' AS QTY096,
                 'QTY097' AS QTY097, 'QTY098' AS QTY098, 'QTY099' AS QTY099, 'QTY100' AS QTY100, 'QTY101' AS QTY101, 'QTY102' AS QTY102,
                 'QTY103' AS QTY103, 'QTY104' AS QTY104, 'QTY105' AS QTY105, 'QTY106' AS QTY106, 'QTY107' AS QTY107, 'QTY108' AS QTY108,
                 'QTY109' AS QTY109, 'QTY110' AS QTY110, 'QTY111' AS QTY111, 'QTY112' AS QTY112, 'QTY113' AS QTY113, 'QTY114' AS QTY114,
                 'QTY115' AS QTY115, 'QTY116' AS QTY116, 'QTY117' AS QTY117, 'QTY118' AS QTY118, 'QTY119' AS QTY119, 'QTY120' AS QTY120,
                 'QTY121' AS QTY121, 'QTY122' AS QTY122, 'QTY123' AS QTY123, 'QTY124' AS QTY124, 'QTY125' AS QTY125, 'QTY126' AS QTY126,
                 'QTY127' AS QTY127, 'QTY128' AS QTY128, 'QTY129' AS QTY129, 'QTY130' AS QTY130, 'QTY131' AS QTY131, 'QTY132' AS QTY132,
                 'QTY133' AS QTY133, 'QTY134' AS QTY134, 'QTY135' AS QTY135, 'QTY136' AS QTY136, 'QTY137' AS QTY137, 'QTY138' AS QTY138,
                 'QTY139' AS QTY139, 'QTY140' AS QTY140, 'QTY141' AS QTY141, 'QTY142' AS QTY142, 'QTY143' AS QTY143, 'QTY144' AS QTY144,
                 'QTY145' AS QTY145, 'QTY146' AS QTY146, 'QTY147' AS QTY147, 'QTY148' AS QTY148, 'QTY149' AS QTY149, 'QTY150' AS QTY150,
                 'QTY151' AS QTY151, 'QTY152' AS QTY152, 'QTY153' AS QTY153, 'QTY154' AS QTY154, 'QTY155' AS QTY155, 'QTY156' AS QTY156,
                 'QTY157' AS QTY157, 'QTY158' AS QTY158, 'QTY159' AS QTY159, 'QTY160' AS QTY160, 'QTY161' AS QTY161, 'QTY162' AS QTY162,
                 'QTY163' AS QTY163, 'QTY164' AS QTY164, 'QTY165' AS QTY165, 'QTY166' AS QTY166, 'QTY167' AS QTY167, 'QTY168' AS QTY168,
                 'QTY169' AS QTY169, 'QTY170' AS QTY170, 'QTY171' AS QTY171, 'QTY172' AS QTY172, 'QTY173' AS QTY173, 'QTY174' AS QTY174,
                 'QTY175' AS QTY175, 'QTY176' AS QTY176, 'QTY177' AS QTY177, 'QTY178' AS QTY178, 'QTY179' AS QTY179, 'QTY180' AS QTY180,
                 'QTY181' AS QTY181, 'QTY182' AS QTY182, 'QTY183' AS QTY183, 'QTY184' AS QTY184, 'QTY185' AS QTY185, 'QTY186' AS QTY186,
                 'QTY187' AS QTY187, 'QTY188' AS QTY188, 'QTY189' AS QTY189, 'QTY190' AS QTY190, 'QTY191' AS QTY191, 'QTY192' AS QTY192,
                 'QTY193' AS QTY193, 'QTY194' AS QTY194, 'QTY195' AS QTY195, 'QTY196' AS QTY196, 'QTY197' AS QTY197, 'QTY198' AS QTY198,
                 'QTY199' AS QTY199, 'QTY200' AS QTY200, 'QTY201' AS QTY201, 'QTY202' AS QTY202, 'QTY203' AS QTY203, 'QTY204' AS QTY204,
                 'QTY205' AS QTY205, 'QTY206' AS QTY206, 'QTY207' AS QTY207, 'QTY208' AS QTY208, 'QTY209' AS QTY209, 'QTY210' AS QTY210,
                 'QTY211' AS QTY211, 'QTY212' AS QTY212, 'QTY213' AS QTY213, 'QTY214' AS QTY214, 'QTY215' AS QTY215, 'QTY216' AS QTY216,
                 'QTY217' AS QTY217, 'QTY218' AS QTY218, 'QTY219' AS QTY219, 'QTY220' AS QTY220, 'QTY221' AS QTY221, 'QTY222' AS QTY222,
                 'QTY223' AS QTY223, 'QTY224' AS QTY224, 'QTY225' AS QTY225, 'QTY226' AS QTY226, 'QTY227' AS QTY227, 'QTY228' AS QTY228,
                 'QTY229' AS QTY229, 'QTY230' AS QTY230, 'QTY231' AS QTY231, 'QTY232' AS QTY232, 'QTY233' AS QTY233, 'QTY234' AS QTY234,
                 'QTY235' AS QTY235, 'QTY236' AS QTY236, 'QTY237' AS QTY237, 'QTY238' AS QTY238, 'QTY239' AS QTY239, 'QTY240' AS QTY240,
                 'QTY241' AS QTY241, 'QTY242' AS QTY242, 'QTY243' AS QTY243, 'QTY244' AS QTY244, 'QTY245' AS QTY245, 'QTY246' AS QTY246,
                 'QTY247' AS QTY247, 'QTY248' AS QTY248, 'QTY249' AS QTY249, 'QTY250' AS QTY250, 'QTY251' AS QTY251, 'QTY252' AS QTY252,
                 'QTY253' AS QTY253, 'QTY254' AS QTY254, 'QTY255' AS QTY255, 'QTY256' AS QTY256, 'QTY257' AS QTY257, 'QTY258' AS QTY258,
                 'QTY259' AS QTY259, 'QTY260' AS QTY260, 'QTY261' AS QTY261, 'QTY262' AS QTY262, 'QTY263' AS QTY263, 'QTY264' AS QTY264,
                 'QTY265' AS QTY265, 'QTY266' AS QTY266, 'QTY267' AS QTY267, 'QTY268' AS QTY268, 'QTY269' AS QTY269, 'QTY270' AS QTY270,
                 'QTY271' AS QTY271, 'QTY272' AS QTY272, 'QTY273' AS QTY273, 'QTY274' AS QTY274, 'QTY275' AS QTY275, 'QTY276' AS QTY276,
                 'QTY277' AS QTY277, 'QTY278' AS QTY278, 'QTY279' AS QTY279, 'QTY280' AS QTY280, 'QTY281' AS QTY281, 'QTY282' AS QTY282,
                 'QTY283' AS QTY283, 'QTY284' AS QTY284, 'QTY285' AS QTY285, 'QTY286' AS QTY286, 'QTY287' AS QTY287, 'QTY288' AS QTY288,
                 'QTY289' AS QTY289, 'QTY290' AS QTY290, 'QTY291' AS QTY291, 'QTY292' AS QTY292, 'QTY293' AS QTY293, 'QTY294' AS QTY294,
                 'QTY295' AS QTY295, 'QTY296' AS QTY296, 'QTY297' AS QTY297, 'QTY298' AS QTY298, 'QTY299' AS QTY299, 'QTY300' AS QTY300,
                 'QTY301' AS QTY301, 'QTY302' AS QTY302, 'QTY303' AS QTY303, 'QTY304' AS QTY304, 'QTY305' AS QTY305, 'QTY306' AS QTY306,
                 'QTY307' AS QTY307, 'QTY308' AS QTY308, 'QTY309' AS QTY309, 'QTY310' AS QTY310, 'QTY311' AS QTY311, 'QTY312' AS QTY312,
                 'QTY313' AS QTY313, 'QTY314' AS QTY314, 'QTY315' AS QTY315, 'QTY316' AS QTY316, 'QTY317' AS QTY317, 'QTY318' AS QTY318,
                 'QTY319' AS QTY319, 'QTY320' AS QTY320, 'QTY321' AS QTY321, 'QTY322' AS QTY322, 'QTY323' AS QTY323, 'QTY324' AS QTY324,
                 'QTY325' AS QTY325, 'QTY326' AS QTY326, 'QTY327' AS QTY327, 'QTY328' AS QTY328, 'QTY329' AS QTY329, 'QTY330' AS QTY330,
                 'QTY331' AS QTY331, 'QTY332' AS QTY332, 'QTY333' AS QTY333, 'QTY334' AS QTY334, 'QTY335' AS QTY335, 'QTY336' AS QTY336,
                 'QTY337' AS QTY337, 'QTY338' AS QTY338, 'QTY339' AS QTY339, 'QTY340' AS QTY340, 'QTY341' AS QTY341, 'QTY342' AS QTY342,
                 'QTY343' AS QTY343, 'QTY344' AS QTY344, 'QTY345' AS QTY345, 'QTY346' AS QTY346, 'QTY347' AS QTY347, 'QTY348' AS QTY348,
                 'QTY349' AS QTY349, 'QTY350' AS QTY350, 'QTY351' AS QTY351, 'QTY352' AS QTY352, 'QTY353' AS QTY353, 'QTY354' AS QTY354,
                 'QTY355' AS QTY355, 'QTY356' AS QTY356, 'QTY357' AS QTY357, 'QTY358' AS QTY358, 'QTY359' AS QTY359, 'QTY360' AS QTY360,
                 'QTY361' AS QTY361, 'QTY362' AS QTY362, 'QTY363' AS QTY363, 'QTY364' AS QTY364
           ) ) XX
    ;

    /* 원본 L2150~L2210 : UPDATE .. FROM JOIN -> MERGE (SOP §3.3). WORKING_TIME 값 반영 */
    MERGE INTO GT_SCXL_PSI_GLOBAL_ESS X
    USING GT_SCXL_WORKING_TIME Y
       ON (    Y.DIVISION_ID     = X.DIVISION_ID
           AND Y.OPERATION_GROUP = X.OPERATION_GROUP
           AND Y.SCM_SITE_ID     = X.FROM_SITE
           AND Y.PROD_LINE       = X.PROD_LINE
           AND Y.OPERATION_ID    = X.ATTRIBUTE9
           AND X.MEASURE         IN ('PACK_WORKING_TIME','CELL_WORKING_TIME') )
     WHEN MATCHED THEN UPDATE
        SET X.QTY001 = NVL(Y.QTY001, 0), X.QTY002 = NVL(Y.QTY002, 0), X.QTY003 = NVL(Y.QTY003, 0), X.QTY004 = NVL(Y.QTY004, 0)
          , X.QTY005 = NVL(Y.QTY005, 0), X.QTY006 = NVL(Y.QTY006, 0), X.QTY007 = NVL(Y.QTY007, 0), X.QTY008 = NVL(Y.QTY008, 0)
          , X.QTY009 = NVL(Y.QTY009, 0), X.QTY010 = NVL(Y.QTY010, 0), X.QTY011 = NVL(Y.QTY011, 0), X.QTY012 = NVL(Y.QTY012, 0)
          , X.QTY013 = NVL(Y.QTY013, 0), X.QTY014 = NVL(Y.QTY014, 0), X.QTY015 = NVL(Y.QTY015, 0), X.QTY016 = NVL(Y.QTY016, 0)
          , X.QTY017 = NVL(Y.QTY017, 0), X.QTY018 = NVL(Y.QTY018, 0), X.QTY019 = NVL(Y.QTY019, 0), X.QTY020 = NVL(Y.QTY020, 0)
          , X.QTY021 = NVL(Y.QTY021, 0), X.QTY022 = NVL(Y.QTY022, 0), X.QTY023 = NVL(Y.QTY023, 0), X.QTY024 = NVL(Y.QTY024, 0)
          , X.QTY025 = NVL(Y.QTY025, 0), X.QTY026 = NVL(Y.QTY026, 0), X.QTY027 = NVL(Y.QTY027, 0), X.QTY028 = NVL(Y.QTY028, 0)
          , X.QTY029 = NVL(Y.QTY029, 0), X.QTY030 = NVL(Y.QTY030, 0), X.QTY031 = NVL(Y.QTY031, 0), X.QTY032 = NVL(Y.QTY032, 0)
          , X.QTY033 = NVL(Y.QTY033, 0), X.QTY034 = NVL(Y.QTY034, 0), X.QTY035 = NVL(Y.QTY035, 0), X.QTY036 = NVL(Y.QTY036, 0)
          , X.QTY037 = NVL(Y.QTY037, 0), X.QTY038 = NVL(Y.QTY038, 0), X.QTY039 = NVL(Y.QTY039, 0), X.QTY040 = NVL(Y.QTY040, 0)
          , X.QTY041 = NVL(Y.QTY041, 0), X.QTY042 = NVL(Y.QTY042, 0), X.QTY043 = NVL(Y.QTY043, 0), X.QTY044 = NVL(Y.QTY044, 0)
          , X.QTY045 = NVL(Y.QTY045, 0), X.QTY046 = NVL(Y.QTY046, 0), X.QTY047 = NVL(Y.QTY047, 0), X.QTY048 = NVL(Y.QTY048, 0)
          , X.QTY049 = NVL(Y.QTY049, 0), X.QTY050 = NVL(Y.QTY050, 0), X.QTY051 = NVL(Y.QTY051, 0), X.QTY052 = NVL(Y.QTY052, 0)
          , X.QTY053 = NVL(Y.QTY053, 0), X.QTY054 = NVL(Y.QTY054, 0), X.QTY055 = NVL(Y.QTY055, 0), X.QTY056 = NVL(Y.QTY056, 0)
          , X.QTY057 = NVL(Y.QTY057, 0), X.QTY058 = NVL(Y.QTY058, 0), X.QTY059 = NVL(Y.QTY059, 0), X.QTY060 = NVL(Y.QTY060, 0)
          , X.QTY061 = NVL(Y.QTY061, 0), X.QTY062 = NVL(Y.QTY062, 0), X.QTY063 = NVL(Y.QTY063, 0), X.QTY064 = NVL(Y.QTY064, 0)
          , X.QTY065 = NVL(Y.QTY065, 0), X.QTY066 = NVL(Y.QTY066, 0), X.QTY067 = NVL(Y.QTY067, 0), X.QTY068 = NVL(Y.QTY068, 0)
          , X.QTY069 = NVL(Y.QTY069, 0), X.QTY070 = NVL(Y.QTY070, 0), X.QTY071 = NVL(Y.QTY071, 0), X.QTY072 = NVL(Y.QTY072, 0)
          , X.QTY073 = NVL(Y.QTY073, 0), X.QTY074 = NVL(Y.QTY074, 0), X.QTY075 = NVL(Y.QTY075, 0), X.QTY076 = NVL(Y.QTY076, 0)
          , X.QTY077 = NVL(Y.QTY077, 0), X.QTY078 = NVL(Y.QTY078, 0), X.QTY079 = NVL(Y.QTY079, 0), X.QTY080 = NVL(Y.QTY080, 0)
          , X.QTY081 = NVL(Y.QTY081, 0), X.QTY082 = NVL(Y.QTY082, 0), X.QTY083 = NVL(Y.QTY083, 0), X.QTY084 = NVL(Y.QTY084, 0)
          , X.QTY085 = NVL(Y.QTY085, 0), X.QTY086 = NVL(Y.QTY086, 0), X.QTY087 = NVL(Y.QTY087, 0), X.QTY088 = NVL(Y.QTY088, 0)
          , X.QTY089 = NVL(Y.QTY089, 0), X.QTY090 = NVL(Y.QTY090, 0), X.QTY091 = NVL(Y.QTY091, 0), X.QTY092 = NVL(Y.QTY092, 0)
          , X.QTY093 = NVL(Y.QTY093, 0), X.QTY094 = NVL(Y.QTY094, 0), X.QTY095 = NVL(Y.QTY095, 0), X.QTY096 = NVL(Y.QTY096, 0)
          , X.QTY097 = NVL(Y.QTY097, 0), X.QTY098 = NVL(Y.QTY098, 0), X.QTY099 = NVL(Y.QTY099, 0), X.QTY100 = NVL(Y.QTY100, 0)
          , X.QTY101 = NVL(Y.QTY101, 0), X.QTY102 = NVL(Y.QTY102, 0), X.QTY103 = NVL(Y.QTY103, 0), X.QTY104 = NVL(Y.QTY104, 0)
          , X.QTY105 = NVL(Y.QTY105, 0), X.QTY106 = NVL(Y.QTY106, 0), X.QTY107 = NVL(Y.QTY107, 0), X.QTY108 = NVL(Y.QTY108, 0)
          , X.QTY109 = NVL(Y.QTY109, 0), X.QTY110 = NVL(Y.QTY110, 0), X.QTY111 = NVL(Y.QTY111, 0), X.QTY112 = NVL(Y.QTY112, 0)
          , X.QTY113 = NVL(Y.QTY113, 0), X.QTY114 = NVL(Y.QTY114, 0), X.QTY115 = NVL(Y.QTY115, 0), X.QTY116 = NVL(Y.QTY116, 0)
          , X.QTY117 = NVL(Y.QTY117, 0), X.QTY118 = NVL(Y.QTY118, 0), X.QTY119 = NVL(Y.QTY119, 0), X.QTY120 = NVL(Y.QTY120, 0)
          , X.QTY121 = NVL(Y.QTY121, 0), X.QTY122 = NVL(Y.QTY122, 0), X.QTY123 = NVL(Y.QTY123, 0), X.QTY124 = NVL(Y.QTY124, 0)
          , X.QTY125 = NVL(Y.QTY125, 0), X.QTY126 = NVL(Y.QTY126, 0), X.QTY127 = NVL(Y.QTY127, 0), X.QTY128 = NVL(Y.QTY128, 0)
          , X.QTY129 = NVL(Y.QTY129, 0), X.QTY130 = NVL(Y.QTY130, 0), X.QTY131 = NVL(Y.QTY131, 0), X.QTY132 = NVL(Y.QTY132, 0)
          , X.QTY133 = NVL(Y.QTY133, 0), X.QTY134 = NVL(Y.QTY134, 0), X.QTY135 = NVL(Y.QTY135, 0), X.QTY136 = NVL(Y.QTY136, 0)
          , X.QTY137 = NVL(Y.QTY137, 0), X.QTY138 = NVL(Y.QTY138, 0), X.QTY139 = NVL(Y.QTY139, 0), X.QTY140 = NVL(Y.QTY140, 0)
          , X.QTY141 = NVL(Y.QTY141, 0), X.QTY142 = NVL(Y.QTY142, 0), X.QTY143 = NVL(Y.QTY143, 0), X.QTY144 = NVL(Y.QTY144, 0)
          , X.QTY145 = NVL(Y.QTY145, 0), X.QTY146 = NVL(Y.QTY146, 0), X.QTY147 = NVL(Y.QTY147, 0), X.QTY148 = NVL(Y.QTY148, 0)
          , X.QTY149 = NVL(Y.QTY149, 0), X.QTY150 = NVL(Y.QTY150, 0), X.QTY151 = NVL(Y.QTY151, 0), X.QTY152 = NVL(Y.QTY152, 0)
          , X.QTY153 = NVL(Y.QTY153, 0), X.QTY154 = NVL(Y.QTY154, 0), X.QTY155 = NVL(Y.QTY155, 0), X.QTY156 = NVL(Y.QTY156, 0)
          , X.QTY157 = NVL(Y.QTY157, 0), X.QTY158 = NVL(Y.QTY158, 0), X.QTY159 = NVL(Y.QTY159, 0), X.QTY160 = NVL(Y.QTY160, 0)
          , X.QTY161 = NVL(Y.QTY161, 0), X.QTY162 = NVL(Y.QTY162, 0), X.QTY163 = NVL(Y.QTY163, 0), X.QTY164 = NVL(Y.QTY164, 0)
          , X.QTY165 = NVL(Y.QTY165, 0), X.QTY166 = NVL(Y.QTY166, 0), X.QTY167 = NVL(Y.QTY167, 0), X.QTY168 = NVL(Y.QTY168, 0)
          , X.QTY169 = NVL(Y.QTY169, 0), X.QTY170 = NVL(Y.QTY170, 0), X.QTY171 = NVL(Y.QTY171, 0), X.QTY172 = NVL(Y.QTY172, 0)
          , X.QTY173 = NVL(Y.QTY173, 0), X.QTY174 = NVL(Y.QTY174, 0), X.QTY175 = NVL(Y.QTY175, 0), X.QTY176 = NVL(Y.QTY176, 0)
          , X.QTY177 = NVL(Y.QTY177, 0), X.QTY178 = NVL(Y.QTY178, 0), X.QTY179 = NVL(Y.QTY179, 0), X.QTY180 = NVL(Y.QTY180, 0)
          , X.QTY181 = NVL(Y.QTY181, 0), X.QTY182 = NVL(Y.QTY182, 0), X.QTY183 = NVL(Y.QTY183, 0), X.QTY184 = NVL(Y.QTY184, 0)
          , X.QTY185 = NVL(Y.QTY185, 0), X.QTY186 = NVL(Y.QTY186, 0), X.QTY187 = NVL(Y.QTY187, 0), X.QTY188 = NVL(Y.QTY188, 0)
          , X.QTY189 = NVL(Y.QTY189, 0), X.QTY190 = NVL(Y.QTY190, 0), X.QTY191 = NVL(Y.QTY191, 0), X.QTY192 = NVL(Y.QTY192, 0)
          , X.QTY193 = NVL(Y.QTY193, 0), X.QTY194 = NVL(Y.QTY194, 0), X.QTY195 = NVL(Y.QTY195, 0), X.QTY196 = NVL(Y.QTY196, 0)
          , X.QTY197 = NVL(Y.QTY197, 0), X.QTY198 = NVL(Y.QTY198, 0), X.QTY199 = NVL(Y.QTY199, 0), X.QTY200 = NVL(Y.QTY200, 0)
          , X.QTY201 = NVL(Y.QTY201, 0), X.QTY202 = NVL(Y.QTY202, 0), X.QTY203 = NVL(Y.QTY203, 0), X.QTY204 = NVL(Y.QTY204, 0)
          , X.QTY205 = NVL(Y.QTY205, 0), X.QTY206 = NVL(Y.QTY206, 0), X.QTY207 = NVL(Y.QTY207, 0), X.QTY208 = NVL(Y.QTY208, 0)
          , X.QTY209 = NVL(Y.QTY209, 0), X.QTY210 = NVL(Y.QTY210, 0), X.QTY211 = NVL(Y.QTY211, 0), X.QTY212 = NVL(Y.QTY212, 0)
          , X.QTY213 = NVL(Y.QTY213, 0), X.QTY214 = NVL(Y.QTY214, 0), X.QTY215 = NVL(Y.QTY215, 0), X.QTY216 = NVL(Y.QTY216, 0)
          , X.QTY217 = NVL(Y.QTY217, 0), X.QTY218 = NVL(Y.QTY218, 0), X.QTY219 = NVL(Y.QTY219, 0), X.QTY220 = NVL(Y.QTY220, 0)
          , X.QTY221 = NVL(Y.QTY221, 0), X.QTY222 = NVL(Y.QTY222, 0), X.QTY223 = NVL(Y.QTY223, 0), X.QTY224 = NVL(Y.QTY224, 0)
          , X.QTY225 = NVL(Y.QTY225, 0), X.QTY226 = NVL(Y.QTY226, 0), X.QTY227 = NVL(Y.QTY227, 0), X.QTY228 = NVL(Y.QTY228, 0)
          , X.QTY229 = NVL(Y.QTY229, 0), X.QTY230 = NVL(Y.QTY230, 0), X.QTY231 = NVL(Y.QTY231, 0), X.QTY232 = NVL(Y.QTY232, 0)
          , X.QTY233 = NVL(Y.QTY233, 0), X.QTY234 = NVL(Y.QTY234, 0), X.QTY235 = NVL(Y.QTY235, 0), X.QTY236 = NVL(Y.QTY236, 0)
          , X.QTY237 = NVL(Y.QTY237, 0), X.QTY238 = NVL(Y.QTY238, 0), X.QTY239 = NVL(Y.QTY239, 0), X.QTY240 = NVL(Y.QTY240, 0)
          , X.QTY241 = NVL(Y.QTY241, 0), X.QTY242 = NVL(Y.QTY242, 0), X.QTY243 = NVL(Y.QTY243, 0), X.QTY244 = NVL(Y.QTY244, 0)
          , X.QTY245 = NVL(Y.QTY245, 0), X.QTY246 = NVL(Y.QTY246, 0), X.QTY247 = NVL(Y.QTY247, 0), X.QTY248 = NVL(Y.QTY248, 0)
          , X.QTY249 = NVL(Y.QTY249, 0), X.QTY250 = NVL(Y.QTY250, 0), X.QTY251 = NVL(Y.QTY251, 0), X.QTY252 = NVL(Y.QTY252, 0)
          , X.QTY253 = NVL(Y.QTY253, 0), X.QTY254 = NVL(Y.QTY254, 0), X.QTY255 = NVL(Y.QTY255, 0), X.QTY256 = NVL(Y.QTY256, 0)
          , X.QTY257 = NVL(Y.QTY257, 0), X.QTY258 = NVL(Y.QTY258, 0), X.QTY259 = NVL(Y.QTY259, 0), X.QTY260 = NVL(Y.QTY260, 0)
          , X.QTY261 = NVL(Y.QTY261, 0), X.QTY262 = NVL(Y.QTY262, 0), X.QTY263 = NVL(Y.QTY263, 0), X.QTY264 = NVL(Y.QTY264, 0)
          , X.QTY265 = NVL(Y.QTY265, 0), X.QTY266 = NVL(Y.QTY266, 0), X.QTY267 = NVL(Y.QTY267, 0), X.QTY268 = NVL(Y.QTY268, 0)
          , X.QTY269 = NVL(Y.QTY269, 0), X.QTY270 = NVL(Y.QTY270, 0), X.QTY271 = NVL(Y.QTY271, 0), X.QTY272 = NVL(Y.QTY272, 0)
          , X.QTY273 = NVL(Y.QTY273, 0), X.QTY274 = NVL(Y.QTY274, 0), X.QTY275 = NVL(Y.QTY275, 0), X.QTY276 = NVL(Y.QTY276, 0)
          , X.QTY277 = NVL(Y.QTY277, 0), X.QTY278 = NVL(Y.QTY278, 0), X.QTY279 = NVL(Y.QTY279, 0), X.QTY280 = NVL(Y.QTY280, 0)
          , X.QTY281 = NVL(Y.QTY281, 0), X.QTY282 = NVL(Y.QTY282, 0), X.QTY283 = NVL(Y.QTY283, 0), X.QTY284 = NVL(Y.QTY284, 0)
          , X.QTY285 = NVL(Y.QTY285, 0), X.QTY286 = NVL(Y.QTY286, 0), X.QTY287 = NVL(Y.QTY287, 0), X.QTY288 = NVL(Y.QTY288, 0)
          , X.QTY289 = NVL(Y.QTY289, 0), X.QTY290 = NVL(Y.QTY290, 0), X.QTY291 = NVL(Y.QTY291, 0), X.QTY292 = NVL(Y.QTY292, 0)
          , X.QTY293 = NVL(Y.QTY293, 0), X.QTY294 = NVL(Y.QTY294, 0), X.QTY295 = NVL(Y.QTY295, 0), X.QTY296 = NVL(Y.QTY296, 0)
          , X.QTY297 = NVL(Y.QTY297, 0), X.QTY298 = NVL(Y.QTY298, 0), X.QTY299 = NVL(Y.QTY299, 0), X.QTY300 = NVL(Y.QTY300, 0)
          , X.QTY301 = NVL(Y.QTY301, 0), X.QTY302 = NVL(Y.QTY302, 0), X.QTY303 = NVL(Y.QTY303, 0), X.QTY304 = NVL(Y.QTY304, 0)
          , X.QTY305 = NVL(Y.QTY305, 0), X.QTY306 = NVL(Y.QTY306, 0), X.QTY307 = NVL(Y.QTY307, 0), X.QTY308 = NVL(Y.QTY308, 0)
          , X.QTY309 = NVL(Y.QTY309, 0), X.QTY310 = NVL(Y.QTY310, 0), X.QTY311 = NVL(Y.QTY311, 0), X.QTY312 = NVL(Y.QTY312, 0)
          , X.QTY313 = NVL(Y.QTY313, 0), X.QTY314 = NVL(Y.QTY314, 0), X.QTY315 = NVL(Y.QTY315, 0), X.QTY316 = NVL(Y.QTY316, 0)
          , X.QTY317 = NVL(Y.QTY317, 0), X.QTY318 = NVL(Y.QTY318, 0), X.QTY319 = NVL(Y.QTY319, 0), X.QTY320 = NVL(Y.QTY320, 0)
          , X.QTY321 = NVL(Y.QTY321, 0), X.QTY322 = NVL(Y.QTY322, 0), X.QTY323 = NVL(Y.QTY323, 0), X.QTY324 = NVL(Y.QTY324, 0)
          , X.QTY325 = NVL(Y.QTY325, 0), X.QTY326 = NVL(Y.QTY326, 0), X.QTY327 = NVL(Y.QTY327, 0), X.QTY328 = NVL(Y.QTY328, 0)
          , X.QTY329 = NVL(Y.QTY329, 0), X.QTY330 = NVL(Y.QTY330, 0), X.QTY331 = NVL(Y.QTY331, 0), X.QTY332 = NVL(Y.QTY332, 0)
          , X.QTY333 = NVL(Y.QTY333, 0), X.QTY334 = NVL(Y.QTY334, 0), X.QTY335 = NVL(Y.QTY335, 0), X.QTY336 = NVL(Y.QTY336, 0)
          , X.QTY337 = NVL(Y.QTY337, 0), X.QTY338 = NVL(Y.QTY338, 0), X.QTY339 = NVL(Y.QTY339, 0), X.QTY340 = NVL(Y.QTY340, 0)
          , X.QTY341 = NVL(Y.QTY341, 0), X.QTY342 = NVL(Y.QTY342, 0), X.QTY343 = NVL(Y.QTY343, 0), X.QTY344 = NVL(Y.QTY344, 0)
          , X.QTY345 = NVL(Y.QTY345, 0), X.QTY346 = NVL(Y.QTY346, 0), X.QTY347 = NVL(Y.QTY347, 0), X.QTY348 = NVL(Y.QTY348, 0)
          , X.QTY349 = NVL(Y.QTY349, 0), X.QTY350 = NVL(Y.QTY350, 0), X.QTY351 = NVL(Y.QTY351, 0), X.QTY352 = NVL(Y.QTY352, 0)
          , X.QTY353 = NVL(Y.QTY353, 0), X.QTY354 = NVL(Y.QTY354, 0), X.QTY355 = NVL(Y.QTY355, 0), X.QTY356 = NVL(Y.QTY356, 0)
          , X.QTY357 = NVL(Y.QTY357, 0), X.QTY358 = NVL(Y.QTY358, 0), X.QTY359 = NVL(Y.QTY359, 0), X.QTY360 = NVL(Y.QTY360, 0)
          , X.QTY361 = NVL(Y.QTY361, 0), X.QTY362 = NVL(Y.QTY362, 0), X.QTY363 = NVL(Y.QTY363, 0), X.QTY364 = NVL(Y.QTY364, 0)
    ;

    /* 원본 L2215~L2218 : 단일 테이블 UPDATE 라 그대로 UPDATE 로 옮긴다(FROM 절 불필요) */
    UPDATE GT_SCXL_PSI_GLOBAL_ESS
       SET LT_DAY = 0
     WHERE TRANSPORT_MODE = '-'
    ;

    /* 원본 L2229~L2280 : SEMI_PACK_PROD_CELL MEASURE 행 생성(컬럼 지정 INSERT) */
    INSERT INTO GT_SCXL_PSI_GLOBAL_ESS
         ( PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ
         , DIVISION_ID, XLS_KEY1, OPERATION_GROUP, OPERATION_GROUP_NAME
         , CELL_ITEM_ID, ITEM_ID, NICK_NAME, ATTRIBUTE9
         , TO_SITE, TO_SITE_DESCRIPTION, FROM_SITE, FROM_SITE_DESCRIPTION
         , PROJECT_CODE, FROM_BOH_QTY, TO_BOH_QTY, INCOTERMS, CELL_QTY_PACK
         , TRANSPORT_MODE, PROD_LINE, LT_DAY, BOD_ID
         , MEASURE, MEASURE_LABEL, SORT_ORDER_NO
           /* 원본 L2237~L2238 주석 보존 : CREATE_FROM_YYYYMMDD/CREATE_TO_YYYYMMDD, CREATED_BY 등 */
         )
    SELECT P_PLAN_START_YYYYMMDD, P_PLAN_TYPE, P_SEQ
         , DIVISION_ID
         , 1 AS XLS_KEY1
         , 'A' AS OPERATION_GROUP
         , (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL X2 WHERE X2.LOOKUP_TYPE = 'OPERATION_GROUP' AND X2.SEGMENT1 = 'A' AND ROWNUM = 1) AS OPERATION_GROUP_NAME
         , CELL_ITEM_ID
         , X.CELL_ITEM_ID AS ITEM_ID
         , (SELECT M.NICK_NAME FROM SCM_MST_ITEM_SN M WHERE M.ITEM_ID = X.CELL_ITEM_ID AND M.DIVISION_ID = X.DIVISION_ID AND ROWNUM = 1) AS NICK_NAME
         , 'F6000' AS OPERATION_ID
         , X.FROM_SITE AS TO_SITE
         , (SELECT M.SITE_DESCRIPTION FROM SCM_MST_SITE M WHERE M.SCM_SITE_ID = X.FROM_SITE AND ROWNUM = 1)
         , '-' FROM_SITE
         , '-'
         , '-', 0, 0, '-', 0   /* PROJECT_CODE, FROM_BOH_QTY, TO_BOH_QTY, INCOTERMS, CELL_QTY_PACK */
         , '-', '-', 0, '-'    /* TRANSPORT_MODE, PROD_LINE, LT_DAY, BOD_ID */
         , 'SEMI_PACK_PROD_CELL' AS MEASURE
         , M.COLUMN_LABEL_NAME  AS MEASURE_LABEL
         , M.SORT_ORDER_NO
      FROM GT_SCXL_PSI_GLOBAL_ESS X
      LEFT JOIN ( SELECT COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO
                    FROM SCM_MST_SHEET_MEASURE M2
                   WHERE COLUMN_NAME = 'SEMI_PACK_PROD_CELL'
                     AND ROWNUM = 1 ) M
        ON M.COLUMN_NAME = 'SEMI_PACK_PROD_CELL'
     WHERE 1 = 1
       AND X.MEASURE = 'PACK_PROD'
       AND CELL_ITEM_ID IS NOT NULL
       AND NOT EXISTS ( SELECT 1 FROM GT_SCXL_PSI_GLOBAL_ESS S
                         WHERE MEASURE = 'SEMI_PACK_PROD_CELL'
                           AND S.ITEM_ID = X.CELL_ITEM_ID )
     GROUP BY DIVISION_ID, CELL_ITEM_ID, X.CELL_ITEM_ID, X.FROM_SITE
            , M.COLUMN_LABEL_NAME, M.SORT_ORDER_NO
    ;

    /* -------------------------------------------------------------------------------------
       [구간7] 원본 L2285~L2641
       (1) GTT -> 실테이블 SCP_XLS_PSI_GLOBAL_ESS 적재(XLS_KEY1 = 화면 정렬순서 채번)
       (2) YIELD 보정 UPDATE 2건 -> MERGE (SOP §3.3)
       (3) #..._MODEL_INVENTORY 생성 후 QTY001 = 기초재고 반영
       ------------------------------------------------------------------------------------- */
    INSERT INTO SCP_XLS_PSI_GLOBAL_ESS
         ( DIVISION_ID
         , PLAN_START_YYYYMMDD
         , CREATE_FROM_YYYYMMDD
         , CREATE_TO_YYYYMMDD
         , PLAN_TYPE, SEQ
         , OPERATION_GROUP, OPERATION_GROUP_NAME, CELL_ITEM_ID, ITEM_ID, NICK_NAME, CELL_QTY_PACK, TO_SITE, TO_SITE_DESCRIPTION
         , PROJECT_CODE
         , FROM_BOH_QTY, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_SITE_DESCRIPTION
         , TRANSPORT_MODE, PROD_LINE
         , LT_DAY
         , BOD_ID, MEASURE, MEASURE_LABEL
         , XLS_KEY1
         , XLS_KEY2, XLS_KEY3, XLS_KEY4, XLS_KEY5
         , XLS_ATTRIBUTE1, XLS_ATTRIBUTE2, XLS_ATTRIBUTE3, XLS_ATTRIBUTE4, XLS_ATTRIBUTE5
         , SORT_ORDER_NO
         , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
, QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
, QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
, QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
, QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
, QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
, QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
, QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
, QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
, QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
, QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
, QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
, QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
, QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
, QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
, QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
, QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
, QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
, QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
, QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
, QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
, QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
, QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
, QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
, QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
, QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
, QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
, QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
, QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
, QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
, QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
, QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
, QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
, QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
, QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
, QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
, QTY361, QTY362, QTY363, QTY364
         , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
         , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
         )
    SELECT DIVISION_ID
         , PLAN_START_YYYYMMDD
         , P_CREATE_FROM_YYYYMMDD
         , P_CREATE_TO_YYYYMMDD
         , PLAN_TYPE, SEQ
         , OPERATION_GROUP, OPERATION_GROUP_NAME, CELL_ITEM_ID, ITEM_ID, NICK_NAME, CELL_QTY_PACK, TO_SITE, TO_SITE_DESCRIPTION
           /* 원본 LEN(x)=0 -> Oracle 은 빈문자=NULL 이므로 LENGTH 가 NULL 이 된다. NVL 로 0 처리해 등가 유지 */
         , (CASE WHEN NVL(LENGTH(PROJECT_CODE), 0) = 0 THEN '-' ELSE PROJECT_CODE END) AS PROJECT_CODE
         , FROM_BOH_QTY, TO_BOH_QTY, INCOTERMS, FROM_SITE, FROM_SITE_DESCRIPTION
         , TRANSPORT_MODE, PROD_LINE
         , LT_DAY
         , BOD_ID, MEASURE, MEASURE_LABEL
           /* ★XLS_KEY1 = 화면 정렬순서 채번(원본 주석 "정렬순서임에 유의(KSK)"). ORDER BY 순서를 그대로 보존한다. */
         , ROW_NUMBER() OVER(ORDER BY DIVISION_ID
                                    , OPERATION_GROUP DESC
                                    , CELL_ITEM_ID
                                      /* 동일한 CELL ITEM ID 인경우 CELL 공정에서는 CP 해당 품목을 위에 표시 */
                                    , CASE WHEN OPERATION_GROUP = 'P' THEN '0'
                                           WHEN OPERATION_GROUP = 'A' THEN FN_GET_FINAL_ITEM(DIVISION_ID, ITEM_ID, 'CELL_SORT')
                                           ELSE '9' END
                                    , (CASE WHEN ATTRIBUTE1 = 'DIO' THEN '-' ELSE OPERATION_GROUP END) DESC
                                    , ITEM_ID
                                      /* 원본 L2352 주석 보존 : ,TO_SITE desc */
                                    , (CASE WHEN (TO_SITE = '-' AND MEASURE = 'MKT_FCST_PACK_TOTAL' )  THEN 'ZZZ'
                                            WHEN (TO_SITE = '-' AND MEASURE = 'SHIP_REQ_PACK_TOTAL' )  THEN 'ZZZ'
                                            WHEN (TO_SITE = '-' AND MEASURE = 'MKT_FCST_CELL_TOTAL' )  THEN 'AAA'
                                            WHEN (TO_SITE = '-' AND MEASURE = 'SHIP_REQ_CELL_TOTAL' )  THEN 'AAA'
                                            WHEN (TO_SITE = '-' AND MEASURE = 'PACK_SHIP_PLAN_TOTAL' ) THEN 'AAA'
                                            WHEN (TO_SITE = '-' AND MEASURE = 'CELL_SHIP_PLAN_TOTAL' ) THEN 'AAA'
                                            ELSE TO_SITE END) DESC
                                    , ITEM_ID
                                    , INCOTERMS
                                    , (CASE WHEN (FROM_SITE = '-' AND MEASURE LIKE 'CELL%' ) THEN 'AAA'
                                            ELSE FROM_SITE END)
                                    , PROJECT_CODE
                                    , ATTRIBUTE10
                                    , (CASE WHEN MEASURE IN ('PACK_CELL_BOH','PACK_CELL_EOH') THEN 'ZZZ' ELSE PROD_LINE END)
                                    , SORT_ORDER_NO
                                    , TRANSPORT_MODE
                                    , MEASURE_LABEL DESC
                            ) AS XLS_KEY1
         , XLS_KEY2, XLS_KEY3, XLS_KEY4, XLS_KEY5
         , XLS_ATTRIBUTE1, XLS_ATTRIBUTE2, XLS_ATTRIBUTE3, XLS_ATTRIBUTE4, XLS_ATTRIBUTE5
         , SORT_ORDER_NO
         , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
, QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
, QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
, QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
, QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
, QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
, QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
, QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
, QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
, QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
, QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
, QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
, QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
, QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
, QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
, QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
, QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
, QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
, QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
, QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
, QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
, QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
, QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
, QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
, QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
, QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
, QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
, QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
, QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
, QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
, QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
, QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
, QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
, QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
, QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
, QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
, QTY361, QTY362, QTY363, QTY364
           /* 원본 GETDATE() -> SYSDATE */
         , P_USER_ID AS CREATED_BY, SYSDATE AS CREATION_DATE, P_USER_ID AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
         , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
      FROM GT_SCXL_PSI_GLOBAL_ESS
    ;

    /* 원본 L2410~L2428 : UPDATE .. FROM JOIN -> MERGE. CELL_CHAR_AVAILABLE 의 YIELD 보정 */
    MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X
    USING ( SELECT ITEM_ID
                 , PLANT_SITE_ID
                 , MAX(FORMATION_TOTAL_YIELD) AS FORMATION_TOTAL_YIELD
                 , SSP_MODIFY_YIELD
              FROM SCP_MST_FORMATION_V Z
             WHERE Z.DIVISION_ID = P_DIVISION_ID
             GROUP BY ITEM_ID
                    , PLANT_SITE_ID
                    , SSP_MODIFY_YIELD ) Y
       ON (    X.CELL_ITEM_ID          = Y.ITEM_ID
           AND X.FROM_SITE             = Y.PLANT_SITE_ID
           AND X.CREATE_FROM_YYYYMMDD  = P_CREATE_FROM_YYYYMMDD   /* 2021.04.30 KSW PJ20209642 */
           AND X.MEASURE               = 'CELL_CHAR_AVAILABLE' )
     WHEN MATCHED THEN UPDATE
        SET X.YIELD = (CASE WHEN Y.SSP_MODIFY_YIELD > 0.0 THEN Y.SSP_MODIFY_YIELD ELSE Y.FORMATION_TOTAL_YIELD END)
    ;

    /* 원본 L2435~L2451 : UPDATE .. FROM JOIN -> MERGE. PACK_PROD 의 YIELD 보정 */
    MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X
    USING ( SELECT PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID, MAX(YIELD) AS YIELD
              FROM GT_SCXL_TACT_TIME_TMP
             WHERE DIVISION_ID = P_DIVISION_ID
             GROUP BY PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID ) Y
       ON (    X.ITEM_ID             = Y.ITEM_ID
           AND X.FROM_SITE           = Y.PLANT_SITE_ID
           AND X.ATTRIBUTE9          = Y.OPERATION_ID
           AND X.PROD_LINE           = Y.LINE_ID
           AND X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD   /* 2021.04.30 KSW PJ20209642 */
           AND X.MEASURE             = 'PACK_PROD' )
     WHEN MATCHED THEN UPDATE
        SET X.YIELD = Y.YIELD
    ;

    /* 원본 L2456~L2464 : SELECT .. INTO #SCP_XLS_PSI_GLOBAL_ESS_MODEL_INVENTORY */
    DELETE
      FROM GT_SCXL_MODEL_INVENTORY;

    INSERT INTO GT_SCXL_MODEL_INVENTORY
         ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, CELL_ITEM_ID, ITEM_ID, FROM_SITE, FROM_BOH_QTY )
    SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, CELL_ITEM_ID, ITEM_ID, FROM_SITE, FROM_BOH_QTY
      FROM SCP_ANL_PSI_GLOBAL X
     WHERE X.DIVISION_ID          = P_DIVISION_ID
       AND X.PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
       AND X.PLAN_TYPE            = P_PLAN_TYPE
       AND X.SEQ                  = P_SEQ
       AND X.MEASURE              = 'MODEL_INVENTORY'
       AND X.YYYYMMDD             = P_PLAN_START_YYYYMMDD
    ;

    /* 원본 L2466~L2474 : UPDATE .. FROM JOIN -> MERGE. PACK_BOH 의 QTY001 에 기초재고 반영 */
    MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X
    USING GT_SCXL_MODEL_INVENTORY Y
       ON (    X.DIVISION_ID          = Y.DIVISION_ID
           AND X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD   /* 2021.04.30 KSW PJ20209642 */
           AND X.FROM_SITE            = Y.FROM_SITE
           AND X.ITEM_ID              = Y.ITEM_ID
           AND X.MEASURE              = 'PACK_BOH' )
     WHEN MATCHED THEN UPDATE
        SET X.QTY001 = Y.FROM_BOH_QTY
    ;

    /* -------------------------------------------------------------------------------------
       원본 L2480~L2497 : 조인 없는 단일 테이블 UPDATE(상관 서브쿼리) 라 UPDATE 로 그대로 옮긴다.
       SELECT TOP 1 -> AND ROWNUM = 1 (원본에 ORDER BY 없음).
       ★SET 은 갱신 전 값으로 동시 평가되므로 서브쿼리의 X.ITEM_ID 는 옛 ITEM_ID 다(원본 동일).
       ------------------------------------------------------------------------------------- */
    UPDATE SCP_XLS_PSI_GLOBAL_ESS X
       SET X.ITEM_ID = ( SELECT Y.CHILD_ITEM_ID
                           FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Y
                          WHERE Y.DIVISION_ID        = X.DIVISION_ID
                            AND Y.MODEL_ID           = X.ITEM_ID
                            AND Y.OPERATION_GROUP_ID = 'A'
                                /* 활성화 코드 관련 조건 추가::2023.07.01, KSK */
                            AND Y.CELL_TYPE          = 'CP'
                            AND ROWNUM               = 1 )
         , X.TO_SITE             = '-'
         , X.TO_SITE_DESCRIPTION = '-'
         , X.PROJECT_CODE        = '-'
         , X.INCOTERMS           = '-'
         , X.PROD_LINE           = '-'
     WHERE X.OPERATION_GROUP = 'P'
       AND X.MEASURE IN ('PACK_CELL_BOH','PACK_CELL_EOH','PACK_CELL_EOH_TOTAL')
       AND X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD   /* 2021.04.30 KSW PJ20209642 */
    ;

    /* 원본 L2499~L2505 : 조인 없는 단일 테이블 UPDATE(상관 서브쿼리) 라 UPDATE 로 그대로 옮긴다.
       SELECT TOP 1 -> AND ROWNUM = 1.  2021.05.25 NICK_NAME 누락방지 */
    UPDATE SCP_XLS_PSI_GLOBAL_ESS X
       SET X.NICK_NAME = (SELECT (CASE WHEN Y.NICK_NAME IS NULL THEN '-'
                                       WHEN Y.NICK_NAME = ''    THEN '-'
                                       ELSE Y.NICK_NAME END)
                            FROM SCM_MST_ITEM_SN Y
                           WHERE Y.ITEM_ID     = X.ITEM_ID
                             AND Y.DIVISION_ID = '82'
                             AND ROWNUM        = 1)
     WHERE X.OPERATION_GROUP = 'P'
       AND X.MEASURE IN ('PACK_CELL_BOH','PACK_CELL_EOH','PACK_CELL_EOH_TOTAL')
       AND X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD   /* 2021.04.30 KSW PJ20209642 */
    ;

    /* 원본 L2508~L2519 : 동일. CONVERT(NVARCHAR(50), CEILING(x)) -> TO_CHAR(CEIL(x)) */
    UPDATE SCP_XLS_PSI_GLOBAL_ESS X
       SET X.CELL_QTY_PACK = (SELECT TO_CHAR(CEIL(V.ACCUMULATED_CHILD_QTY))
                                FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V
                               WHERE V.DIVISION_ID        = X.DIVISION_ID
                                 AND V.OPERATION_GROUP_ID = 'A'
                                 AND V.MODEL_ID           = X.ITEM_ID
                                 AND V.CHILD_ITEM_ID      = X.CELL_ITEM_ID
                                 AND ROWNUM               = 1)
     WHERE 0 = 0
       AND X.OPERATION_GROUP = 'P'
       AND X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD   /* 2021.04.30 KSW PJ20209642 */
    ;

    /* -------------------------------------------------------------------------------------
       원본 L2523~L2602 : `DELETE TBL FROM (SELECT ROW_NUMBER() .. ) AS TBL WHERE TBL.ROWNUM > 1`
       ★MSSQL 전용 "인라인뷰 DELETE"(중복 제거) 다. Oracle 에는 없으므로
         ROWID 를 키로 뽑아 지우는 형태로 옮긴다(같은 행만 지운다).
       ★원본 별칭이 ROWNUM 인데 Oracle 은 예약 의사컬럼이라 별칭으로 못 쓴다 -> RN 으로 바꾼다.
       ------------------------------------------------------------------------------------- */
    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS
     WHERE ROWID IN ( SELECT RID FROM
                        ( SELECT ROWID AS RID
                               , ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID, FROM_SITE ORDER BY XLS_KEY1 DESC) AS RN
                            FROM SCP_XLS_PSI_GLOBAL_ESS
                           WHERE MEASURE IN ('PACK_CELL_BOH')
                             AND CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD )
                       WHERE RN > 1 )
    ;

    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS
     WHERE ROWID IN ( SELECT RID FROM
                        ( SELECT ROWID AS RID
                               , ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID, FROM_SITE ORDER BY XLS_KEY1 DESC) AS RN
                            FROM SCP_XLS_PSI_GLOBAL_ESS
                           WHERE MEASURE IN ('PACK_CELL_EOH')
                             AND CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD )
                       WHERE RN > 1 )
    ;

    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS
     WHERE ROWID IN ( SELECT RID FROM
                        ( SELECT ROWID AS RID
                               , ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID, FROM_SITE ORDER BY XLS_KEY1 DESC) AS RN
                            FROM SCP_XLS_PSI_GLOBAL_ESS
                           WHERE MEASURE IN ('PACK_CELL_EOH_TOTAL')
                             AND CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD )
                       WHERE RN > 1 )
    ;

    /* 원본 L2557~L2560 */
    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS
     WHERE MEASURE = 'SHIP_PLAN'
       AND BOD_ID  = '-'
       AND CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD   /* 2021.04.30 KSW PJ20209642 */
    ;

    /* 원본 L2563~L2566 */
    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS
     WHERE MEASURE IN ('CELL_PROD','CELL_PROD_LOAD')
       AND PROD_LINE = '-'
       AND CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD   /* 2021.04.30 KSW PJ20209642 */
    ;

    /* 원본 L2571~L2580 : UPDATE .. FROM JOIN -> MERGE. LT_DAY = LT_FORMATION + ATTRIBUTE1
       CONVERT(INT, ISNULL(x,'0')) -> TO_NUMBER(NVL(x,'0')) */
    MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X
    USING SCP_MST_FORMATION Y
       ON (    X.DIVISION_ID          = Y.DIVISION_ID
           AND X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD   /* 2021.04.30 KSW PJ20209642 */
           AND X.FROM_SITE            = Y.PLANT_SITE_ID
           AND X.ITEM_ID              = Y.ITEM_ID
           AND X.MEASURE              = 'CELL_PROD' )
     WHEN MATCHED THEN UPDATE
        SET X.LT_DAY = Y.LT_FORMATION + TO_NUMBER(NVL(Y.ATTRIBUTE1, '0'))   /* AS LT_FORMATION */
    ;

    /* 원본 L2584~L2592 */
    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS
     WHERE ROWID IN ( SELECT RID FROM
                        ( SELECT ROWID AS RID
                               , ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID, FROM_SITE ORDER BY XLS_KEY1 DESC) AS RN
                            FROM SCP_XLS_PSI_GLOBAL_ESS
                           WHERE MEASURE IN ('PACK_SHIP_PLAN_TOTAL')
                             AND CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD )
                       WHERE RN > 1 )
    ;

    /* 원본 L2594~L2602 */
    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS
     WHERE ROWID IN ( SELECT RID FROM
                        ( SELECT ROWID AS RID
                               , ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID, FROM_SITE ORDER BY XLS_KEY1 DESC) AS RN
                            FROM SCP_XLS_PSI_GLOBAL_ESS
                           WHERE MEASURE IN ('CELL_SHIP_PLAN_TOTAL')
                             AND CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD )
                       WHERE RN > 1 )
    ;

    /* 원본 L2604~L2607 */
    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS
     WHERE MEASURE = 'PACK_SHIP_PLAN_TOTAL'
       AND CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD   /* 2021.04.30 KSW PJ20209642 */
       AND OPERATION_GROUP = 'A'
    ;

    /* -------------------------------------------------------------------------------------
       [구간8] 원본 L2626~L2761 : PLAN_START = CREATE_FROM 일 때만 BOH 반영, DIO/BOD 기간 보정
       ------------------------------------------------------------------------------------- */
    IF (P_PLAN_START_YYYYMMDD = P_CREATE_FROM_YYYYMMDD) THEN

        /* 원본 L2629~L2655 : SELECT .. INTO #BOH */
        DELETE
          FROM GT_SCXL_BOH;

        INSERT INTO GT_SCXL_BOH
             ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SCM_SITE_ID, INCOTERMS, ITEM_ID, QTY )
        SELECT DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , SCM_SITE_ID
             , INCOTERMS
             , ITEM_ID
             , SUM(QTY) AS QTY
               /* 원본 주석 보존 : ,ORIGIN_ITEM_ID / ,SUM(ORIGIN_QTY) AS ORIGIN_QTY */
          FROM SCP_XLS_BOH
         WHERE DIVISION_ID         = P_DIVISION_ID
           AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND PLAN_TYPE           = P_PLAN_TYPE
           AND SEQ                 = P_SEQ
             /* 원본 ISNULL(ORIGIN_ITEM_ID,'') = '' : Oracle 은 빈문자=NULL 이라 NVL 로 못 맞춘다.
                "값이 없다"는 뜻이므로 IS NULL 로 옮긴다(원본에서 빈문자 적재는 곧 NULL). */
           AND ORIGIN_ITEM_ID IS NULL
         GROUP BY DIVISION_ID
                , PLAN_START_YYYYMMDD
                , PLAN_TYPE
                , SEQ
                , SCM_SITE_ID
                , INCOTERMS
                , ITEM_ID
        ;

        /* 원본 L2659~L2667 : UPDATE .. FROM JOIN -> MERGE. BOH 를 QTY001 에 반영 */
        MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X
        USING GT_SCXL_BOH Y
           ON (    0 = 0
               AND X.FROM_SITE            = Y.SCM_SITE_ID
               AND X.ITEM_ID              = Y.ITEM_ID
               AND X.MEASURE              IN ('PACK_BOH','CELL_BOH','PACK_CELL_BOH')
               AND X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD )   /* 2021.04.30 KSW PJ20209642 */
         WHEN MATCHED THEN UPDATE
            SET X.QTY001 = NVL(Y.QTY, 0)
        ;

        /* 원본 L2672~L2684 : WH_HOLD 재고를 CELL_BOH 에서 차감 */
        MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X
        USING ( SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY
                  FROM GT_SCXL_ENG_STOCK_PLAN Y
                 WHERE DESCR = 'WH_HOLD'
                 GROUP BY ITEM_ID, FROM_SITE ) Y
           ON (    0 = 0
               AND X.FROM_SITE            = Y.FROM_SITE
               AND X.ITEM_ID              = Y.ITEM_ID
               AND X.MEASURE              = 'CELL_BOH'
               AND X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD )   /* 2021.04.30 KSW PJ20209642 */
         WHEN MATCHED THEN UPDATE
            SET X.QTY001 = NVL(X.QTY001, 0) - NVL(Y.QTY, 0)
        ;

        /* 원본 L2687~L2696 : TO_SITE_BOH 반영 */
        MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X
        USING GT_SCXL_BOH Y
           ON (    0 = 0
               AND X.TO_SITE              = Y.SCM_SITE_ID
               AND X.ITEM_ID              = Y.ITEM_ID
               AND X.MEASURE              = 'TO_SITE_BOH'
               AND X.INCOTERMS            = Y.INCOTERMS
               AND X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD )   /* 2021.04.30 KSW PJ20209642 */
         WHEN MATCHED THEN UPDATE
            SET X.QTY001 = NVL(Y.QTY, 0)
        ;

    END IF;

    /* 원본 L2708~L2722 : SELECT .. INTO #tmp_SCP_MST_DIO (분기별 최신 YYYYQ 만) */
    DELETE
      FROM GT_SCXL_DIO;

    INSERT INTO GT_SCXL_DIO
         ( DIVISION_ID, PLANT_ID, ITEM_ID, GRO_STD_DIO, MIN_STD_DIO )
    SELECT A.DIVISION_ID, A.PLANT_ID, A.ITEM_ID, A.GRO_STD_DIO, A.MIN_STD_DIO
      FROM SCP_MST_DIO A
     INNER JOIN ( SELECT DIVISION_ID, PLANT_ID, MAX(YYYYQ) AS YYYYQ
                    FROM SCP_MST_DIO
                   WHERE DIVISION_ID IS NOT NULL
                   GROUP BY DIVISION_ID, PLANT_ID ) B
        ON  A.DIVISION_ID = B.DIVISION_ID
       AND  A.PLANT_ID    = B.PLANT_ID
       AND  A.YYYYQ       = B.YYYYQ
       AND  A.DIVISION_ID = P_DIVISION_ID
    ;

    /* 원본 L2726~L2734 : ALLOCATION_DIO 의 ATTRIBUTE4/5 보정 */
    MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X
    USING GT_SCXL_DIO Z
       ON (    X.CELL_ITEM_ID        = Z.ITEM_ID
           AND X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD        /* 2021.04.30 KSW PJ20209642 */
           AND X.MEASURE              = 'ALLOCATION_DIO' )
     WHEN MATCHED THEN UPDATE
        SET X.ATTRIBUTE4 = Z.GRO_STD_DIO
          , X.ATTRIBUTE5 = Z.MIN_STD_DIO
    ;

    /* 원본 L2741~L2746 : BOD 기간을 ATTRIBUTE3 에 기록. 문자열 결합 '+' -> '||' */
    MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X
    USING SCP_MST_BOD_N_V Z
       ON (    X.BOD_ID  = Z.BOD_ID
           AND X.MEASURE IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN') )
     WHEN MATCHED THEN UPDATE
        SET X.ATTRIBUTE3 = Z.FROM_YYYYMMDD || ',' || Z.TO_YYYYMMDD
    ;

    /* -------------------------------------------------------------------------------------
       [구간9] 원본 L2758~L2848 : #Rn (주차 WQTYnn <-> 일련번호 1~364 매핑) 생성
       ★원본은 `SELECT 'WQTY01',1 UNION ALL SELECT 'WQTY01',2 ...` 로 364행을 나열한다.
         실측 결과 **RN 이 1..364 연속이고 WQTYnn = CEIL(RN/7) 규칙에 완전 일치**하므로
         CONNECT BY 로 같은 364행을 생성한다(값·행수 동일, 2026-08-14 원본 파싱으로 검증).
       ------------------------------------------------------------------------------------- */
    DELETE
      FROM GT_SCXL_RN;

    INSERT INTO GT_SCXL_RN ( WEEK_COLUMN, RN )
    SELECT 'WQTY' || LPAD(TO_CHAR(CEIL(LEVEL / 7)), 2, '0') AS WEEK_COLUMN
         , LEVEL AS RN
      FROM DUAL
     CONNECT BY LEVEL <= 364
    ;

    /* -------------------------------------------------------------------------------------
       [구간10] 원본 L2826~L3020
       #CALENDAR / #HEADER 생성 -> 주간합계(WQTYnn) 동적 UPDATE -> 짝 없는 행 정리 DELETE 8건
       ------------------------------------------------------------------------------------- */
    /* 원본 L2828~L2844 : SELECT .. INTO #CALENDAR
       CONVERT(CHAR(2), 31) -> TO_CHAR(31). 문자열 결합 '+' -> '||' */
    DELETE
      FROM GT_SCXL_CALENDAR;

    INSERT INTO GT_SCXL_CALENDAR
         ( D_YYYYMMDD, YYYYMMDD_COLUMN, W_YYYY_WEEK, M_YYYYMM, ISO_WEEK, RN, SORT_ORDER_NO )
    SELECT 'D_' || A.BASIS_YYYYMMDD AS D_YYYYMMDD
         , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS YYYYMMDD_COLUMN
         , MAX('W_' || A.BASIS_YYYYMM || A.ISO_WEEK) AS W_YYYY_WEEK
         , MAX('M_' || A.BASIS_YYYYMM)              AS M_YYYYMM
         , MAX(A.ISO_WEEK)                          AS ISO_WEEK
         , ROW_NUMBER() OVER (ORDER BY A.BASIS_YYYYMMDD || TO_CHAR(31)) AS RN
         , A.BASIS_YYYYMMDD || TO_CHAR(31) AS SORT_ORDER_NO
      FROM SCM_SYS_CALENDAR_M A
     WHERE A.BASIS_YYYYMMDD >= P_CREATE_FROM_YYYYMMDD
       AND A.BASIS_YYYYMMDD <= P_CREATE_TO_YYYYMMDD
     GROUP BY A.BASIS_YYYYMMDD   /* 원본 주석 보존 : ,ISO_WEEK ,A.BASIS_YYYYMM,ISO_WEEK */
    ;

    /* 원본 L2846~L2852 : SELECT .. INTO #HEADER (달력 x 주차매핑) */
    DELETE
      FROM GT_SCXL_HEADER;

    INSERT INTO GT_SCXL_HEADER
         ( YYYYMMDD_COLUMN, WEEK_COLUMN, W_YYYY_WEEK, M_YYYYMM, ISO_WEEK, SORT_ORDER_NO, RN )
    SELECT X.YYYYMMDD_COLUMN, Y.WEEK_COLUMN, X.W_YYYY_WEEK, X.M_YYYYMM, X.ISO_WEEK, X.SORT_ORDER_NO, X.RN
      FROM GT_SCXL_CALENDAR X
     INNER JOIN GT_SCXL_RN Y ON X.RN = Y.RN
     ORDER BY X.RN
    ;

    /* -------------------------------------------------------------------------------------
       원본 L2855~L2880 : 주간합계 동적 UPDATE
         `WQTY01 = (QTY001+QTY002+ ... +QTY007)` 형태를 주차 수만큼 만들어 한 번에 UPDATE 한다.
       ★MSSQL 문자열 집계 `STUFF((SELECT '+'+col .. FOR XML PATH('')),1,1,'')` 는 Oracle 에 없다.
         -> `LISTAGG(col, '+') WITHIN GROUP (ORDER BY SORT_ORDER_NO)` 로 옮긴다.
            STUFF(x,1,1,'') 는 맨 앞 '+' 를 떼는 것이고, LISTAGG 는 애초에 사이에만 넣으므로 결과가 같다.
       ★원본은 마지막 콤마 2자를 LEFT(x, LEN(x)-2) 로 잘라낸다 -> 조립 시 콤마를 넣지 않고 LISTAGG 로 한번에.
       ------------------------------------------------------------------------------------- */
    V_MQRY_SUMWEEK := 'UPDATE SCP_XLS_PSI_GLOBAL_ESS X ' || CHR(10) || 'SET ' || CHR(10);

    FOR R IN ( SELECT A.WEEK_COLUMN
                    , A.WEEK_COLUMN || ' = (' || LISTAGG(A.YYYYMMDD_COLUMN, '+')
                          WITHIN GROUP (ORDER BY A.SORT_ORDER_NO) || ')' AS WSUM
                    , MIN(A.SORT_ORDER_NO) - 1 AS SORT_ORDER_NO
                 FROM GT_SCXL_HEADER A
                GROUP BY A.WEEK_COLUMN
                ORDER BY A.WEEK_COLUMN ) LOOP
        V_MQRY_SUMWEEK := V_MQRY_SUMWEEK || R.WSUM || ',' || CHR(10);
    END LOOP;

    /* 원본 L2874 : LEFT(@mQry_sumWeek, LEN(@mQry_sumWeek)-2) — 마지막 ",<CHR(10)>" 제거 */
    V_MQRY_SUMWEEK := SUBSTR(V_MQRY_SUMWEEK, 1, LENGTH(V_MQRY_SUMWEEK) - 2);

    V_MQRY_SUMWEEK := V_MQRY_SUMWEEK || CHR(10)
                   || ' WHERE X.CREATE_FROM_YYYYMMDD = ''' || P_CREATE_FROM_YYYYMMDD || '''' || CHR(10);

    EXECUTE IMMEDIATE V_MQRY_SUMWEEK;

    /* 원본 L2885~L2893 : PACK_PROD_LOAD 중복 제거(ROW_NUMBER) */
    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS
     WHERE ROWID IN ( SELECT RID FROM
                        ( SELECT ROWID AS RID
                               , ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID, FROM_SITE, PROD_LINE ORDER BY XLS_KEY1 DESC) AS RN
                            FROM SCP_XLS_PSI_GLOBAL_ESS
                           WHERE MEASURE IN ('PACK_PROD_LOAD')
                             AND CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD )
                       WHERE RN > 1 )
    ;

    /* 원본 L2896~L2900 */
    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS
     WHERE CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
       AND ITEM_ID      = '-'
       AND CELL_ITEM_ID IS NULL
    ;

    /* -------------------------------------------------------------------------------------
       원본 L2902~L3020 : `DELETE TBL FROM (.. WHERE ISNULL((SELECT DISTINCT 'Y' ..),'N')='N') AS TBL`
       ★"짝이 되는 행이 없으면 지운다" 이므로 NOT EXISTS 와 등가다(서브쿼리 0행 -> NULL -> 'N' -> 참).
       ------------------------------------------------------------------------------------- */
    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS X
     WHERE X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
       AND X.MEASURE IN ('PACK_PROD_LOAD_TOTAL')
       AND NOT EXISTS ( SELECT 1 FROM SCP_XLS_PSI_GLOBAL_ESS A
                         WHERE A.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
                           AND A.FROM_SITE = X.FROM_SITE
                               /* 원본 L2912 주석 보존 : AND A.PROD_LINE = X.PROD_LINE */
                           AND A.MEASURE   = 'PACK_PROD' )
    ;

    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS X
     WHERE X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
       AND X.MEASURE IN ('PACK_PROD_LOAD_TOTAL')
       AND NOT EXISTS ( SELECT 1 FROM SCP_XLS_PSI_GLOBAL_ESS A
                         WHERE A.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
                           AND A.ITEM_ID   = X.ITEM_ID
                           AND A.FROM_SITE = X.FROM_SITE
                           AND A.PROD_LINE = X.PROD_LINE
                           AND A.MEASURE   = 'PACK_PROD' )
    ;

    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS X
     WHERE X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
       AND X.MEASURE IN ('PACK_PROD_LOAD', 'PACK_WORKING_TIME', 'PACK_TACT_TIME')
       AND NOT EXISTS ( SELECT 1 FROM SCP_XLS_PSI_GLOBAL_ESS A
                         WHERE A.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
                           AND A.ITEM_ID      = X.ITEM_ID
                           AND A.CELL_ITEM_ID = X.CELL_ITEM_ID
                           AND A.FROM_SITE    = X.FROM_SITE
                           AND A.PROD_LINE    = X.PROD_LINE
                           AND A.MEASURE      = 'PACK_PROD' )
    ;

    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS X
     WHERE X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
       AND X.MEASURE IN ('PACK_PROD_TOTAL', 'PACK_DIO')
       AND NOT EXISTS ( SELECT 1 FROM SCP_XLS_PSI_GLOBAL_ESS A
                         WHERE A.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
                           AND A.ITEM_ID      = X.ITEM_ID
                           AND A.CELL_ITEM_ID = X.CELL_ITEM_ID
                           AND A.FROM_SITE    = X.FROM_SITE
                               /* 원본 L2966 주석 보존 : AND A.PROD_LINE = X.PROD_LINE */
                           AND A.MEASURE      = 'PACK_PROD' )
    ;

    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS X
     WHERE X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
       AND X.MEASURE = 'CELL_TACT_TIME'
       AND NOT EXISTS ( SELECT 1 FROM SCP_XLS_PSI_GLOBAL_ESS A
                         WHERE A.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
                           AND A.ITEM_ID      = X.ITEM_ID
                           AND A.CELL_ITEM_ID = X.CELL_ITEM_ID
                           AND A.FROM_SITE    = X.FROM_SITE
                           AND A.PROD_LINE    = X.PROD_LINE
                           AND A.MEASURE      = 'CELL_PROD' )
    ;

    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS X
     WHERE X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
       AND X.MEASURE IN ('CELL_PROD_LOAD', 'CELL_WORKING_TIME')
       AND NOT EXISTS ( SELECT 1 FROM SCP_XLS_PSI_GLOBAL_ESS A
                         WHERE A.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
                           AND A.FROM_SITE = X.FROM_SITE
                           AND A.PROD_LINE = X.PROD_LINE
                           AND A.MEASURE   = 'CELL_PROD' )
    ;

    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS X
     WHERE X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
       AND X.MEASURE IN ('MKT_FCST_DIO', 'ALLOCATION_DIO', 'ALLOCATION_GAP_STD_DIO', 'ALLOCATION_GAP_MIN_DIO')
       AND NOT EXISTS ( SELECT 1 FROM SCP_XLS_PSI_GLOBAL_ESS A
                         WHERE A.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
                           AND A.ITEM_ID      <> '-'
                           AND A.CELL_ITEM_ID = X.CELL_ITEM_ID )
    ;

    /* -------------------------------------------------------------------------------------
       [구간11] 원본 L3025~L3405 : 주간 LineLoad PIVOT 반영 -> LT 환산 -> 정리 -> RETURN
       ------------------------------------------------------------------------------------- */
    /* 원본 L3025~L3046 : SELECT .. INTO #LineLoad_WEEK (주 단위 집계) */
    DELETE
      FROM GT_SCXL_LINELOAD_WEEK;

    INSERT INTO GT_SCXL_LINELOAD_WEEK
         ( DIVISION_ID, SITE_ID, OPERATION_ID, PROD_LINE, MEASURE, WQTY, ISO_YYYYWW, WEEK_COLUMN )
    SELECT A.DIVISION_ID
         , A.SCM_SITE_ID AS SITE_ID
         , A.OPERATION_ID
         , A.LINE_ID AS PROD_LINE
         , A.MEASURE
         , CASE WHEN SUM(A.WORKING_TIME) <= 0.0 THEN 0
                ELSE NVL( ( ROUND(SUM(A.CAPA_TACT), 0) / SUM(A.WORKING_TIME) ), 0 )
           END AS WQTY
         , A.ISO_YYYYWW
         , A.WEEK_COLUMN
      FROM GT_SCXL_LINELOAD A
     GROUP BY A.DIVISION_ID
            , A.SCM_SITE_ID
            , A.OPERATION_ID
            , A.LINE_ID
            , A.MEASURE
            , A.ISO_YYYYWW
            , A.WEEK_COLUMN
    ;

    /* 원본 L3048~L3068 : PIVOT (주차 52개). PIVOT IN 은 리터럴 AS 별칭이어야 한다(ORA-56901) */
    DELETE
      FROM GT_SCXL_LINELOAD_WEEK_PVT;

    INSERT INTO GT_SCXL_LINELOAD_WEEK_PVT
    SELECT *
      FROM ( SELECT DIVISION_ID, SITE_ID, OPERATION_ID, PROD_LINE, MEASURE, WQTY, WEEK_COLUMN
               FROM GT_SCXL_LINELOAD_WEEK ) SOURCETABLE
     PIVOT ( MIN(WQTY) FOR WEEK_COLUMN IN (
                 'WQTY01' AS WQTY01, 'WQTY02' AS WQTY02, 'WQTY03' AS WQTY03, 'WQTY04' AS WQTY04, 'WQTY05' AS WQTY05, 'WQTY06' AS WQTY06,
                 'WQTY07' AS WQTY07, 'WQTY08' AS WQTY08, 'WQTY09' AS WQTY09, 'WQTY10' AS WQTY10, 'WQTY11' AS WQTY11, 'WQTY12' AS WQTY12,
                 'WQTY13' AS WQTY13, 'WQTY14' AS WQTY14, 'WQTY15' AS WQTY15, 'WQTY16' AS WQTY16, 'WQTY17' AS WQTY17, 'WQTY18' AS WQTY18,
                 'WQTY19' AS WQTY19, 'WQTY20' AS WQTY20, 'WQTY21' AS WQTY21, 'WQTY22' AS WQTY22, 'WQTY23' AS WQTY23, 'WQTY24' AS WQTY24,
                 'WQTY25' AS WQTY25, 'WQTY26' AS WQTY26, 'WQTY27' AS WQTY27, 'WQTY28' AS WQTY28, 'WQTY29' AS WQTY29, 'WQTY30' AS WQTY30,
                 'WQTY31' AS WQTY31, 'WQTY32' AS WQTY32, 'WQTY33' AS WQTY33, 'WQTY34' AS WQTY34, 'WQTY35' AS WQTY35, 'WQTY36' AS WQTY36,
                 'WQTY37' AS WQTY37, 'WQTY38' AS WQTY38, 'WQTY39' AS WQTY39, 'WQTY40' AS WQTY40, 'WQTY41' AS WQTY41, 'WQTY42' AS WQTY42,
                 'WQTY43' AS WQTY43, 'WQTY44' AS WQTY44, 'WQTY45' AS WQTY45, 'WQTY46' AS WQTY46, 'WQTY47' AS WQTY47, 'WQTY48' AS WQTY48,
                 'WQTY49' AS WQTY49, 'WQTY50' AS WQTY50, 'WQTY51' AS WQTY51, 'WQTY52' AS WQTY52
           ) )
    ;

    /* 원본 L3071~L3091 : UPDATE .. FROM JOIN -> MERGE. 주간 LOAD 값 반영 */
    MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X
    USING GT_SCXL_LINELOAD_WEEK_PVT Y
       ON (    Y.PROD_LINE            = X.PROD_LINE
           AND X.DIVISION_ID          = Y.DIVISION_ID
           AND X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD   /* 2021.04.30 KSW PJ20209642 */
           AND X.FROM_SITE            = Y.SITE_ID
           AND X.ATTRIBUTE9           = Y.OPERATION_ID
           AND X.MEASURE              IN ('PACK_PROD_LOAD','CELL_PROD_LOAD') )
     WHEN MATCHED THEN UPDATE
        SET X.WQTY01 = Y.WQTY01, X.WQTY02 = Y.WQTY02, X.WQTY03 = Y.WQTY03, X.WQTY04 = Y.WQTY04
          , X.WQTY05 = Y.WQTY05, X.WQTY06 = Y.WQTY06, X.WQTY07 = Y.WQTY07, X.WQTY08 = Y.WQTY08
          , X.WQTY09 = Y.WQTY09, X.WQTY10 = Y.WQTY10, X.WQTY11 = Y.WQTY11, X.WQTY12 = Y.WQTY12
          , X.WQTY13 = Y.WQTY13, X.WQTY14 = Y.WQTY14, X.WQTY15 = Y.WQTY15, X.WQTY16 = Y.WQTY16
          , X.WQTY17 = Y.WQTY17, X.WQTY18 = Y.WQTY18, X.WQTY19 = Y.WQTY19, X.WQTY20 = Y.WQTY20
          , X.WQTY21 = Y.WQTY21, X.WQTY22 = Y.WQTY22, X.WQTY23 = Y.WQTY23, X.WQTY24 = Y.WQTY24
          , X.WQTY25 = Y.WQTY25, X.WQTY26 = Y.WQTY26, X.WQTY27 = Y.WQTY27, X.WQTY28 = Y.WQTY28
          , X.WQTY29 = Y.WQTY29, X.WQTY30 = Y.WQTY30, X.WQTY31 = Y.WQTY31, X.WQTY32 = Y.WQTY32
          , X.WQTY33 = Y.WQTY33, X.WQTY34 = Y.WQTY34, X.WQTY35 = Y.WQTY35, X.WQTY36 = Y.WQTY36
          , X.WQTY37 = Y.WQTY37, X.WQTY38 = Y.WQTY38, X.WQTY39 = Y.WQTY39, X.WQTY40 = Y.WQTY40
          , X.WQTY41 = Y.WQTY41, X.WQTY42 = Y.WQTY42, X.WQTY43 = Y.WQTY43, X.WQTY44 = Y.WQTY44
          , X.WQTY45 = Y.WQTY45, X.WQTY46 = Y.WQTY46, X.WQTY47 = Y.WQTY47, X.WQTY48 = Y.WQTY48
          , X.WQTY49 = Y.WQTY49, X.WQTY50 = Y.WQTY50, X.WQTY51 = Y.WQTY51, X.WQTY52 = Y.WQTY52
    ;

    /* 원본 L3097~L3107 : BOD L/T 를 주 단위로 환산. CEILING -> CEIL, ROUND(x,0,0) -> TRUNC(x,0) */
    MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X
    USING SCP_MST_BOD_N_V Y   /* BOD L/T 2단계 : SCP_MST_BOD_V -> SCP_MST_BOD_N_V */
       ON (    X.DIVISION_ID          = Y.DIVISION_ID
           AND X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD   /* 2021.04.30 KSW PJ20209642 */
           AND X.FROM_SITE            = Y.FROM_SITE
           AND X.TO_SITE              = Y.TO_SITE
           AND X.TRANSPORT_MODE       = Y.TRANSPORT_MODE
           AND X.BOD_ID               = Y.BOD_ID )
     WHEN MATCHED THEN UPDATE
        SET X.LT_DAY     = (CASE WHEN (Y.LT_TOTAL / 7.0) < 1 THEN TRUNC((Y.LT_TOTAL / 7.0), 0)
                                 ELSE CEIL((Y.LT_TOTAL / 7.0)) END)
          , X.ATTRIBUTE2 = Y.LT_TOTAL
    ;

    /* 원본 L3110~L3116 : 조인 없는 단일 UPDATE.
       ★SET 은 동시 평가라 ATTRIBUTE2 에는 갱신 전 LT_DAY 가 들어간다(MSSQL 도 동일 — 원본 의미 보존) */
    UPDATE SCP_XLS_PSI_GLOBAL_ESS X
       SET X.LT_DAY     = (CEIL(X.LT_DAY / 7.0))
         , X.ATTRIBUTE2 = X.LT_DAY
     WHERE 0 = 0
       AND X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD   /* 2021.04.30 KSW PJ20209642 */
       AND X.MEASURE = 'CELL_PROD'
    ;

    /* 원본 L3119~L3122 : XLS_KEY1 스케일 조정 */
    UPDATE SCP_XLS_PSI_GLOBAL_ESS X
       SET X.XLS_KEY1 = X.XLS_KEY1 * 1000
     WHERE X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD   /* 2021.04.30 KSW PJ20209642 */
    ;

    /* 원본 L3129~L3142 : 프로젝트명 반영(최신 버전 1건). 원본 WHERE Y.Rn = 1 은 USING 안으로 옮긴다 */
    MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X
    USING ( SELECT PROJECT_CODE, PROJECT_NAME, DIVISION_ID
              FROM ( SELECT PROJECT_CODE
                          , PROJECT_NAME
                          , ROW_NUMBER() OVER (PARTITION BY PROJECT_CODE ORDER BY PROJECT_VER_SEQ DESC) AS RN
                          , DIVISION_ID
                       FROM SCM_MST_PROJECT )
             WHERE RN = 1 ) Y
       ON (    X.PROJECT_CODE         = Y.PROJECT_CODE
           AND X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD )  /* 2021.04.30 KSW PJ20209642 */
     WHEN MATCHED THEN UPDATE
        SET X.ATTRIBUTE8 = Y.PROJECT_NAME
    ;

    /* 원본 L3147~L3150 */
    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS
     WHERE MEASURE IN ('CELL_WORKING_TIME','PACK_WORKING_TIME')
       AND PROD_LINE = '-'
       AND CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD   /* 2021.04.30 KSW PJ20209642 */
    ;

    /* 원본 L3153~L3155 : QTY001 이 NULL 인 행의 QTY 전체를 0 으로 채운다 */
    UPDATE SCP_XLS_PSI_GLOBAL_ESS
       SET QTY001 = NVL(QTY001, 0), QTY002 = NVL(QTY002, 0), QTY003 = NVL(QTY003, 0)
         , QTY004 = NVL(QTY004, 0), QTY005 = NVL(QTY005, 0), QTY006 = NVL(QTY006, 0), QTY007 = NVL(QTY007, 0)
         , QTY008 = NVL(QTY008, 0), QTY009 = NVL(QTY009, 0), QTY010 = NVL(QTY010, 0), QTY011 = NVL(QTY011, 0)
         , QTY012 = NVL(QTY012, 0), QTY013 = NVL(QTY013, 0), QTY014 = NVL(QTY014, 0), QTY015 = NVL(QTY015, 0)
         , QTY016 = NVL(QTY016, 0), QTY017 = NVL(QTY017, 0), QTY018 = NVL(QTY018, 0), QTY019 = NVL(QTY019, 0)
         , QTY020 = NVL(QTY020, 0), QTY021 = NVL(QTY021, 0), QTY022 = NVL(QTY022, 0), QTY023 = NVL(QTY023, 0)
         , QTY024 = NVL(QTY024, 0), QTY025 = NVL(QTY025, 0), QTY026 = NVL(QTY026, 0), QTY027 = NVL(QTY027, 0)
         , QTY028 = NVL(QTY028, 0), QTY029 = NVL(QTY029, 0), QTY030 = NVL(QTY030, 0), QTY031 = NVL(QTY031, 0)
         , QTY032 = NVL(QTY032, 0), QTY033 = NVL(QTY033, 0), QTY034 = NVL(QTY034, 0), QTY035 = NVL(QTY035, 0)
         , QTY036 = NVL(QTY036, 0), QTY037 = NVL(QTY037, 0), QTY038 = NVL(QTY038, 0), QTY039 = NVL(QTY039, 0)
         , QTY040 = NVL(QTY040, 0), QTY041 = NVL(QTY041, 0), QTY042 = NVL(QTY042, 0), QTY043 = NVL(QTY043, 0)
         , QTY044 = NVL(QTY044, 0), QTY045 = NVL(QTY045, 0), QTY046 = NVL(QTY046, 0), QTY047 = NVL(QTY047, 0)
         , QTY048 = NVL(QTY048, 0), QTY049 = NVL(QTY049, 0), QTY050 = NVL(QTY050, 0), QTY051 = NVL(QTY051, 0)
         , QTY052 = NVL(QTY052, 0), QTY053 = NVL(QTY053, 0), QTY054 = NVL(QTY054, 0), QTY055 = NVL(QTY055, 0)
         , QTY056 = NVL(QTY056, 0), QTY057 = NVL(QTY057, 0), QTY058 = NVL(QTY058, 0), QTY059 = NVL(QTY059, 0)
         , QTY060 = NVL(QTY060, 0), QTY061 = NVL(QTY061, 0), QTY062 = NVL(QTY062, 0), QTY063 = NVL(QTY063, 0)
         , QTY064 = NVL(QTY064, 0), QTY065 = NVL(QTY065, 0), QTY066 = NVL(QTY066, 0), QTY067 = NVL(QTY067, 0)
         , QTY068 = NVL(QTY068, 0), QTY069 = NVL(QTY069, 0), QTY070 = NVL(QTY070, 0), QTY071 = NVL(QTY071, 0)
         , QTY072 = NVL(QTY072, 0), QTY073 = NVL(QTY073, 0), QTY074 = NVL(QTY074, 0), QTY075 = NVL(QTY075, 0)
         , QTY076 = NVL(QTY076, 0), QTY077 = NVL(QTY077, 0), QTY078 = NVL(QTY078, 0), QTY079 = NVL(QTY079, 0)
         , QTY080 = NVL(QTY080, 0), QTY081 = NVL(QTY081, 0), QTY082 = NVL(QTY082, 0), QTY083 = NVL(QTY083, 0)
         , QTY084 = NVL(QTY084, 0), QTY085 = NVL(QTY085, 0), QTY086 = NVL(QTY086, 0), QTY087 = NVL(QTY087, 0)
         , QTY088 = NVL(QTY088, 0), QTY089 = NVL(QTY089, 0), QTY090 = NVL(QTY090, 0), QTY091 = NVL(QTY091, 0)
         , QTY092 = NVL(QTY092, 0), QTY093 = NVL(QTY093, 0), QTY094 = NVL(QTY094, 0), QTY095 = NVL(QTY095, 0)
         , QTY096 = NVL(QTY096, 0), QTY097 = NVL(QTY097, 0), QTY098 = NVL(QTY098, 0), QTY099 = NVL(QTY099, 0)
         , QTY100 = NVL(QTY100, 0), QTY101 = NVL(QTY101, 0), QTY102 = NVL(QTY102, 0), QTY103 = NVL(QTY103, 0)
         , QTY104 = NVL(QTY104, 0), QTY105 = NVL(QTY105, 0), QTY106 = NVL(QTY106, 0), QTY107 = NVL(QTY107, 0)
         , QTY108 = NVL(QTY108, 0), QTY109 = NVL(QTY109, 0), QTY110 = NVL(QTY110, 0), QTY111 = NVL(QTY111, 0)
         , QTY112 = NVL(QTY112, 0), QTY113 = NVL(QTY113, 0), QTY114 = NVL(QTY114, 0), QTY115 = NVL(QTY115, 0)
         , QTY116 = NVL(QTY116, 0), QTY117 = NVL(QTY117, 0), QTY118 = NVL(QTY118, 0), QTY119 = NVL(QTY119, 0)
         , QTY120 = NVL(QTY120, 0), QTY121 = NVL(QTY121, 0), QTY122 = NVL(QTY122, 0), QTY123 = NVL(QTY123, 0)
         , QTY124 = NVL(QTY124, 0), QTY125 = NVL(QTY125, 0), QTY126 = NVL(QTY126, 0), QTY127 = NVL(QTY127, 0)
         , QTY128 = NVL(QTY128, 0), QTY129 = NVL(QTY129, 0), QTY130 = NVL(QTY130, 0), QTY131 = NVL(QTY131, 0)
         , QTY132 = NVL(QTY132, 0), QTY133 = NVL(QTY133, 0), QTY134 = NVL(QTY134, 0), QTY135 = NVL(QTY135, 0)
         , QTY136 = NVL(QTY136, 0), QTY137 = NVL(QTY137, 0), QTY138 = NVL(QTY138, 0), QTY139 = NVL(QTY139, 0)
         , QTY140 = NVL(QTY140, 0), QTY141 = NVL(QTY141, 0), QTY142 = NVL(QTY142, 0), QTY143 = NVL(QTY143, 0)
         , QTY144 = NVL(QTY144, 0), QTY145 = NVL(QTY145, 0), QTY146 = NVL(QTY146, 0), QTY147 = NVL(QTY147, 0)
         , QTY148 = NVL(QTY148, 0), QTY149 = NVL(QTY149, 0), QTY150 = NVL(QTY150, 0), QTY151 = NVL(QTY151, 0)
         , QTY152 = NVL(QTY152, 0), QTY153 = NVL(QTY153, 0), QTY154 = NVL(QTY154, 0), QTY155 = NVL(QTY155, 0)
         , QTY156 = NVL(QTY156, 0), QTY157 = NVL(QTY157, 0), QTY158 = NVL(QTY158, 0), QTY159 = NVL(QTY159, 0)
         , QTY160 = NVL(QTY160, 0), QTY161 = NVL(QTY161, 0), QTY162 = NVL(QTY162, 0), QTY163 = NVL(QTY163, 0)
         , QTY164 = NVL(QTY164, 0), QTY165 = NVL(QTY165, 0), QTY166 = NVL(QTY166, 0), QTY167 = NVL(QTY167, 0)
         , QTY168 = NVL(QTY168, 0), QTY169 = NVL(QTY169, 0), QTY170 = NVL(QTY170, 0), QTY171 = NVL(QTY171, 0)
         , QTY172 = NVL(QTY172, 0), QTY173 = NVL(QTY173, 0), QTY174 = NVL(QTY174, 0), QTY175 = NVL(QTY175, 0)
         , QTY176 = NVL(QTY176, 0), QTY177 = NVL(QTY177, 0), QTY178 = NVL(QTY178, 0), QTY179 = NVL(QTY179, 0)
         , QTY180 = NVL(QTY180, 0), QTY181 = NVL(QTY181, 0), QTY182 = NVL(QTY182, 0), QTY183 = NVL(QTY183, 0)
         , QTY184 = NVL(QTY184, 0), QTY185 = NVL(QTY185, 0), QTY186 = NVL(QTY186, 0), QTY187 = NVL(QTY187, 0)
         , QTY188 = NVL(QTY188, 0), QTY189 = NVL(QTY189, 0), QTY190 = NVL(QTY190, 0), QTY191 = NVL(QTY191, 0)
         , QTY192 = NVL(QTY192, 0), QTY193 = NVL(QTY193, 0), QTY194 = NVL(QTY194, 0), QTY195 = NVL(QTY195, 0)
         , QTY196 = NVL(QTY196, 0), QTY197 = NVL(QTY197, 0), QTY198 = NVL(QTY198, 0), QTY199 = NVL(QTY199, 0)
         , QTY200 = NVL(QTY200, 0), QTY201 = NVL(QTY201, 0), QTY202 = NVL(QTY202, 0), QTY203 = NVL(QTY203, 0)
         , QTY204 = NVL(QTY204, 0), QTY205 = NVL(QTY205, 0), QTY206 = NVL(QTY206, 0), QTY207 = NVL(QTY207, 0)
         , QTY208 = NVL(QTY208, 0), QTY209 = NVL(QTY209, 0), QTY210 = NVL(QTY210, 0), QTY211 = NVL(QTY211, 0)
         , QTY212 = NVL(QTY212, 0), QTY213 = NVL(QTY213, 0), QTY214 = NVL(QTY214, 0), QTY215 = NVL(QTY215, 0)
         , QTY216 = NVL(QTY216, 0), QTY217 = NVL(QTY217, 0), QTY218 = NVL(QTY218, 0), QTY219 = NVL(QTY219, 0)
         , QTY220 = NVL(QTY220, 0), QTY221 = NVL(QTY221, 0), QTY222 = NVL(QTY222, 0), QTY223 = NVL(QTY223, 0)
         , QTY224 = NVL(QTY224, 0), QTY225 = NVL(QTY225, 0), QTY226 = NVL(QTY226, 0), QTY227 = NVL(QTY227, 0)
         , QTY228 = NVL(QTY228, 0), QTY229 = NVL(QTY229, 0), QTY230 = NVL(QTY230, 0), QTY231 = NVL(QTY231, 0)
         , QTY232 = NVL(QTY232, 0), QTY233 = NVL(QTY233, 0), QTY234 = NVL(QTY234, 0), QTY235 = NVL(QTY235, 0)
         , QTY236 = NVL(QTY236, 0), QTY237 = NVL(QTY237, 0), QTY238 = NVL(QTY238, 0), QTY239 = NVL(QTY239, 0)
         , QTY240 = NVL(QTY240, 0), QTY241 = NVL(QTY241, 0), QTY242 = NVL(QTY242, 0), QTY243 = NVL(QTY243, 0)
         , QTY244 = NVL(QTY244, 0), QTY245 = NVL(QTY245, 0), QTY246 = NVL(QTY246, 0), QTY247 = NVL(QTY247, 0)
         , QTY248 = NVL(QTY248, 0), QTY249 = NVL(QTY249, 0), QTY250 = NVL(QTY250, 0), QTY251 = NVL(QTY251, 0)
         , QTY252 = NVL(QTY252, 0), QTY253 = NVL(QTY253, 0), QTY254 = NVL(QTY254, 0), QTY255 = NVL(QTY255, 0)
         , QTY256 = NVL(QTY256, 0), QTY257 = NVL(QTY257, 0), QTY258 = NVL(QTY258, 0), QTY259 = NVL(QTY259, 0)
         , QTY260 = NVL(QTY260, 0), QTY261 = NVL(QTY261, 0), QTY262 = NVL(QTY262, 0), QTY263 = NVL(QTY263, 0)
         , QTY264 = NVL(QTY264, 0), QTY265 = NVL(QTY265, 0), QTY266 = NVL(QTY266, 0), QTY267 = NVL(QTY267, 0)
         , QTY268 = NVL(QTY268, 0), QTY269 = NVL(QTY269, 0), QTY270 = NVL(QTY270, 0), QTY271 = NVL(QTY271, 0)
         , QTY272 = NVL(QTY272, 0), QTY273 = NVL(QTY273, 0), QTY274 = NVL(QTY274, 0), QTY275 = NVL(QTY275, 0)
         , QTY276 = NVL(QTY276, 0), QTY277 = NVL(QTY277, 0), QTY278 = NVL(QTY278, 0), QTY279 = NVL(QTY279, 0)
         , QTY280 = NVL(QTY280, 0), QTY281 = NVL(QTY281, 0), QTY282 = NVL(QTY282, 0), QTY283 = NVL(QTY283, 0)
         , QTY284 = NVL(QTY284, 0), QTY285 = NVL(QTY285, 0), QTY286 = NVL(QTY286, 0), QTY287 = NVL(QTY287, 0)
         , QTY288 = NVL(QTY288, 0), QTY289 = NVL(QTY289, 0), QTY290 = NVL(QTY290, 0), QTY291 = NVL(QTY291, 0)
         , QTY292 = NVL(QTY292, 0), QTY293 = NVL(QTY293, 0), QTY294 = NVL(QTY294, 0), QTY295 = NVL(QTY295, 0)
         , QTY296 = NVL(QTY296, 0), QTY297 = NVL(QTY297, 0), QTY298 = NVL(QTY298, 0), QTY299 = NVL(QTY299, 0)
         , QTY300 = NVL(QTY300, 0), QTY301 = NVL(QTY301, 0), QTY302 = NVL(QTY302, 0), QTY303 = NVL(QTY303, 0)
         , QTY304 = NVL(QTY304, 0), QTY305 = NVL(QTY305, 0), QTY306 = NVL(QTY306, 0), QTY307 = NVL(QTY307, 0)
         , QTY308 = NVL(QTY308, 0), QTY309 = NVL(QTY309, 0), QTY310 = NVL(QTY310, 0), QTY311 = NVL(QTY311, 0)
         , QTY312 = NVL(QTY312, 0), QTY313 = NVL(QTY313, 0), QTY314 = NVL(QTY314, 0), QTY315 = NVL(QTY315, 0)
         , QTY316 = NVL(QTY316, 0), QTY317 = NVL(QTY317, 0), QTY318 = NVL(QTY318, 0), QTY319 = NVL(QTY319, 0)
         , QTY320 = NVL(QTY320, 0), QTY321 = NVL(QTY321, 0), QTY322 = NVL(QTY322, 0), QTY323 = NVL(QTY323, 0)
         , QTY324 = NVL(QTY324, 0), QTY325 = NVL(QTY325, 0), QTY326 = NVL(QTY326, 0), QTY327 = NVL(QTY327, 0)
         , QTY328 = NVL(QTY328, 0), QTY329 = NVL(QTY329, 0), QTY330 = NVL(QTY330, 0), QTY331 = NVL(QTY331, 0)
         , QTY332 = NVL(QTY332, 0), QTY333 = NVL(QTY333, 0), QTY334 = NVL(QTY334, 0), QTY335 = NVL(QTY335, 0)
         , QTY336 = NVL(QTY336, 0), QTY337 = NVL(QTY337, 0), QTY338 = NVL(QTY338, 0), QTY339 = NVL(QTY339, 0)
         , QTY340 = NVL(QTY340, 0), QTY341 = NVL(QTY341, 0), QTY342 = NVL(QTY342, 0), QTY343 = NVL(QTY343, 0)
         , QTY344 = NVL(QTY344, 0), QTY345 = NVL(QTY345, 0), QTY346 = NVL(QTY346, 0), QTY347 = NVL(QTY347, 0)
         , QTY348 = NVL(QTY348, 0), QTY349 = NVL(QTY349, 0), QTY350 = NVL(QTY350, 0), QTY351 = NVL(QTY351, 0)
         , QTY352 = NVL(QTY352, 0), QTY353 = NVL(QTY353, 0), QTY354 = NVL(QTY354, 0), QTY355 = NVL(QTY355, 0)
         , QTY356 = NVL(QTY356, 0), QTY357 = NVL(QTY357, 0), QTY358 = NVL(QTY358, 0), QTY359 = NVL(QTY359, 0)
         , QTY360 = NVL(QTY360, 0), QTY361 = NVL(QTY361, 0), QTY362 = NVL(QTY362, 0), QTY363 = NVL(QTY363, 0)
         , QTY364 = NVL(QTY364, 0)
     WHERE QTY001 IS NULL
    ;

    /* 원본 L3175~L3186 : CELL_FORM_HOLD_AFTER 의 기초재고에서 주간 합계를 뺀다 */
    UPDATE SCP_XLS_PSI_GLOBAL_ESS X
       SET X.FROM_BOH_QTY = NVL(X.FROM_BOH_QTY, 0) -
           ( NVL(X.WQTY01, 0) + NVL(X.WQTY02, 0) + NVL(X.WQTY03, 0) + NVL(X.WQTY04, 0) + NVL(X.WQTY05, 0) + NVL(X.WQTY06, 0)
           + NVL(X.WQTY07, 0) + NVL(X.WQTY08, 0) + NVL(X.WQTY09, 0) + NVL(X.WQTY10, 0) + NVL(X.WQTY11, 0) + NVL(X.WQTY12, 0)
           + NVL(X.WQTY13, 0) + NVL(X.WQTY14, 0) + NVL(X.WQTY15, 0) + NVL(X.WQTY16, 0) + NVL(X.WQTY17, 0) + NVL(X.WQTY18, 0)
           + NVL(X.WQTY19, 0) + NVL(X.WQTY20, 0) + NVL(X.WQTY21, 0) + NVL(X.WQTY22, 0) + NVL(X.WQTY23, 0) + NVL(X.WQTY24, 0)
           + NVL(X.WQTY25, 0) + NVL(X.WQTY26, 0) + NVL(X.WQTY27, 0) + NVL(X.WQTY28, 0) + NVL(X.WQTY29, 0) + NVL(X.WQTY30, 0)
           + NVL(X.WQTY31, 0) + NVL(X.WQTY32, 0) + NVL(X.WQTY33, 0) + NVL(X.WQTY34, 0) + NVL(X.WQTY35, 0) + NVL(X.WQTY36, 0)
           + NVL(X.WQTY37, 0) + NVL(X.WQTY38, 0) + NVL(X.WQTY39, 0) + NVL(X.WQTY40, 0) + NVL(X.WQTY41, 0) + NVL(X.WQTY42, 0)
           + NVL(X.WQTY43, 0) + NVL(X.WQTY44, 0) + NVL(X.WQTY45, 0) + NVL(X.WQTY46, 0) + NVL(X.WQTY47, 0) + NVL(X.WQTY48, 0)
           + NVL(X.WQTY49, 0) + NVL(X.WQTY50, 0) + NVL(X.WQTY51, 0) + NVL(X.WQTY52, 0)
           )
     WHERE X.MEASURE = 'CELL_FORM_HOLD_AFTER'
       AND X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD   /* 2021.04.30 KSW PJ20209642 */
    ;

    /* 원본 L3194~L3198 : 2022.08.23 중장기 플랜에서 +52 주에만 ATTRIBUTE6 에 dc 정보를 남기므로 선초기화 */
    UPDATE SCP_XLS_PSI_GLOBAL_ESS
       SET ATTRIBUTE6 = NULL
     WHERE ATTRIBUTE6 IS NOT NULL
       AND CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
    ;

    /* -------------------------------------------------------------------------------------
       원본 L3200~L3244 : DC Link 모듈 정보를 ATTRIBUTE6 에 최초 기록
       ★[E20260618-001229] 2026.06.19 ymh — ESS 시뮬레이터 중복 키값 호출 로직 추가
         내부에 ROW_NUMBER() OVER(PARTITION BY Z.CHILD_ITEM_ID ORDER BY Z.CHILD_ITEM_ID, MODULE_ID)
         를 두고 RN = 1 로 걸러 **CHILD_ITEM_ID 중복을 제거**한다(이번 운영 변경분).
       ★원본 INNER HASH JOIN 의 HASH 는 MSSQL 조인 힌트라 Oracle 무대응(SOP §3.11) — 조인만 옮긴다.
       ------------------------------------------------------------------------------------- */
    MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X
    USING ( SELECT * FROM
              ( SELECT DISTINCT Z.MODEL_ID AS ITEM_ID
                     , Z.CHILD_ITEM_ID AS CELL_ITEM_ID
                     , Z.ACCUMULATED_CHILD_QTY AS CELL_QTY_PACK
                     , Y.MODULE_ID
                       /* E20260618-001229 ESS 시뮬레이터 중복 키값 호출 로직 추가 시작 */
                     , ROW_NUMBER() OVER(PARTITION BY Z.CHILD_ITEM_ID ORDER BY Z.CHILD_ITEM_ID, Y.MODULE_ID) AS RN
                       /* E20260618-001229 ESS 시뮬레이터 중복 키값 호출 로직 추가 끝 */
                  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Z
                     , ( SELECT X2.DIVISION_ID, X2.MODEL_ID, X2.CHILD_ITEM_ID AS MODULE_ID, X2.CHILD_QTY AS MODULE_QTY_PACK
                           FROM SCM_MST_BOM_SN_V X2   /* 2021-03-09 SCP 대치 BOM 적용 */
                          INNER JOIN SCM_MST_ITEM_SN I
                             ON  X2.CHILD_DIVISION_ID = I.DIVISION_ID
                            AND X2.CHILD_ITEM_ID      = I.ITEM_ID
                                /* 원본 주석 보존 : AND I.FLOW_ID = 'P5200' */
                            AND X2.CHILD_COMPANY_ID   = I.COMPANY_ID   /* A002 빈강 추가 따른 조건 추가 */
                            AND X2.CHILD_SITE_ID      = I.SITE_ID
                            AND I.ACTIVE_FLAG         = 'Y'
                          WHERE 1 = 1
                            AND X2.CHILD_ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                                        FROM SCM_MST_FINAL_ITEM_V
                                                       WHERE DIVISION_ID        = P_DIVISION_ID
                                                         AND OPERATION_GROUP_ID = 'P'
                                                         AND DC_YN              = 'Y'
                                                         AND ITEM_ID IN ( SELECT DISTINCT ITEM_ID FROM SCP_XLS_PSI_GLOBAL_ESS X3
                                                                           WHERE X3.MEASURE = 'PACK_PROD' ) )
                       ) Y
                 WHERE Z.DIVISION_ID        = Y.DIVISION_ID
                   AND Z.MODEL_ID           = Y.MODEL_ID
                   AND Z.OPERATION_GROUP_ID = 'P'
                   /* E20260618-001229 ESS 시뮬레이터 중복 키값 호출 로직 추가 시작 */
              ) Z_R WHERE RN = 1
                   /* E20260618-001229 ESS 시뮬레이터 중복 키값 호출 로직 추가 끝 */
          ) Z
       ON (    X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
           AND X.OPERATION_GROUP      = 'P'
               /* 원본 L3237~L3242 주석 보존 : AND Z.MODULE_ID IN (SELECT DISTINCT ITEM_ID FROM SCM_MST_FINAL_ITEM_V ..) */
           AND X.ITEM_ID              = Z.CELL_ITEM_ID )
     WHEN MATCHED THEN UPDATE
        SET X.ATTRIBUTE6 = (CASE WHEN X.ITEM_ID = Z.MODULE_ID THEN '1' ELSE '2' END) || '::' || Z.MODULE_ID
    ;

    /* -------------------------------------------------------------------------------------
       원본 L3248~L3265 : DC 대상 품목 수를 세고 상한을 건다
       ★[E20260618-001229] `IF @V_DC_CNT > 8 SET @V_DC_CNT = 8` 이 이번 운영 변경으로 신설됐다
         (반복 횟수 상한 = 8). 아래 WHILE 루프의 실행 횟수를 제한한다.
       ------------------------------------------------------------------------------------- */
    V_DC_CNT  := 0;
    V_ADD_CNT := 0;

    SELECT COUNT(X.ITEM_ID)
      INTO V_DC_CNT
      FROM ( SELECT DISTINCT ITEM_ID
               FROM SCM_MST_FINAL_ITEM_V
              WHERE DIVISION_ID        = P_DIVISION_ID
                AND OPERATION_GROUP_ID = 'P'
                AND DC_YN              = 'Y'
                AND ITEM_ID IN ( SELECT DISTINCT ITEM_ID FROM SCP_XLS_PSI_GLOBAL_ESS X2
                                  WHERE X2.MEASURE = 'PACK_PROD' ) ) X
    ;

    /* E20260618-001229 : 반복 상한 8 */
    IF V_DC_CNT > 8 THEN
        V_DC_CNT := 8;
    END IF;

    /* 원본 L3267~L3312 : 남은 모듈을 ATTRIBUTE6 에 '|' 로 이어 붙이며 V_DC_CNT 회 반복 */
    WHILE V_ADD_CNT < V_DC_CNT LOOP

        MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X
        USING ( SELECT DISTINCT Z.MODEL_ID AS ITEM_ID
                     , Z.CHILD_ITEM_ID AS CELL_ITEM_ID
                     , Z.ACCUMULATED_CHILD_QTY AS CELL_QTY_PACK
                     , Y.MODULE_ID
                  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Z
                     , ( SELECT X2.DIVISION_ID, X2.MODEL_ID, X2.CHILD_ITEM_ID AS MODULE_ID, X2.CHILD_QTY AS MODULE_QTY_PACK
                           FROM SCM_MST_BOM_SN_V X2   /* 2021-03-09 SCP 대치 BOM 적용 */
                          INNER JOIN SCM_MST_ITEM_SN I
                             ON  X2.CHILD_DIVISION_ID = I.DIVISION_ID
                            AND X2.CHILD_ITEM_ID      = I.ITEM_ID
                                /* 원본 주석 보존 : AND I.FLOW_ID = 'P5200' */
                            AND X2.CHILD_COMPANY_ID   = I.COMPANY_ID   /* A002 빈강 추가 따른 조건 추가 */
                            AND X2.CHILD_SITE_ID      = I.SITE_ID
                            AND I.ACTIVE_FLAG         = 'Y'
                          WHERE 1 = 1
                            AND X2.CHILD_ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                                        FROM SCM_MST_FINAL_ITEM_V
                                                       WHERE DIVISION_ID        = P_DIVISION_ID
                                                         AND OPERATION_GROUP_ID = 'P'
                                                         AND DC_YN              = 'Y'
                                                         AND ITEM_ID IN ( SELECT DISTINCT ITEM_ID FROM SCP_XLS_PSI_GLOBAL_ESS X3
                                                                           WHERE X3.MEASURE = 'PACK_PROD' ) )
                       ) Y
                 WHERE Z.DIVISION_ID        = Y.DIVISION_ID
                   AND Z.MODEL_ID           = Y.MODEL_ID
                   AND Z.OPERATION_GROUP_ID = 'P'
              ) Z
           ON (    X.CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD
               AND X.OPERATION_GROUP      = 'P'
                   /* 원본 L3300~L3305 주석 보존 : AND Z.MODULE_ID IN (SELECT DISTINCT ITEM_ID FROM SCM_MST_FINAL_ITEM_V ..) */
               AND X.ITEM_ID              = Z.CELL_ITEM_ID
                   /* LEFT(x,1) -> SUBSTR(x,1,1) */
               AND SUBSTR(X.ATTRIBUTE6, 1, 1) <> '1'
                   /* CHARINDEX(찾을것, 대상, 1) = 0  ->  INSTR(대상, 찾을것, 1) = 0 (인자 순서가 반대다) */
               AND INSTR(X.ATTRIBUTE6, ((CASE WHEN X.ITEM_ID = Z.MODULE_ID THEN '1' ELSE '2' END) || '::' || Z.MODULE_ID), 1) = 0 )
         WHEN MATCHED THEN UPDATE
            SET X.ATTRIBUTE6 = (CASE WHEN X.ATTRIBUTE6 IS NULL
                                     THEN (CASE WHEN X.ITEM_ID = Z.MODULE_ID THEN '1' ELSE '2' END) || '::' || Z.MODULE_ID
                                     ELSE X.ATTRIBUTE6 || '|' || (CASE WHEN X.ITEM_ID = Z.MODULE_ID THEN '1' ELSE '2' END) || '::' || Z.MODULE_ID
                                END)
        ;

        V_ADD_CNT := V_ADD_CNT + 1;

    END LOOP;

    /* -------------------------------------------------------------------------------------
       원본 L3315~L3323 : DC. Link 고객향 semi intransit 삭제
       ★MSSQL 다중테이블 DELETE(`DELETE X FROM A X, B M WHERE ..`) -> Oracle 은 EXISTS 로 옮긴다.
       ------------------------------------------------------------------------------------- */
    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS X
     WHERE X.MEASURE IN ('SEMI_INTRANSIT_ETA', 'SEMI_INTRANSIT')
       AND X.OPERATION_GROUP = 'P'
       AND X.ATTRIBUTE6 IS NOT NULL
       AND EXISTS ( SELECT 1 FROM SCM_MST_SITE M
                     WHERE M.SCM_SITE_ID = X.TO_SITE
                       AND M.SITE_TYPE   = 'SALES' )
    ;

    /* 원본 L3327~L3338 : 복수 BOD 수립관련건 적용 :: 2022.04.18 - SHIP_REQ 삭제 */
    DELETE
      FROM SCP_XLS_PSI_GLOBAL_ESS X
     WHERE X.MEASURE         = 'SHIP_REQ'
       AND X.OPERATION_GROUP = 'P'
       AND EXISTS ( SELECT 1 FROM GT_SCXL_BOD_OTHER_SHIP B
                     WHERE X.ITEM_ID      = B.ITEM_ID
                       AND X.FROM_SITE    = B.FROM_SITE
                       AND X.TO_SITE      = B.TO_SITE
                       AND X.BOD_ID       = B.BOD_ID
                       AND X.PROJECT_CODE = B.PROJECT_CODE
                       AND X.INCOTERMS    = B.INCOTERMS )
    ;
    /* -------------------------------------------------------------------------------------
       원본 L3343~L3357 : TXN LOG
       ★@@ROWCOUNT -> SQL%ROWCOUNT. 직전 DML(바로 위 DELETE)의 처리 건수를 그대로 쓴다.
       ------------------------------------------------------------------------------------- */
    V_LOG_TYPE    := 'TXN';
    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
    /* CONVERT(CHAR(8), @d_event_date, 112) = YYYYMMDD */
    V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
    D_EVENT_DATE  := SYSDATE;

    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER );

    /* -------------------------------------------------------------------------------------
       원본 L3386~L3388 : 실행시간(MM:SS)  ※원본 주석 "임시 운영반영시에 주석처리 할것."
       ★원본 `REPLICATE('0', 2-LEN(x)) + x` 는 x 가 3자리면 REPLICATE 가 NULL 을 돌려주고
         '+' 결합으로 **전체가 NULL** 이 된다(2026-07-23 MSSQL 실측).
         LPAD 는 반대로 왼쪽을 잘라내므로 그대로 바꾸면 값이 달라진다.
         -> 자릿수가 2를 넘는 경우 NULL 이 되도록 CASE 로 감싸 원본 거동을 재현한다.
            (선례 : PR_SCM_DNM_STOCK_OSP_V 외 3객체)
       ------------------------------------------------------------------------------------- */
    V_EXEC_TIME := CASE
                     WHEN LENGTH(TO_CHAR(TRUNC((SYSDATE - V_START_TIME) * 86400) / 60)) > 2
                       OR LENGTH(TO_CHAR(MOD(TRUNC((SYSDATE - V_START_TIME) * 86400), 60))) > 2
                     THEN NULL
                     ELSE LPAD(TO_CHAR(TRUNC(TRUNC((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0')
                          || ':' ||
                          LPAD(TO_CHAR(MOD(TRUNC((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0')
                   END;

    /* 원본 L3390~L3402 : 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '[' || P_MASTER_ID || '][' || P_ENGINE_PLAN_ID || '][' || V_EXEC_TIME || ']';
    D_EVENT_DATE  := SYSDATE;

    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER );

    /* 원본 L3403 : return 1 (정상 종료) — 계약서 §1 */
    O_RETURN_CODE := 1;
    RETURN;

EXCEPTION
    /* -------------------------------------------------------------------------------------
       원본 L3362~L3383 BEGIN CATCH
       ★원본 주석 보존 : IF @@TRANCOUNT > 0 BEGIN ROLLBACK TRAN T1 END  (주석 처리돼 있었음)
       ★원본은 예외를 흡수하고 return -1 을 돌려준다. 계약서 §1 대로 RAISE 하지 않는다.
       ------------------------------------------------------------------------------------- */
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        /* 원본 STR(ERROR_LINE()) -> Oracle 은 오류 줄번호를 직접 못 얻으므로 SQLCODE 를 남긴다 */
        V_DESCRIPTION := V_PROGRAM_NAME || 'ERROR_LINE : ' || TO_CHAR(SQLCODE);
        D_EVENT_DATE  := SYSDATE;

        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER );

        /* 원본 L3382 : return -1 (에러) — 계약서 §1. RAISE 금지(원본은 흡수) */
        O_RETURN_CODE := -1;
        RETURN;
END;