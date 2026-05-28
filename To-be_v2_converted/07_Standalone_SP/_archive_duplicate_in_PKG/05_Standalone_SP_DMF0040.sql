-- ============================================================================
-- ARCHIVED: 다음 SP들은 PKG_DMF0040 에 이미 등록되어 있어 standalone에서 제거됨
--          PKG 호출 권장: SCM_MGR.PKG_DMF0040.P_{SP_NAME}
-- ============================================================================


-- DMF0040_GET_MKT_FCST_COMPARISON → PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0040_GET_MKT_FCST_COMPARISON
(
  p_division_id    VARCHAR2,
  p_scm_site_id    VARCHAR2,
  p_plant_site_id  VARCHAR2,
  p_team_id        VARCHAR2,
  p_customer       VARCHAR2,
  p_biz_type       VARCHAR2,
  p_project_code   VARCHAR2,
  p_item_id        VARCHAR2,
  p_from_yyyymmdd  VARCHAR2,
  p_to_yyyymmdd    VARCHAR2,
  p_created_by      VARCHAR2,
  p_version_no     VARCHAR2,
  p_item_type      VARCHAR2,
  p_owner          VARCHAR2,
  p_diff_only      VARCHAR2,  -- 'True' or 'False'
  --,p_debug         OUT VARCHAR2
  p_bucket          VARCHAR2
)
/*=====================================================================================================================================================
 * Program ID   : DMF0040_GET_MKT_FCST_COMPARISON
 * Description  : MKT FCST Comparison 조회 (2개의 version으로 고객 수요 비교 화면용)
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge      Description
 *=====================================================================================================================================================
 * 2018/02/07   byunghunjung   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180618     KHSONG          QTY <> 0 으로 수정
 * 20180706                     속도개선버젼
 * 2018/07/31   Son Young Suk 검색조건 project(코드,네임 라이크 검색), model/item(코드,닉네임 라이크 검색)으로 수정
 * 2018/08/01   Son Young Suk 검색조건 version 검색할때 current 빠지게 처리
 * 20180808       KHSONG            MODIFY  실적구간 중복되어 between 에서 수식으로 수정/p_from 변수사용
 * 20180809     ytchoi          조건수정으로 속도개선
 * 20180809     JYE             멀티 오너 수정
 * 20180810     ytchoi          조회속도개선 SCM_MST_MODEL_FINAL_ITEM_BOM_V.CHILD_ITEM_ID -> SCM_MST_SITE.attribute5 컬럼사용
 * 20180816     KHSONG          VALID_YN 조건추가
 * 20180817     KHSONG          TEAM조건 인입시 속도가 느려서 수정함
 * 20180911     Son Young Suk   조회 컬럼 CELL_TYPE 추가 DM_MST_ITEM_SINGLE_V.CELL_TYPE 사용 LookUp 테이블로 명칭 조회
 * 20181101     khsong          특정기간(20181101-20190531) 조회시 에러발생으로 BUCKET_PER null조건추가
 * 181102                       속도개선을 의해서 추가
 * 20181116     JYE             PRIORITY 추가
 * 20181207     KHSONG          고객 수요 비교 화면용으로 변환
 * 20190118     KHSONG          중복제거위한 DISTINCT추가
 * 20190911     KHSONG          ITEM_ID 검색조건 보완
 * 20200624     hwi1993         성능개선을 위해 with 문을 중간에 끊고, # 테이블로 변경함.
 * 20211125     hwi1993         [C20211109-000439] [SCM PI팀] MKT FCST Comparison 내 W/S팀 수요 구현요청
 * 2021.11.25 hwi1993       프로시저 이름 변경함.
 * 2022.04.18 rosia27       과제PJ20216891RGM_JV
 * 2022.04.27 hwi1993       [] 자동차 사업부 vmi 는 mkt fcst 메저를 사용하는 관계로 관련 로직 수정
 * 2022.06.23 kdw2819       [C20220620-000557] GSCM DM 영역내, Version에 주차표기
 * 2022.07.26 kdw2819       [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
 * 2022.09.15 KDW2819       [C20220831-000365]MKT FCST Comparison 조회 로직 개선 요청 건
 * 2022.09.29 kdw2819       [C20220929-000253]MKT FCST Comparison Project 코드 조회 오류 건
 * 2023.10.25   HMIN            [E20231017-000634] [영업/마케팅 PI팀] MKT FCST Report 화면 칼럼추가 (SCP테이블정보) (요청자: 오윤종님)
 * 2024.02.15   hmin            [E20240201-001467] MKT FCST Comparison 화면 정렬 Order 개선
 * 2024.03.07   kcw3408         DM 프로시저 속도개선(CNS 전정관 책임님이 지원)
 * 2024.08.28 KJJ           [PJ2024-50461] Team Mapping
 * 2024.09.12 JSSBAE            [E20240920-000300]_SCM.DM 화면 조회 속도 개선
 * 2024.10.04 JSSBAE            [E20241002-000765]_MKT FCST Comparision 화면 Nickname 로직 검토요청
 * 2024.11.05 KJJ           [PJ2024-50461] Team Mapping -검색조건 처리 누락 수정
 * 2024.11.21 KJJ           [PJ2024-50611] Team Mapping -반영 후 오류 수정
 * 2025.07.07 KANG.H.J      [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 *===================================================================================================================================================*/
