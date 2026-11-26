# -*- coding: utf-8 -*-
"""운영자 매뉴얼 생성기(VMW 업무 '🛠 운영자 매뉴얼'). 2026-11-24 사용자 지시.

  양식 PPT 는 구조만 쓴다. 표지, 개정 이력, 목차, 간지, 본문 장표 모양, 장 제목 순서(outline), 장별 표 머리글, 마지막 장.
  양식의 글은 쓰지 않는다. 내용 = 고른 모듈(DM, SCP, SSP, SYSTEM) 분석 자료에서 운영자에게 필요한 사항(흐름, 점검, 조치)을 뽑아 정리한다.

  근거 자료
    - 메뉴, 화면 = 사내 SCM_ADM_MNU_M(user_manual.menu_tree)
    - 2026-11-24 사용자 지시: 잡, 배치, 로직 = TO-BE 기준만. AS-IS 로직은 넣지 않음. TO-BE 잡에 스케줄이 없거나 잡이 없을 때만 AS-IS 시각을 참고값으로 적음(ops_tobe.py)
    - 화면별 버튼, 프로시저 = 사내 TO-BE SCM_ADM_MNU_BTN_MPG_M, SCM_ADM_API_M · 읽기, 쓰기 테이블 = TO-BE 프로시저 본문(ALL_SOURCE)
    - 배치 = 사내 TO-BE ALL_SCHEDULER_JOBS(job_action 단계, 프로시저), ALL_SCHEDULER_SCHEDULES
    - 화면 흐름 = 화면 A 가 쓰는 테이블을 화면 B 가 읽으면 A → B(공통 테이블, 절반 넘는 화면이 읽는 테이블 제외)

  python tools/Docs/ops_manual.py prep  --module DM   사실 수집, 양식 구조(plan.json template.outline), 자동 초안(content/chapters_auto.json)
  python tools/Docs/ops_manual.py check --module DM   양식 장 빠짐, 화면 빠짐(프로그램 목록), 배치 잡 빠짐(잡 목록), 근거, 흐름 노드, 문장 규칙
  python tools/Docs/ops_manual.py build --module DM   Doc/OpsManual/<모듈>/SCM_OM_운영자매뉴얼_<모듈>_v<버전>.pptx
"""
import os, sys, re, csv, copy, datetime, argparse

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import user_manual as um  # 모듈 정의, 메뉴 트리, 일자 형식, 장표 복제 재사용
import ops_struct as OS  # 2026-11-24 사용자 확정 구성(장 순서, 사실 수집, 생성기 장, 검사 규칙)

ROOT = um.ROOT
sys.path.insert(0, os.path.join(ROOT, 'tools', 'Analysis'))
PLAN, AUTO, MAIN = 'plan.json', 'chapters_auto.json', 'chapters.json'
COMMON_TBL = re.compile(r'^(?:#|@|SCM_ADM_|TB_FX_|SCM_SYS_|SCM_COM_|SCM_MST_TITLESET|SCM_MST_SHEET_|C_BUCKET$)', re.I)
HEAD_RX = re.compile(r'^\s*(\d{1,2}(?:[.-]\d{1,2})?)\s*\.{0,2}\s+(\D.*?)\s*$')  # 장 번호 1~2자리(표지 일자 '2024. 6. 21' 제외)
PAGE_RX = re.compile(r'^\s*\d+\s*/\s*(?:\d+|N)\s*$')
out = um.out


def odir(key):
    # OPS_MANUAL_OUT = 시험용 출력 폴더(기본 Doc/OpsManual)
    return os.path.join(os.environ.get('OPS_MANUAL_OUT') or os.path.join(ROOT, 'Doc', 'OpsManual'), key)


def rel(p):
    return os.path.relpath(p, ROOT).replace('\\', '/')


def rcsv(f):
    try:
        with open(f, encoding='utf-8-sig', newline='') as fh:
            return list(csv.DictReader(fh))
    except Exception:
        return []


def norm(s):
    return re.sub(r'[^0-9a-z가-힣]', '', str(s or '').lower())


def inputs_of(key):
    inp = um.rj(os.path.join(odir(key), '_inputs.json'), None)
    if not inp:
        raise SystemExit(f'입력 없음: Doc/OpsManual/{key}/_inputs.json (VMW 운영자 매뉴얼 업무로 시작)')
    for k in ('author', 'date', 'version', 'template'):
        if not str(inp.get(k) or '').strip():
            raise SystemExit(f'입력 빠짐: {k} (Doc/OpsManual/{key}/_inputs.json)')
    if not os.path.exists(inp['template']):
        raise SystemExit(f'파일 없음: {inp["template"]}')
    inp['date'] = um.win_date(inp['date'])
    return inp


# ───────────────────────── 사실 수집 ─────────────────────────
def flow_edges(screens):
    n = max(1, len(screens)); rd = {}
    for s in screens:
        for t in s['reads']:
            rd[t] = rd.get(t, 0) + 1
    hot = {t for t, c in rd.items() if c > max(3, n * 0.5)}
    edges = {}
    for a in screens:
        for t in a['writes']:
            if COMMON_TBL.search(t) or t in hot:
                continue
            for b in screens:
                if b['id'] != a['id'] and t in b['reads']:
                    edges.setdefault((a['id'], b['id']), set()).add(t)
    return [{'from': k[0], 'to': k[1], 'tables': sorted(v)} for k, v in sorted(edges.items())]


# ───────────────────────── 양식 구조 ─────────────────────────
def first_line(slide):
    return um.slide_title(slide).split('\n')[0].strip()


def slide_texts(slide):
    return [sh.text_frame.text.strip() for sh in slide.shapes if sh.has_text_frame and sh.text_frame.text.strip()]


def roles(prs):
    """양식 장표 역할 번호(0부터): cover, rev, toc, divider, end, body(글 본문), table(표 본문)"""
    sl = list(prs.slides); r = {'cover': 0}
    for i, s in enumerate(sl):
        tx = ' '.join(slide_texts(s))
        tbl = [sh for sh in s.shapes if sh.has_table]
        if 'rev' not in r and tbl and re.search(r'버전|Version|개정|Rev', ' '.join(c.text for c in tbl[0].table.rows[0].cells), re.I):
            r['rev'] = i
        elif 'toc' not in r and re.search(r'목\s*차|Contents', tx, re.I) and i > 0:
            r['toc'] = i
        elif 'end' not in r and re.search(r'End of Document|끝', tx, re.I) and len(slide_texts(s)) <= 2:
            r['end'] = i
        elif 'divider' not in r and i > 1 and len(slide_texts(s)) == 1 and not tbl and not HEAD_RX.match(first_line(s)) and len(s.shapes) <= 3:
            r['divider'] = i
        elif 'table' not in r and len(tbl) == 1 and HEAD_RX.match(first_line(s)):
            r['table'] = i
        elif 'body' not in r and not tbl and HEAD_RX.match(first_line(s)):
            r['body'] = i
    return r


