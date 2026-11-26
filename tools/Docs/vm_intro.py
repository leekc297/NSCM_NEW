# -*- coding: utf-8 -*-
"""VM 소개 자료 생성기(VMW 업무 '🎤 VM 소개 자료'). 2026-11-24 사용자 지시.

  대상(VMW 에서 고름, 여러 개면 대상마다 자료 1개): EXEC 경영진 보고, DEV 개발자와 운영 교육, SHARE 사내 공유
  출력 형식(여러 개 고름): pptx = PowerPoint · gslides = Google Slides 가져오기용 PPTX(Noto Sans KR, 기본 도형만)
                         pdf = PowerPoint 로 PDF 저장 · html = 브라우저 발표용 HTML 한 파일
  디자인 = 양식 없이 비즈니스 제안서 형태(16:9, 남색 표지, 헤드라인 제목, 수치 카드, 단계 그림)

  수치 = prep 이 측정한 값(facts.json)만 씀. 장표의 수치 카드는 fact 키로만 적고 값은 build 가 facts 에서 넣음(감, 예측 수치 금지)
  python tools/Docs/vm_intro.py prep  --module EXEC   사실 측정(Doc/VMIntro/<대상>/facts.json) + 초안(content/slides_auto.json)
  python tools/Docs/vm_intro.py check --module EXEC   장 구성, fact 키, 본문 숫자, 문장 규칙
  python tools/Docs/vm_intro.py build --module EXEC   _inputs.json formats 에 따라 pptx, gslides, pdf, html
"""
import os, sys, re, json, glob, csv, datetime, argparse, subprocess, collections

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
VM = os.path.join(ROOT, 'tools', 'VibeManager')
AUD = {'EXEC': '경영진 보고', 'DEV': '개발자, 운영 교육', 'SHARE': '사내 공유'}
FORMATS = ['pptx', 'gslides', 'pdf', 'html']
MAIN, AUTO = 'slides.json', 'slides_auto.json'
AUTHOR = 'MARISOFT'  # 2026-11-24 사용자: VM 솔루션 소개 자료의 문서 작성자 = MARISOFT(개인 이름 금지, 입력값과 상관없이 고정)
# 대상별 장 수 범위(검사 기준)
RANGE = {'EXEC': (12, 18), 'DEV': (22, 36), 'SHARE': (15, 22)}
KINDS = {'cover', 'agenda', 'section', 'kpi', 'cards', 'process', 'columns', 'list', 'table', 'roadmap', 'closing'}


def out(s):
    print(s, flush=True)


def odir(a):
    return os.path.join(os.environ.get('VM_INTRO_OUT') or os.path.join(ROOT, 'Doc', 'VMIntro'), a)


def rj(p, d=None):
    try:
        with open(p, encoding='utf-8-sig') as fh:
            return json.load(fh)
    except Exception:
        return d


def wj(p, o):
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, 'w', encoding='utf-8') as fh:
        json.dump(o, fh, ensure_ascii=False, indent=1)


def rel(p):
    return os.path.relpath(p, ROOT).replace(os.sep, '/')


def clean(label):
    """메뉴 이름 앞 그림 문자 제거"""
    return re.sub(r'^[^\w(]+', '', str(label or '')).strip()


# ───────────────────────── 사실 측정 ─────────────────────────
def facts():
    """VM 사실(측정값만). 키 = 'group.name', 값 = {v, unit, label, src}"""
    F = {}; now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M')

    def put(k, v, unit, label, src):
        F[k] = {'v': v, 'unit': unit, 'label': label, 'src': src}
    pk = rj(os.path.join(VM, 'package.json'), {}) or {}
    put('vm.version', pk.get('version', ''), '', 'VM 버전', 'tools/VibeManager/package.json')
    q = rj(os.path.join(VM, 'quick.json'), {}) or {}
    groups = q.get('groups', [])
    put('menu.groups', len(groups), '개', '메뉴 묶음', 'tools/VibeManager/quick.json')
    put('menu.items', sum(len(g.get('items', [])) for g in groups), '개', '메뉴 항목', 'tools/VibeManager/quick.json')
    put('vmw.jobs', sum(1 for g in groups for it in g.get('items', []) if it.get('batch') is True), '개', 'VMW 업무 종류', 'tools/VibeManager/quick.json')
    menus = [{'group': clean(g.get('title') or g.get('name')), 'items': [clean(it.get('label')) for it in g.get('items', [])]} for g in groups]
    st = (rj(os.path.join(VM, 'steps.json'), {}) or {}).get('steps', [])
    def walk(v):  # steps.json = 묶음 안에 단계(id, kind, title)
        if isinstance(v, dict):
            if 'id' in v and 'kind' in v and 'title' in v:
                yield v['id']
            for x in v.values():
                yield from walk(x)
        elif isinstance(v, list):
            for x in v:
                yield from walk(x)
    put('vm.steps', len(set(walk(st))), '개', '실행 단계 정의', 'tools/VibeManager/steps.json')
    put('vm.modules', len(glob.glob(os.path.join(VM, '*.js'))), '개', 'VM 코드 모듈', 'tools/VibeManager/*.js')
    put('vm.tests', len(glob.glob(os.path.join(VM, 'test', 't_*.js'))), '개', 'VM 자동 시험', 'tools/VibeManager/test')
    put('rule.hooks', len(glob.glob(os.path.join(ROOT, 'Doc', '_rules_v2', 'hooks', '*.md'))), '개', '작업 규칙 hook 문서', 'Doc/_rules_v2/hooks')
    put('rule.exec', len({os.path.splitext(os.path.basename(f))[0] for f in glob.glob(os.path.join(ROOT, '.claude', 'hooks', '*.ps1'))}), '개', '실행 hook(자동 차단)', '.claude/hooks')
    tr = os.path.join(ROOT, 'tools', 'Harness', 'rules', 'tobe_rule_registry.csv')
    try:
        with open(tr, encoding='utf-8-sig') as fh:
            put('rule.tobe', sum(1 for _ in csv.DictReader(fh)), '건', 'TO-BE 룰', rel(tr))
    except Exception:
        pass
    ur = rj(os.path.join(VM, 'user_rules.json'), {}) or {}
    put('rule.user', len(ur.get('items', [])) if isinstance(ur, dict) else 0, '건', '사용자 지적 규칙(VMO)', 'tools/VibeManager/user_rules.json')
    # 산출물
    def files(p, pat='*'):
        return [f for f in glob.glob(os.path.join(ROOT, p, pat)) if os.path.isfile(f)]
    cl = files('Doc/UI_CHECKLIST', '*CheckList*.xlsx')
    put('out.checklist_screens', len({re.match(r'([A-Z]{2,4}\d{4}(?:_\d+)?)', os.path.basename(f)).group(1) for f in cl if re.match(r'[A-Z]{2,4}\d{4}', os.path.basename(f))}), '개', 'CheckList 작성 화면', 'Doc/UI_CHECKLIST')
    put('out.analysis', len(files('Doc/화면분석서')), '개', '화면분석서 파일', 'Doc/화면분석서')
    put('out.design', len(files('Doc/화면설계서')), '개', '화면설계서 파일', 'Doc/화면설계서')
    put('out.user_manual', len(glob.glob(os.path.join(ROOT, 'Doc', 'UserManual', '*', '*.pptx'))), '개', '사용자 매뉴얼', 'Doc/UserManual')
    put('out.ops_manual', len(glob.glob(os.path.join(ROOT, 'Doc', 'OpsManual', '*', '*.pptx'))), '개', '운영자 매뉴얼', 'Doc/OpsManual')
    # VMO
    ev = os.path.join(ROOT, '.vibe', 'orch', 'events.jsonl')
    try:
        with open(ev, encoding='utf-8', errors='ignore') as fh:
            put('vmo.events', sum(1 for _ in fh), '건', 'VMO 감시 사건 기록', '.vibe/orch/events.jsonl')
    except Exception:
        pass
    put('vmo.incidents', len(glob.glob(os.path.join(ROOT, '.vibe', 'orch', 'incidents', '*.json'))), '건', 'VMO 사건', '.vibe/orch/incidents')
    pc = collections.Counter()
    for f in glob.glob(os.path.join(ROOT, '.vibe', 'orch', 'proposals', '*.json')):
        pc[(rj(f, {}) or {}).get('status', '?')] += 1
    put('vmo.proposals', sum(pc.values()), '건', 'VMO 개선안', '.vibe/orch/proposals')
    put('vmo.applied', pc.get('applied', 0), '건', 'VMO 개선안 반영', '.vibe/orch/proposals')
    try:  # 전환 대상 화면 = 사내 TO-BE 메뉴 중 사용 메뉴(상위까지 USE_YN Y + 사용 권한 그룹 연결)의 SCREEN
        sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
        from dbconn import connect
        with connect('tobe') as cx:
            cx.call_timeout = 60000; cur = cx.cursor()
            cur.execute("""SELECT COUNT(*) FROM (SELECT M.MNU_ID, M.MNU_TP_CD FROM SCM_MGR.SCM_ADM_MNU_M M
                            WHERE M.MNU_TP_CD <> 'SCREEN' OR EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M X JOIN SCM_MGR.SCM_ADM_USER_GR_M G ON G.USER_GR_ID = X.USER_GR_ID
                                                                   WHERE X.MNU_ID = M.MNU_ID AND NVL(X.USE_YN,'Y') = 'Y' AND NVL(G.USE_YN,'Y') = 'Y')
                            START WITH M.UPPR_MNU_ID IS NULL AND M.USE_YN = 'Y' CONNECT BY PRIOR M.MNU_ID = M.UPPR_MNU_ID AND M.USE_YN = 'Y') WHERE MNU_TP_CD = 'SCREEN'""")
            put('scope.screens', int(cur.fetchone()[0]), '개', '전환 대상 화면(사용 메뉴)', '사내 TO-BE SCM_ADM_MNU_M')
    except Exception as e:
        out(f'[WARN] 전환 대상 화면 수 측정 못 함(사내 DB): {str(e)[:120]} → 예상 효과 장표는 미측정으로 둠')
    jc = collections.Counter((rj(f, {}) or {}).get('status', '?') for f in glob.glob(os.path.join(ROOT, '.vibe', 'jobs', '*', 'job.json')))
    put('vmw.runs', sum(jc.values()), '건', 'VMW 작업 실행', '.vibe/jobs')
    return {'at': now, 'facts': F, 'menus': menus}


