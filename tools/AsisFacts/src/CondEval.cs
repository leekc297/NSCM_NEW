using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace AsisFacts;

/// <summary>
/// division 값에 대한 분기 조건 3값 평가 (true / false / null=판단불가).
/// division 을 담는 식: 이름에 'div' 가 들어간 식별자/멤버 (division, sDivision, cboDivision.Value …) 와 그 Substring/Trim/ToUpper.
/// 지원: 리터럴 bool, !, &&, ||, ==, !=, .Equals("x"), .StartsWith/EndsWith/Contains("x"), string.Equals(a,b), switch case 라벨.
/// 그 외는 판단불가로 남긴다 (추측하지 않음).
/// </summary>
public static class CondEval
{
    public static bool? Eval(string expr, string div, string sheet = null)
    {
        if (string.IsNullOrWhiteSpace(expr)) return null;
        var e = SyntaxFactory.ParseExpression(expr);
        _sheet = sheet;
        return E(e, div);
    }

    [ThreadStatic] static string _sheet;

    static bool? E(ExpressionSyntax e, string div)
    {
        switch (e)
        {
            case LiteralExpressionSyntax l when l.IsKind(SyntaxKind.TrueLiteralExpression): return true;
            case LiteralExpressionSyntax l when l.IsKind(SyntaxKind.FalseLiteralExpression): return false;
            case ParenthesizedExpressionSyntax p: return E(p.Expression, div);
            case PrefixUnaryExpressionSyntax u when u.IsKind(SyntaxKind.LogicalNotExpression): return E(u.Operand, div) is bool nb ? !nb : null;
            case BinaryExpressionSyntax b when b.IsKind(SyntaxKind.LogicalAndExpression):
                { var l = E(b.Left, div); var r = E(b.Right, div); if (l == false || r == false) return false; if (l == true && r == true) return true; return null; }
            case BinaryExpressionSyntax b when b.IsKind(SyntaxKind.LogicalOrExpression):
                { var l = E(b.Left, div); var r = E(b.Right, div); if (l == true || r == true) return true; if (l == false && r == false) return false; return null; }
            case BinaryExpressionSyntax b when b.IsKind(SyntaxKind.EqualsExpression) || b.IsKind(SyntaxKind.NotEqualsExpression):
                {
                    var eq = Cmp(b.Left, b.Right, div) ?? Cmp(b.Right, b.Left, div);
                    if (eq == null) return null;
                    return b.IsKind(SyntaxKind.EqualsExpression) ? eq : !eq;
                }
            case InvocationExpressionSyntax inv when inv.Expression is MemberAccessExpressionSyntax ma && inv.ArgumentList.Arguments.Count >= 1:
                {
                    var m = ma.Name.Identifier.Text;
                    if ((ma.Expression.ToString() is "string" or "String") && m == "Equals" && inv.ArgumentList.Arguments.Count >= 2)
                        return Cmp(inv.ArgumentList.Arguments[0].Expression, inv.ArgumentList.Arguments[1].Expression, div) ?? Cmp(inv.ArgumentList.Arguments[1].Expression, inv.ArgumentList.Arguments[0].Expression, div);
                    var lit = Lit(inv.ArgumentList.Arguments[0].Expression);
                    if (_sheet != null && lit != null && m == "Equals" && ma.Expression.ToString().EndsWith("SheetName", StringComparison.OrdinalIgnoreCase))
                        return string.Equals(_sheet, lit, StringComparison.OrdinalIgnoreCase);
                    var v = DivVal(ma.Expression, div);
                    if (v == null || lit == null) return null;
                    return m switch
                    {
                        "Equals" => v == lit,
                        "StartsWith" => v.StartsWith(lit, StringComparison.Ordinal),
                        "EndsWith" => v.EndsWith(lit, StringComparison.Ordinal),
                        "Contains" => v.Contains(lit, StringComparison.Ordinal),
                        _ => null
                    };
                }
        }
        return null;
    }

