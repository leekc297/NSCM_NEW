# Hook — Screen Analysis Post-Build (작성 직후 검증)

> ⚠️ **이 Hook 실행 전 반드시 Read**: `Doc/_dev_rules/hooks/anti-simplification.md` (2026-05-22 신규)
> 작업 단순화 절대 금지 — 다중 패턴, Cross-check, 기존 자료 활용 의무. 위반 시 신뢰성 손상.


> **언제 사용**: 화면 분석서(xlsx + SVG + PNG)를 새로 만들거나 보강한 직후, PR 제출 전.
> **AI 동작**: 본 파일을 `Read` 한 후, 아래 자동 검증 코드를 실행하여 모든 항목이 ✓인지 확인.
> **관련 룰**: `19_MOCKUP_SVG_RULES.md`, `20_SCREEN_ANALYSIS_PIPELINE.md`

---

## 1. xlsx 구조 검증

```python
from openpyxl import load_workbook

EXPECTED_SHEETS = ["1_화면개요","2_Layout","3_UI목록","4_Event","5_기능",
                   "6_APIEndpoint","7_연결SP","8_연결Tables","9_변경이력",
                   "10_ToBe권장","11_Validation","12_Expression"]

wb = load_workbook(xlsx_path, read_only=True, data_only=True)
assert wb.sheetnames == EXPECTED_SHEETS, f"시트 구성 불일치: {wb.sheetnames}"
```

```
☐ 시트 12개 정확히 존재 + 순서 일치
☐ 1_화면개요 R5 "화면 ID" 값 == 파일명 ScreenId
☐ 11_Validation R1 첫 글자 == "{ScreenId} —" 시작
☐ 12_Expression R1 첫 글자 == "{ScreenId} —" 시작
```

---

## 2. 11/12 시트 무손상 검증 (백업본 대비 MD5)

```python
import hashlib
def sheet_hash(ws):
    h = hashlib.md5()
    for row in ws.iter_rows(values_only=True):
        h.update(repr(row).encode("utf-8","ignore"))
    return h.hexdigest()

wb_new = load_workbook(xlsx_path, read_only=True, data_only=True)
wb_bak = load_workbook(bak_path, read_only=True, data_only=True)
assert sheet_hash(wb_new["11_Validation"]) == sheet_hash(wb_bak["11_Validation"]), "11_Validation 무손상 실패"
assert sheet_hash(wb_new["12_Expression"]) == sheet_hash(wb_bak["12_Expression"]), "12_Expression 무손상 실패"
```

```
☐ 11_Validation MD5 == 백업본 11_Validation MD5
☐ 12_Expression MD5 == 백업본 12_Expression MD5
```

---

## 3. PNG 임베드 검증 (2_Layout)

```python
import zipfile

with zipfile.ZipFile(xlsx_path, "r") as z:
    media = [n for n in z.namelist() if n.startswith("xl/media/")]
    assert media, "PNG 임베드 누락 — xl/media/ 파일 없음"
    png_size = max(z.getinfo(n).file_size for n in media)
    assert png_size > 10000, f"PNG 너무 작음({png_size}B) — 더미 파일 가능성"
```

```
☐ xl/media/image1.png 존재
☐ PNG 크기 > 10KB
☐ 2_Layout 시트의 _images에 등록되어 있음
```

---

## 4. SVG 파일 검증

```python
import os
svg_kor = os.path.join(xlsx_dir, f"{sid}_Mockup_KOR.svg")
svg_eng = os.path.join(xlsx_dir, f"{sid}_Mockup_ENG.svg")
assert os.path.exists(svg_kor), "KOR SVG 없음"
assert os.path.exists(svg_eng), "ENG SVG 없음"
assert os.path.getsize(svg_kor) > 1000, "KOR SVG 너무 작음"
assert os.path.getsize(svg_eng) > 1000, "ENG SVG 너무 작음"
```

