"""DMF0082 저장 검증 #10 (Sales Price 52주) — Project Code 불일치 품목 누락 보완 [E20260915-PRICEPJTGAP].
usage: python apply_sp.py backup|apply|verify
  backup : 현재 PKG_DMF0082 BODY → 00_BACKUP_ASIS/ , 치환본 → 01_APPLY/ (DB 무변경)
  apply  : 게이트(현재 BODY == 백업) 통과 시 배포 → STATUS / ERRORS / 배포본 대조
  verify : ASIS·TOBE 본문의 #10 SELECT 원문을 추출해 세션 GTT 에 대상 키를 적재 후 실행 비교 (ROLLBACK — DB 무변경)
"""
import pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora  # noqa: E402

ASIS = HERE / "00_BACKUP_ASIS" / "PKG_DMF0082_BODY.ASIS.sql"
TOBE = HERE / "01_APPLY" / "PKG_DMF0082_BODY.sql"

# ① #10 의 INNER JOIN SCM_MST_SITE_ITEM Z (Project Code 일치 행만 검사 대상) — 공백 변형 허용 매칭
JOIN_RE = re.compile(
    r"(?P<from>FROM SCM_MGR\.GT_PRDM1_T_MAIN A\s*\n)"
    r"(?P<indent>[ \t]*)INNER JOIN SCM_MGR\.SCM_MST_SITE_ITEM Z\s*\n"
    r"\s*ON A\.DIVISION_ID\s*=\s*Z\.DIVISION_ID\s*\n"
    r"\s*AND A\.PROJECT_CODE\s*=\s*Z\.PROJECT_CODE\s*\n"
    r"\s*AND A\.SCM_SITE_ID\s*=\s*Z\.SCM_SITE_ID\s*\n"
    r"\s*AND A\.ITEM_ID\s*=\s*Z\.ITEM_ID\s*\n"
    r"\s*AND Z\.VALID_YN\s*=\s*'Y'\s*\n"
    r"\s*AND \(Z\.SALES_PLAN_ADJUST_YN = 'Y' OR Z\.SALES_PLAN_ADJUST_YN IS NULL\)\s*\n"
)
# ② 같은 SELECT 의 WHERE — QTY_PRICE 조건 직후에 NOT EXISTS 삽입
WHERE_RE = re.compile(
    r"(?P<head>WHERE P\.YYYYMMDD IS NULL[^\n]*\n"
    r"(?P<indent>[ \t]*)AND A\.MEASURE IN \(SELECT SEGMENT2 FROM SCM_MGR\.GT_PRDM1_MSHYCHU1\)\s*\n"
    r"[ \t]*AND A\.QTY_PRICE <> 0\s*\n)"
)
# 대상 = 동일 판정식 2곳 (P_DMF0082_EXCEL_UPLOAD 행별 오류 분류 / P_DMF0082_SAVE_MAIN_DATA 검증 #10)
EXPECTED_SITES = 2


def patch(body: str) -> str:
    joins = list(JOIN_RE.finditer(body))
    assert len(joins) == EXPECTED_SITES, f"JOIN 매칭 {len(joins)}건 (기대 {EXPECTED_SITES})"
    # 각 JOIN 바로 뒤(다음 JOIN 이전)의 WHERE 1건을 쌍으로 확정
    pairs = []
    for i, j in enumerate(joins):
        limit = joins[i + 1].start() if i + 1 < len(joins) else len(body)
        w = WHERE_RE.search(body, j.end(), limit)
        assert w, f"JOIN#{i + 1} 뒤 WHERE 미발견"
        assert body.count("SELECT", j.end(), w.start()) <= 3, f"JOIN#{i + 1}~WHERE 사이 SELECT 과다 — 다른 문장 의심"
        pairs.append((j, w))

    out, pos = [], 0
    for j, w in pairs:
        ind_j, ind_w = j.group("indent"), w.group("indent")
        out.append(body[pos:j.start()])
        out.append(j.group("from")
                   + f"{ind_j}--[E20260915-PRICEPJTGAP] INNER JOIN SCM_MST_SITE_ITEM(Project Code 일치 행만 검사) 제거 → 아래 WHERE NOT EXISTS 로 전환.\n"
                   + f"{ind_j}--  종전(=AS-IS DMF0082_SAVE_MAIN_DATA L1185-1191 동일)에는 #5 Site/Item 검증이 Site+Model 로만 통과시키고\n"
                   + f"{ind_j}--  여기서는 Project 까지 맞는 마스터 행이 있어야 검사해, 다른 Project 로만 등록된 품목이 Unit Price 없이 저장됐다.\n"
                   + f"{ind_j}--  사용자 지시(2026-09-15): 이 경우도 누락되지 않도록 — AS-IS 대비 의도적 강화.\n")
        out.append(body[j.end():w.start()])
        out.append(w.group("head")
                   + f"{ind_w}--[E20260915-PRICEPJTGAP] 전 행 검사 기본 — 마스터(Division+Project+Site+Model)에서\n"
                   + f"{ind_w}--  판매계획 조정 제외(SALES_PLAN_ADJUST_YN='N')로 명시된 경우만 제외(종전 제외 규칙 보존).\n"
                   + f"{ind_w}AND NOT EXISTS (SELECT 1\n"
                   + f"{ind_w}                  FROM SCM_MGR.SCM_MST_SITE_ITEM Z\n"
                   + f"{ind_w}                 WHERE Z.DIVISION_ID  = A.DIVISION_ID\n"
                   + f"{ind_w}                   AND Z.PROJECT_CODE = A.PROJECT_CODE\n"
                   + f"{ind_w}                   AND Z.SCM_SITE_ID  = A.SCM_SITE_ID\n"
                   + f"{ind_w}                   AND Z.ITEM_ID      = A.ITEM_ID\n"
                   + f"{ind_w}                   AND Z.VALID_YN     = 'Y'\n"
                   + f"{ind_w}                   AND Z.SALES_PLAN_ADJUST_YN = 'N')\n")
        pos = w.end()
    out.append(body[pos:])
    new = "".join(out)
    assert not JOIN_RE.search(new), "치환 후 INNER JOIN 잔존"
    return new


