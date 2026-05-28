# 19. As-Is Mockup (PNG/SVG) 생성 룰 — v2

> ⚠️ **최우선 Rule**: `hooks/anti-simplification.md` (2026-05-22)
> 본 룰의 모든 v6.x~v7.4 규정은 [작업 단순화 절대 금지 룰] 의 적용 사례입니다.
> "메타 자동 생성으로 빈 시트 다수 산출" 같은 위반은 즉시 재작업 대상.


> **목적**: 화면별 분석 산출물(`{27|28|29}_*_Screens/`)의 mockup PNG/SVG 생성을 명문화하여 누락/혼동 없이 일관된 시각 자료를 보장.
> **대상**: 인간 개발자 + AI(Claude) — 화면 분석서 재생성 시 본 룰을 1차 참조.
> **위반 시**: 시각 비교 곤란 + 카운트 일치 의무 위반 → PR reject.
> **이력**: 2026-05-19 v1 신설 (Designer.cs 좌표 기반 직접 매핑) → 2026-05-19 **v2 전면 개정** (LayoutControl 자식 좌표 한계 발견, 정형 GSCM 레이아웃 빌더 채택, 백업본 PNG 우선 정책 추가).

---

## 1. 핵심 원칙

### 원칙 1 — 누락 0건 (모든 화면 구성 요소 포함)
phase2b_screens.json `controls`에 등록된 모든 컨트롤 + Designer.cs/.cs에서 동적으로 생성되는 모든 컨트롤이 mockup에 반영되어야 한다. **제외 가능 항목은 없다.**
> `imageList*`, `timer*`, `errorProvider*`, `toolTip*`, `bindingSource*`, `contextMenuStrip*`, `backgroundWorker*` 등도 디자이너 트레이(viewBox 하단 별도 영역)에 아이콘 + 라벨로 표시한다.
> Spread/Grid 내부의 `*_Sheet[0-9]+`, `*_Sheet*Column*`, TabControl/TabPage, 동적으로 생성된 컬럼/패널 모두 표현.

### 원칙 1.1 — Spread/Grid 컬럼 정확 표기 (FarPoint Spread, DevExpress XtraGrid)
**전제**: GSCM 화면은 대부분 **DB SP `{prefix}_GET_SPREAD_TITLE` 또는 `GET_BUCKET_TYPE_CODE`의 DataTable로 컬럼이 런타임 생성**된다. 정적 컬럼명 추출이 불가능한 경우가 다수.

규약:
- Designer.cs의 `{sheet}.Columns.Get(N).Label`, `ColumnHeader.Cells.Get(r,c).Text` 등 정적 패턴이 있으면 그대로 추출
- 정적 패턴이 없으면 **mockup에 동적 컬럼 시뮬레이션** + `[ 동적 컬럼 — SP GET_SPREAD_TITLE 기반 ]` 마커 표기
- Spread 패턴 라벨(타이틀바 옆): `(1S 1G)`, `(NS NG)`, `(NS NG 1to1 MULTISHEET)`, `(NS NG more groups MULTISHEET)` 등

### 원칙 1.2 — TabControl / TabPage 정확 표기
- Designer.cs의 `this.tabControl1`, `this.tabPage1`, `this.tabControl1.Controls.Add(this.tabPageX);`, `this.tabPageX.Text = "..."` 패턴 추출
- 각 TabPage는 별도 영역 박스로 그리고, 탭 헤더 줄에 `[ 탭1 ][ 탭2 ][ 탭3 ]` 형태로 표기 (active 탭은 강조 색상)
- 비활성 탭의 컬럼 정보가 있으면 `[Inactive Sheet/Tab] [spdSub] {name}` → `Endpoint: ...`로 별도 표기

### 원칙 1.3 — 동적 컨트롤 추적
- .cs 메인 파일에서 `new {Type}()` + `this.{parent}.Controls.Add(this.{var})` 또는 `Controls.Add(new ...())` 패턴 추출
- 동적 생성 컨트롤도 mockup에 그린다. 위치/크기를 알 수 없으면 디자이너 트레이 영역에 라벨로 표기.

### 원칙 2 — Designer.cs 좌표 직접 매핑 금지 (v2 신규)
> ⚠️ **중요한 경험적 결론**: WinForms Designer.cs의 `Location` / `Size` 값은 **부모 컨테이너 기준 상대좌표**이며, DevExpress LayoutControl의 자식 컨트롤은 LayoutControlItem이 좌표를 갖고 실제 컨트롤은 (0,0)으로 등록된다. 자식 좌표를 그대로 누적하면 모든 LayoutControl 자식이 좌상단에 겹쳐 그려져 mockup이 깨진다.

규약:
- **정형 GSCM 레이아웃 빌더**(`build_mockup_v2.py`)를 표준 빌더로 사용한다.
- 컨트롤 종류만 추출(`by_type`)하고, **GSCM 표준 화면 구조에 따라 정형 배치**한다 (§3 참조).
- 절대좌표 직접 매핑은 사용 금지 (사실상 폐기). 단, 단순 popup(컨트롤 < 10개)은 좌표 직접 매핑이 가능하나 검증된 화면만.

### 원칙 3 — 백업본 PNG 우선 정책 (As-Is 정밀 mockup)
1단계 추출기가 만든 **백업본의 `xl/media/image1.png`는 정확한 As-Is 분석 결과**일 가능성이 높다 (검증된 사례: 27_DM 13개 백업본 모두 자기 화면을 정확히 가리킴).

규약:
- 새 mockup을 빌드하기 전에 백업본(`__bak_*/`)에 PNG가 있는지 확인
- 백업본 PNG가 자기 화면을 정확히 가리키면(`1_화면개요`의 ScreenId 또는 11_Validation 헤더와 일치) **그대로 임베드**하고 빌더 mockup으로 덮어쓰지 않음
- 백업본 PNG가 다른 화면을 가리키면 v2 빌더 mockup으로 교체

### 원칙 4 — KOR/ENG 두 벌 + PNG 임베드 의무
모든 화면에 다음 4종이 동시에 존재해야 한다:
1. `{ScreenId}_Mockup_KOR.svg` — 한글 라벨 SVG
2. `{ScreenId}_Mockup_ENG.svg` — 영문 라벨 SVG
3. `xl/media/image1.png` — xlsx 2_Layout 시트에 임베디드 PNG
4. `2_Layout` 시트 텍스트 — SVG 파일명 + 화면 패턴 + 컨트롤 통계 명시

> ⚠️ **PNG 임베드 누락 금지**: 2_Layout 시트에 SVG 파일명만 텍스트로 있고 PNG가 없으면 사용자가 mockup을 보지 못한다. 반드시 PNG를 임베드해야 함.

