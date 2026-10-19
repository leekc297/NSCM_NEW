
/*
 * Program ID   : SCP0051_GET_NEW_INFO
 * Description  : 
 * Program History
 *  @PARAM1 = DIVISION, @PARAM2 = OPERATION_GROUP, @PARAM3 = Plan Date, @PARAM4 = Plan Type, @PARAM5 = Seq
================================================================================
   Date       In Charge      Description
================================================================================
 2022/11/10   lwy           PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Initial Release
                            - 개체참조 오류 지속 발생으로 sp 생성
 2024.01.25   vadabi3       NERP - 특정 Company 별도 처리 개선
 2024.06.09	  vadabi5	    NERP) QA, 개발 DB 적용
 ----------------------------------------------------------------------------------------------------
 exec NERP_SCP0051_GET_NEW_INFO
   @code   = ''
 , @param1 = ''
 , @param2 = ''
 , @param3 = ''
 , @param4 = ''
 , @param5 = ''
 , @param6 = ''

 exec SCP0051_GET_NEW_INFO
   @code   = ''
 , @param1 = ''
 , @param2 = ''
 , @param3 = ''
 , @param4 = ''
 , @param5 = ''
 , @param6 = ''
*/

CREATE PROCEDURE [dbo].[SCP0051_GET_NEW_INFO]
   @code   NVARCHAR(100)
 , @param1 NVARCHAR(200)
 , @param2 NVARCHAR(200)
 , @param3 NVARCHAR(200)
 , @param4 NVARCHAR(200)
 , @param5 NVARCHAR(200)
 , @param6 NVARCHAR(200)

AS

