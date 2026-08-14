# SCM_MST_SITE 클라우드 → 로컬(사내) 데이터 이관 세트 (2026-08-12)

> **배경**: 사내 Oracle 의 SCM_MST_SITE 가 부분 이관 상태 — 행수는 2,997로 비슷하지만
> **DEPT_ID 등 컬럼 값이 결핍**(DEPT_ID 보유 109 vs AS-IS 2,963 / SALES·81 부서 8 vs 32).
> 이 결핍이 Team 콤보(TeambyDivision — DMF0021 등) 81 기준 5팀(AS-IS ~31팀) 과소의 원인.
> 방식 = PK(DIVISION_ID, SCM_SITE_ID) **MERGE UPSERT** — 값 갱신+부재 행 삽입, DELETE 없음(사내 전용 행 보존).

## 절차 (3단계)

1. **클라우드에서 추출** — 클라우드 sqlplus 에서:
   ```
   @01_EXTRACT_SCM_MST_SITE_CLOUD.sql
   ```
   → 실행 디렉터리에 `scm_mst_site_cloud.dat` 생성(전 행·39컬럼, '|@|' 구분).
   말미 화면 출력(TOTAL_ROWS / DEPT_FILLED / SALES_81_DEPT)을 함께 기록해 주세요.

2. **파일을 로컬로 복사** — 본 폴더(`SITE_SYNC_FROM_CLOUD_20260812\`)에 두는 것을 권장.

3. **로컬 적재** — 드라이런으로 예상치 확인 후 실적재:
   ```
   python 02_load_scm_mst_site.py scm_mst_site_cloud.dat --dry
   python 02_load_scm_mst_site.py scm_mst_site_cloud.dat
   ```
   적재 후 자동 검증 출력: 총행/DEPT_ID 보유/SALES·81 부서 팀 수(기대 ~30).

## 주의

- 감사컬럼(CREATED_BY 등)은 **클라우드 원값 보존**(데이터 이관 — 메타 SQL 'admin' 규약과 별개).
- SITE_DESCRIPTION 의 줄바꿈은 `\n`/`\r` 이스케이프로 왕복(적재기가 복원).
- 재실행 무해(멱등 MERGE). 적재 후 브라우저 새로고침해야 콤보 캐시(staleTime Infinity)가 갱신됩니다.
- `.dat` 파일이 준비되면 저(클로드)에게 경로만 알려주셔도 드라이런→적재→검증까지 대신 실행합니다.