### 원칙 5 — 한글 폰트 미설치 환경 대응
샌드박스/CI 환경에 한글 폰트가 없을 경우, **영문(ENG) SVG → PNG 변환을 표준으로** 사용한다. 한글 라벨이 필요한 사용자는 KOR SVG 파일을 직접 열어볼 수 있다(브라우저에서 바로 렌더링됨). 2_Layout 시트의 R3에 KOR SVG 파일명을 명시할 것.

---

## 2. SVG 골격 (정형 빌더 v2 표준 스펙)

### 2.1. 루트 + viewBox
```xml
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" font-family="Arial,sans-serif">
```
- W: ClientSize.Width 이상, 최소 1340
- H: 영역별 합산 (타이틀 + 메뉴 + Filter + Main Spread + Sub Tab + Buttons + Auto-Events + Tray)

### 2.2. defs/style (15 CSS 클래스 + 6 linearGradient — **고정값**)

```xml
<defs><style>
.title{font-size:13px;font-weight:700;fill:white;}
.menu{font-size:11px;fill:#333;}
.section{font-size:12px;font-weight:700;fill:white;}        /* 오렌지 strip */
.section-d{font-size:11px;font-weight:700;fill:#1F4E78;}    /* Filter 라벨 */
.lbl{font-size:11px;fill:#333;}
.input-val{font-size:11px;fill:#000;}
.input-text{font-size:10px;fill:#888;font-style:italic;}
.btn-text{font-size:11px;font-weight:600;fill:white;}
.grid-h{font-size:10px;font-weight:700;fill:white;}
.grid-c{font-size:10px;fill:#222;}
.cb{font-size:11px;fill:#333;}
.endp{font-size:10px;fill:#666;font-style:italic;}
.tray-lbl{font-size:9px;fill:#666;}
.fwk-h{font-size:11px;font-weight:700;fill:#1F4E78;}
.fwk-k{font-size:10px;font-weight:600;fill:#000;}
.fwk-v{font-size:10px;fill:#555;}
.tab-act{font-size:11px;font-weight:700;fill:#1F4E78;}
.tab-inact{font-size:11px;fill:#888;}
</style>
<linearGradient id="tg" .../>  <!-- title: 파랑 그라데이션 -->
<linearGradient id="bg" .../>  <!-- 보조 버튼: 파랑 -->
<linearGradient id="ag" .../>  <!-- 액션 버튼: 녹색 -->
<linearGradient id="gh" .../>  <!-- grid 헤더: 진파랑 -->
<linearGradient id="st" .../>  <!-- 섹션 strip: 오렌지 -->
<linearGradient id="cb" .../>  <!-- Filter 배경 -->
</defs>
```

---

## 3. 정형 GSCM 화면 레이아웃 (v2 표준)

mockup은 다음 8개 영역을 위에서 아래로 순서대로 배치한다:

| # | 영역 | 높이 | 내용 |
|---|---|---|---|
| 1 | **타이틀바** | 24px | `{ScreenId} - Screen Mockup ({pattern})` + 우상단 `_ □ X` |
| 2 | **메뉴바** | 24px | `File(F) Edit(E) View(V) Tools(T) Help(H) | F5 Find F7 Save F8 Insert F9 Delete F12 Excel` |
| 3 | **Filter Condition** | 70-110px | 4×2 그리드 콤보 (Division/Department/Team/End Custo / Sales Site/Country/City/Active) + Detail Mode + Search(F5) |
| 4 | **Main Spread** (선택) | 동적 | 오렌지 strip `[{name}] Main ({N} cols)` + Endpoint + 16열 헤더 + 6 샘플 행 |
| 5 | **Sub Spread Tab** (선택) | 동적 | 오렌지 strip `[spdSub] Sub-Grids ({N} sheets via AddSheet)` + N개 탭 + Active Endpoint + 8열 + 4 행 |
| 6 | **버튼 줄** | 44px | Search(F5)/Insert(F8)/Save(F7)/Delete(F9)/Edit(F2)/Excel(F12)/Print/Close (액션 6 녹색 + 보조 2 파랑) |
| 7 | **Framework Auto-Events** | 140px | 7개 F-키 바인딩 + 동작 설명 |
| 8 | **Designer Tray** | 30px | 비가시 컴포넌트(ImageList/Timer/ContextMenu 등) 라벨 |

### 3.1. 화면 패턴 자동 감지

| 조건 | 패턴 라벨 |
|---|---|
| Main 1 + Sub 0 | `(1S 1G)` |
| Main N + Sub 0 | `(NS NG)` |
| Main + Sub 1 | `(NS NG 1to1 MULTISHEET)` |
| Main + Sub ≥2 | `(NS NG more groups MULTISHEET)` |
| Spread 없음 | `(no grid)` — 팝업/다이얼로그 |

### 3.2. Main/Sub Spread 분류 규칙
변수명 키워드로 자동 분류:
- Sub 키워드: `sub`, `detail`, `level2`, `level3`, `cust`, `sumitem`, `sumcust`, `sumloc`, `item`, `customer`, `location`
- 그 외 `spdMain`, `spdRepair`, `spdSummary` 등 → Main

### 3.3. Endpoint 추출
.cs 메인의 `"{domain}.{SCREEN_PREFIX}_GET_*"` 패턴에서 SP 호출 추적:
- Main Spread Endpoint: `GET_SPREAD_TITLE`, `GET_BUCKET_TYPE_CODE`, `GET_COMMON*` 우선
- Sub Spread Endpoint: 나머지 `_DATA`, `_GET_*` SP

---

## 4. 라벨 한글/영문 변환 사전

| 영문 | 한글 |
|---|---|
| Save | 저장 |
| Search / Query / Find | 조회 / 검색 |
| Add / New / Insert | 추가 / 신규 / 등록 |
| Delete / Remove | 삭제 / 제거 |
| Cancel / Close / Exit | 취소 / 닫기 / 종료 |
| Apply / OK / Confirm | 적용 / 확인 |
| Export / Excel | 내보내기 / 엑셀 |
| Import / Upload / Download | 가져오기 / 업로드 / 다운로드 |
| Refresh / Reload / Reset / Clear | 새로고침 / 초기화 |
| Edit / Modify | 수정 |
| Copy / Paste | 복사 / 붙여넣기 |
| Print / Preview | 인쇄 / 미리보기 |
| Filter Condition | 필터 조건 |
| Detail Mode | 상세 모드 |
| All Selected | 전체 선택 |
| Division / Department / Team / End Custo | 사업부 / 부서 / 팀 / 최종고객 |
| Sales Site / Country / City / Active | 판매사이트 / 국가 / 도시 / 활성 |
| Project / Customer / Item / Model | 프로젝트 / 고객 / 품목 / 모델 |
| Site / Date / Period / From / To | 사이트 / 일자 / 기간 / 시작 / 종료 |
| Batch Job / Exchange Rate | 배치작업 / 환율 |
| Framework Auto-Events | 프레임워크 자동 이벤트 |
| Designer Component Tray (non-visible at runtime) | 디자이너 컴포넌트 트레이 (런타임 비가시) |
| Endpoint | 엔드포인트 |

