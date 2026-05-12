package com.ms.semicolans.sereportapi.sereportapi.repo;

import com.ms.semicolans.sereportapi.sereportapi.entity.main.CompanyDetails;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.stereotype.Repository;

import java.util.Optional;

public interface CompanyDetailsRepo extends JpaRepository<CompanyDetails, String> {
    @Query(value = "SELECT * FROM tbl_CompanyDetails WHERE UserName=?1", nativeQuery = true)
    public Optional<CompanyDetails> findByUserName(String username);
}
