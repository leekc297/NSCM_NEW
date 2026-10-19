# DMF0042_GAP261_REPLINCO_CLOUD_20261015 — 40 Replace 2024-12 이전 구간 불가 보정 (클라우드 패치, DB 만)

- 마커: `[E20261015-GAP261]` 1곳 · 대상: `SCM_MGR.PKG_DMF0042` PACKAGE BODY → `P_DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF`
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료 · 리허설 재적용(19:09, 사내 적용본과 원문 전체 일치) — `_artifacts/_apply_corporate/DMF0042_GAP261_20261015/APPLIED_OPERATIONS.md`
- **FE 무변경 · BE 재기동 불필요 · 데이터 변경 없음.** GAP257 패키지(`DMF0042_GAP257_BLANKFILL_CLOUD_20261015`)와 같은 BODY 의 다른 위치 — 서로 독립, 어느 순서든 가능.

## ⚠ 원인 재판정 (2026-10-15 19:30) — 이 패치는 GAP 261 해결책이 아님 (선택 적용)
- QA PRECHECK 결과는 다음과 같다. 원장 INCOTERMS 에 `DEFAULT ON NULL '/'` 이 있다. 기본값 없는 NOT NULL 컬럼의 NULL 은 0, 컷오프 PK 중복도 0 이다. Replace 실행 로그는 30일 0건이다 → **ORA-01400 은 원인이 아니다.**
- GAP 261 의 실제 원인은 기간 하나를 버전 목록 조회 필터와 Replace 구간에 함께 쓰는 구조다(AS-IS 와 같음). 2024 구간에서 고를 수 있는 버전은 `24BP_DM_2024_W23_V01` 1건이고, 컷오프 데이터가 0행이다. 그래서 TO-BE 가드가 "되돌릴 자료가 없습니다"로 중단한다. AS-IS 는 같은 경우에 그 구간을 비워 버린다.
- 이 패치를 적용해도 동작은 같다. 효과는 원장 DEFAULT 와 무관하게 빈 INCOTERMS 를 '/' 로 넣는 방어뿐이다. **사내 ZIOUI1 에는 적용돼 있으므로 사내와 원문을 맞추려면 적용하고, 원하지 않으면 생략해도 된다.**

## 무엇이 바뀌나
40 Replace 는 컷오프 `DM_PLN_BP_FCST_C` 를 원장 `DM_PLN_BP_FCST` 로 되돌린다. 컷오프 INCOTERMS 는 NULL 허용, 원장은 NOT NULL(PK)이라
컷오프에 INCOTERMS NULL 행이 있는 구간(2024-12 이전)은 **ORA-01400 으로 Replace 전체가 실패**한다(원장에 DEFAULT ON NULL 이 없는 DB).
→ INSERT…SELECT 의 `INCOTERMS` 를 `NVL(NULLIF(RTRIM(INCOTERMS), ''), '/')` 로 1줄 변경 (빈값 = '/', 이관·적재 규칙과 같음).

## 사내 검증 (ZIOUI1, 전부 ROLLBACK)
- 202401~202412 Replace `OK 110,908` · 202609~202702 `OK 68,534` (수정 전과 동일)
- 컷오프 빈값 336행을 NULL 로 바꾼 상태에서 Replace → 오류 없음 · 원장 INCOTERMS '/' 336행
- 사내는 원장 DEFAULT ON NULL '/'·컷오프 값 '-' 라 수정 전에도 실패가 재현되지 않았다 → **클라우드 원인 판정은 00_PRECHECK L3** 로 한다.

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 2줄 PASS · L2 마커 0 · **L3 = 원인 판정**(아래) | L1 FAIL 이면 **10 실행 금지**, 결과 회신 |
| 2 | `A_DB/10_APPLY_GAP261_PATCH.sql` | `APPLIED — PKG_DMF0042 BODY VALID · 마커 1곳` | `중단 — …` 이면 원문 무변경, 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 마커 1 · V2 VALID/오류 0 PASS | 회신 |
| 4 | 화면: 40 Replace 를 2024-12 이전 구간으로 실행 | 정상 완료 | 회신 (오류 문구 포함) |
| 원복 | `A_DB/99_ROLLBACK_GAP261_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

**L3 판정**: `L3 컷오프`(버전별 INCOTERMS NULL 행) > 0 이고 `L3 원장` DM_PLN_BP_FCST.INCOTERMS 의 DEFAULT_ON_NULL = NO → GAP 증상의 원인이 이것으로 확정, 본 패치로 해소.
`L3 컷오프` 가 0행이면 다른 원인 — 4단계 화면 실행 결과(오류 문구)를 회신해 주십시오.

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치 1줄) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 |
| 원장·컷오프 데이터 | 변경 없음 (GAP 조치안의 `_C` 데이터 UPDATE 대신 SP 에서 보정) |
| 메타 · MSG/LBL · GRANT/SYNONYM · FE · BE | 해당 없음 |

## 파일
- `build_package.py` — 생성기(FRESH-GATE · 시뮬레이터) · `run_rehearsal.py` · `_rehearsal_out/` · `_md5now.py` · `_md5_corporate_applied.txt`
