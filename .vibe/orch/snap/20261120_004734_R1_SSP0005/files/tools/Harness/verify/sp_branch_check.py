# -*- coding: utf-8 -*-
"""저장 SP 검증 분기 대조(2026-11-01 엔진 갭 EG161) — AS-IS 저장 SP 의 오류 문구 ↔ TO-BE 저장 PROC·화면 코드

  python tools/Harness/verify/sp_branch_check.py <MENU_ID>   → Doc/verify/<ID>/sp_branch.csv (eg_ingest 가 E4 행으로 반입)

  저장 SP 를 위반 값으로 직접 호출하지 않는다(내부 COMMIT 위험). 소스만 읽는다(사내오라클 ALL_SOURCE 새로 조회 · hook #152).
  AS-IS: 화면 저장 ENDPOINT 의 SP 와 1단계 EXEC 하위 SP 에서 RAISERROR 리터럴 · @…MSG… = '리터럴' 추출(주석 제외)
  TO-BE: 저장 PROC + 1단계 하위 호출 본문 리터럴 · 메시지 사전(msg_master) · 화면 폴더 코드
  판정: 같은 문구 또는 사전 문구로 찾음 = PASS · 단어 60% 이상 겹침 = PASS(문구 다듬음) · 없음 = MISSING(원문·SP:줄 인용)
  한계: 분기 조건이 같은지는 재지 않는다. 동적 SQL 안 문구는 리터럴로만 찾는다
"""
import argparse, csv, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..')); DOC = os.path.join(ROOT, 'Doc')
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); sys.path.insert(0, HERE)
from facts_sortrules import strip_comments  # noqa: E402  # SQL 주석(--·/* */) 제거 — facts_combosrc 판은 // 만 지운다(T37)
from sort_check import proc_body  # noqa: E402

MOD = os.path.join(DOC, 'asisfacts', 'db', 'modules')
RX_RAISE = re.compile(r"(?i)RAISERROR\s*\(\s*N?'((?:[^']|'')+)'")
RX_ASSIGN = re.compile(r"(?i)@[A-Z0-9_]*(?:MSG|ERR)[A-Z0-9_]*\s*=\s*N?'((?:[^']|'')+)'")
RX_EXEC = re.compile(r"(?i)\bEXEC(?:UTE)?\s+(?:\[?dbo\]?\.)?\[?([A-Z0-9_]+)\]?")
RX_CALL = re.compile(r'(?i)\b((?:[A-Z0-9_]+\.)?P_[A-Z0-9_]+|PR_[A-Z0-9_]+)\s*\(')
RX_LIT = re.compile(r"'((?:[^']|'')+)'")
NOISE = re.compile(r'(?i)^(\s*|y|n|s|e|ok|success|error|fail\w*|\[|\]|\d+)$')


def rd(p):
    if not os.path.exists(p): return []
    with open(p, encoding='utf-8-sig', newline='') as f: return list(csv.DictReader(f))


def asis_src(name):
    p = os.path.join(MOD, f'dbo.{name}.sql')
    if not os.path.exists(p): return ''
    raw = open(p, encoding='utf-8', errors='replace').read()
    return re.sub(r'(?m)--.*$', '', re.sub(r'/\*.*?\*/', lambda m: re.sub(r'[^\n]', ' ', m.group(0)), raw, flags=re.S))


def extract(name):
    src = asis_src(name); out = []
    if not src: return out
    for rx in (RX_RAISE, RX_ASSIGN):
        for m in rx.finditer(src):
            t = m.group(1).replace("''", "'").strip()
            if NOISE.match(t) or len(t) < 4: continue
            out.append((t, f"{name}:{src.count(chr(10), 0, m.start()) + 1}"))
    return out


RX_COND = re.compile(r"(?i)\b(?:IF|WHEN|WHERE|AND|OR|ON)\b[^\n;]{0,200}")
RX_CMP = re.compile(r"(?:=|<>|!=)\s*N?'([^'\n]{2,40})'")
RX_IN = re.compile(r"(?i)\bIN\s*\(([^)\n]{2,200})\)")


def branch_literals(src):
    """저장 SP 분기 조건의 비교 리터럴(EG179) — 대입·문구는 제외, 조건절(IF·WHEN·WHERE·AND·OR·ON) 안의 값만"""
    out = {}
    for m in RX_COND.finditer(src or ''):
        t = re.split(r'(?i)\b(?:SET|BEGIN|THEN|SELECT|EXEC|EXECUTE|UPDATE|INSERT|DELETE|PRINT|RETURN)\b', m.group(0))[0]  # 같은 줄의 대입·본문은 조건이 아니다
        vals = RX_CMP.findall(t) + [v for x in RX_IN.findall(t) for v in re.findall(r"N?'([^'\n]{2,40})'", x)]
        for v in vals:
            if not re.search(r'[%_@]$|^\s*$', v) and not re.fullmatch(r'(?i)y|n|s|e|ok|success|error', v):  # 숫자는 사업부 코드('81')일 수 있어 남긴다
                out.setdefault(v, src.count(chr(10), 0, m.start()) + 1)
    return out


