use std::collections::HashMap;

use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone, Default)]
pub struct Page {
    pub domain: String,
    pub path: Option<String>,
}

fn default_path() -> String {
    "/".to_string()
}

#[derive(Default, Serialize, Deserialize)]
pub struct PageInfo {
    page: Page,
    usage: Vec<FontUsage>,
    screenshot_count: u32,
}

#[derive(Debug, Serialize, Deserialize, Clone, Default)]
pub struct FontUsage {
    family: Family,
    sub_family: SubFamily,
    src: Option<String>,
    element_usage: Vec<ElementUsage>,
}

#[derive(Debug, Serialize, Deserialize, Clone, Default)]
pub struct Family {
    id: String,
    name: String,
    designer: Designer,
    manufacturer: Manufacturer,
}

#[derive(Debug, Serialize, Deserialize, Clone, Default)]
pub struct Designer {
    id: String,
    name: String,
    url: String,
}

#[derive(Debug, Serialize, Deserialize, Clone, Default)]
pub struct Manufacturer {
    id: String,
    name: String,
    url: String,
}

#[derive(Debug, Serialize, Deserialize, Clone, Default)]
pub struct SubFamily {
    id: String,
    name: String,
}

#[derive(Debug, Serialize, Deserialize, Clone, Default)]
pub struct Element {
    id: String,
    name: String,
}

#[derive(Debug, Serialize, Deserialize, Clone, Default)]
pub struct ElementUsage {
    element: Element,
    weight: u32,
    line_height: f32,
    size: f32,
}
