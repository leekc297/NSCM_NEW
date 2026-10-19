"""sqlscan 분류기 단위 시험 — 손작성 표본으로 role / 컬럼 특정 기대값 대조.  python test_sqlscan.py"""
import sys
from sqlscan import Scanner

CAT = {
    "T_SALES": {"kind": "real", "cols": {"FCST_TYPE", "DEPT_ID", "ITEM_ID", "QTY", "INCOTERMS"}, "order": ["ITEM_ID", "FCST_TYPE", "DEPT_ID", "QTY", "INCOTERMS"]},
    "T_ITEM": {"kind": "real", "cols": {"ITEM_ID", "ITEM_NM", "DEPT_ID"}, "order": ["ITEM_ID", "ITEM_NM", "DEPT_ID"]},
    "T_OTHER": {"kind": "real", "cols": {"FCST_TYPE", "X"}, "order": ["FCST_TYPE", "X"]},
    "GTT_STG": {"kind": "gtt", "cols": {"FCST_TYPE", "DEPT_ID", "ITEM_ID"}, "order": ["ITEM_ID", "FCST_TYPE", "DEPT_ID"]},
}
POP = {"T_SALES": {"FCST_TYPE", "DEPT_ID", "INCOTERMS"}, "T_ITEM": {"DEPT_ID"}}

