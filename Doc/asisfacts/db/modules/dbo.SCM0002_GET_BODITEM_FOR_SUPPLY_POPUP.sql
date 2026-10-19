

/*
 * Program ID   : SCM0002_GET_BODITEM_FOR_SUPPLY_POPUP
 * Description  : BOD ITEM 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/07/08   hwyoon			Initial Release [PS02199094B] [CSR ID:4043582] GSCM - Shipment Plan FG / SEMI "New" 버튼 생성 요청 건
 * 2021/07/07   khj79			PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 개발 : FROM,TO 추가 , scp_mst_bod_v=> scp_mst_bod_n_v
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 2026/04/17	YMH				E20260417-001788 Shipment Plan FG 에 New line 추가 시 BOD Validation 기능 제거
 * 2026/06/29	YMH				E20260511-000181 BOD ITEM-Excluded Item Tab 조회저장 로직 수정요청
 */
CREATE PROCEDURE [dbo].[SCM0002_GET_BODITEM_FOR_SUPPLY_POPUP]
--chaan   @p_division_id				NVARCHAR(2)
   @p_division_id				NVARCHAR(30)--chaan
  ,@p_plan_start_yyyymmdd		NVARCHAR(8)
  ,@p_plan_type					NVARCHAR(2)
  ,@p_seq						NVARCHAR(2)
  ,@p_operation_group			NVARCHAR(2)
--chaan  ,@p_origin_from_division_id	NVARCHAR(2)
  ,@p_origin_from_division_id	NVARCHAR(30)--chaan
--chaan  ,@p_origin_to_division_id		NVARCHAR(2)	
  ,@p_origin_to_division_id		NVARCHAR(30)	--chaan
  ,@p_item_id					NVARCHAR(MAX)
  ,@p_prgram_id					NVARCHAR(MAX)
AS  
  
