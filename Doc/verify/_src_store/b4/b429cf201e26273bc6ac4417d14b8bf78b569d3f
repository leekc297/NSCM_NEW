# -*- coding: utf-8 -*-
"""AS-IS 사실 파일의 컬럼 상수 이름 정규화 (2026-11-12 T266 · 주기 1 C1-27)

  문제: 화면 코드가 컬럼 상수를 대소문자 혼합 이름으로 선언한 경우(DMF0005 cs:192 `public static string EditFlag = "EDIT_FLAG";`)
        사실 파일(actions.csv 등)에는 `DefColumns.EditFlag` 로 남는데, 이를 읽는 도구 25개 + 검증 스펙의 정규식은 `Def*.([A-Z0-9_]+)` 라
        'E' 만 잘라 읽거나 아예 못 잡는다(T265 — DMF0005 'COL(E) 없음'). 검증 대상 48개 화면 원문에 이런 참조 8,209곳(실측 2026-11-12 15:34).
  방법: 읽는 쪽 수십 곳을 고치는 대신, 사실 파일 안의 `Def*.<혼합 이름>` 을 그 상수의 값(`Def*.<VALUE>`)으로 바꿔 쓴다(한 곳 · 멱등).
        값은 그 화면 AS-IS 원문(사실 파일의 file 열이 가리키는 .cs)의 선언에서만 읽는다. 다음은 바꾸지 않는다:
          · 값이 대문자·숫자·밑줄이 아닌 것(컬럼 이름이 아님)  · 같은 이름이 서로 다른 값으로 선언된 것(어느 것인지 모름)  · 선언을 못 찾은 것
        바꾼 내역은 defcol_alias.csv(이름 · 값 · 건수 · 선언 위치)에 남긴다 — 원문 표기는 여기서 되찾을 수 있다.

  python tools/Harness/verify/facts_defcols.py <ID> [--asis <AS-IS ID>]   그 화면 사실 파일 정규화(이미 정규화돼 있으면 0건)
  python tools/Harness/verify/facts_defcols.py --check <ID>               바꿀 것이 남았는지만(쓰지 않음 · 남았으면 exit 2)
  python tools/Harness/verify/facts_defcols.py --selftest
"""
import csv, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
FILES = ('actions.csv', 'actions_entries.csv', 'events.csv')
RX_TOKEN = re.compile(r'\b(Def[A-Za-z0-9_]*)\.([A-Za-z_][A-Za-z0-9_]*)')
RX_DECL = re.compile(r'\b(?:public|private|internal|protected)?\s*(?:static\s+readonly|static|const|readonly)\s+(?:readonly\s+)?(?:string|String)\s+([A-Za-z_]\w*)\s*=\s*"([^"]*)"\s*;')


def decl_map(texts):
    """원문들 → ({이름: 값}, {이름: [값들]} 충돌). 값이 대문자·숫자·밑줄인 선언만 · 같은 이름이 다른 값이면 충돌로 빼낸다"""
    seen = {}
    for src, text in texts:
        for i, ln in enumerate(text.split('\n'), 1):
            m = RX_DECL.search(ln.split('//')[0])
            if m and re.fullmatch(r'[A-Z0-9_]+', m.group(2)):
                seen.setdefault(m.group(1), {}).setdefault(m.group(2), f'{src}:{i}')
    ok = {k: (next(iter(v)), next(iter(v.values()))) for k, v in seen.items() if len(v) == 1}
    clash = {k: sorted(v) for k, v in seen.items() if len(v) > 1}
    return ok, clash


def normalize(text, cmap):
    """사실 파일 본문 → (바꾼 본문, {이름: 건수}). 이름이 이미 대문자·숫자·밑줄이면 그대로(멱등)"""
    cnt = {}

    def rep(m):
        name = m.group(2)
        if re.fullmatch(r'[A-Z0-9_]+', name) or name not in cmap or cmap[name][0] == name:
            return m.group(0)
        cnt[name] = cnt.get(name, 0) + 1
        return f'{m.group(1)}.{cmap[name][0]}'
    return RX_TOKEN.sub(rep, text), cnt


