package com.ms.semicolans.sereportapi.sereportapi.api;

import com.ms.semicolans.sereportapi.sereportapi.service.UserService;
import com.ms.semicolans.sereportapi.sereportapi.util.StandardResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.sql.SQLException;

@RestController
@RequestMapping("/api/v1/user")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;


    @PreAuthorize("hasAnyRole('ROLE_ADMIN')")
    @GetMapping(path = {"/get-user-details"})
    public ResponseEntity<StandardResponse> getUserDetails
            (@RequestHeader("Authorization") String token) throws SQLException {
        return new ResponseEntity<>(
                new StandardResponse(200, "User details", userService.getUserDetails(token))
                , HttpStatus.OK);
    }
}
