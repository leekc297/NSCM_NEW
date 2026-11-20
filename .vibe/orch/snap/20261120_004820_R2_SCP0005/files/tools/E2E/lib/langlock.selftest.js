// langlock 끊긴 언어 전환 기록(T251 2026-11-12) 변이 입증 — 실패 1건이라도 있으면 exit 1
//   실제 Doc/e2e 를 건드리지 않도록 임시 폴더를 저장소 뿌리로 삼아 모듈을 올린다.
const fs = require('fs'), path = require('path'), os = require('os');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'langlock.ts'), 'utf8');
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'langlock_st_'));
const fakeDir = path.join(root, 'tools', 'E2E', 'lib'); fs.mkdirSync(fakeDir, { recursive: true }); fs.mkdirSync(path.join(root, 'Doc', 'e2e'), { recursive: true });
const m = { exports: {} };
new Function('module', 'exports', 'require', '__dirname', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020', esModuleInterop: true } }).outputText)(m, m.exports, require, fakeDir);
const L = m.exports;
const J = path.join(root, 'Doc', 'e2e', '_run.lang.journal.json');
const DEAD = 2 ** 22 + 12345;   // 살아 있지 않은 pid
const put = o => fs.writeFileSync(J, JSON.stringify(o));
const has = () => fs.existsSync(J);
const cases = [];
const t = (name, ok) => cases.push([name, !!ok]);

t('기록 없음 → 복구 대상 없음', L.pendingLangRestore() === null);
put({ pid: DEAD, at: Date.now(), tag: 'X 시나리오', code: 'EN', name: 'ENG' });
const p1 = L.pendingLangRestore();
t('주인 죽은 기록 → 복구 대상(원래 ENG)', p1 && p1.code === 'EN' && p1.name === 'ENG');
t('원복 확인 — 지금 CHN 이면 기록 유지(false)', L.langRestored('CHN') === false && has());
t('원복 확인 — 지금 ENG 이면 기록 삭제(true)', L.langRestored('ENG') === true && !has());
L.markLangChanging('Y I2', 'EN', 'ENG');
t('전환 직전 기록 생성', has() && JSON.parse(fs.readFileSync(J, 'utf8')).pid === process.pid);
t('주인이 나(전환 중) → 복구 대상 아님', L.pendingLangRestore() === null);
put({ pid: DEAD, at: Date.now(), tag: 'X 시나리오', code: 'EN', name: 'ENG' });
L.markLangChanging('Z I2', 'CN', 'CHN');   // 끊긴 전환 뒤 다음 시험이 CHN 을 '원래' 로 읽어도
const j2 = JSON.parse(fs.readFileSync(J, 'utf8'));
t('끊긴 기록의 원래 언어(ENG)를 유지 — 오염된 CHN 으로 덮지 않음', j2.code === 'EN' && j2.name === 'ENG' && j2.pid === process.pid);
t('그 시험이 CHN 으로 "원복" 해도 기록 유지', L.langRestored('CHN') === false && has());
put({ pid: DEAD, at: Date.now(), tag: 'bad', code: '', name: '' });
t('코드 빈 기록 → 복구 대상 아님', L.pendingLangRestore() === null);
fs.unlinkSync(J);
L.markLangChanging('빈 코드', '', '');
t('원래 언어를 못 읽었으면 기록하지 않음', !has());
t('기록 없을 때 원복 확인 = true', L.langRestored('ENG') === true);

let bad = 0;
for (const [n, ok] of cases) { console.log((ok ? 'PASS ' : 'FAIL ') + n); if (!ok) bad++; }
console.log(`selftest ${cases.length - bad}/${cases.length}`);
try { fs.rmSync(root, { recursive: true, force: true }); } catch { /* 임시 폴더 */ }
process.exit(bad ? 1 : 0);
