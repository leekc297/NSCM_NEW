using System.Text.Json;
using System.Text.RegularExpressions;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace AsisFacts;

/// <summary>
/// 액션 추출 (사용자 지시 2026-10-23) — flow.csv 는 "SP 에 닿는 경로" 만 남겨 핸들러 본문의 구체 동작
/// (그리드 Init/Clear, 컨트롤 값 비우기, 목록 재구성, 활성/숨김, 플래그, 메시지·중단)이 빠졌다(예: DMF0003 Division 변경 시 Clear 대상).
/// 화면 클래스 메서드의 **모든 실행 문장**을 행으로 남긴다(메서드당 1회 — actions.csv). 진입점(이벤트·버튼 override·기타 override·생성자)에서
/// 어떤 메서드에 어떤 호출 조건으로 닿는지는 actions_entries.csv(path·call_guard), 진입점별 문장 수·분류율은 actions_summary.csv.
///  - 분류 못 한 문장도 버리지 않는다(OTHER / CALL_EXT) — actions_summary.csv 의 문장 수 대비 분류 수로 누락을 드러낸다.
///  - 각 행에 조건 문맥(guard: if/else/switch case/loop/try/catch/lambda)을 붙인다(사업부 분기 보존).
///  - 주석·#if 비활성 코드는 Roslyn 이 trivia 로 두므로 대상이 아니다(실제 실행 코드만). legacy 사본 파일은 제외.
///  - 진입점에서 닿지 않는 메서드도 entry_kind=unreached 로 남긴다.
/// 분류 사전 = actions_dict.json (첫 일치). 디자이너 InitializeComponent 는 전개하지 않음(props/controls/events.csv 담당).
/// 산출: screens/&lt;ID&gt;/actions.csv · actions_entries.csv · actions_summary.csv
/// </summary>
public static class Actions
{
    sealed class Rule { public string kind { get; set; } public string name { get; set; } public string recv { get; set; } public string meaning { get; set; } public Regex N, R; }
    sealed class Dict
    {
        public List<Rule> invoke { get; set; } = new();
        public List<string> assignValueProps { get; set; } = new();
        public List<string> assignListProps { get; set; } = new();
        public List<string> assignStateProps { get; set; } = new();
        public List<string> assignGridHints { get; set; } = new();
    }
    public sealed record EpUse(string File, string Line, string Key);

    static Dict _d;
    static Dict D()
    {
        if (_d != null) return _d;
        var p = Path.Combine(AppContext.BaseDirectory, "actions_dict.json");
        _d = File.Exists(p) ? JsonSerializer.Deserialize<Dict>(File.ReadAllText(p)) : new Dict();
        foreach (var r in _d.invoke)
        {
            r.N = new Regex(r.name ?? ".*", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);
            r.R = string.IsNullOrEmpty(r.recv) ? null : new Regex(r.recv, RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);
        }
        return _d;
    }

    sealed class Meth { public BaseMethodDeclarationSyntax Decl; public string File; public string Name; }
    sealed class Cls { public string Name; public Dictionary<string, List<Meth>> Methods = new(StringComparer.Ordinal); public HashSet<string> Fields = new(StringComparer.Ordinal); }

    /// <summary>메서드 1개(오버로드 합침)의 전개 결과 — 메서드 본문은 화면당 1회만 기록(정규화). 진입점별 도달은 actions_entries.csv</summary>
    sealed class Ctx
    {
        public string Screen, Cls, Method;
        public int Stmt, Other, Ext, Rows;
        public Dictionary<string, int> ByKind = new(StringComparer.Ordinal);
        public List<(string callee, string guard, int line)> Callees = new();
    }
    const string Designer = "InitializeComponent";

    static CsvOut _w;
    static Dictionary<(string, string), List<string>> _eps;
    static Cls _cls;

    static string Short(string s, int n = 160)
    {
        s = Regex.Replace(s ?? "", @"\s+", " ").Trim();
        return s.Length > n ? s[..n] + "…" : s;
    }
    static int Line(SyntaxNode n) => n.SyntaxTree.GetLineSpan(n.Span).StartLinePosition.Line + 1;
    static string FileOf(SyntaxNode n) => n.SyntaxTree.FilePath;

