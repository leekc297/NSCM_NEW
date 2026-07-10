# DMF0014 — 저장 SQL error 5종 + 테이블 전체삭제 치명버그 hotfix (2026-07-08)

> **클라우드 적용 대상 = FE 2 파일뿐** (DB/SP 는 사내 Oracle 공용 — 클라우드 BE 도 동일 DB 직결이라 **이미 반영 완료**. sql/ 은 기록·재배포 참고용).
- 화면 ID: **DMF0014** (CustomerFcstUpload) | 도메인: `demand` | BE Java 무변경
- 선행: `_dmf0014_artifacts`(07-08 오전, cascade/라벨/모달) — 그 후속 hotfix. FE 2파일은 최신본.

## 1. 오늘 해결한 결함 체인 (다건 수정 저장 시 순차 노출)

| # | 증상 | 근본원인 | 조치(사내 반영 완료) |
|---|---|---|---|
| 1 | ORA-01400 CREATED_BY NULL (다건 저장) | FE `createdBy` 키를 BE가 세션 단일값으로 덮음 → '^'×N 붕괴 | FE `createdByList` + PROC_M SORT17 동일 정렬 (`06`) |
| 2 | ORA-01403 (마스터 lookup) | MSSQL `SELECT @v` no-row 관용 누락 (10곳) | `08` FIX — `NO_DATA_FOUND` wrap 10곳 |
| 3 | ORA-01422 ① | `DM_MST_CUSTOMER_FCST` 동일키 9중복 → SELECT INTO 다중행 (MSSQL=마지막행 관용) | `08` FIX — MAX 집계 6곳 |
| 4 | ⭐⭐⭐ **저장 1건에 테이블 전체 삭제** (SQL error 없음!) | SAVE의 INSERT-전-DELETE 상관 서브쿼리가 **무prefix 컬럼명** 사용 — GTT(`GT_SCFU_RESULTS`) 실컬럼은 `V_*` → 외부 PSI 자기참조(항상 참) → `DM_PLN_CUSTOMER_PSI` 전체 삭제 | `07` FIX — `G.V_* = PSI.*` 정확 상관 (11 컬럼) |
| 5 | ORA-01422 ② (저장 후 메시지) | GTT 4종 INSERT 전 DELETE 누락(C-5) — 루프/세션 잔존 RN 중복 | `08` FIX — DELETE 초기화 4곳 |
| - | 소실 데이터 | 실패 업로드의 범위삭제 커밋 잔존 + #4 | Flashback 복구 2회 (48→49행, `09` 참고) |

> `08_PR_DM_PLN_FIX_FINAL_DEPLOYED.sql` = 공유 SP `PR_DM_PLN_CUST_FCST_TO_MKT_FCST` **누적 최종본**
> (금일 오전 TRUNCATE→DELETE 8곳 + `@@FETCH_STATUS` 무한루프 2곳 포함 — 이 파일 하나로 전체 재배포 가능).

## 2. 패키지 구성
```
_dmf0014_hotfix_20260708_artifacts/
├── fe/features/demand/src/pages/customer-fcst-upload/
│   ├── customer-fcst-upload.constant.ts     ← SAVE_KEYS 'createdByList'
│   └── CustomerFcstUpload.tsx               ← payload 키 createdByList
├── sql/  (사내 반영 완료 — 기록/재배포용)
│   ├── 06_PROC_M_createdByList_DEPLOYED.sql
│   ├── 07_PKG_DMF0014_BODY_ORIG_backup.sql / 07_..._FIX_DEPLOYED.sql   ← 전체삭제 버그 정정
│   ├── 08_PR_DM_PLN_ORIG_backup.sql / 08_..._FIX_FINAL_DEPLOYED.sql    ← 공유 SP 누적 최종본
│   └── 09_recover_psi_flashback_reference.py                            ← Flashback 복구 절차 참고
└── _README.md
```

## 3. 클라우드 적용
```bash
cp fe/features/demand/src/pages/customer-fcst-upload/customer-fcst-upload.constant.ts \
   nscm-fe/features/demand/src/pages/customer-fcst-upload/
cp fe/features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx \
   nscm-fe/features/demand/src/pages/customer-fcst-upload/
# DB 는 공용(사내) — 추가 작업 없음. 별도 DB 환경이면 06→07→08 순 배포.
```

## 4. 검증
1. 일자별(D_) 셀 **다건** 수정 → 저장 → 오류 없이 완료 + 재조회 시 수정 반영 **+ 기존 행 전부 유지**.
2. Excel Upload → 정상 완료(파일 기간 범위 대체는 의도 동작임에 유의).
3. 회귀: 1건 수정 저장 / 신규(INSERT) 저장.

