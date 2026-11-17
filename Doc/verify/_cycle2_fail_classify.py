# -*- coding: utf-8 -*-
"""주기 2 점검 - 요소 단위 조치 필요(FAIL)를 지금까지 확인한 근거로 분류한다.
   출력: Doc/verify/_cycle2_fail_classified.csv (행마다 분류, 근거) 와 화면별 집계.
   분류는 _ENGINE_MASTER.md 11-13 기록에서 원문, 로그, 별도 실측으로 확인한 꼴만 넣는다. 그 밖은 '미분류'."""
import csv, collections, sys, re, os
sys.stdout.reconfigure(encoding='utf-8'); csv.field_size_limit(10**9)
S = 'DMF0005 SCP0005 SCP0007 SCP0016 SCP0020 SCP0028 SCP0033 SCP0037 SCP0041 SCP0084 SCP0111 SCP0122 SCP0127 SCP0131 SSP0003 SSP0005 SSP0014 SSP0015 SSP0021 SSP0023 SSP0024 SSP0025 SSP0060 SSP0200'.split()
A = '엔진 오판(수정됨, 재측정 대기)'; B = '엔진 오판(미수정)'; C = '문서 표기'; D = '실제 차이 후보'; E = '사용자 결정 대기'; F = '미분류'; G = 'AS-IS 실측, 추가 측정 대상'


