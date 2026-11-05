/* =====================================================================================================
 * SCP0096 Shipment Working Day OSP — 저장 시 SQL ERROR(ORA-01407 LAST_UPDATED_BY NULL) 보완
 *   대상 : SCM_ADM_PROC_M  PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP  SORT_ORD=8 (P_USER_ID, VARCHAR IN)
 *   변경 : COL_NM 'userIdList' → 'userId'
 *   원인 : FE(공통소스 10-28 반영본 ShipmentWorkingDayOsp.tsx handleSave)가 payload 키 'userId'(세션 단일값)로 전송.
 *          BE BaseService.makeProcedure 는 PROC_M COL_NM 키만 SP 로 넘기므로 COL_NM='userIdList' 면 P_USER_ID=NULL
 *          → UPDATE/INSERT LAST_UPDATED_BY NULL → ORA-01407(SCM_SYS_LOG_BATCH 2026-10-28 21:01:34 · 21:06:40 실측).
 *   근거 : 원래 등록값 'userId'(ZIONEX 2026-09-24, SCM_ADM_PROC_M_BAK20260930) · 2026-10-20 21:35 'userIdList' 로 변경됨.
 *          PKG 본문은 단일값/'^' 배열 모두 첫 토큰을 쓰므로(E20261020-USERIDLIST) PKG 변경 없음.
 *   성질 : 멱등(재실행 0건) · 비파괴(행 삭제 없음) · 사내 수정 전 값을 WHERE 에 쓰지 않음(목표 상태 기준)
 *   전체 F5 실행 기준 오류 0.
 * ===================================================================================================== */
SET SERVEROUTPUT ON;

-- 백업 테이블(이 패치가 바꾸는 행만, 최초 1회) — 이미 있으면 건너뜀
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE SCM_ADM_PROC_M_BAK20261028_S096 AS SELECT * FROM SCM_ADM_PROC_M '
                   || 'WHERE PROC_NM = ''PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP''';
    DBMS_OUTPUT.PUT_LINE('[BAK] SCM_ADM_PROC_M_BAK20261028_S096 생성');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            DBMS_OUTPUT.PUT_LINE('[BAK] SCM_ADM_PROC_M_BAK20261028_S096 이미 존재 — 기존 백업 유지');
        ELSE
            RAISE;
        END IF;
END;
/

DECLARE
    V_CNT  PLS_INTEGER;
BEGIN
    UPDATE SCM_ADM_PROC_M
       SET COL_NM           = 'userId'
         , LAST_UPDATED_BY  = 'admin'
         , LAST_UPDATE_DATE = SYSDATE
     WHERE PROC_NM   = 'PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP'
       AND SORT_ORD  = 8
       AND COL_TP_CD = 'IN'
       AND COL_NM   <> 'userId'
       AND NOT EXISTS (SELECT 1 FROM SCM_ADM_PROC_M X
                        WHERE X.PROC_NM   = 'PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP'
                          AND X.COL_NM    = 'userId'
                          AND X.COL_TP_CD = 'IN');
    V_CNT := SQL%ROWCOUNT;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[APPLY] PROC_M SORT_ORD=8 COL_NM→userId 갱신 ' || V_CNT || '건 (0건 = 이미 적용됨 또는 대상 행 없음 → 90_VERIFY 확인)');
END;
/
