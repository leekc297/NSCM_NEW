# DMF0020 Sales Price 조회 — 기간 컬럼을 Period 전체 구간으로 (클라우드 이관 · DB 패치 + BE 2개 파일)

> 화면에 Period 전체가 나오려면 **두 가지가 다 필요하다.** DB 패치만으로는 화면이 바뀌지 않는다 (클라우드 QA 10-13 실측).

| | 무엇 | 왜 | 상태 |
|---|---|---|---|
| (가) DB | `PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE` 가 기간 컬럼을 **달력 전체 구간**으로 내려준다 — 마커 `[E20261013-DMF0020PERIODCOLS]` | 종전에는 조회된 데이터의 날짜로만 컬럼을 만들었다 | 사내 적용 · **클라우드 QA 적용됨**(10:48:47, 01_DIAG 회신으로 확인) · 클라우드 DEV 미확인 |
| (나) BE | 값이 NULL 인 컬럼도 응답에 담는다 — `mybatis-config.xml` `callSettersOnNulls=true` + `CustomMap.put` null 가드 | BE 는 이 설정이 꺼져 있으면 NULL 컬럼을 응답 행에서 뺀다. 화면은 응답 행의 키로 기간 컬럼을 만들므로, 값이 전부 빈 구간은 컬럼째 사라진다 | 로컬 작업 트리 수정 · **빌드·기동 미확인** · 클라우드 미배포 |

## 클라우드 QA 에서 확인된 것 (2026-10-13 11:01, Sales Site `AJ상사_AB_TES`, 20261001~20270430)
- SP 는 주차 컬럼 41개 · 월 7개를 내려준다 (달력 대비 빠진 구간 0) — (가) 는 됐다.
- 판가가 있는 날짜는 11개: 10/12 · 10/13 · 10/15 · 10/19 · 10/20 · 10/22 · 10/26 · 10/27 · 10/29 · 11/01 · 11/02.
- 화면은 그중 **월요일이거나 1일**인 날짜만 주차 컬럼으로 쓴다 → 10/12 · 10/19 · 10/26 · 11/01 · 11/02 = **5개**. 보고된 "5개 주차"와 일치.
- 나머지 주차 컬럼은 값이 전부 NULL 이라 BE 가 응답에서 뺐다 — (나) 가 안 돼 있다.

## (나) BE — 고칠 곳 2곳 (C_BE)
같은 수정이 2026-06-01 에 들어갔다가(DMF0043 때) 2026-08-05 커밋에서 둘 다 빠졌다. 주석을 뺀 코드는 6월 적용본과 동일하다.

| 파일 | 수정 |
|---|---|
| [mybatis-config.xml](C_BE/nscm-be/src/main/resources/mybatis/mybatis-config.xml) | `<setting name="callSettersOnNulls" value="true"/>` 를 **주석 블록 밖으로** 꺼낸다 (지금은 `<!-- … -->` 안에 있어 꺼져 있다) |
| [CustomMap.java](C_BE/nscm-be/src/main/java/com/lgcns/nscm/framework/model/CustomMap.java) | `put` 맨 앞에 `if (value == null) return super.put(key, null);` |

- **두 파일은 반드시 함께 나가야 한다.** 설정만 켜면 `CustomMap.put` 의 `value.getClass()` 가 NULL 값에서 NPE 를 내 **모든 조회가 실패한다**.
- C_BE 의 파일로 **통째로 덮어쓰지 말 것.** `mybatis-config.xml` 에는 로컬 전용 주석·BOM 등 다른 차이가 섞여 있다. 공통소스 원본에 위 두 줄 수정만 옮긴다.
- 영향 범위는 **전 화면**이다 (조회 커서 결과가 전부 `CustomMap` 을 탄다).
  - 응답에 `"컬럼": null` 이 실린다 → 응답 크기가 커진다 (NULL 이 많은 대량 조회일수록).
  - 화면 코드가 "키가 없음"과 "값이 null"을 다르게 다루는 곳이 있으면 동작이 달라질 수 있다. 전수 점검은 하지 않았다.
  - 참고: 이 조합은 6/1~8/5 두 달간 이 저장소에서 켜진 채로 쓰였다.
- BE 재빌드·재기동 필요. 빌드와 기동은 여기서 확인하지 못했다.

