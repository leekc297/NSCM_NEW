"""DMF0044 Version Copy 저장 — GROUP BY 불일치(ORA-00979) 보완 [E20261014-DMF0044VCGRP] (사내 ZIOUI1)

배경(2026-10-14): 조회 오류([E20261014-DMF0044GRPUPPER]) 뒤 패키지 전체 정적 SQL 을 파싱 점검한 결과
  P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY 의 4문장이 같은 계열(ORA-00979)이었다. 사용자 지시 "진행".

원인: SELECT 는 NVL(NULLIF(RTRIM(X),''), '/') 인데 GROUP BY 는 NVL(X, '/') — X 자체는 GROUP BY 에 없어 ORA-00979.
  X = A.CURRENCY (SP 복사 · 실적 기반 복사) · B.SALES_COMPANY · A.ITEM_USE · A.END_CUSTOMER (BP 복사) · A.COMPANY_ID (리포트 원장 적재)
  컬럼 이름을 정해 두지 않고, SELECT 목록에 그 꼴로 나오는 컬럼을 모두 대상으로 한다.

보완 규칙 (GROUP BY 절만 고친다 — SELECT · WHERE · 그 밖의 문장 무변경)
  GROUP BY 절마다 짝이 되는 SELECT 목록을 찾아,
    SELECT 목록에 NVL(NULLIF(RTRIM(X),''), '/') 가 있고 GROUP BY 에 NVL(X, '/') 가 있을 때
      - SELECT 목록이 NVL(X, '/') 도 따로 쓰면  → GROUP BY 에 SELECT 의 식을 덧붙인다 (둘 다 필요)
      - 아니면                                  → GROUP BY 의 식을 SELECT 의 식으로 바꾼다
  결과 행의 값은 SELECT 가 정하므로 달라지지 않는다. 묶음 기준이 결과 컬럼과 같은 식이 된다.

  python build_apply.py build   # ALL_SOURCE 재조회 → 00_BACKUP / 01_BODY 생성 + 치환 목록(_changes.json)
  python build_apply.py apply   # FRESH-GATE 통과 시 BODY 적용 + 컴파일 확인
"""
import sys, os, re, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0044"
TYP = "PACKAGE BODY"
STATE = os.path.join(HERE, "_fresh_state.json")
CHANGES = os.path.join(HERE, "_changes.json")
MARK = "[E20261014-DMF0044VCGRP]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0044_BODY.sql", "01_PKG_DMF0044_BODY.sql"
P_START = "\nPROCEDURE P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY"


def raw(x):
    return f"NVL({x}, '/')"


def sel(x):
    return f"NVL(NULLIF(RTRIM({x}),''), '/')"


def mask(src):
    """주석 · 문자열 내용을 같은 길이의 공백/x 로 가린 사본 (위치가 원문과 1:1)."""
    out, i, n = [], 0, len(src)
    while i < n:
        if src[i] == "'":
            j = i + 1
            while j < n and not (src[j] == "'" and src[j + 1:j + 2] != "'"):
                j += 2 if src[j] == "'" else 1
            out.append("'" + "x" * (j - i - 1) + "'"); i = j + 1
        elif src.startswith("--", i):
            j = src.find("\n", i)
            j = n if j < 0 else j
            out.append(" " * (j - i)); i = j
        elif src.startswith("/*", i):
            j = src.find("*/", i + 2)
            j = n if j < 0 else j + 2
            out.append("".join(c if c == "\n" else " " for c in src[i:j])); i = j
        else:
            out.append(src[i]); i += 1
    m = "".join(out)
    assert len(m) == len(src)
    return m


