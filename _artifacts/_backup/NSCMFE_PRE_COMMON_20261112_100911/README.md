# 공통소스 다운로드 & 병합 회차 보고 — 2026-11-12 10:09

- 원천: remote `common` (https://gyucheollee297@github.com/eunjoo-hwang/nscm-fe.git) · push URL `no_push` 확인 — 푸시 없음
- 기준선 `1d476295b` → **신규 기준선 `61c936ba4`** (61c936ba4 2026-11-12 09:52 eunjoo_hwang feat(login): 로그인 성공 시 SCM_ADM_USER_M.LOGN_DTM 갱신)
- 공통 신규 커밋 2건 · FE 대상(nscm-fe: apps·features·packages·public·configs) 변경 3건 (이름변경은 삭제+신규로 풀어 집계)
- BE 대상(nscm-be: src) — 기준선 `없음(첫 회차 — 공통 최신 트리와 직접 대조)` · 변경 0건 · 환경 파일 항상 로컬 유지 = `src/main/resources/application*.yml`, `src/main/resources/application*.yaml`, `src/main/resources/application*.properties`, `src/main/resources/config/*`, `src/main/resources/mybatis/mybatis-config.xml`, `src/main/resources/logback*.xml`, `src/main/resources/log4j*`, `src/main/java/*/framework/config/CorsConfig.java` · 빌드 설정(build.gradle 등)·lib·저장소·빌드 산출물은 대상 밖(쓰기 차단)
- ⚠ **DB MODE — 로컬 소스 보호 안 함**: 공통 최신 트리 기준으로 다른 파일은 내 편집본도 공통 원문으로 덮어쓴다 · 공통이 지운 파일은 삭제 · 공통에 없는 로컬 전용 파일은 유지

## 분류·처리 결과

| 구분 | 건수 | 처리 |
|---|---:|---|
| 동일 | 2796 | 변경 없음 |
| 로컬 전용(공통에 없음) — 유지 | 104 | 로컬 유지 |
| 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 53 | 공통 원문 적용 |
| 공통 파일 — 로컬 부재 | 18 | 공통 원문 적용 |
| 로컬 환경 파일 — 항상 로컬 유지(접속 정보) | 9 | 로컬 유지 |
| 공통 변경분 — 공통 원문 적용(로컬 보호 안 함) | 3 | 공통 원문 적용 |

적용 폴더별: nscm-be 71 / supply 3

## ⚠️ 결정 대기 0건 (로컬 유지 상태 — 자동 적용 안 함)

- 없음

## BE(nscm-be) 파일별 처리 80건

| 파일 | 구분 | 처리 | 비고 |
|---|---|---|---|
| `nscm-be/src/main/java/com/lgcns/nscm/admin/auth/AuthService.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/auth/AuthServiceImpl.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/auth/dto/MnuBtnAuthSheet.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/log/LogController.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/lookup/LookupController.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/lookup/LookupServiceImpl.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/menu/MenuController.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/menu/MenuService.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/menu/MenuServiceImpl.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/menu/dto/GridColumn.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/menu/dto/GridMeasure.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/menu/dto/MenuAuthDto.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/menu/dto/TitleSetRetrieveRequest.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/message/MessageController.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/test/TestController.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/user/SsoController.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/user/SsoDevController.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/user/User.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/user/UserController.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/user/UserService.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/user/UserServiceImpl.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/user/UserSession.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/admin/user/dto/TmzCdRequest.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/aspect/SystemLogAspect.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/base/BaseConstants.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/base/BaseService.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/config/CorsConfig.java` | 로컬 환경 파일 — 항상 로컬 유지(접속 정보) | 로컬 유지 | 공통과 다름 — 필요하면 직접 반영 |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/config/SecurityConfig.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/config/WebServiceConfig.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/dao/NDBConnection.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/handler/GlobalExceptionHandler.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/ifclient/IfSendClient.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/ifclient/IfSendEnvelope.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/ifclient/NscmIfProperties.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/interceptor/LogInterceptor.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/interceptor/QueryLogInterceptor.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/model/CustomMap.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/property/CommonProperties.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/security/CustomAuthorizationManager.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/security/CustomUserDetails.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/security/CustomUserDetailsService.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/security/SsoService.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/security/filter/CachedBodyHttpServletRequest.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/security/filter/JsonLoginFilter.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/security/filter/SqlInjectionGuardFilter.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/security/handler/LoginSuccessHandler.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/security/sqlguard/SqlInjectionScanner.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/security/sqlguard/SqlInjectionSignatureDetector.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/security/sqlguard/SqlInjectionViolation.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/utils/SecurityUtil.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/webservice/WebServiceCommonController.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/webservice/WebServiceCommonService.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/webservice/WebServiceCommonTestController.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/webservice/WebServiceProperties.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/webservice/WsdlCommonService.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/general/GeneralController.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/general/GeneralService.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/general/GeneralServiceImpl.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/general/file/FileController.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/java/com/lgcns/nscm/general/file/FileServiceImpl.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/resources/application.yml` | 로컬 환경 파일 — 항상 로컬 유지(접속 정보) | 로컬 유지 | 공통과 다름 — 필요하면 직접 반영 |
| `nscm-be/src/main/resources/config/config-dev.yml` | 로컬 환경 파일 — 항상 로컬 유지(접속 정보) | 로컬 유지 | 공통과 다름 — 필요하면 직접 반영 |
| `nscm-be/src/main/resources/config/config-local.yml` | 로컬 환경 파일 — 항상 로컬 유지(접속 정보) | 로컬 유지 | 공통과 다름 — 필요하면 직접 반영 |
| `nscm-be/src/main/resources/config/config-prd.yml` | 로컬 환경 파일 — 항상 로컬 유지(접속 정보) | 로컬 유지 | 공통과 다름 — 필요하면 직접 반영 |
| `nscm-be/src/main/resources/config/config-qa.yml` | 로컬 환경 파일 — 항상 로컬 유지(접속 정보) | 로컬 유지 | 공통과 다름 — 필요하면 직접 반영 |
| `nscm-be/src/main/resources/log4jdbc.log4j2.properties` | 로컬 환경 파일 — 항상 로컬 유지(접속 정보) | 로컬 유지 |  |
| `nscm-be/src/main/resources/logback-spring.xml` | 로컬 환경 파일 — 항상 로컬 유지(접속 정보) | 로컬 유지 |  |
| `nscm-be/src/main/resources/mybatis/mybatis-config.xml` | 로컬 환경 파일 — 항상 로컬 유지(접속 정보) | 로컬 유지 | 공통과 다름 — 필요하면 직접 반영 |
| `nscm-be/src/main/resources/sql/CommonSql.xml` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/resources/sql/admin/Auth.xml` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/resources/sql/admin/DynamicQuery.xml` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/resources/sql/admin/Excel.xml` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/resources/sql/admin/File.xml` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/resources/sql/admin/Menu.xml` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/resources/sql/admin/User.xml` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/main/resources/sql/admin/log.xml` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/test/java/com/lgcns/nscm/admin/user/UserServiceImplTest.java` | 로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함) | 공통 원문 적용 |  |
| `nscm-be/src/test/java/com/lgcns/nscm/framework/security/filter/SqlInjectionGuardFilterTest.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/test/java/com/lgcns/nscm/framework/security/sqlguard/SqlInjectionScannerTest.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |
| `nscm-be/src/test/java/com/lgcns/nscm/framework/security/sqlguard/SqlInjectionSignatureDetectorTest.java` | 공통 파일 — 로컬 부재 | 공통 원문 적용 |  |

## 원복 자료
- `local_before/` — 덮어쓰거나 삭제한 로컬 원본
- `worktree_tracked.patch` — 적용 직전 nscm-fe 추적파일 전체 diff
- `git_status_before.txt` — 적용 직전 워킹트리 상태
- `local_before/nscm-be/` · `be_worktree_tracked.patch` · `be_git_status_before.txt` — BE(nscm-be) 분
- `conflicts/` — 결정 대기 파일의 base · common · merged(충돌 마커 포함) 사본

## 검증
- 공통 원문 적용 74건 — 개행 정규화 후 공통 원문과 불일치 0건
- 적용 파일 충돌 마커 잔존 0건
- 삭제 0건 — 잔존 0
- procedures.d.ts `declare global` 1건(기대 1)
- BE 환경 파일 항상 로컬 유지 9건 — 적용 전과 다른 파일 0건
- BE 대상 밖(build.gradle·settings.gradle·gradle/·lib/ 등) 변경 0건
- 정적검증(type-check/lint) **미수행** — 사용자 지시(요청 시만). 공통 신규 소스 ↔ 내 화면 소스 타입 불일치는 type-check 로 확인 필요
- BE 컴파일(gradlew build) **미수행** — BE 소스가 바뀌었으면 BE 재기동 전 빌드 확인 필요. 실행 중인 BE 는 재기동해야 반영된다
