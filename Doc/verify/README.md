# 화면 정합검증 가이드 (AS-IS vs TO-BE)

> 2026-10-23 신설 · Vibe_Manager 기능 「🔎 화면 정합검증」 · 실행기 `tools/Harness/verify/run_verify.py`

## 1. 목적

사람이 단위테스트에서 찾은 오류를 시스템이 먼저 찾아내는 것이 목적입니다. 개발된 화면을 AS-IS 와 비교해 결함을 행 단위로 도출하고, 고칠 대상을 Excel 로 정리한 뒤, 사용자가 정한 범위 안에서만 보완합니다.

- 기준 정답지(수용 기준)는 사람이 수행한 단위테스트 결함 원장 **310건**입니다.
  - 공통·DM 285건: `C:\TRANFILE\RECEIVE\최종 단위테스트 결과 점검 (zio 관리) _ 202600826.xlsx` 의 `수정사항` 시트
  - SCP·SSP 25건: `SCP & SSP 단위테스트 결과 v1.0.xlsx` 의 `확인사항` 시트
- 2026-10-30 추가 원천(사용자 지시 "3개 파일에 나타나는 내역을 누락 없이 CheckList 에") — `python tools/Harness/verify/sources_extract.py` 가 모든 시트·셀·이미지를 `Doc/verify/sources/` 에 MD+CSV 로 뽑고 `_extract_report.md` 로 누락 0 을 증명한다:
  - DM 단위테스트 원문(23열 전부 · 증빙 시트 168 · 이미지 450): `sources/dm_unit_test_20260826.md` (행 ID `DM-<No.>`)
  - AS-IS vs TO-BE 화면 기능 갭 분석 종합(2026-09-28): `sources/gap_analysis_20260928.md` — 갭분석 506(행 ID `GAP-<번호>`) · PI확인요청 66(`GAPPI-<번호>_r<행>`) · 자체결함확인 42(`GAPSELF-<번호>`). 처리 상태 `제외` = TO-BE 설계 결정(FAIL 아닌 NA 근거), 완료·품질반영 = 재발 검출 규칙
  - SCP&SSP 단위테스트 DMF0045: `sources/scpssp_test_dmf0045.md` — 공통요건 25(`SSP45REQ-<No>` · 전 화면 공통 요건 → 확정 규칙) · 검증내역 12(`SSP45-<No.>`)
- 같은 결함이 다시 생기지 않게 하는 것도 목적입니다. 결함 원장의 각 행은 **검출 규칙**에 대응되고, 전 화면의 검증 항목으로 자동 포함됩니다.

## 2. 오류의 정의 — 세 가지 정답

검증 행 하나는 아래 정답 중 하나 이상을 가집니다. 정답이 없는 행은 만들지 않습니다. 정답이 애매하면 `판정필요` 로 둡니다.

| 정답 | 무엇과 다르면 오류인가 | 원천 |
|---|---|---|
| **O1 AS-IS 동작** | 같은 조건·같은 조작에서 AS-IS 의 건수·값·콤보 후보·잠금·메시지·연쇄 결과 | AS-IS 소스 사실(`Doc/asisfacts/screens/<ID>/`), 프레임워크 원문(SpreadInfo.cs 등) |
| **O2 확정 규칙** | 디자인·공통 표준·다국어·**고객 확정 요구** (AS-IS 와 달라도 이것이 정답) | `tools/Harness/rules/confirmed_requirements.csv`, 조회조건 기준표, check.js 게이트 |
| **O3 기능 무결성** | 오류·무반응·**허위 성공**(성공 메시지인데 미반영 등) | HTTP·결과 커서·콘솔 오류, 저장 후 DB |

## 3. 산출물 (화면마다)

| 산출물 | 위치 | 용도 |
|---|---|---|
| **화면 정합검증서** | `Doc/화면분석서/<ID>_<화면명>_정합검증서_v<N>.xlsx` | 검증 결과 전체 |
| **보완대상목록** | `Doc/화면분석서/<ID>_<화면명>_보완대상_v<N>.xlsx` | **보완 적용 전에 확인하는 목록** |
| 검증 항목 원장 | `Doc/verify/<ID>/verify_ledger.csv` | 판정 단일 원천(행 = 대상 × 조건 × 정답) |
| 보완 목록(기계용) | `Doc/verify/<ID>/fixlist.csv` | 🛠️·🧯·🩹 보완 프롬프트가 읽는 사본 |
| E2E 결과 | `Doc/verify/<ID>/e2e_results.json`, `e2e/` | 동적 판정 증거 |
| **테스트결과서**(2026-10-30) | `Doc/테스트결과서/<ID>_<화면명>_테스트결과서_v<N>.xlsx` | 사용자가 읽는 결과서 — CheckList 행을 영역 → 검사 규칙 → 항목으로 묶고 테스트 내역·기대·실제·겪는 일·캡처를 사람 말로. 새로 측정하지 않음(`make_test_report.py`, 메뉴 📋) |

버전 번호는 실행할 때마다 +1 되고, 이전 파일을 덮어쓰지 않습니다.

**화면 정합검증서 시트 구성**
- 요약
- 1 디자인·다국어 / 2 AS-IS 로직 / 3 SMOKE / 4 CRUD / 5 권한별 CRUD
- 조치 필요 / 판정 필요
- **결함 원장 대조**: 사람 결함 ↔ 시스템 결과
- 미검증: 사유 포함, **PASS 로 세지 않음**
- 검출 규칙

**보완대상목록 시트 구성**
- 요약: 계층별 건수·적용 예정
- 보완 대상 전체
- DB 적용분 / FE 적용분 / 공통 컴포넌트 가이드 / 사람판정

## 4. 실행 방법 (Vibe_Manager)

| 메뉴 | 동작 |
|---|---|
| UI 분석·생성·보완 › **🔎 화면 정합검증** | 아래 5단계를 한 번에 실행합니다(S8.verify). FE 5173·BE 8080 기동이 필요합니다 |
| 단계 S8.verifyStatic | 서버 없이 정적·메타 판정만 합니다. E2E 행은 미검증으로 남습니다 |
| 환경설정 › **🧭 보완 범위 (repairScope)** | `DB_ONLY` 또는 `DB_FE` 로 설정합니다(S8.scope) |
| 단계 S8.defects | 결함 원장 xlsx 를 다시 반입합니다(원장 갱신 시) |

명령행: `python tools/Harness/verify/run_verify.py <ID> [--skip-e2e] [--scope DB_ONLY|DB_FE]`

**5단계 순서** — 실패한 단계에서 멈추고, 미실행을 완료로 보고하지 않습니다.
1. **AS-IS 사실 보강**
   - `facts_cellrules.py`: 셀 입력 규칙(숫자 소수자리·min·max, 날짜)
   - `facts_lockrules.py`: 잠금 범위를 컬럼 목록으로 전개하고, 신규행·기존행별 편집 기대표를 만듭니다
2. **검증 항목 원장** — `ledger.py`. 행의 출처는 아래 6가지입니다.
   - 화면 공통 규칙
   - 조회조건: 기준표(SCP·SSP). DM 은 AS-IS 조회조건 패널을 씁니다
   - 그리드 컬럼
   - AS-IS 액션: 잠금·셀 콤보·연쇄·메시지·팝업·검증·색, 버튼 전제조건
   - 결함 원장
   - 확정 규칙
3. **동적 판정** — `Doc/e2e/specs/_verify.spec.ts`(@verify). 원장의 E2E 행을 실행하고, **저장은 하지 않습니다**
4. **판정** — `judge.py`. E2E 결과 반입, 다국어 등록(DB 조회), 조회조건 명칭·순서, 결함 원장 행 상속
5. **문서** — `make_verify_docs.py`. 정합검증서와 보완대상목록을 만듭니다

## 5. 보완 절차 — 목록 확인 → 범위 설정 → 적용

1. 🔎 화면 정합검증을 실행해 **보완대상목록 xlsx 를 먼저 확인**합니다. 바로 고치지 않습니다.
2. 🧭 보완 범위를 정합니다.
   - `DB_ONLY` (기본): DB 메타·DB 객체(PKG/SP)만 적용합니다. 화면 FE 는 가이드(파일:라인·변경 전/후·검증법)만 남깁니다.
   - `DB_FE`: 화면 FE(`features/**/pages/<화면>`)까지 적용합니다.
   - 공통 컴포넌트(`@shared`·`@foundation`)는 **어느 설정에서도 직접 수정하지 않습니다**. 가이드와 영향 화면만 남깁니다.
3. 🛠️ 기존 화면 보완 / 🧯 자동 보완 / 🩹 E2E 오류 보완을 실행합니다. 세 프롬프트 모두 `fixlist.csv` 를 보완 기준으로 읽고, 실행 시점의 `repairScope` 를 따릅니다.
   - 🛠️ 는 보완 요청을 비워 두면 fixlist 를 요청으로 삼습니다.
   - 🧯·🩹 의 "FE 수정 승인"은 `DB_FE` 일 때만 유효합니다.
4. 보완이 끝나면 `run_verify.py` 로 재판정합니다. 정합검증서와 보완대상목록의 새 버전이 만들어집니다. 처리 결과는 fixlist 의 status·change 열에 남습니다.

**보완 계층 판정 규칙** (`make_verify_docs.py` `decide_layer`, 근거는 목록의 '계층 판단 근거' 열)
- DB 메타: 라벨·메시지 미등록, 컬럼 표시·편집 메타(TO-BE `INPUT_TP_CD` 가 AS-IS 기대와 반대일 때), 기준정보, 콤보 원천 SQL
- DB 객체: 조회·저장 SP 결과(건수·저장 반영·업무 검증)
- 화면 FE: 셀 편집 제어·입력 검증·연쇄·버튼 전제조건·팝업 인자
- 공통 컴포넌트: Sort/Filter·컬럼 셋팅·Excel·메시지 표준 등
- 사람판정: 기대가 조건부이거나 정답 확정이 필요한 행

## 6. 검출 규칙 카탈로그

- 위치: `tools/Harness/verify/detect_rules.csv`
- 규모: **81개 규칙, 유형 A~N**. 310건을 행마다 판독해 만들었고, 신규 제안 44건은 의미가 겹치는 것을 합쳐 25개로 정리했습니다.

| 유형 | 내용 |
|---|---|
| A | 조회 결과 정합(건수·표시값·합계·정렬·동적 컬럼) |
| B | 콤보 후보(빈 행·중복·정렬·AS-IS 원천 집합·허용 목록·캐시 갱신) |
| C | Cascade·연쇄 채움·그리드 간 연동 |
| D | 편집 가능성(컬럼·Measure×기간·행 조건·신규행 전제·에디터 유형) |
| E | 입력 검증(숫자·날짜·필수·업무·후보 외 값) |
| F | 저장 정합(DB 반영·1회 저장·붙여넣기·SQL 오류·CRUD 상태·값 보존·연계 테이블) |
| G | 조회조건 동작(결과 반영·ALL·다중·저장 복원·표시·팝업 연동·기본값) |
| H | 표시·디자인(정렬·색·병합·레이아웃·라벨·팝업 표준·Excel·포맷·폭·메시지 표준) |
| I | 다국어(등록·런타임 언어·데이터 언어·중복 채번) |
| J | 권한(Division·버튼·편집 구간·메뉴 노출) |
| K | 공통 기능(Sort·Filter·셋팅·그리드 조작·버튼 구성) |
| L | 성능(응답·재렌더) |
| M | 특수 기능(Excel Upload·버전·팝업 내부 기능) |
| N | 기준 데이터 정합 |

**결함 원장 분류 결과**
- `Doc/verify/defects_classified.csv`: 310건 전부가 규칙 1개 이상에 대응됩니다. 자동 검출 불가로 판정된 건은 0건입니다.
- "개선·전체 UI 적용" 67건은 확정 규칙 69건(`confirmed_requirements.csv`, 충돌 4건 기록 포함)으로 등록돼 전 화면에 적용됩니다.

## 7. 현재 자동화 범위와 한계 (2026-10-23 기준 — 정직 보고)

- **자동 판정이 구현된 규칙은 81개 중 14개입니다.**
  - 구현됨: A5, B1, B2, C3, D1, D4, E1, E2, G2, G4, G5, H5, I1, I2
- 결함 원장 310건 기준 자동 판정 범위:

  | 범위 | 건수 |
  |---|---|
  | 해당 규칙이 전부 자동 판정됨 | 39 |
  | 일부만 자동 판정됨 | 79 |
  | 아직 자동 판정 안 됨 | 192 |

- 미구현 규칙은 결함 빈도순으로 B4(32)·F1(30)·M3(26)·E4(22)·K2(19)·F4(16)·N1(15)·M1(14)·H6(14)·C2(14) 입니다. 정합검증서의 **미검증 시트**에 그대로 남고, PASS 로 세지 않습니다.
- B4·A1(AS-IS 결과 대조)에는 AS-IS DB 동시 실행(`tools/DbConn/golden.py`)과 인자 매핑(`param_map`)이 필요합니다. 아직 구현하지 않았습니다.
- 검증은 **현재 작업 트리(미커밋 포함)** 의 화면을 대상으로 합니다. 다른 작업자가 같은 화면을 고치는 중이면 결과가 그 상태를 반영합니다.

