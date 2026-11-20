// 실제 사건 1건을 실제 claude 로 진단만 한다(읽기 전용 권한 · 파일 수정 없음 · 사건 파일도 만들지 않음).
//   대상 = 화면 <ID> 의 CheckList 판정 정체(R10 형태): Doc/verify/<ID>/run_verify.result.json · unverified_history.csv 를 근거로 넘긴다.
//   사용: node test/t_orch_agent_diag.js <VibeManager 폴더> <화면ID> [모델]
const path = require('path'); const fs = require('fs');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..')); const id = String(process.argv[3] || '').toUpperCase(); const root = path.resolve(dir, '..', '..');
if (!id) { console.log('화면 ID 필요'); process.exit(2); }
const p = { root, vibeDir: path.join(root, '.vibe'), claude: process.env.CLAUDE_BIN || 'claude', claudeModel: process.argv[4] || '' };
const agent = require(path.join(dir, 'orch-agent'));
agent.init({ paths: () => p, serverSvc: null, loadQuick: () => [] });
const vd = path.join(root, 'Doc', 'verify', id);
const j = JSON.parse(fs.readFileSync(path.join(vd, 'run_verify.result.json'), 'utf8')); const s = j.summary || {};
let hist = ''; try { hist = fs.readFileSync(path.join(vd, 'unverified_history.csv'), 'utf8').trim().split(/\r?\n/).slice(-8).join('\n'); } catch { }
const inc = { id: `DIAG_${id}`, at: new Date().toISOString(), rule: 'R10', ruleName: 'CheckList 판정 정체', screen: id, sig: `R10|${id}`, count: 1, status: 'open',
  title: `CheckList 판정 정체 — ${id} FAIL ${s.FAIL} · 판정필요 ${s['판정필요']} · 미검증 ${s['미검증']} (실행 ${j.started})`,
  detail: `미검증 처리 대상이 회차를 거듭해도 줄지 않음. unverified_history.csv 마지막 8줄:\n${hist}`,
  evidence: { result: `Doc/verify/${id}/run_verify.result.json`, fixlist: `Doc/verify/${id}/fixlist.csv`, triage: `Doc/verify/${id}/unverified_triage.json`, history: `Doc/verify/${id}/unverified_history.csv`, issues: (j.issues || []).slice(0, 60).map(x => `${x.id}|${x.class || ''}|${String(x.msg || '').slice(0, 80)}`) } };
agent.on(m => { if (m.kind === 'tool') console.log('  ·', m.name, m.text); });
(async () => {
  const t0 = Date.now();
  const prompt = agent.buildPrompt(inc, '이번 실행은 진단만 한다. 파일을 고치지 않는다(읽기 전용 권한). 조치가 필요하면 actions 에 "미실행" 으로 적고 status 는 need-user 또는 proposal 로 낸다.');
  const r = await agent.runClaude(prompt, { screen: id, label: `진단 R10 ${id}`, permissionMode: 'default', allowedTools: 'Read,Glob,Grep,Bash(dir *),Bash(ls *),Bash(type *),Bash(cat *),Bash(git status*),Bash(git diff*),Bash(git log*)' });
  const out = agent.lastJsonBlock(r.text);
  console.log('ok', r.ok, '| exit', r.code, '| sec', Math.round((Date.now() - t0) / 1000), '| turns', r.turns, '| costUsd', r.costUsd, '| log', r.log);
  console.log('RESULT_JSON', JSON.stringify(out, null, 2)); if (!out) console.log('TEXT_TAIL', String(r.text).slice(-1500));
  fs.writeFileSync(path.join(p.vibeDir, 'orch', `diag_${id}.json`), JSON.stringify({ at: new Date().toISOString(), incident: inc, result: out, sec: Math.round((Date.now() - t0) / 1000), turns: r.turns, costUsd: r.costUsd, log: r.log }, null, 2));
  agent.dispose(); process.exit(r.ok && out ? 0 : 1);
})();
