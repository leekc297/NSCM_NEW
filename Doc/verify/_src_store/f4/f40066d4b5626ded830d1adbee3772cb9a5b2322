// 2026-11-20 T501~T505(SCP0028 T-d6ad4a4e·T-6b9a8ce8·T-0caf6c62·T-4677b9e5·V-86e7f1e2·V-a89007be·V-a99ddb18):
//   AS-IS 화면 기능 버튼(this.<btn>.Click → <btn>_Click 이 팝업을 연다) → 팝업 OK → 후속 메서드(FindInput·FindDelete) 경로의 사실과 판정.
//   사실 원천: Doc/asisfacts/screens/<ID>/actions_entries.csv(진입점 → 메서드) · actions.csv(메서드의 ENDPOINT) · props.csv(버튼 Designer Text)
//            · Doc/verify/<ID>/popup_args.csv(클릭 메서드가 여는 팝업) · tools/Harness/rules/sp_pair.csv(AS-IS SP ↔ TO-BE PROC · 종류 GET/LOG/SAVE)
//   순수 함수는 btnpopup.selftest.js 가 변이 입증한다. 화면 ID·버튼·SP 이름을 코드에 두지 않는다.
import * as fs from 'node:fs';
import * as path from 'node:path';

import { parseCsv } from './probe';

export type PathEp = { asisSp: string; tobeProc: string; kind: string; line: string };
export type PathMethod = { method: string; depth: number; guard: string; eps: PathEp[] };
export type BtnPath = { btn: string; text: string; handler: string; popup: string; methods: PathMethod[] };

const rd = (fp: string): Record<string, string>[] => { try { return parseCsv(fs.readFileSync(fp, 'utf8').replace(/^﻿/, '')); } catch { return []; } };

/** 팝업을 여는 AS-IS 기능 버튼과 그 버튼에서 닿는 메서드·엔드포인트. 팝업 인자 사실(popup_args.csv)에 클릭 메서드가 있는 버튼만 */
export function popupButtonPaths(root: string, id: string): BtnPath[] {
  const sd = path.join(root, 'Doc', 'asisfacts', 'screens', id);
  const ents = rd(path.join(sd, 'actions_entries.csv'));
  const acts = rd(path.join(sd, 'actions.csv')).filter(a => a.kind === 'ENDPOINT' && a.endpoint);
  const props = rd(path.join(sd, 'props.csv'));
  const pa = rd(path.join(root, 'Doc', 'verify', id, 'popup_args.csv')).filter(a => a.side === 'ASIS');
  const pairs = rd(path.join(root, 'tools', 'Harness', 'rules', 'sp_pair.csv')).filter(z => (z.menu_id || '').toUpperCase() === id.toUpperCase());
  return buildPaths(ents, acts, props, pa, pairs);
}

/** popupButtonPaths 의 계산부(파일 없이 selftest) */
export function buildPaths(ents: Record<string, string>[], acts: Record<string, string>[], props: Record<string, string>[], pa: Record<string, string>[], pairs: Record<string, string>[]): BtnPath[] {
  const out = new Map<string, BtnPath>();
  for (const e of ents) {
    const m = /^this\.(\w+)\.Click$/.exec(String(e.entry || '').trim()); if (!m) continue;
    const btn = m[1]; const handler = String(e.handler || '');
    const pop = pa.find(a => String(a.asis_method || '').toLowerCase() === handler.toLowerCase()); if (!pop) continue;
    const t = props.find(q => q.target === btn && q.prop === 'Text');
    const text = t ? String(t.value || '').trim().replace(/^"|"$/g, '') : '';
    let bp = out.get(btn); if (!bp) { bp = { btn, text, handler, popup: String(pop.asis_popup || ''), methods: [] }; out.set(btn, bp); }
    const meth = String(e.method || ''); if (!meth || bp.methods.some(x => x.method === meth)) continue;
    const eps = acts.filter(a => a.method === meth && /\./.test(String(a.endpoint || ''))).map(a => {
      const sp = String(a.endpoint).split('.').pop() || ''; const pr = pairs.find(z => String(z.asis_sp || '').toUpperCase() === sp.toUpperCase());
      return { asisSp: sp, tobeProc: pr ? String(pr.tobe_proc || '') : '', kind: pr ? String(pr.kind || '').toUpperCase() : '', line: String(a.line || '') };
    });
    bp.methods.push({ method: meth, depth: Number(e.depth || 0), guard: String(e.call_guard || ''), eps });
  }
  return [...out.values()];
}

