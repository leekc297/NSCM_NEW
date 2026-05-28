# Hook — Screen Analysis Pre-Build (작성 전 자기 점검)

> ⚠️ **이 Hook 실행 전 반드시 Read**: `Doc/_dev_rules/hooks/anti-simplification.md` (2026-05-22 신규)
> 작업 단순화 절대 금지 — 다중 패턴, Cross-check, 기존 자료 활용 의무. 위반 시 신뢰성 손상.


> **언제 사용**: 화면 분석서(xlsx + SVG + MD)를 새로 만들거나 보강하기 직전.
> **AI 동작**: 본 파일을 `Read` 한 후, 아래 체크리스트를 차례로 self-check 한 다음 작업 시작.
> **관련 룰**: `19_MOCKUP_SVG_RULES.md`, `20_SCREEN_ANALYSIS_PIPELINE.md`, `09_WIJMO_VALIDATION_EXPRESSION.md`

---

## 1. 자료 확보 자가점검

작업 대상 화면 ID를 `{ScreenId}` 라고 할 때, 다음 4개 자료가 모두 존재해야 작업을 시작할 수 있다.

```
☐ Doc/_legacy_source/06_UIL/.../{ScreenId}.cs            (메인 .cs)
☐ Doc/_legacy_source/06_UIL/.../{ScreenId}.Designer.cs  (Designer)
☐ _analysis/_scan/phase2b_screens.json 의 designs[class_name={ScreenId}]
☐ _analysis/_scan/phase3_{domain}.json 의 sps prefix 매칭
```

추가로 1차 참조 자료:
```
☐ Doc/_analysis/domain_{X}/screens/{ScreenId}/analysis.md
☐ Doc/_analysis/domain_{X}/screens/{ScreenId}/validation.md  (= 11_Validation 원본)
☐ Doc/_analysis/domain_{X}/screens/{ScreenId}/expressions.md  (= 12_Expression 원본)
```

**없는 항목이 있으면**: 1단계 사전 분석(phase2b/phase3 스캔)을 먼저 실행하거나, 작업 보류.

---

## 2. 기존 xlsx 상태 점검

```
☐ {xlsx_dir}/{prefix}_{ScreenId}.xlsx 존재 여부
☐ 시트 12개 여부 (1_화면개요 ~ 12_Expression)
☐ 1_화면개요의 화면 ID == 파일명 ScreenId (꼬임 검증)
☐ 11_Validation 헤더 == ScreenId
☐ 12_Expression 헤더 == ScreenId
☐ 2_Layout 시트의 xl/media/image1.png 존재 (PNG 임베드)
☐ 백업 폴더(__bak_*/) 존재 여부
```

**꼬임 발견 시**: 즉시 룰 09 §1 원칙 4 + 룰 20 §6 사고 1 참조 → 백업 후 1~10 시트 재빌드 절차.

---

## 3. 데이터 원천 정합성 점검

```
☐ phase2b designs[{ScreenId}].controls 수 ≈ 3_UI목록 행 수
☐ phase3 {domain}.sps[{prefix}_*] 수 ≈ 6_APIEndpoint 행 수
☐ phase2b designs[{ScreenId}].line_count ≈ .cs 파일 줄 수
☐ Designer.cs ClientSize ≈ 정형 mockup viewBox
```

---

## 4. 빌더 도구 사용 결정

다음 표를 보고 사용할 빌더를 결정:

| 작업 | 빌더 | 비고 |
|---|---|---|
| 27_DM 화면 1~10 시트 빌드 | `build_screen_xlsx.py` | DM 도메인 전용 |
| 28_Common, 29_SCM 화면 12시트 풀스코프 | `build_28_29_full.py` | Common/SCM 도메인 |
| Mockup SVG 빌드 (KOR/ENG) | `build_mockup_v2.py` | 정형 GSCM 빌더 |
| SVG → PNG 변환 + 임베드 | `embed_svg_png.py` | cairosvg 사용 |

