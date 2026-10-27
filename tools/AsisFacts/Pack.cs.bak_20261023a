using System.Text;

namespace AsisFacts;

/// <summary>
/// 화면별 Fact Pack: scan 출력 CSV 를 화면ID 기준으로 모아 화면 폴더(요약 MD + CSV)로 만든다. 소스 재파싱 없음.
///   AsisFacts pack                 → 전체 화면 + screens\_index.csv
///   AsisFacts pack DMF0052 DMF0021 → 지정 화면만
/// </summary>
public static class Pack
{
    sealed class Ep { public string Key, Element, Sp, TextFile, File; public int Params; }
    sealed class Use { public string File, Cls, Member, Line, SiteKind, Kind, Cand, Key, Status, Detail, Via, Active, Commented; }
    sealed class Mem { public string File, Cls, Name, Kind, Mods, Params; public int Line, End; }
    sealed class Call { public string File, Cls, Member, Line, Callee, Recv; }
    sealed class Scr
    {
        public string Id;
        public List<Dictionary<string, string>> Files = new(), Events = new(), Controls = new(), Meta = new(), Props = new();
        public List<Use> Uses = new();
        public List<Mem> Mems = new();
        public List<Call> Calls = new();
        public List<GridCode.Row> Grid = new();
    }

    static Dictionary<string, List<(string owner, SortedSet<string> cols)>> _fwMeta = new();
    static List<string> _metaFiles = new();
    static readonly Dictionary<string, string> _gridModes = new();

    // ───────────── DB (2단계 결과가 있으면 결합) ─────────────
    static bool _dbLoaded;
    static readonly Dictionary<string, string> _dbObj = new(StringComparer.OrdinalIgnoreCase);                 // NAME → type
    static readonly Dictionary<string, List<(string kind, string name, string access)>> _modRefs = new(StringComparer.OrdinalIgnoreCase);
    static readonly Dictionary<string, List<(string module, string name, string access)>> _branchByValue = new(StringComparer.OrdinalIgnoreCase);

    static void LoadDb(string outDir)
    {
        var d = Path.Combine(outDir, "db");
        if (!File.Exists(Path.Combine(d, "db_objects.csv"))) return;
        foreach (var r in CsvIn.Read(Path.Combine(d, "db_objects.csv"))) _dbObj[r["name"]] = r["type"].Trim();
        foreach (var r in CsvIn.Read(Path.Combine(d, "db_module_refs.csv")))
        {
            if (r["ref_kind"] is "NONE" or "ENCRYPTED") continue;
            var m = r["module"].Split('.').Last();
            if (!_modRefs.TryGetValue(m, out var l)) _modRefs[m] = l = new();
            l.Add((r["ref_kind"], r["name"], r["access"]));
        }
        if (File.Exists(Path.Combine(d, "db_code_branches.csv")))
            foreach (var r in CsvIn.Read(Path.Combine(d, "db_code_branches.csv")))
            {
                if (r["ref_kind"] == "NONE") continue;
                if (!_branchByValue.TryGetValue(r["value"], out var l)) _branchByValue[r["value"]] = l = new();
                l.Add((r["module"].Split('.').Last(), r["name"], r["access"]));
            }
        _dbLoaded = true;
    }

    /// <summary>SP 내부 참조를 EXEC 체인까지 전이적으로 펼침 (테이블/함수/동적SQL)</summary>
    static List<string> SpClosure(string sp, int maxDepth = 6)
    {
        var res = new List<string>();
        var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        var q = new Queue<(string, int)>(); q.Enqueue((SqlAnalyzer.NormName(sp), 0));
        while (q.Count > 0)
        {
            var (m, dep) = q.Dequeue();
            if (!seen.Add(m) || !_modRefs.TryGetValue(m, out var refs)) continue;
            foreach (var (kind, name, access) in refs)
            {
                var t = kind == "EXEC" ? $"EXEC:{name}" : kind == "DYNAMIC" ? $"DYNAMIC@{m}" : $"{access}:{name}";
                if (!res.Contains(t)) res.Add(t);
                if ((kind == "EXEC" || kind == "FUNC") && dep < maxDepth) q.Enqueue((name, dep + 1));
            }
        }
        return res;
    }

