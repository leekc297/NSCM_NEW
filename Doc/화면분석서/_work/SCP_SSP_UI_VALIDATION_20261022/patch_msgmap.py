# -*- coding: utf-8 -*-
"""build_all.py 패치 — 메시지 대조표 시트 + TO-BE 적용여부 '메시지 미등록'/'메시지 불일치' (2026-10-23 사용자 지시)
- AS-IS 마스터 의미 기준으로 TO-BE 마스터에 같은 의미가 없으면 '메시지 미등록'(부분적용과 혼선 방지)
- TO-BE 마스터엔 같은 의미가 있는데 TO-BE 코드가 뜻이 다른 ID 를 쓰면 '메시지 불일치'
- 로직 차이로 이미 '부분적용' 인 행은 그대로 두고 '(참고) 메시지 의미 대조' 칸에 결과만 표기"""
import os
p = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'build_all.py')
s = open(p, encoding='utf-8').read()

def rep(old, new):
    global s
    assert old in s, old[:90]
    s = s.replace(old, new, 1)

# 1) 대조표 원천 로드
rep("""# ------------------------------------------------------------------ 행 구성""", """# AS-IS↔TO-BE 메시지 마스터 의미 대조표(msgmap_out — 문구 의미 기준)
amap = {}
for f in glob.glob(f'{W}/msgmap_out/a*.jsonl'):
    for line in open(f, encoding='utf-8'):
        if line.strip():
            o = json.loads(line); amap[o['asis_msg_id']] = o
TOBE_MSG = {}
for r in csv.DictReader(open(f'{W}/tobe_msg_master.csv', encoding='utf-8-sig')):
    if r['LANG_CD'] == 'KO':
        TOBE_MSG[r['MSG_ID']] = r

# ------------------------------------------------------------------ 행 구성""")

# 2) 적용여부 규칙 교체
rep("""            if mc.get('meaning') in ('불일치', 'TO-BE 미등록') and apply_ == '적용':
                apply_ = '부분적용'
                basis_ += f" | [메시지 의미 대조] {mc.get('meaning')}: TO-BE 가 표시하는 문구가 AS-IS 와 뜻이 다름 → 부분적용\"""",
    """            pass
        else:
            meaning = '미대조'
    asis_id_ = o.get('msg_id') or ''
    am = amap.get(asis_id_) if asis_id_ else None
    if apply_ in ('적용', '부분적용'):
        mstat = ''
        if am and am.get('result') == '메시지 미등록':
            mstat = '메시지 미등록'
        elif mc and mc.get('meaning') == 'TO-BE 미등록':
            mstat = '메시지 미등록' if not (am and am.get('tobe_equiv_ids')) else '메시지 불일치'
        elif mc and mc.get('meaning') == '불일치':
            mstat = '메시지 불일치'
        if mstat:
            eq = ', '.join(am.get('tobe_equiv_ids') or []) if am else ''
            meaning = f'[{mstat}] ' + meaning + (f' / TO-BE 마스터 같은 의미 ID: {eq}' if eq else ' / TO-BE 마스터에 같은 의미 메시지 없음')
            if apply_ == '적용':
                apply_ = mstat
    if False:
        pass""")
rep("""        else:
            meaning = '미대조'
    asis_id = o.get('msg_id') or ''""", """    asis_id = o.get('msg_id') or ''""")

# 3) 색상
rep("""'미확인': 'DDEBF7'}""", """'미확인': 'DDEBF7', '메시지 미등록': 'D9D2E9', '메시지 불일치': 'F4B084'}""")
# 집계 TO-BE 현황 값 목록
s = s.replace("""for a in ('적용', '부분적용', '미적용', 'TO-BE 미개발') if cnt[a]""", """for a in ('적용', '부분적용', '메시지 미등록', '메시지 불일치', '미적용', 'TO-BE 미개발', '미확인') if cnt[a]""")
s = s.replace("""for a in ('적용', '부분적용', '미적용', 'TO-BE 미개발') if cB[a]""", """for a in ('적용', '부분적용', '메시지 미등록', '메시지 불일치', '미적용', 'TO-BE 미개발', '미확인') if cB[a]""")

