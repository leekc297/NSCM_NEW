CREATE OR REPLACE PROCEDURE SCM_MGR."PR_SCM_MST_EXCHANGE_RATE_UI" (
    P_BATCH_YN      IN  VARCHAR2 DEFAULT 'N',
    O_RESULT_CURSOR OUT SYS_REFCURSOR
) AS
    V_ERR        VARCHAR2(200 CHAR);
    V_TARGET_CNT NUMBER;
BEGIN
    --[E20260915-BPSIFNODATA] 반영 대상 0건 안내 (사용자 지시 2026-09-15).
    --  공유 배치 PR_SCM_MST_EXCHANGE_RATE 는 대상이 없어도 오류 없이 끝나 이 래퍼가 항상 success 를 돌려줬고,
    --  화면은 "정상 반영" 토스트 후 값이 그대로여서 반영된 것으로 오인됐다(사내 XIF 0행 실측).
    --  → 배치 CUR_E 와 **동일 조건**으로 대상 건수를 먼저 세고, 0건이면 배치를 호출하지 않고 안내를 돌려준다.
    --  CODE <> '0' 이면 FE(ExchangeRateModal handleBpsIf)가 RESULT_MSG 를 Alert 로 표시한다 — FE 무변경.
    --  공유 배치 본문은 무수정(야간 배치 P_BATCH_YN='Y' 경로 영향 없음).
    IF P_BATCH_YN = 'Y' THEN
        SELECT COUNT(*)
          INTO V_TARGET_CNT
          FROM SCM_MGR.XIF_GSC_MOVE_EXCHANGE_RATE_SN E
         WHERE NVL(E.TRANSF_FLAG, 'N') = 'N'
           AND E.SCENARIO_TYPE_CD IN ('ML', 'RF');
    ELSE
        SELECT COUNT(*)
          INTO V_TARGET_CNT
          FROM SCM_MGR.XIF_GSC_MOVE_EXCHANGE_RATE_SN E
         WHERE E.TRANSF_DATE = (SELECT MAX(A.TRANSF_DATE)
                                  FROM SCM_MGR.XIF_GSC_MOVE_EXCHANGE_RATE_SN A
                                 WHERE A.SCENARIO_TYPE_CD IN ('ML', 'RF'))
           AND E.SCENARIO_TYPE_CD IN ('ML', 'RF');
    END IF;

    IF V_TARGET_CNT = 0 THEN
        OPEN O_RESULT_CURSOR FOR
            SELECT '1' AS CODE, '반영할 환율 정보가 없습니다' AS RESULT_MSG, CAST(NULL AS VARCHAR2(200 CHAR)) AS EVENT FROM DUAL;
        RETURN;
    END IF;

    SCM_MGR.PR_SCM_MST_EXCHANGE_RATE(P_BATCH_YN);
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'success' AS RESULT_MSG, CAST(NULL AS VARCHAR2(200 CHAR)) AS EVENT FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
        V_ERR := SUBSTR(SQLERRM, 1, 200);
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR
            SELECT '9' AS CODE, 'fail' AS RESULT_MSG, V_ERR AS EVENT FROM DUAL;
END PR_SCM_MST_EXCHANGE_RATE_UI;
/