    /// <summary>메타 테이블 행 중 셀 값이 화면ID(또는 화면ID_ 접두)인 행을 화면별로 모음</summary>
    static Dictionary<string, List<(string table, (string[] header, List<object[]> rows) data)>> ScreenMetaRows(string outDir, HashSet<string> ids)
    {
        var res = new Dictionary<string, List<(string, (string[], List<object[]>))>>();
        var metaDir = Path.Combine(outDir, "db", "meta");
        if (!Directory.Exists(metaDir)) return res;
        foreach (var f in Directory.EnumerateFiles(metaDir, "*.csv"))
        {
            var tbl = Path.GetFileNameWithoutExtension(f);
            string[] header = null;
            var buckets = new Dictionary<string, List<object[]>>();
            foreach (var r in CsvIn.Read(f))
            {
                header ??= r.Keys.ToArray();
                var hit = new HashSet<string>();
                foreach (var v in r.Values)
                {
                    if (string.IsNullOrEmpty(v) || v.Length < 6) continue;
                    var u = v.Trim().ToUpperInvariant();
                    if (ids.Contains(u)) hit.Add(u);
                    else { var us = u.IndexOf('_'); if (us > 0 && ids.Contains(u[..us])) hit.Add(u[..us]); }
                }
                foreach (var id in hit)
                {
                    if (!buckets.TryGetValue(id, out var l)) buckets[id] = l = new();
                    l.Add(r.Values.Cast<object>().ToArray());
                }
            }
            foreach (var (id, rows) in buckets)
            {
                if (!res.TryGetValue(id, out var l)) res[id] = l = new();
                l.Add((tbl, (header, rows)));
            }
        }
        return res;
    }
    static readonly HashSet<string> NonControlTypes = new(StringComparer.Ordinal) { "Size", "SizeF", "Point", "PointF", "Padding", "Font", "Color", "Container", "Rectangle" };
    static readonly HashSet<string> HideStatus = new() { "EMPTY", "WRAPS_FOX_REQUEST" };
    static readonly HashSet<string> EntryOverrides = new(StringComparer.Ordinal)
        { "FindButton", "SaveButton", "InsertButton", "DeleteButton", "EditButton", "ExcelButton", "SortButton", "FilterButton", "ConditionButton", "ResetConditionButton", "HelpButton" };

