# -*- coding: utf-8 -*-
"""SCP / SSP DB VALIDATION 취합 산출물 생성 (도메인별 xlsx + md 분리)
입력: units.csv, ui_sp_chain.csv, ui_sp_direct.csv, excluded.csv, commented_calls.csv, out/b*.jsonl,
      map.csv, cmp_out/c*.jsonl(있으면), tobe/_env.txt
출력: <OUTDIR>/{SCP,SSP}_DB_VALIDATION_취합_20261022.{xlsx,md}
"""
import os, re, csv, json, glob, collections, sys, datetime
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment
from openpyxl.utils import get_column_letter

B = os.path.dirname(os.path.abspath(__file__))
OUTDIR = sys.argv[1] if len(sys.argv) > 1 else os.path.join(B, 'report')
os.makedirs(OUTDIR, exist_ok=True)
DATE = '20261022'

def rd(p):
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))

units = {r['unit']: r for r in rd(os.path.join(B, 'units.csv'))}
chain = rd(os.path.join(B, 'ui_sp_chain.csv'))
direct = rd(os.path.join(B, 'ui_sp_direct.csv'))
excluded = rd(os.path.join(B, 'excluded.csv'))
commented = rd(os.path.join(B, 'commented_calls.csv'))
mp = {r['asis_sp']: r for r in rd(os.path.join(B, 'map.csv'))}
tobe_env = open(os.path.join(B, 'tobe', '_env.txt'), encoding='utf-8').read().strip()

# ---- AS-IS 판독 결과
vrows, summ = [], {}
for f in sorted(glob.glob(os.path.join(B, 'out', 'b*.jsonl'))):
    if re.search(r'\.p\d', f):
        continue
    bid = os.path.basename(f)[:-6]
    for l in open(f, encoding='utf-8'):
        if not l.strip():
            continue
        r = json.loads(l)
        r['_batch'] = bid
        if r.get('_summary'):
            summ[r['unit']] = r
        else:
            vrows.append(r)
# b01 은 파일럿(기준 추가 전) — 단순 NULLIF 빈값정규화 행은 추가 기준에 따라 제외 처리
drop_pilot = []
keep = []
for r in vrows:
    if r['_batch'] == 'b01' and r.get('class') == 'B' and 'NULLIF' in str(r.get('condition', '')).upper() and 'NULL' in str(r.get('on_fail', '')).upper():
        drop_pilot.append(r)
    else:
        keep.append(r)
vrows = keep
# idx 는 build_compare 와 동일 규칙(asis_rows_indexed.json) 사용
idxmap = {}
p_idx = os.path.join(B, 'asis_rows_indexed.json')
if os.path.exists(p_idx):
    for u, rs in json.load(open(p_idx, encoding='utf-8')).items():
        for r in rs:
            idxmap[(u, r.get('line_from'), r.get('line_to'), r.get('check_type'), r.get('condition'))] = r['idx']
for r in vrows:
    r['idx'] = idxmap.get((r['unit'], r.get('line_from'), r.get('line_to'), r.get('check_type'), r.get('condition')), '')

# ---- 비교 결과 (유효 쌍만: c01~c10 중 재사용 쌍 + n## 신규 쌍)
pf = json.load(open(os.path.join(B, 'pairs_final.json'), encoding='utf-8'))
valid_c = {(a, t): b for a, t, s, b in pf['valid_from_c01_c10']}
valid_n = {(a, t): b for a, t, s, b in pf['new_pairs']}
cmp_rows, cmp_summ = [], []
for f in sorted(glob.glob(os.path.join(B, 'cmp_out', '*.jsonl'))):
    bid = os.path.basename(f)[:-6]
    for l in open(f, encoding='utf-8'):
        if not l.strip():
            continue
        r = json.loads(l)
        k = (r.get('asis_sp'), r.get('tobe'))
        if valid_c.get(k) == bid or valid_n.get(k) == bid or bid.startswith('x'):
            r['_cbatch'] = bid
            (cmp_summ if r.get('_summary') else cmp_rows).append(r)
pairs_done = {(s['asis_sp'], s['tobe']) for s in cmp_summ}
pairs_all = set(valid_c) | set(valid_n)

# ---- 보충: 비교 판독에서 확인된 AS-IS 추출누락 → AS-IS 행으로 추가
supp_cmp = 0
for c in cmp_rows:
    if c.get('verdict') == 'AS-IS 추출누락':
        vrows.append(dict(unit=c['asis_sp'], kind='SP', line_from=c.get('asis_line_from'), line_to=c.get('asis_line_to'),
                          **{'class': c.get('class')}, check_type=c.get('check_type', 'OTHER'), target=c.get('target', ''),
                          condition=c.get('asis_evidence', ''), on_fail='', message='', division='전체', reach='실행',
                          desc_ko=c.get('desc_ko', ''), note=f"[비교판독 보충 {c['_cbatch']}] TO-BE {c.get('tobe')} L{c.get('tobe_line_from')} 대응 · {c.get('diff','')}",
                          _batch='cmp', idx=f"S{c['_cbatch']}-{c.get('tobe_line_from')}",
                          _cmp=dict(tobe=c.get('tobe'), loc=f"{c.get('tobe_file','')} L{c.get('tobe_line_from','')}-{c.get('tobe_line_to','')}",
                                    ev=c.get('tobe_evidence', ''), diff=c.get('diff', ''))))
        supp_cmp += 1