확장은 동일 위치 룰 19 §4에 사전 추가. 누락이 있을 때는 원문 유지 + 별도 ToDo 마킹.

---

## 5. SVG → PNG 변환 + xlsx 임베드

### 5.1. 변환 도구
- **표준**: `cairosvg.svg2png(url=eng_svg, write_to=png, output_width=1400)` (영문 SVG 기반)
- KOR PNG는 한글 폰트 미설치 시 □로 깨지므로 ENG PNG만 임베드를 표준화
- 한글 보고 싶으면 KOR SVG 파일을 브라우저로 직접 열기

### 5.2. xlsx 2_Layout 시트 표준 텍스트

```
R1: {ScreenId} — UI Mockup ({pattern})
R2: As-Is GSCM 표준 화면 레이아웃 mockup. (타이틀바/메뉴/Filter/Main Spread/Sub Tab/버튼/Framework Auto-Events 구조)
R3: 한글 SVG: {ScreenId}_Mockup_KOR.svg (한글 라벨 시각화는 SVG 직접 열기)
R4: 영문 SVG: {ScreenId}_Mockup_ENG.svg / PNG: 본 시트 임베드 (ENG SVG → 1400px 렌더링)
R5: Spread Main: [...] / Sub: [...] / Buttons: N / Combo: N / CheckedList: N / CheckBox: N
R6: SP 호출 추적: N건 (대표: {first_sp})
R7: 아래 → 렌더링된 PNG (정형 GSCM 화면 mockup)
A8: [임베디드 PNG 이미지] — width ≤ 1280px로 축소
```

### 5.3. PNG 임베드 검증 의무
xlsx 저장 후 다음을 검증:
- `xl/media/image1.png` 존재 여부 (`zipfile`로 직접 확인)
- PNG 크기 > 10KB (텍스트만 있는 더미가 아닌지)
- 2_Layout 시트의 R7에 PNG가 등록되어 있는지

---

## 6. 누락 0건 검증 (PR 머지 게이트)

### 6.1. 컨트롤 회계 (account)
```
n_types == visible + tray + layout_item + spread_internal + meta + form + no_coord_problem
```
모든 Designer.cs types가 7가지 분류에 정확히 매칭되어야 한다. `no_coord_problem` > 0이면 수정 필요.

### 6.2. 트레이 자동 분류 대상
다음 타입 + 명명규칙을 트레이로 분류 (좌표 없어도 정상):
- `ImageList`, `Timer`, `ErrorProvider`, `ToolTip`, `NotifyIcon`, `BindingSource`, `BackgroundWorker`
- `ContextMenuStrip`, `ContextMenu`, `ToolStripMenuItem`, `MenuItem`, `MainMenu`, `MenuStrip`
- `ToolStrip`, `StatusStrip`, `ToolStripContainer`, `ToolStripSeparator`
- 명명규칙: var명이 `_pr`/`_history`/`_action`으로 끝나거나 `request_`/`view_`/`add_`로 시작하면 메뉴 아이템으로 추정

### 6.3. xlsx 파일 검증
모든 화면 분석 xlsx는 다음을 만족:
- 시트 12개 (1_화면개요 ~ 12_Expression) 정확히 존재
- 11_Validation, 12_Expression이 백업본과 MD5 100% 일치 (무손상 보존)
- 2_Layout 시트에 PNG 임베드 (size > 10KB)
- KOR/ENG SVG 파일이 같은 폴더에 존재

---

## 7. 사고 사례 + 재발 방지 룰

### 7.1. 사고 1: xlsx 1~10 시트 꼬임 (2026-05-18)
- **원인**: 1단계 추출기 캐시 재사용 버그로 27_DM_Screens 14개 파일의 1~10 시트가 다른 화면 데이터로 채워짐
- **방지**: `1_화면개요`의 화면 ID가 파일명과 일치하는지 사전 검증 (룰 09 §1 원칙 4)
- **복구**: 백업본 → 1~10 시트 재구성기(build_screen_xlsx.py) → 11/12는 백업본 복사

### 7.2. 사고 2: 2_Layout PNG 미임베드 (2026-05-19)
- **원인**: 28/29 폴더에 PNG 임베드 없이 SVG 파일명만 텍스트로 명시
- **방지**: 2_Layout 시트는 반드시 `xl/media/image1.png`를 포함 (zipfile 검증)
- **복구**: ENG SVG → cairosvg → PNG 임베드

### 7.3. 사고 3: Designer.cs 좌표 절대좌표 가정 (2026-05-19)
- **원인**: DevExpress LayoutControl 자식 좌표가 (0,0)인데 절대좌표로 가정해 모든 컨트롤이 좌상단에 겹침
- **방지**: 절대좌표 직접 매핑 폐기, 정형 GSCM 빌더(`build_mockup_v2.py`) 사용
- **복구**: v2 빌더로 전 화면 재생성

### 7.4. 사고 4: Spread 컬럼 정적 추출 시도 (2026-05-19)
- **원인**: GSCM 화면 거의 전체가 동적 컬럼(SP `GET_SPREAD_TITLE` 결과) 패턴인데 정적 컬럼명 추출을 시도
- **방지**: Spread 컬럼은 동적 마커 + 16열 시뮬레이션 + Endpoint 명시로 표준화

---

## 8. 빌더 도구 인벤토리

| 빌더 | 위치 | 용도 |
|---|---|---|
| `build_screen_xlsx.py` | `Doc/_analysis/scripts/` (예정) | xlsx 1~10 시트 재구성 (Designer.cs + phase2b + phase3 입력) |
| `build_mockup_v2.py` | `Doc/_analysis/scripts/` (예정) | 정형 GSCM mockup SVG 빌더 (v2 표준) |
| `embed_svg_png.py` | `Doc/_analysis/scripts/` (예정) | SVG → PNG (cairosvg) + xlsx 2_Layout 시트 임베드 |
| `build_28_29_full.py` | `Doc/_analysis/scripts/` (예정) | 28/29 도메인 화면 풀스코프 보강기 |

