# DMF0082_DBFIX_CLOUD_20260831 — 통합테스트 DB 보완 4건 (마커 E20260831-DBFIX4)

> 원천: 보완요청 원장 `REQ:CHAT-20260831-8 / -9 / -12 / -13` (2026-08-31 사용자 지정 — "전체 클라우드 배포 후 오류").
> 구성 원칙: **적용해야만 하는 DB 내용만** (사용자 지시 2026-08-31). SPEC 3본·PKG_DMF0000·GTT DDL 은 기존 클라우드 패키지와 동일/기이관이라 제외 (아래 제외표).

## 대상 결함 × 원인 × 동봉물

| REQ | 증상 (클라우드, div 40) | 원인 (실측) | 동봉 파일 |
|---|---|---|---|
| -8 | Exchange Rate 팝업 저장 시 SQL Error — 재조회하면 저장돼 있음 | `PKG_DMF0020.P_..._CONVERSION` 도입부 `ALTER SESSION ENABLE PARALLEL DML` 이 트랜잭션 중 내부호출에서 **ORA-12841** (사내 로그 08-13 15:47 실측: BACKTRACE 4351행 → PKG_DMF0000 1073행). CONVERSION STEP1 COMMIT 이 환율 MERGE 를 먼저 확정하므로 "저장은 됨". 사내는 08-13 가드 적용 완료·08-18 정상 실행(END) — **클라우드 구본 회귀** | `01` (12841 허용 가드 포함 BODY — DMF0020_CLOUD_20260824 와 동일 본문, 클라우드 세대는 PRECHECK [B] 로 판정) |
| -9 | BPS I/F 버튼 동작 안 함 | 래퍼 `PR_SCM_MST_EXCHANGE_RATE_UI` 가 **어느 클라우드 패키지에도 CREATE 미동봉** (0818 패키지는 GRANT/시노님만). + base `PR_SCM_MST_EXCHANGE_RATE` 는 08-24 REPOINT(PKG 멤버 호출) 본문 미이관 | `03`(base REPOINT 본문) + `04`(래퍼) + `05`(GRANT SCMP_APP/시노님/API_M/PROC_M/BTN/권한 — NOT EXISTS 멱등) |
| -12 | MKT FCST 수량 입력 시 Unit Price 필수 Validation 없이 저장 (★★★) | SAVE V#10(52주 판가 게이트)은 룩업 `MKT_FCST_VALIDATION_PRICE` 에 의존 — **룩업 부재 시 본문이 최신이어도 조용히 무력화**. 사내 룩업 11행 + V#10 실존·양성 실측 | `02`(BODY — V#10 + E20260814-FCSTNAME/E20260820-SENTINELDDL 정정 포함) + `06`(룩업 11행 INSERT NOT EXISTS + VALID_YN 보정) |
| -13 | QTY ≥ 0 (조회 옵션) 동작 안 함 — 체크해도 7,668건 그대로 | ⭐ **원인 확정 재판정 (2026-08-31 사용자 실측 제보로 축 정정)**: 지정 항목의 실체 = 조회조건 "Qty ≥ 0" 체크박스. GET_MAIN_DATA 의 구 구현이 **셀 단위 `DELETE WHERE QTY=0`** 이라 키의 타 메저 행이 남아 필터 무효 — **사내에서도 재현**(720=720). AS-IS 정본(L5890~) = **9축 키 단위** MKT_FCST/SCM_FCST SUM(QTY)<>0 필터. 같은 PKG 의 `_CURRENT` 에는 올바른 변환이 있었고 GET_MAIN_DATA 만 단순화된 결함. 정정 = [E20260831-QTYKEY] (사내 적용·검증 완료: gyucheol_lee **7,726→2,183** ≒ 테스터 7,668→2,136 / minyonglee1 720→718) | `02`(BODY — QTYKEY 포함 재덤프) — 판정 VERIFY V2 의 V#13 게이트 |

## 적용 순서

