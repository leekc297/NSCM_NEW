# T540~T544 _trace.spec.ts 패치(2026-11-25 SCP0005 라운드 3) — CRLF 유지, 앵커 1회 일치 확인
import sys, io
FP = r'C:\Projects\NSCM\Doc\e2e\specs\_trace.spec.ts'
src = io.open(FP, 'r', encoding='utf-8', newline='').read()
assert '\r\n' in src
t = src.replace('\r\n', '\n')

def rep(old, new, cnt=1):
    global t
    n = t.count(old)
    if n != cnt:
        print('ANCHOR COUNT', n, repr(old[:120])); sys.exit(1)
    t = t.replace(old, new)

# ---------- 공용 도우미(테스트 묶음 앞) ----------
HELP = r'''/** T541·T542(2026-11-25 SCP0005): AS-IS 화면 원문(files.csv current 의 .cs · Designer·AssemblyInfo 제외) 줄 목록 */
const ASIS_SRC = (() => { const out: { file: string; lines: string[] }[] = []; try { for (const f of parseCsv(fs.readFileSync(path.join(ROOT, 'Doc', 'asisfacts', 'screens', ID, 'files.csv'), 'utf8').replace(/^\uFEFF/, ''))) { const rel = String(f.file || ''); if (!/\.cs$/i.test(rel) || /\.Designer\.cs$|AssemblyInfo\.cs$/i.test(rel) || String(f.variant || '') !== 'current') continue; const fp = path.join(ROOT, 'GSCM', ...rel.split('\\')); if (fs.existsSync(fp)) out.push({ file: path.basename(fp), lines: fs.readFileSync(fp, 'utf8').split(/\r?\n/) }); } } catch { /* 사실 없음 = 빈 목록 */ } return out; })();
/** T541: AS-IS 원문에서 칸 값·후보를 쓰는 문장(행 값 대입 · SetValue·SetText · 콤보 설정 · Cells[..].Value/Text) 위치 — 칸 번호 변수(x = GetColumnIndex(DefColumns.칸)) 포함 */
function asisWrites(col: string): { writes: string[]; vars: string[]; files: string[] } {
  const ws: string[] = []; const allVars: string[] = []; const idxRe = new RegExp(`\\b(\\w+)\\s*=\\s*[\\w.]*GetColumnIndex\\(\\s*DefColumns\\.${escRe(col)}\\s*\\)`);
  for (const f of ASIS_SRC) {
    const vars = new Set<string>(); for (const l of f.lines) { const m = idxRe.exec(l); if (m) vars.add(m[1]); }
    allVars.push(...vars);
    const ref = `(?:DefColumns\\.${escRe(col)}\\b${[...vars].map(v => `|\\b${v}\\b`).join('')})`;
    const wr = [new RegExp(`\\[\\s*DefColumns\\.${escRe(col)}\\s*\\]\\s*=(?!=)`), new RegExp(`\\b(?:SetValue|SetText|SetCellTypeCombo\\w*|SetComboBox\\w*)\\s*\\([^;]*${ref}`), new RegExp(`Cells\\s*\\[[^\\]]*${ref}[^\\]]*\\]\\s*\\.\\s*(?:Value|Text)\\s*=(?!=)`)];
    f.lines.forEach((l, i) => { if (l.trim().startsWith('//')) return; if (wr.some(r => r.test(l))) ws.push(`${f.file}:${i + 1}`); });
  }
  return { writes: ws, vars: [...new Set(allVars)], files: ASIS_SRC.map(f => f.file) };
}
/** T542: 셀 값 변경 이벤트 메서드의 메시지 조건 'if (Parse(합계 변수) > N)' 과 합계 식(Parse(a) + Parse(b) …)의 칸(a = …[DefColumns.X]) — 원문에서 못 찾으면 null */
function asisSumGuard(meth: string, msg: string): { cols: string[]; n: number; ref: string } | null {
  for (const f of ASIS_SRC) {
    const L = f.lines;
    const ms = L.findIndex(l => new RegExp(`^\\s*(?:(?:private|public|protected|internal|static|override|virtual|async)\\s+)*[\\w<>\\[\\],.]+\\s+${escRe(meth)}\\s*\\(`).test(l) && !/;\s*$/.test(l)); if (ms < 0) continue;
    const ml = L.findIndex((l, i) => i > ms && l.includes(`"${msg}"`)); if (ml < 0) continue;
    let gv = ''; let n = 0; let gl = -1;
    for (let i = ml; i >= Math.max(ms, ml - 12); i--) { const m = /if\s*\(\s*(?:(?:Int64|Int32|Decimal|Double|long|int)\.Parse|Convert\.To\w+)\(\s*(\w+)\s*\)\s*>\s*(\d+)\s*\)/.exec(L[i]); if (m) { gv = m[1]; n = Number(m[2]); gl = i; break; } }
    if (!gv) continue;
    let terms: string[] = [];
    for (let i = gl - 1; i > ms; i--) { const m = new RegExp(`\\b${gv}\\s*=\\s*([^;]*)`).exec(L[i]); if (m && /Parse\(|Convert\.To/.test(m[1])) { terms = [...m[1].matchAll(/(?:Parse|Convert\.To\w+)\(\s*(\w+)\s*\)/g)].map(z => z[1]); break; } }
    if (!terms.length) terms = [gv];
    const cols: string[] = [];
    for (const tv of terms) for (let i = ms; i < gl; i++) { const m = new RegExp(`\\b${tv}\\s*=\\s*[^;=]*DefColumns\\.(\\w+)`).exec(L[i]); if (m) { if (!cols.includes(m[1])) cols.push(m[1]); break; } }
    if (cols.length) return { cols, n, ref: `${f.file}:${ml + 1}` };
  }
  return null;
}
/** T542: AS-IS 셀 상한(cell_rules.csv max) */
const CELLMAX = (() => { const o: Record<string, string> = {}; try { for (const z of parseCsv(fs.readFileSync(path.join(ROOT, 'Doc', 'asisfacts', 'screens', ID, 'cell_rules.csv'), 'utf8').replace(/^\uFEFF/, ''))) if (z.column && z.max && !(z.column in o)) o[z.column] = z.max; } catch { /* 사실 없음 */ } return o; })();
/** T540: AS-IS Save 진입점(SaveButton · btnSave Click)에서 닿는 메서드 */
const H2_SAVE_REACH = (() => { const s = new Set<string>(); try { for (const z of parseCsv(fs.readFileSync(path.join(ROOT, 'Doc', 'asisfacts', 'screens', ID, 'actions_entries.csv'), 'utf8').replace(/^\uFEFF/, ''))) if (/^SaveButton$|btnSave\b.*Click|^this\.btnSave/i.test(String(z.entry || '')) || /^SaveButton$/i.test(String(z.handler || ''))) s.add(String(z.method || '')); } catch { /* 사실 없음 */ } return s; })();
/** T540(2026-11-25 SCP0005 H2 V-17e451a7·V-e63ff383): 저장 검증 메서드(Save 진입점 경로)가 조건 만족 행의 규칙 칸을 오류 색(InvalidColor)으로 칠하는 규칙 — 조회 상태에는 그 색이 없다.
 *  조건을 만족하는 기존 행 하나에서 규칙·조건 밖 편집 가능 칸을 다른 값으로 바꿔 수정 표시를 만들고, 쓰기 요청을 막은 채 Save → 규칙 칸 색이 바뀌는지(오류 표시 클래스 · AS-IS 색 · Save 전과 다른 배경) 잰다.
 *  끝에 화면을 다시 열어 편집을 버린다 */
async function h2SaveMark(nscm: Nscm, cr: Record<string, string>, cols: string[], hit: number[], condCols: string[], head: string): Promise<{ result: 'PASS' | 'FAIL' | 'ERROR'; why: string }> {
  const p = nscm.page;
  const want = (asisControlColor(ROOT, cr.color_edit || '') || asisControlColor(ROOT, String(cr.color_edit || '').replace(/Invalid/, 'InValid'))).replace(/\s+/g, '');
  type CC = { b: string; cls: string; bg: string };
  const readCols = (r: number) => p.evaluate(`(async () => { const c = ${probe.CTL_SRC}; if (!c || !c.rows[${r}]) return []; const ns = ${JSON.stringify(cols.map(s => s.toUpperCase()))}; const out = []; for (let i = 0; i < c.columns.length; i++) { const k = c.columns[i]; const b = String(k.binding || ''); if (k.visible === false || !ns.includes(b.toUpperCase())) continue; c.scrollIntoView(${r}, i); await new Promise(z => requestAnimationFrame(() => requestAnimationFrame(z))); const el = c.cells.getCellElement(${r}, i); if (el) out.push({ b, cls: String(el.className || ''), bg: getComputedStyle(el).backgroundColor }); } return out; })()`).catch(() => []) as Promise<CC[]>;
  const skip = new Set([...cols, ...condCols].map(s => s.toUpperCase()));
  const binds = ((await probe.allBindings(p)) || []).filter(b => !skip.has(b.toUpperCase()) && !/^(CRUD_TYPE|CHK|ROW_?NO|_.*)$/i.test(b));
  let row = -1; let touch = ''; let from = ''; let to = '';
  for (const r of hit.slice(0, 10)) {
    const it = await probe.rowItem(p, r) as Record<string, unknown> | null; if (!it || String(it.CRUD_TYPE || '')) continue;
    for (const b of binds.slice(0, 40)) {
      if ((await probe.editable(p, r, b)) !== true) continue;
      const now = String((await probe.value(p, r, b)) ?? '');
      const alt = (((await probe.candidates(p, r, b)) || []).find(v => !!v && v.split(/\s+/)[0] !== now)) || (((await probe.columnValues(p, b)) || []).find(v => !!v && v !== now)) || '';
      if (!alt) continue; row = r; touch = b; from = now; to = alt.split(/\s+/)[0]; break;
    }
    if (row >= 0) break;
  }
  if (row < 0) return { result: 'ERROR', why: `[측정 경로 없음] ${head} · 조건 만족 기존 행(앞 10행)에 규칙·조건 밖 편집 가능 칸이 없어 수정 표시를 만들 수 없음 · AS-IS ${cr.ref} ${cr.api} ${cr.color_edit || '-'}` };
  const before = await readCols(row);
  const guard = await probe.blockWrites(p); let msgs: string[] = []; let after: CC[] = []; let crud = ''; let typed = false;
  try {
    typed = await probe.setByEditor(p, row, touch, to); await p.waitForTimeout(400);
    crud = String(((await probe.rowItem(p, row)) as Record<string, unknown> | null)?.CRUD_TYPE || '');
    if (typed && crud) { await (await nscm.toolbarButton('Save')).click({ timeout: 10_000 }).catch(() => undefined); msgs = await collectMsgs(nscm, 5_000, []); await p.waitForTimeout(800); after = await readCols(row); }
  } finally { await guard.off(); }
  const bgOf = (xs: CC[], b: string) => (xs.find(c => c.b === b)?.bg || '');
  const marked = after.filter(c => /invalid|error|danger/i.test(c.cls) || (!!want && c.bg.replace(/\s+/g, '') === want) || (bgOf(before, c.b) !== c.bg && !/wj-state-selected|wj-state-multi-selected/.test(c.cls)));
  const ev = `${head} · r${row} ${touch} '${from}'→'${to}'${typed ? '' : '(입력 실패)'} · 수정 표시 '${crud || '-'}' · 규칙 칸 색 Save 전→후 [${after.length ? after.map(c => `${c.b}:${bgOf(before, c.b) || '-'}→${c.bg || '-'}`).join(', ') : cols.join(',') + ' 못 읽음'}] · 막은 쓰기 요청 ${guard.st.n}건(서버 미전송) · 알림 '${msgs.join(' | ').slice(0, 120) || '없음'}' · AS-IS ${cr.ref} ${cr.api} ${cr.color_edit || '-'}${want ? `(${want})` : ''} = Save 검증이 문제 칸을 오류 색으로 표시`;
  await nscm.openScreen(ID).catch(() => undefined);  // 편집 버림(저장 안 함)
  if (!typed || !crud) return { result: 'ERROR', why: `[측정 전제 미충족] 수정 표시를 만들지 못함 · ${ev}` };
  if (!after.length) return { result: 'ERROR', why: `[측정 실패] Save 뒤 규칙 칸 색을 읽지 못함 · ${ev}` };
  return { result: marked.length ? 'PASS' : 'FAIL', why: `${marked.length ? `오류 표시 칸 ${marked.map(c => c.b).join(', ')}` : 'Save 뒤 규칙 칸 색 변화 없음(문제 칸 표시 미구현)'} · ${ev}` };
}

test.describe(`검증엔진 ${ID} @trace`, () => {'''
rep('test.describe(`검증엔진 ${ID} @trace`, () => {', HELP)

