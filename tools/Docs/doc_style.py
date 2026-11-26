# -*- coding: utf-8 -*-
"""문서 문장 규칙 검사 — 사용자 상시 지시 2026-11-13
  ① 수식어 쓰지 않기  ② 문맥으로 아는 주어 빼기  ③ 번역투 빼기
  규칙 정본   tools/VibeManager/rules/50_DOC_STYLE.md
  검출 표현   tools/Docs/doc_style_rules.csv (kind · pattern · hint) — 표현을 더하거나 빼려면 이 CSV 만 고친다

사용
  python doc_style.py <파일…> [--out <폴더>] [--quiet]
      .xlsx          모든 시트의 문장 셀
      .md .txt       줄 단위
      .py .js .cs    한글이 든 문자열 리터럴(생성기에 박힌 고정 문장)
  생성기에서:  import doc_style; doc_style.after_save(xlsx_path)   # 저장 직후 1줄 요약 + 보고 CSV

검사하지 않는 것(오탐 방지)
  따옴표·백틱·「」 안 글자(AS-IS 원문 라벨·메시지 인용) · 한글 4자 미만 셀 · 경로·식별자만 있는 셀
  .js 는 걸린 표현을 문장, 표지, 이름 인용으로 나눠 문장만 위반으로 센다(classify_js). 보고 csv '분류' 칸, 요약 줄 '표지 n | 이름 인용 n'
종료 코드  0 = 위반 0 · 1 = 위반 있음(문서 생성 실패가 아님 — 생성기는 이 값을 종료 코드로 쓰지 않는다)
"""
import csv, io, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
RULES_CSV = os.path.join(HERE, 'doc_style_rules.csv')
OUT_DIR = os.path.join(ROOT, 'Doc', '_doc_style')
KINDS = ('수식어', '주어', '번역투', '기호', '틀', '접속', '소개·맺음', '추측', '추상어')

_rules = None


def rules():
    global _rules
    if _rules is None:
        rs = []  # 다 읽은 뒤에 넣는다 — 중간에 실패한 목록으로 검사하지 않게
        with open(RULES_CSV, encoding='utf-8-sig', newline='') as f:
            for r in csv.DictReader(f):
                if (r.get('kind') or '').strip() and (r.get('pattern') or '').strip():
                    rs.append((r['kind'].strip(), re.compile(r['pattern']), (r.get('hint') or '').strip()))
        _rules = rs
    return _rules


# 인용 구간 = AS-IS 원문·라벨·메시지 → 검사 제외. 같은 길이의 공백으로 바꿔 위치를 유지한다.
_QUOTED = re.compile(r"'[^'\n]{0,200}'|\"[^\"\n]{0,200}\"|‘[^’\n]{0,200}’|“[^”\n]{0,200}”|`[^`\n]{0,200}`|「[^」\n]{0,200}」|『[^』\n]{0,200}』")
_HANGUL = re.compile(r'[가-힣]')


def mask_quoted(s):
    return _QUOTED.sub(lambda m: ' ' * len(m.group(0)), s)


def is_sentence(s):
    return isinstance(s, str) and len(_HANGUL.findall(s)) >= 4


def check_text(s):
    """→ [(kind, 걸린 표현, 고치는 법)]"""
    if not is_sentence(s):
        return []
    t = mask_quoted(s)
    out = []
    for kind, rx, hint in rules():
        for m in rx.finditer(t):
            a, b = max(0, m.start() - 6), min(len(s), m.end() + 6)
            out.append((kind, s[a:b].replace('\n', ' ').strip(), hint))
    return out


def scan_xlsx(path):
    import openpyxl
    wb = openpyxl.load_workbook(path, read_only=True, data_only=True)
    cells = 0
    for ws in wb.worksheets:
        for row in ws.iter_rows():
            for c in row:
                v = c.value
                if not is_sentence(v):
                    continue
                cells += 1
                for k, hit, hint in check_text(v):
                    yield (ws.title, getattr(c, 'coordinate', ''), k, hit, hint, v)
    wb.close()
    scan_xlsx.cells = cells


def scan_lines(path):
    n = 0
    with open(path, encoding='utf-8-sig', errors='replace') as f:
        for i, line in enumerate(f, 1):
            if not is_sentence(line):
                continue
            n += 1
            for k, hit, hint in check_text(line.rstrip('\n')):
                yield ('', f'L{i}', k, hit, hint, line.strip())
    scan_lines.cells = n


_STR = re.compile(r"\"\"\"(.*?)\"\"\"|'''(.*?)'''|\"((?:[^\"\\\n]|\\.)*)\"|'((?:[^'\\\n]|\\.)*)'|`((?:[^`\\]|\\.)*)`", re.S)


