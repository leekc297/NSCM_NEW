"""패키지 BODY 의 정적 SQL 을 전부 뽑아 "파싱만" 해 보는 점검 (실행하지 않는다 — DBMS_SQL.PARSE, 읽기 전용)

  python check_static_sql.py PKG_DMF0044                 # 사내 DB 의 현재 원문
  python check_static_sql.py PKG_DMF0044 some_body.sql   # 파일 원문 (예: 보완 전 백업본 — 점검 도구가 오류를 잡는지 확인용)

왜: ORA-00979(GROUP BY 불일치) 같은 오류는 패키지 컴파일(VALID)로는 드러나지 않고 그 문장이 실행될 때만 난다.
    문장을 파싱만 하면 데이터 · 분기와 무관하게 같은 오류를 미리 볼 수 있다.

방법
  1. 주석을 걷어내고(문자열 안은 보존) ';' 로 문장을 나눈다.
  2. 문장마다 INSERT / UPDATE / DELETE / MERGE / SELECT / WITH 로 시작하는 SQL 부분만 남긴다
     (커서 FOR 루프 · OPEN FOR · CURSOR IS 안의 SELECT 포함, SELECT … INTO 변수 절은 뺀다).
  3. DBMS_SQL.PARSE 로 파싱한다. ORA-00904(모르는 이름) = PL/SQL 변수 · 파라미터 · 루프 레코드이므로 바인드로 바꿔 다시 파싱한다.
  4. 끝까지 남는 오류를 보고한다.

한계 (보고에 그대로 적는다)
  - 문자열로 조립해 실행하는 동적 SQL(EXECUTE IMMEDIATE · OPEN … FOR 변수)은 대상이 아니다 → 개수와 줄 번호만 따로 낸다.
  - 변수를 바인드로 바꾸는 과정에서 자료형을 알 수 없어 생기는 오류(ORA-00932 등)는 "수동 확인" 으로 분류한다.
"""
import sys, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

START = re.compile(r"\b(INSERT\s+(/\*.*?\*/\s*)?INTO|MERGE\s+(/\*.*?\*/\s*)?INTO|UPDATE\s|DELETE\s|SELECT\s|WITH\s+\w+\s+AS\s*\()", re.I | re.S)


def strip_comments(src):
    """주석을 공백으로 바꾼다(줄 수 유지). 문자열은 그대로 둔다."""
    out, i, n = [], 0, len(src)
    while i < n:
        c = src[i]
        if c == "'":
            j = i + 1
            while j < n:
                if src[j] == "'":
                    if j + 1 < n and src[j + 1] == "'":
                        j += 2
                        continue
                    break
                j += 1
            out.append(src[i:j + 1]); i = j + 1
        elif src.startswith("--", i):
            j = src.find("\n", i)
            j = n if j < 0 else j
            i = j
        elif src.startswith("/*", i):
            j = src.find("*/", i + 2)
            j = n if j < 0 else j + 2
            out.append("".join(ch if ch == "\n" else " " for ch in src[i:j])); i = j
        else:
            out.append(c); i += 1
    return "".join(out)


def mask_strings(s):
    """문자열 리터럴 내용을 같은 길이의 'x' 로 가린 사본 (위치 계산용)."""
    return re.sub(r"'(?:[^']|'')*'", lambda m: "'" + "x" * (len(m.group(0)) - 2) + "'", s)


def split_statements(code):
    m = mask_strings(code)
    res, start = [], 0
    for i, ch in enumerate(m):
        if ch == ";":
            res.append((start, code[start:i])); start = i + 1
    return res


def top_level_find(masked, word, frm=0):
    """괄호 깊이 0 에서 단어 word 의 위치 (없으면 -1)."""
    depth = 0
    for mm in re.finditer(r"[()]|\b" + word + r"\b", masked[frm:], re.I):
        t = mm.group(0)
        if t == "(":
            depth += 1
        elif t == ")":
            depth -= 1
        elif depth == 0:
            return frm + mm.start()
    return -1


def extract_sql(stmt):
    """PL/SQL 문장 조각에서 SQL 본문만 남긴다. (SQL, 문장 안 시작 오프셋) 또는 None."""
    m = mask_strings(stmt)
    hit = START.search(m)
    if not hit:
        return None
    s = hit.start()
    before = m[:s].rstrip()
    if before.endswith("("):                        # FOR r IN ( SELECT … ) LOOP / 괄호로 감싼 커서
        depth, j = 1, s
        while j < len(m) and depth:
            depth += (m[j] == "(") - (m[j] == ")")
            j += 1
        sql = stmt[s:j - 1]
    else:
        sql = stmt[s:]
    mk = mask_strings(sql)
    if re.match(r"(SELECT|WITH)\b", mk, re.I):      # SELECT … INTO 변수 FROM … → INTO 절 제거
        p_into = top_level_find(mk, r"(BULK\s+COLLECT\s+)?INTO")
        p_from = top_level_find(mk, "FROM")
        if 0 <= p_into < p_from:
            sql = sql[:p_into] + sql[p_from:]
    mk = mask_strings(sql)
    p_ret = top_level_find(mk, r"RETURNING")        # DML … RETURNING … INTO 변수
    if p_ret > 0:
        sql = sql[:p_ret]
    return sql.replace("$$PLSQL_UNIT", "'PKG'"), s


