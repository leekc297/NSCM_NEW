using System.Text.RegularExpressions;

namespace AsisFacts;

public sealed class Usage
{
    public Site Site;
    public string Candidate;   // 해석된 값(표시용)
    public string Key;         // 카탈로그 키
    public string Status;      // MATCH | MATCH_BARE | MATCH_PATTERN | MATCH_COMMENTED_ONLY | BIZ_MATCH | NOT_IN_FOXQUERY | UNRESOLVED | AMBIGUOUS
    public string Detail;
}

/// <summary>요청 객체 파라미터 결합 → 파생 sink 전파(고정점) → 카탈로그 조인</summary>
public sealed class Linker
{
    readonly CsIndex _ix;
    readonly List<FoxEndpoint> _cat;
    readonly Dictionary<string, List<FoxEndpoint>> _byKey = new(StringComparer.OrdinalIgnoreCase);
    readonly Dictionary<string, List<FoxEndpoint>> _byBareId = new(StringComparer.OrdinalIgnoreCase);
    readonly Dictionary<string, List<FoxEndpoint>> _commentedByKey = new(StringComparer.OrdinalIgnoreCase);
    public const int MaxDepth = 8;
    int _lastReport;

    readonly HashSet<string> _keyParams;
    public Linker(CsIndex ix, List<FoxEndpoint> cat, IEnumerable<string> keyParams = null)
    {
        _ix = ix; _cat = cat;
        _keyParams = new HashSet<string>(keyParams ?? Array.Empty<string>(), StringComparer.OrdinalIgnoreCase);
        foreach (var e in cat)
        {
            var d = e.Commented ? _commentedByKey : _byKey;
            if (!d.TryGetValue(e.Key, out var l)) d[e.Key] = l = new();
            l.Add(e);
            if (!e.Commented && e.Dialect == "foxml" && e.ParentId == null)
            {
                if (!_byBareId.TryGetValue(e.Id, out var b)) _byBareId[e.Id] = b = new();
                b.Add(e);
            }
        }
    }

    /// <summary>같은 멤버 안에서 요청 객체 변수명이 같은 reqparam 을 직전 생성 사이트에 결합</summary>
    public static void AttachReqParams(List<Site> sites)
    {
        foreach (var g in sites.GroupBy(s => (s.File, s.MemberLine, s.Member, s.Commented, s.Active)))
        {
            var reqs = g.Where(s => s.SiteKind == "ctor" || s.SiteKind == "derived").OrderBy(s => s.Line).ToList();
            foreach (var p in g.Where(s => s.SiteKind == "reqparam").OrderBy(s => s.Line))
            {
                var owner = reqs.Where(r => r.Line <= p.Line && Same(r.Receiver, p.Receiver)).LastOrDefault()
                         ?? reqs.Where(r => Same(r.Receiver, p.Receiver)).FirstOrDefault();
                if (owner == null) continue;
                if (!owner.ReqParams.TryGetValue(p.Target, out var l)) owner.ReqParams[p.Target] = l = new();
                l.AddRange(p.Values.Where(v => !l.Contains(v)));
                owner.ReqParamSeqs.Add(p.Seq);
            }
        }
    }

    static bool Same(string a, string b) => Norm(a) == Norm(b) && Norm(a).Length > 0;
    static string Norm(string s) => (s ?? "").Replace("this.", "").Replace(" ", "");

