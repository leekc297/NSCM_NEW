#!/usr/bin/env node
'use strict';
// report — Playwright results.json → 화면별 Doc/e2e/results/<ID>/_summary.csv·_summary.md(정본) + 공용 색인 Doc/e2e/results/_summary.csv·_summary.md (화면×종류 판정, 어노테이션 요약)
// 2026-11-06(사용자 지시): 화면 하나 실행(run-e2e.cmd <종류> <ID>)은 E2E_RESULTS=Doc/e2e/results/<ID> — results.json·html·artifacts·shots 가 화면 폴더에 쌓여
//   여러 화면을 동시에 돌려도 서로 덮어쓰지 않는다. 요약은 화면별 파일이 정본이고, 공용 색인은 잠금(results/_summary.lock) 안에서 화면별 파일을 다시 모아 원자적으로 교체한다
//   (종전: 공용 _summary.csv 를 읽고-합치고-쓰는 사이 다른 화면이 쓴 행을 잃을 수 있었고, 반쯤 쓰인 파일을 다른 도구가 읽을 수 있었다).
//   화면 결과를 읽는 쪽은 Doc/e2e/results/<ID>/_summary.csv 를 먼저, 없으면 공용 색인을 본다(tools/Harness/verify/e2e_paths.py · VibeManager).
const fs = require('fs'); const path = require('path');
const cfg = JSON.parse(fs.readFileSync(path.join(__dirname, 'e2e.config.json'), 'utf8').replace(/^﻿/, ''));
const ROOT_RES = cfg.resultsDir; const E2E_DIR = path.dirname(ROOT_RES);
const dir = process.env.E2E_RESULTS || ROOT_RES; const f = path.join(dir, 'results.json');
const ONE_ID = String(process.env.E2E_ID || '').trim().toUpperCase();
if (!fs.existsSync(f)) { console.error('results.json 없음: ' + f); process.exit(2); }
// 2026-10-21: 이번 실행에서 갱신된 결과인지 확인 — run-e2e.cmd 의 잠금 시작 시각보다 오래된 results.json 이면 Playwright 가 돌지 않은 것(예전 결과를 다시 출력하고 exit 0 하던 사고)
//   2026-11-06: 화면 하나 실행은 화면별 잠금 _run.e2e.<ID>.lock, 그 밖은 공용 _run.lock
{
  const lockF = path.join(E2E_DIR, ONE_ID ? `_run.e2e.${ONE_ID}.lock` : '_run.lock');
  try {
    if (fs.existsSync(lockF)) {
      const lk = JSON.parse(fs.readFileSync(lockF, 'utf8')); const mt = fs.statSync(f).mtimeMs;
      if (lk.startedMs && mt < lk.startedMs - 2000) { console.error(`[FAIL] results.json 이 이번 실행(${lk.started}) 에서 갱신되지 않았습니다 — Playwright 미실행. 로그: Doc/e2e/logs/${ONE_ID ? ONE_ID + '/' : ''}run_${lk.runId}_*.log`); process.exit(3); }
    }
  } catch (e) { console.error('[WARN] 결과 신선도 확인 실패: ' + e.message); }
}
const R = JSON.parse(fs.readFileSync(f, 'utf8'));
const rows = [];
const walk = (s, file) => { for (const sp of s.specs || []) for (const t of sp.tests || []) { const last = t.results[t.results.length - 1] || {}; const ann = (t.annotations || []).concat(last.annotations || []); const soft = (last.errors || []).map(e => (e.message || '').split('\n')[0].replace(/\u001b\[[0-9;]*m/g, '')).slice(0, 5); const m = /^([A-Z0-9_]+)\.(smoke|crud|authcrud|auth)\.spec\.ts$/.exec(path.basename(file || s.file || '')); rows.push({ menu_id: m ? m[1] : '', kind: m ? m[2] : '', title: sp.title + (t.projectName ? '' : ''), account: (sp.title.match(/\[([^\s\]]+)/) || [])[1] || '', status: t.status === 'expected' ? 'PASS' : t.status === 'unexpected' ? 'FAIL' : t.status === 'flaky' ? 'FLAKY' : 'SKIP', duration_ms: last.duration || 0, soft_fails: soft.length, annotations: ann.map(x => `${x.type}: ${String(x.description || '').replace(/\s+/g, ' ').slice(0, 400)}`).join(' || ').slice(0, 16000) /* 항목별 400자 — 전체 1500자 자르기는 뒤쪽 판정 원문(cond '(기준표 순서)' 등)을 지워 근거 없는 FAIL 을 남겼다(2026-10-30 SCP0100 SC1) */, errors: soft.join(' || ').slice(0, 800) }); } for (const c of s.suites || []) walk(c, file || s.file); };
for (const s of R.suites || []) walk(s, s.file);
const parse = text => { text = text.replace(/^﻿/, ''); const out = []; let row = [], f = '', q = false; for (let i = 0; i < text.length; i++) { const ch = text[i]; if (q) { if (ch === '"') { if (text[i + 1] === '"') { f += '"'; i++; } else q = false; } else f += ch; } else if (ch === '"') q = true; else if (ch === ',') { row.push(f); f = ''; } else if (ch === '\n' || ch === '\r') { if (ch === '\r' && text[i + 1] === '\n') i++; row.push(f); out.push(row); row = []; f = ''; } else f += ch; } if (f || row.length) { row.push(f); out.push(row); } return out.filter(r => r.length > 1); };
// 2026-11-06: 요약 읽기·쓰기 공용 함수 — 원자 쓰기(임시 파일 → rename, Windows 에서 다른 프로세스가 잠깐 열고 있으면 재시도) · 요약 잠금
const HEAD = ['menu_id', 'kind', 'account', 'status', 'duration_ms', 'soft_fails', 'errors', 'annotations'];
const readSummary = p => { if (!fs.existsSync(p)) return []; const t = parse(fs.readFileSync(p, 'utf8')); const h = t.shift() || []; return t.map(r => Object.fromEntries(h.map((k, i) => [k, r[i] ?? '']))).filter(o => o.menu_id).map(o => ({ menu_id: String(o.menu_id).toUpperCase(), kind: o.kind, title: '', account: o.account || '', status: o.status || '', duration_ms: Number(o.duration_ms || 0), soft_fails: Number(o.soft_fails || 0), annotations: o.annotations || '', errors: o.errors || '' })); };
const toCsv = rs => '﻿' + [HEAD.join(',')].concat(rs.map(r => HEAD.map(k => '"' + String(r[k] ?? '').replace(/"/g, '""') + '"').join(','))).join('\n') + '\n';
const sortRows = rs => rs.sort((x, y) => (x.menu_id + x.kind + x.account).localeCompare(y.menu_id + y.kind + y.account));
const sleep = ms => Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, ms);
const atomicWrite = (p, s) => { fs.mkdirSync(path.dirname(p), { recursive: true }); const t = `${p}.${process.pid}.tmp`; fs.writeFileSync(t, s, 'utf8'); for (let i = 0; ; i++) { try { fs.renameSync(t, p); return; } catch (e) { if (i >= 40 || !/^(EPERM|EBUSY|EACCES)$/.test(e.code || '')) { try { fs.unlinkSync(t); } catch { } throw e; } sleep(250); } } };
const withLock = (lf, fn) => { let fd = null; for (let i = 0; i < 480 && fd === null; i++) { try { fd = fs.openSync(lf, 'wx'); fs.writeSync(fd, JSON.stringify({ pid: process.pid, at: new Date().toISOString() })); } catch (e) { if (e.code !== 'EEXIST') throw e; try { if (Date.now() - fs.statSync(lf).mtimeMs > 120000) { fs.unlinkSync(lf); continue; } } catch { } sleep(250); } } if (fd === null) throw new Error('요약 잠금 획득 실패(120초): ' + lf); try { return fn(); } finally { try { fs.closeSync(fd); } catch { } try { fs.unlinkSync(lf); } catch { } } };
const isId = id => /^[A-Z0-9_]+$/.test(id);
// 2026-10-20: 테스트 단계 4종 — smoke · crud · auth · authcrud(권한별 CRUD)
const KINDS = ['smoke', 'crud', 'auth', 'authcrud'];
const agg = arr => arr.length ? `${arr.filter(r => r.status === 'PASS').length}/${arr.length}${arr.some(r => r.status === 'FAIL') ? ' ✗' : ''}` : '-';
const localStamp = d => { const p = n => String(n).padStart(2, '0'); return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`; }; // 2026-10-21: UTC(toISOString) → 로컬 시각
// 2026-10-23: 스모크의 '조회조건 동작'·'공통 기능' 요약(condsum/commonsum 어노테이션: "OK/판정 · FAIL n · WARN n · ERROR n · NA n")
const sumOf = (arr, type) => { const r = (arr || []).map(x => (new RegExp(`(?:^|\\|\\| )${type}: ([^|]+)`).exec(x.annotations) || [])[1]).find(Boolean); return r ? r.trim().replace(/ · NA \d+$/, '') : '-'; };
// 2026-10-26: 테스트 구간 BE 로그 DB 오류(fixtures/test.ts dberr) — 이 화면 요청 5xx 와 함께면 실패로 귀속
const dbErrOf = v => { const rs = KINDS.flatMap(x => v[x] || []).filter(r => /(^|\|\| )dberr: /.test(r.annotations)); if (!rs.length) return '-'; const syn = rs.filter(r => /\[SYN\]/.test(r.annotations)).length; return `${rs.length}건${syn ? ` (시노님·권한 ${syn})` : ''}`; };
// 요약 Markdown — 받은 행(화면 하나 또는 색인 전체)으로 만든다
const buildMd = rows => {
  const by = {}; for (const r of rows) { const k = r.menu_id || '(기타)'; by[k] = by[k] || Object.fromEntries(KINDS.map(x => [x, []])); (by[k][r.kind] || (by[k][r.kind] = [])).push(r); }
  const md = [`# E2E 결과 — ${localStamp(new Date())}`, '', `테스트 ${rows.length} · PASS ${rows.filter(r => r.status === 'PASS').length} · FAIL ${rows.filter(r => r.status === 'FAIL').length} · FLAKY ${rows.filter(r => r.status === 'FLAKY').length} · SKIP ${rows.filter(r => r.status === 'SKIP').length}`, '', '| 화면 | 스모크 | 조회조건 동작 | 공통 기능 | CRUD | 권한(계정×DIV) | 권한별 CRUD(계정) | BE DB 오류(시노님·SQL) | 실패 요약 |', '|---|---|---|---|---|---|---|---|---|'];
  for (const [k, v] of Object.entries(by).sort()) md.push(`| ${k} | ${agg(v.smoke)} | ${sumOf(v.smoke, 'condsum')} | ${sumOf(v.smoke, 'commonsum')} | ${agg(v.crud)} | ${agg(v.auth)} | ${agg(v.authcrud)} | ${dbErrOf(v)} | ${KINDS.flatMap(x => v[x]).filter(r => r.status === 'FAIL').map(r => `${r.kind}${r.account ? '[' + r.account + ']' : ''}: ${r.errors.split(' || ')[0].slice(0, 120)}`).slice(0, 4).join('<br>')} |`);
  md.push('', '상세: `_summary.csv` (어노테이션: cond=조회조건별 동작(값 변경→조회·기준표 순서·Checkbox/Radio 디자인) · common=공통 기능(Search·F5·Sort·Filter·Condition·Reset·Excel·Columns·Search Area·Manual) · columns=컬럼 대사, dynamic=동적 기간 컬럼(정적 메타 밖 binding 수·타이틀 시트 호출), calls=call-proc, buttons=노출 버튼, division=DIV별 행수, crud=CRUD 사이클 결과(mode/saved/cleaned), authcrud=계정 권한 기대(btn_auth) vs 실측) · HTML: `html/index.html` · 실패 trace: `artifacts/`');
  return md;
};
// 2026-10-20: 종류별 실행이 쌓이도록 병합 — 이번 실행에 포함된 (화면, 종류) 는 교체, 나머지 기존 행은 유지(체인이 smoke→crud→auth→authcrud 를 따로 돌려도 요약이 4종 모두 남게)
// 2026-11-06: 병합 단위 = 화면 폴더(Doc/e2e/results/<ID>/_summary.csv). 화면 폴더 요약이 아직 없으면 공용 색인의 그 화면 행을 이어받는다(전환 1회)
const ids = [...new Set(rows.map(r => r.menu_id).filter(isId))].sort();
const idDir = id => path.join(ROOT_RES, id);
let indexRows = []; const mineById = {};
withLock(path.join(ROOT_RES, '_summary.lock'), () => {
  const shared = readSummary(path.join(ROOT_RES, '_summary.csv'));
  for (const id of ids) {
    const p = path.join(idDir(id), '_summary.csv');
    const prev = fs.existsSync(p) ? readSummary(p) : shared.filter(r => r.menu_id === id);
    const fresh = new Set(rows.filter(r => r.menu_id === id).map(r => r.kind));
    const mine = sortRows(rows.filter(r => r.menu_id === id).concat(prev.filter(r => r.menu_id === id && !fresh.has(r.kind))));
    mineById[id] = mine;
    atomicWrite(p, toCsv(mine));
    atomicWrite(path.join(idDir(id), '_summary.md'), buildMd(mine).join('\n') + '\n');
  }
  // 공용 색인 — 화면 폴더 요약이 있는 화면은 그 파일, 없는 화면(전환 전 결과)은 기존 색인 행 그대로
  const folders = (() => { try { return fs.readdirSync(ROOT_RES, { withFileTypes: true }).filter(d => d.isDirectory() && isId(d.name.toUpperCase()) && fs.existsSync(path.join(ROOT_RES, d.name, '_summary.csv'))).map(d => d.name); } catch { return []; } })();
  const covered = new Set(folders.map(s => s.toUpperCase()));
  indexRows = shared.filter(r => !covered.has(r.menu_id));
  for (const d of folders) indexRows.push(...readSummary(path.join(ROOT_RES, d, '_summary.csv')));
  indexRows.push(...rows.filter(r => !isId(r.menu_id)));  // 화면 ID 를 알 수 없는 스펙(이번 실행분만 — 종전과 같음)
  sortRows(indexRows);
  atomicWrite(path.join(ROOT_RES, '_summary.csv'), toCsv(indexRows));
  atomicWrite(path.join(ROOT_RES, '_summary.md'), buildMd(indexRows).join('\n') + '\n');
});
// 호출자가 화면 폴더도 공용 폴더도 아닌 곳을 E2E_RESULTS 로 준 경우 — 그 폴더에도 이번 실행 요약을 남긴다(종전 동작)
const same = (a, b) => path.resolve(a).toLowerCase() === path.resolve(b).toLowerCase();
if (!same(dir, ROOT_RES) && !ids.some(id => same(dir, idDir(id)))) { const rs = sortRows([...rows]); atomicWrite(path.join(dir, '_summary.csv'), toCsv(rs)); atomicWrite(path.join(dir, '_summary.md'), buildMd(rs).join('\n') + '\n'); }
const shown = ids.length === 1 ? mineById[ids[0]] : indexRows; const md = buildMd(shown);
console.log(md.slice(0, 3).join('\n')); console.log(`→ ${ids.length === 1 ? path.join(idDir(ids[0]), '_summary.md') + ' · 색인 ' + path.join(ROOT_RES, '_summary.md') : path.join(ROOT_RES, '_summary.md')}`);
