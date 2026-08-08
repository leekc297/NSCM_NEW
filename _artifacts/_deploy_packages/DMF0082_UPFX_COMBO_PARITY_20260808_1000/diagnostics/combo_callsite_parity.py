#!/usr/bin/env python3
"""combo_callsite_parity.py — AS-IS ↔ TO-BE **콤보 호출 지점 수(N:N) 대사** (2026-08-08 신설)

배경(hook #117 §5.12): SQL 도 파라미터도 맞는데 **부르는 시점이 빠지면 기능이 조용히 죽는다.**
같은 날 2건이 나왔다 —
  · `FCST_PRICE_EDIT_MEASURE` AS-IS 6지점 vs TO-BE 1지점 → **InsertRow 누락**으로 사이트 특성(VMI_YN)
    measure 필터가 시드복사 정상흐름에서 상시 미적용
  · `CELL_PROD_SITE_ID` AS-IS 2지점 vs TO-BE 0지점 (매핑표엔 "구현" 오기재)
기존 게이트(섹션 7 / E2E D2축)는 "올바른 데이터를 주는가" 만 본다 — "제때 부르는가" 는 본 도구가 담당.

추출 (다중 패턴 — anti-simplification):
  AS-IS `.cs`  ① `GetLookupValues("CODE", …)` 범용 디스패처 호출부 리터럴
               ② `Data.Type.<Code>` (기본판 은닉 호출)
               ③ `Data.User<Code>(` (은닉 호출 — UserSiteByEndCustomer 등)
               ④ `Parameters["CODE"] = "리터럴"` = **명명 헬퍼 정의** → 헬퍼의 **호출부**로 치환
               ⑤ 주석(`//`) 라인 제외 — 사문 호출은 미이관이 파리티(제외 건수 보고)
  TO-BE FE     ⑥ `getCombo({comboId:'X'…})` 명시 호출부 (+ 감싸는 함수명)
               ⑦ `useTabComboQueries` filters 리터럴 = 페이지 1회 프리페치
               ⑧ `SHEET_COLUMNS.CELL_COMBO_DATA_TYPE` = DataGrid 자동 바인딩(렌더 1회)

판정:
  FAIL  AS-IS 라이브 호출 ≥2 인데 TO-BE 명시 호출 0 & 메타 자동 바인딩도 없음 → 배선 자체 부재
  FAIL  AS-IS 에 **행 생성(InsertRow) 지점**이 있는데 TO-BE 에 신규행 프라이밍 경로 없음
        (시드복사 화면은 전 사용자가 이 경로를 타므로 가장 치명적)
  WARN  AS-IS 호출 지점 수 > TO-BE 호출 지점 수 (트리거 부족 의심 — 사유 기재 필요)
  PASS  그 외

사용:
  python combo_callsite_parity.py --menu DMF0082 --page nscm-fe/features/demand/src/pages/forecast-price
  python combo_callsite_parity.py --all          # FE MENU_ID 상수 보유 화면 전수
"""
import argparse
import datetime
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
LEGACY = ROOT / "Doc" / "_legacy_source"
FE_ROOT = ROOT / "nscm-fe" / "features"
REPORT_DIR = ROOT / "_artifacts" / "_gate_reports"

# AS-IS CODE ↔ TO-BE SQL_ID 별칭 — 정규화(영숫자 소문자) 매칭이 안 되는 개명분.
#   ⚠️ 여기에 없는 미매칭은 '미식별 WARN' 으로 노출된다(조용한 통과 금지).
CODE_ALIAS = {
    "AS_INCOTERMS": "AsIncotermsEdit",          # AS 사이트 전용 Incoterms 편집판
    "DM_CUSTOMS_HANDBOOK": "CustomsHandbook",   # lookup DM_CUSTOMS_HANDBOOK_40
    "SiteByEndCustomer40": "ScmSitebyEndCustomer40",
    "FromSiteByDivision": "PlantByDivisionCompany",
}

