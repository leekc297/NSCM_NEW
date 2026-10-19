"""[E20261006-ASISDELTA] AS-IS 변경분 반영 2건 (asis_delta_20261002 시트 14 · 우선순위 20·21 / 31·32)

① PKG_DMF0004.P_DMF0004_SAVE_SALES_SITE_DATA — 저장 컬럼 누락 (#005 · #007)
   AS-IS 운영 DMF0004_SAVE_SALES_SITE_DATA 는 SCM_MST_SITE.attribute3(Distribution Channel) · attribute5(Inventory days)
   를 TRIM 후 UPDATE/INSERT 한다 (L229-230·L242 / L433-434 / L457-458·L479-480). TO-BE 는 둘 다 입력·저장하지 않았다.
   → JSON_TABLE 에 두 항목 추가(TRIM) + UPDATE SET + INSERT 반영.
   → 페이로드에 키가 아예 없는 행은 기존 값을 유지한다(UPDATE). AS-IS 는 파라미터가 항상 넘어오므로 생기지 않는 경우이고,
     TO-BE 에서 키 누락 호출이 기존 값을 지우지 않게 하는 방어다. 키가 있으면(null·빈값 포함) AS-IS 와 같이 그대로 저장한다.

② PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL — 81 사업부 분기 (#006 · #008)
   AS-IS 운영 [E20260512-000502] L458(Current · DM_PLN_SALES_PLAN) · L538(Cutoff · DM_PLN_SALES_PLAN_C):
     CASE WHEN A.DIVISION_ID = '40' THEN …  →  CASE WHEN (A.DIVISION_ID = '40' OR A.DIVISION_ID LIKE '81%') THEN …
   → 같은 2줄을 1:1 로 바꾼다. 그 외 줄 변경 없음.

방식: 지금 DB 원문(ALL_SOURCE) 위의 외과적 변경.
  python build_apply.py build            # 01/02 SQL 생성만 (DB 변경 없음)
  python build_apply.py apply DMF0004    # FRESH-GATE 후 적용 + 검증
  python build_apply.py apply DMF0022
"""
import sys, os, re, hashlib, json, datetime

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
TYP = "PACKAGE BODY"
MARK = "[E20261006-ASISDELTA]"


def connect():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def read_source(cur, pkg):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS'), status FROM all_objects "
                "WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=pkg, t=TYP)
    ddl, status = cur.fetchone()
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=pkg, t=TYP)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "status": status, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def one(lines, lo, hi, pred, what):
    hit = [i for i in range(lo, hi) if pred(lines[i])]
    assert len(hit) == 1, f"{what}: 매칭 {len(hit)}건 (1건이어야 함) — 원문이 바뀌었거나 이미 반영됨"
    return hit[0]


def member(lines, name):
    lo = one(lines, 0, len(lines), lambda l: l.strip().startswith("PROCEDURE " + name), name + " 시작")
    hi = one(lines, lo, len(lines), lambda l: l.strip() == "END " + name + ";", name + " 끝")
    return lo, hi


