using System.Collections.Concurrent;
using System.Diagnostics;
using Microsoft.CodeAnalysis.CSharp;

namespace AsisFacts;

public static class Program
{
    public static int Main(string[] args)
    {
        Console.OutputEncoding = System.Text.Encoding.UTF8;
        string cfgPath = Path.Combine(AppContext.BaseDirectory, "asisfacts.json");
        string rootOverride = null, outOverride = null, only = null;
        var cmd = args.Length > 0 && !args[0].StartsWith("--") ? args[0] : "scan";
        for (int i = 0; i < args.Length; i++)
        {
            if (args[i] == "--config" && i + 1 < args.Length) cfgPath = args[++i];
            else if (args[i] == "--root" && i + 1 < args.Length) rootOverride = args[++i];
            else if (args[i] == "--out" && i + 1 < args.Length) outOverride = args[++i];
            else if (args[i] == "--only" && i + 1 < args.Length) only = args[++i];
        }
        var cfg = Config.Load(cfgPath);
        var root = Path.GetFullPath(Config.NormPath(rootOverride ?? cfg.asisRoot));
        var outDir = Path.GetFullPath(Config.NormPath(outOverride ?? cfg.outDir));
        if (cmd is "scan" or "pack" or "agent" && !Directory.Exists(root)) { Console.Error.WriteLine("asisRoot not found: " + root); return 2; }
        if (outDir.StartsWith(root.TrimEnd(Path.DirectorySeparatorChar) + Path.DirectorySeparatorChar, StringComparison.OrdinalIgnoreCase))
        { Console.Error.WriteLine("outDir 는 asisRoot 바깥이어야 합니다 (As-is 원본은 읽기 전용)."); return 2; }
        Directory.CreateDirectory(outDir);

        return cmd switch
        {
            "scan" => Scan.Run(cfg, root, outDir, only),
            "db" => DbExtract.Run(cfg, outDir),
            "grid" => DbGrid.Run(cfg, outDir, args.Contains("--plan-only")),
            "agent" => Agent.Run(cfg, outDir, args.Skip(1).Where(a => !a.StartsWith("--") && !IsOptValue(args, a)).ToList(), Opt(args, "--driver"), Opt(args, "--model"), Opt(args, "--agent-out"), Opt(args, "--phase")),
            "sqltest" => SqlTest(args[1]),
            "pack" => Pack.Run(cfg, root, outDir, args.Skip(1).Where(a => !a.StartsWith("--") && !IsOptValue(args, a)).ToList()),
            _ => Usage()
        };
    }

    /// <summary>개발용: SQL 파일 하나의 참조/분기 분석 결과 출력</summary>
    static int SqlTest(string file)
    {
        var sql = TextIO.Read(file).text;
        var r = SqlAnalyzer.Analyze(sql);
        Console.WriteLine($"mode={r.Mode} err={r.ParseError}");
        foreach (var x in r.Refs) Console.WriteLine($"  {x.Kind}\t{x.Access}\t{x.Name}\tL{x.Line}");
        foreach (var b in SqlAnalyzer.Branches(sql, out var e)) Console.WriteLine($"  IF {b.Variable}='{b.Value}' L{b.Line}: " + string.Join(", ", b.Refs.Select(x => x.Access + ":" + x.Name)));
        return 0;
    }

    static string Opt(string[] args, string name) { var i = Array.IndexOf(args, name); return i >= 0 && i + 1 < args.Length ? args[i + 1] : null; }

    static bool IsOptValue(string[] args, string a)
    {
        var i = Array.IndexOf(args, a);
        return i > 0 && args[i - 1].StartsWith("--");
    }

    static int Usage()
    {
        Console.WriteLine("AsisFacts scan [--config path] [--root asisRoot] [--out outDir] [--only relPathPrefix]");
        Console.WriteLine("AsisFacts db [--config path] [--out outDir]   (As-is MSSQL 카탈로그·메타 추출, SELECT 전용)");
        Console.WriteLine("AsisFacts grid [--plan-only]   (division×sheet Grid 정의: 쓰기 없는 *_SPREAD_TITLE SP 를 트랜잭션 내 실행 후 ROLLBACK)");
        Console.WriteLine("AsisFacts agent 화면ID... [--driver claude-cli|api|dry] [--model m] [--agent-out dir] [--phase all|analysis|docs]   (Fact Pack → 분석서 5종 + 업무분석서·화면설계서·단위테스트 + 건수 게이트)");
        Console.WriteLine("AsisFacts pack [화면ID ...] [--config path] [--out outDir]   (인자 없으면 전체 화면)");
        return 1;
    }
}