    public static int Run(Config cfg, string root, string outDir, List<string> ids)
    {
        var want = ids.Count == 0 ? null : new HashSet<string>(ids.Select(i => i.ToUpperInvariant()));
        bool Want(string s) => !string.IsNullOrEmpty(s) && (want == null || want.Contains(s));
        string P(string f) => Path.Combine(outDir, f);
        if (!File.Exists(P("files.csv"))) { Console.Error.WriteLine("scan 결과가 없습니다: " + outDir); return 2; }

        var scr = new Dictionary<string, Scr>(StringComparer.Ordinal);
        Scr S(string id) { if (!scr.TryGetValue(id, out var s)) scr[id] = s = new Scr { Id = id }; return s; }

        // 프로그램ID 별칭: 파일명 패턴에 화면ID 가 없는 공통/관리 화면(GSCM_USERINFO → GSCM.SystemMgmt.UIL.UserInfo 등)은
        // As-is 메타 TB_FX_ProgramInfo(ProgramID ↔ ClassName) 로 screen_id 를 보정한다. (파일 stem == ClassName 마지막 토큰)
        var alias = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        var progInfo = Path.Combine(outDir, "db", "meta", "dbo.TB_FX_ProgramInfo.csv");
        if (File.Exists(progInfo))
            foreach (var r in CsvIn.Read(progInfo))
            {
                var cls = r.GetValueOrDefault("ClassName", "").Split('.').Last(); var pid = r.GetValueOrDefault("ProgramID", "");
                if (cls == "" || pid == "" || System.Text.RegularExpressions.Regex.IsMatch(cls, @"^[A-Z]{2,5}\d{4}")) continue; // 이미 ID 패턴인 클래스는 제외
                if (!alias.ContainsKey(cls)) alias[cls] = pid;
            }
        string Stem(string file) { var n = file.Split('\\', '/').Last(); n = n.EndsWith(".Designer.cs", StringComparison.OrdinalIgnoreCase) ? n[..^12] : Path.GetFileNameWithoutExtension(n); return n; }
        IEnumerable<Dictionary<string, string>> Rd(string f) => CsvIn.Read(P(f)).Select(r =>
        {
            if (alias.Count > 0 && r.TryGetValue("screen_id", out var sid) && sid == "" && r.TryGetValue("file", out var fl) && alias.TryGetValue(Stem(fl), out var pid)) r["screen_id"] = pid;
            return r;
        });
        if (alias.Count > 0) Console.WriteLine($"프로그램ID 별칭 {alias.Count}건 (TB_FX_ProgramInfo)");

        foreach (var r in Rd("files.csv")) if (Want(r["screen_id"])) S(r["screen_id"]).Files.Add(r);
        var fileScreen = scr.Values.SelectMany(s => s.Files.Select(f => (f["file"], s.Id))).ToDictionary(x => x.Item1, x => x.Id, StringComparer.Ordinal);

        foreach (var r in Rd("events.csv")) if (Want(r["screen_id"])) S(r["screen_id"]).Events.Add(r);
        // 디자이너 속성(Text/Orientation/SplitterDistance/Size/Control/Dock…) — To-Be 생성기의 라벨·레이아웃 근거
        var keepProps = new HashSet<string>(StringComparer.Ordinal) { "Text", "Orientation", "SplitterDistance", "Size", "Dock", "Control", "Visible", "Enabled", "ReadOnly", "Checked", "Multiline", "MaxLength", "PasswordChar", "TabIndex", "Panel1MinSize", "Panel2MinSize", "FixedPanel", "Panel1Collapsed", "Panel2Collapsed", "IsSplitterFixed", "UsrPanelType", "DateFormat", "Format", "Items", "SelectedIndex", "Caption", "ToolTip" };
        if (File.Exists(P("props.csv")))
            foreach (var r in Rd("props.csv")) if (Want(r["screen_id"]) && keepProps.Contains(r["prop"])) S(r["screen_id"]).Props.Add(r);
        foreach (var r in Rd("controls.csv"))
            if (Want(r["screen_id"]) && !NonControlTypes.Contains(r["type"].Split('.').Last())) S(r["screen_id"]).Controls.Add(r);
        // 프레임워크(화면ID 없는 파일)의 메타 소비 메서드: 메서드명 → 읽는 컬럼 (예: CreateSheetHeaderColumn → COLUMN_NAME …)
        var fwMeta = new Dictionary<string, SortedSet<string>>(StringComparer.Ordinal);
        foreach (var r in Rd("meta_reads.csv"))
        {
            if (Want(r["screen_id"])) S(r["screen_id"]).Meta.Add(r);
            else if (r["screen_id"] == "" && r["file"].StartsWith("01.Framework"))
            {
                var k = r["class"] + "." + r["member"];
                if (!fwMeta.TryGetValue(k, out var set)) fwMeta[k] = set = new SortedSet<string>(StringComparer.Ordinal);
                set.Add(r["column"]);
            }
        }
        _fwMeta = fwMeta.GroupBy(kv => kv.Key.Split('.').Last()).ToDictionary(g => g.Key, g => g.Select(kv => (kv.Key, kv.Value)).ToList(), StringComparer.Ordinal);
        foreach (var r in Rd("members.csv"))
            if (Want(r["screen_id"]) && (r["kind"] == "Method" || r["kind"] == "Constructor"))
                S(r["screen_id"]).Mems.Add(new Mem { File = r["file"], Cls = r["class"], Name = r["member"], Kind = r["kind"], Mods = r["modifiers"], Params = r["params"], Line = int.Parse(r["line"]), End = int.Parse(r["end_line"]) });
        foreach (var r in Rd("calls.csv"))
            if (Want(r["screen_id"])) S(r["screen_id"]).Calls.Add(new Call { File = r["file"], Cls = r["class"], Member = r["member"], Line = r["line"], Callee = r["callee"], Recv = r["receiver"] });
        if (File.Exists(P("grid_code.csv")))
            foreach (var r in Rd("grid_code.csv"))
                if (Want(r["screen_id"]))
                    S(r["screen_id"]).Grid.Add(new GridCode.Row { File = r["file"], Cls = r["class"], Member = r["member"], Line = int.Parse(r["line"]), Api = r["api"], Recv = r["receiver"], Source = r["source"], Args = r["args"], ArgNames = r["arg_names"], Cond = r["conditions"], Raw = r["raw"], Columns = r.GetValueOrDefault("columns", "") });
        foreach (var r in Rd("endpoint_usage.csv"))
            if (Want(r["screen_id"]))
                S(r["screen_id"]).Uses.Add(new Use { File = r["file"], Cls = r["class"], Member = r["member"], Line = r["line"], SiteKind = r["site_kind"], Kind = r["kind"], Cand = r["candidate"], Key = r["key"], Status = r["status"], Detail = r["detail"], Via = r["via"], Active = r["active"], Commented = r["commented"] });

        var eps = new Dictionary<string, Ep>(StringComparer.OrdinalIgnoreCase);
        foreach (var r in Rd("foxquery_endpoints.csv"))
            if (r["commented"] == "0") eps[r["key"]] = new Ep { Key = r["key"], Element = r["element"], Sp = r["sp_name"], TextFile = r["text_file"], File = r["file"], Params = int.Parse(r["param_count"]) };
        var refs = new Dictionary<string, List<string>>(StringComparer.OrdinalIgnoreCase);
        foreach (var r in Rd("foxquery_sql_refs.csv"))
        {
            if (r["ref_kind"] == "NONE") continue;
            if (!refs.TryGetValue(r["key"], out var l)) refs[r["key"]] = l = new();
            var t = $"{r["access"]}:{r["name"]}";
            if (!l.Contains(t)) l.Add(t);
        }
        var slnProjects = SlnProjects(root);
        LoadDb(outDir);
        GridView.Load(outDir, cfg);
        if (_dbLoaded) Console.WriteLine($"db: objects {_dbObj.Count}, modules with refs {_modRefs.Count}");
        var screenMeta = _dbLoaded ? ScreenMetaRows(outDir, scr.Keys.ToHashSet()) : new();

        var baseDir = P("screens");
        Directory.CreateDirectory(baseDir);
        using var idx = new CsvOut(Path.Combine(baseDir, "_index.csv"), "screen_id", "files", "current_files", "legacy_files", "endpoints", "match", "not_in_foxquery", "unresolved", "commented_calls", "controls", "events", "meta_columns", "grid_mode", "grid_hardcoded_columns", "grid_db_loop_columns", "grid_overrides", "current_project");
        foreach (var s in scr.Values.OrderBy(x => x.Id, StringComparer.Ordinal))
        {
            var variant = Variants(s, slnProjects);
            var dir = Path.Combine(baseDir, s.Id);
            Directory.CreateDirectory(dir);
            var visible = s.Uses.Where(u => u.Active == "1" && u.Commented == "0" && !HideStatus.Contains(u.Status) && !u.Key.EndsWith(".PseudoDataClient")).ToList();
            WriteCsvs(dir, s, variant, visible, eps, refs);
            var metaFiles = new List<string>();
            if (screenMeta.TryGetValue(s.Id, out var mt))
                foreach (var (tbl, rows) in mt)
                {
                    var fn = "dbmeta_" + tbl.Replace('.', '_') + ".csv";
                    using (var w = new CsvOut(Path.Combine(dir, fn), rows.header)) foreach (var r in rows.rows) w.Row(r);
                    metaFiles.Add($"{tbl}|{rows.rows.Count}|{fn}");
                }
            _metaFiles = metaFiles;
            var flows = Flows(s, visible, variant);
            using (var w = new CsvOut(Path.Combine(dir, "flow.csv"), "variant", "file", "class", "entry_kind", "entry", "path", "member", "line", "endpoint", "status", "sp_or_sql", "objects"))
                foreach (var f in flows) w.Row(f.variant, f.file, f.cls, f.entryKind, f.entry, f.path, f.member, f.line, f.key, f.status, Detail(f.key, eps), Objects(f.key, eps, refs));
            var curFiles = variant.Where(v => v.Value != "legacy").Select(v => v.Key).ToHashSet();
            var gridRows = s.Grid.Where(g => curFiles.Contains(g.File)).ToList();
            GridCode.AssignSheets(s.Grid);
            GridCode.WriteCsv(dir, s.Grid, f => variant.GetValueOrDefault(f, ""));
            var gridMode = GridCode.Mode(gridRows, GridView.HasData);
            _gridModes[s.Id] = gridMode;
            File.WriteAllText(Path.Combine(dir, s.Id + "_summary.md"), Summary(s, variant, visible, flows, eps, refs) + GridView.Write(dir, s.Id) + GridCode.Summary(gridRows, gridMode)
                + GridMerge.Write(dir, s.Id, gridRows, GridView.RowsFor(s.Id), GridView.Divisions), new UTF8Encoding(true));

            var cur = variant.Where(v => v.Value != "legacy").Select(v => v.Key).ToHashSet();
            var vc = visible.Where(u => cur.Contains(u.File)).ToList();
            idx.Row(s.Id, s.Files.Count, cur.Count, variant.Count(v => v.Value == "legacy"),
                vc.Select(u => u.Key).Where(k => k != "").Distinct().Count(), vc.Count(u => u.Status.StartsWith("MATCH") || u.Status == "BIZ_MATCH"),
                vc.Count(u => u.Status == "NOT_IN_FOXQUERY"), vc.Count(u => u.Status == "UNRESOLVED"),
                s.Uses.Count(u => u.Commented == "1" && cur.Contains(u.File)), s.Controls.Count(c => cur.Contains(c["file"])), s.Events.Count(e => cur.Contains(e["file"])),
                s.Meta.Where(m => cur.Contains(m["file"])).Select(m => m["column"]).Distinct().Count(),
                _gridModes.GetValueOrDefault(s.Id, ""),
                s.Grid.Count(g => cur.Contains(g.File) && GridCode.IsColumnDef(g) && g.Source == "HARDCODED"),
                s.Grid.Count(g => cur.Contains(g.File) && GridCode.IsColumnDef(g) && g.Source != "HARDCODED"),
                s.Grid.Count(g => cur.Contains(g.File) && GridCode.IsOverride(g)),
                string.Join(" | ", s.Files.Where(f => variant.GetValueOrDefault(f["file"]) == "current").Select(f => f["project"]).Distinct()));
        }
        Console.WriteLine($"screens: {scr.Count} → {baseDir}");
        return 0;
    }

