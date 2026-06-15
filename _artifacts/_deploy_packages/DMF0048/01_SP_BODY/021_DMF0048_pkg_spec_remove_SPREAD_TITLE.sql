--==============================================================================
-- 021_DMF0048_pkg_spec_remove_SPREAD_TITLE.sql
--   PKG_DMF0048 spec 의 P_DMF0048_GET_SPREAD_TITLE 선언 제거
--
-- 배경: 기존 PKG_DMF0048 spec L62~68 에 SPREAD_TITLE 선언만 있고 body 누락
--   → SPREAD_TITLE 를 standalone SP 로 옮긴 후 PKG spec 에서 제거
--   → PKG 가 SALES_MONITORING 1 SP 만 갖도록 (body 와 일치)
--
-- ⚠️ 본 작업은 PKG spec 전체 재정의 (CREATE OR REPLACE PACKAGE) — body 영향 검증 필수
--   PKG body 의 GET_DM_PLN_SALES_MONITORING 는 그대로 보존됨 (signature 일치)
--   sp-body-minimal-change hook 준수 (body 1바이트도 변경 X)
--
-- 사용자 명시 승인 후 실행 권장 (PKG spec 재정의는 dependency 가 있는 모든 객체 invalid 전파)
--
-- 작성: 2026-06-07 (Phase B-1 후속)
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === DMF0048 PKG spec 재정의 (SPREAD_TITLE 제거) ===

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0048 IS
    /*
    * Program ID   : PKG_DMF0048
    * Description  : PKG_DMF0048 (DMF0048 Sales Monitoring 메인 SP only)
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.04.07   김준규          [PJ20264226] NextSCM Pilot 설계 및 개발
    * 2026.06.07   마리소프트      SPREAD_TITLE → standalone SP 분리 (body 누락 해결)
    */

    PROCEDURE P_DMF0048_GET_DM_PLN_SALES_MONITORING
    (
        P_DIVISION_ID   VARCHAR2
       ,P_DEPT_ID       VARCHAR2
       ,P_END_CUSTOMER  VARCHAR2
       ,P_SCM_SITE_ID   VARCHAR2
       ,P_PROJECT_CODE  VARCHAR2
       ,P_ITEM_ID       VARCHAR2
       ,P_ITEM_TYPE     VARCHAR2
       ,P_FROM_YYYYMMDD VARCHAR2
       ,P_NOW_YYYYMMDD  VARCHAR2
       ,P_TO_YYYYMMDD   VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_PLANT_SITE_ID VARCHAR2
       ,P_BIZTYPE       VARCHAR2
       ,P_OWNER         VARCHAR2
       ,P_INTERNAL_YN   VARCHAR2
       ,P_USERINFO      VARCHAR2
       ,P_BUCKET        VARCHAR2
       ,P_USER_DEPT_ID  VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RC2           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    -- ============================================================
    -- P_DMF0048_GET_SPREAD_TITLE — standalone SP 로 분리 (2026-06-07)
    -- 위치: _artifacts/_deploy_packages/DMF0048/01_SP_BODY/020_DMF0048_SPREAD_TITLE_create.sql
    -- 메타 API_URL: P_DMF0048_GET_SPREAD_TITLE (PKG prefix 없음)
    -- ============================================================

END PKG_DMF0048;
/

PROMPT === PKG_DMF0048 status 검증 ===
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, LAST_DDL_TIME
  FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR'
   AND OBJECT_NAME='PKG_DMF0048'
 ORDER BY OBJECT_TYPE;

PROMPT === PKG body recompile 권장 (spec 변경 후 의존성) ===
ALTER PACKAGE SCM_MGR.PKG_DMF0048 COMPILE BODY;

SELECT OBJECT_NAME, OBJECT_TYPE, STATUS
  FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR'
   AND OBJECT_NAME='PKG_DMF0048';

EXIT;
