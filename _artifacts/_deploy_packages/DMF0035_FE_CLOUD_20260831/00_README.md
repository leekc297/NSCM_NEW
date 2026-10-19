# DMF0035 Demand Plan Waterfall — FE 클라우드 이관 (2026-08-31, 토일월 수정분)

## 포함 (10 파일)
- `features/report/src/pages/demand-plan-waterfall/` 8본 + `__asis-mapping__.md`
  - 주요 수정: GUBUN_META(AS-IS 시트명·종속 PROGRAM_ID 메타 조회) / Measure 선택 모달·표시 필터(MEASCOUNT — 건수·그리드 동일 축)
    / VERCUR·VERREQ(버전 CURRENT 기본·전 타입 필수) / PERIOD6M(당월1일~+6개월−1일, 타입 변경 시 재설정)
    / NOONLYWEEKLY(버킷 콤보 ONLY_WEEKLY 제거) / BUCKETRESET(버킷 변경 시 그리드 초기화) / NOFILTERICON·NOCOMMONFS
    / RAILW150(레일 450px + zones 스크롤) / RAILSPLIT / W39(VERSION 말미 고정) / W45(MEASURE 위치 강제 해제·X만 봉인)
    / UM02FIX(EndCustomerByDivision + 40 한정 cascade) / NOCHARTBTN
- `packages/shared/src/hooks/useCustomQueryClient.ts` — 주말 공통 수정(쿼리 키 안정 해시) ⚠ 공용 파일: 클라우드 최신본과 diff 후 반영
- `packages/shared/src/components/organisms/olap-pivot-grid/OlapPivotGrid.tsx` — ⭐ 필수 (2026-09-01 보강):
  `extraFields`/`onLayoutChange`/`onGridInit` prop — 금요일 저녁(08-28 19:32) 수정분이라 최초 취합(토~월 필터)에서 누락.
  클라우드 type-check 실측 오류 `TS2322 Property 'extraFields' does not exist` 의 원인. 공통소스 8f0b2a60 대조로 로컬이 최신 확정.

## 이관 제외 판정 (2026-09-01 공통소스 8f0b2a60 대조)
- `features/master/src/components/index.ts` — 클라우드가 더 최신(bigFilterCombo export 추가) → 로컬본 올리면 역행. 제외.
- 그 외 3화면 의존 외부 심볼 전수 대조(CustomDropdown/unpivotWideRows/toGridNumber/CustomMergeManager/createPersistedStoreWithTab/IcMeasureSelect/FunctionSearchIcon/MeasureMeta) = 공통소스 실존 확인 — 추가 반영 불요.

## d.ts (2026-09-01 공통소스 8f0b2a60 대조로 정정)
- `procedures.d.ts.DMF0035_BLOCK.txt` — 공통소스 블록과 **상이**(로컬 최신, 230행) → 블록 단위 교체.
  bizPlanWaterfall/salesPlanWaterfall 등 시트 배선 타입은 전부 이 블록 내부 (별도 DMF0051 블록은 양쪽 다 없음 — 정상)
- 2026-09-01 2차 보강: 취합 기준을 mtime(토~월)에서 **공통소스 내용 대조**로 전환 — 화면 폴더 **전체본**(18파일)으로 재취합
  (금요일 저녁 수정분 누락 2건: OlapPivotGrid extraFields·0040/0053 constants — 클라우드 type-check 실측 오류 2회의 원인)

## 짝 DB 패키지 (클라우드 미적용 — 함께 반영 필수)
- `_artifacts/_apply_corporate/DMF0035_W34_DEFAULTFLAG_20260831/` 01~03 (PKG_DMF0022/0035/0051 —
  W34 숨은컬럼 arm RTRIM + W41 TITLE TEI 조인 + VERCASE 'Current' 대소문자 CI). FE 만 반영하면 SALES/BIZ 미조회 재발.

## 반영 방법
- `nscm-fe/` 이하 **실경로 그대로** 클라우드 소스에 덮어쓰기 (축약·평탄화 ⛔ — 룰 22 §1.8).
- `procedures.d.ts.*_BLOCK.txt` 는 클라우드 d.ts 에 **블록 단위 병합**만 (전체본 덮어쓰기 ⛔, hook #148). 동일하면 스킵.
- 취합 기준: 2026-08-29(토)~08-31(월) 수정분 최종본. 금요일(08-28) 이관분에서 미수정 파일은 미포함.
- 검증: 로컬 type-check 13/13 PASS + lint 0 error (2026-08-31, fe-check.ps1 — 넥서스 미접속).
