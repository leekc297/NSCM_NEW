

/*
 * Program ID   : SCP0006_GET_PROJECT_ROUTE_SITE_82
 * Description  : Project Route Site 조회(divsion 82전용)
 * Comments     : @p_scm_site_id,@p_project_code 미사용 SCP0006_GET_PROJECT_ROUTE_SITE와 파라미터 호환을 위해 남겨둠
				  비정상적으로 느릴때 db plan cache삭제 필요 : DBCC FREESYSTEMCACHE ('ALL','default')
 * Program History
==========================================================================================================================================================
 Date         In Charge     Description
==========================================================================================================================================================
 2018/04/09   PJS                   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 2018/04/17   PJS                   임시테이블 삭제 OBJECT_ID형식으로 변경
 2018/05/03   byunghunjung          Alternate Part 제외로직 추가
 2018/05/17   byunghunjung          전극 제외
 2018/05/23   byunghunjung          전극 제외 로직 추가
 2018/05/28   byunghunjung          팩모델 하위의 CELL중에서 일부가 자동차전지에만 BOM에서 모ITEM으로 존재하지만,PROJECT ROUTE화면에서 ESS에 생산지를 등록하도록 표기되는 오류수정
 2018/05/28   byunghunjung          dm_pln_mkt_fcst 테이블 조회시 중복제거
 2018/06/11   PJS                   시작일자 현재일자의 월요일로 고정
 2018/06/21   byunghunjung          BOM을 제거모델 조회안되도록 수정
 2018/09/14   hwyoon                Item Type = R 도 보이도록 수정
 2018/11/07	  hwyoon                vmi에 따라 MKT measure 조절
 2019/09/02	  hwyoon                [CSR ID:4077274] 자체개선 - SCP 3개 메뉴 기능보완(Global PSI, Project Route, Master Validation)
                                    MKT FCST 수량 조회 쿼리 변경 - 동일 Plant에서 여러 Sales Site로 동일날짜&동일수량 으로 잡히는 경우 수량SUM 계산
 2021/04/07   PJG                   수량 카운트용 쿼리 데이터 별도 임시테이블 저장
 2021/10/05   khj79	                [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - W/S AS UI 변경
 2022/11/07   jahn1501              PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MKT FCST 조건 변경
 2023/06/29   vadabi3               [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - ACTIVE_FLAG = N Material 조건 적용
 2024/01/15   chaan         V1.1.1  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 조회대상 제외 로직 수정(하나라도 ACTIVE_FLAG = N 이면 제외 => 전체가 N 이면 제외로 변경)
 2025/06/23   KANG.H.J				[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (강현준)
 2026.07.15	  YMH					E20260713-000141 [ESS]Project Route 화면 기능 개선요청드립니다

 ex )
 EXEC SCP0006_GET_PROJECT_ROUTE_SITE_82 @p_division_id='82',@p_scm_site_id='', @p_project_code='', @p_item_id='', @p_from_yyyymm='201802', @p_to_yyyymm='201901', @p_status=NULL,@debug_mode='T'
 */
