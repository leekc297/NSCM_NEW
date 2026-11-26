// 2026-11-24 VM 소개 자료 규칙 시험(tools/Docs/test_vm_intro.py 를 부름). 출력은 임시 폴더
//   사용: node test/t_vm_intro.js <VibeManager 폴더>
'use strict';
const path = require('path'); const cp = require('child_process');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const py = path.join(dir, '..', 'Docs', 'test_vm_intro.py');
const r = cp.spawnSync('python', [py], { encoding: 'utf8', windowsHide: true, timeout: 120000, env: Object.assign({}, process.env, { PYTHONIOENCODING: 'utf-8' }) });
process.stdout.write(r.stdout || ''); if (r.stderr) process.stdout.write(r.stderr);
process.exit(r.status === 0 && /ALL PASS/.test(r.stdout || '') ? 0 : 1);