/** 이 메서드에 닿는 진입점이 전부 팝업 버튼 클릭인가(조회 버튼 등 다른 진입점에서도 닿으면 그 경로 시험의 몫) */
export function onlyViaPopupButtons(ents: Record<string, string>[], paths: BtnPath[], method: string): BtnPath | null {
  const es = ents.filter(e => e.method === method); if (!es.length) return null;
  const btns = new Set(paths.map(b => b.btn));
  if (!es.every(e => { const m = /^this\.(\w+)\.Click$/.exec(String(e.entry || '').trim()); return !!m && btns.has(m[1]); })) return null;
  const b0 = (/^this\.(\w+)\.Click$/.exec(String(es[0].entry || '').trim()) || [])[1] || '';
  return paths.find(b => b.btn === b0) || null;
}

/** 경로가 서버 데이터를 바꾸는가 — 메서드 엔드포인트 중 종류가 GET·LOG 가 아닌 것이 있으면 true(종류 미상도 true · 안전한 쪽) */
export function isDestructive(m: PathMethod): boolean { return m.eps.some(e => !/^(GET|LOG)$/.test(e.kind)); }

/** 메시지 의미 분류 — 성공·오류와 동작(삭제·저장) */
export function msgIntent(t: string): { kind: 'error' | 'success' | 'other'; act: 'delete' | 'save' | '' } {
  const s = String(t || '');
  const err = /오류|에러|실패|error|fail|exception|失败|错误/i.test(s);
  const ok = /되었|하였|완료|성공|success|completed|\bdone\b|成功|已/i.test(s) || /\b(deleted|saved)\b/i.test(s);
  const act: 'delete' | 'save' | '' = /삭제|delete|删除/i.test(s) ? 'delete' : /저장|save|saving|保存/i.test(s) ? 'save' : '';
  return { kind: err ? 'error' : ok ? 'success' : 'other', act };
}

export type BJ = { result: 'PASS' | 'FAIL' | 'ERROR'; why: string };
/** 분기 메시지 판정 — expect = AS-IS·짝 TO-BE 문구 · seen = OK 뒤 화면 알림·토스트 · driven = 경로를 끝까지 구동했나 */
export function judgeMsgBranch(s: { expect: string[]; seen: string[]; driven: boolean; why: string }): BJ {
  if (!s.driven) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  const ex = s.expect.map(msgIntent).find(i => i.kind !== 'other');
  if (!ex) return { result: 'ERROR', why: `[측정 경로 없음] 기대 문구 의미 분류 불가(${s.expect.join(' / ').slice(0, 80)}) · ${s.why}` };
  const seen = s.seen.filter(Boolean);
  if (!seen.length) return { result: 'FAIL', why: `${s.why} → 화면 메시지 없음(기대 ${ex.kind === 'error' ? '오류' : '성공'} 메시지 '${s.expect[0] || ''}')` };
  const hit = seen.find(t => { const i = msgIntent(t); return i.kind === ex.kind && (!ex.act || !i.act || i.act === ex.act); });
  if (hit) return { result: 'PASS', why: `${s.why} → 화면 '${hit.slice(0, 120)}' · 기대 '${s.expect[0] || ''}' 와 같은 의미(${ex.kind === 'error' ? '오류' : '성공'}${ex.act ? ` · ${ex.act === 'delete' ? '삭제' : '저장'}` : ''})` };
  return { result: 'FAIL', why: `${s.why} → 화면 '${seen.join(' | ').slice(0, 160)}' · 기대 '${s.expect[0] || ''}'(${ex.kind === 'error' ? '오류' : '성공'}) 와 의미 다름` };
}

