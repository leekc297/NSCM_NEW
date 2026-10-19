import pathlib
p=pathlib.Path("parse_check.py"); s=p.read_text(encoding="utf-8")
old='''def bindify(seg, s, names):
    """rebuild statement text replacing bare declared identifiers with binds; keep original spacing"""
    out = []; last = seg[0][2]
    for t in seg:
        pos = t[2]
        raw = s[pos:pos + len(t[1])] if t[0] != "str" else t[1]
        out.append(s[last:pos])
        if t[0] == "id" and "." not in t[1] and t[1] in names:
            out.append(":B_" + t[1])
        elif t[0] == "id" and t[1].startswith("SCM_MGR.") is False and "." in t[1] and t[1].split(".")[0] in names:
            out.append(":B_" + t[1].replace(".", "_"))   # record.field → bind
        else:
            out.append(raw)
        last = pos + len(raw)
    return "".join(out)'''
new='''def _aliases(seg):
    """table aliases used in this statement: identifier directly following a table-like identifier (FROM t A / JOIN t A / UPDATE t A / INTO t A)"""
    al = set(); n = len(seg)
    for i in range(1, n):
        t, prev = seg[i], seg[i - 1]
        if t[0] == "id" and "." not in t[1] and t[1] not in KW and prev[0] == "id" and prev[1] not in KW and "(" not in prev[1]:
            nxt = seg[i + 1] if i + 1 < n else None
            if nxt is None or not is_op(nxt, "("):
                al.add(t[1])
        # ") A" after a subquery
        if t[0] == "id" and "." not in t[1] and t[1] not in KW and is_op(prev, ")"):
            al.add(t[1])
    return al


def _insert_collist_span(seg):
    """token index range (a,b) of the INSERT INTO t ( col, ... ) column list, else None"""
    if not (seg and seg[0][0] == "id" and seg[0][1] == "INSERT"):
        return None
    for i in range(1, min(len(seg), 8)):
        if is_op(seg[i], "("):
            d = 0
            for j in range(i, len(seg)):
                if is_op(seg[j], "("): d += 1
                elif is_op(seg[j], ")"):
                    d -= 1
                    if d == 0:
                        return (i, j)
            return None
        if seg[i][0] == "id" and seg[i][1] in ("SELECT", "VALUES", "WITH"):
            return None
    return None


def bindify(seg, s, names):
    """rebuild statement text replacing declared PL/SQL identifiers with binds; keep original spacing.
    Not substituted: INSERT column list, dotted refs whose head is a table alias of this statement, identifiers followed by '('."""
    out = []; last = seg[0][2]; al = _aliases(seg); col = _insert_collist_span(seg)
    for i, t in enumerate(seg):
        pos = t[2]
        raw = s[pos:pos + len(t[1])] if t[0] != "str" else t[1]
        out.append(s[last:pos])
        nxt = seg[i + 1] if i + 1 < len(seg) else None
        in_collist = col is not None and col[0] < i < col[1]
        if t[0] == "id" and not in_collist and not (nxt and is_op(nxt, "(")):
            if "." not in t[1] and t[1] in names:
                out.append(":B_" + t[1]); last = pos + len(raw); continue
            head = t[1].split(".")[0]
            if "." in t[1] and head in names and head not in al:
                out.append(":B_" + t[1].replace(".", "_")); last = pos + len(raw); continue
        out.append(raw)
        last = pos + len(raw)
    return "".join(out)'''
assert old in s; s=s.replace(old,new); p.write_text(s,encoding="utf-8"); print("bindify patched")
