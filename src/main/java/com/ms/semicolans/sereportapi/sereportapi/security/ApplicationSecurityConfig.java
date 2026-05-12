package com.ms.semicolans.sereportapi.sereportapi.security;

import java.util.List;

import javax.crypto.SecretKey;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import com.ms.semicolans.sereportapi.sereportapi.jwt.JwtConfig;
import com.ms.semicolans.sereportapi.sereportapi.jwt.JwtTokenVerifier;
import com.ms.semicolans.sereportapi.sereportapi.jwt.JwtUsernameAndPasswordAuthenticationFilter;
import com.ms.semicolans.sereportapi.sereportapi.repo.CompanyDetailsRepo;
import com.ms.semicolans.sereportapi.sereportapi.service.impl.ApplicationUserServiceImpl;

@Configuration
@EnableMethodSecurity
public class ApplicationSecurityConfig {
    private final PasswordEncoder passwordEncoder;
    private final ApplicationUserServiceImpl applicationUserService;
    private final JwtConfig jwtConfig;
    private final SecretKey secretKey;
    private final AuthenticationConfiguration authenticationConfiguration;
    private final CompanyDetailsRepo companyDetailsRepo;

    public ApplicationSecurityConfig(
            PasswordEncoder passwordEncoder,
            ApplicationUserServiceImpl applicationUserService,
            JwtConfig jwtConfig,
            SecretKey secretKey,
            AuthenticationConfiguration authenticationConfiguration,
            CompanyDetailsRepo companyDetailsRepo) {
        this.passwordEncoder = passwordEncoder;
        this.applicationUserService = applicationUserService;
        this.jwtConfig = jwtConfig;
        this.secretKey = secretKey;
        this.authenticationConfiguration = authenticationConfiguration;
        this.companyDetailsRepo = companyDetailsRepo;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable())
                .cors(httpSecurityCorsConfigurer ->
                        httpSecurityCorsConfigurer.configurationSource(corsConfigurationSource()))
                .sessionManagement(session ->
                        session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .addFilter(new JwtUsernameAndPasswordAuthenticationFilter(
                        authenticationConfiguration.getAuthenticationManager(),
                        jwtConfig,
                        secretKey,
                        companyDetailsRepo))
                .addFilterAfter(new JwtTokenVerifier(jwtConfig, secretKey),
                        JwtUsernameAndPasswordAuthenticationFilter.class)
                .authorizeHttpRequests(authz -> authz
                        .requestMatchers(
                                "/api/v1/users/register/**",
                                "/api/v1/users/verify/**",
                                "/api/v1/users/resend/**",
                                "/api/v1/users/verify-reset/**",
                                "/api/v1/users/reset-password/**",
                                "/api/v1/users/forgot-password-verify/**",
                                "/api/v1/*/visitor/**",
                                "/api/v1/test/**",
                                "/swagger-ui.html",
                                "/swagger-ui/**",
                                "/v3/api-docs/**",
                                "/webjars/**")
                        .permitAll()
                        .anyRequest().authenticated());

        http.authenticationProvider(authenticationProvider());

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration corsConfiguration = new CorsConfiguration();
        corsConfiguration.setAllowedHeaders(List.of("Authorization", "Cache-Control", "Content-Type"));
        corsConfiguration.setAllowedOrigins(List.of("*"));
        corsConfiguration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"));
        corsConfiguration.setAllowCredentials(false);
        corsConfiguration.setExposedHeaders(List.of("Authorization"));
        corsConfiguration.setMaxAge(3600L);
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", corsConfiguration);
        return source;
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setPasswordEncoder(NoOpPasswordEncoder.getInstance());
        provider.setUserDetailsService(applicationUserService);
        return provider;
    }
}