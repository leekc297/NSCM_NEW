# 사내 Oracle 적용 보고 — 2026-06-10

## Phase 0~3 결과

### 적용 도구
- `docker exec nscm-oracle sqlplus` (사내 DB: 121.162.245.167:2521:ESSCMD, user=SCM_MGR)
- 자동화 스크립트: `_artifacts/_apply_corporate/apply.sh`
- 로그: `_artifacts/_apply_corporate/_logs/`

### 11 화면 SQL 적용 통계
| 화면 | 적용 파일 수 | 결과 |
|---|---:|---|
| SYS0014 (Group User) | 5 | ✅ MNU/SP 신규 등록 |
| SYS0015 (Program) | 2 | ✅ MNU/SP 신규 등록 |
| SYS0013 (Dynamic Query) | 6 | ✅ |
| SYS0011 (Auth Request) | 4 | ✅ |
| SYS0012 (Auth Approval) | 5 | ✅ SP 신규 13개 등록 |
| SYS0001 (Message) | 0 | Skip (이미 적용) |
| DMF0008 (ERP EDI Master) | 22 | ✅ (04_GRANT 6개 별도 승인 필요) |
| DMF0072 (NN Master Mapping) | 14 | ✅ |
| DMF0043 (Contribute Main) | 13 | ⚠️ SP fix 4개 PLS-00905 (caller INVALID) |
| DMF0043_01 (Contribute View) | 10 | ✅ |
| DMF0020 (Sales Future Price) | 1 | ✅ 메타만 (SP body 미존재 — 산출물 한계) |
| **합계** | **82** | |

### 변경량 (사내 DB BEFORE → AFTER)
| 카테고리 | BEFORE | AFTER | Δ |
|---|---:|---:|---:|
| MNU | 89 | 91 | +2 |
| API | 109 | 139 | +30 |
| PROC | 595 | 702 | +107 |
| SHEET_COLUMNS | 15284 | 15346 | +62 |
| MNU_BTN_MPG | 108 | 135 | +27 |
| USER_GR_MNU_MPG | 344 | 349 | +5 |
| USER_GR_MNU_BTN_MPG | 295 | 337 | +42 |

### SP VALID/INVALID 상태 (11 화면)
| 화면 | VALID | INVALID |
|---|---:|---:|
| DMF0008 | 8 | 0 |
| DMF0072 | 10 | 0 |
| DMF0043 | 10 | **1** (DMF0043_GET_CONTRIBUTE_MAIN_DATA) |
| DMF0020 | 20 | **1** (P_DMF0020_GET_OWNER_DATA — 산출물 미존재) |
| SYS0011 | 1 | 0 |
| SYS0012 | 3 | 0 |
| SYS0014 | 4 | 0 |
| SYS0015 | 2 | 0 |

## Known 이슈 (Phase 5 보완 작업 대상)

### 1. i18n 메시지 (SCM_ADM_MSG_M) NOT NULL 제약 ⚠️
- 사내 DB 의 `SCM_ADM_MSG_M` 은 `MSG_TP_CD/USE_YN/CREATED_BY/LAST_UPDATED_BY` 가 NOT NULL
- Docker DB 는 NULLABLE — 적용된 SQL 들이 컬럼 누락한 채 INSERT 시도 → ORA-01400
- **영향**: 11 화면의 모든 i18n MSG 미등록 → 메시지 ID 가 fallback 표시됨
- **해결**: Phase 5 (별도 패치) — DMF0008 우선 사용자 요청

### 2. SCM_COM_MSG_M 테이블 미존재
- 사내 + Docker 양쪽 모두 미존재
- SYS0011/0012/0013 i18n INSERT 가 시도되었으나 ORA-00942 로 실패
- Docker 도 동일 상태 — i18n 은 SCM_ADM_MSG_M 사용으로 전환 필요

### 3. SCM_ADM_MNU_M BMK_YN 컬럼 미존재 (사내)
- Docker DB 에는 BMK_YN 추가, 사내 DB 에는 없음
- MENU INSERT 시 ORA-00904 — 다른 컬럼은 정상 INSERT
- **해결**: 사내 DB DDL 동기화 또는 SQL 에서 BMK_YN 컬럼 제거

### 4. USERS tablespace quota
- ORA-01653: 일부 INSERT 시 발생
- 사내 DBA 측 tablespace 확장 필요

### 5. 04_GRANT_SYNONYM 미적용 (사용자 승인 보류)
- DMF0008 의 6개 GRANT/Synonym 파일 — 공유 DB 권한 변경으로 별도 승인 필요
- 다른 화면 04_GRANT 도 동일

### 6. DMF0043_GET_CONTRIBUTE_MAIN_DATA INVALID
- 호출되는 caller 가 다른 SP/cursor type 불일치로 INVALID
- 사내 DB 의 의존 객체 분석 필요

### 7. P_DMF0020_GET_OWNER_DATA INVALID
- 메타 등록만 + SP body 미작성 — 산출물 한계 (plan 결정)
- 사용자 결정 후 SP body 작성 필요

### 8. DBMS_METADATA 버그 (BLOCK 1 audit backup)
- 사내 Oracle 19c 의 DBMS_METADATA 가 일부 SP backup 추출 시 LPX-00210
- 실제 SP recreation 은 정상 — backup-only 영향

## 수동 검증 안내 (사용자)

1. **BE 재기동** — `start-all.ps1` (이미 수행됨)
2. **재로그인** — F12 DevTools → Application → Clear site data → 로그인
3. **메뉴 표시 확인** — sidebar 에 11 화면 표시 (SYS 5종 + DMF 5종)
4. **각 화면 진입 + 조회 동작 확인** — BE 로그 ORA-* / PLS-* 0건 확인

## 다음 작업
- ⏭️ **DMF0008 i18n MSG 클라우드 등록 SQL 파일 생성** (사용자 요청 2026-06-10)
- ⏭️ Phase 5 (선택): 다른 화면 i18n patch / 04_GRANT 적용 / DMF0020 SP body 작성