# ── JS 소스 읽기 (2026-11-20 개선안 20261120001936_SELF_2) ──────────────────────────────
# _STR 정규식 1개로는 // 주석, /* */ 주석, 정규식 리터럴 안의 따옴표·백틱을 문자열 시작으로 짝짓는다.
# .js 는 앞에서부터 읽으며 주석과 정규식 리터럴을 건너뛰고 ' " ` 문자열만 뽑는다. 템플릿 ${…} 안은 코드로 다시 읽는다.
_JS_WORD = re.compile(r'[A-Za-z0-9_$]+')
_JS_KW = frozenset(('return', 'typeof', 'instanceof', 'in', 'of', 'new', 'delete', 'void', 'throw',
                    'case', 'do', 'else', 'yield', 'await'))
_JS_RX_PREV = set('(,=:[!&|?{};+-*%<>~^}')


def _blank(s):
    return re.sub(r'[^\n]', ' ', s)


def _js_regex_end(src, i):
    """src[i] == '/' 인 정규식 리터럴의 끝 위치. 같은 줄에서 닫히지 않으면 None(나눗셈으로 봄)."""
    n = len(src); j = i + 1; cls = False
    while j < n:
        c = src[j]
        if c == '\n':
            return None
        if c == '\\':
            j += 2; continue
        if cls:
            cls = c != ']'
        elif c == '[':
            cls = True
        elif c == '/':
            j += 1
            while j < n and (src[j].isalnum() or src[j] in '_$'):
                j += 1
            return j
        j += 1
    return None


def _js_template_text(t):
    """템플릿 글자 부분에서 /* */ 구간과 줄 머리가 // 인 줄을 뺀다(웹뷰·CSS 주석). 위치는 유지."""
    t = re.sub(r'/\*.*?\*/', lambda m: _blank(m.group(0)), t, flags=re.S)
    return '\n'.join(' ' * len(ln) if ln.lstrip().startswith('//') else ln for ln in t.split('\n'))


def _js_code(src, i, out, nested):
    """코드 구간을 읽으며 문자열을 out 에 (따옴표 종류, 시작 위치, 내용) 으로 넣는다. nested 면 짝 맞는 } 다음 위치를 돌려준다."""
    n = len(src); depth = 0; prev = ''
    while i < n:
        c = src[i]
        if c in ' \t\r\n':
            i += 1; continue
        nx = src[i + 1] if i + 1 < n else ''
        if c == '/' and nx == '/':
            k = src.find('\n', i); i = n if k < 0 else k; continue
        if c == '/' and nx == '*':
            k = src.find('*/', i + 2); i = n if k < 0 else k + 2; continue
        if c in '\'"':
            j = i + 1
            while j < n and src[j] != c and src[j] != '\n':
                j += 2 if src[j] == '\\' else 1
            out.append((c, i, src[i + 1:min(j, n)]))
            i = j + 1; prev = 'a'; continue
        if c == '`':
            i = _js_template(src, i, out); prev = 'a'; continue
        if c == '/' and (prev == '' or prev in _JS_KW or prev in _JS_RX_PREV):
            k = _js_regex_end(src, i)
            if k is not None:
                i = k; prev = 'a'; continue
        if c == '{':
            depth += 1
        elif c == '}':
            if nested and depth == 0:
                return i + 1
            depth -= 1
        m = _JS_WORD.match(src, i)
        if m:
            w = m.group(0); i = m.end(); prev = w if w in _JS_KW else 'a'; continue
        prev = c; i += 1
    return n


def _js_template(src, i, out):
    """src[i] == '`'. 글자 부분은 ${…} 를 공백으로 바꿔 1건으로 넣고, ${…} 안은 코드로 읽는다. → 닫는 ` 다음 위치"""
    n = len(src); j = i + 1; buf = []
    while j < n:
        c = src[j]
        if c == '\\':
            buf.append(src[j:j + 2]); j += 2; continue
        if c == '`':
            j += 1; break
        if c == '$' and j + 1 < n and src[j + 1] == '{':
            k = _js_code(src, j + 2, out, True)
            buf.append(_blank(src[j:k])); j = k; continue
        buf.append(c); j += 1
    out.append(('`', i, _js_template_text(''.join(buf))))
    return j


def _js_literals(src):
    out = []
    _js_code(src, 0, out, False)
    return sorted(out, key=lambda x: x[1])


def _source_literals(path, src):
    """→ [(시작 위치, 내용, 안쪽 '…' 인용을 가릴지)]"""
    if path.lower().endswith('.js'):
        return [(st, s, q != "'") for q, st, s in _js_literals(src)]
    res = []
    for m in _STR.finditer(src):
        ls = src.rfind('\n', 0, m.start()) + 1
        head = src[ls:m.start()].lstrip()
        if head.startswith('#') or head.startswith('//') or head.startswith('*'):
            continue
        s = next((g for g in m.groups() if g is not None), '')
        res.append((m.start(), s, bool(m.group(1) or m.group(2) or m.group(3) or m.group(5))))
    return res


