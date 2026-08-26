/**
 * 클라우드에서 실행 — 이 패키지가 필요로 하는 공용 파일 중 **클라우드에 없는/다른 것**만 골라낸다.
 *
 * 왜 필요한가 (2026-08-24 실사고 3연발):
 *   사내가 아무리 잘 골라도, **클라우드 트리는 공통소스와도 다르다.**
 *   - 앞선 곳: `CascadeFields`(클라우드에만) → 우리 것으로 덮으면 TS2305
 *   - 뒤처진 곳: `CELL_CONTROL_TYPE.TEXT_MODAL`(공통엔 있는데 클라우드엔 없음) → TS2339
 *   그래서 "무엇을 올릴지"는 **클라우드에서 판정**해야 한 번에 끝난다.
 *
 * 사용법 (배포 루트 = nscm-fe 에서):
 *   node <패키지>/_cloud_gap_check.mjs <패키지>/B_FE_POOL           # 진단만
 *   node <패키지>/_cloud_gap_check.mjs <패키지>/B_FE_POOL --apply   # 다른 것만 실제 복사
 *
 * B_FE_POOL = 화면이 의존하는 공용 중 **사내와 공통소스가 완전히 같은** 파일들.
 *   클라우드가 공통 최신이면 전부 SAME 이 뜨고 아무것도 복사하지 않는다.
 *   클라우드가 뒤처져 있으면 그 파일만 STALE 로 잡혀 최신화된다.
 */
import { readFileSync, writeFileSync, existsSync, mkdirSync, readdirSync, statSync } from 'node:fs';
import { createHash } from 'node:crypto';
import { join, relative, dirname, sep } from 'node:path';

const src = process.argv[2];
const apply = process.argv.includes('--apply');
if (!src) { console.error('usage: node _cloud_gap_check.mjs <B_FE_POOL 경로> [--apply]'); process.exit(2); }

const walk = d => readdirSync(d).flatMap(f => {
  const p = join(d, f);
  return statSync(p).isDirectory() ? walk(p) : [p];
});
const h = b => createHash('sha256').update(b.toString('utf8').replace(/\r\n/g, '\n')).digest('hex').slice(0, 12);

let same = 0, stale = [], missing = [];
for (const file of walk(src)) {
  const rel = relative(src, file).split(sep).join('/');
  if (rel.startsWith('_')) continue;
  const mine = readFileSync(file);
  if (!existsSync(rel)) { missing.push(rel); continue; }
  if (h(readFileSync(rel)) === h(mine)) { same++; continue; }
  stale.push(rel);
}
for (const rel of missing) console.log(`MISSING  ${rel}`);
for (const rel of stale)   console.log(`STALE    ${rel}`);
console.log(`\n동일 ${same} / 클라우드에 없음 ${missing.length} / 내용 다름 ${stale.length}`);

if (!apply) {
  if (missing.length + stale.length) console.log('\n→ 실제로 반영하려면 같은 명령에 --apply 를 붙인다.');
  else console.log('\n✅ 클라우드가 이미 최신 — POOL 에서 올릴 것이 없다.');
  process.exit(0);
}
let n = 0;
for (const rel of [...missing, ...stale]) {
  const from = join(src, rel.split('/').join(sep));
  mkdirSync(dirname(rel), { recursive: true });
  writeFileSync(rel, readFileSync(from));
  n++;
}
console.log(`\n적용 ${n}본 완료. 이어서 type-check 를 돌릴 것: pnpm exec turbo run type-check --continue`);
