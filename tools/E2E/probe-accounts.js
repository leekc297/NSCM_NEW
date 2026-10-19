#!/usr/bin/env node
'use strict';
// probe-accounts — accounts.json 의 계정(+ defaultAccount + scenarios 계정)을 BE dev-login 으로 실제 확인해 loginOk 를 기록한다.
//   node probe-accounts.js            (BE: E2E_BE 또는 e2e.config.json beUrl — localhost 만 호출, 외부망 없음)
//   302(FE redirect)=OK · 401=SCM_ADM_USER_M/PR_GET_NSCM_USER 가 사용자를 못 찾음 · 그 외=BE 상태 확인
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
      const r = await fetch(`${BE}/sso/dev-login?id=${encodeURIComponent(id)}`, { redirect: 'manual', signal: AbortSignal.timeout(15000) });
      ok[id] = r.status === 302 || r.status === 301 || r.status === 303; n += ok[id] ? 1 : 0;
      console.log(`${ok[id] ? 'OK  ' : 'FAIL'} ${id} HTTP ${r.status}`);
    } catch (e) { ok[id] = false; console.log(`FAIL ${id} ${e.message}`); }
  }
  for (const a of acc.accounts) a.loginOk = !!ok[a.id];
  acc.loginProbe = { be: BE, at: new Date().toISOString(), ok: Object.keys(ok).filter(k => ok[k]) };
  fs.writeFileSync(accF, JSON.stringify(acc, null, 2), 'utf8');
  console.log(`로그인 가능 ${n}/${ids.size} → accounts.json loginOk/loginProbe 갱신`);
  if (!n) process.exit(1);
})();
