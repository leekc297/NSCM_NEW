

/*
 * Program ID   : SCP0049_GET_NEW_VERSION_INFO
 * Description  : Master Data Management Version 정보 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/08/26   khj79          [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성
 * 2020/10/12   khj79          [PJ20199555] BP,RP,SCP OR 조건 검색 수정
 * 2020/11/18   khj79          [PJ20199555] INSERT_TIME 조건 from - to 로 변경
 * 2021/01/22   khj79          [PJ20199555] DIVISION 별 VER 생성 - DIVISION_ID 추가
 */

 
CREATE PROCEDURE [dbo].[SCP0049_GET_NEW_VERSION_INFO]
	 @p_from_date		NVARCHAR(8)
	,@p_to_date			NVARCHAR(8)
	,@p_version_name	NVARCHAR(MAX)
	,@p_chk_bp			CHAR(1)
	,@p_chk_rp			CHAR(1)
	,@p_chk_scp			CHAR(1)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	 declare @v_chk_all_none char(1) = 'N'

	 IF @p_chk_bp = '' AND @p_chk_rp = '' AND @p_chk_scp = ''
	 BEGIN
		SET @v_chk_all_none = 'Y'
	 END
	
	SELECT A.VERSION_ID
		 , '(W)' + SUBSTRING(A.VERSION_ID,5,2)	AS VERSION_WEEK
		 , A.DIVISION_ID						AS DIVISION_ID
	     , CONVERT(CHAR(10), A.INSERT_TIME, 23)	AS VERSION_DATE
		 , CONVERT(CHAR(5) , A.INSERT_TIME, 8)	AS VERSION_TIME
		 , A.VERSION_NAME
		 , CASE WHEN A.BP_USE_FLAG = 'Y' THEN 'True' else 'False' END AS BP_USE_FLAG
		 , CASE WHEN A.RP_USE_FLAG = 'Y' THEN 'True' else 'False' END AS RP_USE_FLAG
		 , CASE WHEN A.SCP_USE_FLAG = 'Y' THEN 'True' else 'False' END AS SCP_USE_FLAG
		 , C.DEPT_NAME_KO + ' ' + C.USER_NAME	AS CONFIRMED_BY
		 FROM SCM_MASTER_VERSION_INFO_H_SN A

		LEFT JOIN (SELECT A.USER_NAME, A.USER_ID, A.DEPT_ID, B.DEPT_NAME_KO, B.DEPT_NAME_EN, B.DEPT_NAME_CN
				   FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK)
					  , SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK)
				  WHERE 1=1
					AND A.DEPT_ID = B.DEPT_ID
				) C
	    ON 1 = 1
	   AND A.INSERT_ID = C.USER_ID

	WHERE ((@p_version_name  IS NULL OR @p_version_name  ='') OR (A.VERSION_NAME LIKE '%' + @p_version_name + '%'))
	   AND (@v_chk_all_none = 'Y' OR ( A.BP_USE_FLAG  = @p_chk_bp
	    or A.RP_USE_FLAG  = @p_chk_rp
	    or  A.SCP_USE_FLAG = @p_chk_scp ))
	   AND CONVERT(NVARCHAR(8),A.INSERT_TIME,112) >= @p_from_date
	   AND CONVERT(NVARCHAR(8),A.INSERT_TIME,112) <= @p_to_date
	 ORDER BY VERSION_ID ASC

END

