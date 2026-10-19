"""조회 SP 파라미터 자동 유도 v2 — SP 본문에서 각 IN 파라미터의 쓰임을 읽고, 케이스 테이블의 '실제 행' 하나에서 값을 채운다.
  · 선택 파라미터( P IS NULL OR / NVL(P,'ALL') / P = 'ALL' / TRIM(P) IS NULL ) → '' 또는 'ALL' (필터 해제 → 결과가 비지 않게)
  · 등치 비교( alias.COL = P ) → 대표 행의 COL 값   · 날짜( TO_DATE(P,'fmt') / REPLACE(P,'-','') ) → 대표 행 날짜를 그 형식으로
  · 범위( COL >= P / COL <= P ) → 대표 행 날짜 ±45일   · USER/PROGRAM/SHEET/… 고정값
대표 행 = 케이스 테이블 샘플(대형 테이블은 SAMPLE) 중 최신 날짜·사업부별 1행 (세트 2개)"""
import re, datetime, collections


def _usage(body, p):
    """파라미터 p 의 쓰임 요약."""
    u = {"optional": False, "all": False, "date_fmt": None, "eq_cols": [], "range_cols": [], "like": False, "split": False}
    rx = re.escape(p)
    if re.search(rx + r"\s+IS\s+NULL|TRIM\(\s*" + rx + r"\s*\)\s+IS\s+NULL|NVL\(\s*" + rx + r"\s*,\s*'ALL'\s*\)|LENGTH\(\s*" + rx + r"\s*\)\s*=\s*0", body, re.I):
        u["optional"] = True
    if re.search(rx + r"\s*(=|IN\s*\()\s*'ALL'|'ALL'\s*=\s*" + rx, body, re.I):
        u["all"] = True
    m = re.search(r"TO_DATE\(\s*(?:SUBSTR\(\s*)?(?:REPLACE\(\s*)?" + rx + r"[^,)]*(?:,\s*'[^']*'\s*,\s*''\s*\))?(?:,\s*\d+\s*,\s*\d+\s*\))?\s*,\s*'([^']+)'", body, re.I)
    if m:
        u["date_fmt"] = m.group(1)
    elif re.search(r"REPLACE\(\s*" + rx + r"\s*,\s*'-'\s*,\s*''\s*\)", body, re.I):
        u["date_fmt"] = "YYYYMMDD"
    for m in re.finditer(r"(?:\w+\.)?(\w+)\s*=\s*" + rx + r"\b|\b" + rx + r"\s*=\s*(?:\w+\.)?(\w+)\b", body, re.I):
        c = (m.group(1) or m.group(2) or "").upper()
        if c and not c.startswith(("P_", "V_")) and c not in ("ALL", "NULL"):
            u["eq_cols"].append(c)
    for m in re.finditer(r"(?:\w+\.)?(\w+)\s*(>=|<=|>|<)\s*(?:TO_DATE\()?\s*" + rx + r"\b", body, re.I):
        u["range_cols"].append(m.group(1).upper())
    if re.search(rx + r"\s*\|\|\s*'%'|LIKE\s*" + rx, body, re.I):
        u["like"] = True
    if re.search(r"STRING_SPLIT\(\s*" + rx, body, re.I):
        u["split"] = True
    return u


def _fmt_date(d8, fmt):
    f = fmt.upper()
    y, mo, dd = d8[:4], d8[4:6], d8[6:8]
    if f.startswith("YYYY-MM-DD"):
        return f"{y}-{mo}-{dd}"
    if f == "YYYYMM":
        return y + mo
    if f.startswith("YYYY/MM/DD"):
        return f"{y}/{mo}/{dd}"
    return d8


