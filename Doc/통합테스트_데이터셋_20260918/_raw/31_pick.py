# -*- coding: utf-8 -*-
"""Phase 3 — STEP 별 실데이터 선별 (읽기 전용)

2026-09-18 사용자 보완 요구 반영
  ① INCOTERMS — 화면 입력 불가 값 금지.
     판별자 = SCM_ADM_LOOKUP_MASTER_DETAIL(LOOKUP_TYPE='INCOTERMS').ATTRIBUTE2(EDIT_FLAG)
     EDIT_FLAG='N' : A01 · DAT · DDU · Z01 · Z02 · Z04  → 제시 금지
     EDIT_FLAG='Y' : CFR CIF CIP CPT DAP DDP EXW FAS FCA FOB (10종)
  ② Cell Prod Site — 필수 컬럼인데 공백이던 문제.
     40 = CELL_PROD_SITE_ID (DMF0021/DMF0082 · INPUT_TP_CD='IM' 필수)
     81 = PLANT_SITE_ID
     82 = 해당 컬럼 자체가 화면 LAYOUT 에 없음(실측) → '해당없음' 명시
  ③ CRUD UI = division 별 USER_SELECTABLE_FLAG='N' 컬럼 전체 (30_layouts.py)
  ④ VMI — DMF0082 VMI 메저(40: VMI_In_Plan/VMI_In_Req/VMI_Inv)를 쓸 수 있는
     SCM_MST_SITE.VMI_YN='Y' SITE 선정
"""
import json
import pathlib
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

HERE = pathlib.Path(__file__).resolve().parent
N_PER = 5


def connect():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
    m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


def rows_as_dicts(cur):
    names = [d[0] for d in cur.description]
    return [dict(zip(names, r)) for r in cur.fetchall()]


# ── ① 입력 가능 INCOTERMS ──────────────────────────────────────────────────
def editable_incoterms(cur):
    cur.execute("""SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                    WHERE LOOKUP_TYPE='INCOTERMS' AND VALID_YN='Y'
                      AND NVL(ATTRIBUTE2,'N')='Y' ORDER BY 1""")
    return [r[0] for r in cur]


def div_pred(div):
    """division 필터 — 81 계열 포함."""
    if div == "81":
        return "(DIVISION_ID='81' OR DIVISION_ID LIKE '81\\_%' ESCAPE '\\')"
    return "DIVISION_ID='{}'".format(div)


# ── ② Cell Prod Site 축 ───────────────────────────────────────────────────
CELL_COL = {"40": "CELL_PROD_SITE_ID", "81": "PLANT_SITE_ID", "82": None}


def cell_site_values(cur, div):
    """해당 division 에서 실제 사용되는 Cell Prod Site 값 (센티널 '-' 제외 우선)."""
    col = CELL_COL[div]
    if not col:
        return []
    tbl = "DM_PLN_SALES_PLAN" if div == "40" else "DM_PLN_MKT_FCST"
    cur.execute("""SELECT {c} V, COUNT(*) CNT FROM SCM_MGR.{t}
                    WHERE {d} AND {c} IS NOT NULL AND {c} <> '-'
                    GROUP BY {c} ORDER BY 2 DESC""".format(c=col, t=tbl, d=div_pred(div)))
    return [(r[0], r[1]) for r in cur]


# ── ④ VMI 가능 SITE ───────────────────────────────────────────────────────
def vmi_sites(cur, div):
    cur.execute("""SELECT SCM_SITE_ID, END_CUSTOMER, SITE_DESCRIPTION
                     FROM SCM_MGR.SCM_MST_SITE
                    WHERE VMI_YN='Y' AND VALID_YN='Y' AND {d}
                    ORDER BY SCM_SITE_ID""".format(d=div_pred(div)))
    return rows_as_dicts(cur)


def vmi_measures(cur, div):
    cur.execute("""SELECT DISTINCT COLUMN_NAME, COLUMN_LABEL_NAME
                     FROM SCM_MGR.SCM_MST_SHEET_MEASURE
                    WHERE PROGRAM_ID='DMF0082' AND VALID_YN='Y'
                      AND UPPER(COLUMN_NAME) LIKE '%VMI%'
                      AND (','||DIVISION_ID||',') LIKE :p
                    ORDER BY 1""", {"p": "%,{},%".format(div)})
    return rows_as_dicts(cur)


