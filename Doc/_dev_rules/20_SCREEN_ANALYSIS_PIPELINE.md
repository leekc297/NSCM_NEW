# 20. 화면 분석서 (Screen Analysis Artifact) 생성 파이프라인 룰

> ⚠️ **최우선 룰**: [`hooks/anti-simplification.md`](hooks/anti-simplification.md) (2026-05-22 신규) — 화면 분석서 작성 시 작업 단순화 절대 금지. 화면별 .cs 처음~끝 Read 의무, xlsx 13시트 모두 filled cells 30+ 의무, "메타 자동 생성 일괄 자동화" 금지.
>
> **목적**: As-Is GSCM 화면별 분석 산출물을 누락/꼬임 없이 일관되게 생성하기 위한 전체 파이프라인 룰.
> **대상**: 인간 개발자 + AI(Claude) — 화면 분석서 신규 작성, 보강, 재생성 시 본 룰을 1차 참조.
> **위반 시**: 카운트 일치 의무 위반 + 시각 자료 누락 → PR reject.
> **이력**: 2026-05-19 신설. 27_DM 14건 꼬임 + 28/29 시트 누락 + Mockup 누락 사고 4건 종합 정리. 2026-05-22 anti-simplification 룰 참조 추가.

---

## 1. 화면 분석 산출물의 정의

NSCM의 각 As-Is GSCM 화면은 두 가지 형태로 산출물이 보존된다:

| 자료 | 위치 | 신뢰 우선순위 |
|---|---|---|
| **MD 파일 8종** | `Doc/_analysis/domain_{DM\|Common\|SCM\|FP\|SCP\|SSP}/screens/{ScreenId}/` | **1차** (Source of Truth) |
| **xlsx 12시트** | `{27\|28\|29}_*_Screens/{prefix}_{ScreenId}.xlsx` | 2차 (보조, 시각 자료) |

### 1.1. MD 8종 (1차 신뢰)

```
Doc/_analysis/domain_DM/screens/DMF0020_SalesFuturePrice/
├── analysis.md        — 화면 종합 분석
├── source_links.md    — Legacy 소스 경로
├── web_components.md  — As-Is 컨트롤 → To-Be 매핑
├── tobe_design.md     — To-Be React 화면 설계
├── oracle_migration.md — T-SQL → PL/SQL 변환 가이드
├── figma_link.md      — Figma 디자인 링크
├── validation.md      — Validation 추출 (MSG####)
└── expressions.md     — Spread/Grid 계산식 추출
```

### 1.2. xlsx 12시트 (2차 신뢰)

| 시트 | 입력 | 내용 |
|---|---|---|
| 1_화면개요 | 메타 + 정량 집계 | 화면 ID, 도메인, ClientSize, 컨트롤/이벤트/SP/Table 수 |
| 2_Layout | SVG + PNG | mockup 시각 자료 (룰 19 참조) |
| 3_UI목록 | `phase2b_screens.json` controls | 컨트롤 목록 (Field Name / Category / Type / Width / Height 등) |
| 4_Event | `phase2b_screens.json` event_handlers + .cs 본문 | 이벤트 핸들러 + Call Chain |
| 5_기능 | 4_Event 기반 재구성 | 기능 단위 (F001~) + To-Be REST API |
| 6_APIEndpoint | `phase3_{domain}.json` sps | API 엔드포인트 매핑 |
| 7_연결SP | `phase3_{domain}.json` sps | SP 상세 (Lines/복잡도/Tables/동적SQL 등) |
| 8_연결Tables | sps의 tables 합집합 | 연결 Tables + 도메인/의미 추정 |
| 9_변경이력 | .cs 주석 추출 | 일자/식별자 + 내용 |
| 10_ToBe권장 | 표준 템플릿 | UI/Grid/API/State/Validation/Expression 매핑 |
| 11_Validation | .cs 원소스 직접 파싱 | MSG####, MessageBox.Show, 사전 검증 |
| 12_Expression | .cs 원소스 직접 파싱 | Spread/Grid 계산식, LockRange, Cell.Formula |

---

## 2. 핵심 원칙