    /// <summary>
    /// 파라미터 자리표시자를 가진 sink 를 '파생 sink' 로 만들어 호출자 쪽으로 전파한다.
    /// biz 요청은 [FoxBizMethod] 메서드로 이어서, 그 안의 sink 를 요청 파라미터 이름으로 치환한다.
    /// </summary>
    public List<Site> Propagate(List<Site> baseSites, List<CallRec> calls, List<string> log)
    {
        var all = new List<Site>(baseSites);
        var callsByCallee = calls.GroupBy(c => c.Callee).ToDictionary(g => g.Key, g => g.ToList(), StringComparer.Ordinal);
        var methodsAt = new Dictionary<(string, int), MethodInfo>();
        foreach (var l in _ix.MethodsByName.Values) foreach (var m in l) methodsAt[(m.File, m.Line)] = m;
        var sitesByMethod = baseSites.Where(s => s.Active && !s.Commented).GroupBy(s => (s.File, s.MemberLine)).ToDictionary(g => g.Key, g => g.ToList());
        var seen = new HashSet<string>(StringComparer.Ordinal);

        var work = new Queue<Site>(baseSites.Where(s => s.Active && !s.Commented && s.SiteKind != "reqparam"));
        int created = 0;
        while (work.Count > 0)
        {
            var s = work.Dequeue();
            if (created > 0 && created % 5000 == 0 && created != _lastReport)
            {
                _lastReport = created;
                var top = all.Skip(baseSites.Count).GroupBy(x => x.Via.Split(" > ")[0]).OrderByDescending(g => g.Count()).Take(5).Select(g => g.Key + "=" + g.Count());
                Console.WriteLine($"  propagate: created {created}, queue {work.Count}, mem {GC.GetTotalMemory(false) / 1048576}MB, top: {string.Join(", ", top)}");
            }
            if (created > 2_000_000) { log.Add("propagation cap reached"); break; }
            if (s.Depth >= MaxDepth) continue;

            // (1) biz 요청 → BIZ 메서드 내부 sink (요청 파라미터 이름으로 치환)
            if (s.Kind == "biz")
            {
                foreach (var cls in s.Values.Where(Val.IsLiteral).Distinct())
                    foreach (var meth in s.Values2.Where(Val.IsLiteral).Distinct())
                    {
                        if (!_ix.BizMethods.TryGetValue(cls + "." + meth, out var targets)) continue;
                        foreach (var t in targets)
                        {
                            if (!sitesByMethod.TryGetValue((t.File, t.Line), out var inner)) continue;
                            foreach (var tpl in inner.Where(x => x.SiteKind != "reqparam"))
                            {
                                var d = Derive(tpl, s, (idx, name) => s.ReqParams.TryGetValue(name, out var v) ? v : null, $"biz:{cls}.{meth}");
                                if (d != null && seen.Add(Sig(d))) { all.Add(d); work.Enqueue(d); created++; }
                            }
                        }
                    }
            }

            // (2) 파라미터 의존 sink → 호출자 쪽으로 전파
            // 키 결정 값(엔드포인트 ID·BIZ 메서드·키 파라미터)이 파라미터에 의존할 때만 호출자 쪽으로 전파
            bool hasParam = s.Values.Any(Val.HasParam) || s.Values2.Any(Val.HasParam) || s.GuardIdx >= 0
                         || s.ReqParams.Where(kv => _keyParams.Contains(kv.Key)).Any(kv => kv.Value.Any(Val.HasParam));
            if (!hasParam) continue;
            if (!methodsAt.TryGetValue((s.File, s.MemberLine), out var mi)) continue;
            if (!callsByCallee.TryGetValue(mi.Name == ".ctor" ? mi.ClassSimple : mi.Name, out var callers)) continue;
            foreach (var c in callers)
            {
                if (mi.Name == ".ctor" ? !c.IsCtor : c.IsCtor) continue;
                if (c.Args.Count < mi.RequiredParams || c.Args.Count > mi.ParamNames.Count) continue;
                if (!ReceiverCompatible(c, mi)) continue;
                var caller = new Site { File = c.File, ClassSimple = c.ClassSimple, ClassFull = c.ClassSimple, Member = c.Member, MemberLine = c.MemberLine, Line = c.Line };
                // switch 가드: 호출자 인자가 case 라벨과 맞지 않으면 그 분기는 타지 않음
                int newGuardIdx = -1; string newGuardName = null; string guardHit = null;
                if (s.GuardIdx >= 0)
                {
                    var gi = c.ArgNames.IndexOf(s.GuardName);
                    var av = gi >= 0 ? c.Args[gi] : s.GuardIdx < c.Args.Count ? c.Args[s.GuardIdx] : null;
                    if (av == null) guardHit = "?";
                    else
                    {
                        var pp = av.SelectMany(Val.Params).FirstOrDefault();
                        if (av.Count == 1 && Val.HasParam(av[0]) && pp.name != null) { newGuardIdx = pp.idx; newGuardName = pp.name; }
                        else
                        {
                            var shown = av.Select(x => Val.Show(x).Trim('{', '}', '?')).ToList();
                            guardHit = s.GuardLabels.FirstOrDefault(lb => shown.Any(a => LabelMatch(lb, a)));
                            if (guardHit == null && av.All(Val.IsLiteral)) continue;              // 리터럴인데 불일치 → 분기 안 탐
                            if (guardHit == null && shown.All(a => a.Contains('.'))) continue;     // enum 멤버인데 불일치
                            guardHit ??= "?";
                        }
                    }
                }
                var d = Derive(s, caller, (idx, name) =>
                {
                    // 이름 지정 인자 우선
                    var ni = c.ArgNames.IndexOf(name);
                    if (ni >= 0) return c.Args[ni] ?? new List<string> { Val.Unknown("arg:" + name) };
                    if (idx < c.Args.Count && c.ArgNames[idx] == "") return c.Args[idx] ?? new List<string> { Val.Unknown("arg:" + name) };
                    return new List<string> { Val.Unknown("default:" + name) };
                }, $"{mi.ClassSimple}.{mi.Name}" + (s.GuardIdx >= 0 ? $"[case {(guardHit ?? "param")}:{string.Join("/", s.GuardLabels)}]" : ""));
                if (d == null) continue;
                d.GuardIdx = newGuardIdx; d.GuardName = newGuardName; d.GuardLabels = newGuardIdx >= 0 ? s.GuardLabels : null;
                // 호출 지점 자체가 switch(param) case 안이면 그 가드를 이어받는다 (예: Data.Common(Type) → CallBizCommonData("코드"))
                if (d.GuardIdx < 0 && c.GuardIdx >= 0) { d.GuardIdx = c.GuardIdx; d.GuardName = c.GuardName; d.GuardLabels = c.GuardLabels; }
                if (seen.Add(Sig(d))) { all.Add(d); work.Enqueue(d); created++; }
            }
        }
        log.Add($"derived sites: {created}");
        return all;
    }

