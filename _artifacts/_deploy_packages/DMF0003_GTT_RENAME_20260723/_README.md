# DMF0003 GTT 리네임 이관 패키지 (2026-07-23)

## 배경 — 클라우드 GT TEMP DROP 실패(ORA-14452) 대응

클라우드에서 DMF0003 GTT 정밀도 교정(00A REBUILD) 시 **공용 명칭 GTT 가 타 세션 사용 중이면 DROP 불가(ORA-14452)** → 재생성 중단.
`GT_GGET_*` / `GT_MFCP_` / `GT_SAVEPK_` 는 이름이 화면 비종속(공용)이라 DROP 타이밍을 잡기 어렵다.

**해결 (사용자 지시)**: 이 GTT 들을 **명칭에 DMF0003 을 넣어 신규 생성**하고, SP(PKG_DMF0003) 사용부도 신명칭으로 전환한다.
→ DROP 이 필요 없어짐(신명칭은 신규 CREATE, 멱등 -955 skip). 구 GTT 는 그대로 두어도 무방(타 화면 GT_GGET_* 공유분과 충돌 없음).

## 리네임 맵 (40 GTT, 전역 prefix 치환)

| 구명 prefix | 신명 prefix | 건수 |
|---|---|---|
| `GT_GGET_` | `GT_DMF0003_` | 37 |
| `GT_MFCP_` | `GT_DMF0003_MFCP_` | 1 |
| `GT_SAVEPK_` | `GT_DMF0003_SAVEPK_` | 2 |

> ⚠️ `GT_GGET_SPLIT_*` 는 **PKG_DMF0005 도 공유**하므로 구명(GT_GGET_SPLIT_*)이 계속 존재해야 한다.
> 본 리네임은 PKG_DMF0003 body 내 참조만 신명칭으로 바꾸며, 신명칭 GTT를 **추가 생성**하는 것이라 GT_GGET_SPLIT_* 구 테이블은 유지된다(양립).

## 파일 / 적용 순서

### ⭐ 클라우드 권장 — 00C 단일 파일 (자가치유, 2026-07-23 보강)

클라우드는 **00A REBUILD(DROP 스크립트)가 GT_GGET_CAL_MONTH_END 사용중(ORA-14452)에서 중단**되어,
그 이전에 드롭된 **비(非)리네임 GTT(GT_CREF_*/GT_FSPS_*/GT_DMF3_* 등)가 미복구** 상태가 되었다.
또한 구버전 00B 로 만든 **GT_DMF0003_* 가 잘못된 스키마**로 존재(ORA-00904 QTY/YYYYMMDD/MEASURE)한다.
→ 이 둘을 한 파일로 해결하는 것이 `00C`.

```
[BE(WAS) 정지]  ← PART B 의 DROP 이 ORA-14452 안 나려면 필수 (모든 세션이 GTT 미사용 상태)
Step 1: sp/00C_GTT_CLOUD_FULL_DMF0003.sql   (PART A: 비리네임 12종 복구 -955 skip / PART B: 리네임 39종 DROP후 CREATE = 스키마 교정)
Step 2: sp/02_PKG_DMF0003_BODY.sql          (body 신명칭 전환, 마커 [DMF0003 GTT RENAME 20260723])
Step 3: sql/03_VERIFY.sql                    (PACKAGE/BODY VALID, errors 0, 구명 실참조 0)
[BE(WAS) 기동]
```

- 00C 의 모든 DDL = **사내 라이브 GET_DDL 덤프**(권위 스키마) → 컬럼 파리티 보장(ORA-00904 재발 차단).
- PART B DROP 은 ORA-14452(사용중) 시 **"BE 재기동 후 본 파일부터 재실행"** 로 즉시 중단 → 반드시 BE 정지 후 실행.
- PART A(비리네임)는 삭제하지 않고 CREATE(-955 skip)만 → 사용중이어도 안전.

### (참고) 신규/정상 환경 — 00B 단독

클라우드에 GT_DMF0003_* 가 **아예 없거나 이미 올바른 스키마**면, DROP 불필요하므로 00B(-955 skip)만으로 충분:
```
Step 1: sp/00B_GTT_DDL_DMF0003_RENAMED.sql   (GT_DMF0003_* 40종 생성, 멱등 -955 skip, DROP 없음)
        + 비리네임 GTT 가 드롭된 상태라면 원본 sp/00_GTT_DDL_DMF0003.sql 도 재실행(복구)
Step 2: sp/02_PKG_DMF0003_BODY.sql
Step 3: sql/03_VERIFY.sql
```

- 구 `00A_GTT_REBUILD_DMF0003.sql`(DROP 방식) 은 **본 패키지로 대체 — 실행 금지**(중단 사고 원인).

## ⚠ ORA-00942 / ORA-00904 컴파일 오류 원인 (클라우드 실측)

body(02) 를 GTT 준비 없이 실행하면 아래가 발생 — **리네임 자체 문제가 아니라 GTT 부재/스키마 불일치**:

| 오류 | 대상 예 | 원인 | 해소 |
|---|---|---|---|
| ORA-00942 (테이블 없음) | GT_CREF_TEMP_DATA, GT_FSPS_T_PRICE, GT_FSPS_SALES_PLAN_TEMP_LOC | 00A REBUILD 가 드롭 후 미복구 (비리네임) | 00C PART A |
| ORA-00904 (QTY/YYYYMMDD/MEASURE 부적합) | GT_DMF0003_VMI_INV 등 | 구버전 00B(잘못된 스키마)로 생성됨 | 00C PART B (DROP후 CREATE) |

## 검증 결과 (사내 OCGSCMD_P01, 2026-07-23 적용 완료)

- 컴파일: PACKAGE / PACKAGE BODY 모두 VALID, errors 0, 마커 1, 구명(GT_GGET_/MFCP/SAVEPK) 실참조 0
- 회귀: `P_DMF0003_GET_MKT_FCST_DATA` 40(539행)·81(555행) — O_RC1~O_RESULT 4커서 **행수·SHA-256 리네임 전후 완전 일치** + O_RC1 전행 dump 바이트 diff 0
- 신명칭 GTT: `GT_DMF0003_*` 40종 생성 확인

## 참고 — 별개 이슈: ORA-00918 (MEASURE ambiguously specified)

클라우드 DMF0003 조회 시 보고된 `ORA-20001 ... SQLCODE=-918 / ORA-00918: MEASURE column ambiguously specified` (PKG line 9247, OPEN O_RC1 FOR V_SQL_TEXT) 는
**본 GTT 리네임과 무관한 별도 메타 이슈**다. 동적 PIVOT 의 SELECT 컬럼 목록(V_COLUMN)이
titleset(사용자컬럼) ∩ SHEET_COLUMNS(고정컬럼) 겹침으로 MEASURE 가 2회 들어가 발생.
→ 진단/정정 SQL 별도 제공(titleset user 'C' ∩ SHEET_COLUMNS DEFAULT_FLAG '-'/공백 교집합 DELETE + SHEET_COLUMNS DEFAULT_FLAG 사내 대조).
GTT 리네임 배포와 독립적으로 적용 가능.
