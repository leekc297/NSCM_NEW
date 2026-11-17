// sheetid — 화면 그리드가 어느 admin 시트(SHEET_NAME)인지 확정(2026-11-10 T203).
//   사용자: '각각의 시트는 어떤 시트를 사용했는지를 확인해서 검사하면 되지 않나요? 왜 비슷한 걸로 검사를 하나요?'
//   1순위 = DataGrid props 의 시트 이름(probe.gridSheets · layoutKey.sheetName/sheetName) — 넘기는 화면만 있음
//           (SSP0060·SSP0003 실측 17:0x: 그리드 시트 이름 '' — 한 상세 그리드가 FE 키 planDetail/stockDetail/owmsDetail/holdStock 로 시트 전환)
//   2순위 = TO-BE SCM_MST_SHEET_COLUMNS(Doc/tobefacts/db/sheet_columns.csv) 시트별 컬럼 정의 ↔ 그리드에 그려진 컬럼 —
//           그리드 컬럼의 90% 이상이 그 시트 정의에 속하는 시트 중 정의가 가장 작은 하나로 확정.
//   AS-IS 기대와 '비슷한지' 가 아니라 TO-BE 정의상 그 그리드가 그 시트인지를 본다. 확정 못 하면 sheet='' (호출부는 측정 실패로 둔다)
import * as fs from 'fs';
import * as path from 'path';
import type { Page } from '@playwright/test';
import { probe, parseCsv } from './probe';

const ROOT = path.join(__dirname, '..', '..', '..');
export const nSh = (t: string) => String(t || '').toLowerCase().replace(/[^a-z0-9가-힣]/g, '');
const SYS = /^(CRUD_TYPE|_SEL|ROW_STATUS|CHK|NO|ROW_NO|__.*)$/i;
// 기간 동적 컬럼(D_20261009 · X_D_20261113 · W_20261144 · M_202611 · Y_2031)은 메타 시트 정의에 없다 — 시트 판정에서 뺀다(SSP0060 메인 그리드 46% 미확정 실측)
const DYN = /^(?:[A-Z]{1,2}_){0,3}\d{4,8}$/i;

let metaCache: { id: string; sheets: Map<string, Set<string>> } | null = null;
function metaSheets(id: string): Map<string, Set<string>> {
  if (metaCache && metaCache.id === id) return metaCache.sheets;
  const m = new Map<string, Set<string>>();
  try {
    for (const r of parseCsv(fs.readFileSync(path.join(ROOT, 'Doc', 'tobefacts', 'db', 'sheet_columns.csv'), 'utf8').replace(/^﻿/, ''))) {
      if (String(r.program_id || '').toUpperCase() !== id.toUpperCase() || (r.valid_yn || 'Y') === 'N') continue;
      const s = m.get(r.sheet_name) || new Set<string>(); s.add(String(r.column_name || '').toUpperCase()); m.set(r.sheet_name, s);
    }
  } catch { /* 메타 없음 */ }
  metaCache = { id, sheets: m }; return m;
}

/** 그리드 컬럼 → 시트 확정(메타 정의). 반환 sheet='' 이면 미확정 */
export function sheetByMeta(id: string, cols: string[]): { sheet: string; why: string } {
  const g = cols.map(c => c.toUpperCase()).filter(c => !SYS.test(c) && !DYN.test(c)); if (!g.length) return { sheet: '', why: '그리드 컬럼 없음' };
  const cands: { sheet: string; cov: number; size: number }[] = [];
  for (const [sh, set] of metaSheets(id)) { const hit = g.filter(c => set.has(c)).length; cands.push({ sheet: sh, cov: hit / g.length, size: set.size }); }
  const ok = cands.filter(c => c.cov >= 0.9).sort((a, b) => a.size - b.size);
  if (!ok.length) { const top = [...cands].sort((a, b) => b.cov - a.cov)[0]; return { sheet: '', why: `메타 정의에 그리드 컬럼 90% 이상 속하는 시트 없음(최대 ${top ? `${top.sheet} ${Math.round(top.cov * 100)}%` : '메타 없음'})` }; }
  return { sheet: ok[0].sheet, why: `메타 정의 대조 — 그리드 컬럼 ${g.length}개 중 ${Math.round(ok[0].cov * 100)}% 가 '${ok[0].sheet}'(정의 ${ok[0].size}컬럼)${ok.length > 1 ? ` · 후보 ${ok.length}개 중 정의가 가장 작은 시트` : ''}` };
}

/** 보이는 그리드마다 시트 확정 */
export async function gridSheetsResolved(p: Page, id: string): Promise<{ sheet: string; cols: string[]; how: string }[]> {
  const gs = (await probe.gridSheets(p).catch(() => [])) || [];
  return gs.map(g => { if (g.sheet) return { sheet: g.sheet, cols: g.cols, how: `DataGrid props 시트 '${g.sheet}'` }; const r = sheetByMeta(id, g.cols); return { sheet: r.sheet, cols: g.cols, how: r.why }; });
}

/** 이 시트로 확정된 그리드를 프로브 대상으로 지정 — 그 그리드에만 있는 컬럼 최대 4개로 고정. 못 찾으면 ok=false */
export async function pickSheetGrid(p: Page, id: string, sheet: string): Promise<{ ok: boolean; how: string }> {
  const gs = await gridSheetsResolved(p, id);
  const g = gs.find(z => nSh(z.sheet) === nSh(sheet));
  if (!g) return { ok: false, how: `시트 '${sheet}' 그리드를 화면에서 확정 못 함 — 보이는 그리드: ${gs.map(z => z.sheet || '미확정').join(', ') || '없음'}` };
  const others = new Set(gs.filter(z => z !== g).flatMap(z => z.cols.map(c => c.toUpperCase())));
  const uniq = g.cols.filter(c => !others.has(c.toUpperCase()) && !SYS.test(c) && !DYN.test(c)).slice(0, 4);
  await probe.pickGridBySheet(p, null).catch(() => undefined);
  const ok = await probe.pickGrid(p, uniq.length ? uniq : g.cols.filter(c => !SYS.test(c)).slice(0, 4)).catch(() => false);
  return { ok, how: `${g.how}${uniq.length ? '' : ' · 고유 컬럼 없음(공통 컬럼으로 고정)'}` };
}
