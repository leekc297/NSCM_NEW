-- SOURCE-FRESH: SCM_MGR.PKG_DMF0043 PACKAGE LAST_DDL=2026-09-15 18:58:19 FETCHED=2026-09-15 21:03 DB=ZIOUI1
-- PKG_DMF0043 PACKAGE — standalone SP 취합본 (사내 적용 2026-09-15)
SET DEFINE OFF
CREATE OR REPLACE PACKAGE SCM_MGR."PKG_DMF0043" IS
    /*
    * Program ID   : PKG_DMF0043
    * Description  : PKG_DMF0043
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.15   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_DMF0043_GET_CONTRIBUTE_RATE_POPUP 
(
	p_yyyy		    VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
);

    PROCEDURE P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP 
/*
 **************************************************************************************************
 * Program ID  :  DMF0043_GET_CONTRIBUTE_YEAR_POPUP
 * Description : DMF0043 > 검색 연도
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description
 *--------------------------------------------------------------------------------------------------
 * 2019/05/09  JYE       Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 **************************************************************************************************
*/
(
    p_user_id VARCHAR2
  , p_menu_id VARCHAR2
  , O_RC1  OUT	SYS_REFCURSOR
);

    PROCEDURE P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP 
(
    p_start_yyyymmdd  VARCHAR2,
    p_end_yyyymmdd    VARCHAR2,
	--p_created_by	   VARCHAR2,
	p_division_id	   VARCHAR2,
	p_version_type	   VARCHAR2,
	--p_version_no	   VARCHAR2,
	p_description	   VARCHAR2
    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
);

    PROCEDURE P_DMF0043_GET_MAIN_SPREAD_TITLE_CORE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_YYYY          VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RC2           OUT SYS_REFCURSOR
       ,O_RC3           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0043_GET_MAIN_VARSION_DATA 
/****************************************************************************************************/
/* Program ID  : DMF0043_GET_MAIN_VARSION_DATA								   */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :										    */
/*												    */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description 							    */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/07/18     JYE		기여율 등록화면 Version 바인딩 데이터                    */
/****************************************************************************************************/
(
    p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
);

    PROCEDURE P_DMF0043_GET_SALES_LIST_SPREAD_TITLE (
    p_division_id VARCHAR2,
    p_created_by  VARCHAR2,
    p_menu_id	  VARCHAR2,
    O_RC1	  OUT SYS_REFCURSOR
);

    PROCEDURE P_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO 
(

	-- Add the parameters for the stored procedure here
     p_active_flag				VARCHAR2
    ,p_ver_seq					VARCHAR2
    ,p_department_id			VARCHAR2
    ,p_dept_id					VARCHAR2
    ,p_end_cust_report			VARCHAR2
    ,p_soldto_cust_report		VARCHAR2
    ,p_product_group			VARCHAR2
    ,p_dm_biz_type				VARCHAR2
    ,p_yyyymm					VARCHAR2
    ,p_os_corp_cd				VARCHAR2
    ,p_contribution_type		VARCHAR2
    ,p_contribution_ratio		VARCHAR2
    ,p_created_by				VARCHAR2

    , O_RC1  OUT  SYS_REFCURSOR
);

    PROCEDURE P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER 
(

	-- Add the parameters for the stored procedure here
    p_active_flag	VARCHAR2,
    p_ver_seq		VARCHAR2,
    p_yyyy			VARCHAR2,
    p_version_nm	VARCHAR2,
    p_description	VARCHAR2,
    p_valid_yn		VARCHAR2,
    p_created_by	VARCHAR2

    , O_RC1  OUT  SYS_REFCURSOR
    , O_RC2  OUT  SYS_REFCURSOR
);

    -- [2026-09-15 UIPKG] standalone DMF0043_GET_MAIN_SPREAD_TITLE
    PROCEDURE P_DMF0043_GET_MAIN_SPREAD_TITLE 
(
    p_division_id  IN  VARCHAR2,
    p_yyyy         IN  VARCHAR2,
    p_created_by   IN  VARCHAR2,
    p_user_id      IN  VARCHAR2,
    p_menu_id      IN  VARCHAR2,
    O_RC1          OUT SYS_REFCURSOR,
    O_RC2          OUT SYS_REFCURSOR,
    O_RC3          OUT SYS_REFCURSOR
);

    -- [2026-09-15 UIPKG] standalone DMF0043_GET_CONTRIBUTE_MAIN_DATA
    PROCEDURE P_DMF0043_GET_CONTRIBUTE_MAIN_DATA 
(
    p_yyyy	       IN  VARCHAR2,
    p_ver_seq	       IN  VARCHAR2,
    p_dis	       IN  VARCHAR2,
    p_his	       IN  VARCHAR2,
    p_created_by       IN  VARCHAR2,
    p_user_group       IN  VARCHAR2,
    O_RC1	       OUT SYS_REFCURSOR
);

    -- [2026-09-15 UIPKG] standalone DMF0043_GET_CONTRIBUTION_SALES_LIST
    PROCEDURE P_DMF0043_GET_CONTRIBUTION_SALES_LIST 
(
    p_division_id      IN  VARCHAR2,
    p_ver_seq	       IN  VARCHAR2,
    p_version_no       IN  VARCHAR2,
    p_end_cust_report  IN  VARCHAR2,
    p_product_group    IN  VARCHAR2,
    p_biz_type	       IN  VARCHAR2,
    p_million_yn       IN  VARCHAR2,
    p_compatibility_yn IN  VARCHAR2,
    p_created_by       IN  VARCHAR2,
    O_RC1      OUT SYS_REFCURSOR,   -- 동적 SQL(@v_sql_text) 결과셋
    O_RC2      OUT SYS_REFCURSOR,   -- 정렬 정보 쿼리(@nsql2) 결과셋
    O_RC3       OUT SYS_REFCURSOR    -- CNT 결과셋
);

END PKG_DMF0043;
/
