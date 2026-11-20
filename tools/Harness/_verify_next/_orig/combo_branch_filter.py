# -*- coding: utf-8 -*-
"""AS-IS 조회조건 콤보가 BigFilter(SSP_BIGFILTER)를 거칠 때, 그 결과셋을 만드는 SP @Code 분기 본문의 ATTRIBUTE3 필터를 찾는다.

2026-11-20 SSP0014 미검증 해소(T376 · EG-a6f6bebc J1 'Division 후보 EE 없음 판정필요'):
  combo_src.csv filters 칸은 화면 원문(BLUtils.GetDivisionWithoutEE 등) 필터만 적는다. SSP_BIGFILTER MyDivisionCMM 은
  BigFilter.xml list_line_ssp 결과셋 → UP_FX_GetCommonDataList @Code='MyDivision' 분기 안에 `A.ATTRIBUTE3 <> 'EE'` 가 있어
  기대 후보 계산(eg_auth.spec.ts DIV_FILTER)이 이 제외를 몰랐다.
  분기 원문은 오프라인 사본 Doc/asisfacts/db/modules/dbo.<SP>.sql 에서 읽는다(DB 접속 없음). 주석 줄은 뺀다.

사용: python combo_branch_filter.py <MENU_ID>          → JSON [{target, wrapper, code, sp, sp_code, filter, ref}]
      python combo_branch_filter.py --selftest
"""
import csv
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)

ATTR = re.compile(r"\b(?:\w+\.)?ATTRIBUTE3\s*(<>|!=|=)\s*'([^']*)'", re.I)


def strip_sql_comments(t):
    t = re.sub(r'/\*.*?\*/', ' ', t, flags=re.S)
    return '\n'.join(l.split('--', 1)[0] for l in t.splitlines())


def branch_text(sql, code):
    """@Code = 'X' 조건 뒤 첫 BEGIN 부터 짝이 맞는 END 까지(주석 제외). 없으면 ''"""
    body0 = strip_sql_comments(sql)
    m = re.search(r"@Code\s*=\s*'" + re.escape(code) + r"'", body0, re.I)
    if not m:
        return ''
    body = body0[m.end():m.end() + 60000]
    b = re.search(r'\bBEGIN\b', body, re.I)
    if not b:
        return body[:3000]
    depth = 0
    for t in re.finditer(r'\b(BEGIN|CASE|END)\b', body[b.start():], re.I):
        depth += 1 if t.group(1).upper() in ('BEGIN', 'CASE') else -1
        if depth == 0:
            return body[b.start():b.start() + t.end()]
    return body[b.start():b.start() + 3000]


def branch_filter(sql, code):
    """분기 본문의 첫 ATTRIBUTE3 비교 → "ATTRIBUTE3 <> 'EE'" 형식. 없으면 ''"""
    m = ATTR.search(branch_text(sql, code))
    return f"ATTRIBUTE3 {m.group(1)} '{m.group(2)}'" if m else ''


def resolve(menu):
    fp = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', menu, 'combo_src.csv')
    if not os.path.exists(fp):
        return []
    import facts_combosrc as fc
    import b7_check as b7
    sets = b7.ssp_bigfilter_sets()
    out = []
    with open(fp, encoding='utf-8-sig') as f:
        for r in csv.DictReader(f):
            if not (r.get('sp') or '').startswith('SSP_BIGFILTER'):
                continue
            spec = fc.SSP_INNER.get(r.get('code') or '')
            if not spec or spec[0] >= len(sets) or not sets[spec[0]]:
                continue
            sp, sp_code, _ = sets[spec[0]]
            mp = os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'modules', f'dbo.{sp}.sql')
            if not os.path.exists(mp):
                continue
            sql = open(mp, encoding='utf-8-sig', errors='ignore').read()
            flt = branch_filter(sql, sp_code)
            if flt:
                ln = 0
                m = re.search(r"@Code\s*=\s*'" + re.escape(sp_code) + r"'", sql, re.I)
                if m:
                    ln = sql.count('\n', 0, m.start()) + 1
                out.append({'target': r.get('target', ''), 'wrapper': r.get('sp', ''), 'code': r.get('code', ''), 'sp': sp, 'sp_code': sp_code,
                            'filter': flt, 'ref': f'Doc/asisfacts/db/modules/dbo.{sp}.sql:{ln} @Code={sp_code}'})
    return out


def selftest():
    sql = """IF @Code = 'A'
BEGIN
  SELECT 1 FROM T WHERE ATTRIBUTE3 = '82'
END
IF @Code = 'MyDivision'
BEGIN
    SELECT CODE FROM SCM_MST_DIVISION A
    WHERE A.ATTRIBUTE3 <> 'EE'
    --AND DIVISION_ID NOT IN ('EE','EE_UC') ATTRIBUTE3 = 'ZZ'
    AND (CASE WHEN 1=1 THEN 1 END) = 1
END
IF @Code = 'NoFilter'
BEGIN
    SELECT 1  -- ATTRIBUTE3 <> 'X'
END"""
    cases = [(branch_filter(sql, 'MyDivision'), "ATTRIBUTE3 <> 'EE'"), (branch_filter(sql, 'A'), "ATTRIBUTE3 = '82'"),
             (branch_filter(sql, 'NoFilter'), ''), (branch_filter(sql, 'None'), '')]
    ok = sum(1 for a, b in cases if a == b)
    print(f'[combo_branch_filter selftest] {ok}/{len(cases)}')
    return 0 if ok == len(cases) else 1


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest':
        sys.exit(selftest())
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(2)
    print(json.dumps(resolve(sys.argv[1].upper()), ensure_ascii=False))
