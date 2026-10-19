using System.Data;
using System.Text;
using Microsoft.Data.SqlClient;

namespace AsisFacts;

/// <summary>
/// 2단계: As-is MSSQL 카탈로그 + 메타 테이블 추출.
///  - SELECT 만 실행 (Guard), READ UNCOMMITTED, ApplicationIntent=ReadOnly
///  - 비밀번호는 .env 파일/환경변수에서 읽고 어떤 출력에도 남기지 않는다
///  - SP 는 실행하지 않는다 (결과셋 컬럼은 sys.dm_exec_describe_first_result_set_for_object 로 메타데이터만)
/// </summary>
public static class DbExtract
{
    public static int Run(Config cfg, string outDir)
    {
        var dbDir = Path.Combine(outDir, "db");
        Directory.CreateDirectory(dbDir);
        var log = new List<string>();
        void Log(string s) { Console.WriteLine(s); log.Add(s); }

        string cs;
        try { cs = ConnString(cfg.db); }
        catch (Exception ex) { Console.Error.WriteLine("DB 접속정보 오류: " + ex.Message); return 2; }

        var csb = new SqlConnectionStringBuilder(cs);
        Console.WriteLine($"target: {csb.DataSource} / {csb.InitialCatalog} / user={(csb.IntegratedSecurity ? "(Windows 인증)" : csb.UserID)} / envFile={cfg.db.envFile} (비밀번호 {(string.IsNullOrEmpty(csb.Password) && !csb.IntegratedSecurity ? "없음" : "읽음")})");
        using var con = new SqlConnection(cs);
        try { con.Open(); }
        catch (Exception ex) { Console.Error.WriteLine("DB 접속 실패: " + ex.Message); return 2; }
        Exec(con, cfg, "SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; SET LOCK_TIMEOUT 10000; SET NOCOUNT ON;");
        Log($"connected: {con.DataSource} / {con.Database}");

        // 1. 객체
        var objs = Query(con, cfg, @"SELECT o.object_id, s.name AS schema_name, o.name, o.type, o.type_desc, o.create_date, o.modify_date
            FROM sys.objects o JOIN sys.schemas s ON s.schema_id = o.schema_id
            WHERE o.is_ms_shipped = 0 AND o.type IN ('P','PC','FN','IF','TF','FS','FT','V','U','TR','SN','TT')");
        WriteTable(Path.Combine(dbDir, "db_objects.csv"), objs);
        Log($"objects: {objs.Rows.Count}");

        // 2. 모듈 원문 + 참조 분석 + 코드 분기
        var mods = Query(con, cfg, @"SELECT m.object_id, s.name AS schema_name, o.name, o.type, m.definition
            FROM sys.sql_modules m JOIN sys.objects o ON o.object_id = m.object_id JOIN sys.schemas s ON s.schema_id = o.schema_id
            WHERE o.is_ms_shipped = 0");
        var modDir = Path.Combine(dbDir, "modules");
        Directory.CreateDirectory(modDir);
        int encrypted = 0;
        using (var wr = new CsvOut(Path.Combine(dbDir, "db_module_refs.csv"), "module", "type", "ref_kind", "name", "raw", "access", "line", "parse_mode", "parse_error"))
        using (var wb = new CsvOut(Path.Combine(dbDir, "db_code_branches.csv"), "module", "variable", "value", "line", "ref_kind", "name", "access"))
        {
            foreach (DataRow r in mods.Rows)
            {
                var name = $"{r["schema_name"]}.{r["name"]}";
                var def = r["definition"] as string;
                if (def == null) { encrypted++; wr.Row(name, r["type"], "ENCRYPTED", "", "", "", 0, "", "definition null (암호화 또는 권한 없음)"); continue; }
                File.WriteAllText(Path.Combine(modDir, Safe(name) + ".sql"), def, new UTF8Encoding(true));
                var res = SqlAnalyzer.Analyze(def);
                foreach (var f in res.Refs) wr.Row(name, r["type"], f.Kind, f.Name, f.Raw, f.Access, f.Line, res.Mode, res.ParseError);
                if (res.Refs.Count == 0) wr.Row(name, r["type"], "NONE", "", "", "", 0, res.Mode, res.ParseError);
                foreach (var b in SqlAnalyzer.Branches(def, out _))
                    foreach (var f in b.Refs.DefaultIfEmpty(new SqlRef { Kind = "NONE", Name = "", Access = "" }))
                        wb.Row(name, b.Variable, b.Value, b.Line, f.Kind, f.Name, f.Access);
            }
        }
        Log($"modules: {mods.Rows.Count} (definition 없음 {encrypted})");

        // 3. 파라미터 / 컬럼 / 키 / 의존 / 동의어
        WriteTable(Path.Combine(dbDir, "db_params.csv"), Query(con, cfg, @"SELECT s.name AS schema_name, o.name AS object_name, o.type, p.parameter_id, p.name AS param_name,
              TYPE_NAME(p.user_type_id) AS data_type, p.max_length, p.precision, p.scale, p.is_output, p.has_default_value
            FROM sys.parameters p JOIN sys.objects o ON o.object_id = p.object_id JOIN sys.schemas s ON s.schema_id = o.schema_id
            WHERE o.is_ms_shipped = 0 ORDER BY s.name, o.name, p.parameter_id"));
        WriteTable(Path.Combine(dbDir, "db_columns.csv"), Query(con, cfg, @"SELECT s.name AS schema_name, o.name AS object_name, o.type, c.column_id, c.name AS column_name,
              TYPE_NAME(c.user_type_id) AS data_type, c.max_length, c.precision, c.scale, c.is_nullable, c.is_identity, c.is_computed,
              dc.definition AS default_definition, cc.definition AS computed_definition
            FROM sys.columns c JOIN sys.objects o ON o.object_id = c.object_id JOIN sys.schemas s ON s.schema_id = o.schema_id
            LEFT JOIN sys.default_constraints dc ON dc.object_id = c.default_object_id
            LEFT JOIN sys.computed_columns cc ON cc.object_id = c.object_id AND cc.column_id = c.column_id
            WHERE o.is_ms_shipped = 0 AND o.type IN ('U','V','TF','IF') ORDER BY s.name, o.name, c.column_id"));
        WriteTable(Path.Combine(dbDir, "db_indexes.csv"), Query(con, cfg, @"SELECT s.name AS schema_name, o.name AS table_name, i.name AS index_name, i.type_desc, i.is_primary_key, i.is_unique,
              ic.key_ordinal, ic.is_included_column, c.name AS column_name
            FROM sys.indexes i JOIN sys.objects o ON o.object_id = i.object_id JOIN sys.schemas s ON s.schema_id = o.schema_id
            JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
            JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
            WHERE o.is_ms_shipped = 0 AND o.type = 'U' AND i.type > 0 ORDER BY s.name, o.name, i.name, ic.key_ordinal"));
        WriteTable(Path.Combine(dbDir, "db_dependencies.csv"), Query(con, cfg, @"SELECT OBJECT_SCHEMA_NAME(d.referencing_id) AS referencing_schema, OBJECT_NAME(d.referencing_id) AS referencing_name,
              d.referenced_server_name, d.referenced_database_name, d.referenced_schema_name, d.referenced_entity_name,
              OBJECT_NAME(d.referenced_id) AS resolved_name, d.is_ambiguous, d.is_caller_dependent
            FROM sys.sql_expression_dependencies d"));
        WriteTable(Path.Combine(dbDir, "db_synonyms.csv"), Query(con, cfg, @"SELECT s.name AS schema_name, sn.name, sn.base_object_name FROM sys.synonyms sn JOIN sys.schemas s ON s.schema_id = sn.schema_id"));
        try
        {
            WriteTable(Path.Combine(dbDir, "db_rowcounts.csv"), Query(con, cfg, @"SELECT s.name AS schema_name, o.name AS table_name, SUM(p.row_count) AS row_count
                FROM sys.dm_db_partition_stats p JOIN sys.objects o ON o.object_id = p.object_id JOIN sys.schemas s ON s.schema_id = o.schema_id
                WHERE o.type = 'U' AND p.index_id IN (0,1) GROUP BY s.name, o.name"));
        }
        catch (Exception ex) { Log("rowcounts 생략 (권한): " + ex.Message); }

        // 4. 프로시저 결과셋 메타 (실행하지 않음)
        using (var w = new CsvOut(Path.Combine(dbDir, "db_resultsets.csv"), "module", "column_ordinal", "name", "system_type_name", "is_nullable", "error_type", "error_message"))
        {
            int n = 0;
            foreach (DataRow r in objs.Rows)
            {
                if ((string)r["type"] is not ("P " or "P")) continue;
                var name = $"{r["schema_name"]}.{r["name"]}";
                try
                {
                    var t = Query(con, cfg, "SELECT column_ordinal, name, system_type_name, is_nullable, error_type_desc, error_message FROM sys.dm_exec_describe_first_result_set_for_object(@id, 0)",
                        ("@id", (int)r["object_id"]));
                    foreach (DataRow c in t.Rows) w.Row(name, c["column_ordinal"], c["name"], c["system_type_name"], c["is_nullable"], c["error_type_desc"], c["error_message"]);
                    if (t.Rows.Count == 0) w.Row(name, "", "", "", "", "NO_RESULTSET", "");
                }
                catch (Exception ex) { w.Row(name, "", "", "", "", "EXCEPTION", ex.Message); }
                if (++n % 500 == 0) Console.WriteLine($"  resultsets {n}");
            }
        }
        Log("resultsets done");

        // 5. 메타 테이블 데이터
        var metaNames = MetaTables(cfg, dbDir, objs);
        var metaDir = Path.Combine(dbDir, "meta");
        Directory.CreateDirectory(metaDir);
        using (var w = new CsvOut(Path.Combine(dbDir, "db_meta_tables.csv"), "table", "reason", "rows_written", "status"))
            foreach (var (tbl, reason) in metaNames)
            {
                try
                {
                    var cnt = Convert.ToInt64(Query(con, cfg, $"SELECT COUNT_BIG(*) AS c FROM {Quote(tbl)}").Rows[0][0]);
                    if (cnt > cfg.db.maxRowsPerTable) { w.Row(tbl, reason, 0, $"SKIPPED rows={cnt} > maxRowsPerTable"); continue; }
                    var t = Query(con, cfg, $"SELECT * FROM {Quote(tbl)}");
                    WriteTable(Path.Combine(metaDir, Safe(tbl) + ".csv"), t);
                    w.Row(tbl, reason, t.Rows.Count, "OK");
                }
                catch (Exception ex) { w.Row(tbl, reason, 0, "ERROR " + ex.Message); }
            }
        Log($"meta tables: {metaNames.Count}");
        File.WriteAllLines(Path.Combine(dbDir, "_db.log"), log);
        return 0;
    }

    /// <summary>메타 소스 모듈(예: *_SPREAD_TITLE)이 SELECT 하는 테이블 + 이름 패턴 + 명시 목록</summary>
    static List<(string, string)> MetaTables(Config cfg, string dbDir, DataTable objs)
    {
        var res = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        var tables = objs.Rows.Cast<DataRow>().Where(r => ((string)r["type"]).Trim() == "U").Select(r => $"{r["schema_name"]}.{r["name"]}").ToList();
        var byName = tables.GroupBy(t => t.Split('.').Last(), StringComparer.OrdinalIgnoreCase).ToDictionary(g => g.Key, g => g.First(), StringComparer.OrdinalIgnoreCase);
        var srcPats = cfg.db.metaSourceModules.Select(Like).ToList();
        foreach (var r in CsvIn.Read(Path.Combine(dbDir, "db_module_refs.csv")))
        {
            if (r["ref_kind"] != "TABLE" || r["access"] != "SELECT") continue;
            var mod = r["module"].Split('.').Last();
            var hit = srcPats.FirstOrDefault(p => p.IsMatch(mod));
            if (hit != null && byName.TryGetValue(r["name"], out var full) && !res.ContainsKey(full)) res[full] = "referenced by " + r["module"];
        }
        foreach (var p in cfg.db.metaTablePatterns.Select(Like))
            foreach (var t in tables) if (p.IsMatch(t.Split('.').Last()) && !res.ContainsKey(t)) res[t] = "name pattern " + p;
        foreach (var t in cfg.db.metaTables)
        {
            var full = t.Contains('.') ? t : byName.GetValueOrDefault(t, t);
            res[full] = "config metaTables";
        }
        return res.Select(kv => (kv.Key, kv.Value)).OrderBy(x => x.Key).ToList();
    }

    static System.Text.RegularExpressions.Regex Like(string pat)
        => new("^" + System.Text.RegularExpressions.Regex.Escape(pat).Replace("%", ".*").Replace("_", ".") + "$", System.Text.RegularExpressions.RegexOptions.IgnoreCase);

    static string Quote(string full) => string.Join(".", full.Split('.').Select(p => "[" + p.Replace("]", "]]") + "]"));
    static string Safe(string s) => string.Concat(s.Select(c => Path.GetInvalidFileNameChars().Contains(c) ? '_' : c));

    // ───────────── 접속 ─────────────
    internal static string ConnString(DbConfig db)
    {
        var env = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        if (!string.IsNullOrEmpty(db.envFile) && File.Exists(db.envFile))
            foreach (var line in File.ReadAllLines(db.envFile))
            {
                var t = line.Trim();
                if (t.StartsWith("#") || !t.Contains('=')) continue;
                var i = t.IndexOf('=');
                env[t[..i].Trim()] = t[(i + 1)..].Trim().Trim('"');
            }
        string Get(string k, string fallback)
        {
            var key = db.envKeys.GetValueOrDefault(k);
            var v = key != null ? (Environment.GetEnvironmentVariable(key) ?? env.GetValueOrDefault(key)) : null;
            return string.IsNullOrEmpty(v) ? fallback : v;
        }
        var host = Get("host", db.server); var port = Get("port", null);
        var b = new SqlConnectionStringBuilder
        {
            DataSource = string.IsNullOrEmpty(port) ? host : $"{host},{port}",
            InitialCatalog = Get("database", db.database),
            ApplicationIntent = ApplicationIntent.ReadOnly,
            ApplicationName = "AsisFacts(read-only)",
            Encrypt = SqlConnectionEncryptOption.Optional,
            TrustServerCertificate = true,
            ConnectTimeout = 20
        };
        if (db.integratedSecurity) b.IntegratedSecurity = true;
        else
        {
            b.UserID = Get("user", db.user);
            var pw = Get("password", null);
            if (string.IsNullOrEmpty(pw)) pw = Prompt($"{b.UserID}@{b.DataSource} 비밀번호: ");
            b.Password = pw;
        }
        if (string.IsNullOrEmpty(b.DataSource) || string.IsNullOrEmpty(b.InitialCatalog)) throw new InvalidDataException("server/database 미설정 (asisfacts.json db.envFile 또는 db.server/db.database)");
        return b.ConnectionString;
    }

    static string Prompt(string msg)
    {
        Console.Write(msg);
        var sb = new StringBuilder();
        while (true)
        {
            var k = Console.ReadKey(true);
            if (k.Key == ConsoleKey.Enter) break;
            if (k.Key == ConsoleKey.Backspace) { if (sb.Length > 0) sb.Length--; continue; }
            sb.Append(k.KeyChar);
        }
        Console.WriteLine();
        return sb.ToString();
    }

    // ───────────── 실행 (읽기 전용 가드) ─────────────
    static void Guard(string sql)
    {
        var t = System.Text.RegularExpressions.Regex.Replace(sql, @"\s+", " ").Trim().ToUpperInvariant();
        bool ok = t.StartsWith("SELECT ") || t.StartsWith("SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED");
        var banned = new[] { " INSERT ", " UPDATE ", " DELETE ", " MERGE ", " DROP ", " ALTER ", " CREATE ", " EXEC ", " EXECUTE ", " TRUNCATE ", " GRANT ", " INTO " };
        if (!ok || banned.Any(bw => (" " + t + " ").Contains(bw))) throw new InvalidOperationException("읽기 전용 가드: 허용되지 않은 SQL - " + t[..Math.Min(80, t.Length)]);
    }

    internal static void Exec(SqlConnection con, Config cfg, string sql)
    {
        Guard(sql);
        using var cmd = new SqlCommand(sql, con) { CommandTimeout = cfg.db.commandTimeoutSec };
        cmd.ExecuteNonQuery();
    }

    internal static DataTable Query(SqlConnection con, Config cfg, string sql, params (string, object)[] ps)
    {
        Guard(sql);
        using var cmd = new SqlCommand(sql, con) { CommandTimeout = cfg.db.commandTimeoutSec };
        foreach (var (n, v) in ps) cmd.Parameters.AddWithValue(n, v);
        var t = new DataTable();
        using var rd = cmd.ExecuteReader();
        t.Load(rd);
        return t;
    }

    static void WriteTable(string path, DataTable t)
    {
        using var w = new CsvOut(path, t.Columns.Cast<DataColumn>().Select(c => c.ColumnName).ToArray());
        foreach (DataRow r in t.Rows)
            w.Row(r.ItemArray.Select(v => v switch
            {
                DBNull => null,
                byte[] b => "0x" + Convert.ToHexString(b.Length > 64 ? b[..64] : b) + (b.Length > 64 ? $"…({b.Length}B)" : ""),
                DateTime d => d.ToString("yyyy-MM-dd HH:mm:ss.fff"),
                _ => v
            }).ToArray());
    }
}
