



/*
 * Program ID   : SSP0200_GET_SHIPMENT_PLAN_TO_SITE
 * Description  : SITE 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *=================================================================================================== 
 * 2022/04/18   SMS             MyDivisionOut40, SSPToSiteByDivision, ShipmentPlanToSite 가상디비젼 적용
 * 2026/02/20   강주용			E20260206-001938 - SSP 시스템의 JV법인 ESS 출하계획 전송을 위한 JV법인 ESS 권한 개선 건
 *								UP_FX_GetCommonDataList_SCP 에서 이관
 */

CREATE PROCEDURE [dbo].[SSP0200_GET_SHIPMENT_PLAN_TO_SITE]   
 @Param1 NVARCHAR(100) -- DIVISION_ID
,@Param2 NVARCHAR(100) -- NOW_GROUP_ID
,@Param3 NVARCHAR(100) -- USER_ID
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @exception_company TABLE ( company_id nvarchar(100) );--[NERP]COMPANY 예외적용--NERP (IT20250117A)

	BEGIN
		-- START E20260206-001938 - SSP 시스템의 JV법인 ESS 출하계획 전송을 위한 JV법인 ESS 권한 개선 건
		-- 20220418	SMS	가상디비젼 권한 체크 추가
		--Declare @AuthTypeShipmentPlanToSite varchar(100) = 'D'		   
		--if(@Param2 = 'JV Planner') SET @AuthTypeShipmentPlanToSite = 'J';
		-- END E20260206-001938 - SSP 시스템의 JV법인 ESS 출하계획 전송을 위한 JV법인 ESS 권한 개선 건
		--[NERP]COMPANY 예외적용 시작--NERP (IT20250117A)
		INSERT INTO @exception_company (company_id) select SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock) 
			WHERE 1=1
			AND LOOKUP_TYPE = 'SSP_UI_EXCEPT_COMPANY' and VALID_YN='Y'
		--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		SELECT distinct CODE
			   ,NAME
			   ,COMPANY_ID--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		FROM(
			SELECT	 SCM_SITE_ID			AS	CODE
					,SITE_DESCRIPTION			AS	NAME
					,COMPANY_ID--[NERP]COMPANY 예외적용--NERP (IT20250117A)
			FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
			WHERE   A.VALID_YN  = 'Y'
			AND	A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,','))
			-- START E20260206-001938 - SSP 시스템의 JV법인 ESS 출하계획 전송을 위한 JV법인 ESS 권한 개선 건
			--AND    A.DIVISION_ID IN (SELECT CODE
			--							FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
			--		    				WHERE  GroupID LIKE '%'+ @Param2 + '%'
			--							AND    UserID  LIKE '%'+ @Param3 + '%'
			--							AND    AuthType = @AuthTypeShipmentPlanToSite
			--							)
			-- END E20260206-001938 - SSP 시스템의 JV법인 ESS 출하계획 전송을 위한 JV법인 ESS 권한 개선 건
			OR     A.DIVISION_ID like (case when @Param1 = '81' THEN '81_%' END)
			union all
			SELECT distinct SEGMENT2 CODE
				  ,ISNULL(b.SITE_DESCRIPTION, a.SEGMENT2) NAME
				  ,B.COMPANY_ID --[NERP]COMPANY 예외적용--NERP (IT20250117A)
			FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] a WITH(NOLOCK)
			LEFT OUTER JOIN SCM_MST_SITE b WITH(NOLOCK) on b.SCM_SITE_ID = a.SEGMENT2
			WHERE LOOKUP_TYPE = 'EE_SHIPMENT_PLAN'
			  AND a.VALID_YN = 'Y'
			  AND A.SEGMENT2 != '-'
		) a
		WHERE not exists (select 1 from @exception_company K where a.COMPANY_ID = K.company_id)--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		ORDER BY CODE;
	END

END