def plan(region):
    """region(프로시저 본문) 안의 치환 목록 [(GROUP BY 절 안 위치, old, new, 방식)] 을 만든다."""
    m = mask(region)
    mc = "".join(o if (k != " " or o == " ") else " " for o, k in zip(region, m))   # 주석 자리만 공백, 문자열은 원문 그대로
    toks, depth = [], 0
    for t in re.finditer(r"[();]|\b(SELECT|FROM|GROUP\s+BY|UNION|HAVING|ORDER\s+BY)\b", m, re.I):
        w = t.group(0).upper()
        if w == "(":
            depth += 1
        elif w == ")":
            depth -= 1
            toks.append((t.start(), "CLOSE", depth + 1))
        elif w == ";":
            depth = 0
            toks.append((t.start(), "END", 0))
        else:
            toks.append((t.start(), re.sub(r"\s+", " ", w), depth))
    res = []
    for i, (pos, kind, d) in enumerate(toks):
        if kind != "GROUP BY":
            continue
        # GROUP BY 절의 끝 = 같은 깊이의 다음 절 · 이 깊이를 닫는 괄호 · 문장 끝
        end = next(p for p, k, dd in toks[i + 1:] if (dd == d and k in ("UNION", "HAVING", "ORDER BY", "CLOSE", "END", "SELECT")) or k == "END")
        # 짝 SELECT = 같은 깊이에서 거슬러 올라가 처음 만나는 SELECT, 그 목록 = 그 뒤 같은 깊이의 첫 FROM 까지
        j = i - 1
        while not (toks[j][1] == "SELECT" and toks[j][2] == d):
            j -= 1
        s_pos = toks[j][0]
        f_pos = next(p for p, k, dd in toks[j + 1:] if k == "FROM" and dd == d)
        s_list, g_txt = mc[s_pos:f_pos], mc[pos:end]   # 주석만 가린 원문 (문자열은 그대로 — 식 비교용)
        for x in sorted(set(re.findall(r"NVL\(NULLIF\(RTRIM\((\w+\.\w+)\),''\), '/'\)", s_list))):   # SELECT 목록에 이 꼴로 나오는 모든 컬럼
            if sel(x) in s_list and raw(x) in g_txt:
                if g_txt.count(raw(x)) != 1:
                    sys.exit(f"ABORT: GROUP BY 절 안에 {raw(x)} 가 1회가 아님 (위치 {pos})")
                both = raw(x) in s_list.replace(sel(x), "")   # SELECT 목록이 NVL(X,'/') 도 따로 쓰는가
                new = raw(x) + ", " + sel(x) if both else sel(x)
                res.append((pos + g_txt.index(raw(x)), raw(x), new, "덧붙임" if both else "바꿈"))
    return res


def connect():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def read_source(cur):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects "
                "WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=PKG, t=TYP)
    ddl = cur.fetchone()[0]
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=PKG, t=TYP)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}


