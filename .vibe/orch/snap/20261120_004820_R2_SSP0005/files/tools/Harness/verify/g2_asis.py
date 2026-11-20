# -*- coding: utf-8 -*-
"""G2 선택 조회 '조건 밖 값' 확인 — 화면이 보낸 같은 인자로 AS-IS 조회 SP 를 실행해 AS-IS 결과에도 같은 값이 나오는지 (2026-11-10 T217)

  python tools/Harness/verify/g2_asis.py <MENU_ID> <sheet> <btn> <body.json 경로> <TO-BE 컬럼> <조건 밖 값1> [값2 …]
  → 표준출력 JSON 1줄 {ok, asis_sp, asis_rows, col, asis_has:[…], asis_lacks:[…], note}

왜: SSP0015 v3 G2 — From Site 'NJ01-P,HQ06-A' 복수 선택 조회에 'LGESNJ Cell NJ01' 이 섞여 FAIL. AS-IS SSP0015_GET_SHIPMENT_PSI:162-163 은
  'IF LEN(@p_from_site) > 6 SET @p_from_site = ''' — 복수 선택이면 필터를 비워 전체를 조회한다(TO-BE 도 1121행 = 전체). 원문 패턴 대신 같은 인자 AS-IS 실측으로 가린다.
판정 재료만 낸다(판정은 _verify G2): asis_has = 조건 밖 값 중 AS-IS 결과에도 있는 값 · asis_lacks = AS-IS 결과에 없는 값.
실행 대상 = 이름에 _GET_ 이 있는 AS-IS SP 만(a1_live.run_asis — 저장 SP 실행 금지).
"""
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import a1_live as A  # noqa: E402  (main 보호됨 — 함수만 사용)


def main():
    if len(sys.argv) < 7:
        print(json.dumps({'ok': False, 'note': '인자 부족'}, ensure_ascii=False)); return 2
    mid, sheet, btn, bodyp, tcol = sys.argv[1].upper(), sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]
    vals = [v for v in sys.argv[6:] if v]
    try: body = open(bodyp, encoding='utf-8').read()
    except OSError as e:
        print(json.dumps({'ok': False, 'note': f'본문 파일 없음 {e}'}, ensure_ascii=False)); return 0
    pm = [r for r in A.rd(os.path.join(A.DOC, 'tobefacts', 'db', 'proc_meta.csv')) if (r.get('menu_id') or '').upper() == mid]
    proc = next((r.get('proc') for r in pm if (r.get('sheet') or '').lower() == sheet.lower() and (r.get('btn') or '').upper() == btn.upper()), '')
    g = next((x for x in A.rd(os.path.join(A.DOC, 'golden', 'golden_cases.csv')) if x.get('tobe_proc') == proc and proc), None)
    if not g or not re.search(r'_GET_', g.get('asis_sp') or '', re.I):
        print(json.dumps({'ok': False, 'note': f"{sheet}/{btn} PROC '{proc}' 에 대응하는 AS-IS 조회 SP 없음(golden_cases)"}, ensure_ascii=False)); return 0
    try: dflt = json.loads(g.get('params') or '{}')
    except ValueError: dflt = {}
    args = A.dict_of(body); ps = {}; miss = []
    for pn, v in dflt.items():
        k = A.concept(re.sub(r'(?i)^(p_|v_)', '', pn))
        if k in args: ps[pn] = args[k]
        else: ps[pn] = v; miss.append(pn)
    try:
        cx = A.connect('asis'); c = cx.cursor(); c.execute(f"SELECT OBJECT_DEFINITION(OBJECT_ID('dbo.{g['asis_sp']}'))"); t = c.fetchone()[0] or ''
        sets = A.run_asis(cx, g['asis_sp'], A.norm_all(t, ps))
    except Exception as e:  # noqa: BLE001
        print(json.dumps({'ok': False, 'asis_sp': g['asis_sp'], 'note': f'AS-IS 실행 실패 {str(e)[:160]}'}, ensure_ascii=False)); return 0
    acols, arows = next((s for s in sets if len(s[0]) > 1), sets[0] if sets else ([], []))
    # 보조 근거(실측 대조가 성립하지 않을 때): 여러 값(쉼표)이 담긴 인자를 AS-IS 원문이 조건부로 비우는 문장 — 'IF LEN(@p_x) > N SET @p_x = ''' · 'IF CHARINDEX(',', @p_x) > 0 SET @p_x = '''
    clears = []
    from facts_sortrules import strip_comments  # SQL 주석 제거(주석 속 문장은 사실 아님)
    body_l = strip_comments(t)
    for pn, v in ps.items():
        if ',' not in str(v): continue
        n = re.escape(pn.lstrip('@'))
        rx = re.compile(r"(?is)(?<![A-Za-z0-9_])IF\s*\(?\s*(?:LEN\s*\(\s*@" + n + r"\s*\)\s*>\s*\d+|CHARINDEX\s*\(\s*N?',?'\s*,\s*@" + n + r"\s*\)\s*>\s*0)\s*\)?\s*(?:BEGIN\s*)?SET\s+@" + n + r"\s*=\s*N?''")
        m = rx.search(body_l)
        if m: clears.append(f"{g['asis_sp']}:{body_l[:m.start()].count(chr(10)) + 1} {' '.join(m.group(0).split())[:90]}")
    # TO-BE 컬럼과 같은 이름(정규화) 컬럼 → 없으면 조건 밖 값이 하나라도 들어 있는 문자 컬럼
    ci = next((i for i, a in enumerate(acols) if A.nk(a) == A.nk(tcol)), None)
    if ci is None:
        for i, a in enumerate(acols):
            if any(str(r[i] or '').strip() in vals for r in arows[:50000]): ci = i; break
    if ci is None:
        print(json.dumps({'ok': False, 'asis_sp': g['asis_sp'], 'asis_rows': len(arows), 'clears': clears, 'note': f"AS-IS 결과에 '{tcol}' 대응 컬럼 없음 · 미대응 인자 {miss}"}, ensure_ascii=False)); return 0
    have = {str(r[ci] or '').strip() for r in arows}
    out = {'ok': True, 'asis_sp': g['asis_sp'], 'asis_rows': len(arows), 'col': acols[ci], 'asis_has': [v for v in vals if v in have], 'asis_lacks': [v for v in vals if v not in have], 'clears': clears,
           'note': f"인자 {json.dumps({k: v for k, v in ps.items() if v not in ('', None)}, ensure_ascii=False)[:200]} · 미대응 {miss}"}
    print(json.dumps(out, ensure_ascii=False)); return 0


if __name__ == '__main__':
    sys.exit(main())
