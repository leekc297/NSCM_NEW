#!/usr/bin/env node
'use strict';
// TobeFacts — To-Be(React/Wijmo FE + Spring/MyBatis BE) Fact 추출기.  node index.js [scan|pack|all] --config tobefacts.json
const fs = require('fs');
const path = require('path');
const args = process.argv.slice(2);
const cmd = args.find(a => !a.startsWith('--')) || 'all';
const opt = k => { const i = args.indexOf(k); return i >= 0 ? args[i + 1] : null; };
const cfgPath = opt('--config') || path.join(__dirname, 'tobefacts.json');
const cfg = JSON.parse(fs.readFileSync(cfgPath, 'utf8').replace(/^\uFEFF/, ''));
for (const k of ['feRoot', 'beRoot', 'outDir', 'asisOutDir']) if (opt('--' + k)) cfg[k] = opt('--' + k);
// typescript 는 To-Be 프런트의 node_modules 에서 빌려 쓴다 (도구 폴더에 별도 설치 불필요)
try { require.resolve('typescript'); } catch (_) {
  process.env.NODE_PATH = [path.join(cfg.feRoot, 'node_modules'), process.env.NODE_PATH || ''].filter(Boolean).join(path.delimiter);
  require('module').Module._initPaths();
  try { require.resolve('typescript'); } catch (e) { console.error('typescript 를 찾지 못했습니다: ' + path.join(cfg.feRoot, 'node_modules/typescript')); process.exit(2); }
}
const out = cfg.outDir;
fs.mkdirSync(out, { recursive: true });
const t0 = Date.now();
if (cmd === 'scan' || cmd === 'all') {
  const fe = require('./src/fe').run(cfg, out);
  console.log(`FE: 파일 ${fe.files}, 페이지 ${fe.pages}  (${((Date.now() - t0) / 1000).toFixed(1)}s)`);
  if (cfg.beRoot && fs.existsSync(cfg.beRoot)) { const be = require('./src/be').run(cfg, out); console.log(`BE: java ${be.java}, xml ${be.xml}, 엔드포인트 ${be.endpoints}, SQL ${be.sql}`); }
  else console.log('BE: beRoot 없음 — 건너뜀');
}
if (cmd === 'pack' || cmd === 'all') { const p = require('./src/pack').run(cfg, out); console.log(`Pack: 화면 ${p.screens} → ${path.join(out, 'screens')}`); }
console.log(`완료 ${((Date.now() - t0) / 1000).toFixed(1)}s → ${out}`);