# ---- 표본 검수(qa_out) 반영
qa = []
for f in sorted(glob.glob(os.path.join(B, 'qa_out', 'q*.jsonl'))):
    for l in open(f, encoding='utf-8'):
        if l.strip():
            qa.append(json.loads(l))
qa_drop, qa_supp = [], 0
qa_key = {}
for q in qa:
    if q.get('verdict') == 'NG':
        qa_key[(q.get('unit'), str(q.get('line_from')))] = q
    for m in q.get('missed_rows') or []:
        m = dict(m); m.setdefault('unit', q.get('unit')); m['reach'] = m.get('reach') or '실행'
        m['note'] = f"[표본검수 보충] {m.get('note','')}"; m['_batch'] = 'qa'; m['idx'] = ''
        vrows.append(m); qa_supp += 1
keep = []
for r in vrows:
    q = qa_key.get((r['unit'], str(r.get('line_from'))))
    if q and 'class' in (q.get('ng_fields') or []) and re.search(r'아님|대상이 아닌|과다|정규화|스위치|계산 로직', q.get('detail', '')):
        qa_drop.append((r, q)); continue
    if q:
        r['note'] = f"{r.get('note','')} [표본검수 보정: {', '.join(q.get('ng_fields') or [])}] {q.get('detail','')}"[:1500]
    keep.append(r)
vrows = keep

# ---- 기준 통일 재판정(R1) · 미도달 재검증(R2) 반영
RULE = {'1': '계산 방어식', '2': '화면 표시 설정 기본값', '3': 'UI 편집 경계값 전달', '4': '일반 범위·조인'}
rv1, rv2 = {}, {}
for fn in ('r1a_out.jsonl', 'r1b_out.jsonl'):
    p = os.path.join(B, 'rv', fn)
    if os.path.exists(p):
        for l in open(p, encoding='utf-8'):
            if l.strip():
                x = json.loads(l); rv1[(x.get('_batch'), x.get('unit'), str(x.get('line_from')))] = x
p = os.path.join(B, 'rv', 'r2_out.jsonl')
if os.path.exists(p):
    for l in open(p, encoding='utf-8'):
        if l.strip():
            x = json.loads(l); rv2[(x.get('_batch'), x.get('unit'), str(x.get('line_from')))] = x
rv_drop, rv_cls, rv_flip = [], 0, 0
keep = []
for r in vrows:
    k = (r.get('_batch'), r['unit'], str(r.get('line_from')))
    x = rv1.get(k)
    if x and x.get('decision') == 'drop':
        rv_drop.append((r, x)); continue
    if x and x.get('new_class') and x['new_class'] != r.get('class'):
        r['note'] = f"{r.get('note','')} [기준통일 class {r.get('class')}→{x['new_class']}]"; r['class'] = x['new_class']; rv_cls += 1
    y = rv2.get(k)
    if y and y.get('decision') == 'flip' and r.get('reach') == '미도달':
        r['reach'] = '실행'; r['note'] = f"{r.get('note','')} [미도달 재검증 → 실행: {y.get('reason','')}]"[:1500]; rv_flip += 1
    keep.append(r)
vrows = keep

# ---- ⭐ 실행 코드만 취합 (사용자 지시 2026-10-22): 주석 = 전면 제외(목록 미기재) / 미도달 = 취합 제외, 8_제외근거에 사유만
n_comment = sum(1 for r in vrows if r.get('reach') == '주석')
unreach = [r for r in vrows if r.get('reach') == '미도달']
vrows = [r for r in vrows if r.get('reach') not in ('주석', '미도달')]
cmp_rows = [c for c in cmp_rows if c.get('verdict') != '해당없음']
# 매핑오류 중 비교판독이 "전환본 없음"(호출부 주석·본체 부재)을 확인한 쌍 → TO-BE 미개발
summ_note = {(s.get('asis_sp'), s.get('tobe')): (s.get('map_note') or '') for s in cmp_summ}
remap_needed = []
for c in cmp_rows:
    if c.get('verdict') == '매핑오류':
        mn = summ_note.get((c.get('asis_sp'), c.get('tobe')), '')
        if re.search(r'전환본 없음|전환본이 없|전환본은 .*없|올바른 대상(은|이)? 없|미존재|어디에도 없|존재하지 않|전환본이 아님', mn + ' ' + (c.get('diff') or '')):
            c['verdict'] = 'TO-BE 미개발(전환본 없음)'
            c['diff'] = f"매핑 후보({c.get('tobe')})는 전환본 아님 — {mn}"[:1500]
            c['tobe'] = ''
        else:
            remap_needed.append(c)

