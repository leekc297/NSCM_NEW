// TO-BE 라벨 별칭(명칭 변경 룰) — tools/Harness/rules/label_alias.csv (2026-10-30 사용자: SCP·SSP 'Valid' → 'Active', CR-092)
//   판정 엔진(judge.py)과 같은 데이터 파일을 읽는다. AS-IS 라벨이 별칭 원문이면 TO-BE 는 별칭 대상 라벨이어야 하고(같으면 PASS),
//   TO-BE 에 원문(Valid)이 남아 있으면 변경 대상(FAIL)이다. 비교 = '*'·대소문자·영숫자 외 문자 무시한 전체 일치.
import * as fs from 'node:fs';
import * as path from 'node:path';

import { parseCsv } from './probe';

export type LabelAlias = { req_id: string; scope: string; area: string; asis_label: string; tobe_label: string; match: string; note: string };

const ROOT = path.resolve(__dirname, '..', '..', '..');
const CSV = path.join(ROOT, 'tools', 'Harness', 'rules', 'label_alias.csv');
const canon = (s: unknown) => String(s || '').replace(/\*/g, '').toLowerCase().replace(/[^a-z0-9가-힣]/g, '');

function scopeOk(scope: string, id: string): boolean {
  const ss = String(scope || 'ALL').toUpperCase().split(';').map(s => s.trim()).filter(Boolean);
  return ss.includes('ALL') || ss.includes(id) || ss.some(s => s.length === 3 && id.startsWith(s));
}

/** 화면 ID 에 적용되는 별칭 행 */
export function loadLabelAliases(id: string): LabelAlias[] {
  if (!id || !fs.existsSync(CSV)) return [];
  return (parseCsv(fs.readFileSync(fs.realpathSync(CSV), 'utf8')) as unknown as LabelAlias[]).filter(a => a.asis_label && a.tobe_label && scopeOk(a.scope, id.toUpperCase()));
}

/** AS-IS 라벨 → 적용 별칭(없으면 null) */
export function aliasFor(asisLabel: string, aliases: LabelAlias[]): LabelAlias | null {
  const k = canon(asisLabel);
  return aliases.find(a => canon(a.asis_label) === k) || null;
}

/** TO-BE 라벨이 변경 전 원문(예 'Valid')으로 남아 있으면 그 별칭(= 변경 대상), 아니면 null */
export function leftoverAlias(tobeLabel: string, aliases: LabelAlias[]): LabelAlias | null {
  const k = canon(tobeLabel);
  return aliases.find(a => canon(a.asis_label) === k) || null;
}

/** AS-IS ↔ TO-BE 라벨 판정 — { res: 'PASS'|'FAIL'|null, why } · null = 별칭 무관(기존 판정 사용) */
export function judgeLabel(asisLabel: string, tobeLabel: string, aliases: LabelAlias[]): { res: 'PASS' | 'FAIL'; why: string } | null {
  const a = aliasFor(asisLabel, aliases);
  if (!a) return null;
  if (canon(tobeLabel) === canon(a.tobe_label)) return { res: 'PASS', why: `TO-BE 룰 ${a.req_id}: SCP·SSP 라벨 '${a.asis_label}' 은 '${a.tobe_label}' 로 변경(AS-IS 와 달라도 PASS)` };
  if (canon(tobeLabel) === canon(a.asis_label)) return { res: 'FAIL', why: `TO-BE 룰 ${a.req_id}: TO-BE 라벨이 변경 전 '${a.asis_label}' 그대로 — '${a.tobe_label}' 로 변경 대상(보완: SHEET_COLUMNS.COLUMN_LABEL_NAME 메타 / 조회조건 기준표·Form 라벨)` };
  return null;
}

/** 2026-11-20 T434(SCP0028 V-9e2b9258 G1 '조회조건 Model 칸을 찾지 못함'): 조회조건 기준표(search_cond.csv · CR-065 표준 명칭)가 같은 AS-IS 이름을
 *  한 TO-BE 이름으로 바꾼 비율이 USE 행 10건 이상·90% 이상이면 그 이름을 칸 찾기 별칭으로 쓴다(judge.py H5 기준표 행 0 경로와 같은 규칙).
 *  예 AS-IS 'Model' → 'Model/Nickname' 75/78행. 판정(PASS·FAIL)에는 쓰지 않고 칸 찾기에만 쓴다. 없으면 null */
let STD: Map<string, Map<string, { name: string; n: number }>> | null = null;
export function stdAlias(asisLabel: string): LabelAlias | null {
  if (!STD) {
    STD = new Map();
    try {
      const rows = parseCsv(fs.readFileSync(path.join(ROOT, 'tools', 'Harness', 'rules', 'search_cond.csv'), 'utf8').replace(/^﻿/, '')) as unknown as Record<string, string>[];
      for (const r of rows) {
        if ((r.usage || '') !== 'USE' || !r.asis_name || !r.tobe_name || r.tobe_name.trim() === '-') continue;
        const a = canon(r.asis_name), t = canon(r.tobe_name); const m = STD.get(a) || new Map(); const e = m.get(t) || { name: r.tobe_name.trim(), n: 0 }; e.n++; m.set(t, e); STD.set(a, m);
      }
    } catch { /* 기준표 없음 */ }
  }
  const k = canon(asisLabel); const m = STD.get(k); if (!m) return null;
  const tot = [...m.values()].reduce((s, e) => s + e.n, 0); const best = [...m.entries()].sort((x, y) => y[1].n - x[1].n)[0];
  if (!best || best[0] === k || best[1].n < 10 || best[1].n * 10 < tot * 9) return null;
  return { req_id: 'CR-065', scope: 'ALL', area: '조회조건', asis_label: asisLabel, tobe_label: best[1].name, match: 'exact', note: `조회조건 기준표 표준 명칭 ${best[1].n}/${tot}행` };
}
