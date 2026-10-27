# -*- coding: utf-8 -*-
"""AS-IS SP -> TO-BE PKG.PROC / standalone 매핑 (다중 근거)
 M1 TO-BE 블록 헤더 'Program ID : <AS-IS>' / V_PROGRAM_NAME := '<AS-IS>'
 M2 정확명 (P_ 접두 제거 후 동일 / standalone 동명)
 M3 TO-BE 블록 내 AS-IS 명 언급(주석 포함)
 M4 축약 정규화명 일치 (SHIPMENT->SHIP 등) — 같은 화면번호 PKG 안
 M5 FE __asis-mapping__.md 에서 AS-IS 명과 같은 행에 PKG.P_ 표기
출력: tobe/proc_blocks.csv (PKG 멤버별 라인 범위), map.csv
"""
import os, re, csv, glob, sys, collections
sys.path.insert(0, r'C:/Projects/NSCM/_artifacts/_diagnostics')
BASE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(BASE, 'tobe', 'src')

def rd(p):
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))

units = [r for r in rd(os.path.join(BASE, 'units.csv')) if r['kind'] == 'SP']
asis_names = {r['unit'] for r in units}
procs = rd(os.path.join(BASE, 'tobe', 'procs.csv'))
standalone = {r['object'] for r in procs if r['type'] in ('PROCEDURE', 'FUNCTION')}

# standalone 중 AS-IS 동명인데 덤프에 없는 것 추가 덤프
need = sorted(n for n in asis_names if n in standalone and not os.path.exists(os.path.join(SRC, f'{n}.PROCEDURE.sql')) and not os.path.exists(os.path.join(SRC, f'{n}.FUNCTION.sql')))
if need:
    import ora, oracledb
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    extra = []
    for n in need:
        cur.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE IN ('PROCEDURE','FUNCTION')", n=n)
        for t, s, l in cur.fetchall():
            cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=n, t=t)
            txt = ''.join(x[0] or '' for x in cur.fetchall())
            fn = f'{n}.{t}.sql'
            open(os.path.join(SRC, fn), 'w', encoding='utf-8', newline='').write(txt)
            extra.append([n, t, s, l, txt.count('\n') + 1, fn, 'asis_samename'])
    with open(os.path.join(BASE, 'tobe', 'objects.csv'), 'a', encoding='utf-8-sig', newline='') as f:
        csv.writer(f).writerows(extra)
    print('extra standalone dumped', len(extra))

# PKG BODY 멤버 블록 분해
blocks = []  # pkg, member, start, end, file
HDR = re.compile(r'^\s*(PROCEDURE|FUNCTION)\s+("?\w+"?)', re.I)
for fp in glob.glob(os.path.join(SRC, '*.PACKAGE_BODY.sql')):
    pkg = os.path.basename(fp).split('.')[0]
    lines = open(fp, encoding='utf-8').read().split('\n')
    starts = []
    depth_comment = False
    for i, l in enumerate(lines, 1):
        m = HDR.match(l)
        if m:
            starts.append((i, m.group(2).strip('"').upper()))
    for k, (s, nm) in enumerate(starts):
        e = starts[k + 1][0] - 1 if k + 1 < len(starts) else len(lines)
        # 블록 끝 = 'END <이름>;' (중첩 지역 서브프로그램이 부모를 자르지 않도록) — 없으면 다음 시작-1
        pe = re.compile(r'^\s*END\s+"?' + re.escape(nm) + r'"?\s*;', re.I)
        for j in range(s - 1, len(lines)):
            if pe.match(lines[j]):
                e = j + 1; break
        # 이전 블록 끝 주석 헤더(Program ID)가 다음 PROCEDURE 위에 있는 형식 대응: 헤더 영역은 직전 30줄까지 포함
        blocks.append(dict(pkg=pkg, member=nm, start=s, end=e, file=os.path.basename(fp)))
for fp in glob.glob(os.path.join(SRC, '*.PROCEDURE.sql')) + glob.glob(os.path.join(SRC, '*.FUNCTION.sql')):
    n = os.path.basename(fp).split('.')[0]
    L = open(fp, encoding='utf-8').read().count('\n') + 1
    blocks.append(dict(pkg='', member=n, start=1, end=L, file=os.path.basename(fp)))
with open(os.path.join(BASE, 'tobe', 'proc_blocks.csv'), 'w', encoding='utf-8-sig', newline='') as f:
    w = csv.DictWriter(f, fieldnames=['pkg', 'member', 'start', 'end', 'file']); w.writeheader(); w.writerows(blocks)

cache = {}
def text(fn):
    if fn not in cache:
        cache[fn] = open(os.path.join(SRC, fn), encoding='utf-8').read().split('\n')
    return cache[fn]

ABBR = [('SHIPMENT', 'SHIP'), ('PRODUCTION', 'PROD'), ('DATASET', 'DS'), ('INFORMATION', 'INFO'), ('MANAGEMENT', 'MGMT'),
        ('REQUEST', 'REQ'), ('CONFIRM', 'CFM'), ('INVENTORY', 'INV'), ('CAPACITY', 'CAPA'), ('HISTORY', 'HIST'),
        ('DETAIL', 'DTL'), ('MASTER', 'MST'), ('_ANL_', '_'), ('_PLAN_', '_'), ('_ROW_', '_'), ('_DATA', '')]
