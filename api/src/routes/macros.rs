#[macro_export]
macro_rules! get_routes {
    ( $( $route:ident ),+ ) => {
        $(
            mod $route;
        )*

        pub fn main() -> Vec<(&'static str, axum::routing::MethodRouter)> {
            let routes: Vec<_> = vec![
                $(
                    $route::main(),
                )+
            ];

            routes
        }
    };
}

#[macro_export]
macro_rules! merge_routes {
    ( $( $route:ident ),+ ) => {
        {

            let mut merged_routes = vec![];

            $(
                merged_routes.extend($route::main());
            )+

            merged_routes
        }
    };
}
