-- SOURCE-FRESH: SCM_MGR.PKG_DMF0008 PACKAGE LAST_DDL=2026-09-14 18:37:13 FETCHED=2026-09-15 18:54 DB=ZIOUI1
SET DEFINE OFF
CREATE OR REPLACE PACKAGE SCM_MGR."PKG_DMF0008"
IS

    /* 1단 요약 조회 */
    PROCEDURE P_DMF0008_GET_EDI_MST_SUMMARY 
(
  p_FROM_YYYYMMDD VARCHAR2,  --안쓰임
  p_TO_YYYYMMDD   VARCHAR2,  --안쓰임
  p_DIVISION_ID   VARCHAR2,  --쓰임
  p_user_id       VARCHAR2,
  p_menu_id       VARCHAR2,
  O_RC1           OUT SYS_REFCURSOR,
  O_RC3           OUT SYS_REFCURSOR,
  O_RESULT_CURSOR OUT SYS_REFCURSOR
);

    /* 2단 정비 대상 조회 */
    PROCEDURE P_DMF0008_GET_EDI_MST_REPAIR 
(
	  p_DIVISION_ID        VARCHAR2
	, p_FROM_YYYYMMDD	    VARCHAR2
	, p_TO_YYYYMMDD		VARCHAR2
	, p_Sender_Name		VARCHAR2
	, p_Flag				VARCHAR2
    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
);

    /* 3단 Sales Site 조회 */
    PROCEDURE P_DMF0008_GET_SALES_SITE 
(
  p_division_id   VARCHAR2,
  p_soldto        VARCHAR2,
  p_shipto        VARCHAR2,
  p_scm_site_id   VARCHAR2,
  O_RESULT_CURSOR OUT SYS_REFCURSOR
);

    /* 3단 Project Model 조회 */
    PROCEDURE P_DMF0008_GET_SALES_SITE_PROJECT_MODEL
    (
        p_division_id           VARCHAR2
      , p_item_id               VARCHAR2
      , p_scm_site_id           VARCHAR2
      , p_user_id               VARCHAR2
      , p_menu_id               VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    /* 갱신 이력 조회 */
    PROCEDURE P_DMF0008_GET_UPDATE_HISTORY (
    P_USER_ID VARCHAR2,
    P_MENU_ID VARCHAR2,
    O_RC1     OUT SYS_REFCURSOR
);

    /* Sales Site 저장 */
    PROCEDURE P_DMF0008_SAVE_SALES_SITE_EDI_REPAIR 
(
		p_division_id					IN  VARCHAR2,
		p_end_customer				IN  VARCHAR2,
		p_soldto_customer			IN  VARCHAR2,
		p_company_id					IN  VARCHAR2,
		p_scm_site_id					IN  VARCHAR2,
		p_soldto_code					IN  VARCHAR2,
		p_shipto_code					IN  VARCHAR2,
		p_vmi_yn							IN  VARCHAR2,
		p_valid_yn						IN  VARCHAR2,
		p_cust_valid_yn					IN  VARCHAR2,
		p_rep_yn							IN  VARCHAR2,
		p_country						IN  VARCHAR2,
		p_city								IN  VARCHAR2,
		p_ship_plan_auto				IN  VARCHAR2,
		p_dept_id						IN  VARCHAR2,
		p_created_by					IN  VARCHAR2,
		p_message_cursor				OUT SYS_REFCURSOR
);

    /* Project Model 저장 */
    PROCEDURE P_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR 
(
    p_division_id         VARCHAR2,
    p_project_code          VARCHAR2,
    p_scm_site_id         VARCHAR2,
    p_item_id             VARCHAR2,
    p_currency            VARCHAR2,
    p_kwh               VARCHAR2, --ATTRIBUTE8
    p_cell_per_car          VARCHAR2,
    p_cell_per_module       VARCHAR2,
    p_liability_period        VARCHAR2,
    p_valid_yn            VARCHAR2,
    p_bpms_exist          VARCHAR2,
    p_sales_company       VARCHAR2,
    p_sales_plant         VARCHAR2,
    p_module_variant        VARCHAR2, --ATTRIBUTE2
    p_incoterms           VARCHAR2, --ATTRIBUTE6
    p_created_by          VARCHAR2

    , O_RC1  OUT  SYS_REFCURSOR
    , O_RC2  OUT  SYS_REFCURSOR
    , O_RC3  OUT  SYS_REFCURSOR
    , O_RC4  OUT  SYS_REFCURSOR
    , O_RC5  OUT  SYS_REFCURSOR
    , O_RC6  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
);

END PKG_DMF0008;
/
