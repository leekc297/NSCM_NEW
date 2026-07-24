# DMF0082 PKG 취합 (standalone → PKG_DMF0082 병합) — 2026-07-23

## 배경
DMF0082(FcstNPrice)는 이관·개발 과정에서 **standalone 35개**가 누적됨 — 그중 17개가 INVALID dev 스냅샷(GET_MAIN_DATA_0129/0202/CLAUDE/TEST 등)이고, 진단용 Z_DIAG 3종, 기타 dev 잔재. 화면 배선은 PKG 멤버와 standalone에 혼재. 전량 PKG_DMF0082로 취합.

## 메인 데이터 SP 권위 판정 (핵심)
- **PKG 멤버 P_DMF0082_GET_MAIN_DATA = 최신 fix본** (last_ddl 2026-07-22 14:32, SORT_KEY×7·`999`×2 W/M 파리티 마커, len 183K). 라이브 **SEARCH 버튼이 이미 이 멤버를 사용**.
- standalone `DMF0082_GET_MAIN_DATA` = **fix 이전본** (last_ddl 2026-07-21, `999`×0, len 132K) + 버튼 없는 orphan API `DMF0082_GET`에만 배선 → 폐기.
→ PKG 멤버 유지, standalone + orphan API 정리.

## 4버킷 처리 결과 (standalone 35 전량 삭제)
- **B2 병합 7 (신규 멤버)** — standalone이 live 버튼: EXCEL_UPLOAD(UPLOAD/UPLOAD_SAVE), GET_EXCEL_UPLOAD_DATA(UPLOAD_DATA), GET_MAIN_DATA_CURRENT(SEARCH_CURRENT), GET_SPREAD_TITLE(spreadTitle), POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP(savePriceData), POPUP_GET_SPREAD_TITLE_SAVE_PRICE(savePriceTitle), SAVE_MAIN_DATA(SAVE)
- **B2 재배선만 1** — twin 본문 EQUAL 기존멤버: POPUP_GET_FUTUREPRICE_INFO → API를 기존 P_ 멤버로 repoint 후 standalone 삭제
- **B3 삭제 27** (전건 API/CMBO/의존 참조0):
  - INVALID dev 스냅샷 14 + 진단 Z_DMF0082_DIAG/2/3 = 17
  - VALID 잔재: GET_MAIN_DATA(stale, +orphan API `DMF0082_GET`), 0202_KIMCD, CHOYI, GET_SPREAD_TITLE_TEMP(+PROC_M 5행), POPUP_GET_SPREAD_TITLE_DATE, TEST, P_DMF0082_GET_MAIN_DATA(멤버명 동일 standalone 잔재)
  - PKG 그림자 3 (멤버 본문 EQUAL 유지, standalone만 삭제): POPUP_GET_MEASURE_COUNTINFO, _SAVE_PRICE, POPUP_GET_WEEKDATA
- **B4 보류**: futurePriceInfo IF(PR_SCM_MST_EXCHANGE_RATE_UI 공통 환율), titleSet(SCM0002/DMF0002 공통), version(DMF0073) — 타-UI/공통 SP, 손대지 않음.

**처리 후 PKG_DMF0082 = 멤버 12** (기존 5 + 신규 7). standalone 35개 전부 삭제. 내부 호출 체인·교차 PKG 영향 없음.

## 파일 / 적용 순서 (클라우드)
```
1) sp/00_GTT_DDL_DMF0082.sql       (의존 GTT 56종 자급 — 미존재 시)
2) sp/PKG_DMF0082_SPEC.sql         (멤버 12)
3) sp/PKG_DMF0082_BODY.sql         (본문 무수정 이관)
4) sql/01_wiring_API_PROC_M.sql    (9 API→PKG + orphan API 정리 + PROC_M 76행)
5) sql/02_drop_standalone.sql      (⚠ 4 검증 후 — 35 DROP + 고아 PROC_M)
```

## 검증 (사내 OCGSCMD_P01, 2026-07-23 적용 완료)
- PKG_DMF0082 PACKAGE/BODY VALID, errors 0, 멤버 12.
- MNU_ID=DMF0082 **소유 버튼 11개 전부 PKG한정명 도달** (SEARCH/SEARCH_CURRENT/SAVE/UPLOAD/UPLOAD_SAVE/UPLOAD_DATA/spreadTitle/savePriceData/savePriceTitle/futurePriceInfo). 잔존 4건은 B4 공통·타-UI(정상 제외).
- 메인 GET: PKG 멤버가 07-22 fix본(SORT_KEY 999 파리티) 실측 확인 → 권위. stale standalone + orphan API 정리.
- twin 그림자 3종 본문 EQUAL 실측 → 삭제 무영향.
- standalone 35 DROP(참조0: API/외부의존/CMBO 0), 고아 PROC_M 9종 + orphan 17행 정리.

## 잔여
- 로컬 FE 화면 실동작 권장: FcstNPrice 조회(SEARCH/SEARCH_CURRENT)/저장/엑셀업로드 2-Step, futurePrice·savePrice 팝업. DB단 전부 통과.
