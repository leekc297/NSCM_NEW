# -*- coding: utf-8 -*-
"""E2E 스펙·프로브의 템플릿 문자열(백틱) 안 단일 역슬래시 정규식 검사(2026-11-02 T40) — JS 가 \\d·\\s 의 역슬래시를 버려 정규식이 조용히 깨진다
  python -I tools/E2E/lint_tpl_regex.py   → 위치 출력 · 있으면 exit 1 (String.raw 줄·주석은 제외)
"""
import re,sys
bad=0
for f in ['Doc/e2e/specs/_verify.spec.ts','Doc/e2e/specs/_trace.spec.ts','Doc/e2e/specs/eg_popup.spec.ts','Doc/e2e/specs/eg_auth.spec.ts','tools/E2E/lib/probe.ts','tools/E2E/lib/saveprobe.ts','tools/E2E/lib/nscm.ts','tools/E2E/lib/popupprobe.ts','tools/E2E/lib/authprobe.ts','tools/E2E/lib/smoke-extra.ts']:
    s=open(f,encoding='utf-8',newline='').read()
    i=0;n=len(s);hits=[]
    # 간이 스캐너: 문자열·주석을 건너뛰며 백틱 구간을 찾는다(${} 안은 코드라 깊이 관리)
    stack=[];mode='code'
    while i<n:
        c=s[i]
        if mode=='code':
            if s.startswith('//',i):
                j=s.find('\n',i); i=n if j<0 else j; continue
            if s.startswith('/*',i):
                j=s.find('*/',i+2); i=n if j<0 else j+2; continue
            if c in '\'"':
                j=i+1
                while j<n and s[j]!=c and s[j]!='\n':
                    j+=2 if s[j]=='\\' else 1
                i=j+1; continue
            if c=='/' :
                # 정규식 리터럴 추정
                k=i-1
                while k>=0 and s[k] in ' \t': k-=1
                if k>=0 and s[k] in '(,=:[!&|?{};\n':
                    j=i+1; cl=False
                    while j<n and s[j]!='\n' and (s[j]!='/' or cl):
                        if s[j]=='\\': j+=1
                        elif s[j]=='[': cl=True
                        elif s[j]==']': cl=False
                        j+=1
                    i=j+1; continue
            if c=='`': mode='tpl'; i+=1; continue
            if c=='{' and stack: stack[-1]+=1
            if c=='}' and stack:
                stack[-1]-=1
                if stack[-1]==0:
                    stack.pop(); mode='tpl'; i+=1; continue
            i+=1; continue
        # tpl
        if c=='\\':
            nx=s[i+1] if i+1<n else ''
            if nx in 'dswbDSWB.':
                ln=s.count('\n',0,i)+1
                hits.append((ln,s[max(0,i-34):i+22].replace('\n',' ')))
            i+=2; continue
        if c=='`': mode='code'; i+=1; continue
        if s.startswith('${',i): stack.append(1); mode='code'; i+=2; continue
        i+=1
    hits=[h for h in hits if 'String.raw' not in h[1] and '템플릿 리터럴 안이라' not in h[1]]
    print(f,len(hits))
    bad+=len(hits)
    for h in hits[:40]: print('  ',h[0],h[1])
sys.exit(1 if bad else 0)
