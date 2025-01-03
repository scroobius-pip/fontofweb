use markup5ever_rcdom::Node;
use style::{dom::TDocument, shared_lock::SharedRwLock};

use super::{layout_dom::LayoutDom, node::FWNode};

#[derive(Clone, Copy, Eq, Hash, PartialEq)]
pub struct FWDocument<'dom> {
    pub document: LayoutDom<'dom, InnerFWDocument>,
}

impl<'dom> TDocument for FWDocument<'dom> {
    type ConcreteNode = FWNode<'dom>;

    fn as_node(&self) -> Self::ConcreteNode {
        todo!()
    }

    fn is_html_document(&self) -> bool {
        todo!()
    }

    fn quirks_mode(&self) -> style::context::QuirksMode {
        todo!()
    }

    fn shared_lock(&self) -> &style::shared_lock::SharedRwLock {
        &self.document.value.style_shared_lock
    }
}

pub struct InnerFWDocument<'dom> {
    pub node: &'dom Node,
    pub style_shared_lock: SharedRwLock,
}
