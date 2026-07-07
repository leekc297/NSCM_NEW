# DMF0008 ErpEdiMaster — Figma 레이아웃 상세 분석 (정비)

> 출처: 메인 Figma `c9VYF8oleb9TczKeFWi4ka` / 프레임 **"Master > Demand Master > ERP EDI MASTER 정비"** node **5883:159383** (1920×963, lastModified 2026-04-09).
> 좌표 = 프레임 원점(0,0) 기준 상대 px. 공용 shell(Header 52 / Left Menu 230)은 MDI 공통 → DMF0008 feature 변경 대상 아님.
> 작성: 2026-06-28 (fetch-figma + SVG 라벨 추출). 텍스트 라벨은 컴포넌트 인스턴스라 JSON 미노출 → SVG 에서 추출.

## 1. 전체 골격 (y = 프레임 상대)

| 영역 | y | w | h | 비고 |
|---|---:|---:|---:|---|
| Header (공용) | 0 | 1920 | 52 | MDI shell (무변경) |
| Page Container | 52 | 1920 | 911 | = Left Menu(230) + 본문 Page Container(1690) |
| └ Left Menu (공용) | 52 | 230 | 911 | MDI shell (무변경) |
| └ 본문 Page Container | 52 | 1690 | 911 | MDI Tab(32) + Contents |
| **Contents** | 84 | **1626** | 879 | ⭐ DMF0008 feature 콘텐츠 (좌우 패딩 후 1626) |

## 2. Contents 내부 (y 상대, 콘텐츠폭 1626)

| 순서 | 영역 | y | w | h | 구성 |
|---:|---|---:|---:|---:|---|
| 1 | **Page Title** | 84 | 1626 | **48** | Bookmark(24) + H2 타이틀 + Breadcrumb + Switch Button(125) |
| 2 | **Search Area** | 132 | 1626 | **48** | Search Form(1457) + Btn Area(113: 검색버튼 84 + 토글 32 등) |
| – | Spacing | 180 | 1626 | 12 | |
| 3 | **_Sub Title Area** | 192 | 1626 | **28** | Sub Title(H3) + Count(55) + 우측 버튼행(887) |
| – | Spacing | 220 | 1626 | 4 | |
| 4 | **Content** | 224 | 1626 | **731** | Top(527) + Spacing(24) + 하단 Module(180) |
| 4a | **Top** | 224 | 1626 | **527** | ⭐ **2-컬럼**: Module **400**(좌) + Spacing 24 + Module **1202**(우) |
| 4b | 하단 **Module** (Sub) | 775 | 1626 | **180** | Tab(36) + Spacing 12 + Table(132) |

## 3. ⭐ 핵심 변경점 — Top 영역 2-컬럼 (현재 FE 와 상이)

- **현재 FE**: Summary / Repair / Sub 를 **세로 3단**(flex 3:3:4) 적층.
- **Figma**: **Top(527h) = 좌 패널(400w) | 우 패널(1202w) 가로 2분할** + **하단(180h) = Sub 탭(SalesSite/SSPM)**.
  - 좌 400 / 우 1202 그리드 정체(Summary vs Repair 추정) = **이미지 시각 확인 필요**(현재 Figma API 429 rate limit). SVG 라벨상 "Summary" 그리드(No/Div/EDI Sender Name/GSCM Master/…) + 또 다른 그리드(No/Div/EDI Sender Name/…) 2개 존재.
- 하단 Module(180) = Tab(36, Sales Site/SSPM) + Table(132).

## 4. Search Area 필드 (SVG 라벨)
- **Div.** (필수 Dropdown) / **Last Update Start:** / **Last Update End** (legend) / **Search (F5)** 버튼.
- 모든 객체 높이 32(필드)~48(영역) — 조회조건 36px 표준(#94)·검색영역 48 정합.

## 5. ⭐ Sub Title Area 버튼 9종 (SVG 라벨 + 너비, 좌→우)
| # | 버튼 | hotkey | Figma 너비(px) |
|---:|---|---|---:|
| 1 | Search | F5 | 101 |
| 2 | Status Update | – | 93 |
| 3 | Insert | F8 | 97 |
| 4 | **Delete** | **F9** | 87 |
| 5 | Save | F7 | 84 |
| 6 | Sort | F3 | 90 |
| 7 | Filter | F4 | 116 |
| 8 | Condition | F6 | 159 |
| 9 | Reset Condition | F10 | 102 |

> ⭐ **Delete (F9) 버튼이 Figma 디자인에 이미 존재** — 신규 추가 요구와 정합 (hotkey F9). 매핑은 버튼 너비 순서 기준 추정(라벨↔너비 1:1은 이미지 확인 시 확정).

## 6. 적용 방침 (Phase 2/3)
- Top 영역을 2-컬럼(좌 400 / 우 1202)으로 재구성 + 하단 Sub 탭(180). 비율: Top:하단 ≈ 527:180. 좌:우 = 400:1202 (≈ 24.6% : 74%, gap 24).
- Title 48 / Search 48 / SubTitle 28 / Tab 36 높이 정합. 조회조건 36(#94)·헤더(#93)·zebra·backcolor(#95) 유지.
- Delete(F9) 버튼 추가(hotkeyConfig.delete + 권한 메타).