# 화면별 '이식 안 함' 판정 — 사유 없는 WARN 이 쌓이면 게이트가 무시된다(hook #117 §5.6 규약).
DISPOSITION = {
    "DMF0082": {
        "NO_DATA": "AS-IS 는 빈 목록 콤보로 입력 차단 — TO-BE 는 빈 DataMap 스왑으로 동등 구현(콤보 불요)",
        "TeamByDivisionAuth": "TEAM_ID 는 SAVE 파라미터 부재 = 표시 전용 → 편집판 미적용(hook #117 §5.10)",
    },
}

# 행 생성(InsertRow) 성격의 AS-IS 메서드명 — 가장 치명적인 누락 지점
INSERT_METHOD_RE = re.compile(r"insert(row|button)?|btninsert|addrow", re.I)


# ── AS-IS 추출 ────────────────────────────────────────────────────────────────
def strip_comments(text: str) -> str:
    """`//` 주석 라인을 공백으로 치환(라인 수·오프셋 보존). 블록 주석도 제거."""
    text = re.sub(r"/\*.*?\*/", lambda m: re.sub(r"[^\n]", " ", m.group(0)), text, flags=re.S)
    out = []
    for line in text.split("\n"):
        s = line.lstrip()
        out.append(" " * len(line) if s.startswith("//") else line)
    return "\n".join(out)


METHOD_RE = re.compile(
    r"^[ \t]*(?:public|private|protected|internal)\s+(?:static\s+|override\s+|async\s+|virtual\s+)*"
    r"[\w<>\[\],\. ]+?\s+(\w+)\s*\([^)]*\)\s*$",
    re.M,
)


def parse_methods(text: str):
    """(메서드명, 시작오프셋, 끝오프셋) 목록 — 시그니처 다음 '{' 부터 중괄호 균형까지."""
    out = []
    for m in METHOD_RE.finditer(text):
        i = text.find("{", m.end())
        if i < 0:
            continue
        depth, j = 0, i
        while j < len(text):
            if text[j] == "{":
                depth += 1
            elif text[j] == "}":
                depth -= 1
                if depth == 0:
                    break
            j += 1
        out.append((m.group(1), m.start(), j))
    return out


def method_at(methods, pos):
    """오프셋이 속한 **가장 안쪽** 메서드명."""
    best, best_span = "(전역)", None
    for name, s, e in methods:
        if s <= pos <= e and (best_span is None or (e - s) < best_span):
            best, best_span = name, e - s
    return best


CODE_PATTERNS = [
    (re.compile(r'GetLookupValues\s*\(\s*"([^"]+)"'), "GetLookupValues"),
    (re.compile(r"Data\.Type\.(\w+)"), "Data.Common"),
    (re.compile(r"Data\.User(\w+)\s*\("), "Data.User*"),
]
HELPER_DEF_RE = re.compile(r'Parameters\s*\[\s*"CODE"\s*\]\s*=\s*"([^"]+)"')


def scan_asis(cs_path: pathlib.Path):
    """{CODE: {'sites': [(메서드, 라인)], 'helpers': [헬퍼명], 'commented': n}}"""
    raw = cs_path.read_text(encoding="utf-8", errors="ignore")
    live = strip_comments(raw)
    methods = parse_methods(live)
    lineno = lambda p: live.count("\n", 0, p) + 1  # noqa: E731

    codes = {}

    def add(code, pos, kind):
        e = codes.setdefault(code, {"sites": [], "helpers": [], "commented": 0, "kinds": set()})
        e["sites"].append((method_at(methods, pos), lineno(pos)))
        e["kinds"].add(kind)

    for rex, kind in CODE_PATTERNS:
        for m in rex.finditer(live):
            add(m.group(1), m.start(), kind)

    # ④ 명명 헬퍼 — 정의 안의 CODE 리터럴을 헬퍼 **호출부**로 치환
    for m in HELPER_DEF_RE.finditer(live):
        holder = method_at(methods, m.start())
        if holder == "(전역)":
            continue
        code = m.group(1)
        if not re.fullmatch(r"[A-Za-z_][\w]*", code):
            continue  # 파라미터 변수(p_code 등) = 범용 디스패처 → ①이 처리
        span = next(((s, e) for n, s, e in methods if n == holder), None)
        e = codes.setdefault(code, {"sites": [], "helpers": [], "commented": 0, "kinds": set()})
        e["helpers"].append(holder)
        e["kinds"].add("헬퍼")
        for cm in re.finditer(r"\b%s\s*\(" % re.escape(holder), live):
            if span and span[0] <= cm.start() <= span[1]:
                continue  # 자기 정의 내부
            e["sites"].append((method_at(methods, cm.start()), lineno(cm.start())))

    # ⑤ 주석 처리된 호출 건수 (사문 = 미이관이 파리티, 은폐 방지용 보고)
    dead = strip_comments(raw)
    for code, e in codes.items():
        pat = re.compile(r'(?:"%s"|Data\.Type\.%s\b)' % (re.escape(code), re.escape(code)))
        e["commented"] = len(pat.findall(raw)) - len(pat.findall(dead))
        e["sites"] = sorted(set(e["sites"]), key=lambda t: t[1])
        e["kinds"] = sorted(e["kinds"])
    return codes