# ───────────────────────── 목표, 가정, 예상 효과 ─────────────────────────
# 2026-11-24 사용자: 목적 = 웹 개발자가 아닌 일반 사용자가 Vibe 도구로 웹 개발. 바이브 코딩 산출물 60~70% 수준 → VM 목표 95% 이상(사람 보정 없이 사용).
#   VMO 가 자가 진단, 자가 보완으로 산출물 수준을 올리고 오류를 줄임. 예상 효과 = 대체 가능 개발자 수(가정 기반 계산, 실측 아님)
GOALS = {'goal.vibe_low': (60, '%', '일반 바이브 코딩 산출물 수준(하한)'), 'goal.vibe_high': (70, '%', '일반 바이브 코딩 산출물 수준(상한)'), 'goal.vm': (95, '%', 'VM 목표 산출물 수준')}
ASSUME = {'assume.md_per_screen': ('mdPerScreen', 10, 'MD', '가정: 화면당 수작업 개발 공수'), 'assume.months': ('months', 12, '개월', '가정: 투입 기간'), 'assume.workdays': ('workdays', 20, '일', '가정: 월 근무일')}


def num(v, d):
    try:
        x = float(str(v).strip())
        return int(x) if x == int(x) else x
    except Exception:
        return d


def estimates(FX, inp):
    """예상 효과 = 측정(전환 대상 화면) × 가정(화면당 공수) × 목표(산출물 수준). 화면 수를 못 재면 계산하지 않음"""
    F = FX['facts']
    for k, (v, u, lb) in GOALS.items():
        F[k] = {'v': v, 'unit': u, 'label': lb, 'src': '사용자 목표(2026-11-24)', 'kind': 'goal'}
    for k, (name, d, u, lb) in ASSUME.items():
        F[k] = {'v': num(inp.get(name), d), 'unit': u, 'label': lb, 'src': 'VMW 입력(가정값)', 'kind': 'assume'}
    if 'scope.screens' not in F:
        return
    N = F['scope.screens']['v']; A = F['assume.md_per_screen']['v']; per = F['assume.months']['v'] * F['assume.workdays']['v']
    r1 = lambda x: round(x, 1) if round(x, 1) != int(x) else int(x)
    manual = N * A; vm = N * A * (100 - F['goal.vm']['v']) / 100
    vib_hi = N * A * (100 - F['goal.vibe_low']['v']) / 100; vib_lo = N * A * (100 - F['goal.vibe_high']['v']) / 100
    E = {'est.manual_md': (r1(manual), 'MD', '수작업 개발 공수'), 'est.vm_md': (r1(vm), 'MD', 'VM 사람 보정 공수'), 'est.saved_md': (r1(manual - vm), 'MD', '줄어드는 공수'),
         'est.person_md': (r1(per), 'MD', '개발자 1명 투입 기간 공수'), 'est.replace': (r1((manual - vm) / per), '명', '대체 가능 개발자(수작업 대비)'),
         'est.vibe_lo_md': (r1(vib_lo), 'MD', '바이브 코딩 사람 보정 공수(하한)'), 'est.vibe_hi_md': (r1(vib_hi), 'MD', '바이브 코딩 사람 보정 공수(상한)'),
         'est.replace_vs_vibe_lo': (r1((vib_lo - vm) / per), '명', '추가 대체 개발자(바이브 코딩 대비, 하한)'), 'est.replace_vs_vibe_hi': (r1((vib_hi - vm) / per), '명', '추가 대체 개발자(바이브 코딩 대비, 상한)')}
    for k, (v, u, lb) in E.items():
        F[k] = {'v': v, 'unit': u, 'label': lb, 'src': '예상 계산(측정 화면 수 × 가정 공수 × 목표 수준)', 'kind': 'est'}


def effect_slide(F):
    if 'est.replace' not in F:
        return {'kind': 'list', 'title': '예상 효과', 'items': ['전환 대상 화면 수 미측정(사내 DB 접속 실패). 예상 효과 계산 안 함']}
    v = lambda k: (f"{F[k]['v']:,}" if isinstance(F[k]['v'], (int, float)) else str(F[k]['v']))
    return {'kind': 'kpi', 'title': f"예상 효과: 개발자 {v('est.replace')}명 몫의 공수를 VM 이 처리함", 'lead': '예상(가정 기반 계산, 실측 아님). 가정값은 VMW 입력에서 바꿈',
            'kpis': [{'fact': 'est.replace', 'note': f"투입 기간 {v('assume.months')}개월 기준"}, {'fact': 'est.saved_md', 'note': f"전환 대상 화면 {v('scope.screens')}개 기준"},
                     {'fact': 'est.replace_vs_vibe_lo', 'note': f"바이브 코딩 대비 추가(하한), 상한 {v('est.replace_vs_vibe_hi')}명"}],
            'items': [f"계산: 화면 {v('scope.screens')}개 × 화면당 {v('assume.md_per_screen')} MD = 수작업 {v('est.manual_md')} MD. VM 사람 보정 = 수작업 × (1 − {v('goal.vm')}%) = {v('est.vm_md')} MD",
                      f"개발자 1명 = {v('assume.months')}개월 × {v('assume.workdays')}일 = {v('est.person_md')} MD. 대체 = (수작업 − VM 보정) ÷ 1명 공수",
                      f"바이브 코딩 사람 보정 = 수작업 × (1 − {v('goal.vibe_high')}%)~(1 − {v('goal.vibe_low')}%) = {v('est.vibe_lo_md')}~{v('est.vibe_hi_md')} MD"]}