/** 증거 문구에 남은 '<sheet>/<btn>:200 응답={…}' 에서 응답 JSON 표본 — 같은 시트·버튼 호출의 실제 성공 응답(가짜 응답 형식의 근거) */
export function respSample(texts: string[], sheet: string, btn: string): Record<string, unknown> | null {
  const key = `${sheet}/${btn}:200 응답=`;
  for (const t of texts) {
    let i = String(t || '').indexOf(key);
    while (i >= 0) {
      const st = i + key.length; const js = balanced(t, st);
      if (js) { try { const o = JSON.parse(js); if (o && typeof o === 'object' && !Array.isArray(o)) return o as Record<string, unknown>; } catch { /* 잘린 표본 */ } }
      i = t.indexOf(key, st);
    }
  }
  return null;
}
/** T642(2026-11-25 SCP0005 MSG00043 3행 · H2 5행 'route/SAVE 실제 응답 표본 없음'): 표본 원천(이번 결과 · 원장 · .prev)은 부분 재측정(run_mode only)이
 *  .prev 를 덮으면 앞 회차의 실제 응답을 잃는다(19:41 부분 실행 .prev 표본 0건 · 22:36 결과 T-9b93a539 에 route/SAVE 표본 있음).
 *  원천에서 찾은 '<sheet>/<btn>:200 응답={…}' 를 화면 폴더 파일(시트/버튼 → 마지막 실제 응답)에 쌓고 그 파일 내용도 원천으로 돌려준다.
 *  가짜 응답 표지(E2E-FAKE) 가 든 본문은 쌓지 않는다 */
export function persistRespSamples(texts: string[], file: string): string[] {
  let store: Record<string, { body: string; at: string }> = {};
  try { store = JSON.parse(fs.readFileSync(file, 'utf8')); } catch { store = {}; }
  const re = /([^\s|/:=']+\/[^\s|/:=']+):200 응답=/g; let changed = false;
  for (const t of texts) {
    const s = String(t || ''); re.lastIndex = 0; let m: RegExpExecArray | null;
    while ((m = re.exec(s))) {
      const js = balanced(s, m.index + m[0].length); if (!js || js.includes('E2E-FAKE')) continue;
      try { const o = JSON.parse(js); if (!o || typeof o !== 'object' || Array.isArray(o)) continue; } catch { continue; }
      if (!store[m[1]] || store[m[1]].body !== js) { store[m[1]] = { body: js, at: new Date().toISOString() }; changed = true; }
    }
  }
  if (changed) { try { fs.writeFileSync(file, JSON.stringify(store, null, 1)); } catch { /* 쓰기 실패 = 이번 원천만 사용 */ } }
  return Object.entries(store).map(([k, v]) => `${k}:200 응답=${v.body}`);
}
function balanced(t: string, st: number): string {
  if (t[st] !== '{') return '';
  let d = 0; let inS = false; let esc = false;
  for (let k = st; k < t.length; k++) {
    const ch = t[k];
    if (inS) { if (esc) esc = false; else if (ch === '\\') esc = true; else if (ch === '"') inS = false; continue; }
    if (ch === '"') inS = true; else if (ch === '{') d++; else if (ch === '}') { d--; if (!d) return t.slice(st, k + 1); }
  }
  return '';
}

