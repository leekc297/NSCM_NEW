using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.Text;
using System.Text.RegularExpressions;

namespace AsisFacts;

public sealed class FileFacts
{
    public List<Site> Sites = new();
    public List<CallRec> Calls = new();
    public List<MemberRec> Members = new();
    public List<EventRec> Events = new();
    public List<ControlRec> Controls = new();
    public List<PropRec> Props = new();
    public List<MetaRead> MetaReads = new();
    public List<LiteralRec> Literals = new();
    public List<TriviaRec> Trivia = new();
    public Dictionary<string, string> ControlParent = new(StringComparer.Ordinal);
    public List<GridCall> GridCalls = new();
    public int ParseErrors;
    public string FirstError = "";
}

/// <summary>
/// 2차 패스: 파일 단위 사실 추출.
/// 주석·비활성(#if) 판정은 Roslyn 트리비아로만 한다. 주석 안 코드는 같은 파서로 다시 파싱해 Commented=true 로 기록한다.
/// </summary>
public sealed class CsExtractor
{
    readonly Config _cfg;
    readonly CsIndex _ix;
    readonly Resolver _rv;
    static long _seq;
    bool _frag; // 주석/비활성 조각 처리 중: sink 사이트만 기록
    static readonly Regex LiteralLike = new(@"^[A-Za-z_][A-Za-z0-9_\.\\#\-]{3,}$", RegexOptions.CultureInvariant);

    readonly List<Regex> _gridApi;
    public CsExtractor(Config cfg, CsIndex ix) { _cfg = cfg; _ix = ix; _rv = new Resolver(ix); _gridApi = cfg.gridApiPatterns.Select(p => new Regex(p, RegexOptions.CultureInvariant)).ToList(); }

    /// <summary>조건식 안의 상수(필드/지역 상수)를 리터럴로 치환해 평가 가능하게 만든다. division/sheet 변수 자체는 그대로 둔다.</summary>
    string Simplify(ExpressionSyntax e)
    {
        try
        {
            var repl = new Dictionary<SyntaxNode, SyntaxNode>();
            foreach (var x in e.DescendantNodesAndSelf().Where(x => x is MemberAccessExpressionSyntax || x is IdentifierNameSyntax))
            {
                if (x.Parent is MemberAccessExpressionSyntax pm && pm.Expression == x) continue;   // 수신자 부분은 건너뜀
                if (x.Parent is InvocationExpressionSyntax) continue;                                // 메서드 이름
                var t = x.ToString();
                if (t.Contains("div", StringComparison.OrdinalIgnoreCase) || t.Contains("SheetName", StringComparison.OrdinalIgnoreCase)) continue;
                if (repl.Keys.Any(k => k.Contains(x))) continue;
                var v = _rv.Resolve((ExpressionSyntax)x);
                if (v.Count == 1 && Val.IsLiteral(v[0]) && v[0].Length > 0)
                    repl[x] = SyntaxFactory.LiteralExpression(SyntaxKind.StringLiteralExpression, SyntaxFactory.Literal(v[0]));
            }
            return repl.Count == 0 ? e.ToString() : e.ReplaceNodes(repl.Keys, (o, _) => repl[o]).ToString();
        }
        catch { return e.ToString(); }
    }

    /// <summary>노드를 감싸는 분기 조건 (if / else / switch case / 반복문) — division별 하드코딩 분기 추적용</summary>
    string Conditions(SyntaxNode n)
    {
        var parts = new List<string>();
        SyntaxNode child = n;
        foreach (var a in n.Ancestors())
        {
            if (a is BaseMethodDeclarationSyntax || a is AccessorDeclarationSyntax || a is LocalFunctionStatementSyntax) break;
            switch (a)
            {
                case IfStatementSyntax ifs when ifs.Statement == child || ifs.Statement.Contains(child) && !(ifs.Else?.Contains(child) ?? false):
                    if (ifs.Condition != child) parts.Insert(0, "if(" + Trunc(Simplify(ifs.Condition), 200) + ")"); break;
                case ElseClauseSyntax els when els.Parent is IfStatementSyntax pif:
                    parts.Insert(0, "else!(" + Trunc(Simplify(pif.Condition), 200) + ")"); break;
                case SwitchSectionSyntax sec when sec.Parent is SwitchStatementSyntax sw:
                    parts.Insert(0, "switch(" + Trunc(sw.Expression.ToString(), 60) + ")case " + string.Join("/", sec.Labels.OfType<CaseSwitchLabelSyntax>().Select(l => Trunc(Simplify(l.Value), 40)))); break;
                case ForEachStatementSyntax fe: parts.Insert(0, "foreach(" + fe.Identifier.Text + " in " + Trunc(fe.Expression.ToString(), 80) + ")"); break;
                case ForStatementSyntax fs: parts.Insert(0, "for(" + Trunc(fs.Condition?.ToString() ?? "", 80) + ")"); break;
                case WhileStatementSyntax ws: parts.Insert(0, "while(" + Trunc(ws.Condition.ToString(), 80) + ")"); break;
            }
            child = a;
        }
        return string.Join(" ⟫ ", parts);
    }

