"""2026-10-07 범위 확정 반영 — 액션 부여 + xlsx 재구성

내 범위 = DEFAULT DDL + DB 객체(PKG/SP/VIEW/FUNCTION) 변경 목록·변경안.  기존 데이터 변환('-'→'/')은 타 팀 → 분류·건수만 제공.
TO-BE '-' 출현 1건마다 액션:
  NVL→'/'          : NVL/NVL2/COALESCE(x,'-') 의 '-' → '/'  (NVL 은 NULL 일 때만 값을 넣으므로 뜻이 변하지 않음)
  비교→'/'      : NULL·''·'-' 를 하나로 보던 비교·분기에 '/' 를 같은 값으로 추가 (NVL(x,'/') IN ('/','-'), x IN ('/','-','--') …)
  리터럴→'/'        : 이관 때 넣은 빈값 자리표시 '-' → '/'
  유지(AS-IS 값)    : AS-IS 에 원래 있던 '-' 값·비교 — 그대로
  유지(비센티널)    : 구분자·문자열 가공 — 그대로
  미확정(검토)      : AS-IS 대응을 못 찾았거나 자동 변경안을 못 만든 줄 — 수작업
"""
import os, re, json, collections, subprocess, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\DASH_SENTINEL_INVENTORY_20261001")
import extract_dash_inventory as old

ILLEGAL = re.compile(r"[\x00-\x08\x0b\x0c\x0e-\x1f]")
MARK_MIG = ("SOLDTO-SENTINEL", "PLANTNORM", "NVLSAVE", "PKSENTINEL", "SENTINEL", "#119", "센티널", "NOT NULL", "ORA-01400", "E2026", "AJS", "POJ")
FE_ROOT = r"C:\Projects\NSCM\nscm-fe\features"


# ------------------------------------------------------------------------------------------------------------
# 변경안 생성 (한 줄 안에서, '-' 리터럴 위치 기준)
# ------------------------------------------------------------------------------------------------------------
def _q(dyn):
    return "''" if dyn else "'"


def _lit(dyn, ch):
    q = _q(dyn); return q + ch + q


def rewrite_nullchk(line, dyn):
    q = re.escape(_q(dyn)); d = q + r"-" + q
    rx = re.compile(r"\b(NVL|COALESCE)\s*\((.+?),\s*" + d + r"\s*\)\s*(=|<>|!=)\s*" + d, re.I | re.S)
    m = rx.search(line)
    if not m:
        return None
    fn, inner, op = m.group(1), m.group(2), m.group(3)
    S = _lit(dyn, "/")
    return line[:m.start()] + f"{fn}({inner}, {S}) {op} {S}" + line[m.end():]


def rewrite_compare(line, pos, ln, dyn):
    """pos: 줄 안 '-' 리터럴 시작, ln: 리터럴 길이. 앞의 연산자(= <> !=) 또는 IN 목록을 찾아 '/' 를 동치로 추가."""
    S = _lit(dyn, "/")
    before = line[:pos]
    if re.search(r"(=|<>|!=)\s*$", before):
        return line[:pos] + S + line[pos + ln:]
    k = before.rfind("(")
    if k >= 0 and re.search(r"\bIN\s*$", before[:k], re.I):
        if S in line[k + 1:].split(")")[0]:
            return None                        # 이미 '/' 가 목록에 있음 — 수작업
        return line[:pos] + S + line[pos + ln:]
    return None


def rewrite_nvl_write(line, pos, ln, dyn):
    """적재 경로의 NVL(x,'-') → NVL(NULLIF(RTRIM(x),''),'/')  (x 가 이미 TRIM/NULLIF 로 감싸져 있으면 리터럴만 치환)."""
    q = _q(dyn); S = q + "/" + q; E = q + q
    before = line[:pos]
    m = re.search(r",\s*$", before)
    if not m:
        return None
    k = m.start(); d = 0; j = k - 1
    while j >= 0:
        ch = before[j]
        if ch == ")":
            d += 1
        elif ch == "(":
            if d == 0:
                break
            d -= 1
        j -= 1
    if j < 0 or not re.search(r"\b(NVL|COALESCE)\s*$", before[:j], re.I):
        return None
    inner = before[j + 1:k].strip()
    if re.search(r"\b(TRIM|RTRIM|NULLIF)\s*\(", inner, re.I) or not re.match(r"^[\w.:\"]+$", inner):
        return line[:pos] + S + line[pos + ln:]
    return before[:j + 1] + f"NULLIF(RTRIM({inner}),{E}), {S}" + line[pos + ln:]


def rewrite_literal(line, pos, ln):
    seg = line[pos:pos + ln]
    if "-" not in seg:
        return None
    return line[:pos] + seg.replace("-", "/") + line[pos + ln:]


# ------------------------------------------------------------------------------------------------------------
# AS-IS 대응 객체에서 리터럴 '-' 의 출처 판단
# ------------------------------------------------------------------------------------------------------------
def asis_literal_origin(defs, name, role_hint=""):
    """defs: AS-IS 대응 객체 정의문 목록, name: 별칭/컬럼명. → ('유지'|'슬래시'|'미확정', 사유)"""
    if not defs:
        return "슬래시", "AS-IS 대응 객체 없음(TO-BE 신규 코드)"
    joined = "\n".join(defs)
    code = old.strip_ms_comments(joined)
    if name:
        n = re.escape(name)
        has_dash = re.search(r"N?'-'\s+(AS\s+)?\[?" + n + r"\]?\b", code, re.I) or re.search(r"\b" + n + r"\]?\s*=\s*N?'-'(?!\w)", code, re.I)
        has_blank = re.search(r"N?''\s+(AS\s+)?\[?" + n + r"\]?\b", code, re.I) or re.search(r"\b" + n + r"\]?\s*=\s*N?''(?!')", code, re.I)
        if has_dash and not has_blank:
            return "유지", f"AS-IS 에 '-' AS {name} / {name} = '-' 존재(원래 값)"
        if has_blank and not has_dash:
            return "슬래시", f"AS-IS 는 '' AS {name} / {name} = '' (빈문자 → 이관 때 '-' 로 치환된 것)"
        if has_dash and has_blank:
            return "미확정", f"AS-IS 에 {name} 의 '-' 와 '' 가 모두 있음 — 같은 자리 확인"
        if re.search(r"ISNULL\s*\((?:[^()]|\([^()]*\))*,\s*N?'-'\s*\)\s*(AS\s+)?\[?" + n + r"\]?\b", code, re.I):
            return "슬래시", f"AS-IS 는 ISNULL(x,'-') AS {name} (빈값 대체)"
        if re.search(r"ISNULL\s*\((?:[^()]|\([^()]*\))*,\s*N?''\s*\)\s*(AS\s+)?\[?" + n + r"\]?\b", code, re.I):
            return "슬래시", f"AS-IS 는 ISNULL(x,'') AS {name} (빈값 대체)"
    if not re.search(r"N?'-'", code):
        return "슬래시", "AS-IS 대응 객체에 '-' 리터럴 없음(이관 추가분)"
    th_dash = re.search(r"\b(THEN|ELSE)\s+N?'-'", code, re.I); th_blank = re.search(r"\b(THEN|ELSE)\s+N?''(?!')", code, re.I)
    if role_hint == "CASE_VALUE":
        if th_blank and not th_dash:
            return "슬래시", "AS-IS CASE 결과값은 '' (이관 때 '-' 로 치환된 것)"
        if th_dash and not th_blank:
            return "유지", "AS-IS CASE 결과값에 '-' 존재(원래 값) — 같은 CASE 인지 확인"
    if re.search(r"\b(THEN|ELSE|VALUES\s*\(|SELECT|,)\s*N?'-'", code, re.I):
        return "미확정", "AS-IS 대응 객체에 '-' 리터럴 존재 — 같은 자리인지 수작업 확인"
    return "미확정", "AS-IS 대응 객체에 '-' 존재(용도 불명)"