## (가) DB — 실행 순서 (SCM_MGR, 각 파일 전체 F5, 값 입력 없음)
클라우드 QA 는 이미 적용돼 있어 재실행해도 `SKIP` 이다. 클라우드 DEV 는 아래 순서로.

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK.sql](A_DB/00_PRECHECK.sql) | L1 `미적용 → 10_APPLY 실행 대상` · L2 앵커 `N=1 PASS` · L3 달력 `PASS` · L4 실행 중 세션 없음 |
| 2 | [A_DB/10_APPLY_PERIODCOLS_PATCH.sql](A_DB/10_APPLY_PERIODCOLS_PATCH.sql) | `APPLIED — PKG_DMF0020 BODY VALID · 마커 1곳` (이미 적용이면 `SKIP`, 앵커 ≠1 이면 중단·원문 무변경) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 PASS · V2 VALID/오류 0 · V3 `SP PASS …` |

현상 점검: [A_DB/01_DIAG_SITE_PERIOD_COLS.sql](A_DB/01_DIAG_SITE_PERIOD_COLS.sql) (조회 전용, Sales Site `AJ상사_AB_TES` 고정).
D6 의 **값이 전부 빈 컬럼** 수 = BE 배포 전까지 화면에서 빠지는 컬럼 수. BE 배포 뒤에도 이 숫자는 그대로다 — DB 에서는 BE 설정을 볼 수 없으므로, 배포 뒤 확인은 화면에서 한다.

롤백: [A_DB/99_ROLLBACK_PERIODCOLS_PATCH.sql](A_DB/99_ROLLBACK_PERIODCOLS_PATCH.sql).

## 배포 뒤 화면 확인
Sales Price 에서 Sales Site `AJ상사_AB_TES` · 기간 2026-10 ~ 2027-04 조회 → 주차 컬럼이 10/01 주부터 2027/04/26 주까지 전부 나오고, 판가가 없는 칸은 빈칸이다.
(10/13 · 10/15 처럼 월요일도 1일도 아닌 날짜의 판가는 종전처럼 화면 주차 컬럼에 나오지 않는다 — 화면 규칙이며 이번 범위 밖.)

## 남는 한계
- 조회 결과가 **0행**이면 화면에 기간 컬럼이 없다 (화면이 행에서 컬럼을 읽는다). 해결하려면 FE 가 달력 SP(`P_DMF0020_GET_SPREAD_TITLE_DATE`, 배선 `main / SPREAD_TITLE_DATE` 기등록)로 컬럼을 만들어야 한다.
- Price Batch Input 팝업 조회(`…_SAVE_PRICE_POPUP`)는 같은 구조이나 손대지 않았다.
- 채택하지 않은 안: SP 가 빈 칸을 0 으로 채워 내려주기 — FE·BE 무변경으로 되지만 빈 칸이 전부 `0.000` 으로 보인다 (사용자 결정 10-13: BE 일괄 수정).

## 사내 검증 (ZIOUI1 59.19.252.148, 2026-10-13)
- DB: [_rehearsal_apply.out.txt](_rehearsal_apply.out.txt) (00 → 10 SKIP → 90 → 00) · [_equiv_before_after.out.txt](_equiv_before_after.out.txt) 전/후 10케이스 PASS (행·기존 값 동일, 추가 컬럼 전부 NULL, 달력 구간 전부 포함).
- 점검 SQL: [_rehearsal_diag.out.txt](_rehearsal_diag.out.txt) — 사내에 없는 사이트라 `LGCOC2_KR_OCH` 로 이름만 바꿔 실행. 원문 그대로는 `D6 SKIP`.
- 사내 DB 최종 상태 = 적용됨 (LAST_DDL 2026-10-13 10:57:08).
- BE: **미검증** (로컬 BE 미기동 — 빌드·기동·화면 모두 확인하지 못했다).

## 작업 ↔ 파일 대조
| 한 일 | 파일 |
|---|---|
| 사내 PKG_DMF0020 BODY 루프 1문장 교체 | A_DB/10_APPLY_PERIODCOLS_PATCH.sql |
| 로컬 BE 2개 파일 수정 | C_BE/nscm-be/… (위 표) |
| 권한·시노님·메타·데이터 변경 | 없음 |