    public static (int rows, int stmts, int other, int ext) Write(Config cfg, string root, string dir, string screenId, List<string> files, List<Dictionary<string, string>> events, List<EpUse> eps, HashSet<string> buttonOverrides)
    {
        var d = D();
        _eps = eps.GroupBy(e => (e.File, e.Line)).ToDictionary(g => g.Key, g => g.Select(x => x.Key).Where(k => k != "").Distinct().ToList());
        // 1) 화면 파일 파싱 → 클래스(부분 클래스 병합)별 메서드·필드
        var classes = new Dictionary<string, Cls>(StringComparer.Ordinal);
        foreach (var rel in files.Where(f => f.EndsWith(".cs", StringComparison.OrdinalIgnoreCase)))
        {
            var full = Path.Combine(root, Config.NormPath(rel));
            if (!File.Exists(full)) continue;
            var tree = CSharpSyntaxTree.ParseText(TextIO.Read(full).text, CsIndex.ParseOptions(cfg), path: rel);
            foreach (var cd in tree.GetRoot().DescendantNodes().OfType<ClassDeclarationSyntax>())
            {
                var cn = cd.Identifier.Text;
                if (!classes.TryGetValue(cn, out var c)) classes[cn] = c = new Cls { Name = cn };
                foreach (var m in cd.Members)
                {
                    if (m is FieldDeclarationSyntax fd) foreach (var v in fd.Declaration.Variables) c.Fields.Add(v.Identifier.Text);
                    else if (m is PropertyDeclarationSyntax pd) c.Fields.Add(pd.Identifier.Text);
                    else if (m is MethodDeclarationSyntax md) Add(c, md.Identifier.Text, md, rel);
                    else if (m is ConstructorDeclarationSyntax ctor) Add(c, ".ctor", ctor, rel);
                }
            }
        }
        static void Add(Cls c, string name, BaseMethodDeclarationSyntax decl, string rel)
        {
            if (!c.Methods.TryGetValue(name, out var l)) c.Methods[name] = l = new();
            l.Add(new Meth { Decl = decl, File = rel, Name = name });
        }

        int rows = 0, stmts = 0, other = 0, ext = 0;
        using var w = new CsvOut(Path.Combine(dir, "actions.csv"), "screen_id", "class", "method", "file", "line", "stmt_no", "kind", "target", "value", "endpoint", "guard", "meaning", "raw");
        using var we = new CsvOut(Path.Combine(dir, "actions_entries.csv"), "screen_id", "class", "entry_kind", "entry", "handler", "method", "depth", "path", "call_line", "call_guard");
        using var ws = new CsvOut(Path.Combine(dir, "actions_summary.csv"), "screen_id", "class", "entry_kind", "entry", "handler", "methods", "statements", "rows", "classified", "other", "call_ext", "classified_pct", "by_kind");
        _w = w;
        foreach (var c in classes.Values.Where(c => c.Methods.Count > 0).OrderBy(c => c.Name, StringComparer.Ordinal))
        {
            _cls = c;
            // 1) 메서드 본문 1회 전개(디자이너 InitializeComponent 는 props/controls/events.csv 가 담당 — 전개 안 함)
            var mx = new Dictionary<string, Ctx>(StringComparer.Ordinal);
            foreach (var name in c.Methods.Keys.Where(n => n != Designer).OrderBy(n => n, StringComparer.Ordinal))
            {
                var x = new Ctx { Screen = screenId, Cls = c.Name, Method = name };
                foreach (var m in c.Methods[name])
                {
                    if (m.Decl.Body != null) WalkStmt(x, m.Decl.Body, name, 0, "");
                    else if (m.Decl.ExpressionBody != null) Stmt(x, m.Decl.ExpressionBody.Expression, m.Decl.ExpressionBody, name, 0, "", "EXPRBODY");
                }
                mx[name] = x; rows += x.Rows; stmts += x.Stmt; other += x.Other; ext += x.Ext;
            }
            // 2) 진입점 → 도달 메서드(BFS, 경로·호출 조건 누적)
            var entries = new List<(string kind, string entry, string method)>();
            foreach (var e in events.Where(e => e.GetValueOrDefault("class") == c.Name && e.GetValueOrDefault("op") == "+=" && files.Contains(e.GetValueOrDefault("file"))))
            {
                var h = e["handler"].Split('.').Last();
                if (mx.ContainsKey(h)) entries.Add(("event", e["target"] + "." + e["event"], h));
            }
            foreach (var (name, ms) in c.Methods)
                if (name != Designer && ms.Any(m => m.Decl.Modifiers.Any(t => t.IsKind(SyntaxKind.OverrideKeyword))))
                    entries.Add((buttonOverrides.Contains(name) ? "button" : "override", name, name));
            if (mx.ContainsKey(".ctor")) entries.Add(("ctor", ".ctor", ".ctor"));
            entries = entries.Distinct().ToList();
            var reached = new HashSet<string>(StringComparer.Ordinal);
            void Entry(string kind, string entry, string start)
            {
                var seen = new HashSet<string>(StringComparer.Ordinal);
                var q = new Queue<(string m, int d, string path, int line, string guard)>();
                q.Enqueue((start, 0, start, 0, ""));
                var agg = new Ctx { Screen = screenId, Cls = c.Name, Method = start };
                while (q.Count > 0)
                {
                    var (m, d, path, line, guard) = q.Dequeue();
                    if (!mx.TryGetValue(m, out var x) || !seen.Add(m)) continue;
                    reached.Add(m);
                    we.Row(screenId, c.Name, kind, entry, start, m, d, path, line == 0 ? "" : line.ToString(), guard);
                    agg.Stmt += x.Stmt; agg.Rows += x.Rows; agg.Other += x.Other; agg.Ext += x.Ext;
                    foreach (var kv in x.ByKind) agg.ByKind[kv.Key] = agg.ByKind.GetValueOrDefault(kv.Key) + kv.Value;
                    foreach (var (callee, g, ln) in x.Callees)
                        if (!seen.Contains(callee) && mx.ContainsKey(callee)) q.Enqueue((callee, d + 1, path + " > " + callee, ln, guard == "" ? g : (g == "" ? guard : guard + " ▸ " + g)));
                }
                Sum(ws, agg, kind, entry, start, seen.Count);
            }
            foreach (var (kind, entry, method) in entries) Entry(kind, entry, method);
            foreach (var name in mx.Keys.OrderBy(n => n, StringComparer.Ordinal).ToList())
                if (!reached.Contains(name)) Entry("unreached", "(진입점 미연결)", name);
        }
        _w = null; _cls = null; _eps = null;
        return (rows, stmts, other, ext);
    }

