# -*- coding: utf-8 -*-
"""전수 목록의 '아직 증명 안 됨' 을 보완 유형으로 묶는다 (2026-11-12 주기 방식 — 일괄 보완의 작업 단위)

  python tools/Harness/verify/backlog_types.py            Doc/verify/_proof_backlog_detail.csv → Doc/verify/_backlog_types.md · _backlog_types.csv
  python tools/Harness/verify/backlog_types.py --selftest

  proof_backlog.py 의 분류(B01~B16)는 '어디서 막혔나' 이고 사유 문장은 화면·대상마다 달라 932종까지 갈라진다.
  일괄 보완은 '무엇을 고치면 풀리나' 단위가 필요하다 → 사유 문장을 아래 규칙으로 유형에 묶는다(위에서부터 첫 일치).
  어느 규칙에도 안 맞는 것은 '미분류' 로 남긴다(숨기지 않는다 · 합계 = 입력 합계 강제).
  증명됨(A1)·조치 필요(A2)·근거 있는 해당없음(N1)은 대상이 아니다.
"""
import csv, os, re, sys, time

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
VD = os.path.join(ROOT, 'Doc', 'verify')

# (유형 id, 이름, 사유 정규식, 고칠 것)
TYPES = [
    ('Y01', '신규행 전제 미충족(Insert 가 행을 못 만듦)', r'신규행 없음|신규 행 없음|Insert 전제|신규행 전제', '검사기가 AS-IS Insert 전제(시트·편집 잠금 해제·선택 행 상태)를 만든 뒤 Insert'),
    ('Y02', '검증 메시지가 Save 경로 밖(편집·다른 버튼 경로)', r'경로 메시지\(저장 전 검증 아님|Save 진입점에서 닿지 않음', '메시지를 내는 동작(편집 버튼·셀 변경 등)을 실행해 판정하는 경로 추가'),
    ('Y03', '검증 메시지 위반 입력 자동 생성 불가', r'위반 입력 자동 생성 불가|위반 입력.*생성', '조건식에서 위반 값을 만들어 넣는 생성기 확장'),
    ('Y04', '행 조건식을 행 값으로 풀지 못함(조건부 잠금 등)', r'조건 계산 불가|조건식을 행 값으로 풀지 못함', '조건식 평가기 확장(메서드 호출·열 번호·상수)'),
    ('Y05', '연쇄 원천 칸을 열 수 없음(기존행 편집 불가)', r'원천 .{0,40}기존행 편집 불가|원천 셀을 열 수 없', '원천 칸이 편집되는 행·상태(신규행·편집 모드)를 만들어 측정'),
    ('Y06', '연쇄 원천 컬럼 분기 해석 불가', r'원천 컬럼 분기 해석 불가|원천/대상 해석 불가', 'AS-IS 분기 조건 해석(사실 추출) 확장'),
    ('Y07', '콤보가 아니라 후보 변화 비교 불가', r'콤보\(.{0,20}\) 아님 — 후보 변화 비교 불가|후보 변화 비교 불가', '적용성 재판정(콤보 아닌 대상은 값 채움 규칙으로 이관)'),
    ('Y08', '팝업 검사기가 대상을 실행하지 못함', r'(smoke popup|팝업 내부 조회|popup_args_check|팝업).{0,80}실행하지 못함|실행하지 못함.{0,40}팝업', '팝업 검사 실행 경로(여는 방법·대상 식별) 추가'),
    ('Y18', '팝업에서 고른 값이 행에 반영되는 위치 확인 불가', r'팝업에서 가져온 값이 행에 하나도 반영되지 않음|팝업 선택값 반영|팝업 열림 감지 실패', '팝업 선택 → 반영 칸 추적(반영 대상 컬럼 사실 + 팝업 열기 경로)'),
    ('Y19', '검사기는 있는데 이 대상을 실행하는 경로 없음', r'실행하는 경로 없음|검증 엔진 연결 필요', '규칙별로 대상(COL·BTN·SP)을 검사 항목으로 만드는 연결 추가'),
    ('Y09', '검사기가 대상을 실행하지 못함(팝업 외)', r'이 대상을 실행하지 못함|검증 엔진 확장 대상', '규칙별 검사 실행 경로 추가(규칙별로 다시 나눔)'),
    ('Y10', '현재 그리드·화면에 대상 없음(다른 시트·상태)', r'현재 그리드에 없음|현재 화면에 없음|탭 .{0,30}0행|조회 결과 0행|데이터 없음', '대상이 있는 시트·조건·데이터를 찾아 측정(행 확보)'),
    ('Y11', '집계 행 — 하위 검사가 풀리면 따라 풀림', r'진입점 집계|행 집계', '직접 보완 대상 아님(하위 유형 보완 뒤 재집계)'),
    ('Y12', '차등 검증 인자 미정·짝 없음', r'인자 미해결|짝 없음|sp_pair|케이스 없음|골든|파라미터 미정', '인자·짝 해결'),
    ('Y13', '대조표 서술 보강', r'구현 위치|제외 사유 미기재|서술 보강', '대조표에 구현 위치·제외 사유 기재'),
    ('Y14', '프레임워크 공통 오류 표시(검사 대상 아님 표기)', r'검사 대상 아님 — .{0,20}블록 예외 메시지', '적용성 근거 정리(해당없음 근거 확인)'),
    ('Y15', '원장 판정 승계만 있고 사유 없음', r'^(ASIS|~)?\s*/?\s*원장 ~|원장 판정 승계', '원장 행의 실제 사유로 다시 분류(proof_backlog 사유 해석 보강)'),
    ('Y16', '측정 경로 없음·실패(그 밖)', r'측정 경로 없음|측정 경로 실패|측정 경로 누락|미기동|시간 초과|timeout', '실패 원인별 수정(시간 초과·경로)'),
    ('Y20', '설계 결정·TO-BE 룰로 처리된 것(사람 판정 근거 확인)', r'설계 결정\(|TO-BE 룰|룰 ~ —|DD-|CR-', '결정 근거가 원장에 연결됐는지 확인 → 근거 있으면 해당없음 확정'),
    ('Y21', '실행은 됐으나 판정하지 못함', r'판정하지 못함|인자 대조 불가|호출 없음\(셀 이벤트', '판정 규칙·재확인 행 선택 보강'),
    ('Y17', '해당없음 — 근거 재확인 필요', r'해당없음|검사 대상 아님|연결된 AS-IS 문장|연결된 문장|죽은 코드|진입점 미연결|메시지/규칙 없음|인자 없는 팝업 문장', '근거 있는 것만 인정 · 나머지 미검증으로 재분류'),
]
SKIP = ('A1', 'A2', 'A3', 'A4', 'N1')  # 2026-11-13 T285: A3 집계 행 · A4 대조표 미구현 표기


