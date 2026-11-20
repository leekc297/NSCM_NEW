# -*- coding: utf-8 -*-
"""팝업 목록 원천 대조 (2026-10-31 E02) — popup_rowsets.json(E2E 실측) ↔ AS-IS 팝업 SP · 문서 확정 원천 SQL

  python -I tools/Harness/verify/facts_popup_golden.py <run 폴더> <MENU_ID>   -> <run 폴더>/popup_source.csv

판정
  AS-IS 축(EG433·EG441·EG060): 팝업 호출 클래스의 조회 SP 를 TO-BE 요청 본문 값으로 실행(읽기 전용 접속).
    · TO-BE 0행 + AS-IS >0행 = FAIL · 행수·키 집합 같음 = PASS · 차이 = 판정필요(원천 DB 시점 차이 가능 — 고정 건수 FAIL 금지)
    · SP 원문·인자 대응 실패·실행 오류 = ERROR
  문서 원천 축(EG078·EG285·EG433): SRC_RULES — 문서 행이 정한 원천 SQL 을 TO-BE DB 에서 실행해 팝업 키 집합과 대조. 다르면 FAIL(차이 앞 10개).

추출 한계: 인자 대응은 이름 개념 일치(popup_args_check.concept)만. 대응 안 되는 인자는 SP 기본값 → 'ALL'/'' 로 보낸다(note 에 기록).
           rowsets 는 행당 앞 12컬럼·3000행까지만 저장한다(3000행 초과 팝업은 집합 대조 불가 → ERROR).
"""
import csv, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect  # noqa: E402
from popup_args_check import concept  # noqa: E402

FACTS = os.path.join(ROOT, 'Doc', 'verify', '_parallel', 'E02', 'facts')
FIELDS = ['menu', 'call', 'cls', 'trig', 'axis', 'egs', 'result', 'expected', 'actual', 'basis', 'note']
MAX_SET = 3000

# 문서 확정 원천 — (문서, 메뉴 정규식, 팝업 제목 정규식, 키 컬럼 정규식, SQL, EG)
SRC_RULES = [
    ('GAPPI-22', r'DMF0005', r'team', r'^(DEPT_ID|TEAM_ID|DEPTID)$',
     "select distinct d.DEPT_ID from SCM_MST_SSO_DEPT_INFO d join SCM_ADM_USER_M u on u.DEPT_ID = d.DEPT_ID", 'EG078;EG433'),
    ('DM-13', r'DMF0005', r'team', r'^(DEPT_ID|TEAM_ID|DEPTID)$',
     "select distinct d.DEPT_ID from SCM_MST_SSO_DEPT_INFO d", 'EG285;EG433'),
    ('DM-130', r'DMF0005', r'owner', r'^(USER_ID|USERID|OWNER_ID)$',
     "select distinct i.USER_ID from SCM_MST_SSO_USER_INFO i join SCM_ADM_USER_M u on u.USER_ID = i.USER_ID", 'EG060;EG433'),
    ('GAP-211', r'DMF0021', r'team', r'^(DEPT_ID|TEAM_ID|DEPTID)$',
     "select distinct DEPT_ID from SCM_MST_SITE_ITEM where DIVISION_ID = :div and DEPT_ID is not null", 'EG078;EG433'),
]


def nk(s):
    return re.sub(r'[^a-z0-9]', '', str(s).lower())


def body_args(body):
    try:
        j = json.loads(body)
    except ValueError:
        return {}
    if isinstance(j, dict):
        return {concept(k): ('' if v is None else str(v)) for k, v in j.items() if not isinstance(v, (list, dict))}
    return {}