AS
    v_program_name VARCHAR2(200) := $$PLSQL_UNIT;

    v_sql_text CLOB;
    v_sql_text_result CLOB;
    v_sql_text3 CLOB;
    v_iteration CLOB;
    v_column CLOB;
    v_groupby CLOB;
    v_orderby CLOB;
    v_column_text VARCHAR2(1000 CHAR);
    v_column_name VARCHAR2(50 CHAR);
    v_column_date VARCHAR2(50 CHAR);
    v_column_type VARCHAR2(50 CHAR);
    v_column_value VARCHAR2(50 CHAR);
    v_sort_order_no VARCHAR2(50 CHAR);
    v_day_code VARCHAR2(50 CHAR);
    p_param_list VARCHAR2(4000 CHAR);
    p_end_week VARCHAR2(6 CHAR);
    v_program_id VARCHAR2(10 CHAR);
    v_sheet_name VARCHAR2(100 CHAR);
    v_groupby_column VARCHAR2(100 CHAR);
    v_week_monday VARCHAR2(8 CHAR);
    v_from_yyyymmdd VARCHAR2(1000 CHAR);
    v_to_yyyymmdd VARCHAR2(1000 CHAR);
    v_from_yyyymmdd_f VARCHAR2(1000 CHAR);
    v_to_yyyymmdd_f VARCHAR2(1000 CHAR);
    v_from_yyyymmdd_t VARCHAR2(1000 CHAR);
    v_to_yyyymmdd_t VARCHAR2(1000 CHAR);
    v_from_result_date VARCHAR2(8 CHAR);
    v_to_result_date VARCHAR2(8 CHAR);
    v_from_result VARCHAR2(1000 CHAR);
    v_to_result VARCHAR2(1000 CHAR);
    v_from_result_f VARCHAR2(1000 CHAR);
    v_to_result_f VARCHAR2(1000 CHAR);
    v_from_result_t VARCHAR2(1000 CHAR);
    v_to_result_t VARCHAR2(1000 CHAR);
    v_version_no VARCHAR2(4000 CHAR);
    v_version_no_q VARCHAR2(4000 CHAR);
    v_user_col_cnt INTEGER;
    v_user_mea_cnt INTEGER;
    v_dept_id VARCHAR2(50 CHAR);
    v_user_time_zone VARCHAR2(50 CHAR);
  ----20180626, lsh
    v_owner_sml_text VARCHAR2(4000 CHAR);
    v_owner_def_text VARCHAR2(4000 CHAR);
    p_program_id VARCHAR2(50 CHAR);
    v_group_id VARCHAR2(4000 CHAR) := NULL;
    v_DATA_SORT_METHOD_CODE VARCHAR2(50 CHAR);
    V_ORDER VARCHAR2(4000 CHAR) := NULL;
    v_step         VARCHAR2(4000 CHAR) := NULL;
    v_p_item_id    VARCHAR2(4000 CHAR);
    v_item_input       t_varchar2_tab := t_varchar2_tab();
    v_project_input    t_varchar2_tab := t_varchar2_tab();
    v_div_match_cnt NUMBER := 0; 
        V_IN_PARA_DATA VARCHAR2(4000);
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;

    CURSOR c_bucket IS
    SELECT 'D_'  ||  a.basis_yyyymmdd  AS column_name
         , a.basis_yyyymmdd AS column_date
         , 'F.YYYYMMDD'             AS column_type
         , 'F.QTY'                  AS column_value
         , a.basis_yyyymmdd  ||  '_'  ||  TO_CHAR(31) AS sort_order_no
    FROM   SCM_SYS_CALENDAR_M a
    WHERE  a.basis_yyyymmdd >= p_from_yyyymmdd
    AND    a.basis_yyyymmdd <= p_to_yyyymmdd
    AND    p_bucket != 'ONLY_WEEKLY'
    UNION ALL
    SELECT 'W_'  ||  a.basis_yyyymm  ||  a.iso_week
         , a.basis_yyyymm  ||  a.iso_week
         , 'F.YYYYMMWW'
         , 'F.QTY'
         , a.basis_start_date  ||  '_'  ||  TO_CHAR(21)
    FROM   SCM_SYS_CALENDAR_M a
    WHERE  a.basis_yyyymmdd >= p_from_yyyymmdd
    AND    a.basis_yyyymmdd <= p_to_yyyymmdd
    AND    p_bucket != 'ONLY_WEEKLY'
    GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date
    UNION ALL
    SELECT 'M_'  ||  a.basis_yyyymm
          , a.basis_yyyymm
          , 'F.YYYYMM'
          , 'F.QTY'
          , MIN(a.basis_start_date)  ||  '_'  ||  TO_CHAR(1)
    FROM    SCM_SYS_CALENDAR_M a
    WHERE  a.basis_yyyymmdd >= p_from_yyyymmdd
    AND    a.basis_yyyymmdd <= p_to_yyyymmdd
    AND    p_bucket != 'ONLY_WEEKLY'
    GROUP BY a.basis_yyyymm
    UNION ALL
    SELECT 'W_'  ||  SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK
           ,  SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK
           , 'F.YYYYMMWW'
           , 'F.QTY'
           , MAX(BASIS_YYYYMMDD) ||  '_'  || TO_CHAR(21)
    FROM   SCM_SYS_CALENDAR_M A
    WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
    AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd
    AND    p_bucket = 'ONLY_WEEKLY'
    GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME;

    CURSOR c_title IS
    SELECT U.PROGRAM_ID
         , U.SHEET_NAME
         , U.COLUMN_NAME
         , U.DATA_SORT_METHOD_CODE
    FROM   SCM_MST_TITLESET_USER U
         , SCM_MST_SHEET_COLUMNS C
    WHERE  1 = 1
    AND    U.PROGRAM_ID  = C.PROGRAM_ID
    AND    U.SHEET_NAME  = C.SHEET_NAME
    AND    U.COLUMN_NAME = C.COLUMN_NAME
    AND    U.PROGRAM_ID  = 'DMF0040'
    AND    U.SHEET_NAME  = 'Mkt Fcst Waterfall'
    AND    U.USER_ID     = p_created_by
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    AND    C.VISIBLE_FLAG = 'Y'
    UNION ALL
    SELECT C.PROGRAM_ID
         , C.SHEET_NAME
         , C.COLUMN_NAME
         , C.DATA_SORT_METHOD_CODE
    FROM   SCM_MST_SHEET_COLUMNS C
    WHERE  1 = 1
    AND    C.PROGRAM_ID  = 'DMF0040'
    AND    C.SHEET_NAME  = 'Mkt Fcst Waterfall'
    AND    C.VISIBLE_FLAG = ''
    AND    C.DEFAULT_FLAG IS NULL;
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_division_id' VALUE p_division_id,
            'p_scm_site_id' VALUE p_scm_site_id,
            'p_plant_site_id' VALUE p_plant_site_id,
            'p_team_id' VALUE p_team_id,
            'p_customer' VALUE p_customer,
            'p_biz_type' VALUE p_biz_type,
            'p_project_code' VALUE p_project_code,
            'p_item_id' VALUE p_item_id,
            'p_from_yyyymmdd' VALUE p_from_yyyymmdd,
            'p_to_yyyymmdd' VALUE p_to_yyyymmdd,
            'p_created_by' VALUE p_created_by,
            'p_version_no' VALUE p_version_no,
            'p_item_type' VALUE p_item_type,
            'p_owner' VALUE p_owner,
            'p_diff_only' VALUE p_diff_only
          );

    v_p_item_id := p_item_id;

    -- GTT TRUNCATE
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GMFC_DM_MST_ITEM_SINGLE_ORI_V';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GMFC_DM_MST_ITEM_SINGLE_A_V';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GMFC_DM_MST_ITEM_SINGLE_B_V';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GMFC_SKH_DM_MST_ITEM_SINGLE_V';
    
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GMFC_ALL_QUERY_DATA_B';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GMFC_ALL_QUERY_DATA';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GMFC_SCP_ITEM_INFO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GMFC_CALENDAR';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GMFC_TARGET_VERSION_NO';

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        v_program_name := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    p_program_id := 'DMF0040';
    v_dept_id := NULL;

  v_iteration := NULL;

  OPEN c_bucket;
  FETCH c_bucket INTO v_column_name, v_column_date, v_column_type, v_column_value, v_sort_order_no;
  LOOP
            EXIT WHEN c_bucket%NOTFOUND;
                IF SUBSTR(v_column_name, 2, 1) = 'B' THEN
                    v_column_text := ', MAX(CASE WHEN v_column_type = v_column_date THEN v_column_value ELSE NULL END) AS v_column_name ';
                ELSIF SUBSTR(v_column_name, 1, 1) = 'M' THEN  --20180517, 수정
                        v_column_text := '
                            , SUM(CASE
                                    WHEN v_column_type = v_column_date AND F.Measure NOT IN ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') THEN F.QTY
                                    WHEN v_column_type = v_column_date AND F.Measure IN  ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') AND M_LAST_D_FLAG = ''Y'' THEN F.QTY
                                    WHEN v_column_type = v_column_date AND F.Measure IN  ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') AND M_LAST_D_FLAG <> ''Y''THEN NULL
                                    ELSE NULL
                                  END) AS v_column_name';
                    ELSIF SUBSTR(v_column_name, 1, 1) = 'W' THEN
                        v_column_text := '
                            , SUM(CASE
                                    WHEN v_column_type = v_column_date AND F.Measure NOT IN ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') THEN F.QTY
                                    WHEN v_column_type = v_column_date AND F.Measure IN  ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') AND F.END_FLAG = ''Y'' THEN F.QTY
                                    WHEN v_column_type = v_column_date AND F.Measure IN  ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') AND F.END_FLAG <> ''Y'' THEN NULL
                                    ELSE NULL
                                  END) AS v_column_name';
                    ELSIF SUBSTR(v_column_name, 1, 1) = 'D' THEN
                        v_column_text := ', SUM(CASE WHEN v_column_type = v_column_date THEN v_column_value ELSE NULL END) AS v_column_name ';

                END IF;

                v_column_text := REPLACE(v_column_text,'v_column_type', v_column_type);
                v_column_text := REPLACE(v_column_text,'v_column_date', v_column_date);
                v_column_text := REPLACE(v_column_text,'v_column_value', v_column_value);
                v_column_text := REPLACE(v_column_text,'v_column_name', v_column_name);

                v_iteration := v_iteration || v_column_text;
                FETCH c_bucket INTO v_column_name, v_column_date, v_column_type, v_column_value, v_sort_order_no;
            END LOOP;

  --SELECT v_iteration AS xxxx;
  CLOSE c_bucket;

  v_column_name := NULL;
  v_column := NULL;
  v_groupby := NULL;
  v_user_col_cnt := 0;
  v_user_mea_cnt := 0;

    SELECT COUNT(*)
  INTO v_user_col_cnt
    FROM   SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = p_program_id
    AND    U.SHEET_NAME = 'Mkt Fcst Waterfall'
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    AND    U.USER_ID    = p_created_by;

    IF v_user_col_cnt = 0 THEN
        INSERT INTO SCM_MST_TITLESET_USER
        ( USER_ID
        , PROGRAM_ID
        , SHEET_NAME
        , USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME
        , SORT_ORDER_NO
        , SUB_TOTAL_FLAG
        , DATA_SORT_METHOD_CODE
        , CREATED_BY
        , CREATION_DATE
        , LAST_UPDATED_BY
        , LAST_UPDATE_DATE
        )
        SELECT p_created_by
             , C.PROGRAM_ID
             , C.SHEET_NAME
             , 'C'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , ''
             , NULL
             , p_created_by
             , TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
             , p_created_by
             , TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
        FROM   SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID  = p_program_id
        AND    C.SHEET_NAME  = 'Mkt Fcst Waterfall'
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y'
        AND    C.VISIBLE_FLAG = 'Y'  --[E20240201-001467]

        UNION ALL

        SELECT p_created_by
             , C.PROGRAM_ID
             , C.SHEET_NAME
             , 'C'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , ''
             , NULL
             , p_created_by
             , TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
             , p_created_by
             , TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
        FROM   SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID  = p_program_id
        AND    C.SHEET_NAME  = 'Mkt Fcst Waterfall'
        AND    C.VISIBLE_FLAG = ''
        AND    C.DEFAULT_FLAG IS NULL
        AND    C.VALID_YN     = 'Y';
    END IF;

    SELECT COUNT(*)
  INTO v_user_mea_cnt
    FROM   SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = p_program_id
    AND    U.SHEET_NAME = 'Mkt Fcst Waterfall'
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND    U.USER_ID    = p_created_by;

    IF v_user_mea_cnt = 0 THEN
        INSERT INTO SCM_MST_TITLESET_USER
        ( USER_ID
        , PROGRAM_ID
        , SHEET_NAME
        , USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME
        , SORT_ORDER_NO
        , SUB_TOTAL_FLAG
        , DATA_SORT_METHOD_CODE
        , CREATED_BY
        , CREATION_DATE
        , LAST_UPDATED_BY
        , LAST_UPDATE_DATE
        )
        SELECT p_created_by
             , C.PROGRAM_ID
             , C.SHEET_NAME
             , 'M'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , ''
             , NULL
             , p_created_by
             , TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
             , p_created_by
             , TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
        FROM   SCM_MST_SHEET_MEASURE C
        WHERE  1 = 1
        AND    C.PROGRAM_ID  = p_program_id
        AND    C.SHEET_NAME  = 'Mkt Fcst Waterfall'
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';

    END IF;


  OPEN c_title;
  --20240216
  --FETCH c_title INTO v_program_id, v_sheet_name, v_column_name--, v_sort_order_no
  FETCH c_title INTO v_program_id, v_sheet_name, v_column_name , v_DATA_SORT_METHOD_CODE; --, v_sort_order_no
  LOOP
  EXIT WHEN c_title%NOTFOUND;
    IF v_column IS NULL THEN
        v_column := 'F.'  ||  v_column_name;
        v_groupby := ' GROUP BY F.'  ||  v_column_name;
        --v_orderby := ' ORDER BY F.' || v_column_name;
        v_orderby := ' ORDER BY F.'  ||  v_column_name  ||  ' '  ||  v_DATA_SORT_METHOD_CODE;
    ELSE
        v_column := v_column   ||  ', F.'  ||  v_column_name;
        v_groupby := v_groupby  ||  ', F.'  ||  v_column_name;
        --v_orderby := v_orderby || ', F.' || v_column_name;
        v_orderby := v_orderby  ||  ', F.'  ||  v_column_name  ||  ' '  ||   v_DATA_SORT_METHOD_CODE;
        END IF;

    --SELECT v_iteration = v_iteration + v_column_text;
    --FETCH c_title INTO v_program_id, v_sheet_name, v_column_name--, v_sort_order_no
    FETCH c_title INTO v_program_id, v_sheet_name, v_column_name , v_DATA_SORT_METHOD_CODE;
  END LOOP;

  --Measure Sort Order No로 Sort
  v_groupby := v_groupby  ||  ', F.VERSION_SORT';
  v_orderby := v_orderby  ||  ', F.VERSION_SORT'; --20240222

  --SELECT v_column;
  --SELECT v_groupby;
  CLOSE c_title;

  v_week_monday := NULL;
  v_from_result_date := NULL;
  v_to_result_date := NULL;
  v_from_yyyymmdd := NULL;
  v_to_yyyymmdd := NULL;
  v_from_yyyymmdd_f := NULL;
  v_to_yyyymmdd_f := NULL;
  v_from_yyyymmdd_t := NULL;
  v_to_yyyymmdd_t := NULL;
  v_from_result := NULL;
  v_to_result := NULL;
  v_from_result_f := NULL;
  v_to_result_f := NULL;
  v_from_result_t := NULL;
  v_to_result_t := NULL;
  v_user_time_zone := NULL;

  BEGIN
      SELECT U.tmz_cd 
      INTO   v_user_time_zone
      FROM   SCM_ADM_USER_M U
      WHERE  U.User_ID = p_created_by;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;

  SELECT MIN(C.BASIS_YYYYMMDD)  /* 현재시점의 월요일 */
  INTO v_week_monday
  FROM   SCM_SYS_CALENDAR_M C
       , (SELECT DISTINCT ISO_YYYYWW
          FROM   SCM_SYS_CALENDAR_M
          WHERE  1 = 1
          AND    BASIS_YYYYMMDD = TO_CHAR(FN_MULTY_TIME(v_user_time_zone), 'YYYYMMDD')
         ) T
  WHERE  1 = 1
  AND    C.ISO_YYYYWW = T.ISO_YYYYWW ;

  SELECT C.BASIS_START_DATE
  INTO v_from_result_date
  FROM   SCM_SYS_CALENDAR_M      C
  WHERE  1 = 1
  AND    C.BASIS_YYYYMMDD = p_from_yyyymmdd;

  SELECT C.BASIS_START_DATE
  INTO v_to_result_date
  FROM   SCM_SYS_CALENDAR_M      C
  WHERE  1 = 1
  AND    C.BASIS_YYYYMMDD = p_to_yyyymmdd;

  v_from_yyyymmdd := v_from_result_date;  /* 조회시작일 */
  v_to_yyyymmdd := v_to_result_date;  /* 조회끝날짜 */

  IF v_week_monday > v_from_result_date THEN -- 실적 계획 보여줌
      v_from_yyyymmdd := ''''  ||  v_week_monday  ||  '''';
      v_to_yyyymmdd := ''''  ||  p_to_yyyymmdd  ||  '''';
      v_from_yyyymmdd_f := 'TO_CHAR(FN_NEXT_DAY( TO_DATE(F.CUTOFF_YYYYMMDD, ''YYYYMMDD''), ''MON'') + (-7), ''YYYYMMDD'')';
      v_to_yyyymmdd_f := ''''  ||  p_to_yyyymmdd  ||  '''';
      v_from_yyyymmdd_t := 'TO_CHAR(FN_NEXT_DAY( CAST(T.CUTOFF_YYYYMMDD as DATE), ''MON'') + (-7), ''YYYYMMDD'')';
      v_to_yyyymmdd_t := ''''  ||  p_to_yyyymmdd  ||  '''';
      v_from_result := ''''  ||  p_from_yyyymmdd  ||  '''';
      v_to_result := ''''  ||  v_week_monday  ||  '''';
      v_from_result_f := ''''  ||  p_from_yyyymmdd  ||  '''';
      v_to_result_f := 'TO_CHAR(FN_NEXT_DAY( TO_DATE(F.CUTOFF_YYYYMMDD, ''YYYYMMDD''), ''MON'') + (-7), ''YYYYMMDD'')';
      v_from_result_t := ''''  ||  p_from_yyyymmdd  ||  '''';
      v_to_result_t := 'TO_CHAR(FN_NEXT_DAY( CAST(T.CUTOFF_YYYYMMDD as DATE), ''MON'') + (-7), ''YYYYMMDD'')';

  ELSIF v_week_monday <= v_from_result_date THEN
      v_from_yyyymmdd := ''''  ||  v_week_monday  ||  '''';
      v_to_yyyymmdd := ''''  ||  p_to_yyyymmdd  ||  '''';
      v_from_yyyymmdd_f := 'TO_CHAR(FN_NEXT_DAY( TO_DATE(F.CUTOFF_YYYYMMDD, ''YYYYMMDD''), ''MON'') + (-7), ''YYYYMMDD'')';
      v_to_yyyymmdd_f := ''''  ||  p_to_yyyymmdd  ||  '''';
      v_from_yyyymmdd_t := 'TO_CHAR(FN_NEXT_DAY( CAST(T.CUTOFF_YYYYMMDD as DATE), ''MON'') + (-7), ''YYYYMMDD'')';
      v_to_yyyymmdd_t := ''''  ||  p_to_yyyymmdd  ||  '''';
      v_from_result := ''''  ||  '19000101'  ||  '''';
      v_to_result := ''''  ||  '19000101'  ||  '''';
      v_from_result_f := ''''  ||  '19000101'  ||  '''';
      v_to_result_f := ''''  ||  '19000101'  ||  '''';
      v_from_result_t := ''''  ||  '19000101'  ||  '''';
      v_to_result_t := ''''  ||  '19000101'  ||  '''';

  ELSIF v_week_monday > v_to_result_date THEN
      v_from_yyyymmdd := ''''  ||  '19000101'  ||  '''';
      v_to_yyyymmdd := ''''  ||  '19000101'  ||  '''';
      v_from_yyyymmdd_f := 'TO_CHAR(FN_NEXT_DAY( TO_DATE(F.CUTOFF_YYYYMMDD, ''YYYYMMDD''), ''MON'') + (-7), ''YYYYMMDD'')';
      v_to_yyyymmdd_f := ''''  ||  v_to_result_date  ||  '''';
      v_from_yyyymmdd_t := 'TO_CHAR(FN_NEXT_DAY( CAST(T.CUTOFF_YYYYMMDD as DATE), ''MON'') + (-7), ''YYYYMMDD'')';
      v_to_yyyymmdd_t := ''''  ||  v_to_result_date  ||  '''';
      v_from_result := ''''  ||  p_from_yyyymmdd  ||  '''';
      v_to_result := ''''  ||  v_to_result_date  ||  '''';
      v_from_result_f := ''''  ||  v_to_result_date  ||  '''';
      v_to_result_f := 'TO_CHAR(FN_NEXT_DAY( TO_DATE(F.CUTOFF_YYYYMMDD, ''YYYYMMDD''), ''MON'') + (-7), ''YYYYMMDD'')';
      v_from_result_t := ''''  ||  v_to_result_date  ||  '''';
      v_to_result_t := 'TO_CHAR(FN_NEXT_DAY( CAST(T.CUTOFF_YYYYMMDD as DATE), ''MON'') + (-7), ''YYYYMMDD'')';

  ELSIF v_week_monday = v_to_result_date THEN
      v_from_yyyymmdd := ''''  ||  v_week_monday  ||  '''';
      v_to_yyyymmdd := ''''  ||  v_week_monday  ||  '''';
      v_from_yyyymmdd_f := 'TO_CHAR(FN_NEXT_DAY( TO_DATE(F.CUTOFF_YYYYMMDD, ''YYYYMMDD''), ''MON'') + (-7), ''YYYYMMDD'')';
      v_to_yyyymmdd_f := ''''  ||  v_week_monday  ||  '''';
      v_from_yyyymmdd_t := 'TO_CHAR(FN_NEXT_DAY( CAST(T.CUTOFF_YYYYMMDD as DATE), ''MON'') + (-7), ''YYYYMMDD'')';
      v_to_yyyymmdd_t := ''''  ||  v_week_monday  ||  '''';
      v_from_result := ''''  ||  p_from_yyyymmdd  ||  '''';
      v_to_result := ''''  ||  p_to_yyyymmdd  ||  '''';
      v_from_result_f := ''''  ||  p_from_yyyymmdd  ||  '''';
      v_to_result_f := 'TO_CHAR(FN_NEXT_DAY( TO_DATE(F.CUTOFF_YYYYMMDD, ''YYYYMMDD''), ''MON'') + (-7), ''YYYYMMDD'')';
      v_from_result_t := ''''  ||  p_from_yyyymmdd  ||  '''';
      v_to_result_t := 'TO_CHAR(FN_NEXT_DAY( CAST(T.CUTOFF_YYYYMMDD as DATE), ''MON'') + (-7), ''YYYYMMDD'')';
      END IF;

      DBMS_OUTPUT.PUT_LINE('v_from_yyyymmdd ='  || v_from_yyyymmdd);
      DBMS_OUTPUT.PUT_LINE('v_to_yyyymmdd ='  || v_to_yyyymmdd);
      DBMS_OUTPUT.PUT_LINE('v_from_result ='  || v_from_result);
      DBMS_OUTPUT.PUT_LINE('v_to_result ='  || v_to_result);

    ------------------------------------------------------------------------------------------------- 20190911 ADD ITEM조회조건 속도개선 (BEGIN)
    -- 20190911 KHSONG ITEM_ID = (MCCM131012A1-M01,MCCM131012A1) 이렇게 조회시 두배로 보이는 현상으로 재 GROUP (BEGIN)
    --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
    --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 속도개선 END
    -- 20190911 마지막 자릿수에 콤마값이 들어오면 제거
    IF SUBSTR(v_p_item_id,LENGTH(v_p_item_id),1) = ',' THEN
            v_p_item_id := SUBSTR(v_p_item_id,1,LENGTH(v_p_item_id) - 1);
    END IF;
    -- 20190911 마지막 자릿수에 콤마값이 들어오면 제거
