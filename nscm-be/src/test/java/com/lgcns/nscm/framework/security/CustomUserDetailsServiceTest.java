package com.lgcns.nscm.framework.security;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Collections;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.lgcns.nscm.admin.menu.MenuService;
import com.lgcns.nscm.admin.user.User;
import com.lgcns.nscm.admin.user.UserService;

@ExtendWith(MockitoExtension.class)
class CustomUserDetailsServiceTest {

    @Mock
    private UserService userService;
    @Mock
    private MenuService menuService;

    @InjectMocks
    private CustomUserDetailsService service;

    @Test
    @DisplayName("미등록 사용자면 실제 사번을 유지한 Guest 로 폴백한다")
    void guestFallbackWhenUserNotFound() throws Exception {
        when(userService.retrieveUser("kim")).thenReturn(null);
        when(menuService.retrieveMenus("GUEST")).thenReturn(Collections.emptyList());

        CustomUserDetails details = (CustomUserDetails) service.loadUserByUsername("kim");

        assertTrue(details.isGuest());
        assertEquals("kim", details.getUserId());   // 로그/이력 귀속용 실제 사번 유지
        assertEquals("Guest", details.getUserNm());
        verify(menuService).retrieveMenus("GUEST");  // GUEST 그룹 메뉴 로드
    }

    @Test
    @DisplayName("등록 사용자면 기존대로 본인 정보/메뉴로 로그인한다")
    void normalLoginWhenUserExists() throws Exception {
        User user = User.builder().userId("minyonglee1").userNm("이민용").userEngNm("Lee")
                .langCd("KO").build();
        when(userService.retrieveUser("minyonglee1")).thenReturn(user);
        when(menuService.retrieveMenus("minyonglee1")).thenReturn(Collections.emptyList());

        CustomUserDetails details = (CustomUserDetails) service.loadUserByUsername("minyonglee1");

        assertFalse(details.isGuest());
        assertEquals("minyonglee1", details.getUserId());
        verify(menuService).retrieveMenus("minyonglee1");
    }

    @Test
    @DisplayName("조회 중 DB 오류가 나면 게스트로 새지 않고 예외를 던진다")
    void throwsWhenRetrieveFails() throws Exception {
        when(userService.retrieveUser("kim")).thenThrow(new RuntimeException("DB down"));

        assertThrows(UsernameNotFoundException.class, () -> service.loadUserByUsername("kim"));
    }
}
