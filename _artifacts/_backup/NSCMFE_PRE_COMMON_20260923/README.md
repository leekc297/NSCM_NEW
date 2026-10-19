# 공통소스 다운로드 회차 보고 — 2026-09-23

- 원천: `https://github.com/eunjoo-hwang/nscm-fe.git` (remote `common`, push URL = `no_push`)
- 기준선: `77d024d4` (2026-09-22 적용분) → **신규 기준선 `3a2c2c0b`** ("updated scp 조회조건")
- 공통 신규 커밋 42건 / 전체 변경 493파일 (대부분 `.atlas`·`Doc/rules` = 4폴더 밖 → 미반영)
- **4폴더(apps·features·packages·public) + configs 대상 = 43본** (신규 37 / 수정 6)
- `77d024d4` 는 `3a2c2c0b` 의 조상 — 이번 회차 force-push 재작성 없음

## 분류·처리 결과

| 구분 | 건수 | 처리 |
|---|---:|---|
| 신규(A) | 37 | 전부 신규 적용 (로컬 기존 파일 충돌 0) |
| 수정 — 로컬 무편집 | 2 | 공통 채택 (capaNewModelPopup 2본) |
| 수정 — 3-way 대상 | 2 | **사용자 지시(2026-09-23) 로 공통 원문 verbatim 채택 — 내 수정 무시** |
| 수정 — locales | 2 | 키 단위 병합 (EN/KO 각 `MSG00251` 1키 추가, 로컬 키 전량 보존) |

### 공통 원문 채택 2본 (내 수정 폐기 — 사용자 지시)
1. `features/demand/src/components/fcst-upload-modal/FcstUploadModal.tsx`
   - 3-way base `ad7b2cb9`(09-15) 기준 충돌 1 — 양쪽이 같은 결함(오류그리드 컬럼을 첫 행 키로만 산출)을
     각자 수정. 공통본이 상위(전 행 union + `EXCEL_ROW` 시드 + `useMemo`).
2. `features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx`
   - 3-way base `01b82603`(09-18) 기준 **충돌 8** — DMF0035 SALES Version Monthly Rolling Forecast 를
     양쪽이 독립 구현. 로컬본 폐기분: `hasButton('SAVE')` 권한게이트 · 당주(`isCurrentWeekYmd`) 판정 ·
     `GridUtils.getChangedRows`/`isEditableCell` 경유 · MSG00614 필수입력 검증.
     공통본 채택분: `EditTracker` 기반 dirty 판정 · `savingRef` 재진입 가드 · Y/N 콤보(`YesOrNo`) ·
     `MSG00606` 저장성공 토스트 · `buildVersionColumns(isSalesSheet)`.
   - 저장 SP 계약은 양쪽 동일 (`PKG_DMF0035.P_DMF0035_SAVE_VERSION_MRF`, `'^'` 조인 배치).

### 신규 37본 (화면 3 + 팝업 1)
- `features/shipping/src/pages/delegate/` (SSP0020) 11본
- `features/shipping/src/pages/shipment-model-pic/` (SSP0014) 11본
- `features/supply/src/pages/operation-lt/` (SCP0037) 11본
- `features/master/src/components/capaNewModelPopup/capaNewModelPopup.editLock.ts` 1본
- `features/*/__asis-mapping__.md` 3본 (위 화면 폴더 포함 집계)

## ⚠️ 미해소 1 — 신규 3화면의 `procedures.d.ts` 키 부재
`SSP0020` · `SSP0014` · `SCP0037` 키가 **로컬·공통 양쪽 `configs/types/procedures.d.ts` 모두 0건**.
발췌 원본이 없어 임의 작성하지 않고 보류 (과거 `SCP0013` 건과 동일 유형).
→ 해당 3화면은 `viewRegistry`/배럴 배선도 **공통 원본에서 이미 미배선**(공통 `viewRegistry` 참조 0건)이라
런타임 영향 없음. 배선·d.ts 채번은 사용자 결정 대기.

## 원복 자료
- `local_before/` — 이번 회차에 덮어쓴 로컬 원본 6본 (수정 대상 전부)
- `worktree_tracked.patch` — 적용 직전 `nscm-fe` 추적파일 전체 diff (56,849행)
- `git_status_before.txt` — 적용 직전 워킹트리 상태

## 검증
- 대상 41본(locales 제외) **공통 원문과 바이트 일치 0 불일치** (개행 정규화 후 대조)
- 충돌마커 잔존 0건
- `public/locales/*.json` 은 `.gitignore` 대상 — git diff 에 안 잡히므로 파일 직접 grep 으로 `MSG00251` 확인
- 정적검증(type-check/lint) 미수행 — 사용자 지시(2026-09-02) 유지