def sem_rows(text, names, rel_src, class_file):
    """2026-11-25 사용자 지시 'VM 의 AS-IS 파서에도 의미 분석 연결': 같은 이름이 클래스마다 다른 값으로 선언돼(충돌) 이름만으로 못 바꾼 상수를
    사실 파일 행(file 열 · 없으면 class 열로 찾은 파일)마다 Roslyn 의미 모델(asis_sem.values)로 실제 심볼 값을 받아 바꾼다.
    값이 대문자·숫자·밑줄 하나로 정해질 때만 바꾼다. → (바꾼 본문, {(파일, 이름): (값, 건수)})"""
    import io as _io
    try:
        import asis_sem
    except Exception:
        return text, {}
    rows = list(csv.reader(_io.StringIO(text)))
    if not rows:
        return text, {}
    hdr = rows[0]
    fi = hdr.index('file') if 'file' in hdr else -1
    ci = hdr.index('class') if 'class' in hdr else -1

    def file_of(r):
        if fi >= 0 and fi < len(r):
            return r[fi]
        return class_file.get(r[ci], '') if 0 <= ci < len(r) else ''
    need = set()
    for r in rows[1:]:
        f = file_of(r)
        if not f or f not in rel_src:
            continue
        for cell in r:
            for m in RX_TOKEN.finditer(cell):
                if m.group(2) in names:
                    need.add((f, m.group(0)))
    if not need:
        return text, {}
    qs = []
    for f, tok in sorted(need):
        lines = rel_src[f].split('\n')
        ln = next((i for i, t in enumerate(lines, 1) if re.search(r'(?<![\w.])' + re.escape(tok) + r'\b', t.split('//')[0])), 0)
        if ln:
            qs.append((f, ln, tok))
    got = asis_sem.values(qs) if qs else {}
    val = {}
    for (f, _ln, tok), v in got.items():
        if v and v['status'] == 'OK' and len(v['values']) == 1 and re.fullmatch(r'[A-Z0-9_]+', v['values'][0]):
            val[(f.replace('/', chr(92)), tok)] = v['values'][0]
    cnt = {}
    for r in rows[1:]:
        f = file_of(r).replace('/', chr(92))
        for i, cell in enumerate(r):
            def rep(m, f=f):
                v = val.get((f, m.group(0)))
                if not v or m.group(2) not in names:
                    return m.group(0)
                k = (f, m.group(0)); c = cnt.get(k, (v, 0)); cnt[k] = (v, c[1] + 1)
                return f'{m.group(1)}.{v}'
            r[i] = RX_TOKEN.sub(rep, cell)
    if not cnt:
        return text, {}
    out = _io.StringIO()
    w = csv.writer(out, quoting=csv.QUOTE_ALL, lineterminator='\r\n')
    w.writerows(rows)
    return out.getvalue(), cnt