# 4) 작성기준 범례
rep("""        ['메시지 의미 대조', """, """        ['메시지 미등록 / 불일치', 'TO-BE 적용여부 값. 메시지 미등록 = 로직은 적용됐으나 AS-IS 메시지(AS-IS 마스터 문구 의미 기준)와 같은 의미의 메시지가 TO-BE 마스터(SCM_ADM_MSG_M)에 없음. 메시지 불일치 = TO-BE 마스터에 같은 의미 메시지가 있는데 TO-BE 코드가 뜻이 다른 ID 를 씀. '
                     '로직 차이로 이미 부분적용인 행은 부분적용을 유지하고 (참고) 메시지 의미 대조 칸에 [메시지 미등록]/[메시지 불일치] 를 표기. 메시지별 상세는 마지막 시트 "메시지 대조표"'],
        ['메시지 의미 대조', """)

# 5) 메시지 대조표 시트 (판독현황 뒤 = 마지막)
rep("""    path = f'{OUTDIR}/{dom}_화면_VALIDATION_취합_{STAMP}.xlsx'""", """    ws = wb.create_sheet('메시지 대조표')
    used = defaultdict(lambda: {'sids': set(), 'rows': 0, 'tobe_used': Counter(), 'mean': Counter()})
    for b in B:
        if b['msgid'] and b['msgid'] != '-':
            u = used[b['msgid']]; u['sids'].add(b['sid']); u['rows'] += 1
            for t in b.get('tobe_ids', []): u['tobe_used'][t] += 1
            m = (b.get('meaning') or '').split(' — ')[0]
            if m: u['mean'][m.split('] ')[-1] if m.startswith('[') else m] += 1
    for _ev, mid, _a, _rm, _loc in COMMON:
        if mid: used[mid]['sids'].add('전 화면 공통(BaseForm)'); used[mid]['rows'] += 1
    data = []
    for mid in sorted(used):
        u, am = used[mid], amap.get(mid, {})
        a = MSG.get(mid)
        tb_same = TOBE_MSG.get(mid)
        eq = am.get('tobe_equiv_ids') or []
        code_ids = ', '.join(f'{k}(TO-BE) {v}건' for k, v in u['tobe_used'].most_common())
        code_ok = ''
        if u['tobe_used']:
            bad = [k for k in u['tobe_used'] if eq and k not in eq]
            code_ok = '일치' if not bad and eq else ('코드 사용 ID 가 같은 의미 ID 와 다름: ' + ', '.join(bad) if bad else '대조 불가(같은 의미 ID 없음)')
        data.append([mid, a['Ko'] if a else '(AS-IS 마스터 없음)', a['En'] if a else '',
                     ', '.join(f'{x}(TO-BE)' for x in eq), am.get('tobe_equiv_ko', ''), am.get('result', '미대조'),
                     tb_same['MSG_NM'] if tb_same else '(TO-BE 마스터에 같은 번호 없음)', am.get('same_id_same_meaning', ''),
                     code_ids, code_ok, ' / '.join(f'{k} {v}' for k, v in u['mean'].most_common()),
                     len(u['sids']), u['rows'], '\\n'.join(sname(x) if x in screens else x for x in sorted(u['sids'])), am.get('note', '')])
    sheet(ws, ['AS-IS MSG ID', 'AS-IS 메시지(KO)', 'AS-IS 메시지(EN)', 'TO-BE 같은 의미 MSG ID', 'TO-BE 메시지(KO)', '대조 결과',
               '같은 번호의 TO-BE 문구', '같은 번호 의미 같음(Y/N)', 'TO-BE 코드 실제 사용 ID(행 수)', '코드 사용 ID 판정', '행별 의미 대조 결과',
               '사용 UI 수', '사용 행 수', '사용 UI 목록', '비고'],
          data, [12, 40, 34, 22, 40, 12, 36, 10, 26, 30, 26, 8, 8, 30, 40])
    MF = {'동일 문구': 'E2EFDA', '같은 의미': 'E2EFDA', '메시지 미등록': 'D9D2E9', 'AS-IS 마스터 없음': 'F8CBAD'}
    for r in ws.iter_rows(min_row=2):
        r[5].fill = PatternFill('solid', fgColor=MF.get(r[5].value, 'FFFFFF'))
        if r[7].value == 'N':
            r[7].fill = PatternFill('solid', fgColor='F4B084')

    path = f'{OUTDIR}/{dom}_화면_VALIDATION_취합_{STAMP}.xlsx'""")
open(p, 'w', encoding='utf-8').write(s)
print('patched')
