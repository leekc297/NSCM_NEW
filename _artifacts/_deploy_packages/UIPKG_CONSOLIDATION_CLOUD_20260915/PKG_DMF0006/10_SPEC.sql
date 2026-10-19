-- SOURCE-FRESH: SCM_MGR.PKG_DMF0006 PACKAGE LAST_DDL=2026-09-15 18:57:59 FETCHED=2026-09-15 21:03 DB=ZIOUI1
-- PKG_DMF0006 PACKAGE — standalone SP 취합본 (사내 적용 2026-09-15)
SET DEFINE OFF
CREATE OR REPLACE PACKAGE SCM_MGR."PKG_DMF0006" IS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0006                                                                        */
/* Description : PKG_DMF0006                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.16  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA(
   P_DIVISION_ID             IN VARCHAR2
  ,P_DEPT_ID                 IN VARCHAR2  --DEPARTMENT
  ,P_END_CUSTOMER            IN VARCHAR2  --ENDCUSTOMER
  ,P_SCM_SITE_ID             IN VARCHAR2
  ,P_PROJECT_CODE            IN VARCHAR2
  ,P_ITEM_ID                 IN VARCHAR2
  ,P_CUSTOMER_PROJECT_CODE   IN VARCHAR2
  ,P_CUSTOMER_MODEL          IN VARCHAR2
  ,P_VALID_YN                IN VARCHAR2
  ,P_CREATED_BY              IN VARCHAR2
  ,P_USERINFO                IN VARCHAR2
  ,P_USER_ID                 IN VARCHAR2
  ,P_MENU_ID                 IN VARCHAR2
  
  ,O_CURSOR                  OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR           OUT SYS_REFCURSOR
);

PROCEDURE P_PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA
(
    -- Add the parameters for the stored procedure here
    P_ACTIVE_FLAG           IN VARCHAR2,
    P_DIVISION_ID           IN VARCHAR2,
    P_CUSTOMER_PROJECT_CODE IN VARCHAR2,
    P_CUSTOMER_MODEL        IN VARCHAR2,
    P_SCM_SITE_ID           IN VARCHAR2,
    P_PROJECT_CODE          IN VARCHAR2,
    P_ITEM_ID               IN VARCHAR2,
    P_VALID_YN              IN VARCHAR2,
    P_CUSTOMER_MODEL_TYPE   IN VARCHAR2,
    P_CONVERT_QTY_PACK      IN VARCHAR2,
    P_CONVERT_QTY_MODULE    IN VARCHAR2,
    P_CONVERT_QTY_CELL      IN VARCHAR2,
    P_CREATED_BY            IN VARCHAR2,
    /*P_CREATION_DATE         IN VARCHAR2,
    P_LAST_UPDATED_BY       IN VARCHAR2,
    P_LAST_UPDATE_DATE      IN VARCHAR2,*/
    /*
    P_ATTRIBUTE1            IN VARCHAR2,
    P_ATTRIBUTE2            IN VARCHAR2,
    P_ATTRIBUTE3            IN VARCHAR2,
    P_ATTRIBUTE4            IN VARCHAR2,
    P_ATTRIBUTE5            IN VARCHAR2,
    P_ATTRIBUTE6            IN VARCHAR2,
    P_ATTRIBUTE7            IN VARCHAR2,
    P_ATTRIBUTE8            IN VARCHAR2,
    P_ATTRIBUTE9            IN VARCHAR2,
    P_ATTRIBUTE10           IN VARCHAR2
    */
    --P_SUCCESS_YN          OUT VARCHAR2,
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
);


    -- [2026-09-15 UIPKG] standalone PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST
    PROCEDURE P_PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST 
(

	p_division_id				VARCHAR2,
	p_customer_project_code	VARCHAR2,
	p_customer_model			VARCHAR2,
	p_scm_site_id				VARCHAR2,
	p_project_code				VARCHAR2,
	p_item_id					VARCHAR2,
	p_valid_yn					VARCHAR2,
	p_customer_model_type		VARCHAR2,
	p_convert_qty_pack			VARCHAR2,
	p_convert_qty_module		VARCHAR2,
	p_convert_qty_cell			VARCHAR2,
	p_created_by				VARCHAR2
);

END PKG_DMF0006;
/