def selftest():
    src = [('A.cs', 'public static string EditFlag = "EDIT_FLAG";\n public static string ITEM_ID = "ITEM_ID";\n public static string Title = "Sales Site"; // 컬럼 아님\n const string Measure = "MEASURE";'),
           ('B.cs', 'public static string Measure = "MEASURE";\n public static string Kind = "KIND_A";'), ('C.cs', 'public static string Kind = "KIND_B";')]
    cmap, clash = decl_map(src)
    t0 = 'if (GetColumnIndex(DefColumns.EditFlag) == e.Column) ▸ DefMain.Measure ▸ DefColumns.ITEM_ID ▸ DefColumns.Title ▸ DefColumns.Kind ▸ DefColumns.Unknown ▸ Default.Value'
    t1, c1 = normalize(t0, cmap)
    t2, c2 = normalize(t1, cmap)
    cases = [('혼합 이름 → 값', 'DefColumns.EDIT_FLAG' in t1 and 'DefColumns.EditFlag' not in t1),
             ('다른 Def* 접두도', 'DefMain.MEASURE' in t1),
             ('이미 대문자 이름은 그대로', 'DefColumns.ITEM_ID' in t1),
             ('값이 컬럼 이름 꼴이 아니면 그대로', 'DefColumns.Title' in t1),
             ('같은 이름·다른 값(충돌)은 그대로', 'DefColumns.Kind' in t1 and 'Kind' in clash),
             ('선언 없는 이름은 그대로', 'DefColumns.Unknown' in t1),
             ('Def 로 시작하는 다른 단어의 멤버(선언 없음)는 그대로', 'Default.Value' in t1),
             ('여러 파일 같은 값은 충돌 아님', 'Measure' in cmap and 'Measure' not in clash),
             ('건수', c1 == {'EditFlag': 1, 'Measure': 1}),
             ('멱등(두 번째는 0건)', t2 == t1 and c2 == {})]
    bad = 0
    for n, ok in cases:
        print(('PASS ' if ok else 'FAIL ') + n); bad += (not ok)
    print(f'selftest {len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


def main():
    a = sys.argv[1:]
    if '--selftest' in a:
        return selftest()
    check = '--check' in a
    asis = a[a.index('--asis') + 1] if '--asis' in a else ''
    ids = [x for x in a if not x.startswith('--') and x != asis]
    if not ids:
        print(__doc__); return 3
    mid = ids[0].upper()
    sdir = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', asis or mid)
    ap = os.path.join(sdir, 'actions.csv')
    if not os.path.exists(ap):
        print(f'[facts_defcols] {mid}: actions.csv 없음 — 건너뜀'); return 0
    with open(ap, encoding='utf-8-sig', newline='') as f:
        rels = sorted({(r.get('file') or '').replace('\\', '/') for r in csv.DictReader(f) if r.get('file')})
    texts = []; missing = []
    for rel in rels:
        fp = next((os.path.join(ROOT, b, rel) for b in ('GSCM', 'GSCM_20260512') if os.path.exists(os.path.join(ROOT, b, rel))), None)
        if not fp:
            missing.append(rel); continue
        with open(fp, encoding='utf-8', errors='replace') as f:
            texts.append((os.path.basename(rel), f.read()))
    cmap, clash = decl_map(texts)
    # 2026-11-25 의미 분석: 충돌 이름을 행 단위로 풀 때 쓰는 원문(파일 열 표기 그대로) · 클래스 → 파일
    rel_src = {}
    for rel in rels:
        fp = next((os.path.join(ROOT, b, rel) for b in ('GSCM', 'GSCM_20260512') if os.path.exists(os.path.join(ROOT, b, rel))), None)
        if fp:
            with open(fp, encoding='utf-8', errors='replace') as f:
                rel_src[rel.replace('/', chr(92))] = f.read()
    class_file = {}
    with open(ap, encoding='utf-8-sig', newline='') as f:
        for r in csv.DictReader(f):
            if r.get('class') and r.get('file'):
                class_file.setdefault(r['class'], set()).add(r['file'].replace('/', chr(92)))
    class_file = {k: next(iter(v)) for k, v in class_file.items() if len(v) == 1}
    sem_total = {}
    total = {}; changed = []
    for fn in FILES:
        fp = os.path.join(sdir, fn)
        if not os.path.exists(fp):
            continue
        with open(fp, encoding='utf-8-sig', newline='') as f:
            old = f.read()
        new, cnt = normalize(old, cmap)
        if clash and os.environ.get('ASIS_SEM_OFF') != '1':
            try:
                new, scnt = sem_rows(new, set(clash), rel_src, class_file)
            except Exception as e:  # 도구 실패 = 종전 결과(이름만으로 바꾼 것까지)
                print(f'[WARN] facts_defcols {mid}: 의미 분석 행 정규화 실패({type(e).__name__}: {str(e)[:100]})'); scnt = {}
            for (ff, tok), (v, c) in scnt.items():
                nm = tok.split('.', 1)[1]
                cnt[nm] = cnt.get(nm, 0) + c
                sem_total[(ff, tok)] = (v, sem_total.get((ff, tok), (v, 0))[1] + c)
        for k, v in cnt.items():
            total[k] = total.get(k, 0) + v
        if cnt and not check:
            tmp = fp + '.tmp_defcols'
            with open(tmp, 'w', encoding='utf-8-sig', newline='') as f:
                f.write(new)
            os.replace(tmp, fp)
        if cnt:
            changed.append(f'{fn} {sum(cnt.values())}')
    # 풀지 못해 그대로 둔 혼합 이름(보고용)
    left = {}
    for fn in FILES:
        fp = os.path.join(sdir, fn)
        if os.path.exists(fp):
            with open(fp, encoding='utf-8-sig', newline='') as f:
                for m in RX_TOKEN.finditer(f.read()):
                    if not re.fullmatch(r'[A-Z0-9_]+', m.group(2)):
                        left[m.group(2)] = left.get(m.group(2), 0) + 1
    if sem_total and not check:   # 의미 분석으로 바꾼 충돌 이름(파일마다 값이 다를 수 있어 파일 열 포함)
        with open(os.path.join(sdir, 'defcol_alias_sem.csv'), 'w', encoding='utf-8-sig', newline='') as f:
            w = csv.writer(f); w.writerow(['file', 'member', 'value', 'count'])
            for (ff, tok), (v, c) in sorted(sem_total.items()):
                w.writerow([ff, tok, v, c])
    for k in list(total):
        if k not in cmap:   # 의미 분석으로만 바꾼 이름은 defcol_alias.csv(이름 하나 = 값 하나) 대상 아님
            total.pop(k)
    if total and not check:
        outp = os.path.join(sdir, 'defcol_alias.csv'); prev = {}
        if os.path.exists(outp):
            with open(outp, encoding='utf-8-sig', newline='') as f:
                prev = {r['member']: r for r in csv.DictReader(f)}
        for k, v in total.items():
            prev[k] = {'member': k, 'value': cmap[k][0], 'count': str(int((prev.get(k) or {}).get('count') or 0) + v), 'declared_at': cmap[k][1]}
        with open(outp, 'w', encoding='utf-8-sig', newline='') as f:
            w = csv.DictWriter(f, fieldnames=['member', 'value', 'count', 'declared_at']); w.writeheader(); w.writerows(sorted(prev.values(), key=lambda r: r['member']))
    n = sum(total.values()) + sum(c for _v, c in sem_total.values())
    print(f"[facts_defcols] {mid}: 컬럼 상수 이름 → 값 {n}곳({len(total)}종){' — 바꿀 것 있음(쓰지 않음)' if check and n else ''}"
          + (f" · {', '.join(changed)}" if changed else '')
          + (f" · 그대로 둔 혼합 이름 {sum(left.values())}곳({len(left)}종 · 선언 없음/컬럼 이름 꼴 아님/충돌 {len(clash)}종)" if left else '')
          + (f' · 원문 못 찾음 {len(missing)}개' if missing else '')
          + (f" · 의미 분석으로 충돌 이름 {sum(c for _v, c in sem_total.values())}곳({len(sem_total)}종·파일별) 값 확정" if sem_total else ''))
    if total:
        print('   ' + ' · '.join(f'{k}→{cmap[k][0]} {v}' for k, v in sorted(total.items(), key=lambda kv: -kv[1])[:10]))
    return 2 if (check and n) else 0


if __name__ == '__main__':
    sys.exit(main())
