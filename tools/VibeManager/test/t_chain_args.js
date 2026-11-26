// 체인 단계 인자 시험(2026-11-26 SCP0005 J20261125_210634 사고): 체인 단계(quick.json)가 args 를 적으면
//   workbench.js runTaskStreaming 이 작업 정의(steps.json) args 를 통째로 바꾼다.
//   작업 정의 args 의 '--' 옵션이 체인 args 에 빠지면 다른 동작으로 실행된다(--wl-round · --gate 누락 → CheckList 전체 2회, 181.6분).
//   이 시험은 quick.json 전 체인 단계에서 작업 정의가 '--' 옵션을 갖는데 체인 args 에 '--' 옵션이 하나도 없는 경우를 찾는다.
//   체인이 다른 옵션으로 바꾼 경우(S8.engineGate --check → --mark, S8.checklistRun --docs 등)는 의도한 동작 전환으로 본다.
//   사용: node test/t_chain_args.js <VibeManager 폴더>
const fs = require('fs'); const path = require('path');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const steps = JSON.parse(fs.readFileSync(path.join(dir, 'steps.json'), 'utf8'));
const quick = JSON.parse(fs.readFileSync(path.join(dir, 'quick.json'), 'utf8'));
const tasks = {};
(function walk(o) { if (Array.isArray(o)) return o.forEach(walk); if (!o || typeof o !== 'object') return; if (typeof o.id === 'string' && (o.script || o.kind)) tasks[o.id] = o; Object.values(o).forEach(walk); })(steps);
let n = 0; let bad = 0;
(function walk(o, label) {
  if (Array.isArray(o)) return o.forEach(x => walk(x, label)); if (!o || typeof o !== 'object') return;
  const lb = o.label || label;
  if (typeof o.task === 'string' && Array.isArray(o.args) && o.args.length) {
    const t = tasks[o.task];
    if (!t) { console.log(`FAIL 작업 정의 없음: ${lb} · ${o.title || ''} · ${o.task}`); bad++; }
    else {
      n++;
      const need = (t.args || []).map(String).filter(a => a.startsWith('--'));
      const have = o.args.map(String).filter(a => a.startsWith('--'));
      const miss = have.length ? [] : need;
      if (miss.length) { console.log(`FAIL 옵션 누락: ${lb} · ${o.title || ''} · ${o.task} · 작업 정의 ${JSON.stringify(t.args)} · 체인 ${JSON.stringify(o.args)} · 빠진 옵션 ${miss.join(' ')}`); bad++; }
    }
  }
  Object.values(o).forEach(v => walk(v, lb));
})(quick, '');
console.log(bad ? 'SOME FAIL' : `PASS 체인 단계 args ${n}곳 · 작업 정의 옵션을 모두 잃은 단계 0`);
process.exit(bad ? 1 : 0);