    /// <summary>LGCE_GSCM.sln 에 등록된 csproj 상대경로</summary>
    static HashSet<string> SlnProjects(string root)
    {
        var h = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        try
        {
            foreach (var sln in Directory.EnumerateFiles(root, "*.sln"))
                foreach (var line in File.ReadLines(sln))
                {
                    var m = System.Text.RegularExpressions.Regex.Match(line, "^Project\\(.*?\\)\\s*=\\s*\"[^\"]*\",\\s*\"([^\"]+\\.csproj)\"");
                    if (m.Success) h.Add(m.Groups[1].Value.Replace('/', '\\'));
                }
        }
        catch { }
        return h;
    }

    /// <summary>
    /// 같은 화면이 여러 프로젝트에 있을 때: 화면 전용 csproj(이름에 화면ID) = current, 나머지 UIL 사본 = legacy.
    /// 화면 전용 csproj 가 없으면 모두 only.
    /// </summary>
    static Dictionary<string, string> Variants(Scr s, HashSet<string> sln)
    {
        var d = new Dictionary<string, string>(StringComparer.Ordinal);
        bool Dedicated(string proj) => Path.GetFileNameWithoutExtension(proj).ToUpperInvariant().Contains(s.Id);
        var hasDedicated = s.Files.Any(f => Dedicated(f["project"]) && f["layer"] == "06.UIL");
        // 화면 전용 csproj 에 같은 파일명이 있을 때만 legacy. 전용 csproj 에 없는 파일(팝업 등 도메인 공용 프로젝트 소속)은 shared = 현행으로 취급
        var dedicatedNames = s.Files.Where(f => Dedicated(f["project"])).Select(f => Path.GetFileName(f["file"].Replace('\\', '/'))).ToHashSet(StringComparer.OrdinalIgnoreCase);
        foreach (var f in s.Files)
        {
            var proj = f["project"];
            var fname = Path.GetFileName(f["file"].Replace('\\', '/'));
            string v = !hasDedicated || f["layer"] != "06.UIL" ? "only" : Dedicated(proj) ? "current" : dedicatedNames.Contains(fname) ? "legacy" : "shared";
            if (v == "current" && sln.Count > 0 && !sln.Contains(proj)) v = "current(sln미등록)";
            d[f["file"]] = v;
        }
        return d;
    }

