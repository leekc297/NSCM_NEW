# -*- coding: utf-8 -*-
"""Cross-check 기준값: 화면별 로직 .cs 의 메시지 호출(주석 제외) — GMessageBox / MessageBox.Show / XtraMessageBox.Show / FoxMessageBox.Show.
주석 제거는 문자열 리터럴("..", @"..", '..')을 인식하는 토크나이저로 한다(정규식 제거는 문자열 안의 /* 를 주석으로 오인 — 2026-10-23 SCP0078/0099 에서 확인).
출력: msgcalls_grep.csv (screen, msgcalls_grep, detail, lines=파일:줄 목록)"""
import csv, os, re

W = os.path.dirname(os.path.abspath(__file__))
G = r'C:/Projects/NSCM/GSCM/'
PAT = re.compile(r'GMessageBox\s*\(|XtraMessageBox\.Show\s*\(|FoxMessageBox\.Show\s*\(|(?<![A-Za-z])MessageBox\.Show\s*\(')

def strip_comments(src):
    """주석을 공백으로 바꾸고 줄 구조는 유지. 문자열·문자 리터럴 안은 건드리지 않음."""
    out, i, n = [], 0, len(src)
    while i < n:
        c = src[i]
        nx = src[i + 1] if i + 1 < n else ''
        if c == '/' and nx == '/':
            j = src.find('\n', i)
            j = n if j < 0 else j
            out.append(' ' * (j - i)); i = j
        elif c == '/' and nx == '*':
            j = src.find('*/', i + 2)
            j = n if j < 0 else j + 2
            out.append(''.join(ch if ch == '\n' else ' ' for ch in src[i:j])); i = j
        elif c == '@' and nx == '"':
            j = i + 2
            while j < n:
                if src[j] == '"':
                    if j + 1 < n and src[j + 1] == '"':
                        j += 2; continue
                    break
                j += 1
            out.append(src[i:j + 1]); i = j + 1
        elif c == '"' or c == "'":
            j = i + 1
            while j < n and src[j] != c and src[j] != '\n':
                j += 2 if src[j] == '\\' else 1
            out.append(src[i:j + 1]); i = j + 1
        else:
            out.append(c); i += 1
    return ''.join(out)

rows = []
for s in csv.DictReader(open(f'{W}/screens.csv', encoding='utf-8-sig')):
    total, per, lines = 0, [], []
    for ent in filter(None, s['logic_files'].split(';')):
        path = ent.rsplit(':', 1)[0]
        if path.lower().endswith('.designer.cs'):
            continue
        fp = G + path
        if not os.path.exists(fp):
            per.append(f'{path}:MISSING'); continue
        src = strip_comments(open(fp, encoding='utf-8-sig', errors='replace').read())
        n = 0
        for i, l in enumerate(src.split('\n'), 1):
            k = len(PAT.findall(l))
            if k:
                n += k; lines.extend([f'{os.path.basename(path)}:{i}'] * k)
        total += n; per.append(f'{os.path.basename(path)}:{n}')
    rows.append({'screen': s['screen'], 'msgcalls_grep': total, 'detail': ';'.join(per), 'lines': ';'.join(lines)})
with open(f'{W}/msgcalls_grep.csv', 'w', encoding='utf-8-sig', newline='') as fo:
    w = csv.DictWriter(fo, fieldnames=['screen', 'msgcalls_grep', 'detail', 'lines']); w.writeheader(); w.writerows(rows)
print('screens', len(rows), 'calls', sum(r['msgcalls_grep'] for r in rows), 'missing', sum(r['detail'].count('MISSING') for r in rows))