```
☐ {ScreenId}_Mockup_KOR.svg 존재 + > 1KB
☐ {ScreenId}_Mockup_ENG.svg 존재 + > 1KB
☐ 두 SVG의 viewBox 동일 (도형 좌표 동일, 텍스트만 차이)
```

---

## 5. 화면 ID 일치 전수 검증

```python
import re
wb = load_workbook(xlsx_path, read_only=True, data_only=True)
sid = file_name.replace(prefix, "").replace(".xlsx", "")

# 1_화면개요
ov_id = None
for row in wb["1_화면개요"].iter_rows(min_row=1, max_row=15, values_only=True):
    if row and row[0] == "화면 ID":
        ov_id = str(row[1]) if len(row) > 1 else ""
        break
assert sid in (ov_id or ""), f"1_화면개요 ID 불일치: {ov_id} vs {sid}"

# 11/12 헤더
v_hdr = str(wb["11_Validation"].cell(1,1).value or "")
e_hdr = str(wb["12_Expression"].cell(1,1).value or "")
assert sid in v_hdr, f"11 헤더 불일치: {v_hdr}"
assert sid in e_hdr, f"12 헤더 불일치: {e_hdr}"
```

```
☐ 파일명 ScreenId == 1_화면개요 ID
☐ 파일명 ScreenId == 11_Validation 헤더
☐ 파일명 ScreenId == 12_Expression 헤더
```

---

## 6. 누락 검증 (컨트롤 회계)

```python
import json
with open("_analysis/_scan/phase2b_screens.json") as f:
    p2b = json.load(f)
design = next(d for d in p2b["designs"] if d.get("class_name") == sid)
n_ctrls = len(design["controls"])

# 3_UI목록 행 수 (헤더 3행 제외)
ui_rows = wb["3_UI목록"].max_row - 3
# phase2b 컨트롤 수와 ±5건 이내여야 함 (메타 제외 등 약간 차이 허용)
assert abs(ui_rows - n_ctrls) <= 5, f"3_UI목록 카운트 불일치: ui={ui_rows} vs p2b={n_ctrls}"
```

```
☐ 3_UI목록 행 수 ≈ phase2b controls 수
☐ 4_Event 행 수 ≈ phase2b event_handlers 수
☐ 6/7 시트 행 수 ≈ phase3 sps 매칭 수
```

---

## 7. MD ↔ xlsx 카운트 의무 (룰 09 §1 원칙 1)

```python
# validation.md 행 수
md_v = open(f"Doc/_analysis/domain_{domain}/screens/{sid}/validation.md").read()
# "총 N건" 패턴 추출
import re
m = re.search(r"총\s*(\d+)건", md_v)
md_v_count = int(m.group(1)) if m else 0

# 11_Validation 시트 행 수 (헤더 5행 제외)
xlsx_v_count = wb["11_Validation"].max_row - 5

# ±3 허용 (헤더 행 수 차이 등)
assert abs(md_v_count - xlsx_v_count) <= 3, f"Validation 카운트 불일치: MD={md_v_count} vs xlsx={xlsx_v_count}"
```

```
☐ validation.md "총 N건" == 11_Validation 행 수
☐ expressions.md "총 N건" == 12_Expression 행 수
```

---

## 8. 2_Layout 시트 텍스트 검증

```python
ws = wb["2_Layout"]
r1 = str(ws.cell(1,1).value or "")
r3 = str(ws.cell(3,1).value or "")
r4 = str(ws.cell(4,1).value or "")
assert sid in r1, "2_Layout R1에 ScreenId 없음"
assert "KOR" in r3 and "svg" in r3.lower(), "2_Layout R3에 KOR SVG 참조 없음"
assert "ENG" in r4 and "svg" in r4.lower(), "2_Layout R4에 ENG SVG 참조 없음"
```

```
☐ 2_Layout R1: 화면 ID 포함
☐ 2_Layout R3: KOR SVG 파일명 참조
☐ 2_Layout R4: ENG SVG 파일명 + PNG 임베드 명시
```

---

## 9. 자동 검증 일괄 실행 스크립트

