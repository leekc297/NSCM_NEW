// .claude/hooks/auto-improve-on-stop.js(Stop hook): 개선 세션만 이어서 진행(2026-11-26 18:4x 사용자 결정 '개선 세션만으로 좁힘')
//   임시 저장소(AUTO_IMPROVE_ROOT)와 가짜 세션 기록으로 본다. 실제 .vibe 에는 쓰지 않는다
//   사용: node test/t_auto_improve_stop.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os'); const cp = require('child_process');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const hook = path.join(dir, '..', '..', '.claude', 'hooks', 'auto-improve-on-stop.js');
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
if (!fs.existsSync(hook)) { console.log('SKIP hook 파일 없음(설치 폴더에서 실행)', hook); console.log('ALL PASS'); process.exit(0); }
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'aistop-')); const pd = path.join(root, '.vibe', 'orch', 'proposals'); fs.mkdirSync(pd, { recursive: true });
const hj = path.join(root, 'tools', 'Harness', 'harness.json'); fs.mkdirSync(path.dirname(hj), { recursive: true });
const setH = orch => fs.writeFileSync(hj, JSON.stringify({ orch }));
setH({});
const now = Date.now();
fs.writeFileSync(path.join(pd, '20261126000001_SELF.json'), JSON.stringify({ id: '20261126000001_SELF', status: 'pending', title: '안 1', targets: ['tools/VibeManager/a.js'], ms: now }));
const tr = (name, lines) => { const f = path.join(root, name); fs.writeFileSync(f, lines.map(l => JSON.stringify(l)).join('\n')); return f; };
const trImprove = tr('improve.jsonl', [{ type: 'assistant', message: { content: [{ type: 'tool_use', input: { command: 'node tools/VibeManager/claim_proposal.js done 20261126000000_SELF "x"' } }] } }]);
const trNormal = tr('normal.jsonl', [{ type: 'user', message: { content: 'DMF0082 화면 수정' } }]);
const run = (tp, sid, envX) => { const r = cp.spawnSync(process.execPath, [hook], { input: JSON.stringify({ session_id: sid, transcript_path: tp }), encoding: 'utf8', env: Object.assign({}, process.env, { CLAUDE_CODE_ENTRYPOINT: 'claude-desktop', VIBE_HARNESS: '', VIBE_ORCH: '', AUTO_IMPROVE_ON_STOP: '', AUTO_IMPROVE_ROOT: root }, envX || {}) }); let j = null; try { j = r.stdout ? JSON.parse(r.stdout) : null; } catch { j = null; } return { code: r.status, j, raw: r.stdout + r.stderr }; };
let r = run(trNormal, 'n1'); chk('일반 세션 = 이어가기 없음(출력 없음)', r.code === 0 && !r.j, r.raw);
r = run(trImprove, 'i1'); chk('개선 세션 = 종료 막음, 대기 안 목록', r.code === 0 && r.j && r.j.decision === 'block' && /20261126000001_SELF/.test(r.j.reason), r.raw.slice(0, 200));
r = run(path.join(root, 'none.jsonl'), 'n2'); chk('세션 기록 없음 = 이어가기 없음', !r.j, r.raw);
setH({ autoImproveScope: 'all' }); r = run(trNormal, 'n3'); chk("orch.autoImproveScope 'all' = 일반 세션도 막음(예전 동작)", r.j && r.j.decision === 'block', r.raw.slice(0, 200));
setH({}); r = run(trImprove, 'i2', { CLAUDE_CODE_ENTRYPOINT: 'cli' }); chk('데스크톱 밖(VM 이 띄운 claude) = 이어가기 없음', !r.j, r.raw);
setH({ autoImproveOnStop: false }); r = run(trImprove, 'i3'); chk('orch.autoImproveOnStop false = 이어가기 없음', !r.j, r.raw);
try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
