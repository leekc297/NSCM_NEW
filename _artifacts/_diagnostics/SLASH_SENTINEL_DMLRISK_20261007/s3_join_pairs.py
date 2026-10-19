"""[파일 분석] '-'→'/' 일괄 변환(DML) 위험 점검 3 — TO-BE 원문에서 컬럼=컬럼 등치(조인·상관) 쌍 추출

원문 = _all_src.json.gz (s3a_fetch_all_source.py — 사내 zioui1 전 프로그램·뷰 699 객체 직접 조회본).
방식(정적·근사):
  ① 주석 제거(문자열 보존) → 문장(;) 단위 분할
  ② 문장 안 FROM/JOIN/UPDATE/MERGE INTO/USING/DELETE FROM 뒤의 "테이블 [별칭]" 수집 (실테이블·뷰·GTT 구분은 컬럼 사전으로)
  ③ [NVL(]a.C1[,'x')] = [NVL(]b.C2[,'x')] 형태 등치 수집 → 별칭을 테이블로 해석
한계: 문장 단위 별칭 해석(서브쿼리 안팎 같은 별칭 재사용 시 마지막 정의 우선) · 무별칭 컬럼 · USING(col) · IN (서브쿼리) · 동적 SQL 문자열 안의 조인은 문자열 그대로 스캔(별칭 해석 동일 규칙).
결과 = _join_pairs.json
"""
import sys, json, re, pathlib, collections
sys.path.insert(0, r"C:\Projects\NSCM\Doc\_analysis\asis_delta_20261002\_raw")
from common import code_mask_lines

HERE = pathlib.Path(__file__).resolve().parent
C = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_diagnostics\SLASH_SENTINEL_TARGET_20261006\_cache")
import gzip
src = json.load(gzip.open(HERE / "_all_src.json.gz", "rt", encoding="utf-8"))
cat = json.load(open(C / "tobe_cat.json", encoding="utf-8"))
tables = {}
for k, v in cat["tables"].items():
    own, t = k.split("|", 1)
    tables.setdefault(t.upper(), []).append((own, v.get("kind"), set(c.upper() for c in v.get("cols", {}))))
for k, v in (cat.get("views") or {}).items() if isinstance(cat.get("views"), dict) else []:
    own, t = k.split("|", 1)
    tables.setdefault(t.upper(), []).append((own, "view", set(c.upper() for c in (v.get("cols", {}) if isinstance(v, dict) else []))))

KW = {"WHERE", "ON", "SET", "INNER", "LEFT", "RIGHT", "FULL", "CROSS", "JOIN", "GROUP", "ORDER", "CONNECT", "START", "UNION", "MINUS", "INTERSECT", "USING",
      "WHEN", "VALUES", "SELECT", "HAVING", "PIVOT", "UNPIVOT", "PARTITION", "FOR", "AS", "AND", "OR", "NATURAL", "OUTER", "FETCH", "OFFSET", "RETURNING", "LOOP", "T", "MODEL", "SAMPLE", "WITH", "LOG", "INTO", "BULK", "IS", "THEN", "END", "BEGIN"}
REF = re.compile(r"""(?ix)\b(?:FROM|JOIN|UPDATE|INTO|USING|,)\s+ (?:(?:"?(\w+)"?)\s*\.\s*)? "?([A-Z_][\w$#]*)"? (?:\s*@\w+)? (?:\s+(?:AS\s+)?"?([A-Z_][\w$#]*)"?)?""")
SIDE = r"""(?:NVL\s*\(\s*)?(?:TRIM\s*\(\s*|RTRIM\s*\(\s*|UPPER\s*\(\s*)?"?([A-Z_][\w$#]*)"?\s*\.\s*"?([A-Z_][\w$#]*)"?(?:\s*\))?(?:\s*\(\+\))?(?:\s*,\s*'([^']*)'\s*\))?(?:\s*\(\+\))?"""
EQ = re.compile(r"(?ix)" + SIDE + r"\s*=\s*" + SIDE)

out = []; half = []; stat = collections.Counter()
for key, lines in src["objs"].items():
    own, typ, name = key.split("|", 2)
    text = "".join(lines) if isinstance(lines, list) else str(lines)
    if "=" not in text: continue
    mask = code_mask_lines(text.replace("\r\n", "\n"))
    # 문장 분할: 줄 번호 보존
    stmts, cur, start = [], [], 1
    for i, l in enumerate(mask, 1):
        cur.append(l)
        if ";" in l:
            stmts.append((start, cur)); cur = []; start = i + 1
    if cur: stmts.append((start, cur))
    for st, ls in stmts:
        body = "\n".join(ls)
        if "=" not in body: continue
        alias = {}
        for m in REF.finditer(body):
            o, t, a = m.group(1), m.group(2).upper(), (m.group(3) or "").upper()
            if t not in tables: continue
            if a in KW or not a: a = t
            alias[a] = t; alias.setdefault(t, t)
        if not alias: continue
        for m in EQ.finditer(body):
            a1, c1, d1, a2, c2, d2 = (x.upper() if x else x for x in m.groups())
            t1, t2 = alias.get(a1), alias.get(a2)
            if not t1 or not t2:
                stat["unresolved"] += 1
                if t1 or t2:
                    ln = st + body.count("\n", 0, m.start())
                    half.append(dict(owner=own, type=typ, obj=name, line=ln, t1=t1, a1=a1, c1=c1, t2=t2, a2=a2, c2=c2, text=re.sub(r"\s+", " ", m.group(0))[:160]))
                continue
            if c1 not in set().union(*[x[2] for x in tables[t1]]) or c2 not in set().union(*[x[2] for x in tables[t2]]): stat["col_not_in_table"] += 1; continue
            ln = st + body.count("\n", 0, m.start())
            out.append(dict(owner=own, type=typ, obj=name, line=ln, stmt_line=st, t1=t1, c1=c1, nvl1=d1, t2=t2, c2=c2, nvl2=d2,
                            text=re.sub(r"\s+", " ", m.group(0))[:160], k1=tables[t1][0][1], k2=tables[t2][0][1]))
            stat["pairs"] += 1
(HERE / "_join_pairs.json").write_text(json.dumps(out, ensure_ascii=False), encoding="utf-8")
(HERE / "_join_half.json").write_text(json.dumps(half, ensure_ascii=False), encoding="utf-8")
print("한쪽만 해석", len(half))
print("객체", len(src["objs"]), dict(stat))
print("테이블 종류:", collections.Counter((o["k1"], o["k2"]) for o in out).most_common(8))

