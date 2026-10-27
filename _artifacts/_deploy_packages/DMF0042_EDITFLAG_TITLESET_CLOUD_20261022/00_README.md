# DMF0042_EDITFLAG_TITLESET_CLOUD_20261022 — Business Plan 편집 불가(노란 셀 0) 보정 (클라우드 패치, DB 만)

- 마커: `[E20261022-EDITFLAG]` 1곳 · 대상: `SCM_MGR.PKG_DMF0042` PACKAGE BODY → `P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA`
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료 · 리허설 재적용(10:38, 사내 적용본과 원문 전체 일치) — `_artifacts/_apply_corporate/DMF0042_EDITFLAG_20261022/APPLIED_OPERATIONS.md`
- **FE 무변경 · BE 재기동 불필요 · 데이터·메타 변경 없음.** 같은 BODY 의 GAP257/GAP261 패키지와 위치가 달라 서로 독립.

## 무엇이 바뀌나
조회 SP 는 화면 컬럼 목록을 메타(SCM_MST_SHEET_COLUMNS)로 만든다. 편집 판정 칸 `EDIT_FLAG` 는 숨은 고정 칸(VISIBLE_FLAG 'N')이고,
10-19 빈 값 일괄 변환으로 DEFAULT_FLAG 가 'N' 이 됐다. 컬럼 목록 2분기 중 **개인 컬럼 설정이 저장된 사용자 분기**만 `RTRIM(DEFAULT_FLAG) IS NULL`
그대로라 EDIT_FLAG 를 빼고 반환한다 → 화면이 모든 행을 잠금(노란 셀 0).
→ 그 1줄을 기본 분기와 같은 `NVL(RTRIM(C.DEFAULT_FLAG, ' -'), 'N') = 'N'` 으로 변경(원래 줄은 주석 보존).

## 사내 검증 (ZIOUI1, SP 직접 호출)
- minyonglee1 / ADMIN / 40 / 2026-10-01~2027-04-30: 수정 전 EDIT_FLAG 컬럼 없음 → 수정 후 72행 전부 `'Y'` (행 수 동일)
- 개인 설정 없는 사용자(admin): 1,434행 EDIT_FLAG `'Y'` — 회귀 없음

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 4줄 PASS · L2 마커 0 · L3 메타 EDIT_FLAG DEFAULT_FLAG `[N]` · 개인설정 사용자 ≥ 1 | L1 FAIL 이면 **10 실행 금지**, 결과 회신 |
| 2 | `A_DB/10_APPLY_EDITFLAG_PATCH.sql` | `APPLIED — PKG_DMF0042 BODY VALID · 마커 1곳` | `중단 — …` 이면 원문 무변경, 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 마커 1 · 판정줄 0 · V2 VALID/오류 0 PASS | 회신 |
| 4 | 화면: minyonglee1 / 40 / 2026-10-01~2027-04-30 조회 | 2027-01~ 컬럼의 Business_Plan·LOC 행 노란색·편집 가능 (2026-10~12 는 유효구간 밖이라 잠김 = 정상) | 회신 |
| 원복 | `A_DB/99_ROLLBACK_EDITFLAG_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치 1줄 + 원래 줄 주석) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 |
| 메타(SHEET_COLUMNS) · 데이터 | 변경 없음 |
| MSG/LBL · GRANT/SYNONYM · FE · BE | 해당 없음 |

## 파일
- `build_package.py` — 생성기(FRESH-GATE · 시뮬레이터 · ASCII 앵커) · `run_rehearsal.py` · `_rehearsal_out/` · `_md5now.py` · `_md5_corporate_applied.txt`