def sample_rows(cur, table, n_rows=2):
    """대표 행 — 최신 날짜 순, 사업부(DIVISION_ID)가 다른 행 우선."""
    cur.execute("SELECT column_name FROM all_tab_columns WHERE owner='SCM_MGR' AND table_name=:1 ORDER BY column_id", [table])
    cols = [r[0] for r in cur]
    nr = cur.execute("SELECT NVL(num_rows,0) FROM all_tables WHERE owner='SCM_MGR' AND table_name=:1", [table]).fetchone()[0]
    src = f"SCM_MGR.{table} SAMPLE(0.05)" if nr > 5_000_000 else f"SCM_MGR.{table}"
    dc = next((c for c in ("PLAN_START_YYYYMMDD", "YYYYMMDD", "BASIS_YYYYMMDD", "CUTOFF_YYYYMMDD", "PLAN_DATE", "YYYYMM", "CREATION_DATE") if c in cols), None)
    order = f" ORDER BY {dc} DESC" if dc else ""
    cur.execute(f"SELECT * FROM (SELECT * FROM {src} WHERE ROWNUM <= 5000){order} FETCH FIRST 400 ROWS ONLY")
    rows = [dict(zip(cols, [("" if v is None else v) for v in r])) for r in cur]
    out = []; seen_div = set()
    for r in rows:
        d = str(r.get("DIVISION_ID", ""))
        if d in seen_div:
            continue
        seen_div.add(d); out.append(r)
        if len(out) >= n_rows:
            break
    if len(out) < n_rows and rows:
        out += [r for r in rows if r not in out][: n_rows - len(out)]
    return out, cols


def derive(cur, args, body, table, screen, sheet_cache):
    """args=[(pos,name,in_out,dtype)], body=서브프로그램 원문 → 파라미터 세트 목록(최대 2)."""
    rows, tcols = sample_rows(cur, table)
    if not rows:
        return []
    sets = []
    for row in rows:
        vals = []
        base_date = None
        for dcol in ("PLAN_START_YYYYMMDD", "YYYYMMDD", "BASIS_YYYYMMDD", "CUTOFF_YYYYMMDD", "YYYYMM", "PLAN_DATE"):
            if dcol in row and row[dcol]:
                base_date = str(row[dcol]).replace("-", "")[:8]; break
        if base_date and len(base_date) == 6:
            base_date += "01"
        base_date = base_date or datetime.date.today().strftime("%Y%m%d")
        bd = datetime.datetime.strptime(base_date, "%Y%m%d")
        for pos, n, io, dt in args:
            if io != "IN":
                continue
            base = re.sub(r"^(P|V|I)_", "", n); u = _usage(body, n); v = ""
            if base in ("USER_ID", "CREATED_BY", "SES_USER_ID", "LOGIN_ID", "LAST_UPDATED_BY"):
                v = "minyonglee1"
            elif base in ("PROGRAM_ID", "MENU_ID", "MNU_ID"):
                v = screen
            elif base == "SHEET_NAME":
                if screen not in sheet_cache:
                    cur.execute("SELECT SHEET_NAME FROM (SELECT SHEET_NAME, COUNT(*) N FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:1 GROUP BY SHEET_NAME ORDER BY N DESC) WHERE ROWNUM=1", [screen])
                    r = cur.fetchone(); sheet_cache[screen] = r[0] if r else ""
                v = sheet_cache[screen]
            elif base.endswith("_YN") or base.endswith("CHK") or base in ("REAL_FLAG", "DEBUG_MODE", "INVALID_EXEC", "MYMODELCHK"):
                v = "N"
            elif base == "BUCKET" or base == "BUCKET_TYPE":
                v = "MONTHLY"
            elif base == "VERSION_TYPE":
                v = "Current"
            elif u["date_fmt"] or re.search(r"YYYYMMDD|YYYYMM|_DATE$", base):
                fmt = u["date_fmt"] or "YYYYMMDD"
                if re.search(r"^(FROM|START|BEGIN)", base) or base.endswith(("_FROM", "_START")):
                    d = (bd - datetime.timedelta(days=45)).strftime("%Y%m%d")
                elif re.search(r"^(TO|END)", base) or base.endswith(("_TO", "_END")):
                    d = (bd + datetime.timedelta(days=45)).strftime("%Y%m%d")
                else:
                    d = base_date
                v = _fmt_date(d, fmt)
            elif u["optional"] and not u["all"]:
                v = ""
            elif u["all"]:
                v = "ALL"
            else:
                col = next((c for c in u["eq_cols"] if c in row), None)
                if col is None:
                    for cand in (base, base.replace("SCM_SITE_ID", "FROM_SITE"), "FROM_SITE" if base in ("SITE_ID", "SCM_SITE_ID", "PLANT_SITE_ID") else base, "COMPANY_ID"):
                        if cand in row and cand == base or (cand in row and base in ("SITE_ID", "SCM_SITE_ID", "PLANT_SITE_ID", "FROM_SITE")):
                            col = cand; break
                if col is not None:
                    v = str(row.get(col, ""))
                elif u["like"] or u["split"]:
                    v = ""
                else:
                    v = ""
            vals.append(str(v))
        if vals not in sets:
            sets.append(vals)
    return sets