> **금지**: Designer.cs 좌표 직접 매핑 빌더 v1(`build_mockup_svg.py`)는 폐기. LayoutControl 자식 좌표 한계로 mockup 깨짐 (룰 19 §7.3, 룰 20 §6 사고 4 참조).

---

## 5. Mockup 정책 결정

3가지 시나리오 중 하나:

### (A) 백업본 PNG가 자기 화면 정확히 가리키면
→ 백업본 PNG를 그대로 새 xlsx에 임베드. v2 빌더는 SVG만 생성 (보조 자료).

### (B) 백업본 PNG가 없거나 다른 화면 가리키면
→ v2 정형 빌더로 KOR/ENG SVG 생성 → ENG SVG → PNG → xlsx 임베드.

### (C) 화면 자체가 신규(레거시 .cs 없음)
→ MD/Figma 기반 To-Be mockup 생성 (별도 절차, 본 룰 범위 외).

**결정 후**: 어떤 시나리오인지 작업 일지에 기록.

---

## 6. 작업 일지 사전 작성

작업 시작 전 다음 항목을 결정/기록:
```
작업 일자        : YYYY-MM-DD
대상 화면        : {ScreenId}
도메인           : {DM|Common|SCM|FP|SCP|SSP}
시나리오         : (A) 백업 PNG 유지 / (B) v2 신규 생성 / (C) To-Be 신규
백업 폴더 경로   : __bak_YYYYMMDD/
변경 사유        : (꼬임 복구 / 시트 누락 보강 / 신규 화면 / ...)
```

---

## 7. 작업 시작 직전 마지막 확인

```
☐ 룰 19 (Mockup SVG/PNG) 읽었음
☐ 룰 20 (전체 파이프라인) 읽었음
☐ 룰 09 (Validation/Expression 신뢰 우선순위) 읽었음
☐ 사용할 빌더가 결정되었음
☐ 백업이 준비되었음 (__bak_YYYYMMDD/)
☐ Mockup 시나리오(A/B/C)가 결정되었음
```

모두 ✓이면 작업 시작. 하나라도 ✗이면 보류.

---

## 8. 절대 금지 (Top 5)

1. ❌ Designer.cs `Location/Size`를 절대좌표로 가정해 SVG 그리기 (LayoutControl 자식 겹침)
2. ❌ 2_Layout 시트에 SVG 파일명만 텍스트로 적고 PNG 미임베드
3. ❌ 11/12 시트를 새로 만들기 (백업본에서 그대로 복사해야 함, .cs 원소스 파싱은 별도 추출기 영역)
4. ❌ 백업 없이 원본 xlsx 덮어쓰기
5. ❌ 1_화면개요의 화면 ID가 파일명과 다른데도 작업 진행 (꼬임 무시)

---

## 9. 사용자 캡쳐 자료 사전 점검 (v6 신설, 2026-05-21)

캡쳐(`C:/Projects_Document/NSCM/AsIs_UI_Sample/` 또는 uploads)가 제공된 화면은 시작 전 다음 결정:
- 캡쳐별 다루는 영역: 메인 / 팝업 / Tab / 모드(편집/조회)
- 동적 UI 행동 식별: 우측 동적 컬럼 / 다단(2~3단) 헤더 / RowSpan + 동일키 그룹 다중 선택 / 그룹 동기 입력 / 팝업 모달
- 캡쳐 ↔ 기존 xlsx/MD 매핑 GAP → 신규 시트 후보(14_조회조건/15_DynamicColumns/16_GridHeader_3Tier/17_RowSpan_MultiSelect/18_Popup_*/19_Popup_*)

## 10. 팝업/연관 화면 Mockup 작성 룰 (v6.2 신설, 2026-05-21)

부모 화면 호출 팝업/연관 화면 SVG/PNG 생성 시 순서 엄수:

