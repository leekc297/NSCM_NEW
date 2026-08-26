--==============================================================================
-- 95_FIX_CLOUD_EMPTY_SPW_VERSION.sql — 빈 껍데기 SP_W_20260806_V001(40) 버전 행 정리
--
-- 근거 (93/94 실측): 클라우드 QA 는 SP_W_20260728_V001 까지 원장 정상(58,798행).
--   08-06 배치가 DM_MST_VERSION 행만 만들고 원장(DM_PLN_SALES_PLAN_C) 적재 실패(0행).
--   빈 버전이 MAX(VERSION_NO) 를 차지해 정상 07-28 버전을 가림 → Excel Form 0건 → MSG00656.
-- 조치: 빈 버전 행 1건 삭제 → MAX 가 07-28 로 복귀 → 즉시 정상화.
--   (근본 조치 별건: 주간 배치가 08-06 이후 중단 — 배치 담당 확인 필요. §마지막 참고)
--
-- ⚠ 실행 전 [S1] 참조 스윕 결과가 "전부 0" 인 것을 확인한 뒤에만 [S3] 삭제를 실행.
-- ⚠ QA·DEV 양쪽 각각 실행.
--==============================================================================
SET LINESIZE 200 PAGESIZE 200 SERVEROUTPUT ON TRIMSPOOL ON

PROMPT ===== [S0] 환경 =====
SELECT SYS_CONTEXT('USERENV','DB_NAME') AS DB_NAME FROM DUAL;

PROMPT ===== [S1] 참조 전수 스윕 — VERSION_NO 컬럼 보유 DM% 테이블에서 해당 버전 행수 (기대: 전부 0) =====
DECLARE
    v_cnt NUMBER;
    v_sql VARCHAR2(1000);
BEGIN
    FOR t IN (SELECT TABLE_NAME
                FROM ALL_TAB_COLUMNS
               WHERE OWNER='SCM_MGR' AND COLUMN_NAME='VERSION_NO'
                 AND TABLE_NAME LIKE 'DM%' AND TABLE_NAME NOT LIKE 'GT%'
               ORDER BY TABLE_NAME) LOOP
        v_sql := 'SELECT COUNT(*) FROM SCM_MGR.' || t.TABLE_NAME ||
                 ' WHERE VERSION_NO = ''SP_W_20260806_V001''';
        BEGIN
            EXECUTE IMMEDIATE v_sql INTO v_cnt;
            IF v_cnt > 0 THEN
                DBMS_OUTPUT.PUT_LINE('  ⚠ ' || t.TABLE_NAME || ' = ' || v_cnt || ' 행 (0 아님 — 삭제 중단, 결과 회신)');
            END IF;
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('  ! ' || t.TABLE_NAME || ' 조회 실패: ' || SQLERRM);
        END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('  [S1] 스윕 완료 — 위에 ⚠ 출력이 없으면 참조 0 (DM_MST_VERSION 자기 행 제외)');
END;
/

PROMPT ===== [S2] 삭제 대상 행 백업 출력 (이 출력을 보관 — 원복 시 사용) =====
SELECT * FROM SCM_MGR.DM_MST_VERSION
 WHERE DIVISION_ID='40' AND VERSION_TYPE='SP_W' AND VERSION_NO='SP_W_20260806_V001';

PROMPT ===== [S3] 빈 버전 행 삭제 (S1 전부 0 확인 후에만!) =====
DELETE FROM SCM_MGR.DM_MST_VERSION
 WHERE DIVISION_ID='40' AND VERSION_TYPE='SP_W' AND VERSION_NO='SP_W_20260806_V001';
-- 기대: 1 행이 삭제되었습니다.
COMMIT;

PROMPT ===== [S4] 사후 검증 — MAX 버전이 07-28(원장 58,798행 보유)로 복귀했는지 =====
SELECT MAX(VERSION_NO) AS MAX_VER
  FROM SCM_MGR.DM_MST_VERSION
 WHERE DIVISION_ID='40' AND VERSION_TYPE='SP_W';

PROMPT ===== [S5] 사후 검증 — 템플릿 깔때기 s1 재현 (기대: > 0) =====
WITH TEMP_VERSION_NO AS (
    SELECT A.DIVISION_ID, A.VERSION_NO, A.YYYYMMDD
         , TO_CHAR(SCM_MGR.FN_NEXT_DAY(A.YYYYMMDD, 'MON') - 7, 'YYYYMMDD')                AS RESULT_TO
         , TO_CHAR(SCM_MGR.FN_NEXT_DAY(A.YYYYMMDD, 'MON') - 7 + (52 * 7) - 1, 'YYYYMMDD') AS PLAN_TO
    FROM (SELECT DIVISION_ID, MAX(VERSION_NO) AS VERSION_NO, MAX(YYYYMMDD) AS YYYYMMDD
            FROM SCM_MGR.DM_MST_VERSION
           WHERE DIVISION_ID='40' AND VERSION_TYPE='SP_W'
           GROUP BY DIVISION_ID) A
    INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON B.BASIS_YYYYMMDD = A.YYYYMMDD
)
SELECT COUNT(*) AS S1_LEDGER
  FROM SCM_MGR.DM_PLN_SALES_PLAN_C SP
 INNER JOIN TEMP_VERSION_NO T_VER
         ON SP.DIVISION_ID=T_VER.DIVISION_ID AND SP.VERSION_NO=T_VER.VERSION_NO
 WHERE SP.DIVISION_ID='40' AND SP.QTY <> 0 AND SP.MEASURE='RTF_SYS_RP'
   AND SP.YYYYMMDD >= T_VER.RESULT_TO AND SP.YYYYMMDD <= T_VER.PLAN_TO;

--==============================================================================
-- 완료 후: 화면에서 40 division Excel Form 조회 재시도 → 그리드 행이 떠야 정상.
--
-- [근본 조치 — 배치 담당 전달 사항]
--  · 주간 SP_W 스냅샷 배치가 2026-08-06 이후 미수행 (그 전은 07-16/21/24/28 주기 수행, CREATED_BY='system').
--  · 08-06 회차는 버전 생성 단계만 성공, 원장 백업 단계(PR_DM_LONGPLAN_40_BACKUP 계열) 실패.
--  · 배치 로그 확인: SELECT * FROM SCM_MGR.SCM_COM_SYS_LOG
--       WHERE EVENT_DATE BETWEEN TO_DATE('2026-08-06 10:30','YYYY-MM-DD HH24:MI')
--                            AND TO_DATE('2026-08-06 11:30','YYYY-MM-DD HH24:MI')
--       ORDER BY EVENT_DATE;  -- 실패 사유(EXCT_MSG_CTN) 확보
--  · 배치 재개 시 다음 주기부터 새 버전이 최신이 되어 본 정리는 자연 소급됨.
--==============================================================================
