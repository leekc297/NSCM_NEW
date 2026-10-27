



CREATE VIEW [dbo].[SCM_MODEL_COMP_TEMP_V] AS
-- ================================================================================================
-- Program ID          : [dbo].[SCM_MODEL_COMP_TEMP_V]
--
-- Program Name        : SCM_MODEL_COMP_TEMP 조회
-- Param               :
-- Batch Period        : 
-- Description         : 
--                       
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 2023.06.01
-- Author              : FP Pjt.
-- Version             : 1.0
--                       
--                       
--                       
-- ================================================================================================


SELECT   *
FROM   SCM_MODEL_COMP_TEMP WITH(NOLOCK)
/*WHERE COMPANY_ID = 'C100'
UNION ALL
SELECT   *
FROM   CONV_SCM_MODEL_COMP_TEMP WITH(NOLOCK)
WHERE COMPANY_ID != 'C100'*/


