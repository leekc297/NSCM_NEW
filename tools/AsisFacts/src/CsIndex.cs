using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace AsisFacts;

public sealed class MethodInfo
{
    public string ClassFull;      // Namespace.Outer.Inner
    public string ClassSimple;
    public string Name;
    public List<string> ParamNames = new();
    public int RequiredParams;
    public bool IsStatic;
    public string File;
    public int Line;
    public string BizName;        // [FoxBizMethod("X")]
    public string Kind;           // method|ctor|property|field-init|...
    public string Id => $"{ClassFull}.{Name}({ParamNames.Count})@{File}:{Line}";
}

public sealed class FieldInit
{
    public string ClassFull;
    public string Name;
    public string ExprText;       // 초기화식 또는 대입식 원문
    public bool IsConst;
    public string File;
    public int Line;
}

/// <summary>1차 패스: 전체 소스의 클래스/메서드/필드 색인. 구문트리는 보관하지 않는다.</summary>
public sealed class CsIndex
{
    public readonly Dictionary<string, List<MethodInfo>> MethodsByName = new(StringComparer.Ordinal);
    public readonly Dictionary<string, List<FieldInit>> FieldsByClassField = new(StringComparer.Ordinal); // "ClassSimple.Field"
    public readonly Dictionary<string, List<FieldInit>> FieldsByName = new(StringComparer.Ordinal);       // "Field"
    public readonly Dictionary<string, HashSet<string>> BaseTypes = new(StringComparer.Ordinal);          // ClassSimple → base simple names
    public readonly Dictionary<string, List<MethodInfo>> BizMethods = new(StringComparer.OrdinalIgnoreCase); // "Class.BizName"
    public readonly HashSet<string> ClassSimpleNames = new(StringComparer.Ordinal);

    public static CSharpParseOptions ParseOptions(Config cfg)
        => new CSharpParseOptions(LanguageVersion.Latest, DocumentationMode.None, SourceCodeKind.Regular, cfg.preprocessorSymbols);

    public static string ClassFullOf(SyntaxNode n)
    {
        var parts = new List<string>();
        for (var p = n; p != null; p = p.Parent)
        {
            switch (p)
            {
                case BaseTypeDeclarationSyntax t: parts.Insert(0, t.Identifier.Text); break;
                case BaseNamespaceDeclarationSyntax ns: parts.Insert(0, ns.Name.ToString()); break;
            }
        }
        return string.Join(".", parts);
    }

    public static string ClassSimpleOfFull(string full) { var i = full.LastIndexOf('.'); return i < 0 ? full : full[(i + 1)..]; }

    public static string ClassSimpleOf(SyntaxNode n) => n.AncestorsAndSelf().OfType<BaseTypeDeclarationSyntax>().FirstOrDefault()?.Identifier.Text ?? "";

    public void AddFile(SyntaxTree tree, string rel)
    {
        var root = tree.GetCompilationUnitRoot();
        foreach (var t in root.DescendantNodes().OfType<TypeDeclarationSyntax>())
        {
            var simple = t.Identifier.Text;
            ClassSimpleNames.Add(simple);
            if (!BaseTypes.TryGetValue(simple, out var bs)) BaseTypes[simple] = bs = new HashSet<string>(StringComparer.Ordinal);
            foreach (var b in t.BaseList?.Types ?? default)
            {
                var bn = b.Type switch { GenericNameSyntax g => g.Identifier.Text, QualifiedNameSyntax q => q.Right.Identifier.Text, IdentifierNameSyntax i => i.Identifier.Text, _ => b.Type.ToString() };
                bs.Add(bn);
            }
        }

        foreach (var m in root.DescendantNodes().OfType<BaseMethodDeclarationSyntax>())
        {
            var name = m switch { MethodDeclarationSyntax md => md.Identifier.Text, ConstructorDeclarationSyntax cd => ".ctor", _ => null };
            if (name == null) continue;
            var mi = new MethodInfo
            {
                ClassFull = ClassFullOf(m), ClassSimple = ClassSimpleOf(m), Name = name, File = rel,
                Line = m.GetLocation().GetLineSpan().StartLinePosition.Line + 1,
                IsStatic = m.Modifiers.Any(SyntaxKind.StaticKeyword), Kind = name == ".ctor" ? "ctor" : "method"
            };
            foreach (var p in m.ParameterList.Parameters)
            {
                mi.ParamNames.Add(p.Identifier.Text);
                if (p.Default == null && !p.Modifiers.Any(SyntaxKind.ParamsKeyword)) mi.RequiredParams++;
            }
            foreach (var a in m.AttributeLists.SelectMany(l => l.Attributes))
            {
                var an = a.Name.ToString();
                if ((an.EndsWith("FoxBizMethod") || an.EndsWith("FoxBizMethodAttribute")) && a.ArgumentList?.Arguments.Count > 0
                    && a.ArgumentList.Arguments[0].Expression is LiteralExpressionSyntax lit)
                    mi.BizName = lit.Token.ValueText;
            }
            Add(MethodsByName, name, mi);
            if (mi.BizName != null) Add(BizMethods, mi.ClassSimple + "." + mi.BizName, mi);
        }

        // 필드 초기화
        foreach (var f in root.DescendantNodes().OfType<FieldDeclarationSyntax>())
        {
            bool isConst = f.Modifiers.Any(SyntaxKind.ConstKeyword);
            foreach (var v in f.Declaration.Variables)
                if (v.Initializer != null) AddField(f, v.Identifier.Text, v.Initializer.Value.ToString(), isConst, rel);
        }
        // 필드/정적 멤버 대입 (메서드 본문 내): Name = expr, this.Name = expr, Class.Name = expr
        var localCache = new Dictionary<SyntaxNode, HashSet<string>>();
        foreach (var a in root.DescendantNodes().OfType<AssignmentExpressionSyntax>())
        {
            if (!a.IsKind(SyntaxKind.SimpleAssignmentExpression)) continue;
            var cls = ClassSimpleOf(a);
            string fname = null, owner = cls;
            switch (a.Left)
            {
                case IdentifierNameSyntax id: fname = id.Identifier.Text; break;
                case MemberAccessExpressionSyntax ma when ma.Expression is ThisExpressionSyntax: fname = ma.Name.Identifier.Text; break;
                case MemberAccessExpressionSyntax ma when ma.Expression is IdentifierNameSyntax oid && char.IsUpper(oid.Identifier.Text[0]): fname = ma.Name.Identifier.Text; owner = oid.Identifier.Text; break;
            }
            if (fname == null) continue;
            // 지역변수/파라미터 대입은 제외 (같은 메서드에 선언이 있으면 지역)
            var member = a.Ancestors().FirstOrDefault(x => x is BaseMethodDeclarationSyntax || x is AccessorDeclarationSyntax || x is LocalFunctionStatementSyntax);
            if (a.Left is IdentifierNameSyntax && member != null)
            {
                if (!localCache.TryGetValue(member, out var locals)) localCache[member] = locals = LocalNames(member);
                if (locals.Contains(fname)) continue;
            }
            Add(FieldsByClassField, owner + "." + fname, new FieldInit { ClassFull = owner, Name = fname, ExprText = a.Right.ToString(), File = rel, Line = a.GetLocation().GetLineSpan().StartLinePosition.Line + 1 });
        }
    }

