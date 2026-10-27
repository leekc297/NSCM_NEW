




CREATE VIEW [dbo].[SCM_BOM_M_V] AS
-- ================================================================================================
-- Program ID          : [dbo].[SCM_BOM_M_V]
--
-- Program Name        : SCM_BOM_M 조회
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
FROM   SCM_BOM_M WITH(NOLOCK)
/*WHERE COMPANY_ID = 'C100'
UNION ALL
SELECT   *
FROM   CONV_SCM_BOM_M WITH(NOLOCK)
WHERE COMPANY_ID != 'C100'*/

