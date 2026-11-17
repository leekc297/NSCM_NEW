// 저장 전후 DB 스냅샷 판정(2026-10-31 엔진 갭 E05) — 순수 함수. 변이 입증은 tools/E2E/lib/savecheck.selftest.ts
export type Snap = { tables: Record<string, { keys: string[]; pk: string[]; n: number; rows: Record<string, string | null>[] }>; skipped: Record<string, string> };
export type SaveJudge = { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; evidence: string };  // NA = T222 대상 아님
const AUDIT = /^(CREATION_DATE|CREATED_BY|LAST_UPDATE_DATE|LAST_UPDATED_BY)$/;
const isHist = (t: string) => /_H$|_HIST|HISTORY/i.test(t);
const rowKey = (r: Record<string, string | null>, pk: string[]) => (pk.length ? pk : Object.keys(r).filter(k => !AUDIT.test(k))).map(k => String(r[k] ?? '')).join('\u0001');

export type SaveDiff = { table: string; added: Record<string, string | null>[]; removed: Record<string, string | null>[]; changed: { before: Record<string, string | null>; after: Record<string, string | null> }[]; keys: string[] };
export function diffSnap(a: Snap, b: Snap): SaveDiff[] {
  const out: SaveDiff[] = [];
  for (const t of Object.keys(b.tables)) {
    const x = a.tables[t]; const y = b.tables[t]; if (!x) continue;
    const pk = y.pk; const mx = new Map(x.rows.map(r => [rowKey(r, pk), r])); const my = new Map(y.rows.map(r => [rowKey(r, pk), r]));
    const added = y.rows.filter(r => !mx.has(rowKey(r, pk))); const removed = x.rows.filter(r => !my.has(rowKey(r, pk)));
    const changed: SaveDiff['changed'] = [];
    for (const [k, r] of my) { const o = mx.get(k); if (o && JSON.stringify(o) !== JSON.stringify(r)) changed.push({ before: o, after: r }); }
    out.push({ table: t, added, removed, changed, keys: y.keys });
  }
  return out;
}

/** 수정 저장 1회의 행 수 불변 — 이력 표(_H)가 아닌 표에 새 행이 생기거나 사라지면 FAIL(같은 키 수정이 중복 행을 만든 것) · 키가 PK 일부뿐이면 다른 행 변화도 섞일 수 있어 근거에 키를 적는다 */
// 2026-11-10 T222(SSP0060 V-b07e6278 'CHG_REQ_DE 추가 1 — 수정인데 행 수가 바뀜'): T212 append 표(AS-IS 저장 SP 가 저장마다 새 키로 INSERT)는 행 증가가 AS-IS 동작 — 추가만 있으면 제외
export function judgeRowCount(d: SaveDiff[], sk: Record<string, string>, append: Map<string, string> = new Map()): SaveJudge {
  const biz = d.filter(x => !isHist(x.table));
  if (!biz.length) return { result: 'ERROR', evidence: `[측정 경로 누락] 비교 가능한 업무 표 없음 · ${JSON.stringify(sk).slice(0, 200)}` };
  const app = (t: string) => append.get(t.split('.').pop()!.toUpperCase());
  const excused = biz.filter(x => x.added.length && !x.removed.length && app(x.table));
  const bad = biz.filter(x => (x.added.length && !app(x.table)) || x.removed.length);
  const ev = biz.map(x => `${x.table}(키 ${x.keys.join(',')}): 추가 ${x.added.length} · 삭제 ${x.removed.length} · 변경 ${x.changed.length}`).join(' / ');
  if (!biz.some(x => x.changed.length || x.added.length || x.removed.length)) return { result: 'ERROR', evidence: `[측정 경로 누락] 저장했으나 비교 범위 안에 변화 없음(키 매핑 범위 밖 표에 저장했을 수 있음) · ${ev}` };
  return { result: bad.length ? 'FAIL' : 'PASS', evidence: `수정 저장 1회 DB 전후 대조 — ${ev}${bad.length ? ' — 수정인데 행 수가 바뀜(같은 키 중복 생성·삭제 의심 · 저장 SP MERGE 키 확인)' : ''}${excused.length ? ` · AS-IS 도 저장마다 새 키로 행 추가: ${excused.map(x => `${x.table}(${app(x.table)})`).join(', ')}(T222)` : ''}` };
}

