# 2026-09-14 사내 적용분 일괄 재반영 (ZIOUI1)

## ✅ 재적용 완료 — 2026-09-14 16:42 (사용자 지시: "14:10 이전 적용 SQL 재적용")
- 실행: `python apply_batch.py --apply "--steps=01,02,03,04,05,06"` (07 SYS0006 = 14:10 이후 적용분이라 제외·현재 반영됨) · 로그 `apply_log_20260914.txt`
- 결과: 01·02 BODY VALID/오류 0 · 03 시노님 생성 · 04 SCM_MGR|PKG_ 행 MERGE · 05 HEADER 재기록(동일값) · 06 SKIP(이미 반영)
- `90_POSTCHECK` 전 항목 기대값 일치 (로그 `postcheck_log_20260914.txt`): 마커 MULTISEL 6 / DMF0053FLT 3 / EXCELROW 1, `<> ''` 잔존 0, 시노님 1
- 기능 실측: DMF0053 BE API Project 59·Model 14·Owner 59 (선택값만) / SYS0005 procList 504행 / DMF0040 멀티선택 전수 OK (Plant Site 172·38·210, Div40 End Customer·Project 58·40·98) — 원 적용 시 실측과 동일

## 배경
2026-09-14 14:10 사내 ZIOUI1 PDB 가 새로 생성되어(SERVER_HOST `ol9-db`, 내용 시점 ≈ 09-14 10:24) 그 사이 적용분 일부가 현재 DB 에 없다.
오늘 사내에 적용한 SQL 전체를 이 폴더에 모았다 — 차후 일괄 반영용. **아직 실행하지 않았다(드라이런만).**

## 대상 목록 · 현재 상태 (2026-09-14 16:40 실측)

| 순서 | 파일 | 화면 | 내용 | 계정 | 현재 DB |
|---|---|---|---|---|---|
| 01 | `01_DMF0040_PKG_DMF0040_BODY.sql` | DMF0040 | PKG_DMF0040 BODY 전체 — Plant Site 괄호 누락(ORA-00907) / Div40 End Customer 멀티선택 LIKE / Project `<> ''` | SCM_MGR | **미반영** (본문 = 적용 전 백업) |
| 02 | `02_DMF0053_PKG_DMF0053_BODY.sql` | DMF0053 | PKG_DMF0053 BODY 전체 — Project/Model/Owner `IS NOT NULL AND <> ''` 3곳 정정 | SCM_MGR | **미반영** (본문 = 적용 전 백업) |
| 03 | `03_DMF0053_SYNONYM_SCMP_APP.sql` | DMF0053 | SCMP_APP 시노님 PKG_DMF0053 (멱등 블록) | **SCMP_APP** | **미반영** |
| 04 | `04_SYS0005_LOOKUP_UI_PKG_NM_MERGE.sql` | SYS0005 | 룩업 UI_PKG_NM 에 SCM_MGR + PKG_ 행 MERGE (기존 행 보존) | SCM_MGR | **미반영** |
| 05 | `05_DMF0074_EXCEL_COLUMNS_HEADER_UPDATE.sql` | DMF0074 | Excel Form 2단 헤더 HEADER_CONTENT (DMF0074 / DMF0074_40) | SCM_MGR | 반영됨 (재실행 무해) |
| 06 | `06_DMF0074_PKG_NSCM_UI_EXCEL_BODY.sql` | 공용 Excel | PKG_NSCM_UI_EXCEL BODY — EXCEL_ROW = 엑셀 실제 행 번호 | SCM_MGR | 반영됨 (실행기 SKIP) |
| 07 | `07_SYS0006_LOOKUP_API_TP_CD_MERGE.sql` | SYS0006 | 룩업 API_TP_CD 5코드 목표상태 MERGE | SCM_MGR | 반영됨 (재실행 0행) |

- 원래 산출물(근거·실측): `../DMF0040_MULTISEL_20260914/` · `../DMF0053_FILTER_20260914/` · `../SYS0005_LOOKUP_UIPKG_20260914/` · `../DMF0074_EXCELFORM_2TIER_20260914/` · `../SYS0006_LOOKUP_APITYPE_20260914/` 의 `_README.md`
- DMF0074 는 BE(ExcelUtils·FileServiceImpl)·FE(gridAction·FcstUploadModal 등) 변경이 함께 있다 — 이 폴더는 **DB 분만**

## 실행 방법
```
python apply_batch.py            # 드라이런 — 접속 대상·게이트 판정·문장 수만 출력
python apply_batch.py --apply    # 적용 (01→07, 오류 시 중단, BODY 는 VALID/ALL_ERRORS 0 확인)
```
그 뒤 `90_POSTCHECK.sql` 로 검증. 수동 실행 시에는 `00_PRECHECK.sql` → 01~07 순서(03 만 SCMP_APP) → `90_POSTCHECK.sql`.

### 안전 게이트 (01·02·06 = PKG BODY 전체 교체)
| 현재 DB 본문 | 판정 |
|---|---|
| = 적용본 | SKIP (이미 반영) |
| = 적용 전 백업(`99_ROLLBACK/R0x`) | 적용 |
| 둘 다 아님 | **ABORT** — 그 사이 다른 사람이 수정. 전체 교체 금지, 차이분(마커 `E20260914-MULTISEL` / `E20260914-DMF0053FLT`)만 병합 |

2026-09-14 16:40 드라이런: 01·02 = 적용 / 06 = SKIP / 03·04·05·07 = 멱등 실행.
**반영 시점에 다시 드라이런** — 그때까지 다른 변경이 들어오면 ABORT 로 걸린다.

## 검증 기대값 (`90_POSTCHECK.sql`)
- PKG_DMF0040 / PKG_DMF0053 / PKG_NSCM_UI_EXCEL BODY VALID, ALL_ERRORS 0
- 마커: MULTISEL ≥ 6 · DMF0053FLT ≥ 3 · EXCELROW ≥ 1, `IS NOT NULL AND P_x <> ''` 잔존 0
- SCMP_APP.PKG_DMF0053 시노님 1 · UI_PKG_NM 에 SCM_MGR|PKG_|Y · DMF0074 HEADER `Period(Fr)_Ni` 형태 · API_TP_CD 5코드 각 1행
- 화면: DMF0040 End Customer 2건·Plant Site / DMF0053 Project·Model·Owner / SYS0005 목록 조회 / SYS0006 API Type 콤보

## 원복 (`99_ROLLBACK/`)
| 파일 | 대상 |
|---|---|
| R01 / R02 / R06 | 각 PKG BODY 적용 전 전체본 (CREATE OR REPLACE) |
| R04 | UI_PKG_NM 의 SCM_MGR+PKG_ 행 삭제 |
| R05 | DMF0074 HEADER_CONTENT 적용 전 값 |
| R07 | API_TP_CD 로 새로 넣은 5행 삭제 (보정 UPDATE 된 환경은 사전 SELECT 결과로 복원) |
| 03 원복 | SCMP_APP 에서 `DROP SYNONYM PKG_DMF0053;` |

## ⚠ 클라우드
이 폴더는 **사내 전용**. 클라우드는 본문이 다르다(DMF0040 = 09-09 VERLABEL 본문 → 01 전체 교체 금지, 3건만 병합). 클라우드 이관은 각 원래 산출물 README 의 주의사항을 따른다.
