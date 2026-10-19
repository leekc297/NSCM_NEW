'use strict';
// TobeFacts 공통 유틸 — CSV 출력(BOM UTF-8, 전부 인용), 파일 순회, 식별자 패턴
const fs = require('fs');
const path = require('path');

class CsvOut {
  constructor(file, header) {
    fs.mkdirSync(path.dirname(file), { recursive: true });
    this.fd = fs.openSync(file, 'w');
    this.header = header; this.rows = 0;
    fs.writeSync(this.fd, '﻿' + header.map(q).join(',') + '\n');
  }
  row(obj) {
    const vals = this.header.map(h => obj[h] == null ? '' : String(obj[h]));
    fs.writeSync(this.fd, vals.map(q).join(',') + '\n'); this.rows++;
  }
  close() { fs.closeSync(this.fd); }
}
function q(s) { return '"' + String(s).replace(/"/g, '""').replace(/\r?\n/g, '\\n') + '"'; }

function walk(dir, opts, out = []) {
  if (!fs.existsSync(dir)) return out;
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) {
      if (opts.skipDirs.includes(e.name)) continue;
      walk(p, opts, out);
    } else if (opts.exts.some(x => e.name.endsWith(x))) out.push(p);
  }
  return out;
}
function rel(root, p) { return path.relative(root, p).split(path.sep).join('/'); }
function read(p) { return fs.readFileSync(p, 'utf8').replace(/^﻿/, ''); }

// As-is 식별자 패턴 — 화면ID, SP 이름, PKG, 소스 줄 참조
const RE = {
  screenId: /\b(DMF|DM|SCP|SSP|SCM|SYS|COM|SDM|PBF|PB)\d{4}(?:_\d{2})?\b/g,
  spName: /\b(?:P_|PR_|UP_|FN_|PKG_)[A-Z0-9_]{4,}\b|\b[A-Z][A-Z0-9]{1,8}\d{2,4}_(?:GET|SAVE|SET|DEL|UPD|INS|CHK|UPDATE|INSERT|DELETE|SELECT|CHECK|CREATE|PROC)_[A-Z0-9_]+\b/g,
  csLine: /\b(?:cs|L|line|줄)\s*[:#]?\s*(\d{2,5})\b/g,
  msgCode: /^(MSG|LBL|BTN|TTL|ERR|CMM)\d{3,6}$/,
  tableName: /\b(?:SCM|DM|SCP|SSP|TB|XIF|SYS|COM|SDM)_[A-Z0-9_]{3,}\b/g
};
function uniq(a) { return [...new Set(a)]; }
function matches(re, text) { re.lastIndex = 0; const r = []; let m; while ((m = re.exec(text))) r.push(m[0]); return uniq(r); }

module.exports = { CsvOut, walk, rel, read, RE, uniq, matches };

function parseCsv(text) {
  text = text.replace(/^\uFEFF/, ''); const rows = []; let row = [], f = '', qd = false;
  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    if (qd) { if (ch === '"') { if (text[i + 1] === '"') { f += '"'; i++; } else qd = false; } else f += ch; }
    else if (ch === '"') qd = true;
    else if (ch === ',') { row.push(f); f = ''; }
    else if (ch === '\n' || ch === '\r') { if (ch === '\r' && text[i + 1] === '\n') i++; row.push(f); f = ''; if (row.length > 1 || row[0] !== '') rows.push(row); row = []; }
    else f += ch;
  }
  if (f !== '' || row.length) { row.push(f); rows.push(row); }
  if (!rows.length) return [];
  const h = rows[0]; return rows.slice(1).map(r => { const o = {}; h.forEach((k, i) => o[k] = r[i] == null ? '' : r[i]); return o; });
}
function readCsv(file) { return fs.existsSync(file) ? parseCsv(fs.readFileSync(file, 'utf8')) : []; }
module.exports.readCsv = readCsv; module.exports.parseCsv = parseCsv;