# ── 확인된 오탐 제외 (2026-11-21 개선안 20261120225006_SELF_2) ──────────────────────────────
# (파일 이름, 걸린 표현 일부, 사유). 같은 파일에서 걸린 표현에 일부가 들어 있으면 위반 수에서 빼고 보고 csv 에 '제외'로 남긴다.
# 제외를 더할 때는 소스에서 사유를 확인하고 파일:줄을 사유에 적는다. 위반을 PASS 로 바꾸려고 넣지 않는다.
# 2026-11-23 개선안 20261123000643_VISION: history.js '💬 프롬프트'(줄 머리 표지), orchestra.js 정규식(웹뷰 <script> 코드)은 JS 분류(classify_js)가 표지로 나눠 목록에서 뺌
KNOWN_OK = (
    ('extension.js', '🔎 Check', '메뉴 이름 🔎 CheckList 실행 인용(extension.js:470)'),
    ('jobs.js', 'abled>▶', 'HTML 단추 기호(jobs.js:107)'),
    ('orch-ledger.js', '함 → 변경 후', '변경 전후 표기 화살표(orch-ledger.js:133)'),
    ('orch-usercheck.js', '없음 → 추가', '변경 전후 표기 화살표(orch-usercheck.js:605)'),
    ('orch-vision.js', '근거로 판단한다', '단정 어미, 추측 아님(orch-vision.js:66)'),
    ('orch-undo.js', '곳에 있어 위치를', "'~에 있어서' 번역투 아님(orch-undo.js:48)"),
)
_FAIL_HEAD = ('✖', '✘')
_FAIL_HEAD_WHY = '제외(FAIL_RE 실패 표시, workbench.js:661)'


def _known_ok(path, hit):
    name = os.path.basename(path)
    for f, part, why in KNOWN_OK:
        if f == name and part in hit:
            return why
    return None


def _excluded(row):
    return row[2] in NOT_SENTENCE


# ── JS 고정 문구 분류 (2026-11-23 개선안 20261123000643_VISION 단계 1) ──────────────────────────
# 문장 규칙 대상은 사람이 읽는 문장만이다. .js 리터럴에서 걸린 표현을 셋으로 나눈다.
#   문장      = 알림, 화면 설명, 보고, AI 지시문. 위반 수에 넣는다.
#   표지      = 코드와 사람이 상태를 알아보는 줄 머리 기호(JS_MARKERS), 웹뷰 템플릿 안 코드(<script> 안 문자열 밖, <style>, <!-- -->).
#   이름 인용 = quick.json, steps.json 에 있는 메뉴 이름을 그대로 적은 곳(사용자 원문 인용).
# 표지, 이름 인용은 보고 csv 에 분류만 남기고 위반 수에서 뺀다. 줄 머리가 아닌 기호와 줄표, 가운뎃점은 문장으로 센다.
JS_MARKERS = ('▶', '✅', '⛔', '⚠', '✖', '✘', '❌', '✔', '🔎', '💬')   # 줄 머리 상태 표지. 더할 때는 쓰는 코드 파일:줄을 주석에 적는다
_NOTIFY_HEAD = 'Vibe_Manager'                                             # 알림 머리 'Vibe_Manager ✅ …'(workbench.js 알림)
NOT_SENTENCE = ('제외', '표지', '이름 인용')
_menu_names = None


def menu_names():
    """quick.json, steps.json 의 메뉴 이름(label, label_en, name). 괄호 설명은 떼고 기호로 시작하는 이름만."""
    global _menu_names
    if _menu_names is not None:
        return _menu_names
    import json
    names = set()
    vm = os.path.join(ROOT, 'tools', 'VibeManager')

    def walk(o):
        if isinstance(o, dict):
            for k, v in o.items():
                if k in ('label', 'label_en', 'name') and isinstance(v, str):
                    n = re.split(r'\s+\(', v.strip(), 1)[0].strip()
                    if len(n) >= 3 and not re.match(r'[A-Za-z0-9가-힣]', n):
                        names.add(n)
                else:
                    walk(v)
        elif isinstance(o, list):
            for v in o:
                walk(v)
    for f in ('quick.json', 'steps.json'):
        try:
            with open(os.path.join(vm, f), encoding='utf-8-sig') as fh:
                walk(json.load(fh))
        except (OSError, ValueError):
            pass
    _menu_names = sorted(names, key=len, reverse=True)
    return _menu_names


