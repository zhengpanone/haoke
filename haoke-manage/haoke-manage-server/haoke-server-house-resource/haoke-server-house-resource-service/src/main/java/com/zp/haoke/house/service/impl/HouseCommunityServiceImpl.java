package com.zp.haoke.house.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zp.haoke.house.domain.dto.HouseCommunityCreateDTO;
import com.zp.haoke.house.domain.dto.HouseCommunityQueryDTO;
import com.zp.haoke.house.domain.dto.HouseCommunityUpdateDTO;
import com.zp.haoke.house.domain.po.HouseCommunityPO;
import com.zp.haoke.house.domain.vo.HouseEstateVO;
import com.zp.haoke.house.mapper.HouseCommunityMapper;
import com.zp.haoke.house.service.IHouseCommunityService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.UUID;

/**
 * @author : zhengpanone
 * Date : 2026/3/16 22:26
 * Version : v1.0.0
 * Description: 房源管理服务类
 */
@Service
public class HouseCommunityServiceImpl extends ServiceImpl<HouseCommunityMapper, HouseCommunityPO> implements IHouseCommunityService {

    @Override
    public HouseEstateVO create(HouseCommunityCreateDTO createDTO) {
        HouseCommunityPO estatePO = toPO(createDTO);
        estatePO.setId(UUID.randomUUID().toString().replace("-", ""));
        baseMapper.insert(estatePO);
        return toVO(estatePO);
    }

    @Override
    public HouseEstateVO queryById(String id) {
        return toVO(baseMapper.selectById(id));
    }

    @Override
    public HouseEstateVO updateById(HouseCommunityUpdateDTO houseEstateUpdateDTO) {
        HouseCommunityPO estatePO = toPO(houseEstateUpdateDTO);
        estatePO.setId(houseEstateUpdateDTO.getId());
        baseMapper.updateById(estatePO);
        return queryById(houseEstateUpdateDTO.getId());
    }

    @Override
    public boolean delete(String id) {
        return baseMapper.deleteById(id) > 0;
    }

    @Override
    public List<HouseEstateVO> queryPageList(HouseCommunityQueryDTO queryDTO) {
        HouseCommunityQueryDTO safeQuery = queryDTO == null ? new HouseCommunityQueryDTO() : queryDTO;
        String keyword = safeQuery.getKeyword();
        int pageNum = safeQuery.getCurrentPage() == null || safeQuery.getCurrentPage() < 1 ? 1 : safeQuery.getCurrentPage();
        int pageSize = safeQuery.getPageSize() == null || safeQuery.getPageSize() < 1 ? 20 : safeQuery.getPageSize();
        LambdaQueryWrapper<HouseCommunityPO> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            wrapper.and(query -> query
                    .like(HouseCommunityPO::getName, keyword)
                    .or()
                    .like(HouseCommunityPO::getAddress, keyword)
                    .or()
                    .like(HouseCommunityPO::getArea, keyword)
                    .or()
                    .like(HouseCommunityPO::getCity, keyword));
        }
        wrapper.orderByDesc(HouseCommunityPO::getCreateTime);
        return baseMapper.selectPage(new Page<>(pageNum, pageSize), wrapper)
                .getRecords()
                .stream()
                .map(this::toVO)
                .toList();
    }

    private HouseCommunityPO toPO(HouseCommunityCreateDTO dto) {
        HouseCommunityPO estatePO = new HouseCommunityPO();
        estatePO.setName(dto.getName());
        estatePO.setProvince(dto.getProvince());
        estatePO.setCity(dto.getCity());
        estatePO.setArea(dto.getArea());
        estatePO.setAddress(dto.getAddress());
        estatePO.setYear(dto.getYear());
        estatePO.setType(dto.getType());
        estatePO.setPropertyCost(dto.getPropertyCost());
        estatePO.setPropertyCompany(dto.getPropertyCompany());
        estatePO.setDevelopers(dto.getDevelopers());
        return estatePO;
    }

    private HouseEstateVO toVO(HouseCommunityPO po) {
        if (po == null) {
            return null;
        }
        HouseEstateVO vo = new HouseEstateVO();
        vo.setId(po.getId());
        vo.setName(po.getName());
        vo.setProvince(po.getProvince());
        vo.setCity(po.getCity());
        vo.setArea(po.getArea());
        vo.setAddress(po.getAddress());
        vo.setYear(po.getYear());
        vo.setType(po.getType());
        vo.setPropertyCost(po.getPropertyCost());
        vo.setPropertyCompany(po.getPropertyCompany());
        vo.setDevelopers(po.getDevelopers());
        return vo;
    }
}
