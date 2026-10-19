using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace AsisFacts;

/// <summary>
/// 문자열 식의 정적 값 후보 계산 (상수 폴딩 + 지역변수/필드/파라미터 추적).
/// 결정할 수 없는 부분은 버리지 않고 Unknown 자리표시자로 남긴다.
/// </summary>
public sealed class Resolver
{
    readonly CsIndex _ix;
    readonly Dictionary<string, List<string>> _fieldCache = new(StringComparer.Ordinal);
    public Resolver(CsIndex ix) { _ix = ix; }

    /// <summary>멤버별 지역 선언/대입 색인 (반복 탐색 비용 제거)</summary>
    sealed class Scope
    {
        public Dictionary<string, List<VariableDeclaratorSyntax>> Decls = new(StringComparer.Ordinal);
        public Dictionary<string, List<AssignmentExpressionSyntax>> Assigns = new(StringComparer.Ordinal);
        public HashSet<string> OtherLocals = new(StringComparer.Ordinal);
    }
    readonly Dictionary<SyntaxNode, Scope> _scopes = new();
    SyntaxTree _scopeTree;

    Scope ScopeOf(SyntaxNode member)
    {
        if (_scopeTree != member.SyntaxTree) { _scopes.Clear(); _scopeTree = member.SyntaxTree; }
        if (_scopes.TryGetValue(member, out var sc)) return sc;
        sc = new Scope();
        foreach (var n in member.DescendantNodes())
        {
            switch (n)
            {
                case VariableDeclaratorSyntax v:
                    if (!sc.Decls.TryGetValue(v.Identifier.Text, out var dl)) sc.Decls[v.Identifier.Text] = dl = new();
                    dl.Add(v); break;
                case AssignmentExpressionSyntax a when a.Left is IdentifierNameSyntax lid:
                    if (!sc.Assigns.TryGetValue(lid.Identifier.Text, out var al)) sc.Assigns[lid.Identifier.Text] = al = new();
                    al.Add(a); break;
                case ForEachStatementSyntax fe: sc.OtherLocals.Add(fe.Identifier.Text); break;
                case SingleVariableDesignationSyntax sv: sc.OtherLocals.Add(sv.Identifier.Text); break;
                case CatchDeclarationSyntax cd: sc.OtherLocals.Add(cd.Identifier.Text); break;
            }
        }
        _scopes[member] = sc;
        return sc;
    }

    public List<string> Resolve(ExpressionSyntax e, int depth = 0, HashSet<string> guard = null)
    {
        guard ??= new HashSet<string>(StringComparer.Ordinal);
        if (e == null) return new() { Val.Unknown("null") };
        if (depth > 12) return new() { Val.Unknown(e.ToString()) };
        switch (e)
        {
            case LiteralExpressionSyntax lit when lit.IsKind(SyntaxKind.StringLiteralExpression):
                return new() { lit.Token.ValueText };
            case LiteralExpressionSyntax lit when lit.IsKind(SyntaxKind.NumericLiteralExpression) || lit.IsKind(SyntaxKind.CharacterLiteralExpression):
                return new() { lit.Token.ValueText };
            case LiteralExpressionSyntax lit when lit.IsKind(SyntaxKind.NullLiteralExpression):
                return new() { "" };
            case ParenthesizedExpressionSyntax p: return Resolve(p.Expression, depth + 1, guard);
            case CastExpressionSyntax c: return Resolve(c.Expression, depth + 1, guard);
            case BinaryExpressionSyntax b when b.IsKind(SyntaxKind.AddExpression):
                return Val.Cross(Resolve(b.Left, depth + 1, guard), Resolve(b.Right, depth + 1, guard));
            case BinaryExpressionSyntax b when b.IsKind(SyntaxKind.CoalesceExpression):
                return Union(Resolve(b.Left, depth + 1, guard), Resolve(b.Right, depth + 1, guard));
            case ConditionalExpressionSyntax c:
                return Union(Resolve(c.WhenTrue, depth + 1, guard), Resolve(c.WhenFalse, depth + 1, guard));
            case InterpolatedStringExpressionSyntax ip:
                {
                    var acc = new List<string> { "" };
                    foreach (var part in ip.Contents)
                        acc = part switch
                        {
                            InterpolatedStringTextSyntax t => acc.Select(a => a + t.TextToken.ValueText).ToList(),
                            InterpolationSyntax ins => Val.Cross(acc, Resolve(ins.Expression, depth + 1, guard)),
                            _ => acc
                        };
                    return acc;
                }
            case InvocationExpressionSyntax inv: return ResolveInvocation(inv, depth, guard);
            case IdentifierNameSyntax id: return ResolveIdentifier(id, id.Identifier.Text, depth, guard);
            case MemberAccessExpressionSyntax ma: return ResolveMemberAccess(ma, depth, guard);
        }
        return new() { Val.Unknown(e.ToString()) };
    }

