using System.Diagnostics;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;

namespace AsisFacts;

/// <summary>
/// 4단계 선행: 단독 실행 Agent. 화면 Fact Pack(screens\ID\*) 만을 근거로 LLM 이 분석서를 쓰고,
/// 프로그램이 건수 게이트(엔드포인트·이벤트·시트 전부 언급)를 검사한다. 실패 시 누락 목록을 붙여 1회 재시도.
///   AsisFacts agent DMF0021 [--driver claude-cli|api|dry] [--model m] [--agent-out dir]
///   driver 기본: ANTHROPIC_API_KEY 있으면 api, 없으면 claude-cli (headless `claude -p`), dry = 프롬프트만 저장
/// </summary>
public static class Agent
{
    static readonly string[] Docs = { "analysis.md", "source_links.md", "web_components.md", "oracle_migration.md", "tobe_design.md" };
    /// <summary>2차 문서 3종: 업무분석서 · 화면설계서 · 단위테스트 (1차 분석서 5종 + Fact Pack 을 근거로 생성)</summary>
    static readonly string[] Docs2 = { "business_analysis.md", "screen_design.md", "unit_test.md" };

    public static int Run(Config cfg, string outDir, List<string> ids, string driver, string model, string agentOut, string phase = null)
    {
        phase = (phase ?? "all").ToLowerInvariant();
        if (phase is not ("all" or "analysis" or "docs")) { Console.Error.WriteLine("--phase 는 all|analysis|docs"); return 2; }
        if (ids.Count == 0) { Console.Error.WriteLine("화면ID 를 지정하세요"); return 2; }
        driver = driver ?? (string.IsNullOrEmpty(Environment.GetEnvironmentVariable("ANTHROPIC_API_KEY")) ? "claude-cli" : "api");
        model ??= Environment.GetEnvironmentVariable("ASISFACTS_MODEL") ?? "claude-sonnet-4-5";
        agentOut ??= Path.Combine(outDir, "agent");
        int rc = 0;
        foreach (var id in ids) rc |= RunOne(outDir, id.ToUpperInvariant(), driver, model, agentOut, phase);
        return rc;
    }

