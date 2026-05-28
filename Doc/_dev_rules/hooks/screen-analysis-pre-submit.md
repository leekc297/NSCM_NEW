# Hook — Screen Analysis Pre-Submit (PR 머지 직전 최종 검증)

> ⚠️ **이 Hook 실행 전 반드시 Read**: `Doc/_dev_rules/hooks/anti-simplification.md` (2026-05-22 신규)
> 작업 단순화 절대 금지 — 다중 패턴, Cross-check, 기존 자료 활용 의무. 위반 시 신뢰성 손상.


> **언제 사용**: 화면 분석서 PR을 제출하기 직전, 또는 머지 게이트에서.
> **AI 동작**: 본 파일을 `Read` 한 후, 아래 체크리스트를 전수 점검. 1건이라도 ✗이면 머지 차단.
> **관련 룰**: `19_MOCKUP_SVG_RULES.md`, `20_SCREEN_ANALYSIS_PIPELINE.md`, `18_CODE_REVIEW_CHECKLIST.md`

---

## 1. 메타 일관성 (필수)

```
[화면 ID 일치 5곳 검증]
☐ 파일명: {prefix}_{ScreenId}.xlsx
☐ 1_화면개요 R5 "화면 ID"
☐ 11_Validation 시트 R1 헤더
☐ 12_Expression 시트 R1 헤더
☐ MD 폴더명: Doc/_analysis/domain_{X}/screens/{ScreenId}/
☐ MD 8종의 H1 헤더 (예: "# DMF0020_SalesFuturePrice — ...")
```

모두 같은 ScreenId여야 함. 1곳이라도 다르면 **즉시 머지 차단**.

---

## 2. 산출물 완전성

### 2.1. MD 파일 8종
```
Doc/_analysis/domain_{X}/screens/{ScreenId}/
☐ analysis.md          (As-Is 분석)
☐ source_links.md      (Legacy 경로)
☐ web_components.md    (As-Is → To-Be 매핑)
☐ tobe_design.md       (To-Be 설계)
☐ oracle_migration.md  (DB 변환)
☐ figma_link.md        (Figma)
☐ validation.md        (Validation 추출)
☐ expressions.md       (Expression 추출)
```

### 2.2. xlsx 12시트
```
{xlsx_dir}/{prefix}_{ScreenId}.xlsx
☐ 1_화면개요
☐ 2_Layout         (← PNG 임베드 필수)
☐ 3_UI목록
☐ 4_Event
☐ 5_기능
☐ 6_APIEndpoint
☐ 7_연결SP
☐ 8_연결Tables
☐ 9_변경이력
☐ 10_ToBe권장
☐ 11_Validation   (← .cs 원소스 파싱)
☐ 12_Expression   (← .cs 원소스 파싱)
```

### 2.3. Mockup 시각 자료
```
{xlsx_dir}/
☐ {ScreenId}_Mockup_KOR.svg  (한글 라벨)
☐ {ScreenId}_Mockup_ENG.svg  (영문 라벨)
☐ xl/media/image1.png  (xlsx 내부 임베드, 크기 > 10KB)
```

### 2.4. 백업
```
☐ {xlsx_dir}/__bak_YYYYMMDD/{prefix}_{ScreenId}.xlsx (원본 보존)
☐ {xlsx_dir}/__bak_YYYYMMDD/README.txt (백업 사유 기록)
```

---

## 3. 카운트 일치 의무 (PR 머지 게이트 — 룰 09 §1 원칙 1)

```
☐ validation.md "총 N건"           == 11_Validation 행 수 (헤더 제외)
☐ expressions.md "총 N건"          == 12_Expression 행 수 (헤더 제외)
☐ phase2b designs[*].controls 수   ≈ 3_UI목록 행 수 (±5 허용)
☐ phase2b designs[*].events 수     ≈ 4_Event 행 수 (±2 허용)
☐ phase3.sps[prefix=*] 수          == 6_APIEndpoint 행 수
☐ 11_Validation count              == To-Be useXxxValidation hook 항목 수 (Frontend 코드 머지 시)
☐ 12_Expression count              == To-Be Wijmo cellTemplate/aggregate 항목 수
```

**누락 0건**. 1건이라도 누락되면 PR reject.

---

## 4. 무손상 보존 검증

```
☐ MD5(new.11_Validation) == MD5(bak.11_Validation)
☐ MD5(new.12_Expression) == MD5(bak.12_Expression)
☐ 2_Layout PNG가 기존(백업본) PNG와 동일하거나, 의도된 v2 빌더 결과
```

---

## 5. 시각 자료 검증

