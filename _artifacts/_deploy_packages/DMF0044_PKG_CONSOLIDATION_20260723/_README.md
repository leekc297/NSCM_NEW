# DMF0044 PKG 취합 (standalone → PKG_DMF0044 병합) — 2026-07-23

## 배경
DMF0044는 기존 PKG 멤버 17개가 이미 화면에 배선(API→PKG)돼 있었고, standalone 23개는 대부분 그 **그림자(본문 바이트 동일)**였음. 일부 standalone(SPREAD_TITLE / MOBILE 리포트 생성 체인 / 버전복사)은 아직 standalone 배선 또는 타 PKG 내부호출 상태 → 전량 PKG_DMF0044로 취합.

## 4버킷 처리 결과 (standalone 23 전량 삭제)
- **B2 병합 6 (신규 멤버)** — standalone이 live(API→SA 또는 내부호출) → PKG 멤버화 + 배선전환:
  - GET_EXCHANGE_POPUP_SPREAD_TITLE (API DMF0044_exchangeRate_TITLE)
  - GET_SPREAD_TITLE (API DMF0044_spreadTitle_SEARCH)
  - MOBILE_REPORT_CREATE (API DMF0044/DMF0049_unitedVersion_TRANSFER) — **내부호출부 3건(DEPT/PRODUCT/EXCHANGE_RATE CREATE)을 PKG한정명으로 정합**
  - SAVE_SALES_PLAN_VERSION_COPY (API DMF0044/DMF0049_unitedVersion_ACTION)
  - SALES_REPORT_DEPT_CREATE, SALES_REPORT_PRODUCT_CREATE (MOBILE 내부호출 체인, twin無)
- **B3-a PKG 그림자 삭제 17** — 이미 PKG 멤버가 live(API→PKG), standalone은 본문 바이트 동일(END 라벨만 상이) 잉여본 → standalone만 DROP, PKG 멤버 유지:
  GET_MEASURE, GET_SALES_REPORTS_DATA, GET_SALES_VERSION_POPUP, GET_SCM_MST_EXCHANGE_RATE_POPUP(+_DATA), GET_TEXTBOX, SAVE_BIZ_PLAN_VERSION_COPY, SAVE_DM_EXCHANGE_RATE_REPORT, SAVE_SALES_PLAN_REPORT_C(+_CF), SAVE_TEXTBOX, BP_REPORT_DEPT/EXCHANGE_RATE/PRODUCT_CREATE, GET_COPY_VERSION_POPUP, GET_VERSION_POPUP, SALES_REPORT_EXCHANGE_RATE_CREATE
- **B4 보류**: 없음.

**처리 후 PKG_DMF0044 = 멤버 23** (기존 17 유지 + 신규 6). standalone 23개 전부 삭제.

## ⚠️ 교차 배선 (타 UI 영향 — 승인받고 처리)
- **PKG_DMF0049 본문이 `SCM_MGR.DMF0044_MOBILE_REPORT_CREATE(...)`를 직접 호출** → `PKG_DMF0044.P_DMF0044_MOBILE_REPORT_CREATE(...)`로 1줄 정합 후 PKG_DMF0049 재배포(sp/PKG_DMF0049_FULL_fixed.sql). 결정 ②(내부 호출부 PKG한정명 정합) 범위.
- **DMF0049 버튼 2개(unitedVersion ACTION, TRANSFER)**가 DMF0044 standalone을 직접 배선 → PKG_DMF0044 멤버로 재배선.

## 파일 / 적용 순서 (클라우드)
```
1) sp/00_GTT_DDL_DMF0044.sql       (의존 GTT 18종 자급 — 미존재 시)
2) sp/PKG_DMF0044_SPEC.sql         (멤버 23; DEFAULT는 멤버 헤더에서 추출해 spec=body 정합)
3) sp/PKG_DMF0044_BODY.sql         (본문 무수정; MOBILE 내부호출 3건만 PKG한정명)
4) sql/01_wiring_API_PROC_M.sql    (6 API→PKG + PROC_M 24행)
5) sp/PKG_DMF0049_FULL_fixed.sql   (MOBILE 호출 PKG한정 정합 — spec+body 재배포)
6) sql/02_drop_standalone.sql      (⚠ 5까지 완료·검증 후 — 23 DROP + 고아 PROC_M)
```

## 검증 (사내 OCGSCMD_P01, 2026-07-23 적용 완료)
- PKG_DMF0044 PACKAGE/BODY VALID, errors 0, 멤버 23. PKG_DMF0049 PACKAGE/BODY VALID.
- **버튼 28개(DMF0044 23 + DMF0049 5) 전부 PKG한정명 도달**, 잔존 standalone 배선 0.
- PROC_M ↔ ALL_ARGUMENTS positional 일치(병합 4건, 내부 2건은 API 무배선).
- 그림자 17건: PKG 멤버 본문 == standalone 본문 바이트 동일(END 라벨만 상이) 실측 → 삭제 무영향.
- MOBILE 병합본 내부호출 3건 PKG한정 정합, PKG_DMF0049 live 본문 PKG한정 호출 1건 확인, 컴파일 VALID.
- standalone 23 DROP(참조0: API/외부의존/CMBO 0, drop-set 내부·PKG_DMF0044 멤버만), 고아 PROC_M 정리.

## 잔여
- 로컬 FE 화면 실동작 권장: MDF Reports 조회/저장/버전복사(ACTION), unitedVersion TRANSFER(MOBILE 리포트 생성 체인) — DMF0044·DMF0049 양 화면. DB단 전부 통과.
