'use strict';
// Vibe_Manager 1.3 — Claude 프롬프트 패널 (Webview) + Claude Code 세션 터미널 + 빠른 실행
//   Claude Code 기능은 그대로: 사이드바 입력 → 전용 터미널에서 실행 중인 `claude`(대화형)에 그대로 전달한다.
//   (slash 명령 /clear /model /compact 등도 그대로 통과. 권한 프롬프트는 터미널에서 응답)
const vscode = require('vscode');
const fs = require('fs');
const path = require('path');

let claudeTerm = null;           // 'Claude Code (Vibe)' 터미널
let claudeStartedAt = 0;
const servers = {};              // name → terminal

function loadQuick(extDir, root) {
  const cands = [path.join(root, '.vibe', 'quick.json'), path.join(root, 'tools', 'VibeManager', 'quick.json'), path.join(extDir, 'quick.json')];
  for (const f of cands) if (fs.existsSync(f)) { try { return JSON.parse(fs.readFileSync(f, 'utf8').replace(/^﻿/, '')); } catch (e) { vscode.window.showWarningMessage(`quick.json 파싱 실패: ${f} — ${e.message}`); } }
  return { groups: [] };
}
const subst = (s, vars) => String(s == null ? '' : s).replace(/\$\{(\w+)\}/g, (m, k) => (vars[k] != null ? String(vars[k]) : m));

function ensureClaude(p, opts = {}) {
  const alive = claudeTerm && vscode.window.terminals.includes(claudeTerm);
  if (alive && !opts.fresh) { claudeTerm.show(true); return { term: claudeTerm, fresh: false }; }
  if (alive && opts.fresh) { try { claudeTerm.dispose(); } catch { } }
  const env = Object.assign({}, opts.harness ? { VIBE_HARNESS: '1', NSCM_SKIP_RULE_READ: '1' } : {});
  claudeTerm = vscode.window.createTerminal({ name: 'Claude Code (Vibe)', cwd: p.root, env });
  claudeTerm.show(true);
  const model = (p.claudeModel ? ` --model ${p.claudeModel}` : '') + ` --permission-mode ${p.permissionMode}`;
  const cont = opts.continue ? ' --continue' : '';
  claudeTerm.sendText(`${/\s/.test(p.claude) ? `& "${p.claude}"` : p.claude}${model}${cont}`);
  claudeStartedAt = Date.now();
  return { term: claudeTerm, fresh: true };
}
function sendToClaude(p, text, opts = {}) {
  if (!text || !text.trim()) return;
  const { term, fresh } = ensureClaude(p, opts);
  const wait = fresh ? p.claudeDelay : Math.max(0, p.claudeDelay - (Date.now() - claudeStartedAt));
  // 여러 줄은 한 번에 붙여넣기(터미널 bracketed paste) — 줄 단위 전송 시 첫 줄에서 바로 제출되는 문제 방지
  setTimeout(() => { term.sendText(text.replace(/\r?\n/g, ' '), true); }, wait);
}
function startServer(p, item) {
  const name = item.name || item.label; const cwd = subst(item.cwd, { root: p.root });
  if (!fs.existsSync(cwd)) { vscode.window.showErrorMessage(`폴더 없음: ${cwd}`); return; }
  const alive = servers[name] && vscode.window.terminals.includes(servers[name]);
  if (alive) { servers[name].show(true); vscode.window.showInformationMessage(`${name} 터미널이 이미 열려 있습니다(재기동은 그 터미널에서 Ctrl+C 후 ↑ Enter).`); return; }
  const t = vscode.window.createTerminal({ name, cwd }); servers[name] = t; t.show(true); t.sendText(item.cmd);
  vscode.window.setStatusBarMessage(`$(server) ${name} 기동 — ${item.hint || ''}`, 8000);
}