def classify(reason):
    for tid, name, rx, _ in TYPES:
        if re.search(rx, reason or ''):
            return tid
    return 'Y99'


def selftest():
    cases = [
        ('[측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(…)', 'Y01'),
        ('실측: ~ — ~ 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음)', 'Y02'),
        ('실측: ~ 위반 입력 자동 생성 불가(검사기 한계)', 'Y03'),
        ('/ 실측: 조건 계산 불가(검사기가 ~ 조건식을 행 값으로 풀지 못함 — 미검증)', 'Y04'),
        ('원천 ~ 기존행 편집 불가 → 기계 판정 불가', 'Y05'),
        ('원천 컬럼 분기 해석 불가 — 조건 ~', 'Y06'),
        ('| 검사기(~(@~) W4b 팝업 내부 조회(~) )가 이 대상을 실행하지 못함', 'Y08'),
        ('| 검사기(~(@~) · ~(@~) W5)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상', 'Y09'),
        ('진입점 집계 3검사 — ~ (미실행 검사가 남아 판정필요)', 'Y11'),
        ('전혀 다른 문장', 'Y99'),
        ('신규행 없음 과 진입점 집계 가 같이 있으면 앞 규칙', 'Y01'),
    ]
    bad = 0
    for s, want in cases:
        got = classify(s); ok = got == want; bad += not ok
        print(('PASS ' if ok else 'FAIL ') + f'{want} ← {s[:50]}' + ('' if ok else f' (실제 {got})'))
    ids = [t[0] for t in TYPES]
    ok = len(ids) == len(set(ids)); bad += not ok
    print(('PASS ' if ok else 'FAIL ') + '유형 id 중복 없음')
    print(f'selftest {len(cases) + 1 - bad}/{len(cases) + 1}')
    return 1 if bad else 0


