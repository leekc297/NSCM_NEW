





CREATE VIEW [dbo].[SCM_MST_LINE_V]
 AS
/*
 * Program ID   : SCM_MST_LINE_V
 * Description  : SCM_MST_LINE_SN 정보와 SCM_MST_LINE_OSP 정보를 UNION하여 보여줌
                  LINE_NAME 정보를 조회 하기 위해서
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.02.07  KTH      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 */

    SELECT COMPANY_ID
          ,DIVISION_ID
          ,SITE_ID
          ,PLANT_ID
          ,FACTORY_ID
          ,OPERATION_ID
          ,LINE_ID
          ,ELECTRODE_TYPE
          ,LINE_NAME
          ,'Y'            AS VALID_YN
    --      ,'N'            AS OSP_YN
    FROM SCM_MST_LINE_SN WITH (NOLOCK)
    UNION ALL
    SELECT NULL           AS COMPANY_ID
          ,DIVISION_ID
          ,SCM_SITE_ID    AS SITE_ID
          ,OPERATION_ID   AS PLANT_ID
          ,NULL           AS FACTORY_ID
          ,OPERATION_ID
          ,LINE_ID
          ,NULL           AS ELECTRODE_TYPE
          ,LINE_NAME
          ,VALID_YN
    --      ,'Y'            AS OSP_YN
    FROM SCM_MST_LINE_OSP WITH (NOLOCK)

