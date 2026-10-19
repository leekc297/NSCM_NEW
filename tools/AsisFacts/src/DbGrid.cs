using System.Data;
using System.Diagnostics;
using Microsoft.Data.SqlClient;
using Microsoft.SqlServer.TransactSql.ScriptDom;

namespace AsisFacts;

/// <summary>
/// 3단계: division × sheet 별 실제 Grid 정의 수집.
///  - 대상: gridSpPatterns (기본 *SPREAD_TITLE*, *SPD_TITLE*) SP
///  - 안전: SP 원문 + EXEC 전이 closure 에 영구 테이블 쓰기(INSERT/UPDATE/DELETE/MERGE/CREATE/TRUNCATE)·동적 SQL·미확인 모듈이
///          하나라도 있으면 실행하지 않는다 (UNSAFE 로 기록). 안전한 SP 도 트랜잭션 안에서 실행하고 항상 ROLLBACK.
///  - 파라미터: division / sheet / user / program 은 이름으로 추론, 나머지는 gridParamDefaults 또는 NULL (grid_runs.csv 에 기록)
///  - --plan-only : DB 접속 없이 실행 계획(grid_plan.csv)만 생성
/// </summary>
public static class DbGrid
{
    sealed class Param { public string Name; public string Type; public bool IsOutput; public bool HasDefault; }