def template_structure(path):
    from pptx import Presentation
    prs = Presentation(path); outline, seen = [], {}
    for i, s in enumerate(prs.slides):
        m = HEAD_RX.match(first_line(s))
        if not m:
            continue
        no, title = m.group(1), m.group(2)
        title = re.sub(r'\s*\(\s*\d+\s*/\s*\d+\s*\)\s*$', '', title)
        base, sub = (re.split(r'\s+[–-]\s+', title, maxsplit=1) + [''])[:2]
        base = re.sub(r'\s*\(.*\)\s*$', '', base).strip(); k = norm(base)
        if not k:
            continue
        if k not in seen:
            seen[k] = {'no': no, 'title': base, 'subs': [], 'slides': [], 'tables': []}; outline.append(seen[k])
        o = seen[k]; o['slides'].append(i + 1)
        if sub and sub not in o['subs']:
            o['subs'].append(sub)
        for sh in s.shapes:
            if sh.has_table:
                cols = [c.text.replace('\x0b', ' ').strip() for c in sh.table.rows[0].cells]
                if cols not in o['tables']:
                    o['tables'].append(cols)
    r = roles(prs)
    return {'file': path, 'roles': r, 'outline': outline, 'layouts': [l.name for l in prs.slide_layouts], 'slides': len(prs.slides),
            'dividerExample': first_line(list(prs.slides)[r['divider']]) if 'divider' in r else ''}


# ───────────────────────── 준비 ─────────────────────────
def wcsv(path, rows, cols):
    with open(path, 'w', encoding='utf-8-sig', newline='') as fh:
        w = csv.DictWriter(fh, fieldnames=cols, extrasaction='ignore'); w.writeheader()
        for r in rows:
            w.writerow(r)


def cmd_prep(a):
    key = um.mod_key(a.module); mods = um.mods_of(key); inp = inputs_of(key); d = odir(key)
    os.makedirs(os.path.join(d, 'facts'), exist_ok=True); os.makedirs(os.path.join(d, 'content'), exist_ok=True)
    plan = {'key': key, 'mods': mods, 'at': datetime.datetime.now().strftime('%Y-%m-%d %H:%M'), 'template': template_structure(inp['template']), 'modules': []}
    S, B, E, TL = [], [], [], []
    import ops_tobe as OT
    try:
        db = OT.TobeDB()
    except Exception as e:  # TO-BE 사실 없이 만들지 않음(AS-IS 대체 금지)
        raise SystemExit(f'[ERROR] TO-BE DB 접속 실패(tools/DbConn tobe): {e}')
    for mod in mods:
        groups = um.menu_tree(mod, active=True); scr = []  # 2026-11-24 사용자: 사용하는 메뉴만
        for g in groups:
            for s in g['screens']:
                f = OT.screen_facts(db, s['id']); f.update({'name': s['name'], 'ko': s.get('ko', ''), 'top': g['top'], 'group': g['group'], 'menuPath': s['menuPath']}); scr.append(f)
        mod_sps = set().union(*[s['sps'] for s in scr]) if scr else set()
        edges = flow_edges(scr); bt, tl = OT.batch_facts(db, mod, mod_sps); TL += tl; no_f = [s['id'] for s in scr if not s['facts']]
        plan['modules'].append({'mod': mod, 'groups': [{'top': g['top'], 'group': g['group'], 'screens': [s['id'] for s in g['screens']]} for g in groups], 'screens': len(scr),
                                'noFacts': no_f, 'edges': len(edges), 'batchJobs': len({b['job'] for b in bt}), 'batchSteps': len(bt),
                                'batchBasis': {k: len({b['job'] for b in bt if b['basis'] == k}) for k in dict.fromkeys(b['basis'] for b in bt)}})
        for s in scr:
            save = ' '.join(f'{k}:{"/".join(sorted(v))}' for k, v in sorted(s['buttons'].items()) if re.search(r'save|upload|confirm|create|apply|exec|run|delete|close|release|cutoff', k, re.I))
            S.append({'module': mod, 'top': s['top'], 'group': s['group'], 'id': s['id'], 'name': s['name'], 'ko': s['ko'], 'facts': s['facts'] or 'TO-BE 메뉴 API 배선 없음(미확인)',
                      'writes': ' '.join(sorted(s['writes'])), 'reads': ' '.join(sorted(s['reads'])), 'sps': ' '.join(sorted(s['sps'])), 'saveButtons': save})
        B += bt; E += [dict(e, module=mod, tables=' '.join(e['tables'])) for e in edges]
        out(f'{mod}: 화면 {len(scr)} · TO-BE 배선 없는 화면 {len(no_f)} · 화면 간 연결 {len(edges)} · TO-BE 배치 잡 {len({b["job"] for b in bt})}개 단계 {len(bt)} · 기준 {plan["modules"][-1]["batchBasis"]}')
    wcsv(os.path.join(d, 'facts', 'screens.csv'), S, ['module', 'top', 'group', 'id', 'name', 'ko', 'facts', 'writes', 'reads', 'sps', 'saveButtons'])
    wcsv(os.path.join(d, 'facts', 'batch.csv'), B, ['module', 'job', 'enabled', 'desc', 'schedule', 'step', 'stepName', 'exec', 'group', 'ext', 'lastOutcome', 'lastRun', 'runs', 'failed', 'basis'])
    wcsv(os.path.join(d, 'facts', 'flow_edges.csv'), E, ['module', 'from', 'to', 'tables'])
    # 권한과 메뉴 관리 장 근거: SYSTEM 사용 메뉴 중 SCM_ADM_* 를 저장하는 화면(TO-BE 배선, 저장 프로시저 본문)
    ADM = []
    for g in um.menu_tree('SYSTEM', active=True):
        for sc in g['screens']:
            f = OT.screen_facts(db, sc['id']); w = sorted(t for t in f['writes'] if t.startswith('SCM_ADM_'))
            if w:
                ADM.append({'id': sc['id'], 'name': sc['name'], 'group': g['group'], 'writes': ' '.join(w), 'saveProcs': ' '.join(sorted(x for x in f['sps'] if 'SAVE' in x))})
    wcsv(os.path.join(d, 'facts', 'admin_screens.csv'), ADM, ['id', 'name', 'group', 'writes', 'saveProcs'])
    plan['struct'] = OS.collect(d, plan, S, B, COMMON_TBL, db, TL)
    # 점검 쿼리 근거: 데이터 구조 테이블 + 로그 테이블의 TO-BE 컬럼(파일에 없는 컬럼은 쓰지 않음)
    names = sorted({r['table'] for r in rcsv(os.path.join(d, 'facts', 'tables.csv'))} | {'SCM_SYS_LOG_BATCH', 'SCM_COM_SQL_LOG', 'SCM_ADM_SMS_MAIL_SEND_LOG', 'DM_MST_VERSION'})
    COLS = []
    for i in range(0, len(names), 200):
        part = names[i:i + 200]
        db.cur.execute("SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, COLUMN_ID FROM ALL_TAB_COLUMNS WHERE OWNER = 'SCM_MGR' AND TABLE_NAME IN (" + ','.join(f':b{k}' for k in range(len(part))) + ") ORDER BY TABLE_NAME, COLUMN_ID", {f'b{k}': v for k, v in enumerate(part)})
        COLS += [{'table': r[0], 'column': r[1], 'type': r[2], 'no': r[3]} for r in db.cur.fetchall()]
    wcsv(os.path.join(d, 'facts', 'columns.csv'), COLS, ['table', 'column', 'type', 'no'])
    db.close()
    um.wj(os.path.join(d, PLAN), plan)
    um.wj(os.path.join(d, 'content', AUTO), OS.auto_draft(plan, OS.facts(d), key))
    t = plan['template']; st = plan['struct']
    out(f'      구성: 잡 {st["jobs"]}개, 스케줄 {st["schedules"]}줄, 잡 호출 {st["links"]}건, 실행 프로시저 {st["sps"]}개(TO-BE 본문 찾음 {st["spFound"]}), 테이블 {st["tables"]}개, 프로세스 {", ".join(st["processes"])}')
    out(f'[OK] prep {key}: facts/screens.csv {len(S)}행, facts/batch.csv {len(B)}행, facts/flow_edges.csv {len(E)}행, content/{AUTO}')
    out(f'      양식 {os.path.basename(inp["template"])}: 장표 {t["slides"]}장, 장 제목 {len(t["outline"])}개({", ".join(o["no"] + " " + o["title"] for o in t["outline"])[:300]}), 역할 {t["roles"]}')
    return 0