# ---------- T540 H2 고정 칸 표본 · Save 검증 오류 색 ----------
rep("""        const cells: { r: number; b: string; cls: string; bg: string }[] = [];
        for (const r of hit.slice(0, 4)) {""",
"""        // T540(2026-11-25 SCP0005 H2 5행): 표본을 기간 칸(dyn_columns 정규식)에서만 찾아 고정 칸 규칙(color_rules columns PRIORITY·FROM_CITY_NAME~FROM_CITY 등)이 '표본 0칸' ERROR 였다.
        //   규칙 칸이 고정(expand ≠ DYNAMIC)이면 그 칸을 잰다. 오류 색(InvalidColor)이고 메서드가 Save 진입점 경로면 조회 상태가 아닌 Save 뒤 색으로 잰다(h2SaveMark)
        const fixedCols = cr.expand === 'DYNAMIC' ? [] : String(cr.columns || '').split(';').map(s => s.trim()).filter(s => /^[A-Z][A-Z0-9_]*$/.test(s));
        if (fixedCols.length && /invalid/i.test(cr.color_edit || '') && H2_SAVE_REACH.has(cr.method || '')) { const r2 = await h2SaveMark(nscm, cr, fixedCols, hit, names, `계정 ${cur} · Div ${curDiv || '-'} · 조회 ${data.length}행 중 만족 ${hit.length}행 · 조건 ${cond.slice(0, 160)}`); put(x.row_id, r2.result, r2.why); continue; }
        const cells: { r: number; b: string; cls: string; bg: string }[] = [];
        for (const r of hit.slice(0, 4)) {""")
