# [Project] NSCM Backend 애플리케이션

본 문서는 LG Energy Solution NSCM 시스템의 Backend API 서비스 운영 및 개발을 위한 기술 사양과 개발 표준을 기술한다.

---

## 1. 시스템 개요
* **프로젝트명**: NSCM Backend
* **시스템 목적**: 공급망 관리 효율화 및 데이터 정합성 확보를 위한 통합 백엔드 서비스 제공
* **주요 기능**: 사용자 인증/인가 관리, NSCM Frontend API 요청 및 트랜잭션 처리


## 2. 기술 스택 (Standard Tech Stack)

| 구분 | 기술 사양 | 비고 |
| :--- | :--- | :--- |
| **Language** | Java 17 | Amazon Corretto |
| **Framework** | Spring Boot 3.2.x | Spring Security 6.x |
| **Persistence** | MyBatis 3.5.x | Oracle 19c / MSSQL 2019 |
| **Library** | Lombok, Swagger, SpringDoc | 개발 생산성 향상 도구 |
| **Build** | Gradle 8.x | Artifact 관리 및 빌드 자동화 |
| **Test** | JUnit5 | 단위테스트 |


## 3. 인증 및 인가
* Spring Security 기반 인증 및 인가 관리

### 3.1. 인증(Authentication) 체계
* **방식**: Session-based (Spring Security Filter 기반)
* **로그인 처리**: `JsonLoginFilter`를 통한 JSON 인증 요청 처리
* **SSO**: LG Energy Solution SSO 인증 연동 (예정)

### 3.2. 인가(Authorization) 정책
* MENU_ID, ACTION_ID 기반의 요청 단위 권한 제어
* **권한 체크 어노테이션 (`@AuthCheck`) 정의**
    1. **`NONE`**: 비인증/비인가 허용
    2. **`LOGIN`**: 인증 여부 확인 (Default)
    3. **`ALL`**: 인증 및 인가 여부 확인


## 4. 요청 형식
* 정확한 요청 포맷에 대해서는 Swagger 문서를 참고한다.

### 4.1 공통 Header
```json
{
  X-Request-ID: "8b2e4d1a9f5c4b3aa1d2e7f6c5b4a3d2", // 요청 고유 식별자
  ...
}
```

### 4.2. GET 조회 요청은 쿼리 파라미터를 사용한다

### 4.3. POST 조회 요청 Body
```json
{
  param1: "cond1",
  param2: 1,
  param3: [1, 2, 3],
  param4: ['1','2','3'],
  ...
}
```

### 4.4. POST 저장 요청 Body
```json
[
  { a: string, b: number, c: boolean, d: json },
  ...
]
```


## 5. 응답 포맷
* 정확한 응답 포맷에 대해서는 Swagger 문서를 참고한다.

### 5.1. 성공 응답
#### 5.1.1 SCM 비즈니스 공통 응답
```json
// Response Body
{
  code: "1000",
  message: "Success",
  result: {
      OUTPUT_NAME_1: [ { columnA: data, columnB: data, ... }, ... ],
     OUTPUT_NAME_2: [ {}, ... ],
     ...
  }
}
```

#### 5.1.2 그 외 응답
```json
// Response Body
{
  code: "1000",
  message: "Success",
  result: {} or []
}
```


### 5.2. 에러 응답 (Exception Handling)
모든 에러 응답은 `GlobalExceptionHandler` 및 Spring Security 보안 핸들러를 통해 아래의 표준 포맷으로 출력함을 원칙으로 한다.

```json
// Response Body
{
  code: "-9999",
  message: "Server Error",
  result: null
}
```
