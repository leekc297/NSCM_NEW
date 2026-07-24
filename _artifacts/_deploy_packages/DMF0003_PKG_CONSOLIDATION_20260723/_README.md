# DMF0003 PKG 취합 (standalone → PKG_DMF0003 병합) — 2026-07-23

## 배경
DMF0003는 이미 main GET/SAVE만 PKG 병합(savemerge)돼 있고 서브기능(car/psi/pr popup/title)은 standalone 배선 상태였음. 전 standalone을 PKG_DMF0003로 합류.

## 4버킷 처리 결과 (standalone 23)
- **B2 병합 15** (배선 standalone → PKG):
  - twin無 신규 6: GET_DM_ANL_MKT_PSI_AN_LOGIC(INVALID→재컴파일 VALID), GET_DM_ANL_MKT_PSI_DATA, GET_PRPOPUP, GET_PR_HISTORY_POPUP, SAVE_DM_ANL_MKT_PSI_DETAIL, SAVE_PRPOPUP
  - twin refresh 8 (PKG twin이 standalone과 상이 → live 기준 최신화): GET_DM_ANL_CAR_PROPERTY, GET_DM_ANL_CAR_REF, GET_DM_ANL_MKT_PSI_DPINIT, GET_DM_ANL_MKT_PSI_DPRESULT, GET_MKT_FCST_COMPARE_POPUP, GET_SPREAD_TITLE, GET_SPREAD_TITLE_CAR, GET_SPREAD_TITLE_PSI
  - SAVE_MKT_FCST: main SAVE는 이미 PKG. **DELETE 버튼**도 PKG로 전환(같은 SAVE proc) + standalone 삭제
- **B1 유지 1**: GET_MKT_FCST_DATA (PKG 배선, GTT 리네임 반영본)
- **B3 삭제 7** (미사용 standalone, API/콤보/의존 0 확인): CAR_FCST_EXCEL_UPLOAD, GET_BUCKET_TYPE_CODE, GET_QTY_TYPE_CODE, GET_REPORT_BUCKET_TYPE_CODE, GET_SPREAD_TITLE_PSI_POPUP, MKT_FCST_SALES_PLAN_SYNC, SAVE_MKT_FCST_PK_DATA_UPDATE (PKG twin은 유지)
- **B4 보류**: DMF0002/SCM0002 titleSet (공통)

**처리 후 PKG_DMF0003 = 멤버 23** (기존 9 유지 + 14 최신화/신규). standalone 23개 전부 삭제.

## 파일 / 적용 순서 (클라우드)
```
1) sp/00_GTT_DDL_DMF0003.sql   (기존 GTT; ⚠ 별도 GTT 리네임 패키지 DMF0003_GTT_RENAME_20260723 선행분과 정합)
2) sp/PKG_DMF0003_SPEC.sql     (멤버 23; 파라미터 DEFAULT는 멤버 헤더에서 추출해 spec=body 정합)
3) sp/PKG_DMF0003_BODY.sql
4) sql/01_wiring_API_PROC_M.sql  (15 API→PKG + PROC_M)
5) sql/02_drop_standalone.sql    (⚠ 4 검증 후 — 23 DROP)
```

## 검증 (사내 OCGSCMD_P01, 2026-07-23 적용 완료)
- PACKAGE/BODY VALID, errors 0, 멤버 23.
- MNU_ID=DMF0003 버튼 전부 PKG한정명 도달(car/psi/prPopup/title/custDemand/psiLogic/compare/DELETE 포함), 잔존 standalone 참조 0.
- PROC_M ↔ ALL_ARGUMENTS positional 일치(15건 전부 OK).
- twin refresh 8건: PKG twin↔standalone 본문 DIFFER 확인 → live(standalone) 본문으로 최신화(무수정 헤더치환).
- AN_LOGIC: INVALID→재컴파일 VALID 후 멤버화.
- standalone 23 DROP(참조0: API/외부의존/CMBO 0), 고아 PROC_M 정리.

## 잔여
- 로컬 FE 화면 서브탭(CAR/PSI/PR/Compare) 진입 조회/저장 실동작 확인 권장(DB단 전부 통과).
