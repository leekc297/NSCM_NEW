// orch-agent.js 실제 claude CLI 호출 1회(가벼운 모델) — 입력 형식·권한 모드·허용 도구·종료 처리가 실제 CLI 에서 동작하는지 본다.
//   감시기는 시작하지 않는다(실제 저장소의 사건을 건드리지 않음). 사용: node test/t_orch_agent_real.js <VibeManager 폴더> [모델]
const path = require('path');
const dir = process.argv[2] || path.join(__dirname, '..'); const root = path.resolve(dir, '..', '..');
const p = { root, vibeDir: path.join(root, '.vibe'), claude: process.env.CLAUDE_BIN || 'claude', claudeModel: process.argv[3] || 'haiku' };
const agent = require(path.join(dir, 'orch-agent'));
agent.init({ paths: () => p, serverSvc: null, loadQuick: () => [] });
const seen = []; agent.on(m => { seen.push(m); if (m.kind === 'tool') console.log('  tool', m.name, m.text); });
(async () => {
  const t0 = Date.now();
  const r = await agent.ask('.claude/agents/vm-orchestra.md 의 조치 등급 표에서 B 등급 대상 폴더 3개를 한 줄로만 답한다. 파일은 그 1개만 읽는다.');
  const text = seen.filter(m => m.kind === 'text').map(m => m.text).join(' ').replace(/\s+/g, ' ');
  console.log('ok', r && r.ok, '| exit', r && r.code, '| sec', Math.round((Date.now() - t0) / 1000), '| turns', r && r.turns, '| costUsd', r && r.costUsd, '| session', !!(r && r.session));
  console.log('answer:', text.slice(0, 300)); if (r && !r.ok) console.log('stderr:', r.stderr);
  const pass = !!(r && r.ok) && /tools\/Harness/.test(text) && /tools\/E2E/.test(text) && /tools\/Docs/.test(text);
  console.log(pass ? 'REAL CALL PASS' : 'REAL CALL FAIL'); agent.dispose(); process.exit(pass ? 0 : 1);
})();
