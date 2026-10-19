#!/usr/bin/env python3
# TobeFacts 독립 교차검증 — 자체 렉서로 주석/문자열을 걷어낸 뒤 sink 호출 건수를 세어 endpoints.csv(살아있는 코드) 와 파일 단위로 비교한다.
# 사용: python crosscheck.py --fe <feRoot> --out <outDir> --config tobefacts.json   → 불일치 0 이어야 통과(exit 0)
import sys, os, re, csv, json, collections
args = sys.argv[1:]
def opt(k, d=None):
    return args[args.index(k) + 1] if k in args else d
fe = opt('--fe'); out = opt('--out'); cfgp = opt('--config', os.path.join(os.path.dirname(__file__), '..', 'tobefacts.json'))
cfg = json.load(open(cfgp, encoding='utf-8-sig'))
# fe.js 와 같은 규칙: callProc 류·hooks 는 끝 이름(tail) 일치, http 는 점 포함 전체 이름 일치
tails = set(s.split('.')[-1] for s in cfg['sinks']['callProc'] + cfg['sinks']['hooks'])
fulls = set(cfg['sinks']['http']) | set(cfg['sinks']['callProc'])
alts = sorted(map(re.escape, tails | set(s.split('.')[-1] for s in fulls)), key=len, reverse=True)
pat = re.compile(r'(?<![\w.$])((?:[\w$]+\s*\.\s*)*(?:' + '|'.join(alts) + r'))\s*(?=[<(])')
def call_follows(code, pos):
    """pos 가 이름 끝. 제네릭 <...> 를 건너뛴 뒤 '(' 가 오면 호출."""
    j = pos
    while j < len(code) and code[j] in ' \t\r\n': j += 1
    if j < len(code) and code[j] == '<':
        depth = 0
        while j < len(code):
            if code[j] == '<': depth += 1
            elif code[j] == '>': depth -= 1
            elif j - pos > 600: return False
            j += 1
            if depth == 0: break
        while j < len(code) and code[j] in ' \t\r\n': j += 1
    return j < len(code) and code[j] == '('
def is_sink(callee):
    return callee in fulls or callee.split('.')[-1] in tails
SKIP = {'node_modules', 'dist', '.turbo', 'coverage', '__mocks__'}

def strip(src):
    """주석·문자열·템플릿 리터럴을 공백으로. JSX 텍스트의 // 는 'http://' 처럼 ':' 뒤면 주석으로 보지 않는다."""
    o = []; i = 0; n = len(src); comments = []
    while i < n:
        c = src[i]; nx = src[i + 1] if i + 1 < n else ''
        if c == '/' and nx == '/' and not (i > 0 and src[i - 1] == ':'):
            j = src.find('\n', i); j = n if j < 0 else j; comments.append(src[i + 2:j]); o.append(' ' * (j - i)); i = j; continue
        if c == '/' and nx == '*':
            j = src.find('*/', i + 2); j = n - 2 if j < 0 else j; comments.append(src[i + 2:j]); o.append(re.sub(r'[^\n]', ' ', src[i:j + 2])); i = j + 2; continue
        if c in '"\'':
            j = i + 1
            while j < n and src[j] != c and src[j] != '\n':
                if src[j] == '\\': j += 1
                j += 1
            o.append(c + ' ' * (j - i - 1) + c); i = j + 1; continue
        if c == '`':
            j = i + 1; depth = 0
            while j < n:
                if src[j] == '\\': j += 2; continue
                if depth == 0 and src[j] == '`': break
                if src[j] == '$' and j + 1 < n and src[j + 1] == '{': depth += 1; j += 2; continue
                if depth and src[j] == '}': depth -= 1
                j += 1
            o.append(re.sub(r'[^\n]', ' ', src[i:j + 1])); i = j + 1; continue
        o.append(c); i += 1
    return ''.join(o), comments

def rel(p): return os.path.relpath(p, fe).replace(os.sep, '/')
mine = collections.Counter(); mine_c = collections.Counter(); theirs_c = collections.Counter()
for root, dirs, files in os.walk(fe):
    dirs[:] = [d for d in dirs if d not in SKIP]
    for f in files:
        if not re.search(r'\.tsx?$', f) or f.endswith('.d.ts'): continue
        p = os.path.join(root, f)
        txt = open(p, encoding='utf-8-sig', errors='replace').read()
        code, comments = strip(txt)
        for c in comments:
            c2 = c.replace('\n', ' ')
            if any(is_sink(re.sub(r'\s+', '', m.group(1))) and call_follows(c2, m.end(1)) for m in pat.finditer(c2)):
                mine_c[rel(p)] += 1
        for m in pat.finditer(code):
            # 선언/정의 제외: 'function name(' 'name = (' 는 pat 에 안 걸림. 'async name<T>(' 도 안 걸림.
            if not is_sink(re.sub(r'\s+', '', m.group(1))) or not call_follows(code, m.end(1)): continue
            pre = code[max(0, m.start() - 10):m.start()]
            if re.search(r'(function|async)\s+$', pre): continue
            mine[rel(p)] += 1
theirs = collections.Counter()
with open(os.path.join(out, 'endpoints.csv'), encoding='utf-8-sig', newline='') as fh:
    for r in csv.DictReader(fh):
        if r['kind'] == 'propagated': continue
        if r['commented'] == '0': theirs[r['file']] += 1
        else: theirs_c[r['file']] += 1
bad = []
for f in sorted(set(mine) | set(theirs)):
    if mine[f] != theirs[f]: bad.append((f, 'live', mine[f], theirs[f]))
for f in sorted(set(mine_c) | set(theirs_c)):
    if mine_c[f] != theirs_c[f]: bad.append((f, 'commented', mine_c[f], theirs_c[f]))
rep = os.path.join(out, 'crosscheck_report.csv')
with open(rep, 'w', encoding='utf-8-sig', newline='') as fh:
    w = csv.writer(fh); w.writerow(['file', 'metric', 'python', 'parser'])
    for b in bad: w.writerow(b)
print(f'files python={len(mine)} parser={len(theirs)} live calls python={sum(mine.values())} parser={sum(theirs.values())} commented python={sum(mine_c.values())} parser={sum(theirs_c.values())} mismatches={len(bad)}')
for b in bad[:15]: print('  ', *b)
print('RESULT', 'PASS' if not bad else 'FAIL')
sys.exit(0 if not bad else 1)