def _code_mask(s):
    """웹뷰 템플릿 글자 s 에서 화면에 문장으로 보이지 않는 코드 구간 → bytearray(1 = 코드)."""
    mask = bytearray(len(s))
    if '<' not in s:
        return mask
    for m in re.finditer(r'<!--.*?-->', s, re.S):
        mask[m.start():m.end()] = b'\x01' * (m.end() - m.start())
    for m in re.finditer(r'<style[^>]*>(.*?)</style>', s, re.S):
        mask[m.start(1):m.end(1)] = b'\x01' * (m.end(1) - m.start(1))
    for m in re.finditer(r'<script[^>]*>(.*?)(?:</script>|$)', s, re.S):
        a, b = m.start(1), m.end(1)
        mask[a:b] = b'\x01' * (b - a)
        body = s[a:b]
        for q, st, txt in _js_literals(body):   # 스크립트 안 문자열은 문장으로 되돌린다(주석, 정규식, 식별자는 코드)
            if q == '`':
                continue
            e = min(b, a + st + len(txt) + 2)
            mask[a + st:e] = bytes(e - a - st)
    return mask


def classify_js(s, kind, pos, code):
    """.js 리터럴 s 의 pos 에서 걸린 kind 표현 → (분류, 사유). 분류 = '문장' | '표지' | '이름 인용'"""
    if code and pos < len(code) and code[pos]:
        return '표지', '웹뷰 템플릿 안 코드(<script> 안 문자열 밖, <style>, <!-- -->)'
    if kind != '기호':
        return '문장', ''
    for n in menu_names():
        i = s.find(n)
        while i >= 0:
            if i <= pos < i + len(n):
                return '이름 인용', f"메뉴 이름 '{n}'(quick.json, steps.json)"
            i = s.find(n, i + 1)
    if s[pos:pos + 1] in JS_MARKERS or s[pos:pos + 2] in JS_MARKERS:
        ls = s.rfind('\n', 0, pos) + 1
        head = s[ls:pos].strip()
        if head == '' or head == _NOTIFY_HEAD:
            return '표지', '줄 머리 상태 표지(JS_MARKERS)'
    return '문장', ''


def scan_source(path):
    """생성기 소스의 문자열 리터럴 — 주석은 제외. 리터럴 안에서는 인용 구간을 가리지 않는다(리터럴 자체가 따옴표라서).
    KNOWN_OK 와 .js 리터럴 머리 ✖ ✘ 는 규칙 칸 '제외' 행으로 내보낸다(위반 수에서 뺌)."""
    src = open(path, encoding='utf-8-sig', errors='replace').read()
    is_js = path.lower().endswith('.js')
    n = 0
    for start, s, mask in _source_literals(path, src):
        if not is_sentence(s):
            continue
        n += 1
        line = src.count('\n', 0, start) + 1
        t = re.sub(r"'[^'\n]{0,80}'|‘[^’\n]{0,80}’|「[^」\n]{0,80}」", lambda q: ' ' * len(q.group(0)), s) if mask else s
        lead = len(s) - len(s.lstrip())
        head_fail = is_js and s.lstrip()[:1] in _FAIL_HEAD
        code = _code_mask(s) if is_js else None
        for kind, rx, hint in rules():
            for h in rx.finditer(t):
                a, b = max(0, h.start() - 6), min(len(s), h.end() + 6)
                hit = s[a:b].replace('\n', ' ').strip()
                at = f'L{line + s.count(chr(10), 0, h.start())}'   # 여러 줄 템플릿은 걸린 줄 번호
                why = _known_ok(path, hit)
                if why is None and head_fail and kind == '기호' and h.start() <= lead < h.end():
                    why = _FAIL_HEAD_WHY
                if why is not None:
                    yield ('', at, '제외', hit, f'{kind}: {why}', s.replace('\n', ' ')[:300])
                    continue
                if is_js:
                    cls, cwhy = classify_js(s, kind, h.start(), code)
                    if cls != '문장':
                        yield ('', at, cls, hit, f'{kind}: {cwhy}', s.replace('\n', ' ')[:300])
                        continue
                yield ('', at, kind, hit, hint, s.replace('\n', ' ')[:300])
    scan_source.cells = n


def scan(path):
    ext = os.path.splitext(path)[1].lower()
    fn = scan_xlsx if ext in ('.xlsx', '.xlsm') else scan_source if ext in ('.py', '.js', '.cs', '.ps1') else scan_lines
    allr = list(fn(path))
    rows = [r for r in allr if not _excluded(r)]
    scan.excluded = [r for r in allr if _excluded(r)]   # 위반 수에서 뺀 행 — 보고 csv 에만 남긴다
    return rows, getattr(fn, 'cells', 0)


