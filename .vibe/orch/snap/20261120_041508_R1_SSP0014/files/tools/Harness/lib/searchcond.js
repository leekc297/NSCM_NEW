'use strict';
// 조회조건 기준표(rules/search_cond.csv) — SCP·SSP 화면의 To-Be 조회조건 순서·사용여부·명칭 (2026-10-23 사용자 지시)
//   원천 xlsx → tools/Harness/refs/build_search_cond.py → rules/search_cond.csv + 참고자료 tools/VibeManager/rules/40_SEARCH_COND.md
//   gen.js: apply() 로 조회조건 필드 재정렬·제외·통합·라벨 교체 → GEN_NOTES §12 · check.js SC1(순서)/SC2(제외 조건 잔존)
const fs = require('fs'); const path = require('path');
const { readCsv } = require('../../TobeFacts/src/util');

const norm = s => (s || '').toLowerCase().replace(/[^0-9a-z가-힣]/g, '');
// As-Is 컨트롤 이름/라벨 ↔ 기준표 명칭 별칭 (정규화 후). 기준표 As-Is 명칭이 라벨과 다른 실측 사례만
const ALIAS = { division: 'div', divisions: 'div', version: 'ver', verno: 'ver', versionno: 'ver', seqno: 'seq', planversion: 'plandate', nickname: 'nickname', project: 'project', projectcode: 'project', valid: 'valid', validyn: 'valid', useyn: 'valid', active: 'valid', bucket: 'bucket', buckettype: 'bucket', opgroup: 'operationgroup', group: 'group', dayofweek: 'dayoftheweek', dow: 'dayoftheweek', divisiontype: 'operationgroup' };  // divisiontype = Cell/Pack 라디오(Group,Type 시트: Operation group = Cell/Pack)
const canon = s => { const n = norm(s); return ALIAS[n] || n; };
// 생성하지 않는 사용여부(조회조건 영역에서 빠짐) — 사유는 __asis-mapping__ '해당없음' 으로 남긴다(AS-IS 근거 보존)
const EXCLUDE = new Set(['DROP', 'SUNSET', 'NOT_MIGRATED', 'BUTTON_AREA', 'IN_CALENDAR', 'COLUMN_PERSONAL', 'COMMON_BUTTON']);
const HOLD = new Set(['REVIEW', 'COMMON_REVIEW', 'SUNSET_REVIEW']);

let cache = null;
function load(rulesDir) {
  if (cache && cache.dir === rulesDir) return cache.rows;
  const f = path.join(rulesDir, 'search_cond.csv');
  cache = { dir: rulesDir, rows: fs.existsSync(f) ? readCsv(f) : [] };
  return cache.rows;
}
// 화면 기준표(정본 primary=Y). 없으면 null
function forScreen(rulesDir, id) {
  const rows = load(rulesDir).filter(r => (r.menu_id || '').toUpperCase() === id && r.primary === 'Y');
  if (!rows.length) return null;
  return { id, domain: rows[0].domain, screen: rows[0].screen, src: `${rows[0].src_file} ${rows[0].src_row}~${rows[rows.length - 1].src_row}행`, rows, main: rows.filter(r => r.area === 'MAIN') };
}

// 필드 하나 ↔ 기준표 행: ①As-Is 명칭 = 디자이너 라벨/이름 라벨/param_key ②To-Be 명칭 ③앞부분 포함(4자 이상)
//   유형 호환: 체크박스 ↔ '체크박스' 행만 · 라디오는 '텍스트'/'체크박스'/'버튼' 행 불가 (SCP0100 rgrpSearchLevel 이 콤보 'Search Level' 행을 가져간 사례)
const isRadio = f => /RadioGroup/.test(f.r && f.r.tobe_component || '') || /RadioGroup|UsrRadio|RadioButton/i.test(f.c && f.c.type || '');
const isCheck = f => /Checkbox/.test(f.r && f.r.tobe_component || '');
const compatible = (f, r) => { const t = r.asis_type1; if (!t) return true; if (isCheck(f)) return t === '체크박스'; if (t === '체크박스') return false; if (isRadio(f)) return !/^(텍스트|버튼)$/.test(t); if (t === '라디오버튼') return false; return true; };
function matchRow(f, rows, used) {
  const keys = [f.label, f.nameLabel, f.key, (f.c && f.c.name || '').replace(/^(cbo|clb|txt|chk|drp|usr|rdo|rgrp|d|mrp|dt|num)/, '')].filter(Boolean).map(canon);
  const free = rows.filter(r => !used.has(r) && compatible(f, r));
  const by = (pick) => free.find(r => keys.includes(canon(pick(r))));
  let r = by(r => r.asis_name) || by(r => r.tobe_name);
  if (!r) r = free.find(r => { const a = canon(r.asis_name); return a.length >= 4 && keys.some(k => k.length >= 4 && (k.startsWith(a) || a.startsWith(k))); });
  return r || null;
}