def parse_only(cur, sql):
    """파싱만. 모르는 이름(ORA-00904)은 바인드로 바꿔 가며 반복. (결과코드, 메시지, 바인드로 바꾼 이름들)"""
    binds = []
    for _ in range(80):
        try:
            cur.execute("DECLARE c INTEGER := DBMS_SQL.OPEN_CURSOR; BEGIN "
                        "BEGIN DBMS_SQL.PARSE(c, :s, DBMS_SQL.NATIVE); EXCEPTION WHEN OTHERS THEN DBMS_SQL.CLOSE_CURSOR(c); RAISE; END; "
                        "DBMS_SQL.CLOSE_CURSOR(c); END;", s=sql)
            return "OK", "", binds
        except oracledb.DatabaseError as e:
            msg = str(e).split("\n")[0]
            m = re.match(r'ORA-00904: (?:"(\w+)"\.)?"([\w$#]+)"', msg)
            if not m:
                # 바인드는 나올 때마다 서로 다른 값으로 취급돼, 변수가 든 식이 SELECT · GROUP BY 양쪽에 있으면 거짓 ORA-00979 가 난다.
                # 그래서 바인드로 실패하면 같은 자리를 상수 '1' 로 바꿔 한 번 더 파싱한다 (상수는 양쪽이 같은 식으로 인정된다).
                if binds and ":B" in sql:
                    sql = re.sub(r":B\d+\b", "'1'", sql)
                    continue
                return msg[:9], msg, binds
            name = (m.group(1) + "." if m.group(1) else "") + m.group(2)
            pat = re.compile(r"(?<![\w.$:])" + re.escape(name).replace(r"\.", r"\s*\.\s*") + r"(?![\w$])", re.I)
            mk = mask_strings(sql)
            spans = [x.span() for x in pat.finditer(mk)]
            if not spans:
                return "ORA-00904", msg, binds
            for a, b in reversed(spans):
                sql = sql[:a] + ":B" + str(len(binds)) + sql[b:]
            binds.append(name)
    return "LOOP", "바인드 치환 반복 한도 초과", binds


def main():
    pkg = sys.argv[1]
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    if len(sys.argv) > 2:
        src = open(sys.argv[2], encoding="utf-8").read()
        src = "\n".join(l for l in src.split("\n") if not l.startswith("-- SOURCE-FRESH:"))
        src = re.sub(r"^CREATE OR REPLACE ", "", src)
        origin = "파일 " + sys.argv[2]
    else:
        cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type='PACKAGE BODY' ORDER BY line", n=pkg)
        src = "".join(r[0] for r in cur)
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n AND object_type='PACKAGE BODY'", n=pkg)
        origin = "사내 DB 현재 원문 LAST_DDL " + cur.fetchone()[0]
    cur.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR")
    print("대상", pkg, "|", origin, "|", src.count("\n"), "줄")
    code = strip_comments(src)
    procs = [(m.start(), m.group(2)) for m in re.finditer(r"^\s*(PROCEDURE|FUNCTION)\s+(\w+)", code, re.M)]

    def where(pos):
        line = code.count("\n", 0, pos) + 1
        name = next((nm for st, nm in reversed(procs) if st <= pos), "?")
        return line, name

    stats, findings, manual, n_group = {}, [], [], 0
    for off, stmt in split_statements(code):
        ex = extract_sql(stmt)
        if not ex:
            continue
        sql, s = ex
        if sql.lstrip()[:1] == "'" or not re.search(r"\b(FROM|INTO|SET)\b", mask_strings(sql), re.I):
            continue
        lead = len(sql) - len(sql.lstrip())
        line, proc = where(off + s + lead)
        has_group = bool(re.search(r"\bGROUP\s+BY\b", mask_strings(sql), re.I))
        n_group += has_group
        code_, msg, binds = parse_only(cur, sql)
        stats[code_] = stats.get(code_, 0) + 1
        if code_ == "OK":
            continue
        rec = (line, proc, "GROUP BY 있음" if has_group else "", msg[:150], re.sub(r"\s+", " ", sql)[:70])
        (findings if code_ in ("ORA-00979", "ORA-00937", "ORA-00934", "ORA-00918") else manual).append(rec)
    # 동적 SQL (문자열 안의 GROUP BY) — 점검 대상 밖, 위치만
    dyn = sorted({where(m.start()) for m in re.finditer(r"'(?:[^']|'')*'", code) if re.search(r"\bGROUP\s+BY\b", m.group(0), re.I)})
    print("정적 SQL 문장", sum(stats.values()), "개 (GROUP BY 포함", n_group, "개) | 결과", stats)
    print("--- 같은 계열 오류 (GROUP BY 불일치 · 집계 오류 · 컬럼 모호):", len(findings), "건")
    for r in findings:
        print("  L%d | %s | %s | %s | %s" % r)
    print("--- 수동 확인 대상 (파싱 실패 — 변수 치환 한계일 수 있음):", len(manual), "건")
    for r in manual:
        print("  L%d | %s | %s | %s | %s" % r)
    print("--- 점검 밖: 문자열로 조립하는 동적 SQL 중 GROUP BY 가 있는 곳:", len(dyn), "곳")
    for line, proc in dyn:
        print("  L%d | %s" % (line, proc))


if __name__ == "__main__":
    main()
