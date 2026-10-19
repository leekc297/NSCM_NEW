'use strict';
// 값 해석기 — 문자열 리터럴/템플릿/enum 멤버/상수 식별자를 페이지 상수표로 치환. 미해결은 {?식}
const ts = require('typescript');

function lineOf(sf, pos) { return sf.getLineAndCharacterOfPosition(pos).line + 1; }

/** 페이지(또는 파일 집합)에서 문자열 상수·enum 멤버·as const 객체 멤버를 수집 → Map(이름 → 값) */
function collectConstants(sf, into, fileRel) {
  const visit = n => {
    if (ts.isVariableStatement(n)) {
      for (const d of n.declarationList.declarations) {
        const name = d.name.getText(sf);
        const init = d.initializer && stripAsConst(d.initializer);
        if (!init) continue;
        if (ts.isStringLiteralLike(init)) into.push({ scope: fileRel, kind: 'const', name, value: init.text, line: lineOf(sf, d.getStart(sf)) });
        else if (ts.isNumericLiteral(init)) into.push({ scope: fileRel, kind: 'const', name, value: init.text, line: lineOf(sf, d.getStart(sf)) });
        else if (ts.isObjectLiteralExpression(init)) {
          for (const p of init.properties) if (ts.isPropertyAssignment(p) && ts.isStringLiteralLike(stripAsConst(p.initializer)))
            into.push({ scope: fileRel, kind: 'object', name: `${name}.${p.name.getText(sf)}`, value: stripAsConst(p.initializer).text, line: lineOf(sf, p.getStart(sf)) });
        }
      }
    } else if (ts.isTypeAliasDeclaration(n) && n.type) {
      // type ActiveSheet = SHEETS.PACK | SHEETS.CELL | 'lit'  → 'ActiveSheet' = 'Pack Biz|Cell Biz' (뒤에서 enum 값으로 치환)
      const parts = ts.isUnionTypeNode(n.type) ? n.type.types : [n.type];
      const vals = parts.map(t => ts.isLiteralTypeNode(t) && ts.isStringLiteralLike(t.literal) ? t.literal.text : ts.isTypeReferenceNode(t) || ts.isTypeQueryNode(t) ? '@' + t.getText(sf).replace(/^typeof\s+/, '') : null);
      if (vals.length && vals.every(v => v != null)) into.push({ scope: fileRel, kind: 'type', name: '#' + n.name.text, value: vals.join('|'), line: lineOf(sf, n.getStart(sf)) });
    } else if (ts.isPropertySignature(n) && n.type && n.name && n.parent && ts.isInterfaceDeclaration(n.parent)) {
      // 스토어 인터페이스의 속성 타입 — 다른 파일의 state.activeSheet 를 타입으로 해석하기 위함
      into.push({ scope: fileRel, kind: 'proptype', name: '#prop:' + n.name.getText(sf), value: n.type.getText(sf).replace(/\s+/g, ''), line: lineOf(sf, n.getStart(sf)) });
    } else if (ts.isEnumDeclaration(n)) {
      const en = n.name.text; let auto = 0;
      into.push({ scope: fileRel, kind: 'enumset', name: '@' + en, value: n.members.map(m => m.initializer && ts.isStringLiteralLike(m.initializer) ? m.initializer.text : m.name.getText(sf)).join('|'), line: lineOf(sf, n.getStart(sf)) });
      for (const m of n.members) {
        let v = String(auto++);
        if (m.initializer && ts.isStringLiteralLike(m.initializer)) v = m.initializer.text;
        else if (m.initializer && ts.isNumericLiteral(m.initializer)) { v = m.initializer.text; auto = Number(v) + 1; }
        into.push({ scope: fileRel, kind: 'enum', name: `${en}.${m.name.getText(sf)}`, value: v, line: lineOf(sf, m.getStart(sf)) });
      }
    }
    ts.forEachChild(n, visit);
  };
  visit(sf);
}
function stripAsConst(e) {
  while (e && (ts.isAsExpression(e) || ts.isSatisfiesExpression?.(e) || ts.isParenthesizedExpression(e) || ts.isTypeAssertionExpression?.(e))) e = e.expression;
  return e;
}

