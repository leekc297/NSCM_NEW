// 사건 처리 담당 기록(개선안 20261126183041_SELF): orch-improve.js linkIncidents 가 개선안이 가리키는 열린 사건에 handler { by, ref, at } 와 progressAt 을 적음
//   임시 저장소 사건 파일로 본다. 실제 .vibe 에는 쓰지 않는다
//   사용: node test/t_incident_handler.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'inchd-')); const vibeDir = path.join(root, '.vibe'); const incDir = path.join(vibeDir, 'orch', 'incidents');
fs.mkdirSync(incDir, { recursive: true }); fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true });
fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { agentEnabled: false } }));
const now = Date.now();
const inc = (id, x) => fs.writeFileSync(path.join(incDir, `${id}.json`), JSON.stringify(Object.assign({ id, rule: 'R12', status: 'open', ms: now - 277 * 60000, title: id, actions: [] }, x)));
inc('20261126_130515_R12_ALL', { sig: 'R12|S13|U21|count|20261125005937_SELF|1795665875000' });
inc('20261126_140000_R12_ALL', { sig: 'R12|S13|U210|count|x|1' });
inc('20261126_150000_R12_ALL', { sig: 'R12|S13|U21|count|y|2', status: 'resolved' });
inc('20261126_160000_R13_SCP0005', { sig: 'R13|SCP0005', rule: 'R13' });
const watch = require(path.join(dir, 'orch-watch')); watch.init({ root, vibeDir }, { noReloadSweep: true });
const imp = require(path.join(dir, 'orch-improve'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const rd = id => JSON.parse(fs.readFileSync(path.join(incDir, `${id}.json`), 'utf8'));
const got = imp.linkIncidents({ id: '20261126163554_SELF', source: 'self', evidence: 'orch-improve.js:366 · 진단 사다리 묶음 L3|usercheck|U21', sig: 's', selfKey: '' });
chk('U21 근거 개선안 = 열린 U21 사건 1건에만 기록', JSON.stringify(got) === JSON.stringify(['20261126_130515_R12_ALL']), JSON.stringify(got));
const a = rd('20261126_130515_R12_ALL');
chk('handler by selfdiag, ref 개선안 id, progressAt 있음', a.handler && a.handler.by === 'selfdiag' && a.handler.ref === '20261126163554_SELF' && !!a.progressAt && a.actions.length === 0, JSON.stringify(a.handler));
chk('U210 사건, 닫힌 사건 = 기록 안 함', !rd('20261126_140000_R12_ALL').handler && !rd('20261126_150000_R12_ALL').handler);
const got2 = imp.linkIncidents({ id: 'P2', source: 'vision', incident: '20261126_160000_R13_SCP0005', evidence: 'x', sig: '', selfKey: '' });
chk('incident 필드 = 그 사건에 기록(by vision)', got2.join() === '20261126_160000_R13_SCP0005' && rd('20261126_160000_R13_SCP0005').handler.by === 'vision');
chk('가리키는 사건 없음 = 0건', imp.linkIncidents({ id: 'P3', source: 'self', evidence: '근거 없음', sig: '', selfKey: '' }).length === 0);
try { watch.dispose(); } catch { }
try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
