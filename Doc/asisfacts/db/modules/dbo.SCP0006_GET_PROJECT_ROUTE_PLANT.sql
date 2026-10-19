/*
 * Program ID   : SCP0006_GET_PROJECT_ROUTE_PLANT
 * Description  : Project Route Plant Site 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge       Description
 *===================================================================================================
 * 2017/12/28   byunghunjung            Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/09   PJS                     입력, 수정 이력 컬럼 조회 추가
 * 2018/08/16   YHW                     VALIDATION용 ERP ITEM 조회
 * 2021/09/15   KMJ                     [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - PLANT_ID, OPERATION_ID 추가
 * 2023/06/07   chaan			V1.1.1  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 활성화 코드 분리
 * 2023/06/30   chaan			V1.1.2  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Plant Assign 목록조회시 Warranty 제외
 *
*/
CREATE PROCEDURE [dbo].[SCP0006_GET_PROJECT_ROUTE_PLANT]
  @p_division_id    NVARCHAR(200),
  @p_scm_site_id    NVARCHAR(200),
  @p_project_code   NVARCHAR(200),
  @p_item_id        NVARCHAR(200)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	--DECLARE @p_division_id    NVARCHAR(200)		= '82';
	--DECLARE @p_scm_site_id    NVARCHAR(200)		= '-';
	--DECLARE @p_project_code   NVARCHAR(200)		= '- ';
	--DECLARE @p_item_id        NVARCHAR(200)		= 'EM104063P3B1';



	SELECT	  T.PRIORITY_SEQ
			, T.DIVISION_ID
			, T.PROJECT_CODE
			, T.ITEM_ID
			, T.SALES_SITE_ID                                                   AS SCM_SITE_ID
			, T.PLANT_SITE_ID
			, T.PRIORITY
			, T.VALID_YN
			, CONVERT(NVARCHAR(10),DBO.FN_CHAR_TO_DATE(T.FROM_YYYYMMDD),121)    AS FROM_YYYYMMDD
			, CONVERT(NVARCHAR(10),DBO.FN_CHAR_TO_DATE(T.TO_YYYYMMDD)  ,121)    AS TO_YYYYMMDD
			, T.CREATED_BY
			, T.CREATION_DATE
			, T.LAST_UPDATED_BY
			, T.LAST_UPDATE_DATE
			, T.FROM_YYYYMMDD                                                   AS ORG_FROM_YYYYMMDD
			, T.TO_YYYYMMDD                                                     AS ORG_TO_YYYYMMDD
			, T.FROM_YYYYMMDD + T.TO_YYYYMMDD                                   AS MERGE_DATE
			, ''                                                                AS IS_PASS_N1
			, ''                                                                AS IS_PASS_N2
			, ''                                                                AS IS_PASS_N3
			, ''                                                                AS IS_PASS_N4
			, ''                                                                AS IS_PASS_N5
			, ''                                                                AS IS_PASS_N6
			, ''                                                                AS IS_PASS_N7
			, S.PLANT_ID
			, C.OPERATION_ID
			, C.OPERATION_GROUP_ID
	FROM	SCM_MST_SITE_ITEM_PRIORITY T (NOLOCK)
			JOIN ( 
                    SELECT  *
                    FROM    SCM_MST_SITE (NOLOCK)
                    WHERE   1=1
                        AND OPERATION_GROUP <> 'W'
                  ) S ON 
					T.DIVISION_ID	= S.DIVISION_ID 
				AND T.PLANT_SITE_ID = S.SCM_SITE_ID
			LEFT JOIN (
						SELECT DISTINCT
								  A.COMPANY_ID
								, A.DIVISION_ID
								, A.SITE_ID
								, A.FLOW_ID AS OPERATION_ID
								, B.OPERATION_GROUP_ID
						FROM	SCM_MST_ITEM_SN A WITH(NOLOCK)
								JOIN (
										SELECT DISTINCT
												  COMPANY_ID
												, DIVISION_ID
												, SITE_ID
												, OPERATION_ID
												, OPERATION_GROUP_ID
										FROM	SCM_LINE_HIERARCHY_V_SN B WITH(NOLOCK)
									 ) B ON 
									A.COMPANY_ID		= B.COMPANY_ID
								AND A.DIVISION_ID		= B.DIVISION_ID
								AND A.SITE_ID			= B.SITE_ID
								AND LEFT(A.FLOW_ID,5)	= B.OPERATION_ID
						WHERE	A.DIVISION_ID	= @p_division_id
							AND A.FLOW_ID IS NOT NULL
							AND A.ACTIVE_FLAG	= 'Y'
							AND A.ITEM_ID		= @p_item_id
					   ) C ON 
					S.COMPANY_ID	= C.COMPANY_ID
				AND S.DIVISION_ID	= C.DIVISION_ID
				AND S.SITE_ID		= C.SITE_ID
	WHERE	S.SITE_TYPE     = 'PLANT'
		AND T.DIVISION_ID   = @p_division_id
		AND T.SALES_SITE_ID = @p_scm_site_id
		AND T.PROJECT_CODE  = @p_project_code
		AND T.ITEM_ID       = @p_item_id
	ORDER BY T.ITEM_ID, T.FROM_YYYYMMDD, T.PRIORITY, T.VALID_YN DESC, T.TO_YYYYMMDD


	SELECT	  COMPANY_ID
			, DIVISION_ID
			, ITEM_ID
			, SITE_ID
	FROM	SCM_MST_ITEM_SN WITH(NOLOCK)
	WHERE	ITEM_ID LIKE SUBSTRING(@p_item_id,1,len(@p_item_id)-1)+'%'
		AND DIVISION_ID = '40'
		AND ACTIVE_FLAG = 'Y'
END
