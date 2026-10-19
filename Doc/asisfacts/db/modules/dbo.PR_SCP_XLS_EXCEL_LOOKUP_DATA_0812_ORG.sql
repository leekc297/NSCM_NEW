



/*
 * Program ID   : PR_SCP_XLS_EXCEL_LOOKUP_DATA
 * Description  : SCP SIMULATION LOOKUP DATA QUERY
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.01.07   YYDOK         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.01.21   KTH           CELL_ITEM_ID 추가
 * 2019.02.13   KTH           VERSION CHECK 추가
 * 2019.02.20   KTH           @p_pgm_code 추가
 * 2019.02.21   KTH           소형 PACK 추가(XLSPSI02)
 * 2019.02.21   KTH           END_CUSTOMER 추가(XLSPSI02)
 * 2019.02.21   KTH           CELL_TYPE_GROUP_CODE 추가 
 * 2019.03.08   KSW           END_CUSTOMER CHECK 와 CELL TYPE 순서를 변경함, CELL_ITEM_ID : 모델정보 XLSPSI03 포함
 * 2019.03.21   KTH           소형 PACK Planner ID별 Item_ID 조회조건 추가(XLSPSI02)
 * 2019.05.08   KSW           소형 CELL LINE 리스트 추가, END_CUSTOMER CHECK 주석처리(사용안함)
 * 2019.06.05   KTH           소형 PACK AND G.OPERATION_GROUP ='A' 조건 주석 처리
 * 2019.06.27   KTH           [PJ20189106] 전지.GSCM 고도화 이행 ESS(82) 추가
 * 2019.08.13   KSW           #1. DIVISION_ID : 사업부구분 - WHERE DIVISION_ID 주석처리 - 전극 시뮬레이터 개발관련
 * 2019.11.05   KTH           소형 PACK 조회조건 변경(OPERATION_GROUP이 'A'만 존재하는 CELL_ITEM_ID는 제외)
 * 2019.12.13   KTH           전극 조회조건 추가
 * 2020.02.06   KTH           ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정(SCM_MST_LINE_SN --> SCM_MST_LINE_V 변경)
 * 2020.02.11   KSW           전극 BUILDING 정보 추가
 * 2020.02.25   KSW           ESS PACK / CELL 분리
 * 2020.03.03   KSW           ESS PACK - SITE 정보추가
 * 2020.05.25   KTH           @p_user_id       NVARCHAR(0150)  = 'SCP_batch'   추가
 * 2020.05.25   KTH           #9. 전극 광폭 여부, #10. WORKING TIME, #11. TACT TIME 추가
 * 2020.11.23   KSW           'PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - XLSPSI21: 소형 SHIPMENT PLAN 입력 SIMULATION 추가
 * 2021.05.26   KSW			  CELL measure 정보만 존재할 경우 조회창에 모델이 표시되지 않는 오류 수정
 * 2021.05.26   KSW           'PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - XLSPSI22: ESS SHIPMENT PLAN 입력 SIMULATION 추가
 * 2021.05.28   KSW           전극 시뮬레이터 Add Prod Line tact time/working time 을 CAPA UI 에 표시되는 값으로 변경
 * 2021.09.06   KSW           전극 시뮬레이터 Add Prod Line CAPA Line Assign 업데이트 기한을 -7일로 변경
 * 2022.03.23	KSW	          GM JV 반영
 * 2022.05.02	KSW			  소형 PACK 시뮬레이터 :: Daily 주차 및 Monthly 선택을 위한 DATA 추가
 * 2023.05.08	KSK			  [PJ20230691] SCM 역량 강화 위한 SCP 개선과제 이행 (ESHM JV 사업부 지원)
 * 2023.08.03	KSK			  [PJ20230691] SCM 역량 강화 위한 SCP 개선과제 이행 (아이템 FIND 데이터 중복 개선)
 * 2023.09.21	KSK			  [PJ20230692] SCM 역량 강화 위한 SCP Phase2 개선과제 이행 (자동차 시뮬레이터 대치그룹 기능 개발)
 */

CREATE PROCEDURE [dbo].[PR_SCP_XLS_EXCEL_LOOKUP_DATA_0812_ORG](
     @p_division_id   NVARCHAR(010)
    ,@p_pgm_code      NVARCHAR(040)  = 'XLSPSI01'
    ,@p_user_id       NVARCHAR(150)  = 'scp_batch'        
 )
AS

BEGIN


DECLARE @p_plan_start_yyyymmdd  NVARCHAR(8) = ''

-- 2021.03.23   KSW           'PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - XLSPSI22: ESS SHIPMENT PLAN 입력 SIMULATION 추가 - START
DECLARE @p_plan_type            NVARCHAR(4000) = 'MA';
DECLARE @p_seq                  NVARCHAR(0008) = NULL;

DECLARE @v_plan_start_yyyymmdd  NVARCHAR(0008);
DECLARE @v_seq                  NVARCHAR(0008)
-- 2021.03.23   KSW           'PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - XLSPSI22: ESS SHIPMENT PLAN 입력 SIMULATION 추가 - END

  -----------------------------------------
  -- #1. DIVISION_ID : 사업부구분
  -----------------------------------------
  
IF CHARINDEX ('_' , @p_division_id )  > 0
BEGIN
	DECLARE @OWNER NVARCHAR(10) ;
	SET @OWNER = LEFT(@p_division_id, CHARINDEX('_', @p_division_id) -1);
	SELECT DIVISION_ID,DIVISION_NAME
	FROM SCM_MST_DIVISION WITH(NOLOCK)
	WHERE DIVISION_ID != @OWNER AND ATTRIBUTE3 = @OWNER ;
END
ELSE 
BEGIN
	SELECT DIVISION_ID,DIVISION_NAME
	FROM SCM_MST_DIVISION WITH(NOLOCK)
