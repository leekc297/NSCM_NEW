// 개선안 20261124000457_VISION v3 확인용: 실원장으로 L4-2 판정(--update 면 ladder.json 갱신, AI 진단 없음)
const path = require('path'); const root = process.cwd(); const vm = path.join(root, 'tools/VibeManager');
const paths = () => ({ root, vibeDir: path.join(root, '.vibe') });
const fs = require('fs'); const IM0 = require(path.join(vm, 'orch-improve')); const pd = path.join(root, '.vibe/orch/proposals');
// orch-improve 는 orch-agent.paths() 를 써서 init 없이 목록을 못 읽음 → 같은 폴더를 직접 읽는 목록 + 공용 effectiveMsOf(acts 를 넘겨받음)
const IM = { list: () => fs.readdirSync(pd).filter(f => f.endsWith('.json')).sort().reverse().map(n => { try { return JSON.parse(fs.readFileSync(path.join(pd, n), 'utf8').replace(/^﻿/, '')); } catch { return null; } }).filter(Boolean), effectiveMsOf: IM0.effectiveMsOf };
IM.get = id => IM.list().find(p => p.id === id) || null;
const L = require(path.join(vm, 'orch-ladder')); L.init({ paths, improve: IM });
const K = 'L4|useraxis|checklistTime';
const before = L.readLadder().bundles[K]; console.log('BEFORE', JSON.stringify(before && { status: before.status, statusLabel: before.statusLabel || '', why: before.why, lastSeenAt: before.lastSeenAt }));
const cs = L.scan(); const g = cs.find(x => x.key === K);
console.log('proposals', IM.list().length);
console.log('SCAN', JSON.stringify(g && { wait: g.wait, label: g.waitLabel, title: g.title, why: g.why, ev: g.evidence.map(e => e.what) }, null, 1));
if (process.argv[2] === '--update') { const u = L.update(cs); const b = u.ladder.bundles[K]; console.log('AFTER', JSON.stringify({ status: b.status, statusLabel: b.statusLabel, waitAt: b.waitAt, why: b.why, fresh: u.fresh.some(x => x.key === K) }, null, 1)); }
process.exit(0);
