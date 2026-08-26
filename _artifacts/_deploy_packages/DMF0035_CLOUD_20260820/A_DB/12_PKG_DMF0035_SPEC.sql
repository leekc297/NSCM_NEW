-- DMF0035_CLOUD_20260820 / 12_PKG_DMF0035_SPEC.sql
-- PKG_DMF0035 PACKAGE — 사내 Oracle 라이브 ALL_SOURCE 신선 덤프 (2026-08-20).
-- ⭐ 2026-08-20 조회 튜닝 세트 (SPEC — 시그니처 무변경, BODY 와 동시 배포)
-- ⚠ 단독 실행 (SPEC → BODY 순서). 누적 패치 조합 아님 = 현재 라이브 원문 그대로.
CREATE OR REPLACE PACKAGE           "PKG_DMF0035" AS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0053                                                                        */
/* Description : PKG_DMF0053                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.25  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0035_GET_MKT_FCST_WATERFALL
(
    P_DIVISION_ID      IN VARCHAR2
  , P_DEPT_ID          IN VARCHAR2
  , P_END_CUSTOMER     IN VARCHAR2
  , P_SCM_SITE_ID      IN VARCHAR2
  , P_PROJECT_CODE     IN VARCHAR2
  , P_ITEM_ID          IN VARCHAR2
  , P_ITEM_TYPE        IN VARCHAR2
  , P_FROM_YYYYMMDD    IN VARCHAR2
  , P_TO_YYYYMMDD      IN VARCHAR2
  , P_CREATED_BY       IN VARCHAR2
  , P_PLANT_SITE_ID    IN VARCHAR2
  , P_BIZ_TYPE         IN VARCHAR2
  , P_OWNER            IN VARCHAR2
  , P_VERSION_NO       IN VARCHAR2
  , P_BUCKET           IN VARCHAR2  -- 20211103 MKT FCST WATERFALL 속도 개선
  , P_USER_DEPT_ID     IN VARCHAR2  -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
  , P_GROUP_ID         IN VARCHAR2  -- JV Planner 일지 확인하기 위해 추가
  , P_CELL_YN          IN VARCHAR2
  , P_SENDER_CODE      IN VARCHAR2  -- SENDER_CODE 추가
  , P_USER_ID          IN VARCHAR2
  , P_MENU_ID          IN VARCHAR2

  , O_RC1              OUT SYS_REFCURSOR
  , O_RC2              OUT SYS_REFCURSOR
  , O_RC3              OUT SYS_REFCURSOR
  , O_RESULT_CURSOR    OUT SYS_REFCURSOR
);


  -- [E20260806-WF] SPREAD_TITLE PKG 합류 (standalone VALID 본문 무수정 — UI별 PKG 원칙)
  PROCEDURE P_DMF0035_GET_SPREAD_TITLE
  ( P_START_YYYYMMDD  IN VARCHAR2
  , P_END_YYYYMMDD    IN VARCHAR2
  , P_CREATED_BY      IN VARCHAR2
  , P_DIVISION_ID     IN VARCHAR2
  , P_BUCKET          IN VARCHAR2
  , O_RC1             OUT SYS_REFCURSOR
  , O_RESULT_CURSOR   OUT SYS_REFCURSOR
  );

END PKG_DMF0035;
/