# ---------------------------------------------------------------------------------------------------------------
# ① PKG_DMF0004 — 저장 컬럼 누락
# ---------------------------------------------------------------------------------------------------------------
def transform_dmf0004(src):
    assert MARK not in src, "이미 반영됨"
    lines = src.split("\n")
    lo, hi = member(lines, "P_DMF0004_SAVE_SALES_SITE_DATA")
    seg = "\n".join(lines[lo:hi])
    assert "ATTRIBUTE3" not in seg and "ATTRIBUTE5" not in seg and "DISTRIBUTION_CHANNEL" not in seg, "저장 멤버에 이미 대상 컬럼 존재"

    sel = one(lines, lo, hi, lambda l: l.strip() == ", TRIM(JT.SHIP_PLAN_AUTO)                  AS SHIP_PLAN_AUTO", "SELECT 목록")
    col = one(lines, lo, hi, lambda l: l.strip().startswith(", SHIP_PLAN_AUTO        VARCHAR2(10)   PATH '$.\"SHIP_PLAN_AUTO\"'"), "JSON_TABLE COLUMNS")
    upd = one(lines, lo, hi, lambda l: l.strip() == ", ATTRIBUTE2 = R.SHIP_PLAN_AUTO", "UPDATE SET")
    icol = one(lines, lo, hi, lambda l: l.strip() == ", ATTRIBUTE2", "INSERT 컬럼")
    ival = one(lines, lo, hi, lambda l: l.strip() == ", R.SHIP_PLAN_AUTO", "INSERT VALUES")
    assert sel < col < upd < icol < ival
    assert lines[upd + 1].strip() == "WHERE DIVISION_ID = R.DIVISION_ID", lines[upd + 1]
    assert lines[icol + 1].strip() == ")" and lines[ival + 1].strip() == ");"

    ind = lambda i: re.match(r"\s*", lines[i]).group()
    add = {
        sel: [ind(sel) + "-- " + MARK + " AS-IS L229-230·L242 — Distribution Channel(ATTRIBUTE3)·Inventory days(ATTRIBUTE5) TRIM 후 저장",
              ind(sel) + ", TRIM(JT.DISTRIBUTION_CHANNEL)            AS DISTRIBUTION_CHANNEL",
              ind(sel) + ", TRIM(JT.ATTRIBUTE5)                      AS ATTRIBUTE5",
              ind(sel) + ", JT.HAS_DISTRIBUTION_CHANNEL              AS HAS_DISTRIBUTION_CHANNEL",
              ind(sel) + ", JT.HAS_ATTRIBUTE5                        AS HAS_ATTRIBUTE5"],
        col: [ind(col) + "-- " + MARK + " HAS_* = 페이로드에 키가 있는지 (없으면 기존 값 유지 — 아래 UPDATE)",
              ind(col) + ", DISTRIBUTION_CHANNEL  VARCHAR2(600)  PATH '$.\"DISTRIBUTION_CHANNEL\"' NULL ON EMPTY NULL ON ERROR",
              ind(col) + ", ATTRIBUTE5            VARCHAR2(600)  PATH '$.\"ATTRIBUTE5\"' NULL ON EMPTY NULL ON ERROR",
              ind(col) + ", HAS_DISTRIBUTION_CHANNEL NUMBER(1)   EXISTS PATH '$.\"DISTRIBUTION_CHANNEL\"'",
              ind(col) + ", HAS_ATTRIBUTE5        NUMBER(1)      EXISTS PATH '$.\"ATTRIBUTE5\"'"],
        upd: [ind(upd) + "-- " + MARK + " AS-IS L433-434 — attribute3/attribute5 저장 (키 없는 페이로드는 기존 값 유지)",
              ind(upd) + ", ATTRIBUTE3 = CASE WHEN R.HAS_DISTRIBUTION_CHANNEL = 1 THEN R.DISTRIBUTION_CHANNEL ELSE ATTRIBUTE3 END",
              ind(upd) + ", ATTRIBUTE5 = CASE WHEN R.HAS_ATTRIBUTE5 = 1 THEN R.ATTRIBUTE5 ELSE ATTRIBUTE5 END"],
        icol: [ind(icol) + "-- " + MARK + " AS-IS L457-458",
               ind(icol) + ", ATTRIBUTE3",
               ind(icol) + ", ATTRIBUTE5"],
        ival: [ind(ival) + "-- " + MARK + " AS-IS L479-480",
               ind(ival) + ", R.DISTRIBUTION_CHANNEL",
               ind(ival) + ", R.ATTRIBUTE5"],
    }
    for i in sorted(add, reverse=True):
        lines[i + 1:i + 1] = add[i]
    out = "\n".join(lines)
    n_add = sum(len(v) for v in add.values())
    assert n_add == 19 and out.count(MARK) == 5
    assert len(out.split("\n")) == len(src.split("\n")) + n_add
    # 삽입 외 변경 없음: 삽입 줄을 걷어내면 원문과 같아야 한다
    added = {x for v in add.values() for x in v}
    assert "\n".join(l for l in out.split("\n") if l not in added) == src
    return out, n_add


# ---------------------------------------------------------------------------------------------------------------
# ② PKG_DMF0022 — 81 사업부 분기
# ---------------------------------------------------------------------------------------------------------------
OLD22 = "CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END"
NEW22 = "CASE WHEN (A.DIVISION_ID = '40' OR A.DIVISION_ID LIKE '81%') THEN A.CELL_PROD_SITE_ID ELSE '-' END"


