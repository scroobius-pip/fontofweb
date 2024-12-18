use crate::entities::page::{Page, PageInfo};
use axum::{http::StatusCode, Json};
use axum_typed_routing_macros::route;

struct Report {}

#[route(POST "/report")]
pub async fn main() -> StatusCode {
    StatusCode::OK
}
