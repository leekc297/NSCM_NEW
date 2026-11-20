// 2026-11-20 A1 진입 확인 선행(CheckList 속도 개선 플랜): 본 시험 전에 화면을 한 번 열어 본다.
//   SCP0028·SSP0014(11-20)는 화면이 열리지 않은 채 시험 80개(화면 열기마다 66초)와 AI 판정 검토(묶음 224개)를 다 돌았다 → 열리지 않으면 run_verify 가 측정을 시작하지 않는다.
//   결과 = Doc/verify/<ID>/open_check.json { ok, at, url, authorized, notFound, beDown, feError, user }
//   실행: run_verify.py 가 VERIFY_ID 를 주고 `playwright test _open --grep @open` 으로 부른다
import * as fs from 'node:fs';
import * as path from 'node:path';
import { test } from '../../../tools/E2E/fixtures/test';

const ID = (process.env.VERIFY_ID || '').toUpperCase();
const ROOT = path.join(__dirname, '..', '..', '..');

test.describe(`진입 확인 ${ID} @open`, () => {
  test.describe.configure({ retries: 0 });
  test.skip(!ID, 'VERIFY_ID 없음');
  test('화면 열기 1회', async ({ nscm, page }) => {
    test.setTimeout(240_000);
    const r = await nscm.openScreen(ID);
    const url = page.url();
    const ok = r.authorized && !r.notFound && !r.beDown && !nscm.feError;
    const out = { ok, at: new Date().toISOString(), url, authorized: r.authorized, notFound: r.notFound, beDown: !!r.beDown, feError: nscm.feError || '', user: (nscm as unknown as { curUser?: string }).curUser || '' };
    const d = path.join(ROOT, 'Doc', 'verify', ID); fs.mkdirSync(d, { recursive: true });
    fs.writeFileSync(path.join(d, 'open_check.json'), JSON.stringify(out, null, 1), 'utf8');
    console.log(`[진입 확인] ${ID} ${ok ? '열림' : '열리지 않음'} · ${url}${nscm.feError ? ` · FE 변환 오류 ${nscm.feError}` : ''}${r.beDown ? ' · BE 응답 없음' : ''}${!r.authorized && !nscm.feError && !r.beDown ? ' · 권한 안내 또는 Home 으로 돌아감' : ''}`);
  });
});
