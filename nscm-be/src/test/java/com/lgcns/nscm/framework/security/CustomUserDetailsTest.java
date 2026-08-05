package com.lgcns.nscm.framework.security;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.Collections;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class CustomUserDetailsTest {

    @Test
    @DisplayName("isGuest=true 로 빌드하면 isGuest()가 true 를 반환한다")
    void isGuestTrue() {
        CustomUserDetails details = CustomUserDetails.builder()
                .username("kim")
                .password("")
                .isGuest(true)
                .authorities(Collections.emptyList())
                .build();

        assertTrue(details.isGuest());
    }

    @Test
    @DisplayName("isGuest 를 설정하지 않으면 기본값 false 이다")
    void isGuestDefaultsFalse() {
        CustomUserDetails details = CustomUserDetails.builder()
                .username("kim")
                .password("")
                .authorities(Collections.emptyList())
                .build();

        assertFalse(details.isGuest());
    }
}
