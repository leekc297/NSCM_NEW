# -*- coding: utf-8 -*-
"""정적 게이트 요약 — `run_verify.py <ID> --static` 의 마지막 단계(2026-11-08 · 사용자 결정 '순차 진행' (a))

  python tools/Harness/verify/static_gate.py <MENU_ID>     → Doc/verify/<ID>/static_gate.md · static_gate.json · stdout 요약 · exit 0(FAIL 0) / 2(정적 FAIL ≥1)

정적 = 브라우저(E2E) 없이 판정된 행 = tobe_ref 가 'E2E'·'수동 E2E'·'DB @diff' 로 시작하지 않는 행(STATIC Form 라벨·META·SYN·sort·align·i18n 정적·대조표 추적·
  오라클 분류·적용성 NA 등). E2E 가 필요한 행은 NOT_RUN 으로 남아 '런타임 보류' 로 집계만 한다(CheckList 판을 만들지 않는다 — 생성·보정 직후 1~3분 게이트용).
FAIL 집계 규칙: 사용자 판정 행·상속(규칙 N 판정 …)·집계(진입점/행 집계) 행은 '직접 FAIL' 에서 뺀다(원천 행이 이미 들어 있다).
"""
import csv, io, json, os, re, sys, collections

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
RUNTIME = ('E2E', '수동 E2E', 'DB @diff')
INHERIT = re.compile(r'^(\[[^\]]*\]\s*|실측\[T-[0-9a-f]+\]: )*(행 집계|진입점 집계|선행 미구현에 종속|선행 대조표 |규칙 \w+ 판정 \d+행)')


def main(mid):
    mid = mid.upper(); led = os.path.join(ROOT, 'Doc', 'verify', mid, 'verify_ledger.csv')
    if not os.path.exists(led):
        print(f'[static_gate] {mid}: 원장 없음 {led}'); return 3
    rows = list(csv.DictReader(io.open(led, encoding='utf-8-sig')))
    static = [r for r in rows if not (r.get('tobe_ref') or '').startswith(RUNTIME)]
    pending = [r for r in rows if r['result'] == 'NOT_RUN']
    judged = [r for r in static if r['result'] not in ('NOT_RUN', '')]
    dist = collections.Counter(r['result'] for r in judged)
    fails = [r for r in judged if r['result'] == 'FAIL' and not (r.get('evidence') or '').startswith('[사용자판정]') and not INHERIT.match(r.get('evidence') or '')]
    user_fail = [r for r in judged if r['result'] == 'FAIL' and (r.get('evidence') or '').startswith('[사용자판정]')]
    errs = collections.Counter((re.match(r'\[([^\]:—]{1,30})', r.get('evidence') or '') or [None, (r.get('evidence') or '')[:20]])[1] for r in judged if r['result'] == 'ERROR')
    by_rule = collections.Counter(r['rule_id'] for r in fails)
    # E2E 유래 행(직전 실행 결과가 원장에 남은 것)의 FAIL 은 이번 게이트 범위 밖이지만 숨기지 않는다 — 별도 집계·목록(정직 보고)
    rt_fail = [r for r in rows if (r.get('tobe_ref') or '').startswith(RUNTIME) and r['result'] == 'FAIL' and not (r.get('evidence') or '').startswith('[사용자판정]') and not INHERIT.match(r.get('evidence') or '')]
    rules_static = sorted({r['rule_id'] for r in judged if r['result'] in ('PASS', 'FAIL')})
    out = {'menu_id': mid, 'rows': len(rows), 'static_judged': len(judged), 'runtime_pending': len(pending), 'dist': dict(dist),
           'fail_direct': len(fails), 'fail_user': len(user_fail), 'fail_by_rule': dict(by_rule), 'error_by_prefix': dict(errs.most_common(12)),
           'runtime_fail_prev': len(rt_fail), 'runtime_fail_rows': [{'row_id': r['row_id'], 'rule_id': r['rule_id'], 'target': r['target'][:60], 'evidence': (r.get('evidence') or '')[:200]} for r in rt_fail],
           'rules_static_measured': rules_static,
           'fails': [{'row_id': r['row_id'], 'rule_id': r['rule_id'], 'target': r['target'][:80], 'expect_src': r.get('expect_src', ''), 'evidence': (r.get('evidence') or '')[:400], 'tobe_ref': (r.get('tobe_ref') or '')[:60]} for r in fails]}
    d = os.path.join(ROOT, 'Doc', 'verify', mid)
    json.dump(out, io.open(os.path.join(d, 'static_gate.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    md = [f'# 정적 게이트 {mid} — {__import__("time").strftime("%Y-%m-%d %H:%M")}', '',
          f'- 원장 {len(rows)}행 · 정적 판정 {len(judged)}행({" · ".join(f"{k} {v}" for k, v in sorted(dist.items()))}) · 런타임(E2E) 보류 {len(pending)}행',
          f'- **직접 FAIL {len(fails)}** · 사용자 판정 FAIL {len(user_fail)} · 정적 실측 규칙 {len(rules_static)}종: {", ".join(rules_static)}', '',
          '## 직접 FAIL(정적)', '', '| row_id | 규칙 | 대상 | 기대 원천 | 증거 |', '|---|---|---|---|---|']
    md += [f"| {f['row_id']} | {f['rule_id']} | {f['target'][:50]} | {f['expect_src'][:40]} | {f['evidence'][:180].replace('|', '／')} |" for f in out['fails']] or ['| - | - | 없음 | | |']
    md += ['', '## ERROR 사유(정적)', ''] + [f'- {n} {k}' for k, n in errs.most_common(12)]
    md += ['', f'## E2E 유래 FAIL(직전 실행 결과 · 이번 게이트 범위 밖 · 숨기지 않음) — {len(rt_fail)}행', '']
    md += [f"- {r['row_id']} {r['rule_id']} {r['target'][:40]} — {(r.get('evidence') or '')[:140].replace('|', '／')}" for r in rt_fail[:30]] or ['- 없음']
    md += ['', '> 이 게이트는 CheckList 판을 만들지 않는다. E2E 가 필요한 행은 정규 실행(run_verify.py <ID>) 또는 부분 재판정(--only <규칙>)에서 판정한다.']
    io.open(os.path.join(d, 'static_gate.md'), 'w', encoding='utf-8', newline='\n').write('\n'.join(md) + '\n')
    print(f"[static_gate] {mid}: 정적 판정 {len(judged)}행 · 직접 FAIL {len(fails)}(규칙 {dict(by_rule)}) · 사용자 FAIL {len(user_fail)} · ERROR {dist.get('ERROR', 0)} · 런타임 보류 {len(pending)} · E2E 유래 FAIL(직전) {len(rt_fail)} → Doc/verify/{mid}/static_gate.md")
    return 2 if fails else 0


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(1)
    sys.exit(main(sys.argv[1]))