# ───────────────────────── 검사 ─────────────────────────
def load_content(key):
    d = odir(key)
    c = um.rj(os.path.join(d, 'content', MAIN), None)
    return (c, MAIN) if c else (um.rj(os.path.join(d, 'content', AUTO), None), AUTO)


def check_slide(tag, s, allids, jobs, seen, texts, fails):
    if s.get('kind') == 'divider':
        return
    if not s.get('src'):
        fails.append(f'{tag}: 근거(src) 없음')
    for p in s.get('src') or []:
        if not os.path.exists(os.path.join(ROOT, re.split(r'[#:]', str(p))[0] if not re.match(r'^[A-Za-z]:', str(p)) else str(p))):
            fails.append(f'{tag}: 근거 파일 없음 {p}')
    k = s.get('kind')
    if k == 'flow':
        nids = {n.get('id') for n in s.get('nodes', [])}
        if not nids:
            fails.append(f'{tag}: 흐름 노드 없음')
        for e in s.get('edges', []):
            if e.get('from') not in nids or e.get('to') not in nids:
                fails.append(f'{tag}: 흐름 연결 끝점이 노드에 없음 {e.get("from")} → {e.get("to")}')
        seen['screens'] |= {n.get('id') for n in s.get('nodes', [])} & allids
        texts += [n.get('sub', '') for n in s.get('nodes', [])] + list(s.get('notes') or [])
    elif k == 'table':
        if not s.get('rows'):
            fails.append(f'{tag}: 표 행 없음')
        for r in s.get('rows', []):
            cells = [str(x) for x in r]
            seen['screens'] |= set(cells) & allids
            seen['jobs'] |= {j for j in jobs if any(j in c for c in cells)}
            # 표 칸은 화면 ID, SP, AS-IS 잡 설명(원문 인용) 이라 문장 규칙 검사에서 뺌. 문장 검사 = 본문(text), 흐름 메모(notes)
    elif k == 'text':
        if not s.get('lines'):
            fails.append(f'{tag}: 본문 없음')
        if any('작성 필요' in str(x) for x in s.get('lines', [])):
            fails.append(f'{tag}: 초안 문구(작성 필요) 남음')
        texts += list(s.get('lines', []))
    elif k in ('divider', 'timeline', 'tree', 'pmap'):
        return
    else:
        fails.append(f'{tag}: kind 는 flow, table, text, divider 중 하나')


def style_texts(texts, fails):
    try:
        import doc_style
        hits = [h for t in texts if t and not re.match(r'^[\w./,: -]+$', str(t)) for h in (doc_style.check_text(str(t)) or [])]
        if hits:
            fails.append(f'문장 규칙 위반 {len(hits)}건(50_DOC_STYLE): {str(hits[:3])[:300]}')
    except Exception as e:
        out(f'문장 검사 못 함(계속): {e}')


def cmd_check(a):
    """2026-11-24 확정 구성 검사: AI 장 빠짐, 프로세스 간지와 흐름도, 화면, 잡, 테이블 설명 빠짐, 근거, 초안 문구, 문장 규칙, 연락처 장 비움"""
    key = um.mod_key(a.module); d = odir(key); plan = um.rj(os.path.join(d, PLAN), None)
    if not plan:
        out('[FAIL] plan.json 없음. prep 먼저'); return 2
    c, name = load_content(key); fails = []
    if name != MAIN:
        fails.append(f'content/{MAIN} 없음(AI 단계가 {AUTO} 와 facts 를 보고 작성)')
    F = OS.facts(d)
    f2, sm = OS.check(plan, F, c or {}, check_slide, style_texts); fails += f2
    for f in fails:
        out(f'[FAIL] {f}')
    out(f'[{"OK" if not fails else "FAIL"}] check {key}: 프로세스 {sm["procs"]}개, 화면 설명 {sm["screenNotes"]}/{sm["screens"]}, 설명 빠진 잡 {sm["jobNotes"]}, 설명 빠진 테이블 {sm["tableNotes"]}/{sm["tables"]}, 실패 {len(fails)} · 내용 {name}')
    return 0 if not fails else 2


# ───────────────────────── PPTX 생성 ─────────────────────────
def proto_title_shape(slide):
    t = first_line(slide)
    for sh in slide.shapes:
        if sh.has_text_frame and sh.text_frame.text.strip().split('\n')[0].strip() == t:
            return sh
    return None


def new_from(prs, proto, title, keep_tables=False):
    """양식 장표 복제 → 제목, 쪽 번호만 남기고 나머지 도형 지움. 반환 (장표, 쪽 번호 도형)"""
    s = um.dup_slide(prs, proto); tshape = None; page = None; t0 = first_line(proto)
    for sh in list(s.shapes):
        txt = sh.text_frame.text.strip() if sh.has_text_frame else ''
        if tshape is None and txt and txt.split('\n')[0].strip() == t0:
            tshape = sh; continue
        if txt and PAGE_RX.match(txt):
            page = sh; continue
        if keep_tables and sh.has_table:
            continue
        sh._element.getparent().remove(sh._element)
    sub = ''
    sep = ' - ' if ' - ' in title else ' – '  # 양식 제목은 '–', 생성 제목은 '-'
    import ops_draw as _DR
    if sep in title and _DR.tw(title, 24) > prs.slide_width * 0.9:  # 넓힌 제목 상자(24pt)에도 안 들어갈 때만 부제목 줄로 나눔
        title, sub = title.split(sep, 1)
        m = re.search(r'\s*\(\d+/\d+\)$', sub)
        if m:
            title, sub = title + m.group(0), sub[:m.start()]
    if tshape is not None:
        um.set_text_keep(tshape, title)
        W0 = prs.slide_width  # 2026-11-24 사용자: 제목 상자 가로를 키워 2줄로 나오지 않게
        tshape.width = max(tshape.width, W0 - tshape.left - int(W0 * 0.03))
    draw_nav(s, prs)
    if sub:
        from pptx.util import Pt
        from pptx.dml.color import RGBColor
        W, H = prs.slide_width, prs.slide_height
        tb = s.shapes.add_textbox(int(W * 0.04), int(H * 0.105), int(W * 0.92), int(H * 0.04))
        tb.text_frame.text = sub; r0 = tb.text_frame.paragraphs[0].runs[0]; r0.font.size = Pt(12); r0.font.bold = True; r0.font.color.rgb = RGBColor(0x1F, 0x3B, 0x63)
    return s, page


NAV = {'items': None, 'cur': None}  # 2026-11-24 사용자 제안: 프로세스 장 = 왼쪽 프로세스 목록(자기 프로세스만 색칠) + 가운데, 오른쪽 = 흐름