# ------------------------------------------------------------------------------------------------------------
# 액션 부여
# ------------------------------------------------------------------------------------------------------------
def assign_actions(trows, cols, mods):
    meaning = {(c["table"], c["column"]) for c in cols if c["auto"] == "제외"}
    # '-' 를 유효값으로 쓰는 컬럼 = AS-IS 분기·비교 근거(457) ∪ AS-IS 실데이터에 '-' 행 존재(금지 84 · 공존 69)
    valid_dash = {(c["table"], c["column"]) for c in cols if c["auto"] == "제외" or str(c.get("dclass", "")).startswith(("금지", "공존"))}
    only_dash = {(c["table"], c["column"]) for c in cols if str(c.get("dclass", "")).startswith("보류")}      # 빈값 없이 '-' 만 + AS-IS 코드 근거(51)
    popset = {(c["table"], c["column"]) for c in cols}
    by_name = collections.defaultdict(list)
    for m in mods:
        by_name[m["name"].upper()].append(m["definition"])
    mod_index = set(by_name)
    cp_cache = {}

    def counterparts(r):
        k = (r["sub"], r["name"])
        if k not in cp_cache:
            cp_cache[k] = old.asis_counterparts(r["sub"], r["name"], mod_index)
        return cp_cache[k]

    for r in trows:
        dyn = r["dynamic"]
        cands = {tuple(x) for x in r["refs"]} | {tuple(x) for x in r["dest"]}
        fixed = sorted({(t, c) for t, c, tier in cands if tier == "확정" and (t, c) in popset})
        loose = sorted({(t, c, tier) for t, c, tier in cands if tier != "확정" and (t, c) in popset})
        r["fixed"] = fixed; r["loose"] = loose
        r["mean_cols"] = [x for x in fixed if x in meaning]
        cps = counterparts(r); r["asis_cp"] = ", ".join(cps)
        defs = [d for n in cps for d in by_name.get(n, [])]
        pos = (r.get("colpos") or 0) - 1
        raw = r.get("raw") or r["text"]
        lead = r.get("lead", 0)
        p = pos - lead if pos >= 0 else -1
        ln = 5 if dyn else 3
        act = conf = why = ""; chg = None
        role = r["role"]
        has_marker = any(m in r["markers"] for m in MARK_MIG)
        if role == "NON_SENTINEL":
            act, conf, why = "유지(비센티널)", "높음", r["detail"]
        elif r["nullchk"]:
            act, conf, why = "비교→'/'", "높음", "NVL(x,'-') = '-' (빈값 검사) → NVL(x,'/') = '/' — 구조 불변"
            chg = rewrite_nullchk(raw, dyn)
            if chg is None:
                conf = "수작업"; why += " (자동 변경안 생성 실패)"
        elif role in ("NVL",):
            act, conf, why = "NVL→'/'", "높음", "NULL 일 때만 채우는 초기값 — 뜻 불변"
            write_path = bool(r["dest"]) or "적재 대상" in r["notes"] or bool(re.search(r"^\s*,?\s*[\w.]+\s*=\s*(NVL|COALESCE)\s*\(|\bSET\s+[\w.]+\s*=\s*(NVL|COALESCE)\s*\(|\bVALUES\s*\(", raw, re.I))
            if write_path:
                chg = rewrite_nvl_write(raw, p, ln, dyn) if p >= 0 else None
                why = "적재 경로 초기값 — NVL(NULLIF(RTRIM(x),''),'/') 로 ''·' '·뒤공백 유입 차단(데이터 변환 규칙 RTRIM 과 동일)" + (" (단순 치환: 이미 TRIM/NULLIF 감쌈 또는 복합식)" if chg and "RTRIM(" not in chg[len(raw[:p]) - 40 if p >= 40 else 0:] else "")
            else:
                chg = rewrite_literal(raw, p, ln) if p >= 0 else None
            if r["mean_cols"]:
                why += " · 대상 컬럼은 '-' 를 값으로도 씀(넘어온 '-' 는 그대로)"
        elif role == "NVL_CMP":
            act, conf, why = "NVL→'/'", "높음", "null-safe 비교 양변 NVL — 양변 모두 '/' (같은 줄의 다른 '-' 행과 함께 변경)"
            chg = rewrite_literal(raw, p, ln) if p >= 0 else None
            if r["mean_cols"]:
                conf = "중"; why += " · '-' 의미 컬럼 — 변경 후 빈값('/')≠'-' 가 됨(AS-IS 도 ''≠'-' 였음)"
        elif role in ("PREDICATE", "BRANCH"):
            act = "비교→'/'"; conf = "높음"
            why = "빈값 비교 리터럴 '-' → '/' (연산자 구조 불변, IN/OR 추가 없음 — 데이터 변환 후 빈값은 '/' 만 남는다는 전제)"
            chg = rewrite_compare(raw, p, ln, dyn) if p >= 0 else None
            if chg is None:
                conf = "수작업"; why = "CASE x WHEN '-' / NULLIF / DECODE / LIKE 등 — 자동 치환 위치를 못 잡음, 수작업"
            if r["mean_cols"]:
                # AS-IS 원래 비교인지
                names = [c for _, c in r["mean_cols"]]
                if defs and any(re.search(r"\b" + re.escape(c) + r"\]?\s*(=|<>|!=|IN\s*\()\s*[^)]*N?'-'", old.strip_ms_comments("\n".join(defs)), re.I) for c in names):
                    conf = "중" if conf == "높음" else conf
                    why += " · AS-IS 원래 비교(실제 '-' 값) — '/' 추가는 빈값도 같이 잡음(현재 TO-BE 동작과 동일, AS-IS 는 ''≠'-')"
        elif role in ("CASE_VALUE", "LOAD", "ASSIGN", "DEFAULT"):
            gm = re.search(r"GTT\((\w+)\)\.(\w+)", r["notes"])
            name = r.get("alias") or (fixed[0][1] if fixed else (gm.group(2) if gm else (loose[0][1] if loose else "")))
            if role == "DEFAULT":
                act, conf, why = "리터럴→'/'", "높음", "파라미터/변수 DEFAULT '-' → '/'"
            elif has_marker:
                act, conf, why = "리터럴→'/'", "높음", "이관 작업 마커 있음(" + r["markers"] + ") — 이관 추가분"
            elif re.search(r"WHEN\s+1\s*=\s*2\s+THEN\s+'-'", raw, re.I):
                act, conf, why = "리터럴→'/'", "높음", "더미 CASE(1=2) — 영향 없음"
            else:
                o, reason = asis_literal_origin(defs, name, role)
                act = {"유지": "유지(AS-IS 값)", "슬래시": "리터럴→'/'", "미확정": "미확정(검토)"}[o]
                conf = {"유지": "중", "슬래시": "중" if defs else "중", "미확정": "수작업"}[o]
                why = reason
            if act == "리터럴→'/'":
                chg = rewrite_literal(raw, p, ln) if p >= 0 else None
            if not fixed and not loose and r.get("alias") and "GTT(" not in r["notes"]:
                why += " · 조회 출력 컬럼(테이블 적재 아님 — 화면 표시값 '-'→'/' 영향)"
        else:
            act, conf, why = "미확정(검토)", "수작업", r["detail"]
        # 2026-10-07 사용자 확정(9차): 보류는 AS-IS 데이터에 빈값 없이 '-' 만 있는 금지 84 컬럼에만. 그 외 컬럼의 '-' 는 빈값 자리표시로 보고 '/' 적용
        vd = [x for x in fixed if x in only_dash] or [(t, c) for t, c, _ in loose if (t, c) in only_dash]
        # 변형 정규화(hook #119 §1.5): TRIM(x) IN ('-','--') THEN '-' → IN ('-','--','/') THEN '/'  (같은 줄의 두 '-' 행에 동일 변경안)
        vrx = re.compile(r"IN\s*\(\s*(''|')-\1\s*,\s*\1--\1\s*\)(\s*THEN\s*\1-\1)?", re.I)
        mv = vrx.search(raw)
        if mv and r["role"] in ("BRANCH", "PREDICATE", "CASE_VALUE") and act not in ("유지(비센티널)",):
            q = mv.group(1)
            new = f"IN ({q}-{q}, {q}--{q}, {q}/{q})" + ((" THEN " + f"{q}/{q}") if mv.group(2) else "")
            chg = raw[:mv.start()] + new + raw[mv.end():]
            act = "변형정규화→'/'"; conf = "높음"
            why = "변형 정규화(' '·'-'·'--' 를 빈값으로 합치던 식) — 결과값 '/', IN 목록에 '/' 추가하고 '-'·'--' 는 잔여 변형 정규화용으로 유지(정규화식이라 인덱스 무관)"
        if act in ("리터럴→'/'", "비교→'/'", "변형정규화→'/'") and vd:
            kind0 = act
            act = "미확정(검토)"; conf = "수작업"
            why = ("대상 컬럼 " + ", ".join(f"{t}.{c}" for t, c in vd[:4]) + (" 외" if len(vd) > 4 else "") +
                   " 은(는) 빈값 없이 '-' 만 있고 AS-IS 코드가 '-' 를 비교·분기하는 보류 51 컬럼(1b 시트) — " + kind0 + " 자동 적용 보류 / 원 판정: " + why)
        r["action"] = act; r["conf"] = conf; r["why"] = why
        r["changed2"] = ILLEGAL.sub(" ", (chg or "").strip())[:500] if chg else ("(유지)" if act.startswith("유지") else "")
        if act in ("리터럴→'/'", "NVL→'/'") and not chg:
            r["conf"] = "수작업"; r["why"] += " (자동 변경안 생성 실패)"
    return trows


