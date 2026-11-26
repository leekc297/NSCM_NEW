// 2026-11-24 운영자 매뉴얼 확정 구성 규칙 시험(tools/Docs/test_ops_struct.py 를 부름). 실제 DB, PPT 생성 없음
//   사용: node test/t_ops_struct.js <VibeManager 폴더>
'use strict';
const path = require('path'); const cp = require('child_process');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const py = path.join(dir, '..', 'Docs', 'test_ops_struct.py');
const r = cp.spawnSync('python', [py], { encoding: 'utf8', windowsHide: true, timeout: 120000, env: Object.assign({}, process.env, { PYTHONIOENCODING: 'utf-8' }) });
process.stdout.write(r.stdout || ''); if (r.stderr) process.stdout.write(r.stderr);
process.exit(r.status === 0 && /ALL PASS/.test(r.stdout || '') ? 0 : 1);
