# -*- coding: utf-8 -*-
"""SSP 흐름 뷰어 화면 틀(2026-11-23 사용자 요청 '보기가 쉽지 않다 · 분석하기 쉽게 다시 정리').

위쪽 탭 8개(문서 파일 단위, 탭 하나 최대 37,169px) → 왼쪽 목차(묶음 6개) + 절 단위 본문.
- wrap(): md2html 결과를 h3(절) · h4(소절) 단위 상자(div.sx · div.sx4)로 감싼다. 내용은 바꾸지 않는다.
- build_nav(): 목차 대응표(NAV)를 실제 상자에 맞춰 풀어 JSON 으로 낸다. 어느 항목에도 들지 않은 상자는
  '그 밖(자동 배치)' 항목으로 모으고 로그에 적는다(누락 방지).
ssp_flow.py 가 부른다. 화면 동작은 ssp_flow_shell.js · ssp_flow_shell.css.
"""
import re, html, json

FILE_KEY = {'SSP_OVERVIEW.md': 'OV', 'SSP_REF_PROCESS.md': 'REF', 'SSP_PROCESS_FLOW.md': 'PF', 'SSP_DATA_FLOW.md': 'DF',
            'SSP_BATCH_FLOW.md': 'BF', 'SSP_BATCH_ANALYSIS.md': 'BA', 'SSP_SHIPPLAN_FLOW.md': 'SP', 'SSP_DATA_FLOW_DETAIL.md': 'DT', 'SSP_MAP': 'MAP'}
FILE_LABEL = {'OV': '한눈에 보기', 'REF': '업무 프로세스(PI · 통합테스트)', 'PF': '프로세스 흐름', 'DF': '데이터 흐름(개요)', 'BF': '배치 흐름',
              'BA': '배치 분석서', 'SP': 'Shipment Plan 산출 흐름', 'DT': '화면별 상세', 'MAP': '전체 지도'}

_TAG = re.compile(r'<[^>]+>')


def _text(s): return html.unescape(_TAG.sub('', s)).strip()


def wrap(body, fkey, blocks):
    """md2html 결과 → 절 상자. blocks 에 {id, file, h3, h4, lv} 를 순서대로 추가하고 감싼 HTML 을 돌려준다."""
    out = []
    for n, ch in enumerate(re.split(r'(?=<h3>)', body)):
        if not ch: continue
        m = re.match(r'<h3>(.*?)</h3>', ch, re.S)
        t3 = _text(m.group(1)) if m else '개요'
        sid = f'{fkey}-{n}'
        subs = []
        for k, c4 in enumerate(re.split(r'(?=<h4>)', ch)):
            if not c4: continue
            m4 = re.match(r'<h4>(.*?)</h4>', c4, re.S)
            t4 = _text(m4.group(1)) if m4 else ''
            bid = f'{sid}-{k}'
            blocks.append({'id': bid, 'file': fkey, 'sx': sid, 'h3': t3, 'h4': t4})
            subs.append(f'<div class="sx4" data-b="{bid}" data-t="{html.escape(t4, quote=True)}">{_wrap5(c4)}</div>')
        out.append(f'<div class="sx" data-sx="{sid}" data-t="{html.escape(t3, quote=True)}">{"".join(subs)}</div>')
    return ''.join(out)


def _wrap5(c4):
    """소절 안의 h5(슬라이드, 단계)도 상자로. 목차 항목의 pick 5 가 1개씩 보여 준다."""
    parts = re.split(r'(?=<h5>)', c4)
    if len(parts) < 3: return c4
    out = [parts[0]]
    for c5 in parts[1:]:
        m5 = re.match(r'<h5>(.*?)</h5>', c5, re.S)
        t5 = html.escape(_text(m5.group(1)) if m5 else '', quote=True)
        out.append(f'<div class="sx5" data-t="{t5}">{c5}</div>')
    return ''.join(out)


def wrap_one(inner, fkey, n, title, blocks):
    """나누지 않는 덩어리(화면별 상세 · 전체 지도)를 상자 1개로."""
    sid = f'{fkey}-{n}'; bid = f'{sid}-0'
    blocks.append({'id': bid, 'file': fkey, 'sx': sid, 'h3': title, 'h4': ''})
    return f'<div class="sx" data-sx="{sid}" data-t="{html.escape(title, quote=True)}"><div class="sx4" data-b="{bid}" data-t="">{inner}</div></div>'


# 목차 대응표: (묶음, [(항목 제목, 한 줄 설명, [선택자 …], 옵션)]) · 선택자 = (파일 키, h3 정규식, h4 포함 정규식|None, h4 제외 정규식|None)
#   h4 포함 = 그 소절만 · h4 제외 = 그 소절을 뺀 나머지(절 머리글 포함) · h3 '^$' = 문서 머리(개요) 상자
def S(f, h3, inc=None, exc=None): return (f, h3, inc, exc)


