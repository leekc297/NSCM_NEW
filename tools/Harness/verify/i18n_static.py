# -*- coding: utf-8 -*-
"""다국어 정적 점검(2026-11-01 엔진 갭 EG451·EG356·EG364)

  python tools/Harness/verify/i18n_static.py <MENU_ID>   → Doc/verify/<ID>/i18n_static.csv (eg_ingest 가 MS1·I1 행으로 반입)

  FE: 화면 폴더 .ts/.tsx 문자열·JSX 텍스트의 한글 — 주석 제외 · t(코드, '_기본문구') 의 기본 문구 제외(등록 코드가 우선) · 등록 코드 없는 고정 문구만
  DB: 화면 저장·조회 PROC 본문의 한글 문자열 리터럴(주석 제외 · ALL_SOURCE 새로 조회) — 언어 전환 때 그대로 보이는 메시지 후보
  사전: 화면이 쓰는 MSG 코드 중 같은 언어·같은 문구를 가진 다른 코드(재사용 위반 후보)
  한계: 문자열이 화면에 실제 표시되는지는 재지 않는다 — 내부 비교값·로그일 수 있어 FAIL 이 아니라 ERROR(확인 대상)
"""
import argparse, collections, csv, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..')); DOC = os.path.join(ROOT, 'Doc')
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); sys.path.insert(0, HERE)
from facts_sortrules import strip_comments  # noqa: E402  # SQL 주석(--·/* */) 제거 — facts_combosrc 판은 // 만 지운다(T37)
from sort_check import proc_body  # noqa: E402
from sp_branch_check import rd  # noqa: E402

KO = re.compile(r'[가-힣]')
RX_STR = re.compile(r"""'([^'\n]*[가-힣][^'\n]*)'|"([^"\n]*[가-힣][^"\n]*)"|`([^`\n]*[가-힣][^`\n]*)`""")
RX_JSX = re.compile(r'>\s*([^<>{}\n]*[가-힣][^<>{}\n]*)\s*<')
RX_T_DEFAULT = re.compile(r"\bt\(\s*[^,()]+,\s*$")


def page_dir(mid):
    plan = os.path.join(DOC, 'e2e', 'specs', f'{mid}.plan.json')
    if os.path.exists(plan):
        rp = [x for x in re.split(r'[\\/]', json.load(open(plan, encoding='utf-8')).get('routePath') or '') if x]
        if len(rp) >= 2:
            d = os.path.join(ROOT, 'nscm-fe', 'features', rp[0], 'src', 'pages', rp[-1])
            if os.path.isdir(d): return [d]
    out = []; fr = os.path.join(ROOT, 'nscm-fe', 'features')
    for feat in (os.listdir(fr) if os.path.isdir(fr) else []):
        pg = os.path.join(fr, feat, 'src', 'pages')
        if not os.path.isdir(pg): continue
        for page in os.listdir(pg):
            d = os.path.join(pg, page)
            for dp, dn, fn in os.walk(d):
                dn[:] = [x for x in dn if x != 'node_modules']
                if any(f.endswith(('.ts', '.tsx')) and re.search(r"['\"`]" + mid + r"['\"`]", open(os.path.join(dp, f), encoding='utf-8', errors='replace').read()) for f in fn):
                    out.append(d); break
    return out


def strip_ts(t):
    t = re.sub(r'/\*.*?\*/', lambda m: re.sub(r'[^\n]', ' ', m.group(0)), t, flags=re.S)
    return re.sub(r'(?m)(?<![:\'"`])//.*$', '', t)


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('menu'); a = ap.parse_args(); mid = a.menu.upper(); vd = os.path.join(DOC, 'verify', mid); os.makedirs(vd, exist_ok=True)
    rows = []; ids = set()
    for d in page_dir(mid):
        for dp, dn, fn in os.walk(d):
            dn[:] = [x for x in dn if x != 'node_modules']
            for f in fn:
                if not f.endswith(('.ts', '.tsx')) or re.search(r'\.(test|spec|asis\.spec)\.', f): continue
                p = os.path.join(dp, f); src = strip_ts(open(p, encoding='utf-8', errors='replace').read()); rel = os.path.relpath(p, ROOT).replace('\\', '/')
                ids |= set(re.findall(r'MSG\d{5}', src))
                for m in RX_STR.finditer(src):
                    if RX_T_DEFAULT.search(src[max(0, m.start() - 80):m.start()]): continue  # t(코드, '기본 문구')
                    txt = next(g for g in m.groups() if g is not None)
                    if txt.startswith('_'): continue
                    rows.append({'menu_id': mid, 'kind': 'FE', 'where': f"{rel}:{src.count(chr(10), 0, m.start()) + 1}", 'text': txt[:100]})
                if f.endswith('.tsx'):
                    for m in RX_JSX.finditer(src): rows.append({'menu_id': mid, 'kind': 'FE', 'where': f"{rel}:{src.count(chr(10), 0, m.start()) + 1}", 'text': m.group(1).strip()[:100]})
    pm = [r for r in rd(os.path.join(DOC, 'tobefacts', 'db', 'proc_meta.csv')) if (r.get('menu_id') or '').upper() == mid and r.get('proc') and '.' in r.get('proc')]
    if pm:
        from dbconn import connect
        cache = {}; seen = set()
        with connect('tobe') as cx:
            cur = cx.cursor()
            for r in pm:
                pkg, proc = r['proc'].split('.')[:2]; pkg = pkg.upper()
                if r['proc'] in seen: continue
                seen.add(r['proc'])
                if pkg not in cache:
                    cur.execute("SELECT OWNER FROM ALL_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=pkg); m = cur.fetchone()
                    if not m: cache[pkg] = ''
                    else:
                        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", o=m[0], n=pkg); cache[pkg] = strip_comments(''.join(x[0] for x in cur.fetchall()))
                body = proc_body(cache[pkg], proc) if cache[pkg] else ''
                for line in (body or '').split(chr(10)):
                  line = re.sub(r'--.*$', '', line)
                  for lit in re.findall(r"'((?:[^'\n]|'')*[가-힣](?:[^'\n]|'')*)'", line):
                    rows.append({'menu_id': mid, 'kind': 'DB', 'where': r['proc'], 'text': lit[:100]})
    # 같은 문구 다른 코드
    mm = rd(os.path.join(DOC, 'tobefacts', 'db', 'msg_master.csv')); by = collections.defaultdict(set)
    for x in mm:
        if (x.get('msg_id') or '').startswith('MSG') and x.get('use_yn') != 'N': by[(x.get('lang_cd'), (x.get('msg_nm') or '').strip())].add(x['msg_id'])
    for (lg, txt), codes in by.items():
        if len(codes) > 1 and txt and codes & ids:
            rows.append({'menu_id': mid, 'kind': 'DUP', 'where': ','.join(sorted(codes)[:6]), 'text': f'[{lg}] {txt[:80]}'})
    uniq = {(r['kind'], r['where'], r['text']): r for r in rows}; rows = list(uniq.values())
    with open(os.path.join(vd, 'i18n_static.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['menu_id', 'kind', 'where', 'text']); w.writeheader(); w.writerows(rows)
    print(f"{mid}: {dict(collections.Counter(r['kind'] for r in rows))} · 화면 사용 MSG {len(ids)}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