/** 응답 표본의 첫 결과 행에서 AS-IS 판정 값(Rows[0][0] == 리터럴)을 가진 칸 — flip=true 면 그 값을 다른 값으로 바꾼 사본(else 분기) · 없으면 null */
export function branchBody(o: Record<string, unknown>, literal: string, flip: boolean): { body: Record<string, unknown>; field: string } | null {
  const c = JSON.parse(JSON.stringify(o)) as Record<string, unknown>;
  const arrays: Record<string, unknown>[][] = [];
  const scan = (v: unknown, d: number): void => { if (d > 4 || !v || typeof v !== 'object') return; if (Array.isArray(v)) { if (v.length && v[0] && typeof v[0] === 'object' && !Array.isArray(v[0])) arrays.push(v as Record<string, unknown>[]); return; } for (const x of Object.values(v as Record<string, unknown>)) scan(x, d + 1); };
  scan(c, 0);
  for (const a of arrays) {
    const r0 = a[0]; const f = Object.keys(r0).find(k => String(r0[k]) === literal); if (!f) continue;
    if (flip) r0[f] = literal === 'F' ? 'E' : 'F';
    return { body: c, field: f };
  }
  return null;
}

/** AS-IS 가드 문장의 비교 리터럴과 분기 — 'if (… == "S")' = 성공 분기 · 'else of (… == "S")' = 그 밖 분기 */
export function guardBranch(guard: string): { literal: string; elseBranch: boolean } | null {
  const g = String(guard || ''); const segs = g.split('▸').map(x => x.trim());
  for (let i = segs.length - 1; i >= 0; i--) {
    const m = /==\s*\\?"([^"\\]+)\\?"/.exec(segs[i]); if (!m) continue;
    return { literal: m[1], elseBranch: /^else of\b/.test(segs[i]) };
  }
  return null;
}

/** .NET 이름 색(ControlColor.<Name> = Color.<Known> 또는 FromArgb) → 'rgb(r, g, b)' · 모르면 '' */
export function asisControlColor(root: string, name: string): string {
  try {
    const src = fs.readFileSync(path.join(root, 'GSCM', '01.Framework', 'GSCM.Windows.Forms', 'Class', 'ControlColor.cs'), 'utf8');
    return parseControlColor(src, name);
  } catch { return ''; }
}
export function parseControlColor(src: string, name: string): string {
  const m = new RegExp(`\\bm_${name}\\s*=\\s*Color\\.(\\w+)(?:\\(([^)]*)\\))?`).exec(src); if (!m) return '';
  if (m[1] === 'FromArgb') { const n = String(m[2] || '').split(',').map(x => Number(x.trim())); if (n.length === 3 && n.every(Number.isFinite)) return `rgb(${n[0]}, ${n[1]}, ${n[2]})`; if (n.length === 4 && n.every(Number.isFinite)) return `rgb(${n[1]}, ${n[2]}, ${n[3]})`; return ''; }
  const KN: Record<string, string> = { White: 'rgb(255, 255, 255)', Black: 'rgb(0, 0, 0)', Red: 'rgb(255, 0, 0)', Yellow: 'rgb(255, 255, 0)', Gray: 'rgb(128, 128, 128)', LightGray: 'rgb(211, 211, 211)', Silver: 'rgb(192, 192, 192)', WhiteSmoke: 'rgb(245, 245, 245)', Gainsboro: 'rgb(220, 220, 220)' };
  return KN[m[1]] || '';
}

/** 조건식에서 실행 중 상태(수정 표시) 원자와 칸 값 원자 — 'RAW(x == CAppSetting.FlagM) && COL(A)=="" && …' 만(그 밖 연산이 섞이면 null) */
export function runtimeEditAtoms(cond: string): { flag: string; cols: { col: string; val: string }[] } | null {
  const parts = String(cond || '').split('&&').map(x => x.trim()).filter(Boolean); if (!parts.length) return null;
  let flag = ''; const cols: { col: string; val: string }[] = [];
  for (const q of parts) {
    let m = /^RAW\(\s*\w+\s*==\s*CAppSetting\.Flag(\w)\s*\)$/.exec(q); if (m) { flag = m[1]; continue; }
    m = /^COL\((\w+)\)\s*==\s*"([^"]*)"$/.exec(q); if (m) { cols.push({ col: m[1], val: m[2] }); continue; }
    return null;
  }
  return flag ? { flag, cols } : null;
}