def judge_branch(asis, tobe_lits):
    """AS-IS 분기 리터럴 ↔ TO-BE 리터럴(대소문자 무시) → (찾음, 없음)"""
    low = {str(x).lower() for x in tobe_lits}
    found = [k for k in asis if k.lower() in low]
    return found, [k for k in asis if k.lower() not in low]


def norm(s): return re.sub(r'[^0-9a-z가-힣]', '', (s or '').lower())
def words(s): return {w for w in re.findall(r'[0-9a-z가-힣]+', (s or '').lower()) if len(w) >= 2}


def selftest():
    src = "IF @DIVISION_ID = '81' BEGIN SET @X = 'NOPE' END\nWHERE A.TYPE IN ('AA','BB') AND B.K <> 'CC' AND C.K = 'Y'\n"
    al = branch_literals(src); f1, m1 = judge_branch(al, ['81', 'aa', 'BB']); _, m2 = judge_branch(al, [])
    cases = [('조건 값만 추출·대입 제외', sorted(al) == ['81', 'AA', 'BB', 'CC']), ('없는 값 검출', sorted(f1) == ['81', 'AA', 'BB'] and m1 == ['CC']), ('전부 없음', len(m2) == 4)]
    for nm, ok in cases: print('OK ' if ok else 'NG ', nm)
    print(f'{sum(1 for _, k in cases if k)}/{len(cases)}'); return 0 if all(k for _, k in cases) else 1


