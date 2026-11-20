// 웹뷰 HTML 안 스크립트 구문 검사 — VMO 창(orchestra.js) · 업무 작업창(jobs.js)이 만드는 HTML 에서 <script> 를 뽑아 구문만 본다(실행하지 않음)
//   확장 코드의 node --check 는 템플릿 문자열 안 브라우저 스크립트의 구문 오류를 잡지 못한다. 한글 · 영문 두 언어로 본다.
//   사용: node test/t_webview_syntax.js <VibeManager 폴더>
const Module = require('module'); const path = require('path'); const vm = require('vm');
const stub = new Proxy(function () { }, { get: (t, k) => (k === 'then' ? undefined : stub), apply: () => stub, construct: () => stub });
const orig = Module._load; Module._load = function (req, ...rest) { return req === 'vscode' ? stub : orig.call(this, req, ...rest); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
function scripts(html) { const out = []; const re = /<script(\s[^>]*)?>([\s\S]*?)<\/script>/g; let m; while ((m = re.exec(html))) if (!/\ssrc=/.test(m[1] || '') && m[2].trim()) out.push(m[2]); return out; }
function check(name, html) {
  const list = scripts(html); let bad = '';
  for (const s of list) { try { new vm.Script(s, { filename: `${name}.webview.js` }); } catch (e) { bad = `${e.message} · ${String(e.stack || '').split('\n').slice(0, 3).join(' | ')}`; break; } }
  chk(`${name}: 스크립트 ${list.length}개 구문`, list.length > 0 && !bad, bad);
  // 줄 머리의 function 선언이 같은 이름으로 2번 나오면 뒤 것이 앞 것을 말없이 덮어쓴다(2026-11-19 hm 함수 실제 사례) → 실패로 본다
  const fns = (list.join(String.fromCharCode(10)).match(/^function\s+\w+/gm) || []).map(x => x.replace(/^function\s+/, '')); const dup = [...new Set(fns.filter((x, i) => fns.indexOf(x) !== i))];
  chk(`${name}: 같은 이름 함수 선언 없음`, !dup.length, dup.join());
  return list.join('\n');
}
for (const lang of ['ko', 'en']) {
  const p = { root: 'C:\\x', vibeDir: 'C:\\x\\.vibe', extDir: dir, language: lang };
  try { const js = check(`orchestra(${lang})`, require(path.join(dir, 'orchestra')).html(p, { tab: '' }));
    if (lang === 'ko') { chk('orchestra: 오류 보고 코드 포함', js.includes("type:'vmerr'")); chk('orchestra: 자가진단 · 이력 탭 함수', /function paintSelf\(/.test(js) && /function paintHist\(/.test(js) && /function paintLedger\(/.test(js)); }
  } catch (e) { chk(`orchestra(${lang}) HTML 생성`, false, e.message); }
  try { const js = check(`jobs(${lang})`, require(path.join(dir, 'jobs')).html(p)); if (lang === 'ko') chk('jobs: 오류 보고 코드 포함', js.includes("type:'vmerr'")); } catch (e) { chk(`jobs(${lang}) HTML 생성`, false, e.message); }
}
// 탭 단추마다 같은 id 의 패널이 있는지(없으면 눌러도 화면이 바뀌지 않는다)
try { const html = require(path.join(dir, 'orchestra')).html({ root: 'C:\\x', vibeDir: 'C:\\x\\.vibe', extDir: dir, language: 'ko' }, {}); const tabs = [...html.matchAll(/class="tab" data-t="(\w+)"/g)].map(m => m[1]); const miss = tabs.filter(t => !new RegExp(`class="pane" id="${t}"`).test(html));
  chk('orchestra: 탭 순서(상황판 · 기능 · 사건 · 개선안 · 자가진단 · 이력 · 에이전트 · Log)', tabs.join() === 'board,task,inc,prop,self,hist,agent,log', tabs.join()); chk('orchestra: 탭마다 패널 있음', !miss.length, miss.join());
  const ids = [...html.matchAll(/\$\('(\w+)'\)/g)].map(m => m[1]); const noEl = [...new Set(ids)].filter(i => !new RegExp(`id="${i}"`).test(html));
  chk('orchestra: 스크립트가 찾는 id 가 HTML 에 있음', !noEl.length, noEl.join());
} catch (e) { chk('orchestra 탭 확인', false, e.message); }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
