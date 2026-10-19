'use strict';
// To-Be BE(Spring Boot + MyBatis) Fact 추출 — 주석은 먼저 분리해 commented=1 로만 기록한다.
const path = require('path');
const { walk, rel, read, RE, matches, CsvOut } = require('./util');

const HEAD = {
  be_endpoints: ['file', 'line', 'class', 'base_path', 'http', 'path', 'full_path', 'method', 'params', 'commented'],
  be_methods: ['file', 'line', 'class', 'kind', 'method', 'calls_sql_ids', 'calls_methods', 'tables', 'procs', 'commented'],
  be_sql: ['file', 'namespace', 'sql_id', 'type', 'line', 'tables', 'procs', 'params', 'dynamic_tags', 'commented', 'sql_head'],
  be_rules: ['file', 'line', 'rule', 'evidence']
};

/** 자바 주석 분리: 코드 문자열(주석 자리 공백 유지)과 주석 목록 */
function splitJava(text) {
  let code = '', i = 0; const comments = [];
  const n = text.length;
  while (i < n) {
    const ch = text[i], nx = text[i + 1];
    if (ch === '"' || ch === '\'') { // 문자열
      let j = i + 1; while (j < n && text[j] !== ch) { if (text[j] === '\\') j++; j++; }
      code += text.slice(i, j + 1); i = j + 1; continue;
    }
    if (ch === '/' && nx === '/') { let j = text.indexOf('\n', i); if (j < 0) j = n; comments.push({ pos: i, text: text.slice(i + 2, j) }); code += ' '.repeat(j - i); i = j; continue; }
    if (ch === '/' && nx === '*') { let j = text.indexOf('*/', i + 2); if (j < 0) j = n - 2; comments.push({ pos: i, text: text.slice(i + 2, j) }); code += text.slice(i, j + 2).replace(/[^\n]/g, ' '); i = j + 2; continue; }
    code += ch; i++;
  }
  return { code, comments };
}
const lineAt = (text, pos) => text.slice(0, pos).split('\n').length;