rep("""const re = new RegExp(${JSON.stringify(dynRe)}); const d = c.rows[${r}] && c.rows[${r}].dataItem; const out = []; for (let i = 0; i < c.columns.length && out.length < 3; i++) { const k = c.columns[i]; const b = String(k.binding || ''); if (k.visible === false || !re.test(b) || !d || d[b] == null || String(d[b]).trim() === '') continue;""",
"""const re = new RegExp(${JSON.stringify(dynRe)}); const fx = ${JSON.stringify(fixedCols.map(s => s.toUpperCase()))}; const d = c.rows[${r}] && c.rows[${r}].dataItem; const out = []; for (let i = 0; i < c.columns.length && out.length < ${fixedCols.length ? Math.min(fixedCols.length, 12) : 3}; i++) { const k = c.columns[i]; const b = String(k.binding || ''); if (k.visible === false || !d || (fx.length ? !fx.includes(b.toUpperCase()) : (!re.test(b) || d[b] == null || String(d[b]).trim() === ''))) continue;""")
rep("""        const want = (cr.color_edit || '').replace(/\\s+/g, ''); const ok = (c: { cls: string; bg: string }) =>""",
"""        const want = (asisControlColor(ROOT, cr.color_edit || '') || asisControlColor(ROOT, String(cr.color_edit || '').replace(/Invalid/, 'InValid')) || cr.color_edit || '').replace(/\\s+/g, ''); const ok = (c: { cls: string; bg: string }) =>""")
rep("""${res === 'ERROR' ? '[측정 경로 없음] 조건 만족 행에 값 있는 기간 칸 없음 · ' : ''}""",
"""${res === 'ERROR' ? (fixedCols.length ? `[측정 경로 없음] 조건 만족 행에 규칙 칸(${fixedCols.join(',')}) 셀 없음 · ` : '[측정 경로 없음] 조건 만족 행에 값 있는 기간 칸 없음 · ') : ''}""")