1. **1차 자료 — Designer.cs 정밀 분석** (Location/Size/Text/TabIndex/Type/계층). 사용자 캡쳐는 1차 자료 아님 (검증 도구).
2. **2차 — 의미적 재배치 SVG** (Designer.cs Location 절대좌표 사용 금지, ClientSize 비례 viewBox)
3. **3차 — 사용자 캡쳐 검증** (있으면 시각 비교, 없으면 TabIndex 순서/라벨/그룹화 정합성 검증)
4. **4차 — xlsx `2_Layout` 시트에 ENG PNG 임베드** + 룰 19 준수 안내

**캡쳐 ≠ 1차 자료** — 캡쳐에 안 보이는 컨트롤이 Designer.cs 에 있을 수 있음(사례: DMF0020_POPUP_Version 의 chkDay/chkWeek/chkMonth/txtDes 발견).

---

## 11. 컨테이너 계층 정밀 분석 룰 (v6.4 신설, 2026-05-21)

> **배경**: v6.3 일괄 자동화 빌더는 ClientSize / 컨트롤 수 / ColumnHeaderSpan / AddSheet 카운트만 보고 mockup 을 그렸으나, 실제 화면이 **SplitContainer 로 상하/좌우 분할** 되거나 **XtraTabControl + TabPage** 로 구성된 경우 구조를 표현하지 못했음. (사례: DMF0008 의 3단 구조 + 하단 spdSub 2-sheet 탭이 누락)
>
> **v6.4 룰**: 모든 화면 mockup 생성 시 다음 4종 컨테이너 계층을 반드시 파싱.

### 11.1 필수 파싱 패턴

```python
# 1. SplitContainer.Panel1/Panel2 자식
re.finditer(r"this\.(\w+)\.(Panel[12])\.Controls\.Add\(this\.(\w+)\)", ds)

# 2. XtraTabControl.TabPages.AddRange
re.finditer(r"this\.(\w+)\.TabPages\.AddRange\(\s*new[^{]*\{([^}]+)\}\s*\)", ds, re.DOTALL)

# 3. XtraTabPage Controls.Add (Tab 페이지 자식)
# instances[parent] == "XtraTabPage" 인 부모의 Controls.Add

# 4. Panel/GroupBox/UsrLayoutControl Controls.Add (조회조건 그룹)
# instances[parent] in ("Panel", "GroupBox", "GroupControl", "UsrLayoutControl")
```

### 11.2 Spread별 AddSheet 매핑 (.cs 본문)

```python
# AddSheet(spreadName, SpdSheet.SheetName, ...) 패턴
re.finditer(r"\bAddSheet\(\s*(\w+)\s*,\s*\w+\.(\w+)\s*,", cs_text)
# spread_name → [sheet_name1, sheet_name2, ...]
```

→ Spread 1개에 sheet 2개 이상이면 **Spread 내부에 sheet 탭** 으로 표시 (TabControl 처럼 보임).

### 11.3 의미적 레이아웃 매핑

| Designer.cs 구조 | Mockup 표현 |
|---|---|
| `SplitContainer.Panel1` + `Panel2` (Orientation=Horizontal) | 상하 분할 (Splitter 가로선) |
| `SplitContainer.Panel1` + `Panel2` (Orientation=Vertical) | 좌우 분할 (Splitter 세로선) |
| Panel1 자식에 `FpSpread` 2개 이상 | 패널 내부 좌우 또는 상하 분할 |
| 자식 `FpSpread` + `AddSheet ≥ 2` | Spread 위쪽에 sheet 탭 (TabControl 처럼) |
| `XtraTabControl` + N개 `XtraTabPage` | 상단 Tab 탭바 + 활성 페이지 표시 |
| `UsrLayoutControl` 자식이 콤보/체크박스/입력박스 | 조회조건 패널 |

### 11.4 자가점검 (작업 전)

```
☐ Designer.cs SplitContainer 인스턴스 수 (== 0/1/2+)
☐ Designer.cs XtraTabControl / TabPage 수
☐ .cs AddSheet(spreadName, ...) 호출별 spread 매핑
☐ 각 Spread 의 sheet 수 (1 = 단일 sheet, 2+ = 탭 형태)
☐ Splitter 분할 방향 (Orientation = Horizontal/Vertical)
☐ Dock 속성 (Top/Bottom/Left/Right/Fill) 으로 패널 배치 추정
```

