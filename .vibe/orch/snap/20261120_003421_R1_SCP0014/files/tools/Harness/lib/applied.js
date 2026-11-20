// applied — 골격 적용 매니페스트(Doc/gen/<ID>/applied.json): 적용 시점의 파일 해시. 이후 파일이 바뀌었거나(Claude/사람 작업) REPAIR.md 가 있으면 touched.
const fs = require('fs'); const path = require('path'); const crypto = require('crypto');
const walk = d => fs.readdirSync(d, { withFileTypes: true }).flatMap(e => e.isDirectory() ? walk(path.join(d, e.name)) : [path.join(d, e.name)]);
const sha = f => crypto.createHash('sha1').update(fs.readFileSync(f)).digest('hex').slice(0, 16);
function writeManifest(dir, genDir) { const files = {}; for (const f of walk(dir)) { const rel = path.relative(dir, f).replace(/\\/g, '/'); files[rel] = sha(f); } fs.mkdirSync(genDir, { recursive: true }); fs.writeFileSync(path.join(genDir, 'applied.json'), JSON.stringify({ at: new Date().toISOString(), dir, files }, null, 1), 'utf8'); }
// touchReason — 덮어쓰면 안 되는 이유(null = 이 하네스가 적용한 뒤 아무도 손대지 않은 골격 → 재적용 허용)
//   2026-10-19 SCP0096 사고: 매니페스트가 없으면 "구버전 골격" 으로 보고 재적용을 허용하던 규칙이, 손으로 완성해 커밋해 둔 페이지를
//   골격으로 교체했다(1,361줄 삭제·대사표 91→20행·dynamic-columns/types 삭제). 이제 ①git 추적 파일이 있거나 ②매니페스트가 없으면 보호한다.
// gitTracked — dir 을 감싸는 모든 git 저장소(가까운 것부터 상위로)에서 dir 안의 추적 파일을 찾는다.
//   nscm-fe 는 자체 .git(공통소스 remote)이 있어 `git -C <페이지>` 만 보면 NSCM 루트 저장소가 추적하는 커밋본을 놓친다(2026-10-19 실측: 루트 9파일 추적, nscm-fe 0).
function gitTracked(dir) {
  const cp = require('child_process'); const abs = path.resolve(dir); const roots = []; let d = abs;
  for (;;) { if (fs.existsSync(path.join(d, '.git'))) roots.push(d); const up = path.dirname(d); if (up === d) break; d = up; }
  for (const root of roots) { const rel = path.relative(root, abs).replace(/\\/g, '/') || '.'; try { const r = cp.spawnSync('git', ['-C', root, 'ls-files', '--', rel], { encoding: 'utf8' }); if (r.status === 0 && r.stdout.trim()) return { root, rel, files: r.stdout.trim().split(/\r?\n/).map(f => f.replace(/\\/g, '/')) }; } catch { /* git 없음 */ } }
  return null;
}
function touchReason(dir, genDir) {
  if (genDir && fs.existsSync(path.join(genDir, 'REPAIR.md'))) return 'REPAIR.md(수선 이력)';
  const gt = gitTracked(dir); if (gt) return `git 추적 파일 ${gt.files.length}개(커밋본 — 자동 덮어쓰기 금지, 저장소 ${gt.root})`;
  const mf = genDir ? path.join(genDir, 'applied.json') : null; if (!mf || !fs.existsSync(mf)) return '적용 매니페스트(applied.json) 없음 — 이 하네스가 만든 골격이 아님';
  const m = JSON.parse(fs.readFileSync(mf, 'utf8')).files || {};
  for (const f of walk(dir)) { const rel = path.relative(dir, f).replace(/\\/g, '/'); if (!(rel in m) || m[rel] !== sha(f)) return `적용 후 변경: ${rel}`; }
  return null;
}
function isTouched(dir, genDir) { return touchReason(dir, genDir) !== null; }
module.exports = { writeManifest, isTouched, touchReason, gitTracked };