# ---------- T541 C3 직접 입력 · Insert 값 · 원문 쓰기 0건 ----------
rep("""      if (c.viaPopup) { put(x.row_id, '판정필요', `${tgt}: 원천 ${srcs.join('/')} 이 팝업을 여는 셀""",
"""      // T541(2026-11-25 SCP0005 C3 7행): 원천이 팝업을 여는 셀이거나 원천 해석이 비어도, 원천 칸이 키보드 입력을 받으면(AS-IS FPTextBox · 값 변경 이벤트 SetCityCode) 직접 입력 경로를 잰다.
      //   종전엔 viaPopup 을 전부 M4 로 넘기고(판정필요) 원천 없음은 '해석 불가' 로 끝났다. 원천 = 대상 칸 자체가 값 변경 이벤트 문장에 있으면 자기 칸 · AS-IS 분기 리터럴(Loc == "FROM")과 같은 토큰을 이름에 가진 원천 · 그 밖 원천 목록
      //   입력 값 = 원천 값이 있는 다른 기존 행의 값 → 기대 = 그 행의 대상 값. Insert 메서드 값 대입뿐이면 신규행 값과 리터럴 대조
      {
        const rawsJ = (c.raws || []).join(' ');
        const insLit = (c.raws || []).length && (c.raws || []).every(s => /^\\w*Insert\\w*:\\d+/i.test(s)) ? (new RegExp(`DefColumns\\\\.${escRe(tgt)}\\\\)\\\\s*,\\\\s*"([^"]*)"\\\\s*\\\\)`).exec(rawsJ) || [])[1] : undefined;
        if (insLit != null && nr) { const v = String((await probe.value(p, nr.row, tgt)) ?? ''); const okI = v === insLit || (insLit === 'Y' && /^(true|y)$/i.test(v)) || (insLit === 'N' && /^(false|n)$/i.test(v)); put(x.row_id, okI ? 'PASS' : 'FAIL', `신규행 r${nr.row} ${tgt}='${v}' ↔ AS-IS Insert 값 대입 "${insLit}"(${(c.raws || [])[0].slice(0, 110)})${okI ? ' 일치' : ' 불일치'} — 다른 칸에서 이어지는 연쇄가 아닌 Insert 기본값`); continue; }
        const selfTrig = (c.raws || []).some(s => /^\\w*(?:Changed|EditChange|Change|EditModeOff)\\w*:\\d+/.test(s) && s.includes(`DefColumns.${tgt})`));
        const lits = [...rawsJ.matchAll(/==\\s*"(\\w+)"/g)].map(m => m[1].toUpperCase());
        const byLit = srcs.filter(s => lits.some(l => s.toUpperCase().split('_').includes(l)));
        const head0 = tgt.split('_')[0];
        const cand = selfTrig ? [tgt] : byLit.length ? byLit : [...srcs].sort((a, b) => Number(b.split('_')[0] === head0) - Number(a.split('_')[0] === head0));
        if ((c.viaPopup || !srcs.length) && cand.length) {
          const tried: string[] = []; let okD = false; let anyAnchor = false;
          for (const src of cand) {
            if ((await probe.editable(p, cRow.row, src)) !== true) { tried.push(`${src} ${crNm} 편집 불가`); continue; }
            const cur = String((await probe.value(p, cRow.row, src)) ?? '');
            const anc = await p.evaluate(`(() => { const c = ${probe.CTL_SRC}; if (!c) return null; const s = ${JSON.stringify(src)}, t = ${JSON.stringify(tgt)}, me = ${cRow.row}, cur = ${JSON.stringify(cur)}; for (let r = 0; r < Math.min(c.rows.length, 3000); r++) { if (r === me) continue; const d = c.rows[r].dataItem; if (!d || d.CRUD_TYPE) continue; const sv = d[s] == null ? '' : String(d[s]).trim(); const tv = d[t] == null ? '' : String(d[t]).trim(); if (sv && tv && sv !== cur) return { r, sv, tv }; } return null; })()`).catch(() => null) as { r: number; sv: string; tv: string } | null;
            if (!anc) { tried.push(`${src}: 값 있는 다른 기존 행 없음`); continue; }
            anyAnchor = true;
            const setOk = await probe.setByEditor(p, cRow.row, src, anc.sv); await p.waitForTimeout(1_200);
            const got = String((await probe.value(p, cRow.row, tgt)) ?? '');
            const hitD = setOk && got.trim() === anc.tv;
            tried.push(`${src}='${anc.sv}'(기존 r${anc.r} 값) 입력${setOk ? '' : ' 실패'} → ${tgt}='${got}' · 기대 '${anc.tv}'(r${anc.r} 의 ${tgt}) ${hitD ? 'OK' : 'NG'}`);
            if (!nr && cur !== anc.sv) { await probe.setByEditor(p, cRow.row, src, cur).catch(() => false); await p.waitForTimeout(400); }
            if (hitD) { okD = true; break; }
          }
          if (anyAnchor) { put(x.row_id, okD ? 'PASS' : 'FAIL', `${crNm} r${cRow.row} 원천 칸 직접 입력(${selfTrig ? '자기 칸 = 값 변경 이벤트 원천' : byLit.length ? `AS-IS 분기 리터럴 ${[...new Set(lits)].join('/')} 로 고른 원천` : '원천'} ${cand.join('/')}): ${tried.join(' | ')}${okD ? '' : ' — 같은 원천 값의 기존 행과 다른 값(직접 입력 연쇄 미동작)'} · AS-IS ${(c.raws || []).slice(0, 2).map(s => s.slice(0, 90)).join(' | ')}${c.viaPopup ? ' · 팝업 선택 경로는 M4 에서 판정' : ''}`); continue; }
        }
      }
      if (c.viaPopup) { put(x.row_id, '판정필요', `${tgt}: 원천 ${srcs.join('/')} 이 팝업을 여는 셀""")