    static string Detail(string key, Dictionary<string, Ep> eps)
    {
        if (string.IsNullOrEmpty(key)) return "";
        var parts = key.Split('|').Take(3).Select(k => eps.TryGetValue(k, out var e) ? (string.IsNullOrEmpty(e.Sp) ? $"[{e.Element}] {e.TextFile}" : $"SP {e.Sp}") : "").Where(x => x != "");
        return string.Join(" | ", parts);
    }

    static string Objects(string key, Dictionary<string, Ep> eps, Dictionary<string, List<string>> refs)
    {
        if (string.IsNullOrEmpty(key)) return "";
        var items = new List<string>();
        foreach (var k in key.Split('|').Take(3))
        {
            if (refs.TryGetValue(k, out var l)) items.AddRange(l);
            if (_dbLoaded && eps.TryGetValue(k, out var e))
            {
                var sps = !string.IsNullOrEmpty(e.Sp) ? new[] { e.Sp } : (refs.GetValueOrDefault(k) ?? new()).Where(x => x.StartsWith("EXEC:")).Select(x => x[5..]).ToArray();
                foreach (var sp in sps) items.AddRange(SpClosure(sp));
            }
        }
        return string.Join(", ", items.Distinct().Take(60));
    }

    static void WriteCsvs(string dir, Scr s, Dictionary<string, string> variant, List<Use> visible, Dictionary<string, Ep> eps, Dictionary<string, List<string>> refs)
    {
        using (var w = new CsvOut(Path.Combine(dir, "files.csv"), "variant", "file", "project", "lines", "encoding", "sha256", "parse_errors"))
            foreach (var f in s.Files) w.Row(variant[f["file"]], f["file"], f["project"], f["lines"], f["encoding"], f["sha256"], f["parse_errors"]);
        using (var w = new CsvOut(Path.Combine(dir, "endpoints.csv"), "variant", "file", "class", "member", "line", "site_kind", "kind", "candidate", "key", "status", "sp_or_sql", "objects", "via", "detail"))
            foreach (var u in visible.OrderBy(u => variant[u.File]).ThenBy(u => u.File).ThenBy(u => int.Parse(u.Line)))
                w.Row(variant[u.File], u.File, u.Cls, u.Member, u.Line, u.SiteKind, u.Kind, u.Cand, u.Key, u.Status, Detail(u.Key, eps), Objects(u.Key, eps, refs), u.Via, u.Detail);
        using (var w = new CsvOut(Path.Combine(dir, "commented_calls.csv"), "variant", "file", "line", "kind", "candidate", "key", "status"))
            foreach (var u in s.Uses.Where(u => u.Commented == "1" || u.Active == "0")) w.Row(variant[u.File], u.File, u.Line, u.Kind, u.Cand, u.Key, (u.Active == "0" ? "inactive:" : "commented:") + u.Status);
        using (var w = new CsvOut(Path.Combine(dir, "events.csv"), "variant", "file", "class", "member", "line", "target", "event", "handler", "op"))
            foreach (var e in s.Events) w.Row(variant[e["file"]], e["file"], e["class"], e["member"], e["line"], e["target"], e["event"], e["handler"], e["op"]);
        // 메서드 목록(BaseForm 공통 버튼 override 판정용: FindButton/InsertButton/DeleteButton/SaveButton/EditButton/ExcelButton/UploadButton…)
        using (var w = new CsvOut(Path.Combine(dir, "members.csv"), "variant", "file", "class", "member", "kind", "modifiers", "params", "line", "end_line", "lines"))
            foreach (var m in s.Mems.OrderBy(m => m.File).ThenBy(m => m.Line)) w.Row(variant.GetValueOrDefault(m.File, "current"), m.File, m.Cls, m.Name, m.Kind, m.Mods, m.Params, m.Line, m.End, (m.End - m.Line + 1).ToString());
        using (var w = new CsvOut(Path.Combine(dir, "controls.csv"), "variant", "file", "class", "name", "type", "parent", "line"))
            foreach (var c in s.Controls) w.Row(variant[c["file"]], c["file"], c["class"], c["name"], c["type"], c["parent"], c["line"]);
        using (var w = new CsvOut(Path.Combine(dir, "props.csv"), "variant", "file", "class", "member", "line", "target", "prop", "value"))
            foreach (var r in s.Props) w.Row(variant.TryGetValue(r["file"], out var v) ? v : "", r["file"], r["class"], r["member"], r["line"], r["target"], r["prop"], r["value"]);
        using (var w = new CsvOut(Path.Combine(dir, "meta_reads.csv"), "variant", "file", "class", "member", "line", "receiver", "column", "via"))
            foreach (var m in s.Meta) w.Row(variant[m["file"]], m["file"], m["class"], m["member"], m["line"], m["receiver"], m["column"], m["via"]);
    }

