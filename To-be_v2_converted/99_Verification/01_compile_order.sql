/*=============================================================================================
 * File         : 01_compile_order.sql
 * Description  : To-Be v2 변환 산출물 실행 순서 가이드
 *              : 종속성 순으로 모든 SQL 파일을 호출하는 마스터 스크립트
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 방법    : SQL*Plus
 *                  $ sqlplus SCM_MGR/password@ESSCMD
 *                  SQL> @01_compile_order.sql
 *===========================================================================================*/

SET ECHO ON
SET TIMING ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SPOOL compile_log.txt

PROMPT ========================================================
PROMPT  Phase 1: Foundation Layer
PROMPT ========================================================

@@../01_Foundation/01_Common_TYPE_Objects.sql
@@../01_Foundation/02_System_Log_Table.sql
@@../01_Foundation/03_System_Log_Procedures.sql
@@../01_Foundation/04_Common_Helper_Functions.sql

PROMPT ========================================================
PROMPT  Phase 2: Tables (DM Domain)
PROMPT ========================================================

@@../02_Tables/01_DM_ANL_Tables.sql
@@../02_Tables/01_DM_BP_Tables.sql
@@../02_Tables/01_DM_BPS_Tables.sql
@@../02_Tables/01_DM_CUST_Tables.sql
@@../02_Tables/01_DM_DNM_Tables.sql
@@../02_Tables/01_DM_HI_Tables.sql
@@../02_Tables/01_DM_MDF_Tables.sql
@@../02_Tables/01_DM_MOBILE_Tables.sql
@@../02_Tables/01_DM_MST_Tables.sql
@@../02_Tables/01_DM_PLN_Tables.sql
@@../02_Tables/01_DM_YEARLY_Tables.sql

PROMPT ========================================================
PROMPT  Phase 3: Global Temporary Tables
PROMPT ========================================================

@@../03_GTT/02_GTT_DM.sql
@@../03_GTT/02_GTT_DMF.sql
@@../03_GTT/02_GTT_LEGACY.sql
@@../03_GTT/02_GTT_OTHER_part1.sql
@@../03_GTT/02_GTT_OTHER_part2.sql
@@../03_GTT/02_GTT_OTHER_part3.sql
@@../03_GTT/02_GTT_OTHER_part4.sql

PROMPT ========================================================
PROMPT  Phase 4: Views
PROMPT ========================================================

@@../04_Views/03_View_DM_MST_ITEM_SINGLE_V.sql
@@../04_Views/03_View_DM_MST_ITEM_SINGLE_V_TEST.sql
@@../04_Views/03_View_SCM_ADM_DEPT_CHANGED_V.sql
@@../04_Views/03_View_SCM_ADM_USER_MNU_EDIT_AUTH_V.sql
@@../04_Views/03_View_SCM_DNM_PLAN_FROZEN_V.sql
@@../04_Views/03_View_SCM_DNM_PRODUCT_RESULT_V.sql
@@../04_Views/03_View_SCM_MST_ALTER_BOM_V.sql
@@../04_Views/03_View_SCM_MST_BOM_SN_V.sql
@@../04_Views/03_View_SCM_MST_FINAL_ITEM_ORIGIN_DIV_V.sql
@@../04_Views/03_View_SCM_MST_FINAL_ITEM_V.sql
@@../04_Views/03_View_SCM_MST_LINE_V.sql
@@../04_Views/03_View_SCM_MST_MODEL_FINAL_ITEM_BOM_V.sql
@@../04_Views/03_View_SCM_MST_SITE_DETP_V.sql
@@../04_Views/03_View_SCM_MST_SITE_ITEM_PRIORITY_V.sql

PROMPT ========================================================
PROMPT  Phase 5: Packages (55개)
PROMPT ========================================================
PROMPT  주의: 패키지 간 상호 호출이 있을 수 있으므로 모두 컴파일 후
PROMPT       ALTER PACKAGE ... COMPILE BODY 로 재컴파일 권장

-- 공통 패키지 우선 (다른 패키지의 의존성)
@@../06_Packages/04_Package_PKG_NSCM_UI_COMM.sql
@@../06_Packages/04_Package_PKG_NSCM_UI_COM_AUTH.sql
@@../06_Packages/04_Package_PKG_NSCM_UI_COM_LOOKUP.sql
@@../06_Packages/04_Package_PKG_NSCM_UI_COM_MENU.sql
@@../06_Packages/04_Package_PKG_NSCM_UI_COM_USER.sql
@@../06_Packages/04_Package_PKG_NSCM_UI_EXCEL.sql
@@../06_Packages/04_Package_PKG_COM0000.sql
@@../06_Packages/04_Package_PKG_SEND_MAIL.sql
@@../06_Packages/04_Package_PKG_SCM_DB_MAINTENANCE.sql
@@../06_Packages/04_Package_PKG_SCM_USER_MNU.sql