```
0) 00_CLOUD_PRECHECK.sql   -- read-only. [B] 가드/마커=0 인 것만이 실제 회귀. [C] 로 -8 실오류(SQLERRM) 확보 → 판정 확정
                           -- [D]/[F] MISSING 있으면 적용 중단·보고 (선행 패키지 미적용 상태)
1) A_DB/01_PKG_DMF0020_BODY.sql            -- SCM_MGR 로
2) A_DB/02_PKG_DMF0082_BODY.sql
3) A_DB/03_PR_SCM_MST_EXCHANGE_RATE.sql
4) A_DB/04_PR_SCM_MST_EXCHANGE_RATE_UI.sql
5) A_DB/05_BPSIF_WIRING.sql                -- 시노님 2문은 권한 부족 시 DBA 세션
6) A_DB/06_LOOKUP_VALIDATION_PRICE.sql
7) A_DB/90_VERIFY.sql                      -- 전 게이트 PASS 의무 (V6 = GTT 모의행 양성 테스트)
```

## 제외 (동일/기이관 — 재취합 불요 근거)

| 제외물 | 근거 (실측) |
|---|---|
| PKG_DMF0000 SPEC/BODY | 사내 라이브 == `DMF0082_EXCHANGE_SAVE_20260724_1241/sp/02_PKG_DMF0000_BODY.sql` (delta = 종결자 `/` 뿐) |
| PKG_DMF0020 SPEC | == `DMF0020_CLOUD_20260824/A_DB/01` 동일 |
| PKG_DMF0082 SPEC | == `DMF0082_CLOUD_20260823_FULL/A_DB/01` 동일 |
| GTT/SEQ DDL | 기존 패키지 기이관 — PRECHECK [F] 존재 판정으로 대체 (MISSING 시 해당 선행 패키지 적용) |

## 화면 확인 시나리오 (적용 후 — 사용자 실측 축)

1. **-8**: 환율 팝업 → 기존 행 수정 → Save → 오류 팝업 없이 토스트 + 재조회 값 유지
2. **-9**: 환율 팝업(ADMIN/DM ADMIN) → [BPS I/F] → success/fail 알림 + 재조회
3. **-12**: 40 신규 행 MKT_FCST 수량만 입력(판가 미입력) → Save → "Unit Price Not Found !" 차단
4. **-13**: 40 비RMA 행 수량 음수 입력 → Save → "정수값만 입력가능합니다 !" 차단 / RMA 행 양수 → "반품수량(RMA)은 음수값만" 차단

## 재적재 검증 (2026-08-31 — 사용자가 클라우드 적용 최신 BODY DDL 을 사내에 직접 실행)

- 사내 BODY 재적재 확정: TIMESTAMP **2026-08-31 10:45:52** (구 08-24 23:04 → 갱신)
- 보완 생존 판정 **전 축 PASS**: 12841 가드 1 / E20260824-GTTDEL 8 / PKGCONSOL 2 / CONVERSION·통합 4본 실존 — **회귀 없음**
- 재적재본(=클라우드 최신)이 구 스냅샷 대비 앞선 것: `P_DMF0020_GET_SCM_MST_FUTURE_PRICE` 의 `P_VERSION_TYPE` → `UPPER(P_VERSION_TYPE)` **5곳** (대소문자 무시 정정 — 조회 SP, 본 4건과 무충돌)
- `01_PKG_DMF0020_BODY.sql` 을 재적재본 기준으로 **재덤프 완료** (delta 실측 = `_survey/delta_PKG_DMF0020_BODY.diff`, 0824 패키지 대비 14줄 = UPPER 5쌍+헤더)
- ⭐ 이 본문의 원천이 **클라우드 적용본**이므로, 클라우드에서 PRECHECK [B] 가드=1 이면 `01` 재적용은 불필요
- **-8 런타임 재현 검증 PASS ×2** (구본 09:5x·재적재본 10:5x): 활성 트랜잭션(LOCAL_TRANSACTION_ID NOT NULL) 상태에서 `CONVERSION('40')` 직접 호출 → ORA-12841 미발생, 결과커서 CODE='0'/EVENT=393696 (08-13 사고 조건 재현으로 가드 작동 실증)

## 사내 실측 요약 (2026-08-31)

- PKG_DMF0000/PKG_DMF0020/PKG_DMF0082/base/래퍼 5객체 = **VALID** (PKG_DMF0000 BODY·래퍼는 의존성 무효화 상태였음 → 재컴파일 0 에러, 본문 이상 없음)
- -13 GTT 모의행 양성 테스트: V11=1·V12=1 PASS / -12 룩업 arm 4행(MEASURE)+7행(FCST_TYPE)
- delta 실측: `_survey/delta_*.diff` (PKG_DMF0082 = 직전 0826_PENDING 대비 46줄 — 08-27 이후 정정 포함 최신본)
