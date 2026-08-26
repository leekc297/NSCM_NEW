# DMF0074 — Excel Form ORA-01861 정정 (E20260825-DATECONV, 2026-08-25)

## 원인 (진단 v2/v3 실측으로 확정)
클라우드 "다운로드할 템플릿 대상 데이터가 없습니다" = 데이터 0건이 아니라 **SP 예외를 FE 가 0건으로 오표시**.
- `SCM_SYS_LOG_BATCH`: ORA-01861 at PKG_DMF0074 line 590 (OPEN O_RC1), div 81·40 공통
- 근인 = `FN_NEXT_DAY(A.YYYYMMDD,'MON')` — 함수 파라미터가 **DATE** 인데 VARCHAR2 직접 전달 = 암묵 형변환(세션 NLS_DATE_FORMAT 의존, hook #109)
- NLS 실증: `DD-MON-RR`(클라우드 BE JVM)=ORA-01861 / `RR/MM/DD`(사내)=우연히 통과 — "사내 정상"은 복불복
- 같은 PKG L1022~1026 은 이미 `TO_DATE(...,'YYYYMMDD')` 선행 — 템플릿 proc 3곳만 누락

## 정정
`P_DMF0074_GET_METAL_LINK_TEMPLATE` L601·605·606: `FN_NEXT_DAY(TO_DATE(A.YYYYMMDD,'YYYYMMDD'),'MON')` 로 명시 변환 선행.

## 클라우드 적용 (이 순서대로)
1. `02_PKG_DMF0074_BODY.sql` — BODY 전체 교체 (사내 적용본과 동일, 마커 3)
2. `90_VERIFY.sql` — 마커 3·VALID + **DD-MON-RR 세션 SP 실호출 CODE=0** 확인
3. 화면에서 Excel Form(81/Current) 조회 재시도 — 데이터 표시 확인 (클라우드 원장 8,346행 보유 실측)

## 사내 검증 (2026-08-25 완료)
- 컴파일 VALID·마커 3
- 클라우드 조건 재현 세션(DD-MON-RR/AMERICAN)에서 SP 실호출: div 40 = 191행 + CODE=0 / div 81 = CODE=0 (0행은 사내 dev 원장 미적재 탓 — 클라우드는 8,346행 보유라 데이터 표시될 것)
- `BACKUP_PKG_DMF0074_20260825_170609.sql` = 적용 직전 원본 (실행하면 원복)

## RULE (사용자 지시 — 등재 완료)
hook #109 `oracle-nls-implicit-conversion.md` **§5 신설**: DATE 파라미터 함수 호출 = 명시 TO_DATE 선행 의무 +
전수 스캔 게이트 + 클라우드 조건(DD-MON-RR) 세션 검증 의무. 잔여 동일 패턴 인벤토리:
PKG_DMF0022(7)·PKG_DMF0048(6)·**PKG_DMF0020(3 — DMF0074 형제, 동일 CTE)**·PKG_DMF0044(1) — 소급 대기.

## 추가 (2026-08-25 2차) — E20260825-DASHRM
템플릿 데이터 영역 '-' placeholder **44곳 제거 → 빈값** (사용자 지시):
PLAN_YYYYMM·ENERGY + APPLY_PRICE_TYPE_CODE1~7·FROM_PERIOD1~7·TO_PERIOD1~7·CONTRACT_UNIT1~7·METAL_APPLY1~7·METAL_REQR1~7.
사내 실측: 컴파일 VALID·div40 191행 CODE=0·'-' 잔존 0곳·FE 다운로드 치환 로직은 no-op 로 무해.
`02_PKG_DMF0074_BODY.sql` 는 **DATECONV+DASHRM 누적본** — 클라우드는 이 파일 하나로 두 정정 모두 반영.
원복: `BACKUP_PKG_DMF0074_pre_dashrm.sql`(DASHRM 직전) / `BACKUP_PKG_DMF0074_20260825_170609.sql`(전체 원본).