    static void Sum(CsvOut ws, Ctx x, string kind, string entry, string handler, int methods)
    {
        int cls = x.Stmt - x.Other;
        ws.Row(x.Screen, x.Cls, kind, entry, handler, methods, x.Stmt, x.Rows, cls, x.Other, x.Ext, x.Stmt == 0 ? "" : Math.Round(100.0 * cls / x.Stmt, 1).ToString(System.Globalization.CultureInfo.InvariantCulture),
               string.Join(" ", x.ByKind.OrderByDescending(k => k.Value).Select(k => $"{k.Key}:{k.Value}")));
    }

    static string G(string guard, string add) => guard == "" ? add : guard + " ▸ " + add;

    static void WalkStmt(Ctx x, StatementSyntax st, string path, int depth, string guard)
    {
        switch (st)
        {
            case BlockSyntax b: foreach (var s in b.Statements) WalkStmt(x, s, path, depth, guard); break;
            case IfStatementSyntax i:
                {
                    var cond = Short(i.Condition.ToString(), 120);
                    Stmt(x, i.Condition, i, path, depth, guard, "IF");
                    WalkStmt(x, i.Statement, path, depth, G(guard, $"if ({cond})"));
                    if (i.Else != null) WalkStmt(x, i.Else.Statement, path, depth, G(guard, $"else of ({cond})"));
                    break;
                }
            case SwitchStatementSyntax sw:
                {
                    var ex = Short(sw.Expression.ToString(), 80);
                    Stmt(x, sw.Expression, sw, path, depth, guard, "SWITCH");
                    foreach (var sec in sw.Sections)
                    {
                        var labels = Short(string.Join(" ", sec.Labels.Select(l => l.ToString())), 100);
                        foreach (var s in sec.Statements) WalkStmt(x, s, path, depth, G(guard, $"switch ({ex}) {labels}"));
                    }
                    break;
                }
            case ForEachStatementSyntax fe: Stmt(x, fe.Expression, fe, path, depth, guard, "LOOP"); WalkStmt(x, fe.Statement, path, depth, G(guard, $"foreach ({Short(fe.Type + " " + fe.Identifier + " in " + fe.Expression, 100)})")); break;
            case ForStatementSyntax fo: Stmt(x, fo, fo, path, depth, guard, "LOOP", headerOnly: true); WalkStmt(x, fo.Statement, path, depth, G(guard, $"for ({Short(fo.Condition?.ToString() ?? "", 80)})")); break;
            case WhileStatementSyntax wh: Stmt(x, wh.Condition, wh, path, depth, guard, "LOOP"); WalkStmt(x, wh.Statement, path, depth, G(guard, $"while ({Short(wh.Condition.ToString(), 80)})")); break;
            case DoStatementSyntax dw: WalkStmt(x, dw.Statement, path, depth, G(guard, $"do-while ({Short(dw.Condition.ToString(), 80)})")); Stmt(x, dw.Condition, dw, path, depth, guard, "LOOP"); break;
            case TryStatementSyntax tr:
                WalkStmt(x, tr.Block, path, depth, G(guard, "try"));
                foreach (var cc in tr.Catches) WalkStmt(x, cc.Block, path, depth, G(guard, $"catch ({Short(cc.Declaration?.ToString() ?? "", 60)})"));
                if (tr.Finally != null) WalkStmt(x, tr.Finally.Block, path, depth, G(guard, "finally"));
                break;
            case UsingStatementSyntax us:
                if (us.Declaration != null) Stmt(x, us.Declaration, us, path, depth, guard, "USING"); else if (us.Expression != null) Stmt(x, us.Expression, us, path, depth, guard, "USING");
                WalkStmt(x, us.Statement, path, depth, guard); break;
            case LockStatementSyntax lk: WalkStmt(x, lk.Statement, path, depth, guard); break;
            case CheckedStatementSyntax ck: WalkStmt(x, ck.Block, path, depth, guard); break;
            case UnsafeStatementSyntax un: WalkStmt(x, un.Block, path, depth, guard); break;
            case FixedStatementSyntax fx: WalkStmt(x, fx.Statement, path, depth, guard); break;
            case LabeledStatementSyntax lb: WalkStmt(x, lb.Statement, path, depth, guard); break;
            case EmptyStatementSyntax: break;
            case ReturnStatementSyntax r: Stmt(x, r.Expression, r, path, depth, guard, "RETURN"); break;
            case ThrowStatementSyntax t: Stmt(x, t.Expression, t, path, depth, guard, "THROW"); break;
            case BreakStatementSyntax or ContinueStatementSyntax or GotoStatementSyntax or YieldStatementSyntax: Stmt(x, null, st, path, depth, guard, "FLOW"); break;
            case LocalDeclarationStatementSyntax ld: Stmt(x, ld.Declaration, ld, path, depth, guard, "LOCAL"); break;
            case ExpressionStatementSyntax es: Stmt(x, es.Expression, es, path, depth, guard, "EXPR"); break;
            case LocalFunctionStatementSyntax lf: Row(x, path, depth, lf, "OTHER", "local function " + lf.Identifier.Text, "", "", guard, "지역 함수 선언(호출 지점에서 전개 안 됨)"); x.Stmt++; x.Other++; break;
            default: Row(x, path, depth, st, "OTHER", "", "", "", guard, "분류 안 된 문장"); x.Stmt++; x.Other++; break;
        }
    }

