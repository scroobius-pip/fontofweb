use axum::{
    http::{HeaderMap, StatusCode},
    Json,
};
use axum_typed_routing_macros::route;
use serde::Serialize;

use crate::entities::page::Page;

#[route(GET "/usage?domain&path")]
pub async fn main(
    domain: String,
    path: Option<String>,
) -> Result<(StatusCode, Json<Page>), StatusCode> {
    Ok((StatusCode::OK, Json(Page { domain, path })))
}
