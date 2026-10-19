
/*
 * Program ID   : SCP0013_GET_NEW_POPUP_INFO
 * Description  : new - popup 용도 : UP_FX_GetCommonDataList_SCP -> SCP0013_GET_NEW_POPUP_INFO
 * Program History
 *  @PARAM1 = DIVISION, @PARAM2 = OPERATION_GROUP, @PARAM3 = Plan Date, @PARAM4 = Plan Type, @PARAM5 = Seq
================================================================================
   Date       In Charge      Description
================================================================================
 2022/11/03   lwy           PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Initial Release
                            - 개체참조 오류 지속 발생으로 sp 생성

*/

CREATE PROCEDURE [dbo].[SCP0013_GET_NEW_POPUP_INFO]
   @code NVARCHAR(100)
 , @param1 NVARCHAR(100)
 , @param2 NVARCHAR(100)
 , @param3 NVARCHAR(MAX)
 , @param4 NVARCHAR(MAX)
 , @param5 NVARCHAR(MAX)

AS

BEGIN
 SET NOCOUNT ON;
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

/*===============================================
용		 도:  Item List 조회
사 용 화 면:  Production Plan Line Insert Popup - 조회조건
변       수:  @PARAM1 = DIVISION, @PARAM2 = OPERATION_GROUP, @PARAM3 = Plan Date, @PARAM4 = Plan Type, @PARAM5 = Seq
최 초 작 성:
개  발  자 :
최 종 작 성:  2021. 05. 24
수  정  자 :  ygkim,khj79
수 정 사 항:  scp_mst_tact_time => SCM_MST_TACT_TIME_SN 변경 , TACT TIME 계획 종료구간 추가
===============================================*/
 IF @Code = 'ItemProdPlanLinePopup'
	BEGIN
		--IF @Param1 = 'EE'
		IF @Param1 LIKE 'EE%'
			BEGIN
				IF OBJECT_ID('tempdb..#TT') IS NOT NULL
				    BEGIN    DROP TABLE #TT END;

				SELECT DISTINCT DIVISION_ID, ITEM_ID, PLANT_ID
				INTO #TT
									  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
									 WHERE ( @Param3='' or @Param3 is null or X.DIVISION_ID=@Param3)
									   AND X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
									   AND X.TACT_TIME > 0
									    ----- 계획 종료 구간 추가
									   --AND MONTH < = (  SELECT p.horizon_end_date  // LWY
									   AND MONTH < = (  SELECT MAX(p.horizon_end_date) AS horizon_end_date
														 FROM dbo.scm_mst_plan p WITH(NOLOCK)
														WHERE ( @Param3='' or @Param3 is null or P.DIVISION_ID=@Param3)
														  AND p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK)
																				WHERE ( @Param3='' or @Param3 is null or X.DIVISION_ID=@Param3)
																				  and plan_id <  9999)
																				)
													;

				SELECT a.ITEM_ID CODE
						,a.ITEM_ID NAME
						,PLANT_SITE_ID
						,c.SITE_DESCRIPTION
						,(select top 1 NICK_NAME from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID) NICK_NAME
						,CASE WHEN C.OSP_YN='Y' THEN (select top 1 ITEM_TYPE from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID AND (B.ITEM_TYPE='P' OR B.ITEM_TYPE='H'))
							  ELSE (select MIN(ISNULL(ITEM_TYPE,'Z')) from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID and b.site_id=c.site_id)
							  --ELSE (select top 1 ITEM_TYPE from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID and b.site_id=c.site_id)
						 END ITEM_TYPE
						--,(select top 1 ITEM_TYPE from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID and b.site_id=c.site_id) ITEM_TYPE
						,OPERATION_ID
						,a.DIVISION_ID
						,C.OSP_YN
				FROM(
						SELECT distinct a.ITEM_ID, a.PLANT_SITE_ID, SUBSTRING(i.FLOW_ID,1,5) OPERATION_ID, a.division_id
						FROM scm_mst_site_item_priority a (NOLOCK)
						--JOIN scp_mst_tact_time b (NOLOCK) ON a.item_id = b.item_id AND a.PLANT_SITE_ID = b.PLANT_SITE_ID
						--LEFT JOIN scp_mst_tact_time b (NOLOCK) ON a.division_id = b.division_id AND a.item_id = b.item_id AND a.PLANT_SITE_ID = b.PLANT_SITE_ID
						JOIN SCM_MST_SITE C WITH(NOLOCK) ON C.SCM_SITE_ID=A.PLANT_SITE_ID
						-- 테이블 변경
						LEFT JOIN #TT B
					/*	LEFT JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID, PLANT_ID
									  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
									 WHERE ( @Param3='' or @Param3 is null or X.DIVISION_ID=@Param3)
									   AND X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
									   AND X.TACT_TIME > 0
									    ----- 계획 종료 구간 추가
									   --AND MONTH <= (  SELECT p.horizon_end_date  // LWY
									   AND MONTH <= (  SELECT MAX(p.horizon_end_date) AS horizon_end_date
														 FROM dbo.scm_mst_plan p WITH(NOLOCK)
														WHERE ( @Param3='' or @Param3 is null or P.DIVISION_ID=@Param3)
														  AND p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK)
																				WHERE ( @Param3='' or @Param3 is null or X.DIVISION_ID=@Param3)
																				  and plan_id < 9999)
																				)
													) B */
							 ON A.DIVISION_ID	= B.DIVISION_ID
							AND A.ITEM_ID		= B.ITEM_ID
							AND C.PLANT_ID		= B.PLANT_ID

						LEFT OUTER JOIN SCP_MST_FINAL_ITEM i (NOLOCK) ON a.division_id = i.division_id AND a.item_id = i.item_id
						LEFT JOIN SCP_MST_OUTSOURCING_CAPA P WITH(NOLOCK) ON P.division_id=A.DIVISION_ID AND P.PLANT_SITE_ID=A.PLANT_SITE_ID AND A.ITEM_ID = P.ITEM_ID
						WHERE a.VALID_YN ='Y'
						AND (
									--(C.OSP_YN='N' AND b.VALID_YN ='Y'	) OR
									( C.OSP_YN='N' ) OR   -- 테이블 변경
									(C.OSP_YN='Y')
								)
						and ( @Param2='' or @Param2 is null or i.OPERATION_GROUP = @Param2 )
						AND (
									--(C.OSP_YN='N' AND B.TACT_TIME IS NOT NULL) OR
									(C.OSP_YN='N' AND B.DIVISION_ID IS NOT NULL) OR  -- 테이블 변경
									(C.OSP_YN='Y' AND P.daily_capa_qty IS NOT NULL)
								)
						and ( @Param3='' or @Param3 is null or a.DIVISION_ID=@Param3)
						-- 생산계획 있는 모델이라고 하더라도 라인 변경해서 추가할 경우가 있으므로 제외함 - 08.31 (정병훈D)
						--AND not exists (select 'x' from SCP_ANL_PRODUCTION_PLAN c (NOLOCK)
						--				where a.division_id = c.DIVISION_ID
						--				and a.ITEM_ID = c.ITEM_ID
						--				and (a.PLANT_SITE_ID = c.SCM_SITE_ID or b.PLANT_SITE_ID = c.SCM_SITE_ID)
						--				AND c.PLAN_START_YYYYMMDD = @Param3
						--				AND PLAN_TYPE = @Param4
						--				AND SEQ = @Param5
						--				AND OPERATION_GROUP = @Param2
						--				)
				) a
				LEFT OUTER JOIN SCM_MST_SITE c WITH(NOLOCK) ON A.PLANT_SITE_ID = c.SCM_SITE_ID AND C.VALID_YN = 'Y'
				--WHERE a.DIVISION_ID IN ('40','81','82')
				WHERE a.DIVISION_ID IN (SELECT division_id FROM SCM_MST_DIVISION WITH(NOLOCK) 
                                        WHERE  attribute4 IN (SELECT attribute4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE division_id = @param1 )
                                      )
				order by a.item_id

				IF OBJECT_ID('tempdb..#TT') IS NOT NULL
				    BEGIN    DROP TABLE #TT END;
			END
		ELSE
			BEGIN
					SELECT a.ITEM_ID CODE
							,a.ITEM_ID NAME
							,PLANT_SITE_ID
							,c.SITE_DESCRIPTION
							,(select top 1 NICK_NAME from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID) NICK_NAME
							,CASE WHEN C.OSP_YN='Y' THEN (select top 1 ITEM_TYPE from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID AND (B.ITEM_TYPE='P' OR B.ITEM_TYPE='H'))
								  ELSE (select MIN(ISNULL(ITEM_TYPE,'Z')) from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID and b.site_id=c.site_id)
							 END ITEM_TYPE
							--,(select top 1 ITEM_TYPE from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID and b.site_id=c.site_id) ITEM_TYPE
							,OPERATION_ID
							,a.DIVISION_ID
							,C.OSP_YN
					FROM(
							SELECT distinct a.ITEM_ID, a.PLANT_SITE_ID, SUBSTRING(i.FLOW_ID,1,5) OPERATION_ID, a.DIVISION_ID
							FROM scm_mst_site_item_priority a (NOLOCK)
							--LEFT JOIN scp_mst_tact_time b (NOLOCK) ON a.division_id = b.division_id AND a.item_id = b.item_id AND a.PLANT_SITE_ID = b.PLANT_SITE_ID
							LEFT OUTER JOIN SCP_MST_FINAL_ITEM i (NOLOCK) ON a.division_id = i.division_id AND a.item_id = i.item_id
							JOIN SCM_MST_SITE C WITH(NOLOCK) ON C.SCM_SITE_ID=A.PLANT_SITE_ID
							-- 테이블 변경
							LEFT JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID, PLANT_ID
									  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
									 WHERE X.DIVISION_ID  = @Param1
									   AND X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
									   AND X.TACT_TIME > 0
									     ----- 계획 종료 구간 추가
									   AND MONTH <= (  SELECT p.horizon_end_date
														 FROM dbo.scm_mst_plan p WITH(NOLOCK)
														WHERE ( @Param1='' or @Param1 is null or P.DIVISION_ID=@Param1)
														  AND p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK)
																				WHERE ( @Param1='' or @Param1 is null or X.DIVISION_ID=@Param1)
																				  and plan_id < 9999)
													)
										) B
							 ON A.DIVISION_ID	= B.DIVISION_ID
							AND A.ITEM_ID		= B.ITEM_ID
							AND C.PLANT_ID		= B.PLANT_ID

							LEFT JOIN SCP_MST_OUTSOURCING_CAPA P WITH(NOLOCK) ON P.division_id=A.DIVISION_ID AND P.PLANT_SITE_ID=A.PLANT_SITE_ID AND A.ITEM_ID = P.ITEM_ID
							--AND i.site_id = ( select site_id from scm_mst_plant_sn s (NOLOCK) where s.division_id = a.division_id and s.plant_id = dbo.fn_scm_split(a.plant_site_id,1,'-') )
							WHERE a.VALID_YN ='Y'
							AND (
									--(C.OSP_YN='N' AND b.VALID_YN ='Y'	) OR
									( C.OSP_YN='N' ) OR   -- 테이블 변경
									--ESS 외주 Pakcer Line 생산 Target 적용
									--(C.OSP_YN='Y')
									(C.OSP_YN='Y' AND ISNULL(C.ATTRIBUTE1,'N') IN ('','N'))
								)
							AND a.DIVISION_ID = @Param1
							and ( @Param2='' or @Param2 is null or i.OPERATION_GROUP = @Param2 )
							AND (
									--(C.OSP_YN='N' AND B.TACT_TIME IS NOT NULL) OR
									(C.OSP_YN='N' AND B.DIVISION_ID IS NOT NULL) OR  -- 테이블 변경
									--ESS 외주 Pakcer Line 생산 Target 적용
									--(C.OSP_YN='Y' AND P.daily_capa_qty IS NOT NULL)
									(C.OSP_YN='Y' AND P.daily_capa_qty IS NOT NULL AND ISNULL(C.ATTRIBUTE1,'N') IN ('','N'))
								)
							/*
							SELECT distinct a.ITEM_ID, a.PLANT_SITE_ID, SUBSTRING(i.FLOW_ID,1,5) OPERATION_ID, a.DIVISION_ID
							FROM scm_mst_site_item_priority a (NOLOCK)
							JOIN scp_mst_tact_time b (NOLOCK) ON a.division_id = b.division_id AND a.item_id = b.item_id AND a.PLANT_SITE_ID = b.PLANT_SITE_ID
							LEFT OUTER JOIN SCP_MST_FINAL_ITEM i (NOLOCK) ON a.division_id = i.division_id
							AND a.item_id = i.item_id
							--AND i.site_id = ( select site_id from scm_mst_plant_sn s (NOLOCK) where s.division_id = a.division_id and s.plant_id = dbo.fn_scm_split(a.plant_site_id,1,'-') )
							WHERE a.VALID_YN ='Y'
							AND b.VALID_YN ='Y'
							AND a.DIVISION_ID = @Param1
							and i.OPERATION_GROUP = @Param2
							*/
							-- 생산계획 있는 모델이라고 하더라도 라인 변경해서 추가할 경우가 있으므로 제외함 - 08.31 (정병훈D)
							--AND not exists (select 'x' from SCP_ANL_PRODUCTION_PLAN c (NOLOCK)
							--				where a.division_id = c.DIVISION_ID
							--				and a.ITEM_ID = c.ITEM_ID
							--				and (a.PLANT_SITE_ID = c.SCM_SITE_ID or b.PLANT_SITE_ID = c.SCM_SITE_ID)
							--				AND c.PLAN_START_YYYYMMDD = @Param3
							--				AND PLAN_TYPE = @Param4
							--				AND SEQ = @Param5
							--				AND OPERATION_GROUP = @Param2
							--				)
							-- ESS 외주 Pakcer Line 생산 Target 적용
							UNION ALL
							SELECT distinct a.ITEM_ID, a.PLANT_SITE_ID, SUBSTRING(i.FLOW_ID,1,5) OPERATION_ID, a.DIVISION_ID
							FROM scm_mst_site_item_priority a (NOLOCK)
							JOIN scp_mst_tact_time_OSP b (NOLOCK) ON a.division_id = b.division_id AND a.item_id = b.item_id AND a.PLANT_SITE_ID = b.PLANT_SITE_ID	AND B.VALID_YN='Y'
							LEFT OUTER JOIN SCP_MST_FINAL_ITEM i (NOLOCK) ON a.division_id = i.division_id AND a.item_id = i.item_id
							JOIN SCM_MST_SITE C WITH(NOLOCK) ON C.SCM_SITE_ID=A.PLANT_SITE_ID AND C.OSP_YN='Y' AND ISNULL(C.ATTRIBUTE1,'N')='Y'
							WHERE a.VALID_YN ='Y'
							AND a.DIVISION_ID = @Param1
							AND ( @Param2='' or @Param2 is null or i.OPERATION_GROUP = @Param2 )
					) a
					LEFT OUTER JOIN SCM_MST_SITE c WITH(NOLOCK) ON A.PLANT_SITE_ID = c.SCM_SITE_ID AND C.VALID_YN = 'Y'
					order by a.item_id
				END

	END