/** 수정 저장 감사 컬럼 — 바뀐 행: LAST_UPDATED_BY=계정 · LAST_UPDATE_DATE 갱신 · CREATED_BY/CREATION_DATE 불변 */
export function judgeAudit(d: SaveDiff[], account: string): SaveJudge {
  const ch = d.filter(x => !isHist(x.table)).flatMap(x => x.changed.map(c => ({ t: x.table, ...c })));
  if (!ch.length) return { result: 'ERROR', evidence: '[측정 경로 누락] 변경된 행이 없어 감사 컬럼을 잴 수 없음' };
  const has = ch.filter(c => 'LAST_UPDATE_DATE' in c.after || 'CREATION_DATE' in c.after);
  if (!has.length) return { result: 'ERROR', evidence: `[측정 경로 누락] 변경 표(${[...new Set(ch.map(c => c.t))].join(',')})에 감사 컬럼 없음` };
  const bad: string[] = [];
  for (const c of has) {
    if ('CREATION_DATE' in c.after && c.after.CREATION_DATE !== c.before.CREATION_DATE) bad.push(`${c.t} CREATION_DATE 변경 ${c.before.CREATION_DATE}→${c.after.CREATION_DATE}`);
    if ('CREATED_BY' in c.after && c.after.CREATED_BY !== c.before.CREATED_BY) bad.push(`${c.t} CREATED_BY 변경 ${c.before.CREATED_BY}→${c.after.CREATED_BY}`);
    if ('LAST_UPDATE_DATE' in c.after && c.after.LAST_UPDATE_DATE === c.before.LAST_UPDATE_DATE) bad.push(`${c.t} LAST_UPDATE_DATE 미갱신`);
    if ('LAST_UPDATED_BY' in c.after && String(c.after.LAST_UPDATED_BY || '').toLowerCase() !== account.toLowerCase()) bad.push(`${c.t} LAST_UPDATED_BY='${c.after.LAST_UPDATED_BY}'(저장 계정 ${account})`);
  }
  return { result: bad.length ? 'FAIL' : 'PASS', evidence: `변경 행 ${has.length} 감사 컬럼 대조${bad.length ? ' — ' + [...new Set(bad)].slice(0, 4).join(' · ') + ' (저장 SP 수정 분기 확인)' : ': Created 불변 · Updated 갱신 · 수정자=저장 계정'}` };
}

/** 연계·이력 표 변화 사실 기록(기대값 원천이 없으면 FAIL 을 내지 않는다) — 어떤 표에 몇 행이 생겼는지 실측 */
export function linkedSummary(d: SaveDiff[], sk: Record<string, string>): string {
  const t = d.map(x => `${x.table}: +${x.added.length} -${x.removed.length} ~${x.changed.length}`).join(' / ');
  const s = Object.entries(sk).map(([k, v]) => `${k}(${v.slice(0, 40)})`).join(' / ');
  return `${t}${s ? ` · 미측정 표: ${s}` : ''}`;
}

/** EG237 저장 대상 이력 표에 행이 생기는가 — 대상 표는 저장 SP DML 에서 뽑은 cleanup_spec 이 원천. 이력 표가 없으면 판정 불가 */
// 2026-11-10 T222(SSP0060 V-112e89f2 'SSP_ANL_SHIP_CONFIRM_H +0 — 수정 저장인데 이력 행 없음'): 이번에 호출된 AS-IS 저장 SP 체인이 INSERT 하는 표(asisIns · append_tables.csv 전체 행)가
//   주어지면, 그 체인이 쓰지 않는 이력 표는 기대 대상이 아니다(AS-IS SAVE_SHIPMENT_PLAN 은 _H 에 쓰지 않음 — _H 는 REQUEST_CONFIRM SP 만)
export function judgeHistory(d: SaveDiff[], sk: Record<string, string>, asisIns?: Set<string>): SaveJudge {
  const hs0 = d.filter(x => isHist(x.table)); const tn = (t: string) => t.split('.').pop()!.toUpperCase();
  const hs = asisIns && asisIns.size ? hs0.filter(x => asisIns.has(tn(x.table))) : hs0;
  if (asisIns && asisIns.size && hs0.length && !hs.length) return { result: 'NA', evidence: `이번 저장의 AS-IS SP 체인이 이력 표(${hs0.map(x => x.table).join(',')})에 쓰지 않음 — AS-IS INSERT 대상 ${[...asisIns].slice(0, 6).join(',')}(T222) · 실측 ${linkedSummary(d, sk)}` };
  if (!hs.length) return { result: 'ERROR', evidence: `[측정 경로 없음] 저장 대상에 이력 표 없음 · 실측 ${linkedSummary(d, sk)}` };
  const none = hs.filter(x => !x.added.length);
  return { result: none.length ? 'FAIL' : 'PASS', evidence: `${hs.map(x => `${x.table} +${x.added.length}`).join(' · ')}${none.length ? ` — 수정 저장인데 이력 행 없음(${none.map(x => x.table).join(',')})` : ''} · ${linkedSummary(d, sk)}` };
}

