# -*- coding: utf-8 -*-
"""여러 패키지를 순서대로 --apply → --after 실행하고 요약만 출력한다. 상세는 logs\\batch_<시각>.log
  python run_batch.py PKG_A PKG_B ...
DB 원문은 apply_patch.py 가 실행 시점에 ALL_SOURCE 에서 다시 조회하고 FRESH-GATE 로 확인한다.
"""
import sys, os, subprocess, datetime, re
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
HERE = os.path.dirname(os.path.abspath(__file__))
log = os.path.join(HERE, 'logs', 'batch_%s.log' % datetime.datetime.now().strftime('%H%M%S'))
env = dict(os.environ, PYTHONIOENCODING='utf-8')
for name in sys.argv[1:]:
    out = ''
    for mode in ('--apply', '--after'):
        p = subprocess.run([sys.executable, os.path.join(HERE, 'apply_patch.py'), name, mode], capture_output=True, text=True, encoding='utf-8', errors='replace', env=env)
        out += p.stdout + p.stderr
        if mode == '--apply' and p.returncode != 0:
            break
    open(log, 'a', encoding='utf-8').write(out)
    ap = re.search(r'적용 완료.*', out)
    res = re.search(r'대조 결과: .*', out)
    bad = [l.strip() for l in out.splitlines() if ('FAIL' in l and '대조 결과' not in l) or 'ERROR' in l or 'Error' in l or 'ORA-' in l or '컴파일 오류' in l]
    tests = len(re.findall(r'\[after\]', out))
    # 수정 전/후 시간 합
    tb = sum(float(x) for x in re.findall(r'\| 전 \S+행 ([\d.]+)s', out))
    ta = sum(float(x) for x in re.findall(r'→ 후 \S+행 ([\d.]+)s', out))
    slow = [l.strip()[:150] for l in out.splitlines() if (m := re.search(r'전 \S+행 ([\d.]+)s → 후 \S+행 ([\d.]+)s', l)) and float(m.group(2)) > max(2.0, float(m.group(1)) * 2)]
    print('%s | %s | 시험 %d개 | %s | 시간합 전 %.1fs → 후 %.1fs' % (name, ap.group(0)[:95] if ap else '적용 실패', tests, res.group(0) if res else '대조 없음', tb, ta))
    for b in bad[:8]:
        print('    !', b[:230])
    for s in slow[:5]:
        print('    느려짐:', s)
print('상세:', log)
