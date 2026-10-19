using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;

namespace AsisFacts;

public sealed class SinkCtor { public string type { get; set; } public int arg { get; set; } public int arg2 { get; set; } = -1; public string kind { get; set; } }
public sealed class SinkInvoke { public string method { get; set; } public int arg { get; set; } public int arg2 { get; set; } = -1; public string kind { get; set; } public bool stringOnly { get; set; } }
public sealed class SinkProp { public string property { get; set; } public string kind { get; set; } }
public sealed class SinkConfig
{
    public List<SinkCtor> ctor { get; set; } = new();
    public List<SinkInvoke> invoke { get; set; } = new();
    public List<SinkProp> propertyAssign { get; set; } = new();
    public List<string> requestParams { get; set; } = new();
}

public sealed class DbConfig
{
    public string envFile { get; set; }
    public Dictionary<string, string> envKeys { get; set; } = new();
    public string server { get; set; }
    public string database { get; set; }
    public string user { get; set; }
    public bool integratedSecurity { get; set; }
    public int commandTimeoutSec { get; set; } = 300;
    public List<string> metaSourceModules { get; set; } = new();
    public List<string> metaTablePatterns { get; set; } = new();
    public List<string> metaTables { get; set; } = new();
    public int maxRowsPerTable { get; set; } = 300000;
    // 3단계 Grid 전개: 실행 대상 SP 이름 패턴, 파라미터 기본값(이름 소문자 기준)
    public List<string> gridSpPatterns { get; set; } = new() { "%SPREAD_TITLE%", "%SPD_TITLE%" };
    public Dictionary<string, string> gridParamDefaults { get; set; } = new(StringComparer.OrdinalIgnoreCase);
    public string gridUser { get; set; } = "__ASISFACTS__";
    public int gridExecTimeoutSec { get; set; } = 60;
    // Grid 메타 규칙 전개 대상 (DIVISION_ID 빈값=전체, VISIBLE_FLAG/VALID_YN='Y', USER_SELECTABLE_FLAG='N'=필수, DEFAULT_FLAG='Y'=기본)
    public List<string> gridMetaTables { get; set; } = new() { "SCM_MST_SHEET_COLUMNS", "SCM_MST_SHEET_MEASURE" };
}

public sealed class Config
{
    public DbConfig db { get; set; } = new();
    public string asisRoot { get; set; }
    public string outDir { get; set; }
    public string foxQueryRoot { get; set; } = "04.WSL\\FoxQuery";
    public List<string> preprocessorSymbols { get; set; } = new() { "TRACE" };
    public List<string> excludeDirs { get; set; } = new();
    public List<string> screenIdPatterns { get; set; } = new();
    public SinkConfig sinks { get; set; } = new();
    /// <summary>코드로 Grid 컬럼/헤더/시트를 정의하는 API (하드코딩 Grid 추출 대상)</summary>
    public List<string> gridApiPatterns { get; set; } = new();

    public static Config Load(string path)
    {
        var json = File.ReadAllText(path, Encoding.UTF8);
        var cfg = JsonSerializer.Deserialize<Config>(json, new JsonSerializerOptions { ReadCommentHandling = JsonCommentHandling.Skip, AllowTrailingCommas = true });
        return cfg ?? throw new InvalidDataException("config parse failed: " + path);
    }

    /// <summary>Windows 경로 표기(\)를 OS 구분자로 변환</summary>
    public static string NormPath(string p) => p?.Replace('\\', Path.DirectorySeparatorChar).Replace('/', Path.DirectorySeparatorChar);
}

public static class TextIO
{
    static TextIO() { Encoding.RegisterProvider(CodePagesEncodingProvider.Instance); }
    static readonly UTF8Encoding StrictUtf8 = new(false, true);

    /// <summary>BOM 우선 → UTF-8 strict → CP949 순으로 디코드. 손실 디코드는 하지 않는다.</summary>
    public static (string text, string encoding) Read(string path)
    {
        var bytes = File.ReadAllBytes(path);
        if (bytes.Length >= 3 && bytes[0] == 0xEF && bytes[1] == 0xBB && bytes[2] == 0xBF)
            return (StrictUtf8.GetString(bytes, 3, bytes.Length - 3), "utf-8-bom");
        if (bytes.Length >= 2 && bytes[0] == 0xFF && bytes[1] == 0xFE)
            return (Encoding.Unicode.GetString(bytes, 2, bytes.Length - 2), "utf-16le");
        if (bytes.Length >= 2 && bytes[0] == 0xFE && bytes[1] == 0xFF)
            return (Encoding.BigEndianUnicode.GetString(bytes, 2, bytes.Length - 2), "utf-16be");
        try { return (StrictUtf8.GetString(bytes), "utf-8"); }
        catch (DecoderFallbackException) { }
        return (Encoding.GetEncoding(949).GetString(bytes), "cp949");
    }

