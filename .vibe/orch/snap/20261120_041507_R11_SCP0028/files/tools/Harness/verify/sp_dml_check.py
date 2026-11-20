# -*- coding: utf-8 -*-
"""저장 SP 쓰기 컬럼 대조(2026-11-01 엔진 갭 EG238·EG230·EG223) — AS-IS 저장 SP 가 쓰는 표·컬럼 ↔ TO-BE 저장 PROC

  python tools/Harness/verify/sp_dml_check.py <MENU_ID>   → Doc/verify/<ID>/sp_dml.csv (eg_ingest 가 F8 행으로 반입)

  소스만 읽는다(저장 SP 직접 호출 금지 · 사내오라클 ALL_SOURCE 새로 조회). AS-IS = 저장 ENDPOINT SP + 1단계 EXEC · TO-BE = 저장 PROC + 1단계 호출.
  추출: UPDATE … SET 컬럼 / INSERT INTO 표(컬럼…) / MERGE 안 UPDATE SET·INSERT(컬럼…). 임시 표(# · @ · GTT)는 제외.
  판정: AS-IS 가 쓰는 컬럼을 TO-BE 도 쓴다 = FOUND · 표는 쓰는데 컬럼 없음 = MISSING_COL · 표 자체를 안 씀 = MISSING_TABLE
  한계: 값 식이 같은지는 재지 않는다 · 2단계 이상 호출·동적 SQL 은 리터럴에 보일 때만 잡힌다 — 그래서 FAIL 이 아니라 확인 대상(ERROR)으로 반입
"""
import argparse, csv, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..')); DOC = os.path.join(ROOT, 'Doc')
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); sys.path.insert(0, HERE)
from facts_sortrules import strip_comments  # noqa: E402  # SQL 주석(--·/* */) 제거 — facts_combosrc 판은 // 만 지운다(T37)
from sort_check import proc_body  # noqa: E402
from sp_branch_check import asis_src, rd, RX_EXEC, RX_CALL  # noqa: E402

SKIP_T = re.compile(r'(?i)^(#|@|GTT_|TMP_|TEMP_)|_TMP$|_TEMP$|_GTT$|^SCM_SYS_LOG|^DUAL$')
AUDIT = re.compile(r'(?i)^(CREATED_BY|CREATION_DATE|LAST_UPDATED_BY|LAST_UPDATE_DATE|LAST_UPDATE_LOGIN|ATTRIBUTE[0-9]+|[VP]_[A-Z0-9_]+|HISTORY_[A-Z_]+)$')
NAME = r'(?:\[?[A-Za-z0-9_]+\]?\.)*\[?([#@A-Za-z0-9_]+)\]?'
RX_INS = re.compile(r'(?is)\bINSERT\s+(?:INTO\s+)?' + NAME + r'\s*\(([^()]*)\)')
RX_INS_ALL = re.compile(r'(?is)\bINSERT\s+(?:INTO\s+)?' + NAME + r'\s+(?:SELECT|VALUES)\b')
RX_UPD = re.compile(r'(?is)\bUPDATE\s+' + NAME + r'(?:\s+[A-Za-z0-9_]+)?\s+SET\s+(.*?)(?=\bWHERE\b|\bFROM\b|;|\bWHEN\b|\bEND\b|\Z)')
RX_MRG = re.compile(r'(?is)\bMERGE\s+(?:INTO\s+)?' + NAME)
RX_MRG_U = re.compile(r'(?is)\bUPDATE\s+SET\s+(.*?)(?=\bWHEN\b|\bWHERE\b|;|\Z)')
RX_MRG_I = re.compile(r'(?is)\bINSERT\s*\(([^()]*)\)')


def split_top(s):
    out, d, cur = [], 0, ''
    for ch in s:
        if ch == '(': d += 1
        elif ch == ')': d -= 1
        if ch == ',' and d == 0: out.append(cur); cur = ''
        else: cur += ch
    if cur.strip(): out.append(cur)
    return out


def setcols(txt):
    cols = set()
    for p in split_top(txt):
        m = re.match(r'\s*(?:[A-Za-z0-9_\[\]"]+\.)?[\["]?([A-Za-z0-9_]+)[\]"]?\s*=', p)
        if m: cols.add(m.group(1).upper())
    return cols


def alias_map(src):
    return {m.group(2).upper(): m.group(1).upper() for m in re.finditer(r'(?i)\b(?:FROM|JOIN)\s+' + NAME + r'\s+(?:AS\s+)?([A-Za-z][A-Za-z0-9_]*)\b', src) if m.group(2).upper() not in ('WHERE', 'ON', 'SET', 'INNER', 'LEFT', 'JOIN', 'WITH', 'GROUP', 'ORDER')}