/*===============================================
	용		 도:  LineProdPlanLinePopupAll
	사 용 화 면:  Production Plan Line New 입력 팝업에서 사용
	변       수:  @PARAM1=OPERATION_GROUP
	최 초 작 성:  2019. 03. 22
	개  발  자 :  YWHOON
	최 종 작 성:  2019. 03. 22
	수  정  자 :
	수 정 사 항:  [CSR ID:3962713]  Production Plan Line 신규 다건입력 로직 개선의 건
	2020.02.27		ESS 외주 Pakcer Line 생산 Target 적용
	2021.05.24		scp_mst_tact_time => SCM_MST_TACT_TIME_SN 변경 , khj79
	2022.07.22        ISUZU 관련 수정 , lwy
===============================================*/
ELSE IF @Code = 'LineProdPlanLinePopupAll'
	BEGIN
		SELECT
		DISTINCT
				A.LINE_ID						  AS CODE
			,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
			--,t.PLANT_SITE_ID
			,B.SCM_SITE_ID	AS plant_site_id
			,t.ITEM_ID
			,t.OPERATION_ID
			,A.DIVISION_ID
		FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
		JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID AND A.DIVISION_ID=B.DIVISION_ID
		INNER HASH JOIN  (SELECT DISTINCT b.segment4, b.segment1
						FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
						WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
						AND    b.valid_yn    = 'Y'
						AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
					) f ON a.operation_id = f.segment4 --AND c.operation_group_id = f.segment3 -- operation group id 에 추가된 operation 만보이도록
		--JOIN scp_mst_tact_time t WITH(NOLOCK) on t.division_id=A.DIVISION_ID and t.plant_site_id=b.SCM_SITE_ID and t.operation_id=A.OPERATION_ID and t.line_id=A.LINE_ID
		 JOIN ( SELECT DISTINCT X.DIVISION_ID, ITEM_ID , PLANT_ID , LINE_ID , OPERATION_ID
				  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
				 WHERE X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
				   AND X.TACT_TIME > 0
			  ) T
		   ON T.DIVISION_ID = A.DIVISION_ID AND T.PLANT_ID = B.PLANT_ID AND T.OPERATION_ID = A.OPERATION_ID AND T.LINE_ID=A.LINE_ID
		WHERE 1=1
		AND A.ACTIVE_FLAG ='Y'
		AND  (@Param1 IS NULL OR @Param1='' OR b.OPERATION_GROUP = @Param1 )
		UNION
		SELECT
		DISTINCT
			A.LINE_ID						  AS CODE
			,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
			,B.PLANT_SITE_ID
			,B.ITEM_ID
			,B.OPERATION_ID
			,A.DIVISION_ID
		FROM SCM_MST_LINE_OSP A WITH(NOLOCK)
		JOIN SCM_MST_SITE S WITH(NOLOCK) ON S.DIVISION_ID=A.DIVISION_ID
											AND S.SCM_SITE_ID=A.SCM_SITE_ID
											AND S.OSP_YN='Y'
											AND ISNULL(S.ATTRIBUTE1,'N')='Y'
		JOIN SCP_MST_TACT_TIME_OSP B WITH(NOLOCK) ON A.DIVISION_ID=B.DIVISION_ID
													AND A.SCM_SITE_ID=B.PLANT_SITE_ID
													--AND B.ITEM_ID=@Param6
													AND B.VALID_YN='Y'
													AND A.LINE_ID=B.LINE_ID
		WHERE 1=1--A.DIVISION_ID=@Param1
		--AND A.SCM_SITE_ID=@Param3
		AND A.VALID_YN='Y'
		AND  (@Param1 IS NULL OR @Param1='' OR S.OPERATION_GROUP=@Param1 )

		-- 2022.07.22 Begin
		UNION

		SELECT
		DISTINCT
				A.LINE_ID						  AS CODE
			   ,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME			
			   ,B.SCM_SITE_ID	AS plant_site_id
			   ,t.ITEM_ID
			   ,t.OPERATION_ID
			   ,A.DIVISION_ID
		FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
		JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID AND A.DIVISION_ID=B.DIVISION_ID
		
		JOIN ( SELECT DISTINCT X.DIVISION_ID, X.ITEM_ID , X.PLANT_ID , X.LINE_ID , X.OPERATION_ID
			     FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
				 JOIN dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
					ON X.ITEM_ID = A.ITEM_ID
				   AND X.DIVISION_ID = A.DIVISION_ID
				WHERE X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
				  AND X.TACT_TIME > 0
			 ) T
		   ON T.DIVISION_ID = A.DIVISION_ID AND T.PLANT_ID = B.PLANT_ID AND T.OPERATION_ID = A.OPERATION_ID AND T.LINE_ID=A.LINE_ID
		WHERE 1=1
		AND A.ACTIVE_FLAG ='Y'
		AND  (@Param1 IS NULL OR @Param1='' OR b.OPERATION_GROUP = @Param1 )
		-- 2022.07.22 End

	END




RETURN;

 --------------
END

