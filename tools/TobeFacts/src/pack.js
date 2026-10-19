'use strict';
// 화면(MENU_ID)별 Fact Pack — To-Be 쪽. As-is Pack(Doc/asisfacts/screens/<ID>) 과 같은 꼴로 폴더를 만든다.
const fs = require('fs');
const path = require('path');
const { CsvOut, readCsv } = require('./util');

const TABLES = ['files', 'endpoints', 'events', 'controls', 'grid_columns', 'messages', 'asis_refs', 'commented_code', 'asis_mapping', 'constants'];

function run(cfg, out) {
  const data = {}; for (const t of TABLES) data[t] = readCsv(path.join(out, t + '.csv'));
  const dts = readCsv(path.join(out, 'procedures_dts.csv'));
  const idx = readCsv(path.join(out, 'screens', '_index.csv'));
  const asisIdx = cfg.asisOutDir ? readCsv(path.join(cfg.asisOutDir, 'screens', '_index.csv')) : [];
  const asisIds = new Set(asisIdx.map(r => r.screen_id));
  const w = new CsvOut(path.join(out, 'screens', '_index.csv'), Object.keys(idx[0] || { page_key: 1 }).concat(['screen_dir', 'asis_present', 'dts_sheets']));
  let n = 0;
  for (const r of idx) {
    const id = r.menu_id || r.page_key.replace(/[^A-Za-z0-9_-]+/g, '_');
    const dir = path.join(out, 'screens', id); fs.mkdirSync(dir, { recursive: true });
    const pick = rows => rows.filter(x => x.page_key === r.page_key);
    for (const t of TABLES) {
      const rows = pick(data[t]); if (!rows.length) continue;
      const cw = new CsvOut(path.join(dir, t + '.csv'), Object.keys(rows[0])); rows.forEach(x => cw.row(x)); cw.close();
    }
    const myDts = dts.filter(x => x.menu_id === r.menu_id && r.menu_id);
    if (myDts.length) { const cw = new CsvOut(path.join(dir, 'procedures_dts.csv'), Object.keys(myDts[0])); myDts.forEach(x => cw.row(x)); cw.close(); }
    fs.writeFileSync(path.join(dir, `${id}_summary.md`), summary(id, r, pick, data, myDts, asisIds.has(r.menu_id)), 'utf8');
    w.row(Object.assign({}, r, { screen_dir: `screens/${id}`, asis_present: asisIds.has(r.menu_id) ? 'Y' : (r.menu_id ? 'N' : ''), dts_sheets: myDts.map(x => x.sheet).join(' ') }));
    n++;
  }
  w.close();
  return { screens: n };
}

function md(rows, cols) {
  if (!rows.length) return '(없음)\n';
  const esc = s => String(s ?? '').replace(/\|/g, '\\|').replace(/\r?\n/g, ' ');
  return `| ${cols.join(' | ')} |\n|${cols.map(() => '---').join('|')}|\n` + rows.map(r => `| ${cols.map(c => esc(r[c])).join(' | ')} |`).join('\n') + '\n';
}
function summary(id, r, pick, data, dts, asis) {
  const ep = pick(data.endpoints), live = ep.filter(x => x.commented !== '1');
  const groups = {}; for (const e of live) { const k = e.url || `(${e.kind})`; (groups[k] = groups[k] || []).push(e); }
  const epRows = Object.entries(groups).map(([url, xs]) => ({ url, kind: [...new Set(xs.map(x => x.kind))].join(','), calls: xs.length, resolved: xs.every(x => x.resolved === 'Y') ? 'Y' : 'N', where: [...new Set(xs.map(x => `${path.basename(x.file)}:${x.line}`))].slice(0, 6).join(' ') }));
  const ev = pick(data.events), ctl = pick(data.controls), gc = pick(data.grid_columns), msg = pick(data.messages), refs = pick(data.asis_refs), cc = pick(data.commented_code), map = pick(data.asis_mapping), files = pick(data.files);
  const ctlAgg = {}; for (const c of ctl) ctlAgg[c.component] = (ctlAgg[c.component] || 0) + 1;
  const refIds = {}; for (const x of refs) for (const s of x.screen_ids.split(' ').filter(Boolean)) refIds[s] = (refIds[s] || 0) + 1;
  const refSps = {}; for (const x of refs) for (const s of x.sp_names.split(' ').filter(Boolean)) refSps[s] = (refSps[s] || 0) + 1;
  const mapStat = {}; for (const m of map) mapStat[m.status] = (mapStat[m.status] || 0) + 1;
  return `# ${id} — To-Be Fact Pack 요약

- page_key: \`${r.page_key}\` · feature: ${r.feature} · As-is Fact Pack ${asis ? '있음' : '없음(화면ID 미대응)'}
- 파일 ${files.length} · 엔드포인트 호출 ${live.length} (미해결 ${live.filter(x => x.resolved === 'N').length}, 주석 속 ${ep.length - live.length}) · 이벤트 ${ev.length} · 컴포넌트 사용 ${ctl.length} · 하드코딩 컬럼 ${gc.length} · 메시지 ${msg.length}
- Grid 컬럼 출처: 메타(/column·titleSet) ${r.uses_meta_column === 'Y' ? '사용' : '미사용'} · spreadTitle(동적 헤더 SP) ${r.uses_spread_title === 'Y' ? '사용' : '미사용'} · 하드코딩 컬럼 정의 ${gc.length}건

## 1. 파일
${md(files, ['file', 'role', 'lines'])}
## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
${md(epRows, ['url', 'kind', 'calls', 'resolved', 'where'])}
## 3. procedures.d.ts 등재 시트
${md(dts, ['sheet', 'request_keys', 'response_cursors', 'sp_hints'])}
## 4. 이벤트 배선
${md(ev, ['element', 'event', 'handler', 'via', 'file', 'line'])}
## 5. 컴포넌트 사용 집계
${md(Object.entries(ctlAgg).sort((a, b) => b[1] - a[1]).map(([component, count]) => ({ component, count })), ['component', 'count'])}
## 6. 하드코딩 Grid 컬럼
${md(gc, ['context', 'binding', 'header', 'width', 'visible', 'isReadOnly', 'dataType', 'via', 'file', 'line'])}
## 7. 메시지 코드
${md(Object.entries(msg.reduce((a, m) => (a[m.code] = (a[m.code] || 0) + 1, a), {})).map(([code, count]) => ({ code, count })), ['code', 'count'])}
## 8. 주석 속 As-is 참조
- 화면ID: ${Object.entries(refIds).sort((a, b) => b[1] - a[1]).map(([k, v]) => `${k}(${v})`).join(', ') || '(없음)'}
- SP/PKG: ${Object.entries(refSps).sort((a, b) => b[1] - a[1]).slice(0, 40).map(([k, v]) => `${k}(${v})`).join(', ') || '(없음)'}
## 9. 주석 처리된 코드 (현행 기능 아님)
${md(cc.slice(0, 60), ['kind', 'snippet', 'file', 'line'])}
## 10. __asis-mapping__.md 상태
${Object.entries(mapStat).map(([k, v]) => `- ${k}: ${v}`).join('\n') || '- (매핑 파일 없음)'}
${md(map.filter(m => !m.status.startsWith('구현')), ['design_id', 'summary', 'reason', 'status'])}
`;
}
module.exports = { run };
