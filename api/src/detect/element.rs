use std::{
    cell::RefCell,
    fmt::{self, Debug},
    hash::Hasher,
    rc::Rc,
};

use atomic_refcell::{AtomicRef, AtomicRefMut};
use by_address::ByAddress;
use html5ever::tokenizer::states::State::TagName;
use markup5ever_rcdom::Node;
use selectors::{
    context::VisitedHandlingMode, matching::ElementSelectorFlags, sink::Push, Element,
    OpaqueElement,
};
use std::hash::Hash;
use style::{
    dom::{DomChildren, LayoutIterator, NodeInfo, TDocument, TElement, TNode, TShadowRoot},
    selector_parser::SelectorImpl,
    shared_lock::SharedRwLock,
};

use style_dom::ElementState;

use super::{layout_dom::LayoutDom, node::FWNode};

#[derive(Clone, Copy, Eq, PartialEq, Hash)]
pub struct FWElement<'dom> {
    pub element: LayoutDom<'dom, InnerFWElement<'dom>>,
}

impl<'dom> Element for FWElement<'dom> {
    type Impl = SelectorImpl;

    fn opaque(&self) -> selectors::OpaqueElement {
        todo!()
    }

    fn parent_element(&self) -> Option<Self> {
        todo!()
    }

    fn parent_node_is_shadow_root(&self) -> bool {
        todo!()
    }

    fn containing_shadow_host(&self) -> Option<Self> {
        todo!()
    }

    fn is_pseudo_element(&self) -> bool {
        todo!()
    }

    fn prev_sibling_element(&self) -> Option<Self> {
        todo!()
    }

    fn next_sibling_element(&self) -> Option<Self> {
        todo!()
    }

    fn first_element_child(&self) -> Option<Self> {
        todo!()
    }

    fn is_html_element_in_html_document(&self) -> bool {
        todo!()
    }

    fn has_local_name(
        &self,
        local_name: &<Self::Impl as selectors::SelectorImpl>::BorrowedLocalName,
    ) -> bool {
        todo!()
    }

    fn has_namespace(
        &self,
        ns: &<Self::Impl as selectors::SelectorImpl>::BorrowedNamespaceUrl,
    ) -> bool {
        todo!()
    }

    fn is_same_type(&self, other: &Self) -> bool {
        todo!()
    }

    fn attr_matches(
        &self,
        ns: &selectors::attr::NamespaceConstraint<
            &<Self::Impl as selectors::SelectorImpl>::NamespaceUrl,
        >,
        local_name: &<Self::Impl as selectors::SelectorImpl>::LocalName,
        operation: &selectors::attr::AttrSelectorOperation<
            &<Self::Impl as selectors::SelectorImpl>::AttrValue,
        >,
    ) -> bool {
        todo!()
    }

    fn match_non_ts_pseudo_class(
        &self,
        pc: &<Self::Impl as selectors::SelectorImpl>::NonTSPseudoClass,
        context: &mut selectors::context::MatchingContext<Self::Impl>,
    ) -> bool {
        todo!()
    }

    fn match_pseudo_element(
        &self,
        pe: &<Self::Impl as selectors::SelectorImpl>::PseudoElement,
        context: &mut selectors::context::MatchingContext<Self::Impl>,
    ) -> bool {
        todo!()
    }

    fn apply_selector_flags(&self, flags: selectors::matching::ElementSelectorFlags) {
        todo!()
    }

    fn is_link(&self) -> bool {
        todo!()
    }

    fn is_html_slot_element(&self) -> bool {
        todo!()
    }

    fn has_id(
        &self,
        id: &<Self::Impl as selectors::SelectorImpl>::Identifier,
        case_sensitivity: selectors::attr::CaseSensitivity,
    ) -> bool {
        todo!()
    }

    fn has_class(
        &self,
        name: &<Self::Impl as selectors::SelectorImpl>::Identifier,
        case_sensitivity: selectors::attr::CaseSensitivity,
    ) -> bool {
        todo!()
    }

    fn has_custom_state(&self, name: &<Self::Impl as selectors::SelectorImpl>::Identifier) -> bool {
        todo!()
    }