NOWR = """      // T541(2026-11-25 SCP0005 PRIORITY C2·C6): 원천도 AS-IS 문장도 없는 칸(대조표 후보만) — AS-IS 원문에 이 칸 값·후보를 쓰는 문장이 0건이면 연쇄 대상 아님(근거 = 원문 검색 결과)
      if (!src && !(c.raws || []).length) { const aw = asisWrites(tgt); if (aw.files.length && !aw.writes.length) { put(x.row_id, 'NA', `${tgt}: AS-IS 원문(${aw.files.join(', ')})에 이 칸 값·후보를 쓰는 문장 0건(행 값 대입 · SetValue·SetText · 콤보 설정 · 칸 번호 변수 ${aw.vars.join(',') || '없음'} 포함) — ${x.rule_id === 'C2' ? '후보 재구성' : '무변경 편집 연쇄'} 대상 아님 · 원장 근거 ${(x.asis_ref || '-').slice(0, 60)}`); continue; } }
"""
rep("""      if (!src) { put(x.row_id, '판정필요', `${tgt} 연쇄 원천 해석 불가 — AS-IS ${(c.raws || [])[0] || ''}`); continue; }""",
NOWR + """      if (!src) { put(x.row_id, '판정필요', `${tgt} 연쇄 원천 해석 불가 — AS-IS ${(c.raws || [])[0] || ''}`); continue; }""")
rep("""      if (!src) { put(x.row_id, '판정필요', `${tgt} 연쇄 원천 해석 불가`); continue; }""",
NOWR + """      if (!src) { put(x.row_id, '판정필요', `${tgt} 연쇄 원천 해석 불가`); continue; }""")