// gen.js 에서 호출 — fields 를 제자리 수정(순서·라벨), 제외 필드는 skipped 로, 통보는 반환값(GEN_NOTES §12)
function apply(ref, fields, skipped, lblFor, todos) {
  const rows = ref.main; const used = new Set(); const out = { ref, matched: [], excluded: [], merged: [], combined: [], hold: [], unmatched: [], missing: [], planVersion: false };
  const keep = [];
  // 영역(area): MAIN 먼저, 남은 필드는 상세 영역(SSP Lv4 'Shipment Plan Detail' 등 — 같은 Form 의 탭/패널 조건) 순서대로. 영역 k 의 순서 = 1000k + 순번
  const areas = [...new Set(ref.rows.map(r => r.area))].sort((x, y) => (x === 'MAIN' ? -1 : y === 'MAIN' ? 1 : 0));
  // 행 순서(시트) → 정렬값: USE/MERGED 는 tobe_order, 그 외(검토중 등)는 시트상 바로 앞 행 값 + 0.5 (시트 위치 보존)
  const ordOf = new Map(); for (const ar of areas) { let prev = 0; for (const r of ref.rows.filter(x => x.area === ar)) { const v = Number(r.tobe_order) || prev + 0.5; ordOf.set(r, areas.indexOf(ar) * 1000 + v); prev = Number(r.tobe_order) || prev; } }
  // 1차: 전 필드 매칭(통합 대상 존재 판정에 필요) → 2차: 제외·통합·라벨
  fields.forEach((f, i) => { f.sc = { asisIdx: i }; });
  // 라디오는 마지막에 매칭(같은 이름의 콤보/텍스트 조건에 행을 양보) → 이름 매칭이 없으면 AS-IS 그룹명 없는 행('NoName')으로 보완
  const matchOrder = fields.filter(f => !isRadio(f)).concat(fields.filter(isRadio));
  for (const ar of areas) for (const f of matchOrder) {
    if (f.sc.row) continue;
    const pool = ref.rows.filter(x => x.area === ar);
    let r = matchRow(f, pool, used);
    if (!r && isRadio(f)) r = pool.find(x => !used.has(x) && /^(noname.*)?$/.test(norm(x.asis_name)) && compatible(f, x)) || null;
    if (r) { used.add(r); f.sc = { row: r, asisIdx: f.sc.asisIdx, order: ordOf.get(r), usage: r.usage, area: ar }; }
  }
  // 같은 이름 컨트롤이 As-is 파일 2곳에 'current' 로 있는 화면(예: SCP0049 — FP·SCP 프로젝트 각각 designer.cs) → 앞 필드의 기준표 행을 공유
  for (const f of fields) if (!f.sc.row) { const twin = fields.find(x => x !== f && x.sc.row && !x.sc.dup && x.c.name === f.c.name); if (twin) f.sc = { ...twin.sc, asisIdx: f.sc.asisIdx, dup: twin.c }; }
  for (const f of fields) {
    const r = f.sc.row;
    if (!r) { out.unmatched.push(f); keep.push(f); continue; }
    const at = `조회조건 기준표(${ref.domain} ${r.src_row}행)`;
    if (f.sc.dup) { skipped.push({ c: f.c, reason: `${at}: 같은 이름 컨트롤 중복(${f.c.file} — 대표 ${f.sc.dup.file}) · 기준표 행 공유` }); out.dups = (out.dups || []).concat({ f, r }); continue; }
    // hook #155: 기준표 BUTTON_AREA + 'Bulk Update' = 조회영역 일괄 입력 → 버튼+입력 팝업으로 '이동'(기능 유지) → 대조표 '미구현'(구현 전까지 추적), '해당없음' 아님
    if (r.usage === 'BUTTON_AREA' && /Bulk Update/i.test(`${r.review} ${r.change}`) && Array.isArray(todos)) { todos.push({ c: f.c, r: { note: `${at}: hook #155 — 조회영역에서 빼고 SubTitle customButtons(Input) + <Page>InputModal 로 이동(정본 SCP0096). 구현 위치 = InputModal` } }); out.excluded.push({ f, r }); continue; }
    if (EXCLUDE.has(r.usage)) { skipped.push({ c: f.c, reason: `${at}: ${r.usage} — ${r.usage_reason || r.change}${r.review ? ' · ' + r.review : ''}` }); out.excluded.push({ f, r }); continue; }
    if (r.usage === 'MERGED' && fields.some(x => x !== f && x.sc.row && x.sc.row.usage === 'USE' && x.sc.area === f.sc.area && canon(x.sc.row.tobe_name) === canon(r.tobe_name))) {
      skipped.push({ c: f.c, reason: `${at}: '${r.tobe_name}' 로 통합(${r.review || r.change}) — 조회 파라미터는 통합 필드 값으로 전달(SP 인자 대조)` }); out.merged.push({ f, r }); continue;
    }
    // 같은 영역에서 여러 AS-IS 필드가 같은 To-Be 명칭(USE)으로 → 첫 필드 하나로 합침(예: SCP0080 FCST/Production/BOM/Active 체크박스 → 'Model Attribute' 선택/다중)
    const head = r.usage === 'USE' && keep.find(x => x.sc.row && x.sc.area === f.sc.area && x.sc.row.usage === 'USE' && canon(x.sc.row.tobe_name) === canon(r.tobe_name));
    if (head) {
      head.scCombined = (head.scCombined || [head.c.name]).concat(f.c.name);
      skipped.push({ c: f.c, reason: `${at}: '${r.tobe_name}' 하나로 합침(${head.c.name} 필드가 대표 — ${r.tobe_type1}/${r.tobe_type2}${r.tobe_note ? ' ' + r.tobe_note : ''}${r.review ? ' · ' + r.review : ''})` });
      out.merged.push({ f, r, into: head }); continue;
    }
    if (HOLD.has(r.usage)) out.hold.push({ f, r });
    else if (r.tobe_name && r.tobe_name !== '-' && r.tobe_name !== f.label) {  // 원문 비교('Plan-date*' → 'Plan Date' 도 교체. 필수 표시는 검증/required 로)
      f.asisLabel = f.label; f.label = r.tobe_name;
      if (!f.cat) f.lbl = lblFor(r.tobe_name) || '';  // 카탈로그 필드는 컴포넌트 내장 라벨 — GEN_NOTES §12 에 명칭 확인 항목
    }
    out.matched.push({ f, r }); keep.push(f);
  }
  // 순서: 기준표 tobe_order. 기준표에 없는 필드는 AS-IS 에서 바로 앞에 있던 필드 뒤에 붙임(상대 위치 보존)
  let last = 0;
  for (const f of keep) { if (f.sc.order) last = f.sc.order; else f.sc.order = last + 0.001 * (f.sc.asisIdx + 1); }
  keep.sort((x, y) => x.sc.order - y.sc.order || x.sc.asisIdx - y.sc.asisIdx);
  fields.splice(0, fields.length, ...keep);
  out.combined = keep.filter(f => f.scCombined).map(f => ({ f, r: f.sc.row, ctls: f.scCombined }));
  // 기준표 USE 인데 AS-IS 컨트롤에 없는 조건(신규 추가 검토 대상)
  const seen = new Set(); for (const r of ref.rows) { if (r.usage !== 'USE' || used.has(r) || seen.has(canon(r.tobe_name))) continue; if ([...used].some(u => canon(u.tobe_name) === canon(r.tobe_name))) continue; seen.add(canon(r.tobe_name)); out.missing.push(r); }
  const names = new Set(rows.filter(r => r.usage === 'USE').map(r => canon(r.tobe_name)));
  out.planVersion = names.has('plandate') && names.has('plantype') && names.has('seq');
  return out;
}

function summary(res) {
  if (!res) return '';
  return `${res.ref.domain} 기준표 ${res.ref.screen}(${res.ref.src}) — 적용 ${res.matched.length} · 제외 ${res.excluded.length} · 통합 ${res.merged.length} · 검토중 ${res.hold.length} · 기준표에 없음 ${res.unmatched.length} · AS-IS 컨트롤 없음 ${res.missing.length}${(res.dups || []).length ? ` · 중복 컨트롤 ${res.dups.length}` : ''}`;
}

module.exports = { load, forScreen, apply, summary, norm, canon, EXCLUDE, HOLD };