scan.excluded = []


def report(path, rows, cells, out_dir=None, excluded=()):
    out_dir = out_dir or OUT_DIR
    os.makedirs(out_dir, exist_ok=True)
    out = os.path.join(out_dir, os.path.basename(path) + '.style.csv')
    tmp = out + '.tmp'
    with open(tmp, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f)
        w.writerow(['시트', '위치', '규칙', '걸린 표현', '고치는 법', '문장', '분류'])
        for r in list(rows) + list(excluded):
            w.writerow([r[0], r[1], r[2], r[3], r[4], r[5][:500], r[2] if r[2] in NOT_SENTENCE else '문장'])
    os.replace(tmp, out)
    return out


def summary(rows):
    c = {k: 0 for k in KINDS}
    for r in rows:
        c[r[2]] = c.get(r[2], 0) + 1
    return c


def after_save(path, quiet=False):
    """생성기 저장 직후 호출 — 실패해도 문서 생성에는 영향이 없다. → 위반 수(검사 실패 = -1)"""
    try:
        rows, cells = scan(path)
        if scan.excluded:
            report(path, rows, cells, excluded=scan.excluded)
        if not rows:
            if not quiet:
                print(f'[문장 규칙] 위반 0, 문장 {cells}개, {os.path.basename(path)}')
            return 0
        out = report(path, rows, cells, excluded=scan.excluded)
        c = summary(rows)
        if not quiet:
            print(f"[문장 규칙] 위반 {len(rows)}건({', '.join(f'{k} {v}' for k, v in c.items() if v)}), 문장 {cells}개, {os.path.basename(path)}, 보고 {os.path.relpath(out, ROOT)}")
        return len(rows)
    except Exception as e:  # 검사 실패는 숨기지 않는다
        print(f'[문장 규칙] ERROR 검사 못함 — {os.path.basename(str(path))}: {e}')
        return -1


# ── 저장 직전 정리 (2026-11-13 규칙 4·7) ──────────────────────────────────────────────
# 검사 엔진이 남긴 측정 기록은 ' — ' · ' · ' 를 구분자로 쓰고, 생성기가 그 구분자로 글을 자른다(make_verify_docs · plain_detail).
# 그래서 원문은 그대로 두고, Excel 에 쓰는 마지막 단계에서만 기호를 문장 부호로 바꾼다. 따옴표 안(AS-IS 원문 인용)은 건드리지 않는다.
_DECO = re.compile('[⭐✅⚠❌⛔☁🔎🛠🧯💬📌🔴🟡🟢✔✖★☆]️?[ \t]?')
_BOLD = re.compile(r'\*\*([^*\n]{1,80})\*\*')
_DASH = re.compile(r'[ \t]*[—–][ \t]*')
SKIP_HEADERS = ('사용자의견', '사용자판정')   # 사람이 적는 칸 — 고치지 않는다
CHECKLIST_GAEJO = ('설명', '쉬운 설명', '기대(AS-IS·규칙)')   # CheckList · ActionItemList · 테스트결과서 — 생성기·규칙 원장이 쓴 글
GAEJO_HEADERS = ('설명',)                      # 개조식(~함 · ~임 · ~없음)으로 끝내는 칸


def _hold(s):
    keep = []

    def put(m):
        keep.append(m.group(0)); return f'\x00{len(keep) - 1}\x00'
    return _QUOTED.sub(put, s), keep


def _back(s, keep):
    return re.sub('\x00(\\d+)\x00', lambda m: keep[int(m.group(1))], s)


def _dash_line(ln):
    out = []; pos = 0; n = 0
    for m in _DASH.finditer(ln):
        head = ln[:m.start()]; tail = ln[m.end():]
        if not head.strip() or not tail.strip():
            continue
        if re.search(r'\d$', head) and re.match(r'\d', tail) and m.group(0).strip() == m.group(0):
            rep = '-'                                   # 1–5 같은 범위
        elif n == 0 and ':' not in head and '：' not in head and len(head) <= 60 and not re.search(r'(다|음|함|임|됨|요)\.?$', head.rstrip()):
            rep = ': '                                  # '대상 — 내용' → '대상: 내용'
        else:
            rep = ', '
        out.append(ln[pos:m.start()] + rep); pos = m.end(); n += 1
    return ''.join(out) + ln[pos:]


