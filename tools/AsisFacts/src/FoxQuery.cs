using System.Text.RegularExpressions;
using System.Xml;
using System.Xml.Linq;

namespace AsisFacts;

public sealed class FoxEndpoint
{
    public string Key;          // foxml: NS.id  /  sqls: page#id[/child]
    public string Dialect;      // foxml | sqls
    public string Scope;        // NS 또는 pagePath
    public string Id;
    public string Element;      // procedure|statement|sql|insert-sql|update-sql|delete-sql|update-batch ...
    public string ParentId;
    public string MethodName;
    public string SpName;       // procedure 의 실 SP 명 (text 가 단일 식별자일 때)
    public string Text;
    public string File;
    public int Line;
    public bool Commented;
    public string Attrs;
    public List<Dictionary<string, string>> Params = new();
}

/// <summary>
/// FoxQuery 매핑 파서. XML 주석은 XComment 노드로만 판정한다.
/// 주석 안에 있는 엔드포인트는 Commented=true 로 별도 기록하고 활성 카탈로그에 넣지 않는다.
/// </summary>
public static class FoxQueryParser
{
    static readonly Regex SingleIdent = new(@"^\s*(?:EXEC(?:UTE)?\s+)?([\[\]\w\.#$@]+)\s*;?\s*$", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);
    static readonly HashSet<string> EndpointElems = new(StringComparer.OrdinalIgnoreCase)
        { "procedure", "statement", "sql", "update-batch", "insert-sql", "update-sql", "delete-sql", "select", "insert", "update", "delete" };

    public static List<FoxEndpoint> ParseAll(Config cfg, string asisRoot, List<string> errors)
    {
        var root = Path.Combine(asisRoot, Config.NormPath(cfg.foxQueryRoot));
        var list = new List<FoxEndpoint>();
        foreach (var f in SourceScan.Enumerate(cfg, root, ".foxml", ".xml"))
        {
            try { list.AddRange(ParseFile(root, asisRoot, f)); }
            catch (Exception ex) { errors.Add($"{SourceScan.Rel(asisRoot, f)}\t{ex.Message}"); }
        }
        return list;
    }

    public static List<FoxEndpoint> ParseFile(string foxRoot, string asisRoot, string file)
    {
        var (text, _) = TextIO.Read(file);
        var doc = XDocument.Parse(text, LoadOptions.SetLineInfo | LoadOptions.PreserveWhitespace);
        var rel = SourceScan.Rel(asisRoot, file);
        var result = new List<FoxEndpoint>();
        bool isFoxml = file.EndsWith(".foxml", StringComparison.OrdinalIgnoreCase);
        string scope = isFoxml
            ? Path.GetFileNameWithoutExtension(file)
            : SourceScan.Rel(foxRoot, file)[..^4]; // ".xml" 제거, '\' 구분 pagePath
        var dialect = isFoxml ? "foxml" : "sqls";

        // 활성 노드
        foreach (var el in doc.Descendants())
            if (IsEndpoint(el)) result.Add(Build(el, dialect, scope, rel, false, 0));

        // 주석 노드: 내용이 XML 이면 파싱해서, 아니면 id="..." 패턴만 (주석 텍스트 안에서만 적용)
        foreach (var c in doc.DescendantNodes().OfType<XComment>())
        {
            int baseLine = ((IXmlLineInfo)c).LineNumber;
            bool parsed = false;
            try
            {
                var frag = XElement.Parse("<__c>" + c.Value + "</__c>", LoadOptions.SetLineInfo);
                foreach (var el in frag.Descendants())
                    if (IsEndpoint(el)) { result.Add(Build(el, dialect, scope, rel, true, baseLine - 1)); parsed = true; }
            }
            catch (XmlException) { }
            if (!parsed)
                foreach (Match m in Regex.Matches(c.Value, @"<\s*(procedure|statement|sql|update-batch)\b[^>]*\bid\s*=\s*""([^""]+)""", RegexOptions.IgnoreCase))
                    result.Add(new FoxEndpoint
                    {
                        Dialect = dialect, Scope = scope, Id = m.Groups[2].Value.Trim(), Element = m.Groups[1].Value.ToLowerInvariant(),
                        Key = MakeKey(dialect, scope, m.Groups[2].Value.Trim(), null, null), File = rel, Line = baseLine, Commented = true, Text = ""
                    });
        }
        return result;
    }

    static bool IsEndpoint(XElement el)
    {
        var n = el.Name.LocalName;
        if (!EndpointElems.Contains(n)) return false;
        // insert-sql 등 하위 요소는 id 가 없어도 상위 update-batch 의 구성요소로 기록
        return el.Attribute("id") != null || (el.Parent != null && el.Parent.Name.LocalName.Equals("update-batch", StringComparison.OrdinalIgnoreCase));
    }

    public static string MakeKey(string dialect, string scope, string id, string parentId, string elem)
        => dialect == "foxml"
            ? $"{scope}.{(parentId != null ? parentId + "/" + elem : id)}"
            : $"{scope}#{(parentId != null ? parentId + "/" + elem : id)}";

    static FoxEndpoint Build(XElement el, string dialect, string scope, string rel, bool commented, int lineOffset)
    {
        var id = el.Attribute("id")?.Value?.Trim();
        string parentId = null;
        var elem = el.Name.LocalName.ToLowerInvariant();
        if (id == null && el.Parent != null) { parentId = el.Parent.Attribute("id")?.Value?.Trim() ?? "?"; id = parentId + "/" + elem; }
        var textEl = el.Elements().FirstOrDefault(e => e.Name.LocalName.Equals("text", StringComparison.OrdinalIgnoreCase));
        var text = textEl?.Value ?? "";
        if (textEl == null && !el.HasElements) text = el.Value;
        string sp = "";
        if (elem == "procedure")
        {
            var m = SingleIdent.Match(text);
            if (m.Success) sp = m.Groups[1].Value;
        }
        var ep = new FoxEndpoint
        {
            Dialect = dialect, Scope = scope, Id = id, Element = elem, ParentId = parentId,
            Key = MakeKey(dialect, scope, parentId == null ? id : null, parentId, elem),
            MethodName = el.Attribute("methodName")?.Value, SpName = sp, Text = text.Trim(),
            File = rel, Line = ((IXmlLineInfo)el).LineNumber + lineOffset, Commented = commented,
            Attrs = string.Join(";", el.Attributes().Select(a => a.Name.LocalName + "=" + a.Value))
        };
        var pars = el.Elements().FirstOrDefault(e => e.Name.LocalName.Equals("parameters", StringComparison.OrdinalIgnoreCase));
        if (pars != null)
            foreach (var p in pars.Elements())
                ep.Params.Add(p.Attributes().ToDictionary(a => a.Name.LocalName, a => a.Value, StringComparer.OrdinalIgnoreCase));
        return ep;
    }
}
