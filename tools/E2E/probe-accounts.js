#!/usr/bin/env node
'use strict';
// probe-accounts — accounts.json 의 계정(+ defaultAccount + scenarios 계정)을 BE 로그인으로 실제 확인해 loginOk 를 기록한다.
//   node probe-accounts.js            (BE: E2E_BE 또는 e2e.config.json beUrl — localhost 만 호출, 외부망 없음)
//   2026-10-20: FE 와 같은 POST /user/login {userId}(JsonLoginFilter, 비밀번호 없음) 로 확인. 2xx=OK · 401/403=사용자 없음(PR_GET_NSCM_USER) · 그 외=BE 상태 확인
//   /sso/dev-login 은 SsoDevController 에 @AuthCheck(NONE) 이 없어 항상 401 — 사용하지 않는다(BE 미수정)
const fs = require('fs'), path = require('path');
const cfg = JSON.parse(fs.readFileSync(path.join(__dirname, 'e2e.config.json'), 'utf8').replace(/^﻿/, ''));
const BE = process.env.E2E_BE || cfg.beUrl;
const accF = path.join(__dirname, 'accounts.json');
const acc = JSON.parse(fs.readFileSync(accF, 'utf8').replace(/^﻿/, ''));
const ids = new Set(acc.accounts.map(a => a.id)); if (cfg.defaultAccount) ids.add(cfg.defaultAccount);
for (const x of process.argv.slice(2)) ids.add(x);
(async () => {
  const ok = {}; let n = 0;
  for (const id of ids) {
    try {
      const r = await fetch(`${BE}/user/login`, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ userId: id }), redirect: 'manual', signal: AbortSignal.timeout(15000) });
      ok[id] = r.status >= 200 && r.status < 300; n += ok[id] ? 1 : 0;
      console.log(`${ok[id] ? 'OK  ' : 'FAIL'} ${id} HTTP ${r.status}`);
    } catch (e) { ok[id] = false; console.log(`FAIL ${id} ${e.message}`); }
  }
  for (const a of acc.accounts) a.loginOk = !!ok[a.id];
  acc.loginProbe = { be: BE, at: new Date().toISOString(), ok: Object.keys(ok).filter(k => ok[k]) };
  fs.writeFileSync(accF, JSON.stringify(acc, null, 2), 'utf8');
  console.log(`로그인 가능 ${n}/${ids.size} → accounts.json loginOk/loginProbe 갱신`);
  if (!n) process.exit(1);
})();
