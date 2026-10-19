
/*
 * Program ID   : UP_FX_GetNewUserAuthRequestList
 * Description  : 신규사용자 권한요청
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.26   KYH			   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.05   ygkim          @AuthType = 'P' 일 경우 쿼리 수정
 */

CREATE PROCEDURE [dbo].[UP_FX_GetNewUserAuthRequestList]
	@GroupID		NVARCHAR(20)
	, @UserID		NVARCHAR(20)
	, @AuthType		CHAR(1)	
	, @DivisionID		NVARCHAR(20)

AS
BEGIN
	IF @AuthType = 'D'
	BEGIN
	    
		SELECT distinct
			-- DIVISION_ID AS CODE, MIN([DIVISION_NAME]) AS NAME 
			DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME 
		FROM
			SCM_MST_DIVISION
		--WHERE 
		--	DIVISION_ID = @DivisionID
		GROUP BY 
			DIVISION_ID 
		ORDER BY DIVISION_ID 
	END

	IF @AuthType = 'P'
	BEGIN
		--SELECT distinct
		--	S.Code AS CODE
		--		,(CASE WHEN A.PLANT_NAME IS NULL THEN V.VENDOR_NAME
		--						ELSE A.PLANT_NAME END ) AS NAME
		--FROM SCM_MST_SITE S
		--LEFT OUTER JOIN  SCM_MST_PLANT_SN A ON A.PLANT_ID = S.Code
		--LEFT OUTER JOIN  SCM_MST_VENDOR V ON V.VENDOR_CODE = S.Code
		--WHERE PrntCode = @DivisionID
		--	and A.PLANT_NAME is not null
		--ORDER BY S.Code
		/*
		SELECT 
			 s.plant_id AS CODE
			,s.site_description AS NAME
		FROM SCM_MST_SITE S
		WHERE s.division_id = @DivisionID
		AND s.site_type ='PLANT'
		AND s.valid_yn ='Y'
		ORDER BY s.site_description
		*/

		SELECT distinct S.PLANT_ID      AS CODE
			, MAX((CASE 
				WHEN A.PLANT_NAME IS NULL 
					THEN V.VENDOR_NAME
				ELSE A.PLANT_NAME
				END ))		   AS NAME
		FROM  SCM_MST_SITE S
		LEFT OUTER JOIN  SCM_MST_PLANT_SN A ON A.DIVISION_ID = S.DIVISION_ID AND A.PLANT_ID = S.PLANT_ID -- AND s.operation_group = A.shop_group_id
		LEFT OUTER JOIN  SCM_MST_VENDOR V ON V.VENDOR_CODE = S.PLANT_ID
		WHERE S.DIVISION_ID = @DivisionID 
				AND s.site_type ='PLANT'
				AND  S.VALID_YN ='Y'
		GROUP BY S.PLANT_ID
		ORDER BY S.PLANT_ID
	END

	IF @AuthType = 'C'
	BEGIN
		SELECT distinct
			END_CUSTOMER AS CODE , END_CUSTOMER AS NAME
		FROM SCM_MST_SITE (nolock) a
		WHERE 
				a.DIVISION_ID = @DivisionID
			and end_customer is not null
			--AND SOLDTO_CODE IN (
			--	SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
			--	WHERE PrntCode = @DivisionID and SOLDTO_DESCRIPTION is not null
			--)

		ORDER BY END_CUSTOMER ASC
	END

END