    static List<string> Union(List<string> a, List<string> b) => a.Concat(b).Distinct().Take(Val.MaxCandidates).ToList();

    List<string> ResolveInvocation(InvocationExpressionSyntax inv, int depth, HashSet<string> guard)
    {
        var args = inv.ArgumentList.Arguments;
        if (inv.Expression is MemberAccessExpressionSyntax ma)
        {
            var mname = ma.Name.Identifier.Text;
            var recv = ma.Expression.ToString();
            if ((recv == "string" || recv == "String" || recv == "System.String") && mname == "Format" && args.Count >= 1)
            {
                var fmts = Resolve(args[0].Expression, depth + 1, guard);
                var argVals = args.Skip(1).Select(a => Resolve(a.Expression, depth + 1, guard)).ToList();
                var outs = new List<string>();
                foreach (var f in fmts)
                {
                    if (!Val.IsLiteral(f)) { outs.Add(Val.Unknown(inv.ToString())); continue; }
                    var acc = new List<string> { "" };
                    int i = 0;
                    while (i < f.Length)
                    {
                        if (f[i] == '{' && i + 1 < f.Length && f[i + 1] == '{') { acc = acc.Select(a => a + "{").ToList(); i += 2; continue; }
                        if (f[i] == '}' && i + 1 < f.Length && f[i + 1] == '}') { acc = acc.Select(a => a + "}").ToList(); i += 2; continue; }
                        if (f[i] == '{')
                        {
                            var end = f.IndexOf('}', i);
                            var spec = end > i ? f[(i + 1)..end] : "";
                            var idxStr = spec.Split(',', ':')[0];
                            if (end > i && int.TryParse(idxStr, out var k) && k < argVals.Count) { acc = Val.Cross(acc, argVals[k]); i = end + 1; continue; }
                            acc = acc.Select(a => a + Val.Unknown("{" + spec + "}")).ToList(); i = end > i ? end + 1 : f.Length; continue;
                        }
                        acc = acc.Select(a => a + f[i]).ToList(); i++;
                    }
                    outs.AddRange(acc);
                }
                return outs.Distinct().Take(Val.MaxCandidates).ToList();
            }
            if ((recv == "string" || recv == "String") && mname == "Concat")
            {
                var acc = new List<string> { "" };
                foreach (var a in args) acc = Val.Cross(acc, Resolve(a.Expression, depth + 1, guard));
                return acc;
            }
            if (args.Count == 0 && (mname is "ToUpper" or "ToUpperInvariant"))
                return Resolve(ma.Expression, depth + 1, guard).Select(v => Val.IsLiteral(v) ? v.ToUpperInvariant() : v).ToList();
            if (args.Count == 0 && (mname is "ToLower" or "ToLowerInvariant"))
                return Resolve(ma.Expression, depth + 1, guard).Select(v => Val.IsLiteral(v) ? v.ToLowerInvariant() : v).ToList();
            if (args.Count == 0 && (mname is "Trim" or "ToString"))
                return Resolve(ma.Expression, depth + 1, guard).Select(v => Val.IsLiteral(v) ? (mname == "Trim" ? v.Trim() : v) : v).ToList();
        }
        return new() { Val.Unknown(inv.ToString()) };
    }

    static SyntaxNode MemberOf(SyntaxNode n) => n.Ancestors().FirstOrDefault(x => x is BaseMethodDeclarationSyntax || x is AccessorDeclarationSyntax || x is LocalFunctionStatementSyntax);