    static int RunOne(string outDir, string id, string driver, string model, string agentOut, string phase)
    {
        var sdir = Path.Combine(outDir, "screens", id);
        if (!Directory.Exists(sdir)) { Console.Error.WriteLine($"{id}: Fact Pack 없음 ({sdir}) — pack 먼저"); return 2; }
        var dir = Path.Combine(agentOut, id);
        Directory.CreateDirectory(dir);

        var facts = LoadFacts(sdir);
        var bundle = Bundle(sdir, facts);
        File.WriteAllText(Path.Combine(dir, "_bundle.md"), bundle, new UTF8Encoding(true));
        var prompt = Prompt(id, facts, bundle);
        File.WriteAllText(Path.Combine(dir, "_prompt.txt"), prompt, new UTF8Encoding(true));
        Console.WriteLine($"{id}: bundle {bundle.Length / 1024} KB, endpoints {facts.Endpoints.Count}, events {facts.Events.Count}, sheets {facts.Sheets.Count}, driver={driver}");
        if (driver == "dry")
        {
            var d1 = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            foreach (var d in Docs) { var p = Path.Combine(dir, d); if (File.Exists(p)) d1[d] = File.ReadAllText(p); }
            File.WriteAllText(Path.Combine(dir, "_prompt2.txt"), Prompt2(id, facts, bundle, d1), new UTF8Encoding(true));
            Console.WriteLine($"{id}: dry — {dir}\\_prompt.txt, _prompt2.txt 생성"); return 0;
        }

        var files = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        var missing = new List<string>();
        bool phase1 = phase != "docs" || !File.Exists(Path.Combine(dir, "analysis.md"));
        if (phase1)
        {
            string response = Call(driver, model, prompt);
            File.WriteAllText(Path.Combine(dir, "_response_1.md"), response, new UTF8Encoding(true));
            files = Split(response);
            missing = Gate(files, facts);
            if (missing.Count > 0)
            {
                Console.WriteLine($"{id}: 1차 게이트 실패 {missing.Count}건 → 누락 목록을 붙여 재시도");
                var retry = prompt + RetryNote(missing);
                response = Call(driver, model, retry);
                File.WriteAllText(Path.Combine(dir, "_response_2.md"), response, new UTF8Encoding(true));
                files = Split(response);
                missing = Gate(files, facts);
            }
            foreach (var kv in files) File.WriteAllText(Path.Combine(dir, kv.Key), kv.Value, new UTF8Encoding(true));
        }
        else
        {
            foreach (var d in Docs) { var p = Path.Combine(dir, d); if (File.Exists(p)) files[d] = File.ReadAllText(p); }
            missing = Gate(files, facts);
            Console.WriteLine($"{id}: 1차 분석서 재사용 ({files.Count}/{Docs.Length})");
        }

        // ── 2차: 업무분석서 · 화면설계서 · 단위테스트 ──
        var files2 = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        var missing2 = new List<string>();
        bool phase2 = phase != "analysis";
        if (phase2)
        {
            var prompt2 = Prompt2(id, facts, bundle, files);
            File.WriteAllText(Path.Combine(dir, "_prompt2.txt"), prompt2, new UTF8Encoding(true));
            string response = Call(driver, model, prompt2);
            File.WriteAllText(Path.Combine(dir, "_response2_1.md"), response, new UTF8Encoding(true));
            files2 = Split(response);
            missing2 = Gate2(files2, facts);
            if (missing2.Count > 0)
            {
                Console.WriteLine($"{id}: 2차 게이트 실패 {missing2.Count}건 → 누락 목록을 붙여 재시도");
                response = Call(driver, model, prompt2 + RetryNote(missing2));
                File.WriteAllText(Path.Combine(dir, "_response2_2.md"), response, new UTF8Encoding(true));
                files2 = Split(response);
                missing2 = Gate2(files2, facts);
            }
            foreach (var kv in files2) File.WriteAllText(Path.Combine(dir, kv.Key), kv.Value, new UTF8Encoding(true));
        }

        var pass1 = missing.Count == 0 && Docs.All(files.ContainsKey);
        var pass2 = !phase2 || (missing2.Count == 0 && Docs2.All(files2.ContainsKey));
        using (var w = new CsvOut(Path.Combine(dir, "_gate.csv"), "check", "status", "detail"))
        {
            foreach (var d in Docs) w.Row("doc:" + d, files.ContainsKey(d) ? "OK" : "MISSING", "");
            foreach (var m in missing) w.Row("fact", "MISSING", m);
            w.Row("summary", pass1 ? "PASS" : "FAIL", $"missing facts {missing.Count}, docs {files.Count}/{Docs.Length}");
            if (phase2)
            {
                foreach (var d in Docs2) w.Row("doc2:" + d, files2.ContainsKey(d) ? "OK" : "MISSING", "");
                foreach (var m in missing2) w.Row("fact2", "MISSING", m);
                w.Row("summary2", pass2 ? "PASS" : "FAIL", $"missing facts {missing2.Count}, docs {files2.Count}/{Docs2.Length}");
            }
            w.Row("total", pass1 && pass2 ? "PASS" : "FAIL", $"analysis {(pass1 ? "PASS" : "FAIL")}, docs3 {(phase2 ? (pass2 ? "PASS" : "FAIL") : "skip")}");
        }
        Console.WriteLine($"{id}: {(pass1 && pass2 ? "PASS" : "FAIL")} → {dir}  (분석서 {files.Count}/{Docs.Length} 누락 {missing.Count}{(phase2 ? $", 문서3종 {files2.Count}/{Docs2.Length} 누락 {missing2.Count}" : "")})");
        return pass1 && pass2 ? 0 : 1;
    }

    static string RetryNote(List<string> missing) =>
        "\n\n## 재작성 지시\n이전 출력에서 아래 사실이 누락되었습니다. 모든 문서를 다시 출력하되 아래 항목이 반드시 포함되어야 합니다.\n" + string.Join("\n", missing.Select(m => "- " + m));

    // ───────────── Fact Pack 로드 ─────────────
    sealed class Facts
    {
        public List<string> Endpoints = new(), Events = new(), Sheets = new(), Controls = new(), SpNames = new();
        public string Mode = "";
    }

