# 분류 지침 — 원천 행(GAP·PI·자체결함·SSP45) → 검출 규칙 분류 (defects_classified 확장)

> 2026-10-30 2단계. 1단계 산출 `Doc/verify/sources/*.csv` 의 행을 **한 행씩 읽고** 검출 규칙·대상·기대·상태로 분류한다.
> 자동 키워드 분류 금지(anti-simplification · `defects_import.py` 정책). 읽지 않은 행을 추정으로 채우지 않는다. 행 수 = 입력 행 수(누락 0).
> 출력: `Doc/verify/sources/_classified/<batch>.csv` (UTF-8 BOM · 아래 열 순서 그대로) → `validate_classified.py` 통과 후 `defects_classified.csv` 에 병합된다.

## 1. 입력
- 갭분석/PI확인요청/자체결함확인: `Doc/verify/sources/gap_analysis_20260928.csv` (열: row_id, src_sheet, src_row, 번호, 화면 코드, 화면 이름, 조치 담당, 구분, 항목 번호, 대상 기능, 사업부 · 대상, 업무 현상, AS-IS, TO-BE, 근거, 화면 확인, 처리 상태, 담당자, 수정 일자, 처리 내역, 반영 내역, 확인사항, 테스트, 요청 일자, 세부 구분 …). 같은 내용의 읽기용 MD: `gap_analysis_20260928.md`.
- DMF0045 검증내역·공통요건: `Doc/verify/sources/scpssp_test_dmf0045.csv` (+ `scpssp_test_dmf0045.md`, 이미지 `_img/ssp45/`).
- 검출 규칙 카탈로그: `tools/Harness/verify/detect_rules.csv` (rule_id, family, name, oracle, method, expected_source, how). **2단계 신규 규칙**(카탈로그에 추가 예정 · 지금부터 사용 가능):
  - `G9` G 텍스트 조회조건 콤마 다중값 입력 조회(O1+O2 · E2E) — `a,b` 입력 시 두 값 모두 조회·결과가 그 값들만
  - `E7` E 팝업 입력 컬럼 Key-in 값 검증(O1+O2 · E2E) — 팝업으로 고르는 셀에 직접 입력한 잘못된 값은 되돌리거나 검증 메시지
  - 기존 `G8` 텍스트 조건 대소문자 무시(impl 예정)
- 기존 분류 예(양식 참고): `Doc/verify/defects_classified.csv` 처음 20행.
- 화면 코드 → menu_id: 화면 코드 그대로(`DMF0043_01` 포함). `공통` → `COMMON`. 오타 `DMF00005` → `DMF0005`. 화면 코드가 비고 화면 이름도 없는 PI 행(번호만 있는 빈 행) → menu_id 공란.

## 2. 출력 열(순서 고정)
`src,no,menu_id,family,rule_ids,oracle,method,target,condition,expected,general_rule,general_rule_text,detectable,undetectable_reason,note,proposed_new,status,generalize,src_file,src_sheet,src_row,gap_item,evidence_ref,human_check,classified_by,classified_at,target_tokens,asis,tobe,reason`