## 8. 시범 결과 (2026-10-23)

**SCP0007 BOD — E2E 포함**
- 원장 475행: PASS 144 · FAIL 8 · 판정필요 10 · 미검증 313
- 실측 FAIL(진짜 결함):
  - 조회 전 Insert 로 행이 추가됨 (AS-IS 무동작, cs:370-376·540) — 고객 #22
  - 날짜에 2026-10-33 입력이 허용됨 — 고객 #23
  - PRIORITY 100 입력 허용 (AS-IS 최대 99, cs:333)
  - To Site 셀 후보 중복(EG00×6 등)
- 고객 #18(Division 잠금)·#16·#24(다국어)·#25(정수)·#17(팝업 인자)·#20(Select ALL)은 PASS 입니다. 같은 날 다른 작업으로 이미 보완된 상태를 그대로 판정한 결과입니다.
- 실행 중 도구 오탐 6건을 찾아 고쳤습니다.
  - ROUTE_ID 팝업 입력 컬럼
  - 연쇄 원천 분기
  - 팝업 인자 코드 환산
  - 가상 스크롤 목록 수집(3건)

**DMF0082 Fcst MGMT — E2E 포함**
- 원장 772행: PASS 36 · FAIL 1 · 판정필요 103 · 해당없음 84 · 미검증 548
- FAIL: 조회 전 Insert 로 행이 추가됨. AS-IS 는 `isCurVersion` 을 조회에서만 세팅하므로 무동작입니다(DM-71 과 같은 유형).
- 판정필요로 넘어간 것:
  - 기존행 편집: AS-IS 가 메타 루프로 변수 컬럼(`LockColumn(iCol, iCol)`)을 잠가서 정적으로 확정할 수 없습니다.
  - 표시 여부 3건(MEASURE·VERSION_NO·MDM_PROJECT_NAME): 확정 규칙(DM-47)과 겹칩니다.

**DMF0005 Sales Site Project Model — E2E 포함**
- 원장 1,599행: PASS 53 · FAIL 0 · 판정필요 261 · 해당없음 145 · 미검증 1,140
- AS-IS 잠금이 대부분 행 조건부(COND)라서 판정필요가 많습니다.
- 이 화면 결함 원장 25건은 대부분 아직 자동화되지 않은 규칙(B4·F1·M3 등)에 속합니다.

**시범 3화면에서 고친 범용성·오탐 결함**
- 메인 클래스 오인
- 잔존 변형 시트
- DM 조회조건 원천
- 근거 없는 '편집 가능' 추정 → 미확정 처리
- 그리드에 없는 컬럼 → 해당없음
- 원천 입력 실패 → 판정필요
- 최종 실행에서 도구 오류(ERROR)는 세 화면 모두 0건입니다.

## 9. 단위테스트 문서와의 관계

`/단위테스트`(`.claude/commands/단위테스트.md`) 가이드를 같은 기준으로 보강했습니다.
- 세 가지 정답 원칙
- 요소 × 결함 유형 의무 TC(§4-3)
- 결함 원장 재현 의무
- 확정 규칙·유형 하한 대사

단위테스트 TC 의 비고에는 검출 규칙 ID 와 결함 원장 번호를 남깁니다.

## 10. 파일 목록

| 파일 | 역할 |
|---|---|
| `tools/Harness/verify/defects_import.py` | 결함 원장 xlsx → `defects_baseline.csv` |
| `tools/Harness/verify/sources_extract.py` | 원천 xlsx 3개(DM 단위테스트 · GAP 분석 종합 · SCP&SSP DMF0045) → `Doc/verify/sources/*.md`·`*.csv`·`_img/`·`_extract_report.md`(누락 0 증명) |
| `tools/Harness/verify/defects_sources_merge.py` · `validate_classified.py` | 원천 분류(`Doc/verify/sources/_classified/*.csv` · 지침 `sources/_classify_brief.md`) 형식 검사 → `defects_baseline.csv`(src GAP·GAPPI·GAPSELF·SSP45·SSP45REQ) · `defects_classified.csv` 확장 열(status·generalize·target_tokens…) · `tools/Harness/rules/design_decisions.csv` |
| `tools/Harness/rules/design_decisions.csv` | TO-BE 설계 결정(GAP 제외 등) — judge 가 같은 화면·규칙·대상이면 FAIL→NA '설계 결정(GAP F-xx)'(T7 방지) · 적용 내역 `Doc/verify/<ID>/design_decisions_applied.csv` · CheckList '설계 결정(GAP)' 시트 |
| `tools/Harness/verify/detect_rules.csv` | 검출 규칙 카탈로그 |
| `Doc/verify/defects_classified.csv` | 결함 310건 × 규칙·정답·기대 |
| `tools/Harness/rules/confirmed_requirements.csv` | 확정 규칙(O2) |
| `tools/Harness/verify/facts_cellrules.py` · `facts_lockrules.py` | AS-IS 사실 보강 |
| `tools/Harness/verify/ledger.py` · `judge.py` · `make_verify_docs.py` · `run_verify.py` · `set_scope.py` | 원장·판정·문서·실행·범위 설정 |
| `tools/Harness/verify/make_test_report.py` | 테스트결과서 xlsx(요약·테스트결과(그룹)·실패 상세(캡처)·실행 테스트·화면 캡처·용어 설명) — 입력 = 직전 run_verify 산출물 + `e2e/shots/index_*.json`(FAIL 캡처, `_verify/_trace.spec afterEach`) + 스모크 캡처 · `run_verify --resume-docs` 와 같이 재측정 없음 |
| `tools/E2E/lib/probe.ts` · `Doc/e2e/specs/_verify.spec.ts` | 런타임 프로브·원장 구동 E2E (@verify — 기존 4단계 체인과 분리) |
| `tools/Harness/harness.json` `repairScope` | 보완 범위 단일 원천 |

## 11. 대조표 전 행 검증 커버리지 · DB 접근(시노님·권한) — 2026-10-26 추가

> 사용자 지시: "AS-IS 의 모든 기능을 파싱·분석해 TO-BE 로 구현하고, 대조표를 만들어 제대로 만들어졌는지 확인·테스트한다. 대조표에 있는데 오류 여부를 확인하지 않으면 제대로 생성됐는지 확인할 방법이 없다. 누락되는 검증 없이." · "시노님이 없어서 오류가 발생하는 것도 오류로 검출." 목적은 오류 수정이 아니라 **전체 검증의 빈틈 0**.

이 정합검증(원장)은 검출 규칙·결함 원장 기준으로 행을 만든다. 그래서 **대조표의 어떤 행이 검증되지 않았는지**는 드러나지 않았다. 이를 잇는 단계를 추가했다(`run_verify.py` 판정 뒤·문서 앞).

| 단계 | 파일 | 하는 일 |
|---|---|---|
| 시노님·권한 정적 검사 | `syn_check.py <ID>` (`--all`) | BE 계정 **SCMP_APP** 이 부르는 이름을 실제로 해석한다. ① PROC_M 배선 PKG/SP(BE 는 스키마 없이 `{call PKG.P}`) ② 화면 콤보 SQL(FE 소스 콤보 ID + `SHEET_COLUMNS.CELL_COMBO_DATA_TYPE`)의 FROM/JOIN·함수 객체. 판정 = 자기 객체 → SCMP_APP 시노님 → PUBLIC 시노님 → 대상 존재 → 권한(직접·PUBLIC·**롤 경유**) → VALID. 결과 `Doc/verify/<ID>/syn_check.csv`(SYN_MISSING·PRIV_MISSING·TARGET_MISSING·INVALID · 호출 시 예상 오류 코드). 고치지 않는다 |
| 대조표 ↔ 검증 추적 | `mapping_trace.py <ID> --to-ledger` | 대조표 2종의 **모든 행**에 필요한 검증 층을 정하고, 증거(원장·E2E 요약·하네스 게이트·시노님 검사)를 붙여 행 판정(FAIL · 검증완료 · 미검증(사유) · 미구현 · 해당없음). 검증 항목이 없는 (행 × 층)은 원장에 `source=MAPPING` 행(NOT_RUN · R6)으로 편입 → **정합검증서 미검증 시트에 대조표 행 단위로 남는다**. 결과 `Doc/verify/<ID>/mapping_trace.md/.csv/_summary.json` |
| 전 화면 집계 | `trace_all.py [--no-syn]` | FE 페이지가 있는 전 화면을 추적해 `Doc/verify/_trace_all.md`(화면별 대조표 행·검증완료·FAIL·미검증(R6)·미구현·FE 대조표 유무·시노님 문제) |
| 런타임 DB 오류 | `tools/E2E/fixtures/test.ts` · `lib/nscm.ts beLogErrors` | 모든 E2E 스펙(smoke·crud·auth·authcrud·verify) 구간의 BE 로그(`nscm-be/logs/nscm.log`) ORA-/PLS- 를 모아 어노테이션 `dberr` · **이 화면 요청이 5xx 를 받았으면 실패로 귀속**(같은 BE 의 다른 요청 오류는 기록만) |

**검증 층**: 정적 디자인 · 동적 생성·조회 · 콤보 후보 · Cascade · 편집·검증 · CRUD · 팝업 · 공통 기능 · 권한 · DB 실행·접근. 행 종류(조회조건·그리드·AS-IS 액션)와 증거 영역이 맞을 때만 연결한다(과대 귀속 방지). AS-IS 액션의 내부 문장(LOCAL·EXPR·BRANCH 등)은 진입점(이벤트·버튼 메서드) 행에 포함해 그 동작으로 검증한다.

**미검증 사유**: R6 이 행을 검증하는 항목이 없음(검사기 연결 필요) · R6k 대조표 서술에 식별자(컨트롤·SP·컬럼명)가 없음(대조표 보강) · NOT_RUN 검사기는 있으나 미실행 · REVIEW 판정필요 · WARN 확인 필요.

**완료 게이트**: 하네스 `check.js` **VC1**(대조표 FAIL·미검증·추적 없음·FE 대조표 없음) · **VC2**(시노님·권한) — `--final` BLOCK · `screen-completion-gate` **G11** · 대사표(recon) 열 `verify_cov`·`syn_issue`(신뢰도 반영) · E2E `_summary.md` 열 'BE DB 오류'.

**최초 전수 결과(2026-10-26, 기존 증거만)**: 130화면 · 대조표 30,344행 · 검증완료 479 · FAIL 111 · 미검증 28,232(대부분 R6) · FE 대조표 없는 화면 26 · 시노님/권한 문제 화면 29(73행). → 검증 체계의 빈틈이 정량화됐다. 다음 확장은 R6 가 많은 층부터 검사기를 연결한다(`_trace_all.md` 의 층별 집계 기준).

### 11.1 v2 — 대조표 전 행 = 검증 대상 · 검증 엔진 · 구현 엔진 (2026-10-26 추가)

> 사용자 지시: "미검증 28,170 은 검증할 필요가 없는 항목인가? 아니라면 어떻게 검증할지를 체계적으로 검증 항목으로 추가해야" · "대조표에 있다면 정적이던 동적이던 무엇인가를 해야 한다는 의미 → 검증 대상" · "검사기가 없다면 구현이 안 되어 있을 수도 있으므로 구현을 위한 엔진과 검증 엔진이 추가되어야".
> → **'검증 불필요' 분류는 없다.** 제외·해당없음 행도 사유·근거 검사(X-REASON) 대상이다.

