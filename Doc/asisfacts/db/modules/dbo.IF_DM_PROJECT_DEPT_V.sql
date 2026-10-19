
CREATE VIEW [dbo].[IF_DM_PROJECT_DEPT_V]
AS
/*=====================================================================================================
 * PROJECT       : LGES SCM Customer Demand Analysis
 * VIEW NAME     : DM_PROJECT_DEPT_V
 * DESCRIPTION   : Power BI 제공용: SSPM의 Division, Project 별 담당, 거래선 정보
 * PROGRAM HISTORY
 *=====================================================================================================
 *  DATE        IN CHARGE			DESCRIPTION
 *=====================================================================================================
 * 2025.01.22	Philsu Park         Initial Release.
 * 2025.02.17   Philsu Park         표준 Report 요청: DEPT_ID, PJT_NAME 추가.
=====================================================================================================*/
    SELECT    MM.DIVISION_ID
            , MM.PROJECT_CODE
            , PJT.PROJECT_NAME AS PJT_NAME
            , DPT.DEPT_ID
            , MM.DEPARTMENT_NAME
            , MM.REPORT_CUSTOMER_NAME
    FROM    ( 
                SELECT    STM.DIVISION_ID       AS DIVISION_ID
                        , STM.PROJECT_CODE      AS PROJECT_CODE
                        , MAX(STM.CRGE_ORG_NM)  AS DEPARTMENT_NAME
                        , MAX(STM.CUST_ENG_NM)  AS REPORT_CUSTOMER_NAME
                FROM    SCM_MST_SITE_ITEM STM WITH(NOLOCK)
                WHERE   ISNULL(STM.CRGE_ORG_NM, '') != ''
                AND     STM.VALID_YN = 'Y'
                GROUP BY  STM.DIVISION_ID
                        , STM.PROJECT_CODE
            ) MM
    LEFT OUTER JOIN (SELECT  DIVISION_ID, PROJECT_CODE, MAX(PROJECT_NAME) AS PROJECT_NAME
                    FROM    SCM_MST_PROJECT WITH(NOLOCK)
                    GROUP BY DIVISION_ID, PROJECT_CODE
                    ) AS PJT
        ON  MM.DIVISION_ID  = PJT.DIVISION_ID
        AND MM.PROJECT_CODE = PJT.PROJECT_CODE
    LEFT OUTER JOIN (SELECT  SEGMENT1 AS DEPT_ID
                            , SEGMENT2 AS DEPT_NAME
                    FROM    SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                    WHERE   LOOKUP_TYPE = 'DM_ORG_NAME_DEPT_LIST'
                    AND     VALID_YN    = 'Y') DPT
        ON  MM.DEPARTMENT_NAME = DPT.DEPT_NAME
    WHERE   1=1