def clean_text(s):
    """기호 정리 — 줄표 · 장식 기호 · 굵은 글씨 표시 · 가운뎃점 나열. 화살표(순서 · 변경 전후 표기)는 둔다."""
    if not is_sentence(s) or s.startswith('='):
        return s
    t, keep = _hold(s)
    t = _BOLD.sub(r'\1', t)
    t = _DECO.sub('', t)
    lines = []
    for ln in t.split('\n'):
        ln = re.sub(r'^([ \t]*)⇒[ \t]*', r'\1', ln)
        ln = re.sub(r'[ \t]*⇒[ \t]*', ', ', ln)
        ln = re.sub(r'^([ \t]*)[·•▸▶][ \t]+', r'\1- ', ln)
        ln = _dash_line(ln)
        ln = re.sub(r'[ \t]+·[ \t]+', ', ', ln)
        lines.append(ln)
    return _back('\n'.join(lines), keep)


_SEND = r'(?=\.?(?:$|\n|\)|\]|\s+/\s)|\.\s|[:;,(]|\s+[—–(])'   # 문장 끝: 마침표 · 줄 끝 · 닫는 괄호 · ' / ' · 쌍점 · 줄표·여는 괄호 앞


def _jong(ch, to):
    c = ord(ch) - 0xAC00
    return chr(0xAC00 + c - c % 28 + to)


def gaejo_core(t):
    """개조식 변환 본체(인용 가리기 없음). 합니다체 → 한다체 순서로 문장 끝만 바꾼다.
    없습니다→없음 · 합니다→함 · 입니다→임 · 않는다→않음 · 한다→함 · 된다→됨 · 있다→있음 · 했다→했음 · 이다→임 · 아니다→아님 · 다르다→다름"""
    t = re.sub(r'([가-힣])습니다' + _SEND, r'\1음', t)

    def bn(m):
        c = ord(m.group(1)) - 0xAC00
        return _jong(m.group(1), 16) if c % 28 == 17 else m.group(0)
    t = re.sub(r'([가-힣])니다' + _SEND, bn, t)
    t = re.sub(r'([가-힣])는다' + _SEND, lambda m: m.group(1) + '음' if (ord(m.group(1)) - 0xAC00) % 28 else m.group(0), t)

    def da(m):
        ch = m.group(1); j = (ord(ch) - 0xAC00) % 28
        if j in (0, 4):                 # 받침 없음(이다·아니다·다르다) · ㄴ(한다·된다) → ㅁ 받침
            return _jong(ch, 16)
        if j in (8, 17):                # ㄹ·ㅂ 받침(쉽다 → 쉬움 같은 불규칙) — 바꾸지 않는다
            return m.group(0)
        return ch + '음'                # 있다 · 없다 · 같다 · 했다
    return re.sub(r'([가-힣])다' + _SEND, da, t)


def to_gaejo(s):
    """문장 끝을 개조식으로. 따옴표 안(원문 인용)은 그대로."""
    if not isinstance(s, str) or '다' not in s:
        return s
    t, keep = _hold(s)
    return _back(gaejo_core(t), keep)


# 2026-11-18 사용자: 일반 사용자에게 낯선 내부 용어를 문서에 쓰지 않는다. 대조표(mapping_trace) = AS-IS 동작 ↔ TO-BE 구현 대조 → 'GAP'.
#   검사 엔진·원장 원문은 그대로 두고 Excel 에 쓰는 마지막 단계에서만 바꾼다(생성기가 원문 문구로 글을 자르고 분류함). 따옴표 안 인용은 그대로.
PLAIN_TERMS = (('대조표', 'GAP'),)


def plain_terms(s):
    if not isinstance(s, str) or not any(k in s for k, _ in PLAIN_TERMS) or s.startswith('='):
        return s
    t, keep = _hold(s)
    for k, v in PLAIN_TERMS:
        t = t.replace(k, v)
    return _back(t, keep)


def clean_workbook(wb, skip=SKIP_HEADERS, gaejo=GAEJO_HEADERS, free=False):
    """openpyxl Workbook 의 문장 셀을 정리한다 — 저장 직전에 부른다. → 바꾼 셀 수
    gaejo = 개조식으로 바꿀 칸 이름 · free=True 면 표 밖 안내문(머리글 위 · 머리글 없는 시트)도 개조식"""
    n = 0
    for ws in wb.worksheets:   # 용어 바꾸기는 한 단어 칸(영역 '대조표')까지 — 사람이 쓰는 칸은 제외
        hdr = {}; hrow = 0
        for row in ws.iter_rows(min_row=1, max_row=min(6, ws.max_row or 1)):
            names = {c.column: str(c.value).strip() for c in row if isinstance(c.value, str)}
            if any(any(k in v for k in skip) for v in names.values()):
                hdr = names; hrow = row[0].row; break
        for row in ws.iter_rows():
            for c in row:
                if not isinstance(c.value, str):
                    continue
                h = hdr.get(c.column, '') if hdr and c.row > hrow else ''
                if h and any(k in h for k in skip):
                    continue
                w = plain_terms(c.value)
                if w != c.value:
                    try:
                        c.value = w; n += 1
                    except AttributeError:
                        pass
    for ws in wb.worksheets:
        hdr = {}; hrow = 0
        for row in ws.iter_rows(min_row=1, max_row=min(6, ws.max_row or 1)):
            names = {c.column: str(c.value).strip() for c in row if isinstance(c.value, str)}
            if any(v in gaejo or any(k in v for k in skip) or v in ('검증 ID', '규칙', '대상', '결과') for v in names.values()):
                hdr = names; hrow = row[0].row; break
        for row in ws.iter_rows():
            for c in row:
                v = c.value
                if not isinstance(v, str) or not is_sentence(v):
                    continue
                h = hdr.get(c.column, '') if hdr and c.row > hrow else ''
                if h and any(k in h for k in skip):
                    continue
                w = clean_text(v)
                if h in gaejo or (free and not h and not (hdr and c.row > hrow)):
                    w = to_gaejo(w)
                if w != v:
                    try:
                        c.value = w; n += 1
                    except AttributeError:   # 병합 셀
                        pass
    return n