---

## 9. 관련 문서

| 경로 | 내용 |
|---|---|
| `Doc/_dev_rules/09_WIJMO_VALIDATION_EXPRESSION.md` | xlsx 11/12 시트 룰 + 신뢰 우선순위 |
| `Doc/_dev_rules/20_SCREEN_ANALYSIS_PIPELINE.md` | ⭐ 화면 분석서 전체 파이프라인 룰 |
| `Doc/_dev_rules/hooks/screen-analysis-pre-build.md` | 화면 분석서 작성 전 자기 점검 |
| `Doc/_dev_rules/hooks/screen-analysis-post-build.md` | 화면 분석서 작성 후 검증 |
| `Doc/_dev_rules/hooks/screen-analysis-pre-submit.md` | PR 머지 전 최종 검증 |
| `CLAUDE.md` §Step 4 | 화면별 분석 자료 1차 참조 룰 |

---

## 10. 변경 이력

| 일자 | 버전 | 변경 |
|---|---|---|
| 2026-05-19 | v1 | 신설. Designer.cs 좌표 기반 직접 매핑 빌더(`build_mockup_svg.py`) |
| 2026-05-19 | v2 | **전면 개정**. LayoutControl 자식 좌표 한계 발견 → 정형 GSCM 레이아웃 빌더(`build_mockup_v2.py`) 채택. 백업본 PNG 우선 정책 추가. xlsx 2_Layout PNG 임베드 의무화. 사고 사례 4건 + 재발 방지 룰 추가. 컨트롤 회계 7분류 명문화. |
| 2026-05-21 | **v3 (v6.4)** | **컨테이너 계층 정밀 파싱 룰 추가**. SplitContainer Panel1/2 + XtraTabControl/TabPage + Panel/GroupBox/UsrLayoutControl Controls.Add + Spread별 AddSheet 매핑(.cs 본문) 4종 패턴 파싱 필수. 사례: DMF0008 의 3단 구조 + 하단 2-sheet 탭 누락 → v6.4 에서 복원. Hook `screen-analysis-pre-build.md §11` 과 동기. |

---

## 11. v6.4 컨테이너 계층 룰 (2026-05-21)

### 11.1 Designer.cs 4종 필수 파싱 패턴

```python
# 1) SplitContainer Panel 자식
re.finditer(r"this\.(\w+)\.(Panel[12])\.Controls\.Add\(this\.(\w+)\)", ds)

# 2) XtraTabControl 의 TabPages.AddRange
re.finditer(r"this\.(\w+)\.TabPages\.AddRange\(\s*new[^{]*\{([^}]+)\}\s*\)", ds, re.DOTALL)

# 3) XtraTabPage 의 Controls.Add
# instances[parent] == "XtraTabPage"

# 4) Panel/GroupBox/UsrLayoutControl 의 Controls.Add
# instances[parent] in ("Panel", "GroupBox", "GroupControl", "UsrLayoutControl")
```

### 11.2 Spread별 AddSheet (.cs)

```python
# AddSheet(spreadName, SpdSheet.SheetName, ...) → spreadName 별 sheet 누적
re.finditer(r"\bAddSheet\(\s*(\w+)\s*,\s*\w+\.(\w+)\s*,", cs_text)
```

Spread 1개에 sheet 2+ → mockup 에 **sheet 탭** (TabControl 처럼).

### 11.3 의미적 매핑 표

| Designer.cs 구조 | Mockup 표현 |
|---|---|
| SplitContainer.Panel1/Panel2 (Horizontal) | 상하 분할 (Splitter 가로선) |
| SplitContainer.Panel1/Panel2 (Vertical) | 좌우 분할 (Splitter 세로선) |
| Panel1 자식에 FpSpread 2+ | 패널 내 좌우/상하 분할 |
| FpSpread + AddSheet ≥ 2 | Spread 상단 sheet 탭 |
| XtraTabControl + N TabPage | 상단 Tab 탭바 |
| UsrLayoutControl 자식 (콤보/체크/입력) | 조회조건 패널 |

### 11.4 사례 — DMF0008_ErpEdiMaster

- SplitContainer1 (상하): Panel1(조회조건 3개 + spdSummary + spdRepair) | Panel2(spdSub)
- AddSheet 4회: spdSummary(1) / spdRepair(1) / spdSub(**2 = shtSales_Site + shtSSPM**)
- v6.3 에서는 단일 Grid 로 그렸으나 v6.4 에서 3단 구조 + 하단 2-sheet 탭으로 정확 표현
| 2026-05-21 | **v3 (v6.4)** | **컨테이너 계층 정밀 파싱 룰 추가**. SplitContainer Panel1/2 + XtraTabControl/TabPage + Panel/GroupBox/UsrLayoutControl Controls.Add + Spread별 AddSheet 매핑(.cs 본문) 4종 패턴 파싱 필수. DMF0008 사례. |
| 2026-05-21 | **v4 (v6.6/v6.7)** | **개별 .cs 정밀 분석 의무화**. v3 일괄 빌더는 단순 화면용. 다단 Dock 중첩(`Dock=Top` 3개 이상) 또는 SplitContainer+TabPage 혼합 또는 사용자 캡쳐 제공 화면은 개별 .cs 정밀 분석 + 손 작업 의무. DefColumns struct + 주석 그룹화 + AddColumn 인자 정확 추출. DMF0008 사례. |

---

## 12. v7.0 통합 룰 — 모든 mockup 생성 전 의무 절차 (2026-05-21 신설)

> **본 룰은 v1~v3 누적 룰의 통합 명문화. 모든 mockup 생성 시 본 §12 를 1차 룰로 적용.**

### 12.1 mockup 생성 4단계 강제 절차