### 원칙 1 — MD = Source of Truth, xlsx = 보조
- MD 파일이 진실의 원본. xlsx 1~10 시트는 MD를 기반으로 재생성 가능
- xlsx 11/12 시트는 별도 추출기로 .cs 원소스를 직접 파싱 → MD 동기화 필수
- 의심 시 항상 **MD를 우선 신뢰**한다 (룰 09 §1 원칙 4)

### 원칙 2 — 12시트 풀스코프 의무
모든 화면 분석 xlsx는 정확히 12개 시트를 가진다. 단순 화면이라도 시트는 모두 존재해야 한다 (내용이 적을 수는 있음).
> 28/29 폴더의 이전 상태(시트 3개만 존재)는 **이상 상태**이며 풀스코프로 보강 완료(2026-05-19).

### 원칙 3 — 카운트 일치 의무 (PR 머지 게이트)
```
MD 카운트 == xlsx 카운트 == To-Be 코드 적용 건수
```
- `validation.md` 행 수 == `11_Validation` 시트 행 수 == To-Be useXxxValidation hook 항목 수
- `expressions.md` 행 수 == `12_Expression` 시트 행 수 == To-Be Wijmo cellTemplate 항목 수
- 누락 0건. 1건이라도 누락되면 PR reject.

### 원칙 4 — Mockup 누락 금지
xlsx 2_Layout 시트는 다음을 모두 만족 (룰 19 참조):
- KOR/ENG SVG 두 벌 (`{ScreenId}_Mockup_{KOR|ENG}.svg`)
- PNG 임베드 (`xl/media/image1.png` 크기 > 10KB)
- 시트 텍스트에 SVG 파일명 + 화면 패턴 + 컨트롤 통계 명시

### 원칙 5 — 백업 + 정정 안내 필수
화면 분석 산출물을 재생성할 때:
- 원본 xlsx를 `__bak_YYYYMMDD/` 폴더에 백업
- 꼬임/손상 발견 시 격리(`__corrupted__/`) + 안내 파일 작성
- 작업 일자 + 도구 + 정정 사유를 시트 또는 README에 기록

### 원칙 6 — 화면 ID 불일치 검증
xlsx를 새로 만들거나 갱신할 때 다음 일치성을 검증:
```
파일명 ScreenId == 1_화면개요 ScreenId == 11_Validation 헤더 ScreenId == 12_Expression 헤더 ScreenId
```
불일치 시 즉시 작업 중단 + 원인 추적.

---

## 3. 데이터 원천 (Source) 인벤토리

### 3.1. JSON 메타 (정적 분석 결과)
| 파일 | 도메인 | 키 | 용도 |
|---|---|---|---|
| `_analysis/_scan/phase2b_screens.json` | 전체 | `designs[].controls`, `event_handlers`, `class_name`, `line_count` | 3_UI목록, 4_Event |
| `_analysis/_scan/phase3_dm.json` | DM | `sps`, `tables`, `screens` | 6/7/8 시트 (DM 도메인) |
| `_analysis/_scan/phase3_common.json` | Common | `sps`, `tables`, `endpoints` | 6/7/8 시트 (Common) |
| `_analysis/_scan/phase3_scm.json` | SCM | `sps`, `tables` | 6/7/8 시트 (SCM) |
| `_analysis/_scan/phase3_fp.json` | FP | (동일) | 6/7/8 시트 (FP) |
| `_analysis/_scan/phase3_scp.json` | SCP | (동일) | 6/7/8 시트 (SCP) |
| `_analysis/_scan/phase3_ssp.json` | SSP | (동일) | 6/7/8 시트 (SSP) |

### 3.2. Legacy 소스
- `Doc/_legacy_source/06_UIL/{domain_DM|domain_Common|...|common}/` 하위의 `.Designer.cs`, `.cs`, `.csproj`, `.resx`
- 1~10 시트 빌드 시 1차 참조

### 3.3. MD 산출물
- `Doc/_analysis/domain_{DM|Common|SCM|FP|SCP|SSP}/screens/{ScreenId}/*.md` (8종)

### 3.4. 화면 카탈로그
- `Doc/_analysis/domain_{domain}/INDEX.md`
- `Doc/_analysis/INDEX.md` (전체 진입점)

---

## 4. 표준 빌더 파이프라인

화면 분석 산출물을 새로 만들거나 보강할 때 다음 순서로 진행한다.

