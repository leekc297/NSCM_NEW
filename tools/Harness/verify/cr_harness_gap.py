# -*- coding: utf-8 -*-
"""cr_harness_gap — 확정 룰(confirmed_requirements.csv)이 하네스(생성기·게이트·공용 컴포넌트)에 등록돼 원천 차단되는지 현황표
  python cr_harness_gap.py            → Doc/verify/_cr_harness_gap.md (+ 콘솔 요약)
  사용자 제안 2026-10-28: "정합검증 대상 RULE 을 필요 시 하네스에 등록해서 생성이나 보완 시 적용되도록 하면 원천적으로 오류 발생의 소지를 줄일 수 있다"
  판정: harness 열이 비어 있으면 '정합검증만'(사후 검출) — 생성·보완 단계 강제 없음 → 등록 후보. method 가 E2E 만이면 정적 게이트로 옮기기 어려운 동작 규칙(E2E 로만 검출)일 수 있어 '검토' 표기.
"""
import csv, io, os, sys, datetime, collections
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
C = os.path.join(ROOT, 'tools', 'Harness', 'rules', 'confirmed_requirements.csv')
rows = list(csv.DictReader(io.StringIO(open(C, encoding='utf-8-sig').read())))
reg = [r for r in rows if (r.get('harness') or '').strip()]; gap = [r for r in rows if not (r.get('harness') or '').strip()]
by_rule = collections.Counter(x for r in gap for x in (r.get('rule_ids') or '').split(';') if x)
md = [f"# 확정 룰 → 하네스 등록 현황 ({datetime.datetime.now():%Y-%m-%d %H:%M})", '',
      f"- 확정 룰 {len(rows)}건 · 하네스 등록(생성·게이트에서 강제) {len(reg)}건 · **정합검증만(사후 검출) {len(gap)}건**",
      f"- 미등록 룰의 규칙 분포: " + ' · '.join(f'{k} {v}' for k, v in by_rule.most_common(12)), '',
      '## 하네스 등록됨', '', '| CR | 규칙 | 대상 | 강제 위치 |', '|---|---|---|---|']
md += [f"| {r['req_id']} | {r.get('rule_ids', '')} | {r.get('target', '')[:50]} | {r['harness']} |" for r in reg]
md += ['', '## 정합검증만 — 등록 후보(생성·보완 단계 강제 없음)', '', '| CR | 규칙 | 대상 | 판정 방법 | 등록 제안 |', '|---|---|---|---|---|']
def hint(r):
    m = r.get('method', ''); rid = r.get('rule_ids', '')
    if 'META' in m: return '메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트'
    if 'STATIC' in m or 'DB' in m: return 'check.js/check-pkg 정적 게이트'
    if any(x in rid for x in ('K1', 'K2', 'K3', 'H4', 'L1', 'L2')): return '공용 컴포넌트(DataGrid/SearchArea) 기본 동작 — 컴포넌트 단위 테스트'
    return '검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목'
md += [f"| {r['req_id']} | {r.get('rule_ids', '')} | {r.get('target', '')[:50]} | {r.get('method', '')} | {hint(r)} |" for r in gap]
out = os.path.join(ROOT, 'Doc', 'verify', '_cr_harness_gap.md'); os.makedirs(os.path.dirname(out), exist_ok=True)
open(out, 'w', encoding='utf-8').write('\n'.join(md) + '\n')
print(f"확정 룰 {len(rows)} · 하네스 등록 {len(reg)} · 정합검증만 {len(gap)} → {out}")