CREATE PROCEDURE [dbo].[SCP0006_GET_PROJECT_ROUTE_SITE_82_YMH_20260720]
    @p_division_id    NVARCHAR(MAX)
  , @p_scm_site_id    NVARCHAR(MAX)
  , @p_project_code   NVARCHAR(MAX)
  , @p_item_id		  NVARCHAR(MAX)
  , @p_from_yyyymm	  NVARCHAR(6)
  , @p_to_yyyymm	  NVARCHAR(6)
  , @p_status		  NVARCHAR(6)
  , @debug_mode       NVARCHAR(20)      = 'F'
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    --DECLARE @p_division_id    NVARCHAR(MAX)		= N'82';
    --DECLARE @p_scm_site_id    NVARCHAR(MAX)		= N'';
    --DECLARE @p_project_code   NVARCHAR(MAX)		= N'';
    --DECLARE @p_item_id		  NVARCHAR(MAX)		= N'';
    --DECLARE @p_from_yyyymm	  NVARCHAR(6)		= N'202401';
    --DECLARE @p_to_yyyymm	  NVARCHAR(6)		= N'202412';
    --DECLARE @p_status		  NVARCHAR(6)		= N'';
    --DECLARE @debug_mode       NVARCHAR(20)      = N'F';



	DECLARE @v_data_cnt NVARCHAR(8);

    DECLARE @p_from_yyyymmdd     AS NVARCHAR(8)='';
    DECLARE @p_to_yyyymmdd       AS NVARCHAR(8)='';

    DECLARE @v_from_yyyymmdd     AS NVARCHAR(8)='';
    DECLARE @v_to_yyyymmdd       AS NVARCHAR(8)='';
    DECLARE @v_from_result       AS NVARCHAR(8)='';
    DECLARE @v_to_result         AS NVARCHAR(8)='';
	DECLARE @v_unit_date         AS NVARCHAR(8)='';  --현재일 기준의 주(week)의 시작일자

	set @v_data_cnt =0;

	-- 월의 시작일자 설정
	IF( ISNULL(@p_from_yyyymm ,'') ='')
		SET @p_from_yyyymmdd =  '';
	ELSE
		SET @p_from_yyyymmdd =  @p_from_yyyymm +'01';

  -- from_yyyymmdd는 현재일자의 월요일로 강제설정
	SET @p_from_yyyymmdd	= (	SELECT	CONVERT(VARCHAR(8), DATEADD(DD, -(DAYOFWEEK_NO-1),BASIS_YYYYMMDD),112) AS BASIS_START_DATE
								FROM	(
											SELECT	  CASE
														WHEN DAYOFWEEK_NO -1 =0 THEN 7
														ELSE DAYOFWEEK_NO -1
													  END AS DAYOFWEEK_NO
													, CONVERT(DATETIME, basis_yyyymmDD) as basis_yyyymmDD
													, DAYOFWEEK
											FROM	SCM_SYS_CALENDAR_M WITH(NOLOCK)
											WHERE	1=1
												AND BASIS_YYYYMMDD =CONVERT(VARCHAR(8), GETDATE(),112)
										) F
								);

   print '@p_from_yyyymmdd = ' +@p_from_yyyymmdd;
    -- 월의 마지막일자 설정

	IF( ISNULL(@p_to_yyyymm ,'') ='')
		SET @p_to_yyyymmdd =  '';
	ELSE
		SET @p_to_yyyymmdd =  convert(varchar, dateadd(day,-1, dateadd(month, 1, convert(datetime,@p_to_yyyymm+'01'))) ,112) ;


	SELECT	@v_unit_date = C.BASIS_START_DATE
	FROM	[dbo].[SCM_SYS_CALENDAR_M]      C
	WHERE	1=1
		AND C.BASIS_YYYYMMDD = CONVERT(NVARCHAR(8), CURRENT_TIMESTAMP, 112);


	IF (@v_unit_date >= @p_from_yyyymmdd AND @v_unit_date <= @p_to_yyyymmdd)
	BEGIN
		SET @v_from_result   = @p_from_yyyymmdd ;
		SET @v_to_result     = @v_unit_date;
		SET @v_from_yyyymmdd = @v_unit_date;
		SET @v_to_yyyymmdd   = @p_to_yyyymmdd;

		IF @p_from_yyyymmdd  = @v_unit_date
		BEGIN
			SET @v_from_result   = '';
			SET @v_to_result     = '';
		END;
	END
	ELSE IF (@v_unit_date < @p_from_yyyymmdd  AND  @v_unit_date < @p_to_yyyymmdd)
	BEGIN
		SET @v_from_yyyymmdd = @p_from_yyyymmdd;
		SET @v_to_yyyymmdd   = @p_to_yyyymmdd;
		SET @v_from_result   = '';
		SET @v_to_result     = '';
	END
	ELSE IF (@v_unit_date > @p_from_yyyymmdd  AND  @v_unit_date > @p_to_yyyymmdd)
	BEGIN
		SET @v_from_yyyymmdd = '';
		SET @v_to_yyyymmdd   = '';
		SET @v_from_result   = @p_from_yyyymmdd;
		SET @v_to_result     = @p_to_yyyymmdd;
	END;

	IF @debug_mode = 'T'
	BEGIN
		PRINT '==============PARMS INFO================';
		PRINT '@p_division_id   = ' + @p_division_id ;
		PRINT '@p_scm_site_id   = ' + @p_scm_site_id ;
		PRINT '@p_project_code  = ' + @p_project_code;
		PRINT '@p_item_id		= ' + @p_item_id	 ;
		PRINT '@p_from_yyyymm	= ' + @p_from_yyyymm ;
		PRINT '@p_to_yyyymm		= ' + @p_to_yyyymm	 ;
		PRINT '@p_status		= ' + @p_status		 ;
		PRINT '@v_from_result	= ' + @v_from_result   ;
		PRINT '@v_to_result     = ' + @v_to_result     ;
		PRINT '@v_from_yyyymmdd = ' + @v_from_yyyymmdd ;
		PRINT '@v_to_yyyymmdd   = ' + @v_to_yyyymmdd   ;
		PRINT '';
	END;


	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/

 -- 수량 카운트용 쿼리 데이터 임시테이블 저장
    IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_03') IS NOT NULL
		   DROP TABLE #TblDynamicPivot_SCP0006_03

	SELECT	  DIVISION_ID
			, SCM_SITE_ID
			, PROJECT_CODE
			, MODEL_ID
			, CONVERT(VARCHAR, SUM(PLANT_CNT) ) +'/'+ CONVERT(VARCHAR, TOT_CNT) AS PLANT_PER_ITEM
			, CASE WHEN SUM(PLANT_CNT) = TOT_CNT THEN 'Y' ELSE 'N' END CMPLTD_STATUS
	INTO	#TblDynamicPivot_SCP0006_03
	FROM	(
				SELECT	  DIVISION_ID
						, '-'												AS SCM_SITE_ID
						, '-'												AS PROJECT_CODE
						, MODEL_ID
						, COUNT(*) OVER(PARTITION BY DIVISION_ID,MODEL_ID)	AS TOT_CNT
						, CASE
							WHEN PRIMARY_PLANT IS NOT NULL THEN 1
							ELSE 0
						  END												AS PLANT_CNT
				FROM	(
							SELECT DISTINCT
									  CASE
										WHEN dbo.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) = 'E' THEN C.ITEM_ID
										ELSE B.MODEL_ID
									  END AS MODEL_ID
									, CASE
										-- 전극 제외 20180517
										-- WHEN D.OPERATION_GROUP_ID = 'E' THEN 'Electrode'
										WHEN D.OPERATION_GROUP_ID = 'A' THEN 'Cell'
										WHEN D.OPERATION_GROUP_ID = 'P' THEN 'Pack'
									  END AS OPERATION_GROUP_ID
									, D.ELECTRODE_TYPE
									, B.CHILD_ITEM_ID AS ITEM_ID
									, (
										SELECT	ROWNUMBER
										FROM	(
													SELECT	ROW_NUMBER() OVER (ORDER BY FROM_YYYYMMDD) AS ROWNUMBER
													FROM	SCM_MST_SITE_ITEM_PRIORITY S
													WHERE	1=1
														AND S.DIVISION_ID   = B.DIVISION_ID
														AND S.ITEM_ID       = B.CHILD_ITEM_ID
														AND S.TO_YYYYMMDD  >= CONVERT(VARCHAR, GETDATE(),112)
														AND S.VALID_YN = 'Y'
														AND S.PRIORITY = '1'
												) A
										WHERE	1=1
											AND ROWNUMBER =1
									  ) AS PRIMARY_PLANT
									, B.DIVISION_ID
							FROM	DM_PLN_MKT_FCST A
									-- 2021.03.25 대체 BOM 모델링
									INNER JOIN SCM_MST_BOM_SN_V B ON
											A.DIVISION_ID	= B.DIVISION_ID
									--JOIN SCM_MST_BOM_SN B    ON A.DIVISION_ID   = B.DIVISION_ID
										AND A.ITEM_ID   = B.MODEL_ID
									INNER JOIN SCM_MST_ITEM_SN C ON
											B.COMPANY_ID    = C.COMPANY_ID
										AND B.DIVISION_ID   = C.DIVISION_ID
										AND B.SITE_ID       = C.SITE_ID
										AND B.CHILD_ITEM_ID = C.ITEM_ID
									INNER JOIN SCM_MST_FINAL_ITEM_V D ON B.DIVISION_ID = D.DIVISION_ID
										AND B.CHILD_ITEM_ID = D.ITEM_ID
									--2021/10/05 : W/S AS
									--LEFT JOIN scm_mst_site s ON s.DIVISION_ID=a.DIVISION_ID AND s.SCM_SITE_ID=a.SCM_SITE_ID AND s.VMI_YN='Y'
									LEFT JOIN SCM_MST_SITE S ON
											S.DIVISION_ID = A.DIVISION_ID
										AND S.SCM_SITE_ID = A.SCM_SITE_ID
										AND (S.VMI_YN='Y' OR ( SITE_TYPE = 'SALES' AND OPERATION_GROUP = 'W'))
										WHERE 1=1
										--Alternate Part 제외로직 추가
										AND B.ALT_PRIORITY  = 'Y'
										--AND c.item_type		<> 'r'
										--  실적(등록된 카운트)수량은 분기되기 이전 날짜 전체를 사용해야 카운트가 맞음
										AND a.yyyymmdd >= @p_from_yyyymmdd
										AND a.yyyymmdd <= @p_to_yyyymmdd
										--2021/10/05 : W/S AS
										--AND a.MEASURE = IIF( ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')
										--2022/11/07
										--AND A.MEASURE = IIF(ISNULL(S.OPERATION_GROUP, '') = 'W', 'AS_In_Req', IIF(S.vmi_yn = 'Y', 'VMI_In_Req',  'MKT_FCST'))
										AND A.MEASURE = CASE WHEN ISNULL(S.OPERATION_GROUP, '') = 'W' THEN 'AS_In_Req' WHEN S.VMI_YN = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(A.ATTRIBUTE10, '') = '' THEN 'MKT_FCST' END
										AND A.QTY>0
										AND A.DIVISION_ID = @P_DIVISION_ID
										AND ((@P_ITEM_ID IS NULL OR @P_ITEM_ID = '') OR B.MODEL_ID IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@P_ITEM_ID, ',')))
										AND D.OPERATION_GROUP_ID <> 'E'
										--ESS 팩모델 하위의 CELL중에서 일부가 자동차전지에만 BOM에서 모ITEM으로 존재하지만,PROJECT ROUTE화면에서 ESS에 생산지를 등록하도록 표기되는 오류수정
										AND EXISTS (
														SELECT	*
														FROM	[dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
														WHERE	1=1
															AND DIVISION_ID = @p_division_id
															AND PARENT_ITEM_ID= B.CHILD_ITEM_ID
															--BOM을 제거모델 조회안되도록 수정
															AND EFF_END_DATE >= GETDATE()
															AND KEY_DATE = (
																				SELECT	MAX(KEY_DATE)
																				FROM	[dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
																				WHERE	1=1
																					AND PARENT_ITEM_ID = B.CHILD_ITEM_ID --'ECE0315N1-01'
																					AND DIVISION_ID    = @p_division_id
																			)
												   )
						) M
			) N
	GROUP BY	  DIVISION_ID
				, SCM_SITE_ID
				, PROJECT_CODE
				, MODEL_ID
				, TOT_CNT;