# ───────────────────────── 초안(대상별 장 구성) ─────────────────────────
WINDOWS = [('VM', '메뉴와 체인 실행. 화면 단위 분석, 개발, 검증, 보완'), ('VMW', '업무 작업. 화면 묶음 처리, 모듈별 문서와 매뉴얼'), ('VMO', '감시와 자가 진단. 사건 감지, 원인, 보완, 다시 실행')]
FLOW = [('AS-IS 파싱', '원본 소스, DB 에서 사실 추출'), ('AS-IS 실측', '실제 화면을 띄워 동작 기록'), ('분석서, 설계서', '화면별 문서 생성'), ('개발', 'React, Spring Boot, Oracle'), ('CheckList', 'AS-IS 대조 판정'), ('보완', 'DB 객체 우선 수정 후 재판정')]


# 2026-11-24 사용자: 지금은 C#.NET → React 지만 PowerBuilder, Visual Basic, MiPlatform, XPlatform 등 4GL, X-Platform 을 AS-IS 로,
#   TO-BE 도 React 외에 고를 수 있게 하는 미래 로드맵
ROADMAP_MATRIX = {'kind': 'table', 'title': 'AS-IS 언어와 TO-BE 기술을 골라 전환하는 구조로 넓힘', 'table': {'columns': ['구분', '지금', '확장 대상'], 'rows': [
    ['AS-IS 화면', 'C#.NET WinForms', 'PowerBuilder, Visual Basic 6, MiPlatform, XPlatform, Nexacro, Delphi'],
    ['AS-IS DB', 'MS-SQL', 'Oracle, Sybase, Informix, DB2'],
    ['TO-BE 화면', 'React 18', 'React, Vue, Angular, Nexacro N, WebSquare'],
    ['TO-BE 서버', 'Spring Boot 3.5', 'Spring Boot, .NET, Node.js'],
    ['TO-BE DB', 'Oracle 19c', 'Oracle, PostgreSQL, MySQL, MS-SQL'],
    ['공통 기준', 'AS-IS 사실 원장, CheckList', '언어별 파서 + 공통 중간 표현(화면, 이벤트, SP, 메타)']]}}
ROADMAP = {'kind': 'roadmap', 'title': '미래 로드맵: 어떤 4GL, X-Platform 화면도 고른 TO-BE 로 전환', 'phases': [
    {'head': '지금', 'when': '진행 중', 'items': ['C#.NET WinForms → React, Spring Boot, Oracle', 'AS-IS 사실 원장, CheckList 판정, VMO 자가 보완']},
    {'head': '1단계', 'when': '파서 확장', 'items': ['PowerBuilder(PBL, DataWindow) 파서', 'Visual Basic(FRM, BAS) 파서', 'MiPlatform, XPlatform(XML 화면, 스크립트) 파서']},
    {'head': '2단계', 'when': '공통 중간 표현', 'items': ['화면, 그리드, 이벤트, SP 호출을 언어와 무관한 형식으로 저장', 'CheckList, 분석서를 중간 표현 기준으로 생성']},
    {'head': '3단계', 'when': 'TO-BE 선택', 'items': ['화면 기술: React, Vue, Nexacro N 중 선택', '서버, DB 기술 선택', '기술별 생성 규칙과 검사 규칙 묶음']},
    {'head': '4단계', 'when': '전환 서비스', 'items': ['프로젝트마다 AS-IS, TO-BE 조합 설정', '같은 검증 흐름으로 품질 확인']}]}


def draft(a, FX):
    if 'goal.vm' not in FX['facts']:  # 목표, 가정 없이 부르면 기본 가정값으로 채움
        estimates(FX, {})
    f = FX['facts']; menus = FX['menus']; K = lambda k: {'fact': k}
    cover = {'kind': 'cover', 'title': 'Vibe Manager', 'subtitle': 'GSCM → NSCM 전환 자동화 도구', 'tag': AUD[a]}
    kpi = {'kind': 'kpi', 'title': '한 화면에서 분석, 개발, 검증, 보완까지 이어서 실행함', 'kpis': [K('menu.items'), K('vmw.jobs'), K('out.checklist_screens'), K('vmo.applied')]}
    why = {'kind': 'columns', 'title': '화면 수작업 전환은 누락과 재작업을 만듦', 'left': {'head': '과제', 'items': ['AS-IS 화면 로직, SP, 메시지 누락', '화면마다 다른 개발 방식', '검증 결과를 사람이 모아 정리']},
           'right': {'head': 'VM 방식', 'items': ['AS-IS 사실을 먼저 추출해 기준 원장으로 씀', '규칙 문서와 실행 hook 으로 같은 방식 강제', 'CheckList 로 AS-IS 대조 판정 자동화']}}
    arch = {'kind': 'cards', 'title': '창 3개가 역할을 나눠 함께 움직임', 'cards': [{'head': n, 'text': t} for n, t in WINDOWS]}
    flow = {'kind': 'process', 'title': '화면 하나를 파싱부터 보완까지 한 흐름으로 처리함', 'steps': [{'name': n, 'text': t} for n, t in FLOW]}
    qual = {'kind': 'kpi', 'title': '규칙과 검사로 품질을 지킴', 'kpis': [K('rule.hooks'), K('rule.exec'), K('rule.tobe'), K('vm.tests')]}
    vmo = {'kind': 'process', 'title': 'VMO 가 스스로 진단하고 보완해 산출물 수준을 올림', 'lead': '사람이 오류를 찾고 고치지 않아도 VMO 오케스트라 에이전트가 개선을 이어감', 'steps': [{'name': '자가 진단', 'text': '실행 실패, 지연, 반복 오류 감지'}, {'name': '원인 분석', 'text': '로그, 단계 기록 분석'}, {'name': '자가 보완', 'text': '자동 등급은 바로 반영'}, {'name': '다시 실행', 'text': '그 화면 체인 재수행'}, {'name': '규칙화', 'text': '같은 문제 재발 방지'}],
           'kpis': [K('vmo.incidents'), K('vmo.proposals'), K('vmo.applied')]}
    outs = {'kind': 'kpi', 'title': '산출물을 같은 규칙으로 만듦', 'kpis': [K('out.analysis'), K('out.design'), K('out.user_manual'), K('out.ops_manual')]}
    nxt = {'kind': 'list', 'title': '다음 계획', 'items': ['작성 필요(AI 단계): 다음 계획']}
    end = {'kind': 'closing', 'title': 'Q&A', 'subtitle': 'Vibe Manager ' + str(f.get('vm.version', {}).get('v', ''))}
    agenda = {'kind': 'agenda', 'title': '목차', 'items': []}
    purpose = {'kind': 'cards', 'title': '목적: 웹 개발자가 아닌 사람도 웹 화면을 만듦', 'cards': [
        {'head': '누가', 'items': ['웹 개발자가 아닌 일반 사용자', 'Vibe 도구(VM)로 웹 화면 개발']},
        {'head': '무엇을', 'items': ['사람이 손보지 않아도 쓰는 산출물', f"산출물 수준 {f['goal.vm']['v']}% 이상 목표"]},
        {'head': '어떻게', 'items': ['VMO 자가 진단, 자가 보완', '쓸수록 산출물 수준이 오름']}]}
    background = {'kind': 'columns', 'title': '추진 배경: 바이브 코딩 산출물은 사람 손을 거쳐야 쓸 수 있음', 'left': {'head': '지금의 바이브 코딩', 'items': [
        f"산출물 수준 {f['goal.vibe_low']['v']}~{f['goal.vibe_high']['v']}%", '나머지는 개발자가 손봐야 사용 가능', '오류를 찾고 고치는 일은 사람 몫', '웹 개발을 모르는 사용자는 결과를 고칠 수 없음']},
        'right': {'head': 'VM 이 푸는 방식', 'items': ['AS-IS 사실, 규칙, 검사 기준을 먼저 세움', '규칙대로 만들고 CheckList 로 스스로 판정', 'VMO 가 오류를 찾아 보완하고 다시 실행', f"목표 산출물 수준 {f['goal.vm']['v']}% 이상"]}}
    compare = {'kind': 'table', 'title': '일반 바이브 코딩과 다른 점', 'table': {'columns': ['구분', '일반 바이브 코딩', 'VM'], 'rows': [
        ['산출물 수준', f"{f['goal.vibe_low']['v']}~{f['goal.vibe_high']['v']}%", f"{f['goal.vm']['v']}% 이상(목표)"],
        ['사람 보정', '개발자 보정 필요', '보정 없이 사용(목표)'],
        ['개발 주체', '웹 개발자', '일반 사용자(현업)'],
        ['품질 기준', '프롬프트와 사람 판단', 'AS-IS 사실 원장, 규칙 문서, 실행 hook, CheckList'],
        ['오류 개선', '사람이 찾아 고침', 'VMO 자가 진단, 자가 보완, 다시 실행'],
        ['반복할수록', '같은 실수 반복', '사용자 지적을 규칙으로 쌓아 재발 방지']]}}
    effect = effect_slide(f)
    if a == 'EXEC':
        sl = [cover, purpose, background, compare, kpi, arch, flow, qual, vmo, effect, ROADMAP_MATRIX, ROADMAP, nxt, end]
    elif a == 'SHARE':
        sl = [cover, agenda, purpose, background, compare, arch, flow, {'kind': 'section', 'title': '품질과 자가 개선'}, qual, vmo, outs, kpi, effect, {'kind': 'section', 'title': '미래 로드맵'}, ROADMAP_MATRIX, ROADMAP, nxt, {'kind': 'list', 'title': '도입 방법', 'items': ['작성 필요(AI 단계): 도입 방법']}, end]
    else:
        menu_sl = [{'kind': 'list', 'title': f'메뉴 - {m["group"]}', 'items': m['items'][:14], 'note': f'{len(m["items"])}개'} for m in menus]
        sl = [cover, agenda, purpose, compare, arch, {'kind': 'section', 'title': '메뉴'}] + menu_sl + [flow, {'kind': 'section', 'title': '작업 방법'},
              {'kind': 'list', 'title': '화면 하나 처리 순서', 'items': ['작성 필요(AI 단계)']}, {'kind': 'list', 'title': 'VMW 업무 실행', 'items': ['작성 필요(AI 단계)']},
              {'kind': 'list', 'title': '환경설정', 'items': ['작성 필요(AI 단계)']}, qual, vmo, {'kind': 'list', 'title': '자주 생기는 문제와 조치', 'items': ['작성 필요(AI 단계)']}, outs, {'kind': 'section', 'title': '미래 로드맵'}, ROADMAP_MATRIX, ROADMAP, end]
    for s in sl:
        if s['kind'] == 'agenda':
            s['items'] = [x['title'] for x in sl if x['kind'] == 'section'] or [x['title'] for x in sl if x['kind'] not in ('cover', 'agenda', 'closing')][:8]
    return {'audience': a, 'title': 'Vibe Manager 소개', 'slides': [dict(s) for s in sl]}


