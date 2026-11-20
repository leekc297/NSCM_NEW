// prereq — AS-IS '선행 칸' 을 사용자 순서대로 먼저 채운다(2026-11-09 T176 · SSP0025 신규행 Division 허위 FAIL 10건).
//   원천 = Doc/asisfacts/screens/<ID>/cell_prereq.csv (tools/Harness/verify/facts_prereq.py — AS-IS 편집 진입 이벤트의
//   'IsNullOrEmpty(선행 칸) [&& e.Column != 선행 칸] → 메시지 + return' 가드). 화면 독립: 칸 이름은 사실 파일에서만 온다.
//   AS-IS 사용자는 선행 칸(Division 등)을 고르지 않으면 다른 칸을 편집할 수 없다 → 검사기가 선행 칸을 비운 채 다른 칸을 측정하면
//   '편집 불가·자동완성 안 됨·저장 실패' 가 AS-IS 와 같은 동작인데도 FAIL 로 나온다. 신규행 측정 전에 이 함수로 채운다.
//   신규행 기본값(D4)·선행 칸 차단 자체를 보는 검사는 이 함수를 부르기 전에 측정해야 한다.
import type { Page } from '@playwright/test';
import * as fs from 'fs';
import * as path from 'path';
import { probe, parseCsv } from './probe';

const ROOT = path.join(__dirname, '..', '..', '..');
export type Prereq = { target: string; except: string; prereq: string; scope: string; cond_kind: string; msg: string; ref: string };

export function loadPrereq(id: string): Prereq[] {
  const fp = path.join(ROOT, 'Doc', 'asisfacts', 'screens', id, 'cell_prereq.csv');
  if (!fs.existsSync(fp)) return [];
  // cond_kind=ROW(행 값에 따라 걸리는 가드 — SCP0123 actv_cd == "A003")는 자동으로 채우지 않는다(그 조건이 아닌 행에선 AS-IS 도 요구하지 않음)
  return (parseCsv(fs.readFileSync(fp, 'utf8')) as unknown as Prereq[]).filter(r => r.prereq && r.cond_kind !== 'ROW');
}

/** 행 전체 선행 칸(target='*') 중 이 행에서 비어 있는 칸을 채운다. 값 = 같은 칸의 기존행 값(조회 결과와 같은 범위) 중 후보에 있는 것 → 없으면 첫 후보.
 *  targets 를 주면 그 칸이 요구하는 칸 지정 선행 칸(target=칸)도 채운다. 반환 = 채운 기록(증거용) · 실패도 기록(측정 실패를 숨기지 않음) */
export async function fillPrereq(p: Page, id: string, row: number, opt: { isNew?: boolean; targets?: string[] } = {}): Promise<string[]> {
  const rules = loadPrereq(id).filter(r => r.scope !== 'NEW' || opt.isNew !== false);
  const want: string[] = [];
  for (const r of rules) if (r.target === '*' && !want.includes(r.prereq)) want.push(r.prereq);
  for (const t of opt.targets || []) for (const r of rules) if (r.target === t && !want.includes(r.prereq)) want.push(r.prereq);
  const log: string[] = [];
  const bindings = (await probe.allBindings(p)) || [];
  for (const col of want) {
    if (!bindings.includes(col)) { log.push(`${col}: 그리드에 칸 없음`); continue; }
    const cur = (await probe.value(p, row, col)) ?? '';
    if (cur.trim()) continue;
    const opened = await probe.startEdit(p, row, col).catch(() => false); if (opened) await p.waitForTimeout(400);
    const cands = ((await probe.candidates(p, row, col)) || []).filter(t => t && t.trim() && !/^(-|\/|ALL)$/i.test(t.trim()));
    await probe.cancelEdit(p).catch(() => undefined);
    const ex = await probe.findRow(p, 'existing');
    const exDisp = ex ? ((await probe.displayText(p, ex.row, col).catch(() => null)) ?? '') : '';
    const pick = (exDisp && cands.find(c => c === exDisp)) || cands[0] || exDisp;
    if (!pick) { log.push(`${col}: 후보 없음 — 채우지 못함`); continue; }
    const ok = await probe.setByEditor(p, row, col, pick);
    await p.waitForTimeout(500);
    const after = (await probe.value(p, row, col)) ?? '';
    log.push(`${col}='${pick}'${ok && after.trim() ? '' : ' — 입력 실패(값 ' + after + ')'}`);
  }
  return log;
}