/*    
    --ACTIVE_FLAG 구분없이 전체
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_All') IS NOT NULL
		DROP TABLE  #TblDynamicPivot_SCP0006_All;

	SELECT    A.DIVISION_ID
            , A.ITEM_ID
            , A.ACTIVE_FLAG
    INTO    #TblDynamicPivot_SCP0006_All
	FROM	SCM_MST_ITEM_SN A WITH(NOLOCK)
			INNER HASH JOIN SCM_MST_ITEM_CLASS_SN B(NOLOCK) ON
					A.ITEM_CLASS = B.CLASS_ID
	WHERE	1=1
		AND B.USE_FLAG		= 'Y'
		AND DIVISION_ID IN (SELECT TOKEN FROM dbo.String_Split(@p_division_id, ','))
    GROUP BY  A.DIVISION_ID
            , A.ITEM_ID
            , A.ACTIVE_FLAG;

--TESTING : NOK
--select * from #TblDynamicPivot_SCP0006_All;return;

	--------------------------------------------------------------------------------------------------------------------------------------------------------
	-- 20230629 List = [company, div, item] 이 구분에 필요하지만 Item 기준으로 하나라도 N이면 active_flag = N  간주

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_Inactive') IS NOT NULL
		DROP TABLE  #TblDynamicPivot_SCP0006_Inactive;

	SELECT    A.DIVISION_ID
            , A.ITEM_ID
            , A.ACTIVE_FLAG 
    INTO    #TblDynamicPivot_SCP0006_Inactive
	FROM	#TblDynamicPivot_SCP0006_All A
	WHERE	1=1
		AND A.ACTIVE_FLAG	= 'N'
    GROUP BY  A.DIVISION_ID
            , A.ITEM_ID
            , A.ACTIVE_FLAG;

--TESTING : NOK
--select * from #TblDynamicPivot_SCP0006_Inactive;return;

    --20240115 DIVISION, ITEMID 그륩별 전체가 N 인 경우에만 N 간주, 즉 하나라도 Y 가 있으면 조회가능 by chaan (신재욱책임 요청)
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_Active') IS NOT NULL
		DROP TABLE  #TblDynamicPivot_SCP0006_Active;

	SELECT    A.DIVISION_ID
            , A.ITEM_ID
            , A.ACTIVE_FLAG 
    INTO    #TblDynamicPivot_SCP0006_Active
	FROM	#TblDynamicPivot_SCP0006_All A
	WHERE	1=1
		AND A.ACTIVE_FLAG	= 'Y'
    GROUP BY  A.DIVISION_ID
            , A.ITEM_ID
            , A.ACTIVE_FLAG;

    DELETE  A
    FROM    #TblDynamicPivot_SCP0006_Inactive A JOIN #TblDynamicPivot_SCP0006_Active B ON
                    A.DIVISION_ID   = B.DIVISION_ID
                AND A.ITEM_ID       = B.ITEM_ID
*/

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_Inactive') IS NOT NULL
		DROP TABLE  #TblDynamicPivot_SCP0006_Inactive;

    SELECT  *
    INTO    #TblDynamicPivot_SCP0006_Inactive
    FROM    dbo.FN_GET_SCP_ITEM_INACTIVE(@p_division_id, @p_item_id)

