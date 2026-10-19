

/*
 * Program ID   : SCP0041_GET_STOCK_OSP
 * Description  : STOCK OSP 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/12/27   hwyoon			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019/07/19	hwyoon			[CSR ID:4043239] Stock OSP 자체개선 - 조회조건(날짜) 추가
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 2024/06/05   mrchois			PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - Valuation Type 컬럼추가
 * 2024/08/21   mrchois			PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - Cell From Site 컬럼추가
 * 2024/10/21   mrchois			PJ20248928 LGES 재료비 Task SCP 소형사업부 확산 및 고도화 - Box 컬럼추가
 * 
 */

CREATE PROCEDURE [dbo].[SCP0041_GET_STOCK_OSP]
--chaan	@p_division_id          NVARCHAR(2)
   @p_division_id        NVARCHAR(30)--chaan
  ,@p_plant_site_id		 NVARCHAR(MAX)
  ,@p_item_id            NVARCHAR(MAX)
  ,@p_from_yyyymmdd      NVARCHAR(MAX)
  ,@p_to_yyyymmdd		 NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT A.DIVISION_ID
		, A.SCM_SITE_ID
		, B.SITE_DESCRIPTION
		, A.ITEM_ID
		, dbo.fn_get_item_nickname (a.division_id, a.item_id ) AS nick_name
		, SUBSTRING(A.YYYYMMDD,1,4)+'-'+SUBSTRING(A.YYYYMMDD,5,2)+'-'+SUBSTRING(A.YYYYMMDD,7,2) YYYYMMDD
		, A.ATTRIBUTE1	--Valuation Type 컬럼추가
		, A.QTY
		, A.ATTRIBUTE2	--Cell From Site 컬럼추가
		, A.COMMENT
		, A.ATTRIBUTE3	--Box 컬럼추가
		, A.CREATED_BY
		, A.CREATION_DATE
		, A.LAST_UPDATED_BY
		, A.LAST_UPDATE_DATE
	FROM SCM_DNM_STOCK_OSP A WITH(NOLOCK)
	JOIN SCM_MST_SITE B ON B.DIVISION_ID=A.DIVISION_ID AND B.SCM_SITE_ID=A.SCM_SITE_ID
	WHERE A.division_id				   =    @p_division_id
		AND (isnull(@p_plant_site_id, '' ) = '' OR A.scm_site_id   IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id	 ,',')) )
		AND (isnull(@p_item_id,       '' ) = '' OR A.item_ID       IN ( SELECT token FROM dbo.String_Split(@p_item_id	 ,',')) )
		AND A.YYYYMMDD >= @p_from_yyyymmdd
		AND A.YYYYMMDD <= @p_to_yyyymmdd
	ORDER BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID;

END

