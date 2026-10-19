using System.Text;
using System.Text.RegularExpressions;

namespace AsisFacts;

/// <summary>
/// 정적 문자열 값 후보. 리터럴 부분과 자리표시자(파라미터/미해결)를 함께 가진다.
///   \u0001P{index}:{name}\u0001  → 메서드 파라미터
///   \u0001?{expr}\u0001         → 정적으로 결정 불가
/// </summary>
public static class Val
{
    public const char M = '\u0001';
    public const int MaxCandidates = 64;

    public static string Param(int idx, string name) => $"{M}P{idx}:{name}{M}";
    public static string Unknown(string expr) => $"{M}?{Clean(expr)}{M}";
    static string Clean(string s) { s = Regex.Replace(s ?? "", @"\s+", " "); return s.Length > 120 ? s[..120] + "…" : s.Replace(M, ' '); }

    public static bool IsLiteral(string v) => v.IndexOf(M) < 0;
    public static bool HasParam(string v) => v.Contains(M + "P");
    public static bool HasUnknown(string v) => v.Contains(M + "?");

    static readonly Regex Ph = new("\u0001(P(\\d+):([^\u0001]*)|\\?[^\u0001]*)\u0001");

    public static IEnumerable<(int idx, string name)> Params(string v)
    {
        foreach (Match m in Ph.Matches(v)) if (m.Groups[2].Success) yield return (int.Parse(m.Groups[2].Value), m.Groups[3].Value);
    }

    /// <summary>사람이 읽는 형태: {p:name}, {?expr}</summary>
    public static string Show(string v) => Ph.Replace(v, m => m.Groups[2].Success ? "{p:" + m.Groups[3].Value + "}" : "{" + m.Groups[1].Value + "}");

    /// <summary>자리표시자를 와일드카드로 바꾼 정규식 (카탈로그 패턴 매칭용)</summary>
    public static Regex ToPattern(string v)
    {
        var sb = new StringBuilder("^");
        int last = 0;
        foreach (Match m in Ph.Matches(v)) { sb.Append(Regex.Escape(v[last..m.Index])); sb.Append(".+"); last = m.Index + m.Length; }
        sb.Append(Regex.Escape(v[last..])).Append('$');
        return new Regex(sb.ToString(), RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);
    }

    /// <summary>파라미터 자리표시자를 실제 인자 값으로 치환 (인덱스 또는 이름 기준)</summary>
    public static List<string> Substitute(string template, Func<int, string, List<string>> argValues)
    {
        var outs = new List<string> { "" };
        int last = 0;
        foreach (Match m in Ph.Matches(template))
        {
            var lit = template[last..m.Index];
            List<string> rep;
            if (m.Groups[2].Success) rep = argValues(int.Parse(m.Groups[2].Value), m.Groups[3].Value) ?? new List<string> { m.Value };
            else rep = new List<string> { m.Value };
            outs = Cross(outs.Select(o => o + lit).ToList(), rep);
            last = m.Index + m.Length;
        }
        var tail = template[last..];
        return outs.Select(o => o + tail).Distinct().ToList();
    }

    public static List<string> Cross(List<string> a, List<string> b)
    {
        var r = new List<string>();
        foreach (var x in a) foreach (var y in b) { r.Add(x + y); if (r.Count >= MaxCandidates) return r; }
        return r;
    }

    public static string Join(IEnumerable<string> vals) => string.Join(" || ", vals.Select(Show));
}