--TESTING : NOK
--select * from #TblDynamicPivot_SCP0006_Inactive;return;


	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_02') IS NOT NULL
		   DROP TABLE #TblDynamicPivot_SCP0006_02

	SELECT	  T.DIVISION_ID
			, DBO.FN_GET_DIVISION_NAME(T.DIVISION_ID)	AS DIVISION_NAME
			, '-' AS SCM_SITE_ID
			-- E20260713-000141 주석처리
			--, '-' AS PROJECT_CODE 
			-- E20260713-000141 
			, t.PROJECT_CODE 
			, T.ITEM_ID
			, CASE
				WHEN U.PLANT_PER_ITEM IS NULL THEN 'BOM Not Exists'
				ELSE U.PLANT_PER_ITEM
			  END AS PLANT_PER_ITEM
			, ISNULL(U.CMPLTD_STATUS,'N')				AS CMPLTD_STATUS
			, SUBSTRING(YYYYMMDD,1,6)					AS MONTH
			, T.QTY
			, 0											as NO_DEMAND		-- E20260713-000141 
	INTO	#TblDynamicPivot_SCP0006_02
	FROM	(
				SELECT DISTINCT
						  A.DIVISION_ID
						, A.PROJECT_CODE
						, A.SCM_SITE_ID
						, A.ITEM_ID,DOM_EXP
						, FCST_TYPE
						, INCOTERMS
						, MEASURE
						, PLANT_SITE_ID
						, YYYYMMDD,QTY
				FROM	DM_PLN_MKT_FCST A WITH(NOLOCK)
						INNER JOIN SCM_MST_ITEM_SN B WITH(NOLOCK) ON
								A.DIVISION_ID	= B.DIVISION_ID
							AND A.ITEM_ID		= B.ITEM_ID
						LEFT JOIN SCM_MST_SITE S WITH(NOLOCK) ON
								S.DIVISION_ID	= A.DIVISION_ID
							AND S.SCM_SITE_ID	= A.SCM_SITE_ID
							AND (S.VMI_YN = 'Y' OR (SITE_TYPE = 'SALES' AND OPERATION_GROUP = 'W'))
				WHERE	1=1
					AND A.MEASURE = CASE WHEN ISNULL(S.OPERATION_GROUP, '') = 'W' THEN 'AS_In_Req' WHEN S.vmi_yn = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(a.attribute10, '') = '' THEN 'MKT_FCST' END
					AND B.SCP_OPERATION_GROUP_ID <> 'E'
					AND A.YYYYMMDD >= @v_from_yyyymmdd
					AND A.YYYYMMDD <= @v_to_yyyymmdd
					AND A.YYYYMMDD != '' AND A.YYYYMMDD IS NOT NULL
					AND A.DIVISION_ID = @p_division_id
					AND A.QTY>0
					AND ((@p_item_id IS NULL OR @p_item_id = '') OR A.ITEM_ID IN (SELECT TOKEN FROM dbo.String_Split(@p_item_id,',')))
				UNION ALL
				SELECT    -- DISTINCT	-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가(DISTINCT 제거)
						  A.DIVISION_ID
						, A.PROJECT_CODE
						, A.SCM_SITE_ID
						, A.ITEM_ID
						, DOM_EXP
						, FCST_TYPE
						, INCOTERMS
						, MEASURE
						, PLANT_SITE_ID
						, YYYYMMDD
						--, QTY
						, SUM(QTY)			AS QTY				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (DM_PLN_MKT_FCST_RESULT에 CELL_PROD_SITE_ID 추가됨에 따라 GROUP BY에 의해 SUM(QTY) 처리)
				FROM	DM_PLN_MKT_FCST_RESULT A WITH(NOLOCK)
						INNER JOIN SCM_MST_ITEM_SN B WITH(NOLOCK) ON
								A.DIVISION_ID	= B.DIVISION_ID
							AND A.ITEM_ID		= B.ITEM_ID
						LEFT JOIN SCM_MST_SITE S WITH(NOLOCK) ON
								S.DIVISION_ID	= A.DIVISION_ID
							AND S.SCM_SITE_ID	= A.SCM_SITE_ID
							AND (S.VMI_YN = 'Y' OR (SITE_TYPE = 'SALES' AND OPERATION_GROUP = 'W'))
						WHERE	1=1
							AND A.MEASURE = IIF(ISNULL(S.OPERATION_GROUP, '') = 'W', 'AS_In_Req', IIF(S.vmi_yn = 'Y', 'VMI_In_Req',  'MKT_FCST'))
							AND A.MEASURE = CASE WHEN ISNULL(S.OPERATION_GROUP, '') = 'W' THEN 'AS_In_Req' WHEN S.VMI_YN = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(A.ATTRIBUTE10, '') = '' THEN 'MKT_FCST' END
							AND B.SCP_OPERATION_GROUP_ID <> 'E'
							AND A.YYYYMMDD >= @v_from_result
							AND A.YYYYMMDD <= @v_to_result
							AND A.YYYYMMDD != '' and a.yyyymmdd is not null
							AND A.QTY>0
							AND A.DIVISION_ID = @p_division_id
							AND ((@p_item_id IS NULL OR @p_item_id = '') OR A.ITEM_ID IN (SELECT TOKEN FROM dbo.String_Split(@p_item_id, ',')))
				GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (DM_PLN_MKT_FCST_RESULT에 CELL_PROD_SITE_ID 추가됨에 따라 GROUP BY에 의해 SUM(QTY) 처리)
			) T
			LEFT OUTER JOIN #TBLDYNAMICPIVOT_SCP0006_03 U ON
					T.DIVISION_ID	= U.DIVISION_ID
				AND T.ITEM_ID		= U.MODEL_ID
			INNER JOIN (
							SELECT	  DIVISION_ID
									, ITEM_ID
									, NICK_NAME
									, ITEM_TYPE
									, ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, ITEM_ID ORDER BY  CASE ITEM_TYPE WHEN 'P' THEN 999 WHEN 'H' THEN 888 WHEN 'R' THEN 777  WHEN 'Q' THEN 666 ELSE 0 END  DESC ) NUMS
							FROM	SCM_MST_ITEM_SN WITH(NOLOCK)
						) I ON
					T.DIVISION_ID	= I.DIVISION_ID
				AND T.ITEM_ID		= I.ITEM_ID
				AND I.NUMS			= 1
			LEFT OUTER JOIN #TblDynamicPivot_SCP0006_Inactive W ON
					W.ITEM_ID = T.ITEM_ID
	WHERE	1=1
		AND T.MEASURE IN ('AS_In_Req','VMI_In_Req',  'MKT_FCST')
		AND W.ACTIVE_FLAG IS NULL
		AND ((@p_status IS NULL OR @p_status = '') OR U.CMPLTD_STATUS IN (SELECT TOKEN FROM dbo.String_Split(@p_status, ',')));

	-- E20260713-000141 신규로직 시작
    IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_04') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0006_04

	SELECT
		  SEGMENT2	AS DIVISION_ID
		, SEGMENT3	AS ITEM_ID 
		, SEGMENT5	AS PROJECT_CODE
		INTO #TblDynamicPivot_SCP0006_04
	FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL AS A WITH(NOLOCK)
	WHERE LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP' AND VALID_YN = 'Y'
	AND EXISTS
	(
		select * from #TblDynamicPivot_SCP0006_02 AS B with(nolock)	
		WHERE A.SEGMENT2		= B.DIVISION_ID
		AND LEFT(A.SEGMENT3,12) = LEFT(B.ITEM_ID,12)
		AND A.SEGMENT5			= B.PROJECT_CODE
		AND A.SEGMENT3			<> B.ITEM_ID
	)
		
	INSERT INTO #TblDynamicPivot_SCP0006_03
	SELECT	  DIVISION_ID
			, SCM_SITE_ID
			, PROJECT_CODE
			, MODEL_ID
			, CONVERT(VARCHAR, SUM(PLANT_CNT) ) +'/'+ CONVERT(VARCHAR, TOT_CNT) AS PLANT_PER_ITEM
			, CASE WHEN SUM(PLANT_CNT) = TOT_CNT THEN 'Y' ELSE 'N' END CMPLTD_STATUS
	FROM	(
		SELECT	  DIVISION_ID
				, '-'												AS SCM_SITE_ID
				, '-'												AS PROJECT_CODE
				, MODEL_ID
				, COUNT(*) OVER(PARTITION BY DIVISION_ID,MODEL_ID)	AS TOT_CNT
				, CASE
					WHEN PRIMARY_PLANT IS NOT NULL THEN 1
					ELSE 0
					END												AS PLANT_CNT
		FROM	
		(
			SELECT DISTINCT
						CASE
						WHEN dbo.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) = 'E' THEN C.ITEM_ID
						ELSE B.MODEL_ID
						END AS MODEL_ID
					, CASE
						-- 전극 제외 20180517
						-- WHEN D.OPERATION_GROUP_ID = 'E' THEN 'Electrode'
						WHEN D.OPERATION_GROUP_ID = 'A' THEN 'Cell'
						WHEN D.OPERATION_GROUP_ID = 'P' THEN 'Pack'
						END AS OPERATION_GROUP_ID
					, D.ELECTRODE_TYPE
					, B.CHILD_ITEM_ID AS ITEM_ID
					, (
						SELECT	ROWNUMBER
						FROM	(
									SELECT	ROW_NUMBER() OVER (ORDER BY FROM_YYYYMMDD) AS ROWNUMBER
									FROM	SCM_MST_SITE_ITEM_PRIORITY S
									WHERE	1=1
										AND S.DIVISION_ID   = B.DIVISION_ID
										AND S.ITEM_ID       = B.CHILD_ITEM_ID
										AND S.TO_YYYYMMDD  >= CONVERT(VARCHAR, GETDATE(),112)
										AND S.VALID_YN = 'Y'
										AND S.PRIORITY = '1'
								) A
						WHERE	1=1
							AND ROWNUMBER =1
						) AS PRIMARY_PLANT
					, B.DIVISION_ID
			FROM #TblDynamicPivot_SCP0006_04 AS A
				INNER JOIN SCM_MST_BOM_SN_V B ON
				A.DIVISION_ID	= B.DIVISION_ID
				AND A.ITEM_ID   = B.MODEL_ID
				INNER JOIN SCM_MST_ITEM_SN C ON
				B.COMPANY_ID    = C.COMPANY_ID
				AND B.DIVISION_ID   = C.DIVISION_ID
				AND B.SITE_ID       = C.SITE_ID
				AND B.CHILD_ITEM_ID = C.ITEM_ID
				INNER JOIN SCM_MST_FINAL_ITEM_V D ON B.DIVISION_ID = D.DIVISION_ID
				AND B.CHILD_ITEM_ID = D.ITEM_ID
		) M
	) N
	GROUP BY	  DIVISION_ID
				, SCM_SITE_ID
				, PROJECT_CODE
				, MODEL_ID
				, TOT_CNT;

	INSERT INTO #TBLDYNAMICPIVOT_SCP0006_02
	SELECT 
		T.DIVISION_ID
		, DBO.FN_GET_DIVISION_NAME(T.DIVISION_ID)	AS DIVISION_NAME
		, '-' AS SCM_SITE_ID
		, '-' AS PROJECT_CODE 
		, T.ITEM_ID
		, CASE
			WHEN U.PLANT_PER_ITEM IS NULL THEN 'BOM NOT EXISTS'
			ELSE U.PLANT_PER_ITEM
			END AS PLANT_PER_ITEM
		, ISNULL(U.CMPLTD_STATUS,'N')					AS CMPLTD_STATUS
		, SUBSTRING(@P_FROM_YYYYMMDD,1,6)				AS MONTH
		, 0 AS QTY
		, 1												AS NO_DEMAND
	FROM #TBLDYNAMICPIVOT_SCP0006_04 AS T
		LEFT OUTER JOIN #TBLDYNAMICPIVOT_SCP0006_03 U 
		ON	T.DIVISION_ID	= U.DIVISION_ID
		AND T.ITEM_ID		= U.MODEL_ID
	-- E20260713-000141 신규로직 끝

