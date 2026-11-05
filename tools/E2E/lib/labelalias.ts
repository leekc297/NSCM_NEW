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
