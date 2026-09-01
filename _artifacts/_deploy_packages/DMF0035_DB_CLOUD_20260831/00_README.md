# DMF0035 계열 DB 클라우드 이관 (2026-08-31 사내 정본 — 클라우드 미적용)

> 원본 기록: `_artifacts/_apply_corporate/DMF0035_W34_DEFAULTFLAG_20260831/` (사내 적용 이력). 본 폴더 = 클라우드 이관용 취합.
> FE 짝 패키지: `DMF0035_FE_CLOUD_20260831` — **함께 반영 필수** (FE 만 반영 시 SALES/BIZ 미조회 재발).

## 포함 (전체본 3본 — 토·일·월 수정 통합 최종)
| 파일 | 정정 마커 | 내용 |
|---|---|---|
| 01_PKG_DMF0022_BODY.sql | W34 ×4 · VERCASE ×5 | 숨은컬럼 arm RTRIM(MEASURE/VERSION_NO 축 복원) + CTE 고정 A.MEASURE 제거 + 'Current' 대소문자 CI |
| 02_PKG_DMF0035_BODY.sql | W34 ×3 · VERCASE ×5 | SPREAD_TITLE ''=NULL 사문 arm 정정 + CURRENT CI |
| 03_PKG_DMF0051_BODY.sql | W34 ×3 · W41 ×3 · VERCASE ×2 | 숨은컬럼 arm + TITLE TEI 조인(P_DIVISION_ID — DIVISION_ID 등 콤마목록 4컬럼 복원) + CURRENT CI |

## 스윕 결과 (2026-09-01)
- SP/객체 축: LAST_DDL ≥ 08-29 = 위 3본뿐 (DMF0040/0053/SCM0002 계열 변경 없음 — 금요일 이관분 그대로)
- 메타 축: PROGRAM_ID(DMF0035/22/51/40/53) × 감사컬럼 보유 35개 테이블 + MNU/BTN/언어 축 전수 = **변경 0행** → 메타 이관 대상 없음

## 적용 순서
1. (백업) 클라우드 현재 본문 spool 후 01→02→03 실행
2. `04_POSTCHECK.sql` 실행 — 3본 VALID + 마커 카운트 일치 + 컴파일 오류 0 이 통과 기준
