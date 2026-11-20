# -*- coding: utf-8 -*-
"""엔진 갭 항목을 신설 묶음(engine)으로 분류해 _engine_gap.csv 에 고정하고 진행 현황을 출력한다(2026-10-31) — 진행율의 분모는 이 파일

  python tools/Harness/verify/engine_gap_cluster.py          → engine 열 갱신(이미 값이 있으면 유지) · 묶음별 현황
  python tools/Harness/verify/engine_gap_cluster.py E05      → 그 묶음의 미완료 항목 목록
  build_status: 해당없음(이미 있음) · 미착수 · 구현(코드 작성) · 변이입증(주입 오류 FAIL·정상 PASS 확인) · 완료(문서 화면 실측) · 불가(사유·사용자 확인)
"""
import collections, csv, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
F = os.path.join(ROOT, 'Doc', 'verify', '_engine_gap.csv')
G = [('E01 Excel 업로드·양식', r'Excel|엑셀|업로드|Upload|양식'),
     ('E02 팝업', r'팝업|Popup|모달'),
     ('E03 Division·권한 순회', r'Div(?:ision)? ?(별|전환|순회)|권한|계정|그룹|GET_ADMIN|시간창'),
     ('E04 값 계산·DB 대조', r'계산|환산|합계|Sum|이월|재계산|파생|비율|단가'),
     ('E05 저장 세부', r'저장|Save|중복|다건|이력|DB 반영'),
     ('E06 붙여넣기·행 조작', r'붙여넣|Ctrl|복사|Insert|Delete|병합|행 추가|행 삭제'),
     ('E07 컬럼 설정·개인화', r'컬럼 ?(셋팅|설정)|Columns|개인화|TITLESET|USER_SELECT|필수 컬럼'),
     ('E08 레이아웃·디자인', r'너비|겹침|리사이즈|폭|레이아웃|높이|색|스크롤|글자'),
     ('E09 다국어·라벨·메시지', r'언어|다국어|라벨|메시지|문구|표기'),
     ('E10 조회조건', r'조회조건|필터|Filter|Like|콤마|대소문자|초기화|연쇄|하위|후보'),
     ('E11 편집 잠금·기간', r'잠금|편집|Measure|Bucket|구간'),
     ('E12 정렬·표시 형식', r'Sort|정렬|표시|형식|소수|천단위')]


def main():
    with open(F, encoding='utf-8-sig', newline='') as fh:
        R = list(csv.DictReader(fh))
    for r in R:
        if not r.get('engine'):
            t = r['sub_item'] + ' ' + r['missing']
            r['engine'] = next((k for k, p in G if re.search(p, t, re.I)), 'E99 기타')
    fields = [k for k in R[0].keys() if k != 'engine'] + ['engine']
    with open(F, 'w', encoding='utf-8-sig', newline='') as fh:
        w = csv.DictWriter(fh, fieldnames=fields); w.writeheader(); w.writerows(R)
    if len(sys.argv) > 1:
        for r in R:
            if r['engine'].startswith(sys.argv[1]) and r['build_status'] in ('미착수', '구현'):
                print(r['gap_id'], r['rule_id'], r['status'], f"행{r['doc_rows']}", '|', r['sub_item'][:90], '|', r['missing'][:110])
        return
    c = collections.defaultdict(collections.Counter); d = collections.Counter()
    for r in R:
        c[r['engine']][r['build_status']] += 1; d[r['engine']] += int(r['doc_rows'] or 0)
    for k in sorted(c):
        print(k, '문서행', d[k], dict(c[k]))
    tot = collections.Counter(r['build_status'] for r in R); print('전체', len(R), dict(tot))


if __name__ == '__main__':
    main()
