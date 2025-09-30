import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:le_coin_des_cuisiniers_app/dashboard/dashboard_home.dart';
import 'package:le_coin_des_cuisiniers_app/views/home_page.dart';
import 'package:le_coin_des_cuisiniers_app/views/login.dart';

class Routes {
  GoRouter router = GoRouter(routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'home',
            builder: (BuildContext context, GoRouterState state) {
              return const HomePage();
            },
          ),
          // GoRoute(
          //   path: 'announcements/edit/:id',
          //   builder: (BuildContext context, GoRouterState state) {
          //     final id = int.parse(state.pathParameters['id']!);
          //     return EditAnnouncement(
          //       id: id,
          //     );
          //   },
          // ),
          GoRoute(
            path: 'dashboard',
            builder: (BuildContext context, GoRouterState state) {
              return const DashboardHome();
            },
            // routes: <RouteBase>[
            //   GoRoute(
            //     path: 'add',
            //     builder: (BuildContext context, GoRouterState state) {
            //       return const HomePage();
            //     },
            //   ),
            // ],
          ),
          GoRoute(
            path: 'commissions',
            builder: (BuildContext context, GoRouterState state) {
              return const HomePage();
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'add',
                builder: (BuildContext context, GoRouterState state) {
                  return const HomePage();
                },
              ),
            ],
          ),
          GoRoute(
            path: 'classes',
            builder: (BuildContext context, GoRouterState state) {
              return const HomePage();
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'add',
                builder: (BuildContext context, GoRouterState state) {
                  return const HomePage();
                },
              ),
            ],
          ),
          GoRoute(
            path: 'kingdom-homes',
            builder: (BuildContext context, GoRouterState state) {
              return const HomePage();
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'add',
                builder: (BuildContext context, GoRouterState state) {
                  return const HomePage();
                },
              ),
            ],
          ),
        ])
  ]);
}
