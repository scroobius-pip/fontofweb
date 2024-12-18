#[macro_use]
extern crate dotenv_codegen;
extern crate dotenv;

use axum::http::{header, Method};
use db::DB;
use routes::build_router;
use tower::ServiceBuilder;
use tower_http::cors::{AllowOrigin, CorsLayer};
mod db;
mod entities;
mod routes;
mod transactions;

use env_logger::Env;

#[tokio::main(flavor = "multi_thread")]
async fn main() {
    println!("cargo::rerun-if-changed=.env");
    setup_logs();
    log::info!("HOST: {}", dotenv!("HOST"));

    let db = DB::new().await.expect("failed to create db connection");
    let cors = CorsLayer::new()
        .allow_methods([Method::GET, Method::POST, Method::DELETE])
        .allow_headers([header::ACCEPT, header::CONTENT_TYPE, header::COOKIE])
        .allow_credentials(true)
        .allow_origin(AllowOrigin::predicate(|origin, _| {
            origin.as_bytes().ends_with(b"fontofweb.com")
        }));

    #[cfg(debug_assertions)]
    let cors = cors.allow_origin(AllowOrigin::list(
        ["http://localhost:3000", "https://localhost:3000"]
            .iter()
            .flat_map(|origin| origin.parse()),
    ));
    let app = build_router().layer(cors);
    let add = format!("0.0.0.0:{}", dotenv!("PORT"));
    let listener = tokio::net::TcpListener::bind(add).await.unwrap();

    axum::serve(listener, app).await.unwrap();
}

fn get_font_data() {
    // let font_bytes = include_bytes!("rm_neue_bold.woff2");
    // assert!(is_woff2(font_bytes));
    // let ttf_font = convert_woff2_to_ttf(&mut font_bytes.as_slice()).unwrap();

    // let mut font = font::load(&mut &ttf_font[..]).unwrap();

    // if let Table::Name(name_table) = font.get_table(b"name").unwrap().unwrap() {
    //     for entry in &name_table.records {
    //         println!("{:?}", entry)
    //     }
    // }
}

fn setup_logs() {
    std::env::set_var("RUST_BACKTRACE", "1");
    env_logger::Builder::from_env(Env::default().default_filter_or("info")).init();
}