    static Facts LoadFacts(string sdir)
    {
        var f = new Facts();
        string P(string n) => Path.Combine(sdir, n);
        if (File.Exists(P("endpoints.csv")))
            foreach (var r in CsvIn.Read(P("endpoints.csv")))
            {
                if (r["variant"] == "legacy") continue;
                var k = r["key"] != "" ? r["key"] : r["candidate"];
                if (k != "" && !k.Contains("PseudoDataClient") && !f.Endpoints.Contains(k)) f.Endpoints.Add(k);
                var m = Regex.Match(r["sp_or_sql"] ?? "", @"^SP (\S+)");
                if (m.Success && !f.SpNames.Contains(m.Groups[1].Value)) f.SpNames.Add(m.Groups[1].Value);
            }
        if (File.Exists(P("events.csv")))
            foreach (var r in CsvIn.Read(P("events.csv")))
                if (r["variant"] != "legacy" && r["op"] == "+=" && r["handler"] != "<lambda>" && !f.Events.Contains(r["handler"])) f.Events.Add(r["handler"]);
        if (File.Exists(P("grid_effective.csv")))
            foreach (var r in CsvIn.Read(P("grid_effective.csv")))
                if (r["sheet"] != "(시트 미상)" && !f.Sheets.Contains(r["sheet"])) f.Sheets.Add(r["sheet"]);
        if (File.Exists(P("controls.csv")))
            foreach (var r in CsvIn.Read(P("controls.csv")))
                if (r["variant"] != "legacy" && Regex.IsMatch(r["type"], "Spread|Usr|Button|Combo|Check|Text|Date|Picker|List", RegexOptions.IgnoreCase) && !Regex.IsMatch(r["type"], "ImageList|ToolTip|Timer", RegexOptions.IgnoreCase) && !f.Controls.Contains(r["name"])) f.Controls.Add(r["name"]);
        var idx = Path.Combine(Path.GetDirectoryName(sdir)!, "_index.csv");
        if (File.Exists(idx)) foreach (var r in CsvIn.Read(idx)) if (r["screen_id"] == Path.GetFileName(sdir)) f.Mode = r["grid_mode"];
        return f;
    }

    static string Bundle(string sdir, Facts facts)
    {
        var sb = new StringBuilder();
        var summary = Directory.EnumerateFiles(sdir, "*_summary.md").FirstOrDefault();
        if (summary != null) sb.AppendLine(Cap(File.ReadAllText(summary), 60_000));
        foreach (var (name, cap) in new[] { ("endpoints.csv", 40_000), ("flow.csv", 40_000), ("events.csv", 15_000), ("controls.csv", 20_000), ("props.csv", 20_000), ("grid_effective.csv", 40_000), ("grid_code.csv", 40_000), ("meta_reads.csv", 15_000), ("commented_calls.csv", 8_000) })
        {
            var p = Path.Combine(sdir, name);
            if (!File.Exists(p)) continue;
            var lines = File.ReadAllLines(p).Where(l => !l.Contains("\"legacy\",")).ToList();
            if (name == "props.csv") lines = lines.Where((l, i) => i == 0 || Regex.IsMatch(l, "\"(Text|Orientation|SplitterDistance|Size|Control|Dock|Visible|Enabled|ReadOnly|Checked|UsrPanelType|Panel1Collapsed|Panel2Collapsed)\",")).ToList();
            sb.AppendLine($"\n### FILE {name} ({lines.Count - 1} rows)\n```csv");
            sb.AppendLine(Cap(string.Join("\n", lines), cap));
            sb.AppendLine("```");
        }
        return sb.ToString();
    }

    static string Cap(string s, int n) => s.Length <= n ? s : s[..n] + $"\n… (truncated, {s.Length - n} chars more — 전체는 Fact Pack CSV 참조)";

