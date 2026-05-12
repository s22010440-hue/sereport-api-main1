package com.ms.semicolans.sereportapi.sereportapi.entity.main;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@RequiredArgsConstructor
@AllArgsConstructor
@Table(name = "tbl_CompanyDetails")
public class CompanyDetails {
    @Id
    @Column(name = "CompID")
    private String companyId;

    @Column(name = "UserName")
    private String username;

    @Column(name = "CompName")
    private String companyName;

    @Column(name = "UserPassword")
    private String password;

    @Column(name = "UserType")
    private String userType;

    @Column(name = "Status")
    private String status;

    @Column(name = "pinnumber")   // ← ADDED THIS ONLY
    private String pinnumber;
}