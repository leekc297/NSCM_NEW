// 2026-11-24 클라우드 이관 패키지 → VS Code 탐색기 이동(workbench.js cloudReadmeOf · revealCloudReadme) 시험. 20:2x 사용자: README 를 열지 않음, 이관 목록 링크만
// vscode 모듈 대신 호출 기록용 가짜를 넣고, workbench.js 에서 두 함수 원문을 잘라 실행한다.
const fs = require('fs');
const path = require('path');
const assert = require('assert');

const src = fs.readFileSync(path.join(__dirname, '..', 'workbench.js'), 'utf8');
const s = src.indexOf('function cloudReadmeOf(');
const e = src.indexOf('// 개선안 20261120042556_INC: 실행이 중지로 끝났는지 판정');
assert(s > 0 && e > s, '함수 원문 위치 못 찾음');
const calls = [];
const vscode = {
  Uri: { file: f => ({ fsPath: f }) },
  window: {
    showTextDocument: async (u, o) => { calls.push(['open', u.fsPath, o && o.preserveFocus]); },
    showInformationMessage: async (m, ...b) => { calls.push(['info', m, b.join(',')]); return undefined; },
  },
  commands: { executeCommand: async (c, u) => { calls.push(['cmd', c, u && u.fsPath]); } },
};
const mod = new Function('fs', 'path', 'vscode', src.slice(s, e) + '\nreturn { cloudReadmeOf, revealCloudReadme };')(fs, path, vscode);

const root = path.resolve(__dirname, '..', '..', '..');
const p = { root };
const pk = fs.readdirSync(path.join(root, '_artifacts', '_deploy_packages')).filter(d => fs.existsSync(path.join(root, '_artifacts', '_deploy_packages', d, '00_README.md')));
assert(pk.length > 0, '시험용 패키지 폴더 없음');
const readme = path.join(root, '_artifacts', '_deploy_packages', pk[pk.length - 1], '00_README.md');
const dirLink = { label: '📂 패키지 폴더', file: path.dirname(readme) };
const rdLink = { label: '📄 README', file: readme };

(async () => {
  let n = 0;
  const pkgDir = path.dirname(readme); const sqls = [];
  for (const d of fs.readdirSync(pkgDir)) { const f = path.join(pkgDir, d); if (fs.statSync(f).isFile() && d !== '00_README.md') sqls.push(f); else if (fs.statSync(f).isDirectory()) for (const x of fs.readdirSync(f)) sqls.push(path.join(f, x)); }
  const fileLink = { label: '📄 이관 1.', file: sqls[0] };
  // 1) 패키지 폴더 링크 → README 열지 않음 + 탐색기 = 패키지 폴더 + 알림 단추 2개
  calls.length = 0;
  assert.strictEqual(await mod.revealCloudReadme(p, [dirLink], false), true);
  assert.strictEqual(calls.filter(c => c[0] === 'open').length, 0, 'README 를 편집기로 열지 않음');
  assert.deepStrictEqual(calls[0], ['cmd', 'revealInExplorer', pkgDir]);
  assert.strictEqual(calls[1][0], 'info'); assert.strictEqual(calls[1][2], '탐색기에서 보기,폴더 열기'); n++;
  // 2) 이관 파일 링크만 있어도 패키지 폴더로 이동(대소문자 다른 루트 포함), quiet = 알림 없음
  calls.length = 0;
  const p2 = { root: root[0] === root[0].toUpperCase() ? root[0].toLowerCase() + root.slice(1) : root[0].toUpperCase() + root.slice(1) };
  assert.strictEqual(await mod.revealCloudReadme(p2, [fileLink], true), true);
  assert.strictEqual(calls.filter(c => c[0] === 'open' || c[0] === 'info').length, 0, 'quiet + 열기 없음');
  assert.strictEqual(String(calls[0][2]).toLowerCase(), pkgDir.toLowerCase()); n++;
  // 3) _deploy_packages 밖 → 대상 아님
  calls.length = 0;
  assert.strictEqual(await mod.revealCloudReadme(p, [{ label: '📄 README', file: path.join(root, 'tools', 'VibeManager', 'README.md') }], false), false);
  assert.strictEqual(calls.length, 0); n++;
  // 4) 없는 파일 → 대상 아님
  assert.strictEqual(await mod.revealCloudReadme(p, [{ label: 'x', file: path.join(pkgDir, 'NO_FILE.sql') }], false), false); n++;
  // 5) 링크 없음
  assert.strictEqual(await mod.revealCloudReadme(p, [], false), false); n++;
  // 6) cloud_pkg.py 이관 링크 = README 링크 없음, '이관 n.' 형식
  const cp = fs.readFileSync(path.join(__dirname, '..', '..', 'CloudPkg', 'cloud_pkg.py'), 'utf8');
  assert(!/@@LINK 📄 README/.test(cp) && /@@LINK 📄 이관 \{n\}\. \{rel\}/.test(cp), 'cloud_pkg.py 이관 목록 링크'); n++;
  console.log(`t_cloud_reveal: ${n}/6 통과 (시험 패키지 ${path.relative(root, pkgDir)})`);
})().catch(err => { console.error('t_cloud_reveal 실패:', err.message); process.exit(1); });
