-- SOURCE-FRESH: SCM_MGR.PKG_SCP0096 PACKAGE FETCHED=2026-10-19 22:43:24 FROM ZIOUI1 LAST_DDL=['2026-10-09 13:38:32']
PACKAGE PKG_SCP0096 IS

    /*
     * Program ID   : PKG_SCP0096
     * Description  : 출하일 관리 조회 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.24   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     */

    /* 출하일 관리 조회 (AS-IS SCP0096_GET_SHIPMENT_WORKING_DAY_OSP)
     * 기간 안의 일자 수만큼 칸이 늘어나는 조회라 칸 구성을 실행 시점에 만든다. */
    PROCEDURE P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP
    (
        P_DIVISION_ID     IN  VARCHAR2,
        P_PLANT_SITE_ID   IN  VARCHAR2,
        P_FROM_YYYYMMDD   IN  VARCHAR2,
        P_TO_YYYYMMDD     IN  VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    /* 출하일 관리 저장 (AS-IS SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP)
     * AS-IS 는 행마다 한 번씩 불렀고, 화면 공통 규약에 맞춰 여러 행을 '^' 로 이어 한 번에 받는다. */
    PROCEDURE P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP
    (
        P_DIVISION_ID            IN  CLOB,
        P_PLANT_SITE_ID          IN  CLOB,
        P_YYYYMMDD               IN  CLOB,
        P_MEASURE                IN  CLOB,
        P_SHIPMENT_YN            IN  CLOB,
        P_WORKING_TIME_DEFAULT   IN  CLOB,
        P_IS_SAVE_DEFAULT        IN  CLOB,
        P_USER_ID                IN  VARCHAR2,
        O_RESULT_CURSOR          OUT SYS_REFCURSOR
    );

END PKG_SCP0096;