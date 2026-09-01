# DMF0035 Demand Plan Waterfall — FE 클라우드 이관 (2026-08-31, 토일월 수정분)

## 포함 (10 파일)
- `features/report/src/pages/demand-plan-waterfall/` 8본 + `__asis-mapping__.md`
  - 주요 수정: GUBUN_META(AS-IS 시트명·종속 PROGRAM_ID 메타 조회) / Measure 선택 모달·표시 필터(MEASCOUNT — 건수·그리드 동일 축)
    / VERCUR·VERREQ(버전 CURRENT 기본·전 타입 필수) / PERIOD6M(당월1일~+6개월−1일, 타입 변경 시 재설정)
    / NOONLYWEEKLY(버킷 콤보 ONLY_WEEKLY 제거) / BUCKETRESET(버킷 변경 시 그리드 초기화) / NOFILTERICON·NOCOMMONFS
    / RAILW150(레일 450px + zones 스크롤) / RAILSPLIT / W39(VERSION 말미 고정) / W45(MEASURE 위치 강제 해제·X만 봉인)
    / UM02FIX(EndCustomerByDivision + 40 한정 cascade) / NOCHARTBTN
- `packages/shared/src/hooks/useCustomQueryClient.ts` — 주말 공통 수정(쿼리 키 안정 해시) ⚠ 공용 파일: 클라우드 최신본과 diff 후 반영

## d.ts
- DMF0035 블록은 금요일 이관 이후 변경 없음 → 미포함.

## 짝 DB 패키지 (클라우드 미적용 — 함께 반영 필수)
- `_artifacts/_apply_corporate/DMF0035_W34_DEFAULTFLAG_20260831/` 01~03 (PKG_DMF0022/0035/0051 —
  W34 숨은컬럼 arm RTRIM + W41 TITLE TEI 조인 + VERCASE 'Current' 대소문자 CI). FE 만 반영하면 SALES/BIZ 미조회 재발.

## 반영 방법
- `nscm-fe/` 이하 **실경로 그대로** 클라우드 소스에 덮어쓰기 (축약·평탄화 ⛔ — 룰 22 §1.8).
- `procedures.d.ts.*_BLOCK.txt` 는 클라우드 d.ts 에 **블록 단위 병합**만 (전체본 덮어쓰기 ⛔, hook #148). 동일하면 스킵.
- 취합 기준: 2026-08-29(토)~08-31(월) 수정분 최종본. 금요일(08-28) 이관분에서 미수정 파일은 미포함.
- 검증: 로컬 type-check 13/13 PASS + lint 0 error (2026-08-31, fe-check.ps1 — 넥서스 미접속).
