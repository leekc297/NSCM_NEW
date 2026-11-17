"""AS-IS 콤보 원천 후보 값(정적 사실) — Doc/asisfacts/screens/<AS-IS ID>/combo_values.json (2026-10-28)

CheckList 자기검증에서 드러난 공백(SCP0007 C2): AS-IS 는 분기마다 다른 원천(dtIncotermsEdit 10건 ↔ dtIncoterms 16건)을 셀 콤보로 바꾸는데,
  검사기는 편집 잠금 전환만 보고 '그 분기의 후보 목록이 AS-IS 원천과 같은지'는 대조하지 않았다 → 분기별 후보 오류를 놓침.
  이 파일 = 원천 변수(var)별 AS-IS 후보(CODE·NAME). _trace.spec 의 분기 검사가 편집 분기의 TO-BE 후보 집합과 대조한다.

원천 = Doc/asisfacts/screens/<ID>/combo_src.csv(var·sp·code·args). 인자가 모두 리터럴인 원천만 AS-IS DB 에서 실행(읽기 전용 SELECT SP),
  실행 중에만 정해지는 인자(변수·컨트롤 값)가 있으면 실행하지 않고 'unresolved' 로 남긴다(추측 금지).
  python tools/Harness/verify/facts_combovalues.py <AS-IS ID>
"""
import csv, datetime, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))


def literal(expr):
    """combo_src args expr → 리터럴 문자열 또는 None(해석 불가). '"X"' → X · '""' / '' → ''"""
    e = (expr or '').strip()
    if e in ('', '""', "''", 'string.Empty', 'String.Empty', 'null'):
        return ''
    m = re.fullmatch(r'"([^"]*)"', e)
    return m.group(1) if m else None


def main():
    sid = sys.argv[1].upper()
    sd = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', sid)
    src = os.path.join(sd, 'combo_src.csv')
    if not os.path.exists(src):
        print(f'{sid}: combo_src.csv 없음 — facts_combosrc.py 먼저'); return 0
    rows = list(csv.DictReader(open(src, encoding='utf-8-sig')))
    from dbconn import connect
    out, done = {}, {}
    with connect('asis') as cx:
        cur = cx.cursor()
        params = {}
        for r in rows:
            sp, var = (r.get('sp') or '').strip(), (r.get('var') or '').strip()
            if not sp or sp in ('STATIC',) or sp.startswith(('DM_BIGFILTER', 'SSP_BIGFILTER')) or not var:
                continue
            try:
                args = json.loads(r.get('args') or '[]')
            except ValueError:
                args = []
            vals = {a.get('n'): literal(a.get('expr')) for a in args if a.get('n')}
            key = (sp, r.get('code') or '', json.dumps(vals, sort_keys=True, ensure_ascii=False))
            ent = out.setdefault(var, {'sp': sp, 'code': r.get('code') or '', 'targets': [], 'ref': r.get('ref') or ''})
            ent['targets'] = sorted(set(ent['targets']) | {f"{r.get('target_kind')}:{r.get('target')}"})
            if any(v is None for v in vals.values()):
                ent['unresolved'] = '실행 중에만 정해지는 인자: ' + ', '.join(k for k, v in vals.items() if v is None); continue
            if key in done:
                ent['rows'] = done[key]; continue
            if sp not in params:
                cur.execute('SELECT PARAMETER_NAME FROM INFORMATION_SCHEMA.PARAMETERS WHERE SPECIFIC_NAME=? ORDER BY ORDINAL_POSITION', sp)
                params[sp] = [x[0] for x in cur.fetchall()]
            ps = params[sp]
            if not ps and not vals:
                ent['unresolved'] = 'SP 매개변수 정보 없음'; continue
            a = {p: '' for p in ps if p.upper() != '@TIMEZONE'}
            if '@Code' in a and r.get('code'):
                a['@Code'] = r['code']
            for k, v in vals.items():
                if k in a:
                    a[k] = v
            try:
                cur.execute('SET NOCOUNT ON; EXEC dbo.[' + sp + '] ' + ', '.join(f'{p}=?' for p in a), list(a.values()))
                cols = [d[0] for d in cur.description] if cur.description else []
                data = cur.fetchall() if cols else []
                ci = next((i for i, c in enumerate(cols) if c.upper() == 'CODE'), 0)
                ni = next((i for i, c in enumerate(cols) if c.upper() == 'NAME'), 1 if len(cols) > 1 else 0)
                ent['rows'] = done[key] = [{'CODE': str(x[ci]), 'NAME': str(x[ni])} for x in data]
            except Exception as ex:  # 실행 실패 = 사실 없음(추측 금지)
                ent['unresolved'] = f'AS-IS 실행 실패: {str(ex)[:160]}'
    res = {'screen': sid, 'generated': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), 'vars': out}
    json.dump(res, open(os.path.join(sd, 'combo_values.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    ok = sum(1 for v in out.values() if v.get('rows') is not None)
    print(f"{sid}: 콤보 원천 {len(out)}종 — 값 확보 {ok} · 미해석 {len(out) - ok} → {os.path.join(sd, 'combo_values.json')}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
