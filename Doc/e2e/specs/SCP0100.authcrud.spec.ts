// 자동 생성 — tools/E2E/gen-e2e.js (2026-10-20) · 원천: Doc/gen/SCP0100/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것
import { test, expect } from '../../../tools/E2E/fixtures/test';
import * as fs from 'node:fs';
const PLAN = JSON.parse(fs.readFileSync(__dirname + '/SCP0100.plan.json', 'utf8'));
const MENU = "SCP0100";
import { crudCycle } from '../../../tools/E2E/lib/crud';

// 계정별 권한 CRUD — 기대 권한은 To-Be 메타(그룹 소속 user_group_user.csv × 버튼 권한 btn_auth.csv), 데이터셋 그룹은 표기만. 로그인은 비밀번호 없는 /user/login(id)
const CODES: string[] = PLAN.menuBtnCodes || [];
const has = (arr: string[] | null, code: string) => arr ? arr.includes(code) : null;
for (const acc of PLAN.accounts) {
  const G = (acc.tobeGroups && acc.tobeGroups.length ? acc.tobeGroups : acc.groups) as string[];
  test.describe(`${MENU} 권한별 CRUD @authcrud [${acc.id} ${G.join('/')}]`, () => {
    test.use({ account: acc.id });
    const MARK = "E2E_" + acc.id.replace(/[^A-Za-z0-9]/g, '').slice(0, 6).toUpperCase() + Date.now().toString(36).toUpperCase().slice(-4);
    test('메뉴 접근 → 기대 버튼(SAVE/INSERT/DELETE/EDIT) ↔ 실제 노출·편집 → 허용이면 마커 행 CRUD · 비허용이면 편집 불가', async ({ nscm }) => {
      test.setTimeout(420_000); // 로그인 → 조회(최대 searchTimeoutMs) → CRUD 사이클(저장·재조회 반복) 예산
      const expSave = has(acc.expectedBtns, 'SAVE'), expIns = CODES.includes('INSERT') ? has(acc.expectedBtns, 'INSERT') : null, expDel = CODES.includes('DELETE') ? has(acc.expectedBtns, 'DELETE') : null, expEdit = CODES.includes('EDIT') ? has(acc.expectedBtns, 'EDIT') : null;
      test.info().annotations.push({ type: 'authcrud', description: `tobeGroups=${G.join('|') || '-'} menuAccess=${acc.menuAccess || '?'} expected=${acc.expectedBtns ? acc.expectedBtns.join('|') : '(btn_auth 미등록)'} dataset=${acc.groups.join('|')} matrix=${(acc.matrix || []).join(' ') || '-'}` });
      const r = await nscm.openScreen(MENU);
      if (!r.authorized || r.notFound) { expect.soft(acc.menuAccess, `[${acc.id}] 메뉴 권한 있음(user_group_menu) 인데 접근 불가 (authorized=${r.authorized} notFound=${r.notFound})`).not.toBe('Y'); return; }
      // 메뉴 권한 없는 계정도 URL 직접 접근으로는 열린다(To-Be FE 라우트 가드 없음) → 기록하고, 버튼·편집은 '없어야 함' 으로 계속 검증
      if (acc.menuAccess === 'N') test.info().annotations.push({ type: 'gap', description: `메뉴 권한(user_group_menu) 없는 계정이 /view/${MENU} 직접 접근으로 열림` });
      const div = (acc.divisions && acc.divisions[0]) || PLAN.sample.div; if (div) await nscm.setDivision(div);
      const calls = await nscm.search(); for (const c of calls) expect.soft(c.status, `[${acc.id}] call-proc ${c.sheet}/${c.btn}`).toBeLessThan(400);
      const out = await crudCycle(nscm, test.info(), PLAN, MARK);
      // 버튼 노출 ↔ 기대
      if (expSave != null) expect.soft(out.saveVisible, `[${acc.id} ${G.join('/')}] btn_auth SAVE=${expSave ? 'Y' : 'N'} → Save 버튼 ${expSave ? '노출' : '비노출'}`).toBe(expSave);
      if (expIns != null) expect.soft(out.insertVisible, `[${acc.id}] btn_auth INSERT=${expIns ? 'Y' : 'N'} → Insert 버튼`).toBe(expIns);
      if (expDel != null) expect.soft(out.deleteVisible, `[${acc.id}] btn_auth DELETE=${expDel ? 'Y' : 'N'} → Delete 버튼`).toBe(expDel);
      // EDIT 코드 = 셀 편집 권한 → 편집기 열림 여부와 대조(판정 가능할 때만)
      if (expEdit != null && out.editable != null) expect.soft(out.editable, `[${acc.id}] btn_auth EDIT=${expEdit ? 'Y' : 'N'} → 셀 편집기 ${expEdit ? '열림' : '안 열림'}`).toBe(expEdit);
      if (expSave === true) {
        if (out.mode === 'insert') { expect.soft(out.saved, `[${acc.id}] 허용 계정 마커 행 저장 ${out.saveErrors.join(' / ')}`).toBeTruthy(); expect.soft(out.found, `[${acc.id}] 재조회 후 신규 행 존재`).toBeTruthy(); expect(out.cleaned, `[${acc.id}] 마커 행 정리 완료`).toBeTruthy(); }
        else if (out.mode === 'edit-save') { expect.soft(out.editable, `[${acc.id}] 허용 계정 편집 가능 셀 존재`).toBeTruthy(); if (out.editable) { expect.soft(out.saved, `[${acc.id}] 수정 저장 성공 ${out.saveErrors.join(' / ')}`).toBeTruthy(); expect.soft(out.found, `[${acc.id}] 재조회 후 수정값 반영`).toBeTruthy(); expect(out.restored, `[${acc.id}] 원래 값 복원 저장·확인`).toBeTruthy(); } }
      } else if (expSave === false) {
        if (out.editable != null) expect.soft(out.editable, `[${acc.id}] 비허용 계정 셀 편집 불가`).toBeFalsy();
        expect.soft(out.saveCalls, `[${acc.id}] 비허용 계정 SAVE 계열 call-proc 0`).toBe(0);
      } else test.info().annotations.push({ type: 'note', description: 'btn_auth 에 이 계정 그룹의 행이 없어 실측만 기록(기대 없음)' });
      await nscm.snapshot(`${MENU}_authcrud_${acc.id}`);
    });
  });
}
