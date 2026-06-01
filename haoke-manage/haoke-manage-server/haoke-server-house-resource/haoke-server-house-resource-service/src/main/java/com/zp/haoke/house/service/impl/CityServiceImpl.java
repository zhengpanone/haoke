package com.zp.haoke.house.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zp.haoke.house.domain.dto.CityCreateDTO;
import com.zp.haoke.house.domain.dto.CityQueryDTO;
import com.zp.haoke.house.domain.dto.CityUpdateDTO;
import com.zp.haoke.house.domain.po.CityPO;
import com.zp.haoke.house.domain.vo.CityVO;
import com.zp.haoke.house.mapper.CityMapper;
import com.zp.haoke.house.service.ICityService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class CityServiceImpl extends ServiceImpl<CityMapper, CityPO> implements ICityService {
    private static final String ROOT_PARENT_ID = "0";

    @Override
    public CityVO createCity(CityCreateDTO createDTO) {
        CityPO cityPO = toPO(createDTO);
        cityPO.setId(UUID.randomUUID().toString().replace("-", ""));
        cityPO.setCreateTime(LocalDateTime.now());
        cityPO.setUpdateTime(LocalDateTime.now());
        baseMapper.insert(cityPO);
        return toVO(cityPO);
    }

    @Override
    public CityVO updateCity(CityUpdateDTO updateDTO) {
        CityPO cityPO = toPO(updateDTO);
        cityPO.setId(updateDTO.getId());
        cityPO.setUpdateTime(LocalDateTime.now());
        baseMapper.updateById(cityPO);
        return queryById(updateDTO.getId());
    }

    @Override
    public CityVO queryById(String id) {
        return toVO(baseMapper.selectById(id));
    }

    @Override
    public List<CityVO> queryList(CityQueryDTO queryDTO) {
        CityQueryDTO safeQuery = queryDTO == null ? new CityQueryDTO() : queryDTO;
        LambdaQueryWrapper<CityPO> wrapper = buildQueryWrapper(safeQuery);
        return baseMapper.selectList(wrapper).stream().map(this::toVO).toList();
    }

    @Override
    public List<CityVO> queryTree() {
        List<CityVO> nodes = baseMapper.selectList(orderWrapper()).stream().map(this::toVO).toList();
        Map<String, CityVO> nodeMap = new LinkedHashMap<>();
        List<CityVO> roots = new ArrayList<>();

        for (CityVO node : nodes) {
            nodeMap.put(node.getId(), node);
        }

        for (CityVO node : nodes) {
            String parentId = normalizeParentId(node.getParentId());
            CityVO parent = nodeMap.get(parentId);
            if (ROOT_PARENT_ID.equals(parentId) || parent == null) {
                roots.add(node);
            } else {
                parent.getChildren().add(node);
            }
        }

        return roots;
    }

    @Override
    public List<CityVO> queryHot() {
        CityQueryDTO queryDTO = new CityQueryDTO();
        queryDTO.setHot(true);
        queryDTO.setLevel(2);
        return queryList(queryDTO);
    }

    @Override
    public boolean deleteCity(String id) {
        List<String> ids = new ArrayList<>();
        collectDescendantIds(id, ids);
        return baseMapper.deleteBatchIds(ids) > 0;
    }

    private LambdaQueryWrapper<CityPO> buildQueryWrapper(CityQueryDTO queryDTO) {
        LambdaQueryWrapper<CityPO> wrapper = orderWrapper();
        if (StringUtils.hasText(queryDTO.getKeyword())) {
            wrapper.like(CityPO::getName, queryDTO.getKeyword());
        }
        if (StringUtils.hasText(queryDTO.getParentId())) {
            wrapper.eq(CityPO::getParentId, normalizeParentId(queryDTO.getParentId()));
        }
        if (queryDTO.getLevel() != null) {
            wrapper.eq(CityPO::getLevel, queryDTO.getLevel());
        }
        if (queryDTO.getHot() != null) {
            wrapper.eq(CityPO::getHot, queryDTO.getHot());
        }
        return wrapper;
    }

    private LambdaQueryWrapper<CityPO> orderWrapper() {
        return new LambdaQueryWrapper<CityPO>()
                .orderByAsc(CityPO::getLevel)
                .orderByAsc(CityPO::getSort)
                .orderByAsc(CityPO::getCreateTime);
    }

    private void collectDescendantIds(String id, List<String> ids) {
        ids.add(id);
        List<CityPO> children = baseMapper.selectList(
                new LambdaQueryWrapper<CityPO>().eq(CityPO::getParentId, id));
        for (CityPO child : children) {
            collectDescendantIds(child.getId(), ids);
        }
    }

    private CityPO toPO(CityCreateDTO dto) {
        CityPO cityPO = new CityPO();
        cityPO.setName(dto.getName());
        cityPO.setCode(dto.getCode());
        cityPO.setParentId(normalizeParentId(dto.getParentId()));
        cityPO.setLevel(dto.getLevel());
        cityPO.setSort(dto.getSort() == null ? 0 : dto.getSort());
        cityPO.setHot(Boolean.TRUE.equals(dto.getHot()));
        return cityPO;
    }

    private CityVO toVO(CityPO po) {
        if (po == null) {
            return null;
        }
        CityVO vo = new CityVO();
        vo.setId(po.getId());
        vo.setName(po.getName());
        vo.setCode(po.getCode());
        vo.setParentId(po.getParentId());
        vo.setLevel(po.getLevel());
        vo.setSort(po.getSort());
        vo.setHot(po.getHot());
        return vo;
    }

    private String normalizeParentId(String parentId) {
        return StringUtils.hasText(parentId) ? parentId : ROOT_PARENT_ID;
    }
}