# ───────────────────────── 검사 ─────────────────────────
TECH_VER = re.compile(r'(?i)(React|Vue|Angular|Spring Boot|Oracle|Java|Node\.js|PostgreSQL|MySQL|Visual Basic|Delphi|PowerBuilder|Nexacro|\.NET)\s*\d+(?:\.\d+)*\w*')  # 기술 이름 뒤 버전 = 측정 수치 아님
NUM = re.compile(r'(?<![\w.,])(\d{1,3}(?:,\d{3})+(?:\.\d+)?|\d{2,}(?:\.\d+)?)(?![\w.])')  # 천 단위 쉼표 숫자(1,370)는 통째로 읽음


def check(a, c, FX):
    fails = []; F = FX['facts']; S = c.get('slides') or []
    lo, hi = RANGE[a]
    if not lo <= len(S) <= hi:
        fails.append(f'장 수 {len(S)}장. {AUD[a]} = {lo}~{hi}장')
    if not S or S[0].get('kind') != 'cover':
        fails.append('첫 장 = cover')
    allowed = {str(v['v']) for v in F.values()} | {f"{v['v']:,}" for v in F.values() if isinstance(v['v'], (int, float))}
    texts = []
    for i, s in enumerate(S, 1):
        k = s.get('kind'); tag = f'{i}장 {s.get("title", "")[:30]}'
        if k not in KINDS:
            fails.append(f'{tag}: kind {k} 없음({", ".join(sorted(KINDS))})')
        if not str(s.get('title', '')).strip():
            fails.append(f'{tag}: 제목 없음')
        for kp in s.get('kpis') or []:
            if kp.get('fact') not in F:
                fails.append(f'{tag}: 수치 카드 fact 키 없음 {kp.get("fact")}(facts.json 키만, 값은 쓰지 않음)')
            if 'value' in kp:
                fails.append(f'{tag}: 수치 카드에 value 직접 씀. fact 키만 씀')
        body = [s.get('title', ''), s.get('subtitle', ''), s.get('lead', '')] + [str(x) for x in s.get('items') or []] + [str(x.get('text', '')) + ' ' + str(x.get('head', '')) for x in s.get('cards') or []] + \
               [str(x.get('name', '')) + ' ' + str(x.get('text', '')) for x in s.get('steps') or []] + [str(x) for side in ('left', 'right') for x in (s.get(side) or {}).get('items', [])] + [' '.join(map(str, r)) for r in (s.get('table') or {}).get('rows', [])] + [str(x.get('head', '')) + ' ' + str(x.get('when', '')) + ' ' + ' '.join(map(str, x.get('items', []))) for x in s.get('phases') or []]
        for t in body:
            if '작성 필요' in t:
                fails.append(f'{tag}: 초안 문구(작성 필요) 남음')
            for n in NUM.findall(TECH_VER.sub(' ', str(t))):
                if n not in allowed and not re.fullmatch(r'20\d\d', n):
                    fails.append(f'{tag}: 본문 숫자 {n} 이 facts.json 측정값에 없음(감, 예측 수치 금지)')
        texts += [t for t in body if t]
    try:
        sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
        import doc_style
        hits = [h for t in texts for h in (doc_style.check_text(str(t)) or [])]
        if hits:
            fails.append(f'문장 규칙 위반 {len(hits)}건(50_DOC_STYLE): {str(hits[:3])[:300]}')
    except Exception as e:
        out(f'문장 검사 못 함(계속): {e}')
    return fails


# ───────────────────────── 디자인(비즈니스 제안서) ─────────────────────────
NAVY, NAVY2, TEAL, AMBER, INK, SUB, LIGHT, WHITE, LINE = '0B1F3A', '16325C', '00A3A1', 'F2A900', '1F2937', '6B7280', 'F3F6FA', 'FFFFFF', 'D6DCE5'


