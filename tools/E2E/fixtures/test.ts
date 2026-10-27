import { test as base } from '@playwright/test';
import { Nscm, CFG, beLogMark, beLogErrors } from '../lib/nscm';
export type Opts = { account: string; division: string };
export const test = base.extend<{ nscm: Nscm } & Opts>({
  account: [process.env.E2E_ACCOUNT || CFG.defaultAccount, { option: true }],
  division: [process.env.E2E_DIVISION || CFG.defaultDivision, { option: true }],
  nscm: async ({ page, account }, use, testInfo) => {
    // 2026-10-26: 테스트 구간의 BE 로그 DB 오류(시노님·권한·SQL) 검출 — 모든 스펙(smoke·crud·auth·authcrud·verify) 공통
    const mark = beLogMark();
    const n = new Nscm(page); await n.loginAs(account); await use(n);
    const errs = beLogErrors(mark);
    if (errs.length || n.serverErrors.length) {
      testInfo.annotations.push({ type: 'dberr', description: `BE 5xx ${n.serverErrors.length}건${n.serverErrors.length ? ' (' + n.serverErrors.slice(0, 3).map(e => `${e.status} ${e.url.replace(/^.*\/api\//, '')}`).join(' | ') + ')' : ''} · 같은 시간 BE 로그 DB 오류 ${errs.length}건: ${errs.slice(0, 6).map(e => `[${e.cls}] ${e.code} ${e.object || e.msg.slice(0, 60)}`).join(' | ')}` });
      // 이 화면 요청이 5xx 를 받았을 때만 실패로 귀속한다(같은 BE 를 쓰는 다른 사용자 요청의 오류는 기록만)
      if (n.serverErrors.length && errs.length) {
        const syn = errs.filter(e => e.cls === 'SYN');
        throw new Error(`BE DB 오류 — ${syn.length ? `시노님·권한 누락 ${syn.length}건(${syn.slice(0, 4).map(e => `${e.code} ${e.object}`).join(', ')}) — tools/Harness/verify/syn_check.py 로 정적 확인` : ''}${syn.length && errs.length > syn.length ? ' · ' : ''}${errs.length > syn.length ? `SQL 오류 ${errs.length - syn.length}건(${errs.filter(e => e.cls === 'DB').slice(0, 3).map(e => e.code + ' ' + e.msg.slice(0, 50)).join(', ')})` : ''}`);
      }
    }
  },
});
export { expect } from '@playwright/test';