    bool ReceiverCompatible(CallRec c, MethodInfo mi)
    {
        if (c.IsCtor) return true;
        var r = c.Receiver ?? "";
        if (r == "" || r == "this" || r == "base")
        {
            var chain = _ix.SelfAndBases(c.ClassSimple).ToHashSet();
            if (chain.Contains(mi.ClassSimple)) return true;
            // 수신자 없는 호출은 자기/조상 클래스 메서드만 해당 (다른 클래스 정적 메서드는 using static 외엔 불가)
            return false;
        }
        // 정적 호출: 수신자가 타입명
        var last = r.Split('.').Last();
        if (_ix.ClassSimpleNames.Contains(last)) return _ix.SelfAndBases(last).Contains(mi.ClassSimple);
        return true; // 인스턴스 변수 수신 → 타입 미상, 후보로 유지
    }

    /// <summary>파라미터 자리표시자와 리터럴로만 구성 (미해결 부분 없음)</summary>
    static bool TemplateOnly(string v) => Val.HasParam(v) && !Val.HasUnknown(v);
    static bool NoUnknown(string v) => !Val.HasUnknown(v);

    static bool LabelMatch(string label, string arg)
    {
        var l = label.Trim().Trim('"'); var a = arg.Trim().Trim('"');
        if (l.Equals(a, StringComparison.Ordinal)) return true;
        var ls = l.Split('.').Last(); var as_ = a.Split('.').Last();
        return ls.Length > 0 && ls == as_ && (l.Contains('.') || a.Contains('.'));
    }

    // 경로(Via)·비키 파라미터는 서명에서 제외: 같은 지점·같은 키 값이면 한 번만 (재귀/오버로드/조합 폭발 방지)
    string Sig(Site d) => $"{d.File}|{d.Line}|{d.Kind}|{d.Target}|{string.Join("§", d.Values)}|{string.Join("§", d.Values2)}|{string.Join("§", d.ReqParams.Where(k => _keyParams.Contains(k.Key)).OrderBy(k => k.Key).Select(k => k.Key + "=" + string.Join("¤", k.Value)))}|{d.GuardIdx}";

