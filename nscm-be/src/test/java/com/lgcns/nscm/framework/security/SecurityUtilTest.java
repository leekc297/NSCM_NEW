package com.lgcns.nscm.framework.security;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.Collections;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;

import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.framework.utils.SecurityUtil;

class SecurityUtilTest {

    @Test
    @DisplayName("게스트 CustomUserDetails 로 만든 세션은 isGuest=true 이고 userId 는 실제 사번이다")
    void mapsGuestSession() {
        CustomUserDetails guest = CustomUserDetails.builder()
                .username("kim")
                .password("")
                .userNm("Guest")
                .isGuest(true)
                .menus(Collections.emptyList())
                .authorities(Collections.emptyList())
                .build();
        Authentication auth = new UsernamePasswordAuthenticationToken(guest, "", Collections.emptyList());

        UserSession session = SecurityUtil.getUserSession(auth);

        assertTrue(session.isGuest());
        assertEquals("kim", session.getUserId()); // 로그/이력 본래 계정 보장
    }
}
