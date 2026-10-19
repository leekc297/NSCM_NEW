


/*
 * Program ID   : SCP0130_GET_SEARCH_INFO
 * Description  : 선행생산 일수 (PRECEDE / SAFETY STOCK DAY)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/25   kh    			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 *
 */

CREATE PROCEDURE [dbo].[SCP0202_GET_OPMZ_UI_LIST]
AS
BEGIN
	
    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  
    ;WITH Ranked AS (
        SELECT P.ProgramID
              ,M.Title 
              ,P.ClassName
              ,P.ProgramName
              ,ProgramPath
              ,ROW_NUMBER() OVER (PARTITION BY P.ProgramID ORDER BY M.Title  ) AS rn

        FROM TB_FX_MenuItemInfo M  WITH(NOLOCK)
            ,TB_FX_ProgramInfo P   WITH(NOLOCK)
             ,dbo.SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
        WHERE P.ProgramID = M.ProgramID
        AND   P.ProgramID = L.SEGMENT1
        AND   L.LOOKUP_TYPE LIKE 'OPMZ_UI_LIST'
        AND   L.VALID_YN='Y'
        )  
    SELECT ProgramID   AS PROGRAM_ID
         , Title       AS TITLE_NAME
         , ClassName   AS CLASS_NAME
         , ProgramName AS PROGRAM_NM
         , ProgramPath AS PROGRAM_PATH
    FROM Ranked
    WHERE rn = 1;

	 
END