# ------------------------------------------------------------------------------------------------------------
# 데이터 변환 분류(타 팀용)
# ------------------------------------------------------------------------------------------------------------
def data_class(cols, adata, space=None):
    space = space or {}
    for c in cols:
        sp = (space.get((c.get("asis_db") or "") + "|" + c["table"]) or {}).get("cols", {}).get(c["column"]) if c.get("asis_db") else None
        c["sp_only"] = sp["space_only"] if sp else ""; c["sp_trail"] = sp["trail_sp"] if sp else ""; c["sp_pure"] = (sp["blank_any"] - sp["space_only"]) if sp else ""
        c["sp_total"] = ""
        if not c["asis_db"]:
            c["dclass"] = "신규(AS-IS 테이블 없음) — 일괄 변환 가능"; c["a_blank"] = ""; c["a_dash"] = ""; continue
        t = adata.get(c["asis_db"] + "|" + c["table"])
        if not t or t.get("error"):
            c["dclass"] = "미확인(AS-IS 스캔 실패)"; c["a_blank"] = ""; c["a_dash"] = ""; continue
        x = t["cols"].get(c["column"])
        if x is None:
            c["dclass"] = "미확인(AS-IS 컬럼 미스캔)"; c["a_blank"] = ""; c["a_dash"] = ""; continue
        b = x["blank"]; d = x["dash"] + x["ddash"]
        c["a_blank"] = b; c["a_dash"] = d
        c["sp_total"] = t.get("total", "")
        if b and d:
            c["dclass"] = "공존 — 행 단위 대조 필요"
        elif d:
            # 2026-10-07 사용자 확정(10차): 빈값 없이 '-' 만 있어도 AS-IS 코드가 '-' 를 비교·분기하지 않으면 자리표시 → '/' 대상
            c["dclass"] = ("보류 — AS-IS 코드가 '-' 비교·분기(1b 시트에서 결정)" if c["auto"] == "제외"
                           else "대상(코드 근거 없음 · '-' 는 자리표시) — 일괄 변환 가능")
        elif b:
            c["dclass"] = "안전(빈값만) — 일괄 변환 가능"
        else:
            c["dclass"] = "안전 — 일괄 변환 가능"
    return cols


