# 소스코드 분석
##### 기존 linkable 백엔드 프레임워크의 AS-IS 소스 분석 내용을 기록하는 문서입니다.

---
## 1. @BaseArgumentResolver
Controller 단에서 QueryParameter 및 RequestBody에 대한 공통 로직 적용을 위한 어노테이션

참조파일 : CustomWebConfig, BaseArgumentResolver, 모든 Controller

#### 파라미터 어노테이션 작동원리
* WebMvcConfigurer를 구현한 CustomWebConfig에서 addArgumentResolvers 메소드에서 baseArgumentResolver()가 반환하는 객체를 리스트에 등록함
* @BaseArgument가 붙은 파라미터는 BaseArgumentResolver가 처리 가능한 파라미터로 감지됨 (supportsParameter())
    * Spring은 기본적으로 모든 파라미터에 대해서 처리 가능한 Resolver가 있는지 탐색함
* 해당 Resolver가 파라미터에 대해 어떤 처리를 할 지는 resolveArgument()에 작성

#### BaseArgumentResolver 수행 역할
* Query Parameter와 Request Body 파싱하여 단일 파라미터(params)로 제공
* 보안 처리 : 문자열 파라미터 검사, script injection 감지 후 처리
* 실행 권한 주입

#### NSCM을 위한 검토사항
* 보안 처리, 세션값 조회는 유효한 기능이지만 전체적으로 문제의 소지가 많음
* 1. Query Parameter와 Request Body 간 출처가 불분명하고 key가 동일한 값은 덮어씌워질 우려도 있음
* 2. Bean Validation이 불가함

--> 결과적으로 @BaseArgumentResolver 및 관련 설정은 삭제
--> 로그인 유저 정보를 가져오는 annotation 별도 작성, injection 체크 유틸을 만들고 RequestBodyAdvice로 적용 권장


---
## 2. Exception 처리 방식
BaseException과 이를 상속하는 CustomException을 만들고, @RestController를 통해 Controller-level의 Exception 처리 로직을 공통화

참조파일 : BaseException, CustomBusinessException, CustomExceptionHandler

#### 핵심 로직
* BaseException에서는 다양한 형식의 생성자와 에러 메시지 다국어를 지원
* CustomExceptionHandler은 각 Exception에 매핑되는 customExceptionHandler로 분기 처리
    * 2개 이상의 메소드에 매핑되면 더 구체적인 Exception에 대한 메소드를 사용

#### NSCM을 위한 검토사항
* 우리에게 맞는 Exception 재정의 및 처리 로직 개선 필요
* success 형식의 responseEntity로 응답되는 구조도 개선 필요


---
## 3. Transaction 관리 방식
TransactionConfig를 통한 Service Layer의 Transaction 공통 관리

참조파일 : TransactionConfig(deleted), MyBatisPrimaryConfig(deleted), MyBatisSecondaryConfig(deleted)

#### 적용 방식
* TransactionConfig에서 NameMatchTransactionAttributeSource와 TransactionManager를 주입한 TransactionInterceptor 생성 및 Bean 등록
    * TransactionManager는 MyBatisXXXConfig에서 Bean 등록
* Advisor Bean을 등록하여 AOP로 TransactionInterceptor 로직 적용

#### NSCM을 위한 검토사항
* 선언적 트랜잭션 관리를 하는 경우라면 유효한 공통화 설정
    * 선언적 트랜잭션 관리 : @Transactional 어노테이션을 통해 Spring이 관리하도록 하는 방식
* 단, 선언적 트랜잭션 관리를 공통화 해놓고, DAO에서 다시 @Transactional을 사용하고 있는 것은 잘못된 방식이었던 것으로 예상됨
* NSCM은 Service Layer에서 선언적 트랜잭션 관리를 하지 않고, DAO Layer에서 프로그래밍적 트랜잭션 관리(트랜잭션 직접 제어)를 하고 있어서 AS-IS의 공통화 Config 혼용에 어려움이 있음

-> 결과적으로 관련 설정 모두 삭제
