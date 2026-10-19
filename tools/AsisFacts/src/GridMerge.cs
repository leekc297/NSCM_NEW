namespace AsisFacts;

/// <summary>
/// 최종 Grid = 메타 규칙(10장) + 코드 하드코딩 컬럼 + 코드 표시 변경(Visible 대입, 분기 조건 포함)을 division 별로 합성.
/// 셀 값: 필수/기본/선택/숨김(메타), 코드추가, →표시/→숨김(코드 변경), 뒤에 '?' 는 분기 조건을 정적으로 판단 못 함.
/// </summary>
public static class GridMerge
{
    public static string Write(string dir, string screenId, List<GridCode.Row> code, List<GridView.MetaRow> meta, List<string> divs)
    {
        if (divs.Count == 0) return "";
        // 컬럼 키: (시트, 컬럼명)
        var cells = new Dictionary<(string sheet, string col), (string source, string label, Dictionary<string, string> st)>(new KeyCmp());
        foreach (var r in meta.Where(m => m.Table == "SCM_MST_SHEET_COLUMNS"))
            cells[(r.Sheet, r.Column)] = ("META", r.Label, divs.ToDictionary(d => d, d => GridView.Rule(r, d)));

        var sheetsOfMeta = meta.Select(m => m.Sheet).Distinct(StringComparer.OrdinalIgnoreCase).ToList();
        int unknown = 0;
        var unknownKinds = new Dictionary<string, int>();
        string UnknownKind(string cond)
        {
            var c = cond ?? "";
            if (System.Text.RegularExpressions.Regex.IsMatch(c, @"GetColumnTag|GetColumnIndex|ColumnHeader|e\.Column|e\.Row")) return "런타임:컬럼별 루프/태그 판정";
            if (System.Text.RegularExpressions.Regex.IsMatch(c, @"\b(cbo|chk|txt|rdo|dtp|drp|lst|clb|usr|btn)\w*\.|\.(Checked|ControlValues|SelectedValue|Text|Value)\b")) return "런타임:화면컨트롤값";
            if (System.Text.RegularExpressions.Regex.IsMatch(c, @"UserInfo|GroupID|UserId|Authority|ACL", System.Text.RegularExpressions.RegexOptions.IgnoreCase)) return "런타임:사용자/권한";
            if (System.Text.RegularExpressions.Regex.IsMatch(c, @"\b(dt|ds|dr|row)\w*\b|Rows\.Count|Tables\[", System.Text.RegularExpressions.RegexOptions.IgnoreCase)) return "런타임:조회데이터";
            if (System.Text.RegularExpressions.Regex.IsMatch(c, @"_popupType|Mode|sGubun|gubun|Type\b", System.Text.RegularExpressions.RegexOptions.IgnoreCase)) return "런타임:호출파라미터";
            return "정적평가 미지원식";
        }
        foreach (var r in code.OrderBy(r => r.File).ThenBy(r => r.Line))
        {
            bool colDef = GridCode.IsColumnDef(r);
            bool visSet = r.Api == "set:Visible" || r.Api.Contains("Visible") || r.Api.Contains("Hidden");
            if (!colDef && !visSet) continue;
            var colNames = colDef ? new List<string> { Arg(r, 1) } : (r.Columns ?? "").Split(" || ", StringSplitOptions.RemoveEmptyEntries).ToList();
            colNames = colNames.Where(c => c != "" && !c.StartsWith("{")).ToList();
            if (colNames.Count == 0) continue;
            // 적용 시트: 시트 문맥이 있으면 그 시트, 없으면 메타 시트 전체(또는 '(시트 미상)')
            var allSheets = sheetsOfMeta.Union(code.Where(x => x.Api == "AddSheet").Select(x => Arg(x, 1)).Where(x => x != "" && !x.StartsWith("{")), StringComparer.OrdinalIgnoreCase)
                                        .Union(code.SelectMany(x => CondEval.SheetLiterals(x.Cond)), StringComparer.OrdinalIgnoreCase).ToList();
            // 조건식이 시트명을 직접 비교하면 모든 시트에 대해 조건으로 판정, 아니면 시트 문맥(같은 메서드의 직전 시트 지정) 사용
            // 시트 범위는 같은 클래스(폼/팝업)가 AddSheet 로 만든 시트로 한정한다. 팝업의 하드코딩 컬럼이 본 화면 시트에 섞이지 않게.
            var clsSheets = code.Where(x => x.Cls == r.Cls && x.Api == "AddSheet").Select(x => Arg(x, 1)).Where(x => x != "" && !x.StartsWith("{"))
                                .Concat(code.Where(x => x.Cls == r.Cls).SelectMany(x => CondEval.SheetLiterals(x.Cond)))   // 조건식에 쓰인 시트명도 그 클래스의 시트
                                .Distinct(StringComparer.OrdinalIgnoreCase).ToList();
            var scope = clsSheets.Count > 0 ? clsSheets : allSheets;
            var sheets = r.Cond.Contains("SheetName", StringComparison.OrdinalIgnoreCase) && scope.Count > 0 ? scope
                       : r.SheetHint != "" ? new List<string> { r.SheetHint } : scope.Count > 0 ? scope : new List<string> { "(시트 미상)" };
            foreach (var sheet in sheets)
                foreach (var col in colNames)
                {
                    if (!cells.TryGetValue((sheet, col), out var c))
                    {
                        c = (colDef ? (r.Source == "HARDCODED" ? "CODE" : "CODE_LOOP") : "CODE_ONLY_CHANGE", colDef ? Arg(r, 0) : "", divs.ToDictionary(d => d, d => ""));
                        cells[(sheet, col)] = c;
                    }
                    foreach (var d in divs)
                    {
                        var cond = CondEval.Chain(r.Cond, d, sheet == "(시트 미상)" ? null : sheet);
                        if (cond == false) continue;
                        string val;
                        if (colDef) val = Arg(r, 4) is var v && (v == "?false" || v == "false") ? "코드추가(숨김)" : "코드추가";
                        else
                        {
                            // Visible = <값>: 리터럴 또는 division 조건식
                            var raw = r.Api == "set:Visible" ? r.Args.Trim('{', '}', '?') : Arg(r, Math.Max(0, r.Args.Split(" ¦ ").Length - 1)).Trim('{', '}', '?');
                            bool? vis = raw == "true" ? true : raw == "false" ? false : CondEval.Eval(raw, d, sheet);
                            if (r.Api.Contains("Hidden")) vis = vis is bool hb ? !hb : null;
                            val = vis == true ? "→표시" : vis == false ? "→숨김" : "→표시?숨김";
                        }
                        if (cond == null) { val += "?"; unknown++; var uk = UnknownKind(r.Cond); unknownKinds[uk] = unknownKinds.GetValueOrDefault(uk) + 1; }
                        c.st[d] = c.st[d] == "" ? val : c.st[d] + " " + val;
                    }
                }
        }

        // ── 시트 연결 규칙: 메타 시트가 코드에서 참조되는가 / 코드 시트가 메타에 있는가
        var codeSheets = code.Where(r => r.Api is "AddSheet" or "ChangeSheet" or "ChangeActiveSheet" or "InitSheet" or "GetSheetInfo")
                             .SelectMany(r => r.Args.Split(" ¦ ")).Concat(code.Select(r => r.SheetHint))
                             .SelectMany(v => v.Split(" || ")).Select(v => v.Trim()).Where(v => v != "" && !v.Contains('{') && !v.StartsWith("?"))
                             .Concat(code.SelectMany(x => CondEval.SheetLiterals(x.Cond))).ToHashSet(StringComparer.OrdinalIgnoreCase);
        var sheetRule = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        foreach (var sh in cells.Keys.Select(k => k.sheet).Distinct(StringComparer.OrdinalIgnoreCase))
        {
            bool inMeta = sheetsOfMeta.Contains(sh, StringComparer.OrdinalIgnoreCase);
            bool inCode = codeSheets.Contains(sh);
            bool hardCols = cells.Any(c => c.Key.sheet.Equals(sh, StringComparison.OrdinalIgnoreCase) && c.Value.source is "CODE" or "CODE_LOOP");
            sheetRule[sh] = inMeta && inCode ? "META+코드연결" : inMeta && !inCode ? (hardCols ? "메타 미연결(코드는 하드코딩)" : "메타 정의만, 코드 미참조(미사용 가능)")
                          : inCode && hardCols ? "코드 하드코딩 전용(메타 없음)" : inCode ? "코드 시트, 컬럼 미확인(DB루프/동적)" : "(시트 미상)";
        }

        using (var w = new CsvOut(Path.Combine(dir, "grid_effective.csv"), new[] { "sheet", "sheet_rule", "column", "label", "source" }.Concat(divs).ToArray()))
            foreach (var kv in cells.OrderBy(k => k.Key.sheet).ThenBy(k => k.Value.source).ThenBy(k => k.Key.col))
                w.Row(new object[] { kv.Key.sheet, sheetRule.GetValueOrDefault(kv.Key.sheet, ""), kv.Key.col, kv.Value.label, kv.Value.source }.Concat(divs.Select(d => kv.Value.st[d])).ToArray());

        var sb = new System.Text.StringBuilder();
        sb.AppendLine(); sb.AppendLine("## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)");
        sb.AppendLine("최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).");
        sb.AppendLine();
        sb.AppendLine("| 시트 | 연결 규칙 | " + string.Join(" | ", divs) + " |"); sb.AppendLine("|---|---|" + string.Concat(divs.Select(_ => "---:|")));
        foreach (var g in cells.GroupBy(k => k.Key.sheet).OrderBy(g => g.Key))
            sb.AppendLine($"| {g.Key} | {sheetRule.GetValueOrDefault(g.Key, "")} | " + string.Join(" | ", divs.Select(d =>
            {
                int vis = 0, q = 0;
                foreach (var c in g)
                {
                    var s = c.Value.st[d];
                    if (s == "") continue;
                    var last = s.Split(' ').Last();
                    bool shown = last.StartsWith("→표시") || last.StartsWith("코드추가") && !last.Contains("숨김") || last is "필수" or "기본";
                    if (last.StartsWith("→") && last.Contains("숨김") && !last.StartsWith("→표시")) shown = false;
                    if (shown) vis++;
                    if (s.Contains('?')) q++;
                }
                return vis == 0 && q == 0 ? "·" : q > 0 ? $"{vis} (?{q})" : $"{vis}";
            })) + " |");
        sb.AppendLine();
        sb.AppendLine("연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.");
        if (unknownKinds.Count > 0) sb.AppendLine("판단불가(?) 분류: " + string.Join(", ", unknownKinds.OrderByDescending(k => k.Value).Select(k => $"{k.Key} {k.Value}")) + " — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.");
        sb.AppendLine($"분기 조건 판단불가 적용 {unknown}건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.");
        return sb.ToString();
    }

    static string Arg(GridCode.Row r, int i) { var a = r.Args.Split(" ¦ "); return i < a.Length ? a[i] : ""; }

    sealed class KeyCmp : IEqualityComparer<(string, string)>
    {
        public bool Equals((string, string) a, (string, string) b) => string.Equals(a.Item1, b.Item1, StringComparison.OrdinalIgnoreCase) && string.Equals(a.Item2, b.Item2, StringComparison.OrdinalIgnoreCase);
        public int GetHashCode((string, string) k) => HashCode.Combine(k.Item1?.ToUpperInvariant(), k.Item2?.ToUpperInvariant());
    }
}