    fn imported_part(
        &self,
        name: &<Self::Impl as selectors::SelectorImpl>::Identifier,
    ) -> Option<<Self::Impl as selectors::SelectorImpl>::Identifier> {
        todo!()
    }

    fn is_part(&self, name: &<Self::Impl as selectors::SelectorImpl>::Identifier) -> bool {
        todo!()
    }

    fn is_empty(&self) -> bool {
        todo!()
    }

    fn is_root(&self) -> bool {
        todo!()
    }

    fn add_element_unique_hashes(&self, filter: &mut selectors::bloom::BloomFilter) -> bool {
        todo!()
    }
}
pub struct FWChildren<'dom> {
    children: DomChildren<FWNode<'dom>>,
}

impl<'dom> Iterator for FWChildren<'dom> {
    type Item = FWNode<'dom>;

    fn next(&mut self) -> Option<Self::Item> {
        self.children.next()
    }
}

impl<'dom> fmt::Debug for FWElement<'dom> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        // write!(f, "<{}", self.element.local_name())?;
        if let Some(id) = self.id() {
            write!(f, " id={}", id)?;
        }
        write!(f, "> ({:#x})", self.as_node().opaque().0)
    }
}

pub struct InnerFWElement<'dom> {
    pub node: &'dom Node,
}

impl<'dom> TElement for FWElement<'dom> {
    type ConcreteNode = FWNode<'dom>;
    type TraversalChildrenIterator = FWChildren<'dom>;

    fn unopaque(opaque: OpaqueElement) -> Self {
        unimplemented!()
    }

