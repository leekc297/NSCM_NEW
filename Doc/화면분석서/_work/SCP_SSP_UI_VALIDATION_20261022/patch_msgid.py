# -*- coding: utf-8 -*-
"""build_all.py 에 AS-IS/TO-BE 메시지 ID 표기 + 의미 대조 반영 (2026-10-23 사용자 지시)"""
import os
p = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'build_all.py')
s = open(p, encoding='utf-8').read()

def rep(old, new):
    global s
    assert old in s, old[:80]
    s = s.replace(old, new, 1)

rep("""for f in sorted(glob.glob(f'{W}/out/u*.jsonl')):
    for line in open(f, encoding='utf-8'):
        line = line.strip()""", """for f in sorted(glob.glob(f'{W}/out/u*.jsonl')):
    for _ln, line in enumerate(open(f, encoding='utf-8'), 1):
        line = line.strip()""")
rep("""        t = o.get('t')
        if t == 'ui': ui.append(o)""", """        t = o.get('t')
        o['_uid'] = f'{os.path.basename(f)}:{_ln}'
        if t == 'ui': ui.append(o)""")
rep("""# ------------------------------------------------------------------ 행 구성""", """# 메시지 ID AS-IS↔TO-BE 대조 결과(msgcheck_out — TO-BE FE 코드 + SCM_ADM_MSG_M 2026-10-23 06:58)
msgchk = {}
for f in glob.glob(f'{W}/msgcheck_out/m*.jsonl'):
    for line in open(f, encoding='utf-8'):
        if line.strip():
            o = json.loads(line); msgchk[o['uid']] = o

# ------------------------------------------------------------------ 행 구성""")
rep("""    ko, en = render(o.get('msg_id'), o.get('msg_args'), o.get('msg_text', ''))
    block.append({'sid': sid, 'event': o['event'], 'kind': 'UI', 'apply': o.get('tobe_apply') or 'TO-BE 미개발', 'seq': o.get('seq') or 0,
                  'msg': ko, 'remark': o.get('remark', ''), 'cls': o.get('cls', 'A'), 'msgid': o.get('msg_id') or '', 'en': en,
                  'item': (norm_item(o.get('item', '')), o.get('check_type', '')), 'target': o.get('target', ''),
                  'loc': o.get('asis_loc', ''), 'tobe': o.get('tobe_basis', '')})""", """    ko, en = render(o.get('msg_id'), o.get('msg_args'), o.get('msg_text', ''))
    apply_, basis_ = o.get('tobe_apply') or 'TO-BE 미개발', o.get('tobe_basis', '')
    mc = msgchk.get(o['_uid'])
    tobe_ids, tobe_msg, meaning = [], '', ''
    if apply_ in ('적용', '부분적용'):
        if mc:
            tobe_ids = [x for x in (mc.get('tobe_msg_ids') or []) if x]
            tobe_msg = mc.get('tobe_msg_ko') or mc.get('tobe_text') or ''
            meaning = (mc.get('meaning') or '') + (f" — {mc['note']}" if mc.get('note') else '')
            if mc.get('meaning') in ('불일치', 'TO-BE 미등록') and apply_ == '적용':
                apply_ = '부분적용'
                basis_ += f" | [메시지 의미 대조] {mc.get('meaning')}: TO-BE 가 표시하는 문구가 AS-IS 와 뜻이 다름 → 부분적용"
        else:
            meaning = '미대조'
    asis_id = o.get('msg_id') or ''
    id_disp = ', '.join(([asis_id] if asis_id else []) + [f'{x}(TO-BE)' for x in tobe_ids])
    block.append({'sid': sid, 'event': o['event'], 'kind': 'UI', 'apply': apply_, 'seq': o.get('seq') or 0,
                  'msg': ko, 'remark': o.get('remark', ''), 'cls': o.get('cls', 'A'), 'msgid': asis_id, 'msgid_disp': id_disp,
                  'tobe_ids': tobe_ids, 'tobe_msg': tobe_msg, 'meaning': meaning, 'en': en,
                  'item': (norm_item(o.get('item', '')), o.get('check_type', '')), 'target': o.get('target', ''),
                  'loc': o.get('asis_loc', ''), 'tobe': basis_})""")
