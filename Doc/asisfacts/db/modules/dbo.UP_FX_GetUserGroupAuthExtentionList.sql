
/*
 * Program ID   : UP_FX_GetUserGroupAuthExtentionList
 * Description  : 시스템관리 - 그룹-사용자 목록
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/11/22   SJSHIN         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/10	ygkim		   AutyType = 'P' 일 경우 Name 중복 제거	
 */
 
CREATE PROCEDURE [dbo].[UP_FX_GetUserGroupAuthExtentionList]
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
					SCM_MST_DIVISION A
					INNER JOIN TB_FX_UserGroupAuthExtention B ON A.DIVISION_ID = B.Code AND B.AuthType = 'D'
				WHERE B.GroupID = @GroupID
					AND B.UserID = @UserID
				GROUP BY 
					DIVISION_ID 
				ORDER BY DIVISION_ID

			END

		IF @AuthType = 'P'
			BEGIN
				--SELECT
				--	PLANT_ID AS CODE, PLANT_NAME AS NAME FROM SCM_MST_PLANT_SN 
				--WHERE 
				--	DIVISION_ID = @DivisionID
				--	AND
				--	PLANT_ID IN
				--	(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE PrntCode = @DivisionID AND GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthType)
				--ORDER BY PLANT_ID
				SELECT S.Code AS CODE
					 ,MAX((CASE WHEN A.PLANT_NAME IS NULL THEN V.VENDOR_NAME
									   ELSE A.PLANT_NAME END )) AS NAME
				FROM TB_FX_UserGroupAuthExtention S
				LEFT OUTER JOIN  SCM_MST_PLANT_SN A ON A.PLANT_ID = S.Code
				LEFT OUTER JOIN  SCM_MST_VENDOR V ON V.VENDOR_CODE = S.Code
				WHERE PrntCode = @DivisionID AND GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthType
				GROUP BY S.Code
				ORDER BY S.Code
			END

		IF @AuthType = 'C'
			BEGIN

			---해당 권한 조건 미사용으로 모든 고객이 다 조회 되도록 쿼리 변경 --2018-03-19 진준희
			SELECT DISTINCT 
					END_CUSTOMER AS CODE, END_CUSTOMER AS NAME FROM SCM_MST_SITE
				WHERE 
					DIVISION_ID = @DivisionID
					/*AND
					SOLDTO_CODE IN
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE PrntCode = @DivisionID AND GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthType)
					AND SOLDTO_CODE IS NOT NULL
				ORDER BY SOLDTO_CODE
			*/
			/*
				SELECT
					SOLDTO_CODE AS CODE, SOLDTO_DESCRIPTION AS NAME FROM SCM_MST_CUSTOMER
				WHERE 
					DIVISION_ID = @DivisionID
					AND
					SOLDTO_CODE IN
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE PrntCode = @DivisionID AND GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthType)
				ORDER BY SOLDTO_CODE

			*/

			END

		/*
			김승일 21.06.16  JV용 AuthType J 추가
		*/
		IF @AuthType = 'J'
			BEGIN
				SELECT distinct
					-- DIVISION_ID AS CODE, MIN([DIVISION_NAME]) AS NAME 
					DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME,
					JV_PLANT_ID AS JV_Plant_ID
				FROM
					SCM_MST_DIVISION A
					INNER JOIN TB_FX_UserGroupAuthExtention B ON A.DIVISION_ID = B.Code AND B.AuthType = 'J'
				WHERE B.GroupID = @GroupID
					AND B.UserID = @UserID
				GROUP BY 
					DIVISION_ID , JV_PLANT_ID
				ORDER BY DIVISION_ID

			END

END



