// 2026-11-25 사용자 '전체 미검증을 다 해소한 후에 검증': 해소 게이트 시험(tools/Harness/verify/test_unverified_gate.py 실행)
//   사용: node test/t_unv_gate.js <VibeManager 폴더>
const cp = require('child_process'); const path = require('path');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const py = path.join(dir, '..', 'Harness', 'verify', 'test_unverified_gate.py');
if (!require('fs').existsSync(py)) { console.log('PASS 건너뜀(이 폴더 옆에 Harness 없음: 설치 폴더 실행)'); process.exit(0); }
const r = cp.spawnSync('py', [py], { encoding: 'utf8', windowsHide: true });
process.stdout.write(r.stdout || ''); process.stderr.write(r.stderr || '');
process.exit(r.status === 0 && /ALL PASS/.test(r.stdout || '') ? 0 : 1);
