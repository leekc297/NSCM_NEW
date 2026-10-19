




CREATE VIEW [dbo].[SSP_MKT_USER_V] AS
/********************************************************************************************************************************
* VIEW NAME     : [SSP_MKT_USER_V]
* DESCRIPTION   : MKT OWNER 조회 ( 동일 정보에 여러명 지정 된 경우 열로 분리하여 조회  
*          
* PROGRAM HISTORY
*--------------------------------------------------------------
*  DATE      IN CHARGE           DESCRIPTION
*--------------------------------------------------------------
* 2018.11.07   juhlee     Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트

********************************************************************************************************************************/
SELECT MU.DIVISION_ID AS DIVISION_ID
,      MU.ITEM_ID       
,      MU.SCM_SITE_ID  AS TO_SITE
,      MU.PROJECT_CODE 
,      MU.MKT_USER 
FROM  ( 
		SELECT S.DIVISION_ID
		,      S.ITEM_ID  
		,      S.SCM_SITE_ID
		,      S.PROJECT_CODE 
		,      [dbo].[FN_SCM_SPLIT](S.OWNER, 1 , ',')  AS MKT_USER1
		,      [dbo].[FN_SCM_SPLIT](S.OWNER, 2 , ',')  AS MKT_USER2
		,      [dbo].[FN_SCM_SPLIT](S.OWNER, 3 , ',')  AS MKT_USER3
		,      [dbo].[FN_SCM_SPLIT](S.OWNER, 4 , ',')  AS MKT_USER4
		,      [dbo].[FN_SCM_SPLIT](S.OWNER, 5 , ',')  AS MKT_USER5
		FROM  (
				SELECT DIVISION_ID
				,      ITEM_ID
				,      SCM_SITE_ID
				,      PROJECT_CODE
				,      MAX(OWNER)    AS OWNER 
				FROM  SCM_MST_SITE_ITEM  WITH(NOLOCK) 
				WHERE   VALID_YN  = 'Y'
				GROUP BY  DIVISION_ID
				,      ITEM_ID
				,      SCM_SITE_ID
				,      PROJECT_CODE
				) S  
    ) T
 UNPIVOT  ( MKT_USER FOR AA IN ( T.MKT_USER1 , T.MKT_USER2, T.MKT_USER3, T.MKT_USER4, T.MKT_USER5) 
          ) AS MU






