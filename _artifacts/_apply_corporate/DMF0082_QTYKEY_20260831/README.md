# DMF0082_QTYKEY_20260831 — 조회 옵션 "Qty ≥ 0" 무효 정정 (사내 적용 완료)

- **원장**: REQ:CHAT-20260831-13 / 마커 `[E20260831-QTYKEY]`
- **증상** (통합테스트 40, 사용자 실측): 전체 조회 7,668건 → Qty ≥ 0 체크 시에도 7,668건 (AS-IS 는 2,136건)
- **원인**: `P_DMF0082_GET_MAIN_DATA` 의 구 구현 = 셀 단위 `DELETE ... WHERE QTY = 0` — 키의 타 메저 행이 남아 그리드 행 미감소 (**사내 재현**: minyonglee1 720=720). AS-IS 정본(DMF0082_GET_MAIN_DATA L5890~) = **9축 키 단위** `MEASURE IN ('MKT_FCST','SCM_FCST') HAVING SUM(QTY) <> 0` NOT EXISTS 필터. 같은 PKG 의 `P_DMF0082_GET_MAIN_DATA_CURRENT`(L8987~)에는 올바른 변환이 있었고 GET_MAIN_DATA 만 단순화된 변환 결함.
- **정정**: 구 블록 → 이설 주석, 신 9축 키 필터를 조회조건 필터·중복 제거 이후([E20260826-CUSTSUBORPH] 직전)에 삽입 — AS-IS(전 필터 완료 후 최종 단계) 위치 파리티 + 모행 잘린 CUST 종속 메저는 기존 안전망이 제거.
- **검증** (2026-08-31): VALID·컴파일 에러 0 / gyucheol_lee 40 기본조건 **7,726→2,183** (테스터 7,668→2,136 과 원장 변동분 수준 일치) / minyonglee1 **720→718** (해당 계정 메저셋 기준 0-합 키 2건 — 데이터 의존 정상)
- **파일**: `00_PRE_PKG_DMF0082_BODY.sql`(원복용 사전본) / `01_POST_PKG_DMF0082_BODY.sql`(적용본)
- **클라우드**: `_deploy_packages/DMF0082_DBFIX_CLOUD_20260831/A_DB/02_PKG_DMF0082_BODY.sql` 재덤프 동봉 (VERIFY V#13 게이트 추가)
- **부수 발견 (미지정 — 보고만)**: `P_DMF0082_GET_MAIN_DATA_CURRENT` 직접 호출 시 ORA-00904("GROUP_ID") @9203 — FE 는 이 proc 을 호출하지 않음(SEARCH_CURRENT 배선 사문, FE grep 0건) → 휴면 결함. 지정 시 별도 착수.