```
[1단계 — 1차 자료 수집]
☐ 대상 화면 ScreenId 의 .cs 파일 (Forms.UIL 우선) 위치 확인
☐ 대상 화면 ScreenId 의 .Designer.cs 위치 확인
☐ AsIs_UI_Sample/{ScreenId}.png 캡쳐 존재 여부 확인
☐ 부모 화면에서 호출되는 POPUP 인 경우, POPUP 클래스의 .cs/.Designer.cs

[2단계 — 화면별 정밀 추출 (절대 일괄 자동화 금지)]
☐ ClientSize / Form Title
☐ DefColumns struct + 주석 그룹화 (Spread별 컬럼)
☐ AddColumn / AddNumColumn 호출의 헤더 텍스트 + 바인딩 컬럼명
☐ ColumnHeaderSpan 호출의 row + 텍스트
☐ Designer.cs 모든 컨트롤의 Location/Size/Text/TabIndex/Type
☐ 컨테이너 계층 4종 파싱 (§11.1)
☐ Spread별 AddSheet 매핑 (§11.2)
☐ Dock 속성 (Top/Bottom/Left/Right/Fill) — 다단 Dock 중첩 식별

[3단계 — 손 작업 의무 화면 판별]
다음 중 1개라도 해당 → 손 작업 mockup 필수, v3 빌더 결과는 검토용:
☐ 다단 Dock 중첩 (`Dock=Top` 3개 이상 — DMF0008 사례)
☐ SplitContainer + XtraTabControl 혼합
☐ Spread 2개 이상 + 각각 컬럼 다름
☐ 사용자 캡쳐(`AsIs_UI_Sample/`) 제공된 화면
☐ ColumnHeaderSpan 11회 이상 (4단 이상 다단 헤더)

[4단계 — mockup SVG/PNG 생성]
☐ SVG 작성 시 ClientSize 비례 → viewBox 1600×920 (또는 1700×980)
☐ Designer.cs Location 절대좌표 그대로 사용 금지 (LayoutControl 겹침)
☐ 실제 컬럼명 (DefColumns/AddColumn/캡쳐) 사용 — "Col1, Col2" 같은 placeholder 금지
☐ 한글 라벨 (Designer.cs Text + LayoutControlItem Caption) 그대로 사용
☐ KOR + ENG 양벌 SVG 생성
☐ 한글 폰트(NanumGothic) base64 임베드 KOR/ENG 모두 적용
☐ Playwright 기반 PNG 변환 (cairosvg 한글 글리프 한계 회피, §12.3 참조)
☐ xlsx 2_Layout 에 ENG PNG 임베드 (한글 깨짐 없는 영문)
```

### 12.2 절대 금지 (v7.0 통합)

1. ❌ 일괄 자동화 빌더로만 mockup 생성 (개별 .cs 미확인)
2. ❌ DefColumns 추출 없이 "Col1, Col2" 같은 generic 컬럼명 사용
3. ❌ Dock 중첩 구조를 단일 Grid 로 표현
4. ❌ SplitContainer/TabPage/AddSheet 다중 컨테이너를 무시
5. ❌ 사용자 캡쳐 제공된 화면에 캡쳐 매핑 검증 없이 생성
6. ❌ KOR PNG 한글 깨짐을 그대로 두기 (Playwright 재변환 또는 ENG PNG 사용)
7. ❌ Designer.cs `Location/Size` 절대좌표를 그대로 SVG 매핑 (LayoutControl 자식 겹침)

### 12.3 한글 PNG 렌더링 정책

cairosvg + Linux 환경의 한글 글리프 한계로 KOR PNG 깨짐 발생. 대응:

| 방법 | 장점 | 단점 | 권장 |
|---|---|---|---|
| **Playwright (Chromium)** | 브라우저 폰트 광범위, 한글 완벽 | 의존성 큼 | ✓ 1차 |
| cairosvg + 폰트 임베드 | 빠름, 가벼움 | 글리프 누락 | ✗ KOR 부적합 |
| svglib + reportlab | 한글 일부 지원 | 레이아웃 차이 | △ 백업 |
| **xlsx에 ENG PNG 임베드** | 한글 깨짐 무관 | 영문만 | ✓ 임베드용 |
| **KOR SVG 원본 보관** | Excel/브라우저 정상 | PNG 아님 | ✓ 원본 |

원칙:
- **xlsx 2_Layout 임베드**: ENG PNG 사용 (깨짐 없음)
- **KOR PNG 표시 필요 시**: Playwright 변환 또는 Windows 환경 재변환
- **KOR SVG 원본**: 모든 SVG는 한글 텍스트 정상 보관 — Excel/Inkscape/브라우저에서 정상 표시

### 12.4 각 .cs 정밀 분석 검증 체크

mockup 생성 후 다음 모두 ✓ 되어야 PR 머지 가능:

```
☐ Designer.cs ClientSize == mockup viewBox 비례
☐ 캡쳐 컬럼명 == mockup Grid 헤더 (한 글자도 다르면 ✗)
☐ Designer.cs Dock=Top 3개 이상 화면 → mockup 다단 분할 표현
☐ AddSheet N회 → mockup sheet 탭 N개
☐ SplitContainer/XtraTabControl 모두 표현
☐ 한글 라벨 Designer.cs Text 와 1:1 일치
☐ MD analysis.md 의 영역별 구조 표 + 컬럼 매핑 표 작성
☐ xlsx 2_Layout 에 영역별 구조 표 + ENG PNG 임베드
```

### 12.5 사례별 가이드

| 화면 유형 | 사례 | 작업 방식 |
|---|---|---|
| 단순 Single Grid | DMF0006, DMF0007 등 | v3 빌더 자동 → 검토 |
| 다단 헤더 + 시간축 | DMF0020, DMF0021, DMF0042 | v3 빌더 → 다단 헤더 손 보정 |
| SplitContainer 단순 | DMF0005, DMF0006 | v3 + 컨테이너 표현 확인 |
| **Dock 중첩 다단** | DMF0008 (4단), DMF0052 (3단) | **개별 .cs + 손 작업 의무** |
| Multi-Spread + Multi-Sheet | DMF0003_1, DMF0069 | 개별 .cs 정밀 분석 |
| POPUP (캡쳐 있음) | DMF0020_POPUP_ExchangeRate, _Price | 캡쳐 + Designer.cs |
| POPUP (캡쳐 없음) | DMF0020_POPUP_Version 등 | Designer.cs 정밀 + TabIndex 정합성 |


---

## 13. v7.1 — 영문(ENG) Mockup 표준 정책 (2026-05-21 신설)

> **배경**: cairosvg + Linux 샌드박스 환경의 한글 글리프 한계로 KOR PNG 가 부분 깨짐 발생. Playwright Chromium / sudo 폰트 설치 등 모든 대안이 네트워크/권한 한계로 실패. 이를 해결하기 위해 **xlsx 2_Layout 임베드 PNG 는 ENG 표준** 으로 채택.

### 13.1 영문 표준 정책 (v7.1 — 의무)

```
☐ xlsx `2_Layout` 시트에 임베드되는 PNG 는 **반드시 ENG PNG**
☐ KOR SVG 는 원본 보관 (Excel/Inkscape/브라우저에서 한글 정상 표시 — 사용자 환경 의존)
☐ KOR PNG 가 필요하면 Windows 환경에서 SVG → PNG 재변환 (Inkscape/Edge headless)
☐ MD analysis.md 의 "Mockup 파일" 섹션에 KOR/ENG SVG + KOR/ENG PNG 4벌 모두 명시
☐ KOR PNG 의 cairosvg 한글 글리프 한계는 분석서 변경이력에 명시
```

