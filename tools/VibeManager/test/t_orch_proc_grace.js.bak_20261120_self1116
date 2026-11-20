// 개선안 20261120095113_INC: 하위 PID 소멸 뒤 10초 유예 · 그 사이 proc.end 가 오면 사라진 실행(gone) 0건 · proc.end 없이 10초 지나면 gone 1건
//   사용: node test/t_orch_proc_grace.js <VibeManager 폴더>
const path = require('path');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const st = require(path.join(dir, 'orch-state'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const realNow = Date.now; let clock = realNow(); Date.now = () => clock;
const OWNER = process.pid; const DEAD = 999931; const label = '유예 시험';
const procN = () => st.snapshot().procs.filter(v => v.label === label).length;
// 1) proc.start → 하위 PID 없음 → sweep 1회 gone 0건 → proc.end → sweep gone 0건
st.apply({ ms: clock - 60000, type: 'proc.start', src: 'vm', pid: OWNER, wb: 1, screen: 'SCP0005', label, procId: 9001, childPid: DEAD, log: '' });
let g = st.sweep().filter(x => x.label === label);
chk('하위 PID 소멸 첫 sweep = gone 0건', g.length === 0, JSON.stringify(g));
chk('유예 중 procs 유지', procN() === 1);
clock += 44;
st.apply({ ms: clock, type: 'proc.end', src: 'vm', pid: OWNER, wb: 1, screen: 'SCP0005', label, procId: 9001, exit: 0 });
clock += 11000;
g = st.sweep().filter(x => x.label === label);
chk('proc.end 뒤 sweep = gone 0건', g.length === 0, JSON.stringify(g));
chk('proc.end 뒤 procs 0건', procN() === 0);
// 2) proc.start → 하위 PID 없음 → proc.end 없이 10초 경과 → gone 1건
st.apply({ ms: clock - 60000, type: 'proc.start', src: 'vm', pid: OWNER, wb: 1, screen: 'SCP0005', label, procId: 9002, childPid: DEAD, log: '' });
g = st.sweep().filter(x => x.label === label);
chk('두 번째 실행 첫 sweep = gone 0건', g.length === 0, JSON.stringify(g));
clock += 5000; g = st.sweep().filter(x => x.label === label);
chk('5초 경과 = gone 0건', g.length === 0, JSON.stringify(g));
clock += 5001; g = st.sweep().filter(x => x.label === label);
chk('10초 경과 · proc.end 없음 = gone 1건', g.length === 1 && g[0].what === 'proc', JSON.stringify(g));
// 3) 주인 PID 소멸 = 유예 없이 바로 gone(종전 조건 유지)
st.apply({ ms: clock, type: 'proc.start', src: 'vm', pid: DEAD + 2, wb: 1, screen: 'SCP0005', label, procId: 9003, childPid: OWNER, log: '' });
g = st.sweep().filter(x => x.label === label);
chk('주인 PID 소멸 = 첫 sweep gone 1건', g.length === 1, JSON.stringify(g));
Date.now = realNow; st.dispose();
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
