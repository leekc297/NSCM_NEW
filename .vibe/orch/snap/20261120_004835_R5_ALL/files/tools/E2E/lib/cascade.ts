// 권한·Division CASCADE 실측 — <ID>.authcrud.spec.ts(division 모드: 계정이 대표하는 Division 마다 CASCADE → 조회 → CRUD)
//   2026-10-27 사용자 지시: "권한별 CRUD 는 권한별/DIVISION별 CRUD/CASCADE 로 · CASCADE 이후 CRUD 까지 정합검증·테스트"
//   ① Division 후보 = 계정 Division 권한(unit_auth D · 메뉴 권한 있는 그룹) 안에서만(밖의 Division 노출 0) · 대표 Division 포함
//   ② 대표 Division 선택 → Division 연동 조회조건(AS-IS 콤보 원천이 DIVISION_ID 로 거르는 조건) 후보가 비지 않음
//   결과는 test.info() 주석 'cascade' 로 남겨 정합검증 judge.py 가 J1(권한 Division 노출)·C1(조회조건 cascade)로 반입한다
import type { TestInfo } from '@playwright/test';
import type { Nscm } from './nscm';
import { findCond } from './smoke-extra';

export type CascadePlan = { divLabels?: string[]; divCascade?: string[][] };
export type CascadeOutcome = { div: string; candidates: string[]; leak: string[]; divListed: boolean | null; selected: boolean; deps: Array<{ label: string; count: number; sample: string[] }>; notes: string[] };

const famOf = (c: string) => c.split('_')[0];
const codeOf = (t: string) => (t.trim().match(/^([A-Za-z0-9_]+)/) || [, ''])[1];

/** 조회조건 칸의 콤보 후보 글자 목록(ALL/SELECT ALL 제외) — 열고 읽고 닫는다 */
async function comboOptions(nscm: Nscm, labels: string[], tag: string): Promise<string[] | null> {
  const c = await findCond(nscm, labels, tag);
  if (!c || c.kind !== 'combo') return null;
  const page = nscm.page; const combo = c.root.locator('[role="combobox"]').first();
  await combo.click({ timeout: 5_000 }).catch(() => undefined);
  const opts = page.locator('.MuiAutocomplete-popper [role="option"], .MuiAutocomplete-popper li, [role="listbox"] [role="option"]');
  await opts.first().waitFor({ state: 'visible', timeout: 5_000 }).catch(() => undefined);
  const texts = (await opts.allInnerTexts().catch(() => [] as string[])).map(t => t.trim()).filter(t => t && !/^(select\s*)?all$|^전체$/i.test(t));
  await page.keyboard.press('Escape').catch(() => undefined); await page.waitForTimeout(300);
  return texts.slice(0, 500);
}

export async function divisionCascade(nscm: Nscm, info: TestInfo, plan: CascadePlan, acc: { id: string; expectedDivs?: string[] | null }, div: string): Promise<CascadeOutcome> {
  const out: CascadeOutcome = { div, candidates: [], leak: [], divListed: null, selected: false, deps: [], notes: [] };
  await nscm.expandSearchArea();
  const opts = await comboOptions(nscm, plan.divLabels || ['Div', 'Division', 'Div.'], `cas-div-${div}`);
  if (opts) {
    out.candidates = opts.map(codeOf).filter(Boolean);
    const exp = acc.expectedDivs || null;
    if (exp) out.leak = out.candidates.filter(c => !exp.includes(c) && !exp.some(e => famOf(e) === c));
    out.divListed = out.candidates.some(c => c === div || famOf(c) === div);
  } else out.notes.push('Division 콤보 칸을 찾지 못함(라벨 ' + (plan.divLabels || []).join('/') + ')');
  out.selected = await nscm.setDivision(div);
  let k = 0;
  for (const labels of plan.divCascade || []) {
    const o = await comboOptions(nscm, labels, `cas-dep-${div}-${k++}`);
    if (o == null) { out.notes.push(`연동 조건 [${labels[0]}] 콤보 칸 없음`); continue; }
    out.deps.push({ label: labels[0], count: o.length, sample: o.slice(0, 5) });
  }
  info.annotations.push({ type: 'cascade', description: `${acc.id} div=${div} 선택=${out.selected} 후보=[${out.candidates.join(',')}] 권한=[${(acc.expectedDivs || []).join(',') || '?'}] 권한밖=${out.leak.length ? out.leak.join(',') : '0'} 대표포함=${out.divListed} 연동=${out.deps.map(d => `${d.label}:${d.count}`).join(',') || '-'}${out.notes.length ? ' 비고=' + out.notes.join('/') : ''}` });
  return out;
}
