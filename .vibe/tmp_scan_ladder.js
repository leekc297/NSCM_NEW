// 임시: orch-ladder scan 의 L3 edits 묶음 출력(개선안 20261122000646_SELF_2 검증용)
const path = require('path'); const root = 'C:/Projects/NSCM';
const L = require(path.join(root, 'tools/VibeManager/orch-ladder'));
const H = require(path.join(root, 'tools/VibeManager/orch-history'));
const paths = () => ({ root, vibeDir: path.join(root, '.vibe'), extDir: path.join(root, 'tools/VibeManager') });
H.init({ paths }); L.init({ paths, history: H });
const out = L.scan();
for (const b of out.filter(x => x.kind === 'edits')) console.log(b.key, '|', b.title, '|', b.why);
console.log('edits 묶음', out.filter(x => x.kind === 'edits').length);
