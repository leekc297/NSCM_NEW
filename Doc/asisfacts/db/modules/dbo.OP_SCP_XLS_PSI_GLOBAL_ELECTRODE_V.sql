
CREATE VIEW [dbo].[OP_SCP_XLS_PSI_GLOBAL_ELECTRODE_V] AS 
/*
 * Program ID   : OP_SCP_XLS_PSI_GLOBAL_ELECTRODE_V
 * Description  : 데이터검증를 위해 운영서버의 SCP_XLS_PSI_GLOBAL_ELECTRODE 테이블을 조회하는 원격뷰
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024. 12. 06  KSK      Initial Release 
 */
SELECT *
FROM [10.34.221.78,7433].LGCE_SCMPROD.DBO.SCP_XLS_PSI_GLOBAL_ELECTRODE