def vmi_rows(cur, div, inco, limit=N_PER):
    """VMI SITE 에서 실제 원장 행 (DM_PLN_MKT_FCST) — 없으면 SSPM 키로 대체."""
    sites = [s["SCM_SITE_ID"] for s in vmi_sites(cur, div)]
    if not sites:
        return []
    inlist = ",".join("'" + s.replace("'", "''") + "'" for s in sites)
    incos = ",".join("'" + c + "'" for c in inco)
    cur.execute("""SELECT * FROM (
                     SELECT F.DIVISION_ID, F.SCM_SITE_ID, F.ITEM_ID, F.PROJECT_CODE,
                            F.INCOTERMS, F.FCST_TYPE, F.DOM_EXP, F.PLANT_SITE_ID,
                            F.MEASURE, COUNT(*) OVER (PARTITION BY F.SCM_SITE_ID, F.ITEM_ID) CNT,
                            ROW_NUMBER() OVER (PARTITION BY F.SCM_SITE_ID
                                               ORDER BY F.ITEM_ID) RN
                       FROM SCM_MGR.DM_PLN_MKT_FCST F
                      WHERE {d} AND F.SCM_SITE_ID IN ({s})
                        AND F.INCOTERMS IN ({i})
                   ) WHERE RN = 1 AND ROWNUM <= :n""".format(
        d=div_pred(div).replace("DIVISION_ID", "F.DIVISION_ID"), s=inlist, i=incos),
        {"n": limit * 4})
    return rows_as_dicts(cur)[:limit]


# ── 기존(데이터보유 상위) 실행 ───────────────────────────────────────────────
SRC_OF = {
    "DMF0082": ("DM_PLN_MKT_FCST", "QTY"),
    "DMF0003": ("DM_PLN_MKT_FCST", "QTY"),
    "DMF0021": ("DM_PLN_SALES_PLAN", "QTY"),
    "DMF0020": ("SCM_MST_FUTURE_PRICE", "PRICE"),
    "DMF0005": ("SCM_MST_SITE_ITEM", None),
    "DMF0007": ("DM_MST_CUSTOMER_FCST", None),
    "DMF0072": ("DM_CUST_MODEL_MAPPING_M", None),
}