    static Site Derive(Site tpl, Site at, Func<int, string, List<string>> args, string via)
    {
        var d = tpl.Clone();
        d.Seq = CsExtractor.Next();
        d.SiteKind = "derived";
        d.File = at.File; d.ClassSimple = at.ClassSimple; d.ClassFull = at.ClassFull; d.Member = at.Member; d.MemberLine = at.MemberLine; d.Line = at.Line;
        d.Values = tpl.Values.SelectMany(v => Val.Substitute(v, args)).Distinct().Take(Val.MaxCandidates).ToList();
        d.Values2 = tpl.Values2.SelectMany(v => Val.Substitute(v, args)).Distinct().Take(Val.MaxCandidates).ToList();
        foreach (var k in d.ReqParams.Keys.ToList())
            d.ReqParams[k] = d.ReqParams[k].SelectMany(v => Val.Substitute(v, args)).Distinct().Take(Val.MaxCandidates).ToList();
        d.Via = via + (string.IsNullOrEmpty(tpl.Via) ? "" : " > " + tpl.Via);
        d.Depth = Math.Max(tpl.Depth, at.Depth) + 1;
        d.OriginSeq = at.Seq != 0 ? at.OriginSeq : d.Seq;
        d.Raw = tpl.Raw;
        return d;
    }

    // ───────────── 카탈로그 조인 ─────────────
    public IEnumerable<Usage> Resolve(Site s)
    {
        if (s.SiteKind == "reqparam") yield break;
        if (s.Kind == "biz")
        {
            foreach (var cls in s.Values) foreach (var m in s.Values2.DefaultIfEmpty(""))
                {
                    var kp = s.ReqParams.Where(kv => _keyParams.Contains(kv.Key) && !kv.Key.Equals("pagePath", StringComparison.OrdinalIgnoreCase)).Select(kv => kv.Key + "=" + Val.Join(kv.Value)).ToList();
                    var cand = Val.Show(cls) + "." + Val.Show(m) + (kp.Count > 0 ? " [" + string.Join("; ", kp) + "]" : "");
                    if (Val.IsLiteral(cls) && Val.IsLiteral(m))
                        yield return new Usage { Site = s, Candidate = cand, Key = "biz:" + cls + "." + m, Status = _ix.BizMethods.ContainsKey(cls + "." + m) ? "BIZ_MATCH" : "BIZ_NOT_FOUND" };
                    else yield return new Usage { Site = s, Candidate = cand, Key = "", Status = (Val.HasParam(cls) || Val.HasParam(m)) && NoUnknown(cls) && NoUnknown(m) ? "TEMPLATE" : "UNRESOLVED" };
                }
            // pagePath + batchId/procedure → sqls 엔드포인트
            if (s.ReqParams.TryGetValue("pagePath", out var pages))
            {
                var ids = new List<string>();
                foreach (var k in new[] { "batchId", "procedure", "sqlId", "queryId" })
                    if (s.ReqParams.TryGetValue(k, out var l)) ids.AddRange(l);
                foreach (var p in pages) foreach (var id in ids.DefaultIfEmpty(""))
                        foreach (var u in ResolveSqls(s, p, id)) yield return u;
            }
            yield break;
        }
        if (s.Kind == "sqls")
        {
            foreach (var p in s.Values) foreach (var id in s.Values2.DefaultIfEmpty(""))
                    foreach (var u in ResolveSqls(s, p, id)) yield return u;
            yield break;
        }
        foreach (var v in s.Values) yield return ResolveFox(s, v);
    }

    IEnumerable<Usage> ResolveSqls(Site s, string page, string id)
    {
        var cand = Val.Show(page) + "#" + Val.Show(id);
        if (!Val.IsLiteral(page) && Val.Show(page).StartsWith("{?new FoxDataRequest("))
        { yield return new Usage { Site = s, Candidate = cand, Key = "", Status = "WRAPS_FOX_REQUEST", Detail = "요청 객체 전달 — 원 FoxDataRequest 생성 지점에서 해석됨" }; yield break; }
        if ((Val.HasParam(page) || Val.HasParam(id)) && NoUnknown(page) && NoUnknown(id))
        { yield return new Usage { Site = s, Candidate = cand, Key = "", Status = "TEMPLATE", Detail = "파라미터 의존 — 호출 지점(derived)에서 해석됨" }; yield break; }
        var pageN = page.Replace('/', '\\').Trim('\\');
        var key = pageN + "#" + id;
        if (Val.IsLiteral(key))
        {
            if (_byKey.ContainsKey(key)) { yield return new Usage { Site = s, Candidate = cand, Key = key, Status = "MATCH" }; yield break; }
            if (_commentedByKey.ContainsKey(key)) { yield return new Usage { Site = s, Candidate = cand, Key = key, Status = "MATCH_COMMENTED_ONLY" }; yield break; }
            yield return new Usage { Site = s, Candidate = cand, Key = key, Status = "NOT_IN_FOXQUERY" };
            yield break;
        }
        foreach (var u in PatternMatch(s, key, cand, "sqls")) yield return u;
    }

