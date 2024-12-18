use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Page {
    pub domain: String,
    // #[serde(default = "default_path")]
    pub path: Option<String>,
}

fn default_path() -> String {
    "/".to_string()
}

pub struct PageInfo {
    
}