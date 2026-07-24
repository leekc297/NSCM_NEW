
  CREATE OR REPLACE EDITIONABLE PACKAGE "SCM_MGR"."PKG_DMF0082" 
/*
 * Program ID   : PKG_DMF0082
 * Description  : PKG_DMF0082
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.30   jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                          UI 항목으로 Package로 전환
 */
AS
    -- 프로시저 선언
PROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO
(
    P_START_YYYYMMDD   IN  VARCHAR2,
    P_END_YYYYMMDD     IN  VARCHAR2,
    P_USER_ID          IN VARCHAR2, -- For EditYn
    P_MNU_ID           IN VARCHAR2, -- For EditYn
    O_RC1              OUT SYS_REFCURSOR,
    O_RESULT_CURSOR    OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0082_POPUP_GET_WEEKDATA
(
    P_YYYYMMDD          IN  VARCHAR2,
    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE
(
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0082_POPUP_GET_MEASURE_COUNTINFO
(
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0082_GET_MAIN_DATA
(
    p_division_id    IN  VARCHAR2
  , p_team_id        IN  VARCHAR2
  , p_customer       IN  VARCHAR2
  , p_biz_type       IN  VARCHAR2
  , p_from_yyyymmdd  IN  VARCHAR2
  , p_to_yyyymmdd    IN  VARCHAR2
  , p_scm_site_id    IN  VARCHAR2
  , p_item_id        IN  VARCHAR2
  , p_version_type   IN  VARCHAR2
  , p_qty_yn         IN  VARCHAR2
  , p_created_by     IN  VARCHAR2
  , p_user_group     IN  VARCHAR2
  , O_RC1            OUT SYS_REFCURSOR
  , O_RC2            OUT SYS_REFCURSOR
  , O_RC3            OUT SYS_REFCURSOR
  , O_RC4            OUT SYS_REFCURSOR
  , O_RC5            OUT SYS_REFCURSOR
  , O_RESULT_CURSOR  OUT SYS_REFCURSOR
);
/*
PROCEDURE P_DMF0082_SAVE_MAIN_DATA
(   p_active_flag         IN VARCHAR2
  , p_division_id         IN VARCHAR2
  , p_project_code        IN VARCHAR2
  , p_end_customer        IN VARCHAR2
  , p_scm_site_id         IN VARCHAR2
  , p_item_id             IN VARCHAR2
  , p_dom_exp             IN VARCHAR2
  , p_fcst_type           IN VARCHAR2
  , p_incoterms           IN VARCHAR2
  , p_measure             IN VARCHAR2
  , p_plant_site_id       IN VARCHAR2
  , p_cell_prod_site_id   IN VARCHAR2
  , p_yyyymmdd            IN VARCHAR2
  , p_currency            IN VARCHAR2
  , p_qty                 IN VARCHAR2
  , p_created_by          IN VARCHAR2
  , O_RESULT_CURSOR       OUT SYS_REFCURSOR
);
*/
END PKG_DMF0082;
/