    static bool? Cmp(ExpressionSyntax a, ExpressionSyntax b, string div)
    {
        var l = Lit(b);
        if (_sheet != null && l != null && a.ToString().EndsWith("SheetName", StringComparison.OrdinalIgnoreCase))
            return string.Equals(_sheet, l, StringComparison.OrdinalIgnoreCase);
        var v = DivVal(a, div);
        return v == null || l == null ? null : v == l;
    }

    static string Lit(ExpressionSyntax e) => e is LiteralExpressionSyntax l && l.IsKind(SyntaxKind.StringLiteralExpression) ? l.Token.ValueText : null;

    /// <summary>division 을 담는 식이면 그 값(가공 포함), 아니면 null</summary>
    static string DivVal(ExpressionSyntax e, string div)
    {
        switch (e)
        {
            case ParenthesizedExpressionSyntax p: return DivVal(p.Expression, div);
            case IdentifierNameSyntax or MemberAccessExpressionSyntax when e.ToString().Contains("div", StringComparison.OrdinalIgnoreCase) && !e.ToString().Contains("("):
                return div;
            case InvocationExpressionSyntax inv when inv.Expression is MemberAccessExpressionSyntax ma:
                {
                    var inner = DivVal(ma.Expression, div);
                    if (inner == null)
                    {
                        // cboDivision.GetValue() 처럼 div 이름의 값 조회 메서드
                        if (ma.Expression.ToString().Contains("div", StringComparison.OrdinalIgnoreCase) && inv.ArgumentList.Arguments.Count == 0 && ma.Name.Identifier.Text is "ToString" or "GetValue" or "Trim")
                            return div;
                        return null;
                    }
                    var name = ma.Name.Identifier.Text;
                    var args = inv.ArgumentList.Arguments;
                    if (name is "Trim" or "ToString") return inner.Trim();
                    if (name is "ToUpper" or "ToUpperInvariant") return inner.ToUpperInvariant();
                    if (name == "Substring" && args.Count >= 1 && int.TryParse(args[0].Expression.ToString(), out var st))
                    {
                        if (st >= inner.Length) return "";
                        if (args.Count == 2 && int.TryParse(args[1].Expression.ToString(), out var ln)) return inner.Substring(st, Math.Min(ln, inner.Length - st));
                        return inner[st..];
                    }
                    return null;
                }
        }
        return null;
    }

    static readonly System.Text.RegularExpressions.Regex SheetLit = new("SheetName\\s*(?:==|\\.Equals\\()\\s*\"([^\"]+)\"");
    /// <summary>조건식에서 시트명 리터럴 추출 (SheetName == "X" / .Equals("X"))</summary>
    public static IEnumerable<string> SheetLiterals(string conditions)
    {
        foreach (System.Text.RegularExpressions.Match m in SheetLit.Matches(conditions ?? "")) yield return m.Groups[1].Value;
    }

    /// <summary>"if(c) ⟫ else!(c) ⟫ switch(x)case A/B ⟫ foreach(...)" 체인 평가. 반복문은 무시.</summary>
    public static bool? Chain(string conditions, string div, string sheet = null)
    {
        if (string.IsNullOrWhiteSpace(conditions)) return true;
        bool? acc = true;
        foreach (var part in conditions.Split(" ⟫ "))
        {
            bool? v;
            if (part.StartsWith("if(")) v = Eval(part[3..^1], div, sheet);
            else if (part.StartsWith("else!(")) v = Eval(part[6..^1], div, sheet) is bool b ? !b : null;
            else if (part.StartsWith("switch("))
            {
                var close = part.IndexOf(")case ");
                if (close < 0) { v = null; }
                else
                {
                    var sw = part[7..close];
                    var labels = part[(close + 6)..].Split('/');
                    var any = labels.Select(l => Eval($"({sw}) == {l}", div, sheet)).ToList();
                    v = any.Any(x => x == true) ? true : any.All(x => x == false) ? false : null;
                }
            }
            else continue; // foreach / for / while
            if (v == false) return false;
            if (v == null) acc = null;
        }
        return acc;
    }
}