    void AddGridCall(SyntaxNode n, string rel, FileFacts ff, string api, string recv, IEnumerable<ExpressionSyntax> args, IEnumerable<string> names, int lineOffset)
    {
        var argList = args.ToList();
        var vals = argList.Select(a => IsStringish(a) ? Val.Join(_rv.Resolve(a)) : "?" + Trunc(a.ToString(), 60)).ToList();
        // Visible = <조건식> 은 평가 가능하도록 상수 치환한 식으로 보관
        if (api.StartsWith("set:") && argList.Count == 1 && !(argList[0] is LiteralExpressionSyntax)) vals = new List<string> { "{?" + Trunc(Simplify(argList[0]), 200) + "}" };
        var raw = string.Join(" ¦ ", argList.Select(a => Trunc(a.ToString(), 60)));
        // 출처: 리터럴 헤더/필드 = 하드코딩, DataRow/DataTable 값 = DB 구동, 그 외 = 식
        string src = argList.Select(a => a.ToString()).Concat(vals).Any(a => Regex.IsMatch(a, @"\b(dr|row|dt\w*|\w*Row\w*)\s*\[|Rows\s*\[|\.Field<|\[\s*""(COLUMN_|MEASURE)")) ? "DB_DRIVEN"
                   : vals.Take(3).Any(v => v.Length > 0 && !v.Contains('{') && v.Any(char.IsLetter)) ? "HARDCODED" : "EXPR";
        // 대상 컬럼: 식 안의 GetColumnIndex(...) / Columns["X"] 인자를 해석
        var cols = new List<string>();
        foreach (var gi in n.DescendantNodesAndSelf().OfType<InvocationExpressionSyntax>())
        {
            var nm = gi.Expression is MemberAccessExpressionSyntax gma ? gma.Name.Identifier.Text : gi.Expression is IdentifierNameSyntax gid ? gid.Identifier.Text : "";
            if (nm is "GetColumnIndex" or "GetColumn" && gi.ArgumentList.Arguments.Count >= 1)
                cols.AddRange(_rv.Resolve(gi.ArgumentList.Arguments[0].Expression).Select(Val.Show));
        }
        foreach (var ea in n.DescendantNodesAndSelf().OfType<ElementAccessExpressionSyntax>())
            if (ea.Expression.ToString().EndsWith("Columns") && ea.ArgumentList.Arguments.Count == 1 && ea.ArgumentList.Arguments[0].Expression is LiteralExpressionSyntax cl && cl.IsKind(SyntaxKind.StringLiteralExpression))
                cols.Add(cl.Token.ValueText);
        ff.GridCalls.Add(new GridCall { File = rel, ClassSimple = CsIndex.ClassSimpleOf(n), Member = MemberName(n), Line = Line(n) + lineOffset, Api = api, Receiver = Trunc(recv, 80),
            Args = string.Join(" ¦ ", vals), ArgNames = string.Join(",", names), Source = src, Conditions = Conditions(n), Raw = raw, Columns = string.Join(" || ", cols.Distinct()) });
    }

    public static long Next() => Interlocked.Increment(ref _seq);

    public FileFacts Extract(SyntaxTree tree, string rel)
    {
        var ff = new FileFacts();
        var root = tree.GetCompilationUnitRoot();
        var diags = tree.GetDiagnostics().Where(d => d.Severity == DiagnosticSeverity.Error).ToList();
        ff.ParseErrors = diags.Count;
        if (diags.Count > 0) ff.FirstError = diags[0].ToString();

        Walk(root, rel, ff, active: true, commented: false, lineOffset: 0);
        ExtractTrivia(root, rel, ff, 0, 0);
        return ff;
    }

