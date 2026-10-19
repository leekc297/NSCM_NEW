# -*- coding: utf-8 -*-
"""
AsisFacts 독립 교차검증기 (Roslyn 과 무관한 별도 구현)

C# : 자체 렉서로 주석·문자열·#if 비활성 영역을 판정한 뒤 패턴 건수를 센다.
XML: ElementTree(주석 노드 포함)로 FoxQuery 엔드포인트 건수를 센다.
결과를 AsisFacts 출력(sites.csv, foxquery_endpoints.csv)과 파일 단위로 대조해 1건이라도 다르면 exit 1.

사용: python crosscheck.py --root <asisRoot> --out <AsisFacts outDir> [--config asisfacts.json]
"""
import argparse, csv, json, os, re, sys, collections
import xml.etree.ElementTree as ET

def read_text(path):
    b = open(path, 'rb').read()
    if b.startswith(b'\xef\xbb\xbf'): return b[3:].decode('utf-8')
    if b.startswith(b'\xff\xfe'): return b[2:].decode('utf-16-le')
    try: return b.decode('utf-8')
    except UnicodeDecodeError: return b.decode('cp949')

# ───────────── C# 렉서 ─────────────
def eval_pp(expr, symbols):
    """#if 식 평가: 식별자, !, &&, ||, (), true/false"""
    toks = re.findall(r'\|\||&&|!|\(|\)|[A-Za-z_]\w*', expr)
    pos = 0
    def peek(): return toks[pos] if pos < len(toks) else None
    def take():
        nonlocal pos; t = toks[pos]; pos += 1; return t
    def prim():
        t = take()
        if t == '!': return not prim()
        if t == '(':
            v = orx(); take(); return v
        if t == 'true': return True
        if t == 'false': return False
        return t in symbols
    def andx():
        v = prim()
        while peek() == '&&': take(); v = prim() and v
        return v
    def orx():
        v = andx()
        while peek() == '||': take(); v = andx() or v
        return v
    return orx() if toks else False

TOK = re.compile(r"""
  (?P<lc>//[^\n]*)
| (?P<bc>/\*.*?\*/)
| (?P<vs>(?:\$@|@\$|@)"(?:[^"]|"")*")
| (?P<ist>\$"(?:\{\{|\}\}|\{(?:[^{}"]|"(?:\\.|[^"\\])*")*\}|\\.|[^"\\\n{}])*")
| (?P<s>"(?:\\.|[^"\\\n])*")
| (?P<ch>'(?:\\.[^'\n]*|[^'\\\n])')
""", re.S | re.X)
PP = re.compile(r'^[ \t]*#[ \t]*(\w+)(.*)$')

def lex(text, symbols):
    """반환: code(활성 코드: 주석/문자열 내용은 공백, 문자열 시작은 'S'), comments, inactive, strings"""
    lines = text.split('\n')
    stack = []; active = True; inactive = []; out_lines = []
    symbols = set(symbols)
    for ln, L in enumerate(lines, 1):
        m = PP.match(L)
        if m and m.group(1) in ('if', 'elif', 'else', 'endif', 'define', 'undef', 'region', 'endregion', 'pragma', 'warning', 'error', 'line', 'nullable'):
            kw = m.group(1); rest = re.split(r'//', m.group(2))[0].strip()
            if kw == 'if':
                parent = active; cond = eval_pp(rest, symbols); stack.append([parent, parent and cond, cond]); active = parent and cond
            elif kw == 'elif':
                top = stack[-1]; cond = (not top[2]) and eval_pp(rest, symbols); top[1] = top[0] and cond; top[2] = top[2] or cond; active = top[1]
            elif kw == 'else':
                top = stack[-1]; cond = not top[2]; top[1] = top[0] and cond; top[2] = True; active = top[1]
            elif kw == 'endif':
                active = stack.pop()[0]
            elif kw == 'define' and active: symbols.add(rest)
            elif kw == 'undef' and active: symbols.discard(rest)
            out_lines.append(' ' * len(L)); continue
        if not active:
            inactive.append((ln, L)); out_lines.append(' ' * len(L)); continue
        out_lines.append(L)
    src = '\n'.join(out_lines)
    comments = []; strings = []; parts = []; last = 0
    for m in TOK.finditer(src):
        parts.append(src[last:m.start()])
        seg = m.group(0); kind = m.lastgroup
        line = src.count('\n', 0, m.start()) + 1 if kind in ('lc', 'bc') else 0
        if kind == 'lc': comments.append((line, seg[2:]))
        elif kind == 'bc': comments.append((line, seg[2:-2]))
        elif kind in ('vs', 'ist', 's'): strings.append(seg)
        blank = re.sub(r'[^\n]', ' ', seg)
        if kind in ('vs', 'ist', 's'): blank = 'S' + blank[1:]
        parts.append(blank); last = m.end()
    parts.append(src[last:])
    return ''.join(parts), comments, inactive, strings

PATS = {
    'ctor:FoxDataRequest': re.compile(r'\bnew\s+(?:[\w\.]+\.)?FoxDataRequest\s*\(\s*[^\s\)]'),
    'ctor:FoxBizRequest': re.compile(r'\bnew\s+(?:[\w\.]+\.)?FoxBizRequest\s*\(\s*[^\s\)]'),
    'prop:QueryID': re.compile(r'\.\s*QueryID\s*=(?!=)'),
}

