# -*- coding: utf-8 -*-
# PL/SQL 토큰 분석(주석·문자열 구분) — 조사 때 쓴 분석기 사본
import re
def tokenize(s):
    """PL/SQL 토큰: ('c',start,end)=주석 ('s',start,end,content)=문자열 ('o',start,end,text)=기타 기호/단어"""
    i, n, out = 0, len(s), []
    while i < n:
        ch = s[i]
        if ch.isspace():
            i += 1; continue
        if s.startswith('--', i):
            j = s.find('\n', i); j = n if j < 0 else j
            out.append(('c', i, j, s[i:j])); i = j; continue
        if s.startswith('/*', i):
            j = s.find('*/', i + 2); j = n if j < 0 else j + 2
            out.append(('c', i, j, s[i:j])); i = j; continue
        if ch in 'qQ' and i + 2 < n and s[i+1] == "'" and (i == 0 or not (s[i-1].isalnum() or s[i-1] in '_$#')):
            op = s[i+2]; cl = {'[': ']', '(': ')', '{': '}', '<': '>'}.get(op, op)
            j = s.find(cl + "'", i + 3)
            if j < 0: j = n - 2
            out.append(('s', i, j + 2, s[i+3:j], 'q')); i = j + 2; continue
        if ch == "'":
            j = i + 1; buf = []
            while j < n:
                if s[j] == "'":
                    if j + 1 < n and s[j+1] == "'":
                        buf.append("'"); j += 2; continue
                    break
                buf.append(s[j]); j += 1
            out.append(('s', i, min(j + 1, n), ''.join(buf), 'n' if j < n else 'unterminated')); i = j + 1; continue
        if ch == '"':
            j = s.find('"', i + 1); j = n - 1 if j < 0 else j
            out.append(('o', i, j + 1, s[i:j+1])); i = j + 1; continue
        m = re.compile(r'[A-Za-z_][A-Za-z0-9_$#]*|\d+(?:\.\d+)?|<>|!=|\^=|~=|<=|>=|:=|\|\||.', re.S).match(s, i)
        out.append(('o', i, m.end(), m.group(0))); i = m.end()
    return out