    record FlowRow(string variant, string file, string cls, string entryKind, string entry, string path, string member, string line, string key, string status);

    /// <summary>진입점(이벤트 핸들러·버튼 override·생성자/Load) → 같은 클래스 내부 호출 → 엔드포인트</summary>
    static List<FlowRow> Flows(Scr s, List<Use> visible, Dictionary<string, string> variant)
    {
        var rows = new List<FlowRow>();
        foreach (var g in s.Mems.GroupBy(m => (variant[m.File] == "legacy" ? "legacy:" + m.File : "main", m.Cls)))
        {
            var cls = g.Key.Cls;
            var files = g.Select(m => m.File).ToHashSet();
            var names = g.Select(m => m.Name).ToHashSet();
            var edges = s.Calls.Where(c => files.Contains(c.File) && c.Cls == cls && names.Contains(c.Callee) && (c.Recv == "" || c.Recv == "this" || c.Recv == "base"))
                               .GroupBy(c => c.Member).ToDictionary(x => x.Key, x => x.Select(c => c.Callee).Distinct().ToList());
            var useBy = visible.Where(u => files.Contains(u.File) && u.Cls == cls).GroupBy(u => u.Member).ToDictionary(x => x.Key, x => x.ToList());
            var entries = new List<(string kind, string entry, string member)>();
            foreach (var e in s.Events.Where(e => files.Contains(e["file"]) && e["class"] == cls && e["op"] == "+="))
            {
                var h = e["handler"].Split('.').Last();
                if (names.Contains(h)) entries.Add(("event", $"{e["target"]}.{e["event"]}", h));
            }
            foreach (var m in g.Where(m => m.Mods.Contains("override") && EntryOverrides.Contains(m.Name))) entries.Add(("button", m.Name, m.Name));
            foreach (var m in g.Where(m => m.Name == ".ctor")) entries.Add(("ctor", ".ctor", ".ctor"));
            var reached = new HashSet<string>();
            foreach (var (kind, entry, start) in entries.Distinct())
            {
                var stack = new Stack<(string m, string path, int d)>();
                stack.Push((start, start, 0));
                var seen = new HashSet<string>();
                while (stack.Count > 0)
                {
                    var (m, path, d) = stack.Pop();
                    if (!seen.Add(m)) continue;
                    reached.Add(m);
                    if (useBy.TryGetValue(m, out var us))
                        foreach (var u in us) rows.Add(new FlowRow(variant[u.File], u.File, cls, kind, entry, path, m, u.Line, Show(u), u.Status));
                    if (d < 8 && edges.TryGetValue(m, out var nx)) foreach (var n in nx) stack.Push((n, path + " > " + n, d + 1));
                }
            }
            // 진입점에서 닿지 않는 엔드포인트도 누락 없이 표시
            foreach (var kv in useBy.Where(kv => !reached.Contains(kv.Key)))
                foreach (var u in kv.Value) rows.Add(new FlowRow(variant[u.File], u.File, cls, "unreached", "(진입점 미연결)", kv.Key, kv.Key, u.Line, Show(u), u.Status));
        }
        return rows;
    }

    /// <summary>표시용 엔드포인트: biz 는 코드 파라미터까지 (예: biz:CommonData.CommonDataList [code=YesOrNo])</summary>
    static string Show(Use u) => u.Kind == "biz" && u.Key.StartsWith("biz:") ? "biz:" + u.Cand : (u.Key == "" ? u.Cand : u.Key);