# ------------------------------------------------------------------------------------------------------------
# FE '-' 기본값
# ------------------------------------------------------------------------------------------------------------
def fe_dash_defaults():
    try:
        out = subprocess.run(["rg", "-n", "--no-heading", "-g", "*.ts", "-g", "*.tsx", "-g", "!*.test.*", r"(\?\?|\|\||:|=|\()\s*'-'", FE_ROOT],
                             capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=120).stdout
    except Exception as e:
        return [["(rg 실행 실패: %s)" % str(e)[:100], "", "", "", ""]]
    rows = []
    for ln in out.splitlines():
        m = re.match(r"(.+?):(\d+):(.*)", ln)
        if not m:
            continue
        path, line, code = m.group(1), int(m.group(2)), m.group(3).strip()
        rel = os.path.relpath(path, FE_ROOT)
        low = (rel + " " + code).lower()
        if code.startswith(("//", "*", "/*")):
            kind = "주석(변경 불필요)"
        elif re.search(r"</|<\w+[\s>]|\bt\(|typography|label|title|debug|console|preview|tooltip|format", low):
            kind = "표시용(변경 불필요)"
        elif re.search(r"===\s*'-'|!==\s*'-'|\.filter\(|includes\('-'\)", low):
            kind = "비교(동치 — '/' 도 같이 볼지 검토)"
        elif re.search(r"payload|request|\.api\.|save|store|params|filters|\bid:|_id\b|code:", low):
            kind = "저장·조회 payload 기본값(변경 대상 후보)"
        else:
            kind = "확인 필요"
        rows.append([rel, line, kind, ILLEGAL.sub(" ", code)[:300], ""])
    rows.sort(key=lambda r: (r[2], r[0], r[1]))
    return rows