### 13.2 사용자가 한글 mockup 필요 시 (Windows 절차)

```powershell
# outputs/convert_kor_svg_to_png_windows.ps1 (제공됨)
.\convert_kor_svg_to_png_windows.ps1

# 사전 조건: Inkscape 설치 (권장) 또는 Chrome/Edge 브라우저
# 결과: 84개 KOR SVG → KOR PNG 일괄 변환 (한글 정상)
```

### 13.3 절대 금지 (v7.1 추가)

15. ❌ xlsx 2_Layout 에 한글 깨진 KOR PNG 임베드 (사용자가 글자 안 보임)
16. ❌ Linux 측 cairosvg 결과 KOR PNG 를 그대로 산출물로 제공
17. ❌ KOR SVG 원본 미보관 (Windows 재변환 불가능해짐)

### 13.4 영문 mockup 의 한글 라벨 처리

ENG SVG 도 실제 화면에 한글이 있으면(예: 컬럼명 "정비필요", 버튼 "조회") 그대로 한글 유지 — 영문 라벨이 있으면 영문 사용, 없으면 한글 그대로. **혼합 표기 허용** (DMF0008 사례 — "Summary"/"GSCM Master Data Required"/"정상" 혼용).

이유: ENG PNG 는 한글이 적게 들어가야 cairosvg가 정상 처리. 가능한 한 한글 라벨 → 영문 라벨로 변환 (룰 19 §4 사전 활용).

### 13.5 변경 이력

- 2026-05-21 (v7.1): ENG mockup 표준 채택. KOR PNG 환경 제약 명시. Windows 재변환 스크립트 (convert_kor_svg_to_png_windows.ps1) 안내.


---

## 14. v7.2 — 일괄 자동화 금지 + 개별 .cs 의무 룰 (2026-05-21 최우선 명문화)

> **이 룰은 §1~§13 의 모든 룰을 압도하는 최우선 룰입니다.**

### 14.1 의무 — 각 화면별 개별 .cs 정밀 분석

**모든 mockup 생성 작업은 반드시 다음 단계로 진행:**

```
[필수 1단계] 화면 1개 선택 → 해당 화면의 .cs / .Designer.cs 파일 단일 Read
[필수 2단계] DefColumns / AddColumn / Designer 라벨 / 컨테이너 계층 정밀 추출
[필수 3단계] 추출 결과 기반 개별 SVG 손 작성 (자동 빌더 결과는 검토용)
[필수 4단계] 캡쳐 있으면 시각 검증 / 없으면 TabIndex/라벨 정합성 검증
[필수 5단계] xlsx 2_Layout 에 ENG PNG 임베드
```

### 14.2 절대 금지 (v7.2 — 최우선)

18. ❌ **일괄 자동화 빌더(dm_v3_gen_all.py 등)만으로 mockup 생성 후 검토 없이 산출**
19. ❌ 화면별 .cs 파일을 읽지 않고 mockup 생성
20. ❌ POPUP mockup 도 일괄 처리 (모든 POPUP 의 .cs/.Designer.cs 개별 읽기 의무)
21. ❌ 한글 KOR PNG 가 깨진 상태로 xlsx 임베드

### 14.3 v3 자동 빌더 사용 정책 (제한)

`dm_v3_gen_all.py` 같은 자동 빌더는 **다음 용도로만 제한 사용**:
- 단순 화면(컨트롤 < 20개, ColumnHeaderSpan 0, SplitContainer 0) 의 1차 초안 생성
- 100% 검토용 — 항상 손 작업으로 보정 후 산출

다음 화면은 v3 빌더 결과 폐기, **개별 손 작업 의무**:
- 다단 Dock 중첩 (`Dock=Top` 3개 이상)
- SplitContainer / XtraTabControl 존재
- DefColumns 그룹 2개 이상
- POPUP (모든 POPUP)
- 사용자 캡쳐 제공된 화면

### 14.4 화면별 정밀 작업 절차 (단일 화면)

```python
# 1. 화면 선택
sid = "DMF0008_ErpEdiMaster"

# 2. .cs / .Designer.cs 단일 Read (Read tool)
#    cs_path = Doc/_legacy_source/06_UIL/.../DMF0008_ErpEdiMaster.cs
#    ds_path = Doc/_legacy_source/06_UIL/.../DMF0008_ErpEdiMaster.Designer.cs

# 3. 정밀 분석 (outputs/dm_v3_extract.py 의 analyze_screen() 단일 호출)

# 4. 결과 검토:
#    - DefColumns 그룹 확인
#    - 컨테이너 계층 확인
#    - 캡쳐(있으면) 시각 비교

# 5. SVG 손 작성 (gen_dmf0008_handcrafted.py 같은 단일 화면 스크립트)

# 6. ENG PNG → xlsx 2_Layout 임베드

# 7. analysis.md 에 v7.x 섹션 + 영역별 구조 표
```

### 14.5 사례 비교

| 화면 | v3 일괄 빌더 결과 | v7.2 개별 손 작업 |
|---|---|---|
| DMF0008 | 단일 Grid (4단 구조 누락) | 4영역 + 5+18+16 컬럼 + 2탭 정확 |
| DMF0020 메인 | (보존 — 손 작업) | Exchange Rate/Price/RowSpan 정확 |
| 신규 POPUP 29종 | DefColumns generic | (필요 시 개별 캡쳐+.cs 손 작업) |

→ **모든 신규 mockup 작업은 본 §14 룰을 1차 적용**


---

## 15. v7.3 — "소스기반 정밀 손 작업" 최우선 의무 룰 (2026-05-21 사용자 지시)

> **이 룰은 §1~§14 모든 룰을 압도하는 절대 최우선 룰입니다. 위반 시 PR 즉시 reject.**

### 15.1 배경

DMF0043 POPUP 2종 (ContributeRate / VersionPopup) 의 사용자 피드백:
> "DMF0043 에서 사용하는 POPUP의 경우 아직도 글씨가 깨져있습니다. 그리고 COLUMN도 제대로 생성되지 않았습니다. CS 파일과 소스를 읽어 제대로된 목업으로 생성해주세요."

원인 진단:
- 이전 v3 빌더(`dm_v3_gen_all.py`)는 Designer.cs Position/Size 만 파싱하여 단순 박스로 그렸음
- 컨테이너 계층(UsrConditionPanel/UsrLayoutControl/SplitContainer/XtraTabControl) 의미 누락
- `.cs` 본문의 `AddTextColumn("Description", DefColumns.VERSION_DESCRIPTION, FPMerge.None, 300, true)` 같은 정적 컬럼 정의 누락
- 권한별 button enable/disable 패턴(`Set_ButtonVisibleFalse(list)`) 누락
- cairosvg + Linux 한글 글리프 제약으로 KOR PNG 깨짐

