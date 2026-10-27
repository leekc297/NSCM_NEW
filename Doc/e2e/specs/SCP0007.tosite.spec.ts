// SCP0007 To Site 셀 콤보 3분기 확정(@tosite) — 2026-10-24 판정필요 ①(C2 6건) 확정용
//   AS-IS SCP0007_BOD.cs:1131-1161 SpdMain_ComboSelChange: From Site 접미 'E' → ToSiteBOD1 / 'A'+OSP_YN='Y' → ToSiteByDivisionPlant1 / 그 밖 → ToSiteByDivision1,
//   세 원천 모두 조회조건 Div(filterExpression DIVISION_ID IN …)로 다시 거른다.
//   조회조건 Div 를 ALL·40 으로 바꿔 세 종류 From Site 의 To Site 후보 수를 읽어 Doc/verify/SCP0007/tosite_probe.json 에 쓴다(기대값은 사내 DB 로 별도 계산). 저장하지 않는다
import * as fs from 'node:fs';
import * as path from 'node:path';

import { test } from '../../../tools/E2E/fixtures/test';
import { probe } from '../../../tools/E2E/lib/probe';

const OUT = path.resolve(__dirname, '..', '..', 'verify', 'SCP0007', 'tosite_probe.json');
const FROMS = ['KR02149300_40-A', 'HQ06-A', 'HQ06-E', 'HQ07-P'];

test('SCP0007 To Site 후보 — 조회조건 Div × From Site 분기 @tosite', async ({ nscm }) => {
  test.setTimeout(600_000);
  const p = nscm.page;
  const out: { div: string; from: string; set: boolean; fromNow: string; n: number; sample: string[] }[] = [];
  for (const div of ['ALL', '40']) {
    const r = await nscm.openScreen('SCP0007'); if (!r.authorized) return;
    await nscm.expandSearchArea();
    if (div !== 'ALL') {
      // 조회조건 Div 다중선택 콤보에서 40 하나만 남긴다(_verify G1 과 같은 방식)
      const area = (await nscm.visibleFirst(p.locator('[class*="searchArea"], [class*="SearchArea"]'))) || p.locator('body');
      const lab = await nscm.visibleFirst(area.getByText(/^\s*\*?\s*Div\s*\.?\s*\*?\s*$/i));
      const box = lab ? lab.locator('xpath=ancestor::*[.//*[@role="combobox"]][1]').locator('[role="combobox"]').first() : null;
      if (!box) throw new Error('조회조건 Div 콤보 없음');
      await box.click(); await p.waitForTimeout(500);
      const lis = p.locator('.MuiAutocomplete-popper li[role="option"]');
      const allChecked = await p.evaluate(() => { const c = [...document.querySelectorAll('.MuiAutocomplete-popper li[role="option"] input[type="checkbox"]')] as HTMLInputElement[]; return c.length > 0 && c.every(i => i.checked); });
      if (allChecked) { await lis.first().click(); await p.waitForTimeout(300); }
      const texts = (await lis.allInnerTexts()).map(t => t.trim());
      const idx = texts.findIndex(t => t === div || t.split(/\s+/)[0] === div);
      if (idx < 0) throw new Error(`Div 후보에 ${div} 없음: ${texts.slice(0, 12).join(',')}`);
      await lis.nth(idx).click(); await p.waitForTimeout(300); await p.keyboard.press('Escape'); await p.waitForTimeout(300);
    }
    await nscm.search(); for (let k = 0; k < 240 && (await probe.rowCount(p)) <= 0; k++) await p.waitForTimeout(500);
    await p.waitForLoadState('networkidle', { timeout: 20_000 }).catch(() => undefined); await nscm.clearDialogs();
    const sentDiv = nscm.calls.filter(c => /divisionId/.test(c.body || '')).map(c => (/"divisionId"\s*:\s*"([^"]*)"/.exec(c.body || '') || [])[1]).pop() ?? '?';
    await nscm.subButton('Insert').click({ timeout: 10_000 }); await p.waitForTimeout(1_000); await nscm.clearDialogs();
    const nr = await probe.findRow(p, 'new'); if (!nr) throw new Error('신규행 없음');
    if (!((await probe.value(p, nr.row, 'DIVISION_ID')) ?? '')) await probe.setByEditor(p, nr.row, 'DIVISION_ID', '40');
    for (const f of FROMS) {
      const set = await probe.setByEditor(p, nr.row, 'FROM_SITE_CODE', f); await p.waitForTimeout(600);
      const fromNow = (await probe.value(p, nr.row, 'FROM_SITE_CODE')) ?? '';
      const c = [...new Set(((await probe.candidates(p, nr.row, 'TO_SITE_CODE')) || []).filter(Boolean))];
      out.push({ div: `${div}(전송 '${sentDiv}')`, from: f, set, fromNow, n: c.length, sample: c.slice(0, 5) });
    }
  }
  fs.writeFileSync(OUT, JSON.stringify(out, null, 1), 'utf8');
});