-- SYS 패키지
@@../06_Packages/04_Package_PKG_SYS0001.sql
@@../06_Packages/04_Package_PKG_SYS0002.sql
@@../06_Packages/04_Package_PKG_SYS0003.sql
@@../06_Packages/04_Package_PKG_SYS0004.sql
@@../06_Packages/04_Package_PKG_SYS0005.sql
@@../06_Packages/04_Package_PKG_SYS0006.sql
@@../06_Packages/04_Package_PKG_SYS0007.sql
@@../06_Packages/04_Package_PKG_SYS0008.sql
@@../06_Packages/04_Package_PKG_SYS0009.sql
@@../06_Packages/04_Package_PKG_SYS0010.sql
@@../06_Packages/04_Package_PKG_SYS0011.sql

-- SCM 패키지
@@../06_Packages/04_Package_PKG_SCM0000.sql
@@../06_Packages/04_Package_PKG_SCM0002.sql
@@../06_Packages/04_Package_PKG_SCM0006.sql
@@../06_Packages/04_Package_PKG_SCM0007.sql
@@../06_Packages/04_Package_PKG_SCM0010.sql

-- DM 패키지
@@../06_Packages/04_Package_PKG_DM0000.sql
@@../06_Packages/04_Package_PKG_DMF0000.sql
@@../06_Packages/04_Package_PKG_DMF0002.sql
@@../06_Packages/04_Package_PKG_DMF0003.sql
@@../06_Packages/04_Package_PKG_DMF0004.sql
@@../06_Packages/04_Package_PKG_DMF0005.sql
@@../06_Packages/04_Package_PKG_DMF0006.sql
@@../06_Packages/04_Package_PKG_DMF0007.sql
@@../06_Packages/04_Package_PKG_DMF0008.sql
@@../06_Packages/04_Package_PKG_DMF0014.sql
@@../06_Packages/04_Package_PKG_DMF0020.sql
@@../06_Packages/04_Package_PKG_DMF0021.sql
@@../06_Packages/04_Package_PKG_DMF0022.sql
@@../06_Packages/04_Package_PKG_DMF0027.sql
@@../06_Packages/04_Package_PKG_DMF0035.sql
@@../06_Packages/04_Package_PKG_DMF0040.sql
@@../06_Packages/04_Package_PKG_DMF0042.sql
@@../06_Packages/04_Package_PKG_DMF0043.sql
@@../06_Packages/04_Package_PKG_DMF0044.sql
@@../06_Packages/04_Package_PKG_DMF0048.sql
@@../06_Packages/04_Package_PKG_DMF0049.sql
@@../06_Packages/04_Package_PKG_DMF0051.sql
@@../06_Packages/04_Package_PKG_DMF0053.sql
@@../06_Packages/04_Package_PKG_DMF0068.sql
@@../06_Packages/04_Package_PKG_DMF0072.sql
@@../06_Packages/04_Package_PKG_DMF0073.sql
@@../06_Packages/04_Package_PKG_DMF0074.sql
@@../06_Packages/04_Package_PKG_DMF0081.sql
@@../06_Packages/04_Package_PKG_DMF0082.sql

PROMPT ========================================================
PROMPT  Phase 6: Standalone Procedures
PROMPT ========================================================
PROMPT  주의: 일부 SP에 DATEADD/CHARINDEX/STRING_SPLIT 잔존 가능
PROMPT       (07_Standalone_SP/05_Standalone_SP_*.sql 참조)

@@../07_Standalone_SP/05_Standalone_SP_MISC.sql
@@../07_Standalone_SP/05_Standalone_SP_DM0000.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF000.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0000.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0002.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0003.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0004.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0005.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0006.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0007.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0008.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0014.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0020.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0021.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0022.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0027.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0035.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0040.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0042.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0043.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0044.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0048.sql
@@../07_Standalone_SP/05_Standalone_SP_DMF0049.sql

PROMPT ========================================================
PROMPT  Phase 7: 재컴파일 (의존성 보정)
PROMPT ========================================================

BEGIN
    DBMS_UTILITY.COMPILE_SCHEMA(schema => 'SCM_MGR', compile_all => FALSE);
END;
/

PROMPT ========================================================
PROMPT  Phase 8: 컴파일 결과 확인
PROMPT ========================================================

SELECT object_type, status, COUNT(*) AS cnt
FROM   user_objects
GROUP BY object_type, status
ORDER BY object_type, status;

SELECT name, type, line, text
FROM   user_errors
ORDER BY type, name, sequence
FETCH FIRST 100 ROWS ONLY;

SPOOL OFF
