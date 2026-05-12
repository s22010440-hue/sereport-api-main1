package com.ms.semicolans.sereportapi.sereportapi.jwt;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Date;
import java.util.Optional;

import javax.crypto.SecretKey;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ms.semicolans.sereportapi.sereportapi.entity.main.CompanyDetails;
import com.ms.semicolans.sereportapi.sereportapi.repo.CompanyDetailsRepo;

import io.jsonwebtoken.Jwts;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class JwtUsernameAndPasswordAuthenticationFilter
        extends UsernamePasswordAuthenticationFilter {

    private final AuthenticationManager authenticationManager;
    private final JwtConfig jwtConfig;
    private final SecretKey secretKey;
    private final CompanyDetailsRepo companyDetailsRepo;

    public JwtUsernameAndPasswordAuthenticationFilter(
            AuthenticationManager authenticationManager,
            JwtConfig jwtConfig,
            SecretKey secretKey,
            CompanyDetailsRepo companyDetailsRepo) {
        this.authenticationManager = authenticationManager;
        this.jwtConfig = jwtConfig;
        this.secretKey = secretKey;
        this.companyDetailsRepo = companyDetailsRepo;
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request,
                                                HttpServletResponse response)
            throws AuthenticationException {
        try {
            UsernameAndPasswordAuthenticationRequest authenticationRequest =
                    new ObjectMapper().readValue(request.getInputStream(),
                            UsernameAndPasswordAuthenticationRequest.class);

            // ── PIN NUMBER CHECK ──────────────────────────────────────
            String providedPin = authenticationRequest.getPinnumber();
            if (providedPin == null || providedPin.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("Pin number is required");
                return null;
            }
            Optional<CompanyDetails> user = companyDetailsRepo
                    .findByUserName(authenticationRequest.getUsername());
            if (user.isEmpty() || user.get().getPinnumber() == null ||
                    !user.get().getPinnumber().trim().equals(providedPin.trim())) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("Invalid pin number");
                return null;
            }
            // ─────────────────────────────────────────────────────────

            Authentication authentication = new UsernamePasswordAuthenticationToken(
                    authenticationRequest.getUsername(),
                    authenticationRequest.getPassword()
            );
            return authenticationManager.authenticate(authentication);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void successfulAuthentication(HttpServletRequest request,
                                            HttpServletResponse response,
                                            FilterChain chain,
                                            Authentication authResult)
            throws IOException, ServletException {
        String token = Jwts.builder()
                .setSubject(authResult.getName())
                .claim("authorities", authResult.getAuthorities())
                .setIssuedAt(new Date())
                .setExpiration(java.sql.Date.valueOf(LocalDate.now()
                        .plusDays(jwtConfig.getTokenExpirationAfterDays())))
                .signWith(secretKey)
                .compact();
        response.addHeader(jwtConfig.getAuthorizationHeader(),
                jwtConfig.getTokenPrefix() + token);
    }
}