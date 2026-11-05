-- 25_REGEN_SALES_REPORT — 중복 정리 후 Sales Report(ETC 병합분) 재생성 (선택 실행 · 전체 F5 시 조회만 실행됨)
-- 왜: 중복이 생긴 뒤의 DMF0049 저장은 MOBILE_REPORT_CREATE 가 중복 검증에서 멈춰 Sales Report 원장
--     (DM_PLN_SALES_PLAN_REPORT_C DATA_TYPE='2' · 부서/제품/환율 리포트)에 반영되지 않았다(로그 delete/merge 0/0).
--     20_DATA 로 중복을 정리한 버전 중 전송 상태(SEND_YN='Y')인 버전은 재생성해야 ETC Report 와 Sales Report 가 맞는다.
-- 재생성 = DMF0049 저장 끝에서 하던 것과 같은 호출: PKG_DMF0044.P_DMF0044_MOBILE_REPORT_CREATE(사업부, 버전, 버전유형, 'T', 사용자)
--     → 해당 버전 DATA_TYPE='2' 행 삭제 후 ETC 원장으로 다시 생성 + 부서/제품/환율 리포트 재생성 + COMMIT
-- 전체 F5 시 실행되는 것: 아래 R1 조회 1건뿐. 재생성 블록(R2)은 줄 주석 — 버전을 확인한 뒤 각 줄 앞 '-- ' 를 지우고 실행.

-- R1. 재생성 후보 — 20_DATA 가 정리한 버전 중 SEND_YN='Y'
SELECT 'R1' CHK, B.DIVISION_ID, B.VERSION_NO, V.VERSION_TYPE, V.SEND_YN, COUNT(*) DELETED_ROWS
  FROM BAK_DMF0049_DUP_20261028 B
  JOIN DM_MDF_VERSION V ON V.DIVISION_ID = B.DIVISION_ID AND V.VERSION_NO = B.VERSION_NO
 GROUP BY B.DIVISION_ID, B.VERSION_NO, V.VERSION_TYPE, V.SEND_YN
 ORDER BY B.VERSION_NO DESC;

-- R2. 재생성 실행 — R1 에서 SEND_YN='Y' 인 버전만, 버전마다 아래 블록을 복사해 VERSION_NO 두 곳을 바꾸고 '-- ' 를 지워 실행
-- SET SERVEROUTPUT ON
-- DECLARE
--     rc    SYS_REFCURSOR;
--     msg   VARCHAR2(4000);
--     v_typ VARCHAR2(50);
-- BEGIN
--     SELECT VERSION_TYPE INTO v_typ FROM DM_MDF_VERSION WHERE DIVISION_ID = '40' AND VERSION_NO = 'R_S_20261008_V004_C';
--     PKG_DMF0044.P_DMF0044_MOBILE_REPORT_CREATE('40', 'R_S_20261008_V004_C', v_typ, 'T', 'admin', rc);
--     FETCH rc INTO msg; CLOSE rc;
--     DBMS_OUTPUT.PUT_LINE('결과 → ' || msg);   -- 'success' 이어야 정상
-- END;
-- /