public static class Scan
{
    public static int Run(Config cfg, string root, string outDir, string only)
    {
        var sw = Stopwatch.StartNew();
        var log = new List<string>();
        void Log(string s) { Console.WriteLine($"[{sw.Elapsed:mm\\:ss}] {s}"); log.Add(s); }

        // ── 0. 파일 인벤토리
        var csFiles = SourceScan.Enumerate(cfg, root, ".cs");
        var csprojs = SourceScan.Enumerate(cfg, root, ".csproj");
        var projMap = SourceScan.ProjectMap(root, csprojs);
        var extractFiles = only == null ? null : new HashSet<string>(csFiles.Where(f => SourceScan.Rel(root, f).StartsWith(only, StringComparison.OrdinalIgnoreCase)), StringComparer.Ordinal);
        Log($"cs files: {csFiles.Count}, csproj: {csprojs.Count}");

        // ── 1. FoxQuery
        var foxErr = new List<string>();
        var cat = FoxQueryParser.ParseAll(cfg, root, foxErr);
        Log($"foxquery endpoints: active {cat.Count(c => !c.Commented)}, commented {cat.Count(c => c.Commented)}, file errors {foxErr.Count}");
        WriteFox(outDir, cat, foxErr);

        // ── 2. 1차 패스: 색인
        var popt = CsIndex.ParseOptions(cfg);
        var ix = new CsIndex();
        var files = new ConcurrentBag<SourceFile>();
        var ixLock = new object();
        Parallel.ForEach(csFiles, new ParallelOptions { MaxDegreeOfParallelism = Environment.ProcessorCount }, f =>
        {
            var rel = SourceScan.Rel(root, f);
            var (text, enc) = TextIO.Read(f);
            var sf = new SourceFile
            {
                FullPath = f, RelPath = rel, Layer = rel.Split('\\')[0], Project = SourceScan.NearestProject(projMap, f, root),
                ScreenId = SourceScan.ScreenIdOf(cfg, rel), Encoding = enc, Sha256 = TextIO.Sha256(f), Lines = text.Count(c => c == '\n') + 1
            };
            files.Add(sf);
            var tree = CSharpSyntaxTree.ParseText(text, popt, path: rel);
            lock (ixLock) ix.AddFile(tree, rel);
        });
        Log($"index: methods {ix.MethodsByName.Values.Sum(l => l.Count)}, fields {ix.FieldsByClassField.Count}, biz {ix.BizMethods.Count}");

        // ── 3. 2차 패스: 사실 추출 (파일별 즉시 출력)
        var linker = new Linker(ix, cat, cfg.sinks.requestParams);
        var streams = new Streams(outDir, linker);
        var all = new ConcurrentBag<(SourceFile sf, FileFacts ff)>();
        var fileList = files.Where(f => extractFiles == null || extractFiles.Contains(f.FullPath)).OrderBy(f => f.RelPath, StringComparer.Ordinal).ToList();
        Parallel.ForEach(fileList, new ParallelOptions { MaxDegreeOfParallelism = Environment.ProcessorCount },
            () => new CsExtractor(cfg, ix),
            (sf, _, ex) =>
            {
                var (text, _) = TextIO.Read(sf.FullPath);
                var tree = CSharpSyntaxTree.ParseText(text, popt, path: sf.RelPath);
                var ff = ex.Extract(tree, sf.RelPath);
                streams.Write(sf, ff);
                all.Add((sf, ff));
                return ex;
            }, _ => { });
        streams.Dispose();
        var facts = all.OrderBy(x => x.sf.RelPath, StringComparer.Ordinal).ToList();
        var sites = facts.SelectMany(x => x.ff.Sites).ToList();
        var calls = facts.SelectMany(x => x.ff.Calls).ToList();
        Log($"extract: sites {sites.Count} (commented {sites.Count(s => s.Commented)}, inactive {sites.Count(s => !s.Active)}), calls {calls.Count}");

        // ── 4. 결합 + 전파
        Linker.AttachReqParams(sites);
        GC.Collect();
        Log($"memory after extract: {GC.GetTotalMemory(true) / 1024 / 1024} MB");
        var allSites = linker.Propagate(sites, calls, log);
        Log($"sites after propagation: {allSites.Count}");

        // ── 5. 출력
        Output.Write(outDir, root, facts, allSites, calls, linker, ix);
        File.WriteAllLines(Path.Combine(outDir, "_run.log"), log);
        Log($"done → {outDir}");
        return 0;
    }