    // ───────────────────────── 활성 코드 ─────────────────────────
    void Walk(SyntaxNode root, string rel, FileFacts ff, bool active, bool commented, int lineOffset)
    {
        foreach (var m in root.DescendantNodes().OfType<MemberDeclarationSyntax>())
        {
            if (m is BaseMethodDeclarationSyntax || m is PropertyDeclarationSyntax || m is BaseTypeDeclarationSyntax || m is FieldDeclarationSyntax || m is EventFieldDeclarationSyntax)
            {
                if (commented) continue;
                var mr = new MemberRec
                {
                    File = rel, ClassFull = CsIndex.ClassFullOf(m is BaseTypeDeclarationSyntax ? m.Parent ?? m : m), ClassSimple = CsIndex.ClassSimpleOf(m is BaseTypeDeclarationSyntax ? m.Parent ?? m : m),
                    Kind = m.Kind().ToString().Replace("Declaration", ""), Modifiers = string.Join(" ", m.Modifiers.Select(x => x.Text)),
                    Line = Line(m) + lineOffset, EndLine = m.GetLocation().GetLineSpan().EndLinePosition.Line + 1 + lineOffset
                };
                switch (m)
                {
                    case MethodDeclarationSyntax md: mr.Member = md.Identifier.Text; mr.Params = md.ParameterList.ToString(); break;
                    case ConstructorDeclarationSyntax cd: mr.Member = ".ctor"; mr.Params = cd.ParameterList.ToString(); break;
                    case DestructorDeclarationSyntax: mr.Member = ".dtor"; break;
                    case OperatorDeclarationSyntax od: mr.Member = "op_" + od.OperatorToken.Text; break;
                    case ConversionOperatorDeclarationSyntax: mr.Member = "op_conv"; break;
                    case PropertyDeclarationSyntax pd: mr.Member = pd.Identifier.Text; mr.Params = pd.Type.ToString(); break;
                    case FieldDeclarationSyntax fd: mr.Member = string.Join(",", fd.Declaration.Variables.Select(v => v.Identifier.Text)); mr.Params = fd.Declaration.Type.ToString(); break;
                    case EventFieldDeclarationSyntax ed: mr.Member = string.Join(",", ed.Declaration.Variables.Select(v => v.Identifier.Text)); mr.Params = ed.Declaration.Type.ToString(); break;
                    case BaseTypeDeclarationSyntax bt: mr.Member = bt.Identifier.Text; mr.BaseList = bt.BaseList?.Types.ToString(); mr.ClassSimple = bt.Identifier.Text; mr.ClassFull = CsIndex.ClassFullOf(bt); break;
                }
                ff.Members.Add(mr);
            }
        }

        foreach (var node in root.DescendantNodes())
        {
            switch (node)
            {
                case ObjectCreationExpressionSyntax oc: OnCreation(oc, oc.Type, oc.ArgumentList, rel, ff, active, commented, lineOffset); break;
                case ImplicitObjectCreationExpressionSyntax ioc: break;
                case InvocationExpressionSyntax inv: OnInvocation(inv, rel, ff, active, commented, lineOffset); break;
                case AssignmentExpressionSyntax asg: OnAssignment(asg, rel, ff, active, commented, lineOffset); break;
                case ElementAccessExpressionSyntax ea when !commented: OnElementAccess(ea, rel, ff, lineOffset); break;
                case LiteralExpressionSyntax lit when !commented && lit.IsKind(SyntaxKind.StringLiteralExpression):
                    {
                        var v = lit.Token.ValueText;
                        if (LiteralLike.IsMatch(v) && (v.Contains('_') || v.Contains('.') || v.Contains('\\')))
                            ff.Literals.Add(new LiteralRec { File = rel, ClassSimple = CsIndex.ClassSimpleOf(lit), Member = MemberName(lit), Line = Line(lit) + lineOffset, Value = v });
                        break;
                    }
            }
        }
    }

    static int Line(SyntaxNode n) => n.GetLocation().GetLineSpan().StartLinePosition.Line + 1;

    static SyntaxNode MemberNode(SyntaxNode n) => n.Ancestors().FirstOrDefault(x => x is BaseMethodDeclarationSyntax || x is PropertyDeclarationSyntax || x is FieldDeclarationSyntax || x is EventDeclarationSyntax || x is IndexerDeclarationSyntax);

    static string MemberName(SyntaxNode n) => MemberNode(n) switch
    {
        MethodDeclarationSyntax m => m.Identifier.Text,
        ConstructorDeclarationSyntax => ".ctor",
        PropertyDeclarationSyntax p => p.Identifier.Text,
        FieldDeclarationSyntax f => "<field:" + f.Declaration.Variables.First().Identifier.Text + ">",
        EventDeclarationSyntax e => e.Identifier.Text,
        null => "<type>",
        var x => x.Kind().ToString()
    };

    Site NewSite(SyntaxNode n, string rel, string siteKind, string target, string kind, bool active, bool commented, int lineOffset)
    {
        var mem = MemberNode(n);
        var s = new Site
        {
            Seq = Next(), File = rel, ClassFull = CsIndex.ClassFullOf(n), ClassSimple = CsIndex.ClassSimpleOf(n), Member = MemberName(n),
            MemberLine = mem != null ? Line(mem) + lineOffset : 0, Line = Line(n) + lineOffset, SiteKind = siteKind, Target = target, Kind = kind,
            Active = active, Commented = commented, Raw = Trunc(n.ToString(), 300)
        };
        s.OriginSeq = s.Seq;
        SetGuard(n, s);
        return s;
    }

