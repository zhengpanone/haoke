package com.zp.haoke.house.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.zp.haoke.house.domain.dto.HouseEstateCreateDTO;
import com.zp.haoke.house.domain.dto.HouseEstateQueryDTO;
import com.zp.haoke.house.domain.dto.HouseEstateUpdateDTO;
import com.zp.haoke.house.domain.po.HouseEstatePO;
import com.zp.haoke.house.domain.vo.HouseEstateVO;

import java.util.List;

/**
 * @author : zhengpanone
 * Date : 2026/3/16 22:23
 * Version : v1.0.0
 * Description:
 */
public interface IHouseEstateService extends IService<HouseEstatePO> {

    /**
     * 创建楼盘
     *
     * @param createDTO
     * @return
     */
    HouseEstateVO createHouseEstate(HouseEstateCreateDTO createDTO);

    /**
     * 查询楼盘
     *
     * @param id
     * @return
     */
    HouseEstateVO queryById(String id);

    /**
     * 更新楼盘
     *
     * @param estateUpdateDTO
     * @return
     */
    HouseEstateVO updateById(HouseEstateUpdateDTO estateUpdateDTO);

    /**
     * 删除楼盘
     *
     * @param id
     * @return
     */
    boolean deleteHouseEstate(String id);

    List<HouseEstateVO> queryPageList(HouseEstateQueryDTO queryDTO);

}
