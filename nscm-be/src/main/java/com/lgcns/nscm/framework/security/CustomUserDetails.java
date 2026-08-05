package com.lgcns.nscm.framework.security;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.lgcns.nscm.admin.menu.dto.MenuDto;

import lombok.Builder;

@Builder
public class CustomUserDetails implements UserDetails {

	private static final long serialVersionUID = 1L;

	private final String username;
	private final String password;
	private final String userNm;
	private final String userEngNm;
    private final Collection<? extends GrantedAuthority> authorities;
    private String langCd;
    private List<MenuDto> menus;
    private final boolean isGuest;
    private List<String> groups;
    private final String div;

    @Override
    public String getUsername() { return username; }

    @Override
    public String getPassword() { return password; }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    public String getUserId() { return username; }

    public String getUserNm() { return userNm; }

    public String getUserEngNm() { return userEngNm; }

    public String getLangCd() { return langCd; }

    public List<MenuDto> getMenus() { return menus; }

    public boolean isGuest() { return isGuest; }

    public List<String> getGroups() { return groups; }

    public String getDiv() { return div; }

    public void setLangCd(String langCd) { this.langCd = langCd; }

    public void setMenus(List<MenuDto> menus) { this.menus = menus; }

    @Override
    public boolean isAccountNonExpired() { return true; }

    @Override
    public boolean isAccountNonLocked() { return true; }

    @Override
    public boolean isCredentialsNonExpired() { return true; }

    @Override
    public boolean isEnabled() { return true; }
}