NAV = [
    ('전체 지도', [
        ('SSP 전체 한 장', '외부 시스템, 배치, 업무 단계, 화면이 이어지는 순서', [S('MAP', '^SSP 전체 지도$')], {}),
        ('읽는 법 · 원천 자료', '목차 사용법과 문서별 원천', [S('MAP', '^읽는 법$'), S('OV', '^개요$'), S('REF', '^개요$'), S('PF', '^개요$'), S('DF', '^개요$'), S('BF', '^개요$'), S('BA', '^개요$'), S('SP', '^개요$'), S('DT', '^개요$')], {'help': 1}),
    ]),
    ('업무 순서', [
        ('기준정보 Master Flow', '기준정보 등록에서 출하계획까지 10단계', [S('OV', r'^1\.', None, r'^1-[12]\.')], {}),
        ('입력 오류 확인 순서', '출하계획 입력 오류(BOD ITEM)가 났을 때 보는 순서', [S('OV', r'^2\.')], {}),
        ('PI 프로세스 맵(22 Seq)', 'SSP CUTOFF Process 단계와 Seq 별 화면, 잡, 프로시저', [S('REF', r'^1\.')], {}),
        ('통합테스트 14단계', '업무 순서대로 본 시험 112건', [S('REF', r'^2\.', None, r'^2-1\.')], {'pick': 1, 'pickLabel': '단계', 'pickAll': 1}),
        ('ERP 송신 규칙', 'SO 오더타입 매핑과 송신 컬럼 값 규칙', [S('REF', r'^2\.', r'^2-1\.')], {}),
        ('자주 받는 문의', 'SSP Manual 원문', [S('OV', r'^4\.')], {}),
        ('화면 매뉴얼 원문', 'SSP Manual 2~11번 슬라이드', [S('OV', r'^5\.')], {}),
    ]),
    ('계획 산출', [
        ('Shipment Plan 전체 흐름', 'SCP FINAL 에서 확정, ERP 송신까지', [S('SP', r'^1\.')], {}),
        ('산출 요약', '산출 단위, 수량 결정, 실적 차감, Rolling', [S('SP', r'^2\.')], {}),
        ('단계 × 사업부 비교', '같은 단계를 사업부별로 나란히', [S('SP', r'^3\.')], {}),
        ('사업부별 산출 흐름', '40, 81·82, 전극, Packer, 통합', [S('SP', r'^4\.')], {'pick': 1, 'pickLabel': '사업부'}),
        ('기준정보 설정', '산출에 쓰는 기준정보', [S('SP', r'^5\.')], {}),
        ('확인 필요 · 실행 상태', '흐름도 10번 슬라이드', [S('SP', r'^6\.')], {}),
    ]),
    ('배치', [
        ('하루 배치 흐름', 'SSP CUTOFF 하루 순서', [S('OV', r'^3\.', None, r'^3-1\.')], {}),
        ('운영 잡 스케줄(46잡)', '시각 지정 잡, 주기 잡, 잡 → 프로시저 호출', [S('REF', r'^4\.')], {}),
        ('프로세스 진행 조건', '배치가 계획을 만들기 전에 확인하는 것', [S('OV', r'^3\.', r'^3-1\.'), S('REF', r'^5\.', r'^5-0\.')], {}),
        ('배치별 입출력(슬라이드 2~10)', '배치마다 읽는 표와 쓰는 표, 처리 규칙', [S('REF', r'^5\.', None, r'^5-0\.')], {'pick': 5, 'pickLabel': '슬라이드'}),
        ('실행 기반 구조', 'SQL Agent, SSP 스케줄러, SAP RFC', [S('BF', r'^1\.'), S('BA', r'^1\.')], {}),
        ('배치 그룹 → 엔터티 → 화면', '배치가 만든 데이터를 보는 화면', [S('BF', r'^2\.')], {}),
        ('화면 → 엔터티 → 배치 그룹', '화면이 만든 데이터를 가져가는 배치', [S('BF', r'^3\.')], {}),
        ('배치 간 데이터 의존', '잡 A 가 쓴 표를 잡 B 가 읽음', [S('BF', r'^4\.')], {}),
        ('외부 인터페이스 맵', '수신, 송신 배치와 상대 시스템', [S('BF', r'^5\.')], {}),
        ('배치 인벤토리', '그룹별 잡 목록', [S('BA', r'^2\.')], {'pick': 1, 'pickLabel': '배치 그룹', 'pickAll': 1}),
        ('잡별 상세(잡 선택)', '잡 1개의 스케줄, 스텝, 프로시저, 표와 그림', [S('BA', r'^3\.'), S('BF', r'^6\.')], {'pick': 1, 'pickLabel': '잡'}),
        ('화면 유발 배치', '화면 저장 SP 가 부르는 PR_SSP_*', [S('BA', r'^4\.')], {}),
        ('PR_SSP_* 전수(140)', '프로시저별 호출처', [S('BA', r'^5\.')], {}),
        ('SAP RFC 배치', 'SAPRFC_Batch_NERP 함수와 SSP 사용', [S('BA', r'^6\.')], {}),
        ('TO-BE 이관 현황', '배치 이관 요약', [S('BA', r'^7\.')], {}),
    ]),
    ('화면과 데이터', [
        ('TO-BE 메뉴 구조', 'Shipping 메뉴 아래 화면', [S('PF', r'^1\.')], {}),
        ('업무 단계 흐름', 'Master → Request → Plan → Confirm → Change', [S('PF', r'^2\.', None, r'^2-[12]\.')], {}),
        ('단계별 화면 의존', '단계 안 화면끼리 주고받는 데이터', [S('PF', r'^2\.', r'^2-1\.')], {'pick': 5, 'pickLabel': '단계'}),
        ('TO-BE 화면 간 흐름', 'TO-BE 메뉴 19 화면', [S('PF', r'^2\.', r'^2-2\.')], {}),
        ('화면 순서(위상 정렬)', '선행 의존이 없는 화면부터', [S('PF', r'^4\.')], {}),
        ('화면 내부 표준 프로세스', '조회, 저장 호출 순서', [S('PF', r'^5\.')], {}),
        ('외부 ↔ SSP 데이터', '타 도메인, 공통, 인터페이스 표와 SSP 단계', [S('DF', r'^1\.')], {}),
        ('단계 × 엔터티', '어느 단계가 만들고 어느 단계가 읽는지', [S('DF', r'^2\.', None, r'^2-1\.')], {}),
        ('단계별 화면 → 엔터티', '화면 단위 쓰기, 읽기', [S('DF', r'^2\.', r'^2-1\.')], {'pick': 5, 'pickLabel': '단계'}),
        ('테이블별 쓰기/읽기 화면', 'SSP 테이블마다 쓰는 화면, 읽는 화면', [S('DF', r'^3\.')], {}),
        ('화면별 상세(화면 선택)', '화면 1개의 SP, 테이블(R/W)', [S('DT', r'^화면별 상세$')], {}),
        ('화면별 연계', '화면마다 PI Seq, 통합테스트, 수정 필요사항', [S('REF', r'^3\.')], {}),
    ]),
    ('근거와 대조', [
        ('배치 원천과 한계', '배치 분석에 쓴 자료와 못 본 범위', [S('BA', r'^0\.')], {'fold': 1}),
        ('Master Flow 화살표 검증', '단계 화살표를 AS-IS SP 본문에 대조', [S('OV', r'^1\.', r'^1-[12]\.')], {'fold': 1}),
        ('교차검증(기존 자료 ↔ 분석)', '운영 잡, 프로시저, 테이블, 진행 조건, 계획기준 대조', [S('REF', r'^6\.')], {'fold': 1}),
        ('Shipment Plan 대조', '자료와 AS-IS SP 본문 대조', [S('SP', r'^7\.')], {'fold': 1}),
        ('화면 의존 표(전체 쌍)', '선행 화면 → 후행 화면, 매개 테이블', [S('PF', r'^3\.')], {'fold': 1}),
        ('로그 · 이력 표', '개요 그림에서 뺀 표', [S('DF', r'^4\.')], {'fold': 1}),
    ]),
]