def transform_dmf0022(src):
    assert MARK not in src, "이미 반영됨"
    assert NEW22 not in src
    lines = src.split("\n")
    lo, hi = member(lines, "P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL")
    hit = [i for i in range(len(lines)) if OLD22 in lines[i]]
    assert len(hit) == 2 and all(lo < i < hi for i in hit), hit
    cur_i, cut_i = hit
    assert lines[cur_i + 1].strip() == "FROM SCM_MGR.DM_PLN_SALES_PLAN A", lines[cur_i + 1]      # AS-IS L459 (Current)
    assert lines[cut_i + 1].strip() == "FROM SCM_MGR.DM_PLN_SALES_PLAN_C A", lines[cut_i + 1]    # AS-IS L539 (Cutoff)
    for i in (cur_i, cut_i):
        assert lines[i].count(OLD22) == 1 and not lines[i].strip().startswith("--")
    notes = {cur_i: "AS-IS L457-458 (Current 구간)", cut_i: "AS-IS L537-538 (Cutoff 구간)"}
    for i in (cut_i, cur_i):   # 뒤에서부터 (앞 인덱스 보존)
        ind = re.match(r"\s*", lines[i]).group()
        lines[i] = lines[i].replace(OLD22, NEW22, 1)
        lines.insert(i, ind + "--[E20260512-000502]_81 사업부 추가 " + MARK + " " + notes[i])
    out = "\n".join(lines)
    assert out.count(MARK) == 2 and out.count(NEW22) == 2 and OLD22 not in out
    assert len(out.split("\n")) == len(src.split("\n")) + 2
    # 2줄 치환 + 주석 2줄 외 변경 없음
    back = "\n".join(l for l in out.split("\n") if MARK not in l).replace(NEW22, OLD22)
    assert back == src
    return out, 2


TARGETS = {
    "DMF0004": ("PKG_DMF0004", transform_dmf0004, "01_PKG_DMF0004_BODY.sql",
                "DMF0004 저장 컬럼 누락 — DISTRIBUTION_CHANNEL(ATTRIBUTE3)·ATTRIBUTE5 저장 추가 (AS-IS 운영 DMF0004_SAVE_SALES_SITE_DATA)"),
    "DMF0022": ("PKG_DMF0022", transform_dmf0022, "02_PKG_DMF0022_BODY.sql",
                "DMF0022 81 사업부 분기 — CELL_PROD_SITE_ID 유지 조건에 81% 추가 (AS-IS 운영 [E20260512-000502])"),
}


def build(cur, key):
    pkg, fn, fname, why = TARGETS[key]
    base = read_source(cur, pkg)
    new, n = fn(base["src"])
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    with open(os.path.join(HERE, fname), "w", encoding="utf-8", newline="\n") as f:
        f.write(f"-- SOURCE-FRESH: SCM_MGR.{pkg} {TYP} LAST_DDL={base['last_ddl']} FETCHED={now} DB=ZIOUI1\n"
                "-- " + MARK + " " + why + "\n" + ddl_text(new) + "/\n")
    print("BUILD", pkg, "base", base["last_ddl"], base["md5"], f"→ +{n} lines")
    return pkg, base, new


def apply(key):
    with connect() as con:
        cur = con.cursor()
        pkg, base, new = build(cur, key)
        saved = json.load(open(os.path.join(HERE, "_fresh_state.json")))[pkg + "__PACKAGE_BODY"]
        if saved["md5"] != base["md5"]:
            sys.exit("ABORT: 착수 시 백업본과 현재 DB 원문이 다름 — 재조회·재검토 필요")
        # FRESH-GATE: 적용 직전 DB 원문(ALL_SOURCE) 재조회 == 방금 읽은 기준본
        now = read_source(cur, pkg)
        if now["md5"] != base["md5"] or now["last_ddl"] != base["last_ddl"]:
            sys.exit("FRESH-GATE FAIL: 착수 후 DB 원문 변경 — 중단")
        print("FRESH-GATE PASS", now["last_ddl"], now["md5"])
        cur.execute(ddl_text(new).rstrip())
        after = read_source(cur, pkg)
        cur.execute("SELECT line, position, text FROM all_errors WHERE owner='SCM_MGR' AND name=:n ORDER BY sequence", n=pkg)
        errs = cur.fetchall()
        cur.execute("SELECT object_name, object_type FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID' "
                    "AND object_name IN (SELECT name FROM all_dependencies WHERE referenced_owner='SCM_MGR' AND referenced_name=:n)", n=pkg)
        inv = cur.fetchall()
        same = after["src"].rstrip() == new.rstrip()
        print("AFTER", after["last_ddl"], after["status"], "errors", errs, "same_as_built", same, "dependent_invalid", inv)
        json.dump({"before": {k: base[k] for k in ("last_ddl", "status", "md5")},
                   "after": {k: after[k] for k in ("last_ddl", "status", "md5")},
                   "errors": errs, "same_as_built": same, "dependent_invalid": inv},
                  open(os.path.join(HERE, f"_apply_result_{key}.json"), "w"), indent=1, ensure_ascii=False)
        if errs or after["status"] != "VALID" or not same:
            sys.exit("APPLY CHECK FAIL — 원복 검토")


if __name__ == "__main__":
    if len(sys.argv) == 3 and sys.argv[1] == "apply" and sys.argv[2] in TARGETS:
        apply(sys.argv[2])
    else:
        with connect() as con:
            for k in TARGETS:
                build(con.cursor(), k)
