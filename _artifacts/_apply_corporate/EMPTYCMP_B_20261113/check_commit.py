# -*- coding: utf-8 -*-
# 시험 전 확인: 조회 프로시저 안의 COMMIT, ROLLBACK, 자율 트랜잭션 줄
import os, re, sys
sys.stdout.reconfigure(encoding='utf-8')
HERE = os.path.dirname(os.path.abspath(__file__))
for name, sub in (('PKG_DMF0003', 'P_DMF0003_GET_MKT_FCST_DATA'), ('PKG_DMF0003_01', 'P_DMF0003_01_GET_MKT_FCST_DATA')):
    b = open(os.path.join(HERE, 'backup', name + '.ASIS.sql'), encoding='utf-8', newline='').read().split('\n')
    s = next(i for i, l in enumerate(b) if re.match(r'\s*PROCEDURE\s+' + sub + r'\b', l, re.I))
    e = next(i for i, l in enumerate(b) if i > s and re.match(r'\s*END\s+' + sub + r'\s*;', l, re.I))
    hits = [(i + 1, b[i].strip()[:90]) for i in range(s, e)
            if re.search(r'\bCOMMIT\b|AUTONOMOUS|\bROLLBACK\b', b[i], re.I) and not b[i].lstrip().startswith('--')]
    print(name, sub, 'L%d~%d' % (s + 1, e + 1), 'COMMIT/ROLLBACK/AUTONOMOUS 줄:', hits[:8])
