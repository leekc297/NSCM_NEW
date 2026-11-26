
  CREATE OR REPLACE EDITIONABLE PACKAGE "SCM_MGR"."PKG_SYS0016" 
/*
 * Program ID   : PKG_SYS0013
 * Description  : PKG_DMF0207
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.24   jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                          UI 항목으로 Package로 전환
 */
AS
    PROCEDURE P_SYS0016_GET_NOTICE_CONTENT_MASTER
    (
        P_MODULE	       IN  VARCHAR2,
        P_SUB_MODULE	   IN  VARCHAR2,
        P_ACTIVE_YN	 	   IN  VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0016_SAVE_NOTICE_CONTENT_MASTER
    (
        P_DATA           IN  CLOB,
        P_USER_ID        IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

END PKG_SYS0016;