### 11.5 사례 — DMF0008_ErpEdiMaster

- SplitContainer1 (상하분할)
  - Panel1: 조회조건(usrLayoutControl1/2/3) + **spdSummary** + **spdRepair** (FpSpread 2개)
  - Panel2: **spdSub** (FpSpread 1개)
- AddSheet 4회:
  - spdSummary → shtSummary (1 sheet)
  - spdRepair → shtRepair (1 sheet)
  - spdSub → shtSales_Site, shtSSPM (**2 sheets** = 탭 표시)
- v6.3 mockup 은 단순 Grid 한 개로만 그려 누락. v6.4 에서 3단 구조 + 하단 2-sheet 탭으로 정확 표현.

### 11.6 절대 금지 (v6.4 추가)

6. ❌ SplitContainer / XtraTabControl 존재하는데 단일 Grid 로 mockup 그리기 (구조 누락)
7. ❌ Spread 1개에 sheet 여러 개인데 sheet 탭 표시 안 함
8. ❌ 컨테이너 계층 표 (이 컨테이너의 자식 = ...) 분석서에 미명시
9. ❌ 사용자 캡쳐를 1차 자료로 쓰고 Designer.cs 분석 생략 (캡쳐에 안 보이는 컨트롤 누락 위험)
10. ❌ 캡쳐 1장당 매핑되는 시트 / MD 섹션 추적표를 작업 일지에 안 남기기


## 12. v7.0 통합 룰 (2026-05-21) — mockup 생성 전 의무 절차

> **본 룰은 v6.0 ~ v6.7 누적 룰의 통합. 모든 mockup 생성 시 본 §12 를 1차 룰로 적용.**

### 12.1 사전 점검 (각 화면별 .cs 정밀 분석 의무)

```
☐ 대상 화면 .cs 파일 (Forms.UIL 우선) 위치 확인
☐ 대상 화면 .Designer.cs 위치 확인
☐ AsIs_UI_Sample/{ScreenId}.png 캡쳐 존재 여부 확인
☐ POPUP 화면이면 POPUP 클래스의 .cs/.Designer.cs
```

### 12.2 일괄 자동화 금지 화면 (개별 손 작업 의무)

다음 조건 중 1개라도 해당되면 v3 빌더 결과는 검토용으로만, 손 작업 mockup 필수:

```
☐ 다단 Dock 중첩 (`Dock=Top` 3개 이상) — DMF0008 사례 (4단)
☐ SplitContainer + XtraTabControl 혼합
☐ Spread 2개 이상이고 각 Spread 컬럼 다름 (DMF0008, DMF0052 등)
☐ 사용자 캡쳐 (`AsIs_UI_Sample/{ScreenId}.png`) 제공
☐ ColumnHeaderSpan 11회 이상 (4단 이상 다단 헤더)
☐ POPUP 화면 (캡쳐 있음 → 캡쳐 기준, 없음 → Designer.cs 정밀)
```

### 12.3 정밀 추출 의무 항목 (v3 빌더 코드 참조: dm_v3_extract.py)

```
☐ ClientSize / Form Title
☐ DefColumns struct + 주석 그룹화 → Spread별 컬럼명 정확
☐ AddColumn / AddNumColumn 호출의 헤더 텍스트 + 바인딩
☐ ColumnHeaderSpan 호출의 row + 텍스트
☐ Designer.cs 모든 컨트롤 Location/Size/Text/TabIndex
☐ 컨테이너 계층 4종 (SplitContainer/XtraTabControl/Panel/UsrLayoutControl)
☐ Spread별 AddSheet 매핑
☐ Dock 속성 (Top/Bottom/Left/Right/Fill) — 다단 Dock 중첩 식별
```

### 12.4 한글 PNG 정책 (cairosvg + Linux 한계 대응)