    /// <summary>sink 가 switch(메서드파라미터) 의 case 안에 있으면 가드로 기록 (데이터 구동 분기 추적)</summary>
    static void SetGuard(SyntaxNode n, Site s)
    {
        var (i, nm, lb) = GuardOf(n);
        if (i >= 0) { s.GuardIdx = i; s.GuardName = nm; s.GuardLabels = lb; }
    }

    static (int, string, List<string>) GuardOf(SyntaxNode n)
    {
        foreach (var sec in n.Ancestors().OfType<SwitchSectionSyntax>())
        {
            if (sec.Parent is not SwitchStatementSyntax sw || sw.Expression is not IdentifierNameSyntax id) continue;
            var mem = sw.Ancestors().OfType<BaseMethodDeclarationSyntax>().FirstOrDefault();
            if (mem == null) return (-1, null, null);
            var ps = mem.ParameterList.Parameters;
            for (int i = 0; i < ps.Count; i++)
                if (ps[i].Identifier.Text == id.Identifier.Text)
                {
                    var labels = sec.Labels.OfType<CaseSwitchLabelSyntax>().Select(l => l.Value.ToString()).ToList();
                    if (labels.Count == 0) return (-1, null, null); // default:
                    return (i, id.Identifier.Text, labels);
                }
        }
        return (-1, null, null);
    }

    static string Trunc(string s, int n) { s = Regex.Replace(s, @"\s+", " "); return s.Length > n ? s[..n] + "…" : s; }

    static string TypeSimple(TypeSyntax t) => t switch
    {
        QualifiedNameSyntax q => q.Right.Identifier.Text,
        GenericNameSyntax g => g.Identifier.Text,
        IdentifierNameSyntax i => i.Identifier.Text,
        AliasQualifiedNameSyntax a => a.Name.Identifier.Text,
        _ => t.ToString()
    };

    static string ReceiverOf(SyntaxNode n)
    {
        // var request = new X(...)  /  request = new X(...)
        var p = n.Parent;
        while (p is ParenthesizedExpressionSyntax || p is CastExpressionSyntax) p = p.Parent;
        if (p is EqualsValueClauseSyntax ev && ev.Parent is VariableDeclaratorSyntax vd) return vd.Identifier.Text;
        if (p is AssignmentExpressionSyntax a) return a.Left.ToString();
        return "";
    }

    void OnCreation(ExpressionSyntax oc, TypeSyntax type, ArgumentListSyntax args, string rel, FileFacts ff, bool active, bool commented, int lineOffset)
    {
        var tname = TypeSimple(type);
        // 호출 그래프용 (생성자)
        if (!_frag) ff.Calls.Add(MakeCall(oc, rel, tname, "new", args, true, lineOffset));
        foreach (var sc in _cfg.sinks.ctor.Where(c => c.type == tname))
        {
            if (args == null || args.Arguments.Count <= sc.arg) continue;
            var s = NewSite(oc, rel, "ctor", tname, sc.kind, active, commented, lineOffset);
            s.Values = _rv.Resolve(args.Arguments[sc.arg].Expression);
            if (sc.arg2 >= 0 && args.Arguments.Count > sc.arg2) s.Values2 = _rv.Resolve(args.Arguments[sc.arg2].Expression);
            s.Receiver = ReceiverOf(oc);
            ff.Sites.Add(s);
        }
    }

    CallRec MakeCall(SyntaxNode n, string rel, string callee, string receiver, ArgumentListSyntax args, bool isCtor, int lineOffset)
    {
        var mem = MemberNode(n);
        var c = new CallRec
        {
            Seq = Next(), File = rel, ClassSimple = CsIndex.ClassSimpleOf(n), Member = MemberName(n), MemberLine = mem != null ? Line(mem) + lineOffset : 0,
            Line = Line(n) + lineOffset, Callee = callee, Receiver = receiver, IsCtor = isCtor
        };
        var texts = new List<string>();
        if (args != null)
            foreach (var a in args.Arguments)
            {
                c.ArgNames.Add(a.NameColon?.Name.Identifier.Text ?? "");
                // 메모리 절감: 정적으로 아무것도 알 수 없는 인자는 null (표시 시 '?')
                List<string> v = IsStringish(a.Expression) ? _rv.Resolve(a.Expression) : null;
                if (v != null && v.Count == 1 && Val.HasUnknown(v[0]) && !Val.HasParam(v[0]) && !(a.Expression is MemberAccessExpressionSyntax || a.Expression is IdentifierNameSyntax)) v = null;
                c.Args.Add(v);
                texts.Add((c.ArgNames[^1] != "" ? c.ArgNames[^1] + ":" : "") + (v == null ? "?" + Trunc(a.Expression.ToString(), 60) : Val.Join(v)));
            }
        c.ArgsText = string.Join(" ¦ ", texts);
        (c.GuardIdx, c.GuardName, c.GuardLabels) = GuardOf(n);
        // 해석 가능한 인자가 하나도 없으면 인자 목록을 비워 메모리 절감 (개수는 유지)
        if (c.Args.All(x => x == null)) { var cnt = c.Args.Count; c.Args = Enumerable.Repeat<List<string>>(null, cnt).ToList(); }
        return c;
    }

