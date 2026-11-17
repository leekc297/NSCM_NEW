# -*- coding: utf-8 -*-
"""
SSP 기존 분석 자료(사용자 제공 3종) → 구조화 팩트 (2026-11-11)
  python -I tools/Analysis/ssp_ref_extract.py <SCP_SSP_Batch List.xlsx> <SSP 프로세스 확인 내용.pptx> <SSP 통합테스트 시나리오.xlsx>
산출: Doc/asisfacts/ref_ssp/
  src/                      원본 사본(재현용)
  ppt_shapes.csv            슬라이드별 도형(id·이름·문구·좌표·그룹)
  ppt_connectors.csv        연결선(시작 도형 → 끝 도형 · 화살표 방향)
  prod_jobs.csv             운영 잡 스케줄(JOB-Daily&Weekly · RealTime · Monthly 합본)
  prod_job_calltree.csv     잡 → 프로시저 호출 트리
  prod_job_timetable.csv    잡 시간대별 실행 요일
  batch_list.csv            Batch List(프로시저 · IF 구분 · Job 여부 · UI 연계 · TO-BE 객체 상태)
  if_prc.csv                I/F 프로시저 ↔ I/F 테이블
  ui_prc.csv                UI 관련 프로시저
  it_scenario.csv           통합테스트 시나리오 · it_precheck.csv 사전 점검 · it_issues.csv 협의·수정 필요사항
  it_so_ordertype*.csv · it_send_rules.csv   (V2 2026-11-12 추가 시트) SO 오더타입 매핑 · 변경요청 ERP 송신 컬럼 값 규칙
  manual_*.csv              (--manual <Standard Information SSP Manual.pptx>) 기준정보 매뉴얼 도형·표·연결선(2026-11-16)
원칙: 원문 그대로 옮긴다(해석·보정 없음). 줄바꿈은 ' / ' 로만 바꾼다.
"""
import sys, os, io, re, csv, zipfile, shutil
sys.stdout.reconfigure(encoding='utf-8')
import openpyxl
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
OUT = os.path.join(ROOT, 'Doc', 'asisfacts', 'ref_ssp'); os.makedirs(os.path.join(OUT, 'src'), exist_ok=True)


def w(name, header, rows):
    p = os.path.join(OUT, name)
    with io.open(p, 'w', encoding='utf-8-sig', newline='') as f:
        c = csv.writer(f); c.writerow(header); c.writerows(rows)
    print(f'  {name}: {len(rows)}행'); return len(rows)


def cell(v):
    if v is None: return ''
    return re.sub(r'\s*\n\s*', ' / ', str(v)).strip()


def sheet_rows(wb, name):
    ws = wb[name]; return [[cell(c) for c in r] for r in ws.iter_rows(values_only=True)]


