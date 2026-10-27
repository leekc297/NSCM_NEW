# 화면 정합검증 가이드 (AS-IS vs TO-BE)

> 2026-10-23 신설 · Vibe_Manager 기능 「🔎 화면 정합검증」 · 실행기 `tools/Harness/verify/run_verify.py`

## 1. 목적

사람이 단위테스트에서 찾은 오류를 시스템이 먼저 찾아내는 것이 목적입니다. 개발된 화면을 AS-IS 와 비교해 결함을 행 단위로 도출하고, 고칠 대상을 Excel 로 정리한 뒤, 사용자가 정한 범위 안에서만 보완합니다.

- 기준 정답지(수용 기준)는 사람이 수행한 단위테스트 결함 원장 **310건**입니다.
  - 공통·DM 285건: `C:\TRANFILE\RECEIVE\최종 단위테스트 결과 점검 (zio 관리) _ 202600826.xlsx` 의 `수정사항` 시트
  - SCP·SSP 25건: `SCP & SSP 단위테스트 결과 v1.0.xlsx` 의 `확인사항` 시트
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
| `tools/Harness/verify/detect_rules.csv` | 검출 규칙 카탈로그 |
| `Doc/verify/defects_classified.csv` | 결함 310건 × 규칙·정답·기대 |
| `tools/Harness/rules/confirmed_requirements.csv` | 확정 규칙(O2) |
| `tools/Harness/verify/facts_cellrules.py` · `facts_lockrules.py` | AS-IS 사실 보강 |
| `tools/Harness/verify/ledger.py` · `judge.py` · `make_verify_docs.py` · `run_verify.py` · `set_scope.py` | 원장·판정·문서·실행·범위 설정 |
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
- **2026-10-27 CR-073 셀 병합(사용자 판정 "셀병합 적용되어 있음 — 오류 아님")**: TO-BE 는 화면이 정한 키(그룹) 컬럼만 병합(BOD MERGE_COLUMNS 9) → 값 컬럼 미병합 7건 + Trans Mode(병합 대상이지만 왼쪽 비병합 컬럼 때문에 계층 병합 구조상 병합 안 됨) 1건 = PASS. `_trace.spec.ts` H3(`!mergeInfo.cols[b]` → PASS · `leftNoMerge` → PASS 권고) · judge `H3_CR073` 즉시 재판정 · hook datagrid §5.4 · 룰 D3.
- **2026-10-27 밤 — 사용자 재확인 3건 + 동시 실행**: ① 대조표 '미구현' 16행(To Site 유형별 콤보 분기) = **구현됨**(BodGrid `resolveToSiteBucket` · OSP_YN=Y 인 -A From Site 로 PLANT 분기 26건 = 사내 DB 원천 SQL 26건) → W9 G-F 는 '분기 존재' 로 판정하고 후보 집합 데이터 차이(2668 vs 2603)는 B4 행에 기록(`Doc/verify/<ID>/combo_expect.json` = 원천 SQL 직접 실행 기대값) ② D6 Insert 맨 위 = CR-074(사용자 판정) ③ C3 L/T Type = 재실측 PASS(이전 FAIL 은 측정 시점 오류) ④ 사용자의견 어휘 '판단오류·정상 확인' 반입 ⑤ 자동 검사기 없는 일반 규칙·결함원장 항목 = NA(수동 검수, 작업 원장 W4/W5) ⑥ 메뉴 접근 권한 없는 그룹의 auth 기록(menuAccess=N, expected 없음)은 J2 근거에서 제외. 주의: 사용자 측 run_verify(gen2·gen3, skip_e2e)가 같은 시각에 원장을 재생성(GENERAL 551행 추가)해 TRACE 요소의 E2E 결과가 비어 판정필요가 늘었음 → 전체 체인(E2E 포함) 재실행으로 정리.
- 타입체크: `tools/E2E/tsconfig.json` `paths`(@playwright/test) 추가 — `node nscm-fe/node_modules/typescript/bin/tsc --noEmit -p tools/E2E/tsconfig.json` 으로 스펙까지 검사(종전 `npx tsc` 는 tsc 미설치로 아무것도 검사하지 않았다).

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