END

  -----------------------------------------
  -- #2. CELL_ITEM_ID : 모델정보
  -----------------------------------------

  IF @p_pgm_code = 'XLSPSI01' 
	
    BEGIN

	 if @p_division_id = '81' 
      SELECT DISTINCT G.DIVISION_ID, G.OPERATION_GROUP_NAME, G.CELL_ITEM_ID,F.NICK_NAME
	  --대치그룹정보 추가::2023-07-19, KSK
		, F.LEVEL2_CODE AS REPLACE_GROUP, F.REPLACEMENT AS REPLACE_YN
      FROM SCP_XLS_PSI_GLOBAL G WITH(NOLOCK),
           SCP_MST_FINAL_ITEM F WITH(NOLOCK)
     WHERE 0 = 0
       AND G.OPERATION_GROUP ='A'
	   AND G.DIVISION_ID     = @p_division_id			-- 2022.03.23	KSW	          GM JV 반영
       AND G.DIVISION_ID     = F.DIVISION_ID
       AND G.CELL_ITEM_ID    = F.ITEM_ID  
	   AND F.ATTRIBUTE8 = 'CP'				--2023/06/20 Edit by DHJ 시뮬레이터 FIND 조회 시 PROD 기준으로만 조회
     ORDER BY G.DIVISION_ID,G.OPERATION_GROUP_NAME DESC,G.CELL_ITEM_ID
   else 
	  SELECT DISTINCT G.DIVISION_ID, G.OPERATION_GROUP_NAME, G.CELL_ITEM_ID,F.NICK_NAME
      FROM SCP_XLS_PSI_GLOBAL G WITH(NOLOCK),
           SCP_MST_FINAL_ITEM F WITH(NOLOCK)
     WHERE 0 = 0
       AND G.OPERATION_GROUP ='A'
	   AND G.DIVISION_ID     = @p_division_id			-- 2022.03.23	KSW	          GM JV 반영
       AND G.DIVISION_ID     = F.DIVISION_ID
       AND G.CELL_ITEM_ID    = F.ITEM_ID  
	   AND F.ATTRIBUTE8 = 'CP'				--2023/06/20 Edit by DHJ 시뮬레이터 FIND 조회 시 PROD 기준으로만 조회
     ORDER BY G.DIVISION_ID,G.OPERATION_GROUP_NAME DESC,G.CELL_ITEM_ID
    END
 ;  


   IF @p_pgm_code = 'XLSPSI02' 
    BEGIN
      SELECT DISTINCT G.DIVISION_ID, G.CELL_ITEM_ID,F.NICK_NAME, F.ATTRIBUTE2 AS PLANNER_ID  -- PACK PLANNER USER ID SETTING 소형팩 시뮬레이션용 베어셀별 팩플래너 담당자지정
      FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK G WITH(NOLOCK),
           SCP_MST_FINAL_ITEM F WITH(NOLOCK)
     WHERE 0 = 0
      -- AND G.OPERATION_GROUP ='A'
       AND G.DIVISION_ID     = F.DIVISION_ID
       AND G.CELL_ITEM_ID    = F.ITEM_ID 
       AND EXISTS (        
                                           SELECT 'X'        
                                              FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK Z WITH(NOLOCK)        
                                            WHERE 1=1        
                                              AND Z.DIVISION_ID              = G.DIVISION_ID                                
                                              AND Z.OPERATION_GROUP          = G.OPERATION_GROUP                            
                                              AND Z.CELL_ITEM_ID             = G.CELL_ITEM_ID
                                              --AND Z.OPERATION_GROUP          = 'P'		-- 2021.05.26   KSW			  CELL measure 정보만 존재할 경우 조회창에 모델이 표시되지 않는 오류 수정

                                         )  

     ORDER BY G.DIVISION_ID, F.ATTRIBUTE2, G.CELL_ITEM_ID
    END
 ;  


   IF @p_pgm_code = 'XLSPSI03'
    BEGIN
      SELECT DISTINCT G.DIVISION_ID, 'A' AS OPERATION_GROUP_NAME, G.CELL_ITEM_ID ,F.NICK_NAME
      FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL G WITH(NOLOCK),
           SCP_MST_FINAL_ITEM F WITH(NOLOCK)
     WHERE 0 = 0
       AND G.DIVISION_ID    = F.DIVISION_ID
       AND G.CELL_ITEM_ID   = F.ITEM_ID 
     ORDER BY G.DIVISION_ID, G.CELL_ITEM_ID /*G.OPERATION_GROUP_NAME DESC,*/
    END
 ;  

 IF @p_pgm_code = 'XLSPSI04' 
    BEGIN
     -- SELECT DISTINCT G.DIVISION_ID, UPPER(G.OPERATION_GROUP_NAME) AS OPERATION_GROUP_NAME, G.CELL_ITEM_ID,F.NICK_NAME
     -- FROM SCP_XLS_PSI_GLOBAL_ESS G WITH(NOLOCK),
     --      SCP_MST_FINAL_ITEM F WITH(NOLOCK)
     --WHERE 0 = 0
     --  AND G.OPERATION_GROUP ='A'
     --  AND G.DIVISION_ID     = F.DIVISION_ID
     --  AND G.CELL_ITEM_ID    = F.ITEM_ID
     --ORDER BY G.DIVISION_ID,UPPER(G.OPERATION_GROUP_NAME) DESC,G.CELL_ITEM_ID


     SELECT DISTINCT G.DIVISION_ID, UPPER(F.OPERATION_GROUP) AS OPERATION_GROUP_NAME, G.CELL_ITEM_ID,F.NICK_NAME
      FROM SCP_XLS_PSI_GLOBAL_ESS G WITH(NOLOCK),
           SCP_MST_FINAL_ITEM F WITH(NOLOCK)
     WHERE 0 = 0
       AND F.OPERATION_GROUP ='A'
       --AND G.DIVISION_ID     = F.DIVISION_ID
       AND G.CELL_ITEM_ID    = F.ITEM_ID
     ORDER BY G.DIVISION_ID,UPPER(F.OPERATION_GROUP) DESC,G.CELL_ITEM_ID

    END
 ;

 --JV 사업부 구분을 위한 전극그룹 준비 
 DECLARE @EE_GROUP NVARCHAR(30)
 select @EE_GROUP = attribute4 from scm_mst_division with(nolock) where DIVISION_ID = @p_division_id

 -- 전극 조회조건 
 IF @p_pgm_code = 'XLSPSI05' 
    BEGIN
    -- Plant
     SELECT DIVISION_ID, SCM_SITE_ID, SITE_DESCRIPTION , *
      FROM SCM_MST_SITE WITH (NOLOCK)
      WHERE OPERATION_GROUP ='E'
