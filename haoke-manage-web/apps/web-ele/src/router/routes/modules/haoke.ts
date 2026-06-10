import type { RouteRecordRaw } from 'vue-router';

const routes: RouteRecordRaw[] = [
  {
    meta: {
      icon: 'lucide:building-2',
      order: 10,
      title: '好客业务',
    },
    name: 'HaokeBusiness',
    path: '/haoke',
    children: [
      {
        component: () => import('#/views/haoke/recommend-houses/index.vue'),
        meta: {
          icon: 'lucide:home',
          title: '推荐房源管理',
        },
        name: 'HaokeRecommendHouses',
        path: '/haoke/recommend-houses',
      },
      {
        component: () => import('#/views/haoke/news/index.vue'),
        meta: {
          icon: 'lucide:newspaper',
          title: '最新资讯管理',
        },
        name: 'HaokeNews',
        path: '/haoke/news',
      },
    ],
  },
];

export default routes;