# ── TO-BE 추출 ────────────────────────────────────────────────────────────────
# ⚠️ 일반 `const x = 값` 을 함수로 오인하면 enclosing 이 지역변수가 되어 트리거 추출이 통째로 죽는다
#   (2026-08-08 실측: enclosing 이 div/site/inco/item 으로 잡혀 Insert 프라이밍 미인식 → 오탐 FAIL).
#   → **화살표 함수 / function 선언만** 함수로 인정한다.
FN_RE = re.compile(
    r"^\s*(?:const\s+(\w+)\s*=\s*(?:async\s*)?\([^)]*\)\s*(?::[^=\n]+)?=>"
    r"|function\s+(\w+)\s*\()",
    re.M,
)


PASTE_METHOD_RE = re.compile(r"paste|clipboard", re.I)


def tobe_shares_paste(page_dir: pathlib.Path) -> bool:
    """TO-BE 가 pastedCell/pastingCell 에 **편집 핸들러를 그대로 등록**하면 Paste 는 별도 트리거가 아니다."""
    for f in list(page_dir.rglob("*.tsx")) + list(page_dir.rglob("*.ts")):
        if re.search(r"paste(d|ing)Cell\.addHandler", f.read_text(encoding="utf-8", errors="ignore")):
            return True
    return False


def scan_tobe(page_dir: pathlib.Path):
    """{comboId: {'sites': [(파일, 함수, 라인)], 'prefetch': n, 'triggers': [binding]}}"""
    out = {}
    for f in sorted(list(page_dir.rglob("*.ts")) + list(page_dir.rglob("*.tsx"))):
        text = f.read_text(encoding="utf-8", errors="ignore")
        rel = f.relative_to(page_dir).as_posix()
        fns = [((m.group(1) or m.group(2)), m.start()) for m in FN_RE.finditer(text)]
        enclosing = lambda p: next(  # noqa: E731
            (n for n, s in reversed(fns) if s < p), "(모듈)"
        )
        # JSX prop 형식: <SalesSiteField comboId={cond ? 'A' : 'B'} /> — 카탈로그 필드 바인딩(프리페치성)
        for jm in re.finditer(r"comboId\s*=\s*\{([^}]{0,300})\}", text):
            for lit in re.findall(r"'([A-Za-z_][\w]*)'", jm.group(1)):
                out.setdefault(lit, {"sites": [], "prefetch": 0, "triggers": set()})["prefetch"] += 1
        for m in re.finditer(r"comboId\s*:\s*'([^']+)'", text):
            cid = m.group(1)
            head = text[: m.start()]
            # 직전 400자에 getCombo( 가 있으면 명시 호출, 아니면 프리페치/설정
            # 탐지 창 — 좁으면 그 자체가 조용한 누락이다. getCombo 호출과 comboId 사이 거리는
            # 옵션 체이닝·주석으로 길어질 수 있어 넉넉히 잡는다(2026-08-08 상한 감사).
            is_call = "getCombo" in head[-2000:]
            e = out.setdefault(cid, {"sites": [], "prefetch": 0, "triggers": set()})
            if is_call:
                fn = enclosing(m.start())
                e["sites"].append((rel, fn, text.count("\n", 0, m.start()) + 1))
                # 트리거 = 그 함수를 부르는 곳 주변의 binding === 'X'
                for cm in re.finditer(r"\b%s\s*\(" % re.escape(fn), text):
                    ctx = text[max(0, cm.start() - 500) : cm.start()]
                    for bm in re.finditer(r"binding\s*===\s*'([A-Z_0-9]+)'", ctx):
                        e["triggers"].add(bm.group(1))
                    if re.search(r"CRUD_TYPE'?\]?\s*===?\s*'I'", ctx) or "primed" in ctx:
                        e["triggers"].add("(신규행 프라이밍)")
            else:
                e["prefetch"] += 1
    for e in out.values():
        e["triggers"] = sorted(e["triggers"])
    return out