--	    AND  (CASE WHEN DIVISION_ID IN ('81', '82', '40') THEN 'LG' ELSE 'GM' END) = (CASE WHEN @p_division_id = 'EE_UC' THEN 'GM' ELSE 'LG' END)	-- 2022.03.23	KSW	          GM JV 반영	
	    AND   DIVISION_ID IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE4 = @EE_GROUP) 	-- 2022.05.17	KSK	          JV 반영	
    ORDER BY 2

    -- FIND MODEL
  --   SELECT DISTINCT X.PLANT_SITE_ID AS SCM_SITE_ID
  --            ,Y.OPERATION_GROUP AS OPERATION_GROUP_NAME
  --            ,X.ITEM_ID AS CELL_ITEM_ID
  --            ,Y.NICK_NAME AS NICK_NAME
  --     FROM SCM_MST_SITE_ITEM_PRIORITY X WITH (NOLOCK)
  --     INNER JOIN SCP_MST_FINAL_ITEM Y WITH (NOLOCK)
  --      ON X.ITEM_ID = Y.ITEM_ID
  --    WHERE 1 = 1 
  --      AND X.PLANT_SITE_ID LIKE '%-E'
  --      AND X.VALID_YN      = 'Y'
  --      AND X.TO_YYYYMMDD   > dbo.FN_GET_BUCKET_YYYYMMDD(0)   
		--AND (CASE WHEN Y.DIVISION_ID IN ('81', '82', '40') THEN 'LG' ELSE 'GM' END) = (CASE WHEN @p_division_id = 'EE_UC' THEN 'GM' ELSE 'LG' END)	-- 2022.03.23	KSW	          GM JV 반영

	-- 생산계획과 조회목록이 일치하지 않는 문제점 개선 :: 2022.10.31
	 SELECT DISTINCT SCM_SITE_ID, OPERATION_GROUP_NAME, CELL_ITEM_ID, NICK_NAME
	   from (
		 SELECT DISTINCT X.PLANT_SITE_ID AS SCM_SITE_ID
				  ,Y.OPERATION_GROUP AS OPERATION_GROUP_NAME
				  ,X.ITEM_ID AS CELL_ITEM_ID
				  ,Y.NICK_NAME AS NICK_NAME
		   FROM SCM_MST_SITE_ITEM_PRIORITY X WITH (NOLOCK)
		   INNER JOIN SCP_MST_FINAL_ITEM Y WITH (NOLOCK)
			ON X.ITEM_ID = Y.ITEM_ID
		  WHERE 1 = 1 
			AND X.PLANT_SITE_ID LIKE '%-E'
			AND X.VALID_YN      = 'Y'
			AND X.TO_YYYYMMDD   > dbo.FN_GET_BUCKET_YYYYMMDD(0)   
			--AND (CASE WHEN Y.DIVISION_ID IN ('81', '82', '40') THEN 'LG' ELSE 'GM' END) = (CASE WHEN @p_division_id = 'EE_UC' THEN 'GM' ELSE 'LG' END)	-- 2022.03.23	KSW	          GM JV 
			AND   Y.DIVISION_ID IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE4 = @EE_GROUP)
		UNION ALL
		SELECT FROM_SITE_ID AS SCM_SITE_ID
			  ,'E' AS OPERATION_GROUP_NAME
			  ,ITEM_ID AS CELL_ITEM_ID
			  ,NICK_NAME
		  FROM SCP_XLS_PSI_GLOBAL_ELECTRODE E WITH (NOLOCK)
		 WHERE DIVISION_ID = @p_division_id
		   AND LEN(CELL_TYPE_GROUP_CODE) > 0

	 ) XX
    END
 ;  

 IF @p_pgm_code = 'XLSPSI06' 
    BEGIN
     -- SELECT DISTINCT G.DIVISION_ID, UPPER(G.OPERATION_GROUP_NAME) AS OPERATION_GROUP_NAME, G.CELL_ITEM_ID,F.NICK_NAME
     -- FROM SCP_XLS_PSI_GLOBAL_ESS G WITH(NOLOCK),
     --      SCP_MST_FINAL_ITEM F WITH(NOLOCK)
     --WHERE 0 = 0
     --  AND G.OPERATION_GROUP ='A'
     --  AND G.DIVISION_ID     = F.DIVISION_ID
     --  AND G.CELL_ITEM_ID    = F.ITEM_ID
     --ORDER BY G.DIVISION_ID,UPPER(G.OPERATION_GROUP_NAME) DESC,G.CELL_ITEM_ID


     SELECT DISTINCT G.DIVISION_ID, UPPER(F.OPERATION_GROUP) AS OPERATION_GROUP_NAME, G.CELL_ITEM_ID,F.NICK_NAME
      FROM SCP_XLS_PSI_GLOBAL_ESS G WITH(NOLOCK),
           SCP_MST_FINAL_ITEM F WITH(NOLOCK)
     WHERE 0 = 0
       AND F.OPERATION_GROUP ='A'
       --AND G.DIVISION_ID     = F.DIVISION_ID
       AND G.CELL_ITEM_ID    = F.ITEM_ID
     ORDER BY G.DIVISION_ID,UPPER(F.OPERATION_GROUP) DESC,G.CELL_ITEM_ID

    END
 ;

 IF @p_pgm_code = 'XLSPSI07' 
    BEGIN
     -- SELECT DISTINCT G.DIVISION_ID, UPPER(G.OPERATION_GROUP_NAME) AS OPERATION_GROUP_NAME, G.CELL_ITEM_ID,F.NICK_NAME
     -- FROM SCP_XLS_PSI_GLOBAL_ESS G WITH(NOLOCK),
     --      SCP_MST_FINAL_ITEM F WITH(NOLOCK)
     --WHERE 0 = 0
     --  AND G.OPERATION_GROUP ='A'
     --  AND G.DIVISION_ID     = F.DIVISION_ID
     --  AND G.CELL_ITEM_ID    = F.ITEM_ID
     --ORDER BY G.DIVISION_ID,UPPER(G.OPERATION_GROUP_NAME) DESC,G.CELL_ITEM_ID


     SELECT DISTINCT G.DIVISION_ID, UPPER(F.OPERATION_GROUP) AS OPERATION_GROUP_NAME, G.CELL_ITEM_ID,F.NICK_NAME
      FROM SCP_XLS_PSI_GLOBAL_ESS G WITH(NOLOCK),
           SCP_MST_FINAL_ITEM F WITH(NOLOCK)
     WHERE 0 = 0
       AND F.OPERATION_GROUP ='A'
       --AND G.DIVISION_ID     = F.DIVISION_ID
       AND G.CELL_ITEM_ID    = F.ITEM_ID
     ORDER BY G.DIVISION_ID,UPPER(F.OPERATION_GROUP) DESC,G.CELL_ITEM_ID

    END
 ;

  -----------------------------------------
  -- #3. VERSION CHECK
  -----------------------------------------
