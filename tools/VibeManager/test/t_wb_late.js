// 작업창 체인 보드 — 단계 카드 밖으로 나가던 행(2026-11-20 사용자: '5번 Group 아래의 작업목록' · '유사한 케이스도 작업 단계 카드 안의 접히는 묶음')
//   AI Agent 단계가 보고를 한 번 끝낸 뒤 이어서 한 작업(도구 · 결과 · 문장 · 메타), 스크립트 단계 중에 온 AI Agent 실행 · HTML 보기가
//   보드 아래(#chat 바로 아래)가 아니라 단계 카드(details.step) 안에 들어가는지 jsdom 으로 실제 웹뷰 스크립트를 돌려 본다.
//   사용: node test/t_wb_late.js <VibeManager 폴더>   (jsdom = nscm-fe/node_modules · 없으면 SKIP)
const Module = require('module'); const path = require('path'); const fs = require('fs');
const stub = new Proxy(function () { }, { get: (t, k) => (k === 'then' ? undefined : stub), apply: () => stub, construct: () => stub });
const orig = Module._load; Module._load = function (req, ...rest) { return req === 'vscode' ? stub : orig.call(this, req, ...rest); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const jd = path.resolve(dir, '..', '..', 'nscm-fe', 'node_modules', 'jsdom');
if (!fs.existsSync(jd)) { console.log('SKIP jsdom 없음(nscm-fe/node_modules/jsdom)'); console.log('ALL PASS'); process.exit(0); }
const { JSDOM } = require(jd);
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const p = { root: 'C:\\x', vibeDir: 'C:\\x\\.vibe', extDir: dir, language: 'ko', modelList: [], claudeModel: '' };
const html = require(path.join(dir, 'workbench'))._html({ claudeSession: '' }, p, { model: '', permissionMode: 'bypassPermissions' });
const dom = new JSDOM(html, { runScripts: 'dangerously', pretendToBeVisual: true, beforeParse(w) { w.acquireVsCodeApi = () => ({ postMessage() { }, getState() { return {}; }, setState() { } }); w.ResizeObserver = class { observe() { } }; } });
const w = dom.window; const send = m => w.dispatchEvent(new w.MessageEvent('message', { data: m }));
const chat = w.document.getElementById('chat');
const rootRows = () => [...chat.children].filter(e => /\bm\b/.test(e.className) && !/\brun\b/.test(e.className));
setTimeout(() => {
  try {
    send({ type: 'fb', state: 'start', id: 'F1', title: '🔎 CheckList', screen: 'TST0001', steps: [{ no: 1, name: '1. 측정', kind: 'task' }, { no: 3, name: '3. 검증 보완', kind: 'claude' }, { no: 5, name: '5. 부분 재측정', kind: 'task' }] });
    send({ type: 'fb', state: 'step', id: 'F1', no: 1, status: 'OK', sec: 3 });
    send({ type: 'fb', state: 'step', id: 'F1', no: 3, status: 'RUN' });
    send({ type: 'chat', role: 'user', text: '미검증 해소' });
    send({ type: 'chat', role: 'tool', text: 'Read x', brief: '읽기 x' });
    send({ type: 'run', state: 'done', text: '보고', ok: true });
    // 보고를 끝낸 뒤 이어진 작업(3단계 진행 중)
    send({ type: 'chat', role: 'tool', text: 'Bash fix', brief: '실행 고침' });
    send({ type: 'chat', role: 'result', text: 'OK' });
    send({ type: 'fb', state: 'step', id: 'F1', no: 3, status: 'OK', sec: 60 });
    send({ type: 'fb', state: 'step', id: 'F1', no: 5, status: 'RUN' });
    // 5단계(스크립트) 진행 중에 온 AI Agent 의 늦은 행 · 메타 · 새 실행 · HTML 보기
    send({ type: 'chat', role: 'tool', text: 'Edit golden.py', brief: '수정 golden.py' });
    send({ type: 'chat', role: 'assistant', text: 'Redoing the edits' });
    send({ type: 'chat', role: 'result', text: 'restored' });
    send({ type: 'chat', role: 'meta', text: '메타 줄' });
    send({ type: 'html', label: '보고서', html: '<p>x</p>', file: '' });
    const steps = [...chat.querySelectorAll('details.step')];
    const s3 = steps[1], s5 = steps[2];
    chk('보드 아래(#chat 바로 아래) 행 없음', rootRows().length === 0, rootRows().map(e => e.className + ':' + e.textContent.slice(0, 30)).join(' | '));
    const late3 = s3 && s3.querySelector('details.late');
    chk('AI Agent 단계(3) 카드 안 접는 묶음에 이어진 작업', !!late3 && /이어진 작업/.test(late3.querySelector('summary').textContent) && /실행 고침/.test(late3.textContent) && /수정 golden\.py/.test(late3.textContent) && /Redoing the edits/.test(late3.textContent), late3 ? late3.querySelector('summary').textContent : '없음');
    chk('묶음은 접힌 상태로 시작(details 닫힘)', late3 && !late3.open);
    chk('메타·HTML 보기도 단계 카드 안', !!(s3 && /메타 줄/.test(s3.textContent)) && !!(s3 || s5).querySelector('iframe'));
    // 체인이 끝난 뒤에는 종전대로(보드 아래)
    send({ type: 'fb', state: 'end', id: 'F1', ok: true, summary: '끝', sec: 100 });
    send({ type: 'chat', role: 'tool', text: 'after', brief: '체인 뒤 작업' });
    chk('체인 끝난 뒤 행 = 종전대로 대화 영역', rootRows().some(e => /체인 뒤 작업/.test(e.textContent)));
  } catch (e) { chk('실행', false, e.stack); }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
}, 300);