def norm(s: str) -> str:
    return re.sub(r"[^a-z0-9]", "", s.lower())


def resolve_cs(menu: str):
    hits = [p for p in LEGACY.rglob("%s_*.cs" % menu) if not p.name.endswith(".Designer.cs")]
    return hits[0] if hits else None


def fe_pages():
    out = {}
    for f in FE_ROOT.rglob("*.constants.ts"):
        m = re.search(r"export\s+const\s+MENU_ID\s*=\s*'([^']+)'", f.read_text(encoding="utf-8", errors="ignore"))
        if m:
            out.setdefault(m.group(1), f.parent)
    return dict(sorted(out.items()))


def analyze(menu, page_dir, meta_combos, combo_tokens):
    cs = resolve_cs(menu)
    if not cs:
        return None, "AS-IS .cs 미발견 (%s_*.cs)" % menu, False
    asis = scan_asis(cs)
    tobe = scan_tobe(page_dir)
    tobe_norm = {norm(k): k for k in tobe}
    meta_norm = {norm(k): k for k in meta_combos}

    shares_paste = tobe_shares_paste(page_dir)
    rows = []
    for code, e in sorted(asis.items()):
        # ⚠️ AS-IS 는 같은 이벤트 핸들러 안에서 여러 번 부르기도 한다(ComboSelChange 2회 등).
        #   트리거 등가 비교의 단위는 **호출 횟수가 아니라 구별된 이벤트 핸들러 수**다.
        methods = {m for m, _ in e["sites"]}
        if shares_paste:
            methods = {m for m in methods if not PASTE_METHOD_RE.search(m)}
        n_a = len(methods)
        n_sites = len(e["sites"])
        if n_a == 0 and not e["helpers"]:
            continue
        alias = CODE_ALIAS.get(code, code)
        key = tobe_norm.get(norm(code)) or tobe_norm.get(norm(alias))
        meta_key = meta_norm.get(norm(code)) or meta_norm.get(norm(alias))
        note = DISPOSITION.get(menu, {}).get(code)
        t = tobe.get(key, {"sites": [], "prefetch": 0, "triggers": []})
        # ⚠️ AS-IS 는 같은 헬퍼를 이벤트마다 재호출하므로 '호출부 수'가 곧 트리거 수지만,
        #   TO-BE 는 헬퍼 1개를 여러 트리거가 부른다 → **트리거 수**로 비교해야 등가다
        #   (정의 수로 비교하면 정상 구현도 항상 '부족'으로 보인다 — 2026-08-08 실측 오탐).
        n_t = len(t["triggers"]) or len(t["sites"])
        insert_asis = any(INSERT_METHOD_RE.search(mth) for mth in methods)
        insert_tobe = "(신규행 프라이밍)" in t["triggers"]
        # ⭐ 행 종속 토큰(@divisionId/@itemId/@scmSiteId/@endCustomer …)을 가진 콤보는
        #   메타 자동 바인딩(렌더 1회)이 **행 생성 시점 재조회를 대체하지 못한다**.
        #   반대로 파라미터 없는 콤보는 메타 바인딩으로 충분하다(AS-IS 가 InsertRow 에서 부르는 것은
        #   셀 콤보를 붙이기 위함일 뿐) — 이 구분이 없으면 오탐이 쏟아진다.
        row_tokens = combo_tokens.get(key or meta_key or "", set())

        if n_a == 0 and n_sites == 0:
            continue
        if note:
            v, why = "✅ PASS", "이식 안 함(사유 기재): " + note
        elif n_a >= 2 and n_t == 0 and t["prefetch"] == 0 and not meta_key:
            v, why = "⛔ FAIL", "AS-IS %d지점인데 TO-BE 배선 자체가 없음" % n_a
        elif insert_asis and not insert_tobe and row_tokens:
            v, why = "⛔ FAIL", (
                "AS-IS 에 **행 생성 지점**(%s)이 있고 콤보가 행 종속 토큰(%s)을 갖는데 "
                "TO-BE 신규행 프라이밍 없음 — 메타 자동 바인딩은 렌더 1회라 대체 불가"
                % (", ".join(sorted({m for m in methods if INSERT_METHOD_RE.search(m)})),
                   ", ".join(sorted(row_tokens)))
            )
        elif n_a > max(n_t, 1) and (n_t > 0 or t["prefetch"] > 0):
            v, why = "⚠ WARN", "AS-IS 이벤트 %d종 > TO-BE 트리거 %d — 부족 의심" % (n_a, n_t)
        elif n_t == 0 and t["prefetch"] == 0 and not meta_key:
            v, why = "⚠ WARN", "TO-BE 대응 콤보 미식별 (명명 상이 or 미이관)"
        else:
            v, why = "✅ PASS", ""
        rows.append(
            {
                "code": code, "tobe": key or meta_key or "-", "n_a": n_a, "n_t": n_t, "n_sites": n_sites,
                "prefetch": t["prefetch"], "meta": bool(meta_key), "verdict": v, "why": why,
                "methods": sorted({m for m, _ in e["sites"]}), "triggers": t["triggers"],
                "commented": e["commented"], "kinds": e["kinds"],
            }
        )
    return rows, str(cs.relative_to(ROOT)), shares_paste


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--menu")
    ap.add_argument("--page")
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--out")
    a = ap.parse_args()

    import oracledb

    u, p, d = conn_info()
    targets = {}
    if a.all:
        targets = fe_pages()
    elif a.menu:
        targets = {a.menu: pathlib.Path(a.page) if a.page else fe_pages().get(a.menu)}
    if not targets or any(v is None for v in targets.values()):
        sys.exit("[error] --menu <ID> [--page <폴더>] 또는 --all 필요")

    meta, combo_tokens = {}, {}
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        for menu in targets:
            cur.execute(
                """SELECT DISTINCT CELL_COMBO_DATA_TYPE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID = :m AND TRIM(CELL_COMBO_DATA_TYPE) IS NOT NULL
                      AND NVL(VALID_YN,'Y') = 'Y'""",
                {"m": menu},
            )
            meta[menu] = {r[0] for r in cur.fetchall()}
        # 콤보별 행 종속 토큰 (서버 자동 주입 제외) — 메타 바인딩 대체 가능 여부 판정용
        cur.execute("SELECT SQL_ID, SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M")
        for sid, ctn in cur.fetchall():
            s = ctn.read() if hasattr(ctn, "read") else str(ctn)
            toks = set(re.findall(r"@(\w+)", s)) - {"sesUserId", "sesLangCd", "mnuId", "langCd", "userId"}
            combo_tokens[sid] = toks

    ts = datetime.datetime.now()
    L = [
        "# AS-IS ↔ TO-BE 콤보 **호출 지점 수(N:N)** 대사",
        "",
        f"> 실행 {ts:%Y-%m-%d %H:%M} · `_artifacts/_diagnostics/combo_callsite_parity.py` · **읽기 전용**",
        "> 룰 = hook #117 §5.12. SQL·파라미터가 맞아도 **부르는 시점이 빠지면 조용히 죽는다.**",
        "> 섹션 7·E2E D2축이 못 보는 축 — 이 대사표가 유일한 방어선이다.",
        "",
        "판정: **FAIL** = 배선 자체 부재(AS-IS ≥2 지점) 또는 **행 생성(InsertRow) 지점 누락** /",
        "**WARN** = AS-IS 지점 수 > TO-BE(트리거 부족 의심) 또는 대응 콤보 미식별 / **PASS** = 그 외",
        "",
    ]
    tot = {"⛔ FAIL": 0, "⚠ WARN": 0, "✅ PASS": 0}
    detail = []
    for menu, page_dir in targets.items():
        rows, src, shares_paste = analyze(menu, page_dir, meta.get(menu, set()), combo_tokens)
        if rows is None:
            detail += ["## %s — SKIP" % menu, "", src, ""]
            continue
        for r in rows:
            tot[r["verdict"]] += 1
        bad = [r for r in rows if r["verdict"] != "✅ PASS"]
        detail += [
            "## %s (%s)" % (menu, "FAIL %d / WARN %d / PASS %d" % (
                sum(1 for r in rows if "FAIL" in r["verdict"]),
                sum(1 for r in rows if "WARN" in r["verdict"]),
                sum(1 for r in rows if "PASS" in r["verdict"]))),
            "",
            "> AS-IS 원천: `%s`" % src,
            "",
            "> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). "
            + ("TO-BE 가 pastedCell 에 편집 핸들러를 공유하므로 **Paste 는 AS-IS 집계에서 제외**했다."
               if shares_paste else "TO-BE 는 Paste 핸들러 공유가 없다 — Paste 지점도 집계에 포함."),
            "",
            "| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |",
            "|---|---|---:|---:|---:|---:|:-:|---|---|",
        ]
        for r in rows:
            detail.append("| %s | %s | %d | %d | %d | %d | %s | %s | %s |" % (
                r["code"], r["tobe"], r["n_a"], r["n_sites"], r["n_t"], r["prefetch"],
                "O" if r["meta"] else "-", r["verdict"], r["why"]))
        if bad:
            detail += ["", "### 상세 (FAIL/WARN)", ""]
            for r in bad:
                detail.append("- **%s** → `%s` · AS-IS 호출 메서드: %s%s" % (
                    r["code"], r["tobe"], ", ".join(r["methods"]) or "-",
                    " · 주석처리 %d건(사문=미이관 파리티)" % r["commented"] if r["commented"] else ""))
                detail.append("  - TO-BE 트리거: %s" % (", ".join(r["triggers"]) or "없음"))
        detail.append("")
    L += ["## 종합 — FAIL **%d** / WARN **%d** / PASS **%d** (화면 %d개)" % (
        tot["⛔ FAIL"], tot["⚠ WARN"], tot["✅ PASS"], len(targets)), ""] + detail
    L += [
        "## 한계 (은폐 없음)",
        "- AS-IS 명명 헬퍼는 **1단계**만 해소한다(헬퍼 안의 헬퍼는 미추적).",
        "- TO-BE 트리거 추출은 `binding === 'X'` 정적 매칭 — 동적 분기(맵/스위치)는 누락될 수 있다.",
        "- 이름이 다른 대응 콤보는 정규화(영숫자 소문자) 매칭이 실패하면 '미식별 WARN' 으로 노출한다(조용한 통과 없음).",
        "- 주석 처리된 AS-IS 호출은 **제외하되 건수를 표에 기록**한다 — 사문 = 미이관이 파리티.",
        "",
    ]
    out = pathlib.Path(a.out) if a.out else (
        REPORT_DIR / ("COMBO_CALLSITE_PARITY_%s_%s.md" % (
            ("ALL" if a.all else a.menu), ts.strftime("%Y%m%d_%H%M"))))
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("\n".join(L) + "\n", encoding="utf-8")
    print("FAIL %d / WARN %d / PASS %d" % (tot["⛔ FAIL"], tot["⚠ WARN"], tot["✅ PASS"]))
    print("리포트:", out)
    sys.exit(1 if tot["⛔ FAIL"] else 0)


if __name__ == "__main__":
    main()