| 열 | 채우는 법 |
|---|---|
| src, no | row_id 를 첫 `-` 에서 나눔: `GAP-12`→GAP/12 · `GAPPI-1_r5`→GAPPI/1_r5 · `GAPSELF-3`→GAPSELF/3 · `SSP45-5`→SSP45/5 · `SSP45REQ-7`→SSP45REQ/7 |
| menu_id | §1 규칙. 공통요건(SSP45REQ)은 `COMMON` |
| family | rule_ids 의 가족 문자(;) 예 `G;H` |
| rule_ids | 카탈로그 rule_id 1개 이상(;). 행의 **업무 현상·AS-IS·TO-BE·테스트** 를 읽고 그 오류를 화면에서 잡아낼 규칙을 고른다. 없으면 `NEW-<가족><짧은영문>` 하나를 쓰고 proposed_new 에 정의를 적는다(남발 금지 — 기존 규칙으로 표현 가능하면 기존 규칙) |
| oracle | O1(AS-IS 동작과 비교) · O2(확정 요구·공통 규칙) · O3(DB 반영·실행 결과) 를 `;` 로 |
| method | E2E · META · STATIC · DB 조합(`E2E+DB` 등) — 카탈로그 method 참고 |
| target | **라틴 식별자(컬럼 binding·라벨·버튼·콤보 이름·SP 이름) 1개 이상 포함**(상속 매처가 영문 토큰만 봄). 예 `조회조건 Sales Site 콤보(SALES_SITE_ID)` · `그리드 Measure 컬럼 MKT FCST[R+P] 빈 줄` |
| condition | 사업부·대상 + 테스트 절차 요지(계정·Div·조작) |
| expected | **TO-BE 기대 동작**(TO-BE 열·반영 내역 기준 · 설계 결정이면 TO-BE 의 결정된 동작). 300자 안 |
| general_rule / general_rule_text | 이 현상이 다른 화면에도 같은 형태로 생길 수 있는 **UI 공통 규칙**이면 Y + 한 문장 규칙. 화면 고유 업무면 N |
| detectable / undetectable_reason | 화면(E2E)·메타·DB 로 기계가 확인할 수 있으면 Y. DB 내부 배치·문서·업무 결정만이면 N + 이유 |
| note | 분류 근거 1~2문장(어느 열의 어떤 문구로 판단했는지) |
| proposed_new | NEW 규칙 정의(없으면 공란) |
| status | `DEFECT`(완료·품질반영·수정완료·재수정완료·수정완료(재확인) 등 **고쳐진 결함 → 재발 검출**) · `DESIGN`(처리 상태 `제외`, 또는 구분 업무 확인/동작 변경에서 TO-BE 가 의도적으로 AS-IS 와 다르게 확정된 것) · `OPEN`(확인필요·수정필요·재수정중 등 미결) · `REQ`(공통요건 25행 — 확정 규칙 후보) · `INFO`(번호만 있는 빈 행 · 집계·메모) |
| generalize | 이 행을 다른 화면 검증에도 GENERAL 행으로 넣을지. **UI 공통 현상(조치 담당 UI·공통)만 Y** · 업무/DB/화면 고유는 N. 기본 N |
| src_file, src_sheet, src_row | 원천 CSV 값 그대로 |
| gap_item | 갭분석 `항목 번호`(F-02 등) · 없으면 공란 |
| evidence_ref | 원천 CSV `증빙_이미지` 값(없으면 공란) |
| human_check | DESIGN 이고 처리 상태 `제외` → `확인(원천 제외)` · 그 밖 DESIGN → `보류` · 나머지 공란 |
| classified_by, classified_at | `claude(batch <이름>)` · `2026-10-30` |
| target_tokens | 판정 행과 대조할 **영문 토큰**(;) — 컬럼 binding·라벨·버튼 이름(대소문자 무관). 화면 전체 성격이면 `*` |
| asis, tobe, reason | DESIGN 행만: AS-IS 동작 · TO-BE 결정 동작 · 근거(처리 내역·반영 내역 문구 요약). 그 밖 공란 |

## 3. 판단 규칙
- 처리 상태 우선: `제외` → DESIGN. `완료`·`품질반영`·`수정완료`·`재수정완료`(재확인 포함) → DEFECT. `확인필요`·`수정필요`·`재수정중` → OPEN. 공란이면 내용으로 판단(PI/자체결함 시트는 처리 상태 열이 있음).
- 구분 `업무 확인`·`동작 변경`인데 처리 상태가 완료류 → 구현된 변경 = DEFECT(TO-BE 기대 = 반영 내역). 처리 상태가 제외 → DESIGN.
- `테스트` 열에 ①계정 ②화면 ③조작 절차가 있으면 condition 에 요지를 넣는다(검사기 재현 재료).
- 조치 담당 `DB` 만이고 화면에서 보이는 효과가 서술돼 있으면 detectable Y(화면 결과로 확인) · 효과 서술이 없으면 N(이유: DB 내부).
- 한 행에 여러 오류(①②③)가 있으면 rule_ids 를 여러 개 — 요구 대조 단위 = 하위 문구.
- SSP45REQ(공통요건 25행): status REQ · menu_id COMMON · generalize Y · rule_ids = 요건을 구현하는 규칙 · expected = 요건 문장 · general_rule Y + 규칙 문장. 아래 대응을 기준으로 하되 행을 읽고 확정: 1→C1;C4;A4 · 2→A5 · 3→B4 · 4→C1 · 5→G1;B6 · 6→G5 · 7→G8 · 8→G2;G9 · 9→K1 · 10→K1 · 11→G3 · 12→G3 · 13→G8;M3 · 14→G9;M3 · 15→D1 · 16→D4;D6 · 17→F5 · 18→D5 · 19→B4 · 20→F1;F2;F6 · 21→M4;K6 · 22→E5 · 23→E7 · 24→E3 · 25→A5;K2;E3.
- 빈 행(번호만 · PI확인요청 51~65 등) → status INFO · rule_ids 공란 · note `빈 행(번호만)` · detectable N.

## 4. 금지
- 행을 건너뛰거나 묶어서 한 줄로 처리하지 않는다. 입력 행 수 = 출력 행 수.
- 원천 문구를 바꾸어 인용하지 않는다(요약은 note/condition 에서만).
- 규칙 ID 를 지어내지 않는다(카탈로그 + G9/E7 + NEW-… 만).
