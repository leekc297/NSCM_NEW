# SCP0005 미검증 해소 행별 조치표 생성(라운드 3, 2026-11-25)
import csv, os, sys, collections
B = 'C:/Projects/NSCM/Doc/verify/SCP0005/'
rows = [x for x in csv.DictReader(open(B + 'unverified_triage.csv', encoding='utf-8-sig')) if x['actor'] != '집계']
res = {}
rp = 'C:/Projects/NSCM/.tmp_u5/results.csv'
if os.path.exists(rp):
    res = {x['row_id']: x for x in csv.DictReader(open(rp, encoding='utf-8-sig'))}
BUN = {
 'B01': ('D1·E1 POPUP 시트 기대값', 'L', 'tools/Harness/verify/ledger.py'),
 'B02': ('H2 배경색 조건 행', 'T', 'Doc/e2e/specs/_trace.spec.ts'),
 'B03': ('C2·C3·C6 연쇄 추적', 'T', 'Doc/e2e/specs/_trace.spec.ts'),
 'B04': ('E4 메시지 경로', 'T', 'Doc/e2e/specs/_trace.spec.ts'),
 'B05': ('H6·G5 팝업 표준·인자', 'V', 'Doc/e2e/specs/_verify.spec.ts'),
 'B06': ('C3·C6 LT 숫자 칸 입력', 'V', 'Doc/e2e/specs/_verify.spec.ts'),
 'B07': ('F3 후보 밖 값 복사', 'G', 'tools/Harness/verify/gen_expect.py'),
 'B08': ('시나리오 기대값(팝업 채움·필수칸·콤보 원천)', 'G', 'tools/Harness/verify/gen_expect.py'),
 'B09': ('저장 왕복·키 중복', 'V', 'tools/E2E/lib/saveprobe.ts, newrow.ts'),
 'B10': ('SP 축(골든·순서·정렬·시노님)', 'S', 'tools/DbConn/golden.py, tools/Harness/verify/diff_verify.py, sort_check.py, syn_check.py'),
 'B11': ('EG 팝업 원문 연결', 'P', 'Doc/e2e/specs/eg_popup.spec.ts'),
 'B12': ('AS-IS 사실 추출', 'P', 'tools/Harness/verify/facts_*.py, tools/AsisFacts'),
 'B13': ('판정 규칙(judge·mapping_trace)', 'L', 'tools/Harness/verify/judge.py, mapping_trace.py'),
 'B14': ('추적 기타(팝업 0행·버튼·언어·업로드)', 'T', 'Doc/e2e/specs/_trace.spec.ts'),
 'B15': ('E2E 공용(언어·단축키·조건 대응·E1)', 'V', 'Doc/e2e/specs/_verify.spec.ts, tools/E2E/lib'),
 'B16': ('사람(스냅샷 승인)', '-', '결정 목록'),
 'B17': ('재실행(저장 왕복 클릭 시간 초과)', 'V', 'tools/E2E/lib/crud.ts'),
}
def bundle(x):
    r, rid, s, c = x['rule_id'], x['row_id'], x['source'], x['class']
    if x['actor'] == '사람': return 'B16'
    if x['actor'] == '자동': return 'B17'
    if r == 'D1' or (r == 'E1' and x['target'].startswith('POPUP.')): return 'B01'
    if r == 'E1': return 'B15'
    if r == 'H2': return 'B02'
    if rid in ('V-e4a3ef56', 'V-9beff6f2', 'V-eab82e73', 'V-3aecb21a') or r == 'C1': return 'B08'
    if s == 'TRACE' and r in ('C2', 'C3', 'C6'): return 'B03'
    if s == 'ASIS' and r in ('C3', 'C6'): return 'B06'
    if rid in ('V-3134fc3e',): return 'B13'
    if rid == 'V-b3450ff5': return 'B09'
    if r == 'E4': return 'B04'
    if r in ('H6', 'G5'): return 'B05'
    if r == 'F3': return 'B07'
    if r in ('F1', 'F6'): return 'B09'
    if r in ('A1', 'A6', 'A7', 'DB-SYN', 'F4') or rid == 'FACT-9f114f46': return 'B10'
    if s == 'FACT' or r == 'B4': return 'B12'
    if rid.startswith('EG-') and r in ('B3', 'G4', 'M3', 'D5'): return 'B11'
    if r in ('I2', 'K3', 'G1', 'E3'): return 'B15'
    if s == 'TRACE' and r in ('M4', 'G4', 'I3') and c != 'AI검토:검사기오판': return 'B14'
    if r in ('M3', 'M1', 'I3'): return 'B14'
    return 'B13'
for x in rows: x['b'] = bundle(x)
if __name__ == '__main__' and '--dump' in sys.argv:
    w = csv.writer(open('C:/Projects/NSCM/.tmp_u5/rows_by_bundle.csv', 'w', encoding='utf-8-sig', newline=''))
    w.writerow(['bundle', 'row_id', 'source', 'rule_id', 'class', 'target', 'evidence', 'remedy'])
    for x in sorted(rows, key=lambda z: z['b']): w.writerow([x['b'], x['row_id'], x['source'], x['rule_id'], x['class'], x['target'], x['evidence'], x['remedy']])
cnt = collections.Counter(x['b'] for x in rows)
order = sorted(BUN, key=lambda b: -cnt[b])
L = ['# SCP0005 미검증 해소 행별 조치표(라운드 3)', '',
     f"- 입력: 원장 verify_ledger.csv(2026-11-25 02:47), 분류 unverified_triage.csv(02:57:33). 미검증 148행 중 집계 47행 제외, 처리 대상 {len(rows)}행(엔진 162, 판단 1, 자동 2) + 사람 1행",
     f"- 목록 행 수 {len(rows)} = 분류 처리 대상 165 + 사람 1 = 166 확인: {'일치' if len(rows) == 166 else '불일치'}",
     '- 담당 에이전트: T = _trace.spec.ts, V = _verify.spec.ts·E2E lib, G = gen_expect.py, L = ledger.py·judge.py·mapping_trace.py, S = SP 축 검사기, P = eg_popup.spec.ts·사실 추출기', '',
     '## 묶음 요약(행 수 많은 순)', '', '| 묶음 | 내용 | 행 | 담당 | 고칠 파일 |', '|---|---|---|---|---|']
for b in order:
    if cnt[b]: L.append(f"| {b} | {BUN[b][0]} | {cnt[b]} | {BUN[b][1]} | {BUN[b][2]} |")
L += ['', '## 행별 조치', '', '| No | 묶음 | row_id | 원천 | 규칙 | 유형 | 대상 | 증거 요약 | 결과 | 사유·고친 곳 |', '|---|---|---|---|---|---|---|---|---|---|']
n = 0
cl = lambda s, k: (s or '').replace('|', '/').replace('\n', ' ')[:k]
for b in order:
    for x in [z for z in rows if z['b'] == b]:
        n += 1; rr = res.get(x['row_id'], {})
        L.append(f"| {n} | {b} | {x['row_id']} | {x['source']} | {x['rule_id']} | {x['class']} | {cl(x['target'], 50)} | {cl(x['evidence'], 140)} | {rr.get('result', '처리 전')} | {cl(rr.get('note', ''), 220)} |")
open(B + '_unverified_plan.md', 'w', encoding='utf-8').write('\n'.join(L) + '\n')
print('rows', len(rows), dict(cnt))