--TESTING : NOK
--select * from #TblDynamicPivot_SCP0006_02;return;

	BEGIN
		DECLARE @v_date_cols	NVARCHAR(MAX);
		DECLARE @v_sql			NVARCHAR(MAX);

		SET @v_date_cols = '';

		--  날짜 커럼 생성
		SELECT	@v_date_cols = @v_date_cols + '[' + month + '], '
		FROM	(
					SELECT	  A.BASIS_YYYYMM									AS MONTH
							, MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01')	AS SORT_ORDER_NO
					FROM	[dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
					WHERE	1=1
						AND A.BASIS_YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                ) A
		ORDER BY MONTH;


		-- PIVOT 쿼리 실행
		SET @v_date_cols = LEFT(@v_date_cols, LEN(@v_date_cols) - 1);

--TESTING : OK
--exec debug_log @v_date_cols, 'T';return;


		SET @v_sql = N'SELECT	  DIVISION_ID
								, DIVISION_NAME
								, SCM_SITE_ID
								, ''-'' AS SCM_SITE_NAME
								--, PROJECT_CODE -- E20260713-000141 주석처리
								, ''-'' AS PROJECT_CODE -- E20260713-000141 신규로직
								, ITEM_ID
								, PLANT_PER_ITEM
								, CMPLTD_STATUS
								, dbo.FN_GET_ITEM_NICKNAME(DIVISION_ID, ITEM_ID ) AS NICK_NAME
								, ' + @v_date_cols + '
								, NO_DEMAND  -- E20260713-000141 신규로직
						FROM	#TblDynamicPivot_SCP0006_02
						PIVOT	(
									SUM(QTY) FOR MONTH IN (' + @v_date_cols + ')
								 ) AS A
								ORDER BY DIVISION_ID, CMPLTD_STATUS, PLANT_PER_ITEM';

		--TESTING : OK
		--exec debug_log @v_sql, 'T';return;
		EXEC (@v_sql);
	END;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_02') IS NOT NULL
		DROP TABLE  #TblDynamicPivot_SCP0006_02;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_03') IS NOT NULL
		DROP TABLE  #TblDynamicPivot_SCP0006_03;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_04') IS NOT NULL -- E20260713-000141 신규로직
		DROP TABLE  #TblDynamicPivot_SCP0006_04; -- E20260713-000141 신규로직
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_All') IS NOT NULL
		DROP TABLE  #TblDynamicPivot_SCP0006_All;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_AllInactive') IS NOT NULL
		DROP TABLE  #TblDynamicPivot_SCP0006_AllInactive;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_Inactive') IS NOT NULL
		DROP TABLE  #TblDynamicPivot_SCP0006_Inactive;
END