    /// <summary>문자열로 해석할 가치가 있는 식인가 (람다/new 객체 등은 제외해 비용을 줄인다)</summary>
    static bool IsStringish(ExpressionSyntax e) => e is LiteralExpressionSyntax || e is IdentifierNameSyntax || e is MemberAccessExpressionSyntax
        || e is BinaryExpressionSyntax || e is InterpolatedStringExpressionSyntax || e is InvocationExpressionSyntax || e is ConditionalExpressionSyntax || e is ParenthesizedExpressionSyntax || e is CastExpressionSyntax;

    void OnInvocation(InvocationExpressionSyntax inv, string rel, FileFacts ff, bool active, bool commented, int lineOffset)
    {
        string name, recv;
        switch (inv.Expression)
        {
            case MemberAccessExpressionSyntax ma: name = ma.Name.Identifier.Text; recv = ma.Expression.ToString(); break;
            case IdentifierNameSyntax id: name = id.Identifier.Text; recv = ""; break;
            case GenericNameSyntax g: name = g.Identifier.Text; recv = ""; break;
            case MemberBindingExpressionSyntax mb: name = mb.Name.Identifier.Text; recv = "?."; break;
            default: return;
        }
        if (!_frag) ff.Calls.Add(MakeCall(inv, rel, name, recv, inv.ArgumentList, false, lineOffset));
        if (!_frag && _gridApi.Any(r => r.IsMatch(name)))
        {
            // 같은 이름을 화면 클래스(또는 조상)가 직접 정의했으면 프레임워크 메타 API 가 아니라 화면 로컬 메서드 → "local:" 접두
            var curCls = CsIndex.ClassSimpleOf(inv);
            bool local = (recv == "" || recv == "this" || recv == "base") && _ix.MethodsByName.TryGetValue(name, out var lm)
                         && lm.Any(m => m.ClassSimple == curCls && !m.File.StartsWith("01.Framework"));
            if (local) { AddGridCall(inv, rel, ff, "local:" + name, recv, inv.ArgumentList.Arguments.Select(a => a.Expression), Array.Empty<string>(), lineOffset); goto gridDone; }
            var cand = _ix.MethodsByName.TryGetValue(name, out var ml) ? ml.Where(m => m.RequiredParams <= inv.ArgumentList.Arguments.Count && m.ParamNames.Count >= inv.ArgumentList.Arguments.Count).ToList() : new();
            var pn = cand.Select(m => string.Join(",", m.ParamNames.Take(inv.ArgumentList.Arguments.Count))).Distinct().ToList();
            AddGridCall(inv, rel, ff, name, recv, inv.ArgumentList.Arguments.Select(a => a.Expression), pn.Count == 1 ? pn[0].Split(',') : Array.Empty<string>(), lineOffset);
        }
        gridDone:;
        // 컨트롤 트리: parent.Controls.Add(child) / AddRange(new Control[]{...})
        if (!_frag && (name == "Add" || name == "AddRange") && recv.EndsWith(".Controls") || !_frag && recv == "Controls" && (name == "Add" || name == "AddRange"))
        {
            var parent = recv == "Controls" ? "this" : recv[..^".Controls".Length].Replace("this.", "");
            foreach (var a in inv.ArgumentList.Arguments)
            {
                var exprs = a.Expression is ArrayCreationExpressionSyntax ac && ac.Initializer != null ? ac.Initializer.Expressions.ToList()
                          : a.Expression is ImplicitArrayCreationExpressionSyntax ic ? ic.Initializer.Expressions.ToList() : new List<ExpressionSyntax> { a.Expression };
                foreach (var e in exprs) ff.ControlParent[e.ToString().Replace("this.", "")] = parent;
            }
        }

        // 같은 이름의 사용자 정의 메서드를 직접(무수신자/this/정적 클래스) 호출하는 경우는 라이브러리 sink 가 아니다 → 전파로 추적
        bool userMethodCall = (recv == "" || recv == "this" || recv == "base" || _ix.ClassSimpleNames.Contains(recv.Split('.').Last()))
                              && _ix.MethodsByName.TryGetValue(name, out var um) && um.Any(m => m.RequiredParams <= inv.ArgumentList.Arguments.Count && m.ParamNames.Count >= inv.ArgumentList.Arguments.Count);
        foreach (var si in _cfg.sinks.invoke.Where(x => x.method == name && !userMethodCall))
        {
            if (inv.ArgumentList.Arguments.Count <= si.arg) continue;
            var e = inv.ArgumentList.Arguments[si.arg].Expression;
            var vals = _rv.Resolve(e);
            // stringOnly: 첫 인자가 문자열로 보이지 않으면(요청 객체 등) sink 아님
            if (si.stringOnly && vals.All(v => Val.HasUnknown(v) && !Val.HasParam(v)) && !(e is LiteralExpressionSyntax)) continue;
            var s = NewSite(inv, rel, "invoke", name, si.kind, active, commented, lineOffset);
            s.Values = vals;
            if (si.arg2 >= 0 && inv.ArgumentList.Arguments.Count > si.arg2) s.Values2 = _rv.Resolve(inv.ArgumentList.Arguments[si.arg2].Expression);
            ff.Sites.Add(s);
        }
        // request.Parameters.Add("pagePath", x)
        if (name == "Add" && inv.Expression is MemberAccessExpressionSyntax pma && pma.Expression is MemberAccessExpressionSyntax pp && pp.Name.Identifier.Text == "Parameters"
            && inv.ArgumentList.Arguments.Count >= 2 && inv.ArgumentList.Arguments[0].Expression is LiteralExpressionSyntax plit)
            AddReqParam(inv, pp.Expression.ToString(), plit.Token.ValueText, inv.ArgumentList.Arguments[1].Expression, rel, ff, active, commented, lineOffset);

        // DataRow.Field<T>("COL") / IsNull("COL")
        if (!_frag && (name is "Field" or "IsNull" or "SetField") && inv.ArgumentList.Arguments.Count >= 1 && inv.ArgumentList.Arguments[0].Expression is LiteralExpressionSyntax flit && flit.IsKind(SyntaxKind.StringLiteralExpression))
            ff.MetaReads.Add(new MetaRead { File = rel, ClassSimple = CsIndex.ClassSimpleOf(inv), Member = MemberName(inv), Line = Line(inv) + lineOffset, Receiver = Trunc(recv, 120), Column = flit.Token.ValueText, Via = name });
    }

