# 공통소스 다운로드 & 병합 회차 보고 — 2026-11-12 10:30

- 원천: remote `common` (https://gyucheollee297@github.com/eunjoo-hwang/nscm-fe.git) · push URL `no_push` 확인 — 푸시 없음
- 기준선 `61c936ba4` → **신규 기준선 `3e1e0a081`** (3e1e0a081 2026-11-12 10:27 Inhye Kim fix(SCP0025): Unfix 성공 토스트에 처리 건수 표시 — MSG00672 (AS-IS 파리티))
- **BE 전용 실행(Source Download & Merge(BE))** — FE(nscm-fe)는 다루지 않는다
- BE 대상(nscm-be: src) — 기준선 `61c936ba4` · 변경 0건 · 환경 파일 항상 로컬 유지 = `src/main/resources/application*.yml`, `src/main/resources/application*.yaml`, `src/main/resources/application*.properties`, `src/main/resources/config/*`, `src/main/resources/mybatis/mybatis-config.xml`, `src/main/resources/logback*.xml`, `src/main/resources/log4j*`, `src/main/java/*/framework/config/CorsConfig.java` · 빌드 설정(build.gradle 등)·lib·저장소·빌드 산출물은 대상 밖(쓰기 차단)
- BE 로컬 ID 로그인 점검: OK — ID 로그인 경로(/user/login · JsonLoginFilter) 유지
- BE 로컬 ID 로그인 점검: OK — 로컬 설정에 ID 로그인 차단(id-login-disabled: true) 없음
- ⚠ **DB MODE — 로컬 소스 보호 안 함**: 공통 최신 트리 기준으로 다른 파일은 내 편집본도 공통 원문으로 덮어쓴다 · 공통이 지운 파일은 삭제 · 공통에 없는 로컬 전용 파일은 유지

## 분류·처리 결과

| 구분 | 건수 | 처리 |
|---|---:|---|
| 동일 | 162 | 변경 없음 |
| 로컬 환경 파일·필수 유지 소스 — 항상 로컬 유지 | 8 | 로컬 유지 |
| 로컬 전용(공통에 없음) — 유지 | 6 | 로컬 유지 |
| BE 환경 파일 — 누락 설정 키 보충(기존 값 유지) | 2 | 병합본 적용 |

적용 폴더별: nscm-be 2

## ⚠️ 결정 대기 0건 (로컬 유지 상태 — 자동 적용 안 함)

- 없음

## 병합 적용

| 파일 | 구분 | 비고 |
|---|---|---|
| `nscm-be/src/main/resources/application.yml` | BE 환경 파일 — 누락 설정 키 보충(기존 값 유지) | 보충 4개: config.mybatis.queue-capacity, config.mybatis.batch-size, config.mybatis.log-pool-size, config.mybatis.flush-interval-ms |
| `nscm-be/src/main/resources/config/config-local.yml` | BE 환경 파일 — 누락 설정 키 보충(기존 값 유지) | 보충 1개: config.system-cd · 공통에만 있는 설정 블록(넣지 않음 — 직접 확인): config.web-service, config.nscm-if |

## BE(nscm-be) 파일별 처리 10건

| 파일 | 구분 | 처리 | 비고 |
|---|---|---|---|
| `nscm-be/src/main/java/com/lgcns/nscm/framework/config/CorsConfig.java` | 로컬 환경 파일·필수 유지 소스 — 항상 로컬 유지 | 로컬 유지 | 공통과 다름 — 필요하면 직접 반영 |
| `nscm-be/src/main/java/com/lgcns/nscm/framework/model/CustomMap.java` | 로컬 환경 파일·필수 유지 소스 — 항상 로컬 유지 | 로컬 유지 | 공통과 다름 — 필요하면 직접 반영 |
| `nscm-be/src/main/resources/application.yml` | BE 환경 파일 — 누락 설정 키 보충(기존 값 유지) | 병합본 적용 | 보충 4개: config.mybatis.queue-capacity, config.mybatis.batch-size, config.mybatis.log-pool-size, config.mybatis.flush-interval-ms |
| `nscm-be/src/main/resources/config/config-dev.yml` | 로컬 환경 파일·필수 유지 소스 — 항상 로컬 유지 | 로컬 유지 | 공통과 다름 — 필요하면 직접 반영 |
| `nscm-be/src/main/resources/config/config-local.yml` | BE 환경 파일 — 누락 설정 키 보충(기존 값 유지) | 병합본 적용 | 보충 1개: config.system-cd · 공통에만 있는 설정 블록(넣지 않음 — 직접 확인): config.web-service, config.nscm-if |
| `nscm-be/src/main/resources/config/config-prd.yml` | 로컬 환경 파일·필수 유지 소스 — 항상 로컬 유지 | 로컬 유지 | 공통과 다름 — 필요하면 직접 반영 |
| `nscm-be/src/main/resources/config/config-qa.yml` | 로컬 환경 파일·필수 유지 소스 — 항상 로컬 유지 | 로컬 유지 | 공통과 다름 — 필요하면 직접 반영 |
| `nscm-be/src/main/resources/log4jdbc.log4j2.properties` | 로컬 환경 파일·필수 유지 소스 — 항상 로컬 유지 | 로컬 유지 |  |
| `nscm-be/src/main/resources/logback-spring.xml` | 로컬 환경 파일·필수 유지 소스 — 항상 로컬 유지 | 로컬 유지 |  |
| `nscm-be/src/main/resources/mybatis/mybatis-config.xml` | 로컬 환경 파일·필수 유지 소스 — 항상 로컬 유지 | 로컬 유지 | 공통과 다름 — 필요하면 직접 반영 |

## 원복 자료
- `local_before/` — 덮어쓰거나 삭제한 로컬 원본
- `worktree_tracked.patch` — 적용 직전 nscm-fe 추적파일 전체 diff
- `git_status_before.txt` — 적용 직전 워킹트리 상태
- `local_before/nscm-be/` · `be_worktree_tracked.patch` · `be_git_status_before.txt` — BE(nscm-be) 분
- `conflicts/` — 결정 대기 파일의 base · common · merged(충돌 마커 포함) 사본

## 검증
- 공통 원문 적용 0건 — 개행 정규화 후 공통 원문과 불일치 0건
- 적용 파일 충돌 마커 잔존 0건
- 삭제 0건 — 잔존 0
- 설정 키 보충 `nscm-be/src/main/resources/application.yml` — 추가 5줄(키 4개 + 안내 주석) · 기존 줄 삭제·변경 0건
- 설정 키 보충 `nscm-be/src/main/resources/config/config-local.yml` — 추가 2줄(키 1개 + 안내 주석) · 기존 줄 삭제·변경 0건
- BE 로컬 ID 로그인 점검 — OK: ID 로그인 경로(/user/login · JsonLoginFilter) 유지
- BE 로컬 ID 로그인 점검 — OK: 로컬 설정에 ID 로그인 차단(id-login-disabled: true) 없음
- BE 환경 파일 항상 로컬 유지 8건 — 적용 전과 다른 파일 0건
- BE 대상 밖(build.gradle·settings.gradle·gradle/·lib/ 등) 변경 0건
- 정적검증(type-check/lint) **미수행** — 사용자 지시(요청 시만). 공통 신규 소스 ↔ 내 화면 소스 타입 불일치는 type-check 로 확인 필요
- BE 컴파일(gradlew build) **미수행** — BE 소스가 바뀌었으면 BE 재기동 전 빌드 확인 필요. 실행 중인 BE 는 재기동해야 반영된다