def before_save(wb, gaejo=GAEJO_HEADERS, free=False):
    """생성기 저장 직전 호출 — 실패해도 문서 생성은 계속한다."""
    try:
        n = clean_workbook(wb, gaejo=gaejo, free=free)
        print(f'[문장 규칙] 저장 전 정리 {n}셀')
        return n
    except Exception as e:
        print(f'[문장 규칙] ERROR 저장 전 정리 못함: {e}')
        return -1


PROMPT_RULE = """## 문장 규칙 (사용자 상시 지시 2026-11-13 · 모든 설명·문장에 적용 · 정본 tools/VibeManager/rules/50_DOC_STYLE.md)
1. 수식어를 쓰지 않는다 — 매우·다소·실제로·모두·반드시·정확히·다양한·중요한·적절히·원활하게·효과적으로 같은 꾸밈말 삭제. 정도는 수치·조건으로 적는다.
2. 문맥으로 아는 주어는 뺀다 — '이 화면은', '본 기능은', '사용자가', '시스템은' 으로 문장을 시작하지 않는다. 주체가 둘 이상이라 헷갈릴 때만 주어를 적는다.
3. 번역투를 쓰지 않는다 — '~에 대한/관한', '~에 의해', '~로 인해', '~를 통해', '~에 있어서', '~의 경우', '~를 수행한다', '~를 가지고 있다', '~하는 것이 가능하다', '~되어진다', '~것으로 보인다', '~에서의' 금지. '조회 조건 검증', 'SP 가 저장한다', '조회한다', '~이 있다', '~할 수 있다' 처럼 쓴다.
4. 줄표(—), 장식 기호(⇒ ⭐ ✅ ⚠), 굵은 글씨 표시를 문장 안에 쓰지 않는다. 나열은 가운뎃점 대신 쉼표로, 이어지는 내용은 문장을 나눠 쓴다. 화살표는 순서·변경 전후 표기('조회 → 저장', 'Center → Left')에만 쓰고 문장을 잇는 데 쓰지 않는다.
5. 괄호 부연은 한 문장에 1개까지. 괄호 안에 문장을 넣지 않는다.
6. 영문 병기는 문서에서 처음 1회만. 이후는 현업에서 부르는 이름 하나로 쓴다.
7. 설계서·CheckList·분석서의 셀은 개조식으로 끝낸다('~함', '~임', '~없음', '확인 필요'). '~합니다'는 안내문·보고 본문에만 쓴다. 한 문서에서 어미를 섞지 않는다.
8. 'A가 아니라 B', '단순한 ~가 아닌', '~뿐만 아니라 ~도' 틀을 쓰지 않는다. B만 쓴다.
9. 셋씩 묶어 나열하지 않는다. 있는 만큼만 적는다.
10. 항목마다 같은 틀을 반복하지 않는다. 내용이 한 줄이면 한 줄로 끝낸다.
11. 접속 부사(또한, 따라서, 한편, 아울러, 더불어, 즉, 특히)로 문장을 시작하지 않는다.
12. 문서를 소개하는 문장을 쓰지 않는다('이 문서는 ~를 설명한다', '아래 표는 ~를 보여준다', '다음과 같다').
13. 맺음말을 쓰지 않는다('결론적으로', '요약하면', '참고 바랍니다', 앞 내용을 다시 말하는 마지막 문장).
14. 추측 어미를 쓰지 않는다('~일 수 있다', '~할 수도 있다', '~로 판단된다', '~것 같다', '필요 시'). 확인했으면 단정하고 못 했으면 '미확인'이라고 쓴다.
15. 추상어(정합성, 고도화, 효율화, 제고, 측면, 관점, 맥락) 대신 대상과 값을 쓴다. 예: 'PLAN_QTY 컬럼 AS-IS 12건, TO-BE 10건'.
16. 당연한 내용을 풀어 쓰지 않는다(조회 버튼이 조회한다는 설명, 용어 뜻풀이, 같은 말 반복).
17. 화면ID, 컬럼명, SP명, 건수, 일자를 적는다. '일부 컬럼', '여러 건', '특정 조건'이라고 쓰지 않는다.
18. 다 쓴 뒤 담당자가 회의에서 말하는 문장인지 본다. 아니면 고친다.
AS-IS 원문(라벨·메시지·코드·SP 본문) 인용은 고치지 않고 따옴표 안에 그대로 둔다."""