    fn as_node(&self) -> FWNode<'dom> {
        // self.node
        FWNode {
            node: LayoutDom {
                value: &self.element.value.node,
            },
        }
    }

    fn traversal_children(&self) -> LayoutIterator<Self::TraversalChildrenIterator> {
        unimplemented!()
    }

    fn is_html_element(&self) -> bool {
        unimplemented!()
    }

    fn is_mathml_element(&self) -> bool {
        unimplemented!()
    }

    fn is_svg_element(&self) -> bool {
        unimplemented!()
    }

    fn style_attribute(
        &self,
    ) -> Option<
        style::servo_arc::ArcBorrow<
            style::shared_lock::Locked<style::properties::PropertyDeclarationBlock>,
        >,
    > {
        unimplemented!()
    }

    fn animation_rule(
        &self,
        _: &style::context::SharedStyleContext,
    ) -> Option<
        style::servo_arc::Arc<
            style::shared_lock::Locked<style::properties::PropertyDeclarationBlock>,
        >,
    > {
        unimplemented!()
    }

    fn transition_rule(
        &self,
        context: &style::context::SharedStyleContext,
    ) -> Option<
        style::servo_arc::Arc<
            style::shared_lock::Locked<style::properties::PropertyDeclarationBlock>,
        >,
    > {
        unimplemented!()
    }

    fn state(&self) -> ElementState {
        unimplemented!()
    }

    fn has_part_attr(&self) -> bool {
        unimplemented!()
    }

    fn exports_any_part(&self) -> bool {
        unimplemented!()
    }

    fn id(&self) -> Option<&style::Atom> {
        unimplemented!()
    }

    fn each_class<F>(&self, callback: F)
    where
        F: FnMut(&style::values::AtomIdent),
    {
        unimplemented!()
    }

    fn each_custom_state<F>(&self, callback: F)
    where
        F: FnMut(&style::values::AtomIdent),
    {
        unimplemented!()
    }

    fn each_attr_name<F>(&self, callback: F)
    where
        F: FnMut(&style::LocalName),
    {
        unimplemented!()
    }

    fn has_dirty_descendants(&self) -> bool {
        unimplemented!()
    }

    fn has_snapshot(&self) -> bool {
        unimplemented!()
    }

    fn handled_snapshot(&self) -> bool {
        unimplemented!()
    }

    unsafe fn set_handled_snapshot(&self) {
        unimplemented!()
    }

    unsafe fn set_dirty_descendants(&self) {
        unimplemented!()
    }

    unsafe fn unset_dirty_descendants(&self) {
        unimplemented!()
    }

    fn store_children_to_process(&self, n: isize) {
        unimplemented!()
    }

    fn did_process_child(&self) -> isize {
        unimplemented!()
    }

    unsafe fn ensure_data(&self) -> AtomicRefMut<style::data::ElementData> {
        unimplemented!()
    }

    unsafe fn clear_data(&self) {
        unimplemented!()
    }

    fn has_data(&self) -> bool {
        unimplemented!()
    }

    fn borrow_data(&self) -> Option<AtomicRef<style::data::ElementData>> {
        unimplemented!()
    }

    fn mutate_data(&self) -> Option<AtomicRefMut<style::data::ElementData>> {
        unimplemented!()
    }

    fn skip_item_display_fixup(&self) -> bool {
        unimplemented!()
    }

    fn may_have_animations(&self) -> bool {
        unimplemented!()
    }

    fn has_animations(&self, context: &style::context::SharedStyleContext) -> bool {
        unimplemented!()
    }

    fn has_css_animations(
        &self,
        context: &style::context::SharedStyleContext,
        pseudo_element: Option<style::selector_parser::PseudoElement>,
    ) -> bool {
        unimplemented!()
    }

    fn has_css_transitions(
        &self,
        context: &style::context::SharedStyleContext,
        pseudo_element: Option<style::selector_parser::PseudoElement>,
    ) -> bool {
        unimplemented!()
    }

    fn shadow_root(&self) -> Option<<Self::ConcreteNode as TNode>::ConcreteShadowRoot> {
        unimplemented!()
    }

    fn containing_shadow(&self) -> Option<<Self::ConcreteNode as TNode>::ConcreteShadowRoot> {
        unimplemented!()
    }

    fn lang_attr(&self) -> Option<style::selector_parser::AttrValue> {
        unimplemented!()
    }

    fn match_element_lang(
        &self,
        override_lang: Option<Option<style::selector_parser::AttrValue>>,
        value: &style::selector_parser::Lang,
    ) -> bool {
        unimplemented!()
    }

    fn is_html_document_body_element(&self) -> bool {
        unimplemented!()
    }

    fn synthesize_presentational_hints_for_legacy_attributes<V>(
        &self,
        visited_handling: VisitedHandlingMode,
        hints: &mut V,
    ) where
        V: Push<style::applicable_declarations::ApplicableDeclarationBlock>,
    {
        unimplemented!()
    }

    fn local_name(
        &self,
    ) -> &<style::selector_parser::SelectorImpl as selectors::parser::SelectorImpl>::BorrowedLocalName
    {
        unimplemented!()
    }

    fn namespace(&self)
    -> &<style::selector_parser::SelectorImpl as selectors::parser::SelectorImpl>::BorrowedNamespaceUrl{
        unimplemented!()
    }

    fn query_container_size(
        &self,
        display: &style::values::computed::Display,
    ) -> euclid::default::Size2D<Option<app_units::Au>> {
        unimplemented!()
    }

    fn has_selector_flags(&self, flags: ElementSelectorFlags) -> bool {
        unimplemented!()
    }

    fn relative_selector_search_direction(&self) -> ElementSelectorFlags {
        unimplemented!()
    }
    // type TraversalChildrenIterator = ;

    // fn cle
}

#[derive(Debug, Clone, PartialEq, Copy, Hash, Eq)]
pub struct FWShadowRoot<'dom> {
    _phantom: std::marker::PhantomData<&'dom ()>,
}

impl<'dom> TShadowRoot for FWShadowRoot<'dom> {
    type ConcreteNode = FWNode<'dom>;

    fn as_node(&self) -> Self::ConcreteNode {
        todo!()
    }

    fn host(&self) -> <Self::ConcreteNode as TNode>::ConcreteElement {
        todo!()
    }

    fn style_data<'a>(&self) -> Option<&'a style::stylist::CascadeData>
    where
        Self: 'a,
    {
        todo!()
    }
}