def cls(m, chk, name, txt, x_et=''):
    if 'PR_GET_MNU_BTN_AUTH_DIV(Div' in txt and '없음 → 비노출' in txt: return A, 'T288 버튼 권한 기대값(CR-102)'
    if re.search(r'신규행 r\d+ \S+ 편집=false \(AS-IS 편집 가능\)|기존행 r\d+ \S+ 편집=false \(AS-IS 편집 가능\)', txt) and '[T-' in txt and chk in ('D1', 'E4'): return A, 'T289 다른 컨트롤의 편집 기대값'
    if '위반 입력 경로 없음(AS-IS 는 편집 가능)' in txt: return A, 'T289 에 딸린 E4'
    if re.search(r'GROUP ?== ?"[^"]+".{0,200}편집=true \(AS-IS 잠금', txt): return A, 'T301 잠금 규칙의 그룹 조건(CR-102 합집합)'
    if '조건부 잠금 재현 불가' in txt: return A, 'T300 재현 전제 미충족'
    if chk == 'F3' and re.search(r"원값 '[/-]' Copy='[/-]'", txt): return B, '빈 값 표시(/, -)를 복사한 경우'
    if chk == 'A1' and re.search(r'golden DIFF AS-IS 0행 ↔ TO-BE \d+행', txt): return B, 'AS-IS 0행, TO-BE 조회됨. CR-101 상 오류 아님(데이터 차이)'
    if chk in ('D1', 'J3') and re.search(r'GROUP ?== ?"[^"]+" → 잠금\) NG', txt) and '편집=true' in txt: return A, 'T301 잠금 규칙의 그룹 조건(CR-102 합집합)'
    if chk == 'C2' and '미구현(D00-' in txt: return C, '대조표가 미구현으로 적은 항목에 딸린 검사'
    if chk == 'C2' and m == 'DMF0005' and name.split(' / ')[0].strip() == 'DIVISION_ID': return C, '대조표 D00-3-009(내 Division 목록 콤보 미구현)에 딸린 검사. 같은 대상의 다른 2건과 같은 항목'
    if chk == 'D1' and 'AS-IS 편집 가능(기본(편집 모드 전체 해제))' in txt: return G, 'AS-IS 기대값이 11-12 편집 모드 해석에서 나옴. AS-IS 실측으로 확인'
    if chk == 'D1' and re.search(r'편집=true \(AS-IS 잠금\)|편집=true / AS-IS 잠금\(', txt): return D, 'AS-IS 잠금 컬럼이 TO-BE 편집 가능'
    if chk == 'F3' and '후보 밖 값' in txt: return G, '후보 밖 값 붙여넣기의 AS-IS 동작 미확인. AS-IS 실측으로 확인'
    if chk == 'F3' and '코드·명칭 동반' in txt: return D, '붙여넣기 시 코드 칸이 채워지지 않음'
    if chk == 'F2' and '저장 요청 없음' in txt: return G, '시험 입력값(E2E_SCN 등)으로 저장이 막힌 이유 문구 미기록. T302 로 다음 실행부터 기록'
    if chk == 'G4' and m == 'SCP0028': return A, 'T308 smoke 라벨 후보에 KO 문구(Div) 없음'
    if chk == 'X-LOC': return C, '대조표가 적은 구현 파일이 없음'
    if chk == 'K3' and 'Hide Column' in txt: return D, 'SCP0037 별도 실측으로 재현(11-13 17:28)'
    if chk == 'C6': return D, '값 변경 없이 닫아도 하위 값 지워짐(실측 문구)'
    if chk == 'D3': return D, '행 값 조건 잠금이 AS-IS 와 다름'
    if chk == 'A5' and '표시 여부 불일치' in txt: return D, '메타 표시 여부가 AS-IS 와 다름'
    if chk == 'B3': return D, '콤보 후보 순서가 AS-IS 와 다름'
    if chk == 'M3': return D, '팝업 목록 0건 또는 팝업 열림 실패'
    if chk == 'F5': return D, 'CRUD 상태 표시가 AS-IS 와 다름'
    if chk == 'I1' and '미등록' in txt: return D, '메시지 코드 미등록'
    if '편집기 생성 오류' in txt: return D, '셀 편집 시작 시 화면 오류'
    if chk == 'E4' and ('오류코드' in txt or 'errCode' in txt): return D, '저장 실패 시 오류 행, 셀 표시 없음'
    if chk == 'F1' and re.search(r'재조회 .* NG|저장 요청 없음', txt): return D, '저장 왕복 불일치'
    if chk == 'A6' and '순서대조 DIFF' in txt: return D, '실측 행 순서가 AS-IS 와 다름'
    if chk == 'A6': return D, 'ORDER BY 문장 차이(실측 없음, 건별 확인 대상)'
    if chk == 'F10': return E, '저장 PROC 안 COMMIT 판정 기준(F10 표준)'
    # 11-13 19:40 미분류 43건 원장 확인분
    if chk == 'B1' and '후보 0건' in txt: return D, '셀 콤보 후보 0건'
    if chk == 'B2' and '중복' in txt: return D, '조회조건 후보 중복'
    if chk == 'B6': return D, '조회조건 ALL 항목 유무가 AS-IS 와 다름'
    if chk == 'C1' and '값 유지' in txt: return D, '상위 조건 변경 시 하위 값 비우기 없음'
    if chk == 'C3' and '원천 선택 후 대상 빈 값' in txt: return D, '연쇄 채움 없음'
    if chk == 'D5': return D, '셀 유형이 AS-IS 와 다름'
    if chk == 'D6': return D, 'Insert 위치가 선택 행 위가 아님'
    if chk == 'E1' and 'NG' in txt: return D, 'AS-IS 가 막는 값(최소 0 미만)이 입력됨'
    if chk == 'E2' and '존재하지 않는 날짜' in txt: return D, '없는 날짜가 입력됨'
    if chk == 'E3' and '차단되지 않음' in txt: return D, '필수 공란인데 조회가 차단되지 않음'
    if chk == 'F6' and '복원되지 않음' in txt: return D, '원복 저장 후 값이 복원되지 않음'
    if chk == 'F6' and '저장 요청 없음' in txt: return G, '시험 입력 뒤 저장 요청이 없는 이유 문구 미기록. 추가 측정 필요'
    if chk == 'G1' and 'NG' in txt: return D, '조회조건 값이 결과에 반영되지 않음'
    if chk == 'G4' and '누락 라벨' in txt: return G, 'smoke 라벨 대조의 누락 판정. 라벨별 확인 필요'
    if chk == 'G6' and '[사용자판정] FAIL' in txt: return D, '사용자 확정(11-06)'
    if chk == 'G6': return D, '조회조건 초기값이 AS-IS 와 다름'
    if chk == 'H10' and '확인창 없이 저장 요청' in txt: return D, '저장 전 확인창 없음'
    if chk == 'H10' and 'MSG00680' in txt: return D, '편집 중 실행 차단 문구 없음'
    if chk == 'H2' and '편집 불가인데 노랑' in txt: return D, '셀 색과 편집 가능 여부가 다름'
    if chk == 'H4': return G, '기준 화면샷과 차이. 차이 내용 확인 필요'
    if chk == 'I1' and '없음 — 실제' in txt: return D, '변경 없이 저장 시 안내 문구 없음'
    if chk == 'K-SA': return G, 'smoke 조회영역 토글 결과. 내용 확인 필요'
    if chk == 'J2' and '(그룹 조건)' in txt and '실제 노출' in txt: return G, '그룹 조건 버튼 노출. 시험 계정의 보유 그룹과 CR-102 적용 여부 확인 필요'
    if chk in ('F1', 'J2', 'K4') and x_et == 'SCREEN' and '] ' not in txt.split(' ## ', 1)[-1]: return G, 'crud, authcrud, auth 테스트 전체 FAIL 을 화면 단위에 귀속(시간 초과, Insert 후 행 증가 없음, SAVE 호출 없음 등). 조작 성립 여부 확인 필요'
    return F, ''


