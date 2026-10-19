namespace AsisFacts;

public static class Output
{
    public static void Write(string outDir, string root, List<(SourceFile sf, FileFacts ff)> facts, List<Site> sites, List<CallRec> calls, Linker linker, CsIndex ix)
    {
        var screenOf = facts.ToDictionary(x => x.sf.RelPath, x => x.sf.ScreenId, StringComparer.Ordinal);
        string Scr(string f) => screenOf.TryGetValue(f, out var s) ? s : "";

        using (var w = new CsvOut(Path.Combine(outDir, "sites.csv"), "seq", "origin_seq", "file", "screen_id", "class", "member", "member_line", "line", "site_kind", "target", "kind", "values", "values2", "req_params", "receiver", "active", "commented", "via", "depth", "raw"))
            foreach (var s in sites)
                w.Row(s.Seq, s.OriginSeq, s.File, Scr(s.File), s.ClassSimple, s.Member, s.MemberLine, s.Line, s.SiteKind, s.Target, s.Kind, Val.Join(s.Values), Val.Join(s.Values2),
                      string.Join("; ", s.ReqParams.Select(kv => kv.Key + "=" + Val.Join(kv.Value))), s.Receiver, s.Active, s.Commented, s.Via, s.Depth, s.Raw);

        var usageStats = new Dictionary<string, int>();
        using (var w = new CsvOut(Path.Combine(outDir, "endpoint_usage.csv"), "seq", "file", "screen_id", "class", "member", "line", "site_kind", "kind", "candidate", "key", "status", "detail", "active", "commented", "via", "depth"))
            foreach (var s in sites)
                foreach (var u in linker.Resolve(s))
                {
                    w.Row(s.Seq, s.File, Scr(s.File), s.ClassSimple, s.Member, s.Line, s.SiteKind, s.Kind, u.Candidate, u.Key, u.Status, u.Detail, s.Active, s.Commented, s.Via, s.Depth);
                    var k = (s.Commented ? "commented:" : !s.Active ? "inactive:" : "") + u.Status;
                    usageStats[k] = usageStats.GetValueOrDefault(k) + 1;
                }
        File.WriteAllLines(Path.Combine(outDir, "endpoint_usage_summary.txt"), usageStats.OrderBy(k => k.Key).Select(k => $"{k.Key}\t{k.Value}"));

    }

    static string Trunc(string s, int n) => s == null ? "" : s.Length > n ? s[..n] + "…" : s;
}