- xlsx 2_Layout 임베드: **ENG PNG 사용** (한글 깨짐 없음)
- KOR SVG 원본 보관: Excel/브라우저/Inkscape 에서 한글 정상 표시
- KOR PNG 필요 시: **Playwright(Chromium)** 또는 Windows 환경 재변환

### 12.5 절대 금지 (v7.0 통합)

11. ❌ 일괄 자동화 빌더로만 mockup 생성 (개별 .cs 미확인)
12. ❌ DefColumns 추출 없이 "Col1, Col2" generic placeholder
13. ❌ Dock 중첩 구조를 단일 Grid 로 표현
14. ❌ KOR PNG 한글 깨짐 그대로 두기

### 12.6 사례 가이드

| 화면 유형 | 작업 방식 |
|---|---|
| 단순 Single Grid (DMF0006, DMF0007 등) | v3 빌더 자동 → 검토 |
| 다단 헤더 + 시간축 (DMF0020, DMF0021) | v3 → 다단 헤더 손 보정 |
| **Dock 중첩 다단 (DMF0008, DMF0052)** | **개별 .cs + 손 작업 의무** |
| Multi-Spread + Multi-Sheet | 개별 .cs 정밀 분석 |
| POPUP (캡쳐 있음) | 캡쳐 + Designer.cs |
| POPUP (캡쳐 없음) | Designer.cs + TabIndex 정합성 |


## 13. v7.1 영문(ENG) Mockup 표준 정책 (2026-05-21)

> **배경**: 한글 PNG 깨짐 — cairosvg+Linux 환경 한계 (Playwright/sudo 설치 모두 실패).

### 13.1 영문 표준 의무

```
☐ xlsx 2_Layout 임베드 PNG: **ENG 표준** (KOR PNG 절대 임베드 금지)
☐ KOR SVG 원본 보관: Windows 재변환용 (Inkscape/Edge headless)
☐ MD 의 "Mockup 파일" 섹션: KOR/ENG SVG + KOR/ENG PNG 4벌 모두 명시
```

### 13.2 절대 금지 (v7.1)

15. ❌ xlsx 2_Layout 에 한글 깨진 KOR PNG 임베드
16. ❌ KOR SVG 원본 미보관

### 13.3 mockup 생성 시 권장 흐름

1. KOR/ENG SVG 양벌 생성 (원본 보관)
2. ENG SVG → ENG PNG (cairosvg, 한글 깨짐 없음)
3. xlsx 2_Layout 에 **ENG PNG** 임베드
4. KOR PNG 가 필요하면 Windows 에서 별도 변환 (outputs/convert_kor_svg_to_png_windows.ps1)


## 14. v7.2 — 일괄 자동화 절대 금지 (최우선 룰, 2026-05-21)

> **이 룰은 §1~§13 의 모든 룰을 압도하는 최우선 룰입니다.**

### 14.1 의무 절차 (단일 화면 → 단일 mockup)

```
[필수] 화면 1개 선택 → .cs / .Designer.cs 단일 Read
[필수] DefColumns / AddColumn / Designer 라벨 / 컨테이너 계층 정밀 추출
[필수] 개별 SVG 손 작성 (자동 빌더 결과는 검토용)
[필수] 캡쳐 검증 (있으면 시각, 없으면 TabIndex/라벨)
[필수] ENG PNG → xlsx 2_Layout 임베드
```

### 14.2 절대 금지 (v7.2 최우선)

18. ❌ **일괄 자동화 빌더만으로 mockup 생성 후 검토 없이 산출**
19. ❌ 화면별 .cs 파일을 읽지 않고 mockup 생성
20. ❌ POPUP mockup 도 일괄 처리
21. ❌ 한글 KOR PNG 가 깨진 상태로 xlsx 임베드

### 14.3 작업 시작 전 체크

```
☐ 작업 화면 ID 1개 명시 (배치 처리 금지)
☐ 해당 화면 .cs / .Designer.cs 파일 위치 확인
☐ Read 도구로 .cs 본문 읽기 (DefColumns 추출용)
☐ Read 도구로 .Designer.cs 본문 읽기 (Location/라벨 추출용)
☐ 캡쳐(AsIs_UI_Sample/{ScreenId}.png) 존재 여부 확인
☐ POPUP 화면이면 POPUP 클래스 .cs/.Designer.cs 도 단일 Read
```

