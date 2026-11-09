# 검사엔진 허위 FAIL 근본 원인 분석과 보완 제안 (2026-11-06)

> 근거: 2026-11-06 SCP0084(29건)·SCP0037(12건)·SCP0016(38건) 조치 필요 항목 사용자 재확인 → 원인 확정분 T82~T102(`_checker_defects.md`).
> 실제 결함으로 남은 것: SCP0037 LT_DAY 최대 100(8번) · SCP0016 Ver. 기본값/필수 알림(4·16번) · SCP0016 EG160 필수 표시(24번) · SCP0084 EN 라벨 문자열(27번).
> 검사기가 **놓친** 실결함: SCP0016 Div 81 Operation group 'ele' 누락 — 원장 B4 행이 측정은 했으나 NA 로 내림(V-72ef7746).

## 1. 오늘 허위 FAIL 79건의 원인 분류

| 유형 | 건수(항목 기준) | 대표 | 공통 메커니즘 |
|---|---|---|---|
| A. 기대값 원천이 AS-IS 인데 TO-BE 가 룰·공용 컴포넌트로 바꾼 것 | 34 | SELECT ALL 항목(T88) · 1460 가로 스크롤(T91) · popupSearchField 40px(T95) · MeasureSelectModal(T100) · Enter 팝업(T92) · CN 검사 | 검사기가 AS-IS 원문·메타를 '정답' 으로 두고, TO-BE 확정 결정(CR/DD)·공용 컴포넌트 설계를 모름 → 공용이면 전 화면에서 반복 |
| B. 측정 실패를 결함으로 기록 | 12 | 편집 칸 화면 밖(T82) · Electrode 비활성(T101) · 헤더 반영 전 병합 0(T100) · Reset 뒤 접힌 칸 못 찾음(T96) | '못 쟀다'(0건·비활성·반영 전·DOM 밖)를 '없다' 로 해석 |
| C. 측정 시점·대상 선택 오류 | 9 | 첫 call-proc 만 봄(T98) · 편집 뒤 dataMap(T94) · 맨 위/맨 아래 헤더 행(T97·T99) | 화면 구조(병렬 호출·행별 dataMap 교체·다단 헤더)를 전제하지 않은 단일 경로 |
| D. 모의 응답이 실제 계약과 다름 | 16(묶음 1) | 저장 실패 주입 HTTP 500(T93) | BE 계약(200+CODE≠0)·FE 인터셉터 동작을 확인하지 않은 주입 |
| E. 사용자 판정·결정이 엔진에 좁게 반영 | 6 | NA 패턴 `$`(T90) · MS1 상속 · C4 정규식 꼬리 · 화면 전용 GAP 을 일반화(T92) | 판정 반입·상속 코드가 문자열 모양에 묶임 |
| F. 보고 품질 | (중복 포함 40+) | 같은 실측 16건 반복 · 위치 미기재 · '순서·구성' 오기(T89·T102) | 조치 필요 생성이 원장 행을 그대로 나열 |

## 2. 근본 보완 제안(우선순위 순)

### P1. FAIL 발행 2중 조건을 공통 게이트로(judge.py 마지막 단계)
- 지금: '근거 없음=ERROR' 계약이 있으나 검사기마다 따로 구현 → 빠진 곳(T82·T101·EG315)에서 FAIL 이 샘.
- 제안: FAIL 행은 **(1) 기대 원천 등급**(아래 P2)과 **(2) 측정 성공 증거**(조회 행>0 · 대상 칸 활성·DOM 존재 · 조회 호출 완료)가 증거 문자열에 있을 때만 FAIL 로 남기고, 없으면 ERROR(미검증)로 자동 전환. 측정 helper 가 `[측정 성공: 행 N·칸 활성]` 접두를 찍고 judge 가 그것을 요구.

### P2. 기대값 원천 우선순위 고정 + 공용 컴포넌트 계약 파일
- 순서: TO-BE 확정 결정(confirmed_requirements·design_decisions) > TO-BE 메타(sheet_columns·sheet_measure·btn_auth·cmbo_sql) > **공용 컴포넌트 계약** > AS-IS 원문.
- 신설 `tools/Harness/rules/common_contract.csv`: SearchArea 최소폭 1460·가로 스크롤 / popupSearchField 버튼 right:-40px / CustomDropdown 'ALL' sentinel·'SELECT ALL' 항목 / MeasureSelectModal·ColumnLayoutModal 대응 / axios 500 처리 / F10 서버 저장본만 삭제 … — 검사기가 이 표를 읽어 기대를 만들고, 공용 컴포넌트를 고칠 때 이 표도 같이 고친다(누락 시 CheckList 가 FAIL 로 알려주는 구조).
- AS-IS 와 다름 자체는 FAIL 이 아니라 **판정필요**. FAIL 은 TO-BE 기준(위 1·2·3단) 위반일 때만.

### P3. 검사기 자체 회귀(골든 화면)와 'FAIL 승격 게이트'
- 검사기·공용 컴포넌트를 수정할 때마다 골든 화면 2~3개(SCP0007·SCP0096 + 다단 헤더 화면 1개)의 결과가 바뀌지 않는지 자동 대조(지금 regress.py 는 사용자 판정 회귀만).
- 새 검사·새 기대는 처음엔 **판정필요** 로만 발행하고, 서로 다른 화면 2개 이상에서 사용자가 FAIL 을 확인한 뒤에만 FAIL 로 승격(엔진 갭 EG 신설 검사가 바로 FAIL 을 내는 지금 방식 폐지).