### 15.2 의무 절차 (모든 화면 mockup 생성 시)

```
[필수 1단계] 화면별 .cs 파일 1개 Read
[필수 2단계] 화면별 .Designer.cs 파일 1개 Read
[필수 3단계] 메타 추출 (개별 추출, 일괄 빌더 금지):
  - ClientSize / 부모 컨테이너 계층 (SplitContainer/XtraTabControl/Panel/UsrConditionPanel/UsrLayoutControl)
  - 조회조건 컨트롤: 라벨 + 컨트롤명 + 타입(Combo/CheckedList/DateRangePicker/TextBox 등) + Position + Size
  - Grid: AddSheet 호출 / SheetView 변수 / AddColumn|AddTextColumn|AddNumColumn 헤더/필드/너비/Editable
  - DefColumns struct (모든 정적 필드)
  - ButtonList: UsrButtonList 의 ButtonItem.UserText / UserType / 권한별 visible 제어
  - 이벤트 핸들러 + 핵심 호출 SP
[필수 4단계] 추출 결과를 1:1로 표현하는 SVG **화면별 독립 빌더 함수** 작성
  - 일괄 자동화 빌더(dm_v3_gen_all.py 등) 결과 사용 금지
  - 화면별로 빌더 함수 1개 (예: gen_dmf0043_contribute_rate(), gen_dmf0043_version_popup())
  - 컨테이너 계층은 SVG 그룹/박스로 의미 분리하여 표현
  - 조회조건 위치는 실제 Position 의미를 살려 재배치 (절대 좌표 그대로 X)
  - Grid 컬럼 헤더는 .cs AddColumn 결과 그대로 사용
  - 캡쳐 있으면 시각 검증, 없으면 TabIndex/라벨 정합성 검증
[필수 5단계] ENG 표준으로 생성 (cairosvg KOR 깨짐 회피)
[필수 6단계] xlsx 2_Layout 에 ENG PNG 임베드
[필수 7단계] analysis.md 의 "v7.0~v7.2 정책 통합" 표를:
  - 작성 방식 = "캡쳐+소스 기반 정밀 손 작업 (v3 빌더 덮어쓰기 금지)"
  - 일괄 자동화 사용 = "아니오 (수작업 — gen_xxx_handcrafted.py)"
  - POPUP 정밀 사양 섹션 추가 (Designer.cs/.cs 정밀 메타: 컨테이너/조회조건 표/Grid 컬럼 표/ButtonList/SP/Validation)
```

### 15.3 절대 금지 (v7.3)

| # | 금지 행위 | 이유 |
|---:|---|---|
| 22 | ❌ v3 빌더(`dm_v3_gen_all.py`) 결과 그대로 사용 | 컨테이너/Grid 컬럼/ButtonList 의미 누락 |
| 23 | ❌ 화면별 .cs 파일을 읽지 않고 mockup 생성 | DefColumns/AddColumn 정확한 매핑 불가 |
| 24 | ❌ 화면별 .Designer.cs 파일을 읽지 않고 mockup 생성 | 컨테이너 계층/Position/Caption 누락 |
| 25 | ❌ 여러 화면을 1개 함수로 일괄 처리 | 화면별 정확성 보장 불가 — 화면당 빌더 1개 의무 |
| 26 | ❌ KOR PNG 가 깨진 상태로 xlsx 임베드 | 사용자가 글자 안 보임 |
| 27 | ❌ analysis.md 의 "일괄 자동화 사용"을 "예"로 둔 채 mockup 산출 | 룰 위반 표시 미명시 |

### 15.4 화면별 빌더 함수 작성 패턴

```python
# 좋은 예 (v7.3 의무 패턴) — gen_dmf0043_popups_handcrafted.py
def gen_contribute_rate(lang="ENG"):
    """DMF0043_ContributeRatePopup — Designer.cs + .cs 정밀 분석 결과 1:1 매핑"""
    # 1. Designer.cs 기반: ClientSize 1102x320, usrConditionPanel1 (Dock=Top h=39) + spdMain (Dock=Fill h=232)
    # 2. .cs 기반: DefColumns 5건 (VER_SEQ/YYYY/VERSION_NM/VALID_YN/DESCRIPTION)
    # 3. .cs 기반: ButtonList 7건 (Find/Edit/Insert/Save/OK/Close/Delete) 권한별 disable 패턴
    # ... 정확한 SVG 손 작성
    return svg

def gen_version_popup(lang="ENG"):
    """DMF0043_VersionPopup — 별도 함수 (다른 컨테이너/Grid 구조)"""
    # 1. Designer.cs: ClientSize 908x519, 2단 조회조건
    # 2. .cs: 정적 8 컬럼 (Divison/Version/Description/Type/Seq/Date/Create By/Create Date)
    # ... 정확한 SVG 손 작성
    return svg
```

```python
# 나쁜 예 (v7.3 금지 패턴) — dm_v3_gen_all.py
for screen in all_screens:  # ← 일괄 처리 금지!
    designer = parse_designer(screen)
    svg = build_simple_layout(designer.controls)  # ← 의미 누락!
    write(svg)
```

### 15.5 사례 비교

| 항목 | v3 빌더 (금지) | v7.3 손 작업 (의무) |
|---|---|---|
| 컨테이너 계층 | Position 그대로 박스 | UsrConditionPanel/SplitContainer 의미 분리 |
| 조회조건 | 라벨 텍스트만 | 라벨 + Combo 화살표 + DateRangePicker `~` + ButtonList 7개 |
| Grid 헤더 | "Column1, Column2..." | "Ver Seq / Year / Version Name / Valid / Description / Created By / Creation Date" |
| Grid 너비 | 균등 분할 | AddColumn 의 `width` 인자 그대로 |
| ButtonList | 단순 박스 | Find/Edit/Insert/Save/OK/Close/Delete + 권한별 disabled 스타일 |
| 한글 처리 | 깨짐 위험 | ENG 표준 + 손 번역 |

### 15.6 변경 이력

- 2026-05-21 (v7.3): "소스기반 정밀 손 작업" 최우선 의무 룰 명문화. v3 빌더 결과 사용 금지. 화면당 빌더 함수 1개 의무. analysis.md 표 자동 갱신 의무.


---

## 16. v7.4 — "메타 자동 생성도 일괄 자동화" 명문화 (2026-05-21 사용자 재지적)