    public static HashSet<string> LocalNames(SyntaxNode member)
    {
        var h = new HashSet<string>(StringComparer.Ordinal);
        foreach (var n in member.DescendantNodesAndSelf())
            switch (n)
            {
                case ParameterSyntax p: h.Add(p.Identifier.Text); break;
                case VariableDeclaratorSyntax v: h.Add(v.Identifier.Text); break;
                case SingleVariableDesignationSyntax sv: h.Add(sv.Identifier.Text); break;
                case ForEachStatementSyntax fe: h.Add(fe.Identifier.Text); break;
                case CatchDeclarationSyntax cd: h.Add(cd.Identifier.Text); break;
            }
        return h;
    }

    public static bool DeclaresLocalOrParam(SyntaxNode member, string name)
    {
        if (member is BaseMethodDeclarationSyntax bm && bm.ParameterList.Parameters.Any(p => p.Identifier.Text == name)) return true;
        if (member is LocalFunctionStatementSyntax lf && lf.ParameterList.Parameters.Any(p => p.Identifier.Text == name)) return true;
        if (member.DescendantNodes().OfType<VariableDeclaratorSyntax>().Any(v => v.Identifier.Text == name)) return true;
        if (member.DescendantNodes().OfType<SingleVariableDesignationSyntax>().Any(v => v.Identifier.Text == name)) return true;
        if (member.DescendantNodes().OfType<ForEachStatementSyntax>().Any(v => v.Identifier.Text == name)) return true;
        if (member.DescendantNodes().OfType<ParameterSyntax>().Any(v => v.Identifier.Text == name)) return true; // 람다
        if (member.DescendantNodes().OfType<CatchDeclarationSyntax>().Any(v => v.Identifier.Text == name)) return true;
        return false;
    }

    void AddField(FieldDeclarationSyntax f, string name, string expr, bool isConst, string rel)
    {
        var fi = new FieldInit { ClassFull = ClassFullOf(f), Name = name, ExprText = expr, IsConst = isConst, File = rel, Line = f.GetLocation().GetLineSpan().StartLinePosition.Line + 1 };
        Add(FieldsByClassField, ClassSimpleOf(f) + "." + name, fi);
        Add(FieldsByName, name, fi);
    }

    static void Add<T>(Dictionary<string, List<T>> d, string k, T v)
    {
        if (!d.TryGetValue(k, out var l)) d[k] = l = new List<T>();
        l.Add(v);
    }

    /// <summary>클래스와 그 조상(이름 기준) 목록</summary>
    public IEnumerable<string> SelfAndBases(string cls)
    {
        var seen = new HashSet<string>(StringComparer.Ordinal);
        var q = new Queue<string>(); q.Enqueue(cls);
        while (q.Count > 0)
        {
            var c = q.Dequeue();
            if (!seen.Add(c)) continue;
            yield return c;
            if (BaseTypes.TryGetValue(c, out var bs)) foreach (var b in bs) q.Enqueue(b);
        }
    }
}