rows = []; per = collections.defaultdict(collections.Counter)
for m in S:
    led = {y['row_id']: y for y in csv.DictReader(open(f'Doc/verify/{m}/verify_ledger.csv', encoding='utf-8-sig'))}
    for x in csv.DictReader(open(f'Doc/verify/{m}/mapping_trace_instances.csv', encoding='utf-8-sig')):
        if x['result'] != 'FAIL' or re.match(r'\s*(행|진입점) 집계', x['why']) or re.search(r"의 상태가 '미구현'|^\s*선행 미구현에 종속", x['why']): continue
        ev = []
        for vid in re.findall(r'[VT]-[0-9a-f]{8}|EG-[0-9a-f]{8}', x['why']):
            y = led.get(vid)
            if y and y['result'] == 'FAIL': ev.append(f"[{vid} {y['source']}] " + re.sub(r'\s+', ' ', y['evidence'])[:700])
        # 사유가 원장 ID 목록으로 잘린 경우: 같은 규칙의 FAIL 원장 행 중 이 대상 이름이 들어간 것을 근거로 붙인다
        if not ev:
            nm = x['name'].split(' / ')[0].strip()
            for y in led.values():
                if y['result'] == 'FAIL' and y['rule_id'] == x['check'] and y['source'] != 'TRACE' and nm and nm in (y['target'] + ' ' + y['condition'] + ' ' + y['evidence'][:400]):
                    ev.append(f"[{y['row_id']} {y['source']}] " + re.sub(r'\s+', ' ', y['evidence'])[:700])
                    if len(ev) >= 2: break
        txt = re.sub(r'\s+', ' ', x['why']) + ' ## ' + ' ## '.join(ev)
        c, why = cls(m, x['check'], x['name'], txt, x['et'])
        per[m][c] += 1
        rows.append([m, c, why, x['check'], x['et'], x['name'][:60], re.sub(r'\s+', ' ', x['why'])[:300], ' ## '.join(ev)[:900]])
with open('Doc/verify/_cycle2_fail_classified.csv', 'w', encoding='utf-8-sig', newline='') as f:
    w = csv.writer(f); w.writerow(['화면', '분류', '분류 근거', '검사', '대상 유형', '대상', '사유', '원장 근거']); w.writerows(rows)
order = [A, B, C, D, G, E, F]
print('화면 | 요소 | ' + ' | '.join(order))
T = collections.Counter()
for m in S:
    p = per[m]; T.update(p)
    print(m, '|', sum(p.values()), '|', ' | '.join(str(p[k]) for k in order))
print('합계 |', sum(T.values()), '|', ' | '.join(str(T[k]) for k in order))
un = collections.Counter((r[3]) for r in rows if r[1] == F)
print('미분류 검사 종류', un.most_common())
