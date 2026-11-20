'use strict';
// AS-IS 액션 대조표 생성/갱신 (사용자 지시 2026-10-23) — **문서 보강 단계: 개발된 FE·작업 흐름 무영향**
//   기본 출력 = Doc/asisfacts/screens/<AS-IS ID>/__asis-actions__.md (AS-IS 자료 영역 — Doc/gen 은 VM 생성분 판정·gen.js 재생성 삭제 대상이라 쓰지 않음)
//   이 위치의 대조표는 게이트 AC0~AC2 를 WARN 으로만 낸다(check.js). BLOCK 은 생성기가 만든 신규 화면 페이지 폴더의 대조표에만.
//   사용: node tools/Harness/actions-checklist.js <화면ID ...> | --all  [--out <파일>(단일 화면)] [--config harness.json]
//   재실행 = 같은 ID 행의 상태·구현 위치·사유·의미 보존(merge). 원천 = Doc/asisfacts/screens/<AS-IS ID>/actions.csv (AsisFacts pack)
const fs = require('fs'); const path = require('path');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const cfg = JSON.parse(fs.readFileSync(opt('--config', path.join(__dirname, 'harness.json')), 'utf8').replace(/^\uFEFF/, ''));
const AC = require('./lib/actions');
let ids = a.filter((x, i) => !x.startsWith('--') && !(i > 0 && a[i - 1].startsWith('--'))).map(x => x.toUpperCase());
if (a.includes('--all')) ids = fs.readdirSync(path.join(cfg.asisOutDir, 'screens')).filter(d => fs.existsSync(path.join(cfg.asisOutDir, 'screens', d, 'actions.csv'))).sort();
if (!ids.length) { console.error('화면ID 또는 --all 을 지정하세요'); process.exit(2); }
let fail = 0, total = 0, unknown = 0;
for (const id of ids) {
  const out = ids.length === 1 && opt('--out') ? opt('--out') : AC.docPath(cfg, id);
  const prev = fs.existsSync(out) ? fs.readFileSync(out, 'utf8') : '';
  const r = AC.render(cfg, id, prev);
  if (!r) { console.error(`${id}: actions.csv 없음 — tools/AsisFacts pack 먼저`); fail++; continue; }
  fs.mkdirSync(path.dirname(out), { recursive: true }); fs.writeFileSync(out, r.md, 'utf8');
  total += r.rows; unknown += r.unknown;
  if (ids.length <= 5) console.log(`${id}${r.AID !== id ? `(AS-IS ${r.AID})` : ''} → ${out}  ${r.rows}행 · 의미 확인 필요 ${r.unknown}${prev ? ' (기존 상태 보존)' : ''}`);
}
if (ids.length > 5) console.log(`${ids.length - fail}화면 → Doc/asisfacts/screens/<ID>/${AC.FILE}  ${total}행 · 의미 확인 필요 ${unknown}${fail ? ` · 실패 ${fail}` : ''}`);
process.exit(fail ? 1 : 0);
