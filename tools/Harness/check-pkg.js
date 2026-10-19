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
// ── P30+: 이관 Oracle 룰 (10_RULES_KEEP.md §H)
{
  const R2 = [
    ['P30', 'BLOCK', /\bNVL\s*\([^,()]+,\s*NULL\s*\)/gi, 'NVL(x, NULL) 금지 — ISNULL(x,\'\') 오변환 계보 (#127)'],
    ['P31', 'BLOCK', /\bTRUNCATE\s+TABLE\s+\w*(GTT|TMP|TEMP)\w*/gi, 'GTT TRUNCATE(DDL) 금지 → DELETE (#107)'],
    ['P32', 'WARN', /\bTO_DATE\s*\(\s*[\w.:]+\s*\)/gi, '단일 인자 TO_DATE 금지 — 마스크 명시 (#109 NLS 암묵변환)'],
    ['P33', 'WARN', /\bTO_CHAR\s*\(\s*(SYSDATE|\w*_DT|\w*_DATE|\w*DTM)\s*\)/gi, 'DATE TO_CHAR 무마스크 금지 (#109)'],
    ['P34', 'WARN', /\bSUBSTR\s*\(\s*[^,]+,\s*0\s*,/gi, 'SUBSTR(s,0,n) — MSSQL 0 인덱스 잔재 audit (#61)'],
    ['P35', 'WARN', /\/\*\+\s*(INDEX|FULL|LEADING|USE_NL|USE_HASH)/gi, '힌트 우선 금지 — ①함수 제거 ②인덱스 구문 ③힌트 순서 (#129)'],
    ['P36', 'WARN', /\bUTL_CALL_STACK\.SUBPROGRAM\s*\(\s*1\s*\)\s*\(\s*([2-9])\s*\)/gi, 'UTL_CALL_STACK.SUBPROGRAM(1)(N) — .COUNT>=N 안전체크 동반 (#62)'],
    ['P37', 'WARN', /\bREGEXP_(SUBSTR|REPLACE|LIKE)\s*\(/gi, 'REGEXP 함수 — 성능 안티패턴 후보(문자열 분해는 GTT 사전적재) (#31/#110)'],
    ['P38', 'WARN', /WHEN\s+OTHERS\s+THEN\s+NULL\s*;/gi, 'WHEN OTHERS THEN NULL — 예외 삼킴 금지, 전파 (#137)'],
  ];
  for (const [c, lv, re, msg] of R2) { let m; let n = 0; while ((m = re.exec(code)) && n < 20) { n++; add(lv, c, msg, lineOf(m.index)); } }
}
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
