// 디버그(2026-11-18): 시작·끝 월 칸 분리형 기간(SCP0111 Period) — periodShiftEnd · periodReverseTry · pickSplitMonth 자기 시험.
//   조회·저장하지 않는다. 화면의 조회조건 값만 바뀐다(조건 저장 버튼 안 누름)
import { test } from '../../../tools/E2E/fixtures/test';
import { findCondAny, isSplitPeriod, periodReverseTry, periodShiftEnd, periodValues } from '../../../tools/E2E/lib/smoke-extra';

test('분리형 기간 달력 조작 @dbgperiod', async ({ nscm }) => {
  test.setTimeout(300_000);
  const p = nscm.page;
  const fresh = async () => { await nscm.openScreen('SCP0111'); await p.waitForTimeout(1500); await nscm.clearDialogs(); return findCondAny(nscm, ['Period'], 'dbgP'); };
  let box = await fresh(); if (!box) { console.log('box 없음'); return; }
  console.log('kind', box.kind, 'split', await isSplitPeriod(box.root), 'values', JSON.stringify(await periodValues(box.root)));
  console.log('shiftEnd', JSON.stringify(await periodShiftEnd(nscm, box.root)));
  box = await fresh(); if (!box) return;
  console.log('reverseTry', JSON.stringify(await periodReverseTry(nscm, box.root)));
});
