import type {
  AdminProfileQuery,
  ContactChannel,
  HouseContract,
  HouseFavorite,
  HouseOrder,
  IdentityVerification,
  PageResult,
  StatusPayload,
  UserWallet,
  ViewingRecord,
  WalletRecord,
} from './types';

import { haokeDelete, haokeGet, haokePost, haokePut } from './client';

const base = '/api/admin/profile';

export function queryViewingRecordsApi(data: AdminProfileQuery) {
  return haokePost<PageResult<ViewingRecord>>(`${base}/viewing/page`, data);
}

export function updateViewingRecordStatusApi(id: string, data: StatusPayload) {
  return haokePut<void>(`${base}/viewing/${id}/status`, data);
}

export function deleteViewingRecordApi(id: string) {
  return haokeDelete<void>(`${base}/viewing/${id}`);
}

export function queryHouseOrdersApi(data: AdminProfileQuery) {
  return haokePost<PageResult<HouseOrder>>(`${base}/orders/page`, data);
}

export function updateHouseOrderStatusApi(id: string, data: StatusPayload) {
  return haokePut<void>(`${base}/orders/${id}/status`, data);
}

export function queryHouseFavoritesApi(data: AdminProfileQuery) {
  return haokePost<PageResult<HouseFavorite>>(`${base}/favorites/page`, data);
}

export function deleteHouseFavoriteApi(id: string) {
  return haokeDelete<void>(`${base}/favorites/${id}`);
}

export function queryIdentityVerificationsApi(data: AdminProfileQuery) {
  return haokePost<PageResult<IdentityVerification>>(
    `${base}/identities/page`,
    data,
  );
}

export function updateIdentityVerificationStatusApi(
  id: string,
  data: StatusPayload,
) {
  return haokePut<void>(`${base}/identities/${id}/status`, data);
}

export function queryHouseContractsApi(data: AdminProfileQuery) {
  return haokePost<PageResult<HouseContract>>(`${base}/contracts/page`, data);
}

export function updateHouseContractStatusApi(id: string, data: StatusPayload) {
  return haokePut<void>(`${base}/contracts/${id}/status`, data);
}

export function queryUserWalletsApi(data: AdminProfileQuery) {
  return haokePost<PageResult<UserWallet>>(`${base}/wallets/page`, data);
}

export function queryWalletRecordsApi(data: AdminProfileQuery) {
  return haokePost<PageResult<WalletRecord>>(
    `${base}/wallet-records/page`,
    data,
  );
}

export function queryContactChannelsApi() {
  return haokeGet<ContactChannel[]>(`${base}/contact-channels`);
}