def existing_rows(cur, program_id, div, inco, limit=N_PER):
    tbl, _ = SRC_OF[program_id]
    incos = ",".join("'" + c + "'" for c in inco)
    has_inco = program_id not in ("DMF0005", "DMF0007")
    cell = CELL_COL[div]
    cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS
                    WHERE OWNER='SCM_MGR' AND TABLE_NAME=:1""", [tbl])
    have = {r[0] for r in cur}
    # 표에 실존하는 컬럼만 SELECT — DM_MST_CUSTOMER_FCST 는 ITEM_ID 가 없다(실측)
    sel = [c for c in ("DIVISION_ID", "SCM_SITE_ID", "ITEM_ID") if c in have]
    for c in ("PROJECT_CODE", "INCOTERMS", "FCST_TYPE", "DOM_EXP", "CURRENCY",
              "MEASURE", "CUSTOMER_CODE", "END_CUSTOMER", "MEASURE_GROUP",
              "SUMMARY_BUCKET_TYPE", "UPLOAD_UOM", "UPLOAD_BUCKET_TYPE",
              "EDI_FCST_YN", "CUSTOMER_PSI", "VALID_YN", cell):
        if c and c in have and c not in sel:
            sel.append(c)
    where = [div_pred(div)]
    if has_inco and "INCOTERMS" in have:
        where.append("INCOTERMS IN ({})".format(incos))
    if cell and cell in have:
        where.append("{c} IS NOT NULL AND {c} <> '-'".format(c=cell))
    gkey = "CUSTOMER_CODE" if "ITEM_ID" not in have else "ITEM_ID"
    # 2단계 — ① GROUP BY 로 데이터 많은 키 상위 추출(집계만, 윈도우 함수 금지)
    #          ② 그 ITEM 각각에 대해 대표 1행만 조회
    # 3M행 규모 표에서 COUNT(*) OVER(PARTITION BY ...) 는 타임아웃한다(2026-09-18 실측).
    try:
        cur.execute("""SELECT {g} K, COUNT(*) CNT FROM SCM_MGR.{t}
                        WHERE {w} GROUP BY {g} ORDER BY 2 DESC
                        FETCH FIRST :n ROWS ONLY""".format(g=gkey, t=tbl, w=" AND ".join(where)),
                    {"n": limit})
        tops = [(r[0], r[1]) for r in cur]
    except Exception as e:
        print("   !! existing_rows(top) {} {} : {}".format(program_id, div, str(e).split("\n")[0]))
        return []
    out = []
    for item, cnt in tops:
        try:
            cur.execute("""SELECT {cols} FROM SCM_MGR.{t}
                            WHERE {w} AND {g} = :it
                            FETCH FIRST 1 ROWS ONLY""".format(g=gkey,
                cols=", ".join(sel), t=tbl, w=" AND ".join(where)), {"it": item})
            rs = rows_as_dicts(cur)
            if rs:
                rs[0]["ITEM_CNT"] = cnt
                out.append(rs[0])
        except Exception as e:
            print("   !! existing_rows(row) {} {} {} : {}".format(
                program_id, div, item, str(e).split("\n")[0]))
    return out


# ── 키 단위 실측 정규화 ────────────────────────────────────────────────────
# 사용자 지적 : "미사용 데이터는 임의로 제시 하면 안됨" / "Cell Prod Site 필수인데 공백"
# → 값은 반드시 그 키(또는 같은 SITE)의 **실제 원장 사용값**에서 유도한다.
_CACHE = {}


def _one(cur, sql, args):
    try:
        cur.execute(sql, args)
        r = cur.fetchone()
        return r[0] if r else None
    except Exception:
        return None


def resolve_incoterms(cur, div, site, item, cur_val, inco, div_top):
    """INCOTERMS 를 화면 입력 가능 값으로 정규화. 반환 (값, 출처)."""
    if cur_val and cur_val in inco:
        return cur_val, "원장 실값(입력가능)"
    incos = ",".join("'" + c + "'" for c in inco)
    tbl = "DM_PLN_MKT_FCST"
    k = ("inco", div, site, item)
    if k not in _CACHE:
        v = _one(cur, """SELECT INCOTERMS FROM (
                           SELECT INCOTERMS, COUNT(*) C FROM SCM_MGR.{t}
                            WHERE {d} AND SCM_SITE_ID=:s AND ITEM_ID=:i
                              AND INCOTERMS IN ({i2}) GROUP BY INCOTERMS ORDER BY 2 DESC)
                         WHERE ROWNUM=1""".format(t=tbl, d=div_pred(div), i2=incos),
                 {"s": site, "i": item})
        src = "동일 키 원장 최빈(입력가능)"
        if v is None:
            v = _one(cur, """SELECT INCOTERMS FROM (
                               SELECT INCOTERMS, COUNT(*) C FROM SCM_MGR.{t}
                                WHERE {d} AND SCM_SITE_ID=:s AND INCOTERMS IN ({i2})
                                GROUP BY INCOTERMS ORDER BY 2 DESC) WHERE ROWNUM=1""".format(
                t=tbl, d=div_pred(div), i2=incos), {"s": site})
            src = "동일 SITE 원장 최빈(입력가능)"
        if v is None:
            v, src = div_top, "division 최빈(입력가능)"
        _CACHE[k] = (v, src)
    return _CACHE[k]


def resolve_cell_site(cur, div, site, item, cur_val, div_vals):
    """Cell Prod Site(40=CELL_PROD_SITE_ID / 81=PLANT_SITE_ID) 실값 유도. 반환 (값, 출처)."""
    col = CELL_COL[div]
    if col is None:
        return "(해당없음 — 82 화면 LAYOUT 미보유)", "실측 — 82 는 해당 컬럼 없음"
    if cur_val and str(cur_val) not in ("-", ""):
        return cur_val, "원장 실값"
    tbl = "DM_PLN_SALES_PLAN" if div == "40" else "DM_PLN_MKT_FCST"
    k = ("cell", div, site, item)
    if k not in _CACHE:
        v = _one(cur, """SELECT {c} FROM (
                           SELECT {c}, COUNT(*) N FROM SCM_MGR.{t}
                            WHERE {d} AND SCM_SITE_ID=:s AND ITEM_ID=:i
                              AND {c} IS NOT NULL AND {c} <> '-'
                            GROUP BY {c} ORDER BY 2 DESC) WHERE ROWNUM=1""".format(
            c=col, t=tbl, d=div_pred(div)), {"s": site, "i": item})
        src = "동일 키 원장 최빈"
        if v is None:
            v = _one(cur, """SELECT {c} FROM (
                               SELECT {c}, COUNT(*) N FROM SCM_MGR.{t}
                                WHERE {d} AND SCM_SITE_ID=:s
                                  AND {c} IS NOT NULL AND {c} <> '-'
                                GROUP BY {c} ORDER BY 2 DESC) WHERE ROWNUM=1""".format(
                c=col, t=tbl, d=div_pred(div)), {"s": site})
            src = "동일 SITE 원장 최빈"
        if v is None:
            v = div_vals[0][0] if div_vals else "-"
            src = "division 최빈"
        _CACHE[k] = (v, src)
    return _CACHE[k]


# IF 랜딩 테이블은 적재 후 비워진다(사내 실측 2026-09-18 — 아래 5표 전부 0행).
# LAYOUT 은 사용자가 지정한 IF 표 그대로 쓰고, 값만 적재 후 상시표에서 가져온다.
IF_VALUE_SRC = {
    "XIF_ERP_EDI_CALLOFF_HEAD_R":    ("SCM_MGR", "DM_DNM_EDI_CALLOFF_HEAD"),
    "XIF_ERP_EDI_CALLOFF_ITEM_R":    ("SCM_MGR", "DM_DNM_EDI_CALLOFF_ITEM"),
    "XIF_ERP_EDI_CALLOFF_PARTNER_R": ("SCM_MGR", "DM_DNM_EDI_CALLOFF_PARTNER"),
    "XIF_CUST_DEMAND_MAPPING_MST_R": ("SCM_MGR", "DM_CUST_MODEL_MAPPING_M"),
    "SCM_STOCK_H":                   ("SCM_MGR", "SCM_DNM_STOCK"),
}


def _table_cols(cur, owner, table):
    cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER=:o AND TABLE_NAME=:t
                    ORDER BY COLUMN_ID""", {"o": owner, "t": table})
    return [r[0] for r in cur]


