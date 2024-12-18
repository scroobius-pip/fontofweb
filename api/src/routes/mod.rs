use crate::merge_routes;
use axum::Router;
mod macros;

mod page;
mod usage;

pub fn build_router() -> Router {
    let routes = merge_routes!(usage, page);
    routes.into_iter().fold(Router::new(), |router, route| {
        log::info!("Route: {}", route.0);
        router.route(route.0, route.1)
    })
}