def main():
    if '--selftest' in sys.argv:
        return selftest()
    src = os.path.join(VD, '_proof_backlog_detail.csv')
    rows = list(csv.DictReader(open(src, encoding='utf-8-sig')))
    tot_in = 0; agg = {}; un = {}
    for r in rows:
        if r['bucket'][:2] in SKIP:
            continue
        n = int(r['count']); tot_in += n
        tid = classify((r.get('reason') or '') + ' ' + (r.get('example') or '') if False else (r.get('reason') or ''))
        a = agg.setdefault(tid, {'n': 0, 'checks': {}, 'buckets': {}, 'screens': set(), 'ex': ''})
        a['n'] += n; a['checks'][r['check']] = a['checks'].get(r['check'], 0) + n
        a['buckets'][r['bucket'][:3]] = a['buckets'].get(r['bucket'][:3], 0) + n
        a['screens'].add(r['example_screen']); a['ex'] = a['ex'] or (r.get('reason') or '')[:120]
        if tid == 'Y99':
            k = (r['bucket'][:3], r['check'], (r.get('reason') or '')[:90]); un[k] = un.get(k, 0) + n
    assert sum(a['n'] for a in agg.values()) == tot_in, '합계 불일치'
    name = {t[0]: t[1] for t in TYPES}; fix = {t[0]: t[3] for t in TYPES}; name['Y99'] = '미분류'; fix['Y99'] = '사유를 읽어 유형 규칙 추가'
    at = time.strftime('%Y-%m-%d %H:%M:%S')
    top = lambda d, k=5: ' · '.join(f'{x}:{v}' for x, v in sorted(d.items(), key=lambda kv: -kv[1])[:k])
    md = [f'# 아직 증명 안 된 검사 단위 — 보완 유형별 ({at})', '',
          f'입력 = `_proof_backlog_detail.csv`(증명됨·조치 필요·근거 있는 해당없음 제외) 합 **{tot_in}**. 아래 유형 합 = 입력 합(하나도 빼지 않음). 사유 문장은 숫자·식별자가 `~` 로 일반화된 것.', '',
          '| 유형 | 이름 | 건수 | 검사 규칙(상위) | 막힌 분류 | 고칠 것 |', '|---|---|---|---|---|---|']
    out = []
    for tid, a in sorted(agg.items(), key=lambda kv: -kv[1]['n']):
        md.append(f"| {tid} | {name[tid]} | {a['n']} | {top(a['checks'])} | {top(a['buckets'], 4)} | {fix[tid]} |")
        out.append({'at': at, 'type': tid, 'name': name[tid], 'count': a['n'], 'checks': top(a['checks'], 8), 'buckets': top(a['buckets'], 8), 'fix': fix[tid], 'example': a['ex']})
    md += ['', '## 미분류 상위(유형 규칙 추가 대상)', '', '| 건수 | 분류 | 규칙 | 사유 |', '|---|---|---|---|']
    for (b, c, s), n in sorted(un.items(), key=lambda kv: -kv[1])[:40]:
        md.append(f"| {n} | {b} | {c} | {s.replace('|', '/')} |")
    open(os.path.join(VD, '_backlog_types.md'), 'w', encoding='utf-8').write('\n'.join(md) + '\n')
    with open(os.path.join(VD, '_backlog_types.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(out[0].keys())); w.writeheader(); w.writerows(out)
    # 2026-11-12: 유형 × 화면(화면별 건수 — 대표 화면이 아니라 실제 건수)
    sp = os.path.join(VD, '_proof_backlog_detail_by_screen.csv')
    if os.path.exists(sp):
        ts = {}
        for r in csv.DictReader(open(sp, encoding='utf-8-sig')):
            if r['bucket'][:2] in SKIP:
                continue
            k = (classify(r.get('reason') or ''), r['menu_id'], r['check'])
            ts[k] = ts.get(k, 0) + int(r['count'])
        with open(os.path.join(VD, '_backlog_types_by_screen.csv'), 'w', encoding='utf-8-sig', newline='') as f:
            w = csv.writer(f); w.writerow(['type', 'menu_id', 'check', 'count'])
            for (tid, m_, chk), n in sorted(ts.items(), key=lambda kv: (kv[0][0], -kv[1])):
                w.writerow([tid, m_, chk, n])
    print(f'[backlog_types] {at} · 입력 {tot_in} · 유형 {len(agg)} → Doc/verify/_backlog_types.md')
    for o in out:
        print(f"  {o['count']:>6}  {o['type']} {o['name']}  [{o['checks'][:60]}]")
    return 0


if __name__ == '__main__':
    sys.exit(main())
