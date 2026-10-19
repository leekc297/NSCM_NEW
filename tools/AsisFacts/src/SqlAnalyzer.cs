using Microsoft.SqlServer.TransactSql.ScriptDom;

namespace AsisFacts;

/// <summary>
/// T-SQL 분석. 주석/문자열 판정은 ScriptDom 토크나이저에 전적으로 위임한다 (정규식 사용 금지).
/// 파싱 실패 시에도 토큰 스트림 기반 fallback 으로 참조를 수집하고 parse_error 를 남긴다.
/// </summary>
public sealed class SqlRef
{
    public string Kind;     // TABLE | EXEC | FUNC | TEMP | DYNAMIC
    public string Name;     // 정규화 이름 (schema 제거 대문자, 원문은 Raw)
    public string Raw;
    public string Access;   // SELECT/INSERT/UPDATE/DELETE/MERGE/EXEC/REF
    public int Line;
}

public sealed class SqlResult
{
    public List<SqlRef> Refs = new();
    public string ParseError = "";
    public int CommentTokens;
    public int CodeTokens;
    public string Mode = "ast"; // ast | tokens
}

public static class SqlAnalyzer
{
    public static string NormName(string raw)
    {
        if (string.IsNullOrWhiteSpace(raw)) return "";
        var parts = raw.Split('.').Select(p => p.Trim().Trim('[', ']', '"')).Where(p => p.Length > 0).ToList();
        var last = parts.Count > 0 ? parts[^1] : raw;
        return last.ToUpperInvariant();
    }

    public static SqlResult Analyze(string sql)
    {
        var res = new SqlResult();
        if (string.IsNullOrWhiteSpace(sql)) return res;
        var parser = new TSql160Parser(true);
        IList<ParseError> errors;
        TSqlFragment frag;
        using (var sr = new StringReader(sql)) frag = parser.Parse(sr, out errors);

        foreach (var t in frag?.ScriptTokenStream ?? (IList<TSqlParserToken>)Array.Empty<TSqlParserToken>())
        {
            if (t.TokenType == TSqlTokenType.SingleLineComment || t.TokenType == TSqlTokenType.MultilineComment) res.CommentTokens++;
            else if (t.TokenType != TSqlTokenType.WhiteSpace && t.TokenType != TSqlTokenType.EndOfFile) res.CodeTokens++;
        }

        if (errors.Count == 0 && frag != null)
        {
            var v = new RefVisitor(res);
            frag.Accept(v);
        }
        else
        {
            res.ParseError = string.Join(" | ", errors.Take(3).Select(e => $"L{e.Line}:{e.Message}"));
            res.Mode = "tokens";
            TokenFallback(sql, res);
        }
        // 중복 제거
        res.Refs = res.Refs.GroupBy(r => (r.Kind, r.Name, r.Access)).Select(g => g.OrderBy(x => x.Line).First()).ToList();
        return res;
    }

    public sealed class Branch { public string Variable, Value; public int Line; public List<SqlRef> Refs = new(); }

    /// <summary>
    /// IF @var = '값' / @var IN ('a','b') 분기별 참조 객체 (코드값 디스패치형 SP: 예 UP_FX_GetCommonDataList @Code).
    /// 주석은 ScriptDom 이 이미 제외한다.
    /// </summary>
    public static List<Branch> Branches(string sql, out string error)
    {
        error = "";
        var list = new List<Branch>();
        if (string.IsNullOrWhiteSpace(sql)) return list;
        IList<ParseError> errors;
        TSqlFragment frag;
        using (var sr = new StringReader(sql)) frag = new TSql160Parser(true).Parse(sr, out errors);
        if (errors.Count > 0 || frag == null) { error = string.Join(" | ", errors.Take(3).Select(e => $"L{e.Line}:{e.Message}")); return list; }
        frag.Accept(new BranchVisitor(list));
        return list;
    }