def build_nav(blocks, log=print):
    """NAV → [{g, items:[{id, t, d, b:[상자 id], src:[문서 이름], pick, fold, help}]}]. 안 쓰인 상자는 자동 항목."""
    used = set(); groups = []; n = 0
    for g, items in NAV:
        gi = []
        for title, desc, sels, opt in items:
            ids = []
            for f, r3, inc, exc in sels:
                for b in blocks:
                    if b['file'] != f or not re.search(r3, b['h3']): continue
                    if inc is not None and not (b['h4'] and re.search(inc, b['h4'])): continue
                    if exc is not None and b['h4'] and re.search(exc, b['h4']): continue
                    if b['id'] not in ids: ids.append(b['id'])
            if not ids: log(f'[ssp_shell] 목차 항목 "{title}" 에 맞는 절 없음(건너뜀)'); continue
            used.update(ids); n += 1
            it = {'id': f'i{n}', 't': title, 'd': desc, 'b': ids, 'src': list(dict.fromkeys(FILE_LABEL[x.split('-')[0]] for x in ids))}
            it.update(opt); gi.append(it)
        if gi: groups.append({'g': g, 'items': gi})
    rest = [b for b in blocks if b['id'] not in used]
    if rest:
        by = {}
        for b in rest: by.setdefault((b['file'], b['h3']), []).append(b['id'])
        gi = []
        for (f, h3), ids in by.items():
            n += 1; gi.append({'id': f'i{n}', 't': h3[:40], 'd': FILE_LABEL[f], 'b': ids, 'src': [FILE_LABEL[f]]})
            log(f'[ssp_shell] 대응표에 없는 절 → 자동 배치: {FILE_LABEL[f]} › {h3[:60]} ({len(ids)}상자)')
        groups.append({'g': '그 밖(자동 배치)', 'items': gi})
    return groups


def nav_json(groups): return json.dumps(groups, ensure_ascii=False, separators=(',', ':'))