BEGIN
		SET NOCOUNT ON; 
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

		declare @p_to_site_type nvarchar(max) = '';

		if(@p_prgram_id='FG') 
			SET @p_to_site_type='SALES'
		ELSE IF(@p_prgram_id='ALL')				-- E20260511-000181  BOD ITEM-Excluded Item Tab 조회저장 로직 수정요청
			SET @p_to_site_type='ALL'			-- E20260511-000181  BOD ITEM-Excluded Item Tab 조회저장 로직 수정요청
		ELSE
			SET @p_to_site_type='PLANT'

		/********************************************************************************      
		* 임시테이블만들기 - 조회조건 테이블      
		********************************************************************************/      
		IF OBJECT_ID('tempdb..#TblDynamic_SCM0002_ShpimentPlan') IS NOT NULL
		DROP TABLE #TblDynamic_SCM0002_ShpimentPlan;    

		CREATE TABLE #TblDynamic_SCM0002_ShpimentPlan (
			DIVISION_ID						NVARCHAR(30)	
			,ORIGIN_FROM_DIVISION_ID		NVARCHAR(30)	
			,FROM_SITE						NVARCHAR(30)
			,ORIGIN_TO_DIVISION_ID			NVARCHAR(30)	
			,TO_SITE						NVARCHAR(30)
			,ITEM_ID						NVARCHAR(50)
			,BOD_ID							NVARCHAR(150)
		);

		IF(@p_prgram_id='FG')
			BEGIN
				INSERT INTO #TblDynamic_SCM0002_ShpimentPlan
				SELECT DISTINCT DIVISION_ID
						, ORIGIN_FROM_DIVISION_ID
						, FROM_SITE
						, ORIGIN_TO_DIVISION_ID
						, TO_SITE
						, ITEM_ID
						, BOD_ID
				FROM SCP_ANL_SHIPMENT_PLAN_FG WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND PLAN_TYPE = @p_plan_type
				AND SEQ = @p_seq
				AND BIZ_TYPE = @p_operation_group
				AND ITEM_ID = @p_item_id
				AND MEASURE = 'SHIP_PLAN_AMEND'
				AND YYYYMMDD = @p_plan_start_yyyymmdd
			END
		ELSE IF(@p_prgram_id='ALL')
				INSERT INTO #TblDynamic_SCM0002_ShpimentPlan
				SELECT DISTINCT DIVISION_ID
						, ORIGIN_FROM_DIVISION_ID
						, FROM_SITE
						, ORIGIN_TO_DIVISION_ID
						, TO_SITE
						, ITEM_ID
						, BOD_ID
				FROM SCP_ANL_SHIPMENT_PLAN_FG WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND PLAN_TYPE = @p_plan_type
				AND SEQ = @p_seq
				AND BIZ_TYPE = @p_operation_group
				AND ITEM_ID = @p_item_id
				AND MEASURE = 'SHIP_PLAN_AMEND'
				AND YYYYMMDD = @p_plan_start_yyyymmdd
				UNION ALL
				SELECT DISTINCT DIVISION_ID
						, ORIGIN_FROM_DIVISION_ID
						, FROM_SITE
						, ORIGIN_TO_DIVISION_ID
						, TO_SITE
						, ITEM_ID
						, BOD_ID
				FROM SCP_ANL_SHIPMENT_PLAN_SEMI WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND PLAN_TYPE = @p_plan_type
				AND SEQ = @p_seq
				AND OPERATION_GROUP = @p_operation_group
				AND ITEM_ID = @p_item_id
				AND MEASURE = 'SHIP_PLAN_AMEND'
				AND YYYYMMDD = @p_plan_start_yyyymmdd
		ELSE 
			BEGIN
				INSERT INTO #TblDynamic_SCM0002_ShpimentPlan
				SELECT DISTINCT DIVISION_ID
						, ORIGIN_FROM_DIVISION_ID
						, FROM_SITE
						, ORIGIN_TO_DIVISION_ID
						, TO_SITE
						, ITEM_ID
						, BOD_ID
				FROM SCP_ANL_SHIPMENT_PLAN_SEMI WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND PLAN_TYPE = @p_plan_type
				AND SEQ = @p_seq
				AND OPERATION_GROUP = @p_operation_group
				AND ITEM_ID = @p_item_id
				AND MEASURE = 'SHIP_PLAN_AMEND'
				AND YYYYMMDD = @p_plan_start_yyyymmdd
			END

		-- E20260417-001788 Shipment Plan FG 에 New line 추가 시 BOD Validation 기능 제거로 기존로직 주석
		--SELECT (CASE WHEN S.BOD_ID IS NULL OR S.BOD_ID='' THEN 'N' ELSE 'Y' END) CHK
		--	   , (CASE WHEN S.BOD_ID IS NULL OR S.BOD_ID='' THEN 'N' ELSE 'Y' END) LOCK
		-- E20260417-001788 Shipment Plan FG 에 New line 추가 시 BOD Validation 기능 제거 로직 추가. FG UI 에서 베리데이션 해제.
		SELECT IiF(@p_prgram_id='FG','N',(CASE WHEN S.BOD_ID IS NULL OR S.BOD_ID='' THEN 'N' ELSE 'Y' END))  CHK
			   , IiF(@p_prgram_id='FG','N',(CASE WHEN S.BOD_ID IS NULL OR S.BOD_ID='' THEN 'N' ELSE 'Y' END))  LOCK
			   , a.*
			FROM(
					SELECT  distinct
							a.division_id
							,b.from_site
							,SF.division_id AS FROM_DIVISION_ID
							,SF.SITE_TYPE AS FROM_SITE_TYPE
							,SF.SITE_DESCRIPTION AS FROM_SITE_NAME
							,b.to_site
							,ST.division_id AS TO_DIVISION_ID
							,ST.SITE_TYPE AS TO_SITE_TYPE
							,ST.SITE_DESCRIPTION AS TO_SITE_NAME
							,a.item_id
							,a.priority
							,a.bod_id
							,b.incoterms
							,c.transport_mode 
							-- BOD 2단계 개발
							--,(SELECT v.lt_total FROM scp_mst_bod_v v WHERE v.division_id = b.division_id  and v.bod_id = b.bod_id ) AS lead_time
							,(SELECT v.lt_total FROM scp_mst_bod_n_v v WHERE v.division_id = b.division_id  and v.bod_id = b.bod_id ) AS lead_time
							,a.valid_yn AS BOD_ITEM_VALID
							,c.route_id  
 							,c.days_mon  
 							,c.days_tue  
 							,c.days_wed  
 							,c.days_thu  
 							,c.days_fri  
 							,c.days_sat  
 							,c.days_sun
							,CONVERT(date,b.attribute2,112)		AS FROM_YYYYMMDD	-- BOD 2단계 개발
							,CONVERT(date,b.attribute3,112)		AS TO_YYYYMMDD		-- BOD 2단계 개발
					FROM scp_mst_bod_item a  
					INNER JOIN scp_mst_bod b  ON a.bod_id = b.bod_id
					INNER JOIN SCM_MST_SITE SF ON SF.SCM_SITE_ID=b.from_site and sf.SITE_TYPE='PLANT' and sf.operation_group=@p_operation_group
					-- E20260511-000181  BOD ITEM-Excluded Item Tab 조회저장 로직 수정요청으로 주석처리
					-- INNER JOIN SCM_MST_SITE ST ON ST.SCM_SITE_ID=b.to_site AND ST.SITE_TYPE = @p_to_site_type
					-- E20260511-000181  BOD ITEM-Excluded Item Tab 조회저장 로직 수정요청으로 신규로직 시작
					INNER JOIN SCM_MST_SITE ST ON ST.SCM_SITE_ID=b.to_site 
					AND 
					(
						@p_to_site_type = 'ALL' 
						OR 
						(
							@p_to_site_type != 'ALL' 
							AND 
							ST.SITE_TYPE = @p_to_site_type
						)
					)
					-- E20260511-000181  BOD ITEM-Excluded Item Tab 조회저장 로직 수정요청으로 신규로직 끝

					INNER JOIN scp_mst_distribution_route c  ON b.route_id = c.route_id 
			) a
			LEFT OUTER JOIN #TblDynamic_SCM0002_ShpimentPlan S ON S.ORIGIN_FROM_DIVISION_ID = A.FROM_DIVISION_ID
															   AND S.FROM_SITE = A.FROM_SITE
															   AND S.ORIGIN_TO_DIVISION_ID = A.TO_DIVISION_ID
															   AND S.TO_SITE = A.TO_SITE
															   AND S.BOD_ID = A.BOD_ID
			WHERE 1=1
				and a.division_id = @p_origin_from_division_id
				and a.TO_DIVISION_ID = @p_origin_to_division_id
				and a.item_id=@p_item_id
			ORDER BY a.BOD_ITEM_VALID desc, a.division_id, a.from_site, a.to_site, a.priority, a.INCOTERMS, a.TRANSPORT_MODE 

		IF OBJECT_ID('tempdb..#TblDynamic_SCM0002_ShpimentPlan') IS NOT NULL
		DROP TABLE #TblDynamic_SCM0002_ShpimentPlan;    
								  
END