SELECT SEGMENT2, SEGMENT4, DESCRIPTION, SEGMENT5 
  FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)  
 WHERE LOOKUP_TYPE  ='SCP_SIMULATOR_VER'
   AND SEGMENT1     = @p_division_id -- DIVISION_ID
   AND VALID_YN ='Y' 
ORDER BY SEGMENT2, SEGMENT4


  -----------------------------------------
  -- #4. CELL TYPE
  -----------------------------------------
SELECT  SEGMENT1 AS CELL_TYPE_GROUP_CODE,
        SEGMENT2 AS CELL_TYPE_GROUP_NAME
  FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
 WHERE LOOKUP_TYPE ='CELL_TYPE_GROUP_CODE'
   AND VALID_YN ='Y'


  -----------------------------------------
  -- #5. END_CUSTOMER CHECK
  -----------------------------------------
--SELECT END_CUSTOMER, SOLDTO_CUSTOMER,* 
--  FROM SCM_MST_SITE  WITH (NOLOCK)  -- END_CUSTOMER, SOLDTO_CUSTOMER
-- WHERE 0 = 0
--   AND DIVISION_ID = @p_division_id -- '40'
----AND SITE_TYPE ='SALES'

  -----------------------------------------
  -- #5. REPLACE GROUP
  -----------------------------------------
 -- 대치그룹 기능지원::2020-07-21, KSK
IF @p_pgm_code = 'XLSPSI01'  
BEGIN

   if @p_division_id = '81' 
   begin
   -- 대치그룹정보
	SELECT DISTINCT F.LEVEL2_CODE AS CODE, F.LEVEL2_CODE AS NAME
	FROM SCP_XLS_PSI_GLOBAL G WITH(NOLOCK)
	INNER JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)
		ON  G.OPERATION_GROUP ='A'
		AND G.DIVISION_ID     = F.DIVISION_ID
		AND G.CELL_ITEM_ID    = F.ITEM_ID  
		AND F.ATTRIBUTE8 = 'CP'				
	WHERE G.DIVISION_ID    = @p_division_id		
	AND ISNULL(F.LEVEL2_CODE, '') <> ''
   end;

	--메저정보
	SELECT COLUMN_NAME AS CODE , COLUMN_LABEL_NAME AS NAME
	FROM DBO.SCM_MST_SHEET_MEASURE WITH(NOLOCK)
	WHERE PROGRAM_ID = @p_pgm_code 
	;