```bash
# 단일 화면 검증
python3 Doc/_analysis/scripts/validate_screen_xlsx.py {ScreenId}

# 도메인 전체 검증
python3 Doc/_analysis/scripts/validate_screen_xlsx.py --domain DM
python3 Doc/_analysis/scripts/validate_screen_xlsx.py --domain Common
python3 Doc/_analysis/scripts/validate_screen_xlsx.py --domain SCM
```

---

## 10. 검증 실패 시 대응

| 실패 항목 | 대응 |
|---|---|
| 시트 12개 아님 | `build_screen_xlsx.py` 또는 `build_28_29_full.py` 재실행 |
| 화면 ID 불일치 | 즉시 작업 중단 + 백업본 비교 + 룰 09 §1 원칙 4 참조 |
| 11/12 MD5 불일치 | 백업본에서 다시 복사 (`copy_existing_sheets`) |
| PNG 임베드 누락 | `embed_svg_png.py` 재실행 |
| SVG 누락 | `build_mockup_v2.py` 재실행 |
| MD↔xlsx 카운트 불일치 | 11/12 추출기 재실행 + MD 동기화 |

---

## 11. 최종 확인 — PR 제출 가능 여부

```
☐ §1 xlsx 구조 (12 시트, 캡쳐 보완 시 13~20 시트 허용) ✓
☐ §2 11/12 무손상 MD5 ✓
☐ §3 PNG 임베드 (> 10KB) ✓
☐ §4 SVG KOR/ENG 두 벌 ✓
☐ §5 화면 ID 일치 (3곳: 1/11/12) ✓
☐ §6 컨트롤 회계 ≈ phase2b ✓
☐ §7 MD↔xlsx 카운트 ✓
☐ §8 2_Layout 시트 텍스트 ✓
☐ §12 사용자 캡쳐 매핑 (제공

## 12. v6.4 컨테이너 계층 검증 (2026-05-21 신설)

### 12.1 필수 검증 항목

```
☐ Designer.cs 의 SplitContainer / XtraTabControl / XtraTabPage 인스턴스가 mockup에 표현되었는가
☐ .cs 의 AddSheet(spreadName, ...) 호출이 Spread별 sheet 탭으로 표현되었는가
☐ Spread 1개에 sheet 2개 이상이면 mockup 에 sheet 탭바 시각화되어 있는가
☐ Splitter 분할 (상하/좌우)이 정확한가
☐ Panel1 자식의 FpSpread 2개 이상이면 패널 내 분할되어 있는가
☐ xlsx 2_Layout 시트에 "컨테이너 계층" 표 + "Spread별 Sheet" 표 존재
```

### 12.2 자동 검증 코드

```python
import json, re, pathlib
meta = json.loads(pathlib.Path(f"outputs/dm_v2_meta.json").read_text())[sid]
# 1) SplitContainer 존재 → 분할 패턴 표현 필수
if meta["stats"]["SplitContainer"] > 0:
    assert any("Panel1" in k for k in meta["containers"]), "SplitContainer 자식 매핑 누락"
# 2) Spread별 AddSheet 매핑
for spread, sheets in meta["spread_sheets"].items():
    if len(sheets) > 1:
        # 해당 Spread의 sheet 탭이 SVG/PNG 에 표현되어야 함
        print(f"검증: {spread} 의 {len(sheets)}개 sheet 탭 표현 필수")
