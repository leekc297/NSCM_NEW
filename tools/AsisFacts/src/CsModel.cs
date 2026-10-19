namespace AsisFacts;

public sealed class Site
{
    public long Seq;
    public string File, ClassFull, ClassSimple, Member;
    public int MemberLine, Line;
    public string SiteKind;      // ctor | invoke | prop | reqparam | derived
    public string Target;        // 타입명/메서드명/속성명/파라미터명
    public string Kind;          // fox | biz | param
    public List<string> Values = new();
    public List<string> Values2 = new();   // biz: method 이름
    public string Raw;
    public string Receiver;      // 요청 객체 변수명
    public bool Active = true;   // #if 비활성 = false
    public bool Commented;
    public string Via = "";      // 파생 경로
    public long OriginSeq;       // 최초 UI 호출 지점
    public int Depth;
    // switch(param) case 가드: 호출자 인자와 일치할 때만 전파
    public int GuardIdx = -1;
    public string GuardName;
    public List<string> GuardLabels;
    public Dictionary<string, List<string>> ReqParams = new(StringComparer.OrdinalIgnoreCase);
    public List<long> ReqParamSeqs = new();

    public Site Clone()
    {
        var c = (Site)MemberwiseClone();
        c.Values = new(Values); c.Values2 = new(Values2);
        c.ReqParams = ReqParams.ToDictionary(k => k.Key, v => new List<string>(v.Value), StringComparer.OrdinalIgnoreCase);
        c.ReqParamSeqs = new(ReqParamSeqs);
        c.GuardLabels = GuardLabels == null ? null : new(GuardLabels);
        return c;
    }
}

public sealed class CallRec
{
    public long Seq;
    public string File, ClassSimple, Member;
    public string ArgsText; // 출력용 (메모리에는 해석 필요 인자만 유지)
    public int MemberLine, Line;
    public string Callee, Receiver;
    public List<List<string>> Args = new();
    public List<string> ArgNames = new();
    public bool IsCtor;
    public int GuardIdx = -1;
    public string GuardName;
    public List<string> GuardLabels;
}

public sealed class MemberRec
{
    public string File, ClassFull, ClassSimple, Member, Kind, Modifiers, Params, BaseList;
    public int Line, EndLine;
}

public sealed class EventRec { public string File, ClassSimple, Member, Target, EventName, Handler, Op; public int Line; }
public sealed class ControlRec { public string File, ClassSimple, Name, Type, Parent; public int Line; }
public sealed class PropRec { public string File, ClassSimple, Member, Target, Prop, Value; public int Line; }
public sealed class MetaRead { public string File, ClassSimple, Member, Receiver, Column, Via; public int Line; }
public sealed class LiteralRec { public string File, ClassSimple, Member, Value; public int Line; }
public sealed class TriviaRec { public string File, Kind; public int Line, EndLine, Sites; }

public sealed class GridCall
{
    public string File, ClassSimple, Member, Api, Receiver, Args, ArgNames, Source, Conditions, Raw, Columns;
    public int Line;
}
