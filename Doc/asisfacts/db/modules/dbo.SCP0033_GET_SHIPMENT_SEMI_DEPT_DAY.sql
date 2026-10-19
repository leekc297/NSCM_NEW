



/*
 * Program ID   : SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY
 * Description  : Shipment Semi Dept Day 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/10/04   yhw				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/10/11   yhw				nick_name 항목 추가
 * 2022.05.13   LSC             PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
 * 2023/04/10   LWY				PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 */
CREATE PROCEDURE [dbo].[SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY]
  @p_division_id    NVARCHAR(MAX),
  @p_item_id		NVARCHAR(MAX),
  @p_valid			NVARCHAR(MAX)
AS  
  
BEGIN
  SET NOCOUNT ON; 
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

	SELECT	A.DIVISION_ID
			--, CASE WHEN A.DIVISION_ID IN ('EE','EE_UC') THEN 'E' 
			, CASE WHEN A.DIVISION_ID IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) THEN 'E' --div_commonization
				ELSE (SELECT TOP 1 ISNULL(B.SCP_OPERATION_GROUP,'') FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID=A.DIVISION_ID AND B.ITEM_ID=A.ITEM_ID) 
			  END OPERATION_GROUP
			, ITEM_ID
			, (SELECT TOP 1 isnull(NULLIF(NICK_NAME,''),'-') FROM DBO.SCM_MST_ITEM_SN x WITH(NOLOCK) WHERE 1=1 AND x.ITEM_ID = a.item_id) NICK_NAME
			, DEPARTURE_DAY
			, VALID_YN
			, VALID_YN AS S_VALUE_YN
			, CREATED_BY
			, CREATION_DATE
			, LAST_UPDATED_BY
			, LAST_UPDATE_DATE
	FROM SCP_MST_SHIPMENT_SEMI_DEPT_DAY A WITH(NOLOCK)
	WHERE 1=1
	  AND ( ( @p_division_id	IS NULL OR  @p_division_id = ''	) OR A.division_id IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
	  AND ( ( @p_item_id		IS NULL OR  @p_item_id = ''		) OR A.ITEM_ID  LIKE  @p_item_id + '%' )
	  AND ( ( @p_valid			IS NULL OR  @p_valid = ''		) OR A.VALID_YN = @p_valid)
	ORDER BY A.DIVISION_ID, A.ITEM_ID
	;

	--validation용 전체조회
	SELECT DIVISION_ID, ITEM_ID
	FROM SCP_MST_SHIPMENT_SEMI_DEPT_DAY
	;

END

  