CASES = [
    # (dialect, sql, [(role, {(table,col,tier)} refs, {(table,col,tier)} dest)])
    ("tsql", "SELECT CASE WHEN R.FCST_TYPE = '-' THEN '' ELSE R.FCST_TYPE END FROM T_SALES R",
     [("BRANCH", {("T_SALES", "FCST_TYPE", "확정")}, set())]),
    ("tsql", "SELECT * FROM T_SALES A WHERE A.DEPT_ID = '-'",
     [("PREDICATE", {("T_SALES", "DEPT_ID", "확정")}, set())]),
    ("tsql", "SELECT ISNULL(A.DEPT_ID,'-') AS DEPT_ID FROM T_SALES A",
     [("NVL", {("T_SALES", "DEPT_ID", "확정")}, set())]),
    ("tsql", "SELECT 1 FROM T_SALES A JOIN T_ITEM B ON ISNULL(A.DEPT_ID,'-') = ISNULL(B.DEPT_ID,'-')",
     [("NVL_CMP", {("T_SALES", "DEPT_ID", "확정"), ("T_ITEM", "DEPT_ID", "확정")}, set()),
      ("NVL_CMP", {("T_SALES", "DEPT_ID", "확정"), ("T_ITEM", "DEPT_ID", "확정")}, set())]),
    ("tsql", "IF @FCST_TYPE = '-' SET @X = 1 SELECT 1 FROM T_SALES",
     [("BRANCH", {("T_SALES", "FCST_TYPE", "변수")}, set())]),
    ("tsql", "SELECT A.ITEM_ID + '-' + A.DEPT_ID FROM T_SALES A", [("NON_SENTINEL", set(), set())]),
    ("tsql", "SELECT REPLACE(A.ITEM_ID,'-','') FROM T_SALES A", [("NON_SENTINEL", set(), set())]),
    ("tsql", "INSERT INTO T_SALES (ITEM_ID, FCST_TYPE, DEPT_ID) SELECT A.ITEM_ID, '-', ISNULL(A.DEPT_ID,'-') FROM T_ITEM A",
     [("LOAD", set(), {("T_SALES", "FCST_TYPE", "확정")}), ("NVL", {("T_ITEM", "DEPT_ID", "확정")}, {("T_SALES", "DEPT_ID", "확정")})]),
    ("tsql", "UPDATE A SET A.FCST_TYPE = '-' FROM T_SALES A WHERE A.QTY = 0",
     [("ASSIGN", set(), {("T_SALES", "FCST_TYPE", "확정")})]),
    ("tsql", "SELECT * FROM T_SALES WHERE FCST_TYPE IN ('A','-')",
     [("PREDICATE", {("T_SALES", "FCST_TYPE", "확정")}, set())]),
    ("tsql", "SELECT CASE A.FCST_TYPE WHEN '-' THEN 'N' ELSE 'Y' END FROM T_SALES A",
     [("BRANCH", {("T_SALES", "FCST_TYPE", "확정")}, set())]),
    ("tsql", "SELECT * FROM #TMP T WHERE T.FCST_TYPE <> '-'\nSELECT 1 FROM T_SALES",
     [("PREDICATE", {("T_SALES", "FCST_TYPE", "간접")}, set())]),
    ("tsql", "IF EXISTS (SELECT 1 FROM T_SALES WHERE DEPT_ID = '-') BEGIN SELECT 1 END",
     [("PREDICATE", {("T_SALES", "DEPT_ID", "확정")}, set())]),
    ("tsql", "SELECT CASE WHEN ISNULL(A.DEPT_ID,'-') = '-' THEN 1 ELSE 0 END FROM T_SALES A",
     [("NVL_CMP", {("T_SALES", "DEPT_ID", "확정")}, set()), ("BRANCH", {("T_SALES", "DEPT_ID", "확정")}, set())]),
    ("tsql", "SELECT CASE WHEN A.QTY = 0 THEN '-' ELSE A.FCST_TYPE END AS FCST_TYPE FROM T_SALES A",
     [("CASE_VALUE", {("T_SALES", "FCST_TYPE", "확정")}, set())]),
    ("tsql", "SELECT * FROM T_SALES A, T_OTHER B WHERE FCST_TYPE = '-'",
     [("PREDICATE", {("T_SALES", "FCST_TYPE", "추정")}, set())]),
    ("tsql", "SET @SQL = 'SELECT * FROM T_SALES A WHERE A.DEPT_ID = ''-'''",
     [("PREDICATE", {("T_SALES", "DEPT_ID", "확정")}, set())]),
    ("tsql", "DECLARE @A VARCHAR(10) = '-'", [("ASSIGN", None, None)]),
    ("tsql", "SELECT CASE WHEN SUBSTRING(A.ITEM_ID,13,1) != '-' THEN 1 END FROM T_SALES A", [("NON_SENTINEL", set(), set())]),
    ("tsql", "SET @Q = @Q + ' SELECT CASE WHEN A.FCST_TYPE=''-'' THEN ''-'' ELSE A.DEPT_ID END '\nSET @Q = @Q + ' FROM T_SALES A '",
     [("BRANCH", {("T_SALES", "FCST_TYPE", "추정")}, set()), ("CASE_VALUE", None, None)]),
    ("tsql", "SELECT CASE WHEN A.QTY = 0 THEN '-' ELSE A.ITEM_ID END FROM T_SALES A", [("CASE_VALUE", set(), set())]),
    ("tsql", "SELECT ISNULL(dbo.FN_X(A.DEPT_ID, A.FCST_TYPE),'-') AS NM FROM T_SALES A", [("NVL", set(), set())]),
    ("tsql", "SELECT * FROM T_SALES A WHERE dbo.FN_X(A.DEPT_ID) = '-'", [("PREDICATE", set(), set())]),
    ("tsql", "SELECT ISNULL((SELECT MAX(B.DEPT_ID) FROM T_ITEM B WHERE B.ITEM_ID = A.ITEM_ID),'-') FROM T_SALES A",
     [("NVL", {("T_ITEM", "DEPT_ID", "확정")}, set())]),
    ("plsql", "V_SEQ := TO_NUMBER(FN_SCM_SPLIT(V_REV, 3, '-'));", [("NON_SENTINEL", None, None)]),
    # PL/SQL
    ("plsql", "INSERT INTO T_SALES (ITEM_ID, FCST_TYPE, DEPT_ID) SELECT G.ITEM_ID, NVL(G.FCST_TYPE,'-'), NVL(P_DEPT_ID,'-') FROM GTT_STG G;",
     [("NVL", None, {("T_SALES", "FCST_TYPE", "확정")}), ("NVL", None, {("T_SALES", "DEPT_ID", "확정")})]),
    ("plsql", "IF V_FCST_TYPE = '-' THEN V_X := 1; END IF;", [("BRANCH", None, None)]),
    ("plsql", "V_DEPT := NVL(P_DEPT_ID, '-');", [("NVL", None, None)]),
    ("plsql", "SELECT COUNT(*) INTO V_CNT FROM T_SALES A WHERE NVL(A.DEPT_ID,'-') = NVL(P_DEPT_ID,'-') AND A.FCST_TYPE IN ('-','--');",
     [("NVL_CMP", {("T_SALES", "DEPT_ID", "확정")}, set()), ("NVL_CMP", None, None), ("PREDICATE", {("T_SALES", "FCST_TYPE", "확정")}, set())]),
    ("plsql", "MERGE INTO T_SALES T USING (SELECT ITEM_ID, FCST_TYPE FROM GTT_STG) S ON (T.ITEM_ID = S.ITEM_ID AND NVL(T.FCST_TYPE,'-') = NVL(S.FCST_TYPE,'-')) "
              "WHEN MATCHED THEN UPDATE SET T.DEPT_ID = NVL(S.FCST_TYPE,'-') WHEN NOT MATCHED THEN INSERT (ITEM_ID, DEPT_ID) VALUES (S.ITEM_ID, '-');",
     [("NVL_CMP", None, set()), ("NVL_CMP", None, None),
      ("NVL", None, {("T_SALES", "DEPT_ID", "확정")}), ("LOAD", set(), {("T_SALES", "DEPT_ID", "확정")})]),
    ("plsql", "UPDATE T_SALES SET DEPT_ID = NVL(P_DEPT, '-') WHERE ITEM_ID = P_ITEM;",
     [("NVL", None, {("T_SALES", "DEPT_ID", "확정")})]),
    ("plsql", "V_SQL := 'SELECT A.ITEM_ID FROM T_SALES A WHERE NVL(A.DEPT_ID,''-'') = ''-''';",
     [("NVL_CMP", {("T_SALES", "DEPT_ID", "확정")}, set()), ("PREDICATE", None, None)]),
    ("plsql", "SELECT DECODE(A.FCST_TYPE,'-',NULL,A.FCST_TYPE), NULLIF(A.DEPT_ID,'-') FROM T_SALES A;",
     [("BRANCH", {("T_SALES", "FCST_TYPE", "확정")}, set()), ("BRANCH", {("T_SALES", "DEPT_ID", "확정")}, set())]),
    ("plsql", "SELECT A.ITEM_ID || '-' || A.DEPT_ID FROM T_SALES A;", [("NON_SENTINEL", set(), set())]),
    ("plsql", "SELECT CASE WHEN A.DEPT_ID IS NULL OR TRIM(A.DEPT_ID) IS NULL OR A.DEPT_ID IN ('-','--') THEN '-' ELSE A.DEPT_ID END FROM T_SALES A;",
     [("BRANCH", {("T_SALES", "DEPT_ID", "확정")}, set()), ("CASE_VALUE", {("T_SALES", "DEPT_ID", "확정")}, set())]),
]


def main():
    fail = 0
    for n, (dia, sql, exp) in enumerate(CASES, 1):
        sc = Scanner(CAT, POP, dialect=dia)
        got, _ = sc.scan(sql)
        ok = len(got) == len(exp)
        msgs = []
        if ok:
            for g, (role, refs, dest) in zip(got, exp):
                if g["role"] != role:
                    ok = False; msgs.append(f"role {g['role']} != {role}")
                if refs is not None and set(g["refs"]) != refs:
                    ok = False; msgs.append(f"refs {set(g['refs'])} != {refs}")
                if dest is not None and set(g["dest"]) != dest:
                    ok = False; msgs.append(f"dest {set(g['dest'])} != {dest}")
        else:
            msgs.append(f"count {len(got)} != {len(exp)}: {[g['role'] for g in got]}")
        print(("PASS" if ok else "FAIL"), n, dia, sql[:90].replace("\n", " "))
        if not ok:
            fail += 1
            for m in msgs:
                print("      ", m)
            for g in got:
                print("       got:", g["role"], g["detail"][:70], g["refs"], g["dest"], g["notes"][:3])
    print("FAILED", fail, "/", len(CASES))
    return fail


if __name__ == "__main__":
    sys.exit(1 if main() else 0)