## 5. 별건 권고 (미조치)
- `DM_MST_CUSTOMER_FCST` 동일키 9중복 + MEASURE 오타('Cutomer FCST') 191행 — 마스터 정리 권장.
- 업로드 프로시저의 "범위삭제 후 실패 시 삭제 커밋 잔존" 구조 — 트랜잭션 정합 개선 검토.

---

## 6. (추가 2026-07-08 오후) Excel Upload ORA-01841 + "10행→20행 Duplication Key" fix — `11_*`

### 6.1 근본 원인 2건 (진단 확정)

| # | 증상 | 근본 원인 |
|---|---|---|
| 1 | `ORA-01841` (년 범위) — 업로드 OK 시 | 업로드 파일 일자-tier 행이 **숫자 셀**(`2.0260706E7` 과학표기, 첫 주 칸 빈값) → 기존 [2-tier support] 가드(`ATTRIBUTE14 = ^[0-9]{8}$`) 미통과 → V_TITLE에 `W28` 잔존 → `TO_DATE('W28','YYYYMMDD')` 폭발 (body 1770행 CASE) |
| 2 | 재시도 시 10행이 20행 인식 → 전건 "Duplication Key." | ⭐ **BE 프레임워크 결함**: `SystemLogAspect.java` catch 블록이 예외 시 `joinPoint.proceed()` **재호출** → 실패한 업로드 요청 전체(파싱→스테이징 INSERT→검증 SP)가 같은 요청 안에서 2회 실행. 재실행이 같은 초면 CREATION_DATE(초 정밀) 동일 → SP가 한 배치로 인식 → 트윈 20행 → dup 오탐. **사용자 결정: BE 불변** → SP 방어로 대응 |

### 6.2 SP 패치 (`11_PKG_DMF0014_upload_dedup_normalize_FIX.sql` — P_DMF0014_CUST_FCST_EXCEL_UPLOAD, mode=0)

1. **[DEDUP FIX] 잔존 배치 정리** — 현재 배치(V_CREATION_DATE) 외 본인(user+program+sheet) 이전 행 DELETE (7/6부터 누적 잔존 정리, 사용자 승인).
2. **[DEDUP FIX] 같은 초 트윈 dedup** — 동일 배치에 타이틀행(`Division*`) 2개↑면 두 번째 타이틀부터 DELETE (BE 이중 실행 방어 — UPLOAD_ID 순번 기반).
3. **[NORMALIZE] 일자행 정규화** — ATTRIBUTE1 NULL 행의 ATTR14~150 중 숫자표기(`2.0260706E7`/`20260706.0`)를 `TO_CHAR(TO_NUMBER(x),'FM99999999')`로 'YYYYMMDD' 환원.
4. **가드 완화** — [2-tier support] 일자행 판정 `ATTR14` → `ATTR14 OR ATTR15` (첫 주 칸 빈값 파일 수용).

원본 = `11_..._ORIG_backup.sql` (배포 직전 user_source 추출본). signature 불변 → PROC_M/GRANT 추가작업 없음.

### 6.3 배포 (사내 = 클라우드 공용 DB, 1회)
```bash
python _artifacts/_diagnostics/ora.py exec _artifacts/_deploy_packages/_dmf0014_hotfix_20260708_artifacts/sql/11_PKG_DMF0014_upload_dedup_normalize_FIX.sql
python _artifacts/_diagnostics/ora.py compile PKG_DMF0014   # VALID + USER_ERRORS 0 확인
```

### 6.4 검증
1. 화면 Excel 다운로드(최신 빌드) → QTY 수정 → Upload OK → 정상 완료 (ORA-01841 0건).
2. 과거 다운로드본(주차 헤더 + 숫자 일자행) 업로드 → 정규화로 정상 처리.
3. 고의 실패 후 재시도 → 10행 그대로 인식 (20행 dup 오탐 0건).
4. `SELECT COUNT(*) FROM SCM_ADM_EXCEL_UPLOAD WHERE CREATED_BY='<본인>' AND PROGRAM_ID='DMF0014'` — 최신 배치만 잔존.

### 6.5 미조치 (한계 명시)
- **BE `SystemLogAspect` 예외 시 재실행 결함은 남아 있음** — DMF0014 는 SP 방어로 커버되지만, 실패하는 **모든** `@SystemLog` 엔드포인트(저장/버튼 계열 포함)는 여전히 2회 실행됨. 클라우드/사내 BE 공통. 프레임워크 소유자 수정 권고: catch 블록의 `result = joinPoint.proceed();` 제거 + rethrow.
- 동일 패키지 내 `P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM`(별도 시트 변형)에는 [2-tier support]/정규화/dedup 미적용 (현 화면 미사용 경로 — 사용 시 동일 패치 필요).