--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
--원소스 주석처리
/*
    -- GTT INSERT: GT_GMFC_SKH_DM_MST_ITEM_SINGLE_V
    INSERT INTO GT_GMFC_SKH_DM_MST_ITEM_SINGLE_V
    SELECT DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MATERIAL_CLASS_NAME
         , ITEM_UOM,SPEC,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP
         , FORECAST_INFO_CELL_MODEL,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,ACTIVE_FLAG,CELL_TYPE
        FROM
            (SELECT *
--          FROM DM_MST_ITEM_SINGLE_V T2     -- 20240312 View 제거후 scm_mst_site_item 조인
            FROM ( SELECT T1.DIVISION_ID,
                            T1.ITEM_ID,
                            MAX(T1.ITEM_NAME) ITEM_NAME,                --해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
                            MAX(T1.ITEM_CLASS) ITEM_CLASS,              --해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
                            MAX(T1.ITEM_CLASS_NAME) ITEM_CLASS_NAME,        --해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
                            MAX(T1.NICK_NAME) NICK_NAME,            --닉네임이 NULL인 경우가 있으므로 하나로 통일
                            case  min( case when T1.item_type = 'P' then 1                  --타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
                                            when T1.item_type = 'H' then 2                  --또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
                                            when T1.item_type = 'Q' then 3
                                            else 4 end )
                                                            when 1 then 'P'
                                                            when 2 then 'H'
                                                            when 3 then 'Q'
                                                            else 'R' end    AS ITEM_TYPE,
                            MAX(T1.MATERIAL_CLASS_NAME              ) MATERIAL_CLASS_NAME,
                            MAX(T1.ITEM_UOM                         ) ITEM_UOM,
                            MAX(T1.SPEC                             ) SPEC,
                            MAX(T1.MDM_PROJECT_NAME                 ) MDM_PROJECT_NAME,
                            MAX(T1.MIN_CAPACITY                     ) MIN_CAPACITY,
                            MAX(T2.FORECAST_INFO_BIZ_TYPE       ) FORECAST_INFO_BIZ_TYPE,
                            MAX(T2.FORECAST_INFO_PRODUCT_GROUP      ) FORECAST_INFO_PRODUCT_GROUP,
                            MAX(T2.FORECAST_INFO_CELL_MODEL         ) FORECAST_INFO_CELL_MODEL,
                            MAX(T2.FORECAST_INFO_CELL_PACK_COUNT    ) FORECAST_INFO_CELL_PACK_COUNT,
                            MAX(T2.FORECAST_INFO_SPEC           ) FORECAST_INFO_SPEC,
                            MAX(T2.FORECAST_INFOR_VERSION       ) FORECAST_INFOR_VERSION,
                            MAX(T1.ACTIVE_FLAG                      ) ACTIVE_FLAG,  -- 20180720 ADD 'Y'대상중 1건 추출
                            MAX(T2.CELL_TYPE                        ) CELL_TYPE,  -- 20180911 ADD cell_type
                            MAX(T1.ENERGE                       ) ENERGE,       -- 20200116 khsong ADD ENERGE
                            MAX(T1.CELL_QUANTITY                    ) CELL_QUANTITY,    -- 20200116 khsong ADD CELL_QUANTITY
                            MAX(T1.SCP_EXTRA_SPEC) SCP_EXTRA_SPEC   -- [20210428 SJHAN / CSR ID:C20210323-000420]
                      FROM SCM_MST_ITEM_SN T1
                      INNER JOIN ( SELECT T3.DIVISION_ID, SUBSTR(T3.ITEM_ID, 1, 12) ITEM_ID
                                        , MAX(T3.FORECAST_INFO_BIZ_TYPE) FORECAST_INFO_BIZ_TYPE
                                        , MAX(T3.FORECAST_INFO_PRODUCT_GROUP) FORECAST_INFO_PRODUCT_GROUP
                                        , MAX(T3.FORECAST_INFO_CELL_MODEL) FORECAST_INFO_CELL_MODEL
                                        , MAX(T3.FORECAST_INFO_CELL_PACK_COUNT) FORECAST_INFO_CELL_PACK_COUNT
                                        , MAX(T3.FORECAST_INFO_SPEC) FORECAST_INFO_SPEC
                                        , MAX(T3.FORECAST_INFOR_VERSION) FORECAST_INFOR_VERSION
                                        , MAX(T3.CELL_TYPE) CELL_TYPE
                                    FROM  SCM_MST_ITEM_SN T3
                                    INNER JOIN scm_mst_site_item T4  ON T4.DIVISION_ID = T3.DIVISION_ID AND T4.ITEM_ID = T3.ITEM_ID
                                    WHERE T3.DIVISION_ID = p_division_id  --'40'
                                    GROUP BY T3.DIVISION_ID, SUBSTR(T3.ITEM_ID, 1, 12)
                                ) T2 ON T1.DIVISION_ID = T2.DIVISION_ID
                           AND SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
                      where 1=1
                      AND T1.DIVISION_ID = p_division_id
                      --WHERE ACTIVE_FLAG = 'Y'  -- 20180720 ADD 'Y'대상만
                      --LGCE_FPDEV_TR.SCM_ITEM_M T1
                     group by T1.DIVISION_ID, T1.ITEM_ID ) T2
                WHERE DIVISION_ID = p_division_id
            ) G
    GROUP BY DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MATERIAL_CLASS_NAME,ITEM_UOM,SPEC,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP,FORECAST_INFO_CELL_MODEL,FORECAST_INFO_CELL_PACK_COUNT
    ,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,ACTIVE_FLAG,CELL_TYPE
*/
DBMS_OUTPUT.PUT_LINE('D1--'  ||  TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    --> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다.
    /* GTT:GT_GMFC_DM_MST_ITEM_SINGLE_ORI_V-->GT_GMFC_DM_MST_ITEM_SINGLE_ORI_V */
    INSERT INTO GT_GMFC_DM_MST_ITEM_SINGLE_ORI_V
    SELECT *
    FROM SCM_MST_ITEM_SN
    --FROM [10.34.221.78,7433].FP_MGR.SCM_ITEM_M
    WHERE DIVISION_ID = p_division_id;

    --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
    /* GTT:GT_GMFC_DM_MST_ITEM_SINGLE_A_V-->GT_GMFC_DM_MST_ITEM_SINGLE_A_V */
    INSERT INTO GT_GMFC_DM_MST_ITEM_SINGLE_A_V
    SELECT T1.DIVISION_ID
         , T1.ITEM_ID
         , MAX(T1.ITEM_NAME) ITEM_NAME
         , MAX(T1.ITEM_CLASS) ITEM_CLASS
         , MAX(T1.ITEM_CLASS_NAME) ITEM_CLASS_NAME
         , MAX(T1.NICK_NAME) NICK_NAME
         , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                          WHEN T1.ITEM_TYPE = 'H' THEN 2
                          WHEN T1.ITEM_TYPE = 'Q' THEN 3
                     ELSE 4 END )
                                    WHEN 1 THEN 'P'
                                    WHEN 2 THEN 'H'
                                    WHEN 3 THEN 'Q'
                                    ELSE 'R' END    AS ITEM_TYPE
         , MAX(T1.MATERIAL_CLASS_NAME) MATERIAL_CLASS_NAME
         , MAX(T1.ITEM_UOM) ITEM_UOM
         , MAX(T1.SPEC) SPEC
         , MAX(T1.MDM_PROJECT_NAME) MDM_PROJECT_NAME
         , MAX(T1.MIN_CAPACITY) MIN_CAPACITY
         , MAX(T1.ACTIVE_FLAG) ACTIVE_FLAG
         , MAX(T1.ENERGE) ENERGE
         , MAX(T1.CELL_QUANTITY) CELL_QUANTITY
         , MAX(T1.SCP_EXTRA_SPEC) SCP_EXTRA_SPEC
    FROM GT_GMFC_DM_MST_ITEM_SINGLE_ORI_V T1
    WHERE 1=1
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

    --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
    /* GTT:GT_GMFC_DM_MST_ITEM_SINGLE_B_V-->GT_GMFC_DM_MST_ITEM_SINGLE_B_V */
    INSERT INTO GT_GMFC_DM_MST_ITEM_SINGLE_B_V
    SELECT DIVISION_ID
         , SUBSTR(ITEM_ID, 1, 12) ITEM_ID
         , MAX(FORECAST_INFO_BIZ_TYPE) FORECAST_INFO_BIZ_TYPE
         , MAX(FORECAST_INFO_PRODUCT_GROUP) FORECAST_INFO_PRODUCT_GROUP
         , MAX(FORECAST_INFO_CELL_MODEL) FORECAST_INFO_CELL_MODEL
         , MAX(FORECAST_INFO_CELL_PACK_COUNT) FORECAST_INFO_CELL_PACK_COUNT
         , MAX(FORECAST_INFO_SPEC) FORECAST_INFO_SPEC
         , MAX(FORECAST_INFOR_VERSION) FORECAST_INFOR_VERSION
         , MAX(CELL_TYPE) CELL_TYPE
    FROM GT_GMFC_DM_MST_ITEM_SINGLE_ORI_V T2
    GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

    --TEMP 테이블에 넣은 데이터를 JOIN 한다.
    /* GTT:GT_GMFC_SKH_DM_MST_ITEM_SINGLE_V-->GT_GMFC_SKH_DM_MST_ITEM_SINGLE_V */
    INSERT INTO GT_GMFC_SKH_DM_MST_ITEM_SINGLE_V
    SELECT DIVISION_ID
         , ITEM_ID
         , ITEM_NAME
         , ITEM_CLASS
         , ITEM_CLASS_NAME
         , NICK_NAME
         , ITEM_TYPE
         , MATERIAL_CLASS_NAME
         , ITEM_UOM
         , SPEC
         , MDM_PROJECT_NAME
         , MIN_CAPACITY
         , FORECAST_INFO_BIZ_TYPE
         , FORECAST_INFO_PRODUCT_GROUP
         , FORECAST_INFO_CELL_MODEL
         , FORECAST_INFO_CELL_PACK_COUNT
         , FORECAST_INFO_SPEC
         , FORECAST_INFOR_VERSION
         , ACTIVE_FLAG
         , CELL_TYPE
         , ENERGE
         , CELL_QUANTITY
         , SCP_EXTRA_SPEC
    FROM
    (
        SELECT T1.DIVISION_ID
             , T1.ITEM_ID
             , T1.ITEM_NAME ITEM_NAME
             , T1.ITEM_CLASS ITEM_CLASS
             , T1.ITEM_CLASS_NAME ITEM_CLASS_NAME
             , T1.NICK_NAME NICK_NAME
             , T1.ITEM_TYPE ITEM_TYPE
             , T1.MATERIAL_CLASS_NAME MATERIAL_CLASS_NAME
             , T1.ITEM_UOM ITEM_UOM
             , T1.SPEC SPEC
             , T1.MDM_PROJECT_NAME MDM_PROJECT_NAME
             , T1.MIN_CAPACITY MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE FORECAST_INFO_BIZ_TYPE
             , T2.FORECAST_INFO_PRODUCT_GROUP FORECAST_INFO_PRODUCT_GROUP
             , T2.FORECAST_INFO_CELL_MODEL FORECAST_INFO_CELL_MODEL
             , T2.FORECAST_INFO_CELL_PACK_COUNT FORECAST_INFO_CELL_PACK_COUNT
             , T2.FORECAST_INFO_SPEC FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION FORECAST_INFOR_VERSION
             , T1.ACTIVE_FLAG ACTIVE_FLAG
             , T2.CELL_TYPE CELL_TYPE
             , T1.ENERGE ENERGE
             , T1.CELL_QUANTITY CELL_QUANTITY
             , T1.SCP_EXTRA_SPEC SCP_EXTRA_SPEC
        FROM GT_GMFC_DM_MST_ITEM_SINGLE_A_V T1
        INNER JOIN GT_GMFC_DM_MST_ITEM_SINGLE_B_V T2
                ON T1.DIVISION_ID = T2.DIVISION_ID
               AND SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
        WHERE 1=1
    ) T2
    --[E20241002-000765]_MKT FCST Comparision 화면 Nickname 로직 검토요청
    INNER JOIN ( SELECT DISTINCT '%' || value || '%' tst FROM TABLE(fn_splitstring(p_item_id,',')) ) b
            ON  T2.ITEM_ID      like  b.tst
            OR  T2.NICK_NAME    like  b.tst
            AND b.tst <> '%%'
    WHERE DIVISION_ID = p_division_id
    GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
           , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
           , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
           , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC;

