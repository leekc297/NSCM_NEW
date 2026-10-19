namespace AsisFacts;

/// <summary>
/// 화면 코드에 정의된 Grid (하드코딩 / DB 루프 / 표시·라벨 변경) 를 시트 문맥과 함께 정리하고,
/// 메타(GridView) 와 합쳐 화면의 Grid 구성 방식을 판정한다.
///   META      : CreateSheetHeaderColumn 류(프레임워크가 메타 행으로 컬럼 생성)만 사용
///   HARDCODED : Add*Column 리터럴 정의만 사용
///   HYBRID    : 둘 다 사용 (또는 메타 컬럼 생성 후 코드에서 표시/라벨 변경)
/// </summary>
public static class GridCode
{
    public sealed class Row
    {
        public string File, Cls, Member, Api, Recv, Source, Args, ArgNames, Cond, Raw, SheetHint, Columns;
        public int Line;
    }

    static readonly HashSet<string> SheetApis = new(StringComparer.Ordinal) { "AddSheet", "ChangeSheet", "ChangeActiveSheet", "InitSheet", "GetSheetInfo" };
    static readonly System.Text.RegularExpressions.Regex MetaApi = new("^(CreateSheetHeaderColumn|SetSheetHeaderColumn|SetSpreadColumn|SetSpreadHeaderSpan)", System.Text.RegularExpressions.RegexOptions.CultureInvariant);

    public static bool IsColumnDef(Row r) => r.Api.StartsWith("Add") && r.Api.Contains("Column");
    public static bool IsMetaDef(Row r) => MetaApi.IsMatch(r.Api);
    public static bool IsOverride(Row r) => r.Api.StartsWith("set:") || r.Api.Contains("Visible") || r.Api.Contains("Hidden") || r.Api.StartsWith("SetColumnLabel") || r.Api.StartsWith("SetColumnHeader") || r.Api.StartsWith("SetColumnWidth");

    static string Arg(Row r, int i) { var a = r.Args.Split(" ¦ "); return i < a.Length ? a[i] : ""; }

    /// <summary>같은 메서드에서 앞서 지정된 시트명(리터럴) — 시트 문맥 추정</summary>
    public static void AssignSheets(List<Row> rows)
    {
        foreach (var g in rows.GroupBy(r => (r.File, r.Member)))
        {
            string cur = "";
            foreach (var r in g.OrderBy(r => r.Line))
            {
                if (SheetApis.Contains(r.Api))
                {
                    var idx = r.Api == "AddSheet" ? 1 : r.Api == "GetSheetInfo" ? 1 : 0;
                    var v = Arg(r, idx);
                    if (v != "" && !v.Contains('{') && !v.Contains("||")) cur = v;
                }
                r.SheetHint = cur;
            }
        }
    }

    public static string Mode(List<Row> rows, bool hasMetaRows)
    {
        bool meta = rows.Any(IsMetaDef), hard = rows.Any(r => IsColumnDef(r) && r.Source == "HARDCODED"), loop = rows.Any(r => IsColumnDef(r) && r.Source != "HARDCODED"), ov = rows.Any(IsOverride);
        var parts = new List<string>();
        if (meta) parts.Add("META(프레임워크)");
        if (loop) parts.Add("DB루프(코드)");
        if (hard) parts.Add("HARDCODED");
        if (parts.Count == 0) return hasMetaRows ? "META(행 존재, 생성 호출 미발견)" : "없음";
        var mode = parts.Count > 1 ? "HYBRID: " + string.Join(" + ", parts) : parts[0];
        return ov ? mode + " (+코드 표시/라벨 변경)" : mode;
    }

    public static void WriteCsv(string dir, List<Row> rows, Func<string, string> variant)
    {
        using var w = new CsvOut(Path.Combine(dir, "grid_code.csv"), "variant", "file", "class", "member", "line", "sheet_hint", "kind", "api", "source", "header", "field", "columns", "args", "arg_names", "conditions", "raw");
        foreach (var r in rows.OrderBy(r => r.File).ThenBy(r => r.Line))
        {
            string kind = r.Api.StartsWith("local:") ? "LOCAL_METHOD" : IsColumnDef(r) ? "COLUMN" : IsMetaDef(r) ? "META_BUILD" : IsOverride(r) ? "OVERRIDE" : SheetApis.Contains(r.Api) ? "SHEET" : "OTHER";
            w.Row(variant(r.File), r.File, r.Cls, r.Member, r.Line, r.SheetHint, kind, r.Api, r.Source, IsColumnDef(r) ? Arg(r, 0) : "", IsColumnDef(r) ? Arg(r, 1) : "", r.Columns, r.Args, r.ArgNames, r.Cond, r.Raw);
        }
    }

    public static string Summary(List<Row> rows, string mode)
    {
        var sb = new System.Text.StringBuilder();
        sb.AppendLine(); sb.AppendLine($"## 11. 코드로 정의된 Grid — 구성 방식: **{mode}** (상세 grid_code.csv)");
        sb.AppendLine("메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.");
        var sheets = rows.Where(r => r.Api == "AddSheet").Select(r => Arg(r, 1)).Where(v => v != "").Distinct().ToList();
        if (sheets.Count > 0) sb.AppendLine("- 코드에서 생성하는 시트: " + string.Join(", ", sheets));
        var metaCalls = rows.Where(IsMetaDef).ToList();
        if (metaCalls.Count > 0) sb.AppendLine("- 메타 컬럼 생성 호출(프레임워크): " + string.Join(", ", metaCalls.Select(r => $"{r.Api}@{r.Member}:{r.Line}").Distinct().Take(10)));
        var locals = rows.Where(r => r.Api.StartsWith("local:")).Select(r => r.Api[6..]).Distinct().ToList();
        if (locals.Count > 0) sb.AppendLine("- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): " + string.Join(", ", locals));
        sb.AppendLine();
        sb.AppendLine("| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |"); sb.AppendLine("|---|---|---:|---|---|---|---|---|");
        foreach (var r in rows.Where(r => IsColumnDef(r) || IsOverride(r)).OrderBy(r => r.File).ThenBy(r => r.Line).Take(400))
        {
            string kind = IsColumnDef(r) ? (r.Source == "HARDCODED" ? "하드코딩" : r.Source == "DB_DRIVEN" ? "DB루프" : "식") : "표시/라벨 변경";
            string hdr = IsColumnDef(r) ? Arg(r, 0) : (r.Api.StartsWith("set:") ? r.Api[4..] + " = " : "") + Arg(r, 0);
            sb.AppendLine($"| {E(r.Member)} | {E(r.SheetHint)} | {r.Line} | {kind} | {E(r.Api)} | {E(hdr)} | {E(IsColumnDef(r) ? Arg(r, 1) : r.Columns)} | {E(r.Cond)} |");
        }
        var more = rows.Count(r => IsColumnDef(r) || IsOverride(r)) - 400;
        if (more > 0) sb.AppendLine($"| … | | | | | {more}건 더 (grid_code.csv) | | |");
        return sb.ToString();
    }

    static string E(string s) => (s ?? "").Replace("|", "\\|").Replace("\n", " ");
}