END

  -----------------------------------------
  -- #6. CELL TYPE에 대한 LINE, CELL ITEM 목록
  -----------------------------------------
  IF @p_pgm_code = 'XLSPSI03' 
    BEGIN
      SELECT DISTINCT X.CELL_TYPE_GROUP_CODE
                  --, Y.SCM_SITE_ID
                  , X.PROD_LINE
                  , Y.LINE_NAME + ' [' + Y.SITE_DESCRIPTION + ']' AS LINE_SITE_DESC
                  ,X.CELL_ITEM_ID 
      FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL X WITH (NOLOCK)
      INNER JOIN (SELECT A.LINE_ID,  A.LINE_NAME, B.SCM_SITE_ID, B.SITE_DESCRIPTION
                    FROM SCM_MST_LINE_V A WITH (NOLOCK)
--                    FROM SCM_MST_LINE_SN  A WITH (NOLOCK)
              INNER JOIN SCM_MST_SITE B WITH (NOLOCK)
                     ON A.COMPANY_ID  = B.COMPANY_ID 
  							    AND A.DIVISION_ID = B.DIVISION_ID 
	                  AND A.PLANT_ID    = B.PLANT_ID 
								    AND A.SITE_ID     = B.SITE_ID
                  WHERE A.DIVISION_ID ='40'
                    AND OPERATION_ID IN ('A3000','A9000')) Y 
        ON X.PROD_LINE = Y.LINE_ID
    END
 ; 


  -----------------------------------------
  -- #7. 전극 BUILDING 정보 추가
   -----------------------------------------
  IF @p_pgm_code = 'XLSPSI05' 
    BEGIN
      SELECT 
			 DISTINCT
				LS.DIVISION_ID
			   ,S.SCM_SITE_ID
			   ,FS.FACTORY_ID
			   ,FS.FACTORY_NAME
			 --FROM SCM_MST_LINE_SN LS WITH (NOLOCK)
       FROM SCM_MST_LINE_V LS WITH (NOLOCK)       
			 INNER JOIN SCM_MST_SITE S WITH (NOLOCK) 
				 ON LS.COMPANY_ID   = S.COMPANY_ID 
			  AND LS.DIVISION_ID  = S.DIVISION_ID 
			  AND LS.PLANT_ID     = S.PLANT_ID 
			  AND LS.SITE_ID      = S.SITE_ID
			  INNER JOIN SCM_MST_FACTORY_SN FS WITH (NOLOCK) 
				 ON LS.COMPANY_ID   = FS.COMPANY_ID 
			  AND LS.DIVISION_ID  = FS.DIVISION_ID 
			  AND LS.PLANT_ID     = FS.PLANT_ID 
			  AND LS.SITE_ID      = FS.SITE_ID 
			  AND LS.FACTORY_ID   = FS.FACTORY_ID
			  AND S.OPERATION_GROUP = FS.SHOP_GROUP_ID
			WHERE  -- (CASE WHEN S.DIVISION_ID IN ('81', '82', '40') THEN 'LG' ELSE 'GM' END) = (CASE WHEN @p_division_id = 'EE_UC' THEN 'GM' ELSE 'LG' END)		-- 2022.03.23	KSW	          GM JV 반영
				   S.DIVISION_ID IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE4 = @EE_GROUP)

			ORDER BY 3
    END
 ; 

   -----------------------------------------
  -- #8. ESS PACK SITE 정보 추가
   -----------------------------------------
  IF @p_pgm_code = 'XLSPSI06' 
    BEGIN
      select country, operation_group, scm_site_id, site_description
	   from scm_mst_site with(nolock)
	  where site_type = 'PLANT'
	  order by division_id, operation_group
    END
 ; 


  -----------------------------------------
  -- #9. 전극 광폭 여부
   -----------------------------------------
   /*@p_pgm_code = 'XLSPSI05' */ 
  IF @p_user_id <> 'scp_batch'
    BEGIN

        SELECT TOP 1  @p_plan_start_yyyymmdd = PLAN_START_YYYYMMDD 
		  FROM SCP_XLS_PSI_GLOBAL_ELECTRODE  WITH (NOLOCK)
		 WHERE DIVISION_ID         = @p_division_id		-- 2022.03.23	KSW	GM JV 반영
		 ;

      SELECT A.FROM_SITE_ID,  A.PROD_LINE, C.ATTRIBUTE1 AS MEASURE_VALUE2_LABEL
        FROM  SCP_XLS_PSI_GLOBAL_ELECTRODE A WITH (NOLOCK)
        INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK)
            ON 0 = 0
          AND C.LOOKUP_TYPE   = 'ELECTRODE_LINE_WIDE_RATE'
          AND A.FROM_SITE_ID  = C.SEGMENT1
          AND A.PROD_LINE     = C.SEGMENT4
          AND A.MEASURE       = 'PROD_TACT_TIME'
		  AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022.03.23	KSW	GM JV 반영
		  AND A.DIVISION_ID         = @p_division_id				-- 2022.03.23	KSW	GM JV 반영
    END
 ; 

  -----------------------------------------
  -- #10. WORKING TIME
  -----------------------------------------
   /*@p_pgm_code = 'XLSPSI05' */ 
  IF @p_user_id <> 'scp_batch'
    BEGIN
        
		-- 2021.05.28   KSW           전극 시뮬레이터 Add Prod Line tact time/working time 을 CAPA UI 에 표시되는 값으로 변경 - start
		-- 변경전
		--
        SELECT TOP 1  @p_plan_start_yyyymmdd = PLAN_START_YYYYMMDD 
		  FROM SCP_XLS_PSI_GLOBAL_ELECTRODE  WITH (NOLOCK)
		 WHERE DIVISION_ID         = @p_division_id		-- 2022.03.23	KSW	GM JV 반영
		 ;

--        PRINT @p_plan_start_yyyymmdd 

--		    SELECT DIVISION_ID
--			        , PLANT_SITE_ID AS FROM_SITE_ID
----			               , OPERATION_ID
--			        , LINE_ID
--			        , YYYYMMDD
--			        , WORKING_TIME
--		    --INTO #LINE_WORKINGTIME_BY_LOSS
--		    FROM dbo.FN_LINE_WORKINGTIME_BY_LOSS(@p_division_id, @p_plan_start_yyyymmdd, CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112), '' )
--        WHERE 0 = 0
--          AND WORKING_TIME <> 0
--          --AND LINE_ID ='FP_EED05_C'
--          AND LINE_ID <> '-'
--          AND LINE_ID IN (SELECT LINE_ID FROM SCP_MST_TACT_TIME WITH (NOLOCK)
--                           WHERE 0 = 0
--                             AND CREATED_BY =@p_user_id
--                             AND CREATION_DATE >= (SELECT MAX(CREATION_DATE) FROM SCP_XLS_PSI_GLOBAL_ELECTRODE WITH (NOLOCK)) 

--        --AND PLANT_SITE_ID IN (SELECT PLANT_SITE_ID FROM SCP_MST_TACT_TIME WITH (NOLOCK)
--        --                       WHERE 0 = 0
--        --                         AND CREATED_BY =@p_user_id
--        --                         AND CREATION_DATE >= (SELECT MAX(CREATION_DATE) FROM SCP_XLS_PSI_GLOBAL_ELECTRODE WITH (NOLOCK)) -1
--                             )

--        --ORDER BY YYYYMMDD
		
		SELECT    A.DIVISION_ID
				, A.FROM_SITE_ID
				, A.LINE_ID
				, B.YYYYMMDD
				, A.WORKING_TIME
				, A.UPDATE_TIME
		  FROM (
				SELECT DISTINCT
						  TM.DIVISION_ID
						, TM.PLANT_ID AS FROM_SITE_ID
						, TM.LINE_ID
						, TM.MONTH
						, ISNULL(TM.DAILY_CAPA, 0) / 30 AS WORKING_TIME
						, AN.UPDATE_TIME
				  FROM  SCM_MST_ITEM_LINE_ASSIGN_SN AN WITH (NOLOCK)
					   ,SCM_MST_TACT_TIME_SN TM WITH (NOLOCK)
				 WHERE AN.ITEM_ID IN (SELECT ITEM_ID FROM SCP_XLS_PSI_GLOBAL_ELECTRODE  WITH (NOLOCK) 
				                       WHERE DIVISION_ID         = @p_division_id
									     AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd )		-- 2022.03.23	KSW	GM JV 반영
				   AND AN.UPDATE_TIME >= convert(char(8), dateadd(D, -7, getdate()), 112)		-- CAPA Line Assign 업데이트 기한을 -7일로 변경
				   AND AN.UPDATE_ID         = @p_user_id
				   AND AN.OPERATION_ID      = 'E2000'
				   AND TM.DIVISION_ID		= AN.DIVISION_ID
				   AND TM.COMPANY_ID		= AN.COMPANY_ID
				   AND TM.SITE_ID			= AN.SITE_ID
				   AND TM.PLANT_ID			= AN.PLANT_ID
				   AND TM.FACTORY_ID		= AN.FACTORY_ID
				   AND TM.OPERATION_ID		= AN.OPERATION_ID
				   AND TM.LINE_ID			= AN.LINE_ID
				   AND TM.ELECTRODE_TYPE	= AN.ELECTRODE_TYPE
				   AND TM.ITEM_ID			= AN.ITEM_ID
			   ) A
		 INNER JOIN
			   (SELECT C.BASIS_YYYYMMDD AS YYYYMMDD, C.BASIS_YYYYMM AS YYYYMM
				  FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
				 WHERE 1=1  
				   AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
				   AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)
				   AND C.DAYOFWEEK = 'MON'
			   ) B
			   ON A.MONTH = B.YYYYMM 
		 ORDER BY A.FROM_SITE_ID, A.LINE_ID, B.YYYYMMDD
		-- 2021.05.28   KSW           전극 시뮬레이터 Add Prod Line tact time/working time 을 CAPA UI 에 표시되는 값으로 변경 - end

    END
 ; 

  -----------------------------------------
  -- #11. TACT TIME
  -----------------------------------------
   /*@p_pgm_code = 'XLSPSI05' */ 
  IF @p_user_id <> 'scp_batch'
    BEGIN

        
		-- 2021.05.28   KSW           전극 시뮬레이터 Add Prod Line tact time/working time 을 CAPA UI 에 표시되는 값으로 변경 - start
		-- 변경전
		--
		SELECT TOP 1  @p_plan_start_yyyymmdd = PLAN_START_YYYYMMDD 
		  FROM SCP_XLS_PSI_GLOBAL_ELECTRODE  WITH (NOLOCK)
		 WHERE DIVISION_ID = @p_division_id		-- 2022.03.23	KSW	GM JV 반영
		  ;