    Usage ResolveFox(Site s, string v)
    {
        var cand = Val.Show(v);
        if (v.Trim().Length == 0) return new Usage { Site = s, Candidate = "", Key = "", Status = "EMPTY" };
        if (Val.IsLiteral(v))
        {
            if (_byKey.TryGetValue(v, out _)) return new Usage { Site = s, Candidate = cand, Key = v, Status = "MATCH" };
            var bare = v.Contains('.') ? v[(v.LastIndexOf('.') + 1)..] : v;
            if (!v.Contains('.') && _byBareId.TryGetValue(bare, out var b))
                return b.Count == 1 ? new Usage { Site = s, Candidate = cand, Key = b[0].Key, Status = "MATCH_BARE" }
                                    : new Usage { Site = s, Candidate = cand, Key = string.Join("|", b.Select(x => x.Key)), Status = "AMBIGUOUS" };
            if (_commentedByKey.ContainsKey(v)) return new Usage { Site = s, Candidate = cand, Key = v, Status = "MATCH_COMMENTED_ONLY" };
            return new Usage { Site = s, Candidate = cand, Key = v, Status = "NOT_IN_FOXQUERY", Detail = "SP 직접호출 또는 미등록 — DB 단계에서 확인" };
        }
        if (TemplateOnly(v)) return new Usage { Site = s, Candidate = cand, Key = "", Status = "TEMPLATE", Detail = "파라미터 의존 — 호출 지점(derived)에서 해석됨" };
        var pm = PatternMatch(s, v, cand, "foxml").ToList();
        return pm.Count == 1 ? pm[0] : new Usage { Site = s, Candidate = cand, Key = string.Join("|", pm.Select(p => p.Key).Where(k => k.Length > 0).Take(20)), Status = pm.Count == 0 ? "UNRESOLVED" : pm[0].Status, Detail = pm.Count > 1 ? $"pattern matches={pm.Count}" : "" };
    }

    IEnumerable<Usage> PatternMatch(Site s, string v, string cand, string dialect)
    {
        // 자리표시자 외 리터럴이 4자 미만이면 의미 없는 패턴 → 미해결
        var litLen = Regex.Replace(v, "\u0001[^\u0001]*\u0001", "").Length;
        if (litLen < 4) { yield return new Usage { Site = s, Candidate = cand, Key = "", Status = "UNRESOLVED" }; yield break; }
        var rx = Val.ToPattern(v);
        var hits = _byKey.Keys.Where(k => rx.IsMatch(k)).ToList();
        if (hits.Count == 0) { yield return new Usage { Site = s, Candidate = cand, Key = "", Status = "UNRESOLVED", Detail = "pattern no match" }; yield break; }
        yield return new Usage { Site = s, Candidate = cand, Key = string.Join("|", hits.Take(50)), Status = "MATCH_PATTERN", Detail = $"matches={hits.Count}" };
    }

    /// <summary>리터럴이 카탈로그 키/ID/SP 명과 일치하는가 (안전망용)</summary>
    public string LiteralMatch(string v)
    {
        if (_byKey.ContainsKey(v)) return "key";
        if (_byBareId.ContainsKey(v)) return "bare_id";
        if (SpSet.Contains(SqlAnalyzer.NormName(v))) return "sp_name";
        if (PageSet.Contains(v.Replace('/', '\\').Trim('\\'))) return "page";
        if (_commentedByKey.ContainsKey(v)) return "commented_key";
        return "";
    }
    HashSet<string> _spSet, _pageSet;
    HashSet<string> SpSet => _spSet ??= new HashSet<string>(_cat.Where(c => !c.Commented && !string.IsNullOrEmpty(c.SpName)).Select(c => SqlAnalyzer.NormName(c.SpName)), StringComparer.OrdinalIgnoreCase);
    HashSet<string> PageSet => _pageSet ??= new HashSet<string>(_cat.Where(c => c.Dialect == "sqls").Select(c => c.Scope), StringComparer.OrdinalIgnoreCase);
}
