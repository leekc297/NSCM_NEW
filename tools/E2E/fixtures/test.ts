import * as fs from 'node:fs';
import * as path from 'node:path';
import { test as base } from '@playwright/test';
import { Nscm, CFG, beLogMark, beLogErrors } from '../lib/nscm';
import { installRequestMutations, flushMutationLog } from '../lib/mutate';
export type Opts = { account: string; division: string };
export const test = base.extend<{ nscm: Nscm } & Opts>({
  account: [process.env.E2E_ACCOUNT || CFG.defaultAccount, { option: true }],
  division: [process.env.E2E_DIVISION || CFG.defaultDivision, { option: true }],
  // 2026-10-29: 픽스처 자체 timeout — 로그인 재시도(풀 고갈 60초 대기 × 최대 4회)가 테스트 timeout(180s)을 깎아 본문 전에 끝나지 않게 분리한다(Playwright fixture timeout 옵션)
  nscm: [async ({ page, account }, use, testInfo) => {
    // 2026-10-26: 테스트 구간의 BE 로그 DB 오류(시노님·권한·SQL) 검출 — 모든 스펙(smoke·crud·auth·authcrud·verify) 공통
    const mark = beLogMark();
    await installRequestMutations(page);  // CheckList 자기검증 요청 변이(CL_MUTATE 지정 시만, 2026-10-28)
    // VERIFY_NO_SAVE=1 — 저장 계열 call-proc 를 서버로 보내지 않고 가짜 응답으로 돌려준다(요청 자체는 nscm.calls 에 남아 '저장 요청이 나갔다' 는 사실은 측정된다) · 정리 정의 없는 화면 일괄 실행용
    if (process.env.VERIFY_NO_SAVE || process.env.CL_FAKE_SAVE) await page.route(/\/(SAVE|INS|UPD|DEL)[^/]*\/call-proc/i, r => r.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({ success: true, data: [], message: '[VERIFY_NO_SAVE] 서버 미전송' }) }));
    const n = new Nscm(page); await n.loginAs(account); await use(n);
    await flushMutationLog(page, testInfo.title);
    const errs = beLogErrors(mark);
    if (errs.length || n.serverErrors.length) {
      testInfo.annotations.push({ type: 'dberr', description: `BE 5xx ${n.serverErrors.length}건${n.serverErrors.length ? ' (' + n.serverErrors.slice(0, 3).map(e => `${e.status} ${e.url.replace(/^.*\/api\//, '')}`).join(' | ') + ')' : ''} · 같은 시간 BE 로그 DB 오류 ${errs.length}건: ${errs.slice(0, 6).map(e => `[${e.cls}] ${e.code} ${e.object || e.msg.slice(0, 60)}`).join(' | ')}` });
      // 이 화면 요청이 5xx 를 받았을 때만 실패로 귀속한다(같은 BE 를 쓰는 다른 사용자 요청의 오류는 기록만)
      // 2026-10-29: 같은 BE 를 쓰는 다른 세션의 ORA-00942 가 이 화면 5xx 와 같은 시간대에 찍혀 이 화면의 차단으로 오인(SCP0007 W4c 중단·허위 DB-SYN FAIL)
      //   → 이 화면이 받은 5xx 응답 본문에 시노님·권한 오류 코드가 있을 때만 중단(fail-fast). 그 밖의 5xx(ORA-06502 등 업무 SQL 오류)는 각 검사가 FAIL 로 기록하므로 중단하지 않는다
      // CR-076(2026-10-29): 시노님·권한(SYN) 뿐 아니라 DB 객체 없음·컴파일·인자 불일치(OBJ)·메타 누락(META)도 이 화면 응답 본문에 있으면 '환경 차단' 으로 중단한다 — 비정상 테스트 결과를 결함으로 적지 않기 위해
      const ownAll = n.serverErrors.filter(e => /ORA-00942|ORA-04043|PLS-00201|PLS-00306|PLS-00302|ORA-00904|ORA-01031|ORA-00980|ORA-04063|ORA-06508|ORA-04068|ORA-04061|ORA-06575|NullPointerException|프로시저 정보 없음/.test(e.body || ''));
      // 2026-10-29(사용자 승인): 콤보·룩업 API(/admin/combo·lookup·lookup-muti — SCMP_APP 세션에서 직접 실행되는 동적 SQL)의 오류는 메인 조회(call-proc, DEFINER 패키지)와 무관하다
      //   → 메인 조회가 정상이면 중단하지 않고 '부분 차단' 으로 기록(dberr_partial.json) · 그 콤보에 의존하는 검사만 judge 가 ERROR(차단 영향)로. call-proc·메뉴/권한 API 의 오류만 중단(fail-fast)
      const isSoft = (u: string) => /\/admin\/(combo|lookup|lookup-muti)\b/.test(u);
      const ownSyn = ownAll.filter(e => !isSoft(e.url));
      const ownSoft = ownAll.filter(e => isSoft(e.url));
      if (ownSoft.length) {
        try {
          const dir = process.env.E2E_RESULTS || path.join(__dirname, '..', '..', '..', 'Doc', 'e2e', 'results'); fs.mkdirSync(dir, { recursive: true });
          const fp = path.join(dir, 'dberr_partial.json'); const prev = fs.existsSync(fp) ? JSON.parse(fs.readFileSync(fp, 'utf8')) : [];
          const objs = [...new Set(ownSoft.flatMap(e => [...(e.body || '').matchAll(/"SCMP_APP"\."([A-Z0-9_$#]+)"/g)].map(m => m[1])))];
          prev.push({ test: testInfo.title, at: new Date().toISOString(), urls: [...new Set(ownSoft.map(e => e.url.replace(/^.*\/api\//, '')))], objects: objs, codes: [...new Set(ownSoft.map(e => ((e.body || '').match(/(ORA|PLS)-\d{5}/) || [''])[0]).filter(Boolean))] });
          fs.writeFileSync(fp, JSON.stringify(prev, null, 1), 'utf8');
        } catch { /* 기록 실패는 무시 */ }
        testInfo.annotations.push({ type: 'dberr-soft', description: `콤보/룩업 API 시노님·객체 오류 ${ownSoft.length}건(부분 차단 — 메인 조회와 무관, 콤보 의존 검사만 차단 영향)` });
      }
      if (ownSyn.length && errs.length) {
        const syn = errs.filter(e => (e.cls === 'SYN' || e.cls === 'OBJ' || e.cls === 'META') && ownSyn.some(o => (o.body || '').includes(e.object.replace(/"/g, '')) || !e.object || e.cls === 'META'));
        const kinds: Record<string, string> = { SYN: '시노님·권한 누락', OBJ: 'DB 객체 오류(없음·컴파일·인자 불일치)', META: '메타(PROC_M/API_M) 오류' };
        const grp = (['SYN', 'OBJ', 'META'] as const).map(k => [k, syn.filter(e => e.cls === k)] as const).filter(([, l]) => l.length).map(([k, l]) => `${kinds[k]} ${l.length}건(${l.slice(0, 4).map(e => `${e.code} ${e.object}`).join(', ')})`).join(' / ');
        throw new Error(`BE DB 오류 — ${syn.length ? `${grp} — tools/Harness/verify/syn_check.py 로 정적 확인` : ''}${syn.length && errs.length > syn.length ? ' · ' : ''}${errs.length > syn.length ? `SQL 오류 ${errs.length - syn.length}건(${errs.filter(e => e.cls === 'DB').slice(0, 3).map(e => e.code + ' ' + e.msg.slice(0, 50)).join(', ')})` : ''}`);
      }
    }
  }, { timeout: 360_000 }],
});
export { expect } from '@playwright/test';