    /// <summary>문장 1개 = 분모 1. 문장의 식 안(람다 제외)에서 호출·대입·생성을 문서 순서로 행으로 낸다. 람다 본문은 guard 'lambda' 로 이어서 전개.</summary>
    static void Stmt(Ctx x, SyntaxNode expr, SyntaxNode stmtNode, string path, int depth, string guard, string stmtKind, bool headerOnly = false)
    {
        x.Stmt++;
        var before = x.Rows; var lambdas = new List<AnonymousFunctionExpressionSyntax>();
        var exprRows = new List<(SyntaxNode n, string kind, string target, string value, string meaning)>();
        if (expr != null)
        {
            IEnumerable<SyntaxNode> Nodes(SyntaxNode n)
            {
                foreach (var c in n.ChildNodes())
                {
                    if (c is AnonymousFunctionExpressionSyntax af) { lambdas.Add(af); continue; }
                    if (headerOnly && c is StatementSyntax) continue;
                    yield return c;
                    foreach (var g in Nodes(c)) yield return g;
                }
            }
            var all = new List<SyntaxNode> { expr }; all.AddRange(Nodes(expr));
            foreach (var n in all.Distinct())
            {
                switch (n)
                {
                    case InvocationExpressionSyntax inv: OnInvoke(x, inv, path, depth, guard, exprRows); break;
                    case AssignmentExpressionSyntax asg: OnAssign(x, asg, path, depth, guard); break;
                    case ObjectCreationExpressionSyntax oc:
                        {
                            var t = oc.Type.ToString();
                            if (Regex.IsMatch(t, @"(Popup|Form|Dialog|Pop)\w*$")) Row(x, path, depth, oc, "POPUP", "new " + t, Short(oc.ArgumentList?.ToString() ?? ""), Ep(oc), guard, "팝업/폼 생성");
                            else if (Ep(oc) != "") Row(x, path, depth, oc, "ENDPOINT", "new " + t, Short(oc.ArgumentList?.ToString() ?? ""), Ep(oc), guard, "엔드포인트 요청 생성");
                            break;
                        }
                }
            }
        }
        // 부수효과 없는 계산(EXPR)만 있는 문장 → 1행으로 요약(버리지 않음). 다른 효과가 있으면 EXPR 행은 생략
        if (x.Rows == before && exprRows.Count > 0) { var e = exprRows[0]; Row(x, path, depth, e.n, "EXPR", e.target, e.value, "", guard, "값 계산(부수효과 없음)"); }
        if (stmtKind is "RETURN" or "THROW" or "FLOW")
            Row(x, path, depth, stmtNode, stmtKind == "RETURN" ? "RETURN" : stmtKind == "THROW" ? "THROW" : "FLOW", Short(stmtNode.ToString(), 80), "", "", guard, stmtKind == "RETURN" ? "처리 중단/반환" : stmtKind == "THROW" ? "예외 발생" : "흐름 제어");
        if (x.Rows == before)
        {
            if (stmtKind is "LOCAL") Row(x, path, depth, stmtNode, "LOCAL", Short(stmtNode.ToString(), 120), "", "", guard, "지역 변수(부수효과 없음)");
            else if (stmtKind is "IF" or "SWITCH" or "LOOP") Row(x, path, depth, stmtNode, "BRANCH", Short(expr?.ToString() ?? "", 120), "", "", guard, "분기/반복 조건(하위 행은 guard 로 연결)");
            // using(데이터 클라이언트 등 자원 열기) — 본문은 WalkStmt 가 이어서 전개
            else if (stmtKind is "USING") Row(x, path, depth, stmtNode, "RESOURCE", Short(expr?.ToString() ?? "", 120), "", Ep(stmtNode), guard, "자원 열기(using) — 본문은 이어지는 행");
            // i++ / --i : 화면 필드면 FLAG, 아니면 지역 카운터
            else if (expr is PostfixUnaryExpressionSyntax or PrefixUnaryExpressionSyntax)
            {
                var operand = (expr as PostfixUnaryExpressionSyntax)?.Operand ?? ((PrefixUnaryExpressionSyntax)expr).Operand;
                var nm = operand.ToString().Replace("this.", "");
                Row(x, path, depth, stmtNode, _cls.Fields.Contains(nm) ? "FLAG" : "LOCAL", operand.ToString(), expr.ToString(), "", guard, _cls.Fields.Contains(nm) ? "화면 필드 증감" : "지역 카운터 증감");
            }
            // LINQ 람다 식 본문(w => w.A == s.A, g => new { g.A, g.B }) — 검색 조건/선택 키
            else if (guard.EndsWith("lambda")) Row(x, path, depth, stmtNode, "EXPR", Short(stmtNode.ToString(), 120), "", "", guard, "람다 조건/선택식(LINQ 검색 조건·묶음 키)");
            else { Row(x, path, depth, stmtNode, "OTHER", "", "", "", guard, "분류 안 된 문장"); x.Other++; }
        }
        foreach (var af in lambdas)
        {
            if (af.Body is BlockSyntax lb) WalkStmt(x, lb, path, depth, G(guard, "lambda"));
            else if (af.Body is ExpressionSyntax le) Stmt(x, le, le, path, depth, G(guard, "lambda"), "EXPR");
        }
    }

