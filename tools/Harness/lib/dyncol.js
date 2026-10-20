'use strict';
// 동적 헤더(기간·타이틀 컬럼) 원천 판정 공용 — check.js(B26/B27) · gap.js · gen.js 가 같은 판정을 쓴다.
//   계기(2026-10-20 SCP0096): As-is GetSpdTitle → SCP0009_GET_SHEET_CALENDAR_3SPAN 으로 기간 컬럼을 만들었는데,
//   To-Be 는 사내 배선(calendar/SEARCH)을 호출하지 않고 BE 에 없는 응답 키(o_rc1_columns)에서 컬럼을 파생 → 조회 시 기간 컬럼 0.
//   정적 게이트는 ①타이틀 SP '등록'만으로 COVERED ②응답 키 존재 미검사 ③생성기 _SPREAD_TITLE 정규식 1개 로 모두 통과했다.
const fs = require('fs'); const path = require('path');

// 타이틀 SP 판정 — 다중 신호(anti-simplification): ①SP 이름 계열 ②호출 메서드 ③(check.js) grid_code DB루프
//   전수 조사(Doc/asisfacts/screens/*/endpoints.csv 9,283행, 2026-10-20) 접미 분포: *_GET_SHEET_CALENDAR_3SPAN 69 · *_GET_SPREAD_TITLE 47 ·
//   *_GET_COMMON_SPREAD_TITLE 45 · *_SPREAD_TITLE_DATE 9 · *_GET_SHEET_CALENDAR 7 · *_3SPAN_ISO 4 · *_TITLE_PARAL 7 · *_SHEET_USER_TITLE 4 · HOLIDAY_CALENDAR 1 …
//   TITLESET(사용자 컬럼셋 팝업 저장/조회)은 헤더 원천이 아니므로 제외.
const TITLE_SP_RE = /(SPREAD_TITLE|SHEET_CALENDAR|SHEET_USER_TITLE|_TITLE_PARAL$|HOLIDAY_CALENDAR)/i;
const TITLE_EXCLUDE_RE = /TITLESET/i;
const TITLE_MEMBER_RE = /^(GetSpdTitle\w*|GetSpdHoliday|GetUserTitle|SetSpdTitleSummary)$/i;
const spOf = e => (e.sp_or_sql || '').replace(/^SP\s+/, '').trim();

// 헤더 원천 종류
//   'meta'   = SCM_MST_SHEET_COLUMNS(+TITLESET_USER) 만 읽는 공통 타이틀 → To-Be admin 컬럼 메타(/admin/menu/{MENU}/column)로 대체 = 정상
//   'period' = 그 외(SCM_SYS_CALENDAR_M · CTE 날짜 · 동적 SQL 등) → 사내 배선된 타이틀 SP 를 FE 가 호출해야 함(As-is 1:1)
const kindOf = objects => { const o = (objects || '').toUpperCase(); return /SCM_MST_SHEET_COLUMNS/.test(o) && !/CALENDAR|CTE_DATE|SP_EXECUTESQL|FN_WEEKOFDAY/.test(o) ? 'meta' : 'period'; };