| 구성 | 파일 | 하는 일 |
|---|---|---|
| 검사 카탈로그 | `mapping_checks.csv` | 행 유형 → 검사 ID. 유형 = 대조표 상태(제외/해당없음 → X-REASON · 미구현 → X-NOTIMPL) · FE 행 패턴(조회조건 컨트롤·그리드·이벤트·셀 유형·엔드포인트·버튼·메시지 …) · AS-IS 진입점 이름(Form_Load·FindData·SaveData·*Changed·*Popup …) · AS-IS 문장 종류(ENDPOINT·GRID_LOCK·GRID_SET·VALUE_SET·MESSAGE …) |
| 검사 정의 | `mapping_checkdefs.csv` | 검사 ID → 층 · 대상 단위(SCREEN·ELEM·SP·ENTRY·ROW) · **검사기 구현 여부(impl)** · 실행 경로(runner: verify·trace·smoke·crud·auth·meta·static) · 방법 · 검사 방법(how). 검출 규칙(`detect_rules.csv`) 전부 + 추적 전용(X-LOC·X-REASON·X-NOTIMPL·X-REOPEN·X-ROW·DB-SYN·G03-WIRE·K-SA·SC1) |
| 추적 v2 | `mapping_trace.py <ID> [--to-ledger]` | FE 대조표 전 행 + AS-IS 액션 **진입점 + 전 문장**(LOCAL·EXPR·BRANCH 포함) → 검사 → **검사 인스턴스(검사 × 대상)** 로 묶어 판정. 원장 ASIS 행이 그 문장 위치(file.cs:line)에 있으면 그 규칙도 검사로 붙인다. 증거 없음 = **NOT_RUN**(검사기 있음·실행 필요) · **NOPATH**(검사기는 있으나 이 대상 유형을 실행하는 경로 없음 — @verify 는 ledger.py 가 만든 원장 행만 실행) · **TODO**(검사기 미구현) · **BLOCKED**(대조표 미구현 행 — 구현 후 검증). `--to-ledger` = 원장 연결 없는 인스턴스를 `source=TRACE` 행(rule_id = 검사 ID, condition = 검증 엔진 입력 JSON)으로 편입. 정적 검사기 내장: X-LOC(구현 위치 파일:라인 실존) · X-REASON · X-NOTIMPL · H10(브라우저 alert/confirm 직접 호출) |
| 검증 엔진 | `Doc/e2e/specs/_trace.spec.ts` (`@trace`) | TRACE 행(+ASIS D3·E4 행) 중 엔진 구현 검사 실행. **1차**: A10 조회 전 그리드(AS-IS 로드 중 조회 호출 여부로 기대) · K4 버튼 구성(AS-IS 버튼 메서드 ↔ 보이는 버튼 · 대조표 제외 버튼 비교 제외) · X-REOPEN 탭 닫기·재오픈 · G6 조회조건 초기값(AS-IS 로드 문장 리터럴은 콤보 응답 코드→명칭 환산 비교) · C1 상위 조건 변경 → 하위 콤보 재요청·선택 초기화 · C4 조건 변경 → 그리드 초기화/유지 · D6 Insert 위치. **W5(컬럼 대상 연결)**: H5 헤더 ↔ AS-IS 라벨(grid_effective 메인 시트 · TO-BE 메타 라벨과 같으면 명칭 변경 결정 → 판정필요) · A5 컬럼 표시(Division 별 '기본/숨김/코드추가') + 그리드 구성 집합(AS-IS 유효 컬럼 ⊆ TO-BE) · H2 색 · D1 편집(edit_expect Y/N/COND 행 값 계산) · D5 셀 타입(AS-IS SetCellType 문장) · E1 숫자(cell_rules) · D4 신규행 기본값(InsertButton SetValue 리터럴) · C3/C2/C6 연쇄(값 대입 문장의 원천 — 팝업 트리거 원천은 M4 로) · F4 SP 호출 HTTP(진입·조회 경로 밖 SP 는 판정필요). **W4(신규 검사기)**: D3 행 조건부 잠금(lock_rules ROW_COND guard 를 행 값으로 계산 — 지역 변수·플래그 절은 판정필요) · E4 업무 검증 메시지(위반 입력 자동 생성: 빈값·FROM>TO·요일·바이트 초과 → Save, **SAVE 요청은 route 차단**으로 DB 무변경 → TO-BE 메시지(문구 환산) 표시 & 저장 시도 없음 = PASS) · M4 팝업 선택값 반영(트리거 셀 더블클릭 → 팝업 첫 행 선택 → AS-IS SetValue 대상 셀 채움). 팝업 내부 그리드 컬럼(PCOL)은 메인 그리드에서 찾지 않고 M3 시나리오로 넘긴다. 기대를 원문으로 정할 수 없으면 실측만 남기고 판정필요 |
| 구현 엔진 | `impl_engine.py <ID>` | **작업 원장** `work_ledger.md/.csv/_summary.json` — 판정과 별도 '대기열' 을 두지 않는다. **PASS·NA 가 아닌 검사 인스턴스 전부 = 할 일** 한 원장. 유형: W1 기능 구현(X-NOTIMPL FAIL) · W2 구현 위치 확인(X-LOC FAIL) · W3 동작 수정(그 외 FAIL — fixlist FX 연결) · W4 검사기 구현(TODO) · W5 검사기 연결(NOPATH) · W6 검증 실행(NOT_RUN — 실행 경로별 방법) · W7 기대값 확정(REVIEW·WARN) · W8 구현 후 검증(BLOCKED — 선행 W1) · W9 도구 오류. W4·W5 는 TO-BE 흔적(FE 소스·SHEET_COLUMNS·문구 환산 MSG·PROC_M)을 함께 적어 **구현 의심**을 표시. 담당 층 = DB(적용 가능) / FE(repairScope=DB_ONLY 면 가이드만) / 대조표 / 하네스 / E2E / 사람. 0건이어야 완료(VC1·G11). 코드는 고치지 않는다 |

### 11.2 결과 정렬(A6) — AS-IS 정렬 방식(SQL vs 그리드) 그대로 (2026-10-26 사용자 지시)

> "조회 시 ORDER BY 적용 부분도 대조표에 있는지" → 없었다(정렬은 화면 코드가 아니라 SP 안에 있어 화면 파싱 대조표에 잡히지 않음). "AS-IS 에서 정렬을 어떻게 수행하는지(SQL/그리드) 확인해서 동일하게 SORT 적용".

