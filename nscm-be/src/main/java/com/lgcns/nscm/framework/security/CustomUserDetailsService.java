package com.lgcns.nscm.framework.security;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.lgcns.nscm.admin.menu.MenuService;
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

    	User user = null;

    	try {
    		user = userService.retrieveUser(userId);
		} catch (Exception e) {
			throw new UsernameNotFoundException("User not found: " + userId);
		}

        if (user == null) {
        	throw new UsernameNotFoundException("User not found: " + userId);
        }

        List<MenuDto> menus = new ArrayList<>();
        try {
        	menus = menuService.retrieveMenus(user.getUserId());
        	log.info("menus found");
        } catch (Exception e) {
			log.info("menu retrieve exception");
		}

        return CustomUserDetails.builder()
            .username(user.getUserId())
            .password("")
            .userNm(user.getUserNm())
            .userEngNm(user.getUserEngNm())
            .langCd(user.getLangCd())
            .menus(menus)
            .authorities(Collections.emptyList())
            .build();
    }
}
