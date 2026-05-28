/**
 * gen-procedures.ts — procedures.d.ts 자동 생성 스크립트
 *
 * 사용:
 *   pnpm gen:procedures                              # 기본 (NSCM_API_BASE 환경변수 사용)
 *   pnpm gen:procedures --api-base http://localhost:8080
 *   pnpm gen:procedures --out configs/types/procedures.d.ts
 *
 * 동작:
 *   1. GET {API_BASE}/admin/dev/procedures-metadata
 *      ← BE DevToolsController → PKG_NSCM_UI_COMM.PR_GET_PROCEDURES_METADATA
 *   2. cursor row 평탄화 응답을 (MENU_ID × SHEET × BUTTON) 그룹핑
 *   3. TypeScript declaration file 생성
 *
 * To-Be FE 위치: `nscm-fe/scripts/gen-procedures.ts`
 * package.json: `"gen:procedures": "tsx scripts/gen-procedures.ts"`
 *
 * @author Marisoft / Claude
 * @date 2026-05-13
 */
import * as fs from 'fs';
import * as path from 'path';

// ===== Types matching BE response =====
interface ProcMetadataRow {
  MNU_ID: string;        // 'DMF0099'
  MNU_DESC: string;      // 'Sales Monitor'
  SHT_NM: string;        // 'main' (or '_DEFAULT_')
  MNU_BTN_CD: string;    // 'SEARCH', 'SAVE', 'DELETE'
  API_ID: string;
  PROC_NM: string;       // 'PKG_DMF0099.P_DMF0099_GET_MAIN_DATA'
  COL_NM: string;        // 'DIVISION_ID'
  DATA_TP_CD: string;    // 'STRING' / 'NUMBER' / 'DATE' / 'CLOB' / 'CURSOR'
  COL_TP_CD: string;     // 'IN' / 'OUT' / 'NORMAL'
  SORT_ORD: number;
}

interface BaseResponse<T> {
  code: string;
  message: string;
  result: T;
}

// ===== CLI =====
function parseArgs(argv: string[]) {
  const args: Record<string, string> = {};
  for (let i = 2; i < argv.length; i++) {
    const k = argv[i];
    if (k.startsWith('--')) {
      const v = argv[i + 1] && !argv[i + 1].startsWith('--') ? argv[++i] : 'true';
      args[k.slice(2)] = v;
    }
  }
  return args;
}

const args = parseArgs(process.argv);
const API_BASE = args['api-base'] || process.env.NSCM_API_BASE || 'http://localhost:8080';
const OUT_PATH = args['out'] || path.join(process.cwd(), 'configs', 'types', 'procedures.d.ts');
const AUTH_TOKEN = process.env.NSCM_DEV_TOKEN || ''; // optional bearer for protected endpoint

// ===== DataType mapping (Oracle → TypeScript) =====
function tsType(dataTpCd: string): string {
  const t = (dataTpCd || '').toUpperCase();
  if (t === 'NUMBER' || t === 'INT' || t === 'DECIMAL') return 'number';
  if (t === 'DATE' || t === 'DATETIME' || t === 'TIMESTAMP') return 'string';  // ISO string
  if (t === 'CLOB' || t === 'BLOB') return 'string';
  if (t === 'CURSOR') return 'unknown[]';
  return 'string';
}

// ===== Group rows =====
interface ScreenMeta {
  menuId: string;
  menuDesc: string;
  sheets: Record<string, SheetMeta>;
}

interface SheetMeta {
  sheetName: string;
  buttons: Record<string, ButtonMeta>;
}

interface ButtonMeta {
  buttonCode: string;
  procName: string;
  inColumns: ColumnMeta[];
  outColumns: ColumnMeta[];
}

interface ColumnMeta {
  name: string;
  type: string;
  sortOrder: number;
}

function groupRows(rows: ProcMetadataRow[]): Record<string, ScreenMeta> {
  const screens: Record<string, ScreenMeta> = {};
  for (const r of rows) {
    if (!r.MNU_ID) continue;
    screens[r.MNU_ID] ??= { menuId: r.MNU_ID, menuDesc: r.MNU_DESC, sheets: {} };
    const sht = r.SHT_NM || '_DEFAULT_';
    screens[r.MNU_ID].sheets[sht] ??= { sheetName: sht, buttons: {} };
    const btn = r.MNU_BTN_CD || 'SEARCH';
    screens[r.MNU_ID].sheets[sht].buttons[btn] ??= {
      buttonCode: btn, procName: r.PROC_NM, inColumns: [], outColumns: [],
    };
    if (r.COL_NM) {
      const col: ColumnMeta = { name: r.COL_NM, type: tsType(r.DATA_TP_CD), sortOrder: r.SORT_ORD };
      if (r.COL_TP_CD === 'IN') {
        screens[r.MNU_ID].sheets[sht].buttons[btn].inColumns.push(col);
      } else {
        screens[r.MNU_ID].sheets[sht].buttons[btn].outColumns.push(col);
      }
    }
  }
  return screens;
}