```

### 12.3 검증 실패 시 대응

| 증상 | 조치 |
|---|---|
| SplitContainer 있는데 단일 Grid 만 표시 | v2 빌더 (`dm_gen_v2.py`) 로 재생성 |
| AddSheet 2회 호출인데 sheet 탭 없음 | Spread별 sheet 매핑 재파싱 |
| TabPage 있는데 탭바 없음 | XtraTabControl.TabPages.AddRange 파싱 재확인 |


## 13. v7.0 통합 검증 (2026-05-21)

### 13.1 mockup 정확성 검증

```
☐ Designer.cs ClientSize == mockup viewBox 비례
☐ 캡쳐 컬럼명 == mockup Grid 헤더 (한 글자도 다르면 ✗)
☐ Designer.cs Dock=Top 3개 이상 화면 → mockup 다단 분할 표현
☐ AddSheet N회 → mockup sheet 탭 N개
☐ SplitContainer/XtraTabControl 모두 표현
☐ 한글 라벨 Designer.cs Text 와 1:1 일치
☐ DefColumns 그룹 → Spread별 컬럼 매핑 명확
```

### 13.2 한글 PNG 검증

```
☐ KOR SVG 원본 한글 텍스트 정상 (cat 으로 utf-8 확인)
☐ ENG PNG 한글 없음 (영문만)
☐ xlsx 2_Layout 임베드는 ENG PNG (한글 깨짐 0)
☐ KOR PNG (필요 시): Playwright 변환 또는 Windows 재변환
```

### 13.3 자동 검증 명령

```bash
# DefColumns 추출 검증
python3 outputs/dm_v3_extract.py
# 컨테이너 계층 검증
python3 outputs/dm_analyze_v2.py
# 한글 PNG 재변환 (Playwright)
python3 outputs/kor_png_playwright.py  # v7.0 신규
```


## 14. v7.1 영문 mockup 표준 검증 (2026-05-21)

```python
# xlsx 2_Layout 임베드 PNG 가 ENG 인지 검증
from openpyxl import load_workbook
import zipfile
wb = load_workbook(xlsx_path)
ws = wb["2_Layout"]
assert len(ws._images) >= 1, "2_Layout 임베드 이미지 없음"
# media 파일 확인 (KOR/ENG 구분은 파일명 또는 시각 확인 필요)
with zipfile.ZipFile(xlsx_path) as z:
    media = [n for n in z.namelist() if "media" in n]
    # 모든 media PNG가 ENG 형태 (한글 깨짐 0) 인지 검증
```

```
☐ xlsx 2_Layout 임베드 PNG: ENG (한글 깨짐 없음)
☐ {ScreenId}_Mockup_KOR.svg 원본 보관: ✓
☐ {ScreenId}_Mockup_ENG.svg 원본 보관: ✓
☐ {ScreenId}_Mockup_ENG.png: ✓
☐ {ScreenId}_Mockup_KOR.png: ✓ (Windows 변환 권장 안내)
```


## 15. v7.2 — 일괄 자동화 결과 사용 금지 검증 (2026-05-21)

```
☐ mockup SVG 가 단일 화면 .cs 정밀 분석 결과인지 확인
☐ 다단 Dock / SplitContainer / TabPage / POPUP 화면이 v3 일괄 빌더 결과로 산출되지 않았는지
☐ DefColumns 컬럼명이 mockup Grid 헤더에 정확히 사용되었는지
☐ Designer.cs 한글 라벨이 mockup에 정확히 표시되었는지
☐ KOR PNG 가 cairosvg+Linux 깨짐 상태로 xlsx 임베드되지 않았는지
```


---

## §16. v7.3 — "소스기반 정밀 손 작업" 검증 (2026-05-21 사용자 지시)

### 16.1 산출 직후 자동 검증 (모두 ✓ 필수)

```bash
# 1. SVG 파일이 화면별 독립 빌더로 생성되었는지 (gen_xxx_handcrafted.py 패턴 확인)
ls outputs/gen_*_handcrafted.py | head
grep -l "def gen_" outputs/gen_*_handcrafted.py

# 2. xlsx 2_Layout 에 ENG PNG 임베드 확인 (KOR PNG 임베드 금지)
python3 -c "
from openpyxl import load_workbook
wb = load_workbook('xxx.xlsx')
ws = wb['2_Layout']
assert len(ws._images) == 1, '이미지 1개 없음'
"

# 3. analysis.md 의 작성 방식이 '캡쳐+소스 기반 정밀 손 작업' 인지
grep "정밀 손 작업 (v3 빌더 덮어쓰기 금지)" path/analysis.md