class Deck:
    def __init__(self, font, gslides=False):
        from pptx import Presentation
        from pptx.util import Inches
        self.prs = Presentation(); self.prs.slide_width = Inches(13.333); self.prs.slide_height = Inches(7.5)
        self.W, self.H = self.prs.slide_width, self.prs.slide_height; self.font = font; self.gs = gslides; self.n = 0

    def rgb(self, h):
        from pptx.dml.color import RGBColor
        return RGBColor.from_string(h)

    def blank(self, bg=WHITE):
        s = self.prs.slides.add_slide(self.prs.slide_layouts[6]); self.n += 1
        s.background.fill.solid(); s.background.fill.fore_color.rgb = self.rgb(bg)
        return s

    def rect(self, s, x, y, w, h, fill, line=None, round_=False):
        from pptx.enum.shapes import MSO_SHAPE
        from pptx.util import Pt
        sh = s.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE if round_ else MSO_SHAPE.RECTANGLE, int(x), int(y), int(w), int(h))
        if round_:
            sh.adjustments[0] = 0.08
        sh.fill.solid(); sh.fill.fore_color.rgb = self.rgb(fill)
        if line:
            sh.line.color.rgb = self.rgb(line); sh.line.width = Pt(1)
        else:
            sh.line.fill.background()
        sh.shadow.inherit = False
        return sh

    def text(self, s, x, y, w, h, lines, size=14, color=INK, bold=False, align='l', anchor='t', spacing=1.15):
        from pptx.util import Pt
        from pptx.enum.text import PP_ALIGN, MSO_ANCHOR
        tb = s.shapes.add_textbox(int(x), int(y), int(w), int(h)); tf = tb.text_frame; tf.word_wrap = True
        tf.margin_left = tf.margin_right = Pt(2); tf.margin_top = tf.margin_bottom = Pt(1)
        tf.vertical_anchor = {'t': MSO_ANCHOR.TOP, 'm': MSO_ANCHOR.MIDDLE, 'b': MSO_ANCHOR.BOTTOM}[anchor]
        for i, ln in enumerate(lines if isinstance(lines, list) else [lines]):
            if isinstance(ln, tuple):
                t, sz, col, b = ln
            else:
                t, sz, col, b = ln, size, color, bold
            p = tf.paragraphs[0] if i == 0 else tf.add_paragraph()
            p.alignment = {'l': PP_ALIGN.LEFT, 'c': PP_ALIGN.CENTER, 'r': PP_ALIGN.RIGHT}[align]; p.line_spacing = spacing
            r = p.add_run(); r.text = str(t); r.font.size = Pt(sz); r.font.bold = b; r.font.color.rgb = self.rgb(col); r.font.name = self.font
            rPr = r._r.get_or_add_rPr()
            for tag in ('a:ea', 'a:cs'):  # 한글 글꼴(동아시아) 같이 지정
                from pptx.oxml.ns import qn
                el = rPr.find(qn(tag))
                if el is None:
                    el = rPr.makeelement(qn(tag), {}); rPr.append(el)
                el.set('typeface', self.font)
        return tb

    def value(self, s, x, y, w, h, v, unit, size, color):
        """큰 숫자 + 작은 단위 한 줄(예: 78개)"""
        from pptx.util import Pt
        from pptx.oxml.ns import qn
        tb = s.shapes.add_textbox(int(x), int(y), int(w), int(h)); tf = tb.text_frame; tf.word_wrap = False
        p = tf.paragraphs[0]
        for t, sz in ((v, size), (unit, int(size * 0.4))):
            if not t:
                continue
            r = p.add_run(); r.text = str(t); r.font.size = Pt(sz); r.font.bold = True; r.font.color.rgb = self.rgb(color); r.font.name = self.font
            rPr = r._r.get_or_add_rPr()
            for tag in ('a:ea', 'a:cs'):
                el = rPr.find(qn(tag))
                if el is None:
                    el = rPr.makeelement(qn(tag), {}); rPr.append(el)
                el.set('typeface', self.font)
        return tb

    def frame(self, sl, section=''):
        """본문 장 공통: 왼쪽 위 구역 이름(청록), 헤드라인 제목, 가는 선, 오른쪽 아래 쪽 번호와 이름"""
        from pptx.util import Inches
        s = self.blank()
        self.rect(s, 0, 0, Inches(0.18), self.H, NAVY)
        if section:
            self.text(s, Inches(0.6), Inches(0.35), Inches(8), Inches(0.35), section.upper(), 11, TEAL, True)
        self.text(s, Inches(0.6), Inches(0.62), Inches(12.1), Inches(0.9), sl.get('title', ''), 26, NAVY, True)
        self.rect(s, Inches(0.6), Inches(1.5), Inches(1.2), Inches(0.05), TEAL)
        if sl.get('lead'):
            self.text(s, Inches(0.6), Inches(1.65), Inches(12.1), Inches(0.5), sl['lead'], 14, SUB)
        self.text(s, Inches(9.5), Inches(7.0), Inches(3.4), Inches(0.3), f'Vibe Manager  |  {self.n}', 10, SUB, False, 'r')
        return s

    def body_top(self, sl):
        from pptx.util import Inches
        return Inches(2.35) if sl.get('lead') else Inches(1.95)


def kpi_val(F, k):
    x = F.get(k) or {}
    v = x.get('v', '')
    return (f'{v:,}' if isinstance(v, (int, float)) and not isinstance(v, bool) else str(v)), x.get('unit', ''), x.get('label', k)