# W4d T300: Site 칸 없는 화면은 W4 C3 직접 입력 결과를 덮지 않는다
rep("""        // C3 값 연쇄(FROM/TO_COUNTRY · ROUTE_CNT) — From/To Site 입력 후 캐시(dtCountryCity)에서 채워지는지
""",
"""        // T541(2026-11-25 SCP0005 C3 4행 T300): 그리드에 From/To Site 칸이 없는 화면(도시 칸 직접 입력)은 이 Site 경로 전제가 없다 — W4 C3 직접 입력 판정을 'Site 후보 입력 실패' ERROR 로 덮지 않는다
        const siteGrid = ((await probe.allBindings(p)) || []).some(b => /^(FROM|TO)_SITE_CODE$/i.test(b));
        // C3 값 연쇄(FROM/TO_COUNTRY · ROUTE_CNT) — From/To Site 입력 후 캐시(dtCountryCity)에서 채워지는지
""")
rep("""          if (!need) { put(x.row_id, 'ERROR', `[전제 미충족 T300]""",
"""          if (!need && !siteGrid) continue;
          if (!need) { put(x.row_id, 'ERROR', `[전제 미충족 T300]""")

# ---------- T542 E4 셀 값 변경 경로(합계 상한) ----------
rep("""      if (!/^Save/i.test(e.meth) && !saveReach.has(e.meth)) { const pv = prevVerdict(rid);""",
"""      // T542(2026-11-25 SCP0005 E4 4행 MSG00209): 셀 값 변경 이벤트 경로(…_Changed · EditChange) 메시지는 Save 로 닿지 않아 '해당 동작 시나리오에서 판정' 으로 끝났다.
      //   AS-IS 원문에서 메시지 앞 조건 'Parse(합계 변수) > N' 과 합계 식의 칸을 읽어, 그 칸들에 셀 상한(cell_rules max) 안의 값을 차례로 넣어 합계가 N 을 넘게 하고 메시지가 뜨는지 잰다(저장 없음 · 끝에 값 원복)
      if (!/^Save/i.test(e.meth) && !saveReach.has(e.meth) && /(?:Changed|EditChange|Change|EditModeOff)$/i.test(e.meth) && e.msg) {
        const sg = asisSumGuard(e.meth, e.msg);
        if (sg) {
          const row = nrE4 ? nrE4.row : ex.row; const where = nrE4 ? '신규행' : '기존행';
          const before: Record<string, string> = {}; for (const col of sg.cols) before[col] = String((await probe.value(p, row, col)) ?? '');
          let sum = sg.cols.reduce((a, col) => a + (Number(before[col]) || 0), 0); const sum0 = sum; const typed: string[] = []; let shown: string[] = []; let last = '';
          for (const col of sg.cols) {
            if (sum > sg.n) break;
            if ((await probe.editable(p, row, col)) !== true) { typed.push(`${col} 편집 불가`); continue; }
            const v = Math.min(Number(CELLMAX[col] || '') || sg.n, sg.n);
            const okSet = await probe.setByEditor(p, row, col, String(v)); await p.waitForTimeout(400);
            const msgs = await collectMsgs(nscm, 1_500, []); const got = String((await probe.value(p, row, col)) ?? '');
            typed.push(`${col} '${before[col]}'→'${v}'${okSet ? '' : '(입력 실패)'} 값 '${got}'`);
            if (okSet) { sum += v - (Number(before[col]) || 0); last = col; }
            if (msgs.length) { shown = msgs; break; }
          }
          for (const col of sg.cols) { const now = String((await probe.value(p, row, col)) ?? ''); if (now !== before[col]) { await probe.setByEditor(p, row, col, before[col]).catch(() => false); await p.waitForTimeout(250); } }
          await nscm.clearDialogs();
          const expText = (e.text || '').replace(/\\{\\d+\\}/g, '').trim(); const txt = shown.join(' | ');
          const matched = expText ? nrm(txt).includes(nrm(expText).slice(0, 12)) : txt.includes(String(sg.n));
          const ev = `${e.msg}${e.tobe ? `→${e.tobe}` : ''} '${expText.slice(0, 40)}' · AS-IS ${sg.ref} ${e.meth}: 합계(${sg.cols.join('+')}) > ${sg.n} 이면 메시지 뒤 바꾼 칸 0 · ${where} r${row} 합계 ${sum0}→${sum} · 입력 ${typed.join(', ')} · 알림 '${txt.slice(0, 120) || '없음'}'${last ? ` · 마지막 입력 칸 ${last}` : ''}`;
          if (sum <= sg.n && !txt) put(rid, 'ERROR', `[측정 전제 미충족] 합계가 ${sg.n} 을 넘게 입력하지 못함 · ${ev}`);
          else put(rid, txt && matched ? 'PASS' : 'FAIL', `${ev}${txt ? (matched ? ' — 메시지 일치' : ` — 다른 메시지(기대 문구${expText ? '' : ` = 상한 ${sg.n} 포함`})`) : ' — 합계 초과인데 메시지 없음'}`);
          continue;
        }
      }
      if (!/^Save/i.test(e.meth) && !saveReach.has(e.meth)) { const pv = prevVerdict(rid);""")

