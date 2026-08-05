package com.lgcns.nscm.framework.security;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.lgcns.nscm.admin.menu.MenuService;
import com.lgcns.nscm.framework.base.BaseConstants;
import com.lgcns.nscm.admin.menu.dto.MenuDto;
import com.lgcns.nscm.admin.user.User;
import com.lgcns.nscm.admin.user.UserService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserService userService;
    private final MenuService menuService;


    // 요청 받은 User 정보를 찾아서 인증 객체 반환
    @Override
    public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {

    	User user;

    	try {
    		user = userService.retrieveUser(userId);
		} catch (Exception e) {
			throw new UsernameNotFoundException("User not found: " + userId);
		}

        if (user == null) {
            // Case 3: 미등록 사용자 → 임시 Guest (DB 미저장).
            // username 에 실제 사번을 유지해 로그/접속이력이 본래 계정으로 남게 한다.
            log.info("미등록 사용자 게스트 폴백 로그인. userId={}", userId);
            return CustomUserDetails.builder()
                .username(userId)
                .password("")
                .userNm("Guest")
                .userEngNm("Guest")
                .langCd("KO")
                .isGuest(true)
                .menus(retrieveMenusSafely(BaseConstants.GUEST_USER_ID))
                .groups(retrieveGroupsSafely(BaseConstants.GUEST_USER_ID))
                .div(retrieveDivSafely(BaseConstants.GUEST_USER_ID))
                .authorities(Collections.emptyList())
                .build();
        }

        // Case 1/2: 등록 사용자. 단 그룹이 GUEST 뿐(또는 없음)이면 권한 미부여 상태 → 게스트로 취급.
        List<String> groups = retrieveGroupsSafely(user.getUserId());
        return CustomUserDetails.builder()
            .username(user.getUserId())
            .password("")
            .userNm(user.getUserNm())
            .userEngNm(user.getUserEngNm())
            .langCd(user.getLangCd())
            .isGuest(isGuestOnly(groups))
            .menus(retrieveMenusSafely(user.getUserId()))
            .groups(groups)
            .div(retrieveDivSafely(user.getUserId()))
            .authorities(Collections.emptyList())
            .build();
    }

    /** 그룹이 없거나 전부 GUEST 그룹이면 게스트(권한 미부여)로 본다. */
    private boolean isGuestOnly(List<String> groups) {
        if (groups == null || groups.isEmpty()) return true;
        return groups.stream().allMatch(g -> BaseConstants.GUEST_GROUP_NM.equalsIgnoreCase(g));
    }

    private List<MenuDto> retrieveMenusSafely(String userId) {
        try {
            return menuService.retrieveMenus(userId);
        } catch (Exception e) {
            log.info("menu retrieve exception. userId={}", userId);
            return new ArrayList<>();
        }
    }

    private List<String> retrieveGroupsSafely(String userId) {
        try {
            return userService.retrieveUserGroups(userId);
        } catch (Exception e) {
            log.info("group retrieve exception. userId={}", userId);
            return new ArrayList<>();
        }
    }

    private String retrieveDivSafely(String userId) {
        try {
            return userService.retrieveUserDefaultDiv(userId);
        } catch (Exception e) {
            log.info("div retrieve exception. userId={}", userId);
            return null;
        }
    }
}