def render_pptx(c, FX, path, font, gslides=False):
    from pptx.util import Inches, Pt
    D = Deck(font, gslides); F = FX['facts']; sec = ''
    for sl in c['slides']:
        k = sl.get('kind')
        if k == 'cover':
            s = D.blank(NAVY)
            D.rect(s, 0, Inches(5.6), D.W, Inches(1.9), NAVY2)
            D.rect(s, Inches(0.8), Inches(2.0), Inches(0.12), Inches(2.2), TEAL)
            D.text(s, Inches(1.15), Inches(1.9), Inches(11), Inches(0.5), sl.get('tag', ''), 14, AMBER, True)
            D.text(s, Inches(1.15), Inches(2.4), Inches(11), Inches(1.2), sl.get('title', ''), 48, WHITE, True)
            D.text(s, Inches(1.15), Inches(3.55), Inches(11), Inches(0.7), sl.get('subtitle', ''), 20, 'C9D3E3')
            D.text(s, Inches(1.15), Inches(6.0), Inches(11), Inches(0.9), [(c.get('_author', ''), 14, WHITE, True), (c.get('_date', ''), 12, 'C9D3E3', False)], 14)
            continue
        if k == 'closing':
            s = D.blank(NAVY)
            D.text(s, 0, Inches(2.7), D.W, Inches(1.2), sl.get('title', ''), 54, WHITE, True, 'c')
            D.rect(s, D.W / 2 - Inches(0.6), Inches(3.95), Inches(1.2), Inches(0.06), TEAL)
            D.text(s, 0, Inches(4.2), D.W, Inches(0.6), sl.get('subtitle', ''), 16, 'C9D3E3', False, 'c')
            continue
        if k == 'section':
            sec = sl.get('title', '')
            s = D.blank(LIGHT)
            D.rect(s, 0, 0, Inches(5.2), D.H, NAVY)
            D.text(s, Inches(0.8), Inches(3.0), Inches(4.2), Inches(1.2), sec, 32, WHITE, True)
            D.rect(s, Inches(0.8), Inches(4.25), Inches(1.0), Inches(0.06), TEAL)
            if sl.get('lead'):
                D.text(s, Inches(5.9), Inches(3.1), Inches(6.8), Inches(1.5), sl['lead'], 18, INK)
            continue
        s = D.frame(sl, sec); top = D.body_top(sl); L = Inches(0.6); RW = Inches(12.1)
        if k == 'agenda':
            items = sl.get('items', [])
            for i, it in enumerate(items):
                y = top + i * Inches(0.62)
                D.rect(s, L, y, Inches(0.55), Inches(0.48), NAVY, round_=True)
                D.text(s, L, y, Inches(0.55), Inches(0.48), f'{i + 1:02d}', 14, WHITE, True, 'c', 'm')
                D.text(s, L + Inches(0.8), y, Inches(10), Inches(0.48), it, 18, INK, False, 'l', 'm')
        elif k == 'kpi':
            kp = sl.get('kpis', []); n = max(1, len(kp)); gap = Inches(0.3); cw = (RW - gap * (n - 1)) / n
            ch = Inches(2.9); extra = Inches(0.6) * len(sl.get('items') or [])
            top = top + max(0, (Inches(6.8) - top - ch - extra) / 2)  # 본문 영역 세로 가운데
            for i, x in enumerate(kp):
                v, u, lb = kpi_val(F, x.get('fact'))
                cx = L + i * (cw + gap)
                D.rect(s, cx, top, cw, ch, LIGHT, round_=True)
                D.rect(s, cx, top, cw, Inches(0.08), TEAL)
                D.value(s, cx + Inches(0.35), top + Inches(0.45), cw - Inches(0.7), Inches(1.3), v, u, 54, NAVY)
                D.text(s, cx + Inches(0.35), top + Inches(1.85), cw - Inches(0.7), Inches(0.9), [(lb, 16, INK, True), (x.get('note', ''), 12, SUB, False)], 16)
            if sl.get('items'):
                D.text(s, L, top + ch + Inches(0.45), RW, extra, ['· ' + str(t) for t in sl['items']], 16, INK, spacing=1.3)
        elif k == 'cards':
            cs = sl.get('cards', []); n = max(1, len(cs)); gap = Inches(0.3); cw = (RW - gap * (n - 1)) / n
            import ops_draw as DR
            nl = max([sum(max(1, -(-DR.tw(str(t), 15) // int(cw - Inches(0.5)))) for t in (x.get('items') or [x.get('text', '')])) for x in cs] or [1])
            ch = min(Inches(4.6), Inches(1.5) + Inches(0.36) * nl); top = top + max(0, (Inches(6.8) - top - ch) / 2)
            for i, x in enumerate(cs):
                cx = L + i * (cw + gap)
                D.rect(s, cx, top, cw, ch, WHITE, LINE, round_=True)
                D.rect(s, cx, top, cw, Inches(0.9), NAVY if i % 2 == 0 else NAVY2, round_=False)
                D.text(s, cx + Inches(0.25), top, cw - Inches(0.5), Inches(0.9), x.get('head', ''), 22, WHITE, True, 'l', 'm')
                D.text(s, cx + Inches(0.25), top + Inches(1.1), cw - Inches(0.5), ch - Inches(1.3), [str(t) for t in (x.get('items') or [x.get('text', '')])], 15, INK)
        elif k == 'process':
            from pptx.enum.shapes import MSO_SHAPE
            st = sl.get('steps', []); n = max(1, len(st)); gap = Inches(0.08); cw = (RW - gap * (n - 1)) / n
            if not sl.get('kpis') and not sl.get('items'):
                top = top + max(0, (Inches(6.8) - top - Inches(2.6)) / 2)
            import ops_draw as DR
            npt = min(DR.fit_pt(str(x.get('name', '')), int(cw - Inches(0.6)), 16, 10) for x in st) if st else 15
            for i, x in enumerate(st):
                cx = L + i * (cw + gap)
                sh = s.shapes.add_shape(MSO_SHAPE.CHEVRON if i else MSO_SHAPE.PENTAGON, int(cx), int(top), int(cw), int(Inches(0.9)))
                sh.adjustments[0] = 0.3; sh.fill.solid(); sh.fill.fore_color.rgb = D.rgb(NAVY if i % 2 == 0 else TEAL); sh.line.fill.background(); sh.shadow.inherit = False
                D.text(s, cx + Inches(0.3), top, cw - Inches(0.55), Inches(0.9), x.get('name', ''), npt, WHITE, True, 'c', 'm')
                D.text(s, cx + Inches(0.1), top + Inches(1.1), cw - Inches(0.2), Inches(1.6), x.get('text', ''), 14, INK, False, 'c')
            kp = sl.get('kpis') or []
            if kp:
                y2 = top + Inches(2.9); n2 = len(kp); cw2 = (RW - Inches(0.3) * (n2 - 1)) / n2
                for i, x in enumerate(kp):
                    v, u, lb = kpi_val(F, x.get('fact')); cx = L + i * (cw2 + Inches(0.3))
                    D.rect(s, cx, y2, cw2, Inches(1.5), LIGHT, round_=True)
                    D.value(s, cx + Inches(0.3), y2 + Inches(0.15), cw2 - Inches(0.6), Inches(0.8), v, u, 36, TEAL)
                    D.text(s, cx + Inches(0.3), y2 + Inches(0.95), cw2 - Inches(0.6), Inches(0.45), lb, 14, INK, True)
            if sl.get('items'):
                D.text(s, L, top + Inches(4.6), RW, Inches(1), ['· ' + str(t) for t in sl['items']], 14, INK)
        elif k == 'columns':
            cw = (RW - Inches(0.4)) / 2
            nl = max(len((sl.get(sd) or {}).get('items', [])) for sd in ('left', 'right'))
            chh = min(Inches(4.6), Inches(1.4) + Inches(0.5) * nl); top = top + max(0, (Inches(6.8) - top - chh) / 2)
            for j, side in enumerate(('left', 'right')):
                x = sl.get(side) or {}; cx = L + j * (cw + Inches(0.4))
                D.rect(s, cx, top, cw, chh, LIGHT if j == 0 else WHITE, None if j == 0 else TEAL, round_=True)
                D.text(s, cx + Inches(0.35), top + Inches(0.25), cw - Inches(0.7), Inches(0.6), x.get('head', ''), 20, NAVY if j == 0 else TEAL, True)
                D.text(s, cx + Inches(0.35), top + Inches(0.95), cw - Inches(0.7), Inches(3.3), ['· ' + str(t) for t in x.get('items', [])], 16, INK, spacing=1.35)
        elif k == 'list':
            items = [str(t) for t in sl.get('items', [])]; two = len(items) > 7
            per = (len(items) + 1) // 2 if two else len(items); cw = (RW - Inches(0.4)) / 2 if two else RW
            for j in range(2 if two else 1):
                part = items[j * per:(j + 1) * per]; cx = L + j * (cw + Inches(0.4))
                for i, t in enumerate(part):
                    y = top + i * Inches(0.6)
                    D.rect(s, cx, y + Inches(0.17), Inches(0.14), Inches(0.14), TEAL)
                    D.text(s, cx + Inches(0.3), y, cw - Inches(0.3), Inches(0.55), t, 15 if two else 17, INK, False, 'l', 'm')
            if sl.get('note'):
                D.text(s, L, Inches(6.55), RW, Inches(0.35), sl['note'], 12, SUB)
        elif k == 'roadmap':  # 단계 열(위 = 단계 이름 띠, 가운데 = 시간 축 점, 아래 = 항목 카드)
            ph = sl.get('phases', []); n = max(1, len(ph)); gap = Inches(0.2); cw = (RW - gap * (n - 1)) / n
            D.rect(s, L, top + Inches(1.05), RW, Inches(0.05), LINE)
            for i, x in enumerate(ph):
                cx = L + i * (cw + gap); cur = i == 0
                D.rect(s, cx, top, cw, Inches(0.75), TEAL if cur else NAVY, round_=True)
                D.text(s, cx, top, cw, Inches(0.75), [(x.get('head', ''), 18, WHITE, True)], 18, WHITE, True, 'c', 'm')
                from pptx.enum.shapes import MSO_SHAPE
                dot = s.shapes.add_shape(MSO_SHAPE.OVAL, int(cx + cw / 2 - Inches(0.11)), int(top + Inches(0.97)), int(Inches(0.22)), int(Inches(0.22)))
                dot.fill.solid(); dot.fill.fore_color.rgb = D.rgb(AMBER if cur else TEAL); dot.line.fill.background(); dot.shadow.inherit = False
                D.text(s, cx, top + Inches(1.25), cw, Inches(0.4), x.get('when', ''), 13, TEAL if not cur else AMBER, True, 'c')
                D.rect(s, cx, top + Inches(1.7), cw, Inches(3.0), LIGHT, round_=True)
                D.text(s, cx + Inches(0.15), top + Inches(1.85), cw - Inches(0.3), Inches(2.8), ['· ' + str(t) for t in x.get('items', [])], 12, INK, spacing=1.25)
        elif k == 'table':
            tb = sl.get('table') or {}; cols = tb.get('columns', []); rows = tb.get('rows', [])
            t = s.shapes.add_table(len(rows) + 1, max(1, len(cols)), int(L), int(top), int(RW), int(Inches(0.45) * (len(rows) + 1))).table
            for j, cn in enumerate(cols):
                cell = t.cell(0, j); cell.text = str(cn); cell.fill.solid(); cell.fill.fore_color.rgb = D.rgb(NAVY)
                for p in cell.text_frame.paragraphs:
                    for r in p.runs:
                        r.font.size = Pt(13); r.font.bold = True; r.font.color.rgb = D.rgb(WHITE); r.font.name = font
            for i, r0 in enumerate(rows, 1):
                for j in range(len(cols)):
                    cell = t.cell(i, j); cell.text = str(r0[j] if j < len(r0) else ''); cell.fill.solid(); cell.fill.fore_color.rgb = D.rgb(LIGHT if i % 2 else WHITE)
                    for p in cell.text_frame.paragraphs:
                        for r in p.runs:
                            r.font.size = Pt(12); r.font.color.rgb = D.rgb(INK); r.font.name = font
        if sl.get('notes'):
            s.notes_slide.notes_text_frame.text = str(sl['notes'])
    os.makedirs(os.path.dirname(path), exist_ok=True)
    D.prs.save(path)
    return D.n


def render_html(c, FX, path):
    """브라우저 발표용 HTML 한 파일(16:9, ← → 키로 넘김)"""
    import html as H
    F = FX['facts']; e = lambda x: H.escape(str(x or ''))
    css = ("*{box-sizing:border-box;margin:0}body{background:#111;font-family:'Noto Sans KR','Malgun Gothic',sans-serif}"
           ".s{width:100vw;height:56.25vw;max-height:100vh;max-width:177.78vh;margin:auto;position:absolute;inset:0;display:none;background:#fff;padding:4vw 5vw;color:#1F2937;overflow:hidden}"
           ".s.on{display:block}.s:before{content:'';position:absolute;left:0;top:0;bottom:0;width:1.2vw;background:#0B1F3A}"
           ".dark{background:#0B1F3A;color:#fff}.dark:before{display:none}.sec{color:#00A3A1;font-weight:700;font-size:1vw;letter-spacing:.1em}"
           "h1{font-size:2.3vw;color:#0B1F3A;margin:.4vw 0 .8vw}.bar{width:8vw;height:.35vw;background:#00A3A1;margin-bottom:1.6vw}"
           ".dark h1{color:#fff;font-size:4.2vw}.tag{color:#F2A900;font-weight:700;font-size:1.2vw}.sub{color:#C9D3E3;font-size:1.6vw}"
           ".row{display:flex;gap:1.6vw}.card{flex:1;background:#F3F6FA;border-radius:.8vw;padding:1.6vw;border-top:.5vw solid #00A3A1}"
           ".v{font-size:3.6vw;font-weight:800;color:#0B1F3A}.lb{font-weight:700;margin-top:.6vw;font-size:1.2vw}"
           ".chev{flex:1;background:#0B1F3A;color:#fff;font-weight:700;text-align:center;padding:1.2vw .5vw;clip-path:polygon(0 0,88% 0,100% 50%,88% 100%,0 100%,12% 50%);font-size:1.1vw}"
           ".chev:nth-child(even){background:#00A3A1}.st{flex:1;text-align:center;font-size:1vw;padding:.8vw .4vw}"
           "ul{font-size:1.4vw;line-height:2.1}li{list-style:none;padding-left:1.4vw;position:relative}li:before{content:'';position:absolute;left:0;top:.9vw;width:.6vw;height:.6vw;background:#00A3A1}"
           "table{border-collapse:collapse;width:100%;font-size:1.05vw}th{background:#0B1F3A;color:#fff;padding:.6vw}td{padding:.5vw;border-bottom:1px solid #D6DCE5}"
           ".pg{position:absolute;right:2vw;bottom:1.2vw;color:#6B7280;font-size:.9vw}")
    out_ = []; sec = ''; n = 0

    def kp(x):
        v, u, lb = kpi_val(F, x.get('fact'))
        return f'<div class="card"><div class="v">{e(v)}<span style="font-size:1.4vw">{e(u)}</span></div><div class="lb">{e(lb)}</div></div>'
    for sl in c['slides']:
        k = sl.get('kind'); n += 1
        if k == 'cover':
            out_.append(f'<section class="s dark"><div style="margin-top:9vw;border-left:.8vw solid #00A3A1;padding-left:2vw"><div class="tag">{e(sl.get("tag"))}</div><h1>{e(sl.get("title"))}</h1><div class="sub">{e(sl.get("subtitle"))}</div></div><div style="position:absolute;bottom:4vw;left:7vw"><b>{e(c.get("_author"))}</b><div class="sub" style="font-size:1.1vw">{e(c.get("_date"))}</div></div></section>'); continue
        if k == 'closing':
            out_.append(f'<section class="s dark" style="text-align:center"><h1 style="margin-top:14vw">{e(sl.get("title"))}</h1><div class="sub">{e(sl.get("subtitle"))}</div></section>'); continue
        if k == 'section':
            sec = sl.get('title', ''); out_.append(f'<section class="s dark"><h1 style="margin-top:15vw">{e(sec)}</h1><div class="bar"></div></section>'); continue
        b = ''
        if k == 'agenda':
            b = '<ul>' + ''.join(f'<li>{i + 1:02d}  {e(t)}</li>' for i, t in enumerate(sl.get('items', []))) + '</ul>'
        elif k == 'kpi':
            b = '<div class="row">' + ''.join(kp(x) for x in sl.get('kpis', [])) + '</div>' + ('<ul style="margin-top:2vw">' + ''.join(f'<li>{e(t)}</li>' for t in sl.get('items', [])) + '</ul>' if sl.get('items') else '')
        elif k == 'cards':
            b = '<div class="row">' + ''.join(f'<div class="card" style="border-top-color:#0B1F3A"><div class="lb" style="font-size:1.6vw">{e(x.get("head"))}</div><p style="font-size:1.2vw;margin-top:1vw">{e(x.get("text"))}</p></div>' for x in sl.get('cards', [])) + '</div>'
        elif k == 'process':
            st = sl.get('steps', [])
            b = '<div class="row" style="gap:.3vw">' + ''.join(f'<div class="chev">{e(x.get("name"))}</div>' for x in st) + '</div><div class="row" style="gap:.3vw">' + ''.join(f'<div class="st">{e(x.get("text"))}</div>' for x in st) + '</div>'
            if sl.get('kpis'):
                b += '<div class="row" style="margin-top:2vw">' + ''.join(kp(x) for x in sl['kpis']) + '</div>'
        elif k == 'columns':
            b = '<div class="row">' + ''.join(f'<div class="card"><div class="lb" style="font-size:1.6vw">{e((sl.get(sd) or {}).get("head"))}</div><ul>' + ''.join(f'<li>{e(t)}</li>' for t in (sl.get(sd) or {}).get('items', [])) + '</ul></div>' for sd in ('left', 'right')) + '</div>'
        elif k == 'list':
            b = '<ul>' + ''.join(f'<li>{e(t)}</li>' for t in sl.get('items', [])) + '</ul>' + (f'<div class="pg" style="left:5vw;right:auto">{e(sl.get("note"))}</div>' if sl.get('note') else '')
        elif k == 'roadmap':
            b = '<div class="row" style="gap:1vw">' + ''.join(f'<div style="flex:1"><div class="chev" style="clip-path:none;border-radius:.6vw;{"background:#00A3A1" if i == 0 else "background:#0B1F3A"}">{e(x.get("head"))}</div><div style="text-align:center;color:#00A3A1;font-weight:700;margin:.6vw 0;font-size:1vw">{e(x.get("when"))}</div><div class="card" style="border-top:none"><ul style="font-size:.95vw;line-height:1.6">' + ''.join(f'<li>{e(t)}</li>' for t in x.get('items', [])) + '</ul></div></div>' for i, x in enumerate(sl.get('phases', []))) + '</div>'
        elif k == 'table':
            tb = sl.get('table') or {}
            b = '<table><tr>' + ''.join(f'<th>{e(x)}</th>' for x in tb.get('columns', [])) + '</tr>' + ''.join('<tr>' + ''.join(f'<td>{e(x)}</td>' for x in r) + '</tr>' for r in tb.get('rows', [])) + '</table>'
        lead = f'<p style="font-size:1.3vw;color:#6B7280;margin-bottom:1.4vw">{e(sl.get("lead"))}</p>' if sl.get('lead') else ''
        out_.append(f'<section class="s"><div class="sec">{e(sec)}</div><h1>{e(sl.get("title"))}</h1><div class="bar"></div>{lead}{b}<div class="pg">Vibe Manager | {n}</div></section>')
    js = "let i=0;const S=[...document.querySelectorAll('.s')];const go=k=>{S[i].classList.remove('on');i=Math.max(0,Math.min(S.length-1,k));S[i].classList.add('on')};S[0].classList.add('on');document.onkeydown=ev=>{if(['ArrowRight','PageDown',' '].includes(ev.key))go(i+1);if(['ArrowLeft','PageUp'].includes(ev.key))go(i-1)};document.onclick=()=>go(i+1);"
    doc = f'<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>{e(c.get("title"))}</title><style>{css}</style></head><body>{"".join(out_)}<script>{js}</script></body></html>'
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as fh:
        fh.write(doc)
    return len(out_)


def to_pdf(pptx, pdf):
    """PowerPoint 로 PDF 저장. 사용자가 연 다른 프레젠테이션이 있으면 PowerPoint 를 끄지 않음"""
    ps = ("$pp=New-Object -ComObject PowerPoint.Application;$p=$pp.Presentations.Open('" + pptx.replace("'", "''") + "',$true,$false,$false);"
          "$p.SaveAs('" + pdf.replace("'", "''") + "',32);$p.Close();if($pp.Presentations.Count -eq 0){$pp.Quit()}")
    r = subprocess.run(['powershell', '-NoProfile', '-Command', ps], capture_output=True, text=True, timeout=300)
    return os.path.exists(pdf), (r.stderr or '').strip()[:300]


# ───────────────────────── 명령 ─────────────────────────
def inputs_of(a):
    inp = rj(os.path.join(odir(a), '_inputs.json'), {}) or {}
    fm = inp.get('formats') or ['pptx']
    if isinstance(fm, str):
        fm = [x.strip() for x in re.split(r'[,\n]', fm) if x.strip()]
    inp['formats'] = [x for x in fm if x in FORMATS] or ['pptx']
    return inp


def cmd_prep(a):
    d = odir(a.module); FX = facts(); estimates(FX, inputs_of(a.module)); wj(os.path.join(d, 'facts.json'), FX)
    wj(os.path.join(d, 'content', AUTO), draft(a.module, FX))
    kc = collections.Counter(v.get('kind', 'measure') for v in FX['facts'].values())
    out(f'[OK] prep {a.module}({AUD[a.module]}): facts.json 측정 {kc["measure"]}개({FX["at"]}), 사용자 목표 {kc["goal"]}개, 가정 {kc["assume"]}개, 예상 계산 {kc["est"]}개, 메뉴 묶음 {len(FX["menus"])}개, content/{AUTO}')
    for k, v in FX['facts'].items():
        out(f'      {k} = {v["v"]}{v["unit"]} ({v["label"]}, {v["src"]})')
    return 0


def load(a):
    d = odir(a)
    c = rj(os.path.join(d, 'content', MAIN)); return (c, MAIN) if c else (rj(os.path.join(d, 'content', AUTO)), AUTO)


def cmd_check(a):
    d = odir(a.module); FX = rj(os.path.join(d, 'facts.json'))
    if not FX:
        out('[FAIL] facts.json 없음. prep 먼저'); return 2
    c, name = load(a.module)
    if not c:
        out('[FAIL] 내용 없음'); return 2
    fails = check(a.module, c, FX)
    for f in fails:
        out(f'[FAIL] {f}')
    out(f'[{"OK" if not fails else "FAIL"}] check {a.module}: 장표 {len(c.get("slides") or [])}장, 실패 {len(fails)} · 내용 {name}')
    return 0 if not fails else 3


def cmd_build(a):
    d = odir(a.module); FX = rj(os.path.join(d, 'facts.json'))
    if not FX:
        out('[FAIL] facts.json 없음. prep 먼저'); return 2
    c, name = load(a.module); inp = inputs_of(a.module)
    c = dict(c); c['_author'] = AUTHOR; c['_date'] = inp.get('date', '') or datetime.date.today().isoformat()
    base = os.path.join(d, f'VM_소개_{a.module}_{re.sub(r"[^0-9]", "", c["_date"])[:8] or datetime.date.today().strftime("%Y%m%d")}')
    made, rc = [], 0

    def save(fn, *args):
        try:
            return fn(*args)
        except PermissionError:
            p = args[2] if fn is render_pptx else args[2]
            raise
    pptx = base + '.pptx'
    if 'pptx' in inp['formats'] or 'pdf' in inp['formats']:
        n = render_pptx(c, FX, pptx, '맑은 고딕'); made.append(rel(pptx) + f' ({n}장)')
    if 'gslides' in inp['formats']:
        g = base + '_GoogleSlides.pptx'; n = render_pptx(c, FX, g, 'Noto Sans KR', True); made.append(rel(g) + f' ({n}장, Google Drive 에 올려 Google Slides 로 열기)')
    if 'pdf' in inp['formats']:
        ok, err = to_pdf(pptx, base + '.pdf')
        if ok:
            made.append(rel(base + '.pdf'))
        else:
            out(f'[ERROR] PDF 저장 못 함(PowerPoint 필요): {err}'); rc = 4
        if 'pptx' not in inp['formats']:
            made = [m for m in made if not m.startswith(rel(pptx))]
    if 'html' in inp['formats']:
        h = base + '.html'; n = render_html(c, FX, h); made.append(rel(h) + f' ({n}장, 브라우저에서 ← → 로 넘김)')
    for m in made:
        out(f'      {m}')
    out(f'[{"OK" if rc == 0 else "FAIL"}] build {a.module}({AUD[a.module]}): 형식 {", ".join(inp["formats"])} · 내용 {name}')
    return rc


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('cmd', choices=['prep', 'check', 'build']); ap.add_argument('--module', required=True)
    a = ap.parse_args(); a.module = a.module.upper()
    if a.module not in AUD:
        out(f'[FAIL] 대상 {a.module} 없음({", ".join(AUD)})'); return 2
    return {'prep': cmd_prep, 'check': cmd_check, 'build': cmd_build}[a.cmd](a)


if __name__ == '__main__':
    sys.exit(main())