# ---------- T543 조회조건 팝업 결과 행 대기 ----------
rep("""      const ds = dlg.getByRole('button', { name: /^(조회|Search|Find)(\\(F5\\))?$/i }).first(); if (await ds.isVisible().catch(() => false)) { await ds.click().catch(() => undefined); await p.waitForTimeout(2_500); }
      const rowsN = await dlg.locator('.wj-cells .wj-row').count().catch(() => 0);""",
"""      const ds = dlg.getByRole('button', { name: /^(조회|Search|Find)(\\(F5\\))?$/i }).first(); if (await ds.isVisible().catch(() => false)) { await ds.click().catch(() => undefined); await p.waitForTimeout(1_000); }
      // T543(2026-11-25 SCP0005 M4 3행 T-47ab9353 등 '대화상자 열림(0행) · Total89,417rows'): 팝업 조회 결과 89,417행이 2.5초 안에 그려지지 않아 0행으로 셌다 — 행이 그려지거나 0건 표시가 뜰 때까지 60초까지 기다린다
      let rowsN = 0;
      for (const t0 = Date.now(); Date.now() - t0 < 60_000;) { rowsN = await dlg.locator('.wj-cells .wj-row').count().catch(() => 0); if (rowsN > 0) break; const tx = (await dlg.innerText().catch(() => '')) || ''; if (/Total\\s*0\\s*rows|조회된 데이터가 없|No data/i.test(tx)) break; await p.waitForTimeout(500); }""")