### P4. 측정 전제(precondition) helper 공통화
- 모든 E2E 검사 앞단: `조회 완료(networkidle·모든 SEARCH 응답)` · `rows>0` · `대상 칸 DOM 존재(가상화면 스크롤)` · `칸 활성` · `헤더 행 수 안정` 을 한 helper 로. 전제 미충족 = ERROR 반환(검사기가 FAIL 을 쓸 수 없게 타입으로 강제).

### P5. 사용자 판정의 일반화를 엔진이 제안
- 같은 규칙·같은 증거 패턴이 다른 화면 원장에도 있으면 판정 시 '설계 결정 후보(DESIGN_CAND)' 로 표시하고 ActionItemList 에 "다른 화면 N건 동일 — 전 화면 제외 여부 결정 요청" 을 적는다(오늘 CN·필터 유지처럼 수동으로 찾은 일을 자동화).

### P6. 조치 필요 목록 품질 게이트(make_verify_docs)
- 같은 실측 1회 → 1건(규칙·대상 이름이 달라도) · 라벨/메시지 항목은 위치(시트.컬럼·메타 원천)와 [AS-IS]/[TO-BE 사용]/[같은 문구 코드] 병기 필수 · 설명 문장은 검사 대상별(돋보기≠순서).
- 근거 등급 '기계' FAIL 은 같은 화면 2회 실행에서 재현(`재측정 동일`)된 것만 조치 필요에 올리고, 1회뿐이면 판정필요.

### P7. 놓친 결함 쪽(오류인데 못 잡음)
- Division 별 조회조건 후보(Operation group 등)를 AS-IS 원천(SetOperationGroupByDivision 분기)과 대조하는 검사가 B4 에서 '자동 대조 불가' 로 NA 처리됨 → Division 분기 SQL 을 실행해 후보 집합을 직접 대조(popup_data_check 방식)하도록 확장.
- 필수 조건 자동 채움(T59)이 'Ver. ALL 인데 선택 요구' 같은 실결함을 우회해 PASS 로 만들 수 있음 → 자동 채움이 일어난 사실을 별도 행(판정필요)으로 남긴다.

## 3. 오늘 반영한 것 / 남은 것
- 반영: T82~T102 검사기 수정(자체시험 통과 · 스펙 컴파일 통과) · 사용자 판정 등록 · SCP0084 v9 / SCP0037 v5 / SCP0016 v6 재생성.
- 남은 것: 수정된 E2E 검사기의 재측정은 다음 CheckList 실행에서 이뤄짐(이번엔 판정·문서만 재생성) · P1~P7 은 제안 단계(미구현).
- 주의(미측정): FE 공용 axios 가 HTTP 500 을 성공 경로로 흘릴 가능성(T93 부수) — 로컬에서 저장 SP 예외를 내어 화면 문구를 확인해야 함.

## 4. 구현 상태 (2026-11-06 16:3x 반영)
| 제안 | 구현 | 위치 | 확인 |
|---|---|---|---|
| P1 FAIL 2중 조건 게이트 | 스펙 put() mctx 적재 + judge `[측정 전제 미충족]` ERROR 전환 | _verify/_trace/eg_auth/eg_popup.spec.ts · eg_ingest.py · judge.py(PRECOND_ERROR) | 3화면 재판정 PRECOND_ERROR 0(기존 결과엔 mctx 없음 — 다음 실행부터) |
| P2 기대 원천 우선순위 + 공용 계약 | common_contract.csv 9건 + judge CONTRACT 단계(DD 뒤) | tools/Harness/rules/common_contract.csv · judge.py | 재판정 CONTRACT 0(코드 수정분이 먼저 처리) — 재실행 전 옛 원장의 백스톱 |
| P3 골든 회귀 + FAIL 승격 게이트 | checker_regress.py(docs 단계 3번째) · check_maturity.csv 22건 trial · judge TRIAL | checker_regress.py · check_maturity.csv · run_verify.py | 골든 기준 SCP0007·SCP0096 저장 · 재판정 TRIAL SCP0084 3 / SCP0037 6 / SCP0016 40 |
| P4 측정 전제 helper | lib/precond.ts measurable() · EG315·G1·A5 배선 | tools/E2E/lib/precond.ts | 컴파일 93 tests · 실측은 다음 실행 |
| P5 판정 일반화 제안 | judge SIMILAR_VERDICT note → 설명 '★ 전 화면 제외 여부 결정 요청' | judge.py · make_verify_docs.py | 재판정으로 확인(아래 기록) |
| P6 조치 목록 품질 | 재현 2회/1회 표식 | make_verify_docs.py | SCP0016 v9 |
| P7 놓친 결함 | B4 AS-IS 전용 후보 판정필요 · 자동 채움 원장 행 | judge.py · ledger.py · _verify.spec.ts | SCP0016 Operation group 'E' → 판정필요 V-72ef7746 |
- 재판정 결과(16:30~16:34): SCP0084 조치 2(SC1 PI 대기·EN 라벨) · SCP0037 조치 3(LT_DAY · MSG00006 · **SC1 Excel 순서: 화면 Operation→Div ↔ Excel Div→Operation**) · SCP0016 조치 3(Ver 4·16 · **SC1 Excel 순서: Ver./Period/Bucket 위치**) — SC1 2건은 오늘 바꾼 Excel 기준에서 새로 나온 것.
- 다음 CheckList 실행에서 확인할 것: mctx 게이트·precond·재측정 결과(T91~T102 수정분).
