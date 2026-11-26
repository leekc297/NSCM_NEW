// 자동 생성 — tools/E2E/gen-e2e.js (2026-11-24) · 원천: Doc/gen/SSP0014/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것
import { test, expect } from '../../../tools/E2E/fixtures/test';
import * as fs from 'node:fs';
const PLAN = JSON.parse(fs.readFileSync(__dirname + '/SSP0014.plan.json', 'utf8'));
const MENU = "SSP0014";
import { crudCycle } from '../../../tools/E2E/lib/crud';
import { divisionCascade } from '../../../tools/E2E/lib/cascade';

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
      // 2026-10-27: division 모드(사용자가 화면 지정) = 계정이 대표하는 Division 마다 CASCADE → 조회 → CRUD. 그 외 모드 = 첫 Division 1회(CASCADE 확인 포함)
      const divs: string[] = (PLAN.mode === 'division' ? (acc.divisions && acc.divisions.length ? acc.divisions : [PLAN.sample.div]) : [(acc.divisions && acc.divisions[0]) || PLAN.sample.div]).filter(Boolean);
      test.setTimeout(120_000 + Math.max(1, divs.length) * 420_000);
      let out: any = null;
      for (const div of divs) {
        const cas = await divisionCascade(nscm, test.info(), PLAN, acc, div);
        if (acc.expectedDivs) expect.soft(cas.leak, `[${acc.id} ${div}] Division 후보 ⊆ 계정 Division 권한(unit_auth) — 권한 밖 Division 노출 0`).toEqual([]);
        if (cas.divListed !== null) expect.soft(cas.divListed, `[${acc.id}] 대표 Division ${div} 가 Division 후보에 있음`).toBeTruthy();
        for (const d of cas.deps) expect.soft(d.count, `[${acc.id} ${div}] Division 연동 조회조건 [${d.label}] 후보 1건 이상(CASCADE)`).toBeGreaterThan(0);
        const calls = await nscm.search(); for (const c of calls) expect.soft(c.status, `[${acc.id} ${div}] call-proc ${c.sheet}/${c.btn}`).toBeLessThan(400);
        const alert = await nscm.alertText(); if (alert) await nscm.closeAlert();
        const divVals = (await nscm.gridColumnValues('DIVISION')).concat(await nscm.gridColumnValues('DIVISION_ID')).concat(await nscm.gridColumnValues('Division'));
        if (divVals.length) expect.soft(divVals.every(v => !v || v.startsWith(div)), `[${acc.id} ${div}] 조회 결과 DIVISION 값 = 선택 Division`).toBeTruthy();
        const o = await crudCycle(nscm, test.info(), PLAN, MARK + (divs.length > 1 ? div.replace(/[^A-Za-z0-9]/g, '') : ''));
        test.info().annotations.push({ type: 'authcrud', description: `${acc.id} div=${div} mode=${o.mode} save=${o.saveVisible} insert=${o.insertVisible} delete=${o.deleteVisible} editable=${o.editable} saved=${o.saved} found=${o.found} cleaned=${o.cleaned} restored=${o.restored}` });
        out = out ? Object.assign({}, out, { saved: out.saved && o.saved, found: out.found && o.found, cleaned: out.cleaned && o.cleaned, restored: out.restored && o.restored, saveCalls: out.saveCalls + o.saveCalls, saveErrors: out.saveErrors.concat(o.saveErrors) }) : o;
      }
      if (!out) return;
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