--        PRINT @p_plan_start_yyyymmdd 

--               SELECT DIVISION_ID
--                        ,PLANT_SITE_ID AS FROM_SITE_ID
--                        , ITEM_ID
--                        , LINE_ID
--			                  , YYYYMMDD
--			                  , TACT_TIME
--                        , CREATED_BY
--                        , OPERATION_ID
--                FROM 
--                    (
--                    SELECT DIVISION_ID,PLANT_SITE_ID,LINE_ID,ITEM_ID,TACT_TIME,YYYYMMDD
--                          ,OPERATION_ID
--                          --,YYYYMMDD_COLUMN,ITEM_UOM
--                          ,CREATED_BY
--                          ,CREATION_DATE
--                     -- INTO #tmp_SCP_MST_TACT_TIME
--                      FROM (
--                            SELECT X.DIVISION_ID,PLANT_SITE_ID,OPERATION_ID,LINE_ID,ITEM_ID,TACT_TIME,YYYYMMDD,YYYYMMDD_COLUMN
--                                  ,YN
--                                  ,USE_YN
--                                  ,ITEM_UOM
--                                  ,ROW_NUMBER() OVER (PARTITION BY X.DIVISION_ID,PLANT_SITE_ID,OPERATION_ID,LINE_ID,ITEM_ID,YYYYMMDD ORDER BY YN) AS Rn
--                                  ,ISNULL((SELECT COUNT(LS.ACTIVE_FLAG) 
--                                            FROM SCM_MST_LINE_SN LS 
--												                    WHERE 0 = 0
--                                              --AND LS.COMPANY_ID   = B.COMPANY_ID 
--                                              AND LS.DIVISION_ID  = X.DIVISION_ID 
--                                              --AND LS.SITE_ID      = B.PLANT_SITE_ID 
--                                              AND LS.PLANT_ID     = B.PLANT_ID 
--												                      AND LS.OPERATION_ID = X.OPERATION_ID 
--                                              AND LS.LINE_ID      = X.LINE_ID 
--                                              AND LS.ACTIVE_FLAG='Y'), 0) ACTIVE_CNT
--                                  ,X.CREATED_BY
--                                  ,X.CREATION_DATE
--                            FROM
--                            (
--                             SELECT T.DIVISION_ID
--                                    ,T.PLANT_SITE_ID
--                                    ,T.OPERATION_ID
--                                    ,T.LINE_ID
--                                    ,T.ITEM_ID
--                                    ,T.ITEM_UOM
--                                    ,T.TACT_TIME
--                                    ,YYYYMMDD
--                                    ,YYYYMMDD_COLUMN
--                                    ,'Y' AS YN
--                                    ,'Y' AS USE_YN
--                                    ,T.CREATED_BY
--                                    ,T.CREATION_DATE
--                              FROM SCP_MST_TACT_TIME T WITH(NOLOCK)
--                              CROSS APPLY (  SELECT C.BASIS_YYYYMMDD AS YYYYMMDD      
--                                                  ,'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)) AS YYYYMMDD_COLUMN
--                                              FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
--                                            WHERE 1=1  
--                                              AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
--                                              AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)  

--                                          ) Y 
--                              WHERE 1=1
--                                AND T.VALID_YN   = 'Y'
--                                AND T.ITEM_ID IN (SELECT ITEM_ID FROM SCP_XLS_PSI_GLOBAL_ELECTRODE  WITH (NOLOCK))
--                      --        AND S.OSP_YN     <> 'Y'               

--                            UNION ALL

--                             SELECT DIVISION_ID
--                                    ,PLANT_SITE_ID AS SCM_SITE_ID
--                                    ,OPERATION_ID
--                                    ,X.LINE_ID
--                                    ,X.ITEM_ID
--                                    ,NULL AS ITEM_UOM
--                                    ,(CASE USE_YN WHEN 'N' THEN 0.0 ELSE TACT_TIME END) AS TACT_TIME
--                                    ,YYYYMMDD
--                                    ,YYYYMMDD_COLUMN
--                                    ,'N' AS YN
--                                    ,USE_YN
--                                    ,X.CREATED_BY
--                                    ,X.CREATION_DATE
--                              FROM SCP_MST_TACT_TIME_EXCEPT X WITH(NOLOCK)
--                              CROSS APPLY (  SELECT C.BASIS_YYYYMMDD AS YYYYMMDD      
--                                                  ,'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)) AS YYYYMMDD_COLUMN
--                                              FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
--                                            WHERE 1=1  
--                                              AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
--                                              AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)  

--                                          ) Y
--                              WHERE 0 = 0
--                                AND Y.YYYYMMDD >= TACT_TIME_START_DATE
--                                AND Y.YYYYMMDD <= TACT_TIME_END_DATE
--                                AND X.ITEM_ID IN (SELECT ITEM_ID FROM SCP_XLS_PSI_GLOBAL_ELECTRODE  WITH (NOLOCK))
--                            ) X
--                             INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
--                              ON X.DIVISION_ID = B.DIVISION_ID 
--                             AND X.PLANT_SITE_ID = B.SCM_SITE_ID			 
--                      ) XX