// ===== Render procedures.d.ts =====
function renderDts(screens: Record<string, ScreenMeta>): string {
  let out = `/**
 * procedures.d.ts — 자동 생성 (gen-procedures.ts)
 *
 * ⚠ 이 파일은 자동 생성됩니다. 직접 수정하지 마세요.
 * 갱신: pnpm gen:procedures
 *
 * 생성일: ${new Date().toISOString().slice(0, 10)}
 * 소스 : ${API_BASE}/admin/dev/procedures-metadata
 *        ← SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROCEDURES_METADATA
 */

declare global {
  interface RawProcedureMap {
`;

  for (const menuId of Object.keys(screens).sort()) {
    const scr = screens[menuId];
    out += `    /** ${scr.menuDesc} */\n`;
    out += `    ${menuId}: {\n`;
    for (const sht of Object.keys(scr.sheets).sort()) {
      const sheet = scr.sheets[sht];
      out += `      ${JSON.stringify(sht)}: {\n`;
      for (const btn of Object.keys(sheet.buttons).sort()) {
        const b = sheet.buttons[btn];
        out += `        ${JSON.stringify(btn)}: {\n`;
        out += `          /** SP: ${b.procName} */\n`;
        out += `          request: {\n`;
        for (const c of b.inColumns) {
          out += `            ${c.name}?: ${c.type};\n`;
        }
        out += `          };\n`;
        out += `          response: {\n`;
        out += `            o_rc: Array<{\n`;
        for (const c of b.outColumns) {
          out += `              ${c.name}: ${c.type};\n`;
        }
        out += `            }>;\n`;
        out += `          };\n`;
        out += `        };\n`;
      }
      out += `      };\n`;
    }
    out += `    };\n`;
  }

  out += `  }\n`;
  out += `}\n\n`;
  out += `export type ProcedureMenuId = keyof RawProcedureMap;\n`;
  out += `export type ProcedureSheetName<M extends ProcedureMenuId> = keyof RawProcedureMap[M];\n`;
  out += `export type ProcedureButtonCode<M extends ProcedureMenuId, S extends ProcedureSheetName<M>> = keyof RawProcedureMap[M][S];\n`;
  out += `export {};\n`;
  return out;
}

// ===== Main =====
async function main() {
  console.log(`[gen-procedures] API_BASE = ${API_BASE}`);
  console.log(`[gen-procedures] OUT_PATH = ${OUT_PATH}`);

  const url = `${API_BASE}/admin/dev/procedures-metadata`;
  const headers: Record<string, string> = { 'Accept': 'application/json' };
  if (AUTH_TOKEN) headers['Authorization'] = `Bearer ${AUTH_TOKEN}`;

  let response: Response;
  try {
    response = await fetch(url, { headers });
  } catch (err) {
    console.error(`[gen-procedures] BE 호출 실패: ${err}`);
    process.exit(1);
  }
  if (!response.ok) {
    console.error(`[gen-procedures] HTTP ${response.status} ${response.statusText}`);
    process.exit(1);
  }

  const body = (await response.json()) as BaseResponse<ProcMetadataRow[]>;
  if (body.code !== '0') {
    console.error(`[gen-procedures] BE 응답 오류: ${body.message}`);
    process.exit(1);
  }

  const rows = body.result || [];
  console.log(`[gen-procedures] 수신: ${rows.length} 행`);

  const screens = groupRows(rows);
  const menuCount = Object.keys(screens).length;
  console.log(`[gen-procedures] 화면: ${menuCount}개`);

  const dts = renderDts(screens);
  fs.mkdirSync(path.dirname(OUT_PATH), { recursive: true });
  fs.writeFileSync(OUT_PATH, dts, 'utf-8');
  console.log(`[gen-procedures] ✅ ${OUT_PATH} (${dts.split('\n').length} 줄)`);
}

main().catch((err) => {
  console.error('[gen-procedures] 실패:', err);
  process.exit(1);
});