    static string Ep(SyntaxNode n) => _eps != null && _eps.TryGetValue((FileOf(n), Line(n).ToString()), out var l) ? string.Join(" | ", l) : "";

    static void OnInvoke(Ctx x, InvocationExpressionSyntax inv, string path, int depth, string guard, List<(SyntaxNode, string, string, string, string)> exprRows)
    {
        string name, recv;
        switch (inv.Expression)
        {
            case MemberAccessExpressionSyntax ma: name = ma.Name.Identifier.Text; recv = ma.Expression.ToString(); break;
            case IdentifierNameSyntax id: name = id.Identifier.Text; recv = ""; break;
            case GenericNameSyntax g: name = g.Identifier.Text; recv = ""; break;
            case MemberBindingExpressionSyntax mb: name = mb.Name.Identifier.Text; recv = "?."; break;
            default: Row(x, path, depth, inv, "CALL_EXT", Short(inv.Expression.ToString(), 100), Short(inv.ArgumentList.ToString()), Ep(inv), guard, "호출(대상 식 미해석)"); x.Ext++; return;
        }
        var target = recv == "" ? name : Short(recv, 100) + "." + name;
        var args = Short(inv.ArgumentList.ToString());
        var ep = Ep(inv);
        // 화면 클래스 메서드 → 호출 관계만 기록(본문은 그 메서드 행에 1회) — 진입점별 도달·호출 조건은 actions_entries.csv
        if ((recv == "" || recv == "this" || recv == "base") && _cls.Methods.ContainsKey(name))
        {
            if (name == Designer) { Row(x, path, depth, inv, "CALL_LOCAL", target, args, ep, guard, "디자이너 초기화 — props.csv·controls.csv·events.csv 참조(본문 미전개)"); return; }
            Row(x, path, depth, inv, "CALL_LOCAL", target, args, ep, guard, "화면 메서드 호출 — 본문은 method=" + name + " 행");
            x.Callees.Add((name, guard, Line(inv)));
            return;
        }
        foreach (var r in D().invoke)
        {
            if (!r.N.IsMatch(name)) continue;
            if (r.R != null && !r.R.IsMatch(recv)) continue;
            if (r.kind == "EXPR") { exprRows.Add((inv, "EXPR", target, args, r.meaning)); return; }
            if (r.kind == "DATA_OP" && ep == "") { Row(x, path, depth, inv, "DATA_OP", target, args, "", guard, r.meaning); return; }
            Row(x, path, depth, inv, ep != "" && r.kind is "CALL_EXT" ? "ENDPOINT" : r.kind, target, args, ep, guard, r.meaning);
            return;
        }
        // 수신자 없이(또는 this/base) 부르는데 화면 클래스에 없는 메서드 = 상속받은 BaseForm 등 프레임워크 메서드
        if (ep == "" && (recv == "" || recv == "this" || recv == "base"))
        { Row(x, path, depth, inv, "CALL_BASE", target, args, "", guard, "상속(BaseForm 등) 메서드 호출 — 사전 미등록, 의미 확인 필요"); x.Ext++; return; }
        Row(x, path, depth, inv, ep != "" ? "ENDPOINT" : "CALL_EXT", target, args, ep, guard, ep != "" ? "엔드포인트 호출" : "외부/프레임워크 호출(사전 미등록 — 의미 확인 필요)");
        if (ep == "") x.Ext++;
    }

