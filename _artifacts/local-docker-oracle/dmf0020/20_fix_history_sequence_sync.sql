-- =====================================================================================
-- DMF0020 저장 블로커: 이력 시퀀스 동기화 (2026-06-27)
--   증상: div81/82 LOC 저장 시 ORA-20001 ← ORA-00001 PK_SCM_MST_FUTURE_PRICE_H(HISTORY_SEQ) 위반
--         (SP DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL L799/L821 H이력 INSERT)
--   원인: SEQ1_SCM_MST_FUTURE_PRICE_H.LAST_NUMBER(101) << MAX(HISTORY_SEQ)(156,247)
--         → CSV/seed 적재가 HISTORY_SEQ 값만 넣고 시퀀스 미전진 → NEXTVAL 충돌.
--   조치: 시퀀스를 MAX(HISTORY_SEQ)+여유 로 RESTART (Oracle 19c). 시퀀스는 전진만 = 무손실.
-- 멱등: 재실행해도 항상 현재 MAX 기준 재정렬. 적용: python ora.py exec <this>
-- =====================================================================================
DECLARE
  v_next NUMBER;
BEGIN
  SELECT NVL(MAX(HISTORY_SEQ), 0) + 1000 INTO v_next FROM SCM_MGR.SCM_MST_FUTURE_PRICE_H;
  EXECUTE IMMEDIATE 'ALTER SEQUENCE SCM_MGR.SEQ1_SCM_MST_FUTURE_PRICE_H RESTART START WITH ' || v_next;
  DBMS_OUTPUT.PUT_LINE('SEQ1_SCM_MST_FUTURE_PRICE_H restarted at ' || v_next);
END;
/