rep("""    data = [[sname(b['sid']), b['event'], b['kind'], b['apply'], b['seq'], b['msg'], b['remark'], b['cls'], b['msgid'], b['en'], bid[b['item']], b['target'], b['loc'], b['tobe']] for b in B]
    sheet(ws, ['화면 ID', 'EVENT', 'UI / DB', 'TO-BE 적용여부', 'SEQ', 'VALIDATION MESSAGE', 'REMARK', '(참고) 분류', '(참고) MSG ID', '(참고) 영문 메시지', '(참고) 항목 ID', '(참고) 검증 대상', '(참고) AS-IS 근거 위치', '(참고) TO-BE 근거'],
          data, [24, 30, 7, 12, 6, 44, 70, 7, 11, 34, 10, 26, 45, 60], extra_from=8)""", """    data = [[sname(b['sid']), b['event'], b['kind'], b['apply'], b['seq'], b['msg'], b['remark'], b['cls'], b.get('msgid_disp') or b['msgid'],
             b.get('tobe_msg', ''), b.get('meaning', ''), b['en'], bid[b['item']], b['target'], b['loc'], b['tobe']] for b in B]
    sheet(ws, ['화면 ID', 'EVENT', 'UI / DB', 'TO-BE 적용여부', 'SEQ', 'VALIDATION MESSAGE', 'REMARK', '(참고) 분류', '(참고) MSG ID',
               '(참고) TO-BE 메시지', '(참고) 메시지 의미 대조', '(참고) 영문 메시지', '(참고) 항목 ID', '(참고) 검증 대상', '(참고) AS-IS 근거 위치', '(참고) TO-BE 근거'],
          data, [24, 30, 7, 12, 6, 44, 70, 7, 22, 36, 30, 34, 10, 26, 45, 60], extra_from=8)""")
rep("""                    ', '.join([m for m in OrderedDict.fromkeys(x['msgid'] for x in rs) if m and m != '-'][:8]), rs[0]['msg'],""", """                    ', '.join([m for m in OrderedDict.fromkeys(x['msgid'] for x in rs) if m and m != '-'][:8]),
                    ', '.join(f'{m}(TO-BE)' for m in list(OrderedDict.fromkeys(t for x in rs for t in x.get('tobe_ids', [])))[:8]), rs[0]['msg'],""")
rep("""'MSG ID(AS-IS)', '대표 VALIDATION MESSAGE',""", """'MSG ID(AS-IS)', 'MSG ID(TO-BE)', '대표 VALIDATION MESSAGE',""")
rep("""          agg, [9, 34, 11, 8, 6, 18, 40, 9, 26, 6, 95, 24, 26])""", """          agg, [9, 34, 11, 8, 6, 18, 22, 40, 9, 26, 6, 95, 24, 26])""")
rep("""        ['TO-BE 메시지 번호', '같은 의미라도 번호가 다름(SCM_ADM_MSG_M 재매핑) — 예: MSG00002→MSG00429, MSG00193→MSG01035, MSG00072→MSG01036, MSG00049→MSG00611, MSG00093→MSG01122, MSG00060→MSG01092'],""",
    """        ['MSG ID 표기', '(참고) MSG ID 칸은 AS-IS 메시지 ID 를 먼저 적고, TO-BE 가 적용(적용·부분적용)된 행은 TO-BE 화면이 실제로 표시하는 메시지 ID 를 옆에 "(TO-BE)" 로 덧붙임(예: MSG00002, MSG00429(TO-BE)). VALIDATION MESSAGE 칸은 AS-IS 문구. 집계 시트는 MSG ID(AS-IS)·MSG ID(TO-BE) 두 칸'],
        ['메시지 의미 대조', 'AS-IS·TO-BE 는 메시지 번호 체계가 다르므로 번호가 아니라 문구 의미로 대조(2026-10-23 사용자 지시). TO-BE ID·문구는 TO-BE FE 코드(상수 정의까지 추적)와 TO-BE 메시지 마스터(사내 ZIOUI1 SCM_ADM_MSG_M, 2026-10-23 06:58 조회, 740 ID)로 확정. '
                     '일치 / 불일치(번호가 같아도 뜻이 다름 — 예: TO-BE MSG00002="성공적으로 저장되었습니다") / TO-BE 미등록(마스터에 없는 ID → fallback 문자열 표시) / 메시지 없음 / AS-IS 문구 이상(AS-IS 코드 의도와 AS-IS 마스터 문구가 이미 어긋남 — 의도 기준으로 판정). 불일치·미등록이면 적용 → 부분적용으로 조정'],
        ['AS-IS 문구 재확인(2026-10-23)', '① 조회 필수 메시지 MSG00002 의 {0} = GetTerm(LayoutControlItem.CustomizationFormText)(DataUtil.cs L437 외) — 다수 화면 Designer 에서 Division 항목 CustomizationFormText="Bucket"(예: SCP0012 L736) + AS-IS 용어 마스터 Bucket→Bucket 이라 AS-IS 실제 표시는 "Bucket 값은 필수 입력입니다"(AS-IS 원문 동작). '
                     '② SCP0125~0133 등은 날짜 형식 오류에 MSG00046 을 쓰나(코드 주석 의도 "유효한 날짜 형식이 아닙니다 {0}") AS-IS DB(LGCE_SCMDEV, 2026-10-23 06:57 직접 조회) MSG00046="삭제할 데이터가 없습니다." — AS-IS 문구 이상. 같은 의미 ID 는 AS-IS MSG00049 / TO-BE MSG01081·MSG00611. ※ AS-IS 운영 DB 는 접속 불가라 개발 DB 기준'],""")
open(p, 'w', encoding='utf-8').write(s)
print('patched')
