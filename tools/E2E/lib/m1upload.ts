// 2026-11-25 T584(SCP0005 M1 V-219edc76 '[측정 코드 없음] … 양식·검증 시나리오 미구현'): Excel Upload 검증 메시지(행 상태) AS-IS ↔ TO-BE 대조.
//   AS-IS 공용 업로드 창(ExcelUploadForm2.cs)의 Validation_Check_<화면ID> 원문에서 행 상태 문구('Error-…')와 그 조건을 읽어 오류 종류별 행을 만든다.
//   기준 행 = 화면 조회 결과의 기존 행 1개(양식 머리글 ↔ 그리드 칸 순서 대응). 저장(적재)은 하지 않는다: 검증 단계 응답의 행 상태만 읽는다.
//   순수 함수만 둔다(m1upload.selftest.js).

export type M1Kind = { status: string; kind: 'required' | 'allEmpty' | 'lookup' | 'dbdup' | 'filedup'; vars: string[]; line: number };
export type M1Parse = { fn: string; kinds: M1Kind[]; varIdx: Record<string, number>; idVar: string; skipped: string[]; why: string };

/** 함수 본문(주석 제거) · 상태 문구별 조건 분류. varIdx = 변수 → 양식 칸 번호(업로드 그리드 칸 - 1 · 0번 칸 = 상태) */
export function parseUploadKinds(cs: string, programId: string): M1Parse {
  const fn = `Validation_Check_${programId}`;
  const out: M1Parse = { fn, kinds: [], varIdx: {}, idVar: '', skipped: [], why: '' };
  const at = cs.search(new RegExp(`\\b(private|public|protected)\\s+\\w+\\s+${fn}\\s*\\(`));
  if (at < 0) { out.why = `AS-IS ${fn} 없음`; return out; }
  const rest = cs.slice(at); const endRel = rest.slice(10).search(/\n\s{8}(private|public|protected)\s/); const raw = endRel < 0 ? rest : rest.slice(0, endRel + 10);
  const lineOf = (i: number) => cs.slice(0, at + i).split('\n').length;
  // 주석 안 상태 문구(실행 안 됨) = 대상 아님으로 따로 기록
  for (const m of raw.matchAll(/\/\*[\s\S]*?\*\//g)) for (const s of m[0].matchAll(/Value\s*=\s*"([^"]*Error[^"]*)"/g)) if (!out.skipped.includes(s[1])) out.skipped.push(s[1]);
  const body = raw.replace(/\/\*[\s\S]*?\*\//g, m => m.replace(/[^\n]/g, ' ')).replace(/\/\/[^\n]*/g, m => ' '.repeat(m.length));
  for (const m of body.matchAll(/(str\w+)\s*=\s*\w+\.Sheets\[0\]\.Cells\[i,\s*(\d+)\]\.Value/g)) out.varIdx[m[1]] = Number(m[2]) - 1;
  const idm = /if\s*\(\s*(str\w+)\s*==\s*""\s*\)\s*\{?\s*\1\s*=\s*"0"/.exec(body); if (idm) out.idVar = idm[1];
  const condBefore = (pos: number): string => {
    const k = body.lastIndexOf('if (', pos); if (k < 0) return '';
    let d = 0; for (let j = k + 3; j < body.length; j++) { if (body[j] === '(') d++; else if (body[j] === ')') { d--; if (d === 0) return body.slice(k, j + 1); } }
    return body.slice(k, pos);
  };
  const seen = new Set<string>();
  for (const m of body.matchAll(/Cells\[i,\s*0\]\.Value\s*=\s*"(Error[^"]*)"/g)) {
    const st = m[1]; if (seen.has(st)) continue;
    const c = condBefore(m.index || 0); const line = lineOf(m.index || 0);
    let k: M1Kind | null = null;
    if (/Cells\[j,/.test(c)) k = { status: st, kind: 'filedup', vars: [...c.matchAll(/(str\w+)\s*==\s*\w+\.Sheets\[0\]\.Cells\[j,/g)].map(z => z[1]), line };
    else if (/Dup\w*Cnt\s*!=\s*0/i.test(c)) k = { status: st, kind: 'dbdup', vars: [], line };
    else if (/\.Select\(/.test(c) && /Length\s*==\s*0/.test(c)) k = { status: st, kind: 'lookup', vars: [...c.matchAll(/'"\s*\+\s*(str\w+)/g)].map(z => z[1]), line };
    else if (/(str\w+)\s*==\s*""/.test(c)) { const vs = [...c.matchAll(/(str\w+)\s*==\s*""/g)].map(z => z[1]); k = { status: st, kind: /&&/.test(c) && !/\|\|/.test(c) ? 'allEmpty' : 'required', vars: vs, line }; }
    if (k) { out.kinds.push(k); seen.add(st); }
  }
  if (!out.kinds.length) out.why = `${fn} 안 상태 문구 조건 해석 0건`;
  return out;
}

/** 양식 머리글 ↔ 그리드 칸(순서대로) 대응. 같은 자리에서 머리글이 같거나 양식 머리글이 그리드 머리글로 끝나면 일치('From Country*' ↔ 'Country*') · 80% 이상 일치면 자리 대응 */
export function mapFormToGrid(form: string[], grid: { b: string; header: string }[]): { map: string[]; agree: number; diff: string[]; ok: boolean } {
  const n = (t: string) => String(t || '').replace(/\*/g, '').replace(/\s+/g, ' ').trim().toLowerCase();
  const diff: string[] = []; let agree = 0; const map: string[] = [];
  form.forEach((f, i) => { const g = grid[i]; map.push(g ? g.b : ''); if (g && (n(f) === n(g.header) || n(f).endsWith(' ' + n(g.header)))) agree++; else diff.push(`${i}:'${f}'↔'${g ? g.header : '-'}'`); });
  return { map, agree, diff, ok: form.length > 0 && form.length <= grid.length && agree >= Math.ceil(form.length * 0.8) };
}

export type M1Row = { status: string; kind: string; cells: string[]; how: string };

/** 기준 행(base · 양식 칸 순서 값)에서 오류 종류별 행을 만든다. 첫 행 = 대조군(바꾸지 않음 · 기대 'Success') */
export function buildM1Rows(base: string[], ps: M1Parse): { rows: M1Row[]; notBuilt: string[] } {
  const rows: M1Row[] = [{ status: 'Success', kind: 'control', cells: [...base], how: '기준 행 그대로' }]; const notBuilt: string[] = [];
  const ix = (v: string) => (v in ps.varIdx ? ps.varIdx[v] : -1);
  const lookVars = new Set(ps.kinds.filter(k => k.kind === 'lookup').flatMap(k => k.vars));
  const emptyVars = new Set(ps.kinds.filter(k => k.kind === 'allEmpty').flatMap(k => k.vars));
  for (const k of ps.kinds) {
    const cells = [...base];
    if (k.kind === 'required' || k.kind === 'allEmpty') {
      const vs = k.kind === 'required' ? k.vars.filter(v => v !== ps.idVar).slice(0, 1) : k.vars; const is = vs.map(ix);
      if (!is.length || is.some(i => i < 0)) { notBuilt.push(`${k.status}: 변수 칸 위치 못 찾음(${vs.join(',')})`); continue; }
      for (const i of is) cells[i] = ''; rows.push({ status: k.status, kind: k.kind, cells, how: `${vs.join(',')} 비움` });
    } else if (k.kind === 'lookup') {
      const i = ix(k.vars[0] || ''); if (i < 0) { notBuilt.push(`${k.status}: 조회 대상 변수 칸 위치 못 찾음(${k.vars.join(',')})`); continue; }
      cells[i] = 'ZZ'; rows.push({ status: k.status, kind: k.kind, cells, how: `${k.vars[0]} = 'ZZ'(기준 정보에 없는 값)` });
    } else if (k.kind === 'dbdup') {
      const i = ix(ps.idVar); if (i < 0) { notBuilt.push(`${k.status}: 행 식별 변수(빈 값이면 "0") 칸 못 찾음`); continue; }
      cells[i] = ''; rows.push({ status: k.status, kind: k.kind, cells, how: `${ps.idVar} 비움(신규 행) · 나머지 = 기존 행과 같은 값` });
    } else if (k.kind === 'filedup') {
      const free = k.vars.filter(v => v !== ps.idVar && !lookVars.has(v) && !emptyVars.has(v) && ix(v) >= 0);
      const v = free[free.length - 1]; if (!v) { notBuilt.push(`${k.status}: 바꿀 자유 칸 없음(비교 변수 ${k.vars.join(',')})`); continue; }
      cells[ix(v)] = 'E2EDUP'; rows.push({ status: k.status, kind: k.kind, cells, how: `${v} = 'E2EDUP' 같은 행 2개(1/2)` }); rows.push({ status: k.status, kind: k.kind, cells: [...cells], how: `${v} = 'E2EDUP' 같은 행 2개(2/2)` });
    }
  }
  // 2026-11-25 T637(SCP0005 V-219edc76 row_run 18:48 '대조군 상태 Error-Duplicate'): AS-IS 파일 안 중복 검사(ExcelUploadForm2.cs:1062~1080)는 비교 칸이 모두 같은 두 행을
  //   'Error-Duplicate' 로 바꾼다. 기준 행을 복사해 비교 칸이 아닌 칸만 바꾼 행(요일 비움 등)이 대조군과 겹쳐 대조군까지 오류가 됐다 →
  //   대조군·DB 중복 행·파일 중복 쌍을 뺀 행은 비교 칸 중 자유 칸(행 ID·기준 정보 조회·묶음 필수 아님) 하나에 행 번호 꼬리를 붙여 서로 겹치지 않게 한다
  const dupK = ps.kinds.find(k => k.kind === 'filedup');
  const freeK = dupK ? dupK.vars.filter(v => v !== ps.idVar && !lookVars.has(v) && !emptyVars.has(v) && ix(v) >= 0) : [];
  const fv = freeK[freeK.length - 1];  // 파일 중복 쌍과 같은 칸(자유 칸 마지막)
  if (fv) rows.forEach((r, n) => { if (r.kind === 'control' || r.kind === 'dbdup' || r.kind === 'filedup') return; const i = ix(fv); if (r.cells[i] === '') return; r.cells[i] = `${r.cells[i]}M${n}`; r.how += ` · ${fv} 꼬리 'M${n}'(파일 안 중복 피함 · T637)`; });
  return { rows, notBuilt };
}

/** 응답 본문에서 행 상태 배열(값이 Success·Error… 인 문자 칸을 가진 객체 배열)을 찾는다 */
export function statusesOf(json: unknown): string[] | null {
  let best: string[] | null = null;
  const walk = (o: unknown, d: number): void => {
    if (d > 6 || o == null) return;
    if (Array.isArray(o)) {
      const objs = o.filter(x => x && typeof x === 'object' && !Array.isArray(x)) as Record<string, unknown>[];
      if (objs.length && objs.length === o.length) {
        const keys = Object.keys(objs[0]); const k = keys.find(kk => objs.every(x => typeof x[kk] === 'string' && /^(Success|Error\b[^\n]*)$/i.test(String(x[kk]).trim())));
        if (k && (!best || objs.length > best.length)) best = objs.map(x => String(x[k]).trim());
      }
      for (const x of o) walk(x, d + 1); return;
    }
    if (typeof o === 'object') for (const v of Object.values(o as Record<string, unknown>)) walk(v, d + 1);
  };
  walk(json, 0); return best;
}

// 2026-11-25 T600(SCP0005 E3 V-087d756b · M1 V-219edc76 '[측정 경로 없음] 업로드 응답에서 행 상태 배열 못 찾음'): TO-BE 공용 업로드 결과
//   PKG_NSCM_UI_EXCEL.PR_GET_EXCEL_UPLOAD_RESULT 는 O_CUR_CNT(SUCCESS_COUNT·ERROR_COUNT·TOTAL_COUNT) 와 O_CUR_LIST(오류 행만 · EXCEL_ROW·UPLOAD_STATUS_CODE·ATTRIBUTE1..n·MESSAGE_TEXT)를 돌려준다
//   (_artifacts/_apply_corporate/DMF0074_EXCELFORM_2TIER_20260914/02_PKG_NSCM_UI_EXCEL_BODY.sql 85~158 · 행 상태 문구 = MESSAGE_TEXT ← PKG_SCP0005 P_WRITE_STAT T_STAT).
//   종전 statusesOf 는 '모든 행이 상태 칸을 가진 배열'만 찾아 성공 행이 빠진 오류 행 목록을 못 읽었다 → 상태는 키 이름이 아니라 값으로 찾고(STATUS_RE), 성공 행은 건수로 채운다.
export const STATUS_RE = /^(Success|Error-.+|.+ Error)$/;
/** 객체 안 문자 값 중 행 상태 문구(STATUS_RE) 첫 값 · 없으면 '' */
export function statusOfRow(o: Record<string, unknown>): string { for (const v of Object.values(o)) if (typeof v === 'string' && STATUS_RE.test(v.trim())) return v.trim(); return ''; }
export type UpStat = { statuses: string[] | null; total: number | null; ok: number | null; err: number | null; errRows: { status: string; row: number | null }[]; why: string };
/** 업로드 응답 → 올린 행 순서의 상태 배열. cells = 올린 행(양식 칸 순서) · 오류 행은 ATTRIBUTE{k+1} ↔ cells[k] 값 일치로 짝짓는다(성공 행 = 'Success' · 건수 맞을 때만) */
export function uploadStatuses(json: unknown, cells?: string[][]): UpStat {
  const out: UpStat = { statuses: null, total: null, ok: null, err: null, errRows: [], why: '' };
  const num = (v: unknown) => (v == null || v === '' || Number.isNaN(Number(v)) ? null : Number(v));
  let list: Record<string, unknown>[] | null = null;
  const walk = (o: unknown, d: number): void => {
    if (d > 6 || o == null) return;
    if (Array.isArray(o)) {
      const objs = o.filter(x => x && typeof x === 'object' && !Array.isArray(x)) as Record<string, unknown>[];
      if (objs.length && objs.length === o.length && objs.every(x => statusOfRow(x)) && (!list || objs.length > list.length)) list = objs;
      for (const x of o) walk(x, d + 1); return;
    }
    if (typeof o === 'object') {
      const rec = o as Record<string, unknown>;
      if ('ERROR_COUNT' in rec && out.err == null) { out.err = num(rec.ERROR_COUNT); out.ok = num(rec.SUCCESS_COUNT); out.total = num(rec.TOTAL_COUNT); }
      for (const v of Object.values(rec)) if (v && typeof v === 'object') walk(v, d + 1);
    }
  };
  walk(json, 0);
  const L: Record<string, unknown>[] = list || [];
  if (!L.length && out.err == null) { out.why = '응답에 행 상태 문구(Success·Error-…)도 ERROR_COUNT 도 없음'; return out; }
  const n = cells ? cells.length : (out.total ?? L.length);
  const all = L.length === n && L.some(x => /^Success$/.test(statusOfRow(x)));
  if (all) { out.statuses = L.map(statusOfRow); out.errRows = L.map((x, i) => ({ status: statusOfRow(x), row: i })).filter(z => z.status !== 'Success'); return out; }
  const s = (v: unknown) => (v == null ? '' : String(v)).trim();
  // 2026-11-25 T638(SCP0005 V-219edc76 row_run 18:56: 'Error-Unique Duplicate' 오류 행을 대조군 0행에 짝지음 · 건수 성공 1·오류 9 = 기대와 같음):
  //   DB 중복 행은 대조군과 행 ID 칸만 다르다(행 ID 빈 값) → 값 일치 점수가 같은 후보가 둘이고 앞 행이 뽑혔다.
  //   동점 후보는 응답 EXCEL_ROW(엑셀 행 번호)와 올린 행 번호의 차이(유일하게 짝지은 행들에서 구한 값)로 고르고, 그래도 못 고르면 짝짓지 않은 행으로 남긴다(추정 금지)
  const used = new Set<number>(); const thr = (i: number) => Math.ceil((cells ? cells[i] || [] : []).length * 0.8);
  const scoreOf = (x: Record<string, unknown>, c: string[]) => { let sc = 0; c.forEach((v, k) => { if (s(x[`ATTRIBUTE${k + 1}`]) === s(v)) sc++; }); return sc; };
  const tops = L.map(x => { if (!cells) return [] as number[]; const sc = cells.map(c => scoreOf(x, c)); const bs = Math.max(-1, ...sc); return bs < 0 ? [] : sc.map((v, i) => (v === bs && v >= thr(i) ? i : -1)).filter(i => i >= 0); });
  const offs = new Map<number, number>(); L.forEach((x, k) => { const er = num(x.EXCEL_ROW); if (er != null && tops[k].length === 1) offs.set(er - tops[k][0], (offs.get(er - tops[k][0]) || 0) + 1); });
  const off = [...offs.entries()].sort((a, b) => b[1] - a[1])[0]?.[0];
  const claim = new Map<number, number>(); L.forEach((x, k) => { if (tops[k].length === 1) claim.set(tops[k][0], (claim.get(tops[k][0]) || 0) + 1); });
  for (const [i, c] of claim) if (c === 1) used.add(i);  // 두 오류 행이 같은 행을 유일 후보로 가지면 그 행은 짝짓지 않음
  const same = (a: number[]) => !!cells && a.every(i => cells[i].join('\u0001') === cells[a[0]].join('\u0001'));
  L.forEach((x, k) => {
    const st = statusOfRow(x); let row: number | null = null; const t = tops[k];
    if (t.length === 1) row = claim.get(t[0]) === 1 ? t[0] : null;
    else if (t.length > 1) {
      const er = num(x.EXCEL_ROW); let pick = er != null && off != null ? t.find(i => er - i === off && !used.has(i)) : undefined;
      if (pick == null && same(t)) pick = t.find(i => !used.has(i));  // 값이 똑같은 행끼리(파일 중복 쌍)는 어느 쪽이든 같은 기대 상태
      if (pick != null) { row = pick; used.add(pick); }
    }
    out.errRows.push({ status: st, row });
  });
  if (!cells) { out.why = `오류 행 ${L.length}건(올린 행 정보 없음)`; return out; }
  const unmatched = out.errRows.filter(z => z.row == null).length;
  if (unmatched) { out.why = `오류 행 ${L.length}건 중 ${unmatched}건을 올린 행과 값(ATTRIBUTE1..n)으로 못 짝지음`; return out; }
  if (out.err != null && out.err !== L.length) { out.why = `ERROR_COUNT ${out.err} ≠ 오류 행 목록 ${L.length}건`; return out; }
  if (out.total != null && out.total !== n) { out.why = `TOTAL_COUNT ${out.total} ≠ 올린 행 ${n}`; return out; }
  if (out.ok != null && out.ok + L.length !== n) { out.why = `SUCCESS_COUNT ${out.ok} + 오류 ${L.length} ≠ 올린 행 ${n}`; return out; }
  if (out.total == null && out.ok == null) { out.why = '건수(TOTAL_COUNT·SUCCESS_COUNT) 없음 · 성공 행 상태 확인 불가'; return out; }
  const st = cells.map(() => 'Success'); for (const z of out.errRows) st[z.row as number] = z.status; out.statuses = st; return out;
}

/** AS-IS 필수 검사 상태(from) 뒤에서 행 상태를 덮어쓸 수 있는 문구 — 'Success' 확인·다른 행(Cells[j,]) 비교 없이 상태를 바꾸는 대입. 반환 = [from, …덮어쓰는 문구] · line = ExcelUploadForm2.cs 줄 */
export function overwriteChain(cs: string, programId: string, from: string): { list: string[]; lines: string[] } {
  const ps = parseUploadKinds(cs, programId); const at = cs.search(new RegExp(`\\b(private|public|protected)\\s+\\w+\\s+${ps.fn}\\s*\\(`)); if (at < 0) return { list: [], lines: [] };
  const rest = cs.slice(at); const endRel = rest.slice(10).search(/\n\s{8}(private|public|protected)\s/); const raw = endRel < 0 ? rest : rest.slice(0, endRel + 10);
  const body = raw.replace(/\/\*[\s\S]*?\*\//g, m => m.replace(/[^\n]/g, ' ')).replace(/\/\/[^\n]*/g, m => ' '.repeat(m.length));
  const lineOf = (i: number) => cs.slice(0, at + i).split('\n').length;
  const condBefore = (pos: number): string => { const k = body.lastIndexOf('if (', pos); if (k < 0) return ''; let d = 0; for (let j = k + 3; j < body.length; j++) { if (body[j] === '(') d++; else if (body[j] === ')') { d--; if (d === 0) return body.slice(k, j + 1); } } return body.slice(k, pos); };
  const list: string[] = []; const lines: string[] = []; let on = false;
  for (const m of body.matchAll(/Cells\[i,\s*0\]\.Value\s*=\s*"(Error[^"]*)"/g)) {
    const st = m[1]; const pos = m.index || 0;
    if (!on) { if (st === from) { on = true; list.push(st); lines.push(`${st}:${lineOf(pos)}`); } continue; }
    const c = condBefore(pos); if (/"Success"/.test(c) || /Cells\[j,/.test(c) || /IndexOf\("Error"\)/.test(c)) continue;
    if (!list.includes(st)) { list.push(st); lines.push(`${st}:${lineOf(pos)}`); }
  }
  return { list, lines };
}

/** 종류별 기대 상태(AS-IS 문구) ↔ TO-BE 응답 행 상태 */
export function judgeM1(rows: M1Row[], got: string[] | null, notBuilt: string[], skipped: string[], gotWhy = ''): { result: 'PASS' | 'FAIL' | 'ERROR'; why: string } {
  const tail = `${notBuilt.length ? ` · 못 만든 종류 ${notBuilt.join(' / ')}` : ''}${skipped.length ? ` · AS-IS 주석 처리 상태(실행 안 됨 · 대상 아님) ${skipped.join(', ')}` : ''}`;
  if (!got) return { result: 'ERROR', why: `[측정 경로 없음] 업로드 응답에서 행 상태 배열 못 찾음${gotWhy ? `(${gotWhy})` : ''}${tail}` };
  if (got.length !== rows.length) return { result: 'ERROR', why: `[측정 실패] 올린 행 ${rows.length} ≠ 응답 행 상태 ${got.length}(${got.slice(0, 12).join(', ')})${tail}` };
  if (got[0] !== 'Success') return { result: 'ERROR', why: `[측정 전제 실패] 대조군(기준 행 그대로) 상태 '${got[0]}' ≠ 'Success': 기준 행이 이미 오류라 종류별 비교 불가${tail}` };
  const bad = rows.map((r, i) => ({ r, g: got[i] })).filter(z => z.r.kind !== 'control' && z.g !== z.r.status);
  const list = rows.slice(1).map((r, i) => `${r.status}(${r.how}) → '${got[i + 1]}'`).join(' · ');
  return { result: bad.length ? 'FAIL' : 'PASS', why: `${bad.length ? `AS-IS 행 상태와 다름 ${bad.length}건: ${bad.map(z => `기대 '${z.r.status}' 실제 '${z.g}'`).join(', ')} · ` : ''}대조군 Success · ${list}${tail}` };
}
