PACKAGE PKG_SCP0024
IS
    /*
     * Package ID   : PKG_SCP0024
     * Description  : SCP0024 Production Plan Fix
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.17   AJS            MSSQL -> Oracle 전환
     * 2026.09.17   AJS            검증 반영 - 해제 플래그 대소문자 무시 · 공백 수량 NULL · 형식이 틀린 JSON 오류 처리
     *                             · 확정 뒤 오류 시 되돌리기 생략 · 조회조건 대입을 본문으로 · 조회 디버그 기본값 'F'
     * 2026.09.17   AJS            기준 반영 - 조회 임시테이블 제거(결과 조회문 한 문장) · 저장 키 대소문자 무시 · 정렬 2단 식
     */

    /* Production Plan Fix 조회 (일자 칸 D_YYYYMMDD · 주 합계 W_YYYYMMWW · 월 합계 M_YYYYMM 동적 생성) */
    PROCEDURE P_SCP0024_GET_PROD_PLAN_FIX
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_ELECTRODE_TYPE        IN  VARCHAR2 DEFAULT NULL,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',    /* AS-IS 기본값 'T' - 2026.09.17 AJS 화면 미사용 인자라 출력 없는 'F' 로 */
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,      /* S : 정상 · F : 오류 */
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Production Plan Fix 일괄 등록/수정/해제 (JSON 배열 입력) */
    PROCEDURE P_SCP0024_SAVE_PLAN_FIX_DS
    (
        P_DATA                  IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        -- 2026.10.06 AJS 결과 반환을 결과 커서로 변경 (START)
        -- O_RESULT_CODE           OUT VARCHAR2,      /* S : 정상 · F : 오류 */
        -- O_RESULT_CNT            OUT NUMBER,
        -- O_RESULT_MSG            OUT VARCHAR2
        O_RESULT_CURSOR         OUT SYS_REFCURSOR      /* RESULT_CODE · CODE(성공 '0' · 실패 '-1') · MSG */
        -- 2026.10.06 AJS 결과 반환을 결과 커서로 변경 (END)
    );

    /* Production Plan Fix 등록/수정/해제 (^ 구분 목록 입력) */
    PROCEDURE P_SCP0024_SAVE_PROD_PLAN_FIX
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_OPERATION_GROUP       IN  CLOB,
        P_SCM_SITE_ID           IN  CLOB,
        P_LINE_ID               IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_OPERATION_ID          IN  CLOB,
        P_YYYYMMDD              IN  CLOB,
        P_QTY                   IN  CLOB,
        P_FIX_REASON            IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_ORIGIN_DIVISION_ID    IN  CLOB,
        P_ELECTRODE_TYPE        IN  CLOB,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RESULT_CODE           OUT VARCHAR2,      /* S : 정상 · F : 오류 */
        O_RESULT_CNT            OUT NUMBER,
        O_RESULT_MSG            OUT VARCHAR2
    );

END PKG_SCP0024;