def writes(src):
    out, am = {}, alias_map(src)

    def add(t, cols):
        t = t.upper(); t = am.get(t, t)
        if SKIP_T.search(t): return
        out.setdefault(t, set()).update(c for c in cols if not AUDIT.match(c))
    for m in RX_INS.finditer(src): add(m.group(1), {c.strip().strip('[]"').upper() for c in m.group(2).split(',') if c.strip()})
    for m in RX_INS_ALL.finditer(src): add(m.group(1), {'*'})
    for m in RX_UPD.finditer(src): add(m.group(1), setcols(m.group(2)))
    for m in RX_MRG.finditer(src):
        seg = src[m.end():m.end() + 12000]; nx = RX_MRG.search(seg); seg = seg[:nx.start()] if nx else seg
        for u in RX_MRG_U.finditer(seg): add(m.group(1), setcols(u.group(1)))
        for i in RX_MRG_I.finditer(seg): add(m.group(1), {c.strip().strip('[]"').upper() for c in i.group(1).split(',') if c.strip()})
    return out


def merge(a, b):
    for t, c in b.items(): a.setdefault(t, set()).update(c)


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('menu'); a = ap.parse_args(); mid = a.menu.upper(); vd = os.path.join(DOC, 'verify', mid); os.makedirs(vd, exist_ok=True)
    acts = rd(os.path.join(DOC, 'asisfacts', 'screens', mid, 'actions.csv'))
    sps = {re.split(r'[.]', r.get('endpoint') or '')[-1].upper() for r in acts if r.get('kind') == 'ENDPOINT' and re.search(r'SAVE|_INS|_UPD|_DEL', r.get('endpoint') or '', re.I)}; sps.discard('')
    aw = {}
    for sp in sorted(sps):
        src = asis_src(sp); merge(aw, writes(src))
        for m in RX_EXEC.finditer(src): merge(aw, writes(asis_src(m.group(1).upper())))
    pm = [r for r in rd(os.path.join(DOC, 'tobefacts', 'db', 'proc_meta.csv')) if (r.get('menu_id') or '').upper() == mid and r.get('proc') and re.search(r'SAVE|INS|UPD|DEL', r.get('btn') or '', re.I)]
    tw = {}
    if pm:
        from dbconn import connect
        cache = {}
        with connect('tobe') as cx:
            cur = cx.cursor()

            def body_of(pkg):
                if pkg not in cache:
                    cur.execute("SELECT OWNER FROM ALL_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=pkg); m = cur.fetchone()
                    if not m: cache[pkg] = ''
                    else:
                        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", o=m[0], n=pkg)
                        cache[pkg] = strip_comments(''.join(r2[0] for r2 in cur.fetchall()))
                return cache[pkg]
            for r in pm:
                tp = r['proc']; pkg, proc = (tp.split('.') + [''])[:2] if '.' in tp else ('', tp)
                body = proc_body(body_of(pkg.upper()), proc) if pkg else ''
                if not body: continue
                merge(tw, writes(body))
                for m in RX_CALL.finditer(body):
                    nm = m.group(1).upper(); cpkg, cproc = (nm.split('.') + [''])[:2] if '.' in nm else (pkg.upper(), nm)
                    cb = proc_body(body_of(cpkg), cproc) if cpkg else ''
                    if not cb:
                        cur.execute("SELECT OWNER FROM ALL_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE IN ('PROCEDURE','FUNCTION')", n=cproc); own = cur.fetchone()
                        if own:
                            cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE IN ('PROCEDURE','FUNCTION') ORDER BY LINE", o=own[0], n=cproc); cb = strip_comments(''.join(r2[0] for r2 in cur.fetchall()))
                    if cb: merge(tw, writes(cb))
    pkg_text = ' '.join(v for v in (cache.values() if pm else []) if v).upper()
    said = lambda w: bool(w) and re.search(r'(?<![A-Z0-9_])' + re.escape(w) + r'(?![A-Z0-9_])', pkg_text) is not None
    rows = []
    for t, cols in sorted(aw.items()):
        cols = {c for c in cols if c != '*'}
        if t not in tw:
            if said(t): rows.append({'menu_id': mid, 'table': t, 'column': '', 'verdict': 'FOUND', 'detail': '패키지 본문 언급(쓰기 문장 미확인)'}); continue
            rows.append({'menu_id': mid, 'table': t, 'column': '', 'verdict': 'MISSING_TABLE', 'detail': f'AS-IS 쓰기 컬럼 {len(cols)}개 · TO-BE 저장 경로에 이 표 쓰기 없음'}); continue
        for c in sorted(cols):
            rows.append({'menu_id': mid, 'table': t, 'column': c, 'verdict': 'FOUND' if c in tw[t] or '*' in tw[t] or said(c) else 'MISSING_COL', 'detail': '' if c in tw[t] or '*' in tw[t] else '패키지 본문 언급(쓰기 문장 미확인)' if said(c) else f'TO-BE 는 이 표에 컬럼 {len(tw[t])}개만 씀'})
    with open(os.path.join(vd, 'sp_dml.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['menu_id', 'table', 'column', 'verdict', 'detail']); w.writeheader(); w.writerows(rows)
    import collections
    print(f"{mid}: AS-IS 저장 SP {len(sps)} · 표 {len(aw)} · TO-BE 저장 PROC {len(pm)} · 표 {len(tw)} · {dict(collections.Counter(r['verdict'] for r in rows))}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
