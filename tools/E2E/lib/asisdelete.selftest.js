// asisDeleteNewOnly(newrow.ts) ↔ asis_delete.py 전 화면 일치 + 변이 입증(2026-11-09 T173) · 불일치·실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path'), cp = require('child_process');
const ROOT = path.join(__dirname, '..', '..', '..');
const ts = require(path.join(ROOT, 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'newrow.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', 'require', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports, require);
const { asisDeleteNewOnly: f } = m.exports;
const A = (method, line, kind, target, guard) => ({ method, line, kind, target, guard });
const cases = [
  ['위임 + StringI guard(SSP0025)', f([A('DeleteButton', '199', 'CALL_LOCAL', 'this.Delete', 'if (fps.Name == "spdMain")'), A('Delete', '343', 'DATA_OP', 'sv.Rows.Remove', 'if (sCellText.Trim() == CAppSetting.StringI)')]).newOnly, true],
  ['직접 DeleteRow + StringI', f([A('DeleteButton', '1', 'CALL_EXT', 'siMain.DeleteRow', 'if (x == CAppSetting.StringI)')]).newOnly, true],
  ['guard 없는 Delete(D Flag)', f([A('DeleteButton', '1', 'DATA_OP', 'siMain.Delete', '')]).newOnly, false],
  ['else of FlagI 분기 삭제', f([A('DeleteButton', '1', 'DATA_OP', 'siMain.Delete', 'if (a == CAppSetting.FlagI)'), A('DeleteButton', '2', 'DATA_OP', 'siMain.Delete', 'else of (a == CAppSetting.FlagI)')]).newOnly, false],
  ['!= FlagI', f([A('DeleteButton', '1', 'DATA_OP', 'siMain.Delete', 'if (a != CAppSetting.FlagI)')]).newOnly, false],
  ['삭제 문장 없음', f([A('DeleteButton', '1', 'BRANCH', 'x', '')]).newOnly, false],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = got === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got}(기대 ${want})`); }
// 전 화면 Python 일치
const csvRows = (p) => { const t = fs.readFileSync(p, 'utf8').replace(/^﻿/, ''); const rows = []; let row = [], cur = '', q = false; for (let i = 0; i < t.length; i++) { const ch = t[i]; if (q) { if (ch === '"') { if (t[i + 1] === '"') { cur += '"'; i++; } else q = false; } else cur += ch; } else if (ch === '"') q = true; else if (ch === ',') { row.push(cur); cur = ''; } else if (ch === '\n') { row.push(cur.replace(/\r$/, '')); rows.push(row); row = []; cur = ''; } else cur += ch; } if (cur || row.length) { row.push(cur); rows.push(row); } const h = rows.shift(); return rows.filter(r => r.length > 1).map(r => Object.fromEntries(h.map((k, i) => [k, r[i] || '']))); };
const B = path.join(ROOT, 'Doc', 'asisfacts', 'screens'); const js = {};
for (const s of fs.readdirSync(B)) { const p = path.join(B, s, 'actions.csv'); if (!fs.existsSync(p)) continue; js[s] = f(csvRows(p)).newOnly; }
const py = JSON.parse(cp.execFileSync('python', ['-c', `import csv,os,json,sys; sys.path.insert(0, r'${path.join(ROOT, 'tools', 'Harness', 'verify')}'); from asis_delete import new_only; B=r'${B}'; print(json.dumps({s: new_only(list(csv.DictReader(open(os.path.join(B,s,'actions.csv'),encoding='utf-8-sig'))))[0] for s in os.listdir(B) if os.path.exists(os.path.join(B,s,'actions.csv'))}))`], { encoding: 'utf8', maxBuffer: 1 << 26 }));
const mis = Object.keys(py).filter(s => py[s] !== js[s]); console.log(`Python↔JS 전 화면 ${Object.keys(py).length} · 신규 행 전용 ${Object.values(py).filter(Boolean).length} · 불일치 ${mis.length} ${mis.slice(0, 10).join(',')}`);
if (mis.length) bad++;
console.log(`${cases.length - (bad - (mis.length ? 1 : 0))}/${cases.length}`); process.exit(bad ? 1 : 0);