def transform(body):
    if MARK in body:
        sys.exit(f"ABORT: BODY 에 {MARK} 이미 존재 — 재적용 불필요")
    if "\r" in body:
        sys.exit("ABORT: BODY 원문에 CR 포함")
    if body.count(P_START) != 1:
        sys.exit(f"ABORT: 프로시저 시작 {body.count(P_START)}회")
    a = body.index(P_START)
    nxt = re.search(r"\nPROCEDURE |\nFUNCTION |\nEND PKG_DMF0044", body[a + 10:])
    b = a + 10 + nxt.start()
    reg = body[a:b]
    ch = plan(reg)
    if not ch:
        sys.exit("ABORT: 치환 대상 0건")
    lines = []
    for pos, old, new, how in sorted(ch, reverse=True):   # 뒤에서부터 — 앞쪽 위치가 밀리지 않게
        assert reg[pos:pos + len(old)] == old
        reg = reg[:pos] + new + reg[pos + len(old):]
        lines.append({"line": body.count("\n", 0, a + pos) + 1, "old": old, "new": new, "how": how})
    # 마커 = 프로시저 첫 치환 줄 끝이 아니라 프로시저 머리(IS/AS 앞 주석 불가) 대신, 첫 치환 줄 바로 위에 주석 1줄
    first = min(p for p, *_ in ch)
    ls = reg.rfind("\n", 0, first) + 1
    note = (f"        --{MARK} 이 프로시저의 GROUP BY 절 {len(ch)}곳을 SELECT 와 같은 식으로 맞춤 — "
            "NVL(X,'/') 와 NVL(NULLIF(RTRIM(X),''),'/') 가 달라 ORA-00979 (실행 시점 오류)\n")
    reg = reg[:ls] + note + reg[ls:]
    for l in lines:
        l["line_after"] = l["line"] + 1
    return body[:a] + reg + body[b:], sorted(lines, key=lambda r: r["line"])


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def build():
    with connect() as con:
        cur = con.cursor()
        s = read_source(cur)   # 기준본 = 지금 ALL_SOURCE 에서 새로 조회한 원문
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI'), SYS_CONTEXT('USERENV','SERVER_HOST') FROM dual")
        fetched, host = cur.fetchone()
    new, lines = transform(s["src"])
    stamp = f"-- SOURCE-FRESH: SCM_MGR.{PKG} {TYP} LAST_DDL={s['last_ddl']} FETCHED={fetched} DB=ZIOUI1\n"
    open(os.path.join(HERE, F_BAK), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(s["src"]) + "/\n")
    open(os.path.join(HERE, F_NEW), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(new) + "/\n")
    json.dump({"last_ddl": s["last_ddl"], "md5": s["md5"], "fetched": fetched, "host": host}, open(STATE, "w"), indent=1)
    json.dump(lines, open(CHANGES, "w", encoding="utf-8"), indent=1, ensure_ascii=False)
    print("BUILD OK", fetched, "HOST", host, "LAST_DDL", s["last_ddl"], "lines", s["src"].count("\n"), "->", new.count("\n"), "marker", new.count(MARK))
    for l in lines:
        print("  L%d | %s | %s → %s" % (l["line"], l["how"], l["old"], l["new"]))
    print("치환", len(lines), "곳")


def strip(txt):
    lines = [l for l in txt.split("\n") if not l.startswith("-- SOURCE-FRESH:")]
    t = "\n".join(lines).rstrip()
    return t[:-1].rstrip() if t.endswith("/") else t


def apply():
    st = json.load(open(STATE))
    with connect() as con:
        cur = con.cursor()
        cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM dual")
        host = cur.fetchone()[0]
        if host != st["host"]:
            sys.exit(f"ABORT: 접속 DB 가 build 시점과 다름 (build {st['host']} → now {host})")
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == build 시점 기준본 (다르면 중단·재빌드)
        now = read_source(cur)
        if now["md5"] != st["md5"] or now["last_ddl"] != st["last_ddl"]:
            sys.exit(f"FRESH-GATE FAIL: build {st['last_ddl']} {st['md5']} → now {now['last_ddl']} {now['md5']}")
        print("FRESH-GATE PASS", "HOST", host)
        cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
        inv_before = cur.fetchone()[0]
        tobe = strip(open(os.path.join(HERE, F_NEW), encoding="utf-8").read())
        cur.execute(tobe)
        after = read_source(cur)
        print("APPLIED", F_NEW, "DB==TOBE", after["src"].rstrip() == tobe[len("CREATE OR REPLACE "):].rstrip(),
              "marker", after["src"].count(MARK))
        cur.execute("SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name=:n ORDER BY 1", n=PKG)
        for r in cur:
            print("  ", r)
        cur.execute("SELECT type, line, position, text FROM user_errors WHERE name=:n ORDER BY sequence", n=PKG)
        errs = cur.fetchall()
        print("USER_ERRORS", len(errs))
        for e in errs:
            print("  ", e)
        cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
        print("SCM_MGR INVALID objects", inv_before, "->", cur.fetchone()[0])


if __name__ == "__main__":
    {"build": build, "apply": apply}[sys.argv[1]]()
