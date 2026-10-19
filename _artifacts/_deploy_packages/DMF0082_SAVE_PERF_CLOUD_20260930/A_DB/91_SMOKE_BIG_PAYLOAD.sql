-- 91_SMOKE_BIG_PAYLOAD.sql — 32,767B 초과 페이로드 수용 확인 (선택 · 데이터 무변경)
--  40 행 2,500개 + 마지막 1행 division 81 → 파싱 완주 후 V81-00 '복수 Division' 검증으로 RESULT_CODE='F' 종료.
--  영구 테이블 DML 이전 종료 · ROLLBACK · 로그(SCM_SYS_LOG_BATCH)만 남음 — 파싱 루프가 행마다 1행(A00E) 기록하므로 약 2,500행.
--  기대 출력: MAX_PARAM_BYTES > 32767 · RESULT_CODE=F · RESULT_MSG=복수 Division ... (적용 전이면 ORA-06502 등 바인드/인자 오류)
--  ⚠ 사내에서도 이 스모크는 아직 실행하지 못했다(도구 권한 차단) — 첫 실행 결과를 공유 요망.
SET SERVEROUTPUT ON
DECLARE
  n_rows CONSTANT PLS_INTEGER := 2500;  -- ITEM 파라미터 약 40KB (> 32,767B)
  c_af CLOB; c_dv CLOB; c_pj CLOB; c_ec CLOB; c_ss CLOB; c_it CLOB; c_de CLOB; c_ft CLOB; c_ic CLOB;
  c_ms CLOB; c_ps CLOB; c_cp CLOB; c_yd CLOB; c_cu CLOB; c_qt CLOB; c_cb CLOB; c_as CLOB;
  rc SYS_REFCURSOR; v1 VARCHAR2(4000); v2 VARCHAR2(4000); v3 VARCHAR2(4000);
  PROCEDURE ap(c IN OUT NOCOPY CLOB, v VARCHAR2, is_first BOOLEAN) IS
  BEGIN
    IF NOT is_first THEN DBMS_LOB.WRITEAPPEND(c, 1, '^'); END IF;
    IF v IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(c, LENGTH(v), v); END IF;
  END;
BEGIN
  DBMS_LOB.CREATETEMPORARY(c_af, TRUE); DBMS_LOB.CREATETEMPORARY(c_dv, TRUE); DBMS_LOB.CREATETEMPORARY(c_pj, TRUE);
  DBMS_LOB.CREATETEMPORARY(c_ec, TRUE); DBMS_LOB.CREATETEMPORARY(c_ss, TRUE); DBMS_LOB.CREATETEMPORARY(c_it, TRUE);
  DBMS_LOB.CREATETEMPORARY(c_de, TRUE); DBMS_LOB.CREATETEMPORARY(c_ft, TRUE); DBMS_LOB.CREATETEMPORARY(c_ic, TRUE);
  DBMS_LOB.CREATETEMPORARY(c_ms, TRUE); DBMS_LOB.CREATETEMPORARY(c_ps, TRUE); DBMS_LOB.CREATETEMPORARY(c_cp, TRUE);
  DBMS_LOB.CREATETEMPORARY(c_yd, TRUE); DBMS_LOB.CREATETEMPORARY(c_cu, TRUE); DBMS_LOB.CREATETEMPORARY(c_qt, TRUE);
  DBMS_LOB.CREATETEMPORARY(c_cb, TRUE); DBMS_LOB.CREATETEMPORARY(c_as, TRUE);
  FOR i IN 1..n_rows + 1 LOOP
    ap(c_af, 'M', i = 1);
    ap(c_dv, CASE WHEN i <= n_rows THEN '40' ELSE '81' END, i = 1);   -- 마지막 1행 81 → V81-00 복수 Division 'F'
    ap(c_pj, 'SMOKE_PRJ', i = 1);           ap(c_ec, 'SMOKE_EC', i = 1);
    ap(c_ss, 'SMOKE_SITE', i = 1);          ap(c_it, 'SMOKE_ITEM_' || i, i = 1);
    ap(c_de, 'E', i = 1);                   ap(c_ft, 'MPS', i = 1);
    ap(c_ic, 'DDP', i = 1);                 ap(c_ms, 'LOC', i = 1);
    ap(c_ps, '-', i = 1);                   ap(c_cp, 'SMOKE_CP', i = 1);
    ap(c_yd, TO_CHAR(DATE '2027-01-01' + MOD(i, 300), 'YYYYMMDD'), i = 1);
    ap(c_cu, 'USD', i = 1);                 ap(c_qt, '1', i = 1);
    ap(c_cb, 'SMOKE_TEST', i = 1);          ap(c_as, NULL, i = 1);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('ROWS=' || (n_rows + 1) || ' MAX_PARAM_BYTES(ITEM)=' || DBMS_LOB.GETLENGTH(c_it));
  SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA(c_af, c_dv, c_pj, c_ec, c_ss, c_it, c_de, c_ft, c_ic, c_ms, c_ps, c_cp,
                                               c_yd, c_cu, c_qt, c_cb, c_as, rc);
  FETCH rc INTO v1, v2, v3; CLOSE rc;
  DBMS_OUTPUT.PUT_LINE('RESULT_CODE=' || v1 || ' RESULT_MSG=' || v2 || ' EVENT=' || v3);
  DBMS_OUTPUT.PUT_LINE(CASE WHEN v1 = 'F' AND v2 LIKE '%Division%' THEN 'PASS (32K 초과 수용 · 검증 단계 정상 종료)' ELSE '❌ 확인 필요' END);
END;
/