    public static int Run(Config cfg, string outDir, bool planOnly)
    {
        var dbDir = Path.Combine(outDir, "db");
        if (!File.Exists(Path.Combine(dbDir, "db_module_refs.csv"))) { Console.Error.WriteLine("db 단계 결과가 없습니다. 먼저 db.ps1 실행"); return 2; }
        var gridDir = Path.Combine(dbDir, "grid");
        Directory.CreateDirectory(gridDir);

        // 모듈 참조 / 파라미터 / 메타
        var refs = new Dictionary<string, List<(string kind, string name, string access)>>(StringComparer.OrdinalIgnoreCase);
        var modFull = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        foreach (var r in CsvIn.Read(Path.Combine(dbDir, "db_module_refs.csv")))
        {
            var m = r["module"].Split('.').Last();
            modFull[m] = r["module"];
            if (!refs.TryGetValue(m, out var l)) refs[m] = l = new();
            l.Add((r["ref_kind"], r["name"], r["access"]));
        }
        var pars = new Dictionary<string, List<Param>>(StringComparer.OrdinalIgnoreCase);
        foreach (var r in CsvIn.Read(Path.Combine(dbDir, "db_params.csv")))
        {
            if (r["param_name"] == "") continue; // 함수 반환값
            var k = r["object_name"];
            if (!pars.TryGetValue(k, out var l)) pars[k] = l = new();
            l.Add(new Param { Name = r["param_name"], Type = r["data_type"], IsOutput = r["is_output"] is "True" or "1", HasDefault = r["has_default_value"] is "True" or "1" });
        }
        var divisions = new List<string>();
        var divFile = Directory.EnumerateFiles(Path.Combine(dbDir, "meta"), "*.SCM_MST_DIVISION.csv").FirstOrDefault();
        if (divFile != null) foreach (var r in CsvIn.Read(divFile)) if (r.GetValueOrDefault("VALID_YN", "Y") != "N") divisions.Add(r["DIVISION_ID"]);
        var sheetsByProgram = new Dictionary<string, SortedSet<string>>(StringComparer.OrdinalIgnoreCase);
        foreach (var f in Directory.EnumerateFiles(Path.Combine(dbDir, "meta"), "*.csv"))
        {
            bool hasCols = false;
            foreach (var r in CsvIn.Read(f))
            {
                if (!r.ContainsKey("PROGRAM_ID") || !r.ContainsKey("SHEET_NAME")) break;
                hasCols = true;
                if (!sheetsByProgram.TryGetValue(r["PROGRAM_ID"], out var s)) sheetsByProgram[r["PROGRAM_ID"]] = s = new(StringComparer.Ordinal);
                if (r["SHEET_NAME"] != "") s.Add(r["SHEET_NAME"]);
            }
            _ = hasCols;
        }
        var fromCode = CodeArgs(outDir);
        Console.WriteLine($"code-derived SP args: {fromCode.Count} SP");
        Console.WriteLine($"divisions: {divisions.Count} [{string.Join(",", divisions)}], programs with sheets: {sheetsByProgram.Count}");

        // 대상 SP + 안전성 + 실행 계획
        var pats = cfg.db.gridSpPatterns.Select(p => new System.Text.RegularExpressions.Regex("^" + System.Text.RegularExpressions.Regex.Escape(p).Replace("%", ".*").Replace("_", ".") + "$", System.Text.RegularExpressions.RegexOptions.IgnoreCase)).ToList();
        var procNames = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (var r in CsvIn.Read(Path.Combine(dbDir, "db_objects.csv"))) if (r["type"].Trim() is "P" or "PC") procNames.Add(r["name"]);
        var targets = refs.Keys.Where(m => pats.Any(p => p.IsMatch(m)) && procNames.Contains(m)).Distinct(StringComparer.OrdinalIgnoreCase).OrderBy(x => x).ToList();
        foreach (var fn in refs.Keys.Where(m => pats.Any(p => p.IsMatch(m)) && !procNames.Contains(m))) Console.WriteLine($"  skip (not a procedure): {fn}");
        var plan = new List<(string sp, string program, string sheet, string division, Dictionary<string, object> args, string note)>();
        using (var w = new CsvOut(Path.Combine(gridDir, "grid_sp_safety.csv"), "sp", "safe", "reason", "program_ids", "sheets", "params"))
            foreach (var sp in targets)
            {
                var (safe, reason) = Safety(sp, refs);
                var programs = ProgramIds(dbDir, modFull.GetValueOrDefault(sp, sp), sp, sheetsByProgram);
                var ps = pars.GetValueOrDefault(sp) ?? new List<Param>();
                // 공통 SP(프로그램ID를 파라미터로 받는 SP): 실제 호출 코드가 넘기는 값/호출 화면ID 사용
                var codeSheets = new Dictionary<string, HashSet<string>>(StringComparer.OrdinalIgnoreCase);
                if (fromCode.TryGetValue(sp, out var ca))
                {
                    foreach (var (prog, sheet) in ca)
                    {
                        if (prog != "" && sheetsByProgram.ContainsKey(prog) && !programs.Contains(prog)) programs.Add(prog);
                        if (prog != "" && sheet != "") { if (!codeSheets.TryGetValue(prog, out var hs)) codeSheets[prog] = hs = new(); hs.Add(sheet); }
                    }
                }
                var sheets = programs.SelectMany(p => sheetsByProgram.GetValueOrDefault(p) ?? new SortedSet<string>()).Distinct().ToList();
                w.Row(sp, safe, reason, string.Join(",", programs), sheets.Count, string.Join(",", ps.Select(p => p.Name)));
                if (!safe) continue;
                bool usesDiv = ps.Any(p => IsDiv(p.Name)), usesSheet = ps.Any(p => IsSheet(p.Name));
                foreach (var prog in programs.DefaultIfEmpty(""))
                    foreach (var sheet in (usesSheet ? (sheetsByProgram.GetValueOrDefault(prog) ?? new SortedSet<string>()).Union(codeSheets.GetValueOrDefault(prog) ?? new HashSet<string>()).Distinct().ToList() : new List<string> { "" }))
                        foreach (var div in usesDiv ? divisions : new List<string> { "" })
                        {
                            var args = new Dictionary<string, object>();
                            var notes = new List<string>();
                            foreach (var p in ps.Where(p => !p.IsOutput))
                            {
                                var n = p.Name.TrimStart('@');
                                if (IsDiv(n)) args[p.Name] = div;
                                else if (IsSheet(n)) args[p.Name] = sheet;
                                else if (IsProgram(n)) args[p.Name] = prog;
                                else if (IsUser(n)) args[p.Name] = cfg.db.gridUser;
                                else if (cfg.db.gridParamDefaults.TryGetValue(n, out var dv)) args[p.Name] = Expand(dv);
                                else if (DateDefault(n) is string dd) { args[p.Name] = dd; notes.Add(n + "=" + dd); }
                                else if (p.HasDefault) { notes.Add(n + "=DEFAULT"); continue; }
                                else { args[p.Name] = DBNull.Value; notes.Add(n + "=NULL"); }
                            }
                            plan.Add((sp, prog, sheet, div, args, string.Join(";", notes)));
                        }
            }
        using (var w = new CsvOut(Path.Combine(gridDir, "grid_plan.csv"), "sp", "program_id", "sheet", "division", "args", "note"))
            foreach (var p in plan) w.Row(p.sp, p.program, p.sheet, p.division, string.Join("; ", p.args.Select(a => a.Key + "=" + (a.Value is DBNull ? "NULL" : a.Value))), p.note);
        Console.WriteLine($"grid targets: {targets.Count} SP, executions planned: {plan.Count}");
        if (planOnly) return 0;

        // 실행
        using var con = new SqlConnection(DbExtract.ConnString(cfg.db));
        con.Open();
        DbExtract.Exec(con, cfg, "SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; SET LOCK_TIMEOUT 10000; SET NOCOUNT ON;");
        var safeSet = new HashSet<string>(plan.Select(p => p.sp), StringComparer.OrdinalIgnoreCase);
        var writers = new Dictionary<string, (CsvOut w, string[] cols)>(StringComparer.OrdinalIgnoreCase);
        using var runs = new CsvOut(Path.Combine(gridDir, "grid_runs.csv"), "sp", "program_id", "sheet", "division", "status", "resultsets", "rows", "ms", "note", "error");
        int i = 0;
        foreach (var p in plan)
        {
            if (!safeSet.Contains(p.sp)) throw new InvalidOperationException("안전 목록 밖 SP 실행 시도: " + p.sp);
            var sw = Stopwatch.StartNew();
            using var tx = con.BeginTransaction();
            try
            {
                using var cmd = new SqlCommand(modFull.GetValueOrDefault(p.sp, p.sp), con, tx) { CommandType = CommandType.StoredProcedure, CommandTimeout = cfg.db.gridExecTimeoutSec };
                foreach (var a in p.args) cmd.Parameters.AddWithValue(a.Key, a.Value);
                int rs = 0, rows = 0;
                using (var rd = cmd.ExecuteReader())
                {
                    do
                    {
                        var cols = Enumerable.Range(0, rd.FieldCount).Select(rd.GetName).ToArray();
                        var key = p.sp + "#" + rs;
                        if (!writers.TryGetValue(key, out var wr))
                        {
                            wr = (new CsvOut(Path.Combine(gridDir, Safe(p.sp) + (rs > 0 ? "_rs" + rs : "") + ".csv"), new[] { "_sp", "_program_id", "_sheet", "_division", "_row" }.Concat(cols).ToArray()), cols);
                            writers[key] = wr;
                        }
                        int rn = 0;
                        while (rd.Read())
                        {
                            var vals = new object[wr.cols.Length];
                            for (int c = 0; c < wr.cols.Length; c++)
                            {
                                var ord = c < rd.FieldCount && rd.GetName(c) == wr.cols[c] ? c : (Array.IndexOf(cols, wr.cols[c]));
                                vals[c] = ord >= 0 && !rd.IsDBNull(ord) ? rd.GetValue(ord) : null;
                            }
                            wr.w.Row(new object[] { p.sp, p.program, p.sheet, p.division, ++rn }.Concat(vals).ToArray());
                            rows++;
                        }
                        rs++;
                    } while (rd.NextResult());
                }
                runs.Row(p.sp, p.program, p.sheet, p.division, "OK", rs, rows, sw.ElapsedMilliseconds, p.note, "");
            }
            catch (Exception ex) { runs.Row(p.sp, p.program, p.sheet, p.division, "ERROR", 0, 0, sw.ElapsedMilliseconds, p.note, ex.Message); }
            finally { try { tx.Rollback(); } catch { } }
            if (++i % 200 == 0) Console.WriteLine($"  grid exec {i}/{plan.Count}");
        }
        foreach (var w in writers.Values) w.w.Dispose();
        Console.WriteLine($"grid done → {gridDir}");
        return 0;
    }