위 6건 모두 ✓ 후에만 mockup SVG 작성 시작.


---

## §15. v7.3 — "소스기반 정밀 손 작업" 최우선 의무 (2026-05-21 사용자 지시)

### 15.1 작업 시작 전 자기 점검 (반드시 모두 ✓)

```
☐ [v7.3 의무] 화면별 .cs 파일을 직접 Read 했는가?
☐ [v7.3 의무] 화면별 .Designer.cs 파일을 직접 Read 했는가?
☐ [v7.3 의무] 컨테이너 계층(SplitContainer/Tab/Panel/UsrConditionPanel/UsrLayoutControl) 정밀 추출했는가?
☐ [v7.3 의무] 조회조건 컨트롤(라벨/타입/Position/Size) 모두 추출했는가?
☐ [v7.3 의무] Grid AddColumn/AddTextColumn/AddNumColumn 헤더+필드+너비+Editable 모두 추출했는가?
☐ [v7.3 의무] DefColumns struct의 모든 필드 추출했는가?
☐ [v7.3 의무] ButtonList의 ButtonItem.UserText/UserType + 권한별 visible 제어 모두 추출했는가?
☐ [v7.3 의무] 화면당 빌더 함수 1개로 작성하는가? (여러 화면 1개 함수 금지)
☐ [v7.3 의무] ENG 표준으로 작성하는가? (cairosvg KOR 깨짐 회피)
☐ [v7.3 의무] 캡쳐 있으면 1:1 시각 검증 계획이 있는가?
```

**1건이라도 ✗ → 작업 중단, 자료 보강 후 재시작**

### 15.2 절대 금지 (v7.3 추가)

22. ❌ v3 빌더(`dm_v3_gen_all.py`)만으로 mockup 생성 → 반드시 화면별 손 작업 빌더 사용
23. ❌ 화면별 .cs / .Designer.cs Read 없이 mockup 생성 → 즉시 작업 중단
24. ❌ 여러 화면을 1개 함수로 처리 → 화면당 빌더 1개 의무
25. ❌ KOR PNG 깨진 상태로 작업 진행 → ENG PNG 표준 채택
26. ❌ analysis.md "일괄 자동화 사용" 표시를 "예"로 둔 채 mockup 산출 → "아니오 (수작업)"로 명시

### 15.3 추출 메타 → SVG 매핑 체크리스트

| Designer.cs / .cs 요소 | SVG 매핑 |
|---|---|
| ClientSize | SVG viewBox |
| usrConditionPanel1 | 상단 panel 박스 |
| UsrLayoutControl + LayoutControlItem.Text | 라벨 텍스트 |
| UsrCombo | combo 박스 + 화살표 |
| UsrCheckedList | 체크박스 리스트 |
| UsrDateRangePicker | 2개 textbox + `~` 구분자 |
| UsrButtonList + ButtonItem[] | 우측 버튼 그룹 + 권한별 disabled 스타일 |
| SplitContainer | 좌우/상하 분할 박스 |
| XtraTabControl + XtraTabPage | 상단 탭 바 + active 표시 |
| FpSpread + AddSheet | Grid + Sheet 탭 |
| siXxx.AddTextColumn("Header", DefColumns.X, ..., width, editable) | Grid 컬럼 헤더 + 너비 + lock 표시 |

### 15.4 변경 이력

- 2026-05-21 (v7.3): "소스기반 정밀 손 작업" 자기 점검 체크리스트 + 추출 메타 매핑 표 추가


---

## §16. v7.4 — "메타 자동 생성도 일괄 자동화" 명문화 (2026-05-21 사용자 재지적)

### 16.1 사용자 재지적 (2026-05-21)

