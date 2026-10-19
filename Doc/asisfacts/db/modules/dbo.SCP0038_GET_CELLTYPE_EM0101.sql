

/*
 * Program ID   : SCP0038_GET_CELLTYPE_EM0101
 * Description  : GLOBAL PSI(SMALL) 조회조건 CELLTYPE 
 * Program History
 *===================================================================================================
 * Date         In Charge		Description
 *===================================================================================================
 * 2025/07/17	YMH		        GLOBAL PSI(SMALL) 조회조건 CELLTYPE 최초생성
 *                              PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 * 2025/08/22	kimcd 	        PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
 *                              CELL 유형을 활성화 후 공정 포함하도록 수정
 */
CREATE PROCEDURE [dbo].[SCP0038_GET_CELLTYPE_EM0101]

AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

		SELECT  
			  CLASS_NAME AS CODE
			, CLASS_NAME AS NAME
		FROM    SCM_MST_ITEM_CLASS_SN IC WITH(NOLOCK)
		-- WHERE   CLASS_ID LIKE 'EM0101%'
		WHERE   LEVEL_3_ID IN ( 'EM0101', 'EM0102', 'EM0104', 'EM0105' )  --  2025/08/22 kimcd PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
                                                                          --                   CELL 유형을 활성화 후 공정 포함하도록 수정
		AND     LEVEL = 4
		ORDER BY CLASS_ID;

END
