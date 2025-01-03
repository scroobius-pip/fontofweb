use std::borrow::{Borrow, BorrowMut};
use std::collections::VecDeque;
use std::sync::LazyLock;
mod element;
mod layout_dom;
mod node;
mod stylesheet;
use document::{FWDocument, InnerFWDocument};
use layout_dom::LayoutDom;
use node::FWNode;
use stylesheet::{get_ua_stylesheets, UA_STYLESHEETS};
mod document;
mod servo_test;
use element::{FWElement, InnerFWElement};
use html5ever::parse_document;
use html5ever::tendril::TendrilSink;
use markup5ever_rcdom::{Handle, Node, NodeData, RcDom};
use style::context::{QuirksMode, SharedStyleContext};
use style::context::{RegisteredSpeculativePainters, StyleContext};
use style::dom::{NodeInfo, TDocument, TElement, TNode};
use style::driver;
use style::media_queries::{Device, MediaType};
use style::parallel::style_trees;
use style::properties::style_structs::Font;
use style::properties::ComputedValues;
use style::queries::values::PrefersColorScheme;
use style::selector_parser::SnapshotMap;
use style::servo::media_queries::FontMetricsProvider;
use style::servo_arc::Arc;
use style::shared_lock::{SharedRwLock, StylesheetGuards};
use style::stylesheets::UserAgentStylesheets;
use style::stylist::Stylist;
use style::traversal::PreTraverseToken;
use style::traversal::{recalc_style_at, DomTraversal, PerLevelTraversalData};
use style::traversal_flags::TraversalFlags;
use style::values::computed::font::GenericFontFamily;
use style::values::computed::{FontSize, Length, NonNegativeLength};
use style::values::specified::font::KeywordInfo;

pub fn main() {
    let html = r#"
                <html>
                    <head>
                        <style>
                            body { font-size: 16px; }
                            .large { font-size: 20px; }
                            #special { font-size: calc(2em + 10px); }
                        </style>
                    </head>
                    <body>
                        <div class="large">Large text</div>
                        <div id="special">Special text</div>
                    </body>
                </html>
            "#;

    let dom = parse_document(RcDom::default(), Default::default())
        .from_utf8()
        .read_from(&mut html.as_bytes())
        .unwrap();

    let parent_elem = FWElement {
        element: LayoutDom {
            value: &InnerFWElement {
                node: dom.document.as_ref(),
            },
        },
    };

    let mut font = Font::initial_values();

    let default_font_size = 16;

    font.font_size = FontSize {
        computed_size: NonNegativeLength::new(default_font_size as f32),
        used_size: NonNegativeLength::new(default_font_size as f32),
        keyword_info: KeywordInfo::medium(),
    };

    let device = Device::new(
        MediaType::screen(),
        QuirksMode::NoQuirks,
        Default::default(),
        Default::default(),
        Box::new(LayoutFontMetricsProvider),
        ComputedValues::initial_values_with_font_override(font),
        // TODO: obtain preferred color scheme from embedder
        PrefersColorScheme::Light,
    );

    let stylist = Stylist::new(device, QuirksMode::NoQuirks);

    let document_shared_lock = document.shared_lock();
    let document = FWDocument {
        document: LayoutDom {
            value: &InnerFWDocument {
                node: dom.document.as_ref(),
                style_shared_lock: document_shared_lock,
            },
        },
    };

    let sharing_context = SharedStyleContext {
        stylist: &stylist,
        visited_styles_enabled: false,
        options: Default::default(),
        guards: StylesheetGuards {
            author: &document_shared_lock.read(),
            ua_or_user: &UA_STYLESHEETS.shared_lock.read(),
        },
        current_time_for_animations: Default::default(),
        traversal_flags: TraversalFlags::AnimationOnly,
        snapshot_map: &SnapshotMap::new(),
        animations: Default::default(),
        registered_speculative_painters: &Painters,
    };

    let traversal = Walk {
        style_context: &sharing_context,
    };

    let token = Walk::pre_traverse(parent_elem, &sharing_context);
    _ = driver::traverse_dom::<FWElement, Walk>(&traversal, token, None);
}

struct Painters;
impl RegisteredSpeculativePainters for Painters {
    fn get(&self, name: &style::Atom) -> Option<&dyn style::context::RegisteredSpeculativePainter> {
        None
    }
}

struct Walk<'dom> {
    style_context: &'dom SharedStyleContext<'dom>,
}

impl<'dom> DomTraversal<FWElement<'dom>> for Walk<'dom> {
    fn process_preorder<'a, F>(
        &self,
        traversal_data: &PerLevelTraversalData,
        context: &mut StyleContext<'a, FWElement<'dom>>,
        node: FWNode<'dom>,
        note_child: F,
    ) where
        F: FnMut(FWNode<'dom>),
    {
        if !node.is_text_node() {
            let el = node.as_element().unwrap();
            let mut data = el.mutate_data().unwrap();
            recalc_style_at(self, traversal_data, context, el, &mut data, note_child);

            let font_size = data
                .styles
                .get_primary()
                .unwrap()
                .clone_font_size()
                .computed_size()
                .px();
        }
    }

    fn process_postorder(&self, context: &mut StyleContext<FWElement>, node: FWNode) {
        panic!("NONONO")
    }

    fn shared_context(&self) -> &SharedStyleContext {
        &self.style_context
    }
}

#[derive(Debug)]
struct LayoutFontMetricsProvider;

impl FontMetricsProvider for LayoutFontMetricsProvider {
    fn query_font_metrics(
        &self,
        vertical: bool,
        font: &style::properties::style_structs::Font,
        base_size: style::values::computed::CSSPixelLength,
        in_media_query: bool,
        retrieve_math_scales: bool,
    ) -> style::font_metrics::FontMetrics {
        Default::default()
    }

    fn base_size_for_generic(
        &self,
        generic: style::values::computed::font::GenericFontFamily,
    ) -> style::values::computed::Length {
        Length::new(match generic {
            GenericFontFamily::Monospace => 16,
            _ => 16,
        } as f32)
        .max(Length::new(0.0))
    }
}

// #[cfg(test)]
// mod test {
//     use super::*;

//     #[test]
//     fn test() {
//         main();
//     }
// }

// static UA_STYLESHEETS: LazyLock<UserAgentStylesheets> =
//     // LazyLock::new(|| Document);
