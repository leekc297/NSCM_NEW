#!/usr/bin/env node
'use strict';
// 생성기(gen.js)와 게이트(check.js) 자체 시험. 개선안 20261126164445_VISION_4(2026-11-26).
//   기준 화면(DMF0004~0006 중 AS-IS 자료와 Doc/gen 산출이 있는 첫 화면)으로 gen.js 를 임시 폴더에 돌리고, 같은 결과에 check.js --json 을 돌린다.
//   genOutDir 만 임시 폴더로 바꾼 설정 사본을 쓴다. --apply 를 쓰지 않으므로 nscm-fe 에 쓰지 않고, 저장소 Doc/gen 에도 쓰지 않는다(전후 지문 비교로 확인).
//   사용: node tools/Harness/test/t_gen_check_smoke.js [--id DMF0005] [--keep]
//   판정: 'FAIL ' 줄 0 · 마지막 줄 ALL PASS · exit 0. engine_selfcheck.py GEN_SMOKE 가 부른다.
//   기대 BLOCK(KNOWN_BLOCK): 2026-11-26 16:5x 실측 DMF0005 = MS1 1건(AS-IS 메시지 ID MSG00097 그대로 사용). 생성기나 AS-IS 자료가 바뀌어 달라지면 실측 뒤 고친다.
const fs = require('fs'); const path = require('path'); const os = require('os'); const cp = require('child_process'); const crypto = require('crypto');
const HERE = path.resolve(__dirname, '..'); const ROOT = path.resolve(HERE, '..', '..');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const KNOWN_BLOCK = { DMF0005: { MS1: 1 } };
const cfg0 = JSON.parse(fs.readFileSync(path.join(HERE, 'harness.json'), 'utf8').replace(/^﻿/, ''));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x === undefined ? '' : x); if (!c) ok = false; };
const walk = d => { try { return fs.readdirSync(d, { withFileTypes: true }).flatMap(e => e.isDirectory() ? walk(path.join(d, e.name)) : [path.join(d, e.name)]); } catch { return []; } };
const sig = d => walk(d).map(f => { const s = fs.statSync(f); return `${path.relative(d, f)}|${s.size}|${s.mtimeMs}`; }).sort().join('\n');
const hashes = d => Object.fromEntries(walk(d).map(f => [path.relative(d, f).split(path.sep).join('/'), crypto.createHash('sha1').update(fs.readFileSync(f)).digest('hex')]));
const ID = (opt('--id') || ['DMF0004', 'DMF0005', 'DMF0006'].find(i => fs.existsSync(path.join(cfg0.asisOutDir, 'screens', i)) && fs.existsSync(path.join(cfg0.genOutDir, i))) || '').toUpperCase();
if (!ID) { console.log('FAIL 기준 화면 없음(DMF0004~0006 중 AS-IS 자료와 Doc/gen 산출이 같이 있는 화면 0개)'); console.log('SOME FAIL'); process.exit(1); }
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'gensmoke-')); const genOut = path.join(tmp, 'gen'); fs.mkdirSync(genOut);
const cfgF = path.join(tmp, 'harness.json'); fs.writeFileSync(cfgF, JSON.stringify(Object.assign({}, cfg0, { genOutDir: genOut }), null, 1), 'utf8');
const repoGen = path.join(cfg0.genOutDir, ID); const before = sig(repoGen);
const run = (file, args) => cp.spawnSync(process.execPath, [path.join(HERE, file), ...args], { cwd: ROOT, encoding: 'utf8', timeout: 180000, windowsHide: true, maxBuffer: 64 * 1024 * 1024 });
try {
  console.log(`기준 화면 ${ID} · 임시 폴더 ${tmp}`);
  // 1) gen.js
  const g = run('gen.js', [ID, '--config', cfgF]); const gl = `${g.stdout || ''}${g.stderr || ''}`;
  chk('gen.js exit 0', g.status === 0, `exit ${g.status} ${gl.trim().split(/\r?\n/).pop()}`);
  const m = /page=(\S+)/.exec(gl); const pageRel = m ? m[1] : ''; const pageDir = path.join(genOut, ID, pageRel);
  const files = walk(path.join(genOut, ID)).map(f => path.relative(path.join(genOut, ID), f).split(path.sep).join('/'));
  const need = ['register.json', 'GEN_NOTES.md', 'msg_map.json', 'e2e_plan.json'];
  chk('생성 파일: register.json, GEN_NOTES.md, msg_map.json, e2e_plan.json', need.every(n => files.includes(n)), files.filter(f => !f.includes('/')).join(', '));
  const pf = walk(pageDir).map(f => path.basename(f));
  chk('페이지 폴더: index.ts, *.constants.ts, __asis-mapping__.md, 화면 .tsx 1개 이상', !!pageRel && pf.includes('index.ts') && pf.some(f => /\.constants\.ts$/.test(f)) && pf.includes('__asis-mapping__.md') && pf.filter(f => /\.tsx$/.test(f)).length >= 1, `${pageRel} · ${pf.length}개`);
  const todo = walk(pageDir).filter(f => /\.tsx?$/.test(f)).reduce((n, f) => n + (fs.readFileSync(f, 'utf8').match(/TODO\(이식\)/g) || []).length, 0);
  chk('TODO(이식) 표지 있음', todo > 0, `${todo}건`);
  const constF = walk(pageDir).find(f => /\.constants\.ts$/.test(f));
  chk(`MENU_ID 상수 = ${ID}`, !!constF && fs.readFileSync(constF, 'utf8').includes(`export const MENU_ID = '${ID}' as const`));
  // 2) 같은 입력이면 같은 결과(결정론)
  const h1 = hashes(path.join(genOut, ID)); const g2 = run('gen.js', [ID, '--config', cfgF]); const h2 = hashes(path.join(genOut, ID));
  const diff = Object.keys(Object.assign({}, h1, h2)).filter(k => h1[k] !== h2[k]);
  chk('gen.js 두 번 실행 결과 같음', g2.status === 0 && !diff.length, diff.slice(0, 5).join(', '));
  // 3) check.js --json
  const c = run('check.js', ['--page', pageDir, '--id', ID, '--config', cfgF, '--json']);
  let j = null; try { j = JSON.parse(c.stdout); } catch { j = null; }
  chk('check.js exit 0/1/2 · JSON 출력', [0, 1, 2].includes(c.status) && !!j && Array.isArray(j.findings) && j.id === ID, `exit ${c.status}${j ? ` · BLOCK ${j.block} · WARN ${j.warn}` : ` · ${(c.stderr || '').trim().split(/\r?\n/).pop()}`}`);
  if (j) {
    const blk = {}; for (const f of j.findings.filter(x => x.level === 'BLOCK')) blk[f.code] = (blk[f.code] || 0) + 1;
    const known = KNOWN_BLOCK[ID] || {}; const extra = Object.keys(blk).filter(k => (blk[k] || 0) > (known[k] || 0));
    chk('check.js BLOCK = 기대 건수 이하(새 BLOCK 코드 0)', !extra.length && (c.status === 2) === (j.block > 0), `실측 ${JSON.stringify(blk)} · 기대 ${JSON.stringify(known)}${extra.length ? ` · 늘어난 코드 ${extra.join(', ')}: ${j.findings.filter(x => extra.includes(x.code)).slice(0, 2).map(x => x.msg).join(' / ').slice(0, 300)}` : ''}`);
    chk('check.js 보고(CHECK.md, CHECK.result.json, DOD.md)는 임시 폴더에', ['CHECK.md', 'CHECK.result.json', 'DOD.md'].every(n => fs.existsSync(path.join(genOut, ID, n))));
  }
  // 4) 저장소 Doc/gen/<ID> 그대로
  chk(`저장소 Doc/gen/${ID} 변경 0건`, sig(repoGen) === before);
} finally {
  if (!a.includes('--keep')) { try { fs.rmSync(tmp, { recursive: true, force: true }); } catch { } }
}
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
