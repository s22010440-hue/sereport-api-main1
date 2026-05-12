package com.ms.semicolans.sereportapi.sereportapi.service.impl;

import com.ms.semicolans.sereportapi.sereportapi.auth.ApplicationUser;
import com.ms.semicolans.sereportapi.sereportapi.entity.main.CompanyDetails;
import com.ms.semicolans.sereportapi.sereportapi.repo.CompanyDetailsRepo;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

import static com.ms.semicolans.sereportapi.sereportapi.security.ApplicationUserRole.*;

@Service
@RequiredArgsConstructor
public class ApplicationUserServiceImpl implements UserDetailsService {
    private final CompanyDetailsRepo companyDetailsRepo;


    @Override
    public UserDetails loadUserByUsername(String username)
            throws UsernameNotFoundException {
        Optional<CompanyDetails> systemUser = companyDetailsRepo.findByUserName(username);
        if (systemUser.isPresent()) {
            return buildApplicationUserForSystemUser(systemUser.get());
        }else {

            throw new UsernameNotFoundException(String.format("username %s not found", username));
        }


    }


    private ApplicationUser buildApplicationUserForSystemUser(CompanyDetails systemUser) {

        Set<SimpleGrantedAuthority> grantedAuthorities = new HashSet<>();


        if (systemUser.getUserType().trim().equals("Admin") || systemUser.getUserType().trim().equals("ADMIN")) {
            grantedAuthorities.addAll(ADMIN.getGrantedAuthorities());
        }
        boolean isActive;
        if (systemUser.getStatus().trim().equalsIgnoreCase("Active")) {
            isActive = true;
        } else {
            isActive = false;
        }
        ApplicationUser user = null;
        user = new ApplicationUser(
                systemUser.getPassword().trim(),
                systemUser.getUsername(),
                grantedAuthorities,
                true,
                true,
                true,
                isActive,
                systemUser.getCompanyId()

        );
        return user;
    }
}
