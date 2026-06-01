package com.zp.haoke.house.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zp.haoke.house.domain.dto.HouseEstateCreateDTO;
import com.zp.haoke.house.domain.dto.HouseEstateQueryDTO;
import com.zp.haoke.house.domain.dto.HouseEstateUpdateDTO;
import com.zp.haoke.house.domain.po.HouseEstatePO;
import com.zp.haoke.house.domain.vo.HouseEstateVO;
import com.zp.haoke.house.mapper.HouseEstateMapper;
import com.zp.haoke.house.service.IHouseEstateService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * @author : zhengpanone
 * Date : 2026/3/16 22:26
 * Version : v1.0.0
 * Description: 房源管理服务类
 */
@Service
public class HouseEstateServiceImpl extends ServiceImpl<HouseEstateMapper, HouseEstatePO> implements IHouseEstateService {

    @Override
    public HouseEstateVO createHouseEstate(HouseEstateCreateDTO createDTO) {
        HouseEstatePO estatePO = toPO(createDTO);
        estatePO.setId(UUID.randomUUID().toString().replace("-", ""));
        estatePO.setCreateTime(LocalDateTime.now());
        estatePO.setUpdate_time(LocalDateTime.now());
        baseMapper.insert(estatePO);
        return toVO(estatePO);
    }

    @Override
    public HouseEstateVO queryById(String id) {
        return toVO(baseMapper.selectById(id));
    }

    @Override
    public HouseEstateVO updateById(HouseEstateUpdateDTO houseEstateUpdateDTO) {
        HouseEstatePO estatePO = toPO(houseEstateUpdateDTO);
        estatePO.setId(houseEstateUpdateDTO.getId());
        estatePO.setUpdate_time(LocalDateTime.now());
        baseMapper.updateById(estatePO);
        return queryById(houseEstateUpdateDTO.getId());
    }

    @Override
    public boolean deleteHouseEstate(String id) {
        return baseMapper.deleteById(id) > 0;
    }

    @Override
    public List<HouseEstateVO> queryPageList(HouseEstateQueryDTO queryDTO) {
        HouseEstateQueryDTO safeQuery = queryDTO == null ? new HouseEstateQueryDTO() : queryDTO;
        String keyword = safeQuery.getKeyword();
        int pageNum = safeQuery.getPageNum() == null || safeQuery.getPageNum() < 1 ? 1 : safeQuery.getPageNum();
        int pageSize = safeQuery.getPageSize() == null || safeQuery.getPageSize() < 1 ? 20 : safeQuery.getPageSize();
        LambdaQueryWrapper<HouseEstatePO> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            wrapper.and(query -> query
                    .like(HouseEstatePO::getName, keyword)
                    .or()
                    .like(HouseEstatePO::getAddress, keyword)
                    .or()
                    .like(HouseEstatePO::getArea, keyword)
                    .or()
                    .like(HouseEstatePO::getCity, keyword));
        }
        wrapper.orderByDesc(HouseEstatePO::getCreateTime);
        return baseMapper.selectPage(new Page<>(pageNum, pageSize), wrapper)
                .getRecords()
                .stream()
                .map(this::toVO)
                .toList();
    }

    private HouseEstatePO toPO(HouseEstateCreateDTO dto) {
        HouseEstatePO estatePO = new HouseEstatePO();
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

    private HouseEstateVO toVO(HouseEstatePO po) {
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
        vo.setCreated(po.getCreateTime());
        vo.setUpdated(po.getUpdate_time());
        return vo;
    }
}