/** 식 → 문자열. consts: Map(name→value). 결과 {value, resolved:boolean} */
function resolve(expr, sf, consts) {
  if (!expr) return { value: '', resolved: false };
  expr = stripAsConst(expr);
  if (ts.isStringLiteralLike(expr)) return { value: expr.text, resolved: true };
  if (ts.isNumericLiteral(expr)) return { value: expr.text, resolved: true };
  if (ts.isTemplateExpression(expr)) {
    let s = expr.head.text, ok = true;
    for (const span of expr.templateSpans) {
      const r = resolve(span.expression, sf, consts);
      if (r.resolved) s += r.value; else { s += '{' + span.expression.getText(sf).replace(/\s+/g, '') + '}'; ok = false; }
      s += span.literal.text;
    }
    return { value: s, resolved: ok };
  }
  const txt = expr.getText(sf).replace(/\s+/g, '');
  if (ts.isIdentifier(expr) || ts.isPropertyAccessExpression(expr)) {
    if (consts.has(txt)) return { value: expandUnion(consts.get(txt), consts), resolved: true };
    if (ts.isIdentifier(expr)) {
      const tn = typeOfVar(expr.text, sf) || consts.get('#prop:' + expr.text);
      if (tn && consts.has('#' + tn)) return { value: expandUnion(consts.get('#' + tn), consts), resolved: true };
      if (tn && consts.has('@' + tn)) return { value: consts.get('@' + tn), resolved: true };
      if (tn && consts.has(tn) && !/\|/.test(consts.get(tn))) return { value: consts.get(tn), resolved: true };
    }
    // SHEETS.MAIN 처럼 enum.member → 다른 파일 enum 도 consts 에 들어 있음. 끝 세그먼트만으로도 시도
    const tail = txt.split('.').slice(-2).join('.');
    if (consts.has(tail)) return { value: consts.get(tail), resolved: true };
    return { value: '{?' + txt + '}', resolved: false };
  }
  if (ts.isConditionalExpression(expr)) {
    const a = resolve(expr.whenTrue, sf, consts), b = resolve(expr.whenFalse, sf, consts);
    return { value: `${a.value}|${b.value}`, resolved: a.resolved && b.resolved };
  }
  if (ts.isBinaryExpression(expr) && expr.operatorToken.kind === ts.SyntaxKind.PlusToken) {
    const a = resolve(expr.left, sf, consts), b = resolve(expr.right, sf, consts);
    return { value: a.value + b.value, resolved: a.resolved && b.resolved };
  }
  if (ts.isBinaryExpression(expr) && (expr.operatorToken.kind === ts.SyntaxKind.QuestionQuestionToken || expr.operatorToken.kind === ts.SyntaxKind.BarBarToken)) {
    const a = resolve(expr.left, sf, consts), b = resolve(expr.right, sf, consts);
    return { value: `${a.value}|${b.value}`, resolved: a.resolved && b.resolved };
  }
  return { value: '{?' + txt.slice(0, 80) + '}', resolved: false };
}

/** 'A|@SHEETS.X|@SHEETS' 꼴의 union 값을 enum 값으로 전개 */
function expandUnion(v, consts, depth = 0, seen = new Set()) {
  if (v == null) return '';
  if (!/\|/.test(v) && !v.startsWith('@')) return v;
  if (depth > 6) return v;
  return [...new Set(v.split('|').map(x => {
    if (!x.startsWith('@')) return x;
    const ref = x.slice(1);
    if (seen.has(ref)) return '{?' + ref + '}';
    const s2 = new Set(seen); s2.add(ref);
    if (consts.has('#' + ref)) return expandUnion(consts.get('#' + ref), consts, depth + 1, s2);
    if (consts.has(ref) && !ref.includes('.')) return consts.get(ref);
    const tail = ref.split('.').slice(-2).join('.'); if (consts.has(tail) && !/\|/.test(consts.get(tail))) return consts.get(tail);
    if (consts.has('@' + ref)) return expandUnion(consts.get('@' + ref), consts, depth + 1, s2);
    return '{?' + ref + '}';
  }))].join('|');
}
/** 식별자의 선언 타입 이름(파일 안에서): const x: T / useState<T>(…) / 매개변수 x: T / 구조분해 [x] = useState<T> */
const _typeCache = new WeakMap();
function typeOfVar(name, sf) {
  let m = _typeCache.get(sf);
  if (!m) {
    m = new Map();
    const visit = n => {
      if (ts.isVariableDeclaration(n)) {
        const tn = n.type ? n.type.getText(sf) : (n.initializer && ts.isCallExpression(n.initializer) && n.initializer.typeArguments && n.initializer.typeArguments.length ? n.initializer.typeArguments[0].getText(sf) : null);
        if (tn) { if (ts.isIdentifier(n.name)) m.set(n.name.text, tn); else if (ts.isArrayBindingPattern(n.name) && n.name.elements[0] && ts.isBindingElement(n.name.elements[0])) m.set(n.name.elements[0].name.getText(sf), tn); }
      } else if (ts.isParameter(n) && n.type && ts.isIdentifier(n.name)) m.set(n.name.text, n.type.getText(sf));
      else if (ts.isPropertySignature(n) && n.type && n.name) m.set(n.name.getText(sf), n.type.getText(sf));
      ts.forEachChild(n, visit);
    };
    visit(sf); _typeCache.set(sf, m);
  }
  const t = m.get(name); if (!t) return null;
  return t.replace(/\s+/g, '').replace(/^SHEETS$/, 'SHEETS');
}

/** 객체 리터럴에서 속성 이름 → 식 */
function prop(obj, name) {
  if (!obj || !ts.isObjectLiteralExpression(obj)) return null;
  for (const p of obj.properties) {
    if (ts.isPropertyAssignment(p) && p.name.getText() === name) return p.initializer;
    if (ts.isShorthandPropertyAssignment(p) && p.name.text === name) return p.name;
  }
  return null;
}

/** 둘러싼 함수/컴포넌트 이름 */
function enclosingName(node, sf) {
  let n = node.parent;
  while (n) {
    if (ts.isFunctionDeclaration(n) && n.name) return n.name.text;
    if (ts.isMethodDeclaration(n)) return n.name.getText(sf);
    if ((ts.isArrowFunction(n) || ts.isFunctionExpression(n)) && n.parent) {
      const p = n.parent;
      if (ts.isVariableDeclaration(p)) return p.name.getText(sf);
      if (ts.isPropertyAssignment(p)) return p.name.getText(sf);
      if (ts.isCallExpression(p)) { // useCallback(() => ...) 등 → 바깥 변수명
        const vd = p.parent; if (vd && ts.isVariableDeclaration(vd)) return vd.name.getText(sf);
      }
    }
    n = n.parent;
  }
  return '(module)';
}

module.exports = { collectConstants, resolve, prop, enclosingName, lineOf, stripAsConst, expandUnion, typeOfVar };
