#!/usr/bin/env node
'use strict';
// check-pkg — PKG 이식 게이트: Doc/gen/<ID>/<ID>_PKG.sql (또는 --file) 에 T-SQL 잔재·미이식 TODO·ASIS 원문 블록이 남아 있으면 BLOCK
//   node check-pkg.js <ID> | --file x.sql   [--json]      exit 0/1(WARN)/2(BLOCK)
const fs = require('fs'); const path = require('path');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const cfg = JSON.parse(fs.readFileSync(opt('--config', path.join(__dirname, 'harness.json')), 'utf8').replace(/^﻿/, ''));
const ID = (a.find(x => !x.startsWith('--') && !['--file', '--config'].includes(a[a.indexOf(x) - 1])) || '').toUpperCase();
const file = opt('--file') || path.join(cfg.genOutDir, ID, `${ID}_PKG.sql`);
if (!fs.existsSync(file)) { console.error('파일 없음: ' + file); process.exit(2); }
const raw = fs.readFileSync(file, 'utf8');
// 주석/문자열 제거본으로 판정 (ASIS 블록은 별도 카운트)
const asisBlocks = (raw.match(/\/\* ===== ASIS /g) || []).length;
const code = raw.replace(/\/\*[\s\S]*?\*\//g, m => m.replace(/[^\n]/g, ' ')).replace(/--.*$/gm, '').replace(/'(?:[^']|'')*'/g, "''");
const F = []; const add = (level, c, msg, line) => F.push({ level, code: c, msg, where: line ? `${path.basename(file)}:${line}` : path.basename(file) });
const lineOf = idx => code.slice(0, idx).split('\n').length;
const rules = [
  ['P01', 'BLOCK', /\bISNULL\s*\(/gi, 'ISNULL → NVL'], ['P02', 'BLOCK', /\bGETDATE\s*\(\)/gi, 'GETDATE() → SYSDATE'], ['P03', 'BLOCK', /\bSELECT\s+TOP\s+\d+/gi, 'TOP n → FETCH FIRST n ROWS ONLY'],
  ['P04', 'BLOCK', /(^|[^\w@])#\w+/g, '임시테이블 #T → GTT/WITH'], ['P05', 'BLOCK', /@@ROWCOUNT|@@ERROR|@@IDENTITY/gi, '@@ROWCOUNT → SQL%ROWCOUNT'], ['P06', 'BLOCK', /\bWITH\s*\(\s*NOLOCK\s*\)/gi, 'NOLOCK 힌트 제거'],
  ['P07', 'BLOCK', /\bCONVERT\s*\(\s*(N?VARCHAR|DATETIME|INT)/gi, 'CONVERT → TO_CHAR/TO_DATE/TO_NUMBER'], ['P08', 'BLOCK', /\bDATEADD\s*\(|\bDATEDIFF\s*\(/gi, 'DATEADD/DATEDIFF → 날짜 산술/MONTHS_BETWEEN'], ['P09', 'BLOCK', /\bLEN\s*\(/gi, 'LEN → LENGTH'],
  ['P10', 'BLOCK', /\bIIF\s*\(/gi, 'IIF → CASE'], ['P11', 'BLOCK', /\bSET\s+NOCOUNT\b/gi, 'SET NOCOUNT 제거'], ['P12', 'BLOCK', /\bDECLARE\s+@/gi, 'DECLARE @v → IS 절 변수'], ['P13', 'BLOCK', /\bEXEC(?:UTE)?\s+(?:dbo\.)?\[?\w+\]?\s/gi, 'EXEC dbo.SP → PKG.PROC 호출'],
  ['P14', 'BLOCK', /\bSP_EXECUTESQL\b/gi, 'sp_executesql → EXECUTE IMMEDIATE'], ['P15', 'BLOCK', /\bN'/g, "N'' 접두 제거"], ['P16', 'WARN', /\bSTRING_AGG\s*\(/gi, 'STRING_AGG → LISTAGG'], ['P17', 'WARN', /\bCHARINDEX\s*\(/gi, 'CHARINDEX → INSTR(인자 순서 반대)'],
  ['P18', 'WARN', /\bSUBSTRING\s*\(/gi, 'SUBSTRING → SUBSTR'], ['P19', 'WARN', /\bCAST\s*\([^)]*\bAS\s+(N?VARCHAR|INT|DATETIME)\b/gi, 'CAST AS VARCHAR/INT/DATETIME → TO_CHAR/TO_NUMBER/TO_DATE'],
  ['P20', 'BLOCK', /TODO 이식/g, '미이식 TODO 잔존'], ['P21', 'BLOCK', /SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0/g, '빈 결과셋 스텁 잔존'],
];
for (const [c, lv, re, msg] of rules) { let m; let n = 0; const src = /TODO/.test(msg) || /스텁/.test(msg) ? raw : code; while ((m = re.exec(src)) && n < 20) { n++; add(lv, c, msg, lineOf(src === raw ? m.index : m.index)); } }
if (asisBlocks) add('BLOCK', 'P00', `ASIS 원문 블록 ${asisBlocks}개 잔존 — 이식 후 삭제`);
if (!/CREATE OR REPLACE PACKAGE BODY/i.test(raw)) add('BLOCK', 'P90', 'PACKAGE BODY 없음');
// 규약: 모든 PROCEDURE 에 O_RESULT_CURSOR, EXCEPTION WHEN OTHERS
const procs = [...raw.matchAll(/^PROCEDURE\s+(\w+)\s*\(([\s\S]*?)\)\s*IS([\s\S]*?)^END\s+\1;/gim)];
for (const p of procs) { if (!/O_RESULT_CURSOR\s+OUT/i.test(p[2])) add('BLOCK', 'P91', `${p[1]}: O_RESULT_CURSOR OUT 없음`); if (!/WHEN OTHERS/i.test(p[3])) add('BLOCK', 'P92', `${p[1]}: EXCEPTION WHEN OTHERS 없음`); if (!/RAISE_APPLICATION_ERROR\s*\(\s*-20001/i.test(p[3])) add('WARN', 'P93', `${p[1]}: RAISE_APPLICATION_ERROR(-20001 규약 아님`); }
const block = F.filter(f => f.level === 'BLOCK'), warn = F.filter(f => f.level === 'WARN');
const title = `[Harness PKG] ${ID || path.basename(file)} — BLOCK ${block.length} / WARN ${warn.length} (PROC ${procs.length})`;
if (a.includes('--json')) console.log(JSON.stringify({ id: ID, file, block: block.length, warn: warn.length, findings: F }));
else { (block.length ? console.error : console.log)([title, ...block.map(f => `  ✗ ${f.code} ${f.msg} @${f.where}`), ...warn.slice(0, 30).map(f => `  ! ${f.code} ${f.msg} @${f.where}`)].join('\n')); }
try { fs.writeFileSync(path.join(path.dirname(file), 'CHECK_PKG.md'), `# ${title}\n\n` + F.map(f => `- ${f.level} ${f.code} ${f.msg} @${f.where}`).join('\n') + '\n', 'utf8'); } catch { }
process.exit(block.length ? 2 : warn.length ? 1 : 0);
