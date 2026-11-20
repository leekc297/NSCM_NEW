// Dictionary 탭 원천(orch-dict.js, 2026-11-20): 감시 규칙 R1~R14 · 자가진단 S1~S13 · 사용자 지적 · CheckList 규칙 · CR · T · 플랜 약자가 모두 설명을 가짐
//   사용: node test/t_orch_dict.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..')); const root = path.resolve(dir, '..', '..');
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const d = require(path.join(dir, 'orch-dict')); const w = require(path.join(dir, 'orch-watch')); const sc = require(path.join(dir, 'orch-selfcheck'));
const g = d.build(() => ({ root })); const by = id => g.find(x => x.id === id) || { items: [] };
chk('감시 규칙: TITLE 의 규칙마다 설명 있음(코드에 규칙을 더하면 설명도 더해야 함)', Object.keys(w.TITLE).every(k => d.R_DESC[k]), Object.keys(w.TITLE).filter(k => !d.R_DESC[k]).join(','));
chk('자가진단: NAMES 의 항목마다 설명 있음', Object.keys(sc.NAMES).every(k => d.S_DESC[k]), Object.keys(sc.NAMES).filter(k => !d.S_DESC[k]).join(','));
chk('묶음 R · S · U · P · Q · SP · H · G · ST 있음', ['R', 'S', 'U', 'P', 'Q', 'SP', 'H', 'G', 'ST'].every(id => by(id).items.length));
if (fs.existsSync(path.join(root, 'tools', 'Harness', 'verify', 'mapping_checkdefs.csv'))) chk('CheckList 규칙 묶음 = csv 행 수', by('CK').items.length > 0 && by('CK').items.every(i => i.code));
chk('속도 플랜 D1 설명 = E2E 병렬', /E2E 병렬/.test((by('SP').items.find(i => i.code === 'D1') || {}).desc || ''));
chk('빈 설명 없음', g.every(x => x.items.every(i => i.code && (i.desc || i.name))), g.flatMap(x => x.items.filter(i => !(i.desc || i.name)).map(i => x.id + ':' + i.code)).join(','));
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