    /// <summary>확인 필요 항목의 원인 분류 (사람이 볼 것 / 파서 보완 / 폐기 후보 구분)</summary>
    static string Classify(Use u)
    {
        var c = u.Cand ?? "";
        if (u.Status == "NOT_IN_FOXQUERY") return DbNote(u) is var n && n != "" ? n : "FoxQuery 미등록";
        if (u.Status == "BIZ_NOT_FOUND") return "BIZ 메서드 없음(DLL 외부 또는 폐기)";
        if (u.Status == "MATCH_PATTERN") return "후보 복수 — 패턴 매칭, 실행 시 결정";
        if (c.Contains("field ") && c.Contains("←")) return "생성자/메서드 인자로 받은 서비스명 — 호출 측(팝업 호출 화면)에서 결정";
        if (c.Contains("ambiguous")) return "동명 필드 복수 정의 — 파서 보완 대상";
        if (System.Text.RegularExpressions.Regex.IsMatch(c, @"\b(cbo|chk|txt|rdo|lst|clb|usr)\w*\.|ControlValues|SelectedValue|\.Text\b")) return "런타임: 화면 컨트롤 값으로 SP명 조립";
        if (System.Text.RegularExpressions.Regex.IsMatch(c, @"\b(dt|dr|ds|row)\w*\[|Rows\[|Tables\[")) return "런타임: 조회 데이터(메타) 값으로 SP명 결정";
        if (c.Contains("string.Empty") || c.Trim() == "") return "빈 값(미사용 코드 경로)";
        return "정적 결정 불가 — 식 확인 필요";
    }

    /// <summary>DB 단계 결과 기반 보강: SP 존재, 코드 분기(biz code=X), 직접 SP 호출</summary>
    static string DbNote(Use u)
    {
        if (!_dbLoaded) return "";
        var m = System.Text.RegularExpressions.Regex.Match(u.Cand ?? "", @"code=([^;\]]+)");
        if (u.Kind == "biz" && m.Success && _branchByValue.TryGetValue(m.Groups[1].Value.Trim(), out var br))
            return "코드분기 " + string.Join(", ", br.Select(b => $"{b.module}:{b.access}:{b.name}").Distinct().Take(20));
        if (u.Status == "NOT_IN_FOXQUERY")
        {
            var nm = SqlAnalyzer.NormName(u.Cand);
            return _dbObj.TryGetValue(nm, out var t) ? $"DB 객체 존재({t}) → FoxQuery 없이 직접 호출: " + string.Join(", ", SpClosure(nm).Take(20)) : "DB에도 없음 (폐기/오타 가능)";
        }
        return "";
    }

    static string Esc(string s) => (s ?? "").Replace("|", "\\|").Replace("\r", " ").Replace("\n", " ");