function run(cfg, out) {
  const beRoot = cfg.beRoot;
  const w = {}; for (const k of Object.keys(HEAD)) w[k] = new CsvOut(path.join(out, k + '.csv'), HEAD[k]);
  const javas = walk(path.join(beRoot, 'src', 'main', 'java'), { exts: ['.java'], skipDirs: [] });
  const xmls = walk(path.join(beRoot, 'src', 'main', 'resources'), { exts: ['.xml'], skipDirs: [] });
  let nEp = 0, nSql = 0;
  for (const f of javas) {
    const fr = rel(beRoot, f), text = read(f), { code, comments } = splitJava(text);
    const cls = (code.match(/\b(?:class|interface)\s+([A-Za-z0-9_]+)/) || [, path.basename(f, '.java')])[1];
    const base = (code.match(/@RequestMapping\s*\(\s*(?:value\s*=\s*)?"([^"]*)"/) || [, ''])[1];
    const mapRe = /@(Get|Post|Put|Delete|Patch|Request)Mapping\s*(?:\(\s*(?:value\s*=\s*)?(?:"([^"]*)"|\{\s*"([^"]*)")?[^)]*\))?\s*(?:@[A-Za-z]+(?:\([^)]*\))?\s*)*(?:public|protected|private)?\s*[\w<>\[\],.? ]+?\s+(\w+)\s*\(([^)]*)\)/g;
    const emit = (src, commented) => {
      let m; mapRe.lastIndex = 0;
      while ((m = mapRe.exec(src))) {
        const http = m[1] === 'Request' ? ((src.slice(m.index, m.index + 300).match(/method\s*=\s*RequestMethod\.(\w+)/) || [, 'ANY'])[1]) : m[1].toUpperCase();
        const p = m[2] ?? m[3] ?? ''; if (http === 'ANY' && !p && m.index !== 0 && /^\s*@RequestMapping\s*\(\s*"/.test(src.slice(m.index))) { /* class-level */ }
        const params = matches(/@PathVariable(?:\([^)]*\))?\s+[\w<>]+\s+(\w+)/g, m[5]).map(x => x.replace(/.*\s/, ''));
        const full = ('/' + [base, p].filter(Boolean).join('/')).replace(/\/+/g, '/');
        const ln = commented ? (text.indexOf('"' + p + '"') >= 0 ? lineAt(text, text.indexOf('"' + p + '"')) : '') : lineAt(src, m.index);
        w.be_endpoints.row({ file: fr, line: ln, class: cls, base_path: base, http, path: p, full_path: full, method: m[4], params: (m[5] || '').replace(/\s+/g, ' ').slice(0, 200), commented });
        if (!commented) nEp++;
      }
    };
    emit(code, 0);
    // 주석 속 매핑(TestController 의 //@PostMapping 등) — 현행 아님
    const cmText = comments.map(c => c.text).join('\n');
    if (/@\w+Mapping/.test(cmText)) emit(cmText, 1);
    // 메서드 단위: SQL id 호출(selectList("x"), selectOne, insert, update, delete), 테이블/프로시저 문자열
    const methRe = /(?:public|protected|private)\s+(?!class|interface)[\w<>\[\],.? ]+?\s+(\w+)\s*\([^)]*\)\s*(?:throws [\w, .]+)?\s*\{/g;
    let mm; const starts = [];
    while ((mm = methRe.exec(code))) starts.push({ name: mm[1], pos: mm.index, bodyStart: mm.index + mm[0].length });
    for (let k = 0; k < starts.length; k++) {
      const s = starts[k], end = k + 1 < starts.length ? starts[k + 1].pos : code.length, body = code.slice(s.bodyStart, end);
      const sqlIds = matches(/\b(?:selectList|selectOne|select|insert|update|delete|selectMap|selectPagedList|executeProc|callProcedure)\s*\(\s*"([^"]+)"/g, body).map(x => x.replace(/.*"([^"]+)"/, '$1'));
      const calls = matches(/\b([a-z]\w+(?:Service|Mapper|Dao|Repository|Impl)?)\.(\w+)\s*\(/g, body).filter(x => !/^(this|log|logger|System|String|Map|List|Objects|Optional|Arrays|Collections|StringUtils|Math|Integer|Long)\./.test(x));
      const tables = matches(RE.tableName, body), procs = matches(RE.spName, body);
      const kind = /Controller$/.test(cls) ? 'controller' : /ServiceImpl$|Service$/.test(cls) ? 'service' : /Mapper$|Dao$/.test(cls) ? 'dao' : 'other';
      if (sqlIds.length || calls.length || tables.length || procs.length)
        w.be_methods.row({ file: fr, line: lineAt(code, s.pos), class: cls, kind, method: s.name, calls_sql_ids: sqlIds.join(' '), calls_methods: calls.slice(0, 20).join(' '), tables: tables.join(' '), procs: procs.join(' '), commented: 0 });
    }
    // 규칙 증거: 메타 테이블 체인, 권한 경로, {call ...} 조립
    for (const re of [/SCM_ADM_\w+_M\s*(?:→|->|➜)\s*[\w→ ->]+/g, /pathMatcher\.match\("[^"]+"/g, /"\{call "\)[^;]*/g, /makeProcedure\([^)]*\)/g]) {
      re.lastIndex = 0; let r; while ((r = re.exec(text))) w.be_rules.row({ file: fr, line: lineAt(text, r.index), rule: re.source.slice(0, 30), evidence: r[0].replace(/\s+/g, ' ').slice(0, 200) });
    }
  }
  for (const f of xmls) {
    const fr = rel(beRoot, f), text = read(f);
    if (!/<mapper\b/.test(text)) continue;
    const ns = (text.match(/<mapper\s+namespace="([^"]+)"/) || [, ''])[1];
    // 주석 분리
    const comments = []; const code = text.replace(/<!--([\s\S]*?)-->/g, (m0, c, off) => { comments.push({ pos: off, text: c }); return m0.replace(/[^\n]/g, ' '); });
    const stRe = /<(select|insert|update|delete|sql)\s+id="([^"]+)"[^>]*>([\s\S]*?)<\/\1>/g;
    const emit = (src, commented) => {
      let m; stRe.lastIndex = 0;
      while ((m = stRe.exec(src))) {
        const body = m[3].replace(/<!\[CDATA\[|\]\]>/g, ' ');
        const plain = body.replace(/<[^>]+>/g, ' ');
        const tables = matches(/\b(?:FROM|JOIN|INTO|UPDATE|TABLE)\s+([A-Za-z0-9_.]+)/gi, plain).map(x => x.replace(/^\w+\s+/, '')).filter(x => !/^\(|^#|^\$/.test(x));
        const procs = matches(/\{\s*call\s+([A-Za-z0-9_.]+)/gi, plain).map(x => x.replace(/.*call\s+/i, '')).concat(matches(RE.spName, plain));
        const params = matches(/[#$]\{([^}]+)\}/g, body).map(x => x.replace(/[#$]\{|\}/g, '').split(',')[0].trim());
        const tags = matches(/<(if|foreach|choose|when|otherwise|where|set|trim|bind|include)\b/g, body).map(x => x.slice(1));
        w.be_sql.row({ file: fr, namespace: ns, sql_id: m[2], type: m[1], line: lineAt(src, m.index), tables: [...new Set(tables)].join(' '), procs: [...new Set(procs)].join(' '), params: [...new Set(params)].join(' '), dynamic_tags: [...new Set(tags)].join(' '), commented, sql_head: plain.replace(/\s+/g, ' ').trim().slice(0, 200) });
        if (!commented) nSql++;
      }
    };
    emit(code, 0);
    const cm = comments.map(c => c.text).join('\n'); if (/<(select|insert|update|delete)\s+id=/.test(cm)) emit(cm, 1);
  }
  for (const k of Object.keys(w)) w[k].close();
  return { java: javas.length, xml: xmls.length, endpoints: nEp, sql: nSql };
}
module.exports = { run };