    static string Prompt(string id, Facts f, string bundle) => $@"당신은 LG에너지솔루션 GSCM(C#.NET WinForms, FarPoint Spread, TheOne FoxQuery) → NSCM(React + Wijmo + Oracle) 전환 프로젝트의 As-is 분석 작성자입니다.
아래 '사실 묶음(Fact Pack)'은 정적 파서가 소스와 DB에서 기계적으로 추출한 것입니다. **이 묶음에 있는 사실만** 사용하고, 없는 것은 추측하지 말고 '확인 필요'로 표기하세요.
출력은 한국어 Markdown 문서 {Docs.Length}개이며, 각 문서는 정확히 다음 구분자로 시작합니다: `=== FILE: 파일명 ===`

필수 조건 (프로그램이 기계적으로 검사합니다. 하나라도 빠지면 반려):
1. analysis.md 에 아래 엔드포인트 {f.Endpoints.Count}개가 **모두** 원문 그대로 등장: {string.Join(", ", f.Endpoints.Select(e => "`" + e + "`"))}
2. analysis.md 에 아래 이벤트 핸들러 {f.Events.Count}개가 모두 등장: {string.Join(", ", f.Events.Select(e => "`" + e + "`"))}
3. web_components.md 에 아래 시트 {f.Sheets.Count}개가 모두 등장: {string.Join(", ", f.Sheets.Select(e => "`" + e + "`"))}
4. oracle_migration.md 에 아래 SP {f.SpNames.Count}개가 모두 등장: {string.Join(", ", f.SpNames.Select(e => "`" + e + "`"))}
5. 주석 처리된 호출(commented_calls)은 '주석 처리됨'으로만 언급하고 현행 기능으로 쓰지 말 것.

문서별 내용:
- analysis.md: 화면 개요(ID, 도메인, 파일 구성 current/shared/legacy), 기능 흐름(진입점→메서드→엔드포인트 표), 엔드포인트 전체 표(상태·SP·참조 테이블), 이벤트 배선 표, Grid 구성 방식(`{f.Mode}`)과 division별 차이, 확인 필요 항목.
- source_links.md: 파일 경로·줄 번호 기준 링크 표(파일, 메서드, 줄, 내용). 모든 엔드포인트 호출 지점 포함.
- web_components.md: 컨트롤 → React/Wijmo 컴포넌트 매핑 표(라벨은 props.csv 의 LayoutControlItem.Text/컨트롤 Text 원문), 화면 배치(props.csv 의 SplitContainer Orientation·SplitterDistance·Size → 상/하·좌/우 분할 비율), 시트별 Grid 컬럼(메타 규칙 + 코드 하드코딩 + division별 표시 차이 — grid_effective 기준), 시트 연결 규칙.
- oracle_migration.md: 호출 SP 인벤토리(참조 테이블·EXEC 체인), 공통코드 분기(code=X → 테이블), FoxQuery 미등록/직접호출 SP, Oracle 전환 시 확인 포인트. 난이도는 사실에 근거해서만.
- tobe_design.md: 조회조건(컨트롤 기준), 액션별(버튼/이벤트) 호출 API 후보, division별 Grid 변형 요약, 권한(C/R/U/D) 관련 사실, 미확정 사항.

# Fact Pack — {id}
{bundle}";

    // ───────────── LLM 호출 ─────────────
    static string Call(string driver, string model, string prompt)
    {
        return driver switch
        {
            "api" => CallApi(model, prompt).GetAwaiter().GetResult(),
            "claude-cli" => CallCli(model, prompt),
            _ => throw new ArgumentException("driver: claude-cli | api | dry")
        };
    }

    static string CallCli(string model, string prompt)
    {
        var exe = FindClaude();
        var psi = new ProcessStartInfo(exe) { RedirectStandardInput = true, RedirectStandardOutput = true, RedirectStandardError = true, UseShellExecute = false, StandardInputEncoding = new UTF8Encoding(false), StandardOutputEncoding = Encoding.UTF8 };
        foreach (var a in new[] { "-p", "--output-format", "text", "--model", model }) psi.ArgumentList.Add(a);
        using var p = Process.Start(psi) ?? throw new InvalidOperationException("claude CLI 실행 실패");
        p.StandardInput.Write(prompt); p.StandardInput.Close();
        var outTask = p.StandardOutput.ReadToEndAsync(); var errTask = p.StandardError.ReadToEndAsync();
        if (!p.WaitForExit(20 * 60 * 1000)) { try { p.Kill(true); } catch { } throw new TimeoutException("claude CLI 20분 초과"); }
        var err = errTask.Result;
        if (p.ExitCode != 0)
        {
            // 일부 환경의 claude 래퍼는 stdin 을 받지 않고 `claude -p "<prompt>"` 만 허용 → 인자로 재시도
            if (err.Contains("only `claude -p") && prompt.Length < 1_500_000) return CallCliArg(exe, model, prompt);
            throw new InvalidOperationException($"claude CLI exit {p.ExitCode}: {err}");
        }
        return outTask.Result;
    }

