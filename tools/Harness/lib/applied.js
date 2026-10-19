// applied — 골격 적용 매니페스트(Doc/gen/<ID>/applied.json): 적용 시점의 파일 해시. 이후 파일이 바뀌었거나(Claude/사람 작업) REPAIR.md 가 있으면 touched.
const fs = require('fs'); const path = require('path'); const crypto = require('crypto');
const walk = d => fs.readdirSync(d, { withFileTypes: true }).flatMap(e => e.isDirectory() ? walk(path.join(d, e.name)) : [path.join(d, e.name)]);
const sha = f => crypto.createHash('sha1').update(fs.readFileSync(f)).digest('hex').slice(0, 16);
function writeManifest(dir, genDir) { const files = {}; for (const f of walk(dir)) { const rel = path.relative(dir, f).replace(/\\/g, '/'); files[rel] = sha(f); } fs.mkdirSync(genDir, { recursive: true }); fs.writeFileSync(path.join(genDir, 'applied.json'), JSON.stringify({ at: new Date().toISOString(), dir, files }, null, 1), 'utf8'); }
function isTouched(dir, genDir) {
  if (genDir && fs.existsSync(path.join(genDir, 'REPAIR.md'))) return true;
  const mf = genDir ? path.join(genDir, 'applied.json') : null; if (!mf || !fs.existsSync(mf)) return false; // 매니페스트 없는(구버전) 골격은 재적용 허용
  const m = JSON.parse(fs.readFileSync(mf, 'utf8')).files || {};
  for (const f of walk(dir)) { const rel = path.relative(dir, f).replace(/\\/g, '/'); if (!(rel in m) || m[rel] !== sha(f)) return true; }
  return false;
}
module.exports = { writeManifest, isTouched };
