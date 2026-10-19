using System.Text;

namespace AsisFacts;

/// <summary>RFC4180 CSV 스트리밍 리더 (인용 필드 내 개행/따옴표 처리)</summary>
public static class CsvIn
{
    public static IEnumerable<Dictionary<string, string>> Read(string path)
    {
        using var r = new StreamReader(path, Encoding.UTF8, true, 1 << 16);
        string[] header = null;
        foreach (var rec in Records(r))
        {
            if (header == null) { header = rec.ToArray(); continue; }
            var d = new Dictionary<string, string>(header.Length, StringComparer.Ordinal);
            for (int i = 0; i < header.Length; i++) d[header[i]] = i < rec.Count ? rec[i] : "";
            yield return d;
        }
    }

    static IEnumerable<List<string>> Records(StreamReader r)
    {
        var fields = new List<string>();
        var sb = new StringBuilder();
        bool inQ = false, any = false;
        int c;
        while ((c = r.Read()) >= 0)
        {
            char ch = (char)c;
            any = true;
            if (inQ)
            {
                if (ch == '"')
                {
                    if (r.Peek() == '"') { sb.Append('"'); r.Read(); }
                    else inQ = false;
                }
                else sb.Append(ch);
                continue;
            }
            switch (ch)
            {
                case '"': inQ = true; break;
                case ',': fields.Add(sb.ToString()); sb.Clear(); break;
                case '\r': break;
                case '\n':
                    fields.Add(sb.ToString()); sb.Clear();
                    yield return fields; fields = new List<string>(); any = false; break;
                default: sb.Append(ch); break;
            }
        }
        if (any) { fields.Add(sb.ToString()); yield return fields; }
    }
}
