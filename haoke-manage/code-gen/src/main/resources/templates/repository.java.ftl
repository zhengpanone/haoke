package com.yourcompany.${package.ModuleName}.domain.repository;

import com.yourcompany.${package.ModuleName}.domain.model.${entity}Entity;
import java.util.List;
import java.util.Optional;

public interface ${entity}Repository {

${entity}Entity save(${entity}Entity entity);

Optional<${entity}Entity> findById(Long id);

    List<${entity}Entity> findAll();

        void deleteById(Long id);

        boolean existsById(Long id);
        }