_VM_JS = re.compile(r'(?:^|/)tools/VibeManager/([^/]+\.js)$', re.I)


def hook_main():
    """Claude Code PostToolUse(Write|Edit|MultiEdit) hook. tools/VibeManager/<파일>.js 를 고친 직후 문장 분류 위반 수를
    git HEAD 판과 비교해 늘었으면 새 위반 줄을 stderr 로 알리고 종료 코드 2(Claude 에 보임). 그 밖 파일, 검사 실패 = 0(막지 않음).
    2026-11-23 개선안 20261123000643_VISION 단계 2(쓰는 시점 검사). 끄기 = .claude/settings.json 에서 이 줄 삭제"""
    import json, subprocess, tempfile
    try:
        sys.stderr.reconfigure(encoding='utf-8', errors='replace')
    except Exception:
        pass
    try:
        data = json.loads(sys.stdin.buffer.read().decode('utf-8', 'replace') or '{}')
        fp = str(((data.get('tool_input') or {}).get('file_path')) or '').replace('\\', '/')
        m = _VM_JS.search(fp)
        if not m or not os.path.isfile(fp):
            return 0
        rows, _ = scan(fp)
        if not rows:
            return 0
        rel = f'tools/VibeManager/{m.group(1)}'
        base_n = 0
        r = subprocess.run(['git', 'show', f'HEAD:{rel}'], cwd=ROOT, capture_output=True, timeout=10)
        if r.returncode == 0:
            with tempfile.TemporaryDirectory() as td:
                bf = os.path.join(td, m.group(1))
                with open(bf, 'wb') as fh:
                    fh.write(r.stdout)
                base_n = len(scan(bf)[0])
        if len(rows) <= base_n:
            return 0
        lines = [f'[문장 규칙] {rel} 문장 위반 {base_n} → {len(rows)}건(HEAD 대비). 규칙 tools/VibeManager/rules/50_DOC_STYLE.md. '
                 f'줄 머리 상태 표지(JS_MARKERS)와 메뉴 이름 인용은 위반 아님']
        for x in rows[:15]:
            lines.append(f'  {x[1]} {x[2]}: …{x[3]}… ({x[4][:60]})')
        print('\n'.join(lines), file=sys.stderr)
        return 2
    except Exception as e:  # 검사 실패로 작업을 막지 않는다
        print(f'[문장 규칙] hook 검사 못함: {e}', file=sys.stderr)
        return 0


def main(argv):
    try:
        sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    except Exception:
        pass
    if '--hook' in argv:
        return hook_main()
    quiet = '--quiet' in argv
    out_dir = argv[argv.index('--out') + 1] if '--out' in argv else None
    files = [a for i, a in enumerate(argv) if not a.startswith('--') and (i == 0 or argv[i - 1] != '--out')]
    if not files:
        print(__doc__)
        return 2
    total = 0
    for p in files:
        if not os.path.isfile(p):
            print(f'ERROR 파일 없음: {p}')
            total += 1
            continue
        try:
            rows, cells = scan(p)
        except Exception as e:
            print(f'ERROR 검사 못함: {p} — {e}')
            total += 1
            continue
        c = summary(rows)
        ex = scan.excluded
        out = report(p, rows, cells, out_dir, ex) if rows or ex else ''
        nx = {k: sum(1 for r in ex if r[2] == k) for k in NOT_SENTENCE}
        print(f"{os.path.basename(p)} | 문장 {cells} | 위반 {len(rows)} | {' '.join(f'{k} {v}' for k, v in c.items() if v)}" + ''.join(f' | {k} {v}' for k, v in nx.items() if v))
        if not quiet:
            seen = {}
            for r in rows:
                seen.setdefault((r[2], r[3]), 0)
                seen[(r[2], r[3])] += 1
            for (k, hit), n in sorted(seen.items(), key=lambda x: -x[1])[:15]:
                print(f'   {k} · {n}건 · …{hit}…')
        total += len(rows)
    return 1 if total else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
