use std::fmt;

use markup5ever_rcdom::Node;
use style::dom::{NodeInfo, TNode};

use super::{
    document::{FWDocument, InnerFWDocument},
    element::{FWElement, FWShadowRoot},
    layout_dom::LayoutDom,
};

#[derive(Clone, Copy, PartialEq)]
pub struct FWNode<'dom> {
    pub node: LayoutDom<'dom, Node>,
}

impl<'dom> fmt::Debug for FWNode<'dom> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        if let Some(el) = self.as_element() {
            el.fmt(f)
        } else if self.is_text_node() {
            write!(f, "<text node> ({:#x})", self.opaque().0)
        } else {
            write!(f, "<non-text node> ({:#x})", self.opaque().0)
        }
    }
}

impl<'dom> TNode for FWNode<'dom> {
    type ConcreteElement = FWElement<'dom>;

    type ConcreteDocument = FWDocument<'dom>;

    type ConcreteShadowRoot = FWShadowRoot<'dom>;

    fn parent_node(&self) -> Option<Self> {
        unimplemented!()
    }

    fn first_child(&self) -> Option<Self> {
        unimplemented!()
    }

    fn last_child(&self) -> Option<Self> {
        unimplemented!()
    }

    fn prev_sibling(&self) -> Option<Self> {
        unimplemented!()
    }

    fn next_sibling(&self) -> Option<Self> {
        unimplemented!()
    }

    fn owner_doc(&self) -> Self::ConcreteDocument {
        unimplemented!()
    }

    fn is_in_document(&self) -> bool {
        unimplemented!()
    }

    fn traversal_parent(&self) -> Option<Self::ConcreteElement> {
        unimplemented!()
    }

    fn opaque(&self) -> style::dom::OpaqueNode {
        unimplemented!()
    }

    fn debug_id(self) -> usize {
        unimplemented!()
    }

    fn as_element(&self) -> Option<Self::ConcreteElement> {
        unimplemented!()
    }

    fn as_document(&self) -> Option<Self::ConcreteDocument> {
        None
    }

    fn as_shadow_root(&self) -> Option<Self::ConcreteShadowRoot> {
        unimplemented!()
    }
}

impl<'dom> NodeInfo for FWNode<'dom> {
    fn is_element(&self) -> bool {
        // self.node.is_element_for_layout()
        unimplemented!()
    }

    fn is_text_node(&self) -> bool {
        // self.script_type_id()
        //     == NodeTypeId::CharacterData(CharacterDataTypeId::Text(TextTypeId::Text))
        unimplemented!()
    }
}