// ── Git 빠른 실행 (노트북에서 가능한 범위: GitHub 원격만. 사내 GitLab origin 은 클라우드에서) ──
function gitTerm(p, cwd) {
  const name = 'Git (Vibe)'; let t = vscode.window.terminals.find(x => x.name === name);
  if (!t) t = vscode.window.createTerminal({ name, cwd });
  t.show(true); t.sendText(`cd /d "${cwd}"`); return t;
}
async function gitAction(p, item) {
  const cwd = subst(item.cwd, { root: p.root }); if (!fs.existsSync(path.join(cwd, '.git'))) { vscode.window.showErrorMessage(`git 저장소 아님: ${cwd}`); return; }
  const t = gitTerm(p, cwd);
  if (item.kind === 'git-status') { t.sendText('git status -s && git log --oneline -5'); return; }
  if (item.kind === 'git-upload') {
    const msg = await vscode.window.showInputBox({ prompt: `커밋 메시지 (${item.remote}/${item.branch} 로 push) — 규칙: 핵심 작업 1~2줄, 화면 작업은 MNU_ID 명시 (예: feat(DMF0052): …)`, placeHolder: 'chore: Vibe_Manager 1.3 + DMF0052 파이프라인 산출물', ignoreFocusOut: true });
    if (!msg) return;
    const ok = await vscode.window.showWarningMessage(`${cwd}\n전체 stage(.gitignore 적용) → commit → push ${item.remote} ${item.branch}. 비밀번호/회사 자산은 .gitignore 로 제외되는지 'git status -s' 로 먼저 확인하세요.`, { modal: true }, 'push 실행', 'status 만');
    if (ok === 'status 만') { t.sendText('git status -s'); return; }
    if (ok !== 'push 실행') return;
    const safe = msg.replace(/"/g, "'");
    t.sendText(`git add -A && git commit -m "${safe}" && git push ${item.remote} ${item.branch}`);
    return;
  }
  if (item.kind === 'git-fetch') { t.sendText(`git fetch ${item.remote} && git branch -r --list "${item.remote}/*" && git log --oneline HEAD..${item.remote}/main -20`); return; }
  if (item.kind === 'git-merge') {
    const br = await vscode.window.showInputBox({ prompt: `${item.remote} 의 어느 브랜치를 현재 브랜치에 병합할까요?`, value: item.branch || 'main', ignoreFocusOut: true }); if (!br) return;
    const ok = await vscode.window.showWarningMessage(`git merge ${item.remote}/${br} — 충돌 시 터미널에서 해결(공용 패키지 foundation/shared 는 Hard Boundary: 로컬 수정분이 있으면 되돌아볼 것).`, { modal: true }, '병합');
    if (ok !== '병합') return;
    t.sendText(`git fetch ${item.remote} && git merge --no-ff ${item.remote}/${br}`);
  }
}

// NOTE: 1.6 부터 사이드바 PromptViewProvider 는 제거되었다 — 워크벤치가 첫 화면이자 유일한 입력 UI.
//   아래 모듈 export(loadQuick/startServer/ensureClaude/sendToClaude/gitAction) 는 그대로 유지하며
//   extension.js 의 CommandPalette 명령(vibeManager.startBE/startFE/claudeNew) 과 workbench.js 가 재사용한다.
//   아래 _LegacyPromptViewProvider 는 참고용 shim 으로만 export 되고 등록되지 않는다(혹시 외부 조립이 참조할 경우 대비).
class _LegacyPromptViewProvider {
  constructor(ctx, api) { this.ctx = ctx; this.api = api; this.view = null; }
  resolveWebviewView(view) {
    this.view = view; view.webview.options = { enableScripts: true };
    view.webview.html = this.html();
    view.webview.onDidReceiveMessage(m => this.onMessage(m));
  }
  refresh() { if (this.view) this.view.webview.html = this.html(); }
  async onMessage(m) {
    const p = this.api.paths(); const id = (m.id || '').trim().toUpperCase(); const vars = { root: p.root, id };
    const withCtx = (text) => {
      // 자동 컨텍스트: 화면ID 가 있으면 ctx 체크 무관 attach
      if (!id) return text;
      const bits = [`[화면 ${id}]`];
      for (const f of ['GEN_NOTES.md', 'CHECK.md', 'DOD.md', 'PIPELINE.md']) if (fs.existsSync(path.join(p.genDir, id, f))) bits.push(`Doc/gen/${id}/${f}`);
      if (fs.existsSync(path.join(p.outDir, 'screens', id))) bits.push(`Doc/asisfacts/screens/${id}/`);
      return `${bits.join(' · ')} — 참고 후: ${text}`;
    };
    const autoHarness = (userH, item) => !!userH || !!id || (item && item.needsId === true);
    try {
      switch (m.type) {
        case 'send': case 'new': case 'continue': await vscode.commands.executeCommand('vibeManager.openWorkbench'); if (m.type === 'send' && this.api.workbenchAsk) this.api.workbenchAsk(withCtx(m.text), autoHarness(m.harness, null)); break; // 1.4: 터미널 대신 워크벤치 패널에서 대화
        case 'quick': {
          const item = m.item; if (item.needsId && !id) { vscode.window.showWarningMessage('화면ID 를 먼저 입력하세요.'); return; }
          if (item.kind === 'terminal' || item.kind === 'multi' || item.kind === 'task' || item.kind === 'claude' || /^git-/.test(item.kind) || item.kind === 'command') { await vscode.commands.executeCommand('vibeManager.openWorkbench'); if (this.api.workbenchQuick) await this.api.workbenchQuick(item, id, autoHarness(m.harness, item)); break; }
          if (item.kind === 'terminal') startServer(p, item);
          else if (item.kind === 'multi') { const all = loadQuick(p.extDir, p.root).groups.flatMap(g => g.items); for (const l of item.items) { const it = all.find(x => x.label === l); if (it) startServer(p, it); } }
          else if (item.kind === 'browser') vscode.env.openExternal(vscode.Uri.parse(item.url));
          else if (item.kind === 'task') await this.api.runTaskById(item.task, { id, ids: id, dir: id ? this.api.pageDirOf(id) : '' });
          else if (item.kind === 'open') { const f = subst(item.path, vars); if (fs.existsSync(f)) vscode.commands.executeCommand('vscode.open', vscode.Uri.file(f)); else vscode.window.showWarningMessage(`파일 없음: ${f}`); }
          else if (item.kind === 'claude') sendToClaude(p, subst(item.prompt, vars), { harness: !!m.harness });
          else if (/^git-/.test(item.kind)) await gitAction(p, item);
          else if (item.kind === 'command') await vscode.commands.executeCommand(item.command);
          this.api.record('quick', `${item.label} ${id}`);
          break;
        }
        case 'editQuick': { const f = path.join(p.root, 'tools', 'VibeManager', 'quick.json'); vscode.commands.executeCommand('vscode.open', vscode.Uri.file(f)); break; }
        case 'saveState': this.ctx.workspaceState.update('vibe.prompt.state', { id: m.id, ctx: m.ctx, harness: m.harness }); break;
        case 'newScreen': {
          const cur = id || this.ctx.workspaceState.get('vibeManager.lastId', '');
          const nid = await vscode.window.showInputBox({ prompt: '새 화면ID (예: DMF0052, SCP0096) — 비우면 현재 화면ID 를 해제합니다', value: cur, placeHolder: 'DMF0052', ignoreFocusOut: true, validateInput: v => v && !/^[A-Z]{2,4}[0-9]{2,6}$/i.test(v.trim()) ? '형식: 2~4자 영문 + 2~6자리 숫자 (예: DMF0052)' : null });
          if (nid === undefined) break;
          const NID = (nid || '').trim().toUpperCase();
          this.ctx.workspaceState.update('vibe.prompt.state', { id: NID, ctx: m.ctx, harness: m.harness });
          if (NID) this.ctx.workspaceState.update('vibeManager.lastId', NID);
          if (this.view) this.view.webview.postMessage({ type: 'setId', id: NID });
          try { await vscode.commands.executeCommand('vibeManager.refresh'); } catch (_) { }
          vscode.window.setStatusBarMessage(NID ? `Vibe_Manager: 화면 ${NID} 로 전환` : 'Vibe_Manager: 화면ID 해제', 4000);
          break;
        }
      }
    } catch (e) { vscode.window.showErrorMessage(`프롬프트 패널: ${e.message}`); }
  }
  html() {
    const p = this.api.paths(); const q = loadQuick(p.extDir, p.root); const st = this.ctx.workspaceState.get('vibe.prompt.state') || { id: 'DMF0052', ctx: true, harness: false };
    const esc = s => String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/"/g, '&quot;');
    const groups = (q.groups || []).map(g => `<div class="grp"><div class="gt">${esc(g.title)}</div><div class="btns">${(g.items || []).map((it, i) => `<button class="qb${it.needsId ? ' nid' : ''}" data-g="${esc(g.title)}" data-i="${i}" title="${esc(it.hint || it.prompt || it.cmd || it.task || it.path || '')}">${esc(it.label)}</button>`).join('')}</div></div>`).join('');
    const qjson = JSON.stringify(q).replace(/</g, '\\u003c');
    return `<!doctype html><html><head><meta charset="utf-8"><style>
body{font:12px var(--vscode-font-family);color:var(--vscode-foreground);padding:6px 8px;margin:0}
textarea{width:100%;box-sizing:border-box;min-height:84px;resize:vertical;background:var(--vscode-input-background);color:var(--vscode-input-foreground);border:1px solid var(--vscode-input-border,transparent);padding:6px;font:12px var(--vscode-editor-font-family)}
input[type=text]{width:90px;background:var(--vscode-input-background);color:var(--vscode-input-foreground);border:1px solid var(--vscode-input-border,transparent);padding:3px 5px}
button{background:var(--vscode-button-background);color:var(--vscode-button-foreground);border:0;padding:4px 8px;margin:2px 2px 2px 0;cursor:pointer;border-radius:2px}
button.sec{background:var(--vscode-button-secondaryBackground);color:var(--vscode-button-secondaryForeground)}
.row{display:flex;align-items:center;gap:6px;flex-wrap:wrap;margin:4px 0}
.grp{margin-top:8px}.gt{opacity:.75;font-weight:600;margin-bottom:2px}.btns{display:flex;flex-wrap:wrap}
.qb{background:var(--vscode-button-secondaryBackground);color:var(--vscode-button-secondaryForeground);font-size:11px;padding:3px 7px}
.qb.nid::after{content:' ·ID';opacity:.5}
label{user-select:none}.hint{opacity:.6;font-size:11px;margin-top:4px}
</style></head><body>
<div class="row"><b>Vibe_Manager</b><span class="hint">입력은 워크벤치(에디터) 패널로 전달됩니다 — 터미널 없음</span></div>
<textarea id="t" placeholder="프롬프트 입력 — Ctrl+Enter 전송"></textarea>
<div class="row"><button id="send">전송 (Ctrl+Enter)</button><button class="sec" id="new">워크벤치 열기</button><button class="sec" id="newScr" title="화면ID 를 새로 입력합니다. 이전 화면 컨텍스트가 자동 prefix 로 섞이지 않도록 리셋합니다.">새 화면</button><button class="sec" id="cont" style="display:none"></button></div>
<div class="row">화면ID <input id="id" type="text" value="${esc(st.id || '')}" placeholder="DMF0052"><label title="화면ID 가 있으면 자동으로 컨텍스트 prefix 가 붙습니다. 체크를 꺼도 ID 가 있으면 자동 적용 — 체크는 ID 없이 강제할 때."><input id="ctx" type="checkbox" ${st.ctx ? 'checked' : ''}> 컨텍스트(자동)</label><label title="신규 UI 생성·GAP 분석/보완 작업은 자동으로 하네스 모드가 됩니다. 체크 안 해도 자동 — 체크는 다른 Claude 지시에도 강제할 때."><input id="harness" type="checkbox" ${st.harness ? 'checked' : ''}> 하네스(자동)</label></div>
${groups}
<div class="row"><button class="sec" id="editq">메뉴 편집 (quick.json)</button></div>
<script>
const vscode=acquireVsCodeApi();const Q=${qjson};
const $=id=>document.getElementById(id);const state=()=>({id:$('id').value,ctx:$('ctx').checked,harness:$('harness').checked});
const save=()=>vscode.postMessage(Object.assign({type:'saveState'},state()));
['id','ctx','harness'].forEach(k=>$(k).addEventListener('change',save));
function send(){const text=$('t').value;if(!text.trim())return;vscode.postMessage(Object.assign({type:'send',text},state()));$('t').value='';}
$('send').onclick=send;$('t').addEventListener('keydown',e=>{if(e.ctrlKey&&e.key==='Enter'){e.preventDefault();send();}});
$('new').onclick=()=>vscode.postMessage(Object.assign({type:'new'},state()));
$('newScr').onclick=()=>vscode.postMessage(Object.assign({type:'newScreen'},state()));
$('cont').onclick=()=>vscode.postMessage(Object.assign({type:'continue'},state()));
window.addEventListener('message',e=>{const m=e.data;if(m&&m.type==='setId'){$('id').value=m.id||'';save();}});
$('editq').onclick=()=>vscode.postMessage({type:'editQuick'});
document.querySelectorAll('.qb').forEach(b=>b.onclick=()=>{const g=Q.groups.find(x=>x.title===b.dataset.g);const item=g.items[Number(b.dataset.i)];vscode.postMessage(Object.assign({type:'quick',item},state()));});
</script></body></html>`;
  }
}
module.exports = { sendToClaude, ensureClaude, startServer, loadQuick, gitAction, _LegacyPromptViewProvider };
