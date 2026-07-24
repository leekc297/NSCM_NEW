# DMF0003 Measure 조회 AS-IS 파리티 fix (SHEET_PRSL_YN 등록) — 2026-07-23

## 결함 (사용자 신고: "measure 조회 sql 이 oracle 변환하면서 오류")
TO-BE measure 조회 = `PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_MEASURE_LIST` (BE `/admin/menu/{mnuId}/measure`).
이 SP 는 `SHEET_PRSL_YN` lookup 게이트로 2경로 분기:
- 등록('Y') → **titleset 'M' LEFT JOIN** (DISPLAY_FLAG=사용자 선택, 시드 INSERT 포함) = **AS-IS 동형**
- 미등록 → DISPLAY_FLAG=DEFAULT_FLAG 고정 (titleset 무시) ← **DMF0003 이 이 경로였음 (미등록)**

AS-IS 원본(`_asis_original/asis_SCM0002_GET_TITLESET_POPUP.sql` — Measure 분기)은 게이트 없이 **항상**
`scm_mst_sheet_measure b LEFT JOIN scm_mst_titleset_user u` 로 user_flag('Y'/'N') 반환.
→ TO-BE 미등록 상태 = Measure 선택 저장이 모달 재오픈에 반영되지 않는 변환 결함.
(사내 lookup 실측: DMF0082='Y' 기등록 선례 / DMF0003 누락. SP 본문은 무수정 — 메타 등록만으로 AS-IS 경로 활성.)

## 적용 (클라우드)
```
sql/01_SHEET_PRSL_YN_DMF0003.sql   (멱등 INSERT 1행)
```

## 검증 (사내 OCGSCMD_P01, 2026-07-23 적용 완료)
- 등록 후 SP 23행 / DISPLAY_FLAG Y=titleset 4종.
- **왕복 테스트 PASS**: titleset 'M' 에 MKT_FCST 추가 → SP DISPLAY_FLAG='Y' 반영 → 원복 → 'N' 복귀.

## 잔여/참고
- 동일 게이트 미등록 화면(=measure 개인화 모달 보유 화면)은 같은 증상 가능 — 현재 lookup 등록은 DMF0082/DMF0003 2건.
  타 화면(DMF0021 등)에서 동일 신고 시 이 lookup 등록이 1순위 조치.