    void AddReqParam(SyntaxNode n, string receiver, string pname, ExpressionSyntax valueExpr, string rel, FileFacts ff, bool active, bool commented, int lineOffset)
    {
        var s = NewSite(n, rel, "reqparam", pname, "param", active, commented, lineOffset);
        s.Receiver = receiver;
        s.Values = IsStringish(valueExpr) ? _rv.Resolve(valueExpr) : new List<string> { Val.Unknown(Trunc(valueExpr.ToString(), 80)) };
        ff.Sites.Add(s);
    }

    static readonly System.Runtime.CompilerServices.ConditionalWeakTable<SyntaxTree, HashSet<string>> _methodNames = new();
    static HashSet<string> MethodNames(SyntaxTree tree)
    {
        if (_methodNames.TryGetValue(tree, out var set)) return set;
        set = new HashSet<string>(tree.GetRoot().DescendantNodes().OfType<MethodDeclarationSyntax>().Select(m => m.Identifier.Text), StringComparer.Ordinal);
        _methodNames.Add(tree, set);
        return set;
    }

    void OnAssignment(AssignmentExpressionSyntax a, string rel, FileFacts ff, bool active, bool commented, int lineOffset)
    {
        // 이벤트 배선
        if ((a.IsKind(SyntaxKind.AddAssignmentExpression) || a.IsKind(SyntaxKind.SubtractAssignmentExpression)) && !_frag)
        {
            string handler = a.Right switch
            {
                ObjectCreationExpressionSyntax oc when oc.ArgumentList?.Arguments.Count == 1 => oc.ArgumentList.Arguments[0].Expression.ToString(),
                IdentifierNameSyntax id => id.Identifier.Text,
                MemberAccessExpressionSyntax ma => ma.ToString(),
                AnonymousFunctionExpressionSyntax => "<lambda>",
                _ => null
            };
            // 산술 복합대입(i += n, sum_week += x) 오탐 방지: RHS 가 델리게이트 생성/람다가 아니면 같은 파일에 선언된 메서드명일 때만 이벤트로 본다
            if (handler != null && a.Right is not ObjectCreationExpressionSyntax && a.Right is not AnonymousFunctionExpressionSyntax)
            {
                var methods = MethodNames(a.SyntaxTree);
                var last = handler.Split('.').Last();
                if (!methods.Contains(last)) handler = null;
            }
            if (handler != null && a.Left is MemberAccessExpressionSyntax lm)
                ff.Events.Add(new EventRec { File = rel, ClassSimple = CsIndex.ClassSimpleOf(a), Member = MemberName(a), Line = Line(a) + lineOffset, Target = lm.Expression.ToString(), EventName = lm.Name.Identifier.Text, Handler = handler.Replace("this.", ""), Op = a.OperatorToken.Text });
            else if (handler != null && a.Left is IdentifierNameSyntax li)
                ff.Events.Add(new EventRec { File = rel, ClassSimple = CsIndex.ClassSimpleOf(a), Member = MemberName(a), Line = Line(a) + lineOffset, Target = "this", EventName = li.Identifier.Text, Handler = handler.Replace("this.", ""), Op = a.OperatorToken.Text });
        }
        if (!a.IsKind(SyntaxKind.SimpleAssignmentExpression)) return;

        // request.Parameters["x"] = v
        if (a.Left is ElementAccessExpressionSyntax ea && ea.Expression is MemberAccessExpressionSyntax pm && pm.Name.Identifier.Text == "Parameters"
            && ea.ArgumentList.Arguments.Count == 1 && ea.ArgumentList.Arguments[0].Expression is LiteralExpressionSyntax pl)
        {
            AddReqParam(a, pm.Expression.ToString(), pl.Token.ValueText, a.Right, rel, ff, active, commented, lineOffset);
            return;
        }
        // 속성 sink (QueryID 등)
        if (a.Left is MemberAccessExpressionSyntax lma)
        {
            var prop = lma.Name.Identifier.Text;
            foreach (var sp in _cfg.sinks.propertyAssign.Where(x => x.property == prop))
            {
                var s = NewSite(a, rel, "prop", prop, sp.kind, active, commented, lineOffset);
                s.Values = _rv.Resolve(a.Right);
                s.Receiver = lma.Expression.ToString();
                ff.Sites.Add(s);
            }
            // 디자이너/런타임 속성 대입 (this.ctl.Prop = v, ctl.Prop = v)
            if (!_frag)
            {
                var gtxt = lma.Expression.ToString();
                if (gtxt.Contains("Columns[") || gtxt.Contains("Columns.Get(") || gtxt.Contains("ColumnHeader") || (gtxt.EndsWith(".Columns") && prop == "Count") || gtxt.EndsWith("ColumnCount") || prop == "ColumnCount")
                    AddGridCall(a, rel, ff, "set:" + prop, gtxt, new[] { a.Right }, new[] { prop }, lineOffset);
                var target = lma.Expression.ToString().Replace("this.", "");
                ff.Props.Add(new PropRec { File = rel, ClassSimple = CsIndex.ClassSimpleOf(a), Member = MemberName(a), Line = Line(a) + lineOffset, Target = target, Prop = prop, Value = Trunc(a.Right.ToString(), 200) });
                // 컨트롤 선언: this.x = new T()
            }
        }
        if (!_frag && a.Left is MemberAccessExpressionSyntax cma && cma.Expression is ThisExpressionSyntax && a.Right is ObjectCreationExpressionSyntax coc
            && MemberName(a) == "InitializeComponent")
            ff.Controls.Add(new ControlRec { File = rel, ClassSimple = CsIndex.ClassSimpleOf(a), Name = cma.Name.Identifier.Text, Type = coc.Type.ToString(), Line = Line(a) + lineOffset, Parent = "" });
    }

