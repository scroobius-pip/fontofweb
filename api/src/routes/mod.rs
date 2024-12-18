use crate::merge_routes;
use axum::Router;
mod macros;

mod usage;

pub fn build_router() -> Router {
    let routes = merge_routes!(usage);
    routes.into_iter().fold(Router::new(), |router, route| {
        log::info!("Route: {}", route.0);
        router.route(route.0, route.1)
    })
}
