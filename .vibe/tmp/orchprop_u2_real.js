// 개선안 20261123000419_VISION 확인용(임시): 실제 .vibe/orch/events.jsonl 2001줄(chain.end)과 같은 runId 의 step.end 줄을 U2 감지기에 그대로 넣음
//   시각만 '체인 끝 = 지금 - 10분'으로 옮김(감지기가 24시간 안 기록만 봄). 사용: node .vibe/tmp/orchprop_u2_real.js [감지기 파일]
const fs = require('fs'); const path = require('path'); const os = require('os');
const repo = path.resolve(__dirname, '..', '..'); const ucFile = path.resolve(process.argv[2] || path.join(repo, 'tools', 'VibeManager', 'orch-usercheck.js'));
const lines = fs.readFileSync(path.join(repo, '.vibe', 'orch', 'events.jsonl'), 'utf8').split('\n');
const ce = JSON.parse(lines[2000]); if (ce.type !== 'chain.end') throw new Error('2001줄이 chain.end 아님: ' + ce.type);
const all = lines.filter(Boolean).map(l => { try { return JSON.parse(l); } catch { return null; } }).filter(e => e && e.runId === ce.runId && (e.type === 'step.end' || e.type === 'chain.end'));
const shift = Date.now() - 10 * 60000 - ce.ms; const EV = all.map(e => Object.assign({}, e, { ms: e.ms + shift }));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'u2real-')); const vibeDir = path.join(root, '.vibe'); const vmd = path.join(root, 'vm');
for (const d of [path.join(vibeDir, 'orch'), path.join(root, 'tools', 'Harness'), vmd]) fs.mkdirSync(d, { recursive: true });
fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { checklistTargetMin: 30 } }));
fs.writeFileSync(path.join(vmd, 'user_checks.json'), JSON.stringify({ items: [{ id: 'U2', quote: 'q', detector: 'chainTarget', params: {}, level: 'warn', status: 'active' }] }));
const uc = require(ucFile);
uc.init({ paths: () => ({ root, vibeDir }), vmDir: vmd, mods: { 'orch-watch': { list: () => [] }, 'orch-improve': { list: () => [], meta: () => null }, 'orch-state': { snapshot: () => ({ chains: [] }) }, 'orch-selfcheck': {}, 'flow-panel': { targets: () => [] } }, events: () => EV, sessionDirs: [] });
const docs = all.filter(e => e.type === 'step.end' && e.task === 'S8.checklistRun' && /문서/.test(e.name || ''));
console.log(`events.jsonl:2001 runId ${ce.runId} ms_run ${ce.ms_run} · step.end ${all.filter(e => e.type === 'step.end').length}줄 · 문서 단계 step.end ${docs.length}줄${docs[0] ? ` (no ${docs[0].no}, 시작부터 ${Math.round((docs[0].ms - (ce.ms - ce.ms_run)) / 1000)}초, stepKey '${docs[0].stepKey || ''}')` : ''}`);
for (const i of uc.check().items.filter(i => i.uid === 'U2')) console.log(`U2 ${i.level} | ${i.what} | firstDocMin ${i.firstDocMin} chainMin ${i.chainMin}`);
