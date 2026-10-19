namespace AsisFacts;

/// <summary>
/// 화면별 division × 컬럼 Grid 정의.
///  규칙(업무 확인, 2026-10-16):
///   - DIVISION_ID 값 있음 → 해당 division(콤마 목록)만, 빈값 → 전체 division
///   - VISIBLE_FLAG = 'Y' 그리고 VALID_YN = 'Y' 인 컬럼만 표시 대상 (컬럼이 없는 테이블은 해당 조건 생략)
///   - USER_SELECTABLE_FLAG = 'N' → 필수(사용자 선택 불가, 항상 표시)
///   - DEFAULT_FLAG = 'Y' → 기본 선택 (사용자 선택 가능)
///   - 그 외 표시대상 → 선택 가능(기본 미선택)
///  실제 SP 실행 결과(db/grid/*.csv)가 있으면 division별로 대조해 차이를 기록한다.
/// </summary>
public static class GridView
{
    public sealed class MetaRow { public string Table, Program, Sheet, Column, Label, Sort, Div, Visible, Valid, Default, Selectable, CellType, Width; }

    static List<MetaRow> _rows;
    static List<string> _divs;
    static Dictionary<string, List<Dictionary<string, string>>> _exec; // program|sheet|division → rows (정규화 키)
    static string Norm(string s) => new string((s ?? "").Where(c => !char.IsWhiteSpace(c) && c != '_' && c != '-').ToArray()).ToUpperInvariant();
    static string Key(string prog, string sheet, string div) => $"{Norm(prog)}|{Norm(sheet)}|{div}";

    public static void Load(string outDir, Config cfg)
    {
        _rows = new(); _divs = new(); _exec = new(StringComparer.OrdinalIgnoreCase);
        var meta = Path.Combine(outDir, "db", "meta");
        if (!Directory.Exists(meta)) return;
        var divFile = Directory.EnumerateFiles(meta, "*.SCM_MST_DIVISION.csv").FirstOrDefault();
        if (divFile != null) foreach (var r in CsvIn.Read(divFile)) if (r.GetValueOrDefault("VALID_YN", "Y") != "N") _divs.Add(r["DIVISION_ID"]);
        foreach (var t in cfg.db.gridMetaTables)
        {
            var f = Directory.EnumerateFiles(meta, "*." + t + ".csv").FirstOrDefault();
            if (f == null) continue;
            foreach (var r in CsvIn.Read(f))
                _rows.Add(new MetaRow
                {
                    Table = t, Program = r.GetValueOrDefault("PROGRAM_ID", ""), Sheet = r.GetValueOrDefault("SHEET_NAME", ""), Column = r.GetValueOrDefault("COLUMN_NAME", ""),
                    Label = r.GetValueOrDefault("COLUMN_LABEL_NAME", ""), Sort = r.GetValueOrDefault("SORT_ORDER_NO", ""), Div = r.GetValueOrDefault("DIVISION_ID", ""),
                    Visible = r.GetValueOrDefault("VISIBLE_FLAG"), Valid = r.GetValueOrDefault("VALID_YN"), Default = r.GetValueOrDefault("DEFAULT_FLAG", ""),
                    Selectable = r.GetValueOrDefault("USER_SELECTABLE_FLAG", ""), CellType = r.GetValueOrDefault("CELL_CONTROL_OBJECT_TYPE_CODE", ""), Width = r.GetValueOrDefault("COLUMN_WIDTH", "")
                });
        }
        var grid = Path.Combine(outDir, "db", "grid");
        if (Directory.Exists(grid))
            foreach (var f in Directory.EnumerateFiles(grid, "*.csv").Where(f => !Path.GetFileName(f).StartsWith("grid_")))
                foreach (var r in CsvIn.Read(f))
                {
                    var prog = r.GetValueOrDefault("PROGRAM_ID") is string p && p != "" ? p : r["_program_id"];
                    var sheet = r.GetValueOrDefault("SHEET_NAME") is string sh && sh != "" ? sh : r["_sheet"];
                    var k = Key(prog, sheet, r["_division"]);
                    if (!_exec.TryGetValue(k, out var l)) _exec[k] = l = new();
                    l.Add(r);
                }
    }

    public static List<string> Divisions => _divs ?? new();
    public static List<MetaRow> RowsFor(string screenId) => _rows == null ? new() : _rows.Where(r => r.Program.Equals(screenId, StringComparison.OrdinalIgnoreCase) || r.Program.StartsWith(screenId + "_", StringComparison.OrdinalIgnoreCase)).ToList();

    public static bool HasData => _rows != null && _rows.Count > 0;

    static bool DivMatch(string list, string div) => string.IsNullOrWhiteSpace(list) || list.Split(',').Any(x => x.Trim().Equals(div, StringComparison.OrdinalIgnoreCase));

