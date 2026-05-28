/*=============================================================================================
 * File         : 04_Package_PKG_SCM_USER_MNU.sql
 * Description  : Package — PKG_SCM_USER_MNU
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : Standalone SP와 화면 단위로 PKG 통합은 별도 후속 작업.
 *
 * 실행 순서   : 06_Packages 단계 (Foundation + Tables + GTT + Views 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN → (+) 변환 (사내 표준 §7.1.6)
 *   - @변수 잔존 시 검토
 *   - DATEADD/CHARINDEX/STRING_SPLIT (Oracle 비존재 함수) 수동 변환
 *   - v_program_name 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SCM_USER_MNU AS
    TYPE RT_EDIT_YN IS RECORD (
        UNIT_TP_CD VARCHAR2(10), UNIT_ID VARCHAR2(50), EDIT_YN CHAR(1)
    );
    TYPE TT_EDIT_YN IS TABLE OF RT_EDIT_YN;
    FUNCTION PR_SCM_EDIT_YN (P_USER_ID IN VARCHAR2, P_MNU_ID IN VARCHAR2) RETURN TT_EDIT_YN PIPELINED;
END PKG_SCM_USER_MNU;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SCM_USER_MNU AS
    FUNCTION PR_SCM_EDIT_YN (P_USER_ID IN VARCHAR2, P_MNU_ID IN VARCHAR2) RETURN TT_EDIT_YN PIPELINED IS
    BEGIN
        FOR rec IN (
            SELECT UNIT_TP_CD, UNIT_ID, EDIT_YN
              FROM SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V
             WHERE USER_ID = P_USER_ID AND MNU_ID = P_MNU_ID
        ) LOOP
            PIPE ROW (rec);
        END LOOP;
        RETURN;
    END;
END PKG_SCM_USER_MNU;
/