--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END

    -- ITEM_INPUT: t_varchar2_tab TYPE
    SELECT DISTINCT T2.ITEM_ID
    BULK COLLECT INTO v_item_input
    FROM GT_GMFC_SKH_DM_MST_ITEM_SINGLE_V T2
    INNER JOIN ( SELECT DISTINCT '%' || value || '%' tst FROM TABLE(fn_splitstring(v_p_item_id,',')) ) b
            ON  T2.ITEM_ID   LIKE b.tst
            OR  T2.NICK_NAME LIKE b.tst
    WHERE b.tst <> '%%'
      AND T2.DIVISION_ID = p_division_id;        
    
DBMS_OUTPUT.PUT_LINE('D1A--'  ||  TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

-- 20190911 KHSONG ITEM_ID = (MCCM131012A1-M01,MCCM131012A1) 이렇게 조회시 두배로 보이는 현상으로 재 GROUP (END)
------------------------------------------------------------------------------------------------- 20190911 ADD ITEM조회조건 속도개선 (END)
--------------------------------------------------------------------------------------------------- 20190911 ADD PROJECT조회조건 속도개선 (START)

        SELECT COUNT(*) INTO v_div_match_cnt
        FROM SCM_MST_DIVISION
        WHERE ATTRIBUTE3 LIKE '81%' AND ATTRIBUTE3 = '82'
          AND DIVISION_ID = p_division_id;

        IF v_div_match_cnt > 0 THEN
            SELECT DISTINCT I.PROJECT_CODE
            BULK COLLECT INTO v_project_input
                    from scm_mst_site_item I
                    INNER JOIN GT_GMFC_SKH_DM_MST_ITEM_SINGLE_V   T2
                            ON  I.DIVISION_ID = T2.DIVISION_ID
                            AND   I.ITEM_ID     = T2.ITEM_ID
                            AND I.VALID_YN      = 'Y'
                    INNER JOIN    SCM_MST_PROJECT T3
                            ON  I.DIVISION_ID = T3.DIVISION_ID
                            AND   I.PROJECT_CODE    = T3.PROJECT_CODE
                    INNER JOIN ( SELECT DISTINCT '%' || value || '%' tst FROM TABLE(fn_splitstring(p_project_code,',')) ) c
                            ON  I.project_code  like  c.tst
                            OR  T3.project_name like  c.tst     -- 20180809 ytchoi
                    WHERE I.DIVISION_ID     = p_division_id;
        ELSE
            SELECT DISTINCT I.PROJECT_CODE
            BULK COLLECT INTO v_project_input
                    from scm_mst_site_item I
                    INNER JOIN GT_GMFC_SKH_DM_MST_ITEM_SINGLE_V   T2
                            ON  I.DIVISION_ID = T2.DIVISION_ID
                            AND   I.ITEM_ID     = T2.ITEM_ID
                            AND I.VALID_YN      = 'Y'
                    INNER JOIN ( SELECT DISTINCT '%' || value || '%' tst FROM TABLE(fn_splitstring(p_project_code,',')) ) c
                            ON  I.project_code  like  c.tst
                    WHERE I.DIVISION_ID     = p_division_id;
        END IF;

--------------------------------------------------------------------------------------------------- 20190911 ADD PROJECT조회조건 속도개선 (END)
    v_sql_text := '

        /* [E20231017-000634] */
        --INSERT INTO GT_GMFC_SCP_ITEM_INFO (DIVISION_ID, ITEM_ID,    CELL_NICKNAME, BASIC_NICKNAME_CELL40, NICKNAME_40
        --                    , GROUP_CODE1, GROUP_CODE4, GROUP_CODE5,   GROUP_CODE6, GROUP_CODE7
        --                    , CELL_TYPE_GROUP_NAME)
        --SELECT *
        INSERT INTO GT_GMFC_SCP_ITEM_INFO
        SELECT DIVISION_ID, ITEM_ID, CELL_NICKNAME, BASIC_NICKNAME_CELL40, NICKNAME_40, GROUP_CODE1, GROUP_CODE4, GROUP_CODE5,
                GROUP_CODE6, GROUP_CODE7 , CELL_TYPE_GROUP_NAME
        FROM (
            SELECT  SCP_P.DIVISION_ID
                    , SCP_P.ITEM_ID
                    , SCP_P.CELL_NICKNAME
                    , SCP_P.BASIC_NICKNAME_CELL40
                    , SCP_P.NICKNAME_40
                    , SCP_P.GROUP_CODE1
                    , SCP_P.GROUP_CODE4
                    , SCP_P.GROUP_CODE5
                    , SCP_P.GROUP_CODE6
                    , SCP_P.GROUP_CODE7
                    , CASE WHEN SCP_P.LEVEL_EXCEPT = ''EC'' THEN ''POUCH''
                            WHEN SCP_P.LEVEL_EXCEPT = ''AM'' THEN ''CYLINDRICAL''
                            WHEN SUBSTR(SCP_P.ITEM_ID, 3, 1) = ''M'' AND SCP_P.OPERATION_ID = ''P9500'' THEN ''POUCH''
                    ELSE SCP_G.CELL_TYPE_GROUP_NAME END AS CELL_TYPE_GROUP_NAME
            FROM (  /* #TBLDYNAMICPIVOT_SCP0017_PRE */
                    SELECT DIVISION_ID
                        , FLOW_ID OPERATION_ID
                        , ITEM_ID
                        , SUBSTR(A.ITEM_ID, 3, 1) CELL_TYPE_CODE
                        , SUBSTR(A.ITEM_ID, 1, 2) LEVEL_EXCEPT -- 예외적용
                        , CASE WHEN SUBSTR(A.DIVISION_ID, 1, 2) = ''81''  THEN GROUP_CODE1
                                WHEN A.DIVISION_ID = ''82''                  THEN LEVEL2_CODE
                            ELSE '''' END AS CELL_NICKNAME
                        , CASE WHEN SUBSTR(A.ITEM_ID, 1, 2) = ''EC'' THEN ''ESS''
                                WHEN SUBSTR(A.ITEM_ID, 1, 2) = ''AM'' THEN ''M50L''
                            ELSE CASE WHEN A.OPERATION_GROUP = ''P'' THEN (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT DOE FROM SCM_MST_ITEM_SN B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1 AND B.DOE IS NOT NULL AND ROWNUM = 1) AND ROWNUM = 1)
                                    ELSE (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B  WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT  DOE FROM SCM_MST_ITEM_SN B  WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL AND ROWNUM = 1) AND ROWNUM = 1) END
                            END  AS BASIC_NICKNAME_CELL40
                        , A.NICK_NAME NICKNAME_40
                        , A.GROUP_CODE4
                        , A.GROUP_CODE5
                        , A.GROUP_CODE6
                        , A.GROUP_CODE7
                        , A.GROUP_CODE1
                        , CASE WHEN A.FLOW_ID IN (''A3000'', ''A9000'') THEN ''C'' ELSE ''E'' END  AS FLOW_TYPE
                    FROM    SCP_MST_FINAL_ITEM A
                    WHERE   1=1
                        AND (SUBSTR(A.ATTRIBUTE8, 1, 2) <> ''CA'' OR A.ATTRIBUTE8 IS NULL OR A.ATTRIBUTE8 IS NULL) --활성화코드 분리
                        AND A.DIVISION_ID = ''' || p_division_id || '''
            ) SCP_P
            LEFT OUTER JOIN (
                            /* #TBLDYNAMICPIVOT_SCP0017_CELL_TYPE_GROUP */
                            SELECT  A.CODE                    AS CELL_TYPE_CODE
                                , SUBSTR(A.NAME, 1, 1) FLOW_TYPE
                                , A.GROUP_CODE CELL_TYPE_GROUP_CODE
                                , G.NAME CELL_TYPE_GROUP_NAME
                                , A.DISPLAY_SEQ
                            FROM
                            (
                                SELECT    B.SEGMENT1 CODE
                                        , B.SEGMENT2 NAME
                                        , B.SEGMENT3 GROUP_CODE
                                        , B.DISPLAY_SEQ
                                FROM    SCM_ADM_LOOKUP_MASTER A
                                JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE
                                AND B.VALID_YN = ''Y''
                                WHERE   1=1
                                    AND A.LOOKUP_TYPE = ''CELL_TYPE_ITEM_CODE''
                                    AND A.VALID_YN = ''Y''
                            ) A
                            JOIN
                            (
                                SELECT    B.SEGMENT1 CODE
                                        , B.SEGMENT2 NAME
                                FROM    SCM_ADM_LOOKUP_MASTER A
                                JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = ''Y''
                                WHERE   1=1
                                    AND A.LOOKUP_TYPE = ''CELL_TYPE_ITEM_GROUP''
                                    AND A.VALID_YN = ''Y''
                            ) G ON A.GROUP_CODE = G.CODE
            ) SCP_G ON SCP_G.FLOW_TYPE = SCP_P.FLOW_TYPE AND SCP_G.CELL_TYPE_CODE  = SCP_P.CELL_TYPE_CODE
        )  T;
        /* */
            /* GTT:GT_GMFC_CALENDAR-->GT_GMFC_CALENDAR */
            INSERT INTO GT_GMFC_CALENDAR
            SELECT A.BASIS_YYYYMMWW, A.ISO_YYYYWW, A.ISO_WEEK, B.BASIS_YYYYMMDD, B.END_FLAG, B.BASIS_YYYYMM, B.DAYOFWEEK
            FROM (
                SELECT SUBSTR(MAX(BASIS_YYYYMMDD),1,6) + ISO_WEEK AS BASIS_YYYYMMWW, ISO_YYYYWW,  ISO_WEEK
                FROM SCM_SYS_CALENDAR_M
                WHERE BASIS_YYYYMMDD >= ''' || p_from_yyyymmdd || '''
                AND   BASIS_YYYYMMDD <= ''' || p_to_yyyymmdd || '''
                GROUP BY  ISO_YYYYWW, ISO_WEEK
            ) A
            JOIN SCM_SYS_CALENDAR_M B
                ON  A.ISO_YYYYWW = B.ISO_YYYYWW
                AND A.ISO_WEEK = B.ISO_WEEK;

            /* GTT:GT_GMFC_TARGET_VERSION_NO-->GT_GMFC_TARGET_VERSION_NO */
            INSERT INTO GT_GMFC_TARGET_VERSION_NO
            SELECT
                value AS VERSION_NO
                , CASE  WHEN row_number() OVER (ORDER BY  VERSION_NO_SORT DESC) = 1 THEN ''Version(A)''
                        WHEN row_number() OVER (ORDER BY  VERSION_NO_SORT DESC) = 2 THEN ''Version(B)''
                        ELSE ''VERSION_X''
                        END AS VERSION_TYPE
            FROM
                (SELECT CASE WHEN value = ''Current'' THEN ''Z''
                            ELSE ''X''||SUBSTR(value,6,13)
                            END
                            AS VERSION_NO_SORT
                    ,value
                    FROM (SELECT  SUBSTR(value, 1, CASE WHEN INSTR(value,''('') = 0 THEN LENGTH(value) ELSE INSTR(value,''('')-1 END) AS VALUE
                    FROM TABLE(fn_splitstring(''p_version_no'' ,'',''))) B) A;

            /* GTT:GT_GMFC_TARGET_SITE_ITEM-->GT_GMFC_TARGET_SITE_ITEM */
            INSERT INTO GT_GMFC_TARGET_SITE_ITEM
            SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID, T2.NICK_NAME, T3.PROJECT_NAME
                    ,'''' cell_model        -- 20180809 ytchoi
                    ,S.VMI_YN, CASE WHEN S.OPERATION_GROUP = ''W'' THEN ''Y'' ELSE '''' END AS AS_YN, F.VALID_YN
                    ,F.OWNER
                    , FN_GET_DM_MKT_OWNER_NAME (F.OWNER, '','', ''EN'') OWNER_NAME
                    , FN_GET_DM_MKT_OWNER_NAME (F.OWNER, '','', ''KO'') OWNER_NAME_KO
            FROM SCM_MST_SITE_ITEM F
            INNER JOIN GT_GMFC_SKH_DM_MST_ITEM_SINGLE_V   T2
                    ON  F.DIVISION_ID = T2.DIVISION_ID
                    AND   F.ITEM_ID     = T2.ITEM_ID
            LEFT OUTER JOIN SCM_MST_PROJECT   T3
                    ON  F.DIVISION_ID = T3.DIVISION_ID
                    AND   F.PROJECT_CODE    = T3.PROJECT_CODE
                    sp_item_id
                    sp_project_code
            INNER JOIN    SCM_MST_SITE  s
                    ON  F.DIVISION_ID    = s.DIVISION_ID
                    AND   F.SCM_SITE_ID    = s.SCM_SITE_ID
            WHERE F.DIVISION_ID <> ''40'' -- hard coding
                    v_division_id
                    v_scm_site_id
            UNION ALL
            SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID, T2.NICK_NAME, F.PROJECT_CODE
                    ,f.attribute5 cell_model  -- 20180810 ytchoi 조회속도개선 SCM_MST_MODEL_FINAL_ITEM_BOM_V.CHILD_ITEM_ID -> SCM_MST_SITE.attribute5 컬럼사용
                    ,S.VMI_YN, CASE WHEN S.OPERATION_GROUP = ''W'' THEN ''Y'' ELSE '''' END AS AS_YN, F.VALID_YN, F.OWNER
                    , FN_GET_DM_MKT_OWNER_NAME (F.OWNER, '','', ''EN'') OWNER_NAME
                    , FN_GET_DM_MKT_OWNER_NAME (F.OWNER, '','', ''KO'') OWNER_NAME_KO
            FROM SCM_MST_SITE_ITEM F
            INNER JOIN GT_GMFC_SKH_DM_MST_ITEM_SINGLE_V   T2
                    ON  F.DIVISION_ID = T2.DIVISION_ID
                    AND   F.ITEM_ID     = T2.ITEM_ID
                    AND F.VALID_YN = ''Y''
                    sp_item_id
                    --sp_project_code
            INNER JOIN    SCM_MST_SITE  s
                    ON  F.DIVISION_ID    = s.DIVISION_ID
                    AND   F.SCM_SITE_ID    = s.SCM_SITE_ID
            WHERE F.DIVISION_ID = ''40'' -- hard coding
                    v_division_id
                    v_scm_site_id
            ;

            /* GTT:GT_GMFC_ALL_QUERY_DATA_B-->GT_GMFC_ALL_QUERY_DATA_B */
            INSERT INTO GT_GMFC_ALL_QUERY_DATA_B
            SELECT ''Current'' AS VERSION_NO, F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                , F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY
                , T2.cell_model     -- 20180809 ytchoi
            FROM DM_PLN_MKT_FCST       F
            LEFT OUTER JOIN GT_GMFC_TARGET_SITE_ITEM    T2
                ON  F.DIVISION_ID = T2.DIVISION_ID
                AND   F.project_code = T2.project_code
                AND   F.SCM_SITE_ID = T2.SCM_SITE_ID
                AND   F.ITEM_ID   = T2.ITEM_ID
                -- AND T2.VALID_YN = ''Y''
            INNER JOIN SCM_MST_SITE C
                ON F.DIVISION_ID = C.DIVISION_ID
                AND F.SCM_SITE_ID = C.SCM_SITE_ID
                AND C.VALID_YN = ''Y''
            WHERE F.QTY <> 0
                AND T2.VALID_YN = ''Y''
                and f.YYYYMMDD between v_from_yyyymmdd and v_to_yyyymmdd  /* 현재시점의 월요일 부터 조회끝날짜 */
                -- AND MEASURE = CASE WHEN T2.VMI_YN = ''Y'' AND F.DIVISION_ID NOT LIKE ''81%''  THEN ''VMI_In_Req'' ELSE ''MKT_FCST'' END
                AND MEASURE = CASE WHEN T2.VMI_YN = ''Y'' AND F.DIVISION_ID NOT LIKE ''81%''  THEN ''VMI_In_Req''
                    WHEN T2.AS_YN = ''Y'' THEN ''AS_IN_REQ''
                    ELSE ''MKT_FCST'' END
            v_division_id
                --  v_current -- 20180801 add son young suk 검색조건 version 검색할때 current 빠지게 처리  -- 20180809 ytchoi
                v_scm_site_id
                v_plant_site_id
                --v_item_id
            v_project_code
            UNION ALL   -- 20180809 ytchoi
            SELECT ''Current'' AS VERSION_NO, F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                , F.INCOTERMS, F.MEASURE, F.YYYYMMDD
                --, QTY
                , SUM(F.QTY) QTY        -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
                , T2.cell_model     -- 20180809 ytchoi
            FROM DM_PLN_MKT_FCST_RESULT   F
            LEFT OUTER JOIN GT_GMFC_TARGET_SITE_ITEM    T2
                ON  F.DIVISION_ID = T2.DIVISION_ID
                AND   F.project_code = T2.project_code
                AND   F.SCM_SITE_ID = T2.SCM_SITE_ID
                AND   F.ITEM_ID   = T2.ITEM_ID
            WHERE F.QTY <> 0
                and f.YYYYMMDD >= v_from_result and f.YYYYMMDD < v_to_result  -- 20180808 MODIFY
                AND MEASURE = CASE WHEN T2.VMI_YN = ''Y'' AND F.DIVISION_ID NOT LIKE ''81%''  THEN ''VMI_In_Req''
                    WHEN T2.AS_YN = ''Y'' THEN ''AS_IN_REQ''
                    ELSE ''RTF'' END
            v_division_id
                --  v_current -- 20180801 add son young suk 검색조건 version 검색할때 current 빠지게 처리        -- 20180809 ytchoi
                v_scm_site_id
                v_plant_site_id
                --v_item_id
            v_project_code
            -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 START
            GROUP BY  F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                , F.INCOTERMS, F.MEASURE, F.YYYYMMDD
                , T2.cell_model
            -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 END
            UNION ALL    -- 20180809 ytchoi
            SELECT F.VERSION_NO, F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                , F.INCOTERMS, F.MEASURE, F.YYYYMMDD
                --, QTY
                , SUM(F.QTY) QTY        -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
                , T2.cell_model     -- 20180809 ytchoi
            FROM DM_PLN_MKT_FCST_RESULT_C       F
            LEFT OUTER JOIN GT_GMFC_TARGET_SITE_ITEM    T2
                ON  F.DIVISION_ID = T2.DIVISION_ID
                AND   F.project_code = T2.project_code
                AND   F.SCM_SITE_ID = T2.SCM_SITE_ID
                AND   F.ITEM_ID   = T2.ITEM_ID
            WHERE F.QTY <> 0
                and f.YYYYMMDD >= v_from_result_f and f.YYYYMMDD < v_to_result_f  -- 20180808 MODIFY
                AND MEASURE = CASE WHEN T2.VMI_YN = ''Y'' AND F.DIVISION_ID NOT LIKE ''81%''  THEN ''VMI_In_Req''
                    WHEN T2.AS_YN = ''Y'' THEN ''AS_IN_REQ''
                    ELSE ''RTF'' END
            v_division_id
                AND F.VERSION_NO IN (SELECT VERSION_NO FROM GT_GMFC_TARGET_VERSION_NO)
                v_scm_site_id
                v_plant_site_id
                --v_item_id
            v_project_code
            -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 START
            GROUP BY F.VERSION_NO, F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                , F.INCOTERMS, F.MEASURE, F.YYYYMMDD
                , T2.cell_model
            -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 END
            UNION ALL    -- 20180809 ytchoi
            SELECT F.VERSION_NO, F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                , F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY
                , T2.cell_model     -- 20180809 ytchoi
            FROM DM_PLN_MKT_FCST_C       F
            LEFT OUTER JOIN GT_GMFC_TARGET_SITE_ITEM    T2
                ON  F.DIVISION_ID = T2.DIVISION_ID
                AND   F.project_code = T2.project_code
                AND   F.SCM_SITE_ID = T2.SCM_SITE_ID
                AND   F.ITEM_ID   = T2.ITEM_ID
            INNER JOIN SCM_MST_SITE C 
                ON F.DIVISION_ID = C.DIVISION_ID
                AND F.SCM_SITE_ID = C.SCM_SITE_ID
                AND C.VALID_YN = ''Y''
            WHERE F.QTY <> 0
                and f.YYYYMMDD >= v_from_yyyymmdd_f -- TO_CHAR(FN_NEXT_DAY( TO_DATE(F.CUTOFF_YYYYMMDD, ''YYYYMMDD''), ''MON'') + (-7), ''YYYYMMDD'')  /* CUTOFF DATE의 월요일 */
                and f.YYYYMMDD <= v_to_yyyymmdd_f
                AND MEASURE = CASE WHEN T2.VMI_YN = ''Y'' AND F.DIVISION_ID NOT LIKE ''81%''  THEN ''VMI_In_Req''
                    WHEN T2.AS_YN = ''Y'' THEN ''AS_IN_REQ''
                    ELSE ''MKT_FCST'' END
            v_division_id
                AND F.VERSION_NO IN (SELECT VERSION_NO FROM GT_GMFC_TARGET_VERSION_NO)
                v_scm_site_id
                v_plant_site_id
                --v_item_id
            v_project_code
            ; 

            -- Owner filter (was inside dynamic SQL, now PL/SQL IF)
            IF ''' ||  p_owner  ||  ''' <> '''' THEN
                    DELETE FROM GT_GMFC_ALL_QUERY_DATA_B A
                    WHERE NOT EXISTS (
                        SELECT 1
                        FROM GT_GMFC_TARGET_SITE_ITEM B,
                             TABLE(fn_splitstring(p_owner, '','')) T
                        WHERE B.ITEM_ID = A.ITEM_ID
                          AND B.SCM_SITE_ID = A.SCM_SITE_ID
                          AND B.PROJECT_CODE = A.PROJECT_CODE
                          AND (   B.OWNER        LIKE ''%'' || T.value || ''%''
                               OR B.OWNER_NAME   LIKE ''%'' || T.value || ''%''
                               OR B.OWNER_NAME_KO LIKE ''%'' || T.value || ''%'')
                    );
            END IF;                

		INSERT INTO GT_GMFC_ALL_QUERY_DATA
        WITH ALL_QUERY_DATA AS (

            v_diff_only  /* p_diff_only = False 인경우만 쿼리실행 */

            SELECT '''' VERSION_NO , DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,YYYYMMDD, ''Difference'' MEASURE, SUM( CASE WHEN V.VERSION_TYPE = ''Version(A)'' THEN QTY ELSE -QTY END) QTY, cell_model
              FROM GT_GMFC_ALL_QUERY_DATA_B B
                INNER JOIN GT_GMFC_TARGET_VERSION_NO V
                    ON B.VERSION_NO = V.VERSION_NO
             GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,YYYYMMDD,cell_model
        )
        SELECT * FROM ALL_QUERY_DATA;

        -- SELECT * FROM GT_GMFC_ALL_QUERY_DATA    WHERE SCM_SITE_ID IN (''BMW_DE_NBH'',''Ford AS_DE_QKL'',''VW_CZ_MBV'') AND VERSION_NO <> ''Current'';
        with MKT_FCST as (
        select
           a.VERSION_NO
          , CASE WHEN A.MEASURE = ''Version(A)'' THEN ''1''
                 WHEN A.MEASURE = ''Version(B)'' THEN ''2''
                 ELSE ''Z''
               END  AS VERSION_SORT
          ,a.DIVISION_ID
          ,a.DIVISION_ID DIVISION_ID40

          --[PJ2024-50461] Team Mapping------------------------------------
          /*
          , CASE WHEN A.DIVISION_ID = ''40'' THEN TEAM.DEPT_ID ELSE k.DEPT_ID END  AS DEPT_ID   -- 20180809
            , CASE WHEN A.DIVISION_ID = ''40'' THEN TEAM.DEPT_NAME_KO ELSE k.DEPT_NAME_KO END DEPT_NAME_KO  -- 20180809
          , CASE WHEN A.DIVISION_ID = ''40'' THEN TEAM.DEPT_ID ELSE k.DEPT_ID END  AS TEAM_ID   -- 20180809
            , CASE WHEN A.DIVISION_ID = ''40'' THEN TEAM.DEPT_NAME_KO ELSE k.DEPT_NAME_KO END TEAM_NAME_KO  -- 20180809
          */
          , TEAM.DEPT_ID
            , TEAM.DEPT_NAME_KO
          , TEAM.DEPT_ID TEAM_ID
            , NVL(TEAM.DEPT_NAME_KO, '''') TEAM_NAME_KO  --[PJ2024-50611] 정렬시 사용하는 컬럼인데 하드코딩이 되어져 있음. null 방지 처리함
          --[PJ2024-50461] Team Mapping------------------------------------
          , g.END_CUSTOMER
          , a.PROJECT_CODE END_CUSTOMER40
          , f.BIZ_TYPE BIZ_TYPE
          , g.SOLDTO_CUSTOMER
          , i.COUNTRY
          , i.COUNTRY_NAME
          , h.CITY
          , h.CITY_NAME
          , a.SCM_SITE_ID
          , a.SCM_SITE_ID SCM_SITE_ID40
          , a.PLANT_SITE_ID
          , a.PROJECT_CODE
          , f.PROJECT_NAME
          , FN_GET_MULTI_OWNER_NAME(e.OWNER, '','', ''1'') OWNER  -- 20180817
          , CASE WHEN a.division_id <> ''40'' THEN f.PROJECT_OWNER ELSE j.USER_NAME_EN end AS PROJECT_OWNER -- 20180705
          , J.USER_ID
          --20180809 ytchoi modify(e)
          , a.ITEM_ID
          , a.ITEM_ID ITEM_ID40
          , l.ITEM_NAME
          , l.NICK_NAME NICK_NAME
          , a.INCOTERMS
          , l.ITEM_TYPE
          , a.FCST_TYPE
          , a.DOM_EXP
          , f.PROJECT_STATUS
          , a.MEASURE
          , c.BASIS_YYYYMM YYYYMM
          , CASE WHEN ''' || p_bucket || ''' = ''ONLY_WEEKLY'' THEN c.BASIS_YYYYMMWW ELSE c.BASIS_YYYYMM || c.ISO_WEEK END AS YYYYMMWW
          , C.BASIS_YYYYMMDD YYYYMMDD
          , C.DAYOFWEEK
          , case when m.BUCKET_PER = ''Y'' then ''Y'' when m.BUCKET_PER = '''' then '''' else null end AS PER  -- 20181101 khsong add
          , d.QTY
          , c.END_FLAG
          , e.CUST_GROUP
          , e.CUST_GROUP_DTL
          , e.APPLICATION
          , e.ROUTE
          -- 20180711 추가
          , l.MDM_PROJECT_NAME
          , l.MIN_CAPACITY
          , l.FORECAST_INFO_BIZ_TYPE
          , l.FORECAST_INFO_PRODUCT_GROUP
          , a.FORECAST_INFO_CELL_MODEL FORECAST_INFO_CELL_MODEL     -- 20180809 ytchoi
          , LOOK.NAME CELL_TYPE --20180911 LookUp 테이블 조인으로 CELL_TYPE 명칭
          , l.FORECAST_INFO_CELL_PACK_COUNT
          , l.FORECAST_INFO_SPEC || l.FORECAST_INFOR_VERSION as FORECAST_INFO_SPEC
          , g.VMI_YN  -- 20180719
          , CASE WHEN
                C.BASIS_YYYYMMDD = TO_CHAR(LAST_DAY(TO_DATE(C.BASIS_YYYYMMDD, ''YYYYMMDD'')), ''YYYYMMDD'') THEN ''Y''
            ELSE '''' END M_LAST_D_FLAG
          , CASE WHEN a.DIVISION_ID = ''40'' THEN
               CASE WHEN
               --[PJ2024-50461] Team Mapping------------------------------------
                --(( a.MEASURE in ( ''MKT_FCST_RP'',  ''RTF'' ,  ''CUST_FCST'' ,  ''VMI_IN_Req''   )) AND ((FN_GET_DEPT_LIST(''p_created_by'', k.DEPT_ID) = ''Y''))) --20180809 ytchoi modify
                (( a.MEASURE in ( ''MKT_FCST_RP'',  ''RTF'' ,  ''CUST_FCST'' ,  ''VMI_IN_Req''   )) AND ((FN_GET_DEPT_LIST(''p_created_by'', TEAM.DEPT_ID) = ''Y'')))
                --[PJ2024-50461] Team Mapping------------------------------------
              OR ( ( a.MEASURE in ( ''MKT_FCST_RP'',  ''RTF'' ,  ''CUST_FCST'' ,  ''VMI_IN_Req''   )) AND (''v_group_id'' =''ADMIN''))
               THEN ''Y'' ELSE '''' END
            END  AS EDIT_FLAG

          , CASE WHEN a.DIVISION_ID = ''40'' AND g.VMI_YN = ''Y'' AND a.MEASURE = ''VMI_In_Req'' THEN ''Y''
                 WHEN a.DIVISION_ID = ''40'' AND g.VMI_YN = '''' AND a.MEASURE = ''MKT_FCST_RP'' THEN ''Y''
            ELSE '''' END SCP_USE_YN
          , e.ATTRIBUTE7 PRIORITY  --201811116
        --[E20231017-000634] SCP정보수집
        , SCP.CELL_NICKNAME CELL_NICKNAME  --20231025
        , CASE WHEN SUBSTR(A.DIVISION_ID, 1,2) = ''81'' OR A.DIVISION_ID = ''82'' THEN SCP.GROUP_CODE6
          ELSE SCP.CELL_TYPE_GROUP_NAME END AS PRODUCT_LEVEL1
        , CASE WHEN SUBSTR(A.DIVISION_ID, 1,2) = ''81'' OR A.DIVISION_ID = ''82'' THEN SCP.GROUP_CODE7
          ELSE SCP.BASIC_NICKNAME_CELL40 END AS PRODUCT_LEVEL2
        , CASE WHEN SUBSTR(A.DIVISION_ID, 1,2) = ''81'' THEN SCP.GROUP_CODE5
               WHEN A.DIVISION_ID = ''82''                 THEN SCP.GROUP_CODE4
          ELSE SCP.NICKNAME_40 END AS PRODUCT_LEVEL3
  from (
        select distinct  F.VERSION_NO, F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                             , F.INCOTERMS, F.MEASURE
                             , CELL_MODEL FORECAST_INFO_CELL_MODEL      -- 20180809 ytchoi
          from GT_GMFC_ALL_QUERY_DATA F
          sp_project_code_join
        where 1=1   -- 20180809 ytchoi
         --v_version_no_q   -- 20181207
       ) a
 INNER JOIN GT_GMFC_CALENDAR c
        ON 1 = 1
 LEFT JOIN GT_GMFC_ALL_QUERY_DATA d
       ON  a.DIVISION_ID    = d.DIVISION_ID
       AND a.PROJECT_CODE   = d.PROJECT_CODE
       and a.SCM_SITE_ID    = d.SCM_SITE_ID
       and a.PLANT_SITE_ID  = d.PLANT_SITE_ID
       and a.ITEM_ID        = d.ITEM_ID
       and a.DOM_EXP        = d.DOM_EXP
       and a.FCST_TYPE      = d.FCST_TYPE
       and a.INCOTERMS      = d.INCOTERMS
       and a.MEASURE        = d.MEASURE
       and c.BASIS_YYYYMMDD = d.YYYYMMDD
       and a.VERSION_NO     = d.VERSION_NO
 INNER JOIN SCM_MST_SITE_ITEM e
       ON  a.DIVISION_ID    = e.DIVISION_ID
       and a.SCM_SITE_ID    = e.SCM_SITE_ID
       and a.PROJECT_CODE   = e.PROJECT_CODE
       and a.ITEM_ID        = e.ITEM_ID
 LEFT JOIN SCM_MST_PROJECT f
       ON  a.DIVISION_ID    = f.DIVISION_ID
       and a.PROJECT_CODE   = f.PROJECT_CODE
 LEFT OUTER JOIN SCM_MST_SITE g
       ON  a.DIVISION_ID    = g.DIVISION_ID
       and a.SCM_SITE_ID    = g.SCM_SITE_ID
 LEFT OUTER JOIN SCM_MST_CITY h
       ON  g.CITY           = h.CITY
 LEFT OUTER JOIN SCM_MST_COUNTRY i
       ON  g.COUNTRY        = i.COUNTRY
 --[E20231017-000634]
 LEFT OUTER JOIN GT_GMFC_SCP_ITEM_INFO SCP  ON SCP.DIVISION_ID = A.DIVISION_ID AND SCP.ITEM_ID = A.ITEM_ID
 -- 20180809 추가  -----------------
 LEFT JOIN (
    SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
    FROM SCM_MST_SSO_USER_INFO B
    INNER JOIN SCM_MST_SSO_DEPT_INFO C
    ON B.DEPT_ID = C.DEPT_ID
 ) TEAM
 ON              TEAM.USER_ID   IN (SELECT value FROM TABLE(fn_splitstring(e.owner, '','')))
 -- 20180809 추가  -----------------
 LEFT JOIN SCM_MST_SSO_USER_INFO j
       --20180724 ON  CASE WHEN a.DIVISION_ID <> ''40'' THEN F.PROJECT_OWNER ELSE e.OWNER END  = j.USER_ID
       ON  e.OWNER          = j.USER_ID -- 20180724 add son young suk
 LEFT JOIN SCM_MST_SSO_DEPT_INFO k
 --[PJ2024-50461] Team Mapping------------------------------------
       --ON  CASE WHEN a.DIVISION_ID = ''40'' THEN j.DEPT_ID ELSE g.DEPT_ID END  = k.DEPT_ID
       ON  j.DEPT_ID = k.DEPT_ID
--[PJ2024-50461] Team Mapping------------------------------------
 INNER JOIN GT_GMFC_SKH_DM_MST_ITEM_SINGLE_V l
       ON  a.DIVISION_ID    = l.DIVISION_ID
       and a.ITEM_ID        = l.ITEM_ID
 LEFT JOIN DM_MST_BUCKET_CONVERSION m
       ON a.DIVISION_ID     = m.DIVISION_ID
       and a.SCM_SITE_ID    = m.SCM_SITE_ID
       and a.INCOTERMS      = m.INCOTERMS
       and c.DAYOFWEEK      = m.YYYYMMDD
 LEFT JOIN ( --** 20180911  Son Young Suk  조회 컬럼 CELL_TYPE 추가 DM_MST_ITEM_SINGLE_V.CELL_TYPE 사용 LookUp 테이블로 명칭 조회 LookUp 테이블 조인
            SELECT SEGMENT1  AS CODE
                    , SEGMENT2 NAME
            FROM SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE LOOKUP_TYPE = ''CELL_TYPE''
            FETCH FIRST 1 ROWS ONLY
            ) LOOK
        ON LOOK.CODE = l.CELL_TYPE

WHERE 1=1
AND d.qty is not null -- 20240312 조건 추가함.
v_team_id
v_item_type

)

    --SELECT *
    --FROM (
    --      SELECT  COLUMN_NAME, sort_order_no SORT_ORDER_NO_
    --      FROM   SCM_MST_SHEET_MEASURE U
    --      WHERE  1 = 1
    --      AND    U.PROGRAM_ID                     = ''DMF0040''
    --      AND    U.SHEET_NAME                     = ''Mkt Fcst Waterfall''
    --) TEMP1
    --LEFT OUTER JOIN
    --(
        /* 기존SQL 아래 v 컬럼 있음 */
        SELECT v_column
             , F.VERSION_SORT SORT_ORDER_NO
               , v_iteration
        FROM   MKT_FCST F
        WHERE  1 = 1
        -- add 181102 속도개선을 의해서 추가
        -- 20240312 주석처리함. AND    ( F.PER IS NOT NULL OR F.QTY IS NOT NULL )
        v_customer
        v_biz_type
        v_groupby
    --) T ON TEMP1.COLUMN_NAME = T.MEASURE
    --WHERE 1=1
    --[E20240201-001467]
    v_orderby
  '; --DYNAMIC SLQ END

    --[E20240201-001467] 20240216------------------------------------------------------
    SELECT LISTAGG(COLUMN_NAME || ' ' || DATA_SORT_METHOD_CODE, ',')
           WITHIN GROUP (ORDER BY SORT_ORDER_NO)
    INTO   V_ORDER
    FROM   SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE  = 'C'
    AND    U.PROGRAM_ID                     = 'DMF0040'
    AND    U.SHEET_NAME                     = 'mktFcstWaterfall'--'Mkt Fcst Waterfall'
    AND    U.USER_ID                        = p_created_by
    ORDER BY SORT_ORDER_NO;

    --v_sql_text := REPLACE(v_sql_text,'v_orderby'        , v_orderby        );
    V_ORDER := ' ORDER BY ' || V_ORDER || ' , SORT_ORDER_NO ASC ';
    V_ORDER := REPLACE(replace(V_ORDER, ',VERSION_NO' ,''),',MEASURE','') ;
    v_sql_text := REPLACE(v_sql_text,'v_orderby'        , V_ORDER        );

    --DBMS_OUTPUT.PUT_LINE(V_ORDER);
    --end-----------------------------------------------------------------------------
  v_sql_text := REPLACE(v_sql_text,'v_iteration'      , v_iteration    );
  v_sql_text := REPLACE(v_sql_text,'v_division_id'    , FN_SCM_GET_WHERE_SQL('F.DIVISION_ID'  , 'IN', p_division_id));
  v_sql_text := REPLACE(v_sql_text,'v_scm_site_id'    , FN_SCM_GET_WHERE_SQL('F.SCM_SITE_ID'  , 'IN', p_scm_site_id));
  v_sql_text := REPLACE(v_sql_text,'v_plant_site_id'  , FN_SCM_GET_WHERE_SQL('F.PLANT_SITE_ID', 'IN', p_plant_site_id));

  --[PJ2024-50461] Team Mapping -검색조건 처리 누락 수정
  --v_sql_text := REPLACE(v_sql_text,'v_team_id'      , FN_SCM_GET_WHERE_SQL('k.DEPT_ID', 'IN', p_team_id)); --20180809 ytchoi modify
  v_sql_text := REPLACE(v_sql_text,'v_team_id'      , FN_SCM_GET_WHERE_SQL('TEAM.DEPT_ID', 'IN', p_team_id));
  --[PJ2024-50461] Team Mapping -검색조건 처리 누락 수정
  -- 20190911 KHSONG ITEM_ID 조회속도개선 로직추가
    v_sql_text := REPLACE(v_sql_text,'sp_item_id'   ,    '
        INNER JOIN (SELECT COLUMN_VALUE AS ITEM_ID FROM TABLE(CAST(:b_item_input AS t_varchar_list))) ITEM_INPUT
        ON F.ITEM_ID = ITEM_INPUT.ITEM_ID
    ');
    
    --순서 바꿈. sp_project_code_join 먼저 sp_project_code 니중
    IF p_project_code IS NOT NULL THEN
            v_sql_text := REPLACE(v_sql_text,'sp_project_code_join'   ,    '
                    INNER JOIN (SELECT COLUMN_VALUE AS PROJECT_CODE FROM TABLE(CAST(:b_project_input2 AS t_varchar_list))) PROJECT_INPUT
                    ON F.PROJECT_CODE = PROJECT_INPUT.PROJECT_CODE
                ');
    ELSE
        v_sql_text := REPLACE(v_sql_text,'sp_project_code_join'   ,    '');
    END IF;

    -- 20190911 KHSONG PROJECT 조회속도개선
    v_sql_text := REPLACE(v_sql_text,'sp_project_code'   ,    '
        INNER JOIN (SELECT COLUMN_VALUE AS PROJECT_CODE FROM TABLE(CAST(:b_project_input AS t_varchar_list))) PROJECT_INPUT
        ON F.PROJECT_CODE = PROJECT_INPUT.PROJECT_CODE
    ');


  v_sql_text := REPLACE(v_sql_text,'v_item_type'      , FN_SCM_GET_WHERE_SQL('L.ITEM_TYPE'    , 'IN', p_item_type  ));

--
  IF p_division_id <> '40' THEN
            v_sql_text := REPLACE(v_sql_text,'v_customer'     , FN_SCM_GET_WHERE_SQL('F.END_CUSTOMER', 'IN', p_customer)); --20180830 오류수정 잘못된 식별자 G.END_CUSTOMER
            v_sql_text := REPLACE(v_sql_text,'v_project_code' , ''); --20180731, FN_SCM_GET_WHERE_SQL('F.PROJECT_CODE', 'LK', p_project_code))
        ELSE
            v_sql_text := REPLACE(v_sql_text,'v_customer'     , FN_SCM_GET_WHERE_SQL('F.END_CUSTOMER', 'IN', '')); --20180830 오류수정 잘못된 식별자 G.END_CUSTOMER
            v_sql_text := REPLACE(v_sql_text,'v_project_code' , FN_SCM_GET_WHERE_SQL('F.PROJECT_CODE', 'LK', p_customer));
        END IF;
--
  IF p_division_id <> '40' THEN
    v_sql_text := REPLACE(v_sql_text,'v_biz_type'       , FN_SCM_GET_WHERE_SQL('F.BIZ_TYPE'     , 'IN', p_biz_type));
  ELSE
    v_sql_text := REPLACE(v_sql_text,'v_biz_type'       , FN_SCM_GET_WHERE_SQL('FORECAST_INFO_BIZ_TYPE'     , 'IN', p_biz_type));
  END IF;

    --긴것이 먼저해야 문제가 없다. v_from_yyyymmdd_f v_from_yyyymmdd
    v_sql_text := REPLACE(v_sql_text,'v_from_yyyymmdd_f', v_from_yyyymmdd_f);
    v_sql_text := REPLACE(v_sql_text,'v_to_yyyymmdd_f'  , v_to_yyyymmdd_f  );
    v_sql_text := REPLACE(v_sql_text,'v_from_yyyymmdd'  , v_from_yyyymmdd  );
    v_sql_text := REPLACE(v_sql_text,'v_to_yyyymmdd'    , v_to_yyyymmdd    );
    v_sql_text := REPLACE(v_sql_text,'v_column'         , v_column         );
    v_sql_text := REPLACE(v_sql_text,'v_groupby'        , v_groupby        );
    v_sql_text := REPLACE(v_sql_text,'p_created_by'     , p_created_by     );
    v_sql_text := REPLACE(v_sql_text,'v_group_id'       , v_group_id      );

    v_sql_text := REPLACE(v_sql_text,'p_version_no'     , p_version_no);

----->
  /* p_diff_only = False 인경우만 쿼리실행 */
  IF p_diff_only = 'False' THEN
              v_sql_text := REPLACE(v_sql_text,'v_diff_only'      ,
                                                    ' SELECT A.VERSION_NO, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,YYYYMMDD, v.VERSION_TYPE measure , QTY, cell_model
                                                            FROM GT_GMFC_ALL_QUERY_DATA_B A
                                                            INNER JOIN GT_GMFC_TARGET_VERSION_NO V
                                                                ON A.VERSION_NO = V.VERSION_NO
                                                        union all
                                                    ');
          ELSE
              v_sql_text := REPLACE(v_sql_text,'v_diff_only'      , '');
          END IF;

  -- 0703 skh added
  v_sql_text := REPLACE(v_sql_text,'p_from_yyyymmdd', p_from_yyyymmdd);
  v_sql_text := REPLACE(v_sql_text,'p_to_yyyymmdd', p_to_yyyymmdd );
  --v_sql_text := REPLACE(v_sql_text,'v_week_monday', v_week_monday);
  v_sql_text := REPLACE(v_sql_text,'v_from_yyyymmdd_f', v_from_yyyymmdd_f);
  v_sql_text := REPLACE(v_sql_text,'v_to_yyyymmdd_f'  , v_to_yyyymmdd_f  );
  v_sql_text := REPLACE(v_sql_text,'v_from_yyyymmdd'  , v_from_yyyymmdd  );
  v_sql_text := REPLACE(v_sql_text,'v_to_yyyymmdd'    , v_to_yyyymmdd    );
  v_sql_text := REPLACE(v_sql_text,'v_from_result_f'  , v_from_result_f  );
  v_sql_text := REPLACE(v_sql_text,'v_to_result_f'    , v_to_result_f    );
  v_sql_text := REPLACE(v_sql_text,'v_from_result'    , v_from_result    );
  v_sql_text := REPLACE(v_sql_text,'v_to_result'      , v_to_result      );

  --------------------------------------------------------------------------------------------------------------------------------*****
  --p_debug := v_iteration;
  --RETURN p_debug;
  --SELECT v_sql_text;
-- EXECUTE IMMEDIATE with TYPE bind

--DBMS_OUTPUT.PUT_LINE(v_sql_text);
DECLARE
    v_off NUMBER := 1;
    --v_sql_text CLOB := v_sql_text;
BEGIN
    WHILE v_off <= LENGTH(v_sql_text) LOOP
        DBMS_OUTPUT.PUT_LINE(SUBSTR(v_sql_text, v_off, 4000));
        v_off := v_off + 4000;
    END LOOP;
END;

IF p_project_code IS NOT NULL THEN
    EXECUTE IMMEDIATE v_sql_text USING v_item_input, v_project_input, v_project_input;
ELSE
    EXECUTE IMMEDIATE v_sql_text USING v_item_input, v_project_input;
END IF;

-- xml확인할경우
--SELECT CAST(v_sql_text AS TEXT)
--/* TODO: FOR XML PATH --> LISTAGG 수동변환 */--,ROOT('x')

EXCEPTION
    WHEN OTHERS THEN
        BEGIN PR_SCM_SYS_LOG_BATCH(
            v_program_name, 'ERROR', 0, SQLERRM, 'ERROR', SYSDATE,
            p_in_para_data => v_in_para_data,
            p_sql_err_code => SQLCODE,
            p_sql_err_msg => SQLERRM,
            p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
        ); END;
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
END;
/