> **v7.3의 "메타 기반 정밀 매핑"도 일괄 자동화에 해당함을 명문화.**
> **진짜 정밀 손 작업은 화면별로 .cs/.Designer.cs를 직접 Read하여 처음부터 끝까지 읽고 모든 내용을 누락 없이 추출하는 것.**

### 16.1 사용자 재지적 (2026-05-21)

> "상세하게 작성해달라고 요청했는데, SHEET 의 대부분이 다 비어있네요. 진짜 이정도 수준으로 만들어달라고 요청하지 않았습니다.
> 현재의 DM 의 화면분석서를 만드는 수준으로 상세하게 소스를 각각의 화면분석서를 생성할 때마다 각각의 소스를 직접 다 읽어서
> 소스의 모든 부분이 누락되지 않도록 보완해주세요. 일괄적으로 만들지 말고 화면 하나 하나에 대해서 각각의 소스를 읽어서
> 소스의 모든 부분이 누락되지 않도록 해주세요."

### 16.2 v7.4 절대 의무

| # | 의무 | 위반 시 |
|---:|---|---|
| 28 | ✓ 각 화면별로 .cs 파일 **전체** Read (처음 ~ 끝) | xlsx 시트 빈 칸 = 즉시 재작업 |
| 29 | ✓ 각 화면별로 .Designer.cs 파일 **전체** Read | 동일 |
| 30 | ✓ 13시트 모두 의미 있는 내용으로 채움 (빈 시트 = 위반) | 동일 |
| 31 | ✓ 호출 POPUP 식별 (cs 본문에서 `new XxxPopup()` / `xxx.ShowDialog()` 검색) | POPUP 누락 = 위반 |
| 32 | ✓ POPUP 도 화면별 분석서 작성 (이미 있으면 Link, 없으면 신규) | 누락 시 위반 |
| 33 | ✓ Validation: cs 본문의 모든 `MessageHelper.GMessageBox`/`MessageBox.Show` 추출 | 일부만 = 위반 |
| 34 | ✓ Expression: cs 본문의 모든 `siXxx.Set*` / `Lock*` / 계산식 추출 | 일부만 = 위반 |
| 35 | ✓ Call Chain: 각 핸들러가 호출하는 메서드 → SP → 다른 핸들러 | 추적 누락 = 위반 |

### 16.3 v7.4 vs v7.3 차이

| 항목 | v7.3 (이전, 무효) | v7.4 (현재 의무) |
|---|---|---|
| .cs Read 범위 | 메타 추출기 자동 파싱 | **사람이 처음부터 끝까지 읽음** |
| xlsx 13시트 | 메타 → 자동 채움 (대부분 빈 칸) | **각 시트 의미 있는 내용 (DM 수준)** |
| Validation | `GMessageBox\("([^"]+)"` regex만 | **조건/코드/액션/카테고리/Call Chain 전부** |
| Expression | (없음) | **Spread 계산식 / Lock / Merge / 합계 전부** |
| POPUP | (검색 안 함) | **cs 본문에서 추출 + 별도 분석서** |
| 시간/화면 | ~10초 (자동) | **5~15분 (정밀 손)** |

### 16.4 v7.3 산출물 무효화 (SCP/SSP/FP 일괄 생성분)

다음 산출물은 v7.4 룰 위반으로 **재작업 대상**:

- `_analysis/_screens/30_SCP_Screens/30_SCP_*.xlsx` (66건) — 메타 자동 채움, 시트 빈 칸 다수
- `_analysis/_screens/31_SSP_Screens/31_SSP_*.xlsx` (56건) — 동일
- `_analysis/_screens/32_FP_Screens/32_FP_*.xlsx` (95건) — 동일
- `Doc/_analysis/domain_{SCP,SSP,FP}/screens/*/analysis.md` (217건) — 동일

이들은 보존하되 "v7.4 재작업 필요" 마킹 후 화면별 진짜 정밀 분석으로 덮어쓰기.

### 16.5 v7.4 의무 절차 (화면 1개)

```
[Step 1] Read .Designer.cs 전체 (모든 컨트롤, Position, Size, Caption, 이벤트 바인딩)
[Step 2] Read .cs 전체 (Field 선언, DefColumns, SpdSheet, Form_Load, InitControls,
         DefineProperty, CreateSpread, InitSpread, FindData, SaveData, InsertRow,
         모든 *Button overrides, 모든 *_Click_Detected, 모든 spdXxx_* 핸들러,
         모든 Validation, 모든 Expression, 호출 SP, POPUP 호출 위치)
[Step 3] Read .resx (한글 리소스 / 메시지 / 라벨)
[Step 4] cs 본문에서 호출 POPUP 식별:
         - `new XxxPopup()` 패턴
         - `dlg.ShowDialog()` 패턴
         - `BaseForm.OpenForm` 호출
[Step 5] xlsx 13시트를 화면별로 정밀 작성 (DMF0008 수준):
         1_화면개요   — 메타 + 호출 POPUP 목록
         2_Layout    — ENG mockup (정밀 손 작업 SVG)
         3_UI목록    — Designer 모든 컨트롤 (label/caption/datatype/tabidx/width 등)
         4_Event     — 모든 핸들러 + Call Chain (메서드 호출 그래프)
         5_기능     — 기능별 (조회/저장/삭제/추가/특수 액션)
         6_APIEndpoint — 모든 FoxDataRequest + To-Be REST
         7_연결SP    — SP 본문 분석 (Lines/Tables/복잡도/Tx)
         8_연결Tables — 모든 SP 본문의 참조 테이블 추출
         9_변경이력  — 작성 이력
         10_ToBe권장 — 화면별 To-Be 권장 사항
         11_Validation — 모든 GMessageBox 호출 (조건/MsgID/Column/Action)
         12_Expression — 모든 Spread 계산식 (Lock/Merge/합계 변수)
         13_단위테스트시나리오 — 화면별 시나리오 + 입력/기대결과
[Step 6] analysis.md 보강 (DMF0008 수준 — 600+ 라인)
[Step 7] mockup SVG 손 작업 (정밀)
[Step 8] xlsx 2_Layout 임베드
[Step 9] POPUP 화면 분석서 별도 생성 (Step 1~8 반복)
[Step 10] 검증 (시트 빈 칸 0건)
```

### 16.6 변경 이력

- 2026-05-21 (v7.4): "메타 자동 생성도 일괄 자동화" 명문화. SCP/SSP/FP 일괄 자동 산출물 무효화. 화면당 진짜 정밀 분석 의무 (5~15분/화면, DMF0008 수준).