def current_body(cur):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    return "".join(r[0] for r in cur.fetchall())


def ddl(body):
    head, rest = body.split("\n", 1)
    assert head.strip().upper().startswith("PACKAGE BODY"), head[:80]
    name = head.strip()[len("PACKAGE BODY"):].strip()
    if not name.upper().startswith("SCM_MGR."):
        name = "SCM_MGR." + name
    return "CREATE OR REPLACE PACKAGE BODY " + name + "\n" + rest


def extract_check_select(text: str) -> str:
    """#10 SELECT 원문 (INTO 제거)."""
    s = text.index("SELECT 'End Customer________ : '")
    # 내부 스칼라 서브쿼리에도 FETCH FIRST 가 있으므로 문장 종결(;) 이 붙은 바깥 것을 찾는다
    e = text.index("FETCH FIRST 1 ROWS ONLY;", s) + len("FETCH FIRST 1 ROWS ONLY")
    return re.sub(r"\n\s*INTO s_unit_price_valid\s*\n", "\n", text[s:e], count=1)


KEYS_SQL = """
WITH K AS (
  SELECT DISTINCT F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.CELL_PROD_SITE_ID,
         F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, 'KRW' AS CURRENCY  -- 원장에 CURRENCY 없음 · #10 판정 무관
    FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F
   WHERE F.DIVISION_ID='40' AND F.MEASURE='MKT_FCST' AND F.QTY<>0
     AND F.FCST_TYPE NOT IN (SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                              WHERE LOOKUP_TYPE='MKT_FCST_VALIDATION_PRICE' AND SEGMENT1='FCST_TYPE' AND VALID_YN='Y'))
SELECT K.* FROM K
 WHERE EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE_ITEM Z WHERE Z.DIVISION_ID=K.DIVISION_ID AND Z.SCM_SITE_ID=K.SCM_SITE_ID AND Z.ITEM_ID=K.ITEM_ID AND Z.VALID_YN='Y')
   AND NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE_ITEM Z WHERE Z.DIVISION_ID=K.DIVISION_ID AND Z.PROJECT_CODE=K.PROJECT_CODE
                     AND Z.SCM_SITE_ID=K.SCM_SITE_ID AND Z.ITEM_ID=K.ITEM_ID AND Z.VALID_YN='Y'
                     AND (Z.SALES_PLAN_ADJUST_YN='Y' OR Z.SALES_PLAN_ADJUST_YN IS NULL))
"""
REGRESSION_KEY_SQL = KEYS_SQL.replace(" AND NOT EXISTS", " AND EXISTS").replace(
    "AND (Z.SALES_PLAN_ADJUST_YN='Y' OR Z.SALES_PLAN_ADJUST_YN IS NULL))",
    "AND (Z.SALES_PLAN_ADJUST_YN='Y' OR Z.SALES_PLAN_ADJUST_YN IS NULL))\n FETCH FIRST 3 ROWS ONLY")


