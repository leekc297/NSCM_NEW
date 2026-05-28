package com.lgcns.nscm.framework.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.authentication.logout.LogoutFilter;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.web.cors.CorsConfigurationSource;

import com.lgcns.nscm.framework.property.CommonProperties;
import com.lgcns.nscm.framework.security.CustomAuthenticationProvider;
import com.lgcns.nscm.framework.security.CustomAuthorizationManager;
import com.lgcns.nscm.framework.security.filter.ExceptionHandlingFilter;
import com.lgcns.nscm.framework.security.filter.JsonLoginFilter;
import com.lgcns.nscm.framework.security.handler.AccessDeniedExceptionHandler;
import com.lgcns.nscm.framework.security.handler.AuthenticationExceptionHandler;
import com.lgcns.nscm.framework.security.handler.LoginFailureHandler;
import com.lgcns.nscm.framework.security.handler.LoginSuccessHandler;
import com.lgcns.nscm.framework.security.handler.LogoutResponseHandler;

import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

	// Security Core
	private final CommonProperties commonProperties;
    private final AuthenticationConfiguration authenticationConfiguration;
    private final CustomAuthenticationProvider customAuthenticationProvider; // 인증 전략
    private final CustomAuthorizationManager customAuthorizationManager;     // 인가 관리

    // Authentication & Authorization Handlers
    private final LoginSuccessHandler loginSuccessHandler;                 		 	// 로그인 성공 (200)
    private final LoginFailureHandler loginFailureHandler;                 		 	// 로그인 실패 (401)
    private final LogoutResponseHandler logoutResponseHandler;
    private final AuthenticationExceptionHandler authenticationExceptionHandler; 	// 미인증 예외 (401)
    private final AccessDeniedExceptionHandler accessDeniedExceptionHandler;		// 미인가 예외 (403)
    private final ExceptionHandlingFilter exceptionHandlingFilter;         			// 예외 전파 필터 (500)

    // CORS
    private final CorsConfigurationSource corsConfigurationSource;           // CORS 설정

    @Bean
    public SecurityContextRepository securityContextRepository() {
        return new HttpSessionSecurityContextRepository();
    }

    @Bean
    public AuthenticationManager authenticationManager(HttpSecurity http) throws Exception {
        AuthenticationManagerBuilder authenticationManagerBuilder =
            http.getSharedObject(AuthenticationManagerBuilder.class);
        authenticationManagerBuilder.authenticationProvider(customAuthenticationProvider);
        return authenticationManagerBuilder.build();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    	HttpSessionSecurityContextRepository repository = new HttpSessionSecurityContextRepository();

        http
	        .csrf(AbstractHttpConfigurer::disable)		// CSRF 보호 비활성화
	        .formLogin(AbstractHttpConfigurer::disable)	// Form 인증 비활성화
	        .cors(cors -> cors.configurationSource(corsConfigurationSource))

	        .addFilterBefore(exceptionHandlingFilter, LogoutFilter.class)
        	.addFilterBefore(_getJsonLoginFilter(repository), UsernamePasswordAuthenticationFilter.class)

        	.securityContext(Context -> Context.securityContextRepository(repository)) // JSON 인증 Context

            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html", "/swagger-resources/**", "/webjars/**").permitAll() // swagger-ui 요청
                .requestMatchers("/css/**", "/js/**").permitAll() // 정적 리소스 요청
                .requestMatchers(commonProperties.getSecurity().getSkipUris().toArray(new String[0])).permitAll()
                .anyRequest().access(customAuthorizationManager)
            )

            .logout(logout -> logout
                .logoutUrl("/user/logout")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .logoutSuccessHandler(logoutResponseHandler)
            )

            .exceptionHandling(exception -> exception
            	.authenticationEntryPoint(authenticationExceptionHandler)
            	.accessDeniedHandler(accessDeniedExceptionHandler)
            )

            .headers(headers -> headers
                    .frameOptions(frame -> frame.deny()) // X-Frame-Options: DENY (클릭재킹 방지)
                    .contentSecurityPolicy(csp -> csp
                        .policyDirectives("default-src 'self'; "
                            + "script-src 'self'; "
                            + "style-src 'self' 'unsafe-inline'; "
                            + "img-src 'self' data:; "
                            + "font-src 'self'; "
                            + "frame-ancestors 'self';")
                    )
                );

        return http.build();
    }


    private JsonLoginFilter _getJsonLoginFilter(SecurityContextRepository repository) throws Exception {
        JsonLoginFilter filter = new JsonLoginFilter();
        filter.setAuthenticationManager(authenticationConfiguration.getAuthenticationManager());
        filter.setFilterProcessesUrl("/user/login");
        filter.setSecurityContextRepository(repository);
        filter.setAuthenticationSuccessHandler(loginSuccessHandler);
        filter.setAuthenticationFailureHandler(loginFailureHandler);
        return filter;
    }
}
