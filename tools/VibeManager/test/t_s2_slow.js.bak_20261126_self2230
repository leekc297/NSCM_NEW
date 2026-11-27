// S2 오래 걸린 시험 기록 시험(2026-11-26 20:34 게이트 4021초 원인 미확인 보완): info.slow 5개, 120초 넘은 시험 주의
//   사용: node test/t_s2_slow.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const src = fs.readFileSync(path.join(dir, 'orch-selfcheck.js'), 'utf8');
const i = src.indexOf('async function s2()'); const body = src.slice(i, src.indexOf('\n}', i));
chk('S2 결과 info 에 slow 를 남김', /skipped: j\.skipped, slow \}/.test(body));
chk('S2 가 120초 넘은 시험을 주의로 남김', body.includes('x.sec > 120') && body.includes('S2|slow|'));
chk('slow 는 시간 큰 순 5개', body.includes('.sort((a, b) => b.ms - a.ms).slice(0, 5)'));
const ra = fs.readFileSync(path.join(dir, 'test', 'run_all.js'), 'utf8');
chk('run_all 이 파일별 ms 를 남김', /ms: Date\.now\(\) - t0/.test(ra));
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