```
☐ KOR/ENG SVG 두 파일 viewBox 동일 (도형 좌표 동일)
☐ ENG SVG → PNG 렌더링 확인 (cairosvg)
☐ PNG 렌더링 시 모든 컨트롤이 정확한 위치에 표시 (겹침 없음)
☐ 2_Layout 시트의 PNG가 시각적으로 GSCM 표준 레이아웃 (타이틀바 + 메뉴 + Filter + Spread + Buttons + Framework Auto-Events)
```

---

## 6. 한글 폰트 미설치 환경 대응

```
☐ ENG SVG가 한글 텍스트를 포함하지 않음 (사전 변환 사전 적용)
☐ KOR SVG는 시스템 한글 폰트가 있을 때만 사용 (브라우저는 자동 fallback)
☐ 2_Layout 시트 R5에 "ENG SVG → 1400px PNG 렌더링" 명시
```

---

## 7. 룰셋 동기화

```
☐ INDEX 갱신: Doc/_analysis/INDEX.md 또는 domain_{X}/INDEX.md에 작업 화면 등록
☐ PROGRESS 갱신: Doc/_analysis/PROGRESS.md에 작업 일자 + 변경 사유 기록
☐ TodoList 갱신: 작업 완료 항목 체크
```

---

## 8. PR 메시지 표준 포맷

```markdown
## 화면 분석서 [화면 ID] - {복구/신규/보강}

**작업 일자**: 2026-MM-DD
**도메인**: {DM|Common|SCM|FP|SCP|SSP}
**시나리오**: (A) 백업 PNG 유지 / (B) v2 신규 생성 / (C) To-Be 신규

### 변경 사유
- (꼬임 복구 사유 또는 신규 화면 명세)

### 산출물
- [x] xlsx 12시트 풀스코프
- [x] KOR/ENG SVG 두 벌
- [x] 2_Layout PNG 임베드
- [x] 백업 (__bak_YYYYMMDD/)
- [x] MD 8종 검증 완료

### 카운트
- Validation: MD {N}건 == xlsx 11_Validation {N}건
- Expression: MD {N}건 == xlsx 12_Expression {N}건
- UI 컨트롤: phase2b {N}개 ≈ 3_UI목록 {N}행

### 검증
- [x] 화면 ID 5곳 일치
- [x] 11/12 MD5 무손상
- [x] PNG > 10KB 임베드
- [x] SVG KOR/ENG 두 벌
```

---

## 9. 절대 금지 (Top 7)