    sealed class BranchVisitor : TSqlFragmentVisitor
    {
        readonly List<Branch> _out;
        public BranchVisitor(List<Branch> o) { _out = o; }
        public override void Visit(IfStatement node)
        {
            foreach (var (v, val) in Conds(node.Predicate))
            {
                var b = new Branch { Variable = v, Value = val, Line = node.StartLine };
                var r = new SqlResult();
                node.ThenStatement?.Accept(new RefVisitor(r));
                b.Refs = r.Refs.GroupBy(x => (x.Kind, x.Name, x.Access)).Select(g => g.First()).ToList();
                _out.Add(b);
            }
        }
        static IEnumerable<(string, string)> Conds(BooleanExpression e)
        {
            switch (e)
            {
                case BooleanParenthesisExpression p: foreach (var x in Conds(p.Expression)) yield return x; break;
                case BooleanBinaryExpression bb when bb.BinaryExpressionType == BooleanBinaryExpressionType.Or:
                    foreach (var x in Conds(bb.FirstExpression)) yield return x;
                    foreach (var x in Conds(bb.SecondExpression)) yield return x; break;
                case BooleanComparisonExpression c when c.ComparisonType == BooleanComparisonType.Equals:
                    if (c.FirstExpression is VariableReference v1 && c.SecondExpression is StringLiteral s1) yield return (v1.Name, s1.Value);
                    else if (c.SecondExpression is VariableReference v2 && c.FirstExpression is StringLiteral s2) yield return (v2.Name, s2.Value);
                    break;
                case InPredicate ip when !ip.NotDefined && ip.Expression is VariableReference iv:
                    foreach (var val in ip.Values.OfType<StringLiteral>()) yield return (iv.Name, val.Value);
                    break;
            }
        }
    }

    static void TokenFallback(string sql, SqlResult res)
    {
        IList<ParseError> errs;
        var toks = new TSql160Parser(true).GetTokenStream(new StringReader(sql), out errs);
        var code = toks.Where(t => t.TokenType != TSqlTokenType.WhiteSpace && t.TokenType != TSqlTokenType.SingleLineComment
                                   && t.TokenType != TSqlTokenType.MultilineComment && t.TokenType != TSqlTokenType.EndOfFile).ToList();
        for (int i = 0; i < code.Count; i++)
        {
            var kw = code[i].Text.ToUpperInvariant();
            string access = kw switch { "FROM" => "SELECT", "JOIN" => "SELECT", "INTO" => "INSERT", "UPDATE" => "UPDATE", "MERGE" => "MERGE", "EXEC" => "EXEC", "EXECUTE" => "EXEC", _ => null };
            if (access == null || i + 1 >= code.Count) continue;
            // 다음 식별자(점 연결 포함) 수집
            var sb = new System.Text.StringBuilder();
            int j = i + 1;
            while (j < code.Count && (code[j].TokenType == TSqlTokenType.Identifier || code[j].TokenType == TSqlTokenType.QuotedIdentifier || code[j].TokenType == TSqlTokenType.Dot || code[j].TokenType == TSqlTokenType.Variable && sb.Length == 0))
            { sb.Append(code[j].Text); j++; }
            var raw = sb.ToString();
            if (raw.Length == 0 || raw.StartsWith("@")) continue;
            var kind = access == "EXEC" ? "EXEC" : raw.StartsWith("#") ? "TEMP" : "TABLE";
            res.Refs.Add(new SqlRef { Kind = kind, Raw = raw, Name = NormName(raw), Access = access, Line = code[i].Line });
        }
    }

    /// <summary>기본 순회(누락 방지)를 유지하고, DML 대상 노드만 사전에 표시해서 접근 유형을 구분한다.</summary>
    sealed class RefVisitor : TSqlFragmentVisitor
    {
        readonly SqlResult _r;
        readonly Dictionary<TSqlFragment, string> _targets = new(ReferenceEqualityComparer.Instance);
        readonly HashSet<string> _cteNames = new(StringComparer.OrdinalIgnoreCase);
        public RefVisitor(SqlResult r) { _r = r; }

