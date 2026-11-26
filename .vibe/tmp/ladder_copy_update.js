// 개선안 20261124000457_VISION v3 확인용: 실원장 사본(임시 폴더)에서 scan → update 후 ladder.json 의 L4|useraxis|checklistTime 상태. 실원장은 쓰지 않음
const fs = require('fs'); const path = require('path'); const os = require('os');
const src = process.cwd(); const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'ladcopy-'));
const cp = rel => { const a = path.join(src, rel); const b = path.join(tmp, rel); if (!fs.existsSync(a)) return; fs.mkdirSync(path.dirname(b), { recursive: true }); if (fs.statSync(a).isDirectory()) fs.cpSync(a, b, { recursive: true }); else fs.copyFileSync(a, b); };
['.vibe/orch/ladder.json', '.vibe/orch/events.jsonl', '.vibe/orch/activations.jsonl', '.vibe/orch/selfcheck/result.json', '.vibe/orch/usercheck/state.json', '.vibe/orch/proposals', '.vibe/orch/history/stats.json', 'tools/VibeManager/user_checks.json', 'tools/Harness/harness.json'].forEach(cp);
const vm = path.join(src, 'tools/VibeManager'); const paths = () => ({ root: tmp, vibeDir: path.join(tmp, '.vibe') });
const IM0 = require(path.join(vm, 'orch-improve')); const pd = path.join(tmp, '.vibe/orch/proposals');
const IM = { list: () => fs.readdirSync(pd).filter(f => f.endsWith('.json')).sort().reverse().map(n => { try { return JSON.parse(fs.readFileSync(path.join(pd, n), 'utf8').replace(/^﻿/, '')); } catch { return null; } }).filter(Boolean), effectiveMsOf: IM0.effectiveMsOf };
IM.get = id => IM.list().find(p => p.id === id) || null;
const L = require(path.join(vm, 'orch-ladder')); L.init({ paths, improve: IM });
const K = 'L4|useraxis|checklistTime'; const b0 = L.readLadder().bundles[K];
console.log('BEFORE', JSON.stringify(b0 && { status: b0.status, statusLabel: b0.statusLabel || '', why: b0.why }));
const u = L.update(L.scan()); const b = JSON.parse(fs.readFileSync(path.join(tmp, '.vibe/orch/ladder.json'), 'utf8')).bundles[K];
console.log('AFTER ladder.json(사본)', JSON.stringify({ status: b.status, statusLabel: b.statusLabel || '', why: b.why, ev: (b.evidence || []).map(e => e.what), fresh: u.fresh.some(x => x.key === K) }, null, 1));
fs.rmSync(tmp, { recursive: true, force: true }); process.exit(0);
