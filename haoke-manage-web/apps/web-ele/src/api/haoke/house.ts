import type {
  HouseResource,
  HouseResourcePayload,
  HouseResourceQuery,
  PageResult,
} from './types';

import { haokeDelete, haokePost, haokePut } from './client';

export function createHouseResourceApi(data: HouseResourcePayload) {
  return haokePost<HouseResource>('/api/admin/house/resource/create', data);
}

export function deleteHouseResourceApi(id: string) {
  return haokeDelete<void>(`/api/admin/house/resource/${id}`);
}

export function queryHouseResourcePageApi(data: HouseResourceQuery) {
  return haokePost<PageResult<HouseResource>>(
    '/api/admin/house/resource/page',
    data,
  );
}

export function updateHouseResourceApi(data: HouseResourcePayload) {
  return haokePut<void>('/api/admin/house/resource/update', data);
}

export function updateHouseResourceStatusApi(id: string, status: string) {
  return haokePut<void>(`/api/admin/house/resource/${id}/status`, { status });
}
