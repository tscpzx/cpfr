package com.ts.cpfr.spring.security;

import org.apache.log4j.LogManager;
import org.springframework.security.access.AccessDecisionManager;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.authentication.InsufficientAuthenticationException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.Iterator;

/**
 * 进行决策，根据URL获得访问这个资源所需要的权限，然后在与当前用户所拥有的权限进行对比
 * 如果当前用户拥有相关权限，就直接返回，否则抛出 AccessDeniedException异常
 * @author weilu2
 * @date 2016年12月17日 上午11:30:40
 *
 */
@Component
public class CustomAccessDecisionManager implements AccessDecisionManager {

    @Override
    public void decide(Authentication authentication, Object object, Collection<ConfigAttribute> configAttributes)
      throws AccessDeniedException, InsufficientAuthenticationException {

        LogManager.getLogger("CustomAccessDecisionManager").info("decide invoke");

        if (configAttributes == null) {
            return;
        }

        if (configAttributes.size() <= 0) {
            return;
        }

        Iterator<ConfigAttribute> authorities = configAttributes.iterator();
        String needAuthority = null;

        while(authorities.hasNext()) {
            ConfigAttribute authority = authorities.next();

            if (authority == null || (needAuthority = authority.getAttribute()) == null) {
                continue;
            }

            LogManager.getLogger("CustomAccessDecisionManager").info("decide == " + needAuthority);

            for (GrantedAuthority ga : authentication.getAuthorities()) {
                if (needAuthority.equals(ga.getAuthority().trim())) {
                    return;
                }
            }
        }
        throw new AccessDeniedException("No Authority");
    }

    @Override
    public boolean supports(ConfigAttribute attribute) {
        return true;
    }

    @Override
    public boolean supports(Class<?> clazz) {
        return true;
    }

}