    void OnElementAccess(ElementAccessExpressionSyntax ea, string rel, FileFacts ff, int lineOffset)
    {
        if (ea.ArgumentList.Arguments.Count != 1) return;
        if (ea.ArgumentList.Arguments[0].Expression is not LiteralExpressionSyntax lit || !lit.IsKind(SyntaxKind.StringLiteralExpression)) return;
        if (ea.Expression is MemberAccessExpressionSyntax pm && pm.Name.Identifier.Text == "Parameters") return;
        ff.MetaReads.Add(new MetaRead { File = rel, ClassSimple = CsIndex.ClassSimpleOf(ea), Member = MemberName(ea), Line = Line(ea) + lineOffset, Receiver = Trunc(ea.Expression.ToString(), 120), Column = lit.Token.ValueText, Via = "[]" });
    }

    // ───────────────────────── 주석 / 비활성 코드 ─────────────────────────
    /// <summary>lineOffset: 조각 줄 → 원본 줄 보정, depth: 중첩 주석 깊이 (// // 처럼 주석 안의 주석)</summary>
    void ExtractTrivia(SyntaxNode root, string rel, FileFacts ff, int lineOffset, int depth)
    {
        if (depth > 4) return;
        var all = root.DescendantTrivia(descendIntoTrivia: true).ToList();
        int i = 0;
        while (i < all.Count)
        {
            var t = all[i];
            if (t.IsKind(SyntaxKind.SingleLineCommentTrivia))
            {
                // 연속된 // 줄 묶음
                var sb = new StringBuilder();
                int start = t.GetLocation().GetLineSpan().StartLinePosition.Line;
                int lastLine = start;
                int j = i;
                while (j < all.Count)
                {
                    var tj = all[j];
                    if (tj.IsKind(SyntaxKind.SingleLineCommentTrivia))
                    {
                        var ln = tj.GetLocation().GetLineSpan().StartLinePosition.Line;
                        if (ln > lastLine + 1) break;
                        // 줄 정렬 유지: 이전 줄과의 간격만큼 개행
                        while (lastLine < ln) { sb.Append('\n'); lastLine++; }
                        var txt = tj.ToString();
                        sb.Append(txt[2..]); // "///", "////" 도 일반 주석으로 취급 (DocumentationMode.None)
                        lastLine = ln; j++;
                    }
                    else if (tj.IsKind(SyntaxKind.WhitespaceTrivia) || tj.IsKind(SyntaxKind.EndOfLineTrivia)) j++;
                    else break;
                }
                ParseFragment(sb.ToString(), start + lineOffset, rel, ff, depth == 0 ? "line-comment" : "nested-comment", active: true, commented: true, depth);
                i = j;
                continue;
            }
            if (t.IsKind(SyntaxKind.MultiLineCommentTrivia))
            {
                var txt = t.ToString();
                var body = txt.Length >= 4 ? txt[2..^2] : "";
                ParseFragment(body, t.GetLocation().GetLineSpan().StartLinePosition.Line + lineOffset, rel, ff, depth == 0 ? "block-comment" : "nested-comment", true, true, depth);
            }
            else if (t.IsKind(SyntaxKind.DisabledTextTrivia))
            {
                ParseFragment(t.ToString(), t.GetLocation().GetLineSpan().StartLinePosition.Line + lineOffset, rel, ff, "disabled-#if", active: depth > 0 ? true : false, commented: depth > 0, depth);
            }
            i++;
        }
    }