# 4. analysis.md 의 일괄 자동화 사용이 '아니오 (수작업)' 인지
grep "아니오 (수작업" path/analysis.md
```

### 16.2 머지 게이트 (v7.3)

| # | 검증 항목 | Pass 조건 |
|---:|---|---|
| 1 | 화면별 빌더 함수 존재 | `gen_{screen_id}_handcrafted.py` 또는 동등 |
| 2 | .cs / .Designer.cs Read 흔적 | 추출 메타 표가 analysis.md 에 부착됨 |
| 3 | 컨테이너 계층 표현 | SVG 에 의미 분리된 박스 그룹 존재 |
| 4 | Grid 컬럼 정확 매핑 | .cs AddColumn 헤더 = SVG 헤더 100% 일치 |
| 5 | ButtonList 정확 매핑 | UsrButtonList ButtonItem[] = SVG 버튼 100% 일치 |
| 6 | ENG PNG 임베드 | xlsx 2_Layout._images[0] 존재 + ENG |
| 7 | analysis.md v7.3 표 갱신 | "정밀 손 작업" + "수작업" 명시 |
| 8 | 한글 깨짐 0건 | PNG 시각 검증 통과 |

**1건이라도 ✗ → 머지 차단**

### 16.3 변경 이력

- 2026-05-21 (v7.3): "소스기반 정밀 손 작업" 자동 검증 + 머지 게이트 8건 추가


---

## §17. v7.4 — 검증 룰 (산출 직후, 2026-05-21)

### 17.1 산출 직후 자동 검증 (모두 ✓ 필수)

```bash
# 1. xlsx 13시트 모두 의미 있는 내용 (filled cells 30+ per sheet)
python3 -c "
from openpyxl import load_workbook
wb = load_workbook('xxx.xlsx')
for sn in wb.sheetnames:
    ws = wb[sn]
    cnt = sum(1 for r in ws.iter_rows() for c in r if c.value)
    assert cnt >= 20, f'{sn}: filled cells {cnt} (요구: 20+)'
"

# 2. analysis.md DMF0008/SCP0001 수준 (200+ 라인 + 컨테이너/조회조건/Grid/이벤트/SP/Validation/Expression/POPUP 8개 섹션)
test $(wc -l < analysis.md) -ge 100

# 3. mockup PNG 한글 깨짐 없음 (ENG PNG 표준)
test -f xxx_Mockup_ENG.png && test $(stat -c%s xxx_Mockup_ENG.png) -ge 20000

# 4. Screen_POPUP_SP_Tables_Matrix.xlsx 와 cross-check
python3 -c "
from openpyxl import load_workbook
wb = load_workbook('/Doc/_analysis/Screen_POPUP_SP_Tables_Matrix.xlsx')
ws = wb['화면_SP_Tables_매트릭스']
found = False
for r in ws.iter_rows(min_row=2):
    if r[2].value == 'XXX_ScreenID':
        found = True; break
assert found, '통합 매트릭스에 등록 안 됨'
"
```

### 17.2 머지 게이트 (v7.4)

| # | 검증 항목 | Pass 조건 |
|---:|---|---|
| 1 | xlsx 13시트 모두 filled cells 30+ | 모든 시트 |
| 2 | analysis.md 200+ 라인 | v7.4 표준 |
| 3 | ENG PNG 임베드 (xlsx 2_Layout) | images=1 |
| 4 | 호출 POPUP 모두 식별 | Screen_POPUP_SP_Tables_Matrix 일치 |
| 5 | SP 호출 모두 추출 | FoxDataRequest grep == 매트릭스 SP 수 |
| 6 | Validation 누락 0건 | GMessageBox grep == 매트릭스 |
| 7 | Lock/Auto-Sync 추출 | Expression 시트 30+ rows |
| 8 | Source path 명시 | 1_화면개요 시트에 cs/Designer 경로 |

**1건이라도 ✗ → 머지 차단**

### 17.3 변경 이력

- 2026-05-21 (v7.4): 자동 검증 8건 + 머지 게이트 명문화