    /// <summary>규칙 판정: 필수 / 기본 / 선택 / 숨김(VISIBLE·VALID 조건 불충족) / "" (division 미적용)</summary>
    public static string Rule(MetaRow r, string div)
    {
        if (!DivMatch(r.Div, div)) return "";
        if ((r.Visible != null && r.Visible != "Y") || (r.Valid != null && r.Valid != "Y")) return "숨김";
        if (r.Selectable == "N") return "필수";
        if (r.Default == "Y") return "기본";
        return "선택";
    }

    /// <summary>화면 폴더에 grid_rule.csv / grid_diff.csv 작성, 요약 MD 문자열 반환</summary>
    public static string Write(string dir, string screenId)
    {
        if (!HasData) return "";
        var rows = _rows.Where(r => r.Program.Equals(screenId, StringComparison.OrdinalIgnoreCase) || r.Program.StartsWith(screenId + "_", StringComparison.OrdinalIgnoreCase)).ToList();
        if (rows.Count == 0) return "\n## 10. Division별 Grid 정의\n메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.\n";
        using (var w = new CsvOut(Path.Combine(dir, "grid_rule.csv"), new[] { "table", "program_id", "sheet", "sort", "column", "label", "cell_type", "width", "division_id(raw)", "visible", "valid", "default", "user_selectable" }.Concat(_divs).ToArray()))
            foreach (var r in rows.OrderBy(r => r.Table).ThenBy(r => r.Program).ThenBy(r => r.Sheet).ThenBy(r => int.TryParse(r.Sort, out var n) ? n : 99999))
                w.Row(new object[] { r.Table, r.Program, r.Sheet, r.Sort, r.Column, r.Label, r.CellType, r.Width, r.Div, r.Visible, r.Valid, r.Default, r.Selectable }.Concat(_divs.Select(d => Rule(r, d))).ToArray());

        var sb = new System.Text.StringBuilder();
        sb.AppendLine(); sb.AppendLine("## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)");
        sb.AppendLine("규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.");
        sb.AppendLine();
        sb.AppendLine("| 테이블 | 프로그램 | 시트 | " + string.Join(" | ", _divs) + " |");
        sb.AppendLine("|---|---|---|" + string.Concat(_divs.Select(_ => "---:|")));
        foreach (var g in rows.GroupBy(r => (r.Table, r.Program, r.Sheet)).OrderBy(g => g.Key.Table).ThenBy(g => g.Key.Program).ThenBy(g => g.Key.Sheet))
            sb.AppendLine($"| {g.Key.Table} | {g.Key.Program} | {g.Key.Sheet} | " + string.Join(" | ", _divs.Select(d =>
            {
                var c = g.Select(r => Rule(r, d)).ToList();
                int must = c.Count(x => x == "필수" || x == "기본"), opt = c.Count(x => x == "선택");
                return must + opt == 0 ? "·" : $"{must}/{opt}";
            })) + " |");

        // 실행 결과 대조 (SHEET_COLUMNS 기준)
        if (_exec.Count > 0)
        {
            using var w = new CsvOut(Path.Combine(dir, "grid_diff.csv"), "program_id", "sheet", "division", "diff", "column", "rule");
            int diffs = 0, compared = 0;
            foreach (var g in rows.Where(r => r.Table == "SCM_MST_SHEET_COLUMNS").GroupBy(r => (r.Program, r.Sheet)))
                foreach (var d in _divs)
                {
                    // SP 에 division 파라미터가 없으면 실행 결과 division 이 "" → 모든 division 에 동일 적용
                    if (!_exec.TryGetValue(Key(g.Key.Program, g.Key.Sheet, d), out var ex) && !_exec.TryGetValue(Key(g.Key.Program, g.Key.Sheet, ""), out ex)) continue;
                    compared++;
                    var execCols = ex.Select(x => x.GetValueOrDefault("COLUMN_NAME", "")).Where(x => x != "").ToHashSet(StringComparer.OrdinalIgnoreCase);
                    var ruleCols = g.Where(r => Rule(r, d) is "필수" or "기본").ToDictionary(r => r.Column, r => Rule(r, d), StringComparer.OrdinalIgnoreCase);
                    foreach (var c in ruleCols.Keys.Where(c => !execCols.Contains(c))) { w.Row(g.Key.Program, g.Key.Sheet, d, "규칙O·실행X", c, ruleCols[c]); diffs++; }
                    foreach (var c in execCols.Where(c => !ruleCols.ContainsKey(c)))
                    {
                        var mr = g.FirstOrDefault(r => r.Column.Equals(c, StringComparison.OrdinalIgnoreCase));
                        w.Row(g.Key.Program, g.Key.Sheet, d, "실행O·규칙X", c, mr == null ? "메타에 없음(SP 생성 컬럼)" : Rule(mr, d)); diffs++;
                    }
                }
            sb.AppendLine();
            sb.AppendLine(compared == 0 ? "실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치)."
                                        : $"실제 SP 실행 결과 대조: {compared}개 시트×division 비교, 차이 {diffs}건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.");
        }
        return sb.ToString();
    }
}
