# -*- coding: utf-8 -*-
"""FN_CHK_QTY_DIGITS 상한 3 검증 — 적용된 함수 로직을 그대로 재현해 위반 N건별 출력 확인."""
import sys, pathlib, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb  # noqa: E402

# 적용된 SP 함수(L87~130)와 동일 로직을 익명블록으로 재현 (패키지 전역 G_T_* 대신 로컬 배열)
PLSQL = """
DECLARE
  TYPE T_TOK IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;
  G_T_QTY T_TOK; G_T_ITEM_ID T_TOK; G_T_MEASURE T_TOK; G_T_YYYYMMDD T_TOK; G_T_DEPT_NAME T_TOK;
  P_MAX PLS_INTEGER := 20;
  V_RAW VARCHAR2(4000 CHAR); V_NUM NUMBER; V_LIM NUMBER;
  V_CNT PLS_INTEGER := 0; V_DET VARCHAR2(3000 CHAR); V_KEY VARCHAR2(600 CHAR);
  N PLS_INTEGER := :n;
BEGIN
  FOR I IN 1 .. N LOOP
    G_T_QTY(I) := '12345678901234567890123';
    G_T_ITEM_ID(I) := 'MODEL-' || I; G_T_MEASURE(I) := 'MKT_FCST';
    G_T_YYYYMMDD(I) := '2026100' || MOD(I,10); G_T_DEPT_NAME(I) := 'DEPT-' || I;
  END LOOP;
  V_LIM := POWER(10, P_MAX);
  FOR I IN 1 .. G_T_QTY.COUNT LOOP
    V_RAW := TRIM(G_T_QTY(I));
    IF V_RAW IS NOT NULL THEN
      V_NUM := TO_NUMBER(REPLACE(REPLACE(V_RAW, ',', ''), ' ', '') DEFAULT NULL ON CONVERSION ERROR);
      IF V_NUM IS NOT NULL AND ABS(V_NUM) >= V_LIM THEN
        V_CNT := V_CNT + 1;
        IF V_CNT <= 3 THEN
          V_KEY := 'Model : '   || NVL(G_T_ITEM_ID(I), '-')   || CHR(10)
                || 'Measure : ' || NVL(G_T_MEASURE(I), '-')   || CHR(10)
                || '기간 : '    || NVL(G_T_YYYYMMDD(I), '-')  || CHR(10)
                || '부서 : '    || NVL(G_T_DEPT_NAME(I), '-') || CHR(10)
                || '입력값 '    || V_RAW;
          V_DET := V_DET || CHR(10) || CASE WHEN V_CNT > 1 THEN CHR(10) END || V_KEY;
        END IF;
      END IF;
    END IF;
  END LOOP;
  IF V_CNT = 0 THEN :out := NULL; RETURN; END IF;
  :out := '허용 가능한 자릿수를 초과하였습니다. 30자리(정수' || P_MAX || '자리) 이내로 입력하세요.'
       || V_DET
       || CASE WHEN V_CNT > 3 THEN CHR(10) || CHR(10) || '... 외 ' || (V_CNT - 3) || '건' END;
END;
"""

sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
m = re.search(r"CONN='([^/]+)/\"([^\"]+)\"@([^']+)'", sh.read_text(encoding="utf-8", errors="ignore"))
with oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)) as db:
    cur = db.cursor()
    for n in (1, 3, 6, 25):
        out = cur.var(oracledb.STRING, 4000)
        cur.execute(PLSQL, n=n, out=out)
        msg = out.getvalue() or ""
        print(f"===== 위반 {n}건 → 메시지 {len(msg.splitlines())}줄 =====")
        print(msg)
        print()