# ------------------------------------------------------------------------------------------------------------
# xlsx
# ------------------------------------------------------------------------------------------------------------
def write_xlsx2(pop, cat, meta, mods, cols, ev_all, cs, trows, stats, out_path, op_cols, tobe_objs=()):
    from openpyxl import Workbook
    from openpyxl.styles import Font, PatternFill, Alignment
    from openpyxl.utils import get_column_letter
    wb = Workbook()
    hdr = PatternFill("solid", fgColor="DDEBF7")
    fill = {"NVL→'/'": "C6E0B4", "비교→'/'": "BDD7EE", "변형정규화→'/'": "9BC2E6", "리터럴→'/'": "E2EFDA", "유지(AS-IS 값)": "F8CBAD", "유지(비센티널)": "EDEDED", "미확정(검토)": "FFE699",
            "'-' 의미 사용": "F8CBAD", "단순(빈값 대체만)": "C6E0B4"}

    def sheet(title, headers, rows, widths, vcol=None, freeze="A2"):
        ws = wb.create_sheet(title)
        ws.append(headers)
        for r in rows:
            ws.append([ILLEGAL.sub(" ", v) if isinstance(v, str) else v for v in r])
        for c in ws[1]:
            c.font = Font(bold=True); c.fill = hdr; c.alignment = Alignment(wrap_text=True, vertical="center")
        ws.freeze_panes = freeze; ws.auto_filter.ref = ws.dimensions
        for i, w in enumerate(widths, 1):
            ws.column_dimensions[get_column_letter(i)].width = w
        if vcol is not None:
            for row in ws.iter_rows(min_row=2, min_col=vcol + 1, max_col=vcol + 1):
                f = fill.get(str(row[0].value))
                if f:
                    row[0].fill = PatternFill("solid", fgColor=f)
        return ws

    popset = {(c["table"], c["column"]) for c in cols}
    # --- 1_컬럼판정
    h1 = ["스키마", "테이블", "컬럼", "데이터형", "현재 DB 상태", "AS-IS DEFAULT 값", "적용 DEFAULT",
          "AS-IS '-' 사용 분류", "분류 사유", "근거 발췌 1", "근거 발췌 2", "근거 발췌 3",
          "[타 팀] 데이터 변환 분류", "AS-IS 빈값 행수(10-01, ''+' ' 합산)", "AS-IS '-' 행수(10-01)", "AS-IS '' 행수(10-07)", "AS-IS 공백만(' ') 행수(10-07)", "AS-IS 뒤공백 값 행수(10-07)", "AS-IS DB", "비고"]
    r1 = [[c["owner"], c["table"], c["column"], c["dtype"], c["state"], (c["asis_default_val"] or ("(DEFAULT 없음)" if c["asis_db"] else "(AS-IS 테이블 없음)")), c["apply_default"],
           {"제외": "'-' 의미 사용", "대상": "단순(빈값 대체만)"}.get(c["auto"], c["auto"]), c["why"]] + c["samples"] +
          [c["dclass"], c["a_blank"], c["a_dash"], c["sp_pure"], c["sp_only"], c["sp_trail"], c["asis_db"], ""] for c in cols]
    sheet("1_컬럼판정", h1, r1, [9, 34, 24, 10, 20, 16, 10, 16, 50, 60, 60, 60, 30, 12, 12, 12, 12, 12, 13, 24], vcol=7, freeze="D2")

    # --- 1b_보류51컬럼_검토 : 빈값 없이 '-' 만 + AS-IS 코드가 '-' 비교·분기 — 사용자 결정용
    cls_k = {"A": "분기문", "A_NULLCHK": "분기문(NULL검사 겸용)", "B": "조건절 비교", "B_NULLCHK": "조건절(NULL검사 겸용)"}
    hold = [c for c in cols if str(c.get("dclass", "")).startswith("보류")]
    evmap = collections.defaultdict(list)
    for e in ev_all:
        if e["cls"] in cls_k:
            for t, c, tier in {tuple(x) for x in e["refs"]}:
                evmap[(t, c)].append((tier, e))
    tobe_cnt = collections.defaultdict(collections.Counter)
    for r in trows:
        for t, c in r.get("fixed", []):
            tobe_cnt[(t, c)][r["action"]] += 1
        for t, c, _ in r.get("loose", []):
            tobe_cnt[(t, c)]["(후보)"] += 1
    r1b = []
    for c in hold:
        k = (c["table"], c["column"]); evs = evmap.get(k, [])
        fixed = [e for tier, e in evs if tier == "확정"]
        objs = sorted({e["object"] for _, e in evs})
        kinds = collections.Counter(cls_k[e["cls"]] for _, e in evs)
        seen = set(); sm = []
        for tier, e in sorted(evs, key=lambda x: (0 if x[0] == "확정" else 1, 0 if x[1]["cls"] == "A" else 1)):
            key = (e["object"], e["line"])
            if key in seen:
                continue
            seen.add(key); sm.append(f"[{e['object']} L{e['line']} · {cls_k[e['cls']]} · {tier}] {e['snip']}")
            if len(sm) == 4:
                break
        tc = tobe_cnt.get(k, collections.Counter())
        tot = c.get("sp_total") or ""; d = c.get("a_dash") or 0
        if fixed:
            etype = "① 이 테이블.컬럼에 AS-IS DB 비교·분기 확정"
        elif evs:
            etype = "② DB 비교·분기는 있으나 테이블 미확정(간접·변수·추정)"
        elif c.get("cs_same"):
            etype = "③ DB 근거 없음 — C# 분기 컬럼명(5종) 규칙"
        else:
            etype = "④ DB 근거 없음 — 컬럼명 단위 제외 규칙(7종, 타 테이블 근거)"
        pct = (round(100 * d / tot, 1) if tot else "")
        r1b.append([c["table"], c["column"], etype, tot, d, pct, c.get("sp_pure", ""), c.get("sp_only", ""),
                    " · ".join(f"{k2} {v}" for k2, v in kinds.most_common()), len(fixed), len(objs), ", ".join(objs)[:300]] + sm + [""] * (4 - len(sm)) +
                   [sum(v for a, v in tc.items() if a != "(후보)"), tc.get("미확정(검토)", 0), tc.get("(후보)", 0), "", ""])
    r1b.sort(key=lambda x: (x[2], -(x[5] or 0), x[0], x[1]))
    sheet("1b_보류51컬럼_검토", ["테이블", "컬럼", "근거 유형", "AS-IS 전체 행", "AS-IS '-' 행", "'-' 비율(%)", "AS-IS '' 행", "AS-IS ' ' 행",
                             "AS-IS 근거 종류·건수", "테이블 확정 근거 수", "근거 객체 수", "근거 객체", "근거 발췌 1", "근거 발췌 2", "근거 발췌 3", "근거 발췌 4",
                             "TO-BE 관련 줄(확정)", "그중 미확정(검토)", "TO-BE 후보 줄(미확정 컬럼)", "결정(유지 '-' / 슬래시)", "비고"],
          r1b, [34, 24, 40, 12, 12, 8, 10, 10, 30, 8, 8, 60, 90, 90, 90, 90, 10, 10, 10, 14, 30], freeze="D2")

    # --- 2_DEFAULT_DDL
    r2 = []
    for c in cols:
        ap = c["apply_default"]; cd = c["cur_default"]
        if cd == ap:
            ddl = "-- 변경 없음 (현재 DEFAULT 가 이미 적용 값과 같음)"
        elif cd == "'-'":
            on = " ON NULL" if c["cur_on_null"] == "YES" else ""
            ddl = f"ALTER TABLE {c['owner']}.{c['table']} MODIFY ({c['column']} DEFAULT{on} {ap});"
        elif cd in (None, "", "NULL"):
            ddl = f"ALTER TABLE {c['owner']}.{c['table']} MODIFY ({c['column']} DEFAULT ON NULL {ap});  -- 현재 DEFAULT 없음 → '/' (사용자 확정 10-07)" + \
                  ("  -- ⚠ 현재 NULL 허용 컬럼: DEFAULT ON NULL 은 NOT NULL 을 내포하므로 적용 시 NOT NULL 로 바뀜" if c.get("nullable_now") == "Y" else "")
        else:
            ddl = f"-- 유지: 현재 DEFAULT {cd} ('-' 가 아닌 기존 값은 그대로, 사용자 확정 10-07)"
        r2.append([c["owner"], c["table"], c["column"], c["state"], ap, ddl])
    sheet("2_DEFAULT_DDL", ["스키마", "테이블", "컬럼", "현재 DB 상태", "적용 DEFAULT", "DDL (실행하지 않음 — 검토용)"], r2, [9, 34, 24, 22, 12, 110])

    # --- 3_TOBE_변경목록
    role_nm = {"NVL": "NVL 초기값", "NVL_CMP": "NVL 비교(null-safe)", "BRANCH": "분기(IF/CASE/DECODE/NULLIF)", "PREDICATE": "조건절 비교",
               "CASE_VALUE": "CASE 결과값", "LOAD": "리터럴 적재", "ASSIGN": "대입", "DEFAULT": "DEFAULT 선언", "OTHER": "기타", "NON_SENTINEL": "비센티널"}
    h3 = ["스키마", "객체유형", "객체명", "서브프로그램", "줄", "열", "액션", "확신도", "쓰임", "동적SQL", "대상 컬럼(확정)", "'-' 의미 컬럼", "후보 컬럼(미확정)",
          "원문", "변경안", "사유", "AS-IS 대응 객체", "이관작업 마커", "상세", "비고"]
    key = lambda r: (r["owner"], r["name"], r["type"], r["line"], r.get("colpos") or 0)
    r3 = []
    for r in sorted(trows, key=key):
        fx = ", ".join(f"{t}.{c}" for t, c in r["fixed"])
        lo = r["loose"]; lo_txt = ", ".join(f"{t}.{c}({tier})" for t, c, tier in lo[:6]) + (f" 외 {len(lo) - 6}" if len(lo) > 6 else "")
        r3.append([r["owner"], r["type"], r["name"], r["sub"], r["line"], r.get("colpos", ""), r["action"], r["conf"], role_nm.get(r["role"], r["role"]),
                   "Y" if r["dynamic"] else "", fx, ", ".join(f"{t}.{c}" for t, c in r["mean_cols"]), lo_txt, r["text"], r["changed2"], r["why"],
                   r["asis_cp"], r["markers"], r["detail"], r["notes"][:200]])
    sheet("3_TOBE_변경목록", h3, r3, [9, 13, 34, 34, 6, 5, 14, 7, 18, 6, 40, 30, 40, 90, 90, 60, 34, 16, 40, 40], vcol=6, freeze="H2")

    # --- 4_TOBE_객체별요약
    acts = ["NVL→'/'", "비교→'/'", "변형정규화→'/'", "리터럴→'/'", "유지(AS-IS 값)", "유지(비센티널)", "미확정(검토)"]
    agg = collections.defaultdict(collections.Counter); cps = collections.defaultdict(set); subs = collections.defaultdict(set)
    for r in trows:
        k = (r["owner"], r["type"], r["name"]); agg[k][r["action"]] += 1; agg[k]["수작업"] += (r["conf"] == "수작업")
        if r["asis_cp"]:
            cps[k].update(r["asis_cp"].split(", "))
        if r["sub"]:
            subs[k].add(r["sub"])
    r4 = [[k[0], k[1], k[2], sum(v[a] for a in acts)] + [v[a] for a in acts] + [v["수작업"], len(subs[k]), ", ".join(sorted(cps[k]))[:300]]
          for k, v in sorted(agg.items(), key=lambda kv: (-sum(kv[1][a] for a in acts), kv[0]))]
    sheet("4_TOBE_객체별요약", ["스키마", "객체유형", "객체명", "'-' 출현 합계"] + acts + ["수작업 건", "서브프로그램 수", "AS-IS 대응 객체"], r4,
          [9, 13, 40, 10, 9, 10, 10, 9, 10, 10, 10, 8, 9, 80])

    # --- 5_동치정규화(ASIS·C#)
    cls_nm = {"A_NULLCHK": "ISNULL(x,'-') 비교(분기)", "B_NULLCHK": "ISNULL(x,'-') 비교(조건절)", "A": "분기", "B": "조건절"}
    eqrx = re.compile(r"IS\s+NULL[^⏎]*'-'|'-'[^⏎]*IS\s+NULL|=\s*''[^⏎]*'-'|'-'[^⏎]*=\s*''|ISNULL\s*\([^()]*,\s*N?'-'\s*\)\s*(=|<>|!=)", re.I)
    # TO-BE 역대응: AS-IS 객체명 → TO-BE 객체
    rev = collections.defaultdict(set)
    has_dash_obj = {(r["name"], r["sub"]) for r in trows}
    mod_index = {m["name"].upper() for m in (mods["mods"] if isinstance(mods, dict) else mods)}
    for ow, name, sub in tobe_objs:
        for n in old.asis_counterparts(sub or name, name, mod_index):
            tag = f"{name}.{sub}" if sub and sub != name else name
            rev[n].add(tag + ("" if (name, sub) in has_dash_obj or (name, name) in has_dash_obj else " (TO-BE 에 '-' 없음)"))
    for r in trows:
        for n in (r["asis_cp"].split(", ") if r["asis_cp"] else []):
            rev[n].add(f"{r['name']}.{r['sub']}" if r["sub"] and r["sub"] != r["name"] else r["name"])
    r5 = []
    for e in ev_all:
        if e["cls"] not in cls_nm or e["src"] != "DB":
            continue
        if "NULLCHK" not in e["cls"] and not eqrx.search(e["snip"]):
            continue
        refs = sorted({(t, c) for t, c, _ in {tuple(x) for x in e["refs"]} if (t, c) in popset})
        r5.append(["AS-IS DB", e["loc"], e["object"], e["line"], cls_nm[e["cls"]], ", ".join(f"{t}.{c}" for t, c in refs) or ", ".join(n for n, _ in op_cols(e["notes"])),
                   e["snip"], ", ".join(sorted(rev.get(e["object"].upper(), ()))) or "(TO-BE 대응 객체 미발견)", ""])
    bak = re.compile(r"^zjjg_|_backup|_bkup|_org\b|_ORG\b|_YMH|_TUNING|_\d{8}|_KHR\d*$|_TEST$|_OLD$", re.I)
    for row in r5:
        if row[7].startswith("(TO-BE"):
            row[7] = "(AS-IS 백업·변형본 — 대응 불필요)" if bak.search(row[2]) else "(TO-BE 대응 객체 없음 — 미이관 배치·I/F 또는 이름 불일치)"
    r5.sort(key=lambda x: (x[0], x[2], x[3] or 0))
    sheet("5_동치정규화(ASIS DB)", ["원천", "DB", "객체", "줄", "형태", "컬럼", "발췌", "TO-BE 대응 객체(비교→'/' 적용 위치)", "비고"], r5,
          [8, 14, 44, 7, 24, 40, 110, 60, 30])

    # --- 6_C#로직_DB흡수 : AS-IS 화면(C#)의 NULL·''·' '·'-'·'--' 처리 → TO-BE 는 FE 가 아니라 조회/저장 SP 에 흡수 (사용자 확정 2026-10-07)
    cs_eq = re.compile(r'==\s*""|IsNullOrEmpty|IsNullOrWhiteSpace|==\s*null|SafeString\(\)\s*==\s*""|==\s*" "|==\s*"--"', re.I)
    by_screen = collections.defaultdict(set)
    for ow, name, sub in tobe_objs:
        by_screen[name.upper()].add(name)
    r6 = []
    for r in cs["rows"]:
        mm = re.findall(r"([A-Z]{2,3}\d{4,5}(?:_\d+)?)", r["path"].upper())
        scr = (mm[-1] if mm else (r["screen"] or "")).upper()
        base = re.sub(r"_\d+$", "", scr)
        cands = sorted(by_screen.get("PKG_" + scr, set()) | by_screen.get("PKG_" + base, set()) |
                       {n for n in by_screen if n.startswith(scr + "_") or n.startswith(base + "_")})
        colz = ", ".join(r["same"]) or ", ".join(r["near"])
        eqv = bool(cs_eq.search(r["snip"]))
        if r["branch"]:
            kind = "분기 — NULL·''·'-' 동치" if eqv else "분기 — '-' 만 비교"
        else:
            kind = "비교(분기 아님)"
        c1 = (r["same"] or r["near"] or ["<col>"])[0]
        if eqv:
            tpl = (f"조회 SP 출력: CASE WHEN NVL(NULLIF(TRIM({c1}),''),'/') IN ('/','-','--') THEN <C# 분기 결과값> ELSE {c1} END AS {c1} "
                   f"/ 저장·조건 SP 입력: NVL(NULLIF(TRIM(:{c1}),''),'/') — C# 분기 결과를 SP 가 대신 내려주도록 설계(수작업)")
        else:
            tpl = f"조회 SP 출력: CASE WHEN {c1} IN ('/','-') THEN <C# 분기 결과값> ELSE {c1} END — '-' 비교에 '/' 를 같은 값으로(수작업 설계)"
        if not cands:
            if r["path"].startswith(("01.Framework", "03.BIZ", "04.WSL")) or "Common" in r["path"] or "Utils" in r["path"]:
                tgt = "(AS-IS 공통 프레임워크 — 화면 무관. TO-BE 공통 처리(조회 SP 공통 출력 규약)로 흡수)"
            elif scr.startswith("FP"):
                tgt = "(FP 화면 — TO-BE FP_MGR 에 SP/PKG 없음. FP 이관 시 반영)"
            else:
                tgt = "(화면 ID %s 로 TO-BE 객체 못 찾음 — 수작업 매핑)" % (scr or "없음")
        else:
            tgt = ", ".join(cands)
        r6.append([scr or r["screen"], r["path"], r["line"], kind, colz, r["snip"], tgt, tpl, ""])
    r6.sort(key=lambda x: (x[3], x[0], x[1], x[2]))
    sheet("6_C#로직_DB흡수", ["AS-IS 화면", "C# 파일(GSCM/ 기준)", "줄", "형태", "컬럼명(줄 내)", "C# 발췌", "TO-BE 흡수 대상 객체(후보)", "흡수 방안(템플릿 — 결과값은 C# 원문 보고 확정)", "비고"],
          r6, [12, 60, 7, 22, 24, 110, 44, 110, 30])

    # --- 6_FE_기본값
    sheet("7_FE_대시기본값", ["파일(features/ 기준)", "줄", "분류(추정)", "원문", "비고"], fe_dash_defaults(), [70, 7, 34, 120, 30])

    # --- 7 AS-IS 근거(참고)
    h7 = ["테이블", "컬럼", "근거 종류", "컬럼 특정 수준", "동적SQL", "원천", "DB/파일", "객체", "객체유형", "줄", "문장·피연산자", "발췌", "비고"]
    cls_all = {"A": "분기문", "A_NULLCHK": "분기문·NULL검사 겸용", "B": "조건절 비교", "B_NULLCHK": "조건절·NULL검사 겸용"}
    r7 = []
    for e in ev_all:
        if e["cls"] not in cls_all:
            continue
        for tb, c, tier in sorted({tuple(x) for x in e["refs"] if (x[0], x[1]) in popset}):
            r7.append([tb, c, cls_all[e["cls"]], tier, "Y" if e["dynamic"] else "", e["src"], e["loc"], e["object"], e["otype"], e["line"], e["detail"], e["snip"], e["notes"]])
    for r in cs["rows"]:
        for cn, where in ([(x, "같은 줄") for x in r["same"]] + [(x, "인접 줄") for x in r["near"]]) or [("(컬럼 미특정)", "")]:
            r7.append(["(C# — 테이블 미특정)", cn, "C# 분기" if r["branch"] else "C# 비교(분기 아님)", "컬럼명 " + where if where else "", "", "C#", r["path"], r["screen"], "cs", r["line"], "", r["snip"], ""])
    r7.sort(key=lambda x: (x[1], x[0], x[2], x[3], str(x[7]), x[9] or 0))
    sheet("8_ASIS분기근거(참고)", h7, r7, [34, 24, 18, 12, 6, 6, 30, 44, 16, 7, 60, 110, 40])
    colnames = {c["column"] for c in cols}
    r7b = [[", ".join(sorted({n for n, w in op_cols(e["notes"])})), "Y" if any(n in colnames for n, w in op_cols(e["notes"])) else "",
            cls_all[e["cls"]], "Y" if e["dynamic"] else "", e["src"], e["loc"], e["object"], e["otype"], e["line"], e["detail"], e["snip"], e["notes"]]
           for e in ev_all if e["cls"] in ("A", "A_NULLCHK") and not [x for x in e["refs"] if (x[0], x[1]) in popset]]
    r7b.sort(key=lambda x: (x[0], x[5], str(x[6]), x[8] or 0))
    sheet("8b_ASIS분기_컬럼미연결(참고)", ["피연산자 컬럼명", "모집단 컬럼명과 동일", "근거 종류", "동적SQL", "원천", "DB/파일", "객체", "객체유형", "줄", "문장·피연산자", "발췌", "미연결 사유"],
          r7b, [24, 8, 18, 6, 6, 30, 44, 16, 7, 60, 110, 60])

    # --- 요약
    ws = wb["Sheet"]; ws.title = "요약"
    vc = collections.Counter(c["auto"] for c in cols); ac = collections.Counter(r["action"] for r in trows); cc = collections.Counter(r["conf"] for r in trows)
    dc = collections.Counter(c["dclass"] for c in cols)
    L = [["NULL 센티널 '-' → '/' 전환 — DEFAULT DDL · DB 객체 변경 목록 · (타 팀) 데이터 변환 분류"], [],
         ["범위 (사용자 확정 2026-10-07)"],
         ["  이 파일로 진행하는 작업 = ① 1,797 컬럼 DEFAULT '/' (2_DEFAULT_DDL)  ② PKG/SP/VIEW/FUNCTION 의 '-' 변경 (3_TOBE_변경목록 · 4_TOBE_객체별요약)  ③ AS-IS C# 의 NULL·''·' '·'-'·'--' 처리를 TO-BE SP 에 흡수 (6_C#로직_DB흡수)  ④ FE '-' 기본값 (7_FE_대시기본값)"],
         ["  C# 로직은 FE 에서 재구현하지 않고 DB 객체(조회·저장 SP)에 담아 AS-IS 와 같은 값이 보이게 한다(사용자 확정 2026-10-07). 6 시트의 '흡수 방안' 은 템플릿이며 결과값은 C# 원문으로 확정한다."],
         ["  기존 데이터 '-'→'/' 변환은 타 팀 — 1_컬럼판정 의 '[타 팀] 데이터 변환 분류' 열로 범위를 넘긴다(안전/금지/공존). 공존 컬럼은 AS-IS 원천과 행 단위 대조 필요."],
         ["  방침: 빈값 대체는 전부 '/' · 넘어온 '-' 값은 그대로 · AS-IS 원래 '-' 로직은 유지 · 비교 리터럴은 구조 불변 치환(= '/') · MSSQL 전송 시 '/'→''"],
         ["  공백 규칙(사용자 확정 10-07): MSSQL 은 ''=' '='A ' 동치이므로 데이터 변환 시 공백만(' ')→'/', 값 뒤공백은 RTRIM. DML 적재 경로도 NVL(NULLIF(RTRIM(x),''),'/') 로 같은 규칙 적용. 조회·비교에는 TRIM 을 씌우지 않는다(인덱스 보호)."], [],
         ["기준"],
         [f"  모집단: {pop['file']} / '처리대상이력' {len(pop['rows']):,}행"],
         [f"  TO-BE: 사내 {cat['service']} 컬럼 사전 {cat['fetched']} / 소스 {stats['tobe_src_fetched']} / AS-IS DEFAULT {stats['adef_source']} {stats['adef_fetched']}"],
         [f"  AS-IS DB: {mods['source']} — {mods['fetched']} / 모듈 {len(mods['mods']):,}개 / AS-IS 실데이터 '-'·빈값 건수 = 2026-10-01 스캔(DEV)"],
         [f"  AS-IS 파일: GSCM XML·SQL {stats['xml_scanned']:,}개 중 '-' 포함 {stats['xml_files']:,} / C# {cs['scanned']:,}개 중 \"-\" 비교 포함 {cs['hit_files']:,}"], [],
         ["① DEFAULT (규칙: 현재 '-' → '/', 현재 DEFAULT 없음 → '/', '-' 가 아닌 기존 DEFAULT → 유지)", "건수"],
         ["  적용 DEFAULT '/'", sum(1 for c in cols if c["apply_default"] == "'/'")],
         ["    그중 현재 DEFAULT 없음 → '/' 신규 설정", sum(1 for c in cols if c["apply_default"] == "'/'" and c["cur_default"] in (None, "", "NULL"))],
         ["  기존 DEFAULT 유지('-' 아님)", sum(1 for c in cols if c["apply_default"] != "'/'")], [],
         ["② DB 객체 '-' 출현 액션", "건수"]]
    for a in ["NVL→'/'", "비교→'/'", "변형정규화→'/'", "리터럴→'/'", "유지(AS-IS 값)", "유지(비센티널)", "미확정(검토)"]:
        L.append(["  " + a, ac[a]])
    L.append(["  합계", sum(ac.values())]); L.append(["  확신도", "높음 %d · 중 %d · 수작업 %d" % (cc["높음"], cc["중"], cc["수작업"])])
    L.append(["  객체 수", len({(r['owner'], r['name']) for r in trows}), "변경 액션이 1건 이상인 객체 " + str(len({(r['owner'], r['name']) for r in trows if r['action'] not in ('유지(AS-IS 값)', '유지(비센티널)')}))])
    L.append([f"  대사: 스캔 출현 {stats['tobe'].get('occ', 0):,} = 액션 합계 {sum(ac.values()):,} / 주석 안 '-' {stats['tobe'].get('comment_dash', 0):,}(대상 아님)"]); L.append([])
    L.append(["③ [타 팀] 데이터 변환 분류 (10-07 10차: 빈값 없이 '-' 만 있던 84 중 AS-IS 코드가 '-' 를 비교·분기하는 51 = 보류(1b 시트), 코드 근거 없는 33 = 대상)", "컬럼 수"])
    for k, v in sorted(dc.items()):
        L.append(["  " + k, v])
    sp_only_cols = sum(1 for c in cols if c["sp_only"]); sp_trail_cols = sum(1 for c in cols if c["sp_trail"])
    L.append([f"  AS-IS 공백 실태(10-07 DEV 스캔): 공백만(' ') 값 있는 컬럼 {sp_only_cols} / {sum(c['sp_only'] for c in cols if c['sp_only']):,}행 · 뒤공백 붙은 값 있는 컬럼 {sp_trail_cols} / {sum(c['sp_trail'] for c in cols if c['sp_trail']):,}행 — MSSQL 은 ''=' '='A '='A' 로 보지만 Oracle 은 전부 다른 값"])
    L.append([]); L.append(["AS-IS '-' 사용 분류(참고)", "컬럼 수"]); L.append(["  '-' 의미 사용(값 '-' 유지 필요)", vc["제외"]]); L.append(["  단순(빈값 대체만)", vc["대상"]]); L.append([])
    L.append(["액션 규칙"])
    for t in ["변형정규화→'/' : TRIM(x) IS NULL OR TRIM(x) IN ('-','--') THEN '-' (hook #119 §1.5 변형 정규화) → IN ('-','--','/') THEN '/'. '-'·'--' 는 잔여 변형을 계속 합치기 위해 유지. 정규화식이라 인덱스 영향 없음(사용자 확정 10-07).",
              "NVL→'/'      : NVL/NVL2/COALESCE(x,'-') → (x,'/') — NULL 일 때만 채우므로 뜻 불변. 컬럼 미특정(GTT·변수)이어도 적용. 적재 경로(INSERT/MERGE/UPDATE SET/VALUES/GTT 적재)는 NVL(NULLIF(RTRIM(x),''),'/') 로 ''·' '·뒤공백 유입을 막는다(사용자 확정 10-07: 데이터 변환도 공백만→'/' + RTRIM). 조회·비교 쪽은 단순 NVL(x,'/').",
              "비교→'/'      : 빈값을 뜻하던 비교 리터럴 '-' 를 '/' 로 치환 — NVL(x,'-') = '-' → NVL(x,'/') = '/' · x = '-' → x = '/' · x <> '-' → x <> '/' · IN ('-','--') → IN ('/','--'). 연산자 구조 불변(IN/OR 추가 없음, 성능 동일). 전제 = 같은 작업 창에서 데이터 변환(타 팀) 완료. 대상 컬럼이 보류 51 컬럼이면 미확정(검토), 그 외는 '/' (사용자 확정 10-07).",
              "리터럴→'/'    : SELECT/VALUES/CASE 결과/대입의 '-' 중 이관 때 넣은 빈값 자리표시(이관 마커 · AS-IS 대응 객체에 '-' 없음 · AS-IS 는 '' 또는 ISNULL(x,'-')) → '/'. 단 대상 컬럼이 보류 51 컬럼(빈값 없이 '-' 만 + AS-IS 코드 비교·분기, 1b 시트)이면 자동 적용하지 않고 미확정(검토). 그 외 컬럼의 '-' 는 빈값 자리표시로 간주(사용자 확정 10-07).",
              "유지(AS-IS 값): AS-IS 대응 객체에 같은 자리 '-' 리터럴/비교가 있는 것 — 실제 값.",
              "미확정(검토)  : AS-IS 대응 객체에 '-' 가 있으나 같은 자리인지 못 가린 것, CASE x WHEN '-' / NULLIF / DECODE 처럼 자동 변경안을 못 만든 것 → 수작업.",
              "'변경안' 은 그 행의 '-' 하나만 바꾼 한 줄이다. 한 줄에 '-' 가 여러 개면 행이 여러 개(열 로 구분) — 적용 시 같은 줄의 행을 모두 합쳐야 한다."]:
        L.append(["  " + t])
    L.append([]); L.append(["한계"])
    for t in ["정적 분석 — 컬럼 특정은 별칭·FROM 기준이며 GTT·CTE·동적 SQL 경유는 후보만 병기.",
              "AS-IS 대응 객체 = 이름 규칙(PKG_X.P_X_Y ↔ X_Y / SP_ / UP_ / PR_) 매칭 — 이름이 다른 대응은 못 찾음(유지/미확정 판단 신뢰도 영향).",
              "'유지(AS-IS 값)' 판정은 AS-IS 에 '-' AS 컬럼 / 컬럼 = '-' 가 있다는 근거 — 같은 문장인지는 수작업 확인 권장.",
              "C# 동치·FE 기본값은 컬럼명·파일 수준 — 화면별 확인 필요.", "AS-IS 실데이터 건수는 DEV(10-01) 기준 — 운영과 다를 수 있음.",
              "DB 객체·데이터 변경 없음. 이 파일은 검토용이며 실제 적용은 별도 패키지로 진행."]:
        L.append(["  " + t])
    for r in L:
        ws.append(r)
    ws["A1"].font = Font(bold=True, size=13)
    for row in ws.iter_rows(min_col=1, max_col=1):
        v = row[0].value
        if isinstance(v, str) and v and not v.startswith(" ") and row[0].row > 1:
            row[0].font = Font(bold=True)
    ws.column_dimensions["A"].width = 120; ws.column_dimensions["B"].width = 12; ws.column_dimensions["C"].width = 40
    wb.save(out_path)