--                      WHERE Rn = 1
--                        AND ITEM_ID IN (SELECT ITEM_ID FROM SCP_XLS_PSI_GLOBAL_ELECTRODE  WITH (NOLOCK))
--                        AND USE_YN = 'Y'
--                        ANd ACTIVE_CNT > 0

--                  ) XXX
--                  --AND CREATION_DATE >= '20200518'
--                  WHERE 0 = 0
--                    --AND CREATED_BY <> 'COPY'
--                    -- 사용자 조건
--                    AND CREATED_BY =  @p_user_id
--                    AND CREATION_DATE >= (SELECT MAX(CREATION_DATE) FROM SCP_XLS_PSI_GLOBAL_ELECTRODE WITH (NOLOCK)) 
		SELECT   A.DIVISION_ID
			   , A.FROM_SITE_ID
			   , A.ITEM_ID
			   , A.LINE_ID
			   , B.YYYYMMDD
			   , A.TACT_TIME
			   , A.UPDATE_ID
			   , A.OPERATION_ID
		  FROM (
				SELECT DISTINCT
						 TM.DIVISION_ID
					   , TM.PLANT_ID AS FROM_SITE_ID
					   , TM.ITEM_ID
					   , TM.LINE_ID
					   , TM.MONTH
					   , TM.TACT_TIME
					   , TM.UPDATE_ID
					   , TM.OPERATION_ID
				  FROM  SCM_MST_ITEM_LINE_ASSIGN_SN AN WITH (NOLOCK)
					   ,SCM_MST_TACT_TIME_SN TM WITH (NOLOCK)
				 WHERE AN.ITEM_ID IN (SELECT ITEM_ID 
				                        FROM SCP_XLS_PSI_GLOBAL_ELECTRODE  WITH (NOLOCK)
									   WHERE DIVISION_ID         = @p_division_id
									     AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd )		-- 2022.03.23	KSW	GM JV 반영
				   AND AN.UPDATE_TIME >= dateadd(D, -7, getdate())			-- CAPA Line Assign 업데이트 기한을 -7일로 변경
				   AND AN.UPDATE_ID         = @p_user_id
				   AND AN.OPERATION_ID      = 'E2000'
				   AND TM.DIVISION_ID		= AN.DIVISION_ID
				   AND TM.COMPANY_ID		= AN.COMPANY_ID
					AND TM.SITE_ID			= AN.SITE_ID
					AND TM.PLANT_ID			= AN.PLANT_ID
					AND TM.FACTORY_ID		= AN.FACTORY_ID
					AND TM.OPERATION_ID		= AN.OPERATION_ID
					AND TM.LINE_ID			= AN.LINE_ID
					AND TM.ELECTRODE_TYPE	= AN.ELECTRODE_TYPE
					AND TM.ITEM_ID			= AN.ITEM_ID
			   ) A
		 INNER JOIN
			   (SELECT C.BASIS_YYYYMMDD AS YYYYMMDD, C.BASIS_YYYYMM AS YYYYMM
				  FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
				 WHERE 1=1  
				   AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
				   AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)
				   AND C.DAYOFWEEK = 'MON'
			   ) B
			   ON A.MONTH = B.YYYYMM 
		 ORDER BY A.FROM_SITE_ID, A.ITEM_ID, A.LINE_ID, B.YYYYMMDD
		-- 2021.05.28   KSW           전극 시뮬레이터 Add Prod Line tact time/working time 을 CAPA UI 에 표시되는 값으로 변경 - end

    END
 ; 


  -----------------------------------------
  -- 'PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선'
  -- #12. 소형 Shipment Plan 입력 - 시뮬레이션 조회 ITEM 정보 추가
  -- * 2020.11.23   KSW           전지 공급 대응력 향상을 위한 SCM 관리 체계 개선 - XLSPSI21: 소형 SHIPMENT PLAN 입력 SIMULATION 추가
  -----------------------------------------
  IF @p_pgm_code = 'XLSPSI21' 
    BEGIN

	SET @p_plan_start_yyyymmdd = NULL;  --'20210510';

	SET @p_plan_type            = 'MA';
	SET @p_seq                  = NULL;  --'3';

	SET @v_plan_start_yyyymmdd  = NULL;
	SET @v_seq                  = NULL;

	-- 파라미터 확인 
	SELECT @v_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
			,@v_seq = SUBSTRING(MAX(ENG_PLAN_ID), CHARINDEX('MA::', MAX(ENG_PLAN_ID)) + 4, 1)
		FROM DBO.SCP_PLAN_PARAMETER_V WITH (NOLOCK)
		WHERE MASTER_ID = '40::WEEKLY'
		AND ENG_PLAN_ID LIKE '%MA%'
	;

	IF @p_plan_start_yyyymmdd IS NULL
		SET @p_plan_start_yyyymmdd = @v_plan_start_yyyymmdd ;

	IF @p_seq IS NULL
		SET @p_seq = @v_seq ;

	SELECT M.ITEM_ID, F.NICK_NAME
	  FROM (
	   SELECT DISTINCT AA.ITEM_ID
		   FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK)
		   LEFT 
		   JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK)
			 ON AA.DIVISION_ID = BB.DIVISION_ID
			AND AA.PROJECT_CODE = BB.PROJECT_CODE
			AND AA.TO_SITE = BB.SCM_SITE_ID
			AND AA.ITEM_ID = BB.ITEM_ID
		  WHERE 1 = 1  
			AND BB.DIVISION_ID = '40'
			AND BB.VALID_YN = 'Y' 
			AND BB.PROJECT_CODE <> '-'
			AND AA.DIVISION_ID = '40'
			AND AA.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND AA.PLAN_TYPE = 'MA'
			AND AA.SEQ       = @p_seq
		  ) M,
		  SCP_MST_FINAL_ITEM F WITH (NOLOCK)
	 WHERE 0 = 0
	   AND M.ITEM_ID = F.ITEM_ID
	 ORDER BY M.ITEM_ID
    END


 -----------------------------------------
  -- 'PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선'
  -- #12. ESS Shipment Plan 입력 - 시뮬레이션 조회 ITEM 정보 추가
  -- * 2021.03.23   KSW           전지 공급 대응력 향상을 위한 SCM 관리 체계 개선 - XLSPSI22: ESS SHIPMENT PLAN 입력 SIMULATION 추가
  -----------------------------------------
  IF @p_pgm_code = 'XLSPSI22' 
    BEGIN

	SET @p_plan_start_yyyymmdd = NULL;

	SET @p_plan_type            = 'MA';
	SET @p_seq                  = NULL;

	SET @v_plan_start_yyyymmdd  = NULL;
	SET @v_seq                  = NULL;

	-- 파라미터 확인 
	SELECT @v_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
			,@v_seq = SUBSTRING(MAX(ENG_PLAN_ID), CHARINDEX('MA::', MAX(ENG_PLAN_ID)) + 4, 1)
		FROM DBO.SCP_PLAN_PARAMETER_V WITH (NOLOCK)
		WHERE MASTER_ID = '82::WEEKLY'
		AND ENG_PLAN_ID LIKE '%MA%'
	;

	IF @p_plan_start_yyyymmdd IS NULL
		SET @p_plan_start_yyyymmdd = @v_plan_start_yyyymmdd ;

	IF @p_seq IS NULL
		SET @p_seq = @v_seq ;

	SELECT M.ITEM_ID, F.NICK_NAME
	  FROM (
	   SELECT DISTINCT AA.ITEM_ID
		   FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK)
		   LEFT 
		   JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK)
			 ON AA.DIVISION_ID = BB.DIVISION_ID
			AND AA.PROJECT_CODE = BB.PROJECT_CODE
			AND AA.TO_SITE = BB.SCM_SITE_ID
			AND AA.ITEM_ID = BB.ITEM_ID
		  WHERE 1 = 1  
			AND BB.DIVISION_ID = '82'
			AND BB.VALID_YN = 'Y' 
			AND BB.PROJECT_CODE <> '-'
			AND AA.DIVISION_ID = '82'
			AND AA.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND AA.PLAN_TYPE = 'MA'
			AND AA.SEQ       = @p_seq
		  ) M,
		  SCP_MST_FINAL_ITEM F WITH (NOLOCK)
	 WHERE 0 = 0
	   AND M.ITEM_ID = F.ITEM_ID
	 ORDER BY M.ITEM_ID
    END