    /// <summary>{today:yyyyMMdd}, {today+28:yyyyMM} 형식 확장</summary>
    static string Expand(string v)
        => System.Text.RegularExpressions.Regex.Replace(v, @"\{today([+-]\d+)?:([^}]+)\}", m => DateTime.Today.AddDays(m.Groups[1].Success ? int.Parse(m.Groups[1].Value) : 0).ToString(m.Groups[2].Value));

    /// <summary>날짜형 파라미터 기본값: 시작=오늘, 종료=오늘+28일. 형식은 이름으로 추론</summary>
    static string DateDefault(string n)
    {
        var x = n.ToLowerInvariant();
        bool end = x.Contains("end") || x.Contains("_to") || x.StartsWith("p_to") || x.Contains("to_");
        bool start = x.Contains("start") || x.Contains("from");
        string fmt = x.Contains("yyyymmdd") ? "yyyyMMdd" : x.Contains("yyyymm") ? "yyyyMM" : x.EndsWith("yyyy") ? "yyyy" : x.EndsWith("_dt") || x.Contains("date") ? "yyyy-MM-dd" : x.Contains("_month") ? "yyyyMM" : null;
        if (x.Contains("week")) return System.Globalization.ISOWeek.GetYear(DateTime.Today).ToString() + System.Globalization.ISOWeek.GetWeekOfYear(DateTime.Today).ToString("00");
        if (fmt == null) return null;
        return DateTime.Today.AddDays(end ? 28 : 0).ToString(fmt);
    }

