'use strict';
// valref — SCP·SSP 화면 VALIDATION 취합 참고자료 (사용자 지시 2026-10-23: VALIDATION 관련 작업에 참고)
//   원천: Doc/화면분석서/{SCP|SSP}_화면_VALIDATION_취합_<STAMP>.md (엑셀 전 시트 텍스트본)
//         + 같은 이름 폴더/<화면ID>.md (화면별 분할본: 판독현황·차단·보정_필터·제외_미실행) + _INDEX.md
//   AS-IS 기준 화면(C#)·DB(SP) 검증 전수 + TO-BE 적용여부(적용/미적용/TO-BE 미개발/미확인) + TO-BE 적용 TAG
//   ([AS-IS 결함 교정]/[반환값 상실·영향 없음]/[예외 전파 변경]/[판정 결과 차이]/[메시지 불일치]/[메시지 미등록])
//   + MSG ID 칸 "AS-IS ID, TO-BE ID(TO-BE)" + 메시지 의미 대조. 판정 기준 = 전체본 "작성기준" 시트.
//   STAMP 는 폴더 안 최신 파일을 자동 선택(재생성 시 코드 수정 불필요). SCP/SSP 외 화면은 null.
const fs = require('fs'); const path = require('path');

const refDir = cfg => cfg.validationRefDir || path.join(path.dirname(cfg.analysisRoot || 'C:\\Projects\\NSCM\\Doc\\_analysis'), '화면분석서');
const projRoot = cfg => path.dirname(path.dirname(refDir(cfg)));
const relp = (cfg, f) => path.relative(projRoot(cfg), f).replace(/\\/g, '/');

function latest(cfg, dom) {
  const d = refDir(cfg); if (!fs.existsSync(d)) return null;
  const re = new RegExp(`^${dom}_화면_VALIDATION_취합_(\\d{8})\\.md$`);
  const hits = fs.readdirSync(d).map(n => (n.match(re) || [])[1] ? { n, stamp: n.match(re)[1] } : null).filter(Boolean).sort((a, b) => b.stamp.localeCompare(a.stamp));
  return hits[0] ? { file: path.join(d, hits[0].n), stamp: hits[0].stamp } : null;
}

// md 표 1행 → 셀 배열 (`\|` = 셀 안 파이프, `<br>` = 셀 안 줄바꿈)
const cells = ln => ln.replace(/^\|\s?|\s?\|$/g, '').split(/(?<!\\)\|/).map(c => c.trim().replace(/\\\|/g, '|').replace(/<br>/g, '\n'));

function section(md, name) {
  const i = md.indexOf(`\n## ${name}\n`); if (i < 0) return [];
  const body = md.slice(i + name.length + 5).split(/\n## /)[0];
  const lines = body.split('\n').filter(l => l.startsWith('| '));
  if (lines.length < 1) return [];
  const hdr = cells(lines[0]);
  return lines.slice(1).map(l => { const c = cells(l); const o = {}; hdr.forEach((h, k) => { o[h] = c[k] || ''; }); return o; });
}

function find(cfg, id) {
  const ID = String(id || '').toUpperCase(); const dom = (ID.match(/^(SCP|SSP)\d{4}$/) || [])[1]; if (!dom) return null;
  const L = latest(cfg, dom); if (!L) return null;
  const sdir = L.file.replace(/\.md$/, ''); const sf = path.join(sdir, `${ID}.md`);
  const r = { id: ID, dom, stamp: L.stamp, full: relp(cfg, L.file), index: relp(cfg, path.join(sdir, '_INDEX.md')), screen: fs.existsSync(sf) ? relp(cfg, sf) : '', block: [], fix: [], excl: [] };
  if (!r.screen) return r;
  const md = fs.readFileSync(sf, 'utf8').replace(/\r\n/g, '\n'); // export_md.py(Windows 텍스트 모드) = CRLF
  r.block = section(md, 'UI별VALIDATION_차단'); r.fix = section(md, 'UI별VALIDATION_보정_필터'); r.excl = section(md, '제외_미실행');
  const cnt = (rows, f) => rows.reduce((m, x) => { for (const v of f(x)) if (v) m[v] = (m[v] || 0) + 1; return m; }, {});
  r.apply = cnt(r.block, x => [x['TO-BE 적용여부']]);
  r.tags = cnt(r.block, x => (x['TO-BE 적용 TAG'] || '').split('\n'));
  return r;
}

// "MSG00002, MSG00429(TO-BE)" → { asis: ['MSG00002'], tobe: ['MSG00429'] }
const msgIds = s => ({ asis: [...String(s || '').matchAll(/(MSG\d{5})(?!\(TO-BE\))/g)].map(m => m[1]), tobe: [...String(s || '').matchAll(/(MSG\d{5})\(TO-BE\)/g)].map(m => m[1]) });
const tagOf = (x, t) => (x['TO-BE 적용 TAG'] || '').includes(t);

function summary(r) {
  if (!r) return '';
  if (!r.screen) return `VALIDATION 취합(${r.stamp}) 에 ${r.id} 화면 파일 없음 — 전체본 ${r.full}`;
  const kv = o => Object.entries(o).map(([k, v]) => `${k} ${v}`).join(' · ') || '없음';
  return `${r.screen} (차단 ${r.block.length}행 · 보정_필터 ${r.fix.length}행 · 제외 ${r.excl.length}행) — TO-BE 적용여부: ${kv(r.apply)} / 적용 TAG: ${kv(r.tags)}`;
}

module.exports = { refDir, latest, find, summary, msgIds, tagOf, section, cells };