# ---- 항목 ID (정규화): check_type + 대상 객체(테이블/변수) + 컬럼
def obj_key(t):
    t = str(t or '').upper().replace('#', '').replace('@', 'P:')
    m = re.search(r'\b(P:)?([A-Z][A-Z0-9_]{2,})(?:\.([A-Z0-9_]+))?', t)
    if not m:
        return None
    o = (m.group(1) or '') + m.group(2)
    o = re.sub(r'_(SN|V|H)$', '', o) if not o.startswith('P:') else o
    return o + ('.' + m.group(3) if m.group(3) else '')
items = {}
for r in vrows:
    ok = obj_key(r.get('target'))
    key = f"{r.get('check_type','OTHER')}|{ok}" if ok else f"{r.get('check_type','OTHER')}|@{r['unit']}"
    r['_item_key'] = key
    items.setdefault(key, []).append(r)
item_id = {k: f"V{i:04d}" for i, k in enumerate(sorted(items), 1)}
for r in vrows:
    r['item_id'] = item_id[r['_item_key']]

by_unit = collections.defaultdict(list)
for r in vrows:
    by_unit[r['unit']].append(r)

unit_screens = collections.defaultdict(set)
for c in chain:
    unit_screens[c['unit']].add(c['screen'])

# ---- TO-BE 미이관 (실행 코드의 P_RAISE_NOT_MIGRATED('<AS-IS명>'))
not_migrated = {}
for fp in glob.glob(os.path.join(B, 'tobe', 'src', '*.sql')):
    for i, line in enumerate(open(fp, encoding='utf-8'), 1):
        code = line.split('--', 1)[0]
        for m in re.finditer(r"P_RAISE_NOT_MIGRATED\s*\(\s*'([A-Z0-9_]+)'", code, re.I):
            not_migrated.setdefault(m.group(1).upper(), f"{os.path.basename(fp)} L{i}")
cmp_by_idx = collections.defaultdict(list)
for r in cmp_rows:
    if r.get('asis_idx') not in (None, ''):
        cmp_by_idx[int(r['asis_idx'])].append(r)

# ---- oracle_migration.md Cross-check 원천
def mig_sps(dom):
    res = collections.defaultdict(set)
    for fp in glob.glob(rf'C:/Projects/NSCM/Doc/_analysis/domain_{dom}/screens/*/oracle_migration.md'):
        folder = os.path.basename(os.path.dirname(fp))
        if 'Backup' in folder or 'backup' in folder:
            continue
        sid = folder[:7]
        for line in open(fp, encoding='utf-8', errors='replace'):
            m = re.match(r'\|\s*\d+\s*\|\s*`([\w]+)`', line)
            if m:
                res[sid].add(m.group(1).upper())
    return res

HDR_FILL = PatternFill('solid', fgColor='1F4E78')
def sheet(wb, title, cols, rows, widths=None):
    ws = wb.create_sheet(title)
    ws.append(cols)
    for c in ws[1]:
        c.font = Font(bold=True, color='FFFFFF'); c.fill = HDR_FILL; c.alignment = Alignment(wrap_text=True, vertical='center')
    for r in rows:
        ws.append([('' if v is None else (v if isinstance(v, (int, float)) else str(v)[:32000])) for v in r])
    ws.freeze_panes = 'A2'
    ws.auto_filter.ref = f"A1:{get_column_letter(len(cols))}{max(1, len(rows) + 1)}"
    for i, w in enumerate(widths or [], 1):
        ws.column_dimensions[get_column_letter(i)].width = w
    return ws

CLS = {'A': 'A 차단형', 'B': 'B 보정형', 'C': 'C 필터형', 'D': 'D 검증리포트형'}