### Step 1 — 진입점 확인
```
필수 확인 자료:
  ✓ Doc/_analysis/domain_{X}/screens/{ScreenId}/ (8 MD가 모두 존재?)
  ✓ Doc/_legacy_source/06_UIL/.../{ScreenId}.cs / .Designer.cs
  ✓ _analysis/_scan/phase2b_screens.json (designs에 {ScreenId}가 있는가?)
  ✓ _analysis/_scan/phase3_{domain}.json (sps에 {ScreenId} prefix가 있는가?)
```

### Step 2 — 백업
```
mkdir -p {xlsx_dir}/__bak_YYYYMMDD/
cp {xlsx_dir}/{file}.xlsx {xlsx_dir}/__bak_YYYYMMDD/
```

### Step 3 — xlsx 1~10 시트 빌드
사용 빌더: `build_screen_xlsx.py` (DM) / `build_28_29_full.py` (Common/SCM)
- 1_화면개요: 메타 + 정량
- 2_Layout: SVG 파일명 + 컨트롤 통계 (PNG는 Step 5에서 임베드)
- 3_UI목록: phase2b controls
- 4_Event: phase2b event_handlers + .cs 본문 파싱
- 5_기능: 이벤트 → 기능 단위 재구성
- 6/7/8: phase3 sps + tables
- 9_변경이력: .cs 주석
- 10_ToBe권장: 표준 템플릿

### Step 4 — 11/12 시트 백업 복사
11_Validation / 12_Expression은 .cs 원소스 직접 파싱 결과로 별도 추출기가 만든 것이라 **새로 만들지 않고 백업본에서 그대로 복사**한다.
```python
copy_existing_sheets(wb_new, bak_path, ["11_Validation", "12_Expression"])
```

### Step 5 — Mockup SVG/PNG 생성
사용 빌더: `build_mockup_v2.py` (정형 GSCM 빌더 — 룰 19 참조)
1. KOR SVG 생성
2. ENG SVG 생성
3. ENG SVG → PNG 변환 (cairosvg, output_width=1400)
4. 2_Layout 시트에 PNG 임베드 (A9 위치)
5. 2_Layout 시트 R1~R7 텍스트 갱신

### Step 6 — 검증
```python
# 시트 12개 확인
assert wb.sheetnames == ["1_화면개요","2_Layout",...,"12_Expression"]

# 11/12 무손상 확인
assert md5(new["11_Validation"]) == md5(bak["11_Validation"])
assert md5(new["12_Expression"]) == md5(bak["12_Expression"])

# PNG 임베드 확인
import zipfile
with zipfile.ZipFile(xlsx_path) as z:
    media = [n for n in z.namelist() if n.startswith("xl/media/")]
    assert media, "PNG 임베드 누락"
    assert max(z.getinfo(n).file_size for n in media) > 10000, "PNG 너무 작음"

# SVG 파일 존재
assert os.path.exists(f"{xlsx_dir}/{sid}_Mockup_KOR.svg")
assert os.path.exists(f"{xlsx_dir}/{sid}_Mockup_ENG.svg")

# 화면 ID 일치
assert sid in overview_first_row
```

### Step 7 — 인벤토리 갱신
- 작업한 화면을 `Doc/_analysis/INDEX.md` 또는 도메인별 INDEX에 등록
- 작업 일지(README/PROGRESS.md)에 일자 + 변경 사유 기록

---

## 5. 자동화 스크립트 인벤토리

| 스크립트 | 위치 (예정) | 입력 | 출력 |
|---|---|---|---|
| `build_screen_xlsx.py` | `Doc/_analysis/scripts/` | Designer.cs + phase2b + phase3 | 27_DM xlsx 1~10 시트 |
| `build_28_29_full.py` | `Doc/_analysis/scripts/` | Designer.cs + phase2b + phase3 | 28/29 xlsx 12시트 풀스코프 |
| `build_mockup_v2.py` | `Doc/_analysis/scripts/` | Designer.cs + .cs | SVG KOR/ENG |
| `embed_svg_png.py` | `Doc/_analysis/scripts/` | SVG | PNG + xlsx 임베드 |
| `validate_screen_xlsx.py` | `Doc/_analysis/scripts/` (TODO) | xlsx | 검증 보고서 |
| `gen_asis_mapping.py` | `Doc/_analysis/scripts/` | MD + xlsx | `__asis-mapping__.md` 매트릭스 |
| `gen_i18n_msg_json.py` | `Doc/_analysis/scripts/` | validation.md | i18n JSON |

