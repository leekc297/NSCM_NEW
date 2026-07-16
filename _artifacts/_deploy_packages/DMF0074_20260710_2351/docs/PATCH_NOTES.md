# PKG_DMF0074 — SP 변경 4건 라인 단위 명세 (2026-07-10)

> 라인 번호는 **사내 배포본 `ALL_SOURCE` (PACKAGE BODY, 총 3,973행)** 기준.
> `02_PKG_DMF0074_full.sql` 은 아래 4건이 **모두 반영된 상태**의 전문 추출본이다.
> 각 변경은 적용 시 "대상 라인 외 변경 0건" 을 assert 로 강제했고, 적용 전 전체 바디를 백업했다.

---

## 1. L613 — 템플릿 SP 의 MRF 필터 복원

`P_DMF0074_GET_METAL_LINK_TEMPLATE` 의 버전 선택 CTE.

```diff
- --AND    NVL(ATTRIBUTE7, 'N') = 'Y'
+   AND    NVL(ATTRIBUTE7, 'N') = 'Y'
```

**왜**: 업로드 검증(L1102)은 `ATTRIBUTE7='Y'` (MRF) 버전을 강제하는데 템플릿만 필터가 주석 처리되어
서로 **다른 버전**을 참조했다. 그 결과 템플릿이 내려준 모든 행이 `Invalid Sales Plan Waterfall MODEL.` 로 탈락.

**운영 영향 없음**: 운영에서는 매주 최신 SP_W 가 곧 MRF `'Y'` 라 두 선택이 일치한다. 이 수정은 그 일치를 코드로 보장한다.

---

## 2. L3667·3668 / 3684·3685 / 3701·3702 / 3718·3719 / 3735·3736 — D14 조인 NULL 안전화 (10줄)

`GT_DM74_TMP_METAL_LINK_PRICE` INSERT 의 5개 GTT INNER JOIN.

```diff
- AND APPLY_PRICE_TYPE.PROJECT_CODE  = FROM_PERIOD.PROJECT_CODE
- AND APPLY_PRICE_TYPE.PLANT_SITE_ID = FROM_PERIOD.PLANT_SITE_ID
+ AND NVL(APPLY_PRICE_TYPE.PROJECT_CODE,'@#@#@#')  = NVL(FROM_PERIOD.PROJECT_CODE,'@#@#@#')
+ AND NVL(APPLY_PRICE_TYPE.PLANT_SITE_ID,'@#@#@#') = NVL(FROM_PERIOD.PLANT_SITE_ID,'@#@#@#')
```
(FROM_PERIOD / TO_PERIOD / CONTRACT_UNIT / METAL_APPLY / METAL_REQR 5개 조인 × 2컬럼 = 10줄)

**왜**: 소형사업부(40)는 L3012 에서 `PROJECT_CODE = ''` 로 만들고, Oracle 에서 `''` 는 **NULL** 이다.
양쪽이 같은 테이블에서 온 같은 값인데도 `NULL = NULL` 은 거짓이라 INNER JOIN 이 전 행을 버렸다 (`D14=0`).
같은 블록의 `ENERGY` 는 이미 `NVL(...,'@#@#@#')` 을 쓰고 있어 **형식을 일치**시켰다.

**증거**: 배치 로그 `D13=15 → D14=0 → D15=0`. 수정 후 `D14=15 → D15=15`.

---

## 3. L3771 / L3831 / L3901 — `PROJECT_CODE` NOT NULL 대응 (3줄)

```diff
  -- L3771  D15 MERGE ON
- AND A.PROJECT_CODE     = B.PROJECT_CODE
+ AND A.PROJECT_CODE     = NVL(B.PROJECT_CODE,'-')

  -- L3831  D15 MERGE INSERT VALUES
  -- L3901  DM_BPS_METAL_LINK_PRICE_H INSERT SELECT
- ,B.PROJECT_CODE
+ ,NVL(B.PROJECT_CODE,'-')
```

**왜**: `DM_BPS_METAL_LINK_PRICE.PROJECT_CODE` / `_H.PROJECT_CODE` 는 **NOT NULL**.
MSSQL 은 `''` 로 통과했지만 Oracle 은 `ORA-01400`. `'-'` 는 같은 INSERT 의 `DEPT_ID` 가
이미 쓰던 placeholder(L3903 `'-'`, 주석 "공백저장")와 동일한 관례.

**MERGE ON 도 함께 바꾼 이유**: 저장된 `'-'` 와 GTT 의 NULL 이 매칭되지 않으면 재업로드마다
`WHEN NOT MATCHED` 로 빠져 **중복 INSERT** 가 쌓인다.

**조회 안전성**: 메인 조회는 div 40 에서 `PROJECT_CODE` 가 아니라 `END_CUSTOMER` 로 마스터를 조인하므로
`'-'` 저장이 조회를 깨지 않는다.

---

## 4. L83 — 조회 SP 버전 분기 대소문자

```diff
- IF P_VERSION_TYPE LIKE '%CURRENT%' THEN
+ IF UPPER(P_VERSION_TYPE) LIKE '%CURRENT%' THEN
```

**왜**: FE 는 `versionType="Current"` 를 보내는데 Oracle 은 대소문자를 구분한다.
`'Current' LIKE '%CURRENT%'` = **false** → 항상 ELSE 분기(버전 스냅샷 `DM_BPS_METAL_LINK_PRICE_C`)를 탔고,
그 테이블에는 div 40 행이 0건이라 저장해도 조회되지 않았다. MSSQL 기본 collation 은 대소문자를 구분하지 않는다.

`P_VERSION_TYPE` 사용처 5곳을 전수 확인했고, 분기 조건은 L83 한 곳뿐이다 (L300/302 는 ELSE 분기의 토큰 분해).

**검증**: 수정 후 조회 SP 직접 호출 → `Current` 5행 / `CURRENT` 5행 / `SP_W_...` 0행(스냅샷, 정상).

---

## 5. 기각된 가설 (기록)

`projectCode=''` 가 아래 INNER JOIN 에서 0행을 만들어 조회를 막는다고 의심했으나, **사실이 아니다.**

```sql
INNER JOIN (SELECT '%'||TRIM(REGEXP_SUBSTR(P_PROJECT_CODE,'[^,]+',1,LEVEL))||'%' TST
            FROM DUAL CONNECT BY REGEXP_SUBSTR(P_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL) B1
```

Oracle 의 `CONNECT BY` 는 **레벨 1 행을 항상 반환**하므로 파라미터가 NULL 이어도 토큰 1행이 나오고,
`A.PROJECT_CODE LIKE '%%'` 로 전 행이 통과한다. DB 에서 직접 재현해 15행 통과를 확인했다.
**추측으로 SP 를 고치지 않았다.**