| 단계 | 파일 | 하는 일 |
|---|---|---|
| 정렬 사실 | `facts_sortrules.py <AS-IS ID>` / `--all` | 화면이 부르는 SP 의 AS-IS 원문(`Doc/asisfacts/db/modules`)에서 ORDER BY(정적·동적 `SET @qry = @qry + 'ORDER BY …'`)를 주석 제외로 추출 — 동적 문장은 감싸는 IF/ELSE IF 가드(파라미터 분기)를 적음 · 서브쿼리(TOP) 정렬은 depth>0 · 화면 코드 정렬(`.Sort(`·SortRange·AutoSort·DataView.Sort·OrderBy) 도 GRID/CODE 로 → `sort_rules.csv` |
| 원장 | `ledger.py` 1-b | 조회 SP 마다 분기별 `source=SP rule=A6` 행(저장류·서브쿼리 제외) · ORDER BY 없는 SP 는 '임의 정렬 추가 여부' 행 · 코드 정렬은 ASIS A6 행 |
| 정적 대조 | `sort_check.py <ID>` | TO-BE PKG 프로시저 ORDER BY 를 **ALL_SOURCE 에서 새로 읽어**(hook #152) 분기별 유효 키(`CASE WHEN … THEN key END` 는 가드 리터럴로 분기 해석) ↔ AS-IS 키 순서 비교 → `sort_check.csv`(PASS/FAIL/NA/REVIEW) → `judge.py` 가 원장 A6 행에 반입 |
| 실측 | `_trace.spec.ts @trace` A6 | 조회 요청 파라미터로 유효 분기를 고르고 결과 행(최대 2000)이 그 키 순(숫자는 수치 비교·빈값 먼저)으로 정렬돼 있는지 |
| 카탈로그 | `mapping_checks.csv` ENDPOINT_GET·A_FIND → A6 · `mapping_checkdefs.csv` A6 impl=Y runner static·trace | 대조표 조회 SP 행 → A6 인스턴스(SP 단위) |

**SCP0007 실측(2026-10-26 11:20 ZIOUI1)**: AS-IS 는 **SQL 정렬만**(화면 코드 정렬 0건) — `SCP0007_GET_BOD` Required 분기 15키(ROUTE_CNT·TRANSPORT_MODE 포함) / Completed 분기 14키(FROM_YYYYMMDD 포함) · `SCP0005_GET_DISTRIBUTION_ROUTE` 5키. TO-BE `PKG_SCP0007.P_SCP0007_GET_BOD`(LAST_DDL 2026-10-14) 는 이미 `CASE WHEN P_INPUT_STATUS='R'/'C'` 로 동일 키 구현 → PASS 3 · GET_COUNTRY_CITY/ROUTE_CNT/SAVE 는 양쪽 ORDER BY 없음 NA. **PKG 수정 불필요 — 검증 항목만 추가.**

**run_verify 순서(v2)**: facts(+sortrules) → ledger(+A6) → syn_check → sort_check → **syn_check → mapping_trace --to-ledger** → E2E(`_verify @verify` + **`_trace @trace`**) → combo_oracle → cleanup → judge → **mapping_trace(재계산) → impl_engine(작업 원장)** → docs.
**SCP0007 기준(2026-10-26, v2 첫 실행)**: 대조표 1,108행(FE 203 · AS-IS 진입점 49 + 문장 856) → 검사 인스턴스 1,160 — 검증 엔진 실행 결과는 run 로그·`mapping_trace.md` 참조.

### 11.3 W4c/W4d 정밀 판정 엔진 · 판정 보존 (2026-10-26 사용자 지시 "판정필요는 AS-IS/TO-BE 건수 차이 외에는 남기지 않는다")
- `_trace.spec.ts` **W4c**(초기값 룰 G6 · 멀티선택 G1/G2 실측 · D3 사이트타입 잠금 · C2 INCOTERMS_SSP 분기 · C6 · M4/F4/A6 팝업 · H8/H9 · E4 NA) · **W4d**(Insert 기본값=AS-IS SetValue 리터럴/`sYYYYMMDD` · DIVISION_ID dtMyDivision 콤보/단일 Division 자동세팅 · INCOTERMS 조건부 잠금 · 값채움 컬럼 C2/C6 NA(측정) · 숨김 컬럼 H5/E1 NA(측정) · 팝업 prefill/City 검색 버튼 disabled/조회 전용 PCOL · MSG00159·MSG00085 재현 · 화면 규칙 A1/A2/A4/I3/L1/L2/B8/M1/A3/J4/N1). 증거는 항상 실측 문장(`검증엔진 T-…` 금지).
- `judge.py`: E2E 로 판정된 행(`e2e_ids`)은 DEFECT/CONFIRMED 상속·최종 스윕이 덮지 않는다 · RULE_SCREEN NOT_RUN ← 같은 규칙 요소 실측 집계(`SCREEN_AGG`). `mapping_trace.py`: `검증엔진 T-…` 만 적힌 낡은 증거는 보존·인용하지 않음 · X-REASON 사유 어휘 확장. `golden.py`: AS-IS 행수(2-튜플) 집계 수정 — A1 증거 `AS-IS n행 ↔ TO-BE m행`(한쪽만 0 = FAIL, 둘 다 있고 다름 = 판정필요 — 유일하게 허용되는 판정필요).
- 공통버튼 룰(CR-070, `hooks/subtitle-button-actions-mandatory.md §1.0`)로 J1/J2/D4(InsertButton) 계열은 TO-BE 룰 기준 판정. `check.js B08` 양방향(AS-IS NO-OP 인데 핸들러 노출 = 위반).
- **2026-10-27 사용자 의견 43건 반영(정합검증서 v35 '조치 필요' 열 '사용자의견')**: ① judge `USER` 반입 열 확장('사용자판정'+'사용자의견' · 판정오류/오류 아님/이상 없음/정상→PASS · 대상 아님→NA · 구현 필요→FAIL · 상세 설명/이해 불가/중복→판정 유지+메모) ② **TO-BE UI 에 없는 항목 = NA**(`ABSENT_NA`: '칸/컬럼/버튼 없음' FAIL → NA · 대조표 미구현 만 FAIL · 집계·상속 앞에서 수행) ③ DEFECT/CONFIRMED 상속 분모 = 요소 실측만(행·진입점 집계·미구현 종속 제외) ④ `make_verify_docs` '조치 필요' = 직접 실측 FAIL 만(상속 FAIL 중복 제외) · '사용자의견' 열 이어 넘김 ⑤ 검사기: B2 신규행 Division 선지정 후 후보 중복 판정 · E1 문자 입력 검사 · H2 팝업 입력 셀(FPModal) 노랑=PASS(CR-072) · W4d D1 기존행 Incoterms 항상 잠금(EditButton:453)/SSP Incoterms PLANT 해제(:482) · H5 COL 메타·기준표 라벨=PASS(CR-071 확장) · C2 VMI_YN 표시용 dataMap=NA · 팝업 G5/H6 txt 조건 판정+M4 COL 결과값 판정 · 증거 문장에 팝업 이름('Distribution Route 팝업(ROUTE_ID 더블클릭)')·AS-IS 의미 명시(INHERIT·C6·E4).
- **2026-10-27 2차(v36 → v37)**: ① 사용자 지시 "TO-BE UI 에 없고 대상 아닌 항목은 FAIL 로 분류하지 않음" → judge `ABSENT_NA`(칸/컬럼/버튼 없음 FAIL → NA, 대조표 미구현만 FAIL) · mapping_trace X-LOC(구현 위치 공란) = NA(대조표 기록 보강, 화면 오류 아님) ② '조치 필요' 시트 = 요소 실측 FAIL 만 — 행 집계·진입점 집계·결함원장/확정규칙 상속 FAIL 은 중복이라 제외(검증 전체 시트엔 남음) ③ judge USER 반입을 집계·상속 앞으로 이동, 같은 행의 '사용자의견'(판정 문구) > '사용자판정'(이전 라운드), 메모형 의견은 판정 유지+메모 · H2 SetFGColor 는 사람이 읽는 설명(EXPLAIN) 선두 ④ TRACE H5 COL 헤더 = 기준표 라벨 → PASS(CR-071 확장) ⑤ `_trace.spec.ts`: W4 M4·W4d C3/M4 COL 은 **선택 Route 행의 dataItem 값과 대조**(선택 Route 값이 빈값이면 행도 빈값 = 정상 · 팝업 데이터에 없는 항목 = NA · 팝업 1행이면 OK 만으로 적용) · G6 제로폭/NBSP placeholder = 빈값, 상태 코드 1~2자(C/R) = 라벨 머리글자 · C3 DIVISION_ID 기본값 strSel_Division = 조회 Division 단일일 때만, 복수면 NA(D4) · H3 셀 병합 = `getMergedRange` 실측(같은 값 인접행 없으면 NA) · D5 AS-IS 기본 TextCellType ↔ TO-BE 메타 숫자/날짜 = PASS · C6/D6 증거 문장 평문화(hook #144 인용) ⑥ `_verify.spec.ts` B2 신규행 Division 미지정 시 첫 후보로 채움.
- **2026-10-27 3·4차(v37 → v38) — 대조표 행 FAIL 의 '무엇·왜'**: 사용자 "대조표 항목은 정합검증 대상이 맞지만, 구현 여부를 확인하지 않고 FAIL 처리하면 보완할 방법이 없다 · 어떤 오류인지 기재하라".
  - `mapping_trace.py`: 대조표 행의 **요지(2번째 칸)** 를 `label` 로 보존 → 원장 `target` = `D00-x-xxx · 요지`, `expected` 에 요지·사유 · X-NOTIMPL 증거 = "대조표 ID '요지' 상태 미구현 — 사유 … → 구현 필요" · BLOCKED = "선행 미구현에 종속 — 대조표 ID '요지'(사유)" · 집계 = "대조표 ID '요지' 의 규칙 N요소 … · FAIL 요소: 이름 — 사유" · H3 기대 = 컬럼 선언 **FPMerge(Restricted/None)**.
  - **W9 `_trace.spec.ts` '대조표 미구현 행 실측'**: 미구현 32행을 7개 결함군으로 묶어 화면에서 재현 — G-A Route Id 직접 입력 차단 · G-B 신규행 Division 콤보=내 Division · G-C 기존행 SSP Incoterms 편집(To Site PLANT) · G-D 같은 키 신규행 Save → 거부 메시지 + 저장 전후 셀 색 변화(강조) + 오류코드별 메시지 · G-E 팝업 선택 후 커서 위치 · G-F From Site 유형(-E/-A/기타)별 To Site 후보 집합 비교 · G-G From Site 후보 속성 OSP_YN. 결과를 X-NOTIMPL 행에 쓰고 `mapping_trace` 가 **실측을 대조표 상태보다 우선**(PASS 면 "대조표 상태 갱신 대상"), 종속(BLOCKED) 행은 그 실측을 상속. W9 가 다루지 않는 미구현 행은 "실측 검사 없음(검사기 추가 대상)" 을 명시한 FAIL.
  - 첫 실측(10-27 15:40): D00-3-009(내 Division 콤보)·D00-2-006(Route Id 직접 입력 차단)·D00-3-065(커서 이동)·D00-4d-005(OSP_YN) 는 **이미 구현됨(대조표 상태 낡음)** · D00-3-067 계열(From Site 유형별 To Site 분기)은 **실제 미구현**(세 유형 모두 To Site 후보 2671건 동일) · D00-3-034 는 PLANT To Site 기존행이 조회에 없어 NA.
  - `_trace.spec.ts` W4c M4 ROW 결과값 판정 · W4d C3/M4 팝업 값은 코드↔표시값(dataMap) 환산 비교 · H3 Restricted = 왼쪽 병합 컬럼이 같은 인접행만 · `_verify.spec.ts` F1/F2/F6 저장 실패 = FAIL + 사유(HTTP·CODE·메시지·응답) · judge 메모형 의견은 증거에 붙이지 않음 · 정합검증서 '조치 필요' = 요소 실측 FAIL 만(행·진입점 집계·선행 미구현 종속 제외).
- **2026-10-27 5차(v38 → v39)**: ① H3 기대값 = AS-IS 컬럼 선언 `FPMerge`(Restricted/None) 를 **AS-IS .cs 원문에서 직접** 읽음(`asis_fpmerge()` — 액션 추출 actions.csv 에는 Add*Column 선언 문장이 없음 · 선언 없는 메타 자동 컬럼은 기본 None) ② 팝업 값 대조에 코드/명칭 쌍 허용(TRANSPORT_MODE='TRK' ↔ 팝업 다른 필드 'TRUCK') ③ judge: 옛 사용자판정 '구현대상인데 미구현이면 fail' 은 조건부 지시 → 메모(W9 실측이 판정) · H2 SetFGColor 설명문(EXPLAIN)은 ASIS 행만 ④ `nscm.alertText` 닫히는 대화상자 예외 방지 + W9 저장 호출 try/catch(3차 W9 가 저장 직후 예외로 중단 → G-D 판정이 단독 실행의 오판(신규행 기본 배경을 강조로 봄) 그대로 남았던 원인).
- **2026-10-27 6차(v39 → v40)**: ① 선행 미구현 행의 W9 실측이 PASS(이미 구현)면 `mapping_trace` 가 그 행의 종속 검사를 **차단하지 않음**(`impl_ok`) → 종속 행이 '상속 PASS → NOT_RUN → 판정필요' 로 새지 않고 정상 실측 경로로 ② 조치 필요 시트에서 '선행 대조표 … 실측 결과 상속' 행 제외(같은 결함 중복) ③ AS-IS `AddComboColumn` 선언 컬럼(VMI_YN dtValidYN 등) = `asisCombo` → C2 값채움 판정에서 사용자 선택 가능 = 정상 ④ H3 실측에 이 컬럼의 병합 범위 수(400행)와 두 인접행에서 값이 다른 왼쪽 컬럼 목록을 기록 — 공용 `CustomMergeManager` 병합 키는 **왼쪽 전 컬럼 값 누적**(`_getMergeKey`, 숨김·비병합 컬럼 포함)이라 BOD_ID 같은 고유값 컬럼이 왼쪽에 있으면 실제 병합이 일어나지 않음(원인 후보 명시) ⑤ W9 저장 실패 메시지는 닫기 전에 직접 읽고(`nscm.save` 는 닫으면서 돌아와 문구를 놓침) 응답 `ERR_MESSAGE` 로 보강 · 셀 색은 재시도 후에도 못 읽으면 FAIL 이 아니라 '측정 실패(NA)'.
- **2026-10-27 7차(v40 → v41, W4d+W9 만 재실행)**: ① W9 `readCells` 가 파이썬 패치 문자열 `${'${rowIdx}'}` 로 생성돼 평가 JS 문법 오류 → 항상 `[]`(셀 색 측정 실패 NA 원인) → `${rowIdx}` 로 교정 ② `asisCombo` 를 조건 JSON 앞쪽(3000자 절단 전)으로 이동(VMI_YN C2 에 키 누락) ③ `mapping_trace` export 의 '실측 보존' 에서 파생 증거(선행 대조표 상속·행/진입점 집계·대조표 미구현 정적문)와 해제된 사용자판정(증거에 `[사용자판정]` 없음)을 제외 — v40 에서 '상속 PASS' 13행이 판정필요로, 옛 사용자판정 3행이 FAIL 로 남던 원인. 교훈: 파이썬으로 TS 템플릿을 생성할 때 `${}` 중첩은 생성 결과 줄을 반드시 눈으로 확인.
- **2026-10-27 8차(v41 → v42)**: ① 조건 JSON 3000자 축소 순서에 큰 키(siteSamples·e4·d3·m4·widths·metaWidth·tobeMeta)를 추가하고 최후 폴백에도 작은 판정 키(popup·asisCombo·merge·viaPopup·d5Src·d5·noAssign·allFlag·ctlType·asisLabel)를 남김 — VMI_YN C2 가 `truncated` 폴백으로 떨어져 `asisCombo` 를 잃던 원인 ② 연결 문장·요소가 없는 진입점(D00-3-066 ShowCell) = NA(검사할 것 없음) ③ '실측[T-…]: ' 접두가 붙은 파생 증거(선행 상속·집계)도 보존·조치 필요 제외 대상 ④ W9 중복 저장 강조 실측(G-D)을 AS-IS E4 errCode 문장 행에도 반영(W4 E4 의 '대조표 미구현 가정' 정적 FAIL 을 덮음). v41 실측: 중복 저장 시 DIVISION_ID~INCOTERMS·TRANSPORT_MODE 배경이 노랑→연파랑으로 바뀜 = 강조 구현됨(PASS) · 메시지 '저장시 중복 오류가 발생하였습니다. 중복된 기간을 저장할 수 없습니다' = 구체 메시지(PASS).
- **2026-10-27 AS-IS 파싱 룰 보완 1차(v44 → v45)** — 사용자 요청 "정합검증에 필요한 AS-IS 정적·동적 데이터를 파싱 시 추가 취합": `facts_gridcols.py` → `grid_columns_asis.csv`(코드 선언·메타·프레임워크 기본값+원문 라인) + `Doc/asisfacts/framework/spreadinfo_defaults.csv` · `mapping_trace.gc_of()` 가 H3 `merge/mergeSrc` · C2 `asisCombo/asisCellSrc` 의 근거로 사용 · `run_verify` facts 단계에 편입 · `asis_fpmerge()` 는 블록 주석 제거 후 폴백으로만. 발견: SCP0007 메인 Add*Column 31줄은 `/* */` 안(실행 안 됨) → 실제 컬럼은 메타 생성, 병합 정책은 전부 Restricted(`SpreadInfo.cs:1909`). 룰: `hooks/asis-coverage-check.md §0.6`.
- **2026-10-27 v45 교훈 — 부분 재실행 금지**: `_trace` 를 일부 테스트(W4b+W4d)만 다시 돌리면, 앞 테스트(W4b·W5)가 '판정필요' 로 남긴 행을 **뒤 테스트(W4c·W4d·W9)가 덮어 해소하던 결과가 사라져** 판정필요가 15 → 36 으로 늘었다(F3 셀 위치 확인 불가 · J1 Division 후보 · H6 팝업 수동). 같은 row_id 를 여러 테스트가 쓰는 구조에서는 **_trace 전체 실행**이 원칙. 부분 실행은 특정 행만 확인하는 디버그 용도로만.
- **2026-10-27 v46→v47 교훈 — 체인 순서**: E2E 뒤에 반드시 `mapping_trace --to-ledger`(집계 행 재계산) → `judge` 재실행이 있어야 한다(run_verify 정식 순서). 이를 뺀 임시 체인은 대조표 ROW/ENTRY 집계 행을 체인 시작 시점(요소 NOT_RUN)의 '판정필요' 로 남긴다 — v46 판정필요 22(H6 집계 5·X-ROW 2 허위) → 꼬리 단계 재실행으로 15(A1 만). 최종 v47: FAIL 99 · NA 185 · PASS 1008 · 판정필요 15 · 조치 필요 32(To Site 분기 16 · SetFGColor 2 · 실결함 7 · 셀 병합 7: 메타 컬럼 Restricted 인데 TO-BE MERGE_COLUMNS 제외).
- **2026-10-27 정합검증서 '쉬운 설명' 열(v49~, 사용자 요청 "AS-IS 규칙과 증거를 쉽게 이해할 수 있는 열을 근거 등급 앞에")**: `make_verify_docs.plain()` — 행마다 [무엇을 보는 검사] + 대조표 항목(ID·요지) + AS-IS 동작/TO-BE 실측(`↔` 분리) + 결론(같음/다름/대상 아님/사람 확인) + FAIL 이면 사용자가 겪는 일(`FAIL_MEAN`) + 사용자 판정 반영 표시. 집계·상속·미구현·기록 보강 행은 각각 그 성격을 문장으로. 컬럼 코드는 화면 라벨로 치환(`_TOK`). judge: 사용자판정 문구에 줄바꿈이 있으면 접두 제거가 실패해 11중 중첩되던 결함 교정(DOTALL).
- **2026-10-30 CheckList 열 순서(사용자 지시)**: `… 영역 / 대상 / 결과 / 설명 / 기대(AS-IS·규칙) / AS-IS 근거 / 조건 / 정답 / 판정 방법 / 사용자의견 / 근거 등급 / 증거(실측) / TO-BE 위치 / 결함 원장 / 사용자판정` — 결과·설명 두 열을 대상 바로 뒤로, '쉬운 설명' → **'설명'** 명칭 변경. `make_verify_docs.LH/LW_BY/lrow` 는 열 이름 기반(순서 변경이 값 밀림을 못 일으킴) · 독자 `regress.py --harvest` 는 '설명'/'쉬운 설명'(옛 판) 둘 다 인식 · 사용자판정 반입 키는 '검증 ID'(2열) 고정이라 영향 없음. 적용 시트: 검증 전체·조치 필요·판정 필요·미검증(+사유).
- **2026-10-27 CR-073 셀 병합(사용자 판정 "셀병합 적용되어 있음 — 오류 아님")**: TO-BE 는 화면이 정한 키(그룹) 컬럼만 병합(BOD MERGE_COLUMNS 9) → 값 컬럼 미병합 7건 + Trans Mode(병합 대상이지만 왼쪽 비병합 컬럼 때문에 계층 병합 구조상 병합 안 됨) 1건 = PASS. `_trace.spec.ts` H3(`!mergeInfo.cols[b]` → PASS · `leftNoMerge` → PASS 권고) · judge `H3_CR073` 즉시 재판정 · hook datagrid §5.4 · 룰 D3.
- **2026-10-27 밤 — 사용자 재확인 3건 + 동시 실행**: ① 대조표 '미구현' 16행(To Site 유형별 콤보 분기) = **구현됨**(BodGrid `resolveToSiteBucket` · OSP_YN=Y 인 -A From Site 로 PLANT 분기 26건 = 사내 DB 원천 SQL 26건) → W9 G-F 는 '분기 존재' 로 판정하고 후보 집합 데이터 차이(2668 vs 2603)는 B4 행에 기록(`Doc/verify/<ID>/combo_expect.json` = 원천 SQL 직접 실행 기대값) ② D6 Insert 맨 위 = CR-074(사용자 판정) ③ C3 L/T Type = 재실측 PASS(이전 FAIL 은 측정 시점 오류) ④ 사용자의견 어휘 '판단오류·정상 확인' 반입 ⑤ 자동 검사기 없는 일반 규칙·결함원장 항목 = NA(수동 검수, 작업 원장 W4/W5) ⑥ 메뉴 접근 권한 없는 그룹의 auth 기록(menuAccess=N, expected 없음)은 J2 근거에서 제외. 주의: 사용자 측 run_verify(gen2·gen3, skip_e2e)가 같은 시각에 원장을 재생성(GENERAL 551행 추가)해 TRACE 요소의 E2E 결과가 비어 판정필요가 늘었음 → 전체 체인(E2E 포함) 재실행으로 정리.
- 타입체크: `tools/E2E/tsconfig.json` `paths`(@playwright/test) 추가 — `node nscm-fe/node_modules/typescript/bin/tsc --noEmit -p tools/E2E/tsconfig.json` 으로 스펙까지 검사(종전 `npx tsc` 는 tsc 미설치로 아무것도 검사하지 않았다).

### 11.4 라운드 20/21 — 조치 필요 항목의 검증엔진 추가 · 정렬(A6) 데이터 기준 · 메시지 의미 대조(MS1) (2026-10-28 사용자 지시)

사용자 질문 "조치예정이던 항목이 판단불가로 넘어갔다 — 테스트가 불가해서인가, 검증엔진을 추가할 수 없나" · "AS-IS·TO-BE 데이터 조회 기준이 달라 SORT 비교 불가 — 정합검증에 추가" · "조회 쿼리에 ORDER 가 없거나 그리드 정렬이 누락되면 오류" · "MSG_ID 는 같은 ID 가 아니라 같은 의미의 ID 사용 여부를 검사" 에 대한 보완.

| 항목 | 전 | 후 | 파일 |
|---|---|---|---|
| C3 팝업 선택값 반영(ROUTE_VALID·DIS_TOTAL_LEAD_TIME·BOD_VALID) | 팝업 필드명이 달라(VALID_YN·LT_SUM·"Y" 고정) '팝업 데이터에 해당 항목 없음' NA | AS-IS SetRoute 의 `dr["필드"]`/고정값을 `popMap` 으로 추출해 실측 | `mapping_trace.py`(C3 popMap) · `_trace.spec.ts` W4d `pvOf` |
| W9 G-C PLANT To Site 기존행 SSP Incoterms 편집 | `columnValues` 5000행 상한 → PLANT 행 0건 오판 → NA | 전 행 스캔(`c.rows`) · 사이트 유형표 2963건 전량 | `_trace.spec.ts` W9 |
| D3 조건부 잠금 `TO_SITE_CODE=''` | '타입 미확인' → FAIL(검사기 한계를 결함으로) | 빈 To Site = AS-IS 도 유형 없음으로 계산 · 미등록 유형은 NA(검사기 한계 명시) | `_trace.spec.ts` D3 |
| ASIS C3/C6 INCOTERMS 재측정(W9) | 원장 결과가 '판정필요' 일 때만 실측 → 원장 재생성(NOT_RUN)이면 건너뜀 → `_verify` 의 '분기 해석 불가' 판정필요가 남음(v70/v71 C6 Incoterms 지워짐 FAIL 유실) | 항상 실측 | `_trace.spec.ts` W9 |
| E2E 결과 병합 | 뒤 테스트의 판정필요/ERROR 가 앞 실측 PASS/FAIL 을 덮음 | 확정 판정은 판정필요로 덮지 않음(두 spec flush) | `_trace.spec.ts` `_verify.spec.ts` |
| F4 저장 SP(화면 진입·조회 중 호출 없음) | 판정필요(+GENERAL 상속 15행) | NA(저장 경로 F1/F4 CRUD 행에서 판정) | `_trace.spec.ts` |
| E4 저장 성공 메시지(MSG00004) | `_trace` 가 원장 F1 결과(NOT_RUN)로 FAIL | judge 가 F1 최종 결과로 재판정 | `judge.py` E4_F1LINK |
| 골든 비교(A1/A7) 행 상한 | 양쪽 각각 '앞 5000행' 창을 비교 → 395/395행 허위 차이 · TO-BE 상태 커서 1행이 건수에 포함(5000↔5001·1↔2) | 전량(20만 상한) · 상태 커서 제외 · **데이터 기준 명시**(공통/AS-IS 전용/TO-BE 전용 — DEV MSSQL ≠ 사내 Oracle) | `tools/DbConn/golden.py` |
| **A6 실제 순서 대조(신규)** | 정적 ORDER BY 키 비교 + TO-BE 그리드 자기 정렬만 | 같은 인자로 받은 두 결과의 **공통·유일 행 상대 순서** 비교(`<sp>.order.csv`) · 센티널(''↔'-'/'/') 행 집계 · **NULL 정렬 위치**(MSSQL '' 맨 앞 ↔ Oracle NULL 맨 뒤) 검출 → ORDER BY 가 같아도 실제 순서가 다르면 FAIL | `golden.py` `_order_check` · `judge.py` SORT_ACTUAL · `mapping_trace.py` A6 hit |
| **CR-075 조회 결과 결정적 순서(신규)** | AS-IS·TO-BE 모두 ORDER BY 없음 → NA | 그리드 표시 조회 SP(PROC_M sheet 가 SHEET_COLUMNS 를 가짐)에 ORDER BY 없으면 FAIL · 룩업(countryCity·routeCnt)·저장·1행 집계는 NA 사유 기재 · TO-BE 가 ORDER BY 추가 = PASS | `sort_check.py` · `judge.py`(TRACE A6 반영) · `confirmed_requirements.csv` CR-075 |
| **MS1 메시지 의미 대조(신규)** | E4 실측(알림 문구)만 | AS-IS MSG_ID 마다 1행(source MSG): AS-IS 문구 → TO-BE 같은 문구 ID(msgmap) · TO-BE FE 페이지 폴더(주석 제외)·PKG 본문(`tobe_pkg_msgs.csv`) 사용 ID · 같은 ID 를 다른 뜻으로 쓰면 FAIL · 코드 참조 없으면 E4 실측으로 | `ledger.py` · `sort_check.py`(PKG MSG 덤프) · `judge.py` MS1 · `detect_rules.csv` `mapping_checkdefs.csv` |
| `gen_golden_cases.py` | 지정 화면만 남기고 다른 화면 케이스 삭제(10-28 09:41 DMF0004 생성이 SCP0007 5건 삭제 → golden/A1/A6/A7 근거 소실) | 다른 화면 행 유지 | `tools/DbConn/gen_golden_cases.py` |

실측 근거(2026-10-28 10:0x, 읽기 전용 프로브): SCP0007_GET_BOD 같은 인자(Div 40 · C · Y) AS-IS 6487행 ↔ TO-BE 8121행 · 공통 6438 · AS-IS 전용 49 · TO-BE 전용 1683(환경 데이터 차이) · CUSTOMER 빈 값 110행이 MSSQL 은 맨 앞, Oracle 은 맨 뒤 → 공통 행 순서 불일치(첫 차이 r0). AS-IS DB collation Latin1_General_CI_AS · Oracle NLS_SORT/NLS_COMP BINARY(세션·DB). To Site PLANT 기존 BOD 행 Div 40 = 95건(SCP_MST_BOD × SCM_MST_SITE.SITE_TYPE).

**라운드 22~24 추가(2026-10-28 오후)**
- 사용자 제안 "정합검증에서 확정된 룰을 하네스에 등록해 생성·보완 시 적용 → 원천 차단": `confirmed_requirements.csv` 에 `harness` 열(어느 생성기·게이트가 강제하는지) · `cr_harness_gap.py` → `Doc/verify/_cr_harness_gap.md`(확정 룰 75 중 하네스 등록 12 · 정합검증만 63 = 등록 후보) · check-pkg **P42**(CR-075: 그리드 바인딩 GET PROC ORDER BY 없음 BLOCK · NULLS FIRST 없음 WARN) · `prompts/port_pkg.md` §정렬 · KEEP H15.
- 정합검증 단계 = 보완 금지(사용자 지적): 정렬 원인 확인 중 사내 PKG 에 NULLS FIRST 를 적용(11:14)했다가 원복(11:25). 제안은 `Doc/verify/SCP0007/repair_proposals/…_미적용제안.sql`. 남은 순서 차이의 원인 = MSSQL Latin1_General_CI_AS 기호 가중치(하이픈 무시 · 기호 < 숫자/문자 · 대소문자 무시) — Oracle NLS_SORT 어느 것도 완전 재현 못함(BINARY_CI 17/999 역전) → 보완 방법은 보완실행 단계 결정.
- E2E 선택이 원장 결과 상태에 의존하던 결함: run_verify 는 원장을 새로 만들어 E2E 시점엔 전부 NOT_RUN → '판정필요 해소' 류 블록(E4·D4·H2·MSG00222·W9 ASIS C3/C6)이 한 번도 돌지 않았다 → 상태 무관 선택으로 교정.
- W9 popMap 재실측(팝업 첫 행 선택 뒤 2초) → ROUTE_VALID·DIS_TOTAL_LEAD_TIME·BOD_VALID PASS(v73). popMap 추출은 팝업 핸들러(CellDoubleClick·SetRoute) 문장만(TO_YYYYMMDD 고정값 허위 FAIL 교정).
- `_verify` 가 잠긴 셀이라 못 읽던 SSP Incoterms·Active(BOD_VALID) COLUMN 행(B1/B2/A2/D5/E5/D1) → W9 가 PLANT 기존행·신규행 콤보 후보로 판정. 검사기가 실행하지 못한 행·K3 부분 실측·C3/C6 원천 해석 한계 = NA 수동 검수(W7).
- v73(run_verify 11:55:05→12:48:18): FAIL 105 · NA 333 · PASS 1505 · 판정필요 35(A1 27 · K3 7 · C6 1) · 조치 필요 18. 산출물 위치가 `Doc/CheckList/`(CheckList·ActionItemList)로 바뀜(VM 측 변경).
- v82(18:04:20→18:09:11): 6번 H2 Set_ValidTextColor **재실측 PASS** — Route Valid=N 행(r199) Trans Mode·Distribution Total 글자색 rgb(189,189,189) ↔ Y 행 rgb(0,0,0) · Route Check≠Y 행(r219) Route Id rgb(255,0,0) ↔ =Y 행 rgb(0,0,0). 걸림돌 3개를 차례로 걷어냄: ① ledger.py prev 병합 → E2E 선택의 결과 필터 제거 ② 글자색 블록이 Status=Required 토글 뒤에 돌아 Route Valid 값이 빈 상태(블록을 토글 앞으로) ③ judge E2E 반입이 '수동 사용자판정' 행을 건너뜀('[재실측' 확정 결과는 예외). 7·8번(커서) PASS. 공통버튼 클릭 9곳 noWaitAfter+catch(W5 Insert·W4d Save 타임아웃 중단 방지). 결과 FAIL 63 · NA 355 · PASS 1533 · 판정필요 27(A1) · **조치 필요 5**.
- 창별 독립 실행(2026-10-28 19:3x, 사용자: "각 창이 별도 세션·별도 E2E 로 간섭 없이"): E2E 잠금을 **화면별**(`tools/E2E/runlock.js` `verify <ID>` → `_run.verify.<ID>.lock`)로 바꿔 다른 화면의 UI CheckList 는 동시에 돌고 같은 화면만 직렬(run_verify 는 exit 4 대신 최대 120분 대기). 공용 파일 충돌 제거: 골든 `_summary.csv/.md` 화면별 병합(다른 화면 행 보존 — 순차 실행에서도 지워지던 결함), gen-e2e `_index.csv/_matrix.csv` 원자적 쓰기, prereq 의 공용 생산자(TO-BE 메타 export·TobeFacts 인덱스)는 생산자 잠금으로 1개만. 그날 19:03~19:05 다섯 창 동시 실행에서 SCP0041·SCP0111 이 exit 4(공용 잠금)로 끝난 사고가 계기.
- 라운드 39(2026-10-29 12:3x, 사용자: "실제 배선되어 있는데 검사기 오류로 처리되었다면 CHECKLIST 보완 · 반복 안 되게 RULE 로"): SCP0111 F4 '(PROC_M 배선 없음)' FAIL 6건 중 4건이 허위 — 원인 = `mapping_trace.py` F4/A6 가 대상 SP 이름을 proc_meta 의 **proc 열 하나**로만 비교. ⓐ 대조표가 SP 를 **API_ID**(P_SCP0111_GET / P_SCP0111_SAVE / P_SCP0111_SAVE_ADMIN — BTN_MPG·API_M 키)로 적어 프로시저명과 불일치 → 실제로 main/SEARCH 가 호출됐는데도 `callProc` 빈값이라 `_trace.spec.ts` W5 가 FAIL ⓑ TO-BE 프로시저명이 AS-IS 보다 줄어든 경우(SCP0111_SAVE_INTEGRATION_PSI_ADMIN → P_SCP0111_SAVE_PSI_ADMIN)는 골든·P_/_OSP 정규화로 못 찾음. 교정: 공용 `resolve_call_proc()` — BE 해석 경로(`PR_GET_PROC_INFO_LIST` = BTN_MPG ⨝ API_M → PROC_M)와 같은 키 전부: ① 프로시저명 ② P_/UP_/SP_ 접두 무시 ③ API_ID ④ 골든 ⑤ 정규화 ⑥ 토큰 부분집합 1:1(같은 화면·같은 동사·다른 AS-IS SP 가 이름 그대로 차지한 프로시저 제외·후보 1개일 때만) — F4·A6 공용. 회귀(대조표·엔드포인트 SP 전수, 종전↔신규): SCP0111 FIXED 4 · SCP0007 8/8 SAME · SCP0096 8/8 SAME. 나머지 2건(SCP0111_GET_ESS_PACK_LINE)은 **진짜 배선 없음**이었다(BTN_MPG 행 부재 → 같은 날 12:10 사내 보완) — 판정 시 proc_meta 스냅샷(11:30)이 보완보다 낡으면 같은 허위가 남으므로 export 재실행 후 판정(KEEP H17). 원장 F4 행은 `_trace` E2E 결과라 **E2E 재실행 후** 바뀐다.
- 라운드 40(2026-10-29, 사용자: "검사기 오류로 인한 조치 필요 — 재발하지 않도록" · "meta 정보 없다는 오류도 검사기 오류"): 원인 유형 7종을 `Doc/verify/_checker_defects.md` 로 카탈로그화. '메타 없음' = F4 'PROC_M 배선 없음' FAIL(SCP0111 5·SCP0020 2)인데 13:08 배선 해석(resolve_call_proc)이 갱신된 뒤에도 10:54/12:11 의 옛 E2E 판정이 원장에 남은 **T1 낡은 판정 잔존** — TRACE 행 id 가 조건을 포함하지 않아 ledger prev-merge·e2e_results 재반입이 옛 결과를 그대로 썼다. 구조 교정 ① specs `put()` 이 측정 시점 조건 해시 `cond` 를 기록, judge 반입 시 현재 조건과 다르면 ERROR '[재측정 필요]' ② `mapping_trace --to-ledger` 는 조건이 바뀐 TRACE 행의 보존 판정을 버림 ③ F4 '배선 없음' + 현재 callProc 있음 = 즉시 재측정 필요(SCP0111 5·SCP0020 2 → ERROR). 재발 방지 3중: **FAIL 발행 계약**(judge — AS-IS/확정 규칙 근거 없는 직접 FAIL = '[근거 불충분]' ERROR · 대상 시트≠근거 시트 = '[근거 축 불일치]') · **조건 해시** · **사용자 판정 회귀 오라클 `regress.py`**(모든 CheckList 판의 사용자의견 → `_user_verdicts.csv` · 판정오류/대상아님 행의 검사기 원판정(judge 가 note 에 `원판정:` 기록)이 FAIL 이거나 중복 행이 `action_items.json` 에 별도로 남으면 위반 → `_regress_report.md` · run_verify 끝에 자동). KEEP H18.
- 라운드 38(2026-10-29, 사용자 질문 "시노님이 없는데 왜 조회는 됐나" → 승인): 메인 조회는 SCM_MGR 소유 DEFINER 패키지라 SCM_MGR 시노님으로 풀리고, 조회조건 콤보는 SCM_ADM_CMBO_SQL_M 문장을 SCMP_APP 세션에서 execStmt 로 직접 실행해 SCMP_APP 시노님이 필요 — 그래서 조회는 되고 Line 콤보만 ORA-00942. 종전 fixture 는 어떤 요청이든 시노님 5xx 면 전체 중단(17~18/22 ✖) → ① fixture: `/api/admin/(combo|lookup|lookup-muti)` 의 오류는 중단하지 않고 `e2e/dberr_partial.json` 에 기록(부분 차단), call-proc·메뉴/권한 API 오류만 중단 ② run_verify 게이트: syn_check 문제가 COMBO 종류만이면 E2E 진행 ③ judge: 부분 차단 = DB-SYN 행 '[부분 차단] 콤보 SQL 객체 …'(조치 필요 1번 유지) · 콤보 의존 규칙(B1~B4·B6·B7·G1·G2·C1·C4·D5·A2·E5·G6·G5·M4)의 오류 증거 FAIL 만 ERROR(차단 영향) · 미실행 행 ERROR 전환은 전면 차단일 때만 ④ 쉬운 설명 '⚠ … 이 콤보에 의존하는 검사만 미검증'.
- 라운드 37(2026-10-29 11:xx, 사용자 SCP0020 v5 의견 24건 — "중복 제거 안 됨 · AS-IS 미확인 오판 · A5 는 누락/추가 컬럼 명기 · HEAD/DETAIL 상단 깜빡임도 오류"): ① 중복: 종전 중복 키(규칙·대상·증거핵심)는 대상에 시트 접두(Packer./Plant./Tact Time./Tact Time Except.)와 신규행/기존행 조건이 남아 같은 컬럼 규칙이 시트×조건 수만큼 올라왔다(기능이 제거된 것이 아니라 단일 시트 화면 SCP0007 에서만 충분했던 키) → 시트 접두·조건·행번호를 뗀 키로 묶고 '같은 내용 n건(시트 …)' · 요소 행이 있으면 화면 집계 행(규칙 A5 요소 n행 집계)은 조치 필요에서 제외 · 문서 보강용 X-LOC/X-NOTIMPL 은 NA. ② AS-IS 미확인 오판 교정: (a) D1 — EditButton 잠금 가드가 화면 상태(Division 선택값 `division`·활성 시트 `ActiveSheetIndex`)에 걸린 것을 facts_lockrules 가 무조건 잠금(N)으로 적어 DAILY_CAPACITY 등 허위 FAIL → COND(가드 인용) · judge 는 그 행 값으로 계산할 수 없는 COND 를 NA(사람 확인) (b) D4/C3 — Insert 기본값 문장이 `spdMain.ActiveSheetIndex==0||1` 같은 시트 가드 안에 있으면 TO-BE 시트 대응을 기계가 몰라 NA (c) A5 — AS-IS 메타 VISIBLE Y ↔ TO-BE 메타 VISIBLE N(설계 숨김, JUMBO_MIN)은 FAIL 아닌 NA(렌더링 불일치만 FAIL) (d) H8 — 검사기가 컬럼 이름만으로 다른 시트의 셀 규칙(cellRule)을 집어 '소수 0자리' 로 오판(YIELD/TACT_TIME) → 원장 행 기대(해당 시트 SCALE 2/4) 우선. ③ A5 화면 행: 요소 판정을 모아 '누락(AS-IS 표시인데 TO-BE 미표시) n개 = …' / '추가 n개 = …' 로 컬럼명 명기(쉬운 설명도 그 문구). ④ K6 신설(detect_rules·SCREEN_RULES·_verify 테스트): 그리드 2개 이상 화면에서 상단 첫 행 클릭+더블클릭 → 하단 조회 호출 수·상단 재조회 호출·상단 행수 0 순간·상단 첫 셀 DOM 표식 생존(재렌더=깜빡임)을 관찰해 상단 재조회/재렌더/행 비움이 있으면 FAIL. 적용 뒤 E2E 재실행이 필요(사용자가 수행) — H8·D1·A5 화면 행·K6 는 E2E 결과에서 바뀐다.
- 라운드 36c(2026-10-29 10:xx, 사용자: "DB 객체가 없거나 오류 · 메타가 없거나 오류 · 시노님이 없거나 오류 — 비정상 결과 대신 DB 객체가 잘못됐다는 오류를 명확히"): CR-076 범위 확장 — nscm.ts `beLogErrors` 분류 SYN(시노님·권한)/OBJ(PLS-00201·PLS-00306·ORA-00904·ORA-04068 등 DB 객체 없음·컴파일·인자 불일치)/META(PROC_M·API_M 누락 NPE·프로시저 정보 없음)/DB · fixture 는 이 화면 5xx 본문에 세 분류 코드가 있으면 중단(종류별 건수) · syn_check 에 META 행(메뉴·PROC_M SEARCH·SHEET_COLUMNS 누락 → META_MISSING)과 INVALID 패키지의 DBA_ERRORS 첫 줄 · judge 차단 행이 종류별(시노님 없음/권한 없음/DB 객체 없음/DB 객체 컴파일 오류/메타 없음)로 적고 조치 문구에 'CheckList 재작성 요청' · 쉬운 설명·규칙명·KEEP H16 갱신.
- 라운드 36(2026-10-29 09:24~, 사용자: "SCP0020·SCP0111 시노님 추가 · 시노님 없어 실행 안 되면 추가하고 오류 이력 남길 것 · 시노님/DB 객체 오류는 조치 필요에 명기하고 CheckList 재작성 요청 기재" → **CR-076**): ① `syn_fix.py` 신설 — syn_check 비OK + BE 로그 ORA-00942 객체를 모아 SCM_MGR(CREATE ANY SYNONYM)로 `CREATE OR REPLACE SYNONYM SCMP_APP.X FOR <SCM_MGR 시노님이 가리키는 owner.obj>`, SELECT 권한은 GRANT OPTION 이 있을 때만 부여(없으면 DBA 용 GRANT 문 기록), 재검사 후 이력 `Doc/verify/_synonym_history.csv`(ts·화면·객체·원인·조치 SQL·결과·재검사·BE 로그 오류 횟수/시각) · 실행 SQL `Doc/verify/<ID>/applied/<ts>_synonym.sql` · 클라우드용 `Doc/cloud_sql/synonym_<ts>_<ID>.sql`. ② run_verify 차단 게이트가 syn_fix 를 먼저 돌리고 남은 것만 차단 · judge DB-SYN 행에 '시노님 자동 보완 …(이력)' 표기, 미해소는 DBA GRANT 문을 조치 필요에 · 요약 🔧 줄 · 쉬운 설명에 'CheckList 재작성 요청' 명기. ③ syn_check 결함: 앱 계정 소유 '시노님'을 자기 객체로 보고 OK(권한 미검사) → SYNONYM 제외해 연쇄·권한까지 확인(SCM_LINE_HIERARCHY_CPS_V_SN 허위 OK). ④ 적용 결과(09:33~09:40): SCMP_APP.SCM_MST_LINE_SN→FP_MGR.SCM_LINE_M 생성(RL_FP_SEL 로 SELECT 있음 → 해소) · SCMP_APP.SCM_LINE_HIERARCHY_CPS_V_SN→FP_MGR.SCM_LINE_HIERARCHY_CPS_V 생성했으나 SELECT 권한은 SCM_MGR(GRANT OPTION 없음)에만 있어 **DBA 가 `GRANT SELECT ON FP_MGR.SCM_LINE_HIERARCHY_CPS_V TO RL_FP_SEL`(또는 SCMP_APP) 실행 필요** — SCP0111 은 그때까지 차단 CheckList. 기존 10-28 '정합검증 단계 보완 금지' 의 예외(측정 환경 복구)로 규정.
- 라운드 35(2026-10-29 새벽, 사용자: "5개 화면 CheckList 에 오류 아닌 것이 오류로 판정된 항목이 너무 많다 — 근본 보완" · SCP0020/SCP0111 "검증엔진을 제대로 불러오지 못함"): 6개 화면(SCP0007·0020·0041·0096·0100·0111) 의 직접 실측 FAIL 161건을 규칙·증거 패턴별로 전수 분류해 원인 10종을 찾았다. **(1) 환경 차단** — 앱 계정 SCMP_APP 에 FP_MGR 객체(SCM_MST_LINE_SN·SCM_LINE_HIERARCHY_CPS_V_SN) 시노님이 없어 Line 계열 콤보 SQL 이 ORA-00942 → fixture 가 테스트를 중단(의도된 fail-fast) → SCP0020 17/22·SCP0111 18/22 테스트 ✖, 미실행 행은 NA '실행하지 못함' 으로, 콤보 후보 0·조회 0행·HTTP 500 은 FAIL 로 기록돼 원인 1건이 수백 행으로 번짐. syn_check.py 는 이미 SYN_MISSING 을 찾았지만 원장에 행이 없어 CheckList 에 안 보였다. 교정: RULE_SCREEN `DB-SYN` 행(detect_rules·ledger SCREEN_RULES) + judge BLOCKER 단계(syn_check 비OK 또는 Playwright 결과의 'BE DB 오류' 중단 → DB-SYN FAIL·제안 SQL `repair_proposals/<ID>_SYNONYM_미적용제안.sql`·E2E 미실행 행 = ERROR '[차단 미실행]'·ORA/HTTP 500/후보 없음/0행 증거 FAIL = ERROR '[차단 영향]') + run_verify 사전 게이트(시노님 비OK → ⛔ 배너·E2E 생략·`--force-e2e` 로 강행) + 문서 요약 배너·조치 필요 1번. **(2) 상속 증폭** — 결함원장·일반화·확정규칙 행이 '대상 직접 일치 없음' 인데 같은 규칙의 다른 요소 FAIL 을 물려받아 FAIL 수가 3~4배(SCP0020 직접 99 → 341) → 직접 일치 없는 행은 부정 판정을 상속하지 않음(NA · 원천 행 참조, PASS 만 상속). **(3) D4/C3** — AS-IS Insert 기본값이 변수(strDIVISION_ID 등)라 '식 해석 불가' 인데 FAIL(SCP0020 35건) → NA(검사기 한계 W7). **(4) D1** — facts_lockrules 가 스프레드 컨트롤(siMain/siExcept)을 구분하지 않아 Except 시트의 잠금이 Plant/Packer 시트 D1 에 적용 → edit_expect 에 `control` 열(컨트롤별 기대) + ledger `ee_for(col, sheet)` 토큰 매칭. **(5) A6** — ① 그리드에 없는 정렬 키(LINE_ORDER) 뒤의 키를 비교해 '앞 키 동률' 오판 → 첫 누락 키 앞 접두 키만 대조(없으면 NA·골든 순서대조로) ② sort_check 가 `NLSSORT(col,…)` 래퍼를 키로 읽어 '1번째 키부터 다름'(SCP0041) → 래퍼 첫 인자 추출. **(6) 데이터 없음 = 측정 불가** — D3 '조회 결과 0행' FAIL, G1/G2 '후보 1·기본 ALL 0행' FAIL → ERROR(RX_TOOLFAIL 확장). **(7) MS1** — 같은 MSG ID 가 사용 위치마다 행(MSG00109 ×7) + TO-BE 코드가 그 메시지를 쓰지 않는 경우(처리 방식이 달라 메시지가 없는 것)를 FAIL → ID 1건만 판정·미참조는 NA(E4 에서 판정). **(8) F4** — AS-IS 공통 룩업 SP(SCM0001_/UP_FX_/DM0003_) 배선 없음 FAIL → NA(콤보 메타 대체) · 이름이 다른 TO-BE 프로시저(_OSP·P_)는 골든 asis→tobe 매핑으로 배선 탐색. **(9) CR-071 탭(scope)** — SCP0041 처럼 탭별 조회조건을 가진 화면에서 기준표의 다른 탭 전용 조건을 '칸 없음·순서 다름' FAIL(G4 7·H5 2·G1 2) → scope 가 공통이 아닌 조건은 NA(탭 전환 검사 미구현 W7) · 순서 차이는 화면당 1건 집계 · 'Div'↔'Division' 별칭(findCond·judge). **(10) 기타** — A5 AS-IS 표시 여부가 조건 분기('?')면 NA · CRUD 에서 검사기가 필수 칸(YIELD 등)을 못 채워 화면 검증에 막힌 것은 ERROR(입력 한계) · B2 표시명 중복은 B4(원천 집합 일치) PASS 면 PASS · X-LOC 는 파일 이동(공용화)을 이름으로 찾음 · E4←F1 ERROR 전파 · H8 쉬운 설명 오기('총 건수') 교정. 재생성 1차(01:17~03:52) 결과로 드러난 추가 교정(35b/35c): ⓐ fixture 가 같은 BE 를 쓰는 다른 세션의 ORA-00942 를 이 화면의 차단으로 오인(SCP0007 W4c 중단 → 허위 DB-SYN FAIL·29행 ERROR) → 이 화면 5xx 응답 본문에 시노님 오류 코드가 있을 때만 중단(nscm.ts 가 5xx 본문 보관) ⓑ sort_check 래퍼에 REGEXP_REPLACE·TRANSLATE 등 추가 ⓒ CR-071 탭 전용 조건은 SEARCH 행('조회조건 X 칸 없음')도 NA ⓓ `form_labels` 가 constants 의 `t(LBL.X, 'Fallback')`(밑줄 없는 폴백)도 라벨로(SCP0100 '화면 라벨: ' 빈값) ⓔ 대조표 'SP IF @P_BUCKET' 표기의 @변수가 SP(P_BUCKET·P_FROM_SITE…)로 잡혀 F4 FAIL → 제거 ⓕ 모드 라디오(SCP0100 Search Mode = Search Level/Detail) 뒤에 숨은 조건은 `findCondAny` 가 라디오를 바꿔 가며 찾고 못 찾으면 원복(G1 '칸 없음' 7건). 재생성 2차(04:07~04:48)에서 추가 교정(35d/35e): ⓖ `form_labels` 가 주석의 `t(LBL.KEY, '_Fallback')` 을 라벨로 읽음('Fallback') → 주석 줄 제외 · constants 폴백은 Form 라벨이 3개 미만일 때만(SCP0096 에 constants 라벨이 섞여 G4 'Div' 허위 FAIL) ⓗ `sp_tokens` 가 'P_SCM0002'(패키지명)·'P_BUCKET'(바인드 변수)를 SP 로 → 동사 세그먼트 또는 proc_meta 에 있는 P_ 만 ⓘ SCP0100 조회영역은 MuiCollapse 가 아닌 자체 토글(`_toggleButton_`)로 둘째 줄(To Site·Model/Nick Name·Plan Type·Scale·Search Level·Cell Qty/A/S)을 숨겨 `expandSearchArea` 가 펼친 줄 알고 넘어가 G1 '칸 없음' 7건 → 크기 0 인 formItem 이 있으면 토글을 눌러 펼치고(줄지 않으면 원복) 진단 스펙(DOM 덤프)으로 14칸 전부 보임 확인(05:01). 재생성 3차(05:03~) 추가 교정(35f/35g): ⓙ 라벨 없는 체크박스/라디오 칸(hook #154 · FormItem 1자식 'Cell Qty / A/S')은 MuiFormControlLabel 텍스트로 찾는 findCond 폴백 ⓚ 정적 Form 라벨 추출이 조건 일부를 놓치면(labelText 변수·문자열 조합 — SCP0100 'Model / Nick Name'·'Search Mode'·'Period') E2E 가 그 칸을 찾은 사실이 우선 → H5 PASS, 그 화면의 정적 G4 순서는 NA(SC1 E2E smoke 기준표 순서로 판정) ⓛ 05:50 FE(Vite 5173) 다운으로 부분 재실행이 ERR_CONNECTION_REFUSED — 재기동 후 재실행(검사기 결함 아님 · 결과 봉투에 FE 미응답은 exit 5). 유지(진짜 결함으로 남김): H8 숫자 포맷(소수 자리) · E1 숫자 범위 · E3 필수 표시 · A4 Division 재조회 잔존 · K3 · X-REOPEN pageerror · G4 순서(기준표와 다름, 1건) · D1 DAILY_CAPACITY(AS-IS 는 Div 42/44 외 잠금). 한계: 탭 전환 후 조건 검사·AS-IS 변수 대입값 해석은 미구현(수동 검수 W7 로 남김).
- 라운드 34(2026-10-28 22:25~22:30, 사용자: "SCP0096 저장 시 SQL ERROR 는 조치됐나요? CheckList 에서 빠진 건가요, 놓친 건가요?" → 놓친 것): `_verify` CRUD 검사가 **Insert 와 Save 두 버튼이 모두 있어야** 저장을 실행하고, 없으면 E3 '판정필요' 로 끝내 F1/F2/F4/F6 저장 검사를 통째로 건너뛰었다(SCP0096 같은 수정 저장형 화면은 저장 경로가 한 번도 실행되지 않아 저장 SP 오류를 잡을 수 없는 구조). 교정 ① Save 있음 + Insert 없음 = 수정 저장형: 스모크 CRUD 와 같은 `lib/crud.ts crudCycle`(셀 1칸 수정→Save→재조회 반영→원복 Save→재조회 복원)로 F1(DB 반영)·F2(Save 1회 성공)·F4(SQL 오류·HTTP·결과 CODE)·F6(값 보존) 판정, E3 = NA(신규행 시나리오 없음) · Save 없음 = NA(조회 전용/권한) · 편집 가능 셀 없음 = NA, 편집 판정 불가 = ERROR. ② 저장 SP 의 TRACE F4 행(`_trace` 가 '저장 경로 — @verify CRUD 실저장 행에서 판정' 으로 NA 둔 행)을 두 경로(Insert·수정 저장) 모두에서 실제 저장 호출(sheet/btn 일치)로 판정(`judgeSaveSp`, tobe_ref 'E2E @verify CRUD 실저장' 은 flush 의 @trace 보호를 넘는다) — 그동안 SCP0007 SAVE_BOD 도 NA 로 남아 있던 빈틈. 결과(SCP0096 CRUD 22:25:55→22:26:18, 꼬리 22:29:49→22:30:36, v9): 수정 저장 2회 HTTP 200 · 결과 커서 RESULT_CODE S · SQL 오류 없음 → F1/F2/F4/F6 PASS, SAVE SP TRACE F4 PASS. **이 경로(Div 81 · 셀 1칸 Y→N→Y)에서는 저장 SQL 오류가 재현되지 않았다** — 사용자가 본 오류의 시각·문구가 있으면 BE 로그(nscm.log)에서 추적한다. 한계: 수정 저장형 검사는 편집 가능 셀 1칸만 바꾼다(다건·일괄 입력·Bucket 전환 뒤 저장은 미측정).
- 라운드 30~33(2026-10-28 저녁, SCP0096 CheckList 1~11행 '대부분 판정오류' 지적 — 사용자: "SCP0007 로 90번 넘게 만들었는데 기본 판단 오류, 다른 작업 전에 제대로 만드는 것이 먼저"): 엔진이 SCP0007 한 화면에 맞춰져 있던 것이 근본 원인. 교정 ① `form_labels`/META I1·I4 가 `t('LBL…')` 문자열 코드만 읽어 `t(LBL.KEY,'_x')`·`multi(LBL.KEY,'_x',…)` 화면은 라벨 0건 → G4/H5 전부 허위 FAIL(공용 `label_codes()`·`lbl_consts()`) ② 조회 완료 신호가 `'bod'` 시트로 고정(9곳) → 다른 화면은 60초 상한을 다 채워 L1 77초 허위 → plan.mainSheets 기반 `isMainSheet` ③ SCP0007 전용 시나리오(To Site/Route/Incoterms, 팝업 트리거·붙여넣기 열)는 그 컬럼이 있는 화면에서만(`COLS`/`has()`) ④ **측정 실패 ≠ FAIL**: 조건 계산 불가·입력 실패·팝업 감지 실패·golden 미실행·타입 미확인 등은 ERROR(미검증 시트)로(E2E 쪽 + judge 안전망 `RX_TOOLFAIL`) ⑤ 결과를 쓰지 않는 AS-IS SP 호출(`dtBucketType = GetBucketType();` 이후 미참조)은 F4 배선 대상 아님(NA, AS-IS 원문 참조 수 실측) ⑥ E4 성공 분기(`t.Success`) 메시지는 위반 입력 대상 아님(NA) · MS1 은 같은 유형(저장 성공 등) ID 인정 ⑦ CR-071: 기준표에 없는 AS-IS 조회조건(버튼 영역 이동 chkSum·usrButton1)의 요소 검사는 NA ⑧ Division 변경 뒤 그리드 비움 = TO-BE 룰(KEEP E2) PASS, 자동 재조회는 룰 위반 FAIL ⑨ 판정필요는 A1 만 — 나머지 요소·직접 E2E 판정 행은 NA(수동 검수 W7), 상속 집계에서 요소 ERROR 는 미검증 ⑩ 쉬운 설명 템플릿의 SCP0007 고유 문구 제거(대상·증거에서 도출). 결과: SCP0096 v1 조치 필요 23 → v5 3 → **v6(전체 재실행 21:20:44→21:36:15, E2E 14.2분 21/22 통과) 2**(A6 정렬 키 다름 · C4 Division 변경 시 자동 재조회 — L1 77초는 'bod' 대기 결함이었음을 재실측으로 확인) · 판정필요 30(A1 28+집계 2) · 미검증 26(D3 14·G1 11) · SCP0007 v84 조치 필요 5(변동 없음). 교훈: 새 화면 1개를 CheckList 에 통과시키기 전에는 엔진이 화면 독립적이라고 말할 수 없다 — 자기검증(변이 시험)에 '다른 화면 1개' 축을 추가해야 한다.
- 라운드 26(사용자 v77 질문 2건): ① 조치 필요 6번 H2 Set_ValidTextColor — 검사기가 Division 셀(보이는 2번째 컬럼) 색을 Y/N 행끼리 비교해 항상 '색 차이 없음' FAIL(검사기 결함) → AS-IS 규칙대로 Route Valid=N 행 Trans Mode~Distribution Total 회색(189,189,189)·Route Check≠Y 행 Route Id 빨강 실측으로 교체. TO-BE BodGrid formatItem 은 두 규칙을 같은 색 상수로 구현(화면의 빨간 Route Id = Route Check≠Y 표시). 재실측 표식 행에는 옛 '사용자판정'(구현 필요)을 덮지 않음. ② 조치 필요 7·8번(팝업 선택 후 커서) — 커서 측정 전에 BOD_VALID 편집 가능 프로브가 셀을 선택해 28열로 옮긴 뒤 측정한 허위 FAIL → 팝업 닫힌 직후 선택 셀을 먼저 캡처.
- v77(14:08:16→14:09:53, 사용자 v75 의견 11건 반영): 조치 필요 = 요소 실측 FAIL 만(결함일반화·결함원장·확정규칙 상속 행 제외 — 같은 내용 중복) · 같은 규칙·대상·증거 1건 + '같은 내용 n건' · 쉬운 설명 한 문장(FAIL_SHORT 템플릿 — 사용자 문구 E2/G2/C6 채택) · A6 실측 순서는 골든 인자 분기 1행만 · E6 한글 IME = CDP 모사 한계 → NA(사용자 판정오류 → PASS). 결과 FAIL 78 · NA 343 · PASS 1530 · 판정필요 27(A1) · **조치 필요 8**.
- v75(꼬리 체인 13:03:06→13:06:46, E2E 재실행 없음): FAIL 81 · NA 342 · PASS 1528 · **판정필요 27 = A1 만** · 조치 필요 17. v73→v75 차이 = TO_YYYYMMDD 허위 FAIL(popMap 오귀속) 1 + 그 집계·상속 23 → PASS/NA, K3 부분 실측 7 → NA(W7), C6 원천 해석 한계 1 → NA(W7).

**한계(정직 보고)**: 순서 대조는 '공통·유일 행' 만 본다(한쪽 전용 행·중복 행은 제외). 센티널·NULL 위치 검출은 원인 후보 표시이며 ORDER BY 키를 모르는 상태의 휴리스틱 — 최종 원인은 PKG ORDER BY 원문(sort_check)으로 확인한다.

### 11.5 2026-10-30 검증엔진 재설계(WP0~WP9) — "오류는 못 거르고 정상만 오류로" 의 구조적 원인 제거

사용자(2026-10-30): SCP0111 CheckList 가 실제 확인된 오류 8건 중 1건만 판정 · SCP0100 은 정상 6건을 오류로. "지금 수준의 CheckList 는 쓰레기 — 3개 문서의 오류를 다 추출할 수 있게 검사 엔진을 다 추가하고, 실행 오류 소지를 줄이고, 테스트 결과를 자동 보완/보정의 입력으로". 원인·설계 전문 = `C:\Users\ejene\.claude\plans\expressive-hatching-hickey.md`, 유형 = `_checker_defects.md` T11~T15.

| WP | 무엇 | 파일 |
|---|---|---|
| 0 전제 게이트 | plan/스펙/smoke 없으면 **FAIL**(rc 6 · 서버 5) — `gen.js --plan-only` 가 Doc/gen 을 지우지 않고 e2e_plan.json 만 생성 · passed 인데 판정 0 = `[검증엔진 무판정]` ERROR | `prereq.py` · `gen.js` · `judge.py` |
| 1 동적 컬럼 | 런타임 피벗 컬럼 패밀리 `<DYNAMIC:CalendarMonth>`(binding 정규식·프레임워크 기본값) → D1/D5/E1/H8/H2/H13 행 → 프로브가 값 있는 행·빈 행 대표 측정 | `facts_dyncols.py` · `ledger.py` · `probe.ts` · `_verify.spec.ts` |
| 2 잠금 해석 | Def* 접두 전부 · `GetColumnIndex(A)..(B)` 범위 · Insert 체인(InsertRow) · 가드 정규형(`GROUP`·`DIV`·`COL(X)[a:b]`·`COL(SELF)`) · 잘린 가드는 원문에서 재읽기 · `RULES:[…]` JSON → E2E `condeval.ts` 가 계정 그룹·조회 Division·행 값으로 평가(만족/불만족 행 각 2) · 해석 실패 = `[잠금 해석 실패]` ERROR | `facts_lockrules.py` · `condeval.ts` · `_verify.spec.ts` |
| 3 저장 경로 | Insert 실패 시 기존행 수정 저장(edit-save)으로 폴백 · 셀 수정 후 저장 호출 0건 = **FAIL** · 편집 셀 없음 = `[측정 경로 누락]` ERROR | `_verify.spec.ts` · `crud.ts` |
| 4 C4 | AS-IS `*Changed` 핸들러(+피호출)의 GRID_CLEAR 문장 → events.csv 로 조건 컨트롤에 귀속 → C4 인스턴스 | `mapping_checks.csv` · `mapping_trace.py` |
| 5 G3·K4 | Condition 저장 키 ∩ AS-IS ConditionNotUseList = FAIL · 저장→재진입 복원 · Reset 뒤 화면값 유지(사용자 결정 AS-IS 대로) · Edit 버튼 없음 = CR-093 · to_ledger 되먹임 제거(측정 TRACE 행 보존) | `gen-e2e.js` · `smoke-extra.ts` · `confirmed_requirements.csv` · `mapping_trace.py` |
| 6 dead 전파 | 조건 JSON `"dead"` 를 `_trace`/`_verify`/`judge not_target` 전부 존중(SCP0041 SCP0040 F4) | `mapping_trace.py` · specs · `judge.py` |
| 7 숫자 사실 | 프레임워크 기본값 CSV(NegativeRed·blFixedPoint·min/max) → cell_rules `negative_red/fixed_point` → E1 '정수만' · **H13** 음수 글자색 | `facts_gridcols.py` · `facts_cellrules.py` · `_verify.spec.ts` |
| 8 게이트 | 놓친결함 오라클 `_missed_oracle.csv`(FAIL/NOT_FAIL/NA 기대) → `regress.py` 위반 시 run_verify **rc 10** · `coverage.py`(규칙별 측정/미실행/NA + SUSPECT_NA100) → 봉투 `summary.coverage` | `regress.py` · `coverage.py` · `run_verify.py` |
| 9 신설 검사기 | H11 로딩 표시 · H12 고정 컬럼(frozenColumns↔FIXED_FLAG) · G10 팝업 Enter · M2 특수 버튼 반응 · J3 대체 계정 재평가 · C5 하단 조회 인자 · F10 저장 PROC 원자성(ALL_SOURCE) · A9 동적 헤더 · D2=D1 동적 COND · B5=B4 필터 원천 · **F9 미구현(명시)** | `_verify.spec.ts` · `f10_check.py` · `mapping_checkdefs.csv` |

운영 규칙: 새 검사기는 ① 오라클 행 먼저 ② `coverage.feature_present` 근거 ③ 측정 실패 = ERROR ④ 증거에 TO-BE 보완 위치 힌트(자동 보완 입력).

## 12. 근거 등급 · 독립 판정 · 결과 봉투 — 2026-10-26 추가

> 사용자 지시: Atlas Studio 규약 중 "통과 근거 등급"·"검토자 분리" 를 적용해 정합검증서를 만들고 이후 보완에 도움이 되게, "결과 형식 통일" 은 추천 범위에서. 원칙: **AI 판단만으로는 통과시키지 않는다**(정직 보고 #126 의 확장).

| 구성 | 파일 | 하는 일 |
|---|---|---|
| 근거 등급(정합검증서) | `make_verify_docs.py` `evidence_grade` | 행마다 판정 출처(tobe_ref·증거 앞머리)로 등급: 기계 · 기계(상속·집계) · 사람 · AI 작성·인용 확인 · AI 판단만 · 출처 미기록 · 없음. **AI 판단만인 PASS·해당없음은 문서에서 판정필요로 센다**(원장 값 보존). 요약 시트 '근거 등급 × 결과' |
| 종결 근거(보완대상) | 같은 파일 `close_evidence` | 보완 후 '해결' 로 인정하는 조건(판정 방법별 기계 재판정 또는 사람 판정). 보완 세션의 자기 보고(fixlist status)는 종결 근거가 아니다. fixlist.csv `grade`·`close_evidence` |
| 결정표 작성자 | `decisions.py` | `by` 필수. AI 답의 P·N 은 `evidence_ref`(경로:줄)+`evidence_quote`(원문 인용) 기계 확인 시만 반영, AI 의 F 는 반영 |
| 근거 확인기 | `evidence_check.py <봉투>` | 인용(경로:줄 + 원문)이 그 위치(±3줄)에 실제로 있는지. 줄 없는 CSV 는 같은 한 줄에 토큰 전부. 인용 없는 줄 번호 = 미확인 |
| 독립 판정 | `tools/Harness/e2e-judge.js <ID> <kind>` | 🩹 수선 뒤 새 Claude 세션·읽기 전용으로 실패 원인 재분류 → 근거 확인 → `decision.expectFix`(보정 허용) / `decision.human`(사람 확인 큐 `Doc/e2e/_human_review.md`) |
| 테스트 약화 검사 | `weaken_check.py <ID> --snapshot/--compare` | 시험 기준 보정 전후 검사 감소·skip 증가·예외 삼키기·파일 삭제 → 걸리면 HOLD |
| 결과 봉투 | `envelope.py` ↔ `tools/Harness/lib/envelope.js` | `Doc/verify/<ID>/run_verify.result.json` · `Doc/gen/<ID>/E2E_REPAIR.result.json` · `Doc/gen/<ID>/CHECK.result.json` — state·verdict·summary·issues·evidence. 없음·깨짐 = error |

**한계(정직 보고)**: 근거 확인기는 인용 원문이 그 위치에 있는지만 본다 — 그 인용이 해당 행·실패와 관련 있는지는 기계로 판단하지 못한다. 그래서 'AI 작성·인용 확인' 은 '사람' 과 다른 등급으로 표시하고, 관련성은 사람 확인을 권한다. 약화 검사는 기대값 리터럴을 실측값으로 바꾼 '의미 약화' 를 지표로 잡지 못한다 — 그래서 보정 대상 자체를 근거 확인 항목으로 제한한다.
- 판정 우선순위(2026-10-27): 같은 검증 ID 를 `_verify.spec(@verify)` 와 `_trace.spec(@trace)` 가 모두 판정하면 **정밀 엔진 @trace 가 이긴다**(`_verify` flush 가 `E2E @trace` 행을 덮지 않음 — Playwright 파일 순서 `_trace`→`_verify` 때문에 생긴 되돌림 차단). 검사기 공통 원칙: 요소는 매번 다시 찾는다(`findCond` 태그 제거 `fc`, Insert 뒤 기존행은 CRUD_TYPE 로 재탐색) · 코드/NAME 표시는 AS-IS 조회 시점 표시와 비교 · 화면 규칙 집계 분모 = 요소 실측만.

## 감·예측 답변 금지 (사용자 상시 지시 2026-10-31 · hook #126 §0-1)

수치·진행율·소요 시간·원인·결과를 감이나 예측으로 답하지 않는다. 답은 이번에 실행한 측정·로그·파일·DB 조회 결과만 인용하고 그 출처와 시각을 함께 적는다. 측정하지 못했으면 '미측정'이라고 쓰고 측정 방법을 제시한다. '~할 것으로 기대', '약 N분', 'N% 쯤' 같은 추정 표현과, 원인을 확인하지 않은 단정을 금지한다. 진행율은 분모·분자를 명시한 실측값만 쓴다(정합검증 = tools/Harness/verify/doc_proof.py 출력).