def run_check(cur, key, select_sql):
    cur.execute("DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN")
    cur.execute("DELETE FROM SCM_MGR.GT_PRDM1_T_PRICE")
    cur.execute("DELETE FROM SCM_MGR.GT_PRDM1_MSHYCHU1")
    cur.execute("DELETE FROM SCM_MGR.GT_PRDM1_MSHYCHU2")
    cur.execute("""INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU1 (SEGMENT2) SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                   WHERE LOOKUP_TYPE='MKT_FCST_VALIDATION_PRICE' AND SEGMENT1='MEASURE' AND VALID_YN='Y'""")
    cur.execute("""INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU2 (SEGMENT2) SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                   WHERE LOOKUP_TYPE='MKT_FCST_VALIDATION_PRICE' AND SEGMENT1='FCST_TYPE' AND VALID_YN='Y'""")
    (div, pjt, ec, site, plant, cps, item, dom, ft, inco, curr) = key
    cur.execute("""INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
                     (ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE,
                      PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY)
                   VALUES ('M', :1, :2, :3, :4, :5, :6, :7, :8, 'MKT_FCST', :9, :10,
                           TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON'),'YYYYMMDD'), :11, 10, 'verify')""",
                [div, pjt, ec, site, item, dom, ft, inco, plant, cps, curr])
    # SP 1.2) 와 동일 — DB 판가(LOC) 52주 수집
    cur.execute("""INSERT INTO SCM_MGR.GT_PRDM1_T_PRICE
                     (DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID,
                      YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE)
                   SELECT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.ITEM_ID,
                          B.YYYYMMDD, B.CURRENCY, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, SUM(B.PRICE)
                     FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE B
                    WHERE B.DIVISION_ID=:1 AND B.PROJECT_CODE=:2 AND B.END_CUSTOMER=:3 AND B.SCM_SITE_ID=:4 AND B.PLANT_SITE_ID=:5
                      AND B.CELL_PROD_SITE_ID=:6 AND B.ITEM_ID=:7 AND B.DOM_EXP=:8 AND B.FCST_TYPE=:9 AND B.INCOTERMS=:10
                      AND B.MEASURE='LOC' AND B.PRICE<>0
                      AND B.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
                      AND B.YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7 + 52*7, 'YYYYMMDD')
                    GROUP BY B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.ITEM_ID,
                             B.YYYYMMDD, B.CURRENCY, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS""",
                [div, pjt, ec, site, plant, cps, item, dom, ft, inco])
    cur.execute(select_sql)
    r = cur.fetchone()
    return "BLOCK" if r and r[0] else "PASS"


def main():
    mode = sys.argv[1]
    import oracledb
    u, p, d = ora.conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        if mode == "backup":
            body = current_body(cur)
            new = patch(body)
            ASIS.parent.mkdir(parents=True, exist_ok=True)
            TOBE.parent.mkdir(parents=True, exist_ok=True)
            ASIS.write_text(ddl(body) + "\n/\n", encoding="utf-8")
            TOBE.write_text(ddl(new) + "\n/\n", encoding="utf-8")
            print("backup lines", body.count("\n"), "-> patched lines", new.count("\n"))
        elif mode == "apply":
            assert ddl(current_body(cur)) + "\n/\n" == ASIS.read_text(encoding="utf-8"), "게이트 실패: 현재 BODY != 백업본 — 중단"
            tobe = TOBE.read_text(encoding="utf-8")
            cur.execute(tobe.rstrip().rstrip("/").rstrip())
            cur.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082'")
            print(cur.fetchall())
            cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' ORDER BY SEQUENCE")
            print("errors:", cur.fetchall() or 0)
            print("applied == TOBE:", ddl(current_body(cur)) + "\n/\n" == tobe)
        elif mode == "verify":
            old_sql = extract_check_select(ASIS.read_text(encoding="utf-8"))
            new_sql = extract_check_select(ddl(current_body(cur)))  # 배포본 원문
            cur.execute(KEYS_SQL)
            gap_keys = cur.fetchall()
            cur.execute(REGRESSION_KEY_SQL)
            reg_keys = cur.fetchall()
            print(f"gap keys(4번 대상)={len(gap_keys)}  regression sample keys={len(reg_keys)}")
            for label, keys in (("GAP", gap_keys), ("REGRESSION", reg_keys)):
                for k in keys:
                    before = run_check(cur, k, old_sql)
                    after = run_check(cur, k, new_sql)
                    print(f"  {label:10} {k[1]:>12} / {k[3]} / {k[6]} / FT={k[8]} : before={before} after={after}")
                    con.rollback()


if __name__ == "__main__":
    main()