def body_box(prs):
    W, H = prs.slide_width, prs.slide_height
    if NAV['items']:  # 왼쪽 목록 폭(17%)만큼 본문을 오른쪽으로
        return int(W * 0.215), int(H * 0.15), int(W * 0.745), int(H * 0.74)
    return int(W * 0.04), int(H * 0.15), int(W * 0.92), int(H * 0.74)


def draw_nav(slide, prs):
    """왼쪽 프로세스 목록: 전체 프로세스를 순서대로, 지금 프로세스만 남색(흰 글), 나머지 옅은 회색"""
    if not NAV['items']:
        return
    import ops_draw as DR
    from pptx.enum.shapes import MSO_SHAPE
    W, H = prs.slide_width, prs.slide_height
    x, y, w, h = int(W * 0.03), int(H * 0.15), int(W * 0.17), int(H * 0.74)
    n = len(NAV['items']); gap = 50000; bh = min(520000, (h - gap * (n - 1)) // max(1, n))
    for i, name in enumerate(NAV['items']):
        cur = name == NAV['cur']
        b = DR.box(slide, MSO_SHAPE.ROUNDED_RECTANGLE, x, y + i * (bh + gap), w, bh, fill=DR.NAVY if cur else DR.RGBColor(0xF2, 0xF2, 0xF2), line=None if cur else DR.GREY, lw=0.75)
        DR.put(b, [(f'{i + 1}. {name}', DR.fit_pt(f'{i + 1}. {name}', w, 11 if cur else 10, 7), cur, DR.WHITE if cur else DR.SUB)], DR.PP_ALIGN.LEFT)


SHOW_SRC = False  # 2026-11-24 사용자: 장표의 '근거:' 표기 삭제. 근거(src)는 content 에 남겨 검사에만 씀


def add_src(slide, prs, src):
    if not SHOW_SRC:
        return
    from pptx.util import Pt
    from pptx.dml.color import RGBColor
    W, H = prs.slide_width, prs.slide_height
    tb = slide.shapes.add_textbox(int(W * 0.04), int(H * 0.91), int(W * 0.8), int(H * 0.04))
    tb.text_frame.text = '근거: ' + ', '.join(src)[:170]
    r = tb.text_frame.paragraphs[0].runs[0]; r.font.size = Pt(7); r.font.color.rgb = RGBColor(0x80, 0x80, 0x80)


def fill_table_proto(t, cols, rows):
    """양식 표: 머리글 = cols, 둘째 행 서식을 복제해 rows 만큼 늘림(양식 표 모양 유지)"""
    tbl = t._tbl; trs = tbl.findall(um.qn('a:tr'))
    proto_tr = copy.deepcopy(trs[1] if len(trs) > 1 else trs[0])
    for tr in trs[1:]:
        tbl.remove(tr)
    for j, cname in enumerate(cols[:len(t.columns)]):
        um.table_set(t, 0, j, cname)
    for tc in proto_tr.iter(um.qn('a:tc')):
        for at in ('rowSpan', 'gridSpan', 'vMerge', 'hMerge'):
            tc.attrib.pop(at, None)  # 양식 표의 병합 칸이 복제 행에 따라오지 않게
    for r in rows:
        tr = copy.deepcopy(proto_tr); tbl.append(tr)
    for i, r in enumerate(rows, 1):
        for j in range(len(t.columns)):
            um.table_set(t, i, j, str(r[j]) if j < len(r) else '')


def row_lines(cols, rows, widths=None, total=9000000):
    """행마다 줄 수 = 칸별 글 길이 / 칸 너비(글자 수, 9pt 영문 약 62000 EMU) 최댓값"""
    n = max(1, len(cols)); ws = widths if widths and len(widths) == n else [total // n] * n
    cws = [max(4, int(w // 62000)) for w in ws]
    return [max([1] + [-(-len(str(x)) // cws[j]) for j, x in enumerate(r[:n])]) for r in rows]


def split_rows(cols, rows, budget=22, widths=None, total=9000000):
    """장표당 줄 수 합이 budget 넘으면 다음 장.
       2026-11-24 사용자 지적(13행 다음 장에 4행만 나눔): 줄 수 합이 budget 의 1.4배 이내면 한 장(작은 글자),
       넘으면 장 수는 그대로 두고 장마다 줄 수를 고르게 나눔"""
    hs = row_lines(cols, rows, widths, total); tot = sum(hs)
    if tot <= budget * 1.4:
        return [list(rows)]
    n = -(-tot // budget); per = -(-tot // n); parts, cur, used = [], [], 0
    for r, h in zip(rows, hs):
        if cur and used + h > per and len(parts) < n - 1:
            parts.append(cur); cur, used = [], 0
        cur.append(r); used += h
    parts.append(cur)
    return parts


def render_table(prs, P, sl, pages):
    """2026-11-24 사용자 지적: 머리글 초록 배경 대신 남색, 머리글 가운데, 긴 글 왼쪽, 짧은 글 가운데, 열 너비 최적화(ops_draw.style_table)"""
    import ops_draw as DR
    cols, rows = sl.get('columns', []), sl.get('rows', [])
    x, y, w, h = body_box(prs)
    ws = DR.col_widths(cols, rows, w)
    HEAD = DR.template_head([sh for sh in P['table'].shapes if sh.has_table][0].table) if P.get('table') is not None else None  # 머리글 색 = AS-IS 양식
    parts = split_rows(cols, rows, budget=24, widths=ws)
    for pi, part in enumerate(parts):
        title = sl.get('title', '') + (f' ({pi + 1}/{len(parts)})' if len(parts) > 1 else '')
        s, pg = new_from(prs, P['body'], title)
        dense = sum(row_lines(cols, part, ws)) > 24  # 1.4배 이내라 한 장에 모은 표 = 글자 8pt, 행 높이 줄임
        t = s.shapes.add_table(len(part) + 1, max(1, len(cols)), x, y, w, min(h, (200000 if dense else 260000) * (len(part) + 1))).table
        for j, cn in enumerate(cols):
            t.cell(0, j).text = str(cn)
        for i, r in enumerate(part, 1):
            for j in range(len(cols)):
                t.cell(i, j).text = str(r[j] if j < len(r) else '')
        DR.style_table(t, cols, rows, w, pt=8 if dense else 9, head=HEAD)
        if sl.get('layoutOnly'):  # 연락처와 담당 부서 = 내용 채울 대상 표시
            DR.sticker(s, x + w // 2, y + int(h * 0.35))
        if sl.get('src'):
            add_src(s, prs, sl.get('src') or [])
        pages.append(pg)


def style_like(t, proto):
    """양식 표의 머리글, 본문 칸 서식(채우기, 테두리)을 새 표에 복사(열 수가 달라도 양식 모양 유지)"""
    if proto is None:
        return
    try:
        pt = [sh for sh in proto.shapes if sh.has_table][0].table
        h = pt.cell(0, 0)._tc.find(um.qn('a:tcPr')); b = pt.cell(min(1, len(pt.rows) - 1), 0)._tc.find(um.qn('a:tcPr'))
        for i, row in enumerate(t.rows):
            for cell in row.cells:
                src = h if i == 0 else b
                if src is None:
                    continue
                old = cell._tc.find(um.qn('a:tcPr'))
                if old is not None:
                    cell._tc.remove(old)
                cell._tc.append(copy.deepcopy(src))
        tp = t._tbl.find(um.qn('a:tblPr'))
        if tp is not None:
            for k in ('bandRow', 'firstRow'):
                tp.set(k, '0')
    except Exception as e:
        out(f'표 서식 복사 못 함(계속): {e}')


def table_h(cols, rows, w):
    import ops_draw as DR
    return 300000 + sum(row_lines(cols, rows, DR.col_widths(cols, rows, w))) * 165000 + len(rows) * 10000  # 2026-11-24 PNG 실측: 9pt 2줄 행 약 325000 EMU


def text_h(lines, w, pt=10):
    import ops_draw as DR
    return sum(max(1, -(-DR.tw(str(x), pt) // max(1, w - 100000))) for x in lines) * int(pt * 12700 * 1.45) + 100000


def merge_title(a, b):
    """'X - 잡 목록', 'X - 확인 사항' → 'X - 잡 목록, 확인 사항'"""
    ta, tb = str(a).split(), str(b).split(); k = 0
    while k < min(len(ta), len(tb)) and ta[k] == tb[k]:
        k += 1
    ra, rb = ' '.join(ta[k:]), ' '.join(tb[k:])
    if not rb:
        return a
    return (' '.join(ta[:k]) + (' ' if k else '') + (f'{ra}, {rb}' if ra else rb)).strip() if k else f'{a}, {b}'


def can_merge(prs, a, b):
    """2026-11-24 사용자 지적(표와 확인 사항을 두 장으로 나눔. 비슷한 장표도 나누지 않음): 표(한 장 분량) + 글(블록 아님) 또는 글 + 글 이 본문 높이에 들어가면 한 장"""
    import ops_draw as DR
    if not a or not b or a.get('layoutOnly') or b.get('layoutOnly'):
        return False
    ka, kb = a.get('kind'), b.get('kind')
    if kb not in ('text', None) or ka not in ('table', 'text', None) or DR.blocks_of(b.get('lines', [])) or (ka != 'table' and DR.blocks_of(a.get('lines', []))):
        return False
    x, y, w, h = body_box(prs)
    ha = table_h(a.get('columns', []), a.get('rows', []), w) if ka == 'table' else text_h(a.get('lines', []), w)
    if ka == 'table' and len(split_rows(a.get('columns', []), a.get('rows', []), budget=24, widths=DR.col_widths(a.get('columns', []), a.get('rows', []), w))) > 1:
        return False
    return ha + 150000 + text_h(b.get('lines', []), w) <= h


def render_merged(prs, P, a, b, pages):
    """표(또는 글) 위 + 글 아래 한 장"""
    from pptx.util import Pt
    import ops_draw as DR
    s, pg = new_from(prs, P['body'], merge_title(a.get('title', ''), b.get('title', '')))
    x, y, w, h = body_box(prs)
    if a.get('kind') == 'table':
        cols, rows = a.get('columns', []), a.get('rows', [])
        HEAD = DR.template_head([sh for sh in P['table'].shapes if sh.has_table][0].table) if P.get('table') is not None else None
        th = min(h, 260000 * (len(rows) + 1))
        t = s.shapes.add_table(len(rows) + 1, max(1, len(cols)), x, y, w, th).table
        for j, cn in enumerate(cols):
            t.cell(0, j).text = str(cn)
        for i, r in enumerate(rows, 1):
            for j in range(len(cols)):
                t.cell(i, j).text = str(r[j] if j < len(r) else '')
        DR.style_table(t, cols, rows, w, head=HEAD)
        top = table_h(cols, rows, w)
    else:
        top = text_h(a.get('lines', []), w); _text_box(s, x, y, w, top, a.get('lines', []), 10)
    mt = merge_title(a.get('title', ''), b.get('title', ''))
    _text_box(s, x, y + top + 150000, w, h - top - 150000, b.get('lines', []), 10, head=mt.split(', ')[-1] if ', ' in mt else None)  # 아래 글 머리(예: '확인 사항')
    add_src(s, prs, list(dict.fromkeys((a.get('src') or []) + (b.get('src') or []))))
    pages.append(pg)


def _text_box(s, x, y, w, h, lines, pt=11, head=None):
    from pptx.util import Pt
    tf = s.shapes.add_textbox(x, y, w, h).text_frame; tf.word_wrap = True; first = True
    if head:
        p = tf.paragraphs[0]; p.text = head; first = False
        for rn in p.runs:
            rn.font.size = Pt(pt + 1); rn.font.bold = True
    for ln in lines:
        p = tf.paragraphs[0] if first else tf.add_paragraph(); first = False; txt = str(ln)
        p.text = txt if re.match(r'^(\s|[·\-①-⑳]|\d+[.)]|SELECT|select|  )', txt) else '· ' + txt
        for rn in p.runs:
            rn.font.size = Pt(pt)
            if re.match(r'^\s*(SELECT|FROM|WHERE|AND|ORDER|GROUP|BEGIN|EXEC)\b', txt, re.I):
                rn.font.name = 'Consolas'; rn.font.size = Pt(pt - 2)


def render_divider(prs, P, sl, pages):
    if 'divider' not in P:
        s, pg = new_from(prs, P['body'], sl.get('title', '')); pages.append(pg); return
    s = um.dup_slide(prs, P['divider'])
    for sh in s.shapes:
        if sh.has_text_frame and sh.text_frame.text.strip():
            um.set_text_keep(sh, sl.get('title', '')); break


def render_timeline(prs, P, sl, pages, per=16):
    """시간대별 실행표: 왼쪽 = 잡, 실행 요일, 오른쪽 = 0~23시 칸. 진한 칸 = 지정 시각, 옅은 칸 = 반복 실행 구간, 회색 = 사용 안 함"""
    from pptx.util import Pt
    from pptx.enum.shapes import MSO_SHAPE
    from pptx.dml.color import RGBColor
    rows = sl.get('rows', []); parts = [rows[i:i + per] for i in range(0, max(1, len(rows)), per)]
    x0, y0, W, H = body_box(prs); lw, dw = int(W * 0.30), int(W * 0.12); gx = x0 + lw + dw; gw = W - lw - dw; cw = gw // 24
    for pi, part in enumerate(parts):
        s, pg = new_from(prs, P['body'], sl.get('title', '') + (f' ({pi + 1}/{len(parts)})' if len(parts) > 1 else ''))
        rh = min(260000, (H - 250000) // max(1, per))
        def tx(x, y, w, h, t, sz=7, bold=False, color=(0x30, 0x30, 0x30)):
            tb = s.shapes.add_textbox(x, y, w, h); tf = tb.text_frame; tf.margin_left = tf.margin_right = 20000; tf.margin_top = tf.margin_bottom = 0
            tf.text = t; r = tf.paragraphs[0].runs[0]; r.font.size = Pt(sz); r.font.bold = bold; r.font.color.rgb = RGBColor(*color)
        tx(x0, y0, lw, 220000, '잡', 8, True); tx(x0 + lw, y0, dw, 220000, '요일', 8, True)
        for hcol in range(24):
            tx(gx + hcol * cw, y0, cw, 220000, f'{hcol:02d}', 7, True)
        for hcol in range(25):
            ln = s.shapes.add_connector(1, gx + hcol * cw, y0 + 220000, gx + hcol * cw, y0 + 220000 + rh * len(part)); ln.line.color.rgb = RGBColor(0xD0, 0xD0, 0xD0); ln.line.width = Pt(0.5)
        for ri, r in enumerate(part):
            y = y0 + 220000 + ri * rh; grey = not r.get('on')
            col = (0x99, 0x99, 0x99) if grey else (0x20, 0x20, 0x20)
            tx(x0, y, lw, rh, str(r['job'])[:48] + (' (사용 안 함)' if grey else ''), 7, False, col); tx(x0 + lw, y, dw, rh, str(r.get('days', ''))[:16], 7, False, col)
            full = set(r.get('hours') or []); single = {int(t[:2]) for t in r.get('times') or [] if t[:2].isdigit()}
            for hcol in sorted(full):
                if not 0 <= hcol < 24:
                    continue
                box = s.shapes.add_shape(MSO_SHAPE.RECTANGLE, gx + hcol * cw + 8000, y + 30000, cw - 16000, rh - 60000); box.line.fill.background(); box.fill.solid()
                box.fill.fore_color.rgb = RGBColor(0xC8, 0xC8, 0xC8) if grey else (RGBColor(0x3B, 0x6E, 0xB5) if hcol in single else RGBColor(0xB7, 0xCD, 0xEB))
            if r.get('times') and len(r['times']) == 1 and r['times'][0][3:] != '00':
                tx(gx + 24 * cw - 380000, y, 380000, rh, r['times'][0], 6, False, col)
            elif r.get('every'):
                pass
        tx(x0, y0 + 220000 + rh * len(part) + 40000, W, 200000, '진한 칸 = 지정 시각 실행, 옅은 칸 = 반복 실행 구간. TO-BE 잡(DBMS_SCHEDULER) 스케줄 기준. 요일 칸이 "AS-IS 참고" 인 행 = TO-BE 잡이 없어 AS-IS 시각을 참고로 적음. 운영 사용 여부 미확인', 7)
        add_src(s, prs, sl.get('src') or []); pages.append(pg)


def render_text(prs, P, sl, pages, per=15):
    from pptx.util import Pt
    import ops_draw as DR
    lines = sl.get('lines', [])
    bl = DR.blocks_of(lines)
    if bl:  # 2026-11-24 사용자 지적: 업무 개요 글 나열 = 임팩트 없음 → 세로 블록 목록(SmartArt 모양), 장표당 7블록
        parts = [bl[i:i + 7] for i in range(0, len(bl), 7)]
        for pi, part in enumerate(parts):
            s, pg = new_from(prs, P['body'], sl.get('title', '') + (f' ({pi + 1}/{len(parts)})' if len(parts) > 1 else ''))
            DR.draw_blocks(s, body_box(prs), part)
            add_src(s, prs, sl.get('src') or []); pages.append(pg)
        return
    parts = [lines[i:i + per] for i in range(0, max(1, len(lines)), per)]
    for pi, part in enumerate(parts):
        s, pg = new_from(prs, P['body'], sl.get('title', '') + (f' ({pi + 1}/{len(parts)})' if len(parts) > 1 else ''))
        x, y, w, h = body_box(prs)
        tf = s.shapes.add_textbox(x, y, w, h).text_frame; tf.word_wrap = True
        for i, ln in enumerate(part):
            p = tf.paragraphs[0] if i == 0 else tf.add_paragraph(); txt = str(ln)
            p.text = txt if re.match(r'^(\s|[·\-①-⑳]|\d+[.)]|SELECT|select|  )', txt) else '· ' + txt
            for rn in p.runs:
                rn.font.size = Pt(11)
                if re.match(r'^\s*(SELECT|FROM|WHERE|AND|ORDER|GROUP|EXEC)\b', txt, re.I):
                    rn.font.name = 'Consolas'; rn.font.size = Pt(9)
        add_src(s, prs, sl.get('src') or []); pages.append(pg)


def render_flow(prs, P, sl, pages, cap=15):
    """2026-11-24 사용자 지적(선이 상자를 덮음, 이름표가 선에 겹침, 글자 겹침) → ops_draw: 연결선 = 상자 옆 연결점, 선 위 글 없음(번호 원 + 범례), 이름 한 줄.
       layout hub = 수신/송신 흐름, 직선 사슬(2~7단계) = 프로세스형, 그 밖 = 층 배치(노드 cap 개씩 장 나눔)"""
    import ops_draw as DR
    nodes = list(sl.get('nodes', [])); edges = [e for e in sl.get('edges', []) if e.get('from') != e.get('to')]; notes = sl.get('notes') or []
    if sl.get('layout') == 'hub':
        hubs = [n for n in nodes if n.get('hub')] or nodes[-1:]; hid = hubs[0]['id'] if hubs else ''
        recv, send = {}, {}
        for e in edges:
            if e.get('to') == hid:
                recv.setdefault(e['from'], []).append(e.get('label', ''))
            elif e.get('from') == hid:
                send.setdefault(e['to'], []).append(e.get('label', ''))
        lab = {n['id']: str(n.get('label') or n['id']) for n in nodes}
        s, pg = new_from(prs, P['body'], sl.get('title', ''))
        DR.draw_lanes(s, body_box(prs), lab.get(hid, hid), [(lab.get(k, k), ', '.join(x for x in v if x)) for k, v in recv.items()], [(lab.get(k, k), ', '.join(x for x in v if x)) for k, v in send.items()], notes)
        add_src(s, prs, sl.get('src') or []); pages.append(pg); return
    if DR.is_chain(nodes, edges):
        s, pg = new_from(prs, P['body'], sl.get('title', ''))
        DR.draw_process(s, body_box(prs), nodes, edges, notes)
        add_src(s, prs, sl.get('src') or []); pages.append(pg); return
    # 2026-11-24 사용자 지적(64, 65 장 사이 연결고리가 안 보임): 장 나눔 = 연결된 노드 묶음 단위. 묶음은 장 사이로 가르지 않음.
    #   한 묶음이 cap 의 2배를 넘을 때만 가르고, 그 장에 '다음 장 연결' 을 적음
    par = {n['id']: n['id'] for n in nodes}

    def root(k):
        while par[k] != k:
            par[k] = par[par[k]]; k = par[k]
        return k
    for e in edges:
        if e.get('from') in par and e.get('to') in par:
            par[root(e['from'])] = root(e['to'])
    comps = {}
    for n in nodes:
        comps.setdefault(root(n['id']), []).append(n)
    parts, cur = [], []
    for comp in comps.values():
        if len(comp) > cap * 2:
            if cur:
                parts.append(cur); cur = []
            parts += [comp[i:i + cap * 2] for i in range(0, len(comp), cap * 2)]
        elif cur and len(cur) + len(comp) > cap * 2 or cur and len(cur) >= cap and len(cur) + len(comp) > cap:
            parts.append(cur); cur = list(comp)
        else:
            cur += comp
    if cur:
        parts.append(cur)
    lab = {n['id']: str(n.get('label') or n['id']) for n in nodes}
    for pi, part in enumerate(parts):
        ids = {n['id'] for n in part}
        cross = [f'다음 장 연결: {lab[e["from"]]} → {lab[e["to"]]}' for e in edges if (e['from'] in ids) != (e['to'] in ids) and e['from'] in ids]
        s, pg = new_from(prs, P['body'], sl.get('title', '') + (f' ({pi + 1}/{len(parts)})' if len(parts) > 1 else ''))
        DR.draw_layered(s, body_box(prs), part, [e for e in edges if e['from'] in ids and e['to'] in ids], ((notes if pi == 0 else []) + cross) or None)
        add_src(s, prs, sl.get('src') or []); pages.append(pg)


def render_pmap(prs, P, sl, pages, per=6):
    """전체 프로세스 맵: 프로세스 6개씩 장 나눔"""
    import ops_draw as DR
    ps = sl.get('procs', []); parts = [ps[i:i + per] for i in range(0, max(1, len(ps)), per)]
    for pi, part in enumerate(parts):
        s, pg = new_from(prs, P['body'], sl.get('title', '') + (f' ({pi + 1}/{len(parts)})' if len(parts) > 1 else ''))
        DR.draw_pmap(s, body_box(prs), part)
        add_src(s, prs, sl.get('src') or []); pages.append(pg)


def render_tree(prs, P, sl, pages):
    """계층 구조형(UI 메뉴 구조): root → groups → 화면"""
    import ops_draw as DR
    s, pg = new_from(prs, P['body'], sl.get('title', ''))
    DR.draw_tree(s, body_box(prs), sl.get('root', ''), [{'name': g['name'], 'items': [tuple(x) for x in g.get('items', [])]} for g in sl.get('groups', [])])
    add_src(s, prs, sl.get('src') or []); pages.append(pg)


def fill_cover(slide, key, inp):
    """표지: 글 상자 역할로 바꿈(일자, 버전, 관리부서·작성자, 가장 큰 글 = 제목, 나머지 = 프로젝트). 양식 글 남기지 않음"""
    tfs = [sh for sh in slide.shapes if sh.has_text_frame and sh.text_frame.text.strip()]

    def size(sh):
        v = [r.font.size or 0 for p in sh.text_frame.paragraphs for r in p.runs]
        return max(v) if v else 0
    done = set()
    for sh in tfs:
        t = sh.text_frame.text
        if re.search(r'\d{4}\s*[-./]\s*\d{1,2}\s*[-./]\s*\d{1,2}', t):
            um.set_text_keep(sh, inp['date']); done.add(id(sh))
        elif re.search(r'(?i)\bver(sion)?\b', t):
            um.set_text_keep(sh, inp['version']); done.add(id(sh))
        elif re.search(r'관리부서|작성자|Author', t, re.I):
            um.set_text_keep(sh, f'작성자 : {inp["author"]}'); done.add(id(sh))
    rest = sorted([sh for sh in tfs if id(sh) not in done], key=size, reverse=True)
    if rest:
        um.set_text_keep(rest[0], f'NSCM 운영자 매뉴얼 ({key.replace("_", ", ")})')
    for sh in rest[1:]:
        um.set_text_keep(sh, 'LG Energy Solution NSCM')


def fill_toc(slide, key, inp, items):
    tfs = [sh for sh in slide.shapes if sh.has_text_frame and sh.text_frame.text.strip()]
    for sh in tfs:
        t = sh.text_frame.text.strip()
        if re.search(r'\d{4}\s*[-./]\s*\d{1,2}\s*[-./]\s*\d{1,2}', t):
            um.set_text_keep(sh, inp['date'])
        elif re.search(r'매뉴얼|manual', t, re.I) and len(t) < 40:
            um.set_text_keep(sh, f'운영자 매뉴얼 ({key.replace("_", ", ")})')
    lists = [sh for sh in tfs if len(sh.text_frame.paragraphs) >= 3]
    if not lists:
        return
    box = max(lists, key=lambda sh: len(sh.text_frame.paragraphs)); n0 = len(box.text_frame.paragraphs)
    sz = [r.font.size for p in box.text_frame.paragraphs for r in p.runs if r.font.size]
    names = []
    for it in items:
        t = re.sub(r'^\s*\d+(?:[.-]\d+)?\s*\.{0,2}\s*', '', it)  # 양식 목록이 번호를 붙임
        if t not in names:
            names.append(t)
    um.set_text_keep(box, '\n'.join(names))
    # 2026-11-24 사용자 지적: 목차가 길면 상자(테두리)를 세로로 키워 전체를 감쌈. 장표 아래 끝을 넘으면 그때만 글자를 줄임
    from pptx.util import Pt
    H = slide.part.package.presentation_part.presentation.slide_height
    pt = (sz[0] if sz else Pt(14)); line_h = int(pt * 1.45)
    need = len(names) * line_h + 120000
    frame = None
    for sh in slide.shapes:  # 목차 글 상자를 둘러싼 테두리 = 글 상자를 가로로 품는 가장 작은 도형
        if sh is box or sh.width is None or sh.has_text_frame and sh.text_frame.text.strip() == box.text_frame.text.strip():
            continue
        if sh.left <= box.left + 10000 and sh.left + sh.width >= box.left + box.width - 10000 and sh.top <= box.top + 10000 and sh.top + sh.height >= box.top + 10000:
            if frame is None or sh.width * sh.height < frame.width * frame.height:
                frame = sh
    limit = int(H * 0.93) - 400000
    if box.top + need > limit:
        k = (limit - box.top - 120000) / max(1, len(names) * line_h)
        pt = max(Pt(10), int(pt * k)); line_h = int(pt * 1.45); need = len(names) * line_h + 120000
        for p in box.text_frame.paragraphs:
            for r in p.runs:
                r.font.size = pt
    grow = max(0, box.top + need - (box.top + box.height)); box.height = box.height + grow
    if frame is not None:
        fb = frame.top + frame.height; want = box.top + need + 150000
        if want > fb:
            d = want - fb; frame.height = frame.height + d
            for sh in slide.shapes:  # 상자 아래 도형(작성일)도 같이 내림
                if sh is not frame and sh is not box and sh.top is not None and sh.top >= fb - 20000:
                    sh.top = sh.top + d


def fill_app_toc(slide, key, inp, items, no):
    """부록 목차 장표 = 양식 목차 장표 복제. 머리 '목 차' → '{no}. 부 록', 목록 자동 번호 끄고 'A. 이름' 그대로"""
    fill_toc(slide, key, inp, ['__APP__' + x for x in items])
    for sh in slide.shapes:
        if not sh.has_text_frame:
            continue
        t = sh.text_frame.text.strip()
        if re.fullmatch(r'목\s*차', t):
            um.set_text_keep(sh, f'{no}. 부   록')
        elif '__APP__' in t:
            um.set_text_keep(sh, '\n'.join(re.sub(r'^부록\s*', '', x) for x in items))
            for p in sh.text_frame.paragraphs:  # 양식 목록 자동 번호(1. 2. …) 끔 = 'A.' 'B.' 그대로 보임
                pPr = p._p.get_or_add_pPr()
                for el in list(pPr):
                    if el.tag.endswith('}buAutoNum') or el.tag.endswith('}buChar') or el.tag.endswith('}buNone'):
                        pPr.remove(el)
                from lxml import etree
                pPr.insert(0, etree.SubElement(pPr, um.qn('a:buNone')))
                pPr.set('indent', '0')


def fill_rev(slide, inp):
    for sh in slide.shapes:
        if not sh.has_table:
            continue
        t = sh.table
        for r in range(1, len(t.rows)):
            for cc in range(len(t.columns)):
                um.table_set(t, r, cc, '')
        for cc, h in enumerate(c.text for c in t.rows[0].cells):
            # 2026-11-24 사용자 지적: 버전 칸 'Ver' 빼고 숫자만, 글자 11pt(칸 밖으로 넘치지 않게)
            v = um.ver_tag(inp['version']) if re.search(r'버전|Ver|Rev', h, re.I) else inp['date'] if re.search(r'작성일|일자|날짜|Date', h, re.I) else inp['author'] if re.search(r'작성자|Author', h, re.I) else '최초 작성' if re.search(r'내용|Desc|변경', h, re.I) else ''
            if len(t.rows) > 1:
                um.table_set(t, 1, cc, v)
                from pptx.util import Pt
                for p in t.cell(1, cc).text_frame.paragraphs:
                    for r in p.runs:
                        r.font.size = Pt(11)
        return


# 2026-11-24 사용자: 매뉴얼 용어 '잡' → 'JOB'. 생성기 문구, 장 이름, 내용, 표 칸 전부(빌드 마지막에 장표 글 전체에 적용)
TERMS = [('잡', 'JOB')]


def apply_terms(prs):
    def fix(tf):
        for p in tf.paragraphs:
            for r in p.runs:
                t = r.text
                for a, b in TERMS:
                    t = t.replace(a, b)
                if t != r.text:
                    r.text = t
    for sl in prs.slides:
        for sh in sl.shapes:
            if sh.has_text_frame:
                fix(sh.text_frame)
            if getattr(sh, 'has_table', False) and sh.has_table:
                for row in sh.table.rows:
                    for c in row.cells:
                        fix(c.text_frame)


def cmd_build(a):
    from pptx import Presentation
    key = um.mod_key(a.module); d = odir(key); inp = inputs_of(key); plan = um.rj(os.path.join(d, PLAN), None)
    if not plan:
        out('[FAIL] plan.json 없음. prep 먼저'); return 2
    c, name = load_content(key)
    if not c:
        out(f'[FAIL] 내용 없음(content/{MAIN}, {AUTO})'); return 2
    prs = Presentation(inp['template']); orig = list(prs.slides); n0 = len(orig); R = roles(prs)
    P = {k: orig[v] for k, v in R.items()}
    if 'body' not in P:
        P['body'] = orig[min(len(orig) - 1, 4)]
    chs = OS.compose(plan, OS.facts(d), c, key)  # 2026-11-24 확정 구성(장 순서, 생성기 장, 연락처 모양)
    # 2026-11-24 사용자: 목차 = 본문 장 + 'N. 부록' 한 줄, 부록 시작 지점에 부록 목차 장표
    body = [ch['title'] for ch in chs if ch['slides'] and ch.get('part') != 'app']
    app = [ch['title'] for ch in chs if ch['slides'] and ch.get('part') == 'app']
    toc = body + ([f'{len(body) + 1}. 부록'] if app else [])
    pages = []; app_done = False
    for ch in chs:
        if ch.get('part') == 'app' and ch['slides'] and not app_done:
            app_done = True
            if 'toc' in P:
                fill_app_toc(um.dup_slide(prs, P['toc']), key, inp, app, len(body) + 1)
        procs = [x.get('title') for x in ch.get('slides', []) if x.get('kind') == 'divider'] if ch['id'] == 'C3' else []
        NAV['items'] = procs or None; NAV['cur'] = None
        sls = list(ch.get('slides', [])); i = 0
        while i < len(sls):
            sl = sls[i]; k = sl.get('kind'); i += 1
            if procs and k == 'divider':  # 간지 장표 없이 왼쪽 목록의 지금 프로세스로 표시
                NAV['cur'] = sl.get('title'); continue
            nx = sls[i] if i < len(sls) else None
            if k in ('table', 'text', None) and nx is not None and can_merge(prs, sl, nx):
                render_merged(prs, P, sl, nx, pages); i += 1; continue
            if k == 'flow':
                render_flow(prs, P, sl, pages)
            elif k == 'table':
                render_table(prs, P, sl, pages)
            elif k == 'divider':
                render_divider(prs, P, sl, pages)
            elif k == 'timeline':
                render_timeline(prs, P, sl, pages)
            elif k == 'tree':
                render_tree(prs, P, sl, pages)
            elif k == 'pmap':
                render_pmap(prs, P, sl, pages)
            else:
                render_text(prs, P, sl, pages)
        NAV['items'] = None; NAV['cur'] = None
    if 'end' in P:
        um.dup_slide(prs, P['end'])
    keep = sorted({R[k] for k in ('cover', 'rev', 'toc') if k in R})
    fill_cover(orig[0], key, inp)
    import ops_draw as DR
    for sh in list(orig[0].shapes):  # 표지 회사 로고(그림) 위에 '변경 필요'
        if sh.shape_type == 13 and sh.width and sh.height:
            DR.sticker(orig[0], sh.left + sh.width // 2, sh.top + sh.height // 2, w=max(1500000, int(sh.width * 0.9)))
    if 'rev' in R:
        fill_rev(orig[R['rev']], inp)
    if 'toc' in R:
        fill_toc(orig[R['toc']], key, inp, toc)
    ids = list(prs.slides._sldIdLst)
    for i in reversed(range(n0)):
        if i not in keep:
            prs.part.drop_rel(ids[i].get('{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id')); prs.slides._sldIdLst.remove(ids[i])
    total = len(prs.slides)
    idx = {id(s): i + 1 for i, s in enumerate(prs.slides)}
    for pg in pages:
        if pg is not None:
            sl = pg.part.slide if hasattr(pg, 'part') else None
            no = idx.get(id(sl), '') if sl is not None else ''
            um.set_text_keep(pg, f'{no}/{total}' if no else '')
    apply_terms(prs)
    f = os.path.join(d, f'SCM_OM_운영자매뉴얼_{key}_v{um.ver_tag(inp["version"])}.pptx')
    try:
        prs.save(f)
    except PermissionError:  # 2026-11-24: PowerPoint 에 열려 있으면 시각을 붙인 이름으로 저장(작업이 멈추지 않게)
        f2 = f[:-5] + '_' + datetime.datetime.now().strftime('%H%M') + '.pptx'
        try:
            prs.save(f2)
        except PermissionError:
            out(f'[FAIL] 파일이 열려 있어 저장하지 못함: {rel(f)}. PowerPoint 에서 닫고 다시 실행'); return 4
        out(f'[WARN] {rel(f)} 가 PowerPoint 에 열려 있어 {rel(f2)} 로 저장함'); f = f2
    fmts = um.formats_of(inp)  # 2026-11-26 사용자 지시 R210: 고른 출력 형식마다 저장
    made, errs = um.export_formats(f, fmts, rel)
    for m in made:
        out(f'      {m}')
    for e in errs:
        out(f'[FAIL] {e}')
    out(f'[{"OK" if not errs else "FAIL"}] build {key}: {rel(f)} · 장표 {total}장(양식 유지 {len(keep)}, 본문 {total - len(keep)}) · 내용 {name} · 양식 역할 {R} · 형식 {", ".join(fmts)}')
    return 4 if errs else 0


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('cmd', choices=['prep', 'check', 'build']); ap.add_argument('--module', required=True)
    a = ap.parse_args()
    return {'prep': cmd_prep, 'check': cmd_check, 'build': cmd_build}[a.cmd](a)


if __name__ == '__main__':
    sys.exit(main())