def _count(cur, owner, table, where):
    try:
        cur.execute("SELECT COUNT(*) FROM {}.{} WHERE {}".format(owner, table, where))
        return cur.fetchone()[0]
    except Exception:
        return 0


def if_rows(cur, owner, table, div, limit=N_PER):
    """IF LAYOUT 행 — 지정 표가 비어 있으면 적재 후 상시표에서 동일 컬럼명만 투영."""
    lay_cols = _table_cols(cur, owner, table)
    has_div = "DIVISION_ID" in lay_cols
    w = div_pred(div) if has_div else "1=1"
    n = _count(cur, owner, table, w)
    src_owner, src_table, note = owner, table, "IF 원표 실수신"
    if n == 0:
        alt = IF_VALUE_SRC.get(table)
        if not alt:
            return [], "{}.{} 0행 · 대체표 미지정".format(owner, table)
        src_owner, src_table = alt
        note = "{}.{} 는 적재 후 0행 → 값 출처 {}.{}".format(
            owner, table, src_owner, src_table)
    src_cols = _table_cols(cur, src_owner, src_table)
    common = [c for c in lay_cols if c in src_cols]
    if not common:
        return [], note + " · 공통컬럼 0"
    sw = div_pred(div) if "DIVISION_ID" in src_cols else "1=1"
    try:
        cur.execute("""SELECT {c} FROM {o}.{t} WHERE {w}
                        FETCH FIRST :n ROWS ONLY""".format(
            c=", ".join(common), o=src_owner, t=src_table, w=sw), {"n": limit})
        return rows_as_dicts(cur), note + " · 공통컬럼 {}/{}".format(len(common), len(lay_cols))
    except Exception as e:
        return [], note + " · " + str(e).split("\n")[0]


if __name__ == "__main__":
    db = connect()
    cur = db.cursor()
    inco = editable_incoterms(cur)
    print("① 입력 가능 INCOTERMS ({}종): {}".format(len(inco), ", ".join(inco)))
    print()
    for d in ("40", "81", "82"):
        cs = cell_site_values(cur, d)
        print("② DIV {} Cell Prod Site 컬럼={} 실값 {}종: {}".format(
            d, CELL_COL[d], len(cs), ", ".join("{}({:,})".format(v, c) for v, c in cs[:8])))
    print()
    for d in ("40", "81", "82"):
        ms = vmi_measures(cur, d)
        ss = vmi_sites(cur, d)
        print("④ DIV {} VMI 메저 {}종 {} / VMI SITE {}개".format(
            d, len(ms), [m["COLUMN_NAME"] for m in ms], len(ss)))
    print()
    print("④ DIV 40 VMI 실원장 행 표본:")
    for r in vmi_rows(cur, "40", inco):
        print("   ", {k: r[k] for k in ("SCM_SITE_ID", "ITEM_ID", "INCOTERMS",
                                        "FCST_TYPE", "MEASURE")})
    print()
    print("기존(데이터보유 상위) 표본:")
    for pid, d in (("DMF0082", "40"), ("DMF0021", "40"), ("DMF0082", "81"),
                   ("DMF0021", "81"), ("DMF0020", "82"), ("DMF0003", "82")):
        rs = existing_rows(cur, pid, d, inco, 2)
        print("   {} DIV{} → {}행".format(pid, d, len(rs)))
        for r in rs:
            print("      ", {k: v for k, v in r.items() if k not in ("RN",)})