    /// <summary>claude CLI 위치: 환경변수 ASISFACTS_CLAUDE → PATH 의 claude(.exe/.cmd) → 일반 설치 경로</summary>
    static string FindClaude()
    {
        var env = Environment.GetEnvironmentVariable("ASISFACTS_CLAUDE");
        if (!string.IsNullOrEmpty(env) && File.Exists(env)) return env;
        var names = OperatingSystem.IsWindows() ? new[] { "claude.exe", "claude.cmd", "claude.bat", "claude" } : new[] { "claude" };
        foreach (var dir in (Environment.GetEnvironmentVariable("PATH") ?? "").Split(Path.PathSeparator, StringSplitOptions.RemoveEmptyEntries))
            foreach (var n in names) { var f = Path.Combine(dir.Trim('"'), n); if (File.Exists(f)) return f; }
        var home = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
        var cands = new[]
        {
            Path.Combine(home, ".local", "bin", "claude.exe"), Path.Combine(home, ".local", "bin", "claude"),
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "npm", "claude.cmd"),
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Programs", "claude", "claude.exe"),
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "AnthropicClaude", "claude.exe"),
            Path.Combine(home, "AppData", "Roaming", "Claude", "claude.exe"),
        };
        foreach (var c in cands) if (File.Exists(c)) return c;
        throw new FileNotFoundException("claude CLI 를 찾지 못했습니다. 환경변수 ASISFACTS_CLAUDE 에 전체 경로를 지정하세요 (예: C:\\Users\\<me>\\.local\\bin\\claude.exe). 또는 --driver api + ANTHROPIC_API_KEY.");
    }

    static string CallCliArg(string exe, string model, string prompt)
    {
        var psi = new ProcessStartInfo(exe) { RedirectStandardOutput = true, RedirectStandardError = true, UseShellExecute = false, StandardOutputEncoding = Encoding.UTF8 };
        psi.ArgumentList.Add("-p"); psi.ArgumentList.Add(prompt);
        using var p = Process.Start(psi) ?? throw new InvalidOperationException("claude CLI 실행 실패");
        var outTask = p.StandardOutput.ReadToEndAsync(); var errTask = p.StandardError.ReadToEndAsync();
        if (!p.WaitForExit(20 * 60 * 1000)) { try { p.Kill(true); } catch { } throw new TimeoutException("claude CLI 20분 초과"); }
        if (p.ExitCode != 0) throw new InvalidOperationException($"claude CLI exit {p.ExitCode}: {errTask.Result}");
        return outTask.Result;
    }

    static async Task<string> CallApi(string model, string prompt)
    {
        var key = Environment.GetEnvironmentVariable("ANTHROPIC_API_KEY") ?? throw new InvalidOperationException("ANTHROPIC_API_KEY 없음");
        using var http = new HttpClient { Timeout = TimeSpan.FromMinutes(20) };
        http.DefaultRequestHeaders.Add("x-api-key", key);
        http.DefaultRequestHeaders.Add("anthropic-version", "2023-06-01");
        var body = JsonSerializer.Serialize(new { model, max_tokens = 32000, messages = new[] { new { role = "user", content = prompt } } });
        var res = await http.PostAsync("https://api.anthropic.com/v1/messages", new StringContent(body, Encoding.UTF8, "application/json"));
        var txt = await res.Content.ReadAsStringAsync();
        if (!res.IsSuccessStatusCode) throw new InvalidOperationException($"API {(int)res.StatusCode}: {txt[..Math.Min(500, txt.Length)]}");
        using var doc = JsonDocument.Parse(txt);
        var sb = new StringBuilder();
        foreach (var c in doc.RootElement.GetProperty("content").EnumerateArray()) if (c.GetProperty("type").GetString() == "text") sb.Append(c.GetProperty("text").GetString());
        return sb.ToString();
    }

    // ───────────── 분할 / 게이트 ─────────────
    static Dictionary<string, string> Split(string response)
    {
        var files = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        var parts = Regex.Split(response, @"^=== FILE:\s*([^=\r\n]+?)\s*===\s*$", RegexOptions.Multiline);
        for (int i = 1; i + 1 < parts.Length; i += 2) files[parts[i].Trim()] = parts[i + 1].Trim() + "\n";
        return files;
    }

    static List<string> Gate(Dictionary<string, string> files, Facts f)
    {
        var missing = new List<string>();
        string Get(string n) => files.TryGetValue(n, out var v) ? v : "";
        var a = Get("analysis.md"); var w = Get("web_components.md"); var o = Get("oracle_migration.md");
        foreach (var e in f.Endpoints) if (!a.Contains(e, StringComparison.OrdinalIgnoreCase)) missing.Add($"analysis.md 엔드포인트 `{e}`");
        foreach (var e in f.Events) if (!a.Contains(e, StringComparison.OrdinalIgnoreCase)) missing.Add($"analysis.md 이벤트 핸들러 `{e}`");
        foreach (var s in f.Sheets) if (!w.Contains(s, StringComparison.OrdinalIgnoreCase)) missing.Add($"web_components.md 시트 `{s}`");
        foreach (var s in f.SpNames) if (!o.Contains(s, StringComparison.OrdinalIgnoreCase)) missing.Add($"oracle_migration.md SP `{s}`");
        foreach (var d in Docs) if (!files.ContainsKey(d)) missing.Add($"문서 {d} 없음");
        return missing;
    }

    // ───────────── 2차 문서 3종 프롬프트 ─────────────
    static string Prompt2(string id, Facts f, string bundle, Dictionary<string, string> docs1)
    {
        string D(string n) => docs1.TryGetValue(n, out var v) ? Cap(v, 30_000) : "(없음)";
        var ctrls = string.Join(", ", f.Controls.Select(e => "`" + e + "`"));
        return $@"당신은 LG에너지솔루션 GSCM(C#.NET WinForms) → NSCM(React + Wijmo + Oracle) 전환 프로젝트의 산출물 작성자입니다.
아래에는 정적 파서가 추출한 '사실 묶음(Fact Pack)'과, 그것을 근거로 작성된 1차 분석서가 있습니다. **여기에 있는 사실만** 사용하고 없는 것은 '확인 필요'로 표기하세요. 추측으로 업무 규칙을 지어내지 마세요.
출력은 한국어 Markdown 문서 {Docs2.Length}개이며, 각 문서는 정확히 다음 구분자로 시작합니다: `=== FILE: 파일명 ===`

필수 조건 (프로그램이 기계적으로 검사합니다. 하나라도 빠지면 반려):
1. business_analysis.md 에 엔드포인트 {f.Endpoints.Count}개 전부 원문 등장: {string.Join(", ", f.Endpoints.Select(e => "`" + e + "`"))}
2. business_analysis.md 에 SP {f.SpNames.Count}개 전부 등장: {string.Join(", ", f.SpNames.Select(e => "`" + e + "`"))}
3. screen_design.md 에 컨트롤 {f.Controls.Count}개 전부 등장: {ctrls}
4. screen_design.md 에 시트 {f.Sheets.Count}개 전부 등장: {string.Join(", ", f.Sheets.Select(e => "`" + e + "`"))}
5. screen_design.md 에 이벤트 핸들러 {f.Events.Count}개와 엔드포인트 전부 등장: {string.Join(", ", f.Events.Select(e => "`" + e + "`"))}
6. unit_test.md 에 이벤트 핸들러 전부, 엔드포인트 전부, 시트 전부가 '근거' 열에 등장 (각각 최소 1개 테스트 케이스).
7. 주석 처리된 호출(commented_calls)은 현행 기능으로 쓰지 말 것. 테스트 케이스로도 만들지 말 것.

문서별 내용:
- business_analysis.md (업무분석서): 1 업무 목적·범위, 2 사용자 시나리오(행위→시스템 처리→결과), 3 업무 흐름도(텍스트 단계), 4 업무 규칙(SP 분기 조건·필수값·검증·날짜/버킷 규칙 — 사실에 근거), 5 데이터 흐름 표(엔드포인트 → SP → 읽기/쓰기 테이블), 6 division·권한별 변형, 7 외부 인터페이스(사실에 있을 때만), 8 미확정·확인 필요.
- screen_design.md (화면설계서): 1 화면 개요(ID, 명칭, 메뉴 위치는 확인 필요), 2 화면 레이아웃 — **props.csv 의 SplitContainer(Orientation·SplitterDistance·Size) 와 controls.csv 의 parent 체인으로 분할 트리를 그대로 그린 텍스트 와이어프레임**(상/하·좌/우, 비율 %), 영역: 조회조건·버튼·그리드·팝업, 3 컨트롤 명세 표(컨트롤명·타입·**라벨=props.csv Text 원문**·초기값·필수여부·연결 이벤트·To-Be 컴포넌트), 4 그리드 명세(시트별 컬럼 표: 컬럼·헤더·타입·출처 META/HARDCODED·division별 표시·편집 가능 여부), 5 액션 명세 표(버튼/이벤트 → 핸들러 → 처리 → 엔드포인트 → 결과 반영), 6 검증·메시지, 7 권한(C/R/U/D) 사실, 8 To-Be 전환 메모(Wijmo·Oracle 관점에서 바뀌는 점), 9 미확정.
- 세 문서는 서로 참조한다: 업무분석서 §5 데이터 흐름의 엔드포인트 ↔ 화면설계서 §5 액션 명세 ↔ 단위테스트 근거 열이 같은 이름을 쓴다. 화면설계서 §3 컨트롤명은 단위테스트 절차 열에서 그대로 쓴다.
- unit_test.md (단위테스트): 테스트 케이스 표 — 열: TC-ID(TC-{id}-001 형식), 구분(초기화/조회/저장/이벤트/그리드/권한/division), 사전조건, 절차, 입력값, 기대결과, 근거(엔드포인트·SP·핸들러·시트 이름 원문). 이벤트 핸들러마다 1건 이상, 엔드포인트마다 1건 이상, 시트별 컬럼 표시 1건 이상, division 변형이 있으면 division별 1건 이상, 빈 결과·오류 응답 케이스 포함.

# 1차 분석서 — analysis.md
{D("analysis.md")}

# 1차 분석서 — web_components.md
{D("web_components.md")}

# 1차 분석서 — tobe_design.md
{D("tobe_design.md")}

# Fact Pack — {id}
{Cap(bundle, 120_000)}";
    }

    static List<string> Gate2(Dictionary<string, string> files, Facts f)
    {
        var missing = new List<string>();
        string Get(string n) => files.TryGetValue(n, out var v) ? v : "";
        var b = Get("business_analysis.md"); var s = Get("screen_design.md"); var t = Get("unit_test.md");
        foreach (var e in f.Endpoints) if (!b.Contains(e, StringComparison.OrdinalIgnoreCase)) missing.Add($"business_analysis.md 엔드포인트 `{e}`");
        foreach (var e in f.SpNames) if (!b.Contains(e, StringComparison.OrdinalIgnoreCase)) missing.Add($"business_analysis.md SP `{e}`");
        foreach (var e in f.Controls) if (!s.Contains(e, StringComparison.OrdinalIgnoreCase)) missing.Add($"screen_design.md 컨트롤 `{e}`");
        foreach (var e in f.Sheets) if (!s.Contains(e, StringComparison.OrdinalIgnoreCase)) missing.Add($"screen_design.md 시트 `{e}`");
        foreach (var e in f.Events) if (!s.Contains(e, StringComparison.OrdinalIgnoreCase)) missing.Add($"screen_design.md 이벤트 핸들러 `{e}`");
        foreach (var e in f.Endpoints) if (!s.Contains(e, StringComparison.OrdinalIgnoreCase)) missing.Add($"screen_design.md 엔드포인트 `{e}`");
        foreach (var e in f.Events) if (!t.Contains(e, StringComparison.OrdinalIgnoreCase)) missing.Add($"unit_test.md 이벤트 핸들러 `{e}` 테스트");
        foreach (var e in f.Endpoints) if (!t.Contains(e, StringComparison.OrdinalIgnoreCase)) missing.Add($"unit_test.md 엔드포인트 `{e}` 테스트");
        foreach (var e in f.Sheets) if (!t.Contains(e, StringComparison.OrdinalIgnoreCase)) missing.Add($"unit_test.md 시트 `{e}` 테스트");
        foreach (var d in Docs2) if (!files.ContainsKey(d)) missing.Add($"문서 {d} 없음");
        return missing;
    }
}