def do_batch(path):
    wb = openpyxl.load_workbook(path, data_only=True)
    jobs = []
    for sh, kind in (('JOB-Daily&Weekly', 'Daily/Weekly'), ('JOB-RealTime', 'RealTime'), ('JOB-Monthly', 'Monthly')):
        rows = sheet_rows(wb, sh); H = rows[0]
        ix = {h: i for i, h in enumerate(H)}
        for r in rows[1:]:
            if not any(r): continue
            g = lambda k: r[ix[k]] if k in ix and ix[k] < len(r) else ''
            jobs.append([kind, g('No'), g('모듈'), g('IF'), g('Job 명'), g('중복구분'), g('비고'), g('주기'), g('시간'), g('Call Procedure'), g('JOB 내용')])
    w('prod_jobs.csv', ['sheet', 'no', 'module', 'if', 'job', 'dup', 'note', 'cycle', 'time', 'call_procedure', 'job_content'], jobs)
    rows = sheet_rows(wb, 'JOB-Prc호출 트리'); w('prod_job_calltree.csv', ['job', 'depth', 'call_kind', 'procedure', 'args', 'vars'], [r[:6] for r in rows[1:] if any(r)])
    rows = sheet_rows(wb, 'Job 시간대별 실행 요일'); w('prod_job_timetable.csv', ['seq', 'time', 'module', 'job', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun', 'days', 'src_row', 'note1', 'note2', 'note3'], [(r + [''] * 16)[:16] for r in rows[1:] if any(r)])
    rows = sheet_rows(wb, 'JOB-요일별 실행 순서'); w('prod_job_dayorder.csv', ['day', 'seq', 'time', 'module', 'job', 'nth_run', 'same_time_jobs'], [r[:7] for r in rows[1:] if any(r)])
    rows = sheet_rows(wb, 'Batch List')
    w('batch_list.csv', ['module', 'if', 'job_related', 'non_job_has_child', 'ui_linked', 'procedure', 'new_or_convert', 'checked', 'owner', 'note', 'dev_ora_1022', 'dev_ora_1028', 'dev_err', 'dev_created', 'dev_changed', 'local_ora', 'local_err', 'local_created', 'local_changed'], [(r + [''] * 19)[:19] for r in rows[1:] if any(r)])
    rows = sheet_rows(wb, '※ IF PRC'); w('if_prc.csv', ['procedure', 'if', 'if_table', 'x', 'procedure_dedup', 'listup_check', 'if2', 'x2'], [(r + [''] * 8)[:8] for r in rows[1:] if any(r)])
    rows = sheet_rows(wb, '※ UI 관련 Prc'); w('ui_prc.csv', ['procedure', 'flag'], [r[:2] for r in rows if any(r)])
    rows = sheet_rows(wb, 'Prc 호출 트리'); w('prc_calltree.csv', ['start', 'depth', 'call_kind', 'procedure', 'args', 'calls'], [r[:6] for r in rows[1:] if any(r)])
    rows = sheet_rows(wb, '※로그프로시저'); w('log_prc.csv', ['procedure', 'table'], [r[:2] for r in rows[1:] if any(r)])


def do_ppt(path, prefix='ppt_'):
    """도형·연결선을 XML 트리로 읽어 절대 좌표로 푼다(그룹 변환 누적). 연결선 끝점은 ① 도형 id(stCxn/endCxn) ② 없으면 끝점에서 가장 가까운 도형(거리 기록)"""
    import xml.etree.ElementTree as ET
    NS = {'p': 'http://schemas.openxmlformats.org/presentationml/2006/main', 'a': 'http://schemas.openxmlformats.org/drawingml/2006/main'}
    P = '{%s}' % NS['p']; A = '{%s}' % NS['a']
    z = zipfile.ZipFile(path)
    slides = sorted([n for n in z.namelist() if re.match(r'ppt/slides/slide\d+\.xml$', n)], key=lambda n: int(re.findall(r'\d+', n)[-1]))
    shapes = []; conns = []; groups = []; tables = []
    def rel_target(part, kind):
        """part 의 .rels 에서 kind(slideLayout·slideMaster·theme) 대상 경로"""
        d, b = part.rsplit('/', 1); rp = f'{d}/_rels/{b}.rels'
        if rp not in z.namelist(): return ''
        for m_ in re.finditer(r'Target="([^"]+)"', z.read(rp).decode('utf-8')):
            if kind in m_.group(1): return os.path.normpath(os.path.join(d, m_.group(1))).replace(os.sep, '/')
        return ''
    def theme_colors(slide_part):
        """slide → layout → master → theme 의 색 표(accent1~6·dk1/2·lt1/2 · tx1/tx2/bg1/bg2 별칭) — 도형 채움 색(fill) 해석용(2026-11-16)"""
        th = rel_target(rel_target(rel_target(slide_part, 'slideLayout'), 'slideMaster'), 'theme')
        if not th or th not in z.namelist(): return {}
        x_ = z.read(th).decode('utf-8'); out_ = {}
        for k in ('dk1', 'lt1', 'dk2', 'lt2', 'accent1', 'accent2', 'accent3', 'accent4', 'accent5', 'accent6'):
            m_ = re.search(rf'<a:{k}>\s*<a:(?:srgbClr val|sysClr [^>]*?lastClr)="([0-9A-Fa-f]{{6}})"', x_)
            if m_: out_[k] = m_.group(1).upper()
        for a_, b_ in (('tx1', 'dk1'), ('bg1', 'lt1'), ('tx2', 'dk2'), ('bg2', 'lt2')):
            if b_ in out_: out_[a_] = out_[b_]
        return out_
    def fill_of(el, TC):
        """도형 자체 채움(spPr/solidFill) 기준색 hex · 원문 표기(scheme 이름) — lumMod 등 명도 보정은 원문 표기에만 남긴다"""
        sp = el.find('p:spPr', NS)
        f_ = sp.find('a:solidFill', NS) if sp is not None else None
        if f_ is None: return '', ''
        c_ = list(f_)[0] if len(f_) else None
        if c_ is None: return '', ''
        v_ = c_.get('val') or ''; mods = ','.join(f"{m.tag.split('}')[1]}={m.get('val')}" for m in c_)
        hexv = v_.upper() if c_.tag.endswith('srgbClr') else TC.get(v_, '')
        return hexv, (c_.tag.split('}')[1] + ':' + v_ + (f'({mods})' if mods else ''))
    for n in slides:
        sno = int(re.findall(r'\d+', n)[-1]); root = ET.fromstring(z.read(n)); TC = theme_colors(n)
        tree = root.find('p:cSld/p:spTree', NS)
        s_shapes = []; s_conns = []
        def xf(el):
            x = el.find('.//a:xfrm', NS)
            if x is None: return None
            off = x.find('a:off', NS); ext = x.find('a:ext', NS)
            if off is None or ext is None: return None
            return x, int(off.get('x')), int(off.get('y')), int(ext.get('cx')), int(ext.get('cy'))
        def walk(node, T, gpath):
            for el in list(node):
                tag = el.tag
                if tag == P + 'grpSp':
                    pr = el.find('p:grpSpPr/a:xfrm', NS); nv = el.find('p:nvGrpSpPr/p:cNvPr', NS); gid = nv.get('id') if nv is not None else ''
                    T2 = T
                    if pr is not None and pr.find('a:off', NS) is not None:
                        off = pr.find('a:off', NS); ext = pr.find('a:ext', NS); cho = pr.find('a:chOff', NS); che = pr.find('a:chExt', NS)
                        ox, oy, ex, ey = int(off.get('x')), int(off.get('y')), int(ext.get('cx')), int(ext.get('cy'))
                        cx0, cy0 = (int(cho.get('x')), int(cho.get('y'))) if cho is not None else (ox, oy)
                        cex, cey = (int(che.get('cx')), int(che.get('cy'))) if che is not None else (ex, ey)
                        kx = ex / cex if cex else 1.0; ky = ey / cey if cey else 1.0
                        sx, sy, tx, ty = T
                        T2 = (sx * kx, sy * ky, tx + sx * (ox - cx0 * kx), ty + sy * (oy - cy0 * ky))
                        ax, ay = tx + sx * ox, ty + sy * oy
                        groups.append([sno, gid, nv.get('name') if nv is not None else '', gpath[-1] if gpath else '', round(ax), round(ay), round(sx * ex), round(sy * ey)])
                    walk(el, T2, gpath + [gid])
                elif tag == P + 'graphicFrame':  # 표 개체(a:tbl) — 칸 문구를 행·열 그대로
                    nvp = el.find('p:nvGraphicFramePr/p:cNvPr', NS); fid = nvp.get('id') if nvp is not None else ''
                    for ri, tr in enumerate(el.iter(A + 'tr')):
                        for ci, tc in enumerate(tr.findall(A + 'tc')):
                            paras = [''.join(t.text or '' for t in pp.iter(A + 't')) for pp in tc.iter(A + 'p')]
                            tables.append([sno, fid, ri, ci, ' / '.join(t.strip() for t in paras if t.strip())])
                elif tag in (P + 'sp', P + 'cxnSp'):
                    nvp = el.find('p:nvSpPr/p:cNvPr', NS) if tag == P + 'sp' else el.find('p:nvCxnSpPr/p:cNvPr', NS)
                    sid = nvp.get('id') if nvp is not None else ''; nm = nvp.get('name') if nvp is not None else ''
                    v = xf(el.find('p:spPr', NS)) if el.find('p:spPr', NS) is not None else None
                    sx, sy, tx, ty = T
                    if v:
                        x_, ox, oy, ex, ey = v; ax, ay, aw, ah = tx + sx * ox, ty + sy * oy, sx * ex, sy * ey
                    else:
                        x_ = None; ax = ay = aw = ah = None
                    if tag == P + 'sp':
                        paras = [''.join(t.text or '' for t in pp.iter(A + 't')) for pp in el.iter(A + 'p')]
                        txt = ' / '.join(t.strip() for t in paras if t.strip())
                        g = el.find('p:spPr/a:prstGeom', NS)
                        fh_, fr_ = fill_of(el, TC)
                        s_shapes.append({'id': sid, 'name': nm, 'group': gpath[-1] if gpath else '', 'gpath': '>'.join(gpath), 'geom': g.get('prst') if g is not None else '', 'x': ax, 'y': ay, 'w': aw, 'h': ah, 'text': txt, 'fill': fh_, 'fill_raw': fr_})
                    else:
                        cpr = el.find('p:nvCxnSpPr/p:cNvCxnSpPr', NS)
                        st = cpr.find('a:stCxn', NS) if cpr is not None else None; en = cpr.find('a:endCxn', NS) if cpr is not None else None
                        ln = el.find('p:spPr/a:ln', NS)
                        he = ln.find('a:headEnd', NS) if ln is not None else None; te = ln.find('a:tailEnd', NS) if ln is not None else None
                        fh = x_ is not None and x_.get('flipH') == '1'; fv = x_ is not None and x_.get('flipV') == '1'
                        rot = int(x_.get('rot') or 0) / 60000.0 if x_ is not None else 0.0
                        g = el.find('p:spPr/a:prstGeom', NS); prst = g.get('prst') if g is not None else 'line'
                        adj = {}
                        if g is not None:
                            for gd in g.iter(A + 'gd'):
                                m_ = re.match(r'val\s+(-?\d+)', gd.get('fmla') or '')
                                if m_: adj[gd.get('name')] = int(m_.group(1))
                        pts = []
                        if v:
                            _, ox, oy, ex, ey = v
                            a1 = adj.get('adj1', 50000) / 100000.0; a2 = adj.get('adj2', 50000) / 100000.0; a3 = adj.get('adj3', 50000) / 100000.0
                            if prst in ('bentConnector2', 'curvedConnector2'): loc = [(0, 0), (ex, 0), (ex, ey)]
                            elif prst in ('bentConnector3', 'curvedConnector3'): loc = [(0, 0), (ex * a1, 0), (ex * a1, ey), (ex, ey)]
                            elif prst in ('bentConnector4', 'curvedConnector4'): loc = [(0, 0), (ex * a1, 0), (ex * a1, ey * a2), (ex, ey * a2), (ex, ey)]
                            elif prst in ('bentConnector5', 'curvedConnector5'): loc = [(0, 0), (ex * a1, 0), (ex * a1, ey * a2), (ex * a3, ey * a2), (ex * a3, ey), (ex, ey)]
                            else: loc = [(0, 0), (ex, ey)]
                            import math
                            cxm, cym = ex / 2.0, ey / 2.0; th = math.radians(rot); co, si = math.cos(th), math.sin(th)
                            for lx, ly in loc:
                                if fh: lx = ex - lx
                                if fv: ly = ey - ly
                                rx = cxm + (lx - cxm) * co - (ly - cym) * si; ry = cym + (lx - cxm) * si + (ly - cym) * co
                                pts.append((tx + sx * (ox + rx), ty + sy * (oy + ry)))
                        p1 = pts[0] if pts else (None, None); p2 = pts[-1] if pts else (None, None)
                        s_conns.append({'id': sid, 'st': st.get('id') if st is not None else '', 'en': en.get('id') if en is not None else '', 'prst': prst, 'rot': rot, 'pts': pts,
                                        'head': 'Y' if he is not None and he.get('type', 'none') != 'none' else '', 'tail': 'Y' if te is not None and te.get('type', 'none') != 'none' else '', 'p1': p1, 'p2': p2})
        walk(tree, (1.0, 1.0, 0.0, 0.0), [])
        def nearest(pt, exclude=()):
            if pt[0] is None: return '', ''
            best = None
            for sh in s_shapes:
                if sh['x'] is None or sh['id'] in exclude or not sh['text']: continue
                dx = max(sh['x'] - pt[0], 0, pt[0] - (sh['x'] + sh['w'])); dy = max(sh['y'] - pt[1], 0, pt[1] - (sh['y'] + sh['h']))
                d = (dx * dx + dy * dy) ** 0.5
                if best is None or d < best[0]: best = (d, sh['id'])
            return (best[1], round(best[0])) if best else ('', '')
        for sh in s_shapes:
            shapes.append([sno, sh['id'], sh['name'], sh['group'], sh['gpath'], sh['geom'], *(round(v) if v is not None else '' for v in (sh['x'], sh['y'], sh['w'], sh['h'])), sh['text'], sh['fill'], sh['fill_raw']])
        for c in s_conns:
            a_id, a_d = (c['st'], 0) if c['st'] else nearest(c['p1'])
            b_id, b_d = (c['en'], 0) if c['en'] else nearest(c['p2'])
            conns.append([sno, c['id'], a_id, 'id' if c['st'] else 'geom', a_d, b_id, 'id' if c['en'] else 'geom', b_d, c['head'], c['tail'],
                          *(round(v) if v is not None else '' for v in (c['p1'][0], c['p1'][1], c['p2'][0], c['p2'][1])), c['prst'], c['rot'], ';'.join(f'{round(x)},{round(y)}' for x, y in c['pts'])])
    w(prefix + 'shapes.csv', ['slide', 'id', 'name', 'group', 'group_path', 'geom', 'x', 'y', 'w', 'h', 'text', 'fill', 'fill_raw'], shapes)
    w(prefix + 'tables.csv', ['slide', 'frame_id', 'row', 'col', 'text'], tables)
    w(prefix + 'groups.csv', ['slide', 'id', 'name', 'parent', 'x', 'y', 'w', 'h'], groups)
    w(prefix + 'connectors.csv', ['slide', 'id', 'start_id', 'start_by', 'start_dist_emu', 'end_id', 'end_by', 'end_dist_emu', 'arrow_at_start', 'arrow_at_end', 'x1', 'y1', 'x2', 'y2', 'prst', 'rot', 'path'], conns)


def do_it(path):
    wb = openpyxl.load_workbook(path, data_only=True)
    rows = sheet_rows(wb, '통합 시나리오'); H1 = rows[2]; H2 = rows[3]
    H = [(a + (' ' + b if b else '')).strip() or f'col{i}' for i, (a, b) in enumerate(zip(H1, H2 + [''] * len(H1)))]
    seen = {}
    for i, h in enumerate(H):
        if h in seen: seen[h] += 1; H[i] = f'{h}#{seen[h]}'
        else: seen[h] = 1
    out = []; stage = ''
    ti = H1.index('테스트ID')
    for r in rows[4:]:
        r = (r + [''] * len(H))[:len(H)]
        if not r[ti]:
            s = ' '.join(c for c in r if c)
            if s: stage = s
            continue
        out.append([stage] + r[1:])
    w('it_scenario.csv', ['stage_row'] + H[1:], out)
    rows = sheet_rows(wb, '사전 점검'); H1 = rows[2] if '테스트ID' in rows[2] else rows[1]
    hi = next(i for i, r in enumerate(rows) if '테스트ID' in r); H = [h or f'col{i}' for i, h in enumerate(rows[hi])]
    seen = {}
    for i, h in enumerate(H):
        if h in seen: seen[h] += 1; H[i] = f'{h}#{seen[h]}'
        else: seen[h] = 1
    ti = rows[hi].index('테스트ID')
    w('it_precheck.csv', H[1:], [((r + [''] * len(H))[:len(H)])[1:] for r in rows[hi + 1:] if len(r) > ti and r[ti]])
    iss = []
    for sh in ('협의사항', '수정 필요사항'):
        for r in sheet_rows(wb, sh):
            if any(r): iss.append([sh] + [c for c in r])
    w('it_issues.csv', ['sheet', 'c1', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7', 'c8', 'c9'], [(r + [''] * 10)[:10] for r in iss])
    # 2026-11-16 V2((20261112) …-V2.xlsx) 추가 시트: 한 시트에 '제목 줄(칸 1개) → 머리 줄 → 자료 줄' 묶음이 여러 개 — 묶음마다 CSV 1개
    def blocks(rows_):
        out_, cur = [], None
        for r in rows_:
            nz = [c for c in r if c]
            if not nz:
                continue
            if len(nz) == 1 and (cur is None or cur['hdr']):
                cur = {'title': nz[0], 'hdr': None, 'rows': []}; out_.append(cur); continue
            if cur is None: cur = {'title': '', 'hdr': None, 'rows': []}; out_.append(cur)
            first = next(i for i, c in enumerate(r) if c)
            if cur['hdr'] is None: cur['hdr'] = (first, [c for c in r[first:]]); continue
            cur['rows'].append(r[cur['hdr'][0]:])
        return out_
    EXTRA = {'SO 오더타입 매핑': ['it_so_ordertype.csv', 'it_so_ordertype_detail.csv'], '송신 컬럼 값 규칙': ['it_send_rules.csv']}
    KNOWN = {'요약', '사전 점검', '통합 시나리오', '협의사항', '수정 필요사항', 'SQL'}
    for sh, names in EXTRA.items():
        if sh not in wb.sheetnames: continue
        bl = blocks(sheet_rows(wb, sh))
        for i, b in enumerate(bl):
            nm = names[i] if i < len(names) else f'{names[0][:-4]}_{i + 1}.csv'
            hdr = [h or f'c{k}' for k, h in enumerate(b['hdr'][1])] if b['hdr'] else []
            while hdr and hdr[-1].startswith('c') and all(len(r) <= len(hdr) - 1 or not r[len(hdr) - 1] for r in b['rows']): hdr.pop()
            w(nm, ['block_title'] + hdr, [[b['title']] + (r + [''] * len(hdr))[:len(hdr)] for r in b['rows']])
    other = [x for x in wb.sheetnames if x not in KNOWN and x not in EXTRA]
    if other: print('  [경고] 추출하지 않은 시트:', ', '.join(other))
    print('  [참고] SQL 시트는 실행 SQL 모음이라 추출하지 않음(11-11 과 같음)')
    rows = sheet_rows(wb, '요약'); w('it_summary.csv', ['c' + str(i) for i in range(12)], [(r + [''] * 12)[:12] for r in rows if any(r)])


if __name__ == '__main__':
    if sys.argv[1:2] == ['--manual']:  # 2026-11-16 Standard Information SSP Manual(기준정보 Master Flow · 화면별 매뉴얼) → manual_*.csv
        m_ = sys.argv[2]; dst = os.path.join(OUT, 'src', os.path.basename(m_))
        if os.path.abspath(m_) != os.path.abspath(dst): shutil.copy2(m_, dst)
        print('[ssp_ref_extract --manual] →', os.path.relpath(OUT, ROOT)); do_ppt(m_, prefix='manual_'); sys.exit(0)
    b, p, t = sys.argv[1:4]
    for f in (b, p, t):
        dst = os.path.join(OUT, 'src', os.path.basename(f))
        if os.path.abspath(f) != os.path.abspath(dst): shutil.copy2(f, dst)
    print('[ssp_ref_extract] →', os.path.relpath(OUT, ROOT))
    do_batch(b); do_ppt(p); do_it(t)