# ---------- T544 G4 버튼 이름 잘림 · 끝 단어 버튼 · 업로드 대화상자 ----------
rep("""      const name = String((/"name":\\s*"([^"]+)"/.exec(x.condition || '') || [])[1] || '');
      let hit = pa.find(""",
"""      const name0 = String((/"name":\\s*"([^"]+)"/.exec(x.condition || '') || [])[1] || '');
      // T544(2026-11-25 SCP0005 T-eb5343b6 btnEaxel): 원장 대상 이름이 컨트롤 이름의 '_' 앞에서 잘림(btnEaxel_Upload → btnEaxel) — '<이름>_…_Click' 클릭 메서드가 하나뿐이면 그 컨트롤로 본다
      const name = (() => { const lo = name0.toLowerCase(); if (pa.some(a => (a.asis_method || '').toLowerCase() === `${lo}_click`) || BTNPOP.ps.some(b => b.btn.toLowerCase() === lo)) return name0; const ms = [...new Set([...pa.filter(a => a.side === 'ASIS').map(a => String(a.asis_method || '')), ...BTNPOP.ps.map(b => `${b.btn}_Click`)].filter(m => m.toLowerCase().startsWith(`${lo}_`) && /_click$/i.test(m)).map(m => m.replace(/_click$/i, '')))]; return ms.length === 1 ? ms[0] : name0; })();
      let hit = pa.find(""")
rep("""    if (!inside) return { loc: b, names };
  }
  return { loc: null, names };""",
"""    if (!inside) return { loc: b, names };
  }
  // T544(2026-11-25 SCP0005 btnEaxel_Upload 'Upload'): AS-IS 글자가 TO-BE 버튼 이름의 끝 단어(AS-IS 'Upload' ↔ TO-BE 'Excel Upload') — 그런 버튼이 화면에 하나뿐일 때만 같은 버튼으로 본다
  const tail = nscm.page.getByRole('button', { name: new RegExp(`(?:^|\\\\s)(?:${names.map(escRe).join('|')})$`, 'i') }); const vis: Locator[] = [];
  for (let i = 0; i < Math.min(await tail.count().catch(() => 0), 12); i++) { const b = tail.nth(i); if (!(await b.isVisible().catch(() => false))) continue; if (!(await b.evaluate(e => !!e.closest('[role="dialog"], [role="alertdialog"], .wj-flexgrid, [class*="searchArea" i], [class*="SearchArea"]')).catch(() => true))) vis.push(b); }
  if (vis.length === 1) return { loc: vis[0], names: [...names, `(끝 단어 일치) ${(await vis[0].innerText().catch(() => '')).trim()}`] };
  return { loc: null, names };""")
rep("""if (await d.locator('.wj-flexgrid, [class*="formItem"]').count().catch(() => 0)) pop = d; } }""",
"""if (await d.locator(opt.stopAtOpen ? '.wj-flexgrid, [class*="formItem"], input[type="file"]' : '.wj-flexgrid, [class*="formItem"]').count().catch(() => 0)) pop = d; } }  // T544: 열림만 볼 때는 파일 선택 칸만 있는 업로드 대화상자도 팝업""")

io.open(FP, 'w', encoding='utf-8', newline='').write(t.replace('\n', '\r\n'))
print('OK')