BEGIN
 SET NOCOUNT ON;
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

 -- NERP 매핑코드
 DECLARE @v_PLANT_NJ NVARCHAR(8); -- G182
 SELECT @v_PLANT_NJ = dbo.FN_GET_LOOKUP_VALUE('SCP0051_GET_NEW_INFO','PLANT_ID')

 IF @Code = 'ItemProdPlanLinePopup'
	BEGIN
		IF @Param1 = 'EE'
			BEGIN
				SELECT a.ITEM_ID CODE
						,a.ITEM_ID NAME
						,PLANT_SITE_ID
						,c.SITE_DESCRIPTION
						,(select top 1 NICK_NAME from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID) NICK_NAME
						,CASE WHEN C.OSP_YN='Y' THEN (select top 1 ITEM_TYPE from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID AND (B.ITEM_TYPE='P' OR B.ITEM_TYPE='H'))
							  ELSE (select MIN(ISNULL(ITEM_TYPE,'Z')) from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID and b.site_id=c.site_id)
						 END ITEM_TYPE
						,OPERATION_ID
						,a.DIVISION_ID
						,C.OSP_YN
				FROM(
						SELECT distinct a.ITEM_ID, a.PLANT_SITE_ID, SUBSTRING(i.FLOW_ID,1,5) OPERATION_ID, a.division_id
						FROM scm_mst_site_item_priority a (NOLOCK)
						JOIN SCM_MST_SITE C WITH(NOLOCK) ON C.SCM_SITE_ID=A.PLANT_SITE_ID
						-- 테이블 변경
						LEFT JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID, PLANT_ID
									  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
									 WHERE ( @Param3='' or @Param3 is null or X.DIVISION_ID=@Param3)
									   AND X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
									   AND X.TACT_TIME > 0
									    ----- 계획 종료 구간 추가
									   AND MONTH <= (  SELECT MAX(p.horizon_end_date) AS horizon_end_date
														 FROM dbo.scm_mst_plan p WITH(NOLOCK)
														WHERE ( @Param3='' or @Param3 is null or P.DIVISION_ID=@Param3)
														  AND p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK)
																				WHERE ( @Param3='' or @Param3 is null or X.DIVISION_ID=@Param3)
																				  and plan_id < 9999)
																				)
													) B
							 ON A.DIVISION_ID	= B.DIVISION_ID
							AND A.ITEM_ID		= B.ITEM_ID
							AND C.PLANT_ID		= B.PLANT_ID

						LEFT OUTER JOIN SCP_MST_FINAL_ITEM i (NOLOCK) ON a.division_id = i.division_id AND a.item_id = i.item_id
						LEFT JOIN SCP_MST_OUTSOURCING_CAPA P WITH(NOLOCK) ON P.division_id=A.DIVISION_ID AND P.PLANT_SITE_ID=A.PLANT_SITE_ID AND A.ITEM_ID = P.ITEM_ID
						WHERE a.VALID_YN ='Y'
						AND (
									( C.OSP_YN='N' ) OR   -- 테이블 변경
									(C.OSP_YN='Y')
								)
						and ( @Param2='' or @Param2 is null or i.OPERATION_GROUP = @Param2 )
						AND (
									(C.OSP_YN='N' AND B.DIVISION_ID IS NOT NULL) OR  -- 테이블 변경
									(C.OSP_YN='Y' AND P.daily_capa_qty IS NOT NULL)
								)
						and ( @Param3='' or @Param3 is null or a.DIVISION_ID=@Param3)
				) a
				LEFT OUTER JOIN SCM_MST_SITE c WITH(NOLOCK) ON A.PLANT_SITE_ID = c.SCM_SITE_ID AND C.VALID_YN = 'Y'
				WHERE a.DIVISION_ID IN ('40','81','82')
				order by a.item_id
			END
		ELSE IF @Param1 = 'EE_UC'
			BEGIN
				SELECT a.ITEM_ID CODE
						,a.ITEM_ID NAME
						,PLANT_SITE_ID
						,c.SITE_DESCRIPTION
						,(select top 1 NICK_NAME from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID) NICK_NAME
						,CASE WHEN C.OSP_YN='Y' THEN (select top 1 ITEM_TYPE from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID AND (B.ITEM_TYPE='P' OR B.ITEM_TYPE='H'))
							  ELSE (select MIN(ISNULL(ITEM_TYPE,'Z')) from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID and b.site_id=c.site_id)
						 END ITEM_TYPE
						,OPERATION_ID
						,a.DIVISION_ID
						,C.OSP_YN
				FROM(
						SELECT distinct a.ITEM_ID, a.PLANT_SITE_ID, SUBSTRING(i.FLOW_ID,1,5) OPERATION_ID, a.division_id
						FROM scm_mst_site_item_priority a (NOLOCK)
						JOIN SCM_MST_SITE C WITH(NOLOCK) ON C.SCM_SITE_ID=A.PLANT_SITE_ID
						-- 테이블 변경
						LEFT JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID, PLANT_ID
									  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
									 WHERE ( @Param3='' or @Param3 is null or X.DIVISION_ID=@Param3)
									   AND X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
									   AND X.TACT_TIME > 0
									    ----- 계획 종료 구간 추가
									   AND MONTH <= (  SELECT MAX(p.horizon_end_date) AS horizon_end_date
														 FROM dbo.scm_mst_plan p WITH(NOLOCK)
														WHERE ( @Param3='' or @Param3 is null or P.DIVISION_ID=@Param3)
														  AND p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK)
																				WHERE ( @Param3='' or @Param3 is null or X.DIVISION_ID=@Param3)
																				  and plan_id < 9999)
																				)
													) B
							 ON A.DIVISION_ID	= B.DIVISION_ID
							AND A.ITEM_ID		= B.ITEM_ID
							AND C.PLANT_ID		= B.PLANT_ID

						LEFT OUTER JOIN SCP_MST_FINAL_ITEM i (NOLOCK) ON a.division_id = i.division_id AND a.item_id = i.item_id
						LEFT JOIN SCP_MST_OUTSOURCING_CAPA P WITH(NOLOCK) ON P.division_id=A.DIVISION_ID AND P.PLANT_SITE_ID=A.PLANT_SITE_ID AND A.ITEM_ID = P.ITEM_ID
						WHERE a.VALID_YN ='Y'
						AND (
									( C.OSP_YN='N' ) OR   -- 테이블 변경
									(C.OSP_YN='Y')
								)
						and ( @Param2='' or @Param2 is null or i.OPERATION_GROUP = @Param2 )
						AND (
									(C.OSP_YN='N' AND B.DIVISION_ID IS NOT NULL) OR  -- 테이블 변경
									(C.OSP_YN='Y' AND P.daily_capa_qty IS NOT NULL)
								)
						and ( @Param3='' or @Param3 is null or a.DIVISION_ID=@Param3)
				) a
				LEFT OUTER JOIN SCM_MST_SITE c WITH(NOLOCK) ON A.PLANT_SITE_ID = c.SCM_SITE_ID AND C.VALID_YN = 'Y'
				WHERE a.DIVISION_ID IN ('81_UC')
				order by a.item_id
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
							,OPERATION_ID
							,a.DIVISION_ID
							,C.OSP_YN
					FROM(
							SELECT distinct a.ITEM_ID, a.PLANT_SITE_ID, SUBSTRING(i.FLOW_ID,1,5) OPERATION_ID, a.DIVISION_ID
							FROM scm_mst_site_item_priority a (NOLOCK)
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
							WHERE a.VALID_YN ='Y'
							AND (
									( C.OSP_YN='N' ) OR   -- 테이블 변경
									(C.OSP_YN='Y' AND ISNULL(C.ATTRIBUTE1,'N') IN ('','N'))
								)
							AND a.DIVISION_ID = @Param1
							and ( @Param2='' or @Param2 is null or i.OPERATION_GROUP = @Param2 )
							AND (
									(C.OSP_YN='N' AND B.DIVISION_ID IS NOT NULL) OR  -- 테이블 변경
									(C.OSP_YN='Y' AND P.daily_capa_qty IS NOT NULL AND ISNULL(C.ATTRIBUTE1,'N') IN ('','N'))
								)
							
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



 ELSE IF @Code = 'LineProdPlanLinePopup'
	BEGIN
		IF @Param1 = 'EE'
			BEGIN
				SELECT
				DISTINCT
						A.LINE_ID						  AS CODE
					,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
				FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
				JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID
				INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1
								FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
								WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
								AND    b.valid_yn    = 'Y'
								AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
							) f ON a.operation_id = f.segment4 --AND c.operation_group_id = f.segment3 -- operation group id 에 추가된 operation 만보이도록
				--JOIN scp_mst_tact_time t WITH(NOLOCK) on t.division_id=@Param5 and t.plant_site_id=b.SCM_SITE_ID and t.item_id=@Param6 and t.operation_id=@Param4 and t.line_id=A.LINE_ID
				 JOIN ( SELECT DISTINCT X.DIVISION_ID, ITEM_ID , PLANT_ID , LINE_ID
								  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
								 WHERE X.DIVISION_ID  = @Param5
								   AND X.ITEM_ID = @Param6
								   AND X.OPERATION_ID = @Param4
								   AND X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
								   AND X.TACT_TIME > 0
								   ----- 계획 종료 구간 추가
								    AND MONTH <= (  SELECT p.horizon_end_date
													  FROM dbo.scm_mst_plan p WITH(NOLOCK)
													 WHERE ( @Param5='' or @Param5 is null or P.DIVISION_ID=@Param5)
													   AND p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK)
																			 WHERE ( @Param5='' or @Param5 is null or X.DIVISION_ID=@Param5)
																			   and plan_id < 9999)
													)

						) T
				  ON T.LINE_ID = A.LINE_ID
				 AND T.PLANT_ID = B.PLANT_ID
				WHERE 1=1
				AND A.ACTIVE_FLAG ='Y'
				AND A.DIVISION_ID  IN ('40','81','82')
				AND A.OPERATION_ID = @Param4
				AND (@Param2='' OR @Param2 IS NULL OR b.OPERATION_GROUP = @Param2 )
				AND b.SCM_SITE_ID = @Param3
				AND (@Param5='' OR @Param5 IS NULL OR A.DIVISION_ID=@Param5)
			END
		ELSE IF @Param1 = 'EE_UC'
			BEGIN
				SELECT
				DISTINCT
						A.LINE_ID						  AS CODE
					,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
				FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
				JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID
				INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1
								FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
								WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
								AND    b.valid_yn    = 'Y'
								AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
							) f ON a.operation_id = f.segment4 --AND c.operation_group_id = f.segment3 -- operation group id 에 추가된 operation 만보이도록
				--JOIN scp_mst_tact_time t WITH(NOLOCK) on t.division_id=@Param5 and t.plant_site_id=b.SCM_SITE_ID and t.item_id=@Param6 and t.operation_id=@Param4 and t.line_id=A.LINE_ID
				 JOIN ( SELECT DISTINCT X.DIVISION_ID, ITEM_ID , PLANT_ID , LINE_ID
								  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
								 WHERE X.DIVISION_ID  = @Param5
								   AND X.ITEM_ID = @Param6
								   AND X.OPERATION_ID = @Param4
								   AND X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
								   AND X.TACT_TIME > 0
								   ----- 계획 종료 구간 추가
								    AND MONTH <= (  SELECT p.horizon_end_date
													  FROM dbo.scm_mst_plan p WITH(NOLOCK)
													 WHERE ( @Param5='' or @Param5 is null or P.DIVISION_ID=@Param5)
													   AND p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK)
																			 WHERE ( @Param5='' or @Param5 is null or X.DIVISION_ID=@Param5)
																			   and plan_id < 9999)
													)

						) T
				  ON T.LINE_ID = A.LINE_ID
				 AND T.PLANT_ID = B.PLANT_ID
				WHERE 1=1
				AND A.ACTIVE_FLAG ='Y'
				AND A.DIVISION_ID  = '81_UC'
				AND A.OPERATION_ID = @Param4
				AND (@Param2='' OR @Param2 IS NULL OR b.OPERATION_GROUP = @Param2 )
				AND b.SCM_SITE_ID = @Param3
				AND (@Param5='' OR @Param5 IS NULL OR A.DIVISION_ID=@Param5)
			END
		ELSE
			BEGIN
				SELECT
				DISTINCT
						A.LINE_ID						  AS CODE
					,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
				FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
				JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND  A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID
				INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1
								FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
								WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
								AND    b.valid_yn    = 'Y'
								AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
							) f ON a.operation_id = f.segment4 --AND c.operation_group_id = f.segment3 -- operation group id 에 추가된 operation 만보이도록
				--JOIN scp_mst_tact_time t WITH(NOLOCK) on t.division_id=@Param1 and t.plant_site_id=b.SCM_SITE_ID and t.item_id=@Param6 and t.operation_id=@Param4 and t.line_id=A.LINE_ID
				 JOIN ( SELECT DISTINCT X.DIVISION_ID, ITEM_ID , PLANT_ID , LINE_ID
								  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
								 WHERE X.DIVISION_ID  = @Param1
								   AND X.ITEM_ID = @Param6
								   AND X.OPERATION_ID = @Param4
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
						) T
				  ON T.LINE_ID = A.LINE_ID
				 AND T.PLANT_ID = B.PLANT_ID
				WHERE 1=1
				AND A.ACTIVE_FLAG ='Y'
				AND A.DIVISION_ID  = @Param1
				AND A.OPERATION_ID = @Param4
				AND (@Param2='' OR @Param2 IS NULL OR b.OPERATION_GROUP = @Param2)
				AND b.SCM_SITE_ID = @Param3
				--ESS 외주 Pakcer Line 생산 Target 적용
				UNION
				SELECT
				DISTINCT
					A.LINE_ID						  AS CODE
					,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
				FROM SCM_MST_LINE_OSP A WITH(NOLOCK)
				JOIN SCM_MST_SITE S WITH(NOLOCK) ON S.DIVISION_ID=A.DIVISION_ID
												 AND S.SCM_SITE_ID=A.SCM_SITE_ID
												 AND S.OSP_YN='Y'
												 AND ISNULL(S.ATTRIBUTE1,'N')='Y'
				JOIN SCP_MST_TACT_TIME_OSP B WITH(NOLOCK) ON A.DIVISION_ID=B.DIVISION_ID
														  AND A.SCM_SITE_ID=B.PLANT_SITE_ID
														  AND B.ITEM_ID=@Param6
														  AND B.VALID_YN='Y'
														  AND A.LINE_ID=B.LINE_ID
				WHERE A.DIVISION_ID=@Param1
				AND A.SCM_SITE_ID=@Param3
				AND A.VALID_YN='Y'
				UNION
				SELECT '-' AS CODE, '-' AS NAME
				FROM SCM_MST_SITE S WITH(NOLOCK)
				WHERE S.DIVISION_ID=@Param1
				AND S.SCM_SITE_ID=@Param3
				AND S.VALID_YN='Y'
				AND S.OSP_YN='Y'
				AND ISNULL(S.ATTRIBUTE1,'N') IN ('','N')

			   -- 2022.07.22 Begin
			   UNION
			   
			   SELECT
				DISTINCT
						A.LINE_ID						  AS CODE
					,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
				FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
				JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND  A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID
				
				 JOIN ( SELECT DISTINCT X.DIVISION_ID, X.ITEM_ID , X.PLANT_ID , X.LINE_ID
								  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
								  JOIN dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
									ON X.ITEM_ID = A.ITEM_ID
								   AND X.DIVISION_ID = A.DIVISION_ID
								 WHERE X.DIVISION_ID  = @Param1
								   AND X.ITEM_ID = @Param6
								   AND X.OPERATION_ID = @Param4
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
						) T
				  ON T.LINE_ID = A.LINE_ID
				 AND T.PLANT_ID = B.PLANT_ID
				WHERE 1=1
				AND A.ACTIVE_FLAG ='Y'
				AND A.DIVISION_ID  = @Param1
				AND A.OPERATION_ID = @Param4
				AND (@Param2='' OR @Param2 IS NULL OR b.OPERATION_GROUP = @Param2)
				AND b.SCM_SITE_ID = @Param3

				-- 2022.07.22 End

			END
	END

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

 ELSE IF (@Code = 'LineProdPlanLine' )
	 BEGIN
		SELECT DISTINCT
				  A.LINE_ID AS CODE
				, A.LINE_ID + '   ' + A.LINE_NAME AS NAME
		FROM	SCM_MST_LINE_SN A WITH (NOLOCK)
				JOIN
					(
						SELECT	  SEGMENT2 OPERATION_GROUP
								, SEGMENT3 SCM_SITE_ID
								, SEGMENT4 LINE_ID
								, SEGMENT5 OPERATION_ID
								, ATTRIBUTE1 ORIGIN_DIVISION_ID
						FROM	SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
						WHERE	LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
							AND SEGMENT1 = 'SCP'
							AND VALID_YN = 'Y'
							AND ATTRIBUTE2 = @Param1
					) C ON
						((@Param2 IS NULL OR @Param2 = '') OR C.OPERATION_GROUP IN (SELECT token FROM dbo.String_Split(@Param2, ',')))
					AND ((@Param3 IS NULL OR @Param3 ='') OR C.SCM_SITE_ID IN (SELECT token FROM dbo.String_Split(@Param3, ',')))
		WHERE	1=1
			AND A.ACTIVE_FLAG   ='Y'
			AND A.DIVISION_ID   = C.ORIGIN_DIVISION_ID
			AND A.LINE_ID       = C.LINE_ID
			AND A.OPERATION_ID  = C.OPERATION_ID
		UNION ALL
		SELECT	  '-'  AS CODE
				, '-'  AS NAME
		ORDER BY	NAME

 END

 ELSE IF @Code = 'LineByOperationAddOSP'
	BEGIN
		SELECT
				DISTINCT
				A.LINE_ID						  AS CODE
			, A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
			, A.OPERATION_ID
			, B.SCM_SITE_ID
			FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
			JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND  A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID
		INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1
						FROM scm_adm_lookup_master_detail b WITH(NOLOCK)
						WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
						AND    b.valid_yn    = 'Y'
						AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
					) f ON a.operation_id = f.segment4 --AND c.operation_group_id = f.segment3 -- operation group id 에 추가된 operation 만보이도록
			WHERE 1=1
			AND A.ACTIVE_FLAG ='Y'
			AND ( (@Param1 IS NULL OR @Param1 ='') OR A.DIVISION_ID IN  ( SELECT token FROM dbo.String_Split(@Param1,',')))
			AND ( (@Param2 IS NULL OR @Param2 ='') OR A.PLANT_ID IN     ( SELECT token FROM dbo.String_Split(SUBSTRING(@Param2,1,4),',')))
			AND ( (@Param3 IS NULL OR @Param3 ='') OR A.FACTORY_ID IN   ( SELECT token FROM dbo.String_Split(@Param3,',')))
			AND ( (@Param4 IS NULL OR @Param4 ='') OR A.OPERATION_ID IN ( SELECT token FROM dbo.String_Split(@Param4,',')))
			AND ( (@Param5 IS NULL OR @Param5 ='') OR B.SCM_SITE_ID IN  ( SELECT token FROM dbo.String_Split(@Param5,',')))
		UNION
		SELECT
				'-'  AS CODE
				, '-'  AS NAME
				, '-'  AS OPERATION_ID
				, '-'  AS SCM_SITE_ID
		UNION
		-- 외주
		SELECT
				DISTINCT
				A.LINE_ID						AS CODE
			, A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
			, A.OPERATION_ID
			, B.SCM_SITE_ID
			FROM [dbo].SCM_MST_LINE_OSP A WITH(NOLOCK)
			JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
		WHERE b.ATTRIBUTE1 = 'Y'
			AND ( (@Param1 IS NULL OR @Param1 ='') OR A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,',')))
			AND ( (@Param2 IS NULL OR @Param2 ='') OR B.PLANT_ID     IN ( SELECT token FROM dbo.String_Split(SUBSTRING(@Param2,1,4),',')))
			AND ( (@Param4 IS NULL OR @Param4 ='') OR A.OPERATION_ID IN ( SELECT token FROM dbo.String_Split(@Param4,',')))
			AND ( (@Param5 IS NULL OR @Param5 ='') OR B.SCM_SITE_ID  IN ( SELECT token FROM dbo.String_Split(@Param5,',')))
		
		-- 2022/08/31 start
		--ORDER BY NAME		
		UNION
		--Isuzu : P5000
		SELECT
				  DISTINCT
				  A.LINE_ID						  AS CODE
				, A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
				, A.OPERATION_ID
				, B.SCM_SITE_ID
			FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
			JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND  A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID

			WHERE 1=1
			AND A.ACTIVE_FLAG ='Y'
			AND ( (@Param1 IS NULL OR @Param1 ='') OR A.DIVISION_ID IN  ( SELECT token FROM dbo.String_Split(@Param1,',')))
			AND ( (@Param2 IS NULL OR @Param2 ='') OR A.PLANT_ID IN     ( SELECT token FROM dbo.String_Split(SUBSTRING(@Param2,1,4),',')))
			AND ( (@Param3 IS NULL OR @Param3 ='') OR A.FACTORY_ID IN   ( SELECT token FROM dbo.String_Split(@Param3,',')))
			AND ( (@Param4 IS NULL OR @Param4 ='') OR A.OPERATION_ID IN ( SELECT token FROM dbo.String_Split(@Param4,',')))
			AND ( (@Param5 IS NULL OR @Param5 ='') OR B.SCM_SITE_ID IN  ( SELECT token FROM dbo.String_Split(@Param5,',')))
			AND A.PLANT_ID = @v_PLANT_NJ
			and A.OPERATION_ID = 'P5000'

		ORDER BY NAME
		-- 2022/08/31 end

	END;



RETURN;

 --------------
END