> "상세하게 작성해달라고 요청했는데, SHEET 의 대부분이 다 비어있네요. 진짜 이정도 수준으로 만들어달라고 요청하지 않았습니다.
> 현재의 DM 의 화면분석서를 만드는 수준으로 상세하게 소스를 각각의 화면분석서를 생성할 때마다 각각의 소스를 직접 다 읽어서
> 소스의 모든 부분이 누락되지 않도록 보완해주세요."

### 16.2 v7.4 절대 의무 (작업 시작 전 자기 점검)

```
☐ [v7.4 의무] 화면별 .cs 파일 **전체** Read (처음~끝, 수백~수천 라인)
☐ [v7.4 의무] 화면별 .Designer.cs 파일 **전체** Read
☐ [v7.4 의무] 13시트 모두 의미 있는 내용으로 채움 (filled cells 30+ per sheet)
☐ [v7.4 의무] Validation: cs 본문의 모든 MessageHelper.GMessageBox 추출 (개수 + Msg ID + 카테고리)
☐ [v7.4 의무] Expression: 모든 LockColumn/LockRange/SetValue 자동 동기화 추출
☐ [v7.4 의무] 호출 POPUP: cs 본문의 모든 `new XxxPopup()` 추출 + 이미 분석서 있으면 Link / 없으면 신규
☐ [v7.4 의무] F-Key Override: BaseForm 의 FindButton/InsertButton/DeleteButton/EditButton/SaveButton override 모두 추출
☐ [v7.4 의무] 이벤트 핸들러: Designer.cs (`+=`) + cs 본문 (`+=`) 모두 추출
☐ [v7.4 의무] SP 호출: FoxDataRequest 모든 endpoint 추출 + SP DDL 본문에서 참조 테이블 추출
```

### 16.3 v7.4 의무 절차 (1 화면)

```
[Step 1] Read .Designer.cs 전체
[Step 2] Read .cs 전체 (수백~수천 라인이라도 모두 읽음)
[Step 3] 메타 추출 (Validation/Expression/POPUP/SP/Lock/AutoSync 포함)
[Step 4] xlsx 13시트 정밀 작성 (모든 시트 filled cells 30+)
[Step 5] ENG SVG mockup (메타 기반 정밀)
[Step 6] PNG 변환 + xlsx 2_Layout 임베드
[Step 7] analysis.md 작성 (DMF0008/SCP0001 수준)
[Step 8] 호출 POPUP 식별 + 별도 분석서 (공통 영역 확인 후 Link 또는 신규)
[Step 9] Screen_POPUP_SP_Tables_Matrix.xlsx 와 cross-check
[Step 10] 검증 (filled cells 카운트, mockup 시각, 통합 매트릭스 일치)
```

### 16.4 절대 금지 (v7.4 추가)

| # | 금지 | 위반 시 |
|---:|---|---|
| 28 | ❌ "메타 기반 자동 생성"으로 13시트 빈칸 다수 | xlsx 시트 빈 칸 = 즉시 재작업 |
| 29 | ❌ Validation/Expression/POPUP 누락 | 동일 |
| 30 | ❌ SP DDL 본문 분석 없이 참조 테이블 누락 | 동일 |
| 31 | ❌ v3 빌더 / v7.3 자동 생성 결과만으로 PR 산출 | 즉시 재작업 |

### 16.5 v7.4 정밀 빌더 (사용 정책)

- `outputs/v74_screen_builder.py` — **개별 화면별** 실행 (배치 처리 시에도 화면당 .cs 전체 Read)
- 빌더가 추출한 메타는 자동이지만, 결과 xlsx 13시트 / MD / mockup 은 모두 의미 있는 내용 (filled cells 30+ per sheet, MD 200+ 라인)
- `Screen_POPUP_SP_Tables_Matrix.xlsx` — 통합 매트릭스로 cross-check 가능

### 16.6 변경 이력

- 2026-05-21 (v7.4): "메타 자동 생성도 일괄 자동화" 명문화. 13시트 빈칸 = 위반. SP DDL 본문 + 참조 테이블 추출 의무.