    static readonly Regex ClearVal = new(@"^\s*(""""|string\.Empty|String\.Empty|null|-1|DBNull\.Value|new\s+string\s*\[\s*0\s*\]|Array\.Empty<\w+>\(\))\s*$", RegexOptions.CultureInvariant);

    static void OnAssign(Ctx x, AssignmentExpressionSyntax a, string path, int depth, string guard)
    {
        var d = D();
        var left = Short(a.Left.ToString(), 120); var right = Short(a.Right.ToString());
        var op = a.OperatorToken.Text;
        bool clear = op == "=" && ClearVal.IsMatch(a.Right.ToString());
        string kind, meaning;
        if (op is "+=" or "-=" && (a.Right is ObjectCreationExpressionSyntax || a.Right is AnonymousFunctionExpressionSyntax || _cls.Methods.ContainsKey(a.Right.ToString().Replace("this.", ""))))
        { kind = "EVENT_WIRE"; meaning = op == "+=" ? "이벤트 연결" : "이벤트 해제"; }
        else if (d.assignGridHints.Any(h => left.Contains(h + "[") || left.Contains("." + h + ".") || left.Contains(h + ".")) && (left.Contains("Cells") || left.Contains("Sheet") || left.Contains("Columns[") || left.Contains("Rows[")))
        { kind = "GRID_SET"; meaning = "그리드 속성/값 설정"; }
        else if (a.Left is MemberAccessExpressionSyntax ma)
        {
            var prop = ma.Name.Identifier.Text; var owner = ma.Expression.ToString();
            if (d.assignValueProps.Contains(prop)) { kind = clear ? "VALUE_CLEAR" : "VALUE_SET"; meaning = clear ? "컨트롤 값 비움" : "컨트롤 값 설정"; }
            else if (d.assignListProps.Contains(prop)) { kind = clear ? "LIST_CLEAR" : "LIST_BIND"; meaning = clear ? "목록/그리드 데이터 원천 해제" : "목록/그리드 데이터 원천 연결"; }
            else if (d.assignStateProps.Contains(prop)) { kind = "STATE"; meaning = $"컨트롤 상태 {prop}"; }
            else if (owner == "this" && _cls.Fields.Contains(prop) || owner == "base") { kind = "FLAG"; meaning = "화면 필드/플래그 변경"; }
            else { kind = "UI_PROP"; meaning = $"속성 {prop} 설정"; }
        }
        else if (a.Left is IdentifierNameSyntax id)
        {
            if (_cls.Fields.Contains(id.Identifier.Text)) { kind = "FLAG"; meaning = "화면 필드/플래그 변경"; }
            else { kind = "LOCAL"; meaning = "지역 변수 대입"; }
        }
        else if (a.Left is ElementAccessExpressionSyntax) { kind = "DATA_OP"; meaning = "행/컬럼 값 대입"; }
        else { kind = "UI_PROP"; meaning = "대입"; }
        if (kind == "LOCAL" && x.Rows > 0) { Row(x, path, depth, a, kind, left, right, "", guard, meaning); return; }
        Row(x, path, depth, a, kind, left, (op == "=" ? "" : op + " ") + right, Ep(a), guard, meaning);
    }

    static void Row(Ctx x, string path, int depth, SyntaxNode n, string kind, string target, string value, string ep, string guard, string meaning)
    {
        x.Rows++;
        x.ByKind[kind] = x.ByKind.GetValueOrDefault(kind) + 1;
        _w.Row(x.Screen, x.Cls, x.Method, FileOf(n), Line(n), x.Stmt, kind, target, value, ep, guard, meaning, Short(n.ToString(), 200));
    }
}