    static void WriteFox(string outDir, List<FoxEndpoint> cat, List<string> errs)
    {
        var sqlDir = Path.Combine(outDir, "foxquery_sql");
        Directory.CreateDirectory(sqlDir);
        using var w = new CsvOut(Path.Combine(outDir, "foxquery_endpoints.csv"), "key", "dialect", "scope", "id", "element", "parent_id", "method_name", "sp_name", "param_count", "text_sha", "text_file", "file", "line", "commented", "dup_count", "attrs");
        using var wp = new CsvOut(Path.Combine(outDir, "foxquery_params.csv"), "key", "commented", "seq", "name", "property", "db_type", "size", "direction", "replace_what", "attrs");
        using var wr = new CsvOut(Path.Combine(outDir, "foxquery_sql_refs.csv"), "key", "ref_kind", "name", "raw", "access", "line_in_text", "parse_mode", "parse_error");
        var dup = cat.Where(c => !c.Commented).GroupBy(c => c.Key, StringComparer.OrdinalIgnoreCase).ToDictionary(g => g.Key, g => g.Count(), StringComparer.OrdinalIgnoreCase);
        foreach (var e in cat)
        {
            string tf = "";
            if (!string.IsNullOrEmpty(e.Text) && string.IsNullOrEmpty(e.SpName))
            {
                tf = Path.Combine("foxquery_sql", Safe(e.Key) + (e.Commented ? ".commented" : "") + ".sql");
                File.WriteAllText(Path.Combine(outDir, tf), e.Text, new System.Text.UTF8Encoding(true));
            }
            w.Row(e.Key, e.Dialect, e.Scope, e.Id, e.Element, e.ParentId, e.MethodName, e.SpName, e.Params.Count, TextIO.Sha256Text(e.Text), tf, e.File, e.Line, e.Commented, e.Commented ? 0 : dup[e.Key], e.Attrs);
            int i = 0;
            foreach (var p in e.Params)
            {
                string G(string k) => p.TryGetValue(k, out var v) ? v : "";
                wp.Row(e.Key, e.Commented, ++i, G("name"), G("property"), G("dbType"), G("size") + G("dbLen"), G("direction"), G("replace-what"), string.Join(";", p.Select(kv => kv.Key + "=" + kv.Value)));
            }
            if (!e.Commented && !string.IsNullOrEmpty(e.Text))
            {
                if (!string.IsNullOrEmpty(e.SpName)) { wr.Row(e.Key, "EXEC", SqlAnalyzer.NormName(e.SpName), e.SpName, "EXEC", 1, "procedure", ""); continue; }
                var r = SqlAnalyzer.Analyze(e.Text);
                foreach (var rf in r.Refs) wr.Row(e.Key, rf.Kind, rf.Name, rf.Raw, rf.Access, rf.Line, r.Mode, r.ParseError);
                if (r.Refs.Count == 0) wr.Row(e.Key, "NONE", "", "", "", 0, r.Mode, r.ParseError);
            }
        }
        File.WriteAllLines(Path.Combine(outDir, "foxquery_errors.txt"), errs);
    }

    static string Safe(string s) => string.Concat(s.Select(c => Path.GetInvalidFileNameChars().Contains(c) || c == '\\' || c == '/' || c == '#' ? '_' : c));
}