    public static string Sha256(string path)
    {
        using var s = File.OpenRead(path);
        return Convert.ToHexString(SHA256.HashData(s)).ToLowerInvariant();
    }

    public static string Sha256Text(string t) => Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(t ?? ""))).ToLowerInvariant();
}

/// <summary>RFC4180 CSV (UTF-8 BOM, Excel 호환). 모든 값 인용.</summary>
public sealed class CsvOut : IDisposable
{
    readonly StreamWriter _w;
    readonly int _cols;
    public int Rows { get; private set; }
    public CsvOut(string path, params string[] header)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path)!);
        _w = new StreamWriter(path, false, new UTF8Encoding(true)) { NewLine = "\r\n" };
        _cols = header.Length;
        WriteRaw(header);
    }
    void WriteRaw(IReadOnlyList<object> vals)
    {
        var sb = new StringBuilder();
        for (int i = 0; i < vals.Count; i++)
        {
            if (i > 0) sb.Append(',');
            var s = vals[i] switch { null => "", bool b => b ? "1" : "0", _ => Convert.ToString(vals[i], System.Globalization.CultureInfo.InvariantCulture) };
            sb.Append('"').Append(s.Replace("\"", "\"\"")).Append('"');
        }
        _w.WriteLine(sb.ToString());
    }
    public void Row(params object[] vals)
    {
        if (vals.Length != _cols) throw new InvalidOperationException($"CSV column mismatch {vals.Length}/{_cols}");
        WriteRaw(vals); Rows++;
    }
    public void Dispose() => _w.Dispose();
}

public sealed class SourceFile
{
    public string FullPath;
    public string RelPath;      // asisRoot 기준, '\' 구분
    public string Layer;        // 최상위 폴더
    public string Project;      // 가장 가까운 csproj (상대경로)
    public string ScreenId;
    public string Encoding;
    public string Sha256;
    public int Lines;
    public string Text;
}

public static class SourceScan
{
    public static List<string> Enumerate(Config cfg, string root, params string[] exts)
    {
        var ex = new HashSet<string>(cfg.excludeDirs, StringComparer.OrdinalIgnoreCase);
        var result = new List<string>();
        var stack = new Stack<string>();
        stack.Push(root);
        while (stack.Count > 0)
        {
            var d = stack.Pop();
            foreach (var sub in Directory.EnumerateDirectories(d))
                if (!ex.Contains(Path.GetFileName(sub))) stack.Push(sub);
            foreach (var f in Directory.EnumerateFiles(d))
                if (exts.Any(e => f.EndsWith(e, StringComparison.OrdinalIgnoreCase))) result.Add(f);
        }
        result.Sort(StringComparer.Ordinal);
        return result;
    }

    public static string Rel(string root, string full) => Path.GetRelativePath(root, full).Replace('/', '\\');

    public static string ScreenIdOf(Config cfg, string rel)
    {
        // 파일명 → 상위 폴더 순으로 탐색 (가장 가까운 것 우선)
        var parts = rel.Split('\\');
        var regs = cfg.screenIdPatterns.Select(p => new Regex(p, RegexOptions.CultureInvariant)).ToList();
        for (int i = parts.Length - 1; i >= 0; i--)
            foreach (var r in regs)
            {
                var m = r.Match(parts[i].ToUpperInvariant());
                if (m.Success) return m.Groups[1].Value;
            }
        return "";
    }

    public static Dictionary<string, string> ProjectMap(string root, IEnumerable<string> csprojs)
    {
        // 디렉터리 → csproj 상대경로
        var map = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        foreach (var p in csprojs) map[Path.GetDirectoryName(p)!] = Rel(root, p);
        return map;
    }

    public static string NearestProject(Dictionary<string, string> map, string file, string root)
    {
        var d = Path.GetDirectoryName(file);
        while (d != null && d.Length >= root.Length)
        {
            if (map.TryGetValue(d, out var p)) return p;
            d = Path.GetDirectoryName(d);
        }
        return "";
    }
}