def norm(n):
    n = re.sub(r'^P_', '', n.upper())
    for a, b in ABBR:
        n = n.replace(a, b)
    return n.replace('__', '_').strip('_')

ev = collections.defaultdict(lambda: collections.defaultdict(set))  # asis -> target -> evidences
def tgt(b):
    return f"{b['pkg']}.{b['member']}" if b['pkg'] else b['member']
name_re = re.compile(r'\b(' + '|'.join(sorted(map(re.escape, asis_names), key=len, reverse=True)) + r')\b')
byfile = collections.defaultdict(list)
for b in blocks:
    byfile[b['file']].append(b)
for fn, bl in byfile.items():
    bl.sort(key=lambda x: x['start'])
    L = text(fn)
    for i, line in enumerate(L, 1):
        ms = name_re.findall(line.upper())
        if not ms:
            continue
        cont = next((b for b in reversed(bl) if b['start'] <= i <= b['end']), None)
        # 'Program ID :' 헤더 주석 = 바로 뒤(40줄 이내) 시작 블록 소유 / V_PROGRAM_NAME := 는 포함 블록 소유
        if re.search(r'PROGRAM\s*ID\s*:', line, re.I):
            nxt = next((b for b in bl if i < b['start'] <= i + 40), None)
            # 블록 내부(선언부)에 있으면 그 블록, 블록 사이(END 이후)면 다음 블록
            owner, kind = (cont if cont is not None else nxt), 'M1_program_id'
        elif re.search(r'V_PROGRAM_(NAME|NM)[^;]*:=', line, re.I):
            owner, kind = cont, 'M1_program_id'
        else:
            owner, kind = cont, 'M3_mention'
        if owner is None:
            continue
        for a in ms:
            if a == owner['member'] or re.sub(r'^P_', '', owner['member']) == a:
                continue
            ev[a][tgt(owner)].add(kind)
for b in blocks:
    m = re.sub(r'^P_', '', b['member'])
    if m in asis_names:
        ev[m][tgt(b)].add('M0_standalone_exact' if not b['pkg'] and b['member'] == m else 'M2_exact')
nidx = collections.defaultdict(list)
for b in blocks:
    nidx[norm(b['member'])].append(b)
for a in asis_names:
    for b in nidx.get(norm(a), []):
        ev[a][tgt(b)].add('M4_abbr_norm')
# M6 화면 PKG 안 접두 제거명: SCP0049_GET_CAPA -> PKG_SCP0049.P_GET_CAPA (축약 정규화 포함)
for a in asis_names:
    mm = re.match(r'^((?:SCP|SSP)\d{4})_(.+)$', a)
    if not mm:
        continue
    for b in blocks:
        if b['pkg'] == f'PKG_{mm.group(1)}' and norm(re.sub(r'^P_', '', b['member'])) == norm(mm.group(2)):
            ev[a][tgt(b)].add('M6_screen_pkg_stripped')
# 수동 확정(비교 판독에서 원문 확인된 대상) — overrides.csv
ovp = os.path.join(BASE, 'overrides.csv')
if os.path.exists(ovp):
    for r in csv.DictReader(open(ovp, encoding='utf-8-sig')):
        ev[r['asis_sp']] = collections.defaultdict(set, {r['tobe']: {'M9_manual_override'}})
for fp in glob.glob(r'C:/Projects/NSCM/nscm-fe/features/*/src/pages/*/__asis-mapping__.md'):
    for line in open(fp, encoding='utf-8', errors='replace'):
        as_ = set(name_re.findall(line.upper()))
        tb = set(re.findall(r'\b(PKG_S[CS]P\w+)\.(P_\w+)', line))
        if as_ and len(tb) == 1:
            pk, pr = tb.pop()
            for a in as_:
                ev[a][f'{pk}.{pr.upper()}'].add('M5_fe_mapping')

# M3 단독 언급은 호출(EXEC 대체) 일 수 있으므로 약한 근거 — 최종 선택: M1 > M2 > M4 > M5 > M3
rank = {'M9_manual_override': 9, 'M6_screen_pkg_stripped': 5, 'M0_standalone_exact': 7, 'M2_exact': 6, 'M4_abbr_norm': 5, 'M1_program_id': 4, 'M5_fe_mapping': 2, 'M3_mention': 1}
rows = []
stat = collections.Counter()
for a in sorted(asis_names):
    cands = ev.get(a, {})
    if not cands:
        rows.append([a, '', '', '', 'TO-BE 미개발(매핑 근거 없음)']); stat['none'] += 1; continue
    scored = sorted(cands.items(), key=lambda kv: (-max(rank[e] for e in kv[1]), kv[0]))
    best = max(rank[e] for e in scored[0][1])
    top = [t for t, e in scored if max(rank[x] for x in e) == best]
    alt = [t for t, e in scored if max(rank[x] for x in e) < best]
    rows.append([a, ' | '.join(top), ','.join(sorted(scored[0][1])), ' | '.join(alt[:6]), 'strong' if best >= 3 else 'weak'])
    stat['strong' if best >= 3 else 'weak'] += 1
with open(os.path.join(BASE, 'map.csv'), 'w', encoding='utf-8-sig', newline='') as f:
    w = csv.writer(f); w.writerow(['asis_sp', 'tobe_targets', 'evidence', 'weak_alternatives', 'confidence']); w.writerows(rows)
print(stat, 'blocks', len(blocks))
