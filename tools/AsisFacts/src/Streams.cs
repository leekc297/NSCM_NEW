namespace AsisFacts;

/// <summary>파일 단위 사실을 즉시 CSV 로 내보내 메모리를 비운다 (스레드 안전).</summary>
public sealed class Streams : IDisposable
{
    readonly object _lk = new();
    readonly CsvOut _files, _members, _calls, _events, _controls, _props, _meta, _lits, _trivia, _grid;
    readonly Linker _linker;

    public Streams(string outDir, Linker linker)
    {
        _linker = linker;
        _files = new CsvOut(Path.Combine(outDir, "files.csv"), "file", "layer", "project", "screen_id", "encoding", "sha256", "lines", "parse_errors", "first_error", "sites", "commented_sites", "inactive_sites", "line_comment_blocks", "block_comments", "disabled_blocks");
        _members = new CsvOut(Path.Combine(outDir, "members.csv"), "file", "screen_id", "class_full", "class", "member", "kind", "modifiers", "params", "base_list", "line", "end_line");
        _calls = new CsvOut(Path.Combine(outDir, "calls.csv"), "seq", "file", "screen_id", "class", "member", "member_line", "line", "callee", "receiver", "is_ctor", "arg_count", "args");
        _events = new CsvOut(Path.Combine(outDir, "events.csv"), "file", "screen_id", "class", "member", "line", "target", "event", "handler", "op");
        _controls = new CsvOut(Path.Combine(outDir, "controls.csv"), "file", "screen_id", "class", "name", "type", "parent", "line");
        _props = new CsvOut(Path.Combine(outDir, "props.csv"), "file", "screen_id", "class", "member", "line", "target", "prop", "value");
        _meta = new CsvOut(Path.Combine(outDir, "meta_reads.csv"), "file", "screen_id", "class", "member", "line", "receiver", "column", "via");
        _lits = new CsvOut(Path.Combine(outDir, "literals.csv"), "file", "screen_id", "class", "member", "line", "value", "catalog_match");
        _trivia = new CsvOut(Path.Combine(outDir, "trivia_fragments.csv"), "file", "kind", "line", "end_line", "sites");
        _grid = new CsvOut(Path.Combine(outDir, "grid_code.csv"), "file", "screen_id", "class", "member", "line", "api", "receiver", "source", "args", "arg_names", "conditions", "columns", "raw");
    }

    static string T(string s, int n) => s == null ? "" : s.Length > n ? s[..n] + "…" : s;

    public void Write(SourceFile sf, FileFacts ff)
    {
        var scr = sf.ScreenId;
        lock (_lk)
        {
            _files.Row(sf.RelPath, sf.Layer, sf.Project, scr, sf.Encoding, sf.Sha256, sf.Lines, ff.ParseErrors, ff.FirstError,
                ff.Sites.Count(s => s.Active && !s.Commented), ff.Sites.Count(s => s.Commented), ff.Sites.Count(s => !s.Active),
                ff.Trivia.Count(t => t.Kind == "line-comment"), ff.Trivia.Count(t => t.Kind == "block-comment"), ff.Trivia.Count(t => t.Kind == "disabled-#if"));
            foreach (var m in ff.Members) _members.Row(m.File, scr, m.ClassFull, m.ClassSimple, m.Member, m.Kind, m.Modifiers, m.Params, m.BaseList, m.Line, m.EndLine);
            foreach (var c in ff.Calls) _calls.Row(c.Seq, c.File, scr, c.ClassSimple, c.Member, c.MemberLine, c.Line, c.Callee, T(c.Receiver, 120), c.IsCtor, c.Args.Count, c.ArgsText);
            foreach (var e in ff.Events) _events.Row(e.File, scr, e.ClassSimple, e.Member, e.Line, e.Target, e.EventName, e.Handler, e.Op);
            foreach (var c in ff.Controls) _controls.Row(c.File, scr, c.ClassSimple, c.Name, c.Type, ff.ControlParent.GetValueOrDefault(c.Name, ""), c.Line);
            foreach (var p in ff.Props) _props.Row(p.File, scr, p.ClassSimple, p.Member, p.Line, p.Target, p.Prop, p.Value);
            foreach (var m in ff.MetaReads) _meta.Row(m.File, scr, m.ClassSimple, m.Member, m.Line, m.Receiver, m.Column, m.Via);
            foreach (var l in ff.Literals) _lits.Row(l.File, scr, l.ClassSimple, l.Member, l.Line, l.Value, _linker.LiteralMatch(l.Value));
            foreach (var t in ff.Trivia) _trivia.Row(t.File, t.Kind, t.Line, t.EndLine, t.Sites);
            foreach (var g in ff.GridCalls) _grid.Row(g.File, scr, g.ClassSimple, g.Member, g.Line, g.Api, g.Receiver, g.Source, g.Args, g.ArgNames, g.Conditions, g.Columns, g.Raw);
        }
        // 메모리 해제: 사이트/호출만 남긴다
        ff.Members = null; ff.Events = null; ff.Controls = null; ff.Props = null; ff.MetaReads = null; ff.Literals = null; ff.Trivia = null; ff.ControlParent = null; ff.GridCalls = null;
        foreach (var c in ff.Calls) c.ArgsText = null;
    }

    public void Dispose() { _files.Dispose(); _members.Dispose(); _calls.Dispose(); _events.Dispose(); _controls.Dispose(); _props.Dispose(); _meta.Dispose(); _lits.Dispose(); _trivia.Dispose(); _grid.Dispose(); }
}
