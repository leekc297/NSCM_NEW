/****************************************************************************************************/
/* Program ID  : DMF0004_GET_SOLDTO_CUSTOMER_DATA                                                 */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/07/23  JYE           Soldto Customer                                             */
/* 2022/03/28	rosia27		 [과제PJ20216891R]GM_JV													*/
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0004_GET_SOLDTO_CUSTOMER_DATA]  
  @p_division_id  NVARCHAR(50),
  @p_dept_id   NVARCHAR(MAX)
AS
BEGIN
	
  SET NOCOUNT ON;
  
	IF (@p_division_id = '40')
	BEGIN
		SELECT --SITE.SCM_SITE_ID, 
			SITE.SOLDTO_CUSTOMER AS CODE
			, SITE.SOLDTO_CUSTOMER AS NAME
			--, STEAM.DEPT_ID
			--, SITE.END_CUSTOMER
		FROM SCM_MST_SITE AS SITE
		INNER JOIN (
			SELECT SI.DIVISION_ID
				,SI.SCM_SITE_ID 
				,SI.ITEM_ID
				,SU.DEPT_ID
			FROM SCM_MST_SITE_ITEM SI WITH(NOLOCK)
				,[SCM_MST_SSO_USER_INFO] SU WITH(NOLOCK)
				,[SCM_MST_SSO_DEPT_INFO] TM
			WHERE SI.DIVISION_ID = @p_division_id
			AND SI.OWNER = SU.USER_ID
			AND SU.DEPT_ID = TM.DEPT_ID
		) AS STEAM
		ON SITE.SCM_SITE_ID = STEAM.SCM_SITE_ID 
		WHERE SITE.DIVISION_ID = @p_division_id
			AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
					ELSE STEAM.DEPT_ID			
				END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
						(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE STEAM.DEPT_ID END) = P.data
					)
		GROUP BY SITE.SOLDTO_CUSTOMER
		ORDER BY SITE.SOLDTO_CUSTOMER
	END
	ELSE
	BEGIN
		SELECT 
			SOLDTO_CUSTOMER AS CODE
			, SOLDTO_CUSTOMER AS NAME
			--, SITE.DEPT_ID
		FROM [SCM_MST_SITE] AS SITE --94
		INNER JOIN [SCM_MST_SSO_DEPT_INFO] AS DEPT_INFO
		ON SITE.DEPT_ID = DEPT_INFO.DEPT_ID
		WHERE DIVISION_ID = @p_division_id
			AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
					ELSE DEPT_INFO.DEPT_ID			
				END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
						(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE DEPT_INFO.DEPT_ID END) = P.data
					)
			AND SOLDTO_CUSTOMER IS NOT NULL
		GROUP BY SOLDTO_CUSTOMER
	END

END