    /// <summary>sites.csv 에서 SPREAD_TITLE 계열 호출이 넘기는 program/sheet 리터럴 + 호출 화면ID</summary>
    static Dictionary<string, HashSet<(string prog, string sheet)>> CodeArgs(string outDir)
    {
        var res = new Dictionary<string, HashSet<(string, string)>>(StringComparer.OrdinalIgnoreCase);
        var spOfKey = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        var epf = Path.Combine(outDir, "foxquery_endpoints.csv");
        if (File.Exists(epf)) foreach (var r in CsvIn.Read(epf)) if (r["sp_name"] != "") spOfKey[r["key"]] = SqlAnalyzer.NormName(r["sp_name"]);
        var sf = Path.Combine(outDir, "sites.csv");
        if (!File.Exists(sf)) return res;
        foreach (var r in CsvIn.Read(sf))
        {
            if (r["commented"] == "1" || r["active"] == "0" || r["kind"] != "fox") continue;
            var vals = r["values"];
            if (vals.IndexOf("TITLE", StringComparison.OrdinalIgnoreCase) < 0) continue;
            foreach (var v in vals.Split(" || "))
            {
                if (v.Contains('{')) continue;
                var sp = spOfKey.GetValueOrDefault(v) ?? SqlAnalyzer.NormName(v);
                if (!res.TryGetValue(sp, out var set)) res[sp] = set = new();
                string prog = r["screen_id"], sheet = "";
                foreach (var kv in r["req_params"].Split("; ", StringSplitOptions.RemoveEmptyEntries))
                {
                    var i = kv.IndexOf('=');
                    if (i < 0) continue;
                    var name = kv[..i].ToLowerInvariant();
                    var lits = kv[(i + 1)..].Split(" || ").Where(x => !x.Contains('{') && x != "").ToList();
                    if ((name.Contains("program") || name.Contains("pgm")) && lits.Count > 0) prog = lits[0];
                    if (name.Contains("sheet")) foreach (var l in lits) set.Add((prog, l));
                }
                set.Add((prog, sheet));
            }
        }
        return res;
    }

