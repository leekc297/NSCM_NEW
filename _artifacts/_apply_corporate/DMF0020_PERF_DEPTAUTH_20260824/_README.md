# DMF0020 조회 성능 — 사내 적용 누적본 (2026-08-24)

> 계기: **UI 조회 35초** (div 82 / CURRENT / WEEKLY / 20260701~20270630 / 10,524행).
> 목표: DB 5초 이내(사용자 기준). 원복 = `_artifacts/_backup/DMF0020_PRE_DEPTAUTH_TUNING_20260824/`
> (그 이전 지점 = `DMF0020_PRE_PKG_CONSOLIDATION_20260824` / `DMF0020_PRE_INJOIN_20260824`)

## 1. 35초의 실측 분해 — 결론부터

처음엔 전송량(25MB)을 의심했으나 **틀렸다.** API 를 직접 호출해 구간을 갈랐다.

| 구간 | 조치 전 | 정체 |
|---|---:|---|
| DB (SP + 커서 실행) | **13s** | 실제 데이터 처리 |
| **BE `QueryLogInterceptor`** | **지배적** | ⭐ 조회 결과 전체를 JSON 으로 만들어 로그 테이블에 CLOB INSERT |
| 응답 직렬화 | 4.3s | |
| 전송 | 1.5~2s | 25MB 여도 사내망에선 빠르다 |
| 브라우저 | 미미 | API 왕복 ≈ 사용자 체감 |

**결정적 증거**: `SCM_COM_SQL_LOG.PARAMS` 길이 = **20,535,281 bytes (19.6MB)**.
MyBatis 는 실행 후 OUT 파라미터(REF CURSOR 매핑 결과)를 파라미터 맵에 되돌려 넣는데,
인터셉터가 `finally` 에서 그 맵을 통째로 직렬화해 원격 DB 에 넣고 있었다.

## 2. 적용 내역 (7건)

### A. DB — `PKG_DMF0020` (전부 결과 동등성 sha 일치 확인)

| # | 마커 | 내용 | 효과 |
|---|---|---|---|
| 1 | `E20260824-PKGCONSOL` | 단독 SP 20본 → PKG 통합(편입 4·폐기 19), 배선 `API_M` 5 + `PROC_M` 57 전환 | 구조 일원화 |
| 2 | `E20260824-DEPTAUTH` | `FN_GET_DEPT_LIST` **행별 호출 제거** → `GT_DMF0020_DEPT_AUTH` 1회 실현 + JOIN (정적 2 + 동적 1) | 5.40 → 4.43s |
| 3 | — | `PLANT_SITE_ID` 센티널 정규화 **10지점 제거** (원장 163만행 전수 0건 실측) | 포함 |
| 4 | `E20260824-INJOIN` | `MEASURE`/`VERSION_NO` **IN 서브쿼리 6지점 → JOIN** (`GT_DMF0020_SEL_MEASURE`/`_SEL_VERSION` 1회 실현) | 4.43 → 3.41s |
| 5 | `E20260824-MERGEHAVING` | `MERGE PRICE_EXIST` — 68행 갱신에 558,704행 조인하던 것을 `HAVING` 으로 대상만 생성 | 1.43 → 1.06s |

동등성 기준선(div40 / 20260801~20261231 / CURRENT): **173컬럼 8,600행 sha `1407820d95feb3a3`** — 5건 적용 후에도 동일.

### B. BE (`C_BE/` 동봉 — **전 화면 공용**)

| # | 파일 | 내용 | 효과 |
|---|---|---|---|
| 6 | `QueryLogInterceptor.java` `[E20260824-LOGPARAM]` | ①OUT 커서 키(`@`)·`DATARESULT` 제외 → 입력만 로깅 ②`PARAMS_MAX_LEN=4000` 절단 | **PARAMS 19.6MB → 1.4KB** |
| 7 | `application.yml` `[E20260824-GZIP]` | `server.compression` 신설(설정 자체가 없어 기본 비활성이었음) | 전송 20MB → 598KB |
| — | `mybatis-config.xml` `[E20260824-FETCHSIZE]` | `defaultFetchSize` 0 → 1000 | **효과 미미**(실측) · 무해 |

⚠ 6번은 프레임워크 공용이라 **대량 조회를 하는 모든 화면이 함께 개선**된다. `SCM_COM_SQL_LOG` 비대화도 멈춘다.

## 3. DB 문장별 실측 (div82 / 12개월, 초·회)

| 초 | 문장 | 비고 |
|---:|---|---|
| 3.66 | 동적 PIVOT 본쿼리 | = 커서 FETCH 구간. `OPEN` 은 0.07s(지연 실행) |
| 2.22 | `TMPOUTPUTOMISSION` | `TMPOUTPUTALL` **2회 스캔**(GROUP BY + anti-join) — 다음 1순위 |
| 1.75 | `TMPOUTPUTALL` | 419,441행 |
| 1.51 | `TMPOUTPUT` 1차 | 558,704행 |
| 1.06 | `MERGE PRICE_EXIST` | 개선 후 |
| 1.03 | `GT_FTPR_SCM_MST_FUTURE_PRICE` | 433,080행 |
| 0.87 | `TMPOUTPUT` 월평균 | 108,636행 |

**구조**: 62주 × 4 measure × 2,631 키 = 약 66만 행을 만들어 10,524행으로 PIVOT 한다.
사용자 확인 결과 **월(M_) 컬럼 12개와 MEASURE 4종은 모두 필수**라 데이터량 자체는 줄일 수 없다.

## 4. 미해결 · 다음 단계

- **DB 12~13초는 5초 목표 미달.** 분포가 평평해 "한 방"이 없다. 다음 후보 =
  `TMPOUTPUTOMISSION` 을 **partitioned outer join(densify) 1패스**로 재작성(현재 2회 스캔)
- **log4jdbc 프록시 A/B 미판정** — JDBC URL 이 `jdbc:log4jdbc:` 라 107만 셀이 프록시를 거친다.
  측정 시도했으나 **로컬 물리메모리 고갈(39.8GB 중 여유 0)** 로 호출마다 32→64→86→108초로
  악화돼 판정 불가. **깨끗한 환경에서 재측정 필요**
- `PR_SCM_MST_EXCHANGE_RATE` L259 가 단독 `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION` 을
  호출해 그 1본만 폐기 보류 중(범위 밖 배치)
- `P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP` 에 `FN_GET_DEPT_LIST` **2지점 잔존**(배선 없음)

## 5. 적용 순서 (클라우드 이관 시)

```
00_GTT_DDL.sql            GT_DMF0020_DEPT_AUTH (+인덱스)
00B_GTT_DDL_SELSET.sql    GT_DMF0020_SEL_VERSION / _SEL_MEASURE (+인덱스)
01_PKG_DMF0020_SPEC.sql
02_PKG_DMF0020_BODY.sql
90_VERIFY.sql             V1~V6
C_BE/**                   BE 3본 배포 후 재기동
```

⚠ 배선 전환(`API_M`/`PROC_M`)은 `DMF0020_PKG_CONSOLIDATION_20260824/03_REWIRE.sql` 에 있다.
