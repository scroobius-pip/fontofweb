use std::{process, sync::LazyLock};

use reqwest::Url;
use style::{
    context::QuirksMode,
    media_queries::MediaList,
    servo_arc::Arc,
    shared_lock::SharedRwLock,
    stylesheets::{DocumentStyleSheet, Origin, Stylesheet, UserAgentStylesheets},
};

pub fn get_ua_stylesheets() -> Result<UserAgentStylesheets, &'static str> {
    fn parse_ua_stylesheet(
        shared_lock: &SharedRwLock,
        filename: &str,
        content: &[u8],
    ) -> Result<DocumentStyleSheet, &'static str> {
        let url = Url::parse(&format!("chrome://resources/{:?}", filename))
            .ok()
            .unwrap();
        Ok(DocumentStyleSheet(Arc::new(Stylesheet::from_bytes(
            content,
            url.into(),
            None,
            None,
            Origin::UserAgent,
            MediaList::empty(),
            shared_lock.clone(),
            None,
            None,
            QuirksMode::NoQuirks,
        ))))
    }

    let shared_lock = &SharedRwLock::new();

    let user_agent_sheet = parse_ua_stylesheet(
        shared_lock,
        "user-agent.css",
        include_bytes!("user-agent.css"),
    )?;

    Ok(UserAgentStylesheets {
        shared_lock: shared_lock.clone(),
        user_or_user_agent_stylesheets: vec![user_agent_sheet.clone()],
        quirks_mode_stylesheet: user_agent_sheet,
    })
}

pub static UA_STYLESHEETS: LazyLock<UserAgentStylesheets> =
    LazyLock::new(|| match get_ua_stylesheets() {
        Ok(stylesheets) => stylesheets,
        Err(filename) => {
            panic!("shouldn't happen")
        }
    });