    /// <summary>주석/비활성 텍스트를 같은 Roslyn 파서로 재파싱. 줄 번호는 원본 기준으로 보정한다.</summary>
    void ParseFragment(string text, int startLine0, string rel, FileFacts ff, string kind, bool active, bool commented, int depth = 0)
    {
        if (string.IsNullOrWhiteSpace(text)) return;
        // 코드처럼 보이지 않는 주석(설명문)은 비용 절약을 위해 건너뛰되, 판정 기준은 '(' 또는 '=' 존재
        if (text.IndexOf('(') < 0 && text.IndexOf('=') < 0) return;
        var before = ff.Sites.Count;
        // 멤버 수준/문장 수준 모두 수용: 가상 클래스 안의 메서드 본문으로 감싼다 (헤더 1줄)
        var wrapped = "class __Frag { void __M() {\n" + text + "\n} }";
        var tree = CSharpSyntaxTree.ParseText(wrapped, CsIndex.ParseOptions(_cfg));
        var root = tree.GetRoot();
        // 원본 줄 = startLine0 + (frag line) ; frag line 1 은 헤더 → 오프셋 startLine0 - 1
        WalkFragment(root, rel, ff, active, commented, startLine0 - 1);
        // 조각 안의 주석(중첩 주석)도 같은 방식으로 재귀 처리 → 상태는 주석(commented) 유지
        int beforeNested = ff.Sites.Count;
        ExtractTrivia(root, rel, ff, startLine0 - 1, depth + 1);
        if (!commented) foreach (var x in ff.Sites.Skip(beforeNested)) { x.Active = active; }
        // 메서드 본문으로 실패한 경우(멤버 선언 주석) 클래스 멤버로도 시도
        if (ff.Sites.Count == before && (text.Contains("FoxDataRequest") || text.Contains("FoxBizRequest")))
        {
            if (ff.Sites.Count == before)
            {
                var w2 = "class __Frag {\n" + text + "\n}";
                WalkFragment(CSharpSyntaxTree.ParseText(w2, CsIndex.ParseOptions(_cfg)).GetRoot(), rel, ff, active, commented, startLine0 - 1);
            }
        }
        ff.Trivia.Add(new TriviaRec { File = rel, Kind = kind, Line = startLine0 + 1, EndLine = startLine0 + 1 + text.Count(c => c == '\n'), Sites = ff.Sites.Count - before });
    }

    void WalkFragment(SyntaxNode root, string rel, FileFacts ff, bool active, bool commented, int lineOffset)
    {
        _frag = true;
        try {
        foreach (var node in root.DescendantNodes())
        {
            switch (node)
            {
                case ObjectCreationExpressionSyntax oc: OnCreation(oc, oc.Type, oc.ArgumentList, rel, ff, active, commented, lineOffset); break;
                case InvocationExpressionSyntax inv: OnInvocation(inv, rel, ff, active, commented, lineOffset); break;
                case AssignmentExpressionSyntax asg: OnAssignment(asg, rel, ff, active, commented, lineOffset); break;
            }
        }
        } finally { _frag = false; }
        // 주석/비활성 조각의 사이트는 소속을 원본 파일 기준으로 표기
        foreach (var s in ff.Sites.Where(s => s.ClassSimple == "__Frag")) { s.ClassSimple = "(" + (commented ? "comment" : "inactive") + ")"; s.ClassFull = s.ClassSimple; s.Member = "(fragment)"; }
    }
}
