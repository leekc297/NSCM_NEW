# SCP·DM 화면별 조회조건 AS-IS ↔ TO-BE 카탈로그 (전수)

> **원천**: `Doc/SCP_DM_화면별 조회조건 정리_260122_v0.4.xlsx` — `List` 시트 v0.4 (2026-01-22 기준, MD 변환 2026-07-13).
> **규모**: 총 **953행** (SCP 636 / DM 317) · **99개 화면** · 변경(O) **520** / 유지(X) **433**.
> **사용법(룰)**: `Doc/_rules_v2/hooks/search-condition-asis-tobe-catalog.md` (hook #112) — SCP/DM 화면 신규·수정 시 본 카탈로그의 해당 화면 표 전 행 대조 의무.
> **주의**: 이 파일은 원본 xlsx 의 정밀 변환본이다. 임의 수정 금지 — 원본 xlsx 개정 시 재생성 (생성 스크립트 방식: openpyxl 병합셀 해제 전수 추출).

## 0. 읽는 법 / 범례

- **유형**: `유형1·유형2` 병기 — 유형1 = 선택(콤보/팝업 선택형) / 텍스트(입력형) / 버튼 / 체크박스, 유형2 = 단일 / 다중 / 기타.
- **기능**: 검색(검색 가능 콤보) / 팝업(팝업 호출) / 달력(DatePicker) / 공란(기본).
- **팝업**: 코드 = 팝업 패밀리 약어 + 변형번호 (List 시트 실측 1:1 대응 — `팝업 비교` 시트 개수 정합 검증):
  `모1/모2/모3`=Model by DivisionPopup · `아1`=Item by DivisionPopup · `메1`=Material by Division Popup · `오1`=Owner by DivisionPopup · `프1/프2`=Project by Division · `버1/버2`=Version Popup · `버세1`=VersionBySalesPrice Popup · `세1`=Sales Report Popup. 코드 없는 텍스트 = As-Is 팝업명 원문.
- **필수**: As-Is 필수값 여부(`O`). To-Be 필수값 컬럼은 원본 시트 전체 공란(미확정 — To-Do 시트 "필수값(*) 지정" 항목 잔존)이라 본 카탈로그에서 생략.
- **변경**: `O`=As-Is 대비 변경 / `X`=그대로 유지. **변경내용**: 명칭 / 유형 / 팝업 / 공통기능화 검토 / 조회조건 삭제 / 메뉴 Sun-Set 등 (복수는 `/` 병기). `[검토: ...]` = 원본 '추가검토필요' 컬럼.
- **구분**: 원본 Lv4 주석 (탭·대상 구분 등, `-`/공란은 생략).
- **To-Be 열이 전부 공란인 행** = To-Be 에서 조회조건으로 승계하지 않는 행 (메뉴 Sun-Set / 조회조건 삭제 / 버튼·체크박스의 공통기능화 검토 대상 등 — '변경내용' 열로 판정).

### 변경내용 분포 (변경 O 행 기준)

| 변경내용 | 건수 |
|---|---:|
| 공통기능화 검토 | 203 |
| 명칭 | 194 |
| 메뉴 Sun-Set | 48 |
| 명칭/팝업 | 27 |
| 유형 | 18 |
| 조회조건 삭제 | 11 |
| 명칭/유형/팝업 | 10 |
| 명칭/유형 | 5 |
| 팝업 | 2 |
| 유형/팝업 | 1 |
| 용어 | 1 |

## 1. 화면 인덱스

| # | 도메인 | 메뉴 경로 | 화면 | 행수 | 변경 O |
|---:|---|---|---|---:|---:|
| 1 | SCP | Master > Supply Master | Master Validation | 3 | 2 |
| 2 | SCP | Master > Supply Master | Plant Site | 5 | 5 |
| 3 | SCP | Master > Supply Master | Line Master | 6 | 2 |
| 4 | SCP | Master > Supply Master | Project Route | 7 | 4 |
| 5 | SCP | Master > Supply Master | Item Master | 8 | 5 |
| 6 | SCP | Master > Supply Master | Model Code Master | 8 | 7 |
| 7 | SCP | Master > Supply Master | Demand Grouping | 3 | 3 |
| 8 | SCP | Master > Supply Master | BOD | 8 | 3 |
| 9 | SCP | Master > Supply Master | BOD ITEM | 9 | 4 |
| 10 | SCP | Master > Supply Master | Work Calendar(OSP) | 8 | 4 |
| 11 | SCP | Master > Supply Master | Shipment Working Day(OSP) | 6 | 4 |
| 12 | SCP | Master > Supply Master | Formation | 3 | 1 |
| 13 | SCP | Master > Supply Master | Tact Time(OSP) | 5 | 2 |
| 14 | SCP | Master > Supply Master | Characteristic Capacity | 3 | 3 |
| 15 | SCP | Master > Supply Master | Outsourcing Capacity | 4 | 4 |
| 16 | SCP | Master > Supply Master | ProjectRoute (Electrode) | 5 | 3 |
| 17 | SCP | Master > Supply Master | ProjectRoute (Warranty) | 4 | 3 |
| 18 | SCP | Master > Supply Master | Stock OSP | 9 | 4 |
| 19 | SCP | Master > Supply Master | Model Allocation | 6 | 6 |
| 20 | SCP | Master > Supply Master | Operation LT | 5 | 3 |
| 21 | SCP | Master > Supply Master | CAPA | 25 | 18 |
| 22 | SCP | Master > Supply Master | CAPA PIC | 9 | 9 |
| 23 | SCP | Master > Supply Master | SCP BOM (Cell~Pack) | 6 | 5 |
| 24 | SCP | Master > Supply Master | MDM Class Master | 3 | 3 |
| 25 | SCP | Master > Supply Master | SCP BOM(Elec) | 3 | 3 |
| 26 | SCP | Master > Supply Master | CAPA (Mobility IT) | 13 | 8 |
| 27 | SCP | Master > Supply Master | Demand Group Master | 5 | 3 |
| 28 | SCP | Supply > Supply Plan | Plan Management | 3 | 3 |
| 29 | SCP | Supply > Supply Plan | Production Plan | 16 | 8 |
| 30 | SCP | Supply > Supply Plan | Production Plan Line | 24 | 14 |
| 31 | SCP | Supply > Supply Plan | Production Plan Fix | 12 | 5 |
| 32 | SCP | Supply > Supply Plan | Shipment Plan FG | 22 | 13 |
| 33 | SCP | Supply > Supply Plan | Shipment Plan SEMI | 19 | 11 |
| 34 | SCP | Supply > Supply Plan | Shipment Plan Fix | 10 | 6 |
| 35 | SCP | Supply > Supply Plan | Shipment Request SEMI | 7 | 3 |
| 36 | SCP | Supply > Supply Plan | PSI | 12 | 3 |
| 37 | SCP | Supply > Supply Plan | Global PSI | 13 | 6 |
| 38 | SCP | Supply > Supply Plan | PSI Electrode | 12 | 3 |
| 39 | SCP | Supply > Supply Plan | Global PSI(Mobility & IT) | 14 | 5 |
| 40 | SCP | Supply > Supply Plan | Global PSI Elec | 8 | 4 |
| 41 | SCP | Supply > Supply Plan | Global PSI New | 17 | 9 |
| 42 | SCP | Supply > Supply Plan | Integration PSI | 7 | 4 |
| 43 | SCP | Supply > Validation | Intransit Inventory | 7 | 6 |
| 44 | SCP | Supply > Capa Plan | CAPA LineMaster | 2 | 1 |
| 45 | SCP | Supply > Capa Plan | Line Assign | 11 | 6 |
| 46 | SCP | Supply > Capa Plan | Speed Plan | 11 | 5 |
| 47 | SCP | Supply > Capa Plan | Loss Plan | 12 | 6 |
| 48 | SCP | Supply > Capa Plan | LOB Report | 14 | 5 |
| 49 | SCP | Supply > Capa Plan | TEEP Report | 9 | 4 |
| 50 | SCP | Supply > OPT Plan | Constraint Mgmt | 3 | 2 |
| 51 | SCP | Supply > OPT Plan | Plan Control | 3 | 1 |
| 52 | SCP | Supply > OPT Plan | Plan Group Dashboard | 5 | 1 |
| 53 | SCP | Supply > OPT Plan | Plan Group Master | 7 | 2 |
| 54 | SCP | Supply > OPT Plan | Plan Activity Mgmt | 3 | 1 |
| 55 | SCP | Supply > OPT Plan | Workbench | 5 | 3 |
| 56 | SCP | Supply > OPT Plan | OPT CAPA | 11 | 6 |
| 57 | SCP | Supply > OPT Plan | Precede/Safety Stock Day | 8 | 3 |
| 58 | SCP | Supply > OPT Plan | Precede/Safety Stock Qty | 8 | 3 |
| 59 | SCP | Supply > OPT Plan | Demand Exception | 7 | 3 |
| 60 | SCP | Supply > OPT Plan | Scheduled Reciept Information | 8 | 4 |
| 61 | SCP | Supply > OPT Plan | Sales Site Priority | 6 | 3 |
| 62 | SCP | Supply > OPT Plan | Constraint Of Shipment Qty | 9 | 4 |
| 63 | SCP | Supply > OPT Plan | Warehouse Capacity | 8 | 4 |
| 64 | SCP | Report > Waterfall | Production Plan Waterfall | 16 | 9 |
| 65 | SCP | Report > Waterfall | Shipment Plan FG Waterfall | 11 | 7 |
| 66 | SCP | Report > Waterfall | Shipment Plan Semi Waterfall | 9 | 5 |
| 67 | SCP | Report > SCM Supply | Shipment(Allo) Report | 12 | 4 |
| 68 | SCP | Report > SCM Supply | Long-term stock | 4 | 1 |
| 69 | SCP | Report > SCM Supply | Long-term stock MGMT | 12 | 12 |
| 70 | SCP | Report > SCM Supply | Policy-based Inv. Mgmt. | 8 | 8 |
| 71 | SCP | Report > SCM Supply | Inventory Trend | 6 | 4 |
| 72 | SCP | Report > SCM Supply | Ending Inventory | 7 | 2 |
| 73 | SCP | Report > SCM Supply | BOD Validation Report | 14 | 1 |
| 74 | SCP | Report > SCM Supply | Cell Tray Simulation | 5 | 1 |
| 75 | DM | Master > Demand Master | Sales Site | 7 | 2 |
| 76 | DM | Master > Demand Master | Sales Site Project Model | 11 | 6 |
| 77 | DM | Master > Demand Master | Customer Model Mapping | 9 | 5 |
| 78 | DM | Master > Demand Master | Customer FCST Master | 5 | 2 |
| 79 | DM | Master > Demand Master | Sales Price | 16 | 8 |
| 80 | DM | Master > Demand Master | 해외법인 기여율 등록 | 5 | 4 |
| 81 | DM | Master > Demand Master | 해외법인 기여매출 | 8 | 6 |
| 82 | DM | Master > Demand Master | ERP EDI MASTER 정비 | 2 | 2 |
| 83 | DM | Master > Demand Master | N: N Master Mapping | 7 | 3 |
| 84 | DM | Demand > Demand Plan | MKT FCST | 21 | 12 |
| 85 | DM | Demand > Demand Plan | Sales Plan | 17 | 9 |
| 86 | DM | Demand > Demand Plan | Sales Monitoring | 17 | 9 |
| 87 | DM | Demand > Demand Plan | Customer FCST Upload | 11 | 5 |
| 88 | DM | Demand > Demand Plan | Business Plan | 19 | 11 |
| 89 | DM | Demand > Demand Plan | Sales Report | 7 | 4 |
| 90 | DM | Demand > Demand Plan | ETC Sales Report | 6 | 3 |
| 91 | DM | Demand > Demand Plan | MKT FCST (Auto) | 21 | 11 |
| 92 | DM | Demand > Demand Plan | Metal Link Price | 11 | 7 |
| 93 | DM | Demand > Demand Plan | FcstPrice MGMT | 15 | 10 |
| 94 | DM | Report > Waterfall | MKT FCST Waterfall | 20 | 10 |
| 95 | DM | Report > Waterfall | Sales Plan Waterfall | 23 | 14 |
| 96 | DM | Report > Waterfall | Biz Plan Waterfall | 23 | 14 |
| 97 | DM | Report > Waterfall | MKT FCST Comparison | 17 | 9 |
| 98 | DM | Report > Waterfall | Demand Manager | 2 | 1 |
| 99 | DM | Report > Customer Forecast | Customer FCST Waterfall | 17 | 8 |

## 2. 화면별 전수 카탈로그

# ══ SCP ══

## SCP > Master > Supply Master

### Master Validation  (3행 / 변경 2)

| 구분 | As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| 12개 | Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| 12개 | Plan Group | 선택·다중 | 검색 |  |  |  | Plan Group | 선택·단일 | 검색 |  | ALL버튼 | X |  |
| 12개 | Model / Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |

### Plant Site  (5행 / 변경 5)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·다중 | 검색 |  |  | ALL(우) | Div. | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Plant/Vendor | 텍스트·단일 |  |  |  |  | Plant/Vendor | 선택·다중 | 검색 |  | ALL버튼 | O | 유형 |
| Plant Site | 텍스트·단일 |  |  |  |  | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | O | 유형 |
| Outsourcing | 선택·단일 |  |  |  | ALL/Y/N | OSP | 선택·단일 |  |  |  | O | 명칭 |
| Valid | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |

### Line Master  (6행 / 변경 2)

| 구분 | As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Plant, Packer | Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plant, Packer | Plant Site | 선택·다중 | 검색 |  |  | ALL(우) | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Plant | Building | 선택·다중 | 검색 |  |  | ALL(우) | Building | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Plant | Operation | 선택·다중 | 검색 |  |  | ALL(우) | Operation | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Plant, Packer | Line | 선택·다중 | 검색 |  |  | ALL(우) | Line | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Plant, Packer | Valid | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |

### Project Route  (7행 / 변경 4)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Sales Site | 선택·다중 |  |  |  | 비활성화_ALL | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Project | 텍스트·다중 | 팝업 | 프1 |  |  | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭/팝업 |
| Model | 텍스트·다중 | 팝업 | 모1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| Input All | 버튼·기타 | 팝업 | Project Route List For Save |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Period | 선택·단일 | 달력 |  |  | YYYY-MM | Period | 텍스트·단일 | 달력 |  | YYYY-MM | X |  |
| Status | 선택·단일 |  |  |  | ALL/Y/N | Status | 선택·단일 |  |  |  | X |  |

### Item Master  (8행 / 변경 5)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Site | 텍스트·단일 |  |  |  |  | Site | 선택·다중 | 검색 |  | ALL버튼 | O | 유형 |
| SCM Site | 텍스트·단일 |  |  |  |  | SCM Site | 선택·다중 | 검색 |  | ALL버튼 | O | 유형 |
| Class | 텍스트·단일 |  |  |  |  | Class ID | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭/유형 |
| Class1 | 선택·다중 | 검색 |  |  | ALL(우) | Class1 | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Class2 | 선택·다중 | 검색 |  |  | ALL(우) | Class2 | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Material Type | 선택·다중 | 검색 |  |  | ALL(우) | Material Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Material ID/Name | 텍스트·다중 |  |  | O |  | Material | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |

### Model Code Master  (8행 / 변경 7)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation | 선택·다중 | 검색 |  |  | ALL(좌) | Operation | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Model | 텍스트·다중 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| NickName | 텍스트·다중 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 조회조건 삭제 |
| FCST | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Production | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Active | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| BOM | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Demand Grouping  (3행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | - |  |  |  |  | O | 메뉴 Sun-Set |
| Operation group | 선택·단일 |  |  | O |  | - |  |  |  |  | O | 메뉴 Sun-Set |
| Model | 텍스트·다중 | 팝업 | 모1 |  |  | - |  |  |  |  | O | 메뉴 Sun-Set |

### BOD  (8행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·다중 | 검색 |  |  | ALL(좌) | Div. | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| From Site | 선택·다중 | 검색 |  |  | ALL(좌) | From Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| To Site | 선택·다중 | 검색 |  |  | ALL(좌) | To Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Incoterms | 선택·다중 | 검색 |  |  | ALL(좌) | Incoterms | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Trans Mode | 선택·다중 | 검색 |  |  | ALL(좌) | Trans Mode | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Input Status | 선택·단일 |  |  |  | Require/Completed | Status | 선택·단일 |  |  |  | O | 명칭 |
| Valid | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |
| SSP Incoterms | 선택·다중 | 검색 |  |  | ALL(좌) | SSP Incoterms | 선택·다중 | 검색 |  | ALL버튼 | X |  |

### BOD ITEM  (9행 / 변경 4)

| 구분 | As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| 2개 | Div | 선택·다중 | 검색 |  |  | ALL(우) | Div. | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| 2개 | From Site | 선택·다중 | 검색 |  |  | ALL(우) | From Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| 2개 | To Site | 선택·다중 | 검색 |  |  | ALL(우) | To Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| 2개 | Incoterms | 선택·다중 | 검색 |  |  | ALL(우) | Incoterms | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| 2개 | Plan Group | 선택·다중 | 검색 |  |  | ALL(우) | Plan Group | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| 2개 | Trans Mode | 선택·다중 | 검색 |  |  | ALL(우) | Trans Mode | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| 2개 | Model | 텍스트·다중 | 팝업 | 모1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| 2개 | Nick Name | 텍스트·단일 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 조회조건 삭제 |
| 2개 | BOD Item Valid | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |

### Work Calendar(OSP)  (8행 / 변경 4)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plant Site | 선택·다중 | 검색 |  |  | ALL(우) | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Operation | 선택·다중 | 검색 |  |  | ALL(우) | Operation | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Line | 선택·다중 | 검색 |  |  | ALL(우) | Line | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Day of the week | 선택·단일 |  |  |  | 일괄 입력기능_EveryDay/각요일 | - |  |  |  |  | O | 공통기능화 검토 |
| Input Value | 텍스트·단일 |  |  |  | 일괄 입력기능 | - |  |  |  |  | O | 공통기능화 검토 |
| Input | 버튼·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Shipment Working Day(OSP)  (6행 / 변경 4)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plant Site | 선택·다중 | 검색 |  |  | ALL(우) | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Day of the week | 선택·단일 |  |  |  | 일괄 입력기능_EveryDay/각요일 | - |  |  |  |  | O | 공통기능화 검토 |
| Input Value | 선택·단일 |  |  |  | Y/N_일괄 입력기능 | - |  |  |  |  | O | 공통기능화 검토 |
| Input | 버튼·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Formation  (3행 / 변경 1)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plant Site | 선택·다중 |  |  |  | ALL(X) | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Material | 텍스트·다중 | 팝업 | 메1 |  |  | Material | 텍스트·다중 | 팝업 | 메1 |  | X |  |

### Tact Time(OSP)  (5행 / 변경 2)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plant Site | 선택·다중 | 검색 |  |  | ALL(우) | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Operation group | 선택·단일 |  |  | O |  | Operation group | 선택·단일 |  |  |  | X |  |
| Line | 선택·다중 | 검색 |  |  | ALL(우) | Line | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Model | 텍스트·다중 | 팝업 | 모1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |

### Characteristic Capacity  (3행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | - |  |  |  |  | O | 메뉴 Sun-Set |
| Plant Site | 선택·다중 |  |  |  | ALL(X) | - |  |  |  |  | O | 메뉴 Sun-Set |
| Material | 텍스트·다중 | 팝업 | 메1 |  |  | - |  |  |  |  | O | 메뉴 Sun-Set |

### Outsourcing Capacity  (4행 / 변경 4)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | - |  |  |  |  | O | 메뉴 Sun-Set |
| Plant Site | 선택·다중 |  |  |  | ALL(X) | - |  |  |  |  | O | 메뉴 Sun-Set |
| Model | 텍스트·다중 | 팝업 | 모1 |  |  | - |  |  |  |  | O | 메뉴 Sun-Set |
| Nick Name | 텍스트·단일 |  |  |  |  | - |  |  |  |  | O | 메뉴 Sun-Set |

### ProjectRoute (Electrode)  (5행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·다중 | 검색 |  |  | ALL(우) | Div. | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Plant Site | 선택·다중 | 검색 |  |  | ALL(우) | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Operation group | 선택·단일 |  |  |  |  | Operation group | 선택·단일 |  |  |  | X |  |
| Model | 텍스트·단일 | 팝업 | 모1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/유형/팝업 |
| Valid | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |

### ProjectRoute (Warranty)  (4행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·다중 | 검색 |  |  | ALL(우) | Div. | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Plant Site | 선택·다중 | 검색 |  |  | ALL(우) | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Model | 텍스트·단일 | 팝업 | 모1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/유형/팝업 |
| Valid | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |

### Stock OSP  (9행 / 변경 4)

| 구분 | As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| OSP Stock, Pack Hold Stock | Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| OSP Stock, Pack Hold Stock | Plant Site | 선택·다중 | 검색 |  |  | ALL(우) | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| OSP Stock, Pack Hold Stock | Model | 텍스트·다중 | 팝업 | 모1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| OSP Stock, Pack Hold Stock | Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| OSP Stock | Upload | 버튼·기타 | 팝업 | Osp Stock |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| OSP Stock | Excel Form | 버튼·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Pack Hold Stock | 관리번호 | 텍스트·다중 |  |  |  |  | 관리번호 | 텍스트·다중 |  |  |  | X |  |
| Pack Hold Stock | Status | 선택·단일 |  |  |  | ALL/Hold/Release | Status | 선택·단일 |  |  |  | X |  |
| Pack Hold Stock | Cutoff Date | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD | Cutoff Date | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X | [검토: 기존유지 or Period로 변경] |

### Model Allocation  (6행 / 변경 6)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | - |  |  |  |  | O | 메뉴 Sun-Set |
| PKG Site | 선택·다중 | 검색 |  |  | ALL(우) | - |  |  |  |  | O | 메뉴 Sun-Set |
| PKG Line | 선택·다중 | 검색 |  |  | ALL(우) | - |  |  |  |  | O | 메뉴 Sun-Set |
| Material | 텍스트·다중 | 팝업 | 메1 |  |  | - |  |  |  |  | O | 메뉴 Sun-Set |
| Supply Site | 선택·다중 | 검색 |  |  | ALL(우) | - |  |  |  |  | O | 메뉴 Sun-Set |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD(달력형식 다름, 주차X) | - |  |  |  |  | O | 메뉴 Sun-Set |

### Operation LT  (5행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| LT Operation | 선택·단일 |  |  |  |  | Operation | 선택·단일 |  |  |  | O | 명칭 |
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plant Site | 선택·다중 | 검색 |  |  | ALL(우) | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Material | 텍스트·다중 | 팝업 | 메1 |  |  | Material | 텍스트·다중 | 팝업 | 메1 |  | X |  |
| Site Item Valid | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |

### CAPA  (25행 / 변경 18)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Group | 선택·단일 |  |  |  |  | Operation group | 선택·단일 |  |  |  | X |  |
| Plant | 선택·다중 | 검색 |  |  | ALL(좌) | Plant | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Building | 선택·다중 | 검색 |  |  | ALL(좌) | Building | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Version | 선택·단일 |  |  |  |  | Ver. | 선택·단일 |  |  |  | O | 명칭 |
| NoName | 텍스트·기타 |  |  |  | 비활성화_Total/Small/Auto/Elec/PIC | - |  |  |  |  | O | 공통기능화 검토 |
| Line | 선택·다중 | 검색 |  |  | ALL(좌) | Line | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Operation | 선택·다중 | 검색 |  |  | ALL(좌) | Operation | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Model | 텍스트·다중 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| Material | 텍스트·다중 |  |  |  |  | Material | 텍스트·다중 | 팝업 | 메1 |  | O | 팝업 |
| NickName | 텍스트·다중 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 조회조건 삭제 |
| Period | 선택·단일 | 달력 |  |  | YYYY-MM | Period | 텍스트·단일 | 달력 |  | YYYY-MM | X |  |
| Bucket | 선택·다중 |  |  |  |  | Bucket | 선택·단일 | 검색 |  | ALL버튼 | X |  |
| Loss | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Line Assign | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Tact Time | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Yield | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| RESULT | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Empty Value | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| New Version | 버튼·기타 | 팝업 | CAAPA NewVersion Confirm |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| New Model | 버튼·기타 | 팝업 | CAPA New Model |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Version Info | 버튼·기타 | 팝업 | CAPA Version Info |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Upload | 버튼·기타 | 팝업 | CAPA/CAPA_Day |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Excel Form | 버튼·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Mail Request | 버튼·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### CAPA PIC  (9행 / 변경 9)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | - |  |  |  |  | O | 메뉴 Sun-Set |
| Group | 선택·다중 | 검색 |  |  | ALL(좌) | - |  |  |  |  | O | 메뉴 Sun-Set |
| Plant | 선택·다중 | 검색 |  |  | ALL(좌) | - |  |  |  |  | O | 메뉴 Sun-Set |
| Building | 선택·다중 | 검색 |  |  | ALL(좌) | - |  |  |  |  | O | 메뉴 Sun-Set |
| Line | 선택·다중 | 검색 |  |  | ALL(좌) | - |  |  |  |  | O | 메뉴 Sun-Set |
| Operation | 선택·다중 | 검색 |  |  | ALL(좌) | - |  |  |  |  | O | 메뉴 Sun-Set |
| Category | 선택·다중 | 검색 |  |  | ALL(좌) | - |  |  |  |  | O | 메뉴 Sun-Set |
| Key | 선택·다중 | 검색 |  |  | ALL(좌) | - |  |  |  |  | O | 메뉴 Sun-Set |
| Manager | 텍스트·다중 |  |  |  |  | - |  |  |  |  | O | 메뉴 Sun-Set |

### SCP BOM (Cell~Pack)  (6행 / 변경 5)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plant Site | 선택·다중 | 검색 |  |  | ALL(우) | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Model | 텍스트·다중 | 팝업 | 모1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| Parent Item | 텍스트·다중 |  |  |  |  | Parent Item | 선택·다중 | 검색 |  | ALL버튼 | O | 유형 |
| Child Item | 텍스트·다중 |  |  |  |  | Child Item | 선택·다중 | 검색 |  | ALL버튼 | O | 유형 |
| Alter BOM | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### MDM Class Master  (3행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Class ID | 텍스트·단일 |  |  |  |  | Class ID | 선택·다중 | 검색 |  | ALL버튼 | O | 유형 |
| Class Name | 텍스트·단일 |  |  |  |  | Class Name | 선택·다중 | 검색 |  | ALL버튼 | O | 유형 |
| Use Flag | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |

### SCP BOM(Elec)  (3행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Parent Item | 텍스트·다중 |  |  |  |  | Parent Item | 선택·다중 | 검색 |  | ALL버튼 | O | 유형 |
| Child Item | 텍스트·다중 |  |  |  |  | Child Item | 선택·다중 | 검색 |  | ALL버튼 | O | 유형 |

### CAPA (Mobility IT)  (13행 / 변경 8)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O | 비활성화_40 Mobolity & IT Battery | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plant Site | 선택·다중 | 검색 |  |  | ALL(좌) | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Material | 텍스트·단일 | 팝업 | 모1 |  |  | Material | 텍스트·다중 | 팝업 | 메1 |  | O | 유형/팝업 |
| Nick Name | 텍스트·단일 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Line | 선택·다중 | 검색 |  |  | ALL(좌) | Line | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Bucket | 선택·단일 |  |  |  | 비활성화_Daily | Bucket | 선택·단일 |  |  |  | X |  |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Copy Data | 버튼·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Category | 선택·단일 |  |  |  | 비조업/가동율(%)/Ramp-up(0.0~1.0)/Daily Capa(팝업과 동일) | Category | 선택·단일 |  |  |  | X |  |
| Day Type | 선택·단일 |  |  |  |  | - |  |  |  |  | O | 공통기능화 검토 |
| Input Value | 텍스트·단일 |  |  |  | 일괄 입력기능 | - |  |  |  |  | O | 공통기능화 검토 |
| Input | 버튼·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Demand Group Master  (5행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation Group | 선택·단일 |  |  |  |  | Operation group | 선택·단일 |  |  |  | X |  |
| Group Name | 텍스트·단일 |  |  |  |  | Group Name | 텍스트·단일 |  |  |  | X |  |
| Project | 텍스트·다중 | 팝업 | 프1 |  |  | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭/팝업 |
| Model | 텍스트·다중 | 팝업 | 모1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |

## SCP > Supply > Supply Plan

### Plan Management  (3행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | - |  |  |  |  | O | 메뉴 Sun-Set |
| Year | 선택·단일 |  |  | O | 올해 포함 이전 2개년(26년/25년) | - |  |  |  |  | O | 메뉴 Sun-Set |
| Plan Date | 선택·단일 |  |  | O | 당주 포함 이전 3주(W2/W3/W4) | - |  |  |  |  | O | 메뉴 Sun-Set |

### Production Plan  (16행 / 변경 8)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation group | 선택·단일 |  |  | O |  | Operation group | 선택·단일 |  |  |  | X |  |
| Electrode | 선택·다중 |  |  |  | 비활성화_ALL | Electrode | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Bucket | 선택·단일 |  |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| Calculat | 버튼·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Plant Site | 선택·다중 | 검색 |  |  | ALL(우) | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Material | 텍스트·다중 | 팝업 | 메1 |  |  | Material | 텍스트·다중 | 팝업 | 메1 |  | X |  |
| Model | 텍스트·단일 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/유형/팝업 |
| Nick Name | 텍스트·단일 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 조회조건 삭제 |
| AL | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Sum | 체크박스·기타 |  |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | O | 공통기능화 검토 |
| Plan date | 선택·단일 |  |  | O |  | Plan Date | 선택·단일 |  |  |  | X |  |
| Plan type | 선택·단일 |  |  | O |  | Plan Type | 선택·단일 |  |  |  | X |  |
| Seq | 선택·단일 |  |  | O |  | Seq. | 선택·단일 |  |  |  | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |

### Production Plan Line  (24행 / 변경 14)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation group | 선택·단일 |  |  | O |  | Operation group | 선택·단일 |  |  |  | X |  |
| Cell Type Gr | 선택·다중 |  |  |  | 비활성화_ALL | Cell Type Gr | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Electrode | 선택·다중 |  |  |  | 비활성화_ALL | Electrode | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Extra Spec | 선택·다중 |  |  |  | 비활성화_ALL | Extra Spec | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| W26 | 버튼·기타 |  |  |  | Period 조회조건 변경 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| W52 | 버튼·기타 |  |  |  | Period 조회조건 변경 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| New | 버튼·기타 | 팝업 | Production Plan Insert |  | 화면 편집 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Fix | 버튼·기타 |  |  |  | 화면 편집 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Unfix | 버튼·기타 |  |  |  | 화면 편집 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Plant Site | 선택·다중 | 검색 |  |  | ALL(좌) | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Line | 선택·다중 | 검색 |  |  | ALL(좌) | Line | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Model | 텍스트·단일 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/유형/팝업 |
| Material | 텍스트·단일 | 팝업 | 메1 |  |  | Material | 텍스트·다중 | 팝업 | 메1 |  | O | 유형 |
| Nick Name | 텍스트·단일 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 조회조건 삭제 |
| ALL | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Line Assign | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Plan date | 선택·단일 |  |  | O |  | Plan Date | 선택·단일 |  |  |  | X |  |
| Plan type | 선택·단일 |  |  | O |  | Plan Type | 선택·단일 |  |  |  | X |  |
| Seq | 선택·단일 |  |  | O |  | Seq. | 선택·단일 |  |  |  | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Bucket | 선택·단일 |  |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Sum | 체크박스·기타 |  |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | O | 공통기능화 검토 |

### Production Plan Fix  (12행 / 변경 5)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation group | 선택·단일 |  |  | O |  | Operation group | 선택·단일 |  |  |  | X |  |
| Material | 텍스트·다중 | 팝업 | 메1 |  |  | Material | 텍스트·다중 | 팝업 | 메1 |  | X |  |
| Electrode | 선택·다중 |  |  |  | 비활성화_ALL | Electrode | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| W26 | 버튼·기타 |  |  |  | Period 조회조건 변경 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| W52 | 버튼·기타 |  |  |  | Period 조회조건 변경 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Unfix | 버튼·기타 |  |  |  | 화면 편집 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Plant Site | 선택·다중 | 검색 |  |  | ALL(우) | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Line | 선택·다중 | 검색 |  |  | ALL(우) | Line | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Bucket | 선택·단일 |  |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Sum | 체크박스·기타 |  |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | O | 공통기능화 검토 |

### Shipment Plan FG  (22행 / 변경 13)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation group | 선택·단일 |  |  | O |  | Operation group | 선택·단일 |  |  |  | X |  |
| From Site | 선택·다중 | 검색 |  |  | ALL(좌) | From Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| To Site | 선택·다중 | 검색 |  |  | ALL(좌) | To Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| New | 버튼·기타 | 팝업 | Shipment Plan Insert |  | 화면 편집 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Fix | 버튼·기타 |  |  |  | 화면 편집 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Unfix | 버튼·기타 |  |  |  | 화면 편집 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Project | 텍스트·다중 | 팝업 | 프1 |  |  | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭/팝업 |
| Model | 텍스트·다중 | 팝업 | 모1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| Electrode | 선택·다중 |  |  |  | 비활성화_ALL | Electrode | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Bucket | 선택·단일 |  |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| ALL | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Plan date | 선택·단일 |  |  | O |  | Plan Date | 선택·단일 |  |  |  | X |  |
| Plan type | 선택·단일 |  |  | O |  | Plan Type | 선택·단일 |  |  |  | X |  |
| Seq | 선택·단일 |  |  | O |  | Seq. | 선택·단일 |  |  |  | O | 명칭 |
| W26 | 버튼·기타 |  |  |  | Period 조회조건 변경 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| W52 | 버튼·기타 |  |  |  | Period 조회조건 변경 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Sum | 체크박스·기타 |  |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | O | 공통기능화 검토 |

### Shipment Plan SEMI  (19행 / 변경 11)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation group | 선택·단일 |  |  | O |  | Operation group | 선택·단일 |  |  |  | X |  |
| From Site | 선택·다중 |  |  |  |  | From Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| To Site | 선택·다중 | 검색 |  |  | ALL(우) | To Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| New | 버튼·기타 | 팝업 | Shipment Plan Insert |  | 화면 편집 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Fix | 버튼·기타 |  |  |  | 화면 편집 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Unfix | 버튼·기타 |  |  |  | 화면 편집 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Model | 텍스트·다중 | 팝업 | 모1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| Electrode | 선택·다중 |  |  |  | 비활성화_ALL | Electrode | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Bucket | 선택·단일 |  |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| ALL | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| W26 | 버튼·기타 |  |  |  | Period 조회조건 변경 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| W52 | 버튼·기타 |  |  |  | Period 조회조건 변경 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Plan date | 선택·단일 |  |  | O |  | Plan Date | 선택·단일 |  |  |  | X |  |
| Plan type | 선택·단일 |  |  | O |  | Plan Type | 선택·단일 |  |  |  | X |  |
| Seq | 선택·단일 |  |  | O |  | Seq. | 선택·단일 |  |  |  | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Sum | 체크박스·기타 |  |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | O | 공통기능화 검토 |

### Shipment Plan Fix  (10행 / 변경 6)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation group | 선택·단일 |  |  | O |  | Operation group | 선택·단일 |  |  |  | X |  |
| Model | 텍스트·다중 | 팝업 | 모1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| Electrode | 선택·다중 |  |  |  | 비활성화_ALL | Electrode | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| W26 | 버튼·기타 |  |  |  | Period 조회조건 변경 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| W52 | 버튼·기타 |  |  |  | Period 조회조건 변경 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Unfix | 버튼·기타 |  |  |  | 화면 편집 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Bucket | 선택·단일 |  |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Sum | 체크박스·기타 |  |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | O | 공통기능화 검토 |

### Shipment Request SEMI  (7행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation group | 선택·단일 |  |  | O |  | Operation group | 선택·단일 |  |  |  | X |  |
| Model | 텍스트·다중 | 팝업 | 모1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| From Site | 선택·다중 |  |  |  |  | From Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Bucket | 선택·단일 |  |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| Period | 텍스트·단일 | 달력 |  | O | 비활성화_YYYY-MM-DD(달력형식 다름, 주차X) | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Sum | 체크박스·기타 |  |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | O | 공통기능화 검토 |

### PSI  (12행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation Group | 선택·단일 |  |  |  |  | Operation group | 선택·단일 |  |  |  | X |  |
| From Site | 선택·다중 | 검색 |  |  | ALL(우) | From Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Material | 텍스트·다중 | 팝업 | 메1 |  |  | Material | 텍스트·다중 | 팝업 | 메1 |  | X |  |
| Cell Type Gr | 선택·다중 |  |  |  | 비활성화_ALL | Cell Type Gr | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Electrode | 선택·다중 |  |  |  | 비활성화_ALL | Electrode | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Plan date | 선택·단일 |  |  | O |  | Plan Date | 선택·단일 |  |  |  | X |  |
| Plan type | 선택·단일 |  |  | O |  | Plan Type | 선택·단일 |  |  |  | X |  |
| Seq | 선택·단일 |  |  | O |  | Seq. | 선택·단일 |  |  |  | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Bucket | 선택·단일 |  |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| Sum | 체크박스·기타 |  |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | O | 공통기능화 검토 |

### Global PSI  (13행 / 변경 6)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Material | 텍스트·다중 | 팝업 | 메1 |  |  | Material | 텍스트·다중 | 팝업 | 메1 |  | X |  |
| Nick Name | 텍스트·단일 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/유형/팝업 |
| From Site | 선택·다중 | 검색 |  |  | ALL(좌) | From Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| To Site | 선택·다중 | 검색 |  |  | ALL(좌) | To Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Plan date | 선택·단일 |  |  | O |  | Plan Date | 선택·단일 |  |  |  | X |  |
| Plan type | 선택·단일 |  |  | O |  | Plan Type | 선택·단일 |  |  |  | X |  |
| Seq | 선택·단일 |  |  | O |  | Seq. | 선택·단일 |  |  |  | O | 명칭 |
| Bucket | 선택·단일 |  |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| ALL | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Sum | 체크박스·기타 |  |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | O | 공통기능화 검토 |

### PSI Electrode  (12행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O | 비활성화_EE Electrode | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation Group | 선택·단일 |  |  |  | 비활성화_Electrode | Operation group | 선택·단일 |  |  |  | X |  |
| From Site | 선택·다중 | 검색 |  |  | ALL(우) | From Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Material | 텍스트·다중 | 팝업 | 메1 |  |  | Material | 텍스트·다중 | 팝업 | 메1 |  | X |  |
| Electrode | 선택·다중 |  |  |  |  | Electrode | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Unit | 선택·다중 |  |  |  |  | Unit | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Plan date | 선택·단일 |  |  | O |  | Plan Date | 선택·단일 |  |  |  | X |  |
| Plan type | 선택·단일 |  |  | O |  | Plan Type | 선택·단일 |  |  |  | X |  |
| Seq | 선택·단일 |  |  | O |  | Seq. | 선택·단일 |  |  |  | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Bucket | 선택·단일 |  |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| Sum | 체크박스·기타 |  |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | O | 공통기능화 검토 |

### Global PSI(Mobility & IT)  (14행 / 변경 5)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O | 비활성화_40 Mobility & Battery | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation Group | 선택·다중 |  |  |  |  | Operation group | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Cell Type | 선택·다중 |  |  |  |  | Cell Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Material | 텍스트·다중 | 팝업 | 메1 |  |  | Material | 텍스트·다중 | 팝업 | 메1 |  | X |  |
| Nick Name | 텍스트·단일 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/유형/팝업 |
| From Site | 선택·다중 | 검색 |  |  | ALL(우) | From Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| To Site | 선택·다중 | 검색 |  |  | ALL(우) | To Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Plan date | 선택·단일 |  |  | O |  | Plan Date | 선택·단일 |  |  |  | X |  |
| Plan type | 선택·단일 |  |  | O |  | Plan Type | 선택·단일 |  |  |  | X |  |
| Seq | 선택·단일 |  |  | O |  | Seq. | 선택·단일 |  |  |  | O | 명칭 |
| Bucket | 선택·단일 |  |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Sum | 체크박스·기타 |  |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | O | 공통기능화 검토 |

### Global PSI Elec  (8행 / 변경 4)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Company | 선택·다중 | 검색 |  |  | ALL(우) | Company | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Elec Material | 텍스트·다중 | 팝업 | 모2 |  |  | Meterial | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| Plan date | 선택·단일 |  |  | O |  | Plan Date | 선택·단일 |  |  |  | X |  |
| Report type | 선택·단일 |  |  | O | 타메뉴는 Plan Type(용어 다름) *밑에 설명 달려있음 | Plan Type | 선택·단일 |  |  |  | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Bucket | 선택·단일 |  |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |

### Global PSI New  (17행 / 변경 9)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·다중 | 검색 |  | O | ALL(좌) | Div. | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| From Site | 선택·다중 | 검색 |  |  | ALL(좌) | From Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Cell Group | 텍스트·단일 |  |  |  |  | Cell Group | 텍스트·단일 |  |  |  | X |  |
| NoName | 선택·단일 |  |  |  | 형식 다름_Search Level/Detail | Search Level | 선택·단일 |  |  |  | O | 조회조건 삭제 |
| Project | 텍스트·단일 | 팝업 | 프1 |  |  | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭/유형/팝업 |
| Bucket | 선택·단일 |  |  |  | 조회화면 변경 기능_Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| Period | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Plan date | 선택·단일 |  |  | O |  | Plan Date | 선택·단일 |  |  |  | X |  |
| To Site | 선택·다중 | 검색 |  |  | ALL(좌) | To Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Cell Qty | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| A/S | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Search Level | 선택·단일 |  |  |  | 상단 NoName(Search Level/Detail)과 연동(활성화/비활성화) | Search Level | 선택·단일 |  |  |  | X |  |
| Model / Nick Name | 텍스트·단일 | 팝업 | 모1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/유형/팝업 |
| Plan type | 선택·단일 |  |  |  | 비활성화_Final Plan | Plan Type | 선택·단일 |  |  |  | X |  |
| Unit (Qty) | 선택·단일 |  |  |  | 숫자 단위 조정 | Unit | 선택·단일 |  |  |  | O | 명칭 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |

### Integration PSI  (7행 / 변경 4)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Nick Name | 텍스트·다중 | 팝업 | 모1 |  | Model과 같은 팝업 | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 조회조건 삭제 |
| Cell Model | 텍스트·다중 |  |  |  |  | Cell Model | 텍스트·다중 | 팝업 |  |  | X |  |
| Model | 텍스트·다중 | 팝업 | 모1 |  | Nick Name과 같은 팝업 | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| Plan date | 선택·단일 |  |  | O |  | Plan Date | 선택·단일 |  |  |  | X |  |
| Period | 선택·단일 | 달력 |  |  | YYYY-MM | Period | 텍스트·단일 | 달력 |  | YYYY-MM | X |  |
| Qty ＜ 0 | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

## SCP > Supply > Validation

### Intransit Inventory  (7행 / 변경 6)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plant Site | 텍스트·단일 |  |  |  |  | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | O | 유형 |
| Sales Site | 텍스트·단일 |  |  |  |  | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | O | 유형 |
| Project | 텍스트·다중 | 팝업 | 프1 |  |  | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭/팝업 |
| Model | 텍스트·다중 | 팝업 | 모1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| Period | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Result Type | 선택·단일 |  |  |  |  | Type | 선택·단일 |  |  |  | O | 명칭 |

## SCP > Supply > Capa Plan

### CAPA LineMaster  (2행 / 변경 1)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Product Group_하단 | 선택·단일 |  |  |  | 형식 다름_Electrode/Cell/Module.Pack | Operation group | 선택·단일 |  |  |  | X |  |

### Line Assign  (11행 / 변경 6)

| 구분 | As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| 2개 | NoName | 선택·단일 |  |  |  | 형식 다름_Electrode/Cell/Module.Pack | Operation group | 선택·단일 |  |  |  | O | 명칭 |
| 2개 | Model | 텍스트·단일 | 팝업 | 아1 |  |  | Material | 텍스트·다중 | 팝업 | 아1 |  | O | 명칭/유형 |
| 2개 | Valid | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |
| 2개 | NoName_이미지2 | 버튼·기타 | 팝업 | User Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| 2개 | Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| 2개 | Plan Month | 선택·단일 |  |  |  |  | Plan Month | 선택·단일 |  |  |  | X |  |
| 2개 | Version | 선택·단일 |  |  |  |  | Ver. | 선택·단일 |  |  |  | O | 명칭 |
| 2개 | Site | 선택·다중 | 검색 |  |  | ALL(우) | Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| 2개 | Plant | 선택·다중 | 검색 |  |  | ALL(우) | Plant | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| 2개 | Building | 선택·다중 | 검색 |  |  | ALL(우) | Building | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| 2개 | Line | 선택·다중 | 검색 |  |  | ALL(우) | Line | 선택·다중 | 검색 |  | ALL버튼 | X |  |

### Speed Plan  (11행 / 변경 5)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| NoName | 선택·단일 |  |  |  | 형식 다름_Electrode/Cell/Module.Pack | Operation group | 선택·단일 |  |  |  | O | 명칭 |
| Model | 텍스트·단일 | 팝업 | 아1 |  |  | Material | 텍스트·다중 | 팝업 | 아1 |  | O | 명칭/유형 |
| NoName_이미지2 | 버튼·기타 | 팝업 | User Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plan Month | 선택·단일 |  |  |  |  | Plan Month | 선택·단일 |  |  |  | X |  |
| Version | 선택·단일 |  |  |  |  | Ver. | 선택·단일 |  |  |  | O | 명칭 |
| Status | 선택·단일 |  |  |  |  | Status | 선택·단일 |  |  |  | X |  |
| Site | 선택·다중 | 검색 |  |  | ALL(우) | Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Plant | 선택·다중 | 검색 |  |  | ALL(우) | Plant | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Building | 선택·다중 | 검색 |  |  | ALL(우) | Building | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Line | 선택·다중 | 검색 |  |  | ALL(우) | Line | 선택·다중 | 검색 |  | ALL버튼 | X |  |

### Loss Plan  (12행 / 변경 6)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| NoName | 선택·단일 |  |  |  | 형식 다름_Electrode/Cell/Module.Pack | Operation group | 선택·단일 |  |  |  | O | 명칭 |
| Model | 텍스트·단일 | 팝업 | 아1 |  |  | Material | 텍스트·다중 | 팝업 | 아1 |  | O | 명칭/유형 |
| Show Rate Columns | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지2 | 버튼·기타 | 팝업 | User Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plan Month | 선택·단일 |  |  |  |  | Plan Month | 선택·단일 |  |  |  | X |  |
| Version | 선택·단일 |  |  |  |  | Ver. | 선택·단일 |  |  |  | O | 명칭 |
| Status | 선택·단일 |  |  |  |  | Status | 선택·단일 |  |  |  | X |  |
| Site | 선택·다중 | 검색 |  |  | ALL(우) | Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Plant | 선택·다중 | 검색 |  |  | ALL(우) | Plant | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Building | 선택·다중 | 검색 |  |  | ALL(우) | Building | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Line | 선택·다중 | 검색 |  |  | ALL(우) | Line | 선택·다중 | 검색 |  | ALL버튼 | X |  |

### LOB Report  (14행 / 변경 5)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| NoName | 선택·단일 |  |  |  | 형식 다름_Electrode/Cell/Module.Pack | Operation group | 선택·단일 |  |  |  | O | 명칭 |
| Basic Nickname | 텍스트·단일 | 팝업 | 아1 |  |  | Basic Nickname | 텍스트·다중 | 팝업 | 아1 |  | O | 유형 |
| Bottleneck | 선택·단일 |  |  |  | ALL/Y/N | Bottleneck | 선택·단일 |  |  |  | X |  |
| NoName_이미지2 | 버튼·기타 | 팝업 | User Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plan Month | 선택·단일 |  |  |  |  | Plan Month | 선택·단일 |  |  |  | X |  |
| Version | 선택·단일 |  |  |  |  | Ver. | 선택·단일 |  |  |  | O | 명칭 |
| Status | 선택·단일 |  |  |  | 비활성화_Current | Status | 선택·단일 |  |  |  | X |  |
| Site | 선택·다중 | 검색 |  |  | ALL(우) | Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Plant | 선택·다중 | 검색 |  |  | ALL(우) | Plant | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Building | 선택·다중 | 검색 |  |  | ALL(우) | Building | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Line | 선택·다중 | 검색 |  |  | ALL(우) | Line | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Operation | 선택·다중 | 검색 |  |  | ALL(우) | Operation | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Line Type | 선택·다중 | 검색 |  |  | ALL(우) | Line Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |

### TEEP Report  (9행 / 변경 4)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| NoName | 선택·단일 |  |  |  | 형식 다름_Electrode/Cell/Module.Pack | Operation group | 선택·단일 |  |  |  | O | 명칭 |
| NoName_이미지2 | 버튼·기타 | 팝업 | User Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Div | 선택·다중 | 검색 |  |  | ALL(우) | Div. | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Plan Month | 선택·단일 |  |  |  |  | Plan Month | 선택·단일 |  |  |  | X |  |
| Version | 선택·단일 |  |  |  |  | Ver. | 선택·단일 |  |  |  | O | 명칭 |
| Site | 선택·다중 | 검색 |  |  | ALL(우) | Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Plant | 선택·다중 | 검색 |  |  | ALL(우) | Plant | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Building | 선택·다중 | 검색 |  |  | ALL(우) | Building | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Line | 선택·다중 | 검색 |  |  | ALL(우) | Line | 선택·다중 | 검색 |  | ALL버튼 | X |  |

## SCP > Supply > OPT Plan

### Constraint Mgmt  (3행 / 변경 2)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Lookup Type | 텍스트·단일 |  |  |  |  | Lookup Type | 선택·다중 | 검색 |  | ALL버튼 | O | 유형 |
| Plan Group | 선택·다중 | 검색 |  |  | ALL(좌) | Plan Group | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Valid | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |

### Plan Control  (3행 / 변경 1)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plan Group | 선택·단일 |  |  |  |  | Plan Group | 선택·단일 |  |  |  | X |  |
| Plan Date | 선택·단일 |  |  |  |  | Plan Date | 선택·단일 |  |  |  | X |  |

### Plan Group Dashboard  (5행 / 변경 1)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plan Group | 선택·단일 |  |  |  |  | Plan Group | 선택·단일 |  |  |  | X |  |
| Plant | 선택·다중 | 검색 |  |  | ALL(좌) | Plant | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Completed | 선택·단일 |  |  |  | ALL/Y/N | Completed | 선택·단일 |  |  |  | X |  |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |

### Plan Group Master  (7행 / 변경 2)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation Group | 선택·다중 | 검색 |  |  | ALL(좌) | Operation group | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Plant | 선택·다중 | 검색 |  |  | ALL(좌) | Plant | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Building | 선택·다중 | 검색 |  |  | ALL(좌) | Building | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Line | 선택·다중 | 검색 |  |  | ALL(좌) | Line | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Plan Group | 선택·다중 | 검색 |  |  | ALL(좌) | Plan Group | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Plan Group Reg. | 버튼·기타 | 팝업 | Plan Group Info |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Plan Activity Mgmt  (3행 / 변경 1)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plan Group | 선택·단일 |  |  |  |  | Plan Group | 선택·단일 |  |  |  | X |  |
| Process | 선택·단일 |  |  |  |  | Process | 선택·단일 |  |  |  | X |  |

### Workbench  (5행 / 변경 3)

| 구분 | As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| 전체 5개 | Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| 전체 5개 | Plan Date | 선택·단일 |  |  |  |  | Plan Date | 선택·단일 |  |  |  | X |  |
| MKT FCST | MKT FCST Ver. | 선택·단일 |  |  |  |  | MKT FCST Ver. | 선택·단일 |  |  |  | X |  |
| 전체 5개 | Nick Name | 텍스트·단일 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 조회조건 삭제 |
| 전체 5개 | Model | 텍스트·단일 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/유형/팝업 |

### OPT CAPA  (11행 / 변경 6)

| 구분 | As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| 전체 5개 | Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| 전체 5개 | Plan Date | 선택·단일 |  |  |  |  | Plan Date | 선택·단일 |  |  |  | X |  |
| 전체 5개 | Period | 텍스트·단일 | 달력 |  |  | YYYY-MM | Period | 텍스트·단일 | 달력 |  | YYYY-MM | X |  |
| No Work | Bucket | 선택·단일 |  |  |  |  | Bucket | 선택·단일 |  |  |  | X |  |
| 전체 5개 | Plant | 선택·다중 | 검색 |  |  | ALL(좌) | Plant | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| 전체 5개 | Line | 선택·다중 | 검색 |  |  | ALL(좌) | Line | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| 전체 5개 | Nick Name | 텍스트·단일 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 조회조건 삭제 |
| 전체 5개 | Model | 텍스트·단일 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/유형/팝업 |
| 전체 5개 | Excel upload | 버튼·기타 | 팝업 | No Work |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| No Work | Excel Form | 버튼·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| No Work | Batch Save | 버튼·기타 | 팝업 | No Work Batch Save Popup |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Precede/Safety Stock Day  (8행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| SCM Site | 선택·다중 | 검색 |  |  | ALL(우) | SCM Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Type | 선택·단일 |  |  |  | ALL/MIN/MAX | Type | 선택·단일 |  |  |  | X |  |
| Stage | 선택·단일 |  |  |  |  | Stage | 선택·단일 |  |  |  | X |  |
| Plan Group | 선택·다중 | 검색 |  |  | ALL(우) | Plan Group | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Model | 텍스트·다중 | 팝업 | 메1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Valid | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |

### Precede/Safety Stock Qty  (8행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| SCM Site | 선택·다중 | 검색 |  |  | ALL(우) | SCM Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Type | 선택·단일 |  |  |  | ALL/MIN/MAX | Type | 선택·단일 |  |  |  | X |  |
| Stage | 선택·단일 |  |  |  |  | Stage | 선택·단일 |  |  |  | X |  |
| Plan Group | 선택·다중 | 검색 |  |  | ALL(우) | Plan Group | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Model | 텍스트·다중 | 팝업 | 메1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Valid | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |

### Demand Exception  (7행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| SCM Site | 선택·다중 | 검색 |  |  | ALL(우) | SCM Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Stage | 선택·단일 |  |  |  |  | Stage | 선택·단일 |  |  |  | X |  |
| Valid | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |
| Plan Group | 선택·다중 | 검색 |  |  | ALL(우) | Plan Group | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Model | 텍스트·다중 | 팝업 | 메1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |

### Scheduled Reciept Information  (8행 / 변경 4)

| 구분 | As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Virtual BOM, Scheduled Reciept Information | Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Virtual BOM, Scheduled Reciept Information | Plant Site | 선택·다중 | 검색 |  |  | ALL(우) | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Virtual BOM, Scheduled Reciept Information | Valid | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |
| Virtual BOM | Parent Model | 텍스트·다중 | 팝업 | 메1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭 |
| Virtual BOM, Scheduled Reciept Information | Plan Group | 선택·다중 | 검색 |  |  | ALL(우) | Plan Group | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Virtual BOM | Child Material | 선택·다중 |  |  |  |  | Material | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Virtual BOM, Scheduled Reciept Information | From Date | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD(달력형식 다름, 주차X) | From Date | 텍스트·단일 | 달력 |  |  | X | [검토: 기존유지 or Period로 변경] |
| Scheduled Reciept Information | Material | 선택·다중 |  |  |  |  | Material | 선택·다중 | 검색 |  | ALL버튼 | X |  |

### Sales Site Priority  (6행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plan Group | 선택·다중 | 검색 |  |  | ALL(우) | Plan Group | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| SCM Site | 선택·다중 | 검색 |  |  | ALL(우) | SCM Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Model | 텍스트·다중 | 팝업 | 메1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Valid | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |

### Constraint Of Shipment Qty  (9행 / 변경 4)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plan Group | 선택·다중 | 검색 |  |  | ALL(우) | Plan Group | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Model | 텍스트·다중 | 팝업 | 메1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭 |
| Stage | 선택·다중 |  |  |  |  | Stage | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Model Group | 선택·다중 |  |  |  |  | Item Group | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| From Site | 선택·다중 | 검색 |  |  | ALL(우) | From Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| To Site | 선택·다중 | 검색 |  |  | ALL(우) | To Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Valid | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |

### Warehouse Capacity  (8행 / 변경 4)

| 구분 | As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Warehouse Capacity, Warehouse Item Mapping | Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Warehouse Capacity, Warehouse Item Mapping | SCM Site | 선택·다중 | 검색 |  |  | ALL(우) | SCM Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Warehouse Capacity, Warehouse Item Mapping | Stage | 선택·단일 |  |  |  |  | Stage | 선택·단일 |  |  |  | X |  |
| Warehouse Capacity, Warehouse Item Mapping | Valid | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | O | 명칭 |
| Warehouse Capacity, Warehouse Item Mapping | Plan Group | 선택·다중 | 검색 |  |  | ALL(우) | Plan Group | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Warehouse Capacity | Name | 선택·다중 |  |  |  |  | WH Name | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Warehouse Capacity | Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Warehouse Item Mapping | Model | 텍스트·다중 | 팝업 | 메1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭 |

## SCP > Report > Waterfall

### Production Plan Waterfall  (16행 / 변경 9)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation group | 선택·단일 |  |  | O |  | Operation group | 선택·단일 |  |  |  | X |  |
| Plant Site | 선택·다중 | 검색 |  |  | ALL(우) | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Electrode | 선택·다중 |  |  |  | 비활성화_ALL | Electrode | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Model | 텍스트·다중 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| Material | 텍스트·다중 | 팝업 | 메1 |  |  | Material | 텍스트·다중 | 팝업 | 메1 |  | X |  |
| Version | 선택·다중 | 검색 |  | O | ALL(우) | Ver. | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Bucket | 선택·단일 |  |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly/Only Weekly | Bucket | 선택·단일 |  |  |  | X |  |
| Line | 선택·다중 | 검색 |  |  | ALL(우) | Line | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Nick Name | 텍스트·단일 |  |  |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 조회조건 삭제 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Sum | 체크박스·기타 |  |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | O | 공통기능화 검토 |
| ALL | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Gap | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Shipment Plan FG Waterfall  (11행 / 변경 7)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation group | 선택·단일 |  |  | O |  | Operation group | 선택·단일 |  |  |  | X |  |
| Project | 텍스트·다중 | 팝업 | 프1 |  |  | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭/팝업 |
| Model | 텍스트·다중 | 팝업 | 모1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| Electrode | 선택·다중 |  |  |  | 비활성화_ALL | Electrode | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Version | 선택·다중 | 검색 |  | O | ALL(우) | Ver. | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Bucket | 선택·단일 |  |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly/Only Weekly | Bucket | 선택·단일 |  |  |  | X |  |
| Period | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Sum | 체크박스·기타 |  |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | O | 공통기능화 검토 |

### Shipment Plan Semi Waterfall  (9행 / 변경 5)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation group | 선택·단일 |  |  | O |  | Operation group | 선택·단일 |  |  |  | X |  |
| Model | 텍스트·다중 | 팝업 | 모1 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| Electrode | 선택·다중 |  |  |  | 비활성화_ALL | Electrode | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Version | 선택·다중 | 검색 |  | O | ALL(우) | Ver. | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Bucket | 선택·단일 |  |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly/Only Weekly | Bucket | 선택·단일 |  |  |  | X |  |
| Period | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Sum | 체크박스·기타 |  |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | O | 공통기능화 검토 |

## SCP > Report > SCM Supply

### Shipment(Allo) Report  (12행 / 변경 4)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O | 비활성화_40 Mobility & IT Battery | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Operation Group | 선택·단일 |  |  | O | 비활성화_Cell | Operation group | 선택·단일 |  |  |  | X |  |
| From Site | 선택·다중 | 검색 |  |  | ALL(좌) | From Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Team | 선택·다중 | 검색 |  |  | ALL(좌) | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Bucket | 선택·단일 |  |  |  | 비활성화_Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| Gap Date | 선택·단일 |  |  | O |  | Gap Date | 선택·단일 |  |  |  | X |  |
| Model | 텍스트·다중 | 팝업 | 모1 |  | Nick Name과 같은 팝업 | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 명칭/팝업 |
| Nick Name | 텍스트·다중 | 팝업 | 모1 |  | Model과 같은 팝업 | Model/Nickname | 텍스트·다중 | 팝업 | 메1 |  | O | 조회조건 삭제 |
| Cell Type Gr | 선택·다중 |  |  |  | 비활성화_Cyl | Cell Type Gr | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM | Period | 텍스트·단일 | 달력 |  | YYYY-MM | X |  |
| Plan Date | 선택·단일 |  |  | O |  | Plan Date | 선택·단일 |  |  |  | X |  |
| FCST Pegging | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Long-term stock  (4행 / 변경 1)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Month | 텍스트·단일 | 달력 |  |  | YYYY-MM | Month | 텍스트·단일 | 달력 |  | YYYY-MM | X | [검토: 기존유지 or Period로 변경] |
| Div | 선택·다중 | 검색 |  |  | ALL(좌) | Div. | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Plant | 선택·다중 | 검색 |  |  | ALL(좌) | Plant | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Long Term Type | 선택·다중 | 검색 |  |  | ALL(좌) | Long Term Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |

### Long-term stock MGMT  (12행 / 변경 12)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Plan Date | 선택·단일 |  |  | O |  | - |  |  |  |  | O | 메뉴 Sun-Set |
| Div | 선택·다중 | 검색 |  |  | ALL(좌) | - |  |  |  |  | O | 메뉴 Sun-Set |
| Plant | 선택·다중 | 검색 |  |  | ALL(좌) | - |  |  |  |  | O | 메뉴 Sun-Set |
| 발생유형 | 선택·단일 |  |  |  |  | - |  |  |  |  | O | 메뉴 Sun-Set |
| Group Code | 텍스트·다중 |  |  |  |  | - |  |  |  |  | O | 메뉴 Sun-Set |
| Item Type | 선택·다중 | 검색 |  |  | ALL(좌) | - |  |  |  |  | O | 메뉴 Sun-Set |
| Material | 텍스트·다중 |  |  |  |  | - |  |  |  |  | O | 메뉴 Sun-Set |
| EOH Month | 텍스트·단일 | 달력 |  |  | YYYY-MM | - |  |  |  |  | O | 메뉴 Sun-Set |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 메뉴 Sun-Set |
| Upload | 버튼·기타 | 팝업 | Long Term Stock Management |  |  |  |  |  |  |  | O | 메뉴 Sun-Set |
| PSI Export | 버튼·기타 | 팝업 | LongTermStockMgmtViewPopup |  |  |  |  |  |  |  | O | 메뉴 Sun-Set |
| Process LongTerm | 버튼·기타 | 팝업 | LongTermProcessPopup |  |  |  |  |  |  |  | O | 메뉴 Sun-Set |

### Policy-based Inv. Mgmt.  (8행 / 변경 8)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Plan Date | 선택·단일 |  |  | O |  | - |  |  |  |  | O | 메뉴 Sun-Set |
| Div | 선택·다중 | 검색 |  |  | ALL(좌) | - |  |  |  |  | O | 메뉴 Sun-Set |
| Plant | 선택·다중 | 검색 |  |  | ALL(좌) | - |  |  |  |  | O | 메뉴 Sun-Set |
| Category | 선택·단일 |  |  |  | ALL/입고계획/소진계획 | - |  |  |  |  | O | 메뉴 Sun-Set |
| Material | 텍스트·다중 |  |  |  |  | - |  |  |  |  | O | 메뉴 Sun-Set |
| Period | 텍스트·단일 |  |  | O | 날짜키인(달력X) | - |  |  |  |  | O | 메뉴 Sun-Set |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 메뉴 Sun-Set |
| Upload | 버튼·기타 | 팝업 | Policy Inv Management |  |  |  |  |  |  |  | O | 메뉴 Sun-Set |

### Inventory Trend  (6행 / 변경 4)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Month | 텍스트·단일 | 달력 |  |  | YYYY-MM | Month | 텍스트·단일 | 달력 |  | YYYY-MM | X | [검토: 기존유지 or Period로 변경] |
| Div | 선택·다중 | 검색 |  |  | ALL(좌) | Div. | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Plant | 선택·다중 | 검색 |  |  | ALL(좌) | Plant | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Material | 텍스트·다중 | 팝업 | 모1 |  |  | Meterial | 텍스트·다중 | 팝업 | 메1 |  | O | 팝업 |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Detail | 체크박스·기타 |  |  |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |

### Ending Inventory  (7행 / 변경 2)

| 구분 | As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| 월마감 기준 | Month | 텍스트·단일 | 달력 |  |  | YYYY-MM | Month | 텍스트·단일 | 달력 |  | YYYY-MM | X | [검토: 기존유지 or Period로 변경] |
| 월마감 기준, 일별 기준 | Div | 선택·다중 | 검색 |  |  | ALL(좌) | Div. | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| 월마감 기준, 일별 기준 | Plant | 선택·다중 | 검색 |  |  | ALL(좌) | Plant | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| 월마감 기준, 일별 기준 | Item Type | 선택·다중 | 검색 |  |  | ALL(좌) | Item Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| 월마감 기준, 일별 기준 | Material | 텍스트·다중 | 팝업 | 메1 |  |  | Material | 텍스트·다중 | 팝업 | 메1 |  | X |  |
| 월마감 기준, 일별 기준 | Devaluation Age | 체크박스·기타 |  |  |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| 일별 기준 | Date | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD | Date | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X | [검토: 기존유지 or Period로 변경] |

### BOD Validation Report  (14행 / 변경 1)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| From Site | 선택·다중 | 검색 |  |  | ALL(우) | From Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| To Site | 선택·다중 | 검색 |  |  | ALL(우) | To Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| From City | 선택·다중 | 검색 |  |  | ALL(우) | From City | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| To City | 선택·다중 | 검색 |  |  | ALL(우) | To City | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| 정확도 | 선택·단일 |  |  |  |  | 정확도 | 선택·단일 |  |  |  | X |  |
| Exfactory Date | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD(달력형식 다름, 주차X) | Exfactory Date | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X | [검토: 기존유지 or Period로 변경] |
| From Country | 선택·다중 | 검색 |  |  | ALL(우) | From Country | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| To Country | 선택·다중 | 검색 |  |  | ALL(우) | To Country | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| From 권역 | 선택·단일 |  |  |  |  | From 권역 | 선택·단일 |  |  |  | X |  |
| To 권역 | 선택·단일 |  |  |  |  | To 권역 | 선택·단일 |  |  |  | X |  |
| 조회구분 | 선택·다중 | 검색 |  |  | ALL(우) | 조회구분 | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Exfactory Date | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD(달력형식 다름, 주차X)_하단 둘중 단일선택 | Exfactory Date | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X | [검토: 기존유지 or Period로 변경] |
| F.Dest A TA Date | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD(달력형식 다름, 주차X)_하단 둘중 단일선택 | F.Dest A TA Date | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X | [검토: 기존유지 or Period로 변경] |

### Cell Tray Simulation  (5행 / 변경 1)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O | 비활성화_82 ESS Battery | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Plan Date | 선택·단일 |  |  | O |  | Plan Date | 선택·단일 |  |  |  | X |  |
| Plan type | 선택·단일 |  |  | O |  | Plan Type | 선택·단일 |  |  |  | X |  |
| To Site | 선택·단일 |  |  | O | 비활성화_PeopleWorks-KR-3 | To Site | 선택·단일 |  |  |  | X |  |
| Period | 텍스트·단일 | 달력 |  | O | 비활성화_1년 | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |

# ══ DM ══

## DM > Master > Demand Master

### Sales Site  (7행 / 변경 2)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  | 비활성화_ALL | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 |  |  |  | 비활성화_ALL | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Sold-To Customer | 선택·다중 | 검색 |  |  | ALL(우) | Sold-To Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Sales Site | 선택·다중 | 검색 |  |  | ALL(우) | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Active | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | X |  |
| Detail | 체크박스·기타 |  |  |  | 하단 화면 표시 기능 |  |  |  |  |  | O | 공통기능화 검토 |

### Sales Site Project Model  (11행 / 변경 6)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 | 검색 |  |  | ALL(우) | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Sales Site | 선택·다중 | 검색 |  |  | ALL(우) | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Active | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | X |  |
| Project | 텍스트·다중 |  |  |  | 비활성화 | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭 |
| Model / Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | O | 명칭 |
| Owner | 텍스트·다중 | 팝업 | 오1 |  |  | Owner | 텍스트·다중 | 팝업 | 오1 |  | X |  |
| Model Code Change | 버튼·기타 | 팝업 | Sales Site Project Model Popup |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| End Customer(Report) Null | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Project Null | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Customer Model Mapping  (9행 / 변경 5)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 |  |  |  |  | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Sales Site | 선택·다중 |  |  |  |  | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Customer PJT | 텍스트·다중 |  |  |  |  | Customer PJT | 선택·다중 | 검색 |  |  | O | 유형 |
| Customer Model | 텍스트·다중 |  |  |  |  | Customer Model | 선택·다중 | 검색 |  |  | O | 유형 |
| Project | 텍스트·다중 | 팝업 | 프2 |  |  | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭 |
| Model / Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | O | 명칭 |
| Active | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | X |  |

### Customer FCST Master  (5행 / 변경 2)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Bucket Type | 선택·단일 |  |  |  | Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | O | 명칭 |
| End Customer | 선택·다중 |  |  |  |  | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Sales Site | 선택·다중 |  |  |  |  | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Active | 선택·단일 |  |  |  | ALL/Y/N | Active | 선택·단일 |  |  |  | X |  |

### Sales Price  (16행 / 변경 8)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 | 검색 |  |  | ALL(우) | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Biz. Type | 선택·다중 |  |  |  |  | Biz. Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Period | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD(달력형식 다름, 주차X) | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Sales Site | 선택·다중 | 검색 |  |  | ALL(우) | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Project | 텍스트·다중 |  |  |  | 비활성화 | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭 |
| Model / Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | O | 명칭 |
| Exchange Rate | 버튼·기타 | 팝업 | Exchange Rate |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Plant Site | 선택·다중 |  |  |  | 비활성화_ALL | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Owner | 텍스트·다중 | 팝업 | 오1 |  |  | Owner | 텍스트·다중 | 팝업 | 오1 |  | X |  |
| Bucket | 선택·단일 |  |  |  | Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Search over range | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Version | 텍스트·다중 | 팝업 | 버세1 |  |  | Ver. | 텍스트·다중 | 팝업 | 버세1 |  | O | 명칭 |
| Price일괄입력 | 버튼·기타 | 팝업 | Price일괄입력 |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### 해외법인 기여율 등록  (5행 / 변경 4)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Year | 선택·단일 |  |  |  |  | Year | 선택·단일 |  |  |  | X |  |
| 년도별 | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| 불일치조회 | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| History | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| 기여율버전관리 | 버튼·기타 | 팝업 | 기여율 버전관리 |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### 해외법인 기여매출  (8행 / 변경 6)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Year | 선택·단일 |  |  |  |  | Year | 선택·단일 |  |  |  | X |  |
| Version | 텍스트·다중 | 팝업 | 버1 |  |  | Ver. | 텍스트·다중 | 팝업 | 버1 |  | O | 명칭 |
| 고객군 | 텍스트·다중 |  |  |  |  | 고객군 | 선택·다중 | 검색 |  |  | O | 유형 |
| 제품군 | 선택·단일 |  |  |  |  | 제품군 | 선택·단일 |  |  |  | X |  |
| Biz | 선택·단일 |  |  |  |  | Biz. Type | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭/유형 |
| [M$] | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| 정합성 체크 | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |

### ERP EDI MASTER 정비  (2행 / 변경 2)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| STATUS UPDATE | 버튼·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### N: N Master Mapping  (7행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Data Type | 선택·단일 |  |  |  | ALL/ERP/SCM | Data Type | 선택·단일 |  |  |  | X |  |
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 |  |  |  |  | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Project | 텍스트·다중 | 팝업 | 프2 |  |  | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭 |
| Model / Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | O | 명칭 |
| Sales Site | 선택·다중 |  |  |  |  | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |

## DM > Demand > Demand Plan

### MKT FCST  (21행 / 변경 12)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 | 검색 |  |  | ALL(우) | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Biz Type | 선택·다중 |  |  |  |  | Biz. Type | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Sender Code | 선택·다중 |  |  |  | 비활성화_ALL | Sender Code | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Period | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD(달력형식 다름, 주차X) | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Sales Site | 선택·다중 | 검색 |  |  | ALL(우) | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| AS | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Project | 텍스트·다중 | 팝업 |  |  | 비활성화 | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭 |
| Model / Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | O | 명칭 |
| Bucket | 선택·단일 |  |  |  | Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Master Chg | 버튼·기타 | 팝업 | MASTER CHANGE |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Plant Site | 선택·다중 |  |  |  | 비활성화_ALL | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Item Type | 선택·다중 |  |  |  |  | Item Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Owner | 텍스트·다중 | 팝업 | 오1 |  |  | Owner | 텍스트·다중 | 팝업 | 오1 |  | X |  |
| Suum | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Color | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Qty≥0 | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Cell Qty | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Sales Plan  (17행 / 변경 9)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 | 검색 |  |  | ALL(우) | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Item Type | 선택·다중 |  |  |  |  | Item Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Biz Type | 선택·다중 |  |  |  |  | Biz. Type | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Sales Site | 선택·다중 | 검색 |  |  | ALL(우) | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Project | 텍스트·다중 | 팝업 |  |  | 비활성화 | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭 |
| Model / Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD(달력형식 다름, 주차X) | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Plant Site | 선택·다중 |  |  |  | 비활성화_ALL | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Owner | 텍스트·다중 | 팝업 | 오1 |  |  | Owner | 텍스트·다중 | 팝업 | 오1 |  | X |  |
| Bucket | 선택·단일 |  |  |  | Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| Suum | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Color | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Include Internal Txn | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Sales Monitoring  (17행 / 변경 9)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 | 검색 |  |  | ALL(우) | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Item Type | 선택·다중 |  |  |  |  | Item Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Biz Type | 선택·다중 |  |  |  |  | Biz. Type | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Sales Site | 선택·다중 | 검색 |  |  | ALL(우) | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Project | 텍스트·다중 | 팝업 |  |  | 비활성화 | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭 |
| Model / Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD(달력형식 다름, 주차X) | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Plant Site | 선택·다중 |  |  |  | 비활성화_ALL | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Owner | 텍스트·다중 | 팝업 | 오1 |  |  | Owner | 텍스트·다중 | 팝업 | 오1 |  | X |  |
| Bucket | 선택·단일 |  |  |  | Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| Suum | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Color | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Include Internal Txn | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Customer FCST Upload  (11행 / 변경 5)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 |  |  |  |  | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Sales Site | 선택·다중 |  |  |  |  | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Plant Site | 선택·다중 |  |  |  |  | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Project | 텍스트·다중 | 팝업 | 프2 |  |  | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭 |
| Model / Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD(달력형식 다름, 주차X) | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Bucket Type | 선택·단일 |  |  |  | Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | O | 명칭 |
| Customer Handbook | 선택·다중 |  |  |  |  | Customer Handbook | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Upload | 버튼·기타 | 팝업 | FCST Upload |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Business Plan  (19행 / 변경 11)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 | 검색 |  |  | ALL(우) | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Biz Type | 선택·다중 |  |  |  |  | Biz. Type | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD(달력형식 다름, 주차X) | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Sales Site | 선택·다중 | 검색 |  |  | ALL(우) | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Project | 텍스트·다중 | 팝업 | 프2 |  |  | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭 |
| Model / Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | O | 명칭 |
| Bucket | 선택·단일 |  |  |  | Monthly/Quarterly/Yearly | Bucket | 선택·단일 |  |  |  | X |  |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Set Price | 버튼·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Replace | 버튼·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Ver. Cutoff | 버튼·기타 | 팝업 | Ver. Cut-Off [BP_M] |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Exchange Rate | 버튼·기타 | 팝업 | Exchange Rate |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Plant Site | 선택·다중 |  |  |  |  | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Owner | 텍스트·다중 | 팝업 | 오1 |  |  | Owner | 텍스트·다중 | 팝업 | 오1 |  | X |  |
| Item Type | 선택·다중 |  |  |  |  | Item Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Sum | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Qty≠0 | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Sales Report  (7행 / 변경 4)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Report type | 선택·단일 |  |  |  |  | Report type | 선택·단일 |  |  |  | X |  |
| Year | 선택·단일 |  |  |  |  | Year | 선택·단일 |  |  |  | X |  |
| Data Type | 선택·단일 |  |  |  |  | Data Type | 선택·단일 |  |  |  | X |  |
| SP Version | 텍스트·다중 | 팝업 | 세1 |  |  | SP Ver. | 텍스트·다중 | 팝업 | 세1 |  | O | 명칭 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Exchange Rate | 버튼·기타 | 팝업 | Exchange Rate |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### ETC Sales Report  (6행 / 변경 3)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Plan/Result | 선택·단일 |  |  |  | O | 명칭 |
| Plan/Result | 선택·단일 |  |  |  |  | Plan/Result | 선택·단일 |  |  |  | X |  |
| Report type | 선택·단일 |  |  |  |  | Report type | 선택·단일 |  |  |  | X |  |
| Year | 선택·단일 |  |  |  |  | Year | 선택·단일 |  |  |  | X |  |
| SP Version | 텍스트·다중 | 팝업 | 세1 |  |  | SP Ver. | 텍스트·다중 | 팝업 | 세1 |  | O | 명칭 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |

### MKT FCST (Auto)  (21행 / 변경 11)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 | 검색 |  |  | ALL(우) | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Biz Type | 선택·다중 |  |  |  |  | Biz. Type | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Sender Code | 선택·다중 | 검색 |  |  | ALL(우) | Sender Code | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Sales Site | 선택·다중 | 검색 |  |  | ALL(우) | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| AS | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Project | 텍스트·다중 | 팝업 | 프2 |  |  | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭 |
| Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | X |  |
| Owner | 텍스트·다중 | 팝업 | 오1 |  |  | Owner | 텍스트·다중 | 팝업 | 오1 |  | X |  |
| Period | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD(달력형식 다름, 주차X) | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Plant Site | 선택·다중 |  |  |  |  | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Item Type | 선택·다중 |  |  |  |  | Item Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Bucket | 선택·단일 |  |  |  | Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| Sum | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Color | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Qty≥0 | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Cell Qty | 체크박스·기타 |  |  |  | 비활성화 |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Master Chg | 버튼·기타 | 팝업 | MASTER CHANGE |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Metal Link Price  (11행 / 변경 7)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 |  |  |  |  | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Sales Site | 선택·다중 |  |  |  |  | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Plant Site | 선택·다중 |  |  |  | 비활성화_ALL | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Project | 텍스트·다중 | 팝업 |  |  | 비활성화 | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭 |
| Model / Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | O | 명칭 |
| Plan Date | 텍스트·단일 | 달력 |  |  | YYYY-MM | Period | 텍스트·단일 | 달력 |  |  | O | 용어 [검토: 기존유지 or Period로 변경] |
| Version | 텍스트·다중 | 팝업 | 버세1 |  |  | Ver. | 텍스트·다중 | 팝업 | 버세1 |  | O | 명칭 |
| Excel Form | 버튼·기타 | 팝업 | Meta Link Template |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Upload | 버튼·기타 | 팝업 | Metal Link Price |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### FcstPrice MGMT  (15행 / 변경 10)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 | 검색 |  |  | ALL(우) | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Biz Type | 선택·다중 |  |  |  |  | Biz. Type | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  |  | YYYY-MM-DD(달력형식 다름, 주차X) | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Exchange Rate | 버튼·기타 | 팝업 | Exchange Rate |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Sales Site | 선택·다중 | 검색 |  |  | ALL(우) | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Bucket | 선택·단일 |  |  |  | Daily/Weekly/Monthly | Bucket | 선택·단일 |  |  |  | X |  |
| Model / Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | O | 명칭 |
| Version | 텍스트·다중 | 팝업 | 버2 |  |  | Ver. | 텍스트·다중 | 팝업 | 버2 |  | O | 명칭 |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Qty≥0 | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Sum | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Price일괄입력 | 버튼·기타 | 팝업 | Price일괄입력 |  |  |  |  |  |  |  | O | 공통기능화 검토 |

## DM > Report > Waterfall

### MKT FCST Waterfall  (20행 / 변경 10)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 | 검색 |  |  | ALL(우) | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Biz Type | 선택·다중 |  |  |  |  | Biz. Type | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Sender Code | 선택·다중 | 검색 |  |  | ALL(우) | Sender Code | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Sales Site | 선택·다중 | 검색 |  |  | ALL(우) | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Project | 텍스트·다중 | 팝업 | 프2 |  |  | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭 |
| Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | X |  |
| Bucket | 선택·단일 |  |  |  | Daily/Weekly/Monthly/Only Weekly | Bucket | 선택·단일 |  |  |  | X |  |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Color | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Cell Qty | 체크박스·기타 |  |  |  | 비활성화 |  |  |  |  |  | O | 공통기능화 검토 |
| Plant Site | 선택·다중 |  |  |  |  | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Version | 텍스트·다중 | 팝업 | 버2 | O |  | Ver. | 텍스트·다중 | 팝업 | 버2 |  | O | 명칭 |
| Item Type | 선택·다중 |  |  |  |  | Item Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Owner | 텍스트·다중 | 팝업 | 오1 |  |  | Owner | 텍스트·다중 | 팝업 | 오1 |  | X |  |
| QTY | 선택·단일 |  |  |  |  | - |  |  |  |  | O | 공통기능화 검토 |
| Sum | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Sales Plan Waterfall  (23행 / 변경 14)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 | 검색 |  |  | ALL(우) | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Item Type | 선택·다중 |  |  |  |  | Item Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Biz. Type | 선택·다중 |  |  |  |  | Biz. Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Include Internal Txn | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Sales Site | 선택·다중 | 검색 |  |  | ALL(우) | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Project | 텍스트·다중 | 팝업 |  |  | 비활성화 | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭 |
| Model / Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | O | 명칭 |
| Owner | 텍스트·다중 | 팝업 | 오1 |  |  | Owner | 텍스트·다중 | 팝업 | 오1 |  | X |  |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Plant Site | 선택·다중 |  |  |  | 비활성화_ALL | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Version | 텍스트·다중 | 팝업 | 버세1 | O |  | Ver. | 텍스트·다중 | 팝업 | 버세1 |  | O | 명칭 |
| KRW | 선택·단일 |  |  |  |  | - |  |  |  |  | O | 공통기능화 검토 |
| USD | 선택·단일 |  |  |  |  | - |  |  |  |  | O | 공통기능화 검토 |
| LOC | 선택·단일 |  |  |  |  | - |  |  |  |  | O | 공통기능화 검토 |
| QTY | 선택·단일 |  |  |  |  | - |  |  |  |  | O | 공통기능화 검토 |
| Bucket | 선택·단일 |  |  |  | Daily/Weekly/Monthly/Only Weekly | Bucket | 선택·단일 |  |  |  | X |  |
| Sum | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Color | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Cell Qty | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Biz Plan Waterfall  (23행 / 변경 14)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  |  |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 | 검색 |  |  | ALL(우) | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Item Type | 선택·다중 |  |  |  |  | Item Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Biz. Type | 선택·다중 |  |  |  |  | Biz. Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Qty≠0 | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Sales Site | 선택·다중 | 검색 |  |  | ALL(우) | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Project | 텍스트·다중 | 팝업 |  |  | 비활성화 | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭 |
| Model / Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | O | 명칭 |
| Owner | 텍스트·다중 | 팝업 | 오1 |  |  | Owner | 텍스트·다중 | 팝업 | 오1 |  | X |  |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Plant Site | 선택·다중 |  |  |  | 비활성화_ALL | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Version | 텍스트·다중 | 팝업 | 버2 | O |  | Ver. | 텍스트·다중 | 팝업 | 버2 |  | O | 명칭 |
| KRW | 선택·단일 |  |  |  |  | - |  |  |  |  | O | 공통기능화 검토 |
| USD | 선택·단일 |  |  |  |  | - |  |  |  |  | O | 공통기능화 검토 |
| LOC | 선택·단일 |  |  |  |  | - |  |  |  |  | O | 공통기능화 검토 |
| QTY | 선택·단일 |  |  |  |  | - |  |  |  |  | O | 공통기능화 검토 |
| Bucket | 선택·단일 |  |  |  | Monthly/Quarterly/Yearly | Bucket | 선택·단일 |  |  |  | X |  |
| Sum | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Color | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Cell Qty | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### MKT FCST Comparison  (17행 / 변경 9)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 | 검색 |  |  | ALL(우) | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Biz Type | 선택·다중 |  |  |  |  | Biz. Type | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Sales Site | 선택·다중 | 검색 |  |  | ALL(우) | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Project | 텍스트·다중 | 팝업 | 프2 |  |  | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭 |
| Model / Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | O | 명칭 |
| Bucket | 선택·단일 |  |  |  | Daily/Weekly/Monthly/Only Weekly | Bucket | 선택·단일 |  |  |  | X |  |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| Diff. Only | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Plant Site | 선택·다중 |  |  |  |  | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Version | 텍스트·다중 | 팝업 | 버2 | O |  | Ver. | 텍스트·다중 | 팝업 | 버2 |  | O | 명칭 |
| Item Type | 선택·다중 |  |  |  |  | Item Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Owner | 텍스트·다중 | 팝업 | 오1 |  |  | Owner | 텍스트·다중 | 팝업 | 오1 |  | X |  |
| QTY | 선택·단일 |  |  |  |  | - |  |  |  |  | O | 공통기능화 검토 |
| Sum | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |

### Demand Manager  (2행 / 변경 1)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Version | 텍스트·다중 | 팝업 | 버1 |  |  | Ver. | 텍스트·다중 | 팝업 | 버1 |  | O | 명칭 |
| Period | 텍스트·단일 | 달력 |  |  | YYYY-MM | Period | 텍스트·단일 | 달력 |  | YYYY-MM | X |  |

## DM > Report > Customer Forecast

### Customer FCST Waterfall  (17행 / 변경 8)

| As-Is 명칭 | 유형 | 기능 | 팝업 | 필수 | As-Is 비고 | To-Be 명칭 | 유형 | 기능 | 팝업 | To-Be 비고 | 변경 | 변경내용 |
|---|---|---|---|:-:|---|---|---|---|---|---|:-:|---|
| Div | 선택·단일 |  |  | O |  | Div. | 선택·단일 |  |  |  | O | 명칭 |
| Team | 선택·다중 |  |  |  |  | Team | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| End Customer | 선택·다중 | 검색 |  |  | ALL(우) | End Customer | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Biz Type | 선택·다중 |  |  |  |  | Biz. Type | 선택·다중 | 검색 |  | ALL버튼 | O | 명칭 |
| Input Date | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Input Date | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X | [검토: 기존유지 or Period로 변경] |
| Period | 텍스트·단일 | 달력 |  | O | YYYY-MM-DD | Period | 텍스트·단일 | 달력 |  | YYYY-MM-DD | X |  |
| Sales Site | 선택·다중 | 검색 |  |  | ALL(우) | Sales Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Project | 텍스트·다중 | 팝업 |  |  | 비활성화 | PJT | 텍스트·다중 | 팝업 | 프2 |  | O | 명칭 |
| Model / Nickname | 텍스트·다중 | 팝업 | 모3 |  |  | Model/Nickname | 텍스트·다중 | 팝업 | 모3 |  | O | 명칭 |
| Bucket | 선택·단일 |  |  |  | Daily/Weekly/Monthly/Only Weekly | Bucket | 선택·단일 |  |  |  | X |  |
| NoName_이미지2 | 버튼·기타 | 팝업 | Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| NoName_이미지1 | 버튼·기타 | 팝업 | Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | O | 공통기능화 검토 |
| QTY | 선택·단일 |  |  |  |  | - |  |  |  |  | O | 공통기능화 검토 |
| Sum | 체크박스·기타 |  |  |  |  |  |  |  |  |  | O | 공통기능화 검토 |
| Plant Site | 선택·다중 |  |  |  | 비활성화_ALL | Plant Site | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Item Type | 선택·다중 |  |  |  |  | Item Type | 선택·다중 | 검색 |  | ALL버튼 | X |  |
| Owner | 텍스트·다중 | 팝업 | 오1 |  |  | Owner | 텍스트·다중 | 팝업 | 오1 |  | X |  |