    List<string> ResolveIdentifier(SyntaxNode at, string name, int depth, HashSet<string> guard)
    {
        var member = MemberOf(at);
        var cls = CsIndex.ClassSimpleOf(at);
        if (member != null)
        {
            // 람다/로컬함수 파라미터 → 미결정
            foreach (var lam in at.Ancestors().OfType<AnonymousFunctionExpressionSyntax>())
            {
                var ps = lam switch { SimpleLambdaExpressionSyntax s => new[] { s.Parameter }, ParenthesizedLambdaExpressionSyntax p => p.ParameterList.Parameters.ToArray(), AnonymousMethodExpressionSyntax am => am.ParameterList?.Parameters.ToArray() ?? Array.Empty<ParameterSyntax>(), _ => Array.Empty<ParameterSyntax>() };
                if (ps.Any(p => p.Identifier.Text == name)) return new() { Val.Unknown(name) };
            }
            // 메서드 파라미터
            ParameterListSyntax pl = member switch { BaseMethodDeclarationSyntax bm => bm.ParameterList, LocalFunctionStatementSyntax lf => lf.ParameterList, _ => null };
            if (pl != null)
                for (int i = 0; i < pl.Parameters.Count; i++)
                    if (pl.Parameters[i].Identifier.Text == name)
                    {
                        // 메서드 내 재대입이 있으면 함께 반영
                        var reassigned = LocalAssignments(member, name, depth, guard, at);
                        var r = new List<string> { Val.Param(i, name) };
                        return Union(r, reassigned);
                    }
            // 지역변수
            var scope = ScopeOf(member);
            var decls = scope.Decls.TryGetValue(name, out var dd) ? dd : new List<VariableDeclaratorSyntax>();
            if (decls.Count > 0)
            {
                var key = member.SpanStart + ":" + name;
                if (!guard.Add(key)) return new() { Val.Unknown(name) };
                var vals = new List<string>();
                foreach (var d in decls)
                {
                    if (d.Initializer != null) vals.AddRange(Resolve(d.Initializer.Value, depth + 1, guard));
                    else vals.Add(""); // 선언만 있는 경우 초기값 없음
                }
                vals.AddRange(LocalAssignments(member, name, depth, guard, at));
                guard.Remove(key);
                // 선언만 하고 이후 대입되는 경우 빈 초기값은 제거
                var res = vals.Where(v => v.Length > 0).Distinct().Take(Val.MaxCandidates).ToList();
                return res.Count > 0 ? res : new() { "" };
            }
            if (scope.OtherLocals.Contains(name))
                return new() { Val.Unknown(name) };
        }
        // 필드 (자기 클래스 → 조상 클래스)
        foreach (var c in _ix.SelfAndBases(cls))
        {
            var r = ResolveField(c, name, depth, guard, at);
            if (r != null) return r;
        }
        // 이름이 유일한 필드
        if (_ix.FieldsByName.TryGetValue(name, out var fl) && fl.Select(f => f.ClassFull).Distinct().Count() == 1)
        {
            var r = ResolveField(CsIndex.ClassSimpleOfFull(fl[0].ClassFull), name, depth, guard, at);
            if (r != null) return r;
        }
        return new() { Val.Unknown(name) };
    }

    List<string> LocalAssignments(SyntaxNode member, string name, int depth, HashSet<string> guard, SyntaxNode at)
    {
        var vals = new List<string>();
        if (!ScopeOf(member).Assigns.TryGetValue(name, out var list)) return vals;
        foreach (var a in list)
        {
            if (a.IsKind(SyntaxKind.SimpleAssignmentExpression)) vals.AddRange(Resolve(a.Right, depth + 1, guard));
            else if (a.IsKind(SyntaxKind.AddAssignmentExpression)) vals.Add(Val.Unknown(name + " += " + a.Right));
        }
        return vals;
    }

    // 필드 초기화식 해석 중의 문맥 (가상 트리에는 파일/클래스 정보가 없으므로 별도 보관)
    string _ctxFile, _ctxClass;

    (string file, string cls) Ctx(SyntaxNode at)
    {
        var f = at?.SyntaxTree?.FilePath;
        if (!string.IsNullOrEmpty(f)) return (f, CsIndex.ClassFullOf(at));
        return (_ctxFile ?? "", _ctxClass ?? "");
    }