        void Mark(TableReference t, string acc) { if (t != null) _targets[t] = acc; }
        public override void Visit(CommonTableExpression node) { _cteNames.Add(node.ExpressionName.Value); }
        public override void Visit(InsertSpecification node) => Mark(node.Target, "INSERT");
        public override void Visit(UpdateSpecification node) => Mark(node.Target, "UPDATE");
        public override void Visit(DeleteSpecification node) => Mark(node.Target, "DELETE");
        public override void Visit(MergeSpecification node) => Mark(node.Target, "MERGE");
        public override void Visit(SelectStatement node)
        {
            if (node.Into != null)
            {
                var raw = string.Join(".", node.Into.Identifiers.Select(i => i.Value));
                _r.Refs.Add(new SqlRef { Kind = raw.StartsWith("#") ? "TEMP" : "TABLE", Raw = raw, Name = NormName(raw), Access = "INSERT", Line = node.StartLine });
            }
        }
        public override void Visit(CreateTableStatement node)
        {
            var raw = string.Join(".", node.SchemaObjectName.Identifiers.Select(i => i.Value));
            _r.Refs.Add(new SqlRef { Kind = raw.StartsWith("#") ? "TEMP" : "TABLE", Raw = raw, Name = NormName(raw), Access = "CREATE", Line = node.StartLine });
        }
        public override void Visit(TruncateTableStatement node)
        {
            var raw = string.Join(".", node.TableName.Identifiers.Select(i => i.Value));
            _r.Refs.Add(new SqlRef { Kind = raw.StartsWith("#") ? "TEMP" : "TABLE", Raw = raw, Name = NormName(raw), Access = "DELETE", Line = node.StartLine });
        }

        public override void Visit(NamedTableReference node)
        {
            var raw = string.Join(".", node.SchemaObject.Identifiers.Select(i => i.Value));
            if (node.SchemaObject.Identifiers.Count == 1 && _cteNames.Contains(raw)) return;
            var acc = _targets.TryGetValue(node, out var a) ? a : "SELECT";
            var kind = raw.StartsWith("#") ? "TEMP" : raw.StartsWith("@") ? "TABLEVAR" : "TABLE";
            _r.Refs.Add(new SqlRef { Kind = kind, Raw = raw, Name = NormName(raw), Access = acc, Line = node.StartLine });
        }

        public override void Visit(ExecutableProcedureReference node)
        {
            var nm = node.ProcedureReference?.ProcedureReference?.Name;
            if (nm != null)
            {
                var raw = string.Join(".", nm.Identifiers.Select(i => i.Value));
                _r.Refs.Add(new SqlRef { Kind = "EXEC", Raw = raw, Name = NormName(raw), Access = "EXEC", Line = node.StartLine });
            }
            else if (node.ProcedureReference?.ProcedureVariable != null)
                _r.Refs.Add(new SqlRef { Kind = "DYNAMIC", Raw = node.ProcedureReference.ProcedureVariable.Name, Name = "", Access = "EXEC", Line = node.StartLine });
        }

        public override void Visit(ExecutableStringList node)
            => _r.Refs.Add(new SqlRef { Kind = "DYNAMIC", Raw = "EXEC(string)", Name = "", Access = "EXEC", Line = node.StartLine });

        public override void Visit(FunctionCall node)
        {
            if (node.CallTarget is MultiPartIdentifierCallTarget mp)
            {
                var raw = string.Join(".", mp.MultiPartIdentifier.Identifiers.Select(i => i.Value)) + "." + node.FunctionName.Value;
                _r.Refs.Add(new SqlRef { Kind = "FUNC", Raw = raw, Name = NormName(raw), Access = "REF", Line = node.StartLine });
            }
            else if (node.FunctionName.Value.Equals("sp_executesql", StringComparison.OrdinalIgnoreCase))
                _r.Refs.Add(new SqlRef { Kind = "DYNAMIC", Raw = "sp_executesql", Name = "", Access = "EXEC", Line = node.StartLine });
        }

        public override void Visit(SchemaObjectFunctionTableReference node)
        {
            var raw = string.Join(".", node.SchemaObject.Identifiers.Select(i => i.Value));
            _r.Refs.Add(new SqlRef { Kind = "FUNC", Raw = raw, Name = NormName(raw), Access = "REF", Line = node.StartLine });
        }
    }
}