def main():
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest': sys.exit(selftest())
    ap = argparse.ArgumentParser(); ap.add_argument('menu'); a = ap.parse_args(); mid = a.menu.upper(); vd = os.path.join(DOC, 'verify', mid); os.makedirs(vd, exist_ok=True)
    acts = rd(os.path.join(DOC, 'asisfacts', 'screens', mid, 'actions.csv'))
    sps = {re.split(r'[.]', r.get('endpoint') or '')[-1].upper() for r in acts if r.get('kind') == 'ENDPOINT' and re.search(r'SAVE|_INS|_UPD|_DEL', r.get('endpoint') or '', re.I)}; sps.discard('')
    msgs, seen = [], set()
    for sp in sorted(sps):
        for t, ref in extract(sp): msgs.append((t, ref))
        for m in RX_EXEC.finditer(asis_src(sp)):
            for t, ref in extract(m.group(1).upper()): msgs.append((t, ref))
    uniq = []
    for t, ref in msgs:
        k = norm(t)
        if k and k not in seen: seen.add(k); uniq.append((t, ref))
    pm = [r for r in rd(os.path.join(DOC, 'tobefacts', 'db', 'proc_meta.csv')) if (r.get('menu_id') or '').upper() == mid and r.get('proc') and re.search(r'SAVE|INS|UPD|DEL', r.get('btn') or '', re.I)]
    # TO-BE 본문 + 1단계 호출 리터럴
    lits = []
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
                        cache[pkg] = strip_comments(''.join(r[0] for r in cur.fetchall()))
                return cache[pkg]
            for r in pm:
                tp = r['proc']; pkg, proc = (tp.split('.') + [''])[:2] if '.' in tp else ('', tp)
                body = proc_body(body_of(pkg.upper()), proc) if pkg else ''
                if not body: continue
                lits += [x.replace("''", "'") for x in RX_LIT.findall(body)]
                for m in RX_CALL.finditer(body):
                    nm = m.group(1).upper(); cpkg, cproc = (nm.split('.') + [''])[:2] if '.' in nm else (pkg.upper(), nm)
                    cb = proc_body(body_of(cpkg), cproc) if cpkg else ''
                    if not cb:  # 패키지 안에 없으면 독립 프로시저(2026-11-01 DMF0003 PR_SSP_ANL_ESS_REQ 허위 MISSING)
                        cur.execute("SELECT OWNER FROM ALL_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE IN ('PROCEDURE','FUNCTION')", n=cproc); own = cur.fetchone()
                        if own:
                            cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE IN ('PROCEDURE','FUNCTION') ORDER BY LINE", o=own[0], n=cproc); cb = strip_comments(''.join(r2[0] for r2 in cur.fetchall()))
                    if cb: lits += [x.replace("''", "'") for x in RX_LIT.findall(cb)]
    # 분기 리터럴(EG179) — AS-IS 저장 SP 조건의 값이 TO-BE 저장 PROC 에 있는지. 없으면 분기 누락이거나 다른 형태로 재작성 — ERROR 로 확인
    if pm:
        br_rows = []
        for sp in sorted(sps):
            for nm in [sp] + [m.group(1).upper() for m in RX_EXEC.finditer(asis_src(sp))]:
                al = branch_literals(asis_src(nm))
                if not al:
                    continue
                fnd, miss = judge_branch(al, lits)
                br_rows.append({'sp': nm, 'found': len(fnd), 'missing': len(miss), 'missing_list': ' | '.join(f'{k}(:{al[k]})' for k in miss[:12])})
        with open(os.path.join(vd, 'sp_branch_lit.csv'), 'w', encoding='utf-8-sig', newline='') as f:
            w = csv.DictWriter(f, fieldnames=['sp', 'found', 'missing', 'missing_list'])
            w.writeheader(); w.writerows(br_rows)
        print(f'[sp_branch] {mid}: 분기 리터럴 ' + ' / '.join(f"{x['sp']} 찾음 {x['found']}·없음 {x['missing']} {x['missing_list'][:120]}" for x in br_rows))
    # 사전 문구 — TO-BE 가 MSG ID 로 쓰면 그 ID 의 문구로 대조
    mm = rd(os.path.join(DOC, 'tobefacts', 'db', 'msg_master.csv')); text_of = {}
    for x in mm: text_of.setdefault(x.get('msg_id') or '', []).append(' '.join([x.get('msg_nm') or '', x.get('msg_desc') or '']))
    ids = set(re.findall(r'MSG\d{5}', ' '.join(lits)))
    # 화면 코드
    fe_txt = ''
    plan_p = os.path.join(DOC, 'e2e', 'specs', f'{mid}.plan.json')
    if os.path.exists(plan_p):
        import json
        rp = [x for x in re.split(r'[\\/]', json.load(open(plan_p, encoding='utf-8')).get('routePath') or '') if x]
        fd = os.path.join(ROOT, 'nscm-fe', 'features', rp[0], 'src', 'pages', rp[-1]) if len(rp) >= 2 else ''
        if fd and os.path.isdir(fd):
            for dp, dn, fn in os.walk(fd):
                dn[:] = [d for d in dn if d != 'node_modules']
                for f in fn:
                    if f.endswith(('.ts', '.tsx')): fe_txt += open(os.path.join(dp, f), encoding='utf-8', errors='replace').read() + '\n'
    if not fe_txt:  # plan 없는 화면(2026-11-01 SCP0037 operation-lt 허위 MISSING)
        fr = os.path.join(ROOT, 'nscm-fe', 'features')
        for feat in (os.listdir(fr) if os.path.isdir(fr) else []):
            pg = os.path.join(fr, feat, 'src', 'pages')
            if not os.path.isdir(pg): continue
            for page in os.listdir(pg):
                fd = os.path.join(pg, page); txt = ''
                for dp, dn, fn in os.walk(fd):
                    dn[:] = [d for d in dn if d != 'node_modules']
                    for f in fn:
                        if f.endswith(('.ts', '.tsx')): txt += open(os.path.join(dp, f), encoding='utf-8', errors='replace').read() + '\n'
                if re.search(r"['\"`]" + mid + r"['\"`]", txt): fe_txt += txt
    ids |= set(re.findall(r'MSG\d{5}', fe_txt))
    pool = [(x, 'TO-BE PROC') for x in lits] + [(t, f'사전 {i}') for i in ids for t in text_of.get(i, [])] + [(x, '화면 코드') for x in re.findall(r"['\"`]([^'\"`\n]{4,200})['\"`]", fe_txt)]
    pn = [(norm(x), words(x), w) for x, w in pool]
    rows = []
    for t, ref in uniq:
        k, wd = norm(t), words(t); hit = ''
        for pk, pw, w in pn:
            if pk and (k == pk or (len(k) >= 6 and k in pk)): hit = f'같은 문구 · {w}'; break
        if not hit and wd:
            best = max(((len(wd & pw) / len(wd), w) for pk, pw, w in pn if pw), default=(0, ''))
            if best[0] >= 0.6: hit = f'단어 {int(best[0] * 100)}% 일치 · {best[1]}'
        rows.append({'menu_id': mid, 'asis_ref': ref, 'asis_msg': t[:200], 'verdict': 'FOUND' if hit else 'MISSING', 'tobe': hit})
    with open(os.path.join(vd, 'sp_branch.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['menu_id', 'asis_ref', 'asis_msg', 'verdict', 'tobe']); w.writeheader(); w.writerows(rows)
    print(f"{mid}: AS-IS 저장 SP {len(sps)}개 · 문구 {len(uniq)} · 찾음 {sum(r['verdict'] == 'FOUND' for r in rows)} · 없음 {sum(r['verdict'] == 'MISSING' for r in rows)} · TO-BE 저장 PROC {len(pm)} · 대조 문구 {len(pool)}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