    /// <summary>
    /// 같은 단순 이름의 클래스/필드가 여러 화면에 있을 수 있다 (예: 화면마다 struct SpdSheet).
    /// 후보 선택 순서: 같은 파일 → 호출 클래스 내부(중첩) → 같은 파일군(partial) → 전역 유일. 그래도 여럿이고 값이 다르면 미해결.
    /// </summary>
    List<string> ResolveField(string cls, string name, int depth, HashSet<string> guard, SyntaxNode at = null)
    {
        var key = cls + "." + name;
        if (!_ix.FieldsByClassField.TryGetValue(key, out var inits)) return null;
        var (file, callerCls) = Ctx(at);
        List<FieldInit> pick = inits.Where(i => i.File == file).ToList();
        if (pick.Count == 0 && file != "")
        {
            var dir = Path.GetDirectoryName(file) ?? "";
            pick = inits.Where(i => (Path.GetDirectoryName(i.File) ?? "") == dir).ToList();
        }
        if (pick.Count == 0 && callerCls != "") pick = inits.Where(i => i.ClassFull == callerCls || i.ClassFull.StartsWith(callerCls + ".") || callerCls.StartsWith(i.ClassFull + ".")).ToList();
        if (pick.Count == 0) pick = inits;
        var cacheKey = key + "|" + string.Join(",", pick.Select(p => p.File + ":" + p.Line));
        if (_fieldCache.TryGetValue(cacheKey, out var cached)) return cached;
        if (!guard.Add("F:" + key)) return new() { Val.Unknown(key) };
        var vals = new List<string>();
        var classes = pick.Select(p => Path.GetDirectoryName(p.File) + "|" + CsIndex.ClassSimpleOfFull(p.ClassFull)).Distinct().Count();
        var saveF = _ctxFile; var saveC = _ctxClass;
        foreach (var fi in pick)
        {
            _ctxFile = fi.File; _ctxClass = fi.ClassFull;
            // 초기화식은 소속 클래스 문맥에서 해석: 가상 클래스로 감싸 위치를 부여
            var wrapped = SyntaxFactory.ParseCompilationUnit($"class {CsIndex.ClassSimpleOfFull(fi.ClassFull)} {{ object __f = {fi.ExprText}; }}");
            var e2 = wrapped.DescendantNodes().OfType<EqualsValueClauseSyntax>().First().Value;
            vals.AddRange(Resolve(e2, depth + 1, guard));
        }
        _ctxFile = saveF; _ctxClass = saveC;
        guard.Remove("F:" + key);
        // 필드에 대입된 메서드 파라미터는 그 메서드 문맥에서만 의미가 있으므로 미해결로 표기 (예: 생성자 인자로 받은 서비스명)
        vals = vals.Select(v => Val.HasParam(v) ? Val.Unknown("field " + key + " ← " + string.Join(",", Val.Params(v).Select(p => p.name))) : v).ToList();
        // 선언 초기값(빈 문자열)은 다른 대입이 있으면 제외
        if (vals.Any(v => v.Length > 0)) vals = vals.Where(v => v.Length > 0).ToList();
        var res = vals.Distinct().Take(Val.MaxCandidates).ToList();
        // 서로 다른 클래스(다른 화면)의 동명 필드이고 값도 다르면 섞지 않는다
        if (classes > 1 && res.Count > 1) res = new() { Val.Unknown($"ambiguous {key} ({classes} classes)") };
        _fieldCache[cacheKey] = res;
        return res;
    }

    List<string> ResolveMemberAccess(MemberAccessExpressionSyntax ma, int depth, HashSet<string> guard)
    {
        var name = ma.Name.Identifier.Text;
        string owner = ma.Expression switch
        {
            ThisExpressionSyntax => CsIndex.ClassSimpleOf(ma),
            BaseExpressionSyntax => CsIndex.ClassSimpleOf(ma),
            IdentifierNameSyntax id => id.Identifier.Text,
            MemberAccessExpressionSyntax inner => inner.Name.Identifier.Text,
            _ => null
        };
        if (owner != null)
        {
            foreach (var c in _ix.SelfAndBases(owner))
            {
                var r = ResolveField(c, name, depth, guard, ma);
                if (r != null) return r;
            }
        }
        return new() { Val.Unknown(ma.ToString()) };
    }
}
