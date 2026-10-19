
/*
 * Program ID   : SCP0013_GET_PLAN_TYPE_SAVE_YN
 * Description  : PLAN 별 저장가능 여부 정보 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/10/15   YHW				Initial Release  전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/10/31	YHW				ORDER BY 조건 수정
 * 2019/01/18	YHW				상위 플랜 갯수와 상관없이 최상위 플랜이 -1이면 수정 가능
 * 2019/07/24	YHW				최종 FN플랜 수정불가
 * 2019/07/29	YHW				[CSR ID:4043582] GSCM - Shipment Plan FG / SEMI "New" 버튼 생성 요청 건
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장

  EXEC SCP0013_GET_PLAN_TYPE_SAVE_YN @p_division_id='81', @p_start_yyyymmdd='20181008', @p_plan_type='PR'
 */

CREATE PROCEDURE [dbo].[SCP0013_GET_PLAN_TYPE_SAVE_YN]
--chaan	 @p_division_id		NVARCHAR(2)
	   @p_division_id		NVARCHAR(30) --chaan
    ,  @p_start_yyyymmdd	NVARCHAR(8)
	,  @p_plan_type		NVARCHAR(2)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	DECLARE @v_edit_yn	NVARCHAR(1)	= NULL;


	SET @v_edit_yn	= ISNULL(NULLIF((
						SELECT TOP(1)
								--  D.DIVISION_ID
								--, P.PLAN_NAME+'-'+D.PLAN_TYPE+'-'+ DBO.FN_ZERO_LPAD(CONVERT(NVARCHAR,D.PLAN_SEQ),2) AS PLAN_VERSION_ID
								--, P.PLAN_NAME
								--, D.PLAN_TYPE
								--, C.DISPLAY_SEQ
								--, C_SUB.DISPLAY_SEQ AS SUB_DISPLAY_SEQ
									--, D.PLAN_STATUS
								CASE 
									WHEN C.DISPLAY_SEQ =  C_SUB.DISPLAY_SEQ      AND @p_plan_type  = 'FN'  THEN 'N'
									WHEN C.DISPLAY_SEQ =  C_SUB.DISPLAY_SEQ      AND @p_plan_type  != 'FN' THEN 'Y'
									WHEN C.DISPLAY_SEQ >= C_SUB.DISPLAY_SEQ + 10 AND D.PLAN_STATUS =  -1   THEN 'Y'
									ELSE 'N' 
								END AS SAVE_YN
						FROM	SCM_MST_MODELING M WITH(NOLOCK),
								SCM_MST_PLAN_DETAIL D WITH(NOLOCK),
								SCM_MST_PLAN P WITH(NOLOCK),
								SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK),
								SCM_ADM_LOOKUP_MASTER_DETAIL C_SUB WITH(NOLOCK)
						WHERE	1=1
							AND M.PLAN_CYCLE		= 'WEEKLY'
							AND M.MODELING_ID		= D.MODELING_ID
							AND M.DIVISION_ID		= D.DIVISION_ID
							AND P.DIVISION_ID		= D.DIVISION_ID
							AND P.PLAN_CYCLE		= M.PLAN_CYCLE
							AND P.PLAN_ID			= D.PLAN_ID
							AND D.DIVISION_ID		= @p_division_id
							AND P.PLAN_NAME			=  @p_start_yyyymmdd
							AND C.LOOKUP_TYPE		= 'PLAN_TYPE'
							AND C.VALID_YN			= 'Y'
							AND C.SEGMENT1			= D.PLAN_TYPE
							AND C_SUB.LOOKUP_TYPE	= 'PLAN_TYPE'
							AND C_SUB.VALID_YN		= 'Y'
							AND C_SUB.SEGMENT1		= @p_plan_type
						ORDER BY C.DISPLAY_SEQ DESC, D.PLAN_SEQ DESC
					),''),'N');

	SELECT @v_edit_yn AS edit_yn;
END
