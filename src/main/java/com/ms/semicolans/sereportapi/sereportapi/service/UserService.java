package com.ms.semicolans.sereportapi.sereportapi.service;

import com.ms.semicolans.sereportapi.sereportapi.dto.responsedto.ResponseUserDTO;

import java.sql.SQLException;

public interface UserService {
    String getUserDetails(String token) throws SQLException;
}