/** EG240 이력 행 값 — 공통 컬럼이 변경 전 또는 변경 후 원장 값과 일치해야 한다(감사·이력 전용 컬럼 제외) */
export function judgeHistValues(d: SaveDiff[]): SaveJudge {
  const main = d.filter(x => !isHist(x.table)).flatMap(x => x.changed); const hs = d.filter(x => isHist(x.table) && x.added.length);
  if (!main.length || !hs.length) return { result: 'ERROR', evidence: `[측정 경로 없음] 비교할 원장 변경 ${main.length}건·이력 행 표 ${hs.length}개` };
  const skip = (k: string) => AUDIT.test(k) || /^HISTORY|^HIST_/i.test(k); const bad: string[] = []; let n = 0;
  for (const h of hs) for (const row of h.added) { n++;
    const okOf = (m: Record<string, string | null>) => Object.keys(row).filter(k => !skip(k) && k in m).every(k => String(row[k] ?? '') === String(m[k] ?? ''));
    if (!main.some(c => okOf(c.before) || okOf(c.after))) bad.push(`${h.table} ${JSON.stringify(row).slice(0, 120)}`);
  }
  return { result: bad.length ? 'FAIL' : 'PASS', evidence: `이력 행 ${n}건 ↔ 원장 변경 전후 값 대조${bad.length ? ` — 불일치 ${bad.slice(0, 2).join(' · ')}` : ' 일치'}` };
}

/** EG235 같은 행 2회 저장 — 업무 표 행 수 불변 */
// 2026-11-10 T212(SSP0060 v4 F7 허위 FAIL): append = AS-IS 저장 SP(이번에 호출된 저장의 체인)가 저장마다 새 키(NEXT VALUE FOR 등)로 INSERT 하는 표
//   (facts_append_tables.py → Doc/asisfacts/screens/<ID>/append_tables.csv) — 재저장 때 행이 느는 것이 AS-IS 동작이므로 '행 수 불변' 대상에서 뺀다(삭제가 생기면 그대로 FAIL)
export function judgeTwice(d: SaveDiff[], saves: number, append: Map<string, string> = new Map()): SaveJudge {
  if (saves < 2) return { result: 'ERROR', evidence: `[측정 경로 없음] 저장 ${saves}회` };
  const biz = d.filter(x => !isHist(x.table)); const app = (t: string) => append.get(t.split('.').pop()!.toUpperCase());
  const bad = biz.filter(x => (x.added.length && !app(x.table)) || x.removed.length); const excused = biz.filter(x => x.added.length && app(x.table) && !x.removed.length);
  return { result: bad.length ? 'FAIL' : 'PASS', evidence: `저장 ${saves}회 뒤 ${biz.map(x => `${x.table}: 추가 ${x.added.length} · 삭제 ${x.removed.length}`).join(' / ')}${bad.length ? ' — 같은 행 재저장이 행 수를 바꿈' : ''}${excused.length ? ` · AS-IS 도 저장마다 새 키로 행 추가: ${excused.map(x => `${x.table}(${app(x.table)})`).join(', ')}(T212)` : ''}` };
}

/** EG415 저장 응답 시간 — 문서 기준 3초. 부하를 빼려고 저장들 중 가장 빠른 값으로 판정 */
export function judgeSaveTime(durs: number[], limitMs = 3000): SaveJudge {
  if (!durs.length) return { result: 'ERROR', evidence: '[측정 경로 없음] 저장 요청 소요 기록 없음' };
  const best = Math.min(...durs); const ev = `저장 ${durs.length}회 소요 ${durs.join('·')}ms · 최소 ${best}ms · 기준 ${limitMs}ms`;
  return { result: best > limitMs ? 'FAIL' : 'PASS', evidence: ev };
}

/** EG210 경계값 저장 — 저장 오류 없이 값이 그대로 재조회되어야 한다. 화면 검증 차단은 판정 불가 */
export function judgeMaxValue(s: { called: boolean; err: string; ok: boolean; got: string; val: string; msg: string }): SaveJudge {
  if (!s.called) return { result: 'ERROR', evidence: `[업무 검증 차단] 경계값 '${s.val}' 저장 요청 없음 · ${s.msg.slice(0, 80)}` };
  if (s.err) return { result: 'FAIL', evidence: `경계값 '${s.val}' 저장 오류 ${s.err}` };
  return s.ok ? { result: 'PASS', evidence: `경계값 '${s.val}' 저장·재조회 '${s.got}' 일치` } : { result: 'FAIL', evidence: `경계값 '${s.val}' 저장했으나 재조회 '${s.got}' 불일치(잘림 의심)` };
}