    static string Summary(Scr s, Dictionary<string, string> variant, List<Use> visible, List<FlowRow> flows, Dictionary<string, Ep> eps, Dictionary<string, List<string>> refs)
    {
        var cur = variant.Where(v => v.Value != "legacy").Select(v => v.Key).ToHashSet();
        var sb = new StringBuilder();
        sb.AppendLine($"# {s.Id} 화면 Fact Pack");
        sb.AppendLine();
        sb.AppendLine("> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.");
        sb.AppendLine();
        sb.AppendLine("## 1. 파일 구성");
        sb.AppendLine("| 구분 | 파일 | 프로젝트 | 줄수 |"); sb.AppendLine("|---|---|---|---:|");
        foreach (var f in s.Files.OrderBy(f => variant[f["file"]] == "legacy").ThenBy(f => f["file"])) sb.AppendLine($"| {variant[f["file"]]} | {Esc(f["file"])} | {Esc(f["project"])} | {f["lines"]} |");

        sb.AppendLine(); sb.AppendLine("## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)");
        sb.AppendLine("| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |"); sb.AppendLine("|---|---|---:|---|---|---|");
        foreach (var f in flows.Where(f => cur.Contains(f.file)).OrderBy(f => f.entryKind == "unreached").ThenBy(f => f.entry).ThenBy(f => int.Parse(f.line)))
            sb.AppendLine($"| {Esc(f.entryKind + ":" + f.entry)} | {Esc(f.path)} | {f.line} | {Esc(f.key)} | {f.status} | {Esc(Detail(f.key, eps))} |");

        sb.AppendLine(); sb.AppendLine("## 3. 엔드포인트 목록");
        sb.AppendLine("| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |"); sb.AppendLine("|---|---|---:|---|---|---|");
        foreach (var g in visible.Where(u => cur.Contains(u.File)).GroupBy(Show).OrderBy(g => g.Key))
        {
            var key = g.First().Key;
            var spCheck = _dbLoaded && eps.TryGetValue(key, out var ep0) && !string.IsNullOrEmpty(ep0.Sp) && !_dbObj.ContainsKey(SqlAnalyzer.NormName(ep0.Sp)) ? "⚠ DB에 SP 없음" : DbNote(g.First());
            sb.AppendLine($"| {Esc(g.Key)} | {string.Join(",", g.Select(u => u.Status).Distinct())} | {g.Count()} | {Esc(Detail(key, eps))} | {Esc(Objects(key, eps, refs))} | {Esc(spCheck)} |");
        }

        var meta = s.Meta.Where(m => cur.Contains(m["file"])).ToList();
        sb.AppendLine(); sb.AppendLine("## 4. DB 메타/데이터 컬럼 사용 (`row[\"COL\"]`, `Field<T>(\"COL\")`)");
        sb.AppendLine("| 메서드 | 대상 | 컬럼 |"); sb.AppendLine("|---|---|---|");
        foreach (var g in meta.GroupBy(m => (m["member"], m["receiver"])).OrderBy(g => g.Key.Item1))
            sb.AppendLine($"| {Esc(g.Key.Item1)} | {Esc(g.Key.Item2)} | {Esc(string.Join(", ", g.Select(m => m["column"]).Distinct()))} |");

        // 4-2. 화면이 호출하는 프레임워크 메타 소비 메서드 (Grid 컬럼 속성 DB 구동 등)
        var fwCalls = s.Calls.Where(c => cur.Contains(c.File) && _fwMeta.ContainsKey(c.Callee)).GroupBy(c => c.Callee).ToList();
        sb.AppendLine(); sb.AppendLine("### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)");
        sb.AppendLine("| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |"); sb.AppendLine("|---|---|---|---|");
        foreach (var g in fwCalls)
            foreach (var (owner, cols) in _fwMeta[g.Key])
                sb.AppendLine($"| {Esc(g.Key)} | {Esc(string.Join(", ", g.Select(c => c.Member + ":" + c.Line).Distinct().Take(8)))} | {Esc(owner)} | {Esc(string.Join(", ", cols))} |");

        sb.AppendLine(); sb.AppendLine("## 5. 이벤트 배선");
        sb.AppendLine("| 대상 | 이벤트 | 핸들러 | 위치 |"); sb.AppendLine("|---|---|---|---|");
        foreach (var e in s.Events.Where(e => cur.Contains(e["file"]))) sb.AppendLine($"| {Esc(e["target"])} | {e["event"]} | {Esc(e["handler"])} | {e["member"]}:{e["line"]} |");

        var ctl = s.Controls.Where(c => cur.Contains(c["file"])).ToList();
        sb.AppendLine(); sb.AppendLine($"## 6. 컨트롤 ({ctl.Count}개, 상세는 controls.csv)");
        sb.AppendLine("| 유형 | 개수 | 컨트롤 |"); sb.AppendLine("|---|---:|---|");
        foreach (var g in ctl.GroupBy(c => c["type"].Split('.').Last()).OrderByDescending(g => g.Count()))
            sb.AppendLine($"| {Esc(g.Key)} | {g.Count()} | {Esc(string.Join(", ", g.Select(c => c["name"]).Take(15)))}{(g.Count() > 15 ? " …" : "")} |");

        var chk = visible.Where(u => cur.Contains(u.File) && (u.Status == "NOT_IN_FOXQUERY" || u.Status == "UNRESOLVED" || u.Status == "BIZ_NOT_FOUND" || u.Status == "MATCH_PATTERN")).ToList();
        sb.AppendLine(); sb.AppendLine($"## 7. 확인 필요 ({chk.Count}건)");
        sb.AppendLine("| 줄 | 메서드 | 값 | 상태 | 비고 |"); sb.AppendLine("|---:|---|---|---|---|");
        foreach (var u in chk) sb.AppendLine($"| {u.Line} | {Esc(u.Member)} | {Esc(u.Cand)} | {u.Status} | {Esc(Classify(u) + (u.Detail != "" ? " · " + u.Detail : ""))} |");

        sb.AppendLine(); sb.AppendLine(_dbLoaded ? $"## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)" : "## 8. DB 메타 데이터 — `AsisFacts db` 실행 후 pack 하면 채워집니다");
        if (_dbLoaded)
        {
            sb.AppendLine("| 메타 테이블 | 행 수 | 파일 |"); sb.AppendLine("|---|---:|---|");
            foreach (var m in _metaFiles) { var p = m.Split('|'); sb.AppendLine($"| {Esc(p[0])} | {p[1]} | {p[2]} |"); }
        }

        var cm = s.Uses.Where(u => cur.Contains(u.File) && (u.Commented == "1" || u.Active == "0")).ToList();
        sb.AppendLine(); sb.AppendLine($"## 9. 주석/비활성 처리된 호출 ({cm.Count}건, 활성 집계 제외)");
        sb.AppendLine("| 줄 | 값 | 상태 |"); sb.AppendLine("|---:|---|---|");
        foreach (var u in cm) sb.AppendLine($"| {u.Line} | {Esc(u.Cand)} | {(u.Active == "0" ? "inactive" : "commented")}:{u.Status} |");
        return sb.ToString();
    }
}
