package com.zp.haoke.house.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.zp.haoke.house.domain.dto.HouseEstateUpdateDTO;
import com.zp.haoke.house.domain.dto.HouseResourceUpdateDTO;
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
     * @param houseEstatePO
     * @return
     */
    int createHouseEstate(HouseEstatePO houseEstatePO);

    /**
     * 查询楼盘
     *
     * @param id
     * @return
     */
    HouseEstatePO queryById(String id);

    /**
     * 更新楼盘
     *
     * @param estateUpdateDTO
     * @return
     */
    int updateById(HouseEstateUpdateDTO estateUpdateDTO);

    /**
     * 删除楼盘
     *
     * @param id
     * @return
     */
    int deleteHouseEstate(String id);

    List<HouseEstateVO> queryPageList();

}
