package com.zp.haoke.house.service;

import com.zp.haoke.framework.core.domain.response.PageVO;
import com.zp.haoke.house.domain.dto.FavoriteCreateDTO;
import com.zp.haoke.house.domain.dto.HouseOrderCreateDTO;
import com.zp.haoke.house.domain.dto.IdentityVerificationSubmitDTO;
import com.zp.haoke.house.domain.dto.ProfilePageQueryDTO;
import com.zp.haoke.house.domain.dto.ViewingRecordCreateDTO;
import com.zp.haoke.house.domain.dto.WalletTradeDTO;
import com.zp.haoke.house.domain.vo.ContactChannelVO;
import com.zp.haoke.house.domain.vo.HouseContractVO;
import com.zp.haoke.house.domain.vo.HouseFavoriteVO;
import com.zp.haoke.house.domain.vo.HouseOrderVO;
import com.zp.haoke.house.domain.vo.IdentityVerificationVO;
import com.zp.haoke.house.domain.vo.ViewingRecordVO;
import com.zp.haoke.house.domain.vo.WalletOverviewVO;

import java.util.List;

public interface IProfileFeatureService {
    PageVO<ViewingRecordVO> queryViewingRecords(String userId, ProfilePageQueryDTO queryDTO);

    ViewingRecordVO createViewingRecord(String userId, ViewingRecordCreateDTO createDTO);

    PageVO<HouseOrderVO> queryOrders(String userId, ProfilePageQueryDTO queryDTO);

    HouseOrderVO createOrder(String userId, HouseOrderCreateDTO createDTO);

    PageVO<HouseFavoriteVO> queryFavorites(String userId, ProfilePageQueryDTO queryDTO);

    HouseFavoriteVO createFavorite(String userId, FavoriteCreateDTO createDTO);

    Boolean deleteFavorite(String userId, String houseId);

    Boolean isFavorite(String userId, String houseId);

    IdentityVerificationVO getIdentityVerification(String userId);

    IdentityVerificationVO submitIdentityVerification(String userId, IdentityVerificationSubmitDTO submitDTO);

    PageVO<HouseContractVO> queryContracts(String userId, ProfilePageQueryDTO queryDTO);

    HouseContractVO getContract(String userId, String id);

    HouseContractVO getContractByOrderId(String userId, String orderId);

    HouseContractVO signContract(String userId, String id);

    WalletOverviewVO getWallet(String userId);

    WalletOverviewVO recharge(String userId, WalletTradeDTO tradeDTO);

    WalletOverviewVO withdraw(String userId, WalletTradeDTO tradeDTO);

    List<ContactChannelVO> queryContactChannels();
}
