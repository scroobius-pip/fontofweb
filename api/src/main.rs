use axum::{
    async_trait,
    extract::FromRequestParts,
    http::{request::Parts, StatusCode},
    response::{IntoResponse, Response},
    routing::{get, post},
    Json, RequestPartsExt, Router,
};
use axum_extra::{
    headers::{authorization::Bearer, Authorization},
    TypedHeader,
};
use jsonwebtoken::{decode, encode, DecodingKey, EncodingKey, Header, Validation};
use once_cell::sync::Lazy;
use serde::{Deserialize, Serialize};
use serde_json::json;
use std::time::SystemTime;
use std::{error::Error, fmt::Display};

#[shuttle_runtime::main]
async fn main() -> shuttle_axum::ShuttleAxum {
    let app = Router::new().route("/", get(index));

    Ok(app.into())
}

#[derive(Serialize)]
struct FontInfo {
    text: String,
}

async fn index() -> Result<Json<FontInfo>, StatusCode> {
    let url = "https://www.nytimes.com/";
    let text = reqwest::get(url).await.unwrap().text().await.unwrap();
    // A public endpoint that anyone can access
    // "Welcome to the public area :)"
    Ok(Json(FontInfo { text }))
}
