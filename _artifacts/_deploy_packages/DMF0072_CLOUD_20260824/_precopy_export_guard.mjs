/**
 * 이관 전 안전장치 — B_FE 를 덮기 **전에** 실행한다.
 *
 * 무엇을 잡나: 덮어쓸 파일이 **현재 대상 파일이 내보내던 심볼을 잃어버리는** 경우.
 *   (2026-08-23 실사고: 우리 `features/master/src/components/index.ts` 가 클라우드에만 있던
 *    `CascadeFields` export 를 지워 `sales-site-project-model` 이 TS2305 로 깨졌다.)
 *
 * 사용법 (배포 루트 = nscm-fe 에서):
 *   node <경로>/precopy_export_guard.mjs <패키지>/B_FE
 *
 * 출력: LOST 한 줄이라도 있으면 **덮지 말고** 그 파일을 병합해야 한다.
 */
import { readFileSync, existsSync, readdirSync, statSync } from 'node:fs';
import { join, relative, sep } from 'node:path';

const src = process.argv[2];
if (!src) { console.error('usage: node precopy_export_guard.mjs <B_FE 경로>'); process.exit(2); }

const walk = d => readdirSync(d).flatMap(f => {
  const p = join(d, f);
  return statSync(p).isDirectory() ? walk(p) : [p];
});

/** 파일이 내보내는 이름들 (정적 추출 — 재수출 경로는 이름만 본다) */
const exportsOf = text => {
  const names = new Set();
  for (const m of text.matchAll(/export\s+(?:declare\s+)?(?:const|let|var|function|class|type|interface|enum)\s+([A-Za-z0-9_$]+)/g))
    names.add(m[1]);
  for (const m of text.matchAll(/export\s*\{([^}]*)\}/g))
    for (const raw of m[1].split(',')) {
      const n = raw.trim().split(/\s+as\s+/).pop()?.trim();
      if (n && n !== 'default') names.add(n);
    }
  for (const m of text.matchAll(/export\s+\*\s+from\s+['"]([^'"]+)['"]/g))
    names.add('*:' + m[1]);          // 재수출 대상 경로 자체를 하나의 심볼로 취급
  if (/export\s+default/.test(text)) names.add('default');
  return names;
};

let lost = 0, missing = 0, checked = 0;
for (const file of walk(src)) {
  if (!/\.(ts|tsx)$/.test(file)) continue;
  const rel = relative(src, file).split(sep).join('/');
  if (!existsSync(rel)) { missing++; console.log(`NEW    ${rel}  (대상에 없던 신규 파일 — 그대로 추가)`); continue; }
  checked++;
  const before = exportsOf(readFileSync(rel, 'utf8'));
  const after = exportsOf(readFileSync(file, 'utf8'));
  const gone = [...before].filter(n => !after.has(n));
  if (gone.length) { lost++; console.log(`LOST   ${rel}\n         사라지는 export: ${gone.join(', ')}`); }
}
console.log(`\n검사 ${checked}본 / 신규 ${missing}본 / **export 유실 ${lost}본**`);
if (lost) {
  console.log('\n⛔ LOST 가 있으면 그 파일은 덮지 말고 병합할 것. 덮으면 그 심볼을 쓰던 화면이 TS2305 로 깨진다.');
  process.exit(1);
}
console.log('✅ 유실 없음 — 덮어써도 기존 소비처가 깨지지 않는다.');