-----------------------------------------
-- 소형 PACK 시뮬레이터 :: Daily 주차 및 Monthly 선택을 위한 DATA 추가
-----------------------------------------
	IF @p_pgm_code = 'XLSPSI02' 
	BEGIN
		SELECT TOP 1  @p_plan_start_yyyymmdd = Max(PLAN_START_YYYYMMDD) FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK  WITH (NOLOCK);

		DECLARE @v_plan_end_yyyymmdd	NVARCHAR(8) = '';
		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112) ;


		-- 조회조건 :: Daily 마지막 주차선택
		SELECT X.WEEK_NAME, X.W_PLAN
		  FROM (
				SELECT  C.WEEK_NAME
				       ,CONVERT(VARCHAR, MIN(C.BASIS_YYYYMMDD)) + '~' + CONVERT(VARCHAR, MAX(C.BASIS_YYYYMMDD)) AS W_PLAN
				FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
				WHERE 0 = 0
					AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
					AND C.BASIS_YYYYMMDD <  @v_plan_end_yyyymmdd
				GROUP BY C.WEEK_NAME
				) X
		ORDER BY X.W_PLAN, X.WEEK_NAME
				;

		-- 조회조건 :: Month 마지막 월차선택
		SELECT MONTH_LST.T_MONTH, MONTH_LST.M_PLAN
		  FROM (
				SELECT CONVERT(VARCHAR, MIN(E_YYYYMMDD)) + '~' + CONVERT(VARCHAR, MAX(E_YYYYMMDD))    AS M_PLAN
						, CONVERT(VARCHAR, C_YEAR) + '.' + RIGHT('0' + CONVERT(VARCHAR, C_MONTH), 2)  AS T_MONTH
				FROM (
						SELECT C.BASIS_YYYYMMDD AS E_YYYYMMDD, CONVERT(INT, C.CALENDAR_YYYY) AS C_YEAR, CONVERT(INT, C.CALENDAR_MONTH) AS C_MONTH
						FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
						WHERE 0 = 0
							AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
							AND C.BASIS_YYYYMMDD <  @v_plan_end_yyyymmdd
					) X
				WHERE X.E_YYYYMMDD >= @p_plan_start_yyyymmdd
				GROUP BY C_MONTH, C_YEAR
			) MONTH_LST
		ORDER BY MONTH_LST.M_PLAN, MONTH_LST.T_MONTH
			;
	END

 ; 
/*************************************
 *   END OF PROGRAM
 *************************************/    
END