> 위 스크립트는 본 룰셋 v1 기준 outputs/ 디렉토리에 있으며, `Doc/_analysis/scripts/`로 이관 후 PR 머지 권장.

---

## 6. 사고 사례 (참고) — 재발 방지

### 사고 1: xlsx 1~10 시트 꼬임 (2026-05-18)
27_DM 14건의 1~10 시트가 다른 화면 데이터로 채워짐. 1단계 추출기의 캐시 재사용 버그.
- 발견: DMF0020 사용자 신고
- 영향: 14건 (DMF0003_1, DMF0003, DMF0008, DMF0009, DMF0013, DMF0014, DMF0020, DMF0021, DMF0037, DMF0038, DMF0039, DMF0045, DMF0048 + 손상 1건 DMF0035)
- 복구: 백업 + 1~10 시트 재빌드 + 11/12 백업본 복사

### 사고 2: 28/29 시트 2~10 누락 (2026-05-19)
28_Common 32개 + 29_SCM 16개가 처음부터 1, 11, 12 시트만 있고 2~10 시트 없음.
- 영향: 48건
- 복구: build_28_29_full.py로 풀스코프 보강

### 사고 3: 2_Layout PNG 미임베드 (2026-05-19)
28/29의 2_Layout 시트에 SVG 파일명 텍스트만 있고 PNG 없음.
- 영향: 48건 (28/29 전체)
- 복구: ENG SVG → cairosvg PNG → 2_Layout 임베드

### 사고 4: LayoutControl 자식 좌표 절대좌표 가정 (2026-05-19)
DevExpress LayoutControl 자식 컨트롤이 (0,0)으로 등록되는데 절대좌표 가정 → 모든 컨트롤 좌상단 겹침.
- 영향: SVG 빌더 v1 사용 화면 전체
- 복구: 정형 GSCM 빌더 v2 도입 (좌표 무시, 표준 레이아웃 배치)

### 사고 5: Spread 컬럼 정적 추출 시도 (2026-05-19)
GSCM 화면 거의 전체가 DB SP `GET_SPREAD_TITLE` 동적 컬럼인데 정적 추출 시도.
- 복구: 동적 마커 + 시뮬레이션 행으로 표준화

---

## 7. PR 머지 게이트 체크리스트

화면 분석 산출물 PR 머지 전 다음을 모두 확인:

```
☐ xlsx 시트 12개 정확히 존재
☐ 1_화면개요 R5 (화면 ID) == 파일명 ScreenId
☐ 11_Validation, 12_Expression 백업본과 MD5 일치 (무손상)
☐ 2_Layout 시트 PNG 임베드 (크기 > 10KB)
☐ KOR/ENG SVG 두 벌 동일 폴더 존재
☐ MD 8종 모두 존재 + 첫 H1 == ScreenId
☐ phase2b designs 카운트 ≈ 3_UI목록 행 수
☐ phase3 sps 카운트 == 6/7 시트 행 수
☐ validation.md == 11_Validation 행 수
☐ expressions.md == 12_Expression 행 수
☐ 백업 폴더(__bak_*/)에 원본 보존
☐ 변경 이력을 INDEX 또는 PROGRESS에 기록
```

---

## 8. 관련 문서

| 경로 | 내용 |
|---|---|
| `Doc/_dev_rules/09_WIJMO_VALIDATION_EXPRESSION.md` | xlsx 11/12 시트 룰 + 신뢰 우선순위 |
| `Doc/_dev_rules/19_MOCKUP_SVG_RULES.md` | mockup SVG/PNG 생성 룰 (v2) |
| `Doc/_dev_rules/hooks/screen-analysis-pre-build.md` | 작성 전 자기 점검 |
| `Doc/_dev_rules/hooks/screen-analysis-post-build.md` | 작성 후 검증 |
| `Doc/_dev_rules/hooks/screen-analysis-pre-submit.md` | PR 머지 전 최종 검증 |
| `CLAUDE.md` §Step 4 | 화면별 분석 자료 1차 참조 룰 |
