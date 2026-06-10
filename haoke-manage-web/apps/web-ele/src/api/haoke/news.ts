import type {
  NewsArticle,
  NewsArticlePayload,
  NewsArticleQuery,
  PageResult,
} from './types';

import { haokeDelete, haokePost, haokePut } from './client';

export function createNewsArticleApi(data: NewsArticlePayload) {
  return haokePost<NewsArticle>('/api/admin/news/create', data);
}

export function deleteNewsArticleApi(id: string) {
  return haokeDelete<void>(`/api/admin/news/${id}`);
}

export function queryNewsArticlePageApi(data: NewsArticleQuery) {
  return haokePost<PageResult<NewsArticle>>('/api/admin/news/page', data);
}

export function updateNewsArticleApi(data: NewsArticlePayload) {
  return haokePut<NewsArticle>('/api/admin/news/update', data);
}

export function updateNewsArticleStatusApi(id: string, status: number) {
  return haokePut<void>(`/api/admin/news/${id}/status`, { status });
}