1. ❌ MD에 카운트 변경 없이 xlsx만 수정
2. ❌ 11/12 시트를 새로 만들기 (백업본 복사 원칙)
3. ❌ 백업 없이 원본 덮어쓰기
4. ❌ 2_Layout PNG 임베드 없이 SVG 텍스트만 명시 (사고 #2 재발)
5. ❌ Designer.cs 좌표 직접 매핑 (사고 #4 재발)
6. ❌ 1단계 추출기 캐시 재사용 의심 무시 (사고 #1 재발)
7. ❌ 화면 ID 불일치 무시 (꼬임 무시)

---

## 10. 머지 가능 최종 확인

다음 모든 항목이 ✓이면 머지 가능:

```
☐ §1 메타 일관성 (화면 ID 5곳 일치)
☐ §2 산출물 완전성 (MD 8 + xlsx 12시트(+캡쳐 보완 시 13~20) + SVG 2 + PNG 1)
☐ §3 카운트 일치 의무
☐ §4 무손상 보존 (11/12 MD5)
☐ §5 시각 자료 검증
☐ §6 한글 폰트 대응
☐ §7 룰셋 동기화
☐ §8 PR 메시지 표준 포맷
☐ §12 사용자 캡쳐 매핑 (제공된 경우 — v6 추가)
```

1건이라도 ✗ → 머지 차단 + 후속 작업 진행.

---

## 12. 사용자 캡쳐 매핑 머지 게이트 (v6 신설, 2026-05-21)

`C:/Projects_Document/NSCM/AsIs_UI_Sample/` 또는 uploads 캡쳐가 제공된 화면은 다음 머지 게이트를 통과해야 함.

### 12.1 캡쳐 ↔ 시트 1:1 매핑 추적표

`Doc/_analysis/domain_*/screens/{ScreenId}/source_links.md` 에 다음 표가 존재해야 함:

```markdown
### 사용자

## 11. v6.4 컨테이너 계층 머지 게이트 (2026-05-21 신설)

PR 머지 전 다음 모든 항목 ✓:

```
☐ Designer.cs SplitContainer 수 == mockup 의 분할 영역 수
☐ Designer.cs XtraTabControl + TabPage 수 == mockup 의 Tab 탭바 + 페이지 수
☐ .cs AddSheet 호출별 spread 매핑 == mockup 의 Spread 별 sheet 탭 수
☐ MD analysis.md 의 §v6.4 섹션 (컨테이너 계층 표 + Spread별 Sheet 표) 존재
☐ xlsx 2_Layout 시트의 "컨테이너 계층" 표 + "Spread별 Sheet" 표 + ENG PNG 임베드 존재
☐ 9_변경이력 v6.4 행 존재
```

위 6가지 1건이라도 ✗ → 머지 차단.

### 11.1 자동 검증 명령

```bash
python3 outputs/dm_analyze_v2.py    # 메타 재추출
python3 outputs/dm_gen_v2.py        # mockup 재생성
python3 outputs/dm_embed_v2.py      # xlsx 갱신
```

### 11.2 사례 — DMF0008 머지 게이트 통과

| 항목 | 검증 |
|---|---|
| SplitContainer = 1 | mockup 상하 분할 ✓ |
| Panel1 내 FpSpread = 2 (spdSummary + spdRepair) | 좌우 분할 표현 ✓ |
| Panel2 내 FpSpread = 1 (spdSub) | 하단 단일 Spread 표현 ✓ |
| spdSub AddSheet = 2 (Sales_Site + SSPM) | sheet 탭 2개 표시 ✓ |
| MD §v6.4 섹션 | ✓ |
| xlsx 컨테이너/Spread 표 + PNG | ✓ |

→ 머지 가능 ✓


## 12. v7.0 통합 머지 게이트 (2026-05-21)

```
☐ §10 머지 가능 항목 모두 ✓
☐ §11 컨테이너 계층 모두 ✓ (v6.4)
☐ §12 사용자 캡쳐 매핑 (제공 시) ✓ (v6.0)
☐ Designer.cs Dock 중첩 3+단 화면 → 손 작업 mockup ✓ (v6.7)
☐ DefColumns 그룹 → Spread별 컬럼 매핑 명시 ✓ (v6.6/v3)
☐ POPUP 클래스 → 공통/신규/Link 분류 ✓ (v6.5)
☐ KOR PNG 한글 정상 (Playwright 변환 검증) ✓ (v7.0)
☐ xlsx 2_Layout 에 ENG PNG 임베드 ✓ (한글 깨짐 회피)
☐ MD analysis.md 에 v6.x/v7.0 변경이력 + 영역별 구조 표
☐ 9_변경이력 v6.x/v7.0 행
```

위 10개 모두 ✓ 이면 머지 가능. 1건이라도 ✗ → 차단.

### 12.1 사례 — DMF0008 v6.7 머지 게이트 통과

| 항목 | 검증 |
|---|---|
| 4단 Dock 중첩 → 손 작업 ✓ | Filter / Summary / Repair / Sub |
| 캡쳐 컬럼명 일치 ✓ | 5+18+16 컬럼 |
| ENG PNG 깨짐 0 ✓ | 캡쳐와 완벽 일치 |
| KOR SVG 한글 정상 ✓ | "Summary", "SCM 기준정보 정비 필요 리스트" |
| MD §v6.7 ✓ | 9개 영역 표 |


## 13. v7.1 영문 mockup 머지 게이트 (2026-05-21)

```
☐ xlsx 2_Layout 임베드 PNG 가 ENG (한글 깨짐 0건)
☐ KOR/ENG SVG + KOR/ENG PNG 4벌 보관
☐ Windows 재변환 스크립트 안내 (outputs/convert_kor_svg_to_png_windows.ps1)
☐ MD 의 Mockup 섹션에 v7.1 정책 명시 (ENG 표준 + KOR 환경 의존)
```

위 4건 ✓ 시 머지 가능.


## 14. v7.2 머지 게이트 — 개별 .cs 정밀 분석 의무 (2026-05-21)

```
☐ 본 mockup 이 일괄 자동화 결과가 아닌 개별 .cs 정밀 분석 결과
☐ DefColumns 그룹 → Spread별 컬럼 매핑 명확 (generic placeholder 없음)
☐ 컨테이너 계층 (SplitContainer/TabPage/Panel/UsrLayoutControl) 모두 표현
☐ Designer.cs 한글 라벨 정확 사용
☐ POPUP mockup도 개별 .cs 분석 (일괄 처리 금지)
☐ xlsx 2_Layout 임베드는 ENG PNG (한글 깨짐 회피)
☐ MD analysis.md 영역별 구조 표 + DefColumns 매핑 표
```

위 7건 ✓ 시 머지 가능. 1건이라도 ✗ → 즉시 차단 + 개별 손 작업 재진행.


---

## §15. v7.3 — "소스기반 정밀 손 작업" PR 머지 게이트 (2026-05-21 사용자 지시)

### 15.1 PR 제출 직전 최종 점검 (모두 ✓ 필수, 1건이라도 ✗ → 즉시 차단)

| # | 검증 항목 | 검증 명령 |
|---:|---|---|
| 1 | 화면별 손 작업 빌더 파일 존재 | `ls outputs/gen_*_handcrafted.py` |
| 2 | 화면당 빌더 함수 1개 (1:N 금지) | `grep "def gen_" outputs/gen_xxx_handcrafted.py` |
| 3 | .cs / .Designer.cs Read 증거 | analysis.md "POPUP/화면 정밀 사양" 섹션 존재 |
| 4 | 컨테이너 계층 표 부착 | analysis.md "컨테이너 계층" 표 |
| 5 | Grid 컬럼 표 부착 | analysis.md "Grid 컬럼" 표 (AddColumn 결과 1:1) |
| 6 | ButtonList 표 부착 | analysis.md "ButtonList N건" 표 |
| 7 | xlsx 2_Layout ENG PNG 임베드 | openpyxl 검증 통과 |
| 8 | analysis.md "정밀 손 작업" 마커 | `grep "정밀 손 작업 (v3 빌더 덮어쓰기 금지)"` |
| 9 | analysis.md "수작업" 마커 | `grep "아니오 (수작업"` |
| 10 | KOR PNG 깨짐 점검 | PNG 시각 검사 |
| 11 | v3 빌더 결과 사용 흔적 0건 | `grep -r "v3 빌더 (Designer.cs + .cs 정밀 추출)" /paths` (없어야 함) |

### 15.2 v3 빌더 사용 금지 검증 자동화

```bash
# v3 빌더 결과로 표시된 analysis.md 가 1개라도 있으면 머지 차단
COUNT=$(grep -l "v3 빌더 (Designer.cs + .cs 정밀 추출)" \
    Doc/_analysis/domain_*/screens/*/analysis.md 2>/dev/null | wc -l)
if [ "$COUNT" -gt 0 ]; then
    echo "❌ v7.3 위반: v3 빌더로 표시된 화면 $COUNT 개 발견 → 머지 차단"
    exit 1
fi
echo "✓ v7.3 통과: 모든 화면이 정밀 손 작업"
```

### 15.3 변경 이력

- 2026-05-21 (v7.3): "소스기반 정밀 손 작업" PR 머지 게이트 11건 + v3 빌더 사용 금지 자동 검증 추가


---

## §16. v7.4 — PR 머지 게이트 (2026-05-21)

### 16.1 PR 제출 직전 최종 점검 (전 도메인)

```bash
# v7.4 빌더 사용 표시 확인
grep -l "v7.4 진짜 정밀 손 작업" Doc/_analysis/domain_{SCP,SSP,FP}/screens/*/analysis.md | wc -l
# 예상: SCP 70 + SSP 58 + FP 112 = 240

# v3 빌더 사용 표시 잔존 확인 (0이어야 함)
grep -l "v3 빌더 (Designer.cs + .cs 정밀 추출)" Doc/_analysis/domain_{SCP,SSP,FP}/screens/*/analysis.md 2>/dev/null | wc -l
# 0이어야 함

# xlsx 13시트 모두 filled cells 30+ 일괄 검증
for f in _analysis/_screens/{30_SCP,31_SSP,32_FP}_Screens/*.xlsx; do
  python3 -c "
from openpyxl import load_workbook
wb = load_workbook('$f')
for sn in wb.sheetnames:
    ws = wb[sn]
    cnt = sum(1 for r in ws.iter_rows() for c in r if c.value)
    if cnt < 20:
        print(f'⚠ $f $sn: {cnt} cells')
        break
"
done

# 통합 매트릭스 갱신 확인
test -f _analysis/Screen_POPUP_SP_Tables_Matrix.xlsx
```

### 16.2 v7.4 산출물 인벤토리 (정상 카운트)

| 도메인 | xlsx | ENG PNG | analysis.md | 통합 매트릭스 |
|---|---:|---:|---:|---|
| DM | 85 | 84 | 82 | ✓ |
| SCP | 66 | 66 | 70 | ✓ |
| SSP | 56 | 56 | 58 | ✓ |
| FP | 95 | 95 | 112 | ✓ |
| **합계** | **302** | **301** | **322** | **Screen_POPUP_SP_Tables_Matrix.xlsx** |

### 16.3 변경 이력

- 2026-05-21 (v7.4): PR 머지 게이트 + 도메인별 인벤토리 정상 카운트 명시
