use axum::{http::StatusCode, Json};
use axum_typed_routing_macros::route;

use crate::entities::page::{Page, PageInfo};

#[route(GET "/usage?domain&path")]
pub async fn main(
    domain: String,
    path: Option<String>,
) -> Result<(StatusCode, Json<PageInfo>), StatusCode> {
    Ok((StatusCode::OK, Json(PageInfo::default())))
}
