'use strict';
// actions — AS-IS 액션 대조표 __asis-actions__.md (사용자 지시 2026-10-23: 파싱한 구체 액션 — 사전 미등록 외부 호출 포함 — 을 대조표·게이트에 연결)
//   원천: Doc/asisfacts/screens/<AS-IS ID>/actions.csv(메서드 문장 전수) + actions_entries.csv(진입점 → 도달 메서드)  ← tools/AsisFacts pack
//   대상 행 = 사용자 결과에 영향이 있는 kind 전부. 제외 = 지역변수·순수 계산·분기 조건 자체(행 guard 에 붙음)·화면 메서드 호출 연결·로그·using·흐름 제어·이벤트 연결(§2 대조표 담당)
//   CALL_EXT(사전 미등록 외부 호출)·CALL_BASE(상속 메서드)는 '의미' 칸이 '⚠ 의미 확인 필요' 로 생성 → 구현자가 실제 의미를 적어야 한다(게이트 AC2)
//   행 ID = AC-<hash8>(class·method·line·kind·target) — 재생성해도 같은 ID → 상태·구현 위치·사유 보존(merge)
const fs = require('fs'); const path = require('path'); const crypto = require('crypto');
const { readCsv } = require('../../TobeFacts/src/util');

const EXCL = new Set(['LOCAL', 'EXPR', 'BRANCH', 'CALL_LOCAL', 'RESOURCE', 'FLOW', 'LOG', 'EVENT_WIRE']);
const UNKNOWN = new Set(['CALL_EXT', 'CALL_BASE']);
const NEED = '⚠ 의미 확인 필요';
const FILE = '__asis-actions__.md';
const HDR = '| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |';

const esc = s => String(s == null ? '' : s).replace(/\r?\n/g, ' ').replace(/\|/g, '\\|').trim();
const cut = (s, n) => { s = esc(s); return s.length > n ? s.slice(0, n) + '…' : s; };
const idOf = r => 'AC-' + crypto.createHash('sha1').update([r.class, r.method, r.line, r.kind, r.target].join('|')).digest('hex').slice(0, 8);

function asisId(cfg, id) {
  const ID = String(id || '').toUpperCase();
  try {
    const ms = readCsv(path.join(cfg.rulesDir || path.join(__dirname, '..', 'rules'), 'map_screen.csv'));
    const byT = ms.find(r => (r.tobe_id || '').toUpperCase() === ID); if (byT && byT.asis_id) return byT.asis_id.toUpperCase();
  } catch { /* 사전 없음 */ }
  return ID;
}

function load(cfg, id) {
  const AID = asisId(cfg, id); const dir = path.join(cfg.asisOutDir, 'screens', AID);
  const af = path.join(dir, 'actions.csv'); if (!fs.existsSync(af)) return null;
  const rows = readCsv(af).filter(r => !EXCL.has(r.kind));
  const ents = readCsv(path.join(dir, 'actions_entries.csv'));
  const byMethod = new Map(); // class|method → 진입점 목록
  for (const e of ents) { const k = e.class + '|' + e.method; if (!byMethod.has(k)) byMethod.set(k, []); const lab = e.entry_kind === 'unreached' ? '(진입점 미연결)' : `${e.entry}${e.call_guard ? ` [${e.call_guard}]` : ''}`; if (!byMethod.get(k).includes(lab)) byMethod.get(k).push(lab); }
  return { AID, dir, rows, byMethod };
}

// 기존 대조표(상태·구현 위치·사유·사람이 채운 의미) 파싱
function parse(md) {
  const m = new Map();
  for (const line of String(md || '').split(/\r?\n/)) {
    const x = line.match(/^\|\s*(AC-[0-9a-f]{8})\s*\|(.*)\|\s*$/); if (!x) continue;
    const c = x[2].split(/(?<!\\)\|/).map(s => s.trim());
    m.set(x[1], { meaning: c[6] || '', impl: c[7] || '', status: c[8] || '', reason: c[9] || '', kind: c[3] || '', target: c[4] || '', where: c[1] || '' });
  }
  return m;
}

function render(cfg, id, prev) {
  const L = load(cfg, id); if (!L) return null;
  const old = parse(prev);
  const groups = new Map();
  for (const r of L.rows) { const k = r.class + '|' + r.method; if (!groups.has(k)) groups.set(k, []); groups.get(k).push(r); }
  const kinds = {}; let unknown = 0; const seenIds = new Map();
  const out = [`# AS-IS 액션 대조표 — ${id}${L.AID !== String(id).toUpperCase() ? ` (AS-IS ${L.AID})` : ''}`, '',
    `> 원천: \`Doc/asisfacts/screens/${L.AID}/actions.csv\` · \`actions_entries.csv\` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 ${new Date().toISOString().slice(0, 10)}).`,
    '> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.',
    `> **${NEED}** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).`,
    '> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.', ''];
  for (const [k, rs] of [...groups.entries()].sort((a, b) => a[0].localeCompare(b[0]))) {
    const [cls, method] = k.split('|');
    const ents = L.byMethod.get(k) || ['(진입점 정보 없음)'];
    out.push(`## ${cls}.${method}`, '', `진입점: ${cut(ents.join(' / '), 600)}`, '', HDR, '|---|---|---|---|---|---|---|---|---|---|---|');
    for (const r of rs) {
      const base = idOf(r); const n = (seenIds.get(base) || 0) + 1; seenIds.set(base, n);
      const aid = n === 1 ? base : 'AC-' + crypto.createHash('sha1').update(base + '#' + n).digest('hex').slice(0, 8); // 같은 줄·대상 중복 → 순번으로 구분
      const o = old.get(aid) || {};
      kinds[r.kind] = (kinds[r.kind] || 0) + 1;
      let meaning = r.meaning || '';
      if (UNKNOWN.has(r.kind)) { meaning = o.meaning && !o.meaning.startsWith('⚠') ? o.meaning : NEED; if (meaning === NEED) unknown++; }
      const where = `${String(r.file).replace(/\\/g, '/').split('/').pop()}:${r.line}`;
      out.push(`| ${aid} | ${cut(ents[0], 60)}${ents.length > 1 ? ` 외 ${ents.length - 1}` : ''} | ${where} | ${cut(r.guard, 140)} | ${r.kind} | ${cut(r.target, 90)} | ${cut(r.value, 90)}${r.endpoint ? ` ⇒ ${cut(r.endpoint, 80)}` : ''} | ${cut(meaning, 120)} | ${o.impl || ''} | ${o.status || ''} | ${o.reason || ''} |`);
    }
    out.push('');
  }
  out.splice(6, 0, `건수: ${L.rows.length}행 · 메서드 ${groups.size} · 종류 ${Object.entries(kinds).sort((a, b) => b[1] - a[1]).map(([k, v]) => `${k} ${v}`).join(' · ')} · ${NEED} ${unknown}`, '');
  return { md: out.join('\n') + '\n', rows: L.rows.length, unknown, AID: L.AID };
}

// 게이트용 — 대조표 행 판정 목록
function rowsOf(md) { return [...parse(md).entries()].map(([id, v]) => Object.assign({ id }, v)); }

// 기존 화면 문서 위치(문서 보강 단계 — 게이트 WARN 전용): Doc/asisfacts/screens/<AS-IS ID>/__asis-actions__.md
const docPath = (cfg, id) => path.join(cfg.asisOutDir, 'screens', asisId(cfg, id), FILE);

module.exports = { load, render, parse, rowsOf, asisId, docPath, FILE, NEED, EXCL, UNKNOWN };
