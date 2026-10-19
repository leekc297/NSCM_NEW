/*
 * Program ID   : PR_SCP_ENG_IN_FN_PROC_SETUP_MATRIX_40
 * Description  : ENG SETUP MAXTRIX 관련 데이터 생성 및 UPDATE
          
        -----------------------------------------------------------
        -- 1.  FP SETUP 데이터 만들기
        -----------------------------------------------------------
            STEP1 엔진 모델링 대상 라인별 ITEM 생성
              1.1 TEMP TABLE : TMP_TH_ENG_OP_RES_GROUP_MAP
              1.2 기준 TABLE : TH_ENG_OP_RES_GROUP_MAP_SN / SCM_MST_SITE_ENG
            STEP2 FP CUTOFF 데이터 임시 생성
              2.1 엔진 대상 FP 아이템별 속성 임시 데이터 생성 
                2.1.1 TEMP TABLE : TMP_FP_ITEM_SETUP_ATTR_ORG
                2.1.2 기준 TABLE : FP_INSTANCE_ITEM_SETUP_ATTR_VALUE_M_SN / FP_INSTANCE_INFO_V_SN
              2.2 TMP_FP_ITEM_SETUP_ATTR_ORG를 행으로 변경한 데이터 생성
                2.2.1 TEMP TABLE : TMP_FP_ITEM_SETUP_ATTR_NEW
                2.2.2 기준 TABLE : TMP_FP_ITEM_SETUP_ATTR_ORG
              2.3 FP MATCHING KEY ID 데이터 만들기 
                2.3.1 TEMP TABLE : TMP_SETUP_GROUP_KEY_ID
                2.3.2 기준 TABLE : TMP_FP_ITEM_SETUP_ATTR_NEW
              2.4 FP MATCHING KEY ID를 NEW에 UPDATE
                2.4.1 TMP_FP_ITEM_SETUP_ATTR_NEW 에 MATCH_SETUP_GROUP_ID  UPDATE
                2.4.2 MATCH_SETUP_GROUP_ID 테이블 정보 참조
              2.5 TMP_FP_ITEM_SETUP_ATTR_NEW에 FINAL_KEY_ID/FINAL_KEY_ID_ATTR UPDATE
                2.5.1 TEMP TABLE : TMP_FP_ITEM_SETUP_ATTR_NEW
                2.5.2 FOR XML PATH() / STUFF()을 사용하여 ATTRIBUTE의 행정보 생성
            STEP3 FP SETUP MATRIX 임시 데이터 생성
              3.1 TEMP SETUP MATRIX INSERT
                3.1.1 TEMP TABLE : TMP_FP_SETUP_MATRIX
                3.1.2 기준 TABLE : FP_SETUP_MATRIX_M_SN / FP_INSTANCE_INFO_V / FP_ITEM_SETUP_GROUP_M_SN
              3.2 FP MATCHING 데이터를 FROM KEY ID에 UPDATE
                3.2.1 기준 TABLE : TMP_FP_SETUP_MATRIX / TMP_SETUP_GROUP_KEY_ID
                3.2.2 SETUP CATEGORY ID 가 'ATTRIBUTE' 기준
              3.3 FP MATCHING 데이터를 TO KEY ID에 UPDATE
                3.2.1 기준 TABLE : TMP_FP_SETUP_MATRIX / TMP_SETUP_GROUP_KEY_ID
                3.2.2 SETUP CATEGORY ID 가 'ATTRIBUTE' 기준
            STEP4 FP SETUP 속성별로 ITEM ID 데이터 생성
              4.1 FP SETUP 속성별로 FROM/TO ITEM ID 정보 생성
                4.1.1 TEMP TABLE : TMP_SETUP_KEY_ITEM_ID
                4.1.2 기준 TABLE : TMP_FP_SETUP_MATRIX / TMP_FP_ITEM_SETUP_ATTR_NEW
              4.2 FP SETUP 속성별로 FROM/TO ITEM의 MAX SETUP TIME UPDATE
                4.2.1 기준 TABLE : TMP_SETUP_KEY_ITEM_ID
                4.2.2 CALCULATION이 MAX 대상
              4.3 FP SETUP 속성별로 FROM/TO ITEM의 SUM SETUP TIME UPDATE
                4.3.1 기준 TABLE : TMP_SETUP_KEY_ITEM_ID
                4.3.2 CALCULATION이 SUM 대상
            STEP5 FP SETUP 속성별로 ITEM별 정보 생성 
              5.1 FROM ITEM 의 ATTRIBUTE별 MATRIX을 UPDATE
                5.1.1 기준 TABLE : TMP_SETUP_KEY_ITEM_ID / TMP_FP_ITEM_SETUP_ATTR_NEW
                5.1.2 FROM_KEY_ID UPDATE
              5.2 TO ITEM 의 ATTRIBUTE별 MATRIX을 UPDATE
                5.2.1 기준 TABLE : TMP_SETUP_KEY_ITEM_ID / TMP_FP_ITEM_SETUP_ATTR_NEW
                5.2.2 TO_KEY_ID UPDATE
              5.3 FROM ITEM 의 MATRIX ORG 정보 UPDATE
                5.3.1 기준 TABLE : TMP_SETUP_KEY_ITEM_ID / TMP_FP_ITEM_SETUP_ATTR_NEW
                5.3.2 FROM_FINAL_KEY_ID_ORG / FROM_FINAL_KEY_ID_ATTR UPDATE
              5.4 TO ITEM 의 MATRIX ORG 정보 UPDATE
                5.4.1 기준 TABLE : TMP_SETUP_KEY_ITEM_ID / TMP_FP_ITEM_SETUP_ATTR_NEW
                5.4.2 TO_FINAL_KEY_ID_ORG / TO_FINAL_KEY_ID_ATTR UPDATE
              5.5 FROM ITEM 의 MATRIX FINAL 정보 UPDATE
                5.5.1 기준 TABLE : TMP_SETUP_KEY_ITEM_ID / TMP_FP_ITEM_SETUP_ATTR_NEW
                5.5.2 FROM_FINAL_KEY_ID / FROM_FINAL_KEY_ID_ATTR UPDATE
              5.6 TO ITEM 의 MATRIX FINAL 정보 UPDATE
                5.6.1 기준 TABLE : TMP_SETUP_KEY_ITEM_ID / TMP_FP_ITEM_SETUP_ATTR_NEW
                5.6.2 TO_FINAL_KEY_ID / TO_FINAL_KEY_ID_ATTR UPDATE
              5.7 FROM/TO SETUP KEY ID 가 동일 하면 SETUP TIME을 '0'으로 UPDATE
                5.7.1 기준 TABLE : TMP_SETUP_KEY_ITEM_ID
                5.7.2 SETUP_TIME_FINAL UPDATE
            STEP6 엔진 BUF 데이터 생성
              6.1 기존 BUF TABLE 데이터 DELETE
                6.1.1 BUF TABLE : TH_BUF_SETUP_MATRIX
              6.2 TH_BUF_SETUP_MATRIX 정보 생성
                6.2.1 BUF TABLE : TH_BUF_SETUP_MATRIX
                6.2.2 기준 TABLE : TMP_SETUP_KEY_ITEM_ID
        -----------------------------------------------------------
        -- 2.  ENG 관련 테이블 데이터 처리
        -----------------------------------------------------------
            STEP7 ENG SETUP MATRIX 정보 생성
              7.1 TMP_OP_RES_GROUP_ITEM 정보 생성
                7.1.1 TEMP TABLE : TMP_OP_RES_GROUP_ITEM
                7.1.2 기준 TABLE : TMP_TH_ENG_OP_RES_GROUP_MAP / TMP_SETUP_KEY_ITEM_ID
              7.2 TEMP OP RES GROUP의 FROM ITEM에 기존 ATTRIBUTE 정보 UPDATE
                7.2.1 기준 TABLE : TMP_OP_RES_GROUP_ITEM / TMP_SETUP_KEY_ITEM_ID
                7.2.2 FROM_SETUP_GROUP_ID_ATTR / FROM_SETUP_GROUP_ID_ORG / FROM_SETUP_GROUP_ATTR_ORG UPDATE
              7.3 TEMP OP RES GROUP의 FROM ITEM에 기존 FINAL KEY 정보 UPDATE
                7.3.1 기준 TABLE : TMP_OP_RES_GROUP_ITEM / TMP_SETUP_KEY_ITEM_ID
                7.3.2 FROM_SETUP_GROUP_ID UPDATE
              7.4 TEMP OP RES GROUP의 TO ITEM에 기존 ATTRIBUTE 정보 UPDATE
                7.4.1 기준 TABLE : TMP_OP_RES_GROUP_ITEM / TMP_SETUP_KEY_ITEM_ID 
                7.4.2 TO_SETUP_GROUP_ID_ATTR / TO_SETUP_GROUP_ID_ORG / TO_SETUP_GROUP_ATTR_ORG UPDATE
              7.5 TEMP OP RES GROUP의 TO ITEM에 기존 FINAL KEY 정보 UPDATE
                7.5.1 기준 TABLE : TMP_OP_RES_GROUP_ITEM / TMP_SETUP_KEY_ITEM_ID
                7.5.2 TO_SETUP_GROUP_ID UPDATE
              7.6 TEMP OP RES GROUP기준으로 BUF SETUP MATRIX 정보 생성
                7.6.1 생성 TABLE : TH_BUF_SETUP_MATRIX
                7.6.2 기준 TABLE : TMP_OP_RES_GROUP_ITEM
              7.7 TMP_FP_SETUP_MATRIX 의 SETUP TIME으로 UPDATE
                7.7.1 TMP_FP_SETUP_MATRIX 의 SETUP CATEGROY가 ITEM 이면서 FROM/TO SETUP GROUP ID가
                      TMP_SETUP_KEY_ITEM_ID 의 FROM/TO ITEM 와 동일 하면 SETUP TIME을 TMP_FP_SETUP_MATRIX 의 SETUP TIME으로 UPDATE 
                7.7.2 기준 TABLE : TH_BUF_SETUP_MATRIX
              7.8 TH_ENG_SETUP_MATRIX_SN 정보 생성
                7.8.1 기준 TABLE: TH_BUF_SETUP_MATRIX
                7.7.2 FROM/TO SETUP GROUP ID 는 FROM/TO FINAL KEY ID ATTRIBUTE 기준으로 생성
                7.8.3 LINE_SETUP_GROUP_ID / FROM_FINAL_KEY_ID / TO_FINAL_KEY_ID 기준으로 COUNT가 1 일 경우 처리
                      FROM_SETUP_GROUP_ID 를 BUF SETUP MATRIX 의 FROM_FINAL_KEY_ID 적용
                7.8.4 LINE_SETUP_GROUP_ID / FROM_FINAL_KEY_ID / TO_FINAL_KEY_ID 기준으로 COUNT가 1 보다 클 경우 처리
                      FROM_SETUP_GROUP_ID 를 BUF SETUP MATRIX 의 FROM_FINAL_KEY_ID 와 FROM_ITEM_ID 조합 해서 적용
                7.8.5 SETUP TIME 이 '0'일 경우는 제외 함
            STEP8 ENG ITEM에 SETUP GROUP ID UPDATE
              8.1 BUF SETUP MATRIX 기준으로 FINAL KEY ID 정보 조회
              8.2 ENG ITEM의 SETUP GROUP ID 에 UPDATE
            STEP9 TH_ENG_RESOURCE_SN UPDATE
              9.1 BUF SETUP MATRIX 기준으로 RESOURCE  ID 정보 조회
              9.2 RESOURCE SETUP GROUP ID 에 BUF SETUP MATRIX의 LINE SET GROUP ID 값으로 UPDATE

 * OutTable     : TH_ENG_SETUP_MATRIX_SN
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024.05.14   LJH            PJ20244781 LGES 시스템 기반 SCM 고도화(소형 시스템 Planning, oWMS 영역)
 * 2024.07.01   KKC            PJ20244781 LGES 시스템 기반 SCM 고도화(소형 시스템 Planning, oWMS 영역) : 로직 수정/보완
 * 2024.07.09   KKC            PJ20244781 LGES 시스템 기반 SCM 고도화(소형 시스템 Planning, oWMS 영역) : Plant별 Setup Group 기능 추가(엔진패치)
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_FN_PROC_SETUP_MATRIX_40]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)       
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

     --20180228 프로시저 속도 개선을 위해서 입력변수를 일반변수로 변경함
    DECLARE @p_plan_cycle  NVARCHAR(150)    = @p_plan_cycle1;
    DECLARE @p_plan_name   NVARCHAR(4000)   = @p_plan_name1;
    DECLARE @p_plan_id     NVARCHAR(4000)   = @p_plan_id1;
    DECLARE @p_modeling_id NVARCHAR(4000)   = @p_modeling_id1 ;
    DECLARE @p_seq         NVARCHAR(4000)   = @p_seq1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)   = @p_plan_type1 ;
    DECLARE @p_master_id   NVARCHAR(4000)   = @p_master_id1 ;
    DECLARE @p_division_id NVARCHAR(30)     = @p_division_id1 ; 
    DECLARE @p_engine_plan_id NVARCHAR(4000)  = @p_engine_plan_id1 ;
    DECLARE @p_site_type   NVARCHAR(4000)  = 'PLANT' ; 
    
    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_FN_PROC_SETUP_MATRIX_40';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = '';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;

    DECLARE @d_plan_name         DATETIME = CONVERT(DATETIME,@p_plan_name);
    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date

    DECLARE @v_add_pet_date      NVARCHAR(8) ; -- Add Plan End Date (2022.01.26 추가) 
    DECLARE @v_plan_group        NVARCHAR(100) = '-'; -- Plan Group : PJ20230691 도전과제 계획 	

    DECLARE @v_division_group    NVARCHAR(30);   ---(2022.04.04) 추가.
    DECLARE @v_division_comp     NVARCHAR(30);
		
    /*------------------------------------------------------------------
     * Division Group 정의  (2022.04.04: Joint Venture 사업부 추가) 
        - JV사업부 코드(81_UC, EE_UC)추가되면서 division_id만으로는 사업부별 로직분개시 구분값으로 활용 불가.
        - 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수 '@v_division_group'로 처리
        - 기존의 division_id 분개로직을 division_group 기준으로 대체하여 사용한다.
        - 예) division_group: 81 >> division_id: 81 , 81_UC  >>  division_comp: LG , UC
    ----------------------------------------------------------------------*/                        
    SELECT @v_division_group   =  di.attribute3
         , @v_division_comp    =  di.attribute4  -- 회사코드
      FROM scm_mst_division di WITH(NOLOCK)
     WHERE di.valid_yn         =  'Y' 
       AND di.division_id      =  @p_division_id  ; 

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id  ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
			
      /*****************************************************/
	  /* SETP1. 엔진 모델링 대상 라인별 생산 ITEM 정보 생성*/
      /*****************************************************/
	  IF(OBJECT_ID('tempdb.dbo.#tmp_th_eng_op_res_group_map') IS NOT NULL)
          BEGIN
	          DROP TABLE #tmp_th_eng_op_res_group_map;
          END

      SELECT  DISTINCT 
                  a.master_id
                , a.plan_id
                , a.plant_id
                , a.site_id
                , a.scm_site_id
                , a.route_id
                , a.operation_id
                , a.operation_group
                , a.resource_group_id
                , a.line_id
                , b.line_setup_group_id
                , a.item_id
                , 'Y'  AS fp_item_attribute_yn
            INTO  #tmp_th_eng_op_res_group_map
            FROM  
                  (
                  SELECT  a.master_id
                        , a.plan_id
                        , a.site_id
                        , a.route_id
                        , a.operation_id
                        , a.resource_group_id
                        , a.item_id
                        , b.scm_site_id
                        , b.plant_id
                        , b.operation_group
                        , SUBSTRING(a.resource_group_id, dbo.FN_CHARINDEX_REV(a.resource_group_id, '::', 0)+2, 100) AS line_id
                    FROM  th_eng_op_res_group_map_sn  a WITH(NOLOCK)
                    JOIN  (
                          SELECT  b.*
                            FROM  dbo.scm_mst_site_eng b WITH(NOLOCK)
                           WHERE  b.modeling_id     = @p_modeling_id
                             AND  b.plan_id         = @p_plan_id
                             AND  b.plan_seq        = @p_seq
                             AND  b.plan_type       = @p_plan_type
                             AND  b.site_type       = 'PLANT'
                             AND  b.eng_scm_site_id LIKE '%~***'
                          ) b
                      ON  a.site_id     = b.eng_scm_site_id
                   WHERE  a.master_id   = @p_master_id
                     AND  a.plan_id     = @p_engine_plan_id
                  ) a
            JOIN  dbo.scm_line_m_sn b WITH(NOLOCK) 
              ON  a.plant_id            = b.plant_id
             AND  a.operation_id        = b.operation_id
             AND  a.line_id             = b.line_id
           WHERE  b.division_id         = @p_division_id
             AND  b.line_setup_group_id IS NOT NULL
             AND  b.line_setup_group_id <> '' 
      ;

	  -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.1-1';
      SET @v_description = N'1-1. 엔진 모델링 대상 라인별 ITEM 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

      /*********************************************************/
      /* SETP2. FP setup 관련 아이템 속성 데이터 임시 생성 
         2-1. #tmp_fp_item_setup_attr_org
              -> Setup 대상 FP 아이템별 속성 임시 데이터 생성  */
      /*********************************************************/
      IF(OBJECT_ID('tempdb.dbo.#tmp_fp_item_setup_attr_org') IS NOT NULL)
          BEGIN
	          DROP TABLE #tmp_fp_item_setup_attr_org;
          END

      SELECT  DISTINCT 
                  a.instance_id
                , b.instance_type
                , b.division_id
                , b.site_id
                , b.plant_id
                , a.item_id
                , a.operation_id
                , a.attribute1
                , a.attribute2
                , a.attribute3
                , a.attribute4
                , a.attribute5
                , a.attribute6
                , a.attribute7
                , a.attribute8
                , a.attribute9
                , a.attribute10
                , a.attribute11
                , a.attribute12
                , a.attribute13
                , a.attribute14
                , a.attribute15  
            INTO  #tmp_fp_item_setup_attr_org
            FROM  dbo.fp_instance_item_setup_attr_value_m_sn a WITH(NOLOCK)
            JOIN  dbo.fp_instance_info_v_sn                  b WITH(NOLOCK) 
              ON  a.instance_id = b.instance_id
           WHERE b.division_id = @p_division_id
             AND b.instance_type     IN ('A', 'P')
             AND a.active_flag = 'Y'
             AND  EXISTS  (             
                          SELECT  'X'
                            FROM  #tmp_th_eng_op_res_group_map x
                           WHERE  x.plant_id      = b.plant_id
                             AND  x.operation_id  = a.operation_id
                             AND  x.item_id       = a.item_id
                             AND  x.fp_item_attribute_yn  = 'Y'
                          )
      ;

      --fp_item_attribute_yn : N 처리
      UPDATE a 
         SET a.fp_item_attribute_yn = 'N'
        FROM #tmp_th_eng_op_res_group_map a
       WHERE NOT EXISTS (SELECT 'X'
                           FROM #tmp_fp_item_setup_attr_org x
                          WHERE x.plant_id = a.plant_id
                            AND x.item_id  = a.item_id
                        )
      ;

	  -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.2-1';
      SET @v_description = N'2-1. 엔진 대상 FP 아이템별 속성 임시 데이터 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
          
      /*******************************************************************************/
      /* 2-2. #tmp_fp_item_setup_attr_new                                            */
      /*      -> #tmp_fp_item_setup_attr_org를 행(ROW) 데이터 생성                   */
      /*******************************************************************************/
      IF(OBJECT_ID('tempdb.dbo.#tmp_fp_item_setup_attr_new') IS NOT NULL)
          BEGIN
              DROP TABLE #tmp_fp_item_setup_attr_new;
          END
      
      /* TEMP TABLE */
      CREATE TABLE  #tmp_fp_item_setup_attr_new(
                      instance_id 		      nvarchar(100)
     	            , instance_type		      nvarchar(10)
     	            , division_id		      nvarchar(50)
     	            , plant_id   		      nvarchar(50)
     	            , operation_id		      nvarchar(50)
     	            , item_id   		      nvarchar(500)
     	            , setup_key_id       	  nvarchar(200)
                    , item_attr               nvarchar(1000)
     	            , match_setup_group_id    nvarchar(1000)
     	            , final_key_id            nvarchar(1000)
     	            , final_key_id_attr       nvarchar(1000)  --길이 넉넉하게
     	            , com_final_key_id        nvarchar(1000)  --plant구분없는 아이템 기준으로
     	            , com_final_key_id_attr   nvarchar(1000)  --상동
       );
      
      INSERT INTO #tmp_fp_item_setup_attr_new
          (
                 instance_id
               , instance_type
               , division_id
               , plant_id
               , operation_id
               , item_id
               , setup_key_id
               , item_attr
               , match_setup_group_id
          )
          SELECT  instance_id
                , instance_type
                , division_id
                , plant_id
                , operation_id
                , item_id
                , UPPER(setup_key_id) AS setup_key_id 
                , item_attr
                , item_attr   --혹시 NULL이 없게 끔 넣어주자~
            FROM  #tmp_fp_item_setup_attr_org
            UNPIVOT (item_attr FOR setup_key_id IN ([ATTRIBUTE1],  [ATTRIBUTE2],  [ATTRIBUTE3],  [ATTRIBUTE4],  [ATTRIBUTE5]
                                                  , [ATTRIBUTE6],  [ATTRIBUTE7],  [ATTRIBUTE8],  [ATTRIBUTE9],  [ATTRIBUTE10]
                                                  , [ATTRIBUTE11], [ATTRIBUTE12], [ATTRIBUTE13], [ATTRIBUTE14], [ATTRIBUTE15])
                    ) AS unpvt
      ;

	  --TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.2-2';
      SET @v_description = N'2-2. #TMP_FP_ITEM_SETUP_ATTR_NEW 데이터 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;      
      
      /**************************************************************************/
	  /* 2-3. #tmp_setup_group_key_id
              -> 엔진용 KEY ID 데이터 만들기(Attribute기준정보가 문자로 관리)   */
      /**************************************************************************/	  
	  IF(OBJECT_ID('tempdb.dbo.#tmp_setup_group_key_id') IS NOT NULL)
          BEGIN
	          DROP TABLE #tmp_setup_group_key_id;
          END
      
	  CREATE TABLE  #tmp_setup_group_key_id(
					    instance_id 		  nvarchar(100)
				      , operation_id		  nvarchar(50)
				      , setup_key_id          nvarchar(100)
				      , item_setup_group_id   nvarchar(200)
                      , match_setup_group_id  nvarchar(200)
		  );
           
      /*FP MATCHING KEY ID 데이터 생성*/
      INSERT INTO #tmp_setup_group_key_id(
                  instance_id
                , operation_id
                , setup_key_id
                , item_setup_group_id
                , match_setup_group_id
          )
      SELECT  a.instance_id
            , a.operation_id
            , a.setup_key_id
            , a.attribute           AS item_setup_group_id
            , ROW_NUMBER() OVER(PARTITION BY  a.instance_id
                                            , a.operation_id
                                            , a.plant_id
                                    ORDER BY  a.setup_key_id
                                            , a.attribute
                                )  AS match_setup_group_id
       FROM  (
             SELECT  DISTINCT
                     a.instance_id
                   , a.operation_id
                   , a.plant_id
                   , UPPER(a.setup_key_id) AS setup_key_id
                   , a.item_attr AS attribute
               FROM  #tmp_fp_item_setup_attr_new a WITH(NOLOCK)
              WHERE  1 = 1
             ) a
      WHERE  a.attribute != ''
      ;
      
	  -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.2-3';
      SET @v_description = N'2-3. 엔진용 KEY ID 데이터 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

      /*******************************************************************************/
      /* 2-4. #tmp_fp_item_setup_attr_new 
              -> 관련 정보 UPDATE                                                    */
      /*******************************************************************************/
        
      /*****************************************************/
      /* 2-4-1. #tmp_fp_item_setup_attr_new 
              -> match_setup_group_id UPDATE               */
      /*****************************************************/
      UPDATE  a
         SET  a.match_setup_group_id = b.match_setup_group_id
        FROM  #tmp_fp_item_setup_attr_new a
        JOIN  #tmp_setup_group_key_id b
          ON  a.instance_id  = b.instance_id
         AND  a.operation_id = b.operation_id   
         AND  a.setup_key_id = b.setup_key_id
         AND  a.item_attr    = b.item_setup_group_id
      ;

	  --TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.2-4';
      SET @v_description = N'2-4-1. #tmp_fp_item_setup_attr_new.match_setup_group_id UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

      /*****************************************************/
      /* 2-4-2. #tmp_fp_item_setup_attr_new 
              -> 조합key생성 및 final_key_id/final_key_id_attr UPDATE     */
      /*****************************************************/
      UPDATE  a
         SET  a.final_key_id      = b.final_key_id
           ,  a.final_key_id_attr = b.final_key_id_attr
        FROM  #tmp_fp_item_setup_attr_new a
        JOIN  (
              SELECT  a.instance_id
                    , a.instance_type
                    , a.division_id
                    , a.plant_id
                    , a.operation_id
                    , a.item_id
                    , a.setup_key_id
                    , a.item_attr
                    , a.match_setup_group_id
                    , STUFF(
                              (
                              SELECT  '*'+ item_attr
                                FROM  #tmp_fp_item_setup_attr_new p
                               WHERE  instance_id  = a.instance_id
                                 AND  operation_id = a.operation_id
                                 AND  item_id      = a.item_id      
                                 AND  item_attr    <> ''     
                               ORDER 
                                   BY item_id, setup_key_id 
                                  FOR XML PATH('')
                              ), 1,1, '') AS final_key_id_attr
                    , STUFF(
                              (
                              SELECT  '*'+ match_setup_group_id
                                FROM  #tmp_fp_item_setup_attr_new p
                               WHERE  instance_id  = a.instance_id
                                 AND  operation_id = a.operation_id
                                 AND  item_id      = a.item_id      
                                 AND  item_attr    <> ''                 
                              ORDER 
                                 BY item_id, setup_key_id
                                FOR XML PATH('')
                              ), 1,1, '') AS final_key_id
                FROM  #tmp_fp_item_setup_attr_new a
               WHERE  1 = 1
              ) b
          ON  a.instance_id  = b.instance_id
         AND  a.operation_id = b.operation_id
         AND  a.item_id      = b.item_id
      ;

	  --TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.2-4';
      SET @v_description = N'2-4-2. #tmp_fp_item_setup_attr_new.조합key생성/final_key_id UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      
      /*****************************************************/
      /* 2-4-2. #tmp_fp_item_setup_attr_new 
                -> Plant 공통 FINAL_KEY_ID/FINAL_KEY_ID_ATTR UPDATE   */
      /*****************************************************/
      UPDATE  a
         SET  a.com_final_key_id       = b.new_final_key_id
            , a.com_final_key_id_attr  = b.new_final_key_id_attr
        FROM  #tmp_fp_item_setup_attr_new  a
        JOIN  (
              SELECT  operation_id
                    , item_id
                    , MAX(final_key_id)       AS new_final_key_id
                    , MAX(final_key_id_attr)  AS new_final_key_id_attr
                FROM  #tmp_fp_item_setup_attr_new b
               WHERE  1 = 1
               GROUP BY operation_id
                      , item_id
              ) b
          ON  a.operation_id  = b.operation_id
         AND  a.item_id       = b.item_id
      ;

	  --TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.2-4';
      SET @v_description = N'2-4-3. #tmp_fp_item_setup_attr_new.com_final_key_id UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

      /*****************************************************/
      /* 2-5. #tmp_item_setup_group_id 
              Item별 FINAL_KEY_ID/FINAL_KEY_ID_ATTR 데이터 생성   */
      /*****************************************************/
      IF(OBJECT_ID('tempdb.dbo.#tmp_item_setup_group_id') IS NOT NULL)
      BEGIN
	    DROP TABLE #tmp_item_setup_group_id;
      END

      SELECT a.plant_id
           , a.operation_id
           , a.item_id
           , a.setup_key_id
           , a.final_key_id
           , a.final_key_id_attr
           , a.com_final_key_id
           , a.com_final_key_id_attr
       INTO #tmp_item_setup_group_id
       FROM
           (
           SELECT a.plant_id
                , a.operation_id
                , a.item_id
                , a.setup_key_id
                , a.final_key_id
                , a.final_key_id_attr
                , a.com_final_key_id
                , a.com_final_key_id_attr
                , ROW_NUMBER() OVER(PARTITION BY a.plant_id
                                               , a.operation_id
                                               , a.item_id
                                        ORDER BY a.setup_key_id
                                               , a.com_final_key_id
                                   ) AS seq
             FROM #tmp_fp_item_setup_attr_new a
           ) a
      WHERE a.seq = 1
      ;
	  --TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.2-5';
      SET @v_description = N'2-5. #tmp_item_setup_group_id 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      
      /*********************************************************/
      /* SETP3. FP setup matrix 임시 데이터 생성 임시 생성 
           3-1. #tmp_fp_setup_matrix
                -> fp setup matrix 데이터 생성                 */
      /*********************************************************/
	  IF(OBJECT_ID('tempdb.dbo.#tmp_fp_setup_matrix') IS NOT NULL)
          BEGIN
	          DROP TABLE #tmp_fp_setup_matrix;
          END

	  CREATE TABLE #tmp_fp_setup_matrix(
	        instance_id 			    nvarchar(100)
	      , plant_id				    nvarchar(50)
	      , operation_id			    nvarchar(50)
	      , line_setup_group_id		    nvarchar(200)
	      , setup_category_id		    nvarchar(200)
	      , setup_key_id			    nvarchar(200)
	      , from_item_setup_group_id    nvarchar(200)
	      , to_item_setup_group_id	    nvarchar(200)
	      , setup_time				    numeric(20, 10)
	      , setup_time_uom			    nvarchar(50)
	      , calculation				    nvarchar(50)
	      , from_key_id				    nvarchar(100)
	      , to_key_id                   nvarchar(100)
	  );
	
	  INSERT INTO #tmp_fp_setup_matrix(
	        instance_id
	      , plant_id
	      , operation_id
	      , line_setup_group_id
	      , setup_category_id
	      , setup_key_id
	      , from_item_setup_group_id
	      , to_item_setup_group_id
	      , setup_time
	      , setup_time_uom
	      , calculation
	   )
	   SELECT DISTINCT
              a.instance_id
	        , b.plant_Id
	        , a.operation_id
	        , a.line_setup_group_id
	        , a.setup_category_id
	        , a.setup_key_id
	        , a.from_item_setup_group_id
	        , a.to_item_setup_group_id
	        , CASE WHEN a.setup_time IS NULL AND c.setup_time IS NOT NULL THEN c.setup_time
                         ELSE ISNULL(a.setup_time, 0)
                    END AS setup_time
	        , UPPER(a.setup_time_uom)
	        , d.calculation
	   FROM dbo.fp_setup_matrix_m_sn  a WITH(NOLOCK)
	   JOIN dbo.fp_instance_info_v_sn b WITH(NOLOCK)
	     ON a.instance_id = b.instance_id
	   LEFT OUTER JOIN (
	   		   SELECT a.instance_id
	   			    , a.operation_id
	   			    , a.line_setup_group_id
	   			    , a.setup_category_id
	   			    , a.setup_key_id
	   			    , a.from_item_setup_group_id
	   			    , a.to_item_setup_group_id
	   			    , a.setup_time
	   			    , a.setup_time_uom
	   		    FROM  dbo.fp_setup_matrix_m_sn  a WITH(NOLOCK)
	   		   WHERE  1=1
                             AND  a.active_flag               = 'Y'
	   		     AND  a.setup_category_id         = 'ATTRIBUTE'
	   		     AND  a.from_item_setup_group_id  = 'ALL'
	   		     AND  a.to_item_setup_group_id    = 'ALL'
	   		     AND  a.setup_time                > 0
	   		  )  c
	     ON a.instance_id         = c.instance_id
	    AND a.operation_id        = c.operation_id
	    AND a.line_setup_group_id = c.line_setup_group_id 
	    AND a.setup_category_id   = c.setup_category_id
	    AND a.setup_key_id        = c.setup_key_id
	   LEFT OUTER JOIN (
                        SELECT *
	   		           FROM dbo.fp_item_setup_group_m_sn  d WITH(NOLOCK)
	   		          WHERE d.active_flag = 'Y'
	   		         ) d
	      ON a.instance_id       = d.instance_id
	     AND a.operation_id      = d.operation_id
	     AND a.setup_category_id = d.setup_category_id
	     AND a.setup_key_id      = d.setup_key_id
	   WHERE b.division_id       = @p_division_id
	     AND b.instance_type     IN ('A', 'P')
	     AND a.active_flag       = 'Y'
	  ;

	  -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.3-1';
      SET @v_description = N'3-1. #tmp_fp_setup_matrix INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
      /*********************************************************/
      /*   3-2. #tmp_fp_setup_matrix
                -> from_key_id UPDATE                          */
      /*********************************************************/
      UPDATE  a
         SET  a.from_key_id = b.match_setup_group_id
        FROM  #tmp_fp_setup_matrix    a  WITH(NOLOCK)
        JOIN  #tmp_setup_group_key_id b  WITH(NOLOCK)
          ON  a.instance_id               = b.instance_id
         AND  a.operation_id              = b.operation_id
         AND  a.setup_key_id              = b.setup_key_id
         AND  a.from_item_setup_group_id  = b.item_setup_group_id
        WHERE  a.setup_category_id         = 'ATTRIBUTE'
      ;

	  -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.3-2';
      SET @v_description = N'3-2. #tmp_fp_setup_matrix.from_key_id UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      
      /*********************************************************/
      /*   3-3. #tmp_fp_setup_matrix
                -> to_key_id UPDATE                          */
      /*********************************************************/
      UPDATE  a
         SET  a.to_key_id = b.match_setup_group_id
        FROM  #tmp_fp_setup_matrix    a  WITH(NOLOCK)
        JOIN  #tmp_setup_group_key_id b  WITH(NOLOCK)
          ON  a.instance_id             = b.instance_id
         AND  a.operation_id            = b.operation_id
         AND  a.setup_key_id            = b.setup_key_id
         AND  a.to_item_setup_group_id  = b.item_setup_group_id
       WHERE  a.setup_category_id       = 'ATTRIBUTE'
      ;

	  -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.3-3';
      SET @v_description = N'3-3. #tmp_fp_setup_matrix.to_key_id UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    
      /*********************************************************/
      /* SETP4. FP setup 속성별 Item 데이터 생성
           4-1. #tmp_setup_key_item_id
                                                               */
      /*********************************************************/
	  IF(OBJECT_ID('tempdb.dbo.#tmp_setup_key_item_id') IS NOT NULL)
          BEGIN
	          DROP TABLE #tmp_setup_key_item_id;
          END
      
	  CREATE TABLE #tmp_setup_key_item_id(
	  			        instance_id 			    nvarchar(100)
	  			      , plant_id				    nvarchar(50)
	  			      , operation_id			    nvarchar(50)
	  			      , line_setup_group_id		    nvarchar(200)
	  			      , setup_category_id		    nvarchar(200)
	  			      , setup_key_id			    nvarchar(200)
	  			      , from_item_setup_group_id    nvarchar(200)
	  			      , to_item_setup_group_id	    nvarchar(200)
	  			      , setup_time				    numeric(20, 10)
	  			      , setup_time_uom			    nvarchar(50)
	  			      , calculation				    nvarchar(50)
	  			      , from_key_id				    nvarchar(200)
	  			      , to_key_id                   nvarchar(200)
                      , from_item_id                nvarchar(500)
                      , to_item_id                  nvarchar(500)
                      , from_final_key_id           nvarchar(1000)
                      , to_final_key_id             nvarchar(1000)
                      , from_final_key_id_org       nvarchar(1000)
                      , to_final_key_id_org         nvarchar(1000)
                      , from_final_key_id_attr      nvarchar(1000)
                      , to_final_key_id_attr        nvarchar(1000)
                      , from_final_key_id_attr_org  nvarchar(1000)
                      , to_final_key_id_attr_org    nvarchar(1000)
                      , setup_time_final            numeric(20, 10)
	   );
      
      /*FP SETUP 속성별로 FROM/TO ITEM ID 정보 생성*/
      INSERT INTO #tmp_setup_key_item_id( 
                  instance_id
				, plant_id
				, operation_id
				, line_setup_group_id
				, setup_category_id		    
				, setup_key_id
				, from_item_setup_group_id
				, to_item_setup_group_id
                , from_item_id
                , to_item_id
				, setup_time				      
				, setup_time_uom			    
				, calculation
				, from_key_id
				, to_key_id
          )
          SELECT  a.instance_id
                , a.plant_id
                , a.operation_id
                , a.line_setup_group_id
                , a.setup_category_id
                , a.setup_key_id
                , a.from_item_setup_group_id
                , a.to_item_setup_group_id
                , a.item_id                   AS from_item_id
                , b.item_id                   AS to_item_id
                , a.setup_time
                , a.setup_time_uom
                , a.calculation
                , a.from_key_id
                , a.to_key_id
            FROM  (
                  SELECT  DISTINCT
                          b.item_id
                        , a.*
                    FROM  #tmp_fp_setup_matrix a
                   INNER JOIN 
                          #tmp_fp_item_setup_attr_new b
                      ON  a.instance_id               = b.instance_id
                     AND  a.operation_id              = b.operation_id
                     AND  a.plant_id                  = b.plant_id
                     AND  a.setup_key_id              = b.setup_key_id
                     AND  a.from_item_setup_group_id  = b.item_attr
                   WHERE  a.setup_category_id         = 'ATTRIBUTE'
                  ) a
          INNER JOIN  
                  (
                  SELECT  DISTINCT
                          b.item_id
                        , a.*
                    FROM  #tmp_fp_setup_matrix a
                   INNER JOIN 
                    #tmp_fp_item_setup_attr_new b
                      ON  a.instance_id             = b.instance_id
                     AND  a.operation_id            = b.operation_id
                     AND  a.plant_id                = b.plant_id
                     AND  a.setup_key_id            = b.setup_key_id
                     AND  a.to_item_setup_group_id  = b.item_attr
                   WHERE  a.setup_category_id       = 'ATTRIBUTE'
                  ) b
              ON  a.instance_id               = b.instance_id
             AND  a.operation_id              = b.operation_id
             AND  a.plant_id                  = b.plant_id
             AND  a.line_setup_group_id       = b.line_setup_group_id
             AND  a.setup_category_id         = b.setup_category_id
             AND  a.setup_key_id              = b.setup_key_id
             AND  a.from_item_setup_group_id  = b.from_item_setup_group_id
             AND  a.to_item_setup_group_id    = b.to_item_setup_group_id
      ;

	  -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.4-1'; 
      SET @v_description = N'4-1. #tmp_setup_key_item_id 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

      /*********************************************************/
      /*   4-2. #tmp_setup_key_item_id
           -> max setup time 계산/ update
                                                               */
      /*********************************************************/
      UPDATE  #tmp_setup_key_item_id
         SET  setup_time_final = max_setup_time
        FROM  #tmp_setup_key_item_id    a  WITH(NOLOCK)
        JOIN  (
              SELECT  a.instance_id
	                , a.operation_id
	                , a.line_setup_group_id
	                , a.setup_category_id
	                , a.from_item_id
	                , a.to_item_id
	                , MAX(ISNULL(setup_time, 0)) AS max_setup_time
                FROM  #tmp_setup_key_item_id a  WITH(NOLOCK)
               WHERE a.setup_category_id = 'ATTRIBUTE' --2024.07.01 좀 더 명확하게 조건 추가
                 AND a.calculation = 'MAX'
               GROUP 
                  BY a.instance_id
	               , a.operation_id
	               , a.line_setup_group_id
	               , a.setup_category_id
	               , a.from_item_id
	               , a.to_item_id
              )  b
         ON  a.instance_id         = b.instance_id
        AND  a.operation_id        = b.operation_id
        AND  a.line_setup_group_id = b.line_setup_group_id
        AND  a.setup_category_id   = b.setup_category_id
        AND  a.from_item_id        = b.from_item_id
        AND  a.to_item_id          = b.to_item_id
      ;

	  -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.4-2'; 
      SET @v_description = N'4-2. #tmp_setup_key_item_id.MAX SETUP TIME UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      
      /*********************************************************/
      /*   4-3. #tmp_setup_key_item_id
           -> sum setup time add/ update
                                                               */
      /*********************************************************/
      UPDATE #tmp_setup_key_item_id
         SET setup_time_final = ISNULL(setup_time_final,0) + sum_setup_time
        FROM #tmp_setup_key_item_id  a  WITH(NOLOCK)
        JOIN  (
              SELECT  a.instance_id
	                , a.operation_id
	                , a.line_setup_group_id
	                , a.setup_category_id
	                , a.from_item_id
	                , a.to_item_id
	                , SUM(ISNULL(setup_time, 0)) AS sum_setup_time
                FROM  #tmp_setup_key_item_id a  WITH(NOLOCK)
               WHERE a.setup_category_id = 'ATTRIBUTE' --2024.07.01 좀 더 명확하게 조건 추가
                 AND a.calculation = 'SUM'
               GROUP BY a.instance_id
	                  , a.operation_id
	                  , a.line_setup_group_id
	                  , a.setup_category_id
	                  , a.from_item_id
	                  , a.to_item_id
              )  b
         ON  a.instance_id         = b.instance_id
        AND  a.operation_id        = b.operation_id
        AND  a.line_setup_group_id = b.line_setup_group_id
        AND  a.setup_category_id   = b.setup_category_id
        AND  a.from_item_id        = b.from_item_id
        AND  a.to_item_id          = b.to_item_id
      ;

	  -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.4-3'; 
      SET @v_description = N'4-3. #tmp_setup_key_item_id.SUM SETUP TIME UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	  
      /*********************************************************/
      /*   4-4. #tmp_setup_key_item_id
           -> from Item 기준 key값들/ update                   */
      /*********************************************************/
      /*FROM ITEM 의 key id정보 UPDATE, 쿼리 정리, 2024.07.01 */
      UPDATE  a
         SET  a.from_key_id = b.item_attr
            , a.from_final_key_id_org       = b.final_key_id
            , a.from_final_key_id_attr_org  = b.final_key_id_attr
            , a.from_final_key_id           = b.com_final_key_id
            , a.from_final_key_id_attr      = b.com_final_key_id_attr
        FROM  #tmp_setup_key_item_id  a
        JOIN  (
              SELECT  b.instance_id
                    , b.plant_id
                    , b.operation_id
                    , b.item_id
                    , b.setup_key_id
                    , b.item_attr
                    , b.final_key_id
                    , b.final_key_id_attr
                    , b.com_final_key_id
                    , b.com_final_key_id_attr
                FROM  #tmp_fp_item_setup_attr_new b
               WHERE  b.item_attr != ''
              ) b
          ON  a.instance_id       = b.instance_id
         AND  a.plant_id          = b.plant_id
         AND  a.operation_id      = b.operation_id
         AND  a.from_item_id      = b.item_id
         AND  a.setup_key_id      = b.setup_key_id
         AND  a.setup_category_id = 'ATTRIBUTE'
      ;

	  --TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.4-4'; 
      SET @v_description = N'4-4. #tmp_setup_key_item_id(from item) UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date

      /*********************************************************/
      /*   4-5. #tmp_setup_key_item_id
           -> to Item 기준 key값들/ update
           -> FROM/TO SETUP KEY ID 가 동일 하면 SETUP TIME을 '0'으로 UPDATE
                                                               */
      /*********************************************************/
      UPDATE  a
         SET  a.to_key_id = b.item_attr
            , a.to_final_key_id_org       = b.final_key_id
            , a.to_final_key_id_attr_org  = b.final_key_id_attr
            , a.to_final_key_id           = b.com_final_key_id
            , a.to_final_key_id_attr      = b.com_final_key_id_attr
        FROM  #tmp_setup_key_item_id  a
        JOIN  (
              SELECT  b.instance_id
                    , b.plant_id
                    , b.operation_id
                    , b.item_id
                    , b.setup_key_id
                    , b.item_attr
                    , b.final_key_id
                    , b.final_key_id_attr
                    , b.com_final_key_id
                    , b.com_final_key_id_attr
                FROM  #tmp_fp_item_setup_attr_new b
               WHERE  b.item_attr != ''
              ) b
          ON  a.instance_id       = b.instance_id
         AND  a.plant_id          = b.plant_id
         AND  a.operation_id      = b.operation_id
         AND  a.to_item_id        = b.item_id
         AND  a.setup_key_id      = b.setup_key_id
         AND  a.setup_category_id = 'ATTRIBUTE'
      ;

	  --TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.4-5'; 
      SET @v_description = N'4-5. #tmp_setup_key_item_id(to item) UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date

      /* FROM/TO SETUP KEY ID 가 동일 하면 SETUP TIME을 '0'으로 UPDATE 
         JOIN없이 처리하자~. 2024.07.01
      */
      UPDATE a
         SET a.setup_time_final  = 0
        FROM #tmp_setup_key_item_id a WITH(NOLOCK)
       WHERE a.from_final_key_id  = a.to_final_key_id
      ;
            
	  --TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.4-6'; 
      SET @v_description = N'4-6. #tmp_setup_key_item_id(from/to 동일한 key에 대해 Setup Time) UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date

      /*********************************************************/
      /* SETP5. case별 setup time 데이터 생성
           5-1. #tmp_buf_setup_matrix
                -> setup category = 'ATTRIBUTE' / FROM/TO ATTRIBUTE setup time 
                                                               */
      /*********************************************************/
      IF(OBJECT_ID('tempdb.dbo.#tmp_buf_setup_matrix') IS NOT NULL)
          BEGIN
              DROP TABLE #tmp_buf_setup_matrix;
          END
      
      /* TEMP TABLE */
      CREATE TABLE  #tmp_buf_setup_matrix(
              master_id           nvarchar(50),
	          plan_id             nvarchar(50),
	          instance_id         nvarchar(50),
	          plant_id            nvarchar(50),
	          operation_id        nvarchar(50),
	          line_setup_group_id nvarchar(50),
	          resource_group_id   nvarchar(50),
	          line_id             nvarchar(50),
	          setup_category_id   nvarchar(50),
	          from_item_id        nvarchar(150),
	          to_item_id          nvarchar(150),
	          from_final_key_org  nvarchar(1000),
	          to_final_key_org    nvarchar(1000),
	          from_org_key_attr   nvarchar(1000),
	          to_org_key_attr     nvarchar(1000),
	          from_final_key_attr nvarchar(1000),
	          to_final_key_attr   nvarchar(1000),
	          from_final_key_id   nvarchar(100) ,
	          to_final_key_id     nvarchar(100) ,
	          setup_time_final    numeric(20, 10),
	          setup_time_uom      nvarchar(10),
	          setup_type          nvarchar(100)
      );

      INSERT INTO #tmp_buf_setup_matrix(
                  master_id
                , plan_id
                , instance_id
                , plant_id
                , operation_id
                , line_setup_group_id
                , resource_group_id
                , line_id
                , setup_category_id
                , from_item_id
                , to_item_id
                , from_final_key_org
                , to_final_key_org
                , from_org_key_attr
                , to_org_key_attr
                , from_final_key_id
                , to_final_key_id
                , from_final_key_attr
                , to_final_key_attr
                , setup_time_final
                , setup_time_uom
                , setup_type
            ) 
       SELECT  DISTINCT
              @p_master_id      AS master_id
            , @p_engine_plan_id AS plan_id
            , a.instance_id
            , a.plant_id
            , a.operation_id
            , a.line_setup_group_id
            , b.resource_group_id
            , b.line_id
            , a.setup_category_id
            , a.from_item_id
            , a.to_item_id
            , a.from_final_key_id_org
            , a.to_final_key_id_org
            , a.from_final_key_id_attr_org
            , a.to_final_key_id_attr_org
            , a.from_final_key_id
            , a.to_final_key_id
            , a.from_final_key_id_attr
            , a.to_final_key_id_attr
            , a.setup_time_final
            , a.setup_time_uom
            , 'ATTRIBUTE'
        FROM  #tmp_setup_key_item_id        a
        JOIN  #tmp_th_eng_op_res_group_map  b
          ON  a.plant_id            = b.plant_id 
         AND  a.operation_id        = b.operation_id
         AND  a.line_setup_group_id = b.line_setup_group_id
         AND  a.from_item_id        = b.item_id
        JOIN  #tmp_th_eng_op_res_group_map  c
          ON  a.plant_id            = c.plant_id 
         AND  a.operation_id        = c.operation_id
         AND  a.line_setup_group_id = c.line_setup_group_id
         AND  a.to_item_id          = c.item_id
       WHERE  b.line_id             = c.line_id
      ;
      
	  --TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.5-1'; 
      SET @v_description = N'5-1. #tmp_buf_setup_matrix(SETUP CATEGORY = ATTRIBUTE)  생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date

      /*********************************************************/
      /*   5-2. #tmp_op_res_group_item
                ->setup 대상 라인의 생산 Item matrix 정보 생성     
                                                               */
      /*********************************************************/
	  IF(OBJECT_ID('tempdb.dbo.#tmp_op_res_group_item') IS NOT NULL)
         BEGIN
	         DROP TABLE #tmp_op_res_group_item;
         END

      /*TEMP TABLE*/
	  CREATE TABLE  #tmp_op_res_group_item(
	   		          master_id 			      nvarchar(50)
	   		        , plan_id				      nvarchar(50)
	   		        , site_id			          nvarchar(50)
	   		        , route_id		              nvarchar(50)
	   		        , operation_id		          nvarchar(50)
	   		        , plant_id		              nvarchar(50)
	   		        , line_id		              nvarchar(100)
	   		        , resource_group_id           nvarchar(1000)
	   		        , from_item_id		          nvarchar(500)
	   		        , to_item_id                  nvarchar(500)
	   		        , line_setup_group_id         nvarchar(1000)
	   		        , from_setup_group_id         nvarchar(1000)
	   		        , to_setup_group_id           nvarchar(1000)
	   		        , from_setup_group_id_attr    nvarchar(1000)
	   		        , to_setup_group_id_attr      nvarchar(1000)
	   		        , from_setup_group_id_org     nvarchar(1000)
	   		        , to_setup_group_id_org       nvarchar(1000)
	   		        , from_setup_group_attr_org   nvarchar(1000)
	   		        , to_setup_group_attr_org     nvarchar(1000)
                    , setup_time                  numeric(20, 10)
	   		        , setup_time_uom		      nvarchar(50)
	  );
          
      /* TEMP TABLE에 정보 생성 */
      INSERT INTO #tmp_op_res_group_item(
                  master_id
                , plan_id
                , site_id
                , route_id
                , operation_id
                , plant_id
                , line_setup_group_id
                , resource_group_id
                , line_id
                , from_item_id
                , to_item_id
                , from_setup_group_id_org
                , to_setup_group_id_org
                , from_setup_group_id_attr
                , to_setup_group_id_attr
                , from_setup_group_id
                , to_setup_group_id
                , from_setup_group_attr_org
                , to_setup_group_attr_org
                , setup_time
                , setup_time_uom
          )
       SELECT  DISTINCT
               a.master_id
             , a.plan_id
             , a.site_id
             , a.route_id
             , a.operation_id
             , a.plant_id
             , a.line_setup_group_id
             , a.resource_group_id   
             , a.line_id
             , a.from_item_id        AS from_item_id
             , a.to_item_id          AS to_item_id
             , a.from_item_id        AS from_setup_group_id_org
             , a.to_item_id          AS to_setup_group_id_org
             , a.from_item_id        AS from_setup_group_id_attr
             , a.to_item_id          AS to_setup_group_id_attr
             , a.from_item_id        AS from_setup_group_id
             , a.to_item_id          AS to_setup_group_id
             , a.from_item_id        AS from_setup_group_attr_org
             , a.to_item_id          AS to_setup_group_attr_org
             , b.setup_time
             , b.setup_time_uom
           FROM  (
                 SELECT  a.master_id
                       , a.plan_id
                       , a.site_id
                       , a.route_id
                       , a.operation_id
                       , a.plant_id
                       , a.line_id
                       , a.item_id AS from_item_id
                       , b.item_id AS to_item_id
                       , a.resource_group_id
                       , a.line_setup_group_id
                   FROM  #tmp_th_eng_op_res_group_map a --from
                   JOIN  #tmp_th_eng_op_res_group_map b --to
                     ON  a.site_id           =   b.site_id
                    AND  a.route_id          =   b.route_id
                    AND  a.operation_id      =   b.operation_id
                    AND  a.resource_group_id =   b.resource_group_id
                    AND  a.item_id           <>  b.item_id
                  WHERE 1=1
                    /* fp item attribute에 등록되지 않은 item들도 default setup time 생성하자~ 
                    AND a.fp_item_attribute_yn = 'Y'   --fp item attribute에 등록된 아이템 기준 default setup time 생성
                    AND  b.fp_item_attribute_yn = 'Y'
                     */
                   ) a
                   LEFT OUTER JOIN 
                   (
                   SELECT  a.plant_id
                         , a.operation_id
                         , a.line_setup_group_id
                         , MAX(b.setup_time)             AS setup_time
                         , MAX(b.setup_time_uom)         AS setup_time_uom
                     FROM  #tmp_setup_key_item_id a
                     JOIN  #tmp_fp_setup_matrix   b WITH(NOLOCK)  
                   --JOIN  dbo.temp_fp_setup_matrix_m b WITH(NOLOCK)
                       ON  a.instance_id               = b.instance_id
                      AND  a.line_setup_group_id       = b.line_setup_group_id
                    WHERE  b.setup_category_id         = 'ITEM'
                      AND  b.from_item_setup_group_id  = 'ALL'
                      AND  b.to_item_setup_group_id    = 'ALL'   
                    GROUP BY a.plant_id
                           , a.operation_id
                           , a.line_setup_group_id
                           , a.operation_id                    
                   ) b
               ON a.plant_id     = b.plant_id
              AND a.operation_id = b.operation_id
              AND a.line_setup_group_id = b.line_setup_group_id                     
      ;
      
 	  --TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.5-2'; 
      SET @v_description = N'5-2. #tmp_op_res_group_item 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date

      /*********************************************************/
      /*   5-3. #tmp_buf_setup_matrix
                -> setup category = 'ITEM' / FROM/TO ITEM_ID인 setup time 
                                                               */
      /*********************************************************/
      INSERT INTO #tmp_buf_setup_matrix(
                          master_id
                        , plan_id
                        , instance_id
                        , plant_id
                        , operation_id
                        , line_setup_group_id
                        , resource_group_id
                        , line_id
                        , setup_category_id
                        , from_item_id
                        , to_item_id
                        , from_final_key_org
                        , to_final_key_org
                        , from_org_key_attr
                        , to_org_key_attr
                        , from_final_key_id
                        , to_final_key_id
                        , from_final_key_attr
                        , to_final_key_attr
                        , setup_time_final
                        , setup_time_uom
                        , setup_type
                    ) 
          SELECT a.master_id
               , a.plan_id
               , a.instance_id
               , a.plant_id
               , a.operation_id
               , a.line_setup_group_id
               , a.resource_group_id
               , a.line_id
               , a.setup_category_id     
               , a.from_item_id
               , a.to_item_id
               , NULL                       AS from_final_key_org
               , NULL                       AS to_final_key_org
               , NULL                       AS from_org_key_attr
               , NULL                       AS to_org_key_attr
               , CASE WHEN b.from_final_key_id IS NOT NULL THEN CASE WHEN  a.setup_time != b.setup_time_final THEN b.from_final_key_id+'::'+a.from_item_id 
                                                                     ELSE  b.from_final_key_id
                                                                 END 
                      ELSE a.from_item_id
                  END                       AS from_final_key_id
               , CASE WHEN b.to_final_key_id IS NOT NULL THEN CASE WHEN  a.setup_time != b.setup_time_final THEN b.to_final_key_id+'::'+a.to_item_id 
                                                                     ELSE  b.to_final_key_id
                                                                 END 
                      ELSE a.to_item_id
                  END                       AS to_final_key_id
               , ISNULL(b.from_final_key_attr, a.from_item_id)
                                            AS from_final_key_attr
               , ISNULL(b.to_final_key_attr, a.to_item_id)
                                            AS to_final_key_attr
               , a.setup_time               AS setup_time
             --, b.setup_time_final         AS setup_time_org 
               , a.setup_time_uom           AS setup_time_uom
               , 'ITEM_ID'                  AS setup_type
           FROM
              (
              SELECT  b.master_id
                    , b.plan_id
                    , a.instance_id
                    , a.plant_id
                    , a.operation_id
                    , a.line_setup_group_id
                    , b.resource_group_id
                    , b.line_id
                    , a.setup_category_id     
                    , a.from_item_setup_group_id AS from_item_id
                    , a.to_item_setup_group_id   AS to_item_id 
                    , a.setup_time
                    , UPPER(a.setup_time_uom)    AS setup_time_uom 
              FROM #tmp_fp_setup_matrix a 
               JOIN #tmp_op_res_group_item b --bor
                 ON a.plant_id = b.plant_id
                AND a.operation_id = b.operation_id
                AND a.line_setup_group_id = b.line_setup_group_id
                AND a.from_item_setup_group_id = b.from_item_id
                AND a.to_item_setup_group_id   = b.to_item_id
              WHERE a.setup_category_id = 'ITEM'
                AND a.from_item_setup_group_id != 'ALL'
                AND a.to_item_setup_group_id != 'ALL'
              ) a
           LEFT OUTER JOIN 
              (
              SELECT b.*
                FROM #tmp_buf_setup_matrix b WITH(NOLOCK)
               WHERE b.setup_category_id = 'ATTRIBUTE'             
              ) b
           ON a.plant_id = b.plant_id
          AND a.operation_id = b.operation_id
          AND a.line_setup_group_id = b.line_setup_group_id
          AND a.resource_group_id   = b.resource_group_id
          AND a.from_item_id        = b.from_item_id
          AND a.to_item_id          = b.to_item_id
      ;
  
      -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.5-3'; 
      SET @v_description = N'5-3. #tmp_buf_setup_matrix(SETUP CATEGORY = ITEM_ID)  생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date

      /*********************************************************/
      /*   5-4. #tmp_item_setup_group_id
                -> FROM/TO ITEM_ID로 정의된 SETUP TIME에 대해, 기 정의된 SETUP TIME과 차이나는 것은 KEY_ID 새로 생성
                   (item attribute key_id들 조합 key + Item id)
                                                               */
      /*********************************************************/
      --from item 기준으로 update 
      UPDATE a
         SET a.com_final_key_id = b.from_final_key_id
        FROM #tmp_item_setup_group_id a
        JOIN (
              SELECT a.operation_id
                   , a.from_item_id
                   , MAX(a.from_final_key_id)   AS from_final_key_id
                   , MAX(a.from_final_key_attr) AS from_final_key_attr
                FROM #tmp_buf_setup_matrix a WITH(NOLOCK)
               WHERE a.setup_category_id = 'ITEM'
                 AND a.setup_type        = 'ITEM_ID'  
                 AND a.from_item_id     != from_final_key_id 
               GROUP
                  BY a.operation_id
                   , a.from_item_id
              ) b
         ON a.operation_id = b.operation_id
        AND a.item_id      = b.from_item_id
      WHERE a.com_final_key_id <> b.from_final_key_id
      ;

      -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.5-4'; 
      SET @v_description = N'5-4. #tmp_item_setup_group_id(from com_final_key_id)재생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date

      --to item 기준으로 update 
      UPDATE a
         SET a.com_final_key_id = b.to_final_key_id
        FROM #tmp_item_setup_group_id a
        JOIN (
              SELECT a.operation_id
                   , a.to_item_id
                   , MAX(a.to_final_key_id)     AS to_final_key_id
                   , MAX(a.to_final_key_attr)   AS to_final_key_attr
                FROM #tmp_buf_setup_matrix a WITH(NOLOCK)
               WHERE a.setup_category_id = 'ITEM'
                 AND a.setup_type        = 'ITEM_ID'  
                 AND a.to_item_id       !=  to_final_key_id 
               GROUP
                  BY a.operation_id
                   , a.to_item_id
              ) b
         ON a.operation_id = b.operation_id
        AND a.item_id      = b.to_item_id
      WHERE a.com_final_key_id <> b.to_final_key_id
      ;

      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.5-5'; 
      SET @v_description = N'5-5. #tmp_item_setup_group_id(to com_final_key_id)재생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date
      
      /*********************************************************/
      /*   5-6. #tmp_buf_setup_matrix
                -> setup category = 'ITEM' / FROM/TO ALL인 Default setup time 
                -> 최신 Item의 key id 기준으로
                                                               */
      /*********************************************************/
      INSERT INTO #tmp_buf_setup_matrix(
                                  master_id
                                , plan_id
                                , instance_id
                                , plant_id
                                , operation_id
                                , line_setup_group_id
                                , resource_group_id
                                , line_id
                                , setup_category_id
                                , from_item_id
                                , to_item_id
                                , from_final_key_org
                                , to_final_key_org
                                , from_org_key_attr
                                , to_org_key_attr
                                , from_final_key_id
                                , to_final_key_id
                                , from_final_key_attr
                                , to_final_key_attr
                                , setup_time_final
                                , setup_time_uom
                                , setup_type
                            )           
               SELECT a.master_id
                    , a.plan_id
                    , '-'                       AS instance_id
                    , a.plant_id
                    , a.operation_id
                    , a.line_setup_group_id
                    , a.resource_group_id
                    , a.line_id
                    , 'ITEM'                    AS setup_category_id
                    , a.from_item_id
                    , a.to_item_id
                    , NULL                      AS from_final_key_org
                    , NULL                      AS to_final_key_org
                    , NULL                      AS from_org_key_attr
                    , NULL                      AS to_org_key_attr
                    , a.from_final_key_id       AS from_final_key_id
                    , a.to_final_key_id         AS to_final_key_id
                    , a.from_final_key_attr     AS from_final_key_attr
                    , a.to_final_key_attr       AS to_final_key_attr
                    , a.setup_time              AS setup_time_final
                    , a.setup_time_uom
                    , 'ALL'                     AS setup_type
                FROM
                    (
                    SELECT  DISTINCT
                            a.master_id
                        , a.plan_id
                        , a.plant_id
                        , a.operation_id
                        , a.line_setup_group_id
                        , a.resource_group_id
                        , a.line_id
                        , a.from_item_id
                        , a.to_item_id
                        , ISNULL(b.com_final_key_id, a.from_item_id)
                                                    AS from_final_key_id
                        , ISNULL(c.com_final_key_id, a.to_item_id)
                                                    AS to_final_key_id
                        , ISNULL(b.com_final_key_id_attr, a.from_item_id)
                                                    AS from_final_key_attr
                        , ISNULL(c.com_final_key_id_attr, a.to_item_id)  
                                                    AS to_final_key_attr
                        , a.setup_time             
                        , a.setup_time_uom
                    FROM #tmp_op_res_group_item a
                    LEFT OUTER JOIN #tmp_item_setup_group_id b --from 
                      ON a.plant_id = b.plant_id
                     AND a.operation_id = b.operation_id
                     AND a.from_item_id = b.item_id
                    LEFT OUTER JOIN #tmp_item_setup_group_id c --to 
                      ON a.plant_id = c.plant_id
                     AND a.operation_id = c.operation_id
                     AND a.to_item_id   = c.item_id
                   WHERE a.setup_time > 0
                    ) a
            WHERE a.from_final_key_id != a.to_final_key_id
              AND NOT EXISTS  (
                              SELECT 'X'
                                FROM #tmp_buf_setup_matrix b WITH(NOLOCK)
                               WHERE b.plant_id           = a.plant_id
                                 AND b.operation_id       = a.operation_id
                                 AND b.resource_group_id  = a.resource_group_id
                                 AND b.from_item_id       = a.from_item_id
                                 AND b.to_item_id         = a.to_item_id
                              ) 
      ; 

      -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.5-6'; 
      SET @v_description = N'5-6. #tmp_buf_setup_matrix(SETUP CATEGORY = ITEM / ALL)  생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date

      /*********************************************************/
      /*   5-7. th_buf_setup_matrix (SETUP BackUP 데이터 생성)
                
                                                               */
      /*********************************************************/             
      /*기존 데이터 삭제 */
      DELETE ENG_SCP.dbo.th_buf_setup_matrix
       WHERE master_id  = @p_master_id
         AND plan_id    = @p_engine_plan_id
      ;

      INSERT INTO ENG_SCP.dbo.th_buf_setup_matrix
          (
            master_id
          , plan_id
          , instance_id
          , plant_id
          , operation_id
          , line_setup_group_id
          , resource_group_id
          , line_id
          , setup_category_id
          , from_item_id
          , to_item_id
          , from_final_key_org
          , to_final_key_org
          , from_org_key_attr
          , to_org_key_attr
          , from_final_key_attr
          , to_final_key_attr
          , from_final_key_id
          , to_final_key_id
          , setup_time_final
          , setup_time_uom
          , setup_type
          )
     SELECT master_id
          , plan_id
          , instance_id
          , plant_id
          , operation_id
          , line_setup_group_id
          , resource_group_id
          , line_id
          , setup_category_id
          , from_item_id
          , to_item_id
          , from_final_key_org
          , to_final_key_org
          , from_org_key_attr
          , to_org_key_attr
          , from_final_key_attr
          , to_final_key_attr
          , from_final_key_id
          , to_final_key_id
          , setup_time_final
          , setup_time_uom
          , setup_type
       FROM #tmp_buf_setup_matrix
      ;

      -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.5-7'; 
      SET @v_description = N'5-7. eng th_buf_setup_matrix 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date
            
      /*********************************************************/
      /* SETP6. ENG SETUP MATRIX 정보 생성/ 관련 ENG 테이블 Update
           6-1. th_eng_setup_matrix_sn
             SETUP TIME이 '0' 보다 클 경우 만                  */
      /*********************************************************/
      /*기존 데이터 삭제 */
      DELETE th_eng_setup_matrix_sn
      WHERE master_id  = @p_master_id
        AND plan_id    = @p_engine_plan_id
      ;
      
      /* CASE1. setup matrix 등록(attribute + Default setup time 중 item id로 정의된 setup time 없는 것)
       */
      INSERT INTO th_eng_setup_matrix_sn(
             master_id
           , plan_id
           , resource_setup_group_id
           , from_setup_group_id
           , to_setup_group_id
           , setup_time
           , setup_time_uom
                )
      SELECT a.master_id 
           , a.plan_id
           , a.line_setup_group_id+'^'+a.resource_group_id   AS eng_line_setup_group_id
             /* 최신 기준 key id로 등록 */
           , ISNULL(b.com_final_key_id, a.from_final_key_id) AS from_setup_group_id  
           , ISNULL(c.com_final_key_id, a.to_final_key_id)   AS to_setup_group_id
           , MAX(a.setup_time_final) AS setup_time
           , MAX(a.setup_time_uom)   AS setup_time_uom
        FROM #tmp_buf_setup_matrix a WITH(NOLOCK)
        LEFT OUTER JOIN (SELECT b.plant_id
                              , b.operation_id
                              , b.item_id
                              , MAX(b.com_final_key_id) AS com_final_key_id
                           FROM #tmp_item_setup_group_id b  --from
                          GROUP 
                             BY b.plant_id
                              , b.operation_id
                              , b.item_id
                         ) b
          ON a.plant_id     = b.plant_id
         AND a.operation_id = b.operation_id
         AND a.from_item_id = b.item_id
        LEFT OUTER JOIN (
                         SELECT b.plant_id
                              , b.operation_id
                              , b.item_id
                              , MAX(b.com_final_key_id) AS com_final_key_id
                           FROM #tmp_item_setup_group_id b  --to
                          GROUP 
                             BY b.plant_id
                              , b.operation_id
                              , b.item_id
                        ) c  -- 최신
          ON a.plant_id     = b.plant_id
         AND a.operation_id = c.operation_id
         AND a.to_item_id   = c.item_id
       WHERE a.setup_type <> 'ITEM_ID'
         AND a.setup_time_final > 0
         AND NOT EXISTS (
                         SELECT 'X'
                           FROM #tmp_buf_setup_matrix x WITH(NOLOCK)
                          WHERE x.resource_group_id = a.resource_group_id
                            AND x.setup_category_id = 'ITEM'
                            AND x.setup_type        = 'ITEM_ID'
                            AND x.from_item_id      = a.from_item_id
                            AND x.to_item_id        = a.to_item_id
                         )
      GROUP 
         BY a.master_id 
          , a.plan_id
          , a.line_setup_group_id+'^'+a.resource_group_id
          , ISNULL(b.com_final_key_id, a.from_final_key_id)
          , ISNULL(c.com_final_key_id, a.to_final_key_id)
      ;

	  --TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.6-1'; 
      SET @v_description = N'6-1. eng th_eng_setup_matrix_sn 생성(Case1)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date

      /* CASE2. setup matrix 등록(item id로 정의된 setup time )
       */
      INSERT INTO th_eng_setup_matrix_sn(
              master_id
            , plan_id
            , resource_setup_group_id
            , from_setup_group_id
            , to_setup_group_id
            , setup_time
            , setup_time_uom
           )
      SELECT  a.master_id 
            , a.plan_id
            , a.line_setup_group_id+'^'+a.resource_group_id AS eng_line_setup_group_id
              /* ITEM으로 등록된 거는 최신 key id이기 때문에 그대로 사용 */
            , a.from_final_key_id
            , a.to_final_key_id
            , MAX(a.setup_time_final) AS setup_time
            , MAX(a.setup_time_uom)   AS setup_time_uom
         FROM #tmp_buf_setup_matrix a WITH(NOLOCK)
        WHERE a.setup_category_id = 'ITEM'
          AND a.setup_type        = 'ITEM_ID'
          AND a.setup_time_final > 0
          AND NOT EXISTS (
                          SELECT 'X'
                            FROM th_eng_setup_matrix_sn x WITH(NOLOCK)
                           WHERE x.master_id = @p_master_id
                             AND x.plan_id   = @p_engine_plan_id
                             AND x.resource_setup_group_id = a.line_setup_group_id+'::'+a.resource_group_id
                             AND x.from_setup_group_id = a.from_final_key_id
                             AND x.to_setup_group_id   = a.to_final_key_id
                          )
      GROUP 
         BY a.master_id 
         , a.plan_id
         , a.line_setup_group_id+'^'+a.resource_group_id
         , a.from_final_key_id
         , a.to_final_key_id
      ;

      -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.6-2'; 
      SET @v_description = N'6-2. eng th_eng_setup_matrix_sn 생성(Case2)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date
      
      /***************************************************************/
      /*
           6-3. th_eng_item_sn 
                -> 대상 Item의 setup_group_id UPDATE. 2024.07.09 수정 */
      /****************************************************************/
      --Setup 설비 대상 Item 모두 NULL 처리
      UPDATE  a
         SET  a.setup_group_id  = NULL
        FROM  th_eng_item_sn a WITH(NOLOCK)
      WHERE a.master_id   = @p_master_id
        AND a.plan_id     = @p_engine_plan_id
        AND EXISTS (SELECT 'X'
                      FROM #tmp_th_eng_op_res_group_map x
                     WHERE x.item_id = a.item_id
                    )
      ;

      -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.6-3'; 
      SET @v_description = N'6-3. eng th_eng_item_sn.setup_group_id UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

      /*************************************************************************/
      /*
           6-4. th_eng_item_route_site_sn 
                -> 대상 Item의 plant별 setup_group_id UPDATE. 2024.07.09 추가 **/
      /*************************************************************************/
      --1) Default는 Item id로 셋팅
      UPDATE a
         SET a.attr05  = a.item_id
        FROM th_eng_item_route_site_sn a WITH(NOLOCK)
       WHERE a.master_id = @p_master_id
         AND a.plan_id   = @p_engine_plan_id
         AND EXISTS (SELECT 'X'
                       FROM #tmp_th_eng_op_res_group_map x
                      WHERE x.site_id = a.site_id
                        AND x.item_id = a.item_id
                     )
      ;

      --2) fp setup group key로 재셋팅
      UPDATE a
         SET a.attr05  = b.com_final_key_id
        FROM th_eng_item_route_site_sn a WITH(NOLOCK)
        JOIN (
              SELECT b.plant_id
                   , b.operation_id
                   , b.item_id
                   , MAX(b.com_final_key_id) AS com_final_key_id
                FROM #tmp_item_setup_group_id b
               GROUP 
                  BY b.plant_id
                   , b.operation_id
                   , b.item_id        
             ) b
          ON a.site_id   LIKE b.plant_id+'%' 
         AND a.operation_id = b.operation_id
         AND a.item_id   = b.item_id
       WHERE a.master_id = @p_master_id
         AND a.plan_id   = @p_engine_plan_id
      ;

      -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.6-4'; 
      SET @v_description = N'6-4. eng th_eng_item_route_site_sn.setup_group_id UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

      /*****************************************************/
      /*
           6-5. th_eng_resource_sn 
                -> resource_setup_group_id UPDATE          */
      /*****************************************************/
      UPDATE  a
         SET  a.resource_setup_group_id = b.resource_setup_group_id
        FROM  th_eng_resource_sn  a WITH(NOLOCK)
        JOIN  (
              SELECT  DISTINCT 
                      a.resource_group_id
                    , a.line_setup_group_id+'^'+a.resource_group_id AS resource_setup_group_id 
                FROM #tmp_buf_setup_matrix a
               WHERE  1 = 1
               ) b
          ON  a.resource_group_id = b.resource_group_id
       WHERE  a.master_id   = @p_master_id
         AND  a.plan_id     = @p_engine_plan_id
      ;

      -- TXN LOG
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'TXN';
      SET @v_log_message = 'SETP.6-5'; 
      SET @v_description = N'6-5. eng th_eng_resource_sn.resource_setup_group_id UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

      ------------------------------------------------------------
      --임시테이블 삭제
      ------------------------------------------------------------
	  IF(OBJECT_ID('tempdb.dbo.#tmp_th_eng_op_res_group_map') IS NOT NULL)
      BEGIN
	    DROP TABLE #tmp_th_eng_op_res_group_map;
      END

      IF(OBJECT_ID('tempdb.dbo.#tmp_fp_item_setup_attr_org') IS NOT NULL)
      BEGIN
	    DROP TABLE #tmp_fp_item_setup_attr_org;
      END

      IF(OBJECT_ID('tempdb.dbo.#tmp_fp_item_setup_attr_new') IS NOT NULL)
      BEGIN
	    DROP TABLE #tmp_fp_item_setup_attr_new;
      END

      IF(OBJECT_ID('tempdb.dbo.#tmp_item_setup_group_id') IS NOT NULL)
      BEGIN
	    DROP TABLE #tmp_item_setup_group_id;
      END
      
      IF(OBJECT_ID('tempdb.dbo.#tmp_fp_setup_matrix') IS NOT NULL)
      BEGIN
      	  DROP TABLE #tmp_fp_setup_matrix;
      END
      
      IF(OBJECT_ID('tempdb.dbo.#tmp_setup_group_key_id') IS NOT NULL)
      BEGIN
          DROP TABLE #tmp_setup_group_key_id;
      END
      
      IF(OBJECT_ID('tempdb.dbo.#tmp_setup_key_item_id') IS NOT NULL)
      BEGIN
          DROP TABLE #tmp_setup_key_item_id;
      END
      
      IF(OBJECT_ID('tempdb.dbo.#tmp_op_res_group_item') IS NOT NULL)
      BEGIN
          DROP TABLE #tmp_op_res_group_item;
      END

      IF(OBJECT_ID('tempdb.dbo.#tmp_buf_setup_matrix') IS NOT NULL)
      BEGIN
          DROP TABLE #tmp_buf_setup_matrix;
      END

    END TRY

    BEGIN CATCH
      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()) + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      RETURN -1
    END CATCH

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    RETURN 1

  END