    static bool IsDiv(string n) => n.TrimStart('@').ToLowerInvariant().Contains("division");
    static bool IsSheet(string n) => n.TrimStart('@').ToLowerInvariant().Contains("sheet");
    static bool IsProgram(string n) { var x = n.TrimStart('@').ToLowerInvariant(); return x.Contains("program") || x.Contains("pgm"); }
    static bool IsUser(string n) { var x = n.TrimStart('@').ToLowerInvariant(); return x.Contains("created_by") || x.Contains("user_id") || x == "p_user" || x.EndsWith("userid") || x.Contains("updated_by"); }
    static string Safe(string s) => string.Concat(s.Select(c => Path.GetInvalidFileNameChars().Contains(c) ? '_' : c));

    static readonly HashSet<string> WriteAccess = new(StringComparer.OrdinalIgnoreCase) { "INSERT", "UPDATE", "DELETE", "MERGE", "CREATE" };

    /// <summary>EXEC 전이 closure 에 영구 테이블 쓰기/동적SQL/미확인 모듈이 없으면 안전</summary>
    static (bool, string) Safety(string sp, Dictionary<string, List<(string kind, string name, string access)>> refs)
    {
        var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        var q = new Queue<string>(); q.Enqueue(sp);
        while (q.Count > 0)
        {
            var m = q.Dequeue();
            if (!seen.Add(m)) continue;
            if (!refs.TryGetValue(m, out var l)) return (false, $"원문 없는 모듈 호출: {m}");
            foreach (var (kind, name, access) in l)
            {
                if (kind == "ENCRYPTED") return (false, $"원문 없음: {m}");
                if (kind == "DYNAMIC") return (false, $"동적 SQL: {m}");
                if (kind == "TABLE" && WriteAccess.Contains(access)) return (false, $"영구 테이블 쓰기: {m} {access} {name}");
                if (kind == "EXEC")
                {
                    if (name.StartsWith("SP_", StringComparison.OrdinalIgnoreCase) && !refs.ContainsKey(name)) return (false, $"시스템 SP 호출: {name}");
                    q.Enqueue(name);
                }
            }
        }
        return (true, $"closure {seen.Count} 모듈, 쓰기 없음");
    }

    /// <summary>SP 원문(주석 제외 토큰)의 문자열 리터럴 중 메타 PROGRAM_ID 와 일치하는 값. 없으면 SP 이름 접두(화면ID)</summary>
    static List<string> ProgramIds(string dbDir, string full, string sp, Dictionary<string, SortedSet<string>> sheetsByProgram)
    {
        var res = new List<string>();
        var file = Path.Combine(dbDir, "modules", Safe(full) + ".sql");
        if (File.Exists(file))
        {
            var toks = new TSql160Parser(true).GetTokenStream(new StringReader(TextIO.Read(file).text), out _);
            foreach (var t in toks.Where(t => t.TokenType == TSqlTokenType.AsciiStringLiteral || t.TokenType == TSqlTokenType.UnicodeStringLiteral))
            {
                var v = t.Text.TrimStart('N', 'n').Trim('\'');
                if (sheetsByProgram.ContainsKey(v) && !res.Contains(v)) res.Add(v);
            }
        }
        if (res.Count == 0)
        {
            var prefix = sp.Split('_')[0];
            if (sheetsByProgram.ContainsKey(prefix)) res.Add(prefix);
        }
        return res;
    }
}
