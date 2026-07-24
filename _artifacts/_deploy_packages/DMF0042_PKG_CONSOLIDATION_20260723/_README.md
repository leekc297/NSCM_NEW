# DMF0042 PKG 취합 (standalone → PKG_DMF0042 병합) — 2026-07-23

## AS-IS 정합 조사 결과 (사용자 지시: AS-IS 사용 버전 채택)
발산 3건은 **AS-IS IN 인터페이스를 모두 보존**하고 OUT 커서 수만 상이 → AS-IS(=현재 버튼이 호출하는 live) 버전 채택.

| SP | AS-IS(C#/MSSQL IN) | 채택 |
|---|---|---|
| SAVE_DM_PLN_BP_FCST | SAVE 21 IN | PKG 멤버(21IN+1커서) 유지, standalone(+10커서 dev본) 삭제 |
| PRICE_CONV | SET_PRICE 2 IN(s_flag/s_division_id) | **오버로드**: SET_PRICE용 4인자(AS-IS standalone) 멤버 추가 + 내부 P_SAVE용 5인자 멤버 유지 (인자수로 해소) |
| REPLACE_BY_CUTOFF | REPLACE 6 IN | 버튼 결과셋(2커서) 보존 위해 멤버를 standalone(2커서)본으로 최신화 |

나머지 6 GET + EXCHANGE_RATE: PKG twin이 standalone과 미세 상이 → live(standalone) 본문으로 멤버 최신화. BUSINESS_PLAN_DATA·FCST_CUTOFF: 신규 멤버.

## 최종 PKG_DMF0042 멤버 (12 + PRICE_CONV 오버로드 1 = 13 프로시저)
GET_DM_MDF_VERSION / GET_DM_PLN_BP_CUTOFF_VERSION / GET_DM_PLN_BUSINESS_PLAN_DATA / GET_EXCHANGE_PRICE / GET_SCM_MST_FUTURE_PRICE_POPUP(+_DATA) / GET_SPREAD_TITLE / SAVE_DM_BP_EXCHANGE_RATE / SAVE_DM_PLN_BP_FCST(22) / SAVE_DM_PLN_BP_FCST_CUTOFF / SAVE_DM_PLN_BP_FCST_PRICE_CONV(4+5 오버로드) / SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF. standalone 12개 전부 삭제.

## 파일 / 적용 순서 (클라우드)
```
1) sp/00_GTT_DDL_DMF0042.sql
2) sp/PKG_DMF0042_SPEC.sql   (멤버 12 + PRICE_CONV 오버로드)
3) sp/PKG_DMF0042_BODY.sql   (본문 무수정 이관)
4) sql/01_wiring_API_PROC_M.sql   (11 API→PKG + PROC_M; SET_PRICE=4인자 오버로드)
5) sql/02_drop_standalone.sql     (⚠ 4 검증 후 — 12 DROP)
```

## 검증 (사내 OCGSCMD_P01, 2026-07-23 적용 완료)
- PACKAGE/BODY VALID, errors 0, 프로시저 13(오버로드 포함).
- MNU_ID=DMF0042 **18개 버튼 전부 PKG한정명 도달** (SET_PRICE→PRICE_CONV 4인자 오버로드), 잔존 standalone 참조 0.
- PROC_M ↔ ALL_ARGUMENTS 일치(오버로드 PRICE_CONV=4인자 overload와 PROC_M 4 일치 확인).
- 내부 체인 P_SAVE→P_PRICE_CONV(5인자 오버로드) 정합(컴파일 VALID).
- 멤버 본문 = live standalone 무수정(헤더/END만 치환) 또는 기존 PKG 원문 추출.
- standalone 12 DROP(참조0: API/외부의존/CMBO 0), 고아 PROC_M 정리.

## 잔여
- 로컬 FE 화면 진입 조회/저장/SET_PRICE/REPLACE 실동작 1회 확인 권장(DB단 전부 통과).
