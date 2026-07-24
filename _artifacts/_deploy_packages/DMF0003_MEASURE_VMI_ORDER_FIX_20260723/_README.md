# DMF0003 종속 메저(Div82 MKT_FCST_RP→VMI 세트) 미표시·순서 결함 fix — 2026-07-23

## 증상 (사용자 신고)
Grid 에서 메저 선택 후 종속으로 나오는 메저가 제대로 나오지 않거나 순서가 맞지 않음.

## 원천 로직 (AS-IS [C20201103-000114])
Div 82 + MKT_FCST_RP 선택 시 종속 4종(RTF_SYS_RP / VMI_In_Plan / VMI_In_Req / VMI_Inv)을
기존행 DELETE 후 RP SORT 기반 `.1~.4` 로 강제 삽입, RP 자신은 `.9` 로 그룹 마지막 배치.

## Oracle 변환 결함 2건 (실측)
| # | 결함 | 근거 |
|---|---|---|
| 1 | **DELETE 대소문자** — `MEASURE IN ('VMI_IN_PLAN',...)` 대문자 리터럴. MSSQL 은 CI 라 'VMI_In_Plan' 매칭, Oracle 은 불일치 → 사용자가 titleset 에서 VMI 메저를 선택한 경우 기존행 미삭제 + 강제삽입 = **중복 2행** | 실코드 'VMI_In_Plan/In_Req/Inv' (SHEET_MEASURE 실측) |
| 2 | **SORT 부여 무효** — `REPLACE(SORT,'.0',SORTKEY)` 는 SORT 원천(titleset INT → VARCHAR2 '2')에 '.0' 이 없어 no-op → 종속 4종+RP **전부 동률('2')** → 그룹 내 순서 미보장 | fix 전 실측: RP/RTF/VMI_Inv 모두 SORT '2' |
> AS-IS 도 '.0' REPLACE 는 사실상 사문(#TempSelectMeasure nvarchar + int 원천 — dev 실측 '70' 형)이나,
> [C20201103-000114] 의 명시 의도(.1~.4/.9)를 복원하는 것이 증상 해소의 정본.
> ⚠ 참고: CUST_FCST_ORG 의 [Org.] 서브메저 7종은 AS-IS 에서 **E20241126-000426 로 주석 처리(미표시 합의)** — TO-BE 8종 구성이 live 파리티 정확(결함 아님).

## 수정 (본문 3개 지점만, 그 외 무수정)
1. DELETE → `UPPER(MEASURE) IN (...)` (MSSQL CI 등가)
2. 종속 INSERT SORT → `CASE WHEN INSTR(SORT,'.')=0 THEN SORT||SORTKEY ELSE REPLACE(...) END`
3. RP UPDATE '.9' → 동일 CASE 패턴

## 적용 (클라우드)
```
sp/PKG_DMF0003_BODY_vmifix.sql   (BODY 전체 재배포 — titleset 면역 + ORA-12841 가드 포함 최신 누적본)
```
> 이 BODY 가 PKG_DMF0003 의 최신 단일본 (IMMUNIZE/ORA12841 패키지의 BODY 대체).

## 검증 (사내 OCGSCMD_P01, 2026-07-23 적용 완료)
- BODY VALID / errors 0.
- div 82 실호출 fix 전: RP·RTF·VMI_Inv SORT 전부 '2'(동률) → fix 후: **RTF '2.1' / VMI_Inv '2.4' / RP '2.9'** (VMI_In_Plan/In_Req 는 데이터 0건으로 미표시 — QTY 필터, AS-IS 동일 동작).
- 행수 1,083 동일 (measure 구성 외 무변경).
