# -*- coding: utf-8 -*-
"""엔진 갭 대조표 병합·온전성 점검(2026-10-31) — gap_*.csv → Doc/verify/_engine_gap.csv(항목 ID 부여·상태 열 유지)

  python tools/Harness/verify/engine_gap_merge.py <gap_ABC.csv> <gap_DEF.csv> <gap_GN.csv>
  점검: 규칙별 '문서 대상 행 수' ↔ 그 규칙 하위 항목 doc_rows 합. 합 < 원본이면 누락 의심. 대상 규칙이 빠지면 누락.
  build_status 열 = 신설 진행(미착수/구현/변이입증/완료). 재실행해도 기존 build_status 를 보존한다.
"""
import collections, csv, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
OUT = os.path.join(ROOT, 'Doc', 'verify', '_engine_gap.csv')


def rd(f):
    with open(f, encoding='utf-8-sig', newline='') as fh:
        return list(csv.DictReader(fh))


def main():
    rows = []
    for f in sys.argv[1:]:
        rows += rd(f)
    prev = {(r['rule_id'], r['sub_item']): r for r in rd(OUT)} if os.path.exists(OUT) else {}
    refs = collections.Counter()
    for r in rd(os.path.join(ROOT, 'Doc', 'verify', 'defects_classified.csv')):
        if r['status'] in ('DEFECT', '', 'REQ', 'OPEN'):
            for x in {x for x in re.split(r'[;,\s]+', r['rule_ids'].strip()) if x}:
                refs[x] += 1
    n = collections.Counter(); seq = 0; out = []
    for r in sorted(rows, key=lambda r: (r['rule_id'], {'없음': 0, '상속만': 1, '부분': 2, '미확인': 3, '있음': 4}.get(r['status'], 9), -int(r['doc_rows'] or 0))):
        seq += 1; n[r['rule_id']] += int(r['doc_rows'] or 0); p = prev.get((r['rule_id'], r['sub_item']), {})
        out.append({'gap_id': f'EG{seq:03d}', **{k: r.get(k, '') for k in ('rule_id', 'sub_item', 'doc_rows', 'doc_refs', 'status', 'code_ref', 'what_it_measures', 'missing', 'how_to_build')}, 'build_status': p.get('build_status', '해당없음' if r['status'] == '있음' else '미착수'), 'build_note': p.get('build_note', '')})
    with open(OUT, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(out[0].keys())); w.writeheader(); w.writerows(out)
    miss = [x for x in refs if x not in n]; short = [(x, n[x], refs[x]) for x in refs if x in n and n[x] < refs[x]]; extra = [x for x in n if x not in refs]
    print(f'하위 항목 {len(out)} · 규칙 {len(n)} / 문서 규칙 {len(refs)}')
    print('상태(항목):', dict(collections.Counter(r['status'] for r in out)))
    c = collections.Counter()
    for r in out:
        c[r['status']] += int(r['doc_rows'] or 0)
    print('상태(문서 행·중복 포함):', dict(c), '합', sum(c.values()))
    print('규칙 누락:', miss, '· 행 수 부족:', short, '· 문서에 없는 규칙:', extra)


if __name__ == '__main__':
    main()