def count(text, pats):
    return {k: len(p.findall(text)) for k, p in pats.items()}

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--root', required=True); ap.add_argument('--out', required=True)
    ap.add_argument('--config', default=os.path.join(os.path.dirname(__file__), '..', 'asisfacts.json'))
    a = ap.parse_args()
    cfg = json.load(open(a.config, encoding='utf-8-sig'))
    symbols = set(cfg.get('preprocessorSymbols', ['TRACE']))
    excl = {d.lower() for d in cfg.get('excludeDirs', [])}

    # Roslyn 결과 집계
    ros = collections.defaultdict(collections.Counter)
    with open(os.path.join(a.out, 'sites.csv'), encoding='utf-8-sig') as f:
        for r in csv.DictReader(f):
            if r['site_kind'] in ('ctor', 'prop'):
                state = 'commented' if r['commented'] == '1' else ('inactive' if r['active'] == '0' else 'active')
                ros[r['file']][f"{r['site_kind']}:{r['target']}:{state}"] += 1
    ros_files = {}
    with open(os.path.join(a.out, 'files.csv'), encoding='utf-8-sig') as f:
        for r in csv.DictReader(f): ros_files[r['file']] = r

    mism = []; totals = collections.Counter(); nfiles = 0
    for dp, dns, fns in os.walk(a.root):
        dns[:] = sorted(d for d in dns if d.lower() not in excl)
        for fn in sorted(fns):
            if not fn.lower().endswith('.cs'): continue
            full = os.path.join(dp, fn); rel = os.path.relpath(full, a.root).replace('/', '\\')
            nfiles += 1
            text = read_text(full)
            code, comments, inactive, strings = lex(text, symbols)
            py = collections.Counter()
            for k, v in count(code, PATS).items(): py[k + ':active'] += v
            # 주석: 연속 // 줄을 하나로 묶지 않아도 건수는 동일 (패턴이 한 줄 안에 있을 때)
            ctext = '\n'.join(t for _, t in comments)
            for k, v in count(ctext, PATS).items(): py[k + ':commented'] += v
            itext = '\n'.join(t for _, t in inactive)
            for k, v in count(itext, PATS).items(): py[k + ':inactive'] += v
            r = ros.get(rel, collections.Counter())
            keys = set(k for k in py if py[k]) | set(r)
            for k in sorted(keys):
                totals['py:' + k] += py[k]; totals['ros:' + k] += r[k]
                if py[k] != r[k]: mism.append((rel, k, py[k], r[k]))
            if rel not in ros_files: mism.append((rel, 'FILE_NOT_IN_ROSLYN', 1, 0))

    # FoxQuery
    fox_py = collections.Counter(); fox_ros = collections.Counter()
    froot = os.path.join(a.root, cfg.get('foxQueryRoot', '04.WSL\\FoxQuery').replace('\\', os.sep))
    elems = {'procedure', 'statement', 'sql', 'update-batch', 'insert-sql', 'update-sql', 'delete-sql', 'select', 'insert', 'update', 'delete'}
    for dp, dns, fns in os.walk(froot):
        for fn in fns:
            if not (fn.lower().endswith('.xml') or fn.lower().endswith('.foxml')): continue
            full = os.path.join(dp, fn); rel = os.path.relpath(full, a.root).replace('/', '\\')
            parser = ET.XMLParser(target=ET.TreeBuilder(insert_comments=True))
            root = ET.fromstring(read_text(full).encode('utf-8'), parser=parser)
            parent_of = {c: p for p in root.iter() for c in p}
            for el in root.iter():
                if not isinstance(el.tag, str): continue
                tag = el.tag.split('}')[-1]
                if tag not in elems: continue
                par = parent_of.get(el)
                if 'id' in el.attrib or (par is not None and isinstance(par.tag, str) and par.tag.split('}')[-1] == 'update-batch'):
                    fox_py[rel] += 1
    with open(os.path.join(a.out, 'foxquery_endpoints.csv'), encoding='utf-8-sig') as f:
        for r in csv.DictReader(f):
            if r['commented'] == '0': fox_ros[r['file']] += 1
    for k in sorted(set(fox_py) | set(fox_ros)):
        totals['py:foxquery'] += fox_py[k]; totals['ros:foxquery'] += fox_ros[k]
        if fox_py[k] != fox_ros[k]: mism.append((k, 'foxquery_endpoints', fox_py[k], fox_ros[k]))

    rep = os.path.join(a.out, 'crosscheck_report.csv')
    with open(rep, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f, quoting=csv.QUOTE_ALL); w.writerow(['file', 'metric', 'python', 'roslyn'])
        for m in mism: w.writerow(m)
    print(f'files scanned: {nfiles}')
    for k in sorted(set(x.split(":", 1)[1] for x in totals)):
        print(f'  {k:45s} python={totals["py:"+k]:7d} roslyn={totals["ros:"+k]:7d}' + ('' if totals["py:"+k] == totals["ros:"+k] else '  <-- DIFF'))
    print(f'mismatches: {len(mism)}  → {rep}')
    sys.exit(0 if not mism else 1)

if __name__ == '__main__':
    main()