function asisTitleEndpoints(eps) {
  const seen = new Map();
  for (const e of eps) {
    if (e.variant === 'legacy') continue; const sp = spOf(e); if (!sp || TITLE_EXCLUDE_RE.test(sp)) continue;
    const bySp = TITLE_SP_RE.test(sp), byMember = TITLE_MEMBER_RE.test(e.member || '');
    if (!bySp && !byMember) continue;
    const k = sp.toUpperCase();
    const cur = seen.get(k) || { sp, key: e.key || e.candidate, members: new Set(), signals: new Set(), objects: e.objects || '' };
    cur.members.add(e.member); if (bySp) cur.signals.add('sp명'); if (byMember) cur.signals.add('메서드'); seen.set(k, cur);
  }
  return [...seen.values()].map(x => ({ ...x, kind: kindOf(x.objects), members: [...x.members], signals: [...x.signals] }));
}
// As-is grid_code.csv 의 DB루프(타이틀 결과셋 foreach 로 컬럼 생성) — 3번째 신호
function asisDbLoop(sdir) {
  const f = path.join(sdir, 'grid_code.csv'); if (!fs.existsSync(f)) return [];
  const { readCsv } = require('../../TobeFacts/src/util');
  // grid_code.csv 의 source 값은 'DB_DRIVEN'(summary §11 표시명이 'DB루프'). 컬럼 생성(kind=COLUMN · Add*Column)만 신호로 쓴다.
  //   (2026-10-20 정정: 최초 /DB루프/ 로 써서 항상 0건이던 결함)
  return readCsv(f).filter(r => r.variant !== 'legacy' && /^(DB_DRIVEN|DB루프)$/.test(r.source || '') && (r.kind === 'COLUMN' || /^Add\w*Column$/.test(r.api || ''))).map(r => `${r.member}:${r.line}`);
}
// 사내 배선(proc_meta) 에서 As-is 타이틀 SP 에 대응하는 시트 — 정확(proc_nm 이 As-is SP 로 끝남) 우선, 없으면 같은 화면의 타이틀 계열 배선
//   excludeSheets: 다른 As-is 타이틀 SP 에 이미 정확 매칭된 시트(계열 추정에서 재사용 금지 — SCP0011 TITLE_PARAL→calendar 오귀속 교정)
function corpTitleSheets(spName, menuMeta, excludeSheets) {
  const up = spName.toUpperCase();
  let rows = menuMeta.filter(r => (r.proc_nm || r.proc || '').toUpperCase().endsWith(up)); let via = 'exact';
  if (!rows.length) { rows = menuMeta.filter(r => { const n = r.proc_nm || r.proc || ''; return TITLE_SP_RE.test(n) && !TITLE_EXCLUDE_RE.test(n) && !(excludeSheets && excludeSheets.has(r.sheet)); }); via = 'family'; }
  return { via: rows.length ? via : 'none', sheets: [...new Set(rows.map(r => r.sheet))], procs: [...new Set(rows.map(r => r.proc))], pairs: rows.map(r => ({ sheet: r.sheet, btn: r.btn || 'SEARCH', proc: r.proc })) };
}
// (시트,버튼) 쌍 단위 소비 판정 — 같은 시트에 데이터 SEARCH 와 타이틀 버튼(예: DMF0020 main/SPREAD_TITLE_DATE)이 함께 배선되면
//   시트 참조만으로는 타이틀 호출을 증명할 수 없다. btn ≠ SEARCH 면 FE 원문에 그 버튼 코드 문자열이 있어야 한다. (2026-10-20 DMF0020 오판 교정)
function consumesPair(src, pair) {
  if (!consumesSheet(src, pair.sheet)) return false; if (!pair.btn || pair.btn === 'SEARCH') return true;
  const body = Object.entries(src).filter(([f]) => !/[\\/]__tests__[\\/]/.test(f)).map(([, t]) => t.replace(/\/\*[\s\S]*?\*\//g, '').replace(/^\s*\/\/.*$/gm, '')).join('\n');
  return new RegExp(`['"\`/]${pair.btn.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}['"\`/]`).test(body);
}
function corpAllTitlePairs(menuMeta) { return menuMeta.filter(r => { const n = r.proc_nm || r.proc || ''; return TITLE_SP_RE.test(n) && !TITLE_EXCLUDE_RE.test(n); }).map(r => ({ sheet: r.sheet, btn: r.btn || 'SEARCH', proc: r.proc })); }
// 같은 화면의 타이틀 계열 배선 시트 전부(제외 없음) — 정확 배선이 없는 As-is 변형 SP(예: 3SPAN_ISO)를 같은 계열 시트가 대신 공급하는지 판정용
function corpAllTitleSheets(menuMeta) { return [...new Set(menuMeta.filter(r => { const n = r.proc_nm || r.proc || ''; return TITLE_SP_RE.test(n) && !TITLE_EXCLUDE_RE.test(n); }).map(r => r.sheet))]; }
// 페이지 원문(src: {file: text}) 에서 시트 소비 여부 — <상수객체>.<KEY>(값=sheet; SHEETS·AUX_SHEET 등 이름 무관) 를 constants·테스트 밖에서
//   참조하거나, 시트 문자열을 call-proc URL/인자로 사용. (SCP0100 AUX_SHEET.CALENDAR 오탐 교정 2026-10-20)
function consumesSheet(src, sheet) {
  const constTxt = Object.entries(src).filter(([f]) => /constants\.ts$/.test(f)).map(([, t]) => t).join('\n');
  const keys = [...constTxt.matchAll(/(\w+)\s*[=:]\s*'([^']+)'/g)].filter(m => m[2] === sheet).map(m => m[1]);
  const body = Object.entries(src).filter(([f]) => !/constants\.ts$/.test(f) && !/[\\/]__tests__[\\/]/.test(f)).map(([, t]) => t.replace(/\/\*[\s\S]*?\*\//g, '').replace(/^\s*\/\/.*$/gm, '')).join('\n');
  if (keys.some(k => new RegExp(`\\b[A-Z][A-Z0-9_]*\\.${k}\\b`).test(body))) return true;
  const esc = sheet.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  return new RegExp(`['"\`/]${esc}['"\`/]`).test(body);
}
// 응답 키 허용 집합 — BE BaseService.selectList 는 PROC_M OUT COL_NM(대소문자 그대로) + DATARESULT 만 응답 키로 만든다.
//   o_rc1_columns 등 ResultSetMetaData 사이드카는 SYS0013 DynamicQueryServiceImpl 전용(일반 call-proc 에 없음).
function outKeys(procs, params) { const s = new Set(params.filter(p => procs.includes(p.proc) && p.col_tp_cd === 'OUT').map(p => p.col_nm)); s.add('DATARESULT'); return s; }
function responseSetValues(constTxt) {
  const m = constTxt.match(/RESPONSE_SET\s*(?:=\s*)?\{([\s\S]*?)\}/); if (!m) return [];
  return [...m[1].matchAll(/^\s*(\w+)\s*[:=]\s*'([^']+)'/gm)].map(x => ({ key: x[1], value: x[2] }));
}
module.exports = { TITLE_SP_RE, TITLE_EXCLUDE_RE, TITLE_MEMBER_RE, asisTitleEndpoints, asisDbLoop, corpTitleSheets, corpAllTitleSheets, corpAllTitlePairs, consumesSheet, consumesPair, outKeys, responseSetValues, kindOf };
