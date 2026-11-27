// 2026-11-24 사용자 지시 'VM 관련 Claude Code 작업 이력도 VMO 사용자 수정사항으로 관리' 시험 — 가짜 세션 기록, Claude 호출 없음
//   ① 프롬프트 뒤 Claude Code 가 고친 파일(Edit file_path, 패치 스크립트 rep('x.js'), 셸 cp 대상)을 그 프롬프트 edits 로 붙임
//   ② 패치 스크립트 글 안 문자열 값으로만 나온 경로(시험 기대값의 a.js)와 test/ 파일은 뺌
//   ③ 작업 중 보낸 프롬프트(queued_command 배열)는 글 부분을 읽음 · 작업 알림(<task-notification>)은 프롬프트로 보지 않음
//   ④ 같은 규칙이 다시 오면 fixedIn 에 Claude Code 수정 이력을 쌓음
//   사용: node test/t_orch_ccwork.js <VibeManager 폴더>
'use strict';
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'ccwork-')); const vibeDir = path.join(root, '.vibe'); const sd = path.join(root, 'sessions'); fs.mkdirSync(sd, { recursive: true });
fs.mkdirSync(path.join(root, 'tools', 'VibeManager'), { recursive: true });
fs.writeFileSync(path.join(root, 'tools', 'VibeManager', 'user_rules.json'), JSON.stringify({ items: [], categories: [{ key: 'ui-look', name: '화면 모양', scope: 'VM 웹뷰' }] }));
const p = { root, vibeDir, extDir: dir };
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const t0 = Date.parse('2026-01-02T09:00:00+09:00'); /* 지금보다 앞 시각(파일 수정 시각 조건) */ const at = k => new Date(t0 + k * 60000).toISOString();
const L = [
  { type: 'user', entrypoint: 'claude-vscode', timestamp: at(0), message: { role: 'user', content: 'VMW 날짜 칸 배경이 흰색이라 튑니다. 고쳐주세요.' } },
  { type: 'assistant', message: { content: [{ type: 'tool_use', id: 'a1', name: 'Edit', input: { file_path: 'c:\\Projects\\X\\tools\\VibeManager\\jobs.js', old_string: 'a', new_string: 'b' } }] } },
  { type: 'assistant', message: { content: [{ type: 'tool_use', id: 'a2', name: 'Write', input: { file_path: 'C:\\Temp\\scratchpad\\patch.py', content: "rep('workbench.js', [...])\nchk('x', E({ targets: ['tools/VibeManager/a.js'] }))\np='test/t_x.js'\n" } }] } },
  { type: 'assistant', message: { content: [{ type: 'tool_use', id: 'a3', name: 'Bash', input: { command: 'cp orchestra.js ~/.vscode/extensions/vm/orchestra.js && node --check orchestra.js' } }] } },
  { type: 'assistant', message: { content: [{ type: 'tool_use', id: 'a4', name: 'Bash', input: { command: 'grep -n jobs.js history.js' } }] } },
  { type: 'user', entrypoint: 'claude-vscode', timestamp: at(5), message: { role: 'user', content: '<task-notification> <task-id>x</task-id> 완료' } },
  { type: 'attachment', timestamp: at(6), attachment: { type: 'queued_command', origin: { kind: 'human' }, timestamp: at(6), prompt: [{ type: 'text', text: '작업 중에 보낸 지시: 입력칸도 테마 색으로' }] } },
  { type: 'assistant', message: { content: [{ type: 'tool_use', id: 'a5', name: 'Edit', input: { file_path: 'tools/VibeManager/orchestra.js', old_string: 'c', new_string: 'd' } }] } },
];
fs.writeFileSync(path.join(sd, 's1.jsonl'), L.map(x => JSON.stringify(x)).join('\n') + '\n');
const uc = require(path.join(dir, 'orch-usercheck')); uc.init({ paths: () => p, sessionDirs: [sd] });
const ps = uc.pendingPrompts(t0 - 60000);
chk('③ 프롬프트 2건(작업 알림 제외)', ps.length === 2, JSON.stringify(ps.map(x => x.text.slice(0, 20))));
const a = ps[0] || { edits: [] }; const b = ps[1] || { edits: [], text: '' };
chk('① Edit 대상 jobs.js = 저장소 기준 경로', a.edits.includes('tools/VibeManager/jobs.js'), JSON.stringify(a.edits));
chk('① 패치 스크립트 rep 대상 workbench.js', a.edits.includes('workbench.js'), JSON.stringify(a.edits));
chk('① cp 대상 orchestra.js(설치 폴더 경로 끝 파일)', a.edits.includes('orchestra.js'), JSON.stringify(a.edits));
chk('② 글 안 문자열 값 a.js, test/ 파일, 읽기 명령(grep) 파일은 뺌', !a.edits.some(f => /(^|\/)a\.js$|t_x\.js|history\.js/.test(f)), JSON.stringify(a.edits));
chk('③ 작업 중 보낸 프롬프트 배열 = 글 읽음', /작업 중에 보낸 지시/.test(b.text) && !/object Object/.test(b.text), b.text);
chk('① 작업 중 프롬프트 뒤 편집은 그 프롬프트에', b.edits.includes('tools/VibeManager/orchestra.js') && !a.edits.includes('tools/VibeManager/orchestra.js'), JSON.stringify(b.edits));
const ur = require(path.join(dir, 'orch-userrule')); ur.init({ paths: () => p, vmDir: path.join(root, 'tools', 'VibeManager') });
const r1 = ur.addRule({ at: '2026-11-24 09:00', quote: 'q1', rule: '입력칸 배경은 테마 색', category: 'ui-look', fixedIn: 'Claude Code 2026-11-24 09:00 tools/VibeManager/jobs.js' });
const r2 = ur.addRule({ at: '2026-11-24 09:06', quote: 'q2', rule: '입력칸 배경은 테마 색', category: 'ui-look', fixedIn: 'Claude Code 2026-11-24 09:06 tools/VibeManager/orchestra.js' });
const it = (ur.ledger().items || []).find(x => x.id === r1.id) || {};
chk('④ 같은 규칙 = 1건, fixedIn 에 두 수정 이력', r2.dup === true && /jobs\.js/.test(it.fixedIn) && /orchestra\.js/.test(it.fixedIn), it.fixedIn);
try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