def build(dom):
    other = 'SSP' if dom == 'SCP' else 'SCP'
    screens = sorted({c['screen'] for c in chain if c['screen'].startswith(dom)} |
                     {s for s in os.listdir(r'C:/Projects/NSCM/Doc/asisfacts/screens') if s.startswith(dom) and re.match(r'^(SCP|SSP)\d', s)})
    sset = set(screens)
    dchain = [c for c in chain if c['screen'] in sset]
    dunits = sorted({c['unit'] for c in dchain})
    # 화면별 단위 (진입 SP·최소 depth)
    su = collections.defaultdict(lambda: {'roots': set(), 'depth': 99, 'parents': set()})
    for c in dchain:
        k = (c['screen'], c['unit'])
        su[k]['roots'].add(c['root']); su[k]['depth'] = min(su[k]['depth'], int(c['depth']))
        if c['parent']:
            su[k]['parents'].add(c['parent'])
    dir_member = collections.defaultdict(set)
    for d in direct:
        if d['screen'] in sset:
            dir_member[(d['screen'], d['unit'])].add(f"{d['member']}:L{d['line']}({d['pattern']})")

    wb = Workbook(); wb.remove(wb.active)
    # 2 UI별 목록
    ui_rows = []
    for s in screens:
        us = sorted([u for (sc, u) in su if sc == s], key=lambda u: (su[(s, u)]['depth'], u))
        if not us:
            ui_rows.append([s, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 'DB 호출 없음(endpoints/literals/동적호출 해석 결과 0건)'])
        for u in us:
            info = su[(s, u)]
            base = [s, ' / '.join(sorted(info['roots']))[:500], info['depth'], u, ' / '.join(sorted(dir_member.get((s, u), [])))[:300]]
            rs = by_unit.get(u, [])
            if not rs:
                sm = summ.get(u, {})
                why = sm.get('no_validation_reason') or ('원문 없음' if units.get(u, {}).get('source_exists') == 'N' else '')
                ui_rows.append(base + ['', '', '', '', '', '', '', '', '', '', '', '', f'검증 없음 — {why}'])
                continue
            for r in sorted(rs, key=lambda x: (int(x.get('line_from') or 0))):
                ui_rows.append(base + [r['item_id'], CLS.get(r.get('class'), r.get('class')), r.get('check_type'), r.get('target'),
                                       f"L{r.get('line_from')}-{r.get('line_to')}", r.get('condition'), r.get('on_fail'), r.get('message'),
                                       r.get('division'), r.get('reach'), r.get('desc_ko'), r.get('note')])
    cols2 = ['UI', '진입 SP(화면 직접 호출)', '호출 깊이(0=직접)', 'SP/단위', 'C# 호출 위치(멤버:라인·근거패턴)', '항목ID', '분류', '검증유형', '대상',
             'AS-IS 라인', '조건(원문)', '실패 시 처리(원문)', '메시지', '사업부', '도달성', '설명', '비고']
    # 3 항목별 취합
    item_rows = []
    dom_items = collections.defaultdict(list)
    for u in dunits:
        for r in by_unit.get(u, []):
            dom_items[r['item_id']].append(r)
    for iid in sorted(dom_items):
        rs = dom_items[iid]
        sps = sorted({r['unit'] for r in rs})
        uis = sorted({s for sp in sps for s in unit_screens[sp] if s in sset})
        oth = sorted({s for sp in sps for s in unit_screens[sp] if s.startswith(other)})
        k = rs[0]['_item_key']
        descs = collections.Counter(r.get('desc_ko', '') for r in rs)
        item_rows.append([iid, k.split('|')[0], k.split('|')[1].lstrip('@'), ', '.join(sorted({CLS.get(r.get('class'), '') for r in rs})),
                          descs.most_common(1)[0][0], len(rs), len(sps), ' / '.join(sps), len(uis), ', '.join(uis),
                          'Y' if len(uis) >= 2 else 'N', ', '.join(oth),
                          ', '.join(sorted({r.get('reach', '') for r in rs})),
                          ' | '.join(sorted({d for d in (r.get('desc_ko', '') for r in rs) if d})[:8])[:2000]])
    item_rows.sort(key=lambda x: (-x[8], x[0]))
    cols3 = ['항목ID', '검증유형', '대상 객체(정규화)', '분류', '대표 설명', '검증 행 수', 'SP 수', 'SP 목록', f'사용 UI 수({dom})', f'사용 UI({dom})',
             '공통(2개 UI 이상)', f'타 도메인({other}) 사용 UI', '도달성', '설명 변형(최대 8)']
    # 4 AS-IS ↔ TO-BE 비교
    cmp4 = []
    for s in screens:
        for u in sorted([u for (sc, u) in su if sc == s]):
            m = mp.get(u, {})
            tgt = m.get('tobe_targets', '')
            for r in by_unit.get(u, []):
                cs = cmp_by_idx.get(r['idx'], []) if r['idx'] != '' else []
                cs = [c for c in cs if (not c.get('tobe') or c['tobe'].upper().startswith(f'PKG_{s}.') or not any(x.get('tobe', '').upper().startswith(f'PKG_{s}.') for x in cs))]
                if r.get('_cmp'):
                    d = r['_cmp']; dd = d.get('diff') or ''
                    vv = ('일치' if re.search(r'이관(은| 자체는| 판정은)?\s*.?일치|실질(은|적으로)? 일치', dd)
                          else '차이' if re.search(r'차이|다름|빠졌|누락|없습니다|없음', dd) else '일치')
                    cmp4.append([s, u, r['item_id'], CLS.get(r.get('class')), r.get('check_type'), r.get('desc_ko'), r.get('reach'), d.get('tobe'),
                                 f'{vv}(AS-IS 추출누락 보충)', d.get('loc'), d.get('ev'), dd])
                    continue
                if u.upper() in not_migrated:
                    cmp4.append([s, u, r['item_id'], CLS.get(r.get('class')), r.get('check_type'), r.get('desc_ko'), r.get('reach'), '', 'TO-BE 미이관', not_migrated[u.upper()], "P_RAISE_NOT_MIGRATED 로 대체(호출 시 -20001)", ''])
                    continue
                if not tgt:
                    cmp4.append([s, u, r['item_id'], CLS.get(r.get('class')), r.get('check_type'), r.get('desc_ko'), r.get('reach'), '', 'TO-BE 미개발(매핑 대상 없음)', '', '', ''])
                elif not cs:
                    cmp4.append([s, u, r['item_id'], CLS.get(r.get('class')), r.get('check_type'), r.get('desc_ko'), r.get('reach'), tgt, '비교 미실시', '', '', ''])
                for c in cs:
                    cmp4.append([s, u, r['item_id'], CLS.get(r.get('class')), r.get('check_type'), r.get('desc_ko'), r.get('reach'), c.get('tobe'), c.get('verdict'),
                                 f"{c.get('tobe_file','')} L{c.get('tobe_line_from','')}-{c.get('tobe_line_to','')}", c.get('tobe_evidence'), c.get('diff')])
            for c in cmp_rows:
                if c.get('asis_sp') == u and c.get('verdict') == 'TO-BE 추가' and (c.get('tobe', '').upper().startswith(f'PKG_{s}.') or True):
                    cmp4.append([s, u, '', CLS.get(c.get('class')), c.get('check_type'), c.get('desc_ko'), '', c.get('tobe'), 'TO-BE 추가',
                                 f"{c.get('tobe_file','')} L{c.get('tobe_line_from','')}-{c.get('tobe_line_to','')}", c.get('tobe_evidence'), ''])
    cols4 = ['UI', 'AS-IS SP', '항목ID', '분류', '검증유형', 'AS-IS 검증 설명', 'AS-IS 도달성', 'TO-BE 대상(PKG.PROC)', '판정', 'TO-BE 위치', 'TO-BE 원문 발췌', '차이·누락 설명']
    # 5 SP 호출 체인
    ch5 = [[c['screen'], c['root'], c['depth'], c['via'], c['parent'], c['unit'], units.get(c['unit'], {}).get('source_exists', ''),
            units.get(c['unit'], {}).get('lines', ''), len(by_unit.get(c['unit'], [])), mp.get(c['unit'], {}).get('tobe_targets', ''),
            mp.get(c['unit'], {}).get('wired', '')] for c in dchain]
    cols5 = ['UI', '진입 SP', '깊이', '호출종류', '상위 SP', 'SP/단위', '원문 존재', '줄수', '검증 행 수', 'TO-BE 대상', 'TO-BE API_M 배선']
    # 6 Cross-check (oracle_migration.md 호출 SP ↔ 본 인벤토리 직접 호출)
    mig = mig_sps(dom)
    dset = collections.defaultdict(set)
    for d in direct:
        if d['screen'] in sset and d['unit_kind'] == 'SP':
            dset[d['screen']].add(d['unit'].upper())
    cc = []
    for s in sorted(set(mig) | set(dset)):
        if s not in sset:
            continue
        a, b = mig.get(s, set()), dset.get(s, set())
        for x in sorted(a - b):
            cc.append([s, x, '분석서에만 있음', 'Y' if x in units else 'N', '체인(하위 EXEC)에 포함' if any(c['unit'] == x and c['screen'] == s for c in dchain) else '본 인벤토리 미포함 — 분석서 원천(_legacy_source) 차이'])
        for x in sorted(b - a):
            cc.append([s, x, '본 인벤토리에만 있음', 'Y', '분석서 미수록(분석서는 endpoint 직접 매칭만, 리터럴/동적/POPUP 미포함)'])
        if a == b and a:
            cc.append([s, f'{len(a)}건', '일치', '', ''])
    cols6 = ['UI', 'SP', '차이', '판독 대상 포함', '사유']
    # 7 검증 없음 SP
    nv = [[u, units.get(u, {}).get('obj_type', ''), units.get(u, {}).get('lines', ''), summ.get(u, {}).get('no_validation_reason', ''),
           summ.get(u, {}).get('purpose', ''), ', '.join(sorted(s for s in unit_screens[u] if s in sset))]
          for u in dunits if not by_unit.get(u)]
    cols7 = ['SP/단위', '유형', '줄수', '검증 없음 사유', 'SP 목적', '사용 UI']
    # 8 제외·미도달 근거
    ex8 = [[e['screen'], e['key'], e['member'], e['line'], e['reason']] for e in excluded if e['screen'] in sset]
    ex8 += [['', u, '', '', '원문 없음(AS-IS DEV 덤프 미존재 — 타 DB/시스템 SP 또는 폐기)'] for u in dunits if units.get(u, {}).get('source_exists') == 'N']
    ex8 += [['', r['unit'], '', f"L{r.get('line_from')}", f"파일럿(b01) 단순 빈값→NULL 정규화 — 판독 기준 추가(NULLIF 제외)에 따라 제외: {r.get('condition','')[:120]}"] for r in drop_pilot if r['unit'] in dunits]
    ex8 += [[', '.join(sorted(s for s in unit_screens[r['unit']] if s in sset))[:200], r['unit'], '', f"L{r.get('line_from')}", f"미도달(실행되지 않는 코드) — 취합 제외: {r.get('desc_ko','')} / 근거: {r.get('note','')}"[:600]]
            for r in unreach if r['unit'] in dunits]
    ex8 += [[', '.join(sorted(s for s in unit_screens[r['unit']] if s in sset))[:200], r['unit'], '', f"L{r.get('line_from')}", f"표본검수 결과 검증 아님으로 제외: {q.get('detail','')}"[:600]]
            for r, q in qa_drop if r['unit'] in dunits]
    ex8 += [[', '.join(sorted(s for s in unit_screens[r['unit']] if s in sset))[:200], r['unit'], '', f"L{r.get('line_from')}", f"기준 통일 재판정 — 검증 아님({RULE.get(str(x.get('rule')), x.get('rule'))}): {r.get('desc_ko','')} / {x.get('reason','')}"[:600]]
            for r, x in rv_drop if r['unit'] in dunits]
    cols8 = ['UI', '대상', '멤버', '라인', '사유']
    # 9 SP 요약
    s9 = [[u, units.get(u, {}).get('kind', ''), units.get(u, {}).get('lines', ''), summ.get(u, {}).get('lines_read', ''), len(by_unit.get(u, [])),
           summ.get(u, {}).get('purpose', ''), summ.get(u, {}).get('returns_to_ui', ''), summ.get(u, {}).get('exec_calls', ''),
           summ.get(u, {}).get('read_note', ''), summ.get(u, {}).get('_batch', '')] for u in dunits]
    cols9 = ['SP/단위', '종류', '원문 줄수', '판독 줄수', '검증 행 수', '목적', 'UI 반환 방식', '하위 호출(가드)', '판독 비고', '배치']
    # 1 요약
    cnt = collections.Counter(); reach = collections.Counter(); verd = collections.Counter()
    per_ui = []
    for s in screens:
        us = [u for (sc, u) in su if sc == s]
        rs = [r for u in us for r in by_unit.get(u, [])]
        c = collections.Counter(r.get('class') for r in rs)
        rc = collections.Counter(r.get('reach') for r in rs)
        dir_rs = [r for u in us if su[(s, u)]['depth'] == 0 for r in by_unit.get(u, [])]
        per_ui.append([s, len(us), sum(1 for u in us if su[(s, u)]['depth'] == 0), len(rs), len(dir_rs), c['A'], c['B'], c['C'], c['D'], rc['실행'], rc['미도달'], rc['주석']])
    for u in dunits:
        for r in by_unit.get(u, []):
            cnt[r.get('class')] += 1; reach[r.get('reach')] += 1
    for row in cmp4:
        verd[row[8]] += 1
    s1 = [['UI 수', len(screens)], ['DB 호출 있는 UI', sum(1 for p in per_ui if p[1])], ['판독 SP/단위 수', len(dunits)],
          ['원문 없음 단위', sum(1 for u in dunits if units.get(u, {}).get('source_exists') == 'N')],
          ['검증 행(고유, SP 기준)', sum(len(by_unit.get(u, [])) for u in dunits)], ['항목ID 수', len(dom_items)],
          ['공통 항목(2개 UI 이상)', sum(1 for r in item_rows if r[10] == 'Y')]]
    s1 += [[f'분류 {k}', v] for k, v in sorted(cnt.items())] + [[f'도달성 {k}', v] for k, v in sorted(reach.items())] + [[f'비교 판정 {k}', v] for k, v in sorted(verd.items())]
    # 0 기준
    s0 = [
        ['산출물', f'{dom} 화면 DB(SP/PKG) VALIDATION 취합 — AS-IS 기준 + TO-BE 비교'],
        ['작성일', '2026-10-22'],
        ['AS-IS 원천', 'Doc/asisfacts/db/modules (MSSQL 165.244.95.223 LGCE_SCMDEV, sys.sql_modules 덤프 2026-10-16 13:43 — 사용자 결정으로 재덤프 없이 사용). 라인번호 = 덤프 파일 기준'],
        ['화면→SP 원천', 'Doc/asisfacts/screens/<ID>/endpoints.csv·flow.csv(P1) + UNRESOLVED dbo.명(P2) + NOT_IN_FOXQUERY 키(P3) + 화면 .cs 문자열 리터럴의 FoxQuery 키(P4, queryId 변수 대입 등) + SCP0039 그리드 PROCEDURE_NAME 동적호출(P5) → db_module_refs.csv EXEC/FUNC BFS'],
        ['TO-BE 기준시점', '⭐ 2026-10-22 16:25 스냅샷 고정(사용자 결정). 이후 사내 DB 에서 변경·신규 생성된 객체(AS-IS 동명 standalone 22종 신규 등)는 10_기준시점이후변경 시트에 영향 SP·UI 와 함께 표기 — 해당 판정은 재비교 필요'],
        ['TO-BE 원천', f'사내 Oracle {tobe_env} — PKG_SCP%/PKG_SSP% 86종 + 의존 객체 BFS + AS-IS 동명 standalone(ALL_SOURCE 당일 재조회). 배선 = SCM_ADM_API_M ⋈ SCM_ADM_MNU_BTN_MPG_M 당일 조회'],
        ['AS-IS→TO-BE 매핑', 'M1 TO-BE 헤더 Program ID / V_PROGRAM_NAME := AS-IS명 · M2 정확명 · M4 축약정규화명 · M5 FE __asis-mapping__.md · M3 블록 내 언급(약한 근거). 화면 동일 번호 PKG 사본 우선 → API 배선 대상 우선'],
        ['분류 A', '차단형: 조건 불충족 시 실패코드/메시지 반환·RAISERROR/THROW·RETURN·ROLLBACK (CATCH 일반 예외는 SP당 1행 EXCEPTION)'],
        ['분류 B', '보정형: 조건 판정 후 값 대체/자동 보정하고 계속 (채번은 [채번] 표기, 단순 NULLIF 빈값정규화 제외)'],
        ['분류 C', '필터형: 검증 목적으로 불충족 행을 조용히 제외/삭제 (GET 일반 검색조건 제외)'],
        ['분류 D', '검증리포트형: 오류/미등록 목록·건수·검증용 플래그를 계산해 반환 ([조회표시])'],
        ['수록 범위', f'⭐ 실제 실행 코드만 수록(사용자 지시 2026-10-22). 주석 처리된 검증은 전면 제외(미기재, 판독 시 {n_comment}건 식별). 미도달(항상 거짓·호출 파라미터로 차단·고정값) 판정분은 취합에서 제외하고 8_제외근거에 사유만 기재'],
        ['기준 통일', f'배치 간 분류 차이 정리(재판정 {len(rv1)}행): 계산 방어식·화면 표시 설정 기본값·UI 편집 경계값 전달·일반 범위/조인은 검증 아님 → 제외 {len(rv_drop)}건(8_제외근거), class 정정 {rv_cls}건 / 미도달 재검증 {len(rv2)}행(호출처 전수) → 실행 정정 {rv_flip}건'],
        ['보정 이력', f'표본검수(배치당 검증 5건+0건 단위 2건, 원문 재대조) 결과 반영: 검증아님 제외 {len(qa_drop)}건 · 누락 보충 {qa_supp}건 / 비교판독 중 AS-IS 추출누락 보충 {supp_cmp}건'],
        ['항목ID', '검증유형 + 대상 객체(대상 컬럼의 첫 테이블/변수명, _SN/_V/_H 접미 정규화, 컬럼 포함) 기준 기계 묶음. 대상 객체가 없으면 SP 단위로 별도 항목'],
        ['추출 한계 1', '판독은 SP 본문 전량 Read(56 배치·병렬 판독, 각 배치 단위 전원 summary·줄수 일치 기계 점검) — 단 판정(분류·도달성)은 판독자 판단이며, 배치 간 경계 사례(업무 범위 필터 vs C, 계산 보정 vs B) 기준 차이가 남을 수 있음(각 행 note 참조)'],
        ['추출 한계 2', '반복 검사 표기 단위가 배치마다 다름 — 일부는 위치마다 1행, 일부는 대표 1행 + note 에 라인 나열. 건수는 "검증 행" 기준이며 고유 규칙 수와 다를 수 있음'],
        ['추출 한계 3', '항목ID 묶음은 대상 객체명 기반 기계 정규화 — 같은 의미라도 대상 표기가 다르면 다른 항목, 같은 테이블의 다른 의미 검증이 한 항목에 묶일 수 있음(설명 변형 컬럼 참조)'],
        ['추출 한계 4', '원문 없음 단위(덤프 미존재: 타 DB ENG_SCP·시스템 SP·폐기 SP)는 판독 불가 — 8_제외근거 시트'],
        ['추출 한계 5', 'AS-IS 덤프는 DEV(2026-10-16) — 운영 원문과 다를 수 있음(판독 중 DEV 전용 임시 로직 발견 사례 note 기재)'],
        ['추출 한계 6', 'BIZ CommonData 공통 콤보(FP_Common.UI_FP_COMMON)·update-batch 는 검증 아님으로 제외(8_제외근거). FE/C# 측 검증(validation.md)은 범위 밖'],
        ['추출 한계 7', f"TO-BE 비교 판독 중 대형 블록 일부를 반복 컬럼 나열(QTY001~364 등) 접기·키워드 필터로 확인한 쌍 {sum(1 for x in cmp_summ if str(x.get('tobe_lines_read','')).isdigit() and str(x.get('tobe_lines_total','')).isdigit() and int(x['tobe_lines_read']) < int(x['tobe_lines_total']))}개 / 전체 {len(cmp_summ)}개 (판정 근거는 각 쌍 read_note) · 표본검수 350건 정확도 약 91%(NG 대부분 과다기록 → 기준 통일 재판정으로 정리) · 사업부(division) 컬럼은 판독자 표기(일부 SP 명 접미 기준)"],
        ['도메인 분리', f'화면 ID 접두 {dom} 기준. 양 도메인 공용 SP 는 두 파일 모두 수록, 3_항목별취합의 "타 도메인({other}) 사용 UI" 컬럼으로 표시'],
    ]
    # 10 기준시점(16:25) 이후 변경 객체 — 재비교 필요 (사용자 결정: 스냅샷 고정)
    chg = rd(os.path.join(B, 'tobe', 'changed_after_snapshot.csv'))
    c10 = []
    for c in chg:
        o = c['object']
        aff = sorted({u for u in dunits if u == o or any(t.split('.')[0] == o for t in mp.get(u, {}).get('tobe_targets', '').split(' | ') if t)})
        uis = sorted({s for u in aff for s in unit_screens[u] if s in sset})
        if aff or o.upper() in units:
            c10.append([o, c['type'], c['status'], c['created'], c['last_ddl'], 'AS-IS 동명 신규 생성' if c['created'] > '2026-10-22 16:25' else '본문 수정',
                        ' / '.join(aff)[:2000], ', '.join(uis), '이 산출물의 비교 판정은 16:25 스냅샷 기준 — 해당 SP 의 TO-BE 판정(미개발·전환본 없음·차이 등)은 재비교 필요'])
    cols10 = ['TO-BE 객체', '유형', '상태', '생성', '최종 DDL', '구분', '영향 AS-IS SP', f'영향 UI({dom})', '비고']
    sheet(wb, '0_기준', ['항목', '내용'], s0, [18, 160])
    ws1 = sheet(wb, '1_요약', ['지표', '값'], s1, [30, 14])
    sheet(wb, '1b_UI별건수', ['UI', '판독 단위 수', '직접 호출 SP 수', '검증 행(체인 전체)', '검증 행(직접 호출 SP)', 'A', 'B', 'C', 'D', '실행', '미도달', '주석'], per_ui)
    sheet(wb, '2_UI별목록', cols2, ui_rows, [9, 40, 8, 40, 30, 8, 12, 12, 30, 12, 60, 50, 30, 8, 8, 50, 50])
    sheet(wb, '3_항목별취합', cols3, item_rows, [8, 12, 40, 20, 50, 8, 6, 60, 8, 50, 8, 30, 12, 80])
    sheet(wb, '4_ASIS_TOBE비교', cols4, cmp4, [9, 40, 8, 12, 12, 50, 8, 45, 14, 30, 60, 60])
    sheet(wb, '5_SP호출체인', cols5, ch5)
    sheet(wb, '6_CrossCheck', cols6, cc, [9, 45, 18, 8, 60])
    sheet(wb, '7_검증없음SP', cols7, nv, [45, 8, 8, 50, 50, 40])
    sheet(wb, '8_제외근거', cols8, ex8, [20, 45, 20, 8, 90])
    sheet(wb, '9_SP요약', cols9, s9, [45, 6, 8, 8, 8, 50, 50, 60, 40, 6])
    sheet(wb, '10_기준시점이후변경', cols10, c10, [40, 12, 8, 16, 16, 16, 60, 40, 60])
    xp = os.path.join(OUTDIR, f'{dom}_DB_VALIDATION_취합_{DATE}.xlsx')
    wb.save(xp)
    # md 요약
    md = [f'# {dom} 화면 DB(SP/PKG) VALIDATION 취합 — AS-IS 기준 + TO-BE 비교 ({DATE})', '',
          f'상세 = `{os.path.basename(xp)}` (시트 0~10). 원천·분류 정의·추출 한계 = 0_기준 시트.', '', '## 1. 요약', '', '| 지표 | 값 |', '|---|---:|']
    md += [f'| {a} | {b} |' for a, b in s1]
    md += ['', '## 2. UI별 검증 건수 (상위 30, 체인 전체 기준)', '', '| UI | 판독 단위 | 직접 SP | 검증 행 | A | B | C | D |', '|---|---:|---:|---:|---:|---:|---:|---:|']
    md += [f'| {p[0]} | {p[1]} | {p[2]} | {p[3]} | {p[5]} | {p[6]} | {p[7]} | {p[8]} |' for p in sorted(per_ui, key=lambda x: -x[3])[:30]]
    md += ['', '## 3. 공통 항목 (2개 UI 이상, 상위 40)', '', '| 항목ID | 유형 | 대상 | UI 수 | UI | 대표 설명 |', '|---|---|---|---:|---|---|']
    md += [f"| {r[0]} | {r[1]} | {r[2]} | {r[8]} | {r[9][:80]} | {str(r[4])[:60]} |" for r in item_rows if r[10] == 'Y'][:40]
    md += ['', '## 4. AS-IS↔TO-BE 비교 판정 분포', '', '| 판정 | 행 |', '|---|---:|'] + [f'| {k} | {v} |' for k, v in sorted(verd.items())]
    md += ['', '## 5. 추출 한계', ''] + [f'- {r[1]}' for r in s0 if r[0].startswith('추출 한계')]
    open(os.path.join(OUTDIR, f'{dom}_DB_VALIDATION_취합_{DATE}.md'), 'w', encoding='utf-8').write('\n'.join(md) + '\n')
    print(dom, 'screens', len(screens), 'units', len(dunits), 'rows', sum(len(by_unit.get(u, [])) for u in dunits), 'items', len(dom_items), 'ui_rows', len(ui_rows), 'cmp', len(cmp4), xp)

for d in ('SCP', 'SSP'):
    build(d)

# ---- 진단 출력
_v = collections.Counter(c.get('verdict') for c in cmp_rows)
print('verdicts', dict(_v))
print('remap_needed rows', len(remap_needed), 'pairs', sorted({(c.get('asis_sp'), c.get('tobe')) for c in remap_needed})[:40])
print('pairs_all', len(pairs_all), 'pairs_done', len(pairs_done & pairs_all), 'missing', sorted(pairs_all - pairs_done)[:20])