def main(run, mid):
    rs = json.load(open(os.path.join(run, 'popup_rowsets.json'), encoding='utf-8'))
    facts = json.load(open(os.path.join(FACTS, f'{mid}.json'), encoding='utf-8')) if os.path.exists(os.path.join(FACTS, f'{mid}.json')) else {'classes': {}}
    out = []
    asis = None
    tobe = None
    for r in rs:
        base = {'menu': mid, 'call': r['call'], 'cls': r['cls'], 'trig': r['trig'], 'note': f"행 {r['rows']} · 계정 {r['account']}"}
        rows = [json.loads(x) if x.startswith('{') else {} for x in r.get('sample', [])]
        k = facts['classes'].get(r['cls']) or {}
        sps = [s for s in k.get('sps', []) if not s.get('save') and not re.search(r'SPREAD_TITLE|SCM0001_GET|LOOKUP', s['sp'], re.I)]
        if sps:
            sp = sps[0]
            if not sp.get('order_known'):
                out.append({**base, 'axis': 'ASIS', 'egs': 'EG433;EG441', 'result': 'ERROR', 'expected': f"AS-IS {sp['sp']}", 'actual': 'AS-IS SP 원문 없음', 'basis': ''})
            else:
                args = body_args(r.get('body', ''))
                ps = {}
                miss = []
                for pn in sp.get('params', []):
                    c = concept(re.sub(r'(?i)^(p_|v_)', '', pn))
                    if c in args:
                        ps[pn] = args[c]
                    else:
                        miss.append(pn)
                        ps[pn] = 'ALL'  # 미대응 인자 = 'ALL'(docstring 한계 명시)
                try:
                    if asis is None:
                        asis = connect('asis')
                    cur = asis.cursor()
                    sql = f"EXEC dbo.[{sp['sp']}] " + ', '.join(f'@{k_}=?' for k_ in ps)
                    cur.execute(sql, list(ps.values()))
                    while cur.description is None and cur.nextset():
                        pass
                    cols = [d[0] for d in cur.description] if cur.description else []
                    arows = cur.fetchmany(20000) if cols else []
                    n_as = len(arows)
                    res = 'PASS' if n_as == r['rows'] else ('FAIL' if r['rows'] == 0 and n_as > 0 else '판정필요')
                    out.append({**base, 'axis': 'ASIS', 'egs': 'EG433;EG441;EG060', 'result': res, 'expected': f"AS-IS {sp['sp']} {n_as}행", 'actual': f"TO-BE {r['rows']}행 · 인자 {json.dumps(ps, ensure_ascii=False)[:160]} · 미대응 {miss[:6]}", 'basis': f"{sp['src']} · {sp['ref']}"})
                except Exception as e:  # noqa: BLE001
                    out.append({**base, 'axis': 'ASIS', 'egs': 'EG433;EG441;EG060', 'result': 'ERROR', 'expected': f"AS-IS {sp['sp']}", 'actual': f"실행 실패 {str(e)[:160]} · 인자 {list(ps)[:6]} · 미대응 {miss[:6]}", 'basis': ''})
        for doc, mre, tre, kre, sql, egs in SRC_RULES:
            if not re.search(mre, mid) or not re.search(tre, (r.get('title') or '') + ' ' + r['trig'], re.I):
                continue
            key = next((c for c in r.get('columns', []) if re.match(kre, c, re.I)), None)
            if not key:
                out.append({**base, 'axis': 'DOC', 'egs': egs, 'result': 'ERROR', 'expected': f'{doc} 원천 대조', 'actual': f"키 컬럼 없음 — 컬럼 {r.get('columns', [])[:12]}", 'basis': doc})
                continue
            if r['rows'] > MAX_SET:
                out.append({**base, 'axis': 'DOC', 'egs': egs, 'result': 'ERROR', 'expected': f'{doc} 원천 대조', 'actual': f"{r['rows']}행 > 저장 상한 {MAX_SET}", 'basis': doc})
                continue
            try:
                if tobe is None:
                    tobe = connect('tobe')
                cur = tobe.cursor()
                bd = {}
                if ':div' in sql:
                    m = re.search(r'"division\w*"\s*:\s*"([^"]+)"', r.get('body', ''), re.I)
                    bd['div'] = m.group(1) if m else ''
                cur.execute(sql, bd)
                want = {str(x[0]) for x in cur.fetchall() if x[0] is not None}
                got = {str(x.get(key, '')) for x in rows if x.get(key)}
                add, mis = sorted(got - want), sorted(want - got)
                out.append({**base, 'axis': 'DOC', 'egs': egs, 'result': 'PASS' if not add and not mis else 'FAIL', 'expected': f'{doc} 원천 {len(want)}개', 'actual': f"팝업 {len(got)}개 · 원천 밖 {add[:10]} · 누락 {mis[:10]}", 'basis': f'문서 {doc}'})
            except Exception as e:  # noqa: BLE001
                out.append({**base, 'axis': 'DOC', 'egs': egs, 'result': 'ERROR', 'expected': f'{doc} 원천 대조', 'actual': str(e)[:200], 'basis': doc})
    for c in (asis, tobe):
        if c is not None:
            c.close()
    with open(os.path.join(run, 'popup_source.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, FIELDS)
        w.writeheader()
        w.writerows(out)
    return out


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    for x in main(sys.argv[1], sys.argv[2]):
        print(x['call'], x['axis'], x['result'], '|', x['expected'], '|', x['actual'][:220])
